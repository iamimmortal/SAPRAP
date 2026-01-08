@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View For Release Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: [ 'Id','Defect' ]


define root view entity ZC_RELEASE provider contract transactional_query as projection on ZI_RELEASE
{
    key Id,
    @ObjectModel.sort.enabled: true
    key Defect,
    Description,
    @ObjectModel.text.element: [ 'ProjectText' ]
    Projecttype,
    _ProjectText.Description as ProjectText,
    @ObjectModel.text.element: [ 'RegionText' ]
    Region,
    _RegionText.Description as RegionText,
    @ObjectModel.text.element: [ 'ReleaseText' ]
    ReleaseType,
    _ReleaseText.Description as ReleaseText,
    @ObjectModel.text.element: [ 'ChangeText' ]
    ChangeType,
    _ChangeText.Description as ChangeText,
    ReleaseDate,
    FFID,
    JiraUrl,
    CreatedOn,
    @Semantics.user.createdBy: true
    CreatedBy,
    IsDeployed,
    _Attach : redirected to composition child ZC_ATTACH,
    _ProjectText,
    _RegionText,
    _ReleaseText,
    _ChangeText,
    _ChangeLog
}
