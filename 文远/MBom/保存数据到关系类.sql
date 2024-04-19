

--查到物料编码则更新，否则则新增
MERGE INTO innovator.HS_PROCESS_MATERIAL AS Target
USING (VALUES ( @hs_part, @hs_name, @hs_number, @hs_type
              , @id, @config_id, @keyed_name, @created_on, @modified_on, @is_current, @major_rev, @is_released
              , @not_lockable, @generation, @modified_by_id, @created_by_id, @permission_id, @current_state)) AS Source
    (hs_part, hs_name, hs_number, hs_type, id, config_id, keyed_name, created_on, modified_on, is_current, major_rev,
     is_released, not_lockable, generation, modified_by_id, created_by_id, permission_id, current_state)
ON Target.HS_PART = Source.hs_part
WHEN MATCHED THEN
    UPDATE
    SET Target.hs_name   = Source.hs_name,
        target.hs_number = Source.hs_number,
        target.hs_type   = Source.hs_type
WHEN NOT MATCHED THEN
    INSERT    (hs_part, hs_name, hs_number, hs_type,
               id, config_id, keyed_name, created_on, modified_on, is_current, major_rev,
     is_released, not_lockable, generation, modified_by_id, created_by_id, permission_id, current_state)
    VALUES (Source.hs_part, Source.hs_name, Source.hs_number, Source.hs_type,
            Source.id, Source.config_id, Source.keyed_name, Source.created_on, Source.modified_on, Source.is_current, Source.major_rev,
            Source.is_released, Source.not_lockable, Source.generation , Source.modified_by_id, Source.created_by_id, Source.permission_id, Source.current_state);


--删除原有数据
delete innovator.HS_PROCESS_ROUTE_REF_MDATA
where SOURCE_ID = '';


select HS_NUMBER Number , Id
from innovator.HS_PROCESS_MATERIAL MPart ;

select *
from innovator.LIFE_CYCLE_STATE
where id = '17C93C6DA294420281A7CFB51CE1C50D';


select PART.CURRENT_STATE
from innovator.PART

