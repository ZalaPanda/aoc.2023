CLASS zcl_day6 DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS part1 IMPORTING use_sample    TYPE abap_bool OPTIONAL
                        RETURNING VALUE(result) TYPE int8.

    CLASS-METHODS part2 IMPORTING use_sample    TYPE abap_bool OPTIONAL
                        RETURNING VALUE(result) TYPE int8.

  PRIVATE SECTION.
    CLASS-METHODS get_puzzle_sample RETURNING VALUE(result) TYPE string_table.
    CLASS-METHODS get_puzzle_input  RETURNING VALUE(result) TYPE string_table.
ENDCLASS.


CLASS zcl_day6 IMPLEMENTATION.
  METHOD part1.
    TYPES: BEGIN OF race,
             time TYPE i,
             dist TYPE i,
           END OF race.
    TYPES race_table TYPE TABLE OF race WITH DEFAULT KEY.

    DATA(input) = COND string_table( WHEN use_sample = abap_true THEN get_puzzle_sample( ) ELSE get_puzzle_input( ) ).
    SPLIT condense( val = shift_left( places = 9
                                      val    = input[ 1 ] ) ) AT ' ' INTO TABLE DATA(times).
    SPLIT condense( val = shift_left( places = 9
                                      val    = input[ 2 ] ) ) AT ' ' INTO TABLE DATA(dists).
    DATA(race) = VALUE race_table( FOR i = 1 WHILE i <= lines( times )
                                   ( time = CONV i( times[ i ] ) dist = CONV i( dists[ i ] ) ) ).

    result = 1.
    LOOP AT race ASSIGNING FIELD-SYMBOL(<race>).
      DATA(d) = <race>-time ** 2 - 4 * ( <race>-dist + 1 ).
      DATA(x1) = floor( ( <race>-time + sqrt( d ) ) / 2 ).
      DATA(x2) = ceil( ( <race>-time - sqrt( d ) ) / 2 ).
      DATA(number_of_ways) = x1 - x2 + 1.
      result = result * number_of_ways.
    ENDLOOP.

    WRITE / |{ result } is the answer.|.
  ENDMETHOD.

  METHOD part2.
    DATA(input) = COND string_table( WHEN use_sample = abap_true THEN get_puzzle_sample( ) ELSE get_puzzle_input( ) ).
    DATA(time) = CONV int8( translate( from = | |
                                       to   = ||
                                       val  = shift_left( val    = input[ 1 ]
                                                          places = 9 ) ) ).
    DATA(dist) = CONV int8( translate( from = | |
                                       to   = ||
                                       val  = shift_left( val    = input[ 2 ]
                                                          places = 9 ) ) ).
    DATA(d) = time ** 2 - 4 * ( dist + 1 ).
    DATA(x1) = floor( ( time + sqrt( d ) ) / 2 ).
    DATA(x2) = ceil( ( time - sqrt( d ) ) / 2 ).
    result = x1 - x2 + 1.
    WRITE / |{ result } is the answer.|.
  ENDMETHOD.

  METHOD get_puzzle_sample.
    SPLIT
|Time:      7  15   30\n| &&
|Distance:  9  40  200\n| AT |\n| INTO TABLE result.
  ENDMETHOD.

  METHOD get_puzzle_input.
    SPLIT
|Time:        34     90     89     86\n| &&
|Distance:   204   1713   1210   1780\n| AT |\n| INTO TABLE result.
  ENDMETHOD.
ENDCLASS.
