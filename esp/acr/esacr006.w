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

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_empres_usuar    AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_estab_usuar     AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren    AS CHARACTER    NO-UNDO.

def var da-data-ini as date format "99/99/9999".
def var da-data-fim as date format "99/99/9999".

{esp\acr\esacr006tt.i}
DEFINE TEMP-TABLE tt-inc-tit LIKE tt-tit.
/* Temporary Tables Definitions 
{esp\cms\apb900zd.i}

{esp\cms\apb768za.i}

{esp\cms\apb767zc.i}

DEFINE VARIABLE c-especie       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-nr-docto      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE da-dt-emis      AS DATE         NO-UNDO.
DEFINE VARIABLE da-dt-venc      AS DATE         NO-UNDO.
DEFINE VARIABLE de-valor        AS DECIMAL      NO-UNDO.
DEFINE VARIABLE c-ct-codigo     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-sc-codigo     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE de-valor-mov    AS DECIMAL      NO-UNDO.
DEFINE VARIABLE iCod-emit-lanc  AS INTEGER      NO-UNDO.
DEFINE VARIABLE c-parcela       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cUnid_negoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unidade de Neg¢cio" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY .88 NO-UNDO.



DEFINE NEW GLOBAL SHARED VARIABLE v_cod_dwb_user AS CHARACTER  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_cta_ctbl_integr AS RECID  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_ccusto AS RECID  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_plano_ccusto AS RECID  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_fornecedor AS RECID  NO-UNDO.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME br-tit-acr

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-tit

/* Definitions for BROWSE br-tit-acr                                    */
&Scoped-define FIELDS-IN-QUERY-br-tit-acr tt-tit.cdn_cliente tt-tit.nom_abrev tt-tit.cod_tit_acr tt-tit.cod_parcela tt-tit.cod_espec_docto tt-tit.dat_vencto_tit_acr tt-tit.val_sdo_tit_acr tt-tit.cod_portador tt-tit.cod_cart_bcia tt-tit.cdn_repres   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-tit-acr   
&Scoped-define SELF-NAME br-tit-acr
&Scoped-define QUERY-STRING-br-tit-acr FOR EACH tt-tit NO-LOCK     by tt-tit.cdn_cliente     by tt-tit.dat_vencto_tit_acr     by tt-tit.cod_tit_acr
&Scoped-define OPEN-QUERY-br-tit-acr OPEN QUERY {&SELF-NAME} FOR EACH tt-tit NO-LOCK     by tt-tit.cdn_cliente     by tt-tit.dat_vencto_tit_acr     by tt-tit.cod_tit_acr.
&Scoped-define TABLES-IN-QUERY-br-tit-acr tt-tit
&Scoped-define FIRST-TABLE-IN-QUERY-br-tit-acr tt-tit


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-br-tit-acr}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btExit btHelp btFiltro btPrint br-tit-acr ~
btInclui btExcluir rtToolBar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFaixa        LABEL "Faixa"         
       RULE
       MENU-ITEM miRelat        LABEL "Imprime"       
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "A&juda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btExcluir 
     LABEL "&Exclui" 
     SIZE 10 BY 1.

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
     SIZE 4 BY 1.25 TOOLTIP "Filtro".

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btInclui 
     LABEL "&Inclui" 
     SIZE 10 BY 1.

DEFINE BUTTON btPrint 
     IMAGE-UP FILE "image\im-pri.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-pri.bmp":U
     LABEL "Mail" 
     SIZE 4 BY 1.25 TOOLTIP "Relat¢rio".

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-tit-acr FOR 
      tt-tit SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-tit-acr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-tit-acr C-Win _FREEFORM
  QUERY br-tit-acr NO-LOCK DISPLAY
      tt-tit.cdn_cliente
      tt-tit.nom_abrev      WIDTH 16
      tt-tit.cod_tit_acr
      tt-tit.cod_parcela
      tt-tit.cod_espec_docto
      tt-tit.dat_vencto_tit_acr
      tt-tit.val_sdo_tit_acr format ">>>,>>>,>>9.99"
      tt-tit.cod_portador
      tt-tit.cod_cart_bcia
      tt-tit.cdn_repres
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 10.25
         FONT 1 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     btFiltro AT ROW 1.17 COL 1.72 HELP
          "Pesquisa"
     btPrint AT ROW 1.17 COL 5.57 HELP
          "Pesquisa"
     br-tit-acr AT ROW 2.75 COL 1
     btInclui AT ROW 13 COL 1
     btExcluir AT ROW 13 COL 11
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 13.17
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
         TITLE              = "Titulos a Abater da Participacao - ESACR006"
         HEIGHT             = 13.17
         WIDTH              = 90.14
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.21
         VIRTUAL-WIDTH      = 146.29
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
/* BROWSE-TAB br-tit-acr btPrint DEFAULT-FRAME */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-tit-acr
/* Query rebuild information for BROWSE br-tit-acr
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-tit NO-LOCK
    by tt-tit.cdn_cliente
    by tt-tit.dat_vencto_tit_acr
    by tt-tit.cod_tit_acr.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "fedex.cod-transp >= i-transp-ini
and fedex.cod-transp <= i-transp-fim
and fedex.empresa >= c-empresa-ini
and fedex.empresa <= c-empresa-fim
and fedex.cod-emit-frete >= i-frete-ini
and fedex.cod-emit-frete <= i-frete-fim
and fedex.cod-emitente-imp >= i-imp-ini
and fedex.cod-emitente-imp <= i-imp-fim
and (fedex.mp = l-mp-s or fedex.mp = l-mp-n)
and (fedex.lancado-frete = l-frete-s or fedex.lancado-frete = l-frete-n)
and (fedex.lancado-imp = l-impostos-s or fedex.lancado-imp = l-impostos-n)
and (fedex.encerrado = l-encer-s or fedex.encerrado = l-encer-n)
and (fedex.recebido = l-recebido-s or fedex.recebido = l-recebido-n)
and (fedex.tipo = l-tipo-s or fedex.tipo = l-tipo-n)
and fedex.conhecimento matches (c-co)
"
     _Query            is OPENED
*/  /* BROWSE br-tit-acr */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Titulos a Abater da Participacao - ESACR006 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Titulos a Abater da Participacao - ESACR006 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-tit-acr
&Scoped-define SELF-NAME br-tit-acr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-tit-acr C-Win
ON MOUSE-SELECT-DBLCLICK OF br-tit-acr IN FRAME DEFAULT-FRAME
DO:
    /*APPLY 'choose' TO btDet IN FRAME {&FRAME-NAME}.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-tit-acr C-Win
ON RETURN OF br-tit-acr IN FRAME DEFAULT-FRAME
DO:
  /*  APPLY 'choose' TO btDet IN FRAME {&FRAME-NAME}.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcluir C-Win
ON CHOOSE OF btExcluir IN FRAME DEFAULT-FRAME /* Exclui */
DO:
    IF AVAIL tt-tit THEN
    DO:
        MESSAGE "Confirma ExclusÆo T¡tulo ?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                            TITLE "Confirma ExclusÆo" UPDATE vlogOK AS LOGICAL.
        IF  vlogOK THEN
            DELETE tt-tit.

        {&OPEN-QUERY-{&BROWSE-NAME}}

    END.
  /*  RUN piExcluiSolicitacao IN THIS-PROCEDURE.*/
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

    RUN esp/acr/esacr006a.w(INPUT-OUTPUT da-data-ini,
                            INPUT-OUTPUT da-data-fim).
    RUN piAtualizaBrowser.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btInclui
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInclui C-Win
ON CHOOSE OF btInclui IN FRAME DEFAULT-FRAME /* Inclui */
DO:
    DEFINE VARIABLE vRaw AS RAW NO-UNDO.
    DEFINE VARIABLE hWindow AS HANDLE     NO-UNDO.

    ASSIGN hWindow = CURRENT-WINDOW
           hWindow:SENSITIVE = NO.

    RUN esp\acr\esacr006c.w(OUTPUT vRaw).

    ASSIGN hWindow:SENSITIVE = YES.

    IF vRaw <> ? THEN
    DO:
        CREATE tt-tit.
        RAW-TRANSFER vRaw TO tt-tit NO-ERROR.
    END.

    {&OPEN-QUERY-{&BROWSE-NAME}}
  /*  RUN piAlteraSolicitacao IN THIS-PROCEDURE.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrint
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrint C-Win
ON CHOOSE OF btPrint IN FRAME DEFAULT-FRAME /* Mail */
DO:
    DEFINE VARIABLE hWindow AS HANDLE     NO-UNDO.
    ASSIGN hWindow = CURRENT-WINDOW.

    ASSIGN hWindow:SENSITIVE = NO.

    RUN esp\acr\esacr006b.w(INPUT da-data-ini,
                            INPUT da-data-fim,
                            INPUT TABLE tt-tit).
    ASSIGN hWindow:SENSITIVE = YES.

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


&Scoped-define SELF-NAME miRelat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miRelat C-Win
ON CHOOSE OF MENU-ITEM miRelat /* Imprime */
DO:
  APPLY "CHOOSE" TO btPrint IN FRAME {&FRAME-NAME}.
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

    APPLY "CHOOSE" TO btFiltro IN FRAME {&FRAME-NAME}.

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
  ENABLE btExit btHelp btFiltro btPrint br-tit-acr btInclui btExcluir rtToolBar 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaBrowser C-Win 
PROCEDURE piAtualizaBrowser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     for each tt-tit:
        delete tt-tit.
     end.
     SESSION:SET-WAIT-STATE("general":U).    
     for each  tit_acr no-lock
         where tit_acr.cod_empresa          = "1"
         and   tit_acr.cod_estab            = "101"
         and   tit_acr.cod_espec_docto      > "AC"
         and   tit_acr.cod_espec_docto     <> "DV"
         and   tit_acr.dat_vencto_tit_acr  >= da-data-ini
         and   tit_acr.dat_vencto_tit_acr  <= da-data-fim
         and   tit_acr.val_sdo_tit_acr     > 0,
         FIRST emscad.cliente NO-LOCK
         WHERE emscad.cliente.cod_empresa = tit_acr.cod_empresa
         AND   emscad.cliente.cdn_cliente = tit_acr.cdn_cliente,
         FIRST clien_financ NO-LOCK
         WHERE clien_financ.cod_empresa = emscad.cliente.cod_empresa
         AND   clien_financ.cdn_cliente = emscad.cliente.cdn_cliente,
         FIRST grp_clien NO-LOCK
         WHERE grp_clien.cod_grp_clien = emscad.cliente.cod_grp_clien,
         FIRST representante NO-LOCK
         WHERE representante.cod_empresa = clien_financ.cod_empresa
         AND   representante.cdn_repres  = clien_financ.cdn_repres
         break by tit_acr.cdn_cliente
               by tit_acr.dat_vencto_tit_acr
               by tit_acr.cod_tit_acr:
        create tt-tit.
        buffer-copy tit_acr to tt-tit.
     END. /* for each  tit_acr no-lock */
     SESSION:SET-WAIT-STATE("":U).
     IF NOT AVAIL tt-tit THEN
         MESSAGE "Nenhum T¡tulo Encontrado com a Sele‡Æo Informada"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

