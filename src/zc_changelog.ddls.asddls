@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View For ChangeLog'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_CHANGELOG as select from ZI_CHANGELOG
{
    key ChangeId,
    Id,
    ChangingOperation,
    ChangedFieldName,
    ChangedFrom,
    ChangedValue,
    CreatedAt,
    ChangedBy
}
