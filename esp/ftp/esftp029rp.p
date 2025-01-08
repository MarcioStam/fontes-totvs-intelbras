{esp/ftp/esftp029.i}

DEF input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

   DEF TEMP-TABLE tt-fat
       FIELD cod-emitente    LIKE emitente.cod-emitente
       FIELD it-codigo       LIKE ITEM.it-codigo
       FIELD qt-faturado     AS INT FORMAT "999999999"
       FIELD vl-faturado     AS INT FORMAT "999999999"
       INDEX tt-fat IS PRIMARY UNIQUE cod-emitente it-codigo.

   DEF VAR dt-data      AS DATE.
   DEF VAR dt-inicial   AS DATE.
   DEF VAR dt-final     AS DATE.
   DEF VAR c-unid-neg   AS CHAR FORMAT "X(3)".
   DEF VAR c-dt-implant AS CHAR FORMAT "X(10)".
   DEF VAR c-gerente    AS CHAR FORMAT "X(20)".
   DEF VAR c-desc-fam   AS CHAR FORMAT "X(25)".
   DEF VAR c-unid       AS CHAR FORMAT "X(1)".
   DEF VAR c-cod-ger    AS CHAR FORMAT "x(3)".
   DEF VAR c-arquivo    AS CHAR FORMAT "X(80)".
     
create tt-param.
raw-transfer raw-param to tt-param.

IF DAY(today) = 1 THEN DO:
   IF MONTH(today) = 1 THEN DO:
      ASSIGN dt-inicial = DATE(12,01,YEAR(today) - 1).
   END.
   ELSE
      ASSIGN dt-inicial = DATE(MONTH(today) - 1,01, YEAR(today)).
END.
ELSE
   ASSIGN dt-inicial = DATE(MONTH(today),01, YEAR(today)).

ASSIGN dt-final = date(if month(today) < 12 THEN 
                          month(today) + 1
                       else 1,1,
                          if month(today) < 12 then
                             year(today)
                          else
                             year(today) + 1) - 1.

DO dt-data = dt-inicial to dt-final: 
   /*do da-data = 09/01/2006 to 09/10/2006:  */
/*       PUT SCREEN STRING(dt-data). */
   for each nota-fiscal fields(cod-emitente dt-emis-nota)
       WHERE nota-fiscal.dt-emis-nota = dt-data 
       AND   nota-fiscal.dt-cancel    = ?
       AND   nota-fiscal.emite-duplic,
       each it-nota-fisc fields(it-codigo qt-faturada[1] vl-merc-liq) of nota-fiscal NO-LOCK 
            WHERE it-nota-fisc.it-codigo BEGINS "4":                                          
       FIND FIRST tt-fat 
            WHERE tt-fat.cod-emitente = nota-fiscal.cod-emitente
            AND   tt-fat.it-codigo    = it-nota-fisc.it-codigo NO-ERROR.
       IF NOT AVAIL tt-fat THEN DO:
          CREATE tt-fat.
          ASSIGN tt-fat.cod-emitente = nota-fiscal.cod-emitente
                 tt-fat.it-codigo    = it-nota-fisc.it-codigo.
       END.
       ASSIGN tt-fat.qt-faturado = tt-fat.qt-faturado + it-nota-fisc.qt-faturada[1]
              tt-fat.vl-faturado = tt-fat.vl-faturado + it-nota-fisc.vl-merc-liq.
   END.
END.

ASSIGN c-arquivo = tt-param.arquivo.

OUTPUT TO VALUE(c-arquivo). 

FOR EACH tt-fat,
    FIRST emitente fields(cgc cod-emitente nome-emit cidade estado data-implant) NO-LOCK
          WHERE emitente.cod-emitente = tt-fat.cod-emitente
          AND   (emitente.cod-gr-cli = 2
          OR    emitente.cod-gr-cli = 3
          OR    emitente.cod-gr-cli = 13
          OR    emitente.cod-gr-cli = 14
          OR    emitente.cod-gr-cli = 22
          OR    emitente.cod-gr-cli = 23
          OR    emitente.cod-gr-cli = 24
          OR    emitente.cod-gr-cli = 34),
    FIRST gr-cli FIELDS(descricao) NO-LOCK
          WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli,
    FIRST ITEM FIELDS(it-codigo fm-cod-com desc-item) NO-LOCK
          WHERE ITEM.it-codigo = tt-fat.it-codigo,
    FIRST repres fields(nome-abrev) NO-LOCK
          WHERE repres.cod-rep = emitente.cod-rep
          AND   (repres.cod-rep <> 2000
          AND    repres.cod-rep <> 4000
          AND    repres.cod-rep <= 7000):
       
/*     find first unid-neg-item no-lock                              */
/*          where unid-neg-item.it-codigo = item.it-codigo no-error. */

    ASSIGN c-unid-neg = ITEM.cod-unid-neg.

/*     IF avail unid-neg-item then                                          */
/*        assign c-unid-neg = unid-neg-item.cod_unid_negoc.                 */
/*     ELSE DO:                                                             */
/*        FIND FIRST unid-neg-fam-com NO-LOCK                               */
/*             WHERE unid-neg-fam-com.fm-codigo = item.fm-cod-com NO-ERROR. */
/*        if avail unid-neg-fam-com then                                    */
/*           assign c-unid-neg = unid-neg-fam-com.cod_unid_negoc.           */
/*        else                                                              */
/*           assign c-unid-neg = "INV".                                     */
/*     END.                                                                 */

    FIND FIRST cota-rep NO-LOCK
         WHERE cota-rep.cod-diretoria = c-unid-neg 
         AND   cota-rep.cod-rep = emitente.cod-rep 
         AND   cota-rep.periodo = STRING(YEAR(TODAY)) + STRING(MONTH(TODAY),"99") NO-ERROR.

    IF NOT AVAIL cota-rep THEN
       FIND FIRST cota-rep NO-LOCK
            WHERE cota-rep.cod-diretoria = c-unid-neg 
            AND   cota-rep.cod-rep = emitente.cod-rep 
            AND   cota-rep.periodo < STRING(YEAR(TODAY)) + STRING(MONTH(TODAY),"99") NO-ERROR.
       
    IF AVAIL cota-rep THEN DO:
       FIND FIRST gerente NO-LOCK
            WHERE gerente.cod-gerente = cota-rep.cod-gerente NO-ERROR.
       IF AVAIL gerente THEN
          ASSIGN c-gerente = gerente.nome
                 c-cod-ger = string(cota-rep.cod-gerente).
       ELSE
          ASSIGN c-gerente = "Outros"
                 c-cod-ger = "999".
    END.

    IF c-unid-neg = "ter" THEN
       ASSIGN c-unid-neg = "ICON".
    ELSE IF c-unid-neg = "SEC" THEN
       ASSIGN c-unid-neg = "ISEC".
    ELSE IF c-unid-neg = "NET" THEN
       ASSIGN c-unid-neg = "INET".
    ELSE
       ASSIGN c-unid-neg = "ICORP".
       
    FIND FIRST sub-famc-item NO-LOCK
         WHERE sub-famc-item.cod-familia = int(substr(ITEM.fm-cod-com,1,2))
         AND   sub-famc-item.cod-sub-familia = INT(SUBSTR(ITEM.fm-cod-com,3,2)) NO-ERROR.
    IF AVAIL sub-famc-item THEN
       ASSIGN c-desc-fam = sub-famc.descricao.
    ELSE
       ASSIGN c-desc-fam = "Familia nao cadastrada".

    ASSIGN c-dt-implant = STRING(DAY(emitente.data-implant),"99") + "/" +
                          STRING(MONTH(emitente.data-implant),"99") + "/" +
                          STRING(YEAR(emitente.data-implant)).
                                        
    IF c-unid-neg = "icon" THEN
        ASSIGN c-unid = "T".
    ELSE IF c-unid-neg = "isec" THEN
        ASSIGN c-unid = "S".
    ELSE IF c-unid-neg = "INET" THEN
        ASSIGN c-unid = "N".
    ELSE
        ASSIGN c-unid = "C".

    PUT string(emitente.cgc) FORMAT "X(8)" 
        c-cod-ger
        c-unid
        emitente.nome-emit FORMAT "X(40)"
        c-unid-neg         FORMAT "X(20)"
        gr-cli.descricao   FORMAT "X(20)"
        c-dt-implant
        emitente.cidade    FORMAT "X(30)"
        emitente.estado    FORMAT "X(2)"
        repres.nome-abrev  FORMAT "X(20)"
        c-gerente
        SPACE(20)
        c-desc-fam
        ITEM.desc-item FORMAT "X(25)" 
        tt-fat.vl-faturado
        tt-fat.qt-faturado "~r~n". 
END.
   
OUTPUT CLOSE.
/*                      DISP ETIME. */
