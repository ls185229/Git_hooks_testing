select institution_id inst,
	entity_id,
	entity_level lvl,
	entity_dba_name,
	settl_plan_id
from acq_entity
where institution_id = '107'
and 
	(entity_id like '454045_21660001%'
	or  
	entity_id like '454045_21660010%'
	or  
	entity_id like '454045_21660240%'
	or  
	entity_id like '454045_2166062%'
	)
order by 1,2
;
/*
update acq_entity
set settl_plan_id = 15
where institution_id = '107'
and 
	(entity_id like '454045_21660001%'
	or  
	entity_id like '454045_21660010%'
	or  
	entity_id like '454045_21660240%'
	or  
	entity_id like '454045_2166062%'
	)
;
*/