*&---------------------------------------------------------------------*
*& Report  Z_CUSTOM_ALV_SALES_REPORT
*& Custom ALV Sales Order Status Report
*&---------------------------------------------------------------------*

REPORT z_custom_alv_sales_report LINE-SIZE 250 NO STANDARD PAGE HEADING.

*----------------------------------------------------------------------*
* TYPE DECLARATION
*----------------------------------------------------------------------*
TYPES: BEGIN OF ty_report,
         vbeln  TYPE vbak-vbeln,
         erdat  TYPE vbak-erdat,
         auart  TYPE vbak-auart,
         vkorg  TYPE vbak-vkorg,
         kunnr  TYPE vbak-kunnr,
         name1  TYPE kna1-name1,
         posnr  TYPE vbap-posnr,
         matnr  TYPE vbap-matnr,
         arktx  TYPE vbap-arktx,
         kwmeng TYPE vbap-kwmeng,
         netwr  TYPE vbap-netwr,
         waerk  TYPE vbak-waerk,
         color  TYPE c LENGTH 4,
       END OF ty_report.

*----------------------------------------------------------------------*
* DATA DECLARATION
*----------------------------------------------------------------------*
DATA: it_report TYPE STANDARD TABLE OF ty_report,
      wa_report TYPE ty_report,
      it_fcat   TYPE slis_t_fieldcat_alv,
      wa_fcat   TYPE slis_fieldcat_alv,
      gs_layout TYPE slis_layout_alv.

*----------------------------------------------------------------------*
* SELECTION SCREEN
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: so_date  FOR vbak-erdat OBLIGATORY,
                  so_kunnr FOR vbak-kunnr,
                  so_auart FOR vbak-auart.
  PARAMETERS:     p_vkorg  TYPE vbak-vkorg DEFAULT '1000'.
SELECTION-SCREEN END OF BLOCK b1.

*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM fetch_data.
  PERFORM apply_color.
  PERFORM build_fieldcat.
  PERFORM display_alv.

*----------------------------------------------------------------------*
* FETCH DATA
*----------------------------------------------------------------------*
FORM fetch_data.

  CLEAR it_report.
  REFRESH it_report.

  SELECT a~vbeln a~erdat a~auart a~vkorg a~kunnr a~waerk
         b~posnr b~matnr b~arktx b~kwmeng b~netwr
         c~name1
    INTO CORRESPONDING FIELDS OF TABLE it_report
    FROM vbak AS a
    INNER JOIN vbap AS b ON b~vbeln = a~vbeln
    INNER JOIN kna1 AS c ON c~kunnr = a~kunnr
   WHERE a~erdat IN so_date
     AND a~vkorg = p_vkorg
     AND a~kunnr IN so_kunnr
     AND a~auart IN so_auart
     UP TO 1000 ROWS.

ENDFORM.

*----------------------------------------------------------------------*
* APPLY COLOR LOGIC
*----------------------------------------------------------------------*
FORM apply_color.

  LOOP AT it_report INTO wa_report.

    DATA(lv_days) = sy-datum - wa_report-erdat.

    IF lv_days > 30.
      wa_report-color = 'C610'.   " Red
    ELSEIF lv_days BETWEEN 15 AND 30.
      wa_report-color = 'C510'.   " Yellow
    ELSE.
      wa_report-color = 'C310'.   " Green
    ENDIF.

    MODIFY it_report FROM wa_report.

  ENDLOOP.

ENDFORM.

*----------------------------------------------------------------------*
* BUILD FIELD CATALOG
*----------------------------------------------------------------------*
FORM build_fieldcat.

  CLEAR it_fcat.

  DEFINE add_field.
    wa_fcat-fieldname = &1.
    wa_fcat-seltext_m = &2.
    wa_fcat-key       = &3.
    wa_fcat-do_sum    = &4.
    wa_fcat-hotspot   = &5.
    APPEND wa_fcat TO it_fcat.
    CLEAR wa_fcat.
  END-OF-DEFINITION.

  add_field 'VBELN'  'Sales Order' 'X' ''  'X'.
  add_field 'ERDAT'  'Created On'  ''  ''  ''.
  add_field 'AUART'  'Order Type'  ''  ''  ''.
  add_field 'VKORG'  'Sales Org'   ''  ''  ''.
  add_field 'KUNNR'  'Customer'    ''  ''  ''.
  add_field 'NAME1'  'Customer Name' '' '' ''.
  add_field 'POSNR'  'Item'        ''  ''  ''.
  add_field 'MATNR'  'Material'    ''  ''  ''.
  add_field 'ARKTX'  'Description' ''  ''  ''.
  add_field 'KWMENG' 'Quantity'    ''  'X' ''.
  add_field 'NETWR'  'Net Value'   ''  'X' ''.
  add_field 'WAERK'  'Currency'    ''  ''  ''.

ENDFORM.

*----------------------------------------------------------------------*
* DISPLAY ALV
*----------------------------------------------------------------------*
FORM display_alv.

  gs_layout-zebra      = 'X'.
  gs_layout-colwidth_optimize = 'X'.
  gs_layout-info_fieldname = 'COLOR'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = gs_layout
      i_callback_user_command = 'USER_COMMAND'
    TABLES
      t_outtab           = it_report
      t_fieldcat         = it_fcat.

ENDFORM.

*----------------------------------------------------------------------*
* USER COMMAND (DOUBLE CLICK)
*----------------------------------------------------------------------*
FORM user_command USING r_ucomm LIKE sy-ucomm
                        rs_selfield TYPE slis_selfield.

  IF r_ucomm = '&IC1'.   " Double click

    READ TABLE it_report INTO wa_report INDEX rs_selfield-tabindex.

    IF sy-subrc = 0.
      SET PARAMETER ID 'AUN' FIELD wa_report-vbeln.
      CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN.
    ENDIF.

  ENDIF.

ENDFORM.