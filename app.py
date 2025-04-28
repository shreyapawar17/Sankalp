from flask import Flask, render_template, request, redirect, url_for, jsonify, session, g
import mysql.connector
import bcrypt
import secrets
import os
import requests
import logging
import math

logging.basicConfig(level=logging.INFO)  # Configure logging

app = Flask(__name__)
app.secret_key = secrets.token_hex(32)


# Replace with your preferred geocoding API and API key
GEOCODING_API_URL = "https://api.opencagedata.com/geocode/v1/json"
GEOCODING_API_KEY = os.environ.get('f57f1e8672d546038a9703151c474d9d') # Store your API key securely

def get_geocode(location_name):
    """Retrieves latitude and longitude for a given location name using a geocoding service."""
    if not GEOCODING_API_KEY:
        logging.warning("OPENCAGE_API_KEY not set. Geocoding will not work.")
        return None, None

    params = {
        'q': location_name,
        'key': GEOCODING_API_KEY,
        'limit': 1
    }
    try:
        response = requests.get(GEOCODING_API_URL, params=params)
        response.raise_for_status()  # Raise an exception for bad status codes
        data = response.json()
        if data and data.get('results') and len(data['results']) > 0:
            latitude = data['results'][0]['geometry']['lat']
            longitude = data['results'][0]['geometry']['lng']
            logging.info(f"Geocoded '{location_name}' to ({latitude}, {longitude})")
            return latitude, longitude
        else:
            logging.info(f"No results found for '{location_name}' by OpenCage: {data}")
            return None, None
    except requests.exceptions.RequestException as e:
        logging.error(f"Geocoding API request failed for '{location_name}': {e}")
        return None, None
    except Exception as e:
        logging.error(f"An unexpected error occurred during geocoding of '{location_name}': {e}")
        return None, None

def haversine(lat1, lon1, lat2, lon2):
    R = 6371  # Radius of the Earth in kilometers
    lat1_rad = math.radians(lat1)
    lon1_rad = math.radians(lon1)
    lat2_rad = math.radians(lat2)
    lon2_rad = math.radians(lon2)
    dlon = lon2_rad - lon1_rad
    dlat = lat2_rad - lat1_rad
    a = math.sin(dlat / 2)**2 + math.cos(lat1_rad) * math.cos(lat2_rad) * math.sin(dlon / 2)**2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    distance = R * c
    return distance

@app.route('/geocode', methods=['POST'])
def geocode():
    """Handles AJAX request to get coordinates for a location."""
    data = request.get_json()
    if not data or 'location' not in data:
        return jsonify({'error': 'Location not provided'}), 400

    location = data['location']
    latitude, longitude = get_geocode(location)
    if latitude is not None and longitude is not None:
        return jsonify({'latitude': latitude, 'longitude': longitude})
    else:
        return jsonify({'error': f'Could not geocode the location: {location}'}), 404

@app.route('/disaster/add', methods=['GET', 'POST'])
def add_disaster():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    if request.method == 'POST':
        name = request.form['disaster_name']
        dtype = request.form['disaster_type']
        location = request.form['location']
        latitude = request.form['latitude']
        longitude = request.form['longitude']
        start_date = request.form['start_date']
        description = request.form['description']

        db = get_db()
        cursor = db.cursor()
        insert_query = """
        INSERT INTO Disasters (disaster_name, disaster_type, location, latitude, longitude, start_date, description)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        """
        try:
            cursor.execute(insert_query, (name, dtype, location, latitude, longitude, start_date, description))
            db.commit()
        except mysql.connector.Error as err:
            print(f"Error adding disaster: {err}")
        finally:
            cursor.close()
            db.close()
        return redirect(url_for('dashboard'))
    return render_template('add_disaster.html')
def get_db():
    db = mysql.connector.connect(
        host="localhost",
        user="root",
        password="123456",
        database="disaster_management_db"
    )
    return db

@app.route('/')
def index():
    return render_template('landing.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password'].encode('utf-8') # Encode for bcrypt

        db = get_db()
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT employee_id, password FROM Employees WHERE username = %s", (username,))
        user = cursor.fetchone()
        cursor.close()
        db.close()

        if user and bcrypt.checkpw(password, user['password'].encode('utf-8')):
            session['user_id'] = user['employee_id']
            return redirect(url_for('dashboard'))
        else:
            return render_template('login.html', error='Invalid credentials')
    return render_template('login.html')

@app.route('/dashboard', methods=['GET'])
def dashboard():
    if 'user_id' not in session:
        return redirect(url_for('login'))

    db = get_db()
    cursor = db.cursor(dictionary=True)
    search_query = request.args.get('search_query')

    if search_query:
        # Construct your SQL query to search across relevant fields
        query = """
        SELECT disaster_id, disaster_name, disaster_type, location, start_date
        FROM Disasters
        WHERE disaster_name LIKE %s OR disaster_type LIKE %s OR location LIKE %s
        """
        search_term = f"%{search_query}%"
        cursor.execute(query, (search_term, search_term, search_term))
        disasters = cursor.fetchall()
    else:
        # If no search query, fetch all current disasters
        cursor.execute("SELECT disaster_id, disaster_name, disaster_type, location, start_date FROM Disasters")
        disasters = cursor.fetchall()

    cursor.close()
    db.close()
    return render_template('dashboard.html', disasters=disasters)


@app.route('/disaster/remove/<int:disaster_id>')
def remove_disaster(disaster_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    db = get_db()
    cursor = db.cursor()
    try:
        cursor.execute("DELETE FROM Disasters WHERE disaster_id = %s", (disaster_id,))
        db.commit()
        logging.info(f"Disaster ID {disaster_id} removed.")
    except mysql.connector.Error as err:
        logging.error(f"Error removing disaster {disaster_id}: {err}")
        # Consider adding a flash message to inform the user about the error
    finally:
        cursor.close()
        db.close()
    return redirect(url_for('dashboard'))

@app.route('/disaster/manage/<int:disaster_id>')
def manage_disaster(disaster_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT disaster_id, disaster_name FROM Disasters WHERE disaster_id = %s", (disaster_id,))
    disaster = cursor.fetchone()
    cursor.close()
    db.close()
    if disaster:
        return render_template('manage_disaster.html', disaster=disaster)
    else:
        # Handle the case where the disaster ID is not found
        return redirect(url_for('dashboard')) # Or display an error message

@app.route('/disaster/<int:disaster_id>/updates', methods=['GET'])
def manage_updates(disaster_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM DisasterUpdates WHERE disaster_id = %s ORDER BY update_timestamp DESC", (disaster_id,))
    updates = cursor.fetchall()
    cursor.close()
    db.close()
    return render_template('manage_updates.html', disaster_id=disaster_id, updates=updates)

@app.route('/disaster/<int:disaster_id>/updates/add', methods=['POST'])
def add_update(disaster_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    total_affected = request.form.get('total_affected', 0)
    dead = request.form.get('dead', 0)
    injured = request.form.get('injured', 0)
    homeless = request.form.get('homeless', 0)
    livelihood_lost = request.form.get('livelihood_lost', 0)

    db = get_db()
    cursor = db.cursor()
    insert_query = """
    INSERT INTO DisasterUpdates (disaster_id, total_affected, dead, injured, homeless, livelihood_lost)
    VALUES (%s, %s, %s, %s, %s, %s)
    """
    try:
        cursor.execute(insert_query, (disaster_id, total_affected, dead, injured, homeless, livelihood_lost))
        db.commit()
        logging.info(f"Added new update for disaster ID {disaster_id}")
    except mysql.connector.Error as err:
        logging.error(f"Error adding update for disaster ID {disaster_id}: {err}")
        # Consider adding a flash message to inform the user about the error
    finally:
        cursor.close()
        db.close()
    return redirect(url_for('manage_updates', disaster_id=disaster_id))

@app.route('/disaster/<int:disaster_id>/shelters/allocate/<int:shelter_id>', methods=['POST'])
def allocate_shelter(disaster_id, shelter_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    db = get_db()
    cursor = db.cursor()
    update_query = """
    UPDATE Shelters SET disaster_id = %s
    WHERE shelter_id = %s AND (disaster_id IS NULL OR disaster_id = 0)
    """
    try:
        cursor.execute(update_query, (disaster_id, shelter_id))
        db.commit()
        logging.info(f"Allocated shelter ID {shelter_id} to disaster ID {disaster_id}")
    except mysql.connector.Error as err:
        logging.error(f"Error allocating shelter ID {shelter_id}: {err}")
        # Consider adding a flash message
    finally:
        cursor.close()
        db.close()
    return redirect(url_for('manage_shelters', disaster_id=disaster_id))

@app.route('/disaster/<int:disaster_id>/shelters', methods=['GET'])
def manage_shelters(disaster_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    db = get_db()
    cursor = db.cursor(dictionary=True)

    # Fetch the current disaster to get its location
    cursor.execute("SELECT disaster_id, disaster_name, latitude, longitude FROM Disasters WHERE disaster_id = %s", (disaster_id,))
    disaster = cursor.fetchone()

    allocated_shelters = []
    unallocated_nearby_shelters = []

    if disaster:
        # Fetch shelters allocated to the current disaster
        cursor.execute("SELECT * FROM Shelters WHERE disaster_id = %s", (disaster_id,))
        allocated_shelters = cursor.fetchall()

        # Fetch all unallocated shelters
        cursor.execute("SELECT * FROM Shelters WHERE disaster_id IS NULL OR disaster_id = 0")
        unallocated_shelters = cursor.fetchall()

        proximity_threshold = 50  # Kilometers (adjust as needed)

        # Filter unallocated shelters based on proximity to the disaster
        if disaster['latitude'] is not None and disaster['longitude'] is not None:
            for shelter in unallocated_shelters:
                if shelter['latitude'] is not None and shelter['longitude'] is not None:
                    distance = haversine(
                        disaster['latitude'], disaster['longitude'],
                        shelter['latitude'], shelter['longitude']
                    )
                    if distance <= proximity_threshold:
                        shelter['distance_to_disaster'] = f"{distance:.2f} km"
                        unallocated_nearby_shelters.append(shelter)
                    else:
                        shelter['distance_to_disaster'] = f"{distance:.2f} km" # Optionally show all with distance
                        # You might choose not to display these at all if you strictly want "nearby"

    cursor.close()
    db.close()
    return render_template('manage_shelters.html',
                           disaster_id=disaster_id,
                           disaster=disaster,
                           allocated_shelters=allocated_shelters,
                           unallocated_shelters=unallocated_nearby_shelters) # Pass the filtered list


@app.route('/disaster/<int:disaster_id>/shelters/add', methods=['POST'])
def add_shelter(disaster_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    name = request.form['shelter_name']
    shelter_type = request.form['shelter_type']
    capacity = request.form.get('capacity', 0)
    location = request.form['location']
    latitude = request.form.get('latitude')
    longitude = request.form.get('longitude')
    contact_person = request.form.get('contact_person')
    contact_number = request.form.get('contact_number')

    db = get_db()
    cursor = db.cursor()
    insert_query = """
    INSERT INTO Shelters (disaster_id, shelter_name, shelter_type, capacity, location, latitude, longitude, contact_person, contact_number)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
    """
    try:
        cursor.execute(insert_query, (disaster_id, name, shelter_type, capacity, location, latitude, longitude, contact_person, contact_number))
        db.commit()
        logging.info(f"Added new shelter '{name}' for disaster ID {disaster_id}")
    except mysql.connector.Error as err:
        logging.error(f"Error adding shelter for disaster ID {disaster_id}: {err}")
        # Consider adding a flash message
    finally:
        cursor.close()
        db.close()
    return redirect(url_for('manage_shelters', disaster_id=disaster_id))

@app.route('/disaster/<int:disaster_id>/shelter/<int:shelter_id>/delete', methods=['POST'])
def delete_shelter(disaster_id, shelter_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    db = get_db()
    cursor = db.cursor()
    try:
        cursor.execute("UPDATE Shelters SET disaster_id = NULL WHERE shelter_id = %s AND disaster_id = %s", (shelter_id, disaster_id))
        db.commit()
        logging.info(f"Deallocated shelter ID {shelter_id} from disaster ID {disaster_id}")
        # Optionally, you could completely delete the shelter record if it's no longer needed
        # cursor.execute("DELETE FROM Shelters WHERE shelter_id = %s", (shelter_id,))
        # db.commit()
        # logging.info(f"Deleted shelter ID {shelter_id}")
    except mysql.connector.Error as err:
        logging.error(f"Error deallocating/deleting shelter ID {shelter_id}: {err}")
        # Consider adding a flash message
    finally:
        cursor.close()
        db.close()
    return redirect(url_for('manage_shelters', disaster_id=disaster_id))

@app.route('/disaster/<int:disaster_id>/shelter/<int:shelter_id>/edit', methods=['GET', 'POST'])
def edit_shelter(disaster_id, shelter_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    db = get_db()
    cursor = db.cursor(dictionary=True)
    shelter = None

    if request.method == 'GET':
        # Fetch the shelter data for editing
        cursor.execute("SELECT * FROM Shelters WHERE shelter_id = %s AND disaster_id = %s", (shelter_id, disaster_id))
        shelter = cursor.fetchone()
        cursor.close()
        db.close()
        if shelter:
            return render_template('edit_shelter.html', disaster_id=disaster_id, shelter=shelter)
        else:
            return "Shelter not found", 404
    elif request.method == 'POST':
        name = request.form['shelter_name']
        shelter_type = request.form['shelter_type']
        capacity = request.form.get('capacity', 0)
        location = request.form['location']
        latitude = request.form.get('latitude')
        longitude = request.form.get('longitude')
        contact_person = request.form.get('contact_person')
        contact_number = request.form.get('contact_number')

        update_query = """
        UPDATE Shelters
        SET shelter_name = %s, shelter_type = %s, capacity = %s,
            location = %s, latitude = %s, longitude = %s,
            contact_person = %s, contact_number = %s
        WHERE shelter_id = %s AND disaster_id = %s
        """
        try:
            cursor.execute(update_query, (name, shelter_type, capacity, location, latitude, longitude, contact_person, contact_number, shelter_id, disaster_id))
            db.commit()
            logging.info(f"Updated shelter ID {shelter_id} for disaster ID {disaster_id}")
        except mysql.connector.Error as err:
            logging.error(f"Error updating shelter ID {shelter_id}: {err}")
            # Consider adding a flash message
        finally:
            cursor.close()
            db.close()
        return redirect(url_for('manage_shelters', disaster_id=disaster_id))

    return "Method not allowed", 405

@app.route('/disaster/<int:disaster_id>/volunteers', methods=['GET'])
def manage_volunteers(disaster_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    db = get_db()
    cursor = db.cursor(dictionary=True)

    # Fetch the current disaster's information
    cursor.execute("SELECT disaster_id, disaster_name, latitude, longitude FROM Disasters WHERE disaster_id = %s", (disaster_id,))
    disaster = cursor.fetchone()

    nearby_active_unassigned_volunteers = []
    appointed_volunteers = []
    proximity_threshold = 50  # Kilometers (adjust as needed)

    if disaster:
        # Fetch all volunteers
        cursor.execute("SELECT volunteer_id, first_name, last_name, contact_number, volunteer_type, is_active, latitude, longitude FROM volunteers")
        all_volunteers = cursor.fetchall()

        # Fetch IDs of volunteers appointed to this disaster
        cursor.execute("SELECT volunteer_id FROM disastervolunteers WHERE disaster_id = %s", (disaster_id,))
        appointed_volunteer_ids = {row['volunteer_id'] for row in cursor.fetchall()}

        # Filter nearby active and unassigned volunteers
        for volunteer in all_volunteers:
            if volunteer['is_active'] and volunteer['latitude'] is not None and volunteer['longitude'] is not None and disaster['latitude'] is not None and disaster['longitude'] is not None:
                distance = haversine(disaster['latitude'], disaster['longitude'], float(volunteer['latitude']), float(volunteer['longitude']))
                volunteer['distance'] = f"{distance:.2f} km"
                if distance <= proximity_threshold and volunteer['volunteer_id'] not in appointed_volunteer_ids:
                    nearby_active_unassigned_volunteers.append(volunteer)

            # Identify currently appointed volunteers
            if volunteer['volunteer_id'] in appointed_volunteer_ids:
                appointed_volunteers.append(volunteer)

    cursor.close()
    db.close()
    return render_template('manage_volunteers.html',
                           disaster_id=disaster_id,
                           disaster=disaster,
                           nearby_active_unassigned_volunteers=nearby_active_unassigned_volunteers,
                           appointed_volunteers=appointed_volunteers)
@app.route('/disaster/<int:disaster_id>/volunteers/assign/<int:volunteer_id>', methods=['POST'])
def assign_volunteer(disaster_id, volunteer_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    db = get_db()
    cursor = db.cursor()
    insert_query = """
    INSERT INTO disastervolunteers (disaster_id, volunteer_id)
    VALUES (%s, %s)
    """
    try:
        cursor.execute(insert_query, (disaster_id, volunteer_id))
        db.commit()
        logging.info(f"Assigned volunteer ID {volunteer_id} to disaster ID {disaster_id}")
        # Optionally update volunteer's is_active status upon assignment
        cursor.execute("UPDATE volunteers SET is_active = 1 WHERE volunteer_id = %s", (volunteer_id,))
        db.commit()
    except mysql.connector.Error as err:
        logging.error(f"Error assigning volunteer {volunteer_id} to disaster {disaster_id}: {err}")
        # Consider adding a flash message
    finally:
        cursor.close()
        db.close()
    return redirect(url_for('manage_volunteers', disaster_id=disaster_id))

@app.route('/disaster/<int:disaster_id>/volunteers/unassign/<int:volunteer_id>', methods=['POST'])
def unassign_volunteer(disaster_id, volunteer_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    db = get_db()
    cursor = db.cursor()
    delete_query = """
    DELETE FROM disastervolunteers
    WHERE disaster_id = %s AND volunteer_id = %s
    """
    try:
        cursor.execute(delete_query, (disaster_id, volunteer_id))
        db.commit()
        logging.info(f"Unassigned volunteer ID {volunteer_id} from disaster ID {disaster_id}")
        # Optionally update volunteer's is_active status upon unassignment
        # cursor.execute("UPDATE volunteers SET is_active = 0 WHERE volunteer_id = %s", (volunteer_id,))
        # db.commit()
    except mysql.connector.Error as err:
        logging.error(f"Error unassigning volunteer {volunteer_id} from disaster {disaster_id}: {err}")
        # Consider adding a flash message
    finally:
        cursor.close()
        db.close()
    return redirect(url_for('manage_volunteers', disaster_id=disaster_id))
@app.route('/disaster/<int:disaster_id>/resources', methods=['GET'])
def manage_resources(disaster_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    db = get_db()
    cursor = db.cursor(dictionary=True)

    # Fetch the current disaster's information
    cursor.execute("SELECT disaster_id, disaster_name FROM Disasters WHERE disaster_id = %s", (disaster_id,))
    disaster = cursor.fetchone()

    if not disaster:
        cursor.close()
        db.close()
        return "Disaster not found", 404

    # Fetch all available resource types
    cursor.execute("SELECT resource_id, resource_name, resource_type, unit FROM resources")
    all_resources = cursor.fetchall()

    # Fetch current resource needs for this disaster
    cursor.execute("""
        SELECT dr.resource_id, r.resource_name, r.resource_type, dr.quantity_needed
        FROM disasterresources dr
        JOIN resources r ON dr.resource_id = r.resource_id
        WHERE dr.disaster_id = %s
    """, (disaster_id,))
    disaster_resource_needs = {row['resource_id']: row for row in cursor.fetchall()}

    cursor.close()
    db.close()
    return render_template('manage_resources.html',
                           disaster=disaster,
                           disaster_id=disaster_id,
                           all_resources=all_resources,
                           disaster_resource_needs=disaster_resource_needs)

@app.route('/disaster/<int:disaster_id>/resources/add', methods=['POST'])
def add_resource_to_disaster(disaster_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    db = get_db()
    cursor = db.cursor()
    resource_id = request.form.get('resource_id')
    quantity_needed = int(request.form.get('quantity', 0))

    try:
        # Check if the resource is already associated with the disaster
        cursor.execute("""
            SELECT * FROM disasterresources
            WHERE disaster_id = %s AND resource_id = %s
        """, (disaster_id, resource_id))
        existing_resource = cursor.fetchone()

        if existing_resource:
            # Update existing resource's needed quantity
            cursor.execute("""
                UPDATE disasterresources
                SET quantity_needed = quantity_needed + %s
                WHERE disaster_id = %s AND resource_id = %s
            """, (quantity_needed, disaster_id, resource_id))
            logging.info(f"Added {quantity_needed} to resource ID {resource_id} for disaster ID {disaster_id}")
        else:
            # Add new resource for the disaster
            cursor.execute("""
                INSERT INTO disasterresources (disaster_id, resource_id, quantity_needed)
                VALUES (%s, %s, %s)
            """, (disaster_id, resource_id, quantity_needed))
            logging.info(f"Added resource ID {resource_id} with quantity {quantity_needed} to disaster ID {disaster_id}")

        db.commit()
    except mysql.connector.Error as err:
        logging.error(f"Error adding resource for disaster {disaster_id}: {err}")
        # Consider adding a flash message
    finally:
        cursor.close()
        db.close()
    return redirect(url_for('manage_resources', disaster_id=disaster_id))

@app.route('/disaster/<int:disaster_id>/resources/remove/<int:resource_id>', methods=['POST'])
def remove_resource_from_disaster(disaster_id, resource_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    db = get_db()
    cursor = db.cursor()
    try:
        cursor.execute("""
            DELETE FROM disasterresources
            WHERE disaster_id = %s AND resource_id = %s
        """, (disaster_id, resource_id))
        db.commit()
        logging.info(f"Removed resource ID {resource_id} from disaster ID {disaster_id}")
        # Consider adding a flash message
    except mysql.connector.Error as err:
        logging.error(f"Error removing resource {resource_id} from disaster {disaster_id}: {err}")
        # Consider adding a flash message
    finally:
        cursor.close()
        db.close()
    return redirect(url_for('manage_resources', disaster_id=disaster_id))
if __name__ == '__main__':
    app.run(debug=True)