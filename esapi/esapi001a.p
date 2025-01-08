{include/i-prgvrs.i ESAPI001a 2.04.00.001}
/***********************************************************************
**  Programa..: ESP\ESAPI001a.P
**  Autor.....: Medeiros - Gestech 
**  Data......: MAIO/2005 - Desenvolvimento
**  Descricao.: Reporte Produá∆o - Ch∆o de F†brica
**  Vers∆o....: 001 - 31/05/2005
**                    Desenvolvimento Programa
************************************************************************/
{utp/ut-glob.i}
{cdp/cdcfgman.i} /* Pre-processadores */ 
{sfc/sfapi009.i}
{cpp/cpapi001.i}  /*** tt-rep-prod tt-refugo tt-res-neg tt-apont-mob ***/
{cpp/cpapi001.i1} /*** tt-reservas tt-aloca ***/
{esapi/esapi006tt.i} /*** tt-estrutura ***/
{cdp/cd0666.i} /* tt-erros */
{esapi/esapi001tt.i} /*** tt-rep-prod ***/
{sfc/sf0303a.i}  /*** tt-reporte ***/
{sfc/sf0303a.i1} /*** tt-ref, tt-ic, tt-res-tab   ***/

DEFINE VARIABLE h-cpapi001        AS HANDLE     NO-UNDO.
DEFINE VARIABLE l-problema        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE r-ult-oper        AS ROWID      NO-UNDO.
DEFINE VARIABLE i-mensagem        AS INTEGER    NO-UNDO.
DEFINE VARIABLE lReportado        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE dat-inic-reporte  AS DATE       NO-UNDO.
DEFINE VARIABLE dat-fim-reporte   AS DATE       NO-UNDO.
DEFINE VARIABLE c-hra-inic-rep    AS CHARACTER  NO-UNDO FORMAT '99:99:99'.
DEFINE VARIABLE c-hra-fim-rep     AS CHARACTER  NO-UNDO FORMAT '99:99:99'.
DEFINE VARIABLE i-hra-inic-rep    AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-hra-fim-rep     AS INTEGER    NO-UNDO.
DEFINE VARIABLE h-boin536         AS HANDLE     NO-UNDO.
DEFINE VARIABLE i-num-seq-rep     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cTipoReporte      AS CHAR       NO-UNDO. /*Seletivo/Normal*/
DEFINE VARIABLE vLogErro          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE i-nr-itens        AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-serie           AS CHARACTER  NO-UNDO FORMAT "x(3)". 
DEFINE VARIABLE l-procura-saldo   AS LOGICAL    NO-UNDO.

DEFINE VARIABLE cEtiqueta         LIKE ttRepApi.cEtiqueta NO-UNDO.

def var a               as   char format "x(3)".
def var b               as   char format "x(3)".
def var p1              as   int.
def var p2              as   int.
def var p3              as   int.
def var px1             as   int  initial 1 .
def var px2             as   int  initial 1.
def var px3             as   int  initial 1.
def var letra           as   char format "x(3)" extent 62.
def var i               as   int.
def var i-cont          as   int.
def var x-cont          as   int.

DEFINE VARIABLE v_tot_quantidade AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-cod-depos      AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-rep-oper-ctrab  NO-UNDO LIKE rep-oper-ctrab
    FIELD cod-ferr-prod                   LIKE split-operac.cod-ferr-prod
    FIELD dat-fim-setup                   LIKE split-operac.dat-fim-setup
    FIELD dat-inic-setup                  LIKE split-operac.dat-inic-setup
    FIELD qtd-segs-fim-setup              LIKE split-operac.qtd-segs-fim-setup
    FIELD qtd-segs-inic-setup             LIKE split-operac.qtd-segs-inic-setup.

DEFINE TEMP-TABLE  tt-log
    FIELD tipo     AS CHAR 
    FIELD seletivo AS CHAR FORMAT "x(8)"
    FIELD hora-ini AS CHAR 
    FIELD h-ini    AS INT 
    FIELD etiqueta AS CHAR
    FIELD nr-itens AS INT 
    FIELD t1       AS INT  
    FIELD t2       AS INT 
    FIELD t3       AS INT 
    FIELD erro     AS CHAR FORMAT "x(100)".

DEFINE TEMP-TABLE tt-erro-bo NO-UNDO
    FIELD descricao     AS CHAR format "x(132)".

DEFINE TEMP-TABLE ttreservas NO-UNDO LIKE reservas
       FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-rep-refugo-oper NO-UNDO LIKE rep-refugo-oper.
DEFINE TEMP-TABLE tt-rep-ic-oper     NO-UNDO LIKE rep-ic-oper.
DEFINE TEMP-TABLE tt-rep-ic-oper-tab NO-UNDO LIKE rep-ic-oper-tab.

DEFINE BUFFER b-item  FOR ITEM.
DEFINE BUFFER bt-item FOR ITEM.

PROCEDURE piInicializaReporte: /* Em uso */
    DEFINE INPUT PARAM TABLE FOR ttRepApi.
    DEFINE INPUT PARAM pTipoReporte AS CHAR NO-UNDO. /*Seletivo/Normal*/

    ASSIGN cTipoReporte = pTipoReporte.           

    FOR FIRST ttRepApi:
        ASSIGN cEtiqueta = ttRepApi.cEtiqueta.
    END.

    RUN cpp/cpapi001.p PERSISTENT SET h-cpapi001 (input-output table tt-rep-prod,
                                                  input        table tt-refugo,
                                                  input        table tt-res-neg,
                                                  input        table tt-apont-mob,
                                                  input-output table tt-erro,
                                                  input YES).
END PROCEDURE.

/* N∆o esta sendo utilizado 
PROCEDURE piReportaChaoFabrica:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM rOrdProd AS ROWID.
    
    FIND FIRST ord-prod WHERE ROWID(ord-prod) = rOrdProd NO-LOCK NO-ERROR.
    IF NOT AVAIL ord-prod THEN DO:
        RUN piCriaErro(INPUT "Houve algum problema com a ordem. Favor comunicar o Administrador do Sistema").
        RETURN "NOK".
    END.
    
    run cpp/cp9000.p (input  rowid(ord-prod),
                      input  no,
                      output l-problema,
                      output r-ult-oper,
                      output i-mensagem).

    FOR FIRST pert-ordem NO-LOCK
        WHERE pert-ordem.nr-ord-produ = ord-prod.nr-ord-produ:
    END.

    IF AVAIL pert-ordem THEN
    DO:
        FOR EACH  pert-ordem NO-LOCK
            WHERE pert-ordem.nr-ord-produ = ord-prod.nr-ord-produ
            BREAK BY pert-ordem.nr-ord-produ:
            /* IF c-seg-usuario = "super" THEN
                MESSAGE pert-ordem.op-codigo SKIP
                        FIRST-OF(pert-ordem.nr-ord-produ)
                    VIEW-AS ALERT-BOX INFO BUTTONS OK. */
            
            IF FIRST-OF(pert-ordem.nr-ord-produ) THEN
            DO:
                FOR FIRST oper-ord NO-LOCK
                    WHERE oper-ord.num-operac-sfc = pert-ordem.num-operac-predec
                    AND   oper-ord.nr-ord-produ   = pert-ordem.nr-ord-produ,
                    FIRST split-operac NO-LOCK
                    WHERE split-operac.nr-ord-produ      = pert-ordem.nr-ord-produ
                    AND   split-operac.num-operac-sfc    = oper-ord.num-operac-sfc
                    /*
                    AND   split-operac.ind-estado-split >= 3 
                    AND   split-operac.ind-estado-split <= 4*/
                    :

                    IF split-operac.ind-estado-split <= 2 THEN
                    DO:
                        RUN piCriaErro(INPUT "Ordem.: " + STRING(ord-prod.nr-ord-produ) + " n∆o foi liberada pelo PCP. Verificar com Planejamento").
                    END.
                    ELSE IF split-operac.ind-estado-split >= 3 AND
                            split-operac.ind-estado-split <= 4 THEN DO:
                        FOR FIRST ctrab NO-LOCK
                            WHERE ctrab.cod-ctrab = split-operac.cod-ctrab:
                        END.
                        IF NOT AVAIL ctrab THEN
                        DO:
                            RUN piCriaErro(INPUT "N∆o Encontrado Centro de Tralhalho para a Operaá∆o.: " + string(oper-ord.op-codigo)).
                        END.
                        ELSE DO:
                            RUN piReportaChaoEfetivo.
                            IF RETURN-VALUE = "NOK" THEN RETURN "NOK".
                        END.
                    END.
                    ELSE DO:
                        RUN piCriaErro(INPUT "Ordem.: " + STRING(ord-prod.nr-ord-produ)+ " com Status de Finalizado/Suspenso. Verificar com Planejamento").
                    END.
                    /* IF c-seg-usuario = "super" THEN
                    MESSAGE 'Reportando pela Rede Pert da Ordem'                     SKIP
                            'oper-ord.op-codigo      ' oper-ord.op-codigo SKIP
                            'pert-ordem.op-codigo    ' pert-ordem.op-codigo SKIP
                            'oper-ord.num-operac-sfc ' oper-ord.num-operac-sfc SKIP
                            rowid(oper-ord) = r-ult-oper
                            VIEW-AS ALERT-BOX INFO BUTTONS OK. */
                END.
            END.
            IF NOT CAN-FIND(FIRST tt-erro) THEN
            DO:
                FOR FIRST oper-ord OF pert-ordem NO-LOCK,
                    FIRST split-operac NO-LOCK
                    WHERE split-operac.nr-ord-produ      = pert-ordem.nr-ord-produ
                    AND   split-operac.num-operac-sfc    = oper-ord.num-operac-sfc
                    /*
                    AND   split-operac.ind-estado-split >= 3 
                    AND   split-operac.ind-estado-split <= 4*/
                    :
                    IF split-operac.ind-estado-split <= 2 THEN
                    DO:
                        RUN piCriaErro(INPUT "Ordem.: " + STRING(ord-prod.nr-ord-produ) + " n∆o foi liberada pelo PCP. Verificar com Planejamento").
                    END.
                    ELSE IF split-operac.ind-estado-split >= 3 AND
                            split-operac.ind-estado-split <= 4 THEN DO:
                        FOR FIRST ctrab NO-LOCK
                            WHERE ctrab.cod-ctrab = split-operac.cod-ctrab:
                        END.
                        IF NOT AVAIL ctrab THEN
                        DO:
                            RUN piCriaErro(INPUT "N∆o Encontrado Centro de Tralhalho para a Operaá∆o.: " + string(oper-ord.op-codigo)).
                        END.
                        ELSE DO:  
                            RUN piReportaChaoEfetivo.
                            IF RETURN-VALUE = "NOK" THEN RETURN "NOK".

                        END.
                    END.
                    ELSE DO:
                        RUN piCriaErro(INPUT "Ordem.: " + STRING(ord-prod.nr-ord-produ)+ " com Status de Finalizado/Suspenso. Verificar com Planejamento").
                    END.
    
                    /* IF c-seg-usuario = "super" THEN
                    MESSAGE 'Reportando pela Rede Pert da Ordem'                     SKIP
                            'oper-ord.op-codigo      ' oper-ord.op-codigo SKIP
                            'pert-ordem.op-codigo    ' pert-ordem.op-codigo SKIP
                            'oper-ord.num-operac-sfc ' oper-ord.num-operac-sfc SKIP
                            rowid(oper-ord) = r-ult-oper
                            VIEW-AS ALERT-BOX INFO BUTTONS OK. */
                END.
            END.
        END.
    END.
    ELSE IF NOT AVAIL pert-ordem THEN
    DO:
        FOR EACH  split-operac NO-LOCK
            WHERE split-operac.nr-ord-produ     = ord-prod.nr-ord-produ,
            FIRST oper-ord OF split-operac NO-LOCK:
            /* IF c-seg-usuario = "super" THEN
            MESSAGE 'Reportando pelo Split da Ordem' SKIP
                    'op-codigo     ' oper-ord.op-codigo          SKIP
                    'num-operac-sfc' oper-ord.num-operac-sfc     SKIP
                    rowid(oper-ord) = r-ult-oper
                    VIEW-AS ALERT-BOX INFO BUTTONS OK. */
            IF split-operac.ind-estado-split <= 2 THEN
            DO:
                RUN piCriaErro(INPUT "Ordem.: " + STRING(ord-prod.nr-ord-produ) + " n∆o foi liberada pelo PCP. Verificar com Planejamento").
            END.
            ELSE IF split-operac.ind-estado-split >= 3 AND
                    split-operac.ind-estado-split <= 4 THEN DO:
                FOR FIRST ctrab NO-LOCK
                    WHERE ctrab.cod-ctrab = split-operac.cod-ctrab:
                END.
                IF NOT AVAIL ctrab THEN
                DO:
                    RUN piCriaErro(INPUT "N∆o Encontrado Centro de Tralhalho para a Operaá∆o.: " + string(oper-ord.op-codigo)).
                END.
                ELSE DO: 
                    RUN piReportaChaoEfetivo.
                    IF RETURN-VALUE = "NOK" THEN RETURN "NOK".
                END.
            END.
            ELSE DO:
                RUN piCriaErro(INPUT "Ordem.: " + STRING(ord-prod.nr-ord-produ)+ " com Status de Finalizado/Suspenso. Verificar com Planejamento").
            END.
        END.
    END.
    
END PROCEDURE.

PROCEDURE piReportaChaoEfetivo:

    ASSIGN lReportado = YES.

    FOR FIRST ctrab NO-LOCK
        WHERE ctrab.cod-ctrab = split-operac.cod-ctrab,
        FIRST grup-maquina OF oper-ord NO-LOCK:
    END.
    /*
    FOR FIRST oper-ord NO-LOCK
        WHERE oper-ord.nr-ord-produ   = split-operac.nr-ord-produ 
        AND   oper-ord.num-operac-sfc = split-operac.num-operac-sfc,
        FIRST ctrab NO-LOCK
        WHERE ctrab.cod-ctrab = split-operac.cod-ctrab:
        FOR FIRST grup-maquina OF oper-ord:
        END.
    END.
    */
    /* MESSAGE "vai rodar o esapi004" VIEW-AS ALERT-BOX. */
    RUN esapi/esapi004.p (INPUT  ord-prod.nr-ord-produ,
                          INPUT  split-operac.op-codigo,
                          INPUT  ttRepApi.qt-Reporte,
                          OUTPUT dat-inic-reporte,
                          OUTPUT dat-fim-reporte,
                          OUTPUT c-hra-inic-rep,
                          OUTPUT c-hra-fim-rep,
                          OUTPUT i-hra-inic-rep,
                          OUTPUT i-hra-fim-rep,
                          OUTPUT TABLE tt-erro).
    IF NOT CAN-FIND(FIRST tt-erro) THEN
    DO:
        RUN piCriaTTReporte.
        /*
        find oper-ord where rowid(oper-ord) = v-rw-oper-ord no-lock no-error.
        */
        find first tt-reporte no-error.
        
        run inbo/boin536.p persistent set h-boin536.

        /*** Atualizaá∆o das tabelas do Ch∆o de F†brica ***/
        find last rep-oper-ctrab use-index id where 
                  rep-oper-ctrab.nr-ord-produ = split-operac.nr-ord-produ no-lock  no-error.
        if  avail rep-oper-ctrab THEN assign i-num-seq-rep = rep-oper-ctrab.num-seq-rep + 1.
        else assign i-num-seq-rep = 1.
        FOR EACH tt-rep-oper-ctrab.  DELETE tt-rep-oper-ctrab.  END.
        FOR EACH tt-rep-refugo-oper. DELETE tt-rep-refugo-oper. END.
        FOR EACH tt-rep-ic-oper.     DELETE tt-rep-ic-oper.     END.
        FOR EACH tt-rep-ic-oper-tab. DELETE tt-rep-ic-oper-tab. END.
        create tt-rep-oper-ctrab.
        buffer-copy tt-reporte to tt-rep-oper-ctrab
        assign tt-rep-oper-ctrab.nr-ord-produ   = split-operac.nr-ord-produ
               tt-rep-oper-ctrab.num-seq-rep    = i-num-seq-rep
               tt-rep-oper-ctrab.num-operac-sfc = split-operac.num-operac-sfc
               tt-rep-oper-ctrab.num-split-oper = split-operac.num-split-oper
               tt-rep-oper-ctrab.cod-ctrab      = ctrab.cod-ctrab.

        for each tt-ref:
            create tt-rep-refugo-oper.
            buffer-copy tt-ref to tt-rep-refugo-oper
            assign tt-rep-refugo-oper.nr-ord-produ = tt-rep-oper-ctrab.nr-ord-produ
                   tt-rep-refugo-oper.num-seq-rep  = tt-rep-oper-ctrab.num-seq-rep.
        end.
        /* MESSAGE "vai GerarRepOperCTrab" VIEW-AS ALERT-BOX. */
        run GerarRepOperCtrab in h-boin536 (input table tt-rep-oper-ctrab,
                                            input table tt-rep-refugo-oper,
                                            input table tt-rep-ic-oper,
                                            input table tt-rep-ic-oper-tab).
        IF RETURN-VALUE = "NOK" THEN 
           RUN piCriaErro(INPUT "N∆o foi poss°vel reportar ch∆o de f†brica.").
        /*** se a quantidade produzida da operacao for maior ou igual a quantidade prevista da operacao
            entao finaliza o split  ***/
        if  RETURN-VALUE <> "nok" THEN 
        DO:
            IF rowid(oper-ord) = r-ult-oper /*oper-ord.log-operac-final = YES */ THEN DO:
                /* MESSAGE "ultima operacao. vai rodar piReportaProducao" VIEW-AS ALERT-BOX. */
                RUN piReportaProducao(INPUT ord-prod.cod-estabel,
                                      INPUT 2,
                                      INPUT ROWID(ord-prod)). /* SFC */
            END.
            IF oper-ord.qt-produzida >= oper-ord.qtd-previs-operac THEN
               RUN FecharOperacao in h-boin536 (buffer oper-ord).
            /*
            IF RETURN-VALUE = "NOK" THEN DO:
               RUN getRowErrors IN h-boin536 (OUTPUT TABLE RowErrors).
               RUN .
            END.
            */
        END.
        
        DELETE PROCEDURE h-boin536.

/*          if  oper-ord.log-operac-final = YES THEN
            RUN piReportaOperacao.*/

        IF CAN-FIND(FIRST tt-erro) THEN
        DO:
            /*RUN cdp\cd0666.w(INPUT TABLE tt-erro).*/
             RETURN "NOK".
        END.
    END. /* IF NOT CAN-FIND(FIRST tt-erro) THEN */ 
    ELSE DO:
        IF c-seg-usuario = "super" THEN
        DO:
            FOR EACH tt-erro:
                MESSAGE "Erro Retorno do ESAPI004" SKIP
                    tt-erro.cd-erro " - "
                    tt-erro.mensagem
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
        END.
    END.
END PROCEDURE.
*/
PROCEDURE piChecaEstrutura : /* Em uso */
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       PROCEDURE checa-estrutura :
------------------------------------------------------------------------------*/
    for each tt-res-neg:
        find first reservas 
             where reservas.nr-ord-prod = tt-res-neg.nr-ord-prod
               and reservas.it-codigo   = tt-res-neg.it-codigo
                   no-lock no-error.
        if  not avail reservas then do:
            find b-item where b-item.it-codigo = tt-res-neg.it-codigo  no-lock.
            RUN piAtualizaReservas.
            IF CAN-FIND(FIRST tt-erro) THEN LEAVE.
        end.
    end.
END PROCEDURE.

PROCEDURE piAtualizaReservas. /* Em uso */
    DEFINE VARIABLE lErro AS LOGICAL    NO-UNDO.

    FOR EACH tt-erro-bo: DELETE tt-erro-bo. END.
    FOR EACH ttreservas. DELETE ttreservas. END.
    CREATE ttreservas.
    ASSIGN ttreservas.nr-ord-prod = tt-res-neg.nr-ord-prod
           ttreservas.it-codigo   = tt-res-neg.it-codigo
           ttreservas.item-pai    = ord-prod.it-codigo
           ttreservas.quant-orig  = tt-res-neg.quantidade
           ttreservas.un          = b-item.un
           ttreservas.tp-atualiza = 01
           ttreservas.cod-localiz = tt-res-neg.cod-localiz
           ttreservas.cod-depos   = tt-res-neg.cod-depos
           ttreservas.estado      = 1

           ttreservas.nr-ord-refer  = ord-prod.nr-ord-refer
           ttreservas.nr-req-sum    = ord-prod.nr-req-sum   
           ttreservas.origem        = 2
           ttreservas.quant-requis  = tt-res-neg.quantidade
           ttreservas.dt-reserva    = TODAY
           ttreservas.emite-requis  = YES.

    RUN esbo/esboin390.p (INPUT        "ADD",
                          INPUT        TABLE ttreservas,
                          INPUT-OUTPUT TABLE tt-erro-bo,
                          OUTPUT       lErro).

    FOR EACH tt-erro-bo:
        RUN piCriaErro (INPUT tt-erro-bo.descricao).
    END.

END PROCEDURE.

PROCEDURE piAjustaTTResNeg: /* Em uso */
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       procedure ajusta-res-neg.
------------------------------------------------------------------------------*/

    
    DEFINE OUTPUT PARAM pLogErro    AS LOG.
    
    def var nr-saida        as integer  no-undo.
    def var nr-entrada      as integer  no-undo.

    assign pLogErro = no.

    for each reporte-seletivo no-lock
       where reporte-seletivo.it-codigo = ord-prod.it-codigo
         and reporte-seletivo.data-inicial >= today
         and reporte-seletivo.data-final   <= today:
         
         if reporte-seletivo.qtd-unitaria * ttRepApi.qt-reporte > reporte-seletivo.quant-saldo then do:
            RUN piCriaErro(INPUT "Reporte Excede Saldo Seletivo. Execucao Cancelada.").
            assign pLogErro = yes.            
        end.
     end.

     if not pLogErro
     then do:
         for each reporte-seletivo no-lock
            where reporte-seletivo.it-codigo     = ord-prod.it-codigo
              and reporte-seletivo.data-inicial <= today
              and reporte-seletivo.data-final   >= today
              and reporte-seletivo.tipo          = NO /* saida */
              and reporte-seletivo.situacao      = no:

             assign nr-saida = nr-saida + 1.
         end.

         for each reporte-seletivo no-lock
            where reporte-seletivo.it-codigo     = ord-prod.it-codigo
              and reporte-seletivo.data-inicial <= today
              and reporte-seletivo.data-final   >= today
              and reporte-seletivo.tipo          = yes
              and reporte-seletivo.situacao      = no:

             assign nr-entrada = nr-entrada + 1.
         end.

         
         if nr-saida > nr-entrada
         then do:
             RUN piCriaErro(INPUT "N£mero de sa°das maior que n£mero de entradas no Seletivo.").
             assign pLogErro = yes.             
         end.
         if nr-entrada > nr-saida
         then do:
             RUN piCriaErro(INPUT "N£mero de entradas maior que n£mero de sa°das no Seletivo.").
             assign pLogErro = yes.             
         end.
     end.


     IF NOT pLogErro THEN
     DO:
         
         for each reporte-seletivo EXCLUSIVE-LOCK
            where reporte-seletivo.it-codigo     = ord-prod.it-codigo
              and reporte-seletivo.data-inicial <= today
              and reporte-seletivo.data-final   >= today
              and reporte-seletivo.tipo          = NO /* saida */
              and reporte-seletivo.situacao      = no:
             
             /* IF c-seg-usuario = "super" THEN
                 MESSAGE  "SAIDA "
                    "item " reporte-seletivo.it-codigo   SKIP
                    "Compon " reporte-seletivo.es-codigo    SKIP
                    "data ini " reporte-seletivo.data-inicial SKIP
                    "data fim " reporte-seletivo.data-final  
 
                     VIEW-AS ALERT-BOX INFO BUTTONS OK. */
                     
             find first tt-res-neg
                  where tt-res-neg.it-codigo = reporte-seletivo.es-codigo no-error.
             if  avail  tt-res-neg then do:
                 /* IF  c-seg-usuario = "super" THEN
                     MESSAGE tt-res-neg.quantidade SKIP
                             tt-res-neg.quantidade - reporte-seletivo.qtd-unitaria * ttRepApi.qt-reporte SKIP
                             'unit' reporte-seletivo.qtd-unitaria " * " 'report ' ttRepApi.qt-reporte
                             VIEW-AS ALERT-BOX INFO BUTTONS OK. */
                 assign tt-res-neg.quantidade        = tt-res-neg.quantidade - reporte-seletivo.qtd-unitaria * ttRepApi.qt-reporte
                        reporte-seletivo.quant-atend = reporte-seletivo.quant-atend + reporte-seletivo.qtd-unitaria * ttRepApi.qt-reporte
                        reporte-seletivo.quant-saldo = reporte-seletivo.quant-saldo - reporte-seletivo.qtd-unitaria * ttRepApi.qt-reporte.
                 /* IF  c-seg-usuario = "super" THEN
                     MESSAGE tt-res-neg.quantidade SKIP
                             tt-res-neg.quantidade - reporte-seletivo.qtd-unitaria * ttRepApi.qt-reporte SKIP
                             'unit' reporte-seletivo.qtd-unitaria " * " 'report ' ttRepApi.qt-reporte
                             VIEW-AS ALERT-BOX INFO BUTTONS OK. */

                 if  reporte-seletivo.quant-saldo = 0 then 
                     assign reporte-seletivo.situacao = yes.
                 /* IF c-seg-usuario = "super" THEN
                 MESSAGE ' quantidade ' tt-res-neg.quantidade skip
                      tt-res-neg.quantidade <= 0
                     VIEW-AS ALERT-BOX INFO BUTTONS OK. */
                 if  tt-res-neg.quantidade <= 0 then 
                     delete tt-res-neg.
             end.
         end.

         for each reporte-seletivo EXCLUSIVE-LOCK
            where reporte-seletivo.it-codigo = ord-prod.it-codigo
              and reporte-seletivo.data-inicial <= today
              and reporte-seletivo.data-final   >= today
              and reporte-seletivo.tipo = yes
              and reporte-seletivo.situacao = no:
              find bt-item where bt-item.it-codigo = ord-prod.it-codigo no-lock.

              create tt-res-neg.
              assign tt-res-neg.nr-ord-produ  = ord-prod.nr-ord-prod
                     tt-res-neg.it-codigo     = reporte-seletivo.es-codigo 
                     tt-res-neg.quantidade    = reporte-seletivo.qtd-unitaria * ttRepApi.qt-reporte
                     tt-res-neg.cod-depos     = if ttRepApi.depos-sai = "tam" then "inj" else ttRepApi.depos-sai
                     tt-res-neg.cod-localiz   = ""
                     tt-res-neg.lote-serie    = ""
                     tt-res-neg.cod-refer     = ""
                     tt-res-neg.dt-vali-lote  = ?
                     tt-res-neg.positivo      = yes
                     tt-res-neg.nro-ord-seq   = 1.

              /* tratamento Matriz para itens consumidos por mais produtos, exemplo: filme do schrink */

              IF ord-prod.cod-estabel = "101" THEN DO:
                  if reporte-seletivo.es-codigo = "1155903"  or
                     reporte-seletivo.es-codigo = "1156080"  or
                     reporte-seletivo.es-codigo = "1165933"  or
                     reporte-seletivo.es-codigo = "3991466" then
                      assign tt-res-neg.cod-depos = "aca"
                             tt-res-neg.cod-localiz = "".
    
                   if (reporte-seletivo.es-codigo = "1165933" or
                       reporte-seletivo.es-codigo = "3991466") and 
                       ord-prod.nr-linha = 2 then
                       assign tt-res-neg.cod-depos = "cnt"
                              tt-res-neg.cod-localiz = "".
              END.


              /* ** Inicio localizaá∆o de saldo por lote ***/
              ASSIGN v_tot_quantidade = tt-res-neg.quantidade
                     c-cod-depos      = tt-res-neg.cod-depos.

              blk_saldo:
              FOR EACH saldo-estoq NO-LOCK
                 WHERE saldo-estoq.it-codigo   = reporte-seletivo.es-codigo
                   AND saldo-estoq.cod-depos   = c-cod-depos               
                   AND saldo-estoq.cod-estabel = ord-prod.cod-estabel  
                   AND saldo-estoq.cod-localiz = ""
                   AND saldo-estoq.qtidade-atu > 0:

                 ASSIGN tt-res-neg.lote-serie  = saldo-estoq.lote
                        v_tot_quantidade       = v_tot_quantidade - saldo-estoq.qtidade-atu.
                 IF v_tot_quantidade <= 0 
                    THEN LEAVE blk_saldo.
                 /* ** ELSE ***/
          
                 /* ** Quantidade que ser† atendida por este lote***/
                 ASSIGN tt-res-neg.quantidade = saldo-estoq.qtidade-atu.
                 
                 /* ** Criar novo registro para ser atendido por outro lote ***/
                 create tt-res-neg.
                 assign tt-res-neg.nr-ord-produ  = ord-prod.nr-ord-prod
                        tt-res-neg.it-codigo     = reporte-seletivo.es-codigo 
                        tt-res-neg.quantidade    = v_tot_quantidade
                        tt-res-neg.cod-depos     = c-cod-depos
                        tt-res-neg.cod-localiz   = ""
                        tt-res-neg.lote-serie    = string(ord-prod.nr-ord-prod) + "SEM SALDO"
                        tt-res-neg.cod-refer     = ""
                        tt-res-neg.dt-vali-lote  = ?
                        tt-res-neg.positivo      = yes
                        tt-res-neg.nro-ord-seq   = 1.

              END.
              /* ** Fim localizaá∆o de saldos ***/

              assign  reporte-seletivo.quant-atend = reporte-seletivo.quant-atend + reporte-seletivo.qtd-unitaria * ttRepApi.qt-reporte.
                      reporte-seletivo.quant-saldo = reporte-seletivo.quant-saldo - reporte-seletivo.qtd-unitaria * ttRepApi.qt-reporte.

              if reporte-seletivo.quant-saldo = 0 then 
                 assign reporte-seletivo.situacao = yes.
               
         end.
         RUN piChecaEstrutura.
         ASSIGN pLogErro = CAN-FIND(FIRST tt-erro).
     END.
END PROCEDURE.

PROCEDURE piReportaProducao: /* Em uso */
    def input param pCodEstabel as char no-undo.
    DEFINE INPUT  PARAM pIndTipoRep AS INT.
    DEFINE INPUT  PARAM rOrdProd    AS ROWID.
    
    
    /* 1 - CPP 
       2 - SFC 
    */
    FOR EACH tt-erro :              DELETE tt-erro .            END.
    FOR EACH tt-aloca :             DELETE tt-aloca .           END.
    FOR EACH tt-res-neg :           DELETE tt-res-neg .         END.
    FOR EACH tt-rep-prod :          DELETE tt-rep-prod .        END.
    FOR EACH tt-reservas :          DELETE tt-reservas .        END.
    FOR EACH tt-refugo :            DELETE tt-refugo .          END.
    FOR EACH tt-apont-mob :         DELETE tt-apont-mob .       END.


    FOR FIRST ord-prod NO-LOCK 
        WHERE ROWID(ord-prod) = rOrdProd, 
        FIRST ITEM NO-LOCK 
        WHERE ITEM.it-codigo = ord-prod.it-codigo:
    END.

    RUN PiAtualizaLog.

    OPERACAO:
    DO  TRANSACTION ON ERROR UNDO OPERACAO, RETURN "NOK":
       RUN CriaTTRepProd(INPUT pIndTipoRep). 

       RUN pi-recebe-tt-rep-prod  IN h-cpapi001 (INPUT  TABLE tt-rep-prod).

       
       RUN piCriaResNeg (input pCodEstabel). 
       IF CAN-FIND(FIRST tt-erro) THEN
           UNDO, LEAVE OPERACAO.
       
       IF cTipoReporte = "SELETIVO" THEN
       DO:
           run piAjustaTTResNeg(OUTPUT vLogErro). 
           
           IF  vLogErro THEN 
               UNDO, LEAVE OPERACAO.
       END.
       IF  AVAIL tt-log THEN
           ASSIGN tt-log.t1       = TIME 
                  tt-log.nr-itens = i-nr-itens.
       
       RUN pi-recebe-tt-reservas  IN h-cpapi001 (input table tt-reservas).
       RUN pi-verifica-saldo      IN h-cpapi001 (pCodEstabel).
       RUN pi-retorna-tt-reservas IN h-cpapi001 (OUTPUT TABLE tt-reservas).

       FOR EACH   tt-reservas
           WHERE  tt-reservas.log-sem-saldo:
           RUN piCriaErro(INPUT "N∆o encontrado saldo para o componente: " + tt-reservas.it-codigo + " no depos.: " + tt-reservas.cod-depos).
           IF AVAIL tt-log THEN
              ASSIGN tt-log.erro = "N∆o encontrado saldo para o componente: " + tt-reservas.it-codigo + " no depos.: " + tt-reservas.cod-depos.
       END.
       
       IF  NOT CAN-FIND(FIRST tt-erro) THEN
       DO:
           IF l-procura-saldo = NO 
           THEN ASSIGN tt-rep-prod.procura-saldos = NO.

           RUN pi-processa-reportes in h-cpapi001 (input-output table tt-rep-prod,
                                                   input        table tt-refugo,
                                                   input        table tt-res-neg,
                                                   input-output table tt-erro,
                                                   input yes,
                                                   input yes).

           IF  RETURN-VALUE = "NOK" AND NOT CAN-FIND(FIRST tt-erro) THEN DO:
               RUN piCriaErro("N∆o foi poss°vel efetuar o reporte de produá∆o devido a um erro interno de travamento. Favor solicitar para o terminal que travou, para sair do sistema.").
           END.

           IF NOT CAN-FIND(FIRST tt-erro) THEN
           DO:
               FOR EACH tt-rep-prod.
                   CREATE checa-reporte.
                   ASSIGN checa-reporte.it-codigo   = tt-rep-prod.it-codigo
                          checa-reporte.serie       = tt-rep-prod.serie
                          checa-reporte.dt-trans    = tt-rep-prod.data
                          checa-reporte.usuario     = c-seg-usuario
                          checa-reporte.quantidade  = tt-rep-prod.qt-reporte
                          checa-reporte.nr-ord-prod = tt-rep-prod.nr-ord-prod
                          checa-reporte.nro-docto   = INT(tt-rep-prod.nro-docto)
                          checa-reporte.cod-depos   = tt-rep-prod.cod-depos
                          checa-reporte.localizacao = tt-rep-prod.cod-localiz
                          checa-reporte.esp-docto   = "1".
                   FOR EACH  tt-res-neg 
                       WHERE tt-res-neg.nro-ord-seq = tt-rep-prod.nro-ord-seq :
                       CREATE checa-reporte.
                       ASSIGN checa-reporte.it-codigo   = tt-res-neg.it-codigo
                              checa-reporte.serie       = tt-rep-prod.serie
                              checa-reporte.dt-trans    = tt-rep-prod.data
                              checa-reporte.usuario     = c-seg-usuario
                              checa-reporte.quantidade  = tt-res-neg.quantidade
                              checa-reporte.nr-ord-prod = tt-rep-prod.nr-ord-prod
                              checa-reporte.nro-docto   = int(tt-rep-prod.nro-docto)
                              checa-reporte.cod-depos   = tt-res-neg.cod-depos
                              checa-reporte.localizacao = tt-res-neg.cod-localiz
                              checa-reporte.esp-docto   = "28" /*"req"*/ .

                   END.
                   RELEASE checa-reporte.
               END.
           END.
           /* IF c-seg-usuario = "super" THEN
               MESSAGE "Depois de executar API PRODUCAO" RETURN-VALUE
                   VIEW-AS ALERT-BOX INFO BUTTONS OK. */
       END.

       /* IF  c-seg-usuario = "super" THEN
           MESSAGE "RETORNO PROCESSA REPORTES " RETURN-VALUE SKIP 
                   "TT-ERRO " can-find(FIRST tt-erro)
               VIEW-AS ALERT-BOX INFO BUTTONS OK. */
       IF NOT CAN-FIND(FIRST tt-erro) THEN
          ASSIGN tt-log.t2 = TIME.
       ELSE IF AVAIL tt-log THEN
       DO:
           FOR FIRST tt-erro:
               ASSIGN tt-log.erro = tt-erro.mensagem.
           END.
       END.
    END.

END PROCEDURE.

PROCEDURE CriaTTRepProd: /* Em uso */
    DEFINE INPUT PARAM pIndTipoRep AS INT.
    /* 1 - CPP 
       2 - SFC 
    */

    FOR EACH tt-rep-prod: DELETE tt-rep-prod. END.
    CREATE tt-rep-prod.
    ASSIGN tt-rep-prod.tipo              = 1 /*ord-prod.rep-prod*/
           tt-rep-prod.nr-ord-prod       = ord-prod.nr-ord-prod
           tt-rep-prod.it-codigo         = ord-prod.it-codigo
           tt-rep-prod.nro-ord-seq       = 1
           tt-rep-prod.nro-docto         = string(ord-prod.nr-ord-prod)
           tt-rep-prod.serie-docto       = c-serie
           tt-rep-prod.cod-depos-sai     = ?
           tt-rep-prod.cod-local-sai     = ""
           tt-rep-prod.data              = TODAY /*tt-reporte.dat-fim-reporte*/
           tt-rep-prod.un                = ord-prod.un
           tt-rep-prod.qt-reporte        = ttRepApi.qt-reporte /*tt-reporte.qtd-operac-reptda*/
           tt-rep-prod.it-codigo         = ord-prod.it-codigo
           tt-rep-prod.cod-depos         = ttRepApi.depos-ent
           tt-rep-prod.baixa-reservas    = 1
           tt-rep-prod.carrega-reservas  = YES  /* YES para carregar tt-reservas da tt-res-neg*/
           tt-rep-prod.procura-saldos    = ttRepApi.procura-saldo
           tt-rep-prod.reserva           = NO /* YES [Reservas] NO [tt-res-neg] */
           tt-rep-prod.requis-automatica = NO  
           tt-rep-prod.time-out          = 10
           tt-rep-prod.tentativas        = 3
           .
    IF pIndTipoRep = 1 THEN
         ASSIGN  tt-rep-prod.prog-seg          = "CP-ESAPI001"
                 tt-rep-prod.op-codigo         = ?
                 tt-rep-prod.cod-roteiro       = ?
                 tt-rep-prod.pto-controle      = ?
                 tt-rep-prod.finaliza-ordem    = ord-prod.qt-produzida + ttRepApi.qt-reporte >= ord-prod.qt-ordem.
    ELSE ASSIGN tt-rep-prod.it-oper           = ord-prod.it-codigo
                tt-rep-prod.op-codigo         = oper-ord.op-codigo
                tt-rep-prod.cod-roteiro       = oper-ord.cod-roteiro
                tt-rep-prod.it-oper           = oper-ord.it-codigo
                tt-rep-prod.pto-controle      = oper-ord.pto-controle
                tt-rep-prod.prog-seg          = "SF-ESAPI001"
                tt-rep-prod.finaliza-ordem    = oper-ord.qt-produzida >= oper-ord.qtd-previs-operac.
END PROCEDURE.

PROCEDURE piCriaResNeg: /* Em uso */
    def input param pCodEstabel as char no-undo.

    DEF VAR d-tot-lote          AS DECI NO-UNDO.

    assign i-nr-itens = 0.
    for each tt-res-neg:
        delete tt-res-neg.
    end.

    RUN esapi/esapi006.p ( INPUT ROWID(ITEM),  /* Rowid */
                           INPUT "",           /* Refer */
                           INPUT 1,            /* Quantidade */
                           INPUT 0,            /* Quantidade Liq */
                           INPUT 0,            /* N°vel */
                           INPUT-OUTPUT TABLE tt-estrutura,
                           INPUT TODAY,        /* Data Corte */
                           INPUT YES,          /* Recursivo */
                           INPUT 19,           /* N°veis */
                           INPUT pCodEstabel).       /* Estabel */
    for EACH  tt-estrutura no-lock:
        find b-item where b-item.it-codigo = tt-estrutura.es-codigo  no-lock.
        
        if tt-estrutura.log-fantasma = no then do:   
            assign i-nr-itens = i-nr-itens + 1.
            find first tt-res-neg 
                 where tt-res-neg.it-codigo = tt-estrutura.es-codigo no-error.
            if not avail tt-res-neg then 
            DO:
                create tt-res-neg.
                IF b-item.fraciona  = NO THEN
                DO:
                    IF    (tt-estrutura.quant-usada  *  ttRepApi.qt-reporte) <>
                       int(tt-estrutura.quant-usada  *  ttRepApi.qt-reporte) THEN
                    DO:
                        RUN piCriaErro(INPUT "Item.: " + trim(tt-estrutura.es-codigo) + " n∆o aceita quantidade fracionada. Qtd.: " + STRING(tt-estrutura.quant-usada  *  ttRepApi.qt-reporte)).
                    END.
                END.
            END.
            assign tt-res-neg.nr-ord-produ  = ord-prod.nr-ord-prod
                   tt-res-neg.it-codigo     = tt-estrutura.es-codigo
                   tt-res-neg.quantidade    = tt-res-neg.quantidade + (tt-estrutura.quant-usada  *  ttRepApi.qt-reporte) /* Emerson - comentei o Truncate porque nao requisitava itens na quinta casa decimal */
                   /* tt-res-neg.quantidade    = tt-res-neg.quantidade + (truncate(tt-estrutura.quant-usada,4) * ttRepApi.qt-reporte) */
                   /*Foi usado o Truncate porque o seletivo trata apenas quatro posiá‰es */
                   tt-res-neg.cod-depos     = if ttRepApi.depos-sai = "tam" then "inj" else ttRepApi.depos-sai
                   tt-res-neg.cod-localiz   = ""
                   tt-res-neg.lote-serie    = ""
                   tt-res-neg.cod-refer     = ""
                   tt-res-neg.dt-vali-lote  = ?
                   tt-res-neg.positivo      = yes
                   tt-res-neg.nro-ord-seq   = 1.
        
            /* tratamento Matriz para itens consumidos por mais produtos, exemplo: filme do schrink */ 
            
             IF ord-prod.cod-estabel = "101" THEN DO:
                 if tt-estrutura.es-codigo = "1155903"  or
                   tt-estrutura.es-codigo = "1156080"  or 
                   tt-estrutura.es-codigo = "1165933" then
                    assign tt-res-neg.cod-depos   = "aca"
                           tt-res-neg.cod-localiz = "".
                           
                 if tt-estrutura.es-codigo = "1165933" and 
                    ord-prod.nr-linha = 2 then
                    assign tt-res-neg.cod-depos   = "cnt"
                           tt-res-neg.cod-localiz = "".
             END.

             /* ** Inicio localizaá∆o de saldo por lote ***/
             ASSIGN v_tot_quantidade = tt-res-neg.quantidade
                    c-cod-depos      = tt-res-neg.cod-depos.

             blk_saldo:
             FOR EACH saldo-estoq NO-LOCK
                WHERE saldo-estoq.it-codigo   = tt-estrutura.es-codigo
                  AND saldo-estoq.cod-depos   = c-cod-depos               
                  AND saldo-estoq.cod-estabel = ord-prod.cod-estabel 
                  AND saldo-estoq.cod-localiz = ""
                  AND saldo-estoq.qtidade-atu > 0:

                ASSIGN tt-res-neg.lote-serie  = saldo-estoq.lote
                       v_tot_quantidade       = v_tot_quantidade - saldo-estoq.qtidade-atu.
                IF v_tot_quantidade <= 0 
                   THEN LEAVE blk_saldo.
                /* ** ELSE ***/

                /* ** Quantidade que ser† atendida por este lote***/
                ASSIGN tt-res-neg.quantidade = saldo-estoq.qtidade-atu.

                /* ** Criar novo registro para ser atendido por outro lote ***/
                create tt-res-neg.
                assign tt-res-neg.nr-ord-produ  = ord-prod.nr-ord-prod
                       tt-res-neg.it-codigo     = tt-estrutura.es-codigo 
                       tt-res-neg.quantidade    = v_tot_quantidade
                       tt-res-neg.cod-depos     = c-cod-depos
                       tt-res-neg.cod-localiz   = ""
                       tt-res-neg.lote-serie    = string(ord-prod.nr-ord-prod) + "SEM SALDO"
                       tt-res-neg.cod-refer     = ""
                       tt-res-neg.dt-vali-lote  = ?
                       tt-res-neg.positivo      = yes
                       tt-res-neg.nro-ord-seq   = 1.

             END.

             /* ** Fim localizaá∆o de saldos ***/
        end.
        
    end.

    /* Tratamento para eliminar registros com mais de um mesmo item e lote, somando quantidades */
    FOR EACH tt-res-neg
        BREAK BY tt-res-neg.it-codigo
              BY tt-res-neg.lote-serie:

        ASSIGN d-tot-lote = d-tot-lote + tt-res-neg.quantidade.

        IF LAST-OF(tt-res-neg.lote-serie) 
        THEN DO:

            ASSIGN tt-res-neg.quantidade = d-tot-lote
                   d-tot-lote            = 0.
        END.
        ELSE DO:
            DELETE tt-res-neg.
            ASSIGN l-procura-saldo = NO.
        END.
    END.
end.

/* CH«O DE FABRICA
PROCEDURE piCriaTTReporte:
    for each tt-reporte: delete tt-reporte. end.

    create  tt-reporte.
    assign  tt-reporte.rw-split-operac       = rowid(split-operac)
            tt-reporte.cod-ferr-prod         = "" 
            /*
            tt-reporte.dat-fim-setup         = 
            tt-reporte.dat-inic-setup        = 
            tt-reporte.qtd-segs-fim-setup    = 
            tt-reporte.qtd-segs-inic-setup   = 
            */
            tt-reporte.dat-fim-reporte       = dat-fim-reporte
            tt-reporte.dat-inic-reporte      = dat-inic-reporte
            /*
            tt-reporte.qtd-operac-refgda     = 
            tt-reporte.qtd-operac-retrab     = 
            */
            tt-reporte.qtd-operac-aprov      = ttRepApi.qt-reporte
            tt-reporte.qtd-operac-reptda     = tt-reporte.qtd-operac-aprov
            tt-reporte.qtd-segs-inic-reporte = i-hra-inic-rep 
            tt-reporte.qtd-segs-fim-reporte  = i-hra-fim-rep  
            /*
            tt-reporte.cod-equipe            = 
            */
            tt-reporte.num-contador-inic     = 0
            tt-reporte.num-contador-fim      = 0
            tt-reporte.baixa-reservas        = 1
            tt-reporte.informa-deposito      = no
            tt-reporte.informa-localizacao   = no
            tt-reporte.requisicao-automatica = no
            tt-reporte.busca-saldos          = yes
            /*
            tt-reporte.conta-refugo          = 
            */ .
END PROCEDURE.
*/

PROCEDURE PiAtualizaLog:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH   tt-log.
        DELETE tt-log.
    END.

    CREATE tt-log.
    ASSIGN tt-log.tipo      = cTipoReporte
           tt-log.h-ini     = time
           tt-log.hora-ini  = string(time,"HH:MM:SS")
           tt-log.etiqueta  = ttRepApi.cEtiqueta
           tt-log.seletivo  = cTipoReporte.

END PROCEDURE.

PROCEDURE piDefineSerie:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       PROCEDURE define-serie :
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iTime AS INTEGER    NO-UNDO.

    /*find first controla-serie exclusive-lock.*/
    FOR FIRST controla-serie NO-LOCK:
        assign a = controla-serie.serie.

        do i = 0 to 9:
            assign letra[i + 1] = string(i,"9").
        end.

        do i = 65 to 90:
            assign letra[i - 54] = chr(i).
        end.

        do i = 97 to 122:
            assign letra[i - 60] = chr(i).
        end.


       do i = 1 to 62:
           if asc(substring(a,3,1)) = asc(letra[i]) then 
                assign p3 = i
                       px3 = i.
           if asc(substring(a,2,1)) = asc(letra[i]) then 
                assign p2 = i
                       px2 = i.
           if asc(substring(a,1,1)) = asc(letra[i]) then 
                assign p1 = i
                       px1 = i.

        end.

        do i = 1 to 62:

            if asc(letra[i]) = asc(substring(a,3,1)) then 
                assign px3 = p3 + 1.

            if px3 > 62 then 
                assign px3 = 1
                       px2 = p2 + 1.

            if px2 > 62 then 
                assign px3 = 1
                       px2 = 1
                       px1 = p1 + 1.

            if px1 > 62 then
                assign px3 = 1
                       px2 = 1
                       px1 = 1.


        end.

        ASSIGN a       = letra[px1] + letra[px2] + letra[px3]
               c-serie = a.
    END.

    ASSIGN iTime = TIME.
    REPEAT:
        FIND FIRST  controla-serie EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED(controla-serie) THEN
        DO:
            IF TIME - iTime > 10 THEN LEAVE.
            NEXT.
        END.
        ELSE LEAVE.
    END.
    FIND FIRST controla-serie EXCLUSIVE-LOCK NO-ERROR.
    ASSIGN controla-serie.serie = c-serie.
    FIND FIRST controla-serie NO-LOCK NO-ERROR.
    
END PROCEDURE.

PROCEDURE piRetornaLog:
    DEF OUTPUT PARAM TABLE FOR tt-log.
    DEF OUTPUT PARAM pserie LIKE c-serie.

    ASSIGN pserie = c-serie.
END PROCEDURE.

PROCEDURE piCriaErro:
    DEF INPUT PARAM pMsg AS CHAR.

    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = 1
           tt-erro.cd-erro  = 17567
           tt-erro.mensagem = pMsg.

END PROCEDURE.

PROCEDURE pi-Destroy:

    IF VALID-HANDLE(h-cpapi001) THEN DO:

        RUN pi-finalizar in h-cpapi001.

        DELETE OBJECT h-cpapi001.
        ASSIGN h-cpapi001 = ?.
    END.

END.

PROCEDURE piRetornaErro:
    DEF OUTPUT PARAM TABLE FOR tt-erro.
END PROCEDURE.



PROCEDURE piRecebeErro:
    DEF INPUT PARAM TABLE FOR tt-erro.

    RUN pi-recebe-tt-erro IN h-cpapi001 (INPUT TABLE tt-erro).

END PROCEDURE.

