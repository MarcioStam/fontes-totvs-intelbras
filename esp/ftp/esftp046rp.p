/***********************************************************************
**  Programa..: ESP/FTP/ESFTP023RP.P
**  Autor.....: Anderson Silvano
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: Mapa de Faturamento - Lei de Inform tica
**  VersÆo....: 001 27/06/2005
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESFTP046 2.04.00.001}

/****************************  Definitions  ****************************/
{esp/ftp/esftp046.i}

{utp/ut-glob.i}
{include/i-rpvar.i}
/****************************  Temp-Tables  ****************************/

def temp-table tt-nf
    field i-tipo        as int format "9" /* 1-Nacional s/ZF 2-Nac. C/ZF 3-Exportacao */
    field it-codigo     like item.it-codigo format "X(07)"
    field descricao     as char format "X(36)" label "Descricao"
    field class-fiscal  like item.class-fiscal
    field nat-operacao  like it-nota-fisc.nat-operacao
    field nr-nota-fis   like nota-fiscal.nr-nota-fis
    field serie-docto   like docum-est.serie-docto
    field dt-emis-nota  like nota-fiscal.dt-emis-nota
    field dt-trans      like docum-est.dt-trans
    field fm-codigo     like item.fm-codigo
    field qt-fatura     like it-nota-fisc.qt-faturada[1] 
    field vl-merc-liq   like it-nota-fisc.vl-merc-liq  
    field vl-ipi-it     like it-nota-fisc.vl-ipi-it    
    field vl-icms-it    like it-nota-fisc.vl-icms-it
    field vl-pis-cofins as dec format ">,>>>,>>>,>>9.99" label "PIS/COFINS"
    field qt-devolvida  like devol-cli.qt-devolvida format "->,>>>,>>>,>>9.99"
    field vl-devol      like devol-cli.vl-devol
    field vl-ipi-devol  as dec format "->,>>>,>>>,>>9.99" label "IPI Devol"
    field vl-icms-devol as dec format "->,>>>,>>>,>>9.99" label "ICMS Devol"
    field vl-pis-cofins-devol as dec format "->,>>>,>>>,>>9.99" 
                              label "PIS/COFINS Devol"
    field estado        like emitente.estado
    field cod-emitente  like emitente.cod-emitente
    field vl-taxa-exp   like nota-fiscal.vl-taxa-exp
    field cod-estabel   like docum-est.cod-estabel
    field portaria      as char format "x(20)" label "Portaria"
    index tt-nf is primary unique i-tipo cod-emitente dt-emis-nota nat-operacao nr-nota-fis
                                  class-fiscal fm-codigo it-codigo.

def temp-table tt-nf-imp like tt-nf.

DEF TEMP-TABLE tt-natur-oper
    FIELD nat-operacao  LIKE natur-oper.nat-operacao. 



DEF TEMP-TABLE tt-prog-ponto1
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo.

DEF TEMP-TABLE tt-prog-ponto2
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo.

DEF TEMP-TABLE tt-prog-ponto3
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo.

DEF TEMP-TABLE tt-prog-ponto4
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo.

DEF TEMP-TABLE tt-prog-ponto5
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo.

DEF TEMP-TABLE tt-prog-ponto6
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo.

DEF TEMP-TABLE tt-prog-ponto7
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo.

DEF VAR da-data AS DATE no-undo.
def var i-cod-emitente like docum-est.cod-emitente no-undo.
def var c-portaria as char no-undo.
def var c-arquivo as char no-undo.

/****************************  Frames       ****************************/


def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Mapa de Faturamento - Lei de Inform tica"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESFTP046"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */



/* Seleciona naturezas de opera‡Æo */
    RUN esp/es0018p.p (INPUT "esftp023",
                       INPUT 1,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto1) NO-ERROR.
/* Fim sele‡Æo */



/* Seleciona classe fiscal */
    RUN esp/es0018p.p (INPUT "esftp023",
                       INPUT 2,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto2) NO-ERROR.
/* Fim sele‡Æo */



/* Seleciona fm-codigo */
    RUN esp/es0018p.p (INPUT "esftp023",
                       INPUT 3,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto3) NO-ERROR.
/* Fim sele‡Æo */



/* Seleciona naturezas de opera‡Æo */
    RUN esp/es0018p.p (INPUT "esftp023",
                       INPUT 4,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto4) NO-ERROR.
/* Fim sele‡Æo */



/* Seleciona naturezas de opera‡Æo */
    RUN esp/es0018p.p (INPUT "esftp023",
                       INPUT 5,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto5) NO-ERROR.
/* Fim sele‡Æo */

/* Seleciona fornecedores */
    RUN esp/es0018p.p (INPUT "esftp023",
                       INPUT 6,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto6) NO-ERROR.
/* Fim sele‡Æo */

/* Seleciona classifica‡Æo fiscal dos itens de entrada */
    RUN esp/es0018p.p (INPUT "esftp023",
                       INPUT 7,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto7) NO-ERROR.
/* Fim sele‡Æo */


DO on stop undo, leave:   
    {include/i-rpcab.i}
    {include/i-rpout.i}

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    run utp/ut-acomp.p persistent set h-acomp.  

    RUN pi-inicializar in h-acomp (input "Imprimindo...").
    RUN piMontaRelat.
    RUN piImprimeRelat.

    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.



PROCEDURE piMontaRelat:
    FOR EACH tt-prog-ponto1:
        FOR EACH natur-oper NO-LOCK WHERE 
            natur-oper.nat-operacao BEGINS tt-prog-ponto1.conteudo:
            CREATE tt-natur-oper.
            ASSIGN tt-natur-oper.nat-operacao = natur-oper.nat-operacao.
           
        END.
    END.

/*
        FOR EACH natur-oper NO-LOCK
            WHERE (natur-oper.nat-operacao BEGINS "51" 
            OR     natur-oper.nat-operacao BEGINS "61"
            OR     natur-oper.nat-operacao BEGINS "64"
            OR     natur-oper.nat-operacao BEGINS "7"
            OR     natur-oper.nat-operacao BEGINS "693301"):
            CREATE tt-natur-oper.
            ASSIGN tt-natur-oper.nat-operacao = natur-oper.nat-operacao.
        END.
*/



    FOR EACH tt-prog-ponto2: END.
    FOR EACH tt-prog-ponto3: END.   

    DO da-data = tt-param.dt-emis-ini TO tt-param.dt-emis-fim:
       FOR EACH nota-fiscal NO-LOCK                WHERE 
                nota-fiscal.dt-emis-nota = da-data AND 
                nota-fiscal.emite-dup              AND
                nota-fiscal.dt-cancela = ?         and 
                nota-fiscal.cod-estabel >= tt-param.fi-cod-estab-ini and
                nota-fiscal.cod-estabel <= tt-param.fi-cod-estab-fim, 
           EACH it-nota-fisc OF nota-fiscal, 
                FIRST ITEM NO-LOCK WHERE
                      item.it-codigo = it-nota-fisc.it-codigo,
                FIRST tt-natur-oper NO-LOCK WHERE
                      tt-natur-oper.nat-operacao = nota-fiscal.nat-operacao BREAK BY it-nota-fisc.it-codigo:               
          
                
           FIND FIRST tt-prog-ponto1 NO-LOCK WHERE
                      tt-prog-ponto1.conteudo = it-nota-fisc.nat-operacao NO-ERROR. 

           IF NOT AVAIL tt-prog-ponto1 THEN DO:
               
              /* IF it-nota-fisc.nat-operacao <> "693301" THEN   DO: */
                
              FIND FIRST tt-prog-ponto2 NO-LOCK WHERE
                         tt-prog-ponto2.conteudo = it-nota-fisc.class-fiscal NO-ERROR. 
              IF NOT AVAIL tt-prog-ponto2 THEN NEXT.
              
              /*
              IF (it-nota-fisc.class-fiscal <> "85179010"  AND
                  it-nota-fisc.class-fiscal <> "85173014"  AND
                  it-nota-fisc.class-fiscal <> "85173013"  AND
                  it-nota-fisc.class-fiscal <> "85178000"  AND
                  it-nota-fisc.class-fiscal <> "85171100"  AND
                  it-nota-fisc.class-fiscal <> "85171999") THEN 
                  NEXT.
              */
              /*
                put "ponto 3 "  ITEM.fm-codigo " nota " nota-fiscal.nr-nota-fis " serie " nota-fiscal.serie " estab " nota-fiscal.cod-estabel skip.               
                */ 
              FIND FIRST tt-prog-ponto3 NO-LOCK WHERE
                         tt-prog-ponto3.conteudo = ITEM.fm-codigo NO-ERROR. 
              IF NOT AVAIL tt-prog-ponto3 THEN NEXT.
                
              /*
                  IF (ITEM.fm-codigo <> "20002130"  AND
                      ITEM.fm-codigo <> "20003130"  AND
                      ITEM.fm-codigo <> "40002130"  AND
                      ITEM.fm-codigo <> "40003130"  AND
                      ITEM.fm-codigo <> "20002140"  AND
                      ITEM.fm-codigo <> "20003140"  AND
                      ITEM.fm-codigo <> "40002140"  AND
                      ITEM.fm-codigo <> "40003140"  AND
                      ITEM.fm-codigo <> "99000000") THEN 
                      NEXT.
              */

           END.                  

           RUN pi-acompanhar in h-acomp (input "Notas de Sa¡da " + string(nota-fiscal.nr-nota-fis)).

           FOR EACH tt-prog-ponto1:
               IF it-nota-fisc.aliquota-ipi = de-ali-1 OR
                  it-nota-fisc.aliquota-ipi = de-ali-2 OR
                  it-nota-fisc.aliquota-ipi = de-ali-3 OR
                  it-nota-fisc.aliquota-ipi = de-ali-4 OR
                  it-nota-fisc.aliquota-ipi = de-ali-5 OR
                  it-nota-fisc.nat-operacao = tt-prog-ponto1.conteudo THEN DO:                  
                  RUN pi-sem-zona-franca.
               END.
           END.                 
                  
            
           FOR EACH tt-prog-ponto4:
               IF it-nota-fisc.nat-operacao BEGINS tt-prog-ponto4.conteudo THEN
                  RUN pi-com-zona-franca.
           END.                 
                  
           FOR EACH tt-prog-ponto5:
               IF it-nota-fisc.nat-operacao begins tt-prog-ponto5.conteudo then
                  RUN pi-exportacao.
           END.

       END.

       RUN pi-ver-devolucao.
       RUN pi-devol-com-zona-franca.
       RUN pi-devol-exportacao.
       RUN pi-nota-entrada.        
    END.
END.



PROCEDURE piImprimeRelat:
/*
    put "T = 1 Nacional sem Zona Franca" skip
        "T = 2 Nacional com Zona Franca" skip
        "T = 3 Exportacao" skip(1).
        
    put "T = 4 Devolu‡Æo Nacional sem Zona Franca" skip
        "T = 5 Devolu‡Æo Nacional com Zona Franca" skip
        "T = 6 Devolu‡Æo Exportacao" skip(1).
                  
    put "T = 7 Notas de Compra - Insumo" skip.
    
    put "T Item    Descricao                            Class Fisc"
        " Nat Op NF                  Emissao Familia    Quant Fatur    Vl Mercad Liq   "
        "Valor IPI Item     Vl ICMS Item       PIS/COFINS       Quant Devol      Vl Devolucao         "
        "IPI Devol        ICMS Devol    PIS/COFINS Dev  UF      Cliente   Taxa exportacao" skip.
*/  
    RUN pi-acompanhar in h-acomp (input "Imprimindo Notas de Sa¡da").        

    assign c-arquivo = tt-param.arquivo
           tt-param.arquivo = "VENDAS" + STRING(YEAR(TODAY)) + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + ".TXT".
    for each tt-nf-imp:
        delete tt-nf-imp.
    end.
    for each tt-nf
       where tt-nf.i-tipo >= 1
         and tt-nf.i-tipo <= 3:
         create tt-nf-imp.
         buffer-copy tt-nf to tt-nf-imp.
    end.
    run esp/ftp/esftp046rp1.p (input table tt-param,
                               input table tt-nf-imp).

    RUN pi-acompanhar in h-acomp (input "Imprimindo Notas de Devolu‡Æo").
    assign tt-param.arquivo = "DEVOLUCOES" + STRING(YEAR(TODAY)) + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + ".TXT".
    for each tt-nf-imp:
        delete tt-nf-imp.
    end.
    for each tt-nf
       where tt-nf.i-tipo >= 4
         and tt-nf.i-tipo <= 6:
         create tt-nf-imp.
         buffer-copy tt-nf to tt-nf-imp.
    end.
    run esp/ftp/esftp046rp1.p (input table tt-param,
                               input table tt-nf-imp).

    RUN pi-acompanhar in h-acomp (input "Imprimindo Notas de Insumo").
    assign tt-param.arquivo = "INSUMOS" + STRING(YEAR(TODAY)) + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + ".TXT".
    for each tt-nf-imp:
        delete tt-nf-imp.
    end.
    for each tt-nf
       where tt-nf.i-tipo = 7:
         create tt-nf-imp.
         buffer-copy tt-nf to tt-nf-imp.
    end.
    run esp/ftp/esftp046rp1.p (input table tt-param,
                               input table tt-nf-imp).

    put SKIP "VERIFIQUE OS ARQUIVOS GERADOS NO DIRETàRIO DE SPOOL DO SERVIDOR OU NA PASTA TEMPORARIA LOCAL" skip(2)
        "Arquivos gerados: "  skip
        "VENDAS" + STRING(YEAR(TODAY)) + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + ".TXT" format "x(80)" skip
        "DEVOLUCOES" + STRING(YEAR(TODAY)) + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + ".TXT" format "x(80)" skip
        "INSUMOS" + STRING(YEAR(TODAY)) + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + ".TXT" format "x(80)" skip.

END.



procedure pi-sem-zona-franca:               
    find first tt-nf 
         where tt-nf.i-tipo       = 1 
           and tt-nf.cod-emitente = nota-fiscal.cod-emitente
           and tt-nf.it-codigo    = item.it-codigo 
           and tt-nf.class-fiscal = it-nota-fisc.class-fiscal 
           and tt-nf.nat-operacao = it-nota-fisc.nat-operacao 
           and tt-nf.nr-nota-fis  = it-nota-fisc.nr-nota-fis 
           and tt-nf.dt-emis-nota = it-nota-fisc.dt-emis-nota 
           and tt-nf.fm-codigo    = item.fm-codigo no-error.
    if not avail tt-nf then do:
       create tt-nf.
       assign tt-nf.i-tipo        = 1
              tt-nf.it-codigo     = item.it-codigo
              tt-nf.class-fiscal  = it-nota-fisc.class-fiscal 
              tt-nf.nat-operacao  = it-nota-fisc.nat-operacao
              tt-nf.nr-nota-fis   = it-nota-fisc.nr-nota-fis 
              tt-nf.dt-emis-nota  = it-nota-fisc.dt-emis-nota 
              tt-nf.fm-codigo     = item.fm-codigo
              tt-nf.descricao     = item.desc-item
              tt-nf.estado        = nota-fiscal.estado
              tt-nf.cod-emitente  = nota-fiscal.cod-emitente
              tt-nf.cod-estabel   = nota-fiscal.cod-estabel
              tt-nf.vl-taxa-exp   = nota-fiscal.vl-taxa-exp.
    end.
    assign tt-nf.qt-fatura     = it-nota-fisc.qt-faturada[1]
           tt-nf.vl-merc-liq   = it-nota-fisc.vl-merc-liq
           tt-nf.vl-ipi-it     = it-nota-fisc.vl-ipi-it
           tt-nf.vl-icms-it    = it-nota-fisc.vl-icms-it.


    if it-nota-fisc.nat-operacao begins "51" or
       it-nota-fisc.nat-operacao begins "61" or
       it-nota-fisc.nat-operacao begins "6933" OR 
       it-nota-fisc.nat-operacao begins "64"  THEN  
       assign tt-nf.vl-pis-cofins = if SUBSTRING(it-nota-fisc.nat-operacao,1,4) <> "6109" then
                                       /* tt-nf.vl-pis-cofins + (it-nota-fisc.vl-merc-liq * tt-param.de-pis-cofins / 100) */
                                       (it-nota-fisc.vl-merc-liq * tt-param.de-pis-cofins / 100) 
                                       /* (dec(tt-nf.vl-merc-liq) * DEC(de-pis-cofins:SCREEN-VALUE IN FRAME fpage2)) / 100 */                                       
                                    else 
                                        tt-nf.vl-pis-cofins.    
end.




procedure pi-ver-devolucao.
   for each docum-est no-lock
          where docum-est.dt-trans = da-data
          and (docum-est.nat-operacao begins "2201" /*"231"*/
           or  docum-est.nat-operacao begins "2202" /*"232"*/
           or  docum-est.nat-operacao begins "1201" /*"131"*/
           or  docum-est.nat-operacao begins "1202" /*"132"*/
           or  docum-est.nat-operacao begins "3201" /*"321"*/
           or  docum-est.nat-operacao begins "2410" /*"241"*/)
          and docum-est.cod-estabel >= tt-param.fi-cod-estab-ini 
          and docum-est.cod-estabel <= tt-param.fi-cod-estab-fim,
       each item-doc-est of docum-est no-lock,
       first emitente no-lock
             where emitente.cod-emitente = docum-est.cod-emitente,
       first item no-lock
            where item.it-codigo = item-doc-est.it-codigo
            AND  (ITEM.fm-codigo = "20002130"
            OR    ITEM.fm-codigo = "20003130"
            OR    ITEM.fm-codigo = "40002130"
            OR    ITEM.fm-codigo = "40003130"
            OR    ITEM.fm-codigo = "20002140"
            OR    ITEM.fm-codigo = "20003140"
            OR    ITEM.fm-codigo = "40002140"
            OR    ITEM.fm-codigo = "40003140"
            OR    ITEM.fm-codigo = "99000000"):

       find nota-fiscal no-lock 
            where nota-fiscal.cod-estabel = tt-param.cod-estabel 
              and nota-fiscal.serie = item-doc-est.serie-comp 
              and nota-fiscal.nr-nota-fis = item-doc-est.nro-comp no-error.
 
       find first it-nota-fisc of nota-fiscal no-lock
            where it-nota-fisc.it-codigo = item-doc-est.it-codigo 
              and it-nota-fisc.nr-seq-fat = item-doc-est.seq-comp 
              and (it-nota-fisc.class-fiscal = "85179010"
               or it-nota-fisc.class-fiscal  = "85173014" 
               or it-nota-fisc.class-fiscal  = "85173013" 
               or it-nota-fisc.class-fiscal  = "85171100"
               or it-nota-fisc.class-fiscal  = "85178000" 
               or it-nota-fisc.class-fiscal  = "85171999"
               OR  it-nota-fisc.class-fiscal = "85176900"
               OR  it-nota-fisc.class-fiscal = "85176222"
               OR  it-nota-fisc.class-fiscal = "85176223"
               OR  it-nota-fisc.class-fiscal = "85177010"
               OR  it-nota-fisc.class-fiscal = "85171899") no-error.

       RUN pi-acompanhar in h-acomp (input "Notas de Devolu‡Æo " + string(docum-est.nro-docto)).        

       if not avail it-nota-fisc then next.

       if it-nota-fisc.aliquota-ipi = tt-param.de-ali-1 or
          it-nota-fisc.aliquota-ipi = tt-param.de-ali-2 or
          it-nota-fisc.aliquota-ipi = tt-param.de-ali-3 or
          it-nota-fisc.aliquota-ipi = tt-param.de-ali-4 or
          it-nota-fisc.aliquota-ipi = tt-param.de-ali-5 then do:
          find first tt-nf 
               where tt-nf.i-tipo       = 4
                 and tt-nf.cod-emitente = nota-fiscal.cod-emitente               
                 and tt-nf.it-codigo    = item.it-codigo 
                 and tt-nf.class-fiscal = it-nota-fisc.class-fiscal 
                 and tt-nf.nat-operacao = it-nota-fisc.nat-operacao 
                 and tt-nf.nr-nota-fis  = nota-fiscal.nr-nota-fis 
                 and tt-nf.dt-emis-nota = it-nota-fisc.dt-emis-nota 
                 and tt-nf.fm-codigo    = item.fm-codigo no-error.
          if not avail tt-nf then do:
             create tt-nf.
             assign tt-nf.i-tipo        = 4
                    tt-nf.it-codigo     = item.it-codigo
                    tt-nf.class-fiscal  = it-nota-fisc.class-fiscal 
                    tt-nf.nat-operacao  = it-nota-fisc.nat-operacao
                    tt-nf.nr-nota-fis   = nota-fiscal.nr-nota-fis 
                    tt-nf.dt-emis-nota  = it-nota-fisc.dt-emis-nota
                    tt-nf.fm-codigo     = item.fm-codigo
                    tt-nf.descricao     = item.desc-item
                    tt-nf.estado        = nota-fiscal.estado
                    tt-nf.cod-emitente  = nota-fiscal.cod-emitente
                    tt-nf.cod-estabel   = nota-fiscal.cod-estabel                    
                    tt-nf.vl-taxa-exp   = nota-fiscal.vl-taxa-exp.
          end.
        
          assign tt-nf.qt-devolvida        = tt-nf.qt-devolvida  + item-doc-est.quantidade
                 tt-nf.vl-devol            = tt-nf.vl-devol      + item-doc-est.preco-total[1]
                 tt-nf.vl-ipi-devol        = tt-nf.vl-ipi-devol  + item-doc-est.valor-ipi[1]
                 tt-nf.vl-icms-devol       = tt-nf.vl-icms-devol + item-doc-est.valor-icm[1].

          if it-nota-fisc.nat-operacao begins "61" or
             it-nota-fisc.nat-operacao begins "51" or
             it-nota-fisc.nat-operacao begins "693301" then
               
             assign tt-nf.vl-pis-cofins-devol = if SUBSTRING(it-nota-fisc.nat-operacao,1,4) <> "6109" THEN 
                                                   tt-nf.vl-pis-cofins-devol + (tt-nf.vl-devol * tt-param.de-pis-cofins / 100)
                                                ELSE
                                                   tt-nf.vl-pis-cofins-devol.

       end.
    end.
end.



procedure pi-com-zona-franca:
               
    find first tt-nf 
         where tt-nf.i-tipo       = 2
           and tt-nf.cod-emitente = nota-fiscal.cod-emitente                
           and tt-nf.it-codigo    = item.it-codigo 
           and tt-nf.class-fiscal = it-nota-fisc.class-fiscal 
           and tt-nf.nat-operacao = it-nota-fisc.nat-operacao 
           and tt-nf.nr-nota-fis  = it-nota-fisc.nr-nota-fis 
           and tt-nf.dt-emis-nota = it-nota-fisc.dt-emis-nota 
           and tt-nf.fm-codigo    = item.fm-codigo no-error.
    if not avail tt-nf then do:
       create tt-nf.
       assign tt-nf.i-tipo        = 2   
              tt-nf.it-codigo     = item.it-codigo
              tt-nf.class-fiscal  = it-nota-fisc.class-fiscal 
              tt-nf.nat-operacao  = it-nota-fisc.nat-operacao
              tt-nf.nr-nota-fis   = it-nota-fisc.nr-nota-fis 
              tt-nf.dt-emis-nota  = it-nota-fisc.dt-emis-nota 
              tt-nf.fm-codigo     = item.fm-codigo
              tt-nf.descricao     = item.desc-item
              tt-nf.estado        = nota-fiscal.estado
              tt-nf.cod-emitente  = nota-fiscal.cod-emitente
              tt-nf.cod-estabel   = nota-fiscal.cod-estabel              
              tt-nf.vl-taxa-exp   = nota-fiscal.vl-taxa-exp.
    end.
    assign tt-nf.qt-fatura     = it-nota-fisc.qt-faturada[1]
           tt-nf.vl-merc-liq   = it-nota-fisc.vl-merc-liq
           tt-nf.vl-ipi-it     = it-nota-fisc.vl-ipi-it
           tt-nf.vl-icms-it    = it-nota-fisc.vl-icms-it.
    
    if it-nota-fisc.nat-operacao begins "6109" then
       assign tt-nf.vl-pis-cofins = /* tt-nf.vl-pis-cofins + (it-nota-fisc.vl-merc-liq * tt-param.de-pis-cofins / 100) */
                                    (it-nota-fisc.vl-merc-liq * tt-param.de-pis-cofins / 100).
              
end.


procedure pi-devol-com-zona-franca.
   for each docum-est no-lock
      where docum-est.dt-trans = da-data
       and docum-est.cod-estabel >= tt-param.fi-cod-estab-ini 
       and docum-est.cod-estabel <= tt-param.fi-cod-estab-fim       
       and (docum-est.nat-operacao begins "2201" /*"231"*/
        or  docum-est.nat-operacao begins "2202" /*"232"*/
        or  docum-est.nat-operacao begins "1201" /*"131"*/
        or  docum-est.nat-operacao begins "1202" /*"132"*/
        or  docum-est.nat-operacao begins "3201" /*"321"*/
        or  docum-est.nat-operacao begins "2410" /*"241"*/),         
       each item-doc-est of docum-est no-lock,
       first emitente no-lock
             where emitente.cod-emitente = docum-est.cod-emitente,
       first item no-lock
            where item.it-codigo = item-doc-est.it-codigo
            AND  (ITEM.fm-codigo = "20002130"
            OR    ITEM.fm-codigo = "20003130"
            OR    ITEM.fm-codigo = "40002130"
            OR    ITEM.fm-codigo = "40003130"
            OR    ITEM.fm-codigo = "20002140"
            OR    ITEM.fm-codigo = "20003140"
            OR    ITEM.fm-codigo = "40002140"
            OR    ITEM.fm-codigo = "40003140"
            OR    ITEM.fm-codigo = "99000000"):

       find nota-fiscal no-lock 
            where nota-fiscal.cod-estabel = tt-param.cod-estabel 
              and nota-fiscal.serie       = item-doc-est.serie-comp 
              and nota-fiscal.nr-nota-fis = item-doc-est.nro-comp no-error.

       find first it-nota-fisc of nota-fiscal no-lock
            where it-nota-fisc.it-codigo = item-doc-est.it-codigo 
              and it-nota-fisc.nr-seq-fat = item-doc-est.seq-comp 
              and it-nota-fisc.nat-operacao BEGINS "6109"
              and (it-nota-fisc.class-fiscal = "85179010"
               or  it-nota-fisc.class-fiscal = "85173014" 
               or  it-nota-fisc.class-fiscal = "85173013" 
               or  it-nota-fisc.class-fiscal = "85178000" 
               or  it-nota-fisc.class-fiscal = "85171999"
               OR  it-nota-fisc.class-fiscal = "85176900"
               OR  it-nota-fisc.class-fiscal = "85176222"
               OR  it-nota-fisc.class-fiscal = "85176223"
               OR  it-nota-fisc.class-fiscal = "85177010"
               OR  it-nota-fisc.class-fiscal = "85171899") no-error.

       RUN pi-acompanhar in h-acomp (input "Devolu‡Æo com Zona Franca " + string(docum-est.nro-docto)).  

       if not avail it-nota-fisc then next.

       find first tt-nf 
            where tt-nf.i-tipo       = 5
              and tt-nf.cod-emitente = nota-fiscal.cod-emitente                   
              and tt-nf.it-codigo    = item.it-codigo 
              and tt-nf.class-fiscal = it-nota-fisc.class-fiscal 
              and tt-nf.nat-operacao = it-nota-fisc.nat-operacao 
              and tt-nf.nr-nota-fis  = nota-fiscal.nr-nota-fis 
              and tt-nf.dt-emis-nota = it-nota-fisc.dt-emis-nota 
              and tt-nf.fm-codigo    = item.fm-codigo no-error.
        if not avail tt-nf then do:
           create tt-nf.
           assign tt-nf.i-tipo        = 5
                  tt-nf.it-codigo     = item.it-codigo
                  tt-nf.class-fiscal  = it-nota-fisc.class-fiscal 
                  tt-nf.nat-operacao  = it-nota-fisc.nat-operacao
                  tt-nf.nr-nota-fis   = nota-fiscal.nr-nota-fis 
                  tt-nf.dt-emis-nota  = it-nota-fisc.dt-emis-nota
                  tt-nf.fm-codigo     = item.fm-codigo
                  tt-nf.descricao     = item.desc-item
                  tt-nf.estado        = nota-fiscal.estado
                  tt-nf.cod-emitente  = nota-fiscal.cod-emitente
                  tt-nf.cod-estabel   = nota-fiscal.cod-estabel                  
                  tt-nf.vl-taxa-exp   = nota-fiscal.vl-taxa-exp.
        end.
        
          assign tt-nf.qt-devolvida        = tt-nf.qt-devolvida        + item-doc-est.quantidade
                 tt-nf.vl-devol            = tt-nf.vl-devol            + item-doc-est.preco-total[1]
                 tt-nf.vl-ipi-devol        = tt-nf.vl-ipi-devol        + item-doc-est.valor-ipi[1]
                 tt-nf.vl-icms-devol       = tt-nf.vl-icms-devol       + item-doc-est.valor-icm[1].

        if it-nota-fisc.nat-operacao begins "6109" then
           assign tt-nf.vl-pis-cofins-devol = tt-nf.vl-pis-cofins-devol + (tt-nf.vl-devol * tt-param.de-pis-cofins / 100).
    end.
end.


procedure pi-exportacao:
               
    find first tt-nf 
         where tt-nf.i-tipo       = 3 
           and tt-nf.cod-emitente = nota-fiscal.cod-emitente                
           and tt-nf.it-codigo    = item.it-codigo 
           and tt-nf.class-fiscal = it-nota-fisc.class-fiscal 
           and tt-nf.nat-operacao = it-nota-fisc.nat-operacao 
           and tt-nf.nr-nota-fis  = it-nota-fisc.nr-nota-fis 
           and tt-nf.dt-emis-nota = it-nota-fisc.dt-emis-nota 
           and tt-nf.fm-codigo    = item.fm-codigo no-error.
    if not avail tt-nf then do:
       create tt-nf.
       assign tt-nf.i-tipo        = 3
              tt-nf.it-codigo     = item.it-codigo
              tt-nf.class-fiscal  = it-nota-fisc.class-fiscal 
              tt-nf.nat-operacao  = it-nota-fisc.nat-operacao
              tt-nf.nr-nota-fis   = it-nota-fisc.nr-nota-fis 
              tt-nf.dt-emis-nota  = it-nota-fisc.dt-emis-nota 
              tt-nf.fm-codigo     = item.fm-codigo
              tt-nf.descricao     = item.desc-item
              tt-nf.estado        = nota-fiscal.estado
              tt-nf.cod-emitente  = nota-fiscal.cod-emitente
              tt-nf.cod-estabel   = nota-fiscal.cod-estabel              
              tt-nf.vl-taxa-exp   = nota-fiscal.vl-taxa-exp.
    end.
    assign tt-nf.qt-fatura   = it-nota-fisc.qt-faturada[1]
           tt-nf.vl-merc-liq = it-nota-fisc.vl-merc-liq
           tt-nf.vl-ipi-it   = it-nota-fisc.vl-ipi-it
           tt-nf.vl-icms-it  = it-nota-fisc.vl-icms-it.

end.


procedure pi-devol-exportacao.
   for each docum-est no-lock
      where docum-est.dt-trans = da-data
       and docum-est.cod-estabel >= tt-param.fi-cod-estab-ini 
       and docum-est.cod-estabel <= tt-param.fi-cod-estab-fim       
       and (docum-est.nat-operacao begins "2201" /*"231"*/
       or   docum-est.nat-operacao begins "2202" /*"232"*/
       or   docum-est.nat-operacao begins "1201" /*"131"*/
       or   docum-est.nat-operacao begins "1202" /*"132"*/
       or   docum-est.nat-operacao begins "3201" /*"321"*/
       or  docum-est.nat-operacao begins "2410" /*"241"*/),
       each item-doc-est of docum-est no-lock,
       first emitente no-lock
             where emitente.cod-emitente = docum-est.cod-emitente,
       first item no-lock
            where item.it-codigo = item-doc-est.it-codigo
            AND  (ITEM.fm-codigo = "20002130"
            OR    ITEM.fm-codigo = "20003130"
            OR    ITEM.fm-codigo = "40002130"
            OR    ITEM.fm-codigo = "40003130"
            OR    ITEM.fm-codigo = "20002140"
            OR    ITEM.fm-codigo = "20003140"
            OR    ITEM.fm-codigo = "40002140"
            OR    ITEM.fm-codigo = "40003140"
            OR    ITEM.fm-codigo = "99000000"):

       find nota-fiscal no-lock 
            where nota-fiscal.cod-estabel = tt-param.cod-estabel 
              and nota-fiscal.serie = item-doc-est.serie-comp 
              and nota-fiscal.nr-nota-fis = item-doc-est.nro-comp no-error.

       find first it-nota-fisc of nota-fiscal no-lock
            where it-nota-fisc.it-codigo = item-doc-est.it-codigo 
              and it-nota-fisc.nr-seq-fat = item-doc-est.seq-comp 
              and it-nota-fisc.nat-operacao begins "7"
              and (it-nota-fisc.class-fiscal = "85179010"
               OR  it-nota-fisc.class-fiscal = "85173014" 
               OR  it-nota-fisc.class-fiscal = "85173013" 
               OR  it-nota-fisc.class-fiscal = "85178000" 
               OR  it-nota-fisc.class-fiscal = "85171999"
               OR  it-nota-fisc.class-fiscal = "85176900"
               OR  it-nota-fisc.class-fiscal = "85176222"
               OR  it-nota-fisc.class-fiscal = "85176223"
               OR  it-nota-fisc.class-fiscal = "85177010"
               OR  it-nota-fisc.class-fiscal = "85171899") no-error.

       RUN pi-acompanhar in h-acomp (input "Devolu‡Æo Exporta‡Æo " + string(docum-est.nro-docto)).

       if not avail it-nota-fisc then next.
        
       find first tt-nf 
            where tt-nf.i-tipo       = 6
              and tt-nf.cod-emitente = nota-fiscal.cod-emitente                   
              and tt-nf.it-codigo    = item.it-codigo 
              and tt-nf.class-fiscal = it-nota-fisc.class-fiscal 
              and tt-nf.nat-operacao = it-nota-fisc.nat-operacao 
              and tt-nf.nr-nota-fis  = nota-fiscal.nr-nota-fis 
              and tt-nf.dt-emis-nota = it-nota-fisc.dt-emis-nota 
              and tt-nf.fm-codigo    = item.fm-codigo no-error.
       if not avail tt-nf then do:
           create tt-nf.
           assign tt-nf.i-tipo        = 6
                  tt-nf.it-codigo     = item.it-codigo
                  tt-nf.class-fiscal  = it-nota-fisc.class-fiscal 
                  tt-nf.nat-operacao  = it-nota-fisc.nat-operacao
                  tt-nf.nr-nota-fis   = nota-fiscal.nr-nota-fis 
                  tt-nf.dt-emis-nota  = it-nota-fisc.dt-emis-nota
                  tt-nf.fm-codigo     = item.fm-codigo
                  tt-nf.descricao     = item.desc-item
                  tt-nf.estado        = nota-fiscal.estado
                  tt-nf.cod-emitente  = nota-fiscal.cod-emitente
                  tt-nf.cod-estabel   = nota-fiscal.cod-estabel                  
                  tt-nf.vl-taxa-exp   = nota-fiscal.vl-taxa-exp.
       end.
        
       assign tt-nf.qt-devolvida  = tt-nf.qt-devolvida  + item-doc-est.quantidade
              tt-nf.vl-devol      = tt-nf.vl-devol      + item-doc-est.preco-total[1]
              tt-nf.vl-ipi-devol  = tt-nf.vl-ipi-devol  + item-doc-est.valor-ipi[1]
              tt-nf.vl-icms-devol = tt-nf.vl-icms-devol + item-doc-est.valor-icm[1].
    end.
end.



procedure pi-nota-entrada:
    for each tt-prog-ponto6:
        assign i-cod-emitente = int(entry(1,tt-prog-ponto6.conteudo,";"))
               c-portaria     = entry(2,tt-prog-ponto6.conteudo,";").
    
        for each docum-est 
           WHERE docum-est.dt-trans = da-data
             and docum-est.cod-estabel >= tt-param.fi-cod-estab-ini
             and docum-est.cod-estabel <= tt-param.fi-cod-estab-ini
             and docum-est.ce-atual
             and docum-est.cod-emitente = i-cod-emitente no-lock:            
                
            for each item-doc-est of docum-est no-lock:
                find first tt-prog-ponto7
                     where tt-prog-ponto7.conteudo = item-doc-est.class-fiscal no-error.
                if not avail tt-prog-ponto7 then next. 
                
                find item where item.it-codigo = item-doc-est.it-codigo no-lock no-error.
                 
                RUN pi-acompanhar in h-acomp (input "Notas de Insumos " + string(docum-est.nro-docto)). 
                             
                find first tt-nf 
                     where tt-nf.i-tipo       = 7
                       and tt-nf.cod-emitente = docum-est.cod-emitente                      
                       and tt-nf.it-codigo    = item.it-codigo 
                       and tt-nf.class-fiscal = item-doc-est.class-fiscal 
                       and tt-nf.nat-operacao = docum-est.nat-operacao 
                       and tt-nf.nr-nota-fis  = docum-est.nro-docto
                       and tt-nf.dt-emis-nota = docum-est.dt-emissao
                       and tt-nf.fm-codigo    = item.fm-codigo no-error.
                if not avail tt-nf then do:
                   create tt-nf.
                   assign tt-nf.i-tipo        = 7
                          tt-nf.it-codigo     = item.it-codigo
                          tt-nf.descricao     = item.desc-item
                          tt-nf.class-fiscal  = item-doc-est.class-fiscal 
                          tt-nf.nat-operacao  = docum-est.nat-operacao
                          tt-nf.nr-nota-fis   = docum-est.nro-docto
                          tt-nf.dt-emis-nota  = docum-est.dt-emissao
                          tt-nf.fm-codigo     = item.fm-codigo
                          tt-nf.descricao     = item.desc-item
                          tt-nf.estado        = docum-est.uf
                          tt-nf.cod-emitente  = docum-est.cod-emitente
                          tt-nf.cod-estabel   = docum-est.cod-estabel
                          tt-nf.portaria      = c-portaria.
                end.

                assign tt-nf.qt-fatura     = tt-nf.qt-fatura   + item-doc-est.quantidade
                       tt-nf.vl-merc-liq   = tt-nf.vl-merc-liq + item-doc-est.preco-total[1]
                       tt-nf.vl-ipi-it     = tt-nf.vl-ipi-it   + item-doc-est.valor-ipi[1]
                       tt-nf.vl-icms-it    = tt-nf.vl-icms-it  + item-doc-est.valor-icm[1].
            end.
        end.
    end.
end procedure.
