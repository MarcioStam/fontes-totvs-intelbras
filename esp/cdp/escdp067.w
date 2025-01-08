&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*****************************************************************************
** Programa: esp/cdp/escdp067.w
** Vers∆o..: 1.00
** Data....: 27/11/2013
** Autor...: Estevan KrÅger - Sensus
** Obs.....: Consulta de clientes que entregaram a Declaraá∆o de Forma de Tributaá∆o
*****************************************************************************/
{include/i-prgvrs.i ESCDP067 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP067
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-tributacao        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-tipoDeclaracao    AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brClientes

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES int-emitente-trib emitente int-emitente

/* Definitions for BROWSE brClientes                                    */
&Scoped-define FIELDS-IN-QUERY-brClientes emitente.cod-emitente ~
emitente.cgc int-emitente-trib.raiz-cnpj emitente.nome-abrev ~
emitente.nome-emit int-emitente-trib.ind-declaracao ~
fnTipoDeclara(int-emitente-trib.ind-tipo-declaracao) @ c-tipoDeclaracao ~
int-emitente-trib.dt-copia-declaracao int-emitente-trib.ordem-arq ~
fnTributacao(int-emitente.ind-forma-tributo) @ c-tributacao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brClientes 
&Scoped-define QUERY-STRING-brClientes FOR EACH int-emitente-trib ~
      WHERE int-emitente-trib.raiz-cnpj <> "01" ~
 AND int-emitente-trib.raiz-cnpj >= INPUT FRAME fPage0 c-raiz-cnpj-ini ~
 AND int-emitente-trib.raiz-cnpj <= INPUT FRAME fPage0 c-raiz-cnpj-fim NO-LOCK, ~
      EACH emitente WHERE emitente.cgc BEGINS int-emitente-trib.raiz-cnpj NO-LOCK, ~
      FIRST int-emitente OF emitente NO-LOCK ~
    BY int-emitente-trib.raiz-cnpj ~
       BY emitente.cgc INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brClientes OPEN QUERY brClientes FOR EACH int-emitente-trib ~
      WHERE int-emitente-trib.raiz-cnpj <> "01" ~
 AND int-emitente-trib.raiz-cnpj >= INPUT FRAME fPage0 c-raiz-cnpj-ini ~
 AND int-emitente-trib.raiz-cnpj <= INPUT FRAME fPage0 c-raiz-cnpj-fim NO-LOCK, ~
      EACH emitente WHERE emitente.cgc BEGINS int-emitente-trib.raiz-cnpj NO-LOCK, ~
      FIRST int-emitente OF emitente NO-LOCK ~
    BY int-emitente-trib.raiz-cnpj ~
       BY emitente.cgc INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brClientes int-emitente-trib emitente ~
int-emitente
&Scoped-define FIRST-TABLE-IN-QUERY-brClientes int-emitente-trib
&Scoped-define SECOND-TABLE-IN-QUERY-brClientes emitente
&Scoped-define THIRD-TABLE-IN-QUERY-brClientes int-emitente


/* Definitions for FRAME fPage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage0 ~
    ~{&OPEN-QUERY-brClientes}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btQueryJoins btReportsJoins btExit btHelp ~
c-raiz-cnpj-ini c-raiz-cnpj-fim btCheck brClientes rtToolBar-2 IMAGE-1 ~
IMAGE-2 
&Scoped-Define DISPLAYED-OBJECTS c-raiz-cnpj-ini c-raiz-cnpj-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTipoDeclara wWindow 
FUNCTION fnTipoDeclara RETURNS CHARACTER
  (pTipo AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTributacao wWindow 
FUNCTION fnTributacao RETURNS CHARACTER
  (pTributacao AS INTEGER)  FORWARD.

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
DEFINE BUTTON btCheck 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "Atualizar" 
     SIZE 5.29 BY 1 TOOLTIP "Atualizar informaá‰es".

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

DEFINE VARIABLE c-raiz-cnpj-fim AS CHARACTER FORMAT "x(10)" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-raiz-cnpj-ini AS CHARACTER FORMAT "x(10)" 
     LABEL "Raiz CNPJ" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .75.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .75.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 118.72 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brClientes FOR 
      int-emitente-trib, 
      emitente, 
      int-emitente SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brClientes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brClientes wWindow _STRUCTURED
  QUERY brClientes NO-LOCK DISPLAY
      emitente.cod-emitente FORMAT ">>>>>>>>9":U
      emitente.cgc COLUMN-LABEL "CNPJ" FORMAT "x(19)":U WIDTH 14
      int-emitente-trib.raiz-cnpj COLUMN-LABEL "Raiz" FORMAT "x(8)":U
            WIDTH 9.43
      emitente.nome-abrev COLUMN-LABEL "Nome Abrev" FORMAT "X(12)":U
            WIDTH 13.57
      emitente.nome-emit FORMAT "x(80)":U WIDTH 36
      int-emitente-trib.ind-declaracao COLUMN-LABEL "Entregue?" FORMAT "Sim/N∆o":U
            WIDTH 8.57
      fnTipoDeclara(int-emitente-trib.ind-tipo-declaracao) @ c-tipoDeclaracao COLUMN-LABEL "Tipo Declaraá∆o" FORMAT "x(06)":U
      int-emitente-trib.dt-copia-declaracao FORMAT "99/99/9999":U
      int-emitente-trib.ordem-arq FORMAT "x(50)":U WIDTH 8.57
      fnTributacao(int-emitente.ind-forma-tributo) @ c-tributacao COLUMN-LABEL "Tributaá∆o" FORMAT "x(16)":U
            WIDTH 10.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 117 BY 16.21
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btQueryJoins AT ROW 1.13 COL 103.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 107.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 111.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 115.57 HELP
          "Ajuda"
     c-raiz-cnpj-ini AT ROW 2.92 COL 36.72 COLON-ALIGNED HELP
          "Raiz do CNPJ" WIDGET-ID 42
     c-raiz-cnpj-fim AT ROW 2.92 COL 64 COLON-ALIGNED HELP
          "Raiz do CNPJ" NO-LABEL WIDGET-ID 44
     btCheck AT ROW 2.83 COL 83.29 WIDGET-ID 28
     brClientes AT ROW 4.21 COL 2 WIDGET-ID 200
     rtToolBar-2 AT ROW 1 COL 1
     IMAGE-1 AT ROW 3 COL 51.57 WIDGET-ID 16
     IMAGE-2 AT ROW 3 COL 62.29 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 118.72 BY 20
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
         HEIGHT             = 20
         WIDTH              = 118.72
         MAX-HEIGHT         = 27.5
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 27.5
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
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB brClientes btCheck fPage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brClientes
/* Query rebuild information for BROWSE brClientes
     _TblList          = "mgesp.int-emitente-trib,mgcad.emitente WHERE mgesp.int-emitente-trib ...,mgesp.int-emitente OF mgcad.emitente"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ",, FIRST"
     _OrdList          = "mgesp.int-emitente-trib.raiz-cnpj|yes,mgcad.emitente.cgc|yes"
     _Where[1]         = "mgesp.int-emitente-trib.raiz-cnpj <> ""01""
 AND mgesp.int-emitente-trib.raiz-cnpj >= INPUT FRAME fPage0 c-raiz-cnpj-ini
 AND mgesp.int-emitente-trib.raiz-cnpj <= INPUT FRAME fPage0 c-raiz-cnpj-fim"
     _JoinCode[2]      = "mgcad.emitente.cgc BEGINS mgesp.int-emitente-trib.raiz-cnpj"
     _FldNameList[1]   = mgcad.emitente.cod-emitente
     _FldNameList[2]   > mgcad.emitente.cgc
"mgcad.emitente.cgc" "CNPJ" ? "character" ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > mgesp.int-emitente-trib.raiz-cnpj
"mgesp.int-emitente-trib.raiz-cnpj" "Raiz" ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > mgcad.emitente.nome-abrev
"mgcad.emitente.nome-abrev" "Nome Abrev" ? "character" ? ? ? ? ? ? no ? no no "13.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > mgcad.emitente.nome-emit
"mgcad.emitente.nome-emit" ? ? "character" ? ? ? ? ? ? no ? no no "36" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > mgesp.int-emitente-trib.ind-declaracao
"mgesp.int-emitente-trib.ind-declaracao" "Entregue?" ? "logical" ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fnTipoDeclara(int-emitente-trib.ind-tipo-declaracao) @ c-tipoDeclaracao" "Tipo Declaraá∆o" "x(06)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = mgesp.int-emitente-trib.dt-copia-declaracao
     _FldNameList[9]   > mgesp.int-emitente-trib.ordem-arq
"mgesp.int-emitente-trib.ordem-arq" ? ? "character" ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"fnTributacao(int-emitente.ind-forma-tributo) @ c-tributacao" "Tributaá∆o" "x(16)" ? ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brClientes */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
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


&Scoped-define SELF-NAME btCheck
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck wWindow
ON CHOOSE OF btCheck IN FRAME fPage0 /* Atualizar */
DO:
    {&OPEN-QUERY-brClientes}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-raiz-cnpj-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-raiz-cnpj-fim wWindow
ON LEAVE OF c-raiz-cnpj-fim IN FRAME fPage0
DO:
    FIND FIRST emitente NO-LOCK
        WHERE  emitente.cod-emitente = INT(INPUT FRAME fPage0 c-raiz-cnpj-fim) NO-ERROR.
    IF  AVAIL  emitente THEN
        ASSIGN c-raiz-cnpj-fim:SCREEN-VALUE IN FRAME fPage0 = SUBSTRING(emitente.cgc,1,8).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-raiz-cnpj-fim wWindow
ON RETURN OF c-raiz-cnpj-fim IN FRAME fPage0
DO:
    APPLY "LEAVE":U  TO SELF.
    APPLY "CHOOSE":U TO btCheck IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-raiz-cnpj-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-raiz-cnpj-ini wWindow
ON LEAVE OF c-raiz-cnpj-ini IN FRAME fPage0 /* Raiz CNPJ */
DO:
    FIND FIRST emitente NO-LOCK
        WHERE  emitente.cod-emitente = INT(INPUT FRAME fPage0 c-raiz-cnpj-ini) NO-ERROR.
    IF  AVAIL  emitente THEN
        ASSIGN c-raiz-cnpj-ini:SCREEN-VALUE IN FRAME fPage0 = SUBSTRING(emitente.cgc,1,8).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-raiz-cnpj-ini wWindow
ON RETURN OF c-raiz-cnpj-ini IN FRAME fPage0 /* Raiz CNPJ */
DO:
    APPLY "LEAVE":U  TO SELF.
    APPLY "CHOOSE":U TO btCheck IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brClientes
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
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

    ASSIGN c-raiz-cnpj-ini:SCREEN-VALUE IN FRAME fPage0 = ""
           c-raiz-cnpj-fim:SCREEN-VALUE IN FRAME fPage0 = "ZZZZZZZZ".

    ENABLE c-raiz-cnpj-ini
           c-raiz-cnpj-fim
           btCheck
           brClientes
        WITH FRAME fPage0.

/*     {&OPEN-QUERY-brClientes} */

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTipoDeclara wWindow 
FUNCTION fnTipoDeclara RETURNS CHARACTER
  (pTipo AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    CASE pTipo:
        WHEN 1 THEN
            ASSIGN c-tipoDeclaracao = "Original".
        WHEN 2 THEN
            ASSIGN c-tipoDeclaracao = "C¢pia".
        WHEN ? THEN
            ASSIGN c-tipoDeclaracao = "".
        WHEN 0 THEN
            ASSIGN c-tipoDeclaracao = "".
    END CASE.

    RETURN c-tipoDeclaracao.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTributacao wWindow 
FUNCTION fnTributacao RETURNS CHARACTER
  (pTributacao AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    CASE pTributacao:
        WHEN 1 THEN
            ASSIGN c-tributacao = "Lucro Real".
        WHEN 2 THEN
            ASSIGN c-tributacao = "Lucro Presumido".
        WHEN 3 THEN
            ASSIGN c-tributacao = "Simples".
        WHEN 4 THEN
            ASSIGN c-tributacao = "Nenhum".
        WHEN 4 THEN
            ASSIGN c-tributacao = "Isento".
    END CASE.

    RETURN c-tributacao.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

