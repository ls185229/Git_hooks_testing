set echo off
set recsep off

set newpage 0
set pagesize 55

set linesize 66


column card_type heading "Card type" format A10
column count(1) heading "Count" format 999999999
column to_char(to_date(substr(authdatetime,0,8),'YYYYMMDD'),'MON-DD-YYYY') heading "Auth date" format A15

ttitle center "GLOBAL MERCHANT SOLUTIONS auth counts"
set heading off
select to_char(sysdate-1,'MON-DD-YYYY') from dual;

set heading on
ttitle center ""
break on to_char(to_date(substr(authdatetime,0,8),'YYYYMMDD'),'MON-DD-YYYY') skip page noduplicates -
      on tid noduplicates

compute sum label 'Daily total' of count(1) on to_char(to_date(substr(authdatetime,0,8),'YYYYMMDD'),'MON-DD-YYYY')

select tid, to_char(to_date(substr(authdatetime,0,8),'YYYYMMDD'),'MON-DD-YYYY'),card_type,count(1)
from transaction
where mid in (select mid from teihost.merchant  where visa_id = '454045211000051')
and substr(authdatetime,0,8) = to_char(sysdate-1,'YYYYMMDD')
group by tid, to_char(to_date(substr(authdatetime,0,8),'YYYYMMDD'),'MON-DD-YYYY'), card_type
order by tid, to_char(to_date(substr(authdatetime,0,8),'YYYYMMDD'),'MON-DD-YYYY'), card_type;

column to_char(to_date(substr(authdatetime,0,6),'YYYYMM'),'MON-YYYY') heading "Month" format A15

ttitle center "=============================================================" - 
skip              "GLOBAL MERCHANT SOLUTIONS month total to date"
set heading off
select to_char(sysdate-1,'MON-YYYY') from dual;

set heading on

ttitle center ""
break on to_char(to_date(substr(authdatetime,0,6),'YYYYMM'),'MON-YYYY') skip page noduplicates -
      on tid noduplicates

compute sum label 'MTD' of count(1) on to_char(to_date(substr(authdatetime,0,6),'YYYYMM'),'MON-YYYY')

select tid, to_char(to_date(substr(authdatetime,0,6),'YYYYMM'),'MON-YYYY'),card_type,count(1)
from transaction
where mid in (select mid from teihost.merchant  where visa_id = '454045211000051')
and substr(authdatetime,0,6) = to_char(sysdate-1,'YYYYMM')
group by tid, to_char(to_date(substr(authdatetime,0,6),'YYYYMM'),'MON-YYYY'), card_type
order by tid, to_char(to_date(substr(authdatetime,0,6),'YYYYMM'),'MON-YYYY'), card_type;

EXIT
