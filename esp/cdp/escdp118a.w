&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-window 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCDP118A 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESCDP118A ESP}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
def var lg-modificada as logi no-undo.
def var c-mensagem    as char no-undo.

/* Parameters Definitions ---                                           */

{include/i-frm055.i}
/* Local Variable Definitions ---                                       */

&Scoped-define table-parent int_bem_pat

/* insira a seguir a defini‡Æo da temp-table */

def temp-table tt-source no-undo
    field gm-codigo like grup-maquina.gm-codigo
    field descricao like grup-maquina.descricao
    index id is primary gm-codigo.

def temp-table tt-target no-undo like int_bem_pat_gm
    field descricao like grup-maquina.descricao
    index id is primary num_id_bem_pat
                        gm-codigo
                        descricao.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-form2
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-formation
&Scoped-define BROWSE-NAME br-source-browse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-source tt-target

/* Definitions for BROWSE br-source-browse                              */
&Scoped-define FIELDS-IN-QUERY-br-source-browse tt-source.gm-codigo tt-source.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-source-browse   
&Scoped-define SELF-NAME br-source-browse
&Scoped-define QUERY-STRING-br-source-browse FOR EACH tt-source
&Scoped-define OPEN-QUERY-br-source-browse OPEN QUERY {&SELF-NAME} FOR EACH tt-source.
&Scoped-define TABLES-IN-QUERY-br-source-browse tt-source
&Scoped-define FIRST-TABLE-IN-QUERY-br-source-browse tt-source


/* Definitions for BROWSE br-target-browse                              */
&Scoped-define FIELDS-IN-QUERY-br-target-browse tt-target.gm-codigo tt-target.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-target-browse   
&Scoped-define SELF-NAME br-target-browse
&Scoped-define QUERY-STRING-br-target-browse FOR EACH tt-target
&Scoped-define OPEN-QUERY-br-target-browse OPEN QUERY {&SELF-NAME} FOR EACH tt-target.
&Scoped-define TABLES-IN-QUERY-br-target-browse tt-target
&Scoped-define FIRST-TABLE-IN-QUERY-br-target-browse tt-target


/* Definitions for FRAME f-formation                                    */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-formation ~
    ~{&OPEN-QUERY-br-source-browse}~
    ~{&OPEN-QUERY-br-target-browse}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key-parent rt-source-browse ~
rt-source-browse-2 RECT-1 br-source-browse br-target-browse bt-add bt-del ~
bt-ok bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS fi_num_bem_pat fi_num_seq_bem_pat ~
fi_des_bem_pat fi_cod_cta_pat fi-label fi-cod-estabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD is-create-allowed w-window 
FUNCTION is-create-allowed RETURNS LOGICAL
  ( v-row-tt as rowid)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD is-delete-allowed w-window 
FUNCTION is-delete-allowed RETURNS LOGICAL
  ( v-row-target as rowid)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-window AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-add 
     IMAGE-UP FILE "adeicon\next-au":U
     IMAGE-INSENSITIVE FILE "adeicon\next-ai":U
     LABEL "" 
     SIZE 7 BY 1.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-del 
     IMAGE-UP FILE "adeicon\prev-au":U
     IMAGE-INSENSITIVE FILE "adeicon\prev-ai":U
     LABEL "" 
     SIZE 7 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "X(5)":U 
      VIEW-AS TEXT 
     SIZE 5 BY .67 NO-UNDO.

DEFINE VARIABLE fi-label AS CHARACTER FORMAT "X(7)":U INITIAL "Estabel" 
      VIEW-AS TEXT 
     SIZE 6 BY .63 NO-UNDO.

DEFINE VARIABLE fi_cod_cta_pat AS CHARACTER FORMAT "x(18)" 
     LABEL "Conta Patrimonial" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88.

DEFINE VARIABLE fi_des_bem_pat AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE fi_num_bem_pat AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Bem Patrimonial" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi_num_seq_bem_pat AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Sequˆncia Bem" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 87.86 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE rt-key-parent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.86 BY 3.25.

DEFINE RECTANGLE rt-source-browse
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38.57 BY 9.5.

DEFINE RECTANGLE rt-source-browse-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38.57 BY 9.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-source-browse FOR 
      tt-source SCROLLING.

DEFINE QUERY br-target-browse FOR 
      tt-target SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-source-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-source-browse w-window _FREEFORM
  QUERY br-source-browse DISPLAY
      tt-source.gm-codigo format "x(9)"  column-label "Grupo Maq" width 10
tt-source.descricao format "x(32)" column-label "Descri‡Æo" width 32
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 36.43 BY 8.75
         FONT 1.

DEFINE BROWSE br-target-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-target-browse w-window _FREEFORM
  QUERY br-target-browse DISPLAY
      tt-target.gm-codigo format "x(9)"  column-label "Grupo Maq" width 10
tt-target.descricao format "x(32)" column-label "Descri‡Æo" width 32
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 36.43 BY 8.75
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-formation
     fi_num_bem_pat AT ROW 1.58 COL 16 COLON-ALIGNED WIDGET-ID 8
     fi_num_seq_bem_pat AT ROW 2.58 COL 16 COLON-ALIGNED WIDGET-ID 10
     fi_des_bem_pat AT ROW 2.58 COL 22.29 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     fi_cod_cta_pat AT ROW 3.58 COL 16 COLON-ALIGNED WIDGET-ID 2
     br-source-browse AT ROW 5.5 COL 3 WIDGET-ID 200
     br-target-browse AT ROW 5.5 COL 52.14
     bt-add AT ROW 7.67 COL 42.14
     bt-del AT ROW 9.29 COL 42.14
     bt-ok AT ROW 15.71 COL 3
     bt-cancela AT ROW 15.71 COL 14
     bt-ajuda AT ROW 15.71 COL 78.14
     fi-label AT ROW 4.92 COL 41.14 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     fi-cod-estabel AT ROW 5.5 COL 42 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     rt-key-parent AT ROW 1.42 COL 1.86
     rt-source-browse AT ROW 5 COL 2
     rt-source-browse-2 AT ROW 5.04 COL 51.14
     RECT-1 AT ROW 15.5 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.83
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-form2
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "Formar Grupo M quina"
         HEIGHT             = 16.04
         WIDTH              = 89.86
         MAX-HEIGHT         = 41.33
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 41.33
         VIRTUAL-WIDTH      = 274.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-window 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-window.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-formation
   FRAME-NAME                                                           */
/* BROWSE-TAB br-source-browse fi_cod_cta_pat f-formation */
/* BROWSE-TAB br-target-browse br-source-browse f-formation */
/* SETTINGS FOR FILL-IN fi-cod-estabel IN FRAME f-formation
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-label IN FRAME f-formation
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_cod_cta_pat IN FRAME f-formation
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_des_bem_pat IN FRAME f-formation
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_num_bem_pat IN FRAME f-formation
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_num_seq_bem_pat IN FRAME f-formation
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-source-browse
/* Query rebuild information for BROWSE br-source-browse
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-source.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-source-browse */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-target-browse
/* Query rebuild information for BROWSE br-target-browse
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-target.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-target-browse */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-formation
/* Query rebuild information for FRAME f-formation
     _Query            is NOT OPENED
*/  /* FRAME f-formation */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* Formar Grupo M quina */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* Formar Grupo M quina */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-source-browse
&Scoped-define SELF-NAME br-source-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-source-browse w-window
ON VALUE-CHANGED OF br-source-browse IN FRAME f-formation
DO:
  {include/i-frm020.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-target-browse
&Scoped-define SELF-NAME br-target-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-target-browse w-window
ON VALUE-CHANGED OF br-target-browse IN FRAME f-formation
DO:
  {include/i-frm010.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-add w-window
ON CHOOSE OF bt-add IN FRAME f-formation
DO:
   run pi-ins.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-window
ON CHOOSE OF bt-ajuda IN FRAME f-formation /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-window
ON CHOOSE OF bt-cancela IN FRAME f-formation /* Fechar */
DO:
  apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del w-window
ON CHOOSE OF bt-del IN FRAME f-formation
DO:
   run pi-del.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME f-formation /* OK */
DO:
  if lg-modificada
  then do:
       run pi-revalida.
       if return-value = "NOK"
       then return no-apply.

       assign c-mensagem = "Deseja prosseguir?~~Deseja prosseguir?".
       
       run utp/ut-msgs(input 'show',
                       input 27100,
                       input c-mensagem).
       
       if return-value <> 'yes'
       then return no-apply.

       run pi-commit.
       
       run dispatch in wh-browse (input 'open-query':U).
  end.
  
  apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-source-browse
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-window 


/* ***************************  Main Block  *************************** */

{include/i-frm040.i}
/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-window  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-window  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-window  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
  THEN DELETE WIDGET w-window.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-window  _DEFAULT-ENABLE
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
  DISPLAY fi_num_bem_pat fi_num_seq_bem_pat fi_des_bem_pat fi_cod_cta_pat 
          fi-label fi-cod-estabel 
      WITH FRAME f-formation IN WINDOW w-window.
  ENABLE rt-key-parent rt-source-browse rt-source-browse-2 RECT-1 
         br-source-browse br-target-browse bt-add bt-del bt-ok bt-cancela 
         bt-ajuda 
      WITH FRAME f-formation IN WINDOW w-window.
  {&OPEN-BROWSERS-IN-QUERY-f-formation}
  VIEW w-window.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-window 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-window 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}
  
  {utp/ut9000.i "ESCDP118A" "1.00.00.000"}

  for first int_bem_pat
      where rowid(int_bem_pat) = v-row-parent
            no-lock: end.

  for first int_param_uep
      where int_param_uep.cod_empresa = int_bem_pat.cod_empresa
            no-lock: end.

  if int_bem_pat.molde
  or not avail int_param_uep
  then delete procedure this-procedure no-error.

  FOR first bem_pat 
      where bem_pat.cod_empresa     = int_bem_pat.cod_empresa
        and bem_pat.cod_cta_pat     = int_bem_pat.cod_cta_pat
        and bem_pat.num_bem_pat     = int_bem_pat.num_bem_pat
        and bem_pat.num_seq_bem_pat = int_bem_pat.num_seq_bem_pat
            no-lock: end.

  run pi-init-target.
  run pi-init-source.

  run pi-show-master-record.

  /* Dispatch standard ADM method.                             */  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  assign fi_num_bem_pat:screen-value     in frame {&frame-name} = string(int_bem_pat.num_bem_pat)
         fi_num_seq_bem_pat:screen-value in frame {&frame-name} = string(int_bem_pat.num_seq_bem_pat)
         fi_cod_cta_pat:screen-value     in frame {&frame-name} = int_bem_pat.cod_cta_pat
         fi_des_bem_pat:screen-value     in frame {&frame-name} = bem_pat.des_bem_pat
         fi-cod-estabel:screen-value     in frame {&frame-name} = bem_pat.cod_estab.


  run pi-ctrl-bt.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add-to-target w-window 
PROCEDURE pi-add-to-target :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   define input parameter v-row-select-in-source as rowid no-undo.
   
  /*:T Jamais remova a definição do include a seguir de dentro da lógica do programa */
  {include/i-frm190.i}

   /*:T rowid da tabela que possui um registro selecionado no browse de origem */
   find tt-source where
        rowid(tt-source) = v-row-select-in-source
        no-error.

  find tt-target where
       tt-target.gm-codigo = tt-source.gm-codigo
       no-error.

  if not avail tt-target
  then do:
       create tt-target.
       assign tt-target.gm-codigo = tt-source.gm-codigo
              tt-target.descricao = tt-source.descricao.
       assign lg-modificada = yes.
  end.

  if br-source-browse:num-selected-rows in frame {&frame-name} > 0 
  then do on error undo, return no-apply:
       get current br-source-browse.
       delete tt-source.
       if br-source-browse:delete-current-row() in frame {&frame-name} then.
  end.
   
   /*:T Jamais remova a definição do include a seguir de dentro da lógica do programa */
  {include/i-frm195.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega w-window 
PROCEDURE pi-carrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p_cod_ccusto like aloc_bem.cod_ccusto no-undo.

for each gm-estab use-index c-custo no-lock
   where gm-estab.cc-codigo   = p_cod_ccusto
     and gm-estab.cod-estabel = bem_pat.cod_estab,
   first grup-maquina fields(gm-codigo descricao) no-lock
   where grup-maquina.gm-codigo = gm-estab.gm-codigo:
    if can-find(first tt-target where
                      tt-target.gm-codigo = gm-estab.gm-codigo)
    then next.

    create tt-source.
    assign tt-source.gm-codigo = gm-estab.gm-codigo
           tt-source.descricao = grup-maquina.descricao.
end. /* for each gm-estab */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-commit w-window 
PROCEDURE pi-commit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

do transaction on error undo, leave
               on stop  undo, leave:
    for each int_bem_pat_gm exclusive-lock
       where int_bem_pat_gm.num_id_bem_pat = int_bem_pat.num_id_bem_pat:
        delete int_bem_pat_gm.
    end.

    for each tt-target:
        create int_bem_pat_gm.
        assign int_bem_pat_gm.num_id_bem_pat = int_bem_pat.num_id_bem_pat
               int_bem_pat_gm.gm-codigo      = tt-target.gm-codigo.
    end. /* for each tt-target */
end. /* do transaction */

find current int_bem_pat_gm no-lock no-error.
release int_bem_pat_gm.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ctrl-bt w-window 
PROCEDURE pi-ctrl-bt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  assign bt-add:sensitive in frame {&frame-name} = temp-table tt-source:has-records
         bt-del:sensitive in frame {&frame-name} = temp-table tt-target:has-records.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-del w-window 
PROCEDURE pi-del :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /*:T Jamais remova a definição do include a seguir de dentro da lógica do programa */
  {include/i-frm167.i}
  
   /*:T Caso o include a seguir nao atenda suas necessidades, apague-o  e crie sua propria
  logica usando-o como modelo. 
  */   
   run pi-exc.
 
  /*:T Jamais remova a definição do include a seguir de dentro da lógica do programa */
  {include/i-frm175.i}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-delete-from-target w-window 
PROCEDURE pi-delete-from-target :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   define input parameter v-row-target-browse as rowid no-undo.

   def var r-target as rowid no-undo.
   
  /*:T Jamais remova a definição do include a seguir de dentro da lógica do programa */
  {include/i-frm180.i}
   
   find tt-target where
        rowid(tt-target) = v-row-target-browse
        no-error.
        
   assign r-target = rowid(tt-target).

   find tt-source where
        tt-source.gm-codigo = tt-target.gm-codigo
        no-error.
        
   if not avail tt-source 
   then do:
        create tt-source.
        assign tt-source.gm-codigo = tt-target.gm-codigo
               tt-source.descricao = tt-target.descricao
               lg-modificada        = yes.
   end.
   
   find tt-target where 
        rowid(tt-target) = r-target
        no-error.
        
   if avail tt-target 
   then delete tt-target.
   
  /*:T Jamais remova a definição do include a seguir de dentro da lógica do programa */
  {include/i-frm185.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exc w-window 
PROCEDURE pi-exc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var i-cont   as inte  no-undo.
def var r-source as rowid no-undo.

if br-target-browse:num-selected-rows in frame {&frame-name} = 0
then return "OK".

do i-cont = 1 to br-target-browse:num-selected-rows in frame {&frame-name}:
    br-target-browse:fetch-selected-row(i-cont).
    find current tt-target no-error.

    create tt-source.
    assign tt-source.gm-codigo = tt-target.gm-codigo
           tt-source.descricao = tt-target.descricao.
    find current tt-source no-error.
    assign r-source      = rowid(tt-source)
           lg-modificada = yes.

    delete tt-target.
end.

release tt-source.
release tt-target.

{&open-query-br-source-browse}
{&open-query-br-target-browse}

for first tt-target:
     browse br-target-browse:set-repositioned-row(1, 'CONDITIONAL').
     reposition br-target-browse to rowid rowid(tt-target) no-error. 
     br-target-browse:select-focused-row().
     apply 'iteration-changed'  to br-target-browse.
end.

if r-source <> ?
then do:
     browse br-source-browse:set-repositioned-row(1, 'CONDITIONAL').
     reposition br-source-browse to rowid r-source no-error. 
     br-source-browse:select-focused-row().
     apply 'iteration-changed'  to br-source-browse.
end.

run pi-ctrl-bt.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inc w-window 
PROCEDURE pi-inc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var i-cont   as inte  no-undo.
def var r-target as rowid no-undo.

if br-source-browse:num-selected-rows in frame {&frame-name} = 0
then return "OK".

do i-cont = 1 to br-source-browse:num-selected-rows in frame {&frame-name}:
    br-source-browse:fetch-selected-row(i-cont).
    find current tt-source no-error.

    create tt-target.
    assign tt-target.gm-codigo = tt-source.gm-codigo
           tt-target.descricao = tt-source.descricao.
    find current tt-target no-error.
    assign r-target      = rowid(tt-target)
           lg-modificada = yes.

    delete tt-source.
end.

release tt-target.
release tt-source.

{&open-query-br-target-browse}
{&open-query-br-source-browse}

for first tt-source:
     browse br-source-browse:set-repositioned-row(1, 'CONDITIONAL').
     reposition br-source-browse to rowid rowid(tt-source) no-error. 
     br-source-browse:select-focused-row().
     apply 'iteration-changed'  to br-source-browse.
end.

if r-target <> ?
then do:
     browse br-target-browse:set-repositioned-row(1, 'CONDITIONAL').
     reposition br-target-browse to rowid r-target no-error. 
     br-target-browse:select-focused-row().
     apply 'iteration-changed'  to br-target-browse.
end.

run pi-ctrl-bt.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-init-source w-window 
PROCEDURE pi-init-source :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var h-acomp as handle no-undo.

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Carregando source...").

if not can-find (first aloc_bem where
                       aloc_bem.num_id_bem_pat = bem_pat.num_id_bem_pat
                       no-lock)
then if  bem_pat.cod_plano_ccusto    = int_param_uep.cod_plano_ccusto
     and bem_pat.cod_ccusto_respons >= int_param_uep.cod_ccusto_ini
     and bem_pat.cod_ccusto_respons <= int_param_uep.cod_ccusto_fim
     then run pi-carrega (input bem_pat.cod_ccusto_respons).
     else.
else for each aloc_bem no-lock
        where aloc_bem.num_id_bem_pat   = bem_pat.num_id_bem_pat
          and aloc_bem.cod_empresa      = bem_pat.cod_empresa
          and aloc_bem.cod_plano_ccusto = int_param_uep.cod_plano_ccusto
          and aloc_bem.cod_ccusto      >= int_param_uep.cod_ccusto_ini
          and aloc_bem.cod_ccusto      <= int_param_uep.cod_ccusto_fim:
         run pi-carrega (input aloc_bem.cod_ccusto).
     end. /* for each aloc_bem */

/* for each grup-maquina fields(gm-codigo descricao) no-lock:          */
/*     run pi-acompanhar in h-acomp (input grup-maquina.gm-codigo).    */
/*                                                                     */
/*     if can-find(first tt-target where                               */
/*                       tt-target.gm-codigo = grup-maquina.gm-codigo) */
/*     then next.                                                      */
/*                                                                     */
/*     create tt-source.                                               */
/*     assign tt-source.gm-codigo = grup-maquina.gm-codigo             */
/*            tt-source.descricao = grup-maquina.descricao.            */
/* end. /* for each gm-estab */                                        */

find current tt-source no-error.
release tt-source.

run pi-finalizar in h-acomp.
if valid-handle(h-acomp)
then delete procedure h-acomp no-error.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-init-target w-window 
PROCEDURE pi-init-target :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

for each int_bem_pat_gm exclusive-lock
   where int_bem_pat_gm.num_id_bem_pat = int_bem_pat.num_id_bem_pat:
    for first grup-maquina fields(descricao)
        where grup-maquina.gm-codigo = int_bem_pat_gm.gm-codigo
              no-lock: end.

    if not avail grup-maquina
    then do:
         delete int_bem_pat_gm.
         next.
    end.

    create tt-target.
    buffer-copy int_bem_pat_gm to tt-target
        assign tt-target.descricao = grup-maquina.descricao.
end. /* for each int_bem_pat_gm */
find current tt-target no-error.
release tt-target.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ins w-window 
PROCEDURE pi-ins :
/*:T ------------------------------------------------------------------------------
  Purpose   : Incluir no browse destiono o registro selecionado no browse origem     
  Parameters: 
------------------------------------------------------------------------------*/
  /*:T Jamais remova a definição do include a seguir de dentro da lógica do programa */

  {include/i-frm157.i}

  /*:T Caso o include a seguir nao atenda suas necessidades, apague-o  e crie sua propria
  logica usando-o como modelo. 
  */      
  run pi-inc.
  
  /*:T Jamais remova a definição do include a seguir de dentro da lógica do programa */
  {include/i-frm165.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-revalida w-window 
PROCEDURE pi-revalida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var r-tt-target as rowid no-undo.

def buffer b-tt-target for tt-target.

find current int_bem_pat no-lock no-error.

if rowid(int_bem_pat) <> v-row-parent
then return "NOK".

if int_bem_pat.molde
then do:
     run utp/ut-msgs.p (input "show":U, input 17567, input "Op‡Æo Molde est  marcada. Desmarque-a antes de realizar esta a‡Æo!").
     return "NOK".
end.

for each tt-target:
    assign r-tt-target = rowid(tt-target).
    
    find first b-tt-target where 
               b-tt-target.gm-codigo = tt-target.gm-codigo 
           and rowid(b-tt-target) <> rowid(tt-target)
               no-error.

    if avail b-tt-target 
    then do:
         reposition br-target-browse to rowid rowid(b-tt-target).
         run utp/ut-msgs.p (input "show":U, input 17567, input "Duplicidade no destino!").
         return "NOK".
    end.

    if not can-find(first grup-maquina where 
                          grup-maquina.gm-codigo = tt-target.gm-codigo
                          no-lock)
    then do:
         reposition br-target-browse to rowid rowid(b-tt-target).
         run utp/ut-msgs.p (input "show":U, input 17567, input "Grupo M quina nÆo cadastrado!").
         return "NOK".
    end.

    if not can-find(first gm-estab where
                          gm-estab.gm-codigo   = tt-target.gm-codigo
                      and gm-estab.cod-estabel = bem_pat.cod_estab
                      and gm-estab.cc-codigo  >= int_param_uep.cod_ccusto_ini
                      and gm-estab.cc-codigo  <= int_param_uep.cod_ccusto_fim
                          no-lock)
    then do:
         reposition br-target-browse to rowid r-tt-target.
         run utp/ut-msgs.p (input "show":U, input 17567, input "Gr M q nÆo associado ao Estab do Bem ou a um CCusto v lido (" + int_param_uep.cod_ccusto_ini + "-" + int_param_uep.cod_ccusto_fim + ")!").
         return "NOK".
    end.

    for each gm-estab no-lock
       where gm-estab.gm-codigo   = tt-target.gm-codigo
         and gm-estab.cod-estabel = bem_pat.cod_estab
         and gm-estab.cc-codigo  >= int_param_uep.cod_ccusto_ini
         and gm-estab.cc-codigo  <= int_param_uep.cod_ccusto_fim:
        if can-find(first aloc_bem where
                          aloc_bem.num_id_bem_pat   = bem_pat.num_id_bem_pat
                      and aloc_bem.cod_empresa      = bem_pat.cod_empresa
                      and aloc_bem.cod_plano_ccusto = int_param_uep.cod_plano_ccusto
                      and aloc_bem.cod_ccusto       = gm-estab.cc-codigo
                          no-lock)
        or (not can-find(first aloc_bem where
                               aloc_bem.num_id_bem_pat   = bem_pat.num_id_bem_pat
                               no-lock)
        and bem_pat.cod_plano_ccusto   = int_param_uep.cod_plano_ccusto
        and bem_pat.cod_ccusto_respons = gm-estab.cc-codigo)
        then next.

        reposition br-target-browse to rowid r-tt-target.
        run utp/ut-msgs.p (input "show":U, input 17567, input "Gr M q nÆo associado ao Bem ou a um CCusto v lido (" + int_param_uep.cod_ccusto_ini + "-" + int_param_uep.cod_ccusto_fim + ")!").
        return "NOK".
    end. /* for each gm-estab */
end. /* for each tt-target */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-show-master-record w-window 
PROCEDURE pi-show-master-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /*:T Jamais remova a definição do include a seguir de dentro da lógica do programa */

  {include/i-frm145.i}

  /*:T Lógica padrão para apresentação do registro da tabela pai caso esta lógica atenda 
     as suas necessidades chame o include a seguir no corpo da procedure (retire-o de
     dentro do comentário). Em caso contrário crie sua própria lógica usando a 
     do include como modelo.
  */   

  /*
  {include/i-frm150.i}
  */
  
  {include/i-frm155.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-window  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-target"}
  {src/adm/template/snd-list.i "tt-source"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-window 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
  
  if p-state = "apply-entry":U then
     apply "entry":U to bt-ok in frame {&frame-name}.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION is-create-allowed w-window 
FUNCTION is-create-allowed RETURNS LOGICAL
  ( v-row-tt as rowid) : /*:T rowid do registro selecionado no origem */
/*:T------------------------------------------------------------------------------
  Purpose:  Insira aqui a l¢gica que deve verificar se o registro corrente pode ou
            nÆo ser incluido no browse de destino
    Notes:  
------------------------------------------------------------------------------*/

  RETURN true.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION is-delete-allowed w-window 
FUNCTION is-delete-allowed RETURNS LOGICAL
  ( v-row-target as rowid) : /*:T rowid do registro selecionado no destino */
/*:T------------------------------------------------------------------------------
  Purpose:  Insira aqui a l¢gica que deve verificar se o registro corrente pode ou
            nÆo ser eliminado do browse de destino
    Notes:  
------------------------------------------------------------------------------*/

  RETURN true.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

