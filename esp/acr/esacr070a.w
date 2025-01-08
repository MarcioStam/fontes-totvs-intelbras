&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttint-cond-pag-cli NO-UNDO LIKE int-cond-pag-cli
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESACR070A 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESACR070A
&GLOBAL-DEFINE Version           1

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       0

&GLOBAL-DEFINE FolderLabels      Dados

&GLOBAL-DEFINE ttTable           ttint-cond-pag-cli
&GLOBAL-DEFINE hDBOTable         HDBOttint-cond-pag-cli
&GLOBAL-DEFINE DBOTable          int-cond-pag-cli

&GLOBAL-DEFINE page0KeyFields    ttint-cond-pag-cli.cod-emitente
&GLOBAL-DEFINE page0Fields       ttint-cond-pag-cli.cod-emitente c-descricao tg-grupo tg-prazo rs-tipo 
/* &GLOBAL-DEFINE page1Fields       ttponto-programa.descricao ttponto-programa.tipo */


/* Parameters Definitions ---                                           */

DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR lg-esacr070-acao AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttint-cond-pag-cli.cod-emitente 
&Scoped-define ENABLED-TABLES ttint-cond-pag-cli
&Scoped-define FIRST-ENABLED-TABLE ttint-cond-pag-cli
&Scoped-Define ENABLED-OBJECTS RECT-3 rtToolBar RECT-12 RECT-13 c-descricao ~
tg-grupo tg-prazo rs-tipo btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS ttint-cond-pag-cli.cod-emitente 
&Scoped-define DISPLAYED-TABLES ttint-cond-pag-cli
&Scoped-define FIRST-DISPLAYED-TABLE ttint-cond-pag-cli
&Scoped-Define DISPLAYED-OBJECTS c-descricao tg-grupo tg-prazo rs-tipo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE tg-dia-1 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-10 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-11 AS LOGICAL INITIAL no 
     LABEL "11" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-12 AS LOGICAL INITIAL no 
     LABEL "12" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-13 AS LOGICAL INITIAL no 
     LABEL "13" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-14 AS LOGICAL INITIAL no 
     LABEL "14" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-15 AS LOGICAL INITIAL no 
     LABEL "15" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-16 AS LOGICAL INITIAL no 
     LABEL "16" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-17 AS LOGICAL INITIAL no 
     LABEL "17" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-18 AS LOGICAL INITIAL no 
     LABEL "18" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-19 AS LOGICAL INITIAL no 
     LABEL "19" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-2 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-20 AS LOGICAL INITIAL no 
     LABEL "20" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-21 AS LOGICAL INITIAL no 
     LABEL "21" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-22 AS LOGICAL INITIAL no 
     LABEL "22" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-23 AS LOGICAL INITIAL no 
     LABEL "23" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-24 AS LOGICAL INITIAL no 
     LABEL "24" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-25 AS LOGICAL INITIAL no 
     LABEL "25" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-26 AS LOGICAL INITIAL no 
     LABEL "26" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-27 AS LOGICAL INITIAL no 
     LABEL "27" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-28 AS LOGICAL INITIAL no 
     LABEL "28" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-29 AS LOGICAL INITIAL no 
     LABEL "29" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-3 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-30 AS LOGICAL INITIAL no 
     LABEL "30" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-31 AS LOGICAL INITIAL no 
     LABEL "31" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-4 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-5 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-6 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-7 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-8 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-9 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.43 BY .88 NO-UNDO.

DEFINE VARIABLE rs-tipo AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Semana", 1,
"Dias Mˆs", 2,
"Nenhum", 3
     SIZE 9.14 BY 2.25 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 114 BY 5.5.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 109 BY 2.75.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 114 BY 1.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 115 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-grupo AS LOGICAL INITIAL no 
     LABEL "Utilizar Grupo Econ“mico" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-prazo AS LOGICAL INITIAL no 
     LABEL "Prazo DDE" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-1 AS LOGICAL INITIAL no 
     LABEL "Segunda" 
     VIEW-AS TOGGLE-BOX
     SIZE 9 BY .83 NO-UNDO.

DEFINE VARIABLE tg-2 AS LOGICAL INITIAL no 
     LABEL "Ter‡a" 
     VIEW-AS TOGGLE-BOX
     SIZE 7 BY .83 NO-UNDO.

DEFINE VARIABLE tg-3 AS LOGICAL INITIAL no 
     LABEL "Quarta" 
     VIEW-AS TOGGLE-BOX
     SIZE 8 BY .83 NO-UNDO.

DEFINE VARIABLE tg-4 AS LOGICAL INITIAL no 
     LABEL "Quinta" 
     VIEW-AS TOGGLE-BOX
     SIZE 8 BY .83 NO-UNDO.

DEFINE VARIABLE tg-5 AS LOGICAL INITIAL no 
     LABEL "Sexta" 
     VIEW-AS TOGGLE-BOX
     SIZE 8 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttint-cond-pag-cli.cod-emitente AT ROW 1.67 COL 8.14 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-descricao AT ROW 1.67 COL 18.57 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     tg-grupo AT ROW 1.71 COL 71.14 WIDGET-ID 12
     tg-prazo AT ROW 3.75 COL 4 WIDGET-ID 176
     rs-tipo AT ROW 5.17 COL 4.86 NO-LABEL WIDGET-ID 168
     btOK AT ROW 9.5 COL 1.72
     btSave AT ROW 9.5 COL 12.72
     btCancel AT ROW 9.5 COL 23.72
     btHelp AT ROW 9.5 COL 104.43
     RECT-3 AT ROW 1.25 COL 2
     rtToolBar AT ROW 9.29 COL 1
     RECT-12 AT ROW 3.46 COL 2 WIDGET-ID 166
     RECT-13 AT ROW 4.92 COL 4 WIDGET-ID 174
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 116 BY 10.17
         FONT 1.

DEFINE FRAME fSemana
     tg-1 AT ROW 1.5 COL 3 WIDGET-ID 20
     tg-2 AT ROW 1.5 COL 14 WIDGET-ID 22
     tg-3 AT ROW 1.5 COL 22.57 WIDGET-ID 24
     tg-4 AT ROW 1.5 COL 32 WIDGET-ID 26
     tg-5 AT ROW 1.5 COL 42 WIDGET-ID 28
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 17.29 ROW 5.46
         SIZE 52 BY 1.75
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fMes
     tg-dia-1 AT ROW 1.83 COL 2 WIDGET-ID 30
     tg-dia-2 AT ROW 1.83 COL 5 WIDGET-ID 34
     tg-dia-3 AT ROW 1.83 COL 8 WIDGET-ID 38
     tg-dia-4 AT ROW 1.83 COL 11 WIDGET-ID 40
     tg-dia-5 AT ROW 1.83 COL 14 WIDGET-ID 42
     tg-dia-6 AT ROW 1.83 COL 17 WIDGET-ID 44
     tg-dia-7 AT ROW 1.83 COL 20 WIDGET-ID 46
     tg-dia-8 AT ROW 1.83 COL 23 WIDGET-ID 52
     tg-dia-9 AT ROW 1.83 COL 26 WIDGET-ID 54
     tg-dia-10 AT ROW 1.83 COL 29 WIDGET-ID 56
     tg-dia-11 AT ROW 1.83 COL 32 WIDGET-ID 58
     tg-dia-12 AT ROW 1.83 COL 35 WIDGET-ID 60
     tg-dia-13 AT ROW 1.83 COL 38 WIDGET-ID 48
     tg-dia-14 AT ROW 1.83 COL 41 WIDGET-ID 50
     tg-dia-15 AT ROW 1.83 COL 44 WIDGET-ID 72
     tg-dia-16 AT ROW 1.83 COL 47 WIDGET-ID 74
     tg-dia-17 AT ROW 1.83 COL 50 WIDGET-ID 62
     tg-dia-18 AT ROW 1.83 COL 53 WIDGET-ID 64
     tg-dia-19 AT ROW 1.83 COL 56 WIDGET-ID 66
     tg-dia-20 AT ROW 1.83 COL 59 WIDGET-ID 68
     tg-dia-21 AT ROW 1.83 COL 62 WIDGET-ID 70
     tg-dia-22 AT ROW 1.83 COL 65 WIDGET-ID 76
     tg-dia-23 AT ROW 1.83 COL 68 WIDGET-ID 78
     tg-dia-24 AT ROW 1.83 COL 71 WIDGET-ID 80
     tg-dia-25 AT ROW 1.83 COL 74 WIDGET-ID 82
     tg-dia-26 AT ROW 1.83 COL 77 WIDGET-ID 84
     tg-dia-27 AT ROW 1.83 COL 80 WIDGET-ID 86
     tg-dia-28 AT ROW 1.83 COL 83 WIDGET-ID 88
     tg-dia-29 AT ROW 1.83 COL 86 WIDGET-ID 90
     tg-dia-30 AT ROW 1.83 COL 88.72 WIDGET-ID 92
     tg-dia-31 AT ROW 1.83 COL 91.43 WIDGET-ID 94
     "03" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 8 WIDGET-ID 106
     "20" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 59 WIDGET-ID 130
     "25" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 74 WIDGET-ID 160
     "24" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 71 WIDGET-ID 158
     "31" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 91.43 WIDGET-ID 162
     "07" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 20 WIDGET-ID 114
     "08" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 23 WIDGET-ID 116
     "05" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 14 WIDGET-ID 110
     "04" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 11 WIDGET-ID 108
     "16" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 47 WIDGET-ID 122
     "17" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 50 WIDGET-ID 124
     "18" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 53 WIDGET-ID 126
     "15" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 44 WIDGET-ID 140
     "26" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 77 WIDGET-ID 142
     "27" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 80 WIDGET-ID 144
     "28" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 83 WIDGET-ID 146
     "29" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 86 WIDGET-ID 148
     "30" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 88.72 WIDGET-ID 150
     "21" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 62 WIDGET-ID 152
     "22" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 65 WIDGET-ID 154
     "23" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 68 WIDGET-ID 156
     "13" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 38 WIDGET-ID 136
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 17.29 ROW 5.46
         SIZE 94 BY 1.75
         FONT 1 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMes
     "19" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 56 WIDGET-ID 128
     "12" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 35 WIDGET-ID 134
     "01" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 2 WIDGET-ID 100
     "14" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 41 WIDGET-ID 138
     "09" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 26 WIDGET-ID 118
     "10" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 29 WIDGET-ID 120
     "11" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 32 WIDGET-ID 132
     "06" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 17 WIDGET-ID 112
     "02" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 5 WIDGET-ID 104
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 17.29 ROW 5.46
         SIZE 94 BY 1.75
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttint-cond-pag-cli T "?" NO-UNDO mgesp int-cond-pag-cli
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 10.17
         WIDTH              = 116.29
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 195.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fMes:FRAME = FRAME fpage0:HANDLE
       FRAME fSemana:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fMes
                                                                        */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME UNDERLINE                                                 */
ASSIGN 
       c-descricao:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FRAME fSemana
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:

    RUN pi-grava-vencto.
    RUN pi-valida-informacao.
    IF RETURN-VALUE <> "OK" THEN
        RETURN NO-APPLY.

    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:

    RUN pi-grava-vencto.
    RUN pi-valida-informacao.
    IF RETURN-VALUE <> "OK" THEN
        RETURN NO-APPLY.

    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttint-cond-pag-cli.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-cond-pag-cli.cod-emitente wMaintenanceNoNavigation
ON LEAVE OF ttint-cond-pag-cli.cod-emitente IN FRAME fpage0 /* Cliente */
DO:
     FIND emitente NO-LOCK
         WHERE emitente.cod-emitente = INT(ttint-cond-pag-cli.cod-emitente:SCREEN-VALUE IN FRAME fpage0) 
            NO-ERROR.

     IF  AVAIL emitente THEN
         ASSIGN c-descricao:SCREEN-VALUE IN FRAME fpage0 = emitente.nome-emit.
     ELSE
         ASSIGN c-descricao:SCREEN-VALUE IN FRAME fpage0 = "NÆo encontrado...".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo wMaintenanceNoNavigation
ON VALUE-CHANGED OF rs-tipo IN FRAME fpage0
DO:
    RUN pi-mostra-frames (int(rs-tipo:SCREEN-VALUE IN FRAME fpage0)).
    RUN pi-habilita-frames.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/MainBlock.i}
/*                                                                           */
/* RUN pi-carrega-campos.                                                    */
/*                                                                           */
/* IF  AVAIL ttint-cond-pag-cli AND ttint-cond-pag-cli.vencto-fixo <> 0 THEN */
/*     RUN pi-mostra-frames (INPUT ttint-cond-pag-cli.vencto-fixo).          */
/* ELSE DO:                                                                  */
/*     ASSIGN rs-tipo:SCREEN-VALUE IN FRAME fpage0 = "3".                    */
/*     RUN pi-mostra-frames (INPUT 3).                                       */
/* END.                                                                      */
/*                                                                           */
/* APPLY "value-changed" TO rs-tipo IN FRAME fpage0.                         */
/*                                                                           */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterdisplayfields wMaintenanceNoNavigation 
PROCEDURE afterdisplayfields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN pi-carrega-campos.

IF  AVAIL ttint-cond-pag-cli AND ttint-cond-pag-cli.vencto-fixo <> 0 THEN DO:
    RUN pi-mostra-frames (INPUT ttint-cond-pag-cli.vencto-fixo).
    
    APPLY "value-changed" TO rs-tipo IN FRAME fpage0.
    
    APPLY "leave" TO ttint-cond-pag-cli.cod-emitente IN FRAME fpage0.
END.
ELSE DO:
    ASSIGN rs-tipo:SCREEN-VALUE IN FRAME fpage0 = "3".
    RUN pi-mostra-frames (INPUT 3).
END.

CASE lg-esacr070-acao:
    WHEN "Inclui" OR WHEN "Copia" THEN
        ASSIGN ttint-cond-pag-cli.cod-emitente:SENSITIVE IN FRAME fpage0 = YES.
    WHEN "Modifica" THEN
        ASSIGN ttint-cond-pag-cli.cod-emitente:SENSITIVE IN FRAME fpage0 = NO.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
RUN pi-carrega-campos.

IF  AVAIL ttint-cond-pag-cli AND ttint-cond-pag-cli.vencto-fixo <> 0 THEN
    RUN pi-mostra-frames (INPUT ttint-cond-pag-cli.vencto-fixo).
ELSE DO:
    ASSIGN rs-tipo:SCREEN-VALUE IN FRAME fpage0 = "3".
    RUN pi-mostra-frames (INPUT 3).
END.

APPLY "leave" TO ttint-cond-pag-cli.cod-emitente IN FRAME fpage0.

CASE lg-esacr070-acao:
    WHEN "Inclui" OR WHEN "Copia" THEN
        ASSIGN ttint-cond-pag-cli.cod-emitente:SENSITIVE IN FRAME fpage0 = YES.
    WHEN "Modifica" THEN
        ASSIGN ttint-cond-pag-cli.cod-emitente:SENSITIVE IN FRAME fpage0 = NO.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-campos wMaintenanceNoNavigation 
PROCEDURE pi-carrega-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF  NOT AVAIL ttint-cond-pag-cli 
    OR  (AVAIL ttint-cond-pag-cli AND ttint-cond-pag-cli.vencto-fixo = 0) THEN
        RETURN "OK".

    DO WITH FRAME fpage0:
        
        ASSIGN tg-grupo:CHECKED     = ttint-cond-pag-cli.grupo-econ
               tg-prazo:CHECKED     = ttint-cond-pag-cli.prazo-DDE
               rs-tipo:SCREEN-VALUE = string(ttint-cond-pag-cli.vencto-fixo).

        CASE ttint-cond-pag-cli.vencto-fixo:
            WHEN 1 THEN DO:
                ASSIGN tg-1:CHECKED IN FRAME fSemana  = ttint-cond-pag-cli.semana[1]  
                       tg-2:CHECKED IN FRAME fSemana  = ttint-cond-pag-cli.semana[2]  
                       tg-3:CHECKED IN FRAME fSemana  = ttint-cond-pag-cli.semana[3]  
                       tg-4:CHECKED IN FRAME fSemana  = ttint-cond-pag-cli.semana[4]  
                       tg-5:CHECKED IN FRAME fSemana  = ttint-cond-pag-cli.semana[5].

            END.
            WHEN 2 THEN DO:
                ASSIGN tg-dia-1:CHECKED IN FRAME fMes  = ttint-cond-pag-cli.mes[1]  
                       tg-dia-2:CHECKED IN FRAME fMes  = ttint-cond-pag-cli.mes[2]  
                       tg-dia-3:CHECKED IN FRAME fMes  = ttint-cond-pag-cli.mes[3]  
                       tg-dia-4:CHECKED IN FRAME fMes  = ttint-cond-pag-cli.mes[4]  
                       tg-dia-5:CHECKED IN FRAME fMes  = ttint-cond-pag-cli.mes[5]  
                       tg-dia-6:CHECKED IN FRAME fMes  = ttint-cond-pag-cli.mes[6]  
                       tg-dia-7:CHECKED IN FRAME fMes  = ttint-cond-pag-cli.mes[7]  
                       tg-dia-8:CHECKED IN FRAME fMes  = ttint-cond-pag-cli.mes[8]  
                       tg-dia-9:CHECKED IN FRAME fMes  = ttint-cond-pag-cli.mes[9]  
                       tg-dia-10:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[10] 
                       tg-dia-11:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[11] 
                       tg-dia-12:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[12] 
                       tg-dia-13:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[13] 
                       tg-dia-14:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[14] 
                       tg-dia-15:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[15] 
                       tg-dia-16:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[16] 
                       tg-dia-17:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[17] 
                       tg-dia-18:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[18] 
                       tg-dia-19:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[19] 
                       tg-dia-20:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[20] 
                       tg-dia-21:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[21] 
                       tg-dia-22:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[22] 
                       tg-dia-23:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[23] 
                       tg-dia-24:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[24] 
                       tg-dia-25:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[25] 
                       tg-dia-26:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[26] 
                       tg-dia-27:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[27] 
                       tg-dia-28:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[28] 
                       tg-dia-29:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[29] 
                       tg-dia-30:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[30] 
                       tg-dia-31:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[31] .
                RUN pi-zerar-campo (INPUT 1). 
            END.
        END.
    END.

    RUN pi-mostra-frames (INPUT ttint-cond-pag-cli.vencto-fixo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-vencto wMaintenanceNoNavigation 
PROCEDURE pi-grava-vencto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME fpage0:
    
        ASSIGN ttint-cond-pag-cli.grupo-econ  = tg-grupo:CHECKED      
               ttint-cond-pag-cli.prazo-DDE   = tg-prazo:CHECKED 
               ttint-cond-pag-cli.vencto-fixo = int(rs-tipo:SCREEN-VALUE).

        CASE rs-tipo:SCREEN-VALUE IN FRAME fpage0:
            WHEN "1" THEN DO:
                ASSIGN ttint-cond-pag-cli.semana[1] = tg-1:CHECKED IN FRAME fSemana
                       ttint-cond-pag-cli.semana[2] = tg-2:CHECKED IN FRAME fSemana
                       ttint-cond-pag-cli.semana[3] = tg-3:CHECKED IN FRAME fSemana
                       ttint-cond-pag-cli.semana[4] = tg-4:CHECKED IN FRAME fSemana
                       ttint-cond-pag-cli.semana[5] = tg-5:CHECKED IN FRAME fSemana.

                RUN pi-zerar-campo (INPUT 2). 
            END.
            WHEN "2" THEN DO:
                ASSIGN ttint-cond-pag-cli.mes[1]  = tg-dia-1:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[2]  = tg-dia-2:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[3]  = tg-dia-3:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[4]  = tg-dia-4:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[5]  = tg-dia-5:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[6]  = tg-dia-6:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[7]  = tg-dia-7:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[8]  = tg-dia-8:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[9]  = tg-dia-9:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[10] = tg-dia-10:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[11] = tg-dia-11:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[12] = tg-dia-12:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[13] = tg-dia-13:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[14] = tg-dia-14:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[15] = tg-dia-15:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[16] = tg-dia-16:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[17] = tg-dia-17:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[18] = tg-dia-18:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[19] = tg-dia-19:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[20] = tg-dia-20:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[21] = tg-dia-21:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[22] = tg-dia-22:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[23] = tg-dia-23:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[24] = tg-dia-24:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[25] = tg-dia-25:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[26] = tg-dia-26:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[27] = tg-dia-27:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[28] = tg-dia-28:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[29] = tg-dia-29:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[30] = tg-dia-30:CHECKED IN FRAME fMes
                       ttint-cond-pag-cli.mes[31] = tg-dia-31:CHECKED IN FRAME fMes.
                RUN pi-zerar-campo (INPUT 1). 
            END.
            WHEN "3" THEN DO:
                RUN pi-zerar-campo (INPUT INT(rs-tipo:SCREEN-VALUE IN FRAME fpage0)). 
            END.
        END.
    END.

    RUN pi-mostra-frames (INPUT int(rs-tipo:SCREEN-VALUE IN FRAME fpage0)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-frames wMaintenanceNoNavigation 
PROCEDURE pi-habilita-frames :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  rs-tipo:SCREEN-VALUE IN FRAME fpage0 = "1" THEN DO:
        ASSIGN tg-1:sensitive IN FRAME fSemana  = YES
               tg-2:sensitive IN FRAME fSemana  = YES
               tg-3:sensitive IN FRAME fSemana  = YES
               tg-4:sensitive IN FRAME fSemana  = YES
               tg-5:sensitive IN FRAME fSemana  = YES.
    END.
    ELSE IF  rs-tipo:SCREEN-VALUE IN FRAME fpage0 = "2" THEN 
             ASSIGN tg-dia-1:SENSITIVE IN FRAME fMes  = YES
                    tg-dia-2:SENSITIVE IN FRAME fMes  = YES
                    tg-dia-3:SENSITIVE IN FRAME fMes  = YES
                    tg-dia-4:SENSITIVE IN FRAME fMes  = YES
                    tg-dia-5:SENSITIVE IN FRAME fMes  = YES
                    tg-dia-6:SENSITIVE IN FRAME fMes  = YES
                    tg-dia-7:SENSITIVE IN FRAME fMes  = YES
                    tg-dia-8:SENSITIVE IN FRAME fMes  = YES
                    tg-dia-9:SENSITIVE IN FRAME fMes  = YES
                    tg-dia-10:SENSITIVE IN FRAME fMes = YES
                    tg-dia-11:SENSITIVE IN FRAME fMes = YES
                    tg-dia-12:SENSITIVE IN FRAME fMes = YES
                    tg-dia-13:SENSITIVE IN FRAME fMes = YES
                    tg-dia-14:SENSITIVE IN FRAME fMes = YES
                    tg-dia-15:SENSITIVE IN FRAME fMes = YES
                    tg-dia-16:SENSITIVE IN FRAME fMes = YES
                    tg-dia-17:SENSITIVE IN FRAME fMes = YES
                    tg-dia-18:SENSITIVE IN FRAME fMes = YES
                    tg-dia-19:SENSITIVE IN FRAME fMes = YES
                    tg-dia-20:SENSITIVE IN FRAME fMes = YES
                    tg-dia-21:SENSITIVE IN FRAME fMes = YES
                    tg-dia-22:SENSITIVE IN FRAME fMes = YES
                    tg-dia-23:SENSITIVE IN FRAME fMes = YES
                    tg-dia-24:SENSITIVE IN FRAME fMes = YES
                    tg-dia-25:SENSITIVE IN FRAME fMes = YES
                    tg-dia-26:SENSITIVE IN FRAME fMes = YES
                    tg-dia-27:SENSITIVE IN FRAME fMes = YES
                    tg-dia-28:SENSITIVE IN FRAME fMes = YES
                    tg-dia-29:SENSITIVE IN FRAME fMes = YES
                    tg-dia-30:SENSITIVE IN FRAME fMes = YES
                    tg-dia-31:SENSITIVE IN FRAME fMes = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-frames wMaintenanceNoNavigation 
PROCEDURE pi-mostra-frames :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-vencto-fixo AS INTEGER NO-UNDO.

    CASE p-vencto-fixo:
        WHEN 1 THEN DO:
            HIDE FRAME fMes.
            VIEW FRAME fSemana.
        END.
        WHEN 2 THEN DO:
            HIDE FRAME fSemana.
            VIEW FRAME fMes.
        END.
        OTHERWISE  DO:
            HIDE FRAME fSemana.
            HIDE FRAME fMes.
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-informacao wMaintenanceNoNavigation 
PROCEDURE pi-valida-informacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME fpage0:
        
        CASE  rs-tipo:SCREEN-VALUE :
            WHEN "1" THEN DO:
                IF  not tg-1:CHECKED IN FRAME fSemana   
                AND not tg-2:CHECKED IN FRAME fSemana   
                AND not tg-3:CHECKED IN FRAME fSemana   
                AND not tg-4:CHECKED IN FRAME fSemana   
                AND not tg-5:CHECKED IN FRAME fSemana THEN DO:
                    RUN utp/ut-msgs.p(input "show":U, 
                                      input 17006,
                                      input "Selecione ao menos um dia da semana.").
                    RETURN "NOK".
                END.
            END.
            WHEN "2" THEN DO:
                IF  NOT tg-dia-1:CHECKED   IN FRAME fMes
                AND NOT tg-dia-2:CHECKED   IN FRAME fMes
                AND NOT tg-dia-3:CHECKED   IN FRAME fMes
                AND NOT tg-dia-4:CHECKED   IN FRAME fMes
                AND NOT tg-dia-5:CHECKED   IN FRAME fMes
                AND NOT tg-dia-6:CHECKED   IN FRAME fMes
                AND NOT tg-dia-7:CHECKED   IN FRAME fMes
                AND NOT tg-dia-8:CHECKED   IN FRAME fMes
                AND NOT tg-dia-9:CHECKED   IN FRAME fMes
                AND NOT tg-dia-10:CHECKED  IN FRAME fMes
                AND NOT tg-dia-11:CHECKED  IN FRAME fMes
                AND NOT tg-dia-12:CHECKED  IN FRAME fMes
                AND NOT tg-dia-13:CHECKED  IN FRAME fMes
                AND NOT tg-dia-14:CHECKED  IN FRAME fMes
                AND NOT tg-dia-15:CHECKED  IN FRAME fMes
                AND NOT tg-dia-16:CHECKED  IN FRAME fMes
                AND NOT tg-dia-17:CHECKED  IN FRAME fMes
                AND NOT tg-dia-18:CHECKED  IN FRAME fMes
                AND NOT tg-dia-19:CHECKED  IN FRAME fMes
                AND NOT tg-dia-20:CHECKED  IN FRAME fMes
                AND NOT tg-dia-21:CHECKED  IN FRAME fMes
                AND NOT tg-dia-22:CHECKED  IN FRAME fMes
                AND NOT tg-dia-23:CHECKED  IN FRAME fMes
                AND NOT tg-dia-24:CHECKED  IN FRAME fMes
                AND NOT tg-dia-25:CHECKED  IN FRAME fMes
                AND NOT tg-dia-26:CHECKED  IN FRAME fMes
                AND NOT tg-dia-27:CHECKED  IN FRAME fMes
                AND NOT tg-dia-28:CHECKED  IN FRAME fMes
                AND NOT tg-dia-29:CHECKED  IN FRAME fMes
                AND NOT tg-dia-30:CHECKED  IN FRAME fMes
                AND NOT tg-dia-31:CHECKED THEN DO:
                    RUN utp/ut-msgs.p(input "show":U, 
                                      input 17006,
                                      input "Selecione ao menos um dia do mˆs.").
                    RETURN "NOK".
                END.
            END.
        END.
    END.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zerar-campo wMaintenanceNoNavigation 
PROCEDURE pi-zerar-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-vencto-fixo AS INTEGER NO-UNDO.

    CASE p-vencto-fixo:
        WHEN 1 OR WHEN 3 THEN DO:
            ASSIGN ttint-cond-pag-cli.semana[1] = NO
                   ttint-cond-pag-cli.semana[2] = NO
                   ttint-cond-pag-cli.semana[3] = NO
                   ttint-cond-pag-cli.semana[4] = NO
                   ttint-cond-pag-cli.semana[5] = NO.
        END.
        WHEN 2 OR WHEN 3 THEN DO:
            ASSIGN ttint-cond-pag-cli.mes[1]  = NO
                   ttint-cond-pag-cli.mes[2]  = NO
                   ttint-cond-pag-cli.mes[3]  = NO
                   ttint-cond-pag-cli.mes[4]  = NO
                   ttint-cond-pag-cli.mes[5]  = NO
                   ttint-cond-pag-cli.mes[6]  = NO
                   ttint-cond-pag-cli.mes[7]  = NO
                   ttint-cond-pag-cli.mes[8]  = NO
                   ttint-cond-pag-cli.mes[9]  = NO
                   ttint-cond-pag-cli.mes[10] = NO
                   ttint-cond-pag-cli.mes[11] = NO
                   ttint-cond-pag-cli.mes[12] = NO
                   ttint-cond-pag-cli.mes[13] = NO
                   ttint-cond-pag-cli.mes[14] = NO
                   ttint-cond-pag-cli.mes[15] = NO
                   ttint-cond-pag-cli.mes[16] = NO
                   ttint-cond-pag-cli.mes[17] = NO
                   ttint-cond-pag-cli.mes[18] = NO
                   ttint-cond-pag-cli.mes[19] = NO
                   ttint-cond-pag-cli.mes[20] = NO
                   ttint-cond-pag-cli.mes[21] = NO
                   ttint-cond-pag-cli.mes[22] = NO
                   ttint-cond-pag-cli.mes[23] = NO
                   ttint-cond-pag-cli.mes[24] = NO
                   ttint-cond-pag-cli.mes[25] = NO
                   ttint-cond-pag-cli.mes[26] = NO
                   ttint-cond-pag-cli.mes[27] = NO
                   ttint-cond-pag-cli.mes[28] = NO
                   ttint-cond-pag-cli.mes[29] = NO
                   ttint-cond-pag-cli.mes[30] = NO
                   ttint-cond-pag-cli.mes[31] = NO.
        END.
    END.

    RUN pi-mostra-frames (INPUT p-vencto-fixo).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    RUN pi-grava-vencto.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

