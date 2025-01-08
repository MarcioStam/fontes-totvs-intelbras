&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgscopel         PROGRESS
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
DEFINE VARIABLE numLotes            AS INTEGER     NO-UNDO.

DEFINE VARIABLE h_escqp015-b01 AS HANDLE      NO-UNDO.

DEFINE TEMP-TABLE tt-int-item-fornec-skip-lote LIKE int-item-fornec-skip-lote.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main
&Scoped-define BROWSE-NAME BROWSE-2

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES int-item-fornec
&Scoped-define FIRST-EXTERNAL-TABLE int-item-fornec


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR int-item-fornec.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-item-fornec-skip-lote

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tt-int-item-fornec-skip-lote.sequencia tt-int-item-fornec-skip-lote.log-analisa-lote   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2   
&Scoped-define SELF-NAME BROWSE-2
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tt-int-item-fornec-skip-lote NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY {&SELF-NAME} FOR EACH tt-int-item-fornec-skip-lote NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tt-int-item-fornec-skip-lote
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tt-int-item-fornec-skip-lote


/* Definitions for FRAME f-main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS int-item-fornec.it-codigo ~
int-item-fornec.num-lotes 
&Scoped-define ENABLED-TABLES int-item-fornec
&Scoped-define FIRST-ENABLED-TABLE int-item-fornec
&Scoped-Define ENABLED-OBJECTS rt-key BROWSE-2 
&Scoped-Define DISPLAYED-FIELDS int-item-fornec.it-codigo ~
int-item-fornec.num-lotes int-item-fornec.ultimo-skip-lote 
&Scoped-define DISPLAYED-TABLES int-item-fornec
&Scoped-define FIRST-DISPLAYED-TABLE int-item-fornec
&Scoped-Define DISPLAYED-OBJECTS descItem 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS int-item-fornec.it-codigo 

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
DEFINE VARIABLE descItem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .79 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tt-int-item-fornec-skip-lote SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 V-table-Win _FREEFORM
  QUERY BROWSE-2 DISPLAY
      tt-int-item-fornec-skip-lote.sequencia COLUMN-LABEL "Num.Skip Lote" FORMAT ">>>9":U
            WIDTH 10
      tt-int-item-fornec-skip-lote.log-analisa-lote FORMAT "Sim/NÆo":U
            WIDTH 14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88 BY 11.75
         TITLE "Sequˆncia Valida‡Æo Skip Lote".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     int-item-fornec.it-codigo AT ROW 1.25 COL 24 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 14 BY .79
     descItem AT ROW 1.25 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     int-item-fornec.num-lotes AT ROW 2.25 COL 24 COLON-ALIGNED WIDGET-ID 16
          LABEL "Quantidade Lotes"
          VIEW-AS FILL-IN 
          SIZE 14 BY .79
     int-item-fornec.ultimo-skip-lote AT ROW 2.25 COL 79 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     BROWSE-2 AT ROW 3.5 COL 2 WIDGET-ID 200
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgscopel.int-item-fornec
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
         HEIGHT             = 14.88
         WIDTH              = 89.43.
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
/* BROWSE-TAB BROWSE-2 ultimo-skip-lote f-main */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN descItem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int-item-fornec.it-codigo IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN int-item-fornec.num-lotes IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN int-item-fornec.ultimo-skip-lote IN FRAME f-main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-int-item-fornec-skip-lote NO-LOCK
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-2 IN FRAME f-main /* Sequˆncia Valida‡Æo Skip Lote */
DO:
    IF int-item-fornec.num-lotes:SENSITIVE
    AND AVAIL tt-int-item-fornec-skip-lote
    THEN DO:
        ASSIGN  tt-int-item-fornec-skip-lote.log-analisa-lote = NOT tt-int-item-fornec-skip-lote.log-analisa-lote
                tt-int-item-fornec-skip-lote.log-analisa-lote:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(tt-int-item-fornec-skip-lote.log-analisa-lote).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int-item-fornec.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-item-fornec.it-codigo V-table-Win
ON F5 OF int-item-fornec.it-codigo IN FRAME f-main /* Item */
DO:
   {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                      &campo=int-item-fornec.it-codigo
                      &campozoom=it-codigo
                      &campo2=descItem  
                      &campozoom2=desc-item} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-item-fornec.it-codigo V-table-Win
ON LEAVE OF int-item-fornec.it-codigo IN FRAME f-main /* Item */
DO:
    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=descItem
                     &where="item.it-codigo = input frame {&frame-name} int-item-fornec.it-codigo"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-item-fornec.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int-item-fornec.it-codigo IN FRAME f-main /* Item */
DO:
     apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int-item-fornec.num-lotes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-item-fornec.num-lotes V-table-Win
ON LEAVE OF int-item-fornec.num-lotes IN FRAME f-main /* Quantidade Lotes */
DO:
    DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
    DO iCont = 1 TO INPUT FRAME {&FRAME-NAME} int-item-fornec.num-lotes:
        IF NOT CAN-FIND(FIRST tt-int-item-fornec-skip-lote
                        WHERE tt-int-item-fornec-skip-lote.it-codigo       = INPUT FRAME {&FRAME-NAME} int-item-fornec.it-codigo
                          AND tt-int-item-fornec-skip-lote.sequencia       = iCont)
        THEN DO:
            CREATE  tt-int-item-fornec-skip-lote.
            ASSIGN  tt-int-item-fornec-skip-lote.it-codigo         = INPUT FRAME {&FRAME-NAME} int-item-fornec.it-codigo
                    tt-int-item-fornec-skip-lote.sequencia         = iCont
                    tt-int-item-fornec-skip-lote.log-analisa-lote  = YES.
        END.
    END.
    FOR  EACH tt-int-item-fornec-skip-lote
        WHERE tt-int-item-fornec-skip-lote.it-codigo       = INPUT FRAME {&FRAME-NAME} int-item-fornec.it-codigo   
          AND tt-int-item-fornec-skip-lote.sequencia       > INPUT FRAME {&FRAME-NAME} int-item-fornec.num-lotes:
        DELETE tt-int-item-fornec-skip-lote.
    END.

    {&OPEN-QUERY-{&BROWSE-NAME}}
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

if int-item-fornec.it-codigo:load-mouse-pointer("image/lupa.cur")    then.

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
  {src/adm/template/row-list.i "int-item-fornec"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "int-item-fornec"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  EMPTY TEMP-TABLE tt-int-item-fornec-skip-lote.
  {&OPEN-QUERY-{&BROWSE-NAME}}

  /* Code placed here will execute AFTER standard behavior.    */

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
    
    APPLY "leave" TO int-item-fornec.num-lotes IN FRAME {&FRAME-NAME} .

    IF  NOT CAN-FIND(FIRST ITEM
                     WHERE ITEM.it-codigo = int-item-fornec.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME})
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 56,
                           INPUT "Item").
        RETURN "ADM-ERROR".
    END.
    IF  adm-new-record
    AND CAN-FIND(FIRST int-item-fornec
                 WHERE int-item-fornec.it-codigo = int-item-fornec.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                   AND int-item-fornec.cod-emitente = 0)
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 1,
                           INPUT "int-Item-Fornec").
        RETURN "ADM-ERROR".
    END.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

    IF adm-new-record THEN DO:
        ASSIGN int-item-fornec.cod-emitente = 0.
    END.

    FOR EACH int-item-fornec-skip-lote
        WHERE int-item-fornec-skip-lote.it-codigo       = INPUT FRAME {&FRAME-NAME} int-item-fornec.it-codigo
          AND int-item-fornec-skip-lote.cod-emitente    = 0.
        DELETE int-item-fornec-skip-lote.
    END.

    FOR EACH tt-int-item-fornec-skip-lote:
        CREATE int-item-fornec-skip-lote.
        BUFFER-COPY tt-int-item-fornec-skip-lote TO int-item-fornec-skip-lote
            ASSIGN int-item-fornec-skip-lote.cod-emitente = 0.

    END.

    {&OPEN-QUERY-{&BROWSE-NAME}}

    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
    
    FOR EACH int-item-fornec-skip-lote
        WHERE int-item-fornec-skip-lote.it-codigo = int-item-fornec.it-codigo:SCREEN-VALUE   IN FRAME {&FRAME-NAME}:
        DELETE int-item-fornec-skip-lote.
    END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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

    IF AVAIL int-item-fornec
    THEN DO:
        ASSIGN numLotes = int-item-fornec.num-lotes.
        APPLY "leave" TO int-item-fornec.it-codigo      IN FRAME {&FRAME-NAME}.

        IF NOT adm-new-record
        THEN DO:
            EMPTY TEMP-TABLE tt-int-item-fornec-skip-lote.
            FOR  EACH int-item-fornec-skip-lote NO-LOCK 
                WHERE int-item-fornec-skip-lote.it-codigo = int-item-fornec.it-codigo
                  AND int-item-fornec-skip-lote.cod-emitente = 0.
                
                CREATE tt-int-item-fornec-skip-lote.
                BUFFER-COPY int-item-fornec-skip-lote TO tt-int-item-fornec-skip-lote.
            END.
            {&OPEN-QUERY-{&BROWSE-NAME}}
        END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRecebeHandle V-table-Win 
PROCEDURE piRecebeHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p_escqp015-b01   AS HANDLE   NO-UNDO.

ASSIGN h_escqp015-b01 = p_escqp015-b01.

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
  {src/adm/template/snd-list.i "int-item-fornec"}
  {src/adm/template/snd-list.i "tt-int-item-fornec-skip-lote"}

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

