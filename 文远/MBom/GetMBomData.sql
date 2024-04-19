--先查找关系

select MBom.Id,
       MBom.HS_PARENT Parentid
from innovator.HS_PROCESS_ROUTE_REF_MDATA MBom
         left join innovator.HS_PROCESS_MATERIAL MPart on MPart.id = MBom.RELATED_ID
where MBom.SOURCE_ID = '0BC78B170A2443AB8353569A9DA2BAD1'
order by MBom.SORT_ORDER

--虚拟取自身的创建时间，创建者取自身的创建者
select MBom.Id,
       MPart.HS_PART                                                                      PartId,
       MBom.HS_PARENT                                                                     MBomParentId,
       MPart.HS_NUMBER                                                                    PartNumber,
       MPart.HS_NAME                                                                      PartName,
       MPart.HS_TYPE                                                                      PartCategory,
       isnull(Part.MAJOR_REV, 'A')                                                        PartVersion,
       isnull(Part.GENERATION, '1')                                                       PartGeneration,
       isnull(Part.HS_UNIT, N'个') as                                                     Unit,
       State.LABEL_ZC                                                                     PartState,
       isnull(State.LABEL, State.NAME)                                                    PartEnState,
       isnull(Part.CREATED_ON, MPart.CREATED_ON)                                          CreateOn,
       u.KEYED_NAME CreateBy,
       MBom.HS_QUANTITY                                                                   Quantity,
       MBom.HS_PROCESS_CARD                                                               ProcessCard,
       MBom.SORT_ORDER                                                                    SortOrder
from innovator.HS_PROCESS_ROUTE_REF_MDATA MBom
         left join innovator.HS_PROCESS_MATERIAL MPart on MPart.id = MBom.RELATED_ID
         left join innovator.PART Part on Part.id = MPart.HS_PART
         left join innovator.LIFE_CYCLE_STATE State on MPart.CURRENT_STATE = State.ID
         left join innovator.[USER] U on U.id = coalesce(Part.CREATED_BY_ID, MPart.CREATED_BY_ID)
where MBom.SOURCE_ID = '0BC78B170A2443AB8353569A9DA2BAD1'


delete innovator.HS_PROCESS_ROUTE_REF_MDATA
where SOURCE_ID = '0BC78B170A2443AB8353569A9DA2BAD1'
delete
from innovator.HS_PROCESS_MATERIAL


select id
from innovator.HS_PROCESS_MATERIAL;

select id
from innovator.HS_PROCESS_ROUTE_REF_MDATA;



--虚拟取自身的创建时间，创建者取自身的创建者
select MBom.Id,
       MPart.HS_PART                                                                      PartId,
       MBom.HS_PARENT                                                                     MBomParentId,
       MPart.HS_NUMBER                                                                    PartNumber,
       MPart.HS_NAME                                                                      PartName,
       MPart.HS_TYPE                                                                      PartCategory,
       isnull(Part.MAJOR_REV, 'A')                                                        PartVersion,
       isnull(Part.GENERATION, '1')                                                       PartGeneration,
       isnull(Part.HS_UNIT, N'个') as                                                     Unit,
       State.LABEL_ZC                                                                     PartState,
       isnull(State.LABEL, State.NAME)                                                    PartEnState,
       isnull(Part.CREATED_ON, MPart.CREATED_ON)                                          CreateOn,
       u.KEYED_NAME CreateBy,
       MBom.HS_QUANTITY                                                                   Quantity,
       MBom.HS_PROCESS_CARD                                                               ProcessCard,
       MBom.SORT_ORDER                                                                    SortOrder
from innovator.HS_PROCESS_ROUTE_REF_MDATA MBom
         left join innovator.HS_PROCESS_MATERIAL MPart on MPart.id = MBom.RELATED_ID
         left join innovator.PART Part on Part.id = MPart.HS_PART
         left join innovator.LIFE_CYCLE_STATE State on MPart.CURRENT_STATE = State.ID
         left join innovator.[USER] U on U.id = coalesce(Part.CREATED_BY_ID, MPart.CREATED_BY_ID)



