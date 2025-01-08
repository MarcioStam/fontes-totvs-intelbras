&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emscad             PROGRESS
          emsmov             PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE fi_dat_transacao_ini AS DATE FORMAT "99/99/9999" INIT "01/01/1900" NO-UNDO. 
DEFINE VARIABLE fi_dat_transacao_fim AS DATE FORMAT "99/99/9999" INIT "12/31/9999" NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_empres_usuar    AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_estab_usuar     AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_cliente         AS RECID        NO-UNDO.

def var i-tit          like tit_acr.cod_tit_acr.
def var da-tit         like tit_acr.dat_vencto_tit_acr.

def temp-table tt-baixa
    field cod-esp       like tit_acr.cod_espec_docto
    field nr-docto      like tit_acr.cod_tit_acr
    field parcela       like tit_acr.cod_parcela label "Pa"
    field tit-vend      LIKE tit_acr.cod_tit_acr label "NF"
    field cod-port      like movto_tit_acr.cod_portador
    field modalidade    like movto_tit_acr.cod_cart_bcia label "M"
    field dt-vencimen   like movto_tit_acr.dat_vencto_tit_acr
    field dt-baixa      like movto_tit_acr.dat_liquidac_tit_acr
    field periodo       as char format "9999/99"
    field vl-baixa      like movto_tit_acr.val_abat_tit_acr
    index tt-baixas is primary unique cod-esp nr-docto parcela dt-baixa.


DEFINE NEW SHARED VARIABLE cCod_empresa    AS CHARACTER     NO-UNDO.
DEFINE NEW SHARED VARIABLE iCdn_cliente    AS INTEGER       NO-UNDO.
DEFINE NEW SHARED VARIABLE dtBaixaini      AS DATE          NO-UNDO FORMAT "99/99/9999" LABEL "Data Baixa"
    VIEW-AS FILL-IN SIZE 10 BY .88.
DEFINE NEW SHARED VARIABLE dtBaixafim      AS DATE          NO-UNDO FORMAT "99/99/9999"
    VIEW-AS FILL-IN SIZE 10 BY .88. 
DEFINE NEW SHARED VARIABLE cEspecieini     AS CHARACTER     NO-UNDO FORMAT "XX"         LABEL "EspÇcie"
    VIEW-AS FILL-IN SIZE 4 BY .88 . 
DEFINE NEW SHARED VARIABLE cEspeciefim     AS CHARACTER     NO-UNDO FORMAT "XX"
    VIEW-AS FILL-IN SIZE 4 BY .88 . 
DEFINE NEW SHARED VARIABLE cPortadorini    AS CHARACTER     NO-UNDO FORMAT "XXX"        LABEL "Portador" 
    VIEW-AS FILL-IN SIZE 6 BY .88 . 
DEFINE NEW SHARED VARIABLE cPortadorfim    AS CHARACTER     NO-UNDO FORMAT "XXX"
    VIEW-AS FILL-IN SIZE 6 BY .88 . 

DEFINE BUFFER bTit_acr FOR tit_acr.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-baixa

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 tt-baixa.cod-esp tt-baixa.nr-docto tt-baixa.parcela tt-baixa.tit-ven tt-baixa.cod-port tt-baixa.modalidade tt-baixa.dt-vencimen tt-baixa.dt-baixa tt-baixa.dt-baixa - tt-baixa.dt-vencimen tt-baixa.vl-baixa   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1   
&Scoped-define SELF-NAME BROWSE-1
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH tt-baixa     NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY {&SELF-NAME} FOR EACH tt-baixa     NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 tt-baixa
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 tt-baixa


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btFirst btPrev btNext btLast btDet btZoom ~
btFiltro btPrint btExit btHelp cod-cliente btGoTo BROWSE-1 rtParent ~
rtParent-2 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS cod-cliente c-cliente i-tot 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miDetalhe      LABEL "Detalhe"        ACCELERATOR "ALT-D"
       MENU-ITEM miPesquisa     LABEL "Pesquisa"       ACCELERATOR "ALT-Z"
       RULE
       MENU-ITEM miFaixa        LABEL "Faixa"         
       RULE
       MENU-ITEM miRelat        LABEL "Relat¢rios"    
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btDet 
     IMAGE-UP FILE "image/im-det.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-det.bmp":U
     LABEL "Mail" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image\im-ran.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-ran.bmp":U
     LABEL "Mail" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY .88.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image/im-nex1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-nex1.bmp":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image/im-pre1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-pre1.bmp":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrint 
     IMAGE-UP FILE "image\im-pri.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-pri.bmp":U
     LABEL "Mail" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btZoom 
     IMAGE-UP FILE "image/im-sea1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sea1.bmp":U
     LABEL "Mail" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE c-cliente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE cod-cliente AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE i-tot AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Total Baixa" 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.54.

DEFINE RECTANGLE rtParent-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      tt-baixa SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 C-Win _FREEFORM
  QUERY BROWSE-1 NO-LOCK DISPLAY
      tt-baixa.cod-esp label "Esp"
         tt-baixa.nr-docto label "Docto"
         tt-baixa.parcela label "Pa"
         tt-baixa.tit-ven label "NF"
         tt-baixa.cod-port label "Port"
         tt-baixa.modalidade label "M"
         tt-baixa.dt-vencimen label "Vencto"
         tt-baixa.dt-baixa label "Baixa"
         tt-baixa.dt-baixa - tt-baixa.dt-vencimen label "DD" format "->>>9"
         tt-baixa.vl-baixa label "Valor Baixa"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 90 BY 11.75
         FONT 1
         TITLE "T°tulos" EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btDet AT ROW 1.13 COL 18.57 HELP
          "Pesquisa"
     btZoom AT ROW 1.13 COL 22.72 HELP
          "Pesquisa"
     btFiltro AT ROW 1.13 COL 27.86 HELP
          "Pesquisa"
     btPrint AT ROW 1.13 COL 32.86 HELP
          "Pesquisa"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     cod-cliente AT ROW 3 COL 9.29 COLON-ALIGNED
     btGoTo AT ROW 3 COL 29 HELP
          "V† Para"
     c-cliente AT ROW 3 COL 31.57 COLON-ALIGNED NO-LABEL
     i-tot AT ROW 4.83 COL 18.43 COLON-ALIGNED
     BROWSE-1 AT ROW 6.25 COL 1
     rtParent AT ROW 2.71 COL 1
     rtParent-2 AT ROW 4.5 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta Pagamentos Efetuados - ESACR002 - ES0796"
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 32.13
         MAX-WIDTH          = 164.57
         VIRTUAL-HEIGHT     = 32.13
         VIRTUAL-WIDTH      = 164.57
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



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* BROWSE-TAB BROWSE-1 i-tot DEFAULT-FRAME */
/* SETTINGS FOR FILL-IN c-cliente IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-tot IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-baixa
    NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "movto_tit_acr.cdn_cliente = INTEGER(cod-cliente)
 AND movto_tit_acr.dat_transacao >= fi_dat_transacao
 AND movto_tit_acr.dat_transacao <= i-movto_tit_acredfim"
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Consulta Pagamentos Efetuados - ESACR002 - ES0796 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Consulta Pagamentos Efetuados - ESACR002 - ES0796 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDet C-Win
ON CHOOSE OF btDet IN FRAME DEFAULT-FRAME /* Mail */
DO:
  RUN pi-detalhe.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit C-Win
ON CHOOSE OF btExit IN FRAME DEFAULT-FRAME /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro C-Win
ON CHOOSE OF btFiltro IN FRAME DEFAULT-FRAME /* Mail */
DO:
  RUN pi-filter.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst C-Win
ON CHOOSE OF btFirst IN FRAME DEFAULT-FRAME /* First */
DO:
  RUN pi-first.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo C-Win
ON CHOOSE OF btGoTo IN FRAME DEFAULT-FRAME /* Go To */
DO:
    ASSIGN cod-cliente.
    RUN pi-gotorecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast C-Win
ON CHOOSE OF btLast IN FRAME DEFAULT-FRAME /* Last */
DO:
  RUN pi-last.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext C-Win
ON CHOOSE OF btNext IN FRAME DEFAULT-FRAME /* Next */
DO:
  RUN pi-next.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev C-Win
ON CHOOSE OF btPrev IN FRAME DEFAULT-FRAME /* Prev */
DO:
  RUN pi-prev.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrint
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrint C-Win
ON CHOOSE OF btPrint IN FRAME DEFAULT-FRAME /* Mail */
DO:
  RUN pi-print.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btZoom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btZoom C-Win
ON CHOOSE OF btZoom IN FRAME DEFAULT-FRAME /* Mail */
DO:
  RUN pi-zoom.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miDetalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miDetalhe C-Win
ON CHOOSE OF MENU-ITEM miDetalhe /* Detalhe */
DO:
  APPLY "CHOOSE" TO btDet IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miFaixa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miFaixa C-Win
ON CHOOSE OF MENU-ITEM miFaixa /* Faixa */
DO:
  APPLY "CHOOSE" TO btFiltro IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miFirst C-Win
ON CHOOSE OF MENU-ITEM miFirst /* Primeiro */
DO:
  APPLY "CHOOSE" TO btFirst IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miLast C-Win
ON CHOOSE OF MENU-ITEM miLast /* Èltimo */
DO:
  APPLY "CHOOSE" TO btLast IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miNext C-Win
ON CHOOSE OF MENU-ITEM miNext /* Pr¢ximo */
DO:
  APPLY "CHOOSE" TO btNext IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miPesquisa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miPesquisa C-Win
ON CHOOSE OF MENU-ITEM miPesquisa /* Pesquisa */
DO:
  APPLY "CHOOSE" TO btZoom IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miPrev C-Win
ON CHOOSE OF MENU-ITEM miPrev /* Anterior */
DO:
  APPLY "CHOOSE" TO btPrev IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miRelat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miRelat C-Win
ON CHOOSE OF MENU-ITEM miRelat /* Relat¢rios */
DO:
  APPLY "CHOOSE" TO btPrint IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    ASSIGN dtBaixaini      = DATE(MONTH(TODAY), 1, YEAR(TODAY))
           dtBaixafim      = TODAY
           cEspecieini     = ''
           cEspeciefim     = 'ZZ'
           cPortadorini    = ''
           cPortadorfim    = 'ZZZ'. 

    RUN enable_UI.
    RUN pi-first.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

{esp/acr/esacr002.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY cod-cliente c-cliente i-tot 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE btFirst btPrev btNext btLast btDet btZoom btFiltro btPrint btExit 
         btHelp cod-cliente btGoTo BROWSE-1 rtParent rtParent-2 rtToolBar 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-totais C-Win 
PROCEDURE pi-calcula-totais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-detalhe C-Win 
PROCEDURE pi-detalhe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Atribuir a variavel global v_rec_cliente com o recid do emscad.cliente corrente e
   executar o programa de detalhe do emscad.cliente */

RUN prgfin/acr/acr205aa.w.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-display C-Win 
PROCEDURE pi-display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    ASSIGN cod-cliente = STRING(emscad.cliente.cdn_cliente)
           cCod_empresa = v_cod_empres_usuar
           iCdn_cliente = emscad.cliente.cdn_cliente
           c-cliente = emscad.cliente.nom_pessoa
           v_rec_cliente = RECID(emscad.cliente).

    DISPLAY cod-cliente
            c-cliente
        WITH FRAME {&FRAME-NAME}.

    RUN pi-processa-geracao IN THIS-PROCEDURE.

    {&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-email C-Win 
PROCEDURE pi-email :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-filter C-Win 
PROCEDURE pi-filter :
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

    DEFINE IMAGE im-last1
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-first1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-last2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-first2
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-last3
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-first3
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-last4
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-first4
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.


    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

    DEFINE FRAME fFaixa
        dtbaixaini   AT ROW 1.21 COL 13.72 COLON-ALIGNED
        im-last1   AT ROW 1.21 COL 23.71 COLON-ALIGNED
        im-first1  AT ROW 1.21 COL 28.71 COLON-ALIGNED
        dtbaixafim   AT ROW 1.21 COL 31.72 COLON-ALIGNED NO-LABEL
        
        cespecieini AT ROW 2.21 COL 19.72 COLON-ALIGNED
        im-last3   AT ROW 2.21 COL 23.71 COLON-ALIGNED
        im-first3  AT ROW 2.21 COL 28.71 COLON-ALIGNED
        cespeciefim AT ROW 2.21 COL 31.72 COLON-ALIGNED NO-LABEL

        cportadorini AT ROW 3.21 COL 17.72 COLON-ALIGNED
        im-last4   AT ROW 3.21 COL 23.71 COLON-ALIGNED
        im-first4  AT ROW 3.21 COL 28.71 COLON-ALIGNED
        cportadorfim AT ROW 3.21 COL 31.72 COLON-ALIGNED NO-LABEL

        btGoToOK          AT ROW 4.63 COL 2.14
        btGoToCancel      AT ROW 4.63 COL 13
        rtGoToButton      AT ROW 4.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Faixa" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fFaixa DO:

        ASSIGN INPUT FRAME fFaixa
               dtbaixaini
               dtbaixafim
               cespecieini
               cespeciefim
               cportadorini
               cportadorfim.

        ASSIGN fi_dat_transacao_ini = dtbaixaini
               fi_dat_transacao_fim = dtbaixafim.

        RUN pi-processa-geracao IN THIS-PROCEDURE.

        {&OPEN-QUERY-{&BROWSE-NAME}}
        
        APPLY "GO":U TO FRAME fFaixa.
    END.


    DISPLAY
           dtbaixaini
           dtbaixafim
           cespecieini
           cespeciefim
           cportadorini
           cportadorfim
        WITH FRAME fFaixa. 


    ENABLE dtbaixaini
           dtbaixafim
           cespecieini
           cespeciefim
           cportadorini
           cportadorfim
           btGoToOK btGoToCancel 
        WITH FRAME fFaixa. 

    
    WAIT-FOR "GO":U OF FRAME fFaixa.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-first C-Win 
PROCEDURE pi-first :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND FIRST emscad.cliente NO-LOCK NO-ERROR.

IF AVAIL emscad.cliente THEN DO:

    RUN pi-display.
    
    DISABLE btFirst
            btPrev
        WITH FRAME {&FRAME-NAME}.
    
    ASSIGN MENU-ITEM miFirst:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miPrev:SENSITIVE IN MENU smFile = FALSE.
    
    ENABLE btNext
           btLast
        WITH FRAME {&FRAME-NAME}.
    
    ASSIGN MENU-ITEM miNext:SENSITIVE IN MENU smFile = TRUE
           MENU-ITEM miLast:SENSITIVE IN MENU smFile = TRUE.
END.
ELSE DO:
    MESSAGE "N∆o existe nenhum registro na tabela!" VIEW-AS ALERT-BOX ERROR.
    DISABLE ALL 
        EXCEPT btExit
               btHelp
        WITH FRAME {&FRAME-NAME}.
    ASSIGN MENU-ITEM miFirst:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miNext:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miPrev:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miLast:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miDetalhe:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miPesquisa:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miFaixa:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miRelat:SENSITIVE IN MENU smFile = FALSE.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-geracao C-Win 
PROCEDURE pi-geracao :
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

    DEFINE VARIABLE i-empresa AS INT LABEL "Empresa Cobranáa"
        VIEW-AS COMBO-BOX SORT AUTO-COMPLETION
        LIST-ITEM-PAIRS "Merchant",1,"Global",2
        SIZE 20 BY .88 NO-UNDO.

    /* os itens do combo-box acima devem vir da base de dados */

    DEFINE FRAME fGoToRecord
        i-empresa AT ROW 1.71 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Geraá∆o" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-empresa.

        RUN pi-processa-geracao.        
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.

    ASSIGN i-empresa:SCREEN-VALUE IN FRAME fGoToRecord = "1".
    
    ENABLE i-empresa  btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gotorecord C-Win 
PROCEDURE pi-gotorecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST emscad.cliente WHERE emscad.cliente.cdn_cliente = INTEGER(cod-cliente) NO-LOCK NO-ERROR.
    
    IF NOT AVAIL emscad.cliente THEN DO:
        MESSAGE "emscad.cliente n∆o existe para a chave informada!" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    RUN pi-display.        
        
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-last C-Win 
PROCEDURE pi-last :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND LAST emscad.cliente NO-LOCK NO-ERROR.
RUN pi-display.

DISABLE btLast
        btNext
    WITH FRAME {&FRAME-NAME}.

ASSIGN MENU-ITEM miLast:SENSITIVE IN MENU smFile = FALSE
       MENU-ITEM miNext:SENSITIVE IN MENU smFile = FALSE.

ENABLE btFirst
       btPrev
    WITH FRAME {&FRAME-NAME}.

ASSIGN MENU-ITEM miFirst:SENSITIVE IN MENU smFile = TRUE
       MENU-ITEM miPrev:SENSITIVE IN MENU smFile = TRUE.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-next C-Win 
PROCEDURE pi-next :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND NEXT emscad.cliente NO-LOCK NO-ERROR.
IF AVAIL emscad.cliente THEN DO:

    RUN pi-display.

    ENABLE btFirst
           btPrev
        WITH FRAME {&FRAME-NAME}.

    ASSIGN MENU-ITEM miFirst:SENSITIVE IN MENU smFile = TRUE
           MENU-ITEM miPrev:SENSITIVE IN MENU smFile = TRUE.

END.
ELSE DO:
    MESSAGE "Èltimo registro!" VIEW-AS ALERT-BOX ERROR.
    RUN pi-last.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-prev C-Win 
PROCEDURE pi-prev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND PREV emscad.cliente NO-LOCK NO-ERROR.
IF AVAIL emscad.cliente THEN DO:

    RUN pi-display.

    ENABLE btNext
           btLast
        WITH FRAME {&FRAME-NAME}.

    ASSIGN MENU-ITEM miNext:SENSITIVE IN MENU smFile = TRUE
           MENU-ITEM miLast:SENSITIVE IN MENU smFile = TRUE.

END.
ELSE DO:
    MESSAGE "Primeiro registro!" VIEW-AS ALERT-BOX ERROR.
    RUN pi-first.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-print C-Win 
PROCEDURE pi-print :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAILABLE emscad.cliente THEN
        RUN esp/acr/esacr002a.w.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-processa-geracao C-Win 
PROCEDURE pi-processa-geracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-gera-tt IN THIS-PROCEDURE.

   /*
   open query q-tt-baixa
        for each tt-baixa 
            by tt-baixa.dat_liquidac_tit_acr.
   disp with frame f-tt-baixa.*/
    assign i-tot = 0.
    for each tt-baixa:
        assign i-tot = i-tot + tt-baixa.vl-baixa.
    end.
    DISP i-tot 
        WITH FRAME {&FRAME-NAME}.
   /*update b-tt-baixa with frame f-tt-baixa.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom C-Win 
PROCEDURE pi-zoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Executar o programa de zoom de emscad.clientes e posicionar o registro neste programa com
   base na variavel global v_rec_cliente */


RUN prgint/utb/utb107ka.p.

IF v_rec_cliente <> ? THEN DO:
    FIND FIRST emscad.cliente NO-LOCK
        WHERE RECID(emscad.cliente) = v_rec_cliente NO-ERROR.
    IF AVAIL emscad.cliente THEN DO:
        ASSIGN cod-cliente:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(emscad.cliente.cdn_cliente).
        APPLY "choose" TO btGoTo IN FRAME {&FRAME-NAME}.
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

