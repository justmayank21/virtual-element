CLASS zcl_change_doc_15592 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CHANGE_DOC_15592 IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA: lt_response TYPE TABLE OF zchng_docu_15592,
          ls_response TYPE zchng_docu_15592.

    DATA: rt_cdredadd TYPE cl_chdo_read_tools=>tt_cdredadd_tab,
          lr_err      TYPE REF TO cx_chdo_read_error.

    DATA: lt_objectid TYPE TABLE OF cl_chdo_read_tools=>ty_r_objectid_line,
          ls_objectid TYPE cl_chdo_read_tools=>ty_r_objectid_line.

    DATA : lv_objclass TYPE if_chdo_object_tools_rel=>ty_cdobjectcl,
           lv_objectid TYPE STANDARD TABLE OF cl_chdo_read_tools=>ty_r_objectid_line.

*           DATA : lv_objclass TYPE REF TO zcl_zchan_doc_15592_chdo.

    DATA: ls_docno TYPE if_rap_query_filter=>ty_range_option,
          lr_docno TYPE if_rap_query_filter=>tt_range_option,
          ls_supno TYPE if_rap_query_filter=>ty_range_option,
          lr_supno TYPE if_rap_query_filter=>tt_range_option.
    TRY.

*        DATA(lv_data_req) = io_request->is_data_requested(  ).
        io_request->is_data_requested(  ).
        DATA(lv_top) = io_request->get_paging(  )->get_page_size(  ).
        DATA(lv_skip) = io_request->get_paging(  )->get_offset(  ).
        DATA(lt_fields) = io_request->get_requested_elements(  ).
        DATA(lt_sort) = io_request->get_sort_elements(  ).
        DATA(lv_page_size) = io_request->get_paging(  )->get_page_size( ).
        DATA(lv_max_row) = COND #( WHEN lv_page_size = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_page_size ).
        DATA(lv_condition) = io_request->get_filter(  )->get_as_ranges( iv_drop_null_comparisons = abap_true ).
        DATA(lv_filter_cond) = io_request->get_parameters(  ).

        lv_max_row = lv_skip + lv_top.
        IF lv_skip > 0.
          lv_skip = lv_skip + 1.
        ENDIF.

        SORT lv_condition BY name ASCENDING.

        READ TABLE lv_condition WITH KEY name = 'OBJECTCLASS' INTO DATA(ls_objcls_key) BINARY SEARCH.
        IF sy-subrc = 0.
          LOOP AT ls_objcls_key-range INTO DATA(ls_objcls_option).
            IF ls_objcls_option-low IS NOT INITIAL.
              CLEAR lv_objclass.
              lv_objclass = ls_objcls_option-low.
            ENDIF.
          ENDLOOP.
        ENDIF.


***FETCHING THE OBJECTID FROM FILTER
        READ TABLE lv_condition WITH KEY name = 'OBJECTID' INTO DATA(ls_objectid_key) BINARY SEARCH.
        IF sy-subrc = 0.
          LOOP AT ls_objectid_key-range INTO DATA(ls_objectid_option).
            IF ls_objectid_option-low IS NOT INITIAL.
              CLEAR ls_objectid.
              ls_objectid-sign = ls_objectid_option-sign.
              ls_objectid-option = ls_objectid_option-option.
              ls_objectid-low = ls_objectid_option-low.
              ls_objectid-high = ls_objectid_option-high.
              APPEND ls_objectid TO lt_objectid.
              CLEAR ls_objectid.
            ENDIF.

          ENDLOOP.
        ENDIF.


*        READ TABLE lv_condition WITH KEY name = 'OBJECTCLASS' INTO DATA(ls_key) BINARY SEARCH.
*        IF sy-subrc IS INITIAL AND lines( ls_key-range ) = 1.
*          DATA(lt_range_value) = ls_key-range.
*          LOOP AT lt_range_value INTO DATA(ls_range_value).
*
*            ls_docno-sign = ls_range_value-sign.
*            ls_docno-option = ls_range_value-option.
*            ls_docno-low = ls_range_value-low.
*            ls_docno-high = ls_range_value-high.
*
*            APPEND ls_docno TO lr_docno.
*          ENDLOOP.
*        ENDIF.
*
*        READ TABLE lv_condition WITH KEY name = 'OBJECTID' INTO DATA(ls_data) BINARY SEARCH.
*        IF sy-subrc IS INITIAL AND lines( ls_data-range ) = 1.
*          DATA(lt_range) = ls_data-range.
*
*          LOOP AT lt_range INTO DATA(ls_range).
*
*            ls_supno-sign = ls_range-sign.
*            ls_supno-option = ls_range-option.
*            ls_supno-low = ls_range-low.
*            ls_supno-high = ls_range-high.
*
*            APPEND ls_supno TO lr_supno.
*          ENDLOOP.
*        ENDIF.

        TRY.
            cl_chdo_read_tools=>changedocument_read(
            EXPORTING
            i_objectclass = lv_objclass
            it_objectid = lt_objectid

            IMPORTING
            et_cdredadd_tab = rt_cdredadd

            ).

          CATCH cx_chdo_read_error INTO lr_err.
        ENDTRY.

*        TRY.
*            cl_chdo_read_tools=>changedocument_read(
*                 EXPORTING
*                  i_objectclass    = lv_objclass             "lv_objclass  " change document object name
*                  it_objectid      = lt_objectid
*                 IMPORTING
*                   et_cdredadd_tab  = rt_cdredadd    " result returned in table
*               ).
*          CATCH cx_chdo_read_error INTO lr_err.
*        ENDTRY.

        DELETE ADJACENT DUPLICATES FROM rt_cdredadd COMPARING changenr.

        LOOP AT rt_cdredadd ASSIGNING FIELD-SYMBOL(<fs_output>)
        FROM lv_skip TO lv_max_row.
          MOVE-CORRESPONDING <fs_output> TO ls_response.
          APPEND ls_response TO lt_response.
          CLEAR ls_response.
        ENDLOOP.

        lt_response = CORRESPONDING #( rt_cdredadd ).

        TRY.
            io_response->set_total_number_of_records( lines( lt_response ) ).
            io_response->set_data( lt_response ).
          CATCH cx_rap_query_provider INTO DATA(lx_new_root).
            DATA(lv_text2) = lx_new_root->get_text( ).
        ENDTRY.

      CATCH cx_root INTO DATA(cx_dest).
        DATA(lv_text) =  cx_dest->get_text(  ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
