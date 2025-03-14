import sqlite3
import csv
import os
import re

# Database setup
def setup_database(db_path):
    """Create SQLite database and tables"""
    if os.path.exists(db_path):
        os.remove(db_path)
    
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    # Create tables for node types
    cursor.execute('''
    CREATE TABLE Person (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        age INTEGER,
        blog_address TEXT
    )
    ''')
    
    cursor.execute('''
    CREATE TABLE Place (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        code TEXT,
        type TEXT NOT NULL,
        coordinates TEXT,
        parent_id INTEGER,
        region_type TEXT,
        FOREIGN KEY (parent_id) REFERENCES Place(id)
    )
    ''')
    
    cursor.execute('''
    CREATE TABLE PlaceToSleep (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        website TEXT,
        city TEXT,
        street TEXT,
        housenumber TEXT,
        lon REAL,
        lat REAL,
        city_id INTEGER,
        FOREIGN KEY (city_id) REFERENCES Place(id)
    )
    ''')
    
    cursor.execute('''
    CREATE TABLE Sustenance (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        website TEXT,
        cuisine TEXT,
        city TEXT,
        street TEXT,
        housenumber TEXT,
        lon REAL,
        lat REAL,
        city_id INTEGER,
        FOREIGN KEY (city_id) REFERENCES Place(id)
    )
    ''')
    
    cursor.execute('''
    CREATE TABLE Trip (
        id INTEGER PRIMARY KEY,
        name TEXT,
        duration INTEGER,
        year_season TEXT,
        type TEXT
    )
    ''')
    
    # Create tables for relationships
    cursor.execute('''
    CREATE TABLE PersonLivesIn (
        id INTEGER PRIMARY KEY,
        person_id INTEGER,
        place_id INTEGER,
        FOREIGN KEY (person_id) REFERENCES Person(id),
        FOREIGN KEY (place_id) REFERENCES Place(id)
    )
    ''')
    
    cursor.execute('''
    CREATE TABLE PersonWentFor (
        id INTEGER PRIMARY KEY,
        person_id INTEGER,
        trip_id INTEGER,
        FOREIGN KEY (person_id) REFERENCES Person(id),
        FOREIGN KEY (trip_id) REFERENCES Trip(id)
    )
    ''')
    
    cursor.execute('''
    CREATE TABLE TripTo (
        id INTEGER PRIMARY KEY,
        trip_id INTEGER,
        place_id INTEGER,
        transportation TEXT,
        FOREIGN KEY (trip_id) REFERENCES Trip(id),
        FOREIGN KEY (place_id) REFERENCES Place(id)
    )
    ''')
    
    cursor.execute('''
    CREATE TABLE TripStartsFrom (
        id INTEGER PRIMARY KEY,
        trip_id INTEGER,
        place_id INTEGER,
        FOREIGN KEY (trip_id) REFERENCES Trip(id),
        FOREIGN KEY (place_id) REFERENCES Place(id)
    )
    ''')
    
    cursor.execute('''
    CREATE TABLE TripIsPartOf (
        id INTEGER PRIMARY KEY,
        child_trip_id INTEGER,
        parent_trip_id INTEGER,
        order_no INTEGER,
        FOREIGN KEY (child_trip_id) REFERENCES Trip(id),
        FOREIGN KEY (parent_trip_id) REFERENCES Trip(id)
    )
    ''')
    
    cursor.execute('''
    CREATE TABLE TripStayedAt (
        id INTEGER PRIMARY KEY,
        trip_id INTEGER,
        place_to_sleep_id INTEGER,
        rate INTEGER,
        avg_price_per_night REAL,
        FOREIGN KEY (trip_id) REFERENCES Trip(id),
        FOREIGN KEY (place_to_sleep_id) REFERENCES PlaceToSleep(id)
    )
    ''')
    
    cursor.execute('''
    CREATE TABLE TripWentTo (
        id INTEGER PRIMARY KEY,
        trip_id INTEGER,
        sustenance_id INTEGER,
        rate INTEGER,
        avg_money_spent REAL,
        FOREIGN KEY (trip_id) REFERENCES Trip(id),
        FOREIGN KEY (sustenance_id) REFERENCES Sustenance(id)
    )
    ''')
    
    cursor.execute('''
    CREATE TABLE SustenanceLocatedIn (
        id INTEGER PRIMARY KEY,
        sustenance_id INTEGER,
        place_id INTEGER,
        FOREIGN KEY (sustenance_id) REFERENCES Sustenance(id),
        FOREIGN KEY (place_id) REFERENCES Place(id)
    )
    ''')
    
    conn.commit()
    return conn

def load_csv_data(conn, base_path):
    cursor = conn.cursor()
    
    # Load countries
    with open(os.path.join(base_path, 'countries.csv'), 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            cursor.execute(
                "INSERT INTO Place (name, code, type) VALUES (?, ?, ?)",
                (row['CountryName'], row['CountryCode'], 'Country')
            )
    
    # Load regions
    with open(os.path.join(base_path, 'subdiv.csv'), 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            # Get parent country ID
            cursor.execute(
                "SELECT id FROM Place WHERE code = ? AND type = 'Country'", 
                (row['CountryCode'],)
            )
            country_id = cursor.fetchone()[0]
            
            cursor.execute(
                "INSERT INTO Place (name, code, type, parent_id, region_type) VALUES (?, ?, ?, ?, ?)",
                (row['RegionName'], row['RegionCode'], 'Region', country_id, row['RegionType'])
            )
    
    # Load cities
    with open(os.path.join(base_path, 'cities.csv'), 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            # Try to get parent region ID first
            cursor.execute(
                "SELECT id FROM Place WHERE code = ? AND type = 'Region'", 
                (row['RegionCode'],)
            )
            region_result = cursor.fetchone()
            region_id = region_result[0] if region_result else None
            
            # Get country ID
            cursor.execute(
                "SELECT id FROM Place WHERE code = ? AND type = 'Country'", 
                (row['CountryCode'],)
            )
            country_id = cursor.fetchone()[0]
            
            # If region exists, set parent as region, otherwise country
            parent_id = region_id if region_id else country_id
            
            cursor.execute(
                "INSERT INTO Place (name, code, type, coordinates, parent_id) VALUES (?, ?, ?, ?, ?)",
                (row['CityNameNoSpecialChars'], row['CityCode'], 'City', row['Coordinates'], parent_id)
            )
    
    # Load restaurants in Warsaw
    with open(os.path.join(base_path, 'restaurantsWarsaw.csv'), 'r') as f:
        reader = csv.DictReader(f)
        
        # Get Warsaw city ID
        cursor.execute("SELECT id FROM Place WHERE name = ? AND type = 'City'", ('Warszawa',))
        warsaw_id = cursor.fetchone()[0]
        
        for row in reader:
            cursor.execute(
                "INSERT INTO Sustenance (name, lon, lat, cuisine, city, street, housenumber, website, city_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                (row['name'], float(row['lon']), float(row['lat']), row['cuisine'], row['addr_city'], row['addr_street'], row['addr_housenumber'], row['website'], warsaw_id)
            )
            
            # Also create the IS_LOCATED_IN relationship
            cursor.execute("SELECT last_insert_rowid()")
            sustenance_id = cursor.fetchone()[0]
            
            cursor.execute(
                "INSERT INTO SustenanceLocatedIn (sustenance_id, place_id) VALUES (?, ?)",
                (sustenance_id, warsaw_id)
            )
    
    # Load hotels in Warsaw
    with open(os.path.join(base_path, 'hotelsWarsaw.csv'), 'r') as f:
        reader = csv.DictReader(f)
        
        # Get Warsaw city ID
        cursor.execute("SELECT id FROM Place WHERE name = ? AND type = 'City'", ('Warszawa',))
        warsaw_id = cursor.fetchone()[0]
        
        for row in reader:
            cursor.execute(
                "INSERT INTO PlaceToSleep (name, lon, lat, city, street, housenumber, website, city_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
                (row['name'], float(row['lon']), float(row['lat']), row['addr_city'], row['addr_street'], row['addr_housenumber'], row['website'], warsaw_id)
            )
    
    conn.commit()

def extract_people_data(conn, people_cypher_path):
    cursor = conn.cursor()
    
    with open(people_cypher_path, 'r') as f:
        cypher_content = f.read()
    
    # Extract person data
    person_pattern = re.compile(r'\((\w+):Person\{name:\'([\w\s]+)\', age:(\d+), blog_address:\'([\w\s]+)\'\}\)')
    person_matches = person_pattern.findall(cypher_content)
    
    person_ids = {}  # To store person names and their IDs
    
    for var_name, name, age, blog_address in person_matches:
        cursor.execute(
            "INSERT INTO Person (name, age, blog_address) VALUES (?, ?, ?)",
            (name, int(age), blog_address)
        )
        cursor.execute("SELECT last_insert_rowid()")
        person_id = cursor.fetchone()[0]
        person_ids[var_name] = person_id
    
    # Extract trips
    trip_pattern = re.compile(r'\((\w+):Trip\{(.*?)\}\)')
    trip_matches = trip_pattern.findall(cypher_content)
    
    trip_ids = {}  # To store trip variable names and their IDs
    
    for var_name, props_str in trip_matches:
        props = {}
        
        # Parse properties
        if props_str:
            for prop in props_str.split(','):
                if ':' in prop:
                    key, value = prop.strip().split(':', 1)
                    # Remove quotes if present
                    value = value.strip("'")
                    props[key.strip()] = value
        
        name = props.get('name', None)
        duration = props.get('duration', None)
        if duration and duration != '0':
            try:
                duration = int(duration)
            except ValueError:
                duration = None
        year_season = props.get('year_season', None)
        trip_type = props.get('type', None)
        
        cursor.execute(
            "INSERT INTO Trip (name, duration, year_season, type) VALUES (?, ?, ?, ?)",
            (name, duration, year_season, trip_type)
        )
        
        cursor.execute("SELECT last_insert_rowid()")
        trip_id = cursor.fetchone()[0]
        trip_ids[var_name] = trip_id
    
    # Extract WENT_FOR relationships
    went_for_pattern = re.compile(r'\((\w+)\)-\[:WENT_FOR\]->\((\w+)\)')
    went_for_matches = went_for_pattern.findall(cypher_content)
    
    for person_var, trip_var in went_for_matches:
        if person_var in person_ids and trip_var in trip_ids:
            cursor.execute(
                "INSERT INTO PersonWentFor (person_id, trip_id) VALUES (?, ?)",
                (person_ids[person_var], trip_ids[trip_var])
            )
    
    # Extract LIVES_IN relationships
    lives_in_pattern = re.compile(r'\((\w+)\)-\[:LIVES_IN\]->\((\w+)\)')
    lives_in_matches = lives_in_pattern.findall(cypher_content)
    
    for person_var, city_var in lives_in_matches:
        if person_var in person_ids:
            # Get the city ID
            city_name_pattern = re.compile(rf'\({city_var}:City\{{name:\'([\w\s]+)\'\}}')
            city_name_match = city_name_pattern.search(cypher_content)
            
            if city_name_match:
                city_name = city_name_match.group(1)
                cursor.execute("SELECT id FROM Place WHERE name = ? AND type = 'City'", (city_name,))
                city_result = cursor.fetchone()
                
                if city_result:
                    cursor.execute(
                        "INSERT INTO PersonLivesIn (person_id, place_id) VALUES (?, ?)",
                        (person_ids[person_var], city_result[0])
                    )
            else:
                # Try by code
                city_code_pattern = re.compile(rf'\({city_var}:City\{{code:\'([\w\-]+)\'\}}')
                city_code_match = city_code_pattern.search(cypher_content)
                
                if city_code_match:
                    city_code = city_code_match.group(1)
                    cursor.execute("SELECT id FROM Place WHERE code = ? AND type = 'City'", (city_code,))
                    city_result = cursor.fetchone()
                    
                    if city_result:
                        cursor.execute(
                            "INSERT INTO PersonLivesIn (person_id, place_id) VALUES (?, ?)",
                            (person_ids[person_var], city_result[0])
                        )
    
    # Extract TO relationships
    to_pattern = re.compile(r'\((\w+)\)-\[:TO\{transportation:\'([\w\s]+)\'\}\]->\((\w+)\)')
    to_matches = to_pattern.findall(cypher_content)
    
    for trip_var, transportation, city_var in to_matches:
        if trip_var in trip_ids:
            # Get the city ID
            cursor.execute("SELECT name FROM Place WHERE type = 'City'")
            all_cities = [row[0] for row in cursor.fetchall()]
            
            # Find the city in the Cypher content
            city_match = None
            for city_name in all_cities:
                # Escape special characters in city name
                escaped_city_name = re.escape(city_name)
                city_pattern = re.compile(rf'\({city_var}:City\{{name:\'({escaped_city_name})\'\}}')
                city_match = city_pattern.search(cypher_content)
                if city_match:
                    cursor.execute("SELECT id FROM Place WHERE name = ? AND type = 'City'", (city_name,))
                    city_id = cursor.fetchone()[0]
                    
                    cursor.execute(
                        "INSERT INTO TripTo (trip_id, place_id, transportation) VALUES (?, ?, ?)",
                        (trip_ids[trip_var], city_id, transportation)
                    )
                    break
            
            if not city_match:
                # Try by code
                cursor.execute("SELECT code FROM Place WHERE type = 'City'")
                all_city_codes = [row[0] for row in cursor.fetchall()]
                
                for city_code in all_city_codes:
                    city_code_pattern = re.compile(rf'\({city_var}:City\{{code:\'({city_code})\'\}}')
                    city_code_match = city_code_pattern.search(cypher_content)
                    if city_code_match:
                        cursor.execute("SELECT id FROM Place WHERE code = ? AND type = 'City'", (city_code,))
                        city_id = cursor.fetchone()[0]
                        
                        cursor.execute(
                            "INSERT INTO TripTo (trip_id, place_id, transportation) VALUES (?, ?, ?)",
                            (trip_ids[trip_var], city_id, transportation)
                        )
                        break
    
    # Extract STARTS_FROM relationships
    starts_from_pattern = re.compile(r'\((\w+)\)-\[:STARTS_FROM\]->\((\w+)\)')
    starts_from_matches = starts_from_pattern.findall(cypher_content)
    
    for trip_var, city_var in starts_from_matches:
        if trip_var in trip_ids:
            # Get the city name from the variable
            cursor.execute("SELECT name FROM Place WHERE type = 'City'")
            all_cities = [row[0] for row in cursor.fetchall()]
            
            # Find the city in the Cypher content
            city_match = None
            for city_name in all_cities:
                # Escape special characters in city name
                escaped_city_name = re.escape(city_name)
                city_pattern = re.compile(rf'\({city_var}:City\{{name:\'({escaped_city_name})\'\}}')
                city_match = city_pattern.search(cypher_content)
                if city_match:
                    cursor.execute("SELECT id FROM Place WHERE name = ? AND type = 'City'", (city_name,))
                    city_id = cursor.fetchone()[0]
                    
                    cursor.execute(
                        "INSERT INTO TripStartsFrom (trip_id, place_id) VALUES (?, ?)",
                        (trip_ids[trip_var], city_id)
                    )
                    break
            
            if not city_match:
                # Try by code
                cursor.execute("SELECT code FROM Place WHERE type = 'City'")
                all_city_codes = [row[0] for row in cursor.fetchall()]
                
                for city_code in all_city_codes:
                    city_code_pattern = re.compile(rf'\({city_var}:City\{{code:\'({city_code})\'\}}')
                    city_code_match = city_code_pattern.search(cypher_content)
                    if city_code_match:
                        cursor.execute("SELECT id FROM Place WHERE code = ? AND type = 'City'", (city_code,))
                        city_id = cursor.fetchone()[0]
                        
                        cursor.execute(
                            "INSERT INTO TripStartsFrom (trip_id, place_id) VALUES (?, ?)",
                            (trip_ids[trip_var], city_id)
                        )
                        break
    
    # Extract IS_PART_OF relationships
    is_part_of_pattern = re.compile(r'\((\w+)\)-\[:IS_PART_OF\{order_no:(\d+)\}\]->\((\w+)\)')
    is_part_of_matches = is_part_of_pattern.findall(cypher_content)
    
    for child_trip_var, order_no, parent_trip_var in is_part_of_matches:
        if child_trip_var in trip_ids and parent_trip_var in trip_ids:
            cursor.execute(
                "INSERT INTO TripIsPartOf (child_trip_id, parent_trip_id, order_no) VALUES (?, ?, ?)",
                (trip_ids[child_trip_var], trip_ids[parent_trip_var], int(order_no))
            )
    
    # Extract STAYED_AT relationships
    stayed_at_pattern = re.compile(r'\((\w+)\)-\[:STAYED_AT\{rate:(\d+), avg_price_per_night:(\d+)\}\]->\((\w+)\)')
    stayed_at_matches = stayed_at_pattern.findall(cypher_content)
    
    for trip_var, rate, avg_price, hotel_var in stayed_at_matches:
        if trip_var in trip_ids:
            # Get hotel name from variable
            hotel_name_pattern = re.compile(rf'\({hotel_var}:PlaceToSleep\{{name:\'([\w\s\d]+)\'\}}')
            hotel_match = hotel_name_pattern.search(cypher_content)
            
            if hotel_match:
                hotel_name = hotel_match.group(1)
                cursor.execute("SELECT id FROM PlaceToSleep WHERE name = ?", (hotel_name,))
                hotel_result = cursor.fetchone()
                
                if hotel_result:
                    cursor.execute(
                        "INSERT INTO TripStayedAt (trip_id, place_to_sleep_id, rate, avg_price_per_night) VALUES (?, ?, ?, ?)",
                        (trip_ids[trip_var], hotel_result[0], int(rate), float(avg_price))
                    )
    
    # Extract WENT_TO relationships
    went_to_pattern = re.compile(r'\((\w+)\)-\[:WENT_TO\{rate:(\d+), avg_money_spent:(\d+)\}\]->\((\w+)\)')
    went_to_matches = went_to_pattern.findall(cypher_content)
    
    for trip_var, rate, avg_money_spent, sustenance_var in went_to_matches:
        if trip_var in trip_ids:
            # Get sustenance name from variable
            sustenance_name_pattern = re.compile(rf'\({sustenance_var}:Sustenance\{{name:\'([\w\s\d]+)\'\}}')
            sustenance_match = sustenance_name_pattern.search(cypher_content)
            
            if sustenance_match:
                sustenance_name = sustenance_match.group(1)
                cursor.execute("SELECT id FROM Sustenance WHERE name = ?", (sustenance_name,))
                sustenance_result = cursor.fetchone()
                
                if sustenance_result:
                    cursor.execute(
                        "INSERT INTO TripWentTo (trip_id, sustenance_id, rate, avg_money_spent) VALUES (?, ?, ?, ?)",
                        (trip_ids[trip_var], sustenance_result[0], int(rate), float(avg_money_spent))
                    )
    
    conn.commit()

def create_indexes(conn):
    """Create useful indexes for better query performance"""
    cursor = conn.cursor()
    
    # Create indexes on frequently queried columns
    cursor.execute("CREATE INDEX idx_place_name_type ON Place(name, type)")
    cursor.execute("CREATE INDEX idx_place_code_type ON Place(code, type)")
    cursor.execute("CREATE INDEX idx_person_name ON Person(name)")
    cursor.execute("CREATE INDEX idx_trip_name ON Trip(name)")
    cursor.execute("CREATE INDEX idx_trip_type ON Trip(type)")
    
    conn.commit()

def main():
    base_path = "/home/stefan/Documents/Schule/5/DBI/abschluss"
    db_path = os.path.join(base_path, "travel_db.sqlite")
    
    # Initialize database
    conn = setup_database(db_path)
    
    try:
        # Load data from CSV files
        load_csv_data(conn, base_path)
        
        # Process people and trips from Cypher file
        extract_people_data(conn, os.path.join(base_path, 'people.cypher'))
        
        # Create indexes for better performance
        create_indexes(conn)
        
        print(f"Migration completed successfully. Database saved at {db_path}")
    except Exception as e:
        print(f"Error during migration: {str(e)}")
    finally:
        conn.close()

if __name__ == "__main__":
    main()
