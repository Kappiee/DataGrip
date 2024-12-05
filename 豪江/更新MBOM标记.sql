select HS_OLDITEM,HS_NEWITEM from innovator.HS_ECN_REL_IMPACT_ITEMS item
where SOURCE_ID = '83128D8CA5114C369BCF5580F7FC37BD' and HS_ITEMTYPE = N'物料' and HS_ACTION = N'更新'


select RELATED_ID as id,SOURCE_ID as parent_id from innovator.PART_BOM bom
where SOURCE_ID in ('EA0FE750784E4A9099EA34BCA730D347','9CA5EF2E693D4EB889C4616FA83BE760')


select RELATED_ID as id,SOURCE_ID as parent_id from innovator.PART_BOM bom
where SOURCE_ID = '9CA5EF2E693D4EB889C4616FA83BE760'


update innovator.HS_PROCESS_MATERIAL set hs_action = N'变更'
where id in ('')


select c.id,c.BOM_ID,c.PREVIOUS_ID,c.PARENT_ID,c.PART_ID,pc.id,mParentPart.HS_PART
from innovator.CRAFTDATA c
left join innovator.HS_PROCESS_MATERIAL mPart on mPart.id = c.PART_ID
left join innovator.CRAFTDATA pc on pc.id = c.PARENT_ID
left join innovator.HS_PROCESS_MATERIAL mParentPart on mParentPart.id = pc.PART_ID
where c.PARENT_ID in (select c.id
from innovator.CRAFTDATA c
left join innovator.HS_PROCESS_MATERIAL mPart on mPart.id = c.PART_ID
where mPart.HS_PART = '9BE315ACFBC74022B475DC03EC5DA579');


select id,HS_PART
from innovator.HS_PROCESS_MATERIAL
where HS_PART in ('9BE315ACFBC74022B475DC03EC5DA579')

select id,HS_PART from innovator.HS_PROCESS_MATERIAL where HS_PART in ('{string.Join("','",updateImpactItemIdList)}')

select p.id,m.id from innovator.CRAFTDATA c
left join innovator.HS_PROCESS_MATERIAL m on m.id = c.PART_ID
left join innovator.PART p on p.id = m.HS_PART
where p.id in ('9BE315ACFBC74022B475DC03EC5DA579')

select m.HS_PART as part_id,m.id m_part_id,c.bom_id,c.id as craft_data_id,c.PARENT_ID as craft_parent_id from innovator.HS_PROCESS_MATERIAL m
left join innovator.CRAFTDATA c on m.id = c.PART_ID
where m.HS_PART in ('EA0FE750784E4A9099EA34BCA730D347')

select m.HS_PART as part_id,m.id m_part_id,IIF(mBom.state = 'Pending','',c.bom_id) as bom_id ,c.id as craft_data_id from innovator.HS_PROCESS_MATERIAL m
left join innovator.CRAFTDATA c on m.id = c.PART_ID
left join innovator.HS_PROCESS_ROUTE mBom on mBom.id = c.BOM_ID
where m.HS_PART in('EA0FE750784E4A9099EA34BCA730D347')

select *
from innovator.PART
where id = 'EA0FE750784E4A9099EA34BCA730D347';


update innovator.HS_PROCESS_MATERIAL set HS_PART = 'EA0FE750784E4A9099EA34BCA730D347' where id = '98E34A13C5E946B1AB6C72ECA84BE426'
update innovator.CRAFTDATA set PART_ID = '98E34A13C5E946B1AB6C72ECA84BE426' where id ='242CE7421DEC455EB99CC34A183F00BD'

select * from innovator.CRAFTDATA
         where parent_id = '242CE7421DEC455EB99CC34A183F00BD'
           and id in ('5C5D7AC351E6413989794E7AE3E92CF4','A042FDEBA87B422B893DC662B163E967')


select bom.RELATED_ID as part_id,bom.SOURCE_ID as parent_part_id,c.id as c_id,PREVIOUS_ID,PARENT_ID,BOM_ID from innovator.PART_BOM bom
left join innovator.HS_PROCESS_MATERIAL mPart on mPart.HS_PART = bom.RELATED_ID
left join innovator.CRAFTDATA c on c.PART_ID = mPart.id
where SOURCE_ID in ('EA0FE750784E4A9099EA34BCA730D347')


with recursiveT as (
    select SOURCE_ID,RELATED_ID from innovator.PART_BOM
    where SOURCE_ID in ('2294C557065A4547B9BF6D631F75B9C0','9CA5EF2E693D4EB889C4616FA83BE760')
    union all
    select bom.SOURCE_ID,bom.RELATED_ID from innovator.PART_BOM bom
    inner join recursiveT on recursiveT.RELATED_ID = bom.SOURCE_ID
)
select SOURCE_ID as parent_id, RELATED_ID as id from recursiveT