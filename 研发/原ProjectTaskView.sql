SELECT aid.id,
       aid.MANAGED_BY_ID          AS ASSIGNED_TO,
       ad.RELATED_ID              AS ITEM,
       it_ad.ID                   AS ITEM_TYPE_ID,
       p.keyed_name               AS formName,
       a.DATE_START_SCHED         AS START_DATE,
       a.DATE_DUE_SCHED           AS DUE_DATE,
       a.MESSAGE                  AS INSTRUCTIONS,
       '1'                        AS MY_ASSIGNMENT,
       a.NAME,
       p.id                       AS CONTAINER,
       it_p.ID                    AS CONTAINER_TYPE_ID,
       CASE
           WHEN a.STATE = N'Active' THEN '待办'
           WHEN (p.STATE = N'Closed') OR
                ((p.STATE = N'Active') AND (a.STATE = N'Complete')) THEN '已办'
           ELSE '其他' END        AS STATUS,
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
       it2.OPEN_ICON              AS icon,
       CONVERT(NVARCHAR(3), NULL) AS language_code_filter
FROM innovator.ACTIVITY2 AS a
         INNER JOIN innovator.ALIAS AS als ON a.CREATED_BY_ID = als.SOURCE_ID
         INNER JOIN
     (SELECT id, MANAGED_BY_ID, LOCKED_BY_ID, id AS actid, STATE, CURRENT_STATE
      FROM innovator.ACTIVITY2 AS a2
      WHERE (MANAGED_BY_ID IS NOT NULL)
        AND (NOT (id IN
                  (SELECT SOURCE_ID
                   FROM innovator.ACTIVITY2_ASSIGNMENT
                   WHERE (RELATED_ID = a2.MANAGED_BY_ID)
                     AND (SOURCE_ID = a2.id)
                     AND (a2.IS_CURRENT = '1'))))
      UNION ALL
      SELECT tmp_aa.id,
             tmp_aa.RELATED_ID,
             tmp_aa.LOCKED_BY_ID,
             tmp_aa.SOURCE_ID                                                           AS actid,
             CASE WHEN tmp_aa.STATE = 'Complete' THEN tmp_aa.STATE ELSE tmp_a.STATE END AS STATE,
             CASE WHEN tmp_aa.STATE = 'Complete' THEN tmp_aa.CURRENT_STATE ELSE tmp_a.CURRENT_STATE END
                                                                                        AS CURRENT_STATE
      FROM innovator.ACTIVITY2_ASSIGNMENT AS tmp_aa
               INNER JOIN
           innovator.ACTIVITY2 AS tmp_a ON tmp_a.id = tmp_aa.SOURCE_ID
      WHERE (tmp_a.IS_CURRENT = '1')) AS aid ON a.id = aid.actid
         INNER JOIN
     innovator.PROJECT AS p ON (p.STATE = N'Active' OR
                                p.STATE = N'Closed') AND p.PROJECT_NUMBER = a.PROJ_NUM AND p.IS_CURRENT = '1'
         LEFT OUTER JOIN
     (SELECT id, SOURCE_ID, RELATED_ID
      FROM innovator.ACTIVITY2_DELIVERABLE AS a2d) AS ad
     ON a.id = ad.SOURCE_ID AND ad.RELATED_ID IS NOT NULL AND ad.id IN
                                                              (SELECT TOP (1) id
                                                               FROM innovator.ACTIVITY2_DELIVERABLE
                                                               WHERE (SOURCE_ID = a.id)
                                                                 AND (RELATED_ID IS NOT NULL)
                                                                 AND (p.IS_CURRENT = '1'))
         INNER JOIN
     innovator.ITEMTYPE AS it_ad ON it_ad.NAME = 'Deliverable'
         INNER JOIN
     innovator.ITEMTYPE AS it_p ON it_p.NAME = 'Project'
         INNER JOIN
     innovator.ITEMTYPE AS it2 ON it2.NAME = N'Project Task'
WHERE (a.IS_CURRENT = '1')