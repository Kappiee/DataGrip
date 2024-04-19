            --删除原有数据
            WITH RecursiveCTE AS (
                    -- 递归的起始点
                    SELECT source_id, RELATED_ID, id
                    FROM innovator.hs_mbom
                    WHERE source_id = '30465A1270864Dc689F100F32650C9C2' -- 指定一个特定的起始点

                    UNION ALL

                    -- 递归查询部分
                    SELECT bom.source_id,
                           bom.RELATED_ID,
                           bom.id

                    FROM innovator.hs_mbom bom
                             INNER JOIN RecursiveCTE rcte ON bom.source_id = rcte.RELATED_ID)
                -- 零件与零件之间的关系只能有一种，去重

                delete innovator.hs_mbom
                where id in (SELECT id
                             FROM RecursiveCTE)