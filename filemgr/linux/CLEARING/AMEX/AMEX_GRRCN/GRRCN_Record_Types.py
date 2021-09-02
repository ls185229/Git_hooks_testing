#!/usr/bin/env python3

"""
File Name:  Record_Types.py

Description: This script contains the class definitions for the various record types from
            the AMEX GRRCN file.

Specification Version: Raw Data - Global Reconciliation (GRRCN)
                    Technical File Specification - April 2021(REVISED)
"""


class SubmissionRecord:
    def __init__(self, inst_id, line):
        self.inst_id = inst_id
        self.record_type = line[0]
        self.payee_merchant_id = line[1]
        self.settlement_account_type_code = line[2]
        self.american_express_payment_number = line[3]
        self.payment_date = line[4]
        self.payment_currency = line[5]
        self.submission_merchant_id = line[6]
        self.business_submission_date = line[7]
        self.american_express_processing_date = line[8]
        self.submission_invoice_number = line[9]
        self.submission_currency = line[10]
        self.filler1 = line[11]
        self.submission_exchange_rate = line[12]
        self.submission_gross_amount_in_submission_currency = line[13]
        self.submission_gross_amount_in_payment_currency = line[14]
        self.submission_discount_amount = line[15]
        self.submission_service_fee_amount = line[16]
        self.submission_tax_amount = line[17]
        self.submission_net_amount = line[18]
        self.submission_discount_rate = line[19]
        self.submission_tax_rate = line[20]
        self.transaction_count = line[21]
        self.tracking_id = line[22]
        self.installment_number = line[23]
        self.acceleration_number = line[24]
        self.original_settlement_date = line[25]
        self.acceleration_date = line[26]
        self.number_of_days_in_advance = line[27]
        self.submission_acceleration_fee_amount = line[28]
        self.submission_acceleration_fee_net_amount = line[29]
        self.submission_debit_gross_amount = line[30]
        self.submission_credit_gross_amount = line[31]
        self.filler2 = ""


class TransactionRecord:
    def __init__(self, inst_id, line):
        self.inst_id = inst_id
        self.record_type = line[0]
        self.payee_merchant_id = line[1]
        self.settlement_account_type_code = line[2]
        self.american_express_payment_number = line[3]
        self.payment_date = line[4]
        self.payment_currency = line[5]
        self.submission_merchant_id = line[6]
        self.business_submission_date = line[7]
        self.american_express_processing_date = line[8]
        self.submission_invoice_number = line[9]
        self.submission_currency = line[10]
        self.merchant_location_id = line[11]
        self.invoice_or_reference_number = line[12]
        self.seller_id = line[13]
        self.cardmember_account_number = line[14]
        self.industry_specific_reference_number = line[15]
        self.submission_gross_amount_in_payment_currency = line[16]
        self.transaction_amount = line[17]
        self.transaction_date = line[18]
        self.transaction_time = line[19]
        self.transaction_id = line[20]
        self.approval_code = line[21]
        self.terminal_id = line[22]
        self.merchant_category_code = line[23]
        self.cardmember_reference_number = line[24]
        self.acquirer_reference_number = line[25]
        self.data_quality_non_compliant_indicator = line[26]
        self.data_quality_non_compliant_error_code_1 = line[27]
        self.data_quality_non_compliant_error_code_2 = line[28]
        self.data_quality_non_compliant_error_code_3 = line[29]
        self.data_quality_non_compliant_error_code_4 = line[30]
        self.non_swiped_indicator = line[31]
        self.transaction_rejected_indicator = line[32]
        self.first_installment_amount = line[33]
        self.subsequent_installment_amount = line[34]
        self.number_of_installments = line[35]
        self.installment_number = line[36]
        self.filler1 = line[37]
        self.service_fee_amount = line[38]
        self.acceleration_amount = line[39]
        self.filler2 = ""


class ChargebackRecord:
    def __init__(self, inst_id, line):
        self.inst_id = inst_id
        self.record_type = line[0]
        self.payee_merchant_id = line[1]
        self.settlement_account_type_code = line[2]
        self.american_express_payment_number = line[3]
        self.payment_date = line[4]
        self.payment_currency = line[5]
        self.submission_merchant_id = line[6]
        self.business_submission_date = line[7]
        self.merchant_location_id = line[8]
        self.invoice_or_reference_number = line[9]
        self.seller_id = line[10]
        self.cardmember_account_number = line[11]
        self.industry_specific_reference_number = line[12]
        self.american_express_processing_date = line[13]
        self.submission_invoice_number = line[14]
        self.submission_currency = line[15]
        self.chargeback_number = line[16]
        self.chargeback_reason_code = line[17]
        self.chargeback_reason_description = line[18]
        self.gross_amount = line[19]
        self.discount_amount = line[20]
        self.service_fee_amount = line[21]
        self.tax_amount = line[22]
        self.net_amount = line[23]
        self.discount_rate = line[24]
        self.service_fee_rate = line[25]
        self.batch_code = line[26]
        self.bill_code = line[27]
        self.filler = ""


class AdjustmentRecord:
    def __init__(self, inst_id, line):
        self.inst_id = inst_id
        self.record_type = line[0]
        self.payee_merchant_id = line[1]
        self.settlement_account_type_code = line[2]
        self.american_express_payment_number = line[3]
        self.payment_date = line[4]
        self.payment_currency = line[5]
        self.submission_merchant = line[6]
        self.business_submission_date = line[7]
        self.merchant_location_id = line[8]
        self.invoice_or_reference_number = line[9]
        self.seller_id = line[10]
        self.cardmember_account_number = line[11]
        self.industry_specific_reference_number = line[12]
        self.american_express_processing_date = line[13]
        self.submission_invoice_number = line[14]
        self.submission_currency = line[15]
        self.adjustment_number = line[16]
        self.adjustment_reason_code = line[17]
        self.adjustment_reason_description = line[18]
        self.gross_amount = line[19]
        self.discount_amount = line[20]
        self.service_fee_amount = line[21]
        self.tax_amount = line[22]
        self.net_amount = line[23]
        self.discount_rate = line[24]
        self.service_fee_rate = line[25]
        self.batch_code = line[26]
        self.bill_code = line[27]
        self.filler = ""


class TransactionPricingRecord:
    def __init__(self, inst_id, line):
        self.inst_id = inst_id
        self.record_type = line[0]
        self.payee_merchant_id = line[1]
        self.settlement_account_type_code = line[2]
        self.american_express_payment_number = line[3]
        self.payment_date = line[4]
        self.payment_currency = line[5]
        self.submission_merchant_id = line[6]
        self.merchant_location_id = line[7]
        self.filler = line[8]
        self.invoice_or_reference_number = line[9]
        self.seller_id = line[10]
        self.cardmember_account_number = line[11]
        self.transaction_amount = line[12]
        self.transaction_date = line[13]
        self.fee_code = line[14]
        self.filler = line[15]
        self.fee_amount = line[16]
        self.discount_rate = line[17]
        self.discount_amount = line[18]
        self.rounded_fee_amount = line[19]
        self.rounded_discount_amount = line[20]
        self.fee_amount_settlement_currency = line[21]
        self.discount_amount_settlement_currency = line[22]
        self.transaction_amount_settlement_currency = line[23]
        self.filler = ""


class FeesAndRevenueRecord:
    def __init__(self, inst_id, line):
        self.inst_id = inst_id
        self.record_type = line[0]
        self.payee_merchant_id = line[1]
        self.american_express_payment_number = line[2]
        self.payment_date = line[3]
        self.payment_currency = line[4]
        self.submission_merchant_id = line[5]
        self.merchant_location_id = line[6]
        self.fee_or_revenue_amount = line[7]
        self.fee_or_revenue_description = line[8]
        self.asset_billing_amount = line[9]
        self.asset_billing_description = line[10]
        self.asset_billing_tax = line[11]
        self.pay_in_gross_indicator = line[12]
        self.batch_code = line[13]
        self.bill_code = line[14]
        self.seller_id = ""
        self.filler = ""


class SummaryRecord:
    def __init__(self, inst_id, line):
        self.inst_id = inst_id
        self.record_type = line[0]
        self.payee_merchant_id = line[1]
        self.settlement_account_type_code = line[2]
        self.american_express_payment_number = line[3]
        self.payment_date = line[4]
        self.payment_currency = line[5]
        self.unique_payment_reference_number = line[6]
        self.payment_net_amount = line[7]
        self.payment_gross_amount = line[8]
        self.payment_discount_amount = line[9]
        self.payment_service_fee_amount = line[10]
        self.payment_adjustment_amount = line[11]
        self.payment_tax_amount = line[12]
        self.opening_debit_balance_amount = line[13]
        self.payee_direct_deposit_number = line[14]
        self.bank_account_number = line[15]
        self.international_bank_account_number = line[16]
        self.bank_identifier_code = line[17]
        self.filler = ""


class HeaderRecord:
    def __init__(self, inst_id, line):
        self.inst_id = inst_id
        self.record_type = line[0]
        self.file_creation_date = line[1]
        self.file_creation_time = line[2]
        self.sequential_number = line[3]
        self.file_id = line[4]
        self.file_name = line[5]
        self.file_version_number = line[6]
        self.filler = ""


class TrailerRecord:
    def __init__(self, inst_id, line):
        self.inst_id = inst_id
        self.record_type = line[0]
        self.sequential_number = line[1]
        self.total_record_count = line[2]
        self.filler = ""


