&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright  DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCCP011 1.00.00.002}

&GLOBAL-DEFINE BrowseName br-item-estab br-item-fornec-estab br-item-tab br-erro
&GLOBAL-DEFINE FRAME-NAME fpage0 fpage1
&GLOBAL-DEFINE WindowType     Master

DEF TEMP-TABLE tt-item-estab
    FIELD it-codigo     LIKE item-uni-estab.it-codigo     
    FIELD cod-comprado  LIKE item-uni-estab.cod-comprado
    FIELD cd-planejado  LIKE item-uni-estab.cd-planejado
    FIELD lote-multipl  LIKE item-uni-estab.lote-multipl
    FIELD lote-minimo   LIKE item-uni-estab.lote-minimo
    FIELD res-int-comp  LIKE item-uni-estab.res-int-comp
    FIELD res-cq-comp   LIKE item-uni-estab.res-cq-comp
    FIELD res-for-comp  LIKE item-uni-estab.res-for-comp
    FIELD tipo-est-seg  LIKE item-uni-estab.tipo-est-seg
    FIELD tempo-segu    LIKE item-uni-estab.tempo-segu
    FIELD quant-segur   LIKE item-uni-estab.quant-segur
    FIELD consumo-prev  LIKE item-uni-estab.consumo-prev
    FIELD periodo-fixo  LIKE item-uni-estab.periodo-fixo
    FIELD horiz-fixo    LIKE item-uni-estab.horiz-fixo.

 /*
    INDEX codigo is primary it-codigo.                    */


DEF TEMP-TABLE tt-item-fornec-estab 
    FIELD fabricante          AS   INTEGER
    FIELD for-it-codigo       LIKE item-fornec-estab.it-codigo
    FIELD cod-estabel         LIKE item-fornec-estab.cod-estabel
    FIELD cod-emitente        LIKE item-fornec-estab.cod-emitente 
    FIELD nome-abrev          LIKE emitente.nome-abrev
    FIELD tempo-ressup        LIKE item-fornec-estab.tempo-ressup
    FIELD cot-aut             LIKE item-fornec-estab.cot-aut
    FIELD ativo               LIKE item-fornec-estab.ativo
    FIELD i-cod-cond-pag      LIKE item-fornec-estab.cod-cond-pag
    FIELD moeda-des           LIKE moeda.descricao
    FIELD e-cod-cond-pag      LIKE emitente.cod-cond-pag
    FIELD lote-mul-for        LIKE item-fornec-estab.lote-mul-for
    FIELD lote-min-for        LIKE item-fornec-estab.lote-minimo
    FIELD perc-compra         LIKE item-fornec-estab.perc-compra
    FIELD classe-repro        LIKE item-fornec-estab.classe-repro
    FIELD horizonte-fixo      LIKE item-uni-estab.horiz-fixo
    FIELD unid-med-for        LIKE item-fornec-estab.unid-med-for
    FIELD unid-medida         AS   CHARACTER 
    FIELD fat-conv            LIKE item-fornec-estab.fator-conver
    FIELD casa-dec            AS   INTEGER
    FIELD r-item-uni-estab    AS   ROWID
    FIELD r-item-fornec-estab AS   ROWID.

DEF TEMP-TABLE tt-item-tab
    FIELD nr-tab              LIKE tb-pr-cc.nr-tab 
    FIELD t-cod-cond-pag      LIKE tb-pr-cc.cod-cond-pag
    field dt-inic             AS   DATE FORMAT "99/99/9999"
    field dt-term             AS   DATE FORMAT "99/99/9999"
    field moeda               AS   INTEGER
    field taxa-fin            AS   DECIMAL
    field dias-taxa           AS   INTEGER
    field perc-icms           AS   DECIMAL
    field perc-ipi            AS   DECIMAL
    field preco               LIKE item-tab.pr-item
    field qty-min             AS   DECIMAL
    FIELD cod-emitente        LIKE item-tab.cod-emitente                              
    FIELD des-referencia      LIKE item-tab.des-referencia                            
    FIELD it-codigo           LIKE item-tab.it-codigo                                 
    FIELD r-item-uni-estab    AS   ROWID
    FIELD r-item-tab          AS   ROWID
    FIELD r-item-fornec-estab AS   ROWID.

DEF TEMP-TABLE tt-erro
    FIELD nro-erro  AS INTEGER FORMAT '>>>9':U
    FIELD prob-erro AS CHAR FORMAT "x(40)" 
    FIELD solu-erro AS CHAR FORMAT "X(250)".


{upc/btb910za-upc.i}

DEFINE TEMP-TABLE tt-item-uni-estab-aux no-undo LIKE item-uni-estab
        FIELD r-rowid AS ROWID.

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCCP011
&GLOBAL-DEFINE Version        2

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

/*
&GLOBAL-DEFINE FolderLabels   Itens
*/

&GLOBAL-DEFINE First          no 
&GLOBAL-DEFINE Prev           no 
&GLOBAL-DEFINE Next           no 
&GLOBAL-DEFINE Last           no 
&GLOBAL-DEFINE GoTo           no 
&GLOBAL-DEFINE Search         no 

&GLOBAL-DEFINE Add            no
&GLOBAL-DEFINE Copy           no
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         no
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttSon1           tt-item-fornec-estab
&GLOBAL-DEFINE hDBOSon1         h-boin688
&GLOBAL-DEFINE DBOSon1Table     item-fornec-estab

&GLOBAL-DEFINE page0Fields 
&GLOBAL-DEFINE page1Fields 

&GLOBAL-DEFINE page0widgets btCancel btExit btSave btUpdate rtToolBar ~
                            

&GLOBAL-DEFINE page1widgets bt-procurar cod-estab-sel it-cod-comprado-ini it-cod-comprado-fim it-cod-ini it-cod-fim tg-ativo tg-obso-ordauto tg-obso-todas tg-total-obso tg-depende tg-independe ~
               cb-politica-cd1112 vl-lote-multiplo-cd1112 it-estab-com it-estab-tipo it-estab-cons it-estab-cq it-estab-ts cod-per-fixo-cd1112 vl-lote-minimo-cd1112 vl-qs-cd1112 ~
               vl-ressupr-for-cd1112 ~
               it-estab-horiz cod-deposito-cd0140 cod-tp-despesa-cd0140 nat-despesa-cd0140 ~
               des-deposito-cd0140 des-tip-despesa-cd0140 des-nat-despesa-cd0140 cb-cod-obsol-cd0140 cod-unid-negoc-cd0140 des-unid-negoc-cd0140 cb-criticidade-ce0330 ~
               log-control-qualidade-ce0330 cb-classif-abc-ce0330 cod-planejador-cd1112 des-planejador-cd1112 cb-tp-demanda-cd1112 cod-comprador-cc0120 ~
               cod-estab-gestor-cc0120 cod-qtde-politica-cd1112 cb-reabastace-cd1112 cb-classe-reprog-cd1112 cb-emis-ordens-cd1112 cb-divisao-ordens-cd1112 cod-prioridade-mrp-cd1112 ~
               log-repres-demanda-cd1112 cod-prioridade-cd1112 cod-horiz-fixo-cd1112 br-item-estab br-item-fornec-estab br-item-tab br-erro ~
               

/* Parameters Definitions ---                                           */


/* Local Variable Definitions ---                                       */
def var l-conf as log format "Sim/Nao".
def var l-altera as log format "Situaá∆o/Data".
def var da-nova-data as date format "99/99/9999" initial today.
def var c-motivo as char format "x(60)".
DEFINE VARIABLE de-indice AS DECIMAL     NO-UNDO.

DEF VAR c-nat-despesa    AS CHAR NO-UNDO.
DEF VAR c-depos          AS CHAR NO-UNDO.
DEF VAR c-desc-desp      AS CHAR NO-UNDO.
DEF VAR l-permis-alterar AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE i-origem-aux AS INTEGER     NO-UNDO.

DEF VAR tb-pr-cc-cod-cond-pag LIKE tb-pr-cc.cod-cond-pag.
DEF VAR tb-pr-cc-nr-tab       LIKE tb-pr-cc.nr-tab.

DEF NEW GLOBAL SHARED VAR gr-item           AS ROWID NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-item-uni-estab AS ROWID NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-tb-pr-cc       AS ROWID NO-UNDO.

/*programa cc0531*/
DEF VAR hSonProgram AS HANDLE NO-UNDO.
DEF VAR rSon AS ROWID NO-UNDO.
DEF VAR rCurrentParent AS ROWID NO-UNDO.

/*Ponto de Controle*/
DEF VAR i-nome-programa AS CHAR.
DEF VAR i-ponto AS INT.
DEF VAR i-sequencia AS INT.
DEF VAR i-conteudo AS CHAR.

/*--- Vari†veis definidas para que se possa utilizar o zoom 
      feito em Smart Objects ---*/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-implanta       AS LOGICAL.

{esp/es0018.i}

ASSIGN gr-item-uni-estab = ?.

DEFINE TEMP-TABLE ttErro-busca NO-UNDO 
    field i-sequen AS INTEGER
    field cd-erro  AS INTEGER
    field mensagem AS CHARACTER FORMAT "x(255)".

DEFINE VARIABLE h-acomp               AS   HANDLE NO-UNDO.
DEFINE VARIABLE c-class-reprog-browse AS   CHARACTER FORMAT "X(20)":U NO-UNDO.
DEFINE VARIABLE c-descMoeda           LIKE moeda.descricao NO-UNDO.


/**** temp-tables usadas na UPC, favor n∆o eliminar ****/
def new shared temp-table tt-old-item no-undo like item
    use-index codigo.
def new shared temp-table tt-old-item-mat no-undo like item-mat.
def new shared temp-table tt-old-item-uni-estab no-undo like item-uni-estab.

DEFINE VARIABLE hProg AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage1
&Scoped-define BROWSE-NAME br-erro

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-erro tt-item-uni-estab-aux ITEM ~
tt-item-fornec-estab tt-item-tab

/* Definitions for BROWSE br-erro                                       */
&Scoped-define FIELDS-IN-QUERY-br-erro prob-erro solu-erro   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-erro   
&Scoped-define SELF-NAME br-erro
&Scoped-define QUERY-STRING-br-erro FOR EACH tt-erro
&Scoped-define OPEN-QUERY-br-erro OPEN QUERY {&SELF-NAME} FOR EACH tt-erro.
&Scoped-define TABLES-IN-QUERY-br-erro tt-erro
&Scoped-define FIRST-TABLE-IN-QUERY-br-erro tt-erro


/* Definitions for BROWSE br-item-estab                                 */
&Scoped-define FIELDS-IN-QUERY-br-item-estab tt-item-uni-estab-aux.it-codigo ITEM.desc-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-item-estab   
&Scoped-define SELF-NAME br-item-estab
&Scoped-define QUERY-STRING-br-item-estab FOR EACH tt-item-uni-estab-aux NO-LOCK, ~
                                   FIRST ITEM NO-LOCK                             WHERE ITEM.it-codigo = tt-item-uni-estab-aux.it-codigo
&Scoped-define OPEN-QUERY-br-item-estab OPEN QUERY {&SELF-NAME} FOR EACH tt-item-uni-estab-aux NO-LOCK, ~
                                   FIRST ITEM NO-LOCK                             WHERE ITEM.it-codigo = tt-item-uni-estab-aux.it-codigo.
&Scoped-define TABLES-IN-QUERY-br-item-estab tt-item-uni-estab-aux ITEM
&Scoped-define FIRST-TABLE-IN-QUERY-br-item-estab tt-item-uni-estab-aux
&Scoped-define SECOND-TABLE-IN-QUERY-br-item-estab ITEM


/* Definitions for BROWSE br-item-fornec-estab                          */
&Scoped-define FIELDS-IN-QUERY-br-item-fornec-estab tt-item-fornec-estab.cod-estabel tt-item-fornec-estab.cod-emitente tt-item-fornec-estab.nome-abrev tt-item-fornec-estab.fabricante tt-item-fornec-estab.unid-medida tt-item-fornec-estab.fat-conv tt-item-fornec-estab.casa-dec tt-item-fornec-estab.perc-compra tt-item-fornec-estab.ativo tt-item-fornec-estab.lote-min-for tt-item-fornec-estab.lote-mul-for tt-item-fornec-estab.cot-aut fnDesc-class-reprog(tt-item-fornec-estab.classe-repro) @ c-class-reprog-browse tt-item-fornec-estab.horizonte-fixo tt-item-fornec-estab.tempo-ressup tt-item-fornec-estab.i-cod-cond-pag tt-item-fornec-estab.moeda-des tt-item-fornec-estab.e-cod-cond-pag   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-item-fornec-estab   
&Scoped-define SELF-NAME br-item-fornec-estab
&Scoped-define QUERY-STRING-br-item-fornec-estab FOR EACH tt-item-fornec-estab
&Scoped-define OPEN-QUERY-br-item-fornec-estab OPEN QUERY {&SELF-NAME} FOR EACH tt-item-fornec-estab.
&Scoped-define TABLES-IN-QUERY-br-item-fornec-estab tt-item-fornec-estab
&Scoped-define FIRST-TABLE-IN-QUERY-br-item-fornec-estab tt-item-fornec-estab


/* Definitions for BROWSE br-item-tab                                   */
&Scoped-define FIELDS-IN-QUERY-br-item-tab tt-item-tab.cod-emitente tt-item-tab.nr-tab tt-item-tab.t-cod-cond-pag tt-item-tab.taxa-fin tt-item-tab.dias-taxa tt-item-tab.preco fnDesc-moeda(tt-item-tab.moeda) @ c-descMoeda tt-item-tab.qty-min tt-item-tab.perc-ipi tt-item-tab.perc-icms tt-item-tab.dt-inic tt-item-tab.dt-term   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-item-tab   
&Scoped-define SELF-NAME br-item-tab
&Scoped-define QUERY-STRING-br-item-tab FOR EACH tt-item-tab                            WHERE tt-item-tab.r-item-fornec-estab = tt-item-fornec-estab.r-item-fornec-estab
&Scoped-define OPEN-QUERY-br-item-tab OPEN QUERY {&SELF-NAME} FOR EACH tt-item-tab                            WHERE tt-item-tab.r-item-fornec-estab = tt-item-fornec-estab.r-item-fornec-estab.
&Scoped-define TABLES-IN-QUERY-br-item-tab tt-item-tab
&Scoped-define FIRST-TABLE-IN-QUERY-br-item-tab tt-item-tab


/* Definitions for FRAME fpage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage1 ~
    ~{&OPEN-QUERY-br-erro}~
    ~{&OPEN-QUERY-br-item-estab}~
    ~{&OPEN-QUERY-br-item-fornec-estab}~
    ~{&OPEN-QUERY-br-item-tab}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btCC0531 cod-estab-sel it-cod-comprado-fim ~
it-cod-ini it-cod-fim tg-ativo tg-obso-ordauto tg-obso-todas tg-total-obso ~
tg-depende tg-independe bt-procurar i-codigo-orig-cd0140 c-observacao ~
log-repres-demanda-cd1112 it-estab-tipo l-antidumping log-necessita-li ~
tg-inspec br-item-estab br-erro br-item-fornec-estab cb-classif-abc-ce0330 ~
br-item-tab btCC0313 IMAGE-3 IMAGE-4 IMAGE-1 IMAGE-2 RECT-39 RECT-44 ~
RECT-45 RECT-48 RECT-49 RECT-47 RECT-50 RECT-52 
&Scoped-Define DISPLAYED-OBJECTS cod-estab-sel it-cod-comprado-ini ~
it-cod-comprado-fim it-cod-ini it-cod-fim tg-ativo tg-obso-ordauto ~
tg-obso-todas tg-total-obso tg-depende tg-independe cod-estab-gestor-cc0120 ~
cod-comprador-cc0120 c-nome-comprador log-control-qualidade-ce0330 ~
it-estab-cons it-estab-cons-aad cod-deposito-cd0140 des-deposito-cd0140 ~
cod-tp-despesa-cd0140 des-tip-despesa-cd0140 nat-despesa-cd0140 ~
des-nat-despesa-cd0140 i-codigo-orig-cd0140 c-desc-origem ~
cod-unid-negoc-cd0140 des-unid-negoc-cd0140 c-observacao ~
cb-cod-obsol-cd0140 cod-planejador-cd1112 des-planejador-cd1112 ~
vl-lote-multiplo-cd1112 vl-lote-minimo-cd1112 it-estab-horiz ~
cod-horiz-fixo-cd1112 vl-ressupr-for-cd1112 it-estab-cq it-estab-com ~
cod-per-fixo-cd1112 cod-prioridade-cd1112 cod-prioridade-mrp-cd1112 ~
cb-politica-cd1112 cb-tp-demanda-cd1112 cb-classe-reprog-cd1112 ~
cb-reabastace-cd1112 cb-emis-ordens-cd1112 cb-divisao-ordens-cd1112 ~
log-repres-demanda-cd1112 it-estab-tipo vl-qs-cd1112 it-estab-ts ~
cod-qtde-politica-cd1112 c-desc-NCM c-NCM de-perc-II de-perc-IPI ~
l-antidumping log-necessita-li tg-inspec cb-classif-abc-ce0330 ~
cb-criticidade-ce0330 un-cd1112 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDesc-class-reprog wWindow 
FUNCTION fnDesc-class-reprog RETURNS CHARACTER
  ( i-classe-reprog AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDesc-moeda wWindow 
FUNCTION fnDesc-moeda RETURNS CHARACTER
  ( i-mo-codigo AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image/toolbar/im-cancel.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 5 BY 1.5
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/toolbar/im-exi.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-exi.bmp":U
     LABEL "Exit" 
     SIZE 5 BY 1.5
     FONT 4.

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image/toolbar/im-sav.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-sav.bmp":U
     LABEL "Save" 
     SIZE 5 BY 1.5
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image/toolbar/im-mod.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-mod.bmp":U
     LABEL "Update" 
     SIZE 5 BY 1.5
     FONT 4.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 190 BY 1.67
     BGCOLOR 7 .

DEFINE BUTTON bt-procurar 
     IMAGE-UP FILE "image/toolbar/im-sea.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-sea.bmp":U
     LABEL "Procurar..." 
     SIZE 5 BY 1.5 TOOLTIP "Procurar".

DEFINE BUTTON btCC0313 
     LABEL "CC0313" 
     SIZE 15 BY .79.

DEFINE BUTTON btCC0531 
     LABEL "CC0531" 
     SIZE 15 BY .79.

DEFINE VARIABLE cb-classe-reprog-cd1112 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Classe Reprogramaá∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 27.29 BY 1 NO-UNDO.

DEFINE VARIABLE cb-classif-abc-ce0330 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Classif abc" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 7.14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-cod-obsol-cd0140 AS CHARACTER FORMAT "x(30)" 
     LABEL "Situaá∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE cb-criticidade-ce0330 AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     LABEL "Criticidade" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 7.14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-divisao-ordens-cd1112 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Divis∆o Ordens" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 27.29 BY 1 NO-UNDO.

DEFINE VARIABLE cb-emis-ordens-cd1112 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Emiss∆o Ordens" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 27.29 BY 1 NO-UNDO.

DEFINE VARIABLE cb-politica-cd1112 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Politica" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 27.29 BY 1 NO-UNDO.

DEFINE VARIABLE cb-reabastace-cd1112 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Reabastec" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 27.29 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tp-demanda-cd1112 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Demanda" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 27.29 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-NCM AS CHARACTER FORMAT "x(40)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-origem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE c-NCM AS CHARACTER FORMAT "9999.99.99":U 
     LABEL "NCM" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-comprador AS CHARACTER FORMAT "x(40)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .88 NO-UNDO.

DEFINE VARIABLE c-observacao AS CHARACTER FORMAT "X(200)":U 
     LABEL "Observaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 59.86 BY .88
     FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE cod-comprador-cc0120 AS CHARACTER FORMAT "X(12)":U 
     LABEL "Comp" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE cod-deposito-cd0140 AS CHARACTER FORMAT "X(03)":U 
     LABEL "Dep¢sito" 
     VIEW-AS FILL-IN 
     SIZE 6.43 BY .88 NO-UNDO.

DEFINE VARIABLE cod-estab-gestor-cc0120 AS CHARACTER FORMAT "X(03)":U 
     LABEL "Estab Gestor" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE cod-estab-sel AS CHARACTER FORMAT "X(03)":U 
     LABEL "Estabelec" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE cod-horiz-fixo-cd1112 AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .79 NO-UNDO.

DEFINE VARIABLE cod-per-fixo-cd1112 AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Per. Fixo" 
     VIEW-AS FILL-IN 
     SIZE 4.29 BY .79 NO-UNDO.

DEFINE VARIABLE cod-planejador-cd1112 AS CHARACTER FORMAT "X(12)":U 
     LABEL "Planejador" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .79 NO-UNDO.

DEFINE VARIABLE cod-prioridade-cd1112 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Prioridade" 
     VIEW-AS FILL-IN 
     SIZE 4.14 BY .79 NO-UNDO.

DEFINE VARIABLE cod-prioridade-mrp-cd1112 AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Priori. MRP" 
     VIEW-AS FILL-IN 
     SIZE 4.29 BY .79 NO-UNDO.

DEFINE VARIABLE cod-qtde-politica-cd1112 AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     LABEL "QP" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE cod-tp-despesa-cd0140 AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Tipo Despesa" 
     VIEW-AS FILL-IN 
     SIZE 6.43 BY .88 NO-UNDO.

DEFINE VARIABLE cod-unid-negoc-cd0140 AS CHARACTER FORMAT "X(03)":U INITIAL "0" 
     LABEL "Unid. Negocio" 
     VIEW-AS FILL-IN 
     SIZE 6.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-II AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% II" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-IPI AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% IPI" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE des-deposito-cd0140 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 29.43 BY .88 NO-UNDO.

DEFINE VARIABLE des-nat-despesa-cd0140 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 29.43 BY .88 NO-UNDO.

DEFINE VARIABLE des-planejador-cd1112 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 38.57 BY .79 NO-UNDO.

DEFINE VARIABLE des-tip-despesa-cd0140 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 29.43 BY .88 NO-UNDO.

DEFINE VARIABLE des-unid-negoc-cd0140 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 29.43 BY .88 NO-UNDO.

DEFINE VARIABLE i-codigo-orig-cd0140 AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Origem Estab" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE it-cod-comprado-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE it-cod-comprado-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Comprador" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE it-cod-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE it-cod-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE it-estab-com AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Ressupr. Com." 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .79 NO-UNDO.

DEFINE VARIABLE it-estab-cons AS DECIMAL FORMAT "->>>>,>>9.9999":U INITIAL 0 
     LABEL "Cons Previsto" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE it-estab-cons-aad AS DECIMAL FORMAT "->,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Cons AtÇ a Data" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE it-estab-cq AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Ressupr. CQ." 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .79 NO-UNDO.

DEFINE VARIABLE it-estab-horiz AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Horizonte Liber / Fixo" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .79 NO-UNDO.

DEFINE VARIABLE it-estab-ts AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "TS" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE nat-despesa-cd0140 AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Nat. Despesa" 
     VIEW-AS FILL-IN 
     SIZE 6.43 BY .88 NO-UNDO.

DEFINE VARIABLE un-cd1112 AS CHARACTER FORMAT "X(2)":U INITIAL "0" 
     LABEL "Un" 
     VIEW-AS FILL-IN 
     SIZE 4.29 BY .79 NO-UNDO.

DEFINE VARIABLE vl-lote-minimo-cd1112 AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     LABEL "Lote M°nimo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .79 NO-UNDO.

DEFINE VARIABLE vl-lote-multiplo-cd1112 AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     LABEL "Lote Multiplo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .79 NO-UNDO.

DEFINE VARIABLE vl-qs-cd1112 AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     LABEL "QS" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE vl-ressupr-for-cd1112 AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Ressupr. For" 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .79 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE it-estab-tipo AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Quantidade", 1,
"Tempo", 2
     SIZE 11 BY 1.5 NO-UNDO.

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 8.5.

DEFINE RECTANGLE RECT-44
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 74.29 BY 7.54.

DEFINE RECTANGLE RECT-45
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 1.75.

DEFINE RECTANGLE RECT-47
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 127.72 BY 6.79.

DEFINE RECTANGLE RECT-48
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 2.71.

DEFINE RECTANGLE RECT-49
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 52.57 BY 7.54.

DEFINE RECTANGLE RECT-50
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 4.

DEFINE RECTANGLE RECT-52
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18 BY 4.

DEFINE VARIABLE l-antidumping AS LOGICAL INITIAL no 
     LABEL "Tem Antidumping" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE log-control-qualidade-ce0330 AS LOGICAL INITIAL no 
     LABEL "Controle Qualidade" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE log-necessita-li AS LOGICAL INITIAL no 
     LABEL "Necessita LI" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE log-repres-demanda-cd1112 AS LOGICAL INITIAL no 
     LABEL "Represa Demanda" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-ativo AS LOGICAL INITIAL yes 
     LABEL "Ativo" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-depende AS LOGICAL INITIAL yes 
     LABEL "Dependente" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-independe AS LOGICAL INITIAL yes 
     LABEL "Independente" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-inspec AS LOGICAL INITIAL no 
     LABEL "Necessita Inspeá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tg-obso-ordauto AS LOGICAL INITIAL yes 
     LABEL "Obsoleto Ordens Autom†ticas" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-obso-todas AS LOGICAL INITIAL yes 
     LABEL "Obsoleto Todas as Ordens" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE tg-total-obso AS LOGICAL INITIAL yes 
     LABEL "Totalmente Obsoleto" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-erro FOR 
      tt-erro SCROLLING.

DEFINE QUERY br-item-estab FOR 
      tt-item-uni-estab-aux, 
      ITEM SCROLLING.

DEFINE QUERY br-item-fornec-estab FOR 
      tt-item-fornec-estab SCROLLING.

DEFINE QUERY br-item-tab FOR 
      tt-item-tab SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-erro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-erro wWindow _FREEFORM
  QUERY br-erro DISPLAY
      prob-erro COLUMN-LABEL "Problema"
      solu-erro COLUMN-LABEL "Soluá∆o"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 127.29 BY 4.25
         FGCOLOR 12 FONT 1
         TITLE FGCOLOR 12 "Erros" ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.

DEFINE BROWSE br-item-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-item-estab wWindow _FREEFORM
  QUERY br-item-estab DISPLAY
      tt-item-uni-estab-aux.it-codigo     FORMAT "x(7)" COLUMN-LABEL "C¢digo item"
      ITEM.desc-item               COLUMN-LABEL "Descriá∆o"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 60 BY 5.17
         FONT 1
         TITLE "Lista de Itens" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.

DEFINE BROWSE br-item-fornec-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-item-fornec-estab wWindow _FREEFORM
  QUERY br-item-fornec-estab DISPLAY
      tt-item-fornec-estab.cod-estabel    column-label "Estab"
    tt-item-fornec-estab.cod-emitente   column-label "Fornec"
    tt-item-fornec-estab.nome-abrev     column-label "Nome For"
    tt-item-fornec-estab.fabricante     column-label "Fabricante"
    tt-item-fornec-estab.unid-medida    column-label "Uni" WIDTH 3
    tt-item-fornec-estab.fat-conv       column-label "Ft Conv" WIDTH 8
    tt-item-fornec-estab.casa-dec       column-label "De" WIDTH 2
    tt-item-fornec-estab.perc-compra    column-label "%"
    tt-item-fornec-estab.ativo          column-label "Ativo"
    tt-item-fornec-estab.lote-min-for   column-label "Lot Min"
    tt-item-fornec-estab.lote-mul-for   column-label "Lot Mult"
    tt-item-fornec-estab.cot-aut        column-label "Cot Aut"
    fnDesc-class-reprog(tt-item-fornec-estab.classe-repro) @ c-class-reprog-browse column-label "Clas. Reprog" WIDTH 10
    tt-item-fornec-estab.horizonte-fixo column-label "HF"
    tt-item-fornec-estab.tempo-ressup   column-label "T Rsp"
    tt-item-fornec-estab.i-cod-cond-pag column-label "CPI"
    tt-item-fornec-estab.moeda-des      column-label "Moeda" WIDTH 5
    tt-item-fornec-estab.e-cod-cond-pag column-label "CPF"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 115 BY 5.13
         FONT 1
         TITLE "Cotaá‰es Item Fornecedor Estabelecimento ( CC0531 )".

DEFINE BROWSE br-item-tab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-item-tab wWindow _FREEFORM
  QUERY br-item-tab DISPLAY
      tt-item-tab.cod-emitente                    column-label "Fornec"  WIDTH 8
    tt-item-tab.nr-tab                            column-label "Nr. TAB" WIDTH 8
    tt-item-tab.t-cod-cond-pag                    column-label "CPT"
    tt-item-tab.taxa-fin                          column-label "Tax Fin"  WIDTH 5
    tt-item-tab.dias-taxa                         column-label "Dias Tax" WIDTH 6
    tt-item-tab.preco                             column-label "Preáo"    WIDTH 9.5
    fnDesc-moeda(tt-item-tab.moeda) @ c-descMoeda column-label "Moeda"    WIDTH 7
    tt-item-tab.qty-min                           column-label "Qty Min"
    tt-item-tab.perc-ipi                          column-label "%IPI"     WIDTH 5
    tt-item-tab.perc-icms                         column-label "%ICMS"    WIDTH 5
    tt-item-tab.dt-inic                           column-label "Dat Inic"
    tt-item-tab.dt-term                           column-label "Dat Term"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 73 BY 5.13
         FONT 1
         TITLE "Condiá‰es Compras Itens Tabelas Preáos ( CC0313 )".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage1
     btCC0531 AT ROW 25.71 COL 2 WIDGET-ID 370
     cod-estab-sel AT ROW 1.92 COL 9.57 COLON-ALIGNED WIDGET-ID 4
     it-cod-comprado-ini AT ROW 2.92 COL 9.57 COLON-ALIGNED WIDGET-ID 40
     it-cod-comprado-fim AT ROW 2.92 COL 36.72 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     it-cod-ini AT ROW 3.92 COL 9.57 COLON-ALIGNED WIDGET-ID 44
     it-cod-fim AT ROW 3.92 COL 36.72 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     tg-ativo AT ROW 5.96 COL 12.43 WIDGET-ID 328
     tg-obso-ordauto AT ROW 6.71 COL 12.43 WIDGET-ID 330
     tg-obso-todas AT ROW 7.46 COL 12.43 WIDGET-ID 332
     tg-total-obso AT ROW 8.21 COL 12.43 WIDGET-ID 334
     tg-depende AT ROW 6.58 COL 37.43 WIDGET-ID 336
     tg-independe AT ROW 7.33 COL 37.43 WIDGET-ID 338
     bt-procurar AT ROW 7.83 COL 55.43
     cod-estab-gestor-cc0120 AT ROW 16.04 COL 11.14 COLON-ALIGNED WIDGET-ID 154
     cod-comprador-cc0120 AT ROW 16.04 COL 22 COLON-ALIGNED WIDGET-ID 156
     c-nome-comprador AT ROW 16.04 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 256
     log-control-qualidade-ce0330 AT ROW 19.21 COL 11.29 WIDGET-ID 324
     it-estab-cons AT ROW 18.21 COL 44 COLON-ALIGNED WIDGET-ID 286
     it-estab-cons-aad AT ROW 19.21 COL 44 COLON-ALIGNED WIDGET-ID 368
     cod-deposito-cd0140 AT ROW 1.75 COL 72.86 COLON-ALIGNED WIDGET-ID 92
     des-deposito-cd0140 AT ROW 1.75 COL 79.57 COLON-ALIGNED NO-LABEL WIDGET-ID 104
     cod-tp-despesa-cd0140 AT ROW 2.75 COL 72.86 COLON-ALIGNED WIDGET-ID 94
     des-tip-despesa-cd0140 AT ROW 2.75 COL 79.57 COLON-ALIGNED NO-LABEL WIDGET-ID 106
     nat-despesa-cd0140 AT ROW 3.75 COL 72.86 COLON-ALIGNED WIDGET-ID 98
     des-nat-despesa-cd0140 AT ROW 3.75 COL 79.57 COLON-ALIGNED NO-LABEL WIDGET-ID 108
     i-codigo-orig-cd0140 AT ROW 4.75 COL 72.86 COLON-ALIGNED WIDGET-ID 364
     c-desc-origem AT ROW 4.75 COL 77 COLON-ALIGNED NO-LABEL WIDGET-ID 366
     cod-unid-negoc-cd0140 AT ROW 5.75 COL 72.86 COLON-ALIGNED WIDGET-ID 116
     des-unid-negoc-cd0140 AT ROW 5.75 COL 79.57 COLON-ALIGNED NO-LABEL WIDGET-ID 114
     c-observacao AT ROW 6.75 COL 72.86 COLON-ALIGNED WIDGET-ID 242
     cb-cod-obsol-cd0140 AT ROW 7.75 COL 72.86 COLON-ALIGNED WIDGET-ID 210
     cod-planejador-cd1112 AT ROW 9.38 COL 77.29 COLON-ALIGNED WIDGET-ID 274
     des-planejador-cd1112 AT ROW 9.38 COL 90.43 COLON-ALIGNED NO-LABEL WIDGET-ID 282
     vl-lote-multiplo-cd1112 AT ROW 10.25 COL 77.29 COLON-ALIGNED WIDGET-ID 308
     vl-lote-minimo-cd1112 AT ROW 11.17 COL 77.29 COLON-ALIGNED WIDGET-ID 306
     it-estab-horiz AT ROW 12.13 COL 77.29 COLON-ALIGNED WIDGET-ID 290
     cod-horiz-fixo-cd1112 AT ROW 12.13 COL 82.72 COLON-ALIGNED WIDGET-ID 270
     vl-ressupr-for-cd1112 AT ROW 13.04 COL 77.29 COLON-ALIGNED WIDGET-ID 312
     it-estab-cq AT ROW 13.96 COL 77.29 COLON-ALIGNED WIDGET-ID 288
     it-estab-com AT ROW 14.88 COL 77.29 COLON-ALIGNED WIDGET-ID 284
     cod-per-fixo-cd1112 AT ROW 10.25 COL 108 COLON-ALIGNED WIDGET-ID 272
     cod-prioridade-cd1112 AT ROW 11.17 COL 108 COLON-ALIGNED WIDGET-ID 276
     cod-prioridade-mrp-cd1112 AT ROW 12.13 COL 108 COLON-ALIGNED WIDGET-ID 278
     cb-politica-cd1112 AT ROW 9.67 COL 135.43 COLON-ALIGNED WIDGET-ID 264
     cb-tp-demanda-cd1112 AT ROW 10.67 COL 135.43 COLON-ALIGNED WIDGET-ID 268
     cb-classe-reprog-cd1112 AT ROW 11.67 COL 135.43 COLON-ALIGNED WIDGET-ID 258
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.92
         SIZE 190 BY 25.79
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage1
     cb-reabastace-cd1112 AT ROW 12.67 COL 135.43 COLON-ALIGNED WIDGET-ID 266
     cb-emis-ordens-cd1112 AT ROW 13.67 COL 135.43 COLON-ALIGNED WIDGET-ID 262
     cb-divisao-ordens-cd1112 AT ROW 14.67 COL 135.43 COLON-ALIGNED WIDGET-ID 260
     log-repres-demanda-cd1112 AT ROW 9.67 COL 167.29 WIDGET-ID 298
     it-estab-tipo AT ROW 10.92 COL 167.29 NO-LABEL WIDGET-ID 292
     vl-qs-cd1112 AT ROW 12.67 COL 168 COLON-ALIGNED WIDGET-ID 310
     it-estab-ts AT ROW 13.67 COL 168 COLON-ALIGNED WIDGET-ID 296
     cod-qtde-politica-cd1112 AT ROW 14.67 COL 168 COLON-ALIGNED WIDGET-ID 280
     c-desc-NCM AT ROW 7.67 COL 151.29 COLON-ALIGNED NO-LABEL WIDGET-ID 326
     c-NCM AT ROW 7.67 COL 141 COLON-ALIGNED WIDGET-ID 318
     de-perc-II AT ROW 6.67 COL 141 COLON-ALIGNED WIDGET-ID 316
     de-perc-IPI AT ROW 5.67 COL 141 COLON-ALIGNED WIDGET-ID 314
     l-antidumping AT ROW 4.67 COL 143 WIDGET-ID 254
     log-necessita-li AT ROW 3.67 COL 143 WIDGET-ID 252
     tg-inspec AT ROW 2.67 COL 143 WIDGET-ID 250
     br-item-estab AT ROW 9.96 COL 2
     br-erro AT ROW 16.08 COL 62.72
     br-item-fornec-estab AT ROW 20.54 COL 116 RIGHT-ALIGNED
     cb-classif-abc-ce0330 AT ROW 18.21 COL 8.86 COLON-ALIGNED WIDGET-ID 350
     cb-criticidade-ce0330 AT ROW 18.21 COL 24.86 COLON-ALIGNED WIDGET-ID 352
     br-item-tab AT ROW 20.54 COL 190 RIGHT-ALIGNED WIDGET-ID 100
     btCC0313 AT ROW 25.71 COL 118 WIDGET-ID 372
     un-cd1112 AT ROW 13.04 COL 108 COLON-ALIGNED WIDGET-ID 374
     "Seleá∆o Item x Estabelecimento" VIEW-AS TEXT
          SIZE 22 BY .54 AT ROW 1 COL 3 WIDGET-ID 228
     "Demanda:" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 5.08 COL 37.43 WIDGET-ID 342
     "CC0120" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 15.33 COL 3 WIDGET-ID 234
     "CD0140" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 1 COL 63.72 WIDGET-ID 238
     "CE0330" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 17.46 COL 3 WIDGET-ID 240
     "Classificaá∆o Fiscal" VIEW-AS TEXT
          SIZE 13.86 BY .54 AT ROW 1 COL 139.14 WIDGET-ID 246
     "/" VIEW-AS TEXT
          SIZE .86 BY .79 AT ROW 12.13 COL 83.57 WIDGET-ID 302
     "CD1112" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 8.92 COL 64.14 WIDGET-ID 304
     "Situaá∆o:" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 5.08 COL 12.43 WIDGET-ID 340
     IMAGE-3 AT ROW 3.92 COL 31 WIDGET-ID 12
     IMAGE-4 AT ROW 3.92 COL 35.72 WIDGET-ID 14
     IMAGE-1 AT ROW 2.92 COL 31.14 WIDGET-ID 66
     IMAGE-2 AT ROW 2.92 COL 35.86 WIDGET-ID 68
     RECT-39 AT ROW 1.25 COL 2 WIDGET-ID 76
     RECT-44 AT ROW 1.25 COL 62.72 WIDGET-ID 144
     RECT-45 AT ROW 15.54 COL 2 WIDGET-ID 160
     RECT-48 AT ROW 17.67 COL 2 WIDGET-ID 236
     RECT-49 AT ROW 1.25 COL 137.72 WIDGET-ID 244
     RECT-47 AT ROW 9.13 COL 62.72 WIDGET-ID 300
     RECT-50 AT ROW 5.33 COL 11.43 WIDGET-ID 344
     RECT-52 AT ROW 5.33 COL 36.43 WIDGET-ID 348
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.92
         SIZE 190 BY 25.79
         FONT 1.

DEFINE FRAME fpage0
     btUpdate AT ROW 1.17 COL 1.57 HELP
          "Altera ocorrància corrente"
     btCancel AT ROW 1.17 COL 6.72 HELP
          "Cancela alteraá‰es"
     btSave AT ROW 1.17 COL 11.86 HELP
          "Confirma alteraá‰es"
     btExit AT ROW 1.17 COL 185.57 HELP
          "Sair"
     rtToolBar AT ROW 1.08 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 191.29 BY 1.88
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
         HEIGHT             = 27.5
         WIDTH              = 182.86
         MAX-HEIGHT         = 27.71
         MAX-WIDTH          = 192.57
         VIRTUAL-HEIGHT     = 27.71
         VIRTUAL-WIDTH      = 192.57
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
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
  NOT-VISIBLE,                                                          */
/* SETTINGS FOR FRAME fpage0
                                                                        */
ASSIGN 
       FRAME fpage0:RESIZABLE        = TRUE.

/* SETTINGS FOR FRAME fpage1
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-item-estab tg-inspec fpage1 */
/* BROWSE-TAB br-erro br-item-estab fpage1 */
/* BROWSE-TAB br-item-fornec-estab br-erro fpage1 */
/* BROWSE-TAB br-item-tab cb-criticidade-ce0330 fpage1 */
/* SETTINGS FOR BROWSE br-item-fornec-estab IN FRAME fpage1
   ALIGN-R                                                              */
/* SETTINGS FOR BROWSE br-item-tab IN FRAME fpage1
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN c-desc-NCM IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-origem IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-NCM IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-comprador IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-classe-reprog-cd1112 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-cod-obsol-cd0140 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-criticidade-ce0330 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-divisao-ordens-cd1112 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-emis-ordens-cd1112 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-politica-cd1112 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-reabastace-cd1112 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-tp-demanda-cd1112 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cod-comprador-cc0120 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cod-deposito-cd0140 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cod-estab-gestor-cc0120 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cod-horiz-fixo-cd1112 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cod-per-fixo-cd1112 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cod-planejador-cd1112 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cod-prioridade-cd1112 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cod-prioridade-mrp-cd1112 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cod-qtde-politica-cd1112 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cod-tp-despesa-cd0140 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cod-unid-negoc-cd0140 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-perc-II IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-perc-IPI IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN des-deposito-cd0140 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN des-nat-despesa-cd0140 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN des-planejador-cd1112 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN des-tip-despesa-cd0140 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN des-unid-negoc-cd0140 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-cod-comprado-ini IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-estab-com IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-estab-cons IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-estab-cons-aad IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-estab-cq IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-estab-horiz IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-estab-ts IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX log-control-qualidade-ce0330 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN nat-despesa-cd0140 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN un-cd1112 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN vl-lote-minimo-cd1112 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN vl-lote-multiplo-cd1112 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN vl-qs-cd1112 IN FRAME fpage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN vl-ressupr-for-cd1112 IN FRAME fpage1
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-erro
/* Query rebuild information for BROWSE br-erro
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-erro.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-erro */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-item-estab
/* Query rebuild information for BROWSE br-item-estab
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-item-uni-estab-aux NO-LOCK,
                            FIRST ITEM NO-LOCK
                            WHERE ITEM.it-codigo = tt-item-uni-estab-aux.it-codigo.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-item-estab */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-item-fornec-estab
/* Query rebuild information for BROWSE br-item-fornec-estab
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-item-fornec-estab.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-item-fornec-estab */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-item-tab
/* Query rebuild information for BROWSE br-item-tab
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-item-tab
                           WHERE tt-item-tab.r-item-fornec-estab = tt-item-fornec-estab.r-item-fornec-estab.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-item-tab */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage1
/* Query rebuild information for FRAME fpage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage1 */
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


&Scoped-define SELF-NAME fpage1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fpage1 wWindow
ON ENTRY OF FRAME fpage1
DO:
    APPLY "entry" TO it-cod-comprado-ini IN FRAME fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-item-estab
&Scoped-define SELF-NAME br-item-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-item-estab wWindow
ON ENTRY OF br-item-estab IN FRAME fpage1 /* Lista de Itens */
DO:
    IF  CAN-FIND(FIRST tt-item-uni-estab-aux) THEN DO:
        RUN pi-monta. 
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-item-estab wWindow
ON MOUSE-SELECT-CLICK OF br-item-estab IN FRAME fpage1 /* Lista de Itens */
DO:
    APPLY "value-changed" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-item-estab wWindow
ON MOUSE-SELECT-DBLCLICK OF br-item-estab IN FRAME fpage1 /* Lista de Itens */
DO:
    IF  AVAIL tt-item-uni-estab-aux THEN DO:
        RUN pi-reposiciona-cc0120(INPUT tt-item-uni-estab-aux.r-rowid).  
        APPLY "CHOOSE" TO bt-procurar IN FRAME fPage1.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-item-estab wWindow
ON VALUE-CHANGED OF br-item-estab IN FRAME fpage1 /* Lista de Itens */
DO:
    IF  CAN-FIND(FIRST tt-item-uni-estab-aux) THEN DO:
        RUN pi-monta.
        RUN pi-posiciona.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-item-fornec-estab
&Scoped-define SELF-NAME br-item-fornec-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-item-fornec-estab wWindow
ON MOUSE-SELECT-CLICK OF br-item-fornec-estab IN FRAME fpage1 /* Cotaá‰es Item Fornecedor Estabelecimento ( CC0531 ) */
DO:
    IF  AVAIL tt-item-fornec-estab THEN DO:
        RUN pi-posiciona.

        RUN pi-posiciona-preco.

    END. /* IF  AVAIL tt-item-fornec-estab THEN DO: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-item-fornec-estab wWindow
ON MOUSE-SELECT-DBLCLICK OF br-item-fornec-estab IN FRAME fpage1 /* Cotaá‰es Item Fornecedor Estabelecimento ( CC0531 ) */
DO:
    IF  AVAIL tt-item-fornec-estab THEN DO:

        ASSIGN gr-item-uni-estab = tt-item-fornec-estab.r-item-uni-estab.

        FIND FIRST item-uni-estab NO-LOCK
            WHERE rowid(item-uni-estab) = tt-item-fornec-estab.r-item-uni-estab NO-ERROR.

        IF  gr-item-uni-estab <> ? THEN DO:
            RUN ccp/cc0531.w.

            EMPTY TEMP-TABLE tt-item-fornec-estab NO-ERROR.
            
            RUN atualiza-for.

            APPLY "value-changed" TO br-item-fornec-estab IN FRAME fpage1.
        END.
    END.
    ELSE MESSAGE "N∆o encontrado Fornecedor cadastrado para esse Item e Estabelecimento" VIEW-AS ALERT-BOX INFO BUTTONS OK.

    APPLY "CHOOSE" TO bt-procurar IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-item-fornec-estab wWindow
ON VALUE-CHANGED OF br-item-fornec-estab IN FRAME fpage1 /* Cotaá‰es Item Fornecedor Estabelecimento ( CC0531 ) */
DO:
    RUN pi-posiciona.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-item-tab
&Scoped-define SELF-NAME br-item-tab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-item-tab wWindow
ON MOUSE-SELECT-CLICK OF br-item-tab IN FRAME fpage1 /* Condiá‰es Compras Itens Tabelas Preáos ( CC0313 ) */
DO:
    RUN pi-posiciona.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-item-tab wWindow
ON MOUSE-SELECT-DBLCLICK OF br-item-tab IN FRAME fpage1 /* Condiá‰es Compras Itens Tabelas Preáos ( CC0313 ) */
DO:
    IF  AVAIL tt-item-tab THEN DO:
           
        FIND FIRST item-tab NO-LOCK
            WHERE rowid(item-tab) = tt-item-tab.r-item-tab NO-ERROR.
        IF  AVAIL item-tab THEN DO:
            FIND FIRST tb-pr-cc OF item-tab NO-LOCK.
            IF  AVAIL tb-pr-cc THEN ASSIGN gr-tb-pr-cc = ROWID(tb-pr-cc).
        END.

        IF gr-tb-pr-cc <> ? THEN DO:
            RUN ccp/cc0313.w.

            EMPTY TEMP-TABLE tt-item-tab NO-ERROR.
            
            RUN atualiza-for.
            
            APPLY "value-changed" TO br-item-tab IN FRAME fpage1.
        END.
    END. /* IF  AVAIL tt-item-tab THEN DO: */
    ELSE MESSAGE "N∆o encontrado Fornecedor cadastrado para esse Item e Estabelecimento" VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-item-tab wWindow
ON VALUE-CHANGED OF br-item-tab IN FRAME fpage1 /* Condiá‰es Compras Itens Tabelas Preáos ( CC0313 ) */
DO:
    RUN pi-posiciona.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-procurar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-procurar wWindow
ON CHOOSE OF bt-procurar IN FRAME fpage1 /* Procurar... */
DO:
    
    IF  (INPUT FRAME fPage1 it-cod-comprado-ini = "" AND INPUT FRAME fPage1 it-cod-comprado-fim = "ZZZZZZZZZZZZ")
    AND (INPUT FRAME fPage1 it-cod-ini          = "" AND INPUT FRAME fPage1 it-cod-fim      = "ZZZZZZZZZZZZZZZZ") THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 27100,
                           INPUT "Confirma execuá∆o?" + "~~" + 
                                 "Vocà est† informando a faixa m†xima de comprador e item, isso deixar† a execuá∆o do programa lenta. Prosseguir?").
         if  return-value = "no" then do:
             apply 'entry':U to it-cod-comprado-ini in frame fPage1.
             RETURN NO-APPLY.
         end.
    END.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Buscando ...").

    ASSIGN br-item-estab:VISIBLE = YES.

    EMPTY TEMP-TABLE tt-item-uni-estab-aux NO-ERROR.
    EMPTY TEMP-TABLE ttErro-busca          NO-ERROR.
    EMPTY TEMP-TABLE tt-item-fornec-estab  NO-ERROR.
    EMPTY TEMP-TABLE tt-item-tab           NO-ERROR.
    EMPTY TEMP-TABLE tt-erro               NO-ERROR.
    
    IF  CAN-FIND(FIRST item-uni-estab 
                 WHERE item-uni-estab.cod-estabel   = cod-estab-sel:SCREEN-VALUE       IN FRAME fpage1
                 AND   item-uni-estab.cod-comprado >= it-cod-comprado-ini:SCREEN-VALUE IN FRAME fpage1
                 AND   item-uni-estab.cod-comprado <= it-cod-comprado-fim:SCREEN-VALUE IN FRAME fpage1
                 AND   item-uni-estab.it-codigo    >= it-cod-ini:SCREEN-VALUE          IN FRAME fpage1
                 AND   item-uni-estab.it-codigo    <= it-cod-fim:SCREEN-VALUE          IN FRAME fpage1) THEN DO: 

        blk_item:
        FOR EACH  item-uni-estab NO-LOCK 
            WHERE item-uni-estab.cod-estabel   = cod-estab-sel:SCREEN-VALUE       IN FRAME fpage1
            AND   item-uni-estab.cod-comprado >= it-cod-comprado-ini:SCREEN-VALUE IN FRAME fpage1
            AND   item-uni-estab.cod-comprado <= it-cod-comprado-fim:SCREEN-VALUE IN FRAME fpage1
            AND   item-uni-estab.it-codigo    >= it-cod-ini:SCREEN-VALUE          IN FRAME fpage1
            AND   item-uni-estab.it-codigo    <= it-cod-fim:SCREEN-VALUE          IN FRAME fpage1:

            RUN pi-acompanhar IN h-acomp (INPUT "Estab: " + STRING(item-uni-estab.cod-estabel) + " Item: " + STRING(item-uni-estab.it-codigo)).

            /*---[ Validaá‰es ]--------------------------------------------------------*/
            IF  (item-uni-estab.demanda = 1 /* Dependente */   AND NOT tg-depende:CHECKED   IN FRAME fPage1)
            OR  (item-uni-estab.demanda = 2 /* Independente */ AND NOT tg-independe:CHECKED IN FRAME fPage1) THEN DO:
                CREATE ttErro-busca.
                ASSIGN ttErro-busca.i-sequen = 1
                       ttErro-busca.cd-erro  = 17006
                       ttErro-busca.mensagem = "Item tem demanda diferente do parametrizado." 
                                                + CHR(10) + "Estabelecimento : " + STRING(item-uni-estab.cod-estabel) 
                                                + CHR(10) + "ITEM ...........: " + item-uni-estab.it-codigo 
                                                + CHR(10) + "Demanda ........: " + STRING({ininc/i02in122.i 04 item-uni-estab.demanda}).
            END.

            IF  (item-uni-estab.cod-obsoleto = 1 /* Ativo */                       AND NOT tg-ativo:CHECKED        IN FRAME fPage1)
            OR  (item-uni-estab.cod-obsoleto = 2 /* Obsoleto Ordens Autom†ticas */ AND NOT tg-obso-ordauto:CHECKED IN FRAME fPage1)
            OR  (item-uni-estab.cod-obsoleto = 3 /* Obsoleto Todas Ordens */       AND NOT tg-obso-todas:CHECKED   IN FRAME fPage1)
            OR  (item-uni-estab.cod-obsoleto = 4 /* Totalmente Obsoleto */         AND NOT tg-total-obso:CHECKED   IN FRAME fPage1) THEN DO:
                CREATE ttErro-busca.
                ASSIGN ttErro-busca.i-sequen = 2
                       ttErro-busca.cd-erro  = 17006
                       ttErro-busca.mensagem = "Item tem situaá∆o diferente do parametrizado." 
                                                + CHR(10) + "Estabelecimento : " + STRING(item-uni-estab.cod-estabel) 
                                                + CHR(10) + "ITEM ...........: " + item-uni-estab.it-codigo 
                                                + CHR(10) + "Situaá∆o .......: " + STRING({ininc/i17in172.i 04 item-uni-estab.cod-obsoleto}).
            END.
            
            /* Verificando DEMANDA ... */
            IF item-uni-estab.demanda = 1 AND NOT tg-depende:CHECKED   IN FRAME fPage1 THEN NEXT blk_item.
            IF item-uni-estab.demanda = 2 AND NOT tg-independe:CHECKED IN FRAME fPage1 THEN NEXT blk_item.

            /* Verificando SITUAÄ«O ... */
            IF item-uni-estab.cod-obsoleto = 1 AND NOT tg-ativo:CHECKED        IN FRAME fPage1 THEN NEXT blk_item.
            IF item-uni-estab.cod-obsoleto = 2 AND NOT tg-obso-ordauto:CHECKED IN FRAME fPage1 THEN NEXT blk_item.
            IF item-uni-estab.cod-obsoleto = 3 AND NOT tg-obso-todas:CHECKED   IN FRAME fPage1 THEN NEXT blk_item.
            IF item-uni-estab.cod-obsoleto = 4 AND NOT tg-total-obso:CHECKED   IN FRAME fPage1 THEN NEXT blk_item.
          
            CREATE tt-item-uni-estab-aux.
            BUFFER-COPY item-uni-estab TO tt-item-uni-estab-aux 
                ASSIGN tt-item-uni-estab-aux.r-rowid = rowid(item-uni-estab) NO-ERROR.
        END. /* FOR EACH item-uni-estab NO-LOCK */
          
        {&OPEN-QUERY-Br-item-estab}   

        APPLY "entry"         TO br-item-estab.    
        APPLY "value-changed" TO br-item-estab.    

        ASSIGN btupdate:SENSITIVE IN FRAME fpage0 = TRUE.

    END. /* IF  CAN-FIND(FIRST item-uni-estab NO-LOCK */
    ELSE DO:
        CREATE ttErro-busca.
        ASSIGN ttErro-busca.i-sequen = 3
               ttErro-busca.cd-erro  = 17006
               ttErro-busca.mensagem = "Registro n∆o encontrado." + "~~" + "N∆o foram encontrados registros no sistema com os par∆metros informados. Favor revisar.".
    END. /* ELSE DO: */

    RUN pi-finalizar IN h-acomp.

    IF  can-find(FIRST ttErro-busca) AND NOT can-find(tt-item-uni-estab-aux) THEN DO:
        RUN cdp/cd0666.w (INPUT TABLE ttErro-busca).

        EMPTY TEMP-TABLE tt-item-uni-estab-aux NO-ERROR.
        EMPTY TEMP-TABLE ttErro-busca         NO-ERROR.

        CLEAR FRAME fPage1 ALL NO-PAUSE.
        RUN afterInitializeInterface.
    END.
    
    IF NOT CAN-FIND(FIRST tt-item-fornec-estab) 
    THEN ASSIGN btCC0531:SENSITIVE IN FRAME fPage1 = TRUE.
    ELSE ASSIGN btCC0531:SENSITIVE IN FRAME fPage1 = FALSE.

    IF NOT CAN-FIND(FIRST tt-item-tab) 
    THEN ASSIGN btCC0313:SENSITIVE IN FRAME fPage1 = TRUE.
    ELSE ASSIGN btCC0313:SENSITIVE IN FRAME fPage1 = FALSE.

    APPLY 'MOUSE-SELECT-CLICK':U TO br-item-fornec-estab.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    /*RUN cancelRecord IN THIS-PROCEDURE.*/

    DISABLE ALL WITH FRAME fpage1.
    
    /*ENABLE*/                   
    ASSIGN btcancel                     :sensitive in frame fpage0 = NO
           btsave                       :sensitive in frame fpage0 = NO
           btupdate                     :sensitive in frame fpage0 = TRUE
           cod-estab-sel                :sensitive in frame fpage1 = TRUE
           it-cod-comprado-ini          :sensitive in frame fpage1 = TRUE
           it-cod-comprado-fim          :sensitive in frame fpage1 = TRUE
           it-cod-ini                   :sensitive in frame fpage1 = TRUE
           it-cod-fim                   :sensitive in frame fpage1 = TRUE
           tg-ativo                     :sensitive in frame fpage1 = TRUE
           tg-obso-ordauto              :sensitive in frame fpage1 = TRUE
           tg-obso-todas                :sensitive in frame fpage1 = TRUE
           tg-total-obso                :sensitive in frame fpage1 = TRUE
           tg-depende                   :sensitive in frame fpage1 = TRUE
           tg-independe                 :sensitive in frame fpage1 = TRUE
           bt-procurar                  :sensitive in frame fpage1 = TRUE
           br-item-estab                :sensitive in frame fpage1 = TRUE
           br-item-fornec-estab         :sensitive in frame fpage1 = TRUE
           br-item-tab       :sensitive in frame fpage1 = TRUE.

    APPLY "choose" TO bt-procurar IN FRAME fpage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage1
&Scoped-define SELF-NAME btCC0313
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCC0313 wWindow
ON CHOOSE OF btCC0313 IN FRAME fpage1 /* CC0313 */
DO:
    RUN ccp/cc0313.w.

    EMPTY TEMP-TABLE tt-item-tab NO-ERROR.
    RUN atualiza-for.
    APPLY "value-changed" TO br-item-tab IN FRAME fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCC0531
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCC0531 wWindow
ON CHOOSE OF btCC0531 IN FRAME fpage1 /* CC0531 */
DO:
    RUN ccp/cc0531.w.

    EMPTY TEMP-TABLE tt-item-fornec-estab NO-ERROR.
    RUN atualiza-for.
    APPLY "value-changed" TO br-item-fornec-estab IN FRAME fpage1.  

    APPLY "CHOOSE" TO bt-procurar IN FRAME fPage1.
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


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wWindow
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:
    
    RUN pi-save.

    IF RETURN-VALUE <> "OK":U THEN
        RETURN NO-APPLY.

    DISABLE ALL WITH FRAME fpage1.
    
    /*ENABLE*/                   
    ASSIGN btcancel                     :sensitive in frame fpage0 = NO
           btsave                       :sensitive in frame fpage0 = NO
           btupdate                     :sensitive in frame fpage0 = TRUE
           cod-estab-sel                :sensitive in frame fpage1 = TRUE
           it-cod-comprado-ini          :sensitive in frame fpage1 = TRUE
           it-cod-comprado-fim          :sensitive in frame fpage1 = TRUE
           it-cod-ini                   :sensitive in frame fpage1 = TRUE
           it-cod-fim                   :sensitive in frame fpage1 = TRUE
           tg-ativo                     :sensitive in frame fpage1 = TRUE
           tg-obso-ordauto              :sensitive in frame fpage1 = TRUE
           tg-obso-todas                :sensitive in frame fpage1 = TRUE
           tg-total-obso                :sensitive in frame fpage1 = TRUE
           tg-depende                   :sensitive in frame fpage1 = TRUE
           tg-independe                 :sensitive in frame fpage1 = TRUE
           bt-procurar                  :sensitive in frame fpage1 = TRUE
           br-item-estab                :sensitive in frame fpage1 = TRUE
           br-item-fornec-estab         :sensitive in frame fpage1 = TRUE
           br-item-tab       :sensitive in frame fpage1 = TRUE.

    APPLY "choose" TO bt-procurar IN FRAME fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wWindow
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    /*RUN updateRecord IN THIS-PROCEDURE.*/

    /*ENABLE*/
    ENABLE ALL WITH FRAME fPage1.
    ASSIGN btcancel               :sensitive in frame fpage0 = true
           btsave                 :sensitive in frame fpage0 = true.
                                  
    /*DISABLE*/                   
    ASSIGN btupdate                    :sensitive in frame fpage0 = false
           c-observacao                :sensitive in frame fpage1 = false 
           cod-estab-sel               :sensitive in frame fpage1 = false
           it-cod-comprado-ini         :sensitive in frame fpage1 = false
           it-cod-comprado-fim         :sensitive in frame fpage1 = false
           tg-inspec                   :sensitive in frame fpage1 = false
           log-necessita-li            :sensitive in frame fpage1 = false
           l-antidumping               :sensitive in frame fpage1 = false
           it-cod-ini                  :sensitive in frame fpage1 = false
           it-cod-fim                  :sensitive in frame fpage1 = false
           tg-ativo                    :sensitive in frame fpage1 = false
           tg-obso-ordauto             :sensitive in frame fpage1 = false
           tg-obso-todas               :sensitive in frame fpage1 = false
           tg-total-obso               :sensitive in frame fpage1 = false
           tg-depende                  :sensitive in frame fpage1 = false
           tg-independe                :sensitive in frame fpage1 = false
           bt-procurar                 :sensitive in frame fpage1 = false
           br-item-estab               :sensitive in frame fpage1 = false
           br-item-fornec-estab        :sensitive in frame fpage1 = false
           br-item-tab      :sensitive in frame fpage1 = false
           des-deposito-cd0140         :sensitive in frame fpage1 = false
           des-nat-despesa-cd0140      :sensitive in frame fpage1 = false
           des-tip-despesa-cd0140      :sensitive in frame fpage1 = false
           des-unid-negoc-cd0140       :sensitive in frame fpage1 = false
           cb-classif-abc-ce0330       :sensitive in frame fpage1 = false 
           cb-criticidade-ce0330       :sensitive in frame fpage1 = false 
           log-control-qualidade-ce0330:sensitive in frame fpage1 = false
           des-planejador-cd1112       :sensitive in frame fpage1 = false
           c-nome-comprador            :sensitive in frame fpage1 = FALSE
           c-NCM                       :sensitive in frame fpage1 = FALSE
           c-desc-NCM                  :sensitive in frame fpage1 = FALSE
           de-perc-IPI                 :sensitive in frame fpage1 = FALSE
           de-perc-II                  :sensitive in frame fpage1 = FALSE
           c-desc-origem               :sensitive in frame fpage1 = FALSE
           un-cd1112                   :sensitive in frame fpage1 = FALSE
           .

    /*ENABLE or DISABLE CD0140*/
    RUN pi-verifica-permis(INPUT "cd0140").
    ASSIGN cb-cod-obsol-cd0140    :sensitive in frame fpage1 = l-permis-alterar
           cod-unid-negoc-cd0140  :sensitive in frame fpage1 = l-permis-alterar
           cb-classif-abc-ce0330  :sensitive in frame fpage1 = l-permis-alterar.

    APPLY "VALUE-CHANGED" TO it-estab-tipo.

    APPLY 'ENTRY':U TO cod-estab-gestor-cc0120 IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage1
&Scoped-define SELF-NAME cod-comprador-cc0120
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-comprador-cc0120 wWindow
ON F5 OF cod-comprador-cc0120 IN FRAME fpage1 /* Comp */
DO:
    /* ZOOM SMART OBJECT */
    {include/zoomvar.i &prog-zoom=inzoom/z01in055.w
                       &campo=cod-comprador-cc0120
                       &campozoom=cod-comprado
                       &frame=fPage1
                       &campo2=c-nome-comprador
                       &campozoom2=nome
                       &frame2=fPage1}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-comprador-cc0120 wWindow
ON LEAVE OF cod-comprador-cc0120 IN FRAME fpage1 /* Comp */
DO:
    FIND FIRST comprador NO-LOCK
        WHERE  comprador.cod-comprado = INPUT FRAME {&FRAME-NAME} cod-comprador-cc0120 NO-ERROR.
    IF  AVAIL  comprador 
    THEN ASSIGN c-nome-comprador:SCREEN-VALUE IN FRAME {&FRAME-NAME} = comprador.nome.
    ELSE ASSIGN c-nome-comprador:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-comprador-cc0120 wWindow
ON MOUSE-SELECT-DBLCLICK OF cod-comprador-cc0120 IN FRAME fpage1 /* Comp */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-deposito-cd0140
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-deposito-cd0140 wWindow
ON F5 OF cod-deposito-cd0140 IN FRAME fpage1 /* Dep¢sito */
DO:
/* ZOOM SMART OBJECT */
/*     {include/zoomvar.i &prog-zoom=inzoom/z01in084.w   */
/*                        &campo=cod-deposito-cd0140     */
/*                        &campozoom=cod-deposito-cd0140 */
/*                        &frame=fPage1}                 */

    RUN pi-chama-cd0140.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-deposito-cd0140 wWindow
ON LEAVE OF cod-deposito-cd0140 IN FRAME fpage1 /* Dep¢sito */
DO:
    FIND first deposito 
        where deposito.cod-depos = cod-deposito-cd0140:SCREEN-VALUE IN FRAME fpage1 NO-LOCK NO-ERROR.
    if avail deposito then
       assign des-deposito-cd0140:screen-value in frame fPage1 = deposito.nome.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-deposito-cd0140 wWindow
ON MOUSE-SELECT-DBLCLICK OF cod-deposito-cd0140 IN FRAME fpage1 /* Dep¢sito */
DO:
    apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-estab-gestor-cc0120
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-estab-gestor-cc0120 wWindow
ON F5 OF cod-estab-gestor-cc0120 IN FRAME fpage1 /* Estab Gestor */
DO:
/*     /* ZOOM SMART OBJECT */                               */
/*     {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w       */
/*                        &campo=cod-estab-gestor-cc0120     */
/*                        &campozoom=cod-estab-gestor-cc0120 */
/*                        &frame=fPage1}                     */
                        

    IF  gr-item-uni-estab <> ? THEN DO:
        RUN ccp/cc0120.w.
        RUN pi-monta.
        RUN pi-posiciona.
    END.
    ELSE MESSAGE "Selecione um item no browser":U VIEW-AS ALERT-BOX INFO BUTTONS OK.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-estab-gestor-cc0120 wWindow
ON MOUSE-SELECT-DBLCLICK OF cod-estab-gestor-cc0120 IN FRAME fpage1 /* Estab Gestor */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-horiz-fixo-cd1112
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-horiz-fixo-cd1112 wWindow
ON F5 OF cod-horiz-fixo-cd1112 IN FRAME fpage1
DO:
  RUN pi-chama-cd1112.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-horiz-fixo-cd1112 wWindow
ON MOUSE-SELECT-DBLCLICK OF cod-horiz-fixo-cd1112 IN FRAME fpage1
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-per-fixo-cd1112
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-per-fixo-cd1112 wWindow
ON F5 OF cod-per-fixo-cd1112 IN FRAME fpage1 /* Per. Fixo */
DO:
  RUN pi-chama-cd1112.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-per-fixo-cd1112 wWindow
ON MOUSE-SELECT-DBLCLICK OF cod-per-fixo-cd1112 IN FRAME fpage1 /* Per. Fixo */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-planejador-cd1112
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-planejador-cd1112 wWindow
ON F5 OF cod-planejador-cd1112 IN FRAME fpage1 /* Planejador */
DO:
/*   {include/zoomvar.i &prog-zoom="inzoom/z01in321.w"    */
/*                      &campo=cod-planejador-cd1112      */
/*                      &campozoom=cod-planejador-cd1112} */

    RUN pi-chama-cd1112.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-planejador-cd1112 wWindow
ON LEAVE OF cod-planejador-cd1112 IN FRAME fpage1 /* Planejador */
DO:
    FIND FIRST planejad
        where planejad.cd-planejado = cod-planejador-cd1112:SCREEN-VALUE IN FRAME fpage1 no-lock no-error.
    IF AVAIL planejad THEN
        ASSIGN des-planejador-cd1112:screen-value in frame fpage1 = planejad.nome.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-planejador-cd1112 wWindow
ON MOUSE-SELECT-DBLCLICK OF cod-planejador-cd1112 IN FRAME fpage1 /* Planejador */
DO: 
    APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-prioridade-cd1112
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-prioridade-cd1112 wWindow
ON F5 OF cod-prioridade-cd1112 IN FRAME fpage1 /* Prioridade */
DO:
  RUN pi-chama-cd1112.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-prioridade-cd1112 wWindow
ON MOUSE-SELECT-DBLCLICK OF cod-prioridade-cd1112 IN FRAME fpage1 /* Prioridade */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-prioridade-mrp-cd1112
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-prioridade-mrp-cd1112 wWindow
ON F5 OF cod-prioridade-mrp-cd1112 IN FRAME fpage1 /* Priori. MRP */
DO:
  RUN pi-chama-cd1112.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-prioridade-mrp-cd1112 wWindow
ON MOUSE-SELECT-DBLCLICK OF cod-prioridade-mrp-cd1112 IN FRAME fpage1 /* Priori. MRP */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-qtde-politica-cd1112
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-qtde-politica-cd1112 wWindow
ON F5 OF cod-qtde-politica-cd1112 IN FRAME fpage1 /* QP */
DO:
  RUN pi-chama-cd1112.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-qtde-politica-cd1112 wWindow
ON MOUSE-SELECT-DBLCLICK OF cod-qtde-politica-cd1112 IN FRAME fpage1 /* QP */
DO:
    APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-tp-despesa-cd0140
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-tp-despesa-cd0140 wWindow
ON F5 OF cod-tp-despesa-cd0140 IN FRAME fpage1 /* Tipo Despesa */
DO:
/*     /* ZOOM SMART OBJECT */                             */
/*     {include/zoomvar.i &prog-zoom=adzoom/z01ad259.w     */
/*                        &campo=cod-tp-despesa-cd0140     */
/*                        &campozoom=cod-tp-despesa-cd0140 */
/*                        &frame=fPage1}                   */

    RUN pi-chama-cd0140.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-tp-despesa-cd0140 wWindow
ON LEAVE OF cod-tp-despesa-cd0140 IN FRAME fpage1 /* Tipo Despesa */
DO:
    find first tipo-rec-desp 
        where tipo-rec-desp.tp-codigo = int(cod-tp-despesa-cd0140:SCREEN-VALUE IN FRAME fpage1) NO-LOCK no-error. 
    if avail tipo-rec-desp then
       ASSIGN des-tip-despesa-cd0140:screen-value in frame fPage1 = tipo-rec-desp.descricao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-tp-despesa-cd0140 wWindow
ON MOUSE-SELECT-DBLCLICK OF cod-tp-despesa-cd0140 IN FRAME fpage1 /* Tipo Despesa */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-unid-negoc-cd0140
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-unid-negoc-cd0140 wWindow
ON F5 OF cod-unid-negoc-cd0140 IN FRAME fpage1 /* Unid. Negocio */
DO: 
    {method/ZoomFields.i
           &ProgramZoom="inzoom/z01in745.w"
           &FieldZoom1="cod-unid-negoc-cd0140"
           &FieldScreen1="cod-unid-negoc-cd0140"
           &Frame1="fPage1"
           &FieldZoom2="des-unid-negoc-cd0140"
           &FieldScreen2="des-unid-negoc-cd0140"
           &Frame2="fPage1"
           &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-unid-negoc-cd0140 wWindow
ON LEAVE OF cod-unid-negoc-cd0140 IN FRAME fpage1 /* Unid. Negocio */
DO:
  FIND FIRST unid-negoc 
        WHERE unid-negoc.cod-unid-negoc = cod-unid-negoc-cd0140:SCREEN-VALUE IN FRAME fpage1 NO-LOCK NO-ERROR. 
    IF AVAIL unid-negoc THEN
        ASSIGN des-unid-negoc-cd0140:SCREEN-VALUE IN FRAME fpage1 = unid-negoc.des-unid-negoc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-unid-negoc-cd0140 wWindow
ON MOUSE-SELECT-DBLCLICK OF cod-unid-negoc-cd0140 IN FRAME fpage1 /* Unid. Negocio */
DO:
    apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-codigo-orig-cd0140
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-codigo-orig-cd0140 wWindow
ON F5 OF i-codigo-orig-cd0140 IN FRAME fpage1 /* Origem Estab */
DO:
  RUN pi-chama-cd0140.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-codigo-orig-cd0140 wWindow
ON LEAVE OF i-codigo-orig-cd0140 IN FRAME fpage1 /* Origem Estab */
DO:
  ASSIGN i-origem-aux  = INT(i-codigo-orig-cd0140:SCREEN-VALUE IN FRAME fPage1) + 1
         c-desc-origem:SCREEN-VALUE IN FRAME fPage1 = {ininc/i18in122.i 04 i-origem-aux}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-codigo-orig-cd0140 wWindow
ON MOUSE-SELECT-DBLCLICK OF i-codigo-orig-cd0140 IN FRAME fpage1 /* Origem Estab */
DO:
  APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-estab-com
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-estab-com wWindow
ON F5 OF it-estab-com IN FRAME fpage1 /* Ressupr. Com. */
DO:
  RUN pi-chama-cd1112.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-estab-com wWindow
ON MOUSE-SELECT-DBLCLICK OF it-estab-com IN FRAME fpage1 /* Ressupr. Com. */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-estab-cons
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-estab-cons wWindow
ON F5 OF it-estab-cons IN FRAME fpage1 /* Cons Previsto */
DO:
  RUN pi-chama-ce0330.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-estab-cons wWindow
ON MOUSE-SELECT-DBLCLICK OF it-estab-cons IN FRAME fpage1 /* Cons Previsto */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-estab-cons-aad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-estab-cons-aad wWindow
ON F5 OF it-estab-cons-aad IN FRAME fpage1 /* Cons AtÇ a Data */
DO:
  RUN pi-chama-ce0330.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-estab-cons-aad wWindow
ON MOUSE-SELECT-DBLCLICK OF it-estab-cons-aad IN FRAME fpage1 /* Cons AtÇ a Data */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-estab-cq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-estab-cq wWindow
ON F5 OF it-estab-cq IN FRAME fpage1 /* Ressupr. CQ. */
DO:
  RUN pi-chama-cd1112.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-estab-cq wWindow
ON MOUSE-SELECT-DBLCLICK OF it-estab-cq IN FRAME fpage1 /* Ressupr. CQ. */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-estab-horiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-estab-horiz wWindow
ON F5 OF it-estab-horiz IN FRAME fpage1 /* Horizonte Liber / Fixo */
DO:
  RUN pi-chama-cd1112.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-estab-horiz wWindow
ON MOUSE-SELECT-DBLCLICK OF it-estab-horiz IN FRAME fpage1 /* Horizonte Liber / Fixo */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-estab-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-estab-tipo wWindow
ON VALUE-CHANGED OF it-estab-tipo IN FRAME fpage1
DO:
    IF INPUT FRAME {&FRAME-NAME} it-estab-tipo = 1 THEN DO WITH FRAME {&FRAME-NAME}:
        ASSIGN vl-qs-cd1112:SENSITIVE    = YES
               it-estab-ts :SENSITIVE    = NO
               it-estab-ts :SCREEN-VALUE = "0".
    END.
    ELSE DO WITH FRAME {&FRAME-NAME}:
        ASSIGN vl-qs-cd1112:SENSITIVE    = NO
               it-estab-ts :SENSITIVE    = YES
               vl-qs-cd1112:SCREEN-VALUE = "0".
    end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-estab-ts
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-estab-ts wWindow
ON F5 OF it-estab-ts IN FRAME fpage1 /* TS */
DO:
    RUN pi-chama-cd1112.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-estab-ts wWindow
ON MOUSE-SELECT-DBLCLICK OF it-estab-ts IN FRAME fpage1 /* TS */
DO:
    APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME nat-despesa-cd0140
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nat-despesa-cd0140 wWindow
ON F5 OF nat-despesa-cd0140 IN FRAME fpage1 /* Nat. Despesa */
DO:
/*     /* ZOOM SMART OBJECT */                          */
/*     {include/zoomvar.i &prog-zoom=inzoom/z01in246.w  */
/*                        &campo=nat-despesa-cd0140     */
/*                        &campozoom=nat-despesa-cd0140 */
/*                        &frame=fPage1}                */

    RUN pi-chama-cd0140.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nat-despesa-cd0140 wWindow
ON LEAVE OF nat-despesa-cd0140 IN FRAME fpage1 /* Nat. Despesa */
DO: 
   FIND first natureza-despesa 
        where natureza-despesa.nat-despesa = int(nat-despesa-cd0140:SCREEN-VALUE IN FRAME fpage1) NO-LOCK NO-ERROR.
    if avail natureza-despesa then
       assign des-nat-despesa-cd0140:screen-value in frame fPage1 = natureza-despesa.descricao. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nat-despesa-cd0140 wWindow
ON MOUSE-SELECT-DBLCLICK OF nat-despesa-cd0140 IN FRAME fpage1 /* Nat. Despesa */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME un-cd1112
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL un-cd1112 wWindow
ON F5 OF un-cd1112 IN FRAME fpage1 /* Un */
DO:
  RUN pi-chama-cd1112.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL un-cd1112 wWindow
ON MOUSE-SELECT-DBLCLICK OF un-cd1112 IN FRAME fpage1 /* Un */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vl-lote-minimo-cd1112
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vl-lote-minimo-cd1112 wWindow
ON F5 OF vl-lote-minimo-cd1112 IN FRAME fpage1 /* Lote M°nimo */
DO:
  RUN pi-chama-cd1112.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vl-lote-minimo-cd1112 wWindow
ON MOUSE-SELECT-DBLCLICK OF vl-lote-minimo-cd1112 IN FRAME fpage1 /* Lote M°nimo */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vl-lote-multiplo-cd1112
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vl-lote-multiplo-cd1112 wWindow
ON F5 OF vl-lote-multiplo-cd1112 IN FRAME fpage1 /* Lote Multiplo */
DO:
  RUN pi-chama-cd1112.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vl-lote-multiplo-cd1112 wWindow
ON MOUSE-SELECT-DBLCLICK OF vl-lote-multiplo-cd1112 IN FRAME fpage1 /* Lote Multiplo */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vl-qs-cd1112
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vl-qs-cd1112 wWindow
ON F5 OF vl-qs-cd1112 IN FRAME fpage1 /* QS */
DO:
  RUN pi-chama-cd1112.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vl-qs-cd1112 wWindow
ON MOUSE-SELECT-DBLCLICK OF vl-qs-cd1112 IN FRAME fpage1 /* QS */
DO:
    APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vl-ressupr-for-cd1112
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vl-ressupr-for-cd1112 wWindow
ON F5 OF vl-ressupr-for-cd1112 IN FRAME fpage1 /* Ressupr. For */
DO:
  RUN pi-chama-cd1112.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vl-ressupr-for-cd1112 wWindow
ON MOUSE-SELECT-DBLCLICK OF vl-ressupr-for-cd1112 IN FRAME fpage1 /* Ressupr. For */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-erro
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/mainblock.i}

cod-comprador-cc0120:LOAD-MOUSE-POINTER("image/lupa.cur":U)      IN FRAME fpage1.
cod-estab-gestor-cc0120:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fpage1.
cod-deposito-cd0140:LOAD-MOUSE-POINTER("image/lupa.cur":U)       IN FRAME fpage1.
cod-tp-despesa-cd0140:LOAD-MOUSE-POINTER("image/lupa.cur":U)     IN FRAME fpage1.
nat-despesa-cd0140:LOAD-MOUSE-POINTER("image/lupa.cur":U)        IN FRAME fpage1.
i-codigo-orig-cd0140:LOAD-MOUSE-POINTER("image/lupa.cur":U)      IN FRAME fpage1.
cod-planejador-cd1112:LOAD-MOUSE-POINTER("image/lupa.cur":U)     IN FRAME fpage1.
vl-lote-multiplo-cd1112:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fpage1.
cod-per-fixo-cd1112:LOAD-MOUSE-POINTER("image/lupa.cur":U)       IN FRAME fpage1.
vl-lote-minimo-cd1112:LOAD-MOUSE-POINTER("image/lupa.cur":U)     IN FRAME fpage1.
cod-prioridade-cd1112:LOAD-MOUSE-POINTER("image/lupa.cur":U)     IN FRAME fpage1.
it-estab-horiz:LOAD-MOUSE-POINTER("image/lupa.cur":U)            IN FRAME fpage1.
cod-horiz-fixo-cd1112:LOAD-MOUSE-POINTER("image/lupa.cur":U)     IN FRAME fpage1.
cod-prioridade-mrp-cd1112:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage1.
vl-ressupr-for-cd1112:LOAD-MOUSE-POINTER("image/lupa.cur":U)     IN FRAME fpage1.
it-estab-cons:LOAD-MOUSE-POINTER("image/lupa.cur":U)             IN FRAME fpage1.
it-estab-cons-aad:LOAD-MOUSE-POINTER("image/lupa.cur":U)         IN FRAME fpage1.
it-estab-cq:LOAD-MOUSE-POINTER("image/lupa.cur":U)               IN FRAME fpage1.
it-estab-com:LOAD-MOUSE-POINTER("image/lupa.cur":U)              IN FRAME fpage1.
vl-qs-cd1112:LOAD-MOUSE-POINTER("image/lupa.cur":U)              IN FRAME fpage1.
cod-qtde-politica-cd1112:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fpage1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    APPLY "entry" TO it-cod-comprado-ini IN FRAME fpage1.

    ASSIGN cod-estab-sel               :SCREEN-VALUE IN FRAME fpage1 = v_cod_estab_usuar
           it-cod-comprado-ini         :SCREEN-VALUE IN FRAME fpage1 = ""
           it-cod-comprado-fim         :SCREEN-VALUE IN FRAME fpage1 = "ZZZZZZZZZZZZ"
           it-cod-ini                  :SCREEN-VALUE IN FRAME fpage1 = ""
           it-cod-fim                  :SCREEN-VALUE IN FRAME fpage1 = "ZZZZZZZZZZZZZZZZ"
           cb-cod-obsol-cd0140         :sensitive in frame fpage1    = false 
           c-observacao                :sensitive in frame fpage1    = false 
           cb-classif-abc-ce0330       :sensitive in frame fpage1    = false 
           cb-criticidade-ce0330       :sensitive in frame fpage1    = false 
           log-control-qualidade-ce0330:sensitive in frame fpage1    = false 
           cod-comprador-cc0120        :sensitive in frame fpage1    = false 
           cod-estab-gestor-cc0120     :sensitive in frame fpage1    = false 
           cod-deposito-cd0140         :sensitive in frame fpage1    = false 
           cod-unid-negoc-cd0140       :sensitive in frame fpage1    = false 
           cod-prioridade-cd1112       :sensitive in frame fpage1    = false 
           cod-horiz-fixo-cd1112       :sensitive in frame fpage1    = false 
           des-deposito-cd0140         :sensitive in frame fpage1    = false 
           des-nat-despesa-cd0140      :sensitive in frame fpage1    = false 
           des-tip-despesa-cd0140      :sensitive in frame fpage1    = false 
           des-unid-negoc-cd0140       :sensitive in frame fpage1    = false 
           nat-despesa-cd0140          :sensitive in frame fpage1    = false 
           cod-tp-despesa-cd0140       :sensitive in frame fpage1    = false 
           cb-classe-reprog-cd1112     :sensitive in frame fpage1    = false  
           cb-divisao-ordens-cd1112    :sensitive in frame fpage1    = false 
           cb-emis-ordens-cd1112       :sensitive in frame fpage1    = false 
           cb-politica-cd1112          :sensitive in frame fpage1    = false 
           cb-tp-demanda-cd1112        :sensitive in frame fpage1    = false 
           cod-per-fixo-cd1112         :sensitive in frame fpage1    = false 
           cod-planejador-cd1112       :sensitive in frame fpage1    = false  
           cod-prioridade-mrp-cd1112   :sensitive in frame fpage1    = false 
           un-cd1112                   :sensitive in frame fpage1    = false 
           cod-qtde-politica-cd1112    :sensitive in frame fpage1    = false 
           vl-lote-minimo-cd1112       :sensitive in frame fpage1    = false 
           vl-lote-multiplo-cd1112     :sensitive in frame fpage1    = false 
           vl-qs-cd1112                :sensitive in frame fpage1    = false 
           vl-ressupr-for-cd1112       :sensitive in frame fpage1    = false 
           it-estab-com                :sensitive in frame fpage1    = false 
           it-estab-cq                 :sensitive in frame fpage1    = false 
           it-estab-tipo               :sensitive in frame fpage1    = false 
           it-estab-ts                 :sensitive in frame fpage1    = false 
           it-estab-cons               :sensitive in frame fpage1    = false 
           it-estab-cons-aad           :sensitive in frame fpage1    = false 
           it-estab-horiz              :sensitive in frame fpage1    = false 
           cb-reabastace-cd1112        :sensitive in frame fpage1    = false 
           log-repres-demanda-cd1112   :sensitive in frame fpage1    = false 
           des-planejador-cd1112       :sensitive in frame fpage1    = false 
           btcancel                    :sensitive in frame fpage0    = FALSE
           btsave                      :sensitive in frame fpage0    = FALSE
           btupdate                    :sensitive in frame fpage0    = FALSE
           c-nome-comprador            :sensitive in frame fpage1    = FALSE
           c-NCM                       :sensitive in frame fpage1    = FALSE
           c-desc-NCM                  :sensitive in frame fpage1    = FALSE
           de-perc-IPI                 :sensitive in frame fpage1    = FALSE
           de-perc-II                  :sensitive in frame fpage1    = FALSE
           c-desc-origem               :sensitive in frame fpage1    = FALSE
           btCC0313                    :sensitive in frame fpage1    = FALSE
           btCC0531                    :sensitive in frame fpage1    = FALSE
           .
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualiza wWindow 
PROCEDURE atualiza :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DO  WITH FRAME fpage1:
        IF  AVAIL tt-item-uni-estab-aux THEN DO:
            RUN pi-dados-campos.
        END. /* IF  AVAIL tt-item-uni-estab-aux THEN DO: */

        RUN pi-monta.
    END. /* DO  WITH FRAME fpage1: */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualiza-erro wWindow 
PROCEDURE atualiza-erro :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    {&OPEN-QUERY-Br-erro}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualiza-for wWindow 
PROCEDURE atualiza-for :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE d-perc-tot AS DECIMAL     NO-UNDO.
    
EMPTY TEMP-TABLE tt-item-fornec-estab NO-ERROR.
EMPTY TEMP-TABLE tt-erro NO-ERROR.

FOR EACH  item-fornec-estab NO-LOCK
    WHERE item-fornec-estab.it-codigo   = tt-item-uni-estab-aux.it-codigo                                     
    AND   item-fornec-estab.cod-estabel = tt-item-uni-estab-aux.cod-estabel,
    FIRST emitente NO-LOCK
    WHERE emitente.cod-emitente = item-fornec-estab.cod-emitente
    ,EACH int-item-for-PN NO-LOCK
        WHERE int-item-for-PN.it-codigo    = item-fornec-estab.it-codigo 
          AND int-item-for-PN.cod-emitente = item-fornec-estab.cod-emitente:    
        
    CREATE tt-item-fornec-estab.
    ASSIGN tt-item-fornec-estab.cod-estabel         = item-fornec-estab.cod-estabel
           tt-item-fornec-estab.for-it-codigo       = tt-item-uni-estab-aux.it-codigo
           tt-item-fornec-estab.cod-emitente        = item-fornec-estab.cod-emitente
           tt-item-fornec-estab.nome-abrev          = emitente.nome-abrev
           tt-item-fornec-estab.fabricante          = INT(int-item-for-PN.item-do-forn)
           tt-item-fornec-estab.horizonte-fixo      = item-fornec-estab.horiz-fixo
           tt-item-fornec-estab.tempo-ressup        = item-fornec-estab.tempo-ressup
           tt-item-fornec-estab.cot-aut             = item-fornec-estab.cot-aut
           tt-item-fornec-estab.ativo               = item-fornec-estab.ativo
           tt-item-fornec-estab.i-cod-cond-pag      = item-fornec-estab.cod-cond-pag
           tt-item-fornec-estab.e-cod-cond-pag      = emitente.cod-cond-pag
           tt-item-fornec-estab.unid-medida         = item-fornec-estab.unid-med-for
           tt-item-fornec-estab.fat-conv            = item-fornec-estab.fator-conver
           tt-item-fornec-estab.casa-dec            = item-fornec-estab.num-casa-dec
           tt-item-fornec-estab.lote-mul-for        = item-fornec-estab.lote-mul-for
           tt-item-fornec-estab.lote-min-for        = item-fornec-estab.lote-minimo
           tt-item-fornec-estab.perc-compra         = item-fornec-estab.perc-compra
           tt-item-fornec-estab.classe-repro        = item-fornec-estab.classe-repro
           tt-item-fornec-estab.unid-med-for        = item-fornec-estab.unid-med-for
           tt-item-fornec-estab.r-item-uni-estab    = tt-item-uni-estab-aux.r-rowid
           tt-item-fornec-estab.r-item-fornec-estab = ROWID(item-fornec-estab).

    IF SUBSTRING(item-fornec-estab.char-1,1,1) <> "" THEN DO:
        FIND FIRST moeda NO-LOCK
             WHERE moeda.mo-codigo = INT(SUBSTRING(item-fornec-estab.char-1,1,1)) NO-ERROR.
                        
        IF AVAIL moeda THEN
            ASSIGN tt-item-fornec-estab.moeda-des = moeda.descricao.
    END.
    /*
    FIND FIRST tb-pr-cc NO-LOCK
        WHERE  tb-pr-cc.nome-abrev   = emitente.nome-abrev      
        AND    tb-pr-cc.dt-inicio   <= TODAY                    
        AND    tb-pr-cc.dt-termino  >= TODAY                    
        AND    tb-pr-cc.situacao     = 1 /* Ativa */                       
        AND    tb-pr-cc.cod-cond-pag = item-fornec-estab.cod-cond-pag 
        AND    tb-pr-cc.mo-codigo    = INT(SUBSTRING(item-fornec-estab.char-1,1,1)) 
        AND    tb-pr-cc.cod-estabel  = INPUT FRAME fpage1 cod-estab-sel NO-ERROR.   

    IF NOT AVAIL tb-pr-cc THEN
    FIND FIRST tb-pr-cc NO-LOCK
        WHERE  tb-pr-cc.nome-abrev   = emitente.nome-abrev      
        AND    tb-pr-cc.dt-inicio   <= TODAY                    
        AND    tb-pr-cc.dt-termino  >= TODAY                    
        AND    tb-pr-cc.situacao     = 1 /* Ativa */                       
        AND    tb-pr-cc.cod-cond-pag = item-fornec-estab.cod-cond-pag 
        AND    tb-pr-cc.mo-codigo    = INT(SUBSTRING(item-fornec-estab.char-1,1,1)) NO-ERROR.  
    IF  AVAIL  tb-pr-cc THEN DO:*/
    FOR EACH  tb-pr-cc NO-LOCK
        WHERE tb-pr-cc.nome-abrev   = emitente.nome-abrev      
          AND tb-pr-cc.dt-inicio   <= TODAY                    
          AND tb-pr-cc.dt-termino  >= TODAY                    
          AND tb-pr-cc.situacao     = 1 /* Ativa */                       
          AND tb-pr-cc.cod-cond-pag = item-fornec-estab.cod-cond-pag 
          AND tb-pr-cc.mo-codigo    = INT(SUBSTRING(item-fornec-estab.char-1,1,1)) .        

        FOR EACH item-tab NO-LOCK 
           WHERE item-tab.it-codigo    = item-fornec-estab.it-codigo
             AND item-tab.cod-emitente = tb-pr-cc.cod-emitente
             AND item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag
             AND item-tab.nr-tab       = tb-pr-cc.nr-tab
             AND item-tab.dt-inicio    = tb-pr-cc.dt-inicio
             AND item-tab.cod-estabe   = tb-pr-cc.cod-estabel:            

            IF  NOT CAN-FIND(FIRST tt-item-tab
                             WHERE tt-item-tab.cod-emitente   = item-tab.cod-emitente
                               AND tt-item-tab.des-referencia = item-tab.des-referencia
                               AND tt-item-tab.t-cod-cond-pag = item-tab.cod-cond-pag
                               AND tt-item-tab.nr-tab         = item-tab.nr-tab
                               AND tt-item-tab.dt-inic        = item-tab.dt-inicio
                               AND tt-item-tab.it-codigo      = item-tab.it-codigo
                               AND tt-item-tab.qty-min        = item-tab.quant-min) THEN DO:
                
                CREATE tt-item-tab.
                ASSIGN tt-item-tab.cod-emitente        = item-tab.cod-emitente  
                       tt-item-tab.des-referencia      = item-tab.des-referencia
                       tt-item-tab.t-cod-cond-pag      = item-tab.cod-cond-pag  
                       tt-item-tab.nr-tab              = item-tab.nr-tab        
                       tt-item-tab.dt-inic             = item-tab.dt-inicio     
                       tt-item-tab.it-codigo           = item-tab.it-codigo     
                       tt-item-tab.qty-min             = item-tab.quant-min
                       tt-item-tab.dt-term             = IF AVAIL tb-pr-cc THEN tb-pr-cc.dt-termino   ELSE ?
                       tt-item-tab.moeda               = item-tab.mo-codigo
                       tt-item-tab.taxa-fin            = IF AVAIL tb-pr-cc THEN tb-pr-cc.valor-taxa   ELSE 0
                       tt-item-tab.dias-taxa           = IF AVAIL tb-pr-cc THEN tb-pr-cc.nr-dias-taxa ELSE 0
                       tt-item-tab.perc-icms           = item-tab.aliquota-icm
                       tt-item-tab.perc-ipi            = item-tab.aliquota-ipi
                       tt-item-tab.preco               = item-tab.pr-item
                       tt-item-tab.r-item-uni-estab    = tt-item-uni-estab-aux.r-rowid
                       tt-item-tab.r-item-tab          = ROWID(item-tab)
                       tt-item-tab.r-item-fornec-estab = ROWID(item-fornec-estab).
            END.
        END.
    END.
    
    IF  AVAIL tt-item-uni-estab-aux THEN DO:
        IF  INPUT FRAME fPage1 cod-horiz-fixo-cd1112 = 0 THEN DO:
    
            IF  NOT CAN-FIND(FIRST tt-erro 
                             WHERE tt-erro.nro-erro = 11) THEN DO:
                CREATE tt-erro.
                ASSIGN tt-erro.nro-erro  = 11
                       tt-erro.prob-erro = "Sem HF no CD1112"
                       tt-erro.solu-erro = "Informar Horizonte Fixo no CD1112".
            END. 
        END. 

        IF  tt-item-uni-estab-aux.tipo-est-seg <> 1 THEN DO:
            IF  NOT CAN-FIND(FIRST tt-erro 
                             WHERE tt-erro.nro-erro = 1) THEN DO:
                CREATE tt-erro.
                ASSIGN tt-erro.nro-erro  = 1
                       tt-erro.prob-erro = "Estoque Seguranáa <> Quantidade"
                       tt-erro.solu-erro = 'Ajustar opá∆o Estoque de Seguranáa para "Quantidade" no CD1112.'.
            END. /* IF NOT CAN-FIND(FIRST tt-erro ... */
        END. /* IF  tt-item-uni-estab-aux.tipo-est-seg <> 1 */

        IF  substring(tt-item-uni-estab-aux.char-1,10,1) <> "1" THEN DO:
            IF  NOT CAN-FIND(FIRST tt-erro 
                             WHERE tt-erro.nro-erro = 2) THEN DO:
                CREATE tt-erro.
                ASSIGN tt-erro.nro-erro  = 2
                       tt-erro.prob-erro = "Reabastecimento <> Demanda"
                       tt-erro.solu-erro = 'Ajustar opá∆o de Reabastecimento para "Demanda" no CD1112.'.
            END. /* IF  NOT CAN-FIND(FIRST tt-erro ... */
        END. /* IF  substring(tt-item-uni-estab-aux.char-1,10,1) <> "1" */

        IF  substring(tt-item-uni-estab-aux.char-1,132,1) <> "1" THEN DO:
            IF  NOT CAN-FIND(FIRST tt-erro 
                             WHERE tt-erro.nro-erro = 3) THEN DO:
                CREATE tt-erro.
                ASSIGN tt-erro.nro-erro  = 3
                       tt-erro.prob-erro = "Habilitar Repressa Demanda"
                       tt-erro.solu-erro = 'Marcar a opá∆o "Represa Demanda" no CD1112.':U.
            END. /* IF  NOT CAN-FIND(FIRST tt-erro ... */
        END. /* IF  substring(tt-item-uni-estab-aux.char-1,132,1) <> "1" */
    END. /* IF  AVAIL tt-item-uni-estab-aux */

    IF  tt-item-fornec-estab.classe-repro <> 4 
    AND tt-item-fornec-estab.perc-compra  <> 0 
    AND tt-item-fornec-estab.ativo THEN DO:
        IF  NOT CAN-FIND(FIRST tt-erro 
                             WHERE tt-erro.nro-erro = 4) THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.nro-erro  = 4
                   tt-erro.prob-erro = "Item <> N∆o Reprograma"
                   tt-erro.solu-erro = 'Marcar opá∆o "N∆o Reprograma" no CC0531 e no CD1112.'.
        END. /* IF  NOT CAN-FIND(FIRST tt-erro ... */
    END. /* IF  tt-item-fornec-estab.classe-repro <> 4 AND ... */
    
    IF  AVAIL tt-item-tab THEN DO:
        IF  tt-item-fornec-estab.i-cod-cond-pag <> tt-item-tab.t-cod-cond-pag 
        AND tt-item-fornec-estab.ativo THEN DO:
            IF  NOT CAN-FIND(FIRST tt-erro 
                             WHERE tt-erro.nro-erro = 5) THEN DO:
                CREATE tt-erro.
                ASSIGN tt-erro.nro-erro  = 5
                       tt-erro.prob-erro = "CPI <> CPT"
                       tt-erro.solu-erro = "Divergància de Cond. de Pagto entre CC0531 e Tabela de Preáo vigente CC0312." .
            END. /* IF  NOT CAN-FIND(FIRST tt-erro ... */
        END. /* IF  tt-item-fornec-estab.i-cod-cond-pag <> ... */
    END.

    IF NOT CAN-FIND (FIRST tt-item-tab
                     WHERE tt-item-tab.cod-emitente = tt-item-fornec-estab.cod-emitente)  THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.nro-erro  = 19
               tt-erro.prob-erro = "Item sem tabela de preáo."
               tt-erro.solu-erro = "Item sem tabela de preáo para fornecedor ativo." .
    END.
 
    IF  tt-item-fornec-estab.cot-aut     = NO
    AND tt-item-fornec-estab.perc-compra > 0
    AND tt-item-fornec-estab.ativo       = YES THEN DO:

        IF  NOT CAN-FIND(FIRST tt-erro 
                         WHERE tt-erro.nro-erro = 6) THEN DO:

            CREATE tt-erro.
            ASSIGN tt-erro.nro-erro  = 6
                   tt-erro.prob-erro = "Item sem cotaá∆o autom†tica"
                   tt-erro.solu-erro = 'Marcar opá∆o "Cotaá∆o Autom†tica" no CC0531.'.
        END. /* IF  NOT CAN-FIND(FIRST tt-erro ... */
    END. /* IF  tt-item-fornec-estab.cot-aut = NO AND ... */

    IF  tt-item-fornec-estab.ativo = YES THEN DO:
        ASSIGN d-perc-tot = d-perc-tot + tt-item-fornec-estab.perc-compr.
    END. /* IF  tt-item-fornec-estab.ativo = YES ... */

    IF  tt-item-fornec-estab.ativo       = NO 
    AND tt-item-fornec-estab.perc-compra > 0 THEN DO:
        IF  NOT CAN-FIND(FIRST tt-erro 
                             WHERE tt-erro.nro-erro = 7) THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.nro-erro  = 7
                   tt-erro.prob-erro = "Fornecedor com % n∆o est† ativo"
                   tt-erro.solu-erro = "Marcar no CC0531 se ativo o Fornecedor com % informado." .
        END. /* IF  NOT CAN-FIND(FIRST tt-erro ... */
    END. /* IF  tt-item-fornec-estab.ativo = NO AND ... */

    IF  tt-item-fornec-estab.horizonte-fixo = 0
    AND tt-item-fornec-estab.ativo THEN DO:

        IF  NOT CAN-FIND(FIRST tt-erro 
                         WHERE tt-erro.nro-erro = 8) THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.nro-erro  = 8
                   tt-erro.prob-erro = "Sem HF no CC0531"
                   tt-erro.solu-erro = "Informar Horizonte Fixo no CC0531 para Fornecedor Ativo".
        END. /* IF  NOT CAN-FIND(FIRST tt-erro ... */
    END. /* IF  tt-item-fornec-estab.horizonte-fixo = 0 */

    IF  tt-item-fornec-estab.tempo-ressup = 0 
    AND tt-item-fornec-estab.ativo THEN DO:

        IF  NOT CAN-FIND(FIRST tt-erro 
                         WHERE tt-erro.nro-erro = 9) THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.nro-erro  = 9
                   tt-erro.prob-erro = "Sem TR no CC0531"
                   tt-erro.solu-erro = "Informar Tempo Ressuprimento no CC0531".
        END. /* IF  NOT CAN-FIND(FIRST tt-erro ... */
    END. /* IF  tt-item-fornec-estab.tempo-ressup = 0 ... */

    ASSIGN tb-pr-cc-cod-cond-pag = 0
           tb-pr-cc-nr-tab       = "".


    IF  tt-item-fornec-estab.ativo 
    AND (tt-item-fornec-estab.horizonte-fixo <> INPUT FRAME fPage1 cod-horiz-fixo-cd1112) THEN DO:
        IF  NOT CAN-FIND(FIRST tt-erro 
                         WHERE tt-erro.nro-erro = 12) THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.nro-erro  = 12
                   tt-erro.prob-erro = "HFs diferem"
                   tt-erro.solu-erro = "Informar os campos de Horizonte Fixo iguais".
        END. /* IF  NOT CAN-FIND(FIRST tt-erro ... */
    END. /* IF  tt-item-fornec-estab.horizonte-fixo <> cod-horiz-fixo-cd1112 ... */

    IF  tt-item-fornec-estab.ativo 
    AND (tt-item-fornec-estab.tempo-ressup <> INPUT FRAME fPage1 vl-ressupr-for-cd1112) THEN DO:
        IF  NOT CAN-FIND(FIRST tt-erro 
                         WHERE tt-erro.nro-erro = 13) THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.nro-erro  = 13
                   tt-erro.prob-erro = "RFs diferem"
                   tt-erro.solu-erro = "Informar os campos de Ressuprimento iguais".
        END. /* IF  NOT CAN-FIND(FIRST tt-erro ... */
    END. /* IF  tt-item-fornec-estab.horizonte-fixo <> cod-horiz-fixo-cd1112 ... */

    IF  INPUT FRAME fPage1 it-estab-horiz = 0 THEN DO:
        IF  NOT CAN-FIND(FIRST tt-erro 
                             WHERE tt-erro.nro-erro = 14) THEN DO:
                CREATE tt-erro.
                ASSIGN tt-erro.nro-erro  = 14
                       tt-erro.prob-erro = "Sem HL no CD1112"
                       tt-erro.solu-erro = "Informar Horizonte de Liberaá∆o no CD1112".
        END. /* IF  NOT CAN-FIND(FIRST tt-erro ... */    
    END. /* IF  INPUT FRAME fPage1 it-estab-horiz = 0 ... */

    IF  INPUT FRAME fPage1 vl-ressupr-for-cd1112 = 0 THEN DO:
        IF  NOT CAN-FIND(FIRST tt-erro 
                             WHERE tt-erro.nro-erro = 15) THEN DO:
                CREATE tt-erro.
                ASSIGN tt-erro.nro-erro  = 15
                       tt-erro.prob-erro = "Sem RF no CD1112"
                       tt-erro.solu-erro = "Informar Ressuprimento de Fornecedor no CD1112".
        END. /* IF  NOT CAN-FIND(FIRST tt-erro ... */    
    END. /* IF  INPUT FRAME fPage1 vl-ressupr-for-cd1112 = 0 ... */

    IF  tt-item-fornec-estab.ativo 
    AND NOT ((INPUT FRAME fPage1 it-estab-horiz        = INPUT FRAME fPage1 cod-horiz-fixo-cd1112) 
         AND (INPUT FRAME fPage1 cod-horiz-fixo-cd1112 = INPUT FRAME fPage1 vl-ressupr-for-cd1112) 
         AND (INPUT FRAME fPage1 vl-ressupr-for-cd1112 = tt-item-fornec-estab.horizonte-fixo) 
         AND (tt-item-fornec-estab.horizonte-fixo      = tt-item-fornec-estab.tempo-ressup)) THEN DO:
        IF  NOT CAN-FIND(FIRST tt-erro 
                         WHERE tt-erro.nro-erro = 16) THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.nro-erro  = 16
                   tt-erro.prob-erro = "Lead Time do Fornecedor divergente"
                   tt-erro.solu-erro = "Os campos CD1112 (horizonte Liber/Fixo e Ressup Fornec) e CC0531 (Horizonte Fixo e Tempo Ressup) devem estar iguais".
        END. /* IF  NOT CAN-FIND(FIRST tt-erro ... */    
    END.

    /*valida lotes minimos e multiplos item-uni-estab e item-fornec-estab*/
    IF  AVAIL tt-item-fornec-estab
    AND tt-item-fornec-estab.ativo 
    AND INPUT FRAME fPage1 vl-lote-multiplo-cd1112 <> tt-item-fornec-estab.lote-mul-for THEN DO:
        
        ASSIGN INPUT FRAME fPage1 vl-lote-multiplo-cd1112.

        IF ITEM.un <> tt-item-fornec-estab.unid-med-for THEN DO:
        
            {cdp/cd9950.i item.un
                          tt-item-fornec-estab.unid-med-for
                          tt-item-fornec-estab.cod-emitente}
    

            ASSIGN de-indice = 1 WHEN (de-indice = 0 OR de-indice = ?). 
            
            IF INPUT FRAME fPage1 vl-lote-multiplo-cd1112 <> ROUND((tt-item-fornec-estab.lote-mul-for / de-indice),2) THEN DO:
                CREATE tt-erro.
                ASSIGN tt-erro.nro-erro  = 17
                       tt-erro.prob-erro = "Lote multiplo do Fornecedor divergente"
                       tt-erro.solu-erro = "Os campos CD1112 (Lote Multiplo) e CC0531 (Lote Multiplo) devem estar iguais, considerando as unidades de medida de cada um.".
            END.
        END.
        ELSE DO:
            IF INPUT FRAME fPage1 vl-lote-multiplo-cd1112 <> tt-item-fornec-estab.lote-mul-for THEN DO:
                CREATE tt-erro.
                ASSIGN tt-erro.nro-erro  = 18
                       tt-erro.prob-erro = "Lote multiplo do Fornecedor divergente"
                       tt-erro.solu-erro = "Os campos CD1112 (Lote Multiplo) e CC0531 (Lote Multiplo) devem estar iguais, considerando as unidades de medida de cada um.".
            END.
        END.
    END.

    IF  AVAIL tt-item-fornec-estab
    AND ITEM.un <> tt-item-fornec-estab.unid-med-for THEN DO:
        
        {cdp/cd9950.i item.un
                      tt-item-fornec-estab.unid-med-for
                      tt-item-fornec-estab.cod-emitente}
            
        ASSIGN de-indice = 1 WHEN (de-indice = 0 OR de-indice = ?). 
        IF INPUT FRAME fPage1 vl-lote-minimo-cd1112 <> ROUND((tt-item-fornec-estab.lote-min-for / de-indice),2) THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.nro-erro  = 17
                   tt-erro.prob-erro = "Lote m°nimo do Fornecedor divergente"
                   tt-erro.solu-erro = "Os campos CD1112 (Lote M°nimo) e CC0531 (Lote M°nimo) devem estar iguais, considerando as unidades de medida de cada um.".
        END.
    END.
    ELSE DO:
        IF  AVAIL tt-item-fornec-estab
        AND INPUT FRAME fPage1 vl-lote-minimo-cd1112 <> tt-item-fornec-estab.lote-min-for THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.nro-erro  = 17
                   tt-erro.prob-erro = "Lote m°nimo do Fornecedor divergente"
                   tt-erro.solu-erro = "Os campos CD1112 (Lote M°nimo) e CC0531 (Lote M°nimo) devem estar iguais, considerando as unidades de medida de cada um.".
        END.
    END.
    
END. /* FOR EACH item-fornec-estab NO-LOCK */

IF CAN-FIND (FIRST item-fornec-estab NO-LOCK
             WHERE item-fornec-estab.it-codigo   = tt-item-uni-estab-aux.it-codigo                                     
             AND   item-fornec-estab.cod-estabel = tt-item-uni-estab-aux.cod-estabel) THEN DO:
            
    IF  d-perc-tot <> 100 THEN DO:
        IF  NOT CAN-FIND(FIRST tt-erro 
                         WHERE tt-erro.nro-erro = 10) THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.nro-erro  = 10
                   tt-erro.prob-erro = "Fornecedor ativo esta sem 100%"
                   tt-erro.solu-erro = "Informar valor de % no CC0531 para Fornecedor Ativo." .
        END. /* IF  NOT CAN-FIND(FIRST tt-erro ... */
    END. /* IF  d-perc-tot <> 100 THEN DO: */
END.

{&OPEN-QUERY-Br-item-fornec-estab}
{&OPEN-QUERY-br-item-tab}


IF NOT CAN-FIND(FIRST tt-item-fornec-estab) 
THEN ASSIGN btCC0531:SENSITIVE IN FRAME fPage1 = TRUE.
ELSE ASSIGN btCC0531:SENSITIVE IN FRAME fPage1 = FALSE.

IF NOT CAN-FIND(FIRST tt-item-tab) 
THEN ASSIGN btCC0313:SENSITIVE IN FRAME fPage1 = TRUE.
ELSE ASSIGN btCC0313:SENSITIVE IN FRAME fPage1 = FALSE.

     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao001 = {ininc/i06in122.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN  cb-classe-reprog-cd1112:list-item-pairs in frame fPage1 = cAuxTraducao001.
    &else
        ASSIGN cb-classe-reprog-cd1112:list-items in frame fPage1 = {ininc/i06in122.i 03}.
    &endif
   

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao002 = {ininc/i17in172.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao002).
        ASSIGN  cb-cod-obsol-cd0140:list-item-pairs in frame fPage1 = cAuxTraducao002.
    &else
        ASSIGN cb-cod-obsol-cd0140:list-items in frame fPage1 = {ininc/i17in172.i 03}.
    &endif
    
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao003 = {ininc/i26in172.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao003).
        ASSIGN  cb-reabastace-cd1112:list-item-pairs in frame fPage1 = cAuxTraducao003.
    &else
        ASSIGN cb-reabastace-cd1112:list-items in frame fPage1 = {ininc/i26in172.i 03}.
    &endif
    
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao004 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao004 = {ininc/i12in122.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao004).
        ASSIGN  cb-divisao-ordens-cd1112:list-item-pairs in frame fPage1 = cAuxTraducao004.
    &else
        ASSIGN cb-divisao-ordens-cd1112:list-items in frame fPage1 = {ininc/i12in122.i 03}.
    &endif
    
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao005 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao005 = {ininc/i03in122.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao005).
        ASSIGN  cb-emis-ordens-cd1112:list-item-pairs in frame fPage1 = cAuxTraducao005.
    &else
        ASSIGN cb-emis-ordens-cd1112:list-items in frame fPage1 = {ininc/i03in122.i 03}.
    &endif
    
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao006 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao006 = {ininc/i04in122.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao006).
        ASSIGN  cb-politica-cd1112:list-item-pairs in frame fPage1 = cAuxTraducao006.
    &else
        ASSIGN cb-politica-cd1112:list-items in frame fPage1 = {ininc/i04in122.i 03}.
    &endif
    
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao007 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao007 = {ininc/i02in122.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao007).
        ASSIGN  cb-tp-demanda-cd1112:LIST-ITEM-PAIRS in frame fPage1 = cAuxTraducao007.
    &else
        ASSIGN cb-tp-demanda-cd1112:list-items in frame fPage1 = {ininc/i02in122.i 03}.
    &endif                                                                       
    
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao008 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao008 = {ininc/i03in172.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao008).
        ASSIGN  cb-classif-abc-ce0330:LIST-ITEM-PAIRS in frame fPage1 = cAuxTraducao008.
    &else
        ASSIGN cb-classif-abc-ce0330:list-items in frame fPage1 = {ininc/i03in172.i 03}.
    &endif    
    
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao009 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao009 = {ininc/i23in172.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao009).
        ASSIGN  cb-criticidade-ce0330:LIST-ITEM-PAIRS in frame fPage1 = cAuxTraducao009.
    &else
        ASSIGN cb-criticidade-ce0330:list-items in frame fPage1 = {ininc/i23in172.i 03}.
    &endif 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-chama-cd0140 wWindow 
PROCEDURE pi-chama-cd0140 :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    IF  gr-item-uni-estab <> ? THEN DO:
        run cdp/cd0140.w persistent set hProg.
        run dispatch in hProg ("initialize").
        wait-for "close" of hProg.

        APPLY "CHOOSE":U TO bt-procurar IN FRAME fPage1.

/*         RUN pi-monta.                                            */
/*                                                                  */
/*         br-item-estab:REFRESH()        IN FRAME fpage1 NO-ERROR. */
/*         br-item-fornec-estab:REFRESH() IN FRAME fpage1 NO-ERROR. */
/*         br-item-tab:REFRESH()          IN FRAME fPage1 NO-ERROR. */
/*                                                                  */
/*         RUN pi-posiciona.                                        */
    END. /* IF  gr-item-uni-estab <> ? THEN DO: */
    ELSE MESSAGE "Item n∆o tem relacionamento com Estabelecimento: " v_cod_estab_usuar VIEW-AS ALERT-BOX INFO BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-chama-cd1112 wWindow 
PROCEDURE pi-chama-cd1112 :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    IF  gr-item-uni-estab <> ? THEN DO:
        RUN cdp/cd1112.w.

        APPLY "CHOOSE":U TO bt-procurar IN FRAME fPage1.

/*         RUN pi-monta.                                            */
/*                                                                  */
/*         br-item-estab:REFRESH() IN FRAME fpage1 NO-ERROR.        */
/*         br-item-fornec-estab:REFRESH() IN FRAME fpage1 NO-ERROR. */
/*         br-item-tab:REFRESH() IN FRAME fPage1 NO-ERROR.          */
/*                                                                  */
/*         RUN pi-posiciona.                                        */
    END. /* IF  gr-item-uni-estab <> ? THEN DO: */
    ELSE MESSAGE "Item n∆o tem relacionamento com Estabelecimento: " v_cod_estab_usuar VIEW-AS ALERT-BOX INFO BUTTONS OK.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-chama-ce0330 wWindow 
PROCEDURE pi-chama-ce0330 :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    IF  gr-item-uni-estab <> ? THEN DO:
        RUN cep/ce0330.w.

        APPLY "CHOOSE":U TO bt-procurar IN FRAME fPage1.

    END. /* IF  gr-item-uni-estab <> ? THEN DO: */
    ELSE MESSAGE "Item n∆o tem relacionamento com Estabelecimento: " v_cod_estab_usuar VIEW-AS ALERT-BOX INFO BUTTONS OK.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-dados-campos wWindow 
PROCEDURE pi-dados-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*FIND FIRST item-uni-estab 
             WHERE item-uni-estab.it-codigo = item.it-codigo NO-LOCK NO-ERROR.*/
        IF AVAIL tt-item-uni-estab-aux THEN DO:

            ASSIGN cb-classif-abc-ce0330:SCREEN-VALUE IN FRAME fpage1     = {ininc/i03in172.i 04 tt-item-uni-estab-aux.classif-abc}
                   cb-criticidade-ce0330:SCREEN-VALUE IN FRAME fpage1     = {ininc/i06in095.i 04 tt-item-uni-estab-aux.criticidade}
                   log-control-qualidade-ce0330:CHECKED IN FRAME fpage1   = tt-item-uni-estab-aux.contr-qualid
                   cod-comprador-cc0120:SCREEN-VALUE IN FRAME fpage1      = STRING(tt-item-uni-estab-aux.cod-comprado)
                   cod-estab-gestor-cc0120:SCREEN-VALUE IN FRAME fpage1   = STRING(tt-item-uni-estab-aux.cod-estab-gestor)
                   cod-deposito-cd0140:SCREEN-VALUE IN FRAME fpage1       = STRING(tt-item-uni-estab-aux.deposito-pad)
                   cod-unid-negoc-cd0140:SCREEN-VALUE IN FRAME fpage1     = STRING(tt-item-uni-estab-aux.cod-unid-negoc)
                   nat-despesa-cd0140:SCREEN-VALUE IN FRAME fpage1        = STRING(tt-item-uni-estab-aux.nat-despesa)
                   cod-tp-despesa-cd0140:SCREEN-VALUE IN FRAME fpage1     = STRING(tt-item-uni-estab-aux.tp-desp-padrao)
                   
                   cod-per-fixo-cd1112:SCREEN-VALUE IN FRAME fpage1       = STRING(tt-item-uni-estab-aux.periodo-fixo)
                   cod-planejador-cd1112:SCREEN-VALUE IN FRAME fpage1     = STRING(tt-item-uni-estab-aux.cd-planejado) 
                   cod-prioridade-mrp-cd1112:SCREEN-VALUE IN FRAME fpage1 = STRING(tt-item-uni-estab-aux.int-1)
                   cod-prioridade-cd1112:SCREEN-VALUE IN FRAME fpage1     = STRING(tt-item-uni-estab-aux.prioridade)
                   vl-lote-minimo-cd1112:SCREEN-VALUE IN FRAME fpage1     = STRING(tt-item-uni-estab-aux.lote-minimo) 
                   vl-lote-multiplo-cd1112:SCREEN-VALUE IN FRAME fpage1   = STRING(tt-item-uni-estab-aux.lote-multipl)
                   vl-qs-cd1112:SCREEN-VALUE IN FRAME fpage1              = STRING(tt-item-uni-estab-aux.quant-segur)
                   vl-ressupr-for-cd1112:SCREEN-VALUE IN FRAME fpage1     = STRING(tt-item-uni-estab-aux.res-for-comp)
                   it-estab-com:SCREEN-VALUE IN FRAME fpage1              = STRING(tt-item-uni-estab-aux.res-int-comp)
                   it-estab-cq:SCREEN-VALUE IN FRAME fpage1               = STRING(tt-item-uni-estab-aux.res-cq-comp)
                   it-estab-tipo:SCREEN-VALUE IN FRAME fpage1             = STRING(tt-item-uni-estab-aux.tipo-est-seg)
                   it-estab-ts:SCREEN-VALUE IN FRAME fpage1               = STRING(tt-item-uni-estab-aux.tempo-segu)
                   it-estab-cons:SCREEN-VALUE IN FRAME fpage1             = STRING(tt-item-uni-estab-aux.consumo-prev).

            /* Mesmo campo apresentando na tela do CE0330 conforme solicitaá∆o do Agilson (compras) */
            FIND FIRST item-estab NO-LOCK
                WHERE  item-estab.cod-estabel = tt-item-uni-estab-aux.cod-estabel
                AND    item-estab.it-codigo   = tt-item-uni-estab-aux.it-codigo NO-ERROR.
            IF  AVAIL item-estab 
            THEN ASSIGN it-estab-cons-aad:SCREEN-VALUE IN FRAME fpage1 = STRING(item-estab.consumo-aad).
            ELSE ASSIGN it-estab-cons-aad:SCREEN-VALUE IN FRAME fpage1 = "0".
            
            ASSIGN it-estab-horiz:SCREEN-VALUE IN FRAME fpage1            = STRING(subSTRING(tt-item-uni-estab-aux.char-1,129,3))
                   cod-horiz-fixo-cd1112:SCREEN-VALUE IN FRAME fpage1     = STRING(tt-item-uni-estab-aux.horiz-fixo)
                   cb-cod-obsol-cd0140:SCREEN-VALUE IN FRAME fpage1       = {ininc/i17in172.i 04 tt-item-uni-estab-aux.cod-obsoleto}
                   cb-classe-reprog-cd1112:SCREEN-VALUE IN FRAME fpage1   = {ininc/i06in122.i 04 tt-item-uni-estab-aux.classe-repro}
                   cb-reabastace-cd1112:SCREEN-VALUE IN FRAME fpage1      = if substr(tt-item-uni-estab-aux.char-1,10,1) = "" 
                                                                            then {ininc/i26in172.i 04 1} 
                                                                            else {ininc/i26in172.i 04 int(substr(tt-item-uni-estab-aux.char-1,10,1))}  
                   cb-divisao-ordens-cd1112:SCREEN-VALUE IN FRAME fpage1  = {ininc/i12in122.i 04 tt-item-uni-estab-aux.div-ordem}
                   cb-emis-ordens-cd1112:SCREEN-VALUE IN FRAME fpage1     = {ininc/i03in122.i 04 tt-item-uni-estab-aux.emissao-ord}
                   cb-politica-cd1112:SCREEN-VALUE IN FRAME fpage1        = {ininc/i04in122.i 04 tt-item-uni-estab-aux.politica}
                   cb-tp-demanda-cd1112:SCREEN-VALUE IN FRAME fpage1      = {ininc/i02in122.i 04 tt-item-uni-estab-aux.demanda}
                   gr-item-uni-estab                                      = tt-item-uni-estab-aux.r-rowid.

            FIND FIRST ITEM NO-LOCK
                WHERE  ITEM.it-codigo = tt-item-uni-estab-aux.it-codigo NO-ERROR.
            
            FIND FIRST int-item NO-LOCK
                WHERE  int-item.it-codigo = tt-item-uni-estab-aux.it-codigo NO-ERROR.

            FIND FIRST int-item-uni-estab NO-LOCK
                 WHERE int-item-uni-estab.it-codigo   = tt-item-uni-estab-aux.it-codigo
                   AND int-item-uni-estab.cod-estabel = tt-item-uni-estab-aux.cod-estabel NO-ERROR.

            ASSIGN log-necessita-li:CHECKED IN FRAME fPage1 = IF AVAIL ITEM THEN ITEM.log-necessita-li            ELSE FALSE
                   de-perc-II:SCREEN-VALUE IN FRAME fPage1  = IF AVAIL ITEM THEN string(SUBSTR(ITEM.char-2,22,6)) ELSE "0"
                   de-perc-IPI:SCREEN-VALUE IN FRAME fPage1 = IF AVAIL ITEM THEN STRING(ITEM.aliquota-IPI)        ELSE "0"
                   c-NCM:SCREEN-VALUE IN FRAME fPage1       = IF AVAIL ITEM THEN ITEM.class-fiscal                ELSE ""
                   un-cd1112:SCREEN-VALUE IN FRAME fpage1   =  IF AVAIL ITEM THEN ITEM.un                         ELSE "".

            IF  AVAIL ITEM THEN DO:
                FIND FIRST classif-fisc NO-LOCK
                     WHERE classif-fisc.class-fiscal = ITEM.class-fiscal NO-ERROR.
                ASSIGN c-desc-NCM:SCREEN-VALUE IN FRAME fPage1 = IF AVAIL classif-fisc THEN classif-fisc.descricao ELSE "".

                END. /* IF  AVAIL ITEM THEN DO: */
            
            IF SUBSTRING(tt-item-uni-estab-aux.char-1,132,1) = "1" 
            THEN ASSIGN log-repres-demanda-cd1112:CHECKED in frame fpage1 = YES.
            ELSE ASSIGN log-repres-demanda-cd1112:CHECKED in frame fpage1 = NO.
                
            IF AVAIL int-item THEN 
                ASSIGN l-antidumping:CHECKED IN FRAME fPage1 = int-item.log-antidumping.
            ELSE
                 ASSIGN l-antidumping:CHECKED = NO.
            
            IF AVAIL int-item-uni-estab THEN DO:
                 ASSIGN i-origem-aux = int-item-uni-estab.codigo-orig + 1.
                 ASSIGN i-codigo-orig-cd0140:SCREEN-VALUE IN FRAME fPage1 = string(int-item-uni-estab.codigo-orig)
                        c-desc-origem:SCREEN-VALUE        IN FRAME fPage1 = {ininc/i18in122.i 04 i-origem-aux}.
            END.
            

            FIND FIRST int-item-uni-estab
                WHERE  int-item-uni-estab.cod-estabel = tt-item-uni-estab-aux.cod-estabel
                AND    int-item-uni-estab.it-codigo   = tt-item-uni-estab-aux.it-codigo NO-LOCK NO-ERROR. 
            IF AVAIL int-item-uni-estab 
            THEN ASSIGN cod-qtde-politica-cd1112:SCREEN-VALUE IN FRAME fpage1 = STRING(int-item-uni-estab.qtd-pol)
                        c-observacao:SCREEN-VALUE IN FRAME fpage1             = STRING(int-item-uni-estab.observacao).
            ELSE ASSIGN cod-qtde-politica-cd1112:SCREEN-VALUE IN FRAME fpage1 = "0"
                        c-observacao:SCREEN-VALUE IN FRAME fpage1             = "".

            ASSIGN tg-inspec:CHECKED = NO.

            bl_inspec:
            FOR EACH mgesp.item-fabric no-lock
               where item-fabric.it-codigo = tt-item-uni-estab-aux.it-codigo:
                FOR FIRST item-fornec-estab NO-LOCK
                    WHERE item-fornec-estab.it-codigo    = item-fabric.it-codigo
                    AND   item-fornec-estab.item-do-forn = STRING(item-fabric.cod-fabric)
                    AND   item-fornec-estab.cod-estabel  = tt-item-uni-estab-aux.cod-estabel,
                    FIRST int-item-fornec-estab OF item-fornec-estab NO-LOCK:
                    IF int-item-fornec-estab.log-nec-inspec THEN DO:
                       ASSIGN tg-inspec:CHECKED = int-item-fornec-estab.log-nec-inspec.
                       LEAVE bl_inspec.
                    END.
                END.
            END.

            FIND FIRST planejad
                where planejad.cd-planejado = tt-item-uni-estab-aux.cd-planejado no-lock no-error.
            IF AVAIL planejad 
            THEN ASSIGN des-planejador-cd1112:SCREEN-VALUE IN FRAME fpage1 = planejad.nome.
            ELSE ASSIGN des-planejador-cd1112:SCREEN-VALUE IN FRAME fpage1 = "".

            FIND first deposito 
                where deposito.cod-depos = tt-item-uni-estab-aux.deposito-pad NO-LOCK NO-ERROR.
            if avail deposito THEN assign des-deposito-cd0140:SCREEN-VALUE IN FRAME fPage1 = deposito.nome.
            
            FIND first natureza-despesa 
                where natureza-despesa.nat-despesa = tt-item-uni-estab-aux.nat-despesa NO-LOCK NO-ERROR.
            if avail natureza-despesa THEN assign des-nat-despesa-cd0140:SCREEN-VALUE IN FRAME fPage1 = natureza-despesa.descricao. 
            
            find first tipo-rec-desp 
                where tipo-rec-desp.tp-codigo = tt-item-uni-estab-aux.tp-desp-padrao NO-LOCK no-error. 
            if avail tipo-rec-desp THEN ASSIGN des-tip-despesa-cd0140:SCREEN-VALUE IN FRAME fPage1 = tipo-rec-desp.descricao. 
            
            FIND FIRST unid-negoc 
                WHERE unid-negoc.cod-unid-negoc = tt-item-uni-estab-aux.cod-unid-negoc NO-LOCK NO-ERROR. 
            IF AVAIL unid-negoc THEN ASSIGN des-unid-negoc-cd0140:SCREEN-VALUE IN FRAME fpage1 = unid-negoc.des-unid-negoc.
            
        END.
        ELSE DO:
            ASSIGN cb-classif-abc-ce0330:SCREEN-VALUE IN FRAME fpage1     = ""
                   cb-criticidade-ce0330:SCREEN-VALUE IN FRAME fpage1     = ""
                   log-control-qualidade-ce0330:CHECKED IN FRAME fpage1   = FALSE
                   cod-comprador-cc0120:SCREEN-VALUE IN FRAME fpage1      = ""
                   cod-estab-gestor-cc0120:SCREEN-VALUE IN FRAME fpage1   = ""
                   cod-deposito-cd0140:SCREEN-VALUE IN FRAME fpage1       = ""
                   cod-unid-negoc-cd0140:SCREEN-VALUE IN FRAME fpage1     = ""
                   nat-despesa-cd0140:SCREEN-VALUE IN FRAME fpage1        = ""
                   cod-tp-despesa-cd0140:SCREEN-VALUE IN FRAME fpage1     = ""
                   cb-classe-reprog-cd1112:SCREEN-VALUE IN FRAME fpage1   = ""
                   cb-divisao-ordens-cd1112:SCREEN-VALUE IN FRAME fpage1  = ""
                   cb-emis-ordens-cd1112:SCREEN-VALUE IN FRAME fpage1     = ""
                   cb-politica-cd1112:SCREEN-VALUE IN FRAME fpage1        = ""
                   cb-tp-demanda-cd1112:SCREEN-VALUE IN FRAME fpage1      = ""
                   cod-per-fixo-cd1112:SCREEN-VALUE IN FRAME fpage1       = ""
                   cod-planejador-cd1112:SCREEN-VALUE IN FRAME fpage1     = ""
                   cod-prioridade-mrp-cd1112:SCREEN-VALUE IN FRAME fpage1 = ""
                   un-cd1112:SCREEN-VALUE IN FRAME fpage1                 = ""
                   cod-prioridade-cd1112:SCREEN-VALUE IN FRAME fpage1     = ""
                   vl-lote-minimo-cd1112:SCREEN-VALUE IN FRAME fpage1     = ""
                   vl-lote-multiplo-cd1112:SCREEN-VALUE IN FRAME fpage1   = ""
                   vl-qs-cd1112:SCREEN-VALUE IN FRAME fpage1              = ""
                   vl-ressupr-for-cd1112:SCREEN-VALUE IN FRAME fpage1     = ""
                   it-estab-com:SCREEN-VALUE IN FRAME fpage1              = ""
                   it-estab-cq:SCREEN-VALUE IN FRAME fpage1               = ""
                   it-estab-tipo:SCREEN-VALUE IN FRAME fpage1             = ""
                   it-estab-ts:SCREEN-VALUE IN FRAME fpage1               = ""
                   it-estab-cons:SCREEN-VALUE IN FRAME fpage1             = ""
                   it-estab-cons-aad:SCREEN-VALUE IN FRAME fpage1         = ""
                   it-estab-horiz:SCREEN-VALUE IN FRAME fpage1            = ""
                   cod-horiz-fixo-cd1112:SCREEN-VALUE IN FRAME fpage1     = ""
                   cb-reabastace-cd1112:SCREEN-VALUE IN FRAME fpage1      = ""
                   cb-cod-obsol-cd0140:SCREEN-VALUE IN FRAME fpage1       = ""
                   log-repres-demanda-cd1112:CHECKED IN FRAME fpage1      = FALSE
                   cod-qtde-politica-cd1112:SCREEN-VALUE IN FRAME fpage1  = ""
                   des-planejador-cd1112:SCREEN-VALUE IN FRAME fpage1     = ""
                   des-deposito-cd0140:SCREEN-VALUE IN FRAME fpage1       = ""
                   des-nat-despesa-cd0140:SCREEN-VALUE IN FRAME fpage1    = ""
                   des-tip-despesa-cd0140:SCREEN-VALUE IN FRAME fpage1    = ""
                   des-unid-negoc-cd0140:SCREEN-VALUE IN FRAME fpage1     = "".
        END.

        IF tt-item-uni-estab-aux.cod-comprado = "" THEN DO:
            IF  NOT CAN-FIND(FIRST tt-erro 
                             WHERE tt-erro.nro-erro = 11) THEN DO:
                CREATE tt-erro.
                ASSIGN tt-erro.nro-erro  = 11
                       tt-erro.prob-erro = "Item sem comprador CC0120"
                       tt-erro.solu-erro = "Cadastrar comprador no CC0120." .
            END. /* IF  NOT CAN-FIND(FIRST tt-erro ... */
        END.

        APPLY 'LEAVE':U TO cod-comprador-cc0120 IN FRAME fPage1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-monta wWindow 
PROCEDURE pi-monta :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DO  WITH FRAME fpage1:
        EMPTY TEMP-TABLE tt-erro NO-ERROR.
        {&OPEN-QUERY-Br-erro}

        EMPTY TEMP-TABLE tt-item-fornec-estab NO-ERROR.
        {&OPEN-QUERY-Br-item-fornec-estab}

        EMPTY TEMP-TABLE tt-item-fornec-estab NO-ERROR.
        {&OPEN-QUERY-br-item-tab}

        RUN pi-dados-campos.
        RUN atualiza-for.
        RUN atualiza-erro.

        IF  AVAIL tt-item-uni-estab-aux AND AVAIL ITEM THEN
            ASSIGN gr-item           = ROWID(ITEM)
                   gr-item-uni-estab = tt-item-uni-estab-aux.r-rowid. 


        IF NOT CAN-FIND(FIRST tt-item-fornec-estab) 
        THEN ASSIGN btCC0531:SENSITIVE IN FRAME fPage1 = TRUE.
        ELSE ASSIGN btCC0531:SENSITIVE IN FRAME fPage1 = FALSE.

        IF NOT CAN-FIND(FIRST tt-item-tab) 
        THEN ASSIGN btCC0313:SENSITIVE IN FRAME fPage1 = TRUE.
        ELSE ASSIGN btCC0313:SENSITIVE IN FRAME fPage1 = FALSE.


    END. /* DO  WITH FRAME fpage1: */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-posiciona wWindow 
PROCEDURE pi-posiciona :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN gr-item-uni-estab = ?.

    DO  WITH FRAME fpage1:
        RUN pi-dados-campos.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-posiciona-preco wWindow 
PROCEDURE pi-posiciona-preco :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-item-tab NO-ERROR.

    FIND FIRST item-fornec-estab NO-LOCK
         WHERE ROWID(item-fornec-estab) = tt-item-fornec-estab.r-item-fornec-estab NO-ERROR.

    /*FIND FIRST tb-pr-cc NO-LOCK
        WHERE  tb-pr-cc.nome-abrev   = tt-item-fornec-estab.nome-abrev      
        AND    tb-pr-cc.dt-inicio   <= TODAY                    
        AND    tb-pr-cc.dt-termino  >= TODAY                    
        AND    tb-pr-cc.situacao     = 1 /* Ativa */                       
        AND    tb-pr-cc.cod-cond-pag = tt-item-fornec-estab.i-cod-cond-pag 
        AND    tb-pr-cc.mo-codigo    = INT(SUBSTRING(item-fornec-estab.char-1,1,1))  
        AND    tb-pr-cc.cod-estabel  = INPUT FRAME fpage1 cod-estab-sel NO-ERROR.

    IF NOT AVAIL tb-pr-cc THEN
    FIND FIRST tb-pr-cc NO-LOCK
        WHERE  tb-pr-cc.nome-abrev   = tt-item-fornec-estab.nome-abrev      
        AND    tb-pr-cc.dt-inicio   <= TODAY                    
        AND    tb-pr-cc.dt-termino  >= TODAY                    
        AND    tb-pr-cc.situacao     = 1 /* Ativa */                       
        AND    tb-pr-cc.cod-cond-pag = tt-item-fornec-estab.i-cod-cond-pag 
        AND    tb-pr-cc.mo-codigo    = INT(SUBSTRING(item-fornec-estab.char-1,1,1)) NO-ERROR.
    IF  AVAIL  tb-pr-cc THEN DO:*/
    FOR EACH  tb-pr-cc NO-LOCK
        WHERE tb-pr-cc.nome-abrev   = tt-item-fornec-estab.nome-abrev      
          AND tb-pr-cc.dt-inicio   <= TODAY                    
          AND tb-pr-cc.dt-termino  >= TODAY                    
          AND tb-pr-cc.situacao     = 1 /* Ativa */                       
          AND tb-pr-cc.cod-cond-pag = tt-item-fornec-estab.i-cod-cond-pag 
          AND tb-pr-cc.mo-codigo    = INT(SUBSTRING(item-fornec-estab.char-1,1,1)) .

        FOR EACH item-tab NO-LOCK 
           WHERE item-tab.it-codigo    = tt-item-fornec-estab.for-it-codigo
             AND item-tab.cod-emitente = tb-pr-cc.cod-emitente
             AND item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag
             AND item-tab.nr-tab       = tb-pr-cc.nr-tab
             AND item-tab.dt-inicio    = tb-pr-cc.dt-inicio
             AND item-tab.cod-estabe   = tb-pr-cc.cod-estabel:

            IF  NOT CAN-FIND(FIRST tt-item-tab
                             WHERE tt-item-tab.cod-emitente        = item-tab.cod-emitente
                             and   tt-item-tab.des-referencia      = item-tab.des-referencia
                             and   tt-item-tab.t-cod-cond-pag      = item-tab.cod-cond-pag
                             and   tt-item-tab.nr-tab              = item-tab.nr-tab
                             and   tt-item-tab.dt-inic             = item-tab.dt-inicio
                             and   tt-item-tab.it-codigo           = item-tab.it-codigo
                             and   tt-item-tab.qty-min             = item-tab.quant-min) THEN DO:

                CREATE tt-item-tab.
                ASSIGN tt-item-tab.cod-emitente        = item-tab.cod-emitente  
                       tt-item-tab.des-referencia      = item-tab.des-referencia
                       tt-item-tab.t-cod-cond-pag      = item-tab.cod-cond-pag  
                       tt-item-tab.nr-tab              = item-tab.nr-tab        
                       tt-item-tab.dt-inic             = item-tab.dt-inicio     
                       tt-item-tab.it-codigo           = item-tab.it-codigo     
                       tt-item-tab.qty-min             = item-tab.quant-min
                       tt-item-tab.dt-term             = IF AVAIL tb-pr-cc THEN tb-pr-cc.dt-termino   ELSE ?
                       tt-item-tab.moeda               = IF AVAIL tb-pr-cc THEN tb-pr-cc.mo-codigo    ELSE 0
                       tt-item-tab.taxa-fin            = IF AVAIL tb-pr-cc THEN tb-pr-cc.valor-taxa   ELSE 0
                       tt-item-tab.dias-taxa           = IF AVAIL tb-pr-cc THEN tb-pr-cc.nr-dias-taxa ELSE 0
                       tt-item-tab.perc-icms           = item-tab.aliquota-icm
                       tt-item-tab.perc-ipi            = item-tab.aliquota-ipi
                       tt-item-tab.preco               = item-tab.pr-item
                       tt-item-tab.r-item-uni-estab    = tt-item-uni-estab-aux.r-rowid
                       tt-item-tab.r-item-tab          = ROWID(item-tab)
                       tt-item-tab.r-item-fornec-estab = tt-item-fornec-estab.r-item-fornec-estab.
            END. /* IF  NOT CAN-FIND(FIRST tt-item-tab */ 
        END. /* FOR EACH  item-tab OF tb-pr-cc NO-LOCK  */
    END. /* IF  AVAIL  tb-pr-cc THEN DO: */

    {&OPEN-QUERY-br-item-tab}

    IF NOT CAN-FIND(FIRST tt-item-tab) 
    THEN ASSIGN btCC0313:SENSITIVE IN FRAME fPage1 = TRUE.
    ELSE ASSIGN btCC0313:SENSITIVE IN FRAME fPage1 = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reposiciona-cc0120 wWindow 
PROCEDURE pi-reposiciona-cc0120 :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-rowid-cc0120 AS ROWID NO-UNDO.
        
define variable h-prog-compras as handle no-undo.

run ccp/cc0120.w persistent set h-prog-compras.

if  valid-handle(h-prog-compras) then do:

    {&window-name}:sensitive = no.

    session:set-wait-state("general":U).

    /*--- seta parametros no programa de compras ---*/
    run setParameters in h-prog-compras( input p-rowid-cc0120 ) .

    /*--- inicializa o programa ---*/
    run initializeInterface in h-prog-compras .

    session:set-wait-state("":U).

    if valid-handle(h-prog-compras) then wait-for close of h-prog-compras focus current-window.

    {&window-name}:sensitive = yes.

end.
else assign {&window-name}:sensitive = yes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-save wWindow 
PROCEDURE pi-save :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEF BUFFER b-item-uni-estab     FOR item-uni-estab.
    DEF BUFFER b-int-item-uni-estab FOR int-item-uni-estab.

    IF  AVAIL tt-item-uni-estab-aux THEN DO:

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = tt-item-uni-estab-aux.it-codigo NO-ERROR.
                                                  
        IF NOT CAN-FIND(FIRST estabelec WHERE estabelec.cod-estabel = INPUT FRAME fPage1 cod-estab-gestor-cc0120) THEN DO:
    
            RUN utp/ut-msgs.p (INPUT "SHOW", INPUT 2, INPUT "Estabelecimento Gestor").
            APPLY 'ENTRY' TO cod-estab-gestor-cc0120.
            RETURN "NOK".
        end.
    
        IF NOT CAN-FIND(FIRST comprador WHERE comprador.cod-comprado = INPUT FRAME fPage1 cod-comprador-cc0120) THEN DO:
    
            RUN utp/ut-msgs.p (INPUT "SHOW", INPUT 2, INPUT "Comprador").
            APPLY 'ENTRY' TO cod-comprador-cc0120.
            RETURN "NOK".
        END.
    
        IF NOT CAN-FIND(FIRST planejad WHERE planejad.cd-planejado = INPUT FRAME fPage1 cod-planejador-cd1112) THEN DO:
                
            RUN utp/ut-msgs.p (INPUT "show", INPUT 56, INPUT "Planejador"). 
            APPLY 'ENTRY' TO cod-planejador-cd1112.
            RETURN "NOK".
        END.
    
        IF AVAIL ITEM THEN DO:
            IF  INPUT FRAME {&FRAME-NAME} vl-lote-multiplo-cd1112 <> TRUNCATE(INPUT FRAME {&FRAME-NAME} vl-lote-multiplo-cd1112,0) 
            AND NOT ITEM.fraciona THEN DO:
                 
                RUN utp/ut-msgs.p (INPUT "show", INPUT 907, INPUT "").
                APPLY 'ENTRY' TO vl-lote-multiplo-cd1112.
                RETURN "NOK".
            END.
        END.
    
        IF NOT CAN-FIND(FIRST deposito WHERE deposito.cod-depos = INPUT FRAME fPage1 cod-deposito-cd0140) THEN DO:
                            
            RUN utp/ut-msgs.p (INPUT "show", INPUT 2, INPUT "Dep¢sito").
            APPLY 'ENTRY' TO cod-deposito-cd0140.
            RETURN "NOK".                        
        END. 
    
        IF NOT CAN-FIND (FIRST mgcad.localizacao
                         WHERE mgcad.localizacao.cod-estabel = tt-item-uni-estab-aux.cod-estabel  
                         AND   mgcad.localizacao.cod-depos   = INPUT FRAME fPage1 cod-deposito-cd0140
                         AND   mgcad.localizacao.cod-localiz = tt-item-uni-estab-aux.cod-localiz) THEN DO:
    
            RUN utp/ut-msgs.p (INPUT "show", INPUT 6662,  INPUT "").
            APPLY 'ENTRY' TO cod-deposito-cd0140.
            RETURN "NOK".                        
        END.
    
        FIND FIRST tipo-rec-desp NO-LOCK 
             WHERE tipo-rec-desp.tp-codigo = INPUT FRAME fPage1 cod-tp-despesa-cd0140 NO-ERROR.
    
        IF  NOT AVAIL tipo-rec-desp THEN DO:     
            RUN utp/ut-msgs.p (INPUT "show", INPUT 2, INPUT "Tipo Despesa").
            APPLY 'ENTRY' TO cod-tp-despesa-cd0140.
            RETURN "NOK".  
        END.
        ELSE IF  tipo-rec-desp.tipo = 1 THEN DO:
                 RUN utp/ut-msgs.p (INPUT "show", INPUT 414, INPUT "").
                 APPLY 'ENTRY' TO cod-tp-despesa-cd0140.
                 RETURN "NOK".  
             END.
    
        IF  NOT CAN-FIND(FIRST natureza-despesa WHERE natureza-despesa.nat-despesa = INPUT FRAME fPage1 nat-despesa-cd0140) THEN DO:
            RUN utp/ut-msgs.p (INPUT "show", INPUT 2, INPUT "Natureza Despesa").
            APPLY 'ENTRY' TO nat-despesa-cd0140.
            RETURN "NOK".  
        END.
    
        IF  NOT CAN-FIND(FIRST unid-negoc WHERE unid-negoc.cod-unid-negoc = INPUT FRAME fPage1 cod-unid-negoc-cd0140) THEN DO:
            RUN utp/ut-msgs.p (INPUT "show", INPUT 2, INPUT "Unidade de Neg¢cio").
            APPLY 'ENTRY' TO cod-unid-negoc-cd0140.
            RETURN "NOK".  
        END.
    
    
        FIND FIRST b-item-uni-estab EXCLUSIVE-LOCK
             WHERE b-item-uni-estab.it-codigo    = tt-item-uni-estab-aux.it-codigo  
             AND   b-item-uni-estab.cod-estabel  = tt-item-uni-estab-aux.cod-estabel
             AND   b-item-uni-estab.cod-comprado = tt-item-uni-estab-aux.cod-comprado NO-ERROR.
        IF  AVAIL  b-item-uni-estab THEN DO:
            ASSIGN b-item-uni-estab.cod-estab-gestor        = INPUT FRAME fPage1 cod-estab-gestor-cc0120        
                   b-item-uni-estab.cod-comprado            = INPUT FRAME fPage1 cod-comprador-cc0120
                   b-item-uni-estab.res-for-comp            = INPUT FRAME fPage1 vl-ressupr-for-cd1112
                   b-item-uni-estab.res-cq-comp             = INPUT FRAME fPage1 it-estab-cq
                   b-item-uni-estab.res-int-comp            = INPUT FRAME fPage1 it-estab-com                  
                   b-item-uni-estab.consumo-prev            = INPUT FRAME fPage1 it-estab-cons
                   b-item-uni-estab.tipo-est-seg            = INPUT FRAME fPage1 it-estab-tipo
                   b-item-uni-estab.tempo-segur             = INPUT FRAME fPage1 it-estab-ts
                   b-item-uni-estab.quant-segur             = INPUT FRAME fPage1 vl-qs-cd1112
                   OVERLAY(b-item-uni-estab.char-1,132,1)   = IF INPUT FRAME fPage1 log-repres-demanda-cd1112 THEN "1" ELSE "0"
                   b-item-uni-estab.cd-planejado            = INPUT FRAME fPage1 cod-planejador-cd1112          
                   b-item-uni-estab.lote-multipl            = INPUT FRAME fPage1 vl-lote-multiplo-cd1112
                   b-item-uni-estab.lote-minimo             = INPUT FRAME fPage1 vl-lote-minimo-cd1112          
                   b-item-uni-estab.periodo-fixo            = INPUT FRAME fPage1 cod-per-fixo-cd1112
                   b-item-uni-estab.prioridade              = INPUT FRAME fPage1 cod-prioridade-cd1112
                   b-item-uni-estab.int-1                   = INPUT FRAME fPage1 cod-prioridade-mrp-cd1112
                   b-item-uni-estab.horiz-fixo              = INPUT FRAME fPage1 cod-horiz-fixo-cd1112          
                   OVERLAY(b-item-uni-estab.char-1,129,3)   = INPUT FRAME fPage1 it-estab-horiz        
                   b-item-uni-estab.politica                = {ininc/i04in122.i 06 cb-politica-cd1112:SCREEN-VALUE IN FRAME {&FRAME-NAME}}
                   b-item-uni-estab.demanda                 = {ininc/i02in122.i 06 cb-tp-demanda-cd1112:SCREEN-VALUE IN FRAME {&FRAME-NAME}}
                   b-item-uni-estab.classe-repro            = {ininc/i06in122.i 06 cb-classe-reprog-cd1112:SCREEN-VALUE IN FRAME {&FRAME-NAME}}
                   OVERLAY(b-item-uni-estab.char-1,10,1)    = STRING({ininc/i26in172.i 06 cb-reabastace-cd1112:SCREEN-VALUE IN FRAME {&FRAME-NAME}})
                   b-item-uni-estab.emissao-ord             = {ininc/i03in122.i 06 cb-emis-ordens-cd1112:SCREEN-VALUE IN FRAME {&FRAME-NAME}}
                   b-item-uni-estab.cod-obsoleto            = {ininc/i17in172.i 06 cb-cod-obsol-cd0140:SCREEN-VALUE IN FRAME {&FRAME-NAME}}
                   b-item-uni-estab.div-ordem               = {ininc/i12in122.i 06 cb-divisao-ordens-cd1112:SCREEN-VALUE IN FRAME {&FRAME-NAME}}
                   b-item-uni-estab.deposito-pad            = INPUT FRAME fPage1 cod-deposito-cd0140            
                   b-item-uni-estab.tp-desp-padrao          = INPUT FRAME fPage1 cod-tp-despesa-cd0140          
                   b-item-uni-estab.nat-despesa             = INPUT FRAME fPage1 nat-despesa-cd0140
                   b-item-uni-estab.cod-unid-negoc          = INPUT FRAME fPage1 cod-unid-negoc-cd0140
                   b-item-uni-estab.classif-abc             = {ininc/i03in172.i 06 cb-classif-abc-ce0330:SCREEN-VALUE IN FRAME {&FRAME-NAME}}.
           
            FIND FIRST b-int-item-uni-estab EXCLUSIVE-LOCK
                 WHERE b-int-item-uni-estab.cod-estabel = tt-item-uni-estab-aux.cod-estabel
                   AND b-int-item-uni-estab.it-codigo   = tt-item-uni-estab-aux.it-codigo NO-ERROR. 

            IF AVAIL b-int-item-uni-estab THEN 
                ASSIGN b-int-item-uni-estab.qtd-pol     = INPUT FRAME fPage1 cod-qtde-politica-cd1112
                       b-int-item-uni-estab.codigo-orig = INPUT FRAME fPage1 i-codigo-orig-cd0140.
            ELSE DO:
                CREATE int-item-uni-estab.
                ASSIGN int-item-uni-estab.cod-estabel = tt-item-uni-estab-aux.cod-estabel
                       int-item-uni-estab.it-codigo   = tt-item-uni-estab-aux.it-codigo
                       int-item-uni-estab.qtd-pol     = INPUT FRAME fPage1 cod-qtde-politica-cd1112
                       int-item-uni-estab.codigo-orig = INPUT FRAME fPage1 i-codigo-orig-cd0140.
            END. /* ELSE DO: */
            
        END. /* IF  AVAIL  b-item-uni-estab THEN DO: */
    END. /* IF  AVAIL tt-item-uni-estab-aux THEN DO: */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-permis wWindow 
PROCEDURE pi-verifica-permis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM programa AS CHAR NO-UNDO.

/* Seleciona usuario com autorizaá∆o de alteraá∆o de periodo congelado */
    RUN esp\es0018p.p (INPUT programa,
                       INPUT 1,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
/* Fim seleá∆o usu†rio */

    ASSIGN l-permis-alterar = CAN-FIND(FIRST tt-prog-ponto NO-LOCK WHERE tt-prog-ponto.conteudo = c-seg-usuario).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDesc-class-reprog wWindow 
FUNCTION fnDesc-class-reprog RETURNS CHARACTER
  ( i-classe-reprog AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-desc-classe-reprog AS CHARACTER FORMAT 'X(20)':U NO-UNDO.

    ASSIGN c-desc-classe-reprog = {ininc/i06in122.i 04 i-classe-reprog}.

    RETURN c-desc-classe-reprog.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDesc-moeda wWindow 
FUNCTION fnDesc-moeda RETURNS CHARACTER
  ( i-mo-codigo AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-desc-moeda LIKE moeda.descricao NO-UNDO.

    FIND FIRST moeda NO-LOCK
        WHERE  moeda.mo-codigo = i-mo-codigo NO-ERROR.
    IF  AVAIL moeda
    THEN ASSIGN c-desc-moeda = moeda.descricao.
    ELSE ASSIGN c-desc-moeda = "":U.

    RETURN c-desc-moeda.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

