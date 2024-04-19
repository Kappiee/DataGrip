--查询零件的详细信息
select MBom.Id,
       MBom.related_id                           PartId,
       MPart.HS_PART                             EPartId,
       MBom.SOURCE_ID                            PartParentId,
       MPart.HS_PART_NUMBER                      PartNumber,
       MPart.HS_PART_NAME                        PartName,
       isnull(Part.MAJOR_REV, 'A')               PartVersion,
       isnull(Part.GENERATION, '1')              PartGeneration,
       isnull(Part.UNIT, N'个') as               Unit,
       State.name                                PartState,
       isnull(Part.CREATED_ON, MPart.CREATED_ON) CreateOn,
       u.KEYED_NAME                              CreateBy,
       MBom.HS_QUANTITY                          Quantity,
       MBom.SORT_ORDER                           SortOrder,
       MPart.thumbnail          as               Image,
       MBom.HS_LOCK             as               IsLock,
       MBom.HS_HOUR             as               Hour,
       MPart.HS_PROCESS_CARD    as               ProcessCard,
         MBom.hs_card_id                           MBomId
from innovator.HS_PM_REL_MBOM MBom
         left join innovator.HS_PROCESS_MATERIAL MPart on MPart.id = MBom.RELATED_ID
         left join innovator.PART Part on Part.id = MPart.HS_PART
         left join innovator.LIFE_CYCLE_STATE State on MPart.CURRENT_STATE = State.ID
         left join innovator.[USER] U on U.id = coalesce(Part.CREATED_BY_ID, MPart.CREATED_BY_ID)
where MBom.hs_card_id = 'AA24074EAAFC41CE9A5F69637E162A58'


select * from innovator.HS_PM_REL_MBOM where SOURCE_ID = 'AA24074EAAFC41CE9A5F69637E162A58'

--父零件
select null,
       MPart.id                                  PartId,
       MPart.HS_PART                             EPartId,
       null                                      PartParentId,
       MPart.HS_PART_NUMBER                      PartNumber,
       MPart.HS_PART_NAME                        PartName,
       isnull(Part.MAJOR_REV, 'A')               PartVersion,
       isnull(Part.GENERATION, '1')              PartGeneration,
       isnull(Part.UNIT, N'个') as               Unit,
       State.name                                PartState,
       isnull(Part.CREATED_ON, MPart.CREATED_ON) CreateOn,
       u.KEYED_NAME                              CreateBy,
       '1'                                       Quantity,
       '0'                                       SortOrder,
       MPart.thumbnail          as               Image,
       '0'                      as               IsLock,
       '0'                      as               Hour,
       MPart.HS_PROCESS_CARD    as               ProcessCard
from innovator.HS_PROCESS_MATERIAL MPart
         left join innovator.PART Part on MPart.HS_PART = Part.id
         left join innovator.LIFE_CYCLE_STATE State on MPart.CURRENT_STATE = State.ID
         left join innovator.[USER] U on U.id = coalesce(Part.CREATED_BY_ID, MPart.CREATED_BY_ID)
where MPart.id = '5030551CD83B4ABCA48B03E9D977BEE8'


select *
from innovator.HS_PROCESS_MATERIAL
where id = 'B803619D9D5B4FAFBB4FEA8526903D7B'

-- update innovator.HS_PM_REL_MBOM set hs_card_id = '2C25DBCB5109494ABF968DEC926C0DBF' where hs_card_id = '14E600F0D12B4AAAB7983FD991F554C1'

--查询零件的详细信息
select distinct MBom.Id,
                MBom.related_id                           PartId,
                MBom.SOURCE_ID                            MBomParentId,
                MPart.HS_PART_NUMBER                      PartNumber,
                MPart.HS_PART_NAME                        PartName,
                isnull(Part.MAJOR_REV, 'A')               PartVersion,
                isnull(Part.GENERATION, '1')              PartGeneration,
                isnull(Part.UNIT, N'个') as               Unit,
                State.name                                PartState,
                isnull(Part.CREATED_ON, MPart.CREATED_ON) CreateOn,
                u.KEYED_NAME                              CreateBy,
                MBom.HS_QUANTITY                          Quantity,
                MBom.SORT_ORDER                           SortOrder,
                MPart.thumbnail          as               Image,
                MBom.HS_LOCK             as               IsLock,
                MBom.HS_HOUR             as               Hour
from innovator.HS_PM_REL_MBOM MBom
         left join innovator.HS_PROCESS_MATERIAL MPart on MPart.id = MBom.RELATED_ID or MPart.id = MBom.SOURCE_ID
         left join innovator.PART Part on Part.id = MPart.HS_PART
         left join innovator.LIFE_CYCLE_STATE State on MPart.CURRENT_STATE = State.ID
         left join innovator.[USER] U on U.id = coalesce(Part.CREATED_BY_ID, MPart.CREATED_BY_ID)
where MBom.hs_card_id = 'C5BA8D11B0F14E1BA4F0EFB8341D09F8'


select HS_PROCESS_CARD
from innovator.HS_PROCESS_MATERIAL
where id = '5030551CD83B4ABCA48B03E9D977BEE8'

--AA24074EAAFC41CE9A5F69637E162A58
         select PART.ID as PartId , MPart.Id as MPartId
            from innovator.HS_PROCESS_MATERIAL MPart
            join innovator.part on PART.ITEM_NUMBER = MPart.hsP
            where MPart.HS_PART_NUMBER in ('MP2953');


