CLASS zcl_percentage DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PERCENTAGE IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_per TYPE STANDARD TABLE OF zc_marks_table WITH DEFAULT KEY.
    lt_per = CORRESPONDING #( it_original_data ).

    LOOP AT lt_per ASSIGNING FIELD-SYMBOL(<fs_data>).

      DATA(lv_marksObt) = <fs_data>-MarksObt.
      DATA(lv_totalMarks) = <fs_data>-TotalMarks.

      IF lv_totalMarks > 0.
        <fs_data>-percentage = ( lv_marksObt / lv_totalMarks ) * 100.
      ELSE.
        <fs_data>-percentage = 0.
      ENDIF.


    ENDLOOP.


    ct_calculated_data = CORRESPONDING #( lt_per ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.
