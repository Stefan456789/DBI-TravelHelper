OPTIONAL MATCH (warsaw:City{name:'Warszawa'}),
	   (cracow:City{name:'Krakow'}),
	   (zakopane:City{name:'Zakopane'}),
	   (torun:City{name:'Torun'}),
	   (gdansk:City{name:'Gdansk'}),
	   (poznan:City{name:'Poznan'}),
	   (paris:City{name:'Paris'}),
	   (nice:City{name:'Nice'}),
	   (avignon:City{name:'Avignon'}),
	   (lyon:City{name:'Lyon'}),
	   (marseille:City{name:'Marseille'}),
	   (perpignon:City{name:'Perpignan'}),
	   (rome:City{code:'ROM'}),
	   (milan:City{name:'Milano'}),
	   (palermo:City{name:'Palermo'}),
	   (neapol:City{name:'Napoli'}),
	   (bari:City{name:'Bari'}),
	   (barcelona:City{name:'Barcelona'}),
	   (madrid:City{name:'Madrid'}),
	   (seville:City{name:'Sevilla'}),
	   (bilbao:City{name:'Bilbao'}),
	   (porto:City{name:'Porto'}),
	   (lisbon:City{name:'Lisboa'}),
	   (cascais:City{name:'Cascais'}),
	   (faro:City{name:'Faro'}),
	   (london:City{name:'London'}),
	   (glasgow:City{name:'Glasgow'}),
	   (manchester:City{name:'Manchester'}),
	   (cardiff:City{name:'Cardiff'}),
	   (chicago:City{name:'Chicago'}),
	   (newYork:City{code:'NYC'}),
	   (boston:City{name:'Boston'}),
	   (philadelphia:City{name:'Philadelphia'}),
	   (washington:City{name:'Washington'}),
	   (seattle:City{name:'Seattle'}),
	   (sanFrancisco:City{code:'SFO'}),
	   (sanJose:City{code:'SJC'}),
	   (monterey:City{name:'Monterey'}),
	   (santaBarbara:City{code:'SBA'}),
	   (losAngeles:City{code:'LAX'}),
	   (lasVegas:City{code:'LAS'}),
	   (warsawYouthHostel:PlaceToSleep{name:'Villa Jeziorki 71'}),
           (sheraton:PlaceToSleep{name:'Sheraton'}),
           (classic:PlaceToSleep{name:'Mazowiecki'}),
	   (pierogi:Sustenance{name:'Pierogarnia Zapiecek'}),
	   (drinkBar:Sustenance{name:'Literatka'}),
	   (belvederRestaurant:Sustenance{name:'Orient Express'}),
	   (disco:Sustenance{name:'Grill Bar Zgoda'})




//Person
CREATE (kate:Person{name:'Kate', age:30, blog_address:'kate blog'}),
       (ben:Person{name:'Ben', age:56, blog_address:'ben blog'}),
	   (tom:Person{name:'Tom', age:40, blog_address:'tom blog'}),
	   (john:Person{name:'John', age:34, blog_address:'john blog'}),
	   (claudia:Person{name:'Claudia', age:26, blog_address:'claudia blog'}),
	   (norah:Person{name:'Norah', age:18, blog_address:'norah blog'}),
	   (lucas:Person{name:'Lucas', age:30, blog_address:'lucas blog'}),
	   (pedro:Person{name:'Pedro', age:32, blog_address:'pedro blog'}),
	   (pierre:Person{name:'Pierre', age:40, blog_address:'pierre blog'}),
	   (laura:Person{name:'Laura', age:31, blog_address:'Laura blog'})



//Trip
CREATE (kateInUsa:Trip{name:'My trip to USA', duration:30, year_season:'autumn', type:'low budget'}),
	   (kateInUsa1:Trip{duration:2}),
	   (kateInUsa2:Trip{duration:3}),
	   (kateInUsa3:Trip{duration:1}),
	   (kateInUsa4:Trip{duration:2}),
	   (kateInUsa5:Trip{duration:2}),
	   (kateInUsa6:Trip{duration:2}),
	   (kateInUsa7:Trip{duration:3}),
	   (kateInUsa8:Trip{duration:1}),
	   (kateInUsa9:Trip{duration:2}),
	   (kateInUsa10:Trip{duration:3}),
	   (kateInUsa11:Trip{duration:4}),
	   (kateInUsa12:Trip{duration:4}),
	   (kateInUsaEnd:Trip{duration:1})

//Person WENT_FOR a trip
CREATE  (kate)-[:WENT_FOR]->(kateInUsa),
		(kate)-[:WENT_FOR]->(kateInUsa1),
		(kate)-[:WENT_FOR]->(kateInUsa2),
		(kate)-[:WENT_FOR]->(kateInUsa3),
		(kate)-[:WENT_FOR]->(kateInUsa4),
		(kate)-[:WENT_FOR]->(kateInUsa5),
		(kate)-[:WENT_FOR]->(kateInUsa6),
		(kate)-[:WENT_FOR]->(kateInUsa7),
		(kate)-[:WENT_FOR]->(kateInUsa8),
		(kate)-[:WENT_FOR]->(kateInUsa9),
		(kate)-[:WENT_FOR]->(kateInUsa10),
		(kate)-[:WENT_FOR]->(kateInUsa11),
		(kate)-[:WENT_FOR]->(kateInUsa12),
		(kate)-[:WENT_FOR]->(kateInUsaEnd)

//Trip TO Place
CREATE (kateInUsa)-[:STARTS_FROM]->(madrid),
	   (kateInUsa1)-[:TO{transportation:'plane'}]->(chicago),
	   (kateInUsa2)-[:TO{transportation:'plane'}]->(newYork),
	   (kateInUsa3)-[:TO{transportation:'car'}]->(boston),
	   (kateInUsa4)-[:TO{transportation:'car'}]->(philadelphia),
	   (kateInUsa5)-[:TO{transportation:'car'}]->(washington),
	   (kateInUsa6)-[:TO{transportation:'plane'}]->(seattle),
	   (kateInUsa7)-[:TO{transportation:'plane'}]->(sanFrancisco),
	   (kateInUsa8)-[:TO{transportation:'car'}]->(sanJose),
	   (kateInUsa9)-[:TO{transportation:'car'}]->(monterey),
	   (kateInUsa10)-[:TO{transportation:'car'}]->(santaBarbara),
	   (kateInUsa11)-[:TO{transportation:'car'}]->(losAngeles),
	   (kateInUsa12)-[:TO{transportation:'car'}]->(lasVegas),
	   (kateInUsaEnd)-[:TO{transportation:'plane'}]->(madrid)

CREATE (kateInUsa1)-[:IS_PART_OF{order_no:1}]->(kateInUsa),
	   (kateInUsa2)-[:IS_PART_OF{order_no:2}]->(kateInUsa),
	   (kateInUsa3)-[:IS_PART_OF{order_no:3}]->(kateInUsa),
	   (kateInUsa4)-[:IS_PART_OF{order_no:4}]->(kateInUsa),
	   (kateInUsa5)-[:IS_PART_OF{order_no:5}]->(kateInUsa),
	   (kateInUsa6)-[:IS_PART_OF{order_no:6}]->(kateInUsa),
	   (kateInUsa7)-[:IS_PART_OF{order_no:7}]->(kateInUsa),
	   (kateInUsa8)-[:IS_PART_OF{order_no:8}]->(kateInUsa),
	   (kateInUsa9)-[:IS_PART_OF{order_no:9}]->(kateInUsa),
	   (kateInUsa10)-[:IS_PART_OF{order_no:10}]->(kateInUsa),
	   (kateInUsa11)-[:IS_PART_OF{order_no:11}]->(kateInUsa),
	   (kateInUsa12)-[:IS_PART_OF{order_no:12}]->(kateInUsa),
	   (kateInUsaEnd)-[:IS_PART_OF{order_no:13}]->(kateInUsa)

//Trip
CREATE (benInUsa:Trip{name:'My holidays to USA', duration:30, year_season:'summer', type:'standard'}),
	   (benInUsa1:Trip{duration:2}),
	   (benInUsa2:Trip{duration:3}),
	   (benInUsa3:Trip{duration:1}),
	   (benInUsa4:Trip{duration:2}),
	   (benInUsaEnd:Trip{duration:2})

//Person WENT_FOR a trip
CREATE  (ben)-[:WENT_FOR]->(benInUsa),
		(ben)-[:WENT_FOR]->(benInUsa1),
		(ben)-[:WENT_FOR]->(benInUsa2),
		(ben)-[:WENT_FOR]->(benInUsa3),
		(ben)-[:WENT_FOR]->(benInUsa4),
		(ben)-[:WENT_FOR]->(benInUsaEnd)

//Trip TO Place
CREATE (benInUsa)-[:STARTS_FROM]->(london),
	   (benInUsa1)-[:TO{transportation:'plane'}]->(sanFrancisco),
	   (benInUsa2)-[:TO{transportation:'plane'}]->(losAngeles),
	   (benInUsa3)-[:TO{transportation:'car'}]->(santaBarbara),
	   (benInUsa4)-[:TO{transportation:'car'}]->(losAngeles),
	   (benInUsaEnd)-[:TO{transportation:'plane'}]->(london)

CREATE (benInUsa1)-[:IS_PART_OF{order_no:1}]->(benInUsa),
	   (benInUsa2)-[:IS_PART_OF{order_no:2}]->(benInUsa),
	   (benInUsa3)-[:IS_PART_OF{order_no:3}]->(benInUsa),
	   (benInUsa4)-[:IS_PART_OF{order_no:4}]->(benInUsa),
	   (benInUsaEnd)-[:IS_PART_OF{order_no:5}]->(benInUsa)

//Trip
CREATE (lucasEuroTrip:Trip{name:'My trip around Europe', duration:30, year_season:'summer', type:'backpacking'}),
	   (lucasEuroTrip1:Trip{duration:2}),
	   (lucasEuroTrip2:Trip{duration:2}),
	   (lucasEuroTrip3:Trip{duration:2}),
	   (lucasEuroTrip4:Trip{duration:2}),
	   (lucasEuroTrip5:Trip{duration:2}),
	   (lucasEuroTrip6:Trip{duration:2}),
	   (lucasEuroTrip7:Trip{duration:2}),
	   (lucasEuroTrip8:Trip{duration:2}),
	   (lucasEuroTrip9:Trip{duration:2}),
	   (lucasEuroTrip10:Trip{duration:2}),
	   (lucasEuroTrip11:Trip{duration:2}),
	   (lucasEuroTrip12:Trip{duration:2}),
	   (lucasEuroTrip13:Trip{duration:2}),
	   (lucasEuroTrip14:Trip{duration:2}),
	   (lucasEuroTripEnd:Trip{duration:2})

//Person WENT_FOR a trip
CREATE  (lucas)-[:WENT_FOR]->(lucasEuroTrip),
		(lucas)-[:WENT_FOR]->(lucasEuroTrip1),
		(lucas)-[:WENT_FOR]->(lucasEuroTrip2),
		(lucas)-[:WENT_FOR]->(lucasEuroTrip3),
		(lucas)-[:WENT_FOR]->(lucasEuroTrip4),
		(lucas)-[:WENT_FOR]->(lucasEuroTrip5),
		(lucas)-[:WENT_FOR]->(lucasEuroTrip6),
		(lucas)-[:WENT_FOR]->(lucasEuroTrip7),
		(lucas)-[:WENT_FOR]->(lucasEuroTrip8),
		(lucas)-[:WENT_FOR]->(lucasEuroTrip9),
		(lucas)-[:WENT_FOR]->(lucasEuroTrip10),
		(lucas)-[:WENT_FOR]->(lucasEuroTrip11),
		(lucas)-[:WENT_FOR]->(lucasEuroTrip12),
		(lucas)-[:WENT_FOR]->(lucasEuroTrip13),
		(lucas)-[:WENT_FOR]->(lucasEuroTrip14),
		(lucas)-[:WENT_FOR]->(lucasEuroTripEnd)

//Trip TO Place
CREATE (lucasEuroTrip)-[:STARTS_FROM]->(warsaw),
	   (lucasEuroTrip1)-[:TO{transportation:'plane'}]->(rome),
	   (lucasEuroTrip2)-[:TO{transportation:'train'}]->(milan),
	   (lucasEuroTrip3)-[:TO{transportation:'train'}]->(nice),
	   (lucasEuroTrip4)-[:TO{transportation:'train'}]->(marseille),
	   (lucasEuroTrip5)-[:TO{transportation:'train'}]->(avignon),
	   (lucasEuroTrip6)-[:TO{transportation:'train'}]->(perpignon),
	   (lucasEuroTrip7)-[:TO{transportation:'train'}]->(barcelona),
	   (lucasEuroTrip8)-[:TO{transportation:'train'}]->(seville),
	   (lucasEuroTrip9)-[:TO{transportation:'bus'}]->(faro),
	   (lucasEuroTrip10)-[:TO{transportation:'bus'}]->(lisbon),
	   (lucasEuroTrip11)-[:TO{transportation:'train'}]->(cascais),
	   (lucasEuroTrip12)-[:TO{transportation:'train'}]->(porto),
	   (lucasEuroTrip13)-[:TO{transportation:'plane'}]->(madrid),
	   (lucasEuroTrip14)-[:TO{transportation:'plane'}]->(paris),
	   (lucasEuroTripEnd)-[:TO{transportation:'plane'}]->(warsaw)


CREATE (lucasEuroTrip1)-[:IS_PART_OF{order_no:1}]->(lucasEuroTrip),
	   (lucasEuroTrip2)-[:IS_PART_OF{order_no:2}]->(lucasEuroTrip),
	   (lucasEuroTrip3)-[:IS_PART_OF{order_no:3}]->(lucasEuroTrip),
	   (lucasEuroTrip4)-[:IS_PART_OF{order_no:4}]->(lucasEuroTrip),
	   (lucasEuroTrip5)-[:IS_PART_OF{order_no:5}]->(lucasEuroTrip),
	   (lucasEuroTrip6)-[:IS_PART_OF{order_no:6}]->(lucasEuroTrip),
	   (lucasEuroTrip7)-[:IS_PART_OF{order_no:7}]->(lucasEuroTrip),
	   (lucasEuroTrip8)-[:IS_PART_OF{order_no:8}]->(lucasEuroTrip),
	   (lucasEuroTrip9)-[:IS_PART_OF{order_no:9}]->(lucasEuroTrip),
	   (lucasEuroTrip10)-[:IS_PART_OF{order_no:10}]->(lucasEuroTrip),
	   (lucasEuroTrip11)-[:IS_PART_OF{order_no:11}]->(lucasEuroTrip),
	   (lucasEuroTrip12)-[:IS_PART_OF{order_no:12}]->(lucasEuroTrip),
	   (lucasEuroTrip13)-[:IS_PART_OF{order_no:13}]->(lucasEuroTrip),
	   (lucasEuroTrip14)-[:IS_PART_OF{order_no:14}]->(lucasEuroTrip),
	   (lucasEuroTripEnd)-[:IS_PART_OF{order_no:15}]->(lucasEuroTrip)

// pedro in Poland

//Trip
CREATE (pedroPolandTrip:Trip{name:'My trip around Poland', duration:20, year_season:'summer', type:'standard'}),
	   (pedroPolandTrip1:Trip{duration:3}),
	   (pedroPolandTrip2:Trip{duration:3}),
	   (pedroPolandTrip3:Trip{duration:2}),
	   (pedroPolandTrip4:Trip{duration:1}),
	   (pedroPolandTrip5:Trip{duration:5}),
	   (pedroPolandTrip6:Trip{duration:5}),
	   (pedroPolandTripEnd:Trip{duration:1})

//Person WENT_FOR a trip
CREATE  (lucas)-[:WENT_FOR]->(pedroPolandTrip),
		(pedro)-[:WENT_FOR]->(pedroPolandTrip1),
		(pedro)-[:WENT_FOR]->(pedroPolandTrip2),
		(pedro)-[:WENT_FOR]->(pedroPolandTrip3),
		(pedro)-[:WENT_FOR]->(pedroPolandTrip4),
		(pedro)-[:WENT_FOR]->(pedroPolandTrip5),
		(pedro)-[:WENT_FOR]->(pedroPolandTrip6),
		(pedro)-[:WENT_FOR]->(pedroPolandTripEnd)

//Trip TO Place
CREATE (pedroPolandTrip)-[:STARTS_FROM]->(rome),
	   (pedroPolandTrip1)-[:TO{transportation:'plane'}]->(warsaw),
	   (pedroPolandTrip2)-[:TO{transportation:'bus'}]->(torun),
	   (pedroPolandTrip3)-[:TO{transportation:'bus'}]->(poznan),
	   (pedroPolandTrip4)-[:TO{transportation:'train'}]->(warsaw),
	   (pedroPolandTrip5)-[:TO{transportation:'car'}]->(zakopane),
	   (pedroPolandTrip6)-[:TO{transportation:'bus'}]->(cracow),
	   (pedroPolandTripEnd)-[:TO{transportation:'plane'}]->(rome)


CREATE (pedroPolandTrip1)-[:IS_PART_OF{order_no:1}]->(pedroPolandTrip),
	   (pedroPolandTrip2)-[:IS_PART_OF{order_no:2}]->(pedroPolandTrip),
	   (pedroPolandTrip3)-[:IS_PART_OF{order_no:3}]->(pedroPolandTrip),
	   (pedroPolandTrip4)-[:IS_PART_OF{order_no:4}]->(pedroPolandTrip),
	   (pedroPolandTrip5)-[:IS_PART_OF{order_no:5}]->(pedroPolandTrip),
	   (pedroPolandTrip6)-[:IS_PART_OF{order_no:6}]->(pedroPolandTrip),
	   (pedroPolandTripEnd)-[:IS_PART_OF{order_no:7}]->(pedroPolandTrip)

// pierre in Poland

//Trip
CREATE (pierrePolandTrip:Trip{name:'My trip around Poland', duration:10, year_season:'summer', type:'standard'}),
	   (pierrePolandTrip1:Trip{duration:3}),
	   (pierrePolandTrip2:Trip{duration:3}),
	   (pierrePolandTrip3:Trip{duration:3}),
	   (pierrePolandTripEnd:Trip{duration:1})

//Person WENT_FOR a trip
CREATE  (pierre)-[:WENT_FOR]->(pierrePolandTrip),
		(pierre)-[:WENT_FOR]->(pierrePolandTrip1),
		(pierre)-[:WENT_FOR]->(pierrePolandTrip2),
		(pierre)-[:WENT_FOR]->(pierrePolandTrip3),
		(pierre)-[:WENT_FOR]->(pierrePolandTripEnd)

//Trip TO Place
CREATE (pierrePolandTrip)-[:STARTS_FROM]->(nice),
	   (pierrePolandTrip1)-[:TO{transportation:'plane'}]->(poznan),
	   (pierrePolandTrip2)-[:TO{transportation:'train'}]->(warsaw),
	   (pierrePolandTrip3)-[:TO{transportation:'train'}]->(cracow),
	   (pierrePolandTripEnd)-[:TO{transportation:'plane'}]->(nice)


CREATE (pierrePolandTrip1)-[:IS_PART_OF{order_no:1}]->(pierrePolandTrip),
	   (pierrePolandTrip2)-[:IS_PART_OF{order_no:2}]->(pierrePolandTrip),
	   (pierrePolandTrip3)-[:IS_PART_OF{order_no:3}]->(pierrePolandTrip),
	   (pierrePolandTripEnd)-[:IS_PART_OF{order_no:4}]->(pierrePolandTrip)

// claudia in Poland

//Trip
CREATE (claudiaPolandTrip:Trip{name:'My trip around Poland', duration:13, year_season:'summer', type:'standard'}),
	   (claudiaPolandTrip1:Trip{duration:3}),
	   (claudiaPolandTrip2:Trip{duration:3}),
	   (claudiaPolandTrip3:Trip{duration:3}),
	   (claudiaPolandTrip4:Trip{duration:3}),
	   (claudiaPolandTripEnd:Trip{duration:1})

//Person WENT_FOR a trip
CREATE  (claudia)-[:WENT_FOR]->(claudiaPolandTrip),
		(claudia)-[:WENT_FOR]->(claudiaPolandTrip1),
		(claudia)-[:WENT_FOR]->(claudiaPolandTrip2),
		(claudia)-[:WENT_FOR]->(claudiaPolandTrip3),
		(claudia)-[:WENT_FOR]->(claudiaPolandTrip4),
		(claudia)-[:WENT_FOR]->(claudiaPolandTripEnd)

//Trip TO Place
CREATE (claudiaPolandTrip)-[:STARTS_FROM]->(lisbon),
	   (claudiaPolandTrip1)-[:TO{transportation:'plane'}]->(warsaw),
	   (claudiaPolandTrip2)-[:TO{transportation:'train'}]->(cracow),
	   (claudiaPolandTrip3)-[:TO{transportation:'bus'}]->(zakopane),
	   (claudiaPolandTrip4)-[:TO{transportation:'bus'}]->(warsaw),
	   (claudiaPolandTripEnd)-[:TO{transportation:'plane'}]->(lisbon)


CREATE (claudiaPolandTrip1)-[:IS_PART_OF{order_no:1}]->(claudiaPolandTrip),
	   (claudiaPolandTrip2)-[:IS_PART_OF{order_no:2}]->(claudiaPolandTrip),
	   (claudiaPolandTrip3)-[:IS_PART_OF{order_no:3}]->(claudiaPolandTrip),
	   (claudiaPolandTrip4)-[:IS_PART_OF{order_no:4}]->(claudiaPolandTrip),
	   (claudiaPolandTripEnd)-[:IS_PART_OF{order_no:5}]->(claudiaPolandTrip)

// norah in Poland

//Trip
CREATE (norahPolandTrip:Trip{name:'My trip around Poland', duration:32, year_season:'summer', type:'standard'}),
	   (norahPolandTrip1:Trip{duration:10}),
	   (norahPolandTrip2:Trip{duration:10}),
	   (norahPolandTrip3:Trip{duration:10}),
	   (norahPolandTrip4:Trip{duration:1}),
	   (norahPolandTripEnd:Trip{duration:1})

//Person WENT_FOR a trip
CREATE  (norah)-[:WENT_FOR]->(norahPolandTrip),
		(norah)-[:WENT_FOR]->(norahPolandTrip1),
		(norah)-[:WENT_FOR]->(norahPolandTrip2),
		(norah)-[:WENT_FOR]->(norahPolandTrip3),
		(norah)-[:WENT_FOR]->(norahPolandTrip4),
		(norah)-[:WENT_FOR]->(norahPolandTripEnd)

//Trip TO Place
CREATE (norahPolandTrip)-[:STARTS_FROM]->(chicago),
	   (norahPolandTrip1)-[:TO{transportation:'plane'}]->(warsaw),
	   (norahPolandTrip2)-[:TO{transportation:'train'}]->(cracow),
	   (norahPolandTrip3)-[:TO{transportation:'bus'}]->(zakopane),
	   (norahPolandTrip4)-[:TO{transportation:'bus'}]->(warsaw),
	   (norahPolandTripEnd)-[:TO{transportation:'plane'}]->(chicago)


CREATE (norahPolandTrip1)-[:IS_PART_OF{order_no:1}]->(norahPolandTrip),
	   (norahPolandTrip2)-[:IS_PART_OF{order_no:2}]->(norahPolandTrip),
	   (norahPolandTrip3)-[:IS_PART_OF{order_no:3}]->(norahPolandTrip),
	   (norahPolandTrip4)-[:IS_PART_OF{order_no:4}]->(norahPolandTrip),
	   (norahPolandTripEnd)-[:IS_PART_OF{order_no:5}]->(norahPolandTrip)

	   // tom in London

//Trip
CREATE (tomLondonTrip:Trip{name:'Weekend in London', duration:2, year_season:'summer', type:'standard'}),
	   (tomLondonTrip1:Trip{duration:2}),
	   (tomLondonTripEnd:Trip{duration:'0'})

//Person WENT_FOR a trip
CREATE  (tom)-[:WENT_FOR]->(tomLondonTrip),
		(tom)-[:WENT_FOR]->(tomLondonTrip1),
		(tom)-[:WENT_FOR]->(tomLondonTripEnd)

//Trip TO Place
CREATE (tomLondonTrip)-[:STARTS_FROM]->(madrid),
	   (tomLondonTrip1)-[:TO{transportation:'plane'}]->(london),
	   (tomLondonTripEnd)-[:TO{transportation:'plane'}]->(madrid)


CREATE (tomLondonTrip1)-[:IS_PART_OF{order_no:1}]->(tomLondonTrip),
	   (tomLondonTripEnd)-[:IS_PART_OF{order_no:2}]->(tomLondonTrip)

// john in Barcelona

//Trip
CREATE (johnBarcelonaTrip:Trip{name:'Weekend in Barcelona', duration:2, year_season:'summer', type:'standard'}),
	   (johnBarcelonaTrip1:Trip{duration:2}),
	   (johnBarcelonaTripEnd:Trip{duration:0})

//Person WENT_FOR a trip
CREATE  (john)-[:WENT_FOR]->(johnBarcelonaTrip),
		(john)-[:WENT_FOR]->(johnBarcelonaTrip1),
		(john)-[:WENT_FOR]->(johnBarcelonaTripEnd)

//Trip TO Place
CREATE (johnBarcelonaTrip)-[:STARTS_FROM]->(madrid),
	   (johnBarcelonaTrip1)-[:TO{transportation:'plane'}]->(barcelona),
	   (johnBarcelonaTripEnd)-[:TO{transportation:'plane'}]->(madrid)


CREATE (johnBarcelonaTrip1)-[:IS_PART_OF{order_no:1}]->(johnBarcelonaTrip),
	   (johnBarcelonaTripEnd)-[:IS_PART_OF{order_no:2}]->(johnBarcelonaTrip)

// kate in Barcelona

//Trip
CREATE (kateBarcelonaTrip:Trip{name:'Weekend in Barcelona', duration:2, year_season:'summer', type:'standard'}),
	   (kateBarcelonaTrip1:Trip{duration:2}),
	   (kateBarcelonaTripEnd:Trip{duration:0})

//Person WENT_FOR a trip
CREATE  (kate)-[:WENT_FOR]->(kateBarcelonaTrip),
		(kate)-[:WENT_FOR]->(kateBarcelonaTrip1),
		(kate)-[:WENT_FOR]->(kateBarcelonaTripEnd)

//Trip TO Place
CREATE (kateBarcelonaTrip)-[:STARTS_FROM]->(madrid),
	   (kateBarcelonaTrip1)-[:TO{transportation:'plane'}]->(barcelona),
	   (kateBarcelonaTripEnd)-[:TO{transportation:'plane'}]->(madrid)


CREATE (kateBarcelonaTrip1)-[:IS_PART_OF{order_no:1}]->(kateBarcelonaTrip),
	   (kateBarcelonaTripEnd)-[:IS_PART_OF{order_no:2}]->(kateBarcelonaTrip)



//STAYED_AT
CREATE (norahPolandTrip1)-[:STAYED_AT{rate:5, avg_price_per_night:60}]->(warsawYouthHostel),
	   (norahPolandTrip4)-[:STAYED_AT{rate:5, avg_price_per_night:120}]->(classic),
	   (claudiaPolandTrip1)-[:STAYED_AT{rate:5, avg_price_per_night:100}]->(classic),
	   (claudiaPolandTrip4)-[:STAYED_AT{rate:5, avg_price_per_night:120}]->(classic),
	   (pedroPolandTrip1)-[:STAYED_AT{rate:5, avg_price_per_night:120}]->(classic),
	   (pedroPolandTrip4)-[:STAYED_AT{rate:5, avg_price_per_night:100}]->(classic),
	   (pierrePolandTrip2)-[:STAYED_AT{rate:5, avg_price_per_night:400}]->(sheraton)

//WENT_TO
CREATE (norahPolandTrip1)-[:WENT_TO{rate:5, avg_money_spent:50}]->(disco),
	   (norahPolandTrip4)-[:WENT_TO{rate:5, avg_money_spent:30}]->(pierogi),
	   (claudiaPolandTrip1)-[:WENT_TO{rate:5, avg_money_spent:30}]->(pierogi),
	   (claudiaPolandTrip4)-[:WENT_TO{rate:5, avg_money_spent:50}]->(drinkBar),
	   (pedroPolandTrip1)-[:WENT_TO{rate:5, avg_money_spent:30}]->(pierogi),
	   (pedroPolandTrip4)-[:WENT_TO{rate:5, avg_money_spent:50}]->(drinkBar),
	   (pierrePolandTrip2)-[:WENT_TO{rate:5, avg_money_spent:400}]->(belvederRestaurant)

//LIVES_IN
CREATE (kate)-[:LIVES_IN]->(madrid),
	   (ben)-[:LIVES_IN]->(london),
	   (tom)-[:LIVES_IN]->(madrid),
	   (john)-[:LIVES_IN]->(madrid),
	   (claudia)-[:LIVES_IN]->(lisbon),
	   (norah)-[:LIVES_IN]->(chicago),
	   (lucas)-[:LIVES_IN]->(warsaw),
	   (pedro)-[:LIVES_IN]->(rome),
	   (pierre)-[:LIVES_IN]->(nice),
	   (laura)-[:LIVES_IN]->(madrid)


