select  Part.id PartId,m.name as Manufacturer,mpnPart.hs_manp_number MpnNumber ,mpnPart.item_number MPN,mpnPart.description MpnDescription from innovator.hs_part_rel_manufacturer_part mpn
left join innovator.Part on mpn.source_id = Part.id
left join innovator.Manufacturer_Part mpnPart on mpn.related_id = mpnPart.id
left join innovator.Manufacturer m on m.id = mpnPart.manufacturer
group by  Part.id,m.name, Part.id, mpnPart.hs_manp_number, mpnPart.item_number, mpnPart.description