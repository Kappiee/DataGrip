WITH RecursiveCTE AS (
    -- 递归的起始点
    SELECT source_id,RELATED_ID, QUANTITY, '' as MEDIEM_CLASS
    FROM innovator.PART_BOM
    WHERE source_id = '9A9EC48CD3B04766A9B4DDFC10CE722A' -- 指定一个特定的起始点

    UNION ALL

    -- 递归查询部分
    SELECT bom.source_id,bom.RELATED_ID, bom.QUANTITY ,part.HS_MEDIEM_CLASS as MEDIEM_CLASS
    FROM innovator.PART_BOM bom
             INNER JOIN RecursiveCTE rcte ON bom.source_id = rcte.RELATED_ID
             INNER join innovator.PART part on bom.RELATED_ID = part.ID
)
-- 零件与零件之间的关系只能有一种，去重
SELECT distinct source_id ParentId,RELATED_ID PartId, quantity,MEDIEM_CLASS FROM RecursiveCTE




--C8F203936336481A8EC573E85BC9B9DB
--6825EC595EA14716A4B4C2B13ADC1104