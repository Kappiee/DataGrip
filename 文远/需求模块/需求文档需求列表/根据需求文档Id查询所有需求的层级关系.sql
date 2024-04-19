WITH RecursiveCTE AS (
    -- 递归的起始点
    SELECT source_id,
           RELATED_ID,
           SORT_ORDER SortOrder
    FROM innovator.hs_requirement_rel_requirement
    WHERE source_id in (select related_id
                        from innovator.re_Req_Doc_rel_Requirement
                        where source_id = 'EBAB8528EA734CD8AA54CB0B3366D6D2') -- 指定一个特定的起始点

    UNION ALL

    -- 递归查询部分
    SELECT bom.source_id,
           bom.RELATED_ID,
           bom.SORT_ORDER as SortOrder
    FROM innovator.hs_requirement_rel_requirement bom
             INNER JOIN RecursiveCTE rcte ON bom.source_id = rcte.RELATED_ID)
-- 零件与零件之间的关系只能有一种，去重
SELECT distinct source_id ParentId, RELATED_ID Id, SortOrder
FROM RecursiveCTE
union
select null ParentId, reqDoc.RELATED_ID Id,reqDoc.SORT_ORDER SortOrder
from innovator.re_Req_Doc_rel_Requirement reqDoc
where reqDoc.source_id = 'EBAB8528EA734CD8AA54CB0B3366D6D2'
order by SortOrder



--'4C9C1C2D68624BE7A5E490D3C10D0E1A','675602D596164EBB8B3C2D1692C0EB68','0B47055CC5B044D98C36BF405DD9DB65','69ECDD23CD4247D386F4DA5079BE1EF0'

select req.item_number                      as ItemNumber,
       req.req_title_zc                     as Title,
       req.req_discription                  as Description,
       cValue.label_zc                      as Category,
       pValue.label_zc                      as ProductLine,
       managed.keyed_name                   as ManagedById,
       owned.keyed_name                     as OwnerById,
       gValue.label_zc                      as GroupId,
       state.label_zc                       as State,
       req.major_rev                        as MajorRev,
       modelReq.keyed_name                  as Model,
       IIF(req.hs_is_model = 1, N'是', N'否') as IsModel
from innovator.re_requirement req
         left join innovator.list cList on cList.name = 'RE Requirement Category'
         left join innovator.list pList on pList.name = 'RE Requirement hs_product_line'
         left join innovator.list gList on gList.name = 'RE Requirement Group'
         left join innovator.[identity] managed on managed.id = req.managed_by_id
         left join innovator.[identity] owned on owned.id = req.owned_by_id
         left join innovator.value cValue on cValue.source_id = cList.id and req.req_category = cValue.value
         left join innovator.value pValue on pValue.source_id = pList.id and req.hs_product_line = pValue.value
         left join innovator.value gValue on gValue.source_id = gList.id and req.req_group = gValue.value
         left join innovator.LIFE_CYCLE_STATE state on state.id = req.current_state
         left join innovator.re_requirement modelReq on modelReq.id = req.hs_model
where req.id in
      ('4C9C1C2D68624BE7A5E490D3C10D0E1A', '675602D596164EBB8B3C2D1692C0EB68', '0B47055CC5B044D98C36BF405DD9DB65',
       '69ECDD23CD4247D386F4DA5079BE1EF0')

select related_id as id,sort_order as SortOrder
from innovator.re_Req_Doc_rel_Requirement
where source_id = 'EBAB8528EA734CD8AA54CB0B3366D6D2'
order by SortOrder


    WITH RecursiveCTE AS (
                    -- 递归的起始点
                    SELECT source_id,
                           RELATED_ID,
                           SORT_ORDER              SortOrder
                    FROM innovator.hs_requirement_rel_requirement
                    WHERE source_id = '0B47055CC5B044D98C36BF405DD9DB65' -- 指定一个特定的起始点

                    UNION ALL

                    -- 递归查询部分
                    SELECT bom.source_id,
                           bom.RELATED_ID,
                           bom.SORT_ORDER           as SortOrder
                    FROM innovator.hs_requirement_rel_requirement bom
                             INNER JOIN RecursiveCTE rcte ON bom.source_id = rcte.RELATED_ID)
                -- 零件与零件之间的关系只能有一种，去重
                SELECT distinct source_id ParentId, RELATED_ID Id, SortOrder
                FROM RecursiveCTE
                order by SortOrder

select *
from innovator.hs_requirement_rel_requirement
where hs_number = '0B47055CC5B044D98C36BF405DD9DB65'