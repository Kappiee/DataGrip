CREATE VIEW [Project_Task_Step02_Create_Tmp_View]
AS
SELECT aid.ID,
       aid.MANAGED_BY_ID          AS ASSIGNED_TO,
       ad.RELATED_ID              AS ITEM,
       it_ad.ID                   AS ITEM_TYPE_ID,
       a.DATE_START_SCHED         AS START_DATE,
       a.DATE_DUE_SCHED           AS DUE_DATE,
       a.MESSAGE                  AS INSTRUCTIONS,
       '1'                        AS MY_ASSIGNMENT,
       a.NAME,
       p.ID                       AS CONTAINER,
       it_p.ID                    AS CONTAINER_TYPE_ID,
       aid.STATE                  AS STATUS,
       is_mine = '0',
       is_waiting =
               CASE
                 WHEN a.STATE = N'Active' THEN '1'
                 ELSE '0'
               END,
        is_done =
               CASE
                  WHEN (p.STATE = N'Closed') OR
                ((p.STATE = N'Active') AND (a.STATE = N'Complete')) THEN '1'
                 ELSE '0'
               END,
       a.CLASSIFICATION,
       a.KEYED_NAME,
       a.CREATED_ON,
       a.CREATED_BY_ID,
       a.OWNED_BY_ID,
       a.MANAGED_BY_ID,
       a.MODIFIED_ON,
       a.MODIFIED_BY_ID,
       aid.CURRENT_STATE,
       aid.STATE,
       aid.LOCKED_BY_ID,
       a.IS_CURRENT,
       a.MAJOR_REV,
       a.MINOR_REV,
       a.IS_RELEASED,
       a.NOT_LOCKABLE,
       a.CSS,
       a.GENERATION,
       a.NEW_VERSION,
       a.CONFIG_ID,
       a.PERMISSION_ID,
       a.TEAM_ID,
       it2.open_icon              as icon,
       CONVERT(NVARCHAR(3), NULL) AS language_code_filter,
       a.date_due_sched AS CLOSED_DATE
FROM innovator.ACTIVITY2 AS a
         INNER JOIN
     (SELECT ID, MANAGED_BY_ID, LOCKED_BY_ID, ID AS actid, STATE, CURRENT_STATE
      FROM innovator.ACTIVITY2 AS a2
      WHERE (MANAGED_BY_ID IS NOT NULL)
        AND (NOT (ID IN
                  (SELECT SOURCE_ID
                   FROM innovator.ACTIVITY2_ASSIGNMENT
                   WHERE (RELATED_ID = a2.MANAGED_BY_ID)
                     AND (SOURCE_ID = a2.ID))))
      UNION ALL
      SELECT tmp_aa.ID,
             tmp_aa.RELATED_ID,
             tmp_aa.LOCKED_BY_ID,
             tmp_aa.SOURCE_ID                                                                           AS actid,
             CASE WHEN tmp_aa.STATE = 'Complete' THEN tmp_aa.STATE ELSE tmp_a.STATE END                 AS STATE,
             CASE WHEN tmp_aa.STATE = 'Complete' THEN tmp_aa.CURRENT_STATE ELSE tmp_a.CURRENT_STATE END AS CURRENT_STATE
      FROM innovator.ACTIVITY2_ASSIGNMENT AS tmp_aa
               INNER JOIN innovator.ACTIVITY2 tmp_a ON tmp_a.ID = tmp_aa.SOURCE_ID) AS aid ON a.ID = aid.actid
         INNER JOIN
     innovator.PROJECT AS p ON p.STATE = N'Active' AND p.PROJECT_NUMBER = a.PROJ_NUM
         LEFT OUTER JOIN
     (SELECT ID, SOURCE_ID, RELATED_ID
      FROM innovator.ACTIVITY2_DELIVERABLE AS a2d) AS ad
     ON a.ID = ad.SOURCE_ID AND ad.RELATED_ID IS NOT NULL AND ad.ID IN
                                                              (SELECT TOP (1) ID
                                                               FROM innovator.ACTIVITY2_DELIVERABLE
                                                               WHERE (SOURCE_ID = a.ID)
                                                                 AND (RELATED_ID IS NOT NULL))
         INNER JOIN
     innovator.ITEMTYPE AS it_ad ON it_ad.NAME = 'Deliverable'
         INNER JOIN
     innovator.ITEMTYPE AS it_p ON it_p.NAME = 'Project'
         INNER JOIN
     innovator.ITEMTYPE AS it2 ON it2.NAME = N'Project Task'
