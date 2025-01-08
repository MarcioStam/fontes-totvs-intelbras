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
{include/i-prgvrs.i ESCPP001 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP001
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   NO

&GLOBAL-DEFINE page0Widgets   btExecutar     ~
                              btQueryJoins   ~
                              btReportsJoins ~
                              btExit         ~
                              btHelp         ~
                              fiQtdItem      ~
                              fiQtdMac       ~
                              rs-formata     ~
                              fiJustificativa

/* Include Definitions ---                                              */
{esapi/esapi023.i}   /*ttItem*/
{cdp/cd0666.i}       /*tt-erro*/

/* Local Temp-Table Definitions ---                                     */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE wh-pesquisa AS HANDLE    NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE h-acomp AS HANDLE NO-UNDO.

/* Global Shared Variable Definitions ---                               */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl    AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 RECT-34 RECT-35 btExecutar ~
btQueryJoins btReportsJoins btExit btHelp fiQtdItem fiQtdMac ~
fiJustificativa rs-formata 
&Scoped-Define DISPLAYED-OBJECTS fiQtdItem fiQtdMac fiJustificativa ~
rs-formata 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD conv-dec-to-hex wWindow 
FUNCTION conv-dec-to-hex RETURNS CHARACTER
  ( INPUT p-num-decimal AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD conv-hex-to-dec wWindow 
FUNCTION conv-hex-to-dec RETURNS INTEGER
  ( INPUT p-val-hexadecimal AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fator wWindow 
FUNCTION fator RETURNS INTEGER
  ( INPUT p-fator AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miGerar        LABEL "&Gerar Mac Address"
       RULE
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
DEFINE BUTTON btExecutar 
     IMAGE-UP FILE "image/im-thu.bmp":U
     LABEL "Executar" 
     SIZE 4 BY 1.25 TOOLTIP "Executar gera‡Æo Mac Address".

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

DEFINE VARIABLE fiJustificativa AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 66.57 BY 2.38 NO-UNDO.

DEFINE VARIABLE fiQtdItem AS INTEGER FORMAT ">,>>9":U INITIAL 0 
     LABEL "Qtd.Item" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiQtdMac AS INTEGER FORMAT ">,>>9":U INITIAL 0 
     LABEL "Mac p/ Item" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE rs-formata AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Com Formata‡Æo", 1,
"Sem Formata‡Æo", 2
     SIZE 35 BY .58 NO-UNDO.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 2.13.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 3.5.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 85 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btExecutar AT ROW 1.13 COL 1.57 HELP
          "Reimprimir Etiqueta"
     btQueryJoins AT ROW 1.13 COL 69.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 73.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 77.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 81.72 HELP
          "Ajuda"
     fiQtdItem AT ROW 3.88 COL 11.72 COLON-ALIGNED HELP
          "Quantidade de Etiqueta"
     fiQtdMac AT ROW 3.88 COL 65.86 COLON-ALIGNED HELP
          "Quantidade de Etiqueta" WIDGET-ID 12
     fiJustificativa AT ROW 6.63 COL 13.57 NO-LABEL WIDGET-ID 14
     rs-formata AT ROW 10.08 COL 13.57 NO-LABEL WIDGET-ID 8
     "Justificativa:" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 5.83 COL 4.14 WIDGET-ID 16
          FGCOLOR 1 FONT 0
     rtToolBar-2 AT ROW 1 COL 1
     RECT-34 AT ROW 3.25 COL 1 WIDGET-ID 20
     RECT-35 AT ROW 6.08 COL 1 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85.86 BY 9.92
         FONT 1.


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
         TITLE              = "Gera‡Æo Mac para Projeto"
         HEIGHT             = 10.46
         WIDTH              = 85.86
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
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
ON END-ERROR OF wWindow /* Gera‡Æo Mac para Projeto */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Gera‡Æo Mac para Projeto */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExecutar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExecutar wWindow
ON CHOOSE OF btExecutar IN FRAME fpage0 /* Executar */
OR CHOOSE OF MENU-ITEM miGerar IN MENU mbMain DO:
    RUN piValCampos.
    IF RETURN-VALUE = "OK" THEN DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
        RUN pi-inicializar in h-acomp (input "Gera‡Æo de Seriais"). 
        RUN piExecutar.
        RUN pi-finalizar IN h-acomp.
        ASSIGN h-acomp = ?.
    END.
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


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
    {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
    APPLY "LEAVE":U TO fiQtdItem IN FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecutar wWindow 
PROCEDURE piExecutar :
/*------------------------------------------------------------------------------
  Purpose:    Transferido rotina de premac para api esapi023.p  
  Notes:      Carlos Daniel - 22/09/2015
------------------------------------------------------------------------------*/
DEFINE VARIABLE h-api023 AS HANDLE NO-UNDO.

EMPTY TEMP-TABLE tt-mac-address.
EMPTY TEMP-TABLE tt-erro.
EMPTY TEMP-TABLE ttItem.

CREATE ttItem.
ASSIGN ttItem.it-codigo = ""
       ttitem.marcado   = YES
       ttItem.qt-pedido = INTEGER(fiQtdItem:SCREEN-VALUE IN FRAME fPage0)
       ttItem.qtd-mac   = INTEGER(fiQtdMac:SCREEN-VALUE)
       ttItem.projeto   = YES
       ttItem.just-proj = fiJustificativa:SCREEN-VALUE.

RUN esapi/esapi023.p PERSISTENT SET h-api023.

RUN piExecGeraMac IN h-api023 (INPUT  YES,
                               INPUT  INTEGER(rs-formata:SCREEN-VALUE),
                               INPUT  TABLE ttItem,
                               OUTPUT TABLE tt-mac-address,
                               OUTPUT TABLE tt-erro).

IF RETURN-VALUE NE 'OK' THEN DO:
    RUN cdp/cd0666.w( INPUT TABLE tt-erro).
    RETURN "NOK".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValCampos wWindow 
PROCEDURE piValCampos :
/*------------------------------------------------------------------------------
  Purpose: Valida‡Æo campos em tela
  Notes:   Carlos Daniel - 25/09/2015
------------------------------------------------------------------------------*/
DO WITH FRAME fPage0:
    IF INTEGER(fiQtdItem:SCREEN-VALUE) = 0 THEN DO:
        RUN utp/ut-msgs.p ('SHOW', 17006,
                           'Quantidade do item deve ser informada.').
        RETURN "NOK".
    END.

    IF INTEGER(fiQtdMac:SCREEN-VALUE) = 0 THEN DO:
        RUN utp/ut-msgs.p ('SHOW', 17006,
                           'Quantidade Mac deve ser informada.').
        RETURN "NOK".
    END.

    IF fijustificativa:SCREEN-VALUE = "" THEN DO:
        RUN utp/ut-msgs.p ('SHOW', 17006,
                           'Justificativa deve ser informada.').
        RETURN "NOK".
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION conv-dec-to-hex wWindow 
FUNCTION conv-dec-to-hex RETURNS CHARACTER
  ( INPUT p-num-decimal AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-simbolos        AS CHARACTER   NO-UNDO
        FORMAT "x(1)":U
        EXTENT 16
        INITIAL ["0":U, "1":U, "2":U, "3":U, "4":U, "5":U, "6":U, "7":U, "8":U, "9":U, "A":U, "B":U, "C":U, "D":U, "E":U, "F":U].

    DEFINE VARIABLE c-val-hexadecimal AS CHARACTER   NO-UNDO INITIAL "":U.

    DEFINE VARIABLE i-quociente       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-resto           AS INTEGER     NO-UNDO INITIAL 0.

    ASSIGN i-quociente = p-num-decimal.

    REPEAT:
        ASSIGN i-resto           = i-quociente MODULO 16
               i-quociente       = TRUNCATE((i-quociente / 16), 0)
               c-val-hexadecimal = c-simbolos[(i-resto + 1)] + c-val-hexadecimal.

        IF i-quociente <= 0 THEN
            LEAVE.
    END.

    IF LENGTH(c-val-hexadecimal) < 6 THEN DO:

        ASSIGN c-val-hexadecimal = FILL("0", 6 - LENGTH(c-val-hexadecimal)) + c-val-hexadecimal.

    END.

    RETURN c-val-hexadecimal. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION conv-hex-to-dec wWindow 
FUNCTION conv-hex-to-dec RETURNS INTEGER
  ( INPUT p-val-hexadecimal AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cont        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-valor       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-num-decimal AS INTEGER     NO-UNDO.

    DO i-cont = 1 TO LENGTH(p-val-hexadecimal):
        CASE SUBSTRING(p-val-hexadecimal, i-cont, 1):
            WHEN "A":U THEN
                ASSIGN i-valor = 10.
            WHEN "B":U THEN
                ASSIGN i-valor = 11.
            WHEN "C":U THEN
                ASSIGN i-valor = 12.
            WHEN "D":U THEN
                ASSIGN i-valor = 13.
            WHEN "E":U THEN
                ASSIGN i-valor = 14.
            WHEN "F":U THEN
                ASSIGN i-valor = 15.
            OTHERWISE DO:
                ASSIGN i-valor = INTEGER(SUBSTRING(p-val-hexadecimal, i-cont, 1)) NO-ERROR.

                IF ERROR-STATUS:ERROR THEN
                    RETURN 0. /* Function return value. */
            END.
        END CASE.

        ASSIGN i-num-decimal = i-num-decimal + (i-valor * fator(LENGTH(p-val-hexadecimal) - i-cont)).
    END.

    RETURN i-num-decimal. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fator wWindow 
FUNCTION fator RETURNS INTEGER
  ( INPUT p-fator AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cont  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-valor AS INTEGER     NO-UNDO.

    ASSIGN i-valor = 1.

    IF p-fator > 0 THEN DO:
        DO i-cont = 1 TO p-fator:
            ASSIGN i-valor = i-valor * 16.
        END.
    END.

    RETURN i-valor. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

