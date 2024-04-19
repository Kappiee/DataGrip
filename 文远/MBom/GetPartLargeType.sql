select LABEL_ZC as LABEL,VALUE
from innovator.VALUE
join innovator.LIST on VALUE.SOURCE_ID = LIST.ID
where NAME = 'hs_large_class';