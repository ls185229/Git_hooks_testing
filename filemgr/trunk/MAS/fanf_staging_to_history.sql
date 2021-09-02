select count(*) cnt, month_requested
from fanf_staging
where month_requested > sysdate -100 
group by month_requested
order by month_requested
;

select count(*) cnt, month_requested
from fanf_history
where month_requested > sysdate -100 
group by month_requested
order by month_requested
;

insert into fanf_history
select * from fanf_staging
where month_requested > sysdate -100 
;

delete fanf_staging
where month_requested > sysdate -100 
;

select count(*) cnt, month_requested
from fanf_staging
where month_requested > sysdate -100 
group by month_requested
order by month_requested
;

select count(*) cnt, month_requested
from fanf_history
where month_requested > sysdate -100 
group by month_requested
order by month_requested
;
