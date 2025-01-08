&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttitem-tipo-loc NO-UNDO LIKE item-tipo-loc
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
{include/i-prgvrs.i ESCEP010A 2.04.00.000}

/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCEP010
&GLOBAL-DEFINE Version        1

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

&GLOBAL-DEFINE ttTable        ttitem-tipo-loc
&GLOBAL-DEFINE hDBOTable      boitem-tipo-loc
&GLOBAL-DEFINE DBOTable       item-tipo-loc

/* Parameters Definitions ---                                           */
DEF INPUT PARAM p-main AS HANDLE NO-UNDO.
DEF INPUT PARAM p-bo AS HANDLE NO-UNDO.
DEF INPUT PARAM p-acao AS CHAR NO-UNDO.
DEF INPUT PARAM p-rowid AS ROWID NO-UNDO.
/* Local Variable Definitions ---                                       */

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE VARIABLE hProgramZoom AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEF VAR l-implanta AS LOGICAL NO-UNDO.
{method/dbotterr.i}
{upc/btb910za-upc.i} /* Defini‡Æo do estabelecimento do usu rio */

DEF TEMP-TABLE rowerrorsext LIKE RowErrors.

DEF NEW GLOBAL SHARED VAR gs-hbrowse AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR gs-hbo AS HANDLE NO-UNDO.

DEF VAR {&hDBOTable} AS HANDLE NO-UNDO.
DEF VAR v-sequencia AS INTEGER NO-UNDO.

{&hDBOTable} = p-bo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttitem-tipo-loc deposito

/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define FIELDS-IN-QUERY-DEFAULT-FRAME ttitem-tipo-loc.cod-estabel ~
ttitem-tipo-loc.cod-depos ttitem-tipo-loc.it-codigo ~
ttitem-tipo-loc.cod-tipo ttitem-tipo-loc.sequencia ~
ttitem-tipo-loc.quantidade ttitem-tipo-loc.qtd-comp ~
ttitem-tipo-loc.local-entreposto ttitem-tipo-loc.qt-max-entreposto ~
ttitem-tipo-loc.qt-seg-entreposto ttitem-tipo-loc.compartilha ~
ttitem-tipo-loc.mistura 
&Scoped-define ENABLED-FIELDS-IN-QUERY-DEFAULT-FRAME ~
ttitem-tipo-loc.cod-estabel ttitem-tipo-loc.cod-depos ~
ttitem-tipo-loc.it-codigo ttitem-tipo-loc.cod-tipo ~
ttitem-tipo-loc.sequencia ttitem-tipo-loc.quantidade ~
ttitem-tipo-loc.qtd-comp ttitem-tipo-loc.local-entreposto ~
ttitem-tipo-loc.qt-max-entreposto ttitem-tipo-loc.qt-seg-entreposto ~
ttitem-tipo-loc.compartilha ttitem-tipo-loc.mistura 
&Scoped-define ENABLED-TABLES-IN-QUERY-DEFAULT-FRAME ttitem-tipo-loc
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-DEFAULT-FRAME ttitem-tipo-loc
&Scoped-define QUERY-STRING-DEFAULT-FRAME FOR EACH ttitem-tipo-loc SHARE-LOCK, ~
      EACH deposito WHERE TRUE /* Join to ttitem-tipo-loc incomplete */ SHARE-LOCK
&Scoped-define OPEN-QUERY-DEFAULT-FRAME OPEN QUERY DEFAULT-FRAME FOR EACH ttitem-tipo-loc SHARE-LOCK, ~
      EACH deposito WHERE TRUE /* Join to ttitem-tipo-loc incomplete */ SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-DEFAULT-FRAME ttitem-tipo-loc deposito
&Scoped-define FIRST-TABLE-IN-QUERY-DEFAULT-FRAME ttitem-tipo-loc
&Scoped-define SECOND-TABLE-IN-QUERY-DEFAULT-FRAME deposito


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttitem-tipo-loc.cod-estabel ~
ttitem-tipo-loc.cod-depos ttitem-tipo-loc.it-codigo ~
ttitem-tipo-loc.cod-tipo ttitem-tipo-loc.sequencia ~
ttitem-tipo-loc.quantidade ttitem-tipo-loc.qtd-comp ~
ttitem-tipo-loc.local-entreposto ttitem-tipo-loc.qt-max-entreposto ~
ttitem-tipo-loc.qt-seg-entreposto ttitem-tipo-loc.compartilha ~
ttitem-tipo-loc.mistura 
&Scoped-define ENABLED-TABLES ttitem-tipo-loc
&Scoped-define FIRST-ENABLED-TABLE ttitem-tipo-loc
&Scoped-Define ENABLED-OBJECTS btOK btSave btHelp fi-descricao btCancel ~
fi-nome RECT-2 RECT-3 rtKeys rtKeys-2 rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttitem-tipo-loc.cod-estabel ~
ttitem-tipo-loc.cod-depos ttitem-tipo-loc.it-codigo ~
ttitem-tipo-loc.cod-tipo ttitem-tipo-loc.sequencia ~
ttitem-tipo-loc.quantidade ttitem-tipo-loc.qtd-comp ~
ttitem-tipo-loc.local-entreposto ttitem-tipo-loc.qt-max-entreposto ~
ttitem-tipo-loc.qt-seg-entreposto ttitem-tipo-loc.compartilha ~
ttitem-tipo-loc.mistura 
&Scoped-define DISPLAYED-TABLES ttitem-tipo-loc
&Scoped-define FIRST-DISPLAYED-TABLE ttitem-tipo-loc
&Scoped-Define DISPLAYED-OBJECTS fi-descricao fi-nome fi-desc-item 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp  NO-FOCUS
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 1.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 1.5.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.5.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY DEFAULT-FRAME FOR 
      ttitem-tipo-loc, 
      deposito SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     ttitem-tipo-loc.cod-estabel AT ROW 1.25 COL 15 COLON-ALIGNED
          LABEL "Estabelecimento"
          VIEW-AS FILL-IN 
          SIZE 6 BY .79
     ttitem-tipo-loc.cod-depos AT ROW 2.21 COL 15 COLON-ALIGNED
          LABEL "Dep¢sito"
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     ttitem-tipo-loc.it-codigo AT ROW 3.25 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     ttitem-tipo-loc.cod-tipo AT ROW 4.29 COL 15 COLON-ALIGNED
          LABEL "Tipo"
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     ttitem-tipo-loc.sequencia AT ROW 5.29 COL 15 COLON-ALIGNED
          LABEL "Seqˆncia"
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     ttitem-tipo-loc.quantidade AT ROW 7.04 COL 15 COLON-ALIGNED FORMAT ">>>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     ttitem-tipo-loc.qtd-comp AT ROW 8 COL 15 COLON-ALIGNED
          LABEL "Quant Compartilhada" FORMAT ">>>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     ttitem-tipo-loc.local-entreposto AT ROW 7 COL 65 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     ttitem-tipo-loc.qt-max-entreposto AT ROW 8 COL 65 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .88
     ttitem-tipo-loc.qt-seg-entreposto AT ROW 9 COL 65 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .88
     ttitem-tipo-loc.compartilha AT ROW 10.67 COL 17 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sim", yes,
"NÆo", no
          SIZE 22 BY .88
     ttitem-tipo-loc.mistura AT ROW 10.58 COL 55.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sim", yes,
"NÆo", no
          SIZE 22 BY .88
     btOK AT ROW 12.5 COL 2
     btSave AT ROW 12.5 COL 13
     btHelp AT ROW 12.5 COL 80.29
     fi-descricao AT ROW 4.29 COL 20 COLON-ALIGNED HELP
          "Descri‡Æo do Dep¢sito" NO-LABEL NO-TAB-STOP 
     btCancel AT ROW 12.5 COL 24
     fi-nome AT ROW 2.21 COL 20 COLON-ALIGNED HELP
          "Descri‡Æo do Dep¢sito" NO-LABEL NO-TAB-STOP 
     fi-desc-item AT ROW 3.25 COL 32.72 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     "Compartilha:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 10 COL 7
     "Mistura:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 9.92 COL 47
     RECT-2 AT ROW 10.29 COL 3
     RECT-3 AT ROW 10.29 COL 43
     rtKeys AT ROW 1 COL 1
     rtKeys-2 AT ROW 6.75 COL 1
     rtToolBar AT ROW 12.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 12.83
         FONT 1
         CANCEL-BUTTON btCancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttitem-tipo-loc T "?" NO-UNDO mgesp item-tipo-loc
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert window title>"
         HEIGHT             = 12.83
         WIDTH              = 90
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 90
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN ttitem-tipo-loc.cod-depos IN FRAME DEFAULT-FRAME
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttitem-tipo-loc.cod-estabel IN FRAME DEFAULT-FRAME
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttitem-tipo-loc.cod-tipo IN FRAME DEFAULT-FRAME
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       fi-desc-item:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       fi-descricao:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       fi-nome:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN ttitem-tipo-loc.qtd-comp IN FRAME DEFAULT-FRAME
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN ttitem-tipo-loc.quantidade IN FRAME DEFAULT-FRAME
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN ttitem-tipo-loc.sequencia IN FRAME DEFAULT-FRAME
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
     _TblList          = "Temp-Tables.ttitem-tipo-loc,mgcad.deposito WHERE Temp-Tables.ttitem-tipo-loc ..."
     _Query            is OPENED
*/  /* FRAME DEFAULT-FRAME */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel C-Win
ON CHOOSE OF btCancel IN FRAME DEFAULT-FRAME /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp C-Win
ON CHOOSE OF btHelp IN FRAME DEFAULT-FRAME /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK C-Win
ON CHOOSE OF btOK IN FRAME DEFAULT-FRAME /* OK */
DO:
    RUN saveRecord.
    IF RETURN-VALUE NE "nok" THEN APPLY "Close" TO THIS-PROCEDURE.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave C-Win
ON CHOOSE OF btSave IN FRAME DEFAULT-FRAME /* Salvar */
DO:
  RUN saveRecord.
  IF RETURN-VALUE NE "nok" THEN APPLY "entry" TO ttitem-tipo-loc.cod-depos.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttitem-tipo-loc.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-tipo-loc.cod-depos C-Win
ON LEAVE OF ttitem-tipo-loc.cod-depos IN FRAME DEFAULT-FRAME /* Dep¢sito */
DO:
    {include/leave.i &tabela=deposito
                     &atributo-ref=nome
                     &variavel-ref=fi-nome
                     &where="deposito.cod-dep = ttitem-tipo-loc.cod-dep:screen-value in frame {&frame-name}"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-tipo-loc.cod-depos C-Win
ON MOUSE-SELECT-DBLCLICK OF ttitem-tipo-loc.cod-depos IN FRAME DEFAULT-FRAME /* Dep¢sito */
OR F5 OF ttitem-tipo-loc.cod-depos IN FRAME {&frame-name} DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in084"
                       &campo="ttitem-tipo-loc.cod-depos"
                       &campozoom="cod-depos"
                       &frame="{&frame-name}"
                       &campo2="fi-nome"
                       &campozoom2="nome"
                       &frame2="{&frame-name}"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttitem-tipo-loc.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-tipo-loc.cod-estabel C-Win
ON MOUSE-SELECT-DBLCLICK OF ttitem-tipo-loc.cod-estabel IN FRAME DEFAULT-FRAME /* Estabelecimento */
OR F5 OF ttitem-tipo-loc.cod-estabel IN FRAME {&frame-name} DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01ad107"
                       &campo="ttitem-tipo-loc.cod-estabel"
                       &campozoom="cod-estabel"
                       &frame="{&frame-name}"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttitem-tipo-loc.cod-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-tipo-loc.cod-tipo C-Win
ON LEAVE OF ttitem-tipo-loc.cod-tipo IN FRAME DEFAULT-FRAME /* Tipo */
DO:
    {include/leave.i &tabela=tipo-local
                     &atributo-ref=descricao
                     &variavel-ref=fi-descricao
                     &where="tipo-local.cod-estabel = ttitem-tipo-loc.cod-estabel and tipo-local.cod-tipo = input frame {&frame-name} ttitem-tipo-loc.cod-tipo"}
  
    IF p-rowid = ? THEN DO:
        RUN getNextSequence IN p-bo (INPUT FRAME {&FRAME-NAME} ttitem-tipo-loc.it-codigo,
                                     INPUT FRAME {&FRAME-NAME} ttitem-tipo-loc.cod-estabel,        
                                     INPUT FRAME {&FRAME-NAME} ttitem-tipo-loc.cod-depos,
                                     INPUT FRAME {&FRAME-NAME} ttitem-tipo-loc.cod-tipo,
                                     OUTPUT v-sequencia).
        DISP v-sequencia @ ttitem-tipo-loc.sequencia 
             9999999 @ ttitem-tipo-loc.quantidade
             WITH FRAME {&FRAME-NAME}.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-tipo-loc.cod-tipo C-Win
ON MOUSE-SELECT-DBLCLICK OF ttitem-tipo-loc.cod-tipo IN FRAME DEFAULT-FRAME /* Tipo */
OR F5 OF ttitem-tipo-loc.cod-tipo IN FRAME {&frame-name} DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es187"
                         &FieldZoom1="cod-tipo"
                         &FieldScreen1="ttitem-tipo-loc.cod-tipo"
                         &Frame1="{&FRAME-NAME}"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-descricao"
                         &Frame2="{&FRAME-NAME}"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttitem-tipo-loc.compartilha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-tipo-loc.compartilha C-Win
ON ANY-PRINTABLE OF ttitem-tipo-loc.compartilha IN FRAME DEFAULT-FRAME
DO:
  CASE caps(KEYLABEL(LASTKEY)):
      WHEN "S" THEN ttitem-tipo-loc.compartilha:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "yes".
      WHEN "N" THEN ttitem-tipo-loc.compartilha:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "no".
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttitem-tipo-loc.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-tipo-loc.it-codigo C-Win
ON F5 OF ttitem-tipo-loc.it-codigo IN FRAME DEFAULT-FRAME /* Item */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in172.r"
                       &campo="ttitem-tipo-loc.it-codigo"    
                       &campo2="fi-desc-item"
                       &campozoom="it-codigo"
                       &campozoom2="desc-item"
                       &frame="{&frame-name}"
                       &frame2="{&frame-name}"}

    IF VALID-HANDLE(wh-pesquisa) THEN
        WAIT-FOR CLOSE OF wh-pesquisa.

    APPLY "entry" TO ttitem-tipo-loc.it-codigo IN FRAME {&frame-name}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-tipo-loc.it-codigo C-Win
ON LEAVE OF ttitem-tipo-loc.it-codigo IN FRAME DEFAULT-FRAME /* Item */
DO:
    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=fi-desc-item
                     &where="item.it-codigo = ttitem-tipo-loc.it-codigo:screen-value in frame {&frame-name}"}
                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-tipo-loc.it-codigo C-Win
ON MOUSE-SELECT-DBLCLICK OF ttitem-tipo-loc.it-codigo IN FRAME DEFAULT-FRAME /* Item */
DO:
    APPLY "f5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttitem-tipo-loc.local-entreposto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-tipo-loc.local-entreposto C-Win
ON LEAVE OF ttitem-tipo-loc.local-entreposto IN FRAME DEFAULT-FRAME /* Entreposto */
DO:
    IF INPUT FRAME {&FRAME-NAME} ttitem-tipo-loc.local-entreposto = "" THEN
        ASSIGN ttitem-tipo-loc.qt-max-entreposto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0"
               ttitem-tipo-loc.qt-seg-entreposto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0"
               ttitem-tipo-loc.qt-max-entreposto:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               ttitem-tipo-loc.qt-seg-entreposto:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    ELSE DO:
        ASSIGN ttitem-tipo-loc.qt-max-entreposto:SENSITIVE IN FRAME {&FRAME-NAME} = YES
               ttitem-tipo-loc.qt-seg-entreposto:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttitem-tipo-loc.mistura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-tipo-loc.mistura C-Win
ON ANY-PRINTABLE OF ttitem-tipo-loc.mistura IN FRAME DEFAULT-FRAME
DO:
      CASE caps(KEYLABEL(LASTKEY)):
          WHEN "S" THEN ttitem-tipo-loc.mistura:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "yes".
          WHEN "N" THEN ttitem-tipo-loc.mistura:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "no".
      END CASE.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
ttitem-tipo-loc.cod-depos:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME {&frame-name}.
ttitem-tipo-loc.it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME {&frame-name}.
ttitem-tipo-loc.cod-tipo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME {&frame-name}.
ttitem-tipo-loc.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME {&frame-name}.
ttitem-tipo-loc.compartilha:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "no".
ttitem-tipo-loc.mistura:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "no".
FOR FIRST prog_dtsul FIELDS (nom_prog_dtsul_menu) NO-LOCK
    WHERE prog_dtsul.cod_prog_dtsul = "{&Program}":
    ASSIGN C-Win:TITLE = SUBSTITUTE("&1 - &2 - &3",
                                             trim(prog_dtsul.nom_prog_dtsul_menu),
                                             "ESCEP010A", "{&Version}").
END.
/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  
  assign ttitem-tipo-loc.cod-estabel:screen-value in frame {&frame-name} = v_cod_estab_usuar.
  
  IF p-rowid NE ? THEN DO:
      RUN repositionRecord IN p-bo (INPUT p-rowid).
      RUN getRecord IN p-bo (OUTPUT TABLE ttitem-tipo-loc).
      FOR FIRST ttitem-tipo-loc:
          DISP ttitem-tipo-loc.cod-estabel
               ttitem-tipo-loc.cod-depos 
               ttitem-tipo-loc.cod-tipo 
               ttitem-tipo-loc.compartilha 
               ttitem-tipo-loc.it-codigo 
               ttitem-tipo-loc.mistura 
               ttitem-tipo-loc.qtd-comp 
               ttitem-tipo-loc.quantidade 
               ttitem-tipo-loc.local-entreposto
               ttitem-tipo-loc.qt-max-entreposto 
               ttitem-tipo-loc.qt-seg-entreposto
               ttitem-tipo-loc.sequencia WITH FRAME {&FRAME-NAME}.
          APPLY "leave" TO ttitem-tipo-loc.cod-depos IN FRAME {&FRAME-NAME}.
          APPLY "leave" TO ttitem-tipo-loc.it-codigo IN FRAME {&FRAME-NAME}.
          APPLY "leave" TO ttitem-tipo-loc.cod-tipo IN FRAME {&FRAME-NAME}.
          
          IF p-acao = "update" THEN DO:
              DISABLE ttitem-tipo-loc.cod-depos 
                      ttitem-tipo-loc.cod-tipo 
                      ttitem-tipo-loc.it-codigo 
                      ttitem-tipo-loc.sequencia WITH FRAME {&FRAME-NAME}.
              APPLY "entry" TO ttitem-tipo-loc.quantidade IN FRAME {&FRAME-NAME}.
          END.
          ELSE APPLY "entry" TO ttitem-tipo-loc.cod-depos IN FRAME {&FRAME-NAME}.
      END.
      
  END.
  ELSE APPLY "entry" TO ttitem-tipo-loc.cod-depos IN FRAME {&FRAME-NAME}.

  IF ttitem-tipo-loc.local-entreposto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN
        ASSIGN ttitem-tipo-loc.qt-max-entreposto:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               ttitem-tipo-loc.qt-seg-entreposto:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  ELSE
        ASSIGN ttitem-tipo-loc.qt-max-entreposto:SENSITIVE IN FRAME {&FRAME-NAME} = YES
               ttitem-tipo-loc.qt-seg-entreposto:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    
  

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/

  {&OPEN-QUERY-DEFAULT-FRAME}
  GET FIRST DEFAULT-FRAME.
  DISPLAY fi-descricao fi-nome fi-desc-item 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  IF AVAILABLE ttitem-tipo-loc THEN 
    DISPLAY ttitem-tipo-loc.cod-estabel ttitem-tipo-loc.cod-depos 
          ttitem-tipo-loc.it-codigo ttitem-tipo-loc.cod-tipo 
          ttitem-tipo-loc.sequencia ttitem-tipo-loc.quantidade 
          ttitem-tipo-loc.qtd-comp ttitem-tipo-loc.local-entreposto 
          ttitem-tipo-loc.qt-max-entreposto ttitem-tipo-loc.qt-seg-entreposto 
          ttitem-tipo-loc.compartilha ttitem-tipo-loc.mistura 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE ttitem-tipo-loc.cod-estabel ttitem-tipo-loc.cod-depos 
         ttitem-tipo-loc.it-codigo ttitem-tipo-loc.cod-tipo 
         ttitem-tipo-loc.sequencia ttitem-tipo-loc.quantidade 
         ttitem-tipo-loc.qtd-comp ttitem-tipo-loc.local-entreposto 
         ttitem-tipo-loc.qt-max-entreposto ttitem-tipo-loc.qt-seg-entreposto 
         ttitem-tipo-loc.compartilha ttitem-tipo-loc.mistura btOK btSave btHelp 
         fi-descricao btCancel fi-nome RECT-2 RECT-3 rtKeys rtKeys-2 rtToolBar 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveRecord C-Win 
PROCEDURE saveRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR hShowMsg AS HANDLE NO-UNDO.
DEF VAR r-rowid AS ROWID NO-UNDO.

IF p-acao = "update" THEN
    ASSIGN r-rowid = ttitem-tipo-loc.r-rowid.

EMPTY TEMP-TABLE ttitem-tipo-loc.

CREATE ttitem-tipo-loc.
ASSIGN ttitem-tipo-loc.it-codigo         = INPUT FRAME {&FRAME-NAME} ttitem-tipo-loc.it-codigo
       ttitem-tipo-loc.cod-estabel       = INPUT FRAME {&FRAME-NAME} ttitem-tipo-loc.cod-estabel
       ttitem-tipo-loc.cod-depos         = INPUT FRAME {&FRAME-NAME} ttitem-tipo-loc.cod-depos
       ttitem-tipo-loc.cod-tipo          = INPUT FRAME {&FRAME-NAME} ttitem-tipo-loc.cod-tipo
       ttitem-tipo-loc.quantidade        = INPUT FRAME {&FRAME-NAME} ttitem-tipo-loc.quantidade
       ttitem-tipo-loc.mistura           = INPUT FRAME {&FRAME-NAME} ttitem-tipo-loc.mistura
       ttitem-tipo-loc.compartilha       = INPUT FRAME {&FRAME-NAME} ttitem-tipo-loc.compartilha
       ttitem-tipo-loc.qtd-comp          = INPUT FRAME {&FRAME-NAME} ttitem-tipo-loc.qtd-comp
       ttitem-tipo-loc.sequencia         = INPUT FRAME {&FRAME-NAME} ttitem-tipo-loc.sequencia
       ttitem-tipo-loc.qt-max-entreposto = INPUT FRAME {&FRAME-NAME} ttitem-tipo-loc.qt-max-entreposto
       ttitem-tipo-loc.qt-seg-entreposto = INPUT FRAME {&FRAME-NAME} ttitem-tipo-loc.qt-seg-entreposto
       ttitem-tipo-loc.local-entreposto  = INPUT FRAME {&FRAME-NAME} ttitem-tipo-loc.local-entreposto
       ttitem-tipo-loc.r-rowid           = r-rowid.

RUN emptyRowErrors IN {&hDBOTable} NO-ERROR.        

RUN setrecord IN {&hDBOTable} (INPUT TABLE ttitem-tipo-loc).


IF p-rowid NE ? AND p-acao = "update" THEN 
    RUN updateRecord IN {&hDBOTable}.                        
ELSE RUN createRecord IN {&hDBOTable}. 


RUN getrowerrors IN {&hDBOTable} (OUTPUT TABLE rowerrors).
FOR FIRST rowerrorsext:
    CREATE RowErrors.
    BUFFER-COPY rowerrorsext TO RowErrors.
END.
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
    {method/ShowMessage.i1}.
    {method/ShowMessage.i2 &Modal="YES"}.
    {method/ShowMessage.i3}.
    RETURN "NOK".
END.

IF VALID-HANDLE(p-main) THEN do:
    RUN goToKey IN {&hDBOTable} (INPUT ttitem-tipo-loc.it-codigo,
                                 INPUT ttitem-tipo-loc.cod-estabel,
                                 INPUT ttitem-tipo-loc.cod-depos,
                                 INPUT ttitem-tipo-loc.sequencia,
                                 INPUT ttitem-tipo-loc.cod-tipo).
    RUN getRowid IN {&hDBOTable} (OUTPUT r-rowid).
    IF p-rowid NE ? THEN
        RUN updateRow IN p-main (INPUT r-rowid).
    ELSE 
        RUN insertNewRow IN p-main (INPUT r-rowid).

      

END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

