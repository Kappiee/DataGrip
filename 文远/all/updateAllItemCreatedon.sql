select p.ID
from innovator.PROPERTY P
join innovator.ITEMTYPE I on P.source_id = I.id
where  p.name = 'created_by_id' and (
    i.name like 'hs%' or
    i.name = 'Part' or
    i.name = 'Cad' or
    i.name = 'project'or
    i.name = 're_Requirement'or
    i.name = 're_Requirement_Document' or
    i.name = 'Product'or
    i.name = 'Project Template'or
    i.name = 'Vendor'or
    i.name = 'mpp_Machine'or
    i.name = 'mpp_ProcessPlan'or
    i.name = 'mpp_Skill'or
    i.name = 'mpp_Tool'
    )


--需求，需求文档，产品管理,项目风险&问题管理,项目立项单,项目计划,项目计划模板,图库，物料,文档管理,物料请码单，物料送审单，DFMEA，探测措施，预防措施，严重度，发生度，探测度，8D报告，供应商，工艺路线，工艺过程卡，标准工序，典型工艺过程，执行变更(CO)，变更申请单(CR)
--*MAChine*|*process plan*|*skill*|*tools*

-----严重度，Vendor，发生度，探测度



update innovator.PROPERTY
set IS_HIDDEN = 0,
LABEL_ZC = N'创建时间',
LABEL = 'Date Created',
SORT_ORDER = 999999
where id in (
--查询需要更改的属性
select p.ID
from innovator.PROPERTY P
join innovator.ITEMTYPE I on P.source_id = I.id
where  p.name = 'created_on' and (
    i.name like 'hs%' or
    i.name = 'Part' or
    i.name = 'Cad' or
    i.name = 'project'or
    i.name = 're_Requirement'or
    i.name = 're_Requirement_Document' or
    i.name = 'Product'or
    i.name = 'Project Template'or
    i.name = 'Vendor'or
    i.name = 'mpp_Machine'or
    i.name = 'mpp_ProcessPlan'or
    i.name = 'mpp_Skill'or
    i.name = 'mpp_Tool'
    )
)

update innovator.PROPERTY
set IS_HIDDEN = 0,
LABEL_ZC = N'创建者',
LABEL = 'Created By',
SORT_ORDER = 999998
where id in (
--查询需要更改的属性
select p.ID
from innovator.PROPERTY P
join innovator.ITEMTYPE I on P.source_id = I.id
where  p.name = 'created_by_id' and (
     i.name like 'hs%' or
    i.name = 'Part' or
    i.name = 'Cad' or
    i.name = 'project'or
    i.name = 're_Requirement'or
    i.name = 're_Requirement_Document' or
    i.name = 'Product'or
    i.name = 'Project Template'or
    i.name = 'Vendor'or
    i.name = 'mpp_Machine'or
    i.name = 'mpp_ProcessPlan'or
    i.name = 'mpp_Skill'or
    i.name = 'mpp_Tool'
    )
)


