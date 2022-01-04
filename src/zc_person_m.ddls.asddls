@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZI_PERSON_M'
define root view entity ZC_PERSON_M
  as projection on ZI_PERSON_M
{
  key PersonUUID,
  FirstName,
  LastName,
  Email,
  Birthday,
  Status,
  LocalLastChangedAt
  
}
