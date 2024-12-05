with recusive as (
        select source_id,related_id from innovator.Member start
            where start.source_id in (select id from innovator.[IDENTITY] where name = N'型号团队' )
        union all
        select rel.source_id,rel.related_id from innovator.Member rel
            inner join recusive on recusive.related_id = rel.source_id
    )
    select source_id,related_id from recusive
    union all
    select null as source_id,id as related_id from innovator.[IDENTITY] where name = N'型号团队'