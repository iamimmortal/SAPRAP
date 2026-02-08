CLASS ztest_cass DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  METHODS Zoo_execute.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ztest_cass IMPLEMENTATION.
   METHOD Zoo_execute.

DATA: lv_object   TYPE cl_numberrange_objects=>nr_attributes-object,
      lt_interval TYPE cl_numberrange_intervals=>nr_interval,
      ls_interval TYPE cl_numberrange_intervals=>nr_nriv_line.

    lv_object = 'ZRELEASEID'.

*   intervals
    ls_interval-nrrangenr  = '02'.
    ls_interval-fromnumber = '1000000000'.
    ls_interval-tonumber   = '9999999999'.
    ls_interval-procind    = 'U'.
    APPEND ls_interval TO lt_interval.

*   create intervals
    TRY.
        CALL METHOD cl_numberrange_intervals=>update
          EXPORTING
            interval  = lt_interval
            object    = lv_object
            subobject = ' '
          IMPORTING
            error     = DATA(lv_error)
            error_inf = DATA(ls_error)
            error_iv  = DATA(lt_error_iv)
            warning   = DATA(lv_warning).
      CATCH cx_root.

       ENDTRY.

  ENDMETHOD.
ENDCLASS.
