&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i ESCDP053 1.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP053
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              fi-fab-origem fi-fab-destino bt-vapara-ori bt-vapara-dest bt-item bt-tudo br-ori br-dest
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE BUFFER b-item-fab-destino FOR item-fabric.

DEFINE TEMP-TABLE tt-item-fab-origem LIKE item-fabric
    FIELD selec AS LOGICAL FORMAT "*/".

DEFINE VARIABLE c-desc-item AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-dest

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES b-item-fab-destino tt-item-fab-origem

/* Definitions for BROWSE br-dest                                       */
&Scoped-define FIELDS-IN-QUERY-br-dest b-item-fab-destino.it-codigo b-item-fab-destino.it-fabric f-desc-item(b-item-fab-destino.it-codigo) @ c-desc-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-dest   
&Scoped-define SELF-NAME br-dest
&Scoped-define QUERY-STRING-br-dest FOR EACH b-item-fab-destino     WHERE b-item-fab-destino.cod-fabric = INPUT FRAME {&FRAME-NAME} fi-fab-destino
&Scoped-define OPEN-QUERY-br-dest OPEN QUERY {&SELF-NAME} FOR EACH b-item-fab-destino     WHERE b-item-fab-destino.cod-fabric = INPUT FRAME {&FRAME-NAME} fi-fab-destino.
&Scoped-define TABLES-IN-QUERY-br-dest b-item-fab-destino
&Scoped-define FIRST-TABLE-IN-QUERY-br-dest b-item-fab-destino


/* Definitions for BROWSE br-ori                                        */
&Scoped-define FIELDS-IN-QUERY-br-ori tt-item-fab-origem.selec tt-item-fab-origem.it-codigo tt-item-fab-origem.it-fabric f-desc-item(tt-item-fab-origem.it-codigo) @ c-desc-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-ori   
&Scoped-define SELF-NAME br-ori
&Scoped-define QUERY-STRING-br-ori FOR EACH tt-item-fab-origem
&Scoped-define OPEN-QUERY-br-ori OPEN QUERY {&SELF-NAME} FOR EACH tt-item-fab-origem.
&Scoped-define TABLES-IN-QUERY-br-ori tt-item-fab-origem
&Scoped-define FIRST-TABLE-IN-QUERY-br-ori tt-item-fab-origem


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-dest}~
    ~{&OPEN-QUERY-br-ori}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btQueryJoins btReportsJoins ~
btExit btHelp bt-vapara-ori bt-vapara-dest fi-fab-origem fi-fab-destino ~
br-ori br-dest bt-item bt-tudo 
&Scoped-Define DISPLAYED-OBJECTS fi-fab-origem fi-fab-destino ~
fi-desc-origem fi-desc-destino 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-desc-item wWindow 
FUNCTION f-desc-item RETURNS CHARACTER
  ( INPUT p-it-codigo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
DEFINE BUTTON bt-item 
     IMAGE-UP FILE "adeicon/next-u.bmp":U
     LABEL "Button 3" 
     SIZE 7 BY 2.

DEFINE BUTTON bt-tudo 
     IMAGE-UP FILE "adeicon/forwrd-u.bmp":U
     LABEL "Button 4" 
     SIZE 7 BY 2.

DEFINE BUTTON bt-vapara-dest 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "Button 5" 
     SIZE 6 BY 1.13.

DEFINE BUTTON bt-vapara-ori 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "Button 4" 
     SIZE 6 BY 1.13.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

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

DEFINE VARIABLE fi-desc-destino AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nome Destino" 
     VIEW-AS FILL-IN 
     SIZE 37 BY 1 NO-UNDO.

DEFINE VARIABLE fi-desc-origem AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nome Origem" 
     VIEW-AS FILL-IN 
     SIZE 37 BY 1 NO-UNDO.

DEFINE VARIABLE fi-fab-destino AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Fabricante Destino" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY 1 NO-UNDO.

DEFINE VARIABLE fi-fab-origem AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Fabricante Origem" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY 1 NO-UNDO.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 113 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-dest FOR 
      b-item-fab-destino SCROLLING.

DEFINE QUERY br-ori FOR 
      tt-item-fab-origem SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-dest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-dest wWindow _FREEFORM
  QUERY br-dest DISPLAY
      b-item-fab-destino.it-codigo
b-item-fab-destino.it-fabric                                COLUMN-LABEL "Item Fabricante"
f-desc-item(b-item-fab-destino.it-codigo) @ c-desc-item     COLUMN-LABEL "Descriá∆o"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 51 BY 16.25
         FONT 1.

DEFINE BROWSE br-ori
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-ori wWindow _FREEFORM
  QUERY br-ori DISPLAY
      tt-item-fab-origem.selec                              COLUMN-LABEL "*"
tt-item-fab-origem.it-codigo
tt-item-fab-origem.it-fabric                                COLUMN-LABEL "Item Fabricante"
f-desc-item(tt-item-fab-origem.it-codigo) @ c-desc-item     COLUMN-LABEL "Descriá∆o"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 51 BY 16.25
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 97.29 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 101.29 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 105.29 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 109.29 HELP
          "Ajuda"
     bt-vapara-ori AT ROW 2.67 COL 28.14 WIDGET-ID 18
     bt-vapara-dest AT ROW 2.67 COL 88 WIDGET-ID 20
     fi-fab-origem AT ROW 2.75 COL 14 COLON-ALIGNED WIDGET-ID 2
     fi-fab-destino AT ROW 2.75 COL 74 COLON-ALIGNED WIDGET-ID 6
     fi-desc-origem AT ROW 4 COL 14 COLON-ALIGNED WIDGET-ID 22
     fi-desc-destino AT ROW 4 COL 74 COLON-ALIGNED WIDGET-ID 24
     br-ori AT ROW 5.25 COL 2 WIDGET-ID 200
     br-dest AT ROW 5.25 COL 62 WIDGET-ID 300
     bt-item AT ROW 9 COL 54 WIDGET-ID 14
     bt-tudo AT ROW 12 COL 54 WIDGET-ID 16
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 113.14 BY 20.75
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 57 ROW 2.75
         SIZE 3.43 BY 1
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
         HEIGHT             = 20.75
         WIDTH              = 113.14
         MAX-HEIGHT         = 20.75
         MAX-WIDTH          = 113.14
         VIRTUAL-HEIGHT     = 20.75
         VIRTUAL-WIDTH      = 113.14
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB br-ori fi-desc-destino fpage0 */
/* BROWSE-TAB br-dest br-ori fpage0 */
/* SETTINGS FOR FILL-IN fi-desc-destino IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-origem IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME fPage1:SENSITIVE        = FALSE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-dest
/* Query rebuild information for BROWSE br-dest
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH b-item-fab-destino
    WHERE b-item-fab-destino.cod-fabric = INPUT FRAME {&FRAME-NAME} fi-fab-destino.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-dest */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-ori
/* Query rebuild information for BROWSE br-ori
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-item-fab-origem.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-ori */
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


&Scoped-define BROWSE-NAME br-ori
&Scoped-define SELF-NAME br-ori
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ori wWindow
ON MOUSE-SELECT-DBLCLICK OF br-ori IN FRAME fpage0
DO:

    APPLY "return" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ori wWindow
ON RETURN OF br-ori IN FRAME fpage0
DO:

    ASSIGN tt-item-fab-origem.selec = NOT tt-item-fab-origem.selec.

    br-ori:REFRESH().
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-item wWindow
ON CHOOSE OF bt-item IN FRAME fpage0 /* Button 3 */
DO:

    RUN pi-val-origem.
    IF RETURN-VALUE <> "OK" THEN
        RETURN "NOK".

    RUN pi-val-destino.
    IF RETURN-VALUE <> "OK" THEN
        RETURN "NOK".


    RUN pi-transf (INPUT FALSE).
    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-tudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-tudo wWindow
ON CHOOSE OF bt-tudo IN FRAME fpage0 /* Button 4 */
DO:

    RUN pi-val-origem.
    IF RETURN-VALUE <> "OK" THEN
        RETURN "NOK".

    RUN pi-val-destino.
    IF RETURN-VALUE <> "OK" THEN
        RETURN "NOK".


    RUN pi-transf (INPUT TRUE).
    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-vapara-dest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-vapara-dest wWindow
ON CHOOSE OF bt-vapara-dest IN FRAME fpage0 /* Button 5 */
DO:

    RUN pi-val-destino.

   {&open-query-br-dest}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-vapara-ori
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-vapara-ori wWindow
ON CHOOSE OF bt-vapara-ori IN FRAME fpage0 /* Button 4 */
DO:

    EMPTY TEMP-TABLE tt-item-fab-origem.
 
    RUN pi-val-origem.

    IF RETURN-VALUE = "OK" THEN DO:

        FOR EACH item-fabric NO-LOCK
            WHERE item-fabric.cod-fabric = INPUT FRAME {&FRAME-NAME} fi-fab-origem:
    
            CREATE tt-item-fab-origem.
            BUFFER-COPY item-fabric TO tt-item-fab-origem.
            ASSIGN tt-item-fab-origem.selec = FALSE.
    
        END.

    END.

    {&open-query-br-ori}
                            
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define SELF-NAME fi-fab-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fab-destino wWindow
ON F5 OF fi-fab-destino IN FRAME fpage0 /* Fabricante Destino */
DO:

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es077.w"
                         &FieldZoom1="cod-fabric"
                         &FieldScreen1="fi-fab-destino"
                         &Frame1="fPage0"
                         &FieldZoom2="nome-abrev"
                         &FieldScreen2="fi-desc-destino"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fab-destino wWindow
ON LEAVE OF fi-fab-destino IN FRAME fpage0 /* Fabricante Destino */
DO:

    ASSIGN fi-desc-destino:SCREEN-VALUE = "".

    FOR FIRST fabricante NO-LOCK
        WHERE fabricante.cod-fabric = INPUT FRAME {&FRAME-NAME} fi-fab-destino:

        ASSIGN fi-desc-destino:SCREEN-VALUE = fabricante.nome-abrev.
        
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fab-destino wWindow
ON LEFT-MOUSE-DBLCLICK OF fi-fab-destino IN FRAME fpage0 /* Fabricante Destino */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-fab-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fab-origem wWindow
ON F5 OF fi-fab-origem IN FRAME fpage0 /* Fabricante Origem */
DO:

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es077.w"
                         &FieldZoom1="cod-fabric"
                         &FieldScreen1="fi-fab-origem"
                         &Frame1="fPage0"
                         &FieldZoom2="nome-abrev"
                         &FieldScreen2="fi-desc-origem"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fab-origem wWindow
ON LEAVE OF fi-fab-origem IN FRAME fpage0 /* Fabricante Origem */
DO:

    ASSIGN fi-desc-origem:SCREEN-VALUE = "".

    FOR FIRST fabricante NO-LOCK
        WHERE fabricante.cod-fabric = INPUT FRAME {&FRAME-NAME} fi-fab-origem:

        ASSIGN fi-desc-origem:SCREEN-VALUE = fabricante.nome-abrev.
        
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fab-origem wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-fab-origem IN FRAME fpage0 /* Fabricante Origem */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-dest
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}


fi-fab-origem:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
fi-fab-destino:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-transf wWindow 
PROCEDURE pi-transf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-todos AS LOGICAL NO-UNDO.


    /* Validaá‰es */

    IF INPUT FRAME {&FRAME-NAME} fi-fab-origem = INPUT FRAME {&FRAME-NAME} fi-fab-destino THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Fabricante Origem e Fabricante Destino devem ser diferentes.").

        APPLY "entry" TO fi-fab-origem.

        RETURN "NOK":u.

    END.


    /* Transferància */

    DO TRANS:
    
        FOR EACH tt-item-fab-origem EXCLUSIVE-LOCK
            WHERE tt-item-fab-origem.cod-fabric = INPUT FRAME {&frame-name} fi-fab-origem
            AND  (p-todos OR NOT p-todos AND tt-item-fab-origem.selec = TRUE):
    
            FOR FIRST b-item-fab-destino NO-LOCK
                WHERE b-item-fab-destino.cod-fabric = INPUT FRAME {&frame-name} fi-fab-destino
                AND   b-item-fab-destino.it-codigo = tt-item-fab-origem.it-codigo:
            END.
    
            IF NOT AVAIL b-item-fab-destino THEN DO:
    
                FOR FIRST item-fabric EXCLUSIVE-LOCK
                    WHERE item-fabric.cod-fabric = tt-item-fab-origem.cod-fabric
                    AND   item-fabric.it-codigo = tt-item-fab-origem.it-codigo:
                END.
    
                ASSIGN item-fabric.cod-fabric = INPUT FRAME {&frame-name} fi-fab-destino.
    
            END.
    
            DELETE tt-item-fab-origem.
    
        END.

    END.

    {&open-query-br-ori}
    {&open-query-br-dest}

    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 19085,
                       INPUT "Processo executado com sucesso.").

    RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-val-destino wWindow 
PROCEDURE pi-val-destino :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  INPUT FRAME {&FRAME-NAME} fi-fab-destino = 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Fabricante Destino n∆o pode ser 0 (zero)").

        APPLY "entry" TO fi-fab-destino.

        RETURN "NOK":u.
    END.


    FOR FIRST fabricante NO-LOCK
        WHERE fabricante.cod-fabric = INPUT FRAME {&FRAME-NAME} fi-fab-destino:
    END.

    IF NOT AVAIL fabricante THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 56,
                           INPUT "Fabricante Destino").

        APPLY "entry" TO fi-fab-destino.

        RETURN "NOK":u.

    END.
    
    IF  AVAIL fabricante AND NOT fabricante.ativo THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Fabricante Destino n∆o est† Ativo.").

        APPLY "entry" TO fi-fab-destino.

        RETURN "NOK":u.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-val-origem wWindow 
PROCEDURE pi-val-origem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  INPUT FRAME {&FRAME-NAME} fi-fab-origem = 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Fabricante Origem n∆o pode ser 0 (zero)").

        APPLY "entry" TO fi-fab-origem.

        RETURN "NOK":u.
    END.

    FOR FIRST fabricante NO-LOCK
        WHERE fabricante.cod-fabric = INPUT FRAME {&FRAME-NAME} fi-fab-origem:
    END.

    IF NOT AVAIL fabricante THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 56,
                           INPUT "Fabricante Origem").

        APPLY "entry" TO fi-fab-origem.

        RETURN "NOK":u.

    END.

    IF  AVAIL fabricante AND NOT fabricante.ativo THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Fabricante Origem n∆o est† Ativo.").

        APPLY "entry" TO fi-fab-origem.

        RETURN "NOK":u.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-desc-item wWindow 
FUNCTION f-desc-item RETURNS CHARACTER
  ( INPUT p-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = p-it-codigo:

        RETURN ITEM.desc-item.

    END.

    RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

