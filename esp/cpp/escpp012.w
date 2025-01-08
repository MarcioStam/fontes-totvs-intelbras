&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP012 2.00.00.001}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP012
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp bt-clr ~
                              btFechar btHelp2 br-etiqueta bt-excluir          ~
                              f-cod-etiqueta f-cod-etiqueta-filho
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-esapi003    AS HANDLE    NO-UNDO.
DEFINE VARIABLE g-etiq-pallet AS CHARACTER NO-UNDO.

{cdp/cd0666.i} /* tt-erros */
{esapi/esapi003tt.i}

RUN esapi/esapi003.p PERSISTENT SET h-esapi003.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-etiqueta

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ns-volume

/* Definitions for BROWSE br-etiqueta                                   */
&Scoped-define FIELDS-IN-QUERY-br-etiqueta tt-ns-volume.volume-filho tt-ns-volume.data tt-ns-volume.nome-usuar   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-etiqueta   
&Scoped-define SELF-NAME br-etiqueta
&Scoped-define QUERY-STRING-br-etiqueta FOR EACH tt-ns-volume
&Scoped-define OPEN-QUERY-br-etiqueta OPEN QUERY {&SELF-NAME} FOR EACH tt-ns-volume.
&Scoped-define TABLES-IN-QUERY-br-etiqueta tt-ns-volume
&Scoped-define FIRST-TABLE-IN-QUERY-br-etiqueta tt-ns-volume


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-etiqueta}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-33 RECT-34 ~
bt-excluir bt-clr bt-gravar btQueryJoins btReportsJoins btExit btHelp ~
f-cod-etiqueta f-tipo f-quantidade f-item f-desc-item f-cod-etiqueta-filho ~
br-etiqueta btFechar btHelp2 
&Scoped-Define DISPLAYED-OBJECTS f-cod-etiqueta f-tipo f-quantidade f-item ~
f-desc-item f-cod-etiqueta-filho 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnQtdeFilho wWindow 
FUNCTION fnQtdeFilho RETURNS INTEGER
  ( INPUT c-etiq-pai AS CHARACTER,
    INPUT c-etiq-filho AS CHARACTER )  FORWARD.

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
DEFINE BUTTON bt-clr 
     IMAGE-UP FILE "image/im-clr.bmp":U
     IMAGE-DOWN FILE "image/ii-clr1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-clr.bmp":U
     LABEL "Limpar" 
     SIZE 5 BY 1.25 TOOLTIP "Limpa campos em tela"
     FONT 4.

DEFINE BUTTON bt-excluir 
     IMAGE-UP FILE "image/im-era.bmp":U
     IMAGE-DOWN FILE "image/gr-eli.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-era.bmp":U
     LABEL "Excluir" 
     SIZE 5 BY 1.25 TOOLTIP "Elimina etiqueta(s)"
     FONT 4.

DEFINE BUTTON bt-gravar 
     IMAGE-UP FILE "image/im-sav.bmp":U
     IMAGE-DOWN FILE "image/ii-sav.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sav.bmp":U
     LABEL "Gravar" 
     SIZE 5 BY 1.25 TOOLTIP "Grava dados vinculados ao pallet"
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFechar 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

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

DEFINE VARIABLE f-cod-etiqueta AS CHARACTER FORMAT "X(13)":U 
     LABEL "Caixa/Pallet" 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .79 NO-UNDO.

DEFINE VARIABLE f-cod-etiqueta-filho AS CHARACTER FORMAT "X(13)":U 
     LABEL "Etiq.Filho" 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .79 NO-UNDO.

DEFINE VARIABLE f-desc-item AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 58.29 BY .79 NO-UNDO.

DEFINE VARIABLE f-item AS CHARACTER FORMAT "X(12)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE f-quantidade AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "Qtde." 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE f-tipo AS CHARACTER FORMAT "X(10)":U 
     LABEL "Tipo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.75.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.63.

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
DEFINE QUERY br-etiqueta FOR 
      tt-ns-volume SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-etiqueta wWindow _FREEFORM
  QUERY br-etiqueta DISPLAY
      tt-ns-volume.volume-filho  COLUMN-LABEL "C¢d.Etiqueta"
      tt-ns-volume.data                                                  WIDTH 15
      tt-ns-volume.nome-usuar    COLUMN-LABEL "Usu†rio"   FORMAT "X(40)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88 BY 7.5
         FONT 1 ROW-HEIGHT-CHARS .6 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-excluir AT ROW 1.13 COL 1.43 HELP
          "Elimina etiqueta(s)" WIDGET-ID 10
     bt-clr AT ROW 1.13 COL 5.57 HELP
          "Limpa campos em tela" WIDGET-ID 32
     bt-gravar AT ROW 1.13 COL 9.72 HELP
          "Grava dados vinculados ao pallet" WIDGET-ID 34
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     f-cod-etiqueta AT ROW 3.04 COL 11.86 COLON-ALIGNED WIDGET-ID 16
     f-tipo AT ROW 3.04 COL 45 COLON-ALIGNED WIDGET-ID 18
     f-quantidade AT ROW 3.04 COL 70.14 COLON-ALIGNED WIDGET-ID 20
     f-item AT ROW 4.21 COL 11.86 COLON-ALIGNED WIDGET-ID 22
     f-desc-item AT ROW 4.21 COL 20.72 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     f-cod-etiqueta-filho AT ROW 6 COL 39.43 COLON-ALIGNED WIDGET-ID 30
     br-etiqueta AT ROW 7.5 COL 2 WIDGET-ID 200
     btFechar AT ROW 16.75 COL 2
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 16.54 COL 1
     RECT-33 AT ROW 2.75 COL 1 WIDGET-ID 26
     RECT-34 AT ROW 5.58 COL 1 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 17.21
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
         HEIGHT             = 17.21
         WIDTH              = 90.14
         MAX-HEIGHT         = 17.21
         MAX-WIDTH          = 90.14
         VIRTUAL-HEIGHT     = 17.21
         VIRTUAL-WIDTH      = 90.14
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB br-etiqueta f-cod-etiqueta-filho fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-etiqueta
/* Query rebuild information for BROWSE br-etiqueta
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ns-volume.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-etiqueta */
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
    IF VALID-HANDLE(h-esapi003) THEN
        DELETE PROCEDURE h-esapi003.

    /* This event will close the window and terminate the procedure.  */
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-clr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-clr wWindow
ON CHOOSE OF bt-clr IN FRAME fpage0 /* Limpar */
DO:
    RUN piLimpar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-excluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excluir wWindow
ON CHOOSE OF bt-excluir IN FRAME fpage0 /* Excluir */
DO:
    RUN piExcluiVolume.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-gravar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-gravar wWindow
ON CHOOSE OF bt-gravar IN FRAME fpage0 /* Gravar */
DO:
    RUN piGravar.
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


&Scoped-define SELF-NAME btFechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFechar wWindow
ON CHOOSE OF btFechar IN FRAME fpage0 /* Fechar */
DO:
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


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
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


&Scoped-define SELF-NAME f-cod-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cod-etiqueta wWindow
ON RETURN OF f-cod-etiqueta IN FRAME fpage0 /* Caixa/Pallet */
DO:
    RUN piBuscaEtiq.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-cod-etiqueta-filho
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cod-etiqueta-filho wWindow
ON RETURN OF f-cod-etiqueta-filho IN FRAME fpage0 /* Etiq.Filho */
DO:
    RUN piLeituraEtiqFilho(YES).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-etiqueta
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

PROCEDURE WinExec EXTERNAL "kernel32.dll":U:
  DEF INPUT  PARAM prg_name                          AS CHARACTER.
  DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME fPage0:
    ASSIGN f-cod-etiqueta-filho:SENSITIVE = NO.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaEtiq wWindow 
PROCEDURE piBuscaEtiq :
/*------------------------------------------------------------------------------
  Purpose: Busca dados etiqueta pai e popula campos em tela
  Notes:   Carlos Daniel - 02/02/2016
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-etiq-pai   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-etiq-filho AS CHARACTER NO-UNDO.

EMPTY TEMP-TABLE tt-ns-volume.

RUN piBuscaEtiquetaPai IN h-esapi003 (INPUT  f-cod-etiqueta:SCREEN-VALUE IN FRAME fPage0,
                                      OUTPUT f-tipo,
                                      OUTPUT f-quantidade,
                                      OUTPUT f-item,
                                      OUTPUT f-desc-item,
                                      OUTPUT TABLE tt-ns-volume).

IF RETURN-VALUE = "OK" THEN DO:
    DISP f-tipo f-quantidade f-item f-desc-item WITH FRAME fPage0.

    FIND FIRST tt-ns-volume NO-ERROR.

    IF fnQtdeFilho(f-cod-etiqueta:SCREEN-VALUE,"") < INTEGER(f-quantidade) THEN DO:
        ASSIGN f-cod-etiqueta-filho:SENSITIVE = YES.
        APPLY "ENTRY" TO f-cod-etiqueta-filho IN FRAME fpage0.
    END.
    ELSE DO:
        ASSIGN f-cod-etiqueta-filho:SENSITIVE = NO.
        APPLY "ENTRY" TO f-cod-etiqueta.
    END.

    {&OPEN-QUERY-BR-ETIQUETA}
END.
ELSE DO:
    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 17006,
                       INPUT RETURN-VALUE).
    RUN piLimpar.
    RETURN "NOK".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piChamaLeituraPallet wWindow 
PROCEDURE piChamaLeituraPallet :
/*------------------------------------------------------------------------------
  Purpose: Cria dialog para receber leitura etiqueta de pallet    
  Notes:   Carlos Daniel - 04/02/2016
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-etiq-pallet AS CHARACTER FORMAT "X(13)"
     LABEL "Etiq.Pallet"
     VIEW-AS FILL-IN 
     SIZE 15 BY .75 NO-UNDO.

DEFINE BUTTON btPalletCancel AUTO-END-KEY
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8.

DEFINE BUTTON btPalletOK 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8.

DEFINE RECTANGLE rtPalletButton
     EDGE-PIXELS 2 GRAPHIC-EDGE 
     SIZE 30 BY 1.42
     BGCOLOR 7.

DEFINE FRAME fPalletRecord
    c-etiq-pallet   AT ROW 1.21 COL 7.72 COLON-ALIGNED VIEW-AS FILL-IN FORMAT "X(13)"

    btPalletOK      AT ROW 2.63 COL 2.14
    btPalletCancel  AT ROW 2.63 COL 13
    rtPalletButton  AT ROW 2.38 COL 1
    SPACE(0.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
         THREE-D SCROLLABLE TITLE "Pallet" FONT 1
         DEFAULT-BUTTON btPalletOK CANCEL-BUTTON btPalletCancel.

ON "RETURN":U OF c-etiq-pallet IN FRAME fPalletRecord DO:
    ASSIGN c-etiq-pallet.

    ASSIGN g-etiq-pallet = c-etiq-pallet.
    APPLY "GO":U TO FRAME fPalletRecord.
END.

ENABLE c-etiq-pallet btPalletCancel
    WITH FRAME fPalletRecord.

WAIT-FOR "GO":U OF FRAME fPalletRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaVolume wWindow 
PROCEDURE piCriaVolume :
/*------------------------------------------------------------------------------
  Purpose: Cria registros tt-ns-volume conforme leitura das etiquetas
  Notes:   Carlos Daniel - 04/02/2016
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-etiqueta-pai   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER c-etiqueta-filho AS CHARACTER NO-UNDO.

DEFINE BUFFER bf-tt-ns-volume FOR tt-ns-volume.

DEFINE VARIABLE c-tipo AS CHARACTER NO-UNDO.

ASSIGN c-tipo = DYNAMIC-FUNCTION("fnRetornaTpEtiq" IN h-esapi003,c-etiqueta-filho).

FIND FIRST bf-tt-ns-volume WHERE bf-tt-ns-volume.tipo <> c-tipo NO-ERROR.
IF AVAIL bf-tt-ns-volume THEN DO:
    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 17006,
                       INPUT "Etiqueta inv†lida~~Essa etiqueta Ç de " + c-tipo + ", diferente das demais que foram lidas que s∆o do tipo " + bf-tt-ns-volume.tipo + ".").
    ASSIGN f-cod-etiqueta-filho:SCREEN-VALUE IN FRAME fPage0 = "".
    APPLY "ENTRY" TO f-cod-etiqueta-filho.
    RETURN "NOK".
END.

CREATE tt-ns-volume.
ASSIGN tt-ns-volume.volume-pai   = c-etiqueta-pai
       tt-ns-volume.volume-filho = c-etiqueta-filho
       tt-ns-volume.sequencia    = 1
       tt-ns-volume.data         = NOW
       tt-ns-volume.usuario      = c-seg-usuario
       tt-ns-volume.nome-usuar   = DYNAMIC-FUNCTION("fnRetornaNmUsuar" IN h-esapi003,tt-ns-volume.usuario)
       tt-ns-volume.tipo         = c-tipo.

{&OPEN-QUERY-BR-ETIQUETA}

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExcluiVolume wWindow 
PROCEDURE piExcluiVolume :
/*------------------------------------------------------------------------------
  Purpose: Chama rotina para eliminaá∆o dos vinculos da etiqueta selecionada    
  Notes:   Carlos Daniel - 10/02/2016
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-mensagem AS CHARACTER NO-UNDO.

IF f-tipo:SCREEN-VALUE IN FRAME fPage0 = "CAIXA" THEN
    ASSIGN c-mensagem = "Confirma desativaá∆o da etiqueta de CAIXA?~~Todos os N£meros de sÇrie ser∆o desvinculados desta CAIXA. Esta CAIXA ser† desvinculada do PALLET. A etiqueta de CAIXA dever† ser descartada.".
ELSE IF f-tipo:SCREEN-VALUE = "PALLET" THEN
    ASSIGN c-mensagem = "Confirma desativaá∆o da etiqueta de PALLET?~~Todas as CAIXAS ser∆o desvinculadas deste PALLET. A etiqueta de PALLET dever† ser descartada".

RUN utp/ut-msgs.p (INPUT "show",
                   INPUT 27100,
                   INPUT c-mensagem).

IF NOT LOGICAL(RETURN-VALUE) THEN
    RETURN.

RUN piExcluiVolume IN h-esapi003 (INPUT f-cod-etiqueta:SCREEN-VALUE IN FRAME fPage0).

IF RETURN-VALUE = "OK" THEN DO:
    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 15825,
                       INPUT "Etiqueta eliminada com sucesso~~Etiqueta eliminada com sucesso.").

    RUN piLimpar.
    RETURN "OK".
END.
ELSE DO:
    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 17006,
                       INPUT RETURN-VALUE).
    RETURN "NOK".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGravar wWindow 
PROCEDURE piGravar :
/*------------------------------------------------------------------------------
  Purpose: Grava dados vinculados ao pallet    
  Notes:   Carlos Daniel - 04/05/2016
------------------------------------------------------------------------------*/
RUN utp/ut-msgs.p (INPUT "show",
                   INPUT 27100,
                   INPUT "Confirmaá∆o~~O Pallet ainda n∆o est† completo, deseja finalizar assim mesmo?").

IF NOT LOGICAL(RETURN-VALUE) THEN
    RETURN.

RUN piGravaVolume IN h-esapi003 (INPUT TABLE tt-ns-volume).

IF RETURN-VALUE <> "OK" THEN DO:
    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 17006,
                       INPUT "Erro ao gravar etiqueta~~Erro ao gravar etiqueta.").
    RETURN "NOK".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGravaVolume wWindow 
PROCEDURE piGravaVolume :
/*------------------------------------------------------------------------------
  Purpose: Efetiva gravaá∆o dos registros na ns-volume
  Notes:   Carlos Daniel - 10/02/2016
------------------------------------------------------------------------------*/
RUN piGravaVolume IN h-esapi003 (INPUT TABLE tt-ns-volume).

IF RETURN-VALUE <> "OK" THEN DO:
    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 17006,
                       INPUT "Erro ao gravar etiqueta~~Erro ao gravar etiqueta.").
    RETURN "NOK".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLeituraEtiqFilho wWindow 
PROCEDURE piLeituraEtiqFilho :
/*------------------------------------------------------------------------------
  Purpose: Realiza validaá‰es leitura etiqueta filho    
  Notes:   Carlos Daniel - 04/02/2016
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER lcria_volume AS LOGICAL NO-UNDO.


DO WITH FRAME fPage0:
    
    IF DYNAMIC-FUNCTION("fnRetornaTpEtiq" IN h-esapi003,f-cod-etiqueta-filho:SCREEN-VALUE) = "PALLET"  THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Etiqueta inv†lida~~A etiqueta informada refere-se Ö um Pallet e n∆o pode ser utilizada como filha.").

        ASSIGN f-cod-etiqueta-filho:SCREEN-VALUE = "".
        RETURN "NOK".
    END.

    IF lcria_volume THEN DO:
        IF CAN-FIND(FIRST tt-ns-volume
                    WHERE tt-ns-volume.volume-filho = f-cod-etiqueta-filho:SCREEN-VALUE) THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Etiqueta inv†lida~~A etiqueta j† est† vinculada a Caixa/Pallet " + f-cod-etiqueta + ".").

            ASSIGN f-cod-etiqueta-filho:SCREEN-VALUE = "".
            RETURN "NOK".
        END.
        
        RUN piValidaEtiq(INPUT f-cod-etiqueta:SCREEN-VALUE,
                         INPUT f-cod-etiqueta-filho:SCREEN-VALUE,
                         INPUT YES).
        
        IF RETURN-VALUE <> "OK" THEN DO:
            ASSIGN f-cod-etiqueta-filho:SCREEN-VALUE = "".
            RETURN "NOK".
        END.
        
        RUN piCriaVolume(INPUT f-cod-etiqueta:SCREEN-VALUE,
                         INPUT f-cod-etiqueta-filho:SCREEN-VALUE).
        IF RETURN-VALUE <> "OK" THEN DO:
            ASSIGN f-cod-etiqueta-filho:SCREEN-VALUE = "".
            RETURN "NOK".
        END.
    END.

    IF fnQtdeFilho(f-cod-etiqueta:SCREEN-VALUE,f-cod-etiqueta-filho:SCREEN-VALUE) = INTEGER(f-quantidade:SCREEN-VALUE) THEN DO:
        IF f-tipo:SCREEN-VALUE = "CAIXA" THEN DO:
            ASSIGN g-etiq-pallet = "".
            RUN piChamaLeituraPallet.
            IF g-etiq-pallet <> "" THEN DO:
                IF DYNAMIC-FUNCTION("fnRetornaTpEtiq" IN h-esapi003,g-etiq-pallet) <> "PALLET"  THEN DO:
                    RUN utp/ut-msgs.p (INPUT "SHOW",
                                       INPUT 17006,
                                       INPUT "Etiqueta inv†lida~~A etiqueta informada n∆o Ç referente a um Pallet.").
                    RUN piLeituraEtiqFilho(NO).
                    RETURN.
                END.
                
                RUN piValidaEtiqPL(INPUT g-etiq-pallet,
                                   INPUT f-cod-etiqueta:SCREEN-VALUE IN FRAME fPage0,
                                   INPUT NO).
                
                IF RETURN-VALUE <> "OK" THEN DO:
                    RUN piLeituraEtiqFilho(NO).
                    RETURN.
                END.
                
                CREATE tt-ns-volume.
                ASSIGN tt-ns-volume.volume-pai   = g-etiq-pallet
                       tt-ns-volume.volume-filho = f-cod-etiqueta:SCREEN-VALUE
                       tt-ns-volume.sequencia    = 1
                       tt-ns-volume.data         = NOW
                       tt-ns-volume.usuario      = c-seg-usuario
                       tt-ns-volume.tipo         = "PALLET".
            END.
        END.
        
        RUN piGravaVolume.
        IF RETURN-VALUE = "OK" THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW",
                               INPUT 15825,
                               INPUT "Etiqueta de " + f-tipo:SCREEN-VALUE + " vinculada com sucesso.").
            RUN piLimpar.
        END.
    END.
    ELSE DO:
        ASSIGN f-cod-etiqueta-filho:SCREEN-VALUE = "".

        IF f-tipo:SCREEN-VALUE = "PALLET" THEN
            ASSIGN bt-gravar:SENSITIVE    = YES.

        APPLY "ENTRY" TO f-cod-etiqueta-filho.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLimpar wWindow 
PROCEDURE piLimpar :
/*------------------------------------------------------------------------------
  Purpose: Tratamento campos tela e browse ao bot∆o cancelar
  Notes:   Carlos Daniel - 02/02/2016
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE tt-ns-volume.
{&OPEN-QUERY-BR-ETIQUETA}

DO WITH FRAME fPage0:
    ASSIGN f-cod-etiqueta      :SCREEN-VALUE = ""
           f-tipo              :SCREEN-VALUE = ""
           f-quantidade        :SCREEN-VALUE = ""
           f-item              :SCREEN-VALUE = ""
           f-desc-item         :SCREEN-VALUE = ""
           f-cod-etiqueta-filho:SCREEN-VALUE = ""
           f-cod-etiqueta-filho:SENSITIVE    = NO
           bt-gravar:SENSITIVE               = NO.

    APPLY "ENTRY" TO f-cod-etiqueta.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaEtiq wWindow 
PROCEDURE piValidaEtiq :
/*------------------------------------------------------------------------------
  Purpose: Chama rotina para validaá∆o etiqueta
  Notes:   Carlos Daniel - 10/02/2016
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-etiqueta-pai   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER c-etiqueta-filho AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER l-valida-cx      AS LOGICAL   NO-UNDO.


IF fnQtdeFilho(c-etiqueta-pai,c-etiqueta-filho) >= INTEGER(f-quantidade:SCREEN-VALUE IN FRAME fPage0) THEN DO:
    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 17006,
                       INPUT "Etiqueta inv†lida~~Capacidade total da etiqueta j† utilizado, favor verificar.").
    RETURN "NOK".
END.

RUN piValidaEtiqueta IN h-esapi003 (INPUT c-etiqueta-pai,
                                    INPUT c-etiqueta-filho,
                                    INPUT l-valida-cx,
                                    OUTPUT TABLE tt-erro).

/*IF CAN-FIND(FIRST tt-erro) THEN DO:
    RUN esp/cdp/escdp666.w(INPUT TABLE tt-erro).
    ASSIGN f-cod-etiqueta-filho:SCREEN-VALUE IN FRAME fPage0 = "".
    APPLY "ENTRY" TO f-cod-etiqueta-filho.
    RETURN "NOK".
END.*/

IF RETURN-VALUE <> "OK" THEN DO:
    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 17006,
                       INPUT RETURN-VALUE).
    ASSIGN f-cod-etiqueta-filho:SCREEN-VALUE IN FRAME fPage0 = "".
    APPLY "ENTRY" TO f-cod-etiqueta-filho.
    RETURN "NOK".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaEtiqPL wWindow 
PROCEDURE piValidaEtiqPL :
/*------------------------------------------------------------------------------
  Purpose: Chama rotina para validaá∆o etiqueta de pallet
  Notes:   Carlos Daniel - 02/05/2016
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-etiqueta-pai   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER c-etiqueta-filho AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER l-valida-cx      AS LOGICAL   NO-UNDO.

IF fnQtdeFilho(c-etiqueta-pai,c-etiqueta-filho) > DYNAMIC-FUNCTION("fnRetornaCapacidade" IN h-esapi003,c-etiqueta-pai)  THEN DO:
    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 17006,
                       INPUT "Etiqueta inv†lida~~Capacidade total da etiqueta j† utilizado, favor verificar.").
    RETURN "NOK".
END.

RUN piValidaEtiqueta IN h-esapi003 (INPUT c-etiqueta-pai,
                                    INPUT c-etiqueta-filho,
                                    INPUT l-valida-cx,
                                    OUTPUT TABLE tt-erro).

/*IF CAN-FIND(FIRST tt-erro) THEN DO:
    RUN esp/cdp/escdp666.w(INPUT TABLE tt-erro).
    ASSIGN f-cod-etiqueta-filho:SCREEN-VALUE IN FRAME fPage0 = "".
    APPLY "ENTRY" TO f-cod-etiqueta-filho.
    RETURN "NOK".
END.*/

IF RETURN-VALUE <> "OK" THEN DO:
    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 17006,
                       INPUT RETURN-VALUE).
    ASSIGN f-cod-etiqueta-filho:SCREEN-VALUE IN FRAME fPage0 = "".
    APPLY "ENTRY" TO f-cod-etiqueta-filho.
    RETURN "NOK".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnQtdeFilho wWindow 
FUNCTION fnQtdeFilho RETURNS INTEGER
  ( INPUT c-etiq-pai AS CHARACTER,
    INPUT c-etiq-filho AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Retorna quantidade de filhos da etiqueta pai 
    Notes: Carlos Daniel - 04/02/2016
------------------------------------------------------------------------------*/
IF DYNAMIC-FUNCTION("fnRetornaTpEtiq" IN h-esapi003,c-etiq-filho) = "CAIXA" OR c-etiq-filho = "" THEN DO:

    RETURN DYNAMIC-FUNCTION("fnRetornaQtdePC" IN h-esapi003,INPUT c-etiq-pai,INPUT TABLE tt-ns-volume).
END.
ELSE DO:
    FOR EACH tt-ns-volume:
        ACCUMULATE tt-ns-volume.volume-pai (COUNT).
    END.
    
    RETURN ACCUM COUNT tt-ns-volume.volume-pai.   /* Function return value. */
END.

RETURN 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

