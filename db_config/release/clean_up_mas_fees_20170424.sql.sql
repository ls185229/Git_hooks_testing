select * from mas_fees mf
where mas_code in ( 
     
    '0104CNCONCRT1', '0104CNCONCRT1INTLSTL', '0104CNCONCRT2', '0104CNCONCRT2INTLSTL',
    '0104CNINFCRT1', '0104CNINFCRT1INTLSTL', '0104CNINFCRT2', '0104CNINFCRT2INTLSTL',
    '0104CNPPT1', '0104CNPPT1INTLSTL', '0104CNPPT2', '0104CNPPT2INTLSTL',
    '0105CNCHVSUPMKT', '0105CNCPHSRB'

)
and institution_id between '127' and '135'
and mf.fee_status != 'O'
order by mas_code
;

update mas_fees mf
set mf.fee_status = 'O'
where mas_code in (
     
    '0104CNCONCRT1', '0104CNCONCRT1INTLSTL', '0104CNCONCRT2', '0104CNCONCRT2INTLSTL',
    '0104CNINFCRT1', '0104CNINFCRT1INTLSTL', '0104CNINFCRT2', '0104CNINFCRT2INTLSTL',
    '0104CNPPT1', '0104CNPPT1INTLSTL', '0104CNPPT2', '0104CNPPT2INTLSTL',
    '0105CNCHVSUPMKT', '0105CNCPHSRB'
)
and institution_id between '127' and '135'
and mf.fee_status != 'O'
and trunc(mf.EFFECTIVE_DATE) in ('17-mar-15', '16-OCT-15', '31-MAR-16', '15-apr-16', '17-OCT-16', '28-JAN-17')
;

select * from mas_fees where mas_code in ('0105CND2PAYPASS','0105CND3PAYPASS')
and INSTITUTION_ID between '127' and '135'
and FEE_STATUS != 'O'
order by 4,1,2,3, 4;

