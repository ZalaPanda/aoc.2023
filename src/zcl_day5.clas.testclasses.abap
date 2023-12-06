CLASS ltcl_day5 DEFINITION FINAL FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    METHODS sample1 FOR TESTING RAISING cx_static_check.
    METHODS answer1 FOR TESTING RAISING cx_static_check.
    METHODS sample2 FOR TESTING RAISING cx_static_check.
    METHODS answer2 FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_day5 IMPLEMENTATION.
  METHOD sample1.
    DATA(result) = zcl_day5=>part1( use_sample = abap_true ).
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( exp = 35
                                        act = result ).
  ENDMETHOD.

  METHOD answer1.
    DATA(result) = zcl_day5=>part1( ).
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( exp = 318728750
                                        act = result ).
  ENDMETHOD.

  METHOD sample2.
    DATA(result) = zcl_day5=>part2( use_sample = abap_true ).
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( exp = 46
                                        act = result ).
  ENDMETHOD.

  METHOD answer2.
    DATA(answer2) = zcl_day5=>part2( ).
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( exp = 37384986
                                        act = answer2 ).
  ENDMETHOD.
ENDCLASS.
