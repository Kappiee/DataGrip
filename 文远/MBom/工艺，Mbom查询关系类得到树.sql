select Part.HS_NUMBER                PartNumber,
       Part.HS_NAME                       PartName,
       Part.HS_TYPE             PartCategory,
       Part.MAJOR_REV                  PartVersion,
       Part.GENERATION                 PartGeneration,
       isnull(Part.HS_UNIT, N'个') as  Unit,
       State.LABEL_ZC                  PartState,
       isnull(State.LABEL, State.NAME) PartEnState,
       Part.CREATED_ON                 CreateOn,
       u.KEYED_NAME                    CreateBy
from innovator.HS_PROCESS_ROUTE_REF_MDATA Rel
         left join innovator.HS_PROCESS_MATERIAL Part
         left join innovator.LIFE_CYCLE_STATE State on Part.CURRENT_STATE = State.ID
         left join innovator.[USER] U on U.id = Part.CREATED_BY_ID;
