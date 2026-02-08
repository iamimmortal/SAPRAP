CLASS lsc_zi_release DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.
    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_release IMPLEMENTATION.
  METHOD adjust_numbers.
    LOOP AT mapped-zi_release REFERENCE INTO DATA(map).

      IF map->Id IS NOT INITIAL.
        CONTINUE.
      ENDIF.

      TRY.
          "NEW ztest_cass( )->zoo_execute( ).
          cl_numberrange_runtime=>number_get( EXPORTING object      = 'ZRELEASEID'
                                                        nr_range_nr = '01'
                                              IMPORTING number      = DATA(lv_id) ).

        CATCH cx_nr_object_not_found.
        CATCH cx_number_ranges.

      ENDTRY.

      map->Id     = |{ lv_id ALPHA = OUT }|.
      map->Defect = map->%tmp-Defect.

    ENDLOOP.

    LOOP AT mapped-zi_attach REFERENCE INTO DATA(map_attach).
      IF map_attach->Zid IS NOT INITIAL.
        CONTINUE.
      ENDIF.

      TRY.
          map_attach->Zid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error.

      ENDTRY.

      map_attach->Zdefect = map_attach->%tmp-Zdefect.
      map_attach->Zrelid  = map_attach->%tmp-Zrelid.

    ENDLOOP.
  ENDMETHOD.

  METHOD save_modified.
    DATA release_log        TYPE STANDARD TABLE OF zrel_changelog.
    DATA release_log_create TYPE STANDARD TABLE OF zrel_changelog.
    DATA release_log_update TYPE STANDARD TABLE OF zrel_changelog.

    IF create-zi_release IS NOT INITIAL.
      release_log = CORRESPONDING #( create-zi_release ).
      LOOP AT release_log ASSIGNING FIELD-SYMBOL(<ls_release_log_crt>).
        <ls_release_log_crt>-changing_operation = 'CREATE'.
        GET TIME STAMP FIELD <ls_release_log_crt>-created_at.
        TRY.
            <ls_release_log_crt>-changed_by = cl_abap_context_info=>get_user_technical_name(  ).
          CATCH cx_abap_context_info_error.
        ENDTRY.
        TRY.
            <ls_release_log_crt>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
          CATCH cx_uuid_error.
        ENDTRY.
        <ls_release_log_crt>-changed_field_name = 'ID'.
        <ls_release_log_crt>-changed_value = <ls_release_log_crt>-id.
        APPEND <ls_release_log_crt> TO release_log_create.
      ENDLOOP.
      INSERT zrel_changelog FROM TABLE @release_log_create.
    ENDIF.

    IF update-zi_release IS NOT INITIAL.

      release_log = CORRESPONDING #( update-zi_release ).
      LOOP AT update-zi_release ASSIGNING FIELD-SYMBOL(<ls_release>).

        ASSIGN release_log[ Id = <ls_release>-Id ] TO FIELD-SYMBOL(<ls_release_log>).

        IF <ls_release_log>-id IS NOT INITIAL.

          SELECT SINGLE * FROM zi_release WHERE Id = @<ls_release_log>-id INTO @DATA(ls_release_db).
          <ls_release_log>-changing_operation = 'UPDATE'.
          GET TIME STAMP FIELD <ls_release_log>-created_at.

          TRY.
              <ls_release_log>-changed_by = cl_abap_context_info=>get_user_technical_name(  ).
            CATCH cx_abap_context_info_error.
          ENDTRY.

          IF <ls_release>-%control-Description = cl_abap_behv=>flag_changed.
            TRY.
                <ls_release_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
              CATCH cx_uuid_error.
                "handle exception
            ENDTRY.
            <ls_release_log>-changed_field_name = 'Description'.
            <ls_release_log>-changed_from = ls_release_db-Description.
            <ls_release_log>-changed_value = <ls_release>-Description.
            APPEND <ls_release_log> TO release_log_update.
          ENDIF.

          IF <ls_release>-%control-ffid = cl_abap_behv=>flag_changed.
            TRY.
                <ls_release_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
              CATCH cx_uuid_error.
                "handle exception
            ENDTRY.
            <ls_release_log>-changed_field_name = 'FFID'.
            <ls_release_log>-changed_from = ls_release_db-ffid.
            <ls_release_log>-changed_value = <ls_release>-ffid.
            APPEND <ls_release_log> TO release_log_update.
          ENDIF.

          IF <ls_release>-%control-IsDeployed = cl_abap_behv=>flag_changed.
            TRY.
                <ls_release_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
              CATCH cx_uuid_error.
                "handle exception
            ENDTRY.
            <ls_release_log>-changed_field_name = 'IsDeployed'.
            <ls_release_log>-changed_from = ls_release_db-IsDeployed.
            <ls_release_log>-changed_value = <ls_release>-IsDeployed.
            APPEND <ls_release_log> TO release_log_update.
          ENDIF.


          IF <ls_release>-%control-ReleaseDate = cl_abap_behv=>flag_changed.
            TRY.
                <ls_release_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
              CATCH cx_uuid_error.
                "handle exception
            ENDTRY.
            <ls_release_log>-changed_field_name = 'ReleaseDate'.
            <ls_release_log>-changed_from = ls_release_db-ReleaseDate.
            <ls_release_log>-changed_value = <ls_release>-ReleaseDate.
            APPEND <ls_release_log> TO release_log_update.
          ENDIF.

          IF <ls_release>-%control-ChangeType = cl_abap_behv=>flag_changed.
            TRY.
                <ls_release_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
              CATCH cx_uuid_error.
                "handle exception
            ENDTRY.
            <ls_release_log>-changed_field_name = 'Change Type'.
            <ls_release_log>-changed_from = ls_release_db-ChangeType.
            <ls_release_log>-changed_value = <ls_release>-ChangeType.
            APPEND <ls_release_log> TO release_log_update.
          ENDIF.

          IF <ls_release>-%control-Projecttype = cl_abap_behv=>flag_changed.
            TRY.
                <ls_release_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
              CATCH cx_uuid_error.
                "handle exception
            ENDTRY.
            <ls_release_log>-changed_field_name = 'Project Type'.
            <ls_release_log>-changed_from = ls_release_db-Projecttype.
            <ls_release_log>-changed_value = <ls_release>-Projecttype.
            APPEND <ls_release_log> TO release_log_update.
          ENDIF.

          IF <ls_release>-%control-Region = cl_abap_behv=>flag_changed.
            TRY.
                <ls_release_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
              CATCH cx_uuid_error.
                "handle exception
            ENDTRY.
            <ls_release_log>-changed_field_name = 'Region'.
            <ls_release_log>-changed_from = ls_release_db-Region.
            <ls_release_log>-changed_value = <ls_release>-Region.
            APPEND <ls_release_log> TO release_log_update.
          ENDIF.

          IF <ls_release>-%control-ReleaseType = cl_abap_behv=>flag_changed.
            TRY.
                <ls_release_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
              CATCH cx_uuid_error.
                "handle exception
            ENDTRY.
            <ls_release_log>-changed_field_name = 'Release Type'.
            <ls_release_log>-changed_from = ls_release_db-Region.
            <ls_release_log>-changed_value = <ls_release>-ReleaseType.
            APPEND <ls_release_log> TO release_log_update.
          ENDIF.

        ENDIF.

      ENDLOOP.

      INSERT zrel_changelog FROM TABLE @release_log_update.

    ENDIF.

    IF delete-zi_release IS NOT INITIAL.
      release_log = CORRESPONDING #( delete-zi_release ).
      LOOP AT release_log ASSIGNING <ls_release_log>.
        <ls_release_log>-changing_operation = 'DELETE'.
        GET TIME STAMP FIELD <ls_release_log>-created_at.
        TRY.
            <ls_release_log>-changed_by = cl_abap_context_info=>get_user_technical_name(  ).
          CATCH cx_abap_context_info_error.
        ENDTRY.
        TRY.
            <ls_release_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ) .
          CATCH cx_uuid_error.
        ENDTRY.
        <ls_release_log>-changed_field_name = 'ID'.
        <ls_release_log>-changed_value = <ls_release_log>-id.
        APPEND <ls_release_log> TO release_log_update.
      ENDLOOP.

      INSERT zrel_changelog FROM TABLE @release_log_update.

    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_RELEASE DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_release RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_release RESULT result.
    METHODS validatedd FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_release~validatedd.
    METHODS buildurl FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_release~buildurl.
    METHODS mrkdep FOR MODIFY
      IMPORTING keys FOR ACTION zi_release~mrkdep.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys           REQUEST requested_feature FOR zi_release
      RESULT    result_feature.


ENDCLASS.

CLASS lhc_ZI_RELEASE IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD ValidateDD.

    READ ENTITIES OF zi_release IN LOCAL MODE ENTITY zi_release
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result)
      FAILED DATA(lt_failed).

    LOOP AT lt_result INTO DATA(res).

      IF res-Region IS INITIAL.
        APPEND VALUE #( %tky = res-%tky ) TO failed-zi_release.
        APPEND VALUE #( %msg = new_message( id = 'ZMSG'
                                            number = '006'
                                            severity = if_abap_behv_message=>severity-error )
                                            %element-Region = if_abap_behv=>mk-on ) TO reported-zi_release.

      ENDIF.

      IF res-ChangeType IS INITIAL.
        APPEND VALUE #( %tky = res-%tky ) TO failed-zi_release.
        APPEND VALUE #( %msg = new_message( id = 'ZMSG'
                                            number = '007'
                                            severity = if_abap_behv_message=>severity-error )
                                            %element-ChangeType = if_abap_behv=>mk-on ) TO reported-zi_release.

      ENDIF.

      IF res-ReleaseType IS INITIAL.
        APPEND VALUE #( %tky = res-%tky ) TO failed-zi_release.
        APPEND VALUE #( %msg = new_message( id = 'ZMSG'
                                            number = '008'
                                            severity = if_abap_behv_message=>severity-error )
                                            %element-ReleaseType = if_abap_behv=>mk-on ) TO reported-zi_release.

      ENDIF.

      IF res-Projecttype IS INITIAL.
        APPEND VALUE #( %tky = res-%tky ) TO failed-zi_release.
        APPEND VALUE #( %msg = new_message( id = 'ZMSG'
                                            number = '009'
                                            severity = if_abap_behv_message=>severity-error )
                                            %element-Projecttype = if_abap_behv=>mk-on ) TO reported-zi_release.

      ENDIF.

      IF res-ReleaseDate IS INITIAL.
        APPEND VALUE #( %tky = res-%tky ) TO failed-zi_release.
        APPEND VALUE #( %msg = new_message( id = 'ZMSG'
                                            number = '010'
                                            severity = if_abap_behv_message=>severity-error )
                                            %element-ReleaseDate = if_abap_behv=>mk-on ) TO reported-zi_release.

      ENDIF.


      IF res-ReleaseDate IS NOT INITIAL AND res-IsDeployed NE 'X'.
        IF res-ReleaseDate LT cl_abap_context_info=>get_system_date(  ).
          APPEND VALUE #( %tky = res-%tky ) TO failed-zi_release.
          APPEND VALUE #( %tky = res-%tky
                                 %msg = new_message( id = 'ZMSG'
                                                         number = '012'
                                                         severity = if_abap_behv_message=>severity-error )
                                                         %element-ReleaseDate = if_abap_behv=>mk-on  ) TO reported-zi_release.
        ENDIF.
      ENDIF.

      IF res-ffid IS INITIAL.
        APPEND VALUE #( %tky = res-%tky ) TO failed-zi_release.
        APPEND VALUE #( %tky = res-%tky
                               %msg = new_message( id = 'ZMSG'
                                                       number = '013'
                                                       severity = if_abap_behv_message=>severity-error )
                                                       %element-ffid = if_abap_behv=>mk-on  ) TO reported-zi_release.
      ENDIF.

      IF res-IsDeployed EQ 'X'.
        SELECT SINGLE IsDeployed FROM zi_release WHERE Id = @res-Id AND Defect = @res-Defect INTO @DATA(lv_deployed).
        IF sy-subrc = 0.
          IF lv_deployed IS INITIAL.
            APPEND VALUE #( %tky = res-%tky
                            %msg = new_message( id = 'ZMSG'
                            number = '011'
                            severity = if_abap_behv_message=>severity-warning )
                            %element-ReleaseDate = if_abap_behv=>mk-on  ) TO reported-zi_release.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD BuildURL.
    READ ENTITIES OF zi_release IN LOCAL MODE
         ENTITY zi_release ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_results).

    LOOP AT lt_results ASSIGNING FIELD-SYMBOL(<ls_result>).

      IF <ls_result>-JiraUrl IS INITIAL.
        <ls_result>-JiraUrl = |https://Jira.company.com/browse/{ <ls_result>-Defect }|.
      ENDIF.

      IF <ls_result>-CreatedOn IS INITIAL.
        <ls_result>-CreatedOn = cl_abap_context_info=>get_system_date( ).
      ENDIF.

      IF <ls_result>-CreatedBy IS INITIAL.
        TRY.
            <ls_result>-CreatedBy = cl_abap_context_info=>get_user_technical_name(  ).
          CATCH cx_abap_context_info_error.
        ENDTRY.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF zi_release IN LOCAL MODE
           ENTITY zi_release
           UPDATE FIELDS ( JiraUrl CreatedOn CreatedBy )
           WITH CORRESPONDING #( lt_results ).
  ENDMETHOD.

  METHOD MrkDep.
    READ ENTITIES OF zi_release IN LOCAL MODE
         ENTITY zi_release ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
      <fs_data>-IsDeployed = 'X'.
    ENDLOOP.

    MODIFY ENTITIES OF zi_release IN LOCAL MODE
           ENTITY zi_release
           UPDATE FIELDS ( IsDeployed )
           WITH CORRESPONDING #( lt_data ).

*    result = VALUE #( FOR ls_key IN keys (
*        %cid_ref = ls_key-%cid_ref
*        %param   = VALUE #( IsDeployed = 'X' )
*     ) ).
*


  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF zi_release IN LOCAL MODE
         ENTITY zi_release ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_result).

    result_feature = VALUE #(
        FOR ls_result IN lt_result WHERE ( IsDeployed = 'X' )
        ( %tky    = ls_result-%tky
          "%features-%field-ChangeType = if_abap_behv=>fc-f-read_only
          "%features-%field-Description = if_abap_behv=>fc-f-read_only
          "%features-%field-ffid = if_abap_behv=>fc-f-read_only
          "%features-%field-Projecttype = if_abap_behv=>fc-f-read_only
          "%features-%field-Region = if_abap_behv=>fc-f-read_only
          "%features-%field-ReleaseDate = if_abap_behv=>fc-f-read_only
          "%features-%field-IsDeployed = if_abap_behv=>fc-f-read_only
          "%features-%field-ReleaseType = if_abap_behv=>fc-f-read_only
          %delete = if_abap_behv=>fc-o-disabled
          %update = if_abap_behv=>fc-o-disabled
          %assoc-_Attach = if_abap_behv=>fc-o-disabled
          %action = VALUE #( MrkDep = COND #( WHEN ls_result-IsDeployed = 'X'
                                              THEN if_abap_behv=>fc-o-disabled
                                              ELSE if_abap_behv=>fc-o-enabled ) ) ) ).
  ENDMETHOD.




ENDCLASS.
