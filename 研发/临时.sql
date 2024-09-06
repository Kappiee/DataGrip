SELECT id,
        email,
        hs_partner,
        hs_public_login
FROM
    (SELECT workflow_process.id AS wid ,
        workflow_process.created_by_id ,
        workflow.source_id ,
        itemtype.[name] ,
        [user].id ,
        [user].email ,
        [user].hs_partner ,
        [user].hs_public_login ,
        isnull(activity.hs_notification_day,
        1) AS hs_notification_day ,
        convert(varchar(100),
        dateadd(hour,
        8,
        dateadd(day,
        isnull(activity.hs_notification_day,
        1),
        activity_assignment.created_on)),
        120) AS dueday ,
        convert(varchar(30),
        getdate(),
        120) AS nowday
    FROM innovator.activity
    LEFT JOIN innovator.workflow_process_activity
        ON workflow_process_activity.related_id=activity.id
    LEFT JOIN innovator.workflow_process
        ON workflow_process.id=workflow_process_activity.source_id
    LEFT JOIN innovator.workflow
        ON workflow_process.id=workflow.related_id
    LEFT JOIN innovator.itemtype
        ON itemtype.id=workflow.source_type
    LEFT JOIN innovator.activity_assignment
        ON activity_assignment.source_id=activity.id
    LEFT JOIN innovator.[identity]
        ON [identity].id=[activity_assignment].related_id
    LEFT JOIN innovator.alias
        ON alias.related_id=[identity].id
    LEFT JOIN innovator.[user]
        ON [user].id=alias.source_id
    WHERE activity.is_auto=0
            AND activity_assignment.related_id is NOT null
            AND activity_assignment.closed_on is null
            AND activity.[state] ='active'
            AND email is NOT null
            AND workflow.source_id is NOT NULL ) AS t
LEFT JOIN
    (SELECT wpa.source_id 'wpid', count(ac.id) wapc
    FROM innovator.workflow_process_activity wpa
    LEFT JOIN innovator.activity ac
        ON wpa.related_id = ac.id
    WHERE ac.[state] = N'closed'
    GROUP BY  wpa.source_id ) swp
    ON swp.wpid = t.wid
WHERE dueday < convert(varchar(30),getdate(),120)
        AND hs_notification_day > 0
        AND (swp.wapc > 1
        OR (swp.wapc <2
        AND t.created_by_id !=t.id))

UNION

SELECT id,
        email,
        hs_partner,
        hs_public_login
FROM
    (SELECT workflow_process.id AS wid ,
        workflow_process.created_by_id ,
        workflow.source_id ,
        itemtype.[name] ,
        [user].id ,
        [user].email ,
        [user].hs_partner ,
        [user].hs_public_login ,
        isnull(activity.hs_notification_day,
        1) AS hs_notification_day ,
        convert(varchar(100),
        dateadd(hour,
        8,
        dateadd(day,
        isnull(activity.hs_notification_day,
        1),
        activity_assignment.created_on)),
        120) AS dueday ,
        convert(varchar(30),
        getdate(),
        120) AS nowday
    FROM innovator.activity
    LEFT JOIN innovator.workflow_process_activity
        ON workflow_process_activity.related_id=activity.id
    LEFT JOIN innovator.workflow_process
        ON workflow_process.id=workflow_process_activity.source_id
    LEFT JOIN innovator.workflow
        ON workflow_process.id=workflow.related_id
    LEFT JOIN innovator.itemtype
        ON itemtype.id=workflow.source_type
    LEFT JOIN innovator.activity_assignment
        ON activity_assignment.source_id=activity.id
    LEFT JOIN innovator.[identity]
        ON [identity].id=[activity_assignment].related_id
    LEFT JOIN innovator.alias
        ON alias.related_id=[identity].id
    LEFT JOIN innovator.[user]
        ON [user].id=alias.source_id
    WHERE activity.is_auto=0
            AND activity_assignment.related_id is NOT null
            AND activity_assignment.closed_on is null
            AND activity.[state] ='active'
            AND email is NOT null
            AND workflow.source_id is NOT null
            AND (WORKFLOW.SOURCE_ID IN
        (SELECT w.SOURCE_ID
        FROM
            (SELECT source_id,
        count(WORKFLOW.SOURCE_ID ) AS wcnt
            FROM innovator.WORKFLOW
            GROUP BY  WORKFLOW.SOURCE_ID ) AS w
            WHERE w.wcnt>1 )
                    OR itemtype.[name]='hs_mrco_activity') ) AS t
        LEFT JOIN
        (SELECT wpa.source_id 'wpid', count(ac.id) wapc
        FROM innovator.workflow_process_activity wpa
        LEFT JOIN innovator.activity ac
            ON wpa.related_id = ac.id
        WHERE ac.[state] = N'closed'
        GROUP BY  wpa.source_id ) swp
        ON swp.wpid = t.wid
WHERE dueday < convert(varchar(30),getdate(),120)
        AND hs_notification_day > 0
        AND swp.wapc < 2
GROUP BY  id,email,hs_partner,hs_public_login