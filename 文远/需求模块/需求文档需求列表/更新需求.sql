update innovator.RE_REQUIREMENT
set REQ_DISCRIPTION = @description
where id = @id;


 WITH RecursiveCTE AS (
    -- 递归的起始点
    SELECT source_id,
           RELATED_ID,
           Id
    FROM innovator.hs_requirement_rel_requirement
    WHERE source_id in (
        select related_id from innovator.re_Req_Doc_rel_Requirement where source_id = '{docId}') -- 指定一个特定的起始点

    UNION ALL

    -- 递归查询部分
    SELECT bom.source_id,
           bom.RELATED_ID,
           Id
    FROM innovator.hs_requirement_rel_requirement bom
             INNER JOIN RecursiveCTE rcte ON bom.source_id = rcte.RELATED_ID)
delete innovator.hs_mbom
    where id in (SELECT id
                 FROM RecursiveCTE)


update innovator.re_Req_Doc_rel_Requirement
set sort_order = @sort_order
where source_id = @source_id and related_id = @related_id;
