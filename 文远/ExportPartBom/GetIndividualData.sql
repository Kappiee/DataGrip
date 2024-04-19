--获取需要的数据
select top 1 Project.KEYED_NAME                                     Project,      --项目
             Part.MAJOR_REV + Convert(varchar(10), Part.GENERATION) Version,      --Bom版本
             u1.FIRST_NAME        as                                Creator,      --Bom负责人
             PART.RELEASE_DATE    as                                ReleasedDate, --Bom生成日期
             u2.FIRST_NAME        as                                Reviewer,     --审核
             ACTIVITY.CLOSED_DATE as                                ReviewDate    --审核日期
from innovator.PART
         left join innovator.hs_pi Project on PART.HS_PROJECT = Project.id
         left join innovator.HS_PART_EXPRESS_REL_DETAIL on HS_PART_EXPRESS_REL_DETAIL.HS_PART = PART.id
         left join innovator.HS_PART_EXPRESS express on express.id = HS_PART_EXPRESS_REL_DETAIL.SOURCE_ID
         left join innovator.WORKFLOW on express.ID = WORKFLOW.SOURCE_ID
         left join innovator.WORKFLOW_PROCESS on WORKFLOW_PROCESS.id = WORKFLOW.RELATED_ID
         left join innovator.WORKFLOW_PROCESS_ACTIVITY on WORKFLOW_PROCESS_ACTIVITY.SOURCE_ID = WORKFLOW_PROCESS.id
         join innovator.ACTIVITY on ACTIVITY.id = WORKFLOW_PROCESS_ACTIVITY.RELATED_ID and ACTIVITY.NAME = 'Review'
         left join innovator.[USER] u1 on u1.id = PART.CREATED_BY_ID
         left join innovator.[IDENTITY] d on d.id = express.HS_REVIEWER
         left join innovator.alias on alias.RELATED_ID = d.id
         left join innovator.[USER] u2 on u2.id = alias.SOURCE_ID
where PART.id = '2E00DD06AB40408389A66126457EF747'
order by ReleasedDate desc
