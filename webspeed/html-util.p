/******************************************************************************/
/* Função para trocar acentuação e outros por entidades html, para evitar de  */
/* gerar erros nas páginas web.                                               */
/* Autor: Felipe Braun Azambuja                                               */
/* Data: 21.07.2006                                                           */
/******************************************************************************/
PROCEDURE html-entities:
   DEFINE INPUT  PARAMETER c-string AS CHARACTER  NO-UNDO CASE-SENSITIVE.
   DEFINE OUTPUT PARAMETER c-output AS CHARACTER  NO-UNDO CASE-SENSITIVE.

   /** O & deve vir antes de tudo. **/
   ASSIGN c-string = REPLACE (c-string, CHR(38) , CHR(38) + "amp;").

   ASSIGN c-string = REPLACE (c-string, CHR(193), CHR(38) + "Aacute;")
          c-string = REPLACE (c-string, CHR(194), CHR(38) + "Acirc;")
          c-string = REPLACE (c-string, CHR(198), CHR(38) + "AElig;")
          c-string = REPLACE (c-string, CHR(192), CHR(38) + "Agrave;")
          c-string = REPLACE (c-string, CHR(197), CHR(38) + "Aring;")
          c-string = REPLACE (c-string, CHR(195), CHR(38) + "Atilde;")
          c-string = REPLACE (c-string, CHR(196), CHR(38) + "Auml;").
   ASSIGN c-string = REPLACE (c-string, CHR(201), CHR(38) + "Eacute;")
          c-string = REPLACE (c-string, CHR(202), CHR(38) + "Ecirc;")
          c-string = REPLACE (c-string, CHR(200), CHR(38) + "Egrave;")
          c-string = REPLACE (c-string, CHR(203), CHR(38) + "Euml;").
   ASSIGN c-string = REPLACE (c-string, CHR(205), CHR(38) + "Iacute;")
          c-string = REPLACE (c-string, CHR(206), CHR(38) + "Icirc;")
          c-string = REPLACE (c-string, CHR(204), CHR(38) + "Igrave;")
          c-string = REPLACE (c-string, CHR(207), CHR(38) + "Iuml;").
   ASSIGN c-string = REPLACE (c-string, CHR(211), CHR(38) + "Oacute;")
          c-string = REPLACE (c-string, CHR(212), CHR(38) + "Ocirc;")
          c-string = REPLACE (c-string, CHR(210), CHR(38) + "Ograve;")
          c-string = REPLACE (c-string, CHR(213), CHR(38) + "Otilde;")
          c-string = REPLACE (c-string, CHR(214), CHR(38) + "Ouml;")
          c-string = REPLACE (c-string, CHR(216), CHR(38) + "Oslash;").
   ASSIGN c-string = REPLACE (c-string, CHR(215), CHR(38) + "times;").
   ASSIGN c-string = REPLACE (c-string, CHR(217), CHR(38) + "Ugrave;")
          c-string = REPLACE (c-string, CHR(218), CHR(38) + "Uacute;")
          c-string = REPLACE (c-string, CHR(219), CHR(38) + "Ucirc;")
          c-string = REPLACE (c-string, CHR(220), CHR(38) + "Uuml;").
   ASSIGN c-string = REPLACE (c-string, CHR(225), CHR(38) + "aacute;")
          c-string = REPLACE (c-string, CHR(224), CHR(38) + "agrave;")
          c-string = REPLACE (c-string, CHR(226), CHR(38) + "acirc;")
          c-string = REPLACE (c-string, CHR(230), CHR(38) + "aelig;")
          c-string = REPLACE (c-string, CHR(229), CHR(38) + "aring;")
          c-string = REPLACE (c-string, CHR(227), CHR(38) + "atilde;")
          c-string = REPLACE (c-string, CHR(228), CHR(38) + "auml;").
   ASSIGN c-string = REPLACE (c-string, CHR(233), CHR(38) + "eacute;")
          c-string = REPLACE (c-string, CHR(234), CHR(38) + "ecirc;")
          c-string = REPLACE (c-string, CHR(232), CHR(38) + "egrave;")
          c-string = REPLACE (c-string, CHR(235), CHR(38) + "euml;").
   ASSIGN c-string = REPLACE (c-string, CHR(237), CHR(38) + "iacute;")
          c-string = REPLACE (c-string, CHR(238), CHR(38) + "icirc;")
          c-string = REPLACE (c-string, CHR(236), CHR(38) + "igrave;")
          c-string = REPLACE (c-string, CHR(239), CHR(38) + "iuml;").
   ASSIGN c-string = REPLACE (c-string, CHR(243), CHR(38) + "oacute;")
          c-string = REPLACE (c-string, CHR(244), CHR(38) + "ocirc;")
          c-string = REPLACE (c-string, CHR(242), CHR(38) + "ograve;")
          c-string = REPLACE (c-string, CHR(248), CHR(38) + "oslash;")
          c-string = REPLACE (c-string, CHR(245), CHR(38) + "otilde;")
          c-string = REPLACE (c-string, CHR(246), CHR(38) + "ouml;").
   ASSIGN c-string = REPLACE (c-string, CHR(250), CHR(38) + "uacute;")
          c-string = REPLACE (c-string, CHR(251), CHR(38) + "ucirc;")
          c-string = REPLACE (c-string, CHR(249), CHR(38) + "ugrave;")
          c-string = REPLACE (c-string, CHR(252), CHR(38) + "uuml;").
   ASSIGN c-string = REPLACE (c-string, CHR(231), CHR(38) + "ccedil;")
          c-string = REPLACE (c-string, CHR(199), CHR(38) + "Ccedil;")
          c-string = REPLACE (c-string, CHR(209), CHR(38) + "Ntilde;")
          c-string = REPLACE (c-string, CHR(241), CHR(38) + "ntilde;").
   ASSIGN c-string = REPLACE (c-string, CHR(223), CHR(38) + "szlig;")
          c-string = REPLACE (c-string, CHR(222), CHR(38) + "THORN;")
          c-string = REPLACE (c-string, CHR(254), CHR(38) + "thorn;")
          c-string = REPLACE (c-string, CHR(221), CHR(38) + "Yacute;")
          c-string = REPLACE (c-string, CHR(255), CHR(38) + "Yuml;")
          c-string = REPLACE (c-string, CHR(253), CHR(38) + "yacute;")
          c-string = REPLACE (c-string, CHR(160), CHR(38) + "yuml;").
   ASSIGN c-string = REPLACE (c-string, CHR(169), CHR(38) + "copy;")
          c-string = REPLACE (c-string, CHR(174), CHR(38) + "reg;")
          c-string = REPLACE (c-string, CHR(214), CHR(38) + "trade;")
          c-string = REPLACE (c-string, CHR(199), CHR(38) + "euro;")
          c-string = REPLACE (c-string, CHR(165), CHR(38) + "yen;")
          c-string = REPLACE (c-string, CHR(163), CHR(38) + "pound;").
   ASSIGN c-string = REPLACE (c-string, CHR(60) , CHR(38) + "lt;")
          c-string = REPLACE (c-string, CHR(62) , CHR(38) + "gt;")
          c-string = REPLACE (c-string, CHR(34) , CHR(38) + "quot;").

   /** Grava na variável de saída **/
   ASSIGN c-output = c-string.
END.
