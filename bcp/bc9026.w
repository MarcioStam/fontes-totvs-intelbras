&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9026 2.00.00.095 } /*** "010095" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bc9026 MBC}
&ENDIF

{include/i_dbinst.i}  /*Preprocessadores que identificam os bancos do Produto EMS 2*/

CREATE WIDGET-POOL.

{cdp/cdcfgmat.i}
{utp/ut-glob.i}

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        BC9026
&GLOBAL-DEFINE Version        2.00.00.093

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Ord Prod, ITEM, Doc WMS, Rec F°sico

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp

&GLOBAL-DEFINE page1Widgets  op-ordem op-lote op-dep-saida op-local op-referencia ~
                             op-loc-saida op-dt-validade-lote op-quantidade bt-op-executar br-op-tela ~
                             bt-imprimir-op bt-imprimir-todos-op btHelp-op rtToolBar-op bt-incluir-op ~
                             bt-modificar-op bt-eliminar-op op-total-qtd-item

&GLOBAL-DEFINE page2Widgets  it-item it-desc-item it-estab it-lote it-dep-saida it-local it-referencia ~
                             it-loc-saida it-dt-validade-lote it-quantidade bt-it-executar br-it-tela ~
                             bt-imprimir-it bt-imprimir-todos-it btHelp-it rtToolBar-it bt-incluir-it ~
                             bt-modificar-it bt-eliminar-it it-total-qtd-item

&GLOBAL-DEFINE page3Widgets  dc-numero dc-estab dc-lote dc-id-docto dc-local dc-referencia ~
                             dc-dt-validade-lote bt-dc-executar br-dc-tela ~
                             bt-imprimir-dc bt-imprimir-todos-dc btHelp-dc rtToolBar-dc bt-incluir-dc ~
                             bt-modificar-dc bt-eliminar-dc dc-total-qtd-item

&GLOBAL-DEFINE page4Widgets  rf-numero rf-serie cb-rf-tp-nota rf-emitente rf-desc-emitente ~
                             rf-estab rf-local bt-rf-executar br-rf-tela ~
                             bt-imprimir-rf bt-imprimir-todos-rf btHelp-rf rtToolBar-rf bt-incluir-rf ~
                             bt-modificar-rf bt-eliminar-rf rf-total-qtd-item

/* Parameters Definitions ---                                           */
/* Includes --       */
{include/i_dbvers.i}
{cdp/cdcfgwms.i}      
{bcp/bc9026.i}
{bcp/bcapi002.i}    /*** Definicao da temp-table para a API de criacao de etiquetas tt-etiqueta ***/
{bcp/bcapi001.i}    /* Definicao da temp-table tt-trans ---                     */
{bcp/bc9102.i}      /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}      /* Campos de comunicacao com o adapter                          */
/*{method/dbotterr.i} /* Temp Table RowErros */*/
DEFINE BUFFER bftt-browse-tela FOR tt-browse-tela.

DEF TEMP-TABLE tt-embalagem NO-UNDO
    FIELD CodItem            AS CHARACTER FORMAT "X(16)":U
    FIELD CodRefer           AS CHARACTER FORMAT "X(8)":U
    FIELD CodLote            AS CHARACTER FORMAT "X(40)":U
    FIELD DtValidadeLote     AS DATE      
    FIELD NumSeqItem         AS INTEGER 
    FIELD CodEmbalagem       AS CHARACTER FORMAT "X(010)":U
    FIELD Cod-emb-pai        AS CHARACTER FORMAT "X(010)":U
    FIELD logPai             AS LOGICAL
    FIELD ControlaEtiqueta   AS LOGICAL
    FIELD QtdItemEmbalagem   AS DECIMAL   FORMAT "999,999,999,999.9999":U
    FIELD QtdEmbalagem       AS DECIMAL   FORMAT "999,999,999,999.9999":U
    FIELD QtdItem            AS DECIMAL   FORMAT "999,999,999,999.9999":U
    FIELD CodLayoutItem      AS INTEGER   FORMAT "9999":U
    FIELD CodLayoutEmbalagem AS INTEGER   FORMAT "9999":U
    FIELD CodBarrasItem      AS CHARACTER FORMAT "X(100)":U
    FIELD CodBarrasEmbalagem AS CHARACTER FORMAT "X(100)":U
    FIELD id-movto           AS DECIMAL   FORMAT ">>>>>>>>>9".

DEF TEMP-TABLE ttSerialAux NO-UNDO
        FIELD de-serial AS DECIMAL.

DEF TEMP-TABLE tt-rat-lote NO-UNDO LIKE rat-lote.
DEFINE TEMP-TABLE tt-divergencia NO-UNDO LIKE tt-browse-tela.

/* Definitions */
DEFINE NEW GLOBAL SHARED VAR c-seg-usuario  AS CHARACTE FORMAT "x(12)" NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE                  NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR gcod-programa  AS CHARACTER               NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR l-ckd          as LOG INITIAL NO no-undo.

DEFINE VARIABLE wh-pesquisa     AS HANDLE  NO-UNDO.
DEFINE VARIABLE cCdTrans        AS CHARACTER INITIAL "WMOUT004" NO-UNDO. /*Guarda o c¢digo da transacao */
DEFINE VARIABLE deCarga         AS DECIMAL   INITIAL 0          NO-UNDO.
DEFINE VARIABLE dtValidadeLote  AS DATE                         NO-UNDO.  /*Armazena a data de validade da ultima ordem lida*/

DEFINE VAR i-num-seq-item        LIKE wm-docto-itens.num-seq-item NO-UNDO.
DEFINE VAR c-it-codigo           LIKE wm-item.cod-item            NO-UNDO.
DEFINE VAR c-lote                LIKE wm-docto-itens.cod-lote     NO-UNDO.
DEFINE VAR c-cod-refer           LIKE wm-docto-itens.cod-refer    NO-UNDO.
DEFINE VAR c-cod-embalagem       LIKE wm-embalagem.cod-embalagem  NO-UNDO.
DEFINE VAR de-qtd-item           LIKE wm-docto-itens.qtd-item     NO-UNDO.
DEFINE VAR de-qtd-item-embalagem LIKE wm-docto-itens.qtd-item     NO-UNDO.
DEFINE VAR de-qtd-peso-item      LIKE wm-docto-itens.qtd-peso     NO-UNDO.
DEFINE VAR de-qtd-etiqueta       LIKE wm-docto-itens.qtd-item     NO-UNDO.
DEFINE VAR dePesoItem            LIKE wm-docto-itens.qtd-peso     NO-UNDO.
DEFINE VAR dt-validadeLote       AS DATE                          NO-UNDO.   

DEFINE VARIABLE l-verifUtilizEtiqMovto-upc-bc9026 AS LOGICAL      NO-UNDO.

/* hbos */
DEFINE VARIABLE hbosc038    AS HANDLE     NO-UNDO. /* wm-docto */
DEFINE VARIABLE hbosc047    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hbosc074    AS HANDLE     NO-UNDO. /* wm-etiqueta */
DEFINE VARIABLE hbosc073    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hbosc050    AS HANDLE     NO-UNDO. /*  */
DEFINE VARIABLE hboin281    AS HANDLE     NO-UNDO. /* param-cp */
DEFINE VARIABLE hboin367    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hbosc075    AS HANDLE     NO-UNDO. /* carga wms */
DEFINE VARIABLE hbosc044    AS HANDLE     NO-UNDO. /* item wms */
DEFINE VARIABLE hbosc112    AS HANDLE     NO-UNDO. /* movto etiqueta WMS */
DEFINE VARIABLE hboin089    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hdboad098na AS HANDLE     NO-UNDO.
DEFINE VARIABLE hbosc039    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hinbo403    AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-acomp     AS HANDLE     NO-UNDO.

/* Temp-tables */
DEFINE TEMP-TABLE ttWm-carga NO-UNDO LIKE wm-carga
     field RowNum  as integer
     field r-Rowid as rowid.


DEFINE TEMP-TABLE ttWm-docto NO-UNDO LIKE wm-docto
          field RowNum  as integer
          field r-Rowid as rowid.

DEF TEMP-TABLE ttWm-Etiqueta  NO-UNDO LIKE wm-etiqueta. /*Utilizado na bo de geracao da wm-etiqueta*/

DEF TEMP-TABLE ttWm-Etiqueta-rf NO-UNDO LIKE wm-etiqueta /*Utilizado na bo de geracao da wm-etiqueta*/
    FIELD RowNum AS INTEGER INIT 1
    field r-Rowid as rowid.

DEFINE VARIABLE i-id-docto LIKE wm-docto.id-docto    NO-UNDO.
DEFINE VARIABLE l-utiliz-etiq-movto AS LOGICAL     NO-UNDO.

DEF TEMP-TABLE  ttdoc-fisico NO-UNDO LIKE doc-fisico
    FIELD r-Rowid AS ROWID.




DEFINE VARIABLE c-item-aux           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-item-ckd           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-estab-aux          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lista              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-inicial            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lote-alt           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-depos          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-loc-saida-aux      AS CHARACTER FORMAT "x(20)" NO-UNDO.

DEFINE VARIABLE i-registros          AS INTEGER NO-UNDO.
DEFINE VARIABLE i-cont               AS INTEGER NO-UNDO.                 
DEFINE VARIABLE i-pos                AS INTEGER NO-UNDO.
DEFINE VARIABLE i-qtd-etiqueta-total AS INTEGER NO-UNDO.
DEFINE VARIABLE i-qtd-movto-etiqueta AS INTEGER NO-UNDO.
DEFINE VARIABLE i-qtd-etiqueta-emb   AS INTEGER NO-UNDO.
DEFINE VARIABLE iTipoConEst          AS INTEGER NO-UNDO.
DEFINE VARIABLE i-tp-nota            AS INTEGER FORMAT ">9":U  NO-UNDO.

DEFINE VARIABLE de-qtd-item-total    AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-qtd-item-filha    AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-qtd-item-emb      AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-qtd-movto-item    AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-qtd-item-row      AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-aux               AS DECIMAL NO-UNDO.

DEFINE VARIABLE l-selecionada        AS LOGICAL NO-UNDO.
DEFINE VARIABLE c-select             AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-qtd-item           AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-qtd-etiqueta       AS LOGICAL NO-UNDO.


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-dc-tela

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-browse-tela

/* Definitions for BROWSE br-dc-tela                                    */
&Scoped-define FIELDS-IN-QUERY-br-dc-tela num-seq IT-CODIGO cod-refer lote dt-validade-lote qtd-item qtd-item-embalagem cod-embalagem qtd-peso-item qtd-etiqueta layout-etiqueta cod-ean cod-dun desc-tipo-etiqueta   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-dc-tela   
&Scoped-define SELF-NAME br-dc-tela
&Scoped-define QUERY-STRING-br-dc-tela FOR EACH tt-browse-tela.     APPLY "VALUE-CHANGE" TO br-dc-tela
&Scoped-define OPEN-QUERY-br-dc-tela OPEN QUERY {&SELF-NAME} FOR EACH tt-browse-tela.     APPLY "VALUE-CHANGE" TO br-dc-tela.
&Scoped-define TABLES-IN-QUERY-br-dc-tela tt-browse-tela
&Scoped-define FIRST-TABLE-IN-QUERY-br-dc-tela tt-browse-tela


/* Definitions for BROWSE br-it-tela                                    */
&Scoped-define FIELDS-IN-QUERY-br-it-tela num-seq IT-CODIGO cod-refer lote dt-validade-lote qtd-item qtd-item-embalagem cod-embalagem qtd-peso-item qtd-etiqueta layout-etiqueta cod-ean cod-dun desc-tipo-etiqueta   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-it-tela   
&Scoped-define SELF-NAME br-it-tela
&Scoped-define QUERY-STRING-br-it-tela FOR EACH tt-browse-tela.     APPLY "VALUE-CHANGE" TO br-it-tela
&Scoped-define OPEN-QUERY-br-it-tela OPEN QUERY {&SELF-NAME} FOR EACH tt-browse-tela.     APPLY "VALUE-CHANGE" TO br-it-tela.
&Scoped-define TABLES-IN-QUERY-br-it-tela tt-browse-tela
&Scoped-define FIRST-TABLE-IN-QUERY-br-it-tela tt-browse-tela


/* Definitions for BROWSE br-op-tela                                    */
&Scoped-define FIELDS-IN-QUERY-br-op-tela num-seq IT-CODIGO cod-refer lote dt-validade-lote qtd-item qtd-item-embalagem cod-embalagem qtd-peso-item qtd-etiqueta layout-etiqueta cod-ean cod-dun desc-tipo-etiqueta   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-op-tela   
&Scoped-define SELF-NAME br-op-tela
&Scoped-define QUERY-STRING-br-op-tela FOR EACH tt-browse-tela.     APPLY "VALUE-CHANGE" TO br-op-tela
&Scoped-define OPEN-QUERY-br-op-tela OPEN QUERY {&SELF-NAME} FOR EACH tt-browse-tela.     APPLY "VALUE-CHANGE" TO br-op-tela.
&Scoped-define TABLES-IN-QUERY-br-op-tela tt-browse-tela
&Scoped-define FIRST-TABLE-IN-QUERY-br-op-tela tt-browse-tela


/* Definitions for BROWSE br-rf-tela                                    */
&Scoped-define FIELDS-IN-QUERY-br-rf-tela num-seq IT-CODIGO cod-refer lote dt-validade-lote qtd-item qtd-item-embalagem cod-embalagem qtd-peso-item qtd-etiqueta layout-etiqueta cod-ean cod-dun desc-tipo-etiqueta   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-rf-tela   
&Scoped-define SELF-NAME br-rf-tela
&Scoped-define QUERY-STRING-br-rf-tela FOR EACH tt-browse-tela.     APPLY "VALUE-CHANGE" TO br-rf-tela
&Scoped-define OPEN-QUERY-br-rf-tela OPEN QUERY {&SELF-NAME} FOR EACH tt-browse-tela.     APPLY "VALUE-CHANGE" TO br-rf-tela.
&Scoped-define TABLES-IN-QUERY-br-rf-tela tt-browse-tela
&Scoped-define FIRST-TABLE-IN-QUERY-br-rf-tela tt-browse-tela


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-op-tela}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-br-it-tela}

/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-br-dc-tela}

/* Definitions for FRAME fPage4                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage4 ~
    ~{&OPEN-QUERY-br-rf-tela}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btQueryJoins btReportsJoins btExit btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image/im-joi":U
     IMAGE-INSENSITIVE FILE "image/ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image/im-pri":U
     IMAGE-INSENSITIVE FILE "image/ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON bt-eliminar-op 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-imprimir-op 
     LABEL "Imprimir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-imprimir-todos-op 
     LABEL "Imprimir Todos" 
     SIZE 11.29 BY 1.

DEFINE BUTTON bt-incluir-op 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-modificar-op 
     LABEL "Modificar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-op-executar 
     IMAGE-UP FILE "image/im-cq.bmp":U
     LABEL "Button 1" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp-op 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE VARIABLE op-cod-embalagem AS CHARACTER FORMAT "X(10)" 
     LABEL "Embal" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE op-dep-saida AS CHARACTER FORMAT "X(3)":U 
     LABEL "Dep Sa°da" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE op-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .88 NO-UNDO.

DEFINE VARIABLE op-dt-validade-lote AS DATE FORMAT "99/99/9999":U 
     LABEL "Validade Lote" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .88 NO-UNDO.

DEFINE VARIABLE op-item AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE op-loc-saida AS CHARACTER FORMAT "X(3)":U 
     LABEL "Loc Sa°" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .88 NO-UNDO.

DEFINE VARIABLE op-local AS CHARACTER FORMAT "X(3)":U 
     LABEL "Local WMS" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .88 NO-UNDO.

DEFINE VARIABLE op-lote AS CHARACTER FORMAT "X(40)":U 
     LABEL "Lote" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE op-ordem AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Ordem Producao" 
     VIEW-AS FILL-IN 
     SIZE 14.14 BY .88 NO-UNDO.

DEFINE VARIABLE op-quantidade AS DECIMAL FORMAT ">>,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Quantidade" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE op-referencia AS CHARACTER FORMAT "X(8)":U 
     LABEL "Referància" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .88 NO-UNDO.

DEFINE VARIABLE op-total-qtd-item AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Total" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 4.54.

DEFINE RECTANGLE rtToolBar-op
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 87.57 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON bt-eliminar-it 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-imprimir-it 
     LABEL "Imprimir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-imprimir-todos-it 
     LABEL "Imprimir Todos" 
     SIZE 11.29 BY 1.

DEFINE BUTTON bt-incluir-it 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-it-executar 
     IMAGE-UP FILE "image/im-cq.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-modificar-it 
     LABEL "Modificar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp-it 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE VARIABLE it-cod-embalagem AS CHARACTER FORMAT "X(10)" 
     LABEL "Embal" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE it-dep-saida AS CHARACTER FORMAT "X(3)":U 
     LABEL "Dep Sa°da" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE it-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 46.57 BY .88 NO-UNDO.

DEFINE VARIABLE it-dt-validade-lote AS DATE FORMAT "99/99/9999":U 
     LABEL "Validade Lote" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .88 NO-UNDO.

DEFINE VARIABLE it-estab AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE it-item AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE it-loc-saida AS CHARACTER FORMAT "X(3)":U 
     LABEL "Loc Sa°" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .88 NO-UNDO.

DEFINE VARIABLE it-local AS CHARACTER FORMAT "X(3)":U 
     LABEL "Local WMS" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .88 NO-UNDO.

DEFINE VARIABLE it-lote AS CHARACTER FORMAT "X(40)":U 
     LABEL "Lote" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE it-quantidade AS DECIMAL FORMAT ">>,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Quantidade" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE it-referencia AS CHARACTER FORMAT "X(8)":U 
     LABEL "Referància" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .88 NO-UNDO.

DEFINE VARIABLE it-total-qtd-item AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Total" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 4.54.

DEFINE RECTANGLE rtToolBar-it
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 87.57 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON bt-dc-executar 
     IMAGE-UP FILE "image/im-cq.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-eliminar-dc 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-imprimir-dc 
     LABEL "Imprimir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-imprimir-todos-dc 
     LABEL "Imprimir Todos" 
     SIZE 11.29 BY 1.

DEFINE BUTTON bt-incluir-dc 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-modificar-dc 
     LABEL "Modificar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp-dc 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE VARIABLE dc-cod-embalagem AS CHARACTER FORMAT "X(10)" 
     LABEL "Embal" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE dc-dt-validade-lote AS DATE FORMAT "99/99/9999":U 
     LABEL "Validade Lote" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .88 NO-UNDO.

DEFINE VARIABLE dc-estab AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE dc-id-docto AS DECIMAL FORMAT ">>>>>>>>>9":U INITIAL 0 
     LABEL "ID Docto" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE dc-local AS CHARACTER FORMAT "X(3)":U 
     LABEL "Local WMS" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .88 NO-UNDO.

DEFINE VARIABLE dc-lote AS CHARACTER FORMAT "X(40)":U 
     LABEL "Lote" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE dc-numero AS CHARACTER FORMAT "X(16)":U 
     LABEL "N£mero Docto" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE dc-referencia AS CHARACTER FORMAT "X(8)":U 
     LABEL "Referància" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .88 NO-UNDO.

DEFINE VARIABLE dc-total-qtd-item AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Total" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 4.54.

DEFINE RECTANGLE rtToolBar-dc
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 87.57 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON bt-eliminar-rf 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-imprimir-rf 
     LABEL "Imprimir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-imprimir-todos-rf 
     LABEL "Imprimir Todos" 
     SIZE 11.29 BY 1.

DEFINE BUTTON bt-incluir-rf 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-modificar-rf 
     LABEL "Modificar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-rf-executar 
     IMAGE-UP FILE "image/im-cq.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp-rf 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb-rf-tp-nota AS CHARACTER FORMAT "X(30)":U 
     LABEL "Tipo Nota" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 19 BY 1 NO-UNDO.

DEFINE VARIABLE rf-cod-embalagem AS CHARACTER FORMAT "X(10)" 
     LABEL "Embal" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE rf-desc-emitente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48.72 BY .88 NO-UNDO.

DEFINE VARIABLE rf-emitente AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 14.14 BY .88 NO-UNDO.

DEFINE VARIABLE rf-estab AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE rf-local AS CHARACTER FORMAT "X(3)":U 
     LABEL "Local WMS" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .88 NO-UNDO.

DEFINE VARIABLE rf-numero AS CHARACTER FORMAT "X(16)":U 
     LABEL "N£mero Docto" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE rf-serie AS CHARACTER FORMAT "X(5)":U 
     LABEL "SÇrie" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE rf-total-qtd-item AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Total" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 4.54.

DEFINE RECTANGLE rtToolBar-rf
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 87.57 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-dc-tela FOR 
      tt-browse-tela SCROLLING.

DEFINE QUERY br-it-tela FOR 
      tt-browse-tela SCROLLING.

DEFINE QUERY br-op-tela FOR 
      tt-browse-tela SCROLLING.

DEFINE QUERY br-rf-tela FOR 
      tt-browse-tela SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-dc-tela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-dc-tela wWindow _FREEFORM
  QUERY br-dc-tela DISPLAY
      num-seq      
IT-CODIGO
cod-refer             
lote  WIDTH 12
dt-validade-lote
qtd-item   
qtd-item-embalagem 
cod-embalagem
qtd-peso-item
qtd-etiqueta     
layout-etiqueta
cod-ean           
cod-dun   
desc-tipo-etiqueta
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 86 BY 8.25
         FONT 1 ROW-HEIGHT-CHARS .67 FIT-LAST-COLUMN.

DEFINE BROWSE br-it-tela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-it-tela wWindow _FREEFORM
  QUERY br-it-tela DISPLAY
      num-seq      
IT-CODIGO
cod-refer             
lote  WIDTH 12
dt-validade-lote
qtd-item   
qtd-item-embalagem 
cod-embalagem
qtd-peso-item
qtd-etiqueta     
layout-etiqueta   
cod-ean           
cod-dun   
desc-tipo-etiqueta
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 86 BY 8.25
         FONT 1 ROW-HEIGHT-CHARS .67 FIT-LAST-COLUMN.

DEFINE BROWSE br-op-tela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-op-tela wWindow _FREEFORM
  QUERY br-op-tela DISPLAY
      num-seq  
IT-CODIGO
cod-refer
lote  WIDTH 12
dt-validade-lote
qtd-item
qtd-item-embalagem
cod-embalagem
qtd-peso-item
qtd-etiqueta
layout-etiqueta
cod-ean
cod-dun
desc-tipo-etiqueta
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 86 BY 8.25
         FONT 1 ROW-HEIGHT-CHARS .67 FIT-LAST-COLUMN.

DEFINE BROWSE br-rf-tela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-rf-tela wWindow _FREEFORM
  QUERY br-rf-tela DISPLAY
      num-seq      
IT-CODIGO
cod-refer             
lote  WIDTH 12
dt-validade-lote
qtd-item   
qtd-item-embalagem
cod-embalagem
qtd-peso-item
qtd-etiqueta     
layout-etiqueta   
cod-ean           
cod-dun   
desc-tipo-etiqueta
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 86 BY 8.25
         FONT 1 ROW-HEIGHT-CHARS .67 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89.72 BY 18.63
         FONT 1.

DEFINE FRAME fPage3
     dc-numero AT ROW 1.5 COL 12 COLON-ALIGNED
     dc-id-docto AT ROW 1.5 COL 42 COLON-ALIGNED
     dc-estab AT ROW 2.5 COL 12 COLON-ALIGNED
     dc-local AT ROW 2.5 COL 42 COLON-ALIGNED
     dc-lote AT ROW 3.5 COL 12 COLON-ALIGNED
     dc-referencia AT ROW 3.5 COL 42 COLON-ALIGNED
     dc-dt-validade-lote AT ROW 3.5 COL 62 COLON-ALIGNED
     bt-dc-executar AT ROW 3.33 COL 80
     br-dc-tela AT ROW 6 COL 2
     bt-incluir-dc AT ROW 14.71 COL 2.72
     bt-modificar-dc AT ROW 14.71 COL 13.57
     bt-eliminar-dc AT ROW 14.71 COL 24.43
     dc-total-qtd-item AT ROW 14.71 COL 55.86 COLON-ALIGNED
     dc-cod-embalagem AT ROW 14.71 COL 75.57 COLON-ALIGNED
     bt-imprimir-dc AT ROW 16.17 COL 2.72
     bt-imprimir-todos-dc AT ROW 16.17 COL 13.72
     btHelp-dc AT ROW 16.17 COL 77
     RECT-8 AT ROW 1.21 COL 2
     rtToolBar-dc AT ROW 15.96 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3
         SIZE 88 BY 16.5
         FONT 1.

DEFINE FRAME fPage1
     op-ordem AT ROW 1.5 COL 13 COLON-ALIGNED
     op-local AT ROW 1.5 COL 43 COLON-ALIGNED
     op-lote AT ROW 3.5 COL 13 COLON-ALIGNED
     op-referencia AT ROW 3.5 COL 43 COLON-ALIGNED
     op-dt-validade-lote AT ROW 3.5 COL 62.43 COLON-ALIGNED
     op-dep-saida AT ROW 4.5 COL 13 COLON-ALIGNED
     op-loc-saida AT ROW 4.5 COL 43 COLON-ALIGNED
     op-quantidade AT ROW 4.5 COL 62.43 COLON-ALIGNED
     bt-op-executar AT ROW 4.33 COL 80
     br-op-tela AT ROW 6 COL 2
     bt-incluir-op AT ROW 14.71 COL 2.72
     bt-modificar-op AT ROW 14.71 COL 13.57
     bt-eliminar-op AT ROW 14.71 COL 24.43
     op-total-qtd-item AT ROW 14.71 COL 55.86 COLON-ALIGNED
     op-cod-embalagem AT ROW 14.71 COL 75.57 COLON-ALIGNED
     bt-imprimir-op AT ROW 16.17 COL 2.72
     bt-imprimir-todos-op AT ROW 16.17 COL 13.72
     btHelp-op AT ROW 16.17 COL 77
     op-item AT ROW 2.5 COL 13 COLON-ALIGNED
     op-desc-item AT ROW 2.5 COL 32.43 COLON-ALIGNED NO-LABEL
     RECT-6 AT ROW 1.21 COL 2
     rtToolBar-op AT ROW 15.96 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3
         SIZE 88 BY 16.5
         FONT 1.

DEFINE FRAME fPage2
     it-item AT ROW 1.5 COL 10 COLON-ALIGNED
     it-desc-item AT ROW 1.5 COL 30 COLON-ALIGNED NO-LABEL
     it-estab AT ROW 2.5 COL 10 COLON-ALIGNED
     it-local AT ROW 2.5 COL 40 COLON-ALIGNED
     it-lote AT ROW 3.5 COL 10 COLON-ALIGNED
     it-referencia AT ROW 3.5 COL 40 COLON-ALIGNED
     it-dt-validade-lote AT ROW 3.5 COL 60 COLON-ALIGNED
     it-dep-saida AT ROW 4.5 COL 10 COLON-ALIGNED
     it-loc-saida AT ROW 4.5 COL 40 COLON-ALIGNED
     it-quantidade AT ROW 4.5 COL 60 COLON-ALIGNED
     bt-it-executar AT ROW 4.33 COL 80
     br-it-tela AT ROW 6 COL 2
     bt-incluir-it AT ROW 14.71 COL 2.72
     bt-modificar-it AT ROW 14.71 COL 13.57
     bt-eliminar-it AT ROW 14.71 COL 24.43
     it-total-qtd-item AT ROW 14.71 COL 55.86 COLON-ALIGNED
     it-cod-embalagem AT ROW 14.71 COL 75.57 COLON-ALIGNED
     bt-imprimir-it AT ROW 16.17 COL 2.72
     bt-imprimir-todos-it AT ROW 16.17 COL 13.72
     btHelp-it AT ROW 16.17 COL 77
     RECT-7 AT ROW 1.21 COL 2
     rtToolBar-it AT ROW 15.96 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3
         SIZE 88 BY 16.5
         FONT 1.

DEFINE FRAME fPage4
     rf-numero AT ROW 1.5 COL 14 COLON-ALIGNED
     rf-serie AT ROW 1.5 COL 40 COLON-ALIGNED
     cb-rf-tp-nota AT ROW 1.5 COL 58 COLON-ALIGNED
     rf-emitente AT ROW 2.5 COL 14 COLON-ALIGNED
     rf-desc-emitente AT ROW 2.5 COL 28.57 COLON-ALIGNED NO-LABEL
     rf-estab AT ROW 3.5 COL 14 COLON-ALIGNED
     rf-local AT ROW 3.5 COL 40 COLON-ALIGNED
     bt-rf-executar AT ROW 3.5 COL 75.29
     br-rf-tela AT ROW 6 COL 2
     bt-incluir-rf AT ROW 14.71 COL 2.72
     bt-modificar-rf AT ROW 14.71 COL 13.57
     bt-eliminar-rf AT ROW 14.71 COL 24.43
     rf-total-qtd-item AT ROW 14.71 COL 55.86 COLON-ALIGNED
     rf-cod-embalagem AT ROW 14.71 COL 75.57 COLON-ALIGNED
     bt-imprimir-rf AT ROW 16.17 COL 2.72
     bt-imprimir-todos-rf AT ROW 16.17 COL 13.72
     btHelp-rf AT ROW 16.17 COL 77
     RECT-9 AT ROW 1.21 COL 2
     rtToolBar-rf AT ROW 15.96 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3
         SIZE 88 BY 16.5
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 18.63
         WIDTH              = 89.72
         MAX-HEIGHT         = 32.54
         MAX-WIDTH          = 205.72
         VIRTUAL-HEIGHT     = 32.54
         VIRTUAL-WIDTH      = 205.72
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fPage3:MOVE-AFTER-TAB-ITEM (btHelp:HANDLE IN FRAME fpage0)
       XXTABVALXX = FRAME fPage2:MOVE-BEFORE-TAB-ITEM (FRAME fPage1:HANDLE)
       XXTABVALXX = FRAME fPage4:MOVE-BEFORE-TAB-ITEM (FRAME fPage2:HANDLE)
       XXTABVALXX = FRAME fPage3:MOVE-BEFORE-TAB-ITEM (FRAME fPage4:HANDLE)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* BROWSE-TAB br-op-tela bt-op-executar fPage1 */
/* SETTINGS FOR FRAME fPage2
   Custom                                                               */
/* BROWSE-TAB br-it-tela bt-it-executar fPage2 */
/* SETTINGS FOR FRAME fPage3
   Custom                                                               */
/* BROWSE-TAB br-dc-tela bt-dc-executar fPage3 */
/* SETTINGS FOR FRAME fPage4
   Custom                                                               */
/* BROWSE-TAB br-rf-tela bt-rf-executar fPage4 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-dc-tela
/* Query rebuild information for BROWSE br-dc-tela
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-browse-tela.
    APPLY "VALUE-CHANGE" TO br-dc-tela.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-dc-tela */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-it-tela
/* Query rebuild information for BROWSE br-it-tela
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-browse-tela.
    APPLY "VALUE-CHANGE" TO br-it-tela.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-it-tela */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-op-tela
/* Query rebuild information for BROWSE br-op-tela
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-browse-tela.
    APPLY "VALUE-CHANGE" TO br-op-tela.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-op-tela */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-rf-tela
/* Query rebuild information for BROWSE br-rf-tela
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-browse-tela.
    APPLY "VALUE-CHANGE" TO br-rf-tela.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-rf-tela */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fPage1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fPage1 wWindow
ON ENTRY OF FRAME fPage1
DO:
  ASSIGN op-quantidade:SENSITIVE IN FRAME fPage1 = NO
         op-item:SENSITIVE IN FRAME fPage1 = NO
         op-desc-item:SENSITIVE IN FRAME fPage1 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fPage2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fPage2 wWindow
ON ENTRY OF FRAME fPage2
DO:
    ASSIGN it-desc-item:SENSITIVE IN FRAME fPage2 = NO. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fPage4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fPage4 wWindow
ON ENTRY OF FRAME fPage4
DO:
    ASSIGN c-lista   = ""
           c-lista   = {ininc/i01in089.i 04  1} /* Compra        */ + "," + {ininc/i01in089.i 04  2} /* Devolucao        */ + "," +
                       {ininc/i01in089.i 04  3} /* Transferencia */ + "," + {ininc/i01in089.i 04  4} /* Entrada Benef    */ + "," +
                       {ininc/i01in089.i 04  5} /* Retorno Benef */ + "," + {ininc/i01in089.i 04  6} /* Entrada Consig   */ + "," +
                       {ininc/i01in089.i 04  7} /* Fatura Consig */ + "," + {ininc/i01in089.i 04  8} /* Devolucao consig */ + "," +
                       {ininc/i01in089.i 04  9} /* Nota de Rateio */ 
           c-inicial = {ininc/i01in089.i 04  1} /* Compra */.

    &IF "{&fnc_multi_idioma}":U = "yes":U &THEN
        RUN utp/ut-lstit.p (INPUT-OUTPUT c-lista).
        ASSIGN cb-rf-tp-nota:LIST-ITEM-PAIRS IN FRAME fPage4 = c-lista.
    &ELSE
        ASSIGN cb-rf-tp-nota:LIST-ITEMS IN FRAME fPage4 = c-lista.
    &ENDIF

    ASSIGN cb-rf-tp-nota:SCREEN-VALUE IN FRAME fPage4 = c-inicial
           rf-desc-emitente:SENSITIVE IN FRAME fPage4 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-dc-tela
&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME br-dc-tela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-dc-tela wWindow
ON VALUE-CHANGED OF br-dc-tela IN FRAME fPage3
DO:
    ASSIGN dc-total-qtd-item = 0
           dc-cod-embalagem  = "".

    FOR EACH bftt-browse-tela NO-LOCK
        WHERE bftt-browse-tela.num-seq = tt-browse-tela.num-seq AND
              bftt-browse-tela.cod-embalagem = tt-browse-tela.cod-embalagem.
            ASSIGN dc-total-qtd-item = dc-total-qtd-item + bftt-browse-tela.qtd-item * bftt-browse-tela.qtd-etiqueta
                   dc-cod-embalagem  = tt-browse-tela.cod-embalagem.
    END.
    ASSIGN dc-total-qtd-item:SCREEN-VALUE IN FRAME fPage3 = STRING(dc-total-qtd-item)
           dc-cod-embalagem:SCREEN-VALUE IN FRAME fPage3  = dc-cod-embalagem.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-it-tela
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME br-it-tela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-it-tela wWindow
ON VALUE-CHANGED OF br-it-tela IN FRAME fPage2
DO:
    ASSIGN it-total-qtd-item = 0
           it-cod-embalagem  = "".

    FOR EACH bftt-browse-tela NO-LOCK
        WHERE bftt-browse-tela.num-seq = tt-browse-tela.num-seq AND
              bftt-browse-tela.cod-embalagem = tt-browse-tela.cod-embalagem.
            ASSIGN it-total-qtd-item = it-total-qtd-item + bftt-browse-tela.qtd-item * bftt-browse-tela.qtd-etiqueta
                   it-cod-embalagem  = tt-browse-tela.cod-embalagem.
    END.
    ASSIGN it-total-qtd-item:SCREEN-VALUE IN FRAME fPage2 = STRING(it-total-qtd-item)
           it-cod-embalagem:SCREEN-VALUE IN FRAME fPage2  = it-cod-embalagem.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-op-tela
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-op-tela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-op-tela wWindow
ON VALUE-CHANGED OF br-op-tela IN FRAME fPage1
DO:
    ASSIGN op-total-qtd-item = 0
           op-cod-embalagem  = "".
    
    FOR EACH bftt-browse-tela NO-LOCK
        WHERE bftt-browse-tela.num-seq = tt-browse-tela.num-seq AND
              bftt-browse-tela.cod-embalagem = tt-browse-tela.cod-embalagem.
            ASSIGN op-total-qtd-item = op-total-qtd-item + bftt-browse-tela.qtd-item * bftt-browse-tela.qtd-etiqueta
                   op-cod-embalagem  = tt-browse-tela.cod-embalagem.
    END.
    ASSIGN op-total-qtd-item:SCREEN-VALUE IN FRAME fPage1 = STRING(op-total-qtd-item)
           op-cod-embalagem:SCREEN-VALUE IN FRAME fPage1  = op-cod-embalagem.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-rf-tela
&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME br-rf-tela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-rf-tela wWindow
ON VALUE-CHANGED OF br-rf-tela IN FRAME fPage4
DO:
    ASSIGN rf-total-qtd-item = 0
           rf-cod-embalagem  = "".

    FOR EACH bftt-browse-tela NO-LOCK
        WHERE bftt-browse-tela.num-seq = tt-browse-tela.num-seq AND
              bftt-browse-tela.cod-embalagem = tt-browse-tela.cod-embalagem.
            ASSIGN rf-total-qtd-item = rf-total-qtd-item + bftt-browse-tela.qtd-item * bftt-browse-tela.qtd-etiqueta
                   rf-cod-embalagem  = tt-browse-tela.cod-embalagem.
    END.
    ASSIGN rf-total-qtd-item:SCREEN-VALUE IN FRAME fPage4 = STRING(rf-total-qtd-item)
           rf-cod-embalagem:SCREEN-VALUE IN FRAME fPage4  = rf-cod-embalagem.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME bt-dc-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-dc-executar wWindow
ON CHOOSE OF bt-dc-executar IN FRAME fPage3
DO:
    /* Tela de acompanhamento */
    DEFINE VARIABLE h-acomp AS HANDLE NO-UNDO.
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp. 
    {utp/ut-liter.i Processando... *}
    RUN pi-inicializar IN h-acomp ( Return-value ). 
    {utp/ut-liter.i Buscando_informaá‰es_das_etiquetas... *}
    RUN pi-acompanhar IN h-acomp ( Return-value ). 
    RUN pi-finalizar IN h-acomp.                   
    IF VALID-HANDLE (h-acomp) THEN DELETE OBJECT h-acomp.

    ASSIGN dc-numero
           dc-id-docto
           dc-estab
           dc-local
           dc-lote
           dc-referencia
           dc-dt-validade-lote.

    FOR EACH tt-erro:
        DELETE tt-erro.
    END.

    FOR EACH rowerrors:
        DELETE rowerrors.
    END.

    EMPTY TEMP-TABLE tt-browse-tela.
    {&OPEN-QUERY-br-dc-tela}

    RUN PI-VALIDA-CAMPOS-DOCTO IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK" THEN UNDO, LEAVE.

    RUN initializeDBOs.

    /* Busca data de validade */
    RUN pi-buscadatavalidade(INPUT dc-estab:SCREEN-VALUE,           
                             INPUT dc-local:SCREEN-VALUE, 
                             INPUT c-item-aux,            
                             INPUT dc-lote:SCREEN-VALUE,            
                             INPUT dc-referencia:SCREEN-VALUE,      
                             INPUT c-loc-saida-aux,      
                             OUTPUT dc-dt-validade-lote).
    /* Busca as informaá‰es */
    RUN pi-busca-informacao-wms (INPUT dc-estab:SCREEN-VALUE,                
                                 INPUT dc-local:SCREEN-VALUE,                
                                 INPUT dc-numero:SCREEN-VALUE,               
                                 INPUT c-item-aux,                           
                                 INPUT 0,                                    
                                 INPUT dc-id-docto:SCREEN-VALUE,    
                                 INPUT dc-referencia:SCREEN-VALUE,  
                                 INPUT dc-lote:SCREEN-VALUE,        
                                 INPUT 0,                           
                                 INPUT dc-dt-validade-lote:SCREEN-VALUE, 
                                 INPUT 3 /*Documento WMS*/ ).

    {&OPEN-QUERY-br-dc-tela}

    if num-results("br-dc-tela":U) = 0 THEN
        DISABLE bt-modificar-dc
                bt-eliminar-dc
                WITH FRAME fPage3.
    ELSE
       ENABLE bt-modificar-dc
              bt-eliminar-dc
              WITH FRAME fPage3.

    ENABLE bt-incluir-dc WITH FRAME fPage3.

    /* Tela de acompanhamento */ 
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp. 
    {utp/ut-liter.i Processando... *}
    RUN pi-inicializar IN h-acomp ( RETURN-VALUE ). 
    {utp/ut-liter.i TÇrmino_da_busca_de_informaá‰es_das_etiquetas... *}
    RUN pi-acompanhar IN h-acomp ( RETURN-VALUE ). 
    RUN pi-finalizar IN h-acomp. 

    IF VALID-HANDLE (h-acomp) THEN DELETE OBJECT h-acomp.

    RUN BeforeDestroyInterface.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-eliminar-dc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar-dc wWindow
ON CHOOSE OF bt-eliminar-dc IN FRAME fPage3 /* Eliminar */
DO:
    if br-dc-tela:num-selected-rows > 0 then do on error undo, return no-apply:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "sequància_de_documento_WMS" *}
        RUN utp/ut-msgs.p ("SHOW",4350,RETURN-VALUE).
        IF RETURN-VALUE <> "no" THEN DO:
            if avail tt-browse-tela then do:
                get current br-dc-tela.
                delete tt-browse-tela.
                if br-dc-tela:delete-current-row() in frame fPage3 then.
            end.
        END.
    end.
    
    if num-results("br-dc-tela":U) = 0 THEN
        assign bt-modificar-dc:SENSITIVE in frame fPage3 = no
               bt-eliminar-dc:SENSITIVE in frame fPage3  = no.

    APPLY "VALUE-CHANGED" TO br-dc-tela IN FRAME fPage3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-eliminar-it
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar-it wWindow
ON CHOOSE OF bt-eliminar-it IN FRAME fPage2 /* Eliminar */
DO:
    if br-it-tela:num-selected-rows > 0 then do on error undo, return no-apply:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "sequància_de_item" *}
        RUN utp/ut-msgs.p ("SHOW",4350,RETURN-VALUE).
        IF RETURN-VALUE <> "no" THEN DO:    
            if avail tt-browse-tela then do:
                get current br-it-tela.
                delete tt-browse-tela.
                if br-it-tela:delete-current-row() in frame fPage2 then.
            end.
        END. 
    end.
    
    if num-results("br-it-tela":U) = 0 THEN
        assign bt-modificar-it:SENSITIVE in frame fPage2 = no
               bt-eliminar-it:SENSITIVE in frame fPage2  = no.

    APPLY "VALUE-CHANGED" TO br-it-tela IN FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-eliminar-op
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar-op wWindow
ON CHOOSE OF bt-eliminar-op IN FRAME fPage1 /* Eliminar */
DO:   
   if br-op-tela:num-selected-rows > 0 then do on error undo, return no-apply:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "sequància_de_ordem_de_produá∆o" *}
        RUN utp/ut-msgs.p ("SHOW",4350,RETURN-VALUE).
        IF RETURN-VALUE <> "no" THEN DO:
            if avail tt-browse-tela then do:
                get current br-op-tela.
                delete tt-browse-tela.
                if br-op-tela:delete-current-row() in frame fPage1 then.
            end.
        end.
   END.
    
   if num-results("br-op-tela":U) = 0 THEN
    assign bt-modificar-op:SENSITIVE in frame fPage1 = no
           bt-eliminar-op:SENSITIVE in frame fPage1  = no.

   APPLY "VALUE-CHANGED" TO br-op-tela IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME bt-eliminar-rf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar-rf wWindow
ON CHOOSE OF bt-eliminar-rf IN FRAME fPage4 /* Eliminar */
DO:
    if br-rf-tela:num-selected-rows > 0 then do on error undo, return no-apply:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "sequància_de_rec._f°sico" *}
        RUN utp/ut-msgs.p ("SHOW",4350,RETURN-VALUE).
        IF RETURN-VALUE <> "no" THEN DO:
            if avail tt-browse-tela then do:
                get current br-rf-tela.
                delete tt-browse-tela.
                if br-rf-tela:delete-current-row() in frame fPage4 then.
            end.
        END.
    end.
    
    if num-results("br-rf-tela":U) = 0 THEN
        assign bt-modificar-rf:SENSITIVE in frame fPage4 = no
               bt-eliminar-rf:SENSITIVE in frame fPage4  = no.        

    APPLY "VALUE-CHANGED" TO br-rf-tela IN FRAME fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME bt-imprimir-dc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprimir-dc wWindow
ON CHOOSE OF bt-imprimir-dc IN FRAME fPage3 /* Imprimir */
DO:
    

    EMPTY TEMP-TABLE tt-divergencia.
    EMPTY TEMP-TABLE tt-erro.

    IF NUM-RESULTS("br-dc-tela") = 0 OR
       NUM-RESULTS("br-dc-tela") = ?  THEN  DO: 
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "sequància_de_item" *}
        RUN utp/ut-msgs.p ("show",29488, RETURN-VALUE). /*Nenhum &1 foi selecionado.*/
    END.
    ELSE DO:
        RUN initializeDBOs.
        DEFINE BUFFER bf-tt-browse-tela FOR tt-browse-tela.

        FOR EACH bf-tt-browse-tela:
            ASSIGN bf-tt-browse-tela.marca = NO.
        END.

        DO  i-cont = 1 TO br-dc-tela:NUM-SELECTED-ROWS:
            ASSIGN l-selecionada = br-dc-tela:FETCH-SELECTED-ROW(i-cont).
            IF  l-selecionada THEN DO:
                ASSIGN tt-browse-tela.marca = YES.
            END.
        END.
        IF tt-browse-tela.tipo-etiqueta = 0 THEN DO:
            IF l-selecionada THEN DO:
                     RUN pi-gera-etiqueta-docto.
                     RUN BeforeDestroyInterface.
            END.                    
            NEXT.
        END.

        IF CAN-FIND(FIRST bf-tt-browse-tela WHERE
                          bf-tt-browse-tela.tipo-etiqueta <> 1 AND
                          bf-tt-browse-tela.marca = YES) THEN DO:
            DO i-cont = 1 TO br-dc-tela:NUM-SELECTED-ROWS:
                ASSIGN l-selecionada = br-dc-tela:FETCH-SELECTED-ROW(i-cont).
                IF  l-selecionada THEN DO:

                    IF tt-browse-tela.tipo-etiqueta = 1 THEN NEXT.

                    ASSIGN de-qtd-item-total    = 0
                           i-qtd-etiqueta-total = 0
                           de-qtd-item-filha    = 0
                           i-qtd-etiqueta-emb   = 0
                           de-qtd-item-emb      = 0
                           de-qtd-item-row      = 0.
 
                    FOR EACH bf-tt-browse-tela WHERE
                             bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                             bf-tt-browse-tela.cod-embalagem = tt-browse-tela.cod-embalagem AND
                             bf-tt-browse-tela.tipo-etiqueta <> 1 AND
                             bf-tt-browse-tela.marca         = YES NO-LOCK:
                            ASSIGN de-qtd-item-emb    = de-qtd-item-emb + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta)
                                   i-qtd-etiqueta-emb = i-qtd-etiqueta-emb + bf-tt-browse-tela.qtd-etiqueta.
                    END.

                    IF tt-browse-tela.tipo-etiqueta <> 1 AND 
                       tt-browse-tela.tipo-etiqueta <> 0 THEN
                        ASSIGN de-qtd-item-row = tt-browse-tela.qtd-item * tt-browse-tela.qtd-etiqueta.

                    FOR EACH bf-tt-browse-tela WHERE
                             bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                             /*bf-tt-browse-tela.cod-embalagem = tt-browse-tela.cod-embalagem AND*/
                             bf-tt-browse-tela.tipo-etiqueta <> 1 AND
                             bf-tt-browse-tela.marca         = YES NO-LOCK:
                            ASSIGN de-qtd-item-total    = de-qtd-item-total + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta)
                                   i-qtd-etiqueta-total = i-qtd-etiqueta-total + bf-tt-browse-tela.qtd-etiqueta.
                    END.

                    FIND FIRST wm-docto-itens WHERE
                               wm-docto-itens.cod-estabel  = dc-estab:SCREEN-VALUE             AND
                               wm-docto-itens.cod-local    = dc-local:SCREEN-VALUE             AND
                               wm-docto-itens.id-docto     = DECIMAL(dc-id-docto:SCREEN-VALUE) AND
                               wm-docto-itens.num-seq-item = tt-browse-tela.num-seq            AND
                               wm-docto-itens.cod-item     = tt-browse-tela.it-codigo NO-LOCK NO-ERROR.

                     IF de-qtd-item-total = (IF AVAIL wm-docto-itens THEN wm-docto-itens.qtd-item ELSE 0) THEN DO:
                          ASSIGN l-qtd-item = YES.                
                     END.
                     ELSE DO:
                          ASSIGN l-qtd-item = NO.
                          LEAVE.
                     END.

                    IF CAN-FIND(FIRST bf-tt-browse-tela WHERE
                                      bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                                      bf-tt-browse-tela.tipo-etiqueta = 1) THEN DO:

                        FOR EACH bf-tt-browse-tela WHERE
                                 bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                                 bf-tt-browse-tela.tipo-etiqueta = 1 AND
                                 bf-tt-browse-tela.marca         = YES NO-LOCK:
                                ASSIGN de-qtd-item-filha = de-qtd-item-filha + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta).
                        END.

                        IF de-qtd-item-filha = 0 THEN DO: 
                            /*necess†rio selecionar emb filha*/
                            DEFINE VARIABLE c-liter-embalagem-filha AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "embalagem_filha_do_item" *}
                            ASSIGN c-liter-embalagem-filha = RETURN-VALUE.

                            DEFINE VARIABLE c-liter-a-impressao-1 AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "(a)_impress∆o" *}
                            ASSIGN c-liter-a-impressao-1 = RETURN-VALUE.
                            RUN utp/ut-msgs.p ("show",3721, c-liter-embalagem-filha + "~~" + c-liter-a-impressao-1). /*Nenhum(a) &1 foi selecionado(a) - N∆o Ç poss°vel continuar o &2 sem que algum(a) &1 seja selecionado(a)*/

                            RETURN "NOK":U.
                        END.
                        ELSE DO:
                            IF de-qtd-item-filha <> (IF AVAIL wm-docto-itens THEN wm-docto-itens.qtd-item ELSE 0) THEN DO:
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-qtd-itens-embalagem AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "Quantidade_de_itens_da_embalagem_filha" *}
                                ASSIGN c-lbl-liter-qtd-itens-embalagem = TRIM(RETURN-VALUE).
                                DEFINE VARIABLE c-lbl-liter-embalagem-pai AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "embalagem_pai" *}
                                ASSIGN c-lbl-liter-embalagem-pai = TRIM(RETURN-VALUE).
                                /*qtd item emb filha difere do pai*/
                                RUN utp/ut-msgs.p ("show",33090, c-lbl-liter-qtd-itens-embalagem + "~~" + c-lbl-liter-embalagem-pai). /*&1 diferente &2 - &3 diferente &4*/
                                RETURN "NOK":U.
                            END.
                        END.

                    END.

                    ASSIGN i-qtd-movto-etiqueta = 0
                           de-qtd-movto-item    = 0.

                    FOR EACH wm-box-movto WHERE
                             wm-box-movto.cod-estabel    = dc-estab:SCREEN-VALUE             AND
                             wm-box-movto.cod-local      = dc-local:SCREEN-VALUE             AND
                             wm-box-movto.id-docto       = DECIMAL(dc-id-docto:SCREEN-VALUE) AND
                             wm-box-movto.num-seq-item   = tt-browse-tela.num-seq            AND
                             wm-box-movto.cod-item       = tt-browse-tela.it-codigo          AND
                             wm-box-movto.cod-embalagem  = tt-browse-tela.cod-embalagem      AND
                             wm-box-movto.ind-tipo-movto = 1 AND
                             tt-browse-tela.tipo-etiqueta <> 1 NO-LOCK.
                             ASSIGN i-qtd-movto-etiqueta = i-qtd-movto-etiqueta + wm-box-movto.qti-embalagem
                                    de-qtd-movto-item    = de-qtd-movto-item    + (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem).
                    END.

                    IF tt-browse-tela.id-movto = 0 THEN DO:
                        FIND FIRST wm-box-movto WHERE
                                   wm-box-movto.cod-estabel = dc-estab:SCREEN-VALUE             AND
                                   wm-box-movto.cod-local   = dc-local:SCREEN-VALUE             AND
                                   wm-box-movto.id-docto    = DECIMAL(dc-id-docto:SCREEN-VALUE) AND
                                   wm-box-movto.cod-item    = tt-browse-tela.it-codigo          NO-LOCK NO-ERROR.
                        IF AVAIL wm-box-movto THEN DO:
                            IF ((wm-box-movto.cod-embalagem = tt-browse-tela.cod-embalagem AND
                                (i-qtd-movto-etiqueta <> i-qtd-etiqueta-emb OR
                                 de-qtd-item-emb      <> de-qtd-movto-item)) OR
                                (wm-box-movto.cod-embalagem <> tt-browse-tela.cod-embalagem)) AND
                                 tt-browse-tela.tipo-etiqueta <> 1 /*AND
                                 tt-browse-tela.tipo-etiqueta <> 2*/ THEN DO:
                                     CREATE tt-divergencia.
                                     BUFFER-COPY tt-browse-tela TO tt-divergencia.
                            END.
                        END.
                    END.
                    ELSE DO:
                        FIND FIRST wm-box-movto WHERE
                                   wm-box-movto.cod-estabel = dc-estab:SCREEN-VALUE             AND
                                   wm-box-movto.cod-local   = dc-local:SCREEN-VALUE             AND
                                   wm-box-movto.id-docto    = DECIMAL(dc-id-docto:SCREEN-VALUE) AND
                                   wm-box-movto.id-movto    = tt-browse-tela.id-movto           AND
                                   wm-box-movto.cod-item    = tt-browse-tela.it-codigo          NO-LOCK NO-ERROR.
                        IF AVAIL wm-box-movto THEN DO: 
                            IF ((wm-box-movto.cod-embalagem = tt-browse-tela.cod-embalagem AND
                                (i-qtd-movto-etiqueta <> i-qtd-etiqueta-emb OR
                                 de-qtd-item-row      <> wm-box-movto.qtd-item OR
                                 de-qtd-item-emb      <> de-qtd-movto-item)) OR
                                (wm-box-movto.cod-embalagem <> tt-browse-tela.cod-embalagem)) AND
                                 tt-browse-tela.tipo-etiqueta <> 1 /*AND
                                 tt-browse-tela.tipo-etiqueta <> 2*/ THEN DO:
                                     CREATE tt-divergencia.
                                     BUFFER-COPY tt-browse-tela TO tt-divergencia.
                            END.
                        END.
                    END.
                END.
            END.

            IF l-qtd-item THEN DO:
                IF CAN-FIND(FIRST tt-divergencia NO-LOCK) THEN DO:
/*                     {utp/ut-liter.i "fazer nova sugest∆o de alocaá∆o de itens"}
                    run utp/ut-msgs.p(input "show":U,
                                      input 26715,
                                      input RETURN-VALUE).

                    IF RETURN-VALUE = "YES" THEN DO: */
                        RUN pi-gera-etiqueta-docto.
                        run pi-desfaz-sugestao (INPUT dc-estab:SCREEN-VALUE,
                                                INPUT dc-local:SCREEN-VALUE,
                                                INPUT DECIMAL(dc-id-docto:SCREEN-VALUE)).
                        run pi-realizar-sugestao (INPUT dc-estab:SCREEN-VALUE,
                                                  INPUT dc-local:SCREEN-VALUE,
                                                  INPUT DECIMAL(dc-id-docto:SCREEN-VALUE)).
/*                     END. 
                    ELSE DO:
                        RUN pi-gera-etiqueta-docto.
                    END.*/
                END.
                ELSE DO:
                    RUN pi-gera-etiqueta-docto.
                END.
                RUN BeforeDestroyInterface.
            END.
            ELSE DO:
                DEFINE VARIABLE c-lbl-liter-qtd-itens AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Quantidade_de_itens" *}
                ASSIGN c-lbl-liter-qtd-itens = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-da-sugestao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "da_sugest∆o_de_alocaá∆o" *}
                ASSIGN c-lbl-liter-da-sugestao = TRIM(RETURN-VALUE).
                RUN utp/ut-msgs.p ("show",33090, c-lbl-liter-qtd-itens + "~~" + c-lbl-liter-da-sugestao). /*&1 diferente &2*/
            END.
        END.
        ELSE DO:
            DEFINE VARIABLE c-liter-sequencia-de-item AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "sequància_de_item_da_embalagem_pai" *}
            ASSIGN c-liter-sequencia-de-item = RETURN-VALUE.

            DEFINE VARIABLE c-liter-a-impressao-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "(a)_impress∆o" *}
            ASSIGN c-liter-a-impressao-2 = RETURN-VALUE.
            RUN utp/ut-msgs.p ("show",3721, c-liter-sequencia-de-item + "~~" + c-liter-a-impressao-2). /*Nenhum(a) &1 foi selecionado(a) - N∆o Ç poss°vel continuar o &2 sem que algum(a) &1 seja selecionado(a)*/
        END.
    END.

    if num-results("br-dc-tela":U) = 0 THEN
        assign bt-incluir-dc:SENSITIVE in frame fPage3   = no
               bt-modificar-dc:SENSITIVE in frame fPage3 = no
               bt-eliminar-dc:SENSITIVE in frame fPage3  = no.

    APPLY "VALUE-CHANGED" TO br-dc-tela IN FRAME fPage3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-imprimir-it
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprimir-it wWindow
ON CHOOSE OF bt-imprimir-it IN FRAME fPage2 /* Imprimir */
DO:
    
    EMPTY TEMP-TABLE tt-erro.


    IF NUM-RESULTS("br-it-tela") = 0 OR 
       NUM-RESULTS("br-it-tela") = ? THEN  DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "sequància_de_item" *}
        RUN utp/ut-msgs.p ("show",29488, RETURN-VALUE). /*Nenhum &1 foi selecionado.*/
    END.
    ELSE DO:
        RUN initializeDBOs.

        DEFINE BUFFER bf-tt-browse-tela FOR tt-browse-tela.

        FOR EACH bf-tt-browse-tela:
            ASSIGN bf-tt-browse-tela.marca = NO.
        END.

        ASSIGN l-selecionada = NO.
        /*DO i-cont = 1 TO NUM-RESULTS("br-it-tela"):
            ASSIGN i-pos = i-cont.
            IF br-it-tela:IS-ROW-SELECTED(i-cont) = YES THEN DO:
                ASSIGN l-selecionada = YES.
                IF tt-browse-tela.tipo-etiqueta = 1 THEN DO:
                    br-it-tela:SELECT-ROW(i-pos - 1) NO-ERROR.
                    NEXT.
                END.
                IF tt-browse-tela.tipo-etiqueta = 2 THEN DO:
                    br-it-tela:SELECT-ROW(i-pos + 1) NO-ERROR.
                    NEXT.
                END.
            END.
        END.*/

        DO  i-cont = 1 TO br-it-tela:NUM-SELECTED-ROWS:
            ASSIGN l-selecionada = br-it-tela:FETCH-SELECTED-ROW(i-cont).
            IF  l-selecionada THEN DO:
                ASSIGN tt-browse-tela.marca = YES.
            END.
        END.

        IF tt-browse-tela.tipo-etiqueta = 0 THEN DO:
            IF l-selecionada THEN DO:
                     RUN pi-gera-etiqueta-it.
                     RUN BeforeDestroyInterface.
            END.                    
            NEXT.
        END.

        IF CAN-FIND(FIRST bf-tt-browse-tela WHERE
                          bf-tt-browse-tela.tipo-etiqueta <> 1 AND
                          bf-tt-browse-tela.marca = YES) THEN DO:
            DO i-cont = 1 TO br-it-tela:NUM-SELECTED-ROWS:
                ASSIGN l-selecionada = br-it-tela:FETCH-SELECTED-ROW(i-cont).
                IF  l-selecionada THEN DO:

                    IF tt-browse-tela.tipo-etiqueta = 1 THEN NEXT.

                    ASSIGN de-qtd-item-total    = 0
                           de-qtd-item-filha    = 0.
 
                    FOR EACH bf-tt-browse-tela WHERE
                             bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                             /*bf-tt-browse-tela.cod-embalagem = tt-browse-tela.cod-embalagem AND*/
                             bf-tt-browse-tela.tipo-etiqueta <> 1 AND
                             bf-tt-browse-tela.marca         = YES NO-LOCK:
                            ASSIGN de-qtd-item-total    = de-qtd-item-total + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta).
                    END.

                    IF CAN-FIND(FIRST bf-tt-browse-tela WHERE
                                      bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                                      bf-tt-browse-tela.tipo-etiqueta = 1) THEN DO:

                        FOR EACH bf-tt-browse-tela WHERE
                                 bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                                 bf-tt-browse-tela.tipo-etiqueta = 1 AND
                                 bf-tt-browse-tela.marca         = YES NO-LOCK:
                                ASSIGN de-qtd-item-filha = de-qtd-item-filha + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta).
                        END.

                        IF de-qtd-item-filha = 0 THEN DO:
                            /*necess†rio selecionar emb filha*/
                            DEFINE VARIABLE c-liter-embalagem-filha-2 AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "embalagem_filha_do_item" *}
                            ASSIGN c-liter-embalagem-filha-2 = RETURN-VALUE.

                            DEFINE VARIABLE c-liter-a-impressao-2 AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "(a)_impress∆o" *}
                            ASSIGN c-liter-a-impressao-2 = RETURN-VALUE.
                            RUN utp/ut-msgs.p ("show",3721, c-liter-embalagem-filha-2 + "~~" + c-liter-a-impressao-2). /*Nenhum(a) &1 foi selecionado(a) - N∆o Ç poss°vel continuar o &2 sem que algum(a) &1 seja selecionado(a)*/


                            RETURN "NOK":U.
                        END.
                        ELSE DO:
                            IF de-qtd-item-filha <> de-qtd-item-total THEN DO:
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-qtd-itens-embalagem AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "Quantidade_de_itens_da_embalagem_filha" *}
                                ASSIGN c-lbl-liter-qtd-itens-embalagem = TRIM(RETURN-VALUE).
                                DEFINE VARIABLE c-lbl-liter-embalagem-pai AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "embalagem_pai" *}
                                ASSIGN c-lbl-liter-embalagem-pai = TRIM(RETURN-VALUE).
                                /*qtd item emb filha difere do pai*/
                                RUN utp/ut-msgs.p ("show",33090, c-lbl-liter-qtd-itens-embalagem + "~~" + c-lbl-liter-embalagem-pai). /*&1 diferente &2 - &3 diferente &4*/
                                RETURN "NOK":U.
                            END.
                        END.
                    END.
                END.
            END.
            RUN pi-gera-etiqueta-it.
            RUN BeforeDestroyInterface.
        END.
        ELSE DO:
            DEFINE VARIABLE c-liter-sequencia-de-item AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "sequància_de_item_da_embalagem_pai" *}
            ASSIGN c-liter-sequencia-de-item = RETURN-VALUE.

            DEFINE VARIABLE c-liter-a-impressao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "(a)_impress∆o" *}
            ASSIGN c-liter-a-impressao = RETURN-VALUE.
            RUN utp/ut-msgs.p ("show",3721, c-liter-sequencia-de-item + "~~" + c-liter-a-impressao). /*Nenhum(a) &1 foi selecionado(a) - N∆o Ç poss°vel continuar o &2 sem que algum(a) &1 seja selecionado(a)*/
        END.
    END.

    if num-results("br-it-tela":U) = 0 THEN
        assign bt-incluir-it:SENSITIVE in frame fPage2   = no
               bt-modificar-it:SENSITIVE in frame fPage2 = no
               bt-eliminar-it:SENSITIVE in frame fPage2  = no.

    APPLY "VALUE-CHANGED" TO br-it-tela IN FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-imprimir-op
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprimir-op wWindow
ON CHOOSE OF bt-imprimir-op IN FRAME fPage1 /* Imprimir */
DO:

    EMPTY TEMP-TABLE tt-divergencia.
    EMPTY TEMP-TABLE tt-erro.

    IF NUM-RESULTS("br-op-tela") = 0 OR 
       NUM-RESULTS("br-op-tela") = ? THEN  DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "sequància_de_item" *}
        RUN utp/ut-msgs.p ("show",29488, RETURN-VALUE). /*Nenhum &1 foi selecionado.*/
    END.
    ELSE DO:
        DEFINE BUFFER bf-tt-browse-tela FOR tt-browse-tela. 
        RUN initializeDBOs.
        ASSIGN l-selecionada = NO.

        FOR EACH bf-tt-browse-tela:
            ASSIGN bf-tt-browse-tela.marca = NO.
        END.

        DO  i-cont = 1 TO br-op-tela:NUM-SELECTED-ROWS:
            ASSIGN l-selecionada = br-op-tela:FETCH-SELECTED-ROW(i-cont).
            IF  l-selecionada THEN DO:
                ASSIGN tt-browse-tela.marca = YES.
            END.
        END.

        IF tt-browse-tela.tipo-etiqueta = 0 THEN DO:
            IF l-selecionada THEN DO:
                RUN pi-gera-etiqueta-op.
                RUN BeforeDestroyInterface.
            END.                    
            NEXT.
        END.

         IF CAN-FIND(FIRST bf-tt-browse-tela WHERE
                           bf-tt-browse-tela.tipo-etiqueta <> 1 AND
                           bf-tt-browse-tela.marca = YES) THEN DO:
            DO i-cont = 1 TO br-op-tela:NUM-SELECTED-ROWS:
                ASSIGN l-selecionada = br-op-tela:FETCH-SELECTED-ROW(i-cont).
                IF  l-selecionada THEN DO:

                    IF tt-browse-tela.tipo-etiqueta = 1 THEN NEXT.

                    ASSIGN de-qtd-item-total    = 0
                           i-qtd-etiqueta-total = 0
                           de-qtd-item-filha    = 0
                           i-qtd-etiqueta-emb   = 0
                           de-qtd-item-emb      = 0.
 
                    FOR EACH bf-tt-browse-tela WHERE
                             bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                             bf-tt-browse-tela.cod-embalagem = tt-browse-tela.cod-embalagem AND
                             bf-tt-browse-tela.tipo-etiqueta <> 1 AND
                             bf-tt-browse-tela.marca         = YES NO-LOCK:
                            ASSIGN de-qtd-item-emb    = de-qtd-item-emb + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta)
                                   i-qtd-etiqueta-emb = i-qtd-etiqueta-emb + bf-tt-browse-tela.qtd-etiqueta.
                    END.
 
                    FOR EACH bf-tt-browse-tela WHERE
                             bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                             /*bf-tt-browse-tela.cod-embalagem = tt-browse-tela.cod-embalagem AND*/
                             bf-tt-browse-tela.tipo-etiqueta <> 1 AND
                             bf-tt-browse-tela.marca         = YES NO-LOCK:
                        ASSIGN de-qtd-item-total = de-qtd-item-total + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta)
                               i-qtd-etiqueta-total = i-qtd-etiqueta-total + bf-tt-browse-tela.qtd-etiqueta.
                    END.

                    IF de-qtd-item-total = DECIMAL(op-quantidade:SCREEN-VALUE IN FRAME fPage1) THEN DO:
                        ASSIGN l-qtd-item = YES.
                    END.
                    ELSE DO:
                        ASSIGN l-qtd-item = NO.
                        LEAVE.
                    END.

                    IF CAN-FIND(FIRST bf-tt-browse-tela WHERE
                                      bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                                      bf-tt-browse-tela.tipo-etiqueta = 1) THEN DO:

                        FOR EACH bf-tt-browse-tela WHERE
                                 bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                                 bf-tt-browse-tela.tipo-etiqueta = 1 AND
                                 bf-tt-browse-tela.marca         = YES NO-LOCK:
                                ASSIGN de-qtd-item-filha = de-qtd-item-filha + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta).
                        END.

                        IF de-qtd-item-filha = 0 THEN DO:
                            /*necess†rio selecionar emb filha*/
                            DEFINE VARIABLE c-liter-embalagem-filha-3 AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "embalagem_filha_do_item" *}
                            ASSIGN c-liter-embalagem-filha-3 = RETURN-VALUE.

                            DEFINE VARIABLE c-liter-a-impressao-4 AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "(a)_impress∆o" *}
                            ASSIGN c-liter-a-impressao-4 = RETURN-VALUE.
                            RUN utp/ut-msgs.p ("show",3721, c-liter-embalagem-filha-3 + "~~" + c-liter-a-impressao-4). /*Nenhum(a) &1 foi selecionado(a) - N∆o Ç poss°vel continuar o &2 sem que algum(a) &1 seja selecionado(a)*/
                            RETURN "NOK":U.
                        END.
                    END.

                    ASSIGN i-qtd-movto-etiqueta = 0
                           de-qtd-movto-item    = 0.

                    FOR EACH wm-box-movto WHERE
                             wm-box-movto.cod-estabel    = tt-browse-tela.cod-estabel        AND
                             wm-box-movto.cod-local      = op-local:SCREEN-VALUE             AND
                             wm-box-movto.id-docto       = 0                                 AND
                             wm-box-movto.num-seq-item   = tt-browse-tela.num-seq            AND
                             wm-box-movto.cod-item       = tt-browse-tela.it-codigo          AND
                             wm-box-movto.cod-embalagem  = tt-browse-tela.cod-embalagem      AND
                             wm-box-movto.ind-tipo-movto = 1 AND
                             tt-browse-tela.tipo-etiqueta <> 1 NO-LOCK.
                             ASSIGN i-qtd-movto-etiqueta = i-qtd-movto-etiqueta + wm-box-movto.qti-embalagem
                                    de-qtd-movto-item    = de-qtd-movto-item    + (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem).
                    END.

                    FIND FIRST wm-box-movto WHERE
                               wm-box-movto.cod-estabel = tt-browse-tela.cod-estabel        AND
                               wm-box-movto.cod-local   = op-local:SCREEN-VALUE             AND
                               wm-box-movto.id-docto    = 0                                 AND
                               wm-box-movto.cod-item    = tt-browse-tela.it-codigo          NO-LOCK NO-ERROR.

                    IF AVAIL wm-box-movto THEN DO:
                        IF ((wm-box-movto.cod-embalagem = tt-browse-tela.cod-embalagem AND
                            (i-qtd-movto-etiqueta <> i-qtd-etiqueta-emb OR
                             de-qtd-item-emb <> de-qtd-movto-item)) OR
                            (wm-box-movto.cod-embalagem <> tt-browse-tela.cod-embalagem)) AND
                             tt-browse-tela.tipo-etiqueta <> 1 AND 
                             tt-browse-tela.tipo-etiqueta <> 2 THEN DO:
                                 CREATE tt-divergencia.
                                 BUFFER-COPY tt-browse-tela TO tt-divergencia.
                        END.
                    END.
                END.
            END.
            RUN pi-gera-etiqueta-op. 
/*             IF l-qtd-item THEN DO:                                                                                            */
/*                 IF CAN-FIND(FIRST tt-divergencia NO-LOCK) THEN DO:                                                            */
/*                     {utp/ut-liter.i "fazer nova sugest∆o de alocaá∆o de itens"}                                               */
/*                      run utp/ut-msgs.p(input "show":U,                                                                        */
/*                                        input 26715,                                                                           */
/*                                        input RETURN-VALUE).                                                                   */
/*                                                                                                                               */
/*                      IF RETURN-VALUE = "YES" THEN DO:                                                                         */
/*                         RUN pi-gera-etiqueta-op.                                                                              */
/*                         run pi-desfaz-sugestao (INPUT tt-browse-tela.cod-estabel,                                             */
/*                                                 INPUT op-local:SCREEN-VALUE,                                                  */
/*                                                 INPUT 0).                                                                     */
/*                         run pi-realizar-sugestao (INPUT tt-browse-tela.cod-estabel,                                           */
/*                                                   INPUT op-local:SCREEN-VALUE,                                                */
/*                                                   INPUT 0).                                                                   */
/*                      END.                                                                                                     */
/*                      ELSE DO:                                                                                                 */
/*                         RUN pi-gera-etiqueta-op.                                                                              */
/*                      END.                                                                                                     */
/*                 END.                                                                                                          */
/*                 ELSE DO:                                                                                                      */
/*                     RUN pi-gera-etiqueta-op.                                                                                  */
/*                 END.                                                                                                          */
/*                 RUN BeforeDestroyInterface.                                                                                   */
/*             END.                                                                                                              */
/*             ELSE DO:                                                                                                          */
/*                 DEFINE VARIABLE c-lbl-liter-qtd-itens AS CHARACTER NO-UNDO.                                                   */
/*                 {utp/ut-liter.i "Quantidade_de_itens" *}                                                                      */
/*                 ASSIGN c-lbl-liter-qtd-itens = TRIM(RETURN-VALUE).                                                            */
/*                 DEFINE VARIABLE c-lbl-liter-da-sugestao AS CHARACTER NO-UNDO.                                                 */
/*                 {utp/ut-liter.i "da_sugest∆o_de_alocaá∆o" *}                                                                  */
/*                 ASSIGN c-lbl-liter-da-sugestao = TRIM(RETURN-VALUE).                                                          */
/*                 RUN utp/ut-msgs.p ("show",33090, c-lbl-liter-qtd-itens + "~~" + c-lbl-liter-da-sugestao).                     */
/*             END.                                                                                                              */
        END.
        ELSE DO:
           DEFINE VARIABLE c-liter-sequencia-de-item AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "sequància_de_item_da_embalagem_pai" *}
           ASSIGN c-liter-sequencia-de-item = RETURN-VALUE.

           DEFINE VARIABLE c-liter-a-impressao-2 AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "(a)_impress∆o" *}
           ASSIGN c-liter-a-impressao-2 = RETURN-VALUE.
           RUN utp/ut-msgs.p ("show",3721, c-liter-sequencia-de-item + "~~" + c-liter-a-impressao-2). /*Nenhum(a) &1 foi selecionado(a) - N∆o Ç poss°vel continuar o &2 sem que algum(a) &1 seja selecionado(a)*/
        END.
    END.

    if num-results("br-op-tela":U) = 0 THEN
        assign bt-incluir-op:SENSITIVE in frame fPage1   = no
               bt-modificar-op:SENSITIVE in frame fPage1 = no
               bt-eliminar-op:SENSITIVE in frame fPage1  = no.

    APPLY "VALUE-CHANGED" TO br-op-tela IN FRAME fPage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME bt-imprimir-rf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprimir-rf wWindow
ON CHOOSE OF bt-imprimir-rf IN FRAME fPage4 /* Imprimir */
DO:

    EMPTY TEMP-TABLE tt-divergencia.
    EMPTY TEMP-TABLE tt-erro.

    IF NUM-RESULTS("br-rf-tela") = 0 OR
       NUM-RESULTS("br-rf-tela") = ? THEN  DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "sequància_de_item" *}
        RUN utp/ut-msgs.p ("show",29488, RETURN-VALUE). /*Nenhum &1 foi selecionado.*/
    END.
    ELSE DO:
        DEFINE BUFFER bf-tt-browse-tela FOR tt-browse-tela. 
        RUN initializeDBOs.
        ASSIGN l-selecionada = NO.

        FOR EACH bf-tt-browse-tela:
            ASSIGN bf-tt-browse-tela.marca = NO.
        END.

        DO  i-cont = 1 TO br-rf-tela:NUM-SELECTED-ROWS:
            ASSIGN l-selecionada = br-rf-tela:FETCH-SELECTED-ROW(i-cont).
            IF  l-selecionada THEN DO:
                ASSIGN tt-browse-tela.marca = YES.
            END.
        END.

        IF tt-browse-tela.tipo-etiqueta = 0 THEN DO:
            IF l-selecionada THEN DO:
                     RUN pi-gera-etiqueta-rf.
                     RUN BeforeDestroyInterface.
            END.                    
            NEXT.
        END.

         IF CAN-FIND(FIRST bf-tt-browse-tela WHERE
                           bf-tt-browse-tela.tipo-etiqueta <> 1 AND
                           bf-tt-browse-tela.marca = YES) THEN DO:
            DO i-cont = 1 TO br-rf-tela:NUM-SELECTED-ROWS:
                ASSIGN l-selecionada = br-rf-tela:FETCH-SELECTED-ROW(i-cont).
                IF  l-selecionada THEN DO:

                    IF tt-browse-tela.tipo-etiqueta = 1 THEN NEXT.

                    ASSIGN de-qtd-item-total    = 0
                           i-qtd-etiqueta-total = 0
                           de-qtd-item-filha    = 0
                           i-qtd-etiqueta-emb   = 0
                           de-qtd-item-emb      = 0.
 
                    FOR EACH bf-tt-browse-tela WHERE
                             bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                             bf-tt-browse-tela.cod-embalagem = tt-browse-tela.cod-embalagem AND
                             bf-tt-browse-tela.tipo-etiqueta <> 1 AND
                             bf-tt-browse-tela.marca         = YES NO-LOCK:
                            ASSIGN de-qtd-item-emb    = de-qtd-item-emb + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta)
                                   i-qtd-etiqueta-emb = i-qtd-etiqueta-emb + bf-tt-browse-tela.qtd-etiqueta.
                    END.
 
                    FOR EACH bf-tt-browse-tela WHERE
                             bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                             /*bf-tt-browse-tela.cod-embalagem = tt-browse-tela.cod-embalagem AND*/
                             bf-tt-browse-tela.tipo-etiqueta <> 1 AND
                             bf-tt-browse-tela.marca         = YES NO-LOCK:
                        ASSIGN de-qtd-item-total = de-qtd-item-total + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta)
                               i-qtd-etiqueta-total = i-qtd-etiqueta-total + bf-tt-browse-tela.qtd-etiqueta.
                    END.

                    FIND FIRST it-doc-fisico WHERE
                               it-doc-fisico.nro-docto = rf-numero:SCREEN-VALUE IN FRAME fPage4 AND
                               it-doc-fisico.sequencia = tt-browse-tela.num-seq                 AND
                               it-doc-fisico.it-codigo = tt-browse-tela.it-codigo NO-LOCK NO-ERROR.

                    IF de-qtd-item-total = (IF AVAIL it-doc-fisico THEN it-doc-fisico.quantidade ELSE 0) THEN DO:
                        ASSIGN l-qtd-item = YES.
                    END.
                    ELSE DO:
                        ASSIGN l-qtd-item = NO.
                        LEAVE.
                    END.

                    IF CAN-FIND(FIRST bf-tt-browse-tela WHERE
                                      bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                                      bf-tt-browse-tela.tipo-etiqueta = 1) THEN DO:

                        FOR EACH bf-tt-browse-tela WHERE
                                 bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                                 bf-tt-browse-tela.tipo-etiqueta = 1 AND
                                 bf-tt-browse-tela.marca         = YES NO-LOCK:
                                ASSIGN de-qtd-item-filha = de-qtd-item-filha + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta).
                        END.

                        IF de-qtd-item-filha = 0 THEN DO:
                            /*necess†rio selecionar emb filha*/
                            DEFINE VARIABLE c-liter-embalagem-filha AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "embalagem_filha_do_item" *}
                            ASSIGN c-liter-embalagem-filha = RETURN-VALUE.

                            DEFINE VARIABLE c-liter-a-impressao AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "(a)_impress∆o" *}
                            ASSIGN c-liter-a-impressao = RETURN-VALUE.
                            RUN utp/ut-msgs.p ("show",3721, c-liter-embalagem-filha + "~~" + c-liter-a-impressao). /*Nenhum(a) &1 foi selecionado(a) - N∆o Ç poss°vel continuar o &2 sem que algum(a) &1 seja selecionado(a)*/
                            RETURN "NOK":U.
                        END.
                        ELSE DO:
                            IF de-qtd-item-filha <> (IF AVAIL it-doc-fisico THEN it-doc-fisico.quantidade ELSE 0) THEN DO:
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-qtd-itens-embalagem AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "Quantidade_de_itens_da_embalagem_filha" *}
                                ASSIGN c-lbl-liter-qtd-itens-embalagem = TRIM(RETURN-VALUE).
                                DEFINE VARIABLE c-lbl-liter-embalagem-pai AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "embalagem_pai" *}
                                ASSIGN c-lbl-liter-embalagem-pai = TRIM(RETURN-VALUE).
                                /*qtd item emb filha difere do pai*/
                                RUN utp/ut-msgs.p ("show",33090, c-lbl-liter-qtd-itens-embalagem + "~~" + c-lbl-liter-embalagem-pai). /*&1 diferente &2 - &3 diferente &4*/
                                RETURN "NOK":U.
                            END.
                        END.

                    END.

                    ASSIGN i-qtd-movto-etiqueta = 0
                           de-qtd-movto-item    = 0.

                    FOR EACH wm-box-movto WHERE
                             wm-box-movto.cod-estabel    = rf-estab:SCREEN-VALUE             AND
                             wm-box-movto.cod-local      = rf-local:SCREEN-VALUE             AND
                             wm-box-movto.id-docto       = 0                                 AND
                             wm-box-movto.num-seq-item   = tt-browse-tela.num-seq            AND
                             wm-box-movto.cod-item       = tt-browse-tela.it-codigo          AND
                             wm-box-movto.cod-embalagem  = tt-browse-tela.cod-embalagem      AND
                             wm-box-movto.ind-tipo-movto = 1 AND
                             tt-browse-tela.tipo-etiqueta <> 1 NO-LOCK.
                             ASSIGN i-qtd-movto-etiqueta = i-qtd-movto-etiqueta + wm-box-movto.qti-embalagem
                                    de-qtd-movto-item    = de-qtd-movto-item    + (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem).
                    END.

                    FIND FIRST wm-box-movto WHERE
                               wm-box-movto.cod-estabel = rf-estab:SCREEN-VALUE             AND
                               wm-box-movto.cod-local   = rf-local:SCREEN-VALUE             AND
                               wm-box-movto.id-docto    = 0                                 AND
                               wm-box-movto.cod-item    = tt-browse-tela.it-codigo          NO-LOCK NO-ERROR.

                    IF AVAIL wm-box-movto THEN DO:
                        IF ((wm-box-movto.cod-embalagem = tt-browse-tela.cod-embalagem AND
                            (i-qtd-movto-etiqueta <> i-qtd-etiqueta-emb OR
                             de-qtd-item-emb <> de-qtd-movto-item)) OR
                            (wm-box-movto.cod-embalagem <> tt-browse-tela.cod-embalagem)) AND
                             tt-browse-tela.tipo-etiqueta <> 1 AND 
                             tt-browse-tela.tipo-etiqueta <> 2 THEN DO:
                                 CREATE tt-divergencia.
                                 BUFFER-COPY tt-browse-tela TO tt-divergencia.
                        END.
                    END.
                END.
            END.

            IF l-qtd-item THEN DO:
                IF CAN-FIND(FIRST tt-divergencia NO-LOCK) THEN DO:
/*                    {utp/ut-liter.i "fazer nova sugest∆o de alocaá∆o de itens"}
                    run utp/ut-msgs.p(input "show":U,
                                      input 26715,
                                      input RETURN-VALUE).

                    IF RETURN-VALUE = "YES" THEN DO: */
                        RUN pi-gera-etiqueta-rf.
                        run pi-desfaz-sugestao (INPUT rf-estab:SCREEN-VALUE,
                                                INPUT rf-local:SCREEN-VALUE,
                                                INPUT 0).
                        run pi-realizar-sugestao (INPUT rf-estab:SCREEN-VALUE,
                                                  INPUT rf-local:SCREEN-VALUE,
                                                  INPUT 0).
/*                     END.
                    ELSE DO:
                        RUN pi-gera-etiqueta-rf.
                    END. */
                END.
                ELSE DO:
                    RUN pi-gera-etiqueta-rf.
                END.
                RUN BeforeDestroyInterface.
            END.
            ELSE DO:
                DEFINE VARIABLE c-lbl-liter-qtd-itens AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Quantidade_de_itens" *}
                ASSIGN c-lbl-liter-qtd-itens = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-da-sugestao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "da_sugest∆o_de_alocaá∆o" *}
                ASSIGN c-lbl-liter-da-sugestao = TRIM(RETURN-VALUE).
                RUN utp/ut-msgs.p ("show",33090, c-lbl-liter-qtd-itens + "~~" + c-lbl-liter-da-sugestao). /*&1 diferente &2*/
            END.
        END.
        ELSE DO:
           DEFINE VARIABLE c-liter-sequencia-de-item AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "sequància_de_item_da_embalagem_pai" *}
           ASSIGN c-liter-sequencia-de-item = RETURN-VALUE.

           DEFINE VARIABLE c-liter-a-impressao-2 AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "(a)_impress∆o" *}
           ASSIGN c-liter-a-impressao-2 = RETURN-VALUE.
           RUN utp/ut-msgs.p ("show",3721, c-liter-sequencia-de-item + "~~" + c-liter-a-impressao-2). /*Nenhum(a) &1 foi selecionado(a) - N∆o Ç poss°vel continuar o &2 sem que algum(a) &1 seja selecionado(a)*/
        END.
    END.

    if num-results("br-rf-tela":U) = 0 THEN
        assign bt-incluir-rf:SENSITIVE in frame fPage4   = no
               bt-modificar-rf:SENSITIVE in frame fPage4 = no
               bt-eliminar-rf:SENSITIVE in frame fPage4  = no.

    APPLY "VALUE-CHANGED" TO br-rf-tela IN FRAME fPage4.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME bt-imprimir-todos-dc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprimir-todos-dc wWindow
ON CHOOSE OF bt-imprimir-todos-dc IN FRAME fPage3 /* Imprimir Todos */
DO:     

    EMPTY TEMP-TABLE tt-divergencia.
    EMPTY TEMP-TABLE tt-erro.

    IF NUM-RESULTS("br-dc-tela") = 0 OR 
       NUM-RESULTS("br-dc-tela") = ? THEN  DO:
         /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "sequància_de_item" *}
        RUN utp/ut-msgs.p ("show",29488, RETURN-VALUE). /*Nenhum &1 foi selecionado.*/
    END.
    ELSE DO:
        DEFINE BUFFER bf-tt-browse-tela FOR tt-browse-tela.  
        RUN initializeDBOs.
        br-dc-tela:SELECT-ALL().

        FOR EACH bf-tt-browse-tela:
            ASSIGN bf-tt-browse-tela.marca = YES.             
        END.
        DO  i-cont = 1 TO br-dc-tela:NUM-SELECTED-ROWS:
            ASSIGN l-selecionada = br-dc-tela:FETCH-SELECTED-ROW(i-cont).
            IF l-selecionada THEN DO:

                IF tt-browse-tela.tipo-etiqueta = 1 OR
                   tt-browse-tela.tipo-etiqueta = 0 THEN NEXT.
                ASSIGN de-qtd-item-total    = 0
                       i-qtd-etiqueta-total = 0
                       de-qtd-item-filha    = 0
                       i-qtd-etiqueta-emb   = 0
                       de-qtd-item-emb      = 0
                       de-qtd-item-row      = 0.
 
                FOR EACH bf-tt-browse-tela WHERE
                         bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                         bf-tt-browse-tela.cod-embalagem = tt-browse-tela.cod-embalagem AND
                         bf-tt-browse-tela.tipo-etiqueta <> 1 AND
                         bf-tt-browse-tela.marca         = YES NO-LOCK:
                    ASSIGN de-qtd-item-emb    = de-qtd-item-emb + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta)
                           i-qtd-etiqueta-emb = i-qtd-etiqueta-emb + bf-tt-browse-tela.qtd-etiqueta.
                END.
                IF tt-browse-tela.tipo-etiqueta <> 1 AND 
                   tt-browse-tela.tipo-etiqueta <> 0 THEN
                    ASSIGN de-qtd-item-row = tt-browse-tela.qtd-item * tt-browse-tela.qtd-etiqueta.
                FOR EACH bf-tt-browse-tela WHERE
                         bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                         /*bf-tt-browse-tela.cod-embalagem = tt-browse-tela.cod-embalagem*/
                         bf-tt-browse-tela.tipo-etiqueta <> 1 AND
                         bf-tt-browse-tela.tipo-etiqueta <> 0 NO-LOCK:
                    ASSIGN de-qtd-item-total = de-qtd-item-total + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta)
                           i-qtd-etiqueta-total = i-qtd-etiqueta-total + bf-tt-browse-tela.qtd-etiqueta.
                END.

                FIND FIRST wm-docto-itens WHERE
                           wm-docto-itens.cod-estabel  = dc-estab:SCREEN-VALUE             AND
                           wm-docto-itens.cod-local    = dc-local:SCREEN-VALUE             AND
                           wm-docto-itens.id-docto     = DECIMAL(dc-id-docto:SCREEN-VALUE) AND
                           wm-docto-itens.num-seq-item = tt-browse-tela.num-seq            AND
                           wm-docto-itens.cod-item     = tt-browse-tela.it-codigo NO-LOCK NO-ERROR.
                IF de-qtd-item-total = (IF AVAIL wm-docto-itens THEN wm-docto-itens.qtd-item ELSE 0) THEN DO:
                    ASSIGN l-qtd-item = YES.
                END.
                ELSE DO:
                    ASSIGN l-qtd-item = NO.
                    LEAVE.
                END.
                IF CAN-FIND(FIRST bf-tt-browse-tela WHERE
                                  bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                                  bf-tt-browse-tela.tipo-etiqueta = 1) THEN DO:
                      FOR EACH bf-tt-browse-tela WHERE
                               bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                               bf-tt-browse-tela.tipo-etiqueta = 1 NO-LOCK:
                              ASSIGN de-qtd-item-filha = de-qtd-item-filha + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta).
                      END.

                      IF de-qtd-item-filha = 0 THEN DO:
                          /*necess†rio selecionar emb filha*/
                          DEFINE VARIABLE c-liter-embalagem-filha AS CHARACTER NO-UNDO.
                          {utp/ut-liter.i "embalagem_filha_do_item" *}
                          ASSIGN c-liter-embalagem-filha = RETURN-VALUE.

                          DEFINE VARIABLE c-liter-a-impressao AS CHARACTER NO-UNDO.
                          {utp/ut-liter.i "(a)_impress∆o" *}
                          ASSIGN c-liter-a-impressao = RETURN-VALUE.
                          RUN utp/ut-msgs.p ("show",3721, c-liter-embalagem-filha + "~~" + c-liter-a-impressao). /*Nenhum(a) &1 foi selecionado(a) - N∆o Ç poss°vel continuar o &2 sem que algum(a) &1 seja selecionado(a)*/
                          RETURN "NOK":U.
                      END.
                      ELSE DO:
                          IF de-qtd-item-filha <> (IF AVAIL wm-docto-itens THEN wm-docto-itens.qtd-item ELSE 0) THEN DO:
                               /* Inicio -- Projeto Internacional */
                               DEFINE VARIABLE c-lbl-liter-qtd-itens-embalagem AS CHARACTER NO-UNDO.
                               {utp/ut-liter.i "Quantidade_de_itens_da_embalagem_filha" *}
                               ASSIGN c-lbl-liter-qtd-itens-embalagem = TRIM(RETURN-VALUE).
                               DEFINE VARIABLE c-lbl-liter-embalagem-pai AS CHARACTER NO-UNDO.
                               {utp/ut-liter.i "embalagem_pai" *}
                               ASSIGN c-lbl-liter-embalagem-pai = TRIM(RETURN-VALUE).
                               /*qtd item emb filha difere do pai*/
                               RUN utp/ut-msgs.p ("show",33090, c-lbl-liter-qtd-itens-embalagem + "~~" + c-lbl-liter-embalagem-pai). /*&1 diferente &2 - &3 diferente &4*/
                              RETURN "NOK":U.
                          END.
                      END.
                END.

                ASSIGN i-qtd-movto-etiqueta = 0
                       de-qtd-movto-item    = 0.
                FOR EACH wm-box-movto WHERE
                         wm-box-movto.cod-estabel    = dc-estab:SCREEN-VALUE             AND
                         wm-box-movto.cod-local      = dc-local:SCREEN-VALUE             AND
                         wm-box-movto.id-docto       = DECIMAL(dc-id-docto:SCREEN-VALUE) AND
                         wm-box-movto.num-seq-item   = tt-browse-tela.num-seq            AND
                         wm-box-movto.cod-item       = tt-browse-tela.it-codigo          AND
                         wm-box-movto.cod-embalagem  = tt-browse-tela.cod-embalagem      AND
                         wm-box-movto.ind-tipo-movto = 1 AND
                         tt-browse-tela.tipo-etiqueta <> 1 NO-LOCK.
                         ASSIGN i-qtd-movto-etiqueta = i-qtd-movto-etiqueta + wm-box-movto.qti-embalagem
                                de-qtd-movto-item    = de-qtd-movto-item    + (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem).
                END.
                IF tt-browse-tela.id-movto = 0 THEN DO:
                    FIND FIRST wm-box-movto WHERE
                               wm-box-movto.cod-estabel = dc-estab:SCREEN-VALUE             AND
                               wm-box-movto.cod-local   = dc-local:SCREEN-VALUE             AND
                               wm-box-movto.id-docto    = DECIMAL(dc-id-docto:SCREEN-VALUE) AND
                               wm-box-movto.cod-item    = tt-browse-tela.it-codigo          NO-LOCK NO-ERROR.
                    IF AVAIL wm-box-movto THEN DO:
                        IF ((wm-box-movto.cod-embalagem = tt-browse-tela.cod-embalagem AND
                            (i-qtd-movto-etiqueta <> i-qtd-etiqueta-emb OR
                             de-qtd-item-emb      <> de-qtd-movto-item)) OR
                            (wm-box-movto.cod-embalagem <> tt-browse-tela.cod-embalagem)) AND
                             tt-browse-tela.tipo-etiqueta <> 1 /*AND
                             tt-browse-tela.tipo-etiqueta <> 2*/ THEN DO:
                                 CREATE tt-divergencia.
                                 BUFFER-COPY tt-browse-tela TO tt-divergencia.
                        END.
                    END.
                END.
                ELSE DO:
                    FIND FIRST wm-box-movto WHERE
                               wm-box-movto.cod-estabel = dc-estab:SCREEN-VALUE             AND
                               wm-box-movto.cod-local   = dc-local:SCREEN-VALUE             AND
                               wm-box-movto.id-docto    = DECIMAL(dc-id-docto:SCREEN-VALUE) AND
                               wm-box-movto.id-movto    = tt-browse-tela.id-movto           AND
                               wm-box-movto.cod-item    = tt-browse-tela.it-codigo          NO-LOCK NO-ERROR.
                    IF AVAIL wm-box-movto THEN DO: 
                        IF ((wm-box-movto.cod-embalagem = tt-browse-tela.cod-embalagem AND
                            (i-qtd-movto-etiqueta <> i-qtd-etiqueta-emb OR
                             de-qtd-item-row      <> wm-box-movto.qtd-item OR
                             de-qtd-item-emb      <> de-qtd-movto-item)) OR
                            (wm-box-movto.cod-embalagem <> tt-browse-tela.cod-embalagem)) AND
                             tt-browse-tela.tipo-etiqueta <> 1 /*AND
                             tt-browse-tela.tipo-etiqueta <> 2*/ THEN DO:
                                 CREATE tt-divergencia.
                                 BUFFER-COPY tt-browse-tela TO tt-divergencia.
                        END.
                    END.
                END.
            END.
        END.

        IF l-qtd-item THEN DO:
            FIND FIRST tt-divergencia NO-LOCK NO-ERROR.
            IF AVAIL tt-divergencia THEN DO:
/*                 {utp/ut-liter.i "fazer nova sugest∆o de alocaá∆o de itens"}
                 run utp/ut-msgs.p(input "show":U,
                                   input 26715,
                                   input RETURN-VALUE).

                 IF RETURN-VALUE = "YES" THEN DO: */
                    run pi-desfaz-sugestao (INPUT dc-estab:SCREEN-VALUE,           
                                            INPUT dc-local:SCREEN-VALUE,
                                            INPUT DECIMAL(dc-id-docto:SCREEN-VALUE)).
                    RUN pi-gera-etiqueta-docto.
                    run pi-realizar-sugestao (INPUT dc-estab:SCREEN-VALUE,           
                                              INPUT dc-local:SCREEN-VALUE,
                                              INPUT DECIMAL(dc-id-docto:SCREEN-VALUE)).
/*                  END.
                 ELSE DO:
                    RUN pi-gera-etiqueta-docto.
                 END. */
            END.    
            ELSE DO:
                RUN pi-gera-etiqueta-docto.
            END.
            RUN BeforeDestroyInterface.
        END.
        ELSE DO:
            DEFINE VARIABLE c-lbl-liter-qtd-itens AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Quantidade_de_itens" *}
            ASSIGN c-lbl-liter-qtd-itens = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-da-sugestao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "da_sugest∆o_de_alocaá∆o" *}
            ASSIGN c-lbl-liter-da-sugestao = TRIM(RETURN-VALUE).
            RUN utp/ut-msgs.p ("show",33090, c-lbl-liter-qtd-itens + "~~" + c-lbl-liter-da-sugestao). /*&1 diferente &2*/
        END.
        
    END.
    if num-results("br-dc-tela":U) = 0 THEN
        assign bt-incluir-dc:SENSITIVE in frame fPage3   = no
               bt-modificar-dc:SENSITIVE in frame fPage3 = no
               bt-eliminar-dc:SENSITIVE in frame fPage3  = no.

    APPLY "VALUE-CHANGED" TO br-dc-tela IN FRAME fPage3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-imprimir-todos-it
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprimir-todos-it wWindow
ON CHOOSE OF bt-imprimir-todos-it IN FRAME fPage2 /* Imprimir Todos */
DO:     

    EMPTY TEMP-TABLE tt-erro.

    IF NUM-RESULTS("br-it-tela") = 0 OR 
       NUM-RESULTS("br-it-tela") = ? THEN DO:
         /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "sequància_de_item" *}
        RUN utp/ut-msgs.p ("show",29488, RETURN-VALUE). /*Nenhum &1 foi selecionado.*/
    END.
    ELSE DO:
        DEFINE BUFFER bf-tt-browse-tela FOR tt-browse-tela.
        RUN initializeDBOs.
        br-it-tela:SELECT-ALL().

        FOR EACH bf-tt-browse-tela:
            ASSIGN bf-tt-browse-tela.marca = YES.             
        END.

        DO i-cont = 1 TO br-it-tela:NUM-SELECTED-ROWS:
            ASSIGN l-selecionada = br-it-tela:FETCH-SELECTED-ROW(i-cont).
            IF  l-selecionada THEN DO:

                IF tt-browse-tela.tipo-etiqueta = 1 OR
                   tt-browse-tela.tipo-etiqueta = 0 THEN NEXT.

                ASSIGN de-qtd-item-total    = 0
                       de-qtd-item-filha    = 0.
 
                FOR EACH bf-tt-browse-tela WHERE
                         bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                         /*bf-tt-browse-tela.cod-embalagem = tt-browse-tela.cod-embalagem AND*/
                         bf-tt-browse-tela.tipo-etiqueta <> 1 AND
                         bf-tt-browse-tela.tipo-etiqueta <> 0 AND                            
                         bf-tt-browse-tela.marca         = YES NO-LOCK:
                        ASSIGN de-qtd-item-total    = de-qtd-item-total + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta).
                END.

                IF CAN-FIND(FIRST bf-tt-browse-tela WHERE
                                  bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                                  bf-tt-browse-tela.tipo-etiqueta = 1) THEN DO:

                    FOR EACH bf-tt-browse-tela WHERE
                             bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                             bf-tt-browse-tela.tipo-etiqueta = 1 AND
                             bf-tt-browse-tela.marca         = YES NO-LOCK:
                            ASSIGN de-qtd-item-filha = de-qtd-item-filha + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta).
                    END.

                    IF de-qtd-item-filha = 0 THEN DO:                        
                            /*necess†rio selecionar emb filha*/
                            DEFINE VARIABLE c-liter-embalagem-filha AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "embalagem_filha_do_item" *}
                            ASSIGN c-liter-embalagem-filha = RETURN-VALUE.

                            DEFINE VARIABLE c-liter-a-impressao AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "(a)_impress∆o" *}
                            ASSIGN c-liter-a-impressao = RETURN-VALUE.
                            RUN utp/ut-msgs.p ("show",3721, c-liter-embalagem-filha + "~~" + c-liter-a-impressao). /*Nenhum(a) &1 foi selecionado(a) - N∆o Ç poss°vel continuar o &2 sem que algum(a) &1 seja selecionado(a)*/
                        RETURN "NOK":U.
                    END.
                    ELSE DO:
                        IF de-qtd-item-filha <> de-qtd-item-total THEN DO:
                            /* Inicio -- Projeto Internacional */
                            DEFINE VARIABLE c-lbl-liter-qtd-itens-embalagem AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "Quantidade_de_itens_da_embalagem_filha" *}
                            ASSIGN c-lbl-liter-qtd-itens-embalagem = TRIM(RETURN-VALUE).
                            DEFINE VARIABLE c-lbl-liter-embalagem-pai AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "embalagem_pai" *}
                            ASSIGN c-lbl-liter-embalagem-pai = TRIM(RETURN-VALUE).
                            /*qtd item emb filha difere do pai*/
                            RUN utp/ut-msgs.p ("show",33090, c-lbl-liter-qtd-itens-embalagem + "~~" + c-lbl-liter-embalagem-pai). /*&1 diferente &2 - &3 diferente &4*/
                            RETURN "NOK":U.
                        END.
                    END.
                END.
            END.
        END.

        RUN pi-gera-etiqueta-it.
        RUN BeforeDestroyInterface.
    END.

    if num-results("br-it-tela":U) = 0 THEN
        assign bt-incluir-it:SENSITIVE in frame fPage2   = no
               bt-modificar-it:SENSITIVE in frame fPage2 = no
               bt-eliminar-it:SENSITIVE in frame fPage2  = no.

    APPLY "VALUE-CHANGED" TO br-it-tela IN FRAME fPage2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-imprimir-todos-op
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprimir-todos-op wWindow
ON CHOOSE OF bt-imprimir-todos-op IN FRAME fPage1 /* Imprimir Todos */
DO:     

    EMPTY TEMP-TABLE tt-divergencia.
    EMPTY TEMP-TABLE tt-erro.

    IF NUM-RESULTS("br-op-tela") = 0 OR 
       NUM-RESULTS("br-op-tela") = ? THEN  DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "sequància_de_item" *}
        RUN utp/ut-msgs.p ("show",29488, RETURN-VALUE). /*Nenhum &1 foi selecionado.*/
    END.
    ELSE DO:
        DEFINE BUFFER bf-tt-browse-tela FOR tt-browse-tela.
        RUN initializeDBOs.
        br-op-tela:SELECT-ALL().

        FOR EACH bf-tt-browse-tela:
            ASSIGN bf-tt-browse-tela.marca = YES.             
        END.

        DO  i-cont = 1 TO br-op-tela:NUM-SELECTED-ROWS:
            ASSIGN l-selecionada = br-op-tela:FETCH-SELECTED-ROW(i-cont).
            
            IF l-selecionada THEN DO:

                IF tt-browse-tela.tipo-etiqueta = 1 OR
                   tt-browse-tela.tipo-etiqueta = 0 THEN NEXT.

                ASSIGN de-qtd-item-total    = 0
                       i-qtd-etiqueta-total = 0
                       de-qtd-item-filha    = 0
                       i-qtd-etiqueta-emb   = 0
                       de-qtd-item-emb      = 0.
 
                FOR EACH bf-tt-browse-tela WHERE
                         bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                         bf-tt-browse-tela.cod-embalagem = tt-browse-tela.cod-embalagem AND
                         bf-tt-browse-tela.tipo-etiqueta <> 1 AND
                         bf-tt-browse-tela.marca         = YES NO-LOCK:
                        ASSIGN de-qtd-item-emb    = de-qtd-item-emb + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta)
                               i-qtd-etiqueta-emb = i-qtd-etiqueta-emb + bf-tt-browse-tela.qtd-etiqueta.
                END.

                FOR EACH bf-tt-browse-tela WHERE
                         bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                         /*bf-tt-browse-tela.cod-embalagem = tt-browse-tela.cod-embalagem*/
                         bf-tt-browse-tela.tipo-etiqueta <> 0 AND 
                         bf-tt-browse-tela.tipo-etiqueta <> 1 NO-LOCK:
                    ASSIGN de-qtd-item-total = de-qtd-item-total + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta)
                           i-qtd-etiqueta-total = i-qtd-etiqueta-total + bf-tt-browse-tela.qtd-etiqueta.
                END.

                IF de-qtd-item-total = DECIMAL(op-quantidade:SCREEN-VALUE IN FRAME fPage1) THEN DO:
                    ASSIGN l-qtd-item = YES.
                END.
                ELSE DO:
                    ASSIGN l-qtd-item = NO.
                    LEAVE.
                END.

                IF CAN-FIND(FIRST bf-tt-browse-tela WHERE
                                  bf-tt-browse-tela.tipo-etiqueta = 1) THEN DO:

                    FOR EACH bf-tt-browse-tela WHERE
                             bf-tt-browse-tela.tipo-etiqueta = 1 NO-LOCK:
                            ASSIGN de-qtd-item-filha = de-qtd-item-filha + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta).
                    END.

                    IF de-qtd-item-filha = 0 THEN DO:
                        /*necess†rio selecionar emb filha*/
                        DEFINE VARIABLE c-liter-embalagem-filha AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "embalagem_filha_do_item" *}
                        ASSIGN c-liter-embalagem-filha = RETURN-VALUE.

                        DEFINE VARIABLE c-liter-a-impressao AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "(a)_impress∆o" *}
                        ASSIGN c-liter-a-impressao = RETURN-VALUE.
                        RUN utp/ut-msgs.p ("show",3721, c-liter-embalagem-filha + "~~" + c-liter-a-impressao). /*Nenhum(a) &1 foi selecionado(a) - N∆o Ç poss°vel continuar o &2 sem que algum(a) &1 seja selecionado(a)*/
                        RETURN "NOK":U.
                    END.
                END.

                ASSIGN i-qtd-movto-etiqueta = 0
                       de-qtd-movto-item    = 0.

                FOR EACH wm-box-movto WHERE
                         wm-box-movto.cod-estabel    = tt-browse-tela.cod-estabel        AND
                         wm-box-movto.cod-local      = op-local:SCREEN-VALUE             AND
                         wm-box-movto.id-docto       = 0                                 AND
                         wm-box-movto.num-seq-item   = tt-browse-tela.num-seq            AND
                         wm-box-movto.cod-item       = tt-browse-tela.it-codigo          AND
                         wm-box-movto.cod-embalagem  = tt-browse-tela.cod-embalagem      AND
                         wm-box-movto.ind-tipo-movto = 1 AND
                         tt-browse-tela.tipo-etiqueta <> 1 NO-LOCK.
                         ASSIGN i-qtd-movto-etiqueta = i-qtd-movto-etiqueta + wm-box-movto.qti-embalagem
                                de-qtd-movto-item    = de-qtd-movto-item    + (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem).
                END.

                FIND FIRST wm-box-movto WHERE
                           wm-box-movto.cod-estabel = tt-browse-tela.cod-estabel        AND
                           wm-box-movto.cod-local   = op-local:SCREEN-VALUE             AND
                           wm-box-movto.id-docto    = 0                                 AND
                           wm-box-movto.cod-item    = tt-browse-tela.it-codigo          NO-LOCK NO-ERROR.

                IF AVAIL wm-box-movto THEN DO:
                    IF ((wm-box-movto.cod-embalagem = tt-browse-tela.cod-embalagem AND
                        (i-qtd-movto-etiqueta <> i-qtd-etiqueta-emb OR
                         de-qtd-item-emb <> de-qtd-movto-item)) OR
                        (wm-box-movto.cod-embalagem <> tt-browse-tela.cod-embalagem)) AND
                         tt-browse-tela.tipo-etiqueta <> 1 AND
                         tt-browse-tela.tipo-etiqueta <> 2 THEN DO:
                             CREATE tt-divergencia.
                             BUFFER-COPY tt-browse-tela TO tt-divergencia.
                    END.
                END.
            END.
        END.
        RUN pi-gera-etiqueta-op.
/*
            IF l-qtd-item THEN DO:                                                                                                       
                FIND FIRST tt-divergencia NO-LOCK NO-ERROR.                                             
               IF AVAIL tt-divergencia THEN DO:                                                                                  
                   {utp/ut-liter.i "fazer nova sugest∆o de alocaá∆o de itens"}  
                     run utp/ut-msgs.p(input "show":U,                                                  
                                       input 26715,                                                                              
                                       input RETURN-VALUE).                                             
                     IF RETURN-VALUE = "YES" THEN DO:                                                                            
                        RUN pi-gera-etiqueta-op.                                                                                         
                        run pi-desfaz-sugestao (INPUT tt-browse-tela.cod-estabel,         
                                                INPUT op-local:SCREEN-VALUE,            
                                                INPUT 0).                                                       
                        run pi-realizar-sugestao (INPUT tt-browse-tela.cod-estabel,       
                                                  INPUT op-local:SCREEN-VALUE,  
                                                  INPUT 0).                                             
                     END.                                                                                                                            
                     ELSE DO:                                                                                                                
                        RUN pi-gera-etiqueta-op.                                                                                         
                     END.                                                                                                                            
                END.                                                                                                                             
                ELSE DO:                                                                                                                             
                    RUN pi-gera-etiqueta-op.                                                                                         
                END.                                                                                                                             
                RUN BeforeDestroyInterface.                                                                                          
            END.                                                                                                                                                                                                                        
            ELSE DO:                                                                                                                             
              DEFINE VARIABLE c-lbl-liter-qtd-itens AS CHARACTER NO-UNDO.                       
               {utp/ut-liter.i "Quantidade_de_itens" *}                                                 
                ASSIGN c-lbl-liter-qtd-itens = TRIM(RETURN-VALUE).                              
                DEFINE VARIABLE c-lbl-liter-da-sugestao AS CHARACTER NO-UNDO.           
                {utp/ut-liter.i "da_sugest∆o_de_alocaá∆o" *}                                            
                ASSIGN c-lbl-liter-da-sugestao = TRIM(RETURN-VALUE).                            
                RUN utp/ut-msgs.p ("show",33090, c-lbl-liter-qtd-itens + "~~" + c-lbl-liter-da-sugestao).
          END.
*/
    END.
    if num-results("br-op-tela":U) = 0 THEN
        assign bt-incluir-op:SENSITIVE in frame fPage1   = no
               bt-modificar-op:SENSITIVE in frame fPage1 = no
               bt-eliminar-op:SENSITIVE in frame fPage1  = no.

    APPLY "VALUE-CHANGED" TO br-op-tela IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME bt-imprimir-todos-rf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprimir-todos-rf wWindow
ON CHOOSE OF bt-imprimir-todos-rf IN FRAME fPage4 /* Imprimir Todos */
DO:     

    EMPTY TEMP-TABLE tt-divergencia.
    EMPTY TEMP-TABLE tt-erro.

    IF NUM-RESULTS("br-rf-tela") = 0 OR 
       NUM-RESULTS("br-rf-tela") = ? THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "sequància_de_item" *}
        RUN utp/ut-msgs.p ("show",29488, RETURN-VALUE). /*Nenhum &1 foi selecionado.*/
    END.
    ELSE DO:
        DEFINE BUFFER bf-tt-browse-tela FOR tt-browse-tela.
        RUN initializeDBOs.
        br-rf-tela:SELECT-ALL().

        FOR EACH bf-tt-browse-tela:
            ASSIGN bf-tt-browse-tela.marca = YES.             
        END.

        DO  i-cont = 1 TO br-rf-tela:NUM-SELECTED-ROWS:
            ASSIGN l-selecionada = br-rf-tela:FETCH-SELECTED-ROW(i-cont).
            
            IF l-selecionada THEN DO:

                IF tt-browse-tela.tipo-etiqueta = 1 OR
                   tt-browse-tela.tipo-etiqueta = 0 THEN NEXT.

                ASSIGN de-qtd-item-total    = 0
                       i-qtd-etiqueta-total = 0
                       de-qtd-item-filha    = 0
                       i-qtd-etiqueta-emb   = 0
                       de-qtd-item-emb      = 0.
 
                FOR EACH bf-tt-browse-tela WHERE
                         bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                         bf-tt-browse-tela.cod-embalagem = tt-browse-tela.cod-embalagem AND
                         bf-tt-browse-tela.tipo-etiqueta <> 1 AND
                         bf-tt-browse-tela.marca         = YES NO-LOCK:
                        ASSIGN de-qtd-item-emb    = de-qtd-item-emb + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta)
                               i-qtd-etiqueta-emb = i-qtd-etiqueta-emb + bf-tt-browse-tela.qtd-etiqueta.
                END.

                FOR EACH bf-tt-browse-tela WHERE
                         bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                         /*bf-tt-browse-tela.cod-embalagem = tt-browse-tela.cod-embalagem*/
                         bf-tt-browse-tela.tipo-etiqueta <> 1 AND 
                         bf-tt-browse-tela.tipo-etiqueta <> 0 NO-LOCK:
                    ASSIGN de-qtd-item-total = de-qtd-item-total + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta)
                           i-qtd-etiqueta-total = i-qtd-etiqueta-total + bf-tt-browse-tela.qtd-etiqueta.
                END.

                FIND FIRST it-doc-fisico WHERE
                           it-doc-fisico.nro-docto = rf-numero:SCREEN-VALUE IN FRAME fPage4 AND
                           it-doc-fisico.sequencia = tt-browse-tela.num-seq                 AND
                           it-doc-fisico.it-codigo = tt-browse-tela.it-codigo NO-LOCK NO-ERROR.

                IF de-qtd-item-total = (IF AVAIL it-doc-fisico THEN it-doc-fisico.quantidade ELSE 0) THEN DO:
                    ASSIGN l-qtd-item = YES.
                END.
                ELSE DO:
                    ASSIGN l-qtd-item = NO.
                    LEAVE.
                END.

                IF CAN-FIND(FIRST bf-tt-browse-tela WHERE
                                  bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                                  bf-tt-browse-tela.tipo-etiqueta = 1) THEN DO:

                     FOR EACH bf-tt-browse-tela WHERE
                              bf-tt-browse-tela.num-seq       = tt-browse-tela.num-seq AND
                              bf-tt-browse-tela.tipo-etiqueta = 1 NO-LOCK:
                            ASSIGN de-qtd-item-filha = de-qtd-item-filha + (bf-tt-browse-tela.qtd-item * bf-tt-browse-tela.qtd-etiqueta).
                     END.

                     IF de-qtd-item-filha = 0 THEN DO:
                         /*necess†rio selecionar emb filha*/
                         DEFINE VARIABLE c-liter-embalagem-filha AS CHARACTER NO-UNDO.
                         {utp/ut-liter.i "embalagem_filha_do_item" *}
                         ASSIGN c-liter-embalagem-filha = RETURN-VALUE.

                         DEFINE VARIABLE c-liter-a-impressao AS CHARACTER NO-UNDO.
                         {utp/ut-liter.i "(a)_impress∆o" *}
                         ASSIGN c-liter-a-impressao = RETURN-VALUE.
                         RUN utp/ut-msgs.p ("show",3721, c-liter-embalagem-filha + "~~" + c-liter-a-impressao). /*Nenhum(a) &1 foi selecionado(a) - N∆o Ç poss°vel continuar o &2 sem que algum(a) &1 seja selecionado(a)*/
                         RETURN "NOK":U.
                     END.
                     ELSE DO:
                          IF de-qtd-item-filha <> (IF AVAIL it-doc-fisico THEN it-doc-fisico.quantidade ELSE 0) THEN DO:
                              /* Inicio -- Projeto Internacional */
                              DEFINE VARIABLE c-lbl-liter-qtd-itens-embalagem AS CHARACTER NO-UNDO.
                              {utp/ut-liter.i "Quantidade_de_itens_da_embalagem_filha" *}
                              ASSIGN c-lbl-liter-qtd-itens-embalagem = TRIM(RETURN-VALUE).
                              DEFINE VARIABLE c-lbl-liter-embalagem-pai AS CHARACTER NO-UNDO.
                              {utp/ut-liter.i "embalagem_pai" *}
                              ASSIGN c-lbl-liter-embalagem-pai = TRIM(RETURN-VALUE).
                              /*qtd item emb filha difere do pai*/
                              RUN utp/ut-msgs.p ("show",33090, c-lbl-liter-qtd-itens-embalagem + "~~" + c-lbl-liter-embalagem-pai). /*&1 diferente &2 - &3 diferente &4*/
                             RETURN "NOK":U.
                          END.
                     END.

                END.

                ASSIGN i-qtd-movto-etiqueta = 0
                       de-qtd-movto-item    = 0.

                FOR EACH wm-box-movto WHERE
                         wm-box-movto.cod-estabel    = rf-estab:SCREEN-VALUE             AND
                         wm-box-movto.cod-local      = rf-local:SCREEN-VALUE             AND
                         wm-box-movto.id-docto       = 0                                 AND
                         wm-box-movto.num-seq-item   = tt-browse-tela.num-seq            AND
                         wm-box-movto.cod-item       = tt-browse-tela.it-codigo          AND
                         wm-box-movto.cod-embalagem  = tt-browse-tela.cod-embalagem      AND
                         wm-box-movto.ind-tipo-movto = 1 AND
                         tt-browse-tela.tipo-etiqueta <> 1 NO-LOCK.
                         ASSIGN i-qtd-movto-etiqueta = i-qtd-movto-etiqueta + wm-box-movto.qti-embalagem
                                de-qtd-movto-item    = de-qtd-movto-item    + (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem).
                END.

                FIND FIRST wm-box-movto WHERE
                           wm-box-movto.cod-estabel = rf-estab:SCREEN-VALUE             AND
                           wm-box-movto.cod-local   = rf-local:SCREEN-VALUE             AND
                           wm-box-movto.id-docto    = 0                                 AND
                           wm-box-movto.cod-item    = tt-browse-tela.it-codigo          NO-LOCK NO-ERROR.

                IF AVAIL wm-box-movto THEN DO:
                    IF ((wm-box-movto.cod-embalagem = tt-browse-tela.cod-embalagem AND
                        (i-qtd-movto-etiqueta <> i-qtd-etiqueta-emb OR
                         de-qtd-item-emb <> de-qtd-movto-item)) OR
                        (wm-box-movto.cod-embalagem <> tt-browse-tela.cod-embalagem)) AND
                         tt-browse-tela.tipo-etiqueta <> 1 AND 
                         tt-browse-tela.tipo-etiqueta <> 2 THEN DO:
                             CREATE tt-divergencia.
                             BUFFER-COPY tt-browse-tela TO tt-divergencia.
                    END.
                END.
            END.
        END.

        IF l-qtd-item THEN DO:
            FIND FIRST tt-divergencia NO-LOCK NO-ERROR.
            IF AVAIL tt-divergencia THEN DO:
/*                 {utp/ut-liter.i "fazer nova sugest∆o de alocaá∆o de itens"}
                 run utp/ut-msgs.p(input "show":U,
                                   input 26715,
                                   input RETURN-VALUE).

                 IF RETURN-VALUE = "YES" THEN DO: */
                    RUN pi-gera-etiqueta-rf.
                    run pi-desfaz-sugestao (INPUT rf-estab:SCREEN-VALUE,           
                                            INPUT rf-local:SCREEN-VALUE,
                                            INPUT 0).
                    run pi-realizar-sugestao (INPUT rf-estab:SCREEN-VALUE,           
                                              INPUT rf-local:SCREEN-VALUE,
                                              INPUT 0).
/*                  END.
                 ELSE DO:
                    RUN pi-gera-etiqueta-rf.
                 END. */
            END.
            ELSE DO:
                RUN pi-gera-etiqueta-rf.
            END.
            RUN BeforeDestroyInterface.
        END.
        ELSE DO:
            DEFINE VARIABLE c-lbl-liter-qtd-itens AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Quantidade_de_itens" *}
            ASSIGN c-lbl-liter-qtd-itens = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-da-sugestao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "da_sugest∆o_de_alocaá∆o" *}
            ASSIGN c-lbl-liter-da-sugestao = TRIM(RETURN-VALUE).
            RUN utp/ut-msgs.p ("show",33090, c-lbl-liter-qtd-itens + "~~" + c-lbl-liter-da-sugestao). /*&1 diferente &2*/
        END.
    END.

    if num-results("br-rf-tela":U) = 0 THEN
        assign bt-incluir-rf:SENSITIVE in frame fPage4   = no
               bt-modificar-rf:SENSITIVE in frame fPage4 = no
               bt-eliminar-rf:SENSITIVE in frame fPage4  = no.

    APPLY "VALUE-CHANGED" TO br-rf-tela IN FRAME fPage4.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME bt-incluir-dc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir-dc wWindow
ON CHOOSE OF bt-incluir-dc IN FRAME fPage3 /* Incluir */
DO:
    DEF VAR l-cont AS LOGICAL NO-UNDO.
    
    ASSIGN i-num-seq-item        = 0
           c-it-codigo           = ""
           c-lote                = ""
           c-cod-refer           = ""
           c-cod-embalagem       = ""
           de-qtd-item           = 0
           de-qtd-item-embalagem = 0
           de-qtd-peso-item      = 0
           de-qtd-etiqueta       = 0.

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

    if br-dc-tela:num-selected-rows > 0 then DO:
       if avail tt-browse-tela then do:
           get current br-dc-tela.

           ASSIGN i-num-seq-item        = tt-browse-tela.num-seq
                  c-it-codigo           = tt-browse-tela.it-codigo
                  c-lote                = tt-browse-tela.lote
                  c-cod-refer           = tt-browse-tela.cod-refer
                  c-cod-embalagem       = tt-browse-tela.cod-embalagem.

           ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

           RUN bcp/bc9026a.w (INPUT 4,
                               INPUT dc-estab:SCREEN-VALUE,
                               INPUT dc-local:SCREEN-VALUE,
                               INPUT tt-browse-tela.id-docto,
                               INPUT dc-numero:SCREEN-VALUE,
                               INPUT-OUTPUT i-num-seq-item, 
                               INPUT-OUTPUT c-it-codigo,
                               INPUT-OUTPUT c-lote,
                               INPUT-OUTPUT c-cod-refer,
                               INPUT-OUTPUT c-cod-embalagem,
                               INPUT-OUTPUT de-qtd-item,
                               INPUT-OUTPUT de-qtd-peso-item,
                               INPUT-OUTPUT de-qtd-etiqueta,
                               OUTPUT de-qtd-item-embalagem).

           ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.


          IF c-it-codigo <> "" THEN DO:
             ASSIGN bt-modificar-dc:SENSITIVE in frame fPage3 = YES
                    bt-eliminar-dc:SENSITIVE in frame fPage3  = YES.
       
             FIND FIRST tt-embalagem 
                  WHERE tt-embalagem.NumSeqItem   = i-num-seq-item  AND
                        tt-embalagem.CodItem      = c-it-codigo     AND
                        tt-embalagem.CodLote      = c-lote          AND
                        tt-embalagem.CodEmbalagem = c-cod-embalagem NO-LOCK NO-ERROR.
             IF NOT AVAIL tt-embalagem  THEN
                FOR FIRST tt-embalagem 
                      WHERE tt-embalagem.NumSeqItem   = i-num-seq-item  AND
                            tt-embalagem.CodItem      = c-it-codigo     AND
                            tt-embalagem.CodLote      = c-lote          NO-LOCK:
                    ASSIGN dt-validadeLote = tt-embalagem.DtValidadeLote.
                END.                

             CREATE tt-browse-tela.
             ASSIGN tt-browse-tela.cod-estabel        = dc-estab:SCREEN-VALUE
                    tt-browse-tela.id-docto           = DECIMAL(dc-id-docto:SCREEN-VALUE)
                    tt-browse-tela.cod-local          = dc-local:SCREEN-VALUE
                    tt-browse-tela.num-seq            = i-num-seq-item
                    tt-browse-tela.cod-embalagem      = c-cod-embalagem
                    tt-browse-tela.cod-refer          = c-cod-refer
                    tt-browse-tela.it-codigo          = c-it-codigo
                    tt-browse-tela.lote               = c-lote
                    tt-browse-tela.qtd-item           = de-qtd-item
                    tt-browse-tela.qtd-item-embalagem = de-qtd-item-embalagem
                    tt-browse-tela.qtd-etiqueta       = de-qtd-etiqueta
                    tt-browse-tela.cod-usuario        = c-seg-usuario
                    tt-browse-tela.qtd-peso-item      = de-qtd-peso-item
                    tt-browse-tela.dt-validade-lote   = IF AVAIL tt-embalagem THEN tt-embalagem.DtValidadeLote ELSE 01/01/0001
                    tt-browse-tela.logPai             = IF AVAIL tt-embalagem THEN tt-embalagem.logPai ELSE NO
                    tt-browse-tela.ControlaEtiqueta   = IF AVAIL tt-embalagem THEN tt-embalagem.ControlaEtiqueta ELSE NO
                    tt-browse-tela.layout-etiqueta    = IF AVAIL tt-embalagem THEN tt-embalagem.CodLayoutEmbalagem ELSE ?
                    tt-browse-tela.dt-validade-lote   = IF AVAIL tt-embalagem THEN 
                                                            tt-embalagem.DtValidadeLote 
                                                        ELSE 
                                                           IF dt-validadeLote <> ? THEN
                                                               dt-validadeLote
                                                               ELSE 
                                                                   TODAY
                    tt-browse-tela.cod-ean            = IF AVAIL tt-embalagem THEN STRING(tt-embalagem.codBARRASITEM) ELSE ""
                    tt-browse-tela.cod-dun            = IF AVAIL tt-embalagem THEN STRING(tt-embalagem.codbarrasembalagem) ELSE "".
             
       
             FOR EACH tt-browse-tela 
                 WHERE tt-browse-tela.logpai        = YES 
                /* AND   tt-browse-tela.tipo-etiqueta = 0*/:
                ASSIGN l-cont = NO.
                FOR EACH bftt-browse-tela 
                   WHERE bftt-browse-tela.it-codigo     = tt-browse-tela.it-codigo 
                   AND   bftt-browse-tela.cod-refer     = tt-browse-tela.cod-refer 
                   AND   bftt-browse-tela.lote          = tt-browse-tela.lote      
                   AND   bftt-browse-tela.logpai        = NO.
                   ASSIGN l-cont = YES.
                    IF tt-browse-tela.ControlaEtiqueta = YES AND bftt-browse-tela.ControlaEtiqueta = YES THEN  
                        ASSIGN tt-browse-tela.tipo-etiqueta   = 2
                               bftt-browse-tela.tipo-etiqueta = 1
                               tt-browse-tela.desc-tipo-etiqueta   = "Agupadora"
                               bftt-browse-tela.desc-tipo-etiqueta = "N∆o Agrupadora".  
                    IF tt-browse-tela.ControlaEtiqueta = YES AND bftt-browse-tela.ControlaEtiqueta = NO THEN  
                        ASSIGN tt-browse-tela.tipo-etiqueta = 3
                               tt-browse-tela.desc-tipo-etiqueta   = "Agupadora Pr¢pria"
                               bftt-browse-tela.desc-tipo-etiqueta = "N∆o Controlada".
                END.
                IF l-cont = NO THEN
                    ASSIGN tt-browse-tela.tipo-etiqueta        = 3
                           tt-browse-tela.desc-tipo-etiqueta   = "Agupadora Pr¢pria".
             END.
            {&OPEN-QUERY-br-dc-tela}
            APPLY "VALUE-CHANGED" TO br-dc-tela IN FRAME fPage3.
           END.
       end.
    END.
    ELSE DO:

        RUN bcp/bc9026a.w (INPUT 2,
                           INPUT dc-estab:SCREEN-VALUE,
                           INPUT dc-local:SCREEN-VALUE,
                           INPUT DECIMAL(dc-id-docto:SCREEN-VALUE),
                           INPUT dc-numero:SCREEN-VALUE,
                           INPUT-OUTPUT i-num-seq-item,
                           INPUT-OUTPUT c-it-codigo,
                           INPUT-OUTPUT c-lote,
                           INPUT-OUTPUT c-cod-refer,
                           INPUT-OUTPUT c-cod-embalagem,
                           INPUT-OUTPUT de-qtd-item,
                           INPUT-OUTPUT de-qtd-peso-item,
                           INPUT-OUTPUT de-qtd-etiqueta,
                           OUTPUT de-qtd-item-embalagem).
    
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    
         IF c-it-codigo <> "" THEN DO:
            ASSIGN bt-modificar-dc:SENSITIVE in frame fPage3 = YES
                   bt-eliminar-dc:SENSITIVE in frame fPage3  = YES.

             FIND FIRST tt-embalagem 
                  WHERE tt-embalagem.NumSeqItem   = i-num-seq-item  AND
                        tt-embalagem.CodItem      = c-it-codigo     AND
                        tt-embalagem.CodLote      = c-lote          AND
                        tt-embalagem.CodEmbalagem = c-cod-embalagem NO-LOCK NO-ERROR.
             IF NOT AVAIL tt-embalagem  THEN
                FOR FIRST tt-embalagem 
                      WHERE tt-embalagem.NumSeqItem   = i-num-seq-item  AND
                            tt-embalagem.CodItem      = c-it-codigo     AND
                            tt-embalagem.CodLote      = c-lote          NO-LOCK:
                    ASSIGN dt-validadeLote = tt-embalagem.DtValidadeLote.
                END. 

            CREATE tt-browse-tela.
            ASSIGN tt-browse-tela.cod-estabel        = dc-estab:SCREEN-VALUE
                   tt-browse-tela.id-docto           = DECIMAL(dc-id-docto:SCREEN-VALUE)
                   tt-browse-tela.cod-local          = dc-local:SCREEN-VALUE
                   tt-browse-tela.num-seq            = i-num-seq-item
                   tt-browse-tela.cod-embalagem      = c-cod-embalagem
                   tt-browse-tela.cod-refer          = c-cod-refer
                   tt-browse-tela.it-codigo          = c-it-codigo
                   tt-browse-tela.lote               = c-lote
                   tt-browse-tela.qtd-item           = de-qtd-item
                   tt-browse-tela.qtd-item-embalagem = de-qtd-item-embalagem
                   tt-browse-tela.qtd-etiqueta       = de-qtd-etiqueta
                   tt-browse-tela.cod-usuario        = c-seg-usuario
                   tt-browse-tela.qtd-peso-item      = de-qtd-peso-item
                   tt-browse-tela.dt-validade-lote   = IF AVAIL tt-embalagem THEN 
                                                            tt-embalagem.DtValidadeLote 
                                                       ELSE 
                                                           IF dt-validadeLote <> ? THEN
                                                               dt-validadeLote
                                                               ELSE 
                                                                   TODAY
                   tt-browse-tela.logPai             = IF AVAIL tt-embalagem THEN tt-embalagem.logPai ELSE NO
                   tt-browse-tela.ControlaEtiqueta   = IF AVAIL tt-embalagem THEN tt-embalagem.ControlaEtiqueta ELSE NO
                   tt-browse-tela.layout-etiqueta    = IF AVAIL tt-embalagem THEN tt-embalagem.CodLayoutEmbalagem ELSE ?
                   tt-browse-tela.dt-validade-lote   = IF AVAIL tt-embalagem THEN 
                                                                tt-embalagem.DtValidadeLote 
                                                       ELSE 
                                                           IF c-lote = "" THEN 
                                                               ?
                                                           ELSE
                                                               TODAY
                   tt-browse-tela.cod-ean            = IF AVAIL tt-embalagem THEN STRING(tt-embalagem.codBARRASITEM) ELSE ""
                   tt-browse-tela.cod-dun            = IF AVAIL tt-embalagem THEN STRING(tt-embalagem.codbarrasembalagem) ELSE "".
    
            FOR EACH tt-browse-tela 
                WHERE tt-browse-tela.logpai        = YES 
               /* AND   tt-browse-tela.tipo-etiqueta = 0*/:
               ASSIGN l-cont = NO.
               FOR EACH bftt-browse-tela 
                  WHERE bftt-browse-tela.it-codigo     = tt-browse-tela.it-codigo 
                  AND   bftt-browse-tela.cod-refer     = tt-browse-tela.cod-refer 
                  AND   bftt-browse-tela.lote          = tt-browse-tela.lote      
                  AND   bftt-browse-tela.logpai        = NO.
                  ASSIGN l-cont = YES.
                   IF tt-browse-tela.ControlaEtiqueta = YES AND bftt-browse-tela.ControlaEtiqueta = YES THEN  
                       ASSIGN tt-browse-tela.tipo-etiqueta   = 2
                              bftt-browse-tela.tipo-etiqueta = 1
                              tt-browse-tela.desc-tipo-etiqueta   = "Agupadora"
                              bftt-browse-tela.desc-tipo-etiqueta = "N∆o Agrupadora".  
                   IF tt-browse-tela.ControlaEtiqueta = YES AND bftt-browse-tela.ControlaEtiqueta = NO THEN  
                       ASSIGN tt-browse-tela.tipo-etiqueta = 3
                              tt-browse-tela.desc-tipo-etiqueta   = "Agupadora Pr¢pria"
                              bftt-browse-tela.desc-tipo-etiqueta = "N∆o Controlada".
               END.
               IF l-cont = NO THEN
                   ASSIGN tt-browse-tela.tipo-etiqueta        = 3
                          tt-browse-tela.desc-tipo-etiqueta   = "Agupadora Pr¢pria".
            END.
            {&OPEN-QUERY-br-dc-tela}
            APPLY "VALUE-CHANGED" TO br-dc-tela IN FRAME fPage3.
    
         END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-incluir-it
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir-it wWindow
ON CHOOSE OF bt-incluir-it IN FRAME fPage2 /* Incluir */
DO: 
    ASSIGN i-num-seq-item        = 0
           c-it-codigo           = it-item:SCREEN-VALUE
           c-lote                = it-lote:SCREEN-VALUE
           c-cod-refer           = it-referencia:SCREEN-VALUE
           c-cod-embalagem       = ""
           de-qtd-item           = 0
           de-qtd-item-embalagem = 0
           de-qtd-peso-item      = 0
           de-qtd-etiqueta       = 0.

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

    RUN bcp/bc9026a.w (INPUT 1,
                       INPUT it-estab:SCREEN-VALUE,
                       INPUT it-local:SCREEN-VALUE,
                       INPUT 0,
                       INPUT 0,
                       INPUT-OUTPUT i-num-seq-item,
                       INPUT-OUTPUT c-it-codigo,
                       INPUT-OUTPUT c-lote,
                       INPUT-OUTPUT c-cod-refer,
                       INPUT-OUTPUT c-cod-embalagem,
                       INPUT-OUTPUT de-qtd-item,
                       INPUT-OUTPUT de-qtd-peso-item,
                       INPUT-OUTPUT de-qtd-etiqueta,
                       OUTPUT de-qtd-item-embalagem).

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    IF c-it-codigo <> "" THEN DO:
       ASSIGN bt-modificar-it:SENSITIVE in frame fPage2 = YES
              bt-eliminar-it:SENSITIVE in frame fPage2  = YES.

       FIND FIRST tt-embalagem 
            WHERE tt-embalagem.NumSeqItem   = i-num-seq-item  AND
                  tt-embalagem.CodItem      = c-it-codigo     AND
                  tt-embalagem.CodLote      = c-lote          AND
                  tt-embalagem.CodEmbalagem = c-cod-embalagem NO-LOCK NO-ERROR.

       CREATE tt-browse-tela.
       ASSIGN tt-browse-tela.cod-estabel        = it-estab:SCREEN-VALUE
              tt-browse-tela.cod-local          = it-local:SCREEN-VALUE
              tt-browse-tela.num-seq            = i-num-seq-item
              tt-browse-tela.cod-embalagem      = c-cod-embalagem                                                   
              tt-browse-tela.cod-refer          = c-cod-refer
              tt-browse-tela.it-codigo          = c-it-codigo
              tt-browse-tela.lote               = c-lote
              tt-browse-tela.qtd-item           = de-qtd-item
              tt-browse-tela.qtd-item-embalagem = de-qtd-item-embalagem
              tt-browse-tela.qtd-etiqueta       = de-qtd-etiqueta
              tt-browse-tela.dt-validade-lote   = DATE(it-dt-validade-lote:SCREEN-VALUE)
              tt-browse-tela.cod-usuario        = c-seg-usuario
              tt-browse-tela.qtd-peso-item      = de-qtd-peso-item
              tt-browse-tela.dt-validade-lote   = IF AVAIL tt-embalagem THEN 
                                                            tt-embalagem.DtValidadeLote 
                                                  ELSE 
                                                      IF c-lote = "" THEN 
                                                           ?
                                                      ELSE
                                                          TODAY
              tt-browse-tela.logPai             = IF AVAIL tt-embalagem THEN tt-embalagem.logPai ELSE NO
              tt-browse-tela.ControlaEtiqueta   = IF AVAIL tt-embalagem THEN tt-embalagem.ControlaEtiqueta ELSE NO
              tt-browse-tela.layout-etiqueta    = IF AVAIL tt-embalagem THEN tt-embalagem.CodLayoutEmbalagem ELSE ?
              tt-browse-tela.cod-ean            = IF AVAIL tt-embalagem THEN STRING(tt-embalagem.codBARRASITEM) ELSE ""
              tt-browse-tela.cod-dun            = IF AVAIL tt-embalagem THEN STRING(tt-embalagem.codbarrasembalagem) ELSE "".

       DEF VAR l-cont AS LOGICAL NO-UNDO.

       FOR EACH tt-browse-tela 
            WHERE tt-browse-tela.logpai        = YES 
            /*AND   tt-browse-tela.tipo-etiqueta = 0*/:
           ASSIGN l-cont = NO.
           FOR EACH bftt-browse-tela 
              WHERE bftt-browse-tela.it-codigo     = tt-browse-tela.it-codigo 
              AND   bftt-browse-tela.cod-refer     = tt-browse-tela.cod-refer 
              AND   bftt-browse-tela.lote          = tt-browse-tela.lote      
              AND   bftt-browse-tela.logpai        = NO                      
            /*AND   bftt-browse-tela.tipo-etiqueta = 0*/.
              ASSIGN l-cont = YES.
               IF tt-browse-tela.ControlaEtiqueta = YES AND bftt-browse-tela.ControlaEtiqueta = YES THEN  
                   ASSIGN tt-browse-tela.tipo-etiqueta   = 2
                          bftt-browse-tela.tipo-etiqueta = 1
                          tt-browse-tela.desc-tipo-etiqueta   = "Agupadora"
                          bftt-browse-tela.desc-tipo-etiqueta = "N∆o Agrupadora".  
               IF tt-browse-tela.ControlaEtiqueta = YES AND bftt-browse-tela.ControlaEtiqueta = NO THEN  
                   ASSIGN tt-browse-tela.tipo-etiqueta = 3
                          tt-browse-tela.desc-tipo-etiqueta   = "Agupadora Pr¢pria"
                          bftt-browse-tela.desc-tipo-etiqueta = "N∆o Controlada".
           END.
           IF l-cont = NO THEN
               ASSIGN tt-browse-tela.tipo-etiqueta        = 3
                      tt-browse-tela.desc-tipo-etiqueta   = "Agupadora Pr¢pria".
       END.

        {&OPEN-QUERY-br-it-tela}
        APPLY "VALUE-CHANGED" TO br-it-tela IN FRAME fPage2.
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-incluir-op
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir-op wWindow
ON CHOOSE OF bt-incluir-op IN FRAME fPage1 /* Incluir */
DO:
    ASSIGN i-num-seq-item   = 0
           c-it-codigo      = c-item-aux
           c-lote           = op-lote:SCREEN-VALUE
           c-cod-refer      = op-referencia:SCREEN-VALUE
           c-cod-embalagem  = ""
           de-qtd-item      = 0
           de-qtd-peso-item = 0
           de-qtd-etiqueta  = 0.

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

    RUN bcp/bc9026a.w (INPUT 1,
                       INPUT c-estab-aux,           
                       INPUT op-local:SCREEN-VALUE,
                       INPUT 0,
                       INPUT 0,
                       INPUT-OUTPUT i-num-seq-item,
                       INPUT-OUTPUT c-it-codigo,
                       INPUT-OUTPUT c-lote,
                       INPUT-OUTPUT c-cod-refer,
                       INPUT-OUTPUT c-cod-embalagem,
                       INPUT-OUTPUT de-qtd-item,
                       INPUT-OUTPUT de-qtd-peso-item,
                       INPUT-OUTPUT de-qtd-etiqueta,
                       OUTPUT de-qtd-item-embalagem).

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

     IF c-it-codigo <> "" THEN DO:
        ASSIGN bt-modificar-op:SENSITIVE in frame fPage1 = YES
               bt-eliminar-op:SENSITIVE in frame fPage1  = YES.

        FIND FIRST tt-embalagem 
             WHERE tt-embalagem.CodEmbalagem = c-cod-embalagem NO-LOCK NO-ERROR.

        CREATE tt-browse-tela.
        ASSIGN tt-browse-tela.cod-estabel        = c-estab-aux
               tt-browse-tela.cod-local          = op-local:SCREEN-VALUE
               tt-browse-tela.num-seq            = i-num-seq-item
               tt-browse-tela.cod-embalagem      = c-cod-embalagem                                                   
               tt-browse-tela.cod-refer          = c-cod-refer
               tt-browse-tela.it-codigo          = c-it-codigo
               tt-browse-tela.lote               = c-lote
               tt-browse-tela.qtd-item           = de-qtd-item
               tt-browse-tela.qtd-item-embalagem = de-qtd-item-embalagem
               tt-browse-tela.qtd-etiqueta       = de-qtd-etiqueta
               tt-browse-tela.dt-validade-lote   = DATE(op-dt-validade-lote:SCREEN-VALUE)
               tt-browse-tela.cod-usuario        = c-seg-usuario
               tt-browse-tela.qtd-peso-item      = de-qtd-peso-item
               tt-browse-tela.nr-ord-produ       = INTEGER(op-ordem:SCREEN-VALUE)
               tt-browse-tela.dt-validade-lote   = DATE(op-dt-validade-lote:SCREEN-VALUE)
               tt-browse-tela.logPai             = IF AVAIL tt-embalagem THEN tt-embalagem.logPai ELSE NO
               tt-browse-tela.ControlaEtiqueta   = IF AVAIL tt-embalagem THEN tt-embalagem.ControlaEtiqueta ELSE NO
               tt-browse-tela.layout-etiqueta    = IF AVAIL tt-embalagem THEN tt-embalagem.CodLayoutEmbalagem ELSE ?
               tt-browse-tela.cod-ean            = IF AVAIL tt-embalagem THEN STRING(tt-embalagem.codBARRASITEM) ELSE ""
               tt-browse-tela.cod-dun            = IF AVAIL tt-embalagem THEN STRING(tt-embalagem.codbarrasembalagem) ELSE "".

        DEF VAR l-cont AS LOGICAL NO-UNDO.

        FOR EACH tt-browse-tela 
            WHERE tt-browse-tela.logpai        = YES 
            /*AND   tt-browse-tela.tipo-etiqueta = 0*/:
           ASSIGN l-cont = NO.
           FOR EACH bftt-browse-tela 
              WHERE bftt-browse-tela.it-codigo     = tt-browse-tela.it-codigo 
              AND   bftt-browse-tela.cod-refer     = tt-browse-tela.cod-refer 
              AND   bftt-browse-tela.lote          = tt-browse-tela.lote      
              AND   bftt-browse-tela.logpai        = NO                      
            /*AND   bftt-browse-tela.tipo-etiqueta = 0*/.
              ASSIGN l-cont = YES.
               IF tt-browse-tela.ControlaEtiqueta = YES AND bftt-browse-tela.ControlaEtiqueta = YES THEN  
                   ASSIGN tt-browse-tela.tipo-etiqueta   = 2
                          bftt-browse-tela.tipo-etiqueta = 1
                          tt-browse-tela.desc-tipo-etiqueta   = "Agupadora"
                          bftt-browse-tela.desc-tipo-etiqueta = "N∆o Agrupadora".  
               IF tt-browse-tela.ControlaEtiqueta = YES AND bftt-browse-tela.ControlaEtiqueta = NO THEN  
                   ASSIGN tt-browse-tela.tipo-etiqueta = 3
                          tt-browse-tela.desc-tipo-etiqueta   = "Agupadora Pr¢pria"
                          bftt-browse-tela.desc-tipo-etiqueta = "N∆o Controlada".
           END.
           IF l-cont = NO THEN
               ASSIGN tt-browse-tela.tipo-etiqueta        = 3
                      tt-browse-tela.desc-tipo-etiqueta   = "Agupadora Pr¢pria".
        END.

        {&OPEN-QUERY-br-op-tela}
        APPLY "VALUE-CHANGED" TO br-op-tela IN FRAME fPage1.
     END.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME bt-incluir-rf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir-rf wWindow
ON CHOOSE OF bt-incluir-rf IN FRAME fPage4 /* Incluir */
DO:
    DEF VAR l-cont AS LOGICAL NO-UNDO.
    if br-rf-tela:num-selected-rows > 0 then DO:
        if avail tt-browse-tela then do:
            get current br-rf-tela.
            
            ASSIGN i-num-seq-item   = tt-browse-tela.num-seq
                   c-it-codigo      = tt-browse-tela.it-codigo
                   c-lote           = tt-browse-tela.lote
                   c-cod-refer      = tt-browse-tela.cod-refer
                   c-cod-embalagem  = tt-browse-tela.cod-embalagem.

            ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

            RUN bcp/bc9026a.w (INPUT 4,
                               INPUT rf-estab,
                               INPUT rf-local,
                               INPUT tt-browse-tela.id-docto,
                               INPUT rf-numero:SCREEN-VALUE IN FRAME fPage4,
                               INPUT-OUTPUT i-num-seq-item,
                               INPUT-OUTPUT c-it-codigo,
                               INPUT-OUTPUT c-lote,
                               INPUT-OUTPUT c-cod-refer,
                               INPUT-OUTPUT c-cod-embalagem,
                               INPUT-OUTPUT de-qtd-item,
                               INPUT-OUTPUT de-qtd-peso-item,
                               INPUT-OUTPUT de-qtd-etiqueta,
                               OUTPUT de-qtd-item-embalagem).

            ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    
            IF c-it-codigo <> "" THEN DO:
                ASSIGN bt-modificar-rf:SENSITIVE in frame fPage4 = YES
                       bt-eliminar-rf:SENSITIVE in frame fPage4  = YES.
        
                 FIND FIRST tt-embalagem 
                      WHERE tt-embalagem.NumSeqItem   = i-num-seq-item  AND
                            tt-embalagem.CodItem      = c-it-codigo     AND
                            tt-embalagem.CodLote      = c-lote          AND
                            tt-embalagem.CodEmbalagem = c-cod-embalagem NO-LOCK NO-ERROR.
                 IF NOT AVAIL tt-embalagem  THEN
                    FOR FIRST tt-embalagem 
                          WHERE tt-embalagem.NumSeqItem   = i-num-seq-item  AND
                                tt-embalagem.CodItem      = c-it-codigo     AND
                                tt-embalagem.CodLote      = c-lote          NO-LOCK:
                        ASSIGN dt-validadeLote = tt-embalagem.DtValidadeLote.
                    END.   
        
                CREATE tt-browse-tela.
                ASSIGN tt-browse-tela.cod-estabel        = rf-estab
                       tt-browse-tela.cod-local          = rf-local
                       tt-browse-tela.num-seq            = i-num-seq-item
                       tt-browse-tela.cod-embalagem      = c-cod-embalagem                                                   
                       tt-browse-tela.cod-refer          = c-cod-refer
                       tt-browse-tela.it-codigo          = c-it-codigo
                       tt-browse-tela.lote               = c-lote
                       tt-browse-tela.qtd-item           = de-qtd-item
                       tt-browse-tela.qtd-item-embalagem = de-qtd-item-embalagem
                       tt-browse-tela.qtd-etiqueta       = de-qtd-etiqueta
                       tt-browse-tela.cod-usuario        = c-seg-usuario
                       tt-browse-tela.qtd-peso-item      = de-qtd-peso-item
                       tt-browse-tela.dt-validade-lote   = IF AVAIL tt-embalagem THEN 
                                                            tt-embalagem.DtValidadeLote 
                                                        ELSE 
                                                           IF dt-validadeLote <> ? THEN
                                                               dt-validadeLote
                                                               ELSE 
                                                                   TODAY
                       tt-browse-tela.logPai             = IF AVAIL tt-embalagem THEN tt-embalagem.logPai ELSE NO
                       tt-browse-tela.ControlaEtiqueta   = IF AVAIL tt-embalagem THEN tt-embalagem.ControlaEtiqueta ELSE NO
                       tt-browse-tela.layout-etiqueta    = IF AVAIL tt-embalagem THEN tt-embalagem.CodLayoutEmbalagem ELSE ?
                       tt-browse-tela.cod-ean            = IF AVAIL tt-embalagem THEN STRING(tt-embalagem.codBARRASITEM) ELSE ""
                       tt-browse-tela.cod-dun            = IF AVAIL tt-embalagem THEN STRING(tt-embalagem.codbarrasembalagem) ELSE "".
        
        
                FOR EACH tt-browse-tela 
                   WHERE tt-browse-tela.logpai        = YES 
                   /*AND   tt-browse-tela.tipo-etiqueta = 0*/:
                  ASSIGN l-cont = NO.
                  FOR EACH bftt-browse-tela 
                     WHERE bftt-browse-tela.it-codigo     = tt-browse-tela.it-codigo 
                     AND   bftt-browse-tela.cod-refer     = tt-browse-tela.cod-refer 
                     AND   bftt-browse-tela.lote          = tt-browse-tela.lote      
                     AND   bftt-browse-tela.logpai        = NO                      
                   /*AND   bftt-browse-tela.tipo-etiqueta = 0*/.
                     ASSIGN l-cont = YES.
                      IF tt-browse-tela.ControlaEtiqueta = YES AND bftt-browse-tela.ControlaEtiqueta = YES THEN  
                          ASSIGN tt-browse-tela.tipo-etiqueta   = 2
                                 bftt-browse-tela.tipo-etiqueta = 1
                                 tt-browse-tela.desc-tipo-etiqueta   = "Agupadora"
                                 bftt-browse-tela.desc-tipo-etiqueta = "N∆o Agrupadora".  
                      IF tt-browse-tela.ControlaEtiqueta = YES AND bftt-browse-tela.ControlaEtiqueta = NO THEN  
                          ASSIGN tt-browse-tela.tipo-etiqueta = 3
                                 tt-browse-tela.desc-tipo-etiqueta   = "Agupadora Pr¢pria"
                                 bftt-browse-tela.desc-tipo-etiqueta = "N∆o Controlada".
                  END.
                  IF l-cont = NO THEN
                      ASSIGN tt-browse-tela.tipo-etiqueta        = 3
                             tt-browse-tela.desc-tipo-etiqueta   = "Agupadora Pr¢pria".
                END.
        
              {&OPEN-QUERY-br-rf-tela}
                  
            END.
        end.
    END.
    ELSE DO:
    
        ASSIGN i-num-seq-item   = 0
               c-it-codigo      = ""
               c-lote           = ""
               c-cod-refer      = ""
               c-cod-embalagem  = ""
               de-qtd-item      = 0
               de-qtd-peso-item = 0
               de-qtd-etiqueta  = 0.
    
        ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    
        RUN bcp/bc9026a.w (INPUT 2,
                           INPUT rf-estab,
                           INPUT rf-local,
                           INPUT 0,
                           INPUT rf-numero:SCREEN-VALUE IN FRAME fPage4,
                           INPUT-OUTPUT i-num-seq-item,
                           INPUT-OUTPUT c-it-codigo,
                           INPUT-OUTPUT c-lote,
                           INPUT-OUTPUT c-cod-refer,
                           INPUT-OUTPUT c-cod-embalagem,
                           INPUT-OUTPUT de-qtd-item,
                           INPUT-OUTPUT de-qtd-peso-item,
                           INPUT-OUTPUT de-qtd-etiqueta,
                           OUTPUT de-qtd-item-embalagem).
    
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    
        IF c-it-codigo <> "" THEN DO:
            ASSIGN bt-modificar-rf:SENSITIVE in frame fPage4 = YES
                   bt-eliminar-rf:SENSITIVE in frame fPage4  = YES.

             FIND FIRST tt-embalagem 
                  WHERE tt-embalagem.NumSeqItem   = i-num-seq-item  AND
                        tt-embalagem.CodItem      = c-it-codigo     AND
                        tt-embalagem.CodLote      = c-lote          AND
                        tt-embalagem.CodEmbalagem = c-cod-embalagem NO-LOCK NO-ERROR.
             IF NOT AVAIL tt-embalagem  THEN
                FOR FIRST tt-embalagem 
                      WHERE tt-embalagem.NumSeqItem   = i-num-seq-item  AND
                            tt-embalagem.CodItem      = c-it-codigo     AND
                            tt-embalagem.CodLote      = c-lote          NO-LOCK:
                    ASSIGN dt-validadeLote = tt-embalagem.DtValidadeLote.
                END.       

            CREATE tt-browse-tela.
            ASSIGN tt-browse-tela.cod-estabel        = rf-estab
                   tt-browse-tela.cod-local          = rf-local
                   tt-browse-tela.num-seq            = i-num-seq-item
                   tt-browse-tela.cod-embalagem      = c-cod-embalagem                                                   
                   tt-browse-tela.cod-refer          = c-cod-refer
                   tt-browse-tela.it-codigo          = c-it-codigo
                   tt-browse-tela.lote               = c-lote
                   tt-browse-tela.qtd-item           = de-qtd-item
                   tt-browse-tela.qtd-item-embalagem = de-qtd-item-embalagem
                   tt-browse-tela.qtd-etiqueta       = de-qtd-etiqueta
                   tt-browse-tela.cod-usuario        = c-seg-usuario
                   tt-browse-tela.qtd-peso-item      = de-qtd-peso-item
                   tt-browse-tela.dt-validade-lote   = IF AVAIL tt-embalagem THEN 
                                                            tt-embalagem.DtValidadeLote 
                                                        ELSE 
                                                           IF dt-validadeLote <> ? THEN
                                                               dt-validadeLote
                                                               ELSE 
                                                                   TODAY
                   tt-browse-tela.logPai             = IF AVAIL tt-embalagem THEN tt-embalagem.logPai ELSE NO
                   tt-browse-tela.ControlaEtiqueta   = IF AVAIL tt-embalagem THEN tt-embalagem.ControlaEtiqueta ELSE NO
                   tt-browse-tela.layout-etiqueta    = IF AVAIL tt-embalagem THEN tt-embalagem.CodLayoutEmbalagem ELSE ?
                   tt-browse-tela.cod-ean            = IF AVAIL tt-embalagem THEN STRING(tt-embalagem.codBARRASITEM) ELSE ""
                   tt-browse-tela.cod-dun            = IF AVAIL tt-embalagem THEN STRING(tt-embalagem.codbarrasembalagem) ELSE "".
   
    
            FOR EACH tt-browse-tela 
               WHERE tt-browse-tela.logpai        = YES 
               /*AND   tt-browse-tela.tipo-etiqueta = 0*/:
              ASSIGN l-cont = NO.
              FOR EACH bftt-browse-tela 
                 WHERE bftt-browse-tela.it-codigo     = tt-browse-tela.it-codigo 
                 AND   bftt-browse-tela.cod-refer     = tt-browse-tela.cod-refer 
                 AND   bftt-browse-tela.lote          = tt-browse-tela.lote      
                 AND   bftt-browse-tela.logpai        = NO                      
               /*AND   bftt-browse-tela.tipo-etiqueta = 0*/.
                 ASSIGN l-cont = YES.
                  IF tt-browse-tela.ControlaEtiqueta = YES AND bftt-browse-tela.ControlaEtiqueta = YES THEN  
                      ASSIGN tt-browse-tela.tipo-etiqueta   = 2
                             bftt-browse-tela.tipo-etiqueta = 1
                             tt-browse-tela.desc-tipo-etiqueta   = "Agupadora"
                             bftt-browse-tela.desc-tipo-etiqueta = "N∆o Agrupadora".  
                  IF tt-browse-tela.ControlaEtiqueta = YES AND bftt-browse-tela.ControlaEtiqueta = NO THEN  
                      ASSIGN tt-browse-tela.tipo-etiqueta = 3
                             tt-browse-tela.desc-tipo-etiqueta   = "Agupadora Pr¢pria"
                             bftt-browse-tela.desc-tipo-etiqueta = "N∆o Controlada".
              END.
              IF l-cont = NO THEN
                  ASSIGN tt-browse-tela.tipo-etiqueta        = 3
                         tt-browse-tela.desc-tipo-etiqueta   = "Agupadora Pr¢pria".
            END.
    
          {&OPEN-QUERY-br-rf-tela}
              
        END.
    END.
    APPLY "VALUE-CHANGED" TO br-rf-tela IN FRAME fPage4.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-it-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-it-executar wWindow
ON CHOOSE OF bt-it-executar IN FRAME fPage2
DO:
    /* Tela de acompanhamento */
    run utp/ut-acomp.p persistent set h-acomp. 
    {utp/ut-liter.i Processando... *}
    run pi-inicializar in h-acomp ( Return-value ). 
    {utp/ut-liter.i Buscando_informaá‰es_das_etiquetas... *}
    run pi-acompanhar in h-acomp ( Return-value ). 
    run pi-finalizar in h-acomp.                   
    IF VALID-HANDLE (h-acomp) THEN DELETE OBJECT h-acomp.

    ASSIGN it-item
           it-desc-item
           it-estab
           it-local
           it-lote
           it-referencia
           it-dep-saida
           it-loc-saida
           it-dt-validade-lote
           it-quantidade.
    FOR EACH tt-erro:
        DELETE tt-erro.
    END.

    FOR EACH rowerrors:
        DELETE rowerrors.
    END.

    EMPTY TEMP-TABLE tt-browse-tela.
    {&OPEN-QUERY-br-it-tela}

    RUN PI-VALIDA-CAMPOS-IT IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK" THEN UNDO, LEAVE.

    RUN initializeDBOs.

    /* Busca data de validade */
    RUN pi-buscadatavalidade(INPUT it-estab:SCREEN-VALUE,           
                             INPUT it-local:SCREEN-VALUE, 
                             INPUT it-item:SCREEN-VALUE,            
                             INPUT it-lote:SCREEN-VALUE,            
                             INPUT it-referencia:SCREEN-VALUE,      
                             INPUT it-loc-saida:SCREEN-VALUE,      
                             OUTPUT it-dt-validade-lote).

    /* Busca as informaá‰es */
    RUN pi-busca-informacao-wms (INPUT it-estab:SCREEN-VALUE,              
                                 INPUT it-local:SCREEN-VALUE,              
                                 INPUT " ",                                
                                 INPUT it-item:SCREEN-VALUE,               
                                 INPUT 0,                                  
                                 INPUT 0,                                  
                                 INPUT it-referencia:SCREEN-VALUE,         
                                 INPUT it-lote:SCREEN-VALUE,               
                                 INPUT it-quantidade:SCREEN-VALUE,         
                                 INPUT it-dt-validade-lote:SCREEN-VALUE,   
                                 INPUT 2 /*Item*/ ).                       
    {&OPEN-QUERY-br-it-tela}

    if num-results("br-it-tela":U) = 0 THEN
        DISABLE bt-modificar-it
                bt-eliminar-it
                WITH FRAME fPage2.
    ELSE
       ENABLE bt-modificar-it
              bt-eliminar-it
              WITH FRAME fPage2.

    ENABLE bt-incluir-it WITH FRAME fPage2.

    /* Tela de acompanhamento */ 
    run utp/ut-acomp.p persistent set h-acomp. 
    {utp/ut-liter.i Processando... *}
    run pi-inicializar in h-acomp ( Return-value ). 
    {utp/ut-liter.i TÇrmino_da_busca_de_informaá‰es_das_etiquetas... *}
    run pi-acompanhar in h-acomp ( Return-value ). 
    run pi-finalizar in h-acomp. 

    IF VALID-HANDLE (h-acomp) THEN DELETE OBJECT h-acomp.

    RUN BeforeDestroyInterface.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME bt-modificar-dc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-modificar-dc wWindow
ON CHOOSE OF bt-modificar-dc IN FRAME fPage3 /* Modificar */
DO:
     if br-dc-tela:num-selected-rows > 0 then DO:
        if avail tt-browse-tela then do:
            get current br-dc-tela.

            ASSIGN i-num-seq-item        = tt-browse-tela.num-seq
                   c-it-codigo           = tt-browse-tela.it-codigo
                   c-lote                = tt-browse-tela.lote
                   c-cod-refer           = tt-browse-tela.cod-refer
                   c-cod-embalagem       = tt-browse-tela.cod-embalagem
                   de-qtd-item           = tt-browse-tela.qtd-item
                   de-qtd-item-embalagem = tt-browse-tela.qtd-item-embalagem
                   de-qtd-peso-item      = tt-browse-tela.qtd-peso-item
                   de-qtd-etiqueta       = tt-browse-tela.qtd-etiqueta.

            ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

            RUN bcp/bc9026a.w (INPUT 3,
                               INPUT dc-estab:SCREEN-VALUE,
                               INPUT dc-local:SCREEN-VALUE,
                               INPUT tt-browse-tela.id-docto,
                               INPUT dc-numero:SCREEN-VALUE,
                               INPUT-OUTPUT i-num-seq-item, 
                               INPUT-OUTPUT c-it-codigo,
                               INPUT-OUTPUT c-lote,
                               INPUT-OUTPUT c-cod-refer,
                               INPUT-OUTPUT c-cod-embalagem,
                               INPUT-OUTPUT de-qtd-item,
                               INPUT-OUTPUT de-qtd-peso-item,
                               INPUT-OUTPUT de-qtd-etiqueta,
                               OUTPUT de-qtd-item-embalagem).

            ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

            IF c-it-codigo <> "" THEN DO:
                ASSIGN tt-browse-tela.num-seq            = i-num-seq-item
                       tt-browse-tela.cod-embalagem            = c-cod-embalagem
                       tt-browse-tela.cod-refer          = c-cod-refer
                       tt-browse-tela.it-codigo          = c-it-codigo
                       tt-browse-tela.lote               = c-lote
                       tt-browse-tela.qtd-item           = de-qtd-item
                       tt-browse-tela.qtd-item-embalagem = de-qtd-item-embalagem
                       tt-browse-tela.qtd-etiqueta       = de-qtd-etiqueta
                       tt-browse-tela.cod-usuario        = c-seg-usuario
                       tt-browse-tela.qtd-peso-item      = de-qtd-peso-item.

                {&OPEN-QUERY-br-dc-tela}
            END.
        end.
     END.
     APPLY "VALUE-CHANGED" TO br-dc-tela IN FRAME fPage3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-modificar-it
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-modificar-it wWindow
ON CHOOSE OF bt-modificar-it IN FRAME fPage2 /* Modificar */
DO:    
    if br-it-tela:num-selected-rows > 0 then DO:
        if avail tt-browse-tela then do:
            get current br-it-tela.

            ASSIGN i-num-seq-item        = tt-browse-tela.num-seq
                   c-it-codigo           = it-item:SCREEN-VALUE
                   c-lote                = it-lote:SCREEN-VALUE
                   c-cod-refer           = it-referencia:SCREEN-VALUE
                   c-cod-embalagem       = tt-browse-tela.cod-embalagem
                   de-qtd-item           = tt-browse-tela.qtd-item
                   de-qtd-item-embalagem = tt-browse-tela.qtd-item-embalagem
                   de-qtd-peso-item      = tt-browse-tela.qtd-peso-item
                   de-qtd-etiqueta       = tt-browse-tela.qtd-etiqueta.

            ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

            RUN bcp/bc9026a.w (INPUT 3,
                               INPUT it-estab:SCREEN-VALUE,
                               INPUT it-local:SCREEN-VALUE,
                               INPUT tt-browse-tela.id-docto,
                               INPUT 0,
                               INPUT-OUTPUT i-num-seq-item,
                               INPUT-OUTPUT c-it-codigo,
                               INPUT-OUTPUT c-lote,
                               INPUT-OUTPUT c-cod-refer,
                               INPUT-OUTPUT c-cod-embalagem,
                               INPUT-OUTPUT de-qtd-item,
                               INPUT-OUTPUT de-qtd-peso-item,
                               INPUT-OUTPUT de-qtd-etiqueta,
                               OUTPUT de-qtd-item-embalagem).

            ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

            IF c-it-codigo <> "" THEN DO:
               ASSIGN tt-browse-tela.num-seq            = i-num-seq-item
                      tt-browse-tela.cod-embalagem            = c-cod-embalagem                                                   
                      tt-browse-tela.cod-refer          = c-cod-refer
                      tt-browse-tela.it-codigo          = c-it-codigo
                      tt-browse-tela.lote               = c-lote
                      tt-browse-tela.qtd-item           = de-qtd-item
                      tt-browse-tela.qtd-item-embalagem = de-qtd-item-embalagem
                      tt-browse-tela.qtd-etiqueta       = de-qtd-etiqueta
                      /*tt-browse-tela.dt-validade-lote   = DATE(it-dt-validade-lote:SCREEN-VALUE)*/
                      tt-browse-tela.cod-usuario        = c-seg-usuario
                      tt-browse-tela.qtd-peso-item      = de-qtd-peso-item.

                {&OPEN-QUERY-br-it-tela}
            END.
        end.
    END.
    APPLY "VALUE-CHANGED" TO br-it-tela IN FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-modificar-op
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-modificar-op wWindow
ON CHOOSE OF bt-modificar-op IN FRAME fPage1 /* Modificar */
DO:
    if br-op-tela:num-selected-rows > 0 then DO:
        if avail tt-browse-tela then do:
            get current br-op-tela.

            ASSIGN i-num-seq-item   = tt-browse-tela.num-seq
                   c-it-codigo      = c-item-aux
                   c-lote           = op-lote:SCREEN-VALUE
                   c-cod-refer      = op-referencia:SCREEN-VALUE
                   c-cod-embalagem  = tt-browse-tela.cod-embalagem
                   de-qtd-item      = tt-browse-tela.qtd-item
                   de-qtd-peso-item = tt-browse-tela.qtd-peso-item
                   de-qtd-etiqueta  = tt-browse-tela.qtd-etiqueta.

            ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

            RUN bcp/bc9026a.w (INPUT 3,
                               INPUT c-estab-aux,           
                               INPUT op-local:SCREEN-VALUE,
                               INPUT tt-browse-tela.id-docto,
                               INPUT 0,
                               INPUT-OUTPUT i-num-seq-item,
                               INPUT-OUTPUT c-it-codigo,
                               INPUT-OUTPUT c-lote,
                               INPUT-OUTPUT c-cod-refer,
                               INPUT-OUTPUT c-cod-embalagem,
                               INPUT-OUTPUT de-qtd-item,
                               INPUT-OUTPUT de-qtd-peso-item,
                               INPUT-OUTPUT de-qtd-etiqueta,
                               OUTPUT de-qtd-item-embalagem).

            ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

             IF c-it-codigo <> "" THEN DO:
                ASSIGN bt-modificar-op:SENSITIVE in frame fPage1 = YES
                       bt-eliminar-op:SENSITIVE in frame fPage1  = YES.

                ASSIGN tt-browse-tela.num-seq            = i-num-seq-item
                       tt-browse-tela.cod-embalagem            = c-cod-embalagem                                                   
                       tt-browse-tela.cod-refer          = c-cod-refer
                       tt-browse-tela.it-codigo          = c-it-codigo
                       tt-browse-tela.lote               = c-lote
                       tt-browse-tela.qtd-item           = de-qtd-item
                       tt-browse-tela.qtd-item-embalagem = de-qtd-item-embalagem
                       tt-browse-tela.qtd-etiqueta       = de-qtd-etiqueta
                       /*tt-browse-tela.dt-validade-lote   = DATE(op-dt-validade-lote:SCREEN-VALUE)*/
                       tt-browse-tela.cod-usuario        = c-seg-usuario
                       tt-browse-tela.qtd-peso-item      = de-qtd-peso-item.

                {&OPEN-QUERY-br-op-tela}
             END.
        end.
    END.
    APPLY "VALUE-CHANGED" TO br-op-tela IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME bt-modificar-rf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-modificar-rf wWindow
ON CHOOSE OF bt-modificar-rf IN FRAME fPage4 /* Modificar */
DO:
    if br-rf-tela:num-selected-rows > 0 then DO:
        if avail tt-browse-tela then do:
            get current br-rf-tela.
            
            ASSIGN i-num-seq-item   = tt-browse-tela.num-seq
                   c-it-codigo      = tt-browse-tela.it-codigo
                   c-lote           = tt-browse-tela.lote
                   c-cod-refer      = tt-browse-tela.cod-refer
                   c-cod-embalagem  = tt-browse-tela.cod-embalagem
                   de-qtd-item      = tt-browse-tela.qtd-item
                   de-qtd-peso-item = tt-browse-tela.qtd-peso-item
                   de-qtd-etiqueta  = tt-browse-tela.qtd-etiqueta.

            ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

            RUN bcp/bc9026a.w (INPUT 3,
                               INPUT rf-estab,
                               INPUT rf-local,
                               INPUT tt-browse-tela.id-docto,
                               INPUT rf-numero:SCREEN-VALUE IN FRAME fPage4,
                               INPUT-OUTPUT i-num-seq-item,
                               INPUT-OUTPUT c-it-codigo,
                               INPUT-OUTPUT c-lote,
                               INPUT-OUTPUT c-cod-refer,
                               INPUT-OUTPUT c-cod-embalagem,
                               INPUT-OUTPUT de-qtd-item,
                               INPUT-OUTPUT de-qtd-peso-item,
                               INPUT-OUTPUT de-qtd-etiqueta,
                               OUTPUT de-qtd-item-embalagem).

            ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

            IF c-it-codigo <> "" THEN DO:
                 ASSIGN tt-browse-tela.cod-embalagem            = c-cod-embalagem
                        tt-browse-tela.qtd-item           = de-qtd-item
                        tt-browse-tela.qtd-item-embalagem = de-qtd-item-embalagem
                        tt-browse-tela.qtd-etiqueta       = de-qtd-etiqueta
                        tt-browse-tela.cod-usuario        = c-seg-usuario
                        tt-browse-tela.qtd-peso-item      = de-qtd-peso-item.

                {&OPEN-QUERY-br-rf-tela}
            END.
        end.
    END.
    APPLY "VALUE-CHANGED" TO br-rf-tela IN FRAME fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-op-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-op-executar wWindow
ON CHOOSE OF bt-op-executar IN FRAME fPage1 /* Button 1 */
DO:
    /* Tela de acompanhamento */

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp. 
    {utp/ut-liter.i Processando... *}
    RUN pi-inicializar IN h-acomp ( Return-value ). 
    {utp/ut-liter.i Buscando_informaá‰es_das_etiquetas... *}
    RUN pi-acompanhar IN h-acomp ( Return-value ). 
    RUN pi-finalizar IN h-acomp.                   
    IF VALID-HANDLE (h-acomp) THEN DELETE OBJECT h-acomp.

    ASSIGN op-ordem
           op-local
           op-lote
           op-referencia
           op-dt-validade-lote
           op-dep-saida
           op-loc-saida              
           op-quantidade.

    FOR EACH tt-erro:
        DELETE tt-erro.
    END.

    FOR EACH rowerrors:
        DELETE rowerrors.
    END.

    EMPTY TEMP-TABLE tt-browse-tela.
    {&OPEN-QUERY-br-op-tela}

    RUN PI-VALIDA-CAMPOS-OP IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK" THEN UNDO, LEAVE.

    RUN initializeDBOs.

    /* Busca data de validade */
    RUN pi-buscadatavalidade (INPUT c-estab-aux,           
                              INPUT op-local:SCREEN-VALUE, 
                              INPUT c-item-aux,            
                              INPUT op-lote:SCREEN-VALUE,            
                              INPUT op-referencia:SCREEN-VALUE,      
                              INPUT op-loc-saida:SCREEN-VALUE,      
                              OUTPUT op-dt-validade-lote).

    /* Busca as informaá‰es */
    RUN pi-busca-informacao-wms (INPUT c-estab-aux,
                                 INPUT op-local:SCREEN-VALUE,
                                 INPUT " ", 
                                 INPUT c-item-aux,
                                 INPUT op-ordem:SCREEN-VALUE,
                                 INPUT 0,
                                 INPUT op-referencia:SCREEN-VALUE,      
                                 INPUT op-lote:SCREEN-VALUE,            
                                 INPUT op-quantidade:SCREEN-VALUE,      
                                 INPUT op-dt-validade-lote:SCREEN-VALUE,
                                 INPUT 1 /*Ordem Producao*/ ).

    {&OPEN-QUERY-br-op-tela}

    if num-results("br-op-tela":U) = 0 THEN
        DISABLE bt-modificar-op
                bt-eliminar-op
                WITH FRAME fPage1.
    ELSE
       ENABLE bt-modificar-op
              bt-eliminar-op
              WITH FRAME fPage1.

    ENABLE bt-incluir-op WITH FRAME fPage1.

    /* Tela de acompanhamento */ 
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp. 
    {utp/ut-liter.i Processando... *}
    RUN pi-inicializar IN h-acomp ( RETURN-VALUE ). 
    {utp/ut-liter.i TÇrmino_da_busca_de_informaá‰es_das_etiquetas... *}
    RUN pi-acompanhar IN h-acomp ( RETURN-VALUE ). 
    RUN pi-finalizar IN h-acomp. 

    IF VALID-HANDLE (h-acomp) THEN DELETE OBJECT h-acomp.

    RUN BeforeDestroyInterface.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME bt-rf-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-rf-executar wWindow
ON CHOOSE OF bt-rf-executar IN FRAME fPage4
DO:
    /* Tela de acompanhamento */
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp. 
    {utp/ut-liter.i Processando... *}
    RUN pi-inicializar IN h-acomp ( Return-value ). 
    {utp/ut-liter.i Buscando_informaá‰es_das_etiquetas... *}
    RUN pi-acompanhar IN h-acomp ( Return-value ). 
    RUN pi-finalizar IN h-acomp.                   
    IF VALID-HANDLE (h-acomp) THEN DELETE OBJECT h-acomp.

    ASSIGN rf-numero
           rf-serie
           cb-rf-tp-nota
           rf-emitente
           rf-desc-emitente
           rf-estab
           rf-local.

    FOR EACH tt-erro:
        DELETE tt-erro.
    END.

    FOR EACH rowerrors:
        DELETE rowerrors.
    END.
    
    EMPTY TEMP-TABLE tt-browse-tela.
    {&OPEN-QUERY-br-rf-tela}

    ASSIGN i-tp-nota = {ininc/i01in089.i 06  cb-rf-tp-nota}.

    RUN PI-VALIDA-CAMPOS-RF IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK" THEN UNDO, LEAVE.

    RUN initializeDBOs.

    /* Busca as informaá‰es */
    RUN pi-busca-informacao-rf.             
    {&OPEN-QUERY-br-rf-tela}

    if num-results("br-rf-tela":U) = 0 THEN
        DISABLE bt-modificar-rf
                bt-eliminar-rf
                WITH FRAME fPage4.
    ELSE
       ENABLE bt-modificar-rf
              bt-eliminar-rf
              WITH FRAME fPage4.

    ENABLE bt-incluir-rf WITH FRAME fPage4.

    /* Tela de acompanhamento */ 
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp. 
    {utp/ut-liter.i Processando... *}
    RUN pi-inicializar IN h-acomp ( RETURN-VALUE ). 
    {utp/ut-liter.i TÇrmino_da_busca_de_informaá‰es_das_etiquetas... *}
    RUN pi-acompanhar IN h-acomp ( RETURN-VALUE ). 
    RUN pi-finalizar IN h-acomp. 

    IF VALID-HANDLE (h-acomp) THEN DELETE OBJECT h-acomp.

    RUN BeforeDestroyInterface.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btHelp-dc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp-dc wWindow
ON CHOOSE OF btHelp-dc IN FRAME fPage3 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btHelp-it
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp-it wWindow
ON CHOOSE OF btHelp-it IN FRAME fPage2 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btHelp-op
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp-op wWindow
ON CHOOSE OF btHelp-op IN FRAME fPage1 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btHelp-rf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp-rf wWindow
ON CHOOSE OF btHelp-rf IN FRAME fPage4 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME dc-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dc-estab wWindow
ON F5 OF dc-estab IN FRAME fPage3 /* Estab */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc041.w"
                       &FieldZoom1="cod-estabel"
                       &FieldScreen1="dc-estab"
                       &Frame1="fPage3"
                       &RunMethod="   " 
                       &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dc-estab wWindow
ON MOUSE-SELECT-DBLCLICK OF dc-estab IN FRAME fPage3 /* Estab */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc041.w"
                          &FieldZoom1="cod-estabel"
                          &FieldScreen1="dc-estab"
                          &Frame1="fPage3"
                          &RunMethod="   " 
                          &EnableImplant="YES"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dc-local
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dc-local wWindow
ON LEAVE OF dc-local IN FRAME fPage3 /* Local WMS */
DO:
    IF (dc-estab :SCREEN-VALUE IN FRAME fPage3 <> "") AND 
       (dc-local :SCREEN-VALUE IN FRAME fpage3 <> "") AND 
       (dc-numero:SCREEN-VALUE IN FRAME fPage3 <> "") THEN DO:

       FOR EACH wm-docto NO-LOCK
          WHERE wm-docto.cod-estabel = dc-estab :SCREEN-VALUE IN FRAME fPage3
            AND wm-docto.cod-local   = dc-local :SCREEN-VALUE IN FRAME fPage3
            AND wm-docto.num-docto   = dc-numero:SCREEN-VALUE IN FRAME fPage3:
                       
           IF NOT CAN-FIND(FIRST bc-etiqueta 
                           WHERE bc-etiqueta.id-docto = wm-docto.id-docto) THEN DO:
               ASSIGN dc-id-docto:SCREEN-VALUE IN FRAME fPage3 = string(wm-docto.id-docto). 
               LEAVE.
           END.

       END. 

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dc-lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dc-lote wWindow
ON LEAVE OF dc-lote IN FRAME fPage3 /* Lote */
DO:
    IF dc-lote:SCREEN-VALUE IN FRAME fPage3 <> "" THEN                                                 
        RUN pi-buscadatavalidade(INPUT dc-estab:SCREEN-VALUE,           
                                 INPUT dc-local:SCREEN-VALUE, 
                                 INPUT c-item-aux,            
                                 INPUT dc-lote:SCREEN-VALUE,            
                                 INPUT dc-referencia:SCREEN-VALUE,      
                                 INPUT c-loc-saida-aux,      
                                 OUTPUT dc-dt-validade-lote).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dc-numero
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dc-numero wWindow
ON F5 OF dc-numero IN FRAME fPage3 /* N£mero Docto */
DO:
    ASSIGN gcod-programa = "bc9026".
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc038.w"
                           &FieldZoom1="cod-estabel"
                           &FieldScreen1="dc-estab"
                           &Frame1="fPage3"
                           &FieldZoom2="cod-local"
                           &FieldScreen2="dc-local"
                           &Frame2="fpage3"
                           &FieldZoom3="num-docto"
                           &FieldScreen3="dc-numero"
                           &Frame3="fPage3"
                           &FieldZoom4="id-docto"
                           &FieldScreen4="dc-id-docto"
                           &Frame4="fPage3"
                           &RunMethod="   " 
                           &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dc-numero wWindow
ON LEAVE OF dc-numero IN FRAME fPage3 /* N£mero Docto */
DO:
    IF (dc-estab :SCREEN-VALUE IN FRAME fPage3 <> "") AND 
       (dc-local :SCREEN-VALUE IN FRAME fpage3 <> "") AND 
       (dc-numero:SCREEN-VALUE IN FRAME fPage3 <> "") THEN DO:

       FOR EACH wm-docto NO-LOCK
          WHERE wm-docto.cod-estabel = dc-estab :SCREEN-VALUE IN FRAME fPage3
            AND wm-docto.cod-local   = dc-local :SCREEN-VALUE IN FRAME fPage3
            AND wm-docto.num-docto   = dc-numero:SCREEN-VALUE IN FRAME fPage3:
                       
           IF NOT CAN-FIND(FIRST bc-etiqueta 
                           WHERE bc-etiqueta.id-docto = wm-docto.id-docto) THEN DO:
               ASSIGN dc-id-docto:SCREEN-VALUE IN FRAME fPage3 = string(wm-docto.id-docto). 
               LEAVE.
           END.

       END. 

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dc-numero wWindow
ON MOUSE-SELECT-DBLCLICK OF dc-numero IN FRAME fPage3 /* N£mero Docto */
DO:
    ASSIGN gcod-programa = "bc9026".
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc038.w"
                           &FieldZoom1="cod-estabel"
                           &FieldScreen1="dc-estab"
                           &Frame1="fPage3"
                           &FieldZoom2="cod-local"
                           &FieldScreen2="dc-local"
                           &Frame2="fPage3"
                           &FieldZoom3="num-docto"
                           &FieldScreen3="dc-numero"
                           &Frame3="fPage3"
                           &FieldZoom4="id-docto"
                           &FieldScreen4="dc-id-docto"
                           &Frame4="fPage3"
                           &RunMethod="   " 
                           &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME it-dep-saida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-dep-saida wWindow
ON F5 OF it-dep-saida IN FRAME fPage2 /* Dep Sa°da */
DO:
    {include/zoomvar.i &prog-zoom=bcp/bc8206.w
                    &campo=it-dep-saida
                    &campozoom=cod-depos
                    &frame=fPage2} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-dep-saida wWindow
ON MOUSE-SELECT-DBLCLICK OF it-dep-saida IN FRAME fPage2 /* Dep Sa°da */
DO:
    {include/zoomvar.i &prog-zoom=bcp/bc8206.w
                     &campo=it-dep-saida
                     &campozoom=cod-depos
                     &frame=fPage2}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-estab wWindow
ON F5 OF it-estab IN FRAME fPage2 /* Estab */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc041.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="it-estab"
                         &Frame1="fPage2"
                         &RunMethod="   " 
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-estab wWindow
ON MOUSE-SELECT-DBLCLICK OF it-estab IN FRAME fPage2 /* Estab */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc041.w"
                          &FieldZoom1="cod-estabel"
                          &FieldScreen1="it-estab"
                          &Frame1="fPage2"
                          &RunMethod="   " 
                          &EnableImplant="YES"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-item wWindow
ON F5 OF it-item IN FRAME fPage2 /* Item */
DO:
    {include/zoomvar.i &prog-zoom=bcp/bc8208.w
                    &campo=it-item
                    &campozoom=it-codigo
                    &frame=fPage2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-item wWindow
ON LEAVE OF it-item IN FRAME fPage2 /* Item */
DO:
  FIND FIRST ITEM NO-LOCK 
      WHERE ITEM.it-codigo = it-item:SCREEN-VALUE NO-ERROR.
  IF AVAIL ITEM THEN DO:
      ASSIGN it-desc-item:SCREEN-VALUE IN FRAME fPage2 = IF AVAIL ITEM THEN item.desc-item ELSE ''
             it-desc-item                              = IF AVAIL ITEM THEN item.desc-item ELSE ''.
                         IF ITEM.tipo-con-est = 3 THEN DO:
                                ASSIGN it-lote:SCREEN-VALUE IN FRAME fPage2 = ''
                                           it-desc-item:SCREEN-VALUE IN FRAME fPage2 = ''
                                           it-dt-validade-lote:SENSITIVE IN FRAME fPage2 = YES
                                           it-lote:SENSITIVE IN FRAME fPage2 = YES.
                         END.
                         ELSE DO:
                                ASSIGN it-lote:SCREEN-VALUE IN FRAME fPage2 = ''
                                           it-desc-item:SCREEN-VALUE IN FRAME fPage2 = ''
                                           it-dt-validade-lote:SENSITIVE IN FRAME fPage2 = NO
                                           it-lote:SENSITIVE IN FRAME fPage2 = NO.                       
                         
                         END.
  END.
  ELSE DO:
      /* Inicio -- Projeto Internacional */
      {utp/ut-liter.i "Item_da_Ordem_de_Produá∆o" *}
      RUN utp/ut-msgs.p ("SHOW",56, RETURN-VALUE).
      UNDO, LEAVE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-item wWindow
ON MOUSE-SELECT-DBLCLICK OF it-item IN FRAME fPage2 /* Item */
DO:
    {include/zoomvar.i &prog-zoom=bcp/bc8208.w
                    &campo=it-item
                    &campozoom=it-codigo
                    &frame=fPage2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-loc-saida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-loc-saida wWindow
ON F5 OF it-loc-saida IN FRAME fPage2 /* Loc Sa° */
DO:
    {include/zoomvar.i &prog-zoom=bcp/bc8209.w
                    &campo=it-loc-saida
                    &campozoom=cod-localiz
                    &frame=fPage2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-loc-saida wWindow
ON MOUSE-SELECT-DBLCLICK OF it-loc-saida IN FRAME fPage2 /* Loc Sa° */
DO:
    {include/zoomvar.i &prog-zoom=bcp/bc8209.w
                    &campo=it-loc-saida
                    &campozoom=cod-localiz
                    &frame=fPage2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-lote wWindow
ON LEAVE OF it-lote IN FRAME fPage2 /* Lote */
DO:

    IF NOT VALID-HANDLE(hbosc074) THEN DO:
        RUN scbo/bosc074.p PERSISTENT SET hbosc074.
    END.
    IF it-lote:SCREEN-VALUE IN FRAME fPage2 <> "" THEN
        RUN pi-buscadatavalidade(INPUT it-estab:SCREEN-VALUE,           
                                 INPUT it-local:SCREEN-VALUE, 
                                 INPUT it-item:SCREEN-VALUE,            
                                 INPUT it-lote:SCREEN-VALUE,            
                                 INPUT it-referencia:SCREEN-VALUE,      
                                 INPUT it-loc-saida:SCREEN-VALUE,      
                                 OUTPUT it-dt-validade-lote).
        IF RETURN-VALUE = "NOK" THEN DO:
            RUN getLote IN hbosc074 (INPUT it-item:SCREEN-VALUE,           
                                     INPUT it-lote:SCREEN-VALUE, 
                                     INPUT it-referencia:SCREEN-VALUE,      
                                     OUTPUT it-dt-validade-lote).
            IF RETURN-VALUE = "NOK" THEN
                ASSIGN it-dt-validade-lote:SENSITIVE IN FRAME fPage2 = YES
                       it-dt-validade-lote:SCREEN-VALUE IN FRAME fPage2 = "".
        END.
    
       IF RETURN-VALUE = "OK" THEN
            ASSIGN it-dt-validade-lote:SCREEN-VALUE IN FRAME fPage2 = string(it-dt-validade-lote)
                   it-dt-validade-lote:SENSITIVE IN FRAME fPage2 = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME op-dep-saida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-dep-saida wWindow
ON F5 OF op-dep-saida IN FRAME fPage1 /* Dep Sa°da */
DO:
    {include/zoomvar.i &prog-zoom=bcp/bc8206.w
                       &campo=op-dep-saida
                       &campozoom=cod-depos
                       &frame=fPage1} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-dep-saida wWindow
ON MOUSE-SELECT-DBLCLICK OF op-dep-saida IN FRAME fPage1 /* Dep Sa°da */
DO:
    {include/zoomvar.i &prog-zoom=bcp/bc8206.w
                     &campo=op-dep-saida
                     &campozoom=cod-depos
                     &frame=fPage1}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME op-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-item wWindow
ON F5 OF op-item IN FRAME fPage1 /* Item */
DO:
    {include/zoomvar.i &prog-zoom=bcp/bc8208.w
                    &campo=it-item
                    &campozoom=it-codigo
                    &frame=fPage2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-item wWindow
ON MOUSE-SELECT-DBLCLICK OF op-item IN FRAME fPage1 /* Item */
DO:
    {include/zoomvar.i &prog-zoom=bcp/bc8208.w
                    &campo=it-item
                    &campozoom=it-codigo
                    &frame=fPage2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME op-loc-saida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-loc-saida wWindow
ON F5 OF op-loc-saida IN FRAME fPage1 /* Loc Sa° */
DO:
    {include/zoomvar.i &prog-zoom=bcp/bc8209.w
                    &campo=op-loc-saida
                    &campozoom=cod-localiz
                    &frame=fPage1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-loc-saida wWindow
ON MOUSE-SELECT-DBLCLICK OF op-loc-saida IN FRAME fPage1 /* Loc Sa° */
DO:
    {include/zoomvar.i &prog-zoom=bcp/bc8209.w
                    &campo=op-loc-saida
                    &campozoom=cod-localiz
                    &frame=fPage1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME op-lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-lote wWindow
ON LEAVE OF op-lote IN FRAME fPage1 /* Lote */
DO:

    IF NOT VALID-HANDLE(hbosc074) THEN DO:
        RUN scbo/bosc074.p PERSISTENT SET hbosc074.
    END.

    IF op-lote:SCREEN-VALUE IN FRAME fPage1 <> "" THEN
        RUN pi-buscadatavalidade(INPUT c-estab-aux,           
                                 INPUT op-local:SCREEN-VALUE, 
                                 INPUT c-item-aux,            
                                 INPUT op-lote:SCREEN-VALUE,            
                                 INPUT op-referencia:SCREEN-VALUE,      
                                 INPUT op-loc-saida:SCREEN-VALUE,      
                                 OUTPUT op-dt-validade-lote).
        IF RETURN-VALUE = "NOK" THEN DO:
            RUN getLote IN hbosc074 (INPUT c-item-aux,           
                                     INPUT op-lote:SCREEN-VALUE, 
                                     INPUT op-referencia:SCREEN-VALUE,      
                                     OUTPUT op-dt-validade-lote).
            IF RETURN-VALUE = "NOK" THEN 
                ASSIGN op-dt-validade-lote:SENSITIVE IN FRAME fPage1 = YES
                       op-dt-validade-lote:SCREEN-VALUE IN FRAME fPage1 = "".
        END.
        IF RETURN-VALUE = "OK" THEN
              ASSIGN op-dt-validade-lote:SCREEN-VALUE IN FRAME fPage1 = string(op-dt-validade-lote)
                     op-dt-validade-lote:SENSITIVE IN FRAME fPage1 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME op-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-ordem wWindow
ON f5 OF op-ordem IN FRAME fPage1 /* Ordem Producao */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in271.w
                    &campo=op-ordem
                    &campozoom=nr-ord-produ
                    &frame=fPage1} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-ordem wWindow
ON LEAVE OF op-ordem IN FRAME fPage1 /* Ordem Producao */
DO:
    IF NOT VALID-HANDLE(hbosc074) THEN DO:
        RUN scbo/bosc074.p PERSISTENT SET hbosc074.
    END.
    ASSIGN op-ordem.
    FIND FIRST ord-prod 
        WHERE ord-prod.nr-ord-prod = op-ordem NO-LOCK NO-ERROR.
    IF AVAIL ord-prod THEN DO:
       FIND FIRST ITEM NO-LOCK                                                                                              
            WHERE item.it-codigo = ord-prod.it-codigo NO-ERROR.
       ASSIGN op-ordem:SCREEN-VALUE IN FRAME fPage1 = STRING(ord-prod.nr-ord-prod).
       IF AVAIL ITEM THEN DO:
           IF ord-prod.lote <> "" THEN
               ASSIGN c-lote-alt = ord-prod.lote.
           ELSE
               ASSIGN c-lote-alt = op-lote:SCREEN-VALUE IN FRAME fPage1.

          ASSIGN op-referencia:SCREEN-VALUE IN FRAME fPage1 = ord-prod.cod-refer
                 op-lote:SCREEN-VALUE IN FRAME fPage1       = c-lote-alt
                 op-quantidade:SCREEN-VALUE IN FRAME fPage1 = STRING(ord-prod.qt-ordem)
                 op-item:SCREEN-VALUE IN FRAME fPage1       = ord-prod.it-codigo 
                 op-desc-item:SCREEN-VALUE IN FRAME fPage1  = ITEM.desc-item
                 c-item-aux  = ord-prod.it-codigo   
                 c-estab-aux = ord-prod.cod-estabel.
          IF ord-prod.lote <> "" THEN DO:
               RUN pi-buscadatavalidade(INPUT c-estab-aux,           
                                        INPUT op-local:SCREEN-VALUE, 
                                        INPUT c-item-aux,            
                                        INPUT op-lote:SCREEN-VALUE,            
                                        INPUT op-referencia:SCREEN-VALUE,      
                                        INPUT op-loc-saida:SCREEN-VALUE,      
                                        OUTPUT op-dt-validade-lote).

                IF RETURN-VALUE = "NOK" THEN DO:
                    RUN getLote IN hbosc074 (INPUT c-item-aux,           
                                             INPUT op-lote:SCREEN-VALUE, 
                                             INPUT op-referencia:SCREEN-VALUE,      
                                             OUTPUT op-dt-validade-lote).
                    IF RETURN-VALUE = "NOK" THEN
                        ASSIGN op-dt-validade-lote:SENSITIVE IN FRAME fPage1 = YES
                               op-dt-validade-lote:SCREEN-VALUE IN FRAME fPage1 = "".
                END.
            
                IF RETURN-VALUE = "OK" THEN
                     ASSIGN op-dt-validade-lote:SCREEN-VALUE IN FRAME fPage1 = string(op-dt-validade-lote)
                            op-dt-validade-lote:SENSITIVE IN FRAME fPage1 = NO.
            
          END.
       END.
       ELSE DO:
           /* Inicio -- Projeto Internacional */
           {utp/ut-liter.i "Item_da_Ordem_de_Produá∆o" *}
           RUN utp/ut-msgs.p ("SHOW",56, RETURN-VALUE).
           APPLY "entry" TO op-ordem IN FRAME fPage1.
           UNDO, LEAVE.
       END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-ordem wWindow
ON MOUSE-SELECT-DBLCLICK OF op-ordem IN FRAME fPage1 /* Ordem Producao */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in271.w
                    &campo=op-ordem
                    &campozoom=nr-ord-produ
                    &frame=fPage1} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME rf-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rf-emitente wWindow
ON F5 OF rf-emitente IN FRAME fPage4 /* Emitente */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z03in089.w
                           &campozoom=serie-docto
                           &campo=rf-serie
                           &frame=fPage4 
                           &campozoom2=nro-docto
                           &campo2=rf-numero
                           &frame2=fPage4
                           &campozoom3=cod-emitente
                           &campo3=rf-emitente
                           &FRAME3=fPage4}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rf-emitente wWindow
ON LEAVE OF rf-emitente IN FRAME fPage4 /* Emitente */
DO:
    ASSIGN rf-numero
           rf-serie
           rf-emitente.

    FIND FIRST doc-fisico NO-LOCK
        WHERE doc-fisico.nro-docto    = rf-numero 
        AND   doc-fisico.serie        = rf-serie
        AND   doc-fisico.cod-emitente = rf-emitente NO-ERROR.
    IF AVAIL doc-fisico THEN DO:
       ASSIGN rf-numero     = doc-fisico.nro-docto   
              rf-serie      = doc-fisico.serie       
              rf-emitente   = doc-fisico.cod-emitente
              rf-estab      = doc-fisico.cod-estabel 
              rf-numero:SCREEN-VALUE IN FRAME fPage4 = doc-fisico.nro-docto
              rf-serie:SCREEN-VALUE IN FRAME fPage4 = doc-fisico.serie-docto
              rf-emitente:SCREEN-VALUE IN FRAME fPage4 = STRING(doc-fisico.cod-emitente)
              rf-estab:SCREEN-VALUE IN FRAME fPage4 = doc-fisico.cod-estabel
              cb-rf-tp-nota:SCREEN-VALUE IN FRAME fPage4 = {ininc/i01in089.i 04  doc-fisico.tipo-nota}
              c-item-aux      = ""
              c-loc-saida-aux = "".
    END.

    IF NOT VALID-HANDLE(hdboad098na) THEN
        RUN adbo/boad098na.p PERSISTENT SET hdboad098na.
    RUN openQueryStatic IN hdboad098na (INPUT "Main":U).
    RUN gotoKey         IN hdboad098na (INPUT rf-emitente).
    IF RETURN-VALUE = 'OK':U THEN DO:
        RUN getCharField    IN hdboad098na (INPUT "nome-abrev":U,
                                            OUTPUT rf-desc-emitente) NO-ERROR.
    END.
    ELSE 
        ASSIGN rf-desc-emitente = '':U.

    DISP rf-desc-emitente WITH FRAME fpage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rf-emitente wWindow
ON MOUSE-SELECT-DBLCLICK OF rf-emitente IN FRAME fPage4 /* Emitente */
DO:
      APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rf-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rf-estab wWindow
ON F5 OF rf-estab IN FRAME fPage4 /* Estab */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc047.w"
                          &FieldZoom1="cod-local"
                          &FieldScreen1="rf-local"
                          &frame1="fPage4"
                          &FieldZoom2="cod-estabel"
                          &FieldScreen2="rf-estab"
                          &frame2="fPage4"
                          &EnableImplant="NO"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rf-estab wWindow
ON MOUSE-SELECT-DBLCLICK OF rf-estab IN FRAME fPage4 /* Estab */
DO:
   {method/zoomfields.i &ProgramZoom="sczoom/z01sc047.w"
                         &FieldZoom1="cod-local"
                         &FieldScreen1="rf-local"
                         &frame1="fPage4"
                         &FieldZoom2="cod-estabel"
                         &FieldScreen2="rf-estab"
                         &frame2="fPage4"
                         &EnableImplant="NO"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rf-local
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rf-local wWindow
ON F5 OF rf-local IN FRAME fPage4 /* Local WMS */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc047.w"
                          &FieldZoom1="cod-local"
                          &FieldScreen1="rf-local"
                          &frame1="fPage4"
                          &FieldZoom2="cod-estabel"
                          &FieldScreen2="rf-estab"
                          &frame2="fPage4"
                          &EnableImplant="NO"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rf-local wWindow
ON MOUSE-SELECT-DBLCLICK OF rf-local IN FRAME fPage4 /* Local WMS */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc047.w"
                          &FieldZoom1="cod-local"
                          &FieldScreen1="rf-local"
                          &frame1="fPage4"
                          &FieldZoom2="cod-estabel"
                          &FieldScreen2="rf-estab"
                          &frame2="fPage4"
                          &EnableImplant="NO"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rf-numero
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rf-numero wWindow
ON F5 OF rf-numero IN FRAME fPage4 /* N£mero Docto */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z03in089.w
                           &campozoom=serie-docto
                           &campo=rf-serie
                           &frame=fPage4 
                           &campozoom2=nro-docto
                           &campo2=rf-numero
                           &frame2=fPage4
                           &campozoom3=cod-emitente
                           &campo3=rf-emitente
                           &FRAME3=fPage4}
                           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rf-numero wWindow
ON LEAVE OF rf-numero IN FRAME fPage4 /* N£mero Docto */
DO:
    ASSIGN rf-numero
           rf-serie
           rf-emitente.
    FIND FIRST doc-fisico NO-LOCK
        WHERE doc-fisico.nro-docto    = rf-numero 
        AND   doc-fisico.serie        = rf-serie
        AND   doc-fisico.cod-emitente = rf-emitente NO-ERROR.
    IF AVAIL doc-fisico THEN DO:
       ASSIGN rf-numero     = doc-fisico.nro-docto
              rf-serie      = doc-fisico.serie
              rf-emitente   = doc-fisico.cod-emitente
              rf-estab      = doc-fisico.cod-estabel
              rf-numero:SCREEN-VALUE IN FRAME fPage4 = doc-fisico.nro-docto
              rf-serie:SCREEN-VALUE IN FRAME fPage4 = doc-fisico.serie
              rf-emitente:SCREEN-VALUE IN FRAME fPage4 = STRING(doc-fisico.cod-emitente)
              rf-estab:SCREEN-VALUE IN FRAME fPage4 = doc-fisico.cod-estabel
              cb-rf-tp-nota:SCREEN-VALUE IN FRAME fPage4 = {ininc/i01in089.i 04  doc-fisico.tipo-nota}
              c-item-aux      = ""
              c-loc-saida-aux = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rf-numero wWindow
ON MOUSE-SELECT-DBLCLICK OF rf-numero IN FRAME fPage4 /* N£mero Docto */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rf-serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rf-serie wWindow
ON F5 OF rf-serie IN FRAME fPage4 /* SÇrie */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z03in089.w
                           &campozoom=serie-docto
                           &campo=rf-serie
                           &frame=fPage4 
                           &campozoom2=nro-docto
                           &campo2=rf-numero
                           &frame2=fPage4
                           &campozoom3=cod-emitente
                           &campo3=rf-emitente
                           &FRAME3=fPage4}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rf-serie wWindow
ON LEAVE OF rf-serie IN FRAME fPage4 /* SÇrie */
DO:
    ASSIGN rf-numero
           rf-serie
           rf-emitente.
    FIND FIRST doc-fisico NO-LOCK
        WHERE doc-fisico.nro-docto    = rf-numero 
        AND   doc-fisico.serie        = rf-serie
        AND   doc-fisico.cod-emitente = rf-emitente NO-ERROR.
    IF AVAIL doc-fisico THEN DO:
       ASSIGN rf-numero     = doc-fisico.nro-docto   
              rf-serie      = doc-fisico.serie       
              rf-emitente   = doc-fisico.cod-emitente
              rf-estab      = doc-fisico.cod-estabel 
              rf-numero:SCREEN-VALUE IN FRAME fPage4 = doc-fisico.nro-docto
              rf-serie:SCREEN-VALUE IN FRAME fPage4 = doc-fisico.serie
              rf-emitente:SCREEN-VALUE IN FRAME fPage4 = STRING(doc-fisico.cod-emitente)
              rf-estab:SCREEN-VALUE IN FRAME fPage4 = doc-fisico.cod-estabel
              cb-rf-tp-nota:SCREEN-VALUE IN FRAME fPage4 = {ininc/i01in089.i 04  doc-fisico.tipo-nota}
              c-item-aux      = ""
              c-loc-saida-aux = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rf-serie wWindow
ON MOUSE-SELECT-DBLCLICK OF rf-serie IN FRAME fPage4 /* SÇrie */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-dc-tela
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
/* Inicia os ponteiros */
op-ordem:load-mouse-pointer ("image/lupa.cur") IN FRAME fPage1.
op-loc-saida:load-mouse-pointer ("image/lupa.cur") IN FRAME fPage1.
op-dep-saida:load-mouse-pointer ("image/lupa.cur") IN FRAME fPage1.
it-item:load-mouse-pointer ("image/lupa.cur") IN FRAME fPage2.
it-estab:load-mouse-pointer ("image/lupa.cur") IN FRAME fPage2.
it-dep-saida:load-mouse-pointer ("image/lupa.cur") IN FRAME fPage2.
it-loc-saida:load-mouse-pointer ("image/lupa.cur") IN FRAME fPage2.
dc-numero:load-mouse-pointer ("image/lupa.cur") IN FRAME fPage3.
dc-estab:load-mouse-pointer ("image/lupa.cur") IN FRAME fPage3.
rf-numero:load-mouse-pointer ("image/lupa.cur") IN FRAME fPage4.
rf-serie:load-mouse-pointer ("image/lupa.cur") IN FRAME fPage4.
rf-emitente:load-mouse-pointer ("image/lupa.cur") IN FRAME fPage4.
rf-estab:load-mouse-pointer ("image/lupa.cur") IN FRAME fPage4.
rf-local:load-mouse-pointer ("image/lupa.cur") IN FRAME fPage4.

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterChangePage wWindow 
PROCEDURE afterChangePage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN InitializeDBOS.

  ASSIGN c-item-aux      = '' 
         c-loc-saida-aux = ''
         c-estab-aux     = ''
         c-lista         = ''
         c-inicial       = ''
         i-tp-nota       = 0.

  EMPTY TEMP-TABLE tt-browse-tela.
  {&OPEN-QUERY-br-op-tela IN FRAME fPage1} 
  {&OPEN-QUERY-br-it-tela IN FRAME fPage2}
  {&OPEN-QUERY-br-dc-tela IN FRAME fPage3}
  {&OPEN-QUERY-br-rf-tela IN FRAME fPage4}

  DISABLE bt-incluir-op
          bt-modificar-op
          bt-eliminar-op
          op-total-qtd-item
          WITH FRAME fPage1.

  DISABLE bt-incluir-it
          bt-modificar-it
          bt-eliminar-it
          it-total-qtd-item
          WITH FRAME fPage2.

  DISABLE bt-incluir-dc
          bt-modificar-dc
          bt-eliminar-dc
          dc-total-qtd-item
          WITH FRAME fPage3.

  DISABLE bt-incluir-rf
          bt-modificar-rf
          bt-eliminar-rf
          rf-total-qtd-item
          WITH FRAME fPage4.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeDestroyInterface wWindow 
PROCEDURE BeforeDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(hbosc038) THEN DO:
        RUN DESTROY IN hbosc038.
        DELETE OBJECT hbosc038 NO-ERROR.
    END.

    IF VALID-HANDLE(hbosc047) THEN DO:
        RUN DESTROY IN hbosc047.
        DELETE OBJECT hbosc047 NO-ERROR.
    END.
    
    IF VALID-HANDLE(hbosc074) THEN DO:
        RUN DESTROY IN hbosc074.
        DELETE OBJECT hbosc074 NO-ERROR.
    END.

    IF VALID-HANDLE(hbosc073) THEN DO:
        RUN DESTROY IN hbosc073.
        DELETE OBJECT hbosc073 NO-ERROR.
    END.
    
    IF VALID-HANDLE(hbosc050) THEN DO:
        RUN DESTROY IN hbosc050.
        DELETE OBJECT hbosc050 NO-ERROR.
    END.

    IF VALID-HANDLE(hboin281) THEN DO:
        RUN DESTROY IN hboin281.
        DELETE OBJECT hboin281 NO-ERROR.
    END.

    IF VALID-HANDLE(hbosc075) THEN DO:
        RUN DESTROY IN hbosc075.
        DELETE OBJECT hbosc075 NO-ERROR.
    END.

    IF VALID-HANDLE(hbosc044) THEN DO:
        RUN DESTROY IN hbosc044.
        DELETE OBJECT hbosc044 NO-ERROR.
    END.

    IF VALID-HANDLE(hbosc112) THEN DO:
        RUN DESTROY IN hbosc112.
        DELETE OBJECT hbosc112 NO-ERROR.
    END.

    IF VALID-HANDLE(hboin367) THEN DO:
        RUN DESTROY IN hboin367.
        DELETE OBJECT hboin367 NO-ERROR.
    END.          

    IF VALID-HANDLE(hboin089) THEN DO:
        RUN DESTROY IN hboin089.
        DELETE OBJECT hboin089 NO-ERROR.
    END.          

    IF VALID-HANDLE(hdboad098na) THEN DO:
        RUN DESTROY IN hdboad098na.
        DELETE OBJECT hdboad098na NO-ERROR.
    END.          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeDBOS wWindow 
PROCEDURE InitializeDBOS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* wm-docto */
    IF NOT VALID-HANDLE(hbosc038) THEN DO:
        RUN scbo/bosc038.p PERSISTENT SET hbosc038.
    END.

    /* wm-etiqueta */
    IF NOT VALID-HANDLE(hbosc074) THEN DO:
        RUN scbo/bosc074.p PERSISTENT SET hbosc074.
    END.

    IF NOT VALID-HANDLE(hbosc073) THEN DO:
        RUN scbo/bosc073.p PERSISTENT SET hbosc073. 
    END.                

    /*  */
    IF NOT VALID-HANDLE(hbosc050) THEN DO:
        RUN scbo/bosc050.p PERSISTENT SET hbosc050.
    END.

    /* param-cp */
    IF NOT VALID-HANDLE(hboin281) THEN DO:
        RUN inbo/boin281.p PERSISTENT SET hboin281.
    END.

    /* carga */
    IF NOT VALID-HANDLE(hbosc075) THEN DO:
        RUN scbo/bosc075.p PERSISTENT SET hbosc075.
    END.
    RUN openQueryStatic IN hbosc075(input "Main":U).

    /* wm-item*/
    IF NOT VALID-HANDLE(hbosc044) THEN DO:
        RUN scbo/bosc044.p PERSISTENT SET hbosc044.
    END.

    /* wm-movto-etiqueta*/
    IF NOT VALID-HANDLE(hbosc112) THEN DO:
        RUN scbo/bosc112.p PERSISTENT SET hbosc112.
    END.

    IF NOT VALID-HANDLE(hboin367) THEN DO:
        RUN inbo/boin367.p PERSISTENT SET hboin367.
    END.             
    RUN openQueryStatic IN hboin367(input "Main":U).
    
    IF NOT VALID-HANDLE(hboin089) THEN DO:
        RUN inbo/boin089.p PERSISTENT SET hboin089.
    END.                

    IF NOT VALID-HANDLE(hdboad098na) THEN DO:
        RUN adbo/boad098na.p PERSISTENT SET hdboad098na.
    END.                

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-docto wWindow 
PROCEDURE pi-atualiza-docto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /* A query eh aberta na procedure RUN pi-eh-docto-entrada. */
&if '{&mgscm_version}' >= '2.04' &then
    IF deCarga > 0 THEN DO:
        /* Retorna a ttwm-docto */
        RUN getRecord IN hbosc038 (OUTPUT TABLE ttWm-docto).
        
        /* Atribui a nova carga */
        FIND FIRST ttWm-docto NO-ERROR.
        ASSIGN ttWm-docto.id-carga = deCarga.

        /* Atualiza a wm-docto */
        RUN emptyRowErrors IN hbosc038.
        RUN setRecord      IN hbosc038 (INPUT TABLE ttWm-docto).
        RUN updateRecord   IN hbosc038.
        RUN getRowErrors   IN hbosc074 (OUTPUT TABLE RowErrors).

        FIND FIRST rowErrors NO-ERROR.
        IF AVAIL rowErrors THEN DO:
            {method/showmessage.i1}        
            {method/showmessage.i2}        
            RETURN "NOK":U.
        END.    
    END.
    RETURN 'OK':U.
&endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-informacao-rf wWindow 
PROCEDURE pi-busca-informacao-rf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   EMPTY TEMP-TABLE tt-embalagem.
   EMPTY TEMP-TABLE tt-rat-lote. 
   FOR EACH tt-browse-tela.
       DELETE tt-browse-tela.
   END.                      

   RUN pi-carrega-itens-wms(INPUT rf-numero,           
                            INPUT rf-serie,            
                            INPUT rf-emitente,         
                            INPUT i-tp-nota,           
                            OUTPUT TABLE tt-rat-lote). 
   FOR EACH tt-rat-lote: 
       RUN pi-carrega-etiquetas-rf (INPUT rf-estab,                    
                                    INPUT rf-local,                    
                                    INPUT tt-rat-lote.it-codigo,   
                                    INPUT tt-rat-lote.cod-refer,   
                                    INPUT tt-rat-lote.lote,        
                                    INPUT tt-rat-lote.sequencia,   
                                    INPUT tt-rat-lote.quantidade,
                                    INPUT tt-rat-lote.dt-vali-lote,
                                    OUTPUT TABLE tt-embalagem,
                                    OUTPUT TABLE rowerrors).
       /* Nao Gerou Nenhum Registro */
       IF RETURN-VALUE <> "OK":U THEN DO:
           FIND FIRST rowErrors NO-ERROR.
           IF AVAIL rowErrors THEN DO:
               {method/showmessage.i1}        
               {method/showmessage.i2}        
           END.    
           RETURN "NOK":U.
       END.
   END. 

   
   /* Calcula a quantidade de etiquetas a serem impressas */
   FOR EACH tt-embalagem:

       IF tt-embalagem.QtdItem > tt-embalagem.QtdItemEmbalagem THEN
            ASSIGN de-aux = tt-embalagem.QtdItem - ( tt-embalagem.QtdItemEmbalagem * TRUNCATE((tt-embalagem.QtdItem / tt-embalagem.QtdItemEmbalagem),0)).
       ELSE
            ASSIGN de-aux = 0.

       CREATE tt-browse-tela.
       ASSIGN tt-browse-tela.cod-estabel           = rf-estab
              tt-browse-tela.nr-ord-prod           = 0
              tt-browse-tela.id-docto              = 0
              tt-browse-tela.cod-local             = rf-local
              tt-browse-tela.cod-embalagem         = tt-embalagem.codEmbalagem
              tt-browse-tela.cod-refer             = tt-embalagem.codRefer
              tt-browse-tela.it-codigo             = tt-embalagem.codItem
              tt-browse-tela.lote                  = tt-embalagem.codLote
              tt-browse-tela.qtd-item              = tt-embalagem.QtdItem - de-aux
              tt-browse-tela.qtd-item-embalagem    = tt-embalagem.QtdItemEmbalagem
              tt-browse-tela.qtd-etiqueta          = tt-embalagem.QtdEmbalagem
              tt-browse-tela.layout-etiqueta       = tt-embalagem.CodLayoutEmbalagem
              tt-browse-tela.dt-validade-lote      = tt-embalagem.DtValidadeLote  
              tt-browse-tela.cod-ean               = STRING(tt-embalagem.codBarrasItem)
              tt-browse-tela.cod-dun               = STRING(tt-embalagem.codbarrasembalagem)
              tt-browse-tela.cod-usuario           = c-seg-usuario
              tt-browse-tela.cod-embalagem         = tt-embalagem.codembalagem
              tt-browse-tela.cod-emb-pai           = tt-embalagem.cod-emb-pai
              tt-browse-tela.logPai                = tt-embalagem.logPai
              tt-browse-tela.ControlaEtiqueta      = tt-embalagem.ControlaEtiqueta
              tt-browse-tela.num-seq               = tt-embalagem.NumSeqItem.

       FIND FIRST wm-item WHERE
                  wm-item.cod-item = tt-browse-tela.it-codigo NO-LOCK NO-ERROR.

       IF AVAIL wm-item THEN
            ASSIGN tt-browse-tela.qtd-peso-item = wm-item.qtd-peso.

       /* Calcula a quantidade de etiquetas de cada item */
       RUN pi-calcula-etiquetas (INPUT tt-browse-tela.qtd-item,
                                 INPUT tt-browse-tela.qtd-item-embalagem, 
                                 OUTPUT tt-browse-tela.qtd-etiqueta, 
                                 OUTPUT tt-browse-tela.qtd-ult-embalagem).

       ASSIGN tt-browse-tela.qtd-item = tt-browse-tela.qtd-item / tt-browse-tela.qtd-etiqueta.

       IF de-aux > 0 THEN DO:
           CREATE tt-browse-tela.
           ASSIGN tt-browse-tela.cod-estabel           = rf-estab
                  tt-browse-tela.nr-ord-prod           = 0
                  tt-browse-tela.id-docto              = 0
                  tt-browse-tela.cod-local             = rf-local
                  tt-browse-tela.cod-embalagem               = tt-embalagem.codEmbalagem
                  tt-browse-tela.cod-refer             = tt-embalagem.codRefer
                  tt-browse-tela.it-codigo             = tt-embalagem.codItem
                  tt-browse-tela.lote                  = tt-embalagem.codLote
                  tt-browse-tela.qtd-item              = de-aux
                  tt-browse-tela.qtd-item-embalagem    = tt-embalagem.QtdItemEmbalagem
                  tt-browse-tela.qtd-etiqueta          = tt-embalagem.QtdEmbalagem
                  tt-browse-tela.layout-etiqueta       = tt-embalagem.CodLayoutEmbalagem
                  tt-browse-tela.dt-validade-lote      = tt-embalagem.DtValidadeLote  
                  tt-browse-tela.cod-ean               = STRING(tt-embalagem.codBarrasItem)
                  tt-browse-tela.cod-dun               = STRING(tt-embalagem.codbarrasembalagem)
                  tt-browse-tela.cod-usuario           = c-seg-usuario
                  tt-browse-tela.cod-embalagem         = tt-embalagem.codembalagem
                  tt-browse-tela.logPai                = tt-embalagem.logPai
                  tt-browse-tela.ControlaEtiqueta      = tt-embalagem.ControlaEtiqueta
                  tt-browse-tela.num-seq               = tt-embalagem.NumSeqItem.

           FIND FIRST wm-item WHERE
                  wm-item.cod-item = tt-browse-tela.it-codigo NO-LOCK NO-ERROR.
           IF AVAIL wm-item THEN
                ASSIGN tt-browse-tela.qtd-peso-item = wm-item.qtd-peso.
       END.
   END.
   
   DEF VAR l-cont AS LOGICAL NO-UNDO.

   FOR EACH tt-browse-tela 
       WHERE tt-browse-tela.logpai        = YES 
       AND   tt-browse-tela.tipo-etiqueta = 0:
       ASSIGN l-cont = NO.
       FOR EACH bftt-browse-tela 
           WHERE bftt-browse-tela.it-codigo     = tt-browse-tela.it-codigo 
           AND   bftt-browse-tela.cod-refer     = tt-browse-tela.cod-refer 
           AND   bftt-browse-tela.lote          = tt-browse-tela.lote      
           AND   bftt-browse-tela.logpai        = NO                      
           /*AND   bftt-browse-tela.tipo-etiqueta = 0*/.
           ASSIGN l-cont = YES.
           IF tt-browse-tela.ControlaEtiqueta = YES AND bftt-browse-tela.ControlaEtiqueta = YES THEN  
               ASSIGN tt-browse-tela.tipo-etiqueta   = 2
                      bftt-browse-tela.tipo-etiqueta = 1
                      tt-browse-tela.desc-tipo-etiqueta   = "Agupadora"
                      bftt-browse-tela.desc-tipo-etiqueta = "N∆o Agrupadora".  
           IF tt-browse-tela.ControlaEtiqueta = YES AND bftt-browse-tela.ControlaEtiqueta = NO THEN  
               ASSIGN tt-browse-tela.tipo-etiqueta = 3
                      tt-browse-tela.desc-tipo-etiqueta   = "Agupadora Pr¢pria"
                      bftt-browse-tela.desc-tipo-etiqueta = "N∆o Controlada".
       END.
       IF l-cont = NO THEN
           ASSIGN tt-browse-tela.tipo-etiqueta        = 3
                  tt-browse-tela.desc-tipo-etiqueta   = "Agupadora Pr¢pria".
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-informacao-wms wWindow 
PROCEDURE pi-busca-informacao-wms :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&if '{&mgscm_version}' >= '2.04' &then

   DEFINE INPUT PARAMETER c-cod-estabel      AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER c-local            AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER de-docto           LIKE wm-docto.num-docto NO-UNDO.
   DEFINE INPUT PARAMETER c-item             AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER p-ordem            AS INTEGER   NO-UNDO.
   DEFINE INPUT PARAMETER p-id-docto         AS DECIMAL   NO-UNDO.
   DEFINE INPUT PARAMETER p-referencia       AS CHARACTER NO-UNDO.  
   DEFINE INPUT PARAMETER p-lote             AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER p-quantidade       AS DECIMAL   NO-UNDO.
   DEFINE INPUT PARAMETER p-dt-validade-lote AS DATE      NO-UNDO.
   DEFINE INPUT PARAMETER i-selecao          AS INTEGER   NO-UNDO.

   DEFINE VARIABLE c-num-docto AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE i-id-docto  AS INTEGER     NO-UNDO.
   DEFINE VARIABLE r-rowid     AS ROWID       NO-UNDO.

   /*i-selecao = 1 - Ordem Producao
                 2 - item 
                 3 - Doc WMS
                 4 - Rec. Fisico */

   ASSIGN i-id-docto   = 0 
          r-rowid      = ?.
   IF i-selecao = 3 THEN DO: /* por documento */

       RUN emptyRowErrors IN hbosc038.
       RUN setConstraintDtNumIdDocto2 IN hbosc038 (INPUT c-cod-estabel,         
                                                   INPUT c-local,           
                                                   INPUT de-docto,       
                                                   INPUT de-docto,       
                                                   INPUT 1,  
                                                   INPUT 1,  
                                                   INPUT 0,
                                                   INPUT 99).
       RUN openQueryStatic IN hbosc038 (input "DtNumIdDocto2":U).
       /* retorna todos os registros com mesmo num-docto */
       RUN getbatchRecords in hbosc038 (INPUT ?,
                                        INPUT  no,
                                        INPUT  ? ,
                                        OUTPUT i-registros,
                                        OUTPUT TABLE ttwm-docto).

       IF RETURN-VALUE = "NOK":U OR i-registros = 0 THEN DO:
           /* Inicio -- Projeto Internacional */
           {utp/ut-liter.i "documento" *}
           RUN utp/ut-msgs.p ("show",56, RETURN-VALUE + " " + string(de-docto)).
           RETURN "NOK":U.
       END.
   END.

   EMPTY TEMP-TABLE tt-embalagem.
   FOR EACH tt-browse-tela.
       DELETE tt-browse-tela.
   END.

   IF i-selecao = 3 THEN DO: /*por documento*/
       FOR EACH ttwm-docto: 
           RUN repositionRecord IN hbosc038 (INPUT ttWm-docto.r-rowid).
           RUN getdecField      IN hbosc038 ("id-docto":U   , OUTPUT i-id-docto   ).
           RUN getcharField     IN hbosc038 ("num-docto":U  , OUTPUT c-num-docto  ).
           
           ASSIGN r-rowid = ttWm-docto.r-rowid.

           IF  c-num-docto = INPUT FRAME fPage3 dc-numero AND 
               i-id-docto <> INPUT FRAME fPage3 dc-id-docto  THEN DO:
               NEXT.
           END.                                                                     
           RUN returnImpressaoEtiqueta IN hbosc074(INPUT c-cod-estabel,
                                                   INPUT c-local,
                                                   INPUT i-id-docto,
                                                   INPUT c-item,
                                                   OUTPUT TABLE tt-embalagem,
                                                   OUTPUT TABLE rowerrors).
           /* Nao Gerou Nenhum Registro */
           IF RETURN-VALUE <> "OK":U THEN DO:
               FIND FIRST rowErrors NO-ERROR.
               IF AVAIL rowErrors THEN DO:
                   {method/showmessage.i1}        
                   {method/showmessage.i2}        
               END.    
               RETURN "NOK":U.
           END.
       END. 
   END.
   ELSE DO:
       RUN returnImpressaoEtiqueta IN hbosc074 (INPUT c-cod-estabel,
                                                INPUT c-local,
                                                INPUT i-id-docto,
                                                INPUT c-item,
                                                OUTPUT TABLE tt-embalagem,
                                                OUTPUT TABLE rowerrors) .
       /* Nao Gerou Nenhum Registro */
       IF RETURN-VALUE <> "OK":U THEN DO:
           FIND FIRST rowErrors NO-ERROR.
           IF AVAIL rowErrors THEN DO:
               {method/showmessage.i1}        
               {method/showmessage.i2}        
           END.    
           RETURN "NOK":U.
       END.
   END.

   /* Chamada EPC */
   IF c-nom-prog-upc-mg97 <> "" THEN DO:
       RUN VALUE(c-nom-prog-upc-mg97) (INPUT "after-returnImpressaoEtiqueta":U, 
                                       INPUT "tt-embalagem":U,
                                       INPUT THIS-PROCEDURE,
                                       INPUT FRAME {&FRAME-NAME}:HANDLE,
                                       INPUT string(TEMP-TABLE tt-embalagem:HANDLE), /* enviado handle para atualizaá∆o de espec°ficos da ouro-fino */
                                       INPUT r-rowid) NO-ERROR. /* envia rowid do documento, quando existir */
   END. /* if */

   /* Calcula a quantidade de etiquetas a serem impressas */
   FOR EACH tt-embalagem:
       /* Se for por documento, busca o item, cod-refer e lote do documento */
       IF i-selecao = 3 THEN DO:
           FIND FIRST bc-etiqueta NO-LOCK
               WHERE  bc-etiqueta.it-codigo        = tt-embalagem.CodItem
               AND    bc-etiqueta.id-docto         = INPUT FRAME fPage3 dc-id-docto
               AND    bc-etiqueta.sequencia-docto  = tt-embalagem.NumSeqItem NO-ERROR.
           IF AVAIL bc-etiqueta THEN NEXT.
       END.

       IF i-selecao = 3 THEN DO:
           IF tt-embalagem.QtdItem > tt-embalagem.QtdItemEmbalagem THEN
               ASSIGN de-aux = tt-embalagem.QtdItem - ( tt-embalagem.QtdItemEmbalagem * TRUNCATE((tt-embalagem.QtdItem / tt-embalagem.QtdItemEmbalagem),0)).
           ELSE
               ASSIGN de-aux = 0.
       END.
       ELSE DO:
           IF p-quantidade > tt-embalagem.QtdItemEmbalagem THEN
               ASSIGN de-aux = p-quantidade - ( tt-embalagem.QtdItemEmbalagem * TRUNCATE((p-quantidade / tt-embalagem.QtdItemEmbalagem),0)).
           ELSE
               ASSIGN de-aux = 0.
       END.

       IF tt-embalagem.ControlaEtiqueta = YES THEN DO:

           CREATE tt-browse-tela.
           ASSIGN tt-browse-tela.cod-estabel           = c-cod-estabel                                                                     
                  tt-browse-tela.nr-ord-prod           = p-ordem
                  tt-browse-tela.id-docto              = p-id-docto                                                                  
                  tt-browse-tela.cod-local             = c-local                                                                     
                  tt-browse-tela.cod-embalagem         = tt-embalagem.codEmbalagem                                                   
                  tt-browse-tela.cod-emb-pai           = tt-embalagem.cod-emb-pai
                  tt-browse-tela.cod-refer             = IF i-selecao = 3 THEN tt-embalagem.cODrefer                                 
                                                         ELSE p-referencia                                                           
                  tt-browse-tela.it-codigo             = IF i-selecao = 3 THEN tt-embalagem.cODiTEM                                  
                                                         ELSE c-item                                                                 
                  tt-browse-tela.lote                  = IF i-selecao = 3 THEN tt-embalagem.cODlote                                  
                                                         ELSE p-lote                                                                 
                  tt-browse-tela.qtd-item              = IF i-selecao = 3 THEN ((tt-embalagem.QtdItem - de-aux))
                                                         ELSE (p-quantidade - de-aux)
                  tt-browse-tela.qtd-item-embalagem    = tt-embalagem.QtdItemEmbalagem                                               
                  tt-browse-tela.qtd-etiqueta          = tt-embalagem.QtdEmbalagem                                                   
                  tt-browse-tela.layout-etiqueta       = tt-embalagem.CodLayoutEmbalagem                                             
                  tt-browse-tela.dt-validade-lote      = IF i-selecao = 3 THEN tt-embalagem.DtValidadeLote                           
                                                         ELSE p-dt-validade-lote
                  tt-browse-tela.cod-ean               = STRING(tt-embalagem.codBARRASITEM)                                          
                  tt-browse-tela.cod-dun               = STRING(tt-embalagem.codbarrasembalagem)                                     
                  tt-browse-tela.cod-usuario           = c-seg-usuario                                                               
                  tt-browse-tela.logPai                = tt-embalagem.logPai                                                         
                  tt-browse-tela.ControlaEtiqueta      = tt-embalagem.ControlaEtiqueta                                               
                  tt-browse-tela.num-seq               = tt-embalagem.NumSeqItem                                                     
                  tt-browse-tela.id-movto              = IF i-selecao = 3 THEN tt-embalagem.id-movto
                                                         ELSE 0.                                                                                                                  
           /* Calcula a quantidade de etiquetas de cada item */
           RUN pi-calcula-etiquetas (INPUT tt-browse-tela.qtd-item,
                                     INPUT tt-browse-tela.qtd-item-embalagem, 
                                     OUTPUT tt-browse-tela.qtd-etiqueta, 
                                     OUTPUT tt-browse-tela.qtd-ult-embalagem).
    
           ASSIGN tt-browse-tela.qtd-item = tt-browse-tela.qtd-item / tt-browse-tela.qtd-etiqueta.
    
           FIND FIRST wm-item WHERE
                      wm-item.cod-item = tt-browse-tela.it-codigo NO-LOCK NO-ERROR.
    
           IF AVAIL wm-item THEN
                ASSIGN tt-browse-tela.qtd-peso-item = wm-item.qtd-peso.
    
           IF de-aux > 0 THEN DO:
               CREATE tt-browse-tela.
               ASSIGN tt-browse-tela.cod-estabel           = c-cod-estabel                                                                     
                      tt-browse-tela.nr-ord-prod           = p-ordem
                      tt-browse-tela.id-docto              = p-id-docto                                                                  
                      tt-browse-tela.cod-local             = c-local                                                                     
                      tt-browse-tela.cod-embalagem               = tt-embalagem.codEmbalagem                                                   
                      tt-browse-tela.cod-refer             = IF i-selecao = 3 THEN tt-embalagem.cODrefer                                 
                                                             ELSE p-referencia                                                           
                      tt-browse-tela.it-codigo             = IF i-selecao = 3 THEN tt-embalagem.cODiTEM                                  
                                                             ELSE c-item                                                                 
                      tt-browse-tela.lote                  = IF i-selecao = 3 THEN tt-embalagem.cODlote                                  
                                                             ELSE p-lote                                                                 
                      tt-browse-tela.qtd-item              = de-aux
                      tt-browse-tela.qtd-item-embalagem    = tt-embalagem.QtdItemEmbalagem                                               
                      tt-browse-tela.qtd-etiqueta          = tt-embalagem.QtdEmbalagem                                                   
                      tt-browse-tela.layout-etiqueta       = tt-embalagem.CodLayoutEmbalagem                                             
                      tt-browse-tela.dt-validade-lote      = IF i-selecao = 3 THEN tt-embalagem.DtValidadeLote                           
                                                             ELSE p-dt-validade-lote
                      tt-browse-tela.cod-ean               = STRING(tt-embalagem.codBARRASITEM)                                          
                      tt-browse-tela.cod-dun               = STRING(tt-embalagem.codbarrasembalagem)                                     
                      tt-browse-tela.cod-usuario           = c-seg-usuario                                                               
                      tt-browse-tela.logPai                = tt-embalagem.logPai                                                         
                      tt-browse-tela.ControlaEtiqueta      = tt-embalagem.ControlaEtiqueta                                               
                      tt-browse-tela.num-seq               = tt-embalagem.NumSeqItem
                      tt-browse-tela.id-movto              = IF i-selecao = 3 THEN tt-embalagem.id-movto
                                                             ELSE 0.
    
               FIND FIRST wm-item WHERE
                          wm-item.cod-item = tt-browse-tela.it-codigo NO-LOCK NO-ERROR.
    
               IF AVAIL wm-item THEN
                  ASSIGN tt-browse-tela.qtd-peso-item = wm-item.qtd-peso.
           END.

       END.

   END.
   
   DEF VAR l-cont AS LOGICAL NO-UNDO.

   FOR EACH tt-browse-tela 
       WHERE tt-browse-tela.logpai        = YES 
       AND   tt-browse-tela.tipo-etiqueta = 0:
       ASSIGN l-cont = NO.
       FOR EACH bftt-browse-tela 
           WHERE bftt-browse-tela.it-codigo     = tt-browse-tela.it-codigo 
           AND   bftt-browse-tela.cod-refer     = tt-browse-tela.cod-refer 
           AND   bftt-browse-tela.lote          = tt-browse-tela.lote      
           AND   bftt-browse-tela.logpai        = NO                      
           /*AND   bftt-browse-tela.tipo-etiqueta = 0*/.
           ASSIGN l-cont = YES.
           IF tt-browse-tela.ControlaEtiqueta = YES AND bftt-browse-tela.ControlaEtiqueta = YES THEN  
               ASSIGN tt-browse-tela.tipo-etiqueta   = 2
                      bftt-browse-tela.tipo-etiqueta = 1
                      tt-browse-tela.desc-tipo-etiqueta   = "Agupadora"
                      bftt-browse-tela.desc-tipo-etiqueta = "N∆o Agrupadora".  
           IF tt-browse-tela.ControlaEtiqueta = YES AND bftt-browse-tela.ControlaEtiqueta = NO THEN  
               ASSIGN tt-browse-tela.tipo-etiqueta = 3
                      tt-browse-tela.desc-tipo-etiqueta   = "Agupadora Pr¢pria"
                      bftt-browse-tela.desc-tipo-etiqueta = "N∆o Controlada".
       END.
       IF l-cont = NO THEN
           ASSIGN tt-browse-tela.tipo-etiqueta        = 3
                  tt-browse-tela.desc-tipo-etiqueta   = "Agupadora Pr¢pria".
   END.

&endif.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-BuscaDataValidade wWindow 
PROCEDURE pi-BuscaDataValidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-estab            AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER p-local            AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER p-item             AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER p-lote             AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER p-referencia       AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER p-loc-saida        AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-dt-validade-lote AS DATE       NO-UNDO.


    RUN inbo/boin403.p PERSISTENT SET hinbo403.

    /* Pega o deposito do local do WMS */
    RUN scbo/bosc047.p PERSISTENT SET hbosc047.
    RUN openQueryStatic in hbosc047 (INPUT "Main":U).

    /* Posiciona no documento */
    RUN goToKey IN hbosc047 (INPUT p-estab, 
                             INPUT p-local).
    
    
    IF RETURN-VALUE <> "OK":U THEN DO:
       RETURN "NOK".
    END.

    RUN getCharField IN hbosc047 (INPUT "cod-deposito",
                                  OUTPUT c-cod-depos  ).


    IF VALID-HANDLE (hbosc047) THEN 
        DELETE OBJECT hbosc047.

    /* Posiciona no documento */
    RUN getDataValidade IN hinbo403 (INPUT p-estab,     
                                     INPUT c-cod-depos,
                                     INPUT p-item,
                                     INPUT p-lote,
                                     INPUT p-referencia,
                                     INPUT p-loc-saida,
                                     OUTPUT dtValidadeLote).
    
    IF VALID-HANDLE (hinbo403) THEN 
        DELETE OBJECT hinbo403.
    
    IF dtValidadeLote <> ? THEN DO:
        ASSIGN p-dt-validade-lote = dtValidadeLote. 
    END.
    ELSE DO:
        RETURN "NOK".
    END.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-etiquetas wWindow 
PROCEDURE pi-calcula-etiquetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p-deQtdItem          AS DECIMAL    NO-UNDO. /*Quantidade de itens*/
DEFINE INPUT  PARAMETER p-deQtdItemEmbalagem AS DECIMAL    NO-UNDO. /*Quantidade de item por embalagem*/
DEFINE OUTPUT PARAMETER p-iQtdEmbalagem      AS DECIMAL    NO-UNDO. /*Retorna a quantidade de embalagens*/
DEFINE OUTPUT PARAMETER p-deQtdItemUltimaEmb AS DECIMAL    NO-UNDO. /*Retorna a quantidade de itens na ultima embalagem*/

    ASSIGN p-iQtdEmbalagem      = TRUNCATE((p-deQtdItem / p-deQtdItemEmbalagem),0)
           p-deQtdItemUltimaEmb =  p-deQtdItem - (p-iQtdEmbalagem * p-deQtdItemEmbalagem).
    /* Se a divis∆o n∆o for numero redondo, adiciona mais uma embalagem */
    IF p-deQtdItemUltimaEmb > 0 THEN DO:
        ASSIGN p-iQtdEmbalagem = p-iQtdEmbalagem + 1.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-etiquetas-rf wWindow 
PROCEDURE pi-carrega-etiquetas-rf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-estabel   LIKE wm-docto-itens.cod-estabel      NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-local     LIKE wm-docto-itens.cod-local        NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-item      LIKE wm-docto-itens.cod-item         NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-refer     LIKE wm-docto-itens.cod-refer        NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-lote      LIKE wm-docto-itens.cod-lote         NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-seq-item  LIKE wm-docto-itens.num-seq-item     NO-UNDO.
    DEFINE INPUT  PARAMETER p-qtd-item      LIKE wm-docto-itens.qtd-item         NO-UNDO.
    DEFINE INPUT  PARAMETER p-dt-vali-lote  LIKE wm-docto-itens.dt-validade-lote NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-embalagem.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    EMPTY TEMP-TABLE RowErrors.
    
    FIND FIRST wm-item
        WHERE wm-item.cod-item = p-cod-item NO-LOCK NO-ERROR.
    IF  NOT AVAIL wm-item THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Item" *}
        RUN utp/ut-msgs.p ("show",56, RETURN-VALUE + "~~" + STRING(p-cod-item)).
        RETURN "OK":U.
    END.

    FOR EACH  wm-item-embalagem-local
        WHERE wm-item-embalagem-local.cod-estabel = p-cod-estabel AND
              wm-item-embalagem-local.cod-local   = p-cod-local   AND
              wm-item-embalagem-local.cod-item    = p-cod-item    NO-LOCK:

        FIND FIRST wm-item-embalagem-etiq
             WHERE wm-item-embalagem-etiq.cod-item  = wm-item-embalagem-local.cod-item      AND
                   wm-item-embalagem-etiq.cod-embal = wm-item-embalagem-local.cod-embalagem NO-LOCK NO-ERROR.
        IF AVAIL wm-item-embalagem-etiq THEN DO:
            CREATE tt-embalagem.
            ASSIGN tt-embalagem.codItem            = p-cod-item                                                           
                   tt-embalagem.CodRefer           = p-cod-refer 
                   tt-embalagem.CodLote            = p-cod-lote
                   tt-embalagem.NumSeqItem         = p-num-seq-item
                   tt-embalagem.QtdItem            = p-qtd-item
                   tt-embalagem.DtValidadeLote     = p-dt-vali-lote
                   tt-embalagem.codembalagem       = wm-item-embalagem-etiq.cod-embal                                            
                   tt-embalagem.logPai             = YES                                                                         
                   tt-embalagem.QtdEmbalagem       = 1                                                                           
                   tt-embalagem.QtdItemEmbalagem   = wm-item-embalagem-local.qtd-item-emb                                        
                   tt-embalagem.ControlaEtiqueta   = wm-item-embalagem-etiq.log-controla-et                             
                   tt-embalagem.CodLayoutItem      = integer(wm-item.cod-layout)                                          
                   tt-embalagem.CodBarrasItem      = wm-item.cod-barras                                                  
                   tt-embalagem.CodLayoutEmbalagem = INTEGER(wm-item-embalagem-etiq.cod-layout)                           
                   tt-embalagem.CodBarrasEmbalagem = wm-item-embalagem-etiq.cod-barras.                                   
        END.                                                                                                                     
                                                                                                                          
        FIND FIRST wm-item-embalagem-etiq                                                                                 
             WHERE wm-item-embalagem-etiq.cod-item  = wm-item-embalagem-local.cod-item     AND                            
                   wm-item-embalagem-etiq.cod-embal = wm-item-embalagem-local.cod-emb-item NO-LOCK NO-ERROR.              
        IF AVAIL wm-item-embalagem-etiq THEN DO:
            CREATE tt-embalagem.
            ASSIGN tt-embalagem.codItem            = p-cod-item
                   tt-embalagem.CodRefer           = p-cod-refer    
                   tt-embalagem.CodLote            = p-cod-lote     
                   tt-embalagem.NumSeqItem         = p-num-seq-item 
                   tt-embalagem.QtdItem            = p-qtd-item     
                   tt-embalagem.DtValidadeLote     = p-dt-vali-lote
                   tt-embalagem.cod-emb-pai        = wm-item-embalagem-local.cod-embalagem /* fazer o relacionamento com o pai */
                   tt-embalagem.codembalagem       = wm-item-embalagem-etiq.cod-embal
                   tt-embalagem.logPai             = NO
                   tt-embalagem.QtdEmbalagem       = 1
                   tt-embalagem.QtdItemEmbalagem   = wm-item-embalagem-local.qtd-emb-item
                   tt-embalagem.ControlaEtiqueta   = wm-item-embalagem-etiq.log-controla-et
                   tt-embalagem.CodLayoutItem      = INTEGER(wm-item.cod-layout)
                   tt-embalagem.CodBarrasItem      = wm-item.cod-barras
                   tt-embalagem.CodLayoutEmbalagem = INTEGER(wm-item-embalagem-etiq.cod-layout)
                   tt-embalagem.CodBarrasEmbalagem = wm-item-embalagem-etiq.cod-barras.
        END.                                                                           
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-itens-wms wWindow 
PROCEDURE pi-carrega-itens-wms :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  p-nro-docto  LIKE doc-fisico.nro-docto   NO-UNDO.
    DEFINE INPUT PARAMETER  p-serie      LIKE doc-fisico.serie       NO-UNDO.
    DEFINE INPUT PARAMETER  p-emitente   LIKE doc-fisico.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER  p-tipo-nota  LIKE doc-fisico.tipo-nota    NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-rat-lote.  

    EMPTY TEMP-TABLE tt-rat-lote.

    FIND FIRST doc-fisico NO-LOCK
        WHERE doc-fisico.nro-docto    = p-nro-docto
        AND   doc-fisico.serie-docto  = p-serie
        AND   doc-fisico.cod-emitente = p-emitente
        AND   doc-fisico.tipo-nota    = p-tipo-nota NO-ERROR.
    IF AVAIL DOc-fisico THEN DO:
        FOR EACH it-doc-fisico OF doc-fisico NO-LOCK 
            WHERE it-doc-fisico.baixa-ce = YES 
            AND   it-doc-fisico.nr-ord-prod = 0,
            EACH rat-lote NO-LOCK 
            WHERE rat-lote.nro-docto    = it-doc-fisico.nro-docto    
            AND   rat-lote.serie-docto  = it-doc-fisico.serie-docto  
            AND   rat-lote.cod-emitente = it-doc-fisico.cod-emitente 
            AND   rat-lote.nat-operacao = ""                        
            AND   rat-lote.sequencia    = it-doc-fisico.sequencia    
            AND   rat-lote.tipo-nota    = it-doc-fisico.tipo-nota:

            FIND FIRST deposito NO-LOCK 
            WHERE deposito.cod-depos = rat-lote.cod-depos 
            AND &IF "{&mgscm_version}" >= "2.05" &THEN 
                    deposito.log-gera-wms = YES 
                &ELSE
                    deposito.log-2        = YES 
                &ENDIF NO-ERROR.    
            IF NOT AVAIL deposito THEN DO:
                FIND FIRST wm-local-deposito NO-LOCK
                    WHERE wm-local-deposito.cod-estabel  = doc-fisico.cod-estabel 
                    AND   wm-local-deposito.cod-deposito = rat-lote.cod-depos NO-ERROR.
                IF NOT AVAIL wm-local-deposito THEN DO:
                    NEXT.
                END.    
            END.

            IF CAN-FIND(FIRST item NO-LOCK
                        WHERE item.it-codigo = it-doc-fisico.it-codigo
                        AND ( ITEM.tipo-contr = 4 
                        OR  ( ITEM.tipo-contr = 2 AND it-doc-fisico.conta-contabil <> "" ))) THEN
                NEXT.

            CREATE tt-rat-lote.
            BUFFER-COPY rat-lote TO tt-rat-lote.
            ASSIGN tt-rat-lote.cod-refer = it-doc-fisico.cod-refer.
        END.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desfaz-sugestao wWindow 
PROCEDURE pi-desfaz-sugestao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER pc-estabel   LIKE wm-docto-itens.cod-estabel  NO-UNDO.
    DEF INPUT PARAMETER pc-local     LIKE wm-docto-itens.cod-local    NO-UNDO.
    DEF INPUT PARAMETER pi-id-docto  LIKE wm-docto-itens.id-docto     NO-UNDO.

    IF NOT VALID-HANDLE(hbosc039)               OR  
       hbosc039:TYPE <> "PROCEDURE":U           OR  
       hbosc039:FILE-NAME <> "scbo/bosc039.p":U THEN
       RUN scbo/bosc039.p PERSISTENT SET hbosc039.

    FOR EACH tt-divergencia NO-LOCK.
       EMPTY TEMP-TABLE rowerrors.
       RUN devolucaoDoctoItem IN hbosc039 (INPUT  pc-estabel,
                                           INPUT  pc-local,
                                           INPUT  pi-id-docto,
                                           INPUT  tt-divergencia.num-seq,
                                           OUTPUT TABLE rowerrors).
       FIND FIRST rowerrors NO-ERROR.
       IF AVAIL rowerrors THEN DO:
           {method/showmessage.i1}        
           {method/showmessage.i2}        
           RETURN "NOK":U.
       END.  
    END.

    IF VALID-HANDLE(hbosc039) THEN 
       DELETE OBJECT hbosc039.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desfaz-sugestao-ckd wWindow 
PROCEDURE pi-desfaz-sugestao-ckd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER pc-estabel   LIKE wm-docto-itens.cod-estabel  NO-UNDO.
    DEF INPUT PARAMETER pc-local     LIKE wm-docto-itens.cod-local    NO-UNDO.
    DEF INPUT PARAMETER pi-id-docto  LIKE wm-docto-itens.id-docto     NO-UNDO.

    IF NOT VALID-HANDLE(hbosc039)               OR  
       hbosc039:TYPE <> "PROCEDURE":U           OR  
       hbosc039:FILE-NAME <> "scbo/bosc039.p":U THEN
       RUN scbo/bosc039.p PERSISTENT SET hbosc039.

    FOR EACH tt-browse-tela NO-LOCK.
       EMPTY TEMP-TABLE rowerrors.
       RUN devolucaoDoctoItem IN hbosc039 (INPUT  pc-estabel,
                                           INPUT  pc-local,
                                           INPUT  pi-id-docto,
                                           INPUT  tt-browse-tela.num-seq,
                                           OUTPUT TABLE rowerrors).
       FIND FIRST rowerrors NO-ERROR.
       IF AVAIL rowerrors THEN DO:
           {method/showmessage.i1}        
           {method/showmessage.i2}        
           RETURN "NOK":U.
       END.  
    END.

    IF VALID-HANDLE(hbosc039) THEN 
       DELETE OBJECT hbosc039.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-eh-docto-entrada wWindow 
PROCEDURE pi-eh-docto-entrada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mgcld_version}" >= "2.04" &THEN
    DEFINE OUTPUT PARAMETER p-lEhDoctoEntrada AS LOGICAL INITIAL NO   NO-UNDO.
    DEFINE VARIABLE iIndTipoTrans AS INTEGER    NO-UNDO. 

    /* Abre a query da bo */
    RUN openQueryStatic IN hbosc038 (INPUT "Main":U). 
    /* Posiciona no documento */

    RUN goToKey IN hbosc038 (INPUT tt-browse-tela.cod-estabel,
                             INPUT tt-browse-tela.cod-local,
                             INPUT TODAY,
                             INPUT tt-browse-tela.id-docto).
    IF RETURN-VALUE = "NOK":U THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Documento" *}
        RUN utp/ut-msgs.p ("SHOW", 2, RETURN-VALUE).
        RETURN 'NOK'.
    END.

    RUN getRecord IN hbosc038 (OUTPUT TABLE ttWm-docto).
    FIND FIRST ttWm-docto NO-ERROR.
    
    ASSIGN iIndTipoTrans = ttwm-Docto.ind-tipo-trans
           deCarga       = ttwm-Docto.id-carga.

    /* Se for documento de entrada (1), retorna yes */
    IF iIndTipoTrans = 1 THEN 
        ASSIGN p-lEhDoctoEntrada = YES.
&endif    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-carga wWindow 
PROCEDURE pi-gera-carga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&if '{&mgscm_version}' >= '2.04' &then
    DEFINE VARIABLE lEhDoctoEntrada AS LOGICAL    NO-UNDO. /*Retorna se eh docto entrada*/
    
    RUN openQueryStatic IN hbosc075 (INPUT "Main":U). 
    /* Retorna se o que foi digitiado ˝ um documento e ˝ de entrada  */
    RUN pi-eh-docto-entrada (OUTPUT lEhDoctoEntrada).

    /* Se jò existe a carga, n o tem necessidade de pegar uma nova carga */
    IF deCarga > 0 THEN DO:
        RETURN 'ok'.
    END.

    /* Se n o existe a carga, e for documento de entrada, cria uma nova carga */
    IF lEhDoctoEntrada = YES THEN DO:
        /* Verificar se para cada */
        FOR EACH ttWm-carga.
            DELETE ttWm-carga.
        END.
        CREATE ttWm-carga.           
        /* Atribui os valores padroes */
        ASSIGN ttWm-carga.id-carga          = 0
               ttWm-carga.dt-geracao        = TODAY
               ttWm-carga.cod-usuario       = ""
               ttWm-carga.ind-enviado-mp    = 1  
               ttWm-carga.hr-geracao        = TIME.

        IF VALID-HANDLE(hbosc038) THEN DO:
        RUN getintField IN hbosc038 ("ind-origem-docto":U  , OUTPUT ttWm-carga.ind-origem-docto ).
        END.

        /* Busca o usuario */
        RUN getUsuario IN hbosc075 (OUTPUT ttWm-carga.cod-usuario).
        
        /* busca a proxima sequencia do serial */
        ASSIGN deCarga = 0.
        RUN geraSeqCarga IN hbosc075 (OUTPUT ttWm-carga.id-carga).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN hbosc075 (OUTPUT TABLE RowErrors).
            {method/showmessage.i1}        
            {method/showmessage.i2}        
            RETURN 'nok'.
        END.

        /* Salva a nova carga */
        RUN emptyRowErrors IN hbosc075.
        RUN setRecord      IN hbosc075 (INPUT TABLE ttWm-carga).
        RUN createRecord   IN hbosc075.
        RUN getRowErrors   IN hbosc075 (OUTPUT TABLE RowErrors).

        /* Verifica se teve erros */
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2}                                                    
            RETURN 'nok'.
        END.
    END.

    /* Atualiza a carga gerada no documento */
    ASSIGN deCarga = ttWm-carga.id-carga.
    RUN pi-atualiza-docto.

    RETURN 'OK':U.
&endif.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-carga-rf wWindow 
PROCEDURE pi-gera-carga-rf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE pCarga    AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE l-conf-ok AS LOGICAL     NO-UNDO.

    IF NOT VALID-HANDLE(hboin089) THEN
        RUN inbo/boin089.p PERSISTENT SET hboin089.
    RUN openQueryStatic IN hboin089(INPUT "Main":U).
    RUN goToKey IN hboin089 (INPUT rf-serie,
                             INPUT rf-numero,
                             INPUT rf-emitente,
                             INPUT i-tp-nota).
    IF RETURN-VALUE = "NOK":U THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Docto_Rec_F°sico" *}
        RUN utp/ut-msgs.p ("SHOW", 2, RETURN-VALUE).
        RETURN 'NOK'.
    END.                                               
    RUN getRecord IN hboin089 (OUTPUT TABLE ttdoc-fisico).
    FIND FIRST ttdoc-fisico NO-ERROR.

    /* Verificar se j† existe carga */
    IF NOT VALID-HANDLE(hbosc075) THEN
        RUN scbo/bosc075.p PERSISTENT SET hbosc075.
    RUN openQueryStatic    IN hbosc075(INPUT "Main":U).
    
    RUN getStatusConferenciaCarga IN hbosc075(INPUT ttdoc-fisico.nro-docto,
                                              INPUT ttdoc-fisico.serie-docto,
                                              INPUT ttdoc-fisico.tipo-nota,
                                              INPUT ttdoc-fisico.cod-emitente,
                                              INPUT ttdoc-fisico.dt-trans,
                                              OUTPUT l-conf-ok,
                                              OUTPUT pCarga).
    IF pCarga > 0  THEN DO:
        ASSIGN deCarga = pCarga.
        RETURN "OK":U.
    END.
    
    FOR EACH ttWm-carga.
        DELETE ttWm-carga.
    END.
    CREATE ttWm-carga.           
    /* Atribui os valores padroes */
    ASSIGN ttWm-carga.id-carga          = 0
           ttWm-carga.dt-geracao        = TODAY
           ttWm-carga.cod-usuario       = ""
           ttWm-carga.ind-enviado-mp    = 1  
           ttWm-carga.hr-geracao        = TIME
        &IF '{&mgscm_version}' >= '2.08' &THEN
           ttWm-carga.ind-origem-docto = 3  
           ttWm-carga.num-docto-origem = STRING(rf-serie,"x(5)") + STRING(rf-numero, "x(16)") + STRING(rf-emitente, ">>>>>>>>9") + STRING(i-tp-nota, ">9")
        &ELSE 
            ttWm-carga.int-1           = 3
            ttWm-carga.char-1          = STRING(rf-serie,"x(5)") + STRING(rf-numero, "x(16)") + STRING(rf-emitente, ">>>>>>>>9") + STRING(i-tp-nota, ">9")
        &ENDIF                                                                                                             
        .
        
    /* Busca o usuario */
    RUN getUsuario IN hbosc075 (OUTPUT ttWm-carga.cod-usuario).
    
    /* busca a proxima sequencia do serial */
    ASSIGN deCarga = 0.
    RUN geraSeqCarga IN hbosc075 (OUTPUT ttWm-carga.id-carga).
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN getRowErrors IN hbosc075 (OUTPUT TABLE RowErrors).
        {method/showmessage.i1}        
        {method/showmessage.i2}        
        RETURN 'nok'.
    END.

    /* Salva a nova carga */
    RUN emptyRowErrors IN hbosc075.
    RUN setRecord      IN hbosc075 (INPUT TABLE ttWm-carga).
    RUN createRecord   IN hbosc075.
    RUN getRowErrors   IN hbosc075 (OUTPUT TABLE RowErrors).

    /* Verifica se teve erros */
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2}                                                    
        RETURN 'nok'. 
    END.
    
    ASSIGN deCarga = ttWm-carga.id-carga.

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-etiqueta-dc wWindow 
PROCEDURE pi-gera-etiqueta-dc :
/*------------------------------------------------------------------------------
  Purpose:     Cria uma bc-etiqueta. Apenas guarda a referencia da wm-etiqueta
  Parameters:  Passa o serial criado
  Notes:       
------------------------------------------------------------------------------*/
&if '{&mgscm_version}' >= '2.04' &then
    DEFINE INPUT PARAMETER p-deSerial   AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAMETER p-dep-saida  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-loc-saida  AS CHARACTER NO-UNDO.

    CREATE bc-etiqueta NO-ERROR.
    ASSIGN bc-etiqueta.ativo            = YES
           bc-etiqueta.dt-criacao       = TODAY
           bc-etiqueta.hr-criacao       = STRING(TIME,"hh:mm:ss")
           bc-etiqueta.usuar-criacao    = c-seg-usuario
           bc-etiqueta.cod-depos        = p-dep-saida
           bc-etiqueta.cod-local        = p-loc-saida
           bc-etiqueta.progressivo      = STRING(p-deSerial)
           bc-etiqueta.nr-ord-prod      = tt-browse-tela.nr-ord-produ 
           bc-etiqueta.dt-validade      = tt-browse-tela.dt-validade-lote
           bc-etiqueta.it-codigo        = tt-browse-tela.it-codigo
           bc-etiqueta.refer            = tt-browse-tela.cod-refer
           bc-etiqueta.lote             = tt-browse-tela.lote
           bc-etiqueta.cod-estado       = 1 /* criada  */
           bc-etiqueta.id-docto         = tt-browse-tela.id-docto
           bc-etiqueta.sequencia-docto  = tt-browse-tela.num-seq
           bc-etiqueta.log-datasul      = YES
           bc-etiqueta.num-versao       = 1
           bc-etiqueta.cod-layout       = tt-browse-tela.layout-etiqueta.
&endif.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-etiqueta-docto wWindow 
PROCEDURE pi-gera-etiqueta-docto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iContBrowser                AS INTEGER NO-UNDO. /*contador dos registros no browser*/
    DEFINE VARIABLE iContEtiquetas              AS INTEGER NO-UNDO. /*contador de etiquetas a serem impressas*/
    DEFINE VARIABLE deSerial                    AS DECIMAL NO-UNDO. /*Armazena o serial gerado pelo wms*/
    DEFINE VARIABLE deCarga                     AS DECIMAL NO-UNDO. /* Armazena a carga gerada */
    DEFINE VARIABLE deQuantidadeItemNaEmbalagem AS DECIMAL NO-UNDO. /*Qtd item na embalagem*/
    DEFINE VARIABLE cmensagem                   AS CHAR    NO-UNDO.
    DEFINE BUFFER b-tt-browse-tela              FOR tt-browse-tela.
    DEFINE VARIABLE c-cod-estabel               AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-local                     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE de-docto                    LIKE wm-docto.num-docto NO-UNDO.
  /*  DEFINE VARIABLE c-item                      AS CHARACTER NO-UNDO.*/
    DEFINE VARIABLE c-serial-pai                LIKE ttSerial.de-serial NO-UNDO.
        DEFINE VARIABLE c-contagem                                      AS INTEGER NO-UNDO.
        DEFINE VARIABLE numero-pedido                           AS CHAR NO-UNDO.

    /* Iniciando tela de acompanhamento */
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp. 
    {utp/ut-liter.i Imprimindo... *}
    RUN pi-inicializar IN h-acomp (RETURN-VALUE). 
    {utp/ut-liter.i Gerando_impress∆o... *}
    RUN pi-acompanhar IN h-acomp (RETURN-VALUE). 
/*
    {utp/ut-liter.i "Houveram_erros_na_geraá∆o_da_etiqueta_no_M¢dulo_WMS MBC"}
    ASSIGN cmensagem = RETURN-VALUE.    */         

    ASSIGN deCarga = 0.
        ASSIGN c-contagem = 0.
        
        FOR EACH b-tt-browse-tela WHERE b-tt-browse-tela.marca = YES NO-LOCK:
                ASSIGN c-contagem = c-contagem + 1.
        END.

    FIND FIRST b-tt-browse-tela NO-LOCK NO-ERROR.

    IF AVAIL b-tt-browse-tela THEN
       FIND FIRST ITEM WHERE ITEM.it-codigo = b-tt-browse-tela.it-codigo NO-LOCK NO-ERROR.

    IF AVAIL ITEM THEN
       FIND FIRST in-grup-estoq WHERE in-grup-estoq.ge-codigo = item.ge-codigo NO-LOCK NO-ERROR.
    
    ASSIGN l-ckd        = NO.
        ASSIGN c-contagem       = 0.
        ASSIGN numero-pedido = ''.

    IF AVAIL in-grup-estoq 
    AND in-grup-estoq.log-ckd THEN DO:
        
                IF c-contagem > 3 THEN DO:
                
                        ASSIGN numero-pedido = REPLACE(b-tt-browse-tela.lote,"PO","").
                        ASSIGN numero-pedido = REPLACE(numero-pedido, "VLAN", "").
                        ASSIGN numero-pedido = REPLACE(numero-pedido, "Q+", "").
                        ASSIGN numero-pedido = REPLACE(numero-pedido, "VLAN ULTRA", "").
                        ASSIGN numero-pedido = REPLACE(numero-pedido, "Q+ ULTRA", "").
                        ASSIGN numero-pedido = REPLACE(numero-pedido, "IWR 3000", "").
                        ASSIGN numero-pedido = REPLACE(numero-pedido, "IWR 1000", "").
                        ASSIGN numero-pedido = REPLACE(numero-pedido, "RE 301", "").
        
                        FIND FIRST int-pedido-compr WHERE int-pedido-compr.num-pedido = int(numero-pedido) NO-LOCK NO-ERROR.

                        ASSIGN c-cod-estabel = b-tt-browse-tela.cod-estabel   
                                   i-id-docto    = 0    
                                   c-local       = b-tt-browse-tela.cod-local
                                   c-item-ckd    = IF AVAIL int-pedido-compr THEN int-pedido-compr.cod-produto-ckd ELSE ""
                                   l-ckd         = YES.

                        RUN returnImpressaoEtiqueta IN hbosc074 (INPUT c-cod-estabel,
                                                                                                         INPUT c-local,
                                                                                                         INPUT i-id-docto,
                                                                                                         INPUT c-item-ckd,
                                                                                                         OUTPUT TABLE tt-embalagem,
                                                                                                         OUTPUT TABLE rowerrors) .

                        /* Nao Gerou Nenhum Registro */
                        IF RETURN-VALUE <> "OK":U THEN DO:
                                FIND FIRST rowErrors NO-ERROR.
                                IF AVAIL rowErrors THEN DO:
                                        {method/showmessage.i1}        
                                        {method/showmessage.i2}        
                                END.    
                                RETURN "NOK":U.
                        END.
                        
                        FIND FIRST tt-embalagem NO-LOCK NO-ERROR.

                        CREATE tt-browse-tela.
                        ASSIGN tt-browse-tela.cod-estabel        = b-tt-browse-tela.cod-estabel       
                                   tt-browse-tela.id-docto           = b-tt-browse-tela.id-docto          
                                   tt-browse-tela.cod-local          = b-tt-browse-tela.cod-local         
                                   tt-browse-tela.num-seq            = b-tt-browse-tela.num-seq - 1      
                                   /*tt-browse-tela.lote               = b-tt-browse-tela.lote*/
                                   tt-browse-tela.cod-embalagem      = tt-embalagem.codEmbalagem      
                                   tt-browse-tela.cod-refer          = tt-embalagem.cODrefer         
                                   tt-browse-tela.it-codigo          = c-item-ckd     
                                   tt-browse-tela.lote               = tt-embalagem.cODlote              
                                   tt-browse-tela.lote               = b-tt-browse-tela.lote
                                   tt-browse-tela.qtd-item           = IF AVAIL int-pedido-compr THEN int-pedido-compr.qtd-pedido-ckd ELSE 1           
                                   tt-browse-tela.qtd-item-embalagem = tt-embalagem.QtdItemEmbalagem      
                                   tt-browse-tela.qtd-etiqueta       = tt-embalagem.QtdEmbalagem               
                                   tt-browse-tela.cod-usuario        = b-tt-browse-tela.cod-usuario       
                                   tt-browse-tela.qtd-peso-item      = b-tt-browse-tela.qtd-peso-item     
                                   tt-browse-tela.logPai             = tt-embalagem.logPai            
                                   tt-browse-tela.ControlaEtiqueta   = tt-embalagem.ControlaEtiqueta  
                                   tt-browse-tela.layout-etiqueta    = tt-embalagem.CodLayoutEmbalagem   
                                   tt-browse-tela.dt-validade-lote   = IF tt-embalagem.DtValidadeLote = ? THEN b-tt-browse-tela.dt-validade-lote ELSE tt-embalagem.DtValidadeLote 
                                   tt-browse-tela.cod-ean            = STRING(tt-embalagem.codBARRASITEM)                
                                   tt-browse-tela.cod-dun            = STRING(tt-embalagem.codbarrasembalagem) 
                                   tt-browse-tela.marca              = YES
                                   tt-browse-tela.tipo-etiqueta      = 2.
                END.
        END.

    EMPTY TEMP-TABLE ttSerial.

    IF NOT VALID-HANDLE(hbosc050) THEN
        RUN scbo/bosc050.p PERSISTENT SET hbosc050.

    FOR EACH tt-browse-tela 
       WHERE tt-browse-tela.marca = YES
         AND tt-browse-tela.ControlaEtiqueta = YES
          BY tt-browse-tela.num-seq:
        /* Gera um serial de etiqueta */    
        RUN geraSeqEtiqueta IN hbosc050 (OUTPUT TABLE ttSerialAux, INPUT tt-browse-tela.qtd-etiqueta).
        FOR EACH ttSerialAux:
            CREATE ttSerial.
            ASSIGN ttSerial.de-serial = ttSerialAux.de-serial.
        END.
    END.

    /* Nío gerou nenhum registro */
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN GetRowErrors IN hbosc050 (OUTPUT TABLE RowErrors).
        RUN DESTROY IN hbosc050.
        RETURN "NOK":U.
    END.

    IF NOT AVAIL ttSerial THEN DO:
        /* Houveram erros na geracao da etiqueta no MΩdulo WMS */
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 55847,
                           INPUT ""). /*Erro na geraá∆o de Etiquetas*/
        RUN pi-finalizar IN h-acomp.                                         
        RETURN "NOK":U. /*Se retornou erro, nao gera bc-etiqueta*/

    END.
    ELSE
    
        /* Imprime todas os registros selecionados no browse */
        DO TRANSACTION ON ERROR UNDO, LEAVE:

            FOR EACH tt-browse-tela 
               WHERE tt-browse-tela.marca = YES
                  BY tt-browse-tela.num-seq:
                
/* MESSAGE tt-browse-tela.it-codigo          "/"                                 */
/*         tt-browse-tela.cod-refer          "/"                                 */
/*         tt-browse-tela.lote               "/"                                 */
/*         tt-browse-tela.qtd-item           "/"                                 */
/*         tt-browse-tela.qtd-item-embalagem "/"                                 */
/*         tt-browse-tela.qtd-etiqueta       "/"                                 */
/*         tt-browse-tela.qtd-ult-embalagem  "/"                                 */
/*         tt-browse-tela.qtd-peso-item      "/"                                 */
/*         tt-browse-tela.layout-etiqueta    "/"                                 */
/*         tt-browse-tela.cod-ean            "/"                                 */
/*         tt-browse-tela.cod-dun            "/"                                 */
/*         tt-browse-tela.cod-depos          "/"                                 */
/*         tt-browse-tela.cod-local          "/"                                 */
/*         tt-browse-tela.id-docto           "/"                                 */
/*         tt-browse-tela.nr-ord-produ       "/"                                 */
/*         tt-browse-tela.cod-cliente        "/"                                 */
/*         tt-browse-tela.nome-abrev         "/"                                 */
/*         tt-browse-tela.cod-emb-pai        "/"                                 */
/*         tt-browse-tela.cod-embalagem      "/"                                 */
/*         tt-browse-tela.cod-usuario        "/"                                 */
/*         tt-browse-tela.cod-estabel        "/"                                 */
/*         tt-browse-tela.num-seq            "/"                                 */
/*         "tt-browse-tela.tipo-etiqueta=" tt-browse-tela.tipo-etiqueta      "/" */
/*         tt-browse-tela.desc-tipo-etiqueta "/"                                 */
/*         tt-browse-tela.dt-validade-lote   "/"                                 */
/*         tt-browse-tela.logPai             "/"                                 */
/*         tt-browse-tela.ControlaEtiqueta   "/"                                 */
/*         tt-browse-tela.marca              "/"                                 */
/*         tt-browse-tela.id-movto                                               */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.                                        */

                /* Se for um documento, executa funcao de carga no wms. */
                RUN pi-gera-carga.
                IF RETURN-VALUE = 'nok' THEN 
                    RETURN ERROR.
            
                /* Gera a impressao para cada qtd-etiqueta */
                DO iContEtiquetas = 1 TO tt-browse-tela.qtd-etiqueta:
    
                    IF tt-browse-tela.tipo-etiqueta <> 0 THEN
                        FIND FIRST ttSerial NO-ERROR.
    
                    if l-ckd then do:
                    
                        IF  tt-browse-tela.num-seq = 9 THEN 
                            ASSIGN c-serial-pai = ttSerial.de-serial.
                        ELSE DO:
    
                            /* MESSAGE ttSerial.de-serial tt-browse-tela.tipo-etiqueta tt-browse-tela.num-seq 
                                 VIEW-AS ALERT-BOX INFO BUTTONS OK. */
    
                                FIND FIRST in-agrup-etiqueta WHERE in-agrup-etiqueta.id-etiqueta-pai  = c-serial-pai 
                                                               AND in-agrup-etiqueta.id-etiqueta-filho = ttSerial.de-serial NO-LOCK NO-ERROR.
                                IF  NOT AVAIL in-agrup-etiqueta THEN DO:
                                    CREATE in-agrup-etiqueta.
                                    ASSIGN in-agrup-etiqueta.id-etiqueta-pai  = c-serial-pai       
                                           in-agrup-etiqueta.id-etiqueta-filho = ttSerial.de-serial.
                                END.
                        END.
    
                    END.

                    RUN pi-acompanhar IN h-acomp (tt-browse-tela.it-codigo + " - " + STRING(iContEtiquetas)). 
                    /* Soh cria o registro se for diferente de zero */
                    IF (tt-browse-tela.tipo-etiqueta <> 0) and (tt-browse-tela.ControlaEtiqueta) THEN DO:     
                        /*/* Pega a qtd de item na embalagem, caso seja a ultima embalagem */
                        IF tt-browse-tela.qtd-etiqueta = iContEtiquetas AND  tt-browse-tela.qtd-ult-embalagem > 0 THEN DO:
                            ASSIGN deQuantidadeItemNaEmbalagem = tt-browse-tela.qtd-ult-embalagem.
                        END.
                        ELSE DO:
                            ASSIGN deQuantidadeItemNaEmbalagem = tt-browse-tela.qtd-item-embalagem.
                        END.*/
    
                        ASSIGN deQuantidadeItemNaEmbalagem = tt-browse-tela.qtd-item.
                        
                            /* Gera a wm-etiqueta */
                            RUN pi-gera-etiqueta-wms(INPUT deQuantidadeItemNaEmbalagem, 
                                                     INPUT 3, /*Documento WMS*/
                                                     INPUT ttSerial.de-serial).
                          
                            IF RETURN-VALUE = 'nok' OR ttSerial.de-serial = 0 THEN DO:
                                /* Houveram erros na geracao da etiqueta no MΩdulo WMS */
                                RUN utp/ut-msgs.p (INPUT "show",
                                                   INPUT 18475,
                                                   INPUT ""). /*Erro na geraá∆o de Etiquetas*/           
                                RETURN ERROR. /*Se retornou erro, nao gera bc-etiqueta*/
                            END.
                            /* Gera a bc-etiqueta */
                            RUN pi-gera-etiqueta-dc (INPUT ttSerial.de-serial,
                                                     INPUT "",
                                                     INPUT "").
                       
                    END.
            
                    IF (tt-browse-tela.tipo-etiqueta <> 0) and (tt-browse-tela.ControlaEtiqueta) THEN DO:
                        /* Gera a transacao de impressao no datacollection */
                        RUN pi-gera-impressao (INPUT ttSerial.de-serial, 
                                               INPUT deQuantidadeItemNaEmbalagem, 
                                               INPUT 1).
                        
                    END.
                    ELSE DO:
                        /* Gera a transacao de impressao no datacollection */
                        ASSIGN deQuantidadeItemNaEmbalagem = tt-browse-tela.qtd-item-embalagem.
                        RUN pi-gera-impressao (INPUT deSerial, 
                                               INPUT deQuantidadeItemNaEmbalagem, 
                                               INPUT tt-browse-tela.qtd-etiqueta).
                        LEAVE.
                    END.
                    IF tt-browse-tela.tipo-etiqueta <> 0 THEN
                        DELETE ttSerial.  
                    IF RETURN-VALUE <> "OK":U THEN RETURN ERROR.  
                END.                                           
            END.

            FOR EACH tt-browse-tela
                WHERE tt-browse-tela.marca = YES:

                run createMovtoEtiquetaDocWms in hbosc112 (INPUT dc-estab:SCREEN-VALUE IN FRAME fPage3,
                                                           INPUT dc-local:SCREEN-VALUE IN FRAME fPage3,
                                                           INPUT tt-browse-tela.id-docto,
                                                           INPUT tt-browse-tela.num-seq,
                                                           OUTPUT TABLE rowerrors).
            END.
/* MESSAGE "l-ckd= " l-ckd                                                                           */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                            */
            /*IF l-ckd THEN DO:
                FIND FIRST tt-browse-tela NO-LOCK NO-ERROR.
                run pi-desfaz-sugestao-ckd (INPUT dc-estab:SCREEN-VALUE IN FRAME fPage3,
                                            INPUT dc-local:SCREEN-VALUE IN FRAME fPage3,
                                            INPUT tt-browse-tela.id-docto).
                FIND FIRST tt-browse-tela NO-LOCK NO-ERROR.
                run pi-realizar-sugestao-ckd (INPUT dc-estab:SCREEN-VALUE IN FRAME fPage3,
                                              INPUT dc-local:SCREEN-VALUE IN FRAME fPage3,
                                              INPUT tt-browse-tela.id-docto).
            END.*/
/*                                                                                                   */
/*                                                                                                   */

        END. /*DO TRANSACTION ON ERROR UNDO, LEAVE:*/

    ASSIGN l-ckd = NO.
    RELEASE bc-etiqueta.
    RUN pi-finalizar IN h-acomp. 
    EMPTY TEMP-TABLE tt-browse-tela.
    {&OPEN-QUERY-br-dc-tela}
    IF VALID-HANDLE(h-acomp) THEN DELETE OBJECT h-acomp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-etiqueta-it wWindow 
PROCEDURE pi-gera-etiqueta-it :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iContBrowser                AS INTEGER NO-UNDO. /*contador dos registros no browser*/
    DEFINE VARIABLE iContEtiquetas              AS INTEGER NO-UNDO. /*contador de etiquetas a serem impressas*/
    DEFINE VARIABLE deSerial                    AS DECIMAL NO-UNDO. /*Armazena o serial gerado pelo wms*/
    DEFINE VARIABLE deCarga                     AS DECIMAL NO-UNDO. /* Armazena a carga gerada */
    DEFINE VARIABLE deQuantidadeItemNaEmbalagem AS DECIMAL NO-UNDO. /*Qtd item na embalagem*/
    DEFINE VARIABLE cmensagem                   AS CHAR    NO-UNDO.

    /* Iniciando tela de acompanhamento */
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp. 
    {utp/ut-liter.i Imprimindo... *}
    RUN pi-inicializar IN h-acomp (RETURN-VALUE). 
    {utp/ut-liter.i Gerando_impress∆o... *}
    RUN pi-acompanhar IN h-acomp (RETURN-VALUE). 

    /*{utp/ut-liter.i "Houveram_erros_na_geraá∆o_da_etiqueta_no_M¢dulo_WMS MBC"}
    ASSIGN cmensagem = RETURN-VALUE.             */

    ASSIGN deCarga = 0.

    EMPTY TEMP-TABLE ttSerial.

    IF NOT VALID-HANDLE(hbosc050) THEN
        RUN scbo/bosc050.p PERSISTENT SET hbosc050.

   
    FOR EACH tt-browse-tela 
       WHERE tt-browse-tela.marca = YES
         AND tt-browse-tela.ControlaEtiqueta = YES:

        /* Gera um serial de etiqueta */    
        RUN geraSeqEtiqueta IN hbosc050 (OUTPUT TABLE ttSerialAux, INPUT tt-browse-tela.qtd-etiqueta).
        FOR EACH ttSerialAux:
            CREATE ttSerial.
            ASSIGN ttSerial.de-serial = ttSerialAux.de-serial.
        END.
    END.
    
    
    /* N o gerou nenhum registro */
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN GetRowErrors IN hbosc050 (OUTPUT TABLE RowErrors).
        RUN DESTROY IN hbosc050.
        RETURN "NOK":U.
    END.

    if avail ttSerial then do:
        /* Imprime todas os registros selecionados no browse */
        DO TRANSACTION ON ERROR UNDO, LEAVE:
            DO iContBrowser = 1 TO INT(br-it-tela:NUM-SELECTED-ROWS IN FRAME fPage2) :
                /* Navega pelo browse */
                br-it-tela:FETCH-SELECTED-ROW(iContBrowser) NO-ERROR.                 
                /* Gera a impressao para cada qtd-etiqueta */
                DO iContEtiquetas = 1 TO tt-browse-tela.qtd-etiqueta:
                    IF tt-browse-tela.tipo-etiqueta <> 0 THEN
                        FIND FIRST ttSerial NO-ERROR.
                    RUN pi-acompanhar IN h-acomp (tt-browse-tela.it-codigo + " - " + STRING(iContEtiquetas)). 
                    /* Soh cria o registro se for diferente de zero */
                    IF (tt-browse-tela.tipo-etiqueta <> 0) and (tt-browse-tela.ControlaEtiqueta) THEN DO:     
                        /* Pega a qtd de item na embalagem, caso seja a ultima embalagem */
                        /*IF tt-browse-tela.qtd-etiqueta = iContEtiquetas AND  tt-browse-tela.qtd-ult-embalagem > 0 THEN DO:
                            ASSIGN deQuantidadeItemNaEmbalagem = tt-browse-tela.qtd-ult-embalagem.
                        END.
                        ELSE DO:
                            ASSIGN deQuantidadeItemNaEmbalagem = tt-browse-tela.qtd-item-embalagem.
                        END.*/
    
                        ASSIGN deQuantidadeItemNaEmbalagem = tt-browse-tela.qtd-item.
    
                        /* Gera a wm-etiqueta */
                        RUN pi-gera-etiqueta-wms(INPUT deQuantidadeItemNaEmbalagem, 
                                                 INPUT 2, /*Item*/
                                                 INPUT ttSerial.de-serial).
    
                        IF RETURN-VALUE = 'nok' OR ttSerial.de-serial = 0 THEN DO:
                            /* Houveram erros na geracao da etiqueta no MΩdulo WMS */
                            RUN utp/ut-msgs.p (INPUT "show",
                                               INPUT 18475,
                                               INPUT ""). /*Erro na geraá∆o de Etiquetas*/              
                            RETURN ERROR. /*Se retornou erro, nao gera bc-etiqueta*/
                        END.
                        /* Gera a bc-etiqueta */
                        RUN pi-gera-etiqueta-dc (INPUT ttSerial.de-serial,
                                                 INPUT it-dep-saida:SCREEN-VALUE IN FRAME fPage2,
                                                 INPUT it-loc-saida:SCREEN-VALUE IN FRAME fPage2).
                    END.
                    
                    IF (tt-browse-tela.tipo-etiqueta <> 0) and (tt-browse-tela.ControlaEtiqueta) THEN DO:
                        /* Gera a transacao de impressao no datacollection */
                        RUN pi-gera-impressao (INPUT ttSerial.de-serial, 
                                               INPUT deQuantidadeItemNaEmbalagem, 
                                               INPUT 1).
                    END.
                    ELSE DO:
                        /* Gera a transacao de impressao no datacollection */
                        ASSIGN deQuantidadeItemNaEmbalagem = tt-browse-tela.qtd-item-embalagem.
                        RUN pi-gera-impressao (INPUT deSerial, 
                                               INPUT deQuantidadeItemNaEmbalagem, 
                                               INPUT tt-browse-tela.qtd-etiqueta).
                        LEAVE.
                    END.
                    IF tt-browse-tela.tipo-etiqueta <> 0 THEN
                        DELETE ttSerial.
                    IF RETURN-VALUE <> "OK":U THEN RETURN ERROR.
                END.                                           
            END.
    
            RUN createMovtoEtiqueta IN hbosc112 (INPUT it-estab:SCREEN-VALUE IN FRAME fPage2,
                                                 INPUT it-local:SCREEN-VALUE IN FRAME fPage2,
                                                 INPUT tt-browse-tela.id-docto,
                                                 OUTPUT TABLE rowerrors).      
        END.
    end.
    else do:
        /* Houveram erros na geracao da etiqueta no MΩdulo WMS */
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 55847,
                           INPUT ""). /*Erro na geraá∆o de Etiquetas*/
        RUN pi-finalizar IN h-acomp.                                         
        RETURN "NOK":U. /*Se retornou erro, nao gera bc-etiqueta*/
    end.    
    
    RELEASE bc-etiqueta.
    RUN pi-finalizar IN h-acomp. 
    EMPTY TEMP-TABLE tt-browse-tela.
    {&OPEN-QUERY-br-it-tela}
    IF VALID-HANDLE(h-acomp) THEN DELETE OBJECT h-acomp.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-etiqueta-op wWindow 
PROCEDURE pi-gera-etiqueta-op :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iContBrowser                AS INTEGER NO-UNDO. /*contador dos registros no browser*/
    DEFINE VARIABLE iContEtiquetas              AS INTEGER NO-UNDO. /*contador de etiquetas a serem impressas*/
    DEFINE VARIABLE deSerial                    AS DECIMAL NO-UNDO. /*Armazena o serial gerado pelo wms*/
    DEFINE VARIABLE deCarga                     AS DECIMAL NO-UNDO. /* Armazena a carga gerada */
    DEFINE VARIABLE deQuantidadeItemNaEmbalagem AS DECIMAL NO-UNDO. /*Qtd item na embalagem*/
    DEFINE VARIABLE cmensagem                   AS CHAR    NO-UNDO.

    /* Iniciando tela de acompanhamento */
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp. 
    {utp/ut-liter.i Imprimindo... *}
    RUN pi-inicializar IN h-acomp (RETURN-VALUE). 
    {utp/ut-liter.i Gerando_impress∆o... *}
    RUN pi-acompanhar IN h-acomp (RETURN-VALUE). 

    /*{utp/ut-liter.i "Houveram_erros_na_geraá∆o_da_etiqueta_no_M¢dulo_WMS MBC"}
    ASSIGN cmensagem = RETURN-VALUE.             */

    ASSIGN deCarga = 0.

    EMPTY TEMP-TABLE ttSerial.

    IF NOT VALID-HANDLE(hbosc050) THEN
        RUN scbo/bosc050.p PERSISTENT SET hbosc050.

    FOR EACH tt-browse-tela 
       WHERE tt-browse-tela.marca = YES
         AND tt-browse-tela.ControlaEtiqueta = YES:
        /* Gera um serial de etiqueta */    
        RUN geraSeqEtiqueta IN hbosc050 (OUTPUT TABLE ttSerialAux, INPUT tt-browse-tela.qtd-etiqueta).
        FOR EACH ttSerialAux:
            CREATE ttSerial.
            ASSIGN ttSerial.de-serial = ttSerialAux.de-serial.
        END.
    END.
    
    /* N“o gerou nenhum registro */
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN GetRowErrors IN hbosc050 (OUTPUT TABLE RowErrors).
        RUN DESTROY IN hbosc050.
        RETURN "NOK":U.
    END.

    IF NOT AVAIL ttSerial THEN DO:
        /* Houveram erros na geracao da etiqueta no MΩdulo WMS */
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 55847,
                           INPUT ""). /*Erro na geraá∆o de Etiquetas*/
        RUN pi-finalizar IN h-acomp.                                         
        RETURN "NOK":U. /*Se retornou erro, nao gera bc-etiqueta*/

    END.
    ELSE
        /* Imprime todas os registros selecionados no browse */
        DO TRANSACTION ON ERROR UNDO, LEAVE:
            DO iContBrowser = 1 TO INT(br-op-tela:NUM-SELECTED-ROWS IN FRAME fPage1) :
                /* Navega pelo browse */
                br-op-tela:FETCH-SELECTED-ROW(iContBrowser) NO-ERROR.                 
                /* Gera a impressao para cada qtd-etiqueta */
                DO iContEtiquetas = 1 TO tt-browse-tela.qtd-etiqueta:
                    IF tt-browse-tela.tipo-etiqueta <> 0 THEN
                        FIND FIRST ttSerial NO-ERROR.
                    RUN pi-acompanhar IN h-acomp (tt-browse-tela.it-codigo + " - " + STRING(iContEtiquetas)). 
                    /* Soh cria o registro se for diferente de zero */
                    IF (tt-browse-tela.tipo-etiqueta <> 0) and (tt-browse-tela.ControlaEtiqueta) THEN DO:     
                        /*/* Pega a qtd de item na embalagem, caso seja a ultima embalagem */
                        IF tt-browse-tela.qtd-etiqueta = iContEtiquetas AND  tt-browse-tela.qtd-ult-embalagem > 0 THEN DO:
                            ASSIGN deQuantidadeItemNaEmbalagem = tt-browse-tela.qtd-ult-embalagem.
                        END.
                        ELSE DO:
                            ASSIGN deQuantidadeItemNaEmbalagem = tt-browse-tela.qtd-item-embalagem.
                        END.*/
    
                        ASSIGN deQuantidadeItemNaEmbalagem = tt-browse-tela.qtd-item.
            
                        /* Gera a wm-etiqueta */
                        RUN pi-gera-etiqueta-wms(INPUT deQuantidadeItemNaEmbalagem, 
                                                 INPUT 1, /*Ordem Producao*/
                                                 INPUT ttSerial.de-serial).
    
                        IF RETURN-VALUE = 'nok' OR ttSerial.de-serial = 0 THEN DO:
                            /* Houveram erros na geracao da etiqueta no MΩdulo WMS */
                            RUN utp/ut-msgs.p (INPUT "show",
                                               INPUT 18475,
                                               INPUT ""). /*Erro na geraá∆o de Etiquetas*/         
                            RETURN ERROR. /*Se retornou erro, nao gera bc-etiqueta*/
                        END.
                        /* Gera a bc-etiqueta */
                        RUN pi-gera-etiqueta-dc (INPUT ttSerial.de-serial,
                                                 INPUT op-dep-saida:SCREEN-VALUE IN FRAME fPage1,
                                                 INPUT op-loc-saida:SCREEN-VALUE IN FRAME fPage1).
                    END.
            
                    IF (tt-browse-tela.tipo-etiqueta <> 0) and (tt-browse-tela.ControlaEtiqueta) THEN DO:
                        /* Gera a transacao de impressao no datacollection */
                        RUN pi-gera-impressao (INPUT ttSerial.de-serial, 
                                               INPUT deQuantidadeItemNaEmbalagem, 
                                               INPUT 1).
                    END.
                    ELSE DO:
                        /* Gera a transacao de impressao no datacollection */
                        ASSIGN deQuantidadeItemNaEmbalagem = tt-browse-tela.qtd-item-embalagem.
                        RUN pi-gera-impressao (INPUT deSerial, 
                                               INPUT deQuantidadeItemNaEmbalagem, 
                                               INPUT tt-browse-tela.qtd-etiqueta).
                        LEAVE.
                    END.
                    IF tt-browse-tela.tipo-etiqueta <> 0 THEN
                        DELETE ttSerial.
                    IF RETURN-VALUE <> "OK":U THEN RETURN ERROR.  
                END.                                           
            END.
            
            RUN createMovtoEtiqueta IN hbosc112 (INPUT c-estab-aux,
                                                 INPUT op-local:SCREEN-VALUE IN FRAME fPage1,
                                                 INPUT tt-browse-tela.id-docto,
                                                 OUTPUT TABLE rowerrors).      
        END. /*DO TRANS*/
    RELEASE bc-etiqueta.
    RUN pi-finalizar IN h-acomp. 
    EMPTY TEMP-TABLE tt-browse-tela.
    {&OPEN-QUERY-br-op-tela}
    IF VALID-HANDLE(h-acomp) THEN DELETE OBJECT h-acomp.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-etiqueta-rf wWindow 
PROCEDURE pi-gera-etiqueta-rf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iContBrowser                AS INTEGER NO-UNDO. /*contador dos registros no browser*/
    DEFINE VARIABLE iContEtiquetas              AS INTEGER NO-UNDO. /*contador de etiquetas a serem impressas*/
    DEFINE VARIABLE deSerial                    AS DECIMAL NO-UNDO. /*Armazena o serial gerado pelo wms*/
    DEFINE VARIABLE deCarga                     AS DECIMAL NO-UNDO. /* Armazena a carga gerada */
    DEFINE VARIABLE deQuantidadeItemNaEmbalagem AS DECIMAL NO-UNDO. /*Qtd item na embalagem*/
    DEFINE VARIABLE cmensagem                   AS CHAR    NO-UNDO.

    /* Iniciando tela de acompanhamento */
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp. 
    {utp/ut-liter.i Imprimindo... *}
    RUN pi-inicializar IN h-acomp (RETURN-VALUE). 
    {utp/ut-liter.i Gerando_impress∆o... *}
    RUN pi-acompanhar IN h-acomp (RETURN-VALUE). 

    /*{utp/ut-liter.i "Houveram_erros_na_geraá∆o_da_etiqueta_no_M¢dulo_WMS MBC"}
    ASSIGN cmensagem = RETURN-VALUE.            */ 

    ASSIGN deCarga = 0.

    EMPTY TEMP-TABLE ttSerial.

    IF NOT VALID-HANDLE(hbosc050) THEN
        RUN scbo/bosc050.p PERSISTENT SET hbosc050.

    FOR EACH tt-browse-tela 
       WHERE tt-browse-tela.marca = YES
         AND tt-browse-tela.ControlaEtiqueta = YES:
        /* Gera um serial de etiqueta */    
        RUN geraSeqEtiqueta IN hbosc050 (OUTPUT TABLE ttSerialAux, INPUT tt-browse-tela.qtd-etiqueta).
        FOR EACH ttSerialAux:
            CREATE ttSerial.
            ASSIGN ttSerial.de-serial = ttSerialAux.de-serial.
        END.
    END.
    
    /* N“o gerou nenhum registro */
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN GetRowErrors IN hbosc050 (OUTPUT TABLE RowErrors).
        RUN DESTROY IN hbosc050.
        RETURN "NOK":U.
    END.

    IF NOT AVAIL ttSerial THEN DO:
        /* Houveram erros na geracao da etiqueta no MΩdulo WMS */
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 55847,
                           INPUT ""). /*Erro na geraá∆o de Etiquetas*/
        RUN pi-finalizar IN h-acomp.                                         
        RETURN "NOK":U. /*Se retornou erro, nao gera bc-etiqueta*/

    END.
    ELSE
        /* Imprime todas os registros selecionados no browse */
        DO TRANSACTION ON ERROR UNDO, LEAVE:
            DO iContBrowser = 1 TO INT(br-rf-tela:NUM-SELECTED-ROWS IN FRAME fPage4) :
                /* Navega pelo browse */
                br-rf-tela:FETCH-SELECTED-ROW(iContBrowser) NO-ERROR.                 
    
                RUN pi-gera-carga-rf.
                IF RETURN-VALUE = 'nok' THEN 
                    RETURN ERROR.
    
                /* Gera a impressao para cada qtd-etiqueta */
                DO iContEtiquetas = 1 TO tt-browse-tela.qtd-etiqueta:
                    IF tt-browse-tela.tipo-etiqueta <> 0 THEN
                        FIND FIRST ttSerial NO-ERROR.
                    RUN pi-acompanhar IN h-acomp (tt-browse-tela.it-codigo + " - " + STRING(iContEtiquetas)).
                    /* Soh cria o registro se for diferente de zero */
                    IF (tt-browse-tela.tipo-etiqueta <> 0) and (tt-browse-tela.ControlaEtiqueta) THEN DO:
                        /*/* Pega a qtd de item na embalagem, caso seja a ultima embalagem */
                        IF tt-browse-tela.qtd-etiqueta = iContEtiquetas AND  tt-browse-tela.qtd-ult-embalagem > 0 THEN DO:
                            ASSIGN deQuantidadeItemNaEmbalagem = tt-browse-tela.qtd-ult-embalagem.
                        END.
                        ELSE DO:
                            ASSIGN deQuantidadeItemNaEmbalagem = tt-browse-tela.qtd-item-embalagem.
                        END.*/
    
                        ASSIGN deQuantidadeItemNaEmbalagem = tt-browse-tela.qtd-item.
    
                        /* Gera a wm-etiqueta */
                        RUN pi-gera-etiqueta-wms(INPUT deQuantidadeItemNaEmbalagem, 
                                                 INPUT 4, /*Recebimento F°sico*/
                                                 INPUT ttSerial.de-serial).
            
                        IF RETURN-VALUE = 'nok' OR ttSerial.de-serial = 0 THEN DO:
                            /* Houveram erros na geracao da etiqueta no MΩdulo WMS */
                            RUN utp/ut-msgs.p (INPUT "show",
                                               INPUT 18475,
                                               INPUT ""). /*Erro na geraá∆o de Etiquetas*/         
                            RETURN ERROR. /*Se retornou erro, nao gera bc-etiqueta*/
                        END.
                        /* Gera a bc-etiqueta */
                        RUN pi-gera-etiqueta-dc (INPUT ttSerial.de-serial,
                                                 INPUT "",
                                                 INPUT "").
                    END.
            
                    IF (tt-browse-tela.tipo-etiqueta <> 0) and (tt-browse-tela.ControlaEtiqueta) THEN DO:
                        /* Gera a transacao de impressao no datacollection */
                        RUN pi-gera-impressao (INPUT ttSerial.de-serial, 
                                               INPUT deQuantidadeItemNaEmbalagem, 
                                               INPUT 1).
                    END.
                    ELSE DO:
                        /* Gera a transacao de impressao no datacollection */
                        ASSIGN deQuantidadeItemNaEmbalagem = tt-browse-tela.qtd-item-embalagem.
                        RUN pi-gera-impressao (INPUT deSerial, 
                                               INPUT deQuantidadeItemNaEmbalagem, 
                                               INPUT tt-browse-tela.qtd-etiqueta).
                        LEAVE.
                    END.
                    IF tt-browse-tela.tipo-etiqueta <> 0 THEN
                        DELETE ttSerial.
                    IF RETURN-VALUE <> "OK":U THEN RETURN ERROR.
                END.                                           
            END.
            
            RUN createMovtoEtiqueta IN hbosc112 (INPUT rf-estab:SCREEN-VALUE IN FRAME fPage4,
                                                 INPUT rf-local:SCREEN-VALUE IN FRAME fPage4,
                                                 INPUT tt-browse-tela.id-docto,
                                                 OUTPUT TABLE rowerrors).      
    
        END. /*DO TRANSACTION ON ERROR UNDO, LEAVE:*/
    RELEASE bc-etiqueta.
    RUN pi-finalizar IN h-acomp. 
    EMPTY TEMP-TABLE tt-browse-tela.
    {&OPEN-QUERY-br-rf-tela}
    IF VALID-HANDLE(h-acomp) THEN DELETE OBJECT h-acomp.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-etiqueta-wms wWindow 
PROCEDURE pi-gera-etiqueta-wms :
/*------------------------------------------------------------------------------
  Purpose: Cria o registro wm-etiqueta
  Parameters:  Passa a quantidade de item da etiqueta e retorna o serial gerado
  Notes:       Modelo o programa ppgapi003.p da PPG
------------------------------------------------------------------------------*/
&if '{&mgscm_version}' >= '2.04' &then
    DEFINE INPUT PARAMETER p-deQtdItem AS DECIMAL NO-UNDO.
    DEFINE INPUT PARAMETER i-selecao   AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-deSerial AS DECIMAL NO-UNDO.

   /*i-selecao = 1 - Ordem Producao
                 2 - item 
                 3 - Doc WMS
                 4 - Rec. Fisico */

    IF NOT AVAIL tt-browse-tela THEN DO:
        RETURN "NOK":U.
    END.

    RUN openQueryStatic IN hbosc044 (INPUT "Main":U).
    RUN gotokey IN hbosc044 (INPUT tt-browse-tela.it-codigo ).
    IF  RETURN-VALUE <> "OK":U THEN DO:
        RUN getRowErrors IN hbosc044 (OUTPUT TABLE RowErrors).
        FIND FIRST rowErrors NO-ERROR.
        IF AVAIL rowErrors THEN DO:
            RUN pi-finalizar IN h-acomp. 
            IF VALID-HANDLE(h-acomp) THEN DELETE OBJECT h-acomp.
            {method/showmessage.i1}
            {method/showmessage.i2}
        END.
        RETURN "NOK":U.
    END.
    
    RUN getDecField IN hbosc044 (INPUT "qtd-peso",
                                 OUTPUT dePesoItem).
    
    IF RETURN-VALUE <> "OK":U THEN DO:
        RUN getRowErrors IN hbosc044 (OUTPUT TABLE RowErrors).
        FIND FIRST rowErrors NO-ERROR.
        IF AVAIL rowErrors THEN DO:
            RUN pi-finalizar in h-acomp. 
            IF VALID-HANDLE(h-acomp) THEN DELETE OBJECT h-acomp.
            {method/showmessage.i1}
            {method/showmessage.i2}
        END.
        RETURN "NOK":U.
    END.
    
    RUN openQueryStatic in hbosc074 (input "Main":U).
    
    EMPTY TEMP-TABLE ttWm-etiqueta.

    /* verifica se j† existe lote no wms, se j† existir atribui a data de validade do mesmo para as etiquetas */
    FOR FIRST wm-saldo-estoque FIELDS (cod-estabel cod-item cod-lote dt-validade-lote) NO-LOCK
        WHERE wm-saldo-estoque.cod-estabel = tt-browse-tela.cod-estabel
          AND wm-saldo-estoque.cod-item    = tt-browse-tela.it-codigo
          AND wm-saldo-estoque.cod-lote    = tt-browse-tela.lote: END.

    IF AVAIL wm-saldo-estoque THEN
        ASSIGN tt-browse-tela.dt-validade-lote = wm-saldo-estoque.dt-validade-lote.

    CREATE ttWm-etiqueta.
    ASSIGN ttWm-etiqueta.cod-estabel            = tt-browse-tela.cod-estabel
           ttWm-etiqueta.cod-item               = tt-browse-tela.it-codigo
           ttWm-etiqueta.cod-refer              = tt-browse-tela.cod-refer
           ttWm-etiqueta.cod-lote               = tt-browse-tela.lote
           ttWm-etiqueta.qtd-item               = IF tt-browse-tela.tipo-etiq = 2
                                                  AND NOT l-ckd THEN 0
                                                  ELSE p-deQtdItem
           ttWm-etiqueta.cod-cliente            = tt-browse-tela.cod-cliente
           ttWm-etiqueta.cod-embalagem          = tt-browse-tela.cod-embalagem
           ttWm-etiqueta.nome-abrev             = tt-browse-tela.nome-abrev
           ttWm-etiqueta.cod-usuario            = tt-browse-tela.cod-usuario
           ttWm-etiqueta.dt-validade-lote       = tt-browse-tela.dt-validade-lote 
           ttWm-etiqueta.nr-ord-prod            = IF i-selecao = 1 THEN tt-browse-tela.nr-ord-produ
                                                  ELSE 999999999
           ttWm-etiqueta.dt-geracao             = TODAY
           ttWm-etiqueta.hr-geracao             = TIME
           ttWm-etiqueta.ind-sit-agrupador      = /* IF l-ckd AND tt-browse-tela.tipo-etiq <> 2 THEN 1 ELSE */ tt-browse-tela.tipo-etiq
           ttWm-etiqueta.log-impressa           = YES
           ttwm-etiqueta.id-carga               = deCarga
           ttwm-etiqueta.qtd-peso               = ttWm-etiqueta.qtd-item * dePesoItem.

           IF i-selecao = 2 THEN /*por Item*/
               ASSIGN  ttwm-etiqueta.log-reportada = YES.

           RUN GeraEtiquetasWMS IN hbosc074 (INPUT TABLE ttWm-etiqueta,
                                             INPUT 1,
                                             INPUT p-deSerial).
           /* Nao Gerou Nenhum Registro */
           IF  RETURN-VALUE <> "OK":U THEN DO:
               RUN getRowErrors IN hbosc074 (OUTPUT TABLE RowErrors).
               FIND FIRST rowErrors NO-ERROR.
               IF AVAIL rowErrors THEN DO:
                   RUN pi-finalizar IN h-acomp. 
                   IF VALID-HANDLE(h-acomp) THEN DELETE OBJECT h-acomp.
                   {method/showmessage.i1}
                   {method/showmessage.i2}
               END.
               RETURN "NOK":U.
           END.                       

           IF i-selecao = 4 THEN DO:
               IF AVAIL ttSerial AND deCarga <> 0 THEN DO:
                   EMPTY TEMP-TABLE ttWm-Etiqueta-rf.
                   RUN gotokey         IN hbosc074(INPUT p-deSerial).        
                   RUN getRecord       IN hbosc074(OUTPUT TABLE ttWm-Etiqueta-rf).
                   FIND FIRST ttWm-Etiqueta-rf EXCLUSIVE-LOCK NO-ERROR.
                   IF AVAIL ttWm-Etiqueta-rf THEN DO:
                       ASSIGN ttWm-Etiqueta-rf.id-carga    = deCarga
                              &IF '{&mgscm_version}' >= '2.08' &THEN
                                /*Alterar para o campo criado na 2.08 quando o dicionario for liberado*/
                                ttWm-Etiqueta-rf.int-1               = IF i-selecao = 4 THEN tt-browse-tela.num-seq ELSE 0
                              &ELSE
                                ttWm-Etiqueta-rf.int-1               = IF i-selecao = 4 THEN tt-browse-tela.num-seq ELSE 0
                              &ENDIF 
                              .
                       RUN emptyRowErrors IN hbosc074.
                       RUN setRecord      IN hbosc074 (INPUT TABLE ttWm-Etiqueta-rf).
                       RUN updateRecord   IN hbosc074.
                       IF  RETURN-VALUE <> "OK":U THEN DO:
                           RUN getRowErrors IN hbosc074 (OUTPUT TABLE RowErrors).
                           FIND FIRST rowErrors NO-ERROR.
                           IF AVAIL rowErrors THEN DO:
                               RUN pi-finalizar in h-acomp. 
                               IF VALID-HANDLE(h-acomp) THEN DELETE OBJECT h-acomp.
                               {method/showmessage.i1}
                               {method/showmessage.i2}
                           END.
                           RETURN "NOK":U.
                       END.
                   END.
               END.
           END.
           IF i-selecao = 3 THEN DO:
               IF AVAIL ttSerial AND deCarga <> 0 THEN DO:
                   ASSIGN ttWm-etiqueta.id-etiqueta = p-deSerial.
                   RUN etiquetasReportadas  IN hbosc074 (INPUT TABLE ttWm-etiqueta).
                   IF  RETURN-VALUE <> "OK":U THEN DO:
                       RUN getRowErrors IN hbosc074 (OUTPUT TABLE RowErrors).

                       FIND FIRST rowErrors NO-ERROR.
                       IF AVAIL rowErrors THEN DO:
                           RUN pi-finalizar in h-acomp.
                           IF VALID-HANDLE(h-acomp) THEN DELETE OBJECT h-acomp.
                           {method/showmessage.i1}
                           {method/showmessage.i2}
                       END.
                       RETURN "NOK":U.
                   END.
                   RUN associaAgrupCarga IN hbosc074 (INPUT c-seg-usuario,
                                                      INPUT p-deSerial,
                                                      INPUT deCarga).
                   IF  RETURN-VALUE <> "OK":U THEN DO:
                       RUN getRowErrors IN hbosc074 (OUTPUT TABLE RowErrors).
                       FIND FIRST rowErrors NO-ERROR.
                       IF AVAIL rowErrors THEN DO:
                           RUN pi-finalizar in h-acomp. 
                           IF VALID-HANDLE(h-acomp) THEN DELETE OBJECT h-acomp.
                           {method/showmessage.i1}
                           {method/showmessage.i2}
                       END.
                       RETURN "NOK":U.
                   END.
               END.
           END.   
    RETURN "OK":U.
&endif.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-impressao wWindow 
PROCEDURE pi-gera-impressao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-deSerial AS DECIMAL NO-UNDO.
    DEFINE INPUT PARAMETER p-qtditem  AS DECIMAL NO-UNDO.
    DEFINE INPUT PARAMETER p-qtdetiq  AS INTEGER NO-UNDO.
    
    EMPTY TEMP-TABLE TT-ETIQUETA.
    EMPTY TEMP-TABLE TT-TRANS.

    /* Procuara o item */
    FIND FIRST ITEM NO-LOCK 
         WHERE ITEM.it-codigo = tt-browse-tela.it-codigo NO-ERROR.

    CREATE tt-etiqueta.
    ASSIGN tt-etiqueta.cod-versao-integracao = 1
           tt-etiqueta.i-sequen              = 1
           tt-etiqueta.qt-etiqueta           = 1
           tt-etiqueta.cd-trans              = cCdTrans
           tt-etiqueta.tipo-etiq             = tt-browse-tela.layout-etiqueta
           tt-etiqueta.desc-item             = IF AVAIL ITEM THEN item.desc-item ELSE ''
           tt-etiqueta.desc-etiqueta         = IF AVAIL ITEM THEN item.descricao-1 ELSE ''
           tt-etiqueta.nr-docto              = STRING(tt-browse-tela.id-docto)
           tt-etiqueta.quantidade            = p-qtditem
           tt-etiqueta.usuario               = tt-browse-tela.cod-usuario
           tt-etiqueta.it-codigo             = tt-browse-tela.it-codigo
           tt-etiqueta.lote                  = tt-browse-tela.lote
           tt-etiqueta.cod-depos             = tt-browse-tela.cod-depos
           tt-etiqueta.cod-localiz           = tt-browse-tela.cod-local
           tt-etiqueta.dt-val-lote           = tt-browse-tela.dt-validade-lote
           tt-etiqueta.cod-estabel           = tt-browse-tela.cod-estabel
           tt-etiqueta.auxiliar-01           = tt-browse-tela.cod-ean  /*tipo gelatina*/
           tt-etiqueta.auxiliar-02           = tt-browse-tela.cod-dun  /*malha*/
           tt-etiqueta.auxiliar-03           = STRING(p-deSerial)      /*serial do wms*/
           tt-etiqueta.auxiliar-04           = STRING(p-qtdetiq).      /* qtd de etiquetas */

    IF tt-browse-tela.qtd-item < tt-browse-tela.qtd-item-embalagem
       THEN ASSIGN tt-etiqueta.auxiliar-05 = STRING(tt-browse-tela.qtd-item).
       ELSE ASSIGN tt-etiqueta.auxiliar-05 = "".

    /* Se estiver configurado, imprime  */
    CREATE tt-trans.
    ASSIGN tt-trans.cod-versao-integracao = 1
           tt-trans.i-sequen              = 1
           tt-trans.cd-trans              = cCdTrans
           tt-trans.usuario               = c-seg-usuario
           tt-trans.atualizada            = NO
           tt-trans.etiqueta              = YES
           tt-trans.detalhe               = " Ser:"     + STRING(p-deSerial) + 
                                            " It:"      + tt-etiqueta.it-codigo + 
                                            " Lt:"      + tt-etiqueta.lote + 
                                            " QtdEtiq:" + string(p-qtdetiq).
    RAW-TRANSFER tt-etiqueta TO tt-trans.conteudo-trans.
    RUN bcp/bcapi001.p (INPUT-OUTPUT TABLE tt-trans,
                        INPUT-OUTPUT TABLE tt-erro).
    FIND FIRST tt-erro NO-ERROR.
    IF AVAIL tt-erro THEN DO:
        RUN pi-finalizar IN h-acomp. 
        IF VALID-HANDLE(h-acomp) THEN DELETE OBJECT h-acomp.
        RUN cdp/cd0666.w (INPUT TABLE tt-erro).
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-realizar-sugestao wWindow 
PROCEDURE pi-realizar-sugestao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER pc-estabel   LIKE wm-docto-itens.cod-estabel  NO-UNDO.
    DEF INPUT PARAMETER pc-local     LIKE wm-docto-itens.cod-local    NO-UNDO.
    DEF INPUT PARAMETER pi-id-docto  LIKE wm-docto-itens.id-docto     NO-UNDO.

    /*DEF VAR i-cont AS INTEGER.*/

    IF NOT VALID-HANDLE(hbosc039)               OR  
       hbosc039:TYPE <> "PROCEDURE":U           OR  
       hbosc039:FILE-NAME <> "scbo/bosc039.p":U THEN
       RUN scbo/bosc039.p PERSISTENT SET hbosc039.

    FOR EACH tt-divergencia NO-LOCK.
        DO i-cont = 1 TO tt-divergencia.qtd-etiqueta:
            RUN sugestaoAlocacaoItem1 IN hbosc039 (INPUT pc-estabel,
                                                   INPUT pc-local,
                                                   INPUT pi-id-docto,
                                                   INPUT tt-divergencia.num-seq,
                                                   INPUT tt-divergencia.qtd-item).
            RUN GetRowErrors IN hbosc039 (OUTPUT TABLE RowErrors).
        END.

    END.

    IF VALID-HANDLE(hbosc039) THEN
           DELETE OBJECT hbosc039.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-realizar-sugestao-ckd wWindow 
PROCEDURE pi-realizar-sugestao-ckd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER pc-estabel   LIKE wm-docto-itens.cod-estabel  NO-UNDO.
    DEF INPUT PARAMETER pc-local     LIKE wm-docto-itens.cod-local    NO-UNDO.
    DEF INPUT PARAMETER pi-id-docto  LIKE wm-docto-itens.id-docto     NO-UNDO.

    IF NOT VALID-HANDLE(hbosc039)               OR  
       hbosc039:TYPE <> "PROCEDURE":U           OR  
       hbosc039:FILE-NAME <> "scbo/bosc039.p":U THEN
       RUN scbo/bosc039.p PERSISTENT SET hbosc039.

    FOR EACH tt-browse-tela WHERE tt-browse-tela.num-seq >= 10:
        DO i-cont = 1 TO tt-browse-tela.qtd-etiqueta:
            RUN sugestaoAlocacaoItem1 IN hbosc039 (INPUT pc-estabel,
                                                   INPUT pc-local,
                                                   INPUT pi-id-docto,
                                                   INPUT tt-browse-tela.num-seq,
                                                   INPUT tt-browse-tela.qtd-item).
            RUN GetRowErrors IN hbosc039 (OUTPUT TABLE RowErrors).
        END.
    END.

    
/*                                                                                             */
/*     IF NOT VALID-HANDLE(hDBOWm-Sto)                                                         */
/*     OR hDBOWm-Sto:TYPE <> "PROCEDURE":U                                                     */
/*     OR hDBOWm-Sto:FILE-NAME <> "scbo/bosc035sto.p":U THEN DO:                               */
/*         {btb/btb008za.i1 scbo/bosc035sto.p YES}                                             */
/*         {btb/btb008za.i2 scbo/bosc035sto.p '' hDBOWm-Sto}                                   */
/*     end.                                                                                    */
/*                                                                                             */
/*     run getRowid in hDBOWm-docto-itens (OUTPUT r-docto-itens).                              */
/*                                                                                             */
/*     EMPTY TEMP-TABLE tt-docto-itens-emb-aux2.                                               */
/*                                                                                             */
/*     FOR EACH tt-docto-itens-emb-aux:                                                        */
/*         CREATE tt-docto-itens-emb-aux2.                                                     */
/*         ASSIGN tt-docto-itens-emb-aux2.cod-embalagem = tt-docto-itens-emb-aux.cod-embalagem */
/*                tt-docto-itens-emb-aux2.qtd-item      = tt-docto-itens-emb-aux.qtd-item      */
/*                tt-docto-itens-emb-aux2.qtd-embalagem = tt-docto-itens-emb-aux.qtd-embalagem */
/*                tt-docto-itens-emb-aux2.qtd-volume    = tt-docto-itens-emb-aux.qtd-volume    */
/*                tt-docto-itens-emb-aux2.qtd-peso      = tt-docto-itens-emb-aux.qtd-peso      */
/*                tt-docto-itens-emb-aux2.id-box        = tt-docto-itens-emb-aux.id-box        */
/*                tt-docto-itens-emb-aux2.cod-bloco     = tt-docto-itens-emb-aux.cod-bloco     */
/*                tt-docto-itens-emb-aux2.cod-rua       = tt-docto-itens-emb-aux.cod-rua       */
/*                tt-docto-itens-emb-aux2.cod-nivel     = tt-docto-itens-emb-aux.cod-nivel     */
/*                tt-docto-itens-emb-aux2.cod-coluna    = tt-docto-itens-emb-aux.cod-coluna.   */
/*     END.                                                                                    */
/*     run doAlocationManual in hDBOWm-Sto (input table tt-docto-itens-emb-aux2,               */
/*                                          input r-docto-itens,                               */
/*                                          output table RowErrors).                           */
/*                                                                                             */
/*     if can-find(first RowErrors) then do:                                                   */
/*         run pi-finalizar in h-acomp.                                                        */
/*         {method/showmessage.i1}                                                             */
/*         {method/showmessage.i2}                                                             */
/*         undo, return "NOK":U.                                                               */
/*     end.                                                                                    */
/*                                                                                             */

    IF VALID-HANDLE(hbosc039) THEN
           DELETE OBJECT hbosc039.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-campos-docto wWindow 
PROCEDURE pi-valida-campos-docto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FOR FIRST ITEM FIELDS(tipo-con-est)
            WHERE item.it-codigo = c-item-aux NO-LOCK:
        ASSIGN iTipoConEst = ITEM.tipo-con-est.
    END.

    IF dc-numero = "" THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "N£mero_Docto_WMS" *}
        RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
        APPLY "entry" TO dc-numero IN FRAME fPage3.
        RETURN "nok".
    END.

    IF dc-id-docto = 0 THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "ID_Docto_Wms" *}
        RUN utp/ut-msgs.p ("show",164, RETURN-VALUE).
        APPLY "entry" TO dc-id-docto IN FRAME fPage3.
        RETURN "nok".
    END.
    
    IF dc-estab = "" THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Estabelecimento" *}
        RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
        APPLY "entry" TO dc-estab IN FRAME fPage3.
        RETURN "nok".
    END.
    
    IF dc-local = "" THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Local" *}
        RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
        APPLY "entry" TO dc-local IN FRAME fPage3.
        RETURN "nok".
    END.
    
    IF dc-lote = "" AND (iTipoConEst = 3 OR iTipoConEst = 4) THEN DO:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Lote" *}
       RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
       APPLY "entry" TO dc-lote IN FRAME fPage3.
       RETURN "nok".
    END.                                       
    
    IF dc-referencia = "" AND iTipoConEst = 4 THEN DO:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Referància" *}
       RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
       APPLY "entry" TO dc-referencia IN FRAME fPage3.
       RETURN "nok".
    END.                                             
    
    IF dc-dt-validade-lote = DATE("") AND (iTipoConEst = 3 OR iTipoConEst = 4) THEN DO:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Data_de_Validade_do_Lote" *}
       RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
       APPLY "entry" TO dc-dt-validade-lote IN FRAME fPage3.
       RETURN "nok".
    END.
    
    IF NOT VALID-HANDLE(hbosc047) THEN
       RUN scbo/bosc047.p PERSISTENT SET hbosc047.
    
    RUN openQueryStatic IN hbosc047 (INPUT "Main":U).
    RUN goToKey IN hbosc047 (INPUT dc-estab, 
                             INPUT dc-local).
    IF RETURN-VALUE = "NOK":U THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Estabelecimento_e_Local_no_WM0240(Cadastro_Local)" *}
        RUN utp/ut-msgs.p ("SHOW",56, RETURN-VALUE).
        RETURN "NOK":U.
    END.
    
    /* Chamada EPC */
    assign l-verifUtilizEtiqMovto-upc-bc9026 = yes.
    IF c-nom-prog-upc-mg97 <> "" THEN DO:

        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "pi-valida-campos-docto":U, 
                                        INPUT "CONTAINER":U,
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME {&FRAME-NAME}:HANDLE,
                                        INPUT "", 
                                        INPUT ?) NO-ERROR. 

        if return-value = "IGNORA_VALIDACAO":U then
            assign l-verifUtilizEtiqMovto-upc-bc9026 = no.
        
    END. /* if */

    if l-verifUtilizEtiqMovto-upc-bc9026 then do:

        RUN verificarUtilizaEtiqMovto IN hbosc047(INPUT dc-estab,
                                                  INPUT dc-local,
                                                  OUTPUT l-utiliz-etiq-movto).
        IF NOT l-utiliz-etiq-movto THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Estabelecimento_e_Local_no_WM0240(Cadastro_Local)" *}
            RUN utp/ut-msgs.p ("SHOW",51820, RETURN-VALUE).
            RETURN "NOK":U.
        END.    
    end.
    
    /* FIM Chamada EPC */

    IF VALID-HANDLE(hbosc047) THEN 
       DELETE OBJECT hbosc047.
    
    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-campos-it wWindow 
PROCEDURE pi-valida-campos-it :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FOR FIRST ITEM FIELDS(tipo-con-est)
            WHERE item.it-codigo = it-item NO-LOCK:
        ASSIGN iTipoConEst = ITEM.tipo-con-est.
    END.
      
    IF it-estab = "" THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Estabelecimento" *}
        RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
        APPLY "entry" to it-estab IN FRAME fPage2.
        RETURN "nok".
    END.
    
    IF it-local = "" THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Local" *}
        RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
        APPLY "entry" to it-local IN FRAME fPage2.
        RETURN "nok".
    END.
    
    IF it-item = "" THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Item" *}
        RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
        APPLY "entry" TO it-item IN FRAME fPage2.
        RETURN "nok".
    END.
    
    
    IF it-lote = "" AND (iTipoConEst = 2 OR iTipoConEst = 3 OR iTipoConEst = 4) THEN DO:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Lote" *}
       RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
       APPLY "entry" to it-lote IN FRAME fPage2.
       RETURN "nok".
    END.    
    
    IF it-referencia = "" AND iTipoConEst = 4 THEN DO:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Referància" *}
       RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
       APPLY "entry" to it-referencia IN FRAME fPage2.
       RETURN "nok".
    END.                                
    
    IF it-dt-validade-lote = DATE("") AND (iTipoConEst = 3 OR iTipoConEst = 4) THEN DO:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Data_de_Validade_do_Lote" *}
       RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
       APPLY "entry" TO it-dt-validade-lote IN FRAME fPage2.
       RETURN "nok".
    END.
    
    IF it-quantidade = 0 AND iTipoConEst <> 2 THEN DO:
         /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Quantidade_do_Item" *}
        RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
        APPLY "entry" to it-quantidade IN FRAME fPage2.
        RETURN "nok".
    END.

    IF iTipoConEst = 2 AND (it-quantidade <> 0 AND it-quantidade <> 1)  THEN DO:
       RUN utp/ut-msgs.p ("SHOW",1836, "").
       APPLY "entry" to it-quantidade IN FRAME fPage2.
       RETURN "nok".
    END.
    
    IF NOT VALID-HANDLE(hbosc047) THEN
       RUN scbo/bosc047.p PERSISTENT SET hbosc047.
    
    RUN openQueryStatic in hbosc047 (INPUT "Main":U).
    RUN goToKey IN hbosc047 (INPUT it-estab, 
                             INPUT it-local).
    IF RETURN-VALUE = "NOK":U THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Estabelecimento_e_Local_no_WM0240(Cadastro_Local)" *}
        RUN utp/ut-msgs.p ("SHOW",56, RETURN-VALUE).
        RETURN "NOK":U.
    END.
    
    /* Chamada EPC */
    assign l-verifUtilizEtiqMovto-upc-bc9026 = yes.
    IF c-nom-prog-upc-mg97 <> "" THEN DO:

        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "pi-valida-campos-it":U, 
                                        INPUT "CONTAINER":U,
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME {&FRAME-NAME}:HANDLE,
                                        INPUT "", 
                                        INPUT ?) NO-ERROR. 

        if return-value = "IGNORA_VALIDACAO":U then
            assign l-verifUtilizEtiqMovto-upc-bc9026 = no.
        
    END. /* if */

    if l-verifUtilizEtiqMovto-upc-bc9026 then do:

        RUN verificarUtilizaEtiqMovto IN hbosc047(INPUT it-estab,
                                                  INPUT it-local,
                                                  OUTPUT l-utiliz-etiq-movto).
        IF NOT l-utiliz-etiq-movto THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Estabelecimento_e_Local_no_WM0240(Cadastro_Local)" *}
            RUN utp/ut-msgs.p ("SHOW",51820, RETURN-VALUE).
            RETURN "NOK":U.
        end.
    end.

    IF VALID-HANDLE(hbosc047) THEN 
       DELETE OBJECT hbosc047.
    
    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-campos-op wWindow 
PROCEDURE pi-valida-campos-op :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FOR FIRST ITEM FIELDS(tipo-con-est)
            WHERE item.it-codigo = c-item-aux NO-LOCK:
        ASSIGN iTipoConEst = ITEM.tipo-con-est.
    END.
    
    FIND FIRST ORD-PROD NO-LOCK
        WHERE ORD-PROD.NR-ORD-PROD = op-ordem NO-ERROR.
    IF NOT AVAIL ORD-PROD THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Ordem_de_produá∆o" *}
        RUN utp/ut-msgs.p ("SHOW",56, RETURN-VALUE).
        APPLY "entry" to op-ordem IN FRAME fPage1.
        RETURN "nok".
    END.
    
    IF op-local = "" THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Local" *}
        RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
        APPLY "entry" TO op-local IN FRAME fPage1.
        RETURN "nok".
    END.
    
    IF op-lote = "" AND (iTipoConEst = 3 OR iTipoConEst = 4) THEN DO:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Lote" *}
       RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
       APPLY "entry" TO op-lote IN FRAME fPage1.
       RETURN "nok".
    END.                                       
    
    IF op-referencia = "" AND iTipoConEst = 4 THEN DO:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Referància" *}
       RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
       APPLY "entry" TO op-referencia IN FRAME fPage1.
       RETURN "nok".
    END.
                                                     
    IF op-dt-validade-lote = DATE("") AND (iTipoConEst = 3 OR iTipoConEst = 4) THEN DO:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Data_de_Validade_do_Lote" *}
       RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
       APPLY "entry" TO op-dt-validade-lote IN FRAME fPage1.
       RETURN "nok".
    END.

    IF op-dt-validade-lote < TODAY THEN DO:
       /* Inicio -- Projeto Internacional */
       RUN utp/ut-msgs.p ("SHOW",8015, RETURN-VALUE).
       APPLY "entry" TO op-dt-validade-lote IN FRAME fPage1.
       RETURN "nok".
    END.
    
    IF op-quantidade = 0 THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Quantidade_do_Item" *}
        RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
        APPLY "entry" TO op-quantidade IN FRAME fPage1.
        RETURN "nok".
    END.
    
    IF NOT VALID-HANDLE(hbosc047) THEN
       RUN scbo/bosc047.p PERSISTENT SET hbosc047.
    RUN openQueryStatic IN hbosc047 (INPUT "Main":U).
    RUN goToKey IN hbosc047 (INPUT c-estab-aux, 
                             INPUT op-local). 
    IF RETURN-VALUE = "NOK":U THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Estabelecimento_e_Local_no_WM0240(Cadastro_Local)" *}
        RUN utp/ut-msgs.p ("SHOW",56, RETURN-VALUE).
        RETURN "NOK":U.
    END.

    /* Chamada EPC */
    assign l-verifUtilizEtiqMovto-upc-bc9026 = yes.
    IF c-nom-prog-upc-mg97 <> "" THEN DO:
        
        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "pi-valida-campos-op":U, 
                                        INPUT "CONTAINER":U,
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME {&FRAME-NAME}:HANDLE,
                                        INPUT "", 
                                        INPUT ?) NO-ERROR. 

        if return-value = "IGNORA_VALIDACAO":U then
            assign l-verifUtilizEtiqMovto-upc-bc9026 = no.
        
    END. /* if */

    if l-verifUtilizEtiqMovto-upc-bc9026 then do:
        RUN verificarUtilizaEtiqMovto IN hbosc047(INPUT c-estab-aux,
                                                  INPUT op-local,
                                                  OUTPUT l-utiliz-etiq-movto).
        IF NOT l-utiliz-etiq-movto THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Estabelecimento_e_Local_no_WM0240(Cadastro_Local)" *}
            RUN utp/ut-msgs.p ("SHOW",51820, RETURN-VALUE).
            RETURN "NOK":U.
        END.    
    end.
    
    IF VALID-HANDLE(hbosc047) THEN 
       DELETE OBJECT hbosc047.
    
    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-campos-rf wWindow 
PROCEDURE pi-valida-campos-rf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FOR FIRST ITEM FIELDS(tipo-con-est)
            WHERE item.it-codigo = c-item-aux NO-LOCK:
        ASSIGN iTipoConEst = ITEM.tipo-con-est.
    END.
   
    IF rf-numero = "" THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "N£mero_Docto_WMS" *}
        RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
        APPLY "entry" TO rf-numero IN FRAME fPage4.
        RETURN "nok".
    END.

    IF rf-estab = "" THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Estabelecimento" *}
        RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
        APPLY "entry" TO rf-estab IN FRAME fPage4.
        RETURN "nok".
    END.
    
    IF rf-local = "" THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Local" *}
        RUN utp/ut-msgs.p ("SHOW",164, RETURN-VALUE).
        APPLY "entry" TO rf-local IN FRAME fPage4.
        RETURN "nok".
    END.
    
    IF NOT VALID-HANDLE(hbosc047) THEN
       RUN scbo/bosc047.p PERSISTENT SET hbosc047.
    RUN openQueryStatic in hbosc047 (input "Main":U).
    RUN goToKey IN hbosc047 (INPUT rf-estab, 
                             INPUT rf-local).
    IF RETURN-VALUE = "NOK":U THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Estabelecimento_e_Local_no_WM0240(Cadastro_Local)" *}
        RUN utp/ut-msgs.p ("SHOW",56, RETURN-VALUE).
        RETURN "NOK":U.
    END.
    
    /* Chamada EPC */
    assign l-verifUtilizEtiqMovto-upc-bc9026 = yes.
    IF c-nom-prog-upc-mg97 <> "" THEN DO:

        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "pi-valida-campos-rf":U, 
                                        INPUT "CONTAINER":U,
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME {&FRAME-NAME}:HANDLE,
                                        INPUT "", 
                                        INPUT ?) NO-ERROR. 

        if return-value = "IGNORA_VALIDACAO":U then
            assign l-verifUtilizEtiqMovto-upc-bc9026 = no.
        
    END. /* if */
    
    if l-verifUtilizEtiqMovto-upc-bc9026 then do:
        RUN verificarUtilizaEtiqMovto IN hbosc047(INPUT rf-estab,
                                                  INPUT rf-local,
                                                  OUTPUT l-utiliz-etiq-movto).
        IF NOT l-utiliz-etiq-movto THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Estabelecimento_e_Local_no_WM0240(Cadastro_Local)" *}
            RUN utp/ut-msgs.p ("SHOW",51820, RETURN-VALUE).
            RETURN "NOK":U.
        END.    
    end.

    IF VALID-HANDLE(hbosc047) THEN 
       DELETE OBJECT hbosc047.

    IF NOT VALID-HANDLE(hboin089) THEN
       RUN inbo/boin089.p PERSISTENT SET hboin089.
    RUN openQueryStatic in hboin089 (input "Main":U).
    RUN goToKey IN hboin089 (INPUT rf-serie, 
                             INPUT rf-numero,
                             INPUT rf-emitente,
                             INPUT i-tp-nota).
    IF RETURN-VALUE = "NOK":U THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Documento" *}
        RUN utp/ut-msgs.p ("SHOW",56, RETURN-VALUE).
        RETURN "NOK":U.
    END.
    IF VALID-HANDLE(hboin089) THEN 
       DELETE OBJECT hboin089.

    RETURN "ok".              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

