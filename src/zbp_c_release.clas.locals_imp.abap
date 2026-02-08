CLASS lhc_zc_release DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS precheck_create FOR PRECHECK
      IMPORTING entities FOR CREATE zc_release.
    METHODS precheck_update FOR PRECHECK
      IMPORTING entities FOR UPDATE zc_release.

ENDCLASS.

CLASS lhc_zc_release IMPLEMENTATION.

  METHOD precheck_create.



    LOOP AT entities INTO DATA(ls_entity).
      "check defect format
      FIND PCRE '^[A-Z]+-\d' IN ls_entity-Defect MATCH COUNT DATA(lv_count).
      IF lv_count <= 0.
        APPEND VALUE #( %cid = ls_entity-%cid ) TO failed-zc_release.
        APPEND VALUE #( %cid = ls_entity-%cid
                          %msg = new_message( id = 'ZMSG'
                                              number = '014'
                                              severity = if_abap_behv_message=>severity-error )
                                               %element-Defect = if_abap_behv=>mk-on ) TO reported-zc_release.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD precheck_update.
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entity>).

      " Region check
      IF <fs_entity>-Region IS NOT INITIAL.
        SELECT SINGLE staging FROM zi_region_fv WHERE staging = @<fs_entity>-Region INTO @DATA(lv_region).
        IF sy-subrc <> 0.
          APPEND VALUE #( %tky = <fs_entity>-%tky ) TO failed-zc_release.
          APPEND VALUE #( %tky = <fs_entity>-%tky
                          %msg = new_message( id = 'ZMSG'
                                              number = '001'
                                              severity = if_abap_behv_message=>severity-error )
                                               %element-Region = if_abap_behv=>mk-on ) TO reported-zc_release.
        ENDIF.
      ENDIF.

      " ChangeType check
      IF <fs_entity>-ChangeType IS NOT INITIAL.
        SELECT SINGLE ChangeTyp FROM zi_change_fv WHERE ChangeTyp = @<fs_entity>-ChangeType INTO @DATA(lv_change).
        IF sy-subrc <> 0.
          APPEND VALUE #( %tky = <fs_entity>-%tky ) TO failed-zc_release.
          APPEND VALUE #( %tky = <fs_entity>-%tky
                          %msg = new_message( id = 'ZMSG'
                                              number = '002'
                                              severity = if_abap_behv_message=>severity-error )
                                              %element-ChangeType = if_abap_behv=>mk-on ) TO reported-zc_release.
        ENDIF.
      ENDIF.

      " ProjectType check
      IF <fs_entity>-Projecttype IS NOT INITIAL.
        SELECT SINGLE projtype FROM zi_project_fv WHERE projtype = @<fs_entity>-Projecttype INTO @DATA(lv_prj).
        IF sy-subrc <> 0.
          APPEND VALUE #( %tky = <fs_entity>-%tky ) TO failed-zc_release.
          APPEND VALUE #( %tky = <fs_entity>-%tky
                          %msg = new_message( id = 'ZMSG'
                                              number = '004'
                                              severity = if_abap_behv_message=>severity-error )
                                              %element-Projecttype = if_abap_behv=>mk-on ) TO reported-zc_release.
        ENDIF.
      ENDIF.

      " ReleaseType check
      IF <fs_entity>-ReleaseType IS NOT INITIAL.
        SELECT SINGLE reltype FROM zi_reltyp_fv WHERE reltype = @<fs_entity>-ReleaseType INTO @DATA(lv_rel).
        IF sy-subrc <> 0.
          APPEND VALUE #( %tky = <fs_entity>-%tky ) TO failed-zc_release.
          APPEND VALUE #( %tky = <fs_entity>-%tky
                          %msg = new_message( id = 'ZMSG'
                                              number = '003'
                                              severity = if_abap_behv_message=>severity-error )
                                              %element-ReleaseType = if_abap_behv=>mk-on ) TO reported-zc_release.
        ENDIF.
      ENDIF.

      IF <fs_entity>-IsDeployed = 'X'.
        APPEND VALUE #( %tky = <fs_entity>-%tky
                        %msg = new_message( id = 'ZMSG'
                                                number = '011'
                                                severity = if_abap_behv_message=>severity-warning )
                                                %element-IsDeployed = if_abap_behv=>mk-on  ) TO reported-zc_release.
      ENDIF.

      IF <fs_entity>-ReleaseDate IS NOT INITIAL AND <fs_entity>-IsDeployed NE 'X'.
        IF <fs_entity>-ReleaseDate LT cl_abap_context_info=>get_system_date(  ).
          APPEND VALUE #( %tky = <fs_entity>-%tky
                                 %msg = new_message( id = 'ZMSG'
                                                         number = '012'
                                                         severity = if_abap_behv_message=>severity-error )
                                                         %element-ReleaseDate = if_abap_behv=>mk-on  ) TO reported-zc_release.
        ENDIF.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
