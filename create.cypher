
CREATE INDEX FOR (p:Place) ON p.name;
CREATE INDEX FOR (c:Country) ON c.name;
CREATE INDEX FOR (r:Region) ON r.name;
CREATE INDEX FOR (ci:City) ON ci.name;  // Use a different variable name (ci)

CREATE INDEX FOR (p2:Place) ON p2.code;
CREATE INDEX FOR (c2:Country) ON c2.code;
CREATE INDEX FOR (r2:Region) ON r2.code;
CREATE INDEX FOR (ci2:City) ON ci2.code; // Use a different variable name (ci2)

// Countries
load csv with headers from 'countries.csv' as line fieldterminator ','
WITH line.CountryCode as CountryCode, line.CountryName as CountryName
CREATE (p:Place:Country{code:CountryCode, name:CountryName});

// Regions
load csv with headers from 'subdiv.csv' as line fieldterminator ','
WITH line.CountryCode as CountryCode, line.RegionCode as RegionCode, line.RegionName as RegionName, line.RegionType as RegionType
MATCH (country:Country {code:CountryCode})
CREATE (p:Place:Region{code:RegionCode, name:RegionName})-[:BELONGS_TO]->(country);

// Cities
load csv with headers from 'cities.csv' as line fieldterminator ','
WITH line.CountryCode as CountryCode, line.CityCode as CityCode, line.CityNameNoSpecialChars as CityName, line.RegionCode as RegionCode, line.Coordinates as Coordinates
MATCH (country:Country {code:CountryCode})
OPTIONAL MATCH (country)<-[:BELONGS_TO]-(region:Region{code:RegionCode})
FOREACH (o IN CASE WHEN region IS NOT NULL THEN [region] ELSE [] END |
    CREATE (c:Place:City{code:CityCode, name:CityName, coordinates:Coordinates})-[:BELONGS_TO]->(region)
)
FOREACH (o IN CASE WHEN region IS NULL THEN [region] ELSE [] END |
    CREATE (c:Place:City{code:CityCode, name:CityName, coordinates:Coordinates})-[:BELONGS_TO]->(country)
);

// restaurants
load csv with headers from 'restaurantsWarsaw.csv' as line fieldterminator ','
WITH line.name as Name, line.lon as Lon, line.lat as Lat, line.cuisine as Cuisine, line.addr_city as City, line.addr_street as Street, line.addr_housenumber as Housenumber, line.website as Website
MATCH (warsaw:City{name:'Warszawa'})
CREATE (:Sustenance:Restaurant{name:Name, lon:toFloat(Lon), lat:toFloat(Lat),city: City,street:Street, housenumber:Housenumber, cuisine:Cuisine, website:Website})-[:IS_LOCATED_IN]->(warsaw);

// hotels
load csv with headers from 'hotelsWarsaw.csv' as line fieldterminator ','
WITH line.name as Name, line.lon as Lon, line.lat as Lat, line.addr_city as City, line.addr_street as Street, line.addr_housenumber as Housenumber, line.website as Website
MATCH (warsaw:City{name:'Warszawa'})
CREATE (:PlaceToSleep:Hotel{name:Name, lon:toFloat(Lon), lat:toFloat(Lat), city:City, street:Street, housenumber:Housenumber, website:Website})-[:IS_LOCATED_IN]->(warsaw);

