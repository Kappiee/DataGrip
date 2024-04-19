select *
from innovator.HS_PROCESS_MATERIAL MPart
where MPart.id = '7D8E4386D730421C8602299CC2749D1C'

select Step.HS_PS Ps,Step.hs_hour Hour
from Demo12SP18.innovator.HS_PROCESS_CARD_REL_STEP Step
join innovator.HS_PROCESS_CARD Card on Card.id = Step.SOURCE_ID
where Card.id = 'FB231315C6C6484CB13DFEC2A10BD996'


select HS_SELECT,HS_HOUR,hs_quantity
from innovator.HS_PM_REL_MBOM MBom
where SOURCE_ID = '7830CDACE407404CACD63DBFFDAB6F59'
and RELATED_ID = 'CA9DF2391F1743889D3082CD7393E9DC'
union
select HS_SELECT,HS_HOUR,hs_quantity
from innovator.HS_PM_REL_MBOM MBom
where SOURCE_ID = '7830CDACE407404CACD63DBFFDAB6F59'
and RELATED_ID = '374C764257264E16A37B4B3C31206CA1'


update  innovator.HS_PM_REL_MBOM set HS_SELECT = 0,HS_HOUR = t.hs_quantity*t.HS_HOUR
from (
select id,HS_HOUR,hs_quantity from innovator.HS_PM_REL_MBOM MBom
where SOURCE_ID = '7830CDACE407404CACD63DBFFDAB6F59'
and RELATED_ID = '374C764257264E16A37B4B3C31206CA1'
) as t
where HS_PM_REL_MBOM.id = t.id




--刷新子阶所有的工时与选定状态
WITH RecursiveCTE AS (
    -- 递归的起始点
    SELECT source_id, RELATED_ID, id
    FROM innovator.HS_PM_REL_MBOM
    WHERE source_id = '7830CDACE407404CACD63DBFFDAB6F59' -- 指定一个特定的起始点

    UNION ALL

    -- 递归查询部分
    SELECT bom.source_id,
           bom.RELATED_ID,
           bom.id

    FROM innovator.HS_PM_REL_MBOM bom
             INNER JOIN RecursiveCTE rcte ON bom.source_id = rcte.RELATED_ID)
-- 零件与零件之间的关系只能有一种，去重

update innovator.HS_PM_REL_MBOM set HS_SELECT = 0,HS_HOUR = 0
where id in (SELECT id
             FROM RecursiveCTE)