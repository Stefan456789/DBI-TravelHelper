select p.name
  from place p
  join trip t
on t.place_id = p.id
  join trip weekend
on t.trip_id = weekend.id
  join place start_place
on weekend.start_place_id = start_place.id
 where weekend.duration = 2
   and start_place.name = 'Madrid'
   and p.name <> 'Madrid'
 group by p.name
 order by count(p.name) desc;