{include/i-prgvrs.i esftp052 2.04.00.002}
/***********************************************************************
**  Programa..: ESP\FTP\esftp052RP.P
**  Autor.....: Anderson Cenci
**  Data......: Julho/2008
**  Descricao.: Relatorio de Notas Geradas Diariamente
**  VersÆo....: 001 15/07/2008
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp/ftp/esftp052tt.i}
{include/i-rpvar.i}

/****************************  Variaveis    ****************************/
/* DEFINE BUFFER bfam-comerc FOR fam-comerc. */
DEF TEMP-TABLE tt-dapi
    FIELD tipo-linha AS CHARACTER
    FIELD linha      AS CHARACTER
    FIELD coluna     AS CHARACTER  
    FIELD valor      AS DECIMAL DECIMALS 2
    INDEX ch_principal tipo-linha linha coluna.


def var da-data          as DATE COLUMN-LABEL "Data EmissÆo" FORMAT "99/99/9999".
def var da-data-ini      like nota-fiscal.dt-emis-nota.
def var da-data-fim      like nota-fiscal.dt-emis-nota.
DEFINE VARIABLE i-cont   AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-linha  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-coluna AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-valor-96 AS DECIMAL  NO-UNDO.
DEFINE VARIABLE de-valor-91 AS DECIMAL  NO-UNDO.
DEFINE VARIABLE de-valor-88 AS DECIMAL  NO-UNDO.
/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.


     
/*
for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.   */

def var h-acomp      as handle no-undo.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "DIMI - MG"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "esftp052"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */

do on stop undo, leave:
   {include/i-rpcab.i}
   {include/i-rpout.i &pagesize="0"}
    
 
    
   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.
   {include/i-rpclo.i}
   run pi-finalizar in h-acomp.
   RETURN "OK".
end.


/* **********************  Internal Procedures  *********************** */

PROCEDURE piImprimeRelat:
    FIND estabelec
         WHERE estabelec.cod-estabel = tt-param.cod-estabel-ini
         NO-LOCK NO-ERROR.
    PUT "00"
        estabelec.ins-estadual           AT 3  FORMAT "9999999999999"
        YEAR(tt-param.dt-emissao-fim)    AT 16 FORMAT "9999"
        MONTH(tt-param.dt-emissao-fim)   AT 20 FORMAT "99"
        day(tt-param.dt-emissao-fim)     AT 22 FORMAT "99"
        DAY(tt-param.dt-emissao-ini)     AT 24 FORMAT "99"
        "D1"                             AT 26 
        "N"                              AT 28
        "0000000"                        AT 29
        "00"                             AT 36
        "01"                             AT 38
        "N"                              AT 40
        "00000000"                       AT 41
        "N"                              AT 49
        "S"                              AT 50
        "N"                              AT 51
        /* "3222000"                        AT 52 */
        "2632900"                        AT 52
        "00"                             AT 59
        "S"                              AT 61 SKIP.


        /******************** FALTA INFORMACAO **************************/

    
    do da-data = tt-param.dt-emissao-ini to tt-param.dt-emissao-fim:

       RUN pi-acompanhar IN h-acomp (INPUT "Selecionando Faturamento data:" + string(da-data,"99/99/9999")).
       FOR EACH doc-fiscal 
           WHERE doc-fiscal.dt-docto = da-data
           AND   doc-fiscal.cod-estabel  >= tt-param.cod-estabel-ini
           AND   doc-fiscal.cod-estabel  <= tt-param.cod-estabel-fim
           AND   doc-fiscal.ind-sit-doc = 1,
           EACH it-doc-fisc OF doc-fiscal NO-LOCK,
           FIRST natur-oper NO-LOCK
           WHERE natur-oper.nat-operacao = it-doc-fisc.nat-operacao
           AND   natur-oper.ind-gera-of = YES:
           /*
           AND   natur-oper.tipo = 2:
             */

           ASSIGN c-linha = "".

           IF  natur-oper.especie-doc = "NFS" AND 
               natur-oper.emite-duplic AND
               doc-fiscal.estado = estabelec.estado THEN
               ASSIGN c-linha = "44". /* Notas de saida Venda */
           ELSE
               IF natur-oper.especie-doc = "NFT" and
                  doc-fiscal.estado = estabelec.estado THEN
                  ASSIGN c-linha = "45". /* Notas de Transferencia */
               ELSE
                   IF  natur-oper.especie-doc = "NFD" AND
                       doc-fiscal.estado = estabelec.estado THEN
                       ASSIGN c-linha = "46". /* Devolu‡Æo */
                   ELSE
                       IF  natur-oper.especie-doc = "NFS" AND 
                           natur-oper.emite-duplic AND
                           doc-fiscal.estado <> estabelec.estado THEN
                           ASSIGN c-linha = "52". /* Notas de saida Venda */
                       ELSE
                           IF natur-oper.especie-doc = "NFT" and
                              doc-fiscal.estado <> estabelec.estado THEN
                              ASSIGN c-linha = "53". /* Notas de Transferencia */
                           ELSE
                               IF  natur-oper.especie-doc = "NFD" AND
                                   doc-fiscal.estado <> estabelec.estado AND
                                 (natur-oper.cod-cfop = "6201" OR
                                  natur-oper.cod-cfop = "6202" OR
                                 (natur-oper.cod-cfop >= "6205" AND
                                  natur-oper.cod-cfop <= "6210") OR
                                 (natur-oper.cod-cfop >= "6410" AND
                                  natur-oper.cod-cfop <= "6413") OR
                                  natur-oper.cod-cfop = "6503" OR
                                  natur-oper.cod-cfop = "6553" OR
                                  natur-oper.cod-cfop = "6556" OR
                                  natur-oper.cod-cfop = "6660" OR
                                  natur-oper.cod-cfop = "6661" OR
                                  natur-oper.cod-cfop = "6662") THEN
                                  ASSIGN c-linha = "54".  /* Devolu‡Æo */


          IF natur-oper.cod-cfop = "6552" OR 
             natur-oper.cod-cfop = "6152" THEN
             ASSIGN c-linha = "53".                            /* Notas de Transferencia */

          IF natur-oper.cod-cfop = "5414" OR
             natur-oper.cod-cfop = "5415" OR
             natur-oper.cod-cfop = "5451" OR
             natur-oper.cod-cfop = "5551" OR
             natur-oper.cod-cfop = "5554" OR
             natur-oper.cod-cfop = "5555" OR
            (natur-oper.cod-cfop >= "5901" AND
             natur-oper.cod-cfop <= "5929") OR
             natur-oper.cod-cfop = "5931" OR
             natur-oper.cod-cfop = "5932" OR
             natur-oper.cod-cfop = "5949" OR
             natur-oper.cod-cfop = "5657" OR
             natur-oper.cod-cfop = "5663" OR
             natur-oper.cod-cfop = "5664" OR
             natur-oper.cod-cfop = "5665" OR
             natur-oper.cod-cfop = "5666" OR
             natur-oper.cod-cfop = "5933" THEN
             ASSIGN c-linha = "50". /* Linha 50 - Outras */

          IF natur-oper.cod-cfop = "6414" OR
             natur-oper.cod-cfop = "6415" OR
             natur-oper.cod-cfop = "6551" OR
             natur-oper.cod-cfop = "6554" OR
             natur-oper.cod-cfop = "6555" OR
            (natur-oper.cod-cfop >= "6901" AND
             natur-oper.cod-cfop <= "6925") OR
             natur-oper.cod-cfop = "6929" OR
             natur-oper.cod-cfop = "6931" OR
             natur-oper.cod-cfop = "6932" OR
             natur-oper.cod-cfop = "6949" OR
             natur-oper.cod-cfop = "6657" OR
             natur-oper.cod-cfop = "6663" OR
             natur-oper.cod-cfop = "6664" OR
             natur-oper.cod-cfop = "6665" OR
             natur-oper.cod-cfop = "6666" OR
             natur-oper.cod-cfop = "6933" THEN
             ASSIGN c-linha = "58". /* Linha 58 - Outras */
       
           IF natur-oper.cod-cfop = "1101" OR
              natur-oper.cod-cfop = "1102" OR
              natur-oper.cod-cfop = "1111" OR
              natur-oper.cod-cfop = "1113" OR
             (natur-oper.cod-cfop >= "1116" AND
              natur-oper.cod-cfop <= "1118") OR 
             (natur-oper.cod-cfop >= "1120" AND
              natur-oper.cod-cfop <= "1122") OR
             (natur-oper.cod-cfop >= "1124" AND
              natur-oper.cod-cfop <= "1126") OR
              natur-oper.cod-cfop = "1401" OR
              natur-oper.cod-cfop = "1403" OR
              natur-oper.cod-cfop = "1501" OR
              natur-oper.cod-cfop = "1651" OR
              natur-oper.cod-cfop = "1652" OR
              natur-oper.cod-cfop = "1653" THEN
              ASSIGN c-linha = "16". /* Linha 16 - Compras */

           IF natur-oper.cod-cfop = "1408" OR
              natur-oper.cod-cfop = "1409" OR
              natur-oper.cod-cfop = "1658" OR
              natur-oper.cod-cfop = "1659" OR
             (natur-oper.cod-cfop >= "1151" AND
              natur-oper.cod-cfop <= "1154")  THEN
              ASSIGN c-linha = "17". /* Linha 17 - Transferˆncia */
           
           IF natur-oper.cod-cfop = "1410" OR
              natur-oper.cod-cfop = "1411" OR
              natur-oper.cod-cfop = "1503" OR
              natur-oper.cod-cfop = "1504" OR
              natur-oper.cod-cfop = "1660" OR
              natur-oper.cod-cfop = "1661" OR
              natur-oper.cod-cfop = "1662" OR
             (natur-oper.cod-cfop >= "1201" AND
              natur-oper.cod-cfop <= "1209")  THEN
              ASSIGN c-linha = "18". /* Linha 18 - Devolu‡Æo */

          IF (natur-oper.cod-cfop >= "1251" AND
              natur-oper.cod-cfop <= "1257") THEN
              ASSIGN c-linha = "19".  /* Linha 19 - Energia El‚trica */

          IF (natur-oper.cod-cfop >= "1301" AND
              natur-oper.cod-cfop <= "1306") THEN
              ASSIGN c-linha = "20".  /* Linha 20 - Comunica‡Æo */

          IF (natur-oper.cod-cfop >= "1351" AND
              natur-oper.cod-cfop <= "1356") or
              natur-oper.cod-cfop = "1931" OR
              natur-oper.cod-cfop = "1932"  THEN
              ASSIGN c-linha = "21". /* Linha 21 - Transporte	 */
                                
          IF natur-oper.cod-cfop = "1406" OR
              (natur-oper.cod-cfop >= "1551" AND
               natur-oper.cod-cfop <= "1555") OR
              natur-oper.cod-cfop = "1604" THEN
              ASSIGN c-linha = "22". /* Linha 22 - Ativo Permanente	 */

          IF natur-oper.cod-cfop = "1407" OR
              natur-oper.cod-cfop = "1556" OR
              natur-oper.cod-cfop = "1557" OR
              natur-oper.cod-cfop = "1653" THEN
              ASSIGN c-linha = "23". /* Linha 23 - Uso Consumo	 */
          
          IF natur-oper.cod-cfop = "1414" OR
              natur-oper.cod-cfop = "1415" OR
              natur-oper.cod-cfop = "1451" OR
              natur-oper.cod-cfop = "1452" OR
             (natur-oper.cod-cfop >= "1901" AND
              natur-oper.cod-cfop <= "1926") OR
              natur-oper.cod-cfop = "1949" OR
              natur-oper.cod-cfop = "1663" OR
              natur-oper.cod-cfop = "1664" OR
              natur-oper.cod-cfop = "1933" THEN
              ASSIGN c-linha = "24". /* Linha 24 - Outras	 */

          IF natur-oper.cod-cfop = "2101" OR
              natur-oper.cod-cfop = "2102" OR
              natur-oper.cod-cfop = "2111" OR
              natur-oper.cod-cfop = "2113" OR
             (natur-oper.cod-cfop >= "2116" AND
              natur-oper.cod-cfop <= "2118") OR
              (natur-oper.cod-cfop >= "2120" AND
               natur-oper.cod-cfop <= "2122") OR
              (natur-oper.cod-cfop >= "2124" AND
               natur-oper.cod-cfop <= "2126") OR
              natur-oper.cod-cfop = "2401" OR
              natur-oper.cod-cfop = "2403" OR
              natur-oper.cod-cfop = "2501" OR
              natur-oper.cod-cfop = "2651" OR
              natur-oper.cod-cfop = "2652" OR
              natur-oper.cod-cfop = "2653" THEN
              ASSIGN c-linha = "26". /* Linha 26 - Compras	 */


          IF (natur-oper.cod-cfop >= "2151" AND
              natur-oper.cod-cfop <= "2154") OR
              natur-oper.cod-cfop = "2408" OR
              natur-oper.cod-cfop = "2409" OR
              natur-oper.cod-cfop = "2658" OR
              natur-oper.cod-cfop = "2659" THEN
              ASSIGN c-linha = "27". /*Linha 27 - Transferˆncia	 */

          IF (natur-oper.cod-cfop >= "2201" AND
              natur-oper.cod-cfop <= "2209") OR
              natur-oper.cod-cfop = "2410" OR
              natur-oper.cod-cfop = "2411" OR
              natur-oper.cod-cfop = "2503" OR
              natur-oper.cod-cfop = "2504" OR
              natur-oper.cod-cfop = "2660" OR
              natur-oper.cod-cfop = "2661" OR
              natur-oper.cod-cfop = "2662" THEN
              ASSIGN c-linha = "28". /*Linha 28 - Devolu‡Æo	 */

          IF (natur-oper.cod-cfop >= "2251"  AND
              natur-oper.cod-cfop <= "2257") THEN
              ASSIGN c-linha = "29". /*Linha 29 - Energia El‚trica	 */

          IF (natur-oper.cod-cfop >= "2301"  AND
              natur-oper.cod-cfop <= "2306") THEN
              ASSIGN c-linha = "30". /* Linha 30 - Comunica‡Æo */

          IF (natur-oper.cod-cfop >= "2351"  AND
              natur-oper.cod-cfop <= "2356") OR
              natur-oper.cod-cfop  = "2931"  OR
              natur-oper.cod-cfop  = "2932"  THEN
              ASSIGN c-linha = "31". /*  Linha 31 - Transporte */

          IF (natur-oper.cod-cfop >= "2351"  AND
              natur-oper.cod-cfop <= "2356") OR
              natur-oper.cod-cfop  = "2931"  OR
              natur-oper.cod-cfop  = "2932"  THEN
              ASSIGN c-linha = "31". /*  Linha 31 - Transporte */

          IF (natur-oper.cod-cfop >= "2551"  AND
              natur-oper.cod-cfop <= "2555") OR
              natur-oper.cod-cfop  = "2406"  THEN
              ASSIGN c-linha = "32". /*  Linha 32 - Ativo Permanente */

          IF  natur-oper.cod-cfop = "2407" OR
              natur-oper.cod-cfop = "2557" OR
              natur-oper.cod-cfop = "2653" OR
              natur-oper.cod-cfop = "2556"  THEN
              ASSIGN c-linha = "33". /*  Linha 33 - Uso Consumo */

          IF  natur-oper.cod-cfop = "2414" OR
              natur-oper.cod-cfop = "2415" OR
              natur-oper.cod-cfop = "2949" OR
              natur-oper.cod-cfop = "2663" OR
              natur-oper.cod-cfop = "2664" OR
              natur-oper.cod-cfop = "2933" OR
             (natur-oper.cod-cfop >= "2901"  AND
              natur-oper.cod-cfop <= "2925") THEN
              ASSIGN c-linha = "34". /*  Linha 34 - Outras */

          IF  natur-oper.cod-cfop = "3101" OR
              natur-oper.cod-cfop = "3102" OR
              natur-oper.cod-cfop = "3126" OR
              natur-oper.cod-cfop = "3127" OR
              natur-oper.cod-cfop = "3651" OR
              natur-oper.cod-cfop = "3652" OR
              natur-oper.cod-cfop = "3653"  THEN
              ASSIGN c-linha = "36". /*  Linha 36 - Compras */

          IF  natur-oper.cod-cfop = "3201" OR
              natur-oper.cod-cfop = "3202" OR
              natur-oper.cod-cfop = "3211" OR
              natur-oper.cod-cfop = "3503" OR
             (natur-oper.cod-cfop >= "3205"  AND
              natur-oper.cod-cfop <= "3207") THEN
              ASSIGN c-linha = "37". /* Linha 37 - Devolu‡Æo */

         IF  natur-oper.cod-cfop = "3251" OR
             natur-oper.cod-cfop = "3301" OR
            (natur-oper.cod-cfop >= "3351"  AND
             natur-oper.cod-cfop <= "3356") THEN
             ASSIGN c-linha = "38". /* Linha 38 - Com/Trans/Energia */

         IF  natur-oper.cod-cfop = "3551" OR
             natur-oper.cod-cfop = "3553" THEN
             ASSIGN c-linha = "39". /* Linha 39 - Ativo Permanente */

         IF  natur-oper.cod-cfop = "3556" THEN
             ASSIGN c-linha = "40". /* Linha 40 - Uso Consumo */

         IF  natur-oper.cod-cfop = "3930" OR
             natur-oper.cod-cfop = "3949" THEN
             ASSIGN c-linha = "41". /* Linha 41 - Outras */

/*         IF c-linha = "54" THEN                                                                                                */
/*             PUT doc-fiscal.nr-doc-fis doc-fiscal.serie doc-fiscal.cod-estabel doc-fiscal.nat-operacao doc-fiscal.cod-emitente */
/*                it-doc-fisc.vl-tot-item it-doc-fisc.vl-bicms-it it-doc-fisc.vl-icms-it SKIP.                                   */
         
         /*
         IF c-linha = "21" THEN
             PUT "-------> " it-doc-fisc.nr-doc-fis " " it-doc-fisc.nat-operacao " " it-doc-fisc.cd-trib-icm " " it-doc-fisc.vl-icms-it " " it-doc-fisc.vl-icms-it " " it-doc-fisc.vl-icmsou-it " " it-doc-fisc.vl-icmsnt-it " " it-doc-fisc.vl-icmsub-it SKIP.
           */
         RUN CriaTempTable(INPUT c-linha, INPUT "01", INPUT it-doc-fisc.vl-tot-item).
         RUN CriaTempTable(INPUT c-linha, INPUT "02", INPUT it-doc-fisc.vl-bicms-it).
         IF it-doc-fisc.cd-trib-icm = 01 THEN
            RUN CriaTempTable(INPUT c-linha, INPUT "03", INPUT it-doc-fisc.vl-icms-it).
         ELSE
             IF it-doc-fisc.cd-trib-icm = 02 THEN
                RUN CriaTempTable(INPUT c-linha, INPUT "04", INPUT it-doc-fisc.vl-icms-it).
             ELSE
                 IF it-doc-fisc.cd-trib-icm = 03 THEN
                    RUN CriaTempTable(INPUT c-linha, INPUT "08", INPUT it-doc-fisc.vl-icmsou-it).
                 ELSE
                     IF it-doc-fisc.cd-trib-icm = 05 THEN
                        RUN CriaTempTable(INPUT c-linha, INPUT "07", INPUT it-doc-fisc.vl-icms-it).


         RUN CriaTempTable(INPUT c-linha, INPUT "05", INPUT it-doc-fisc.vl-icmsnt-it).

         RUN CriaTempTable(INPUT c-linha, INPUT "09", INPUT it-doc-fisc.vl-icmsub-it).

/*          IF  it-doc-fisc.vl-merc-liq <> it-doc-fisc.vl-bicms-it THEN                                                */
/*              RUN CriaTempTable(INPUT c-linha, INPUT "10", INPUT it-doc-fisc.vl-merc-liq - it-doc-fisc.vl-bicms-it). */
         /*
         PUT c-linha " " it-doc-fisc.nr-doc-fis " " it-doc-fisc.serie it-doc-fisc.vl-merc-liq it-doc-fisc.vl-bicms-it it-doc-fisc.vl-icms-it it-doc-fisc.vl-icmsnt-it it-doc-fisc.vl-icmsub-it SKIP.
         */
       END.
    end.

    FIND tt-dapi
         WHERE tt-dapi.tipo-linha = "10"
           AND tt-dapi.linha      = "87"
           AND tt-dapi.coluna     = "03"
         NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-dapi THEN DO:
        CREATE tt-dapi.
        ASSIGN tt-dapi.tipo-linha = "10"
               tt-dapi.linha      = "87"
               tt-dapi.coluna     = "03".
    END.
    ASSIGN tt-dapi.valor = tt-param.valor-saldo-credor.

    FIND tt-dapi
         WHERE tt-dapi.tipo-linha = "10"
           AND tt-dapi.linha      = "88"
           AND tt-dapi.coluna     = "03"
         NO-LOCK NO-ERROR.
    IF AVAIL tt-dapi THEN
        ASSIGN de-valor-88 = tt-dapi.valor.

    FIND tt-dapi
         WHERE tt-dapi.tipo-linha = "10"
           AND tt-dapi.linha      = "91"
           AND tt-dapi.coluna     = "03"
         NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-dapi THEN DO:
        CREATE tt-dapi.
        ASSIGN tt-dapi.tipo-linha = "10"
               tt-dapi.linha      = "91"
               tt-dapi.coluna     = "03".
    END.
    ASSIGN tt-dapi.valor = tt-dapi.valor  +  tt-param.valor-saldo-credor + de-valor-88
           de-valor-91   = tt-dapi.valor.

    FIND tt-dapi
         WHERE tt-dapi.tipo-linha = "10"
           AND tt-dapi.linha      = "96"
           AND tt-dapi.coluna     = "03"
         NO-LOCK NO-ERROR.
    IF AVAIL tt-dapi  THEN DO:
       ASSIGN de-valor-96 = tt-dapi.valor.
       CREATE tt-dapi.
       ASSIGN tt-dapi.tipo-linha = "10"
              tt-dapi.linha      = "92"
              tt-dapi.coluna     = "03".

       ASSIGN tt-dapi.valor = de-valor-91 - de-valor-96.

    END.


       CREATE tt-dapi.
       ASSIGN tt-dapi.tipo-linha = "10"
              tt-dapi.linha      = "97"
              tt-dapi.coluna     = "03".

       ASSIGN tt-dapi.valor = de-valor-96 - de-valor-91.

       CREATE tt-dapi.
       ASSIGN tt-dapi.tipo-linha = "10"
              tt-dapi.linha      = "99"
              tt-dapi.coluna     = "03".

       ASSIGN tt-dapi.valor = de-valor-96 - de-valor-91.

       CREATE tt-dapi.
       ASSIGN tt-dapi.tipo-linha = "10"
              tt-dapi.linha      = "105"
              tt-dapi.coluna     = "03".

       ASSIGN tt-dapi.valor = de-valor-96 - de-valor-91.

       CREATE tt-dapi.
       ASSIGN tt-dapi.tipo-linha = "10"
              tt-dapi.linha      = "131"
              tt-dapi.coluna     = "03".

       ASSIGN tt-dapi.valor = de-valor-96 - de-valor-91.

    FOR EACH tt-dapi
        WHERE tt-dapi.valor > 0
        BREAK BY int(tt-dapi.linha)
              BY tt-dapi.coluna:
        PUT "10"                             AT 01
            estabelec.ins-estadual           AT 3  FORMAT "9999999999999"
            YEAR(tt-param.dt-emissao-fim)    AT 16 FORMAT "9999"
            MONTH(tt-param.dt-emissao-fim)   AT 20 FORMAT "99"
            day(tt-param.dt-emissao-fim)     AT 22 FORMAT "99"
            DAY(tt-param.dt-emissao-ini)     AT 24 FORMAT "99"
            int(tt-dapi.linha)               AT 26 FORMAT "999"
            tt-dapi.coluna                   AT 29 FORMAT "99"
            tt-dapi.valor * 100              AT 31 FORMAT "999999999999999" SKIP.
        ASSIGN i-cont = i-cont + 1.
    END.
    ASSIGN i-cont = i-cont + 2. /*Considerado linha 01 e 99*/
    PUT "99"                             AT 01
        estabelec.ins-estadual           AT 3  FORMAT "9999999999999"
        YEAR(tt-param.dt-emissao-fim)    AT 16 FORMAT "9999"
        MONTH(tt-param.dt-emissao-fim)   AT 20 FORMAT "99"
        day(tt-param.dt-emissao-fim)     AT 22 FORMAT "99"
        DAY(tt-param.dt-emissao-ini)     AT 24 FORMAT "99"
        i-cont                           AT 26 FORMAT "9999" SKIP.
END PROCEDURE.


PROCEDURE CriaTempTable:
    DEF INPUT PARAMETER p-linha  AS CHARACTER.
    DEF INPUT PARAMETER p-coluna AS CHARACTER.
    DEF INPUT PARAMETER p-valor  AS DECIMAL.

    IF p-linha = "" THEN RETURN.

    FIND tt-dapi
         WHERE tt-dapi.tipo-linha = "10"
           AND tt-dapi.linha      = p-linha
           AND tt-dapi.coluna     = p-coluna
         NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-dapi THEN DO:
        CREATE tt-dapi.
        ASSIGN tt-dapi.tipo-linha = "10"
               tt-dapi.linha      = p-linha
               tt-dapi.coluna     = p-coluna.
    END.
    ASSIGN tt-dapi.valor = tt-dapi.valor + p-valor.
    
   IF int(p-linha) >= 44 AND
       INT(p-linha) <= 50 THEN 
       ASSIGN p-linha = "51".
    ELSE
        IF int(p-linha) >= 52 AND
           INT(p-linha) <= 58 THEN 
           ASSIGN p-linha = "59".
        ELSE
            IF int(p-linha) >= 60 AND
               INT(p-linha) <= 63 THEN 
               ASSIGN p-linha = "64".

    IF int(p-linha) >= 44 AND
       INT(p-linha) <= 64 THEN DO:
        FIND tt-dapi
             WHERE tt-dapi.tipo-linha = "10"
               AND tt-dapi.linha      = "65"
               AND tt-dapi.coluna     = p-coluna
             NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-dapi THEN DO:
            CREATE tt-dapi.
            ASSIGN tt-dapi.tipo-linha = "10"
                   tt-dapi.linha      = "65"
                   tt-dapi.coluna     = p-coluna.
        END.
        ASSIGN tt-dapi.valor = tt-dapi.valor + p-valor.

        FIND tt-dapi
             WHERE tt-dapi.tipo-linha = "10"
               AND tt-dapi.linha      = p-linha
               AND tt-dapi.coluna     = p-coluna
             NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-dapi THEN DO:
            CREATE tt-dapi.
            ASSIGN tt-dapi.tipo-linha = "10"
                   tt-dapi.linha      = p-linha
                   tt-dapi.coluna     = p-coluna.
        END.
        ASSIGN tt-dapi.valor = tt-dapi.valor + p-valor.


        IF p-coluna = "03" THEN DO:
            FIND tt-dapi
                 WHERE tt-dapi.tipo-linha = "10"
                   AND tt-dapi.linha      = "93"
                   AND tt-dapi.coluna     = p-coluna
                 NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-dapi THEN DO:
                CREATE tt-dapi.
                ASSIGN tt-dapi.tipo-linha = "10"
                       tt-dapi.linha      = "93"
                       tt-dapi.coluna     = p-coluna.
            END.
            ASSIGN tt-dapi.valor = tt-dapi.valor + p-valor.
   
            FIND tt-dapi
                 WHERE tt-dapi.tipo-linha = "10"
                   AND tt-dapi.linha      = "96"
                   AND tt-dapi.coluna     = p-coluna
                 NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-dapi THEN DO:
                CREATE tt-dapi.
                ASSIGN tt-dapi.tipo-linha = "10"
                       tt-dapi.linha      = "96"
                       tt-dapi.coluna     = p-coluna.
            END.
            ASSIGN tt-dapi.valor = tt-dapi.valor + p-valor.
        END.
    END.

   IF int(p-linha) >= 16 AND
       INT(p-linha) <= 24 THEN 
       ASSIGN p-linha = "25".
    ELSE
        IF int(p-linha) >= 26 AND
           INT(p-linha) <= 34 THEN 
           ASSIGN p-linha = "35".
        ELSE
            IF int(p-linha) >= 36 AND
               INT(p-linha) <= 41 THEN 
               ASSIGN p-linha = "42".

    IF int(p-linha) >= 16 AND
       INT(p-linha) <= 42 THEN DO:
        FIND tt-dapi
             WHERE tt-dapi.tipo-linha = "10"
               AND tt-dapi.linha      = "43"
               AND tt-dapi.coluna     = p-coluna
             NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-dapi THEN DO:
            CREATE tt-dapi.
            ASSIGN tt-dapi.tipo-linha = "10"
                   tt-dapi.linha      = "43"
                   tt-dapi.coluna     = p-coluna.
        END.
        ASSIGN tt-dapi.valor = tt-dapi.valor + p-valor.
        
        IF p-coluna = "03" THEN DO:
            FIND tt-dapi
                 WHERE tt-dapi.tipo-linha = "10"
                   AND tt-dapi.linha      = "88"
                   AND tt-dapi.coluna     = p-coluna
                 NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-dapi THEN DO:
                CREATE tt-dapi.
                ASSIGN tt-dapi.tipo-linha = "10"
                       tt-dapi.linha      = "88"
                       tt-dapi.coluna     = p-coluna.
            END.
            ASSIGN tt-dapi.valor = tt-dapi.valor + p-valor.
        END.
        FIND tt-dapi
             WHERE tt-dapi.tipo-linha = "10"
               AND tt-dapi.linha      = p-linha
               AND tt-dapi.coluna     = p-coluna
             NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-dapi THEN DO:
            CREATE tt-dapi.
            ASSIGN tt-dapi.tipo-linha = "10"
                   tt-dapi.linha      = p-linha
                   tt-dapi.coluna     = p-coluna.
        END.
        ASSIGN tt-dapi.valor = tt-dapi.valor + p-valor.
    END.
    

/*     IF p-coluna = "03" AND                              */
/*       INT(p-linha) >= 16 AND                            */
/*       INT(p-linha) <= 41 THEN DO:                       */
/*                                                         */
/*         FIND tt-dapi                                    */
/*              WHERE tt-dapi.tipo-linha = "10"            */
/*                AND tt-dapi.linha      = "91"            */
/*                AND tt-dapi.coluna     = "03"            */
/*              NO-LOCK NO-ERROR.                          */
/*         IF NOT AVAIL tt-dapi THEN DO:                   */
/*             CREATE tt-dapi.                             */
/*             ASSIGN tt-dapi.tipo-linha = "10"            */
/*                    tt-dapi.linha      = "91"            */
/*                    tt-dapi.coluna     = "03".           */
/*         END.                                            */
/*         ASSIGN tt-dapi.valor = tt-dapi.valor + p-valor. */
/*                                                         */
/*     END.                                                */
    
/*     IF p-coluna = "03" AND                                  */
/*           INT(p-linha) >= 36 AND                            */
/*           INT(p-linha) <= 63 THEN DO:                       */
/*             FIND tt-dapi                                    */
/*                  WHERE tt-dapi.tipo-linha = "10"            */
/*                    AND tt-dapi.linha      = "96"            */
/*                    AND tt-dapi.coluna     = p-coluna        */
/*                  NO-LOCK NO-ERROR.                          */
/*             IF NOT AVAIL tt-dapi THEN DO:                   */
/*                 CREATE tt-dapi.                             */
/*                 ASSIGN tt-dapi.tipo-linha = "10"            */
/*                        tt-dapi.linha      = "96"            */
/*                        tt-dapi.coluna     = p-coluna.       */
/*             END.                                            */
/*             ASSIGN tt-dapi.valor = tt-dapi.valor + p-valor. */
/*                                                             */
/*                                                             */
/*    END.                                                     */
END PROCEDURE.
