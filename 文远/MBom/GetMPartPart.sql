            select PART.ID as PartId , MPart.Id as MPartId
            from innovator.HS_PROCESS_MATERIAL MPart
            join innovator.part on PART.id = MPart.HS_PART
            where MPart.id in ('B72EC42658024B05807E7967DC74090D');

select  MPart.HS_PART as PartId , MPart.Id as MPartId
from innovator.HS_PROCESS_MATERIAL MPart
where MPart.HS_PART in ('CE528724737E41B2AD5642272DDE80F0');


            select *
            from innovator.HS_PROCESS_MATERIAL
            where id in ('B72EC42658024B05807E7967DC74090D');