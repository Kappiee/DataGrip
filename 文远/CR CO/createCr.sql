select names = (stuff((
select case when HS_ACTION=N'删除' then HS_OLD_ITEM else HS_NEW_ITEM end hs_item
from innovator.HS_CO c
left join innovator.HS_CO_REL_PART p on p.SOURCE_ID = c.id
where c.HS_CR = '180754F77A3D42F782B50E736DCDB2CB'
for xml path('')),1,0,''))