@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED Managed Person'
define root view entity ZI_PERSON_M
  as select from zperson_m as Person
{
  key person_uuid as PersonUUID,
  @EndUserText.label: 'First Name'
  first_name as FirstName,
  @EndUserText.label: 'Last Name'  
  last_name as LastName,
  @EndUserText.label: 'Email' 
  email as Email,
  @EndUserText.label: 'Birthday'
  birthday as Birthday,
  @EndUserText.label: 'Status'
  status as Status,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
  
}
