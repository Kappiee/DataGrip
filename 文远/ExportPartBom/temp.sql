--查询所需的缩略图
WITH PartImages3D AS (
    SELECT
        PART.id AS PartId,
        Cad3D.THUMBNAIL AS image3D,
        Cad3D.hs_stp AS stp3D,
        stp3DFile.filename AS stp3DFileName,
        Cad3D.hs_sign_pdf AS signPdf3D,
        signPdf3DFile.filename AS signPdf3DFileName,
        RelWhd.related_id As whdId,
        whdFile.filename AS whdFileName,
        RelCad3D.CREATED_ON,
        ROW_NUMBER() OVER (PARTITION BY PART.id ORDER BY RelCad3D.CREATED_ON DESC, RelWhd.CREATED_ON DESC) AS RowNum
    FROM
        innovator.PART
        LEFT JOIN innovator.PART_CAD RelCad3D ON PART.id = RelCad3D.source_id
        LEFT JOIN innovator.CAD Cad3D ON RelCad3D.related_id = Cad3D.id
        LEFT JOIN innovator.hs_part_rel_whd RelWhd ON PART.id = RelWhd.source_id
        LEFT JOIN innovator.[file] stp3DFile ON Cad3D.hs_stp = stp3DFile.id
        LEFT JOIN innovator.[file] signPdf3DFile ON Cad3D.hs_sign_pdf = signPdf3DFile.id
        LEFT JOIN innovator.[file] whdFile ON RelWhd.related_id = whdFile.id
    WHERE
        PART.id IN ('{partIdList}') and (Part.state = 'Released' or Part.state is null)  and (Cad3D.state = 'Released' or Cad3D.state is null)
),
PartImages2D AS (
    SELECT
        PART.id AS PartId,
        Cad2D.THUMBNAIL AS image2D,
        Cad2D.hs_stp AS stp2D,
        stp2DFile.filename AS stp2DFileName,
        Cad2D.hs_sign_pdf AS signPdf2D,
        signPdf2DFile.filename AS signPdf2DFileName,
        RelCad2D.CREATED_ON,
        ROW_NUMBER() OVER (PARTITION BY PART.id ORDER BY RelCad2D.CREATED_ON DESC) AS RowNum
    FROM
        innovator.PART
        LEFT JOIN innovator.PART_CAD_2D RelCad2D ON PART.id = RelCad2D.source_id
        LEFT JOIN innovator.CAD Cad2D ON RelCad2D.related_id = Cad2D.id
        LEFT JOIN innovator.[file] stp2DFile ON Cad2D.hs_stp = stp2DFile.id
        LEFT JOIN innovator.[file] signPdf2DFile ON Cad2D.hs_sign_pdf = signPdf2DFile.id
    WHERE
        PART.id IN ('{partIdList}') and (Part.state = 'Released' or Part.state is null)  and (RelCad2D.state = 'Released' or RelCad2D.state is null)
)
SELECT
    P.PartId,
    P.image3D,
    P.stp3D,
    P.stp3DFileName,
    P.signPdf3D,
    P.signPdf3DFileName,
    P.whdId,
    P.whdFileName,
    P2.image2D,
    P2.stp2D,
    P2.stp2DFileName,
    P2.signPdf2D,
    P2.signPdf2DFileName
FROM
    PartImages3D P
    JOIN
    PartImages2D P2 ON P.PartId = P2.PartId AND P.RowNum = 1 AND P2.RowNum = 1