select top 20 CREATED_ON,KEYED_NAME from innovator.PART
group by CREATED_ON,KEYED_NAME

SELECT  top 20
    CREATED_ON,
    STUFF((SELECT ',' + t1.KEYED_NAME +'|' + t1.id
           FROM innovator.PART AS t2
           WHERE t2.CREATED_ON = t1.CREATED_ON
           FOR XML PATH('')), 1, 1, '') AS combined_values
FROM
    innovator.PART AS t1
GROUP BY
    CREATED_ON,t1.KEYED_NAME,t1.id

