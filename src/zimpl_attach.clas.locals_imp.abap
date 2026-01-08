CLASS lhc_zi_attach DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      importing REQUEST requested_features FOR zi_attach RESULT result.
    METHODS addcreatedby FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_attach~addcreatedby.


ENDCLASS.

CLASS lhc_zi_attach IMPLEMENTATION.

  METHOD get_instance_features.


    LOOP AT importing INTO DATA(ls_imp).

      SELECT SINGLE IsDeployed FROM zi_release
                               WHERE Id = @ls_imp-Zrelid
                               INTO @DATA(lv_deployed).

      CHECK lv_deployed EQ abap_true.

      APPEND VALUE #( %tky = ls_imp-%tky
                        %delete = if_abap_behv=>fc-o-disabled
                        %update = if_abap_behv=>fc-o-disabled   ) TO result.
    ENDLOOP.

  ENDMETHOD.


  METHOD AddCreatedBy.

    READ ENTITIES OF zi_release IN LOCAL MODE
    ENTITY zi_attach ALL FIELDS WITH CORRESPONDING  #( keys )
    RESULT DATA(lt_results).

    LOOP AT lt_results ASSIGNING FIELD-SYMBOL(<ls_result>).
      IF <ls_result>-Crtby IS INITIAL.
        TRY.
            <ls_result>-Crtby = cl_abap_context_info=>get_user_technical_name(  ).
          CATCH cx_abap_context_info_error.
        ENDTRY.
      ENDIF.

      IF <ls_result>-Crton IS INITIAL.
        <ls_result>-Crton = cl_abap_context_info=>get_system_date( ).
      ENDIF.
    ENDLOOP.

        MODIFY ENTITIES OF zi_release IN LOCAL MODE
           ENTITY zi_attach
           UPDATE FIELDS ( Crtby Crton )
           WITH CORRESPONDING #( lt_results ).

  ENDMETHOD.

ENDCLASS.
