    select PRODUCT.KEYED_NAME as product_name,
       IIF(
       isnull(parent_activity.rollup_percent_complate,0) >= 100,
       1,0) as finished,
        --为完成数量
       (select count(*) from innovator.PROJECTACTIVITY milestone
                   where milestone.CLASSIFICATION ='milestone' and milestone.proj_num = PROJECT.id
                   and DATEADD(HOUR,32,milestone.rollup_date_due_sched)  <= GETDATE() and isnull(milestone.rollup_percent_complate,0) < 100)
           as overdue_quantity,
       PRODUCT.ID as product_id,PROJECT.id as project_id
    from innovator.PRODUCT
    left join innovator.HS_PI on HS_PI.HS_PRODUCT = PRODUCT.ID
    left join innovator.PROJECT on PROJECT.HS_PI = HS_PI.id
    left join innovator.PROJECTACTIVITY parent_activity on parent_activity.PROJ_NUM = PROJECT.id
           and (parent_activity.PARENT_ID is null or parent_activity.PARENT_ID = '')

    where PRODUCT.id in (select selectProduct.id from innovator.PRODUCT
    left join innovator.PART currentPart on currentPart.HS_PRODUCT = PRODUCT.ID
    left join innovator.PART_BOM on  PART_BOM.SOURCE_ID = currentPart.ID
    left join innovator.PART childPart on childPart.ID = PART_BOM.RELATED_ID
    left join innovator.PRODUCT selectProduct on childPart.HS_PRODUCT = selectProduct.ID
    where PRODUCT.id = '8E5FB890AECA4E2CA799DEE1C5DB919C' and selectProduct.id is not null
    and currentPart.IS_CURRENT = '1'
    and selectProduct.IS_CURRENT = '1'
    union
    select '8E5FB890AECA4E2CA799DEE1C5DB919C' as id)



    select milestone.proj_num,GETDATE() from innovator.PROJECTACTIVITY milestone
       where milestone.CLASSIFICATION ='milestone'
       and DATEADD(HOUR,32,milestone.rollup_date_due_sched)  <= GETDATE() and isnull(milestone.rollup_percent_complate,0) < 100
       and milestone.proj_num = '38B369B84AFD469B90EBC6B48B7A79E1'
    group by milestone.proj_num
