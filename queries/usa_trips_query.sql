WITH RECURSIVE USPlaces AS (
    -- Get US country and all descendant places (e.g. states, cities) via BELONGS_TO
    SELECT id, name, parent_id, code, type
    FROM Place
    WHERE type='Country' AND code='US'
    UNION ALL
    SELECT p.id, p.name, p.parent_id, p.code, p.type
    FROM Place p
    JOIN USPlaces u ON p.parent_id = u.id
),
UsaTrips AS (
    -- Find parent trips (usaTrip) with duration <32 that have a child Trip (shortTrip)
    -- whose TO destination is in the USPlaces set;
    -- also join with the start_place from TripStartsFrom.
    SELECT DISTINCT ut.id AS usaTrip_id, ut.name AS tripName, sp.name AS start_place
    FROM Trip ut
    JOIN TripStartsFrom ts ON ut.id = ts.trip_id
    JOIN Place sp ON ts.place_id = sp.id
    JOIN TripIsPartOf tip ON ut.id = tip.parent_trip_id
    JOIN TripTo tt ON tip.child_trip_id = tt.trip_id
    JOIN USPlaces up ON tt.place_id = up.id
    WHERE ut.duration < 32
),
CityDetails AS (
    -- For a given usaTrip, get each child Trip's destination that is within USPlaces.
    SELECT ut.tripName,
           ut.start_place,
           p.name AS city_name,
           tip.order_no,
           tt.transportation
    FROM UsaTrips ut
    JOIN TripIsPartOf tip ON ut.usaTrip_id = tip.parent_trip_id
    JOIN TripTo tt ON tt.trip_id = tip.child_trip_id
    JOIN USPlaces p ON tt.place_id = p.id
)
SELECT 
    cd.tripName,
    cd.start_place,
    GROUP_CONCAT(json_object('order_no', cd.order_no, 'to', cd.city_name, 'by', cd.transportation)) AS cities,
    COUNT(*) AS nbrOfCities
FROM CityDetails cd
GROUP BY cd.tripName, cd.start_place
ORDER BY nbrOfCities DESC;
