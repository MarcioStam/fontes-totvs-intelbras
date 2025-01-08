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
&Scoped-define EXTERNAL-TABLES int-param-comis
&Scoped-define FIRST-EXTERNAL-TABLE int-param-comis


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR int-param-comis.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS int-param-comis.perc-ating-meta-bonusmix ~
int-param-comis.log-considera-devolucao ~
int-param-comis.log-considera-carteira int-param-comis.dia-carteira ~
int-param-comis.log-considera-inadimp ~
int-param-comis.perc-meta-segmento-tri ~
int-param-comis.perc-excede-rollout-tri int-param-comis.validade-rollout ~
int-param-comis.observacoes 
&Scoped-define ENABLED-TABLES int-param-comis
&Scoped-define FIRST-ENABLED-TABLE int-param-comis
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold RECT-1 
&Scoped-Define DISPLAYED-FIELDS int-param-comis.periodo-mes ~
int-param-comis.periodo-ano int-param-comis.dt-periodo-ini ~
int-param-comis.dt-periodo-fim int-param-comis.idi-status ~
int-param-comis.perc-ating-meta-bonusmix ~
int-param-comis.log-considera-devolucao ~
int-param-comis.log-considera-carteira int-param-comis.dia-carteira ~
int-param-comis.log-considera-inadimp int-param-comis.vl-bonus-tri[1] ~
int-param-comis.vl-bonus-tri[2] int-param-comis.perc-meta-segmento-tri ~
int-param-comis.perc-excede-rollout-tri int-param-comis.validade-rollout ~
int-param-comis.observacoes 
&Scoped-define DISPLAYED-TABLES int-param-comis
&Scoped-define FIRST-DISPLAYED-TABLE int-param-comis


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS int-param-comis.periodo-mes ~
int-param-comis.periodo-ano int-param-comis.dt-periodo-ini ~
int-param-comis.dt-periodo-fim int-param-comis.perc-ating-meta-bonusmix ~
int-param-comis.dia-carteira 

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
DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 5.5.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 2.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 16.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     int-param-comis.periodo-mes AT ROW 1.25 COL 25.14 COLON-ALIGNED WIDGET-ID 48
          LABEL "Per°odo"
          VIEW-AS FILL-IN 
          SIZE 2.86 BY .88
     int-param-comis.periodo-ano AT ROW 1.25 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 52
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     int-param-comis.dt-periodo-ini AT ROW 2.25 COL 25.14 COLON-ALIGNED WIDGET-ID 6
          LABEL "Datas"
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     int-param-comis.dt-periodo-fim AT ROW 2.25 COL 38.14 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     int-param-comis.idi-status AT ROW 4 COL 25 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Iniciada",1,
                     "Calculada",2,
                     "Integrada com o Senior",3
          DROP-DOWN-LIST
          SIZE 26 BY 1
     int-param-comis.perc-ating-meta-bonusmix AT ROW 5 COL 25 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     int-param-comis.log-considera-devolucao AT ROW 6.25 COL 27 WIDGET-ID 40
          LABEL "Considera Devoluá‰es de Clientes"
          VIEW-AS TOGGLE-BOX
          SIZE 26 BY .83
     int-param-comis.log-considera-carteira AT ROW 7.25 COL 27 WIDGET-ID 38
          LABEL "Considera Carteira de Clientes atÇ dia"
          VIEW-AS TOGGLE-BOX
          SIZE 28 BY .83
     int-param-comis.dia-carteira AT ROW 7.25 COL 53.57 COLON-ALIGNED NO-LABEL WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     int-param-comis.log-considera-inadimp AT ROW 8.25 COL 27 WIDGET-ID 42
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .83
     int-param-comis.vl-bonus-tri[1] AT ROW 10 COL 31 COLON-ALIGNED WIDGET-ID 26
          LABEL "Teto M†x. Bìnus Superaá∆o Executivo"
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     int-param-comis.vl-bonus-tri[2] AT ROW 11 COL 31 COLON-ALIGNED WIDGET-ID 28
          LABEL "Teto M†x. Bìnus Superaá∆o Supervisor"
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     int-param-comis.perc-meta-segmento-tri AT ROW 12 COL 31 COLON-ALIGNED WIDGET-ID 20
          LABEL "% Ating. meta por Segmento"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     int-param-comis.perc-excede-rollout-tri AT ROW 13 COL 31 COLON-ALIGNED WIDGET-ID 18
          LABEL "% Excedente Fatur. para Rollout"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     int-param-comis.validade-rollout AT ROW 14 COL 31 COLON-ALIGNED WIDGET-ID 46
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Q1",01,
                     "Q2",02,
                     "Q3",03,
                     "Q4",04
          DROP-DOWN-LIST
          SIZE 16 BY 1
     int-param-comis.observacoes AT ROW 16.38 COL 12 NO-LABEL WIDGET-ID 34
          VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
          SIZE 76 BY 3.5
     "do màs subsequente" VIEW-AS TEXT
          SIZE 14 BY .54 AT ROW 7.38 COL 59.72 WIDGET-ID 44
     "/" VIEW-AS TEXT
          SIZE 1 BY .54 AT ROW 1.38 COL 30.14 WIDGET-ID 50
     "Fechamento Trimestral:" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 9.46 COL 2 WIDGET-ID 32
     "Observaá‰es:" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 16.29 COL 2 WIDGET-ID 36
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 7 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.75 COL 1
     RECT-1 AT ROW 9.75 COL 1.57 WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 7 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgesp.int-param-comis
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
         HEIGHT             = 19.46
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

/* SETTINGS FOR FILL-IN int-param-comis.dia-carteira IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN int-param-comis.dt-periodo-fim IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN int-param-comis.dt-periodo-ini IN FRAME f-main
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR COMBO-BOX int-param-comis.idi-status IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX int-param-comis.log-considera-carteira IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX int-param-comis.log-considera-devolucao IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN int-param-comis.perc-ating-meta-bonusmix IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN int-param-comis.perc-excede-rollout-tri IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN int-param-comis.perc-meta-segmento-tri IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN int-param-comis.periodo-ano IN FRAME f-main
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN int-param-comis.periodo-mes IN FRAME f-main
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN int-param-comis.vl-bonus-tri[1] IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN int-param-comis.vl-bonus-tri[2] IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
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

&Scoped-define SELF-NAME int-param-comis.periodo-mes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-param-comis.periodo-mes V-table-Win
ON LEAVE OF int-param-comis.periodo-mes IN FRAME f-main /* Per°odo */
DO:
  IF int(SELF:SCREEN-VALUE) MOD 3 = 0 
  AND int(SELF:SCREEN-VALUE) <> 0 THEN DO:
        ASSIGN int-param-comis.perc-excede-rollout-tri:sensitive in frame f-main = yes
               int-param-comis.perc-meta-segmento-tri :sensitive in frame f-main = yes
               int-param-comis.validade-rollout       :sensitive in frame f-main = yes.
    END.
    ELSE DO:
        ASSIGN int-param-comis.perc-excede-rollout-tri:sensitive in frame f-main = NO
               int-param-comis.perc-meta-segmento-tri :sensitive in frame f-main = NO
               int-param-comis.validade-rollout       :sensitive in frame f-main = NO.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "int-param-comis"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "int-param-comis"}

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

    IF adm-new-record THEN DO:
        FOR EACH int-exec-superv 
           WHERE int-exec-superv.dt-termino = ? 
             AND int-exec-superv.dt-inicio <= TODAY NO-LOCK
           BREAK BY int-exec-superv.cod-supervisor:

            FIND FIRST int-supervisor NO-LOCK
                 WHERE int-supervisor.cod-supervisor = int-exec-superv.cod-supervisor NO-ERROR.

            IF NOT AVAIL int-supervisor
            OR NOT int-supervisor.log-ativo THEN
                NEXT.

            FIND FIRST int-executivo NO-LOCK
                 WHERE int-executivo.cod-executivo = int-exec-superv.cod-executivo NO-ERROR.

            IF NOT AVAIL int-executivo
            OR NOT int-executivo.log-ativo THEN
                NEXT.
    
            CREATE int-execsuperv-calc.
            ASSIGN int-execsuperv-calc.cod-sup-exec = int-exec-superv.cod-executivo
                   int-execsuperv-calc.periodo-mes  = INPUT FRAME f-main int-param-comis.periodo-mes
                   int-execsuperv-calc.periodo-ano  = INPUT FRAME f-main int-param-comis.periodo-ano
                   int-execsuperv-calc.idi-tipo     = 1.
    
            IF LAST-OF (int-exec-superv.cod-supervisor) THEN DO:
                CREATE int-execsuperv-calc.
                ASSIGN int-execsuperv-calc.cod-sup-exec = int-exec-superv.cod-supervisor
                       int-execsuperv-calc.periodo-mes  = INPUT FRAME f-main int-param-comis.periodo-mes
                       int-execsuperv-calc.periodo-ano  = INPUT FRAME f-main int-param-comis.periodo-ano
                       int-execsuperv-calc.idi-tipo     = 2.
            END.
    
        END.
    END.
    
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

    APPLY "leave" TO int-param-comis.periodo-mes IN FRAME f-main.
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
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Validaá∆o de dicion†rio */

    DEFINE VARIABLE c-mes AS CHARACTER   NO-UNDO.

    IF INPUT FRAME f-main int-param-comis.periodo-mes > 12 THEN DO:
        RUN utp/ut-msgs.p (INPUT "Show",
                           INPUT 17006,
                           INPUT "Màs n∆o pode ser maior que 12.").

        RETURN 'ADM-ERROR':U.
    END.

    IF INPUT FRAME f-main int-param-comis.periodo-mes = 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "Show",
                           INPUT 17006,
                           INPUT "Màs n∆o pode ser 0.").

        RETURN 'ADM-ERROR':U.
    END.

    IF INPUT FRAME f-main int-param-comis.periodo-ano < YEAR(TODAY)  THEN DO:
        RUN utp/ut-msgs.p (INPUT "Show",
                           INPUT 17006,
                           INPUT "Ano n∆o pode ser menor que o atual.").

        RETURN 'ADM-ERROR':U.
    END.

    IF INPUT FRAME f-main int-param-comis.dt-periodo-ini > INPUT FRAME f-main int-param-comis.dt-periodo-fim THEN DO:
        RUN utp/ut-msgs.p (INPUT "Show",
                           INPUT 17006,
                           INPUT "Data inicial n∆o pode ser maior que final.").

        RETURN 'ADM-ERROR':U.
    END.

    IF INPUT FRAME f-main int-param-comis.perc-meta-segmento-tri > 100 THEN DO:
        RUN utp/ut-msgs.p (INPUT "Show",
                           INPUT 17006,
                           INPUT "% Atingimento de meta n∆o pode ser superior a 100%.").

        RETURN 'ADM-ERROR':U.
    END.

    ASSIGN c-mes = string(INPUT FRAME f-main int-param-comis.periodo-mes + 2).

    IF c-mes = "13" THEN
        ASSIGN c-mes = "01".

    IF c-mes = "14" THEN
        ASSIGN c-mes = "02".

    IF INPUT FRAME f-main int-param-comis.dia-carteira > DAY(DATE("01/" + c-mes + "/" + STRING(YEAR(TODAY))) - 1)  THEN DO:
        RUN utp/ut-msgs.p (INPUT "Show",
                           INPUT 17006,
                           INPUT "Dia do Màs Carteira n∆o pode ser maior que o n£mero de dias do màs.").

        RETURN 'ADM-ERROR':U.
    END.

    IF adm-new-record THEN DO:
        IF CAN-FIND (FIRST int-param-comis
                     WHERE int-param-comis.periodo-mes = INPUT FRAME f-main int-param-comis.periodo-mes
                       AND int-param-comis.periodo-ano = INPUT FRAME f-main int-param-comis.periodo-ano) THEN DO:

            RUN utp/ut-msgs.p (INPUT "Show",
                               INPUT 17006,
                               INPUT "ParÉmetros j† cadastrados para o per°odo.").

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "int-param-comis"}

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

