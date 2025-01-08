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

DEF BUFFER b-int-segmento-item FOR int-segmento-item.

DEF VAR l-error AS LOG NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES int-segmento-item
&Scoped-define FIRST-EXTERNAL-TABLE int-segmento-item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR int-segmento-item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS int-segmento-item.cod-segmento ~
int-segmento-item.dt-valid-fim 
&Scoped-define ENABLED-TABLES int-segmento-item
&Scoped-define FIRST-ENABLED-TABLE int-segmento-item
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS int-segmento-item.cod-gr-cli ~
int-segmento-item.cod-segmento int-segmento-item.dt-valid-ini ~
int-segmento-item.dt-valid-fim 
&Scoped-define DISPLAYED-TABLES int-segmento-item
&Scoped-define FIRST-DISPLAYED-TABLE int-segmento-item
&Scoped-Define DISPLAYED-OBJECTS fi-grupo fi-segmento 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS int-segmento-item.cod-gr-cli ~
int-segmento-item.dt-valid-ini 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
cod-segmento||y|TMGESP.int-segmento-item.cod-segmento
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "cod-segmento"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE fi-grupo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE fi-segmento AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 74 BY 5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     int-segmento-item.cod-gr-cli AT ROW 1.5 COL 17.43 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-grupo AT ROW 1.5 COL 23.72 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     int-segmento-item.cod-segmento AT ROW 2.5 COL 15.43 COLON-ALIGNED NO-LABEL WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-segmento AT ROW 2.5 COL 23.72 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     int-segmento-item.dt-valid-ini AT ROW 3.5 COL 10.86 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     int-segmento-item.dt-valid-fim AT ROW 4.5 COL 10.86 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     "C¢d Segmentaá∆o:" VIEW-AS TEXT
          SIZE 13 BY .75 AT ROW 2.5 COL 2.57 WIDGET-ID 16
     rt-mold AT ROW 1.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: TMGESP.int-segmento-item
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
         HEIGHT             = 5.71
         WIDTH              = 74.86.
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

/* SETTINGS FOR FILL-IN int-segmento-item.cod-gr-cli IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN int-segmento-item.dt-valid-ini IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-grupo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-segmento IN FRAME f-main
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

&Scoped-define SELF-NAME int-segmento-item.cod-gr-cli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-segmento-item.cod-gr-cli V-table-Win
ON F5 OF int-segmento-item.cod-gr-cli IN FRAME f-main /* Gr Cliente */
DO:
    {include/zoomvar.i &prog-zoom= "adzoom/z01ad129.w"
                     &campo= int-segmento-item.cod-gr-cli
                     &campo2= fi-grupo
                     &campozoom= cod-gr-cli
                     &campozoom2= descricao} 
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-segmento-item.cod-gr-cli V-table-Win
ON LEAVE OF int-segmento-item.cod-gr-cli IN FRAME f-main /* Gr Cliente */
DO:
  FOR FIRST gr-cli FIELDS(cod-gr-cli descricao) NO-LOCK 
      WHERE gr-cli.cod-gr-cli = INPUT FRAME {&FRAME-NAME} int-segmento-item.cod-gr-cli:
  END.
  IF AVAIL gr-cli THEN
     ASSIGN fi-grupo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gr-cli.descricao.
  ELSE
     ASSIGN fi-grupo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "N∆o cadastrado".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-segmento-item.cod-gr-cli V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int-segmento-item.cod-gr-cli IN FRAME f-main /* Gr Cliente */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int-segmento-item.cod-segmento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-segmento-item.cod-segmento V-table-Win
ON F5 OF int-segmento-item.cod-segmento IN FRAME f-main /* Cod Segmento */
DO:
    {include/zoomvar.i  &prog-zoom  = eszoom/z01escdp115.w
                        &campo      = int-segmento-item.cod-segmento
                        &campo2     = fi-segmento
                        &campozoom  = cod-segmento
                        &campozoom2 = descricao}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-segmento-item.cod-segmento V-table-Win
ON LEAVE OF int-segmento-item.cod-segmento IN FRAME f-main /* Cod Segmento */
DO:
    FIND FIRST int-segmento-portifolio NO-LOCK 
         WHERE int-segmento-portifolio.cod-segmento = INPUT FRAME {&FRAME-NAME} int-segmento-item.cod-segmento NO-ERROR.
    IF AVAIL int-segmento-portifolio THEN
       ASSIGN fi-segmento:SCREEN-VALUE IN FRAME {&FRAME-NAME} = int-segmento-portifolio.descricao.
    ELSE
       ASSIGN fi-segmento:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "N∆o cadastrado!".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-segmento-item.cod-segmento V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int-segmento-item.cod-segmento IN FRAME f-main /* Cod Segmento */
DO:
  APPLY "F5" TO SELF.
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

    IF int-segmento-item.cod-gr-cli  :LOAD-MOUSE-POINTER ('image/lupa.cur') THEN
    IF int-segmento-item.cod-segmento:LOAD-MOUSE-POINTER ('image/lupa.cur') THEN

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
  {src/adm/template/row-list.i "int-segmento-item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "int-segmento-item"}

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
    RUN PI-validate.
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    FIND ITEM NO-LOCK WHERE ROWID(ITEM) = v-row-parent NO-ERROR.
    IF AVAIL ITEM THEN
       ASSIGN int-segmento-item.it-codigo = ITEM.it-codigo.

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

 IF AVAIL int-segmento-item THEN DO:
     APPLY "LEAVE" TO int-segmento-item.cod-gr-cli       IN FRAME {&FRAME-NAME}.
     APPLY "LEAVE" TO int-segmento-item.cod-segmento     IN FRAME {&FRAME-NAME}.
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
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Validaá∆o de dicion†rio */
    
/*:T    Segue um exemplo de validaá∆o de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */


    FIND ITEM NO-LOCK WHERE ROWID(ITEM) = v-row-parent NO-ERROR.
    /*
    FIND FIRST b-int-segmento-item NO-LOCK 
         WHERE b-int-segmento-item.it-codigo    = ITEM.it-codigo 
           AND b-int-segmento-item.cod-gr-cli   = INPUT FRAME {&FRAME-NAME} int-segmento-item.cod-gr-cli NO-ERROR. 
    
    IF NOT AVAIL b-int-segmento-item THEN 
       FIND FIRST b-int-segmento-item NO-LOCK 
            WHERE b-int-segmento-item.it-codigo    = ITEM.it-codigo 
              AND b-int-segmento-item.cod-segmento = INPUT FRAME {&FRAME-NAME} int-segmento-item.cod-segmento NO-ERROR. 

    IF AVAIL b-int-segmento-item THEN DO:
    */
    ASSIGN l-error = NO.
    FOR EACH b-int-segmento-item
        WHERE b-int-segmento-item.it-codigo    = ITEM.it-codigo:


       IF b-int-segmento-item.dt-valid-fim = ? AND 
          b-int-segmento-item.dt-valid-ini <= TODAY THEN
          ASSIGN l-error = YES.
      
       ELSE DO:
            
            IF ( b-int-segmento-item.dt-valid-fim = ?
                OR b-int-segmento-item.dt-valid-fim >= INPUT FRAME {&FRAME-NAME} int-segmento-item.dt-valid-ini) THEN DO:
                ASSIGN l-error = YES.

            END.
            
            IF b-int-segmento-item.dt-valid-ini >= INPUT FRAME {&FRAME-NAME} int-segmento-item.dt-valid-ini  THEN 
               ASSIGN l-error = YES.

            IF b-int-segmento-item.dt-valid-fim >= INPUT FRAME {&FRAME-NAME} int-segmento-item.dt-valid-ini  THEN 
               ASSIGN l-error = YES.
       END.

    END.
    IF l-error THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Registro j† cadastrado!~~J† existe um registro cadastrado com a chave informada.").

        APPLY  "entry" TO int-segmento-item.cod-gr-cli IN FRAME {&FRAME-NAME}.
        RETURN 'ADM-ERROR':U.

    END.


IF NOT CAN-FIND(FIRST gr-cli 
                WHERE gr-cli.cod-gr-cli = INPUT FRAME {&FRAME-NAME} int-segmento-item.cod-gr-cli) THEN DO:

    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 17006,
                       INPUT "Grupo de Cliente n∆o cadastrado!~~Grupo de cliente informado n∆o cadastrado.").

    APPLY  "entry" TO int-segmento-item.cod-gr-cli IN FRAME {&FRAME-NAME}.
    RETURN 'ADM-ERROR':U.

END.
IF NOT CAN-FIND(FIRST int-segmento-portifolio 
                WHERE int-segmento-portifolio.cod-segmento = INPUT FRAME {&FRAME-NAME} int-segmento-item.cod-segmento) THEN DO:

    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 17006,
                       INPUT "Segmento n∆o cadastrado!~~Segmento informado n∆o cadastrado.").

    APPLY  "entry" TO int-segmento-item.cod-segmento IN FRAME {&FRAME-NAME}.
    RETURN 'ADM-ERROR':U.

END.
IF INPUT FRAME {&FRAME-NAME} int-segmento-item.dt-valid-ini = ? THEN DO:


    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 17006,
                       INPUT "Data inicio invalida!~~Data inicio deve ser informada.").

    APPLY  "entry" TO int-segmento-item.dt-valid-ini IN FRAME {&FRAME-NAME}.
    RETURN 'ADM-ERROR':U.

END.

IF INPUT FRAME {&FRAME-NAME} int-segmento-item.dt-valid-fim <> ? THEN DO:

   IF INPUT FRAME {&FRAME-NAME} int-segmento-item.dt-valid-fim < INPUT FRAME {&FRAME-NAME} int-segmento-item.dt-valid-ini THEN DO:
       RUN utp/ut-msgs.p (INPUT "show",
                          INPUT 17006,
                          INPUT "Data Fim invalida!~~Data fim deve ser amior que data inicio.").

       APPLY  "entry" TO int-segmento-item.dt-valid-fim IN FRAME {&FRAME-NAME}.
       RETURN 'ADM-ERROR':U.
   END.
END.


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

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "cod-segmento" "int-segmento-item" "cod-segmento"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "int-segmento-item"}

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

