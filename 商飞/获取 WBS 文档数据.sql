    DECLARE @PageNumber INT = {pageNumber};
    DECLARE @RowsPerPage INT = {rowsPerPage};
select t.*,
       [file].KEYED_NAME as [native_file],
       [user].KEYED_NAME as [creator]

from (

    select
    'CAD' as itemtype,
    main.id as id,
    main.ITEM_NUMBER as number,
    main.CLASSIFICATION as classification,
    main.NATIVE_FILE as native_file_id,
    main.CREATED_BY_ID as creator_id,
    FORMAT(DATEADD(hour,8,main.CREATED_ON), 'yyyy-MM-ddTHH:mm:ss') as created_time,
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
    left join secured.CAD('can_get', '{identity_list}', '', '{user_id}', '', '') sec
    on main.id = sec.id
    where ISNULL( sec.id_$_permission, 0 ) = 9 and main.IS_CURRENT = '1'

)as t
left join innovator.[file] on t.[native_file_id] = [file].id
left join innovator.[USER] on [USER].ID = t.creator_id
{where_sql}
ORDER BY {sort_order}
OFFSET (@PageNumber - 1) * @RowsPerPage ROWS
FETCH NEXT @RowsPerPage ROWS ONLY;