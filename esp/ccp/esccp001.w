&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgmov           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-pedido-compr NO-UNDO LIKE pedido-compr
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCCP001 2.04.01.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCCP001
&GLOBAL-DEFINE Version        1

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1


&GLOBAL-DEFINE First          NO
&GLOBAL-DEFINE Prev           NO
&GLOBAL-DEFINE Next           NO
&GLOBAL-DEFINE Last           NO
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            NO 
&GLOBAL-DEFINE Copy           NO 
&GLOBAL-DEFINE Update         NO  
&GLOBAL-DEFINE Delete         NO  
&GLOBAL-DEFINE Undo           NO  
&GLOBAL-DEFINE Cancel         NO  
&GLOBAL-DEFINE Save           NO

&GLOBAL-DEFINE ttTable        tt-pedido-compr
&GLOBAL-DEFINE hDBOTable      bo-pedido-compr
&GLOBAL-DEFINE DBOTable       pedido-compr

&GLOBAL-DEFINE page0KeyFields tt-pedido-compr.cod-estabel tt-pedido-compr.cod-emitente tt-pedido-compr.num-pedido tt-pedido-compr.cod-cond-pag
&GLOBAL-DEFINE page1Widgets   brOrdemCotacao 
&GLOBAL-DEFINE page2Widgets   btnOk btnCancela
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    fiPtBase fiCodItiner fiCodIncoterm

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

{utp/ut-glob.i}
{cdp\cd0666.i}          /* Definicao da temp-table de erros */
{cdp\cdcfgdis.i}        /* Pre-processadores */

DEFINE TEMP-TABLE tt-ordem-cotacao 
    FIELD numero-ordem        LIKE cotacao-item.numero-ordem     COLUMN-LABEL "Ord Compra"
    FIELD cod-emitente        LIKE cotacao-item.cod-emitente
    FIELD it-codigo           LIKE cotacao-item.it-codigo   
    FIELD seq-cotac           LIKE cotacao-item.seq-cotac 
    FIELD nr-proc-imp         LIKE processo-imp.nr-proc-imp
    FIELD class-fisc          AS   INTEGER   FORMAT "9999,99,99" COLUMN-LABEL "Class Fisc"
    FIELD mapa                AS   CHARACTER FORMAT "X(04)"      COLUMN-LABEL "Mapa" 
    FIELD ptBase              AS   CHARACTER FORMAT "X(05)"      COLUMN-LABEL "Pt Base" 
    FIELD AliqII              AS   CHARACTER FORMAT "X(9)"       COLUMN-LABEL "Aliq II" 
    FIELD regime              AS   CHARACTER FORMAT "X(06)"      COLUMN-LABEL "Regime" 
    FIELD itinerario          AS   INTEGER   FORMAT ">>>>9"      COLUMN-LABEL "Itiner" 
    FIELD cod-incoterm        AS   CHARACTER FORMAT "X(03)"      COLUMN-LABEL "Incoterm" 
    FIELD descItiner          LIKE itinerario.descricao FORMAT "X(15)"
    FIELD descPtoControleBase LIKE pto-contr.descricao
    FIELD cod-transp          LIKE pedido-compr.cod-transp 
    FIELD via-transp          LIKE pedido-comp.via-transp. 

DEFINE VARIABLE l-Class   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-ii      AS LOGICAL    NO-UNDO.
DEFINE BUFFER b-ordem-compra     FOR ordem-compra.
DEFINE BUFFER b-cotacao-item     FOR cotacao-item.
DEFINE BUFFER b-tt-ordem-cotacao FOR tt-ordem-cotacao.
DEFINE BUFFER b-pedido-compr     FOR pedido-compr.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brOrdemCotacao

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ordem-cotacao

/* Definitions for BROWSE brOrdemCotacao                                */
&Scoped-define FIELDS-IN-QUERY-brOrdemCotacao tt-ordem-cotacao.numero-ordem tt-ordem-cotacao.it-codigo tt-ordem-cotacao.nr-proc-imp tt-ordem-cotacao.class-fisc tt-ordem-cotacao.cod-incoterm tt-ordem-cotacao.ptBase tt-ordem-cotacao.descPtoControleBase tt-ordem-cotacao.itinerario tt-ordem-cotacao.descItiner   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brOrdemCotacao   
&Scoped-define SELF-NAME brOrdemCotacao
&Scoped-define QUERY-STRING-brOrdemCotacao FOR EACH tt-ordem-cotacao NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brOrdemCotacao OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem-cotacao NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brOrdemCotacao tt-ordem-cotacao
&Scoped-define FIRST-TABLE-IN-QUERY-brOrdemCotacao tt-ordem-cotacao


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brOrdemCotacao}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-pedido-compr.cod-estabel ~
tt-pedido-compr.cod-emitente tt-pedido-compr.num-pedido ~
tt-pedido-compr.cod-cond-pag 
&Scoped-define ENABLED-TABLES tt-pedido-compr
&Scoped-define FIRST-ENABLED-TABLE tt-pedido-compr
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btGoTo btSearch ~
btQueryJoins btReportsJoins btExit btHelp c-desc-cond 
&Scoped-Define DISPLAYED-FIELDS tt-pedido-compr.cod-estabel ~
tt-pedido-compr.cod-emitente tt-pedido-compr.num-pedido ~
tt-pedido-compr.cod-cond-pag 
&Scoped-define DISPLAYED-TABLES tt-pedido-compr
&Scoped-define FIRST-DISPLAYED-TABLE tt-pedido-compr
&Scoped-Define DISPLAYED-OBJECTS c-nome-abrev c-desc-cond 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miUndo         LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
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
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE c-desc-cond AS CHARACTER FORMAT "x(20)":U 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "x(12)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 114 BY 1.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 114 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btUpdateTarget 
     LABEL "Atualiza" 
     SIZE 18 BY 1.

DEFINE BUTTON btZera 
     LABEL "&Padr∆o" 
     SIZE 18 BY 1.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 112 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btnCancela 
     LABEL "&Cancela" 
     SIZE 15 BY 1.

DEFINE BUTTON btnOk 
     LABEL "&OK" 
     SIZE 15 BY 1.

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Via Transp" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-itiner AS CHARACTER FORMAT "x(20)":U 
     VIEW-AS FILL-IN 
     SIZE 22.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-pto AS CHARACTER FORMAT "x(20)":U 
     VIEW-AS FILL-IN 
     SIZE 22.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-transp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 18.72 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodIncoterm AS CHARACTER FORMAT "X(3)":U 
     LABEL "Incoterm" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodItiner AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Itiner†rio" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fiPtBase AS CHARACTER FORMAT "X(05)":U 
     LABEL "Pt Base" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-transportador AS INTEGER FORMAT ">>>>>>>>9" 
     LABEL "C¢digo Transportador" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 112 BY 18.

DEFINE RECTANGLE rtToolBar-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 112 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brOrdemCotacao FOR 
      tt-ordem-cotacao SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brOrdemCotacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brOrdemCotacao wMaintenance _FREEFORM
  QUERY brOrdemCotacao NO-LOCK DISPLAY
      tt-ordem-cotacao.numero-ordem 
        tt-ordem-cotacao.it-codigo FORMAT "x(7)"
        tt-ordem-cotacao.nr-proc-imp 
        tt-ordem-cotacao.class-fisc    
        tt-ordem-cotacao.cod-incoterm
        tt-ordem-cotacao.ptBase
        tt-ordem-cotacao.descPtoControleBase WIDTH 25
        tt-ordem-cotacao.itinerario    
        tt-ordem-cotacao.descItiner
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 112 BY 18
         FONT 2 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa" WIDGET-ID 6
     btQueryJoins AT ROW 1.13 COL 98.29 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 102.29 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 106.29 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 110.29 HELP
          "Ajuda"
     tt-pedido-compr.cod-estabel AT ROW 3 COL 12.86 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-pedido-compr.cod-emitente AT ROW 3 COL 28.29 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-nome-abrev AT ROW 3 COL 39.43 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     tt-pedido-compr.num-pedido AT ROW 3 COL 60.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-pedido-compr.cod-cond-pag AT ROW 3 COL 87.86 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-cond AT ROW 3 COL 94 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     rtKeys AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 114 BY 24
         FONT 1.

DEFINE FRAME fPage2
     fiCodIncoterm AT ROW 4.75 COL 44 COLON-ALIGNED
     fiPtBase AT ROW 5.75 COL 44 COLON-ALIGNED
     c-desc-pto AT ROW 5.75 COL 51.29 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     fiCodItiner AT ROW 6.75 COL 44 COLON-ALIGNED
     c-desc-itiner AT ROW 6.75 COL 51.29 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     i-cod-transportador AT ROW 7.75 COL 44 COLON-ALIGNED WIDGET-ID 14
     c-nome-transp AT ROW 7.75 COL 55.29 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     COMBO-BOX-1 AT ROW 8.75 COL 44 COLON-ALIGNED WIDGET-ID 10
     btnOk AT ROW 19.79 COL 3
     btnCancela AT ROW 19.79 COL 19
     rtKeys-2 AT ROW 1.25 COL 2
     rtToolBar-3 AT ROW 19.54 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 4.5
         SIZE 114 BY 20.5
         FONT 1.

DEFINE FRAME fPage1
     brOrdemCotacao AT ROW 1.25 COL 2
     btUpdateTarget AT ROW 19.79 COL 3
     btZera AT ROW 19.79 COL 22
     rtToolBar-2 AT ROW 19.54 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 4.5
         SIZE 114 BY 20.5
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-pedido-compr T "?" NO-UNDO mgmov pedido-compr
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 24
         WIDTH              = 114
         MAX-HEIGHT         = 24
         MAX-WIDTH          = 133.57
         VIRTUAL-HEIGHT     = 24
         VIRTUAL-WIDTH      = 133.57
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-nome-abrev IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brOrdemCotacao rtToolBar-2 fPage1 */
ASSIGN 
       brOrdemCotacao:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN c-desc-itiner IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-pto IN FRAME fPage2
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brOrdemCotacao
/* Query rebuild information for BROWSE brOrdemCotacao
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem-cotacao NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brOrdemCotacao */
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fpage0
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fpage0 wMaintenance
ON ENTRY OF FRAME fpage0
DO:
    ASSIGN btgoto:SENSITIVE   IN FRAME {&FRAME-NAME} = YES
           btSearch:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fpage0 wMaintenance
ON GO OF FRAME fpage0
DO:
    /*
    RUN goToRecord IN THIS-PROCEDURE.
    */
    ASSIGN btgoto:SENSITIVE   IN FRAME {&FRAME-NAME} = YES
           btSearch:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brOrdemCotacao
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brOrdemCotacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brOrdemCotacao wMaintenance
ON CHOOSE OF brOrdemCotacao IN FRAME fPage1
DO:
  APPLY "U1" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brOrdemCotacao wMaintenance
ON U1 OF brOrdemCotacao IN FRAME fPage1
DO:
    ASSIGN btUpdateTarget:SENSITIVE = AVAIL tt-ordem-cotacao
           btZera:SENSITIVE         = AVAIL tt-ordem-cotacao.

    /*
    ASSIGN btUpdateTarget:SENSITIVE IN FRAME fPage1 = NO.
    {&OPEN-QUERY-brDeposItem}
    APPLY "U1" TO brDeposItem.
    ASSIGN fiDescItem:SCREEN-VALUE IN FRAME fPage1 = tt-ordem-cotacao.desc-item WHEN AVAIL tt-ordem-cotacao.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brOrdemCotacao wMaintenance
ON VALUE-CHANGED OF brOrdemCotacao IN FRAME fPage1
DO:
  APPLY "U1" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:

    RUN goToRecord IN THIS-PROCEDURE.   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btnCancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnCancela wMaintenance
ON CHOOSE OF btnCancela IN FRAME fPage2 /* Cancela */
DO:
  RUN piTrocaFrame(1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnOk wMaintenance
ON CHOOSE OF btnOk IN FRAME fPage2 /* OK */
DO:

  ASSIGN fiCodIncoterm fiPtBase fiCodItiner COMBO-BOX-1 i-cod-transportador.

  IF  NOT CAN-FIND(FIRST pto-itiner
                   WHERE pto-itiner.cod-itiner    = fiCodItiner
                   AND   pto-itiner.cod-pto-contr = int(fiPtBase)) THEN DO:
      RUN utp/ut-msgs.p (INPUT "show":U, INPUT 17006, INPUT "Ponto-Itiner†rio Inv†lido" + '~~' +
                                                            "Ponto de Controle n∆o relacionado ao Itiner†rio informado").
      RETURN NO-APPLY.
  END. /* IF  NOT CAN-FIND(FIRST pto-itiner */
  
  FOR FIRST itinerario NO-LOCK
      WHERE itinerario.cod-itiner = fiCodItiner:
  END. /* FOR FIRST itinerario NO-LOCK */

  IF  NOT AVAIL itinerario THEN DO:
      RUN utp/ut-msgs.p (INPUT "show":U, INPUT 17567, INPUT "Itiner†rio Inv†lido").
      RETURN NO-APPLY.
  END. /* IF  NOT AVAIL itinerario THEN DO: */
  
  FOR FIRST cotacao-item EXCLUSIVE-LOCK 
      WHERE cotacao-item.numero-ordem = tt-ordem-cotacao.numero-ordem
      AND   cotacao-item.cod-emitente = tt-ordem-cotacao.cod-emitente
      AND   cotacao-item.it-codigo    = tt-ordem-cotacao.it-codigo   
      AND   cotacao-item.seq-cotac    = tt-ordem-cotacao.seq-cotac:
      ASSIGN OVERLAY(cotacao-item.char-1,21,20) = string(fiCodIncoterm,"x(20)")
             OVERLAY(cotacao-item.char-1,41,20) = string(fiPtBase,"x(20)")
             cotacao-item.int-1                = int(fiCodItiner).
  END. /* FOR FIRST cotacao-item EXCLUSIVE-LOCK */

  for each  b-ordem-compra NO-LOCK
      where b-ordem-compra.num-pedido = tt-pedido-compr.num-pedido
      and   b-ordem-compra.situacao   = 2 /*"C"*/,
      each  b-cotacao-item EXCLUSIVE-LOCK
      where b-cotacao-item.it-codigo    = b-ordem-compra.it-codigo
      and   b-cotacao-item.cod-emitente = b-ordem-compra.cod-emitente
      and   b-cotacao-item.numero-ordem = b-ordem-compra.numero-ordem:

      assign OVERLAY(b-cotacao-item.char-1,21,20) = string(fiCodIncoterm,"x(20)")
             OVERLAY(b-cotacao-item.char-1,41,20) = string(fiPtBase,"x(20)")
             b-cotacao-item.int-1 = int(fiCodItiner).

  end. /* for each  b-ordem-compra NO-LOCK */

  /* Ao alterar o c¢digo do itinen†rio na tela, atualiza tambÇm o processo de importaá∆o deste pedido */
  FOR FIRST processo-imp EXCLUSIVE-LOCK
      WHERE processo-imp.num-pedido = tt-pedido-compr.num-pedido:

      ASSIGN processo-imp.cod-itiner        = int(fiCodItiner)
             processo-imp.via-transp        = {adinc/i01ad268.i 06 COMBO-BOX-1}
             processo-imp.cod-transportador = i-cod-transportador.             
  END. /* FOR FIRST processo-imp EXCLUSIVE-LOCK */

  FOR FIRST b-pedido-compr EXCLUSIVE-LOCK
      WHERE b-pedido-compr.num-pedido = tt-pedido-compr.num-pedido:

      ASSIGN b-pedido-compr.via-transp = {adinc/i01ad268.i 06 COMBO-BOX-1}
             b-pedido-compr.cod-transp = i-cod-transportador.             
  END. /* FOR FIRST b-pedido-compr EXCLUSIVE-LOCK */

  RUN piTrocaFrame(1).
  RUN piGeraTTOrdemCotacao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="inzoom/z11in295.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateTarget wMaintenance
ON CHOOSE OF btUpdateTarget IN FRAME fPage1 /* Atualiza */
DO:    
    DO  WITH FRAME fPage2:
        
        RUN pi-valida.
        IF RETURN-VALUE = "NOK" THEN RETURN NO-APPLY.

        ASSIGN fiPtBase            = tt-ordem-cotacao.ptBase         
               fiCodItiner         = int(tt-ordem-cotacao.itinerario)
               fiCodIncoterm       = tt-ordem-cotacao.cod-incoterm
               i-cod-transportador = tt-ordem-cotacao.cod-transp
               COMBO-BOX-1:screen-value in frame fPage2 = {adinc/i01ad268.i 04 tt-ordem-cotacao.via-transp}.

        DISP fiPtBase     
             fiCodItiner
             fiCodIncoterm
             i-cod-transportador.
    END.

    RUN piTrocaFrame(2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btZera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btZera wMaintenance
ON CHOOSE OF btZera IN FRAME fPage1 /* Padr∆o */
DO:
    RUN utp/ut-msgs.p (INPUT "show":U, 
                       INPUT 27100, 
                       INPUT "Zera Valores Cotaá‰es ?").    
    IF  RETURN-VALUE = "yes" THEN DO:
        
        RUN pi-valida.
        IF RETURN-VALUE = "NOK" THEN RETURN NO-APPLY.
        
        for each  ordem-compra no-lock
            where ordem-compra.num-pedido = tt-pedido-compr.num-pedido
            and   ordem-compra.situacao     = 2 /*"C"*/,
            each  cotacao-item EXCLUSIVE-LOCK
            where cotacao-item.it-codigo    = ordem-compra.it-codigo
            and   cotacao-item.numero-ordem = ordem-compra.numero-ordem
            and   cotacao-item.cod-emitente = ordem-compra.cod-emitente:

            find first emitente-cex no-lock 
                where  emitente-cex.cod-emitente = ordem-compra.cod-emitente no-error.
             IF NOT AVAIL emitente-cex  THEN NEXT.

             find item     where item.it-codigo        = ordem-compra.it-codigo    no-lock no-error.
             find emitente where emitente.cod-emitente = ordem-compra.cod-emitente no-lock no-error.

             ASSIGN OVERLAY(cotacao-item.char-1,21,20) = if avail emitente-cex and emitente-cex.cod-incoterm-imp <> "" then STRING(emitente-cex.cod-incoterm-imp,"x(20)") else STRING("fob","x(20)") /* cod-incoterm */
                    OVERLAY(cotacao-item.char-1,41,20) = STRING(emitente-cex.cod-pto-contr)
                    cotacao-item.int-1                 = emitente-cex.cod-itiner-imp.
        end. /* for each  ordem-compra no-lock */

        RUN piGeraTTOrdemCotacao.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME tt-pedido-compr.cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pedido-compr.cod-cond-pag wMaintenance
ON LEAVE OF tt-pedido-compr.cod-cond-pag IN FRAME fpage0 /* Condiá∆o Pagamento */
DO:
    FIND FIRST cond-pagto NO-LOCK
        WHERE  cond-pagto.cod-cond-pag = INPUT FRAME fpage0 tt-pedido-compr.cod-cond-pag NO-ERROR.
    IF  AVAIL  cond-pagto
    THEN ASSIGN c-desc-cond:SCREEN-VALUE IN FRAME fPage0 = cond-pagto.descricao.
    ELSE ASSIGN c-desc-cond:SCREEN-VALUE IN FRAME fPage0 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-pedido-compr.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pedido-compr.cod-emitente wMaintenance
ON LEAVE OF tt-pedido-compr.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
    FIND FIRST emitente NO-LOCK
        WHERE  emitente.cod-emitente = INPUT FRAME fpage0 tt-pedido-compr.cod-emitente NO-ERROR.
    IF  AVAIL  emitente
    THEN ASSIGN c-nome-abrev:SCREEN-VALUE IN FRAME fPage0 = emitente.nome-abrev.
    ELSE ASSIGN c-nome-abrev:SCREEN-VALUE IN FRAME fPage0 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME fiCodItiner
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodItiner wMaintenance
ON F5 OF fiCodItiner IN FRAME fPage2 /* Itiner†rio */
DO:
    {method/zoomfields.i 
     &ProgramZoom="cxzoom/z10cx115.w"
     &FieldZoom1="cod-itiner"
     &FieldScreen1="fiCodItiner"
     &Frame1="fPage2"
     &FieldZoom2="descricao"
     &FieldScreen2="c-desc-itiner"
     &Frame2="fPage2"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodItiner wMaintenance
ON LEAVE OF fiCodItiner IN FRAME fPage2 /* Itiner†rio */
DO:
        FIND FIRST itinerario NO-LOCK
            WHERE itinerario.cod-itiner = input frame fPage2 fiCodItiner NO-ERROR.
        IF  AVAIL itinerario
        THEN ASSIGN c-desc-itiner:screen-value in frame fPage2 = itinerario.descricao.
        ELSE ASSIGN c-desc-itiner:screen-value in frame fPage2 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodItiner wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fiCodItiner IN FRAME fPage2 /* Itiner†rio */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiPtBase
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPtBase wMaintenance
ON F5 OF fiPtBase IN FRAME fPage2 /* Pt Base */
DO:
    {include/zoomvar.i &prog-zoom=cxzoom/z01cx120.w
          &campo=fiCodItiner
          &campozoom=pto-itiner
          &frame="fPage2"
          &campo2=fiPtBase
          &campozoom2=cod-pto-contr
          &frame2="fPage2"}   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPtBase wMaintenance
ON LEAVE OF fiPtBase IN FRAME fPage2 /* Pt Base */
DO:
    FIND FIRST pto-contr NO-LOCK
        WHERE  pto-contr.cod-pto-contr = INTEGER(INPUT FRAME fPage2 fiPtBase) NO-ERROR.
    IF  AVAIL  pto-contr 
    THEN ASSIGN c-desc-pto:SCREEN-VALUE IN FRAME fPage2 = pto-contr.descricao.
    ELSE ASSIGN c-desc-pto:SCREEN-VALUE IN FRAME fPage2 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPtBase wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fiPtBase IN FRAME fPage2 /* Pt Base */
DO:
    APPLY "F5":U TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-transportador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-transportador wMaintenance
ON F5 OF i-cod-transportador IN FRAME fPage2 /* C¢digo Transportador */
DO:
    {method/zoomfields.i 
         &ProgramZoom="adzoom/z10ad268.w"
         &FieldZoom1="cod-transp"
         &FieldScreen1="i-cod-transportador"
         &Frame1="fPage2"
         &FieldZoom2="nome-abrev"
         &FieldScreen2="c-nome-transp"
         &Frame2="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-transportador wMaintenance
ON LEAVE OF i-cod-transportador IN FRAME fPage2 /* C¢digo Transportador */
DO:
    IF  input frame fPage2 i-cod-transportador <> 0 then do:

        FIND FIRST transporte NO-LOCK
            WHERE transporte.cod-transp = input frame fPage2 i-cod-transportador NO-ERROR.
        IF  AVAIL transporte
        THEN ASSIGN c-nome-transp:screen-value in frame fPage2 = transporte.nome-abrev.
        ELSE ASSIGN c-nome-transp:screen-value in frame fPage2 = "".

   end. /* IF  input frame fPage2 i-cod-transportador <> 0 */
   else
       assign c-nome-transp:screen-value in frame fPage2 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-transportador wMaintenance
ON MOUSE-SELECT-DBLCLICK OF i-cod-transportador IN FRAME fPage2 /* C¢digo Transportador */
DO:
    apply "F5":U to self in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/MainBlock.i}

ASSIGN btgoto:SENSITIVE   IN FRAME {&FRAME-NAME} = YES
       btSearch:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

i-cod-transportador:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage2.
fiCodItiner:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage2.
fiPtBase:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage2.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDisplayFields wMaintenance 
PROCEDURE AfterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN piGeraTTOrdemCotacao.

    APPLY "LEAVE":U TO tt-pedido-compr.cod-emitente IN FRAME fPage0.
    APPLY "LEAVE":U TO tt-pedido-compr.cod-cond-pag IN FRAME fPage0.

    APPLY "LEAVE":U TO fiPtBase            IN FRAME fPage2.
    APPLY "LEAVE":U TO fiCodIncoterm       IN FRAME fPage2.
    APPLY "LEAVE":U TO i-cod-transportador IN FRAME fPage2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wMaintenance 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN piTrocaFrame(1).
    DO  WITH FRAME fPage2:
        ASSIGN btnOk:SENSITIVE               = YES
               btnCancela:SENSITIVE          = YES
               fiPtBase:SENSITIVE            = YES 
               fiCodItiner:SENSITIVE         = YES
               fiCodIncoterm:SENSITIVE       = YES
               COMBO-BOX-1:SENSITIVE         = YES
               i-cod-transportador:SENSITIVE = YES.

        ASSIGN COMBO-BOX-1:LIST-ITEMS IN FRAME fPage2 = {adinc/i01ad268.i 03}.

        APPLY "LEAVE":U TO fiPtBase            IN FRAME fPage2.
        APPLY "LEAVE":U TO fiCodIncoterm       IN FRAME fPage2.
        APPLY "LEAVE":U TO i-cod-transportador IN FRAME fPage2.

    END.
    ASSIGN brOrdemCotacao:SENSITIVE IN FRAME fPage1 = YES.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel    AUTO-END-KEY LABEL "&Cancelar" SIZE 10 BY 1 BGCOLOR 8.
    DEFINE BUTTON btGoToOK        AUTO-GO      LABEL "&OK"       SIZE 10 BY 1 BGCOLOR 8.
    DEFINE RECTANGLE rtGoToButton EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 58 BY 1.42 BGCOLOR 7.
    DEFINE VARIABLE rGoTo         AS ROWID NO-UNDO.
    DEFINE VARIABLE iNumPedido    LIKE tt-pedido-compr.num-pedido INITIAL 0 LABEL "Pedido" VIEW-AS FILL-IN SIZE 12 BY .88 NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        iNumPedido        AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Pedido" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    
    ON  "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN iNumPedido.

        RUN setConstraintbypedido IN {&hDBOTable} (INPUT inumpedido) NO-ERROR.

        RUN openQuerybypedido IN {&hDBOTable} NO-ERROR.

        RUN goToKey IN {&hDBOTable} (INPUT iNumPedido).

        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Pedido":U).
            RETURN NO-APPLY.
        END.
 
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).

        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE iNumPedido btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    
    /*:T--- Verifica se o DBO j† est† inicializado ---
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "<DBOProgram>":U THEN DO:
        {btb/btb008za.i1 <DBOProgram> YES}
        {btb/btb008za.i2 <DBOProgram> '' {&hDBOTable}}
    END.
    
    RUN setConstraint<Description> IN {&hDBOTable} (<pamameters>) NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "<QueryName>":U) NO-ERROR.
    */
        


    IF NOT VALID-HANDLE({&hDBOTable}) THEN DO:
       if  not valid-handle(bo-pedido-compr) or
           bo-pedido-compr:type <> "PROCEDURE":U or
           bo-pedido-compr:file-name <> "esbo/boesin295.p" then
           run esbo/boesin295.p persistent set bo-pedido-compr.
    END.

    RUN setConstraintmain IN {&hDBOTable} (INPUT 0) NO-ERROR.

    RUN openQuerystatic IN {&hDBOTable} (INPUT "main") NO-ERROR.
      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida wMaintenance 
PROCEDURE pi-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH b-tt-ordem-cotacao:
    /* Embarcados n∆o podem sofrer alteraá∆o */
    IF  CAN-FIND(FIRST ordens-embarque
                 WHERE ordens-embarque.numero-ordem = b-tt-ordem-cotacao.numero-ordem) THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 17006,
                           INPUT 'Pedidos com ordem(ns) embarcada(s)' + '~~' + 'Pedidos com ordem(ns) embarcada(s) n∆o devem sofrer alteraá∆o.':U).
        RETURN "NOK".
    END. /* IF CAN-FIND(FIRST ordens-embarque */
END. /* FOR EACH b-tt-ordem-cotacao: */

/* Se encontrar alguma ordem que esteja diferente de confirmada, nada pode ser alterado no pedido */
IF  CAN-FIND(FIRST ordem-compra
             WHERE ordem-compra.num-pedido = tt-pedido-compr.num-pedido
             AND   ordem-compra.situacao <> 2
             AND   ordem-compra.situacao <> 4) THEN RETURN "NOK".

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraTTOrdemCotacao wMaintenance 
PROCEDURE piGeraTTOrdemCotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH tt-ordem-cotacao. DELETE tt-ordem-cotacao. END.

/* Se encontrar alguma ordem que esteja diferente de confirmada, nada pode ser alterado no pedido */
IF  CAN-FIND(FIRST ordem-compra
             WHERE ordem-compra.num-pedido = tt-pedido-compr.num-pedido
               AND ordem-compra.situacao <> 2
               AND ordem-compra.situacao <> 4) THEN do: 
    RUN utp/ut-msgs.p (INPUT "show":U, INPUT 15825, INPUT "Procedimento interrompido.":U + '~~' +
                                                          "Existem ordens neste pedido que possuem parcelas embarcadas ou recebidas, este pedido n∆o pode ter seu itiner†rio alterada.":U ).

    RETURN NO-APPLY.
END.

ordem_block:
FOR EACH  ordem-compra NO-LOCK 
    WHERE ordem-compra.num-pedido = tt-pedido-compr.num-pedido AND
          ordem-compra.situacao     = 2:
    FOR EACH  cotacao-item NO-LOCK
        WHERE cotacao-item.it-codigo    = ordem-compra.it-codigo
        AND   cotacao-item.numero-ordem = ordem-compra.numero-ordem
        AND   cotacao-item.cod-emitente = ordem-compra.cod-emitente:
        FIND FIRST tt-ordem-cotacao
             WHERE tt-ordem-cotacao.numero-ordem = cotacao-item.numero-ordem  
             AND   tt-ordem-cotacao.cod-emitente = cotacao-item.cod-emitente  
             AND   tt-ordem-cotacao.it-codigo    = cotacao-item.it-codigo     
             AND   tt-ordem-cotacao.seq-cotac    = cotacao-item.seq-cotac NO-ERROR.
        find first emitente-cex 
             where emitente-cex.cod-emitente = ordem-compra.cod-emitente no-lock no-error.
        IF NOT AVAIL emitente-cex THEN NEXT.
        IF AVAIL tt-ordem-cotacao THEN NEXT.

        /* Embarcados n∆o podem sofrer alteraá∆o */
        IF CAN-FIND(FIRST ordens-embarque
                    WHERE ordens-embarque.numero-ordem = cotacao-item.numero-ordem) THEN DO:

            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 15825, INPUT "Procedimento interrompido.":U + '~~' +
                                                                  "Existem ordens neste pedido que possuem parcelas embarcadas ou recebidas, este pedido n∆o pode ter seu itiner†rio alterada.":U ).

            LEAVE ordem_block.
        END. /* THEN DO: */

        CREATE tt-ordem-cotacao.
        ASSIGN tt-ordem-cotacao.numero-ordem  = cotacao-item.numero-ordem  
               tt-ordem-cotacao.cod-emitente  = cotacao-item.cod-emitente  
               tt-ordem-cotacao.it-codigo     = cotacao-item.it-codigo     
               tt-ordem-cotacao.seq-cotac     = cotacao-item.seq-cotac     
               tt-ordem-cotacao.class-fisc    = int(substr(cotacao-item.char-1,81,20)) /*string(substr(cotacao-item.char-1,23,10),"x(20)") /*c-class-fiscal*/        */
               tt-ordem-cotacao.mapa          = substr(cotacao-item.char-1,01,20) /*string(substr(cotacao-item.char-1,6,2),"x(20)") /*i-mapa cotacao*/          */ 
               tt-ordem-cotacao.ptBase        = substr(cotacao-item.char-1,41,20) /*string(substr(cotacao-item.char-1,11,5),"x(20)") /*i-cod-pto-contr*/        */ 
               tt-ordem-cotacao.AliqII        = substr(cotacao-item.char-1,61,20) /*string(substr(cotacao-item.char-1,17,6),"x(20)") /*de-aliquota-ii*/         */ 
               tt-ordem-cotacao.regime        = string(cotacao-item.regime-impot)         /*i-regime-importacao*/     
               tt-ordem-cotacao.cod-incoterm  = substr(cotacao-item.char-1,21,20) /*string(substr(cotacao-item.char-1,8,3),"x(20)") /*c-cod-incoterm*/          */ 
               tt-ordem-cotacao.itinerario    = cotacao-item.int-1.

        FOR FIRST itinerario NO-LOCK
            WHERE itinerario.cod-itiner = cotacao-item.int-1:
            ASSIGN tt-ordem-cotacao.descItiner = itinerario.descricao.
        END. /* FOR FIRST itinerario NO-LOCK */

        FOR FIRST pto-contr NO-LOCK
            WHERE pto-contr.cod-pto-contr = int(tt-ordem-cotacao.ptBase):
            ASSIGN tt-ordem-cotacao.descPtoControleBase = pto-contr.descricao.
        END. /* FOR FIRST pto-contr NO-LOCK */

        FOR FIRST processo-imp NO-LOCK
            WHERE processo-imp.num-pedido = tt-pedido-compr.num-pedido:

            IF  processo-imp.cod-estabel = tt-pedido-compr.cod-estabel
            THEN tt-ordem-cotacao.nr-proc-imp = processo-imp.nr-proc-imp.

        END. /* FOR FIRST processo-imp NO-LOCK */

        FOR FIRST b-pedido-compr NO-LOCK
            WHERE b-pedido-compr.num-pedido = tt-pedido-compr.num-pedido:

            ASSIGN tt-ordem-cotacao.cod-transp = b-pedido-compr.cod-transp
                   tt-ordem-cotacao.via-transp = IF b-pedido-compr.via-transp <> 0 
                                                 THEN b-pedido-compr.via-transp
                                                 ELSE 1.
        END. /* FOR FIRST b-pedido-compr */

    END. /* FOR EACH  cotacao-item NO-LOCK */
END. /* FOR EACH ordem-compra NO-LOCK */

{&OPEN-QUERY-brOrdemCotacao}
APPLY "U1" TO brOrdemCotacao IN FRAME fPage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTrocaFrame wMaintenance 
PROCEDURE piTrocaFrame :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM pTipoFramePri AS INT.

CASE pTipoFramePri:
    WHEN 1 THEN
    DO:
        HIDE FRAME fPage2.
        VIEW FRAME fPage1.
    END.
    WHEN 2 THEN
    DO:
        HIDE FRAME fPage1.
        VIEW FRAME fPage2.

        APPLY "LEAVE":U TO fiPtBase IN FRAME fPage2.
        APPLY "LEAVE":U TO fiCodItiner IN FRAME fPage2.
        APPLY "LEAVE":U TO i-cod-transportador IN FRAME fPage2.

    END.
END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

