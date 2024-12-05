-- CREATE VIEW [Workflow_Task_Step02_Create_Tmp_View]
-- AS
  SELECT act_asgn.ID, 
	act_asgn.COMMENTS,
	CASE WHEN lang.CODE = 'en' THEN act_asgn.PATH ELSE act_asgn.PATH_zc END AS path,
	act_asgn.RELATED_ID AS ASSIGNED_TO, 
	wfl.SOURCE_ID AS ITEM, wfl.SOURCE_TYPE AS ITEM_TYPE_ID, 
	act.ACTIVE_DATE AS START_DATE, 
	DATEADD(day, ISNULL(act.EXPECTED_DURATION, 0), 
	act.ACTIVE_DATE) AS DUE_DATE, COALESCE (CASE WHEN lang.CODE = 'en' THEN act.MESSAGE END, act.MESSAGE) AS INSTRUCTIONS, 
	'1' AS MY_ASSIGNMENT, COALESCE (CASE WHEN lang.CODE = 'en' THEN act.label ELSE act.label_zc END, act.LABEL, act.NAME) AS NAME, 
	wfl_proc.ID AS CONTAINER, 
	'261EAC08AE9144FC95C49182ACE0D3FE' AS CONTAINER_TYPE_ID, 
	CASE WHEN isnull(act_asgn.closed_on, '') = '' THEN '待办' ELSE '已办' END AS STATUS, 
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
	'00000000000000000000000000000000' 
	AS CONFIG_ID, 
	act_asgn.PERMISSION_ID, 
	act_asgn.TEAM_ID, 
	it2.OPEN_ICON AS icon, 
	lang.CODE AS language_code_filter,
	wfl.SOURCE_ID AS ITEM_ID,
	wfl.BEHAVIOR As BEHAVIOR
FROM innovator.WORKFLOW AS wfl
INNER JOIN innovator.WORKFLOW_PROCESS AS wfl_proc
	ON wfl.RELATED_ID = wfl_proc.ID
INNER JOIN innovator.WORKFLOW_PROCESS_ACTIVITY AS wp_act
	ON wfl_proc.ID = wp_act.SOURCE_ID
INNER JOIN innovator.ACTIVITY AS act
	ON wp_act.RELATED_ID = act.ID LEFT OUTER
JOIN innovator.LIFE_CYCLE_STATE AS LCS
	ON act.CURRENT_STATE = LCS.ID
INNER JOIN innovator.ACTIVITY_ASSIGNMENT AS act_asgn
	ON act.ID = act_asgn.SOURCE_ID
INNER JOIN innovator.ITEMTYPE AS it2
	ON it2.NAME = N'Workflow Task'
CROSS JOIN innovator.LANGUAGE AS lang
WHERE (wfl_proc.LOCKED_BY_ID IS NULL)
		AND (act_asgn.IS_DISABLED = '0')
		AND (act.IS_AUTO = '0')
		--AND (wfl.BEHAVIOR = 'float'
		--OR wfl.BEHAVIOR = 'hard_float')