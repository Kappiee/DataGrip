 WITH RecursiveCTE AS (
    -- 递归的起始点
    SELECT source_id,RELATED_ID, QUANTITY
    FROM innovator.PART_BOM
    WHERE source_id = '2E00DD06AB40408389A66126457EF747' -- 指定一个特定的起始点

    UNION ALL

    -- 递归查询部分
    SELECT bom.source_id,bom.RELATED_ID, bom.QUANTITY
    FROM innovator.PART_BOM bom
    INNER JOIN RecursiveCTE rcte ON bom.source_id = rcte.RELATED_ID
)
-- 零件与零件之间的关系只能有一种，去重
SELECT distinct source_id ParentId,RELATED_ID PartId, quantity, P.ITEM_NUMBER PartNumber FROM RecursiveCTE
left join innovator.PART P on p.id = RELATED_ID
union
SELECT '' '', quantity, P.ITEM_NUMBER PartNumber FROM RecursiveCTE
left join innovator.PART P on p.id = SOURCE_ID

 select ITEM_NUMBER PartNumber from innovator.PART where id ='5CC84159332642568CF40AD9E17822EE'

