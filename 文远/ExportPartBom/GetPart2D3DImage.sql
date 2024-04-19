select PART.id as PartId,Cad2D.THUMBNAIL as image2D,Cad3D.THUMBNAIL as image3D from innovator.PART
left join innovator.PART_CAD_2D RelCad2D on PART.id = RelCad2D.source_id
left join innovator.PART_CAD RelCad3D on PART.id = RelCad3D.source_id
left join innovator.CAD Cad2D on RelCad2D.related_id = Cad2D.id
left join innovator.CAD Cad3D on RelCad3D.related_id = Cad3D.id


select KEYED_NAME
from innovator.PART
where id = 'C98FA5410BD5474AA7B6A2CDE9A367B1';


select PART.id as PartId,Cad2D.THUMBNAIL as image2D,Cad3D.THUMBNAIL as image3D from innovator.PART
left join innovator.PART_CAD_2D RelCad2D on PART.id = RelCad2D.source_id
left join innovator.PART_CAD RelCad3D on PART.id = RelCad3D.source_id
left join innovator.CAD Cad2D on RelCad2D.related_id = Cad2D.id
left join innovator.CAD Cad3D on RelCad3D.related_id = Cad3D.id
where PART.id = 'C98FA5410BD5474AA7B6A2CDE9A367B1'


select top 1  PART.id as PartId,Cad2D.THUMBNAIL as Image2D from innovator.PART
left join innovator.PART_CAD_2D RelCad2D on PART.id = RelCad2D.source_id
left join innovator.CAD Cad2D on RelCad2D.related_id = Cad2D.id
where PART.id = 'C98FA5410BD5474AA7B6A2CDE9A367B1'
order by RelCad2D.CREATED_ON


select top 1 PART.id as PartId,Cad3D.THUMBNAIL as image3D from innovator.PART
left join innovator.PART_CAD RelCad3D on PART.id = RelCad3D.source_id
left join innovator.CAD Cad3D on RelCad3D.related_id = Cad3D.id
where PART.id = 'C98FA5410BD5474AA7B6A2CDE9A367B1'
order by RelCad3D.CREATED_ON


select image2D.PartId,image2D.Image2D,image3D.image3D from (
    select PART.id as PartId,Cad2D.THUMBNAIL as Image2D from innovator.PART
left join innovator.PART_CAD_2D RelCad2D on PART.id = RelCad2D.source_id
left join innovator.CAD Cad2D on RelCad2D.related_id = Cad2D.id
where PART.id in('3A03E047A6F441B7BD75F7C8E8ECECA9','4AAFF6F8D9F74A21A8D42A58AA5C0BF5','94978CCED1EE4ED79F580881EA233D1E','E861B88AE0E9449C851C8F3654F637EE')
order by RelCad2D.CREATED_ON
    ) as image2D
join (
    select  PART.id as PartId,Cad3D.THUMBNAIL as image3D from innovator.PART
left join innovator.PART_CAD RelCad3D on PART.id = RelCad3D.source_id
left join innovator.CAD Cad3D on RelCad3D.related_id = Cad3D.id
where PART.id in('3A03E047A6F441B7BD75F7C8E8ECECA9','4AAFF6F8D9F74A21A8D42A58AA5C0BF5','94978CCED1EE4ED79F580881EA233D1E','E861B88AE0E9449C851C8F3654F637EE')
order by RelCad3D.CREATED_ON
    ) as image3D on image2D.PartId = image3D.PartId



 select PART.id as PartId,Cad2D.THUMBNAIL as Image2D from innovator.PART
left join innovator.PART_CAD_2D RelCad2D on PART.id = RelCad2D.source_id
left join innovator.CAD Cad2D on RelCad2D.related_id = Cad2D.id
where PART.id in('3A03E047A6F441B7BD75F7C8E8ECECA9','4AAFF6F8D9F74A21A8D42A58AA5C0BF5','94978CCED1EE4ED79F580881EA233D1E','E861B88AE0E9449C851C8F3654F637EE')


    select  PART.id as PartId,Cad3D.THUMBNAIL as image3D,RelCad3D.CREATED_ON from innovator.PART
left join innovator.PART_CAD RelCad3D on PART.id = RelCad3D.source_id
left join innovator.CAD Cad3D on RelCad3D.related_id = Cad3D.id
where PART.id in('3A03E047A6F441B7BD75F7C8E8ECECA9','4AAFF6F8D9F74A21A8D42A58AA5C0BF5','94978CCED1EE4ED79F580881EA233D1E','E861B88AE0E9449C851C8F3654F637EE')


WITH PartImages AS (
    SELECT
        PART.id AS PartId,
        Cad3D.THUMBNAIL AS image3D,
        RelCad3D.CREATED_ON,
        ROW_NUMBER() OVER (PARTITION BY PART.id ORDER BY RelCad3D.CREATED_ON DESC) AS RowNum
    FROM
        innovator.PART
        LEFT JOIN innovator.PART_CAD RelCad3D ON PART.id = RelCad3D.source_id
        LEFT JOIN innovator.CAD Cad3D ON RelCad3D.related_id = Cad3D.id
    WHERE
        PART.id IN ('3A03E047A6F441B7BD75F7C8E8ECECA9', '4AAFF6F8D9F74A21A8D42A58AA5C0BF5', '94978CCED1EE4ED79F580881EA233D1E', 'E861B88AE0E9449C851C8F3654F637EE')
)
SELECT
    PartId,
    image3D
FROM
    PartImages
WHERE
    RowNum = 1;

WITH PartImages AS (
    SELECT
        PART.id AS PartId,
        Cad2D.THUMBNAIL AS image2D,
        RelCad2D.CREATED_ON,
        ROW_NUMBER() OVER (PARTITION BY PART.id ORDER BY RelCad2D.CREATED_ON DESC) AS RowNum
    FROM
        innovator.PART
        LEFT JOIN innovator.PART_CAD_2D RelCad2D ON PART.id = RelCad2D.source_id
        LEFT JOIN innovator.CAD Cad2D ON RelCad2D.related_id = Cad2D.id
    WHERE
        PART.id IN ('3A03E047A6F441B7BD75F7C8E8ECECA9', '4AAFF6F8D9F74A21A8D42A58AA5C0BF5', '94978CCED1EE4ED79F580881EA233D1E', 'E861B88AE0E9449C851C8F3654F637EE')
)
SELECT
    PartId,
    image2D
FROM
    PartImages
WHERE
    RowNum = 1;





WITH PartImages3D AS (
    SELECT
        PART.id AS PartId,
        Cad3D.THUMBNAIL AS image3D,
        Cad3D.NATIVE_FILE AS native3D,
        RelCad3D.CREATED_ON,
        ROW_NUMBER() OVER (PARTITION BY PART.id ORDER BY RelCad3D.CREATED_ON DESC) AS RowNum
    FROM
        innovator.PART
        LEFT JOIN innovator.PART_CAD RelCad3D ON PART.id = RelCad3D.source_id
        LEFT JOIN innovator.CAD Cad3D ON RelCad3D.related_id = Cad3D.id
    WHERE
        PART.id IN ('3A03E047A6F441B7BD75F7C8E8ECECA9', '4AAFF6F8D9F74A21A8D42A58AA5C0BF5', '94978CCED1EE4ED79F580881EA233D1E', 'E861B88AE0E9449C851C8F3654F637EE')
),
PartImages2D AS (
    SELECT
        PART.id AS PartId,
        Cad2D.THUMBNAIL AS image2D,
        Cad2D.NATIVE_FILE AS native2D,
        RelCad2D.CREATED_ON,
        ROW_NUMBER() OVER (PARTITION BY PART.id ORDER BY RelCad2D.CREATED_ON DESC) AS RowNum
    FROM
        innovator.PART
        LEFT JOIN innovator.PART_CAD_2D RelCad2D ON PART.id = RelCad2D.source_id
        LEFT JOIN innovator.CAD Cad2D ON RelCad2D.related_id = Cad2D.id
    WHERE
        PART.id IN ('3A03E047A6F441B7BD75F7C8E8ECECA9', '4AAFF6F8D9F74A21A8D42A58AA5C0BF5', '94978CCED1EE4ED79F580881EA233D1E', 'E861B88AE0E9449C851C8F3654F637EE')
)
SELECT
    P.PartId,
    P.image3D,
    P.native3D,
    P2.image2D,
    P2.native2D
FROM
    PartImages3D P
    JOIN
    PartImages2D P2 ON P.PartId = P2.PartId AND P.RowNum = 1 AND P2.RowNum = 1

