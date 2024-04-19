WITH RecursiveCTE AS (
    -- 递归的起始点
    SELECT source_id,
           RELATED_ID,
           hs_QUANTITY             QUANTITY,
           SORT_ORDER              SortOrder,
           hs_hour              as Hour,
           HS_LOCK              as IsLock,
           ISNULL(HS_SELECT, 0) as IsSelect,
           isnull(HS_BIND, 0)   as IsBind,
           HS_BIND_NUMBER       as BindNumber
    FROM innovator.HS_PM_REL_MBOM
    WHERE source_id = '0D41797AC3804105853DD47BA10592BC' -- 指定一个特定的起始点

    UNION ALL

    -- 递归查询部分
    SELECT bom.source_id,
           bom.RELATED_ID,
           bom.hs_QUANTITY          as QUANTITY,
           bom.SORT_ORDER           as SortOrder,
           bom.HS_HOUR              as Hour,
           bom.HS_LOCK              as IsLock,
           ISNULL(bom.hs_select, 0) as IsSelect,
           isnull(bom.HS_BIND, 0)   as IsBind,
           bom.HS_BIND_NUMBER       as BindNumber
    FROM innovator.HS_PM_REL_MBOM bom
             INNER JOIN RecursiveCTE rcte ON bom.source_id = rcte.RELATED_ID)
-- 零件与零件之间的关系只能有一种，去重
SELECT distinct source_id  ParentPartId,
                RELATED_ID PartId,
                quantity,
                SortOrder,
                Hour,
                IsLock,
                IsSelect,
                IsBind,
                BindNumber
FROM RecursiveCTE
order by SortOrder


select MPart.id                    PartId,
       MPart.HS_PART_NUMBER        PartNumber,
       MPart.HS_PART_NAME          PartName,
       MPart.HS_PART               EPartId,
       Part.MAJOR_REV              PartVersion,
       Part.GENERATION             PartGeneration,
       isnull(Part.UNIT, N'个') as Unit,
       State.name                  PartState,
       MPart.CREATED_ON            CreateOn,
       u.KEYED_NAME                CreateBy,
       MPart.thumbnail          as Image,
       MPart.HS_PROCESS_CARD    as ProcessCard,

from innovator.HS_PROCESS_MATERIAL MPart
         left join innovator.PART Part on Part.id = MPart.HS_PART
         left join innovator.LIFE_CYCLE_STATE State on MPart.CURRENT_STATE = State.ID
         left join innovator.[USER] U on U.id = MPart.CREATED_BY_ID
where MPart.id in ('2D8D171843AB4F5886B87DB9B5734E3E')


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
       MPart.thumbnail          as               Image,
       MPart.HS_PROCESS_CARD    as               ProcessCard
from innovator.HS_PM_REL_MBOM MBom
         left join innovator.HS_PROCESS_MATERIAL MPart on MPart.id = MBom.RELATED_ID
         left join innovator.PART Part on Part.id = MPart.HS_PART
         left join innovator.LIFE_CYCLE_STATE State on MPart.CURRENT_STATE = State.ID
         left join innovator.[USER] U on U.id = coalesce(Part.CREATED_BY_ID, MPart.CREATED_BY_ID)
where MBom.hs_card_id = '{rootFormId}'


--查询零件的详细信息
select MPart.id                    PartId,
       MPart.HS_PART_NUMBER        PartNumber,
       MPart.HS_PART_NAME          PartName,
       MPart.HS_PART               EPartId,
       Part.MAJOR_REV              PartVersion,
       Part.GENERATION             PartGeneration,
       isnull(Part.UNIT, N'个') as Unit,
       State.name                  PartState,
       MPart.CREATED_ON            CreateOn,
       u.KEYED_NAME                CreateBy,
       MPart.thumbnail          as Image,
       MPart.HS_PROCESS_CARD    as ProcessCard
from innovator.HS_PROCESS_MATERIAL MPart
         left join innovator.PART Part on Part.id = MPart.HS_PART
         left join innovator.LIFE_CYCLE_STATE State on Part.CURRENT_STATE = State.ID
         left join innovator.[USER] U on U.id = Part.CREATED_BY_ID
where MPart.id in
      ('A957E049BEE74BEE985B81F9AD3DF89D', '31C0AC6096D64B6DA616BE19D269FB2E', 'C543ACB0CA434729BA3F41FEF56C4CFE',
       '26D2707DB75C462FA24CDF17DFACF487', '4A35A0ED7A3D4B49B4CC1B10E5C67C2C', 'D0F334632DCB4EA0AA5D8E4BDB85DEEB',
       '37AC6A82642B41EEBBD797A10E2BD75A', '82DF5C966730489BA080E1F71DA2B340', '87DE00C9C0DC4E0AA27E137CD99A2B0E')


--查询物料编号对应的id
select PART.ID as PartId, MPart.Id as MPartId, MPart.HS_PART_NUMBER
from innovator.HS_PROCESS_MATERIAL MPart
         join innovator.part on PART.ITEM_NUMBER = MPart.HS_PART_NUMBER
where MPart.HS_PART_NUMBER in
      ('MP2954', 'MP1705', 'MP2607', 'MP2607', 'MP2966', 'MP2959', 'MP2505', 'OP1', 'MP2506', 'MP1708', 'MP2685',
       'MP2675', 'MP2350', 'MP2589', '10448127-H10', '10448127-H6', '10448127-H4', '91-10448127-J1101-1-2',
       '10448127-H5', '10448127-H3', '91-10448127-J1101-1-1', '91-10448127-J1101', 'MP2590', 'MP1872', 'MP1994',
       'MP1703', 'MP1915', 'MP1701', 'MP1707', 'MP1606', 'MP0429');

--查询物料编号对应的id
select PART.ID as PartId, MPart.Id as MPartId, MPart.HS_PART_NUMBER
from innovator.HS_PROCESS_MATERIAL MPart
         join innovator.part on PART.ITEM_NUMBER = MPart.HS_PART_NUMBER
where MPart.HS_PART_NUMBER in
      ('91-10448127-J1101');


