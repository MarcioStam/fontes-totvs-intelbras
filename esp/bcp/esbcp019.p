/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9028 2.00.00.024 } /*** 010024 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BC9028 MBC}
&ENDIF

{include/i_dbvers.i}  /* versao das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9029.p                                                                  **
**                                                                                         **
**                                                                                         **
**   Versao....: 2.00.00.000 - abril/2005 - Paulo Eduardo Budal - Cria‡Æo do programa      **
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
**                        Ex. Frame01, Frame01, Frame02, etc.                                     **
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
**                            On Leave of ttWork.cod-depos in Frame Frame01                       **
**                            Do:                                                                 **
**                                Case ttWork.cod-depos:                                          **
**                                  When 'Pro' Then Assign ttWork.cod-local = 'Pro01'.            **
**                                  When 'Alm' Then Assign ttWork.cod-local = 'Alm01'.            **
**                                  When 'Exp' Then Assign ttWork.cod-local = 'Exp01'.            **
**                            End.                                                                **
** AtiveObject1         - Este pro-processador permite que se destruam os objetos persistentes    **
**                        no final da sessao progress.                                            **
**                        Ex: &global-define ActiveObject Hbosc074                               **
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9028
/************************************************************/

{utp/utapi009.i} /* login */
{utp/ut-glob.i}
{cdp/cdcfgmat.i}
{cpp/cpapi001.i} 
{esapi/esapi016.i}

/* Definicao da temp-table de integracao ---                */

&global-define TEMPTABLE tt-reporte-serial-wms
{esp/bcp/esbcp019.i}
{bcp/bc9048.i1} /* definicao variaveis menu padrao */
DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE h-esapi016  AS HANDLE      NO-UNDO.
DEFINE TEMP-TABLE ttwm-etiqueta NO-UNDO LIKE wm-etiqueta.

{method/dbotterr.i}

Define Temp-table ttWork NO-UNDO like {&TempTable}.
Create ttWork.
/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/* ************************** Definitions ******************************** */
DEFINE VARIABLE vcod-senha        AS CHARACTER           NO-UNDO FORMAT 'x(14)':U .
DEFINE VARIABLE vNomeUsuario      AS CHARACTER           NO-UNDO.
DEFINE VARIABLE vLogControlaLogin AS LOGICAL INITIAL NO  NO-UNDO.
DEFINE VARIABLE vProcesso         AS LOGICAL INITIAL NO  NO-UNDO.
DEFINE VARIABLE iUnidContr        AS INTEGER             NO-UNDO.

def var c-modelo       as char no-undo.
def var i-qtd-etiqueta as INT FORMAT ">>9" no-undo.
def var i-qtd-embalag  as INT  no-undo.
def var cPrinter       as CHAR no-undo.
def var i-capacidade   as INT  no-undo.

/*
DEFINE VARIABLE HApiwms AS HANDLE   NO-UNDO.
RUN bcp/bcapiwms.p PERSISTENT SET HApiwms.
*/
DEFINE VARIABLE Hbosc038   AS HANDLE NO-UNDO.
DEFINE VARIABLE Hbosc109   AS HANDLE NO-UNDO.
DEFINE VARIABLE Hbcapiwms  AS HANDLE NO-UNDO.
DEFINE VARIABLE Hbcapi9029 AS HANDLE NO-UNDO.
DEFINE VARIABLE Hbosc044   AS HANDLE NO-UNDO.

DEF TEMP-TABLE tt-ord-prod
    FIELD nr-ord-prod LIKE ord-prod.nr-ord-prod
    FIELD it-codigo   LIKE ord-prod.it-codigo
    INDEX ordem nr-ord-prod.

Define Query qry-ord-prod For tt-ord-prod.

Define Browse brw-ord-prod Query qry-ord-prod No-lock
    DISPLAY tt-ord-prod.nr-ord-prod
        With No-box No-labels Size 20 By 5 No-scrollbar-vertical.

/* --- Knupp - Movimenta‡Æo Utilizando Etiquetas --- */
DEFINE VARIABLE h_bosc047               AS HANDLE                           NO-UNDO.
DEFINE VARIABLE l-utiliz-etiq-movto     AS LOGICAL                 INIT NO  NO-UNDO.
DEFINE VARIABLE c-cod-local             LIKE wm-local.cod-local             NO-UNDO.
DEFINE VARIABLE d-num-serial            AS DECIMAL FORMAT '99999999999999'  NO-UNDO.
DEFINE VARIABLE i-opcao                 AS INTEGER FORMAT "9"               NO-UNDO.
DEFINE VARIABLE l-voltar                AS LOGICAL     NO-UNDO.
/***************************************** Frames Inicio ******************************************/

/* Definicao da Frame01 ---                             */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Reporte Cabos '                                   At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Estab Entrada:'                                   AT ROW 03 COL 01          ~
                              ttWork.cod-estabel                                AT ROW 04 COL 01 NO-LABEL ~
                             'Depos Entrada:'                                   AT ROW 05 COL 01          ~
                              ttWork.cod-depos                                  AT ROW 06 COL 01 NO-LABEL ~

&global-define Frame01Repeat NO

&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Reporte Cabos'                                    At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Linha:'                                           AT ROW 03 COL 01          ~
                              ttWork.nr-linha                                   AT ROW 03 COL 07 NO-LABEL ~
&global-define Frame02Repeat NO

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Reporte Cabos       '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Linha:'                                           AT ROW 03 COL 01          ~
                             ttWork.nr-linha                                    AT ROW 03 COL 06 NO-LABEL ~
                             brw-ord-prod                                       At Row 04 Col 01          ~
&global-define Frame03Repeat NO

/* Definicao da Frame04 ---                                 */
&global-define Frame04Name   Frame04
&global-define Frame04Defs   'Reporte Cabos       '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Linha:'                                           AT ROW 03 COL 01          ~
                             ttWork.nr-linha                                    AT ROW 03 COL 07 NO-LABEL ~
                             'OP:'                                              AT ROW 04 COL 01          ~
                             ttWork.nr-ord-prod                                 AT ROW 04 COL 05 NO-LABEL ~
                             ttWork.cod-item                                    AT ROW 05 COL 01 NO-LABEL VIEW-AS FILL-IN SIZE 08 BY 0.88 ~
                             ttWork.des-item                                    AT ROW 06 COL 01 NO-LABEL ~
                             'Qt:'                                              AT ROW 07 COL 01          ~
                             ttWork.qt-reporte                                  AT ROW 07 COL 04 NO-LABEL ~
                             '1-Conf/2-Can:'                                    AT ROW 08 COL 01          ~
                             i-opcao                                            AT ROW 08 COL 15 NO-LABEL ~
&global-define Frame04Repeat NO

/* Definicao da Frame05 ---                                 */
&global-define Frame05Name   Frame05
&global-define Frame05Defs   'Reporte Cabos     '               At Row 01 Col 01          ~
                             '------------------':U             At Row 02 Col 01          ~
                             'OP  :'                            At Row 03 Col 01          ~
                             ttWork.nr-ord-prod                 At Row 03 Col 06 No-label ~
                             'Item:'                            At Row 04 Col 01          ~
                             ttWork.cod-item                    At Row 04 Col 07 NO-LABEL VIEW-AS FILL-IN SIZE 08 BY 0.88 ~
                             'Qt Etiq:'                         At Row 05 Col 01          ~
                             i-qtd-etiqueta                     At Row 05 COL 09 No-label ~
&global-define Frame05Repeat NO
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-estabel ttWork.cod-depos
&GLOBAL-DEFINE Update02Fields ttWork.nr-linha
&GLOBAL-DEFINE Update03Fields brw-ord-prod
&GLOBAL-DEFINE Update04Fields ttWork.qt-reporte i-opcao 
&GLOBAL-DEFINE Update05Fields i-qtd-etiqueta
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02.
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03.
&global-define TriggerBeforeFrame04 Run InicializaCamposFrame04. 
&global-define TriggerBeforeFrame05 Run InicializaCamposFrame05. IF l-voltar THEN LEAVE _Frame05. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02.
&global-define TriggerAfterFrame03  Run GravaCamposFrame03.
&global-define TriggerAfterFrame04  Run GravaCamposFrame04. 
&global-define TriggerAfterFrame05  Run GravaCamposFrame05. IF l-voltar THEN LEAVE _Frame05. 

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ~
                            ON 'ESC':U OF Frame Frame01 ~
                            DO:                         ~
                                ASSIGN vlogerro = YES.  ~
                                Return 'ESC':U.         ~
                            END.                        ~
                            ON 'ESC':U OF Frame Frame02 ~
                            DO:                         ~
                                ASSIGN vlogerro = YES.  ~
                                Return 'ESC':U.         ~
                            END.                        ~
                            ON 'ESC':U OF Frame Frame03 ~
                            DO:                         ~
                                ASSIGN vlogerro = YES.  ~
                                Return 'ESC':U.         ~
                            END.                        ~
                            ON 'ESC':U OF Frame Frame04 ~
                            DO:                         ~
                                ASSIGN vlogerro = YES.  ~
                                Return 'ESC':U.         ~
                            END.                        ~
                            ON 'Return':U   OF brw-ord-prod In Frame {&Frame03Name}                        ~
                            DO:                                                                            ~
                               Apply 'Go':U To This-procedure.                                             ~
                            END.                                                                           ~
                            ON 'Return':U OF brw-ord-prod In Frame {&Frame03Name}                          ~
                            DO:                                                                            ~
                               ASSIGN ttWork.nr-ord-prod = tt-ord-prod.nr-ord-prod                         ~
                                      ttWork.cod-item    = tt-ord-prod.it-codigo.                          ~
                               Apply 'Go':U To This-procedure.                                             ~
                            END.                                                                           ~
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 Hbcapiwms
&global-define ActiveObject2 Hbcapi9029

/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ‚ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame01 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame01:
    ASSIGN vLogErro     = NO                               
           vLogsai      = NO                               
           vLogfinaliza = NO.
    
    IF v_cod_usuar_corren = '' THEN RETURN ERROR.
    FIND FIRST ttwork NO-ERROR.
    ASSIGN ttWork.cod-estabel = "111"
           ttWork.cod-depos   = "".

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame03 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
********************************************************************
********************************/
Procedure InicializaCamposFrame02:

    ASSIGN vLogErro     = NO
           vLogsai      = NO
           vLogfinaliza = NO.

    FIND FIRST ttWork NO-LOCK NO-ERROR.

    ASSIGN ttWork.nr-linha   = 0
           ttWork.nr-linha:SCREEN-VALUE IN FRAME Frame02 = string(ttWork.nr-linha).

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame01 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame03:
    ASSIGN vLogErro     = NO                               
           vLogsai      = NO                               
           vLogfinaliza = NO
           l-voltar     = NO.

    ASSIGN ttWork.nr-linha:SCREEN-VALUE IN FRAME Frame03   = string(ttWork.nr-linha).
    
    RUN piBuscaOrdens.
    
    FIND FIRST tt-ord-prod NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-ord-prod THEN DO:
       CREATE tt-ord-prod.
       ASSIGN tt-ord-prod.nr-ord-prod = 0
              tt-ord-prod.it-codigo   = 'Sem Ordens.'.
       IF NOT AVAIL ord-prod THEN DO:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "210" "Sem ordens para listar"}
            Return Error.
        END.
    END.

    Open Query qry-ord-prod For Each tt-ord-prod
                                  By tt-ord-prod.nr-ord-prod.
    BROWSE brw-ord-prod:REFRESH() NO-ERROR.

    RETURN "OK".

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame01 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame04:
    ASSIGN vLogErro     = NO                               
           vLogsai      = NO                               
           vLogfinaliza = NO.
    
    FIND FIRST ITEM
         WHERE ITEM.it-codigo = ttWork.cod-item NO-LOCK NO-ERROR.
    IF AVAIL ITEM THEN
        ASSIGN ttWork.des-item   = ITEM.desc-item.

    FIND FIRST ord-prod NO-LOCK
         WHERE ord-prod.nr-ord-prod = ttWork.nr-ord-prod NO-ERROR.

    ASSIGN ttWork.qt-reporte = ord-prod.qt-ordem - ord-prod.qt-produzida.

    DISP ttWork.nr-linha
         ttWork.nr-ord-prod
         ttWork.cod-item
         ttWork.des-item
         ttWork.qt-reporte
        WITH FRAME Frame04.
    
    RETURN "OK".

End Procedure.

Procedure InicializaCamposFrame05:

    ASSIGN vLogErro     = NO                               
           vLogsai      = NO                               
           vLogfinaliza = NO.

    DISP ttWork.nr-ord-prod
         ttWork.cod-item
        WITH FRAME Frame05.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:

    Assign vLogErro           = NO 
           vLogControlaLogin  = NO.

    FIND FIRST estabelec
        WHERE estabelec.cod-estabel = INPUT FRAME Frame01 ttWork.cod-estabel NO-LOCK NO-ERROR.
    IF  NOT AVAIL estabelec THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "101" "Estabelecimento Inv lido (DC)"}
    END.
    IF vLogErro = Yes Then Return Error.

    FIND FIRST deposito
        WHERE deposito.cod-depos = INPUT FRAME Frame01 ttWork.cod-depos NO-LOCK NO-ERROR.
    IF  NOT AVAIL deposito THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "102" "Dep¢sito Inv lido (DC)"}
    END.
    
    IF vLogErro = Yes Then Return Error.
    
    ASSIGN {&TempTable}.cod-estabel   = INPUT FRAME Frame01 ttWork.cod-estabel
           {&TempTable}.cod-depos     = INPUT FRAME Frame01 ttWork.cod-depos.

End Procedure.                                                                 

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame02:

    ASSIGN vLogErro = NO.

    FIND FIRST lin-prod NO-LOCK
         WHERE lin-prod.nr-linha = ttWork.nr-linha NO-ERROR.
    IF NOT AVAIL lin-prod THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "103" "Linha nÆo cadastrada (DC)"}
    END.
    
    IF vLogErro = Yes Then Return Error.

    RETURN "OK".

End Procedure.

Procedure GravaCamposFrame03:

    ASSIGN vLogErro = NO.

End Procedure.

Procedure GravaCamposFrame04:

    ASSIGN vLogErro = NO.

    IF  INPUT FRAME Frame04 i-opcao <> 1
    AND INPUT FRAME Frame04 i-opcao <> 2 THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "104" "Op‡Æo Inv lida. (DC)"}
    END.
    IF vLogErro = Yes Then Return Error.

    IF INPUT FRAME Frame04 i-opcao = 2 THEN DO:
        ASSIGN l-voltar = YES.
    END.
    ELSE DO:

        IF vLogErro = Yes Then Return Error.
    
        FIND FIRST ord-prod
             WHERE ord-prod.nr-ord-produ = ttWork.nr-ord-prod NO-LOCK NO-ERROR.
    
        FIND FIRST ITEM
             WHERE ITEM.it-codigo = ord-prod.it-codigo NO-LOCK NO-ERROR.
        
        IF NOT AVAILABLE ITEM THEN DO:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "105" "Item Inexistente. (DC)"}
        END.
        IF vLogErro = Yes Then Return Error.
        
        IF NOT AVAIL ord-prod THEN DO:
           ASSIGN ttWork.num-livre-1 = ITEM.rep-prod.
        END.
        ELSE DO:
           ASSIGN ttWork.num-livre-1 = ord-prod.rep-prod.
        END.
        
        IF  ord-prod.cod-estabel <> INPUT FRAME Frame01 ttWork.cod-estabel THEN DO:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "106" "Estabelecimento informado no coletor ‚ diferente do estabelecimento da Ordem de Produ‡Æo (DC)"}
        END.
        IF vLogErro = Yes Then Return Error.
        
        IF  vLogErro = NO THEN 
            RUN piReporta.
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE GravaCamposFrame05:

    ASSIGN vLogErro = NO.

    // Imprime Etiqueta
    RUN esapi/esapi016.p PERSISTENT SET h-esapi016.

    ASSIGN c-modelo = "".
    FIND FIRST item-mod-etiq NO-LOCK
         WHERE item-mod-etiq.it-codigo = ord-prod.it-codigo NO-ERROR.
    IF AVAIL item-mod-etiq THEN
        ASSIGN c-modelo = string(item-mod-etiq.cod-modelo).

    IF c-modelo = "" THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "108" "Modelo etiqueta nÆo cadastrado para o item. Imprima manualmente (DC)"}
    END.
    IF vLogErro = Yes Then Return Error.

    ASSIGN cPrinter = "".
    FOR FIRST imprsor_usuar NO-LOCK
        WHERE imprsor_usuar.cod_usuario = c-seg-usuario
        AND   imprsor_usuar.log_imprsor_princ:
    
        FOR FIRST layout_impres NO-LOCK
            WHERE layout_impres.nom_impressora = imprsor_usuar.nom_impressora
            AND   layout_impres.log_layout_impres_princ:
    
            ASSIGN cPrinter = layout_impres.nom_impressora + ":" +
                              layout_impres.cod_layout_impres.
        END.
    END.

    IF cPrinter = "" THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "109" "Impressora nÆo cadastrada. Imprima manualmente (DC)"}
    END.
    IF vLogErro = Yes Then Return Error.

    RUN piImpressao IN h-esapi016 (INPUT 0, // Num PO
                                   INPUT ord-prod.it-codigo,
                                   INPUT c-modelo,
                                   INPUT "CABOS",
                                   INPUT i-qtd-etiqueta,
                                   INPUT i-qtd-embalag,
                                   INPUT 0,  // Motivo ReimpressÆo 
                                   INPUT 0,  // Pedido de Compra 
                                   INPUT cPrinter,
                                   INPUT 4,  // NÆo valida nada, pois j  foi validado na gera‡Æo. 
                                   INPUT NO, //tg-astec
                                   INPUT i-capacidade,
                                   INPUT TABLE tt-lista-ns).
                                   
    IF RETURN-VALUE <> "OK":U THEN DO:
        EMPTY TEMP-TABLE tt-erro.
        RUN piRetornaErros IN h-esapi016 (OUTPUT TABLE tt-erro).
        IF CAN-FIND(FIRST tt-erro) THEN DO:
            FOR EACH tt-erro:
                {bcp/bc9015.i2 STRING(tt-erro.cd-erro) STRING(tt-erro.mensagem)}
            END.
        END.
    END.
    ELSE DO:
        {bcp/bc9105.i "901" "Etiqueta enviada para a impressora (DC)"}
    END.

    DELETE PROCEDURE h-esapi016.

    RETURN "OK".

END PROCEDURE.

PROCEDURE piBuscaOrdens:

    FOR EACH tt-ord-prod:
        DELETE tt-ord-prod.
    END.

    FOR EACH ord-prod USE-INDEX linha NO-LOCK
       WHERE ord-prod.nr-linha = ttWork.nr-linha 
         //AND ord-prod.nr-ord-prod = 4467270
         AND ord-prod.estado   < 7 : // Terminada
    
        FIND FIRST tt-ord-prod
             WHERE tt-ord-prod.nr-ord-prod = ord-prod.nr-ord-prod NO-ERROR.
        IF NOT AVAIL tt-ord-prod THEN DO:
            CREATE tt-ord-prod.
            ASSIGN tt-ord-prod.nr-ord-prod = ord-prod.nr-ord-prod
                   tt-ord-prod.it-codigo   = ord-prod.it-codigo.
        END.
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE piReporta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var d-qt-saldo   as dec  no-undo.
    def var c-return     as char no-undo.
    def var de-qt-etiq   as dec  no-undo.
    def var i-cont       as int  no-undo init 1.
    def var msg          as char no-undo.

    empty temp-table tt-rep-prod.
    empty temp-table tt-erro.

    create tt-rep-prod.
    assign tt-rep-prod.tipo                   = 1
           tt-rep-prod.nr-ord-produ           = ord-prod.nr-ord-produ
           tt-rep-prod.data                   = today
           tt-rep-prod.cod-depos              = ttWork.cod-depos
           tt-rep-prod.cod-depos-sai          = ord-prod.cod-depos
           tt-rep-prod.baixa-reservas         = 1
           tt-rep-prod.carrega-reservas       = yes
           tt-rep-prod.reserva                = yes
           tt-rep-prod.nro-docto              = string(ord-prod.nr-ord-produ)
           tt-rep-prod.serie-docto            = "OP"
           tt-rep-prod.finaliza-ordem         = no
           tt-rep-prod.cod-versao-integracao  = 1
           tt-rep-prod.it-codigo              = ord-prod.it-codigo
           tt-rep-prod.un                     = ord-prod.un
           tt-rep-prod.nro-ord-seq            = 1
           tt-rep-prod.lote-serie             = string(ord-prod.nr-ord-prod)
           tt-rep-prod.dt-vali-lote           = 12/31/9999
           tt-rep-prod.qt-reporte             = ttWork.qt-reporte.

    if  ord-prod.qt-produzida + ttWork.qt-reporte >= ord-prod.qt-ordem then
        tt-rep-prod.finaliza-ordem = yes.

    run cpp/cpapi001.p (input-output table tt-rep-prod,
                        input        table tt-refugo,
                        input        table tt-res-neg,
                        input        table tt-apont-mob,
                        input-output table tt-erro,
                        input        yes) no-error.

    if  can-find(first tt-erro) THEN DO:
        FIND FIRST tt-erro NO-ERROR.
         Assign vLogErro = Yes.
        FOR EACH tt-erro:
            {bcp/bc9015.i2 STRING(tt-erro.cd-erro) STRING(tt-erro.mensagem)}
        END.
    END.
      IF vLogErro = Yes Then Return Error.

    IF vLogErro = NO THEN DO:
        {bcp/bc9105.i "901" "Reporte realizado com Sucesso (DC)"}
    END.

    return 'ok'.

end procedure.
