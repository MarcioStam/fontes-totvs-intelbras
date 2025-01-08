/****************************************************************************************/
/* Programa.: ESESB003a.p - Busca Faturamento por Canal e Unidade de neg¢cio            */
/* Funá∆o...: Retornar a temp-table com o faturamento mensal por canal e UnidNeg        */
/* Data.....: 07/04/2014                                                                */
/****************************************************************************************/

{esp/esb/esesbapi002.i}
    
/* Definiá∆o da tt-central */                       
{esp/esb/esesbapi005.i}
DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

/*--------------------------------------------------*/
/*                   PAR∂METROS                     */
/*--------------------------------------------------*/
DEFINE INPUT  PARAMETER p-ano AS INTEGER NO-UNDO.
DEFINE INPUT  PARAMETER p-mes AS INTEGER NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-central.
DEFINE OUTPUT PARAMETER TABLE FOR tt-fat-mensal.
DEFINE OUTPUT PARAMETER TABLE FOR tt-fat-mensal-det.
DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

DEFINE VARIABLE c-unid-negoc AS CHARACTER NO-UNDO.
DEFINE VARIABLE da-ini AS DATE            NO-UNDO.
DEFINE VARIABLE da-fim AS DATE            NO-UNDO.
                                          
DEFINE VARIABLE h-acomp AS HANDLE.

IF  NOT VALID-HANDLE(h-acomp) THEN                                  
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                      
IF  VALID-HANDLE(h-acomp) THEN                                      
    RUN pi-inicializar IN h-acomp (INPUT "Apurando o Faturamento/Devoluá‰es do per°odo ").

/* Cria a data inicial e final com base no ano e mes informados em tela */
RUN pi-retorna-datas (INPUT p-mes,
                      INPUT p-ano).

/* PRINCIPAL */
RUN pi-apura-faturamento-mensal.

IF  RETURN-VALUE <> "OK" THEN
    RETURN "NOK".

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
                                            INPUT "N∆o existe base de faturamento para processamento.",
                                            INPUT "Favor entrar em contato com a TIC da Intelbras."  ).
        RETURN "NOK".

    END.

    RETURN "OK".
     
END.


PROCEDURE pi-apura-sell-out:
    RETURN "OK".
END.


PROCEDURE pi-cria-tt-fat-mensal:
   
    /* A apuraá∆o dos valores faturados/devolvidos Ç feita sempre em relaá∆o ao parÉmetro ApuraBeneficio do canal   */
    /* Caso seja centralizado, os faturamentos das filiais s∆o totalizadas na central (Matriz), que Ç o canal que   */
    /* ter† a conta corrente de benef°cios                                                                          */

    /* OBS: A TT-FAT-MENSAL, SERPRE TOTALIZA OS VALORES NA CENTRAL, LOGO O TT-FAT-MENSAL.CANAL SERµ O CANAL CENTRAL */
    /*      ISTO ê, O O TT-CENTRAL.CANAL-CENTRAL, ONDE O EMITENTE POSSUI APURAÄ«O DE BENEF÷CIOS CENTRALIZADA        */
    FIND FIRST tt-fat-mensal
        WHERE tt-fat-mensal.ano      = p-ano
          AND tt-fat-mensal.mes      = p-mes
          AND tt-fat-mensal.canal    = tt-central.canal-central
          AND tt-fat-mensal.unid-neg = c-unid-negoc NO-ERROR.
 
    IF  NOT AVAIL tt-fat-mensal THEN DO:
 
        RUN pi-valida-campo-em-branco (INPUT "Unidade de Neg¢cio", INPUT c-unid-negoc).      
        IF  RETURN-VALUE = "NOK" THEN RETURN "NOK".
        
        /* Valida Classificaá∆o do canal */
        CREATE tt-fat-mensal.          
        ASSIGN tt-fat-mensal.ano           = p-ano
               tt-fat-mensal.mes           = p-mes
               tt-fat-mensal.canal         = tt-central.canal-central
               tt-fat-mensal.unid-neg      = c-unid-negoc
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


PROCEDURE pi-gera-detalhes-movimento:

    DEF INPUT PARAM p-tp-movto AS INTEGER NO-UNDO.

    CREATE tt-fat-mensal-det.
    ASSIGN tt-fat-mensal-det.ano          = p-ano
           tt-fat-mensal-det.mes          = p-mes
           tt-fat-mensal-det.canal        = tt-central.canal-filial /* SEMPRE DA FILIAL */
           tt-fat-mensal-det.unid-neg     = c-unid-negoc
           tt-fat-mensal-det.tp-movto     = p-tp-movto
           
           /* Informaá‰es da Nota Fiscal */  
           tt-fat-mensal-det.cod-estabel  = it-nota-fisc.cod-estabel
           tt-fat-mensal-det.serie        = it-nota-fisc.serie       
           tt-fat-mensal-det.nr-nota-fis  = it-nota-fisc.nr-nota-fis
           tt-fat-mensal-det.nr-seq-fat   = it-nota-fisc.nr-seq-fat 
           tt-fat-mensal-det.it-codigo    = it-nota-fisc.it-codigo
           tt-fat-mensal-det.qt-faturada  = IF p-tp-movto = 1 THEN it-nota-fisc.qt-faturada[1] ELSE 0
           tt-fat-mensal-det.vl-faturado  = IF p-tp-movto = 1 THEN (it-nota-fisc.vl-merc-liq /*+ it-nota-fisc.vl-despes-it*/) ELSE 0.

     /* Informaá‰es da Devoluá∆o (item-doc-est) */           
     IF  AVAIL devol-cli THEN DO:
         ASSIGN  tt-fat-mensal-det.serie-docto  = devol-cli.serie-docto
                 tt-fat-mensal-det.nro-docto    = devol-cli.nro-docto                                                                                                                       
                 tt-fat-mensal-det.cod-emitente = devol-cli.cod-emitente
                 tt-fat-mensal-det.nat-operacao = devol-cli.nat-operacao
                 tt-fat-mensal-det.sequencia    = devol-cli.sequencia
                 tt-fat-mensal-det.qt-devolvida = devol-cli.qt-devolvida
                 tt-fat-mensal-det.vl-devolvido = item-doc-est.preco-total[1].
     END.       
     
     ASSIGN tt-fat-mensal-det.data         = IF  AVAIL devol-cli THEN 
                                                 devol-cli.dt-devol 
                                             ELSE 
                                                IF  p-tp-movto = 1 THEN 
                                                    nota-fiscal.dt-emis-nota
                                                ELSE 
                                                    ?
            tt-fat-mensal-det.canal-central = tt-central.canal-central.
    
    RETURN "OK".
END. 


PROCEDURE pi-vendas:

    FOR EACH tt-central
       , EACH nota-fiscal FIELDS (cod-estabel 
                                  serie 
                                  nr-nota-fis 
                                  cod-emitente 
                                  nat-operacao 
                                  dt-emis-nota) NO-LOCK USE-INDEX ch-emi-nota
             WHERE nota-fiscal.cod-emitente = tt-central.canal-filial
               AND nota-fiscal.dt-emis-nota >= da-ini
               AND nota-fiscal.dt-emis-nota <= da-fim
               AND nota-fiscal.dt-cancel     = ?
               AND nota-fiscal.dt-emis-nota >= tt-central.dt-adesao-central
       , FIRST emitente FIELDS(cod-emitente 
                               nome-matriz) NO-LOCK
              WHERE emitente.cod-emitente = nota-fiscal.cod-emitente
       , FIRST natur-oper FIELDS (emite-duplic
                                  atual-estat) NO-LOCK
             WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
               AND natur-oper.tipo <> 1 
               AND natur-oper.emite-duplic /* s¢ sa°das que geram duplicatas   */
               AND natur-oper.atual-estat  /* s¢ sa°das que geram estat°sticas */
       , EACH it-nota-fisc FIELDS (cod-estabel
                                   serie
                                   nr-nota-fis
                                   cod-unid-negoc 
                                   nr-seq-fat
                                   it-codigo 
                                   vl-merc-liq
                                   qt-faturada[1]
                                   vl-merc-liq) 
            OF nota-fiscal NO-LOCK:

         ASSIGN c-unid-negoc = "".
     
         RUN pi-acompanhar IN h-acomp ("Apurando faturamento canal em : " + STRING(nota-fiscal.dt-emis-nota, "99/99/9999")).

        /* UNIDADE DE NEG‡CIO */
        IF  it-nota-fisc.cod-unid-negoc <> "" THEN
            ASSIGN c-unid-negoc = it-nota-fisc.cod-unid-negoc.
        ELSE
            FOR FIRST item-uni-estab FIELDS (cod-unid-neg) NO-LOCK
                WHERE item-uni-estab.cod-estabel = nota-fiscal.cod-estabel
                  AND item-uni-estab.it-codigo   = it-nota-fisc.it-codigo:
                ASSIGN c-unid-negoc = item-uni-estab.cod-unid-negoc. 
            END.

        FOR FIRST item FIELDS (it-codigo fm-cod-com ) NO-LOCK
           WHERE item.it-codigo = it-nota-fisc.it-codigo: 
        END.
        
        RUN pi-cria-tt-fat-mensal.

        RUN pi-gera-detalhes-movimento (INPUT 1 /*Fat*/).
    
        IF  RETURN-VALUE <> "OK" THEN
            RETURN "NOK".
      
        ASSIGN tt-fat-mensal.vl-faturado = tt-fat-mensal.vl-faturado + (it-nota-fisc.vl-merc-liq /*+ it-nota-fisc.vl-despes-it*/)
               tt-fat-mensal.vl-apurado  = tt-fat-mensal.vl-faturado.
      
    END.

    RETURN "OK".
END.


PROCEDURE pi-devolucoes:

    DEFINE VARIABLE da-data-dev AS DATE  NO-UNDO.
    /* Devolucoes */
    DO da-data-dev = da-ini TO da-fim:

        FOR EACH tt-central
          ,EACH devol-cli USE-INDEX ch-dt-emit NO-LOCK 
               WHERE devol-cli.dt-devol     = da-data-dev
                 AND devol-cli.dt-devol    >= tt-central.dt-adesao-central
                 AND devol-cli.nome-ab-emi  = tt-central.nome-abrev-filial
          
          ,EACH item-doc-est FIELDS (item-doc-est.preco-total[1])
              OF devol-cli NO-LOCK
           
          ,FIRST emitente FIELDS (cod-emitente nome-matriz) NO-LOCK
               WHERE emitente.cod-emitente = devol-cli.cod-emitente:
            
           ASSIGN c-unid-negoc = "".
    
           FOR FIRST it-nota-fisc FIELDS (cod-estabel
                                          serie
                                          nr-nota-fis
                                          cod-unid-negoc
                                          nr-seq-fat    
                                          it-codigo     
                                          vl-merc-liq   
                                          qt-faturada[1]
                                          vl-merc-liq)  NO-LOCK
              WHERE it-nota-fisc.cod-estabel = devol-cli.cod-estabel
                AND it-nota-fisc.serie       = devol-cli.serie
                AND it-nota-fisc.nr-nota-fis = devol-cli.nr-nota-fis
                AND it-nota-fisc.nr-seq-fat  = devol-cli.nr-sequencia
                AND it-nota-fisc.it-codigo   = devol-cli.it-codigo:
           END.

           FOR FIRST nota-fiscal FIELDS (cod-estabel  
                                         serie        
                                         nr-nota-fis  
                                         cod-emitente 
                                         nat-operacao 
                                         dt-emis-nota)
               OF it-nota-fisc NO-LOCK:
           END.
        
           FOR FIRST natur-oper FIELDS(emite-duplic  
                                       atual-estat) NO-LOCK
              WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao:
           END.
        
           /** Ignora notas que n∆o geram faturamento **/
           IF  NOT natur-oper.emite-duplic 
           OR  NOT natur-oper.atual-estat THEN  
               NEXT.
    
           /* UNIDADE DE NEG‡CIO */
           IF  it-nota-fisc.cod-unid-negoc <> "" THEN
               ASSIGN c-unid-negoc = it-nota-fisc.cod-unid-negoc.
           ELSE
               FOR FIRST item-uni-estab FIELDS (cod-unid-neg) NO-LOCK
                   WHERE item-uni-estab.cod-estabel = it-nota-fisc.cod-estabel
                     AND item-uni-estab.it-codigo   = it-nota-fisc.it-codigo:
                   ASSIGN c-unid-negoc = item-uni-estab.cod-unid-negoc. 
               END.

           FOR FIRST item FIELDS (it-codigo fm-cod-com ) NO-LOCK
              WHERE item.it-codigo = it-nota-fisc.it-codigo: 
           END.
      
           RUN pi-cria-tt-fat-mensal.
    
           RUN pi-gera-detalhes-movimento (INPUT 2 /*Dev*/).
        
           IF  RETURN-VALUE <> "OK" THEN
               RETURN "NOK".
           
           IF  NOT AVAIL tt-fat-mensal THEN 
               RETURN "NOK".
    
           ASSIGN tt-fat-mensal.vl-devolvido = tt-fat-mensal.vl-devolvido + item-doc-est.preco-total[1]
                  tt-fat-mensal.vl-apurado   = tt-fat-mensal.vl-apurado - (item-doc-est.preco-total[1]).
    
        END.
    END.

    RETURN "OK".
END.


PROCEDURE pi-retorna-datas:
    DEF INPUT PARAM p-mes AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-ano AS INTEGER NO-UNDO.
    
    /**************** CALCULAR DATA INICIAL E FINAL *****************/
    ASSIGN da-ini = DATE(p-mes,01, p-ano)
           da-fim = IF  p-mes = 12 THEN
                        DATE(12, 31, p-ano) 
                    ELSE
                        DATE(MONTH(da-ini) + 1, 01, YEAR(da-ini)) - 1.

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

