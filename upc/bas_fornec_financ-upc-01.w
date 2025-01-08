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

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever† ser MUT                    */

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
DEFINE NEW GLOBAL SHARED VARIABLE h_br_pagto_conjunto  AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE r-tit_ap_global AS ROWID no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-query      AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-buffer     AS widget-handle no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE g-cta_corren_fornec-recid   AS RECID   NO-UNDO.

DEF TEMP-TABLE tt-conta-audit LIKE int_cta_corren_fornec_audit.
DEF TEMP-TABLE tt-hist
    FIELD campo    AS CHAR FORMAT "x(20)"
    FIELD conteudo AS CHAR FORMAT "x(40)".

def new global shared var v_cod_empres_usuar as CHARACTER format "x(3)" label "Empresa" column-label "Empresa" no-undo.

def new global shared var h-facelift as handle no-undo.

IF NOT VALID-HANDLE(h-facelift) THEN
    RUN btb/btb901zo.p PERSISTENT SET h-facelift.

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-implanta  AS LOGICAL.

DEF VAR h-acomp AS HANDLE NO-UNDO.

DEF VAR i-cor AS INT NO-UNDO.

{utp/ut-glob.i}

DEFINE VARIABLE v_win_original_width  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_win_original_height AS DECIMAL     NO-UNDO.

DEFINE VARIABLE v_column AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_asc    AS LOGICAL     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-conta

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-conta-audit

/* Definitions for BROWSE br-conta                                      */
&Scoped-define FIELDS-IN-QUERY-br-conta tt-conta-audit.num_seq (IF tt-conta-audit.tp_movto = 1 THEN "Inclus∆o" ELSE "Exclus∆o") tt-conta-audit.cod_usuar_alter tt-conta-audit.Dat_alter tt-conta-audit.hr_alter tt-conta-audit.cod_banco (tt-conta-audit.cod_agenc_bcia + "-" + tt-conta-audit.cod_digito_agenc_bcia) (tt-conta-audit.cod_cta_corren_bco + "-" + tt-conta-audit.cod_digito_cta_corren) string(tt-conta-audit.log_cta_corren_prefer, "SIM/N«O") tt-conta-audit.des_cta_corren   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-conta   
&Scoped-define SELF-NAME br-conta
&Scoped-define QUERY-STRING-br-conta FOR EACH tt-conta-audit BY tt-conta-audit.num_seq DESC
&Scoped-define OPEN-QUERY-br-conta OPEN QUERY {&SELF-NAME} FOR EACH tt-conta-audit BY tt-conta-audit.num_seq DESC.
&Scoped-define TABLES-IN-QUERY-br-conta tt-conta-audit
&Scoped-define FIRST-TABLE-IN-QUERY-br-conta tt-conta-audit


/* Definitions for DIALOG-BOX f-cad                                     */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-conta}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-buttom RECT-164 br-conta ed-origem bt-ok ~
bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS ed-origem 

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

DEFINE VARIABLE ed-origem AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 100 BY 7.25 NO-UNDO.

DEFINE RECTANGLE RECT-164
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 102 BY 8.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 102 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-conta FOR 
      tt-conta-audit SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-conta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-conta f-cad _FREEFORM
  QUERY br-conta DISPLAY
      tt-conta-audit.num_seq                                   COLUMN-LABEL "Seq" 
       (IF tt-conta-audit.tp_movto = 1 THEN "Inclus∆o" ELSE "Exclus∆o")      COLUMN-LABEL "Aá∆o" WIDTH 8                        
       tt-conta-audit.cod_usuar_alter                          COLUMN-LABEL "Usu†rio" WIDTH 9
       tt-conta-audit.Dat_alter                                COLUMN-LABEL "Data"   WIDTH 9
       tt-conta-audit.hr_alter                                 COLUMN-LABEL "Hora"   WIDTH 8
       tt-conta-audit.cod_banco                                COLUMN-LABEL "Banco"  WIDTH 5
       (tt-conta-audit.cod_agenc_bcia  + "-" + tt-conta-audit.cod_digito_agenc_bcia) FORMAT "x(15)"  COLUMN-LABEL "Agància"
       (tt-conta-audit.cod_cta_corren_bco  + "-" + tt-conta-audit.cod_digito_cta_corren) FORMAT "x(15)" COLUMN-LABEL "Cta Corrente"  WIDTH 12
       string(tt-conta-audit.log_cta_corren_prefer, "SIM/N«O") COLUMN-LABEL "Preferencial?"
       tt-conta-audit.des_cta_corren                           COLUMN-LABEL "Descriá∆o" WIDTH 40
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 102 BY 7.25
         FONT 7
         TITLE "Hist¢rico Alteraá∆o" ROW-HEIGHT-CHARS .5 TOOLTIP "Hist¢rico Alteraá‰es na Conta Corrente".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     br-conta AT ROW 1.33 COL 2 WIDGET-ID 200
     ed-origem AT ROW 9.71 COL 3 NO-LABEL WIDGET-ID 2
     bt-ok AT ROW 17.71 COL 2.86
     bt-cancela AT ROW 17.71 COL 13.72
     bt-ajuda AT ROW 17.71 COL 93.29
     "Origem Alteraá∆o:" VIEW-AS TEXT
          SIZE 13 BY .67 AT ROW 8.83 COL 3.29 WIDGET-ID 4
     rt-buttom AT ROW 17.5 COL 2
     RECT-164 AT ROW 9.25 COL 2 WIDGET-ID 6
     SPACE(0.42) SKIP(2.03)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "Hist¢rico Alteraá‰es Conta Corrente"
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
/* BROWSE-TAB br-conta RECT-164 f-cad */
ASSIGN 
       FRAME f-cad:SCROLLABLE       = FALSE
       FRAME f-cad:HIDDEN           = TRUE.

ASSIGN 
       br-conta:ALLOW-COLUMN-SEARCHING IN FRAME f-cad = TRUE
       br-conta:COLUMN-RESIZABLE IN FRAME f-cad       = TRUE.

ASSIGN 
       bt-cancela:HIDDEN IN FRAME f-cad           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-conta
/* Query rebuild information for BROWSE br-conta
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-conta-audit BY tt-conta-audit.num_seq DESC
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-conta */
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
ON WINDOW-CLOSE OF FRAME f-cad /* Hist¢rico Alteraá‰es Conta Corrente */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-conta
&Scoped-define SELF-NAME br-conta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-conta f-cad
ON START-SEARCH OF br-conta IN FRAME f-cad /* Hist¢rico Alteraá∆o */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-conta f-cad
ON VALUE-CHANGED OF br-conta IN FRAME f-cad /* Hist¢rico Alteraá∆o */
DO:
    ASSIGN ed-origem:SCREEN-VALUE IN FRAME f-cad = "".

    IF  NOT AVAIL tt-conta-audit THEN
        RETURN "OK".

    ASSIGN ed-origem:SCREEN-VALUE IN FRAME f-cad = tt-conta-audit.orig_alter.
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
  DISPLAY ed-origem 
      WITH FRAME f-cad.
  ENABLE rt-buttom RECT-164 br-conta ed-origem bt-ok bt-cancela bt-ajuda 
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

  {utp/ut9000.i "bas_fornec_financ-upc-01" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  RUN pi-carrega-dados.
  
  {&open-query-br-conta}

  APPLY "value-changed" TO br-conta IN FRAME f-cad.
  /* Code placed here will execute AFTER standard behavior.    */

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
    
    FIND fornec_financ NO-LOCK
        WHERE recid(fornec_financ) = g-cta_corren_fornec-recid NO-ERROR.
                                                
    IF  NOT AVAIL fornec_financ THEN
        RETURN "OK".

    EMPTY TEMP-TABLE tt-conta-audit.

    FOR EACH int_cta_corren_fornec_audit NO-LOCK
        WHERE int_cta_corren_fornec_audit.cod_empresa = fornec_financ.cod_empresa
          AND int_cta_corren_fornec_audit.cdn_fornec  = fornec_financ.cdn_fornec
          BY int_cta_corren_fornec_audit.num_seq DESC:
          CREATE tt-conta-audit.
          BUFFER-COPY int_cta_corren_fornec_audit TO tt-conta-audit.
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
  {src/adm/template/snd-list.i "tt-conta-audit"}

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

