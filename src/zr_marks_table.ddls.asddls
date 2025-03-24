@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_MARKS_TABLE
  as select from zmarks_table
  
  association [0..1] to ztf_cds_marks as _result
  on $projection.RollNum = _result.roll_num
{
  key roll_num as RollNum,
  first_name as FirstName,
  last_name as LastName,
  class as Class,
  total_marks as TotalMarks,
  marks_obt as MarksObt,
//  percntg as percntg,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed as LocalLastChanged,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed as LastChanged,
  @Semantics.user.createdBy: true
  creation_user as CreationUser,
  @Semantics.user.lastChangedBy: true
  change_user as ChangeUser,

  _result  
//  _result.percentage
  
  
}
