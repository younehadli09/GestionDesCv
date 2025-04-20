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
def add_cv():
    """
    Endpoint to add a CV
    Accepts JSON, converts to XML, validates against XSD, and stores in DB
    """
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
        xml_data = json_to_xml(json_data)

        # Validate XML
        is_valid, error_message = validate_xml_with_xsd(xml_data, xsd_path)
        if not is_valid:
            return jsonify({
                "error": "Invalid XML",
                "details": error_message,
                "xml": xml_data.decode('utf-8')
            }), 400

        # Store in database
        xml_string = xml_data.decode("UTF-8")
        new_cv = CV(xml_data=xml_string)
        db.session.add(new_cv)
        db.session.commit()

        return jsonify({
            "message": "CV added successfully",
            "cv_id": new_cv.id,
            "xml": xml_string
        }), 201

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