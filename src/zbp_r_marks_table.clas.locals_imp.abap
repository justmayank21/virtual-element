CLASS lsc_zr_marks_table DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.
  PRIVATE SECTION.


ENDCLASS.

CLASS lsc_zr_marks_table IMPLEMENTATION.

  METHOD save_modified.


    DATA: ls_old_data TYPE zmarks_table,
          ls_new_data TYPE zmarks_table,
          lt_new_data TYPE STANDARD TABLE OF zmarks_table,
          lt_old_data TYPE STANDARD TABLE OF zmarks_table.

    DATA  upd_txt_doc TYPE if_chdo_object_tools_rel=>ty_cdchngind.
    DATA  upd_doc TYPE if_chdo_object_tools_rel=>ty_cdchngind.
    DATA  changenumber TYPE if_chdo_object_tools_rel=>ty_cdchangenr.

    DATA: lt_txt_doc TYPE if_chdo_object_tools_rel=>ty_cdtxt_tab,
          ls_txt_doc LIKE LINE OF lt_txt_doc.

    DATA: objectid        TYPE if_chdo_object_tools_rel=>ty_cdobjectv,
          username        TYPE if_chdo_object_tools_rel=>ty_cdusername,
          utime           TYPE if_chdo_object_tools_rel=>ty_cduzeit,
          udate           TYPE if_chdo_object_tools_rel=>ty_cddatum,
          cdoc_upd_object TYPE if_chdo_object_tools_rel=>ty_cdchngindh VALUE 'I'.


    TRY.
        username = cl_abap_context_info=>get_user_technical_name(  ).
        utime = cl_abap_context_info=>get_system_time(  ).
        udate = cl_abap_context_info=>get_system_date(  ).
      CATCH cx_abap_context_info_error.
    ENDTRY.


    IF create-zrmarkstable IS NOT INITIAL.

      lt_new_data = CORRESPONDING #( create-zrmarkstable MAPPING FROM ENTITY ).
      READ TABLE lt_new_data ASSIGNING FIELD-SYMBOL(<fs_create>) INDEX 1.

      objectid = <fs_create>-roll_num.
      <fs_create>-client = sy-mandt.
      CONDENSE objectid.

      upd_doc = 'I'.
      upd_txt_doc = 'I'.

      ls_txt_doc-teilobjid = objectid.
      ls_txt_doc-textart = 'CHAR'.
      ls_txt_doc-textspr = 'E'.
      ls_txt_doc-updkz = 'I'.

      APPEND ls_txt_doc TO lt_txt_doc.
      CLEAR ls_txt_doc.


      TRY.

          zcl_zchan_doc_15592_chdo=>write(
          EXPORTING
          objectid = objectid
          utime = utime
          udate = udate
          username = username
          object_change_indicator = cdoc_upd_object
          planned_or_real_changes = 'R'
          icdtxt_zchan_doc_15592 = lt_txt_doc
          UPD_ICDTXT_zchan_doc_15592 = upd_txt_doc
          o_zmarks_table = ls_old_data
          n_zmarks_table = <fs_create>
          upd_zmarks_table = upd_doc
          IMPORTING
          changenumber = changenumber
          ).

        CATCH cx_chdo_write_error INTO DATA(lx_root).

          DATA(lv_text) = |Exception occured: { lx_root->get_text(  ) }|.
      ENDTRY.

    ENDIF.

    DATA: lt_new TYPE STANDARD TABLE OF zmarks_table.
    FIELD-SYMBOLS: <itab> TYPE any.
    DATA dref_emp TYPE REF TO data.

    DATA: lcl_table TYPE REF TO cl_abap_tabledescr,
          lcl_struc TYPE REF TO cl_abap_structdescr,
          it_fields TYPE abap_compdescr_tab,
          wa_fields TYPE abap_compdescr.

    IF update-zrmarkstable IS NOT INITIAL.

      lt_new = CORRESPONDING #( update-zrmarkstable MAPPING FROM ENTITY ).
      READ TABLE lt_new ASSIGNING FIELD-SYMBOL(<fs_update>) INDEX 1.

      IF sy-subrc = 0.
        DATA(lv_rollnum) = <fs_update>-roll_num.
      ELSE.
        " Handle the case where lt_new is empty or no entry is found
        RETURN.
      ENDIF.

      ASSIGN dref_emp->* TO <itab>.

      lcl_table ?= cl_abap_typedescr=>describe_by_data( <itab> ).

      lcl_struc ?= lcl_table->get_table_line_type( ).

      it_fields = lcl_struc->components.

      DATA: lv_fieldname TYPE string.
      DATA st_var TYPE string.
      LOOP AT update-zrmarkstable ASSIGNING FIELD-SYMBOL(<fs_marks>).

        LOOP AT it_fields INTO DATA(ls_compnents).

          lv_fieldname = ls_compnents-name.

          ASSIGN COMPONENT lv_fieldname OF STRUCTURE <fs_marks>-%control TO FIELD-SYMBOL(<lv_control_value>).
          IF ls_compnents-name EQ 'CLIENT'.
            CONTINUE.
          ENDIF.
          IF <lv_control_value> = '01'.

            IF st_var IS NOT INITIAL.

              st_var = |{ st_var }, { ls_compnents-name }|.
            ENDIF.

          ELSE.
            CONTINUE.

          ENDIF.
        ENDLOOP.

      ENDLOOP.
      SELECT (st_var) FROM @lt_new AS lt_new WHERE roll_num = @lv_rollnum INTO TABLE @lt_new_data.

      SELECT (st_var) FROM zmarks_table WHERE roll_num = @lv_rollnum INTO TABLE @lt_old_data.

      ls_old_data = lt_old_data[ 1 ].
      ls_new_data = lt_new_data[ 1 ].

      objectid = <fs_update>-roll_num.
      CONDENSE Objectid.

      upd_doc = 'U'.
      upd_txt_doc = 'U'.

      ls_txt_doc-teilobjid = objectid.
      ls_txt_doc-textart = 'CHAR'.
      ls_txt_doc-textspr = 'E'.
      ls_txt_doc-updkz = 'U'.

      APPEND ls_txt_doc TO lt_txt_doc.
      CLEAR:ls_txt_doc.

      TRY.

          zcl_zchan_doc_15592_chdo=>write(
          EXPORTING
                    objectid                = objectid
                    utime                   = utime
                    udate                   = udate
                    username                = username
                    object_change_indicator = cdoc_upd_object
                    planned_or_real_changes = 'R'
*                    icdtxt_      = lt_txt_doc
*                    upd_icdtxt_Z_CHANGE_DOC  = upd_txt_doc
                    o_zmarks_table          = ls_old_data
                    n_zmarks_table          = ls_new_data
                    upd_zmarks_table        = upd_doc
                  IMPORTING
                    changenumber            = changenumber
           ).
        CATCH cx_chdo_write_error.
      ENDTRY.



    ENDIF.




*    DATA marks_log        TYPE STANDARD TABLE OF zmarks_table. "travel_log
*    DATA marks_log_create TYPE STANDARD TABLE OF zmarks_table. "travel_log_create
*    DATA marks_log_update TYPE STANDARD TABLE OF zmarks_table. "travel_log_update
*
*    " (1) Get instance data of all instances that have been created
*    IF create-zrmarkstable IS NOT INITIAL. "create-travel
*      " Creates internal table with instance data
*      marks_log = CORRESPONDING #( create-zrmarkstable ).
*
*      LOOP AT marks_log ASSIGNING FIELD-SYMBOL(<marks_log>).
*        <marks_log>-changing_operation = 'CREATE'. "I have to add one field
*
*        " Generate time stamp
*        GET TIME STAMP FIELD <marks_log>-created_at.
*
*        " Read travel instance data into ls_travel that includes %control structure
*        READ TABLE create-zrmarkstable WITH TABLE KEY entity COMPONENTS RollNum = <marks_log>-roll_num INTO DATA(marks).
*        IF sy-subrc = 0.
*
*          " If new value of the booking_fee field created
*          IF marks-%control-FirstName = cl_abap_behv=>flag_changed.
*            " Generate uuid as value of the change_id field
*            TRY.
*                <marks_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .  "create change_id
*              CATCH cx_uuid_error.
*                "handle exception
*            ENDTRY.
*            <marks_log>-changed_field_name = 'first_name'. "create changed fields
*            <marks_log>-changed_value = marks-FirstName. "create change value
*            APPEND <marks_log> TO marks_log_create.
*          ENDIF.
*
*          " If new value of the overall_status field created
*          IF marks-%control-LastName = cl_abap_behv=>flag_changed.
*            " Generate uuid as value of the change_id field
*            TRY.
*                <marks_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
*              CATCH cx_uuid_error.
*                "handle exception
*            ENDTRY.
*            <marks_log>-changed_field_name = 'last_name'.
*            <marks_log>-changed_value = marks-LastName.
*            APPEND <marks_log> TO marks_log_create.
*          ENDIF.
*
*          " IF  ls_travel-%control-...
*
*        ENDIF.
*
*      ENDLOOP.
*
*      " Inserts rows specified in lt_travel_log_c into the DB table /dmo/log_travel
*      INSERT zmarks_table FROM TABLE @marks_log_create.
*
*    ENDIF.
*
*
*    " (2) Get instance data of all instances that have been updated during the transaction
*    IF update-zrmarkstable IS NOT INITIAL.
*      marks_log = CORRESPONDING #( update-zrmarkstable ).
*
*      LOOP AT update-zrmarkstable ASSIGNING FIELD-SYMBOL(<marks_log_update>).
*
*        ASSIGN marks_log[ Roll_Num = <marks_log_update>-RollNum ] TO FIELD-SYMBOL(<marks_log_db>).
*
*        <marks_log_db>-changing_operation = 'UPDATE'.
*
*        " Generate time stamp
*        GET TIME STAMP FIELD <marks_log_db>-created_at.
*
*
*        IF <marks_log_update>-%control-FirstName = if_abap_behv=>mk-on.
*          <marks_log_db>-changed_value = <marks_log_update>-FirstName.
*          " Generate uuid as value of the change_id field
*          TRY.
*              <marks_log_db>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
*            CATCH cx_uuid_error.
*              "handle exception
*          ENDTRY.
*
*          <marks_log_db>-changed_field_name = 'first_name'.
*
*          APPEND <marks_log_db> TO marks_log_update.
*
*        ENDIF.
*
*        IF <marks_log_update>-%control-LastName = if_abap_behv=>mk-on.
*          <marks_log_db>-changed_value = <marks_log_update>-LastName.
*
*          " Generate uuid as value of the change_id field
*          TRY.
*              <marks_log_db>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
*            CATCH cx_uuid_error.
*              "handle exception
*          ENDTRY.
*
*          <marks_log_db>-changed_field_name = 'last_name'.
*
*          APPEND <marks_log_db> TO marks_log_update.
*
*        ENDIF.
*
*        "IF <fs_travel_log_u>-%control-...
*
*      ENDLOOP.
*
*
*      " Inserts rows specified in lt_travel_log_u into the DB table /dmo/log_travel
*      INSERT zmarks_table FROM TABLE @marks_log_update.
*
*    ENDIF.
*
*    " (3) Get keys of all travel instances that have been deleted during the transaction
*    IF delete-zrmarkstable IS NOT INITIAL.
*      marks_log = CORRESPONDING #( delete-zrmarkstable ).
*      LOOP AT marks_log ASSIGNING FIELD-SYMBOL(<marks_log_delete>).
*        <marks_log_delete>-changing_operation = 'DELETE'.
*        " Generate time stamp
*        GET TIME STAMP FIELD <marks_log_delete>-created_at.
*        " Generate uuid as value of the change_id field
*        TRY.
*            <marks_log_delete>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
*          CATCH cx_uuid_error.
*            "handle exception
*        ENDTRY.
*
*      ENDLOOP.
*
*      " Inserts rows specified in lt_travel_log into the DB table /dmo/log_travel
*      INSERT zmarks_table FROM TABLE @marks_log.
*
*    ENDIF.


  ENDMETHOD.

ENDCLASS.

CLASS lhc_zr_marks_table DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR ZrMarksTable
        RESULT result.
ENDCLASS.

CLASS lhc_zr_marks_table IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
ENDCLASS.
