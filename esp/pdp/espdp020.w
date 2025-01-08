&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
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
{include/i-prgvrs.i ESPDP020 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESPDP020
&GLOBAL-DEFINE Version        2.04.00.001

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btGoto btSearch btAdd btReportsJoins btExit btHelp ~
                              btFechar btHelp2 br-alternativo btIncluir btExcluir
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE BUFFER b-it-altern FOR it-altern.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE c-it-codigo AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-alternativo

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES it-altern item

/* Definitions for BROWSE br-alternativo                                */
&Scoped-define FIELDS-IN-QUERY-br-alternativo it-altern.it-altern ~
item.desc-item 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-alternativo 
&Scoped-define QUERY-STRING-br-alternativo FOR EACH it-altern ~
      WHERE it-altern.it-codigo = c-it-codigo NO-LOCK, ~
      FIRST item WHERE item.it-codigo = it-altern.it-altern NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-alternativo OPEN QUERY br-alternativo FOR EACH it-altern ~
      WHERE it-altern.it-codigo = c-it-codigo NO-LOCK, ~
      FIRST item WHERE item.it-codigo = it-altern.it-altern NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-alternativo it-altern item
&Scoped-define FIRST-TABLE-IN-QUERY-br-alternativo it-altern
&Scoped-define SECOND-TABLE-IN-QUERY-br-alternativo item


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-alternativo}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-1 RECT-2 btGoto ~
btSearch btAdd btReportsJoins btExit btHelp fi-it-codigo fi-desc-item ~
br-alternativo btIncluir btExcluir btFechar btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-it-codigo fi-desc-item 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
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
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExcluir 
     LABEL "&Excluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFechar 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btGoto 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go to" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btIncluir 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

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

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "X(10)":U 
     LABEL "Item Venda" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 2.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 10.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-alternativo FOR 
      it-altern, 
      item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-alternativo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-alternativo wWindow _STRUCTURED
  QUERY br-alternativo NO-LOCK DISPLAY
      it-altern.it-altern COLUMN-LABEL "Item Alternativo" FORMAT "X(16)":U
            WIDTH 12.43
      item.desc-item FORMAT "x(60)":U WIDTH 66.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82.86 BY 8.5
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btGoto AT ROW 1.13 COL 1.72 HELP
          "V† Para" WIDGET-ID 6
     btSearch AT ROW 1.13 COL 5.72 HELP
          "Pesquisa" WIDGET-ID 8
     btAdd AT ROW 1.13 COL 9.86 HELP
          "Inclui nova ocorrància" WIDGET-ID 20
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     fi-it-codigo AT ROW 3.46 COL 16.43 COLON-ALIGNED WIDGET-ID 2
     fi-desc-item AT ROW 3.46 COL 27.86 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     br-alternativo AT ROW 5.5 COL 5 WIDGET-ID 200
     btIncluir AT ROW 14.13 COL 5 WIDGET-ID 14
     btExcluir AT ROW 14.13 COL 15 WIDGET-ID 18
     btFechar AT ROW 16.75 COL 2
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 16.54 COL 1
     RECT-1 AT ROW 2.88 COL 3.57 WIDGET-ID 10
     RECT-2 AT ROW 5.04 COL 3.72 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
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
         COLUMN             = 36.72
         ROW                = 7.83
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
         MAX-BUTTON         = no
         RESIZE             = no
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB br-alternativo fi-desc-item fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-alternativo
/* Query rebuild information for BROWSE br-alternativo
     _TblList          = "mgesp.it-altern,mgcad.item WHERE mgesp.it-altern ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _Where[1]         = "mgesp.it-altern.it-codigo = c-it-codigo"
     _JoinCode[2]      = "mgcad.item.it-codigo = mgesp.it-altern.it-altern"
     _FldNameList[1]   > mgesp.it-altern.it-altern
"it-altern.it-altern" "Item Alternativo" ? "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" ""
     _FldNameList[2]   > mgcad.item.desc-item
"item.desc-item" ? ? "character" ? ? ? ? ? ? no ? no no "66.72" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE br-alternativo */
&ANALYZE-RESUME

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


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wWindow
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
DO:
    DEFINE VARIABLE c-it-retorno AS CHARACTER   NO-UNDO.

    ASSIGN CURRENT-WINDOW:SENSITIVE = NO.
    RUN esp/pdp/espdp020a.w (INPUT "venda",
                             INPUT "",
                             OUTPUT c-it-retorno).
    ASSIGN CURRENT-WINDOW:SENSITIVE = YES.

    IF c-it-retorno <> "" THEN DO:
        ASSIGN c-it-codigo = c-it-retorno.

        FIND FIRST ITEM NO-LOCK 
             WHERE ITEM.it-codigo = c-it-codigo NO-ERROR.
        IF AVAIL ITEM THEN DO:
            ASSIGN fi-it-codigo:SCREEN-VALUE IN FRAME fPage0 = ITEM.it-codigo
                   fi-desc-item:SCREEN-VALUE IN FRAME fPage0 = ITEM.desc-item.
        END.

        {&open-query-br-alternativo}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcluir wWindow
ON CHOOSE OF btExcluir IN FRAME fpage0 /* Excluir */
DO:
    IF c-it-codigo <> "" THEN DO:
        IF AVAIL it-altern THEN DO:
            MESSAGE "Deseja excluir registro? "
                VIEW-AS ALERT-BOX INFO BUTTONS YES-NO TITLE "Exclus∆o?" UPDATE l-excluir AS LOGICAL.

            IF l-excluir THEN DO:
                FIND FIRST b-it-altern OF it-altern EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL b-it-altern THEN
                    DELETE b-it-altern.

                {&open-query-br-alternativo}

                IF NOT CAN-FIND(FIRST b-it-altern NO-LOCK WHERE b-it-altern.it-codigo = c-it-codigo) THEN DO:
                    ASSIGN fi-it-codigo:SCREEN-VALUE IN FRAME fPage0 = ""
                           fi-desc-item:SCREEN-VALUE IN FRAME fPage0 = ""
                           c-it-codigo = "".
                    IF AVAIL it-altern THEN RELEASE it-altern.
                END.
            END.
        END.
        ELSE DO:
            MESSAGE "Selecione o item alternativo para exclus∆o! "
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
    END.
    ELSE DO:
        MESSAGE "Selecione um item de venda!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFechar wWindow
ON CHOOSE OF btFechar IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoto wWindow
ON CHOOSE OF btGoto IN FRAME fpage0 /* Go to */
DO:
    RUN pi-gotorecord.

    {&open-query-br-alternativo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
DO:
    {include/ajuda.i}
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


&Scoped-define SELF-NAME btIncluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIncluir wWindow
ON CHOOSE OF btIncluir IN FRAME fpage0 /* Incluir */
DO:
    DEFINE VARIABLE c-it-retorno AS CHARACTER   NO-UNDO.

    IF c-it-codigo <> "" THEN DO:
        ASSIGN CURRENT-WINDOW:SENSITIVE = NO.
        RUN esp/pdp/espdp020a.w (INPUT "altern",
                                 INPUT c-it-codigo,
                                 OUTPUT c-it-retorno).
        ASSIGN CURRENT-WINDOW:SENSITIVE = YES.
    
        IF c-it-retorno <> "" THEN DO:
            ASSIGN c-it-codigo = c-it-retorno.
            {&open-query-br-alternativo}
        END.
    END.
    ELSE DO:
        MESSAGE "Selecione um item de venda!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wWindow
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es101.w"
                         &FieldZoom1="it-codigo"
                         &FieldScreen1="fi-it-codigo"
                         &Frame1="fPage0"
                         &EnableImplant="NO"}

    IF VALID-HANDLE(hProgramZoom) THEN
        WAIT-FOR CLOSE OF hProgramZoom.

    ASSIGN c-it-codigo = INPUT FRAME fPage0 fi-it-codigo.

    FIND FIRST ITEM NO-LOCK 
         WHERE ITEM.it-codigo = c-it-codigo NO-ERROR.
    IF AVAIL ITEM THEN
        ASSIGN fi-desc-item:SCREEN-VALUE IN FRAME fPage0 = ITEM.desc-item.
    ELSE
        ASSIGN fi-desc-item:SCREEN-VALUE IN FRAME fPage0 = "".

    {&open-query-br-alternativo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-alternativo
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gotorecord wWindow 
PROCEDURE pi-gotorecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE c-item LIKE ITEM.it-codigo LABEL "Item Venda" NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-item AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Item" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Item"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */
                                         
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-item .
        
        FIND FIRST it-altern NO-LOCK 
             WHERE it-altern.it-codigo = c-item NO-ERROR.
        IF NOT AVAIL it-altern THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Item n∆o encontrado!":U).
            RETURN NO-APPLY.
        END.

        FIND FIRST ITEM NO-LOCK 
             WHERE ITEM.it-codigo = c-item NO-ERROR.
        IF NOT AVAIL ITEM THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Item inv†lido!":U).
            RETURN NO-APPLY.
        END.
        
        ASSIGN fi-it-codigo:SCREEN-VALUE IN FRAME fPage0 = ITEM.it-codigo
               fi-desc-item:SCREEN-VALUE IN FRAME fPage0 = ITEM.desc-item
               c-it-codigo = c-item.

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-item  btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

