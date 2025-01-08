/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9024I 2.00.00.012 } /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9024i MBC}
&ENDIF

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
**   Programa..: bc9024i.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - novembro/2002 - karla Klemke - Criação do programa          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Inventário WMS                   **
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
**                        que executa a procedure _GenerateDCTransaction que e´ responsavel por   **
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
{bcp/bc9024.i}
{bcp/bc9018h.i}

Define Temp-table ttWork NO-UNDO Like {&TempTable}.

Define Input Parameter pDesEndereco As Character Format "x(11)" No-undo.
Define Input Parameter vQtdItems    As Integer                  No-undo.
Define Input-output Parameter Table For ttWork.

define variable wgbosc145 as widget-handle no-undo.

Find First ttWork NO-ERROR.

DEFINE VARIABLE iIndTipoLeitura        AS INTEGER       NO-UNDO.
DEFINE VARIABLE iIndTipoLeituraUnidade AS INTEGER       NO-UNDO.
DEFINE VARIABLE qtdPesoItem            AS DECIMAL       NO-UNDO.
DEFINE VARIABLE qtdPesoEmbal           AS DECIMAL       NO-UNDO.
DEFINE VARIABLE d-qtd-peso             AS DECIMAL       NO-UNDO.
DEFINE VARIABLE vQtdItemEmbal          AS DECIMAL       NO-UNDO.
DEFINE VARIABLE pQtdItem               AS DECIMAL       NO-UNDO.
DEFINE VARIABLE vLogPadrao             AS LOGICAL       NO-UNDO.
DEFINE VARIABLE l-voltar               AS LOGICAL       NO-UNDO.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/

/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Item:              '     At Row 01 Col 01                         ~
                             ttWork.cod-item           At Row 02 Col 01 No-label                ~
                             'Quantidade:        '     At Row 03 Col 01                         ~
                             ttWork.qtd-item           At Row 04 Col 01 No-label                ~
                             'Peso:              '     At Row 05 Col 01                         ~
                             ttWork.qtd-peso           AT ROW 06 COL 01 NO-LABEL                ~
                             'Lidos:'                  At Row 08 Col 01                         ~
                             vQtdItems                 At Row 08 Col 07 No-label Format   '>>>>9':U
&global-define Frame01Repeat No

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'It:                '     At Row 01 Col 01                         ~
                             ttWork.cod-item           At Row 01 Col 04 No-label FORMAT 'x(15)' ~
                             'Embalagens:        '     At Row 02 Col 01                         ~
                             ttWork.num-livre-1        At Row 03 Col 01 NO-LABEL FORMAT '>>>>9':U ~
                             'Unidades:          '     At Row 04 Col 01                         ~
                             ttWork.num-livre-2        At Row 05 Col 01 No-label FORMAT '>>>>9':U ~
                             'Peso:              '     At Row 06 Col 01                         ~
                             ttWork.qtd-peso           AT ROW 07 COL 01 NO-LABEL                ~
                             'Lidos:'                  At Row 08 Col 01                         ~
                             vQtdItems                 At Row 08 Col 07 No-label Format '>>>>9':U
&global-define Frame02Repeat No

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name Frame03
&global-define Frame03Defs    'Inventario WMS     '                             At Row 01 Col 01~
                              'Tipo leitura?      '                             At Row 02 Col 01~
                              '2 - Por Quantidade '                             At Row 03 Col 01~
                              '4 - Por Emb/Un     '                             AT ROW 04 COL 01~
                              'Opcao              '                             At Row 08 Col 01~
                              iIndTipoLeitura                                   At Row 08 Col 14 No-label Format '9'~
&global-define Frame03Repeat No

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.qtd-item ttWork.qtd-peso
                                  
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 IF l-voltar = YES THEN do: Return 'NOK':U. END. Run InicializaCamposFrame01. if vLogSai or vLogFinaliza then return "ok".
&global-define TriggerBeforeFrame02 IF l-voltar = YES THEN Return 'NOK':U.
&global-define TriggerAfterFrame01  IF l-voltar = YES THEN Return 'NOK':U. If vLogSai = Yes Then Return 'OK':U.
&global-define TriggerAfterFrame02  IF l-voltar = YES THEN DO: /*LEAVE _frame02.*/ Return 'NOK':U. END.

/* Definicao das trigger de usuario ---                     */ 

&global-define UserTriggers ON 'leave':U OF ttWork.qtd-item IN Frame Frame01 ~
                            DO:                         ~
                                assign input frame Frame01 ttWork.qtd-item. ~
                                RUN piCalcularPeso (INPUT ttWork.qtd-item). ~
                                DISPLAY d-qtd-peso @ ttWork.qtd-peso with frame frame01. ~
                            END.                        ~
                            ON 'ESC':U OF Frame Frame01 ~
                            DO:                         ~
                                /*Return 'ESC':U.*/         ~
                                ASSIGN l-voltar = YES.  ~
                            END.                        ~
                            ON 'ESC':U OF Frame Frame02 ~
                            DO:                         ~
                                ASSIGN l-voltar = YES.  ~
                            END.                        ~
                            ON 'ESC':U OF Frame Frame03 ~
                            DO:                         ~
                                ASSIGN l-voltar = YES.  ~
                            END.                        ~
                            ON 'F4':U OF Frame Frame01 ~
                            DO:                         ~
                                /*Return 'ESC':U.*/         ~
                                ASSIGN l-voltar = YES.  ~
                            END.                        ~
                            ON 'F4':U OF Frame Frame02 ~
                            DO:                         ~
                                ASSIGN l-voltar = YES.  ~
                            END.                        ~
                            ON 'F4':U OF Frame Frame03 ~
                            DO:                         ~
                                ASSIGN l-voltar = YES.  ~
                            END.                        ~
/************************************************************/

/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao e´ necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local é destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure e´ executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame01:
     Assign vLogErro = No vLogSai = No vLogFinaliza = No.     

     ASSIGN ttWork.qtd-item = 0.

     Disp 
         ttWork.cod-item 
         ttWork.qtd-item
         ttWork.qtd-peso
         vQtdItems  With Frame frame01.

     If not valid-handle(wgbosc145) Then 
        run scbo/bosc145.p persistent set wgbosc145.

    run setConstraintItem in wgbosc145 (ttWork.cod-item).
    run openQueryStatic in wgbosc145 (input "item":U).
    If  Return-value <> 'OK':U Then Do:
        run piEliminaHandles.
        {bcp/bc9105.i "103" "Item sem embalagem relacionada. (WMS)"}
        Assign vLogErro = Yes.
        Return Error.
    End.

     RUN pi-getIndTipoLeitura IN THIS-PROCEDURE.
     IF  RETURN-VALUE = 'NOK' THEN DO:
         Assign vLogSai = Yes
                vLogFinaliza = Yes.
         Hide All No-pause.
         Return Error.
     END.

     IF iIndTipoLeitura = 2 THEN DO: /* por Quantidade */
        /*DO ON ENDKEY UNDO, RETURN "ESC":*/
           UPDATE ttWork.qtd-item ttWork.qtd-peso WITH FRAME frame01.
        /*END.*/
        Assign vLogErro = No vLogSai = No vLogFinaliza = No.

        If  ttWork.qtd-Item = 0 Then Do:
            Hide All.
            Assign vLogErro = Yes.
            {bcp/bc9105.i "105" "Quantidade Inv lida (DC)"}
            View Frame {&Frame01Name}.
            Pause 0 No-message.
            Hide All No-pause.
            Return Error.
        End.

        If  ttWork.qtd-peso = 0 Then Do:
            Hide All.
            Assign vLogErro = Yes.
            {bcp/bc9105.i "105" "Peso Inv lido (DC)"}
            View Frame {&Frame01Name}.
            Pause 0 No-message.
            Hide All No-pause.
            Return Error.
        End.

        If  ttWork.qtd-peso = 0 Then Do:
            Hide All.
            Assign vLogErro = Yes.
            {bcp/bc9105.i "105" "Peso Inv lido (DC)"}
            View Frame {&Frame01Name}.
            Pause 0 No-message.
            Hide All No-pause.
        END.

        if  not vLogErro then do:
            assign vLogSai      = yes
                   vLogFinaliza = yes.
            hide all no-pause.
        end.
     END. /**********************************  end tipo leitura 2*/
     ELSE DO: /* por Embalagem/Unidade */
         RUN pi-getValorParametro (ttWork.cod-item,
                                   "WmOut003",
                                  ("HABILITA-UNIDADE"),
                                   OUTPUT iIndTipoLeituraUnidade).

         IF  ttWork.num-serial <> 0 THEN DO:

             FIND wm-etiqueta
                 WHERE wm-etiqueta.id-etiqueta = ttWork.num-serial NO-LOCK NO-ERROR.
             
             RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWork.cod-estabel,
                                                   INPUT ttWork.cod-local,
                                                   INPUT ttWork.cod-item,
                                                   INPUT wm-etiqueta.cod-embalagem,
                                                   INPUT ttWork.qtd-Item,
                                                   OUTPUT ttWork.num-livre-1,
                                                   OUTPUT ttWork.num-livre-2).
         END.

         IF iIndTipoLeituraUnidade = 1 THEN DO:
             HIDE ALL NO-PAUSE.
             DISP ttWork.cod-item WITH FRAME frame02.
            /* ASSIGN ttWork.num-livre-1 = 0
                    ttWork.num-livre-2 = 0.*/
             /*DO ON ENDKEY UNDO, RETURN "ESC":*/
                UPDATE ttWork.num-livre-1 ttWork.num-livre-2 WITH FRAME frame02.
             /*END.*/
         END.
         ELSE DO:
             HIDE ALL NO-PAUSE.
             DISP ttWork.cod-item WITH FRAME frame02.
             /*ASSIGN ttWork.num-livre-1 = 0
                    ttWork.num-livre-2 = 0. */
             /*DO ON ENDKEY UNDO, RETURN "ESC":*/
                UPDATE ttWork.num-livre-1 WITH FRAME frame02.
             /*END.*/
         END.

         Assign vLogErro = No vLogSai = No vLogFinaliza = No.

         IF  ttWork.num-serial <> 0 THEN DO:
             FIND wm-etiqueta
                 WHERE wm-etiqueta.id-etiqueta = ttWork.num-serial NO-LOCK NO-ERROR.
             RUN emptyRowErrors In wgbosc145.
             RUN piConverteCaixaQtde IN wgbosc145 (INPUT ttWork.cod-estabel,
                                                   INPUT ttWork.cod-local,
                                                   INPUT ttWork.cod-item,
                                                   INPUT wm-etiqueta.cod-embalagem,
                                                   INPUT ttWork.num-livre-1,
                                                   INPUT ttWork.num-livre-2,
                                                   OUTPUT pQtdItem).
             IF  RETURN-VALUE = 'NOK' THEN DO:
                 RUN getRowErrors In wgbosc145(OUTPUT TABLE RowErrors).
                 FOR EACH RowErrors:
                     ASSIGN vLogErro = YES.
                     ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                     {bcp/bc9015.i2 STRING(ErrorNumber) string(ErrorDescription)}
                 END.
                 IF vLogErro = YES THEN DO :
                     run piEliminaHandles.
                     RETURN ERROR.
                 END.
             END.
         END.
         ELSE DO:
             FIND FIRST wm-item-embalagem-local
                  WHERE wm-item-embalagem-local.cod-estabel = ttWork.cod-estabel
                    AND wm-item-embalagem-local.cod-local   = ttWork.cod-local
                    AND wm-item-embalagem-local.cod-item    = ttWork.cod-item
                    AND wm-item-embalagem-local.log-padrao  = YES NO-LOCK NO-ERROR.
             
             RUN emptyRowErrors In wgbosc145.
             RUN piConverteCaixaQtde IN wgbosc145 (INPUT ttWork.cod-estabel,
                                                   INPUT ttWork.cod-local,
                                                   INPUT ttWork.cod-item,
                                                   INPUT wm-item-embalagem-local.cod-embalagem,
                                                   INPUT ttWork.num-livre-1,
                                                   INPUT ttWork.num-livre-2,
                                                   OUTPUT pQtdItem).
             IF  RETURN-VALUE = 'NOK' THEN DO:
                 RUN getRowErrors In wgbosc145(OUTPUT TABLE RowErrors).
                 FOR EACH RowErrors:
                     ASSIGN vLogErro = YES.
                     ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                     {bcp/bc9015.i2 STRING(ErrorNumber) string(ErrorDescription)}
                 END.
                 IF vLogErro = YES THEN DO: 
                     run piEliminaHandles.
                     RETURN ERROR.
                 END.
             END.
         END.
         RUN piCalcularPeso IN THIS-PROCEDURE (INPUT pQtdItem).
         ASSIGN ttWork.qtd-peso = d-qtd-peso
                ttWork.qtd-item = pQtdItem.
         /*DO ON ENDKEY UNDO, RETURN "ESC":*/
            UPDATE ttWork.qtd-peso with frame frame02.
         /*END.*/
         If  ttWork.qtd-peso = 0 Then Do:
             Hide All.
             Assign vLogErro = Yes.
             {bcp/bc9105.i "105" "Peso Inv lido (DC)"}
             View Frame {&Frame02Name}.
             Pause 0 No-message.
             Hide All No-pause.
             Return Error.
         End.

         RUN piEliminaHandles.

         Assign vLogSai = Yes
                vLogFinaliza = Yes.
         Hide All No-pause.
     END.
End Procedure.

/*************************************  Codigo do Usuario Fim   **********************************/

PROCEDURE pi-getIndTipoLeitura:

    /* Busca o parametro da bc-param-ext conforme o tipo de endereco (BC9018h.i) */
    RUN pi-getValorParametro (ttWork.cod-item,
                              "WmOut003",
                             ("LEIT-QTD-INVENTARIO"),
                              OUTPUT iIndTipoLeitura).

    /* Se nao achar o parametro, assume o valor 2 */
    IF  iIndTipoLeitura = 0 THEN DO:
        {bcp/bc9105.i "104" "Parametros nao foram inicializados (DC)"}
        ASSIGN iIndTipoLeitura = 2.
    END.

    /* Caso o parametro seja informado incorretamente, informa ao usuario */
    IF  iIndTipoLeitura < 0 OR iIndTipoLeitura > 4  THEN DO:
        {bcp/bc9105.i "104" "Valor do parametro incorreto para o item/familia/transacao (DC)"}
        ASSIGN iIndTipoLeitura = 2.
    END.

    /* Se o tipo de leitura for igual a 1, pede em tela */
    IF iIndTipoLeitura = 1 THEN DO:
        REPEAT:
            HIDE ALL NO-PAUSE.
            /*DO ON ENDKEY UNDO, RETURN "ESC":*/
               UPDATE iIndTipoLeitura WITH FRAME Frame03.
            /*END.*/
            HIDE ALL NO-PAUSE.
            /* S¢ aceita valores 2 e 3 digitados em tela */
            IF  iIndTipoLeitura = 2 OR iIndTipoLeitura = 4 THEN
                LEAVE.
        END.
        IF  l-voltar = YES THEN DO:
            ASSIGN vLogSai = Yes
                   vLogFinaliza = Yes.
            Hide All No-pause.
            RETURN 'NOK'.
        END.
    END.
End Procedure.

PROCEDURE piCalcularPeso:
    DEFINE INPUT PARAMETER iQtdItem AS DECIMAL NO-UNDO.

    If not valid-handle(wgbosc044) Then do:
        run scbo/bosc044.p persistent set wgbosc044.
        RUN openQueryStatic IN wgbosc044 (INPUT "MAIN":U).
        run gotoKey in wgbosc044 (input ttWork.cod-item).
    End.

    If not valid-handle(wgbosc145) Then do:
        run scbo/bosc145.p persistent set wgbosc145.
        run setConstraintItem in wgbosc145 (ttWork.cod-item).
        RUN openQueryStatic IN wgbosc145 (INPUT "item":U).
    End.

    run getDecField in wgbosc044 (input "qtd-peso",
                                  output qtdPesoItem).
    run getFirst in wgbosc145.
    run getLogField in wgbosc145 (input "log-padrao",
                                  output vLogPadrao).
    If vLogPadrao <> yes THEN
        Do while vLogSai = no:
            run getNext in wgbosc145.
            run getLogField in wgbosc145 (input "log-padrao",
                                          output vLogPadrao).
            If vLogPadrao = yes Then assign vLogSai = yes.
        End.

    run getDecField in wgbosc145 (input "qtd-peso",
                                  output qtdPesoEmbal).

    run getDecField in wgbosc145 (input "qtd-item-emb",
                                  output vQtdItemEmbal).

    assign d-qtd-peso =  IF (iQtdItem / vQtdItemEmbal) - TRUNCATE(iQtdItem / vQtdItemEmbal,0) > 0
            THEN ((TRUNCATE(iQtdItem / vQtdItemEmbal,0) + 1) * qtdPesoEmbal) + (iQtdItem * qtdPesoItem)
            ELSE (TRUNCATE(iQtdItem / vQtdItemEmbal,0) * qtdPesoEmbal) + (iQtdItem * qtdPesoItem).

END PROCEDURE.

PROCEDURE piEliminaHandles:

    /*Elimina o handle instanciado neste programa*/
    IF VALID-HANDLE (wgbosc145) THEN DO:
        DELETE OBJECT wgbosc145.
        ASSIGN wgbosc145 = ?.
    END.

    IF VALID-HANDLE (wgbosc044) THEN DO:
        DELETE OBJECT wgbosc044.
        ASSIGN wgbosc044 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

