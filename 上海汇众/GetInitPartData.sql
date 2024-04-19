select Part.ID                         PartId,
       Part.ID                         EPartId,
       Part.ITEM_NUMBER                PartNumber,
       Part.NAME                       PartName,
       Part.MAJOR_REV                  PartVersion,
       Part.GENERATION                 PartGeneration,
       isnull(Part.UNIT, N'个') as     Unit,
       State.name                      PartState,
       isnull(State.LABEL, State.NAME) PartEnState,
       Part.CREATED_ON                 CreateOn,
       u.KEYED_NAME                    CreateBy,
       Part.thumbnail           as     Image
from innovator.PART Part
         left join innovator.LIFE_CYCLE_STATE State on Part.CURRENT_STATE = State.ID
         left join innovator.[USER] U on U.id = Part.CREATED_BY_ID


select *
from innovator.HS_PROCESS_MATERIAL
where id = '2D8D171843AB4F5886B87DB9B5734E3E';


select PART.ID as PartId, MPart.Id as MPartId
from innovator.HS_PROCESS_MATERIAL MPart
         join innovator.part on PART.ITEM_NUMBER = MPart.HS_PART_NUMBER