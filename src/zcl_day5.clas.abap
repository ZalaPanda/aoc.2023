CLASS zcl_day5 DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS part1 IMPORTING use_sample    TYPE abap_bool OPTIONAL
                        RETURNING VALUE(result) TYPE i.

    CLASS-METHODS part2 IMPORTING use_sample    TYPE abap_bool OPTIONAL
                        RETURNING VALUE(result) TYPE i.

  PRIVATE SECTION.
    CLASS-METHODS get_puzzle_sample RETURNING VALUE(result) TYPE string_table.
    CLASS-METHODS get_puzzle_input  RETURNING VALUE(result) TYPE string_table.
ENDCLASS.


CLASS zcl_day5 IMPLEMENTATION.
  METHOD part1.
    DATA(input) = COND string_table( WHEN use_sample = abap_true THEN get_puzzle_sample( ) ELSE get_puzzle_input( ) ).
    TYPES integer_table TYPE TABLE OF int8 WITH DEFAULT KEY.
    DATA source TYPE integer_table.
    DATA target TYPE integer_table.

    LOOP AT input ASSIGNING FIELD-SYMBOL(<line>).
      IF find( val   = <line>
               regex = 'seeds: ' ) = 0.
        SPLIT <line>+7 AT ' ' INTO TABLE DATA(seed_strings).
        INSERT LINES OF VALUE integer_table( FOR <seed_string> IN seed_strings
                                             ( CONV int8( <seed_string> ) ) ) INTO TABLE source.
      ELSEIF find( val   = <line>
                   regex = '\d' ) = 0.
        DATA(target_range_start) = CONV int8( segment( val   = <line>
                                                       index = 1 ) ).
        DATA(source_range_start) = CONV int8( segment( val   = <line>
                                                       index = 2 ) ).
        DATA(range_length) = CONV int8( segment( val   = <line>
                                                 index = 3 ) ).

        LOOP AT source ASSIGNING FIELD-SYMBOL(<current>).
          IF <current> BETWEEN source_range_start AND source_range_start + range_length.
            INSERT <current> - source_range_start + target_range_start INTO TABLE target.
            DELETE TABLE source FROM <current>.
          ENDIF.
        ENDLOOP.
      ELSEIF <line> IS INITIAL.
        INSERT LINES OF target INTO TABLE source.
        CLEAR target.
      ENDIF.
    ENDLOOP.
    INSERT LINES OF source INTO TABLE target.
    result = REDUCE i(
      INIT min = cl_abap_math=>max_int4
      FOR <final> IN target
      NEXT min = nmin( val1 = min
                       val2 = <final> ) ).
    WRITE / |{ result } is the lowest location number that corresponds to any of the initial seed numbers.|.
  ENDMETHOD.

  METHOD part2.
    DATA(input) = COND string_table( WHEN use_sample = abap_true THEN get_puzzle_sample( ) ELSE get_puzzle_input( ) ).
    TYPES: BEGIN OF range,
             start TYPE int8,
             close TYPE int8,
           END OF range.
    TYPES range_table TYPE TABLE OF range WITH KEY start.
    DATA source TYPE range_table.
    DATA target TYPE range_table.
    DATA append TYPE range_table.
    LOOP AT input ASSIGNING FIELD-SYMBOL(<line>).
      IF find( val   = <line>
               regex = 'seeds: ' ) = 0.
        SPLIT <line>+7 AT ' ' INTO TABLE DATA(seed_strings).
        target = VALUE range_table(
            FOR i = 1 WHILE i <= lines( seed_strings ) DIV 2
            ( start = seed_strings[ i * 2 - 1 ] close = seed_strings[ i * 2 - 1 ] + seed_strings[ i * 2 ] ) ).
      ELSEIF find( val   = <line>
                   regex = '\d' ) = 0.
        DATA(target_range_start) = CONV int8( segment( val   = <line>
                                                       index = 1 ) ).
        DATA(source_range_start) = CONV int8( segment( val   = <line>
                                                       index = 2 ) ).
        DATA(range_length) = CONV int8( segment( val   = <line>
                                                 index = 3 ) ).

        DATA(delta) = target_range_start - source_range_start.
        DATA(config) = VALUE range( start = source_range_start
                                    close = source_range_start + range_length ).

        LOOP AT source ASSIGNING FIELD-SYMBOL(<current>).
          IF config-start > <current>-close OR config-close < <current>-start.
            CONTINUE.
          ENDIF.

          DATA(union) = VALUE range( start = nmax( val1 = <current>-start
                                                   val2 = config-start )
                                     close = nmin( val1 = <current>-close
                                                   val2 = config-close ) ).

          IF <current>-start < union-start. " the range under the config
            INSERT VALUE range( start = <current>-start
                                close = union-start ) INTO TABLE append.
          ENDIF.
          IF <current>-close > union-close. " the range above the config
            INSERT VALUE range( start = union-close
                                close = <current>-close ) INTO TABLE append.
          ENDIF.
          INSERT VALUE range( start = union-start + delta
                              close = union-close + delta ) INTO TABLE target.

          DELETE TABLE source FROM <current>.
        ENDLOOP.
        INSERT LINES OF append INTO TABLE source.
        CLEAR append.
      ELSEIF <line> IS INITIAL.
        INSERT LINES OF target INTO TABLE source.
        CLEAR target.
      ENDIF.
    ENDLOOP.
    INSERT LINES OF source INTO TABLE target.
    result = REDUCE i(
      INIT min = cl_abap_math=>max_int4
      FOR <final> IN target
      NEXT min = nmin( val1 = min
                       val2 = <final>-start ) ). " the start should be the smallest, right?
    WRITE / |{ result } is the lowest location number that corresponds to any of the initial seed numbers.|.
  ENDMETHOD.

  METHOD get_puzzle_sample.
    SPLIT
|seeds: 79 14 55 13\n| &&
|\n| &&
|seed-to-soil map:\n| &&
|50 98 2\n| &&
|52 50 48\n| &&
|\n| &&
|soil-to-fertilizer map:\n| &&
|0 15 37\n| &&
|37 52 2\n| &&
|39 0 15\n| &&
|\n| &&
|fertilizer-to-water map:\n| &&
|49 53 8\n| &&
|0 11 42\n| &&
|42 0 7\n| &&
|57 7 4\n| &&
|\n| &&
|water-to-light map:\n| &&
|88 18 7\n| &&
|18 25 70\n| &&
|\n| &&
|light-to-temperature map:\n| &&
|45 77 23\n| &&
|81 45 19\n| &&
|68 64 13\n| &&
|\n| &&
|temperature-to-humidity map:\n| &&
|0 69 1\n| &&
|1 0 69\n| &&
|\n| &&
|humidity-to-location map:\n| &&
|60 56 37\n| &&
|56 93 4| AT |\n| INTO TABLE result.
  ENDMETHOD.

  METHOD get_puzzle_input.
    SPLIT
|seeds: 202517468 131640971 1553776977 241828580 1435322022 100369067 2019100043 153706556 460203450 84630899 3766866638 114261107 1809826083 153144153 2797169753 177517156 2494032210 235157184 856311572 542740109\n| &&
|\n| &&
|seed-to-soil map:\n| &&
|1393363309 644938450 159685707\n| &&
|2025282601 1844060172 19312202\n| &&
|1233103806 1026919253 32871092\n| &&
|1086566452 1933428941 86530991\n| &&
|1265974898 0 21589659\n| &&
|1357621124 1636167265 35742185\n| &&
|2343571960 2665606060 81121142\n| &&
|1585337376 809179011 202497192\n| &&
|3151050390 3039622538 54531851\n| &&
|2059837853 804624157 4554854\n| &&
|169037772 124717914 59280146\n| &&
|228317918 183998060 248114943\n| &&
|2646529073 2343571960 51673623\n| &&
|1173097443 1360585007 60006363\n| &&
|2000660015 1203115155 24622586\n| &&
|1059486394 1176035097 27080058\n| &&
|3129081851 4185259485 17367169\n| &&
|3599437884 3098755759 211817367\n| &&
|2810085327 3883695720 116314513\n| &&
|2424693102 4015066563 32329632\n| &&
|3398847262 2507128214 141172870\n| &&
|1787834568 432113003 212825447\n| &&
|1553049016 1603878905 32288360\n| &&
|3111414816 4202626654 17667035\n| &&
|4015961437 3493485543 279005859\n| &&
|3584381554 4000010233 15056330\n| &&
|609280127 1840486939 3573233\n| &&
|0 1603418622 460283\n| &&
|3302297495 3310573126 79244791\n| &&
|3811255251 4047396195 137863290\n| &&
|3381542286 2648301084 17304976\n| &&
|3280255848 3389817917 22041647\n| &&
|840113387 21589659 103128255\n| &&
|3949118541 3816852824 66842896\n| &&
|3205582241 4220293689 74673607\n| &&
|657286135 1420591370 182827252\n| &&
|1287564557 1863372374 70056567\n| &&
|460283 1671909450 168577489\n| &&
|2926399840 2746727202 103388997\n| &&
|3146449020 3094154389 4601370\n| &&
|943241642 1059790345 116244752\n| &&
|476432861 1227737741 132847266\n| &&
|612853360 2019959932 44432775\n| &&
|2698202696 2395245583 111882631\n| &&
|3029788837 3411859564 81625979\n| &&
|2044594803 1011676203 15243050\n| &&
|2457022734 2850116199 189506339\n| &&
|3540020132 3772491402 44361422\n| &&
|\n| &&
|soil-to-fertilizer map:\n| &&
|1845319553 827629590 305617985\n| &&
|3122295925 2644420892 346256096\n| &&
|1459294850 681645131 145984459\n| &&
|1609507353 0 58999651\n| &&
|255693782 1322254706 15503402\n| &&
|1136906676 1310560683 7032394\n| &&
|609209731 1833691163 45329504\n| &&
|271197184 2213414186 148369535\n| &&
|3483324631 2990676988 343929863\n| &&
|3943098203 3619829050 148418709\n| &&
|2945015193 3803447520 177280732\n| &&
|504622935 1337758108 104586796\n| &&
|2644420892 3334606851 81771815\n| &&
|2909815432 3768247759 35199761\n| &&
|3468873015 4096571961 14451616\n| &&
|3827254494 3980728252 115843709\n| &&
|1044649784 1218303791 92256892\n| &&
|3468552021 4111023577 320994\n| &&
|1605279309 677417087 4228044\n| &&
|1668507004 58999651 176812549\n| &&
|978403972 1317593077 4661629\n| &&
|212737043 1879020667 42956739\n| &&
|916089003 1655081947 62314969\n| &&
|0 1442344904 212737043\n| &&
|1228536146 2361783721 230758704\n| &&
|419566719 1133247575 85056216\n| &&
|1143939070 1717396916 84597076\n| &&
|2726192707 4111344571 183622725\n| &&
|983065601 2151830003 61584183\n| &&
|2150937538 235812200 441604887\n| &&
|884391832 1801993992 31697171\n| &&
|654539235 1921977406 229852597\n| &&
|4091516912 3416378666 203450384\n| &&
|\n| &&
|fertilizer-to-water map:\n| &&
|2549847515 3576009818 718957478\n| &&
|0 241538153 477666033\n| &&
|2425421388 2487425840 6333278\n| &&
|2431754666 2369332991 118092849\n| &&
|4172623904 3453666426 122343392\n| &&
|2050888028 0 241538153\n| &&
|2369332991 2493759118 56088397\n| &&
|477666033 719204186 1573221995\n| &&
|3268804993 2587418451 866247975\n| &&
|4135052968 2549847515 37570936\n| &&
|\n| &&
|water-to-light map:\n| &&
|0 614660468 46162263\n| &&
|992982309 3320291957 519425172\n| &&
|2148695908 4242883656 34662742\n| &&
|2183358650 992982309 1749887545\n| &&
|622053693 575891430 38769038\n| &&
|1973119806 3839717129 175576102\n| &&
|3950667093 3281596434 38695523\n| &&
|46162263 0 575891430\n| &&
|1512407481 4015293231 227590425\n| &&
|1739997906 3048474534 233121900\n| &&
|3933246195 4277546398 17420898\n| &&
|3989362616 2742869854 305604680\n| &&
|\n| &&
|light-to-temperature map:\n| &&
|3926915598 4278168812 16798484\n| &&
|1868013910 2147559018 140836186\n| &&
|750719301 1001446770 132766166\n| &&
|0 591148217 159571084\n| &&
|2757723179 3756680674 111319765\n| &&
|3526572182 1656447494 400343416\n| &&
|159571084 0 569934147\n| &&
|2869042944 3868000439 358532427\n| &&
|2008850096 3039560686 189896094\n| &&
|2649579616 3734175051 22505623\n| &&
|2270874649 2588070691 164667420\n| &&
|4008144721 2752738111 286822575\n| &&
|2435542069 2374033144 214037547\n| &&
|2672085239 2288395204 85637940\n| &&
|3450693140 2056790910 18639649\n| &&
|3469332789 3452574549 57239393\n| &&
|883485467 750719301 250727469\n| &&
|3943714082 3509813942 64430639\n| &&
|3227575371 3229456780 223117769\n| &&
|1708083440 3574244581 159930470\n| &&
|2198746190 2075430559 72128459\n| &&
|729505231 569934147 21214070\n| &&
|1656447494 4226532866 51635946\n| &&
|\n| &&
|temperature-to-humidity map:\n| &&
|2530950430 2986195732 64296956\n| &&
|3097031068 3050492688 225336526\n| &&
|2595247386 2262922844 63415061\n| &&
|394235114 386308291 573314459\n| &&
|159338027 199058685 71729011\n| &&
|2107189180 2969998741 16196991\n| &&
|231067038 0 22309581\n| &&
|266735072 959622750 109765613\n| &&
|1941982137 2514902112 165207043\n| &&
|3525862760 2680109155 81512917\n| &&
|3809165514 2049071587 78022870\n| &&
|3887188384 2459869958 55032154\n| &&
|61551861 270787696 97786166\n| &&
|4083271930 3575006611 18595319\n| &&
|993228240 162831557 10548461\n| &&
|967549573 173380018 25678667\n| &&
|376500685 368573862 17734429\n| &&
|2877832272 3856947724 19626311\n| &&
|3607375677 4093177459 201789837\n| &&
|2519444451 4007134226 11505979\n| &&
|2658662447 4082384303 10793156\n| &&
|3322367594 3945539199 61595027\n| &&
|253376619 149473104 13358453\n| &&
|0 87921243 61551861\n| &&
|2961202681 2127094457 135828387\n| &&
|3942220538 3468929261 33142375\n| &&
|2669455603 2761622072 208376669\n| &&
|4197950728 3371912693 97016568\n| &&
|4101867249 3275829214 96083479\n| &&
|2446763340 1976390476 72681111\n| &&
|2313231287 2326337905 133532053\n| &&
|2897458583 4018640205 63744098\n| &&
|2123386171 3667102608 189845116\n| &&
|1003776701 22309581 65611662\n| &&
|3975362913 3593601930 73500678\n| &&
|4048863591 1941982137 34408339\n| &&
|3452927785 3502071636 72934975\n| &&
|3383962621 3876574035 68965164\n| &&
|\n| &&
|humidity-to-location map:\n| &&
|0 853712401 14149303\n| &&
|2655090225 1087300934 303915897\n| &&
|2027272660 3174210041 18998832\n| &&
|1525779414 1936221923 38337972\n| &&
|4147713982 3193208873 142508118\n| &&
|2959006122 2143904256 380930882\n| &&
|1087300934 1765319513 65896883\n| &&
|1352738345 4121926227 173041069\n| &&
|1290854129 4060042011 61884216\n| &&
|3931908769 4005664051 54377960\n| &&
|4091732209 2524835138 55981773\n| &&
|653782902 95274560 214078802\n| &&
|477505648 85866717 9407843\n| &&
|2632545935 1543458967 22544290\n| &&
|123251703 309353362 97540905\n| &&
|3762564408 1974559895 169344361\n| &&
|3487433944 3409639319 23582322\n| &&
|318179985 430129950 159325663\n| &&
|1216931801 3335716991 12046317\n| &&
|1153197817 2580816911 63733984\n| &&
|14149303 406894267 23235683\n| &&
|2206646140 3433221641 320894268\n| &&
|3986286729 1566003257 105445480\n| &&
|37384986 0 85866717\n| &&
|2112775364 1671448737 93870776\n| &&
|2046271492 3107706169 66503872\n| &&
|3511016266 3754115909 251548142\n| &&
|1228978118 3347763308 61876011\n| &&
|1564117386 2644550895 463155274\n| &&
|3339937004 1391216831 147496940\n| &&
|486913491 589455613 166869411\n| &&
|4290222100 1538713771 4745196\n| &&
|220792608 756325024 97387377\n| &&
|2527540408 1831216396 105005527| AT |\n| INTO TABLE result.
  ENDMETHOD.
ENDCLASS.
