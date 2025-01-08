{include/i-prgvrs.i esinp007 2.04.00.002}
/***********************************************************************
**  Programa..: ESP\OFP\esinp007RP.P
**  Autor.....: Roger
**  Data......: Janeiro/2013 - Desenvolvimento
**  Descricao.: Compara 
************************************************************************/

{esp/inp/esinp007tt.i}
{include/i-rpvar.i}

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Compara‡Æo Base EMS x FISCOSOFT"
       c-empresa      = ""
       c-programa     = "esinp007"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
{include/i-rpout.i &pagesize="0"}

run utp/ut-acomp.p persistent set h-acomp.  
run pi-inicializar in h-acomp (input "Imprimindo...").


/******************** Compara NCM da tabela Classif fisc do EMS com a da FISCOSOFT ******************/
PUT "NCM; ORIGEM; % IPI; % Imp. Importa‡Æo; %PIS; %COFINS; %PIS EXT; %COFINS EXT; %Majorada" SKIP.

FOR EACH classif-fisc NO-LOCK
    WHERE classif-fisc.class-fiscal >= tt-param.c-ncm-ini
      AND classif-fisc.class-fiscal <= tt-param.c-ncm-fim:

    FIND LAST fiscosoft-ncm NO-LOCK
        WHERE fiscosoft-ncm.codigo = classif-fisc.class-fiscal NO-ERROR.

    IF  NOT AVAIL fiscosoft-ncm THEN
        NEXT.
    
   RUN pi-acompanhar in h-acomp (input "Comparando NCM: " + classif-fisc.class-fiscal).

   FIND FIRST int-classif-fisc NO-LOCK 
        WHERE int-classif-fisc.class-fiscal = classif-fisc.class-fiscal NO-ERROR.

   RUN pi-compara-NCM.

END.

PUT SKIP(2).

/************************ Compara NCM da tabela ITEM do EMS com a da FISCOSOFT **********************/

PUT "ITEM; ORIGEM; % IPI; Trib II; % Imp. Importa‡Æo; %PIS; %COFINS" /*; ICMS"*/ SKIP.
FOR EACH classif-fisc NO-LOCK
    WHERE classif-fisc.class-fiscal >= tt-param.c-ncm-ini
      AND classif-fisc.class-fiscal <= tt-param.c-ncm-fim:

    FIND LAST fiscosoft-ncm NO-LOCK
        WHERE fiscosoft-ncm.codigo = classif-fisc.class-fiscal NO-ERROR.

    IF  NOT AVAIL fiscosoft-ncm THEN
        NEXT.

    FIND FIRST int-classif-fisc NO-LOCK 
         WHERE int-classif-fisc.class-fiscal = classif-fisc.class-fiscal NO-ERROR.

    FOR EACH ITEM NO-LOCK
        WHERE ITEM.class-fiscal = fiscosoft-ncm.codigo
          AND ITEM.cod-obsoleto <> 4: /* Totalmente obsoleto desconsidera */
    
        RUN pi-acompanhar in h-acomp (input "Comparando NCM: " + classif-fisc.class-fiscal + " / ITEM: " + ITEM.it-codigo).

        RUN pi-compara-ITEM.

    END.

END.

run pi-finalizar in h-acomp.

{include/i-rpclo.i}

RETURN "OK".

PROCEDURE pi-compara-ITEM:

    DEF VAR l-diferenca          AS LOGICAL INIT NO NO-UNDO.
    DEF VAR i-majorada           AS INTEGER NO-UNDO.
    DEF VAR c-ipi                AS CHAR EXTENT 2 FORMAT "X(06)" NO-UNDO.
    DEF VAR c-trib-ipi           AS CHAR EXTENT 2 FORMAT "x(9)"  NO-UNDO.
    DEF VAR c-pis                AS CHAR EXTENT 2 FORMAT "X(06)" NO-UNDO.
    DEF VAR c-cofins             AS CHAR EXTENT 2 FORMAT "X(06)" NO-UNDO.
    DEF VAR c-imposto-imp        AS CHAR EXTENT 2 FORMAT "X(06)" NO-UNDO.
    DEF VAR c-trib-imposto-imp   AS CHAR EXTENT 2 FORMAT "X(12)" NO-UNDO.
    DEF VAR c-majorada           AS CHAR EXTENT 2 FORMAT "X(06)" NO-UNDO.
    DEF VAR c-icms               AS CHAR EXTENT 2 FORMAT "X(09)" NO-UNDO.
    DEF VAR de-pis-fisco         AS DEC NO-UNDO.
    DEF VAR de-cofins-fisco      AS DEC NO-UNDO.

    ASSIGN de-pis-fisco    = DEC(REPLACE(fiscosoft-ncm.pis   , ".", ","))
           de-cofins-fisco = DEC(REPLACE(fiscosoft-ncm.cofins, ".", ",")).

    /******************************** COMPARA  I P I **********************************/
    IF  NOT ITEM.ind-ipi-dife THEN DO: /*Conforme Rog‚rio do Fiscal, nÆo gerar compara‡Æo quando for IPI diferenciado */
    
        IF  fiscosoft-ncm.ipi = "NT" THEN DO:
            IF  ITEM.aliquota-ipi <> 0 THEN 
                ASSIGN l-diferenca = YES.
        END.
        ELSE DO:
            IF  ITEM.aliquota-ipi <> DEC(REPLACE(fiscosoft-ncm.ipi, ".", ",")) THEN
                ASSIGN l-diferenca = YES.
    
        END.
    
        ASSIGN c-ipi[1] =  string(ITEM.aliquota-ipi, ">>9.99")
               c-ipi[2] =  IF  fiscosoft-ncm.ipi = "NT"  THEN 
                               "0,00"
                            ELSE 
                               string(dec(replace(fiscosoft-ncm.ipi, ".", ",")), ">>9.99")
              c-trib-ipi[1] = {ininc/i10in172.i 04 ITEM.cd-trib-ipi}
              c-trib-ipi[2] = IF  fiscosoft-ncm.ipi = "NT" THEN 
                                 {ininc/i10in172.i 04 2} /*ISENTO*/
                              ELSE 
                                  {ininc/i10in172.i 04 1} /*TRIBUTADO*/ .
    END.
              
    /******************************** COMPARA IMPOSTO IMPORTA€ÇO******************************/
    IF  DEC(SUBSTR(ITEM.char-2, 22, 6)) <> DEC(REPLACE(fiscosoft-ncm.aliquota, ".", ",")) THEN
       ASSIGN l-diferenca = YES.

    ASSIGN c-imposto-imp[1] = SUBSTRING(ITEM.char-2, 22, 6)
           c-imposto-imp[2] = string(dec(replace(fiscosoft-ncm.aliquota, ".", ",")) , ">>9.99").

    IF  dec(SUBSTR(item.char-2,20,2)) <> 1 AND dec(replace(fiscosoft-ncm.aliquota, ".", ",")) > 0 THEN 
         ASSIGN l-diferenca = YES.

    ASSIGN c-trib-imposto-imp[1] = IF  SUBSTR(item.char-2,20,2) = "01" THEN "Tributado" 
                                             ELSE IF  SUBSTR(item.char-2,20,2) = "02" THEN "Isento" 
                                                   ELSE IF SUBSTR(item.char-2,20,2) = "03" THEN "Outros" 
                                                       ELSE IF SUBSTR(item.char-2,20,2) = "04" THEN "Reduzido" 
                                                           ELSE "NÆo Informada".
           c-trib-imposto-imp[2] = "TRIBUTADO".                                                        


    /************************************** COMPARA P I S ************************************/
    IF  DEC(SUBSTR(ITEM.CHAR-2, 31, 5)) <> de-pis-fisco THEN
        ASSIGN l-diferenca = YES.

    ASSIGN c-pis[1] =  string(dec(SUBSTR(ITEM.CHAR-2, 31, 5)), ">>9.99")
           c-pis[2] =  string(de-pis-fisco, ">>9.99").

    /************************************* COMPARA COFINS ************************************/
    IF  AVAIL int-classif-fisc AND int-classif-fisc.inss-faturamento THEN 
        ASSIGN i-majorada = -1.
    ELSE 
        ASSIGN i-majorada = 0.

    IF  DEC(SUBSTR(ITEM.CHAR-2, 36, 5)) <> (de-cofins-fisco + i-majorada) THEN
        ASSIGN l-diferenca = YES.

    ASSIGN c-cofins[1] =  STRING(dec(SUBSTR(ITEM.CHAR-2, 36, 5)), ">>9.99")
           c-cofins[2] =  string(de-cofins-fisco + i-majorada, ">>9.99").


    /************************************* COMPARA ICMS ************************************/
/*     IF  fiscosoft-ncm.icms = "ISENTO"  THEN                    */
/*         IF  ITEM.cd-trib-icm <> 1 THEN                         */
/*             ASSIGN l-diferenca = YES.                          */
/*                                                                */
/*     ASSIGN c-icms [1] = {ininc/i11in172.i 04 ITEM.cd-trib-icm} */
/*            c-icms [2] = IF  fiscosoft-ncm.icms = "ISENTO" THEN */
/*                             fiscosoft-ncm.icms                 */
/*                         ELSE                                   */
/*                             "TRIBUTADO".                       */

    /* IMPRESSÇO PARA SCV */
    IF  NOT l-diferenca THEN
        RETURN "OK".

    PUT ITEM.it-codigo " - " SPACE(2) ITEM.desc-item  ";" 
        "FISCOSOFT"                     ";"
        c-ipi             [2]           ";"
        c-trib-imposto-imp[2]           ";"
        c-imposto-imp     [2]           ";"
        c-pis             [2]           ";"
        c-cofins          [2]           /*";"
        c-icms            [2]          */   SKIP.
                                     
    PUT ITEM.it-codigo " - " SPACE(2) ITEM.desc-item  ";" 
        "BASE EMS"                      ";"
        c-ipi             [1]           ";"
        c-trib-imposto-imp[1]           ";"
        c-imposto-imp     [1]           ";"
        c-pis             [1]           ";"
        c-cofins          [1]           /*";"
        c-icms          [1]          */   SKIP.
END.


PROCEDURE pi-compara-NCM:
    
    DEF VAR l-diferenca          AS LOGICAL INIT NO NO-UNDO.
    DEF VAR i-majorada           AS INTEGER NO-UNDO.
    DEF VAR c-ipi                AS CHAR EXTENT 2 FORMAT "X(06)" NO-UNDO.
    DEF VAR c-pis                AS CHAR EXTENT 2 FORMAT "X(06)" NO-UNDO.
    DEF VAR c-cofins             AS CHAR EXTENT 2 FORMAT "X(06)" NO-UNDO.
    DEF VAR c-pis-ext            AS CHAR EXTENT 2 FORMAT "X(06)" NO-UNDO.
    DEF VAR c-cofins-ext         AS CHAR EXTENT 2 FORMAT "X(06)" NO-UNDO.
    DEF VAR c-imposto-imp        AS CHAR EXTENT 2 FORMAT "X(06)" NO-UNDO.
    DEF VAR c-majorada           AS CHAR EXTENT 2 FORMAT "X(06)" NO-UNDO.
    DEF VAR de-pis-fisco         AS DEC NO-UNDO.
    DEF VAR de-cofins-fisco      AS DEC NO-UNDO.
    
    ASSIGN de-pis-fisco    = DEC(REPLACE(fiscosoft-ncm.pis   , ".", ","))
           de-cofins-fisco = DEC(REPLACE(fiscosoft-ncm.cofins, ".", ",")).

    /******************************** COMPARA  I P I **********************************/
    IF  fiscosoft-ncm.ipi = "NT" THEN DO:
        IF  classif-fisc.aliquota-ipi <> 0 THEN 
            ASSIGN l-diferenca = YES.
    END.
    ELSE DO:
        IF  classif-fisc.aliquota-ipi <> DEC(REPLACE(fiscosoft-ncm.ipi, ".", ",")) THEN
            ASSIGN l-diferenca = YES.

    END.

    ASSIGN c-ipi[1] =  string(classif-fisc.aliquota-ipi, ">>9.99")
           c-ipi[2] =  replace(fiscosoft-ncm.ipi, ".", ",").
    

    /******************************** COMPARA IMPOSTO IMPORTA€ÇO******************************/
    IF  dec(substr(classif-fisc.char-1, 1, 20)) <> DEC(REPLACE(fiscosoft-ncm.aliquota, ".", ",")) THEN
       ASSIGN l-diferenca = YES.

    ASSIGN c-imposto-imp[1] = string(dec(substr(classif-fisc.char-1, 1, 20)), ">>9.99")
           c-imposto-imp[2] = string(dec(replace(fiscosoft-ncm.aliquota, ".", ",")), ">>9.99").

    /************************************** COMPARA P I S ************************************/
    IF  classif-fisc.dec-1 <> de-pis-fisco THEN
        ASSIGN l-diferenca = YES.

    ASSIGN c-pis[1] =  STRING(classif-fisc.dec-1, ">>9.99")
           c-pis[2] =  string(de-pis-fisco, ">>9.99").


    /************************************* COMPARA COFINS ************************************/
    IF  AVAIL int-classif-fisc AND int-classif-fisc.inss-faturamento THEN 
        ASSIGN i-majorada = -1.
    ELSE 
        ASSIGN i-majorada = 0.

    IF  classif-fisc.dec-2 <> (de-cofins-fisco + i-majorada) THEN
        ASSIGN l-diferenca = YES.

    ASSIGN c-cofins[1] =  STRING(classif-fisc.dec-2, ">>9.99")
           c-cofins[2] =  string(de-cofins-fisco + i-majorada, ">>9.99").

    /*********************************** COMPARA PIS EXTERNO *********************************/
    IF  classif-fisc.val-aliq-ext-pis <> de-pis-fisco THEN
        ASSIGN l-diferenca = YES.
    
    ASSIGN c-pis-ext[1] = STRING(classif-fisc.val-aliq-ext-pis, ">>9.99")
           c-pis-ext[2] = STRING(de-pis-fisco, ">>9.99").


    /******************************** COMPARA COFINS EXTERNO *********************************/
    IF  classif-fisc.val-aliq-ext-cofins <> (de-cofins-fisco + i-majorada) THEN
        ASSIGN l-diferenca = YES.

    ASSIGN c-cofins-ext[1] = string(classif-fisc.val-aliq-ext-cofins, ">>9.99")
           c-cofins-ext[2] = string(de-cofins-fisco + i-majorada, ">>9.99").


    /******************************** COMPARA Al¡quota Majorada ******************************/
    IF  dec(substr(classif-fisc.char-1, 56,6)) <> DEC(REPLACE(fiscosoft-ncm.cofins , ".", ",")) 
    AND (AVAIL int-classif-fisc AND int-classif-fisc.inss-faturamento) THEN 
        ASSIGN l-diferenca = YES.

    ASSIGN c-majorada[1] = string(dec(substr(classif-fisc.char-1, 56,6)), ">>9.99")
           c-majorada[2] = STRING(de-cofins-fisco, ">>9.99").

    /* IMPRESSÇO PARA SCV */
    IF  NOT l-diferenca THEN
        RETURN "OK".

    PUT classif-fisc.class-fiscal       ";" 
        "FISCOSOFT"                     ";"
        c-ipi                     [2]   ";"
        c-imposto-imp             [2]   ";"
        c-pis                     [2]   ";"
        c-cofins                  [2]   ";"
        c-pis-ext                 [2]   ";"
        c-cofins-ext              [2]   ";"
        c-majorada                [2]   SKIP.
        
    PUT fiscosoft-ncm.codigo FORMAT "9999.99.99"            ";" 
        "BASE "                     ";"
        c-ipi                     [1]   ";"
        c-imposto-imp             [1]   ";"
        c-pis                     [1]   ";"
        c-cofins                  [1]   ";"
        c-pis-ext                 [1]   ";"
        c-cofins-ext              [1]   ";"
        c-majorada                [1]   SKIP.
END.




