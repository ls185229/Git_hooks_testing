/*
    File Name - revert_monthly_settle.sql

    Description - This file reverts the changes made in monthly_settle.sql

*/
DECLARE
fee_pkg_id_0_rate NUMBER;
fee_pkg_id_04_rate NUMBER;
type num_array is varray(5) of NUMBER;
inst_array num_array;

BEGIN
inst_array := num_array(101,105,107,121);
FOR inst IN 1 .. inst_array.count LOOP

    --COLLECT most recent fee_pkg_ids for deletion
    SELECT last_seq_nbr-1, last_seq_nbr
    INTO fee_pkg_id_0_rate, fee_pkg_id_04_rate
    FROM MASCLR.seq_ctrl
    WHERE seq_name = 'fee_pkg_id'
    AND institution_id = inst_array(inst);

    --DELETE entries from  entity_fee_pkg
    DELETE FROM entity_fee_pkg
    WHERE fee_pkg_id = fee_pkg_id_04_rate;

    --DELETE entries from mas_fees
    DELETE FROM mas_fees
    WHERE fee_pkg_id = fee_pkg_id_04_rate
    OR fee_pkg_id = fee_pkg_id_0_rate;

    --DELETE entries from fee_pkg_mas_code
    DELETE FROM fee_pkg_mas_code
    WHERE fee_pkg_id = fee_pkg_id_04_rate
    OR fee_pkg_id = fee_pkg_id_0_rate;

    --DELETE entries from fee_pkg_tid
    DELETE FROM fee_pkg_tid
    WHERE fee_pkg_id = fee_pkg_id_04_rate
    OR fee_pkg_id = fee_pkg_id_0_rate;

    --DELETE entries from fee_pkg
    DELETE FROM fee_pkg
    WHERE fee_pkg_id = fee_pkg_id_04_rate
    OR fee_pkg_id = fee_pkg_id_0_rate;

    --UPDATE SEQ CTRL Table
    UPDATE MASCLR.seq_ctrl
    SET last_seq_nbr = fee_pkg_id_0_rate - 1
    WHERE seq_name = 'fee_pkg_id'
    AND institution_id = inst_array(inst);

END LOOP;
--REVERT FEE_STATUS from 'O' to 'C'
    UPDATE MASCLR.mas_fees
    SET fee_status = 'C'
    WHERE mas_code = 'MONTHLY_SETTLE'
    AND fee_pkg_id = 46;
END;