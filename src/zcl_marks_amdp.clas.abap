CLASS zcl_marks_amdp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS: get_data FOR TABLE FUNCTION ztf_marks_15592.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS ZCL_MARKS_AMDP IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
   FOR HDB
   LANGUAGE SQLSCRIPT
   OPTIONS READ-ONLY
   USING zmarks_table.

    RETURN
    select
     client,
     roll_num,
     first_name,
     last_name,
     class,
     total_marks,
     marks_obt,
     (marks_obt / total_marks) * 100 as percentage,
     case
     when ( marks_obt / total_marks ) * 100 >= 90 then 'A+'
     when ( marks_obt / total_marks ) * 100 >= 80 then 'A'
     when ( marks_obt / total_marks ) * 100 >= 70 then 'B'
     when ( marks_obt / total_marks ) * 100 >= 60 then 'C'
     when ( marks_obt / total_marks ) * 100 >= 50 then 'D'
     else 'F'
     end as grade,
     case
     when (marks_obt/total_marks) * 100 >= 55 then 'Pass'
     else 'Fail'
     end as final_result
     from zmarks_table;
*     where client = SESSION_CONTEXT( 'client' );

  ENDMETHOD.
ENDCLASS.
