CREATE OR REPLACE PROCEDURE masclr.insert_representments(in_file_date IN VARCHAR2,
                                                         inserted_records OUT NUMBER) AS
/**********************************************************************************************************************
  Created Sept 2019 NQS
  This stored procedure creates Mastercard representments from data in MDR tabl
  Modified Oct 7th 2019 added in_file_date parameter
  Modified Oct 9th 2019 added use of cursor count to update global_seq_ctrl and "reserve" record sequence numbers
  Modified Nov 21st 2019 changed value inserted for incoming_dt to use following Monday when run on a weekend
  Modified Nov 26th 2019 added recon curr code column. Should avoid error mas_cb.tcl error message when value is null
  ********************************************************************************************************************/
        iFound NUMBER;
        iDone  NUMBER;
        iTSN   NUMBER;
        iFSN   NUMBER;
        iBSN   NUMBER;
        iEEL   NUMBER;
        CURSOR c1 is
        SELECT idm.trans_seq_nbr as trans_seq_nbr_orig
               ,m.MTI as msg_type
               ,'010103005301' as tid
               ,'05' as card_scheme
               ,idm.mas_code
               ,'05' as pri_dest_inst_id
               ,'55' as pri_dest_file_type
               ,idm.pri_dest_clr_mode
               ,idm.sec_dest_inst_id
               ,idm.sec_dest_file_type
               ,idm.sec_dest_clr_mode
               ,NVL(m.pan,idm.pan) as pan
               ,idm.p_cd_trans_type
               ,idm.p_cd_from_acct
               ,idm.p_cd_to_acct
               ,m.amount_reg as amt_trans
               ,m.Amount_Req_Iss_Curr as trans_ccd
               ,m.Currency_Exp as trans_exp
               ,TO_DATE(m.transaction_dt, 'yyyymmddhh24miss') as trans_dt
               ,idm.pos_crddat_in_cap
               ,idm.pos_ch_auth_cap
               ,idm.pos_crd_capt_cap
               ,idm.pos_operating_env
               ,idm.pos_ch_present
               ,idm.pos_crd_present
               ,idm.pos_crddat_in_mode
               ,idm.pos_ch_auth_method
               ,idm.pos_ch_auth_entity
               ,idm.pos_crddat_out_cap
               ,idm.pos_term_out_cap
               ,idm.pos_pin_capt_mode
               ,idm.pos_cat_level_ind
               ,m.function_cd
               ,m.card_acceptor_bus_cd as mcc
               ,m.arn
               ,CASE WHEN idm.msg_type = '1442' THEN receiving_inst_id ELSE NULL END AS forwarding_inst_id
               ,CASE WHEN idm.msg_type = '1442' THEN forwarding_inst_id ELSE NULL END  AS receiving_inst_id
               ,idm.auth_cd
               ,idm.merch_id
               ,NVL(TRIM(m.card_acceptor_Name),idm.merch_name) as merch_name
               ,idm.merch_address1
               ,idm.merch_city
               ,idm.merch_prov_state
               ,idm.merch_post_cd_zip
               ,idm.merch_cntry_cd_alp
               ,idm.settl_method_ind
               ,idm.doc_ind
               ,m.cycle_id as card_iss_ref_data
               ,idm.amt_trans as amt_original
               ,m.amount_req_iss_curr as original_ccd
               ,m.currency_exp as original_exp
               ,m.transaction_dest_inst_id_cd as trans_dest
               ,m.transaction_orig_inst_id_cd as trans_originator
               ,'X' as trans_clr_status
               ,to_char(TO_DATE(m.file_dt,'yyyymmddhh24miss'),'YYDDD') as clr_date_j
               ,m.file_id as external_file_id
               ,TO_DATE(m.file_dt,'yyyymmddhh24miss') as activity_dt
               ,m.amount_recon as amt_recon
               ,m.currency_exp as recon_exp
               ,m.recon_curr_cd as recon_ccd
               ,m.ch_billing_curr_cd as ch_bill_ccd
               ,m.retrieval_ref_nbr as retv_ref_nbr
               ,m.message_nbr as msg_nbr
               ,substr(NVL(m.rejection_reason,' '),1,250) as msg_text_block
               ,m.reversal_flag as reversal_ind
               ,message
          FROM  masclr.in_draft_main idm
               ,masclr.mdr m
         WHERE idm.arn = m.arn
           AND idm.trans_seq_nbr = (SELECT MAX(trans_seq_nbr) FROM masclr.in_draft_main WHERE arn = idm.arn )
           AND idm.arn NOT IN (SELECT id.arn FROM masclr.in_draft_main id, masclr.mdr md
                               WHERE md.arn = id.arn AND id.msg_type = '1240' AND id.external_file_id = md.file_id
                                 AND md.cycle_id = id.card_iss_ref_data)
           AND m.file_dt = in_file_date;
BEGIN
  iFound := 0;    
  iFSN := 1;
  iTSN := 0;
  iBSN := 0;  
  ieel := 0;
  iDone:= 0;
  
  SELECT COUNT(*) INTO iFound
	  FROM masclr.in_draft_main idm, masclr.mdr mdr
   WHERE mdr.arn = idm.arn
     AND idm.trans_seq_nbr = (SELECT MAX(trans_seq_nbr) FROM masclr.in_draft_main WHERE arn = idm.arn ) 
     AND idm.arn NOT IN (SELECT id.arn 
                           FROM masclr.in_draft_main id, masclr.mdr md
                          WHERE md.arn = id.arn 
                            AND id.msg_type = '1240'
                            AND id.external_file_id = md.file_id
                            AND md.cycle_id = id.card_iss_ref_data)
      AND mdr.file_dt = in_file_date; 
  
  DBMS_OUTPUT.put_line( 'MDR records found to add '||iFound);
  
  IF iFound > 0 THEN
    masclr.increase_global_seq_ctrl(iFound,'trans_seq_nbr', iTSN);
    masclr.increase_global_seq_ctrl(iFSN,'in_file_nbr', iFSN);
    masclr.increase_global_seq_ctrl(iFound,'ep_event_id',ieel);
        
    INSERT INTO masclr.in_file_log
        (in_file_nbr,
         institution_id,
         file_type,
         incoming_dt,
         external_file_name,
         in_file_status)
    VALUES
        (iFSN,
         '05',
         '55',
         CASE WHEN TO_CHAR(SYSDATE, 'DAY') = 'SATURDAY' THEN next_day(Sysdate, 'MONDAY') 
            WHEN TO_CHAR(SYSDATE, 'DAY') = 'SUNDAY' THEN next_day(Sysdate, 'MONDAY')
            ELSE SYSDATE
         END,
         'MDR_'||in_file_date,
         'P');
         
    FOR item IN c1
    LOOP
        
      INSERT INTO masclr.in_draft_main
       (trans_seq_nbr
       ,msg_type
       ,tid
       ,card_scheme
       ,mas_code
       ,in_file_nbr
       ,in_batch_nbr
       ,pri_dest_inst_id
       ,pri_dest_file_type
       ,pri_dest_clr_mode
       ,sec_dest_inst_id
       ,sec_dest_file_type
       ,sec_dest_clr_mode
       ,pan
       ,p_cd_trans_type
       ,p_cd_from_acct
       ,p_cd_to_acct
       ,amt_trans
       ,trans_ccd
       ,trans_exp
       ,trans_dt
       ,pos_ch_auth_cap
       ,pos_crd_capt_cap
       ,pos_operating_env
       ,pos_ch_present
       ,pos_crd_present
       ,pos_crddat_in_mode
       ,pos_ch_auth_method
       ,pos_ch_auth_entity
       ,pos_crddat_out_cap
       ,pos_term_out_cap
       ,pos_pin_capt_mode
       ,pos_cat_level_ind
       ,function_cd
       ,reason_cd
       ,mcc
       ,arn
       ,forwarding_inst_id
       ,receiving_inst_id
       ,auth_cd
       ,merch_id
       ,merch_address1
       ,merch_city
       ,merch_prov_state
       ,merch_post_cd_zip
       ,merch_cntry_cd_alp
       ,settl_method_ind
       ,doc_ind
       ,card_iss_ref_data
       ,amt_original
       ,original_ccd
       ,original_exp
       ,trans_dest
       ,trans_originator
       ,trans_clr_status
       ,clr_date_j
       ,external_file_id
       ,activity_dt
       ,amt_recon
       ,recon_exp
       ,recon_ccd
       ,ch_bill_ccd
       ,retv_ref_nbr
       ,msg_nbr
       ,msg_text_block
       ,reversal_ind
       )
    VALUES 
       (iTSN
       ,item.msg_type
       ,item.tid
       ,item.card_scheme
       ,item.mas_code
       ,iFSN
       ,iBSN
       ,item.pri_dest_inst_id
       ,item.pri_dest_file_type
       ,item.pri_dest_clr_mode
       ,item.sec_dest_inst_id
       ,item.sec_dest_file_type
       ,item.sec_dest_clr_mode
       ,item.pan
       ,item.p_cd_trans_type
       ,item.p_cd_from_acct
       ,item.p_cd_to_acct
       ,item.amt_trans
       ,item.trans_ccd
       ,item.trans_exp
       ,item.trans_dt
       ,item.pos_ch_auth_cap
       ,item.pos_crddat_in_cap
       ,item.pos_operating_env
       ,item.pos_ch_present
       ,item.pos_crd_present
       ,item.pos_crddat_in_mode
       ,item.pos_ch_auth_method
       ,item.pos_ch_auth_entity
       ,item.pos_crddat_out_cap
       ,item.pos_term_out_cap
       ,item.pos_pin_capt_mode
       ,item.pos_cat_level_ind
       ,item.function_cd
       ,item.message
       ,item.mcc
       ,item.arn
       ,item.forwarding_inst_id
       ,item.receiving_inst_id
       ,item.auth_cd
       ,item.merch_id
       ,item.merch_address1
       ,item.merch_city
       ,item.merch_prov_state
       ,item.merch_post_cd_zip
       ,item.merch_cntry_cd_alp
       ,item.settl_method_ind
       ,item.doc_ind
       ,item.card_iss_ref_data
       ,item.amt_original
       ,item.original_ccd
       ,item.original_exp
       ,item.trans_dest
       ,item.trans_originator
       ,item.trans_clr_status
       ,item.clr_date_j
       ,item.external_file_id
       ,item.activity_dt
       ,item.amt_recon
       ,item.recon_exp
       ,item.recon_ccd
       ,item.ch_bill_ccd
       ,item.retv_ref_nbr
       ,item.msg_nbr
       ,item.msg_text_block
       ,item.reversal_ind
       ); 
       
       INSERT INTO masclr.ep_event_log
      ( in_file_nbr 
       ,ep_event_id
       ,institution_id
       ,trans_seq_nbr
       ,trans_seq_nbr_orig
       ,card_scheme
       ,pan
       ,pan_seq
       ,arn
       ,send_id
       ,receive_id
       ,trans_dt
       ,merch_id
       ,amt_ch_bill
       ,ch_bill_exp
       ,amt_trans
       ,trans_ccd
       ,trans_exp
       ,ems_oper_amt_cr
       ,ems_oper_amt_db
       ,ems_oper_exp
       ,reason_cd
       ,event_log_date
       )
      VALUES 
      ( iFSN
       ,ieel
       ,item.sec_dest_inst_id
       ,itsn
       ,item.trans_seq_nbr_orig
       ,item.card_scheme
       ,item.pan
       ,0
       ,item.arn
       ,0
       ,0
       ,item.Trans_dt
       ,item.merch_id
       ,0
       ,0
       ,item.Amt_trans
       ,item.Trans_CCD
       ,item.trans_exp
       ,0
       ,0
       ,0
       ,item.message
       ,item.activity_dt
       );
       
      iTSN := iTSN + 1;
      ieel := ieel + 1;
      iDone := iDone+1;
      END LOOP;
      UPDATE masclr.in_file_log
         SET in_file_status = 'C',
             end_dt = SYSDATE
       WHERE in_file_nbr = iFSN;
       
      COMMIT;
      DBMS_OUTPUT.put_line('Added records '||iDone); 
	    inserted_records := iDone;
    ELSE
      DBMS_OUTPUT.put_line('No new records found');
      inserted_records := 0;
    END IF;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.put_line('in_file_nbr '||iFSN);
    DBMS_OUTPUT.put_line('in_batch_nbr '||iBSN);
    DBMS_OUTPUT.put_line('trans_seq_nbr '||iTSN);
    DBMS_OUTPUT.put_line('ep_event_id '||ieel);
    DBMS_OUTPUT.put_line('Added records '||iDone);
	  inserted_records := iDone;
    RAISE;
END;
/

