@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_MARKS_TABLE
  provider contract transactional_query
  as projection on ZR_MARKS_TABLE as record
{
  key RollNum,
  FirstName,
  LastName,
  Class,
  TotalMarks,
  MarksObt,
  LocalLastChanged,
  LastChanged,
  CreationUser,
  ChangeUser,
  @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_FULL_NAME'
  virtual full_name : abap.string(256),
  @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PERCENTAGE'
  virtual percentage :  abap.decfloat16,                                           
  @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_COMBINE'
  virtual full_name_with_percentage : abap.string(256),
  
//  _result.percentage as perc,
   _result.grade as grade,
   
  _result.final_result as FinalResult
  
  
  
  
  
  
}
