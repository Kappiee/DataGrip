select name from innovator.LIFE_CYCLE_STATE
                where id in (
                select TO_STATE from innovator.LIFE_CYCLE_TRANSITION
                where id in (
                select RELATED_ID from innovator.Activity_Transition
                where SOURCE_ID = '{actid}'))