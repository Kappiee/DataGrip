  MERGE INTO innovator.HS_PROCESS_MATERIAL AS Target
            USING (VALUES ( @hs_part, @hs_name, @hs_number, @hs_type,@hs_process_card,@hs_process_material_type,@hs_part_colour,@hs_part_picture
                          ,@hs_software_version,@hs_dedicated_or_not,@hs_special_properties,@hs_module_from,@hs_workstation,@hs_torque,@hs_update_detail,@hs_description
                          , @id, @config_id, @keyed_name, @created_on, @modified_on, @is_current, @major_rev, @is_released
                          , @not_lockable, @generation, @modified_by_id, @created_by_id, @permission_id, @current_state)) AS Source
                (hs_part, hs_name, hs_number, hs_type, hs_process_card, hs_process_material_type, hs_part_colour, hs_part_picture
                          , hs_software_version, hs_dedicated_or_not, hs_special_properties, hs_module_from, hs_workstation, hs_torque, hs_update_detail, hs_description
                    , id, config_id, keyed_name, created_on, modified_on, is_current, major_rev,
                 is_released, not_lockable, generation, modified_by_id, created_by_id, permission_id, current_state)
            ON Target.hs_number = Source.hs_number
            WHEN MATCHED THEN
                UPDATE
                SET Target.hs_name   = Source.hs_name,
                    target.hs_part = Source.hs_part,
                    target.hs_type   = Source.hs_type,
                    target.hs_process_card = Source.hs_process_card,
                    target.KEYED_NAME = Source.KEYED_NAME,
                    target.hs_process_material_type = Source.hs_process_material_type,
                    target.hs_part_colour = Source.hs_part_colour,
                    target.hs_part_picture = Source.hs_part_picture,
                    target.hs_software_version = Source.hs_software_version,
                    target.hs_dedicated_or_not = Source.hs_dedicated_or_not,
                    target.hs_special_properties = Source.hs_special_properties,
                    target.hs_module_from = Source.hs_module_from,
                    target.hs_workstation = Source.hs_workstation,
                    target.hs_torque = Source.hs_torque,
                    target.hs_update_detail = Source.hs_update_detail,
                    target.hs_description = Source.hs_description
            WHEN NOT MATCHED THEN
                INSERT    (hs_part, hs_name, hs_number, hs_type,hs_process_card,hs_process_material_type,hs_part_colour,hs_part_picture
                            ,hs_software_version,hs_dedicated_or_not,hs_special_properties,hs_module_from,hs_workstation,hs_torque,hs_update_detail,hs_description
                           ,id, config_id, keyed_name, created_on, modified_on, is_current, major_rev,
                 is_released, not_lockable, generation, modified_by_id, created_by_id, permission_id, current_state)
                VALUES (Source.hs_part, Source.hs_name, Source.hs_number, Source.hs_type,Source.hs_process_card,Source.hs_process_material_type,Source.hs_part_colour,Source.hs_part_picture
                        ,Source.hs_software_version,Source.hs_dedicated_or_not,Source.hs_special_properties,Source.hs_module_from,Source.hs_workstation,Source.hs_torque,Source.hs_update_detail,Source.hs_description
                        ,Source.id, Source.config_id, Source.keyed_name, Source.created_on, Source.modified_on, Source.is_current, Source.major_rev,
                        Source.is_released, Source.not_lockable, Source.generation , Source.modified_by_id, Source.created_by_id, Source.permission_id, Source.current_state);


