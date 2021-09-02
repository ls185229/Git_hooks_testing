DEFINE cutoff_date = TO_DATE('01-JAN-1000', 'DD/MM/YYYY');

delete from purchasing_item 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   ) ;


delete from in_draft_discover 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );


delete from in_draft_baseii 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );


delete from visa_adn 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );


delete from merchant_desc 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );


delete from trans_enrichment 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );


delete from moto_adn 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );


delete from visa_tc50 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );


delete from visa_pay_serv_adn 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );


delete from corpcrd_purchasing 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );

delete from in_draft_emc 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );

delete from lodging_adn 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );

delete from fleet_serv_adn 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );

delete from trans_err_log 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );
   
delete from suspend_log 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );

delete from suspend_log_orig 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );

delete from ep_event_log 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );

delete from in_draft_cup 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );

delete from in_draft_amex 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );

delete from icc_data 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );

delete from loc_dtl 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );

delete from ipm_trans_fee 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );

delete from ipm_reject_msg 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );

delete from visa_rtn_rclas_adn 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );

delete from visa_sms_adn 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );

delete from visa_vcr_adn 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );

delete from fraud_advice 
   where trans_seq_nbr in (
         select trans_seq_nbr from in_draft_main a
         inner join masclr.in_file_log b on b.in_file_nbr=a.in_file_nbr
         where b.incoming_dt < &cutoff_date and b.end_dt < &cutoff_date
   );


delete from import_balancing
   where in_file_nbr in (  
         select in_file_nbr from in_file_log 
         where incoming_dt < &cutoff_date and end_dt < &cutoff_date
   ) ;
 
delete from in_draft_main
   where in_file_nbr in (  
         select in_file_nbr from in_file_log 
         where incoming_dt < &cutoff_date and end_dt < &cutoff_date
   ) ;
delete from admin_msg_log
   where in_file_nbr in (  
         select in_file_nbr from in_file_log 
         where incoming_dt < &cutoff_date and end_dt < &cutoff_date
   ) ;
   
delete from out_file_log 
    where FILE_CREATION_DT < &cutoff_date and end_dt < &cutoff_date
    ;
    
delete from out_batch_log
   where in_file_nbr in (  
         select in_file_nbr from in_file_log 
         where incoming_dt < &cutoff_date and end_dt < &cutoff_date
   ) ;
   
delete from cutoff_batch
   where in_file_nbr in (  
         select in_file_nbr from in_file_log 
         where incoming_dt < &cutoff_date and end_dt < &cutoff_date
   ) ;


   
delete from in_batch_log 
   where in_file_nbr in (  
         select in_file_nbr from in_file_log 
         where incoming_dt < &cutoff_date and end_dt < &cutoff_date
   ) ; 
 
delete from in_file_ctrl
   where external_file_name in ( 
         select external_file_name from in_file_log where in_file_nbr in ( 
              select in_file_nbr from in_file_log 
              where incoming_dt < &cutoff_date and end_dt < &cutoff_date
         )
    ) ;

delete from in_file_log
   where incoming_dt < &cutoff_date and end_dt < &cutoff_date ;

 
delete from in_draft_pin_debit 
   where trans_dt < &cutoff_date ; 

delete from sbc_pin_dbt_rpt 
   where local_trans_dt < &cutoff_date ; 

delete from amex_dispute_txn
   where log_date < &cutoff_date ; 

   
--commit ;
