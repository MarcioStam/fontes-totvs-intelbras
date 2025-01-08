&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
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
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
DEFINE VARIABLE hProgramZoom AS HANDLE      NO-UNDO.
{utp/ut-glob.i}

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
&Scoped-define EXTERNAL-TABLES int-simula-dev
&Scoped-define FIRST-EXTERNAL-TABLE int-simula-dev


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR int-simula-dev.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS int-simula-dev.id-tipo-nota ~
int-simula-dev.nr-sequencia int-simula-dev.cod-usuario ~
int-simula-dev.log-email int-simula-dev.email int-simula-dev.narrativa 
&Scoped-define ENABLED-TABLES int-simula-dev
&Scoped-define FIRST-ENABLED-TABLE int-simula-dev
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold RECT-1 
&Scoped-Define DISPLAYED-FIELDS int-simula-dev.cod-emitente ~
int-simula-dev.id-tipo-nota int-simula-dev.dt-simula ~
int-simula-dev.nr-sequencia int-simula-dev.cod-usuario ~
int-simula-dev.cod-estabel int-simula-dev.nome-transp ~
int-simula-dev.frete-cif int-simula-dev.log-email int-simula-dev.email ~
int-simula-dev.narrativa 
&Scoped-define DISPLAYED-TABLES int-simula-dev
&Scoped-define FIRST-DISPLAYED-TABLE int-simula-dev
&Scoped-Define DISPLAYED-OBJECTS c-desc-cliente c-desc-estab c-desc-transp 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS int-simula-dev.cod-emitente ~
int-simula-dev.dt-simula int-simula-dev.cod-estabel ~
int-simula-dev.nome-transp int-simula-dev.frete-cif 

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
DEFINE VARIABLE c-desc-cliente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-transp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 19 BY 2.96.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 5.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 7.17.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     int-simula-dev.cod-emitente AT ROW 1.25 COL 17 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-desc-cliente AT ROW 1.25 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     int-simula-dev.id-tipo-nota AT ROW 1.75 COL 71 NO-LABEL WIDGET-ID 24
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Gera Duplic", 1,
"N∆o Gera Duplic", 2,
"Ambos", 3
          SIZE 16 BY 2.25
     int-simula-dev.dt-simula AT ROW 2.25 COL 17 COLON-ALIGNED WIDGET-ID 6
          LABEL "Data Simulaá∆o"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int-simula-dev.nr-sequencia AT ROW 2.25 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     int-simula-dev.cod-usuario AT ROW 2.25 COL 46 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     int-simula-dev.cod-estabel AT ROW 3.25 COL 17 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-desc-estab AT ROW 3.25 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     int-simula-dev.nome-transp AT ROW 4.25 COL 17 COLON-ALIGNED WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     c-desc-transp AT ROW 4.25 COL 25.86 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     int-simula-dev.frete-cif AT ROW 4.25 COL 71 WIDGET-ID 48
          LABEL "Frete CIF"
          VIEW-AS TOGGLE-BOX
          SIZE 11.57 BY .83
     int-simula-dev.log-email AT ROW 5 COL 71 WIDGET-ID 20
          VIEW-AS TOGGLE-BOX
          SIZE 16 BY .83
     int-simula-dev.email AT ROW 5.25 COL 17 COLON-ALIGNED WIDGET-ID 22
          LABEL "E-mail"
          VIEW-AS FILL-IN 
          SIZE 43 BY .88
     int-simula-dev.narrativa AT ROW 7.25 COL 3 NO-LABEL WIDGET-ID 36
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 85 BY 6.33
     "Observaá‰es:" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 6.58 COL 2 WIDGET-ID 38
     "Tipo NFe:" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 1.08 COL 70 WIDGET-ID 30
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 6.75 COL 1
     RECT-1 AT ROW 1.29 COL 69 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 7 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: emsint.int-simula-dev
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
         HEIGHT             = 13
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-cliente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-transp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int-simula-dev.cod-emitente IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN int-simula-dev.cod-estabel IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN int-simula-dev.dt-simula IN FRAME f-main
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN int-simula-dev.email IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX int-simula-dev.frete-cif IN FRAME f-main
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN int-simula-dev.nome-transp IN FRAME f-main
   NO-ENABLE 1                                                          */
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

&Scoped-define SELF-NAME int-simula-dev.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-simula-dev.cod-emitente V-table-Win
ON F5 OF int-simula-dev.cod-emitente IN FRAME f-main /* Cliente */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z02ad098.w"
                       &campo="int-simula-dev.cod-emitente"
                       &campozoom="cod-emitente"
                       &frame="f-main"
                       &campo2="c-desc-cliente"
                       &campozoom2="nome-emit"
                       &frame2="f-main"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-simula-dev.cod-emitente V-table-Win
ON LEAVE OF int-simula-dev.cod-emitente IN FRAME f-main /* Cliente */
DO:
  FIND FIRST emitente NO-LOCK
       WHERE emitente.cod-emitente = INPUT FRAME f-main int-simula-dev.cod-emitente NO-ERROR.

  IF AVAIL emitente THEN
      ASSIGN c-desc-cliente:SCREEN-VALUE IN FRAME f-main = emitente.nome-emit
             int-simula-dev.email:SCREEN-VALUE IN FRAME f-main = IF int-simula-dev.cod-emitente:SENSITIVE IN FRAME f-main THEN emitente.e-mail ELSE int-simula-dev.email:SCREEN-VALUE IN FRAME f-main.
  ELSE 
      ASSIGN c-desc-cliente:SCREEN-VALUE IN FRAME f-main = ""
             int-simula-dev.email:SCREEN-VALUE IN FRAME f-main = "".

  IF int-simula-dev.dt-simula:SENSITIVE IN FRAME f-main THEN
      ASSIGN int-simula-dev.dt-simula:SCREEN-VALUE IN FRAME f-main = STRING(TODAY).
    
  IF int-simula-dev.cod-usuario:SCREEN-VALUE IN FRAME f-main = "" THEN
      ASSIGN int-simula-dev.cod-usuario:SCREEN-VALUE IN FRAME f-main = c-seg-usuario.

  RUN pi-sugere-seq.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-simula-dev.cod-emitente V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int-simula-dev.cod-emitente IN FRAME f-main /* Cliente */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int-simula-dev.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-simula-dev.cod-estabel V-table-Win
ON F5 OF int-simula-dev.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
    {method/ZoomFields.i &ProgramZoom="adzoom/z12ad107.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="int-simula-dev.cod-estabel"
                         &Frame1="f-main"
                         &FieldZoom2="nome"
                         &FieldScreen2="c-desc-estab"
                         &Frame2="f-main"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-simula-dev.cod-estabel V-table-Win
ON LEAVE OF int-simula-dev.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = INPUT FRAME f-main int-simula-dev.cod-estabel NO-ERROR.

    IF AVAIL estabelec THEN
        ASSIGN c-desc-estab:SCREEN-VALUE IN FRAME f-main = estabelec.nome.
    ELSE 
        ASSIGN c-desc-estab:SCREEN-VALUE IN FRAME f-main = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-simula-dev.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int-simula-dev.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
     APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int-simula-dev.dt-simula
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-simula-dev.dt-simula V-table-Win
ON LEAVE OF int-simula-dev.dt-simula IN FRAME f-main /* Data Simulaá∆o */
DO:
  RUN pi-sugere-seq.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int-simula-dev.nome-transp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-simula-dev.nome-transp V-table-Win
ON F5 OF int-simula-dev.nome-transp IN FRAME f-main /* Transportadora */
DO:
    {method/zoomfields.i &ProgramZoom="adzoom/z02ad268.w"
                         &FieldZoom1="nome-abrev"
                         &FieldScreen1="int-simula-dev.nome-transp"
                         &Frame1="f-main"
                         &FieldZoom2="nome"
                         &FieldScreen2="c-desc-transp"
                         &Frame2="f-main"
                         &enableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-simula-dev.nome-transp V-table-Win
ON LEAVE OF int-simula-dev.nome-transp IN FRAME f-main /* Transportadora */
DO:
   FIND FIRST transporte NO-LOCK
        WHERE transporte.nome-abrev = INPUT FRAME f-main int-simula-dev.nome-transp NO-ERROR.

   IF AVAIL transporte THEN DO:
       ASSIGN c-desc-transp:SCREEN-VALUE IN FRAME f-main = transporte.nome.
   END.
   ELSE DO:
       ASSIGN c-desc-transp:SCREEN-VALUE IN FRAME f-main = "".
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-simula-dev.nome-transp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int-simula-dev.nome-transp IN FRAME f-main /* Transportadora */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF      
     
  if int-simula-dev.cod-emitente:load-mouse-pointer ("image/lupa.cur") then.
  if int-simula-dev.cod-estabel:load-mouse-pointer ("image/lupa.cur") then.
  if int-simula-dev.nome-transp:load-mouse-pointer ("image/lupa.cur") then.

  

  
  
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
  {src/adm/template/row-list.i "int-simula-dev"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "int-simula-dev"}

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
    
    /*:T Ponha na pi-validate todas as validaá‰es */
    /*:T N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    RUN pi-validate.
    IF RETURN-VALUE <> "OK" THEN
        return 'ADM-ERROR':U.
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /*:T Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
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
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    APPLY "leave" TO int-simula-dev.cod-emitente IN FRAME f-main.
    APPLY "leave" TO int-simula-dev.cod-estabel  IN FRAME f-main.
    APPLY "leave" TO int-simula-dev.nome-transp  IN FRAME f-main.
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

    ASSIGN int-simula-dev.nr-sequencia:SENSITIVE IN FRAME f-main = NO
           int-simula-dev.cod-usuario:SENSITIVE IN FRAME f-main = NO
           int-simula-dev.log-email:SENSITIVE IN FRAME f-main = NO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-sugere-seq V-table-Win 
PROCEDURE pi-sugere-seq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF adm-new-record THEN DO:
          FIND LAST int-simula-dev NO-LOCK
              WHERE int-simula-dev.cod-emitente = INPUT FRAME f-main int-simula-dev.cod-emitente 
                AND int-simula-dev.dt-simula    = INPUT FRAME f-main int-simula-dev.dt-simula  NO-ERROR.
          
          IF AVAIL int-simula-dev THEN
              ASSIGN int-simula-dev.nr-sequencia:SCREEN-VALUE IN FRAME f-main = STRING(int-simula-dev.nr-sequencia + 1).
          ELSE 
              ASSIGN int-simula-dev.nr-sequencia:SCREEN-VALUE IN FRAME f-main = "1".
      END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Validaá∆o de dicion†rio */

    IF NOT CAN-FIND (FIRST emitente
                     WHERE emitente.cod-emitente = INPUT FRAME f-main int-simula-dev.cod-emitente) THEN DO:

        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17006, 
                           INPUT "Cliente informado n∆o est† cadastrado.").
        RETURN 'ADM-ERROR':U.                                          
    END.                                                               

    IF NOT CAN-FIND (FIRST estabelec
                     WHERE estabelec.cod-estabel = INPUT FRAME f-main int-simula-dev.cod-estabel) THEN DO:

        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17006, 
                           INPUT "Estabelecimento informado n∆o est† cadastrado.").
        RETURN 'ADM-ERROR':U.                                          
    END.
    
    IF adm-new-record THEN DO:
        IF INPUT FRAME f-main int-simula-dev.dt-simula < TODAY THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17006, 
                               INPUT "N∆o Ç permitido simulaá∆o com data retroativa.").
            RETURN 'ADM-ERROR':U.                                          
        END.
    END.

/*:T    Segue um exemplo de validaá∆o de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */

    RETURN "OK".
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
  {src/adm/template/snd-list.i "int-simula-dev"}

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

