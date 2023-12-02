CLASS zcl_day1 DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS part1 IMPORTING use_sample    TYPE abap_bool OPTIONAL
                        RETURNING VALUE(result) TYPE i.

    CLASS-METHODS part2 IMPORTING use_sample    TYPE abap_bool OPTIONAL
                        RETURNING VALUE(result) TYPE i.

  PRIVATE SECTION.
    CLASS-METHODS get_puzzle_sample1 RETURNING VALUE(result) TYPE string_table.
    CLASS-METHODS get_puzzle_sample2 RETURNING VALUE(result) TYPE string_table.
    CLASS-METHODS get_puzzle_input   RETURNING VALUE(result) TYPE string_table.

    CLASS-METHODS get_digit
      IMPORTING !line        TYPE string
                letters      TYPE string_table OPTIONAL
      RETURNING VALUE(digit) TYPE i.
ENDCLASS.


CLASS zcl_day1 IMPLEMENTATION.
  METHOD part1.
    TYPES integer_table TYPE TABLE OF i WITH DEFAULT KEY.

    DATA(lines) = SWITCH string_table( use_sample WHEN abap_true THEN get_puzzle_sample1( ) ELSE get_puzzle_input( ) ).
    DATA(digits) = VALUE integer_table( FOR line IN lines
                                        ( zcl_day1=>get_digit( line ) * 10 + zcl_day1=>get_digit( reverse( line ) ) ) ).
    result = REDUCE i( INIT sum = 0 FOR digit IN digits NEXT sum = sum + digit ).
    WRITE / result.
  ENDMETHOD.

  METHOD part2.
    TYPES integer_table TYPE TABLE OF i WITH DEFAULT KEY.

    DATA(letters_normal) = VALUE string_table( ).
    SPLIT 'one,two,three,four,five,six,seven,eight,nine' AT ',' INTO TABLE letters_normal.
    DATA(letters_reverse) = VALUE string_table( FOR letter IN letters_normal
                                                ( reverse( letter ) ) ).
    DATA(lines) = SWITCH string_table( use_sample WHEN abap_true THEN get_puzzle_sample2( ) ELSE get_puzzle_input( ) ).
    DATA(digits) = VALUE integer_table( FOR line IN lines
                                        ( zcl_day1=>get_digit( line    = line
                                                               letters = letters_normal ) * 10 +
                                          zcl_day1=>get_digit( line    = reverse( line )
                                                               letters = letters_reverse ) ) ).
    result = REDUCE i( INIT sum = 0 FOR digit IN digits NEXT sum = sum + digit ).
    WRITE / result.
  ENDMETHOD.

  METHOD get_digit.
    DATA(line_len) = strlen( line ).
    DATA(line_pos) = 0.
    WHILE line_pos < line_len.
      IF line+line_pos(1) BETWEEN '1' AND '9'.
        digit = CONV i( line+line_pos(1) ).
        RETURN.
      ENDIF.
      LOOP AT letters INTO DATA(letter).
        DATA(letter_len) = strlen( letter ).
        IF line_len < line_pos + letter_len.
          CONTINUE.
        ENDIF.
        IF line+line_pos(letter_len) = letter.
          digit = sy-tabix.
          RETURN.
        ENDIF.
      ENDLOOP.
      line_pos = line_pos + 1.
    ENDWHILE.
  ENDMETHOD.

  METHOD get_puzzle_sample1.
    SPLIT |1abc2,pqr3stu8vwx,a1b2c3d4e5f,treb7uchet|
          AT ',' INTO TABLE result.
  ENDMETHOD.

  METHOD get_puzzle_sample2.
    SPLIT |two1nine,eightwothree,abcone2threexyz,xtwone3four,4nineeightseven2,zoneight234,7pqrstsixteen|
          AT ',' INTO TABLE result.
  ENDMETHOD.

  METHOD get_puzzle_input.
    SPLIT
|qzjggk1one,two2seven7,vszthreetwo6threethree4two3,zcsvvlslqvfive11chhzmdjdgz8vbgldl,jjsmsksvbr77cfdrdseven1zd,947lkkgznlhxseventwo,8twohprsxmz47,five11eight1,seventhree1eightztszfourfivesix,cbcvd9,hg91fourhhpvkrxbn,1mqbdkqxnine817four,btr| &&
|4seventhree7hbkkg,4fivegtbqthreeeight421six,ninefivekd7,9onetwofprmrhmonedb,threemtmjpfzqkdnlpl81one,six7eight5,twonkhnine22fivep9two,qfqtkz9fivetst,rkzxrhvsgonerqqkpf7nined,fivezg8jmf6hrxnhgxxttwoneg,21nine9two2tfmfxjrvkznkjzs,rhcdx54,jhnpkkp5seve| &&
|n,one8xrjsk9rrgkt,nine58,1twohphpl,eight3pfzvrt9msgxtrbdclsix5,874eighttcpzdbrlj,qlxkgtwo9,ninedbvone1sixlnzdccpsixgzrfdnddmtgf,7eightppzmhmpn4bvvxp39sspf,four48rvhnzsnzmjxrl258,342,three2mmqxh391,eight7vcmhfqznbccrvl4onehfqmjone1,6kgchb4xggs75two,| &&
|five6ntbssixvvtvs8spgdxl1six,one7one,27three2seven,rbmgfive4snq,four239threenineeightzrbvbgthree,two4one3,sixcpcthzvczjp725,fjninetwo6,seventwonine7,1twoonepzrjzsdfourdbdrxg1,vzskvvbtjfeight2sltfdnine,oneeightfive3lthns49,cxkqdgrftbhzsnine6,onethre| &&
|esixsix5jsj,43347two7,threexfcvbv9qkthree3,7qbpndqrzdzfjnineznpfrtkrjqthnkrpvcflfr,prcjmkhg9242eightjtcxmljchpchkkftqfk7,four2bdhjzsfctwothree5,1qkhgpms6two,foursixqgeight5b,8eightxtzp,21bcfkqgjndone,five56fivefiveg9six3,seven1fivegrgcmp,prxgtm9thr| &&
|eezfqsvpshjnrhbtthree,2eightsevenonenine2,sevennine8vr,htssttpntwolpghms7dhqzpcssnqtwozxxj,4hggpthreefive,httwone6hhrvkknd,six2r828,four42xhlgfour,8one8,6twoseven8onextcj7zcl,lqx9848,xdsvgtm8672sixsmlndlc2four,8vrvqdrcmx9,one42nine,dstdftnine8three| &&
|7,hhpbcz3,6tdzgbkdjmfourtworfmjnmlqs2three63,5fivejbcjfqjnd34qcjkjvnnkrtwo86,ztkbh8threezjfkcm2eight1six,gpkzlpfq4kghqlzqfkfivenine,gxnlcr6four92,qoneight55five3,brhzqvk6,sevenlzvktjftcvfkvjzn6thlzf,2tnvkdzrtshfzxvzpc,mbndnhq3one9one2one3,six11eigh| &&
|toneightklv,1lrtvfzszkqlcstmztkninenine14llmfive,1four69two8shhmd,five7xtvtlzpsfsz1htsjxzph5,9seven4fcp,fqhbptgthdfnng6zzzksevenbchrtvtwo,two7712two,fdkbn4lhcfqcdjbfiveeight6,foursjlrleight2five,nzfmprckbcdvnzzj4xcpngq6,kczeightwo4fzshkzoneonesixfi| &&
|vegpnnrpsp,nine5fivethree,ninerjkcvrjr8koneseven23,sncnb4gb9,four3five21,8seventwo,pknhg9jql51one4,1threetwo6rfvsgjbhjlcfour,four7fiveseven3fourdqvsnkkdrbrhnfsx,7rcqcbqsfz766,4hdzzzggfzs18eight2twoqmnlcxzxs,x8,eightsixdqcpvsgzndqqone716three,6sixei| &&
|ghtnsmkckmssfive12,7threesixninejrbthreebqpqtl38,five11nine9cljfjk83,qhrgg313jjhzptpvnrjb,mm23,onenineseventhreeseven5thxmgzlxm2,threevhrfjnvv9sevenone,7onehnxssvbgeightsixone5,sixone9sfsix,seven3five6nineleighttwo,6fiveeight3bxtt8,tvtzseven3ljkqmn| &&
|kprmsevenmdnpfour1,twovjjnznn36fourpvjfourk,4zk2slkstxjxhr9,6qzhhzgvpfoureightljcfxcjntwoseven,73p43cqqpjrsrmzgqzhtrl,32fivemxfdldrkrvstffive2,fivethree3eight86,six33rxgscqrpqtkjrqtwonet,3ssmlszjgtd8sixznrvstmbjqjthzkszx27pbsgkvsj,4eightnjvnvd57six| &&
|jtbrthmtlh,3eightsix28,18mnrnlppvxdjg88,qbnmt4fivepbqrlzkd7eight3twonehzh,5xkmvfive8two,72fourpbrsix48tg,8eighttwo28eight,68dvfxsix5trrftjmgsevenslnjvzggnine,zblphhsrhr2nine,7fivethree35ninet,sevensix1cmqgxjdpj3jqct2,5fourtwogrpxkgxvtcfive1sevenjhx| &&
|zb,oneseven9sixone5,four4klsixnbkxmeightfourtwonekmc,2vzknhhhznx4one,kndone4three942lqxdxddfour,vrcmxdgssevenseventwothree9,stxvhlsqb9jccxph8three38kbrxvkr,fjxhcbbczfmt7twoxfmdgxsps,5715threefgtsgrjb,254hnjrpsbbffxmvtjsjstkxkponeljcqhdll,qmvlxjjklm| &&
|khvmmjd7dfkztjvtnqfn,seven34five5mflmvnine6five,jtqdgkv3three,6four1fcmhbpmbknkpxthpcthreesevenonethree,three18frtwo,boneightvlgzbzrqzhrsfvsevenninenine8nqlzrcqslqxkn,7seven6sevenvrlnvqjdsix,hprgnr2hmgnjnvzleighttssseven42seven,fivethreevhscfxqrz42| &&
|sixseventhreefour,9onettcqgvvgcpone,threeseven2sevenpxsjphvdzj51,26onecmkcseven583six,nine3csevenpzhjxssxsix52,2seveneightsixthree2,7vxxfxjkfkeight69,f3714fivedrzst,qvlrmrgdjsdsevenxjf1fournprtlbpngkqt,9four7rd549four,3xrnlfivehsnkzdgmfoursixnineni| &&
|ne,two1onelkqgvceight,four7vbrkrcnine,twotwo8fshnvrzrhgksbf4two,1eighthdnrtpglhk6bfqtjqkgvcpztrf2,93five6hrxc8six,onechldlktgq5xckxbtlhhszjmsjlsttxrncssffh4sccgxjz,fiveninenbkxzqtbqglx69,xpkfldsggg3eightbqtbrfthd,1six1kk54sixnine5,onethreefourfour9| &&
|9threethree,cbpgjltprj5,seveneightfivezrsrseight9,sevenbqpkone7six9,2sixfour9fivehrksb2six,386mfggvhgksmnine1,tlrkxpbnmmcjfzgbh697,8bkksmcbnxsgzsixpv24,four5qtjjcvnjnxfhcblfdgsssqmcqfive,3jppthreezkvjnxptwoonefourjtbxfllqf,sixtffm85ninefour,19seven| &&
|,twocxxzkcv37kleightwod,dncbnpbch1sjjbdnfjqj,twosixjmljjllk67,hggzqspzbllqeightzbckfllhtwoseven9,tvsrsix9ninefivefour5twoneg,5eightwox,zvpkkrs734sj,88threekmzzbfsfxnrztbgkqseven5ltfcmzpxxvb,fivesix62twonine,xrcssevenp2,seven6eightjkfqnrkntmgfgccrvj| &&
|cninemsix8,jcnnjbttlf7522fqxpcvd4sjq7,dvqlsgd1szspcmfhmptnphk32five,93nqrmmbfbhvhkbjxcj6pzjb,4fourp,35522,1462,four5eightsevenxcqsevenqxxp,2pmthree,five73fivelkcfbxttlkxgqrq,7hcjtq,3c2,stmtgdlxz9mm13mdkpn3fqmfnghmn,fivellbhrntmseven7vltvqrclblsxg,n| &&
|inebrfbxcrsgxhmn61kndonegfbfrdseven,xbq5two9,hrmsgltrlllrrnd3seven,fivexfs9,6eightqvqdpxltsrldc6xrxjpdz14qxfnsvbzgj,sixfourfivershtwo9dfvnqkpzczpxgsfsgb2,8sevenfive9twoonevmjcpklsvmsixbghd,sixgcdjdhgglhdv5,dmxvdp62g6six,fsseven8fcqkl,6ninexkgqsglbn| &&
|inedcgtmsp4qhngtvs1,62nine2threesix,m8rpxcjgcvtseven7five4,kxx13,plptcvbzh3fourfiveczxdrckjbg8twoninecrhfkll,8six8,xlvngzxlrnhh3fiverf3,vk3eight78,eightone97six3jdztsg,4mmdsmdllrkld,twotdnlkbdqmqtwo1foursevenxbbtrfjztbthree,fivetzszgzbvtwoone6,snin| &&
|e52bmvkdkeight9,fourponelvrncjhkmv5,onexvnine2xtjkjvmhpvkzrzczthree3two,5xbdg5klzcxxfsix,seveneight17,gnxptlnhfr32,vcnfhslqb1nine,sixfour7oneights,sninefour9three,ddhmpjnnchkkc1hlb,mzvsgpbp21four468,four8s3kfqhlxfeightkjbfv,83threexgsvhrnvfive,dhqt| &&
|dfcl4sbvthreeckqr,1nineptcsbtckgrgeightjjcn82xtkzmjhnsb,bprldcvpqx94onezmcgntk6,816,sixone9nineeightclrvctwojfjskplgtx,twofourpqkvbs8kgtdrsqd,hgqxn9psdeightpmpqtrzpncxx,lvk1nine9,twothree7eightqqhzbhbmntpknmnvckfourhbsdqlzs,nine61one,759fkfnzgjkhvz| &&
|tssv39,gfhnrfone16eight,threepqxzpeighttwoseventgvjvgl1,dgthhx1,shdffcqfxpvpfsv4hmknbfnvmt5seven,sixsevenkgdvdqbp7tfqjpjfive4,ngvqc6three88nlnhzjndss7two,sroneight8,77seven114sixgzrnlh6,8fourfive7two1,nccsjq6twothree14vzjnnrjbxjhkdcvmvzzc,six4hxrjd| &&
|ztttqssvhslpqjlxtqhgtqf,five4dlmdtsdxrg73one8eight,1sevensevenhb,vbnmfr3knfncgtseven,8sceightnine,x3two,hjhknjmbhnpsl1six2six5,ninenine4b74eightthreefive,twofive5fhnnsq32mdflndlft7,threesix7,sixfivefivesixthreeseven84,ghzgpxjqj4threeone2153,3threef| &&
|ive5,four5one59fivesevenzlpgnmjtqh,47jznslzfdgklndmpcjdksrqfg4threefourgctxp,kjk9pxsdgsheight6,four6mbskcnpgkb,48nine,3ninekncjthtk9rbnmdmdrhrksevenpcpnnk,jgqqvd71twoqmzr,fr8six93nine3,29sevenppgrb3pqbbrthreeseven,onetwo3fivethree,2nineninefourpstb| &&
|72,one6two,971,nine4foureight1dsftjdrq,msgbxbbtb3pnlnjsixthreefoureightwobm,69mqfclsqhss,one166eightbtchdlppone,zpg29lnksjlsxqmtwo1k,76ninetwo56,fourbpmgdl38qmnfrlntxzthree7,jjxvqchjzscxq1vfmjvklg,psixseven57,qxgqsfhf54,zcjshnthree45hhpdfninevhrlhz| &&
|xthree,sgkztgmsbs7ndtvpm8twofive7,ntwonemktccptwotwoseven4one,2sixnine4nine,onelzjlkttzqthree34threethreeeighthrfzgzzbr,2eightxktjp6tmlrlmkpbcz,four974,9ngnj,7fjrh9,2fxpcdjcnm1two,ninerpbnjfbfourtwoone61lndjmzqfrj,8vklltm1pthreedtp,onemfmhgfjcbptwo| &&
|six31,lrzvkvvffvlfjgzcxgqpf769fvppsmfivegktg,five7sevennine,6vjcfhkf2bgjknzlfour,nine7eightwoczx,gccdbvjlzeightfour4fcvxdqg,hsvjdlhqxmq1575two,8rtlptb5xjptxk,4seven3hcpnqhzz3xxkjzltgjmpnmthree,threejlsninefour12,bg915kmgdfzmqp4,four2lsix8zjhmkq,tmj| &&
|twonesevenktwophvrsqpntwobg9,ht8fhqqsvzpg12,fgbd11eight7486,vzrtrfiveoneeightsixseven8xdklgqj,ninejg34,2zlrpcf,318fbtmxdlnbr7sngkjbzt,hgneightwogrfkcxpthree98threefourxshxvpbone,ninesix6onekzffggjtvh3ninethree,5vn,7dctbvpm,cvvpszdheight6,sjtlseven4| &&
|2threemsdfnfive,km6zcxpzlhmd,3sixbfs,clkpxpmtrthree4one,bthreethree42eightqzjfnc,v955onezltllqmk,vrqkjpr1rkjmljn1fourninezpkfvvqsldxzlnl,sixnfivetchsccgr5s7fourgnsxqg,hqkgndxmdthree5npf76seven,six7grnnxhgg4,jthree432mvppjpbk2vcrnthzzc,9seventwo48jp| &&
|vvkgf,86jhtmsftsmkxpjgjvdqjchpmt,kmpqfnvstncrxq3hpbk,hfbknxzrmqlzsdk79,jxdlfivemplvrsl9eight,931,hcfssghtwonsjcdhbnfx42,49sixeight,vpc2eight7two,3sixlqdzbf2nine54five,twoone92threenphjgdlztslfourvlfpbdqpvh,eight1347eightdhfdqnp,3fiveone761,9hbgljt,| &&
|sixlfivet9qtsvhlfour,six35two,2one3vhzfxjp68,seventnqpllcxcxbzkznqs24,1twoeightsix,five2sixnine975ffjtdslzvhmgzxmjp,four53eight,6fivesevensixbnpbqvfvkc91kkcth,4hdfvjblpmhhgvssmzhgtspjc,xtftqpvbfbzlgmrrvmctwo4cqhrdsqjnjone,hbqllzxhz5t,qrxoneight3six| &&
|lcsldhone,hjdsevenqffone5threeljqpdxxxs,one79hdbrttptvpfoursix9seven,ninetwoczt18threenine4vlcrcnmxr,h9fourseven8kbbfkxpmfll,ztrqpd88fjfive,1onetwoxprmpthreevbjmjzqgcms1one,9qgpzftfq,lpsninevdxdxpfbbm2,41hdnzrrv7,vhdbnkjhxbsmsix5zppbcrhhv,fourlnfiv| &&
|e19,threedjjkssbhsevensevenfive8vzsrprh3fcnlz,zkgp95znpqjdgtsclscf6,9z3,fnrkmtkz4,sixfour1qpzzzrtcneight,67kseven,4lrqrhone,vxqtbgltwosptqhznnine7,1tqcxmxhtdljmsklfzfb9,eight2mqcmcxqzdjnpddqjptwocznvhzone,g7,1gzmnlvrmlfscdbnine,18qjtq6nine,three9si| &&
|x85four,vrhfclpzteightdvjdsjhseventhree2,bblhvdcjfqgfive6ninenine7,8nrjbqnfkfiveqhbbc7lfjhsfour7,cjkphrvninefour2nine6,kscvmlxssevenonelqdrtcqcqthree3two4,1333,sfrzr9,onez2eight7,tbsxcmgmnb636nfcdsbj,2vvqhrczfnmngbpgtsnlfourfiveqzk,7gsskljk6bmgstmp| &&
|tsixcdjzm61jzgxbjrtl,fourvfph31,tpzfive8,fiveseven62,six55sevenvrxdeightnine4,pffbhkpvhtmsr3,4eightninemzbkzmkd,jntwo4twofdgrl3fgtqmnfnz,6threetvzjn8,5kvc82tksgsxvm,mrtwone3seventhree,8six7gxgfmpkheightxxqbshrn,fivevtbcgzmvrdkxnssneight2three,fives| &&
|even2ndpkqtxxkninesix,one7jslcxd,7vfjpjfsxgcfbgtsbcnfjfvdql,35ninexmssjbzvflcsgjlgf4,jfnknfxsrp6hpmnclmone6hzpnfnbhsfive9,jhmmvkspvdltqcmqlqmbsevengsvfvxhct7vnjntseven,lzml9ninerbnpl3ltsclmjvfour,fourpzsbmv2oneeightseven,fourcptgpkm5onepkbpbmzhsnbf| &&
|tflkthreeznnjkrmqkp,vflqthspgjrxnvvone9fourfour,two4jtcqdrbmfs2six,1five2seven,seveneight8threerspnbsxhjkeightnblhlj,cxnhsl6three,eight96nineone1oneone,twotwo5ffngqkkjc,sixnine9ptxjjbhhpxmxllvd,69tkdpg,tgrtrd4,7xj99,6kjgvlfivedfourseven,sixjvbqzs9,| &&
|1336threeseven,3mzfgkcgrkm668,eight639five,zzg25s2mccdfrfsthreeklsqnbgpzbjmgqlntc,np9twofive57four,nrkxxt9mbxfnbrjvfzf,55gfl,five4ninepnpdrfqonepblsnm1,2svkthgrhgrkjjvcxxgjjlnm,3758rn6,rghbnfjdz6kj,brnfvpdxrkhfsql216seven,xchkrlrn5rqfcgznxjnfour4hp| &&
|b,three658,72sevensix,6four569rmcnhcqb6three,fourfoursix8eightqkpvbns2,sixh6fourfive,465,8oneightmx,dkdnrtqxhx6,m13oneonethreeldjsbrrvbg,5tqvlxnfournddkxcfchr3,ninefive418lfgb32,cfjbm18,eight6jdgnxxmgg,boneight2seven1,vltwone3eight2one,five1xf1four| &&
|six,ninecgznbgcrfseven8hkqtwo,vttwone6tjnftjsmkb,sixdfthkdcq84chsrtwofdjm,hgtvtqbgchlntttzht34twojpjzqh17,6qqpsnkdscgzvplqpdqkbmtv,eightjbone3cpfvrrpvjeight,9twondldz,974,2jtnd7oneccdhldpghxjp,54fkqhzjgssixtkhvtmkggtpgpn,four7twosixninelmmhzttthtpr| &&
|gd,qkjtzllg7mhvhrdmhlvcjxkqlvplfeightk,xcndxmmqnj6bzhkx,m9one,nzcdtnk8one,onesevenvspvtnlx829one,32fbfbpblxjlsn,7tkgxjdk598xbkxzbt1xqgzppfcrh,zbffthreexqgtzpeight11csbcvrdsdnjxrf,twonine6sixnine,sqlzbx8llrvtzmgdjfrtvjxctp,5nine95nineonethree8,three| &&
|814fourb5eight,tcgrxfxjqthreemdzj1,kpfbjlftxzcvqjmbtbjhzsnhknlcrdntseven8,8572xrjm9bzrnzz,klkdgszqphbdt4,seven69,nineseventwosixseven6fourone,hkmhpdlxrxtbljnlq6twovszpngfdx5dpktd,nfcxsr5eight63one,8eighttwonine5five7eightwokv,4nkv,6klbcjh9rnhvrznrt| &&
|vkktnhone,597twoseven,xlrfzngpffhjc18,nine57seven3xfhs,377,fivefourcxdfgbtnhmscdlsrnnljvgjlthree1f,4hsgqrzthtk,3ninez24,k9qgqsbbqdsj44tr,djcsxdmd6jrgtmxpk5onegrljnflbhmnnx,sxxrhpkpclbjms3jq,8ngmpfiveoneninerpbscdgjxztkzldcjbrk,637zbrfpsvhj2hzmvx,4e| &&
|ight6chc6,5one9nine,7sevengqrqztfvmhkqnjveightl2twovtgdlhv,twosixeighteightmm62,zlbtcjgninevbctrmsqkqkkjmvcfthnfvnl4,fivesjmgr7two,twotwofivexmsqvjv6four,7fiveeightsixnine,ptkdvqjbniner3five6,68threepkzgtdhmmznine,5jhmzcznnppzpzvmtmn,onethree2nine,| &&
|9six9,fivek4qhqpdd,ninexqrfqddhsix96eight,one1nxzzlj,four6gjkhkmqvq3jn,6scthreedtsqfzdjdpb614,77tqrbpsrkvvf,7ncjgtb854,threeggknmtwofour9kjlnfkhfive,t5trbxmkss17qvbdbl,jjftkk5,xqkxrsevennrlqqmcdtwo6srsxdmqffx,3six4,bssbzmgdvs9qnsfznvone8seventfx4,f| &&
|iveckftrzxhmtwobrlgzeightkscfxzqqvm3five,pngggbvtpsfkjcnine18one,zkgg9sevensixhlxb3,gxxgrmqfbrsvm3xdpzqzhjthreefivemz,9sixshcpfivetblntkvqrfcrqbgxcvgzxdq4,1prnmqrteight9three6twozvbmhttzqzhjmxxg,191mjpnddq,4gtddmzprpvgrgbczcxbz,2onesevensixbmsmstbq| &&
|eight9dxtjkndsz,mtwoneeightmdseventwo24qn,two69bmvplcfhgxqxzbnb32,282seventwo1582,19cmqgjn,8ninesxkxtjbmsssevenmtwoptlsx3,5ninefourpc68eightonefour,nineoneseven3four7,83fivevlndzxsix4njnine,4ninengdkgtt4eight,threenine1,461q583,37mtppzmdtonedfrgxxr| &&
|,dbkqbcpgjgonejbrsdvgfmgftwo8,four52bnine6,17,9mmjzvlgnk6,1three3twonett,123threesixklzxonesix,two5ninebcsrkvldtkfseventx14oneightt,eightscsbpjfvzqqzvphgqb5fivermgpnztwo,zlvgbkztbzbbrfive9jqp,eightphzrnbdxshhhkvtv8,mqbqlznsr6,87twobrcxzxgrjqs97pskf| &&
|our,fivecthreekfrmsjvcmlbrcjxjf8four,vgscjjrxtwo6llhdnsevenpb,jrkrbndlphnnfvstthree6ninespchtjzht,flcffqpthznrhmxklztqtdqhone2,2811fourseveneighttwokqsfzvgn,8nvrdhmlnrjqsixpjdbrfrp,thnpqfntttmbbjeightfourxgcone4,5leightkvsjfjttxlrpnmjxzxsevenlhc,ei| &&
|ghtqrqvtcclqfive42,5threesix,qrpfive2mlhgctblhns6sixglnllttvdtwonekls,6six8two,4fourninerrppmzxlfdsixbzvdjljsx4,rjfpktwo7nndlnmsixxtbngv,lpgfs9eight12krtktzsix9four,3one1x,pjnvpbbb3,5nine1ninejxccxrrcdf4,gdnmpnineldhxrtpxbfn8zkmcpgpz4,r821sixxktbpn| &&
|cp,7glxnlfrvlqgkfour,8three28,fourtwo3twopllxrjtcthree4,txhrhxpbg6,psfrrdvdglrgb9,nfjnshb4seven764xmrkhfgpgtsmsix,2vflvfgkcktqlqrktkx3eight8h,hmzhxctkv8tftvzxkoneightdb,cnklbqdseven6kdrvbjthreeone48fiveeightwoj,sevenfouronetwo5323,tworpfmhd12,tlcon| &&
|eightjcktcngts1eightmxnsd6qgzlvrg22,klrpbs2jxmfdhnzmbtwoqmjfive,mdzptfm94mqlscksrmh,spkzfm9six2zjgmpbm1vlktblxqnn,blfxjrrcjx4four84xb6,bbsbpgskffourrfbhgblhvxlhxbms3,lhgtjmone6878,qvlvtwosevenxchqcfivefjbgvgstptbv5,eightff6fhl6,three3vsix1dxtmtwo,7| &&
|9vrsng6eightnblbrhkbk63,nineqlxxvpxvzgsdhsix6,kpjsvdlrfg2drhmqtthreenineseven9six,3nlrkddlvlslnrms,8b3foursixrjrd,7gpjclsfljhnndseven2twonine,cxxtx79onetwokgdbh,bfllxk5t,42fivefivemtcnmftwom,dsrfcc2rjb1nknjlfone,1onethreejnrgmfzbeight277,rxhrjb189n| &&
|ine,onegd6threeone,spcrbvcdgkgtkeight4fourj2ninekfjg,leightwo54dgvslxlmr49drfcpkxglt,fv72xkkqltqfour,one95gcspknineonejbxeightsix,7onetwothree47,twotwo8,9pprfftptwok,two85,cppthree136ljvgmzjsix,twoppqninejtjlnzveight2,4mdnrggvjq7jxst59,twotwoone6xj| &&
|sxdtmpvl,six4flbq,seven3three4jskfivesix3zjbnktkb,fourzzg8four31twogrsbjmhdj,hrbcmsqq2sixsix,one87fourtwoqshfntzqmfourfdkg2,8sixsevenfjsgxeightoneseven6,sixgkmhdprrsdcnrp6,rfleightwo7ctrrfourjszmgsbxdsevenfive48,fpcktkstbxclhttfmdjmqgspbdpt5six,six| &&
|3stptnfbrnrfivekxntrsnnrf,qqnmvdnp7nine9bnkqkxglk5,fninepczvnine6,fivesixthree1foursevendvsdrlrxnjsnlbchs,ninetwo4eightnine,fiveninepcsdhmvtvrzvctd5gcshznfsppbphhtcpeightwob,4jmlqvvrndnine8n9,six8tjgm2vnine,nbf1zqdfrddsfsseven1sixznpcfour,1nine8gj7| &&
|8vhphqf8five,3sixonegthreeninepc18,gsznrcseven4,927four13h,rvzdfpgbdztvhd4two,seven4qnr,six1eight,9lkkb,3seven92ntrbtjggtrcrnffst,xhcpcdmfl5,fiverpngvmzbxrqbtv49qhctgpcmlmbqhzsix,sevensix82fivexhrdfgrbdpp7,lkloneighttwo4dfour8eight,four2threen2mpcq| &&
|mfourrspvlbeightwobb,scqg125htncplb,32shmcone31fourxn,3583,four5zzfphtvjrmmfgfzq4,1one9one,nine9fourmvcfshnbonesevengxlhlmvghsltxhxzg,65hlhzm4brnine,jkkpthree6,zpjkstn72rjjskdcgtwo4three2,gvz73fourjzzbxmf6,662nqsjsxzf7threesix,three9sixfive8pxdktml| &&
|qgchrfpdjpdv7four,19hsvtrpngkqvtrgcntbeightwovfp,zsgeightwo92foursevenonefive,fourthreexcztqhqtmd1sxzqtlhkvnmhcrgthree,dthftwocsnkrjrkkeight8oneqzfxfrxh,36414lxhkhtm,cqjxdlx9two578npkbx,2nine7eightvn8hzcxscgrm,seven3shxcpfdzhmnine6eightp85,pmjfklpr| &&
|vxmfbgthreeeightpkdnskthrkmjmdnpgztqllbrdvt8,7kdrjsrhxljmvqdrdgtcbone636fourone,892,83jkvnxmcsixseven25csxd,13zzrplcqhxktbxkpkhdgb,cgclnmkl9,twotwo1eight,seven23361,72onepmvnzbnjnhv3seven9,threeqmxcpvmhbpvtlvcponedlpcvlqhthree2,vjszmfour69scgz,ldlq| &&
|dbsxb2kzpq,four77threeone1,lglpdjdjrl8seven9,63nineeight,xgg9xhthjft5,qzgk7sixlhc3sixzkqlrhsixnfl,7fourjpmhfclbklmqj,twofive7twothreercdqdjx,2clvxxknzjdsevensixllczroneqxrqm,mcdghvnbvdmqtbnbbvm8sxdpztffkkl,17seven,gj4seven74,pdkhqcrkkpshxgxbxbq3vse| &&
|venvpgxggk,1six7onelhvfffpdkgpgggrk,46jtwonen,4eightsix6hscxf,j8gs5seven,4qntv5two3,pflzqzrxkfive5fourninefrpp9six,seven18,6eighteightthreeeightjltcgqfpttwo,eight6five,tmz9,jpseven4,smnpnlvcfqsdjhs94,pmsseven7prmvp,nkdeighthxxbbvptwoonefive4one,zst| &&
|7cxhnlbgcqfive77xmknmnjcdcbkbrctdj,eightsixjsevenplzkx34jfctccmdbt,kmkzsixthree84,tjpn5xzrktqhlpmeight,vxp6onetwofourfive,meightwoninesevenzdtltdseven7pcgkqgcpsjbbqlseven1,two28tnkxzldhfour6tbtctxsjone,2sevenmkmcrlkhfivertcknzkrtwo6,rthree3seven,1f| &&
|ivebxkhzcdxsixqxldjmhhmlfivehhscj,sixeight2vjfsgrrpqkrkbxmqcntq3eight,fbpsgsgnpthreeb5two4,9fxqxkrrs1qcqct,lg4onetwodkgd9,njszseven55foursix,sevenone8,four8sixvrtzgzbhgone2,threeonetwo227,tbfourrkmclvrjzd2bvf6,27ttkxsqr,xzjf8sixrxdzzn,9qtmt6eightsv| &&
|tcmtkcqcqsxfn9jtpzr,twodhmprpfvcfour747,375jrn,cpvdponeklkpmsqslq9,ttzvkqrjsqgbztzqrvk7ldthree35djbdgh,9lcfxtftnhseven1nine,6bthreecfptdcfsf65,eightnine6nrrpsbqgggflnp91,mslqqsnjlhqdffndcnlcttjmfeightfive8nine,kvfkrt7pkthreethreegt,ninez45fourf,fiv| &&
|efourlscfour1fbpone,8zqdqtzt6bv1fourtwo,lzszbvchjdgz93nine,mtflpsmqm74two8,7sjqprggnzone1,2ncl5gzvnrtgfgp6fourjrbnnmpmhthree,pbfxkfsone5qnlvplzseven4,gkzmtz5jgsldqgl7mtbft4lkmkpvkfive,7lskftknzrtninexthhsnljms,vzrlnsjqz8531three272,seven18bbnd,1hqm| &&
|vhfbgff9nhlbfpqlsf,four2eightseven,fournine4gzjjfgdd,four34rlcmzmzhdmn,knprzpv5four9onetwonineeight,eightrtqcdnsgbbcxgzqtkscbpvnjzs49three,threethree82onezbqjzfxrqkkz8,6vtqkkf,eightsix73,42446eightsixsix,11threesix,5ninenine7seventhree,43seveneight| &&
|58six2eight,szclshzxqq3,29hsl21threevx5,gbxpeight1,7two7four7six,7hcnfclhcfk5,fiveninen5five4,eight11threethreeeight,62lbhqrzbblz,8four6,seveneight8six4,hlknnfkqfive6one9,nmeight8,two98zsevennpjsllnpbkd,4t,j94662seven,two8one96fivenineqd,7seven7nin| &&
|e9s,nineninepgbbrxsdfzsfkrmsjmdrc6khkghxtjcmcjsrk,bqppgvgfour8onedlkzjkfzsbnksixnine,82twojxlgvlrvlmone,mhjh4fttnqjkcteight6eight1blqbn5,14bprmfvssfqnine18,threesixmzsbjdkzrgseventwosix89j,1knlhqgvprseven39,5oneseven,mctqcpseven1msrtlkdtwo2,2threet| &&
|wog3jdvxvxmrjtwo,twotccrchvh9fnxfouronefive6,hdldjzkj26,43kxqcjpkbczcxcfr4nrfpxxnp,mmxvfrpfive3,lcvslljqsss5six84seven,84nine2sevenfivezd3,5ninefxhdvthqninehzksqfgrgtone16,three5533fivexqfm,5fourfive4,fourldkdvvnrbrseven73mngqjf,bpsix4ninetzscrgq,j| &&
|beightwoninemsfcfzrsqtwop5eight69five,sixeightfourgthreegg8,6twonine8fourvdtk,1fivethreetscbjltkmpkjrkbssxnhnsks3,rpcgsqtxqvtwoonetwo4four,one7one3fzmfivethree,mkqzfhhxfive7,sixsix5oneeightsix,l9fourfq,n6seven61eightfoursbcxl,six5gk,nfthreefour88,f| &&
|our265sevenknmlxdxmqpsszznrz,1gqbjbhmghgqdjxxppfhtlnine,bvhvvhmq3fivethree3sixmfgf,vqgnqspseven66qlbgtzqjdxxxjmxmqr,4sevenfive6nine45,htxpdcjfbfour5939mnhqsqcvn,qvqgppfvrktjncgkfshzvhcxfzvtvgtwo37two,foursixzsgx8eight,knxqh1jfskmzqfone,zxq998521jnp| &&
|cvhll,3fivebsonefournine2eight1,kcbcvone6six,four65fourlgzxone,dclkbndljtxrmltrbznine5,bd1qjqhlgftrgsevensevenseven2sglrmx,grpdgfourpjzfourone75qtknl,nine66,twomxqflmbjg7,foursix2threeseven,36three2hvmgbqd,two8vlqnpone3oneninesix,5nine3r9,sevenvpcj| &&
|qtnzdpcscgrgdmghqhpgkninebvbpcv5six1,fivemrzsixpzxvrpseven3rseven1,vqlrmnxnpvlpmeightzmvthgc43,pvttbbzvhfourninekptxsix8three93,hdpkd2h77fourtsjlqp,kgnrsfrmt3tddtzxcdlheight53dfk,z1rqjkp,8prcvdbhvpl4three,rgmtnbmsf9threenfz8,fivesvdn9seven7one99,se| &&
|ven6tnqqkpzj,threeseven9,1kkjfsgfmseventhree,ninesixlqpkvhzntwo6two8bplfhg,25tx7seven5,14vrsdbpftdxfivefivefourtjdmgvblmfjjdjd6,5pntcmsixfivesix4,sixsixvcnzxbxkfour1fiveeight,spjrlfppdsixnvr3tlxcjvtgbjqrszvxv,9five9gnrqdhbhbbsj,sevenjqgdmdzsix4pzpl| &&
|gfzlmltllk1,nmjdzlseven24one8pqqfsrkhb53,seven1four,1gfbqptlvmzgvqrhtthreesevenrxjdslrfdzhx,ddnine5,zbqrvctj5,seven354ftrznzcqx41eight3eightwonsj,three989pvsqhhzvxnine,ktoneight477mkhkjzsbvninefjfive4,85foursixsix,8bcnkh3tcqhneightktlpdmzpjdksjpfon| &&
|eightqm,eight68dlvgjb8bbchjlxzvf,nine1nzcdvfgm,1eight1sdjnfpq,htninefiveeighteight8,gtwo5,9fournhpb33,mqxsfjfive6nine2,gchkthf2,vkd6pmvhbbphtfsjpllvkp,llrfcqczjldmlvvrxeightnvjgkqblgj7six,nine2qb,pqknhcqr54onefourfive2,qthree58,9dnkqgjeighttcbbctlg| &&
|df,8fv5,8fp5xghphxrq6fourbfninefive,nine9sixkqdhvpqeight,qzssjfkv8nrlnx26,413rqbqmqlprthree8br,jzlsrkcsrlfkccslrfrgnq147plpcxrtwo,7twosixone6threedcct6,zhhhr55,5jjzqlpjm,ninetwo1,kskmzfhscm4one,zdrjcmlxcx4mtvsltkm711bncbfnc3ngkhvzt,1six9,3sixtwo9,x| &&
|qvsixonexdkvxpkpqhlrone93,7sevenonevxlcgsfjgbjfztjxjljnbmb5prh,6zbrlxhxr1fourfivegfhnjscnine,5gzeight,twofourbsix17,fcrzbninenine3,qpksmzv5,8kjkmvrggzglpmnnzcmthree,gjbfour7five,eight4eightnine,1onekbsjqjjhtwo,4zxrtfz,jcjlqxfbnvghf1,two2seventhreen| &&
|inefive,6twoclrbkh6nine4,mnrrtf2fiveseven9xlflf,42drsxctvqsix,2six71sixfourtwo,5seven2eight,fhtsxjjnztwovqmxqtlxd1,ttxqr9481,6five8sevenfour2,mjmlgn7seven5,threefive4dzlkfone19ndpxxzjz5,ggpdsnrqtxxt1hpshzkpfhb,91jdrmgzt68pnf,mdtmqvtz9sevenx8twoner,| &&
|sckzbprzktwonine31bkmtbhmcs,fgvjgx5one7hctftvmbvk,fjlxdhqxn6ninetwoxthcbhmxnine9zzcfqbsxqk,43fourthreesjldzsonesix3ndm,8twofivexpvdjljffpcnbjtkninefive,hfbcbhbxgzjqjspxlpnbppjsfcvqvkgxd22,ninezzrg4,4hfkdjkgdfsix,5onefive2,94crrdpjlzztjb6,sixktcznlm| &&
|ccmb8,hgpxpvphr589d,mvsqtsks2772flfkgzd,7ninefivesvglcxk,2knkmjqkpt8gfzvklcpseven7five,two1onetwothree,three3sevenmdhvb,jrmzfnvvhbfour297,ninebkcpfkzdone1,11eighteightkdmmzth,8bnhlskcvtrnpf43jcfhfxf,134geight,5kfmjnseven3two3,seven3four4onebdzznjng| &&
|qbqg,fpxmmbthreeninethreefour3six,9twoz83jxjt,dnpqsmzvlzsppf46,five8onexsgnxtdtwonecl,8gpbddqqpnq1onetxmhshjdpmnine,dhqft2three8twosixppsdxrxrzfb,1xjnzbspfournseven,cjcfkzfive45zjkrlvnz8,sixrzmqrkkd5fqqf,sixkxtpcjmrmvvqjdgfttd6,threehpbsevenffnqgdj| &&
|cftjkdjhhk7dvzmkmqthreefflb,6npp7fivebghnnxnqjxhhxfdqpsixfour,ffour87fqrvqxqlqrrk,6ninerzksfbszmqnvgmtqonesixjzsf,sevenszl3lkqqfhlrdmkxgggvmkb,5c1,vrxbfckfz7qlfrnggsbdfive6glhk62three,7eightfiveeightrdnhfnqeight5,5threethreerdlsfdsvggzbonecxqzqdvxc| &&
|qtqbg1,gttsix2567|
          AT ',' INTO TABLE result.
  ENDMETHOD.
ENDCLASS.
