 select distinct ITEM_NUMBER as CadNumber,hs_cad_type  as CadType from innovator.Cad where ITEM_NUMBER = '000' and hs_cad_type = 'PCB'


 update innovator.CAD
 set HS_RELATED_MATERIALS = (select id from innovator.PART  where ITEM_NUMBER = @PartNumber)
 where ITEM_NUMBER = @CadNumber and HS_CAD_TYPE = @CadType


 select distinct ITEM_NUMBER from innovator.PART where ITEM_NUMBER in ('1')


 select VALUE.value from innovator.List
 left join innovator.VALUE on innovator.List.id = innovator.VALUE.SOURCE_ID
 where name = 'hs_cad_type'

 select id from innovator.PART  where ITEM_NUMBER = '1011021006' and IS_CURRENT