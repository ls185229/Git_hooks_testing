variable inst_id varchar2(30)
variable date_id varchar2(30)
--
exec :inst_id := ''
exec :date_id := ''
--
insert into mas_trans_suspend_wip
select * from mas_trans_suspend mts
where (mts.institution_id    = :inst_id or :inst_id is null)
and (mts.activity_date_time >= :date_id or :date_id is null)
;
--
insert into mas_trans_sus_addn_wip mtsaw
select mtsa.* from mas_trans_sus_addn mtsa
join mas_trans_suspend mts
on mts.institution_id = mtsa.institution_id
and mts.trans_seq_nbr = mtsa.trans_seq_nbr
where (mts.institution_id    = :inst_id or :inst_id is null)
and (mts.activity_date_time >= :date_id or :date_id is null)
;
--
delete mas_trans_sus_addn
where (institution_id, trans_seq_nbr) in (
    select mtsa.institution_id, mtsa.trans_seq_nbr
    from mas_trans_sus_addn mtsa
    join mas_trans_suspend mts
    on mts.institution_id = mtsa.institution_id
    and mts.trans_seq_nbr = mtsa.trans_seq_nbr
    where (mts.institution_id    = :inst_id or :inst_id is null)
    and (mts.activity_date_time >= :date_id or :date_id is null)
)
;
--
delete mas_trans_suspend
where (institution_id, trans_seq_nbr) in (
    select institution_id, trans_seq_nbr
    from mas_trans_suspend_wip
    where (institution_id    = :inst_id or :inst_id is null)
    and (activity_date_time >= :date_id or :date_id is null)
)
;
--
commit;
--