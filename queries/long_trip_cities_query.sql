with longtrips as (
    -- Get distinct long trips and their starting place (via STARTS_FROM)
   select distinct lt.id as longtripid,
                   lt.name as tripname,
                   sp.name as start_place
     from trip lt
     join tripstartsfrom ts
   on lt.id = ts.trip_id
     join place sp
   on ts.place_id = sp.id
    -- Ensuring lt is a parent in a IS_PART_OF relationship
     join tripispartof tip
   on tip.parent_trip_id = lt.id
),citydetails as (
    -- For each long trip, get the child trip's destination details
   select lt.tripname,
          lt.start_place,
          p.name as city_name,
          tip.order_no,
          tt.transportation
     from longtrips lt
     join tripispartof tip
   on lt.longtripid = tip.parent_trip_id
     join tripto tt
   on tt.trip_id = tip.child_trip_id
     join place p
   on tt.place_id = p.id
)
select cd.tripname,
       cd.start_place,
       group_concat(
          json_object(
             'order_no',
                      cd.order_no,
                      'to',
                      cd.city_name,
                      'by',
                      cd.transportation)
       ) as cities,
       count(*) as nbrofcities
  from citydetails cd
 group by cd.tripname,
          cd.start_place
 order by nbrofcities desc;