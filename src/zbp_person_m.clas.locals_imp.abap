CLASS lcl_handler DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Person
        RESULT result,
      set_email FOR DETERMINE ON SAVE
        IMPORTING keys FOR Person~set_email,
      mandatory_check FOR VALIDATE ON SAVE
        IMPORTING keys FOR Person~mandatory_check,
      set_complete FOR MODIFY
        IMPORTING keys FOR ACTION Person~set_complete RESULT result.

    METHODS get_features FOR FEATURES IMPORTING keys REQUEST requested_features FOR Person RESULT result.

ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD get_features.
    READ ENTITIES OF zi_person_m IN LOCAL MODE
    ENTITY person
      FIELDS ( Status )
      WITH CORRESPONDING #( keys )
      RESULT DATA(persons).

    result = VALUE #( FOR person IN persons (
                        %tky = person-%tky
                        %action-set_complete = COND #( WHEN person-Status = 'C'
                                                       THEN if_abap_behv=>fc-o-disabled
                                                       ELSE if_abap_behv=>fc-o-enabled )
                     ) ).

  ENDMETHOD.

  METHOD set_email.
    "Get firsName, lastName from instance
    READ ENTITIES OF zi_person_m IN LOCAL MODE
    ENTITY Person
      FIELDS ( FirstName LastName )
      WITH CORRESPONDING #( keys )
      RESULT DATA(persons).

    DATA(email) = |{ persons[ 1 ]-FirstName }_{ persons[ 1 ]-LastName }@com|.
    email = to_lower( email ).

    "Set email
    MODIFY ENTITIES OF zi_person_m IN LOCAL MODE
    ENTITY Person
      UPDATE
        FIELDS ( Email )
        WITH VALUE #( FOR person IN persons (
                         %tky = person-%tky
*                        PersonUUID = person-PersonUUID
*                        %is_draft = person-%is_draft
                        email = email
           ) )
      REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

  METHOD mandatory_check.
    "Get Mandatory Fields
    READ ENTITIES OF zi_person_m IN LOCAL MODE
    ENTITY Person
      FIELDS ( FirstName LastName )
      WITH CORRESPONDING #( keys )
      RESULT DATA(persons).

    "Do check
    LOOP AT persons INTO DATA(person).
*      APPEND VALUE #( %tky = person-%tky
*                      %state_area = 'mandatory_check')
*             TO reported-person.

      IF person-FirstName IS INITIAL.

        "Set failed keys
        APPEND VALUE #( %tky = person-%tky )
               TO failed-person.

        "Set message
        APPEND VALUE #( %tky = person-%tky
                        %element-FirstName = if_abap_behv=>mk-on
*                        %state_area = 'mandatory_check'
                        %msg = new_message(
                                 id       = 'ZRAP_MSG_YASU2122_2'
                                 number   = 001
                                 severity = if_abap_behv_message=>severity-error
                                 v1       = 'First Name'
                               ) )
               TO reported-person.
      ENDIF.

*      IF person-LastName IS INITIAL.
*
*        "Set failed keys
*        APPEND VALUE #( %tky = person-%tky )
*               TO failed-person.
*
*        "Set message
*        APPEND VALUE #( %tky = person-%tky
*                        %element-LastName = if_abap_behv=>mk-on
*                        %msg = new_message(
*                                 id       = 'ZRAP_MSG_YASU2122_2'
*                                 number   = 001
*                                 severity = if_abap_behv_message=>severity-error
*                                 v1       = 'Last Name'
*                               ) )
*               TO reported-person.
*      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD set_complete.
    "update status
    MODIFY ENTITIES OF zi_person_m IN LOCAL MODE
      ENTITY Person
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR key IN keys ( %tky = key-%tky
                                        Status = 'C' ) ). "Complete

    "read changed data for action result
    READ ENTITIES OF zi_person_m IN LOCAL MODE
      ENTITY person
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT DATA(persons).

    result = VALUE #( FOR person IN persons ( %tky = person-%tky
                                              %param = person ) ).

  ENDMETHOD.

ENDCLASS.
