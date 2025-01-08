&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME f-cad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS f-cad 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i D99XX999 9.99.99.999}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever  ser MUT                    */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE h_br_titulos_epc  AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-query      AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-buffer     AS widget-handle no-undo.

def new global shared var v_rec_tit_ap
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

DEF TEMP-TABLE tt-br-titulo
    FIELD cod_espec_docto    LIKE  compl_retenc_impto_pagto.cod_espec_docto   
    FIELD cod_imposto        LIKE  compl_retenc_impto_pagto.cod_imposto       
    FIELD cod_classif_impto  LIKE  compl_retenc_impto_pagto.cod_classif_impto 
    FIELD val_rendto_tribut  LIKE  compl_retenc_impto_pagto.val_rendto_tribut 
    FIELD val_aliq_impto     LIKE  compl_retenc_impto_pagto.val_aliq_impto    
    FIELD val_imposto        LIKE  compl_retenc_impto_pagto.val_imposto.      

def new global shared var v_cod_empres_usuar as CHARACTER format "x(3)" label "Empresa" column-label "Empresa" no-undo.

def new global shared var h-facelift as handle no-undo.

IF NOT VALID-HANDLE(h-facelift) THEN
    RUN btb/btb901zo.p PERSISTENT SET h-facelift.

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-implanta  AS LOGICAL.

DEF VAR h-acomp AS HANDLE NO-UNDO.

DEF VAR i-cor AS INT NO-UNDO.

{utp/ut-glob.i}

DEFINE NEW GLOBAL SHARED VARIABLE wgh-bt-titulos_epc AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE v_win_original_width  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_win_original_height AS DECIMAL     NO-UNDO.

DEFINE VARIABLE v_column  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_asc     AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v_val_liq AS DECIMAL FORMAT ">,>>>,>>>,>>9.99" 
             LABEL "Valor L¡quido" VIEW-AS FILL-IN SIZE 18 BY 0.88 NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-titulo

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-br-titulo

/* Definitions for BROWSE br-titulo                                     */
&Scoped-define FIELDS-IN-QUERY-br-titulo cod_espec_docto cod_imposto cod_classif_impto val_rendto_tribut val_aliq_impto val_imposto   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-titulo   
&Scoped-define SELF-NAME br-titulo
&Scoped-define QUERY-STRING-br-titulo FOR EACH tt-br-titulo BY tt-br-titulo.cod_espec_docto DESC
&Scoped-define OPEN-QUERY-br-titulo OPEN QUERY {&SELF-NAME} FOR EACH tt-br-titulo BY tt-br-titulo.cod_espec_docto DESC.
&Scoped-define TABLES-IN-QUERY-br-titulo tt-br-titulo
&Scoped-define FIRST-TABLE-IN-QUERY-br-titulo tt-br-titulo


/* Definitions for DIALOG-BOX f-cad                                     */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-titulo}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-buttom br-titulo bt-ok bt-cancela ~
bt-ajuda v_val_liq

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 77 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rt-val-liq
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 77 BY 2.00 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-titulo FOR 
      tt-br-titulo SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-titulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-titulo f-cad _FREEFORM
  QUERY br-titulo DISPLAY
      cod_espec_docto     COLUMN-LABEL "Esp‚cie"                 WIDTH 8
       cod_imposto         COLUMN-LABEL "Imposto"                WIDTH 8
       cod_classif_impto   COLUMN-LABEL "Classifica‡Æo"         WIDTH 12
       val_rendto_tribut   COLUMN-LABEL "Rendimento Tribut rio"  WIDTH 17
       val_aliq_impto      COLUMN-LABEL "Al¡quota"               WIDTH 10 
       val_imposto         COLUMN-LABEL "Valor"                  WIDTH 10
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 77 BY 8.75
         FONT 7
         TITLE "Impostos Vinculados" ROW-HEIGHT-CHARS .6 FIT-LAST-COLUMN TOOLTIP "Seleciona para detalhamento".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     br-titulo AT ROW 1.25 COL 2 WIDGET-ID 200
     rt-val-liq AT ROW 10.5 COL 2
     v_val_liq AT ROW 11 COL 47
     bt-ok AT ROW 12.5 COL 3
     bt-cancela AT ROW 12.5 COL 14
     bt-ajuda AT ROW 12.5 COL 68.29
     rt-buttom AT ROW 12.29 COL 2
     SPACE(1.13) SKIP(0.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Impostos Vinculados"
         DEFAULT-BUTTON bt-ok WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB f-cad 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/d-dialog.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX f-cad
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB br-titulo rt-buttom f-cad */
ASSIGN 
       FRAME f-cad:SCROLLABLE       = FALSE
       FRAME f-cad:HIDDEN           = TRUE.

ASSIGN 
       br-titulo:ALLOW-COLUMN-SEARCHING IN FRAME f-cad = TRUE
       br-titulo:COLUMN-RESIZABLE IN FRAME f-cad       = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-titulo
/* Query rebuild information for BROWSE br-titulo
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-br-titulo BY tt-br-titulo.cod_espec_docto DESC
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-titulo */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX f-cad
/* Query rebuild information for DIALOG-BOX f-cad
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX f-cad */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME f-cad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cad f-cad
ON WINDOW-CLOSE OF FRAME f-cad /* Impostos Vinculados */
DO:  
   ASSIGN v_rec_tit_ap  = ?.
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-titulo
&Scoped-define SELF-NAME br-titulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-titulo f-cad
ON START-SEARCH OF br-titulo IN FRAME f-cad /* Impostos Vinculados */
DO:
  
    DEFINE VARIABLE i_count AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i_index AS INTEGER     NO-UNDO.

    SELF:CLEAR-SORT-ARROWS().

    IF SELF:CURRENT-COLUMN:TABLE = "":U OR
       SELF:CURRENT-COLUMN:TABLE = ?    THEN
        RETURN NO-APPLY.

    IF v_column <> SELF:CURRENT-COLUMN:NAME THEN
        ASSIGN v_column = SELF:CURRENT-COLUMN:NAME
               v_asc    = YES.
    ELSE
        ASSIGN v_asc = NOT v_asc.

    IF v_asc THEN
        SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                 "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME).
    ELSE
        SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                 "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " DESC":U).
            
    DO i_count = 1 TO SELF:NUM-COLUMNS:
        IF SELF:CURRENT-COLUMN = SELF:GET-BROWSE-COLUMN(i_count) THEN
            ASSIGN i_index = i_count.
    END.

    SELF:SET-SORT-ARROW(i_index, v_asc).

    SELF:QUERY:QUERY-OPEN().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-titulo f-cad
ON VALUE-CHANGED OF br-titulo IN FRAME f-cad /* Impostos Vinculados */
DO: 

    IF  NOT AVAIL tt-br-titulo THEN
        RETURN "OK".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda f-cad
ON CHOOSE OF bt-ajuda IN FRAME f-cad /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela f-cad
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Cancelar */
DO:

  ASSIGN v_rec_tit_ap = ?.
  APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok f-cad
ON CHOOSE OF bt-ok IN FRAME f-cad /* OK */
DO:
  APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f-cad 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects f-cad  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available f-cad  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI f-cad  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME f-cad.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI f-cad  _DEFAULT-ENABLE
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
  ENABLE rt-buttom br-titulo bt-ok bt-cancela bt-ajuda 
      WITH FRAME f-cad.
  VIEW FRAME f-cad.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy f-cad 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize f-cad 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  {utp/ut9000.i "apb775za_epc_01" "2.00.00.000"}

  IF  VALID-HANDLE(h_br_titulos_epc)
  AND h_br_titulos_epc:NUM-SELECTED-ROWS > 1 THEN DO:
      RUN utp/ut-msgs.p ("SHOW",
                        17006,
                        "Para consultar impostos vinculados, uma £nica linha deve ser selecionada.").
      APPLY "Window-Close" TO THIS-PROCEDURE.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  IF  (VALID-HANDLE(wgh-bt-titulos_epc) AND wgh-bt-titulos_epc:SENSITIVE) THEN
      ASSIGN v_rec_tit_ap = ?.

  RUN pi-carrega-dados.
  
  {&open-query-br-titulo}

  APPLY "value-changed" TO br-titulo IN FRAME f-cad.
  /* Code placed here will execute AFTER standard behavior.    */

  DISABLE v_val_liq WITH FRAME f-cad.

  DISP v_val_liq WITH FRAME f-cad.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-dados f-cad 
PROCEDURE pi-carrega-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEF BUFFER b_tit_ap_impto FOR tit_ap.

    FIND tit_ap NO-LOCK
        WHERE RECID(tit_ap) = v_rec_tit_ap NO-ERROR.
    
    IF  NOT AVAIL TIT_AP THEN DO:
        RUN Utp/ut-msgs.p(INPUT "SHOW",
                          INPUT 17006,
                          INPUT "Nenhum T¡tulo selecionado." + "~~" + "Clique na linha para detalhar os impostos vinculados").
        RETURN "ok".
    END.

    ASSIGN v_val_liq = 0.

    for each compl_retenc_impto_pagto no-lock
       where compl_retenc_impto_pagto.cod_estab     = tit_ap.cod_estab
         and compl_retenc_impto_pagto.num_id_tit_ap = tit_ap.num_id_tit_ap:

        CREATE tt-br-titulo.
        ASSIGN tt-br-titulo.cod_espec_docto   = compl_retenc_impto_pagto.cod_espec_docto    
               tt-br-titulo.cod_imposto       = compl_retenc_impto_pagto.cod_imposto        
               tt-br-titulo.cod_classif_impto = compl_retenc_impto_pagto.cod_classif_impto  
               tt-br-titulo.val_rendto_tribut = compl_retenc_impto_pagto.val_rendto_tribut  
               tt-br-titulo.val_aliq_impto    = compl_retenc_impto_pagto.val_aliq_impto     
               tt-br-titulo.val_imposto       = compl_retenc_impto_pagto.val_imposto.       

        IF  v_val_liq = 0 THEN
            ASSIGN v_val_liq = compl_retenc_impto_pagto.val_rendto_tribut - compl_retenc_impto_pagto.val_imposto.
        ELSE
            ASSIGN v_val_liq = v_val_liq - compl_retenc_impto_pagto.val_imposto.
    end.
    
    for each movto_tit_ap no-lock
       where movto_tit_ap.cod_estab     = tit_ap.cod_estab
         and movto_tit_ap.num_id_tit_ap = tit_ap.num_id_tit_ap:
        compl_block:
        for each  compl_impto_retid_ap no-lock
            where compl_impto_retid_ap.cod_estab               = movto_tit_ap.cod_estab
              and compl_impto_retid_ap.num_id_movto_tit_ap_pai = movto_tit_ap.num_id_movto_tit_ap:
            find first b_tit_ap_impto no-lock
                 where b_tit_ap_impto.cod_estab     = compl_impto_retid_ap.cod_estab
                   and b_tit_ap_impto.num_id_tit_ap = compl_impto_retid_ap.num_id_tit_ap no-error.

            CREATE tt-br-titulo.                 
            ASSIGN tt-br-titulo.cod_espec_docto    = b_tit_ap_impto.cod_espec_docto
                   tt-br-titulo.cod_imposto        = compl_impto_retid_ap.cod_imposto      
                   tt-br-titulo.cod_classif_impto  = compl_impto_retid_ap.cod_classif_impto
                   tt-br-titulo.val_rendto_tribut  = compl_impto_retid_ap.val_rendto_tribut 
                   tt-br-titulo.val_aliq_impto     = compl_impto_retid_ap.val_aliq_impto 
                   tt-br-titulo.val_imposto        = compl_impto_retid_ap.val_impto_indic_econ_orig.
    
            IF  v_val_liq = 0 THEN
                ASSIGN v_val_liq = compl_impto_retid_ap.val_rendto_tribut - compl_retenc_impto_pagto.val_imposto.
            ELSE
                ASSIGN v_val_liq = v_val_liq - compl_impto_retid_ap.val_impto_indic_econ_orig.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records f-cad  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-br-titulo"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed f-cad 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
  
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

