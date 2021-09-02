CREATE OR REPLACE PROCEDURE masclr.increase_global_seq_ctrl(in_by_nbr in NUMBER,
                                                            in_seq_name in VARCHAR2,
                                                            out_nbr out NUMBER) as                                                          
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
      
      SELECT last_seq_nbr+1 INTO out_nbr FROM masclr.global_seq_ctrl WHERE seq_name = in_seq_name;
      UPDATE masclr.global_seq_ctrl gsc SET gsc.last_seq_nbr = gsc.last_seq_nbr+in_by_nbr WHERE gsc.seq_name = in_seq_name;
      COMMIT;
END;
/
