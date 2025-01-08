/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9025 2.00.00.035 } /*** "010035" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BC9025 MBC}
&ENDIF

{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9025.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2007 - Luciano Leonhardt                           **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Transferància WMS                **
**                                                                                         **
********************************************************************************************/
/* Definicao global do nome da transacao ---                */
&global-define ProgramName esbcp008
&global-define TempTable ttWork
/* Definicao da temp-table de integracao ---                */
{utp/utapi009.i}

{bcp/bc9048.i1} /* definicao variaveis menu padrao */

/* --- Knupp - Movimentaá∆o Utilizando Etiquetas --- */
DEFINE VARIABLE h_bosc047               AS HANDLE            NO-UNDO.
DEFINE VARIABLE l-utiliz-etiq-movto     AS LOGICAL  INIT NO  NO-UNDO.

Define Temp-table ttWork No-undo
    Field cod-usuario     As Character Format 'x(14)':U Label 'Usuario'         
    Field cod-coletor     As Character Format 'x(14)':U Label 'Coletor'         Initial ""
    Field cod-equipamento As Character Format 'x(14)':U Label 'Equipamento'     Initial ""
    Field cod-estabel     As Character Format 'x(05)':U Label 'Estabel'         Initial ""
    Field cod-local       As Character Format 'x(03)':U Label 'Local'           Initial ""
    Field tpMovto         As Integer   Format '9':U     Label 'TpMovto'
    Field TpTarefa        As Integer   Format '9':U     Label 'Processo'.

Define New Global Shared Variable hbc9025n              As Handle       NO-UNDO.
Define New Shared Variable guardatipo                   As INTEGER       NO-UNDO INITIAL 1.

DEFINE VARIABLE vCodSenha          AS CHARACTER FORMAT 'x(12)':U                  NO-UNDO.
DEFINE VARIABLE iTpRegistro        AS INTEGER   FORMAT '9':U     LABEL 'Processo' NO-UNDO.
DEFINE VARIABLE vLogControlaLogin  AS LOGICAL                    INIT NO          NO-UNDO.
DEFINE VARIABLE vLogOk             AS LOGICAL                    INIT NO          NO-UNDO.
DEFINE VARIABLE wgbosc079          AS HANDLE                                      NO-UNDO.
DEFINE VARIABLE wgbosc092          AS HANDLE                                      NO-UNDO.
DEFINE VARIABLE wgbosc038          AS HANDLE                                      NO-UNDO.
DEFINE VARIABLE vLogUtilizaColetor AS LOGICAL                    INIT NO          NO-UNDO.
DEFINE VARIABLE vLogAprovaFatura   AS LOGICAL                    INIT NO          NO-UNDO.
DEFINE VARIABLE iCodTipoEquip      AS INTEGER                                     NO-UNDO.
DEFINE VARIABLE iCodTipoColetor    AS INTEGER                                     NO-UNDO.
DEFINE VARIABLE vLogProcesso       AS LOGICAL                    INIT NO          NO-UNDO.
DEFINE VARIABLE vLogAtivo          AS LOGICAL                    INIT NO          NO-UNDO.
DEFINE VARIABLE i-retorno-bc9025m  AS DECIMAL                                     NO-UNDO.
DEFINE VARIABLE l-menu-padrao      AS LOGICAL INIT YES NO-UNDO.
DEFINE VARIABLE vnom-estabel       AS CHARACTER                                   NO-UNDO.
DEFINE VARIABLE vnom-local         AS CHARACTER                                   NO-UNDO.
DEFINE TEMP-TABLE ttwm-etiqueta    NO-UNDO LIKE wm-etiqueta.

/************************************************************/
/* Definicao dos objetos ativos ---                         */
&global-define ActiveObject1 wgbosc079
&global-define ActiveObject2 wgbosc092
&global-define ActiveObject3 wgbosc038

/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/
{bcp/bc9015.i3}  /* def variaveis padroes */

/* Propriedades globais para frames ---                     */
&global-define FrameSize    20 By 8
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Transferància WMS'                                At Row 01  Col 01          ~
                             '(Agrupadores)'                                    At Row 1.8 Col 01          ~
                             '--------------------':U                           At Row 2.5 Col 01          ~
                             'Usr:'                                             At Row 3.7 Col 01          ~
                             ttWork.cod-usuario                                 At Row 3.7 Col 05 NO-LABEL ~
                             'Sen:'                                             At Row 4.7 Col 01          ~
                             vCodSenha                                          At Row 4.7 Col 05 NO-LABEL ~
                             'Col:'                                             At Row 5.7 Col 01          ~
                             ttWork.cod-coletor                                 At Row 5.7 Col 05 NO-LABEL ~
                             'Equ:'                                             At Row 6.7 Col 01          ~
                             ttWork.cod-equipamento                             At Row 6.7 Col 05 NO-LABEL 
&global-define Frame01Repeat NO

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Transferància WMS'                                At Row 01  Col 01          ~
                             '(Agrupadores)'                                    At Row 1.8 Col 01          ~
                             '--------------------':U                           At Row 2.5 Col 01          ~
                             ' Estab:'                                          AT ROW 04  COL 01          ~
                              ttWork.cod-estabel                                AT ROW 04  COL 08 NO-LABEL ~
                             ' Local:'                                          AT ROW 05  COL 01          ~
                              ttWork.cod-local                                  AT ROW 05  COL 08 NO-LABEL ~
                             'Tarefa:'                                          AT ROW 06  COL 01          ~
                              iTpRegistro                                       AT ROW 06  COL 08 NO-LABEL ~
                             'Op: 0-Man 1-Aut'                                  AT ROW 07  COL 01 ~
                             '    2-Man Emb Unica'                              AT ROW 08  COL 01
&global-define Frame02Repeat NO 

/* Definicao da Frame03 ---          flaviocasas            */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Transferància WMS'                                At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             '1 - Tarefas P£blicas'                             At Row 03 Col 01          ~
                             '2 - Minhas Tarefas'                               At Row 04 Col 01          ~
                             '3 - Tarefas Equipto'                              At Row 05 Col 01          ~
                             '4 - Meus Processos'                               At Row 06 Col 01          ~
                             'Opá∆o:'                                           At Row 07 Col 01          ~
                              ttWork.tpTarefa                                   At Row 07 Col 08 No-label
&global-define Frame03Repeat NO 

/* Definicao da Frame04 ---          flaviocasas            */
&global-define Frame04Name   Frame04
&global-define Frame04Defs   'Transferància WMS'                                At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             '1 - Saida'                                        At Row 03 Col 01          ~
                             '2 - Entrada'                                      At Row 04 Col 01          ~
                             'TpMovto:'                                         At Row 07 Col 01          ~
                              ttWork.tpMovto                                    At Row 07 Col 08 No-label
&global-define Frame04Repeat NO 

/************************************************************/
/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields                                   ~
               ttWork.cod-usuario  WHEN ttWork.cod-usuario = '' ~
               vCodSenha           WHEN ttWork.cod-usuario = '' ~
               ttWork.cod-coletor                               ~
               ttWork.cod-equipamento 

&global-define Update02Fields ttWork.cod-estabel ttWork.cod-local iTpRegistro

&global-define Update03Fields ttWork.tpTarefa

&global-define Update04Fields ttWork.tpMovto
/************************************************************/
/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03. 
&global-define TriggerBeforeFrame04 Run InicializaCamposFrame04. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. 
&global-define TriggerAfterFrame03  Run GravaCamposFrame03.
&global-define TriggerAfterFrame04  Run GravaCamposFrame04.

&global-define UserTriggers                                                         ~
                        ON ENTRY OF ttWork.cod-coletor IN FRAME {&Frame01Name}          ~
                        DO:                                                             ~
                            IF v_cod-coletor_corren     <> '' AND                       ~
                               v_cod-equipamento_corren <> '' THEN DO:                  ~
                                IF l-menu-padrao = YES THEN DO:                         ~
                                    ASSIGN l-menu-padrao = NO.                          ~
                                    APPLY "Enter":U TO ttWork.cod-equipamento IN FRAME {&Frame01Name}. ~
                                END.                                                    ~
                                ELSE DO:                                                ~
                                    APPLY "ESC":U TO ttWork.cod-coletor IN FRAME {&Frame01Name}. ~
                                END.                                                    ~
                            END.                                                        ~
                        END.                                                            ~
                        ON 'enter':U OF ttWork.cod-coletor IN Frame Frame01             ~
                        DO:                                                             ~
                            APPLY 'entry':U TO ttWork.cod-equipamento IN FRAME Frame01. ~
                            RETURN NO-APPLY.                                            ~
                        END.                                                            ~
                        ON 'enter':U OF ttWork.cod-estabel IN Frame Frame02             ~
                        DO:                                                             ~
                            APPLY 'entry':U TO ttWork.cod-local IN FRAME Frame02.       ~
                            RETURN NO-APPLY.                                            ~
                        END.                                                            ~
                        ON 'enter':U OF ttWork.cod-local IN Frame Frame02               ~
                        DO:                                                             ~
                            APPLY 'entry':U TO iTpRegistro IN FRAME Frame02.            ~
                            RETURN NO-APPLY.                                            ~
                        END.                                                            ~
                        ON 'ESC':U OF Frame Frame01 OR END-ERROR OF FRAME {&Frame01Name} ~
                        DO:                                                             ~
                            ASSIGN vlogerro = YES                                       ~
                                   vLogSai  = YES                                       ~
                                   vLogFinaliza = YES                                   ~
                                   vLogCancela = YES.                                   ~
                            Return 'NOK':U.                                             ~
                        END.                                                            ~
                        ON 'F4':U OF Frame Frame01                                      ~
                        DO:                                                             ~
                            Return 'ESC':U.                                             ~
                        END.                                                            ~

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao e necessario efetuar alteracoes nesta sessao.                                             **
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
** Esta procedure e executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:
    IF v_cod_usuar_corren <> '' THEN DO: 
       ASSIGN vCodSenha:BLANK IN FRAME {&Frame01Name}                 = NO.
       ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod_usuar_corren
              ttWork.cod-usuario                                      = v_cod_usuar_corren
              vCodSenha                                               = '****************':U 
              vCodSenha:SCREEN-VALUE IN FRAME {&Frame01Name}          = '****************':U. 
       IF v_cod-coletor_corren     <> '' AND 
          v_cod-equipamento_corren <> '' THEN DO:
            ASSIGN ttWork.cod-coletor:SCREEN-VALUE IN FRAME {&Frame01Name}     = v_cod-coletor_corren
                   ttWork.cod-coletor     = v_cod-coletor_corren
                   ttWork.cod-equipamento:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod-equipamento_corren
                   ttWork.cod-equipamento = v_cod-equipamento_corren.
       END.
    END.
    ELSE DO:
       ASSIGN vCodSenha:BLANK IN FRAME {&Frame01Name}                 = YES.
       ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name} = '' 
              ttWork.cod-usuario                                      = '' 
              vCodSenha                                               = ''  
              vCodSenha:SCREEN-VALUE IN FRAME {&Frame01Name}          = ''.
    END.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame01}.                        **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
    /* Validacoes Frame 01 Inicio --- */
    ASSIGN vLogErro          = NO
           vLogControlaLogin = NO.

    IF v_cod_usuar_corren <> "" THEN
       ASSIGN ttWork.cod-usuario = v_cod_usuar_corren.
    ELSE
       ASSIGN INPUT FRAME {&Frame01Name} ttWork.cod-usuario.

    IF v2_cod_usuar_corren = '' THEN DO:
       FOR EACH tt-erros:
          DELETE tt-erros.
       END.

       login:
       DO ON ERROR  UNDO login, LEAVE login
       ON QUIT      UNDO login, LEAVE login
       ON STOP      UNDO login, LEAVE login
       ON ENDKEY    UNDO login, LEAVE login:
          RUN btb/btapi910za.p (INPUT  ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name}, 
                                INPUT  vCodSenha,
                                OUTPUT TABLE tt-erros) NO-ERROR. 
       END. 
       IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4753) THEN DO:
          {bcp/bc9105.i "4753" "Usu†rio n∆o encontrado. (DC)"}
          ASSIGN vLogErro           = YES
                 v_cod_usuar_corren = ''.
          RETURN ERROR.
       END.
       ELSE DO:
          IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4758) THEN DO: 
             {bcp/bc9105.i "4758" "Senha para o usu†rio n∆o est† correta. (DC)"} 
             ASSIGN vLogErro           = YES
                    v_cod_usuar_corren = ''.
             RETURN ERROR.
          END.
          ELSE DO:
             IF CAN-FIND (FIRST tt-erros) THEN DO:
                {bcp/bc9105.i "202" "Problemas na autenticaá∆o do usu†rio. (DC)"} 
                ASSIGN vLogErro           = YES
                       v_cod_usuar_corren = ''.
                RETURN ERROR.
             END.
          END.
       END.

       ASSIGN vLogControlaLogin = YES.
    END.

    {bcp/bc9017.i1 ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name}}

    IF NOT VALID-HANDLE(wgbosc079) THEN DO:
       RUN scbo/bosc079.p PERSISTENT SET wgbosc079 NO-ERROR.
    END.
    IF NOT VALID-HANDLE(wgbosc092) THEN DO:
       RUN scbo/bosc092.p PERSISTENT SET wgbosc092 NO-ERROR.
    END.
    IF vLogOk = NO THEN DO:
       ASSIGN vLogErro = YES.
       IF vLogControlaLogin = YES THEN
          ASSIGN v_cod_usuar_corren  = ''
                 v2_cod_usuar_corren = ''.

       {bcp/bc9105.i "101" "Usu†rio Inv†lido. (DC)"}
       RETURN ERROR.
    END.

    /* Valida existencia do usuario no WMS e retorna se ele tem ou nao permissao para utilizar coletor */
    RUN validaUsuario IN wgbosc079 (INPUT  ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name},
                                    OUTPUT vLogUtilizaColetor,
                                    OUTPUT vLogAprovaFatura).
    IF RETURN-VALUE <> 'OK' THEN DO:
       ASSIGN vLogErro = YES.
       IF vLogControlaLogin THEN
          ASSIGN v_cod_usuar_corren  = ''
                 v2_cod_usuar_corren = ''.
       {bcp/bc9105.i "101" "Usu†rio Inv†lido. (WMS)"}
       RETURN ERROR.
    END.

    IF vLogUtilizaColetor = NO THEN DO:
       ASSIGN vLogErro = YES.
       IF vLogControlaLogin THEN
          ASSIGN v_cod_usuar_corren  = ''
                 v2_cod_usuar_corren = ''.
       {bcp/bc9105.i "102" "Usu†rio sem permiss∆o para utilizar Coletor. (WMS)"}
       RETURN ERROR.
    END.

    /* valida se existe equipamento, se e do tipo coletor e se esta ativo */
    RUN validaEquipColetor IN wgbosc092 (INPUT  ttWork.cod-coletor,
                                         OUTPUT iCodTipoColetor,
                                         OUTPUT vLogAtivo,
                                         OUTPUT vLogProcesso).
    IF RETURN-VALUE <> 'OK' THEN DO:
       ASSIGN vLogErro = YES.
       {bcp/bc9105.i "103" "Coletor Inv†lido. (WMS)"}
       RETURN ERROR.
    END.

    IF vLogAtivo = NO THEN DO:
       ASSIGN vLogErro = YES.
       {bcp/bc9105.i "104" "Coletor Inativo. (WMS)"}
       RETURN ERROR.
    END.

    /* valida se existe equipamento, se e do tipo transportador e se esta ativo */
    RUN validaEquipTransportador In wgbosc092 (INPUT  ttWork.cod-equipamento,
                                               OUTPUT iCodTipoEquip,
                                               OUTPUT vLogAtivo,
                                               OUTPUT vLogProcesso).
    IF RETURN-VALUE <> 'OK' THEN DO:
       ASSIGN vLogErro = YES.
       {bcp/bc9105.i "105" "Equipto Inv†lido. (WMS)"}
       RETURN ERROR.
    END.

    IF vLogAtivo = NO THEN DO:
       ASSIGN vLogErro = YES.
       {bcp/bc9105.i "106" "Equipto Inativo. (WMS)"}
       RETURN ERROR.
    END.

    /* Validacoes Frame 01 Fim    --- */
    ASSIGN {&TempTable}.cod-usuario     = ttWork.cod-usuario 
           {&TempTable}.cod-coletor     = ttWork.cod-coletor
           {&TempTable}.cod-equipamento = ttWork.cod-equipamento.

    If Valid-handle(wgbosc092) Then Delete Procedure wgbosc092.
    If Valid-handle(wgbosc079) Then Delete Procedure wgbosc079.


END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure e executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:   
    ASSIGN vLogOk  = NO
           iTpRegistro = guardatipo.

    IF NOT VALID-HANDLE(wgbosc038)  THEN DO:
       Run scbo/bosc038.p persistent set wgbosc038.
       Run openQueryStatic In wgbosc038 (Input "Main":U) No-error.
    END.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:
    ASSIGN guardatipo = iTpRegistro.
    Assign  vLogErro = NO.
    Assign  Input Frame Frame01 ttWork.cod-coletor
            Input Frame Frame01 ttWork.cod-equipamento
            Input Frame Frame02 ttWork.cod-estabel
            Input Frame Frame02 ttWork.cod-local.

    If   ttWork.cod-estabel = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "200" "Estabelecimento Inv†lido (DC)"}
         Return Error.
    End.

    RUN getnomestabel IN wgbosc038 (INPUT ttWork.cod-estabel,
                                    OUTPUT vnom-estabel).
    IF RETURN-VALUE <> 'OK':U THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "201" "Estabelecimento Inv†lido (WMS)"}
    END.

    If   ttWork.cod-local = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "202" "Local Inv†lido (DC)"}
         Return Error.
    End.

    RUN getNomLocal IN wgbosc038 (INPUT ttWork.cod-local,
                                  OUTPUT vnom-local).
    IF RETURN-VALUE <> 'OK':U THEN DO:
       Assign vLogErro = Yes.
       {bcp/bc9105.i "203" "Local Inv†lido (WMS)"}
       Return Error.
    END.

    IF VALID-HANDLE (wgbosc038) THEN DO:
       DELETE OBJECT wgbosc038.
       ASSIGN wgbosc038 = ?.
    END.

    /* --- Knupp - Movimentaá∆o Utilizando Etiquetas --- */
    IF NOT VALID-HANDLE(h_bosc047) THEN DO:
        RUN scbo/bosc047.p PERSISTENT SET h_bosc047.
        RUN openQueryStatic IN h_bosc047 (INPUT "Main":U) NO-ERROR.
    END.
    RUN verificarUtilizaEtiqMovto IN h_bosc047(INPUT ttWork.cod-estabel,
                                               INPUT ttWork.cod-local,
                                               OUTPUT l-utiliz-etiq-movto).

    IF VALID-HANDLE (h_bosc047) THEN DO:
        DELETE OBJECT h_bosc047.
        ASSIGN h_bosc047 = ?.
    END.
    IF NOT l-utiliz-etiq-movto THEN DO:
        /*Tratamento erro (51820)*/
        {bcp/bc9105.i "51820" "Local n∆o utiliza etiquetas!"} 
        HIDE ALL.       
        RETURN ERROR.
    END.

    IF iTpRegistro:SCREEN-VALUE IN FRAME {&Frame02Name} <> "0" AND 
       iTpRegistro:SCREEN-VALUE IN FRAME {&Frame02Name} <> "1" AND 
       iTpRegistro:SCREEN-VALUE IN FRAME {&Frame02Name} <> "2" THEN DO:
        {bcp/bc9105.i "100" "Opá∆o Inv†lida (DC)"}
        HIDE ALL.
        RETURN ERROR.
    END.

    IF iTpRegistro = 0 THEN DO:
        HIDE ALL NO-PAUSE.
        RUN esp/bcp/esbcp008m.p  (Input ttWork.cod-coletor,
                            Input ttWork.cod-equipamento,
                            Input ttWork.cod-estabel,
                            Input ttWork.cod-local,
                            OUTPUT i-retorno-bc9025m).
        HIDE ALL NO-PAUSE.
        IF i-retorno-bc9025m = 888888 THEN DO:
           HIDE ALL NO-PAUSE.
           RUN esp/bcp/esbcp008o.p (INPUT ttWork.cod-coletor,    
                              INPUT ttWork.cod-equipamento,
                              INPUT ttWork.cod-estabel, 
                              INPUT ttWork.cod-local,      
                              INPUT ttWork.cod-usuario).
           HIDE ALL NO-PAUSE.
        END.
    END.

    IF iTpRegistro = 2 THEN DO:
        HIDE ALL NO-PAUSE.

        ASSIGN guardatipo  = 2
               iTpRegistro = 0.

        repete:
        REPEAT ON ENDKEY UNDO, RETRY:
            /*********** SAIDA ***********/
            RUN bcp/bc9025k.p (Input ttWork.cod-coletor,
                               Input ttWork.cod-equipamento,
                               Input ttWork.cod-estabel,
                               Input ttWork.cod-local,
                               OUTPUT i-retorno-bc9025m,
                               OUTPUT TABLE ttWm-etiqueta).

            IF i-retorno-bc9025m <> 999999 THEN DO:
                /*********** ENTRADA ***********/
                RUN bcp/bc9025l.p (INPUT ttWork.cod-coletor,
                                   INPUT ttWork.cod-equipamento,
                                   INPUT ttWork.cod-estabel, 
                                   INPUT ttWork.cod-local,      
                                   INPUT ttWork.cod-usuario,
                                   INPUT TABLE ttWm-etiqueta).

                HIDE ALL NO-PAUSE.
                /*********** ENTRADA ***********/
            END.

            IF i-retorno-bc9025m = 999999 THEN
                LEAVE repete.
        END.
    END.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame03 com valores em branco              **
** Esta procedure e executada pelo pre-processador {&TriggerBeforeFrame03}.                       **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame03:
   IF iTpRegistro = 0 THEN DO: /*transferància manual*/
        HIDE FRAME Frame03 NO-PAUSE.
        RETURN ERROR.
   END.
   ELSE DO: /*transferància autom†tica*/
       ASSIGN vLogErro    = NO
              vLogCancela = NO
              vLogSai     = NO
              ttWork.tpTarefa = 1.
   END.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame03}.                        **
****************************************************************************************************/
PROCEDURE GravaCamposFrame03:
    ASSIGN  vLogErro = No.
    IF  ttWork.tpTarefa:SCREEN-VALUE IN FRAME {&Frame03Name} <> "1" AND
        ttWork.tpTarefa:SCREEN-VALUE IN FRAME {&Frame03Name} <> "2" AND
        ttWork.tpTarefa:SCREEN-VALUE IN FRAME {&Frame03Name} <> "3" AND
        ttWork.tpTarefa:SCREEN-VALUE IN FRAME {&Frame03Name} <> "4" THEN DO:
        {bcp/bc9105.i "100" "Opá∆o Inv†lida (DC)"}
        HIDE ALL.
        RETURN ERROR.
    END.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame03 com valores em branco              **
** Esta procedure e executada pelo pre-processador {&TriggerBeforeFrame03}.                       **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame04:
    Assign ttWork.tpMovto = 1.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame03}.                        **
****************************************************************************************************/
PROCEDURE GravaCamposFrame04:
   ASSIGN vLogErro = NO.

    If  ttWork.tpMovto:SCREEN-VALUE IN FRAME {&Frame04Name} <> "1"
    And ttWork.tpMovto:SCREEN-VALUE IN FRAME {&Frame04Name} <> "2"
    Then Do:
        {bcp/bc9105.i "100" "Opá∆o Inv†lida (DC)"}
        Hide All.
        Return Error.
    End.

    IF NOT VALID-HANDLE(hbc9025n) THEN DO:
       RUN bcp/bc9025n.p PERSISTENT SET hbc9025n NO-ERROR.
    END.

    RUN validaAgrupadores IN hbc9025n ( INPUT ttWork.cod-usuario,
                                        INPUT ttWork.cod-equipamento,
                                        INPUT iCodTipoEquip,
                                        INPUT ttWork.cod-coletor,
                                        INPUT ttWork.cod-estabel,
                                        INPUT ttWork.cod-local).

    IF RETURN-VALUE <> 'OK':U THEN DO:
       ASSIGN vLogErro = YES.
       {bcp/bc9105.i "201" "Estab/Local Inv†lido. (WMS)"}
       RETURN ERROR.
    END.

    If ttWork.tpMovto:SCREEN-VALUE IN FRAME {&Frame04Name} = "2" /*Entrada*/
    Then Do:
        HIDE all no-pause.
        Run bcp/bc9025e1.p (INPUT ttWork.cod-estabel, 
                            INPUT ttWork.cod-local,   
                            INPUT ttWork.tpTarefa,
                            INPUT 1,   /*1=Entrada eh invertido mesmo*/
                            INPUT iTpRegistro).
        HIDE all no-pause.
        If Return-value <> "OK":U
        Then Do:
            Run showError.
            Return Error.
        End.
    End.
    Else If ttWork.tpMovto:SCREEN-VALUE IN FRAME {&Frame04Name} = "1" /*Saida*/
    Then Do:
        HIDE all no-pause.
        Run bcp/bc9025s1.p (INPUT ttWork.cod-estabel,
                            INPUT ttWork.cod-local,  
                            INPUT ttWork.tpTarefa,
                            INPUT 2,   /*2=Saida eh invertido mesmo*/
                            INPUT iTpRegistro).
        HIDE all no-pause.
        If Return-value <> "OK":U
        Then Do:
            Run showError.
            Return Error.
        End.
    End.

    /*IF VALID-HANDLE(hbc9025n) THEN DELETE PROCEDURE hbc9025n.*/

End Procedure.

/****************************************************************************
 * Objetivo: Adicionar uma mensagem de erro Ö tabela tt-error               *
 ****************************************************************************/
/****************************************************************************
 * Objetivo: Adicionar uma mensagem de erro Ö tabela tt-error               *
 ****************************************************************************/
PROCEDURE showError:
   FIND FIRST tt-erro NO-ERROR.
   IF AVAIL tt-erro THEN DO:
      FOR EACH tt-erro:
         {bcp/bc9015.i2 STRING(tt-erro.cd-erro) STRING(tt-erro.mensagem)}
         ASSIGN vLogSai = YES.
      END.
      IF vLogErro = YES THEN RETURN ERROR.
   END.
END PROCEDURE.
/****************************************************************************
 * Objetivo: Adicionar uma mensagem de erro Ö tabela tt-error               *
 ****************************************************************************/
PROCEDURE addError:
   DEFINE INPUT PARAMETER iCod-Erro AS INTEGER    NO-UNDO.
   DEFINE INPUT PARAMETER cMensagem AS CHARACTER  NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.

   DEFINE VARIABLE iSequencia AS INTEGER NO-UNDO.

   Find LAST tt-erro NO-ERROR.
   IF NOT AVAIL tt-erro THEN iSequencia = 1.
   ELSE ASSIGN iSequencia = tt-erro.i-sequen + 1.

   CREATE tt-erro.
   ASSIGN tt-erro.i-sequen = iSequencia
          tt-erro.cd-erro = iCod-Erro
          tt-erro.mensagem = cMensagem.

   RETURN "OK":U.
END PROCEDURE.
