select dest_place.name as placename,
       count(dest_place.name) as counts
  from trip weekend
  join tripstartsfrom tsf
on weekend.id = tsf.trip_id
  join place madrid
on tsf.place_id = madrid.id
  join tripispartof tip
on tip.parent_trip_id = weekend.id
  join trip child_trip
on child_trip.id = tip.child_trip_id
  join tripto tt
on tt.trip_id = child_trip.id
  join place dest_place
on tt.place_id = dest_place.id
 where weekend.duration = 2
   and madrid.name = 'Madrid'
   and dest_place.name != 'Madrid'
 group by dest_place.name
 order by counts desc;