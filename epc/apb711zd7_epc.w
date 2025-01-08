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
DEFINE NEW GLOBAL SHARED VARIABLE h_br_pagto_conjunto  AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE r-tit_ap_global AS ROWID no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-query      AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-buffer     AS widget-handle no-undo.


DEF TEMP-TABLE tt-pagtos
    FIELD cod_tit_ap                  LIKE tit_ap.cod_tit_ap
    FIELD dat_pagto                   LIKE compl_movto_pagto.dat_pagto
    FIELD val_movto_ap                LIKE compl_movto_pagto.val_movto_ap
    FIELD ind_tip_forma_pagto         LIKE forma_pagto.ind_tip_forma_pagto  
    FIELD cod_bco                     LIKE compl_movto_pagto.cod_bco  
    FIELD cod_agenc_bcia_pagto        LIKE compl_movto_pagto.cod_agenc_bcia_pagto
    FIELD cod_cta_corren_bco_pagto    LIKE compl_movto_pagto.cod_cta_corren_bco_pagto
    FIELD cod_digito_cta_corren_pagto LIKE compl_movto_pagto.cod_digito_cta_corren_pagto.


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
&Scoped-define BROWSE-NAME br-titulo

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-pagtos

/* Definitions for BROWSE br-titulo                                     */
&Scoped-define FIELDS-IN-QUERY-br-titulo tt-pagtos.cod_tit_ap tt-pagtos.dat_pagto tt-pagtos.val_movto_ap tt-pagtos.ind_tip_forma_pagto tt-pagtos.cod_bco tt-pagtos.cod_agenc_bcia_pagto tt-pagtos.cod_cta_corren_bco_pagto tt-pagtos.cod_digito_cta_corren_pagto   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-titulo   
&Scoped-define SELF-NAME br-titulo
&Scoped-define QUERY-STRING-br-titulo FOR EACH tt-pagtos
&Scoped-define OPEN-QUERY-br-titulo OPEN QUERY {&SELF-NAME} FOR EACH tt-pagtos.
&Scoped-define TABLES-IN-QUERY-br-titulo tt-pagtos
&Scoped-define FIRST-TABLE-IN-QUERY-br-titulo tt-pagtos


/* Definitions for DIALOG-BOX f-cad                                     */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-titulo}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-buttom br-titulo bt-ok bt-cancela ~
bt-ajuda 

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
     SIZE 86 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-titulo FOR 
      tt-pagtos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-titulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-titulo f-cad _FREEFORM
  QUERY br-titulo DISPLAY
      tt-pagtos.cod_tit_ap                   COLUMN-LABEL "Nr T¡tulo"
       tt-pagtos.dat_pagto                    COLUMN-LABEL "Dt Pagto"
       tt-pagtos.val_movto_ap                 COLUMN-LABEL "Valor"
       tt-pagtos.ind_tip_forma_pagto          COLUMN-LABEL "Forma Pagto"
       tt-pagtos.cod_bco                      COLUMN-LABEL "Banco"
       tt-pagtos.cod_agenc_bcia_pagto         COLUMN-LABEL "Agˆncia"
       tt-pagtos.cod_cta_corren_bco_pagto     COLUMN-LABEL "Conta"
       tt-pagtos.cod_digito_cta_corren_pagto  COLUMN-LABEL "D¡gito"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 86 BY 9.08
         FONT 7
         TITLE "éltimos Pagamentos" ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN TOOLTIP "Seleciona para detalhamento".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     br-titulo AT ROW 1.25 COL 2 WIDGET-ID 200
     bt-ok AT ROW 10.71 COL 3
     bt-cancela AT ROW 10.71 COL 14
     bt-ajuda AT ROW 10.71 COL 77.29
     rt-buttom AT ROW 10.5 COL 2
     SPACE(0.71) SKIP(0.24)
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

ASSIGN 
       bt-cancela:HIDDEN IN FRAME f-cad           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-titulo
/* Query rebuild information for BROWSE br-titulo
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-pagtos
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
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-titulo
&Scoped-define SELF-NAME br-titulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-titulo f-cad
ON START-SEARCH OF br-titulo IN FRAME f-cad /* éltimos Pagamentos */
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

  {utp/ut9000.i "apb711zd5_epc" "2.00.00.000"}

  IF  h_br_pagto_conjunto:NUM-SELECTED-ROWS > 1 THEN DO:
      RUN utp/ut-msgs.p ("SHOW",
                        17006,
                        "Para consultar £ltimos pagamentos, uma £nica linha deve ser selecionada.").
      APPLY "Window-Close" TO THIS-PROCEDURE.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  RUN pi-carrega-dados.
  
  {&open-query-br-titulo}

  APPLY "value-changed" TO br-titulo IN FRAME f-cad.
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
    
    DEF BUFFER b_tit_ap_impto FOR tit_ap.
    
    FIND tit_ap NO-LOCK
        WHERE ROWID(tit_ap) = r-tit_ap_global NO-ERROR.
    
    IF  NOT AVAIL TIT_AP THEN DO:
        RUN Utp/ut-msgs.p(INPUT "SHOW",
                          INPUT 17006,
                          INPUT "Nenhum registro selecionado." + "~~" + "Clique na linha para selecionar um t¡tulo").
        RETURN "ok".
    END.

    DEFINE VARIABLE i AS INTEGER     NO-UNDO.
       
    session:SET-WAIT-STATE ("GENERAL").

    FOR EACH compl_movto_pagto NO-LOCK
        WHERE compl_movto_pagto.ind_modo_pagto = 'bordero'
          AND compl_movto_pagto.cdn_fornecedor = tit_ap.cdn_fornec /* fornecedor que estiver posicionado no browse */
          BY dat_pagto DESC:

          FIND bord_ap NO-LOCK
              WHERE bord_ap.cod_estab   = compl_movto_pagto.cod_estab_pagto
                AND bord_ap.cod_portad  = compl_movto_pagto.cod_portad
                AND bord_ap.num_bord_ap = compl_movto_pagto.num_bord_ap NO-ERROR.

          IF NOT AVAIL bord_ap 
          OR (AVAIL bord_ap AND bord_ap.log_bord_ap_escrit = NO) THEN NEXT.

          FIND movto_tit_ap OF compl_movto_pagto NO-LOCK NO-ERROR.
          IF movto_tit_ap.log_movto_estordo  THEN NEXT.

          FIND tit_ap OF movto_tit_ap NO-LOCK NO-ERROR.
          FIND forma_pagto NO-LOCK
              WHERE forma_pagto.cod_forma_pagto = compl_movto_pagto.cod_forma_pagto NO-ERROR.

          CREATE tt-pagtos.
          ASSIGN tt-pagtos.cod_tit_ap                  = tit_ap.cod_tit_ap                             
                 tt-pagtos.dat_pagto                   = compl_movto_pagto.dat_pagto                   
                 tt-pagtos.val_movto_ap                = compl_movto_pagto.val_movto_ap                
                 tt-pagtos.ind_tip_forma_pagto         = forma_pagto.ind_tip_forma_pagto               
                 tt-pagtos.cod_bco                     = compl_movto_pagto.cod_bco                     
                 tt-pagtos.cod_agenc_bcia_pagto        = compl_movto_pagto.cod_agenc_bcia_pagto        
                 tt-pagtos.cod_cta_corren_bco_pagto    = compl_movto_pagto.cod_cta_corren_bco_pagto    
                 tt-pagtos.cod_digito_cta_corren_pagto = compl_movto_pagto.cod_digito_cta_corren_pagto.

          ASSIGN i = i + 1.
          IF i = 10 THEN LEAVE.
    END.

    session:SET-WAIT-STATE ("").

 
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
  {src/adm/template/snd-list.i "tt-pagtos"}

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

