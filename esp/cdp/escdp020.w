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
{include/i-prgvrs.i ESCDP020 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP020
&GLOBAL-DEFINE Version        2.04.00.000

&GLOBAL-DEFINE WindowType     master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   br-partic-societaria btExit btHelp btIncluir btAlterar2 btExcluir
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

DEFINE INPUT PARAMETER p-cod-emitente AS INTEGER NO-UNDO.
DEFINE VARIABLE de-participacao AS DECIMAL     NO-UNDO.
DEF TEMP-TABLE tt-partic-societaria LIKE partic-societaria
     FIELD percentual AS DEC.
/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-partic-societaria

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-partic-societaria

/* Definitions for BROWSE br-partic-societaria                          */
&Scoped-define FIELDS-IN-QUERY-br-partic-societaria tt-partic-societaria.cod-cpf-cnpj tt-partic-societaria.nome-socio tt-partic-societaria.percentual   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-partic-societaria   
&Scoped-define SELF-NAME br-partic-societaria
&Scoped-define QUERY-STRING-br-partic-societaria FOR EACH tt-partic-societaria
&Scoped-define OPEN-QUERY-br-partic-societaria OPEN QUERY {&SELF-NAME} FOR EACH tt-partic-societaria.
&Scoped-define TABLES-IN-QUERY-br-partic-societaria tt-partic-societaria
&Scoped-define FIRST-TABLE-IN-QUERY-br-partic-societaria tt-partic-societaria


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-partic-societaria}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-partic-societaria btIncluir btExit btHelp ~
fi-cod-emitente fi-nome-emit btAlterar btAlterar2 btExcluir rtToolBar-2 ~
rtToolBar RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-emitente fi-nome-emit 

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
DEFINE BUTTON btAlterar 
     LABEL "Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btAlterar2 
     LABEL "Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExcluir 
     LABEL "Excluir" 
     SIZE 10 BY 1.

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

DEFINE BUTTON btIncluir 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "C¢digo":R8 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-emit AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 52.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 1.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 10.38.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-partic-societaria FOR 
      tt-partic-societaria SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-partic-societaria
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-partic-societaria wWindow _FREEFORM
  QUERY br-partic-societaria NO-LOCK DISPLAY
      tt-partic-societaria.cod-cpf-cnpj
 tt-partic-societaria.nome-socio FORMAT "x(70)"
 tt-partic-societaria.percentual
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 75.72 BY 8.88
         FONT 1
         TITLE "Socios" ROW-HEIGHT-CHARS .63 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     br-partic-societaria AT ROW 4.63 COL 3.29 WIDGET-ID 200
     btIncluir AT ROW 15.17 COL 2
     btExit AT ROW 1.13 COL 72.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 76.57 HELP
          "Ajuda"
     fi-cod-emitente AT ROW 3.08 COL 10.43 COLON-ALIGNED WIDGET-ID 2
     fi-nome-emit AT ROW 3.08 COL 19.72 COLON-ALIGNED HELP
          "Nome Completo do Emitente" NO-LABEL WIDGET-ID 4
     btAlterar AT ROW 15.17 COL 13 WIDGET-ID 14
     btAlterar2 AT ROW 15.17 COL 13 WIDGET-ID 16
     btExcluir AT ROW 15.17 COL 24 WIDGET-ID 18
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 14.96 COL 1
     RECT-1 AT ROW 2.75 COL 2.14 WIDGET-ID 6
     RECT-2 AT ROW 4.38 COL 2.14 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.14 BY 15.5
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
         HEIGHT             = 15.5
         WIDTH              = 80.14
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-partic-societaria 1 fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-partic-societaria
/* Query rebuild information for BROWSE br-partic-societaria
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-partic-societaria.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-partic-societaria */
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

        ASSIGN de-participacao = 0.
    FOR EACH emit-partic-societ NO-LOCK
        WHERE emit-partic-societ.cod-emitente = emitente.cod-emitente,
        FIRST partic-societaria NO-LOCK
        WHERE partic-societaria.cod-cpf-cnpj = emit-partic-societ.cod-cpf-cnpj:
        ASSIGN de-participacao = de-participacao + emit-partic-societaria.perc-participacao.
    END.
    IF de-participacao <> 100 THEN DO:
         RUN utp/ut-msgs.p ('show', 17006, 'Total Participaá∆o Societ†ria n∆o Fechou em 100%.~~Foi informado o percentual total de ' + String(de-participacao) + ' %, porem o total da somatoria da participaá∆o societ†ria devera ser igual a 100%').

    END.
    ELSE DO:
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAlterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAlterar wWindow
ON CHOOSE OF btAlterar IN FRAME fpage0 /* Alterar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAlterar2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAlterar2 wWindow
ON CHOOSE OF btAlterar2 IN FRAME fpage0 /* Alterar */
DO:


    RUN esp/cdp/escdp020a.w (INPUT fi-cod-emitente:SCREEN-VALUE IN FRAME fpage0,
                             INPUT tt-partic-societaria.cod-cpf-cnpj,
                             INPUT NO).
    RUN pi-Carrega-Dados.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcluir wWindow
ON CHOOSE OF btExcluir IN FRAME fpage0 /* Excluir */
DO:
    MESSAGE "Confirma Exclus∆o?"
        VIEW-AS ALERT-BOX INFO BUTTONS YES-NO UPDATE choice AS LOGICAL.
    IF choice = TRUE THEN DO:
        FIND FIRST emit-partic-societaria
             WHERE emit-partic-societaria.cod-cpf-cnpj = tt-partic-societaria.cod-cpf-cnpj
               AND emit-partic-societaria.cod-emitente = int(fi-cod-emitente:SCREEN-VALUE IN FRAME fpage0)
             EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL emit-partic-societaria THEN DO:
           DELETE emit-partic-societaria.
        END.
        FIND FIRST emit-partic-societaria
             WHERE emit-partic-societaria.cod-cpf-cnpj = tt-partic-societaria.cod-cpf-cnpj
             EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAIL emit-partic-societaria THEN DO:
            FIND partic-societaria
                 WHERE partic-societaria.cod-cpf-cnpj = tt-partic-societaria.cod-cpf-cnpj
                 exclusive-LOCK NO-ERROR.
            IF AVAIL partic-societaria THEN DO:
                DELETE partic-societaria.
            END.                         
        END.
        RUN pi-carrega-dados.
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    ASSIGN de-participacao = 0.
    FOR EACH emit-partic-societ NO-LOCK
        WHERE emit-partic-societ.cod-emitente = emitente.cod-emitente,
        FIRST partic-societaria NO-LOCK
        WHERE partic-societaria.cod-cpf-cnpj = emit-partic-societ.cod-cpf-cnpj:
        ASSIGN de-participacao = de-participacao + emit-partic-societaria.perc-participacao.
    END.
    IF de-participacao <> 100 THEN DO:
         RUN utp/ut-msgs.p ('show', 17006, 'Total Participaá∆o Societ†ria n∆o Fechou em 100%.~~Foi informado o percentual total de ' + String(de-participacao) + ' %, porem o total da somatoria da participaá∆o societ†ria devera ser igual a 100%').

    END.
    ELSE
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


&Scoped-define SELF-NAME btIncluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIncluir wWindow
ON CHOOSE OF btIncluir IN FRAME fpage0 /* Incluir */
DO:

    RUN esp/cdp/escdp020a.w (INPUT fi-cod-emitente:SCREEN-VALUE IN FRAME fpage0,
                             INPUT ?,
                             INPUT YES).
       RUN pi-Carrega-Dados.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-partic-societaria
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


RUN pi-carrega-dados.

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
    
    APPLY "VALUE-CHANGED" TO br-partic-societaria IN FRAME fPage0.
/*     br-partic-societaria:SELECT-FOCUSED-ROW(). */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-dados wWindow 
PROCEDURE pi-carrega-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-partic-societaria NO-LOCK:
        DELETE tt-partic-societaria.
    END.
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = p-cod-emitente NO-ERROR.
    IF AVAIL emitente THEN DO:
        ASSIGN fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0 = STRING(emitente.cod-emitente)
               fi-nome-emit:SCREEN-VALUE IN FRAME fPage0    = emitente.nome-emit.
        IF CAN-FIND(FIRST emit-partic-societ NO-LOCK
                    WHERE emit-partic-societ.cod-emitente = emitente.cod-emitente) THEN DO:
            FOR EACH emit-partic-societ NO-LOCK
                WHERE emit-partic-societ.cod-emitente = emitente.cod-emitente,
                FIRST partic-societaria NO-LOCK
               WHERE partic-societaria.cod-cpf-cnpj = emit-partic-societ.cod-cpf-cnpj:
                CREATE tt-partic-societaria.
                BUFFER-COPY partic-societaria TO tt-partic-societaria.
                ASSIGN tt-partic-societaria.percentual = emit-partic-societ.perc-participacao.
            END.
            {&OPEN-QUERY-br-partic-societaria}

        END.
/*         ELSE DO:                                                                          */
/*             MESSAGE "N∆o Existe Socios cadastrados para emitente: " emitente.cod-emitente */
/*                 VIEW-AS ALERT-BOX INFO BUTTONS OK.                                        */
/*             APPLY "close" TO THIS-PROCEDURE.                                              */
/*         END.                                                                              */
    END.
    ELSE DO:
        MESSAGE "Emitente: " p-cod-emitente " n∆o cadastrado!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY "close" TO THIS-PROCEDURE.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

