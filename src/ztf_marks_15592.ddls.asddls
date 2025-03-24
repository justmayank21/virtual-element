@EndUserText.label: 'table function for marks'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ClientHandling.type: #CLIENT_DEPENDENT
define table function Ztf_marks_15592
returns
{
  client       : abap.clnt;
  roll_num     : sysuuid_x16;
  first_name   : abap.string(256);
  last_name    : abap.char(50);
  class        : abap.char(2);
  total_marks  : abap.int4;
  marks_obt    : abap.int4;
  percentage   : abap.dec( 10, 3 );
  grade        : abap.string( 256 );
  final_result : abap.char( 10 );

}
implemented by method
  zcl_marks_amdp=>get_data;