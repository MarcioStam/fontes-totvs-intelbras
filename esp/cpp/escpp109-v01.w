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
&Scoped-define EXTERNAL-TABLES int-param-ord-prod-monitor
&Scoped-define FIRST-EXTERNAL-TABLE int-param-ord-prod-monitor


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR int-param-ord-prod-monitor.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS int-param-ord-prod-monitor.cod-estabel ~
int-param-ord-prod-monitor.cod-emitente ~
int-param-ord-prod-monitor.cod-unid-negoc ~
int-param-ord-prod-monitor.nat-operacao-retorno ~
int-param-ord-prod-monitor.nat-operacao-servico ~
int-param-ord-prod-monitor.ct-codigo int-param-ord-prod-monitor.sc-codigo ~
int-param-ord-prod-monitor.cod-depos-ordem-compra ~
int-param-ord-prod-monitor.cod-depos-nf-servico ~
int-param-ord-prod-monitor.cod-depos-nf-retorno ~
int-param-ord-prod-monitor.cod-depos-reporte-prod 
&Scoped-define ENABLED-TABLES int-param-ord-prod-monitor
&Scoped-define FIRST-ENABLED-TABLE int-param-ord-prod-monitor
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS int-param-ord-prod-monitor.cod-estabel ~
int-param-ord-prod-monitor.cod-emitente ~
int-param-ord-prod-monitor.cod-unid-negoc ~
int-param-ord-prod-monitor.nat-operacao-retorno ~
int-param-ord-prod-monitor.nat-operacao-servico ~
int-param-ord-prod-monitor.ct-codigo int-param-ord-prod-monitor.sc-codigo ~
int-param-ord-prod-monitor.cod-depos-ordem-compra ~
int-param-ord-prod-monitor.cod-depos-nf-servico ~
int-param-ord-prod-monitor.cod-depos-nf-retorno ~
int-param-ord-prod-monitor.cod-depos-reporte-prod 
&Scoped-define DISPLAYED-TABLES int-param-ord-prod-monitor
&Scoped-define FIRST-DISPLAYED-TABLE int-param-ord-prod-monitor
&Scoped-Define DISPLAYED-OBJECTS c-nome-emit 

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
cod-estabel|y|y|mgesp.int-param-ord-prod-monitor.cod-estabel
cod-emitente||y|mgesp.int-param-ord-prod-monitor.cod-emitente
ct-codigo||y|mgesp.int-param-ord-prod-monitor.ct-codigo
sc-codigo||y|mgesp.int-param-ord-prod-monitor.sc-codigo
cod-unid-negoc||y|mgesp.int-param-ord-prod-monitor.cod-unid-negoc
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "cod-estabel",
     Keys-Supplied = "cod-estabel,cod-emitente,ct-codigo,sc-codigo,cod-unid-negoc"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-nome-emit AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 10.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     int-param-ord-prod-monitor.cod-estabel AT ROW 1.17 COL 25 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     int-param-ord-prod-monitor.cod-emitente AT ROW 2.75 COL 24.57 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     c-nome-emit AT ROW 2.75 COL 36.14 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     int-param-ord-prod-monitor.cod-unid-negoc AT ROW 3.75 COL 24.57 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     int-param-ord-prod-monitor.nat-operacao-retorno AT ROW 4.75 COL 24.57 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     int-param-ord-prod-monitor.nat-operacao-servico AT ROW 5.75 COL 24.57 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     int-param-ord-prod-monitor.ct-codigo AT ROW 6.75 COL 24.57 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     int-param-ord-prod-monitor.sc-codigo AT ROW 7.75 COL 24.57 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     int-param-ord-prod-monitor.cod-depos-ordem-compra AT ROW 8.75 COL 24.57 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     int-param-ord-prod-monitor.cod-depos-nf-servico AT ROW 9.75 COL 24.57 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     int-param-ord-prod-monitor.cod-depos-nf-retorno AT ROW 10.75 COL 24.57 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     int-param-ord-prod-monitor.cod-depos-reporte-prod AT ROW 11.75 COL 24.57 COLON-ALIGNED WIDGET-ID 8
          LABEL "Dep. Reporte de Produá∆o"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgesp.int-param-ord-prod-monitor
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
         HEIGHT             = 12.38
         WIDTH              = 89.29.
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

/* SETTINGS FOR FILL-IN c-nome-emit IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int-param-ord-prod-monitor.cod-depos-reporte-prod IN FRAME f-main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME int-param-ord-prod-monitor.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-param-ord-prod-monitor.cod-emitente V-table-Win
ON LEAVE OF int-param-ord-prod-monitor.cod-emitente IN FRAME f-main /* Fornecedor Compra */
DO:
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = INT(int-param-ord-prod-monitor.cod-emitente:SCREEN-VALUE IN FRAME f-main) NO-ERROR.
    
    IF AVAIL emitente THEN
        ASSIGN c-nome-emit:SCREEN-VALUE IN FRAME f-main = emitente.nome-abrev.
    ELSE
        ASSIGN c-nome-emit:SCREEN-VALUE IN FRAME f-main = "".
        
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
  DEF VAR key-value AS CHAR NO-UNDO.
  DEF VAR row-avail-enabled AS LOGICAL NO-UNDO.

  /* LOCK status on the find depends on FIELDS-ENABLED. */
  RUN get-attribute ('FIELDS-ENABLED':U).
  row-avail-enabled = (RETURN-VALUE eq 'yes':U).
  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'cod-estabel':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = int-param-ord-prod-monitor
           &WHERE = "WHERE int-param-ord-prod-monitor.cod-estabel eq key-value"
       }
  END CASE.

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
  {src/adm/template/row-list.i "int-param-ord-prod-monitor"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "int-param-ord-prod-monitor"}

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

    IF RETURN-VALUE = 'ADM-ERROR':U THEN 
        RETURN 'ADM-ERROR':U.
    
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


    /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  APPLY "leave" TO int-param-ord-prod-monitor.cod-emitente IN FRAME f-main.

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

        IF NOT CAN-FIND (FIRST estabelec
                         WHERE estabelec.cod-estabel = INPUT FRAME f-main int-param-ord-prod-monitor.cod-estabel) THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Estabelecimento n∆o cadastrado.").
            RETURN "adm-error".

        END.

        IF  adm-new-record
        AND CAN-FIND (FIRST int-param-ord-prod-monitor
                      WHERE int-param-ord-prod-monitor.cod-estabel = INPUT FRAME f-main int-param-ord-prod-monitor.cod-estabel) THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Parametros para o estabelecimento j† cadastradados.").
            RETURN "adm-error".
        END.

        IF NOT CAN-FIND (FIRST emitente
                         WHERE emitente.cod-emitente = INPUT FRAME f-main int-param-ord-prod-monitor.cod-emitente) THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Fornecedor n∆o cadastrado.").

            RETURN "adm-error".
        END.

        IF NOT CAN-FIND (FIRST unid-negoc
                         WHERE unid-negoc.cod-unid-negoc = INPUT FRAME f-main int-param-ord-prod-monitor.cod-unid-negoc) THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Unidade de Neg¢cio n∆o cadastrada.").

            RETURN "adm-error".
        END.

        IF NOT CAN-FIND (FIRST natur-oper
                         WHERE natur-oper.nat-operacao = INPUT FRAME f-main int-param-ord-prod-monitor.nat-operacao-retorno) THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Natureza NF Retorno n∆o cadastrada.").

            RETURN "adm-error".
        END.

        IF NOT CAN-FIND (FIRST natur-oper
                         WHERE natur-oper.nat-operacao = INPUT FRAME f-main int-param-ord-prod-monitor.nat-operacao-servico) THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Natureza NF Serviáo n∆o cadastrada.").

            RETURN "adm-error".
        END.

        /*Conta?*/

        IF NOT CAN-FIND (FIRST deposito
                         WHERE deposito.cod-depos = INPUT FRAME f-main int-param-ord-prod-monitor.cod-depos-ordem-compra) THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Dep¢sito compra n∆o cadastrado.").

            RETURN "adm-error".
        END.

        IF NOT CAN-FIND (FIRST deposito
                         WHERE deposito.cod-depos = INPUT FRAME f-main int-param-ord-prod-monitor.cod-depos-nf-servico) THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Dep¢sito NF Serviáo n∆o cadastrado").

            RETURN "adm-error".
        END.

        IF NOT CAN-FIND (FIRST deposito
                         WHERE deposito.cod-depos = INPUT FRAME f-main int-param-ord-prod-monitor.cod-depos-nf-retorno) THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Dep¢sito NF Retorno n∆o cadastrado").

            RETURN "adm-error".
        END.

        IF NOT CAN-FIND (FIRST deposito
                         WHERE deposito.cod-depos = INPUT FRAME f-main int-param-ord-prod-monitor.cod-depos-reporte-prod) THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Dep. Reporte de Produá∆o n∆o cadastrado").

            RETURN "adm-error".
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
  {src/adm/template/sndkycas.i "cod-estabel" "int-param-ord-prod-monitor" "cod-estabel"}
  {src/adm/template/sndkycas.i "cod-emitente" "int-param-ord-prod-monitor" "cod-emitente"}
  {src/adm/template/sndkycas.i "ct-codigo" "int-param-ord-prod-monitor" "ct-codigo"}
  {src/adm/template/sndkycas.i "sc-codigo" "int-param-ord-prod-monitor" "sc-codigo"}
  {src/adm/template/sndkycas.i "cod-unid-negoc" "int-param-ord-prod-monitor" "cod-unid-negoc"}

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
  {src/adm/template/snd-list.i "int-param-ord-prod-monitor"}

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

