select P.NAME, IIF('true' = 'true12', P.LABEL, P.LABEL_ZC) as LABEL
from innovator.PROPERTY P
         join innovator.ITEMTYPE on innovator.ITEMTYPE.id = P.source_id and ITEMTYPE.name = 'Part'
where ((P.LABEL is not null and P.LABEL <> '') or (P.LABEL_ZC is not null and P.LABEL_ZC <> ''))
  and (p.DATA_TYPE = 'string' or p.DATA_TYPE = 'text' or p.DATA_TYPE = 'integer' or p.DATA_TYPE = 'float' or
       p.DATA_TYPE = 'decimal' or p.DATA_TYPE = 'date')
union
select P.NAME, item.id, forP.*
from innovator.PROPERTY P
         join innovator.ITEMTYPE on innovator.ITEMTYPE.id = P.source_id and ITEMTYPE.name = 'Part'
         left join innovator.ITEMTYPE item on item.id = p.DATA_SOURCE
         left join innovator.Property as forP on forP.id = P.FOREIGN_PROPERTY
where ((P.LABEL is not null and P.LABEL <> '') or (P.LABEL_ZC is not null and P.LABEL_ZC <> ''))
  and p.DATA_TYPE = 'foreign'


order by P.SORT_ORDER


--属性名称，selectStr,LeftJoinStr
select P.NAME,
       '[' + Replace(item.name, ' ', '_') + '].keyed_name as ' + P.Name as SelectStr,
       ' left join innovator.[' + Replace(item.name, ' ', '_') + '] on [' + Replace(item.name, ' ', '_') +
       '].id = Part.' + P.NAME + ' '                                    as LeftJoinStr
from innovator.PROPERTY P
         join innovator.ITEMTYPE on innovator.ITEMTYPE.id = P.source_id and ITEMTYPE.name = 'Part'
         left join innovator.ITEMTYPE item on item.id = p.DATA_SOURCE
where ((P.LABEL is not null and P.LABEL <> '') or (P.LABEL_ZC is not null and P.LABEL_ZC <> ''))
  and p.DATA_TYPE = 'item'
  and p.NAME <> 'team_id' --team_id 另外处理
union
select P.NAME,
       '[' + Replace(forItem.name, ' ', '_') + '].' +
       IIF(forP.data_type = 'ml_string', IIF('true' = 'true12', 'LABEL', 'LABEL_ZC'), forP.KEYED_NAME) + ' as ' +
       P.Name                              as SelectStr,
       ' left join innovator.[' + Replace(forItem.name, ' ', '_') + '] on [' + Replace(forItem.name, ' ', '_') +
       '].id = Part.' + sourceP.name + ' ' as LeftJoinStr
from innovator.PROPERTY P
         join innovator.ITEMTYPE on innovator.ITEMTYPE.id = P.source_id and ITEMTYPE.name = 'Part'
         left join innovator.PROPERTY as forP on forP.id = P.FOREIGN_PROPERTY
         left join innovator.ITEMTYPE forItem on forItem.id = forP.source_id
         left join innovator.PROPERTY sourceP on sourceP.id = P.DATA_SOURCE
where ((P.LABEL is not null and P.LABEL <> '') or (P.LABEL_ZC is not null and P.LABEL_ZC <> ''))
  and p.DATA_TYPE = 'foreign'
union
select P.NAME,
       'IIF(Part.' + P.NAME + N' = 1,N''是'', N''否'') as ' + P.NAME + ' ',
       '' as LeftJoinStr
from innovator.PROPERTY P
         join innovator.ITEMTYPE on innovator.ITEMTYPE.id = P.source_id and ITEMTYPE.name = 'Part'
where ((P.LABEL is not null and P.LABEL <> '') or (P.LABEL_ZC is not null and P.LABEL_ZC <> ''))
  and p.DATA_TYPE = 'boolean'
union
select P.NAME,
       IIF('true' = 'true12', '' + p.NAME + 'v.LABEL as ' + p.NAME,
           '' + p.NAME + 'v.LABEL_ZC as ' + p.NAME) as SelectStr,
       'join innovator.LIST as ' + p.NAME + 'l on ' + p.NAME + 'l.NAME = ''' + LIST.name + '''
        left join innovator.[VALUE]  as ' + p.NAME + 'v on ' + p.NAME + 'v.SOURCE_ID = ' + p.NAME + 'L.ID and ' +
       p.NAME + 'v.VALUE = PART.' + p.NAME + ' '    as LeftJoinStr
from innovator.PROPERTY P
         join innovator.ITEMTYPE on innovator.ITEMTYPE.id = P.source_id and ITEMTYPE.name = 'Part'
         left join innovator.LIST on LIST.id = p.DATA_SOURCE
where ((P.LABEL is not null and P.LABEL <> '') or (P.LABEL_ZC is not null and P.LABEL_ZC <> ''))
  and p.DATA_TYPE = 'list'
union
select P.NAME,
       IIF('true' = 'true12', '' + p.NAME + 'v.LABEL as ' + p.NAME,
           '' + p.NAME + 'v.LABEL_ZC as ' + p.NAME)                                                  as SelectStr,
       'join innovator.LIST as ' + p.NAME + 'l on ' + p.NAME + 'l.NAME = ''' + LIST.name + '''
        left join innovator.[FILTER_VALUE]  as ' + p.NAME + 'v on ' + p.NAME + 'v.SOURCE_ID = ' + p.NAME + 'L.ID and ' +
       p.NAME + 'v.VALUE = PART.' + p.NAME + ' and ' + p.NAME + 'v.FILTER = PART.' + p.PATTERN + ' ' as LeftJoinStr
from innovator.PROPERTY P
         join innovator.ITEMTYPE on innovator.ITEMTYPE.id = P.source_id and ITEMTYPE.name = 'Part'
         left join innovator.LIST on LIST.id = p.DATA_SOURCE
where ((P.LABEL is not null and P.LABEL <> '') or (P.LABEL_ZC is not null and P.LABEL_ZC <> ''))
  and p.DATA_TYPE = 'Filter List'


--获取示例
SELECT FILTER_VALUE.LABEL_ZC
from innovator.PART
         join innovator.LIST on LIST.name = 'HS_MEDIEM_CLASS'
         left join innovator.FILTER_VALUE
                   on FILTER_VALUE.SOURCE_ID = LIST.ID and FILTER_VALUE.VALUE = PART.HS_MEDIEM_CLASS and
                      FILTER_VALUE.FILTER = PART.HS_LARGE_CLASS
where PART.id = 'D30D916FBF7F404793067B4E29ED6A28'


select hs_name
from innovator.hs_export_map
where hs_user = '30B991F927274FA3829655F50C99472E'

update innovator.hs_export_map
set HS_NAME = 'hs_man_part_number,description'
where HS_USER = '30B991F927274FA3829655F50C99472E'

--更新
MERGE INTO innovator.hs_export_map AS Target
USING (VALUES ( @hs_name, @hs_user
              , @id, @config_id, @keyed_name, @created_on, @modified_on, @is_current, @major_rev, @is_released
              , @not_lockable, @generation, @modified_by_id, @created_by_id, @permission_id)) AS Source
    (hs_name, HS_USER, id, config_id, keyed_name, created_on, modified_on, is_current, major_rev,
     is_released, not_lockable, generation, modified_by_id, created_by_id, permission_id)
ON Target.HS_USER = Source.HS_USER
WHEN MATCHED THEN
    UPDATE
    SET Target.HS_NAME = Source.HS_NAME
WHEN NOT MATCHED THEN
    INSERT (hs_name, hs_user,
            id, config_id, keyed_name, created_on, modified_on, is_current, major_rev,
            is_released, not_lockable, generation, modified_by_id, created_by_id, permission_id)
    VALUES (Source.hs_name, Source.hs_user,
            Source.id, Source.config_id, Source.keyed_name, Source.created_on, Source.modified_on, Source.is_current,
            Source.major_rev,
            Source.is_released, Source.not_lockable, Source.generation, Source.modified_by_id, Source.created_by_id,
            Source.permission_id);

select HS_NAME, HS_USER
from innovator.HS_EXPORT_MAP;

update innovator.HS_EXPORT_MAP
set HS_NAME = '[{"Name":"item_number","Label":"零件编号","IsExport":true,"Sort":0},{"Name":"name","Label":"零件名称","IsExport":true,"Sort":1},{"Name":"hs_firmware_name","Label":"固件名称","IsExport":true,"Sort":61},{"Name":"hs_firmware_des","Label":"固件描述","IsExport":true,"Sort":62},{"Name":"hs_large_class","Label":"大类","IsExport":true,"Sort":2},{"Name":"hs_mediem_class","Label":"中类","IsExport":true,"Sort":3},{"Name":"hs_small_class","Label":"小类","IsExport":true,"Sort":4},{"Name":"major_rev","Label":"版本","IsExport":true,"Sort":5},{"Name":"generation","Label":"版次","IsExport":true,"Sort":6},{"Name":"hs_state","Label":"状态","IsExport":true,"Sort":8},{"Name":"release_date","Label":"发布日期","IsExport":true,"Sort":10},{"Name":"hs_dept","Label":"设计责任部门","IsExport":true,"Sort":11},{"Name":"hs_name_en","Label":"英文名称","IsExport":true,"Sort":12},{"Name":"hs_importance","Label":"重要度","IsExport":true,"Sort":13},{"Name":"hs_procurement_type","Label":"采购类型","IsExport":true,"Sort":14},{"Name":"hs_develop_type","Label":"开发类型","IsExport":true,"Sort":15},{"Name":"hs_material","Label":"材料","IsExport":true,"Sort":16},{"Name":"hs_process","Label":"制成工艺","IsExport":true,"Sort":17},{"Name":"hs_length","Label":"长（mm）","IsExport":true,"Sort":18},{"Name":"hs_width","Label":"宽（mm）","IsExport":true,"Sort":19},{"Name":"hs_height","Label":"高（mm）","IsExport":true,"Sort":20},{"Name":"hs_cost","Label":"成本","IsExport":true,"Sort":21},{"Name":"hs_quality","Label":"单件质量","IsExport":true,"Sort":22},{"Name":"hs_mass_unit","Label":"质量单位","IsExport":true,"Sort":23},{"Name":"hs_volume","Label":"单件体积","IsExport":true,"Sort":24},{"Name":"hs_unit","Label":"体积单位","IsExport":true,"Sort":25},{"Name":"hs_cad","Label":"参考图样","IsExport":true,"Sort":26},{"Name":"hs_condition","Label":"适用技术条件","IsExport":true,"Sort":27},{"Name":"hs_car_code","Label":"车型代号","IsExport":true,"Sort":28},{"Name":"hs_project","Label":"项目名称","IsExport":true,"Sort":29},{"Name":"hs_remark","Label":"备注","IsExport":true,"Sort":30},{"Name":"hs_product","Label":"关联产品","IsExport":true,"Sort":31},{"Name":"classification","Label":"类型","IsExport":true,"Sort":33},{"Name":"cost","Label":"成本","IsExport":true,"Sort":34},{"Name":"unit","Label":"单位","IsExport":true,"Sort":35},{"Name":"make_buy","Label":"制造/购买","IsExport":true,"Sort":36},{"Name":"cost_basis","Label":"成本基础","IsExport":true,"Sort":37},{"Name":"weight","Label":"重量","IsExport":true,"Sort":38},{"Name":"weight_basis","Label":"重量基准","IsExport":true,"Sort":39},{"Name":"description","Label":"描述","IsExport":true,"Sort":40},{"Name":"external_id","Label":"外部ID","IsExport":true,"Sort":41},{"Name":"external_type","Label":"外部类型","IsExport":true,"Sort":42},{"Name":"is_released","Label":"发布","IsExport":true,"Sort":43},{"Name":"not_lockable","Label":"不可锁定","IsExport":true,"Sort":44},{"Name":"external_owner","Label":"外部所有者","IsExport":true,"Sort":45},{"Name":"effective_date","Label":"生效日期","IsExport":true,"Sort":46},{"Name":"team_id","Label":"权限组","IsExport":true,"Sort":47},{"Name":"superseded_date","Label":"停用日期","IsExport":true,"Sort":48},{"Name":"thumbnail","Label":"缩略图","IsExport":true,"Sort":49},{"Name":"hs_electronic_name","Label":"电子件名称","IsExport":true,"Sort":50},{"Name":"has_change_pending","Label":"变更中","IsExport":true,"Sort":51},{"Name":"hs_part_level","Label":"物料等级","IsExport":true,"Sort":52},{"Name":"hs_description","Label":"零件描述","IsExport":true,"Sort":53},{"Name":"hs_value","Label":"Value","IsExport":true,"Sort":54},{"Name":"hs_pcb","Label":"PCB Footprint","IsExport":true,"Sort":55},{"Name":"hs_color","Label":"颜色","IsExport":true,"Sort":58},{"Name":"hs_mass","Label":"质量","IsExport":true,"Sort":63},{"Name":"created_by_id","Label":"创建者","IsExport":true,"Sort":64},{"Name":"created_on","Label":"创建时间","IsExport":true,"Sort":65}]'


select *
from innovator.PART;


