@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View For Attachment'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_ATTACH  as projection on ZI_ATTACH
{
key Zrelid,
key Zdefect,
key Zid,
@Semantics.largeObject:{
fileName: 'Filename',
mimeType: 'Mimetype',
contentDispositionPreference: #INLINE
}
Attachment,
@Semantics.mimeType: true
Mimetype,
Filename,
@Semantics.user.createdBy: true
Crtby,
Crton,
/* Associations */
_RELEASE : redirected to parent ZC_RELEASE
}
