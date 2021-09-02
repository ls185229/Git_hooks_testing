prompt moving mas_trans_error to mas_trans_error_wip
Prompt possibly by intitution and/or date
--
variable inst_id varchar2(30)
variable date_id varchar2(30)
--
exec :inst_id := ''
exec :date_id := ''
--
insert into mas_trans_error_wip
select * from mas_trans_error mts
where (mts.institution_id = :inst_id or  :inst_id is null)
and (mts.activity_date_time >= :date_id or  :date_id is null)
;
--
delete mas_trans_error
where (institution_id, trans_seq_nbr) in (
    select institution_id, trans_seq_nbr
    from mas_trans_error_wip
    where (institution_id = :inst_id or  :inst_id is null)
    and (activity_date_time >= :date_id or  :date_id is null)
)
;
--
commit;
--