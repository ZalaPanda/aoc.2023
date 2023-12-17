CLASS zcl_day7 DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS part1 IMPORTING use_sample    TYPE abap_bool OPTIONAL
                        RETURNING VALUE(result) TYPE int8.

    CLASS-METHODS part2 IMPORTING use_sample    TYPE abap_bool OPTIONAL
                        RETURNING VALUE(result) TYPE int8.

  PRIVATE SECTION.
    CLASS-METHODS get_puzzle_sample RETURNING VALUE(result) TYPE string_table.
    CLASS-METHODS get_puzzle_input  RETURNING VALUE(result) TYPE string_table.
ENDCLASS.


CLASS zcl_day7 IMPLEMENTATION.
  METHOD part1.
    TYPES: BEGIN OF game,
             cards    TYPE string,
             bid      TYPE i,
             strength TYPE i,
           END OF game.
    TYPES: BEGIN OF cards_count,
             card  TYPE c LENGTH 1,
             count TYPE i,
           END OF cards_count.
    DATA games TYPE TABLE OF game WITH DEFAULT KEY.
    DATA cards TYPE TABLE OF cards_count WITH DEFAULT KEY.

    DATA(input) = COND string_table( WHEN use_sample = abap_true THEN get_puzzle_sample( ) ELSE get_puzzle_input( ) ).
    LOOP AT input ASSIGNING FIELD-SYMBOL(<line>).
      DATA(game) = VALUE game( cards = translate( from = |AKQJT|
                                                  to   = |EDCBA|
                                                  val  = segment( index = 1
                                                                  val   = <line> ) )
                               bid   = CONV i( segment( index = 2
                                                        val   = <line> ) ) ).

      cards = VALUE #( FOR GROUPS <group> OF <card> IN
                       VALUE string_table( FOR i = 0 WHILE i < 5 " ? strlen( game-cards )
                                           ( game-cards+i(1) ) )
                       GROUP BY
                       ( card = <card> size = GROUP SIZE ) " NOTE: this language is a mess
                       ( card = <group>-card count = <group>-size ) ).

      game-strength = COND i( WHEN line_exists( cards[ count = 5 ] )                        THEN 7 " Five of a kind
                              WHEN line_exists( cards[ count = 4 ] )                        THEN 6 " Four of a kind
                              WHEN line_exists( cards[ count = 3 ] ) AND lines( cards ) = 2 THEN 5 " Full house
                              WHEN line_exists( cards[ count = 3 ] )                        THEN 4 " Three of a kind
                              WHEN line_exists( cards[ count = 2 ] ) AND lines( cards ) = 3 THEN 3 " Two pair
                              WHEN line_exists( cards[ count = 2 ] )                        THEN 2 " One pair
                              WHEN lines( cards ) = 5                                       THEN 1 " High card
                              ELSE                                                               0 ). " Error
      INSERT game INTO TABLE games.
    ENDLOOP.
    SORT games BY strength
                  cards.
    LOOP AT games ASSIGNING FIELD-SYMBOL(<game>).
      DATA(rank) = sy-tabix.
      result = result + rank * <game>-bid.
    ENDLOOP.

    WRITE / |{ result } are the total winnings.|.
  ENDMETHOD.

  METHOD part2.
    TYPES: BEGIN OF game,
             cards    TYPE string,
             bid      TYPE i,
             strength TYPE i,
           END OF game.
    TYPES: BEGIN OF cards_count,
             card  TYPE c LENGTH 1,
             count TYPE i,
           END OF cards_count.
    DATA games TYPE TABLE OF game WITH DEFAULT KEY.
    DATA cards TYPE TABLE OF cards_count WITH DEFAULT KEY.

    DATA(input) = COND string_table( WHEN use_sample = abap_true THEN get_puzzle_sample( ) ELSE get_puzzle_input( ) ).
    LOOP AT input ASSIGNING FIELD-SYMBOL(<line>).
      DATA(game) = VALUE game( cards = translate( from = |AKQJT|
                                                  to   = |EDC1A| " NOTE: J is replaces with 1
                                                  val  = segment( index = 1
                                                                  val   = <line> ) )
                               bid   = CONV i( segment( index = 2
                                                        val   = <line> ) ) ).

      cards = VALUE #( FOR GROUPS <group> OF <card> IN
                       VALUE string_table( FOR i = 0 WHILE i < 5
                                           ( game-cards+i(1) ) )
                       GROUP BY
                       ( card = <card> size = GROUP SIZE )
                       ( card = <group>-card count = <group>-size ) ).

      IF lines( cards ) > 1 AND line_exists( cards[ card = '1' ] ). " NOTE: J was replaces with 1
        DATA(joker_count) = cards[ card = '1' ]-count.
        DELETE cards WHERE card = '1'. " NOTE: remove J and add the count to the card with the highest count
        SORT cards BY count DESCENDING.
        cards[ 1 ]-count = cards[ 1 ]-count + joker_count.
      ENDIF.
      game-strength = COND i( WHEN line_exists( cards[ count = 5 ] )                        THEN 7 " Five of a kind
                              WHEN line_exists( cards[ count = 4 ] )                        THEN 6 " Four of a kind
                              WHEN line_exists( cards[ count = 3 ] ) AND lines( cards ) = 2 THEN 5 " Full house
                              WHEN line_exists( cards[ count = 3 ] )                        THEN 4 " Three of a kind
                              WHEN line_exists( cards[ count = 2 ] ) AND lines( cards ) = 3 THEN 3 " Two pair
                              WHEN line_exists( cards[ count = 2 ] )                        THEN 2 " One pair
                              WHEN lines( cards ) = 5                                       THEN 1 " High card
                              ELSE                                                               0 ). " Error
      INSERT game INTO TABLE games.
    ENDLOOP.
    SORT games BY strength
                  cards.
    LOOP AT games ASSIGNING FIELD-SYMBOL(<game>).
      DATA(rank) = sy-tabix.
      result = result + rank * <game>-bid.
    ENDLOOP.

    WRITE / |{ result } are the total winnings with the stupid joker rule.|.
  ENDMETHOD.

  METHOD get_puzzle_sample.
    SPLIT
|32T3K 765\n| &&
|T55J5 684\n| &&
|KK677 28\n| &&
|KTJJT 220\n| &&
|QQQJA 483\n| AT |\n| INTO TABLE result.
  ENDMETHOD.

  METHOD get_puzzle_input.
    SPLIT
|239A8 171\n| && |8J456 629\n| && |QKJ7Q 687\n| && |67885 526\n| && |24JT3 993\n| &&
|63K64 692\n| && |28K88 46\n| && |KKK35 493\n| && |AAAA8 78\n| && |4K43T 199\n| &&
|22A2J 212\n| && |3J949 943\n| && |96JQJ 546\n| && |62666 243\n| && |637J9 860\n| &&
|9K9K9 632\n| && |99494 375\n| && |KKK8K 22\n| && |AA8A8 780\n| && |QQ422 715\n| &&
|Q8QQQ 657\n| && |9J955 241\n| && |56Q55 194\n| && |2KKQ4 69\n| && |55552 956\n| &&
|73TT7 808\n| && |62T26 930\n| && |44JAA 149\n| && |85888 400\n| && |T5KTK 854\n| &&
|572K7 360\n| && |22439 154\n| && |7K777 746\n| && |38333 90\n| && |K8ATT 63\n| &&
|5J4TJ 361\n| && |9QJ33 97\n| && |Q642J 487\n| && |KTT5Q 173\n| && |58365 936\n| &&
|666J6 355\n| && |55JK2 158\n| && |KA572 33\n| && |99899 952\n| && |78T2T 913\n| &&
|49429 123\n| && |T755T 733\n| && |J8767 308\n| && |AAJTT 751\n| && |44944 866\n| &&
|2A53J 785\n| && |K3434 914\n| && |2KAK2 828\n| && |J8279 658\n| && |K7A32 162\n| &&
|78962 844\n| && |536AK 263\n| && |J555J 777\n| && |8888J 385\n| && |94A4J 369\n| &&
|82Q74 953\n| && |K3KKK 17\n| && |49266 756\n| && |A7378 817\n| && |44QT4 9\n| &&
|99492 246\n| && |A8484 329\n| && |TT36A 972\n| && |22Q2J 598\n| && |J6K66 610\n| &&
|4K73T 309\n| && |6766K 709\n| && |68QJ5 645\n| && |J9599 183\n| && |472Q6 395\n| &&
|4JJ24 719\n| && |3333K 429\n| && |85587 743\n| && |23323 579\n| && |77755 297\n| &&
|QQJT8 482\n| && |53533 465\n| && |6844T 980\n| && |43596 845\n| && |T2T22 731\n| &&
|44KJK 504\n| && |3TTQT 409\n| && |5J554 410\n| && |444Q4 328\n| && |7JK77 153\n| &&
|222QQ 111\n| && |K4443 732\n| && |54445 608\n| && |76659 267\n| && |25352 615\n| &&
|3KKT3 262\n| && |A22J9 694\n| && |4JAT9 961\n| && |TAAJA 282\n| && |4J5T8 900\n| &&
|87787 593\n| && |KQ77K 318\n| && |4TT49 182\n| && |5K3Q2 962\n| && |33K55 368\n| &&
|T8297 839\n| && |5T6AA 795\n| && |37399 423\n| && |5T5J5 466\n| && |55565 664\n| &&
|3Q233 807\n| && |2885J 559\n| && |Q4844 989\n| && |84Q7T 873\n| && |33273 675\n| &&
|3Q943 317\n| && |28868 740\n| && |998J9 583\n| && |Q5Q4Q 48\n| && |444AT 320\n| &&
|4JQJQ 578\n| && |488Q8 392\n| && |J4385 990\n| && |TTTT5 75\n| && |3K336 191\n| &&
|J88AA 662\n| && |Q66K6 278\n| && |J9JJJ 543\n| && |2AA2A 29\n| && |Q7722 23\n| &&
|892JT 393\n| && |KKQJQ 449\n| && |K68J7 569\n| && |A3QJQ 450\n| && |TKAKK 889\n| &&
|266J4 932\n| && |9JJ7A 757\n| && |67667 144\n| && |KTKA7 238\n| && |QQ2Q2 342\n| &&
|Q5T4T 890\n| && |QQQ47 676\n| && |88TTT 555\n| && |QQ87Q 275\n| && |J3T74 566\n| &&
|84848 222\n| && |J2J6Q 304\n| && |9JTJ4 20\n| && |4AAAA 706\n| && |KKKK4 505\n| &&
|56585 225\n| && |TT5AA 745\n| && |86KAQ 6\n| && |A3T74 383\n| && |K44K4 867\n| &&
|44774 905\n| && |84847 159\n| && |Q446Q 378\n| && |QT7TA 765\n| && |63J3Q 671\n| &&
|Q2Q7Q 653\n| && |4J466 187\n| && |4J554 782\n| && |5224Q 942\n| && |492A3 477\n| &&
|4K84Q 335\n| && |QJ4J7 659\n| && |35232 14\n| && |AKKK6 630\n| && |378A6 290\n| &&
|5TJTT 272\n| && |AQJ48 576\n| && |7T83Q 835\n| && |97T65 476\n| && |33J3J 647\n| &&
|KQQK5 112\n| && |QQTQT 133\n| && |633KK 422\n| && |872KT 708\n| && |JKTAA 666\n| &&
|439QK 160\n| && |26626 992\n| && |928K5 106\n| && |22225 742\n| && |AJJ94 351\n| &&
|T3TKK 117\n| && |9999T 34\n| && |88666 524\n| && |JTK86 580\n| && |7KKKA 897\n| &&
|K54K3 595\n| && |J444Q 76\n| && |J6363 997\n| && |A6K8J 858\n| && |9A444 738\n| &&
|7TKT7 821\n| && |44J99 768\n| && |55554 934\n| && |96KJK 987\n| && |J9999 431\n| &&
|63653 462\n| && |AAJAJ 959\n| && |59999 370\n| && |835KJ 387\n| && |T658Q 228\n| &&
|85548 367\n| && |5988Q 198\n| && |33585 460\n| && |AQKK9 321\n| && |AA7K6 74\n| &&
|3K9T9 750\n| && |AA7AA 279\n| && |2A2A2 195\n| && |K85T6 958\n| && |826T4 540\n| &&
|888J2 294\n| && |A65KK 977\n| && |5QQ55 331\n| && |QK3K2 652\n| && |7KQ9Q 695\n| &&
|52552 933\n| && |KKK77 114\n| && |88J33 584\n| && |AQQQQ 507\n| && |A5496 348\n| &&
|TT744 979\n| && |77744 539\n| && |JJ828 607\n| && |JTJ7T 886\n| && |7767K 783\n| &&
|KK2K7 377\n| && |6Q6AA 353\n| && |24K57 838\n| && |4Q378 148\n| && |2A333 725\n| &&
|449T3 531\n| && |J4464 1000\n| && |4Q44A 623\n| && |AA498 413\n| && |JA5AA 345\n| &&
|797A7 813\n| && |462AT 498\n| && |T4T7T 161\n| && |82T82 683\n| && |KK5KK 402\n| &&
|73495 572\n| && |44KAK 747\n| && |88AJ6 735\n| && |A8JAA 571\n| && |64466 27\n| &&
|TA76J 665\n| && |27722 91\n| && |J9JJ9 454\n| && |5A5KK 558\n| && |K52JQ 281\n| &&
|J8JJJ 778\n| && |Q49T6 113\n| && |J9229 621\n| && |66555 82\n| && |K8236 826\n| &&
|A5K32 398\n| && |Q38A2 350\n| && |356QQ 11\n| && |66466 846\n| && |55544 944\n| &&
|35355 156\n| && |5J577 224\n| && |7Q952 143\n| && |3TTTK 711\n| && |63866 589\n| &&
|949KK 960\n| && |6J266 931\n| && |25QK8 407\n| && |9969T 982\n| && |24JJ6 816\n| &&
|J7A95 506\n| && |8J88J 163\n| && |47T48 135\n| && |TTTA2 323\n| && |J44TJ 13\n| &&
|Q6KJ5 499\n| && |8453Q 682\n| && |JTTQT 718\n| && |A424Q 693\n| && |7Q25T 534\n| &&
|668JJ 4\n| && |75T55 461\n| && |KTJTK 754\n| && |8823Q 590\n| && |6T234 791\n| &&
|77K3J 180\n| && |A9965 265\n| && |TTTTK 849\n| && |7Q873 291\n| && |Q5Q7Q 874\n| &&
|48888 641\n| && |6986J 766\n| && |4J8QT 442\n| && |Q99K7 100\n| && |KQKQ3 587\n| &&
|22622 521\n| && |Q49T9 322\n| && |35Q82 554\n| && |TJKA7 213\n| && |2K22K 537\n| &&
|J6K97 288\n| && |3TT9T 32\n| && |QQ5TQ 950\n| && |K68J5 689\n| && |525Q2 804\n| &&
|QKAJ5 819\n| && |434A6 920\n| && |QQ6KK 928\n| && |888K8 996\n| && |KJJKK 427\n| &&
|49J2T 883\n| && |33QQJ 478\n| && |QJTT7 475\n| && |A9K84 790\n| && |A759A 536\n| &&
|QAT62 39\n| && |5A96K 605\n| && |575Q7 668\n| && |83838 570\n| && |T9K9K 438\n| &&
|926K8 301\n| && |A7AA9 202\n| && |889J6 523\n| && |Q56TK 128\n| && |2J496 52\n| &&
|TJ45K 434\n| && |J8555 949\n| && |4T797 927\n| && |42JT2 439\n| && |58AA8 915\n| &&
|T543Q 532\n| && |322J3 700\n| && |QJ733 556\n| && |89A88 420\n| && |J863T 302\n| &&
|9K354 730\n| && |K88K8 710\n| && |KK9JJ 376\n| && |A3Q94 855\n| && |KAJAA 797\n| &&
|K6KKK 260\n| && |AQAQA 880\n| && |43AKA 231\n| && |TK723 703\n| && |A5988 312\n| &&
|K3574 205\n| && |6KKJK 157\n| && |2Q2A7 364\n| && |K8KK3 152\n| && |233JJ 268\n| &&
|8J967 809\n| && |9JKKK 356\n| && |T5TQ5 550\n| && |96269 237\n| && |J44J4 220\n| &&
|84QQ4 81\n| && |A555A 680\n| && |228J8 853\n| && |9K2K9 73\n| && |4K242 998\n| &&
|6676J 921\n| && |J6K88 948\n| && |77A77 975\n| && |7TTT7 421\n| && |3KA8Q 178\n| &&
|T939J 349\n| && |4K78T 336\n| && |33433 164\n| && |K4KK4 969\n| && |9J737 179\n| &&
|Q7Q54 515\n| && |4K444 951\n| && |8822A 729\n| && |44J45 672\n| && |9Q9Q9 203\n| &&
|8257K 229\n| && |2AAA3 221\n| && |9329A 283\n| && |A95QQ 66\n| && |345KJ 923\n| &&
|9J399 425\n| && |TJ826 84\n| && |A82KK 490\n| && |533J3 141\n| && |44434 528\n| &&
|9647K 51\n| && |ATAT3 310\n| && |JT325 93\n| && |95555 92\n| && |J669Q 728\n| &&
|2T32T 327\n| && |44J44 764\n| && |JA4JK 926\n| && |2A779 41\n| && |QKKKQ 602\n| &&
|T4K68 102\n| && |J8666 970\n| && |7Q782 669\n| && |TT2T5 771\n| && |K6T82 758\n| &&
|8AJAJ 266\n| && |AAA93 287\n| && |J22J2 372\n| && |A643T 648\n| && |84679 463\n| &&
|6J555 432\n| && |3J3A3 381\n| && |54TJ3 707\n| && |3Q8Q8 295\n| && |57QQ5 397\n| &&
|J985A 443\n| && |TAT54 399\n| && |6696T 799\n| && |AA2AA 126\n| && |Q55J5 189\n| &&
|9A85K 37\n| && |65JK3 674\n| && |Q83Q3 338\n| && |J9994 519\n| && |T5K5T 352\n| &&
|3393T 870\n| && |T3KJ6 50\n| && |999AQ 973\n| && |28Q8A 872\n| && |63TJA 734\n| &&
|96446 430\n| && |2TTTT 132\n| && |222J2 249\n| && |JAJ37 134\n| && |QTK82 181\n| &&
|89899 480\n| && |7Q777 467\n| && |24TT4 699\n| && |J354A 910\n| && |34AQ3 488\n| &&
|KQ6AQ 373\n| && |K7957 362\n| && |5T53K 510\n| && |6758J 762\n| && |TTK9J 685\n| &&
|4445K 592\n| && |QK8TK 86\n| && |J6649 170\n| && |49399 142\n| && |69486 563\n| &&
|8888Q 527\n| && |4839Q 65\n| && |T4TTJ 859\n| && |83J86 625\n| && |3T33T 634\n| &&
|66K6K 77\n| && |QJJTQ 382\n| && |7J6J6 727\n| && |6T6TT 57\n| && |T555Q 129\n| &&
|77AAA 354\n| && |9Q989 25\n| && |33J33 881\n| && |KA843 334\n| && |AQ876 741\n| &&
|TA5AK 2\n| && |9QQQ4 285\n| && |Q3QQ3 564\n| && |62679 251\n| && |25QKK 798\n| &&
|T3785 343\n| && |6Q836 547\n| && |AK79T 964\n| && |44426 869\n| && |TTTT6 325\n| &&
|TTJTJ 250\n| && |K5558 210\n| && |59569 508\n| && |K9782 391\n| && |75777 359\n| &&
|8364A 892\n| && |6K6KK 264\n| && |KQ7AJ 206\n| && |JT992 649\n| && |48753 85\n| &&
|A4A4A 643\n| && |J6A5K 591\n| && |6JQQ4 67\n| && |94KAK 812\n| && |A7677 613\n| &&
|2K5T3 245\n| && |J3JQJ 895\n| && |T4TT3 293\n| && |3JT3T 796\n| && |84484 773\n| &&
|QJA5J 885\n| && |55A55 772\n| && |6J495 21\n| && |Q4T9J 705\n| && |33QJJ 306\n| &&
|K2KKK 284\n| && |37KQ6 109\n| && |742AA 424\n| && |339J7 384\n| && |4A44A 721\n| &&
|Q6A82 98\n| && |J233Q 789\n| && |66865 899\n| && |4Q44Q 903\n| && |7AJ8J 646\n| &&
|JQTT5 455\n| && |366K9 968\n| && |KK5TK 68\n| && |963Q7 760\n| && |75J7K 542\n| &&
|J34AK 94\n| && |JKKAA 319\n| && |5Q495 938\n| && |5JK55 286\n| && |55888 509\n| &&
|T7JT4 366\n| && |88988 823\n| && |JAA7A 802\n| && |6JJ72 269\n| && |76626 655\n| &&
|J3KKK 879\n| && |74J9J 642\n| && |K623K 617\n| && |9Q9QQ 26\n| && |27K46 822\n| &&
|6KKJJ 545\n| && |656J7 88\n| && |6TT9T 324\n| && |28278 339\n| && |8J885 696\n| &&
|TKTTA 824\n| && |84648 446\n| && |JT2K2 585\n| && |79J92 767\n| && |TTTTA 314\n| &&
|48688 535\n| && |969AK 483\n| && |QKKQ8 12\n| && |7JQ4A 686\n| && |33JJJ 240\n| &&
|34343 850\n| && |KKK55 759\n| && |33886 530\n| && |5K3KJ 898\n| && |TQ34Q 125\n| &&
|T59J6 624\n| && |95949 232\n| && |2T24T 836\n| && |K8J98 514\n| && |2QT22 581\n| &&
|9779J 30\n| && |355Q5 118\n| && |QQQ6Q 146\n| && |667J7 862\n| && |34J2A 177\n| &&
|77AQJ 631\n| && |AAK88 105\n| && |J5J99 912\n| && |K6Q6J 71\n| && |443J3 636\n| &&
|AAATA 230\n| && |JTKTT 45\n| && |75755 981\n| && |K8585 258\n| && |7T47T 660\n| &&
|43TK2 390\n| && |K4Q6J 865\n| && |6A666 702\n| && |4A286 868\n| && |77667 99\n| &&
|T76T7 470\n| && |58TTJ 888\n| && |68648 418\n| && |JJ655 47\n| && |632Q5 248\n| &&
|J64J7 313\n| && |78234 169\n| && |QQ5QJ 717\n| && |7T777 38\n| && |QQJQQ 622\n| &&
|TKKKK 185\n| && |T8JTJ 315\n| && |4QJQ4 697\n| && |Q99T8 503\n| && |T3328 235\n| &&
|QJA2T 244\n| && |Q888T 841\n| && |32434 107\n| && |33739 954\n| && |AKA4A 103\n| &&
|99669 831\n| && |7TKQJ 614\n| && |6QQQJ 116\n| && |34626 787\n| && |88489 637\n| &&
|26262 3\n| && |3Q26Q 209\n| && |QAQJT 96\n| && |37232 929\n| && |6Q934 986\n| &&
|88886 814\n| && |QJ352 253\n| && |88QQ8 596\n| && |67875 214\n| && |7T4J4 562\n| &&
|6JK86 776\n| && |JJJAA 638\n| && |TTTQ9 893\n| && |64667 633\n| && |83888 207\n| &&
|KQQQ2 761\n| && |52A55 61\n| && |AQQJJ 978\n| && |5559Q 698\n| && |QQ88J 940\n| &&
|99QQ5 337\n| && |32222 233\n| && |35375 340\n| && |QA632 124\n| && |QQ7JQ 901\n| &&
|9KKK9 458\n| && |28338 217\n| && |8T699 984\n| && |J92QQ 197\n| && |KAAAA 919\n| &&
|77477 917\n| && |689Q2 852\n| && |4JTJT 784\n| && |7888J 403\n| && |4Q4Q7 104\n| &&
|J7283 502\n| && |K96KK 172\n| && |QA33Q 15\n| && |J9962 415\n| && |K4JA7 834\n| &&
|Q4A4A 626\n| && |JQAAA 218\n| && |T6687 945\n| && |KAKAT 781\n| && |33A3A 516\n| &&
|TQ968 620\n| && |75547 175\n| && |QQQJ8 793\n| && |79245 955\n| && |42422 825\n| &&
|A6A46 603\n| && |22663 501\n| && |24J55 270\n| && |54644 44\n| && |Q33A5 806\n| &&
|82888 1\n| && |99498 832\n| && |QQA66 991\n| && |4T4J8 7\n| && |5AJT4 586\n| &&
|JA9AA 136\n| && |66T76 805\n| && |QQ8KT 788\n| && |4A444 469\n| && |J28K9 406\n| &&
|KKQ6K 64\n| && |AA355 946\n| && |63333 358\n| && |69968 252\n| && |A5AAQ 837\n| &&
|A5465 176\n| && |4TQ83 820\n| && |66656 573\n| && |69652 887\n| && |T46KQ 444\n| &&
|8967A 491\n| && |A7J7J 472\n| && |92KJ6 441\n| && |5A5J7 517\n| && |645J6 371\n| &&
|QA6JT 520\n| && |88J98 486\n| && |9488J 601\n| && |555J5 277\n| && |66QQ6 70\n| &&
|9666K 875\n| && |99559 677\n| && |7K888 827\n| && |QJ524 196\n| && |9KQA9 357\n| &&
|J69J2 165\n| && |626T6 748\n| && |66AK4 678\n| && |K63JJ 101\n| && |36336 909\n| &&
|62J62 688\n| && |77776 786\n| && |TAA69 226\n| && |KAJ22 346\n| && |T4449 489\n| &&
|TAT84 988\n| && |KKKA3 737\n| && |J5K4J 404\n| && |6T666 552\n| && |96853 553\n| &&
|77A6A 426\n| && |6J566 769\n| && |8777T 298\n| && |444AK 654\n| && |555K5 437\n| &&
|KJQT8 716\n| && |4QQQK 457\n| && |2QTK5 541\n| && |TAA3A 863\n| && |88A8A 848\n| &&
|49366 681\n| && |76A92 722\n| && |AAKA8 908\n| && |79JTT 31\n| && |J246K 639\n| &&
|97898 417\n| && |KK8AK 568\n| && |5AA5J 200\n| && |95438 974\n| && |J5KAA 211\n| &&
|KQ955 433\n| && |7J7J7 544\n| && |T6TTA 712\n| && |3AK34 522\n| && |7747K 878\n| &&
|244J2 95\n| && |84822 333\n| && |2TT33 611\n| && |69T8T 408\n| && |69999 19\n| &&
|796QA 594\n| && |A8AA9 495\n| && |KT8Q3 597\n| && |9J9J9 307\n| && |Q85KQ 436\n| &&
|87364 72\n| && |JJ834 130\n| && |6QJ66 965\n| && |Q65T9 604\n| && |9583K 447\n| &&
|66696 10\n| && |AAA42 5\n| && |44Q9Q 80\n| && |88748 60\n| && |Q7Q37 533\n| &&
|8T44T 619\n| && |KQQKQ 967\n| && |64TA7 273\n| && |53359 882\n| && |88T88 957\n| &&
|T9TTT 435\n| && |T642K 473\n| && |28A85 456\n| && |32475 896\n| && |Q743J 560\n| &&
|665Q5 829\n| && |68T37 582\n| && |63A7Q 440\n| && |88887 723\n| && |KA96T 941\n| &&
|99587 925\n| && |KK6AT 87\n| && |45949 618\n| && |45354 108\n| && |AT3JT 884\n| &&
|JJKQQ 296\n| && |3JTQQ 513\n| && |K86A7 299\n| && |4KTTK 239\n| && |94K7T 35\n| &&
|96QT6 448\n| && |J2A7A 924\n| && |5J387 115\n| && |Q22JQ 257\n| && |22J2K 419\n| &&
|K63AQ 774\n| && |JT839 127\n| && |JJ78Q 276\n| && |36Q66 219\n| && |T3Q7Q 983\n| &&
|56445 56\n| && |2A935 661\n| && |AJ335 512\n| && |QTQ6J 428\n| && |QQQ7Q 259\n| &&
|QQQ4Q 139\n| && |44445 690\n| && |85558 628\n| && |TQTJQ 89\n| && |KQ79K 59\n| &&
|AKT36 137\n| && |93763 810\n| && |TT8T4 305\n| && |4J562 204\n| && |4J959 667\n| &&
|7TTAK 811\n| && |77Q7Q 459\n| && |9KK27 40\n| && |Q2KKK 606\n| && |2QQQQ 234\n| &&
|QAA9A 976\n| && |844J8 650\n| && |92252 166\n| && |72648 8\n| && |8293Q 966\n| &&
|33439 701\n| && |52AT2 999\n| && |77333 916\n| && |Q84TA 174\n| && |K26J2 656\n| &&
|99929 937\n| && |5AQQJ 918\n| && |J3993 609\n| && |69AQ5 770\n| && |TJJJQ 453\n| &&
|7KK94 192\n| && |3T7JT 704\n| && |9966J 363\n| && |65644 679\n| && |93939 713\n| &&
|9KQQ9 851\n| && |773Q7 223\n| && |274J6 496\n| && |79999 548\n| && |88T8T 749\n| &&
|34QJQ 481\n| && |64J4A 904\n| && |4QQ54 485\n| && |77JQQ 907\n| && |A6QTA 877\n| &&
|55575 247\n| && |A7248 380\n| && |Q2KA9 55\n| && |QJ797 201\n| && |8245Q 876\n| &&
|82A32 468\n| && |JQQTQ 818\n| && |J73TA 119\n| && |34J96 471\n| && |77J77 150\n| &&
|AJ7KA 464\n| && |4AQ84 379\n| && |293J7 289\n| && |K55Q3 494\n| && |99555 612\n| &&
|44QQQ 451\n| && |Q4J47 394\n| && |5K5Q7 344\n| && |A442A 411\n| && |Q2KT9 151\n| &&
|2J97T 497\n| && |KJT4T 939\n| && |7K598 271\n| && |37838 168\n| && |8558J 714\n| &&
|Q88K8 120\n| && |KKKKJ 18\n| && |22862 330\n| && |JA77A 995\n| && |52J99 801\n| &&
|7TTTT 292\n| && |TKJ2A 902\n| && |88938 388\n| && |3544T 121\n| && |43J63 24\n| &&
|JQ559 138\n| && |98A72 640\n| && |5255J 389\n| && |8Q47Q 891\n| && |QTK53 54\n| &&
|37QK5 167\n| && |Q7J73 53\n| && |TJ753 208\n| && |486Q4 911\n| && |33376 755\n| &&
|5T586 193\n| && |73447 236\n| && |888J3 256\n| && |26T22 574\n| && |A5444 600\n| &&
|QQJQJ 551\n| && |JQQQ2 62\n| && |95A4K 58\n| && |366Q3 985\n| && |66K66 752\n| &&
|5K2J9 511\n| && |AA554 479\n| && |82TAJ 341\n| && |JK82K 856\n| && |AA3A6 311\n| &&
|2K6A6 753\n| && |A3JAA 49\n| && |8J538 800\n| && |8Q35J 840\n| && |23T67 215\n| &&
|22835 670\n| && |949Q9 588\n| && |TJ9KA 922\n| && |94844 414\n| && |J2KA3 492\n| &&
|28878 567\n| && |AAJ94 79\n| && |669KJ 396\n| && |Q5963 726\n| && |T37JJ 830\n| &&
|3QQQQ 792\n| && |2Q95K 736\n| && |7K8KK 963\n| && |8QJ28 28\n| && |5778A 906\n| &&
|TT8T7 83\n| && |44422 186\n| && |TJTTT 857\n| && |AJAAA 405\n| && |KK82K 651\n| &&
|TTTQQ 184\n| && |AA254 227\n| && |6Q666 525\n| && |44428 452\n| && |J5955 744\n| &&
|965QJ 110\n| && |846TT 779\n| && |8JK8K 145\n| && |224T4 935\n| && |43245 864\n| &&
|K66A3 261\n| && |T6993 484\n| && |9TJTT 365\n| && |T5669 803\n| && |63663 644\n| &&
|K44JJ 332\n| && |39369 122\n| && |A57AT 724\n| && |77A2A 561\n| && |TA338 847\n| &&
|66J6J 401\n| && |7779Q 255\n| && |A5AAA 720\n| && |32223 500\n| && |94744 763\n| &&
|T444K 188\n| && |3K3K3 635\n| && |K492K 663\n| && |29292 871\n| && |TT44T 412\n| &&
|JJJJJ 131\n| && |86446 140\n| && |68883 416\n| && |456AT 16\n| && |22595 518\n| &&
|JT28T 386\n| && |A7AJ6 994\n| && |Q5333 565\n| && |AA2A9 739\n| && |4272Q 529\n| &&
|J84T6 242\n| && |AA4Q9 947\n| && |55J35 303\n| && |T4QA9 775\n| && |7JJJA 894\n| &&
|8T778 549\n| && |K59A7 155\n| && |7KK7J 280\n| && |T44JT 971\n| && |667Q7 347\n| &&
|AKAKA 815\n| && |3969J 300\n| && |3TTT3 673\n| && |463J2 316\n| && |KT3KJ 538\n| &&
|72T77 474\n| && |3A9A3 842\n| && |55JKK 627\n| && |AQAKA 843\n| && |K53A8 42\n| &&
|82222 691\n| && |44674 684\n| && |Q8Q8T 216\n| && |28828 274\n| && |773J7 445\n| &&
|TKJK7 147\n| && |28499 861\n| && |82877 43\n| && |J7767 374\n| && |TQA5T 577\n| &&
|K7K77 599\n| && |94QJ5 254\n| && |T3269 575\n| && |5Q776 190\n| && |5AT92 326\n| &&
|KT582 616\n| && |285AA 36\n| && |62AA7 557\n| && |55K57 833\n| && |9TT93 794\n| AT |\n| INTO TABLE result.
  ENDMETHOD.
ENDCLASS.
