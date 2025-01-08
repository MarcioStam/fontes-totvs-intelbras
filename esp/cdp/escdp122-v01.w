&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCDP122-V01 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever  ser MUT                    */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESCDP122-V01 ESP}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid         no-undo.
def var h-container  as widget-handle no-undo.

def new global shared var v_cod_empres_usuar as character no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES int_param_uep
&Scoped-define FIRST-EXTERNAL-TABLE int_param_uep


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR int_param_uep.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS int_param_uep.cod_plano_ccusto ~
int_param_uep.cod_ccusto_ini int_param_uep.cod_ccusto_fim 
&Scoped-define ENABLED-TABLES int_param_uep
&Scoped-define FIRST-ENABLED-TABLE int_param_uep
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS int_param_uep.cod_empresa ~
int_param_uep.cod_plano_ccusto int_param_uep.cod_ccusto_ini ~
int_param_uep.cod_ccusto_fim 
&Scoped-define DISPLAYED-TABLES int_param_uep
&Scoped-define FIRST-DISPLAYED-TABLE int_param_uep
&Scoped-Define DISPLAYED-OBJECTS fi_nom_razao_social fi_des_tit_ctbl 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE fi_des_tit_ctbl AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE fi_nom_razao_social AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 3.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     int_param_uep.cod_empresa AT ROW 1.17 COL 27 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     int_param_uep.cod_plano_ccusto AT ROW 2.67 COL 27 COLON-ALIGNED WIDGET-ID 8
          LABEL "Plano CCusto"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88 TOOLTIP "Plano CCusto para Energia e Deprecia‡Æo"
     int_param_uep.cod_ccusto_ini AT ROW 3.67 COL 27 COLON-ALIGNED WIDGET-ID 4
          LABEL "CCusto Inicial"
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88 TOOLTIP "CCusto inicial para Energia e Deprecia‡Æo"
     int_param_uep.cod_ccusto_fim AT ROW 4.67 COL 27 COLON-ALIGNED WIDGET-ID 2
          LABEL "CCusto Final"
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88 TOOLTIP "CCusto final para Energia e Deprecia‡Æo"
     fi_nom_razao_social AT ROW 1.17 COL 34.43 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     fi_des_tit_ctbl AT ROW 2.67 COL 39.43 COLON-ALIGNED HELP
          "Descri‡Æo Conta Patrimonial" NO-LABEL WIDGET-ID 10
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgesp.int_param_uep
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 4.88
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{include/i_dbtype.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R,COLUMNS                    */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN int_param_uep.cod_ccusto_fim IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN int_param_uep.cod_ccusto_ini IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN int_param_uep.cod_empresa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_param_uep.cod_plano_ccusto IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fi_des_tit_ctbl IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_nom_razao_social IN FRAME f-main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME int_param_uep.cod_empresa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_param_uep.cod_empresa V-table-Win
ON LEAVE OF int_param_uep.cod_empresa IN FRAME f-main /* Empresa */
DO:
  assign fi_nom_razao_social:screen-value in frame {&frame-name} = "".

  for first emscad.empresa no-lock
      where empresa.cod_empresa = input frame {&frame-name} int_param_uep.cod_empresa:
      assign fi_nom_razao_social:screen-value in frame {&frame-name} = emscad.empresa.nom_razao_social.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int_param_uep.cod_plano_ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_param_uep.cod_plano_ccusto V-table-Win
ON LEAVE OF int_param_uep.cod_plano_ccusto IN FRAME f-main /* Plano CCusto */
DO:
  assign fi_des_tit_ctbl:screen-value in frame {&frame-name} = "".

  for first plano_ccusto no-lock
      where plano_ccusto.cod_empresa      = input frame {&frame-name} int_param_uep.cod_empresa
        and plano_ccusto.cod_plano_ccusto = input frame {&frame-name} int_param_uep.cod_plano_ccusto:
      assign int_param_uep.cod_plano_ccusto:screen-value in frame {&frame-name} = plano_ccusto.cod_plano_ccusto
             fi_des_tit_ctbl:screen-value                in frame {&frame-name} = plano_ccusto.des_tit_ctbl.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "int_param_uep"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "int_param_uep"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
/*     {include/i-valid.i} */
    if not frame {&frame-name}:validate() then
                return 'ADM-ERROR':U.
    
    /*:T Ponha na pi-validate todas as valida‡äes */
    /*:T NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    apply 'leave' to int_param_uep.cod_plano_ccusto in frame {&frame-name}.

    assign int_param_uep.cod_ccusto_ini:screen-value in frame {&frame-name} = trim(input frame {&frame-name} int_param_uep.cod_ccusto_ini)
           int_param_uep.cod_ccusto_fim:screen-value in frame {&frame-name} = trim(input frame {&frame-name} int_param_uep.cod_ccusto_fim).

    run pi-validate.
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /*:T Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif   
    
    run pi-busca-pai.
    
    if valid-handle(h-container)
    then run pi-controle in h-container (input "disable").
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    if input frame {&frame-name} int_param_uep.cod_empresa = ""
    then assign int_param_uep.cod_empresa:screen-value in frame {&frame-name} = v_cod_empres_usuar.

    apply 'leave' to int_param_uep.cod_empresa      in frame {&frame-name}.
    apply 'leave' to int_param_uep.cod_plano_ccusto in frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
/*     if adm-new-record = yes then */
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    run pi-busca-pai.
    
    if valid-handle(h-container)
    then run pi-controle in h-container (input "enable").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter v-row-parent-externo as rowid no-undo.
    
    assign v-row-parent = v-row-parent-externo.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-pai V-table-Win 
PROCEDURE pi-busca-pai :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var c-container as char no-undo.

run who-is-the-container in adm-broker-hdl(input this-procedure,
                                           output c-container).

assign h-container = widget-handle(c-container).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    def var de-cc-codigo as deci no-undo.

    {include/i-vldfrm.i} /*:T Valida‡Æo de dicion rio */
    
/*:T    Segue um exemplo de valida‡Æo de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */
  
    if not can-find(first plano_ccusto where
                          plano_ccusto.cod_empresa      = input frame {&frame-name} int_param_uep.cod_empresa
                      and plano_ccusto.cod_plano_ccusto = input frame {&frame-name} int_param_uep.cod_plano_ccusto
                          no-lock)
    then do:
         run utp/ut-msgs.p (input "show":U, input 17567, input "Plano Centro Custo nÆo cadastrado!").
         apply 'entry' to int_param_uep.cod_plano_ccusto in frame {&frame-name}.
         return 'ADM-ERROR':U.
    end.

    if input frame {&frame-name} int_param_uep.cod_ccusto_ini > input frame {&frame-name} int_param_uep.cod_ccusto_fim
    then do:
         run utp/ut-msgs.p (input "show":U, input 17567, input "Centro de Custo inicial maior que final!").
         apply 'entry' to int_param_uep.cod_ccusto_ini in frame {&frame-name}.
         return 'ADM-ERROR':U.
    end.

    if input frame {&frame-name} int_param_uep.cod_ccusto_fim = ""
    then do:
         run utp/ut-msgs.p (input "show":U, input 17567, input "Intervalo de Centro de Custos deve ser informado!").
         apply 'entry' to int_param_uep.cod_ccusto_fim in frame {&frame-name}.
         return 'ADM-ERROR':U.
    end.

    assign de-cc-codigo = deci(input frame {&frame-name} int_param_uep.cod_ccusto_ini) no-error.

    if error-status:error
    then do:
         run utp/ut-msgs.p (input "show":U, input 17567, input "Centro de Custos deve ser num‚rico!").
         apply 'entry' to int_param_uep.cod_ccusto_ini in frame {&frame-name}.
         return 'ADM-ERROR':U.
    end.

    assign de-cc-codigo = deci(input frame {&frame-name} int_param_uep.cod_ccusto_fim) no-error.

    if error-status:error
    then do:
         run utp/ut-msgs.p (input "show":U, input 17567, input "Centro de Custos deve ser num‚rico!").
         apply 'entry' to int_param_uep.cod_ccusto_fim in frame {&frame-name}.
         return 'ADM-ERROR':U.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "int_param_uep"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

