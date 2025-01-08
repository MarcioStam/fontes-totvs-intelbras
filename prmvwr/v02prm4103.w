&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgdes            PROGRESS
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
{include/i-prgvrs.i V99XX999 9.99.99.999}

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
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

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
&Scoped-define EXTERNAL-TABLES prm-projeto-integrador
&Scoped-define FIRST-EXTERNAL-TABLE prm-projeto-integrador


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR prm-projeto-integrador.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS prm-projeto-integrador.url-nfe-venda ~
prm-projeto-integrador.dir-nfe-venda prm-projeto-integrador.url-nfe-canc ~
prm-projeto-integrador.dir-nfe-canc prm-projeto-integrador.url-nfe-rem ~
prm-projeto-integrador.dir-nfe-rem prm-projeto-integrador.url-nfe-ret ~
prm-projeto-integrador.dir-nfe-ret prm-projeto-integrador.url-nfe-devol ~
prm-projeto-integrador.dir-nfe-devol prm-projeto-integrador.url-cte ~
prm-projeto-integrador.dir-cte 
&Scoped-define ENABLED-TABLES prm-projeto-integrador
&Scoped-define FIRST-ENABLED-TABLE prm-projeto-integrador
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 RECT-4 RECT-5 RECT-6 RECT-7 ~
bt-dir-nfe-venda bt-dir-nfe-canc bt-dir-nfe-rem bt-dir-nfe-ret ~
bt-dir-nfe-devol bt-dir-cte 
&Scoped-Define DISPLAYED-FIELDS prm-projeto-integrador.url-nfe-venda ~
prm-projeto-integrador.dir-nfe-venda prm-projeto-integrador.url-nfe-canc ~
prm-projeto-integrador.dir-nfe-canc prm-projeto-integrador.url-nfe-rem ~
prm-projeto-integrador.dir-nfe-rem prm-projeto-integrador.url-nfe-ret ~
prm-projeto-integrador.dir-nfe-ret prm-projeto-integrador.url-nfe-devol ~
prm-projeto-integrador.dir-nfe-devol prm-projeto-integrador.url-cte ~
prm-projeto-integrador.dir-cte 
&Scoped-define DISPLAYED-TABLES prm-projeto-integrador
&Scoped-define FIRST-DISPLAYED-TABLE prm-projeto-integrador


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
DEFINE BUTTON bt-dir-cte 
     IMAGE-UP FILE "adeicon/open.bmp":U
     LABEL "" 
     SIZE 4.43 BY .96.

DEFINE BUTTON bt-dir-nfe-canc 
     IMAGE-UP FILE "adeicon/open.bmp":U
     LABEL "" 
     SIZE 4.43 BY .96.

DEFINE BUTTON bt-dir-nfe-devol 
     IMAGE-UP FILE "adeicon/open.bmp":U
     LABEL "" 
     SIZE 4.43 BY .96.

DEFINE BUTTON bt-dir-nfe-rem 
     IMAGE-UP FILE "adeicon/open.bmp":U
     LABEL "" 
     SIZE 4.43 BY .96.

DEFINE BUTTON bt-dir-nfe-ret 
     IMAGE-UP FILE "adeicon/open.bmp":U
     LABEL "" 
     SIZE 4.43 BY .96.

DEFINE BUTTON bt-dir-nfe-venda 
     IMAGE-UP FILE "adeicon/open.bmp":U
     LABEL "" 
     SIZE 4.43 BY .96.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.14 BY 2.33.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.14 BY 2.33.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.14 BY 2.33.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.14 BY 2.33.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.14 BY 2.33.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.14 BY 2.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     prm-projeto-integrador.url-nfe-venda AT ROW 1.54 COL 23.72 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 55.29 BY .88
     bt-dir-nfe-venda AT ROW 2.5 COL 81 WIDGET-ID 36
     prm-projeto-integrador.dir-nfe-venda AT ROW 2.54 COL 23.72 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 55.29 BY .88
     prm-projeto-integrador.url-nfe-canc AT ROW 4.17 COL 23.72 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 55.29 BY .88
     bt-dir-nfe-canc AT ROW 5.13 COL 81 WIDGET-ID 38
     prm-projeto-integrador.dir-nfe-canc AT ROW 5.17 COL 23.72 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 55.29 BY .88
     prm-projeto-integrador.url-nfe-rem AT ROW 6.79 COL 23.72 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 55.29 BY .88
     bt-dir-nfe-rem AT ROW 7.75 COL 81 WIDGET-ID 56
     prm-projeto-integrador.dir-nfe-rem AT ROW 7.79 COL 23.72 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 55.29 BY .88
     prm-projeto-integrador.url-nfe-ret AT ROW 9.42 COL 23.72 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 55.29 BY .88
     bt-dir-nfe-ret AT ROW 10.38 COL 81 WIDGET-ID 58
     prm-projeto-integrador.dir-nfe-ret AT ROW 10.42 COL 23.72 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 55.29 BY .88
     prm-projeto-integrador.url-nfe-devol AT ROW 12 COL 23.72 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 55.29 BY .88
     bt-dir-nfe-devol AT ROW 13 COL 81 WIDGET-ID 60
     prm-projeto-integrador.dir-nfe-devol AT ROW 13.04 COL 23.72 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 55.29 BY .88
     prm-projeto-integrador.url-cte AT ROW 14.67 COL 23.72 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 55.29 BY .88
     bt-dir-cte AT ROW 15.63 COL 81 WIDGET-ID 62
     prm-projeto-integrador.dir-cte AT ROW 15.67 COL 23.72 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 55.29 BY .88
     "CT-e" VIEW-AS TEXT
          SIZE 5.14 BY .67 AT ROW 14.21 COL 2.72 WIDGET-ID 54
     "NF-e Devolu‡Æo" VIEW-AS TEXT
          SIZE 13.14 BY .67 AT ROW 11.54 COL 2.72 WIDGET-ID 50
     "NF-e de Venda" VIEW-AS TEXT
          SIZE 13.14 BY .67 AT ROW 1.04 COL 2.72 WIDGET-ID 30
     "NF-e Canceladas" VIEW-AS TEXT
          SIZE 13.14 BY .67 AT ROW 3.67 COL 2.72 WIDGET-ID 34
     "NF-e Remessa" VIEW-AS TEXT
          SIZE 13.14 BY .67 AT ROW 6.29 COL 2.72 WIDGET-ID 42
     "NF-e Retorno" VIEW-AS TEXT
          SIZE 13.14 BY .67 AT ROW 8.92 COL 2.72 WIDGET-ID 46
     RECT-2 AT ROW 1.33 COL 2.14 WIDGET-ID 28
     RECT-3 AT ROW 3.96 COL 2.14 WIDGET-ID 32
     RECT-4 AT ROW 6.58 COL 2.14 WIDGET-ID 40
     RECT-5 AT ROW 9.21 COL 2.14 WIDGET-ID 44
     RECT-6 AT ROW 11.83 COL 2.14 WIDGET-ID 48
     RECT-7 AT ROW 14.5 COL 2.14 WIDGET-ID 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgdes.prm-projeto-integrador
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
         HEIGHT             = 16.58
         WIDTH              = 87.14.
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

&Scoped-define SELF-NAME bt-dir-cte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-dir-cte V-table-Win
ON CHOOSE OF bt-dir-cte IN FRAME f-main
DO:
    DEFINE VARIABLE c-diretorio AS CHARACTER NO-UNDO.
    
    SYSTEM-DIALOG GET-DIR c-diretorio.
                  
    IF c-diretorio <> "" THEN
        ASSIGN prm-projeto-integrador.dir-cte:SCREEN-VALUE = c-diretorio.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-dir-nfe-canc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-dir-nfe-canc V-table-Win
ON CHOOSE OF bt-dir-nfe-canc IN FRAME f-main
DO:
    DEFINE VARIABLE c-diretorio AS CHARACTER NO-UNDO.
    
    SYSTEM-DIALOG GET-DIR c-diretorio.
                  
    IF c-diretorio <> "" THEN
        ASSIGN prm-projeto-integrador.dir-nfe-canc:SCREEN-VALUE = c-diretorio.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-dir-nfe-devol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-dir-nfe-devol V-table-Win
ON CHOOSE OF bt-dir-nfe-devol IN FRAME f-main
DO:
    DEFINE VARIABLE c-diretorio AS CHARACTER NO-UNDO.
    
    SYSTEM-DIALOG GET-DIR c-diretorio.
                  
    IF c-diretorio <> "" THEN
        ASSIGN prm-projeto-integrador.dir-nfe-devol:SCREEN-VALUE = c-diretorio.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-dir-nfe-rem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-dir-nfe-rem V-table-Win
ON CHOOSE OF bt-dir-nfe-rem IN FRAME f-main
DO:
    DEFINE VARIABLE c-diretorio AS CHARACTER NO-UNDO.
    
    SYSTEM-DIALOG GET-DIR c-diretorio.
                  
    IF c-diretorio <> "" THEN
        ASSIGN prm-projeto-integrador.dir-nfe-rem:SCREEN-VALUE = c-diretorio.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-dir-nfe-ret
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-dir-nfe-ret V-table-Win
ON CHOOSE OF bt-dir-nfe-ret IN FRAME f-main
DO:
    DEFINE VARIABLE c-diretorio AS CHARACTER NO-UNDO.
    
    SYSTEM-DIALOG GET-DIR c-diretorio.
                  
    IF c-diretorio <> "" THEN
        ASSIGN prm-projeto-integrador.dir-nfe-ret:SCREEN-VALUE = c-diretorio.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-dir-nfe-venda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-dir-nfe-venda V-table-Win
ON CHOOSE OF bt-dir-nfe-venda IN FRAME f-main
DO:
    DEFINE VARIABLE c-diretorio AS CHARACTER NO-UNDO.
    
    SYSTEM-DIALOG GET-DIR c-diretorio.
                  
    IF c-diretorio <> "" THEN
        ASSIGN prm-projeto-integrador.dir-nfe-venda:SCREEN-VALUE = c-diretorio.
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
  {src/adm/template/row-list.i "prm-projeto-integrador"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "prm-projeto-integrador"}

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
    
    ASSIGN bt-dir-nfe-venda:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
           bt-dir-nfe-canc :SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
           bt-dir-nfe-rem  :SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
           bt-dir-nfe-ret  :SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
           bt-dir-nfe-devol:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
           bt-dir-cte      :SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
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
    
    ASSIGN bt-dir-nfe-venda:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE
           bt-dir-nfe-canc :SENSITIVE IN FRAME {&FRAME-NAME} = TRUE
           bt-dir-nfe-rem  :SENSITIVE IN FRAME {&FRAME-NAME} = TRUE
           bt-dir-nfe-ret  :SENSITIVE IN FRAME {&FRAME-NAME} = TRUE
           bt-dir-nfe-devol:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE
           bt-dir-cte      :SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN bt-dir-nfe-venda:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
           bt-dir-nfe-canc :SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
           bt-dir-nfe-rem  :SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
           bt-dir-nfe-ret  :SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
           bt-dir-nfe-devol:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
           bt-dir-cte      :SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
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
  {src/adm/template/snd-list.i "prm-projeto-integrador"}

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

