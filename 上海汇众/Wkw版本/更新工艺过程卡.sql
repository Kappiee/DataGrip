update innovator.HS_TOOL_PROCESS_CARD
set hs_itemname       = '',
    hs_manu_part_no_a = '',
    where;

--使物料绑定最新的工艺卡
update innovator.HS_MANU_PART
set HS_PROCESS_CARD = (select top 1 id
                       from innovator.HS_TOOL_PROCESS_CARD
                       where HS_MANU_PART_NO_A = '60F40AF2E6F44A37B5A54863180A1764'
                       order by created_on desc)
where id = '60F40AF2E6F44A37B5A54863180A1764';


select id as CardId, HS_MANU_PART_NO_A as PartId
from innovator.HS_TOOL_PROCESS_CARD
where HS_MANU_PART_NO_A = '60F40AF2E6F44A37B5A54863180A1764'
order by created_on desc


select MPart.id                    PartId,
       MPart.HS_PART_NUMBER        PartNumber,
       MPart.hs_part_chinese_name  PartName,
       MPart.HS_PART               EPartId,
       Part.MAJOR_REV              PartVersion,
       Part.GENERATION             PartGeneration,
       isnull(Part.UNIT, N'个') as Unit,
       State.name                  PartState,
       MPart.CREATED_ON            CreateOn,
       u.KEYED_NAME                CreateBy,
       MPart.hs_part_image      as Image,
       MPart.HS_PROCESS_CARD    as ProcessCard,
--//新增字段标记--增加显示Part列
       MPart.MANAGED_BY_ID      as ManagedId,
       I.KEYED_NAME             as ManagedLabel,
       Card.hs_itemname         as ProcessCardName
from innovator.hs_manu_part MPart
         left join innovator.PART Part on Part.id = MPart.HS_PART
         left join innovator.LIFE_CYCLE_STATE State on MPart.CURRENT_STATE = State.ID
         left join innovator.[USER] U on U.id = MPart.CREATED_BY_ID
         left join innovator.[IDENTITY] I on I.ID = MPart.MANAGED_BY_ID
         left join innovator.hs_tool_process_card Card on MPart.HS_PROCESS_CARD = Card.id
where MPart.id = 'D3A3A3E3A3A34E3E8E3E3E3E3E3E3E3E'


WITH RecursiveCTE AS (
    -- 递归的起始点
    SELECT source_id,
           RELATED_ID,
           hs_count                QUANTITY,
           SORT_ORDER              SortOrder,
           hs_hour              as Hour,
           HS_LOCK              as IsLock,
           ISNULL(HS_SELECT, 0) as IsSelect,
           isnull(HS_BIND, 0)   as IsBind,
           HS_BIND_NUMBER       as BindNumber,
           --//新增字段标记--增加显示Bom列
           hs_weight            as Weight,
           hs_remark            as Remark,
           hs_equipment         as Equipment,
           hs_cutting_size      as CuttingSize,
           hs_blanking          as Blanking,
           hs_process           as Process
    FROM innovator.hs_manu_part_bom
    WHERE source_id = '60F40AF2E6F44A37B5A54863180A1764' -- 指定一个特定的起始点

    UNION ALL

    -- 递归查询部分
    SELECT bom.source_id,
           bom.RELATED_ID,
           bom.hs_count             as QUANTITY,
           bom.SORT_ORDER           as SortOrder,
           bom.HS_HOUR              as Hour,
           bom.HS_LOCK              as IsLock,
           ISNULL(bom.hs_select, 0) as IsSelect,
           isnull(bom.HS_BIND, 0)   as IsBind,
           bom.HS_BIND_NUMBER       as BindNumber,
           --//新增字段标记--增加显示Bom列
           hs_weight                as Weight,
           hs_remark                as Remark,
           hs_equipment             as Equipment,
           hs_cutting_size          as CuttingSize,
           hs_blanking              as Blanking,
           hs_process               as Process
    FROM innovator.hs_manu_part_bom bom
             INNER JOIN RecursiveCTE rcte ON bom.source_id = rcte.RELATED_ID)
-- 零件与零件之间的关系只能有一种，去重
SELECT distinct cte.source_id                  ParentPartId,
                cte.RELATED_ID                 PartId,
                quantity,
                SortOrder,
                Hour,
                IsLock,
                IsSelect,
                IsBind,
                BindNumber,
                --//新增字段标记--增加显示Bom列
                Weight,
                Remark,
                Equipment,
                CuttingSize,
                Blanking,
                Process
FROM RecursiveCTE as cte
order by SortOrder


WITH RecursiveCTE AS (
    -- 递归的起始点
    SELECT source_id,
           RELATED_ID
    FROM innovator.hs_manu_part_bom
    WHERE source_id = '60F40AF2E6F44A37B5A54863180A1764' -- 指定一个特定的起始点

    UNION ALL

    -- 递归查询部分
    SELECT bom.source_id,
           bom.RELATED_ID
    FROM innovator.hs_manu_part_bom bom
             INNER JOIN RecursiveCTE rcte ON bom.source_id = rcte.RELATED_ID)
-- 零件与零件之间的关系只能有一种，去重
SELECT distinct cte.source_id                  ParentPartId,
                cte.RELATED_ID                 PartId,
                process.HS_PROCESS_NAME     as processId,
                processList.HS_PROCESS_NAME as ProcessName,
                relProcess.id               as RelProcessId,
                relProcess.SOURCE_ID            as SOURCE_ID,
                MPart.HS_PROCESS_CARD       as ProcessCard
FROM RecursiveCTE as cte
         left join innovator.HS_MANU_PART MPart on MPart.id = cte.SOURCE_ID
         left join innovator.hs_process_card_rel_process relProcess
          on relProcess.HS_PS = cte.source_id + '|' + cte.RELATED_ID and MPart.HS_PROCESS_CARD = relProcess.source_id

         left join innovator.hs_tool_process process on process.id = relProcess.RELATED_ID
         left join innovator.HS_PROCESS_LIST processList on processList.id = process.HS_PROCESS_NAME
where process.HS_PROCESS_NAME  is not null


select ProcessList.HS_T1           as t1,
       ProcessList.HS_T2           as t2,
       ProcessList.HS_T3           as t3,
       ProcessList.HS_T4           as t4,
       Process.HS_PROCESS_NAME     as ProcessId,
       ProcessList.HS_PROCESS_NAME as ProcessName,
       RelProcess.HS_PS            as BomId,
       Card.id                     as ProcessCardId,
       RelProcess.id               as RelProcessId
from innovator.HS_TOOL_PROCESS_CARD Card
         left join innovator.HS_PROCESS_CARD_REL_PROCESS RelProcess on Card.id = RelProcess.SOURCE_ID
         left join innovator.HS_TOOL_PROCESS Process on RelProcess.RELATED_ID = Process.id
         left join innovator.HS_PROCESS_LIST ProcessList on Process.HS_PROCESS_NAME = ProcessList.id
where Card.id in ('CCDF3DA57B854064BBB507C7330C9E24')


select RelProcess.RELATED_ID
from innovator.HS_PROCESS_CARD_REL_PROCESS RelProcess
where RelProcess.id = ''

update innovator.HS_TOOL_PROCESS
set HS_PROCESS_NAME = ''
where id = (select RelProcess.RELATED_ID
from innovator.HS_PROCESS_CARD_REL_PROCESS RelProcess
where RelProcess.id = '');


update innovator.HS_PROCESS_CARD_REL_PROCESS
set HS_T1 =  ProcessList.HS_T1,
    HS_T2 =  ProcessList.HS_T2,
    HS_T3 =  ProcessList.HS_T3,
    HS_T4 =  ProcessList.HS_T4
where id = ''


select ProcessList.id    as Id,
       ProcessList.HS_T1 as T1,
       ProcessList.HS_T2 as T2,
       ProcessList.HS_T3 as T3,
       ProcessList.HS_T4 as T4
from innovator.HS_PROCESS_LIST ProcessList
where ProcessList.id in ('{string.Join("', '", existProcessCardList.Select(v => v.ProcessCard))}')


select hs_ps from innovator.HS_PROCESS_CARD_REL_PROCESS where SOURCE_ID ='A6FDBE0DAD9C4A068E82C79BB9315041'




