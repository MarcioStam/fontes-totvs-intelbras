&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE l-ok       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-esacr048 AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-4 RECT-5 tg-up-compras ~
tg-transacoes tg-atu-clientes tg-pagtos tg-param tg-motivo tg-clientes ~
tg-compras tg-pendencias btExecutar btFechar text-retorno text-envio 
&Scoped-Define DISPLAYED-OBJECTS tg-up-compras c-arq-compras tg-transacoes ~
c-arq-transacoes tg-atu-clientes c-arq-clientes tg-pagtos c-arq-pagtos ~
dt-arq-pagtos tg-param c-arq-param tg-motivo c-arq-motivo tg-clientes ~
c-cod-gr-cob tg-compras tg-pendencias text-retorno text-envio 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-arq-clientes 
     IMAGE-UP FILE "image/im-ngrava.bmp":U
     LABEL "" 
     SIZE 4 BY .96 TOOLTIP "Pesquisar Arquivo de Clientes".

DEFINE BUTTON bt-arq-compras 
     IMAGE-UP FILE "image/im-ngrava.bmp":U
     LABEL "" 
     SIZE 4 BY .96 TOOLTIP "Pesquisar Arquivo de Compras".

DEFINE BUTTON bt-arq-motivo 
     IMAGE-UP FILE "image/im-ngrava.bmp":U
     LABEL "" 
     SIZE 4 BY .96 TOOLTIP "Pesquisar Arquivo de Motivos".

DEFINE BUTTON bt-arq-pagtos 
     IMAGE-UP FILE "image/im-ngrava.bmp":U
     LABEL "" 
     SIZE 4 BY .96 TOOLTIP "Pesquisar Arquivo de Pagamentos".

DEFINE BUTTON bt-arq-param 
     IMAGE-UP FILE "image/im-ngrava.bmp":U
     LABEL "" 
     SIZE 4 BY .96 TOOLTIP "Pesquisar Arquivo de Parƒmetros".

DEFINE BUTTON bt-arq-transacoes 
     IMAGE-UP FILE "image/im-ngrava.bmp":U
     LABEL "" 
     SIZE 4 BY .96 TOOLTIP "Pesquisar Arquivo de Transa‡äes".

DEFINE BUTTON btExecutar 
     LABEL "&Executar" 
     SIZE 10 BY 1 TOOLTIP "Executar".

DEFINE BUTTON btFechar 
     LABEL "&Fechar" 
     SIZE 10 BY 1 TOOLTIP "Fechar".

DEFINE VARIABLE c-arq-clientes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE c-arq-compras AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE c-arq-motivo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE c-arq-pagtos AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE c-arq-param AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE c-arq-transacoes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-gr-cob AS CHARACTER FORMAT "X(256)":U 
     LABEL "Grupos de Cobran‡a" 
     VIEW-AS FILL-IN 
     SIZE 26.43 BY .88 NO-UNDO.

DEFINE VARIABLE dt-arq-pagtos AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Dt Arq" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE text-envio AS CHARACTER FORMAT "X(50)":U INITIAL "Arquivos de Envio (Exporta‡Æo)" 
      VIEW-AS TEXT 
     SIZE 21.86 BY .67 NO-UNDO.

DEFINE VARIABLE text-retorno AS CHARACTER FORMAT "X(50)":U INITIAL "Arquivos de Retorno (Importa‡Æo)" 
      VIEW-AS TEXT 
     SIZE 23.14 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 100 BY 6.75.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 100 BY 3.63.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 101.86 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-atu-clientes AS LOGICAL INITIAL no 
     LABEL "Atualiza‡Æo de Clientes (Layout 8.6)" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.86 BY .75 TOOLTIP "Layout 8.6 - Programa ESACR037" NO-UNDO.

DEFINE VARIABLE tg-clientes AS LOGICAL INITIAL no 
     LABEL "Carga de Clientes (Layout 8.1)" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.86 BY .75 TOOLTIP "Layout 8.1 - Programa ESACR033" NO-UNDO.

DEFINE VARIABLE tg-compras AS LOGICAL INITIAL no 
     LABEL "Upload de Compras (Layout 8.2)" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .75 TOOLTIP "Layout 8.2 - Programa ESACR040" NO-UNDO.

DEFINE VARIABLE tg-motivo AS LOGICAL INITIAL no 
     LABEL "Motivos de Retorno (Layout 8.9)" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .75 TOOLTIP "Layout 8.9 - Programa ESACR039" NO-UNDO.

DEFINE VARIABLE tg-pagtos AS LOGICAL INITIAL no 
     LABEL "Agendamento de Pagamentos (Layout 8.7)" 
     VIEW-AS TOGGLE-BOX
     SIZE 32.86 BY .75 TOOLTIP "Layout 8.7 - Programa ESACR046" NO-UNDO.

DEFINE VARIABLE tg-param AS LOGICAL INITIAL no 
     LABEL "Parƒmetros de Compra (Layout 8.8)" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .75 TOOLTIP "Layout 8.8 - Programa ESACR038" NO-UNDO.

DEFINE VARIABLE tg-pendencias AS LOGICAL INITIAL no 
     LABEL "Upload Outras Transa‡äes (Layout 8.4)" 
     VIEW-AS TOGGLE-BOX
     SIZE 29.86 BY .75 TOOLTIP "Layout 8.4 - Programa ESACR042" NO-UNDO.

DEFINE VARIABLE tg-transacoes AS LOGICAL INITIAL no 
     LABEL "Upload Outras Transa‡äes (Layout 8.5)" 
     VIEW-AS TOGGLE-BOX
     SIZE 29.86 BY .75 TOOLTIP "Layout 8.5 - Programa ESACR037" NO-UNDO.

DEFINE VARIABLE tg-up-compras AS LOGICAL INITIAL no 
     LABEL "Upload de Compras (Layout 8.3)" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .75 TOOLTIP "Layout 8.3 - Programa ESACR044" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     tg-up-compras AT ROW 2.04 COL 3.14 WIDGET-ID 64
     c-arq-compras AT ROW 2.04 COL 44 COLON-ALIGNED WIDGET-ID 60
     bt-arq-compras AT ROW 2.04 COL 81.29 WIDGET-ID 84
     tg-transacoes AT ROW 3.04 COL 3.14 WIDGET-ID 62
     c-arq-transacoes AT ROW 3.04 COL 44 COLON-ALIGNED WIDGET-ID 58
     bt-arq-transacoes AT ROW 3.04 COL 81.29 WIDGET-ID 86
     tg-atu-clientes AT ROW 4.04 COL 3.14 WIDGET-ID 68
     c-arq-clientes AT ROW 4.04 COL 44 COLON-ALIGNED WIDGET-ID 66
     bt-arq-clientes AT ROW 4.04 COL 81.29 WIDGET-ID 88
     tg-pagtos AT ROW 5.04 COL 3.14 WIDGET-ID 72
     c-arq-pagtos AT ROW 5.04 COL 44 COLON-ALIGNED WIDGET-ID 70
     bt-arq-pagtos AT ROW 5.04 COL 81.29 WIDGET-ID 90
     dt-arq-pagtos AT ROW 5.04 COL 89 COLON-ALIGNED
     tg-param AT ROW 6.04 COL 3.14 WIDGET-ID 80
     c-arq-param AT ROW 6.04 COL 44 COLON-ALIGNED WIDGET-ID 76
     bt-arq-param AT ROW 6.04 COL 81.29 WIDGET-ID 92
     tg-motivo AT ROW 7.04 COL 3.14 WIDGET-ID 78
     c-arq-motivo AT ROW 7.04 COL 44 COLON-ALIGNED WIDGET-ID 74
     bt-arq-motivo AT ROW 7.04 COL 81.29 WIDGET-ID 94
     tg-clientes AT ROW 9.33 COL 3.14 WIDGET-ID 40
     c-cod-gr-cob AT ROW 9.33 COL 41.14 COLON-ALIGNED
     tg-compras AT ROW 10.33 COL 3.14 WIDGET-ID 56
     tg-pendencias AT ROW 11.33 COL 3.14 WIDGET-ID 2
     btExecutar AT ROW 12.96 COL 2 WIDGET-ID 26
     btFechar AT ROW 12.96 COL 12.29 WIDGET-ID 54
     text-retorno AT ROW 1.17 COL 2.86 NO-LABEL WIDGET-ID 44
     text-envio AT ROW 8.54 COL 2.86 NO-LABEL WIDGET-ID 48
     "*separado por v¡rgula" VIEW-AS TEXT
          SIZE 15.29 BY .54 AT ROW 9.5 COL 70
          FGCOLOR 12 FONT 1
     rtToolBar AT ROW 12.75 COL 1 WIDGET-ID 34
     RECT-4 AT ROW 1.5 COL 2 WIDGET-ID 42
     RECT-5 AT ROW 8.88 COL 2 WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 101.86 BY 13.17
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Executar processos"
         HEIGHT             = 13.17
         WIDTH              = 101.86
         MAX-HEIGHT         = 30.58
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 30.58
         VIRTUAL-WIDTH      = 182.86
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
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
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON bt-arq-clientes IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-arq-compras IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-arq-motivo IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-arq-pagtos IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-arq-param IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-arq-transacoes IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-arq-clientes IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-arq-compras IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-arq-motivo IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-arq-pagtos IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-arq-param IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-arq-transacoes IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-gr-cob IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dt-arq-pagtos IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN text-envio IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN text-retorno IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Executar processos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Executar processos */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arq-clientes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arq-clientes C-Win
ON CHOOSE OF bt-arq-clientes IN FRAME DEFAULT-FRAME
DO:
    SYSTEM-DIALOG GET-FILE c-arq-clientes
            TITLE      "Arquivo " + tg-atu-clientes:HANDLE:LABEL
            FILTERS    "Arquivos de texto (*.txt)" "*.txt"
            INITIAL-DIR SESSION:TEMP-DIRECTORY
            MUST-EXIST
            USE-FILENAME
            UPDATE l-ok.

    IF  NOT l-ok THEN
        RETURN "NOK":U.

    ASSIGN c-arq-clientes = REPLACE(c-arq-clientes, "\", "/").

    DISP c-arq-clientes WITH FRAME default-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arq-compras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arq-compras C-Win
ON CHOOSE OF bt-arq-compras IN FRAME DEFAULT-FRAME
DO:
    SYSTEM-DIALOG GET-FILE c-arq-compras
            TITLE      "Arquivo " + tg-up-compras:HANDLE:LABEL
            FILTERS    "Arquivos de texto (*.ret)" "*.ret"
            INITIAL-DIR SESSION:TEMP-DIRECTORY
            MUST-EXIST
            USE-FILENAME
            UPDATE l-ok.

    IF  NOT l-ok THEN
        RETURN "NOK":U.

    ASSIGN c-arq-compras = REPLACE(c-arq-compras, "\", "/").

    DISP c-arq-compras WITH FRAME default-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arq-motivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arq-motivo C-Win
ON CHOOSE OF bt-arq-motivo IN FRAME DEFAULT-FRAME
DO:
    SYSTEM-DIALOG GET-FILE c-arq-motivo
            TITLE      "Arquivo " + tg-motivo:HANDLE:LABEL
            FILTERS    "Arquivos de texto (*.txt)" "*.txt"
            INITIAL-DIR SESSION:TEMP-DIRECTORY
            MUST-EXIST
            USE-FILENAME
            UPDATE l-ok.

    IF  NOT l-ok THEN
        RETURN "NOK":U.

    ASSIGN c-arq-motivo = REPLACE(c-arq-motivo, "\", "/").

    DISP c-arq-motivo WITH FRAME default-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arq-pagtos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arq-pagtos C-Win
ON CHOOSE OF bt-arq-pagtos IN FRAME DEFAULT-FRAME
DO:
    SYSTEM-DIALOG GET-FILE c-arq-pagtos
            TITLE      "Arquivo " + tg-pagtos:HANDLE:LABEL
            FILTERS    "Arquivos de texto (*.txt)" "*.txt"
            INITIAL-DIR SESSION:TEMP-DIRECTORY
            MUST-EXIST
            USE-FILENAME
            UPDATE l-ok.

    IF  NOT l-ok THEN
        RETURN "NOK":U.

    ASSIGN c-arq-pagtos = REPLACE(c-arq-pagtos, "\", "/").

    DISP c-arq-pagtos WITH FRAME default-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arq-param
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arq-param C-Win
ON CHOOSE OF bt-arq-param IN FRAME DEFAULT-FRAME
DO:
    SYSTEM-DIALOG GET-FILE c-arq-param
            TITLE      "Arquivo " + tg-param:HANDLE:LABEL
            FILTERS    "Arquivos de texto (*.txt)" "*.txt"
            INITIAL-DIR SESSION:TEMP-DIRECTORY
            MUST-EXIST
            USE-FILENAME
            UPDATE l-ok.

    IF  NOT l-ok THEN
        RETURN "NOK":U.

    ASSIGN c-arq-param = REPLACE(c-arq-param, "\", "/").

    DISP c-arq-param WITH FRAME default-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arq-transacoes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arq-transacoes C-Win
ON CHOOSE OF bt-arq-transacoes IN FRAME DEFAULT-FRAME
DO:
    SYSTEM-DIALOG GET-FILE c-arq-transacoes
            TITLE      "Arquivo " + tg-transacoes:HANDLE:LABEL
            FILTERS    "Arquivos de texto (*.ret)" "*.ret"
            INITIAL-DIR SESSION:TEMP-DIRECTORY
            MUST-EXIST
            USE-FILENAME
            UPDATE l-ok.

    IF  NOT l-ok THEN
        RETURN "NOK":U.

    ASSIGN c-arq-transacoes = REPLACE(c-arq-transacoes, "\", "/").

    DISP c-arq-transacoes WITH FRAME default-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExecutar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExecutar C-Win
ON CHOOSE OF btExecutar IN FRAME DEFAULT-FRAME /* Executar */
DO:
    RUN pi-executa.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFechar C-Win
ON CHOOSE OF btFechar IN FRAME DEFAULT-FRAME /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-atu-clientes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-atu-clientes C-Win
ON VALUE-CHANGED OF tg-atu-clientes IN FRAME DEFAULT-FRAME /* Atualiza‡Æo de Clientes (Layout 8.6) */
DO:
    IF  INPUT FRAME default-frame tg-atu-clientes THEN DO:
        IF  NOT VALID-HANDLE(h-esacr048) THEN
            RUN esp/acr/esacr048.p PERSISTENT SET h-esacr048.

        RUN pi-retornar-arquivo-retorno IN h-esacr048 (INPUT "8.6",
                                                       OUTPUT c-arq-clientes).
        
        IF  VALID-HANDLE(h-esacr048) THEN DO:
            DELETE PROCEDURE h-esacr048.
            ASSIGN h-esacr048 = ?.
        END.
    END.
    ELSE
        ASSIGN c-arq-clientes = "".

    DISP c-arq-clientes WITH FRAME default-frame.

    ASSIGN c-arq-clientes:SENSITIVE  IN FRAME default-frame = INPUT FRAME default-frame tg-atu-clientes
           bt-arq-clientes:SENSITIVE IN FRAME default-frame = INPUT FRAME default-frame tg-atu-clientes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-clientes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-clientes C-Win
ON VALUE-CHANGED OF tg-clientes IN FRAME DEFAULT-FRAME /* Carga de Clientes (Layout 8.1) */
DO:
    IF NOT SELF:CHECKED THEN
        ASSIGN c-cod-gr-cob = "":U.

    DISPLAY c-cod-gr-cob
        WITH FRAME default-frame.

    ASSIGN c-cod-gr-cob:SENSITIVE IN FRAME default-frame = SELF:CHECKED.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-motivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-motivo C-Win
ON VALUE-CHANGED OF tg-motivo IN FRAME DEFAULT-FRAME /* Motivos de Retorno (Layout 8.9) */
DO:
    IF  INPUT FRAME default-frame tg-motivo THEN DO:
        IF  NOT VALID-HANDLE(h-esacr048) THEN
            RUN esp/acr/esacr048.p PERSISTENT SET h-esacr048.

        RUN pi-retornar-arquivo-retorno IN h-esacr048 (INPUT "8.9",
                                                       OUTPUT c-arq-motivo).
        
        IF  VALID-HANDLE(h-esacr048) THEN DO:
            DELETE PROCEDURE h-esacr048.
            ASSIGN h-esacr048 = ?.
        END.
    END.
    ELSE
        ASSIGN c-arq-motivo = "".

    DISP c-arq-motivo WITH FRAME default-frame.

    ASSIGN c-arq-motivo:SENSITIVE  IN FRAME default-frame = INPUT FRAME default-frame tg-motivo
           bt-arq-motivo:SENSITIVE IN FRAME default-frame = INPUT FRAME default-frame tg-motivo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-pagtos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-pagtos C-Win
ON VALUE-CHANGED OF tg-pagtos IN FRAME DEFAULT-FRAME /* Agendamento de Pagamentos (Layout 8.7) */
DO:
    IF  INPUT FRAME default-frame tg-pagtos THEN DO:
        IF  NOT VALID-HANDLE(h-esacr048) THEN
            RUN esp/acr/esacr048.p PERSISTENT SET h-esacr048.

        RUN pi-retornar-arquivo-retorno IN h-esacr048 (INPUT "8.7",
                                                       OUTPUT c-arq-pagtos).
        
        IF  VALID-HANDLE(h-esacr048) THEN DO:
            DELETE PROCEDURE h-esacr048.
            ASSIGN h-esacr048 = ?.
        END.

        ASSIGN dt-arq-pagtos = TODAY.
    END.
    ELSE
        ASSIGN c-arq-pagtos  = ""
               dt-arq-pagtos = ?.

    DISP c-arq-pagtos
         dt-arq-pagtos WITH FRAME default-frame.

    ASSIGN c-arq-pagtos:SENSITIVE  IN FRAME default-frame = INPUT FRAME default-frame tg-pagtos
           bt-arq-pagtos:SENSITIVE IN FRAME default-frame = INPUT FRAME default-frame tg-pagtos
           dt-arq-pagtos:SENSITIVE IN FRAME default-frame = INPUT FRAME default-frame tg-pagtos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-param
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-param C-Win
ON VALUE-CHANGED OF tg-param IN FRAME DEFAULT-FRAME /* Parƒmetros de Compra (Layout 8.8) */
DO:
    IF  INPUT FRAME default-frame tg-param THEN DO:
        IF  NOT VALID-HANDLE(h-esacr048) THEN
            RUN esp/acr/esacr048.p PERSISTENT SET h-esacr048.

        RUN pi-retornar-arquivo-retorno IN h-esacr048 (INPUT "8.8",
                                                       OUTPUT c-arq-param).
        
        IF  VALID-HANDLE(h-esacr048) THEN DO:
            DELETE PROCEDURE h-esacr048.
            ASSIGN h-esacr048 = ?.
        END.
    END.
    ELSE
        ASSIGN c-arq-param = "".

    DISP c-arq-param WITH FRAME default-frame.

    ASSIGN c-arq-param:SENSITIVE  IN FRAME default-frame = INPUT FRAME default-frame tg-param
           bt-arq-param:SENSITIVE IN FRAME default-frame = INPUT FRAME default-frame tg-param.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-transacoes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-transacoes C-Win
ON VALUE-CHANGED OF tg-transacoes IN FRAME DEFAULT-FRAME /* Upload Outras Transa‡äes (Layout 8.5) */
DO:
    IF  INPUT FRAME default-frame tg-transacoes THEN DO:
        IF  NOT VALID-HANDLE(h-esacr048) THEN
            RUN esp/acr/esacr048.p PERSISTENT SET h-esacr048.

        RUN pi-retornar-arquivo-retorno IN h-esacr048 (INPUT "8.5",
                                                       OUTPUT c-arq-transacoes).
        
        IF  VALID-HANDLE(h-esacr048) THEN DO:
            DELETE PROCEDURE h-esacr048.
            ASSIGN h-esacr048 = ?.
        END.
    END.
    ELSE
        ASSIGN c-arq-transacoes = "".

    DISP c-arq-transacoes WITH FRAME default-frame.

    ASSIGN c-arq-transacoes:SENSITIVE  IN FRAME default-frame = INPUT FRAME default-frame tg-transacoes
           bt-arq-transacoes:SENSITIVE IN FRAME default-frame = INPUT FRAME default-frame tg-transacoes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-up-compras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-up-compras C-Win
ON VALUE-CHANGED OF tg-up-compras IN FRAME DEFAULT-FRAME /* Upload de Compras (Layout 8.3) */
DO:
    IF  INPUT FRAME default-frame tg-up-compras THEN DO:
        IF  NOT VALID-HANDLE(h-esacr048) THEN
            RUN esp/acr/esacr048.p PERSISTENT SET h-esacr048.

        RUN pi-retornar-arquivo-retorno IN h-esacr048 (INPUT "8.3",
                                                       OUTPUT c-arq-compras).
        
        IF  VALID-HANDLE(h-esacr048) THEN DO:
            DELETE PROCEDURE h-esacr048.
            ASSIGN h-esacr048 = ?.
        END.
    END.
    ELSE
        ASSIGN c-arq-compras = "".

    DISP c-arq-compras WITH FRAME default-frame.

    ASSIGN c-arq-compras:SENSITIVE  IN FRAME default-frame = INPUT FRAME default-frame tg-up-compras
           bt-arq-compras:SENSITIVE IN FRAME default-frame = INPUT FRAME default-frame tg-up-compras.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

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
  DISPLAY tg-up-compras c-arq-compras tg-transacoes c-arq-transacoes 
          tg-atu-clientes c-arq-clientes tg-pagtos c-arq-pagtos dt-arq-pagtos 
          tg-param c-arq-param tg-motivo c-arq-motivo tg-clientes c-cod-gr-cob 
          tg-compras tg-pendencias text-retorno text-envio 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE rtToolBar RECT-4 RECT-5 tg-up-compras tg-transacoes tg-atu-clientes 
         tg-pagtos tg-param tg-motivo tg-clientes tg-compras tg-pendencias 
         btExecutar btFechar text-retorno text-envio 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executa C-Win 
PROCEDURE pi-executa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN INPUT FRAME default-frame tg-param
           INPUT FRAME default-frame c-arq-param
           INPUT FRAME default-frame tg-motivo
           INPUT FRAME default-frame c-arq-motivo
           INPUT FRAME default-frame tg-up-compras
           INPUT FRAME default-frame c-arq-compras
           INPUT FRAME default-frame tg-transacoes
           INPUT FRAME default-frame c-arq-transacoes
           INPUT FRAME default-frame tg-atu-clientes
           INPUT FRAME default-frame c-arq-clientes
           INPUT FRAME default-frame tg-pagtos
           INPUT FRAME default-frame c-arq-pagtos
           INPUT FRAME default-frame dt-arq-pagtos
           INPUT FRAME default-frame tg-clientes
           INPUT FRAME default-frame c-cod-gr-cob
           INPUT FRAME default-frame tg-compras
           INPUT FRAME default-frame tg-pendencias.

    /* Programas de Importa‡Æo */
    IF  tg-atu-clientes THEN
        RUN esp/acr/esacr037.p (INPUT "8.6", INPUT c-arq-clientes).

    IF  tg-up-compras THEN
        RUN esp/acr/esacr044.p (INPUT c-arq-compras).

    IF  tg-transacoes THEN
        RUN esp/acr/esacr037.p (INPUT "8.5", INPUT c-arq-transacoes).

    IF  tg-pagtos THEN
        RUN esp/acr/esacr046.p (INPUT c-arq-pagtos, INPUT dt-arq-pagtos).

    IF  tg-param THEN
        RUN esp/acr/esacr038.p (INPUT c-arq-param).

    IF  tg-motivo THEN
        RUN esp/acr/esacr039.p (INPUT c-arq-motivo).




    /* Programas de Exporta‡Æo */
    IF  tg-clientes THEN
        RUN esp/acr/esacr033.p (INPUT c-cod-gr-cob).

    IF  tg-compras THEN
        RUN esp/acr/esacr040.p.

    IF  tg-pendencias THEN
        RUN esp/acr/esacr042.p.


    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 15825,
                       INPUT "Execu‡Æo Finalizada!":U).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

