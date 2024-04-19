 WITH RecursiveCTE AS (
                    -- 递归的起始点
                    SELECT source_id,
                           RELATED_ID,
                           hs_QUANTITY             QUANTITY,
                           SORT_ORDER              SortOrder
                    FROM innovator.hs_mbom
                    WHERE source_id = (
                        select id from innovator.HS_PROCESS_MATERIAL where HS_PART = 'CE528724737E41B2AD5642272DDE80F0') -- 指定一个特定的起始点

                    UNION ALL

                    -- 递归查询部分
                    SELECT bom.source_id,
                           bom.RELATED_ID,
                           bom.hs_QUANTITY          as QUANTITY,
                           bom.SORT_ORDER           as SortOrder
                    FROM innovator.hs_mbom bom
                             INNER JOIN RecursiveCTE rcte ON bom.source_id = rcte.RELATED_ID)
                -- 零件与零件之间的关系只能有一种，去重
                SELECT distinct source_id ParentPartId, RELATED_ID PartId, quantity, SortOrder
                FROM RecursiveCTE
                order by SortOrder



                 select MPart.id                    PartId,
                       MPart.HS_NUMBER        PartNumber,
                       MPart.HS_NAME          PartName,
                       MPart.HS_PART               EPartId,
                       Part.MAJOR_REV              PartVersion,
                       Part.GENERATION             PartGeneration,
                       MPart.HS_TYPE         PartCategory,
                       isnull(Part.UNIT, N'个') as Unit,
                       State.name                  PartState,
                       MPart.CREATED_ON            CreateOn,
                       u.KEYED_NAME                CreateBy,
                       MPart.HS_PROCESS_CARD    as ProcessCard
                from innovator.HS_PROCESS_MATERIAL MPart
                         left join innovator.PART Part on Part.id = MPart.HS_PART
                         left join innovator.LIFE_CYCLE_STATE State on MPart.CURRENT_STATE = State.ID
                         left join innovator.[USER] U on U.id = MPart.CREATED_BY_ID
                where MPart.id in ('BC450C5DD6BC4EB3A0A79DE117B81278')


                 select MPart.id                    PartId,
                       MPart.HS_NUMBER        PartNumber,
                       MPart.HS_NAME          PartName,
                       MPart.HS_PART               EPartId,
                       Part.MAJOR_REV              PartVersion,
                       Part.GENERATION             PartGeneration,
                       MPart.HS_TYPE         PartCategory,
                       isnull(Part.UNIT, N'个') as Unit,
                       State.name                  PartState,
                       MPart.CREATED_ON            CreateOn,
                       u.KEYED_NAME                CreateBy,
                       MPart.HS_PROCESS_CARD    as ProcessCard
                from innovator.HS_PROCESS_MATERIAL MPart
                         left join innovator.PART Part on Part.id = MPart.HS_PART
                         left join innovator.LIFE_CYCLE_STATE State on MPart.CURRENT_STATE = State.ID
                         left join innovator.[USER] U on U.id = MPart.CREATED_BY_ID
                where MPart.id in ('{string.Join("','", partList)}')