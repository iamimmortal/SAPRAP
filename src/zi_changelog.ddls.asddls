@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic View For Change Log'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CHANGELOG as select from zrel_changelog
{
    key change_id as ChangeId,
    id as Id,
    changing_operation as ChangingOperation,
    changed_field_name as ChangedFieldName,
    changed_from as ChangedFrom,
    changed_value as ChangedValue,
    created_at as CreatedAt,
    changed_by as ChangedBy
}
