/****************************************************************************************/
/* Programa.: ESESBAPI002-FAT-DEV.p - Busca Faturamento por Canal e Unidade de neg¢cio            */
/* Funá∆o...: Retornar a temp-table com o faturamento mensal por canal e UnidNeg        */
/* Data.....: 07/04/2014                                                                */
/****************************************************************************************/

{esp/esb/esesbapi002.i} /*tt-canal*/
{esp/esb/esesbapi002.i1} /*int-fat-mensal e int-fat-mensal-det */
    
/* Definiá∆o da tt-central */                       
{esp/esb/esesbapi005.i}
DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

/*--------------------------------------------------*/
/*                   PAR∂METROS                     */
/*--------------------------------------------------*/
DEFINE INPUT  PARAMETER p-da-ini  AS DATE NO-UNDO.
DEFINE INPUT  PARAMETER p-da-fim  AS DATE NO-UNDO.
DEFINE INPUT  PARAMETER p-tipo AS CHAR NO-UNDO. /* Indica se Ç calculo ou provisionamento */
DEFINE INPUT  PARAMETER TABLE FOR tt-central.
DEFINE OUTPUT PARAMETER TABLE FOR tt-fat-mensal.
DEFINE OUTPUT PARAMETER TABLE FOR tt-fat-mensal-det.
DEFINE OUTPUT PARAMETER TABLE FOR tt-canal.
DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

DEFINE VARIABLE c-unid-negoc AS CHARACTER NO-UNDO.
                                          
DEFINE VARIABLE h-acomp AS HANDLE.
DEFINE VARIABLE l-considerar-para-base-do-rebate AS LOGICAL INIT YES NO-UNDO.
DEF VAR da-data             AS DATE    NO-UNDO.

IF  NOT VALID-HANDLE(h-acomp) THEN                                  
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                      
IF  VALID-HANDLE(h-acomp) THEN                                      
    RUN pi-inicializar IN h-acomp (INPUT "Apurando o Faturamento/Devoluá‰es do per°odo ").

/* PRINCIPAL */
RUN pi-apura-faturamento-mensal.

IF  RETURN-VALUE <> "OK" THEN DO:
    if valid-handle(h-acomp) then    
        RUN pi-finalizar IN h-acomp. 

    RETURN "NOK".
END.
    

if valid-handle(h-acomp) then    
    RUN pi-finalizar IN h-acomp. 

RETURN "OK".
/* F I M */


/*-----------------------------------*/
/*       PROCEDURES INTERNAS         */
/*-----------------------------------*/
PROCEDURE pi-apura-faturamento-mensal:
    
    /* Armazenar† os canais para buscar seus benef°cios */
    EMPTY TEMP-TABLE tt-canal.

    /*  V E N D A S  */                                                     
    RUN pi-vendas.


    /*  D E V O L U Ä Â E S  */
    RUN pi-devolucoes.
    
    /*  S E L L U O T  */
    RUN pi-apura-sell-out.
    
    IF  NOT CAN-FIND (FIRST tt-fat-mensal) THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "N∆o existe base de faturamento para o per°odo.",
                                            INPUT "O per°odo informado n∆o retornou faturamentos ou devoluá‰es para processamento."  ).
        RETURN "NOK".

    END.

    RETURN "OK".
     
END.


PROCEDURE pi-apura-sell-out:
    RETURN "OK".
END.


PROCEDURE pi-gera-detalhes-movimento:

    DEF INPUT PARAM p-tp-movto AS INTEGER NO-UNDO.

    CREATE tt-fat-mensal-det.
    ASSIGN tt-fat-mensal-det.ano          = YEAR(da-data)
           tt-fat-mensal-det.mes          = MONTH(da-data)
           tt-fat-mensal-det.canal        = tt-central.canal-central /* SEMPRE DA FILIAL */
           tt-fat-mensal-det.unid-neg     = c-unid-negoc
           tt-fat-mensal-det.tipo         = p-tipo
           tt-fat-mensal-det.tp-movto     = p-tp-movto
           
           /* Informaá‰es da Nota Fiscal */  
           tt-fat-mensal-det.cod-estabel  = it-nota-fisc.cod-estabel
           tt-fat-mensal-det.serie        = it-nota-fisc.serie       
           tt-fat-mensal-det.nr-nota-fis  = it-nota-fisc.nr-nota-fis
           tt-fat-mensal-det.nr-seq-fat   = it-nota-fisc.nr-seq-fat 
           tt-fat-mensal-det.it-codigo    = it-nota-fisc.it-codigo
           tt-fat-mensal-det.qt-faturada  = IF p-tp-movto = 1 THEN it-nota-fisc.qt-faturada[1] ELSE 0
           tt-fat-mensal-det.vl-faturado  = IF p-tp-movto = 1 THEN (it-nota-fisc.vl-merc-liq /*+ it-nota-fisc.vl-despes-it*/) ELSE 0.

     /* se n∆o for rebate, ent∆o acumula para compor a base de calculo do rebate */
     IF  l-considerar-para-base-do-rebate THEN
         ASSIGN tt-fat-mensal-det.qt-faturada-rebate = IF p-tp-movto = 1 THEN it-nota-fisc.qt-faturada[1] ELSE 0
                tt-fat-mensal-det.vl-faturado-rebate = IF p-tp-movto = 1 THEN (it-nota-fisc.vl-merc-liq /*+ it-nota-fisc.vl-despes-it*/) ELSE 0.

           
     IF  p-tp-movto = 1 THEN tt-fat-mensal-det.cod-emitente = nota-fiscal.cod-emitente.

     /* Informaá‰es da Devoluá∆o (item-doc-est) */           
     IF  AVAIL devol-cli THEN DO:
         ASSIGN  tt-fat-mensal-det.serie-docto  = devol-cli.serie-docto
                 tt-fat-mensal-det.nro-docto    = devol-cli.nro-docto                                                                                                                       
                 tt-fat-mensal-det.cod-emitente = devol-cli.cod-emitente
                 tt-fat-mensal-det.nat-operacao = devol-cli.nat-operacao
                 tt-fat-mensal-det.sequencia    = devol-cli.sequencia
                 tt-fat-mensal-det.qt-devolvida = devol-cli.qt-devolvida
                 tt-fat-mensal-det.vl-devolvido = item-doc-est.preco-total[1].

         /* se n∆o for rebate, ent∆o acumula para compor a base de calculo do rebate */
         IF  l-considerar-para-base-do-rebate THEN
             ASSIGN tt-fat-mensal-det.qt-devolvida-rebate = devol-cli.qt-devolvida
                    tt-fat-mensal-det.vl-devolvido-rebate = item-doc-est.preco-total[1].
     END.       
     
     ASSIGN tt-fat-mensal-det.data         = IF  AVAIL devol-cli THEN 
                                                 devol-cli.dt-devol 
                                             ELSE 
                                                IF  p-tp-movto = 1 THEN 
                                                    nota-fiscal.dt-emis-nota
                                                ELSE 
                                                    ?.
            tt-fat-mensal-det.canal-central = tt-central.canal-central.
    
    RETURN "OK".
END. 


PROCEDURE pi-vendas:

    DEF VAR i-emitente-ant      AS INTEGER NO-UNDO.
    
    FOR EACH tt-central
       , EACH nota-fiscal NO-LOCK USE-INDEX ch-emi-nota
             WHERE nota-fiscal.cod-emitente = tt-central.canal-filial
               AND nota-fiscal.dt-emis-nota >= p-da-ini
               AND nota-fiscal.dt-emis-nota <= p-da-fim
               AND nota-fiscal.dt-cancel     = ?
               AND nota-fiscal.dt-emis-nota >= tt-central.dt-adesao-filial
       , FIRST emitente  NO-LOCK
              WHERE emitente.cod-emitente = nota-fiscal.cod-emitente
       , FIRST natur-oper  NO-LOCK
             WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
               AND natur-oper.tipo > 1 
              /* AND natur-oper.emite-duplic */ /* s¢ sa°das que geram duplicatas   */
              AND natur-oper.atual-estat  /* s¢ sa°das que geram estat°sticas */
       , EACH it-nota-fisc OF nota-fiscal NO-LOCK
        ,  FIRST item NO-LOCK
                WHERE item.it-codigo = it-nota-fisc.it-codigo:

        ASSIGN c-unid-negoc = "".

        /* DESCONSIDERAR OS PEDIDOS QUE POSSUEM SOLICITAÄ«O */
        FOR FIRST ped-venda USE-INDEX ch-pedido
            WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
              AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-LOCK:
        
            IF  CAN-FIND (FIRST int-solicitacao-item
                            WHERE int-solicitacao-item.nome-abrev = ped-venda.nome-abrev
                              AND int-solicitacao-item.nr-pedcli  = ped-venda.nr-pedcli) THEN DO:

                IF  CAN-FIND (FIRST int-solicitacao
                                WHERE int-solicitacao.CodigoSolicitacaoBeneficio = int-solicitacao-item.CodigoSolicitacaoBeneficio
                                  AND int-solicitacao.int-1 = 0 /*Distribuidor*/
                                  AND (int-solicitacao.tipo-beneficio <> 04  /* STOCK BACKUP  */ and int-solicitacao.tipo-beneficio <> 15) /* SHOW ROOM */   ) THEN
                    NEXT.
            END.
                
        END.

        FIND FIRST int-ped-item-rebate NO-LOCK
           WHERE int-ped-item-rebate.nome-abrev    = it-nota-fisc.nome-ab-cli
             AND int-ped-item-rebate.nr-pedcli     = it-nota-fisc.nr-pedcli  
             AND int-ped-item-rebate.nr-sequencia  = it-nota-fisc.nr-seq-ped 
             AND int-ped-item-rebate.it-codigo     = it-nota-fisc.it-codigo  
             AND int-ped-item-rebate.cod-refer     = it-nota-fisc.cod-refer  NO-ERROR.

        IF  AVAIL int-ped-item-rebate AND int-ped-item-rebate.log-calcrebate = NO THEN
            ASSIGN l-considerar-para-base-do-rebate = NO.
        ELSE
            ASSIGN l-considerar-para-base-do-rebate = YES.

        IF  i-emitente-ant <> emitente.cod-emitente THEN DO:
            RUN pi-acompanhar IN h-acomp ("Apurando faturamento canal " + STRING(emitente.cod-emitente)).
            ASSIGN i-emitente-ant = emitente.cod-emitente.
        END.

        /* UNIDADE DE NEG‡CIO */
        IF  it-nota-fisc.cod-unid-negoc <> "" THEN DO:
            ASSIGN c-unid-negoc = it-nota-fisc.cod-unid-negoc.
        END.
        ELSE
            FOR FIRST item-uni-estab  NO-LOCK
                WHERE item-uni-estab.cod-estabel = nota-fiscal.cod-estabel
                  AND item-uni-estab.it-codigo   = it-nota-fisc.it-codigo:
                ASSIGN c-unid-negoc = item-uni-estab.cod-unid-negoc. 
            END.
        
        ASSIGN da-data = nota-fiscal.dt-emis-nota.

        RUN pi-cria-tt-fat-mensal.

        RUN pi-gera-detalhes-movimento (INPUT 1 /*Fat*/).
    
        IF  RETURN-VALUE <> "OK" THEN
            RETURN "NOK".
      
        ASSIGN tt-fat-mensal.vl-faturado = tt-fat-mensal.vl-faturado + (it-nota-fisc.vl-merc-liq /*+ it-nota-fisc.vl-despes-it*/)
               tt-fat-mensal.vl-apurado  = tt-fat-mensal.vl-faturado.

        IF  l-considerar-para-base-do-rebate THEN
            ASSIGN tt-fat-mensal.vl-faturado-rebate = tt-fat-mensal.vl-faturado-rebate + (it-nota-fisc.vl-merc-liq /*+ it-nota-fisc.vl-despes-it*/)
                   tt-fat-mensal.vl-apurado-rebate  = tt-fat-mensal.vl-faturado-rebate.

      END.

    RETURN "OK".
END.


PROCEDURE pi-devolucoes:

    DEFINE VARIABLE i-emitente-ant AS INTEGER NO-UNDO.
    DEFINE VARIABLE da-data-dev    AS DATE  NO-UNDO.
    
    /* Devolucoes */
    DO da-data-dev = p-da-ini TO p-da-fim:

        FOR EACH tt-central
          ,EACH devol-cli USE-INDEX ch-dt-emit NO-LOCK 
               WHERE devol-cli.dt-devol     = da-data-dev
                 AND devol-cli.dt-devol    >= tt-central.dt-adesao-filial
                 AND devol-cli.nome-ab-emi  = tt-central.nome-abrev-filial
          ,EACH item-doc-est 
              OF devol-cli NO-LOCK
          ,FIRST emitente NO-LOCK
               WHERE emitente.cod-emitente = devol-cli.cod-emitente
          ,FIRST it-nota-fisc NO-LOCK
              WHERE it-nota-fisc.cod-estabel = devol-cli.cod-estabel
                AND it-nota-fisc.serie       = devol-cli.serie
                AND it-nota-fisc.nr-nota-fis = devol-cli.nr-nota-fis
                AND it-nota-fisc.nr-seq-fat  = devol-cli.nr-sequencia
                AND it-nota-fisc.it-codigo   = devol-cli.it-codigo
          , FIRST nota-fiscal
               OF it-nota-fisc NO-LOCK
          , FIRST natur-oper  NO-LOCK
              WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
                AND natur-oper.atual-estat:  /** Ignora notas que n∆o geram faturamento **/
               
           IF  i-emitente-ant <> emitente.cod-emitente THEN DO:
                RUN pi-acompanhar IN h-acomp ("Apurando Devoluá‰es Canal " + STRING(emitente.cod-emitente)).
                ASSIGN i-emitente-ant = emitente.cod-emitente.
           END.

           /* DESCONSIDERAR OS PEDIDOS QUE POSSUEM SOLICITAÄ«O */
           FOR FIRST ped-venda USE-INDEX ch-pedido
               WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                 AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-LOCK:
           
               IF  CAN-FIND (FIRST int-solicitacao-item
                               WHERE int-solicitacao-item.nome-abrev = ped-venda.nome-abrev
                                 AND int-solicitacao-item.nr-pedcli  = ped-venda.nr-pedcli) THEN DO:
                   IF  CAN-FIND (FIRST int-solicitacao
                                   WHERE int-solicitacao.CodigoSolicitacaoBeneficio = int-solicitacao-item.CodigoSolicitacaoBeneficio
                                      AND int-solicitacao.int-1 = 0 /*Distribuidor*/
                                      AND (int-solicitacao.tipo-beneficio <> 04  /* STOCK BACKUP  */ and int-solicitacao.tipo-beneficio <> 15) /* SHOW ROOM */   ) THEN
                       NEXT.
               END.
           END.

           FIND FIRST int-ped-item-rebate NO-LOCK
              WHERE int-ped-item-rebate.nome-abrev    = it-nota-fisc.nome-ab-cli
                AND int-ped-item-rebate.nr-pedcli     = it-nota-fisc.nr-pedcli  
                AND int-ped-item-rebate.nr-sequencia  = it-nota-fisc.nr-seq-ped 
                AND int-ped-item-rebate.it-codigo     = it-nota-fisc.it-codigo  
               AND int-ped-item-rebate.cod-refer     = it-nota-fisc.cod-refer  NO-ERROR.

            IF  AVAIL int-ped-item-rebate AND int-ped-item-rebate.log-calcrebate = NO THEN
                ASSIGN l-considerar-para-base-do-rebate = NO.
            ELSE
                ASSIGN l-considerar-para-base-do-rebate = YES.


           ASSIGN c-unid-negoc = "".

           /* UNIDADE DE NEG‡CIO */
           IF  it-nota-fisc.cod-unid-negoc <> "" THEN DO:
               ASSIGN c-unid-negoc = it-nota-fisc.cod-unid-negoc.
           END.
           ELSE
               FOR FIRST item-uni-estab NO-LOCK
                   WHERE item-uni-estab.cod-estabel = it-nota-fisc.cod-estabel
                     AND item-uni-estab.it-codigo   = it-nota-fisc.it-codigo:
                   
                     ASSIGN c-unid-negoc = item-uni-estab.cod-unid-negoc. 
               END.

           FOR FIRST item NO-LOCK
              WHERE item.it-codigo = it-nota-fisc.it-codigo: 
           END.
      
           ASSIGN da-data = devol-cli.dt-devol.
           RUN pi-cria-tt-fat-mensal.
    
           RUN pi-gera-detalhes-movimento (INPUT 2 /*Dev*/).
        
           IF  RETURN-VALUE <> "OK" THEN
               RETURN "NOK".
           
           IF  NOT AVAIL tt-fat-mensal THEN 
               RETURN "NOK".
    
           ASSIGN tt-fat-mensal.vl-devolvido = tt-fat-mensal.vl-devolvido + item-doc-est.preco-total[1]
                  tt-fat-mensal.vl-apurado   = tt-fat-mensal.vl-apurado - (item-doc-est.preco-total[1]).

            IF  l-considerar-para-base-do-rebate THEN
                ASSIGN tt-fat-mensal.vl-devolvido-rebate = tt-fat-mensal.vl-devolvido-rebate + item-doc-est.preco-total[1]
                       tt-fat-mensal.vl-apurado-rebate   = tt-fat-mensal.vl-apurado-rebate - (item-doc-est.preco-total[1]).
        END.
    END.

    RETURN "OK".
END.

PROCEDURE pi-cria-tt-fat-mensal:
   
    /* A apuraá∆o dos valores faturados/devolvidos Ç feita sempre em relaá∆o ao parÉmetro ApuraBeneficio do canal   */
    /* Caso seja centralizado, os faturamentos das filiais s∆o totalizadas na central (Matriz), que Ç o canal que   */
    /* ter† a conta corrente de benef°cios                                                                          */

    /* OBS: A TT-FAT-MENSAL, SERPRE TOTALIZA OS VALORES NA CENTRAL, LOGO O TT-FAT-MENSAL.CANAL SERµ O CANAL CENTRAL */
    /*      ISTO ê, O O TT-CENTRAL.CANAL-CENTRAL, ONDE O EMITENTE POSSUI APURAÄ«O DE BENEF÷CIOS CENTRALIZADA        */
    FIND FIRST tt-fat-mensal
        WHERE tt-fat-mensal.ano      = YEAR(da-data)
          AND tt-fat-mensal.mes      = MONTH(da-data)
          AND tt-fat-mensal.canal    = tt-central.canal-central
          AND tt-fat-mensal.unid-neg = c-unid-negoc
          AND tt-fat-mensal.tipo     = p-tipo NO-ERROR.
 
    IF  NOT AVAIL tt-fat-mensal THEN DO:
 
        RUN pi-valida-campo-em-branco (INPUT "Unidade de Neg¢cio", INPUT c-unid-negoc).      
        IF  RETURN-VALUE = "NOK" THEN RETURN "NOK".
        
        /* Valida Classificaá∆o do canal */
        CREATE tt-fat-mensal.          
        ASSIGN tt-fat-mensal.ano           = YEAR(da-data)
               tt-fat-mensal.mes           = month(da-data)
               tt-fat-mensal.canal         = tt-central.canal-central
               tt-fat-mensal.unid-neg      = c-unid-negoc
               tt-fat-mensal.tipo          = p-tipo
               tt-fat-mensal.guid-canal    = tt-central.guid-canal-central.
    END.

    IF  CAN-FIND (FIRST tt-canal WHERE tt-canal.canal = tt-fat-mensal.canal) THEN
        RETURN "OK".

    CREATE tt-canal.
    ASSIGN tt-canal.canal       = tt-fat-mensal.canal
           tt-canal.guid-canal  = tt-fat-mensal.guid-canal
           tt-canal.guid-class  = tt-central.guid-class-central.

   RETURN "OK".

END.

PROCEDURE pi-valida-campo-em-branco:
    DEF INPUT PARAM p-campo AS CHAR NO-UNDO.
    DEF INPUT PARAM p-valor AS CHAR NO-UNDO.
    IF  p-valor = ""
    OR  p-valor = ? THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "Campo <" + p-campo + "> n∆o preenchido.",
                                            INPUT "Canal: " + STRING(int-emitente.cod-emitente) 
                                                            + " / Unid Neg.: " + c-unid-negoc).
        RETURN "NOK".
    END.

    RETURN "OK".
END.

PROCEDURE pi-cria-erro:

    DEFINE INPUT PARAM p-erro     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM p-mensagem AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-ajuda    AS CHAR NO-UNDO.

    CREATE tt-erro.
    ASSIGN tt-erro.codigo   = p-erro
           tt-erro.mensagem = p-mensagem
           tt-erro.ajuda    = p-ajuda.

END.

