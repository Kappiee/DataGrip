DECLARE @PageNumber INT = 1;
DECLARE @RowsPerPage INT = 50;


select t.*,
       [file].KEYED_NAME as native_file,
       [user].KEYED_NAME as creator

from (
    select
    'hs_doc' as itemtype,
    HS_DOC.id as id,
    HS_DOC.HS_NUMBER as number,
    'Document' as classification,
    null as native_file_id,
    HS_DOC.CREATED_BY_ID as creator_id,
    FORMAT(DATEADD(day,8,HS_DOC.CREATED_ON), 'yyyy-MM-ddTHH:mm:ss') as created_time,
    null as authoring_tool,
    null as type,
    null as name,
    HS_DOC_CONFIG.HS_CATEGORY as category,
    HS_DOC_CONFIG.HS_SMALL_CATEGORY as small_category,
    HS_DOC.HS_REMARK as description,
    null as part_no,
    null as part,
    ISNULL( sec.id_$_permission, 0 ) as can_get

    from innovator.HS_DOC
    left join innovator.HS_DOC_CONFIG on HS_DOC_CONFIG.id = HS_DOC.HS_CATEGORY
    left join secured.HS_DOC('can_get', '6B14D33C4A7D41C188CCF2BC15BD01A3,A73B655731924CD0B027E4F4D5FCC0A9,0AE17A9AA7D741D7805BF6B615004A6B,1050D71126614218B6CF41F80AD95F34,25A6FAEBAAD64D848B9238B97588523A,2618D6F5A90949BAA7E920D1B04C7EE1,44B30710AABC43368678AF35F5E05DE8,4ACA79F318F7448A955AE595511AC789,56A96DA9E981481688563E2D14D5D878,5E12CD824411477AA56D9F539FA295EB,68167A8C96F04737AF6F45FEEF3A3D30,694C8B27E5D940DAA8BD336E45EC3A63,6E4010637C1941748089C622D9C259F2,719FA509EF8C4944AEEF468604A85E1D,9A31744D064D41009A26E458CC7AB874,B32BD81D1AD04207BF1E61E39A4E0E13,F642111069824142BEEF4D9852E4EE03,F6C8853870D245A6BA7FE4D150293229', '', '', '', '') sec
        on HS_DOC.id = sec.id
    where ISNULL( sec.id_$_permission, 0 ) = 9 and HS_DOC.IS_CURRENT = '1'

    union all

    select
    'CAD' as itemtype,
    main.id as id,
    main.ITEM_NUMBER as number,
    main.CLASSIFICATION as classification,
    main.NATIVE_FILE as native_file_id,
    main.CREATED_BY_ID as creator_id,
    FORMAT(DATEADD(day,8,main.CREATED_ON), 'yyyy-MM-ddTHH:mm:ss') as created_time,
    main.AUTHORING_TOOL as authoring_tool,
    main.HS_TYPE as type,
    main.name as name,
    null as category,
    null as small_category,
    main.DESCRIPTION as description,
    (select names = (stuff((
        select ','+PART.ITEM_NUMBER from innovator.PART
        left join innovator.PART_CAD on PART_CAD.SOURCE_ID = PART.ID
        left join innovator.CAD on PART_CAD.RELATED_ID = CAD.ID
        where CAD.ID = main.id
        for xml path('')),1,1,''))) as part_no,
     (select idlist = (stuff((
        select ','+PART.id from innovator.PART
        left join innovator.PART_CAD on PART_CAD.SOURCE_ID = PART.ID
        left join innovator.CAD on PART_CAD.RELATED_ID = CAD.ID
        where CAD.ID = main.id
        for xml path('')),1,1,''))) as part,
        ISNULL( sec.id_$_permission, 0 ) as can_get

    from innovator.CAD main
    left join secured.CAD('can_get', '049AB14B52314AD69AC9BC69CCFCB993,A73B655731924CD0B027E4F4D5FCC0A9,C1ACD57437364B4AA890CBF2CB900C0D,C38C0D2E46174DB59AE833BBA949A394', '', 'A7A8202436AC491498B8ACECEB146E2D', '', '') sec
    on main.id = sec.id
    where ISNULL( sec.id_$_permission, 0 ) = 9 and main.IS_CURRENT = '1'

)as t
left join innovator.[file] on t.[native_file_id] = [file].id
left join innovator.[USER] on [USER].ID = t.creator_id
where created_time between '2023-08-15T00:00:00' and '2024-08-15T23:59:59'
ORDER BY created_time DESC
OFFSET (@PageNumber - 1) * @RowsPerPage ROWS
FETCH NEXT @RowsPerPage ROWS ONLY


--
-- SELECT sec.ID,'can_get' permission_type,ISNULL( sec.id_$_permission, 0 ) AS permission_value,m.ITEM_NUMBER
-- FROM secured.PART('can_get', '6B14D33C4A7D41C188CCF2BC15BD01A3,A73B655731924CD0B027E4F4D5FCC0A9,0AE17A9AA7D741D7805BF6B615004A6B,1050D71126614218B6CF41F80AD95F34,25A6FAEBAAD64D848B9238B97588523A,2618D6F5A90949BAA7E920D1B04C7EE1,44B30710AABC43368678AF35F5E05DE8,4ACA79F318F7448A955AE595511AC789,56A96DA9E981481688563E2D14D5D878,5E12CD824411477AA56D9F539FA295EB,68167A8C96F04737AF6F45FEEF3A3D30,694C8B27E5D940DAA8BD336E45EC3A63,6E4010637C1941748089C622D9C259F2,719FA509EF8C4944AEEF468604A85E1D,9A31744D064D41009A26E458CC7AB874,B32BD81D1AD04207BF1E61E39A4E0E13,F642111069824142BEEF4D9852E4EE03,F6C8853870D245A6BA7FE4D150293229', '', '', '', '') sec
-- JOIN innovator.PART m ON sec.id = m.id
-- WHERE sec.ID = 'C0EA2EE811294071B0AD6075EC64F107'
--
--
--
--
-- select PART.id,PART.ITEM_NUMBER from innovator.PART
-- left join innovator.PART_CAD on PART_CAD.SOURCE_ID = PART.ID
-- left join innovator.CAD on PART_CAD.RELATED_ID = CAD.ID
-- where CAD.ID = 'EB26CC18E3334AE5A9FF5FE2A88E7911'
--
-- select names = (stuff((
-- select ','+hs_product_application.id
-- from innovator.hs_product_application
-- left join innovator.HS_PA_REL_EBOM on hs_product_application.id = HS_PA_REL_EBOM.SOURCE_ID
-- left join innovator.PART on HS_PA_REL_EBOM.RELATED_ID = PART.ID
-- where part.id in(select PART.id from innovator.PART
-- left join innovator.PART_CAD on PART_CAD.SOURCE_ID = PART.ID
-- left join innovator.CAD on PART_CAD.RELATED_ID = CAD.ID
-- where CAD.ID = 'EB26CC18E3334AE5A9FF5FE2A88E7911')
-- for xml path('')),1,1,''))
--
-- select hs_product_application.id
-- from innovator.hs_product_application
-- left join innovator.HS_PA_REL_EBOM on hs_product_application.id = HS_PA_REL_EBOM.SOURCE_ID
-- left join innovator.PART on HS_PA_REL_EBOM.RELATED_ID = PART.ID
-- where part.id in(select PART.id from innovator.PART
-- left join innovator.PART_CAD on PART_CAD.SOURCE_ID = PART.ID
-- left join innovator.CAD on PART_CAD.RELATED_ID = CAD.ID
-- where CAD.ID = 'EB26CC18E3334AE5A9FF5FE2A88E7911')

-- select * from innovator.HS_PI
-- left join innovator.HS_PI_REL_PRODUCT on HS_PI_REL_PRODUCT.SOURCE_ID = HS_PI.ID
-- left join innovator.hs_pro


--
--
--
-- select count(*) as itemmax
-- from (
--     select t.*,
--            [file].KEYED_NAME as [native_file],
--            [user].KEYED_NAME as [creator]
--
--     from (
--         select
--         HS_NUMBER as number,
--         'Document' as classification,
--         null as native_file_id,
--         HS_DOC.CREATED_BY_ID as creator_id,
--         FORMAT(DATEADD(day,8,HS_DOC.CREATED_ON), 'yyyy-MM-ddTHH:mm:ss') as created_time,
--         null as authoring_tool,
--         null as type,
--         null as name,
--         HS_DOC_CONFIG.HS_CATEGORY as category,
--         HS_DOC_CONFIG.HS_SMALL_CATEGORY as small_category,
--         HS_REMARK as description,
--         null as part_no
--
--         from innovator.HS_DOC
--         left join innovator.HS_DOC_CONFIG on HS_DOC_CONFIG.id = HS_DOC.HS_CATEGORY
--
--         union all
--
--         select
--         ITEM_NUMBER as number,
--         CLASSIFICATION as classification,
--         NATIVE_FILE as native_file_id,
--         CREATED_BY_ID as creator_id,
--         FORMAT(DATEADD(day,8,CREATED_ON), 'yyyy-MM-ddTHH:mm:ss') as created_time,
--         AUTHORING_TOOL as authoring_tool,
--         HS_TYPE as type,
--         name as name,
--         null as category,
--         null as small_category,
--         DESCRIPTION as description,
--         null as part_no
--         from innovator.CAD
--     )as t
--     left join innovator.[file] on t.[native_file_id] = [file].id
--     left join innovator.[USER] on [USER].ID = t.creator_id
--     where number like '%11'
-- )as t2
--
