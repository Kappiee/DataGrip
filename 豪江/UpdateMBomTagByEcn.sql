

select craft.id craft_id,
       BOM_ID,
       PART_ID m_part_id,
       mPart.HS_PART as part_id,
       craft.PARENT_ID craft_parent_id,
       craft.PREVIOUS_ID craft_previous_id
from innovator.CRAFTDATA craft
left join innovator.HS_PROCESS_MATERIAL mPart on mPart.id =  craft.PART_ID
where BOM_ID in (
select id
from innovator.HS_PROCESS_ROUTE
where HS_EBOM = '342B87AEDBBE4944AB740F59340163FE' and HS_PROCESS_ROUTE.IS_CURRENT = 1
)

select id,STATE
from innovator.HS_PROCESS_ROUTE
where HS_EBOM in ('AA4F89B3050844099B3662520353C6DC')

select mPart.id as m_part_id,PART.ID as part_id from innovator.PART
left join innovator.HS_PROCESS_MATERIAL mPart on mPart.HS_PART = PART.ID
where PART.ID in ('34DE0C83656A43FC9F04B32C8D661EBD') and mPart.IS_CURRENT = '1'


select mPart.id as m_part_id,PART.ID as part_id from innovator.PART
left join innovator.HS_PROCESS_MATERIAL mPart on mPart.HS_PART = PART.ID
where PART.ID in ('9BE315ACFBC74022B475DC03EC5DA579','AD696B9DC2804B6AB2218D5D01CBD345','34DE0C83656A43FC9F04B32C8D661EBD','6B8D211AA1E4474F97AFA4FEA483F0CC','A1FF23DA86C6461E95FC2B4BA72EA61C','AD696B9DC2804B6AB2218D5D01CBD345','7EF569720859414C95316AFAD7D5729D','34DE0C83656A43FC9F04B32C8D661EBD','9BE315ACFBC74022B475DC03EC5DA579','9BE315ACFBC74022B475DC03EC5DA579','9BE315ACFBC74022B475DC03EC5DA579')
  and mPart.IS_CURRENT = '1'

select
       craftData.BOM_ID as Bom_Id
from innovator.CRAFTDATA craftData


select MBom.id as BOM_ID,Mbom.STATE,PART.ID as impact_part_id from innovator.HS_PROCESS_ROUTE MBom
join innovator.CRAFTDATA craftData on craftData.BOM_ID = MBom.id and MBom.IS_CURRENT = 1
join innovator.HS_PROCESS_MATERIAL mPart on mPart.id = craftData.PART_ID and mPart.IS_CURRENT = 1
join innovator.PART on PART.ID = mPart.HS_PART and PART.IS_CURRENT = 1
where PART.ID in ('62CB17720FBC40EC80807038C2B170FF')

select craftData.id as craft_id,
       craftData.BOM_ID as bom_id,
       craftData.PREVIOUS_ID as previous_id,
       craftData.PARENT_ID as parent_id,
       MPart.id as m_part_id,
       Part.id as part_id,
       parentPART.ID as parent_part_id
from innovator.craftData craftData
join innovator.HS_PROCESS_ROUTE MBom on MBom.id = craftData.BOM_ID and MBom.IS_CURRENT = 1
join innovator.CRAFTDATA parentCraftData on parentCraftData.id = craftData.PARENT_ID
join innovator.HS_PROCESS_MATERIAL parentMPart on parentMPart.id = parentCraftData.PART_ID and parentMPart.IS_CURRENT = 1
join innovator.PART parentPART on parentPART.ID = parentMPart.HS_PART and parentPART.IS_CURRENT = 1
join innovator.HS_PROCESS_MATERIAL MPart on MPart.id = craftData.PART_ID and MPart.IS_CURRENT = 1
join innovator.PART Part on Part.ID = MPart.HS_PART and Part.IS_CURRENT = 1
where parentPART.ID in ('62CB17720FBC40EC80807038C2B170FF')

--85A8E098E119469BA94FF41D9B83E6D9
select PART.ID part_id,MPart.Id as m_part_id from innovator.HS_PROCESS_MATERIAL MPart
right join innovator.PART on PART.ID = MPart.HS_PART
where part.id in ('9A0710973F64468F813D6DCFE74BDFC3','5EC290D0412640DD88C50BA4AD859A1D','62CB17720FBC40EC80807038C2B170FF','62CB17720FBC40EC80807038C2B170FF')

