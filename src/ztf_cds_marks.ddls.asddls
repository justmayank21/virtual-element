@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'cds for table function'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ztf_cds_marks as select from Ztf_marks_15592
{
    roll_num,
    total_marks,
    marks_obt,
    percentage,
    grade,
    final_result
}
