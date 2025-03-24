@EndUserText.label: 'custom entity for change document'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_CHANGE_DOC_15592'
@Search.searchable: true
define custom entity zchng_docu_15592
{
  @EndUserText.label: 'objectclass'
  @UI.facet: [ {
    label: 'General Information',
    id: 'GeneralInfo',
    purpose: #STANDARD,
    position: 10 ,
    type: #IDENTIFICATION_REFERENCE
  } ]
  @UI.identification: [ {
    position: 10 ,
    label: 'objectclass'
  } ]
  @UI.lineItem: [ {
    position: 10 ,
    label: 'objectclass'
  } ]
  @UI.selectionField: [ {
    position: 10
  } ]
  
  key objectclass   : abap.char(15);
  
  @EndUserText.label: 'objectid'
  @UI.identification: [ {
    position: 20 ,
    label: 'objectid'
  } ]
  @UI.lineItem: [ {
    position: 20 ,
    label: 'objectid'
  } ]
  @UI.selectionField: [ {
    position: 20
  } ]
  @Search.defaultSearchElement: true
  
  key objectid     : abap.char(90);
  
   @EndUserText.label: 'Chnage Number'
  @UI.identification: [ {
    position: 30 ,
    label: 'Chnage Number'
  } ]
  @UI.lineItem: [ {
    position: 30 ,
    label: 'Change Number'
  } ]
  @UI.selectionField: [ {
    position: 30
  } ]
      changenr     : abap.char(10);
      objecttxt    : abap.char(350);
      
       @EndUserText.label: 'User ID'
  @UI.identification: [ {
    position: 40 ,
    label: 'User ID'
  } ]
  @UI.lineItem: [ {
    position: 40 ,
    label: 'User ID'
  } ]
  @UI.selectionField: [ {
    position: 40
  } ]
      username     : abap.char(80);//suidtechdesc;
      
      username_db  : abap.char(12);//cdusername;
//      udate        : abap.dats;//cddatum;
//      udate_db     : abap.dats;//cddatum;
//      utime        : abap.tims;//cduzeit;
//      utime_db     : abap.tims;//cduzeit;
//      tcode        : abap.cahr(20);//cdtcode;
//      applname     : cdapplobj;
//      appltype     : cdappltype;
//      tabname      : cdtabname;
//      tabname_db   : cdtabname;
      tabkey       : abap.char(70);//cdtabkey  ;
      tabkey_db    : abap.char(70);//cdtabkey;
      keylen       : abap.numc( 4 );//cdintlen;
      
       @EndUserText.label: 'Change indicator'
  @UI.identification: [ {
    position: 50 ,
    label: 'Change indicator'
  } ]
  @UI.lineItem: [ {
    position: 50 ,
    label: 'Change indicator'
  } ]
  @UI.selectionField: [ {
    position: 50
  } ]
      chngind      : abap.char(1);//cdchngind;
      fname        : abap.char(30);//fieldname;
      fname_db     : abap.char(30);//fieldname;
      ftext        : abap.char(60);//ddtext;
      textart      : abap.char(4);//cdtextart;
      sprache      : spras;
      text_case    : abap.char(1);//cdtextind;
//      outlen       : cdoutlen;
@EndUserText.label: 'old value'
  @UI.identification: [ {
    position: 60 ,
    label: 'old value'
  } ]
  @UI.lineItem: [ {
    position: 60 ,
    label: 'old value'
  } ]
  @UI.selectionField: [ {
    position: 60
  } ]
      f_old        : abap.char(254);//cdfldvalo;
      f_old_db     : abap.char(254);//cdfldvalo;
      
       @EndUserText.label: 'New Value'
  @UI.identification: [ {
    position: 70 ,
    label: 'New Value'
  } ]
  @UI.lineItem: [ {
    position: 70 ,
    label: 'New Value'
  } ]
  @UI.selectionField: [ {
    position: 70
  } ]
      f_new        : abap.char(254);//cdfldvaln;
      f_new_db     : abap.char(254);//cdfldvaln;

  
}
