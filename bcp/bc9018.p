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
**                        Ex. Frame01, Frame03, Frame04, etc.                                     **
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
{esp/wmp/eswmpapi002.i}
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
DEFINE VARIABLE vIdEtiquetaUni          LIKE wms-etiq-packing.val-etiq-packing  NO-UNDO.
DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE c-erro-num              AS INT  NO-UNDO.
DEFINE VARIABLE c-erro-transp           AS CHAR FORMAT "X(100)" VIEW-AS EDITOR INNER-CHARS 16 INNER-LINES 5 MAX-CHARS 70 NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE gCodUsuario         AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gCodColetor         AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gCodEquipamento     AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gCodTipoEquip       AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gCodLocal           AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gCodEstab           AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gIdEtiquetaUni      LIKE wms-etiq-packing.val-etiq-packing  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gCodTransp          LIKE transporte.cod-transp NO-UNDO.

DEF VAR c-nome-transp           LIKE transporte.nome-abrev NO-UNDO.
DEF VAR c-tipo-sep              AS CHAR                    NO-UNDO.
DEF VAR l-completo              AS LOG                     NO-UNDO.

/*fk - opcao do tipo de leitura. Esse valor vem da bc9018h.p*/
DEFINE NEW GLOBAL SHARED VARIABLE iIndTipoLeitura   AS INTEGER NO-UNDO.
/*mk - Tipo de Visualiza‡Æo da quantidade */
DEFINE NEW GLOBAL SHARED VARIABLE iIndTipoVisualiza AS INTEGER NO-UNDO.

DEFINE NEW SHARED VARIABLE wgeswmpapi002               AS WIDGET-HANDLE                 NO-UNDO.

DEF TEMP-TABLE ttTransp NO-UNDO
    FIELD cod-transp   LIKE transporte.cod-transp
    FIELD nome-abrev   LIKE transporte.nome-abrev
    FIELD log-docto    AS LOG
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
&global-define Frame01Defs   'PICKING WMS'                                      At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label ~
                             'Sen:'                                             AT ROW 04 COL 01          ~
                             vcod-senha                                         AT ROW 04 COL 05 NO-LABEL ~
                             'Col:'                                             At Row 05 Col 01          ~
                             ttWork.cod-coletor                                 At Row 05 Col 05 No-label ~
                             'Equ:'                                             At Row 06 Col 01          ~
                             ttWork.cod-equipamento                             At Row 06 Col 05 No-label ~
                             'Loc:'                                             At Row 07 Col 01          ~
                             ttWork.cod-local                                   At Row 07 Col 05 No-label ~

&global-define Frame01Repeat No

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'PICKING WMS'                                      At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Trsp:'                                            AT ROW 03 COL 01          ~
                             c-nome-transp                                      AT ROW 03 COL 06 NO-LABEL ~
                             brw-tipo-sep                                       At Row 04 Col 01          ~

&global-define Frame02Repeat No

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'PICKING WMS'                                      At Row 01 Col 01            ~
                             '--------------------'                             At Row 02 Col 01          ~
                             brw-wm-docto                                       At Row 03 Col 01          ~

&global-define Frame03Repeat No
/************************************************************/

/* Definicao da Frame04 ---                                 */
&global-define Frame04Name   Frame04
&global-define Frame04Defs   'PICKING WMS'                                      At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Etiqueta:'                                        AT ROW 04 COL 01          ~
                             vIdEtiquetaUni                                     At Row 05 Col 01 NO-LABEL ~
                             
&global-define Frame04Repeat NO

/************************************************************/

/* Definicao da Frame05 ---                                 */
&global-define Frame05Name   Frame05
&global-define Frame05Defs   'PICKING WMS'                                      At Row 01 Col 01          ~
                             brw-wm-box-movto                                   At Row 02 Col 01          ~
                             'It:'                                              AT ROW 06 COL 01          ~
                             vcod-item                                          AT ROW 06 COL 03 NO-LABEL ~
                             vdes-item                                          AT ROW 07 COL 01 NO-LABEL ~
                             /*'Tecle 0 solic Doca'                               AT ROW 08 COL 01          ~*/

&global-define Frame05Repeat YES

/************************************************************/

&global-define Frame06Name   Frame06
&global-define Frame06Defs   'PICKING WMS'                                        At Row 01 Col 01          ~
                             'Doca:'                                              AT ROW 02 COL 01          ~
                             id-doca                                              At Row 02 Col 09 NO-LABEL ~
                             c-desc-doca                                          At Row 03 Col 01 NO-LABEL ~
                             'Tecle 999 - SAIR'                                   AT ROW 08 COL 01          ~
&global-define Frame06Repeat NO

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vcod-senha WHEN ttWork.cod-usuario = '' ~
                              ttWork.cod-coletor ~
                              ttWork.cod-equipamento ~
                              ttWork.cod-local

&global-define Update02Fields brw-tipo-sep

&global-define Update03Fields brw-wm-docto

&global-define Update04Fields vIdEtiquetaUni 

&global-define Update05Fields brw-wm-box-movto

&global-define Update06Fields id-doca

/************************************************************/

DEFINE FRAME FTransp
    'PICKING WMS'                 At Row 01 Col 01            
    '--------------------'        At Row 02 Col 01          
    brw-transp                    AT ROW 03 COL 01         
    WITH 1 down font 3 Size 20 By 8 NO-BOX.

DEFINE FRAME FDiferenciado
     'PICKING WMS'                              At Row 01 Col 01            
     '--------------------'                     At Row 02 Col 01          
     tt-mostra-locais.des-diferenciado NO-LABEL AT ROW 03 COL 01         
     WITH 1 down font 3 Size 20 By 8 NO-BOX.
Assign tt-mostra-locais.des-diferenciado:Width              = Frame FDiferenciado:Width  - 1
       tt-mostra-locais.des-diferenciado:Height             = Frame FDiferenciado:height - 2
       tt-mostra-locais.des-diferenciado:SCROLLBAR-VERTICAL = TRUE
       tt-mostra-locais.des-diferenciado:READ-ONLY          = TRUE.

DEFINE FRAME FErroTransp
     'ERRO: '               At Row 01 Col 01            
     c-erro-num    NO-LABEL AT ROW 01 COL 06         
     c-erro-transp NO-LABEL AT ROW 02 COL 01         
     WITH 1 down font 3 Size 20 By 8 NO-BOX.
Assign c-erro-transp:Width  = Frame FDiferenciado:Width  - 1
       c-erro-transp:Height = Frame FDiferenciado:height - 1.


/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03.
&global-define TriggerBeforeFrame04 Run InicializaCamposFrame04.
&global-define TriggerBeforeFrame05 Run InicializaCamposFrame05. If l-completo = YES THEN DO: Apply 'end-error':U To Frame Frame05. END.
&global-define TriggerBeforeFrame06 Run InicializaCamposFrame06.
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. Empty Temp-table tt-reqs. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. Empty Temp-table ttTipoSeparacao. 
&global-define TriggerAfterFrame03  Run GravaCamposFrame03. Empty Temp-table tt-mostra-locais. 
&global-define TriggerAfterFrame04  Run GravaCamposFrame04.
&global-define TriggerAfterFrame05  Run GravaCamposFrame05.
&global-define TriggerAfterFrame06  Run GravaCamposFrame06.

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
                            ON 'Return':U        OF brw-transp In Frame FTransp           ~
                            DO:                                                                     ~
                                    Apply 'Go' To This-procedure.                                    ~
                            END.                                                                    ~
                            ON 'Return':U        OF brw-tipo-sep In Frame {&Frame02Name}           ~
                            DO:                                                                     ~
                                   Apply 'Go' To This-procedure.                                    ~
                            END.                                                                    ~
                            ON 'Return':U        OF brw-wm-docto In Frame {&Frame03Name}            ~
                            DO:                                                                     ~
                                   Apply 'Go' To This-procedure.                                    ~
                            END.                                                                    ~
                            ON 'Return':U        OF brw-wm-box-movto In Frame {&Frame05Name}        ~
                            DO:                                                                     ~
                                   Apply 'Go' To This-procedure.                                    ~
                            END.                                                                    ~
                            ON 'value-changed':U OF brw-wm-box-movto In Frame {&Frame05Name}        ~
                            DO:                                                                     ~
                                Find ttWm-box-movto-idx-picking                                                  ~
                                    Where Rowid(ttWm-box-movto-idx-picking) = tt-mostra-locais.rowid-box-movto   ~
                                           No-error.                                                             ~
                                If  Not Available ttWm-box-movto-idx-picking Then Return No-apply.               ~
                                Run getInfoDoctoItens IN wgbosc096 (Input ttWm-box-movto-idx-picking.cod-estabel,  ~
                                                                    Input ttWm-box-movto-idx-picking.cod-local,    ~
                                                                    Input ttWm-box-movto-idx-picking.id-docto,     ~
                                                                    Input ttWm-box-movto-idx-picking.num-seq-item, ~
                                                                    Output Table ttwm-docto-itens ).               ~
                                Find First ttwm-docto-itens.                                                                             ~
                                RUN goToKey IN wgbosc044 (INPUT ttwm-docto-itens.cod-item). /* Vari vel ou Campo com o c¢digo do Item */ ~
                                IF RETURN-VALUE = "OK":U THEN DO:                                                                        ~
	                                RUN getCharField IN wgbosc044 (INPUT "des-item":U,                                                   ~
                                                                   OUTPUT c-desc-item). /* Vari vel ou Campo com a descri‡Æo do Item */  ~
                                    ASSIGN vdes-item:SCREEN-VALUE   IN FRAME Frame05 = TRIM(SUBSTRING(c-desc-item,1,18)).                ~
                                END.                                                                                                     ~
                                ELSE DO:                                                                                                 ~
	                                ASSIGN vdes-item:SCREEN-VALUE   IN FRAME Frame05 = ''.                                               ~
                                END.                                                                                                     ~
                                ASSIGN vcod-item:SCREEN-VALUE   IN FRAME Frame05 = TRIM(ttwm-docto-itens.cod-item).                       ~
                            END. ~
                            /*
                            ON '0':U OF brw-wm-box-movto IN FRAME {&Frame05NAME}  ~
                            DO:                                                   ~
                                RUN confirmadoca.                                 ~
                                HIDE ALL NO-PAUSE.                                ~
                                VIEW FRAME Frame05. ~
                            END.                                                  ~
                            ON 'ESC':U OF brw-wm-box-movto IN FRAME {&Frame05NAME} ~
                            DO:                                                    ~
                                IF tarefa-cod-doca <> 0 THEN                       ~
                                   RUN confirmadoca.                               ~
                                HIDE ALL NO-PAUSE.                                 ~
                            END.                                                   ~
                            */

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
    
    ASSIGN ttWork.cod-local   = gCodLocal
           ttWork.cod-estabel = gCodEstab.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:

    DEF VAR i-transp    AS INT NO-UNDO.

    ASSIGN vLogErro = NO
           vLogCancela = NO
           vLogSai = NO.

    FOR EACH ttTransp:
        DELETE ttTransp.
    END.

    FIND FIRST wm-equipamento WHERE
        wm-equipamento.cod-equipamento = ttWork.cod-equipamento NO-LOCK NO-ERROR.
    IF AVAIL wm-equipamento THEN DO:
        FOR EACH esp-wm-equipamento-transp OF wm-equipamento NO-LOCK:
            CREATE ttTransp.
            ASSIGN ttTransp.cod-transp = esp-wm-equipamento-transp.cod-transp
                   ttTransp.nome-abrev = esp-wm-equipamento-transp.nome-abrev
                   ttTransp.log-docto  = NO.
        END.
    END.
        
    IF NOT CAN-FIND(FIRST ttTransp) THEN DO:
        /* Assign vLogErro = Yes.
        {bcp/bc9105.i "198" "Equipamento sem Transportadora relacionada (WMS)"} */
        HIDE ALL.
        ASSIGN c-erro-num    = 230
               c-erro-transp = "Equipamento sem Transportadora relacionada (WMS)".
        DISP c-erro-num
             c-erro-transp WITH FRAME FErroTransp. READKEY.
        HIDE ALL.
        ASSIGN vLogErro = YES.
    END.
    If vLogErro = Yes Then Return Error.
    
    /* Filtrando apenas Transportadoras com Tarefas */
    FOR EACH wm-docto NO-LOCK USE-INDEX wmsdocto-10
        WHERE wm-docto.cod-estabel      = ttWork.cod-estabel
          AND wm-docto.cod-local        = ttWork.cod-local
          AND wm-docto.ind-sit-docto    = 1 /* implantado */
          AND wm-docto.ind-tipo-trans   = 2:

        FIND FIRST transporte NO-LOCK
            WHERE transporte.nome-abrev = ENTRY(2,wm-docto.num-docto-origem,"|") NO-ERROR.
        
        FIND FIRST ttTransp WHERE 
            ttTransp.nome-abrev = transporte.nome-abrev NO-ERROR.
        IF AVAIL ttTransp THEN
            ASSIGN ttTransp.log-docto = YES.        

    END.

    ASSIGN i-transp = 0.
    FOR EACH ttTransp:
        IF ttTransp.log-docto = YES THEN
            ASSIGN i-transp = i-transp + 1.
        ELSE
            DELETE ttTransp.
    END.    

    IF i-transp > 1 THEN DO:
        OPEN Query qry-transp For Each ttTransp By ttTransp.nome-abrev.
        UPDATE brw-transp WITH FRAME fTransp.

        ASSIGN gCodTransp    = IF AVAIL ttTransp THEN ttTransp.cod-transp ELSE 0
               c-nome-transp = IF AVAIL ttTransp THEN ttTransp.nome-abrev ELSE "".
    END.
    ELSE IF i-transp = 1 THEN DO:
        FIND FIRST ttTransp NO-ERROR.
        ASSIGN gCodTransp    = IF AVAIL ttTransp THEN ttTransp.cod-transp ELSE 0
               c-nome-transp = IF AVAIL ttTransp THEN ttTransp.nome-abrev ELSE "".
    END.
    ELSE DO:
        /* Assign vLogErro = Yes.
        {bcp/bc9105.i "199" "NÆo existem doctos pendentes para Transportadora(s) do Equito (WMS)"} */
        HIDE ALL.
        ASSIGN c-erro-num    = 231
               c-erro-transp = "NÆo existem doctos pendentes para Transportadora(s) do Equito (WMS)".
        DISP c-erro-num
             c-erro-transp WITH FRAME FErroTransp. READKEY.
        HIDE ALL.
        ASSIGN vLogErro = YES.
    END.
    If vLogErro = Yes Then Return Error.

    EMPTY TEMP-TABLE ttTipoSeparacao.

    RUN GetTipoSep.

    IF vlogerro = YES THEN RETURN ERROR.

    DISP c-nome-transp WITH FRAME Frame02.
    OPEN Query qry-tipo-sep For Each ttTipoSeparacao BY ttTipoSeparacao.seq-tipo By ttTipoSeparacao.cod-tipo.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame03 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame03:

    ASSIGN vLogErro = NO
           vLogCancela = NO
           vLogSai = NO.
   
    EMPTY TEMP-TABLE tt-reqs.

    RUN GetDocto.
    
    IF vlogerro = YES THEN RETURN ERROR.
    
    ASSIGN tarefa-cod-doca = 0
           pidtarefa       = 0.

    OPEN Query qry-wm-docto For Each tt-reqs By tt-reqs.nr-requis.
    /*APPLY "value-change" TO  brw-wm-docto In Frame {&Frame03Name}.*/

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame03 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame04:

    ASSIGN vLogErro = NO
           vLogCancela = NO
           vLogSai = NO.

    IF vlogerro = YES THEN RETURN ERROR.
    
End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame04}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame05:

    ASSIGN vLogErro        = NO
           vLogCancela     = NO
           vLogEmProcesso  = NO.

    RUN GetTasks.
    
    IF vLogerro = YES THEN RETURN ERROR. 

    IF NOT VALID-HANDLE(wgbosc044) THEN DO:
        Run scbo/bosc044.p Persistent Set wgbosc044       No-error.
        Run openQueryStatic In wgbosc044 (Input "Main":U) No-error.
    END.

    Empty Temp-table tt-mostra-locais.

    Assign vNumSeq = 0.

    wm-boxm:
    For Each ttWm-box-movto-idx-picking
        Where ttWm-box-movto-idx-picking.ind-tipo-movto = 2
            BREAK By ttWm-box-movto-idx-picking.nr-pedcli
            By ttWm-box-movto-idx-picking.nome-abrev
            By ttWm-box-movto-idx-picking.val-prioridade
            BY ttwm-box-movto-idx-picking.id-movto
            BY ttwm-box-movto-idx-picking.id-box:
        
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

        Find First ttwm-box NO-ERROR.

        If Not Avail ttwm-box Then Next wm-boxm.

        FIND FIRST tt-mostra-locais WHERE tt-mostra-locais.des-local = ttwm-box.cod-bloco            + '/':U +
                                                                       ttwm-box.cod-rua              + '/':U +
                                                                       ttwm-box.cod-nivel            + '/':U +
                                                                       ttwm-box.cod-coluna           + '/':U +
                                                                       If ttwm-box.ind-posicao-box = 1 Then 'E' Else 'D'
                                                                       NO-LOCK NO-ERROR.

        /*IF AVAIL tt-mostra-locais THEN NEXT.*/

        Assign vNumSeq = vNumSeq + 1.

        Create tt-mostra-locais.
        Assign tt-mostra-locais.num-seq           = vNumSeq
               tt-mostra-locais.des-local         = ttwm-box.cod-bloco            + '/':U +
                                                    ttwm-box.cod-rua              + '/':U +
                                                    ttwm-box.cod-nivel            + '/':U +
                                                    ttwm-box.cod-coluna           + '/':U +
                                                    If ttwm-box.ind-posicao-box = 1 Then 'E' Else 'D'
               tt-mostra-locais.cod-bloco         = ttwm-box.cod-bloco
               tt-mostra-locais.cod-rua           = ttwm-box.cod-rua
               tt-mostra-locais.cod-nivel         = ttwm-box.cod-nivel
               tt-mostra-locais.cod-coluna        = ttwm-box.cod-coluna
               tt-mostra-locais.rowid-box-movto   = Rowid(ttWm-box-movto-idx-picking)
               tt-mostra-locais.diferenciado      = "" /* Inicializando */.

        IF ttWm-box-movto-idx-picking.log-pend-ressup AND ttWork.opcao = 4 THEN
            ASSIGN tt-mostra-locais.des-local = tt-mostra-locais.des-local + '  R'.

        /* Diferencidado */
        FIND FIRST wm-docto WHERE
            wm-docto.cod-estabel = ttWm-box-movto-idx-picking.cod-estabel AND
            wm-docto.cod-local   = ttWm-box-movto-idx-picking.cod-local   AND
            wm-docto.id-docto    = ttWm-box-movto-idx-picking.id-docto    NO-LOCK NO-ERROR.
        FIND FIRST integra-mft-wms-notas WHERE
            integra-mft-wms-notas.cod-integra = wm-docto.num-docto                  AND
            integra-mft-wms-notas.it-codigo   = ttWm-box-movto-idx-picking.cod-item NO-LOCK NO-ERROR.
        IF AVAIL integra-mft-wms-notas THEN DO:
            FIND FIRST emitente WHERE
                emitente.nome-abrev = integra-mft-wms-notas.nome-abrev NO-LOCK NO-ERROR.
            
            EMPTY TEMP-TABLE tt-prog-ponto.
            RUN esp/es0018p.p (INPUT "bc9018":U,
                               INPUT 1,
                               INPUT 0,
                               INPUT "":U,
                               OUTPUT TABLE tt-prog-ponto).
            FOR EACH tt-prog-ponto,
                FIRST cli-difer WHERE
                    cli-difer.cod-emitente = emitente.cod-emitente  AND
                    cli-difer.cc-codigo    = tt-prog-ponto.conteudo NO-LOCK:
                IF AVAIL cli-difer THEN
                    ASSIGN tt-mostra-locais.diferenciado     = "*"
                           tt-mostra-locais.des-diferenciado = cli-difer.descricao.
            END. 
        END.


    End. /*For Each ttWm-box-movto-idx-picking:*/

    FIND FIRST tt-mostra-locais NO-LOCK NO-ERROR.
    IF RECID(tt-mostra-locais) = ? THEN DO:
        CREATE tt-mostra-locais.
        ASSIGN tt-mostra-locais.num-seq   = 999
               tt-mostra-locais.des-local = 'NÆo existem tarefas (WMS)'.
    END.
    IF ttWork.cod-estabel = "104" THEN DO:
        Open Query qry-wm-box-movto For Each tt-mostra-locais 
            By tt-mostra-locais.cod-bloco DESC
            BY tt-mostra-locais.cod-rua 
            BY tt-mostra-locais.cod-nivel
            BY tt-mostra-locais.cod-coluna
            By tt-mostra-locais.num-seq.
    END.
    ELSE DO:
        Open Query qry-wm-box-movto For Each tt-mostra-locais 
            By tt-mostra-locais.cod-bloco 
            BY tt-mostra-locais.cod-rua 
            BY tt-mostra-locais.cod-nivel
            BY tt-mostra-locais.cod-coluna
            By tt-mostra-locais.num-seq.
    END.
    APPLY 'value-changed':U To brw-wm-box-movto In Frame {&Frame05Name}.

End PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame03 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame06:

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
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame02:

    ASSIGN vLogErro = NO.
    Assign vLogIniciado = No.
    
    ASSIGN c-tipo-sep = IF AVAIL ttTipoSeparacao THEN ttTipoSeparacao.cod-tipo ELSE "".

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame03:

    ASSIGN vLogErro = NO.
/*     IF input Frame Frame03 ttWork.opcao <> 1 AND                    */
/*        input Frame Frame03 ttWork.opcao <> 2 AND                    */
/*        input Frame Frame03 ttWork.opcao <> 3 AND                    */
/*        input Frame Frame03 ttWork.opcao <> 4 THEN do:               */
/*        {bcp/bc9105.i "100" "Op‡Æo Inv lida (DC)"}                   */
/*        Hide All.                                                    */
/*        RETURN ERROR.                                                */
/*     END.                                                            */
/*                                                                     */
/*     ASSIGN {&TempTable}.opcao  = input Frame Frame03 ttWork.opcao.  */

    Assign vLogIniciado = No.

    Assign ttWork.qtd-embal-lidas  = 0
           ttWork.des-seriais      = ''
           ttWork.num-box-lido     = 0
           ttWork.num-doca         = 0
           ttWork.qtd-embal-lidas  = 0
           ttWork.qtd-item-digit   = 0.


End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame04:

    DEF VAR c-num-docto        LIKE wm-docto.num-docto    NO-UNDO.

    ASSIGN vLogErro = NO.

    Assign vLogIniciado = No.

    IF NOT(LENGTH(STRING(vIdEtiquetaUni),"CHARACTER") =  15) THEN DO:
        ASSIGN vLogErro = YES.
        {bcp/bc9105.i "105" "Etiqueta de Separacao formato inv lido. (WMS)"}
    END.

    FIND FIRST wms-etiq-packing NO-LOCK
         WHERE wms-etiq-packing.val-etiq-packing = vIdEtiquetaUni NO-ERROR.
    IF AVAIL wms-etiq-packing THEN DO:
        
        ASSIGN c-num-docto = tt-reqs.nr-requis NO-ERROR.
        IF ERROR-STATUS:ERROR OR
           wms-etiq-packing.nr-pedcli <> c-num-docto AND 
           wms-etiq-packing.nr-pedcli <> "" THEN DO:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "105" "Etiqueta de Separacao ja relacionada a outro pedido ou invalida. (WMS)"}
        END.
        ELSE 
            ASSIGN gIdEtiquetaUni = vIdEtiquetaUni.
    END.
    ELSE DO:
        ASSIGN vLogErro = YES.
        {bcp/bc9105.i "105" "Etiqueta de Separacao nao foi impressa"}
        /*ASSIGN gIdEtiquetaUni = vIdEtiquetaUni.*/
    END.
        
    
    Assign vIdEtiquetaUni = 0
           l-completo = NO.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame04}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame05:

    Assign vLogErro = NO
           vLogSai = No 
           vLogFinaliza = NO.

    If Not Avail ttWm-box-movto-idx-picking Then Do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "301" "Movimento Inv lido. (WMS)"}
         Return Error.
    End.                     
    /*FIND FIRST wm-tarefa-docto-itens 
         WHERE wm-tarefa-docto-itens.cod-estabel = ttWm-box-movto-idx-picking.cod-estabel
           AND wm-tarefa-docto-itens.cod-local   = ttWm-box-movto-idx-picking.cod-local     
           AND wm-tarefa-docto-itens.id-movto    = ttWm-box-movto-idx-picking.id-movto  
           AND wm-tarefa-docto-itens.cod-tarefa  = 07 EXCLUSIVE-LOCK NO-ERROR.
    
    If  wm-tarefa-docto-itens.ind-status-tarefa-itens <> 1 Then Do:
        Assign vLogEmProcesso = Yes.
    End. */

    /* Diferenciado */
    IF AVAIL tt-mostra-locais AND tt-mostra-locais.diferenciado = "*" THEN DO:        
        HIDE ALL.
        ENABLE tt-mostra-locais.des-diferenciado WITH FRAME FDiferenciado.
        DISP tt-mostra-locais.des-diferenciado WITH FRAME FDiferenciado. READKEY. 
    END.                                                                 

    If  ttWm-box-movto-idx-picking.ind-status-movto <> 1 Then Do:
        Assign vLogEmProcesso = Yes.
    End.


    IF tarefa-cod-doca <> ttWm-docto-itens.cod-doca AND tarefa-cod-doca <> 0 AND integer(vCodTipoEquip) = 2 THEN DO:
        Assign vLogErro = Yes.
        RUN bcp/bc9115.p (0,"A tarefa nao pertence a mesma doca, favor descaregar o material na doca " + string(tarefa-cod-doca) ,8,20,3).
        Return Error.
    END.
    ASSIGN tarefa-cod-doca = ttWm-docto-itens.cod-doca.


    If  vLogEmProcesso = No Then Do:
        Run inicializaTarefaMovtoOK In wgbosc096
                                     (Input ttWm-box-movto-idx-picking.id-docto,
                                      Input 07,     
                                      Input ttWork.cod-usuario,              
                                      Input ttWork.cod-equipamento,          
                                      Input ttWork.cod-coletor,              
                                      Input ttWm-box-movto-idx-picking.id-movto,         
                                      Input ttWm-box-movto-idx-picking.num-seq-item).
        If  Return-value <> 'OK' Then Do:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "302" "Movimento Expirado ou J  Alocado (WMS)"}
            Return Error.
        End.

        FIND FIRST wm-usuario-tarefa WHERE wm-usuario-tarefa.cod-tarefa  = int(ttWm-docto-itens.cod-tarefa)
                                     AND   wm-usuario-tarefa.cod-usuario = ttWork.cod-usuario NO-LOCK NO-ERROR.

        IF AVAIL wm-usuario-tarefa THEN DO:

            RUN wmp/eswmpapi008.p (Input ttWm-box-movto-idx-picking.cod-estabel,
                                  Input ttWm-box-movto-idx-picking.cod-local,
                                  Input ttWm-box-movto-idx-picking.id-docto,
                                  Input ttWork.cod-usuario,              
                                  Input ttWork.cod-equipamento,          
                                  Input ttWork.cod-coletor,              
                                  Input ttWm-box-movto-idx-picking.id-movto,         
                                  Input ttWm-box-movto-idx-picking.num-seq-item,
                                  INPUT-OUTPUT pIdTarefa,
                                  OUTPUT TABLE RowErrors).
    
            IF RETURN-VALUE <> "OK" THEN DO:
                For Each RowErrors:
                    Hide All No-pause.
                    ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                    Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
                    Hide All No-pause.
                end. /* Each RowErrors */
                RETURN ERROR.
            END.
        END.

        ASSIGN vLogEmProcesso = YES.

    End.

    Assign vLogErro = No.
    If Not Avail ttWm-box-movto-idx-picking Then Do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "301" "Movimento Inv lido (WMS)"}
         Return Error.
    End.

    Hide All.

    Assign vLogFinaliza = No
           vLogSai      = No.

    Hide All No-pause.
    ASSIGN l-completo = NO.
    RUN bcp/bc9018b.p (INPUT  ROWID(ttWm-box-movto-idx-picking),
                       OUTPUT l-completo).
    Hide All No-pause.

    FIND FIRST ttWork.
    RETURN RETURN-VALUE.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame06:

    ASSIGN vLogErro = NO.

    Assign vLogIniciado = No.
    

End Procedure.

/*************************************************************************************************** 
** Esta procedure ir  obter a lista das tarefas para a transa‡Æo de picking                       **
****************************************************************************************************/
PROCEDURE GetTasks:

    Assign vLogCancela = NO
           vLogErro    = NO.

    Empty Temp-table ttWm-box-movto-idx-picking.

    Run getMovtoTarefasDocto  In  wgeswmpapi002 (INPUT  tt-reqs.id-docto,
                                                INPUT  ttwork.cod-usuario,
                                                Input  ttWork.cod-equipamento,
                                                Input  vCodTipoEquip,
                                                Input  07,
                                                Output Table ttWm-box-movto-idx-picking).
    RETURN 'OK':U.

END PROCEDURE.

PROCEDURE confirmadoca:

    REPEAT ON ENDKEY UNDO, RETRY:
            HIDE ALL.
        
        UPDATE id-doca no-label with frame Frame06.

        FIND FIRST wm-docto WHERE wm-docto.id-docto = ttWm-box-movto-idx-picking.id-docto NO-LOCK NO-ERROR.

        IF id-doca = 999 THEN
            LEAVE.

        IF AVAIL wm-docto THEN DO:
            IF wm-docto.cod-doca = id-doca THEN DO:
                RUN bcp/bc9115.p (0,"Material entregue na doca com sucesso." ,8,20,3).
                LEAVE.
            END.
            ELSE DO:
                RUN bcp/bc9115.p (0,"Doca errada, favor ir na doca " + string(id-doca) ,8,20,3).
                Hide All No-pause.
            END.
        END.

    END.

    
    /*
    ASSIGN id-doca = 0.
    IF tarefa-cod-doca = 0 THEN LEAVE. 
    HIDE ALL.

    MESSAGE tarefa-cod-doca SKIP
            ttWork.cod-usuario
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

    FIND FIRST wm-usuario-tarefa WHERE wm-usuario-tarefa.cod-tarefa  = tarefa-cod-doca
                                 AND   wm-usuario-tarefa.cod-usuario = ttWork.cod-usuario NO-LOCK NO-ERROR.

    IF AVAIL wm-usuario-tarefa THEN DO:

        REPEAT ON ENDKEY UNDO, RETRY:
            HIDE ALL.
            FIND FIRST wm-doca WHERE wm-doca.cod-doca = tarefa-cod-doca NO-LOCK NO-ERROR.

            DISP wm-doca.des-doca @ c-desc-doca WITH FRAME Frame06.

            UPDATE id-doca no-label BLANK with frame Frame06.

            FIND FIRST wm-doca WHERE wm-doca.id-box = id-doca NO-LOCK NO-ERROR.

            IF NOT AVAIL wm-doca THEN DO:
                RUN bcp/bc9115.p (0,"Doca errada, favor ir na doca " + string(tarefa-cod-doca) ,8,20,3).
            END.
            ELSE DO:
                IF wm-doca.cod-doca <> tarefa-cod-doca THEN DO:

                   FIND next wm-doca WHERE wm-doca.id-box = id-doca NO-LOCK NO-ERROR.
                   IF wm-doca.cod-doca <> tarefa-cod-doca THEN DO:
                      RUN bcp/bc9115.p (0,"Doca errada, favor ir na doca " + string(tarefa-cod-doca) ,8,20,3).
        /*             Return Error. */
                   end.
                   ELSE DO:

                       RUN wmp/eswmpapi009.p (INPUT-OUTPUT pIdTarefa,
                                             OUTPUT TABLE RowErrors).

                       IF RETURN-VALUE <> "OK" THEN DO:
                           For Each RowErrors:
                               Hide All No-pause.
                               ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                               Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
                               Hide All No-pause.
                           end. /* Each RowErrors */
                       END.
                       ELSE DO:
                           RUN bcp/bc9115.p (0,"Material entregue na doca com sucesso." ,8,20,3).
                           ASSIGN tarefa-cod-doca = 0
                                  pidtarefa       = 0.
                           LEAVE.
                       END.
                   END.
                END.
                ELSE DO:

                    RUN wmp/eswmpapi009.p (INPUT-OUTPUT pIdTarefa,
                                          OUTPUT TABLE RowErrors).
    
                    IF RETURN-VALUE <> "OK" THEN DO:
                        For Each RowErrors:
                            Hide All No-pause.
                            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                            Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
                            Hide All No-pause.
                        end. /* Each RowErrors */
                    END.
                    ELSE DO:
                        RUN bcp/bc9115.p (0,"Material entregue na doca com sucesso." ,8,20,3).
                        ASSIGN tarefa-cod-doca = 0
                               pidtarefa       = 0.
                        LEAVE.
                    END.
                END.
            END.
        END.
    END.
    */
END PROCEDURE.

PROCEDURE GetTipoSep:

    Assign vLogCancela  = NO
           vLogErro = NO.
    Empty Temp-table ttTipoSeparacao.
    
    IF NOT VALID-HANDLE(wgeswmpapi002) THEN DO:
        Run esp/wmp/eswmpapi002.p Persistent Set wgeswmpapi002       No-error.
    END.    
    
    RUN retornaTipoSeparacao IN wgeswmpapi002 (INPUT ttWork.cod-estabel,
                                               INPUT ttWork.cod-local,
                                               INPUT c-nome-transp,
                                               INPUT ttWork.cod-equipamento,
                                               OUTPUT TABLE ttTipoSeparacao,
                                               OUTPUT TABLE rowerrors).
    IF RETURN-VALUE <> "OK" THEN DO:
        For Each RowErrors:
            Hide All No-pause.
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
            Hide All No-pause.
        end. /* Each RowErrors */
        RETURN ERROR.
    END.
    
    RETURN 'OK':U.

END PROCEDURE.

PROCEDURE GetDocto:

    Assign vLogCancela  = NO
           vLogErro = NO.
    Empty Temp-table tt-reqs.
    
    IF NOT VALID-HANDLE(wgeswmpapi002) THEN DO:
        Run wmp/eswmpapi002.p Persistent Set wgeswmpapi002       No-error.
    END.      

    RUN getDoctosTarefa IN wgeswmpapi002 ( INPUT ttWork.cod-estabel,
                                           INPUT ttWork.cod-local,
                                           INPUT c-tipo-sep,
                                           INPUT c-nome-transp,
                                           INPUT ttWork.cod-equipamento,
                                           OUTPUT TABLE tt-reqs,
                                           OUTPUT TABLE rowerrors).
    IF RETURN-VALUE <> "OK" THEN DO:
        For Each RowErrors:
            Hide All No-pause.
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
            Hide All No-pause.
        end. /* Each RowErrors */
        RETURN ERROR.
    END.
    
    RETURN 'OK':U.

END PROCEDURE.

/*************************************  Codigo do Usuario Fim   ********************************/
&else 

    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif
