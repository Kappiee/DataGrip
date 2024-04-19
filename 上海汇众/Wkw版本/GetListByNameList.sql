select list.NAME,IIF('123'='123',VALUE.LABEL_ZC,VALUE.LABEL) as Label,VALUE.Value
from innovator.VALUE
join innovator.LIST on list.ID = value.source_id
where list.NAME in('hs_blanking','hs_mpBomEquipment');

 select MPart.id                    PartId,
   MPart.HS_PART_NUMBER        PartNumber,
   MPart.hs_part_chinese_name          PartName,
   MPart.HS_PART               EPartId,
   Part.MAJOR_REV              PartVersion,
   Part.GENERATION             PartGeneration,
   isnull(Part.UNIT, N'个') as Unit,
   State.name                  PartState,
   MPart.CREATED_ON            CreateOn,
   u.KEYED_NAME                CreateBy,
   MPart.hs_part_image          as Image,
   MPart.HS_PROCESS_CARD    as ProcessCard,
   MPart.MANAGED_BY_ID        as ManagedById,
    I.KEYED_NAME                as ManagedBy

from innovator.hs_manu_part MPart
     left join innovator.PART Part on Part.id = MPart.HS_PART
     left join innovator.LIFE_CYCLE_STATE State on MPart.CURRENT_STATE = State.ID
     left join innovator.[USER] U on U.id = MPart.CREATED_BY_ID
     left join innovator.[IDENTITY] I on I.ID = MPart.MANAGED_BY_ID
where MPart.MANAGED_BY_ID is not null

select HS_PART from innovator.hs_manu_part where id = '509DCA2C78C54FF3980AD649EAC2B757'


select CURRENT_STATE
from innovator.HS_TOOL_PROCESS_CARD
where id = '8C651E55661843779DFC9D212520E140'


