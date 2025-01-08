&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emscad             PROGRESS
          emsmov             PROGRESS
          mgmov            PROGRESS
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

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_empres_usuar    AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_estab_usuar     AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren    AS CHARACTER    NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE v_rec_tit_acr         AS RECID        NO-UNDO.
DEFINE VAR v_regra_visualiz       AS INT INITIAL 1.
DEFINE VAR num_seq_hist           LIKE emsfin.histor_movto_tit_acr.num_seq_histor_movto_acr.
DEFINE VAR v_num_id_movto_tit_acr LIKE emsfin.movto_tit_acr.num_id_movto_tit_acr.
DEFINE VAR v_hra_indcao           AS CHARACTER FORMAT "99:99:99":U      NO-UNDO.

DEF TEMP-TABLE tt-bem-selecao
    FIELD codigo     LIKE bem_pat.num_bem_pat
    FIELD indice     LIKE bem_pat.num_seq_bem_pat
    FIELD descricao  LIKE bem_pat.des_bem_pat
    FIELD conta      LIKE bem_pat.cod_cta_pat
    FIELD ccusto     LIKE bem_pat.cod_ccusto_respons
    FIELD selecionar AS CHAR
    INDEX codigo codigo indice
    INDEX selecao selecionar codigo indice.

def var i-cont as int.       
def var i-cont-i as int.


DEF VAR t-codigo LIKE bem_pat.num_bem_pat.
DEF VAR t-indice LIKE bem_pat.num_seq_bem_pat.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME br-selecao

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-bem-selecao

/* Definitions for BROWSE br-selecao                                    */
&Scoped-define FIELDS-IN-QUERY-br-selecao tt-bem-selecao.selecionar tt-bem-selecao.codigo tt-bem-selecao.indice tt-bem-selecao.conta tt-bem-selecao.ccusto tt-bem-selecao.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-selecao   
&Scoped-define SELF-NAME br-selecao
&Scoped-define QUERY-STRING-br-selecao FOR EACH tt-bem-selecao
&Scoped-define OPEN-QUERY-br-selecao OPEN QUERY {&SELF-NAME} FOR EACH tt-bem-selecao.
&Scoped-define TABLES-IN-QUERY-br-selecao tt-bem-selecao
&Scoped-define FIRST-TABLE-IN-QUERY-br-selecao tt-bem-selecao


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-br-selecao}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btExec bt_sel_all bt_sel_nall ~
btPrint btExit btHelp rs-selecao br-selecao 
&Scoped-Define DISPLAYED-OBJECTS rs-selecao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miDetalhe      LABEL "Detalhe"        ACCELERATOR "ALT-D"
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
DEFINE BUTTON btExec 
     IMAGE-UP FILE "image/ii-run.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-rnl.bmp":U
     LABEL "Detalhe" 
     SIZE 4 BY 1.25.

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

DEFINE BUTTON btPrint 
     IMAGE-UP FILE "image\im-pri.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-pri.bmp":U
     LABEL "Mail" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt_sel_all 
     IMAGE-UP FILE "image/im-ran_a.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-rnl.bmp":U
     LABEL "Seleciona Tudo" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt_sel_nall 
     IMAGE-UP FILE "image/im-ran_n.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-rnl.bmp":U
     LABEL "Seleciona Nada" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE rs-selecao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Avulsas", 1,
"Sele‡Æo", 2
     SIZE 30 BY 1 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 96 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-selecao FOR 
      tt-bem-selecao SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-selecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-selecao C-Win _FREEFORM
  QUERY br-selecao DISPLAY
      tt-bem-selecao.selecionar      FORMAT "x(5)"            COLUMN-LABEL "Sel."
    tt-bem-selecao.codigo                                   COLUMN-LABEL "C¢digo Bem   "
    tt-bem-selecao.indice                                   COLUMN-LABEL "Öndice   "
    tt-bem-selecao.conta           FORMAT "x(18)"           COLUMN-LABEL "Conta" 
    tt-bem-selecao.ccusto          FORMAT "x(15)"           COLUMN-LABEL "Centro custo"
    tt-bem-selecao.descricao       FORMAT "x(60)"           COLUMN-LABEL "Descri‡Æo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 93 BY 10
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btExec AT ROW 1.13 COL 2.14 HELP
          "Pesquisa"
     bt_sel_all AT ROW 1.13 COL 6.29 HELP
          "Pesquisa"
     bt_sel_nall AT ROW 1.13 COL 10.72 HELP
          "Pesquisa"
     btPrint AT ROW 1.13 COL 17 HELP
          "Pesquisa"
     btExit AT ROW 1.13 COL 88 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 92 HELP
          "Ajuda"
     rs-selecao AT ROW 2.75 COL 3 NO-LABEL
     br-selecao AT ROW 4.25 COL 3
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 97.86 BY 15.79
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-bem T "?" NO-UNDO mgmov bem
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Etiquetas do Patrimonio - ESFAS001(1.00.00.001)"
         HEIGHT             = 14.58
         WIDTH              = 96.43
         MAX-HEIGHT         = 38.88
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.88
         VIRTUAL-WIDTH      = 182.86
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
/* BROWSE-TAB br-selecao rs-selecao DEFAULT-FRAME */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-selecao
/* Query rebuild information for BROWSE br-selecao
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-bem-selecao.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-selecao */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Etiquetas do Patrimonio - ESFAS001(1.00.00.001) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Etiquetas do Patrimonio - ESFAS001(1.00.00.001) */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-selecao
&Scoped-define SELF-NAME br-selecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-selecao C-Win
ON MOUSE-SELECT-DBLCLICK OF br-selecao IN FRAME DEFAULT-FRAME
DO: 
    IF tt-bem-selecao.selecionar = "x" THEN DO:
       ASSIGN tt-bem-selecao.selecionar = "".
    END.
    ELSE DO:
       ASSIGN tt-bem-selecao.selecionar = "x".
    END.

    BROWSE br-selecao:REFRESH().
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExec C-Win
ON CHOOSE OF btExec IN FRAME DEFAULT-FRAME /* Detalhe */
DO: 
    IF rs-selecao:SCREEN-VALUE = "1" THEN DO:
        RUN pi-avulsas.  
    END.
    ELSE DO:
        RUN pi-selecao.  
    END.
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


&Scoped-define SELF-NAME btPrint
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrint C-Win
ON CHOOSE OF btPrint IN FRAME DEFAULT-FRAME /* Mail */
DO:
  RUN pi-print.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_sel_all
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_sel_all C-Win
ON CHOOSE OF bt_sel_all IN FRAME DEFAULT-FRAME /* Seleciona Tudo */
DO:
    
    FOR EACH tt-bem-selecao:
        ASSIGN tt-bem-selecao.selecionar = "".
    END.

    BROWSE br-selecao:REFRESH().

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_sel_nall
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_sel_nall C-Win
ON CHOOSE OF bt_sel_nall IN FRAME DEFAULT-FRAME /* Seleciona Nada */
DO:
    FOR EACH tt-bem-selecao:
        ASSIGN tt-bem-selecao.selecionar = "x".
    END.

    BROWSE br-selecao:REFRESH().
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miDetalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miDetalhe C-Win
ON CHOOSE OF MENU-ITEM miDetalhe /* Detalhe */
DO:
    RUN pi-detalhe IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


    RUN enable_UI.

    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

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
  DISPLAY rs-selecao 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE rtToolBar btExec bt_sel_all bt_sel_nall btPrint btExit btHelp 
         rs-selecao br-selecao 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-avulsas C-Win 
PROCEDURE pi-avulsas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 12 BY 1.13
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 12 BY 1.13
     BGCOLOR 8 .

DEFINE VARIABLE fi-codigo-ini AS DECIMAL FORMAT "999999999" INITIAL 0 
     LABEL "Bem Inicial" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-codigo-fim AS DECIMAL FORMAT "999999999" INITIAL 999999999 
     LABEL "Bem Final" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-indice-ini AS INTEGER FORMAT "999" INITIAL 0 
     LABEL "Öndice Inicial" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE fi-indice-fim AS INTEGER FORMAT "999" INITIAL 999 
     LABEL "Öndice Final" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 65 BY 1.75
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     NO-FILL 
     SIZE 65 BY 3.5.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fselecao
     fi-codigo-ini  AT ROW 2    COL 15 COLON-ALIGNED
     fi-codigo-fim  AT ROW 2    COL 45 COLON-ALIGNED
     fi-indice-ini  AT ROW 3.1  COL 15 COLON-ALIGNED
     fi-indice-fim  AT ROW 3.1  COL 45 COLON-ALIGNED
     Btn_OK         AT ROW 5.3  COL 2.5
     Btn_Cancel     AT ROW 5.3  COL 14.5
     RECT-10        AT ROW 5    COL 1.5
     RECT-8         AT ROW 1.25 COL 1.5
     SPACE(0.5) SKIP(1)
     WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "Avulsas"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.



ON CHOOSE OF Btn_OK IN FRAME fselecao 
DO:
    FOR EACH tt-bem-selecao:
        DELETE tt-bem-selecao.
    END.
    {&OPEN-QUERY-br-selecao}

    DO i-cont = INT(fi-codigo-ini:SCREEN-VALUE) to INT(fi-codigo-fim:SCREEN-VALUE):
       DO i-cont-i = INT(fi-indice-ini:SCREEN-VALUE) to INT(fi-indice-fim:SCREEN-VALUE):
          CREATE tt-bem-selecao.
              ASSIGN tt-bem-selecao.codigo        = i-cont
                     tt-bem-selecao.indice        = i-cont-i
                     tt-bem-selecao.selecionar    = "x".
       END.
       {&OPEN-QUERY-br-selecao}
    END.
END.


DISPLAY fi-codigo-ini 
        fi-codigo-fim
        fi-indice-ini
        fi-indice-fim
        WITH FRAME fselecao.

ENABLE fi-codigo-ini 
        fi-codigo-fim
        fi-indice-ini
        fi-indice-fim
        Btn_OK 
        Btn_Cancel 
        RECT-10 
        RECT-8 
        WITH FRAME fselecao.

VIEW FRAME fselecao.

WAIT-FOR GO OF FRAME fselecao.

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


    FOR EACH tt-bem-selecao WHERE
             tt-bem-selecao.selecionar = "x":

        ASSIGN t-codigo = tt-bem-selecao.codigo
               t-indice = tt-bem-selecao.indice.


    OUTPUT TO PRINTER.

    PUT UNFORMATTED.

            PUT "^Q7,2"     SKIP
                "^W32"      SKIP
                "^E12"      SKIP
                "^H7"       SKIP
                "^P1"       SKIP
                "^S2"       SKIP
                "^C1"       SKIP
                "^R0 "      SKIP
                "^O0 "      SKIP
                "^D0"       SKIP
                "Dy2-me-dd" SKIP
                "Th:m:s "   SKIP.
    
            PUT  "^L"       SKIP
                 "AE,30,5,1,1,1,0," tt-bem-selecao.codigo FORMAT ">>>,>>9" "/" 
                                    tt-bem-selecao.indice FORMAT "999" SKIP.

            PUT "E" SKIP.

    OUTPUT CLOSE.

    END.

    OUTPUT TO PRINTER.

    PUT UNFORMATTED.

            PUT "^Q7,2"     SKIP
                "^W32"      SKIP
                "^E12"      SKIP
                "^H7"       SKIP
                "^P1"       SKIP
                "^S2"       SKIP
                "^C1"       SKIP
                "^R0 "      SKIP
                "^O0 "      SKIP
                "^D0"       SKIP
                "Dy2-me-dd" SKIP
                "Th:m:s "   SKIP.
    
            PUT  "^L"       SKIP
                 "AE,30,5,1,1,1,0," tt-bem-selecao.codigo FORMAT ">>>,>>9" "/" 
                                    tt-bem-selecao.indice FORMAT "999" SKIP.

            PUT "E" SKIP.

    OUTPUT CLOSE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-selecao C-Win 
PROCEDURE pi-selecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 12 BY 1.13
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 12 BY 1.13
     BGCOLOR 8 .

DEFINE VARIABLE fi-codigo-ini AS INTEGER FORMAT "999999999" INITIAL 0 
     LABEL "Bem Inicial" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-codigo-fim AS INTEGER FORMAT "999999999" INITIAL 999999999 
     LABEL "Bem Final" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-indice-ini AS INTEGER FORMAT "999" INITIAL 0 
     LABEL "Öndice Inicial" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE fi-indice-fim AS INTEGER FORMAT "999" INITIAL 999 
     LABEL "Öndice Final" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE fi-conta-ini AS CHAR FORMAT "x(18)" INITIAL "" 
     LABEL "Conta Inicial" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-conta-fim AS CHAR FORMAT "x(18)" INITIAL "zzzzzzzzzzzzzzzzzz" 
     LABEL "Conta Final" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-ccusto-ini AS CHAR FORMAT "99999" 
     LABEL "Centro custo inicial" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE fi-ccusto-fim AS CHAR FORMAT "99999" 
     LABEL "Centro custo Final" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 70 BY 1.75
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     NO-FILL 
     SIZE 70 BY 5.5.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fselecao
     fi-codigo-ini  AT ROW 2    COL 15 COLON-ALIGNED
     fi-codigo-fim  AT ROW 2    COL 48 COLON-ALIGNED
     fi-indice-ini  AT ROW 3.1  COL 15 COLON-ALIGNED
     fi-indice-fim  AT ROW 3.1  COL 48 COLON-ALIGNED
     fi-conta-ini   AT ROW 4.2  COL 15 COLON-ALIGNED 
     fi-conta-fim   AT ROW 4.2  COL 48 COLON-ALIGNED
     fi-ccusto-ini  AT ROW 5.3  COL 15 COLON-ALIGNED
     fi-ccusto-fim  AT ROW 5.3  COL 48 COLON-ALIGNED
     Btn_OK         AT ROW 7.3  COL 2.5
     Btn_Cancel     AT ROW 7.3  COL 14.5
     RECT-10        AT ROW 7    COL 1.5
     RECT-8         AT ROW 1.25 COL 1.5
     SPACE(0.5) SKIP(1)
     WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "Sele‡Æo"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.



ON CHOOSE OF Btn_OK IN FRAME fselecao 
DO:
    FOR EACH tt-bem-selecao:
        DELETE tt-bem-selecao.
    END.
    {&OPEN-QUERY-br-selecao}

    FOR EACH bem_pat NO-LOCK WHERE 
             bem_pat.num_bem_pat        >= INT(fi-codigo-ini:SCREEN-VALUE)     AND
             bem_pat.num_bem_pat        <= INT(fi-codigo-fim:SCREEN-VALUE)     AND
             bem_pat.num_seq_bem_pat    >= INT(fi-indice-ini:SCREEN-VALUE)     AND
             bem_pat.num_seq_bem_pat    <= INT(fi-indice-fim:SCREEN-VALUE)     AND
             bem_pat.cod_cta_pat        >= fi-conta-ini:SCREEN-VALUE      AND 
             bem_pat.cod_cta_pat        <= fi-conta-fim:SCREEN-VALUE      AND
             bem_pat.cod_ccusto_respons >= fi-ccusto-ini:SCREEN-VALUE     AND
             bem_pat.cod_ccusto_respons <= fi-ccusto-fim:SCREEN-VALUE:
             /*
             BY tt-bem.bm-codigo
             BY tt-bem.bm-indice.
             */
            CREATE tt-bem-selecao.
                ASSIGN tt-bem-selecao.codigo        = bem_pat.num_bem_pat       
                       tt-bem-selecao.indice        = bem_pat.num_seq_bem_pat
                       tt-bem-selecao.descricao     = bem_pat.des_bem_pat
                       tt-bem-selecao.conta         = bem_pat.cod_cta_pat 
                       tt-bem-selecao.ccusto        = bem_pat.cod_ccusto_respons
                       tt-bem-selecao.selecionar    = "x".
    END.
    {&OPEN-QUERY-br-selecao}
END.


DISPLAY fi-codigo-ini 
        fi-codigo-fim
        fi-indice-ini
        fi-indice-fim
        fi-conta-ini 
        fi-conta-fim
        fi-ccusto-ini
        fi-ccusto-fim
        WITH FRAME fselecao.

ENABLE fi-codigo-ini 
        fi-codigo-fim
        fi-indice-ini
        fi-indice-fim
        fi-conta-ini 
        fi-conta-fim
        fi-ccusto-ini
        fi-ccusto-fim
        Btn_OK 
        Btn_Cancel 
        RECT-10 
        RECT-8 
        WITH FRAME fselecao.

VIEW FRAME fselecao.

WAIT-FOR GO OF FRAME fselecao.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

