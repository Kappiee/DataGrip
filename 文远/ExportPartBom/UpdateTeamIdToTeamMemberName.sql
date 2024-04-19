SELECT 
    team.id,
    nameList = STUFF(
        (
            SELECT DISTINCT ',' + i.NAME
            FROM innovator.TEAM_IDENTITY teamIdentity 
            JOIN innovator.[IDENTITY] i ON i.id = teamIdentity.RELATED_ID
            WHERE teamIdentity.SOURCE_ID = team.id
            FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 
        1, 1, ''
    )
FROM 
    innovator.TEAM team
WHERE 
    team.id IN ('AF334BFFBAA848B09A9324F1E423A2EB')
