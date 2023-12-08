--查询需要显示的MBom列 根据对象类hs_process_material
select
    P.NAME                                        Field,
    IIF('true' = 'true', P.LABEL, P.LABEL_ZC) as Title,
    P.COLUMN_WIDTH                                Width
from innovator.PROPERTY P
left join innovator.ITEMTYPE I on P.SOURCE_ID = I.ID
where I.NAME = 'hs_process_material' and P.IS_HIDDEN2 = 0
order by SORT_ORDER;