&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i CD0821-UPC-1 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        CD0821-UPC-1
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Unid Comercial

&GLOBAL-DEFINE page0Widgets   btClose
&GLOBAL-DEFINE page1Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER pUsuario AS CHARACTER FORMAT "x(12)"  NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-ds-unid-comerc AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brUnidNegoc

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES int-user-coml

/* Definitions for BROWSE brUnidNegoc                                   */
&Scoped-define FIELDS-IN-QUERY-brUnidNegoc int-user-coml.cd-unid-negoc ~
fnDsUnidNegoc(int-user-coml.cd-unid-negoc) @ c-ds-unid-comerc 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brUnidNegoc 
&Scoped-define QUERY-STRING-brUnidNegoc FOR EACH int-user-coml ~
      WHERE int-user-coml.cd-usuario = INPUT FRAME fPage0 c-usuario NO-LOCK
&Scoped-define OPEN-QUERY-brUnidNegoc OPEN QUERY brUnidNegoc FOR EACH int-user-coml ~
      WHERE int-user-coml.cd-usuario = INPUT FRAME fPage0 c-usuario NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brUnidNegoc int-user-coml
&Scoped-define FIRST-TABLE-IN-QUERY-brUnidNegoc int-user-coml


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brUnidNegoc}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-1 c-usuario c-nm-usuario ~
btClose 
&Scoped-Define DISPLAYED-OBJECTS c-usuario c-nm-usuario 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDsUnidNegoc wWindow 
FUNCTION fnDsUnidNegoc RETURNS CHARACTER
  ( pCod-unid-comerc AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btClose 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-nm-usuario AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 46.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-usuario AS CHARACTER FORMAT "x(12)" 
     LABEL "Usu rio":R9 
     VIEW-AS FILL-IN 
     SIZE 13.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 1.38.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btExcluir 
     LABEL "Excluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btIncluir 
     LABEL "Incluir" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brUnidNegoc FOR 
      int-user-coml SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brUnidNegoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brUnidNegoc wWindow _STRUCTURED
  QUERY brUnidNegoc NO-LOCK DISPLAY
      int-user-coml.cd-unid-negoc FORMAT "x(3)":U WIDTH 11.14
      fnDsUnidNegoc(int-user-coml.cd-unid-negoc) @ c-ds-unid-comerc COLUMN-LABEL "Descri‡Æo" FORMAT "x(40)":U
            WIDTH 68.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 83 BY 10.21
         FONT 1 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     c-usuario AT ROW 1.42 COL 16.43 COLON-ALIGNED HELP
          "Nome do Usu rio" WIDGET-ID 14
     c-nm-usuario AT ROW 1.42 COL 30.57 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     btClose AT ROW 16.75 COL 2
     rtToolBar AT ROW 16.54 COL 1
     RECT-1 AT ROW 1.17 COL 1.43 WIDGET-ID 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brUnidNegoc AT ROW 1.29 COL 1.57 WIDGET-ID 200
     btIncluir AT ROW 11.63 COL 1.57 WIDGET-ID 2
     btExcluir AT ROW 11.63 COL 11.86 WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brUnidNegoc 1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brUnidNegoc
/* Query rebuild information for BROWSE brUnidNegoc
     _TblList          = "mgesp.int-user-coml"
     _Options          = "NO-LOCK"
     _Where[1]         = "mgesp.int-user-coml.cd-usuario = INPUT FRAME fPage0 c-usuario"
     _FldNameList[1]   > mgesp.int-user-coml.cd-unid-negoc
"cd-unid-negoc" ? ? "character" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" ""
     _FldNameList[2]   > "_<CALC>"
"fnDsUnidNegoc(int-user-coml.cd-unid-negoc) @ c-ds-unid-comerc" "Descri‡Æo" "x(40)" ? ? ? ? ? ? ? no ? no no "68.14" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brUnidNegoc */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
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


&Scoped-define SELF-NAME btClose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btClose wWindow
ON CHOOSE OF btClose IN FRAME fPage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btExcluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcluir wWindow
ON CHOOSE OF btExcluir IN FRAME fPage1 /* Excluir */
DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 550,
                       INPUT "":U).

    IF  RETURN-VALUE = "YES" THEN DO:
        FIND CURRENT int-user-coml EXCLUSIVE-LOCK NO-ERROR.
        IF  AVAIL  int-user-coml THEN
            DELETE int-user-coml.

        RUN pi-atualizar IN THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btIncluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIncluir wWindow
ON CHOOSE OF btIncluir IN FRAME fPage1 /* Incluir */
DO:
    ASSIGN INPUT FRAME fPage0 c-usuario.

    RUN upc/cd0821-upc01a.w (INPUT c-usuario).

    RUN pi-atualizar IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME c-usuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-usuario wWindow
ON LEAVE OF c-usuario IN FRAME fPage0 /* Usu rio */
DO:
    ASSIGN INPUT FRAME fPage0 c-usuario.

    FIND FIRST usuar_mestre NO-LOCK
        WHERE  usuar_mestre.cod_usuario = c-usuario NO-ERROR.

    ASSIGN c-nm-usuario = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "".

    DISP c-nm-usuario WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brUnidNegoc
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

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

    ASSIGN c-usuario = pUsuario.

    DISPLAY c-usuario WITH FRAME fPage0.

    ENABLE brUnidNegoc
           btIncluir
        WITH FRAME fPage1.

    RUN pi-atualizar IN THIS-PROCEDURE.

    APPLY "LEAVE":U TO c-usuario IN FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualizar wWindow 
PROCEDURE pi-atualizar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {&OPEN-QUERY-brUnidNegoc}

    IF  CAN-FIND(FIRST int-user-coml NO-LOCK
                 WHERE int-user-coml.cd-usuario = INPUT FRAME fPage0 c-usuario) THEN
        ENABLE btExcluir WITH FRAME fPage1.
    ELSE
        DISABLE btExcluir WITH FRAME fPage1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDsUnidNegoc wWindow 
FUNCTION fnDsUnidNegoc RETURNS CHARACTER
  ( pCod-unid-comerc AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST unid-comerc NO-LOCK
        WHERE  unid-comerc.cd-unid-comerc = INT(pCod-unid-comerc) NO-ERROR.

    ASSIGN c-ds-unid-comerc = IF AVAIL unid-comerc THEN unid-comerc.ds-unid-comerc ELSE "".

    RETURN c-ds-unid-comerc.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

