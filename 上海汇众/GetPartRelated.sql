--找到同一个source_id的数据为多个的source_id
select SOURCE_ID, count(1)
from innovator.PART_BOM
group by SOURCE_ID;

select KEYED_NAME
from innovator.PART
where id = 'DA0B2D33098B4DE1BC3C00DCE49395A1';

--查询该id下所有的父子关系
WITH RecursiveCTE AS (
    -- 递归的起始点
    SELECT source_id, RELATED_ID, QUANTITY , SORT_ORDER SortOrder , hs_hour as Hour
    FROM innovator.PART_BOM
    WHERE source_id = '14E600F0D12B4AAAB7983FD991F554C1' -- 指定一个特定的起始点
    UNION ALL

    -- 递归查询部分
    SELECT bom.source_id, bom.RELATED_ID, bom.QUANTITY, bom.SORT_ORDER as SortOrder , bom.HS_HOUR as Hour
    FROM innovator.PART_BOM bom
             INNER JOIN RecursiveCTE rcte ON bom.source_id = rcte.RELATED_ID)
-- 零件与零件之间的关系只能有一种，去重
SELECT distinct source_id ParentPartId, RELATED_ID id, quantity , SortOrder, Hour
FROM RecursiveCTE
order by SortOrder
;

