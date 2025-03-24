CLASS zcl_combine DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_COMBINE IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_data TYPE STANDARD TABLE OF zc_marks_table WITH DEFAULT KEY.
    lt_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      DATA(lv_firstname) = <fs_data>-FirstName.
      DATA(lv_lastname) = <fs_data>-LastName.
      DATA(lv_marksobt) = <fs_data>-MarksObt.
      DATA(lv_totalmarks) = <fs_data>-TotalMarks.


      <fs_data>-full_name = |{ lv_firstname } { lv_lastname }|.


      IF lv_totalmarks > 0.
        <fs_data>-percentage = ( lv_marksobt / lv_totalmarks ) * 100.
      ELSE.
        <fs_data>-percentage = 0.
      ENDIF.


      <fs_data>-full_name_with_percentage = |{ <fs_data>-full_name } - { <fs_data>-percentage }%|.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_data ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.
ENDCLASS.
