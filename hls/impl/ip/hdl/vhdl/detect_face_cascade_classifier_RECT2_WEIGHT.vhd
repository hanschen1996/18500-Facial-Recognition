-- ==============================================================
-- File generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2016.2
-- Copyright (C) 1986-2016 Xilinx, Inc. All Rights Reserved.
-- 
-- ==============================================================

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity detect_face_cascade_classifier_RECT2_WEIGHT_rom is 
    generic(
             dwidth     : integer := 9; 
             awidth     : integer := 12; 
             mem_size    : integer := 2913
    ); 
    port (
          addr0      : in std_logic_vector(awidth-1 downto 0); 
          ce0       : in std_logic; 
          q0         : out std_logic_vector(dwidth-1 downto 0);
          clk       : in std_logic
    ); 
end entity; 


architecture rtl of detect_face_cascade_classifier_RECT2_WEIGHT_rom is 

signal addr0_tmp : std_logic_vector(awidth-1 downto 0); 
type mem_array is array (0 to mem_size-1) of std_logic_vector (dwidth-1 downto 0); 
signal mem : mem_array := (
    0 to 3=> "110000000", 4 to 8=> "100000000", 9 to 13=> "110000000", 14 => "100000000", 
    15 to 18=> "110000000", 19 => "100000000", 20 to 23=> "110000000", 24 => "100000000", 
    25 => "110000000", 26 to 27=> "100000000", 28 => "110000000", 29 => "100000000", 
    30 to 31=> "110000000", 32 to 33=> "100000000", 34 => "110000000", 35 => "100000000", 
    36 => "110000000", 37 to 38=> "100000000", 39 => "110000000", 40 to 41=> "100000000", 
    42 to 43=> "110000000", 44 => "100000000", 45 => "110000000", 46 to 50=> "100000000", 
    51 to 55=> "110000000", 56 to 58=> "100000000", 59 to 60=> "110000000", 61 to 62=> "100000000", 
    63 => "110000000", 64 => "100000000", 65 to 66=> "110000000", 67 to 70=> "100000000", 
    71 to 74=> "110000000", 75 to 76=> "100000000", 77 to 86=> "110000000", 87 => "100000000", 
    88 => "110000000", 89 => "100000000", 90 => "110000000", 91 to 96=> "100000000", 
    97 => "110000000", 98 to 99=> "100000000", 100 to 101=> "110000000", 102 to 106=> "100000000", 
    107 => "110000000", 108 to 110=> "100000000", 111 to 115=> "110000000", 116 to 122=> "100000000", 
    123 => "110000000", 124 to 126=> "100000000", 127 => "110000000", 128 to 131=> "100000000", 
    132 to 136=> "110000000", 137 => "100000000", 138 => "110000000", 139 => "100000000", 
    140 to 142=> "110000000", 143 to 147=> "100000000", 148 to 150=> "110000000", 151 to 152=> "100000000", 
    153 to 154=> "110000000", 155 to 156=> "100000000", 157 => "110000000", 158 to 160=> "100000000", 
    161 => "110000000", 162 => "100000000", 163 => "110000000", 164 => "100000000", 
    165 to 171=> "110000000", 172 to 174=> "100000000", 175 => "110000000", 176 to 182=> "100000000", 
    183 to 184=> "110000000", 185 => "100000000", 186 => "110000000", 187 => "100000000", 
    188 => "110000000", 189 to 192=> "100000000", 193 to 194=> "110000000", 195 to 196=> "100000000", 
    197 => "110000000", 198 to 199=> "100000000", 200 to 201=> "110000000", 202 to 203=> "100000000", 
    204 to 205=> "110000000", 206 to 207=> "100000000", 208 to 209=> "110000000", 210 to 211=> "100000000", 
    212 to 214=> "110000000", 215 => "100000000", 216 => "110000000", 217 to 219=> "100000000", 
    220 to 222=> "110000000", 223 to 224=> "100000000", 225 to 226=> "110000000", 227 => "100000000", 
    228 to 229=> "110000000", 230 => "100000000", 231 to 233=> "110000000", 234 to 237=> "100000000", 
    238 to 239=> "110000000", 240 to 242=> "100000000", 243 to 244=> "110000000", 245 to 249=> "100000000", 
    250 to 253=> "110000000", 254 to 255=> "100000000", 256 => "110000000", 257 => "100000000", 
    258 to 260=> "110000000", 261 to 264=> "100000000", 265 => "110000000", 266 => "100000000", 
    267 => "110000000", 268 to 269=> "100000000", 270 to 271=> "110000000", 272 => "100000000", 
    273 to 275=> "110000000", 276 => "100000000", 277 => "110000000", 278 to 281=> "100000000", 
    282 to 285=> "110000000", 286 to 288=> "100000000", 289 to 290=> "110000000", 291 to 293=> "100000000", 
    294 => "110000000", 295 => "100000000", 296 to 297=> "110000000", 298 => "100000000", 
    299 to 303=> "110000000", 304 to 308=> "100000000", 309 to 315=> "110000000", 316 to 320=> "100000000", 
    321 to 326=> "110000000", 327 to 329=> "100000000", 330 => "110000000", 331 => "100000000", 
    332 to 333=> "110000000", 334 => "100000000", 335 => "110000000", 336 to 337=> "100000000", 
    338 to 341=> "110000000", 342 => "100000000", 343 to 348=> "110000000", 349 => "100000000", 
    350 => "110000000", 351 => "100000000", 352 => "110000000", 353 to 355=> "100000000", 
    356 to 358=> "110000000", 359 to 363=> "100000000", 364 to 365=> "110000000", 366 to 367=> "100000000", 
    368 to 372=> "110000000", 373 to 375=> "100000000", 376 => "110000000", 377 to 379=> "100000000", 
    380 to 383=> "110000000", 384 => "100000000", 385 to 391=> "110000000", 392 => "100000000", 
    393 to 397=> "110000000", 398 => "100000000", 399 to 402=> "110000000", 403 to 404=> "100000000", 
    405 to 409=> "110000000", 410 => "100000000", 411 => "110000000", 412 to 416=> "100000000", 
    417 to 420=> "110000000", 421 to 422=> "100000000", 423 to 425=> "110000000", 426 => "100000000", 
    427 to 430=> "110000000", 431 to 432=> "100000000", 433 to 434=> "110000000", 435 to 436=> "100000000", 
    437 => "110000000", 438 => "100000000", 439 to 442=> "110000000", 443 to 446=> "100000000", 
    447 => "110000000", 448 => "100000000", 449 to 450=> "110000000", 451 to 457=> "100000000", 
    458 => "110000000", 459 to 461=> "100000000", 462 => "110000000", 463 to 464=> "100000000", 
    465 => "110000000", 466 => "100000000", 467 to 469=> "110000000", 470 => "100000000", 
    471 to 472=> "110000000", 473 to 474=> "100000000", 475 to 477=> "110000000", 478 => "100000000", 
    479 to 480=> "110000000", 481 to 482=> "100000000", 483 to 486=> "110000000", 487 to 490=> "100000000", 
    491 to 494=> "110000000", 495 to 496=> "100000000", 497 to 504=> "110000000", 505 => "100000000", 
    506 to 508=> "110000000", 509 => "100000000", 510 to 516=> "110000000", 517 => "100000000", 
    518 to 519=> "110000000", 520 to 525=> "100000000", 526 to 528=> "110000000", 529 => "100000000", 
    530 => "110000000", 531 => "100000000", 532 to 536=> "110000000", 537 to 540=> "100000000", 
    541 => "110000000", 542 to 543=> "100000000", 544 to 545=> "110000000", 546 => "100000000", 
    547 => "110000000", 548 to 550=> "100000000", 551 => "110000000", 552 to 554=> "100000000", 
    555 to 558=> "110000000", 559 => "100000000", 560 to 563=> "110000000", 564 to 567=> "100000000", 
    568 to 571=> "110000000", 572 => "100000000", 573 => "110000000", 574 to 575=> "100000000", 
    576 to 583=> "110000000", 584 => "100000000", 585 to 586=> "110000000", 587 to 588=> "100000000", 
    589 to 590=> "110000000", 591 to 592=> "100000000", 593 => "110000000", 594 to 595=> "100000000", 
    596 to 597=> "110000000", 598 => "100000000", 599 => "110000000", 600 to 603=> "100000000", 
    604 to 605=> "110000000", 606 to 607=> "100000000", 608 => "110000000", 609 => "100000000", 
    610 => "110000000", 611 to 612=> "100000000", 613 => "110000000", 614 => "100000000", 
    615 to 619=> "110000000", 620 => "100000000", 621 => "110000000", 622 to 627=> "100000000", 
    628 => "110000000", 629 to 631=> "100000000", 632 => "110000000", 633 => "100000000", 
    634 to 636=> "110000000", 637 => "100000000", 638 => "110000000", 639 => "100000000", 
    640 to 643=> "110000000", 644 => "100000000", 645 to 647=> "110000000", 648 => "100000000", 
    649 to 654=> "110000000", 655 => "100000000", 656 to 658=> "110000000", 659 => "100000000", 
    660 to 662=> "110000000", 663 to 667=> "100000000", 668 => "110000000", 669 to 670=> "100000000", 
    671 to 672=> "110000000", 673 to 675=> "100000000", 676 to 677=> "110000000", 678 to 684=> "100000000", 
    685 => "110000000", 686 => "100000000", 687 to 689=> "110000000", 690 to 691=> "100000000", 
    692 to 693=> "110000000", 694 to 696=> "100000000", 697 to 698=> "110000000", 699 to 701=> "100000000", 
    702 => "110000000", 703 to 706=> "100000000", 707 to 708=> "110000000", 709 to 710=> "100000000", 
    711 to 712=> "110000000", 713 to 715=> "100000000", 716 => "110000000", 717 to 719=> "100000000", 
    720 => "110000000", 721 to 722=> "100000000", 723 => "110000000", 724 to 728=> "100000000", 
    729 to 738=> "110000000", 739 to 743=> "100000000", 744 => "110000000", 745 => "100000000", 
    746 to 748=> "110000000", 749 to 753=> "100000000", 754 to 755=> "110000000", 756 to 758=> "100000000", 
    759 to 760=> "110000000", 761 => "100000000", 762 to 763=> "110000000", 764 to 766=> "100000000", 
    767 to 769=> "110000000", 770 => "100000000", 771 to 772=> "110000000", 773 => "100000000", 
    774 => "110000000", 775 to 778=> "100000000", 779 => "110000000", 780 to 784=> "100000000", 
    785 => "110000000", 786 => "100000000", 787 to 792=> "110000000", 793 to 794=> "100000000", 
    795 to 797=> "110000000", 798 => "100000000", 799 => "110000000", 800 to 801=> "100000000", 
    802 => "110000000", 803 to 804=> "100000000", 805 to 806=> "110000000", 807 => "100000000", 
    808 => "110000000", 809 to 810=> "100000000", 811 => "110000000", 812 => "100000000", 
    813 to 814=> "110000000", 815 to 817=> "100000000", 818 => "110000000", 819 => "100000000", 
    820 to 823=> "110000000", 824 to 825=> "100000000", 826 to 827=> "110000000", 828 => "100000000", 
    829 to 830=> "110000000", 831 => "100000000", 832 => "110000000", 833 => "100000000", 
    834 to 841=> "110000000", 842 to 844=> "100000000", 845 to 848=> "110000000", 849 to 851=> "100000000", 
    852 to 854=> "110000000", 855 to 856=> "100000000", 857 to 858=> "110000000", 859 => "100000000", 
    860 => "110000000", 861 to 866=> "100000000", 867 => "110000000", 868 => "100000000", 
    869 => "110000000", 870 => "100000000", 871 => "110000000", 872 to 874=> "100000000", 
    875 => "110000000", 876 to 877=> "100000000", 878 to 882=> "110000000", 883 => "100000000", 
    884 to 891=> "110000000", 892 to 894=> "100000000", 895 => "110000000", 896 to 897=> "100000000", 
    898 => "110000000", 899 to 900=> "100000000", 901 => "110000000", 902 => "100000000", 
    903 => "110000000", 904 to 908=> "100000000", 909 to 910=> "110000000", 911 to 913=> "100000000", 
    914 => "110000000", 915 => "100000000", 916 to 919=> "110000000", 920 => "100000000", 
    921 => "110000000", 922 to 923=> "100000000", 924 to 932=> "110000000", 933 to 934=> "100000000", 
    935 to 938=> "110000000", 939 to 940=> "100000000", 941 to 944=> "110000000", 945 to 947=> "100000000", 
    948 => "110000000", 949 to 951=> "100000000", 952 => "110000000", 953 to 957=> "100000000", 
    958 => "110000000", 959 to 966=> "100000000", 967 => "110000000", 968 to 969=> "100000000", 
    970 => "110000000", 971 to 973=> "100000000", 974 to 976=> "110000000", 977 to 978=> "100000000", 
    979 => "110000000", 980 to 984=> "100000000", 985 => "110000000", 986 => "100000000", 
    987 => "110000000", 988 => "100000000", 989 => "110000000", 990 to 991=> "100000000", 
    992 to 993=> "110000000", 994 to 995=> "100000000", 996 to 997=> "110000000", 998 to 999=> "100000000", 
    1000 to 1003=> "110000000", 1004 to 1006=> "100000000", 1007 to 1008=> "110000000", 1009 => "100000000", 
    1010 to 1011=> "110000000", 1012 to 1014=> "100000000", 1015 => "110000000", 1016 to 1018=> "100000000", 
    1019 to 1020=> "110000000", 1021 => "100000000", 1022 to 1024=> "110000000", 1025 to 1029=> "100000000", 
    1030 to 1034=> "110000000", 1035 to 1036=> "100000000", 1037 => "110000000", 1038 to 1039=> "100000000", 
    1040 to 1043=> "110000000", 1044 => "100000000", 1045 => "110000000", 1046 to 1048=> "100000000", 
    1049 to 1050=> "110000000", 1051 to 1053=> "100000000", 1054 to 1056=> "110000000", 1057 to 1060=> "100000000", 
    1061 => "110000000", 1062 => "100000000", 1063 => "110000000", 1064 => "100000000", 
    1065 => "110000000", 1066 => "100000000", 1067 to 1068=> "110000000", 1069 => "100000000", 
    1070 to 1073=> "110000000", 1074 => "100000000", 1075 to 1077=> "110000000", 1078 to 1081=> "100000000", 
    1082 => "110000000", 1083 to 1085=> "100000000", 1086 => "110000000", 1087 to 1089=> "100000000", 
    1090 => "110000000", 1091 => "100000000", 1092 to 1093=> "110000000", 1094 to 1096=> "100000000", 
    1097 => "110000000", 1098 to 1104=> "100000000", 1105 => "110000000", 1106 => "100000000", 
    1107 to 1108=> "110000000", 1109 => "100000000", 1110 to 1113=> "110000000", 1114 => "100000000", 
    1115 => "110000000", 1116 to 1117=> "100000000", 1118 to 1119=> "110000000", 1120 to 1123=> "100000000", 
    1124 to 1125=> "110000000", 1126 to 1127=> "100000000", 1128 to 1130=> "110000000", 1131 to 1133=> "100000000", 
    1134 => "110000000", 1135 to 1139=> "100000000", 1140 => "110000000", 1141 => "100000000", 
    1142 to 1143=> "110000000", 1144 => "100000000", 1145 to 1154=> "110000000", 1155 => "100000000", 
    1156 to 1160=> "110000000", 1161 => "100000000", 1162 to 1169=> "110000000", 1170 to 1171=> "100000000", 
    1172 to 1176=> "110000000", 1177 to 1181=> "100000000", 1182 to 1183=> "110000000", 1184 => "100000000", 
    1185 to 1186=> "110000000", 1187 to 1188=> "100000000", 1189 => "110000000", 1190 to 1192=> "100000000", 
    1193 to 1198=> "110000000", 1199 to 1201=> "100000000", 1202 => "110000000", 1203 => "100000000", 
    1204 to 1208=> "110000000", 1209 to 1212=> "100000000", 1213 to 1220=> "110000000", 1221 => "100000000", 
    1222 to 1225=> "110000000", 1226 to 1227=> "100000000", 1228 => "110000000", 1229 => "100000000", 
    1230 => "110000000", 1231 => "100000000", 1232 => "110000000", 1233 to 1235=> "100000000", 
    1236 => "110000000", 1237 to 1238=> "100000000", 1239 => "110000000", 1240 to 1244=> "100000000", 
    1245 to 1247=> "110000000", 1248 => "100000000", 1249 => "110000000", 1250 to 1251=> "100000000", 
    1252 => "110000000", 1253 => "100000000", 1254 to 1255=> "110000000", 1256 => "100000000", 
    1257 to 1260=> "110000000", 1261 to 1266=> "100000000", 1267 to 1270=> "110000000", 1271 to 1272=> "100000000", 
    1273 to 1288=> "110000000", 1289 => "100000000", 1290 => "110000000", 1291 to 1293=> "100000000", 
    1294 => "110000000", 1295 to 1308=> "100000000", 1309 to 1311=> "110000000", 1312 => "100000000", 
    1313 to 1314=> "110000000", 1315 => "100000000", 1316 to 1318=> "110000000", 1319 => "100000000", 
    1320 to 1323=> "110000000", 1324 to 1327=> "100000000", 1328 => "110000000", 1329 to 1330=> "100000000", 
    1331 to 1334=> "110000000", 1335 to 1340=> "100000000", 1341 to 1342=> "110000000", 1343 to 1344=> "100000000", 
    1345 => "110000000", 1346 => "100000000", 1347 => "110000000", 1348 => "100000000", 
    1349 to 1352=> "110000000", 1353 to 1355=> "100000000", 1356 => "110000000", 1357 to 1358=> "100000000", 
    1359 => "110000000", 1360 => "100000000", 1361 to 1363=> "110000000", 1364 => "100000000", 
    1365 to 1368=> "110000000", 1369 to 1373=> "100000000", 1374 to 1376=> "110000000", 1377 => "100000000", 
    1378 to 1379=> "110000000", 1380 to 1384=> "100000000", 1385 to 1388=> "110000000", 1389 to 1394=> "100000000", 
    1395 to 1397=> "110000000", 1398 to 1400=> "100000000", 1401 => "110000000", 1402 => "100000000", 
    1403 => "110000000", 1404 => "100000000", 1405 => "110000000", 1406 to 1409=> "100000000", 
    1410 => "110000000", 1411 to 1413=> "100000000", 1414 => "110000000", 1415 to 1419=> "100000000", 
    1420 => "110000000", 1421 to 1425=> "100000000", 1426 => "110000000", 1427 => "100000000", 
    1428 to 1435=> "110000000", 1436 to 1439=> "100000000", 1440 to 1447=> "110000000", 1448 => "100000000", 
    1449 to 1450=> "110000000", 1451 to 1452=> "100000000", 1453 => "110000000", 1454 => "100000000", 
    1455 to 1458=> "110000000", 1459 to 1462=> "100000000", 1463 => "110000000", 1464 => "100000000", 
    1465 to 1466=> "110000000", 1467 to 1475=> "100000000", 1476 to 1478=> "110000000", 1479 => "100000000", 
    1480 => "110000000", 1481 to 1485=> "100000000", 1486 => "110000000", 1487 to 1493=> "100000000", 
    1494 to 1495=> "110000000", 1496 to 1497=> "100000000", 1498 to 1499=> "110000000", 1500 => "100000000", 
    1501 => "110000000", 1502 to 1506=> "100000000", 1507 => "110000000", 1508 to 1511=> "100000000", 
    1512 => "110000000", 1513 => "100000000", 1514 => "110000000", 1515 => "100000000", 
    1516 => "110000000", 1517 => "100000000", 1518 to 1519=> "110000000", 1520 to 1521=> "100000000", 
    1522 to 1523=> "110000000", 1524 => "100000000", 1525 to 1526=> "110000000", 1527 => "100000000", 
    1528 to 1529=> "110000000", 1530 => "100000000", 1531 => "110000000", 1532 => "100000000", 
    1533 to 1534=> "110000000", 1535 to 1536=> "100000000", 1537 => "110000000", 1538 => "100000000", 
    1539 to 1540=> "110000000", 1541 to 1542=> "100000000", 1543 => "110000000", 1544 to 1551=> "100000000", 
    1552 => "110000000", 1553 to 1556=> "100000000", 1557 => "110000000", 1558 to 1559=> "100000000", 
    1560 to 1563=> "110000000", 1564 to 1567=> "100000000", 1568 => "110000000", 1569 to 1572=> "100000000", 
    1573 to 1575=> "110000000", 1576 to 1577=> "100000000", 1578 to 1580=> "110000000", 1581 to 1584=> "100000000", 
    1585 to 1595=> "110000000", 1596 to 1597=> "100000000", 1598 to 1599=> "110000000", 1600 to 1601=> "100000000", 
    1602 to 1604=> "110000000", 1605 => "100000000", 1606 => "110000000", 1607 => "100000000", 
    1608 => "110000000", 1609 to 1612=> "100000000", 1613 => "110000000", 1614 to 1616=> "100000000", 
    1617 to 1620=> "110000000", 1621 to 1623=> "100000000", 1624 => "110000000", 1625 => "100000000", 
    1626 => "110000000", 1627 => "100000000", 1628 => "110000000", 1629 to 1630=> "100000000", 
    1631 to 1633=> "110000000", 1634 to 1636=> "100000000", 1637 to 1638=> "110000000", 1639 to 1642=> "100000000", 
    1643 => "110000000", 1644 to 1653=> "100000000", 1654 to 1656=> "110000000", 1657 to 1662=> "100000000", 
    1663 to 1665=> "110000000", 1666 => "100000000", 1667 => "110000000", 1668 to 1671=> "100000000", 
    1672 to 1673=> "110000000", 1674 to 1677=> "100000000", 1678 to 1679=> "110000000", 1680 to 1686=> "100000000", 
    1687 to 1691=> "110000000", 1692 to 1693=> "100000000", 1694 to 1698=> "110000000", 1699 => "100000000", 
    1700 to 1701=> "110000000", 1702 to 1704=> "100000000", 1705 to 1706=> "110000000", 1707 => "100000000", 
    1708 => "110000000", 1709 => "100000000", 1710 to 1712=> "110000000", 1713 to 1714=> "100000000", 
    1715 to 1716=> "110000000", 1717 to 1718=> "100000000", 1719 => "110000000", 1720 to 1722=> "100000000", 
    1723 to 1724=> "110000000", 1725 to 1727=> "100000000", 1728 to 1730=> "110000000", 1731 to 1733=> "100000000", 
    1734 => "110000000", 1735 => "100000000", 1736 to 1747=> "110000000", 1748 => "100000000", 
    1749 => "110000000", 1750 to 1751=> "100000000", 1752 => "110000000", 1753 => "100000000", 
    1754 => "110000000", 1755 => "100000000", 1756 => "110000000", 1757 to 1758=> "100000000", 
    1759 => "110000000", 1760 => "100000000", 1761 => "110000000", 1762 to 1764=> "100000000", 
    1765 => "110000000", 1766 to 1769=> "100000000", 1770 to 1773=> "110000000", 1774 to 1778=> "100000000", 
    1779 to 1780=> "110000000", 1781 => "100000000", 1782 to 1783=> "110000000", 1784 => "100000000", 
    1785 => "110000000", 1786 => "100000000", 1787 => "110000000", 1788 to 1791=> "100000000", 
    1792 => "110000000", 1793 to 1795=> "100000000", 1796 to 1799=> "110000000", 1800 => "100000000", 
    1801 => "110000000", 1802 to 1803=> "100000000", 1804 => "110000000", 1805 to 1808=> "100000000", 
    1809 => "110000000", 1810 => "100000000", 1811 to 1812=> "110000000", 1813 => "100000000", 
    1814 => "110000000", 1815 to 1816=> "100000000", 1817 => "110000000", 1818 => "100000000", 
    1819 => "110000000", 1820 to 1821=> "100000000", 1822 to 1824=> "110000000", 1825 => "100000000", 
    1826 to 1829=> "110000000", 1830 => "100000000", 1831 to 1832=> "110000000", 1833 => "100000000", 
    1834 to 1836=> "110000000", 1837 to 1838=> "100000000", 1839 => "110000000", 1840 to 1843=> "100000000", 
    1844 => "110000000", 1845 => "100000000", 1846 to 1855=> "110000000", 1856 => "100000000", 
    1857 to 1861=> "110000000", 1862 => "100000000", 1863 to 1865=> "110000000", 1866 => "100000000", 
    1867 to 1871=> "110000000", 1872 to 1878=> "100000000", 1879 => "110000000", 1880 => "100000000", 
    1881 to 1882=> "110000000", 1883 to 1886=> "100000000", 1887 to 1891=> "110000000", 1892 to 1894=> "100000000", 
    1895 to 1898=> "110000000", 1899 to 1901=> "100000000", 1902 to 1910=> "110000000", 1911 => "100000000", 
    1912 => "110000000", 1913 to 1917=> "100000000", 1918 to 1919=> "110000000", 1920 to 1924=> "100000000", 
    1925 to 1928=> "110000000", 1929 => "100000000", 1930 to 1931=> "110000000", 1932 => "100000000", 
    1933 => "110000000", 1934 => "100000000", 1935 to 1939=> "110000000", 1940 to 1943=> "100000000", 
    1944 to 1945=> "110000000", 1946 to 1947=> "100000000", 1948 => "110000000", 1949 to 1951=> "100000000", 
    1952 to 1954=> "110000000", 1955 to 1956=> "100000000", 1957 => "110000000", 1958 => "100000000", 
    1959 => "110000000", 1960 => "100000000", 1961 => "110000000", 1962 to 1963=> "100000000", 
    1964 => "110000000", 1965 => "100000000", 1966 => "110000000", 1967 => "100000000", 
    1968 => "110000000", 1969 => "100000000", 1970 => "110000000", 1971 to 1972=> "100000000", 
    1973 to 1974=> "110000000", 1975 to 1978=> "100000000", 1979 to 1983=> "110000000", 1984 to 1987=> "100000000", 
    1988 => "110000000", 1989 => "100000000", 1990 to 1991=> "110000000", 1992 to 1993=> "100000000", 
    1994 to 1995=> "110000000", 1996 to 1998=> "100000000", 1999 => "110000000", 2000 to 2001=> "100000000", 
    2002 => "110000000", 2003 to 2005=> "100000000", 2006 => "110000000", 2007 => "100000000", 
    2008 => "110000000", 2009 => "100000000", 2010 => "110000000", 2011 => "100000000", 
    2012 to 2013=> "110000000", 2014 to 2015=> "100000000", 2016 => "110000000", 2017 to 2021=> "100000000", 
    2022 => "110000000", 2023 => "100000000", 2024 => "110000000", 2025 => "100000000", 
    2026 to 2032=> "110000000", 2033 => "100000000", 2034 to 2035=> "110000000", 2036 to 2037=> "100000000", 
    2038 => "110000000", 2039 to 2044=> "100000000", 2045 => "110000000", 2046 to 2047=> "100000000", 
    2048 to 2052=> "110000000", 2053 to 2054=> "100000000", 2055 => "110000000", 2056 => "100000000", 
    2057 to 2059=> "110000000", 2060 to 2061=> "100000000", 2062 to 2066=> "110000000", 2067 to 2074=> "100000000", 
    2075 => "110000000", 2076 => "100000000", 2077 => "110000000", 2078 => "100000000", 
    2079 => "110000000", 2080 to 2084=> "100000000", 2085 to 2088=> "110000000", 2089 to 2092=> "100000000", 
    2093 => "110000000", 2094 to 2096=> "100000000", 2097 to 2098=> "110000000", 2099 => "100000000", 
    2100 to 2101=> "110000000", 2102 to 2106=> "100000000", 2107 => "110000000", 2108 to 2110=> "100000000", 
    2111 => "110000000", 2112 to 2115=> "100000000", 2116 => "110000000", 2117 => "100000000", 
    2118 to 2126=> "110000000", 2127 => "100000000", 2128 to 2130=> "110000000", 2131 to 2133=> "100000000", 
    2134 => "110000000", 2135 => "100000000", 2136 => "110000000", 2137 to 2138=> "100000000", 
    2139 to 2140=> "110000000", 2141 to 2142=> "100000000", 2143 to 2145=> "110000000", 2146 to 2148=> "100000000", 
    2149 to 2152=> "110000000", 2153 => "100000000", 2154 => "110000000", 2155 to 2157=> "100000000", 
    2158 to 2163=> "110000000", 2164 to 2167=> "100000000", 2168 to 2169=> "110000000", 2170 => "100000000", 
    2171 to 2173=> "110000000", 2174 => "100000000", 2175 to 2176=> "110000000", 2177 to 2178=> "100000000", 
    2179 to 2180=> "110000000", 2181 => "100000000", 2182 to 2185=> "110000000", 2186 => "100000000", 
    2187 to 2188=> "110000000", 2189 to 2192=> "100000000", 2193 to 2196=> "110000000", 2197 => "100000000", 
    2198 => "110000000", 2199 => "100000000", 2200 to 2201=> "110000000", 2202 => "100000000", 
    2203 => "110000000", 2204 to 2206=> "100000000", 2207 to 2212=> "110000000", 2213 to 2214=> "100000000", 
    2215 to 2217=> "110000000", 2218 => "100000000", 2219 to 2224=> "110000000", 2225 to 2226=> "100000000", 
    2227 to 2229=> "110000000", 2230 => "100000000", 2231 to 2236=> "110000000", 2237 to 2240=> "100000000", 
    2241 => "110000000", 2242 to 2248=> "100000000", 2249 => "110000000", 2250 => "100000000", 
    2251 => "110000000", 2252 to 2253=> "100000000", 2254 => "110000000", 2255 => "100000000", 
    2256 to 2262=> "110000000", 2263 to 2266=> "100000000", 2267 to 2268=> "110000000", 2269 to 2275=> "100000000", 
    2276 => "110000000", 2277 to 2279=> "100000000", 2280 => "110000000", 2281 => "100000000", 
    2282 to 2285=> "110000000", 2286 to 2287=> "100000000", 2288 => "110000000", 2289 to 2292=> "100000000", 
    2293 to 2294=> "110000000", 2295 to 2296=> "100000000", 2297 => "110000000", 2298 to 2300=> "100000000", 
    2301 to 2304=> "110000000", 2305 to 2306=> "100000000", 2307 to 2316=> "110000000", 2317 to 2323=> "100000000", 
    2324 => "110000000", 2325 to 2326=> "100000000", 2327 to 2328=> "110000000", 2329 => "100000000", 
    2330 => "110000000", 2331 to 2332=> "100000000", 2333 to 2336=> "110000000", 2337 to 2339=> "100000000", 
    2340 => "110000000", 2341 => "100000000", 2342 to 2345=> "110000000", 2346 to 2351=> "100000000", 
    2352 to 2353=> "110000000", 2354 => "100000000", 2355 => "110000000", 2356 to 2361=> "100000000", 
    2362 to 2364=> "110000000", 2365 => "100000000", 2366 to 2367=> "110000000", 2368 to 2372=> "100000000", 
    2373 => "110000000", 2374 => "100000000", 2375 => "110000000", 2376 to 2378=> "100000000", 
    2379 to 2380=> "110000000", 2381 to 2388=> "100000000", 2389 to 2390=> "110000000", 2391 to 2393=> "100000000", 
    2394 => "110000000", 2395 => "100000000", 2396 to 2399=> "110000000", 2400 to 2402=> "100000000", 
    2403 => "110000000", 2404 to 2405=> "100000000", 2406 to 2410=> "110000000", 2411 to 2412=> "100000000", 
    2413 to 2415=> "110000000", 2416 => "100000000", 2417 to 2418=> "110000000", 2419 to 2421=> "100000000", 
    2422 to 2424=> "110000000", 2425 => "100000000", 2426 => "110000000", 2427 to 2429=> "100000000", 
    2430 to 2432=> "110000000", 2433 to 2439=> "100000000", 2440 => "110000000", 2441 => "100000000", 
    2442 => "110000000", 2443 to 2445=> "100000000", 2446 to 2447=> "110000000", 2448 to 2449=> "100000000", 
    2450 to 2451=> "110000000", 2452 to 2454=> "100000000", 2455 => "110000000", 2456 to 2457=> "100000000", 
    2458 to 2459=> "110000000", 2460 => "100000000", 2461 => "110000000", 2462 to 2463=> "100000000", 
    2464 to 2474=> "110000000", 2475 to 2477=> "100000000", 2478 => "110000000", 2479 => "100000000", 
    2480 => "110000000", 2481 to 2483=> "100000000", 2484 => "110000000", 2485 => "100000000", 
    2486 to 2489=> "110000000", 2490 to 2494=> "100000000", 2495 => "110000000", 2496 => "100000000", 
    2497 to 2498=> "110000000", 2499 => "100000000", 2500 => "110000000", 2501 => "100000000", 
    2502 to 2503=> "110000000", 2504 to 2508=> "100000000", 2509 => "110000000", 2510 to 2511=> "100000000", 
    2512 => "110000000", 2513 => "100000000", 2514 => "110000000", 2515 to 2516=> "100000000", 
    2517 to 2526=> "110000000", 2527 to 2528=> "100000000", 2529 => "110000000", 2530 to 2532=> "100000000", 
    2533 to 2534=> "110000000", 2535 to 2537=> "100000000", 2538 => "110000000", 2539 to 2540=> "100000000", 
    2541 => "110000000", 2542 to 2544=> "100000000", 2545 to 2549=> "110000000", 2550 => "100000000", 
    2551 to 2552=> "110000000", 2553 => "100000000", 2554 => "110000000", 2555 => "100000000", 
    2556 => "110000000", 2557 to 2559=> "100000000", 2560 => "110000000", 2561 to 2562=> "100000000", 
    2563 to 2567=> "110000000", 2568 to 2569=> "100000000", 2570 to 2571=> "110000000", 2572 to 2573=> "100000000", 
    2574 to 2579=> "110000000", 2580 to 2587=> "100000000", 2588 => "110000000", 2589 to 2592=> "100000000", 
    2593 to 2594=> "110000000", 2595 => "100000000", 2596 => "110000000", 2597 to 2598=> "100000000", 
    2599 to 2602=> "110000000", 2603 to 2605=> "100000000", 2606 to 2607=> "110000000", 2608 => "100000000", 
    2609 to 2610=> "110000000", 2611 to 2614=> "100000000", 2615 => "110000000", 2616 => "100000000", 
    2617 to 2621=> "110000000", 2622 to 2624=> "100000000", 2625 => "110000000", 2626 to 2628=> "100000000", 
    2629 to 2631=> "110000000", 2632 to 2633=> "100000000", 2634 => "110000000", 2635 to 2637=> "100000000", 
    2638 => "110000000", 2639 => "100000000", 2640 => "110000000", 2641 to 2643=> "100000000", 
    2644 => "110000000", 2645 to 2650=> "100000000", 2651 to 2652=> "110000000", 2653 => "100000000", 
    2654 to 2655=> "110000000", 2656 => "100000000", 2657 to 2664=> "110000000", 2665 to 2666=> "100000000", 
    2667 to 2669=> "110000000", 2670 to 2671=> "100000000", 2672 to 2673=> "110000000", 2674 to 2676=> "100000000", 
    2677 to 2678=> "110000000", 2679 => "100000000", 2680 => "110000000", 2681 to 2682=> "100000000", 
    2683 to 2684=> "110000000", 2685 to 2686=> "100000000", 2687 to 2688=> "110000000", 2689 => "100000000", 
    2690 => "110000000", 2691 => "100000000", 2692 => "110000000", 2693 to 2694=> "100000000", 
    2695 to 2702=> "110000000", 2703 to 2707=> "100000000", 2708 to 2710=> "110000000", 2711 to 2712=> "100000000", 
    2713 to 2714=> "110000000", 2715 to 2716=> "100000000", 2717 => "110000000", 2718 to 2720=> "100000000", 
    2721 => "110000000", 2722 to 2723=> "100000000", 2724 to 2727=> "110000000", 2728 to 2729=> "100000000", 
    2730 => "110000000", 2731 to 2732=> "100000000", 2733 to 2735=> "110000000", 2736 => "100000000", 
    2737 => "110000000", 2738 => "100000000", 2739 to 2743=> "110000000", 2744 to 2745=> "100000000", 
    2746 => "110000000", 2747 to 2751=> "100000000", 2752 to 2754=> "110000000", 2755 to 2757=> "100000000", 
    2758 => "110000000", 2759 => "100000000", 2760 => "110000000", 2761 to 2763=> "100000000", 
    2764 to 2768=> "110000000", 2769 to 2771=> "100000000", 2772 => "110000000", 2773 to 2779=> "100000000", 
    2780 to 2783=> "110000000", 2784 => "100000000", 2785 => "110000000", 2786 => "100000000", 
    2787 to 2788=> "110000000", 2789 to 2795=> "100000000", 2796 => "110000000", 2797 to 2801=> "100000000", 
    2802 to 2812=> "110000000", 2813 to 2818=> "100000000", 2819 => "110000000", 2820 => "100000000", 
    2821 to 2825=> "110000000", 2826 => "100000000", 2827 to 2830=> "110000000", 2831 to 2832=> "100000000", 
    2833 to 2836=> "110000000", 2837 to 2838=> "100000000", 2839 to 2845=> "110000000", 2846 => "100000000", 
    2847 to 2850=> "110000000", 2851 to 2852=> "100000000", 2853 to 2854=> "110000000", 2855 to 2864=> "100000000", 
    2865 => "110000000", 2866 to 2867=> "100000000", 2868 to 2870=> "110000000", 2871 => "100000000", 
    2872 => "110000000", 2873 => "100000000", 2874 => "110000000", 2875 to 2883=> "100000000", 
    2884 to 2889=> "110000000", 2890 => "100000000", 2891 to 2893=> "110000000", 2894 to 2899=> "100000000", 
    2900 => "110000000", 2901 => "100000000", 2902 => "110000000", 2903 => "100000000", 
    2904 to 2910=> "110000000", 2911 to 2912=> "100000000" );


attribute EQUIVALENT_REGISTER_REMOVAL : string;
begin 


memory_access_guard_0: process (addr0) 
begin
      addr0_tmp <= addr0;
--synthesis translate_off
      if (CONV_INTEGER(addr0) > mem_size-1) then
           addr0_tmp <= (others => '0');
      else 
           addr0_tmp <= addr0;
      end if;
--synthesis translate_on
end process;

p_rom_access: process (clk)  
begin 
    if (clk'event and clk = '1') then
        if (ce0 = '1') then 
            q0 <= mem(CONV_INTEGER(addr0_tmp)); 
        end if;
    end if;
end process;

end rtl;


Library IEEE;
use IEEE.std_logic_1164.all;

entity detect_face_cascade_classifier_RECT2_WEIGHT is
    generic (
        DataWidth : INTEGER := 9;
        AddressRange : INTEGER := 2913;
        AddressWidth : INTEGER := 12);
    port (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0));
end entity;

architecture arch of detect_face_cascade_classifier_RECT2_WEIGHT is
    component detect_face_cascade_classifier_RECT2_WEIGHT_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    detect_face_cascade_classifier_RECT2_WEIGHT_rom_U :  component detect_face_cascade_classifier_RECT2_WEIGHT_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;

