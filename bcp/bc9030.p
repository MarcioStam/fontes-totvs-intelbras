/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9030 2.00.00.009 } /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BC9030 MBC}
&ENDIF

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
{cdp/cdcfgmat.i}

/********************************************************************************************
**   Programa..: bc9030.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - Mar‡o/2005 - Marcelo Dumke - Cria‡Æo do programa            **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Transferencia entre depositos WMS**
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

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9030
/************************************************************/

/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
/* &global-define ErrorDisplaySeconds 3  */

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-transfer-serial-wms
{bcp/bc9030.i " "}
{utp/ut-glob.i}
{utp/utapi009.i} /* login */
{bcp/bc9048.i1} /* definicao variaveis menu padrao */
DEF TEMP-TABLE ttWm-Etiqueta       NO-UNDO LIKE wm-etiqueta.

{method/dbotterr.i}
Define NEW Shared Temp-table ttWork No-Undo like {&TempTable}.

Define Variable vLogControlaLogin       As Logical                 Init No  No-undo.
DEFINE VARIABLE wgbcapiwms AS HANDLE.
DEFINE VARIABLE wgbosc070  AS HANDLE.
DEFINE VARIABLE wgbosc074  AS HANDLE.
DEFINE VARIABLE wgwm9700   AS HANDLE.
DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.
/* --- Knupp - Movimenta‡Æo Utilizando Etiquetas --- */
DEFINE VARIABLE h_bosc047               AS HANDLE                           NO-UNDO.
DEFINE VARIABLE l-utiliz-etiq-movto     AS LOGICAL                 INIT NO  NO-UNDO.
DEFINE VARIABLE c-cod-local             AS CHARACTER                        NO-UNDO.

Create ttWork.

DEFINE VARIABLE vcod-senha              AS CHARACTER FORMAT 'x(14)':U              NO-UNDO.
DEFINE VARIABLE c-texto                 AS CHAR FORMAT "x(18)":U.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Transf. Dep¢sito'                                 At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label ~
                             'Sen:'                                             AT ROW 04 COL 01          ~
                             vcod-senha                                         AT ROW 04 COL 05 NO-LABEL ~
                             'Col:'                                             At Row 05 Col 01          ~
                             ttWork.cod-coletor                                 At Row 05 Col 05 No-label ~
                             'Equ:'                                             At Row 06 Col 01          ~
                             ttWork.cod-equipamento                             At Row 06 Col 05 No-label ~
&global-define Frame01Repeat No

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Transf. Dep¢sito'                                 At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Dep. Orig.:'                                      At Row 03 Col 01          ~
                             ttWork.cod-depos-orig                              At Row 03 Col 12 NO-LABEL ~
                             'Localiza‡Æo Origem'                               At Row 04 Col 01          ~
                             ttWork.cod-local-orig                              At Row 05 Col 01 NO-LABEL VIEW-AS FILL-IN SIZE 19 BY 0.88~
                             'Dep. Dest.:'                                      At Row 06 Col 01          ~
                             ttWork.cod-depos-dest                              At Row 06 Col 12 NO-LABEL ~
                             'Localiza‡Æo Destino'                              At Row 07 Col 01          ~
                             ttWork.cod-local-dest                              At Row 08 Col 01 NO-LABEL VIEW-AS FILL-IN SIZE 19 BY 0.88~

&global-define Frame02Repeat No
/************************************************************/

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Transf. Dep¢sito'                                 At Row 01 Col 01           ~
                             '--------------------'                             At Row 02 Col 01           ~
                             'Estab:'                                           At Row 03 Col 01           ~
                              ttWork.cod-estabel                                At Row 03 Col 07 NO-LABELS ~
                             'Documento:'                                       At Row 04 Col 01           ~
                              ttWork.num-docto-transf                           At Row 05 Col 01 NO-LABELS ~
                             
&global-define Frame03Repeat NO

/* Definicao da Frame04 ---                                 */
&global-define Frame04Name   Frame04
&global-define Frame04Defs   'Transf. Dep¢sito'                                 At Row 01 Col 01           ~
                             '--------------------'                             At Row 02 Col 01           ~
                             'Serial'                                           At Row 03 Col 01           ~
                              ttWork.cod-serial                                 At Row 04 Col 01 NO-LABELS ~
                              ttWork.cod-item                                   At Row 05 Col 01 NO-LABELS ~
                              ttWork.qtd-item                                   At Row 06 Col 01 NO-LABELS ~
                              "1-Conf. 2-NConf."                                AT ROW 07 COL 01           ~
                              ttWork.opcao                                      AT ROW 07 COL 17 NO-LABELS ~
                              c-texto                                           AT ROW 08 COL 01 NO-LABELS ~
&global-define Frame04Repeat YES
                                 
/************************************************************/

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vcod-senha WHEN ttWork.cod-usuario = '' ~
                              ttWork.cod-coletor ~
                              ttWork.cod-equipamento

&global-define Update02Fields ttWork.cod-depos-orig 

&global-define Update03Fields ttWork.cod-estabel ttWork.num-docto-trans

&global-define Update04Fields ttWork.cod-serial ttWork.qtd-item ~
                              ttWork.opcao 

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

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ~
                            ON ENTRY OF ttWork.cod-coletor IN FRAME {&Frame01Name} ~
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
                            ON 'LEAVE':U OF ttWork.cod-serial In Frame {&Frame04Name}         ~
                            DO:                                                               ~
                                RUN pi-mostra-item.                                           ~
                            END.                                                              ~
                            ON 'ENTRY':U OF ttWork.opcao In Frame {&Frame04Name}              ~
                            DO:                                                               ~
                                IF vLogErro = YES THEN DO:                                    ~
                                    RETURN NO-APPLY.                                          ~
                                END.                                                          ~
                            END.                                                              ~
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1  wgbcapiwms
&global-define ActiveObject2  wgbosc070
&global-define ActiveObject3  wgbosc074
&global-define ActiveObject4  wgwm9700

/************************************************************/

/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

/****************************************************************************************/

/* BLOCO-WMS:                                    */
/* DO TRANSACTION                                */
/*    ON ERROR  UNDO BLOCO-WMS, LEAVE BLOCO-WMS  */
/*    ON STOP   UNDO BLOCO-WMS, LEAVE BLOCO-WMS  */
/*    ON QUIT   UNDO BLOCO-WMS, LEAVE BLOCO-WMS  */
/*    ON ENDKEY UNDO BLOCO-WMS, LEAVE BLOCO-WMS: */
   {bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
   {bcp/bc9101.i} /* Procedure de atualizacao da transacao            */
/* END.  */
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
    ASSIGN vLogErro = NO
           vLogCancela = NO.
    /* caso tenha sido startado login autom tico */
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
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame02:

    ASSIGN vLogErro = NO
           vLogCancela = NO
           vLogSai = NO.
    ASSIGN ttWork.cod-depos-orig = ''
           ttWork.cod-local-orig = ''
           ttWork.cod-depos-dest = ''
           ttWork.cod-local-dest = ''.

    IF v_cod_usuar_corren = '' THEN RETURN ERROR.
End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame03:

    ASSIGN vLogErro        = NO
           vLogCancela     = NO
           .
    IF ttWork.num-docto-transf = 0 THEN DO:
       IF NOT VALID-HANDLE(wgbosc070) THEN DO:
           Run scbo/bosc070.p Persistent Set wgbosc070       No-error.
           Run openQueryStatic In wgbosc070 (Input "Main":U) No-error.
       END.
       RUN gera-numero-op-manual IN wgbosc070 (OUTPUT ttWork.num-docto-transf). 
       
    END.
    IF ttwork.cod-estabel = "" THEN DO:
       FIND FIRST wm-param NO-LOCK NO-ERROR.
       IF AVAIL wm-param THEN
           ASSIGN ttwork.cod-estabel = wm-param.cod-estabel.
    END.


End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame04}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame04:

    ASSIGN vLogErro        = NO
           vLogCancela     = NO
           .
    ASSIGN ttWork.cod-serial = 0
           ttwork.cod-item   = ""
           ttWork.qtd-item   = 0
           ttWork.opcao      = 0
           .
   ASSIGN  ttwork.cod-item:SCREEN-VALUE IN FRAME FRAME04 = ""
           ttwork.qtd-item:SCREEN-VALUE IN FRAME FRAME04 = "0"
           .
   ASSIGN c-texto:SCREEN-VALUE IN FRAME frame04 = c-texto.
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:
     Assign vLogErro          = NO 
           vLogControlaLogin  = NO.

    /* valida usuario mestre contra mguni do EMS */
    IF ttWork.cod-usuario = ''  THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "0" "Usu rio Inv lido (DC)"}
    END.

    If vLogErro = Yes Then Return Error.
    IF NOT VALID-HANDLE(wgbcapiwms) THEN DO:
       Run bcp/bcapiwms.p Persistent Set wgbcapiwms       No-error.
    END.
    RUN loginuser IN wgbcapiwms (INPUT ttWork.cod-usuario,
                                 INPUT vcod-senha,
                                 OUTPUT TABLE tt-erro).
    IF RETURN-VALUE <> "OK" THEN DO:
       FOR EACH tt-erro NO-LOCK:
           RUN bcp/bc9115.p (tt-erro.cd-erro,tt-erro.mensagem,8,20,3).
           vLogErro = YES.
       END.
    END.

    If vLogErro = Yes Then Return Error.

    RUN validateUser IN wgbcapiwms (INPUT ttWork.cod-usuario,
                                    INPUT 07,
                                    OUTPUT TABLE tt-erro).
    IF RETURN-VALUE <> "OK" THEN DO:
       FOR EACH tt-erro NO-LOCK:
           RUN bcp/bc9115.p (tt-erro.cd-erro,tt-erro.mensagem,8,20,3).
           vLogErro = YES.
       END.
    END.
    
    If vLogErro = Yes Then Return Error.

    IF ttWork.cod-coletor = ''  THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "0" "Coletor Inv lido (DC)"}
    END.

    If  ttWork.cod-equipamento = '' Then Do:
       Assign vLogErro = Yes.
       {bcp/bc9105.i "0" "Equipamento Inv lido (DC)"}
    End.


    RUN VALIDATEequipament IN wgbcapiwms (INPUT ttWork.cod-coletor,
                                          INPUT ttWork.cod-equipamento,
                                          OUTPUT ttWork.tipo-equipamento,
                                          OUTPUT TABLE tt-erro).
    IF RETURN-VALUE <> "OK" THEN DO:
       FOR EACH tt-erro NO-LOCK:
           RUN bcp/bc9115.p (tt-erro.cd-erro,tt-erro.mensagem,8,20,3).
           vLogErro = YES.
       END.
    END.

    If vLogErro = Yes Then Return Error.

    Assign  {&TempTable}.cod-usuario      = ttWork.cod-usuario 
            {&TempTable}.cod-coletor      = ttWork.cod-coletor
            {&TempTable}.cod-equipamento  = ttWork.cod-equipamento
            {&TempTable}.tipo-equipamento = ttWork.tipo-equipamento
             .

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame02:

IF ttWork.cod-depos-orig = '' THEN DO:
    Assign vLogErro = Yes.
    {bcp/bc9105.i "0" "Deposito Origem deve ser informado. (DC)"}
    Return Error.
END.

FIND FIRST deposito WHERE deposito.cod-depos = ttWork.cod-depos-orig NO-LOCK NO-ERROR.

IF NOT AVAIL deposito THEN DO:
    Assign vLogErro = Yes.
    RUN bcp/bc9115.p (0,"Deposito Origem " + ttWork.cod-depos-orig + " inv lido. (DC)",8,20,3).
    Return Error.
END.
   
IF &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN 
         deposito.log-gera-wms = NO 
    &ELSE 
            deposito.log-2 = NO 
    &ENDIF 
    THEN DO ON ENDKEY UNDO, RETURN ERROR:
    UPDATE ttWork.cod-local-orig NO-LABELS WITH FRAME {&Frame02Name}.
    ASSIGN c-texto = "".
END.
ELSE DO:
     ASSIGN c-texto = "888888 - Lib Docto".
END.

DO ON ENDKEY UNDO, RETURN ERROR:
   UPDATE ttWork.cod-depos-dest NO-LABELS WITH FRAME {&Frame02Name}.
END.

IF ttWork.cod-depos-dest = '' 
THEN DO:
    Assign vLogErro = Yes.
    {bcp/bc9105.i "0" "Deposito Detino deve ser informado. (DC)"}
    Return Error.
END.

FIND FIRST deposito WHERE deposito.cod-depos = ttWork.cod-depos-dest NO-LOCK NO-ERROR.

IF NOT AVAIL deposito THEN DO:
    Assign vLogErro = Yes.
    RUN bcp/bc9115.p (0,"Deposito Destino " + ttWork.cod-depos-dest + " inv lido. (DC)",8,20,3).
    Return Error.
END.

IF &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN 
         deposito.log-gera-wms = NO 
   &ELSE 
            deposito.log-2 = NO 
   &ENDIF 
   THEN DO ON ENDKEY UNDO, RETURN ERROR:
   UPDATE ttWork.cod-local-dest NO-LABELS WITH FRAME {&Frame02Name}.
END.

IF ttWork.cod-depos-orig = ttWork.cod-depos-dest THEN DO:
    Assign vLogErro = Yes.
    {bcp/bc9105.i "0" "Deposito Origem e Destino nao pode ser igual. (DC)"}
    Return Error.
END.

ASSIGN {&temptable}.cod-depos-orig = ttwork.cod-depos-orig
       {&temptable}.cod-local-orig = ttwork.cod-local-orig
       {&temptable}.cod-depos-dest = ttwork.cod-depos-dest
       {&temptable}.cod-local-dest = ttwork.cod-local-dest.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame03:

IF ttWork.cod-estabel = '' 
THEN DO:
    Assign vLogErro = Yes.
    {bcp/bc9105.i "0" "Estabelecimento deve ser informada. (DC)"}
    Return Error.
END.

FIND FIRST estabelec WHERE estabelec.cod-estabel = ttwork.cod-estabel
    NO-LOCK NO-ERROR.

IF NOT AVAIL estabelec THEN  DO:
    Assign vLogErro = Yes.
    {bcp/bc9105.i "0" "C¢digo do estabelecimento inv lido. (DC)"}
    Return Error.
END.


IF ttWork.num-docto-transf = 0 
THEN DO:
    Assign vLogErro = Yes.
    {bcp/bc9105.i "0" "Numero do documento de transferencia deve ser informada. (DC)"}
    Return Error.
END.

IF NOT VALID-HANDLE(wgwm9700) THEN DO:
   Run wmp/wm9700.p Persistent Set wgwm9700       No-error.
   Run openQueryStatic In wgwm9700 (Input "Main":U) No-error.
END.

RUN validaDoctoTransf IN wgwm9700 (INPUT  ttwork.cod-estabel,
                                   INPUT  ttwork.cod-depos-orig,
                                   INPUT  ttwork.cod-depos-dest,
                                   INPUT  ttwork.num-docto-transf,
                                   OUTPUT TABLE RowErrors).
IF  RETURN-VALUE = "NOK":U THEN DO:
    Assign vLogErro = Yes.
    FOR EACH RowErrors NO-LOCK:
         
        RUN bcp/bc9115.p (RowErrors.ErrorNum,RowErrors.ErrorDescription,8,20,3).
    
    END.
    Return Error.
END.

/* --- Knupp - Movimenta‡Æo Utilizando Etiquetas --- */
IF NOT VALID-HANDLE(h_bosc047) THEN DO:
    RUN scbo/bosc047.p PERSISTENT SET h_bosc047.
    RUN openQueryStatic IN h_bosc047 (INPUT "Main":U) NO-ERROR.
END.
/* --- Knupp - Movimenta‡Æo Utilizando Etiquetas --- */
run getLocalDepositoEstab in h_bosc047 (input  ttWork.cod-estabel,
                                        input  ttWork.cod-depos-orig,
                                        output c-cod-local).
RUN verificarUtilizaEtiqMovto IN h_bosc047(INPUT ttWork.cod-estabel,
                                           INPUT c-cod-local,
                                           OUTPUT l-utiliz-etiq-movto).
IF VALID-HANDLE (h_bosc047) THEN DO:
    DELETE OBJECT h_bosc047.
END.
IF NOT l-utiliz-etiq-movto THEN DO:
    {bcp/bc9105.i "51820" "Deposito origem nÆo utiliza etiquetas!"}
    RETURN ERROR.
END.

ASSIGN {&temptable}.num-docto-transf = ttwork.num-docto-transf
       {&temptable}.cod-estabel      = ttwork.cod-estabel.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 04.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame04:

DEF VAR hDBOsc170       AS HANDLE               NO-UNDO.
DEF VAR l-lib-ret       AS LOGICAL              NO-UNDO.
DEF VAR c-cod-estabel   LIKE wm-box.cod-estabel NO-UNDO.
DEF VAR c-cod-local     LIKE wm-box.cod-local   NO-UNDO.
DEF VAR d-id-box        LIKE wm-box.id-box      NO-UNDO.

IF ttWork.cod-SERIAL = 0 
THEN DO:
    Assign vLogErro = Yes.
    {bcp/bc9105.i "0" "Etiqueta deve ser informada. (DC)"}
    Return Error.
END.

IF ttWork.opcao <> 1 AND ttWork.opcao <> 2 THEN DO:
    Assign vLogErro = Yes.
    {bcp/bc9105.i "0" "Opcao invalida. (DC)"}
    Return Error.

END.

/* Verifica se a etiqueta existe e pega dados da etiqueta */
IF ttWork.opcao = 1 THEN DO:
    ASSIGN {&temptable}.cod-item   = ttWork.cod-item
           {&temptable}.qtd-item   = ttWork.qtd-item
           {&temptable}.cod-serial = ttwork.cod-serial
              .
    
    /* Rodar metodo da logista para validar a etiqueta */ 
    IF  ttwork.cod-serial <> 888888 THEN DO:

        /* Validando Bloqueio Endereco */
        ASSIGN c-cod-estabel = ""
               c-cod-local   = ""
               d-id-box      = 0 
               l-lib-ret     = NO.

        FIND FIRST wm-box-saldo-etiqueta WHERE
            wm-box-saldo-etiqueta.id-etiqueta = ttWork.cod-serial NO-LOCK NO-ERROR.
        IF AVAIL wm-box-saldo-etiqueta THEN DO:
            FIND FIRST wm-box OF wm-box-saldo-etiqueta NO-LOCK NO-ERROR.
            FIND FIRST usuario-scm WHERE usuario-scm.usuario = ttWork.cod-usuario NO-LOCK NO-ERROR.
            IF AVAIL wm-box      AND wm-box.log-bloq-ret = YES AND
               AVAIL usuario-scm AND usuario-scm.log-2   = YES THEN DO:

                IF NOT VALID-HANDLE(hDBOsc170) THEN
                    RUN scbo/bosc170.p PERSISTENT SET hDBOsc170.

                IF wm-box.log-bloq-ret = YES THEN DO:
                    RUN liberarRetirada IN hDBOsc170 (INPUT wm-box.cod-estabel,
                                                      INPUT wm-box.cod-local,
                                                      INPUT wm-box.id-box,
                                                      INPUT "Transferencia Deposito - Liberacao Automatica").
                    IF RETURN-VALUE = "OK" THEN DO:
                        ASSIGN c-cod-estabel = wm-box.cod-estabel
                               c-cod-local   = wm-box.cod-local
                               d-id-box      = wm-box.id-box
                               l-lib-ret     = YES.
                        FIND CURRENT wm-box EXCLUSIVE-LOCK NO-ERROR.
                        ASSIGN wm-box.log-bloq-ret = NO.
                    END.
                END.

                IF VALID-HANDLE(hDBOsc170) THEN
                    DELETE OBJECT hDBOsc170.

            END.
        END.

        EMPTY TEMP-TABLE RowErrors.
        
        RUN validaTransfEtiqueta IN wgwm9700 (INPUT {&Temptable}.cod-estabel,
                                              INPUT {&temptable}.cod-depos-orig,
                                              INPUT {&temptable}.cod-local-orig,
                                              INPUT {&temptable}.cod-depos-dest,
                                              INPUT {&temptable}.cod-local-dest,
                                              INPUT {&temptable}.cod-serial,
                                              INPUT {&temptable}.qtd-item,
                                              OUTPUT TABLE RowErrors).

        IF RETURN-VALUE <> "OK":U THEN DO:

            /* Desfazendo Liberacao em Caso de ERRO */
            IF l-lib-ret = YES THEN DO:

                FIND FIRST wm-box-saldo-etiqueta WHERE
                    wm-box-saldo-etiqueta.id-etiqueta = ttWork.cod-serial NO-LOCK NO-ERROR.
                IF AVAIL wm-box-saldo-etiqueta THEN DO:
                    
                    IF NOT VALID-HANDLE(hDBOsc170) THEN
                        RUN scbo/bosc170.p PERSISTENT SET hDBOsc170.
    
                    RUN bloquearRetirada IN hDBOsc170 (INPUT wm-box-saldo-etiqueta.cod-estabel,
                                                       INPUT wm-box-saldo-etiqueta.cod-local,
                                                       INPUT wm-box-saldo-etiqueta.id-box,
                                                       INPUT 1, /*Manual*/
                                                       INPUT "Transferencia Deposito - Retorno Erro Liberacao Automatica").
                    IF RETURN-VALUE = "OK":U THEN DO:
                        FIND FIRST wm-box OF wm-box-saldo-etiqueta EXCLUSIVE-LOCK NO-ERROR.
                        IF AVAIL wm-box THEN
                            ASSIGN wm-box.log-bloq-ret = YES.
                    END.
            
                    IF VALID-HANDLE(hDBOsc170) THEN
                        DELETE OBJECT hDBOsc170.

                END.
            END.

            For Each RowErrors:
                ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                ASSIGN vLogErro = YES.
                RUN bcp/bc9115.p (ErrorNumber,ErrorDescription,8,20,3).
                RETURN ERROR.
            END.
        END.
    
    END.
            
    
    Assign vTransDetail = " SERIAL:" + STRING({&temptable}.cod-serial) +
                          " IT:"     + {&temptable}.cod-item +
                          " QTD:"    + STRING({&temptable}.qtd-item) + 
                          " DOCTO:" + string({&temptable}.num-docto-transf)
                          .  
                                   
    Assign {&TempTable}.data-transacao  = Today
           .
    
    Raw-transfer {&TempTable} To vConteudoRaw.
    
    Run _GenerateDCTransaction (Input vTransaction,              /* Codigo da Transacao                   */
                                Input vConteudoRaw,              /* Conteudo da temp-table {&TempTable}   */
                                Input vTransDetail,              /* Cabecalho de detalhes da transacao    */
                                Input {&TempTable}.cod-usuario). /* Usuario responsavel pela transacao    */
     
    FIND FIRST tt-erro-after-GenerateDC NO-LOCK NO-ERROR.

    IF NOT AVAIL tt-erro-after-GenerateDC AND {&temptable}.cod-serial = 888888 THEN DO:
        RUN bcp/bc9115.p (0,"Documento Liberado com Sucesso.",8,20,3).
    END.
    IF NOT AVAIL tt-erro-after-GenerateDC AND {&temptable}.cod-serial <> 888888 THEN DO:
        RUN bcp/bc9115.p (0,"Etiqueta transferida com sucesso.",8,20,3).
    END.
    
    /* Desfazendo Liberacao em Caso de ERRO */
    IF l-lib-ret = YES AND
       CAN-FIND(FIRST wm-box-saldo WHERE
                wm-box-saldo.cod-estabel = c-cod-estabel AND
                wm-box-saldo.cod-local   = c-cod-local   AND
                wm-box-saldo.id-box      = d-id-box      NO-LOCK) THEN DO:

        IF NOT VALID-HANDLE(hDBOsc170) THEN
            RUN scbo/bosc170.p PERSISTENT SET hDBOsc170.

        RUN bloquearRetirada IN hDBOsc170 (INPUT c-cod-estabel,
                                           INPUT c-cod-local,
                                           INPUT d-id-box,
                                           INPUT 1, /*Manual*/
                                           INPUT "Transferencia Deposito - Saldo Remanescente Liberacao Automatica").
        IF RETURN-VALUE = "OK":U THEN DO:
            FIND FIRST wm-box WHERE 
                wm-box.cod-estabel = c-cod-estabel AND
                wm-box.cod-local   = c-cod-local   AND
                wm-box.id-box      = d-id-box      EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL wm-box THEN
                ASSIGN wm-box.log-bloq-ret = YES.
        END.


        IF VALID-HANDLE(hDBOsc170) THEN
            DELETE OBJECT hDBOsc170.
        
    END.

END.
ELSE DO:
   ASSIGN ttWork.opcao = 0.
END.
End Procedure.

PROCEDURE pi-mostra-item:

IF ttwork.cod-serial:SCREEN-VALUE IN FRAME {&frame04name} <> "888888" THEN DO:
    EMPTY TEMP-TABLE RowErrors.
    
    IF NOT VALID-HANDLE(wgbosc074) THEN DO:
       Run scbo/bosc074.p Persistent Set wgbosc074       No-error.
       Run openQueryStatic In wgbosc074 (Input "Main":U) No-error.
    END.
    
    RUN getInfoEtiqueta IN wgbosc074 (INPUT decimal(ttwork.cod-serial:SCREEN-VALUE IN FRAME {&frame04name}), ~
                                      OUTPUT TABLE ttwm-etiqueta).                                ~
    
    IF RETURN-VALUE <> "OK":U THEN DO:
        Run getrowErrors In wgbosc074 (output Table RowErrors).
        For Each RowErrors:
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            ASSIGN vLogErro = YES.
            RUN bcp/bc9115.p (ErrorNumber,ErrorDescription,8,20,3).
            RETURN ERROR.
        END.
    END.
    ELSE DO:
       FIND FIRST ttwm-etiqueta NO-LOCK NO-ERROR.
       IF AVAIL ttwm-etiqueta THEN DO:                                                            ~
          ASSIGN ttwork.cod-item = ttwm-etiqueta.cod-item                                         ~
                 ttWork.qtd-item = ttwm-etiqueta.qtd-item - ttwm-etiqueta.qtd-item-retirado.      ~
          DISP ttwork.cod-item  ttWork.qtd-item WITH FRAME {&FRAME04NAME}.                        ~
                                                                                              ~
       END.                                                                                       ~
    END.                                                                                          ~
END.
END PROCEDURE.

/*************************************  Codigo do Usuario Fim   ********************************/

