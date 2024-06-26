select Part.ID                         PartId,
       Part.ITEM_NUMBER                PartNumber,
       Part.NAME                       PartName,
       Part.HS_NAME_EN                 PartEnName,
       isnull(v.LABEL_ZC, v.LABEL)     PartCategory,
       Part.MAJOR_REV                  PartVersion,
       Part.GENERATION                 PartGeneration,
       isnull(Part.HS_UNIT, N'个') as  Unit,
       State.LABEL_ZC                  PartState,
       isnull(State.LABEL, State.NAME) PartEnState,
       Part.CREATED_ON                 CreateOn,
       u.KEYED_NAME                    CreateBy
from innovator.PART Part
         left join innovator.LIFE_CYCLE_STATE State on Part.CURRENT_STATE = State.ID
         left join innovator.[USER] U on U.id = Part.CREATED_BY_ID
         left join innovator.[LIST] l on l.name = 'hs_large_class'
         left join innovator.[VALUE] v on v.SOURCE_ID = l.ID and v.VALUE = Part.HS_LARGE_CLASS


select *
from innovator.LIFE_CYCLE_STATE
where id = 'EB5B395C3518438098B8EA33B92667F7';