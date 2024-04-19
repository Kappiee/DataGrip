                WITH RecursiveCTE AS (
                    -- 递归的起始点
                    SELECT source_id,RELATED_ID, QUANTITY , SORT_ORDER SortOrder
                    FROM innovator.PART_BOM
                    WHERE source_id = '5CC84159332642568CF40AD9E17822EE' -- 指定一个特定的起始点

                    UNION ALL

                    -- 递归查询部分
                    SELECT bom.source_id,bom.RELATED_ID, bom.QUANTITY, bom.SORT_ORDER as SortOrder
                    FROM innovator.PART_BOM bom
                    INNER JOIN RecursiveCTE rcte ON bom.source_id = rcte.RELATED_ID
                )
                -- 零件与零件之间的关系只能有一种，去重
                SELECT distinct source_id ParentId,RELATED_ID PartId, quantity,SortOrder FROM RecursiveCTE
                order by SortOrder


                                select
                       Part.ID                         PartId,
                       Part.ID                         EPartId,
                       Part.ITEM_NUMBER                PartNumber,
                       Part.NAME                       PartName,
                       Part.HS_LARGE_CLASS     PartCategory,
                       Part.MAJOR_REV                  PartVersion,
                       Part.GENERATION                 PartGeneration,
                       isnull(Part.HS_UNIT, N'个') as  Unit,
                       State.LABEL_ZC                  PartState,
                       isnull(State.LABEL, State.NAME) PartEnState,
                       Part.CREATED_ON                 CreateOn,
                       u.KEYED_NAME                    CreateBy
                from innovator.PART Part
                         left join innovator.LIFE_CYCLE_STATE State on Part.CURRENT_STATE = State.ID
                         left join innovator.[USER] U on U.id = Part.CREATED_BY_ID
                where Part.id in ('5CC84159332642568CF40AD9E17822EE')