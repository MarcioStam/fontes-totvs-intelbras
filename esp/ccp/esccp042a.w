&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-projeto NO-UNDO LIKE int-projeto
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-int-projeto-item NO-UNDO LIKE int-projeto-item
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esccp042a 1.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esccp042a
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK btCancel

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER pType        AS CHARACTER   NO-UNDO. /* Create or Update */
DEFINE INPUT        PARAMETER pcod-projeto AS CHARACTER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pRow-table   AS ROWID       NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE      NO-UNDO.
DEFINE                   VARIABLE wh-pesquisa    AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-implanta     AS LOGICAL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-int-projeto.desc-projeto ~
tt-int-projeto-item.it-codigo 
&Scoped-define ENABLED-TABLES tt-int-projeto tt-int-projeto-item
&Scoped-define FIRST-ENABLED-TABLE tt-int-projeto
&Scoped-define SECOND-ENABLED-TABLE tt-int-projeto-item
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-6 RECT-7 btOK btSave btCancel ~
btHelp2 
&Scoped-Define DISPLAYED-FIELDS tt-int-projeto.cod-projeto ~
tt-int-projeto.desc-projeto tt-int-projeto-item.it-codigo 
&Scoped-define DISPLAYED-TABLES tt-int-projeto tt-int-projeto-item
&Scoped-define FIRST-DISPLAYED-TABLE tt-int-projeto
&Scoped-define SECOND-DISPLAYED-TABLE tt-int-projeto-item
&Scoped-Define DISPLAYED-OBJECTS c-desc-item 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 12 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 12 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 12 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 12 BY 1.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "x(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 1.5.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 1.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 88 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-int-projeto.cod-projeto AT ROW 1.5 COL 16.43 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-int-projeto.desc-projeto AT ROW 1.5 COL 28.43 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 48.57 BY .88
     tt-int-projeto-item.it-codigo AT ROW 3 COL 16.43 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     c-desc-item AT ROW 3 COL 34.43 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     btOK AT ROW 4.54 COL 2.72
     btSave AT ROW 4.54 COL 15.29 WIDGET-ID 10
     btCancel AT ROW 4.54 COL 27.72
     btHelp2 AT ROW 4.54 COL 77.43
     rtToolBar AT ROW 4.33 COL 2
     RECT-6 AT ROW 1.21 COL 2 WIDGET-ID 12
     RECT-7 AT ROW 2.75 COL 2 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 4.96
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-int-projeto T "?" NO-UNDO mgesp int-projeto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-int-projeto-item T "?" NO-UNDO mgesp int-projeto-item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 5.08
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-int-projeto.cod-projeto IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

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


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    RUN pi-salvar IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "OK" THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wWindow
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN pi-salvar IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "OK" THEN
        RUN pi-zerar-dados IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-projeto.cod-projeto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-projeto.cod-projeto wWindow
ON LEAVE OF tt-int-projeto.cod-projeto IN FRAME fpage0 /* Projeto */
DO:
    FIND FIRST int-projeto NO-LOCK
        WHERE  int-projeto.cod-projeto = INPUT FRAME fPage0 tt-int-projeto.cod-projeto NO-ERROR.
    IF  AVAIL int-projeto
    THEN DISP int-projeto.desc-projeto @ tt-int-projeto.desc-projeto WITH FRAME fPage0.
    ELSE DISP "" @ tt-int-projeto.desc-projeto WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-projeto-item.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-projeto-item.it-codigo wWindow
ON F5 OF tt-int-projeto-item.it-codigo IN FRAME fpage0 /* Item */
DO:
      {include/zoomvar.i &prog-zoom="inzoom/z01in172.w"
                      &campo="tt-int-projeto-item.it-codigo"
                      &campozoom="it-codigo"
                      &frame="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-projeto-item.it-codigo wWindow
ON LEAVE OF tt-int-projeto-item.it-codigo IN FRAME fpage0 /* Item */
DO:
    FIND FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = INPUT FRAME fPage0 tt-int-projeto-item.it-codigo NO-ERROR.
    IF  AVAIL ITEM
    THEN ASSIGN c-desc-item = ITEM.desc-item.
    ELSE ASSIGN c-desc-item = "".

    DISP c-desc-item WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-projeto-item.it-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-int-projeto-item.it-codigo IN FRAME fpage0 /* Item */
DO:
    APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
tt-int-projeto-item.it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
{window/mainblock.i}

/*tt-int-projeto-item.it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  pType = "Create":U THEN ENABLE tt-int-projeto-item.it-codigo btSave WITH FRAME fPage0.
    
    DISP pcod-projeto @ tt-int-projeto.cod-projeto WITH FRAME fPage0.
    APPLY "LEAVE":U TO tt-int-projeto.cod-projeto IN FRAME fPage0.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salvar wWindow 
PROCEDURE pi-salvar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-validar IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    IF  pType = "Create":U THEN DO:
        CREATE int-projeto-item.
        ASSIGN int-projeto-item.cod-projeto = INPUT FRAME fPage0 tt-int-projeto.cod-projeto
               int-projeto-item.it-codigo   = INPUT FRAME fPage0 tt-int-projeto-item.it-codigo.
    END.

    /* Retorna o Rowid do registro Criado/Alterado */
    ASSIGN pRow-table = ROWID(int-projeto-item).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validar wWindow 
PROCEDURE pi-validar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  pType = "Create":U THEN DO:
        IF  NOT CAN-FIND(FIRST ITEM NO-LOCK
                         WHERE ITEM.it-codigo = INPUT FRAME fPage0 tt-int-projeto-item.it-codigo) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 56,
                               INPUT "ITEM":U).

            APPLY "ENTRY":U TO tt-int-projeto-item.it-codigo IN FRAME fPage0.
            RETURN "NOK":U.
        END.

        IF  CAN-FIND(FIRST int-projeto-item NO-LOCK
                     WHERE /*int-projeto-item.cod-projeto = INPUT FRAME fPage0 tt-int-projeto.cod-projeto
                     AND */  int-projeto-item.it-codigo   = INPUT FRAME fPage0 tt-int-projeto-item.it-codigo) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 7,
                               INPUT "Item x Projeto":U).

            APPLY "ENTRY":U TO tt-int-projeto-item.it-codigo IN FRAME fPage0.
            RETURN "NOK":U.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zerar-dados wWindow 
PROCEDURE pi-zerar-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN tt-int-projeto-item.it-codigo:SCREEN-VALUE IN FRAME fPage0 = "".

    DISPLAY pcod-projeto @ tt-int-projeto.cod-projeto WITH FRAME fPage0.

    APPLY "LEAVE":U TO tt-int-projeto.cod-projeto IN FRAME fPage0.
    APPLY "LEAVE":U TO tt-int-projeto-item.it-codigo IN FRAME fPage0.
    APPLY "ENTRY":U TO tt-int-projeto-item.it-codigo IN FRAME fPage0.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

