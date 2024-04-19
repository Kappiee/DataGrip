    MERGE INTO innovator.HS_PROCESS_MATERIAL AS Target
    USING (VALUES ( @hs_part, @hs_part_name, @hs_part_number ,@thumbnail,@hs_process_card
                  , @id, @config_id, @keyed_name, @created_on, @modified_on, @is_current, @major_rev, @is_released
                  , @not_lockable, @generation, @modified_by_id, @created_by_id, @permission_id, @current_state)) AS Source
        (hs_part, hs_part_name, hs_part_number, thumbnail, hs_process_card, id, config_id, keyed_name, created_on, modified_on, is_current, major_rev,
         is_released, not_lockable, generation, modified_by_id, created_by_id, permission_id, current_state)
    ON Target.hs_part_number = Source.hs_part_number
    WHEN MATCHED THEN
        UPDATE
        SET Target.hs_part_name   = Source.hs_part_name,
            target.hs_part = Source.hs_part,
            target.thumbnail = Source.thumbnail,
            target.hs_process_card = Source.hs_process_card,
            Target.KEYED_NAME = Source.KEYED_NAME
    WHEN NOT MATCHED THEN
        INSERT    (hs_part, hs_part_name, hs_part_number,thumbnail,hs_process_card,classification,
                   id, config_id, keyed_name, created_on, modified_on, is_current, major_rev,
         is_released, not_lockable, generation, modified_by_id, created_by_id, permission_id, current_state)
        VALUES (Source.hs_part, Source.hs_part_name, Source.hs_part_number,Source.thumbnail,Source.hs_process_card,N'制造零件',
                Source.id, Source.config_id, Source.keyed_name, Source.created_on, Source.modified_on, Source.is_current, Source.major_rev,
                Source.is_released, Source.not_lockable, Source.generation , Source.modified_by_id, Source.created_by_id, Source.permission_id, Source.current_state);


    update innovator.HS_PROCESS_MATERIAL
    set CLASSIFICATION = N'制造零件'
    where id = 'C543ACB0CA434729BA3F41FEF56C4CFE';