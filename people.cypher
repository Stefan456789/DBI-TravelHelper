// First, let's DETACH DELETE everything to start with a clean slate
MATCH (n) DETACH DELETE n;

// Create cities first
CREATE (madrid:City{name:'Madrid'})
CREATE (london:City{name:'London'})
CREATE (chicago:City{name:'Chicago'})
CREATE (newYork:City{code:'NYC'})
CREATE (boston:City{name:'Boston'})
CREATE (philadelphia:City{name:'Philadelphia'})
CREATE (washington:City{name:'Washington'})
CREATE (seattle:City{name:'Seattle'})
CREATE (sanFrancisco:City{code:'SFO'})
CREATE (sanJose:City{code:'SJC'})
CREATE (monterey:City{name:'Monterey'})
CREATE (santaBarbara:City{code:'SBA'})
CREATE (losAngeles:City{code:'LAX'})
CREATE (lasVegas:City{code:'LAS'})
CREATE (warsaw:City{name:'Warszawa'})
CREATE (rome:City{code:'ROM'})
CREATE (milan:City{name:'Milano'})
CREATE (nice:City{name:'Nice'})
CREATE (marseille:City{name:'Marseille'})
CREATE (avignon:City{name:'Avignon'})
CREATE (perpignon:City{name:'Perpignan'})
CREATE (barcelona:City{name:'Barcelona'})
CREATE (seville:City{name:'Sevilla'})
CREATE (faro:City{name:'Faro'})
CREATE (lisbon:City{name:'Lisboa'})
CREATE (cascais:City{name:'Cascais'})
CREATE (porto:City{name:'Porto'})
CREATE (paris:City{name:'Paris'})
CREATE (torun:City{name:'Torun'})
CREATE (poznan:City{name:'Poznan'})
CREATE (zakopane:City{name:'Zakopane'})
CREATE (cracow:City{name:'Krakow'});

// Create PlaceToSleep nodes
CREATE (warsawYouthHostel:PlaceToSleep{name:'Villa Jeziorki 71'})
CREATE (sheraton:PlaceToSleep{name:'Sheraton'})
CREATE (classic:PlaceToSleep{name:'Mazowiecki'});

// Create Sustenance nodes
CREATE (pierogi:Sustenance{name:'Pierogarnia Zapiecek'})
CREATE (drinkBar:Sustenance{name:'Literatka'})
CREATE (belvederRestaurant:Sustenance{name:'Orient Express'})
CREATE (disco:Sustenance{name:'Grill Bar Zgoda'});

// Create Person nodes
CREATE (kate:Person{name:'Kate', age:30, blog_address:'kate blog'})
CREATE (ben:Person{name:'Ben', age:56, blog_address:'ben blog'})
CREATE (tom:Person{name:'Tom', age:40, blog_address:'tom blog'})
CREATE (john:Person{name:'John', age:34, blog_address:'john blog'})
CREATE (claudia:Person{name:'Claudia', age:26, blog_address:'claudia blog'})
CREATE (norah:Person{name:'Norah', age:18, blog_address:'norah blog'})
CREATE (lucas:Person{name:'Lucas', age:30, blog_address:'lucas blog'})
CREATE (pedro:Person{name:'Pedro', age:32, blog_address:'pedro blog'})
CREATE (pierre:Person{name:'Pierre', age:40, blog_address:'pierre blog'})
CREATE (laura:Person{name:'Laura', age:31, blog_address:'Laura blog'});

// Create LIVES_IN relationships
MATCH (kate:Person{name:'Kate'}), (madrid:City{name:'Madrid'})
CREATE (kate)-[:LIVES_IN]->(madrid);

MATCH (ben:Person{name:'Ben'}), (london:City{name:'London'})
CREATE (ben)-[:LIVES_IN]->(london);

MATCH (tom:Person{name:'Tom'}), (madrid:City{name:'Madrid'})
CREATE (tom)-[:LIVES_IN]->(madrid);

MATCH (john:Person{name:'John'}), (madrid:City{name:'Madrid'})
CREATE (john)-[:LIVES_IN]->(madrid);

MATCH (claudia:Person{name:'Claudia'}), (lisbon:City{name:'Lisboa'})
CREATE (claudia)-[:LIVES_IN]->(lisbon);

MATCH (norah:Person{name:'Norah'}), (chicago:City{name:'Chicago'})
CREATE (norah)-[:LIVES_IN]->(chicago);

MATCH (lucas:Person{name:'Lucas'}), (warsaw:City{name:'Warszawa'})
CREATE (lucas)-[:LIVES_IN]->(warsaw);

MATCH (pedro:Person{name:'Pedro'}), (rome:City{code:'ROM'})
CREATE (pedro)-[:LIVES_IN]->(rome);

MATCH (pierre:Person{name:'Pierre'}), (nice:City{name:'Nice'})
CREATE (pierre)-[:LIVES_IN]->(nice);

MATCH (laura:Person{name:'Laura'}), (madrid:City{name:'Madrid'})
CREATE (laura)-[:LIVES_IN]->(madrid);

// Kate's USA trip
MATCH (kate:Person{name:'Kate'}), (madrid:City{name:'Madrid'})
CREATE (kateInUsa:Trip{name:'My trip to USA', duration:30, year_season:'autumn', type:'low budget'})
CREATE (kateInUsa1:Trip{duration:2})
CREATE (kateInUsa2:Trip{duration:3})
CREATE (kateInUsa3:Trip{duration:1})
CREATE (kateInUsa4:Trip{duration:2})
CREATE (kateInUsa5:Trip{duration:2})
CREATE (kateInUsa6:Trip{duration:2})
CREATE (kateInUsa7:Trip{duration:3})
CREATE (kateInUsa8:Trip{duration:1})
CREATE (kateInUsa9:Trip{duration:2})
CREATE (kateInUsa10:Trip{duration:3})
CREATE (kateInUsa11:Trip{duration:4})
CREATE (kateInUsa12:Trip{duration:4})
CREATE (kateInUsaEnd:Trip{duration:1})
CREATE (kate)-[:WENT_FOR]->(kateInUsa)
CREATE (kate)-[:WENT_FOR]->(kateInUsa1)
CREATE (kate)-[:WENT_FOR]->(kateInUsa2)
CREATE (kate)-[:WENT_FOR]->(kateInUsa3)
CREATE (kate)-[:WENT_FOR]->(kateInUsa4)
CREATE (kate)-[:WENT_FOR]->(kateInUsa5)
CREATE (kate)-[:WENT_FOR]->(kateInUsa6)
CREATE (kate)-[:WENT_FOR]->(kateInUsa7)
CREATE (kate)-[:WENT_FOR]->(kateInUsa8)
CREATE (kate)-[:WENT_FOR]->(kateInUsa9)
CREATE (kate)-[:WENT_FOR]->(kateInUsa10)
CREATE (kate)-[:WENT_FOR]->(kateInUsa11)
CREATE (kate)-[:WENT_FOR]->(kateInUsa12)
CREATE (kate)-[:WENT_FOR]->(kateInUsaEnd)
CREATE (kateInUsa)-[:STARTS_FROM]->(madrid);

// Kate's USA trip destinations
MATCH (kateInUsa1:Trip{duration:2}), (chicago:City{name:'Chicago'})
WHERE EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa1) }
CREATE (kateInUsa1)-[:TO{transportation:'plane'}]->(chicago);

MATCH (kateInUsa2:Trip{duration:3}), (newYork:City{code:'NYC'})
WHERE EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa2) }
CREATE (kateInUsa2)-[:TO{transportation:'plane'}]->(newYork);

MATCH (kateInUsa3:Trip{duration:1}), (boston:City{name:'Boston'})
WHERE EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa3) }
CREATE (kateInUsa3)-[:TO{transportation:'car'}]->(boston);

MATCH (kateInUsa4:Trip{duration:2}), (philadelphia:City{name:'Philadelphia'})
WHERE EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa4) }
CREATE (kateInUsa4)-[:TO{transportation:'car'}]->(philadelphia);

MATCH (kateInUsa5:Trip{duration:2}), (washington:City{name:'Washington'})
WHERE EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa5) }
CREATE (kateInUsa5)-[:TO{transportation:'car'}]->(washington);

MATCH (kateInUsa6:Trip{duration:2}), (seattle:City{name:'Seattle'})
WHERE EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa6) }
CREATE (kateInUsa6)-[:TO{transportation:'plane'}]->(seattle);

MATCH (kateInUsa7:Trip{duration:3}), (sanFrancisco:City{code:'SFO'})
WHERE EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa7) }
CREATE (kateInUsa7)-[:TO{transportation:'plane'}]->(sanFrancisco);

MATCH (kateInUsa8:Trip{duration:1}), (sanJose:City{code:'SJC'})
WHERE EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa8) }
CREATE (kateInUsa8)-[:TO{transportation:'car'}]->(sanJose);

MATCH (kateInUsa9:Trip{duration:2}), (monterey:City{name:'Monterey'})
WHERE EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa9) }
CREATE (kateInUsa9)-[:TO{transportation:'car'}]->(monterey);

MATCH (kateInUsa10:Trip{duration:3}), (santaBarbara:City{code:'SBA'})
WHERE EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa10) }
CREATE (kateInUsa10)-[:TO{transportation:'car'}]->(santaBarbara);

MATCH (kateInUsa11:Trip{duration:4}), (losAngeles:City{code:'LAX'})
WHERE EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa11) }
CREATE (kateInUsa11)-[:TO{transportation:'car'}]->(losAngeles);

MATCH (kateInUsa12:Trip{duration:4}), (lasVegas:City{code:'LAS'})
WHERE EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa12) }
CREATE (kateInUsa12)-[:TO{transportation:'car'}]->(lasVegas);

MATCH (kateInUsaEnd:Trip{duration:1}), (madrid:City{name:'Madrid'})
WHERE EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsaEnd) }
CREATE (kateInUsaEnd)-[:TO{transportation:'plane'}]->(madrid);

// Kate's USA trip parts
MATCH (kateInUsa:Trip), (kateInUsa1:Trip{duration:2})
WHERE kateInUsa.name = 'My trip to USA'
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa) }
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa1) }
CREATE (kateInUsa1)-[:IS_PART_OF{order_no:1}]->(kateInUsa);

MATCH (kateInUsa:Trip), (kateInUsa2:Trip{duration:3})
WHERE kateInUsa.name = 'My trip to USA'
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa) }
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa2) }
CREATE (kateInUsa2)-[:IS_PART_OF{order_no:2}]->(kateInUsa);

MATCH (kateInUsa:Trip), (kateInUsa3:Trip{duration:1})
WHERE kateInUsa.name = 'My trip to USA'
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa) }
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa3) }
CREATE (kateInUsa3)-[:IS_PART_OF{order_no:3}]->(kateInUsa);

MATCH (kateInUsa:Trip), (kateInUsa4:Trip{duration:2})
WHERE kateInUsa.name = 'My trip to USA'
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa) }
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa4) }
AND EXISTS { MATCH (kateInUsa4)-[:TO]->(:City{name:'Philadelphia'}) }
CREATE (kateInUsa4)-[:IS_PART_OF{order_no:4}]->(kateInUsa);

MATCH (kateInUsa:Trip), (kateInUsa5:Trip{duration:2})
WHERE kateInUsa.name = 'My trip to USA'
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa) }
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa5) }
AND EXISTS { MATCH (kateInUsa5)-[:TO]->(:City{name:'Washington'}) }
CREATE (kateInUsa5)-[:IS_PART_OF{order_no:5}]->(kateInUsa);

MATCH (kateInUsa:Trip), (kateInUsa6:Trip{duration:2})
WHERE kateInUsa.name = 'My trip to USA'
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa) }
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa6) }
AND EXISTS { MATCH (kateInUsa6)-[:TO]->(:City{name:'Seattle'}) }
CREATE (kateInUsa6)-[:IS_PART_OF{order_no:6}]->(kateInUsa);

MATCH (kateInUsa:Trip), (kateInUsa7:Trip{duration:3})
WHERE kateInUsa.name = 'My trip to USA'
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa) }
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa7) }
AND EXISTS { MATCH (kateInUsa7)-[:TO]->(:City{code:'SFO'}) }
CREATE (kateInUsa7)-[:IS_PART_OF{order_no:7}]->(kateInUsa);

MATCH (kateInUsa:Trip), (kateInUsa8:Trip{duration:1})
WHERE kateInUsa.name = 'My trip to USA'
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa) }
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa8) }
CREATE (kateInUsa8)-[:IS_PART_OF{order_no:8}]->(kateInUsa);

MATCH (kateInUsa:Trip), (kateInUsa9:Trip{duration:2})
WHERE kateInUsa.name = 'My trip to USA'
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa) }
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa9) }
CREATE (kateInUsa9)-[:IS_PART_OF{order_no:9}]->(kateInUsa);

MATCH (kateInUsa:Trip), (kateInUsa10:Trip{duration:3})
WHERE kateInUsa.name = 'My trip to USA'
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa) }
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa10) }
CREATE (kateInUsa10)-[:IS_PART_OF{order_no:10}]->(kateInUsa);

MATCH (kateInUsa:Trip), (kateInUsa11:Trip{duration:4})
WHERE kateInUsa.name = 'My trip to USA'
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa) }
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa11) }
CREATE (kateInUsa11)-[:IS_PART_OF{order_no:11}]->(kateInUsa);

MATCH (kateInUsa:Trip), (kateInUsa12:Trip{duration:4})
WHERE kateInUsa.name = 'My trip to USA'
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa) }
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa12) }
CREATE (kateInUsa12)-[:IS_PART_OF{order_no:12}]->(kateInUsa);

MATCH (kateInUsa:Trip), (kateInUsaEnd:Trip{duration:1})
WHERE kateInUsa.name = 'My trip to USA'
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsa) }
AND EXISTS { MATCH (:Person{name:'Kate'})-[:WENT_FOR]->(kateInUsaEnd) }
AND EXISTS { MATCH (kateInUsaEnd)-[:TO]->(:City{name:'Madrid'}) }
CREATE (kateInUsaEnd)-[:IS_PART_OF{order_no:13}]->(kateInUsa);

// Ben's USA Trip
MATCH (ben:Person{name:'Ben'}), (london:City{name:'London'})
CREATE (benInUsa:Trip{name:'My holidays to USA', duration:30, year_season:'summer', type:'standard'})
CREATE (benInUsa1:Trip{duration:2})
CREATE (benInUsa2:Trip{duration:3})
CREATE (benInUsa3:Trip{duration:1})
CREATE (benInUsa4:Trip{duration:2})
CREATE (benInUsaEnd:Trip{duration:2})
CREATE (ben)-[:WENT_FOR]->(benInUsa)
CREATE (ben)-[:WENT_FOR]->(benInUsa1)
CREATE (ben)-[:WENT_FOR]->(benInUsa2)
CREATE (ben)-[:WENT_FOR]->(benInUsa3)
CREATE (ben)-[:WENT_FOR]->(benInUsa4)
CREATE (ben)-[:WENT_FOR]->(benInUsaEnd)
CREATE (benInUsa)-[:STARTS_FROM]->(london)
CREATE (benInUsa1)-[:TO{transportation:'plane'}]->(sanFrancisco:City{code:'SFO'})
CREATE (benInUsa2)-[:TO{transportation:'plane'}]->(losAngeles:City{code:'LAX'})
CREATE (benInUsa3)-[:TO{transportation:'car'}]->(santaBarbara:City{code:'SBA'})
CREATE (benInUsa4)-[:TO{transportation:'car'}]->(losAngeles)
CREATE (benInUsaEnd)-[:TO{transportation:'plane'}]->(london)
CREATE (benInUsa1)-[:IS_PART_OF{order_no:1}]->(benInUsa)
CREATE (benInUsa2)-[:IS_PART_OF{order_no:2}]->(benInUsa)
CREATE (benInUsa3)-[:IS_PART_OF{order_no:3}]->(benInUsa)
CREATE (benInUsa4)-[:IS_PART_OF{order_no:4}]->(benInUsa)
CREATE (benInUsaEnd)-[:IS_PART_OF{order_no:5}]->(benInUsa);

// Lucas EuroTrip (simplified for brevity)
MATCH (lucas:Person{name:'Lucas'}), (warsaw:City{name:'Warszawa'})
CREATE (lucasEuroTrip:Trip{name:'My trip around Europe', duration:30, year_season:'summer', type:'backpacking'})
CREATE (lucas)-[:WENT_FOR]->(lucasEuroTrip)
CREATE (lucasEuroTrip)-[:STARTS_FROM]->(warsaw);

// Pedro in Poland
MATCH (pedro:Person{name:'Pedro'}), (rome:City{code:'ROM'})
CREATE (pedroPolandTrip:Trip{name:'My trip around Poland', duration:20, year_season:'summer', type:'standard'})
CREATE (pedroPolandTrip1:Trip{duration:3})
CREATE (pedroPolandTrip4:Trip{duration:1})
CREATE (pedro)-[:WENT_FOR]->(pedroPolandTrip)
CREATE (pedro)-[:WENT_FOR]->(pedroPolandTrip1)
CREATE (pedro)-[:WENT_FOR]->(pedroPolandTrip4)
CREATE (pedroPolandTrip)-[:STARTS_FROM]->(rome)
CREATE (pedroPolandTrip1)-[:TO{transportation:'plane'}]->(warsaw:City{name:'Warszawa'})
CREATE (pedroPolandTrip4)-[:TO{transportation:'train'}]->(warsaw)
CREATE (pedroPolandTrip1)-[:IS_PART_OF{order_no:1}]->(pedroPolandTrip)
CREATE (pedroPolandTrip4)-[:IS_PART_OF{order_no:4}]->(pedroPolandTrip);

// Pierre in Poland 
MATCH (pierre:Person{name:'Pierre'}), (nice:City{name:'Nice'})
CREATE (pierrePolandTrip:Trip{name:'My trip around Poland', duration:10, year_season:'summer', type:'standard'})
CREATE (pierrePolandTrip2:Trip{duration:3})
CREATE (pierre)-[:WENT_FOR]->(pierrePolandTrip)
CREATE (pierre)-[:WENT_FOR]->(pierrePolandTrip2)
CREATE (pierrePolandTrip)-[:STARTS_FROM]->(nice)
CREATE (pierrePolandTrip2)-[:TO{transportation:'train'}]->(warsaw:City{name:'Warszawa'})
CREATE (pierrePolandTrip2)-[:IS_PART_OF{order_no:2}]->(pierrePolandTrip);

// Claudia in Poland
MATCH (claudia:Person{name:'Claudia'}), (lisbon:City{name:'Lisboa'})
CREATE (claudiaPolandTrip:Trip{name:'My trip around Poland', duration:13, year_season:'summer', type:'standard'})
CREATE (claudiaPolandTrip1:Trip{duration:3})
CREATE (claudiaPolandTrip4:Trip{duration:3})
CREATE (claudia)-[:WENT_FOR]->(claudiaPolandTrip)
CREATE (claudia)-[:WENT_FOR]->(claudiaPolandTrip1)
CREATE (claudia)-[:WENT_FOR]->(claudiaPolandTrip4)
CREATE (claudiaPolandTrip)-[:STARTS_FROM]->(lisbon)
CREATE (claudiaPolandTrip1)-[:TO{transportation:'plane'}]->(warsaw:City{name:'Warszawa'})
CREATE (claudiaPolandTrip4)-[:TO{transportation:'bus'}]->(warsaw)
CREATE (claudiaPolandTrip1)-[:IS_PART_OF{order_no:1}]->(claudiaPolandTrip)
CREATE (claudiaPolandTrip4)-[:IS_PART_OF{order_no:4}]->(claudiaPolandTrip);

// Norah in Poland
MATCH (norah:Person{name:'Norah'}), (chicago:City{name:'Chicago'})
CREATE (norahPolandTrip:Trip{name:'My trip around Poland', duration:32, year_season:'summer', type:'standard'})
CREATE (norahPolandTrip1:Trip{duration:10})
CREATE (norahPolandTrip4:Trip{duration:1})
CREATE (norah)-[:WENT_FOR]->(norahPolandTrip)
CREATE (norah)-[:WENT_FOR]->(norahPolandTrip1)
CREATE (norah)-[:WENT_FOR]->(norahPolandTrip4)
CREATE (norahPolandTrip)-[:STARTS_FROM]->(chicago)
CREATE (norahPolandTrip1)-[:TO{transportation:'plane'}]->(warsaw:City{name:'Warszawa'})
CREATE (norahPolandTrip4)-[:TO{transportation:'bus'}]->(warsaw)
CREATE (norahPolandTrip1)-[:IS_PART_OF{order_no:1}]->(norahPolandTrip)
CREATE (norahPolandTrip4)-[:IS_PART_OF{order_no:4}]->(norahPolandTrip);

// Tom to London
MATCH (tom:Person{name:'Tom'}), (madrid:City{name:'Madrid'})
CREATE (tomLondonTrip:Trip{name:'Weekend in London', duration:2, year_season:'summer', type:'standard'})
CREATE (tomLondonTrip1:Trip{duration:2})
CREATE (tom)-[:WENT_FOR]->(tomLondonTrip)
CREATE (tom)-[:WENT_FOR]->(tomLondonTrip1)
CREATE (tomLondonTrip)-[:STARTS_FROM]->(madrid)
CREATE (tomLondonTrip1)-[:TO{transportation:'plane'}]->(london:City{name:'London'})
CREATE (tomLondonTrip1)-[:IS_PART_OF{order_no:1}]->(tomLondonTrip);

// John to Barcelona  
MATCH (john:Person{name:'John'}), (madrid:City{name:'Madrid'})
CREATE (johnBarcelonaTrip:Trip{name:'Weekend in Barcelona', duration:2, year_season:'summer', type:'standard'})
CREATE (johnBarcelonaTrip1:Trip{duration:2})
CREATE (john)-[:WENT_FOR]->(johnBarcelonaTrip)
CREATE (john)-[:WENT_FOR]->(johnBarcelonaTrip1)
CREATE (johnBarcelonaTrip)-[:STARTS_FROM]->(madrid)
CREATE (johnBarcelonaTrip1)-[:TO{transportation:'plane'}]->(barcelona:City{name:'Barcelona'})
CREATE (johnBarcelonaTrip1)-[:IS_PART_OF{order_no:1}]->(johnBarcelonaTrip);

// Kate to Barcelona
MATCH (kate:Person{name:'Kate'}), (madrid:City{name:'Madrid'})
CREATE (kateBarcelonaTrip:Trip{name:'Weekend in Barcelona', duration:2, year_season:'summer', type:'standard'})
CREATE (kateBarcelonaTrip1:Trip{duration:2})
CREATE (kate)-[:WENT_FOR]->(kateBarcelonaTrip)
CREATE (kate)-[:WENT_FOR]->(kateBarcelonaTrip1)
CREATE (kateBarcelonaTrip)-[:STARTS_FROM]->(madrid)
CREATE (kateBarcelonaTrip1)-[:TO{transportation:'plane'}]->(barcelona:City{name:'Barcelona'})
CREATE (kateBarcelonaTrip1)-[:IS_PART_OF{order_no:1}]->(kateBarcelonaTrip);

// STAYED_AT relationships
MATCH (norahPolandTrip1:Trip{duration:10}), (warsawYouthHostel:PlaceToSleep{name:'Villa Jeziorki 71'})
WHERE EXISTS { MATCH (:Person{name:'Norah'})-[:WENT_FOR]->(norahPolandTrip1) }
CREATE (norahPolandTrip1)-[:STAYED_AT{rate:5, avg_price_per_night:60}]->(warsawYouthHostel);

MATCH (norahPolandTrip4:Trip{duration:1}), (classic:PlaceToSleep{name:'Mazowiecki'})
WHERE EXISTS { MATCH (:Person{name:'Norah'})-[:WENT_FOR]->(norahPolandTrip4) }
CREATE (norahPolandTrip4)-[:STAYED_AT{rate:5, avg_price_per_night:120}]->(classic);

MATCH (claudiaPolandTrip1:Trip{duration:3}), (classic:PlaceToSleep{name:'Mazowiecki'})
WHERE EXISTS { MATCH (:Person{name:'Claudia'})-[:WENT_FOR]->(claudiaPolandTrip1) }
CREATE (claudiaPolandTrip1)-[:STAYED_AT{rate:5, avg_price_per_night:100}]->(classic);

MATCH (claudiaPolandTrip4:Trip{duration:3}), (classic:PlaceToSleep{name:'Mazowiecki'})
WHERE EXISTS { MATCH (:Person{name:'Claudia'})-[:WENT_FOR]->(claudiaPolandTrip4) }
CREATE (claudiaPolandTrip4)-[:STAYED_AT{rate:5, avg_price_per_night:120}]->(classic);

MATCH (pedroPolandTrip1:Trip{duration:3}), (classic:PlaceToSleep{name:'Mazowiecki'})
WHERE EXISTS { MATCH (:Person{name:'Pedro'})-[:WENT_FOR]->(pedroPolandTrip1) }
CREATE (pedroPolandTrip1)-[:STAYED_AT{rate:5, avg_price_per_night:120}]->(classic);

MATCH (pedroPolandTrip4:Trip{duration:1}), (classic:PlaceToSleep{name:'Mazowiecki'})
WHERE EXISTS { MATCH (:Person{name:'Pedro'})-[:WENT_FOR]->(pedroPolandTrip4) }
CREATE (pedroPolandTrip4)-[:STAYED_AT{rate:5, avg_price_per_night:100}]->(classic);

MATCH (pierrePolandTrip2:Trip{duration:3}), (sheraton:PlaceToSleep{name:'Sheraton'})
WHERE EXISTS { MATCH (:Person{name:'Pierre'})-[:WENT_FOR]->(pierrePolandTrip2) }
CREATE (pierrePolandTrip2)-[:STAYED_AT{rate:5, avg_price_per_night:400}]->(sheraton);

// WENT_TO relationships
MATCH (norahPolandTrip1:Trip{duration:10}), (disco:Sustenance{name:'Grill Bar Zgoda'})
WHERE EXISTS { MATCH (:Person{name:'Norah'})-[:WENT_FOR]->(norahPolandTrip1) }
CREATE (norahPolandTrip1)-[:WENT_TO{rate:5, avg_money_spent:50}]->(disco);

MATCH (norahPolandTrip4:Trip{duration:1}), (pierogi:Sustenance{name:'Pierogarnia Zapiecek'})
WHERE EXISTS { MATCH (:Person{name:'Norah'})-[:WENT_FOR]->(norahPolandTrip4) }
CREATE (norahPolandTrip4)-[:WENT_TO{rate:5, avg_money_spent:30}]->(pierogi);

MATCH (claudiaPolandTrip1:Trip{duration:3}), (pierogi:Sustenance{name:'Pierogarnia Zapiecek'})
WHERE EXISTS { MATCH (:Person{name:'Claudia'})-[:WENT_FOR]->(claudiaPolandTrip1) }
CREATE (claudiaPolandTrip1)-[:WENT_TO{rate:5, avg_money_spent:30}]->(pierogi);

MATCH (claudiaPolandTrip4:Trip{duration:3}), (drinkBar:Sustenance{name:'Literatka'})
WHERE EXISTS { MATCH (:Person{name:'Claudia'})-[:WENT_FOR]->(claudiaPolandTrip4) }
CREATE (claudiaPolandTrip4)-[:WENT_TO{rate:5, avg_money_spent:50}]->(drinkBar);

MATCH (pedroPolandTrip1:Trip{duration:3}), (pierogi:Sustenance{name:'Pierogarnia Zapiecek'})
WHERE EXISTS { MATCH (:Person{name:'Pedro'})-[:WENT_FOR]->(pedroPolandTrip1) }
CREATE (pedroPolandTrip1)-[:WENT_TO{rate:5, avg_money_spent:30}]->(pierogi);

MATCH (pedroPolandTrip4:Trip{duration:1}), (drinkBar:Sustenance{name:'Literatka'})
WHERE EXISTS { MATCH (:Person{name:'Pedro'})-[:WENT_FOR]->(pedroPolandTrip4) }
CREATE (pedroPolandTrip4)-[:WENT_TO{rate:5, avg_money_spent:50}]->(drinkBar);

MATCH (pierrePolandTrip2:Trip{duration:3}), (belvederRestaurant:Sustenance{name:'Orient Express'})
WHERE EXISTS { MATCH (:Person{name:'Pierre'})-[:WENT_FOR]->(pierrePolandTrip2) }
CREATE (pierrePolandTrip2)-[:WENT_TO{rate:5, avg_money_spent:400}]->(belvederRestaurant);


