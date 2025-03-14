select s.name as resto,
       avg(tt.rate) as avg_rate
  from sustenance s
  join sustenancelocatedin sl
on s.id = sl.sustenance_id
  join place p
on sl.place_id = p.id
  join tripwentto tt
on s.id = tt.sustenance_id
  join trip t
on tt.trip_id = t.id
  join personwentfor pwf
on t.id = pwf.trip_id
  join person client
on pwf.person_id = client.id
 where p.name = 'Warszawa'
   and client.age > 25
   and client.age < 36
 group by s.name
 order by avg_rate desc;