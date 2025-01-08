/***********************************************************************
**  Programa..: esp/cep/escep078rp.p
**  Autor.....: Alexandre de Freitas.Campos.Gon‡alves
**  Data......: Janeiro/2015 - Desenvolvimento
**  Descricao.: Movimenta‡Æo de estoque
**  Versao....: 001 20/01/2015
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i escep078rp 1.00.00.00}

/****************************  Definitions  ****************************/
{esp/cep/escep078tt.i}
{include/i-rpvar.i}
{utp/ut-glob.i}
{cep/ceapi001k.i}
{cdp/cd0666.i}

DEFINE FRAME f-movto
    tt-erro.cd-erro                  column-label "Erro"
    tt-erro.mensagem format "x(77)"  column-label "Mensagem"
    with stream-io width 132 down frame f-movto.

DEFINE VARIABLE h-ceapi001k AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita AS RAW.



/****************************  Temp-Tables  ****************************/

/****************************  Frames       ****************************/

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

DEFINE VARIABLE i-seq            AS INTEGER INITIAL 0  NO-UNDO.
DEFINE VARIABLE h-acomp          AS HANDLE             NO-UNDO.
DEFINE VARIABLE saldo-disponivel AS DEC FORMAT ">>>>,>>9.99".
DEFINE VARIABLE l-erro           AS LOGICAL            NO-UNDO.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

ASSIGN c-sistema      = "Especificos Intelbras"
       c-titulo-relat = "Movimenta‡Æo de estoque"
       c-empresa      = IF AVAIL empresa THEN empresa.razao-social ELSE ''
       c-programa     = "ESCEP078"
       c-versao       = "1.00".

DEFINE BUFFER b-saldo-estoq FOR saldo-estoq.

/* ***************************  Main Block  *************************** */

DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i}


    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Realizando movimenta‡Æo":U).

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    VIEW FRAME fPageTop.

    EMPTY TEMP-TABLE tt-erro.
    EMPTY TEMP-TABLE tt-movto.

    FOR EACH saldo-estoq NO-LOCK
        WHERE saldo-estoq.cod-estabel  = tt-param.estabel
          AND saldo-estoq.cod-depos    = tt-param.deposito-ori
          AND saldo-estoq.cod-localiz >= tt-param.localiza-ini
          AND saldo-estoq.cod-localiz <= tt-param.localiza-fim
          AND saldo-estoq.it-codigo   >= tt-param.item-ini
          AND saldo-estoq.it-codigo   <= tt-param.item-fim:

        FIND FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = saldo-estoq.it-codigo NO-ERROR.

        FIND FIRST estab-mat NO-LOCK
             WHERE estab-mat.cod-estabel = saldo-estoq.cod-estabel NO-ERROR.
       
        ASSIGN saldo-disponivel = 0
               saldo-disponivel = saldo-disponivel + 
                                 (saldo-estoq.qtidade-atu -
                                  saldo-estoq.qt-alocada  -
                                  saldo-estoq.qt-aloc-prod).

        RUN pi-acompanhar IN h-acomp (INPUT "Item:" + saldo-estoq.it-codigo + " " + "Saldo: " + string (saldo-disponivel)).
        
        IF saldo-disponivel <= 0 THEN NEXT.

        
        /*Movimento de saida*/
        CREATE tt-movto.
        ASSIGN tt-movto.cod-versao-integracao = 001
               tt-movto.usuario               = c-seg-usuario
               tt-movto.cod-prog-orig         = "ESCEP078"
               tt-movto.cod-estabel           = saldo-estoq.cod-estabel
               tt-movto.cod-depos             = saldo-estoq.cod-depos /* Dep¢sito de saida*/
               tt-movto.it-codigo             = saldo-estoq.it-codigo
               tt-movto.cod-localiz           = saldo-estoq.cod-localiz
               tt-movto.lote                  = saldo-estoq.lote
               tt-movto.cod-refer             = saldo-estoq.cod-refer
               tt-movto.referencia            = saldo-estoq.cod-refer
               tt-movto.tipo-trans            = 2 /* Sa¡da */
               tt-movto.ct-codigo             = estab-mat.cod-cta-transf-unif
               tt-movto.sc-codigo             = estab-mat.cod-ccusto-transf-unif
               tt-movto.dt-trans              = TODAY
               tt-movto.esp-docto             = 33 /* TRA */
               tt-movto.quantidade            = saldo-disponivel
               tt-movto.un                    = ITEM.un
               tt-movto.nro-docto             = "ESCEP078" 
               tt-movto.dt-vali-lote          = saldo-estoq.dt-vali-lote.

        
        /*Movimento de entrada*/       
        CREATE tt-movto.
        ASSIGN tt-movto.cod-versao-integracao = 001
               tt-movto.usuario               = c-seg-usuario
               tt-movto.cod-prog-orig         = "ESCEP078"
               tt-movto.cod-estabel           = saldo-estoq.cod-estabel
               tt-movto.cod-depos             = tt-param.deposito-des /* Dep¢sito de entrada */
               tt-movto.it-codigo             = saldo-estoq.it-codigo
               tt-movto.cod-localiz           = tt-param.localiza-des
               tt-movto.lote                  = saldo-estoq.lote
               tt-movto.cod-refer             = saldo-estoq.cod-refer
               tt-movto.referencia            = saldo-estoq.cod-refer
               tt-movto.tipo-trans            = 1 /* Entrada */
               tt-movto.ct-codigo             = estab-mat.cod-cta-transf-unif
               tt-movto.sc-codigo             = estab-mat.cod-ccusto-transf-unif
               tt-movto.dt-trans              = TODAY
               tt-movto.esp-docto             = 33 /* TRA */
               tt-movto.quantidade            = saldo-disponivel
               tt-movto.un                    = ITEM.un
               tt-movto.nro-docto             = "ESCEP078" 
               tt-movto.dt-vali-lote          = saldo-estoq.dt-vali-lote.

    
    END.
    
    RUN pi-finalizar IN h-acomp.

    RUN cep/ceapi001k.p PERSISTENT SET h-ceapi001k.
    IF VALID-HANDLE (h-ceapi001k) THEN DO:
        
        RUN pi-execute IN h-ceapi001k(INPUT-OUTPUT TABLE tt-movto,
                                      INPUT-OUTPUT TABLE tt-erro,
                                      INPUT        YES).
        
        DELETE PROCEDURE h-ceapi001k.
        ASSIGN h-ceapi001k = ?.
        
    END.

    FIND FIRST tt-erro NO-ERROR.
    IF AVAIL tt-erro AND tt-erro.cd-erro > 0 THEN DO:

        ASSIGN l-erro = YES.

        IF l-erro = YES THEN DO:
            
            PUT "******************************************************************** " SKIP
                "*Foram encontrados erros durante a movimentacao. VERIFICAR ERROS!!!* " SKIP
                "******************************************************************** " SKIP(1)
    
                "Seq Erro    Descricao" SKIP
                "--- ------- ------------------------------------------------------------------------------------------------------" SKIP.
            
            FOR EACH tt-erro
                WHERE tt-erro.cd-erro > 0:
    
                ASSIGN i-seq = i-seq + 1.
    
                PUT i-seq              FORMAT ">>9" " "
                    tt-erro.cd-erro    FORMAT ">>>,>>9" " "
                    tt-erro.mensagem   FORMAT "x(100)" SKIP.
            END.

            PUT SKIP(1).

            {include/i-rpclo.i}
                RETURN "OK".

        END.
    END.

    ASSIGN l-erro = NO.
    IF l-erro = NO THEN DO:

        PUT "**************************************** " SKIP
            "*TRANSFERENCIA REALIZADA COM SUCESSO!!!* " SKIP
            "**************************************** " SKIP.

        {include/i-rpclo.i}
            RETURN "OK".

    END. 

   
END.








