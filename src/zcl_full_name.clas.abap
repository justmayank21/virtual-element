CLASS zcl_full_name DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FULL_NAME IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

  data: lt_fullname type STANDARD TABLE OF zc_marks_table.
        lt_fullname = CORRESPONDING #( it_original_data ).

        loop at lt_fullname ASSIGNING FIELD-SYMBOL(<fs_data>).
        data(lv_firstname) = <fs_data>-FirstName.
        data(lv_lastname) = <fs_data>-LastName.
        <fs_data>-full_name = |{ lv_firstname } { lv_lastname }|.

        data(lv_marksObt) = <fs_data>-MarksObt.
        data(lv_totalMarks) = <fs_data>-TotalMarks.


        ENDLOOP.


        ct_calculated_data = CORRESPONDING #( lt_fullname ).



  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.
ENDCLASS.
