
#include "ctype_test.h"
void t_isxdigit_0x00()
{
    Assert(isxdigit(0)  == 0 ,"isxdigit should be 0 for 0x00");
}

void t_isxdigit_0x01()
{
    Assert(isxdigit(1)  == 0 ,"isxdigit should be 0 for 0x01");
}

void t_isxdigit_0x02()
{
    Assert(isxdigit(2)  == 0 ,"isxdigit should be 0 for 0x02");
}

void t_isxdigit_0x03()
{
    Assert(isxdigit(3)  == 0 ,"isxdigit should be 0 for 0x03");
}

void t_isxdigit_0x04()
{
    Assert(isxdigit(4)  == 0 ,"isxdigit should be 0 for 0x04");
}

void t_isxdigit_0x05()
{
    Assert(isxdigit(5)  == 0 ,"isxdigit should be 0 for 0x05");
}

void t_isxdigit_0x06()
{
    Assert(isxdigit(6)  == 0 ,"isxdigit should be 0 for 0x06");
}

void t_isxdigit_0x07()
{
    Assert(isxdigit(7)  == 0 ,"isxdigit should be 0 for 0x07");
}

void t_isxdigit_0x08()
{
    Assert(isxdigit(8)  == 0 ,"isxdigit should be 0 for 0x08");
}

void t_isxdigit_0x09()
{
    Assert(isxdigit(9)  == 0 ,"isxdigit should be 0 for 0x09");
}

void t_isxdigit_0x0a()
{
    Assert(isxdigit(10)  == 0 ,"isxdigit should be 0 for 0x0a");
}

void t_isxdigit_0x0b()
{
    Assert(isxdigit(11)  == 0 ,"isxdigit should be 0 for 0x0b");
}

void t_isxdigit_0x0c()
{
    Assert(isxdigit(12)  == 0 ,"isxdigit should be 0 for 0x0c");
}

void t_isxdigit_0x0d()
{
    Assert(isxdigit(13)  == 0 ,"isxdigit should be 0 for 0x0d");
}

void t_isxdigit_0x0e()
{
    Assert(isxdigit(14)  == 0 ,"isxdigit should be 0 for 0x0e");
}

void t_isxdigit_0x0f()
{
    Assert(isxdigit(15)  == 0 ,"isxdigit should be 0 for 0x0f");
}

void t_isxdigit_0x10()
{
    Assert(isxdigit(16)  == 0 ,"isxdigit should be 0 for 0x10");
}

void t_isxdigit_0x11()
{
    Assert(isxdigit(17)  == 0 ,"isxdigit should be 0 for 0x11");
}

void t_isxdigit_0x12()
{
    Assert(isxdigit(18)  == 0 ,"isxdigit should be 0 for 0x12");
}

void t_isxdigit_0x13()
{
    Assert(isxdigit(19)  == 0 ,"isxdigit should be 0 for 0x13");
}

void t_isxdigit_0x14()
{
    Assert(isxdigit(20)  == 0 ,"isxdigit should be 0 for 0x14");
}

void t_isxdigit_0x15()
{
    Assert(isxdigit(21)  == 0 ,"isxdigit should be 0 for 0x15");
}

void t_isxdigit_0x16()
{
    Assert(isxdigit(22)  == 0 ,"isxdigit should be 0 for 0x16");
}

void t_isxdigit_0x17()
{
    Assert(isxdigit(23)  == 0 ,"isxdigit should be 0 for 0x17");
}

void t_isxdigit_0x18()
{
    Assert(isxdigit(24)  == 0 ,"isxdigit should be 0 for 0x18");
}

void t_isxdigit_0x19()
{
    Assert(isxdigit(25)  == 0 ,"isxdigit should be 0 for 0x19");
}

void t_isxdigit_0x1a()
{
    Assert(isxdigit(26)  == 0 ,"isxdigit should be 0 for 0x1a");
}

void t_isxdigit_0x1b()
{
    Assert(isxdigit(27)  == 0 ,"isxdigit should be 0 for 0x1b");
}

void t_isxdigit_0x1c()
{
    Assert(isxdigit(28)  == 0 ,"isxdigit should be 0 for 0x1c");
}

void t_isxdigit_0x1d()
{
    Assert(isxdigit(29)  == 0 ,"isxdigit should be 0 for 0x1d");
}

void t_isxdigit_0x1e()
{
    Assert(isxdigit(30)  == 0 ,"isxdigit should be 0 for 0x1e");
}

void t_isxdigit_0x1f()
{
    Assert(isxdigit(31)  == 0 ,"isxdigit should be 0 for 0x1f");
}

void t_isxdigit_0x20()
{
    Assert(isxdigit(32)  == 0 ,"isxdigit should be 0 for  ");
}

void t_isxdigit_0x21()
{
    Assert(isxdigit(33)  == 0 ,"isxdigit should be 0 for !");
}

void t_isxdigit_0x22()
{
    Assert(isxdigit(34)  == 0 ,"isxdigit should be 0 for 0x22");
}

void t_isxdigit_0x23()
{
    Assert(isxdigit(35)  == 0 ,"isxdigit should be 0 for #");
}

void t_isxdigit_0x24()
{
    Assert(isxdigit(36)  == 0 ,"isxdigit should be 0 for $");
}

void t_isxdigit_0x25()
{
    Assert(isxdigit(37)  == 0 ,"isxdigit should be 0 for %");
}

void t_isxdigit_0x26()
{
    Assert(isxdigit(38)  == 0 ,"isxdigit should be 0 for &");
}

void t_isxdigit_0x27()
{
    Assert(isxdigit(39)  == 0 ,"isxdigit should be 0 for '");
}

void t_isxdigit_0x28()
{
    Assert(isxdigit(40)  == 0 ,"isxdigit should be 0 for (");
}

void t_isxdigit_0x29()
{
    Assert(isxdigit(41)  == 0 ,"isxdigit should be 0 for )");
}

void t_isxdigit_0x2a()
{
    Assert(isxdigit(42)  == 0 ,"isxdigit should be 0 for *");
}

void t_isxdigit_0x2b()
{
    Assert(isxdigit(43)  == 0 ,"isxdigit should be 0 for +");
}

void t_isxdigit_0x2c()
{
    Assert(isxdigit(44)  == 0 ,"isxdigit should be 0 for ,");
}

void t_isxdigit_0x2d()
{
    Assert(isxdigit(45)  == 0 ,"isxdigit should be 0 for -");
}

void t_isxdigit_0x2e()
{
    Assert(isxdigit(46)  == 0 ,"isxdigit should be 0 for .");
}

void t_isxdigit_0x2f()
{
    Assert(isxdigit(47)  == 0 ,"isxdigit should be 0 for /");
}

void t_isxdigit_0x30()
{
    Assert(isxdigit(48) ,"isxdigit should be 1 for 0");
}

void t_isxdigit_0x31()
{
    Assert(isxdigit(49) ,"isxdigit should be 1 for 1");
}

void t_isxdigit_0x32()
{
    Assert(isxdigit(50) ,"isxdigit should be 1 for 2");
}

void t_isxdigit_0x33()
{
    Assert(isxdigit(51) ,"isxdigit should be 1 for 3");
}

void t_isxdigit_0x34()
{
    Assert(isxdigit(52) ,"isxdigit should be 1 for 4");
}

void t_isxdigit_0x35()
{
    Assert(isxdigit(53) ,"isxdigit should be 1 for 5");
}

void t_isxdigit_0x36()
{
    Assert(isxdigit(54) ,"isxdigit should be 1 for 6");
}

void t_isxdigit_0x37()
{
    Assert(isxdigit(55) ,"isxdigit should be 1 for 7");
}

void t_isxdigit_0x38()
{
    Assert(isxdigit(56) ,"isxdigit should be 1 for 8");
}

void t_isxdigit_0x39()
{
    Assert(isxdigit(57) ,"isxdigit should be 1 for 9");
}

void t_isxdigit_0x3a()
{
    Assert(isxdigit(58)  == 0 ,"isxdigit should be 0 for :");
}

void t_isxdigit_0x3b()
{
    Assert(isxdigit(59)  == 0 ,"isxdigit should be 0 for ;");
}

void t_isxdigit_0x3c()
{
    Assert(isxdigit(60)  == 0 ,"isxdigit should be 0 for <");
}

void t_isxdigit_0x3d()
{
    Assert(isxdigit(61)  == 0 ,"isxdigit should be 0 for =");
}

void t_isxdigit_0x3e()
{
    Assert(isxdigit(62)  == 0 ,"isxdigit should be 0 for >");
}

void t_isxdigit_0x3f()
{
    Assert(isxdigit(63)  == 0 ,"isxdigit should be 0 for ?");
}

void t_isxdigit_0x40()
{
    Assert(isxdigit(64)  == 0 ,"isxdigit should be 0 for @");
}

void t_isxdigit_0x41()
{
    Assert(isxdigit(65) ,"isxdigit should be 1 for A");
}

void t_isxdigit_0x42()
{
    Assert(isxdigit(66) ,"isxdigit should be 1 for B");
}

void t_isxdigit_0x43()
{
    Assert(isxdigit(67) ,"isxdigit should be 1 for C");
}

void t_isxdigit_0x44()
{
    Assert(isxdigit(68) ,"isxdigit should be 1 for D");
}

void t_isxdigit_0x45()
{
    Assert(isxdigit(69) ,"isxdigit should be 1 for E");
}

void t_isxdigit_0x46()
{
    Assert(isxdigit(70) ,"isxdigit should be 1 for F");
}

void t_isxdigit_0x47()
{
    Assert(isxdigit(71)  == 0 ,"isxdigit should be 0 for G");
}

void t_isxdigit_0x48()
{
    Assert(isxdigit(72)  == 0 ,"isxdigit should be 0 for H");
}

void t_isxdigit_0x49()
{
    Assert(isxdigit(73)  == 0 ,"isxdigit should be 0 for I");
}

void t_isxdigit_0x4a()
{
    Assert(isxdigit(74)  == 0 ,"isxdigit should be 0 for J");
}

void t_isxdigit_0x4b()
{
    Assert(isxdigit(75)  == 0 ,"isxdigit should be 0 for K");
}

void t_isxdigit_0x4c()
{
    Assert(isxdigit(76)  == 0 ,"isxdigit should be 0 for L");
}

void t_isxdigit_0x4d()
{
    Assert(isxdigit(77)  == 0 ,"isxdigit should be 0 for M");
}

void t_isxdigit_0x4e()
{
    Assert(isxdigit(78)  == 0 ,"isxdigit should be 0 for N");
}

void t_isxdigit_0x4f()
{
    Assert(isxdigit(79)  == 0 ,"isxdigit should be 0 for O");
}

void t_isxdigit_0x50()
{
    Assert(isxdigit(80)  == 0 ,"isxdigit should be 0 for P");
}

void t_isxdigit_0x51()
{
    Assert(isxdigit(81)  == 0 ,"isxdigit should be 0 for Q");
}

void t_isxdigit_0x52()
{
    Assert(isxdigit(82)  == 0 ,"isxdigit should be 0 for R");
}

void t_isxdigit_0x53()
{
    Assert(isxdigit(83)  == 0 ,"isxdigit should be 0 for S");
}

void t_isxdigit_0x54()
{
    Assert(isxdigit(84)  == 0 ,"isxdigit should be 0 for T");
}

void t_isxdigit_0x55()
{
    Assert(isxdigit(85)  == 0 ,"isxdigit should be 0 for U");
}

void t_isxdigit_0x56()
{
    Assert(isxdigit(86)  == 0 ,"isxdigit should be 0 for V");
}

void t_isxdigit_0x57()
{
    Assert(isxdigit(87)  == 0 ,"isxdigit should be 0 for W");
}

void t_isxdigit_0x58()
{
    Assert(isxdigit(88)  == 0 ,"isxdigit should be 0 for X");
}

void t_isxdigit_0x59()
{
    Assert(isxdigit(89)  == 0 ,"isxdigit should be 0 for Y");
}

void t_isxdigit_0x5a()
{
    Assert(isxdigit(90)  == 0 ,"isxdigit should be 0 for Z");
}

void t_isxdigit_0x5b()
{
    Assert(isxdigit(91)  == 0 ,"isxdigit should be 0 for [");
}

void t_isxdigit_0x5c()
{
    Assert(isxdigit(92)  == 0 ,"isxdigit should be 0 for 0x5c");
}

void t_isxdigit_0x5d()
{
    Assert(isxdigit(93)  == 0 ,"isxdigit should be 0 for ]");
}

void t_isxdigit_0x5e()
{
    Assert(isxdigit(94)  == 0 ,"isxdigit should be 0 for ^");
}

void t_isxdigit_0x5f()
{
    Assert(isxdigit(95)  == 0 ,"isxdigit should be 0 for _");
}

void t_isxdigit_0x60()
{
    Assert(isxdigit(96)  == 0 ,"isxdigit should be 0 for `");
}

void t_isxdigit_0x61()
{
    Assert(isxdigit(97) ,"isxdigit should be 1 for a");
}

void t_isxdigit_0x62()
{
    Assert(isxdigit(98) ,"isxdigit should be 1 for b");
}

void t_isxdigit_0x63()
{
    Assert(isxdigit(99) ,"isxdigit should be 1 for c");
}

void t_isxdigit_0x64()
{
    Assert(isxdigit(100) ,"isxdigit should be 1 for d");
}

void t_isxdigit_0x65()
{
    Assert(isxdigit(101) ,"isxdigit should be 1 for e");
}

void t_isxdigit_0x66()
{
    Assert(isxdigit(102) ,"isxdigit should be 1 for f");
}

void t_isxdigit_0x67()
{
    Assert(isxdigit(103)  == 0 ,"isxdigit should be 0 for g");
}

void t_isxdigit_0x68()
{
    Assert(isxdigit(104)  == 0 ,"isxdigit should be 0 for h");
}

void t_isxdigit_0x69()
{
    Assert(isxdigit(105)  == 0 ,"isxdigit should be 0 for i");
}

void t_isxdigit_0x6a()
{
    Assert(isxdigit(106)  == 0 ,"isxdigit should be 0 for j");
}

void t_isxdigit_0x6b()
{
    Assert(isxdigit(107)  == 0 ,"isxdigit should be 0 for k");
}

void t_isxdigit_0x6c()
{
    Assert(isxdigit(108)  == 0 ,"isxdigit should be 0 for l");
}

void t_isxdigit_0x6d()
{
    Assert(isxdigit(109)  == 0 ,"isxdigit should be 0 for m");
}

void t_isxdigit_0x6e()
{
    Assert(isxdigit(110)  == 0 ,"isxdigit should be 0 for n");
}

void t_isxdigit_0x6f()
{
    Assert(isxdigit(111)  == 0 ,"isxdigit should be 0 for o");
}

void t_isxdigit_0x70()
{
    Assert(isxdigit(112)  == 0 ,"isxdigit should be 0 for p");
}

void t_isxdigit_0x71()
{
    Assert(isxdigit(113)  == 0 ,"isxdigit should be 0 for q");
}

void t_isxdigit_0x72()
{
    Assert(isxdigit(114)  == 0 ,"isxdigit should be 0 for r");
}

void t_isxdigit_0x73()
{
    Assert(isxdigit(115)  == 0 ,"isxdigit should be 0 for s");
}

void t_isxdigit_0x74()
{
    Assert(isxdigit(116)  == 0 ,"isxdigit should be 0 for t");
}

void t_isxdigit_0x75()
{
    Assert(isxdigit(117)  == 0 ,"isxdigit should be 0 for u");
}

void t_isxdigit_0x76()
{
    Assert(isxdigit(118)  == 0 ,"isxdigit should be 0 for v");
}

void t_isxdigit_0x77()
{
    Assert(isxdigit(119)  == 0 ,"isxdigit should be 0 for w");
}

void t_isxdigit_0x78()
{
    Assert(isxdigit(120)  == 0 ,"isxdigit should be 0 for x");
}

void t_isxdigit_0x79()
{
    Assert(isxdigit(121)  == 0 ,"isxdigit should be 0 for y");
}

void t_isxdigit_0x7a()
{
    Assert(isxdigit(122)  == 0 ,"isxdigit should be 0 for z");
}

void t_isxdigit_0x7b()
{
    Assert(isxdigit(123)  == 0 ,"isxdigit should be 0 for {");
}

void t_isxdigit_0x7c()
{
    Assert(isxdigit(124)  == 0 ,"isxdigit should be 0 for |");
}

void t_isxdigit_0x7d()
{
    Assert(isxdigit(125)  == 0 ,"isxdigit should be 0 for }");
}

void t_isxdigit_0x7e()
{
    Assert(isxdigit(126)  == 0 ,"isxdigit should be 0 for ~");
}

void t_isxdigit_0x7f()
{
    Assert(isxdigit(127)  == 0 ,"isxdigit should be 0 for 0x7f");
}

void t_isxdigit_0x80()
{
    Assert(isxdigit(128)  == 0 ,"isxdigit should be 0 for 0x80");
}

void t_isxdigit_0x81()
{
    Assert(isxdigit(129)  == 0 ,"isxdigit should be 0 for 0x81");
}

void t_isxdigit_0x82()
{
    Assert(isxdigit(130)  == 0 ,"isxdigit should be 0 for 0x82");
}

void t_isxdigit_0x83()
{
    Assert(isxdigit(131)  == 0 ,"isxdigit should be 0 for 0x83");
}

void t_isxdigit_0x84()
{
    Assert(isxdigit(132)  == 0 ,"isxdigit should be 0 for 0x84");
}

void t_isxdigit_0x85()
{
    Assert(isxdigit(133)  == 0 ,"isxdigit should be 0 for 0x85");
}

void t_isxdigit_0x86()
{
    Assert(isxdigit(134)  == 0 ,"isxdigit should be 0 for 0x86");
}

void t_isxdigit_0x87()
{
    Assert(isxdigit(135)  == 0 ,"isxdigit should be 0 for 0x87");
}

void t_isxdigit_0x88()
{
    Assert(isxdigit(136)  == 0 ,"isxdigit should be 0 for 0x88");
}

void t_isxdigit_0x89()
{
    Assert(isxdigit(137)  == 0 ,"isxdigit should be 0 for 0x89");
}

void t_isxdigit_0x8a()
{
    Assert(isxdigit(138)  == 0 ,"isxdigit should be 0 for 0x8a");
}

void t_isxdigit_0x8b()
{
    Assert(isxdigit(139)  == 0 ,"isxdigit should be 0 for 0x8b");
}

void t_isxdigit_0x8c()
{
    Assert(isxdigit(140)  == 0 ,"isxdigit should be 0 for 0x8c");
}

void t_isxdigit_0x8d()
{
    Assert(isxdigit(141)  == 0 ,"isxdigit should be 0 for 0x8d");
}

void t_isxdigit_0x8e()
{
    Assert(isxdigit(142)  == 0 ,"isxdigit should be 0 for 0x8e");
}

void t_isxdigit_0x8f()
{
    Assert(isxdigit(143)  == 0 ,"isxdigit should be 0 for 0x8f");
}

void t_isxdigit_0x90()
{
    Assert(isxdigit(144)  == 0 ,"isxdigit should be 0 for 0x90");
}

void t_isxdigit_0x91()
{
    Assert(isxdigit(145)  == 0 ,"isxdigit should be 0 for 0x91");
}

void t_isxdigit_0x92()
{
    Assert(isxdigit(146)  == 0 ,"isxdigit should be 0 for 0x92");
}

void t_isxdigit_0x93()
{
    Assert(isxdigit(147)  == 0 ,"isxdigit should be 0 for 0x93");
}

void t_isxdigit_0x94()
{
    Assert(isxdigit(148)  == 0 ,"isxdigit should be 0 for 0x94");
}

void t_isxdigit_0x95()
{
    Assert(isxdigit(149)  == 0 ,"isxdigit should be 0 for 0x95");
}

void t_isxdigit_0x96()
{
    Assert(isxdigit(150)  == 0 ,"isxdigit should be 0 for 0x96");
}

void t_isxdigit_0x97()
{
    Assert(isxdigit(151)  == 0 ,"isxdigit should be 0 for 0x97");
}

void t_isxdigit_0x98()
{
    Assert(isxdigit(152)  == 0 ,"isxdigit should be 0 for 0x98");
}

void t_isxdigit_0x99()
{
    Assert(isxdigit(153)  == 0 ,"isxdigit should be 0 for 0x99");
}

void t_isxdigit_0x9a()
{
    Assert(isxdigit(154)  == 0 ,"isxdigit should be 0 for 0x9a");
}

void t_isxdigit_0x9b()
{
    Assert(isxdigit(155)  == 0 ,"isxdigit should be 0 for 0x9b");
}

void t_isxdigit_0x9c()
{
    Assert(isxdigit(156)  == 0 ,"isxdigit should be 0 for 0x9c");
}

void t_isxdigit_0x9d()
{
    Assert(isxdigit(157)  == 0 ,"isxdigit should be 0 for 0x9d");
}

void t_isxdigit_0x9e()
{
    Assert(isxdigit(158)  == 0 ,"isxdigit should be 0 for 0x9e");
}

void t_isxdigit_0x9f()
{
    Assert(isxdigit(159)  == 0 ,"isxdigit should be 0 for 0x9f");
}

void t_isxdigit_0xa0()
{
    Assert(isxdigit(160)  == 0 ,"isxdigit should be 0 for 0xa0");
}

void t_isxdigit_0xa1()
{
    Assert(isxdigit(161)  == 0 ,"isxdigit should be 0 for 0xa1");
}

void t_isxdigit_0xa2()
{
    Assert(isxdigit(162)  == 0 ,"isxdigit should be 0 for 0xa2");
}

void t_isxdigit_0xa3()
{
    Assert(isxdigit(163)  == 0 ,"isxdigit should be 0 for 0xa3");
}

void t_isxdigit_0xa4()
{
    Assert(isxdigit(164)  == 0 ,"isxdigit should be 0 for 0xa4");
}

void t_isxdigit_0xa5()
{
    Assert(isxdigit(165)  == 0 ,"isxdigit should be 0 for 0xa5");
}

void t_isxdigit_0xa6()
{
    Assert(isxdigit(166)  == 0 ,"isxdigit should be 0 for 0xa6");
}

void t_isxdigit_0xa7()
{
    Assert(isxdigit(167)  == 0 ,"isxdigit should be 0 for 0xa7");
}

void t_isxdigit_0xa8()
{
    Assert(isxdigit(168)  == 0 ,"isxdigit should be 0 for 0xa8");
}

void t_isxdigit_0xa9()
{
    Assert(isxdigit(169)  == 0 ,"isxdigit should be 0 for 0xa9");
}

void t_isxdigit_0xaa()
{
    Assert(isxdigit(170)  == 0 ,"isxdigit should be 0 for 0xaa");
}

void t_isxdigit_0xab()
{
    Assert(isxdigit(171)  == 0 ,"isxdigit should be 0 for 0xab");
}

void t_isxdigit_0xac()
{
    Assert(isxdigit(172)  == 0 ,"isxdigit should be 0 for 0xac");
}

void t_isxdigit_0xad()
{
    Assert(isxdigit(173)  == 0 ,"isxdigit should be 0 for 0xad");
}

void t_isxdigit_0xae()
{
    Assert(isxdigit(174)  == 0 ,"isxdigit should be 0 for 0xae");
}

void t_isxdigit_0xaf()
{
    Assert(isxdigit(175)  == 0 ,"isxdigit should be 0 for 0xaf");
}

void t_isxdigit_0xb0()
{
    Assert(isxdigit(176)  == 0 ,"isxdigit should be 0 for 0xb0");
}

void t_isxdigit_0xb1()
{
    Assert(isxdigit(177)  == 0 ,"isxdigit should be 0 for 0xb1");
}

void t_isxdigit_0xb2()
{
    Assert(isxdigit(178)  == 0 ,"isxdigit should be 0 for 0xb2");
}

void t_isxdigit_0xb3()
{
    Assert(isxdigit(179)  == 0 ,"isxdigit should be 0 for 0xb3");
}

void t_isxdigit_0xb4()
{
    Assert(isxdigit(180)  == 0 ,"isxdigit should be 0 for 0xb4");
}

void t_isxdigit_0xb5()
{
    Assert(isxdigit(181)  == 0 ,"isxdigit should be 0 for 0xb5");
}

void t_isxdigit_0xb6()
{
    Assert(isxdigit(182)  == 0 ,"isxdigit should be 0 for 0xb6");
}

void t_isxdigit_0xb7()
{
    Assert(isxdigit(183)  == 0 ,"isxdigit should be 0 for 0xb7");
}

void t_isxdigit_0xb8()
{
    Assert(isxdigit(184)  == 0 ,"isxdigit should be 0 for 0xb8");
}

void t_isxdigit_0xb9()
{
    Assert(isxdigit(185)  == 0 ,"isxdigit should be 0 for 0xb9");
}

void t_isxdigit_0xba()
{
    Assert(isxdigit(186)  == 0 ,"isxdigit should be 0 for 0xba");
}

void t_isxdigit_0xbb()
{
    Assert(isxdigit(187)  == 0 ,"isxdigit should be 0 for 0xbb");
}

void t_isxdigit_0xbc()
{
    Assert(isxdigit(188)  == 0 ,"isxdigit should be 0 for 0xbc");
}

void t_isxdigit_0xbd()
{
    Assert(isxdigit(189)  == 0 ,"isxdigit should be 0 for 0xbd");
}

void t_isxdigit_0xbe()
{
    Assert(isxdigit(190)  == 0 ,"isxdigit should be 0 for 0xbe");
}

void t_isxdigit_0xbf()
{
    Assert(isxdigit(191)  == 0 ,"isxdigit should be 0 for 0xbf");
}

void t_isxdigit_0xc0()
{
    Assert(isxdigit(192)  == 0 ,"isxdigit should be 0 for 0xc0");
}

void t_isxdigit_0xc1()
{
    Assert(isxdigit(193)  == 0 ,"isxdigit should be 0 for 0xc1");
}

void t_isxdigit_0xc2()
{
    Assert(isxdigit(194)  == 0 ,"isxdigit should be 0 for 0xc2");
}

void t_isxdigit_0xc3()
{
    Assert(isxdigit(195)  == 0 ,"isxdigit should be 0 for 0xc3");
}

void t_isxdigit_0xc4()
{
    Assert(isxdigit(196)  == 0 ,"isxdigit should be 0 for 0xc4");
}

void t_isxdigit_0xc5()
{
    Assert(isxdigit(197)  == 0 ,"isxdigit should be 0 for 0xc5");
}

void t_isxdigit_0xc6()
{
    Assert(isxdigit(198)  == 0 ,"isxdigit should be 0 for 0xc6");
}

void t_isxdigit_0xc7()
{
    Assert(isxdigit(199)  == 0 ,"isxdigit should be 0 for 0xc7");
}

void t_isxdigit_0xc8()
{
    Assert(isxdigit(200)  == 0 ,"isxdigit should be 0 for 0xc8");
}

void t_isxdigit_0xc9()
{
    Assert(isxdigit(201)  == 0 ,"isxdigit should be 0 for 0xc9");
}

void t_isxdigit_0xca()
{
    Assert(isxdigit(202)  == 0 ,"isxdigit should be 0 for 0xca");
}

void t_isxdigit_0xcb()
{
    Assert(isxdigit(203)  == 0 ,"isxdigit should be 0 for 0xcb");
}

void t_isxdigit_0xcc()
{
    Assert(isxdigit(204)  == 0 ,"isxdigit should be 0 for 0xcc");
}

void t_isxdigit_0xcd()
{
    Assert(isxdigit(205)  == 0 ,"isxdigit should be 0 for 0xcd");
}

void t_isxdigit_0xce()
{
    Assert(isxdigit(206)  == 0 ,"isxdigit should be 0 for 0xce");
}

void t_isxdigit_0xcf()
{
    Assert(isxdigit(207)  == 0 ,"isxdigit should be 0 for 0xcf");
}

void t_isxdigit_0xd0()
{
    Assert(isxdigit(208)  == 0 ,"isxdigit should be 0 for 0xd0");
}

void t_isxdigit_0xd1()
{
    Assert(isxdigit(209)  == 0 ,"isxdigit should be 0 for 0xd1");
}

void t_isxdigit_0xd2()
{
    Assert(isxdigit(210)  == 0 ,"isxdigit should be 0 for 0xd2");
}

void t_isxdigit_0xd3()
{
    Assert(isxdigit(211)  == 0 ,"isxdigit should be 0 for 0xd3");
}

void t_isxdigit_0xd4()
{
    Assert(isxdigit(212)  == 0 ,"isxdigit should be 0 for 0xd4");
}

void t_isxdigit_0xd5()
{
    Assert(isxdigit(213)  == 0 ,"isxdigit should be 0 for 0xd5");
}

void t_isxdigit_0xd6()
{
    Assert(isxdigit(214)  == 0 ,"isxdigit should be 0 for 0xd6");
}

void t_isxdigit_0xd7()
{
    Assert(isxdigit(215)  == 0 ,"isxdigit should be 0 for 0xd7");
}

void t_isxdigit_0xd8()
{
    Assert(isxdigit(216)  == 0 ,"isxdigit should be 0 for 0xd8");
}

void t_isxdigit_0xd9()
{
    Assert(isxdigit(217)  == 0 ,"isxdigit should be 0 for 0xd9");
}

void t_isxdigit_0xda()
{
    Assert(isxdigit(218)  == 0 ,"isxdigit should be 0 for 0xda");
}

void t_isxdigit_0xdb()
{
    Assert(isxdigit(219)  == 0 ,"isxdigit should be 0 for 0xdb");
}

void t_isxdigit_0xdc()
{
    Assert(isxdigit(220)  == 0 ,"isxdigit should be 0 for 0xdc");
}

void t_isxdigit_0xdd()
{
    Assert(isxdigit(221)  == 0 ,"isxdigit should be 0 for 0xdd");
}

void t_isxdigit_0xde()
{
    Assert(isxdigit(222)  == 0 ,"isxdigit should be 0 for 0xde");
}

void t_isxdigit_0xdf()
{
    Assert(isxdigit(223)  == 0 ,"isxdigit should be 0 for 0xdf");
}

void t_isxdigit_0xe0()
{
    Assert(isxdigit(224)  == 0 ,"isxdigit should be 0 for 0xe0");
}

void t_isxdigit_0xe1()
{
    Assert(isxdigit(225)  == 0 ,"isxdigit should be 0 for 0xe1");
}

void t_isxdigit_0xe2()
{
    Assert(isxdigit(226)  == 0 ,"isxdigit should be 0 for 0xe2");
}

void t_isxdigit_0xe3()
{
    Assert(isxdigit(227)  == 0 ,"isxdigit should be 0 for 0xe3");
}

void t_isxdigit_0xe4()
{
    Assert(isxdigit(228)  == 0 ,"isxdigit should be 0 for 0xe4");
}

void t_isxdigit_0xe5()
{
    Assert(isxdigit(229)  == 0 ,"isxdigit should be 0 for 0xe5");
}

void t_isxdigit_0xe6()
{
    Assert(isxdigit(230)  == 0 ,"isxdigit should be 0 for 0xe6");
}

void t_isxdigit_0xe7()
{
    Assert(isxdigit(231)  == 0 ,"isxdigit should be 0 for 0xe7");
}

void t_isxdigit_0xe8()
{
    Assert(isxdigit(232)  == 0 ,"isxdigit should be 0 for 0xe8");
}

void t_isxdigit_0xe9()
{
    Assert(isxdigit(233)  == 0 ,"isxdigit should be 0 for 0xe9");
}

void t_isxdigit_0xea()
{
    Assert(isxdigit(234)  == 0 ,"isxdigit should be 0 for 0xea");
}

void t_isxdigit_0xeb()
{
    Assert(isxdigit(235)  == 0 ,"isxdigit should be 0 for 0xeb");
}

void t_isxdigit_0xec()
{
    Assert(isxdigit(236)  == 0 ,"isxdigit should be 0 for 0xec");
}

void t_isxdigit_0xed()
{
    Assert(isxdigit(237)  == 0 ,"isxdigit should be 0 for 0xed");
}

void t_isxdigit_0xee()
{
    Assert(isxdigit(238)  == 0 ,"isxdigit should be 0 for 0xee");
}

void t_isxdigit_0xef()
{
    Assert(isxdigit(239)  == 0 ,"isxdigit should be 0 for 0xef");
}

void t_isxdigit_0xf0()
{
    Assert(isxdigit(240)  == 0 ,"isxdigit should be 0 for 0xf0");
}

void t_isxdigit_0xf1()
{
    Assert(isxdigit(241)  == 0 ,"isxdigit should be 0 for 0xf1");
}

void t_isxdigit_0xf2()
{
    Assert(isxdigit(242)  == 0 ,"isxdigit should be 0 for 0xf2");
}

void t_isxdigit_0xf3()
{
    Assert(isxdigit(243)  == 0 ,"isxdigit should be 0 for 0xf3");
}

void t_isxdigit_0xf4()
{
    Assert(isxdigit(244)  == 0 ,"isxdigit should be 0 for 0xf4");
}

void t_isxdigit_0xf5()
{
    Assert(isxdigit(245)  == 0 ,"isxdigit should be 0 for 0xf5");
}

void t_isxdigit_0xf6()
{
    Assert(isxdigit(246)  == 0 ,"isxdigit should be 0 for 0xf6");
}

void t_isxdigit_0xf7()
{
    Assert(isxdigit(247)  == 0 ,"isxdigit should be 0 for 0xf7");
}

void t_isxdigit_0xf8()
{
    Assert(isxdigit(248)  == 0 ,"isxdigit should be 0 for 0xf8");
}

void t_isxdigit_0xf9()
{
    Assert(isxdigit(249)  == 0 ,"isxdigit should be 0 for 0xf9");
}

void t_isxdigit_0xfa()
{
    Assert(isxdigit(250)  == 0 ,"isxdigit should be 0 for 0xfa");
}

void t_isxdigit_0xfb()
{
    Assert(isxdigit(251)  == 0 ,"isxdigit should be 0 for 0xfb");
}

void t_isxdigit_0xfc()
{
    Assert(isxdigit(252)  == 0 ,"isxdigit should be 0 for 0xfc");
}

void t_isxdigit_0xfd()
{
    Assert(isxdigit(253)  == 0 ,"isxdigit should be 0 for 0xfd");
}

void t_isxdigit_0xfe()
{
    Assert(isxdigit(254)  == 0 ,"isxdigit should be 0 for 0xfe");
}

void t_isxdigit_0xff()
{
    Assert(isxdigit(255)  == 0 ,"isxdigit should be 0 for 0xff");
}



int test_isxdigit()
{
    suite_setup("isxdigit");
    suite_add_test(t_isxdigit_0x00);
    suite_add_test(t_isxdigit_0x01);
    suite_add_test(t_isxdigit_0x02);
    suite_add_test(t_isxdigit_0x03);
    suite_add_test(t_isxdigit_0x04);
    suite_add_test(t_isxdigit_0x05);
    suite_add_test(t_isxdigit_0x06);
    suite_add_test(t_isxdigit_0x07);
    suite_add_test(t_isxdigit_0x08);
    suite_add_test(t_isxdigit_0x09);
    suite_add_test(t_isxdigit_0x0a);
    suite_add_test(t_isxdigit_0x0b);
    suite_add_test(t_isxdigit_0x0c);
    suite_add_test(t_isxdigit_0x0d);
    suite_add_test(t_isxdigit_0x0e);
    suite_add_test(t_isxdigit_0x0f);
    suite_add_test(t_isxdigit_0x10);
    suite_add_test(t_isxdigit_0x11);
    suite_add_test(t_isxdigit_0x12);
    suite_add_test(t_isxdigit_0x13);
    suite_add_test(t_isxdigit_0x14);
    suite_add_test(t_isxdigit_0x15);
    suite_add_test(t_isxdigit_0x16);
    suite_add_test(t_isxdigit_0x17);
    suite_add_test(t_isxdigit_0x18);
    suite_add_test(t_isxdigit_0x19);
    suite_add_test(t_isxdigit_0x1a);
    suite_add_test(t_isxdigit_0x1b);
    suite_add_test(t_isxdigit_0x1c);
    suite_add_test(t_isxdigit_0x1d);
    suite_add_test(t_isxdigit_0x1e);
    suite_add_test(t_isxdigit_0x1f);
    suite_add_test(t_isxdigit_0x20);
    suite_add_test(t_isxdigit_0x21);
    suite_add_test(t_isxdigit_0x22);
    suite_add_test(t_isxdigit_0x23);
    suite_add_test(t_isxdigit_0x24);
    suite_add_test(t_isxdigit_0x25);
    suite_add_test(t_isxdigit_0x26);
    suite_add_test(t_isxdigit_0x27);
    suite_add_test(t_isxdigit_0x28);
    suite_add_test(t_isxdigit_0x29);
    suite_add_test(t_isxdigit_0x2a);
    suite_add_test(t_isxdigit_0x2b);
    suite_add_test(t_isxdigit_0x2c);
    suite_add_test(t_isxdigit_0x2d);
    suite_add_test(t_isxdigit_0x2e);
    suite_add_test(t_isxdigit_0x2f);
    suite_add_test(t_isxdigit_0x30);
    suite_add_test(t_isxdigit_0x31);
    suite_add_test(t_isxdigit_0x32);
    suite_add_test(t_isxdigit_0x33);
    suite_add_test(t_isxdigit_0x34);
    suite_add_test(t_isxdigit_0x35);
    suite_add_test(t_isxdigit_0x36);
    suite_add_test(t_isxdigit_0x37);
    suite_add_test(t_isxdigit_0x38);
    suite_add_test(t_isxdigit_0x39);
    suite_add_test(t_isxdigit_0x3a);
    suite_add_test(t_isxdigit_0x3b);
    suite_add_test(t_isxdigit_0x3c);
    suite_add_test(t_isxdigit_0x3d);
    suite_add_test(t_isxdigit_0x3e);
    suite_add_test(t_isxdigit_0x3f);
    suite_add_test(t_isxdigit_0x40);
    suite_add_test(t_isxdigit_0x41);
    suite_add_test(t_isxdigit_0x42);
    suite_add_test(t_isxdigit_0x43);
    suite_add_test(t_isxdigit_0x44);
    suite_add_test(t_isxdigit_0x45);
    suite_add_test(t_isxdigit_0x46);
    suite_add_test(t_isxdigit_0x47);
    suite_add_test(t_isxdigit_0x48);
    suite_add_test(t_isxdigit_0x49);
    suite_add_test(t_isxdigit_0x4a);
    suite_add_test(t_isxdigit_0x4b);
    suite_add_test(t_isxdigit_0x4c);
    suite_add_test(t_isxdigit_0x4d);
    suite_add_test(t_isxdigit_0x4e);
    suite_add_test(t_isxdigit_0x4f);
    suite_add_test(t_isxdigit_0x50);
    suite_add_test(t_isxdigit_0x51);
    suite_add_test(t_isxdigit_0x52);
    suite_add_test(t_isxdigit_0x53);
    suite_add_test(t_isxdigit_0x54);
    suite_add_test(t_isxdigit_0x55);
    suite_add_test(t_isxdigit_0x56);
    suite_add_test(t_isxdigit_0x57);
    suite_add_test(t_isxdigit_0x58);
    suite_add_test(t_isxdigit_0x59);
    suite_add_test(t_isxdigit_0x5a);
    suite_add_test(t_isxdigit_0x5b);
    suite_add_test(t_isxdigit_0x5c);
    suite_add_test(t_isxdigit_0x5d);
    suite_add_test(t_isxdigit_0x5e);
    suite_add_test(t_isxdigit_0x5f);
    suite_add_test(t_isxdigit_0x60);
    suite_add_test(t_isxdigit_0x61);
    suite_add_test(t_isxdigit_0x62);
    suite_add_test(t_isxdigit_0x63);
    suite_add_test(t_isxdigit_0x64);
    suite_add_test(t_isxdigit_0x65);
    suite_add_test(t_isxdigit_0x66);
    suite_add_test(t_isxdigit_0x67);
    suite_add_test(t_isxdigit_0x68);
    suite_add_test(t_isxdigit_0x69);
    suite_add_test(t_isxdigit_0x6a);
    suite_add_test(t_isxdigit_0x6b);
    suite_add_test(t_isxdigit_0x6c);
    suite_add_test(t_isxdigit_0x6d);
    suite_add_test(t_isxdigit_0x6e);
    suite_add_test(t_isxdigit_0x6f);
    suite_add_test(t_isxdigit_0x70);
    suite_add_test(t_isxdigit_0x71);
    suite_add_test(t_isxdigit_0x72);
    suite_add_test(t_isxdigit_0x73);
    suite_add_test(t_isxdigit_0x74);
    suite_add_test(t_isxdigit_0x75);
    suite_add_test(t_isxdigit_0x76);
    suite_add_test(t_isxdigit_0x77);
    suite_add_test(t_isxdigit_0x78);
    suite_add_test(t_isxdigit_0x79);
    suite_add_test(t_isxdigit_0x7a);
    suite_add_test(t_isxdigit_0x7b);
    suite_add_test(t_isxdigit_0x7c);
    suite_add_test(t_isxdigit_0x7d);
    suite_add_test(t_isxdigit_0x7e);
    suite_add_test(t_isxdigit_0x7f);
    suite_add_test(t_isxdigit_0x80);
    suite_add_test(t_isxdigit_0x81);
    suite_add_test(t_isxdigit_0x82);
    suite_add_test(t_isxdigit_0x83);
    suite_add_test(t_isxdigit_0x84);
    suite_add_test(t_isxdigit_0x85);
    suite_add_test(t_isxdigit_0x86);
    suite_add_test(t_isxdigit_0x87);
    suite_add_test(t_isxdigit_0x88);
    suite_add_test(t_isxdigit_0x89);
    suite_add_test(t_isxdigit_0x8a);
    suite_add_test(t_isxdigit_0x8b);
    suite_add_test(t_isxdigit_0x8c);
    suite_add_test(t_isxdigit_0x8d);
    suite_add_test(t_isxdigit_0x8e);
    suite_add_test(t_isxdigit_0x8f);
    suite_add_test(t_isxdigit_0x90);
    suite_add_test(t_isxdigit_0x91);
    suite_add_test(t_isxdigit_0x92);
    suite_add_test(t_isxdigit_0x93);
    suite_add_test(t_isxdigit_0x94);
    suite_add_test(t_isxdigit_0x95);
    suite_add_test(t_isxdigit_0x96);
    suite_add_test(t_isxdigit_0x97);
    suite_add_test(t_isxdigit_0x98);
    suite_add_test(t_isxdigit_0x99);
    suite_add_test(t_isxdigit_0x9a);
    suite_add_test(t_isxdigit_0x9b);
    suite_add_test(t_isxdigit_0x9c);
    suite_add_test(t_isxdigit_0x9d);
    suite_add_test(t_isxdigit_0x9e);
    suite_add_test(t_isxdigit_0x9f);
    suite_add_test(t_isxdigit_0xa0);
    suite_add_test(t_isxdigit_0xa1);
    suite_add_test(t_isxdigit_0xa2);
    suite_add_test(t_isxdigit_0xa3);
    suite_add_test(t_isxdigit_0xa4);
    suite_add_test(t_isxdigit_0xa5);
    suite_add_test(t_isxdigit_0xa6);
    suite_add_test(t_isxdigit_0xa7);
    suite_add_test(t_isxdigit_0xa8);
    suite_add_test(t_isxdigit_0xa9);
    suite_add_test(t_isxdigit_0xaa);
    suite_add_test(t_isxdigit_0xab);
    suite_add_test(t_isxdigit_0xac);
    suite_add_test(t_isxdigit_0xad);
    suite_add_test(t_isxdigit_0xae);
    suite_add_test(t_isxdigit_0xaf);
    suite_add_test(t_isxdigit_0xb0);
    suite_add_test(t_isxdigit_0xb1);
    suite_add_test(t_isxdigit_0xb2);
    suite_add_test(t_isxdigit_0xb3);
    suite_add_test(t_isxdigit_0xb4);
    suite_add_test(t_isxdigit_0xb5);
    suite_add_test(t_isxdigit_0xb6);
    suite_add_test(t_isxdigit_0xb7);
    suite_add_test(t_isxdigit_0xb8);
    suite_add_test(t_isxdigit_0xb9);
    suite_add_test(t_isxdigit_0xba);
    suite_add_test(t_isxdigit_0xbb);
    suite_add_test(t_isxdigit_0xbc);
    suite_add_test(t_isxdigit_0xbd);
    suite_add_test(t_isxdigit_0xbe);
    suite_add_test(t_isxdigit_0xbf);
    suite_add_test(t_isxdigit_0xc0);
    suite_add_test(t_isxdigit_0xc1);
    suite_add_test(t_isxdigit_0xc2);
    suite_add_test(t_isxdigit_0xc3);
    suite_add_test(t_isxdigit_0xc4);
    suite_add_test(t_isxdigit_0xc5);
    suite_add_test(t_isxdigit_0xc6);
    suite_add_test(t_isxdigit_0xc7);
    suite_add_test(t_isxdigit_0xc8);
    suite_add_test(t_isxdigit_0xc9);
    suite_add_test(t_isxdigit_0xca);
    suite_add_test(t_isxdigit_0xcb);
    suite_add_test(t_isxdigit_0xcc);
    suite_add_test(t_isxdigit_0xcd);
    suite_add_test(t_isxdigit_0xce);
    suite_add_test(t_isxdigit_0xcf);
    suite_add_test(t_isxdigit_0xd0);
    suite_add_test(t_isxdigit_0xd1);
    suite_add_test(t_isxdigit_0xd2);
    suite_add_test(t_isxdigit_0xd3);
    suite_add_test(t_isxdigit_0xd4);
    suite_add_test(t_isxdigit_0xd5);
    suite_add_test(t_isxdigit_0xd6);
    suite_add_test(t_isxdigit_0xd7);
    suite_add_test(t_isxdigit_0xd8);
    suite_add_test(t_isxdigit_0xd9);
    suite_add_test(t_isxdigit_0xda);
    suite_add_test(t_isxdigit_0xdb);
    suite_add_test(t_isxdigit_0xdc);
    suite_add_test(t_isxdigit_0xdd);
    suite_add_test(t_isxdigit_0xde);
    suite_add_test(t_isxdigit_0xdf);
    suite_add_test(t_isxdigit_0xe0);
    suite_add_test(t_isxdigit_0xe1);
    suite_add_test(t_isxdigit_0xe2);
    suite_add_test(t_isxdigit_0xe3);
    suite_add_test(t_isxdigit_0xe4);
    suite_add_test(t_isxdigit_0xe5);
    suite_add_test(t_isxdigit_0xe6);
    suite_add_test(t_isxdigit_0xe7);
    suite_add_test(t_isxdigit_0xe8);
    suite_add_test(t_isxdigit_0xe9);
    suite_add_test(t_isxdigit_0xea);
    suite_add_test(t_isxdigit_0xeb);
    suite_add_test(t_isxdigit_0xec);
    suite_add_test(t_isxdigit_0xed);
    suite_add_test(t_isxdigit_0xee);
    suite_add_test(t_isxdigit_0xef);
    suite_add_test(t_isxdigit_0xf0);
    suite_add_test(t_isxdigit_0xf1);
    suite_add_test(t_isxdigit_0xf2);
    suite_add_test(t_isxdigit_0xf3);
    suite_add_test(t_isxdigit_0xf4);
    suite_add_test(t_isxdigit_0xf5);
    suite_add_test(t_isxdigit_0xf6);
    suite_add_test(t_isxdigit_0xf7);
    suite_add_test(t_isxdigit_0xf8);
    suite_add_test(t_isxdigit_0xf9);
    suite_add_test(t_isxdigit_0xfa);
    suite_add_test(t_isxdigit_0xfb);
    suite_add_test(t_isxdigit_0xfc);
    suite_add_test(t_isxdigit_0xfd);
    suite_add_test(t_isxdigit_0xfe);
    suite_add_test(t_isxdigit_0xff);
     return suite_run();
}
