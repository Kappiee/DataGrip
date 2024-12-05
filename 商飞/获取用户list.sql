select ID
from innovator.[USER]
where USER_NO is not null or USER_NO !='';

select idList = stuff(
(select ','+ ID
from innovator.[USER]
where USER_NO is not null or USER_NO !=''
FOR XML PATH('')
),1,1,'')

select ids = stuff((
  select
  ',' + id
  from innovator.[Identity]
  where hs_team_level = 'Level1'
  for xml path('')
),1 ,1, '')