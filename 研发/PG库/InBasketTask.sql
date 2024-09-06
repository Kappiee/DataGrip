SELECT act_asgn.ID,
       act_asgn.RELATED_ID AS ASSIGNED_TO,
       wfl.SOURCE_ID AS ITEM,
       wfl.SOURCE_TYPE AS ITEM_TYPE_ID,
       CASE
           WHEN lang.CODE = 'en' THEN t.label_plural
           WHEN lang.CODE = 'zh' THEN t.label_plural_zc
       END AS formName,
       act.ACTIVE_DATE AS START_DATE,
       act.ACTIVE_DATE + INTERVAL '1 day' * COALESCE(act.EXPECTED_DURATION, 0) AS DUE_DATE,
       COALESCE(CASE WHEN lang.CODE = 'en' THEN act.MESSAGE END, act.MESSAGE) AS INSTRUCTIONS,
       '1' AS MY_ASSIGNMENT,
       COALESCE(CASE
                    WHEN lang.CODE = 'en' THEN act.label
                    WHEN lang.CODE = 'zh' THEN act.label_zc
                END, act.label, act.NAME) AS NAME,
       wfl_proc.ID AS CONTAINER,
       it.ID AS CONTAINER_TYPE_ID,
       CASE
           WHEN (als.related_id = act_asgn.related_id)
                AND (wfl_proc.STATE = 'Active')
                AND (act.STATE = 'Closed')
                AND (wfl_proc.CREATED_BY_ID = act_asgn.created_by_id) THEN '审核中'
           WHEN (act.STATE = 'Active')
                AND (act_asgn.path IS NULL OR act_asgn.path = '') THEN '待办'
           WHEN act_asgn.path IS NOT NULL OR act_asgn.path != '' THEN '已办'
           ELSE '其他'
       END AS STATUS,
       act.CLASSIFICATION,
       act.KEYED_NAME,
       act_asgn.CREATED_ON,
       act_asgn.CREATED_BY_ID,
       act.OWNED_BY_ID,
       act.MANAGED_BY_ID,
       act_asgn.MODIFIED_ON,
       act_asgn.MODIFIED_BY_ID,
       act.CURRENT_STATE,
       act.STATE,
       act_asgn.LOCKED_BY_ID,
       act_asgn.IS_CURRENT,
       act_asgn.MAJOR_REV,
       act_asgn.MINOR_REV,
       act_asgn.IS_RELEASED,
       act_asgn.NOT_LOCKABLE,
       act.CSS,
       act_asgn.GENERATION,
       act_asgn.NEW_VERSION,
       '00000000000000000000000000000000' AS CONFIG_ID, /* a trick to avoid duplicates while Outer Join on CONFIG_ID column by Innovator Server core*/
       act_asgn.PERMISSION_ID,
       act_asgn.TEAM_ID,
       it2.open_icon AS icon,
       lang.code AS language_code_filter
FROM innovator.WORKFLOW AS wfl
         INNER JOIN innovator.WORKFLOW_PROCESS AS wfl_proc ON wfl.RELATED_ID = wfl_proc.ID
         INNER JOIN innovator.ITEMTYPE t ON t.id = wfl.SOURCE_TYPE
         INNER JOIN innovator.ALIAS als ON wfl_proc.CREATED_BY_ID = als.SOURCE_ID
         INNER JOIN innovator.WORKFLOW_PROCESS_ACTIVITY AS wp_act ON wfl_proc.ID = wp_act.SOURCE_ID
         INNER JOIN innovator.ACTIVITY AS act ON wp_act.RELATED_ID = act.ID
         INNER JOIN innovator.ACTIVITY_ASSIGNMENT AS act_asgn ON act.ID = act_asgn.SOURCE_ID
         INNER JOIN innovator.ITEMTYPE AS it ON it.NAME = 'Workflow Process'
         INNER JOIN innovator.ITEMTYPE AS it2 ON it2.NAME = 'Workflow Task'
         LEFT OUTER JOIN innovator.LANGUAGE AS lang ON lang.ID IS NOT NULL
WHERE wfl_proc.STATE != 'Cancelled'
  AND act_asgn.IS_DISABLED = '0'
  AND act.IS_AUTO = '0'
  AND (wfl.behavior = 'float' OR wfl.behavior = 'hard_float');
