from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from lxml import etree
import os
import uuid
from flask import make_response
app = Flask(__name__)
CORS(app)

# Database configuration
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:matiic@localhost:5432/recruitment'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# CV Model
class CV(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    xml_data = db.Column(db.Text, nullable=False)

def generate_unique_id():
    """Generate unique ID by checking existing CVs in XML"""
    existing_record = CV.query.first()
    if not existing_record:
        return 1
        
    root = etree.fromstring(existing_record.xml_data.encode('utf-8'))
    if root.tag != "cv_list":
        return 1
        
    # Get highest existing ID in XML
    existing_ids = [int(cv.get('id')) for cv in root.xpath('//cv') if cv.get('id').isdigit()]
    return max(existing_ids) + 1 if existing_ids else 1


def validate_xml_with_xsd(xml_data, xsd_path):
    """
    Validate XML against XSD schema
    """
    try:
        xsd_doc = etree.parse(xsd_path)
        xsd_schema = etree.XMLSchema(xsd_doc)
        xml_doc = etree.fromstring(xml_data)
        xsd_schema.assertValid(xml_doc)
        return True, None
    except etree.DocumentInvalid as e:
        return False, str(e)
    except Exception as e:
        return False, str(e)

def json_to_xml(json_data, root_element="cv"):
    root = etree.Element(root_element)

    def build_xml_element(parent, data):
        if isinstance(data, dict):
            # Handle attributes (keys starting with _ except _id)
            attrs = {k[1:]: v for k, v in data.items() 
                    if k.startswith('_') and k != '_id' and k != '__text'}
            
            if '__text' in data:
                parent.text = str(data['__text'])
            
            # Handle child elements
            for key, value in data.items():
                if not key.startswith('_'):
                    if isinstance(value, dict):
                        sub_elem = etree.SubElement(parent, key)
                        build_xml_element(sub_elem, value)
                    elif isinstance(value, list):
                        for item in value:
                            sub_elem = etree.SubElement(parent, key)
                            build_xml_element(sub_elem, item)
                    else:
                        sub_elem = etree.SubElement(parent, key)
                        sub_elem.text = str(value)
            
            # Set attributes (excluding _id)
            for attr, value in attrs.items():
                parent.set(attr, str(value))
                
            # Special handling for experience elements
            if parent.tag == "experience" and "id" not in parent.attrib:
                parent.set("id", str(uuid.uuid4().hex))  # Generate a unique ID
                
        elif isinstance(data, list):
            for item in data:
                build_xml_element(parent, item)
        else:
            parent.text = str(data)

    build_xml_element(root, json_data)

    # Always generate a new ID (remove any existing 'id' attribute)
    if "id" in root.attrib:
        del root.attrib["id"]
    root.set("id", str(generate_unique_id()))

    return etree.tostring(root, pretty_print=True, encoding="UTF-8", xml_declaration=True)


@app.route('/add_cv', methods=['POST'])
def add_cv_combined():
    try:
        # Chemin vers le fichier XSD
        xsd_path = os.path.join(os.path.dirname(__file__), 'cv.xsd')
        if not os.path.exists(xsd_path):
            return jsonify({"error": "Fichier XSD introuvable"}), 500

        # Récupérer les données JSON
        json_data = request.get_json()
        if not json_data:
            return jsonify({"error": "Aucune donnée JSON fournie"}), 400

        # Convertir JSON en XML
        new_cv_xml = json_to_xml(json_data, root_element="cv")

        # Valider le nouveau CV avec le schéma XSD
        is_valid, error_message = validate_xml_with_xsd(new_cv_xml, xsd_path)
        if not is_valid:
            return jsonify({
                "error": "XML invalide",
                "details": error_message,
                "xml": new_cv_xml.decode('utf-8')
            }), 400

        # Vérifier si un fichier XML existe déjà dans la base de données
        existing_record = CV.query.first()
        if existing_record:
            # Charger le XML existant et vérifier la structure
            root = etree.fromstring(existing_record.xml_data.encode('utf-8'))
            if root.tag != "cv_list":
                return jsonify({"error": "Le fichier XML existant n'a pas une balise racine valide <cv_list>"}), 500

            # Ajouter le nouveau CV
            new_cv_element = etree.fromstring(new_cv_xml)
            root.append(new_cv_element)
            combined_xml = etree.tostring(root, pretty_print=True, encoding="UTF-8", xml_declaration=True)
            existing_record.xml_data = combined_xml.decode("utf-8")
        else:
            # Créer une nouvelle balise racine <cv_list> et ajouter le CV
            root = etree.Element("cv_list")
            new_cv_element = etree.fromstring(new_cv_xml)
            root.append(new_cv_element)
            combined_xml = etree.tostring(root, pretty_print=True, encoding="UTF-8", xml_declaration=True)

            # Enregistrer le nouveau XML dans la base de données
            new_cv = CV(xml_data=combined_xml.decode("utf-8"))
            db.session.add(new_cv)

        # Sauvegarder dans la base de données
        db.session.commit()

        return jsonify({
            "message": "CV ajouté avec succès",
            "xml": combined_xml.decode("utf-8")
        }), 201

    except etree.XMLSyntaxError as e:
        return jsonify({"error": "Erreur de syntaxe XML", "details": str(e)}), 400
    except Exception as e:
        return jsonify({
            "error": "Une erreur est survenue",
            "details": str(e)
        }), 500




@app.route('/delete_element', methods=['DELETE'])  # Removed cv_id from URL
def delete_element():
    try:
        # Get all required data from request body
        data = request.get_json()
        if not data:
            return jsonify({"error": "Request body is required"}), 400

        xpath_query = data.get('xpath_query')
        if not xpath_query:
            return jsonify({"error": "XPath query is required"}), 400

        # Get all CVs from database
        cvs = CV.query.all()
        if not cvs:
            return jsonify({"error": "No CVs found in database"}), 404

        deleted_count = 0
        affected_cvs = []

        for cv in cvs:
            try:
                root = etree.fromstring(cv.xml_data.encode('utf-8'))
                elements = root.xpath(xpath_query)
                
                if elements:
                    modified = False
                    for element in elements:
                        parent = element.getparent()
                        if parent is not None:
                            parent.remove(element)
                            modified = True
                            deleted_count += 1
                    
                    if modified:
                        updated_xml = etree.tostring(root, pretty_print=True, 
                                                   encoding="UTF-8", 
                                                   xml_declaration=True).decode('utf-8')
                        cv.xml_data = updated_xml
                        affected_cvs.append(cv.id)

            except Exception as e:
                # Log error but continue with other CVs
                app.logger.error(f"Error processing CV {cv.id}: {str(e)}")
                continue

        if deleted_count == 0:
            return jsonify({
                "message": "No elements matched the XPath query",
                "query": xpath_query
            }), 200

        db.session.commit()

        return jsonify({
            "message": "Elements deleted successfully",
            "total_deleted": deleted_count,
            "affected_cvs": affected_cvs,
            "xpath_query": xpath_query
        }), 200

    except etree.XPathSyntaxError as e:
        return jsonify({"error": "Invalid XPath query", "details": str(e)}), 400
    except Exception as e:
        db.session.rollback()
        return jsonify({
            "error": "An error occurred during deletion",
            "details": str(e)
        }), 500

@app.route('/search', methods=['POST'])
def search_cv():
    """
    Improved search endpoint with proper XPath handling
    """
    try:
        if not request.is_json:
            return jsonify({"error": "Request must be JSON"}), 400
            
        data = request.get_json()
        xpath_query = data.get('xpath_query')
        
        if not xpath_query or not isinstance(xpath_query, str):
            return jsonify({"error": "Valid XPath query string is required"}), 400

        cvs = CV.query.all()
        if not cvs:
            return jsonify({"message": "No CVs found in database"}), 200

        results = []
        for cv in cvs:
            try:
                parser = etree.XMLParser(recover=True)
                root = etree.fromstring(cv.xml_data.encode('utf-8'), parser=parser)
                matches = root.xpath(xpath_query)
                
                if matches:
                    cv_results = []
                    for match in matches:
                        result = {
                            "match": etree.tostring(match, encoding='unicode').strip() if isinstance(match, etree._Element) else str(match),
                            "match_type": type(match).__name__
                        }
                        
                        # Add parent info for elements
                        if isinstance(match, etree._Element):
                            parent = match.getparent()
                            result["parent"] = etree.tostring(parent, encoding='unicode').strip() if parent else None
                            
                        cv_results.append(result)
                    
                    results.append({
                        "cv_id": cv.id,
                        "matches": cv_results,
                        "total_matches": len(matches)
                    })
                    
            except etree.XMLSyntaxError as e:
                results.append({
                    "cv_id": cv.id,
                    "error": f"XML parsing error: {str(e)}"
                })
                continue

        return jsonify({
            "message": "Search completed",
            "query": xpath_query,
            "results": results,
            "total_cvs_searched": len(cvs),
            "cvs_with_matches": len([r for r in results if 'matches' in r])
        }), 200

    except Exception as e:
        app.logger.error(f"Search error: {str(e)}")
        return jsonify({
            "error": "Search failed",
            "details": str(e)
        }), 500

@app.route('/get_cv/<int:cv_id>', methods=['GET'])
def get_cv(cv_id):
    try:
        cv = CV.query.get_or_404(1)
        
        # Load the XSLT stylesheet
        xslt_path = os.path.join(os.path.dirname(__file__), 'cv.xslt')
        xslt = etree.parse(xslt_path)
        transform = etree.XSLT(xslt)
        
        # Parse the XML data (the entire cv_list)
        xml_data = etree.fromstring(cv.xml_data.encode('utf-8'))
        
        # Find the specific CV by ID using XPath
        specific_cv = xml_data.xpath(f'//cv[@id="{cv_id}"]')[0]
        print(specific_cv)
        # Apply the transformation to just this CV
        html_result = transform(specific_cv)
        
        # Return as HTML
        response = make_response(str(html_result))
        response.headers['Content-Type'] = 'text/html'
        return response
        
    except Exception as e:
        return jsonify({
            "error": "An error occurred",
            "details": str(e)
        }), 500

@app.route('/all_cvs', methods=['GET'])
def all_cvs():
    try:
        # Get the CV record containing all CVs
        cv_record = CV.query.first()
        if not cv_record:
            return "No CVs found in database", 404

        # Load the list XSLT
        xslt_path = os.path.join(os.path.dirname(__file__), 'cv_list.xslt')
        xslt = etree.parse(xslt_path)
        transform = etree.XSLT(xslt)
        
        # Parse the XML data
        xml_data = etree.fromstring(cv_record.xml_data.encode('utf-8'))
        
        # Apply transformation
        html_result = transform(xml_data)
        
        # Return as HTML
        response = make_response(str(html_result))
        response.headers['Content-Type'] = 'text/html'
        return response
        
    except Exception as e:
        return jsonify({
            "error": "An error occurred",
            "details": str(e)
        }), 500

@app.route('/view_cv/<int:cv_id>', methods=['GET'])
def view_cv(cv_id):
    try:
        # Get the CV record containing all CVs
        cv_record = CV.query.first()
        if not cv_record:
            return "No CVs found in database", 404

        # Load the detail XSLT
        xslt_path = os.path.join(os.path.dirname(__file__), 'cv.xslt')
        xslt = etree.parse(xslt_path)
        transform = etree.XSLT(xslt)
        
        # Parse the XML data
        xml_data = etree.fromstring(cv_record.xml_data.encode('utf-8'))
        
        # Find the specific CV
        specific_cv = xml_data.xpath(f'//cv[@id="{cv_id}"]')
        if not specific_cv:
            return "CV not found", 404
            
        # Apply transformation
        html_result = transform(specific_cv[0])
        
        # Add back button with proper Python string formatting
        back_button = """
        <div style="text-align:center;margin:20px;">
            <a href="/dashboard" style="padding:10px;background:#3498db;color:white;text-decoration:none;border-radius:5px;">
                Back to List
            </a>
        </div>
        </body>
        """
        html_str = str(html_result).replace('</body>', back_button)
        
        # Return as HTML
        response = make_response(html_str)
        response.headers['Content-Type'] = 'text/html'
        return response
        
    except Exception as e:
        return jsonify({
            "error": "An error occurred",
            "details": str(e)
        }), 500
if __name__ == '__main__':
    # Create database tables
    with app.app_context():
        db.create_all()

    # Run the application on network interface
    app.run(host='0.0.0.0', port=5000, debug=True)