select CURRENT_STATE,state
from innovator.PROJECTACTIVITY
where PROJ_NUM = '43CD40E657064127BEA75C35BF592A7E'
and CLASSIFICATION = 'activity'



select state.id,state.name
from innovator.LIFE_CYCLE_MAP map
left join innovator.LIFE_CYCLE_STATE state on map.ID = state.SOURCE_ID
where map.id = 'F618870653364ECB9B7AFC7F7A44CEB6';


update innovator.PROJECTACTIVITY set CURRENT_STATE = '7032FE666D934FB1B3003E5CD648E94A'
where id in (select id
             from innovator.PROJECTACTIVITY
             where PROJ_NUM = '43CD40E657064127BEA75C35BF592A7E'
               and CLASSIFICATION = 'activity')

update innovator.PROJECTACTIVITY set STATE = 'Active'
where id in (select id
             from innovator.PROJECTACTIVITY
             where PROJ_NUM = '43CD40E657064127BEA75C35BF592A7E'
               and CLASSIFICATION = 'activity')