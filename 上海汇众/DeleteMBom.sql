select *
from innovator.HS_PM_REL_MBOM
where SOURCE_ID = '87DE00C9C0DC4E0AA27E137CD99A2B0E'

select * from innovator.HS_PM_REL_MBOM
where id = '8C2E455463FF4059915CBCCBBB0C53B9'

--删除所有MBOM
WITH RecursiveCTE AS (
    -- 递归的起始点
    SELECT source_id, RELATED_ID, id
    FROM innovator.HS_PM_REL_MBOM
    WHERE source_id = 'FB1D71DE0A354BDE8484D8039E82BAED' -- 指定一个特定的起始点

    UNION ALL

    -- 递归查询部分
    SELECT bom.source_id,
           bom.RELATED_ID,
           bom.id

    FROM innovator.HS_PM_REL_MBOM bom
             INNER JOIN RecursiveCTE rcte ON bom.source_id = rcte.RELATED_ID)
-- 零件与零件之间的关系只能有一种，去重

delete innovator.HS_PM_REL_MBOM
where id in (SELECT id
             FROM RecursiveCTE)


--查询所有路径的ID
WITH RecursiveCTE AS (SELECT source_id, RELATED_ID, id
FROM innovator.HS_PM_REL_MBOM
WHERE source_id = 'FB1D71DE0A354BDE8484D8039E82BAED' -- 指定一个特定的起始点

UNION ALL

-- 递归查询部分
SELECT bom.source_id,
     bom.RELATED_ID,
     bom.id

FROM innovator.HS_PM_REL_MBOM bom
       INNER JOIN RecursiveCTE rcte ON bom.source_id = rcte.RELATED_ID)
SELECT id
FROM RecursiveCTE



--查询路径上的所有零件编号
WITH RecursiveCTE AS (
SELECT source_id, RELATED_ID, id
FROM innovator.HS_PM_REL_MBOM
WHERE source_id = '2D881448E04C4C679596ED4F797462D3' -- 指定一个特定的起始点

UNION ALL

-- 递归查询部分
SELECT bom.source_id,
     bom.RELATED_ID,
     bom.id

FROM innovator.HS_PM_REL_MBOM bom
       INNER JOIN RecursiveCTE rcte ON bom.source_id = rcte.RELATED_ID)
SELECT '|'+ Mpart.HS_PART_NUMBER
FROM RecursiveCTE as R
left join innovator.HS_PM_REL_MBOM Mbom on Mbom.id = R.id
left join innovator.HS_PROCESS_MATERIAL Mpart on (Mpart.id = Mbom.RELATED_ID or Mpart.id = Mbom.SOURCE_ID)
for xml path('')


update innovator.HS_PROCESS_MATERIAL set HS_PROCESS_CARD = null where id = '5030551CD83B4ABCA48B03E9D977BEE8'
update innovator.HS_PROCESS_CARD set HS_PROCESS_MATERIAL = null where id = '2C25DBCB5109494ABF968DEC926C0DBF'


select id
from innovator.HS_PM_REL_MBOM
where RELATED_ID = '5030551CD83B4ABCA48B03E9D977BEE8'

delete
from innovator.HS_PM_REL_MBOM
where id = '40AE5D67E7EF42739187FFB787E3B908'