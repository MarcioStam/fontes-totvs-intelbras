/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9024G 2.00.00.026 } /*** 010026 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9024g MBC}
&ENDIF

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */

/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************
** Copyright DATASUL S.A. (2002)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************************
**   Programa..: bc9024.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - novembro/2002 - karla Klemke - Cria‡Æo do programa          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Invent rio WMS                   **
**                                                                                         **
********************************************************************************************/

/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName          - Nome do programa e, tambem, do Codigo da transacao do Data Collection   **
**                        que sera acionada pela interface.                                       **
** TempTable            - Nome da Temp-Table da transacao de negocio para comunicacao com ERP.    **
**                        Ex: tt-recebe-wms.                                                      **
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
**                        que executa a procedure _GenerateDCTransaction que eï responsavel por   **
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
**                        Ex: &global-define ActiveObject wgBOSC074                               **
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9024
/************************************************************/


/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-inventario-wms
{bcp/bc9024.i }


DEF VAR tempoespera AS INTEGER.
Define Temp-table ttWork NO-UNDO Like {&TempTable}.

Define Input Parameter pDesEndereco As Character Format "x(11)" No-undo.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-inventario-wms-bkp.
Define Input-output Parameter Table For ttWork.


Find First ttWork NO-ERROR.

     
DEFINE VARIABLE vSerialSeq          LIKE tt-inventario-wms-bkp.num-serial NO-UNDO.
DEFINE VARIABLE vQtdItens           AS INTEGER  Init 0   NO-UNDO.
DEFINE VARIABLE cDescriptionError   AS CHAR              NO-UNDO.
DEF TEMP-TABLE  ttWm-etiqueta-aux   NO-UNDO LIKE wm-etiqueta.
DEF VAR c-embalagem                 AS CHARACTER    NO-UNDO.
DEFINE VARIABLE l-flow-rack         AS LOGICAL     NO-UNDO.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Ser:'                   At Row 01 Col 01                          ~
                             ttWork.num-Serial        At Row 01 Col 05 No-label                 ~
                             'Legenda Serial:   '     AT ROW 02 COL 01                          ~
                             '555555 -End. Vazio'     AT ROW 03 COL 01                          ~
                             '999999 -Encerra   '     AT ROW 04 COL 01                          ~
                             'End:'                   At Row 06 Col 01                          ~
                             pDesEndereco             At Row 06 Col 05 No-label Format "x(12)"  ~
                             'Lidos:'                 At Row 07 Col 01                          ~
                             vQtdItens                At Row 07 Col 07 No-label Format '>>>>9'

&global-define Frame01Repeat Yes

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.num-Serial
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. If vLogSai = Yes Then do: ~
                                                               LEAVE _frame01. ~
                                                            END.

/* definicao da trigger de procedimentos para fechamento do programa */
&global-define TriggersCloseProgram Run destroy In wgbosc120 No-error. ~
                                    Run destroy In wgbc9024j No-error. ~
                                    Run destroy In wgbosc074 No-error. ~
                                    Run destroy In wgbosc130 No-error.


/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc120
&global-define ActiveObject1 wgbosc130
&global-define ActiveObject2 wgbc9024j
&global-define ActiveObject3 wgbosc074   /* wg originado pelo bc9024j */


DEF VAR c-cod-barras    AS CHAR FORMAT "X(16)"  NO-UNDO.

DEFINE FRAME fEAN
    'Inventario          '  AT ROW 1 COL 1
    '--------------------'  AT ROW 2 COL 1
    'EAN/DUN:            '  AT ROW 3 COL 1 
    c-cod-barras            AT ROW 4 COL 1 NO-LABEL
    WITH 1 DOWN FONT 3 SIZE 20 BY 8 NO-BOX.
/************************************************************/

/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
 {bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
 {bcp/bc9101.i} /* Procedure de atualizacao da transacao            */
 
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 2
&global-define MessageBell YES
/****************************************************************************************/

/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ‚ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame01:
    Assign vLogErro = No vLogSai = No vLogFinaliza = No.
    DEFINE VARIABLE l-ok AS LOGICAL     NO-UNDO.
    
    Assign ttWork.num-serial           = 0
           ttWork.cod-lote             = ''
           ttWork.cod-refer            = ''
           ttWork.cod-item             = ''
           ttWork.cod-embalagem        = ''
           ttWork.qtd-item             = 0
           ttWork.qtd-peso             = 0
           ttWork.dat-validade         = TODAY
           ttWork.ind-transacao        = 2
           l-flow-rack                 = NO.


    FIND LAST tt-inventario-wms-bkp USE-INDEX id-seq NO-LOCK NO-ERROR.

    IF AVAILABLE tt-inventario-wms-bkp THEN ASSIGN vQtdItens = tt-inventario-wms-bkp.num-sequencia.

/* flow rack inicio */
    FOR FIRST wm-box NO-LOCK
        WHERE wm-box.cod-estabel = ttWork.cod-estabel
          AND wm-box.cod-local   = ttWork.cod-local
          AND wm-box.id-box      = ttWork.num-box:
    END.

    FOR FIRST zona-separa-box NO-LOCK
        WHERE zona-separa-box.cod-estabel = wm-box.cod-estabel
          AND zona-separa-box.cod-local   = wm-box.cod-local
          AND zona-separa-box.id-box      = wm-box.id-box:
    END.

    IF AVAIL zona-separa-box THEN DO:  /* flow rack nao tem etiqueta fisica e deve assumir o que esta no endereco */
    
        IF NOT CAN-FIND(FIRST tt-inventario-wms-bkp  /* so lˆ um item no endere‡o Flow Rack */
                        WHERE tt-inventario-wms-bkp.cod-estabel    = ttWork.cod-estabel      AND
                              tt-inventario-wms-bkp.cod-local      = ttWork.cod-local        AND
                              tt-inventario-wms-bkp.dat-inventario = ttWork.dat-inventario   AND
                              tt-inventario-wms-bkp.num-contagem   = ttWork.num-contagem     AND
                              tt-inventario-wms-bkp.num-seq-invent = ttWork.num-seq-invent   AND
                              tt-inventario-wms-bkp.num-box        = ttWork.num-box          AND
                              tt-inventario-wms-bkp.qtd-item       <> 0                      NO-LOCK) THEN DO:

            RUN bcp/bc9024gfr.p (INPUT TABLE ttWork,
                                 OUTPUT ttWork.num-serial,
                                 OUTPUT l-ok).
        END.
        ASSIGN l-flow-rack = YES.
/*
        IF NOT l-ok THEN DO:
            ASSIGN vLogSai = YES. /* falhou valida‡Æo de pe‡a e retorna */
        END.
        */
    END.
/* flow rack fim */

    DISP ttWork.num-serial 
         pDesEndereco
         vQtdItens    With Frame frame01.

End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:
    ASSIGN vLogErro     = NO
           vLogsai      = NO
           vLogfinaliza = NO.

    /**************************************************************
    **  ind-transacao:
    **     1 = Item sem validar quantidade
    **     2 = Item com quantidade
    **     3 = Erro
    **     4 = Item sem etiqueta com quantidade
    **     
    **     9 = Finaliza
    **
    ***************************************************************/
    Assign vLogErro = No vLogSai = No vLogFinaliza = No.
    
    If  ttWork.num-serial = 0 Then Do:
        Hide ALL.
        Pause 0 No-message.
        Hide Frame frame01.
        Pause 0 No-message.
        Assign vLogErro = Yes.
        {bcp/bc9105.i "101" "Serial Inv lido (DC)"}
        View Frame {&Frame01Name}.
        Pause 0 No-message.
        Return Error.
    End.

    If  ttWork.num-serial = 999999 Then Do:
       /* FO 1651111 inicio */
       IF NOT CAN-FIND(FIRST tt-inventario-wms-bkp WHERE 
                        tt-inventario-wms-bkp.cod-estabel    = ttWork.cod-estabel      AND
                        tt-inventario-wms-bkp.cod-local      = ttWork.cod-local        AND
                        tt-inventario-wms-bkp.dat-inventario = ttWork.dat-inventario   AND
                        tt-inventario-wms-bkp.num-contagem   = ttWork.num-contagem     AND
                        tt-inventario-wms-bkp.num-seq-invent = ttWork.num-seq-invent   AND
                        tt-inventario-wms-bkp.num-box        = ttWork.num-box          AND
                        tt-inventario-wms-bkp.qtd-item       <> 0                      NO-LOCK) THEN DO:
            {bcp/bc9105.i "300" "NÆo pode ser encerrado um endere‡o sem leituras (WMS)"} 
            Assign vLogErro = Yes.                                                                                   
            Return Error.
        END.
        /* FO 1651111 fim */

        Hide All.
        Pause 0 No-message.
        Hide Frame frame01.
        Pause 0 No-message.

        Assign vLogOk = Yes.
        
        /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
        DEFINE VARIABLE c-lbl-liter-inventario-wms AS CHARACTER FORMAT "X(16)" NO-UNDO.
        {utp/ut-liter.i "Invent rio_WMS" *}
        ASSIGN c-lbl-liter-inventario-wms = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-encerra-inventario AS CHARACTER FORMAT "X(20)" NO-UNDO.
        {utp/ut-liter.i "Encerra_Invent rio" *}
        ASSIGN c-lbl-liter-encerra-inventario = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-do-box AS CHARACTER FORMAT "X(9)" NO-UNDO.
        {utp/ut-liter.i "do_Box?" *}
        ASSIGN c-lbl-liter-do-box = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-1sim-2nao AS CHARACTER FORMAT "X(13)" NO-UNDO.
        {utp/ut-liter.i "1=Sim_2=NÆo" *}
        ASSIGN c-lbl-liter-1sim-2nao = TRIM(RETURN-VALUE).
        Disp 
             c-lbl-liter-inventario-wms       At Row 01 Col 01 NO-LABEL
             '------------------'             At Row 02 Col 01 
             c-lbl-liter-encerra-inventario   At Row 03 Col 01 NO-LABEL
             c-lbl-liter-do-box               At Row 04 Col 01 NO-LABEL
             c-lbl-liter-1sim-2nao            At Row 05 Col 01 NO-LABEL With Frame f-conf-1 Font 2 Size 20 By 8 No-box.
        Pause 0 No-message.
        Update vLogOk At Row 05 Col 14 No-label Format '1/2' With Frame f-conf-1 Font 2 Size 20 By 8.
        
        Hide All.
        Pause 0 No-message.

        
        If Not vLogOk Then Do:
            Assign vLogErro = Yes.
            Return Error.
        End.
        Assign ttWork.ind-transacao = 9.
        Run GravaTransacao.
        Assign vLogSai = Yes
               vLogFinaliza = Yes.
        Return.
    End.

    If  ttWork.num-serial = 555555 Then Do:
        IF ttWork.log-existe-end = NO THEN DO: /* regra definida em 13/02/03 por Log¡stica: Se est  informando um endere‡o fora do invent rio, nÆo dever  deixar informar que est  vazio. */
            {bcp/bc9105.i "300" "NÆo poder  ser informado Box Vazio para endere‡o nÆo gerado pelo invent rio (WMS)"}
            Assign vLogErro = Yes.
            Return Error.
        END.

        Hide All.
        Pause 0 No-message.
        Hide Frame frame01.
        Pause 0 No-message.
       
        Assign vLogOk = Yes.
        
        /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
        DEFINE VARIABLE c-lbl-liter-inventario-wms-2 AS CHARACTER FORMAT "X(16)" NO-UNDO.
        {utp/ut-liter.i "Invent rio_WMS" *}
        ASSIGN c-lbl-liter-inventario-wms-2 = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-confirma-box AS CHARACTER FORMAT "X(14)" NO-UNDO.
        {utp/ut-liter.i "Confirma_Box" *}
        ASSIGN c-lbl-liter-confirma-box = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-vazio AS CHARACTER FORMAT "X(9)" NO-UNDO.
        {utp/ut-liter.i "Vazio_?" *}
        ASSIGN c-lbl-liter-vazio = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-1sim-2nao-2 AS CHARACTER FORMAT "X(13)" NO-UNDO.
        {utp/ut-liter.i "1=Sim_2=NÆo" *}
        ASSIGN c-lbl-liter-1sim-2nao-2 = TRIM(RETURN-VALUE).
        Disp c-lbl-liter-inventario-wms-2   At Row 01 Col 01 NO-LABEL
             '------------------'           At Row 02 Col 01 
             c-lbl-liter-confirma-box       At Row 03 Col 01 NO-LABEL
             c-lbl-liter-vazio              At Row 04 Col 01 NO-LABEL
             c-lbl-liter-1sim-2nao-2        At Row 05 Col 01 NO-LABEL With Frame f-conf Font 2 Size 20 By 8 No-box.
        Pause 0 No-message.
        Update vLogOk At Row 05 Col 14 No-label Format '1/2':U With Frame f-conf Font 2 Size 20 By 8.
        
        Hide All.
        Pause 0 No-message.
        
        
        If Not vLogOk Then Do:
            Assign vLogErro = Yes.
            Return Error.
        End.
        Assign ttWork.ind-transacao = 6.
        Run GravaTransacao.
        Assign vLogSai = Yes
               vLogFinaliza = Yes.
        Return.
    End.
    
    IF NOT VALID-HANDLE(wgbosc120)  THEN DO:
       Run scbo/bosc120.p Persistent Set wgbosc120.
    END.

    /* FO 1651111 inicio */
    IF NOT VALID-HANDLE(wgbosc074) THEN 
         Run scbo/bosc074.p Persistent Set wgbosc074.

    Run validaEtiqueta In wgbosc074 (Input ttWork.num-serial,
                                     INPUT 2) No-error.
    If  Return-value <> 'OK':U Then Do:
        Run emptyRowErrors in wgbosc074.   
        Run validaEtiqueta In wgbosc074 (Input ttWork.num-serial,
                                         INPUT 3) No-error.

        If  Return-value <> 'OK':U Then Do:
            Run emptyRowErrors in wgbosc074.   
            Run validaEtiqueta In wgbosc074 (Input ttWork.num-serial,
                                             INPUT 1) No-error.

            IF RETURN-VALUE = 'OK':U THEN DO:
                RUN getInfoEtiqueta IN wgbosc074 (INPUT  ttWork.num-serial,
                                                  OUTPUT TABLE ttWm-etiqueta-aux).

                FIND FIRST ttWm-etiqueta-aux NO-LOCK NO-ERROR.
                IF NOT AVAIL ttWm-etiqueta-aux THEN DO:
                    ASSIGN cDescriptionError = "Agrupador Inexistente para Etiqueta Filha " + STRING(ttWork.num-serial) + "(WMS)":U.
                    Run bcp/bc9115.p (90001, cDescriptionError,8,20,3).    
                    Assign vLogErro = Yes.
                    Return Error.                
                END.
                ELSE DO:
                    FIND FIRST tt-inventario-wms-bkp WHERE 
                        tt-inventario-wms-bkp.num-serial = ttWm-etiqueta-aux.id-agrupador NO-LOCK NO-ERROR.
                    IF NOT AVAIL tt-inventario-wms-bkp THEN DO:
                        ASSIGN cDescriptionError = "Etiqueta Agrupadora deve ser lido antes da Etiqueta NÆo Agrupadora " + STRING(ttWork.num-serial) + "(WMS)":U.
                        Run bcp/bc9115.p (90001, cDescriptionError,8,20,3).    
                        Assign vLogErro = Yes.
                        Return Error.                
                    END.
                END.
            END.
        END.
    End. /* Return-value <> 'OK' */
    /* FO 1651111 fim */

    IF VALID-HANDLE(wgbosc074) THEN RUN destroy IN wgbosc074.

    Run emptyRowErrors In wgbosc120.
    Run validaEtiquetaInventario In wgbosc120(input  ttWork.cod-estabel,
                                              input  ttWork.cod-local,
                                              input  ttWork.dat-inventario,
                                              input  ttWork.num-seq-invent,
                                              input  ttWork.num-box,
                                              input  ttWork.num-contagem,
                                              input  ttWork.num-serial, 
                                              Output ttWork.cod-item,   
                                              Output ttWork.cod-refer,
                                              Output ttWork.cod-lote,
                                              OUTPUT ttWork.cod-embalagem,
                                              Output ttWork.dat-validade,                                        
                                              Output ttWork.qtd-item,
                                              Output ttWork.ind-transacao).
    If ttWork.ind-transacao = 3 Then Do ON ENDKEY UNDO,RETRY:
        Run getRowErrors In wgbosc120(Output Table RowErrors).
        For Each RowErrors:
            Assign vLogErro = Yes.
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
        End.
        IF vLogErro = YES THEN RETURN Error.
    END.
    If ttWork.ind-transacao = 4 Then Do:
        /* serial inv lido, ser  solicitado item */
        {bcp/bc9105.i "101" "Serial Inv lido (DC)"}
        RETURN Error.
    END.

    IF NOT VALID-HANDLE(wgbosc130)  THEN DO:
       Run scbo/bosc130.p Persistent Set wgbosc130.
    END.
    RUN emptyRowErrors    IN wgbosc130.
    RUN validaItemPickingInvent IN wgbosc130 (INPUT ttWork.cod-estabel,
                                              INPUT ttWork.cod-local,
                                              INPUT ttWork.cod-item,
                                              INPUT ttWork.cod-refer,
                                              INPUT ttWork.num-box).
    IF RETURN-VALUE = "NOK":U THEN DO:
        Run getRowErrors In wgbosc130(Output Table RowErrors).
        For Each RowErrors:
            Assign vLogErro = Yes.
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
        End.
        IF vLogErro = YES THEN RETURN Error.
    END.

    
    /* valida‡Æo ref serial, se o mesmo ja foi lido ou nÆo  */

    If ttWork.ind-transacao = 1 Then Do:
        Hide All.
        Pause 0 No-message.
        Hide Frame frame01.
        Pause 0 No-message.

        Run getRowErrors In wgbosc120(Output Table RowErrors).

        Assign vLogOk = Yes.

        For Each RowErrors:
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
            /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
            DEFINE VARIABLE c-lbl-liter-confirma-leitura AS CHARACTER FORMAT "X(19)" NO-UNDO.
            {utp/ut-liter.i "Confirma_Leitura?" *}
            ASSIGN c-lbl-liter-confirma-leitura = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-1sim-2nao-3 AS CHARACTER FORMAT "X(13)" NO-UNDO.
            {utp/ut-liter.i "1=Sim_2=NÆo" *}
            ASSIGN c-lbl-liter-1sim-2nao-3 = TRIM(RETURN-VALUE).
            Disp c-lbl-liter-confirma-leitura    At Row 01 Col 01 NO-LABEL   
                 c-lbl-liter-1sim-2nao-3         At Row 02 Col 01 NO-LABEL With Frame f-conf-2 Font 2 Size 20 By 8 No-box.
            Pause 0 No-message.
            Update vLogOk At Row 02 Col 13 No-label Format '1/2' With Frame f-conf-2 Font 2 Size 20 By 8.
        End.
       
        Hide All.
        Pause 0 No-message.

        View Frame frame01.
        Pause 0 No-message.

        If Not vLogOk Then Do:
            Assign vLogErro = Yes.
            Return Error.
        End.
    End.

    If ttWork.ind-transacao = 5 Then Do:
        /* pallet fechado */
        Hide All.
        Pause 0 No-message. 
        Hide Frame frame01.
        Pause 0 No-message.
        Run GravaTransacao.
        Return.
    End.

    If  (ttWork.ind-transacao = 2 
    Or  ttWork.ind-transacao = 4) 
    AND ttWork.ind-tipo-contr-est <> 2 THEN DO:

        Hide All No-pause.

        IF NOT l-flow-rack THEN DO:  /* validacoes ja feitas no bc9024gfr quando flow-rack */
            UPDATE c-cod-barras WITH FRAME fEan.
            IF NOT CAN-FIND(FIRST wm-item WHERE
                            wm-item.cod-item   = ttWork.cod-item               AND
                            wm-item.cod-barras = INPUT FRAME fEan c-cod-barras NO-LOCK) THEN DO:
                IF NOT CAN-FIND(FIRST wm-item-embalagem-etiq WHERE
                                wm-item-embalagem-etiq.cod-item   = ttWork.cod-item               AND
                                wm-item-embalagem-etiq.cod-barras = INPUT FRAME fEan c-cod-barras NO-LOCK) AND 
                   ttWork.cod-item <> INPUT FRAME fEan c-cod-barras THEN DO:
                    Assign vLogErro = Yes.
                    {bcp/bc9105.i "600" "Codigo de barras nao pertence ao item da etiqueta (WMS)"}
                    IF vLogErro = YES THEN RETURN Error.
                END.
            END.
            /* Sem C¢digo de Barras */
            IF INPUT FRAME fEan c-cod-barras = "" AND
               (CAN-FIND(FIRST wm-item WHERE
                            wm-item.cod-item   = ttWork.cod-item  AND
                            wm-item.cod-barras <> INPUT FRAME fEan c-cod-barras        NO-LOCK) OR 
                CAN-FIND(FIRST wm-item-embalagem-etiq WHERE
                                wm-item-embalagem-etiq.cod-item   =  ttWork.cod-item  AND
                                wm-item-embalagem-etiq.cod-barras <> INPUT FRAME fEan c-cod-barras        NO-LOCK)) THEN DO:
                Assign vLogErro = Yes.
                    {bcp/bc9105.i "601" "Codigo de barras deve ser informado (WMS)"}
                    IF vLogErro = YES THEN RETURN Error.
            END.
        END.

        Hide All No-pause.
        /* pede quantidade e peso */
        Run bcp/bc9024i.p (input pDesEndereco, Input vQtdItens, input-output Table ttWork) .
        Hide All No-pause.
        
        Find First ttWork NO-ERROR.                             

        If Return-value <> 'OK':U Then Do:
           Assign vLogErro = Yes.
           Return Error.
        End.

    End.
    RUN GravaTransacao.
    RETURN RETURN-VALUE.
       
End Procedure.
/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaTransacao:
    
    IF NOT VALID-HANDLE(wgbc9024j)  THEN DO:
       Run bcp/bc9024j.p Persistent Set wgbc9024j.
    END.
    
    /* valida se o serial j  encontra-se lido */
    RUN pi-valida-serial IN wgbc9024j (INPUT ttWork.num-box,
                                       INPUT ttWork.num-serial,
                                       INPUT ttWork.cod-item,
                                       INPUT ttWork.cod-refer, 
                                       INPUT ttWork.cod-lote,
                                       INPUT ttWork.cod-embalagem,
                                       INPUT TABLE tt-inventario-wms-bkp).
    IF RETURN-VALUE <> 'OK':U THEN DO: 
        Assign vLogerro = Yes.
        {bcp/bc9105.i "110" "Item/Serial j  coletado (DC)"}
        RETURN 'NOK':U.
    END.

    FOR EACH tt-trans:
        DELETE tt-trans.
    END.       
    FOR EACH tt-trans-filho:
        DELETE tt-trans-filho.
    END.

    CREATE tt-trans.

    ASSIGN tt-trans.cod-versao-integracao = 1
           tt-trans.i-sequen = 1
           tt-trans.cd-trans = 'WMOut003':U
           tt-trans.detalhe = 'Usr:':U + ttWork.cod-usuario                 + ';':U +
                              'Est:':U + ttWork.cod-estabel                 + ';':U +
                              'Loc:':U + ttWork.cod-local                   + ';':U +
                              'DtI:':U  + string(ttWork.dat-inventario)     + ';':U +
                              'Con:':U  + string(ttWork.num-contagem,'>9':U) + ';':U +
                              'Box:':U + string(ttWork.num-box,'>>>>>>>>>9':U)  
           tt-trans.usuario = v_cod_usuar_corren.
           tt-trans.etiqueta = NO.
    CREATE tt-trans-filho.
    ASSIGN tt-trans-filho.i-sequen-pai = 1
           TT-trans-filho.i-sequen     = 1    
           TT-trans-filho.num-versao   = 1
           TT-trans-filho.conteudo-xml = 'Seq:':U + string(ttWork.num-seq-invent,'>>>>>9':U)     + ';':U +
                                         'Box:':U + string(ttWork.num-box,'>>>>>>>>>9':U)        + ';':U +
                                         'Log:':U + string(ttWork.log-existe-end)                + ';':U +
                                         'Ser:':U + string(ttWork.num-serial,'>>>>>>>>>>>>>>':U) + ';':U +
                                         'Qtd:':U + string(ttWork.qtd-item,'>>>,>>>,>>9.9999':U) + ';':U +
                                         'Ite:':U + string(ttWork.cod-item)                      + ';':U +
                                         'Lot:':U + string(ttWork.cod-lote)                      + ';':U +
                                         'Ref:':U + string(ttWork.cod-Refer)                     + ';':U +
                                         'Emb:':U + string(ttWork.cod-embalagem)                 + ';':U .

     IF ttWork.dat-validade = ? THEN ASSIGN tt-trans-filho.conteudo-xml = tt-trans-filho.conteudo-xml + 'DtV:':U + '?':U + ';':U. 
     ELSE ASSIGN tt-trans-filho.conteudo-xml = tt-trans-filho.conteudo-xml + 'DtV:':U + string(ttWork.dat-validade)  + ';':U.

     ASSIGN tt-trans-filho.conteudo-xml = tt-trans-filho.conteudo-xml +
                                         'Pes:':U + string(ttWork.qtd-peso,'>>>,>>>,>>9.9999':U)       + ';':U +
                                         'QtC:':U + STRING(ttWork.qtd-caixas,'>>>>>9.999':U )          + ';':U +
                                         'Ind:':U + string(ttWork.ind-transacao,'99':U).

     IF NOT VALID-HANDLE(wgbcapi001) THEN DO:
         run bcp/bcapi001.p persistent set wgbcapi001 (input-output table tt-trans,
                                                       input-output table tt-erro).
     END.

     RUN cria_reg_wms  in wgbcapi001 (INPUT 4,INPUT-OUTPUT TABLE tt-trans, INPUT-OUTPUT TABLE tt-trans-filho,INPUT-OUTPUT TABLE tt-erro).
     /* 4 = Estado da Transacao = Em Processo */

     find first tt-erro no-error.     
     if  avail tt-erro THEN DO: 
        FOR EACH tt-erro:
            ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
            {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
        END.
        Assign vLogerro = Yes.
        RETURN 'NOK':U.
     END.
     ELSE DO:
         Assign ttWork.log-existe-end = Yes.
         /* criar regitro na tt-inventario-wms-bkp utilizada p valida‡Æo */
         FIND FIRST tt-trans NO-LOCK NO-ERROR.
         CREATE tt-inventario-wms-bkp.
         ASSIGN tt-inventario-wms-bkp.cod-usuario    = ttWork.cod-usuario
                tt-inventario-wms-bkp.cod-estabel    = ttWork.cod-estabel
                tt-inventario-wms-bkp.cod-local      = ttWork.cod-local
                tt-inventario-wms-bkp.dat-inventario = ttWork.dat-inventario
                tt-inventario-wms-bkp.num-contagem   = ttWork.num-contagem
                tt-inventario-wms-bkp.num-seq-invent = ttWork.num-seq-invent
                tt-inventario-wms-bkp.num-box        = ttWork.num-box
                tt-inventario-wms-bkp.log-existe-end = ttWork.log-existe-end
                tt-inventario-wms-bkp.num-serial     = ttWork.num-serial
                tt-inventario-wms-bkp.qtd-item       = ttWork.qtd-item
                tt-inventario-wms-bkp.cod-item       = ttWork.cod-item
                tt-inventario-wms-bkp.cod-lote       = ttWork.cod-lote
                tt-inventario-wms-bkp.cod-embalagem  = ttWork.cod-embalagem
                tt-inventario-wms-bkp.cod-refer      = ttWork.cod-refer
                tt-inventario-wms-bkp.dat-validade   = ttWork.dat-validade
                tt-inventario-wms-bkp.qtd-peso       = ttWork.qtd-peso
                tt-inventario-wms-bkp.qtd-caixas     = ttWork.qtd-caixas
                tt-inventario-wms-bkp.ind-transacao  = ttWork.ind-transacao
                tt-inventario-wms-bkp.num-sequencia  = vQtdItens + 1
                tt-inventario-wms-bkp.nr-trans       = tt-trans.nr-trans.

         ASSIGN vSerialSeq = tt-inventario-wms-bkp.num-serial.

         IF ttWork.num-serial = 999999 OR
            ttWork.num-serial = 555555 THEN do:  /* Incluido por Amarildo - Ref FO 1.360.464 */
            /* passa bc-trans.estado para 01 */
            RUN finaliza-inventario in wgbc9024j (INPUT TABLE tt-trans, OUTPUT TABLE tt-erro).
            find first tt-erro no-error.
            if  avail tt-erro THEN DO: 
                FOR EACH tt-erro:
                    ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
                    {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
                END.
                Assign vLogerro = Yes.
                RETURN 'NOK':U.
            END.
            /* prepara para efetiva‡Æo */
            RUN inventario-pre-api-wms in wgbc9024j (INPUT-OUTPUT TABLE tt-trans, INPUT-OUTPUT TABLE tt-erro).
            find first tt-erro no-error.
            if  avail tt-erro THEN DO: 
                FOR EACH tt-erro:
                    ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
                    {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
                END.
                Assign vLogerro = Yes.
                RETURN 'NOK':U.
            END.
         END.
         IF ttWork.ind-transacao = 6 /* solicitado box vazio */ Then Do:
            Hide All No-pause.
            {bcp/bc9105.i "903" "Box Encerrado (WMS)"} 
            Assign vQtdItens = vQtdItens + 1.
         End.
         Else Do:
            If ttWork.ind-transacao = 9 THEN DO:
                Hide All No-pause.
               {bcp/bc9105.i "904" "Contagem Encerrada (WMS)"}
            END.
            ELSE DO:
                Hide All No-pause.
               {bcp/bc9105.i "902" "Item/Serial Confirmado (WMS)"}
               Assign vQtdItens = vQtdItens + 1.
            END.
         End.
     End.   

     Hide All No-pause.
     Return Return-value.
    
End Procedure.

/*************************************  Codigo do Usuario Fim   **********************************/

