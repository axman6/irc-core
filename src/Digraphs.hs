{-# Language OverloadedStrings #-}
{-|
Module      : Digraphs
Description : Character mnemonics
Copyright   : (c) Eric Mertens, 2016
License     : ISC
Maintainer  : emertens@gmail.com

This module provides an implementation of /digraphs/ as implemented
in Vim and as specified in RFC 1345 (2-character only).

<https://tools.ietf.org/html/rfc1345>
<http://vimdoc.sourceforge.net/htmldoc/digraph.html>

-}



module Digraphs (lookupDigraph) where

import           Data.ByteString.Short (ShortByteString)
import qualified Data.ByteString.Short as ByteString
import           Data.HashMap.Lazy (HashMap)
import qualified Data.HashMap.Lazy as HashMap
import           Data.String
import           Data.Char


-- | Look up 2-character digraph.
lookupDigraph :: Char -> Char -> Maybe Char
lookupDigraph x y
  | isAscii x, isAscii y = HashMap.lookup (fromString [x,y]) digraphs
  | otherwise            = Nothing


digraphs :: HashMap ShortByteString Char
digraphs = HashMap.fromList
  [ ("NU", '\x00')
  , ("SH", '\x01')
  , ("SX", '\x02')
  , ("EX", '\x03')
  , ("ET", '\x04')
  , ("EQ", '\x05')
  , ("AK", '\x06')
  , ("BL", '\x07')
  , ("BS", '\x08')
  , ("HT", '\x09')
  , ("LF", '\x0a')
  , ("VT", '\x0b')
  , ("FF", '\x0c')
  , ("CR", '\x0d')
  , ("SO", '\x0e')
  , ("SI", '\x0f')
  , ("DL", '\x10')
  , ("D1", '\x11')
  , ("D2", '\x12')
  , ("D3", '\x13')
  , ("D4", '\x14')
  , ("NK", '\x15')
  , ("SY", '\x16')
  , ("EB", '\x17')
  , ("CN", '\x18')
  , ("EM", '\x19')
  , ("SB", '\x1a')
  , ("EC", '\x1b')
  , ("FS", '\x1c')
  , ("GS", '\x1d')
  , ("RS", '\x1e')
  , ("US", '\x1f')
  , ("SP", '\x20')
  , ("Nb", '\x23')
  , ("DO", '\x24')
  , ("At", '\x40')
  , ("<(", '\x5b')
  , ("//", '\x5c')
  , (")>", '\x5d')
  , ("'>", '\x5e')
  , ("'!", '\x60')
  , ("(!", '\x7b')
  , ("!!", '\x7c')
  , ("!)", '\x7d')
  , ("'?", '\x7e')
  , ("DT", '\x7f')
  , ("PA", '\x80')
  , ("HO", '\x81')
  , ("BH", '\x82')
  , ("NH", '\x83')
  , ("IN", '\x84')
  , ("NL", '\x85')
  , ("SA", '\x86')
  , ("ES", '\x87')
  , ("HS", '\x88')
  , ("HJ", '\x89')
  , ("VS", '\x8a')
  , ("PD", '\x8b')
  , ("PU", '\x8c')
  , ("RI", '\x8d')
  , ("S2", '\x8e')
  , ("S3", '\x8f')
  , ("DC", '\x90')
  , ("P1", '\x91')
  , ("P2", '\x92')
  , ("TS", '\x93')
  , ("CC", '\x94')
  , ("MW", '\x95')
  , ("SG", '\x96')
  , ("EG", '\x97')
  , ("SS", '\x98')
  , ("GC", '\x99')
  , ("SC", '\x9a')
  , ("CI", '\x9b')
  , ("ST", '\x9c')
  , ("OC", '\x9d')
  , ("PM", '\x9e')
  , ("AC", '\x9f')
  , ("NS", '\xa0')
  , ("!I", '\xa1')
  , ("Ct", '\xa2')
  , ("Pd", '\xa3')
  , ("Cu", '\xa4')
  , ("Ye", '\xa5')
  , ("BB", '\xa6')
  , ("SE", '\xa7')
  , ("':", '\xa8')
  , ("Co", '\xa9')
  , ("-a", '\xaa')
  , ("<<", '\xab')
  , ("NO", '\xac')
  , ("--", '\xad')
  , ("Rg", '\xae')
  , ("'m", '\xaf')
  , ("DG", '\xb0')
  , ("+-", '\xb1')
  , ("2S", '\xb2')
  , ("3S", '\xb3')
  , ("''", '\xb4')
  , ("My", '\xb5')
  , ("PI", '\xb6')
  , (".M", '\xb7')
  , ("',", '\xb8')
  , ("1S", '\xb9')
  , ("-o", '\xba')
  , (">>", '\xbb')
  , ("14", '\xbc')
  , ("12", '\xbd')
  , ("34", '\xbe')
  , ("?I", '\xbf')
  , ("A!", '\xc0')
  , ("A'", '\xc1')
  , ("A>", '\xc2')
  , ("A?", '\xc3')
  , ("A:", '\xc4')
  , ("AA", '\xc5')
  , ("AE", '\xc6')
  , ("C,", '\xc7')
  , ("E!", '\xc8')
  , ("E'", '\xc9')
  , ("E>", '\xca')
  , ("E:", '\xcb')
  , ("I!", '\xcc')
  , ("I'", '\xcd')
  , ("I>", '\xce')
  , ("I:", '\xcf')
  , ("D-", '\xd0')
  , ("N?", '\xd1')
  , ("O!", '\xd2')
  , ("O'", '\xd3')
  , ("O>", '\xd4')
  , ("O?", '\xd5')
  , ("O:", '\xd6')
  , ("*X", '\xd7')
  , ("O/", '\xd8')
  , ("U!", '\xd9')
  , ("U'", '\xda')
  , ("U>", '\xdb')
  , ("U:", '\xdc')
  , ("Y'", '\xdd')
  , ("TH", '\xde')
  , ("ss", '\xdf')
  , ("a!", '\xe0')
  , ("a'", '\xe1')
  , ("a>", '\xe2')
  , ("a?", '\xe3')
  , ("a:", '\xe4')
  , ("aa", '\xe5')
  , ("ae", '\xe6')
  , ("c,", '\xe7')
  , ("e!", '\xe8')
  , ("e'", '\xe9')
  , ("e>", '\xea')
  , ("e:", '\xeb')
  , ("i!", '\xec')
  , ("i'", '\xed')
  , ("i>", '\xee')
  , ("i:", '\xef')
  , ("d-", '\xf0')
  , ("n?", '\xf1')
  , ("o!", '\xf2')
  , ("o'", '\xf3')
  , ("o>", '\xf4')
  , ("o?", '\xf5')
  , ("o:", '\xf6')
  , ("-:", '\xf7')
  , ("o/", '\xf8')
  , ("u!", '\xf9')
  , ("u'", '\xfa')
  , ("u>", '\xfb')
  , ("u:", '\xfc')
  , ("y'", '\xfd')
  , ("th", '\xfe')
  , ("y:", '\xff')
  , ("A-", '\x0100')
  , ("a-", '\x0101')
  , ("A(", '\x0102')
  , ("a(", '\x0103')
  , ("A;", '\x0104')
  , ("a;", '\x0105')
  , ("C'", '\x0106')
  , ("c'", '\x0107')
  , ("C>", '\x0108')
  , ("c>", '\x0109')
  , ("C.", '\x010A')
  , ("c.", '\x010B')
  , ("C<", '\x010C')
  , ("c<", '\x010D')
  , ("D<", '\x010E')
  , ("d<", '\x010F')
  , ("D/", '\x0110')
  , ("d/", '\x0111')
  , ("E-", '\x0112')
  , ("e-", '\x0113')
  , ("E(", '\x0114')
  , ("e(", '\x0115')
  , ("E.", '\x0116')
  , ("e.", '\x0117')
  , ("E;", '\x0118')
  , ("e;", '\x0119')
  , ("E<", '\x011A')
  , ("e<", '\x011B')
  , ("G>", '\x011C')
  , ("g>", '\x011D')
  , ("G(", '\x011E')
  , ("g(", '\x011F')
  , ("G.", '\x0120')
  , ("g.", '\x0121')
  , ("G,", '\x0122')
  , ("g,", '\x0123')
  , ("H>", '\x0124')
  , ("h>", '\x0125')
  , ("H/", '\x0126')
  , ("h/", '\x0127')
  , ("I?", '\x0128')
  , ("i?", '\x0129')
  , ("I-", '\x012A')
  , ("i-", '\x012B')
  , ("I(", '\x012C')
  , ("i(", '\x012D')
  , ("I;", '\x012E')
  , ("i;", '\x012F')
  , ("I.", '\x0130')
  , ("i.", '\x0131')
  , ("IJ", '\x0132')
  , ("ij", '\x0133')
  , ("J>", '\x0134')
  , ("j>", '\x0135')
  , ("K,", '\x0136')
  , ("k,", '\x0137')
  , ("kk", '\x0138')
  , ("L'", '\x0139')
  , ("l'", '\x013A')
  , ("L,", '\x013B')
  , ("l,", '\x013C')
  , ("L<", '\x013D')
  , ("l<", '\x013E')
  , ("L.", '\x013F')
  , ("l.", '\x0140')
  , ("L/", '\x0141')
  , ("l/", '\x0142')
  , ("N'", '\x0143')
  , ("n'", '\x0144')
  , ("N,", '\x0145')
  , ("n,", '\x0146')
  , ("N<", '\x0147')
  , ("n<", '\x0148')
  , ("'n", '\x0149')
  , ("NG", '\x014A')
  , ("ng", '\x014B')
  , ("O-", '\x014C')
  , ("o-", '\x014D')
  , ("O(", '\x014E')
  , ("o(", '\x014F')
  , ("O\"", '\x0150')
  , ("o\"", '\x0151')
  , ("OE", '\x0152')
  , ("oe", '\x0153')
  , ("R'", '\x0154')
  , ("r'", '\x0155')
  , ("R,", '\x0156')
  , ("r,", '\x0157')
  , ("R<", '\x0158')
  , ("r<", '\x0159')
  , ("S'", '\x015A')
  , ("s'", '\x015B')
  , ("S>", '\x015C')
  , ("s>", '\x015D')
  , ("S,", '\x015E')
  , ("s,", '\x015F')
  , ("S<", '\x0160')
  , ("s<", '\x0161')
  , ("T,", '\x0162')
  , ("t,", '\x0163')
  , ("T<", '\x0164')
  , ("t<", '\x0165')
  , ("T/", '\x0166')
  , ("t/", '\x0167')
  , ("U?", '\x0168')
  , ("u?", '\x0169')
  , ("U-", '\x016A')
  , ("u-", '\x016B')
  , ("U(", '\x016C')
  , ("u(", '\x016D')
  , ("U0", '\x016E')
  , ("u0", '\x016F')
  , ("U\"", '\x0170')
  , ("u\"", '\x0171')
  , ("U;", '\x0172')
  , ("u;", '\x0173')
  , ("W>", '\x0174')
  , ("w>", '\x0175')
  , ("Y>", '\x0176')
  , ("y>", '\x0177')
  , ("Y:", '\x0178')
  , ("Z'", '\x0179')
  , ("z'", '\x017A')
  , ("Z.", '\x017B')
  , ("z.", '\x017C')
  , ("Z<", '\x017D')
  , ("z<", '\x017E')
  , ("O9", '\x01A0')
  , ("o9", '\x01A1')
  , ("OI", '\x01A2')
  , ("oi", '\x01A3')
  , ("yr", '\x01A6')
  , ("U9", '\x01AF')
  , ("u9", '\x01B0')
  , ("Z/", '\x01B5')
  , ("z/", '\x01B6')
  , ("ED", '\x01B7')
  , ("A<", '\x01CD')
  , ("a<", '\x01CE')
  , ("I<", '\x01CF')
  , ("i<", '\x01D0')
  , ("O<", '\x01D1')
  , ("o<", '\x01D2')
  , ("U<", '\x01D3')
  , ("u<", '\x01D4')
  , ("A1", '\x01DE')
  , ("a1", '\x01DF')
  , ("A7", '\x01E0')
  , ("a7", '\x01E1')
  , ("A3", '\x01E2')
  , ("a3", '\x01E3')
  , ("G/", '\x01E4')
  , ("g/", '\x01E5')
  , ("G<", '\x01E6')
  , ("g<", '\x01E7')
  , ("K<", '\x01E8')
  , ("k<", '\x01E9')
  , ("O;", '\x01EA')
  , ("o;", '\x01EB')
  , ("O1", '\x01EC')
  , ("o1", '\x01ED')
  , ("EZ", '\x01EE')
  , ("ez", '\x01EF')
  , ("j<", '\x01F0')
  , ("G'", '\x01F4')
  , ("g'", '\x01F5')
  , (";S", '\x02BF')
  , ("'<", '\x02C7')
  , ("'(", '\x02D8')
  , ("'.", '\x02D9')
  , ("'0", '\x02DA')
  , ("';", '\x02DB')
  , ("'\"",'\x02DD')
  , ("A%", '\x0386')
  , ("E%", '\x0388')
  , ("Y%", '\x0389')
  , ("I%", '\x038A')
  , ("O%", '\x038C')
  , ("U%", '\x038E')
  , ("W%", '\x038F')
  , ("i3", '\x0390')
  , ("A*", '\x0391')
  , ("B*", '\x0392')
  , ("G*", '\x0393')
  , ("D*", '\x0394')
  , ("E*", '\x0395')
  , ("Z*", '\x0396')
  , ("Y*", '\x0397')
  , ("H*", '\x0398')
  , ("I*", '\x0399')
  , ("K*", '\x039A')
  , ("L*", '\x039B')
  , ("M*", '\x039C')
  , ("N*", '\x039D')
  , ("C*", '\x039E')
  , ("O*", '\x039F')
  , ("P*", '\x03A0')
  , ("R*", '\x03A1')
  , ("S*", '\x03A3')
  , ("T*", '\x03A4')
  , ("U*", '\x03A5')
  , ("F*", '\x03A6')
  , ("X*", '\x03A7')
  , ("Q*", '\x03A8')
  , ("W*", '\x03A9')
  , ("J*", '\x03AA')
  , ("V*", '\x03AB')
  , ("a%", '\x03AC')
  , ("e%", '\x03AD')
  , ("y%", '\x03AE')
  , ("i%", '\x03AF')
  , ("u3", '\x03B0')
  , ("a*", '\x03B1')
  , ("b*", '\x03B2')
  , ("g*", '\x03B3')
  , ("d*", '\x03B4')
  , ("e*", '\x03B5')
  , ("z*", '\x03B6')
  , ("y*", '\x03B7')
  , ("h*", '\x03B8')
  , ("i*", '\x03B9')
  , ("k*", '\x03BA')
  , ("l*", '\x03BB')
  , ("m*", '\x03BC')
  , ("n*", '\x03BD')
  , ("c*", '\x03BE')
  , ("o*", '\x03BF')
  , ("p*", '\x03C0')
  , ("r*", '\x03C1')
  , ("*s", '\x03C2')
  , ("s*", '\x03C3')
  , ("t*", '\x03C4')
  , ("u*", '\x03C5')
  , ("f*", '\x03C6')
  , ("x*", '\x03C7')
  , ("q*", '\x03C8')
  , ("w*", '\x03C9')
  , ("j*", '\x03CA')
  , ("v*", '\x03CB')
  , ("o%", '\x03CC')
  , ("u%", '\x03CD')
  , ("w%", '\x03CE')
  , ("'G", '\x03D8')
  , (",G", '\x03D9')
  , ("T3", '\x03DA')
  , ("t3", '\x03DB')
  , ("M3", '\x03DC')
  , ("m3", '\x03DD')
  , ("K3", '\x03DE')
  , ("k3", '\x03DF')
  , ("P3", '\x03E0')
  , ("p3", '\x03E1')
  , ("'%", '\x03F4')
  , ("j3", '\x03F5')
  , ("IO", '\x0401')
  , ("D%", '\x0402')
  , ("G%", '\x0403')
  , ("IE", '\x0404')
  , ("DS", '\x0405')
  , ("II", '\x0406')
  , ("YI", '\x0407')
  , ("J%", '\x0408')
  , ("LJ", '\x0409')
  , ("NJ", '\x040A')
  , ("Ts", '\x040B')
  , ("KJ", '\x040C')
  , ("V%", '\x040E')
  , ("DZ", '\x040F')
  , ("A=", '\x0410')
  , ("B=", '\x0411')
  , ("V=", '\x0412')
  , ("G=", '\x0413')
  , ("D=", '\x0414')
  , ("E=", '\x0415')
  , ("Z%", '\x0416')
  , ("Z=", '\x0417')
  , ("I=", '\x0418')
  , ("J=", '\x0419')
  , ("K=", '\x041A')
  , ("L=", '\x041B')
  , ("M=", '\x041C')
  , ("N=", '\x041D')
  , ("O=", '\x041E')
  , ("P=", '\x041F')
  , ("R=", '\x0420')
  , ("S=", '\x0421')
  , ("T=", '\x0422')
  , ("U=", '\x0423')
  , ("F=", '\x0424')
  , ("H=", '\x0425')
  , ("C=", '\x0426')
  , ("C%", '\x0427')
  , ("S%", '\x0428')
  , ("Sc", '\x0429')
  , ("=\"", '\x042A')
  , ("Y=", '\x042B')
  , ("%\"", '\x042C')
  , ("JE", '\x042D')
  , ("JU", '\x042E')
  , ("JA", '\x042F')
  , ("a=", '\x0430')
  , ("b=", '\x0431')
  , ("v=", '\x0432')
  , ("g=", '\x0433')
  , ("d=", '\x0434')
  , ("e=", '\x0435')
  , ("z%", '\x0436')
  , ("z=", '\x0437')
  , ("i=", '\x0438')
  , ("j=", '\x0439')
  , ("k=", '\x043A')
  , ("l=", '\x043B')
  , ("m=", '\x043C')
  , ("n=", '\x043D')
  , ("o=", '\x043E')
  , ("p=", '\x043F')
  , ("r=", '\x0440')
  , ("s=", '\x0441')
  , ("t=", '\x0442')
  , ("u=", '\x0443')
  , ("f=", '\x0444')
  , ("h=", '\x0445')
  , ("c=", '\x0446')
  , ("c%", '\x0447')
  , ("s%", '\x0448')
  , ("sc", '\x0449')
  , ("='", '\x044A')
  , ("y=", '\x044B')
  , ("%'", '\x044C')
  , ("je", '\x044D')
  , ("ju", '\x044E')
  , ("ja", '\x044F')
  , ("io", '\x0451')
  , ("d%", '\x0452')
  , ("g%", '\x0453')
  , ("ie", '\x0454')
  , ("ds", '\x0455')
  , ("ii", '\x0456')
  , ("yi", '\x0457')
  , ("j%", '\x0458')
  , ("lj", '\x0459')
  , ("nj", '\x045A')
  , ("ts", '\x045B')
  , ("kj", '\x045C')
  , ("v%", '\x045E')
  , ("dz", '\x045F')
  , ("Y3", '\x0462')
  , ("y3", '\x0463')
  , ("O3", '\x046A')
  , ("o3", '\x046B')
  , ("F3", '\x0472')
  , ("f3", '\x0473')
  , ("V3", '\x0474')
  , ("v3", '\x0475')
  , ("C3", '\x0480')
  , ("c3", '\x0481')
  , ("G3", '\x0490')
  , ("g3", '\x0491')
  , ("A+", '\x05D0')
  , ("B+", '\x05D1')
  , ("G+", '\x05D2')
  , ("D+", '\x05D3')
  , ("H+", '\x05D4')
  , ("W+", '\x05D5')
  , ("Z+", '\x05D6')
  , ("X+", '\x05D7')
  , ("Tj", '\x05D8')
  , ("J+", '\x05D9')
  , ("K%", '\x05DA')
  , ("K+", '\x05DB')
  , ("L+", '\x05DC')
  , ("M%", '\x05DD')
  , ("M+", '\x05DE')
  , ("N%", '\x05DF')
  , ("N+", '\x05E0')
  , ("S+", '\x05E1')
  , ("E+", '\x05E2')
  , ("P%", '\x05E3')
  , ("P+", '\x05E4')
  , ("Zj", '\x05E5')
  , ("ZJ", '\x05E6')
  , ("Q+", '\x05E7')
  , ("R+", '\x05E8')
  , ("Sh", '\x05E9')
  , ("T+", '\x05EA')
  , (",+", '\x060C')
  , (";+", '\x061B')
  , ("?+", '\x061F')
  , ("H'", '\x0621')
  , ("aM", '\x0622')
  , ("aH", '\x0623')
  , ("wH", '\x0624')
  , ("ah", '\x0625')
  , ("yH", '\x0626')
  , ("a+", '\x0627')
  , ("b+", '\x0628')
  , ("tm", '\x0629')
  , ("t+", '\x062A')
  , ("tk", '\x062B')
  , ("g+", '\x062C')
  , ("hk", '\x062D')
  , ("x+", '\x062E')
  , ("d+", '\x062F')
  , ("dk", '\x0630')
  , ("r+", '\x0631')
  , ("z+", '\x0632')
  , ("s+", '\x0633')
  , ("sn", '\x0634')
  , ("c+", '\x0635')
  , ("dd", '\x0636')
  , ("tj", '\x0637')
  , ("zH", '\x0638')
  , ("e+", '\x0639')
  , ("i+", '\x063A')
  , ("++", '\x0640')
  , ("f+", '\x0641')
  , ("q+", '\x0642')
  , ("k+", '\x0643')
  , ("l+", '\x0644')
  , ("m+", '\x0645')
  , ("n+", '\x0646')
  , ("h+", '\x0647')
  , ("w+", '\x0648')
  , ("j+", '\x0649')
  , ("y+", '\x064A')
  , (":+", '\x064B')
  , ("\"+", '\x064C')
  , ("=+", '\x064D')
  , ("/+", '\x064E')
  , ("'+", '\x064F')
  , ("1+", '\x0650')
  , ("3+", '\x0651')
  , ("0+", '\x0652')
  , ("aS", '\x0670')
  , ("p+", '\x067E')
  , ("v+", '\x06A4')
  , ("gf", '\x06AF')
  , ("0a", '\x06F0')
  , ("1a", '\x06F1')
  , ("2a", '\x06F2')
  , ("3a", '\x06F3')
  , ("4a", '\x06F4')
  , ("5a", '\x06F5')
  , ("6a", '\x06F6')
  , ("7a", '\x06F7')
  , ("8a", '\x06F8')
  , ("9a", '\x06F9')
  , ("B.", '\x1E02')
  , ("b.", '\x1E03')
  , ("B_", '\x1E06')
  , ("b_", '\x1E07')
  , ("D.", '\x1E0A')
  , ("d.", '\x1E0B')
  , ("D_", '\x1E0E')
  , ("d_", '\x1E0F')
  , ("D,", '\x1E10')
  , ("d,", '\x1E11')
  , ("F.", '\x1E1E')
  , ("f.", '\x1E1F')
  , ("G-", '\x1E20')
  , ("g-", '\x1E21')
  , ("H.", '\x1E22')
  , ("h.", '\x1E23')
  , ("H:", '\x1E26')
  , ("h:", '\x1E27')
  , ("H,", '\x1E28')
  , ("h,", '\x1E29')
  , ("K'", '\x1E30')
  , ("k'", '\x1E31')
  , ("K_", '\x1E34')
  , ("k_", '\x1E35')
  , ("L_", '\x1E3A')
  , ("l_", '\x1E3B')
  , ("M'", '\x1E3E')
  , ("m'", '\x1E3F')
  , ("M.", '\x1E40')
  , ("m.", '\x1E41')
  , ("N.", '\x1E44')
  , ("n.", '\x1E45')
  , ("N_", '\x1E48')
  , ("n_", '\x1E49')
  , ("P'", '\x1E54')
  , ("p'", '\x1E55')
  , ("P.", '\x1E56')
  , ("p.", '\x1E57')
  , ("R.", '\x1E58')
  , ("r.", '\x1E59')
  , ("R_", '\x1E5E')
  , ("r_", '\x1E5F')
  , ("S.", '\x1E60')
  , ("s.", '\x1E61')
  , ("T.", '\x1E6A')
  , ("t.", '\x1E6B')
  , ("T_", '\x1E6E')
  , ("t_", '\x1E6F')
  , ("V?", '\x1E7C')
  , ("v?", '\x1E7D')
  , ("W!", '\x1E80')
  , ("w!", '\x1E81')
  , ("W'", '\x1E82')
  , ("w'", '\x1E83')
  , ("W:", '\x1E84')
  , ("w:", '\x1E85')
  , ("W.", '\x1E86')
  , ("w.", '\x1E87')
  , ("X.", '\x1E8A')
  , ("x.", '\x1E8B')
  , ("X:", '\x1E8C')
  , ("x:", '\x1E8D')
  , ("Y.", '\x1E8E')
  , ("y.", '\x1E8F')
  , ("Z>", '\x1E90')
  , ("z>", '\x1E91')
  , ("Z_", '\x1E94')
  , ("z_", '\x1E95')
  , ("h_", '\x1E96')
  , ("t:", '\x1E97')
  , ("w0", '\x1E98')
  , ("y0", '\x1E99')
  , ("A2", '\x1EA2')
  , ("a2", '\x1EA3')
  , ("E2", '\x1EBA')
  , ("e2", '\x1EBB')
  , ("E?", '\x1EBC')
  , ("e?", '\x1EBD')
  , ("I2", '\x1EC8')
  , ("i2", '\x1EC9')
  , ("O2", '\x1ECE')
  , ("o2", '\x1ECF')
  , ("U2", '\x1EE6')
  , ("u2", '\x1EE7')
  , ("Y!", '\x1EF2')
  , ("y!", '\x1EF3')
  , ("Y2", '\x1EF6')
  , ("y2", '\x1EF7')
  , ("Y?", '\x1EF8')
  , ("y?", '\x1EF9')
  , (";'", '\x1F00')
  , (",'", '\x1F01')
  , (";!", '\x1F02')
  , (",!", '\x1F03')
  , ("?;", '\x1F04')
  , ("?,", '\x1F05')
  , ("!:", '\x1F06')
  , ("?:", '\x1F07')
  , ("1N", '\x2002')
  , ("1M", '\x2003')
  , ("3M", '\x2004')
  , ("4M", '\x2005')
  , ("6M", '\x2006')
  , ("1T", '\x2009')
  , ("1H", '\x200A')
  , ("-1", '\x2010')
  , ("-N", '\x2013')
  , ("-M", '\x2014')
  , ("-3", '\x2015')
  , ("!2", '\x2016')
  , ("=2", '\x2017')
  , ("'6", '\x2018')
  , ("'9", '\x2019')
  , (".9", '\x201A')
  , ("9'", '\x201B')
  , ("\"6", '\x201C')
  , ("\"9", '\x201D')
  , (":9", '\x201E')
  , ("9\"", '\x201F')
  , ("/-", '\x2020')
  , ("/=", '\x2021')
  , ("..", '\x2025')
  , ("%0", '\x2030')
  , ("1'", '\x2032')
  , ("2'", '\x2033')
  , ("3'", '\x2034')
  , ("1\"", '\x2035')
  , ("2\"", '\x2036')
  , ("3\"", '\x2037')
  , ("Ca", '\x2038')
  , ("<1", '\x2039')
  , (">1", '\x203A')
  , (":X", '\x203B')
  , ("'-", '\x203E')
  , ("/f", '\x2044')
  , ("0S", '\x2070')
  , ("4S", '\x2074')
  , ("5S", '\x2075')
  , ("6S", '\x2076')
  , ("7S", '\x2077')
  , ("8S", '\x2078')
  , ("9S", '\x2079')
  , ("+S", '\x207A')
  , ("-S", '\x207B')
  , ("=S", '\x207C')
  , ("(S", '\x207D')
  , (")S", '\x207E')
  , ("nS", '\x207F')
  , ("0s", '\x2080')
  , ("1s", '\x2081')
  , ("2s", '\x2082')
  , ("3s", '\x2083')
  , ("4s", '\x2084')
  , ("5s", '\x2085')
  , ("6s", '\x2086')
  , ("7s", '\x2087')
  , ("8s", '\x2088')
  , ("9s", '\x2089')
  , ("+s", '\x208A')
  , ("-s", '\x208B')
  , ("=s", '\x208C')
  , ("(s", '\x208D')
  , (")s", '\x208E')
  , ("Li", '\x20A4')
  , ("Pt", '\x20A7')
  , ("W=", '\x20A9')
  , ("Eu", '\x20AC')
  , ("oC", '\x2103')
  , ("co", '\x2105')
  , ("oF", '\x2109')
  , ("N0", '\x2116')
  , ("PO", '\x2117')
  , ("Rx", '\x211E')
  , ("SM", '\x2120')
  , ("TM", '\x2122')
  , ("Om", '\x2126')
  , ("AO", '\x212B')
  , ("13", '\x2153')
  , ("23", '\x2154')
  , ("15", '\x2155')
  , ("25", '\x2156')
  , ("35", '\x2157')
  , ("45", '\x2158')
  , ("16", '\x2159')
  , ("56", '\x215A')
  , ("18", '\x215B')
  , ("38", '\x215C')
  , ("58", '\x215D')
  , ("78", '\x215E')
  , ("1R", '\x2160')
  , ("2R", '\x2161')
  , ("3R", '\x2162')
  , ("4R", '\x2163')
  , ("5R", '\x2164')
  , ("6R", '\x2165')
  , ("7R", '\x2166')
  , ("8R", '\x2167')
  , ("9R", '\x2168')
  , ("aR", '\x2169')
  , ("bR", '\x216A')
  , ("cR", '\x216B')
  , ("1r", '\x2170')
  , ("2r", '\x2171')
  , ("3r", '\x2172')
  , ("4r", '\x2173')
  , ("5r", '\x2174')
  , ("6r", '\x2175')
  , ("7r", '\x2176')
  , ("8r", '\x2177')
  , ("9r", '\x2178')
  , ("ar", '\x2179')
  , ("br", '\x217A')
  , ("cr", '\x217B')
  , ("<-", '\x2190')
  , ("-!", '\x2191')
  , ("->", '\x2192')
  , ("-v", '\x2193')
  , ("<>", '\x2194')
  , ("UD", '\x2195')
  , ("<=", '\x21D0')
  , ("=>", '\x21D2')
  , ("==", '\x21D4')
  , ("FA", '\x2200')
  , ("dP", '\x2202')
  , ("TE", '\x2203')
  , ("/0", '\x2205')
  , ("DE", '\x2206')
  , ("NB", '\x2207')
  , ("(-", '\x2208')
  , ("-)", '\x220B')
  , ("*P", '\x220F')
  , ("+Z", '\x2211')
  , ("-2", '\x2212')
  , ("-+", '\x2213')
  , ("*-", '\x2217')
  , ("Ob", '\x2218')
  , ("Sb", '\x2219')
  , ("RT", '\x221A')
  , ("0(", '\x221D')
  , ("00", '\x221E')
  , ("-L", '\x221F')
  , ("-V", '\x2220')
  , ("PP", '\x2225')
  , ("AN", '\x2227')
  , ("OR", '\x2228')
  , ("(U", '\x2229')
  , (")U", '\x222A')
  , ("In", '\x222B')
  , ("DI", '\x222C')
  , ("Io", '\x222E')
  , (".:", '\x2234')
  , (":.", '\x2235')
  , (":R", '\x2236')
  , ("::", '\x2237')
  , ("?1", '\x223C')
  , ("CG", '\x223E')
  , ("?-", '\x2243')
  , ("?=", '\x2245')
  , ("?2", '\x2248')
  , ("=?", '\x224C')
  , ("HI", '\x2253')
  , ("!=", '\x2260')
  , ("=3", '\x2261')
  , ("=<", '\x2264')
  , (">=", '\x2265')
  , ("<*", '\x226A')
  , ("*>", '\x226B')
  , ("!<", '\x226E')
  , ("!>", '\x226F')
  , ("(C", '\x2282')
  , (")C", '\x2283')
  , ("(_", '\x2286')
  , (")_", '\x2287')
  , ("0.", '\x2299')
  , ("02", '\x229A')
  , ("-T", '\x22A5')
  , (".P", '\x22C5')
  , (":3", '\x22EE')
  , (".3", '\x22EF')
  , ("Eh", '\x2302')
  , ("<7", '\x2308')
  , (">7", '\x2309')
  , ("7<", '\x230A')
  , ("7>", '\x230B')
  , ("NI", '\x2310')
  , ("(A", '\x2312')
  , ("TR", '\x2315')
  , ("Iu", '\x2320')
  , ("Il", '\x2321')
  , ("</", '\x2329')
  , ("/>", '\x232A')
  , ("Vs", '\x2423')
  , ("1h", '\x2440')
  , ("3h", '\x2441')
  , ("2h", '\x2442')
  , ("4h", '\x2443')
  , ("1j", '\x2446')
  , ("2j", '\x2447')
  , ("3j", '\x2448')
  , ("4j", '\x2449')
  , ("1.", '\x2488')
  , ("2.", '\x2489')
  , ("3.", '\x248A')
  , ("4.", '\x248B')
  , ("5.", '\x248C')
  , ("6.", '\x248D')
  , ("7.", '\x248E')
  , ("8.", '\x248F')
  , ("9.", '\x2490')
  , ("hh", '\x2500')
  , ("HH", '\x2501')
  , ("vv", '\x2502')
  , ("VV", '\x2503')
  , ("3-", '\x2504')
  , ("3_", '\x2505')
  , ("3!", '\x2506')
  , ("3/", '\x2507')
  , ("4-", '\x2508')
  , ("4_", '\x2509')
  , ("4!", '\x250A')
  , ("4/", '\x250B')
  , ("dr", '\x250C')
  , ("dR", '\x250D')
  , ("Dr", '\x250E')
  , ("DR", '\x250F')
  , ("dl", '\x2510')
  , ("dL", '\x2511')
  , ("Dl", '\x2512')
  , ("LD", '\x2513')
  , ("ur", '\x2514')
  , ("uR", '\x2515')
  , ("Ur", '\x2516')
  , ("UR", '\x2517')
  , ("ul", '\x2518')
  , ("uL", '\x2519')
  , ("Ul", '\x251A')
  , ("UL", '\x251B')
  , ("vr", '\x251C')
  , ("vR", '\x251D')
  , ("Vr", '\x2520')
  , ("VR", '\x2523')
  , ("vl", '\x2524')
  , ("vL", '\x2525')
  , ("Vl", '\x2528')
  , ("VL", '\x252B')
  , ("dh", '\x252C')
  , ("dH", '\x252F')
  , ("Dh", '\x2530')
  , ("DH", '\x2533')
  , ("uh", '\x2534')
  , ("uH", '\x2537')
  , ("Uh", '\x2538')
  , ("UH", '\x253B')
  , ("vh", '\x253C')
  , ("vH", '\x253F')
  , ("Vh", '\x2542')
  , ("VH", '\x254B')
  , ("FD", '\x2571')
  , ("BD", '\x2572')
  , ("TB", '\x2580')
  , ("LB", '\x2584')
  , ("FB", '\x2588')
  , ("lB", '\x258C')
  , ("RB", '\x2590')
  , (".S", '\x2591')
  , (":S", '\x2592')
  , ("?S", '\x2593')
  , ("fS", '\x25A0')
  , ("OS", '\x25A1')
  , ("RO", '\x25A2')
  , ("Rr", '\x25A3')
  , ("RF", '\x25A4')
  , ("RY", '\x25A5')
  , ("RH", '\x25A6')
  , ("RZ", '\x25A7')
  , ("RK", '\x25A8')
  , ("RX", '\x25A9')
  , ("sB", '\x25AA')
  , ("SR", '\x25AC')
  , ("Or", '\x25AD')
  , ("UT", '\x25B2')
  , ("uT", '\x25B3')
  , ("PR", '\x25B6')
  , ("Tr", '\x25B7')
  , ("Dt", '\x25BC')
  , ("dT", '\x25BD')
  , ("PL", '\x25C0')
  , ("Tl", '\x25C1')
  , ("Db", '\x25C6')
  , ("Dw", '\x25C7')
  , ("LZ", '\x25CA')
  , ("0m", '\x25CB')
  , ("0o", '\x25CE')
  , ("0M", '\x25CF')
  , ("0L", '\x25D0')
  , ("0R", '\x25D1')
  , ("Sn", '\x25D8')
  , ("Ic", '\x25D9')
  , ("Fd", '\x25E2')
  , ("Bd", '\x25E3')
  , ("*2", '\x2605')
  , ("*1", '\x2606')
  , ("<H", '\x261C')
  , (">H", '\x261E')
  , ("0u", '\x263A')
  , ("0U", '\x263B')
  , ("SU", '\x263C')
  , ("Fm", '\x2640')
  , ("Ml", '\x2642')
  , ("cS", '\x2660')
  , ("cH", '\x2661')
  , ("cD", '\x2662')
  , ("cC", '\x2663')
  , ("Md", '\x2669')
  , ("M8", '\x266A')
  , ("M2", '\x266B')
  , ("Mb", '\x266D')
  , ("Mx", '\x266E')
  , ("MX", '\x266F')
  , ("OK", '\x2713')
  , ("XX", '\x2717')
  , ("-X", '\x2720')
  , ("IS", '\x3000')
  , (",_", '\x3001')
  , ("._", '\x3002')
  , ("+\"", '\x3003')
  , ("+_", '\x3004')
  , ("*_", '\x3005')
  , (";_", '\x3006')
  , ("0_", '\x3007')
  , ("<+", '\x300A')
  , (">+", '\x300B')
  , ("<'", '\x300C')
  , (">'", '\x300D')
  , ("<\"", '\x300E')
  , (">\"", '\x300F')
  , ("(\"", '\x3010')
  , (")\"", '\x3011')
  , ("=T", '\x3012')
  , ("=_", '\x3013')
  , ("('", '\x3014')
  , (")'", '\x3015')
  , ("(I", '\x3016')
  , (")I", '\x3017')
  , ("-?", '\x301C')
  , ("A5", '\x3041')
  , ("a5", '\x3042')
  , ("I5", '\x3043')
  , ("i5", '\x3044')
  , ("U5", '\x3045')
  , ("u5", '\x3046')
  , ("E5", '\x3047')
  , ("e5", '\x3048')
  , ("O5", '\x3049')
  , ("o5", '\x304A')
  , ("ka", '\x304B')
  , ("ga", '\x304C')
  , ("ki", '\x304D')
  , ("gi", '\x304E')
  , ("ku", '\x304F')
  , ("gu", '\x3050')
  , ("ke", '\x3051')
  , ("ge", '\x3052')
  , ("ko", '\x3053')
  , ("go", '\x3054')
  , ("sa", '\x3055')
  , ("za", '\x3056')
  , ("si", '\x3057')
  , ("zi", '\x3058')
  , ("su", '\x3059')
  , ("zu", '\x305A')
  , ("se", '\x305B')
  , ("ze", '\x305C')
  , ("so", '\x305D')
  , ("zo", '\x305E')
  , ("ta", '\x305F')
  , ("da", '\x3060')
  , ("ti", '\x3061')
  , ("di", '\x3062')
  , ("tU", '\x3063')
  , ("tu", '\x3064')
  , ("du", '\x3065')
  , ("te", '\x3066')
  , ("de", '\x3067')
  , ("to", '\x3068')
  , ("do", '\x3069')
  , ("na", '\x306A')
  , ("ni", '\x306B')
  , ("nu", '\x306C')
  , ("ne", '\x306D')
  , ("no", '\x306E')
  , ("ha", '\x306F')
  , ("ba", '\x3070')
  , ("pa", '\x3071')
  , ("hi", '\x3072')
  , ("bi", '\x3073')
  , ("pi", '\x3074')
  , ("hu", '\x3075')
  , ("bu", '\x3076')
  , ("pu", '\x3077')
  , ("he", '\x3078')
  , ("be", '\x3079')
  , ("pe", '\x307A')
  , ("ho", '\x307B')
  , ("bo", '\x307C')
  , ("po", '\x307D')
  , ("ma", '\x307E')
  , ("mi", '\x307F')
  , ("mu", '\x3080')
  , ("me", '\x3081')
  , ("mo", '\x3082')
  , ("yA", '\x3083')
  , ("ya", '\x3084')
  , ("yU", '\x3085')
  , ("yu", '\x3086')
  , ("yO", '\x3087')
  , ("yo", '\x3088')
  , ("ra", '\x3089')
  , ("ri", '\x308A')
  , ("ru", '\x308B')
  , ("re", '\x308C')
  , ("ro", '\x308D')
  , ("wA", '\x308E')
  , ("wa", '\x308F')
  , ("wi", '\x3090')
  , ("we", '\x3091')
  , ("wo", '\x3092')
  , ("n5", '\x3093')
  , ("vu", '\x3094')
  , ("\"5", '\x309B')
  , ("05", '\x309C')
  , ("*5", '\x309D')
  , ("+5", '\x309E')
  , ("a6", '\x30A1')
  , ("A6", '\x30A2')
  , ("i6", '\x30A3')
  , ("I6", '\x30A4')
  , ("u6", '\x30A5')
  , ("U6", '\x30A6')
  , ("e6", '\x30A7')
  , ("E6", '\x30A8')
  , ("o6", '\x30A9')
  , ("O6", '\x30AA')
  , ("Ka", '\x30AB')
  , ("Ga", '\x30AC')
  , ("Ki", '\x30AD')
  , ("Gi", '\x30AE')
  , ("Ku", '\x30AF')
  , ("Gu", '\x30B0')
  , ("Ke", '\x30B1')
  , ("Ge", '\x30B2')
  , ("Ko", '\x30B3')
  , ("Go", '\x30B4')
  , ("Sa", '\x30B5')
  , ("Za", '\x30B6')
  , ("Si", '\x30B7')
  , ("Zi", '\x30B8')
  , ("Su", '\x30B9')
  , ("Zu", '\x30BA')
  , ("Se", '\x30BB')
  , ("Ze", '\x30BC')
  , ("So", '\x30BD')
  , ("Zo", '\x30BE')
  , ("Ta", '\x30BF')
  , ("Da", '\x30C0')
  , ("Ti", '\x30C1')
  , ("Di", '\x30C2')
  , ("TU", '\x30C3')
  , ("Tu", '\x30C4')
  , ("Du", '\x30C5')
  , ("Te", '\x30C6')
  , ("De", '\x30C7')
  , ("To", '\x30C8')
  , ("Do", '\x30C9')
  , ("Na", '\x30CA')
  , ("Ni", '\x30CB')
  , ("Nu", '\x30CC')
  , ("Ne", '\x30CD')
  , ("No", '\x30CE')
  , ("Ha", '\x30CF')
  , ("Ba", '\x30D0')
  , ("Pa", '\x30D1')
  , ("Hi", '\x30D2')
  , ("Bi", '\x30D3')
  , ("Pi", '\x30D4')
  , ("Hu", '\x30D5')
  , ("Bu", '\x30D6')
  , ("Pu", '\x30D7')
  , ("He", '\x30D8')
  , ("Be", '\x30D9')
  , ("Pe", '\x30DA')
  , ("Ho", '\x30DB')
  , ("Bo", '\x30DC')
  , ("Po", '\x30DD')
  , ("Ma", '\x30DE')
  , ("Mi", '\x30DF')
  , ("Mu", '\x30E0')
  , ("Me", '\x30E1')
  , ("Mo", '\x30E2')
  , ("YA", '\x30E3')
  , ("Ya", '\x30E4')
  , ("YU", '\x30E5')
  , ("Yu", '\x30E6')
  , ("YO", '\x30E7')
  , ("Yo", '\x30E8')
  , ("Ra", '\x30E9')
  , ("Ri", '\x30EA')
  , ("Ru", '\x30EB')
  , ("Re", '\x30EC')
  , ("Ro", '\x30ED')
  , ("WA", '\x30EE')
  , ("Wa", '\x30EF')
  , ("Wi", '\x30F0')
  , ("We", '\x30F1')
  , ("Wo", '\x30F2')
  , ("N6", '\x30F3')
  , ("Vu", '\x30F4')
  , ("KA", '\x30F5')
  , ("KE", '\x30F6')
  , ("Va", '\x30F7')
  , ("Vi", '\x30F8')
  , ("Ve", '\x30F9')
  , ("Vo", '\x30FA')
  , (".6", '\x30FB')
  , ("-6", '\x30FC')
  , ("*6", '\x30FD')
  , ("+6", '\x30FE')
  , ("b4", '\x3105')
  , ("p4", '\x3106')
  , ("m4", '\x3107')
  , ("f4", '\x3108')
  , ("d4", '\x3109')
  , ("t4", '\x310A')
  , ("n4", '\x310B')
  , ("l4", '\x310C')
  , ("g4", '\x310D')
  , ("k4", '\x310E')
  , ("h4", '\x310F')
  , ("j4", '\x3110')
  , ("q4", '\x3111')
  , ("x4", '\x3112')
  , ("zh", '\x3113')
  , ("ch", '\x3114')
  , ("sh", '\x3115')
  , ("r4", '\x3116')
  , ("z4", '\x3117')
  , ("c4", '\x3118')
  , ("s4", '\x3119')
  , ("a4", '\x311A')
  , ("o4", '\x311B')
  , ("e4", '\x311C')
  , ("ai", '\x311E')
  , ("ei", '\x311F')
  , ("au", '\x3120')
  , ("ou", '\x3121')
  , ("an", '\x3122')
  , ("en", '\x3123')
  , ("aN", '\x3124')
  , ("eN", '\x3125')
  , ("er", '\x3126')
  , ("i4", '\x3127')
  , ("u4", '\x3128')
  , ("iu", '\x3129')
  , ("v4", '\x312A')
  , ("nG", '\x312B')
  , ("gn", '\x312C')
  , ("1c", '\x3220')
  , ("2c", '\x3221')
  , ("3c", '\x3222')
  , ("4c", '\x3223')
  , ("5c", '\x3224')
  , ("6c", '\x3225')
  , ("7c", '\x3226')
  , ("8c", '\x3227')
  , ("9c", '\x3228')
  , ("ff", '\xFB00')
  , ("fi", '\xFB01')
  , ("fl", '\xFB02')
  , ("ft", '\xFB05')
  , ("st", '\xFB06')
  ]
