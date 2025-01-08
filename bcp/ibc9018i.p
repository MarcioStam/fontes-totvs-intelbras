/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9018I 2.00.00.018 } /*** 010018 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9018i MBC}
&ENDIF

{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9025.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - Janeiro/2004 - Farley - Criaá∆o do programa                **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Transferància WMS                **
**                                                                                         **
********************************************************************************************/
&if '{&mgscm_version}' >= '2.04' &then
/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName          - Nome do programa e, tambem, do Codigo da transacao do Data Collection   **
**                        que sera acionada pela interface.                                       **
** TempTable            - Nome da Temp-Table da transacao de negocio para comunicacao com ERP.    **
**                        Ex: tt-transf-wms.                                                      **
** FrameSize            - Tamanho da tela da interface. Deve-se observar este parametro quando da **
**                        definicao das telas, o espaco utilizado nao pode ultrapassar o limite   **
**                        estabelecido por este pre-processador.                                  **
** Frame99Name          - Nome da Tela. Sugestao "Frame" mais sequencia.                          **
**                        Ex. Frame01, Frame02, Frame03, etc.                                     **
** Frame99Defs          - Definicoes da tela onde a mesma deve conter:                            **
**                        .Titulo da Tela quando necessario.                                      **
**                        .Campos com a opcao no-label e sua localizacao Ex. At Row x Col y.      **
**                        .Literais que substituem os labels dos campos e sua localizacao.        **
**                        .Instrucoes de Navegacao quando houver espaco livre para o mesmo.       **
**                        Ex. "F4=Sair","ESC=Voltar","F2=Gravar" etc.                             **
** Frame99Repeat        - Indica se a tela tem caracteristica de repeticao. O Valor YES indica    **
**                        que ha repeticao e o valor NO indica que nao ha repeticao.              **
** Update99Fields       - Relaciona os campos que serao solicitados na tela.                      **
**                        OBS. Nao deve conter formatacao. Ex. ttWork.it-codigo no-label.         **
** TriggerBeforeFrame99 - Gatilho para ser executado antes da execucao da tela. Neste gatilho     **
**                        devem ser colocadas chamadas as procedures de inicializacao dos campos  **
**                        da tela.                                                                **
** TriggerAfterFrame99  - Gatilho para ser executado apos a execucao da tela. Neste gatilho       **
**                        dever ser colocada a chamada a procedures que devera armazenar  na      **
**                        temp-table {&TempTable} os campos da ttWork, que sao os campos          **
**                        solicitados em tela. Neste gatilho tambem, quando o mesmo se referir a  **
**                        ultima tela de entrada de dados, devera existir uma chamada a procedure **
**                        que executa a procedure _GenerateDCTransaction que e responsavel por    **
**                        gerar a transacao no Coleta de Dados.                                   **
** UserTriggers         - Este pro-processador destina-se as triggers customizadas do usuario.    **
**                        Ex: Alimentar um campo da dela conforme o informado em outro campo.     **
**                            On Leave of ttWork.cod-depos in Frame Frame02                       **
**                            Do:                                                                 **
**                                Case ttWork.cod-depos:                                          **
**                                  When 'Pro' Then Assign ttWork.cod-local = 'Pro01'.            **
**                                  When 'Alm' Then Assign ttWork.cod-local = 'Alm01'.            **
**                                  When 'Exp' Then Assign ttWork.cod-local = 'Exp01'.            **
**                            End.                                                                **
** AtiveObject1         - Este pro-processador permite que se destruam os objetos persistentes    **
**                        no final da sessao progress.                                            **
**                        Ex: &global-define ActiveObject wgbosc074                               **
***************************************************************************************************/
/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9018

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-picking-wms
{bcp/bc9018.i " "}
{bcp/bc9018.i1 }
{bcp/bc9015.i3} /* def variaveis padroes */
{bcp/bc9018h.i} /*mk - definicao das procedures utilizadas */
/* login */
{utp/utapi009.i}
DEFINE INPUT PARAMETER vRowid AS ROWID NO-UNDO.
define input-output parameter table for tt-picking-wms-table.
define buffer bf-ttResumo for ttResumo.
define buffer bf-ttEmbSelec for ttEmbSelec.

FIND FIRST ttWm-box-movto-idx-picking WHERE ROWID(ttWm-box-movto-idx-picking) = vRowid NO-ERROR.
FIND FIRST ttWork NO-ERROR.

/************************************************************/

/* Variaveis de trabalho ---                                */              
Define Variable vLogAnswer              As Logical                      Init YES  No-undo.
Define Variable vLogAnswer-esc          As Logical                      Init NO   No-undo.
define variable vLogFimTran             as logical                      init no   no-undo.

Define Variable vCodSenha  AS CHAR FORMAT 'x(12)':U No-undo.
Define Variable vEndereco  AS CHAR FORMAT 'x(12)':U No-undo.
Define Variable vCodBloco  AS CHAR                  No-undo.
Define Variable vCodRua    AS CHAR                  No-undo.
Define Variable vCodNivel  AS CHAR                  No-undo.
Define Variable vCodColuna AS CHAR                  No-undo. 

define variable cDispItem as character              no-undo.
define variable cEmbalSel as integer                no-undo.
define variable cTotalItem as character             no-undo.
define variable cBoxOrig   as character             no-undo.
define variable cIndex     as integer               no-undo.

/*fk - opcao do tipo de leitura. Esse valor vem da bc9018h.p*/
DEFINE NEW GLOBAL SHARED VARIABLE iIndTipoLeitura   AS INTEGER NO-UNDO. 

/*mk*/
DEFINE VARIABLE iLogHabilitaUn AS LOGICAL     NO-UNDO.
DEFINE VARIABLE p-qtd-item     AS DECIMAL     NO-UNDO.

Define New Shared Variable wgbosc035 As Widget-handle No-undo. 
Define New Shared Variable wgbosc145 As Widget-handle No-undo. 

define query  qSaldoItem for ttResumo.
define browse bSaldoItem query qSaldoItem no-lock
    display  cDispItem @ ttResumo.cod-item
    with size 20 by 2 No-box No-labels No-scrollbar-vertical.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Saldo Box '                                      At Row 01  Col 01                               ~
                             cBoxOrig                                          at row 01  col 11 no-label                      ~
                             'Emb:'                                            at row 02  col 01                               ~
                             ttEmbSelec.cNumEmbal                              at row 02  col 05 no-label                      ~
                             bSaldoItem                                        at row 03  col 01                               ~
                             'Lt:'                                             at row 05  col 01                               ~
                             ttResumo.cod-lote                                 at row 05  col 04 NO-LABEL FORMAT "x(40)"  VIEW-AS FILL-IN SIZE 17 BY 0.88 ~
                             'It:'                                             at row 06  col 01                               ~
                             ttResumo.cod-item                                 at row 06  col 04 format "x(15)" no-label       ~
                             'Qtd:'                                            at row 07  col 01                               ~
                             ttWork.qtd-item                                   at row 07  col 05 FORMAT '>>>>>9.9999' NO-LABEL ~
                             'Tot.It:'                                         at row 08  col 01                               ~
                             cTotalItem                                        at row 08  col  8 no-label

&global-define Frame01Repeat yes 

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields                               ~
               bSaldoItem                                   
               
/************************************************************/

/* fk ini: frame */
DEFINE FRAME fCodEan
  ttWork.cod-livre-1 FORMAT "x(18)" NO-LABEL.

/* mk - Frame Emb~\Un */
DEFINE FRAME fEmbUn
    'Emb:'             AT ROW 01 COL 01
    ttWork.cod-livre-1 AT ROW 01 COL 05 NO-LABEL FORMAT "x(4)"
    'Un:'              AT ROW 02 COL 02
    ttWork.cod-livre-2 AT ROW 02 COL 05 NO-LABEL FORMAT "x(4)".

ON 'END-ERROR':U OF ttwork.cod-livre-1 IN FRAME fCodEan
DO: 
    RETURN NO-APPLY.
END.
ON 'ESC':U OF ttwork.cod-livre-1 IN FRAME fCodEan
DO: 
    RETURN 'ESC'.
END.
/*mk*/
ON 'END-ERROR':U OF ttwork.cod-livre-1 IN FRAME fEmbUn
DO: 
    RETURN NO-APPLY.
END.
ON 'ESC':U OF ttwork.cod-livre-1 IN FRAME fEmbUn
DO: 
    RETURN 'ESC'.
END.
/*mk*/
/* fk fim */

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. if return-value = 'esc':u then return no-apply.
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. If Return-value = 'OK' AND vLogFinaliza = YES Then RETURN 'OK':U.            ~
                                                            If Return-value = 'NOK'Then RETURN 'NOK':U.                                  ~
&global-define TriggerBeforefCodEan If Return-value = 'ESC' Then RETURN NO-APPLY.            ~

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers                                                                                                              ~
    /* Tecla enter no browser */ ~
    ON 'return':U OF bSaldoItem IN Frame Frame01                                                                 ~
    DO:                                                                                                          ~
        RUN pi-BrowserEnterEvent IN THIS-PROCEDURE.                                                              ~
    End.                                                                                                         ~
    /* Tecla 1 no browser */                                                                                     ~
    ON '1':U OF bSaldoItem in Frame Frame01                                                                      ~
    DO:                                                                                                          ~
        apply 'return' to bSaldoItem in frame Frame01.                                                           ~
    END.                                                                                                         ~
    /* Tecla 2 do browser */                                                                                     ~
    ON '0':U OF bSaldoItem in Frame Frame01                                                                      ~
    DO:                                                                                                          ~
        RUN pi-BrowserZeroEvent IN THIS-PROCEDURE.                                                               ~
    END.                                                                                                         ~
    /* Display do Saldo de browser */ ~
    ON 'row-display':U OF bSaldoItem in Frame Frame01                                                            ~
    DO:                                                                                                          ~
        RUN pi-BrowserRowDisplayEvent IN THIS-PROCEDURE.                                                         ~
    END.                                                                                                         ~
    /* Mudanca de valor do browser */ ~
    on 'value-changed' of bSaldoItem in Frame Frame01                                                            ~
    do:                                                                                                          ~
        RUN pi-BrowserValueChangedEvent IN THIS-PROCEDURE.                                                       ~
    End.                                                                                                         ~
    /* Tecla esc */ ~
    on 'esc':u of current-window anywhere do:                                                                    ~
        assign vLogSai      = yes                                                                                ~
               vLogFinaliza = yes.                                                                               ~
        return 'esc':u.                                                                                          ~
    end.                                                                                                         ~
    ON 'ESC':U of Frame Frame01 anywhere                                                                         ~
    DO:                                                                                                          ~
        RUN pi-BrowserEscEvent IN THIS-PROCEDURE.                                                                ~
        return 'esc':u.                                                                                          ~
    END.                                                                                                         ~
    ON 'ESC':U of Frame fCodEan                                                                                  ~
    DO:                                                                                                          ~
        assign vLogSai      = yes                                                                                ~
               vLogFinaliza = yes.                                                                               ~
        Return 'ESC':U.                                                                                          ~
    END.                                                                                                         ~
/************************************************************/
/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc035
&global-define ActiveObject2 wgbosc044
&global-define ActiveObject3 wgbosc145
/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/
/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao e necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */
/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ≤ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame01 com valores em branco              **
** Esta procedure e executada pelo pre-processador {&TriggerBeforeFrame01}.                       **
****************************************************************************************************/

Procedure InicializaCamposFrame01: 
    if  vLogSai or vLogFinaliza then
        return 'esc':u.

    IF NOT VALID-HANDLE(wgbosc035)  THEN DO:
       Run scbo/bosc035.p Persistent SET wgbosc035.
       Run openQueryStatic In wgbosc035 (Input "Main":U) No-error. 
    END.      
    IF NOT VALID-HANDLE(wgbosc044)  THEN DO:
       Run scbo/bosc044.p Persistent SET wgbosc044.
       Run openQueryStatic In wgbosc044 (Input "Main":U) No-error. 
    END. 
    IF NOT VALID-HANDLE(wgbosc145)  THEN DO:
       Run scbo/bosc145.p Persistent SET wgbosc145.
       Run openQueryStatic In wgbosc145 (Input "Main":U) No-error. 
    END. 

    assign cBoxOrig:screen-value in Frame Frame01 = string(ttWork.num-box-lido)
           cTotalItem = "0/" + String((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking).   

    If valid-handle(wgbosc035) Then
        run getOcupacaoBox in wgbosc035 (input ttWm-box-movto-idx-picking.cod-estabel,
                                         input ttWm-box-movto-idx-picking.cod-local,
                                         input ttWork.num-box-lido,
                                         output table ttResumo).

    /* Agrupando as quantidades dos itens existentes no box informado e verificando existància de alguma seleá∆o */
    For each ttResumo exclusive-lock:

        /* Se o saldo n∆o estiver liberado n∆o dever† ser mostrado */
        if ttResumo.ind-status-saldo <> 3 then do:
            delete ttResumo.
            next.
        End.


        If ttResumo.cod-embalagem <> ttWm-box-movto-idx-picking.cod-embalagem Then do:
            delete ttResumo.
            next.
        End.


        If valid-handle(wgbosc145) Then do: /* Validando se existe embalagem padr∆o para o item. Validaá∆o para garantia, pois n∆o deveria existir esta situaá∆o na base */
            run existeEmbalagemItemLocal in wgbosc145 (input ttResumo.cod-estabel,
                                                       input ttResumo.cod-local,
                                                       input ttResumo.cod-item).
            If return-value = "NOK":U Then do:
                delete ttResumo.
                next.
            End.
        End.

        assign ttResumo.r-Rowid = rowid(ttResumo)
               cEmbalSel = 0.
        assign ttResumo.qtd-item = ttResumo.qtd-item - ttResumo.qtd-item-bloq.
        If ttResumo.qtd-item <= 0 Then do: /* Se o saldo do item for igual a zero, n∆o Ç preciso disponibilizar no zoom */
            delete ttResumo.
            next.
        End.

        /* Consolidando os registros com as mesmas caracter°sticas em um mesmo registro (item, referencia, lote, embalagem e quantidades) */
        For each bf-ttResumo 
            WHERE bf-ttResumo.cod-item    = ttResumo.cod-item 
            AND bf-ttResumo.cod-embalagem = ttResumo.cod-embalagem 
            AND bf-ttResumo.qtd-item      = ttResumo.qtd-item 
            AND bf-ttResumo.qtd-item-bloq = ttResumo.qtd-item-bloq 
            AND bf-ttResumo.qtd-original  = ttResumo.qtd-original 
            AND bf-ttResumo.cod-refer     = ttResumo.cod-refer 
            AND bf-ttResumo.cod-lote      = ttResumo.cod-lote 
            AND rowid(bf-ttResumo)       <> rowid(ttResumo):

            ASSIGN ttResumo.qti-embalagem = ttResumo.qti-embalagem + bf-ttResumo.qti-embalagem.
            DELETE bf-ttResumo.
        End.

    End.
    FIND FIRST ttResumo where ttResumo.cod-item = ttWm-box-movto-idx-picking.cod-item NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ttResumo THEN DO:
       {bcp/bc9105.i "1" "N∆o existem saldos liberados para o item (DC)"}
       assign vLogSai = yes                                                                                     
              vLogfimTran = yes.    
       LEAVE.
    END.
    open query qSaldoItem for each ttResumo where ttResumo.cod-item = ttWm-box-movto-idx-picking.cod-item and 
           ttResumo.cod-refer = ttWm-box-movto-idx-picking.cod-refer no-lock.

    apply 'value-changed' to bSaldoItem in Frame Frame01.


End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame03}.                        **
****************************************************************************************************/
Procedure GravaCamposFrame01:

    define variable cTotalQtde as integer no-undo.
    define variable lSai       as logical init no no-undo.
    define variable cNumEmbal  as integer no-undo.
    define variable i          as integer no-undo.

    If vlogFinaliza or vLogFimTran Then do:
        apply 'go' to frame Frame01.
    End.

End Procedure.

/* **************************************************************************************************** */
/*                                                                                                      */
/* **************************************************************************************************** */
Procedure piVerificarTransf:

    define input        parameter pQtdItem          as integer no-undo.
    define input        parameter pQtdItemEmbalagem as integer no-undo.
    define input        parameter pQtiEmbalagem     as integer no-undo.

    define variable               cTot              as integer no-undo.

    If pQtdItem = 0 Then leave.

    if not can-find(first tt-picking-wms-table where tt-picking-wms-table.cod-item          = ttResumo.cod-item and
         tt-picking-wms-table.qtd-item          = pQtdItem and
         tt-picking-wms-table.cod-embalagem     = ttResumo.cod-embalagem and
         tt-picking-wms-table.qtd-item-digit    = pQtdItemEmbalagem and
         tt-picking-wms-table.qtd-embalagem     = pQtiEmbalagem and
         tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto) and pQtiEmbalagem <> 0 then do:
           run piCriarTransf (input pQtdItem,
                              input pQtdItemEmbalagem,
                              input 1).
   End.
   else do:
       for each tt-picking-wms-table where tt-picking-wms-table.cod-item          = ttResumo.cod-item and
             tt-picking-wms-table.qtd-item          = pQtdItem and
             tt-picking-wms-table.cod-embalagem     = ttResumo.cod-embalagem and
             tt-picking-wms-table.qtd-item-digit    = pQtdItemEmbalagem and
             tt-picking-wms-table.qtd-embalagem     = pQtiEmbalagem and /* Esta Quantidade sempre vai ser 1 */
             tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto no-lock:

           /* N∆o considerar registros de transferància que n∆o est∆o associados ao item especificado */  
           if rowid(ttResumo)  <>  to-rowid(ttEmbSelec.cChave) then next. 
           assign cTot = cTot + 1.
       End.
       If integer(entry(1,ttEmbSelec.cNumEmbal,"/")) > cTot  Then do:
           Do cIndex = 1 to (integer(entry(1,ttEmbSelec.cNumEmbal,"/")) - cTot):
               run piCriarTransf (input pQtdItem,
                                  input pQtdItemEmbalagem,
                                  input 1).
           End.
       End.
   End.

End procedure.

/* **************************************************************************************************** */
/*                                                                                                      */
/* **************************************************************************************************** */
Procedure piCriarTransf:
    define input        parameter pQtdItem          as integer no-undo.
    define input        parameter pQtdItemEmbalagem as integer no-undo.
    define input        parameter pQtiEmbalagem     as integer no-undo.

    If valid-handle(wgbc9018f) Then do:
        RUN pi-cria-tt-picking-ems-table IN wgbc9018f (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                                       Input ttWm-box-movto-idx-picking.cod-local,
                                                       INPUT ttWm-box-movto-idx-picking.id-movto,
                                                       INPUT ttWm-box-movto-idx-picking.ind-tipo-movto,
                                                       INPUT ttwm-box-movto-idx-picking.id-docto,
                                                       INPUT ttWork.num-serial,
                                                       INPUT ttWm-box-movto-idx-picking.num-seq-item,
                                                       INPUT pQtdItem,
                                                       INPUT pQtdItemEmbalagem , 
                                                       INPUT ttWm-box-movto-idx-picking.cod-item,
                                                       INPUT ttWork.num-box-lido /* ttWm-box-movto-idx-picking.id-box */ ,
                                                       INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                                       INPUT ttWm-box-movto-idx-picking.qti-embalagem,
                                                       INPUT ttWm-box-movto-idx-picking.dt-atualizacao,
                                                       INPUT ttWm-box-movto-idx-picking.dt-transacao,
                                                       INPUT ttWork.num-tempo-inicio,
                                                       INPUT ttWork.cod-coletor,
                                                       INPUT ttWork.cod-equipamento,
                                                       input ttResumo.cod-lote,
                                                       INPUT-OUTPUT TABLE tt-picking-wms-table,
                                                       OUTPUT TABLE tt-erro).
    End.
End procedure.

/* **************************************************************************************************** */
/* fk inicio - Busca a quantidade digitada em tela. Caso o codigo for por ean, pega do ean              */
/* **************************************************************************************************** */
PROCEDURE pi-getQtdItem:
    DEFINE VARIABLE deValorAnterior AS DECIMAL    NO-UNDO.

    /* Armazena o valor anterior */
    ASSIGN deValorAnterior = ttWork.qtd-item.

    /* Se for por quantidade, pega a quantidade digitada em tela */
    IF iIndTipoLeitura = 2 THEN DO:

        /* Repete atÇ o usuario informar o valor correto */
        REPEAT ON ENDKEY UNDO, NEXT:
            update ttWork.qtd-item no-label with frame eu view-as dialog-box Font 2 size 21 by 3.1 title "Qtd...". 

            /* Se a quantidade atendida for maior que a quantidade requisitada, sai fora  */
            IF (ttWork.qtd-item - deValorAnterior + DECIMAL(ENTRY(1,cTotalItem,"/"))) <= DECIMAL(ENTRY(2,cTotalItem,"/")) THEN DO:
                LEAVE.
            END.
        END.
    END.

    /* Confirma as informacoes digitadas */
    RUN pi-atualizaQtdTela IN THIS-PROCEDURE.


END PROCEDURE.
/* fk fim */

/* **************************************************************************************************** */
/* fk inicio - Busca a quantidade digitada em tela. Caso o codigo for por ean, pega do ean              */
/* **************************************************************************************************** */
PROCEDURE pi-getQtdCodigoEanDun:

    /* Variaveis */
    DEFINE VARIABLE iTipoInformacao     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cCodItem            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cCodEmbalagem       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE deQtdInformacao     AS DECIMAL    NO-UNDO. /*Quantidade na etiqueta ean-dun*/
    DEFINE VARIABLE deQtdLidaEtiqueta   AS DECIMAL    INITIAL 0   NO-UNDO. /*Qtd lida para essa etiqueta*/
    DEFINE VARIABLE hbosc148            AS HANDLE     NO-UNDO.

    /*  */
    RUN scbo/bosc148.p PERSISTENT SET hbosc148.

    /* Repete ateh completar a qtd do movimento ou a qtd da etiqueta */
    REPEAT:

        /* Executa o evento de mudanca no browser */
        RUN pi-atualizaQtdTela IN THIS-PROCEDURE.
        RUN pi-BrowserValueChangedEvent IN THIS-PROCEDURE.

        /* Se a quantidade for maior que a quantidade do movimento, sai fora */
        IF decimal(entry(1,cTotalItem,"/")) >= decimal(entry(2,cTotalItem,"/")) THEN DO:
            LEAVE.
        END.

        /* Faz a leitura da etiqueta ean-dun */
        update ttWork.cod-livre-1 with frame fCodEan
               view-as dialog-box Font 2 size 21 by 3.1 title "EAN/DUN" . 

        /* Se for 999999, efetiva o q foi lido e sai fora */
        IF ttWork.cod-livre-1 = "999999" THEN DO:
            LEAVE.
        END.

        /* Busca as informacoes referente ao codigo ean */
        Run EmptyRowErrors In hbosc148.
        RUN readBarCode IN hbosc148 (INPUT ttResumo.cod-estabel,
                                     INPUT ttResumo.cod-local,
                                     INPUT ttwork.cod-livre-1, /*codigo ean/dun lido*/
                                     OUTPUT iTipoInformacao,
                                     OUTPUT cCodItem, 
                                     OUTPUT cCodEmbalagem,
                                     OUTPUT deQtdInformacao,
                                     OUTPUT TABLE RowErrors).

        /* Tratamento de erro */
        Run getRowErrors In hbosc148 (Output Table RowErrors) No-error.
        For Each RowErrors:
            Hide All No-pause.
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
            Hide All No-pause.
            next.
        End. 

        /* Teste inicio *****************************************************************/
        /*ASSIGN cCodItem = 'wms-serie'
            cCodEmbalagem = 'pallet'
            deQtdInformacao = 1.
        MESSAGE 'O metodo getInfoCodigoEanDun nao est† definido pela logistica.' SKIP
            'Est† sendo adicionado uma variavel de teste. Nao esquecer de retirar o comentario' SKIP
            ttwork.cod-item
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.*/
        /* Teste fim ********************************************************************/

        /* Verifica se o item do codigo ean/dun eh o mesmo item do serial */
        IF cCodItem <> ttResumo.cod-item THEN DO:
            {bcp/bc9105.i "0" "Item do codigo ean/dun lido n∆o confere com o item do c¢digo serial (DC)"}
            NEXT.
        END.

        /*  */
        ASSIGN deQtdLidaEtiqueta = deQtdLidaEtiqueta + deQtdInformacao.

        /* Se a qtd lida for maior q a qtd da etiqueta, considera apenas a qtd da etiqueta */
        IF deQtdLidaEtiqueta > ttResumo.qtd-item  THEN DO:
            ASSIGN ttWork.qtd-item = ttResumo.qtd-item.
            LEAVE.
        END.
        ELSE DO: 
            ASSIGN ttWork.qtd-item = deQtdLidaEtiqueta.

            /* Se a qtd lida for igual a qtd da etiqueta, sai fora */
            IF deQtdLidaEtiqueta >= ttResumo.qtd-item  THEN DO:
                LEAVE.
            END.
        END.

        /* Se completou a qtd da etiqueta, sai fora */
        IF (decimal(entry(1,cTotalItem,"/")) /*+ deQtdLidaEtiqueta*/ ) >=
           ( ( ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem ) + 
             ( ttWm-box-movto-idx-picking.qtd-item-picking ) ) THEN DO:
            /*fk*/ /*MESSAGE "Saiu " (decimal(entry(1,cTotalItem,"/")) + deQtdLidaEtiqueta) ">="  ( (decimal(entry(1,cTotalItem,"/")) + deQtdLidaEtiqueta) ) "+"  ttWm-box-movto-idx-picking.qtd-item-picking  VIEW-AS ALERT-BOX ERROR BUTTONS OK.*/
            LEAVE.
        END.

    END. /*repeat*/

    /*  */
    IF VALID-HANDLE (hbosc148) THEN DELETE OBJECT hbosc148.

    /* Confirma as informacoes digitadas */
    RUN pi-atualizaQtdTela IN THIS-PROCEDURE.

END PROCEDURE.

/* **************************************************************************************************** */
/* mk inicio - Busca a quantidade digitada em tela por Emb e Un (se parametrizado).                     */
/* **************************************************************************************************** */
PROCEDURE pi-getQtdEmbUn:
    DEFINE VARIABLE deValorAnterior AS DECIMAL    NO-UNDO.

    /* Armazena o valor anterior */
    ASSIGN deValorAnterior = ttWork.qtd-item.

    RUN pi-getLogHabilitaUn.

    /* Repete atÇ o usuario informar o valor correto */
    REPEAT /*ON ENDKEY UNDO, NEXT*/ :

        /* mk - Parametro definido para habilitar ou n∆o para o usuario informar a unidade */
        IF iLogHabilitaUn THEN DO:
            update ttWork.cod-livre-1 ttWork.cod-livre-2 no-label with frame fEmbUn view-as dialog-box Font 2 size 21 by 4 title "Emb~\Un". 
        END.
        ELSE DO:
            update ttWork.cod-livre-1 no-label with frame fEmbUn view-as dialog-box Font 2 size 21 by 4 title "Emb~\Un". 
        END.

        IF NOT VALID-HANDLE(wgbosc145) THEN DO:
            Run scbo/bosc145.p Persistent Set wgbosc145       No-error.
            Run openQueryStatic In wgbosc145 (Input "Main":U) No-error.
        END.

        /* mk Metodo para transformar a emb/un em quantidade */
        Run EmptyRowErrors In wgbosc145.
        RUN piConverteCaixaQtde IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel, 
                                              INPUT ttWm-box-movto-idx-picking.cod-local,   
                                              INPUT ttWm-box-movto-idx-picking.cod-item,    
                                              INPUT ttWm-box-movto-idx-picking.cod-embal,
                                              INPUT ttWork.cod-livre-1,  
                                              INPUT ttWork.cod-livre-2,
                                              OUTPUT p-qtd-item).
        IF RETURN-VALUE <> "OK" THEN DO:
            Run getRowErrors In wgbosc145 (Output Table RowErrors) No-error.
            For Each RowErrors:
                Hide All No-pause.
                ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
                Hide All No-pause.
                next.
            End. 
        END.
        ELSE DO:
        
            /* mk - Pega valor retornado do metodo. Emb~\Un convertida para Quantidade */
            ASSIGN ttWork.qtd-item = p-qtd-item.
    
            /* Se a quantidade atendida for maior que a quantidade requisitada, sai fora  */
            IF (ttWork.qtd-item - deValorAnterior + DECIMAL(ENTRY(1,cTotalItem,"/"))) <= DECIMAL(ENTRY(2,cTotalItem,"/")) THEN DO:
                LEAVE.
            END.
        END.
    END.

    /* Confirma as informacoes digitadas */
    RUN pi-atualizaQtdTela IN THIS-PROCEDURE.


END PROCEDURE.
/* mk fim */

/* **************************************************************************************************** */
/* Atualiza as informacoes em tela                                                          */
/* **************************************************************************************************** */
PROCEDURE pi-atualizaQtdTela:
    /* Confirma as informacoes digitadas */
    assign ttWork.qtd-item:screen-value in frame Frame01 = string(ttWork.qtd-item) 
          ttEmbSelec.qtdItem = ttWork.qtd-item. 

END PROCEDURE.


/* **************************************************************************************************** */
/* Quando digita enter no browser                                                           */
/* **************************************************************************************************** */
PROCEDURE pi-BrowserEnterEvent:
    /* Se nao tiver o ttResumo disponivel, sai fora  */
    If not avail ttResumo Then return no-apply.

    /* Se a quantidade atendida for maior que a quantidade requisitada, sai fora  */

    /* Verifica se abre embalagem */
    RUN getAbreEmbalagem In wgbosc145 (Input  ttWm-box-movto-idx-picking.cod-estabel, 
                                       Input  ttWm-box-movto-idx-picking.cod-local, 
                                       Input  ttWm-box-movto-idx-picking.cod-item, 
                                       INPUT  ttWm-box-movto-idx-picking.cod-embalagem, 
                                       Output v-log-abre-embalagem).  


    /* Verifica o tipo de leitura */ 
    IF iIndTipoLeitura = 3 THEN DO: 
        /* Faz a leitura por codigo ean/dun */ 
        RUN pi-getQtdCodigoEanDun. 
    END. 
    ELSE IF iIndTipoLeitura = 4 THEN DO:
        /* mk - Faz a leitura por emb/un*/
        RUN pi-getQtdEmbUn.
    END.
    ELSE DO: 

        /*MESSAGE 
            ttResumo.qtd-item
            ttWm-box-movto-idx-picking.qtd-item 
            ttWm-box-movto-idx-picking.qti-embalagem
            ttWm-box-movto-idx-picking.qtd-item-picking
            DECIMAL(ENTRY(1,cTotalItem,"/"))
            VIEW-AS ALERT-BOX INFO BUTTONS OK.*/

        /* ? */ 
        If ttResumo.qtd-item + decimal(entry(1,cTotalItem,"/")) > 
        ( (ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem  ) - 
          (ttWm-box-movto-idx-picking.qtd-item-picking ) ) Then do: 

            /* So executa se abre embalagem */
            If v-log-abre-embalagem Then do:
                RUN pi-getQtdItem IN THIS-PROCEDURE.
            END.
            ELSE DO:
                return no-apply. 
            END.

            /* Se retornar o valor zero, nao processa nada */
            /*IF ttWork.qtd-item = 0 THEN DO:
                return no-apply. 
            END.*/

        END.
        ELSE DO:
            /* fk Adiciona o valor igual ao a quantidade da embalagem  */
            ASSIGN ttEmbSelec.qtdItem = ttResumo.qtd-item.
        END.
    END.

    /* Procura as informacoes disponiveis em tela */
    find last ttWork no-error.

    /* Atribui as informacoes da embalagem na tela */
    assign 
        ttWork.cod-embalagem = ttResumo.cod-embalagem
        ttWork.cod-item      = ENTRY  (1,ttResumo.cod-item:screen-value in browse bSaldoItem,"/")
        ttWork.qtd-embalagem = INTEGER(entry(2,ttEmbSelec.cNumEmbal:screen-value in frame Frame01,"/")).  

    /* Procura pela embalagem selecionada na tela */
    find ttEmbSelec where ttEmbSelec.cChave = string(rowid(ttResumo)) NO-ERROR.                                       

    /* Atualiza as informacoes em tela */
    If ttWork.qtd-embalagem > integer(entry(1,ttEmbSelec.cNumEmbal,"/")) THEN DO:                                
        assign entry(1,ttEmbSelec.cNumEmbal,"/") = string(integer(entry(1,ttEmbSelec.cNumEmbal,"/")) + 1).   
    END.

    /* Atualiza o numero de embalagem */
    assign ttEmbSelec.cNumEmbal:screen-value in frame Frame01 = string(ttEmbSelec.cNumEmbal).                

    /* Executa o evento de mudanca no browser */
    apply 'value-changed' to bSaldoItem in frame Frame01.                                                    

END PROCEDURE.

/* **************************************************************************************************** */
/* Quando digita o numero zero no browser                                                           */
/* **************************************************************************************************** */
PROCEDURE pi-BrowserZeroEvent:
    /* Se nao tiver nada, returna */
    If not avail ttResumo Then return no-apply.                                                              

    /* Procura pela embalagem selecionada em tela */
    find ttEmbSelec where ttEmbSelec.cChave = string(rowid(ttResumo)) NO-ERROR.                                       

    /* Atualiza, caso o numero de embalagem for maior que zero */
    If integer(entry(1,ttEmbSelec.cNumEmbal,"/")) > 0 THEN DO:
        assign entry(1,ttEmbSelec.cNumEmbal,"/") = string(integer(entry(1,ttEmbSelec.cNumEmbal,"/")) - 1).   
    END.

    /* Zera a quantidade de itens selecionados */
    if ttEmbSelec.qtdItem <> 0 THEN DO:
        assign ttEmbSelec.qtdItem = 0.                                                                       
    END.

    /* Atualiza o codigo da emgalagem */
    assign ttEmbSelec.cNumEmbal:screen-value in frame Frame01 = string(ttEmbSelec.cNumEmbal).                

    /* Executa o evento de mudanca de tela */
    apply 'value-changed' to bSaldoItem in frame Frame01.                                                    

END PROCEDURE.


/* **************************************************************************************************** */
/* Quando as informacoes sao disponibilizadas em tela                                                   */
/* **************************************************************************************************** */
PROCEDURE pi-BrowserRowDisplayEvent:
    /* Se nao tiver informacoes, retorna */
    If not avail ttResumo Then return no-apply.                                                               

    /* Atualiza as informacoes em tela */
    assign cDispItem = "":U                                                                                   
           cDispItem = cDispItem + string(ttResumo.qtd-item) + "/" + ttResumo.cod-embalagem.                  

    /* Procura a embalagem selecinada em tela */
    find ttEmbSelec where ttEmbSelec.cChave = string(rowid(ttResumo)) no-lock no-error.                       

    /* Se nao tiver sido criado, cria como valor igual a zero */
    If not avail ttEmbSelec Then do:                                                                          
        create ttEmbSelec.                                                                                    
        assign ttEmbSelec.cChave = string(rowid(ttResumo))                                                    
               ttEmbSelec.cNumEmbal = "0/" + string(ttResumo.qti-embalagem).                                  
    End.                                                                                                      
    else DO:
        /* Atualiza o valor tem tela */
        assign ttEmbSelec.cNumEmbal:screen-value in frame Frame01 = string(ttEmbSelec.cNumEmbal).            
    END.

END PROCEDURE.

/* **************************************************************************************************** */
/* Quando as informacoes sao ocorrem alteracoes nos valores em tela                                     */
/* **************************************************************************************************** */
PROCEDURE pi-BrowserValueChangedEvent:
    /*  */
    define variable cTotItem as decimal no-undo.                                                              

    /* Procura pela embalagem selecionada */
    find ttEmbSelec where ttEmbSelec.cChave = string(rowid(ttResumo)) no-error.                               

    /*  */
    If avail ttEmbSelec Then do:                                                                              
        /*  */
        assign cNumEmbal:screen-value in frame Frame01 = ttEmbSelec.cNumEmbal.                                

        /*  */
        FOR EACH bf-ttResumo 
           WHERE bf-ttResumo.cod-item = ttResumo.cod-item 
             AND bf-ttResumo.cod-lote = ttResumo.cod-lote 
             AND bf-ttResumo.cod-refer = ttResumo.cod-refer:                                                    

            /*  */
            FIND FIRST bf-ttEmbSelec 
                 where bf-ttEmbSelec.cChave = string(rowid(bf-ttResumo)) no-lock no-error.           

            /*  */
            If avail bf-ttEmbSelec Then do:                                                                     
                /* Se a quantidade for igual a zero */
                if bf-ttEmbSelec.qtdItem = 0 THEN DO:                                                               
                    /*assign cTotItem = cTotItem + 
                        (decimal(entry(1,bf-ttEmbSelec.cNumEmbal,"/")) * bf-ttResumo.qtd-item). */
                END.
                else do: 
                    /*  */
                    assign cTotItem = cTotItem + 
                        /*((decimal(entry(1,bf-ttEmbSelec.cNumEmbal,"/")) - 1) * bf-ttResumo.qtd-item)*/ + 
                        bf-ttEmbSelec.qtdItem. 
               End. 
            End.                                                                                             
        End.                                                                                                 

        /* Atualiza a quantidade em tela */
        assign ttWork.qtd-item = ttEmbSelec.qtdItem 
               entry(1,cTotalItem,"/") = string(cTotItem).                                                    

        /* Visualiza em tela */
        disp ttWork.qtd-item with frame Frame01.                                                              
    End.                                                                                                      
    else do:                                                                                                  
        /* Adiciona valores defaults */
        assign ttEmbSelec.cNumEmbal:screen-value in frame Frame01 = "0/0".                                    
    End.                                                                                                      

    /* Visualiza em tela */
    if avail ttResumo then                                                                                    
         display cTotalItem ttResumo.cod-lote ttResumo.cod-item with frame Frame01.        

END PROCEDURE.

/* **************************************************************************************************** */
/* Quando o usuario digitar esc no browser                                                              */
/* **************************************************************************************************** */
PROCEDURE pi-BrowserEscEvent:

    /* Para cada embalagem selecionada */
    For each ttEmbSelec no-lock:                                                                             
        /* Procura as informacoes da embalagem selecionada */
        find ttResumo where rowid(ttResumo) = to-rowid(ttEmbSelec.cChave) no-lock no-error.                  

        /* Para todas as embalagens selecionadas, verifica o que foi transferido */
        Do cIndex = 1 to integer(entry(1,ttEmbSelec.cNumEmbal,"/")):                                     
            run piVerificarTransf(if ttEmbSelec.qtdItem = 0 then ttResumo.qtd-item else ttEmbSelec.qtdItem, 
                                  if ttEmbSelec.qtdItem = 0 then ttResumo.qtd-item else ttEmbSelec.qtdItem, 
                                  input 1).                                                              
        End.                                                                                             
    End.

    /* Esvazia a tabela */
    empty temp-table ttEmbSelec.                                                                             

    /* Flega para sair do campo */
    assign vLogSai = yes                                                                                     
           vLogfimTran = yes.                                                                                

END PROCEDURE.


/* fk fim */


/* mk - Busca Parametro HABILITA-UNIDADE - Inicio */
PROCEDURE pi-getLogHabilitaUn:
    DEFINE VARIABLE iNumLogHabilitaUn AS INTEGER     NO-UNDO.

    /* Busca o parametro da bc-param-ext conforme o tipo de endereco (BC9018h.i) */
    RUN pi-getValorParametro (ttWm-box-movto-idx-picking.cod-item,
                              "wmsai001",
                              "HABILITA-UNIDADE",
                              OUTPUT iNumLogHabilitaUn).

    /* Se n∆o achar o parametro, assume o valor 1 - Habilita Unidade */
    IF iNumLogHabilitaUn = 0 THEN DO:
        ASSIGN iLogHabilitaUn = NO.
    END.
    
    /* Caso o parametro seja informado incorretamente, informa ao usuario */
    IF iNumLogHabilitaUn <> 1 AND iNumLogHabilitaUn <> 2 AND iNumLogHabilitaUn <> 0  THEN DO:
        {bcp/bc9105.i "104" "Valor do parametro incorreto para o item/familia/transacao (DC)"}
        ASSIGN iLogHabilitaUn = YES.
    END.

    IF iNumLogHabilitaUn = 1 THEN
        ASSIGN iLogHabilitaUn = YES.
    IF iNumLogHabilitaUn = 2 THEN
        ASSIGN iLogHabilitaUn = NO.

    
END PROCEDURE.
/* mk - Busca Parametro HABILITA-UNIDADE - Fim */

&else 
    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif


