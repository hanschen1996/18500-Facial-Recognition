-- ==============================================================
-- File generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2016.4
-- Copyright (C) 1986-2017 Xilinx, Inc. All Rights Reserved.
-- 
-- ==============================================================

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity cascade_classifieudo_rom is 
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


architecture rtl of cascade_classifieudo_rom is 

signal addr0_tmp : std_logic_vector(awidth-1 downto 0); 
type mem_array is array (0 to mem_size-1) of std_logic_vector (dwidth-1 downto 0); 
signal mem : mem_array := (
    0 to 34=> "000000000", 35 => "100000000", 36 to 47=> "000000000", 48 => "100000000", 
    49 to 55=> "000000000", 56 => "100000000", 57 to 61=> "000000000", 62 => "100000000", 
    63 to 69=> "000000000", 70 => "100000000", 71 to 74=> "000000000", 75 to 76=> "100000000", 
    77 to 104=> "000000000", 105 => "100000000", 106 to 108=> "000000000", 109 to 110=> "100000000", 
    111 to 117=> "000000000", 118 => "100000000", 119 => "000000000", 120 to 122=> "100000000", 
    123 to 151=> "000000000", 152 => "100000000", 153 to 159=> "000000000", 160 => "100000000", 
    161 to 163=> "000000000", 164 => "100000000", 165 to 175=> "000000000", 176 to 177=> "100000000", 
    178 to 186=> "000000000", 187 => "100000000", 188 to 201=> "000000000", 202 => "100000000", 
    203 to 205=> "000000000", 206 to 207=> "100000000", 208 to 214=> "000000000", 215 => "100000000", 
    216 => "000000000", 217 => "100000000", 218 to 222=> "000000000", 223 to 224=> "100000000", 
    225 to 229=> "000000000", 230 => "100000000", 231 to 233=> "000000000", 234 to 235=> "100000000", 
    236 to 240=> "000000000", 241 to 242=> "100000000", 243 to 247=> "000000000", 248 to 249=> "100000000", 
    250 to 254=> "000000000", 255 => "100000000", 256 to 260=> "000000000", 261 => "100000000", 
    262 to 287=> "000000000", 288 => "100000000", 289 to 290=> "000000000", 291 => "100000000", 
    292 to 316=> "000000000", 317 to 319=> "100000000", 320 to 326=> "000000000", 327 => "100000000", 
    328 to 335=> "000000000", 336 to 337=> "100000000", 338 to 358=> "000000000", 359 to 363=> "100000000", 
    364 to 365=> "000000000", 366 to 367=> "100000000", 368 to 372=> "000000000", 373 to 375=> "100000000", 
    376 to 411=> "000000000", 412 => "100000000", 413 to 414=> "000000000", 415 to 416=> "100000000", 
    417 to 443=> "000000000", 444 => "100000000", 445 to 450=> "000000000", 451 => "100000000", 
    452 => "000000000", 453 to 454=> "100000000", 455 to 458=> "000000000", 459 to 461=> "100000000", 
    462 => "000000000", 463 to 464=> "100000000", 465 to 472=> "000000000", 473 => "100000000", 
    474 to 477=> "000000000", 478 => "100000000", 479 to 480=> "000000000", 481 => "100000000", 
    482 to 489=> "000000000", 490 => "100000000", 491 to 519=> "000000000", 520 to 521=> "100000000", 
    522 to 524=> "000000000", 525 => "100000000", 526 to 528=> "000000000", 529 => "100000000", 
    530 to 541=> "000000000", 542 => "100000000", 543 to 545=> "000000000", 546 => "100000000", 
    547 => "000000000", 548 to 549=> "100000000", 550 to 553=> "000000000", 554 => "100000000", 
    555 to 558=> "000000000", 559 => "100000000", 560 to 586=> "000000000", 587 to 588=> "100000000", 
    589 to 590=> "000000000", 591 to 592=> "100000000", 593 => "000000000", 594 to 595=> "100000000", 
    596 to 623=> "000000000", 624 to 625=> "100000000", 626 to 654=> "000000000", 655 => "100000000", 
    656 to 658=> "000000000", 659 => "100000000", 660 to 664=> "000000000", 665 to 666=> "100000000", 
    667 to 674=> "000000000", 675 => "100000000", 676 to 677=> "000000000", 678 to 680=> "100000000", 
    681 to 682=> "000000000", 683 => "100000000", 684 to 685=> "000000000", 686 => "100000000", 
    687 to 690=> "000000000", 691 => "100000000", 692 to 693=> "000000000", 694 => "100000000", 
    695 to 698=> "000000000", 699 to 700=> "100000000", 701 to 703=> "000000000", 704 to 706=> "100000000", 
    707 to 721=> "000000000", 722 => "100000000", 723 to 725=> "000000000", 726 => "100000000", 
    727 to 750=> "000000000", 751 to 752=> "100000000", 753 to 755=> "000000000", 756 to 758=> "100000000", 
    759 to 760=> "000000000", 761 => "100000000", 762 to 769=> "000000000", 770 => "100000000", 
    771 to 774=> "000000000", 775 => "100000000", 776 to 777=> "000000000", 778 => "100000000", 
    779 to 783=> "000000000", 784 => "100000000", 785 => "000000000", 786 => "100000000", 
    787 to 799=> "000000000", 800 => "100000000", 801 to 806=> "000000000", 807 => "100000000", 
    808 to 818=> "000000000", 819 => "100000000", 820 to 832=> "000000000", 833 => "100000000", 
    834 to 850=> "000000000", 851 => "100000000", 852 to 854=> "000000000", 855 => "100000000", 
    856 to 858=> "000000000", 859 => "100000000", 860 => "000000000", 861 to 862=> "100000000", 
    863 to 864=> "000000000", 865 to 866=> "100000000", 867 => "000000000", 868 => "100000000", 
    869 to 875=> "000000000", 876 => "100000000", 877 to 910=> "000000000", 911 to 912=> "100000000", 
    913 to 919=> "000000000", 920 => "100000000", 921 to 945=> "000000000", 946 to 947=> "100000000", 
    948 => "000000000", 949 to 951=> "100000000", 952 => "000000000", 953 => "100000000", 
    954 => "000000000", 955 => "100000000", 956 => "000000000", 957 => "100000000", 
    958 => "000000000", 959 => "100000000", 960 to 961=> "000000000", 962 => "100000000", 
    963 to 964=> "000000000", 965 to 966=> "100000000", 967 => "000000000", 968 => "100000000", 
    969 to 976=> "000000000", 977 to 978=> "100000000", 979 => "000000000", 980 to 981=> "100000000", 
    982 to 989=> "000000000", 990 to 991=> "100000000", 992 to 1008=> "000000000", 1009 => "100000000", 
    1010 to 1011=> "000000000", 1012 to 1013=> "100000000", 1014 to 1015=> "000000000", 1016 to 1018=> "100000000", 
    1019 to 1020=> "000000000", 1021 => "100000000", 1022 to 1043=> "000000000", 1044 => "100000000", 
    1045 => "000000000", 1046 to 1047=> "100000000", 1048 to 1056=> "000000000", 1057 to 1058=> "100000000", 
    1059 to 1073=> "000000000", 1074 => "100000000", 1075 to 1079=> "000000000", 1080 to 1081=> "100000000", 
    1082 => "000000000", 1083 => "100000000", 1084 to 1086=> "000000000", 1087 => "100000000", 
    1088 to 1093=> "000000000", 1094 to 1096=> "100000000", 1097 => "000000000", 1098 => "100000000", 
    1099 => "000000000", 1100 => "100000000", 1101 to 1136=> "000000000", 1137 to 1139=> "100000000", 
    1140 => "000000000", 1141 => "100000000", 1142 to 1160=> "000000000", 1161 => "100000000", 
    1162 to 1176=> "000000000", 1177 => "100000000", 1178 => "000000000", 1179 to 1181=> "100000000", 
    1182 to 1183=> "000000000", 1184 => "100000000", 1185 to 1208=> "000000000", 1209 to 1212=> "100000000", 
    1213 to 1225=> "000000000", 1226 => "100000000", 1227 to 1232=> "000000000", 1233 to 1234=> "100000000", 
    1235 to 1237=> "000000000", 1238 => "100000000", 1239 to 1242=> "000000000", 1243 => "100000000", 
    1244 to 1255=> "000000000", 1256 => "100000000", 1257 to 1261=> "000000000", 1262 => "100000000", 
    1263 => "000000000", 1264 to 1266=> "100000000", 1267 to 1288=> "000000000", 1289 => "100000000", 
    1290 => "000000000", 1291 => "100000000", 1292 => "000000000", 1293 => "100000000", 
    1294 => "000000000", 1295 => "100000000", 1296 => "000000000", 1297 to 1299=> "100000000", 
    1300 => "000000000", 1301 to 1308=> "100000000", 1309 to 1311=> "000000000", 1312 => "100000000", 
    1313 to 1314=> "000000000", 1315 => "100000000", 1316 to 1324=> "000000000", 1325 to 1326=> "100000000", 
    1327 to 1328=> "000000000", 1329 to 1330=> "100000000", 1331 to 1334=> "000000000", 1335 to 1336=> "100000000", 
    1337 to 1347=> "000000000", 1348 => "100000000", 1349 to 1352=> "000000000", 1353 to 1355=> "100000000", 
    1356 to 1369=> "000000000", 1370 to 1372=> "100000000", 1373 to 1376=> "000000000", 1377 => "100000000", 
    1378 to 1388=> "000000000", 1389 to 1390=> "100000000", 1391 to 1406=> "000000000", 1407 to 1408=> "100000000", 
    1409 to 1410=> "000000000", 1411 => "100000000", 1412 to 1423=> "000000000", 1424 => "100000000", 
    1425 to 1426=> "000000000", 1427 => "100000000", 1428 to 1447=> "000000000", 1448 => "100000000", 
    1449 to 1450=> "000000000", 1451 => "100000000", 1452 to 1458=> "000000000", 1459 => "100000000", 
    1460 to 1467=> "000000000", 1468 to 1470=> "100000000", 1471 => "000000000", 1472 => "100000000", 
    1473 to 1481=> "000000000", 1482 to 1485=> "100000000", 1486 => "000000000", 1487 to 1491=> "100000000", 
    1492 => "000000000", 1493 => "100000000", 1494 to 1495=> "000000000", 1496 to 1497=> "100000000", 
    1498 to 1499=> "000000000", 1500 => "100000000", 1501 => "000000000", 1502 to 1505=> "100000000", 
    1506 to 1509=> "000000000", 1510 to 1511=> "100000000", 1512 => "000000000", 1513 => "100000000", 
    1514 => "000000000", 1515 => "100000000", 1516 to 1519=> "000000000", 1520 to 1521=> "100000000", 
    1522 to 1529=> "000000000", 1530 => "100000000", 1531 to 1541=> "000000000", 1542 => "100000000", 
    1543 to 1547=> "000000000", 1548 => "100000000", 1549 to 1555=> "000000000", 1556 => "100000000", 
    1557 to 1564=> "000000000", 1565 to 1566=> "100000000", 1567 to 1570=> "000000000", 1571 => "100000000", 
    1572 to 1575=> "000000000", 1576 to 1577=> "100000000", 1578 to 1582=> "000000000", 1583 => "100000000", 
    1584 to 1595=> "000000000", 1596 => "100000000", 1597 to 1604=> "000000000", 1605 => "100000000", 
    1606 => "000000000", 1607 => "100000000", 1608 to 1609=> "000000000", 1610 => "100000000", 
    1611 => "000000000", 1612 => "100000000", 1613 to 1647=> "000000000", 1648 => "100000000", 
    1649 to 1650=> "000000000", 1651 to 1653=> "100000000", 1654 to 1656=> "000000000", 1657 to 1658=> "100000000", 
    1659 => "000000000", 1660 => "100000000", 1661 to 1667=> "000000000", 1668 to 1669=> "100000000", 
    1670 to 1676=> "000000000", 1677 => "100000000", 1678 to 1679=> "000000000", 1680 => "100000000", 
    1681 to 1682=> "000000000", 1683 to 1685=> "100000000", 1686 to 1701=> "000000000", 1702 => "100000000", 
    1703 to 1712=> "000000000", 1713 => "100000000", 1714 to 1719=> "000000000", 1720 => "100000000", 
    1721 to 1725=> "000000000", 1726 => "100000000", 1727 to 1750=> "000000000", 1751 => "100000000", 
    1752 to 1762=> "000000000", 1763 to 1764=> "100000000", 1765 => "000000000", 1766 => "100000000", 
    1767 => "000000000", 1768 to 1769=> "100000000", 1770 to 1785=> "000000000", 1786 => "100000000", 
    1787 to 1788=> "000000000", 1789 => "100000000", 1790 => "000000000", 1791 => "100000000", 
    1792 to 1799=> "000000000", 1800 => "100000000", 1801 to 1804=> "000000000", 1805 => "100000000", 
    1806 to 1809=> "000000000", 1810 => "100000000", 1811 to 1812=> "000000000", 1813 => "100000000", 
    1814 to 1815=> "000000000", 1816 => "100000000", 1817 to 1819=> "000000000", 1820 to 1821=> "100000000", 
    1822 to 1829=> "000000000", 1830 => "100000000", 1831 to 1832=> "000000000", 1833 => "100000000", 
    1834 to 1836=> "000000000", 1837 to 1838=> "100000000", 1839 => "000000000", 1840 to 1841=> "100000000", 
    1842 to 1861=> "000000000", 1862 => "100000000", 1863 to 1873=> "000000000", 1874 => "100000000", 
    1875 to 1879=> "000000000", 1880 => "100000000", 1881 to 1882=> "000000000", 1883 to 1884=> "100000000", 
    1885 to 1891=> "000000000", 1892 to 1893=> "100000000", 1894 to 1899=> "000000000", 1900 to 1901=> "100000000", 
    1902 to 1912=> "000000000", 1913 to 1915=> "100000000", 1916 => "000000000", 1917 => "100000000", 
    1918 to 1939=> "000000000", 1940 => "100000000", 1941 to 1945=> "000000000", 1946 to 1947=> "100000000", 
    1948 => "000000000", 1949 to 1951=> "100000000", 1952 to 1955=> "000000000", 1956 => "100000000", 
    1957 => "000000000", 1958 => "100000000", 1959 to 1962=> "000000000", 1963 => "100000000", 
    1964 to 1966=> "000000000", 1967 => "100000000", 1968 to 1977=> "000000000", 1978 => "100000000", 
    1979 to 1984=> "000000000", 1985 => "100000000", 1986 to 1991=> "000000000", 1992 => "100000000", 
    1993 to 2002=> "000000000", 2003 to 2005=> "100000000", 2006 to 2008=> "000000000", 2009 => "100000000", 
    2010 to 2014=> "000000000", 2015 => "100000000", 2016 => "000000000", 2017 => "100000000", 
    2018 => "000000000", 2019 to 2021=> "100000000", 2022 to 2024=> "000000000", 2025 => "100000000", 
    2026 to 2035=> "000000000", 2036 => "100000000", 2037 to 2038=> "000000000", 2039 to 2042=> "100000000", 
    2043 to 2045=> "000000000", 2046 to 2047=> "100000000", 2048 to 2060=> "000000000", 2061 => "100000000", 
    2062 to 2066=> "000000000", 2067 => "100000000", 2068 to 2069=> "000000000", 2070 => "100000000", 
    2071 => "000000000", 2072 to 2074=> "100000000", 2075 => "000000000", 2076 => "100000000", 
    2077 to 2083=> "000000000", 2084 => "100000000", 2085 to 2088=> "000000000", 2089 to 2092=> "100000000", 
    2093 to 2094=> "000000000", 2095 to 2096=> "100000000", 2097 to 2101=> "000000000", 2102 to 2106=> "100000000", 
    2107 to 2141=> "000000000", 2142 => "100000000", 2143 to 2145=> "000000000", 2146 => "100000000", 
    2147 to 2152=> "000000000", 2153 => "100000000", 2154 to 2163=> "000000000", 2164 to 2167=> "100000000", 
    2168 to 2169=> "000000000", 2170 => "100000000", 2171 to 2173=> "000000000", 2174 => "100000000", 
    2175 to 2180=> "000000000", 2181 => "100000000", 2182 to 2185=> "000000000", 2186 => "100000000", 
    2187 to 2188=> "000000000", 2189 => "100000000", 2190 to 2191=> "000000000", 2192 => "100000000", 
    2193 to 2196=> "000000000", 2197 => "100000000", 2198 => "000000000", 2199 => "100000000", 
    2200 to 2203=> "000000000", 2204 to 2206=> "100000000", 2207 to 2229=> "000000000", 2230 => "100000000", 
    2231 to 2237=> "000000000", 2238 => "100000000", 2239 to 2244=> "000000000", 2245 => "100000000", 
    2246 to 2251=> "000000000", 2252 to 2253=> "100000000", 2254 to 2263=> "000000000", 2264 to 2265=> "100000000", 
    2266 to 2272=> "000000000", 2273 => "100000000", 2274 => "000000000", 2275 => "100000000", 
    2276 to 2277=> "000000000", 2278 to 2279=> "100000000", 2280 to 2286=> "000000000", 2287 => "100000000", 
    2288 => "000000000", 2289 to 2292=> "100000000", 2293 to 2317=> "000000000", 2318 => "100000000", 
    2319 => "000000000", 2320 to 2322=> "100000000", 2323 to 2328=> "000000000", 2329 => "100000000", 
    2330 to 2336=> "000000000", 2337 to 2339=> "100000000", 2340 => "000000000", 2341 => "100000000", 
    2342 to 2345=> "000000000", 2346 to 2347=> "100000000", 2348 to 2349=> "000000000", 2350 to 2351=> "100000000", 
    2352 to 2353=> "000000000", 2354 => "100000000", 2355 => "000000000", 2356 => "100000000", 
    2357 to 2364=> "000000000", 2365 => "100000000", 2366 to 2367=> "000000000", 2368 to 2369=> "100000000", 
    2370 to 2373=> "000000000", 2374 => "100000000", 2375 to 2377=> "000000000", 2378 => "100000000", 
    2379 to 2381=> "000000000", 2382 to 2383=> "100000000", 2384 to 2385=> "000000000", 2386 => "100000000", 
    2387 to 2394=> "000000000", 2395 => "100000000", 2396 to 2411=> "000000000", 2412 => "100000000", 
    2413 to 2424=> "000000000", 2425 => "100000000", 2426 to 2427=> "000000000", 2428 to 2429=> "100000000", 
    2430 to 2432=> "000000000", 2433 => "100000000", 2434 to 2435=> "000000000", 2436 to 2438=> "100000000", 
    2439 to 2440=> "000000000", 2441 => "100000000", 2442 to 2444=> "000000000", 2445 => "100000000", 
    2446 to 2447=> "000000000", 2448 => "100000000", 2449 to 2455=> "000000000", 2456 to 2457=> "100000000", 
    2458 to 2459=> "000000000", 2460 => "100000000", 2461 to 2462=> "000000000", 2463 => "100000000", 
    2464 to 2478=> "000000000", 2479 => "100000000", 2480 to 2484=> "000000000", 2485 => "100000000", 
    2486 to 2489=> "000000000", 2490 to 2493=> "100000000", 2494 to 2495=> "000000000", 2496 => "100000000", 
    2497 to 2500=> "000000000", 2501 => "100000000", 2502 to 2509=> "000000000", 2510 to 2511=> "100000000", 
    2512 => "000000000", 2513 => "100000000", 2514 to 2534=> "000000000", 2535 to 2537=> "100000000", 
    2538 => "000000000", 2539 to 2540=> "100000000", 2541 => "000000000", 2542 to 2544=> "100000000", 
    2545 to 2552=> "000000000", 2553 => "100000000", 2554 => "000000000", 2555 => "100000000", 
    2556 to 2567=> "000000000", 2568 => "100000000", 2569 to 2579=> "000000000", 2580 to 2584=> "100000000", 
    2585 to 2586=> "000000000", 2587 => "100000000", 2588 => "000000000", 2589 to 2590=> "100000000", 
    2591 => "000000000", 2592 => "100000000", 2593 to 2594=> "000000000", 2595 => "100000000", 
    2596 => "000000000", 2597 to 2598=> "100000000", 2599 to 2607=> "000000000", 2608 => "100000000", 
    2609 to 2610=> "000000000", 2611 to 2612=> "100000000", 2613 to 2615=> "000000000", 2616 => "100000000", 
    2617 to 2625=> "000000000", 2626 => "100000000", 2627 to 2640=> "000000000", 2641 to 2642=> "100000000", 
    2643 to 2644=> "000000000", 2645 to 2646=> "100000000", 2647 => "000000000", 2648 => "100000000", 
    2649 to 2652=> "000000000", 2653 => "100000000", 2654 to 2655=> "000000000", 2656 => "100000000", 
    2657 to 2669=> "000000000", 2670 to 2671=> "100000000", 2672 to 2673=> "000000000", 2674 to 2675=> "100000000", 
    2676 to 2678=> "000000000", 2679 => "100000000", 2680 to 2705=> "000000000", 2706 to 2707=> "100000000", 
    2708 to 2710=> "000000000", 2711 => "100000000", 2712 to 2717=> "000000000", 2718 => "100000000", 
    2719 to 2722=> "000000000", 2723 => "100000000", 2724 to 2727=> "000000000", 2728 => "100000000", 
    2729 to 2756=> "000000000", 2757 => "100000000", 2758 => "000000000", 2759 => "100000000", 
    2760 to 2768=> "000000000", 2769 to 2771=> "100000000", 2772 to 2773=> "000000000", 2774 => "100000000", 
    2775 => "000000000", 2776 to 2779=> "100000000", 2780 to 2785=> "000000000", 2786 => "100000000", 
    2787 to 2793=> "000000000", 2794 to 2795=> "100000000", 2796 => "000000000", 2797 to 2801=> "100000000", 
    2802 to 2815=> "000000000", 2816 to 2817=> "100000000", 2818 to 2825=> "000000000", 2826 => "100000000", 
    2827 to 2831=> "000000000", 2832 => "100000000", 2833 to 2837=> "000000000", 2838 => "100000000", 
    2839 to 2845=> "000000000", 2846 => "100000000", 2847 to 2850=> "000000000", 2851 => "100000000", 
    2852 to 2856=> "000000000", 2857 to 2858=> "100000000", 2859 to 2865=> "000000000", 2866 => "100000000", 
    2867 to 2874=> "000000000", 2875 to 2883=> "100000000", 2884 to 2893=> "000000000", 2894 to 2895=> "100000000", 
    2896 to 2897=> "000000000", 2898 to 2899=> "100000000", 2900 => "000000000", 2901 => "100000000", 
    2902 to 2911=> "000000000", 2912 => "100000000" );


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

entity cascade_classifieudo is
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

architecture arch of cascade_classifieudo is
    component cascade_classifieudo_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    cascade_classifieudo_rom_U :  component cascade_classifieudo_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;

