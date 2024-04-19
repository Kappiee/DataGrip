
select id
from innovator.PERMISSION
where NAME = 'hs_world'

select (select id from innovator.[USER] where LOGIN_NAME = 'admin') userId,
       (select id from innovator.PERMISSION where NAME = 'hs_world') permissionId,
       (select top 1 rel.id from innovator.LIFE_CYCLE_STATE rel
          inner join innovator.LIFE_CYCLE_MAP main on main.id = rel.SOURCE_ID and main.KEYED_NAME = 'hs_process_material' and  rel.NAME = 'Pending'
        ) leftCycleId


select main.KEYED_NAME,rel.id,rel.* from innovator.LIFE_CYCLE_STATE rel
          left join innovator.LIFE_CYCLE_MAP main on main.id = rel.SOURCE_ID
          where rel.NAME = 'Pending' and main.KEYED_NAME = 'hs_process_material'