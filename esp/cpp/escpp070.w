&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgcad           PROGRESS
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
{include/i-prgvrs.i ESCPP070 2.06.00.002}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESCPP070 ESP}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP070
&GLOBAL-DEFINE Version        2.06.00.002

&GLOBAL-DEFINE WindowType     

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   vCodEstabel ~
                              vCodUnidNegoc ~
                              vPeriodoIni ~
                              vPeriodoFin ~
                              vDiasMes ~
                              btFil ~
                              btExit ~
                              brEstoque
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-estoque NO-UNDO
    FIELD cod-estabel    LIKE estabelec.cod-estabel                LABEL "Estabelecimento":U         COLUMN-LABEL "Estabel":U
    FIELD cod-unid-negoc LIKE unid-negoc.cod-unid-negoc            LABEL "Unidade Neg¢cio":U         COLUMN-LABEL "Un Neg¢cio":U
    FIELD it-codigo      LIKE item.it-codigo                       LABEL "Item":U                    COLUMN-LABEL "Item":U
    FIELD desc-item      LIKE item.desc-item                       LABEL "Descri‡Æo":U               COLUMN-LABEL "Descri‡Æo":U
    FIELD periodo        AS CHARACTER FORMAT "9999/99":U           LABEL "Per¡odo":U                 COLUMN-LABEL "Per¡odo":U
    FIELD situacao       AS CHARACTER FORMAT "x(30)":U             LABEL "Situa‡Æo":U                COLUMN-LABEL "Situa‡Æo":U
    FIELD quant-segur    LIKE item-uni-estab.quant-segur           LABEL "Qtd Seguran‡a":U           COLUMN-LABEL "Qtd Seguran‡a":U
    FIELD estoque-medio  AS DECIMAL   FORMAT "->>>,>>>,>>9.9999":U LABEL "Estoque M‚dio":U           COLUMN-LABEL "Estoque M‚dio":U
    FIELD consumo-medio  AS DECIMAL   FORMAT "->>>,>>>,>>9.9999":U LABEL "Consumo M‚dio":U           COLUMN-LABEL "Consumo M‚dio":U
    FIELD tp-despesa     LIKE ordem-compra.tp-despesa
    FIELD desc-tp-desp   LIKE tipo-rec-desp.descricao              LABEL "Descri‡Æo Despesa":U       COLUMN-LABEL "Desc Despesa":U
    FIELD tipo-item      AS CHARACTER FORMAT "x(10)":U             LABEL "Tipo Item":U               COLUMN-LABEL "Tp Item":U
    FIELD fm-cod-com     LIKE item.fm-cod-com
    FIELD ge-codigo      LIKE item.ge-codigo
    FIELD desc-ge        LIKE grup-estoque.descricao               LABEL "Descri‡Æo Grupo Estoque":U COLUMN-LABEL "Desc Gr Estoq":U
    INDEX ch-codigo IS PRIMARY UNIQUE
        cod-estabel
        cod-unid-negoc
        it-codigo
        periodo.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE deWidth      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deWidthDif   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deHeight     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deheightDif  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE lDesc        AS LOGICAL     NO-UNDO INITIAL NO.
DEFINE VARIABLE cQuery       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampoSearch AS CHARACTER   NO-UNDO.
DEFINE VARIABLE hAcomp       AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brEstoque

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-estoque

/* Definitions for BROWSE brEstoque                                     */
&Scoped-define FIELDS-IN-QUERY-brEstoque tt-estoque.cod-estabel tt-estoque.cod-unid-negoc tt-estoque.it-codigo tt-estoque.desc-item tt-estoque.periodo tt-estoque.situacao tt-estoque.quant-segur tt-estoque.estoque-medio tt-estoque.consumo-medio tt-estoque.tp-despesa tt-estoque.desc-tp-desp tt-estoque.tipo-item tt-estoque.fm-cod-com tt-estoque.ge-codigo tt-estoque.desc-ge   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brEstoque   
&Scoped-define SELF-NAME brEstoque
&Scoped-define QUERY-STRING-brEstoque FOR EACH tt-estoque
&Scoped-define OPEN-QUERY-brEstoque OPEN QUERY {&SELF-NAME} FOR EACH tt-estoque.
&Scoped-define TABLES-IN-QUERY-brEstoque tt-estoque
&Scoped-define FIRST-TABLE-IN-QUERY-brEstoque tt-estoque


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brEstoque}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-11 IMAGE-1 IMAGE-2 vCodEstabel ~
vCodUnidNegoc vPeriodoIni vPeriodoFin vDiasMes btFil btExit brEstoque 
&Scoped-Define DISPLAYED-OBJECTS vCodEstabel vCodUnidNegoc vPeriodoIni ~
vPeriodoFin vDiasMes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFiltrar      LABEL "&Filtrar"      
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.13
     FONT 4.

DEFINE BUTTON btFil 
     IMAGE-UP FILE "image/im-enter.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-enter.bmp":U
     LABEL "Filtrar" 
     SIZE 4 BY 1.13.

DEFINE VARIABLE vCodEstabel LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE vCodUnidNegoc LIKE unid-negoc.cod-unid-negoc
     LABEL "Unid Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE vDiasMes AS INTEGER FORMAT ">>9":U INITIAL 30 
     LABEL "Dias Mˆs" 
     VIEW-AS FILL-IN 
     SIZE 6.43 BY .88 NO-UNDO.

DEFINE VARIABLE vPeriodoFin AS CHARACTER FORMAT "9999/99":U INITIAL "299912" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE vPeriodoIni AS CHARACTER FORMAT "9999/99":U INITIAL "180001" 
     LABEL "Per¡odo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brEstoque FOR 
      tt-estoque SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brEstoque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brEstoque wWindow _FREEFORM
  QUERY brEstoque DISPLAY
      tt-estoque.cod-estabel
      tt-estoque.cod-unid-negoc
      tt-estoque.it-codigo      WIDTH 21.50
      tt-estoque.desc-item      WIDTH 30.00
      tt-estoque.periodo        WIDTH  9.00
      tt-estoque.situacao       WIDTH 32.00
      tt-estoque.quant-segur    WIDTH 12.86
      tt-estoque.estoque-medio
      tt-estoque.consumo-medio
      tt-estoque.tp-despesa
      tt-estoque.desc-tp-desp
      tt-estoque.tipo-item
      tt-estoque.fm-cod-com
      tt-estoque.ge-codigo
      tt-estoque.desc-ge
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 18.71
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     vCodEstabel AT ROW 1.58 COL 12.43 COLON-ALIGNED HELP
          "C¢digo do estabelecimento"
     vCodUnidNegoc AT ROW 1.58 COL 31.43 COLON-ALIGNED HELP
          "C¢digo Unidade Neg¢cio"
          LABEL "Unid Neg¢cio"
     vPeriodoIni AT ROW 2.58 COL 12.43 COLON-ALIGNED HELP
          "Per¡odo Inicial"
     vPeriodoFin AT ROW 2.58 COL 31.43 COLON-ALIGNED HELP
          "Per¡odo Final" NO-LABEL
     vDiasMes AT ROW 2.58 COL 51.57 COLON-ALIGNED
     btFil AT ROW 2.58 COL 82 HELP
          "Filtrar"
     btExit AT ROW 2.58 COL 86 HELP
          "Sair"
     brEstoque AT ROW 4.08 COL 1.57 HELP
          "Estoque M‚dio e Consumo M‚dio"
     RECT-11 AT ROW 1.17 COL 1.57
     IMAGE-1 AT ROW 2.58 COL 24.72
     IMAGE-2 AT ROW 2.58 COL 30.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 22
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
         HEIGHT             = 22
         WIDTH              = 90
         MAX-HEIGHT         = 200
         MAX-WIDTH          = 300
         VIRTUAL-HEIGHT     = 200
         VIRTUAL-WIDTH      = 300
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
/* BROWSE-TAB brEstoque btExit fpage0 */
ASSIGN 
       brEstoque:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = TRUE
       brEstoque:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

/* SETTINGS FOR FILL-IN vCodEstabel IN FRAME fpage0
   LIKE = mgcad.estabelec.cod-estabel EXP-SIZE                         */
/* SETTINGS FOR FILL-IN vCodUnidNegoc IN FRAME fpage0
   LIKE = mgcad.unid-negoc.cod-unid-negoc EXP-LABEL EXP-SIZE           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brEstoque
/* Query rebuild information for BROWSE brEstoque
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-estoque.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brEstoque */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-MAXIMIZED OF wWindow
DO:
    ASSIGN FRAME fPage0:WIDTH          = CURRENT-WINDOW:WIDTH
           FRAME fPage0:HEIGHT         = CURRENT-WINDOW:HEIGHT
           FRAME fPage0:WIDTH-CHARS    = CURRENT-WINDOW:WIDTH-CHARS
           FRAME fPage0:HEIGHT-CHARS   = CURRENT-WINDOW:HEIGHT-CHARS
           FRAME fPage0:VIRTUAL-WIDTH  = FRAME fPage0:WIDTH
           FRAME fPage0:VIRTUAL-HEIGHT = FRAME fPage0:HEIGHT
           deWidthDif                  = CURRENT-WINDOW:WIDTH - deWidth
           deHeightDif                 = CURRENT-WINDOW:HEIGHT - deHeight.

    ASSIGN vCodEstabel:COLUMN                     IN FRAME fPage0 = vCodEstabel:COLUMN                     IN FRAME fPage0 + (deWidthDif / 2)
           vCodEstabel:SIDE-LABEL-HANDLE:COLUMN   IN FRAME fPage0 = vCodEstabel:SIDE-LABEL-HANDLE:COLUMN   IN FRAME fPage0 + (deWidthDif / 2)
           vCodUnidNegoc:COLUMN                   IN FRAME fPage0 = vCodUnidNegoc:COLUMN                   IN FRAME fPage0 + (deWidthDif / 2)
           vCodUnidNegoc:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 = vCodUnidNegoc:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 + (deWidthDif / 2)
           vPeriodoIni:COLUMN                     IN FRAME fPage0 = vPeriodoIni:COLUMN                     IN FRAME fPage0 + (deWidthDif / 2)
           vPeriodoIni:SIDE-LABEL-HANDLE:COLUMN   IN FRAME fPage0 = vPeriodoIni:SIDE-LABEL-HANDLE:COLUMN   IN FRAME fPage0 + (deWidthDif / 2)
           IMAGE-1:COLUMN                         IN FRAME fPage0 = IMAGE-1:COLUMN                         IN FRAME fPage0 + (deWidthDif / 2)
           IMAGE-2:COLUMN                         IN FRAME fPage0 = IMAGE-2:COLUMN                         IN FRAME fPage0 + (deWidthDif / 2)
           vPeriodoFin:COLUMN                     IN FRAME fPage0 = vPeriodoFin:COLUMN                     IN FRAME fPage0 + (deWidthDif / 2)
           vDiasMes:COLUMN                        IN FRAME fPage0 = vDiasMes:COLUMN                        IN FRAME fPage0 + (deWidthDif / 2)
           vDiasMes:SIDE-LABEL-HANDLE:COLUMN      IN FRAME fPage0 = vDiasMes:SIDE-LABEL-HANDLE:COLUMN      IN FRAME fPage0 + (deWidthDif / 2)
           btFil:COLUMN                           IN FRAME fPage0 = btFil:COLUMN                           IN FRAME fPage0 +  deWidthDif
           btExit:COLUMN                          IN FRAME fPage0 = btExit:COLUMN                          IN FRAME fPage0 +  deWidthDif
           RECT-11:WIDTH                          IN FRAME fPage0 = RECT-11:WIDTH                          IN FRAME fPage0 +  deWidthDif
           brEstoque:WIDTH                        IN FRAME fPage0 = brEstoque:WIDTH                        IN FRAME fPage0 +  deWidthDif
           brEstoque:HEIGHT                       IN FRAME fPage0 = brEstoque:HEIGHT                       IN FRAME fPage0 +  deHeightDif.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-RESIZED OF wWindow
DO:
    IF CURRENT-WINDOW:WIDTH  <> deWidth  AND
       CURRENT-WINDOW:HEIGHT <> deHeight THEN
        RETURN "NOK":U.

    ASSIGN vCodEstabel:COLUMN                     IN FRAME fPage0 = vCodEstabel:COLUMN                     IN FRAME fPage0 - (deWidthDif / 2)
           vCodEstabel:SIDE-LABEL-HANDLE:COLUMN   IN FRAME fPage0 = vCodEstabel:SIDE-LABEL-HANDLE:COLUMN   IN FRAME fPage0 - (deWidthDif / 2)
           vCodUnidNegoc:COLUMN                   IN FRAME fPage0 = vCodUnidNegoc:COLUMN                   IN FRAME fPage0 - (deWidthDif / 2)
           vCodUnidNegoc:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 = vCodUnidNegoc:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 - (deWidthDif / 2)
           vPeriodoIni:COLUMN                     IN FRAME fPage0 = vPeriodoIni:COLUMN                     IN FRAME fPage0 - (deWidthDif / 2)
           vPeriodoIni:SIDE-LABEL-HANDLE:COLUMN   IN FRAME fPage0 = vPeriodoIni:SIDE-LABEL-HANDLE:COLUMN   IN FRAME fPage0 - (deWidthDif / 2)
           IMAGE-1:COLUMN                         IN FRAME fPage0 = IMAGE-1:COLUMN                         IN FRAME fPage0 - (deWidthDif / 2)
           IMAGE-2:COLUMN                         IN FRAME fPage0 = IMAGE-2:COLUMN                         IN FRAME fPage0 - (deWidthDif / 2)
           vPeriodoFin:COLUMN                     IN FRAME fPage0 = vPeriodoFin:COLUMN                     IN FRAME fPage0 - (deWidthDif / 2)
           vDiasMes:COLUMN                        IN FRAME fPage0 = vDiasMes:COLUMN                        IN FRAME fPage0 - (deWidthDif / 2)
           vDiasMes:SIDE-LABEL-HANDLE:COLUMN      IN FRAME fPage0 = vDiasMes:SIDE-LABEL-HANDLE:COLUMN      IN FRAME fPage0 - (deWidthDif / 2)
           btFil:COLUMN                           IN FRAME fPage0 = btFil:COLUMN                           IN FRAME fPage0 -  deWidthDif
           btExit:COLUMN                          IN FRAME fPage0 = btExit:COLUMN                          IN FRAME fPage0 -  deWidthDif
           RECT-11:WIDTH                          IN FRAME fPage0 = RECT-11:WIDTH                          IN FRAME fPage0 -  deWidthDif
           brEstoque:WIDTH                        IN FRAME fPage0 = brEstoque:WIDTH                        IN FRAME fPage0 -  deWidthDif
           brEstoque:HEIGHT                       IN FRAME fPage0 = brEstoque:HEIGHT                       IN FRAME fPage0 -  deHeightDif.

    ASSIGN FRAME fPage0:WIDTH          = CURRENT-WINDOW:WIDTH
           FRAME fPage0:HEIGHT         = CURRENT-WINDOW:HEIGHT
           FRAME fPage0:WIDTH-CHARS    = CURRENT-WINDOW:WIDTH-CHARS
           FRAME fPage0:HEIGHT-CHARS   = CURRENT-WINDOW:HEIGHT-CHARS
           FRAME fPage0:VIRTUAL-WIDTH  = FRAME fPage0:WIDTH
           FRAME fPage0:VIRTUAL-HEIGHT = FRAME fPage0:HEIGHT.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brEstoque
&Scoped-define SELF-NAME brEstoque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brEstoque wWindow
ON START-SEARCH OF brEstoque IN FRAME fpage0
DO:
    IF SELF:CURRENT-COLUMN:TABLE <> "":U AND
       SELF:CURRENT-COLUMN:NAME  <> ?    AND
       SELF:CURRENT-COLUMN:NAME  <> "":U THEN DO:
        IF cCampoSearch = SELF:CURRENT-COLUMN:NAME THEN DO:
            ASSIGN lDesc = NOT lDesc.

            IF lDesc THEN
                ASSIGN cQuery = "FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " DESC INDEXED-REPOSITION":U.
            ELSE
                ASSIGN cQuery = "FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " INDEXED-REPOSITION":U.
        END.
        ELSE
            ASSIGN cQuery       = "FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " INDEXED-REPOSITION":U
                   cCampoSearch = SELF:CURRENT-COLUMN:NAME
                   lDesc        = NO.

        SELF:QUERY:QUERY-PREPARE(cQuery).
        SELF:QUERY:QUERY-OPEN().
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


&Scoped-define SELF-NAME btFil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFil wWindow
ON CHOOSE OF btFil IN FRAME fpage0 /* Filtrar */
OR CHOOSE OF MENU-ITEM miFiltrar IN MENU mbMain DO:
    EMPTY TEMP-TABLE tt-estoque.

    {&OPEN-QUERY-brEstoque}

    ASSIGN INPUT FRAME fpage0 vCodEstabel
                              vCodUnidNegoc
                              vPeriodoIni
                              vPeriodoFin
                              vDiasMes.

    FIND FIRST estabelec
        WHERE estabelec.cod-estabel = vCodEstabel NO-LOCK NO-ERROR.

    IF NOT AVAILABLE estabelec THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 2,
                           INPUT "Estabelecimento":U).

        RETURN NO-APPLY.
    END.

    FIND FIRST unid-negoc
        WHERE unid-negoc.cod-unid-negoc = vCodUnidNegoc NO-LOCK NO-ERROR.

    IF NOT AVAILABLE unid-negoc THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 2,
                           INPUT "Unidade de Neg¢cio":U).

        RETURN NO-APPLY.
    END.

    IF vPeriodoIni = "":U OR
       vPeriodoFin = "":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Per¡odo inv lido.":U).

        RETURN NO-APPLY.
    END.

    IF vPeriodoIni > vPeriodoFin THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Per¡odo inv lido.~~O per¡odo inicial deve ser igual ou inferior ao per¡odo final.":U).

        RETURN NO-APPLY.
    END.

    IF vDiasMes <= 0 OR
       vDiasMes  = ? THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Dias Mˆs inv lido.~~O campo ~"Dias Mˆs~" deve ser preenchido para que possa ser encontrado a m‚dia de saldo do estoque e a m‚dia de consumo no per¡odo.":U).

        RETURN NO-APPLY.
    END.

    IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN.

    IF NOT VALID-HANDLE(hAcomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.

    EMPTY TEMP-TABLE tt-estoque.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-inicializar IN hAcomp (INPUT "":U).

    RUN piEstoqueConsumoMedio IN THIS-PROCEDURE.

    {&OPEN-QUERY-brEstoque}

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-finalizar IN hAcomp.

    IF SESSION:SET-WAIT-STATE("":U) THEN.

    IF VALID-HANDLE(hAcomp) THEN
        DELETE OBJECT hAcomp.

    ASSIGN hAcomp = ?.

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


&Scoped-define SELF-NAME miContents
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miContents wWindow
ON CHOOSE OF MENU-ITEM miContents /* Conte£do */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vCodUnidNegoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vCodUnidNegoc wWindow
ON F5 OF vCodUnidNegoc IN FRAME fpage0 /* Unid Neg¢cio */
DO:
    {method/ZoomFields.i &ProgramZoom="inzoom/z01in745.w"
                         &FieldZoom1="cod-unid-negoc"
                         &FieldScreen1="vCodUnidNegoc"
                         &Frame1="fpage0"
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vCodUnidNegoc wWindow
ON MOUSE-SELECT-DBLCLICK OF vCodUnidNegoc IN FRAME fpage0 /* Unid Neg¢cio */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/*--- Seta cursor do mouse para lupa, quando estiver posicionado sobre o fill-in ---*/
IF vCodUnidNegoc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage0 THEN.

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
    ASSIGN deWidth  = CURRENT-WINDOW:WIDTH
           deHeight = CURRENT-WINDOW:HEIGHT.

    ASSIGN vCodEstabel   = "101":U
           vCodUnidNegoc = "SEC":U
           vPeriodoIni   = STRING(YEAR(TODAY), "9999":U) + STRING((MONTH(TODAY) - 7), "99":U)
           vPeriodoFin   = STRING(YEAR(TODAY), "9999":U) + STRING((MONTH(TODAY) - 1), "99":U)
           vDiasMes      = 30.

    DISPLAY vCodEstabel
            vCodUnidNegoc
            vPeriodoIni
            vPeriodoFin
            vDiasMes
        WITH FRAME fpage0.

    DISABLE vCodEstabel
        WITH FRAME fpage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEstoqueConsumoMedio wWindow 
PROCEDURE piEstoqueConsumoMedio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dt-periodo-ini   AS DATE        NO-UNDO.
    DEFINE VARIABLE dt-periodo-fin   AS DATE        NO-UNDO.
    DEFINE VARIABLE dt-periodo-aux   AS DATE        NO-UNDO.
    DEFINE VARIABLE dt-per-atual-ini AS DATE        NO-UNDO.
    DEFINE VARIABLE dt-per-atual-fin AS DATE        NO-UNDO.
    DEFINE VARIABLE dt-per-atual-aux AS DATE        NO-UNDO.

    DEFINE VARIABLE v-qtd-per-ant    LIKE sl-it-per.quantidade   NO-UNDO.
    DEFINE VARIABLE v-qtd-movto-item LIKE movto-estoq.quantidade NO-UNDO.
    DEFINE VARIABLE v-qtd-consu-item LIKE movto-estoq.quantidade NO-UNDO.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-seta-titulo IN hAcomp (INPUT "Buscando Estoque/Consumo M‚dio...":U).

    ASSIGN dt-periodo-ini = DATE(INTEGER(TRIM(SUBSTRING(vPeriodoIni, 5, 2))), 01, INTEGER(TRIM(SUBSTRING(vPeriodoIni, 1, 4))))
           dt-periodo-fin = DATE(INTEGER(TRIM(SUBSTRING(vPeriodoFin, 5, 2))), 01, INTEGER(TRIM(SUBSTRING(vPeriodoFin, 1, 4)))).

    /* Buscando TODOS os Itens ATIVOS */
    FOR EACH item NO-LOCK
        WHERE item.cod-obsoleto < 2:

        /* Desconsiderar o Item "D‚bito Direto" */
        IF item.it-codigo = "":U THEN
            NEXT.

        FIND FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo   = item.it-codigo
              AND item-uni-estab.cod-estabel = vCodEstabel NO-LOCK NO-ERROR.

        IF NOT AVAILABLE item-uni-estab                   OR
           item-uni-estab.cod-unid-negoc <> vCodUnidNegoc THEN
            NEXT.

        ASSIGN dt-periodo-aux = dt-periodo-ini.

        DO WHILE dt-periodo-aux <= dt-periodo-fin:
            IF VALID-HANDLE(hAcomp) THEN
                RUN pi-acompanhar IN hAcomp (INPUT "Item: ":U + item-uni-estab.it-codigo + " - Periodo: ":U + TRIM(STRING(YEAR(dt-periodo-aux), "9999":U)) + "/":U + TRIM(STRING(MONTH(dt-periodo-aux), "99":U))).

            ASSIGN v-qtd-per-ant    = 0
                   v-qtd-movto-item = 0
                   v-qtd-consu-item = 0.

            /* Levantando o Saldo do Item no Final do Per¡odo Anterior */
            FOR EACH sl-it-per FIELDS(quantidade) USE-INDEX per-item NO-LOCK
                WHERE sl-it-per.periodo     = dt-periodo-aux - 1
                  AND sl-it-per.it-codigo   = item-uni-estab.it-codigo
                  AND sl-it-per.cod-estabel = item-uni-estab.cod-estabel:
                ASSIGN v-qtd-per-ant = v-qtd-per-ant + sl-it-per.quantidade.
            END.

            ASSIGN dt-per-atual-ini = dt-periodo-aux
                   dt-per-atual-fin = DATE(MONTH(dt-periodo-aux), 25, YEAR(dt-periodo-aux)) + 15
                   dt-per-atual-fin = dt-per-atual-fin - DAY(dt-per-atual-fin).

            /* Levantando o Saldo do Item no Final do Per¡odo Anterior */
            DO dt-per-atual-aux = dt-per-atual-ini TO dt-per-atual-fin:
                FOR EACH movto-estoq FIELDS(tipo-trans quantidade esp-docto) USE-INDEX item-data NO-LOCK
                    WHERE movto-estoq.it-codigo   = item-uni-estab.it-codigo
                      AND movto-estoq.cod-estabel = item-uni-estab.cod-estabel
                      AND movto-estoq.dt-trans    = dt-per-atual-aux:
                    IF movto-estoq.tipo-trans = 1 THEN /* Entrada */
                        ASSIGN v-qtd-movto-item = v-qtd-movto-item + movto-estoq.quantidade.
                    ELSE DO: /* Sa¡da */
                        ASSIGN v-qtd-movto-item = v-qtd-movto-item - movto-estoq.quantidade.

                        IF movto-estoq.esp-docto = 22 THEN DO: /* NFS - Nota Fiscal de Sa¡da */
                            FIND FIRST natur-oper
                                WHERE natur-oper.nat-operacao = movto-estoq.nat-operacao NO-LOCK NO-ERROR.

                            IF  AVAILABLE natur-oper      AND
                                natur-oper.terceiros      AND  /* Opera‡Æo com Terceiros */
                               (natur-oper.oper-terc = 3  OR   /* Remessa Consigna‡Æo */
                                natur-oper.oper-terc = 4) THEN /* Faturamento Consigna‡Æo */
                                ASSIGN v-qtd-movto-item = v-qtd-movto-item + movto-estoq.quantidade.
                        END.

                        IF movto-estoq.esp-docto = 01 OR   /* ACA - Acabado */
                           movto-estoq.esp-docto = 28 THEN /* REQ - Requisi‡Æo */
                            ASSIGN v-qtd-consu-item = v-qtd-consu-item + movto-estoq.quantidade.
                    END.
                END.
            END.

            FIND FIRST tt-estoque
                WHERE tt-estoque.cod-estabel    = item-uni-estab.cod-estabel
                  AND tt-estoque.cod-unid-negoc = item-uni-estab.cod-unid-negoc
                  AND tt-estoque.it-codigo      = item-uni-estab.it-codigo
                  AND tt-estoque.periodo        = TRIM(STRING(YEAR(dt-periodo-aux), "9999":U)) + TRIM(STRING(MONTH(dt-periodo-aux), "99":U)) NO-LOCK NO-ERROR.

            IF NOT AVAILABLE tt-estoque THEN DO:
                FIND FIRST grup-estoque
                    WHERE grup-estoque.ge-codigo = item.ge-codigo NO-LOCK NO-ERROR.

                FIND LAST ordem-compra USE-INDEX compra-item
                    WHERE ordem-compra.it-codigo = item-uni-estab.it-codigo NO-LOCK NO-ERROR.

                IF AVAILABLE ordem-compra THEN
                    FIND FIRST tipo-rec-desp
                        WHERE tipo-rec-desp.tp-codigo = ordem-compra.tp-despesa NO-LOCK NO-ERROR.
                ELSE
                    RELEASE tipo-rec-desp.

                CREATE tt-estoque.
                ASSIGN tt-estoque.cod-estabel    = item-uni-estab.cod-estabel
                       tt-estoque.cod-unid-negoc = item-uni-estab.cod-unid-negoc
                       tt-estoque.it-codigo      = item-uni-estab.it-codigo
                       tt-estoque.desc-item      = item.desc-item
                       tt-estoque.periodo        = TRIM(STRING(YEAR(dt-periodo-aux), "9999":U)) + TRIM(STRING(MONTH(dt-periodo-aux), "99":U))
                       tt-estoque.tp-despesa     = IF AVAILABLE ordem-compra THEN ordem-compra.tp-despesa ELSE ?
                       tt-estoque.desc-tp-desp   = IF AVAILABLE tipo-rec-desp THEN tipo-rec-desp.descricao ELSE "":U
                       tt-estoque.tipo-item      = IF item.compr-fabric = 1 THEN "Comprado":U ELSE "Fabricado":U
                       tt-estoque.fm-cod-com     = item.fm-cod-com
                       tt-estoque.ge-codigo      = item.ge-codigo
                       tt-estoque.desc-ge        = IF AVAILABLE grup-estoque THEN grup-estoque.descricao ELSE "":U.

                IF item.cod-obsoleto = 1 THEN
                    ASSIGN tt-estoque.situacao = "Ativo":U.
                ELSE IF item.cod-obsoleto = 2 THEN
                    ASSIGN tt-estoque.situacao = "Obsoleto Ordens Autom ticas":U.
                ELSE
                    ASSIGN tt-estoque.situacao = "-":U.
            END.

            FIND LAST int-coesa-estoq-segur USE-INDEX id-estoq-quant
                WHERE int-coesa-estoq-segur.cod-estabel   = item-uni-estab.cod-estabel
                  AND int-coesa-estoq-segur.it-codigo     = item-uni-estab.it-codigo
                  AND int-coesa-estoq-segur.dat-registro <= dt-periodo-aux NO-LOCK NO-ERROR.

            IF AVAILABLE int-coesa-estoq-segur THEN
                ASSIGN tt-estoque.quant-segur = int-coesa-estoq-segur.quant-segur.
            ELSE
                ASSIGN tt-estoque.quant-segur = item-uni-estab.quant-segur.

            ASSIGN tt-estoque.estoque-medio = tt-estoque.estoque-medio + ((v-qtd-per-ant + v-qtd-movto-item) / vDiasMes)
                   tt-estoque.consumo-medio = tt-estoque.consumo-medio + (v-qtd-consu-item / vDiasMes).

            /* Incrementando o Per¡odo - Mˆs a Mˆs */
            ASSIGN dt-periodo-aux = ADD-INTERVAL(dt-periodo-aux, 1, "MONTHS":U).
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

