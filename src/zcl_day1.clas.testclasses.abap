class ltcl_day1 definition final for testing duration short risk level harmless.

  PRIVATE SECTION.
    METHODS sample1 FOR TESTING RAISING cx_static_check.
    METHODS answer1 FOR TESTING RAISING cx_static_check.
    METHODS sample2 FOR TESTING RAISING cx_static_check.
    METHODS answer2 FOR TESTING RAISING cx_static_check.
endclass.


class ltcl_day1 implementation.
  METHOD sample1.
    DATA(result) = zcl_day1=>part1( use_sample = abap_true ).
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( exp = 142
                                        act = result ).
  ENDMETHOD.

  METHOD answer1.
    DATA(result) = zcl_day1=>part1( ).
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( exp = 55172
                                        act = result ).
  ENDMETHOD.

  METHOD sample2.
    DATA(result) = zcl_day1=>part2( use_sample = abap_true ).
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( exp = 281
                                        act = result ).
  ENDMETHOD.

  METHOD answer2.
    DATA(answer2) = zcl_day1=>part2( ).
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( exp = 54925
                                        act = answer2 ).
  ENDMETHOD.
endclass.
