/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9018J 2.00.00.003 } /*** 010003 ***/

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */

&if '{&mgscm_version}' >= '2.04' &then
/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName          - Nome do programa e, tambem, do Codigo da transacao do Data Collection   **
**                        que sera acionada pela interface.                                       **
** TempTable            - Nome da Temp-Table da transacao de negocio para comunicacao com ERP.    **
**                        Ex: tt-picking-wms.                                                     **
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

DEFINE INPUT  PARAMETER pCod-usuario              AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pCod-coletor              AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER pCod-equipamento          AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER pRowid-tarefa-docto-itens AS ROWID       NO-UNDO.
DEFINE OUTPUT PARAMETER pLogEsc                   AS LOGICAL     NO-UNDO.

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9018
/************************************************************/

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-picking-wms
{bcp/bc9018.i " "}
{bcp/bc9018.i1 "New"}
{utp/utapi009.i} /* login */
Create ttWork.

DEFINE VARIABLE vnr-pedcli              AS CHARACTER FORMAT 'x(12)':U     INIT ''  NO-UNDO.
DEFINE VARIABLE vnome-abrev             AS CHARACTER FORMAT 'x(12)':U     INIT ''  NO-UNDO.
DEFINE VARIABLE vcod-item               AS CHARACTER FORMAT 'x(16)':U     INIT ''  NO-UNDO.
DEFINE VARIABLE vdes-item               AS CHARACTER FORMAT 'x(18)':U     INIT ''  NO-UNDO. 
DEFINE VARIABLE c-desc-item             AS CHARACTER                               NO-UNDO.


Define Temp-table tt-mostra-locais NO-UNDO
    Field num-seq           As Integer
    Field des-local         As Character Format 'X(19)':U
    Field rowid-box-movto   As Rowid
        Index ID num-seq.

Define Query qry-wm-box-movto For tt-mostra-locais.

Define Browse brw-wm-box-movto Query qry-wm-box-movto No-lock
             Display 
              tt-mostra-locais.des-local
                    With No-box No-labels Size 20 By 2 No-scrollbar-vertical.


/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Picking WMS'                                      At Row 01 Col 01          ~
                             brw-wm-box-movto                                   At Row 02 Col 01          ~
                             'Ped:'                                             AT ROW 04 COL 01          ~
                             vnr-pedcli                                         At Row 04 Col 06 No-label ~
                             'Cli:'                                             AT ROW 05 COL 01          ~
                             vnome-abrev                                        AT ROW 05 COL 06 NO-LABEL ~
                             'It:'                                              AT ROW 06 COL 01          ~
                             vcod-item                                          AT ROW 06 COL 03 NO-LABEL ~
                             vdes-item                                          AT ROW 07 COL 01 NO-LABEL ~
                             
&global-define Frame01Repeat NO
/************************************************************/

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields brw-wm-box-movto

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01.
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ~
                            ON 'Return':U        OF brw-wm-box-movto IN FRAME {&Frame01Name}        ~
                            DO:                                                                     ~
                                APPLY 'Go' TO THIS-PROCEDURE.                                       ~
                            END.                                                                    ~
                            ON 'value-changed':U OF brw-wm-box-movto IN FRAME {&Frame01Name}        ~
                            DO:                                                                     ~
                                FIND ttWm-box-movto-idx-picking                                                  ~
                                    WHERE ROWID(ttWm-box-movto-idx-picking) = tt-mostra-locais.rowid-box-movto   ~
                                           NO-ERROR.                                                             ~
                                IF  NOT AVAILABLE ttWm-box-movto-idx-picking THEN RETURN NO-APPLY.               ~
                                RUN getInfoDoctoItens IN wgbosc096 (INPUT ttWm-box-movto-idx-picking.cod-estabel,  ~
                                                                    INPUT ttWm-box-movto-idx-picking.cod-local,    ~
                                                                    INPUT ttWm-box-movto-idx-picking.id-docto,     ~
                                                                    INPUT ttWm-box-movto-idx-picking.num-seq-item, ~
                                                                    OUTPUT TABLE ttwm-docto-itens ).               ~
                                FIND FIRST ttwm-docto-itens.                                                                             ~
                                RUN goToKey IN wgbosc044 (INPUT ttwm-docto-itens.cod-item). /* Vari vel ou Campo com o c¢digo do Item */ ~
                                IF RETURN-VALUE = "OK":U THEN DO:                                                                        ~
	                                RUN getCharField IN wgbosc044 (INPUT "des-item":U,                                                   ~
                                                                   OUTPUT c-desc-item). /* Vari vel ou Campo com a descri‡Æo do Item */  ~
                                    ASSIGN vdes-item:SCREEN-VALUE   IN FRAME Frame01 = TRIM(SUBSTRING(c-desc-item,1,18)).                ~
                                END.                                                                                                     ~
                                ELSE DO:                                                                                                 ~
	                                ASSIGN vdes-item:SCREEN-VALUE   IN FRAME Frame01 = ''.                                               ~
                                END.                                                                                                     ~
                                ASSIGN vcod-item:SCREEN-VALUE   IN FRAME Frame01 = TRIM(ttwm-docto-itens.cod-item)                       ~
                                       vnr-pedcli:SCREEN-VALUE  In FRAME Frame01 = TRIM(ttWm-box-movto-idx-picking.nr-pedcli)            ~
                                       vnome-abrev:SCREEN-VALUE In FRAME Frame01 = TRIM(ttWm-box-movto-idx-picking.nome-abrev).          ~
                            END.                                                                                                         ~
                            ON 'ESC':U           OF FRAME {&Frame01Name}  ~
                            DO:                                 ~
                                ASSIGN pLogEsc = YES.           ~
                            END.
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1  wgbosc030
&global-define ActiveObject2  wgbosc044
&global-define ActiveObject3  wgbosc096

/************************************************************/

/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

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

    ASSIGN vLogErro        = NO
           vLogCancela     = NO
           vLogEmProcesso  = NO.

    IF NOT VALID-HANDLE(wgbosc030) THEN DO:
        RUN scbo/bosc030.p  PERSISTENT SET wgbosc030      NO-ERROR.
        RUN openQueryStatic IN wgbosc030 (INPUT "Main":U) NO-ERROR.
    END.
/*
    IF NOT VALID-HANDLE(wgbosc032) THEN DO:
        RUN scbo/bosc032.p  PERSISTENT SET wgbosc032      NO-ERROR.
        RUN openQueryStatic IN wgbosc032 (INPUT "Main":U) NO-ERROR.
    END.
  */
    IF NOT VALID-HANDLE(wgbosc044) THEN DO:
        RUN scbo/bosc044.p  PERSISTENT SET wgbosc044      NO-ERROR.
        RUN openQueryStatic IN wgbosc044 (INPUT "Main":U) NO-ERROR.
    END.

    IF NOT VALID-HANDLE(wgbosc096) THEN DO:
        RUN scbo/bosc096.p  PERSISTENT SET wgbosc096      NO-ERROR.
        RUN openQueryStatic IN wgbosc096 (INPUT "Main":U) NO-ERROR.
    END.


    EMPTY TEMP-TABLE ttWm-box-movto-idx-picking.

    RUN getTarefaPickingConvoc IN wgbosc096 (INPUT  pCod-equipamento,
                                             INPUT  pRowid-tarefa-docto-itens,
                                             INPUT  NO,
                                             INPUT  YES,
                                             OUTPUT TABLE ttWm-box-movto-idx-picking).

    IF vLogerro = YES THEN RETURN ERROR. 

    Empty Temp-table tt-mostra-locais.

    Assign vNumSeq = 0.

    wm-boxm:
    For Each ttWm-box-movto-idx-picking
        Where ttWm-box-movto-idx-picking.ind-tipo-movto = 2
            BREAK By ttWm-box-movto-idx-picking.nr-pedcli
            By ttWm-box-movto-idx-picking.nome-abrev
            By ttWm-box-movto-idx-picking.val-prioridade:

        /* Pegar Informacoes Box */
        Run SetConstraintBoxes  In wgbosc030 (Input ttWm-box-movto-idx-picking.cod-estabel,
                                              Input ttWm-box-movto-idx-picking.cod-local,
                                              Input ttWm-box-movto-idx-picking.id-box,
                                              Input ttWm-box-movto-idx-picking.id-box).

        Run openQueryStatic In wgbosc030 (Input 'Boxes':U).

        Run getBatchRecords IN wgbosc030 (Input   ?,
                                          Input  NO,
                                          Input  ?,
                                          Output vNumCont,
                                          Output Table ttwm-box).

        Find First ttwm-box No-error.

        If Not Avail ttwm-box Then Next wm-boxm.

        Assign vNumSeq = vNumSeq + 1.

        Create tt-mostra-locais.
        Assign tt-mostra-locais.num-seq           = vNumSeq
               tt-mostra-locais.des-local         = ttwm-box.cod-bloco            + '/':U +
                                                    ttwm-box.cod-rua              + '/':U +
                                                    ttwm-box.cod-nivel            + '/':U +
                                                    ttwm-box.cod-coluna           + '/':U +
                                                    If ttwm-box.ind-posicao-box = 1 Then 'E' Else 'D'.
               tt-mostra-locais.rowid-box-movto   = Rowid(ttWm-box-movto-idx-picking).                                                                                   


        IF ttWm-box-movto-idx-picking.log-pend-ressup AND ttWork.opcao = 4 THEN
            ASSIGN tt-mostra-locais.des-local = tt-mostra-locais.des-local + '  R'.

    End. /*For Each ttWm-box-movto-idx-picking:*/

    FIND FIRST tt-mostra-locais NO-LOCK NO-ERROR.
    IF RECID(tt-mostra-locais) = ? THEN DO:
        CREATE tt-mostra-locais.
        ASSIGN tt-mostra-locais.num-seq   = 999
               tt-mostra-locais.des-local = 'NÆo existem tarefas (WMS)'.
    END.
    Open Query qry-wm-box-movto For Each tt-mostra-locais By tt-mostra-locais.num-seq By tt-mostra-locais.des-local.

    Apply 'value-changed':U To brw-wm-box-movto In Frame {&Frame01Name}.

End Procedure.


/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:

    ASSIGN vLogErro     = NO
           vLogSai      = NO
           vLogFinaliza = NO.

    IF NOT AVAIL ttWm-box-movto-idx-picking THEN DO:
        ASSIGN vLogErro = YES.
        {bcp/bc9105.i "301" "Movimento Inv lido. (WMS)"}
        RETURN ERROR.
    END.

    IF  vLogEmProcesso = NO THEN DO:
        RUN inicializaTarefaMovtoOK IN wgbosc096 (INPUT ttWm-box-movto-idx-picking.id-docto,
                                                  INPUT 07,     
                                                  INPUT ttWork.cod-usuario,              
                                                  INPUT ttWork.cod-equipamento,          
                                                  INPUT ttWork.cod-coletor,              
                                                  INPUT ttWm-box-movto-idx-picking.id-movto,         
                                                  INPUT ttWm-box-movto-idx-picking.num-seq-item).

        IF  RETURN-VALUE <> 'OK' THEN DO:
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "302" "Movimento Expirado ou J  Alocado (WMS)"}
            RETURN ERROR.
        END.
        ASSIGN vLogEmProcesso = YES.
    END.

    ASSIGN vLogErro = NO.
    IF NOT AVAIL ttWm-box-movto-idx-picking THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "301" "Movimento Inv lido (WMS)"}
         RETURN ERROR.
    END.

    HIDE ALL.

    FIND FIRST ttWork NO-ERROR.

    HIDE ALL NO-PAUSE.
    RUN bcp/bc9018h.p (INPUT ROWID(ttWm-box-movto-idx-picking)).
    HIDE ALL NO-PAUSE.

    FIND FIRST ttWork NO-ERROR.

    ASSIGN vLogFinaliza = YES
           vLogSai      = YES.

    RETURN "ESC":U.

END PROCEDURE.
/*************************************  Codigo do Usuario Fim   ********************************/
&else 

    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif
