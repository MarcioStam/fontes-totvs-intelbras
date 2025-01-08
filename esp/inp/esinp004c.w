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

DEFINE INPUT        PARAM p-row             AS ROWID     NO-UNDO.               
DEFINE OUTPUT       PARAM p-altera-ncm      AS LOGICAL   NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-aliquota-ii     AS CHARACTER NO-UNDO.               
DEFINE OUTPUT       PARAM p-altera-aliquota AS LOGICAL   NO-UNDO.               
DEFINE OUTPUT       PARAM p-altera-ipi      AS LOGICAL   NO-UNDO.               
DEFINE INPUT        PARAM p-item            AS CHARACTER NO-UNDO.               
DEFINE INPUT        PARAM p-ipi-isento      AS LOGICAL   NO-UNDO.               
DEFINE INPUT-OUTPUT PARAM p-ipi             AS CHARACTER NO-UNDO.               
DEFINE OUTPUT       PARAM p-altera-li       AS LOGICAL   NO-UNDO.               
DEFINE OUTPUT       PARAM p-necessita-li    AS LOGICAL   NO-UNDO.               
DEFINE OUTPUT       PARAM p-altera-destaque AS LOGICAL   NO-UNDO.               
DEFINE OUTPUT       PARAM p-destaque        AS INTEGER   NO-UNDO.               
DEFINE OUTPUT       PARAM p-altera-nve      AS LOGICAL   NO-UNDO.               
DEFINE OUTPUT       PARAM p-nve             AS CHARACTER NO-UNDO.               
DEFINE OUTPUT       PARAM p-altera-ex       AS LOGICAL   NO-UNDO.               
DEFINE OUTPUT       PARAM p-ex              AS CHARACTER NO-UNDO.               
DEFINE OUTPUT       PARAM p-altera-gatt     AS LOGICAL   NO-UNDO.               
DEFINE OUTPUT       PARAM p-gatt            AS LOGICAL   NO-UNDO.               
DEFINE OUTPUT       PARAM p-val-gatt        AS DECIMAL   NO-UNDO.               
DEFINE OUTPUT       PARAM p-retorno         AS LOGICAL   NO-UNDO.                 
                                                                                                                                        

DEF VAR teste AS CHAR.

FIND FIRST fiscosoft-ncm NO-LOCK
    WHERE ROWID(fiscosoft-ncm) = p-row NO-ERROR.

IF  NOT AVAIL fiscosoft-ncm THEN
    APPLY "END-ERROR":U TO SELF.

DEFINE NEW GLOBAL SHARED VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE l-implanta AS LOG INIT NO NO-UNDO.

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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-5 RECT-6 RECT-7 RECT-8 RECT-9 RECT-10 ~
RECT-11 RECT-12 tg-altera-ncm tg-aliotas-importacao fi-Aliquota-ii ~
tg-aliotas-ipi fi-ipi Tg-altera-li tg-necessita-li Tg-destaque Tg-nve ~
fi-nve Tg-ex fi-ex Tg-altera-gatt tg-gatt fi-gatt Btn_OK Btn_Cancel ~
Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS fi-ncm fi-descricao tg-altera-ncm ~
tg-aliotas-importacao fi-Aliquota-ii fi-isento tg-aliotas-ipi fi-ipi ~
Tg-altera-li tg-necessita-li Tg-destaque fi-destaque fi-desc-destaque ~
Tg-nve fi-nve Tg-ex fi-ex Tg-altera-gatt tg-gatt fi-gatt 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.13
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.13
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.13
     BGCOLOR 8 .

DEFINE VARIABLE fi-Aliquota-ii AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Imposto Importa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-destaque AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-destaque AS INTEGER FORMAT "999":U INITIAL 999 
     LABEL "Destaque" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ex AS CHARACTER FORMAT "X(8)":U 
     LABEL "Ex Tarif rio" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-gatt AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Perc Gatt" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ipi AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-isento AS CHARACTER FORMAT "X(256)":U INITIAL "NÆo Tributado" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ncm AS CHARACTER FORMAT "X(256)":U 
     LABEL "NCM" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nve AS CHARACTER FORMAT "X(100)":U 
     LABEL "NVE" 
     VIEW-AS FILL-IN 
     SIZE 58 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76 BY 2.25.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76 BY 1.88.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76 BY 2.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 24.25.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76 BY 1.75.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76 BY 1.75.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76 BY 2.25.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76 BY 2.25.

DEFINE VARIABLE tg-aliotas-importacao AS LOGICAL INITIAL no 
     LABEL "Al¡quotas Importa‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-aliotas-ipi AS LOGICAL INITIAL no 
     LABEL "Al¡quotas IPI" 
     VIEW-AS TOGGLE-BOX
     SIZE 12 BY .83 NO-UNDO.

DEFINE VARIABLE Tg-altera-gatt AS LOGICAL INITIAL no 
     LABEL "Alterar Informa‡Æo de LI nos Itens" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.

DEFINE VARIABLE Tg-altera-li AS LOGICAL INITIAL no 
     LABEL "Alterar Informa‡Æo de LI nos Itens" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.

DEFINE VARIABLE tg-altera-ncm AS LOGICAL INITIAL no 
     LABEL "Altera NCM" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.14 BY .83 NO-UNDO.

DEFINE VARIABLE Tg-destaque AS LOGICAL INITIAL no 
     LABEL "Alterar campo Destaque do item" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.

DEFINE VARIABLE Tg-ex AS LOGICAL INITIAL no 
     LABEL "Alterar Ex Tarif rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-gatt AS LOGICAL INITIAL no 
     LABEL "Gatt" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-necessita-li AS LOGICAL INITIAL no 
     LABEL "Necessita LI" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.57 BY .83 NO-UNDO.

DEFINE VARIABLE Tg-nve AS LOGICAL INITIAL no 
     LABEL "Alterar campo NVE" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-ncm AT ROW 2.5 COL 6.86 COLON-ALIGNED WIDGET-ID 2
     fi-descricao AT ROW 2.5 COL 22.43 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     tg-altera-ncm AT ROW 3.75 COL 9 WIDGET-ID 74
     tg-aliotas-importacao AT ROW 5.25 COL 3.86 WIDGET-ID 68
     fi-Aliquota-ii AT ROW 6.04 COL 25 COLON-ALIGNED WIDGET-ID 14
     fi-isento AT ROW 7.5 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     tg-aliotas-ipi AT ROW 7.79 COL 4 WIDGET-ID 72
     fi-ipi AT ROW 8.83 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     Tg-altera-li AT ROW 10.54 COL 4 WIDGET-ID 24
     tg-necessita-li AT ROW 11.33 COL 8 WIDGET-ID 26
     Tg-destaque AT ROW 13.04 COL 4 WIDGET-ID 28
     fi-destaque AT ROW 14.08 COL 15 COLON-ALIGNED WIDGET-ID 32
     fi-desc-destaque AT ROW 14.08 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     Tg-nve AT ROW 16.04 COL 4 WIDGET-ID 44
     fi-nve AT ROW 17.08 COL 15 COLON-ALIGNED WIDGET-ID 46
     Tg-ex AT ROW 19 COL 4 WIDGET-ID 52
     fi-ex AT ROW 20.08 COL 15 COLON-ALIGNED WIDGET-ID 48
     Tg-altera-gatt AT ROW 21.75 COL 4 WIDGET-ID 62
     tg-gatt AT ROW 23 COL 12 WIDGET-ID 64
     fi-gatt AT ROW 23 COL 31 COLON-ALIGNED WIDGET-ID 66
     Btn_OK AT ROW 24.75 COL 2 WIDGET-ID 40
     Btn_Cancel AT ROW 24.75 COL 18 WIDGET-ID 36
     Btn_Help AT ROW 24.75 COL 63 WIDGET-ID 38
     "% IPI:" VIEW-AS TEXT
          SIZE 4 BY .75 AT ROW 8.75 COL 14 WIDGET-ID 56
     " Aplicar os valores abaixo para Classifica‡Æo Fiscal e Itens Selecionados" VIEW-AS TEXT
          SIZE 50 BY .67 AT ROW 1.38 COL 3 WIDGET-ID 6
     RECT-5 AT ROW 2 COL 2 WIDGET-ID 4
     RECT-6 AT ROW 5.58 COL 3 WIDGET-ID 10
     RECT-7 AT ROW 10.83 COL 3 WIDGET-ID 20
     RECT-8 AT ROW 13.33 COL 3 WIDGET-ID 30
     RECT-9 AT ROW 16.33 COL 3 WIDGET-ID 42
     RECT-10 AT ROW 19.33 COL 3 WIDGET-ID 50
     RECT-11 AT ROW 22.25 COL 3 WIDGET-ID 60
     RECT-12 AT ROW 8.08 COL 3 WIDGET-ID 70
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 79.86 BY 25.42
         FONT 1
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert window title>"
         HEIGHT             = 25.42
         WIDTH              = 79.86
         MAX-HEIGHT         = 29.25
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 29.25
         VIRTUAL-WIDTH      = 195.14
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-desc-destaque IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-descricao IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-destaque IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-isento IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-ncm IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
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


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel C-Win
ON CHOOSE OF Btn_Cancel IN FRAME fpage0 /* Cancel */
DO:
   APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help C-Win
ON CHOOSE OF Btn_Help IN FRAME fpage0 /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK C-Win
ON CHOOSE OF Btn_OK IN FRAME fpage0 /* OK */
DO:
  
    IF  tg-destaque:CHECKED IN FRAME fpage0 THEN DO:

        IF  fi-destaque:SCREEN-VALUE IN FRAME fpage0 <> "999" AND
        (NOT CAN-FIND(FIRST destaque-classif-fisc NO-LOCK
                 WHERE destaque-classif-fisc.class-fiscal = fiscosoft-ncm.codigo
                   AND destaque-classif-fisc.destaque     = INT(fi-destaque:SCREEN-VALUE IN FRAME fpage0))) 
        THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW",
                               INPUT 17006,
                               INPUT "N£mero de Destaque inv lido.").

            RETURN NO-APPLY.

        END.
    END.

    IF  tg-altera-gatt:CHECKED IN FRAME fpage0 
    AND tg-gatt:CHECKED IN FRAME fpage0 
    AND dec(fi-gatt:SCREEN-VALUE) = 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "% Gatt deve ser informado").

        RETURN NO-APPLY.
    END.


    ASSIGN p-aliquota-ii     = INPUT FRAME fpage0 fi-Aliquota-ii /*fi-aliquota-ii:SCREEN-VALUE IN FRAME fpage0*/
           p-altera-ncm      = tg-altera-ncm:CHECKED IN FRAME fpage0
           p-altera-aliquota = tg-aliotas-importacao:CHECKED IN FRAME fpage0
           p-altera-ipi      = tg-aliotas-ipi:CHECKED IN FRAME fpage0
           p-altera-li       = tg-altera-li:CHECKED IN FRAME fpage0
           p-necessita-li    = tg-necessita-li:CHECKED IN FRAME fpage0
           p-altera-gatt     = tg-altera-gatt:CHECKED IN FRAME fpage0
           p-gatt            = tg-gatt:CHECKED IN FRAME fpage0
           p-val-gatt        = dec(fi-gatt:SCREEN-VALUE)
           p-altera-destaque = tg-destaque:CHECKED IN FRAME fpage0
           p-destaque        = INPUT FRAME fpage0 fi-destaque
           p-altera-nve      = tg-nve:CHECKED IN FRAME fpage0
           p-nve             = fi-nve:SCREEN-VALUE IN FRAME fpage0
           p-altera-ex       = tg-ex:CHECKED IN FRAME fpage0
           p-ex              = fi-ex:SCREEN-VALUE IN FRAME fpage0
           p-retorno         = YES.

     IF  NOT p-ipi-isento THEN
         ASSIGN p-ipi = fi-ipi:SCREEN-VALUE IN FRAME fpage0.
    
    APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-destaque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-destaque C-Win
ON F5 OF fi-destaque IN FRAME fpage0 /* Destaque */
DO:
  
    {include/zoomvar.i &prog-zoom=eszoom/z01es522.w
                       &campo=fi-destaque IN FRAME fpage0
                       &campozoom=destaque
                       &campo2=fi-desc-destaque
                       &campozoom2=descricao
                       &frame=fpage0
                       &parametros="run pi-seta-inicial in wh-pesquisa (input fiscosoft-ncm.codigo, input fiscosoft-ncm.codigo)."}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-destaque C-Win
ON LEAVE OF fi-destaque IN FRAME fpage0 /* Destaque */
DO:

    FIND FIRST destaque-classif-fisc NO-LOCK
         WHERE destaque-classif-fisc.class-fiscal = fiscosoft-ncm.codigo
           AND destaque-classif-fisc.destaque     = INT(fi-destaque:SCREEN-VALUE IN FRAME fpage0) NO-ERROR.
    IF  AVAIL destaque-classif-fisc THEN DO:
        ASSIGN fi-desc-destaque:SCREEN-VALUE IN FRAME fpage0 = destaque-classif-fisc.descricao.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-destaque C-Win
ON MOUSE-SELECT-DBLCLICK OF fi-destaque IN FRAME fpage0 /* Destaque */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-aliotas-importacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-aliotas-importacao C-Win
ON VALUE-CHANGED OF tg-aliotas-importacao IN FRAME fpage0 /* Al¡quotas Importa‡Æo */
DO:
    IF  tg-aliotas-importacao:CHECKED THEN
        ASSIGN fi-Aliquota-ii = INPUT FRAME fpage0 fi-Aliquota-ii.
    
    ASSIGN fi-Aliquota-ii:SENSITIVE = tg-aliotas-importacao:CHECKED.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-aliotas-ipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-aliotas-ipi C-Win
ON VALUE-CHANGED OF tg-aliotas-ipi IN FRAME fpage0 /* Al¡quotas IPI */
DO:
    IF  tg-aliotas-ipi:CHECKED THEN
        ASSIGN fi-ipi = INPUT FRAME fpage0 fi-ipi.

    ASSIGN fi-ipi:SENSITIVE = tg-aliotas-ipi:CHECKED
           fi-isento:SENSITIVE = tg-aliotas-ipi:CHECKED.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Tg-altera-gatt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tg-altera-gatt C-Win
ON VALUE-CHANGED OF Tg-altera-gatt IN FRAME fpage0 /* Alterar Informa‡Æo de LI nos Itens */
DO:
  
    ASSIGN tg-gatt:SENSITIVE = tg-altera-gatt:CHECKED.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Tg-altera-li
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tg-altera-li C-Win
ON VALUE-CHANGED OF Tg-altera-li IN FRAME fpage0 /* Alterar Informa‡Æo de LI nos Itens */
DO:
  
    ASSIGN tg-necessita-li:SENSITIVE = tg-altera-li:CHECKED.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-altera-ncm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-altera-ncm C-Win
ON VALUE-CHANGED OF tg-altera-ncm IN FRAME fpage0 /* Altera NCM */
DO:
    IF  tg-aliotas-importacao:CHECKED THEN
        ASSIGN fi-Aliquota-ii = INPUT FRAME fpage0 fi-Aliquota-ii.
    
    ASSIGN fi-Aliquota-ii:SENSITIVE = tg-aliotas-importacao:CHECKED.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Tg-destaque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tg-destaque C-Win
ON VALUE-CHANGED OF Tg-destaque IN FRAME fpage0 /* Alterar campo Destaque do item */
DO:
  
    IF  tg-destaque:CHECKED THEN
        ASSIGN fi-destaque:SCREEN-VALUE IN FRAME fpage0 = "999".

    ASSIGN fi-destaque:SENSITIVE = tg-destaque:CHECKED.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Tg-ex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tg-ex C-Win
ON VALUE-CHANGED OF Tg-ex IN FRAME fpage0 /* Alterar Ex Tarif rio */
DO:
  
    IF  tg-ex:CHECKED THEN
        ASSIGN fi-ex:SCREEN-VALUE IN FRAME fpage0 = "".

    ASSIGN fi-ex:SENSITIVE = tg-ex:CHECKED.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-gatt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-gatt C-Win
ON VALUE-CHANGED OF tg-gatt IN FRAME fpage0 /* Gatt */
DO:
  ASSIGN fi-gatt:SENSITIVE = tg-gatt:CHECKED.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Tg-nve
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tg-nve C-Win
ON VALUE-CHANGED OF Tg-nve IN FRAME fpage0 /* Alterar campo NVE */
DO:
  
    IF  tg-nve:CHECKED THEN
        ASSIGN fi-nve:SCREEN-VALUE IN FRAME fpage0 = "".

    ASSIGN fi-nve:SENSITIVE = tg-nve:CHECKED.
  
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
    ASSIGN 
           tg-aliotas-ipi:CHECKED IN FRAME fpage0 = NO
           tg-aliotas-importacao:CHECKED IN FRAME fpage0   = NO 
           tg-altera-li:CHECKED IN FRAME fpage0            = NO
           tg-necessita-li:CHECKED IN FRAME fpage0         = NO
           tg-necessita-li:SENSITIVE IN FRAME fpage0       = NO
           tg-destaque:SENSITIVE IN FRAME fpage0           = YES
           fi-destaque:SCREEN-VALUE IN FRAME fpage0        = ""
           tg-nve:CHECKED IN FRAME fpage0                  = NO
           fi-nve:SENSITIVE                                = NO
           tg-ex:CHECKED IN FRAME fpage0                   = NO
           fi-ex:SENSITIVE                                 = NO
           tg-altera-gatt:CHECKED IN FRAME fpage0          = NO 
           tg-gatt:CHECKED IN FRAME fpage0                 = NO 
           tg-gatt:SENSITIVE IN FRAME fpage0               = NO
           FI-GATT:SENSITIVE IN FRAME fpage0               = NO.

    FIND FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = p-item NO-ERROR.

    ASSIGN fi-ncm:SCREEN-VALUE         IN FRAME fpage0 = fiscosoft-ncm.codigo
           fi-descricao:SCREEN-VALUE   IN FRAME fpage0 = fiscosoft-ncm.descricao
           fi-Aliquota-ii:SCREEN-VALUE IN FRAME fpage0 = REPLACE(p-aliquota-ii, ".", ",")
           fi-ipi:SCREEN-VALUE         IN FRAME fpage0 = REPLACE(p-ipi, ".", ",").       
    
    DISABLE fi-Aliquota-ii           WITH FRAME fPage0.
    DISABLE fi-ipi                   WITH FRAME fPage0.
    DISABLE fi-isento                WITH FRAME fPage0.
    
    IF  p-ipi-isento THEN
        ASSIGN fi-ipi:VISIBLE IN FRAME fpage0 = NO
               fi-isento:VISIBLE IN FRAME fpage0 = YES.
    ELSE
        ASSIGN fi-ipi:VISIBLE IN FRAME fpage0 = YES
               fi-isento:VISIBLE IN FRAME fpage0 = NO.


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
  DISPLAY fi-ncm fi-descricao tg-altera-ncm tg-aliotas-importacao fi-Aliquota-ii 
          fi-isento tg-aliotas-ipi fi-ipi Tg-altera-li tg-necessita-li 
          Tg-destaque fi-destaque fi-desc-destaque Tg-nve fi-nve Tg-ex fi-ex 
          Tg-altera-gatt tg-gatt fi-gatt 
      WITH FRAME fpage0 IN WINDOW C-Win.
  ENABLE RECT-5 RECT-6 RECT-7 RECT-8 RECT-9 RECT-10 RECT-11 RECT-12 
         tg-altera-ncm tg-aliotas-importacao fi-Aliquota-ii tg-aliotas-ipi 
         fi-ipi Tg-altera-li tg-necessita-li Tg-destaque Tg-nve fi-nve Tg-ex 
         fi-ex Tg-altera-gatt tg-gatt fi-gatt Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME fpage0 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fpage0}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

