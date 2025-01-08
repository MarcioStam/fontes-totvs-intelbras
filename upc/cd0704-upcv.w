&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V53AD098 2.00.00.003}  /*** 010003 ***/

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

def var de-bonificacao-ant like emitente.bonificacao no-undo.
def var rw-emitente        as rowid                  no-undo.
def var c-texto            as char extent 2          no-undo.
def var h-window           as handle                 no-undo.
def var c-handle           as char                   no-undo.
def var hProgramZoom as handle no-undo.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES emitente
&Scoped-define FIRST-EXTERNAL-TABLE emitente


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR emitente.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS emitente.bonificacao emitente.cod-suframa 
&Scoped-define ENABLED-TABLES emitente
&Scoped-define FIRST-ENABLED-TABLE emitente
&Scoped-Define ENABLED-OBJECTS RECT-28 RECT-29 
&Scoped-Define DISPLAYED-FIELDS emitente.bonificacao emitente.cod-suframa 
&Scoped-define DISPLAYED-TABLES emitente
&Scoped-define FIRST-DISPLAYED-TABLE emitente
&Scoped-Define DISPLAYED-OBJECTS c-nome-transp desc-transp c-rota desc-rota ~
c-cidade-cif 

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
DEFINE VARIABLE c-cidade-cif AS CHARACTER FORMAT "X(25)":U 
     LABEL "Cidade CIF" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-transp AS CHARACTER FORMAT "X(12)":U 
     LABEL "Transportador" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-rota AS CHARACTER FORMAT "X(12)":U 
     LABEL "Rota" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE desc-rota AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE desc-transp AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79 BY 3.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79 BY 4.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     emitente.bonificacao AT ROW 1.5 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     emitente.cod-suframa AT ROW 2.5 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     c-nome-transp AT ROW 4.5 COL 15 COLON-ALIGNED HELP
          "C¢digo do Transportador Padr∆o do Cliente"
     desc-transp AT ROW 4.5 COL 30 COLON-ALIGNED NO-LABEL
     c-rota AT ROW 5.5 COL 15 COLON-ALIGNED HELP
          "C¢digo da Rota Padr∆o do Cliente"
     desc-rota AT ROW 5.5 COL 30 COLON-ALIGNED NO-LABEL
     c-cidade-cif AT ROW 6.5 COL 15 COLON-ALIGNED HELP
          "Nome da Cidade CIF"
     RECT-28 AT ROW 1 COL 1
     RECT-29 AT ROW 3.92 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.emitente
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
         HEIGHT             = 9.79
         WIDTH              = 79.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cidade-cif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-transp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-rota IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN desc-rota IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN desc-transp IN FRAME f-main
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

&Scoped-define SELF-NAME c-cidade-cif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cidade-cif V-table-Win
ON F5 OF c-cidade-cif IN FRAME f-main /* Cidade CIF */
OR MOUSE-SELECT-DBLCLICK OF c-cidade-cif IN FRAME {&FRAME-NAME} DO:
 /* {include/zoomvar.i &prog-zoom= "dizoom/z01di341.w"
                     &campo= c-cidade-cif
                     &campozoom= cidade}*/
                     
    {method/zoomfields.i &ProgramZoom="dizoom/Z01DI341.w"
                     &FieldZoom1="cidade"                        
                     &FieldScreen1="c-cidade-cif"
                     &Frame1="f-main"                           
                     &EnableImplant="no"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nome-transp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-transp V-table-Win
ON F5 OF c-nome-transp IN FRAME f-main /* Transportador */
OR MOUSE-SELECT-DBLCLICK OF c-nome-transp IN FRAME {&FRAME-NAME} DO:
    assign l-implanta = NO.
    {include/zoomvar.i &prog-zoom= "adzoom/z01ad268.w"
                       &campo= c-nome-transp
                       &campozoom= nome-abrev} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-transp V-table-Win
ON LEAVE OF c-nome-transp IN FRAME f-main /* Transportador */
DO:
    /* procura pelo nome-abrev */
    find first transporte where transporte.nome-abrev =
                                c-nome-transp:screen-value in frame {&FRAME-NAME} no-lock no-error.
    /* se nao achou procura pelo codigo */
    if not avail transporte then
        find first transporte where transporte.cod-transp =
                                int(c-nome-transp:screen-value in frame {&FRAME-NAME}) no-lock no-error.

    if avail transporte then
       assign c-nome-transp:screen-value in frame {&FRAME-NAME} = transporte.nome-abrev
              desc-transp:screen-value in frame {&FRAME-NAME}   = transporte.nome.
    else 
       assign desc-transp:screen-value in frame {&FRAME-NAME} = "".    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-rota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-rota V-table-Win
ON F5 OF c-rota IN FRAME f-main /* Rota */
OR MOUSE-SELECT-DBLCLICK OF c-rota IN FRAME {&FRAME-NAME} DO:
   assign l-implanta = NO.
  {include/zoomvar.i &prog-zoom= "dizoom/z01di181.w"
                     &campo= c-rota
                     &campozoom= cod-rota}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-rota V-table-Win
ON LEAVE OF c-rota IN FRAME f-main /* Rota */
DO:
    find first rota where rota.cod-rota =
                               c-rota:screen-value in frame {&FRAME-NAME} no-lock no-error.
    if avail rota then
       assign desc-rota:screen-value in frame {&FRAME-NAME} = rota.descricao.
    else 
       assign desc-rota:screen-value in frame {&FRAME-NAME} = "".
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
  {src/adm/template/row-list.i "emitente"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "emitente"}

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
    
    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    /* so chama este evento UPC quando for alteracao do registro.
     * desta forma, o programa UPC cd0704-upc cria os dados nas tabelas
     * atraves de ponto existente na viewer cd0704-v04 e altera por este ponto abaixo */

    RUN GET-ATTRIBUTE ('adm-new-record').
    IF RETURN-VALUE = "NO" THEN DO:
       /* {cdp/cd9996.i grava-dados-adicionais "RETURN NO-APPLY" "emitente" ROWID(emitente)} */
        if  c-nom-prog-upc-mg97 <> "" then do:
            run value(c-nom-prog-upc-mg97) (input "grava-dados-adicionais",
                                            input "CONTAINER",
                                            input THIS-PROCEDURE,
                                            input frame {&FRAME-NAME}:HANDLE,
                                            input "emitente",
                                            input ROWID(emitente)).

            if RETURN-VALUE = "NOK" then 
               RETURN NO-APPLY.
        end.
    END.
    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
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

     disable c-nome-transp c-rota c-cidade-cif with frame {&FRAME-NAME}.
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

    IF AVAIL emitente THEN DO:
        FIND FIRST loc-entr
            WHERE loc-entr.nome-abrev  = emitente.nome-abrev
            AND   loc-entr.cod-entrega = "Padr∆o"
        NO-LOCK NO-ERROR.

        IF AVAIL loc-entr THEN DO:
            disp loc-entr.nome-transp   @ c-nome-transp
                 loc-entr.cod-rota      @ c-rota
                 loc-entr.nom-cidad-cif @ c-cidade-cif with frame {&FRAME-NAME}.

            APPLY "leave":U to c-nome-transp in frame {&FRAME-NAME}.
            APPLY "leave":U to c-rota in frame {&FRAME-NAME}.
        END.
    END.

  /* Code placed here will execute AFTER standard behavior.    */

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

    enable c-nome-transp
           c-cidade-cif 
           with frame {&FRAME-NAME}.
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
/*
    /* busca tabela com informaá‰es de parametros */
    find first param-global no-lock no-error.
    find first para-ped     no-lock no-error.
    find first par-preco  where 
               par-preco.cod-estabel = para-ped.estab-padrao no-lock no-error.
*/

     RUN Who-Is-The-Container IN adm-broker-hdl
    (INPUT this-procedure,
     OUTPUT c-handle).
     assign h-window = widget-handle(c-handle). 

     c-nome-transp:load-mouse-pointer ("image/lupa.cur") in frame {&FRAME-NAME}.
     c-cidade-cif:load-mouse-pointer ("image/lupa.cur") in frame {&FRAME-NAME}.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
    
 if input frame {&frame-name} emitente.bonificacao > 100 then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":U, input 507, input '').
    apply "entry" to emitente.bonificacao in frame {&frame-name}. 
    return 'ADM-ERROR':U. 
 end.

  find first transporte where transporte.nome-abrev =
                              c-nome-transp:screen-value in frame {&FRAME-NAME} no-lock no-error.
  if not avail transporte then 
      find first transporte where transporte.cod-transp =
                                  int(c-nome-transp:screen-value in frame {&FRAME-NAME}) no-lock no-error.

  if not avail transporte then do:
     run utp/ut-msgs.p (input "show", input 2190, input "").
     apply 'entry' to c-nome-transp in frame {&FRAME-NAME}.
     return "adm-error":U.
  end.

 /** N∆o h† mais a necessidade de validar ROTA **/
 /** Mas a Cidade CIF deve ser validada ainda **/
 /** Felipe - 27.07.2007 **/
 
 /* if c-rota:screen-value in frame {&frame-name} <> "" */
 
 if c-cidade-cif:screen-value in frame {&frame-name} <> "" then do:          
   if not can-find (first mgcad.cidade no-lock
      where cidade.cidade = c-cidade-cif:screen-value in frame {&frame-name}) then do:
         run utp/ut-msgs.p (input "show", input 25838, input c-rota:screen-value in frame {&FRAME-NAME}).
         apply 'entry' to c-cidade-cif in frame {&FRAME-NAME}.
         return "adm-error":U.
   end.
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
  {src/adm/template/snd-list.i "emitente"}

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

