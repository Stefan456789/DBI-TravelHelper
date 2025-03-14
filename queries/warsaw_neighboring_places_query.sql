WITH RECURSIVE PolishPlaces AS (
    -- Get the country Poland and all its descendant places
    SELECT id, name FROM Place WHERE type = 'Country' AND name = 'Poland'
    UNION ALL
    SELECT p.id, p.name
    FROM Place p
    JOIN PolishPlaces pp ON p.parent_id = pp.id
),
PreviousPlaces AS (
    SELECT previousPlace.name AS place
    FROM Trip AS warsawTrip
    JOIN TripTo AS wtt ON warsawTrip.id = wtt.trip_id
    JOIN Place AS place ON wtt.place_id = place.id
       AND place.name = 'Warszawa'
    JOIN TripIsPartOf AS warsawPart ON warsawTrip.id = warsawPart.child_trip_id
    JOIN Trip AS longTrip ON warsawPart.parent_trip_id = longTrip.id
    JOIN TripIsPartOf AS previousPart 
         ON longTrip.id = previousPart.parent_trip_id 
        AND previousPart.order_no = warsawPart.order_no - 1
    JOIN Trip AS previousTrip ON previousPart.child_trip_id = previousTrip.id
    JOIN TripTo AS ptt ON previousTrip.id = ptt.trip_id
    JOIN Place AS previousPlace ON ptt.place_id = previousPlace.id
    WHERE previousPlace.id IN (SELECT id FROM PolishPlaces)
),
NextPlaces AS (
    SELECT nextPlace.name AS place
    FROM Trip AS warsawTrip
    JOIN TripTo AS wtt ON warsawTrip.id = wtt.trip_id
    JOIN Place AS place ON wtt.place_id = place.id
       AND place.name = 'Warszawa'
    JOIN TripIsPartOf AS warsawPart ON warsawTrip.id = warsawPart.child_trip_id
    JOIN Trip AS longTrip ON warsawPart.parent_trip_id = longTrip.id
    JOIN TripIsPartOf AS nextPart 
         ON longTrip.id = nextPart.parent_trip_id 
        AND nextPart.order_no = warsawPart.order_no + 1
    JOIN Trip AS nextTrip ON nextPart.child_trip_id = nextTrip.id
    JOIN TripTo AS ntt ON nextTrip.id = ntt.trip_id
    JOIN Place AS nextPlace ON ntt.place_id = nextPlace.id
    WHERE nextPlace.id IN (SELECT id FROM PolishPlaces)
)
SELECT place FROM PreviousPlaces
UNION
SELECT place FROM NextPlaces;
