WITH RecursiveCTE AS (
     -- 递归的起始点
     SELECT source_id,
            RELATED_ID,
            IsNull(HS_QUANTITY, 1) AS QUANTITY,
            1                      AS LEVEL
     FROM innovator.CAD_Structure
     WHERE source_id = 'BEE28C6CE8024706AD791B6902A8EB36' -- 指定一个特定的起始点

     UNION ALL

     -- 递归查询部分
     SELECT bom.source_id,
            bom.RELATED_ID,
            IsNull(HS_QUANTITY, 1) AS QUANTITY,
            rcte.LEVEL + 1
     FROM innovator.CAD_Structure bom
              INNER JOIN RecursiveCTE rcte ON bom.source_id = rcte.RELATED_ID
     ), CadBomRes
	AS(select distinct *
              from RecursiveCTE
        union
       select null as source_id,'BEE28C6CE8024706AD791B6902A8EB36' as RELATED_ID,1 as QUANTITY,0 as LEVEL
      )
select CadBomRes.*,Cad.STATE,Cad.CLASSIFICATION,Cad.CREATED_BY_ID from CadBomRes
left join innovator.CAD on CadBomRes.RELATED_ID = innovator.CAD.ID




create procedure hs_auditGetCadBom(@cad_id char(32))
AS
BEGIN

    WITH RecursiveCTE AS (
         -- 递归的起始点
         SELECT source_id,
                RELATED_ID,
                IsNull(HS_QUANTITY, 1) AS QUANTITY,
                1                      AS LEVEL
         FROM innovator.CAD_Structure
         WHERE source_id = @cad_id -- 指定一个特定的起始点

         UNION ALL

         -- 递归查询部分
         SELECT bom.source_id,
                bom.RELATED_ID,
                IsNull(HS_QUANTITY, 1) AS QUANTITY,
                rcte.LEVEL + 1
         FROM innovator.CAD_Structure bom
                  INNER JOIN RecursiveCTE rcte ON bom.source_id = rcte.RELATED_ID
         ), CadBomRes
        AS(select distinct *
                  from RecursiveCTE
            union
           select null as source_id,@cad_id as RELATED_ID,1 as QUANTITY,0 as LEVEL
          )
    select CadBomRes.*,Cad.STATE,Cad.CLASSIFICATION,Cad.CREATED_BY_ID from CadBomRes
    left join innovator.CAD on CadBomRes.RELATED_ID = innovator.CAD.ID

END
