/***********************************************************************
**  Programa..: ESAPI/ESAPI002.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Efetua Transferància Entre Dep¢sitos
**  Vers∆o....: 001 05/11/2004
**                  Desenvolvimento Programa
************************************************************************/
/****************************  Definitions  ****************************/

/****************************  Temp-Tables  ****************************/
{utp/ut-glob.i}         /* Vari†veis Globais  */
{cep/ceapi001k.i}       /* Definicao de temp-table do movto-estoq */
{esapi/esapi002tt.i}    /* Definicao da temp-table de origem */
{cdp/cd0666.i}          /* Definicao da temp-table de erros */
{cdp/cdcfgman.i}        /* Pre-processadores */
{cdp/cd9590.i}
{upc/btb910za-upc.i}
/****************************  Variaveis    ****************************/
DEF VAR i-empresa        LIKE param-global.empresa-prin     NO-UNDO.
/****************************  Frames       ****************************/

DEF INPUT  PARAMETER pTipoTrans      AS INT      NO-UNDO.
    /* case pTipoTrans:
       when 1 - Transferància Entre Dep¢sitos
       when 2 - Transferància Entre Dep¢sitos e Cria Int-Saldo-Estoq
    */
DEF INPUT  PARAM     pRotinaOrig     AS CHAR     NO-UNDO.
DEF INPUT  PARAM TABLE FOR tt-item.
DEF OUTPUT PARAM TABLE FOR tt-erro.

def var h-acomp      as handle no-undo.
DEFINE VARIABLE h-cdapi024 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-ceapi001k AS HANDLE      NO-UNDO.

run utp/ut-acomp.p persistent set h-acomp.  

FOR FIRST param-global NO-LOCK:
END.
/* find first estabelec */
/*      where estabelec.ep-codigo = param-global.empresa-pri no-lock no-error. */
/* if not avail estabelec then return "NOK". */
/*    */

find first tt-item no-error.

{esinc/es0005.i tt-item.cod-estabel}    /* Busca Data Ultimo Faturamento - vDtFatur */

/* IF tt-item.cod-estabel = "102" THEN DO:    /* xunxo para Nova porque a serie 1. n∆o pode estar cadastrada no cadastro de estabelecimento devido em OF a default devera ser a serie "1" */ */
/*     FOR FIRST b-estabelec NO-LOCK                                                                                                                                                         */
/*        WHERE b-estabelec.cod-estabel = tt-item.cod-estabel,                                                                                                                               */
/*        FIRST ser-estab NO-LOCK                                                                                                                                                            */
/*           WHERE ser-estab.cod-estabel = b-estabelec.cod-estabel                                                                                                                           */
/*             AND ser-estab.serie       = "1.":                                                                                                                                             */
/*        ASSIGN vDtFatur = ser-estab.dt-ult-fat.                                                                                                                                            */
/*                                                                                                                                                                                           */
/*     END.                                                                                                                                                                                  */
/* END.                                                                                                                                                                                      */

/* ***************************  Main Block  *************************** */
BLOCO:
DO  TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:
    FOR EACH tt-movto:
        DELETE tt-movto. END.
    /*
    FOR EACH tt-erro:
        DELETE tt-erro.  END.
    */
    FIND FIRST estab-mat NO-LOCK
        WHERE estab-mat.cod-estabel = v_cod_estab_usuar NO-ERROR.

    ASSIGN i-empresa        = param-global.empresa-prin.
           
   IF  pTipoTrans = 1 THEN DO: /* Transferància entre Dep¢sito */
       run pi-inicializar in h-acomp (input "Efetuando Transferància...").
       run pi-desabilita-cancela in h-acomp.
       run piCriaMovtoTransf.
       run piGeraMovto.
       IF CAN-FIND(FIRST tt-erro) THEN 
           UNDO, LEAVE BLOCO.
   END.
   ELSE DO:
       run pi-inicializar in h-acomp (input "Efetuando Transferància...").
       run pi-desabilita-cancela in h-acomp.
       run piCriaMovtoTransf.
       run piGeraMovto.
       IF CAN-FIND(FIRST tt-erro) THEN 
           UNDO, LEAVE BLOCO.
       RUN PiAtualizaTabIntSaldo.
   END.
END.
run pi-finalizar in h-acomp.
RETURN "OK".


/* **********************  Internal Procedures  *********************** */
PROCEDURE piCriaMovtoTransf:
    
    RUN pi-acompanhar IN h-acomp (INPUT "Saida Estoque...").
    FOR EACH  tt-item /* WHEN 2 - Saida */
        WHERE tt-item.TipoTrans = 2:
        FOR FIRST ITEM FIELDS(it-codigo un) NO-LOCK
            WHERE ITEM.it-codigo = tt-item.it-codigo: END.
        RUN PiCriaTTMovto(2,        /* SAIDA */
                          33).      /* TRA */
        ASSIGN tt-movto.cod-depos              = tt-item.cod-depos
               tt-movto.quantidade             = tt-item.quantidade
               tt-movto.serie-docto            = tt-item.serie
               tt-movto.nro-docto              = tt-item.nro-docto
               tt-movto.cod-localiz            = tt-item.cod-localiz
               tt-movto.lote                   = tt-item.lote
               tt-movto.dt-vali-lote           = tt-item.dt-vali-lote
               tt-movto.cod-refer              = tt-item.cod-refer
               tt-movto.descricao-db           = "Efetuada por: " + pRotinaOrig.

        IF  l-unidade-negocio
            AND l-mat-unid-negoc THEN DO:

            run cdp/cdapi024.p persistent set h-cdapi024.

            if  valid-handle(h-cdapi024) then do:
                run retornaUnidadeNegocio IN h-cdapi024 (input tt-movto.cod-estabel,
                                                         input tt-movto.it-codigo,
                                                         input tt-movto.cod-depos,
                                                         output tt-movto.cod-unid-negoc).
    
                delete procedure h-cdapi024.
                assign h-cdapi024 = ?.
            end.
    
        end.


    END.

    RUN pi-acompanhar IN h-acomp (INPUT "Entrada Estoque...").
    FOR EACH  tt-item /* WHEN 1 - Entrada */
        WHERE tt-item.TipoTrans = 1:
        FOR FIRST ITEM FIELDS(it-codigo un) NO-LOCK
            WHERE ITEM.it-codigo = tt-item.it-codigo: END.
    
        RUN PiCriaTTMovto(1,        /* ENTRADA */
                          33).      /* TRA */
        ASSIGN tt-movto.cod-depos              = tt-item.cod-depos
               tt-movto.quantidade             = tt-item.quantidade
               tt-movto.serie-docto            = tt-item.serie
               tt-movto.nro-docto              = tt-item.nro-docto
               tt-movto.cod-localiz            = tt-item.cod-localiz
               tt-movto.lote                   = tt-item.lote
               tt-movto.dt-vali-lote           = tt-item.dt-vali-lote
               tt-movto.cod-refer              = tt-item.cod-refer
               tt-movto.descricao-db           = "Efetuada por: " + pRotinaOrig.

        IF  l-unidade-negocio
            AND l-mat-unid-negoc THEN DO:

            run cdp/cdapi024.p persistent set h-cdapi024.

            if  valid-handle(h-cdapi024) then do:
                run retornaUnidadeNegocio IN h-cdapi024 (input tt-movto.cod-estabel,
                                                         input tt-movto.it-codigo,
                                                         input tt-movto.cod-depos,
                                                         output tt-movto.cod-unid-negoc).
    
                delete procedure h-cdapi024.
                assign h-cdapi024 = ?.
            end.
    
        end.

    END.

END PROCEDURE.

PROCEDURE piGeraMovto:
    RUN pi-acompanhar IN h-acomp (INPUT "Atualizando Estoque...").

    run cep/ceapi001k.p PERSISTENT SET h-ceapi001k.

    IF VALID-HANDLE(h-ceapi001k) THEN DO:

        RUN pi-execute IN h-ceapi001k (input-output table tt-movto,
                                       input-output table tt-erro,
                                       input yes).
        DELETE PROCEDURE h-ceapi001k.
        ASSIGN h-ceapi001k = ?.

    END.

    /*
    FIND FIRST tt-erro NO-LOCK NO-ERROR.
    IF  AVAIL tt-erro THEN DO:
        ASSIGN pReturn = "NOK".
        RUN cdp/cd0666.w (INPUT TABLE tt-erro).
    END.*/
END PROCEDURE.

PROCEDURE PiCriaTTMovto:
    DEF INPUT PARAM pTipoTrans AS INT.
    DEF INPUT PARAM pTipoEsp   AS INT.

    CREATE tt-movto.
    ASSIGN tt-movto.cod-versao-integracao  = 1
           tt-movto.cod-prog-orig          = pRotinaOrig
           tt-movto.tipo-trans             = pTipoTrans
           tt-movto.esp-docto              = pTipoEsp
           tt-movto.dt-trans               = vDtFatur
           tt-movto.ct-codigo              = estab-mat.cod-cta-transf-unif
           tt-movto.sc-codigo              = estab-mat.cod-ccusto-transf-unif
           tt-movto.it-codigo              = tt-item.it-codigo
           tt-movto.un                     = item.un WHEN AVAIL ITEM
           tt-movto.usuario                = c-seg-usuario
           tt-movto.cod-estabel            = tt-item.cod-estabel.
END PROCEDURE.

PROCEDURE PiAtualizaTabIntSaldo:
    FOR EACH  tt-item 
        WHERE tt-item.TipoTrans = 2:
        FOR FIRST saldo-estoq NO-LOCK
            {dbini/es322.i1 saldo-estoq tt-item}:
            FOR FIRST int-saldo-estoq EXCLUSIVE-LOCK
                {dbini/es322.i1 int-saldo-estoq saldo-estoq}:
            END.
            IF  NOT AVAIL int-saldo-estoq THEN 
            DO:
                CREATE int-saldo-estoq.
                ASSIGN int-saldo-estoq.cod-estabel         = saldo-estoq.cod-estabel        
                       int-saldo-estoq.cod-depos           = saldo-estoq.cod-depos          
                       int-saldo-estoq.lote                = saldo-estoq.lote               
                       int-saldo-estoq.it-codigo           = saldo-estoq.it-codigo          
                       int-saldo-estoq.cod-refer           = saldo-estoq.cod-refer          
                       int-saldo-estoq.cod-localiz         = saldo-estoq.cod-localiz.
            END.
            ASSIGN int-saldo-estoq.log-baixado = NO.
        END.
    END.
END.
