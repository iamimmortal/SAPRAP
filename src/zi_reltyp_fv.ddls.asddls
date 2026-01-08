@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Release Type Fix value'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_RELTYP_FV 
  as select from    DDCDS_CUSTOMER_DOMAIN_VALUE(
                      p_domain_name : 'ZRELTYP') as Values
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T(
                      p_domain_name : 'ZRELTYP') as Texts on  Texts.domain_name    = Values.domain_name
                                                          and Texts.value_position = Values.value_position
                                                          and Texts.language       = $session.system_language
{
      @EndUserText.label: 'Release Type'
  key Values.value_low as RelType,
      @Semantics.text: true
      @EndUserText.label: 'Description'
      Texts.text       as Description
}
