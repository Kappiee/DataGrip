select part.id PartId,
       parentPart.Id parentPartId,
       IIF(parentPart.ID is not null and (parentPart.HS_MEDIEM_CLASS = '30PC' or parentPart.HS_MEDIEM_CLASS = '31PC'),'true','false') HasParentPcb,
       Part.ITEM_NUMBER partNumber,
       parentPart.ITEM_NUMBER parentPartNumber
from innovator.part
         left join innovator.PART_BOM bom on part.ID = bom.RELATED_ID
         left join innovator.PART parentPart on bom.SOURCE_ID = parentPart.ID
group by part.id,parentPart.HS_MEDIEM_CLASS,parentPart.ID,Part.ITEM_NUMBER,parentPart.ITEM_NUMBER


select part.id PartId,
       IIF(parentPart.ID is not null and (parentPart.HS_MEDIEM_CLASS = '30PC' or parentPart.HS_MEDIEM_CLASS = '31PC'),'true','false') HasParentPcb,
       Part.ITEM_NUMBER partNumber,
       parentPart.ITEM_NUMBER parentPartNumber
from innovator.part
         left join innovator.Part_Cad cad3d on Part.id = cad3d.source_id
         left join innovator.Part_Cad_2D cad2d on Part.id = cad2d.source_id
         left join innovator.hs_part_rel_manufacturer_part mpn on Part.id = mpn.source_id
         left join innovator.PART_BOM bom on part.ID = bom.RELATED_ID
         left join innovator.PART parentPart on bom.SOURCE_ID = parentPart.ID

