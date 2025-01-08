&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*:T *******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP031RP 2.04.00.003}

/* ***************************  Definitions  ************************** */
&global-define programa ESCPP031RP

def var c-liter-par                  as character format "x(13)":U.
def var c-liter-sel                  as character format "x(10)":U.
def var c-liter-imp                  as character format "x(12)":U.    
def var c-destino                    as character format "x(15)":U.

{esp/cpp/escpp031tt.i}

def temp-table tt-raw-digita
    field raw-digita as raw.
 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
DEFINE VARIABLE dir-op-fin AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dir-op-del AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dir-op-del-erros AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-op-fin   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-op-del   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-ord-prod  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-it-codigo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nr-linha  AS CHARACTER   NO-UNDO.

{cdp/cd0666.i}
{esp/es0018.i}

DEF TEMP-TABLE tt-ord-prod      NO-UNDO LIKE ord-prod USE-INDEX codigo 
    FIELD dt-disponibilidade    AS DATE
    FIELD ind-tipo-movto        AS INTEGER
    FIELD faixa-numeracao       AS INTEGER INIT 1
    FIELD verifica-compras      AS LOGICAL 
    FIELD aloca-reserva         AS LOGICAL INIT ?
    FIELD aloca-lote            AS LOGICAL INIT ?
    FIELD rw-ord-prod           AS ROWID
    FIELD gera-relacionamentos  AS LOGICAL INIT YES
    FIELD gera-reservas         AS LOGICAL INIT YES
    FIELD prog-seg              AS CHAR
    FIELD seg-usuario           AS CHAR
    FIELD ep-codigo-usuario     AS CHAR
    FIELD cod-versao-integracao AS INTEGER FORMAT "999"
    FIELD considera-dias-desl   AS LOGICAL INIT NO.

DEF TEMP-TABLE tt-reapro    NO-UNDO
    FIELD it-codigo         LIKE ord-prod.it-codigo
    FIELD cod-refer         LIKE ord-prod.cod-refer
    FIELD descricao         AS CHAR FORMAT "x(36)"
    FIELD un                LIKE reservas.un
    FIELD quant-orig        LIKE reservas.quant-orig.

ASSIGN dir-op-fin = SESSION:TEMP-DIRECTORY + "op-fin" + STRING(TIME) + ".txt"
       dir-op-del = SESSION:TEMP-DIRECTORY + "op-del" + STRING(TIME) + ".txt"
       dir-op-del-erros = SESSION:TEMP-DIRECTORY + "op-del-erros" + STRING(TIME) + ".txt".

DEFINE STREAM s-op-fin.
DEFINE STREAM s-op-del.
DEFINE STREAM s-op-del-err.

OUTPUT STREAM s-op-fin TO VALUE(dir-op-fin).
OUTPUT STREAM s-op-del TO VALUE(dir-op-del).
OUTPUT STREAM s-op-del-err TO VALUE(dir-op-del-erros).

PUT STREAM s-op-del UNFORMATTED "Ordem Prod.,Item,Linha" SKIP.
PUT STREAM s-op-fin UNFORMATTED "Ordem Prod.,Item,Linha" SKIP.
PUT STREAM s-op-del-err UNFORMATTED "Erro,Ordem Prod.,Item,Linha" SKIP.

DEFINE NEW SHARED VARIABLE h-acomp AS HANDLE NO-UNDO.
def var i-ind as int no-undo.

form
/*form-selecao-ini*/
    skip(1)
    "SELEÄ«O"         
    skip(1)
    /*form-selecao-usuario*/
    tt-param.cod-estabel colon 40 label "Estab" 
    tt-param.item-ini colon 40 label "Item" 
    "<|   |>" at 75 tt-param.item-fim no-label skip
    tt-param.nr-ord-ini colon 40 label "Ordem" 
    "<|   |>" at 75 tt-param.nr-ord-fim no-label skip
    tt-param.data-ini colon 40 label "Data" 
    "<|   |>" at 75 tt-param.data-fim no-label skip
    skip(1)
/*form-selecao-fim*/
/*form-parametro-ini*/
/*form-parametro-fim*/
/*form-impressao-ini*/
    skip(1)
    "IMPRESS«O"
    skip(1)
    c-destino           label "Destino" colon 40 "-"
    tt-param.arquivo    no-label
    tt-param.usuario    label "Usu†rio" colon 40
    skip(1)
/*form-impressao-fim*/
    with stream-io side-labels no-attr-space no-box width 132 frame f-impressao.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

{include/i-rpvar.i}

find mgcad.empresa
    where empresa.ep-codigo = "1"
    no-lock no-error.
find first param-global no-lock no-error.

{utp/ut-liter.i Espec°ficos Intelbras * }
assign c-sistema = return-value.
{utp/ut-liter.i Eliminaá∆o_de_Ordens_de_Produá∆o * }
assign c-titulo-relat = return-value.
assign c-empresa     = param-global.grupo
       c-destino     = {varinc/var00002.i 04 tt-param.destino}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure Template
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 13.75
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{include/i-rpcab.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
find first tt-param no-error.
do on stop undo, leave:
    {include/i-rpout.i}
    view frame f-cabec.
    view frame f-rodape.    
    run utp/ut-acomp.p persistent set h-acomp.  
    
    run pi-inicializar in h-acomp (input "Imprimindo":U). 
    
    run piReport in this-procedure.
    
    if tt-param.imprime-par then do:
        page.
        disp tt-param.cod-estabel 
             tt-param.item-ini 
             tt-param.data-ini 
             tt-param.nr-ord-ini 
             tt-param.item-fim 
             tt-param.data-fim 
             tt-param.nr-ord-fim 
             c-destino           
             tt-param.arquivo    
             tt-param.usuario 
             with frame f-impressao.   
    end.
    
    run pi-finalizar in h-acomp.
    {include/i-rpclo.i}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piEnviaEmail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEnviaEmail Procedure 
PROCEDURE piEnviaEmail :
/*------------------------------------------------------------------------------
  Purpose:    Cria email e chama rotina para envio do mesmo 
  Parameters:  <lista de emails eliminados e lista de emails finalizados>
  Notes:      Carlos Daniel - 18/09/2015
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-op-del AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER c-op-fin AS CHARACTER NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER NO-UNDO FORMAT "X(2000)".
DEFINE VARIABLE h-esapi022  AS HANDLE    NO-UNDO.

ASSIGN c-descricao = "Foi executado o programa ESCPP031 eliminaá∆o de Ordem de Produá∆o. Segue anexo informaá‰es ap¢s a execuá∆o: ~r~n".

/* IF c-op-del <> "" THEN                                                                         */
/*     ASSIGN c-descricao = c-descricao + "Ordem(s) eliminada(s):" + '~r~n' + c-op-del + '~r~n'.  */
/* IF c-op-fin <> "" THEN                                                                         */
/*     ASSIGN c-descricao = c-descricao + "Ordem(s) finalizada(s):" + '~r~n' + c-op-fin + '~r~n'. */

RUN esapi/esapi022.p PERSISTENT SET h-esapi022.

RUN piTrataEmail IN h-esapi022 (INPUT "",
                                INPUT "Eliminaá∆o/Finalizaá∆o Ordem(s) de Produá∆o",
                                INPUT c-descricao,
                                INPUT dir-op-del + "," + dir-op-fin + "," + dir-op-del-erros,
                                INPUT "ESCPP031").

IF VALID-HANDLE(h-esapi022) THEN
    DELETE PROCEDURE h-esapi022.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piReport) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piReport Procedure 
PROCEDURE piReport :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    def var l-apaga as logi no-undo.
    
    DEFINE VARIABLE c-op-del AS LONGCHAR NO-UNDO. /*ordens eliminadas*/
    DEFINE VARIABLE c-op-fin AS LONGCHAR NO-UNDO. /*ordens finalizadas*/

/*     disable triggers for load of reservas.     */
/*     disable triggers for load of ext-ord.      */
/*     disable triggers for load of oper-ord.     */
/*     disable triggers for load of pert-ordem.   */
/*     disable triggers for load of split-operac. */
/*     disable triggers for load of op-sfc.       */
/*     disable triggers for load of ord-prod.     */

    RUN esp/es0018p.p (INPUT "ESCPP031RP",
                       INPUT 1,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).

    /* Eliminando OPÔs Internas - Externas e Internas\Externas n∆o relacionadas a pedidos de compra */
    FOR EACH  ord-prod NO-LOCK
        where ord-prod.cod-estabel  = tt-param.cod-estabel
        and   ord-prod.nr-ord-prod >= tt-param.nr-ord-ini
        and   ord-prod.nr-ord-prod <= tt-param.nr-ord-fim
        and   ord-prod.it-codigo   >= tt-param.item-ini
        and   ord-prod.it-codigo   <= tt-param.item-fim
        and   ord-prod.dt-inicio   >= tt-param.data-ini
        and   ord-prod.dt-inicio   <= tt-param.data-fim:

        run pi-acompanhar in h-acomp (input "Item: " + ord-prod.it-codigo).

        IF  ord-prod.tipo > 5 THEN NEXT.
        /* ord-prod.tipo:
           1 - Interna
           2 - Externa
           3 - Interna/Externa
           4 - Retrabalho
           5 - Conserto
           6 - Manutená∆o
           7 - Ativo Fixo
           8 - Ferramentaria
           9 - Reaproveitamento
        */

        IF ord-prod.estado > 2 THEN NEXT. /* Eliminar OPÔs Nao iniciadas e Liberadas e sem movimento de estoque */
        /* ord-prod.estado:
            1 - N∆o Iniciada
            2 - Liberada
            3 - Alocada
            4 - Separada
            5 - Requisitada
            6 - Iniciada
            7 - Finalizada
            8 - Terminada
        */

        //Atendendo ao chamado C2011-0740
        IF CAN-FIND(FIRST tt-prog-ponto WHERE
                          tt-prog-ponto.conteudo = ord-prod.cod-unid-negoc) 
        THEN NEXT.

        IF   ord-prod.estado = 2 /* OP Liberada - valida se existe movimento de estoque */
        AND (CAN-FIND(FIRST movto-estoq WHERE movto-estoq.nr-ord-prod = ord-prod.nr-ord-prod)
        OR   CAN-FIND(FIRST movto-ggf   WHERE movto-ggf.nr-ord-prod   = ord-prod.nr-ord-prod)) THEN NEXT.
        
        IF  ord-prod.tipo > 1 THEN DO: /* OP Interna n∆o necessita verificar ordens de compra */
            assign l-apaga = yes.
    
            for each ordem-compra no-lock
                 where ordem-compra.ordem-servic = ord-prod.nr-ord-prod :
    
                 run pi-acompanhar in h-acomp (input "Ord.Compra relacionada: " + string(numero-ordem)).
    
                 if ordem-compra.num-pedido <> 0 then assign l-apaga = no.
            end. /* for each ordem-compra */
            if not l-apaga then NEXT.
        END. /* IF  tipo > 1 THEN DO: */

        disp ord-prod.nr-ord-prod
             ord-prod.it-codigo
             ord-prod.nr-linha
             with row 3 centered 12 down frame f-dados stream-io no-box.
             pause 0.

        /*armazena as ordens eliminadas para envio de email*/
        /*ASSIGN c-op-del = c-op-del + (IF c-op-del <> "" THEN "," ELSE "") + STRING(ord-prod.nr-ord-prod).*/
        ASSIGN c-ord-prod = STRING(ord-prod.nr-ord-prod)
               c-it-codigo = ord-prod.it-codigo
               c-nr-linha = string(ord-prod.nr-linha).

        ASSIGN l-op-del = YES.

        FOR EACH tt-ord-prod:
            DELETE tt-ord-prod.
        END.

        CREATE tt-ord-prod.
        ASSIGN tt-ord-prod.cod-versao-integracao = 003
               tt-ord-prod.ind-tipo-movto        = 3
               tt-ord-prod.nr-ord-produ          = ord-prod.nr-ord-produ
               tt-ord-prod.verifica-compras      = NO.
        
        DO TRANSACTION ON ERROR UNDO ON STOP UNDO:
            RUN cpp/cpapi301.p (INPUT-OUTPUT TABLE tt-ord-prod,
                                INPUT-OUTPUT TABLE tt-reapro,
                                INPUT-OUTPUT TABLE tt-erro,
                                YES).
        
            IF CAN-FIND (FIRST tt-erro)  THEN DO:
                FOR EACH tt-erro:
                    PUT STREAM s-op-del-err UNFORMATTED tt-erro.mensagem + "," + c-ord-prod + "," + c-it-codigo + "," c-nr-linha SKIP.
                END.
            END.
            ELSE DO:
                PUT STREAM s-op-del UNFORMATTED c-ord-prod + "," + c-it-codigo + "," c-nr-linha SKIP.
            END.
        END.


/*         for each   reservas exclusive-lock                                                          */
/*             where  reservas.nr-ord-prod = ord-prod.nr-ord-prod:                                     */
/*             delete reservas.                                                                        */
/*         end. /* reservas */                                                                         */
/*         for each   ext-ord of ord-prod exclusive-lock:                                              */
/*             delete ext-ord.                                                                         */
/*         end. /* ext-ord */                                                                          */
/*         for each   oper-ord exclusive-lock where oper-ord.nr-ord-prod = ord-prod.nr-ord-prod:       */
/*             delete oper-ord.                                                                        */
/*         end. /* oper-ord */                                                                         */
/*         for each   pert-ordem of ord-prod exclusive-lock:                                           */
/*             delete pert-ordem.                                                                      */
/*         end. /* pert-ordem */                                                                       */
/*         for each   split-operac of ord-prod exclusive-lock:                                         */
/*             delete split-operac.                                                                    */
/*         end. /* split-operac */                                                                     */
/*         for each   op-sfc exclusive-lock where op-sfc.nr-ord-prod = ord-prod.nr-ord-prod:           */
/*             delete op-sfc.                                                                          */
/*         end. /* op-sfc */                                                                           */
/*         FOR EACH   req-sum WHERE req-sum.nr-req-sum = ord-prod.nr-ord-produ EXCLUSIVE-LOCK:         */
/*             DELETE req-sum.                                                                         */
/*         END. /* req-sum */                                                                          */
/*         FOR EACH   cab-req-sum WHERE cab-req-sum.nr-req-sum = ord-prod.nr-ord-produ EXCLUSIVE-LOCK: */
/*             DELETE cab-req-sum.                                                                     */
/*         END. /* cab-req-sum */                                                                      */
/*                                                                                                     */
/*         delete ord-prod.                                                                            */
    END. /* for each  ord-prod exclusive-lock */
    
    /* Finalizaá∆o das OPÔs */
    FOR EACH ord-prod EXCLUSIVE-LOCK 
       where ord-prod.cod-estabel  = tt-param.cod-estabel
       and   ord-prod.nr-ord-prod >= tt-param.nr-ord-ini
       and   ord-prod.nr-ord-prod <= tt-param.nr-ord-fim
       and   ord-prod.it-codigo   >= tt-param.item-ini
       and   ord-prod.it-codigo   <= tt-param.item-fim
       and   ord-prod.dt-inicio   >= tt-param.data-ini
       and   ord-prod.dt-inicio   <= tt-param.data-fim:

        IF  ord-prod.estado > 1 AND ord-prod.estado < 7 THEN DO:
            IF  ord-prod.tipo <> 1 THEN NEXT.

            //Atendendo ao chamado C2011-0740
            IF CAN-FIND(FIRST tt-prog-ponto WHERE
                              tt-prog-ponto.conteudo = ord-prod.cod-unid-negoc) 
            THEN NEXT.

            /* N∆o finalizar OP-s REQUISITADAS, Internas e de linha de serviáo (Presidio) */
            IF  ord-prod.estado = 5 THEN DO:
                FIND lin-prod NO-LOCK 
                    WHERE lin-prod.cod-estabel = ord-prod.cod-estabel 
                    AND   lin-prod.nr-linha    = ord-prod.nr-linha NO-ERROR.
                IF NOT AVAIL lin-prod OR lin-prod.sum-requis = 2 THEN NEXT.
            END. /* IF ord-prod.estado = 5 */

            RUN pi-acompanhar IN h-acomp (INPUT "Finalizando Ordem: " + string(ord-prod.nr-ord-prod)).

            assign ord-prod.estado = 7.
                   /*c-op-fin        = c-op-fin + (IF c-op-fin <> "" THEN "," ELSE "") +
                                     STRING(ord-prod.nr-ord-prod). /*armazena as ordens finalizadas para envio de email*/*/

            PUT STREAM s-op-fin UNFORMATTED STRING(ord-prod.nr-ord-prod) + "," + ord-prod.it-codigo + "," ord-prod.nr-linha SKIP.
            ASSIGN l-op-fin = YES.

            for each  reservas EXCLUSIVE-LOCK
                where reservas.nr-ord-prod = ord-prod.nr-ord-prod:

                RUN pi-acompanhar IN h-acomp (INPUT "Inativando reservas, Ordem: " + string(reservas.nr-ord-prod) + " Item: " + reservas.it-codigo).
                assign reservas.estado = 2. /* 1 - Ativo 2 - Inativo */
            end. /* for each reservas */
        END. /* IF ord-prod.estado > 1 AND ord-prod.estado < 7 */
    END. /* for each ord-prod exclusive-lock */
    
    OUTPUT STREAM s-op-fin CLOSE.
    OUTPUT STREAM s-op-del CLOSE.
    OUTPUT STREAM s-op-del-err CLOSE.

    /*chama proc para criar e enviar email*/
    IF l-op-del OR l-op-fin THEN
        RUN piEnviaEmail(INPUT c-op-del,
                         INPUT c-op-fin).

    RETURN "OK":U.

    /* FIM Finalizaá∆o OP */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

