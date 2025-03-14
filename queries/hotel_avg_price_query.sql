SELECT 
    hotel.name AS hotel,
    hotel.website AS website,
    AVG(stay.avg_price_per_night) AS avg_price
FROM PlaceToSleep AS hotel
JOIN Place AS p ON hotel.city_id = p.id
JOIN TripStayedAt AS stay ON hotel.id = stay.place_to_sleep_id
JOIN Trip AS t ON stay.trip_id = t.id
JOIN PersonWentFor AS pwf ON t.id = pwf.trip_id
JOIN Person AS client ON pwf.person_id = client.id
WHERE p.name = 'Warszawa'
GROUP BY hotel.name, hotel.website
HAVING avg_price < 200
ORDER BY avg_price;
