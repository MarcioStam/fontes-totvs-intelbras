/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9023 2.00.00.015 } /*** 010015 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BC9023 MBC}
&ENDIF

/* Alterado por Amarildo Gambeta
Substitu¡da a chamada do m‚todo "getLocalizacaoEtiqueta" da BO "bosc112.p" 
pelo m‚todo "getSerialAdrress" da BO "BOSC074" (conforme orientado pela  rea 
de neg¢cio na FO 1.363.764) para busca do endere‡o correto de armazenamento 
da etiqueta. 
** FOI ALTERADA A DOCUMENTA€ÇO DO PRODUTO PARA CONTEMPLAR A NOVA FORMA DE CONSULTA (SEM STATUS E SOMENTE AS ETIQUETAS ARMAZENADAS) - 
Definido em conjunto com a equipe de servi‡os e Desenvolviemnto.
*/

{include/i_dbinst.i}  /* versao das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9023.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - novembro/2002 - karla Klemke - Cria‡Æo do programa          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Consulta de Endere‡o WMS         **
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
&global-define ProgramName BC9023
/************************************************************/

{utp/utapi009.i} /* login */
/* Definicao da temp-table de integracao ---                */
{bcp/bc9023.i}
{bcp/bc9048.i1} /* definicao variaveis menu padrao */
&global-define TempTable tt-consulta

DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.

Define Temp-table ttWork No-Undo like {&TempTable}.
Create ttWork.
Define Temp-table RowErrors No-undo 
    Field ErrorSequence    As Integer 
    Field ErrorNumber      As Integer 
    Field ErrorDescription As Character 
    Field ErrorParameters  As Character 
    Field ErrorType        As Character 
    Field ErrorHelp        As Character 
    Field ErrorSubType     As Character.
/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Consult Endere‡o WMS'                            At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label ~
                             'Sen:'                                             AT ROW 04 COL 01          ~
                             vcod-senha                                         AT ROW 04 COL 05 NO-LABEL ~
                             'Col:'                                             At Row 05 Col 01          ~
                             ttWork.cod-coletor                                 At Row 05 Col 05 No-label ~
                             'Equ:'                                             At Row 06 Col 01          ~
                             ttWork.cod-equipamento                             At Row 06 Col 05 No-label
&global-define Frame01Repeat No


/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Consult Endere‡o WMS'                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Serial  :           '                             At Row 03 Col 01          ~
                             'End:'                                             At Row 05 Col 01          ~
                             'Saldo:'                                           At Row 06 Col 01          ~
                             ttWork.num-serial                                  At Row 04 Col 01 No-label ~
                             ttWork.des-endereco FORMAT "X(14)"                 At Row 05 Col 05 NO-LABEL ~
                             ttWork.dec-livre-1 FORMAT ">>>>>>9.9999"           At Row 06 Col 07 NO-LABEL ~
                             '777777-Lista Docto  '                             AT ROW 07 COL 01          ~
                             ttWork.num-livre-2                                 At Row 08 Col 01 NO-LABEL 
&global-define Frame02Repeat Yes
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = ''  ~
                              vcod-senha WHEN ttWork.cod-usuario = ''          ~
                              ttWork.cod-coletor ttWork.cod-equipamento        ~

&global-define Update02Fields ttWork.num-serial

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. IF vLogSai = Yes Then do: LEAVE _frame01. END.
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. IF vLogErro = YES THEN do: LEAVE _frame02. END.     
/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ON ENTRY OF ttWork.cod-coletor IN FRAME {&Frame01Name} ~
                            DO:                                                    ~
                                IF v_cod-coletor_corren     <> '' AND              ~
                                   v_cod-equipamento_corren <> '' THEN DO:         ~
                                    IF l-menu-padrao = YES THEN DO:                ~
                                        ASSIGN l-menu-padrao = NO.                 ~
                                        APPLY "Enter":U TO ttWork.cod-equipamento IN FRAME {&Frame01Name}. ~
                                    END.                                           ~
                                    ELSE DO:                                       ~
                                        APPLY "ESC":U TO ttWork.cod-coletor IN FRAME {&Frame01Name}. ~
                                    END.                                           ~
                                    RETURN NO-APPLY.                                   ~
                                END.                                               ~
                            END.                                                   ~
                            ON 'ESC':U OF Frame Frame01    ~
                            DO:                            ~
                                ASSIGN  vlogerro = YES     ~
                                       vLogSai  = YES      ~
                                       vLogFinaliza = YES. ~
                                       vLogCancela = YES.  ~
                                Return 'ESC':U.            ~
                            END. ~


/************************************************************/

/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgBOSC092
&global-define ActiveObject2 wgBOSC079
&global-define ActiveObject3 wgBOSC074

/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
RUN pi-return-value.
{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ‚ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure esta inicializando o campo tipo-trans da tela Frame01 com o valor 1             **
** Os outros campos nao estao sendo inicializados pois os mesmos devem apresentar valor           **
** caso seja retornado a proxima tela para esta.                                                  **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame01:

    If  RETURN-VALUE = 'ESC':U  Then Do:
        ASSIGN vlogerro = YES     
               vLogSai  = YES      
               vLogFinaliza = YES
               vLogCancela = YES. 
        HIDE ALL NO-PAUSE.
        RETURN  ERROR.
    End.
    ASSIGN vLogErro     = NO
           vLogsai      = NO
           vLogfinaliza = NO.
    FOR EACH ttWork:
        DELETE ttWork.
    END.
    Create ttWork.
    IF v_cod_usuar_corren <> '' THEN DO: 
        assign vcod-senha:blank in frame frame01 = NO.
        ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = v_cod_usuar_corren
               ttWork.cod-usuario                               = v_cod_usuar_corren
               vcod-senha                                       = '****************':U /* login autom tico */
               vcod-senha:SCREEN-VALUE IN FRAME frame01         = '****************':U. /* login autom tico */
        IF v_cod-coletor_corren     <> '' AND 
           v_cod-equipamento_corren <> '' THEN DO:
            ASSIGN ttWork.cod-coletor:SCREEN-VALUE IN FRAME {&Frame01Name}     = v_cod-coletor_corren
                   ttWork.cod-coletor     = v_cod-coletor_corren
                   ttWork.cod-equipamento:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod-equipamento_corren
                   ttWork.cod-equipamento = v_cod-equipamento_corren.
       END.
    END.
    ELSE DO:
        assign vcod-senha:blank in frame frame01 = YES.
        ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = '' 
               ttWork.cod-usuario = ''
               vcod-senha = ''  
               vcod-senha:SCREEN-VALUE IN FRAME Frame01 = ''.
    END.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame03 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame02:   

    ASSIGN vLogErro     = NO
           vLogsai      = NO
           vLogfinaliza = NO.
    Assign ttWork.des-endereco = ''.
    Disp ttWork.des-endereco
         ttWork.dec-livre-1 With Frame Frame02.
End Procedure.


/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01. Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.     **
****************************************************************************************************/
Procedure GravaCamposFrame01:

    /* Validacoes Frame 01 Inicio --- */
    ASSIGN vLogErro     = NO
           vLogsai      = NO
           vLogfinaliza = NO.

    /* VALIDA€AO USUµRIO */
    If  input Frame Frame01 ttWork.cod-usuario = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "201" "Usu rio Inv lido (DC)"}
    End. 
    IF v2_cod_usuar_corren = ''  THEN DO:
       FOR each tt-erros:
           DELETE tt-erros.
       END.
       login:
       do on error  undo login, leave login
       on quit   undo login, leave login
       on stop   undo login, leave login
       on endkey undo login, leave login: 
          run btb/btapi910za.p (input INPUT FRAME frame01 ttWork.cod-usuario, 
                                INPUT INPUT FRAME frame01 vCod-Senha, 
                                output table tt-erros) NO-ERROR.        
       end. 
       IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4753) THEN DO:
          {bcp/bc9105.i "4753" "Usu rio nÆo encontrado!(DC)"}
          Assign vLogErro           = Yes
                 v_cod_usuar_corren = ''.
          RETURN ERROR.
       END.
       ELSE DO:
          IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4758) THEN DO:
             {bcp/bc9105.i "4758" "Senha para o usu rio nÆo est  correta!(DC)"} 
              Assign vLogErro           = Yes
                     v_cod_usuar_corren = ''.
              RETURN ERROR.
          END.
       END.
       ASSIGN vLogControlaLogin = YES.
    END.

    IF NOT VALID-HANDLE(wgbosc079)  THEN DO:
       Run scbo/bosc079.p Persistent Set wgbosc079.
       Run openQueryStatic In wgbosc079 (Input "Main":U) No-error.
    END.
    Run validaUsuario In wgbosc079 (Input input Frame Frame01 ttWork.cod-usuario,
                                    OUTPUT vLogUtilizaColetor,
                                    OUTPUT vLogAprovaFatura).
    If Return-value <> 'OK' Then Do:
        Assign vLogErro = Yes.
        IF vLogControlaLogin = YES THEN
        ASSIGN v_cod_usuar_corren  = ''
               v2_cod_usuar_corren = ''.
        Run getrowErrors In wgbosc079 (output Table RowErrors).
        For Each RowErrors:
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
        END.                                           
    End.
    IF vLogUtilizaColetor = NO THEN DO:
        Assign vLogErro = Yes.
        IF vLogControlaLogin = YES THEN
        ASSIGN v_cod_usuar_corren  = ''
               v2_cod_usuar_corren = ''.
        {bcp/bc9105.i "202" "Usu rio sem permissÆo para Coletor (WMS)"}
    END.
    If vLogErro = Yes Then Return Error.

    IF ttWork.cod-coletor = ''  THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "102" "Coletor Inv lido (DC)"}
    END.
    If  ttWork.cod-equipamento = '' Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "103" "Equipamento Inv lido (DC)"}
    End.
    If   vLogErro = Yes Then Return Error.

    /* instancia as BOs de forma persistente */
    if NOT valid-handle(wgBOSC092) THEN DO:
        Run scbo/bosc092.p Persistent Set wgbosc092.
    END.

    /* valida se equipamento ‚ do tipo coletor */
    RUN validaEquipColetor In wgbosc092 (Input  ttWork.cod-coletor,
                                         Output vCodTipoEquip,
                                         Output vLogAtivo,
                                         Output vLogProcesso).
    If  Return-value <> 'OK' Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "102" "Coletor Inv lido (WMS)"}
        Return Error.
    End.

    /* valida se existe equipamento e se est  ativo */
    Run validaEquipTransportador In wgbosc092  (Input  ttWork.cod-equipamento,
                                                Output vCodTipoEquip,
                                                Output vLogAtivo,
                                                Output vLogProcesso).
    If  Return-value <> 'OK':U Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "103" "Equipamento Inv lido (WMS)"}
    End.
    IF vlogAtivo = NO THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "104" "Equipamento Desativado (WMS)"}
    END.
    If   vLogErro = Yes Then Return Error.

    Return Return-value.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame02:

    DEFINE VARIABLE vlogcontrol AS LOGICAL INITIAL NO.
    DEFINE VARIABLE vMsg       AS CHARACTER FORMAT "X(35)"  NO-UNDO.

    ASSIGN vLogErro     = NO
           vLogsai      = NO
           vLogfinaliza = NO.

    If  ttWork.num-serial = 0 Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "201" "Serial Inv lido (DC)"}
        Return Error.
    End. /*If  ttWork.num-serial = 0 Then Do:*/

    FIND FIRST wm-etiqueta
        WHERE wm-etiqueta.id-etiqueta = ttWork.num-serial NO-LOCK NO-ERROR.
    IF NOT AVAIL wm-etiqueta THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "202" "Etiqueta inexistente"}
        Return Error.
    END.
    
    IF NOT VALID-HANDLE(wgBOSC074)  THEN DO:
       Run scbo/bosc074.p Persistent SET wgbosc074.
       Run openQueryStatic In wgbosc074 (Input "Main":U) No-error.
    END.
    Run emptyRowErrors in wgbosc074.
    Run getSerialAdrress in wgbosc074 (Input ttWork.num-serial,
                                       Output vNumBox,
                                       Output vCodBloco,
                                       Output vCodRua,
                                       Output vCodNivel,
                                       Output vCodcoluna).

    IF RETURN-VALUE = 'NOK' THEN DO:
        Run getRowErrors   In wgbosc074 (Output Table RowErrors) No-error.    
        For Each RowErrors:
            ASSIGN vLogErro     = YES.
            Hide All No-pause.
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
            Hide All No-pause.
        End. /* Each RowErrors */     
        If vLogErro = Yes Then Return Error.
    END.

    IF vNumBox            <> 0  AND
       STRING(vCodBloco)  <> "" AND
       STRING(vCodRua)    <> "" AND 
       STRING(vCodNivel)  <> "" AND 
       STRING(vCodcoluna) <> "" THEN DO:

        FOR FIRST wm-etiqueta
            WHERE wm-etiqueta.id-etiqueta = ttWork.num-serial NO-LOCK:
            ASSIGN ttWork.dec-livre-1 = wm-etiqueta.qtd-item - wm-etiqueta.qtd-item-retirado.
        END.

        Assign ttWork.des-endereco = vcodbloco            + '/':U + 
                                     vcodrua              + '/':U + 
                                     vcodnivel            + '/':U + 
                                     vcodcoluna.
        IF ttWork.dec-livre-1 > 0 THEN DO:
			Display ttWork.des-endereco 
					ttWork.dec-livre-1 With Frame {&Frame02Name}.
		END.
		ELSE DO:
			Display ttWork.dec-livre-1 With Frame {&Frame02Name}.
		END.
    
        Assign {&TempTable}.num-serial    = ttWork.num-serial
               {&TempTable}.des-endereco  = ttWork.des-endereco
               {&TempTable}.dat-transacao = TODAY.
        ASSIGN ttWork.des-endereco:READ-ONLY IN FRAME frame02 = YES.   

        Assign vLogFinaliza = No
               vLogSai      = YES
               vLogErro     = NO.
        UPDATE ttWork.num-livre-2 WITH FRAME frame02.
        IF ttWork.num-livre-2 = 777777 THEN DO:
            RUN bcp/bc9023a.p (INPUT ttWork.num-serial).
        END.
    END.
    ELSE DO:

        FOR FIRST wm-etiqueta
            WHERE wm-etiqueta.id-etiqueta = ttWork.num-serial NO-LOCK:
            ASSIGN ttWork.dec-livre-1 = wm-etiqueta.qtd-item - wm-etiqueta.qtd-item-retirado.
        END. 

        FIND FIRST wm-movto-etiqueta NO-LOCK
             WHERE wm-movto-etiqueta.id-etiqueta = ttWork.num-serial NO-ERROR.
        IF AVAIL wm-movto-etiqueta THEN DO:
        
            FIND FIRST wm-box-movto NO-LOCK
                 WHERE wm-box-movto.cod-estabel  = wm-movto-etiqueta.cod-estabel 
                   AND wm-box-movto.cod-local    = wm-movto-etiqueta.cod-local   
                   AND wm-box-movto.id-movto     = wm-movto-etiqueta.id-movto NO-ERROR.
        
            FIND FIRST wm-box NO-LOCK
                 WHERE wm-box.cod-estabel = wm-box-movto.cod-estabel
                   AND wm-box.cod-local   = wm-box-movto.cod-local  
                   AND wm-box.id-box      = wm-box-movto.id-box NO-ERROR.

				IF ttWork.dec-livre-1 > 0 THEN DO:

                    ASSIGN  vMsg = "Etiqueta sugerida para endereco:" + CHR(10) + STRING(wm-box.cod-bloco) + '/' +
                                                                                  STRING(wm-box.cod-rua)   + '/' +
                                                                                  STRING(wm-box.cod-nivel) + '/' +
                                                                                  STRING(wm-box.cod-coluna) +
                                   "    Saldo: " + STRING(ttWork.dec-livre-1).

                    FIND FIRST wms-histor-movto-etiq NO-LOCK 
                         WHERE wms-histor-movto-etiq.id-etiqueta = ttWork.num-serial 
                           AND wms-histor-movto-etiq.ind-tipo-movto = 13 //val13 Transferˆncia Dep¢sito - Sa¡da 
                     NO-ERROR.

                    IF AVAIL wms-histor-movto-etiq THEN 
                       ASSIGN vMsg = "Etiqueta zerada!".
				END.
				ELSE DO:
					ASSIGN vMsg = "Etiqueta zerada!".
				END.
                        
               {bcp/bc9015.i2 STRING(203) vMsg}
        END.
        ELSE DO:
            FIND FIRST wms-docto-item-etiq
                 WHERE wms-docto-item-etiq.id-etiqueta = ttWork.num-serial NO-LOCK NO-ERROR.
            IF NOT AVAIL wms-docto-item-etiq THEN DO:
                ASSIGN  vMsg = "Falta sugestÆo de armazenamento para a Etiqueta." + "     Saldo: " + STRING(ttWork.dec-livre-1).
                {bcp/bc9015.i2 STRING(204) vMsg}
            END.
            ELSE DO:
                UPDATE ttWork.num-livre-2 WITH FRAME frame02.
                IF ttWork.num-livre-2 = 777777 THEN DO:
                    RUN bcp/bc9023a.p (INPUT ttWork.num-serial).
                END.
            END.
        END.
    END.

    ASSIGN vNumBox             = 0
           vCodBloco           = ""
           vCodRua             = ""
           vCodNivel           = ""
           vCodcoluna          = ""
           ttWork.des-endereco = ""
           ttWork.dec-livre-1  = 0
           ttWork.num-livre-2  = 0.

    RETURN 'OK':U.
End Procedure.

PROCEDURE pi-return-value:
    RETURN 'OK':U.
END PROCEDURE.
