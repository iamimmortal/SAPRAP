@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic View For Attachment'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ATTACH as select from zrelattach 
association to parent ZI_RELEASE as _RELEASE on $projection.Zrelid = _RELEASE.Id and
                                                $projection.Zdefect = _RELEASE.Defect
{
    
 key zrelattach.zrelid as Zrelid,
 key zrelattach.zdefect as Zdefect,
 key zrelattach.zid as Zid,
 zrelattach.attachment as Attachment,
 zrelattach.mimetype as Mimetype,
 zrelattach.filename as Filename,
 zrelattach.crtby as Crtby,
 zrelattach.crton as Crton,
 _RELEASE
    
}
