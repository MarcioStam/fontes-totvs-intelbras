&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i ESCLT008B 1.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCLT008B
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btCancel bt-so-caixa bt-todas-caixas
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE OUTPUT PARAMETER p-selec AS CHAR  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-so-caixa bt-todas-caixas btCancel lb1 lb2 ~
lb3 lb4 
&Scoped-Define DISPLAYED-OBJECTS lb1 lb2 lb3 lb4 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-so-caixa 
     LABEL "Desvincular Somente esta Caixa" 
     SIZE-PIXELS 217 BY 24
     FONT 4.

DEFINE BUTTON bt-todas-caixas 
     LABEL "Desvincular Todas as Caixas do Pallet" 
     SIZE-PIXELS 217 BY 24
     FONT 4.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE-PIXELS 70 BY 24
     FONT 4.

DEFINE VARIABLE lb1 AS CHARACTER FORMAT "X(256)":U INITIAL "Caixa n∆o pode ser relacionada a NF pois a Caixa est†" 
      VIEW-AS TEXT 
     SIZE-PIXELS 273 BY 16
     FONT 4 NO-UNDO.

DEFINE VARIABLE lb2 AS CHARACTER FORMAT "X(256)":U INITIAL "relacionada a Pallet. ê poss°vel desvincular apenas esta" 
      VIEW-AS TEXT 
     SIZE-PIXELS 273 BY 16
     FONT 4 NO-UNDO.

DEFINE VARIABLE lb3 AS CHARACTER FORMAT "X(256)":U INITIAL " caixa ou todas as caixas do Pallet. Selecione a forma que" 
      VIEW-AS TEXT 
     SIZE-PIXELS 294 BY 16
     FONT 4 NO-UNDO.

DEFINE VARIABLE lb4 AS CHARACTER FORMAT "X(256)":U INITIAL "deseja desvincular conforme bot‰es abaixo." 
      VIEW-AS TEXT 
     SIZE-PIXELS 217 BY 16
     FONT 4 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-so-caixa AT Y 132 X 49
     bt-todas-caixas AT Y 180 X 49
     btCancel AT Y 258 X 7 WIDGET-ID 8
     lb1 AT Y 12 X 0 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     lb2 AT Y 36 X 0 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     lb3 AT Y 60 X 0 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     lb4 AT Y 84 X 0 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     SPACE(0.00) SKIP(4.41)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 0 Y 0 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

DEFINE FRAME fPage1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 4 ROW 7
         SIZE 2.72 BY 2.58
         FONT 1 WIDGET-ID 100.


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
         HEIGHT-P           = 300
         WIDTH-P            = 320
         MAX-HEIGHT-P       = 408
         MAX-WIDTH-P        = 731
         VIRTUAL-HEIGHT-P   = 408
         VIRTUAL-WIDTH-P    = 731
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 4
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Size-to-Fit                                               */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fPage1:MOVE-AFTER-TAB-ITEM (bt-so-caixa:HANDLE IN FRAME fpage0)
       XXTABVALXX = FRAME fPage1:MOVE-BEFORE-TAB-ITEM (bt-todas-caixas:HANDLE IN FRAME fpage0)
/* END-ASSIGN-TABS */.

ASSIGN 
       FRAME fpage0:SCROLLABLE       = FALSE.

/* SETTINGS FOR FRAME fPage1
                                                                        */
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


&Scoped-define SELF-NAME bt-so-caixa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-so-caixa wWindow
ON CHOOSE OF bt-so-caixa IN FRAME fpage0 /* Desvincular Somente esta Caixa */
DO:

    ASSIGN p-selec = "uma".

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-todas-caixas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-todas-caixas wWindow
ON CHOOSE OF bt-todas-caixas IN FRAME fpage0 /* Desvincular Todas as Caixas do Pallet */
DO:

    ASSIGN p-selec = "todas".

    APPLY "CLOSE":U TO THIS-PROCEDURE.
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN p-selec = "".

    DO WITH FRAME fPage0:

        ASSIGN lb1:SCREEN-VALUE = "Caixa n∆o pode ser relacionada a NF pois a Caixa est†"
               lb2:SCREEN-VALUE = "relacionada a Pallet. ê poss°vel desvincular apenas esta"
               lb3:SCREEN-VALUE = "caixa ou todas as caixas do Pallet. Selecione a forma que"
               lb4:SCREEN-VALUE = "deseja desvincular conforme bot‰es abaixo.".


    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

