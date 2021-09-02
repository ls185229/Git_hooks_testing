#!/usr/bin/env tclsh
#
# Version 0.00 Joe Cloud 4/30/05
# Code to pull the TC 57 files created for the EFunds Base II program apart
#
# Internal Version 1.00
# Version modified by MGI 06-19-2009
# Tested by MGI
#    Updates made to support changed TCR records;
#    Added parsing for TC50 purchasing card records.
#
##################################################################################################################


# Global Variable
set LINE_SIZE 168.0

package require Oratcl
#package require Mpexpr

# File Header
set TCR(90) {
    tc n 2 {Transaction Code}
    proc_bin a 6 {Processing BIN}
    proc_date n 5 {Processing Date}
    rsrvd1 a 16 {Reserved}
    test_opt a 4 {Test Option}
    rsrvd2 a 29 {Reserved}
    sec_code a 8 {Security Code}
    rsrvd3 a 6 {Reserved}
    file_id n 3 {Outgoing File ID}
    rsrvd4 a 89 {Reserved}
};# end set TCR(90)

# First Batch Header
set TCR(57-0-0-1) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    dest_bin n 6 {Destination BIN}
    src_bin n 6 {Source BIN}
    rsrvd1 a 6 {Reserved}
    tran_amt n 12 {Transaction Amount}
    rsrvd2 a 3 {Reserved}
    draft_flag a 1 {Draft Flag}
    cp_date a 4 {Central Processing Date}
    rec_fmt_code a 2 {Record Format Code}
    rev_flag a 1 {Reversal Flag}
    disc_a_id n 11 {Discover Acquirer ID}
    rsrvd3 a 12 {Reserved}
    dcp_date a 4 {Data Capture Processing Date}
    rsrvd4 a 2 {Reserved}
    agent n 6 {Agent}
    chain n 6 {Chain}
    merc_num n 16 {Merchant Number}
    store_num n 4 {Store Number}
    term_num n 4 {Terminal Number}
    batch_num n 5 {Merchant Batch Number}
    batch_date n 4 {Merchant Batch Date}
    ds_merc_id a 15 {Discover Merchant ID}
    xmit_time n 6 {Batch Transmit Time}
    time_zone a 3 {Time Zone}
    gmt_offset a 3 {GMT Offset}
    merc_sec_code n 5 {Merchant Security Code}
    rsrvd5 n 2 {Reserved}
    batch_key a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    reimburse_attr n 1 {Reimbursement Attribute}
};# end set TCR(57-0-0-1)

# Second Batch Header
set TCR(57-0-1-1) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    rsrvd1 a 12 {Reserved}
    dev_code a 1 {Device Code}
    rsrvd2 a 4 {Reserved}
    its_num a 8 {Internal Terminal Serial Number}
    mcc n 4 {Merchant Category Code}
    merc_name a 25 {Merchant Name}
    merc_city a 13 {Merchant City}
    merc_state a 3 {Merchant State/Province Code}
    merc_country a 3 {Merchant Country Code}
    merc_zip a 5 {Merchant Zip Code}
    rsrvd3 a 4 {Reserved}
    tran_route a 1 {Transmission Route}
    term_loc_num n 5 {Terminal Locator Number}
    postal_code a 11 {Merchant Postal Code}
    rsrvd4 a 50 {Reserved}
    batch_key a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    rsrvd5 a 1 {Reserved}
};# end set TCR(57-0-1-1)

# AMEX Batch Header
set TCR(57-0-2-1) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    res1 a 12 {Reserved}
    SEN a 10 {Service Establishment Number}
    format_code a 2 {Format Code}
    invoice_batch n 3 {Invoice Batch}
    invoice_sub n 2 {Invoice Sub Code}
    PCI n 6 {Process Control ID}
    file_seq_num n 6 {File Sequence Number}
    CAP a 10 {Chain Affiliated Property}
    service_city a 18 {Service Established City}
    res2 a 80 {Reserved}
    batch_key a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    res3 a 1 {Reserved}
};# end set TCR(57-0-2-1)

# Transaction Detail - AMEX
set TCR(57-0-2-2) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    res1 a 12 {Reserved}
    format_code a 2 {Format Code}
    I3Q a 3 {Item 3 Quantity}
    I3D n 15 {Item 3 Description}
    I3UP a 8 {Item 3 Unit Price}
    I3TP n 8 {Item 3 Total Price}
    I4Q n 3 {Item 4 Quantity}
    I4D a 15 {Item 4 Description}
    I4UP n 8 {Item 4 Unit Price}
    I4TP n 8 {Item 4 Total Price}
    res2 a 67 {Reserved}
    batch_key a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    res3 a 1 {Reserved}
};# end set TCR(57-0-2-2)

# Transaction Detail
set TCR(57-0-0-2) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    dest_bin n 6 {Destination BIN}
    src_bin n 6 {Source BIN}
    sc_ind a 2 {Special Condition Indicators}
    tran_cq n 1 {Transaction Code Qualifier}
    recur_pmt_ind a 1 {Recurring Payment Indicator}
    year_transdate a 2 {Year Info For TXN Date}
    tran_amt n 12 {Transaction Amount}
    cur_code a 3 {Transaction Currency Code}
    drft_sent_flg a 1 {Draft Sent Flag}
    cp_date n 4 {Central Processing Date}
    fmt_code a 2 {Record Format Code}
    rev_flag a 1 {Reversal Flag}
    cat_ind a 1 {Cat Level Indicator}
    prepaid_crd a 1 {Prepaid Card Indicator}
    chip_code a 1 {Chip Condition Code}
    card_type a 1 {Card Type}
    pan a 19 {Account Number}
    purch_date n 4 {Purchase Date}
    tran_time n 4 {Transaction Time}
    tran_type a 1 {Transaction Type}
    void_ind a 1 {Transaction Void Indicator}
    entry_method a 1 {Card Entry Method}
    ch_id_method a 1 {Cardholder ID Method}
    auth_code a 6 {Authorization Code}
    auth_source a 1 {Authorization Source Code}
    film_loc n 11 {Film Locator}
    tip_cashbk a 12 {Tip/Cashback}
    moto_ec_ind a 1 {MOTO or Electronic Commerce Indicator}
    debit_ind a 1 {Debit Indicator}
    rsrch_code a 1 {Research Code}
    netwrk_id a 1 {Network ID}
    settle_date n 4 {Settlement Date}
    dta_num a 6 {Debit Trace Audit Number}
    posdra a 1 {POS Debit Reimbursement Attribute}
    debit_date n 4 {Debit Trans Date}
    debit_time n 6 {Debit Trans Time}
    ret_ref_num a 12 {Retrieval Reference Number}
    avs a 1 {AVS response code}
    crb_exc_ind a 1 {CRB Exception File Indicator}
    atm_account a 1 {ATM Account Selection}
    aci a 1 {Authorization Characteristics Indicator}
    pos_entry a 2 {POS Entry Mode}
    batch_key a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    reimburse_attr a 1 {Reimbursement Attribute}
};# end set TCR(57-0-2)

# Transaction Detail - Payment Service Data
set TCR(57-0-3-2) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    auth_response a 2 {Authorization Response Code}
    auth_amount n 12 {Authorized Amount}
    tran_id n 15 {Transaction Identifier}
    val_code a 4 {Validation Code}
    clr_seq_num n 2 {Multiple Clearing Sequence Number}
    clr_seq_count n 2 {Multiple Clearing Sequence Count}
    mkt_auth_data a 1 {Market-specific Authorization Data Identifier}
    total_amount n 12 {Total Authorized Amount}
    aci a 1 {Submitted Authorization Characteristics Indicator}
    moto_ph_num a 11 {MOTO Customer Service Phone Number}
    moto_ph_flag a 1 {MOTO Customer Service PHone Flag}
    moto_seq_num n 2 {MOTO Installment Sequence Number}
    moto_seq_count n 2 {MOTO Installment Sequence Count}
    egoods_ind a 2 {Electronic Commerce Goods Indicator}
    reward_id a 6 {Rewards Program Identifier}
    crd_lvl_rslt a 2 {Card Level Results Reserved}
    cvv2 a 1 {CVV2 Response Code}
    mvv a 10 {Merchant Verification Value}
    reserved1 a 61 {Reserved}
    batch_key a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    reserved2 a 1 {Reserved}
};# end set TCR(57-0-3-2)

# Mastercard Compliance Data
set TCR(57-0-5-2) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    reserved1 a 11 {Reserved}
    banknet_num a 9 {Banknet Settlement Number}
    banknet_date a 4 {Banknet Settlement Date}
    val_code a 4 {Validation Code}
    ucaf_sec a 1 {UCAF - Ecomm Security Protocol}
    ucaf_cha a 1 {UCAF - Ecomm Cardholder Authentication}
    ucaf_us a 1 {UCAF - Ecomm UCAF Status}
    reserved2 a 5 {Reserved}
    auth_amount n 12 {Authorization Amount}
    service_code a 3 {Service Code}
    pos_sd a 12 {POS Service Data}
    reserved3 a 86 {Reserved}
    batch_key a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    reimburse_attr a 1 {Reimbursement Attribute}
};# end set TCR(57-0-5-2)

# Visa Lodging
set TCR(57-0-4-2) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    res a 12 {Reserved}
    bfc a 2 {Business Format Code}
    res1 a 8 {Reserved}
    lodging_no_show_ind a 1 {Lodging No Show Indicator}
    lodging_extra n 6 {Lodging Extra Charges}
    res2 a 4 {Reserved}
    check_in n 6 {Loding check in date}
    daily_rate n 12 {Daily room rate}
    total_tax n 12 {Total Tax}
    prepaid_exp n 12 {Prepaid Expenses}
    food_charge n 12 {Food/Beverage charge}
    folio_cash_advance n 12 {Folio Cash Advance}
    room_nights n 2 {Room nights}
    room_tax n 12 {Room Tax}
    res3 a 36 {Reserved}
    imbk a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    res4 a 1 {Reserved}
};# end set TCR(57-0-4-2)

# Dynamic Descriptor
set TCR(57-0-1-2) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    reserved1 a 12 {Reserved}
    format_code a 2 {Format Code}
    dd a 25 {Dynamic Descriptor}
    cus_ser_phno a 16 {Customer Service Phone Number}
    reserved2 a 107 {Reserved}
    rec_type a 1 {Record Type}
    rec_ind a 1 {Record Indicator}
};# end set TCR(57-0-1-2)

# Dynamic Descriptor Discover
set TCR(57-0-1-9) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    reserved1 a 12 {Reserved}
    format_code a 2 {Format Code}
    dd a 25 {Dynamic Descriptor}
    cus_ser_phno a 16 {Customer Service Phone Number}
    reserved2 a 107 {Reserved}
    rec_type a 1 {Record Type}
    rec_ind a 1 {Record Indicator}
};# end set TCR(57-0-1-2)

#Visa Transport
set TCR(57-0-4-2V) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    l3_fbc a 6 {Leg 3 Fare Basis Code}
    l4_fbc a 6 {Leg 4 Fare Basis Code}
    bfc a 2 {Business Format Code}
    crs a 4 {Computerized REservation System}
    res a 4 {Reserved}
    pass_name a 20 {Passenger Name}
    depart_date n 6 {Departure Date}
    orig_city a 3 {Origination City/Airport Code}
    leg1 a 7 {Leg 1}
    leg2 a 7 {Leg 2}
    leg3 a 7 {Leg 3}
    leg4 a 7 {Leg 4}
    tac a 8 {Travel Agency Code}
    tan a 25 {Travel Agency Number}
    rti a 1 {Restricted Ticket Indicator}
    otn a 13 {Original Ticket Number}
    l1_fbc a 6 {Leg 1 Fare Basis Code}
    l1_fn a 5 {Leg 1 Flight Number}
    l2_fbc a 6 {Leg 2 Fare Basis Code}
    l2_fn a 5 {Leg 2 Flight Number}
    res1 a 1 {Reserved}
    imbk a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    res4 a 1 {Reserved}
};# end set TCR(57-0-4-2V)

# MasterCard Transport
set TCR(57-0-4-2M) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    pass_name a 12 {Passenger Name}
    bfc a 2 {Business Format Code}
    ticket_number n 15 {Ticket Number}
    res1 n 7 {Reserved}
    issuing_carrier a 4 {Issuing Carrier}
    customer_code a 25 {Customer Code}
    tac a 8 {Travel Agency Code}
    tan a 25 {Travel Agency Number}
    total_fare n 12 {Total Fare}
    l1_travel_date n 6 {Leg 1 Travel Date}
    l1_carrier_code a 2 {Leg 1 Carrier Code}
    l1_scc a 1 {Leg 1 Service Class Code}
    l1_orig_city a 3 {Leg 1 Origination City/Airport Code}
    l1_desc_city a 3 {Leg 1 Destination City/Airport Code}
    l1_soc a 1 {leg 1 Stop over Code}
    l1_fbc a 6 {Leg 1 Fare Basis Code}
    l1_flight_number a 5 {Leg 1 Flight Number}
    l1_dep_time n 4 {Leg 1 Depature Time}
    l1_dep_time_seg n 1 {Leg 1 Depature Time Segment}
    res2 a 7 {Reserved}
    imbk a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    res3 a 1 {Reserved}
};# end set TCR(57-0-4-2M)

# MasterCard Lodging
set TCR(57-0-4-3) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    arrival_date n 6 {Arrival Date}
    depart_date n 6 {Departure Date}
    bfc n 2 {Business Format Code}
    folio a 10 {Folio Number}
    property_phone n 10 {Property Phone Number}
    cust_serv_phone n 10 {Customer Service Phone Number}
    room_rate n 12 {Room Rate}
    room_tax n 12 {Room Tax}
    total_tax n 12 {Total Tax}
    res1 a 47 {Reserved}
    total_room_nights n 4 {Total Room Nights}
    fsai a 1 {Fire Safety Act Indicator}
    customer_code a 17 {Customer Code}
    imbk a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    res4 a 1 {Reserved}
};# end set TCR(57-0-4-3)

# Visa Purchasing Card
set TCR(57-0-5-2V) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    local_tax n 9 {Local Tax}
    tax_included n 1 {Tax included}
    PIF a 1 {Purchase Identifier Format}
    PI a 25 {Purchase Identifier}
    national_tax_included n 1 {National Tax Included}
    national_tax n 12 {National Tax}
    CRI a 17 {Customer Reference Identifier}
    BRN a 20 {Business Refernce Number}
    customer_vat a 13 {Customer VAT}
    scc a 4 {Summary Commodity Code}
    other_tax n 12 {Other Tax}
    PC1 a 2 {Product Code}
    PC2 a 2 {Product Code}
    PC3 a 2 {Product Code}
    PC4 a 2 {Product Code}
    PC5 a 2 {Product Code}
    PC6 a 2 {Product Code}
    PC7 a 2 {Product Code}
    PC8 a 2 {Product Code}
    res a 1 {Reserved}
    mi a 15 {Message Identifier}
    version_code a 2 {Version Code}
    imbk a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    res1 a 1 {Reserved}
};# end set TCR(57-0-5-2)

# TC50 - Visa Commercial Purchasing Card
set TCR(50-0-0-4) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    dest_bin n 6 {Destination BIN}
    src_bin n 6 {Source BIN}
    serv_idnfr a 6 {Service Identifier}
    msg_idnfr a 15 {Message Identifier}
    item_seq_nbr n 3 {Item Sequence Number}
    item_commodity_cd a 12 {Item Commodity Code}
    item_desc a 26 {Item Descriptor}
    product_code a 12 {product_code}
    quantity n 12 {Quantity}
    unit_measure a 12 {Unit of Measure}
    unit_cost n 12 {Unit Cost}
    tax_amt n 12 {VAT Tax Amount}
    tax_rate n 4 {VAT Tax Rate}
    desc_per_itm n 12 {Discount per Line Item}
    line_item_tot n 12 {Line Item Total}
    line_item_dtl_ind n 1 {Line Item Detail Indicator}
    rem_attrib a 1 {Reimbursement Attribute}
};# end set TCR(50-0-0-4)

# TC50 - MasterCard Purchasing Card Line Item Detail Layout
set TCR(50-0-0-5) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    dest_bin n 6 {Destination BIN}
    src_bin n 6 {Source BIN}
    serv_idnfr a 6 {Service Identifier}
    msg_idnfr a 15 {Message Identifier}
    item_seq_nbr n 3 {Item Sequence Number}
    debit_credit_ind a 1 {Debit and Credit Indicator}
    tax_type_apld a 4 {Tax Type Applied}
    net_gross_ind a 1 {Net or Gross Indicator}
    disc_amt_ind a 1 {Discount Amount Indicator}
    reseved a 5 {Reserved}
    item_desc a 26 {Item Descriptor}
    product_code a 12 {product_code}
    quantity n 12 {Quantity}
    unit_measure a 12 {Unit of Measure}
    unit_cost n 12 {Unit Cost}
    tax_amt n 12 {VAT Tax Amount}
    tax_rate n 4 {VAT Tax Rate}
    desc_per_itm n 12 {Discount per Line Item}
    alt_tax_id n 15 {Alternate Tax Id}
    rem_attrib a 1 {Reimbursement Attribute}
};# end set TCR(50-0-0-5)

# Discover Additional Data
set TCR(57-0-1-00) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence}
    sdr a 2 {Reserved}
    pro_code a 6 {Processing Code}
    psi a 1 {Partial Shipment Indicator}
    tran_date n 6 {Transaction Date}
    tran_time a 6 {Transaction Time}
    pos_entry a 3 {POS Entry Mode}
    tdcc a 2 {Track Data Condition Code}
    pos_data a 13 {POS Data}
    response_code a 2 {Response Code}
    network_refernce a 15 {Network Reference ID}
    res2 a 107 {Reserved}
    ind a 1 {Indicator .D. - Discover related}
};# end set TCR(57-0-1-00)

#Discover Statement
set TCR(57-0-3-01) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence}
    sdr a 2 {SDR Type 01}
    seq_nbr a 2 {Sequence Number 01}
    message a 40 {Statement Message}
    filler a 119 {Filler Spaces}
    ind a 1 {Indicator .D. - Discover related}
};# end set TCR(57-0-3-01)

#Discover Tip
set TCR(57-0-3-02) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence}
    sdr a 2 {SDR Type 02}
    seq_nbr a 2 {Sequence Number 01}
    tip n 12 {Tip Amount}
    filler a 147 {Filler Spaces}
    ind a 1 {Indicator .D. - Discover related}
};# end set TCR(57-0-3-02)

#Discover Cash Over
set TCR(57-0-3-03) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence}
    sdr a 2 {SDR Type 03}
    seq_nbr a 2 {Sequence Number 01}
    cash_over n 12 {Cash Over}
    filler a 147 {Filler Spaces}
    ind a 1 {Indicator .D. - Discover related}
};# end set TCR(57-0-3-03)

#Discover Address
set TCR(57-0-3-04) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence}
    sdr a 2 {SDR Type 04}
    seq_nbr a 2 {Sequence Number 01}
    zip a 15 {Postal ZIP Code}
    store_number a 5 {Merchant Store Number}
    mall_name a 21 {Mall Name}
    phone_number a 10 {Phone Number}
    filler a 108 {Filler Spaces}
    ind a 1 {Indicator .D. - Discover related}
};# end set TCR(57-0-3-04)

#Discover Lodging
set TCR(57-0-3-09) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence}
    sdr a 2 {SDR Type 09}
    seq_nbr a 2 {Sequence Number 01}
    promo_code a 12 {Promotional Code}
    coupon_code a 12 {Coupon Code}
    ccc a 12 {Coporate Client Code}
    room_loc a 10 {Room Location}
    bed_type a 12 {Bed Type}
    room_type a 12 {Room Type}
    smoking a 1 {Smoking Preference}
    nbr_rooms n 2 {Number of Rooms}
    nbr_adults n 2 {Number of Adults}
    tax n 10 {Tax Elements}
    no_show a 1 {No Show Indicator}
    travel_code a 8 {Travel Agency Code}
    extra_charge n 12 {Extra Charges}
    travel_agency_name a 25 {Travel Agency Name}
    filler a 16 {Filler Spaces}
    ind a 1 {Indicator .D. - Discover related}
};# end set TCR(57-0-3-09)

#Discover Lodging 2
set TCR(57-0-3-92) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence}
    sdr a 2 {SDR Type 09}
    seq_nbr a 2 {Sequence Number 02}
    arrival n 8 {Arrival Date CCYYMMDD}
    depart n 8 {Depart Date CCYYMMDD}
    folio a 10 {Folio Number}
    fac_phone a 16 {Facility Phone}
    adjustment_amount n 12 {Adjestment Amount}
    room_rate n 12 {Room Rate}
    room_tax n 12 {Room Tax}
    program a 2 {Program Code}
    phone_charge n 12 {Phone Charge}
    rest_charge n 12 {Restraunt Charge}
    mini_bar_charge n 12 {Mini Bar Charge}
    laun_charge n 12 {Laundry Charge}
    other_charge n 12 {Other Charge}
    other_ind a 2 {Other Indicator}
    gift_charge n 12 {Gift Shop Charge}
    filler a 4 {Filler Spaces}
    ind a 1 {Indicator .D. - Discover related}
};# end set TCR(57-0-3-92)

# MasterCard Purchasing Card
set TCR(57-0-6-2) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    sales_tax n 12 {Sales Tax}
    sales_tax_included a 1 {Sales Tax included}
    customer_code a 25 {Customer Code}
    commodity_code a 15 {Commodity Code}
    merchant_type a 4 {Merchant Type}
    merchant_reference_number a 25 {Merchant Refence Number}
    merchant_tax_identifier a 20 {Merchant Tax Identifier}
    res a 30 {Reserved}
    mi a 15 {Message Identifier}
    version_code a 2 {Version Code}
    imbk a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    res1 a 1 {Reserved}
};# end set TCR(57-0-6-2)

#MasterCard Purchasing Item
set TCR(57-0-9-M2) {
        tc n 2 {Transaction Code}
        tcq n 1 {Transaction Code Qualifier}
        tcn n 1 {Transaction Component Sequence Number}
        dest_bin n 6 {Destination BIN}
        src_bin n 6 {Source BIN}
        rec_type a 2 {Record Type Purchase item for Master-Card}
        customer_code a 25 {Customer Code}
        line_item_dt n 6 {Line Item Date YYMMDD}
        tot_taxamt n 12 {Total TaxAmount}
        tot_tax_amt_exp n 1 {Total Tax Amount Exponent}
        tot_tax_amt_sign a 1 {Total Tax Amount Sign}
        tot_tax_col_ind a 1 {Total Tax Collect Indicator}
        ship_dt n 6 {Ship Date YYMMDD}
        order_dt n 6 {Order Date YYMMDD}
        ms_hlth_indus_nbr a 40 {Medical Service Ship to Health Indicatorustry Number}
        contract_nbr a 40 {Contract number}
        ms_price_adj a 1 {MedicalService Price adjustment}
        ms_product_nbr a 2 {Medical Service Product Number Qualifier}
        product_code a 15 {Product Code}
        item_desc a 35 {Item Description}
        item_qty n 12 {Item Quantity}
        item_qty_exp a 1 {Item Quantity Exponent}
        itemunit_measure a 12 {ItemUnit of Measure}
        itemunit_price n 12 {ItemUnit Price}
        itemunit_price_exp n 1 {ItemUnit Price Exponent}
        ext_item_amt n 12 {Extended Item Amount}
        ext_item_exp n 1 {Extended Item Exponent}
        ext_item_sign a 1 {Extended Item Sign}
        item_discount_ind a 1 {Item Discount Indicator}
        item_discount_amt n 12 {Item Discount Amount}
        item_discount_rt n 5 {Item Discount Rate}
        item_discount_rt_exp n 1 {Item Discount Rate Exponent}
        item_discount_sign a 1 {Item Discount Sign}
        zero_cost_cust_ind a 1 {Zero Cost to Customer Indicator}
        debit_credit_ind a 1 {Debit Credit Indicator}
        commodity_code a 15 {Commodity Code}
        dtl_tax_amt1_ind a 1 {Detail Tax Amount1 Indicator}
        dtl_tax_amt1_amt n 12 {Detail Tax Amount1 Amount}
        dtl_tax_amt1_rt n 5 {Detail Tax Amount1 Rate}
        dtl_tax_amt1_exp n 1 {Detail Tax Amount1 Exponent}
        dtl_tax_amt1_apld a 4 {Detail Tax Amount1 Type Applied}
        dtl_tax_amt1_idnfr a 2 {Detail Tax Amount1 Type Identifier}
        dtl_ca_taxid1 a 20 {Detail Card Acceptor TaxID1}
        dtl_tax_amt1_sign a 1 {Detail Tax Amount1 Sign}
        dtl_tax_amt2_ind a 1 {Detail Tax Amount2 Indicator}
        dtl_tax_amt2_amt n 12 {Detail Tax Amount2 Amount}
        dtl_tax_amt2_rt n 5 {Detail Tax Amount2 Rate}
        dtl_tax_amt2_exp n 1 {Detail Tax Amount2 Exponent}
        dtl_tax_amt2_apld a 4 {Detail Tax Amount2 Type Applied}
        dtl_tax_amt2_idnfr a 2 {Detail Tax Amount2 Type Identifier}
        dtl_ca_taxid2 a 20 {Detail Card Acceptor TaxID2}
        dtl_tax_amt2_sign a 1 {Detail Tax Amount2 Sign}
        dtl_tax_amt3_ind a 1 {Detail Tax Amount3 Indicator}
        dtl_tax_amt3_amt n 12 {Detail Tax Amount3 Amount}
        dtl_tax_amt3_rt n 5 {Detail Tax Amount3 Rate}
        dtl_tax_amt3_exp n 1 {Detail Tax Amount3 Exponent}
        dtl_tax_amt3_apld a 4 {Detail Tax Amount3 Type Applied}
        dtl_tax_amt3_idnfr a 2 {Detail Tax Amount3 Type Identifier}
        dtl_ca_taxid3 a 20 {Detail Card Acceptor TaxID3}
        dtl_tax_amt3_sign a 1 {Detail Tax Amount3 Sign}
        of_supply a 2 {Type of Supply}
        tax_exempt_ind a 1 {Tax Exempt Indicator}
        vat_inv_ref_nbr a 17 {Unique VAT Invoice Reference Number}
        dtl_tax_amt4_ind a 1 {Detail Tax Amount4 Indicator}
        dtl_tax_amt4_amt n 12 {Detail Tax Amount4 Amount}
        dtl_tax_amt4_rt n 5 {Detail Tax Amount4 Rate}
        dtl_tax_amt4_exp n 1 {Detail Tax Amount4 Exponent}
        dtl_tax_amt4_apld a 4 {Detail Tax Amount4 Type Applied}
        dtl_tax_amt4_idnfr a 2 {Detail Tax Amount4 Type Identifier}
        dtl_ca_taxid4 a 20 {Detail Card Acceptor TaxID4}
        dtl_tax_amt4_sign a 1 {Detail Tax Amount4 Sign}
        dtl_tax_amt5_ind a 1 {Detail Tax Amount5 Indicator}
        dtltaxamt5amt n 12 {DetailTaxAmount5Amount}
        dtl_tax_amt5_rt n 5 {Detail Tax Amount5 Rate}
        dtl_tax_amt5_exp n 1 {Detail Tax Amount5 Exponent}
        dtl_tax_amt5_apld a 4 {Detail Tax Amount5 Type Applied}
        dtl_tax_amt5_idnfr a 2 {Detail Tax Amount5 Type Identifier}
        dtl_ca_taxid5 a 20 {Detail Card Acceptor TaxID5}
        dtl_tax_amt5_sign a 1 {Detail Tax Amount5 Sign}
        dtl_tax_amt6_ind a 1 {Detail Tax Amount6 Indicator}
        dtl_tax_amt6_amt n 12 {Detail Tax Amount6 Amount}
        dtl_tax_amt6_rt n 5 {Detail Tax Amount6 Rate}
        dtl_tax_amt6_exp n 1 {Detail Tax Amount6 Exponent}
        dtl_tax_amt6_apld a 4 {Detail Tax Amount6 Type Applied}
        dtl_tax_amt6_idnfr a 2 {Detail Tax Amount6 Type Identifier}
        dtl_ca_taxid6 a 20 {Detail Card Acceptor TaxID6}
        dtl_tax_amt6_sign a 1 {Detail Tax Amount6 Sign}
        line_item_tot_amt n 12 {Line Item Total Amount}
        line_item_tot_exp n 1 {Line Item Total Exponent}
        line_item_tot_sign a 1 {Line Item Total Sign}
};# end set TCR(57-0-9-M2)

# Sub Batch Trailer
set TCR(57-0-0-3) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    dest_bin n 6 {Destination BIN}
    src_bin n 6 {Source BIN}
    rsrvd1 n 6 {Reserved}
    rsrvd2 n 12 {Reserved}
    rsrvd3 a 3 {Reserved}
    draft_flag a 1 {Draft Flag}
    cp_date n 4 {Central Processing Date}
    rec_fmt a 2 {Record Format Code}
    rev_flag a 1 {Reversal Flag}
    rsrvd4 n 23 {Reserved}
    tran_count n 7 {Batch Transaction Count}
    net_amount n 15 {Batch Net Amount}
    net_sign a 2 {Batch Net Amount Sign}
    tcr_count n 7 {Batch Record (TCR) Count}
    gross_amt n 15 {Batch Gross Amount}
    secondary_amt n 16 {Secondary Amount}
    rsrvd5 a 23 {Reserved}
    batch_key a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    reimburse_attr a 1 {Reimbursement Attribute}
};# end set tct(57-0-0-3)

# Batch Trailer
set TCR(91) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    bin n  6 {BIN}
    proc_jdate n  5 {Processing Date (YYDDD)}
    dest_amount n 15 {Destination Amount}
    num_money_trans n 12 {Number of Monetary Trans}
    batch_num n  6 {Batch Number}
    num_tcr n 12 {Number of TCRs}
    rsrvd1 n  6 {Reserved}
    batch_id a  8 {Center Batch ID}
    num_trans n  9 {Number of Transactions}
    rsrvd2 n 18 {Reserved}
    src_amount n 15 {Source Amount}
    rsrvd3 n 15 {Reserved}
    rsrvd4 n 15 {Reserved}
    rsrvd5 n 15 {Reserved}
    rsrvd6 a  7 {Reserved}
};# end set TCR(92)

# File Trailer
set TCR(92) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    bin n  6 {BIN}
    proc_jdate n  5 {Processing Date (YYDDD)}
    dest_amount n 15 {Destination Amount}
    num_money_trans n 12 {Number of Monetary Trans}
    batch_num n  6 {Batch Number}
    num_tcr n 12 {Number of TCRs}
    rsrvd1 n  6 {Reserved}
    batch_id a  8 {Center Batch ID}
    num_trans n  9 {Number of Transactions}
    rsrvd2 n 18 {Reserved}
    src_amount n 15 {Source Amount}
    rsrvd3 n 15 {Reserved}
    rsrvd4 n 15 {Reserved}
    rsrvd5 n 15 {Reserved}
    rsrvd6 a  7 {Reserved}
};# end set TCR(92)

############################

proc parse_tc {tc line_in} {
    global TCR

    foreach {index type length comment} $TCR($tc)  {
        set value [string range $line_in 0 [expr $length - 1]]
        puts [format "%-30.30s  >%s<" $comment $value]
        set line_in [string range $line_in $length end]
    }
    puts "\n"
};# end parse_tc


proc determine_which_57 {line_in} {
    set tc 57
    set tcq [string range $line_in 2 2]
    set tcn [string range $line_in 3 3]
    set rec_type [string range $line_in 166 166]
    if {[string range $line_in 4 4] != " " && $tcn == 5 && $rec_type == 2} {
      set rec_type "$rec_type[string range V 0 0]"
    }
    if {[string range $line_in 4 4] != " " && [string range $line_in 167 167] == "D" } {
      set rec_type [string range $line_in 4 5]
    }
    if {[string range $line_in 16 17] == "AI" && $tcn == 4 && $rec_type == 2 && [string range $line_in 16 17] != "LG"} {
      if {[string range $line_in 4 4] == " "} {
        set rec_type "$rec_type[string range V 0 0]"
      } else {
        set rec_type "$rec_type[string range M 0 0]"
      }
    }
    set tc57 "$tc-$tcq-$tcn-$rec_type"
    parse_tc $tc57 $line_in
};# end determine_which_57


proc determine_which_50 {line_in} {
    set tc 50
    set tcq [string range $line_in 2 2]
    set tcn [string range $line_in 3 3]
    set rec_type [string range $line_in 4 4]
    set tc50 "$tc-$tcq-$tcn-$rec_type"
    parse_tc $tc50 $line_in
};# end determine_which_50


proc determine_rec_type {line_in} {
    set tc_type [string range $line_in 0 1]
    switch $tc_type {
        "90" {puts "*** File Header ***"}
        "91" {puts "*** Batch Trailer ***"}
        "92" {puts "*** File Trailer ***"}
        "57" {set tcq [string range $line_in 2 2]
              set tcn [string range $line_in 3 3]
              set rec_type [string range $line_in 166 166]
              if {[string range $line_in 4 4] != " " && $tcn == 5 && $rec_type == 2} {
                set rec_type "$rec_type[string range V 0 0]"
              }
              if {[string range $line_in 16 17] == "AI" && $tcn == 4 && $rec_type == 2 && [string range $line_in 16 17] != "LG"} {
                if {[string range $line_in 4 4] == " "} {
                  set rec_type "$rec_type[string range V 0 0]"
                } else {
                  set rec_type "$rec_type[string range M 0 0]"
                }
              }
              if {[string range $line_in 16 17] == "01" && $tcn == 4 && $rec_type == 2 && [string range $line_in 16 17] != "LG"} {
                set rec_type "$rec_type[string range M 0 0]"
              }
              if {[string range $line_in 4 4] != " " && [string range $line_in 167 167] == "D" } {
                set rec_type [string range $line_in 4 5]
              }
              set tc57_type "$tc_type-$tcq-$tcn-$rec_type"
              switch $tc57_type {
                  "57-0-0-1"   {puts "*** First Batch Header ***"}
                  "57-0-1-1"   {puts "*** Second Batch Header ***"}
                  "57-0-0-2"   {puts "*** Transaction Detail ***"}
                  "57-0-2-2"   {puts "*** Transaction Detail - AMEX ***"}
                  "57-0-3-2"   {puts "*** Visa Payment Services Detail ***"}
                  "57-0-5-2"   {puts "*** Mastercard Compliance Data ***"}
                  "57-0-5-2V"  {puts "*** Visa Purchasing Card ***"}
                  "57-0-4-2V"  {puts "*** Visa Transport ***"}
                  "57-0-4-2M"  {puts "*** Mastercard Transport ***"}
                  "57-0-1-2"   {puts "*** Dynamic Descriptor ***"}
                  "57-0-1-9"   {puts "*** Dynamic Descriptor - Discover ***"}
                  "57-0-4-2"   {puts "*** Visa Lodging ***"}
                  "57-0-4-3"   {puts "*** Mastercard Lodging ***"}
                  "57-0-0-3"   {puts "*** Sub Batch Trailer ***"}
                  "57-0-2-1"   {puts "*** AMEX Batch Header ***"}
                  "57-0-1-00"  {puts "*** Discover Additional Data ***"}
                  "57-0-3-01"  {puts "*** Discover Statement ***"}
                  "57-0-3-02"  {puts "*** Discover Tip ***"}
                  "57-0-3-03"  {puts "*** Discover Cash Over ***"}
                  "57-0-3-04"  {puts "*** Discover Address ***"}
                  "57-0-3-09"  {puts "*** Discover Lodging ***"}
                  "57-0-3-92"  {puts "*** Discover Lodging 2 ***"}
                  "57-0-6-2"   {puts "*** Mastercard Purchasing Card ***"}
                  "57-0-9-M2"  {puts "*** Mastercard Purchasing Item ***"}
                  default {puts "Unknown TC57 type: $tc57_type ***"}
              }
             }
        "50" {set tcq [string range $line_in 2 2]
              set tcn [string range $line_in 3 3]
              set rec_type [string range $line_in 4 4]
              set tc50_type "$tc_type-$tcq-$tcn-$rec_type"
              switch $tc50_type {
                  "50-0-0-4"  {puts "*** TC50 - Visa Commercial Purchasing Card ***"}
                  "50-0-0-5"  {puts "*** TC50 - MasterCard Purchasing Card Line Item Detail Layout ***"}
                  default {puts "Unknown TC50 type: $tc50_type ***"}
              }
             }
        default {puts "Unknown TC type: $tc_type"}
    }
};# end determine_rec_type



########
# MAIN #
########

set filename "[lindex $argv 0]"
if {$argc != 1} {
    puts "Error invoking script"
    puts "Usage: tc57_parser.tcl filename_to_parser"
    exit 1
}

puts "Opening file <$filename>"

set input_file [open $filename r]

#while {[set line [read $input_file $LINE_SIZE]] != {} } {
while {[set line [gets $input_file]] != {} } {
    puts "line is [string length $line] long"
    set tc_type [string range $line 0 1]
#    puts "tc_type is <$tc_type>"

    determine_rec_type $line

    switch $tc_type {
        "90" -
        "91" -
        "92" {parse_tc $tc_type $line}
        "57" {determine_which_57 $line}
        "50" {determine_which_50 $line}
        default {puts "Unknown TC type: <$tc_type>"}
    }
}

close $input_file

puts "tc57_parser.tcl program complete"

exit 0


