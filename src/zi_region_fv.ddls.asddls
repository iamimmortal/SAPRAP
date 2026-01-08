@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Region Fix value'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }
@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZI_REGION_FV
  as select from    DDCDS_CUSTOMER_DOMAIN_VALUE(
                      p_domain_name : 'ZREGION') as Values
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T(
                      p_domain_name : 'ZREGION') as Texts on  Texts.domain_name    = Values.domain_name
                                                          and Texts.value_position = Values.value_position
                                                          and Texts.language       = $session.system_language
{
      @EndUserText.label: 'Region'
  key Values.value_low as Staging,
      @Semantics.text: true
      @EndUserText.label: 'Description'
      Texts.text       as Description
}
