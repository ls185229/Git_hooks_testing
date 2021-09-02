prompt move mas_trans_suspend_wip to mas_trans_suspend
--
variable inst_id     varchar2(30)
variable date_id     varchar2(30)
variable susp_reason varchar2(30)
variable entity_id   varchar2(30)
variable card_sch    varchar2(30)
variable mas_cd      varchar2(30)
variable tid         varchar2(30)
--
exec :inst_id           := ''
exec :date_id           := ''
exec :susp_reason       := ''
exec :entity_id         := ''
exec :card_sch          := ''
exec :mas_cd            := ''
exec :tid               := ''
--
insert into mas_trans_suspend
select * from mas_trans_suspend_wip mts
where (mts.institution_id    = :inst_id     or :inst_id     is null)
and (mts.activity_date_time >= :date_id     or :date_id     is null)
and (mts.suspend_reason      = :susp_reason or :susp_reason is null)
and (mts.entity_id           = :entity_id   or :entity_id   is null)
and (mts.card_scheme         = :card_sch    or :card_sch    is null)
and (mts.mas_code            = :mas_cd      or :mas_cd      is null)
and (mts.tid                 = :tid         or :tid         is null)
;
--
insert into mas_trans_sus_addn mtsaw
select mtsa.* from mas_trans_sus_addn_wip mtsa
join mas_trans_suspend_wip mts
on mts.institution_id = mtsa.institution_id
and mts.trans_seq_nbr = mtsa.trans_seq_nbr
where (mts.institution_id    = :inst_id     or :inst_id     is null)
and (mts.activity_date_time >= :date_id     or :date_id     is null)
and (mts.suspend_reason      = :susp_reason or :susp_reason is null)
and (mts.entity_id           = :entity_id   or :entity_id   is null)
and (mts.card_scheme         = :card_sch    or :card_sch    is null)
and (mts.mas_code            = :mas_cd      or :mas_cd      is null)
and (mts.tid                 = :tid         or :tid         is null)
;
--
delete mas_trans_sus_addn_wip
where (institution_id, trans_seq_nbr) in (
    select mtsa.institution_id, mtsa.trans_seq_nbr
    from mas_trans_sus_addn mtsa
    join mas_trans_suspend mts
    on mts.institution_id = mtsa.institution_id
    and mts.trans_seq_nbr = mtsa.trans_seq_nbr
    where (mts.institution_id    = :inst_id     or :inst_id     is null)
    and (mts.activity_date_time >= :date_id     or :date_id     is null)
    and (mts.suspend_reason      = :susp_reason or :susp_reason is null)
    and (mts.entity_id           = :entity_id   or :entity_id   is null)
    and (mts.card_scheme         = :card_sch    or :card_sch    is null)
    and (mts.mas_code            = :mas_cd      or :mas_cd      is null)
    and (mts.tid                 = :tid         or :tid         is null)
)
;
--
delete mas_trans_suspend_wip
where (institution_id, trans_seq_nbr) in (
    select institution_id, trans_seq_nbr
    from mas_trans_suspend
    where (institution_id        = :inst_id     or  :inst_id    is null)
    and (mts.activity_date_time >= :date_id     or :date_id     is null)
    and (mts.suspend_reason      = :susp_reason or :susp_reason is null)
    and (mts.entity_id           = :entity_id   or :entity_id   is null)
    and (mts.card_scheme         = :card_sch    or :card_sch    is null)
    and (mts.mas_code            = :mas_cd      or :mas_cd      is null)
    and (mts.tid                 = :tid         or :tid         is null)
)
;
--
commit;
--