@AbapCatalog.viewEnhancementCategory: [ #NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic View For Release Items'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define root view entity ZI_RELEASE
  as select from zrelease_items
  composition [0..*] of ZI_ATTACH_V1 as _Attach
  association [1] to ZI_PROJECT_FV as _ProjectText on  $projection.Projecttype = _ProjectText.ProjType
  association [1] to ZI_REGION_FV  as _RegionText  on  $projection.Region = _RegionText.Staging
  association [1] to ZI_RELTYP_FV  as _ReleaseText on  $projection.ReleaseType = _ReleaseText.RelType
  association [1] to ZI_CHANGE_FV  as _ChangeText  on  $projection.ChangeType = _ChangeText.ChangeTyp
  association [0..*] to  ZC_CHANGELOG as _ChangeLog on $projection.Id = _ChangeLog.Id
{
  key id          as Id,
  key defect      as Defect,
      description as Description,
      @ObjectModel.text.association: '_ProjectText'
      projecttype as Projecttype,
      @ObjectModel.text.association: '_RegionText'
      region      as Region,
      @ObjectModel.text.association: '_ReleaseText'
      releasetype as ReleaseType,
      @ObjectModel.text.association: '_ChangeText'
      changetype  as ChangeType,
      releasedate as ReleaseDate,
      ffidused    as FFID,
      jiraurl     as JiraUrl,
      createdon   as CreatedOn,
      createdby   as CreatedBy,
      isdeployed  as IsDeployed,
      _Attach,
      _ProjectText,
      _RegionText,
      _ReleaseText,
      _ChangeText,
      _ChangeLog
}
