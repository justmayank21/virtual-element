class ZCL_ZCHAN_DOC_15592_CHDO definition
  public
  create public .

public section.

  interfaces IF_CHDO_ENHANCEMENTS .

  class-data OBJECTCLASS type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDOBJECTCL read-only value 'ZCHAN_DOC_15592' ##NO_TEXT.

  class-methods WRITE
    importing
      !OBJECTID type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDOBJECTV
      !UTIME type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDUZEIT
      !UDATE type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDDATUM
      !USERNAME type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDUSERNAME
      !PLANNED_CHANGE_NUMBER type IF_CHDO_OBJECT_TOOLS_REL=>TY_PLANCHNGNR default SPACE
      !OBJECT_CHANGE_INDICATOR type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDCHNGINDH default 'U'
      !PLANNED_OR_REAL_CHANGES type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDFLAG default SPACE
      !NO_CHANGE_POINTERS type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDFLAG default SPACE
      !O_ZMARKS_TABLE type ZMARKS_TABLE optional
      !N_ZMARKS_TABLE type ZMARKS_TABLE optional
      !UPD_ZMARKS_TABLE type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDCHNGINDH default SPACE
      !icdtxt_zchan_doc_15592 type IF_CHDO_OBJECT_TOOLS_REL=>ty_cdtxt_tab OPTIONAL
      !UPD_ICDTXT_zchan_doc_15592 type IF_CHDO_OBJECT_TOOLS_REL=>ty_cdchngind OPTIONAL
    exporting
      value(CHANGENUMBER) type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDCHANGENR
    raising
      CX_CHDO_WRITE_ERROR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZCHAN_DOC_15592_CHDO IMPLEMENTATION.


  method WRITE.
*"----------------------------------------------------------------------
*"         this WRITE method is generated for object ZCHAN_DOC_15592
*"         never change it manually, please!        :02/02/2025
*"         All changes will be overwritten without a warning!
*"
*"         CX_CHDO_WRITE_ERROR is used for error handling
*"----------------------------------------------------------------------

    DATA: l_upd        TYPE if_chdo_object_tools_rel=>ty_cdchngind.

    CALL METHOD cl_chdo_write_tools=>changedocument_open
      EXPORTING
        objectclass             = objectclass
        objectid                = objectid
        planned_change_number   = planned_change_number
        planned_or_real_changes = planned_or_real_changes.

     IF ( N_ZMARKS_TABLE IS INITIAL ) AND
        ( O_ZMARKS_TABLE IS INITIAL ).
       l_upd  = space.
     ELSE.
       l_upd = UPD_ZMARKS_TABLE.
     ENDIF.

     IF  l_upd  NE space.
       CALL METHOD CL_CHDO_WRITE_TOOLS=>changedocument_single_case
         EXPORTING
           tablename              = 'ZMARKS_TABLE'
           workarea_old           = O_ZMARKS_TABLE
           workarea_new           = N_ZMARKS_TABLE
           change_indicator       = UPD_ZMARKS_TABLE
           docu_delete            = ''
           docu_insert            = ''
           docu_delete_if         = ''
           docu_insert_if         = ''
                  .
     ENDIF.

    CALL METHOD cl_chdo_write_tools=>changedocument_close
      EXPORTING
        objectclass             = objectclass
        objectid                = objectid
        date_of_change          = udate
        time_of_change          = utime
        username                = username
        object_change_indicator = object_change_indicator
        no_change_pointers      = no_change_pointers
      IMPORTING
        changenumber            = changenumber.

  endmethod.
ENDCLASS.
