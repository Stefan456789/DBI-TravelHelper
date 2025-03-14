import os
import re
import csv
import sqlite3
import logging
from pathlib import Path

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Define the path to the database and CSV files
BASE_DIR = Path('/home/stefan/Documents/Schule/5/DBI/abschluss')
DB_PATH = BASE_DIR / 'travel_data.db'
CSV_FILES = {
    'countries': BASE_DIR / 'countries.csv',
    'cities': BASE_DIR / 'cities.csv',
    'subdiv': BASE_DIR / 'subdiv.csv',
    'restaurants': BASE_DIR / 'restaurantsWarsaw.csv',
    'hotels': BASE_DIR / 'hotelsWarsaw.csv'
}
CYPHER_FILES = {
    'create': BASE_DIR / 'create.cypher',
    'people': BASE_DIR / 'people.cypher'
}

def read_csv_file(file_path):
    """Read a CSV file and return a list of dictionaries."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            # Skip comment lines that start with "//"
            lines = []
            for line in f:
                if not line.strip().startswith('//'):
                    lines.append(line)
            
            # Create CSV reader from filtered lines
            reader = csv.DictReader(lines)
            return list(reader)
    except Exception as e:
        logger.error(f"Error reading CSV file {file_path}: {e}")
        return []

def create_database():
    """Create SQLite database and tables."""
    try:
        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()
        
        # Create place_type table
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS place_type (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type_name TEXT NOT NULL
        )
        ''')
        
        # Insert place types
        place_types = ['Country', 'Region', 'City']
        cursor.executemany(
            "INSERT INTO place_type (type_name) VALUES (?)",
            [(ptype,) for ptype in place_types]
        )
        
        # Create place table
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS place (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            code TEXT,
            latitude REAL,
            longitude REAL,
            place_type_id INTEGER,
            parent_id INTEGER,
            FOREIGN KEY (place_type_id) REFERENCES place_type(id),
            FOREIGN KEY (parent_id) REFERENCES place(id)
        )
        ''')
        
        # Modify existing tables
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS restaurants (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            longitude REAL,
            latitude REAL,
            cuisine TEXT,
            street TEXT,
            house_number TEXT,
            website TEXT,
            place_id INTEGER,
            FOREIGN KEY (place_id) REFERENCES place(id)
        )
        ''')
        
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS hotels (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            longitude REAL,
            latitude REAL,
            street TEXT,
            house_number TEXT,
            website TEXT,
            place_id INTEGER,
            FOREIGN KEY (place_id) REFERENCES place(id)
        )
        ''')
        
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS people (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            age INTEGER,
            blog_address TEXT,
            home_place_id INTEGER,
            FOREIGN KEY (home_place_id) REFERENCES place(id)
        )
        ''')
        
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS trips (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            duration INTEGER,
            year_season TEXT,
            type TEXT,
            person_id INTEGER,
            FOREIGN KEY (person_id) REFERENCES people(id)
        )
        ''')
        
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS trip_segments (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            duration INTEGER,
            order_no INTEGER,
            main_trip_id INTEGER,
            from_place_id INTEGER,
            to_place_id INTEGER,
            transportation TEXT,
            FOREIGN KEY (main_trip_id) REFERENCES trips(id),
            FOREIGN KEY (from_place_id) REFERENCES place(id),
            FOREIGN KEY (to_place_id) REFERENCES place(id)
        )
        ''')
        
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS trip_stays (
            trip_segment_id INTEGER,
            hotel_id INTEGER,
            rate INTEGER,
            avg_price_per_night REAL,
            FOREIGN KEY (trip_segment_id) REFERENCES trip_segments(id),
            FOREIGN KEY (hotel_id) REFERENCES hotels(id),
            PRIMARY KEY (trip_segment_id, hotel_id)
        )
        ''')
        
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS trip_restaurants (
            trip_segment_id INTEGER,
            restaurant_id INTEGER,
            rate INTEGER,
            avg_money_spent REAL,
            FOREIGN KEY (trip_segment_id) REFERENCES trip_segments(id),
            FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
            PRIMARY KEY (trip_segment_id, restaurant_id)
        )
        ''')
        
        conn.commit()
        logger.info("Database tables created successfully")
        return conn
    except sqlite3.Error as e:
        logger.error(f"Error creating database: {e}")
        if conn:
            conn.close()
        return None

def insert_countries(conn, data):
    """Insert countries data into the database."""
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT id FROM place_type WHERE type_name = 'Country'")
        place_type_id = cursor.fetchone()[0]
        
        for row in data:
            cursor.execute(
                "INSERT INTO place (name, code, place_type_id) VALUES (?, ?, ?)",
                (row['CountryName'], row['CountryCode'], place_type_id)
            )
        conn.commit()
        logger.info(f"Inserted {len(data)} countries")
    except sqlite3.Error as e:
        logger.error(f"Error inserting countries: {e}")
        conn.rollback()

def insert_regions(conn, data):
    """Insert regions data into the database."""
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT id FROM place_type WHERE type_name = 'Region'")
        place_type_id = cursor.fetchone()[0]
        
        for row in data:
            cursor.execute(
                "SELECT id FROM place WHERE code = ? AND place_type_id = (SELECT id FROM place_type WHERE type_name = 'Country')",
                (row['CountryCode'],)
            )
            country_id = cursor.fetchone()[0]
            
            cursor.execute(
                "INSERT INTO place (name, code, place_type_id, parent_id) VALUES (?, ?, ?, ?)",
                (row['RegionName'], row['RegionCode'], place_type_id, country_id)
            )
        conn.commit()
        logger.info(f"Inserted {len(data)} regions")
    except sqlite3.Error as e:
        logger.error(f"Error inserting regions: {e}")
        conn.rollback()

def insert_cities(conn, data):
    """Insert cities data into the database."""
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT id FROM place_type WHERE type_name = 'City'")
        place_type_id = cursor.fetchone()[0]
        
        for row in data:
            # Parse coordinates
            lat, lon = None, None
            if row['Coordinates']:
                coords = row['Coordinates'].strip('"').split(',')
                if len(coords) == 2:
                    lat, lon = float(coords[0]), float(coords[1])
            
            cursor.execute(
                "SELECT id FROM place WHERE code = ? AND place_type_id = (SELECT id FROM place_type WHERE type_name = 'Country')",
                (row['CountryCode'],)
            )
            country_id = cursor.fetchone()[0]
            
            cursor.execute(
                "SELECT id FROM place WHERE code = ? AND place_type_id = (SELECT id FROM place_type WHERE type_name = 'Region')",
                (row['RegionCode'],)
            )
            region_id = cursor.fetchone()[0] if cursor.fetchone() else country_id
            
            cursor.execute(
                "INSERT INTO place (name, code, latitude, longitude, place_type_id, parent_id) VALUES (?, ?, ?, ?, ?, ?)",
                (row['CityNameNoSpecialChars'], row['CityCode'], lat, lon, place_type_id, region_id)
            )
        conn.commit()
        logger.info(f"Inserted {len(data)} cities")
    except sqlite3.Error as e:
        logger.error(f"Error inserting cities: {e}")
        conn.rollback()

def insert_restaurants(conn, data):
    """Insert restaurants data into the database."""
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT id FROM place WHERE name = 'Warszawa' AND place_type_id = (SELECT id FROM place_type WHERE type_name = 'City')")
        city_id = cursor.fetchone()[0]
        
        for row in data:
            cursor.execute(
                "INSERT INTO restaurants (name, longitude, latitude, cuisine, street, house_number, website, place_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
                (row['name'], float(row['lon']), float(row['lat']), row['cuisine'], 
                row['addr_street'], row['addr_housenumber'], row['website'], city_id)
            )
        conn.commit()
        logger.info(f"Inserted {len(data)} restaurants")
    except sqlite3.Error as e:
        logger.error(f"Error inserting restaurants: {e}")
        conn.rollback()

def insert_hotels(conn, data):
    """Insert hotels data into the database."""
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT id FROM place WHERE name = 'Warszawa' AND place_type_id = (SELECT id FROM place_type WHERE type_name = 'City')")
        city_id = cursor.fetchone()[0]
        
        for row in data:
            cursor.execute(
                "INSERT INTO hotels (name, longitude, latitude, street, house_number, website, place_id) VALUES (?, ?, ?, ?, ?, ?, ?)",
                (row['name'], float(row['lon']), float(row['lat']),
                row['addr_street'], row['addr_housenumber'], row['website'], city_id)
            )
        conn.commit()
        logger.info(f"Inserted {len(data)} hotels")
    except sqlite3.Error as e:
        logger.error(f"Error inserting hotels: {e}")
        conn.rollback()

def parse_people_cypher(conn):
    """Parse people data from Cypher file and insert into database."""
    try:
        with open(CYPHER_FILES['people'], 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Extract people data
        people_pattern = r'\((\w+):Person\{name:\'(.*?)\', age:(\d+), blog_address:\'(.*?)\'\}\)'
        people_matches = re.findall(people_pattern, content)
        
        cursor = conn.cursor()
        people_ids = {}
        
        # Insert people
        for match in people_matches:
            var, name, age, blog = match
            cursor.execute(
                "INSERT INTO people (name, age, blog_address) VALUES (?, ?, ?)",
                (name, int(age), blog)
            )
            people_ids[var] = cursor.lastrowid
        
        # Extract LIVES_IN relationships
        lives_in_pattern = r'\((\w+)\)-\[:LIVES_IN\]->\((\w+):City\{.*?name:\'(.*?)\'.*?\}\)'
        lives_in_alt_pattern = r'\((\w+)\)-\[:LIVES_IN\]->\((\w+):City\{.*?code:\'(.*?)\'.*?\}\)'
        
        lives_in_matches = re.findall(lives_in_pattern, content)
        lives_in_alt_matches = re.findall(lives_in_alt_pattern, content)
        
        # Update people with home cities
        for match in lives_in_matches:
            person_var, city_var, city_name = match
            if person_var in people_ids:
                cursor.execute("SELECT id FROM place WHERE name = ? AND place_type_id = (SELECT id FROM place_type WHERE type_name = 'City')", (city_name,))
                result = cursor.fetchone()
                if result:
                    cursor.execute(
                        "UPDATE people SET home_place_id = ? WHERE id = ?",
                        (result[0], people_ids[person_var])
                    )
        
        for match in lives_in_alt_matches:
            person_var, city_var, city_code = match
            if person_var in people_ids:
                cursor.execute("SELECT id FROM place WHERE code = ? AND place_type_id = (SELECT id FROM place_type WHERE type_name = 'City')", (city_code,))
                result = cursor.fetchone()
                if result:
                    cursor.execute(
                        "UPDATE people SET home_place_id = ? WHERE id = ?",
                        (result[0], people_ids[person_var])
                    )
        
        # Extract trip data
        trip_pattern = r'\((\w+):Trip\{name:\'(.*?)\', duration:(\d+), year_season:\'(.*?)\', type:\'(.*?)\'\}\)'
        trip_matches = re.findall(trip_pattern, content)
        
        trip_ids = {}
        
        # Insert trips
        for match in trip_matches:
            var, name, duration, year_season, trip_type = match
            
            # Find which person went for this trip
            went_for_pattern = r'\((\w+)\)-\[:WENT_FOR\]->\(' + var + r'\)'
            went_for_match = re.search(went_for_pattern, content)
            
            person_id = None
            if went_for_match:
                person_var = went_for_match.group(1)
                if person_var in people_ids:
                    person_id = people_ids[person_var]
            
            cursor.execute(
                "INSERT INTO trips (name, duration, year_season, type, person_id) VALUES (?, ?, ?, ?, ?)",
                (name, int(duration), year_season, trip_type, person_id)
            )
            trip_ids[var] = cursor.lastrowid
        
        # Extract trip segments
        segment_pattern = r'\((\w+):Trip\{duration:(\d+)\}\)'
        segment_matches = re.findall(segment_pattern, content)
        
        segment_ids = {}
        
        # Insert trip segments
        for match in segment_matches:
            var, duration = match
            
            # Find part of relationship
            part_of_pattern = r'\(' + var + r'\)-\[:IS_PART_OF\{order_no:(\d+)\}\]->\((\w+)\)'
            part_of_match = re.search(part_of_pattern, content)
            
            if part_of_match:
                order_no = part_of_match.group(1)
                main_trip_var = part_of_match.group(2)
                
                if main_trip_var in trip_ids:
                    # Find transportation and destination
                    transport_pattern = r'\(' + var + r'\)-\[:TO\{transportation:\'(.*?)\'\}\]->\(.*?:City\{.*?(name|code):\'(.*?)\'.*?\}\)'
                    transport_match = re.search(transport_pattern, content)
                    
                    to_place_id = None
                    transportation = None
                    if transport_match:
                        transportation = transport_match.group(1)
                        field_type = transport_match.group(2)
                        city_identifier = transport_match.group(3)
                        
                        if field_type == 'name':
                            cursor.execute("SELECT id FROM place WHERE name = ? AND place_type_id = (SELECT id FROM place_type WHERE type_name = 'City')", (city_identifier,))
                        else:
                            cursor.execute("SELECT id FROM place WHERE code = ? AND place_type_id = (SELECT id FROM place_type WHERE type_name = 'City')", (city_identifier,))
                        
                        result = cursor.fetchone()
                        if result:
                            to_place_id = result[0]
                    
                    # Find starting city for the main trip
                    from_place_id = None
                    if order_no == '1':
                        starts_from_pattern = r'\(' + main_trip_var + r'\)-\[:STARTS_FROM\]->\(.*?:City\{.*?(name|code):\'(.*?)\'.*?\}\)'
                        starts_from_match = re.search(starts_from_pattern, content)
                        
                        if starts_from_match:
                            field_type = starts_from_match.group(1)
                            city_identifier = starts_from_match.group(2)
                            
                            if field_type == 'name':
                                cursor.execute("SELECT id FROM place WHERE name = ? AND place_type_id = (SELECT id FROM place_type WHERE type_name = 'City')", (city_identifier,))
                            else:
                                cursor.execute("SELECT id FROM place WHERE code = ? AND place_type_id = (SELECT id FROM place_type WHERE type_name = 'City')", (city_identifier,))
                            
                            result = cursor.fetchone()
                            if result:
                                from_place_id = result[0]
                    
                    cursor.execute(
                        "INSERT INTO trip_segments (duration, order_no, main_trip_id, from_place_id, to_place_id, transportation) VALUES (?, ?, ?, ?, ?, ?)",
                        (int(duration), int(order_no), trip_ids[main_trip_var], from_place_id, to_place_id, transportation)
                    )
                    segment_ids[var] = cursor.lastrowid
        
        # Extract STAYED_AT relationships
        stayed_at_pattern = r'\((\w+)\)-\[:STAYED_AT\{rate:(\d+), avg_price_per_night:(\d+)\}\]->\(.*?:PlaceToSleep\{name:\'(.*?)\'\}\)'
        stayed_at_matches = re.findall(stayed_at_pattern, content)
        
        # Insert trip stays
        for match in stayed_at_matches:
            trip_segment_var, rate, avg_price, hotel_name = match
            if trip_segment_var in segment_ids:
                cursor.execute("SELECT id FROM hotels WHERE name = ?", (hotel_name,))
                hotel_result = cursor.fetchone()
                if hotel_result:
                    cursor.execute(
                        "INSERT INTO trip_stays (trip_segment_id, hotel_id, rate, avg_price_per_night) VALUES (?, ?, ?, ?)",
                        (segment_ids[trip_segment_var], hotel_result[0], int(rate), float(avg_price))
                    )
        
        # Extract WENT_TO relationships
        went_to_pattern = r'\((\w+)\)-\[:WENT_TO\{rate:(\d+), avg_money_spent:(\d+)\}\]->\(.*?:Sustenance\{name:\'(.*?)\'\}\)'
        went_to_matches = re.findall(went_to_pattern, content)
        
        # Insert trip restaurants
        for match in went_to_matches:
            trip_segment_var, rate, avg_money, restaurant_name = match
            if trip_segment_var in segment_ids:
                cursor.execute("SELECT id FROM restaurants WHERE name = ?", (restaurant_name,))
                restaurant_result = cursor.fetchone()
                if restaurant_result:
                    cursor.execute(
                        "INSERT INTO trip_restaurants (trip_segment_id, restaurant_id, rate, avg_money_spent) VALUES (?, ?, ?, ?)",
                        (segment_ids[trip_segment_var], restaurant_result[0], int(rate), float(avg_money))
                    )
        
        conn.commit()
        logger.info(f"Inserted people, trips and relationships from Cypher file")
    except Exception as e:
        logger.error(f"Error parsing people Cypher file: {e}")
        conn.rollback()

def main():
    # Create database
    conn = create_database()
    if not conn:
        return
    
    try:
        # Load CSV data
        countries_data = read_csv_file(CSV_FILES['countries'])
        regions_data = read_csv_file(CSV_FILES['subdiv'])
        cities_data = read_csv_file(CSV_FILES['cities'])
        restaurants_data = read_csv_file(CSV_FILES['restaurants'])
        hotels_data = read_csv_file(CSV_FILES['hotels'])
        
        # Insert data into tables
        insert_countries(conn, countries_data)
        insert_regions(conn, regions_data)
        insert_cities(conn, cities_data)
        insert_restaurants(conn, restaurants_data)
        insert_hotels(conn, hotels_data)
        
        # Parse and insert Cypher data
        parse_people_cypher(conn)
        
        logger.info(f"Database created successfully at {DB_PATH}")
    except Exception as e:
        logger.error(f"Error during data import: {e}")
    finally:
        if conn:
            conn.close()

if __name__ == "__main__":
    main()
