update innovator.HS_PROCESS_MATERIAL
set CURRENT_STATE = '8478CF9C4C1440189AA5D5069A97A76B'
where id = 'E8DF8212F6444B7FA9979BA21E846AB4';


select main.NAME, rel.id
from innovator.LIFE_CYCLE_STATE rel
         join innovator.LIFE_CYCLE_MAP main on main.id = rel.SOURCE_ID
where rel.NAME = 'Pending'
  and (main.NAME = 'hs_process_material' or
       main.NAME = 'hs_process_route' or
       main.NAME = 'hs_process_card' or
       main.NAME = 'hs_standard_process'
    )


update innovator.hs_process_route
set CURRENT_STATE = ''
where id = '';
--更新MPart的生命周期
update innovator.HS_PROCESS_MATERIAL
set CURRENT_STATE = ''
where id in (
--查询需要更新MPart
    select MBom.RELATED_ID
    from innovator.HS_PROCESS_ROUTE_REF_MDATA MBom
    where MBom.SOURCE_ID = '');

--更新工艺过程卡的生命周期
update innovator.hs_process_card
set CURRENT_STATE = ''
where id in (
--查询需要更新
    select MBom.HS_PROCESS_CARD
    from innovator.HS_PROCESS_ROUTE_REF_MDATA MBom
    where MBom.SOURCE_ID = ''
      and HS_PROCESS_CARD is not null);

--更新工艺过程卡的生命周期
update innovator.hs_standard_process
set CURRENT_STATE = ''
where id in (
--查询需要更新
    select Standard.RELATED_ID
    from innovator.HS_PROCESS_ROUTE_REF_MDATA MBom
             join innovator.HS_PROCESS_CARD Card on Card.id = Mbom.HS_PROCESS_CARD
             join innovator.HS_PROCESS_CARD_REL_PROCESS Standard on Standard.SOURCE_ID = Card.id
    where MBom.SOURCE_ID = ''
      and HS_PROCESS_CARD is not null);





select main.NAME,rel.id from innovator.LIFE_CYCLE_STATE rel
    join innovator.LIFE_CYCLE_MAP main on main.id = rel.SOURCE_ID
    where rel.NAME = 'Review'
    and (main.NAME = 'hs_process_material' or
         main.NAME = 'hs_process_route' or
         main.NAME = 'hs_process_card' or
         main.NAME = 'hs_standard_process')

--hs_process_route,D1FCE2BAB62047019B95E838B1FF9B6F
--hs_process_card,C2661A68FD3F429088B95B89A86A27D2
--hs_standard_process,5F3FDC297B634710B88BB1DAF12B6EEC
--hs_process_material,8478CF9C4C1440189AA5D5069A97A76B


select id from innovator.HS_PROCESS_MATERIAL where HS_PART = 'CE528724737E41B2AD5642272DDE80F0'
--2D9BD61F8006456F9B0252C3A965AD9C

                    WITH RecursiveCTE AS (
                    -- 递归的起始点
                    SELECT source_id,
                           RELATED_ID
                    FROM innovator.hs_mbom
                    WHERE source_id = 'B72EC42658024B05807E7967DC74090D'
                         -- 指定一个特定的起始点

                    UNION ALL

                    -- 递归查询部分
                    SELECT bom.source_id,
                           bom.RELATED_ID
                    FROM innovator.hs_mbom bom
                             INNER JOIN RecursiveCTE rcte ON bom.source_id = rcte.RELATED_ID)
                -- 零件与零件之间的关系只能有一种，去重
                SELECT distinct source_id ParentPartId, RELATED_ID PartId
                FROM RecursiveCTE



--更新MPart的生命周期
    update innovator.HS_PROCESS_MATERIAL
    set CURRENT_STATE = '{hs_process_material_cycle_id}'
    where id in ('{mPartListStr}');

    --更新工艺过程卡的生命周期
    update innovator.hs_process_card
    set CURRENT_STATE = '{hs_process_card_id}'
    where id in (
         --查询需要更新
        select MPart.HS_PROCESS_CARD
        from innovator.HS_PROCESS_MATERIAL MPart
        where MPart.id in
              ('{mPartListStr}')
        );

    --更新标准卡的生命周期
     update innovator.hs_standard_process
    set CURRENT_STATE = '{hs_standard_process_id}'
    where id in (
    --查询需要更新
        select Standard.RELATED_ID
        from innovator.HS_PROCESS_MATERIAL MPart
                 join innovator.HS_PROCESS_CARD Card on Card.id = MPart.HS_PROCESS_CARD
                 join innovator.HS_PROCESS_CARD_REL_PROCESS Standard on Standard.SOURCE_ID = Card.id
        where MPart.id in
              ('{mPartListStr}')
        )


   select * from innovator.hs_process_card
    where id in (
        --查询需要更新
        select MPart.HS_PROCESS_CARD
        from innovator.HS_PROCESS_MATERIAL MPart
        where MPart.id in
              ('B72EC42658024B05807E7967DC74090D','4ED51143D754454A915C6096B8E891E5','0AF70354D03645219E459B716444DFC1','1BB8251AB69D4684A8DD4EC6DDF71518','5C44F84E155B4C28A934CB546EE3F8FE','6EC76F7ECCDA4E58A5752375A5B85674','C125407240E04A8291190C89098C53AC','C5B9FF6149664718AC06D30526CDC30F','CA6E3A50AA964002BBAEC7EB2F884FBB','F39F81E8A6D84EA480A17345B2A9D315','F6579FBA5C8E49BD828F402B2A2327B2')
        )



select names = (stuff((
            select distinct ','''+ id +'''' from innovator.part
            where and isnull(ITEM_NUMBER,'') != '' and is_current = 1
            for xml path('')),1,1,''))




select main.NAME,rel.id from innovator.LIFE_CYCLE_STATE rel
    join innovator.LIFE_CYCLE_MAP main on main.id = rel.SOURCE_ID
    where rel.NAME = 'BF854E88CA3C43F78F0AD0413A050F2F'
    and (main.NAME = 'hs_process_material' or
         main.NAME = 'hs_process_route' or
         main.NAME = 'hs_process_card' or
         main.NAME = 'hs_standard_process')