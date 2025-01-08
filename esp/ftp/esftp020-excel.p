/*{utp-ut-glob.i}*/
DEF VAR c-seg-usuario AS CHAR  INIT "ve888002".

DEF TEMP-TABLE tt-relat
    FIELD it-codigo           AS CHAR
    FIELD etiqueta            AS CHAR
    FIELD nr-nota-fis         AS CHAR
    FIELD serie               AS CHAR 
    FIELD parcial             AS LOG
    FIELD possui-serie-sec    AS LOG
    FIELD series-sec          AS CHAR 
    FIELD etiqueta-excel      AS CHAR
    FIELD dun-excel           AS CHAR FORMAT "X(14)"
    FIELD ean-excel           AS CHAR FORMAT "X(14)"
    FIELD data-excel          AS DATETIME 
    FIELD usuario-excel       AS CHAR FORMAT "x(20)"
    FIELD qtd-excel           AS INT
    FIELD descricao-traduzida AS CHAR FORMAT "x(80)"
        INDEX uni nr-nota-fis serie it-codigo.


DEFINE VARIABLE v-num-linha   AS INTEGER NO-UNDO.    
DEFINE VARIABLE chExcel       AS COM-HANDLE.
DEFINE VARIABLE chWorkbook    AS COM-HANDLE.
DEFINE VARIABLE chWorksheet   AS COM-HANDLE.
DEFINE VARIABLE v-nome-arquivo AS CHARACTER  NO-UNDO.

DEF VAR c-ean AS CHAR NO-UNDO.
DEF VAR c-dun AS CHAR NO-UNDO.

DEF INPUT PARAM p-opcao     AS INTEGER NO-UNDO. /*Relat por nota ou por emitente/data*/
DEF INPUT PARAM p-nota      AS CHAR NO-UNDO.
DEF INPUT PARAM p-linguagem AS INTEGER NO-UNDO.
DEF INPUT PARAM p-nome-arquivo AS CHAR NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-relat.


/* corpo do relatΩrio */
CREATE "Excel.Application" chExcel.
chExcel:Visible = FALSE.
chWorkbook  = chExcel:Workbooks:Open(SEARCH("esp\layout\loesftp020001.xlsx")).
chWorksheet = chWorkbook:Worksheets:Item(1).

/* PDECLARAÄ«O */
/*
ASSIGN chWorkSheet:Range("B4"):VALUE = p-declara-1
       chWorkSheet:Range("B4"):HorizontalAlignment = -4131.
ASSIGN chWorkSheet:Range("B5"):VALUE = p-declara-2
       chWorkSheet:Range("B5"):HorizontalAlignment = -4131.
       */
/*ASSIGN v-num-linha = 1.*/
ASSIGN v-num-linha = -2.

FOR EACH tt-relat
    BREAK BY tt-relat.it-codigo
          BY tt-relat.data-excel:

    IF  FIRST-OF(tt-relat.it-codigo) THEN DO:

        ASSIGN c-dun = tt-relat.dun-excel
               c-ean = tt-relat.ean-excel
               v-num-linha = v-num-linha + 3 .

        ASSIGN chWorkSheet:Range("A" + STRING(v-num-linha)):VALUE = "NOTA FISCAL:"
               chWorkSheet:Range("B" + STRING(v-num-linha)):VALUE = trim(STRING(tt-relat.nr-nota-fis + "/" + tt-relat.serie))
               chWorkSheet:Range("B" + STRING(v-num-linha)):HorizontalAlignment = -4131
               chWorkSheet:Range("A" + STRING(v-num-linha) + ":A" + STRING(v-num-linha)):FONT:Bold = TRUE
               v-num-linha = v-num-linha + 1
               chWorkSheet:Range("A" + STRING(v-num-linha)):VALUE = IF p-linguagem = 1 THEN "PRODUTO:" ELSE "PRODUCTO:"
               chWorkSheet:Range("B" + STRING(v-num-linha)):VALUE = trim(STRING(tt-relat.it-codigo + " - " + tt-relat.descricao-traduzida))
               chWorkSheet:Range("B" + STRING(v-num-linha)):HorizontalAlignment = -4131
               chWorkSheet:Range("A" + STRING(v-num-linha) + ":A" + STRING(v-num-linha)):FONT:Bold = TRUE
               v-num-linha = v-num-linha + 2
               chWorkSheet:Range("A" + STRING(v-num-linha)):VALUE = "DUN-14:"
               chWorkSheet:Range("B" + STRING(v-num-linha)):VALUE = trim(STRING("'" + c-dun))
               chWorkSheet:Range("B" + STRING(v-num-linha)):HorizontalAlignment = -4131
               chWorkSheet:Range("A" + STRING(v-num-linha) + ":A" + STRING(v-num-linha)):FONT:Bold = TRUE
               v-num-linha = v-num-linha + 1
               chWorkSheet:Range("A" + STRING(v-num-linha)):VALUE = "EAN-13:"
               chWorkSheet:Range("B" + STRING(v-num-linha)):VALUE = trim(STRING("'" + c-ean))
               chWorkSheet:Range("B" + STRING(v-num-linha)):HorizontalAlignment = -4131
               chWorkSheet:Range("A" + STRING(v-num-linha) + ":A" + STRING(v-num-linha)):FONT:Bold = TRUE
               v-num-linha = v-num-linha + 2
               chWorkSheet:Range("A" + STRING(v-num-linha)):VALUE = IF p-linguagem = 1 THEN "QUANTIDADE:" ELSE "CANTIDAD:"
               chWorkSheet:Range("B" + STRING(v-num-linha)):VALUE = trim(STRING(tt-relat.qtd-excel))
               chWorkSheet:Range("B" + STRING(v-num-linha)):HorizontalAlignment = -4131
               chWorkSheet:Range("A" + STRING(v-num-linha) + ":A" + STRING(v-num-linha)):FONT:Bold = TRUE
               v-num-linha = v-num-linha + 2.
        
    
        ASSIGN chWorkSheet:Range("A" + STRING(v-num-linha) + ":D" + STRING(v-num-linha)):FONT:Bold = TRUE
               chWorkSheet:Range("A" + STRING(v-num-linha)):VALUE = "NUMERO DE SêRIE"
               chWorkSheet:Range("A" + STRING(v-num-linha)):HorizontalAlignment = -4131
               
               chWorkSheet:Range("B" + STRING(v-num-linha)):VALUE = "     DATA / HORµRIO"
               chWorkSheet:Range("B" + STRING(v-num-linha)):HorizontalAlignment = -4131
                
               chWorkSheet:Range("C" + STRING(v-num-linha)):VALUE = "USUµRIO"
               chWorkSheet:Range("C" + STRING(v-num-linha)):HorizontalAlignment = -4131 .

    END.

    ASSIGN v-num-linha = v-num-linha + 1.

    ASSIGN chWorkSheet:Range("A" + STRING(v-num-linha)):VALUE = trim(STRING(tt-relat.etiqueta-excel))
           chWorkSheet:Range("A" + STRING(v-num-linha)):HorizontalAlignment = -4131
           chWorkSheet:Range("B" + STRING(v-num-linha)):VALUE = "'" + trim(STRING(tt-relat.DATA-EXCEL, "99/99/9999 HH:MM:SS"))
           chWorkSheet:Range("B" + STRING(v-num-linha)):HorizontalAlignment = -4108
           chWorkSheet:Range("C" + STRING(v-num-linha)):VALUE = trim(STRING(tt-relat.USUARIO-EXCEL))
           chWorkSheet:Range("C" + STRING(v-num-linha)):HorizontalAlignment = -4131.

     IF  LAST-OF(tt-relat.it-codigo) THEN
         ASSIGN v-num-linha = v-num-linha + 3.
END.

RUN pi-rodape.

PROCEDURE pi-rodape:
/*--------------------------------------------------------------------------------------
**
----------------------------------------------------------------------------------------*/
    /*
    FIND FIRST usuar_mestre NO-LOCK
        WHERE  usuar_mestre.cod_usuario = c-seg-usuario NO-ERROR.
    IF  AVAIL usuar_mestre 
    THEN ASSIGN v-nome-arquivo = usuar_mestre.nom_dir_spool + "/" + usuar_mestre.nom_subdir_spool + "/esftp020_" + string(REPLACE(STRING(TODAY, "99/99/9999"),"/","")) + "_" + STRING(TIME) + ".xls"
                v-nome-arquivo = replace(v-nome-arquivo, "/", "~\").
    ELSE ASSIGN v-nome-arquivo = "c:\temp\roger\esftp020_" + string(REPLACE(STRING(TODAY, "99/99/9999"),"/","_")) + "_" + STRING(TIME) + ".xlsx".
    */

    /*
    IF  OPSYS = "UNIX" THEN 
        ASSIGN v-nome-arquivo = SESSION:TEMP-DIRECTORY + "/" + c-seg-usuario + "/esftp020_" + string(REPLACE(STRING(TODAY, "99/99/9999"),"/","-")) + "_" + STRING(TIME) + ".xlsx".
    ELSE
        ASSIGN v-nome-arquivo = SESSION:TEMP-DIRECTORY +  "esftp020_" + string(REPLACE(STRING(TODAY, "99/99/9999"),"/","-")) + "_" + STRING(TIME) + ".xlsx".
    */
    chWorkbook:SaveCopyAs(p-nome-arquivo).

    /* --- Close the workbook --- */
    if chWorkbook <> ? then
      chWorkbook:Close(0).
    
    /* --- Close the program --- */
    if chExcel <> ? then
      chExcel:Quit.
    
    /* --- Release all the com handles --- */
    if chWorksheet <> ? then
      RELEASE OBJECT chWorksheet.

    if chWorkbook <> ? then
      RELEASE OBJECT chWorkbook.

    if chExcel <> ? then
      RELEASE OBJECT chExcel.

    chWorksheet = ?.
    chWorkbook = ?.      
    chExcel = ?.

END PROCEDURE. /* PROCEDURE pi-rodape: */
