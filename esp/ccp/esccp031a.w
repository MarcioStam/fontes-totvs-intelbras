&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emsfnd           PROGRESS
          mgcad            PROGRESS
          mgmov            PROGRESS
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
{include/i-prgvrs.i ESCCP031A 2.06.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESCCP031A MCC}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCCP031A
&GLOBAL-DEFINE Version        2.06.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Parƒmetro

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   fi-data-pedido fi-end-cobranca fi-responsavel fi-cod-mensagem ~
                              fi-cod-estab-gestor ~
                              text-frete rs-frete ~
                              text-importacao tg-gera-proc-imp tg-gera-embarque

/* Include Definitions ---                                              */

/* Preprocessador de Distribui‡Æo (Materiais) */
{cdp/cdcfgmat.i}

/* Defini‡Æo da Temp-Table "tt-ordem-compra-ped" */
{esp/ccp/esccp031.i}

/* Defini‡Æo da Temp-Table "tt-param" */
{ccp/cc0311.i3}

/* Local Temp-Table Definitions ---                                     */

define temp-table tt-digita
    field marca          as char format "x(01)"  COLUMN-LABEL ""
    field numero-ordem   like ordem-compra.numero-ordem
    field it-codigo      like ordem-compra.it-codigo
    field qt-solic       like ordem-compra.qt-solic
    field cod-emitente   like ordem-compra.cod-emitente
    field cod-estabel    like ordem-compra.cod-estabel
    field cod-comprado   like ordem-compra.cod-comprado
    field nr-processo    like ordem-compra.nr-processo
    field num-pedido     like ordem-compra.num-pedido
    field natureza       like ordem-compra.natureza
    field cod-transp     like ordem-compra.cod-transp
    field data-cotacao   like ordem-compra.data-cotacao
    field cod-cond-pag   like ordem-compra.cod-cond-pag
    field ordem-servic   like ordem-compra.ordem-servic
    field cod-incoterm   as char
    index id is primary unique numero-ordem.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE raw-param   AS RAW         NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE      NO-UNDO.

/* New Global Shared Variable ---                                       */

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl   AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-tg-emb-cc0311 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v-log-emb-cc0311 AS LOGICAL       NO-UNDO.

/* Buffer Definitions ---                                               */

DEFINE BUFFER b-tt-digita FOR tt-digita.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-parent      AS HANDLE                     NO-UNDO.
DEFINE INPUT  PARAMETER p-responsavel LIKE pedido-compr.responsavel NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-ordem-compra-ped.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 87 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fi-cod-estab-gestor LIKE pedido-compr.cod-estab-gestor
     LABEL "Estabelec Gestor" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 TOOLTIP "Estabelecimento gestor do pedido" NO-UNDO.

DEFINE VARIABLE fi-cod-mensagem LIKE pedido-compr.cod-mensagem
     LABEL "C¢digo Mensagem" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 TOOLTIP "C¢digo da mensagem do pedido" NO-UNDO.

DEFINE VARIABLE fi-data-pedido LIKE pedido-compr.data-pedido
     LABEL "Data Pedido" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 TOOLTIP "Data do pedido" NO-UNDO.

DEFINE VARIABLE fi-desc-mens-pedido LIKE mensagem.descricao
     VIEW-AS FILL-IN 
     SIZE 46 BY .88 TOOLTIP "Descri‡Æo da mensagem do pedido" NO-UNDO.

DEFINE VARIABLE fi-end-cobranca LIKE pedido-compr.end-cobranca
     LABEL "Estabel Cobran‡a" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 TOOLTIP "Estabelecimento de cobran‡a do pedido" NO-UNDO.

DEFINE VARIABLE fi-nome-estab-cob-ped LIKE estabelec.nome
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 TOOLTIP "Nome do estabelecimento de cobran‡a do pedido" NO-UNDO.

DEFINE VARIABLE fi-nome-estab-gestor-ped LIKE estabelec.nome
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 TOOLTIP "Nome do estabelecimento gestor do pedido" NO-UNDO.

DEFINE VARIABLE fi-nome-responsavel LIKE usuar_mestre.nom_usuario
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 TOOLTIP "Nome do repons vel do pedido" NO-UNDO.

DEFINE VARIABLE fi-responsavel LIKE pedido-compr.responsavel
     LABEL "Respons vel" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 TOOLTIP "Respons vel pelo pedido" NO-UNDO.

DEFINE VARIABLE text-frete AS CHARACTER FORMAT "X(256)":U INITIAL " Frete" 
      VIEW-AS TEXT 
     SIZE 5.57 BY .67 NO-UNDO.

DEFINE VARIABLE text-importacao AS CHARACTER FORMAT "X(256)":U INITIAL " Importa‡Æo" 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE VARIABLE rs-frete LIKE pedido-compr.frete
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Pago", 1,
"A Pagar", 2
     SIZE 20.14 BY .63 TOOLTIP "Frete (Pago ou A Pagar)" NO-UNDO.

DEFINE RECTANGLE rtFrete
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29.43 BY 1.29.

DEFINE RECTANGLE rtImportacao
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49.57 BY 1.29.

DEFINE RECTANGLE rtParam
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 5.25.

DEFINE VARIABLE tg-gera-embarque AS LOGICAL INITIAL no 
     LABEL "Gera Embarque" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.43 BY .63 TOOLTIP "Gera embarque?" NO-UNDO.

DEFINE VARIABLE tg-gera-proc-imp AS LOGICAL INITIAL no 
     LABEL "Gera Processo Importa‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.14 BY .63 TOOLTIP "Gera processo importa‡Æo?" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 11.42 COL 2 HELP
          "Executar"
     btCancel AT ROW 11.42 COL 13 HELP
          "Cancelar"
     btHelp2 AT ROW 11.42 COL 77 HELP
          "Ajuda"
     rtToolBar AT ROW 11.21 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87 BY 11.67
         FONT 1.

DEFINE FRAME fPage1
     fi-data-pedido AT ROW 1.33 COL 20.29 COLON-ALIGNED HELP
          "Data do pedido"
          LABEL "Data Pedido"
     fi-end-cobranca AT ROW 2.33 COL 20.29 COLON-ALIGNED HELP
          "Estabelecimento de cobran‡a do pedido"
          LABEL "Estabel Cobran‡a"
     fi-nome-estab-cob-ped AT ROW 2.33 COL 29.72 COLON-ALIGNED HELP
          "Nome do estabelecimento de cobran‡a do pedido" NO-LABEL
     fi-responsavel AT ROW 3.33 COL 20.29 COLON-ALIGNED HELP
          "Respons vel pelo pedido"
          LABEL "Respons vel"
     fi-nome-responsavel AT ROW 3.33 COL 34.72 COLON-ALIGNED HELP
          "Nome do repons vel do pedido" NO-LABEL
     fi-cod-mensagem AT ROW 4.33 COL 20.29 COLON-ALIGNED HELP
          "C¢digo da mensagem do pedido"
          LABEL "C¢digo Mensagem"
     fi-desc-mens-pedido AT ROW 4.33 COL 26.72 COLON-ALIGNED HELP
          "Descri‡Æo da mensagem do pedido" NO-LABEL
     fi-cod-estab-gestor AT ROW 5.33 COL 20.29 COLON-ALIGNED HELP
          "Estabelecimento gestor do pedido"
          LABEL "Estabelec Gestor"
     fi-nome-estab-gestor-ped AT ROW 5.33 COL 29.72 COLON-ALIGNED HELP
          "Nome do estabelecimento gestor do pedido" NO-LABEL
     rs-frete AT ROW 7.25 COL 2.86 HELP
          "Frete (Pago ou A Pagar)" NO-LABEL
     tg-gera-proc-imp AT ROW 7.25 COL 33.29 HELP
          "Gera processo importa‡Æo?"
     tg-gera-embarque AT ROW 7.25 COL 61 HELP
          "Gera embarque?"
     text-frete AT ROW 6.54 COL 2.43 NO-LABEL
     text-importacao AT ROW 6.54 COL 30.86 COLON-ALIGNED NO-LABEL
     rtParam AT ROW 1.17 COL 1.57
     rtFrete AT ROW 6.88 COL 1.57
     rtImportacao AT ROW 6.88 COL 32
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.5
         SIZE 81.43 BY 8
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
         HEIGHT             = 11.67
         WIDTH              = 87
         MAX-HEIGHT         = 11.67
         MAX-WIDTH          = 87
         VIRTUAL-HEIGHT     = 11.67
         VIRTUAL-WIDTH      = 87
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN fi-cod-estab-gestor IN FRAME fPage1
   LIKE = mgmov.pedido-compr.cod-estab-gestor EXP-LABEL EXP-HELP EXP-SIZE */
/* SETTINGS FOR FILL-IN fi-cod-mensagem IN FRAME fPage1
   LIKE = mgmov.pedido-compr.cod-mensagem EXP-LABEL EXP-HELP EXP-SIZE   */
/* SETTINGS FOR FILL-IN fi-data-pedido IN FRAME fPage1
   LIKE = mgmov.pedido-compr.data-pedido EXP-LABEL EXP-HELP EXP-SIZE    */
/* SETTINGS FOR FILL-IN fi-desc-mens-pedido IN FRAME fPage1
   LIKE = mgcad.mensagem.descricao EXP-LABEL EXP-HELP EXP-SIZE          */
/* SETTINGS FOR FILL-IN fi-end-cobranca IN FRAME fPage1
   LIKE = mgmov.pedido-compr.end-cobranca EXP-LABEL EXP-HELP EXP-SIZE   */
/* SETTINGS FOR FILL-IN fi-nome-estab-cob-ped IN FRAME fPage1
   LIKE = mgcad.estabelec.nome EXP-LABEL EXP-HELP EXP-SIZE              */
/* SETTINGS FOR FILL-IN fi-nome-estab-gestor-ped IN FRAME fPage1
   LIKE = mgcad.estabelec.nome EXP-LABEL EXP-HELP EXP-SIZE              */
/* SETTINGS FOR FILL-IN fi-nome-responsavel IN FRAME fPage1
   LIKE = emsfnd.usuar_mestre.nom_usuario EXP-LABEL EXP-HELP EXP-SIZE   */
/* SETTINGS FOR FILL-IN fi-responsavel IN FRAME fPage1
   LIKE = mgmov.pedido-compr.responsavel EXP-LABEL EXP-HELP EXP-SIZE    */
/* SETTINGS FOR RADIO-SET rs-frete IN FRAME fPage1
   LIKE = mgmov.pedido-compr.frete EXP-HELP EXP-SIZE                    */
/* SETTINGS FOR FILL-IN text-frete IN FRAME fPage1
   ALIGN-L                                                              */
ASSIGN 
       text-frete:PRIVATE-DATA IN FRAME fPage1     = 
                "Frete".

ASSIGN 
       text-importacao:PRIVATE-DATA IN FRAME fPage1     = 
                "Importa‡Æo".

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
  ASSIGN p-parent:CURRENT-WINDOW:SENSITIVE = YES.

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
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
    DO ON ERROR UNDO, RETURN NO-APPLY:
        RUN piExecute IN THIS-PROCEDURE.
    END.

    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fi-cod-estab-gestor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab-gestor wWindow
ON F5 OF fi-cod-estab-gestor IN FRAME fPage1 /* Estabelec Gestor */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=fi-cod-estab-gestor
                       &campozoom=cod-estabel
                       &frame=fPage1
                       &campo2=fi-nome-estab-gestor-ped
                       &campozoom2=nome
                       &frame2=fPage1}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab-gestor wWindow
ON LEAVE OF fi-cod-estab-gestor IN FRAME fPage1 /* Estabelec Gestor */
DO:
    FIND FIRST estabelec
        WHERE estabelec.cod-estabel = INPUT frame fPage1 fi-cod-estab-gestor NO-LOCK NO-ERROR.

    ASSIGN fi-nome-estab-gestor-ped = IF AVAILABLE estabelec THEN estabelec.nome ELSE "":U.

    DISPLAY fi-nome-estab-gestor-ped
        WITH FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab-gestor wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-estab-gestor IN FRAME fPage1 /* Estabelec Gestor */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-mensagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-mensagem wWindow
ON F5 OF fi-cod-mensagem IN FRAME fPage1 /* C¢digo Mensagem */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad176.w
                       &campo=fi-cod-mensagem
                       &campozoom=cod-mensagem
                       &frame=fPage1
                       &campo2=fi-desc-mens-pedido
                       &campozoom2=descricao
                       &frame2=fPage1}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-mensagem wWindow
ON LEAVE OF fi-cod-mensagem IN FRAME fPage1 /* C¢digo Mensagem */
DO:
    FIND FIRST mensagem
        WHERE mensagem.cod-mensagem = INPUT FRAME fPage1 fi-cod-mensagem NO-LOCK NO-ERROR.

    ASSIGN fi-desc-mens-pedido = IF AVAILABLE mensagem THEN mensagem.descricao ELSE "":U.

    DISPLAY fi-desc-mens-pedido
        WITH FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-mensagem wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-mensagem IN FRAME fPage1 /* C¢digo Mensagem */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-end-cobranca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-end-cobranca wWindow
ON F5 OF fi-end-cobranca IN FRAME fPage1 /* Estabel Cobran‡a */
DO:
    ASSIGN l-implanta = YES.

    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=fi-end-cobranca
                       &campozoom=cod-estabel
                       &frame=fPage1
                       &campo2=fi-nome-estab-cob-ped
                       &campozoom2=nome
                       &frame2=fPage1}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-end-cobranca wWindow
ON LEAVE OF fi-end-cobranca IN FRAME fPage1 /* Estabel Cobran‡a */
DO:
    FIND FIRST estabelec
        WHERE estabelec.cod-estabel = INPUT FRAME fPage1 fi-end-cobranca NO-LOCK NO-ERROR.

    ASSIGN fi-nome-estab-cob-ped = IF AVAILABLE estabelec THEN estabelec.nome ELSE "":U.

    DISPLAY fi-nome-estab-cob-ped
        WITH FRAME fPage1.

    IF NOT fi-cod-estab-gestor:HIDDEN    IN FRAME fPage1 AND
       NOT fi-cod-estab-gestor:SENSITIVE IN FRAME fPage1 THEN DO:
        ASSIGN fi-cod-estab-gestor = fi-end-cobranca.

        DISPLAY fi-cod-estab-gestor
            WITH FRAME fPage1.

        APPLY "LEAVE":U TO fi-cod-estab-gestor IN FRAME fPage1.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-end-cobranca wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-end-cobranca IN FRAME fPage1 /* Estabel Cobran‡a */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-responsavel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-responsavel wWindow
ON F5 OF fi-responsavel IN FRAME fPage1 /* Respons vel */
DO:
    ASSIGN l-implanta = YES.

    {include/zoomvar.i &prog-zoom=inzoom/z01in055.w
                       &campo=fi-responsavel
                       &campozoom=cod-comprado
                       &frame=fPage1
                       &campo2=fi-nome-responsavel
                       &campozoom2=nome
                       &frame2=fPage1}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-responsavel wWindow
ON LEAVE OF fi-responsavel IN FRAME fPage1 /* Respons vel */
DO:
    FIND FIRST usuar-mater
        WHERE usuar-mater.cod-usuario = INPUT FRAME fPage1 fi-responsavel
          AND usuar-mater.usuar-comprado NO-LOCK NO-ERROR.

    IF AVAILABLE usuar-mater THEN DO:
        FIND FIRST usuar_mestre
            WHERE usuar_mestre.cod_usuario = usuar-mater.cod-usuario NO-LOCK NO-ERROR.

        ASSIGN fi-nome-responsavel = IF AVAILABLE usuar_mestre THEN usuar_mestre.nom_usuario ELSE "":U.
    END.
    ELSE
        ASSIGN fi-nome-responsavel = "":U.

    DISPLAY fi-nome-responsavel
        WITH FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-responsavel wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-responsavel IN FRAME fPage1 /* Respons vel */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

PROCEDURE WinExec EXTERNAL "kernel32.dll":U :
    DEFINE INPUT  PARAMETER prg_name  AS CHARACTER.
    DEFINE INPUT  PARAMETER prg_style AS SHORT.
END PROCEDURE.

IF fi-end-cobranca:LOAD-MOUSE-POINTER("image/lupa.cur":U)     IN FRAME fPage1 THEN.
IF fi-responsavel:LOAD-MOUSE-POINTER("image/lupa.cur":U)      IN FRAME fPage1 THEN.
IF fi-cod-mensagem:LOAD-MOUSE-POINTER("image/lupa.cur":U)     IN FRAME fPage1 THEN.
IF fi-cod-estab-gestor:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1 THEN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN p-parent:CURRENT-WINDOW:SENSITIVE = YES.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN p-parent:CURRENT-WINDOW:SENSITIVE = NO.

    ASSIGN fi-data-pedido = TODAY.

    FIND FIRST tt-ordem-compra-ped NO-ERROR.

    IF AVAILABLE tt-ordem-compra-ped THEN DO:
        FIND FIRST ordem-compra
            WHERE ordem-compra.numero-ordem = tt-ordem-compra-ped.numero-ordem NO-LOCK NO-ERROR.

        IF AVAILABLE ordem-compra THEN
            ASSIGN fi-end-cobranca = ordem-compra.cod-estabel.
    END.

    FIND FIRST comprador
        WHERE comprador.cod-comprado = p-responsavel NO-LOCK NO-ERROR.

    ASSIGN fi-responsavel = IF AVAILABLE comprador THEN comprador.cod-comprado ELSE "":U
           rs-frete       = 2.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    IF AVAILABLE param-global THEN DO:
        &IF DEFINED(bf_mat_contratos) &THEN
        IF param-global.modulo-mp THEN DO:
            DISPLAY fi-cod-estab-gestor
                WITH FRAME fPage1.

            APPLY "LEAVE":U TO fi-cod-estab-gestor IN FRAME fPage1.
        END.
        ELSE
            DISABLE fi-cod-estab-gestor
                WITH FRAME fPage1.
        &ELSE
        ASSIGN fi-cod-estab-gestor:HIDDEN      IN FRAME fPage1 = YES
               fi-nome-estab-gestor-ped:HIDDEN IN FRAME fPage1 = YES.

        ASSIGN rtParam:HEIGHT       IN FRAME fPage1 = rtParam:HEIGHT       IN FRAME fPage1 - 1
               text-frete:ROW       IN FRAME fPage1 = text-frete:ROW       IN FRAME fPage1 - 1
               rs-frete:ROW         IN FRAME fPage1 = rs-frete:ROW         IN FRAME fPage1 - 1
               rtFrete:ROW          IN FRAME fPage1 = rtFrete:ROW          IN FRAME fPage1 - 1
               text-importacao:ROW  IN FRAME fPage1 = text-importacao:ROW  IN FRAME fPage1 - 1
               tg-gera-proc-imp:ROW IN FRAME fPage1 = tg-gera-proc-imp:ROW IN FRAME fPage1 - 1
               tg-gera-embarque:ROW IN FRAME fPage1 = tg-gera-embarque:ROW IN FRAME fPage1 - 1
               rtImportacao:ROW     IN FRAME fPage1 = rtImportacao:ROW     IN FRAME fPage1 - 1.
        &ENDIF

        ASSIGN tg-gera-proc-imp = param-global.modulo-07
               tg-gera-embarque = param-global.modulo-07.

        IF NOT param-global.modulo-07 THEN
            DISABLE tg-gera-proc-imp
                    tg-gera-embarque
                WITH FRAME fPage1.
    END.

    FIND FIRST tt-ordem-compra-ped NO-ERROR.

    IF AVAILABLE tt-ordem-compra-ped THEN DO:
        FIND FIRST ordem-compra
            WHERE ordem-compra.numero-ordem = tt-ordem-compra-ped.numero-ordem NO-LOCK NO-ERROR.

        IF AVAILABLE ordem-compra THEN DO:
            FIND FIRST emitente
                WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.

            IF AVAILABLE emitente THEN DO:
                IF emitente.natureza <= 2 THEN
                    ASSIGN fi-cod-mensagem = 1.
                ELSE
                    ASSIGN fi-cod-mensagem = 45.
            END.
        END.
    END.

    DISPLAY fi-data-pedido
            fi-end-cobranca
            fi-responsavel
            fi-cod-mensagem
            rs-frete
            tg-gera-proc-imp
            tg-gera-embarque
        WITH FRAME fPage1.

    APPLY "LEAVE":U TO fi-end-cobranca IN FRAME fPage1.
    APPLY "LEAVE":U TO fi-responsavel  IN FRAME fPage1.
    APPLY "LEAVE":U TO fi-cod-mensagem IN FRAME fPage1.

    ASSIGN wh-tg-emb-cc0311 = tg-gera-embarque:HANDLE
           v-log-emb-cc0311 = YES.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wWindow 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cEditor      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE lAbreArquivo AS LOGICAL     NO-UNDO.

    DO ON ERROR UNDO, RETURN ERROR
       ON STOP  UNDO, RETURN ERROR:

        /* Valida informa‡äes de tela - In¡cio */
        FIND FIRST estabelec
            WHERE estabelec.cod-estabel = INPUT FRAME fPage1 fi-end-cobranca NO-LOCK NO-ERROR.

        IF NOT AVAILABLE estabelec THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 2,
                               INPUT "Estabelecimento Cobran‡a":U).

            APPLY "ENTRY":U TO fi-end-cobranca IN FRAME fPage1.

            RETURN NO-APPLY.
        END.

        FIND FIRST usuar-mater
            WHERE usuar-mater.cod-usuario = INPUT FRAME fPage1 fi-responsavel
              AND usuar-mater.usuar-comprado NO-LOCK NO-ERROR.

        IF NOT AVAILABLE usuar-mater THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 2,
                               INPUT "Respons vel":U).

            APPLY "ENTRY":U TO fi-responsavel IN FRAME fPage1.

            RETURN NO-APPLY.
        END.

        FIND FIRST mensagem
            WHERE mensagem.cod-mensagem = INPUT FRAME fPage1 fi-cod-mensagem NO-LOCK NO-ERROR.

        IF NOT AVAILABLE mensagem THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 2,
                               INPUT "Mensagem":U).

            APPLY "ENTRY":U TO fi-cod-mensagem IN FRAME fPage1.

            RETURN NO-APPLY.
        END.

        &IF DEFINED(bf_mat_contratos) &THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.

        IF AVAILABLE param-global THEN DO:
            IF param-global.modulo-mp THEN DO:
                FIND FIRST estabelec
                    WHERE estabelec.cod-estabel = INPUT frame fPage1 fi-cod-estab-gestor NO-LOCK NO-ERROR.

                IF NOT AVAILABLE estabelec THEN DO:
                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                       INPUT 2,
                                       INPUT "Estabelecimento Gestor":U).

                    APPLY "ENTRY":U TO fi-cod-estab-gestor IN FRAME fPage1.

                    RETURN NO-APPLY.
                END.
            END.
        END.
        &ENDIF
        /* Valida informa‡äes de tela - Final */
    
        /* Carrega ordens de compra na Temp-Table "tt-digita" - In¡cio */
        EMPTY TEMP-TABLE tt-digita.
    
        FOR EACH tt-ordem-compra-ped,
            FIRST ordem-compra NO-LOCK
            WHERE ordem-compra.numero-ordem  = tt-ordem-compra-ped.numero-ordem
              AND ordem-compra.situacao      = 3
              AND ordem-compra.num-pedido    = 0
              AND ordem-compra.cod-cond-pag <> ?
              AND ordem-compra.expectativa   = NO:
            FIND FIRST tt-digita
                 WHERE tt-digita.numero-ordem = ordem-compra.numero-ordem NO-ERROR.

            IF NOT AVAILABLE tt-digita THEN DO:
                CREATE tt-digita.
                ASSIGN tt-digita.marca          = "*":U
                       tt-digita.numero-ordem   = ordem-compra.numero-ordem
                       tt-digita.it-codigo      = ordem-compra.it-codigo
                       tt-digita.cod-emitente   = ordem-compra.cod-emitente
                       tt-digita.cod-estabel    = ordem-compra.cod-estabel
                       tt-digita.cod-comprado   = ordem-compra.cod-comprado
                       tt-digita.nr-processo    = ordem-compra.nr-processo
                       tt-digita.num-pedido     = ordem-compra.num-pedido
                       tt-digita.natureza       = ordem-compra.natureza
                       tt-digita.cod-transp     = ordem-compra.cod-transp
                       tt-digita.data-cotacao   = ordem-compra.data-cotacao
                       tt-digita.cod-cond-pag   = ordem-compra.cod-cond-pag.
            END.


        END.
        /* Carrega ordens de compra na Temp-Table "tt-digita" - Final */

        IF NOT CAN-FIND(FIRST tt-digita) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "NÆo foram encontradas Ordens de Compra para gera‡Æo de Pedido.":U).

            RETURN NO-APPLY.
        END.

        /* Carrega parƒmetros de tela na Temp-Table "tt-param" - In¡cio */
        EMPTY TEMP-TABLE tt-param.

        CREATE tt-param.
        ASSIGN tt-param.usuario   = c-seg-usuario
               tt-param.destino   = 3
               tt-param.data-exec = TODAY
               tt-param.hora-exec = TIME.

        FOR FIRST tt-digita
            BY tt-digita.cod-emitente:
            ASSIGN tt-param.i-forn-ini = tt-digita.cod-emitente.
        END.

        FOR LAST tt-digita
            BY tt-digita.cod-emitente:
            ASSIGN tt-param.i-forn-fim = tt-digita.cod-emitente.
        END.

        FOR FIRST tt-digita
            BY tt-digita.cod-estabel:
            ASSIGN tt-param.c-estabel-ini = tt-digita.cod-estabel.
        END.

        FOR LAST tt-digita
            BY tt-digita.cod-estabel:
            ASSIGN tt-param.c-estabel-fim = tt-digita.cod-estabel.
        END.

        FOR FIRST tt-digita
            BY tt-digita.nr-processo:
            ASSIGN tt-param.i-processo-ini = tt-digita.nr-processo.
        END.

        FOR LAST tt-digita
            BY tt-digita.nr-processo:
            ASSIGN tt-param.i-processo-fim = tt-digita.nr-processo.
        END.

        FOR FIRST tt-digita
            BY tt-digita.numero-ordem:
            ASSIGN tt-param.i-ord-ini = tt-digita.numero-ordem.
        END.

        FOR LAST tt-digita
            BY tt-digita.numero-ordem:
            ASSIGN tt-param.i-ord-fim = tt-digita.numero-ordem.
        END.

        FOR FIRST tt-digita
            BY tt-digita.data-cotacao:
            ASSIGN tt-param.da-cot-ini = tt-digita.data-cotacao.
        END.

        FOR LAST tt-digita
            BY tt-digita.data-cotacao:
            ASSIGN tt-param.da-cot-fim = tt-digita.data-cotacao.
        END.

        FOR FIRST tt-digita
            BY tt-digita.it-codigo:
            ASSIGN tt-param.c-it-ini = tt-digita.it-codigo.
        END.

        FOR LAST tt-digita
            BY tt-digita.it-codigo:
            ASSIGN tt-param.c-it-fim = tt-digita.it-codigo.
        END.

        FOR FIRST tt-digita
            BY tt-digita.cod-comprado:
            ASSIGN tt-param.c-comp-ini = tt-digita.cod-comprado.
        END.

        FOR LAST tt-digita
            BY tt-digita.cod-comprado:
            ASSIGN tt-param.c-comp-fim = tt-digita.cod-comprado.
        END.

        ASSIGN tt-param.i-nr-ordem      = 9999
               tt-param.da-data-ped     = INPUT FRAME fPage1 fi-data-pedido
               tt-param.c-est-cob       = INPUT FRAME fPage1 fi-end-cobranca
               tt-param.c-estab         = INPUT FRAME fPage1 fi-nome-estab-cob-ped
               tt-param.c-resp          = INPUT FRAME fPage1 fi-responsavel
               tt-param.c-deresp        = INPUT FRAME fPage1 fi-nome-responsavel
               tt-param.i-cod-mens      = INPUT FRAME fPage1 fi-cod-mensagem
               tt-param.c-msg           = INPUT FRAME fPage1 fi-desc-mens-pedido
               tt-param.i-condicao      = 1
               &IF DEFINED(bf_mat_contratos) &THEN
               tt-param.c-estab-gestor  = INPUT FRAME fPage1 fi-cod-estab-gestor
               &ELSE
               tt-param.c-estab-gestor  = "":U
               &ENDIF
               tt-param.i-frete         = INPUT FRAME fPage1 rs-frete
               tt-param.c-frete         = ENTRY((tt-param.i-frete - 1) * 2 + 1, rs-frete:RADIO-BUTTONS IN FRAME fPage1)
               tt-param.l-importacao    = INPUT FRAME fPage1 tg-gera-proc-imp.

        &IF DEFINED(bf_mat_oper_triangular) &THEN
        ASSIGN tt-param.i-cod-emit-terc = 0.

        FIND FIRST emitente
            WHERE emitente.cod-emitente = tt-param.i-cod-emit-terc NO-LOCK NO-ERROR.

        ASSIGN tt-param.c-nome-abrev = IF AVAILABLE emitente THEN emitente.nome-abrev ELSE "":U.
        &ELSE
        ASSIGN tt-param.i-cod-emit-terc = "":U
               tt-param.c-nome-abrev    = "":U.
        &ENDIF

        FIND FIRST cond-pagto
            WHERE cond-pagto.cod-cond-pag = tt-param.i-condicao NO-LOCK NO-ERROR.

        ASSIGN tt-param.c-pagto   = IF AVAILABLE cond-pagto THEN cond-pagto.descricao ELSE "":U
               tt-param.c-destino = "Terminal":U
               tt-param.arquivo   = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.
        /* Carrega parƒmetros de tela na Temp-Table "tt-param" - Final */

        /* Executa programa CC0311RP - In¡cio */
        IF SESSION:SET-WAIT-STATE("general":U) THEN.

        RAW-TRANSFER tt-param TO raw-param.

        EMPTY TEMP-TABLE tt-raw-digita.

        FOR EACH tt-digita:
            CREATE tt-raw-digita.
            RAW-TRANSFER tt-digita TO tt-raw-digita.raw-digita.
        END.

        RUN ccp/cc0311rp.p (INPUT raw-param,
                            INPUT TABLE tt-raw-digita).

        IF SESSION:SET-WAIT-STATE("":U) THEN.

        GET-KEY-VALUE SECTION "Datasul_EMS2":U KEY "Show-Report-Program":U VALUE cEditor.

        IF SEARCH(cEditor) = ? THEN DO:
            ASSIGN cEditor = OS-GETENV("windir":U) + "~\notepad.exe":U.

            IF SEARCH(cEditor) = ? THEN DO:
                ASSIGN cEditor = OS-GETENV("windir":U) + "~\write.exe":U.

                IF SEARCH(cEditor) = ? THEN
                    ASSIGN lAbreArquivo = NO.
            END.
            ELSE
                ASSIGN lAbreArquivo = YES.
        END.
        ELSE
            ASSIGN lAbreArquivo = YES.

        IF lAbreArquivo THEN
            RUN winexec (INPUT cEditor + CHR(32) + tt-param.arquivo, INPUT 1).
        ELSE
            OS-COMMAND NO-WAIT VALUE(tt-param.arquivo) NO-ERROR.
        /* Executa programa CC0311RP - Final */
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

