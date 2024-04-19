update innovator.hs_process_card set HS_PROCESS_MATERIAL =
(
select top 1 MPart.id
from innovator.HS_PROCESS_CARD Card
left join innovator.PART on Card.HS_PART = innovator.PART.id
left join innovator.HS_PROCESS_MATERIAL MPart on MPart.HS_PART_NUMBER = PART.ITEM_NUMBER
where  Card.id = 'E3B7C26885BF439AAD183C11BE03C98E'
)
where id = 'E3B7C26885BF439AAD183C11BE03C98E'

