{include/i-prgvrs.i ESREP013 2.04.00.000}
/***********************************************************************
**  Programa..: ESP\REP\ESREP013RP.P
**  Autor.....: Clayton Antunes
**  Data......: JANEIRORO/2007 - Desenvolvimento
**  Descricao.: NF de Entrada
**  VersÆo....: 001 24/01/2006
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp\rep\esrep013tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}

DEF VAR tot-quant       LIKE movto-estoq.quantidade.
DEF VAR tot-valor       LIKE movto-estoq.valor-mat-m[1].

/****************************  Temp-Tables  ****************************/
DEFINE TEMP-TABLE tt-movto-estoq NO-UNDO
    FIELD dt-trans       LIKE movto-estoq.dt-trans
    FIELD nat-operacao   LIKE movto-estoq.nat-operacao
    FIELD nro-docto      LIKE movto-estoq.nro-docto
    FIELD cod-emitente   LIKE movto-estoq.cod-emitente
    FIELD serie-docto    LIKE movto-estoq.serie-docto
    FIELD sequen-nf      LIKE movto-estoq.sequen-nf
    FIELD cod-estabel    LIKE movto-estoq.cod-estabel
    FIELD it-codigo      LIKE movto-estoq.it-codigo
    FIELD descricao      AS CHARACTER FORMAT "x(30)"
    FIELD quantidade     LIKE movto-estoq.quantidade
    FIELD valor          LIKE movto-estoq.valor-mat-m[1]
    FIELD ct-codigo-deb  LIKE movto-estoq.ct-codigo
    FIELD sc-codigo-deb  LIKE movto-estoq.sc-codigo
    FIELD ct-codigo-cre  LIKE movto-estoq.ct-codigo
    FIELD sc-codigo-cre  LIKE movto-estoq.sc-codigo
    FIELD nro-saida      LIKE movto-estoq.nro-docto
    FIELD usuario        LIKE movto-estoq.usuario
    INDEX chave it-codigo
                cod-estabel
                nro-docto
                serie-docto
                nat-operacao
                cod-emitente
                sequen-nf
    INDEX idx   cod-estabel 
                dt-trans 
                nro-docto.

/****************************  Frames       ****************************/
DEF INPUT PARAMETER raw-param as raw no-undo.
DEF INPUT PARAMETER table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

DEF VAR h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "NF de Entrada"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESREP007"
       c-versao       = "2.04"
       c-revisao      = "001".


/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i}

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    
    RUN piCarregaDados.

    IF opcao = 1 THEN DO:
       RUN piMontaRelatAnalitico.
    END.
    ELSE DO:
       RUN piMontaRelatSintetico.
    END.

    RUN pi-finalizar in h-acomp. 

    {include/i-rpclo.i} 

    RETURN "OK".
END.

PROCEDURE piCarregaDados:
    RUN pi-inicializar IN h-acomp (INPUT "Carregando Notas Entrada...").

    FOR EACH docum-est NO-LOCK
       WHERE docum-est.cod-estabel  >= tt-param.cod-estab-ini
         AND docum-est.cod-estabel  <= tt-param.cod-estab-fim
         AND docum-est.dt-trans     >= tt-param.data-ini
         AND docum-est.dt-trans     <= tt-param.data-fim,
/*          AND docum-est.nat-operacao >= tt-param.nat-operacao-ini  */
/*          AND docum-est.nat-operacao <= tt-param.nat-operacao-fim, */
       FIRST natur-oper NO-LOCK
       WHERE natur-oper.nat-operacao = docum-est.nat-operacao
         AND natur-oper.terceiros:

        RUN pi-acompanhar IN h-acomp (INPUT "Est: " + STRING(docum-est.cod-estabel) + " - Data: " + STRING(docum-est.dt-trans,"99/99/99")).

        FOR EACH item-doc-est OF docum-est
           WHERE item-doc-est.it-codigo >= tt-param.it-codigo-ini
             AND item-doc-est.it-codigo <= tt-param.it-codigo-fim
             AND item-doc-est.nat-of    >= tt-param.nat-operacao-ini
             AND item-doc-est.nat-of    <= tt-param.nat-operacao-fim,
           FIRST ITEM NO-LOCK           
           WHERE ITEM.it-codigo = item-doc-est.it-codigo:
    
            FOR EACH movto-estoq 
               WHERE movto-estoq.it-codigo    = item-doc-est.it-codigo    
                 AND movto-estoq.cod-estabel  = docum-est.cod-estabel       
                 AND movto-estoq.nro-docto    = item-doc-est.nro-docto    
                 AND movto-estoq.serie-docto  = item-doc-est.serie-docto  
                 AND movto-estoq.nat-operacao = item-doc-est.nat-operacao 
                 AND movto-estoq.cod-emitente = item-doc-est.cod-emitente 
                 AND movto-estoq.sequen-nf    = item-doc-est.sequencia NO-LOCK:
    
                FIND FIRST tt-movto-estoq NO-LOCK 
                     WHERE tt-movto-estoq.it-codigo    = movto-estoq.it-codigo
                       AND tt-movto-estoq.cod-estabel  = movto-estoq.cod-estabel
                       AND tt-movto-estoq.nro-docto    = movto-estoq.nro-docto
                       AND tt-movto-estoq.serie-docto  = movto-estoq.serie-docto
                       AND tt-movto-estoq.nat-operacao = movto-estoq.nat-operacao
                       AND tt-movto-estoq.cod-emitente = movto-estoq.cod-emitente
                       AND tt-movto-estoq.sequen-nf    = movto-estoq.sequen-nf NO-ERROR.
                IF NOT AVAIL tt-movto-estoq THEN DO:
                    CREATE tt-movto-estoq.
                    ASSIGN tt-movto-estoq.it-codigo      = movto-estoq.it-codigo
                           tt-movto-estoq.cod-estabel    = movto-estoq.cod-estabel
                           tt-movto-estoq.nro-docto      = movto-estoq.nro-docto
                           tt-movto-estoq.serie-docto    = movto-estoq.serie-docto
                           tt-movto-estoq.nat-operacao   = movto-estoq.nat-operacao
                           tt-movto-estoq.cod-emitente   = movto-estoq.cod-emitente
                           tt-movto-estoq.sequen-nf      = movto-estoq.sequen-nf
                           tt-movto-estoq.dt-trans       = movto-estoq.dt-trans
                           tt-movto-estoq.descricao      = ITEM.descricao-1 + ITEM.descricao-2
                           tt-movto-estoq.nro-saida      = item-doc-est.nro-comp
                           tt-movto-estoq.usuario        = movto-estoq.usuario
                           tt-movto-estoq.quantidade     = movto-estoq.quantidade
                           tt-movto-estoq.valor          = movto-estoq.valor-mat-m[1].
                END.
    
                IF movto-estoq.tipo-trans = 1 THEN
                    ASSIGN tt-movto-estoq.ct-codigo-cre  = movto-estoq.ct-codigo
                           tt-movto-estoq.sc-codigo-cre  = movto-estoq.sc-codigo.
                ELSE IF movto-estoq.tipo-trans = 2 THEN
                    ASSIGN tt-movto-estoq.ct-codigo-deb  = movto-estoq.ct-codigo
                           tt-movto-estoq.sc-codigo-deb  = movto-estoq.sc-codigo.
    
            END.
        END.
    END.

    RUN pi-inicializar IN h-acomp (INPUT "Carregando Notas Saida...").

    FOR EACH nota-fiscal NO-LOCK USE-INDEX ch-distancia
       WHERE nota-fiscal.dt-emis-nota >= tt-param.data-ini
         AND nota-fiscal.dt-emis-nota <= tt-param.data-fim
         AND nota-fiscal.cod-estabel  >= tt-param.cod-estab-ini
         AND nota-fiscal.cod-estabel  <= tt-param.cod-estab-fim
         AND nota-fiscal.nat-operacao >= tt-param.nat-operacao-ini
         AND nota-fiscal.nat-operacao <= tt-param.nat-operacao-fim,
       FIRST natur-oper NO-LOCK
       WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
         AND natur-oper.terceiros:

        RUN pi-acompanhar IN h-acomp (INPUT "Est: " + STRING(nota-fiscal.cod-estabel) + " - Data: " + STRING(nota-fiscal.dt-emis-nota,"99/99/99")).

        FOR EACH it-nota-fisc OF nota-fiscal
           WHERE it-nota-fisc.it-codigo >= tt-param.it-codigo-ini
             AND it-nota-fisc.it-codigo <= tt-param.it-codigo-fim,
           FIRST ITEM NO-LOCK
           WHERE ITEM.it-codigo = it-nota-fisc.it-codigo:
    
            FOR EACH movto-estoq 
               WHERE movto-estoq.it-codigo    = it-nota-fisc.it-codigo    
                 AND movto-estoq.cod-estabel  = nota-fiscal.cod-estabel       
                 AND movto-estoq.nro-docto    = it-nota-fisc.nr-nota-fis    
                 AND movto-estoq.serie-docto  = it-nota-fisc.serie  
                 AND movto-estoq.nat-operacao = it-nota-fisc.nat-operacao 
                 AND movto-estoq.cod-emitente = nota-fiscal.cod-emitente 
                 AND movto-estoq.sequen-nf    = it-nota-fisc.nr-seq-fat NO-LOCK:
    
                FIND FIRST tt-movto-estoq NO-LOCK 
                     WHERE tt-movto-estoq.it-codigo    = movto-estoq.it-codigo
                       AND tt-movto-estoq.cod-estabel  = movto-estoq.cod-estabel
                       AND tt-movto-estoq.nro-docto    = movto-estoq.nro-docto
                       AND tt-movto-estoq.serie-docto  = movto-estoq.serie-docto
                       AND tt-movto-estoq.nat-operacao = movto-estoq.nat-operacao
                       AND tt-movto-estoq.cod-emitente = movto-estoq.cod-emitente
                       AND tt-movto-estoq.sequen-nf    = movto-estoq.sequen-nf NO-ERROR.
                IF NOT AVAIL tt-movto-estoq THEN DO:
                    CREATE tt-movto-estoq.
                    ASSIGN tt-movto-estoq.it-codigo      = movto-estoq.it-codigo
                           tt-movto-estoq.cod-estabel    = movto-estoq.cod-estabel
                           tt-movto-estoq.nro-docto      = movto-estoq.nro-docto
                           tt-movto-estoq.serie-docto    = movto-estoq.serie-docto
                           tt-movto-estoq.nat-operacao   = movto-estoq.nat-operacao
                           tt-movto-estoq.cod-emitente   = movto-estoq.cod-emitente
                           tt-movto-estoq.sequen-nf      = movto-estoq.sequen-nf
                           tt-movto-estoq.dt-trans       = movto-estoq.dt-trans
                           tt-movto-estoq.descricao      = ITEM.descricao-1 + ITEM.descricao-2
                           tt-movto-estoq.nro-saida      = ""
                           tt-movto-estoq.usuario        = movto-estoq.usuario
                           tt-movto-estoq.quantidade     = movto-estoq.quantidade    
                           tt-movto-estoq.valor          = movto-estoq.valor-mat-m[1].
                END.
    
                IF movto-estoq.tipo-trans = 1 THEN
                    ASSIGN tt-movto-estoq.ct-codigo-cre  = movto-estoq.ct-codigo
                           tt-movto-estoq.sc-codigo-cre  = movto-estoq.sc-codigo.
                ELSE IF movto-estoq.tipo-trans = 2 THEN
                    ASSIGN tt-movto-estoq.ct-codigo-deb  = movto-estoq.ct-codigo
                           tt-movto-estoq.sc-codigo-deb  = movto-estoq.sc-codigo.
    
            END.
        END.
    END.

END PROCEDURE.

PROCEDURE piMontaRelatAnalitico.

    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").

    PUT UNFORMATTED
        "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Est DT.Trans   Docto     Nat Oper Emitente Item     Descri‡Æo                            Quantidade      Valor          Conta Deb  Sub-Conta  Conta Cred Sub-Conta  NF Sa¡da  Usu rio " SKIP
        "--- ---------- --------- -------- -------- -------- ------------------------------------ --------------- -------------- ---------- ---------- ---------- ---------- --------- --------" SKIP. 
    
    FOR EACH tt-movto-estoq NO-LOCK
        BY tt-movto-estoq.cod-estabel
        BY tt-movto-estoq.dt-trans    
        BY tt-movto-estoq.nro-docto: 
         
        PUT UNFORMATTED 
             tt-movto-estoq.cod-estabel    FORMAT "x(03)"          AT 01
             tt-movto-estoq.dt-trans       FORMAT "99/99/9999"     AT 05
             tt-movto-estoq.nro-docto      FORMAT "x(8)"           AT 16
             tt-movto-estoq.nat-operacao   FORMAT "9999999"        AT 26
             tt-movto-estoq.cod-emitente                           AT 35
             tt-movto-estoq.it-codigo      FORMAT "x(8)"           AT 44
             tt-movto-estoq.descricao      FORMAT "x(36)"          AT 53
             tt-movto-estoq.quantidade     FORMAT ">>>,>>>,>>9.99" AT 91
             tt-movto-estoq.valor          FORMAT ">>>,>>>,>>9.99" AT 106
             tt-movto-estoq.ct-codigo-deb  FORMAT "x(10)"          AT 121
             tt-movto-estoq.sc-codigo-deb  FORMAT "x(10)"          AT 132
             tt-movto-estoq.ct-codigo-cre  FORMAT "x(10)"          AT 143
             tt-movto-estoq.sc-codigo-cre  FORMAT "x(10)"          AT 154
             tt-movto-estoq.nro-saida      FORMAT "x(10)"          AT 165
             tt-movto-estoq.usuario        FORMAT "x(08)"          AT 175 SKIP.
    END.
END.




PROCEDURE piMontaRelatSintetico.

    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").

    PUT UNFORMATTED
        "----------------------------------------------------------------------------------------------------------------------------------------" 
        "Est DT.Trans   Docto     Nat Oper Emitente Quantidade      Valor          Conta Deb  Sub-Conta  Conta Cred Sub-Conta  NF Sa¡da  Usu rio " 
        "--- ---------- --------- -------- -------- --------------- -------------- ---------- ---------- ---------- ---------- --------- --------" SKIP.
                                                                                                                                                 
    FOR EACH tt-movto-estoq NO-LOCK 
        BREAK BY tt-movto-estoq.cod-estabel
              BY tt-movto-estoq.dt-trans
              BY tt-movto-estoq.nro-docto:  

        IF FIRST-OF(tt-movto-estoq.nro-docto) THEN DO:
           ASSIGN tot-quant = 0
                  tot-valor = 0.
        END.

        ASSIGN tot-quant = tot-quant + tt-movto-estoq.quantidade
               tot-valor = tot-valor + tt-movto-estoq.valor.

        IF LAST-OF(tt-movto-estoq.nro-docto) THEN DO:
                 
            PUT UNFORMATTED 
                 tt-movto-estoq.cod-estabel    FORMAT "x(03)"            AT 01
                 tt-movto-estoq.dt-trans       FORMAT "99/99/9999"       AT 05
                 tt-movto-estoq.nro-docto      FORMAT "x(8)"             AT 16
                 tt-movto-estoq.nat-operacao   FORMAT "9999999"          AT 26
                 tt-movto-estoq.cod-emitente                             AT 35
                 tot-quant                     FORMAT ">,>>>,>>>,>>9.99" AT 44
                 tot-valor                     FORMAT ">>>,>>>,>>9.99"   AT 60
                 tt-movto-estoq.ct-codigo-deb  FORMAT "x(10)"            AT 75
                 tt-movto-estoq.sc-codigo-deb  FORMAT "x(10)"            AT 86
                 tt-movto-estoq.ct-codigo-cre  FORMAT "x(10)"            AT 97
                 tt-movto-estoq.sc-codigo-cre  FORMAT "x(10)"            AT 108
                 tt-movto-estoq.nro-saida      FORMAT "x(10)"            AT 119
                 tt-movto-estoq.usuario        FORMAT "x(08)"            AT 129 SKIP.
        END.
    END.
END.



