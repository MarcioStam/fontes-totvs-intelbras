/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9018 2.00.00.008}  /*** 010008 ***/
/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/*******************************************************************************
** Copyright DATASUL S.A. (2002)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************************
**   Programa..: bc9018.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2002 - karla Klemke - Cria‡Æo do programa          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Picking WMS                      **
**                                                                                         **
********************************************************************************************/
&IF '{&mgscm_version}' >= '2.04' &THEN
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
**                        Ex. Frame01, Frame03, Frame02, etc.                                     **
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
**                            On Leave of ttWork.cod-depos in Frame Frame03                       **
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
&global-define ProgramName BC9018
/************************************************************/

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-picking-wms
{esp/es0018.i}
{bcp/bc9018.i " "}
{bcp/bc9018.i1 "New"}
{utp/utapi009.i} /* login */
{bcp/bc9048.i1} /* definicao variaveis menu padrao */
Create ttWork.

DEFINE VARIABLE vnr-pedcli              AS CHARACTER FORMAT 'x(12)':U     INIT ''  NO-UNDO.
DEFINE VARIABLE vnome-abrev             AS CHARACTER FORMAT 'x(12)':U     INIT ''  NO-UNDO.
DEFINE VARIABLE vcod-item               AS CHARACTER FORMAT 'x(16)':U     INIT ''  NO-UNDO.
DEFINE VARIABLE vdes-item               AS CHARACTER FORMAT 'x(18)':U     INIT ''  NO-UNDO. 
DEFINE VARIABLE c-desc-item             AS CHARACTER                               NO-UNDO.
DEFINE VARIABLE vcod-senha              AS CHARACTER FORMAT 'x(14)':U              NO-UNDO.
DEFINE VARIABLE tarefa-cod-doca         AS INTEGER    NO-UNDO.
DEFINE VARIABLE id-doca                 AS INTEGER FORMAT ">>>>>9"   NO-UNDO.
DEFINE VARIABLE c-desc-doca             AS CHAR FORMAT "x(18)".
DEFINE VARIABLE pIdTarefa               LIKE wm-tarefa-docto.id-tarefa.
DEFINE VARIABLE vIdEtiquetaUni          LIKE wm-packing-item.id-etiqueta  NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE gCodUsuario         AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gCodColetor         AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gCodEquipamento     AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gCodTipoEquip       AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gCodLocal           AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gCodEstab           AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gIdEtiquetaUni      LIKE wm-packing-item.id-etiqueta  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gCodTransp          LIKE transporte.cod-transp NO-UNDO.

DEF VAR c-nome-transp           LIKE transporte.nome-abrev NO-UNDO.
DEF VAR c-tipo-sep              AS CHAR                    NO-UNDO.
DEF VAR l-completo              AS LOG                     NO-UNDO.
DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.

DEFINE VARIABLE  c-endereco-entrega AS CHARACTER FORMAT "xxxxxxxxxxxxxxxxx" NO-UNDO.
DEFINE VARIABLE  i-cod-doca         AS INTEGER         NO-UNDO.
DEFINE VARIABLE  de-id-box          LIKE wm-box.id-box NO-UNDO.
DEFINE VARIABLE  de-id-packing      AS INT NO-UNDO.
DEFINE VARIABLE  c-uf               AS CHAR FORMAT "X(12)" NO-UNDO.

/*fk - opcao do tipo de leitura. Esse valor vem da bc9018h.p*/
DEFINE NEW GLOBAL SHARED VARIABLE iIndTipoLeitura   AS INTEGER NO-UNDO.
/*mk - Tipo de Visualiza‡Æo da quantidade */
DEFINE NEW GLOBAL SHARED VARIABLE iIndTipoVisualiza AS INTEGER NO-UNDO.

DEFINE NEW SHARED VARIABLE wgeswmpapi002               AS WIDGET-HANDLE                 NO-UNDO.

DEF TEMP-TABLE ttTransp NO-UNDO
    FIELD cod-transp   LIKE transporte.cod-transp
    FIELD nome-abrev   LIKE transporte.nome-abrev
    INDEX idx-1 IS PRIMARY UNIQUE nome-abrev.

DEF TEMP-TABLE ttTipoSeparacao NO-UNDO
    FIELD cod-tipo   AS CHAR FORMAT "X(12)"
    FIELD seq-tipo   AS INT  
    INDEX idx-1 IS PRIMARY UNIQUE cod-tipo.

DEF TEMP-TABLE tt-reqs NO-UNDO
    FIELD nr-requis AS CHAR FORMAT "X(16)"
    FIELD num-docto-transf LIKE docto-transf-depos.num-docto-transf
    FIELD id-docto LIKE docto-transf-depos.id-docto
    FIELD tipo     AS CHARACTER FORMAT "X(1)"
    INDEX id IS PRIMARY UNIQUE id-docto.

Define Temp-table tt-mostra-locais
    Field num-seq           As Integer
    Field des-local         As Character Format 'X(17)':U
    FIELD cod-bloco         LIKE wm-box.cod-bloco
    FIELD cod-rua           LIKE wm-box.cod-rua
    FIELD cod-nivel         LIKE wm-box.cod-nivel
    FIELD cod-coluna        LIKE wm-box.cod-coluna
    FIELD diferenciado      AS CHAR FORMAT "X(1)"
    FIELD des-diferenciado  AS CHAR FORMAT "X(200)" VIEW-AS EDITOR INNER-CHARS 16 INNER-LINES 5 MAX-CHARS 70 
    Field rowid-box-movto   As Rowid
        Index ID num-seq.

DEF TEMP-TABLE tt-tarefa-docto NO-UNDO
    FIELD CodUsuario     LIKE wm-tarefa-docto-itens.cod-usuario     
    FIELD CodEquipamento LIKE wm-tarefa-docto-itens.cod-equipamento 
    FIELD CodColetor     LIKE wm-tarefa-docto-itens.cod-coletor     
    FIELD TempoInicio    AS INTEGER.

DEFINE TEMP-TABLE tt-serial
       FIELD id-etiqueta          LIKE wm-etiqueta.id-etiqueta
       FIELD qtd-item-retirado    LIKE wm-etiqueta.qtd-item-retirado
       FIELD id-movto             LIKE wm-movto.id-movto
       INDEX idx-serial  AS PRIMARY /*UNIQUE*/ id-etiqueta.

Define Query qry-transp For ttTransp.

Define Browse brw-transp Query qry-transp No-lock
                 Display ttTransp.nome-abrev
                        With No-box No-labels Size 20 By 4.5 No-scrollbar-vertical.

Define Query qry-tipo-sep For ttTipoSeparacao.

Define Browse brw-tipo-sep Query qry-tipo-sep No-lock
                 Display ttTipoSeparacao.cod-tipo 
                        With No-box No-labels Size 20 By 4.0 No-scrollbar-vertical.

Define Query qry-wm-docto For tt-reqs.

Define Browse brw-wm-docto Query qry-wm-docto No-lock
                 Display 
                  tt-reqs.nr-requis tt-reqs.tipo
                        With No-box No-labels Size 20 By 4.5 No-scrollbar-vertical.

Define Query qry-wm-box-movto For tt-mostra-locais.

Define Browse brw-wm-box-movto Query qry-wm-box-movto No-lock
             Display 
              tt-mostra-locais.diferenciado
              tt-mostra-locais.des-local
                    With No-box No-labels Size 20 By 4.5 No-scrollbar-vertical.


/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Transito WMS'                                    At Row 01 Col 01          ~
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
&global-define Frame02Defs   'Transito WMS'                                      At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Etiqueta:'                                        AT ROW 03 COL 01          ~
                             vIdEtiquetaUni                                     At Row 04 Col 01 NO-LABEL ~
                             
&global-define Frame02Repeat YES

/************************************************************/

/************************************************************/

&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Transito WMS'                                        At Row 01 Col 01          ~
                             'Doca:'                                              AT ROW 02 COL 01          ~
                             id-doca                                              At Row 02 Col 09 NO-LABEL ~
                             c-desc-doca                                          At Row 03 Col 01 NO-LABEL ~
                             'Tecle 999 - SAIR'                                   AT ROW 08 COL 01          ~
&global-define Frame03Repeat NO

&global-define Frame04Name   Frame04
&global-define Frame04Defs   'Picking WMS'                                     At Row 01 Col 01                         ~
                             'Endereco Doca:     '                             At Row 03 Col 01                         ~
                             c-endereco-entrega                                At Row 04 Col 02 No-label                ~
                             'Area Pack:'                                      At Row 05 Col 01                         ~
                             de-id-packing                                     At Row 05 Col 11 No-label FORMAT '>>>>>9' ~
                             'UF:'                                             AT ROW 06 COL 01                         ~
                             c-uf                                              AT ROW 06 COL 04 NO-LABEL                ~
                             'Doca:'                                           At Row 07 Col 01                         ~
                             de-id-box                                         At Row 08 Col 02 No-label
&global-define Frame04Repeat NO


/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vcod-senha WHEN ttWork.cod-usuario = '' ~
                              ttWork.cod-coletor ~
                              ttWork.cod-equipamento

&global-define Update02Fields vIdEtiquetaUni 

&global-define Update03Fields id-doca

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02.
&global-define TriggerBeforeFrame05 Run InicializaCamposFrame05. If l-completo = YES THEN DO: Apply 'end-error':U To Frame Frame05. END.
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. Empty Temp-table tt-reqs. 
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

/************************************************************/

/* Definicao dos objetos ativos ---                         */
&global-define ActiveObject1  wgbosc030
&global-define ActiveObject2  wgbosc032
&global-define ActiveObject3  wgbosc044
&global-define ActiveObject4  wgbosc079
&global-define ActiveObject5  wgbc9018f
&global-define ActiveObject6  wgbosc092
&global-define ActiveObject7  wgbosc096
&global-define ActiveObject8  wgbosc135
&global-define ActiveObject9  wgeswmpapi002

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
    ASSIGN vLogErro = NO
           vLogCancela = NO.
    /* caso tenha sido startado login autom tico */
    /* caso tenha sido startado login automºtico */
    IF v_cod_usuar_corren <> '' THEN DO: 
        assign vcod-senha:blank in frame frame01 = NO.
        ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = v_cod_usuar_corren
               ttWork.cod-usuario                               = v_cod_usuar_corren
               vcod-senha                                       = '****************':U /* login automºtico */
               vcod-senha:SCREEN-VALUE IN FRAME frame01         = '****************':U. /* login automºtico */
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

    ASSIGN vLogErro = NO
           vLogCancela = NO
           vLogSai = NO.
    vIdEtiquetaUni = 0.
    IF vlogerro = YES THEN RETURN ERROR.
    DISP vIdEtiquetaUni WITH FRAME frame02.
End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame03 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame03:

    ASSIGN vLogErro = NO
           vLogCancela = NO
           vLogSai = NO.

    IF vlogerro = YES THEN RETURN ERROR.
    
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:


    Assign vLogErro          = No
           vLogControlaLogin = NO.

    /* valida usuario mestre contra mguni do EMS */
    IF ttWork.cod-usuario = ''  THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "101" "Usu rio Inv lido (DC)"}
    END.

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

    /* executa-se neste ponto devido ao login */
    IF NOT VALID-HANDLE(wgbosc030) THEN DO:
        Run scbo/bosc030.p Persistent Set wgbosc030       No-error.
        Run openQueryStatic In wgbosc030 (Input "Main":U) No-error.
    END.

    IF NOT VALID-HANDLE(wgbosc096) THEN DO:
        Run scbo/bosc096.p Persistent Set wgbosc096       No-error.
        Run openQueryStatic In wgbosc096 (Input "Main":U) No-error.
    END.

    IF NOT VALID-HANDLE(wgbosc032) THEN DO:
        Run scbo/bosc032.p Persistent Set wgbosc032       No-error.
        Run openQueryStatic In wgbosc032 (Input "Main":U) No-error.
    END.

    IF NOT VALID-HANDLE(wgbosc044) THEN DO:
        Run scbo/bosc044.p Persistent Set wgbosc044       No-error.
        Run openQueryStatic In wgbosc044 (Input "Main":U) No-error.
    END.

    IF NOT VALID-HANDLE(wgbosc079)  THEN DO:
        Run scbo/bosc079.p Persistent Set wgbosc079.
        Run openQueryStatic In wgbosc079 (Input "Main":U) No-error.
    END.

    IF NOT VALID-HANDLE(wgbosc135)  THEN DO:
        Run scbo/bosc135.p Persistent Set wgbosc135.
        Run openQueryStatic In wgbosc135 (Input "Main":U) No-error.
    END.

    /* Valida se usu rio tem permissÆo para executar a tarefa. */
    RUN validaUsuarioTarefa In wgbosc135 (Input ttWork.cod-usuario,
                                          INPUT 07).
    If  Return-value <> 'OK':U Then Do:
        Assign vLogErro = YES.
        IF vLogControlaLogin = YES THEN
           ASSIGN v_cod_usuar_corren  = ''
                  v2_cod_usuar_corren = ''.
        {bcp/bc9105.i "100" "Usu rio sem permissÆo para executar Picking (WMS)"}
        RETURN ERROR.
    END.

    Run validaUsuario In wgbosc079 (Input input Frame Frame01 ttWork.cod-usuario,
                                    OUTPUT vLogUtilizaColetor,
                                    OUTPUT vLogAprovaFatura).
    If Return-value <> 'OK':U Then Do:
       Assign vLogErro = YES.
       IF vLogControlaLogin = YES THEN
          ASSIGN v_cod_usuar_corren  = ''
                 v2_cod_usuar_corren = ''.
       Run getrowErrors In wgbosc079 (output Table RowErrors).
       For Each RowErrors:
           ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
           {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
       END.                                           
    End.

    IF  vLogUtilizaColetor = NO THEN DO:
        Assign vLogErro = Yes.
        IF vLogControlaLogin = YES THEN
           ASSIGN v_cod_usuar_corren  = ''
                  v2_cod_usuar_corren = ''.
        {bcp/bc9105.i "101" "Usu rio sem permissÆo para utilizar Coletor (WMS)"}
        Return Error.
    END.


    IF ttWork.cod-coletor = ''  THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "102" "Coletor Inv lido (WMS)"}
    END.

    If  ttWork.cod-equipamento = '' Then Do:
       Assign vLogErro = Yes.
       {bcp/bc9105.i "103" "Equipamento Inv lido (WMS)"}
    End.

    If vLogErro = Yes Then Return Error.

    IF NOT VALID-HANDLE(wgbosc092) THEN DO:
       Run scbo/bosc092.p Persistent Set wgbosc092 No-error.
       Run EmptyRowErrors In wgbosc092.
    END.

    Run validaEquipColetor In wgbosc092  (Input  ttWork.cod-coletor,
                                          Output vCodTipoEquip,
                                          Output vLogAtivo,
                                          Output vLogProcesso).
    If  Return-value <> 'OK':U Then Do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "103" "Coletor Inv lido (WMS)"}
    End.

    If   vLogAtivo = No Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "103" "Coletor Inativo (WMS)"}
    End.

    If vLogErro = Yes Then Return Error.

    Run validaEquipTransportador In wgbosc092  (Input  ttWork.cod-equipamento,
                                                Output vCodTipoEquip,
                                                Output vLogAtivo,
                                                Output vLogProcesso).
    If  Return-value <> 'OK':U Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "104" "Equipamento Inv lido (WMS)"}
    End.

    If   vLogAtivo = No Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "105" "Equipamento Inativo (WMS)"}
    End.
    If vLogErro = Yes Then Return Error.

    Assign  {&TempTable}.cod-usuario     = ttWork.cod-usuario 
            {&TempTable}.cod-coletor     = ttWork.cod-coletor
            {&TempTable}.cod-equipamento = ttWork.cod-equipamento.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame02:
    ASSIGN vLogErro = NO.

    FIND FIRST wms-etiq-packing 
        WHERE wms-etiq-packing.val-etiq-packing = vIdEtiquetaUni
        NO-LOCK NO-ERROR.

    IF NOT AVAIL wms-etiq-packing THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "105" "Etiqueta Invalida (WMS)"}
    End.
    If vLogErro = Yes Then Return Error.
    
    FIND LAST wms-box-packing 
        WHERE wms-box-packing.val-etiq-packing = wms-etiq-packing.val-etiq-packing
        NO-LOCK NO-ERROR.

    IF NOT AVAIL wms-box-packing THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "106" "Etiqueta nao armazenada no endereco de transito"}
    End.
    If vLogErro = Yes Then Return Error.

    ASSIGN c-uf = ENTRY(2,wms-etiq-packing.nr-pedcli,"-") NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
        ASSIGN c-uf = "".

    DISP c-uf WITH FRAME {&Frame04Name}.

    IF wms-box-packing.idi-sit-packing = 2 THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "107" "Etiqueta ja entregue (WMS)"}
    End.
    If vLogErro = Yes Then Return Error.

    EMPTY TEMP-TABLE tt-tarefa-docto.
    CREATE tt-tarefa-docto.
    ASSIGN tt-tarefa-docto.CodUsuario     = ttWork.cod-usuario 
           tt-tarefa-docto.CodEquipamento = ttWork.cod-equipamento
           tt-tarefa-docto.CodColetor     = ttWork.cod-coletor 
           tt-tarefa-docto.TempoInicio    = TIME.

    
    IF wms-box-packing.cod-livre-2 = "Doca" THEN DO:

        FIND FIRST wm-doca WHERE wm-doca.id-box = wms-box-packing.val-livre-1
            NO-LOCK NO-ERROR.
        IF NOT AVAIL wm-doca THEN DO:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "000" "Doca atribuido a etiqueta, invalida (DC)"}
            If vLogErro = Yes Then Return Error.
        END.
        c-endereco-entrega = trim(string(wm-doca.cod-doca)) + " " + trim(wm-doca.des-doca).
        DISP c-endereco-entrega WITH FRAME {&Frame04Name}.
        UPDATE de-id-box WITH FRAME {&Frame04Name}.
        IF wms-box-packing.val-livre-1 = de-id-box THEN DO:
            FIND CURRENT wms-box-packing EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN wms-box-packing.idi-sit-packing = 2.
            FIND CURRENT wms-box-packing NO-LOCK NO-ERROR.

            RUN wmp/wm9041.p (INPUT wms-box-packing.cod-estabel,
                              INPUT wms-box-packing.cod-local,
                              INPUT wms-box-packing.val-livre-2,
                              INPUT YES,
                              INPUT TABLE tt-tarefa-docto,
                              OUTPUT TABLE RowErrors).
            {bcp/bc9105.i "000" "Entregue com sucesso (DC)"}
        END.
        ELSE DO:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "000" "Doca incorreta (DC)"}
            If vLogErro = Yes Then Return Error.
        END.
    END.
    ELSE DO:
        UPDATE de-id-packing WITH FRAME {&Frame04Name}.
        FIND FIRST es-wm-area-packing NO-LOCK
             WHERE es-wm-area-packing.cod-area-packing = de-id-packing NO-ERROR.
        IF AVAIL es-wm-area-packing THEN DO:
            FIND CURRENT wms-box-packing EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN wms-box-packing.idi-sit-packing = 2.
            FIND CURRENT wms-box-packing NO-LOCK NO-ERROR.

            RUN wmp/wm9041.p (INPUT wms-box-packing.cod-estabel,
                              INPUT wms-box-packing.cod-local,
                              INPUT wms-box-packing.val-livre-2,
                              INPUT YES,
                              INPUT TABLE tt-tarefa-docto,
                              OUTPUT TABLE RowErrors).
            {bcp/bc9105.i "000" "Entregue com sucesso (DC)"}
        END.
        ELSE DO:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "000" "Area de Packing incorreta (DC)"}
            If vLogErro = Yes Then Return Error.
        END.
    END.


End Procedure.

Procedure GravaCamposFrame03:

    ASSIGN vLogErro = NO.

    
End Procedure.


/*************************************  Codigo do Usuario Fim   ********************************/
&else 

    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif
