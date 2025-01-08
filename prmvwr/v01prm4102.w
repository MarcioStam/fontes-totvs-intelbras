&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgdes            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
{include/i-prgvrs.i V01PRM4102 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever  ser MUT                    */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i PRM4102 MUT}
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
{prmapi/PrmParamIntegrador.i}

def var v-row-parent as rowid no-undo.
DEFINE VARIABLE param-int AS CLASS prmapi.PrmParamIntegrador NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES prm-param-integrador
&Scoped-define FIRST-EXTERNAL-TABLE prm-param-integrador


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR prm-param-integrador.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS prm-param-integrador.cod-grp-usuar-cliente ~
prm-param-integrador.cod-grp-usuar-integracao ~
prm-param-integrador.cod-grp-usuar-int-recebimento ~
prm-param-integrador.cod-gr-cli-pj prm-param-integrador.cod-gr-cli-pf 
&Scoped-define ENABLED-TABLES prm-param-integrador
&Scoped-define FIRST-ENABLED-TABLE prm-param-integrador
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS prm-param-integrador.cod-grp-usuar-cliente ~
prm-param-integrador.cod-grp-usuar-integracao ~
prm-param-integrador.cod-grp-usuar-int-recebimento ~
prm-param-integrador.cod-gr-cli-pj prm-param-integrador.cod-gr-cli-pf 
&Scoped-define DISPLAYED-TABLES prm-param-integrador
&Scoped-define FIRST-DISPLAYED-TABLE prm-param-integrador
&Scoped-Define DISPLAYED-OBJECTS fi-desc-grp-usuar-client ~
fi-desc-grp-usuar-integracao fi-desc-grp-usuar-int-rec fi-desc-gr-cli-pj ~
fi-desc-gr-cli-pf 

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
DEFINE VARIABLE fi-desc-gr-cli-pf AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-gr-cli-pj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-grp-usuar-client AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-grp-usuar-int-rec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-grp-usuar-integracao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 5.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     prm-param-integrador.cod-grp-usuar-cliente AT ROW 1.67 COL 25.86 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     fi-desc-grp-usuar-client AT ROW 1.67 COL 34.86 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     prm-param-integrador.cod-grp-usuar-integracao AT ROW 2.67 COL 25.86 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     fi-desc-grp-usuar-integracao AT ROW 2.67 COL 34.86 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     prm-param-integrador.cod-grp-usuar-int-recebimento AT ROW 3.67 COL 25.86 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     fi-desc-grp-usuar-int-rec AT ROW 3.67 COL 34.86 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     prm-param-integrador.cod-gr-cli-pj AT ROW 4.67 COL 25.86 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     fi-desc-gr-cli-pj AT ROW 4.67 COL 34.86 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     prm-param-integrador.cod-gr-cli-pf AT ROW 5.67 COL 25.86 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     fi-desc-gr-cli-pf AT ROW 5.67 COL 34.86 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     rt-mold AT ROW 1.25 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgdes.prm-param-integrador
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
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
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 6.25
         WIDTH              = 73.72.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fi-desc-gr-cli-pf IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-gr-cli-pj IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-grp-usuar-client IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-grp-usuar-int-rec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-grp-usuar-integracao IN FRAME f-main
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

&Scoped-define SELF-NAME prm-param-integrador.cod-gr-cli-pf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-param-integrador.cod-gr-cli-pf V-table-Win
ON LEAVE OF prm-param-integrador.cod-gr-cli-pf IN FRAME f-main /* Grupo Cliente PF */
DO:
    FIND FIRST gr-cli WHERE gr-cli.cod-gr-cli = prm-param-integrador.cod-gr-cli-pf:INPUT-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE(gr-cli) THEN
        ASSIGN fi-desc-gr-cli-pf:SCREEN-VALUE = gr-cli.descricao.
    ELSE
        ASSIGN fi-desc-gr-cli-pf:SCREEN-VALUE = "".   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-param-integrador.cod-gr-cli-pf V-table-Win
ON MOUSE-SELECT-DBLCLICK OF prm-param-integrador.cod-gr-cli-pf IN FRAME f-main /* Grupo Cliente PF */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad129.r
                       &campozoom=cod-gr-cli
                       &campo=prm-param-integrador.cod-gr-cli-pf
                       &campozoom2=descricao
                       &campo2=fi-desc-gr-cli-pf                                                 
                       &FRAME=f-main}      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME prm-param-integrador.cod-gr-cli-pj
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-param-integrador.cod-gr-cli-pj V-table-Win
ON LEAVE OF prm-param-integrador.cod-gr-cli-pj IN FRAME f-main /* Grupo Cliente PJ */
DO:
    FIND FIRST gr-cli WHERE gr-cli.cod-gr-cli = prm-param-integrador.cod-gr-cli-pj:INPUT-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE(gr-cli) THEN
        ASSIGN fi-desc-gr-cli-pj:SCREEN-VALUE = gr-cli.descricao.
    ELSE
        ASSIGN fi-desc-gr-cli-pj:SCREEN-VALUE = "".         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-param-integrador.cod-gr-cli-pj V-table-Win
ON MOUSE-SELECT-DBLCLICK OF prm-param-integrador.cod-gr-cli-pj IN FRAME f-main /* Grupo Cliente PJ */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad129.r
                       &campozoom=cod-gr-cli
                       &campo=prm-param-integrador.cod-gr-cli-pj
                       &campozoom2=descricao
                       &campo2=fi-desc-gr-cli-pj                                                 
                       &FRAME=f-main}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME prm-param-integrador.cod-grp-usuar-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-param-integrador.cod-grp-usuar-cliente V-table-Win
ON LEAVE OF prm-param-integrador.cod-grp-usuar-cliente IN FRAME f-main /* Grupo de Usu rios Cliente */
DO:
    FIND FIRST grp_usuar WHERE grp_usuar.cod_grp_usuar = prm-param-integrador.cod-grp-usuar-cliente:INPUT-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE(grp_usuar) THEN
        ASSIGN fi-desc-grp-usuar-client:SCREEN-VALUE = grp_usuar.des_grp_usuar.
    ELSE
        ASSIGN fi-desc-grp-usuar-client:SCREEN-VALUE = "".   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-param-integrador.cod-grp-usuar-cliente V-table-Win
ON MOUSE-SELECT-DBLCLICK OF prm-param-integrador.cod-grp-usuar-cliente IN FRAME f-main /* Grupo de Usu rios Cliente */
DO:
    {include/zoomvar.i &prog-zoom=fnzoom/z01fn069.r
                       &campozoom=cod_grp_usuar
                       &campo=prm-param-integrador.cod-grp-usuar-cliente
                       &campozoom2=des_grp_usuar
                       &campo2=fi-desc-grp-usuar-client                                                 
                       &FRAME=f-main}        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME prm-param-integrador.cod-grp-usuar-int-recebimento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-param-integrador.cod-grp-usuar-int-recebimento V-table-Win
ON LEAVE OF prm-param-integrador.cod-grp-usuar-int-recebimento IN FRAME f-main /* Grupo de Usu rios Int Recebimento */
DO:     
    FIND FIRST grp_usuar WHERE grp_usuar.cod_grp_usuar = prm-param-integrador.cod-grp-usuar-int-recebimento:INPUT-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE(grp_usuar) THEN
        ASSIGN fi-desc-grp-usuar-int-rec:SCREEN-VALUE = grp_usuar.des_grp_usuar.
    ELSE
        ASSIGN  fi-desc-grp-usuar-int-rec:SCREEN-VALUE = "".   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-param-integrador.cod-grp-usuar-int-recebimento V-table-Win
ON MOUSE-SELECT-DBLCLICK OF prm-param-integrador.cod-grp-usuar-int-recebimento IN FRAME f-main /* Grupo de Usu rios Int Recebimento */
DO:
    {include/zoomvar.i &prog-zoom=fnzoom/z01fn069.r
                       &campozoom=cod_grp_usuar
                       &campo=prm-param-integrador.cod-grp-usuar-int-recebimento
                       &campozoom2=des_grp_usuar
                       &campo2=fi-desc-grp-usuar-int-rec
                       &FRAME=f-main}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME prm-param-integrador.cod-grp-usuar-integracao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-param-integrador.cod-grp-usuar-integracao V-table-Win
ON LEAVE OF prm-param-integrador.cod-grp-usuar-integracao IN FRAME f-main /* Grupo de Usu rios Integra‡Æo */
DO:     
    FIND FIRST grp_usuar WHERE grp_usuar.cod_grp_usuar = prm-param-integrador.cod-grp-usuar-integracao:INPUT-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE(grp_usuar) THEN
        ASSIGN fi-desc-grp-usuar-integracao:SCREEN-VALUE = grp_usuar.des_grp_usuar.
    ELSE
        ASSIGN  fi-desc-grp-usuar-integracao:SCREEN-VALUE = "".   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-param-integrador.cod-grp-usuar-integracao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF prm-param-integrador.cod-grp-usuar-integracao IN FRAME f-main /* Grupo de Usu rios Integra‡Æo */
DO:
    {include/zoomvar.i &prog-zoom=fnzoom/z01fn069.r
                       &campozoom=cod_grp_usuar
                       &campo=prm-param-integrador.cod-grp-usuar-integracao
                       &campozoom2=des_grp_usuar
                       &campo2=fi-desc-grp-usuar-integracao                                                 
                       &FRAME=f-main}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
prm-param-integrador.cod-grp-usuar-cliente:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-main.
prm-param-integrador.cod-grp-usuar-integracao:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-main.
prm-param-integrador.cod-grp-usuar-int-recebimento:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-main.
prm-param-integrador.cod-gr-cli-pj:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-main.
prm-param-integrador.cod-gr-cli-pf:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-main.

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
  {src/adm/template/row-list.i "prm-param-integrador"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "prm-param-integrador"}

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
    {include/i-valid.i}
    
    /*:T Ponha na pi-validate todas as valida‡äes */
    /*:T NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */              
    
    /* Dispatch standard ADM method.                             */
    DO TRANSACTION:
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).
        
        EMPTY TEMP-TABLE tt-prm-param-integrador.
        CREATE tt-prm-param-integrador.
        BUFFER-COPY prm-param-integrador TO tt-prm-param-integrador.
        
        param-int = NEW prmapi.PrmParamIntegrador().
        param-int:ValidateUpdate(BUFFER tt-prm-param-integrador).
        
        CATCH erro AS Progress.Lang.Error :
            RUN utp/ut-msgs.p(INPUT "show":U,INPUT 17006,INPUT "Ocorreram os erros abaixo.~~" + erro:GetMessage(1)).
            RETURN 'ADM-ERROR':U.                
        END CATCH.
    END.                     
    
    /*IF RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.*/
    
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
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
    
    DO WITH FRAME f-main:
        APPLY "LEAVE" TO prm-param-integrador.cod-grp-usuar-cliente.
        APPLY "LEAVE" TO prm-param-integrador.cod-grp-usuar-integracao.
        APPLY "LEAVE" TO prm-param-integrador.cod-grp-usuar-int-recebimento.
        APPLY "LEAVE" TO prm-param-integrador.cod-gr-cli-pj.
        APPLY "LEAVE" TO prm-param-integrador.cod-gr-cli-pf.
    END.

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
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Valida‡Æo de dicion rio */
    
/*:T    Segue um exemplo de valida‡Æo de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */

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
  {src/adm/template/snd-list.i "prm-param-integrador"}

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

