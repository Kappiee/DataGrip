select *
from innovator.HS_PROCESS_TOOL
where hs_type = 'tool'

select names = (stuff((
select distinct ','''+ id +''''
from innovator.HS_PROCESS_TOOL
where hs_type = 'tool'
for xml path('')),1,1,''))


select *
from innovator.HS_PROCESS_ROUTE

select *
from innovator.HS_PROCESS_ROUTE_REF_MDATA

SELECT
    resource_type,
    resource_database_id,
    resource_associated_entity_id,
    request_status,
    request_mode,
    request_session_id,
    resource_description
FROM
    sys.dm_tran_locks
JOIN
    sys.dm_exec_sessions
ON
    sys.dm_tran_locks.request_session_id = sys.dm_exec_sessions.session_id


SELECT r.session_id, r.status, r.blocking_session_id, r.wait_type,
       r.wait_time, r.wait_resource, t.text
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
WHERE r.wait_type IS NOT NULL;


SELECT * FROM sys.dm_tran_locks;