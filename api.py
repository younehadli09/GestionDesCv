from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from lxml import etree
import os

app = Flask(__name__)

# Database configuration
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:matiic@localhost:5432/recruitment'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# CV Model
class CV(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    xml_data = db.Column(db.Text, nullable=False)

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
    """
    Convert JSON to XML with support for attributes and mixed content
    """
    root = etree.Element(root_element)

    def build_xml_element(parent, data):
        if isinstance(data, dict):
            # Handle attributes (keys starting with _)
            attrs = {k[1:]: v for k, v in data.items() 
                    if k.startswith('_') and k != '__text'}
            
            # Handle mixed content (text node with attributes)
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
            
            # Set attributes
            for attr, value in attrs.items():
                parent.set(attr, str(value))
                
        elif isinstance(data, list):
            for item in data:
                build_xml_element(parent, item)
        else:
            parent.text = str(data)

    build_xml_element(root, json_data)

    return etree.tostring(root, pretty_print=True, encoding="UTF-8", xml_declaration=True)

@app.route('/add_cv', methods=['POST'])
def add_cv_combined():
    try:
        # Load XSD schema
        xsd_path = os.path.join(os.path.dirname(__file__), 'cv.xsd')
        if not os.path.exists(xsd_path):
            return jsonify({"error": "XSD file not found"}), 500

        # Get JSON data
        json_data = request.get_json()
        if not json_data:
            return jsonify({"error": "No JSON data provided"}), 400

        # Convert JSON to XML
        new_cv_xml = json_to_xml(json_data)

        # Validate new CV XML
        is_valid, error_message = validate_xml_with_xsd(new_cv_xml, xsd_path)
        if not is_valid:
            return jsonify({
                "error": "Invalid XML",
                "details": error_message,
                "xml": new_cv_xml.decode('utf-8')
            }), 400

        # Check if a combined XML already exists
        existing_record = CV.query.first()
        if existing_record:
            # Parse the existing XML and append the new CV
            root = etree.fromstring(existing_record.xml_data.encode('utf-8'))
            new_cv_element = etree.fromstring(new_cv_xml)
            root.append(new_cv_element)
            combined_xml = etree.tostring(root, pretty_print=True, encoding="UTF-8", xml_declaration=True)
            existing_record.xml_data = combined_xml.decode("utf-8")
        else:
            # No existing XML, create a new one
            combined_xml = new_cv_xml
            new_cv = CV(xml_data=combined_xml.decode("utf-8"))
            db.session.add(new_cv)

        db.session.commit()

        return jsonify({
            "message": "CV added successfully",
            "xml": combined_xml.decode("utf-8")
        }), 201

    except Exception as e:
        return jsonify({
            "error": "An error occurred",
            "details": str(e)
        }), 500

@app.route('/search_cv', methods=['POST'])
def search_cv():
    """
    Endpoint to search in CVs using XPath query
    """
    try:
        # Get the XPath query from the request
        data = request.get_json()
        xpath_query = data.get('xpath_query')
        if not xpath_query:
            return jsonify({"error": "No XPath query provided"}), 400

        # Retrieve all CVs from the database
        cvs = CV.query.all()
        if not cvs:
            return jsonify({"error": "No CVs found in the database"}), 404

        # Perform XPath search on each CV
        results = []
        for cv in cvs:
            root = etree.fromstring(cv.xml_data.encode('utf-8'))  # Ensure UTF-8 bytes input
            matches = root.xpath(xpath_query)
            if matches:
                # Collect the results
                match_results = [
                    etree.tostring(match, pretty_print=True, encoding="unicode")
                    if isinstance(match, etree._Element)
                    else str(match)
                    for match in matches
                ]
                results.append({
                    "cv_id": cv.id,
                    "matches": match_results
                })

        if not results:
            return jsonify({"message": "No matches found for the given XPath query"}), 200

        return jsonify({
            "message": "Matches found",
            "results": results
        }), 200

    except etree.XPathSyntaxError as e:
        return jsonify({"error": "Invalid XPath query", "details": str(e)}), 400
    except Exception as e:
        return jsonify({
            "error": "An error occurred",
            "details": str(e)
        }), 500


@app.route('/get_cv/<int:cv_id>', methods=['GET'])
def get_cv(cv_id):
    """
    Endpoint to retrieve a CV by ID
    """
    try:
        cv = CV.query.get_or_404(cv_id)
        return jsonify({
            "id": cv.id,
            "xml_data": cv.xml_data
        }), 200
    except Exception as e:
        return jsonify({
            "error": "An error occurred",
            "details": str(e)
        }), 500

if __name__ == '__main__':
    # Create database tables
    with app.app_context():
        db.create_all()
    
    # Run the application
    app.run(debug=True)