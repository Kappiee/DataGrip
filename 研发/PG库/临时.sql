SELECT aid.id,
       aid.rollup_lead_identity   AS assigned_to,
       ad.related_id              AS item,
       it_ad.id                   AS item_type_id,
       p.keyed_name               AS formname,
       a.rollup_date_start_sched  AS start_date,
       a.rollup_date_due_sched    AS due_date,
       a.message                  AS instructions,
       '1'::text                  AS my_assignment,
       a.name,
       p.id                       AS container,
       it_p.id                    AS container_type_id,
       CASE
           WHEN a.state::text = 'Active'::text THEN '待办'::text
           WHEN p.state::text = 'Closed'::text OR p.state::text = 'Active'::text AND a.state::text = 'Complete'::text
               THEN '已办'::text
           ELSE '其他'::text
           END                    AS status,
       a.classification,
       a.keyed_name,
       a.created_on,
       a.created_by_id,
       a.owned_by_id,
       a.managed_by_id,
       a.modified_on,
       a.modified_by_id,
       aid.current_state,
       aid.state,
       aid.locked_by_id,
       a.is_current,
       a.major_rev,
       a.minor_rev,
       a.is_released,
       a.not_lockable,
       a.css,
       a.generation,
       a.new_version,
       a.id                       AS config_id,
       a.permission_id,
       a.team_id,
       it2.open_icon              AS icon,
       NULL::character varying(3) AS language_code_filter
FROM innovator.projectactivity a
         JOIN innovator.alias als ON a.created_by_id = als.source_id
         JOIN (SELECT a2.id,
                      a2.rollup_lead_identity,
                      a2.locked_by_id,
                      a2.id AS actid,
                      a2.state,
                      a2.current_state
               FROM innovator.projectactivity a2
               WHERE a2.rollup_lead_identity IS NOT NULL
                 AND NOT (EXISTS (SELECT 1
                                  FROM innovator.pa_rel_assignment
                                  WHERE pa_rel_assignment.related_id = a2.rollup_lead_identity
                                    AND pa_rel_assignment.source_id = a2.id
                                    AND a2.is_current = '1'::bpchar))
               UNION ALL
               SELECT tmp_aa.id,
                      tmp_aa.related_id,
                      tmp_aa.locked_by_id,
                      tmp_aa.source_id AS actid,
                      CASE
                          WHEN tmp_aa.state::text = 'Complete'::text THEN tmp_aa.state
                          ELSE tmp_a.state
                          END          AS state,
                      CASE
                          WHEN tmp_aa.state::text = 'Complete'::text THEN tmp_aa.current_state
                          ELSE tmp_a.current_state
                          END          AS current_state
               FROM innovator.pa_rel_assignment tmp_aa
                        JOIN innovator.projectactivity tmp_a ON tmp_a.id = tmp_aa.source_id
               WHERE tmp_a.is_current = '1'::bpchar) aid ON a.id = aid.actid
         JOIN innovator.project p ON (p.state::text = 'Active'::text OR p.state::text = 'Closed'::text) AND
                                     (a.proj_num::text = p.project_number::character varying(50)::text OR
                                      a.proj_num::text = p.id::character varying(50)::text) AND p.is_current = '1'::bpchar
         LEFT JOIN (SELECT a2d.id,
                           a2d.source_id,
                           a2d.related_id
                    FROM innovator.pa_rel_deliverable a2d) ad
                   ON a.id = ad.source_id AND ad.related_id IS NOT NULL AND ad.id = (SELECT pa_rel_deliverable.id
                                                                                      FROM innovator.pa_rel_deliverable
                                                                                      WHERE pa_rel_deliverable.source_id = a.id
                                                                                        AND pa_rel_deliverable.related_id IS NOT NULL
                                                                                        AND p.is_current = '1'::bpchar
                                                                                      LIMIT 1)
         JOIN innovator.itemtype it_ad ON it_ad.name::text = 'Deliverable'::text
         JOIN innovator.itemtype it_p ON it_p.name::text = 'Project'::text
         JOIN innovator.itemtype it2 ON it2.name::text = 'Project Task'::text
WHERE a.is_current = '1'::bpchar ;


select keyed_name,label_zc from innovator.itemtype where implementation_type = 'polymorphic'


select * from innovator.inbasket_task