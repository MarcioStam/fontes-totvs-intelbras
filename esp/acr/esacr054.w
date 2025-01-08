&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2012)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESACR054 2.00.00.001}
/*------------------------------------------------------------------------
    File        : esacr054.w
    Purpose     : Cria pendˆncia para um novo cliente.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works).
    Created     : Abril de 2012
    Notes       : <none>
----------------------------------------------------------------------*/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESACR054 ACR}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESACR054
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Pendˆncia

&GLOBAL-DEFINE page0Widgets   edInfo ~
                              fiCodEmitente ~
                              fiValLimiteSugerido ~
                              btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE wh-pesquisa AS HANDLE      NO-UNDO.

/* Global Variable Definitions ---                                      */
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario  AS CHARACTER   NO-UNDO FORMAT "x(12)":U.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar edInfo fiCodEmitente fiNomeEmit ~
fiValLimiteSugerido btOk btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS edInfo fiCodEmitente fiNomeEmit ~
fiValLimiteSugerido 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miOk           LABEL "&OK"            ACCELERATOR "CTRL-S"
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOk 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE edInfo AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 60 BY 3 NO-UNDO.

DEFINE VARIABLE fiCodEmitente LIKE emitente.cod-emitente
     LABEL "Cliente":R8 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fiNomeEmit LIKE emitente.nome-emit
     VIEW-AS FILL-IN 
     SIZE 41.43 BY .88 NO-UNDO.

DEFINE VARIABLE fiValLimiteSugerido LIKE int-pendencias-supcard.val-limite-sugerido
     VIEW-AS FILL-IN 
     SIZE 17.29 BY .88 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     edInfo AT ROW 2 COL 11 HELP
          "Informa‡Æo" NO-LABEL NO-TAB-STOP 
     fiCodEmitente AT ROW 7.04 COL 21 COLON-ALIGNED HELP
          "Cliente"
          LABEL "Cliente":R8
     fiNomeEmit AT ROW 7.04 COL 30.43 COLON-ALIGNED HELP
          "Nome Completo do Emitente" NO-LABEL
     fiValLimiteSugerido AT ROW 8.04 COL 21 COLON-ALIGNED HELP
          "Valor do Limite Sugerido"
     btOk AT ROW 11.75 COL 2 HELP
          "OK"
     btCancel AT ROW 11.75 COL 13 HELP
          "Cancelar"
     btHelp2 AT ROW 11.75 COL 70 HELP
          "Ajuda"
     rtToolBar AT ROW 11.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 12
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
         TITLE              = ""
         HEIGHT             = 12
         WIDTH              = 80
         MAX-HEIGHT         = 12
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 12
         VIRTUAL-WIDTH      = 80
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
ASSIGN 
       edInfo:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN fiCodEmitente IN FRAME fpage0
   LIKE = mgcad.emitente.cod-emitente EXP-LABEL EXP-HELP EXP-SIZE      */
/* SETTINGS FOR FILL-IN fiNomeEmit IN FRAME fpage0
   LIKE = mgcad.emitente.nome-emit EXP-SIZE                            */
/* SETTINGS FOR FILL-IN fiValLimiteSugerido IN FRAME fpage0
   LIKE = mgesp.int-pendencias-supcard.val-limite-sugerido EXP-SIZE    */
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
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain
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


&Scoped-define SELF-NAME btOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOk wWindow
ON CHOOSE OF btOk IN FRAME fpage0 /* OK */
OR CHOOSE OF MENU-ITEM miOk IN MENU mbMain
DO:
    RUN piExecutar IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiCodEmitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodEmitente wWindow
ON F5 OF fiCodEmitente IN FRAME fpage0 /* Cliente */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z02ad098.w"
                       &campo="fiCodEmitente"
                       &campozoom="cod-emitente"
                       &frame="fPage0"
                       &campo2="fiNomeEmit"
                       &campozoom2="nome-emit"
                       &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodEmitente wWindow
ON LEAVE OF fiCodEmitente IN FRAME fpage0 /* Cliente */
DO:
    FIND FIRST emitente
        WHERE emitente.cod-emitente = INPUT FRAME fPage0 fiCodEmitente NO-LOCK NO-ERROR.

    ASSIGN fiNomeEmit = IF AVAILABLE emitente THEN emitente.nome-emit ELSE "":U.

    DISPLAY fiNomeEmit
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodEmitente wWindow
ON MOUSE-SELECT-DBLCLICK OF fiCodEmitente IN FRAME fpage0 /* Cliente */
DO:
    APPLY "F5":U TO SELF.
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

IF fiCodEmitente:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.

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
    ASSIGN edInfo = "Este programa tem por finalidade gerar o registro de pendˆncias do SupplierCard para novos clientes do mesmo.":U.

    DISPLAY edInfo
        WITH FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecutar wWindow 
PROCEDURE piExecutar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN INPUT FRAME fpage0 fiCodEmitente
                              fiValLimiteSugerido.

    FIND FIRST emitente
        WHERE emitente.cod-emitente = fiCodEmitente NO-LOCK NO-ERROR.

    IF NOT AVAILABLE emitente THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 2,
                           INPUT "Cliente":U).

        APPLY "ENTRY":U TO fiCodEmitente IN FRAME fPage0.

        RETURN NO-APPLY.
    END.

    FIND FIRST int-emitente
        WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

    IF AVAILABLE int-emitente    AND
       NOT int-emitente.id-ativo THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Cliente inativo.":U +
                                 "~~":U +
                                 "Cliente ~"":U + TRIM(emitente.nome-emit) + "~" est  inativo no cadastro de clientes.":U).

        RETURN NO-APPLY.
    END.

    IF CAN-FIND(FIRST int-pendencias-supcard NO-LOCK
                WHERE int-pendencias-supcard.cnpj-cliente = emitente.cgc
                  AND int-pendencias-supcard.identific    = 98 /* Solicitacao de Novo Cliente */
                  AND int-pendencias-supcard.dat-envio    = ?) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Solicita‡Æo de pendˆncia para um novo cliente j  cadastrada.":U).

        APPLY "ENTRY":U TO fiCodEmitente IN FRAME fPage0.

        RETURN NO-APPLY.
    END.

    CREATE int-pendencias-supcard.
    ASSIGN int-pendencias-supcard.cod-usuar           = c-seg-usuario
           int-pendencias-supcard.cnpj-cliente        = emitente.cgc
           int-pendencias-supcard.dat-criacao         = TODAY
           int-pendencias-supcard.identific           = 98 /* Solicitacao de Novo Cliente */
           int-pendencias-supcard.log-manual          = YES
           int-pendencias-supcard.log-emergencial     = NO
           int-pendencias-supcard.tipo-bloqueio       = ?
           int-pendencias-supcard.val-limite-sugerido = fiValLimiteSugerido /* VALOR DO LIMITE SUGERIDO */
           int-pendencias-supcard.obs                 = "Pendencia inserida no sistema por meio do programa ":U + CAPS(TRIM(c-programa-mg97)) + ", em " + STRING(TODAY, "99/99/9999":U) + " - ":U + STRING(TIME,"hh:mm:ss":U).

    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 32388,
                       INPUT "Pendˆncia para um novo cliente criada":U).

    ASSIGN fiCodEmitente       = 0
           fiValLimiteSugerido = 0.

    DISPLAY fiCodEmitente
            fiValLimiteSugerido
        WITH FRAME fPage0.

    APPLY "LEAVE":U TO fiCodEmitente IN FRAME fPage0.
    APPLY "ENTRY":U TO fiCodEmitente IN FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

