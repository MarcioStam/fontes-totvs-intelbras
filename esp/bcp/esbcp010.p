/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esbcp010 3.00.00.000 } /*** 010009 ***/

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
&global-define ProgramName esbcp010
/************************************************************/

/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
/* &global-define ErrorDisplaySeconds 3  */

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-transfer-serial-wms
{bcp/bc9030.i " "}
{wmp/wm9000.i}
{scbo/bosc035exi.i "tt-wm-box-saldo"}

{utp/ut-glob.i}
//{utp/utapi009.i} /* login */
{bcp/bc9048.i1} /* definicao variaveis menu padrao */
{cep/ceapi001k.i}
DEF TEMP-TABLE ttBoWm-Etiqueta       NO-UNDO LIKE wm-etiqueta.
DEFINE VARIABLE h-bosc035exi AS HANDLE      NO-UNDO.
def temp-table tt-tarefa-docto no-undo
    field CodUsuario     like wm-tarefa-docto-itens.cod-usuario     
    field CodEquipamento like wm-tarefa-docto-itens.cod-equipamento 
    field CodColetor     like wm-tarefa-docto-itens.cod-coletor     
    field TempoInicio    as integer.
def temp-table tt-etiqueta no-undo
    field id-etiqueta    like wm-etiqueta.id-etiqueta
    field qtd-retirada   like wm-etiqueta.qtd-item 
    index codigo is unique id-etiqueta.

{method/dbotterr.i}
Define NEW Shared Temp-table ttWork No-Undo like {&TempTable}.
DEFINE NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHARACTER    NO-UNDO.
DEFINE VARIABLE codSerial           AS DECIMAL      NO-UNDO.
DEFINE VARIABLE h-bosc074           AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-wm9005a           AS HANDLE       NO-UNDO.
DEFINE VARIABLE logCQArmazenado     AS LOGICAL      NO-UNDO.


Define Variable vLogControlaLogin       As Logical                 Init No  No-undo.
DEFINE VARIABLE wgbcapiwms AS HANDLE.
DEFINE VARIABLE wgbosc070  AS HANDLE.
DEFINE VARIABLE wgbosc074  AS HANDLE.
DEFINE VARIABLE wgwm9700   AS HANDLE.
DEFINE VARIABLE wgwm9701   AS HANDLE.

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
&global-define Frame01Defs   'Trans Rejeito CQ Ser'                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label ~
                             'Sen:'                                             AT ROW 04 COL 01          ~
                             vcod-senha                                         AT ROW 04 COL 05 NO-LABEL ~
                             'Col:'                                             At Row 05 Col 01          ~
                             ttWork.cod-coletor                                 At Row 05 Col 05 No-label ~
                             'Equ:'                                             At Row 06 Col 01          ~
                             ttWork.cod-equipamento                             At Row 06 Col 05 No-label ~
                             'Est:'                                             AT ROW 07 COL 01          ~
                             ttWork.cod-estabel                                 AT ROW 07 COL 05 NO-LABEL ~
&global-define Frame01Repeat No

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Trans Rejeito CQ Ser'                             At Row 01 Col 01          ~
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
&global-define Frame03Defs   'Trans Rejeito CQ Ser'                             At Row 01 Col 01           ~
                             '--------------------'                             At Row 02 Col 01           ~
                             'Serial'                                           At Row 03 Col 01           ~
                              ttWork.cod-serial                                 At Row 04 Col 01 NO-LABELS ~
                              ttWork.cod-item                                   At Row 05 Col 01 NO-LABELS ~
                              ttWork.qtd-item                                   At Row 06 Col 01 NO-LABELS ~
                              "1-Conf. 2-NConf."                                AT ROW 07 COL 01           ~
                              ttWork.opcao                                      AT ROW 07 COL 17 NO-LABELS ~
                              c-texto                                           AT ROW 08 COL 01 NO-LABELS ~
&global-define Frame03Repeat YES
                                 
/************************************************************/

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vcod-senha WHEN ttWork.cod-usuario = '' ~
                              ttWork.cod-coletor ~
                              ttWork.cod-equipamento ~
                              ttWork.cod-estabel

&global-define Update02Fields ttWork.cod-depos-orig 

&global-define Update03Fields ttWork.cod-serial ~
                              ttWork.opcao

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02.
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02.  
&global-define TriggerAfterFrame03  Run GravaCamposFrame03. 

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
                            ON 'LEAVE':U OF ttWork.cod-serial In Frame {&Frame03Name}         ~
                            DO:                                                               ~
                                RUN pi-mostra-item.                                           ~
                            END.                                                              ~
                            ON 'ENTRY':U OF ttWork.opcao In Frame {&Frame03Name}              ~
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
    ASSIGN ttWork.cod-estabel = '104'.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame02:

    FIND FIRST estabelec
         WHERE estabelec.cod-estabel = ttWork.cod-estabel
        NO-LOCK NO-ERROR.
    ASSIGN vLogErro = NO
           vLogCancela = NO
           vLogSai = NO.
    ASSIGN ttWork.cod-depos-orig = "WEX" //IF AVAIL estabelec THEN estabelec.dep-rej-cq ELSE ''
           ttWork.cod-local-orig = ''
           ttWork.cod-depos-dest = ''
           ttWork.cod-local-dest = ''.

    IF v_cod_usuar_corren = '' THEN RETURN ERROR.
End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBefore}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame03:

    ASSIGN vLogErro        = NO
           vLogCancela     = NO
           .
    ASSIGN ttWork.cod-serial = 0
           ttwork.cod-item   = ""
           ttWork.qtd-item   = 0
           ttWork.opcao      = 0
           .
   ASSIGN  ttwork.cod-item:SCREEN-VALUE IN FRAME FRAME03 = ""
           ttwork.qtd-item:SCREEN-VALUE IN FRAME FRAME03 = "0"
           .
   ASSIGN c-texto:SCREEN-VALUE IN FRAME frame03 = c-texto.
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
            {&TempTable}.cod-estabel      = ttWork.cod-estabel
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
** na tela Frame 04.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame03:

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

   IF NOT VALID-HANDLE(wgbosc070) THEN DO:
       Run scbo/bosc070.p Persistent Set wgbosc070       No-error.
       Run openQueryStatic In wgbosc070 (Input "Main":U) No-error.
   END.
   
   RUN gera-numero-op-manual IN wgbosc070 (OUTPUT ttWork.num-docto-transf).

    ASSIGN {&temptable}.cod-item   = ttWork.cod-item
           {&temptable}.qtd-item   = ttWork.qtd-item
           {&temptable}.cod-serial = ttwork.cod-serial
           {&temptable}.num-docto-transf = ttWork.num-docto-transf.
              .

    /* Rodar metodo da logista para validar a etiqueta */ 
    IF  ttwork.cod-serial <> 888888 THEN DO:
        EMPTY TEMP-TABLE RowErrors.
        
        FIND FIRST ttBoWm-Etiqueta NO-LOCK NO-ERROR.
        IF AVAIL ttBoWm-Etiqueta
        THEN DO:
            FOR  EACH wm-movto-etiqueta USE-INDEX idx-wm-movto-etiqueta2
                WHERE wm-movto-etiqueta.id-etiqueta = ttBoWm-Etiqueta.id-etiqueta.

                FOR  EACH Wm-box-movto NO-LOCK
                    WHERE Wm-box-movto.cod-estabel      = wm-movto-etiqueta.cod-estabel
                      AND Wm-box-movto.cod-local        = wm-movto-etiqueta.cod-local
                      AND Wm-box-movto.id-movto         = wm-movto-etiqueta.id-movto
                      AND Wm-box-movto.ind-tipo-movto   = 1.  //Entrada

                    FIND FIRST wm-docto
                         WHERE wm-docto.id-docto = Wm-box-movto.id-docto
                        NO-LOCK NO-ERROR.

                    RUN piAtualidaEstoque.

                    IF RETURN-VALUE <> "OK" THEN DO:
                        RETURN ERROR.
                    END.

                    RUN atualizaQtdRejEtiqueta IN wgbosc074 (INPUT v_cod_usuar_corren,
                                                             INPUT ttBoWm-Etiqueta.id-etiqueta,
                                                             INPUT ttwork.qtd-item).

                    IF RETURN-VALUE <> "OK" THEN DO:
                        MESSAGE "Erro-2"
                            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                        RETURN ERROR.
                    END.

                    /*RUN piCriaDoctoWMS.
                    IF RETURN-VALUE <> "OK" THEN DO:
                        MESSAGE "Erro-3"
                            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                        RETURN ERROR.
                    END.
                    */
                    
                END.
            END.
        END.

        //IF VALID-HANDLE(h-bosc074) THEN DELETE OBJECT h-bosc074.
        IF VALID-HANDLE(wgbosc070) THEN DELETE OBJECT wgbosc070.

    END.

    Assign vTransDetail = " SERIAL:" + STRING({&temptable}.cod-serial) +
                          " IT:"     + {&temptable}.cod-item +
                          " QTD:"    + STRING({&temptable}.qtd-item) + 
                          " DOCTO:" + string({&temptable}.num-docto-transf)
                          .  
                                   
    Assign {&TempTable}.data-transacao  = Today.
    
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
    
END.
ELSE DO:
   ASSIGN ttWork.opcao = 0.
END.
End Procedure.


/*************************************************************************************************** 
****************************************************************************************************
***************************************************************************************************/
PROCEDURE pi-mostra-item:


IF ttwork.cod-serial:SCREEN-VALUE IN FRAME {&frame03name} <> "888888" THEN DO:
    EMPTY TEMP-TABLE RowErrors.
    
    IF NOT VALID-HANDLE(wgbosc074) THEN DO:
       Run scbo/bosc074.p Persistent Set wgbosc074       No-error.
       Run openQueryStatic In wgbosc074 (Input "Main":U) No-error.
    END.
    
    RUN getInfoEtiqueta IN wgbosc074 (INPUT decimal(ttwork.cod-serial:SCREEN-VALUE IN FRAME {&frame03name}), ~
                                      OUTPUT TABLE ttBoWm-Etiqueta).                                ~
    
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
       FIND FIRST ttBoWm-Etiqueta NO-LOCK NO-ERROR.
       IF AVAIL ttBoWm-Etiqueta THEN DO:                                                            ~
          ASSIGN ttwork.cod-item = ttBoWm-Etiqueta.cod-item                                         ~
                 ttWork.qtd-item = ttBoWm-Etiqueta.qtd-item - ttBoWm-Etiqueta.qtd-item-retirado.      ~
          DISP ttwork.cod-item  ttWork.qtd-item WITH FRAME {&FRAME03NAME}.                        ~
                                                                                              ~
       END.                                                                                       ~
    END.                                                                                          ~
END.
END PROCEDURE.

/*************************************  Codigo do Usuario Fim   ********************************/

/*************************************************************************************************** 
****************************************************************************************************
***************************************************************************************************/
PROCEDURE piAtualidaEstoque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var i-insp        as integer no-undo.
    def var i-var-aux     as integer no-undo.
    def var i-var-aux-tot as integer no-undo.
    DEF VAR l-retorno     AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO.
    def var l-leitura-item-fornec-estab as logical INIT NO                  no-undo.
    DEFINE VARIABLE l-deleta-erros AS LOGICAL     NO-UNDO.

    DEFINE VARIABLE h-ceapi001k AS HANDLE      NO-UNDO.
    IF  NOT VALID-HANDLE(h-ceapi001k) THEN
        RUN cep/ceapi001k.p persistent set h-ceapi001k.

    find first param-estoq NO-LOCK no-error.

    for each tt-movto:
        delete tt-movto.
    end.

    find first saldo-estoq
        where  saldo-estoq.it-codigo   = Wm-box-movto.cod-item   
        and    saldo-estoq.cod-estabel = Wm-box-movto.cod-estabel
        and    saldo-estoq.cod-depos   = ttwork.cod-depos-orig
        //and    saldo-estoq.cod-localiz = saldo-estoq.cod-localiz
        //and    saldo-estoq.lote        = saldo-estoq.lote
        //AND    saldo-estoq.cod-refer   = saldo-estoq.cod-refer
        EXCLUSIVE-LOCK no-error.

    /* Valida»’o Imposta */
    Bloco_WMS:
    DO ON ERROR UNDO,  return 'ADM-ERROR':U:
        /* ATUALIZA MOVIMENTA°€O DO ESTOQUE - SA™DA DO CQ - ORIGEM */
        create tt-movto.
        find estab-mat where
             estab-mat.cod-estabel = Wm-box-movto.cod-estabel
             no-lock no-error.
        assign tt-movto.ct-codigo = estab-mat.cod-cta-transf-unif
               tt-movto.sc-codigo = estab-mat.cod-ccusto-transf-unif.               

        FIND FIRST ITEM WHERE ITEM.it-codigo = Wm-box-movto.cod-item NO-LOCK NO-ERROR.
        ASSIGN tt-movto.cod-versao-integracao = 1 
               tt-movto.dt-trans       = TODAY
               tt-movto.nro-docto      = wm-docto.num-docto
               tt-movto.serie-docto    = wm-docto.serie
               tt-movto.cod-depos      = ttwork.cod-depos-orig
               tt-movto.cod-estabel    = wm-docto.cod-estabel
               tt-movto.it-codigo      = Wm-box-movto.cod-item
               tt-movto.cod-localiz    = saldo-estoq.cod-localiz
               tt-movto.lote           = saldo-estoq.lote
               tt-movto.dt-vali-lote   = saldo-estoq.dt-vali-lote
               tt-movto.cod-refer      = Wm-box-movto.cod-refer
               tt-movto.quantidade     = ttwork.qtd-item
               tt-movto.un             = item.un
               tt-movto.esp-docto      = 33
               tt-movto.tipo-trans     = 2
               tt-movto.descricao-db   = ""
               tt-movto.cod-prog-orig  = "esbcp010"
               tt-movto.cod-emitente   = 0
               tt-movto.usuario        = c-seg-usuario.
            
         /* ATUALIZA MOVIMENTA°€O DE ESTOQUE - DESTINO */
        create tt-movto.
        find estab-mat where
             estab-mat.cod-estabel = Wm-box-movto.cod-estabel
             no-lock no-error.     
        assign tt-movto.ct-codigo = estab-mat.cod-cta-transf-unif
               tt-movto.sc-codigo = estab-mat.cod-ccusto-transf-unif.                           
        assign tt-movto.cod-versao-integracao = 1
               tt-movto.dt-trans      = TODAY                     
               tt-movto.nro-docto     = wm-docto.num-docto
               tt-movto.serie-docto   = wm-docto.serie
               tt-movto.cod-depos     = ttwork.cod-depos-dest
               tt-movto.cod-estabel   = wm-docto.cod-estabel      
               tt-movto.it-codigo     = Wm-box-movto.cod-item        
               tt-movto.cod-localiz   = saldo-estoq.cod-localiz      
               tt-movto.lote          = saldo-estoq.lote             
               tt-movto.dt-vali-lote  = saldo-estoq.dt-vali-lote  
               tt-movto.cod-refer     = Wm-box-movto.cod-refer        
               tt-movto.quantidade    = ttwork.qtd-item           
               tt-movto.un            = item.un                   
               tt-movto.esp-docto     = 33
               tt-movto.tipo-trans    = 1
               tt-movto.descricao-db  = ""
               tt-movto.cod-prog-orig = "esbcp010"
               tt-movto.usuario       = c-seg-usuario
               tt-movto.cod-emitente  = 0
               l-deleta-erros         = YES.

            // Atualiza qt-aloc-prod para poder fazer a transferencia
            ASSIGN saldo-estoq.qt-aloc-prod = saldo-estoq.qt-aloc-prod - ttwork.qtd-item.
            IF saldo-estoq.qt-aloc-prod < 0 THEN
                ASSIGN saldo-estoq.qt-aloc-prod = 0.
            
                   
            IF  VALID-HANDLE (h-ceapi001k) THEN DO:
                RUN pi-execute IN h-ceapi001k (input-output table tt-movto,
                                               input-output table tt-erro, 
                                               input              l-deleta-erros).
            END.
                
        /* CHAMADA DO BROWSE QUE MOSTRA AS INCONSISTãNCIAS DE CRIA°€O DO MOVTO-ESTOQ */

        if  RETURN-VALUE = "NOK":U
        OR  avail tt-erro
        then do:
            FOR EACH tt-erro:
                IF tt-erro.cd-erro = 27607 THEN DELETE tt-erro.
            END.

            IF CAN-FIND(FIRST tt-erro)
            THEN DO:
                FOR FIRST tt-erro: END.
                RUN bcp/bc9115.p (0,"Erro:" + STRING(tt-erro.mensagem),8,20,3).
                IF  VALID-HANDLE(h-ceapi001k) THEN
                    DELETE OBJECT h-ceapi001k.
                RETURN "NOK".
            END.
            RETURN "OK".
        end.
    END.

    IF  VALID-HANDLE(h-ceapi001k) THEN
        DELETE OBJECT h-ceapi001k.

    RETURN "OK".

END PROCEDURE.

/****************************************************************************************************/
/****************************************************************************************************/
/****************************************************************************************************
PROCEDURE piCriaDoctoWMS:

    EMPTY TEMP-TABLE ttWm-docto.
    EMPTY TEMP-TABLE ttWm-docto-itens.
    EMPTY TEMP-TABLE ttwm-etiqueta.
    EMPTY TEMP-TABLE tt-etiqueta.
    EMPTY TEMP-TABLE tt-tarefa-docto.

    CREATE ttWm-docto.
    ASSIGN ttWm-docto.cod-estabel      = Wm-box-movto.cod-estabel
           ttWm-docto.cod-local        = Wm-box-movto.cod-local
           ttWm-docto.num-docto        = STRING(wm-docto.num-docto)
           ttWm-docto.ind-origem-docto = 8. /* Transferˆncia Destino */

    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-dat-atz-movto-est-wms" AND funcao.ativo = YES) THEN 
        ASSIGN ttWm-docto.log-dat-atualiz-movto-estoq = YES.
    ELSE
        ASSIGN ttWm-docto.log-dat-atualiz-movto-estoq = NO.

    IF ttWm-docto.id-docto = 0 THEN 
        ASSIGN ttWm-docto.alteracao = NO.
    ELSE 
        ASSIGN ttWm-docto.alteracao = YES
               ttWm-docto.id-docto = Wm-box-movto.id-docto.

    ASSIGN ttWm-docto.ind-tipo-trans = 2       /* Sa¡da */
           ttWm-docto.cod-depos = ttWork.cod-depos-orig.

    CREATE ttWm-docto-itens.
    ASSIGN ttWm-docto-itens.cod-estabel   = ttWm-docto.cod-estabel
           ttWm-docto-itens.cod-local     = ttWm-docto.cod-local
           ttWm-docto-itens.num-docto     = ttWm-docto.num-docto
           ttWm-docto-itens.id-docto      = ttWm-docto.id-docto
           ttWm-docto-itens.cod-cliente   = 0
           ttWm-docto-itens.cod-item      = Wm-box-movto.cod-item
           ttWm-docto-itens.cod-refer     = Wm-box-movto.cod-refer
           ttWm-docto-itens.cod-lote      = Wm-box-movto.cod-lote
           ttWm-docto-itens.qtd-item      = ttWork.qtd-item
           ttWm-docto-itens.num-seq-orig  = Wm-box-movto.num-seq
           ttWm-docto-itens.gera-sugestao = NO
           ttWm-docto-itens.dt-atualizacao = TODAY.

    IF ttWm-docto.id-docto = 0 THEN
        ASSIGN ttWm-docto-itens.num-seq-item = 10.
    ELSE 
        ASSIGN ttWm-docto-itens.num-seq-item = 0.

    RUN wmp/wm9000.p (INPUT-OUTPUT TABLE ttWm-docto,
                      INPUT-OUTPUT TABLE ttWm-docto-itens,
                      INPUT-OUTPUT TABLE ttwm-etiqueta,
                      OUTPUT TABLE RowErrors ).        

    IF CAN-FIND(FIRST RowErrors 
                WHERE RowErrors.ErrorSubType = "ERROR":U)
    THEN DO:
        For Each RowErrors:
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            ASSIGN vLogErro = YES.
            RUN bcp/bc9115.p (ErrorNumber,ErrorDescription,8,20,3).
            RETURN "NOK".
        END.
    END.
    ELSE DO:

        FOR FIRST ttBoWm-etiqueta. END.

        FIND FIRST ttWm-docto NO-LOCK NO-ERROR.

        FIND FIRST wm-docto
             WHERE wm-docto.cod-estabel = ttWm-docto.cod-estabel
               AND wm-docto.cod-local   = ttWm-docto.cod-local  
               AND wm-docto.id-docto    = ttWm-docto.id-docto  NO-LOCK NO-ERROR.

        IF  AVAIL wm-docto THEN DO:

            IF  NOT VALID-HANDLE(h-bosc035exi)                  OR
                h-bosc035exi:TYPE      <> "PROCEDURE":U         OR
                h-bosc035exi:FILE-NAME <> "scbo/bosc035exi.p":U THEN DO:
                RUN scbo/bosc035exi.p PERSISTENT SET h-bosc035exi.
            END.

            FIND FIRST wm-etiqueta
                 WHERE wm-etiqueta.id-etiqueta = ttBoWm-etiqueta.id-etiqueta NO-LOCK NO-ERROR.

            FOR  EACH wm-docto-itens
                WHERE wm-docto-itens.cod-estabel   = wm-docto.cod-estabel  AND
                      wm-docto-itens.cod-local     = wm-docto.cod-local    AND
                      wm-docto-itens.id-docto      = wm-docto.id-docto     AND
                      wm-docto-itens.cod-item      = wm-etiqueta.cod-item  AND
                      wm-docto-itens.cod-refer     = wm-etiqueta.cod-refer AND
                      wm-docto-itens.cod-lote      = wm-etiqueta.cod-lote  AND
                      wm-docto-itens.ind-sit-movto = 1 /* Implantado */    NO-LOCK:

                EMPTY TEMP-TABLE tt-saldo.
                
                FIND FIRST wm-box-saldo-etiqueta
                     WHERE wm-box-saldo-etiqueta.id-etiqueta = ttBoWm-etiqueta.id-etiqueta NO-LOCK NO-ERROR.
                FIND FIRST wm-box-saldo
                     WHERE wm-box-saldo.id-saldo = wm-box-saldo-etiqueta.id-saldo NO-LOCK NO-ERROR.
                
                
                IF  NOT AVAIL wm-box-saldo-etiqueta THEN DO:
                    MESSAGE "LL-erro-001: Saldo Etiqueta no Endere‡o" 
                        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                    /*
                    RUN pi-criarRowErrors (INPUT 56,
                                           INPUT "Saldo Etiqueta no Endere‡o",
                                           INPUT "EMS":U,
                                           INPUT "ERROR":U).
                    UNDO bloco, LEAVE bloco.
                    */
                    RETURN "NOK".
                END.

                /* Geracao Sugestao de Retirada*/
                CREATE tt-saldo.
                ASSIGN tt-saldo.cod-lote      = wm-etiqueta.cod-lote
                       tt-saldo.dt-transacao  = TODAY
                       tt-saldo.id-box        = wm-box-saldo-etiqueta.id-box
                       tt-saldo.cod-embalagem = wm-etiqueta.cod-embalagem
                       tt-saldo.qtd-original  = wm-box-saldo.qtd-original
                       tt-saldo.qtd-item      = wm-box-saldo.qtd-item
                       tt-saldo.qtd-embalagem = 1
                       tt-saldo.qtd-retirar   = ttWork.qtd-item.

                RUN emptyRowErrors     IN h-bosc035exi.
                RUN makeBestExitManual IN h-bosc035exi (INPUT ROWID(wm-docto-itens),
                                                        INPUT TABLE tt-saldo).
                IF  RETURN-VALUE = "NOK":U THEN DO:
                    MESSAGE "erro-100"
                        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                    RUN getRowErrors IN h-bosc035exi (OUTPUT TABLE RowErrors APPEND).
                END.

                For Each RowErrors:
                    ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                    ASSIGN vLogErro = YES.
                    RUN bcp/bc9115.p (ErrorNumber,ErrorDescription,8,20,3).
                    RETURN "NOK".
                END.
                
                /* Inicio Procedimentos Confirmacao Movimento*/
                CREATE tt-etiqueta.
                ASSIGN tt-etiqueta.id-etiqueta  = wm-box-saldo-etiqueta.id-etiqueta
                       tt-etiqueta.qtd-retirada = wm-box-saldo.qtd-original.

                CREATE tt-tarefa-docto.
                ASSIGN tt-tarefa-docto.CodUsuario     = c-seg-usuario
                       tt-tarefa-docto.CodEquipamento = "":U
                       tt-tarefa-docto.CodColetor     = "":U
                       tt-tarefa-docto.TempoInicio    = TIME.

                FIND FIRST wm-box-movto
                     WHERE wm-box-movto.cod-estabel       = wm-docto.cod-estabel         AND
                           wm-box-movto.cod-local         = wm-docto.cod-local           AND
                           wm-box-movto.id-box            = wm-box-saldo-etiqueta.id-box AND
                           wm-box-movto.ind-tipo-movto    = 2                            AND
                           wm-box-movto.ind-status-movto <> 3                            AND
                           wm-box-movto.id-docto          = wm-docto.id-docto            AND
                           wm-box-movto.cod-item          = wm-etiqueta.cod-item         AND
                           wm-box-movto.cod-refer         = wm-etiqueta.cod-refer        AND
                           wm-box-movto.cod-lote          = wm-etiqueta.cod-lote         NO-LOCK NO-ERROR.

                /*
                MESSAGE "Ponto-001:" AVAIL wm-box-movto
                    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                */

                IF  AVAIL wm-box-movto THEN DO:
                    /*
                    MESSAGE "wm-etiqueta.cod-item :" wm-etiqueta.cod-item 
                        SKIP
                        "wm-docto.id-docto:" wm-docto.id-docto
                        SKIP
                        "wm-etiqueta.id-etiqueta:" wm-etiqueta.id-etiqueta
                        SKIP
                        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                    */

                    RUN wmp/wm9021.p (INPUT  wm-box-movto.id-box,
                                      INPUT  wm-box-movto.cod-lote,
                                      INPUT  (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem),
                                      INPUT  ROWID(wm-box-movto),
                                      INPUT  wm-etiqueta.cod-embalagem,
                                      INPUT  TABLE tt-etiqueta,
                                      INPUT  TABLE tt-tarefa-docto,
                                      OUTPUT TABLE RowErrors APPEND).

                    For Each RowErrors:
                        ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                        ASSIGN vLogErro = YES.
                        RUN bcp/bc9115.p (ErrorNumber,ErrorDescription,8,20,3).
                        RETURN "NOK".
                    END.
                END.
            END.
        END.
        RETURN "OK".
    END.

END PROCEDURE.

****************************************************************************************************/
