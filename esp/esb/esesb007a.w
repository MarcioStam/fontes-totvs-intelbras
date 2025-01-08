&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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
{include/i-prgvrs.i XX9999 9.99.99.999}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAM r-rowid AS ROWID.
/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 i-cod-cond-pagto nome-transp ~
cod-canal-venda cod-priori ed-observacoes ed-cond-espec bt-ok bt-cancelar ~
bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS i-cod-cond-pagto des-cond-pagto ~
nome-transp des-transportador cod-canal-venda des-canal-venda cod-priori ~
ed-observacoes ed-cond-espec 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-window AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE ed-cond-espec AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 46 BY 4 NO-UNDO.

DEFINE VARIABLE ed-observacoes AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 46 BY 3.5 NO-UNDO.

DEFINE VARIABLE cod-canal-venda AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Canal Venda" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .88 NO-UNDO.

DEFINE VARIABLE cod-priori AS INTEGER FORMAT "99" INITIAL 0 
     LABEL "Prioridade" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .88 NO-UNDO.

DEFINE VARIABLE des-canal-venda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.72 BY .88 NO-UNDO.

DEFINE VARIABLE des-cond-pagto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.14 BY .88 NO-UNDO.

DEFINE VARIABLE des-transportador AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-cond-pagto AS INTEGER FORMAT ">>>9" INITIAL 0 
     LABEL "Cond Pagto" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE nome-transp AS CHARACTER FORMAT "x(12)" 
     LABEL "Transportador" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 77.86 BY 1.38
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     i-cod-cond-pagto AT ROW 1.75 COL 13.72 COLON-ALIGNED HELP
          "C¢digo da condiá∆o de pagamento" WIDGET-ID 4
     des-cond-pagto AT ROW 1.75 COL 19.86 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     nome-transp AT ROW 2.75 COL 13.72 COLON-ALIGNED HELP
          "Nome do transportador" WIDGET-ID 10
     des-transportador AT ROW 2.75 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     cod-canal-venda AT ROW 3.75 COL 13.72 COLON-ALIGNED HELP
          "C¢digo do canal de venda" WIDGET-ID 12
     des-canal-venda AT ROW 3.75 COL 19.29 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     cod-priori AT ROW 4.75 COL 13.72 COLON-ALIGNED HELP
          "C¢digo de Prioridade para fornecimento do pedido" WIDGET-ID 14
     ed-observacoes AT ROW 5.75 COL 16 NO-LABEL WIDGET-ID 18
     ed-cond-espec AT ROW 9.5 COL 16 NO-LABEL WIDGET-ID 32
     bt-ok AT ROW 17.21 COL 3
     bt-cancelar AT ROW 17.21 COL 14
     bt-ajuda AT ROW 17.21 COL 69
     "Observaá‰es:" VIEW-AS TEXT
          SIZE 9.29 BY .54 AT ROW 5.92 COL 6.43 WIDGET-ID 20
     "Cond Especial:" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 9.75 COL 5.57 WIDGET-ID 34
     RECT-1 AT ROW 17 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17.54
         FONT 7 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: JanelaDetalhe
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert Custom SmartWindow title>"
         HEIGHT             = 17.58
         WIDTH              = 80
         MAX-HEIGHT         = 21.13
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.13
         VIRTUAL-WIDTH      = 114.29
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
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN des-canal-venda IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN des-cond-pagto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN des-transportador IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* <insert Custom SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* <insert Custom SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-window
ON CHOOSE OF bt-ajuda IN FRAME F-Main /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-window
ON CHOOSE OF bt-cancelar IN FRAME F-Main /* Cancelar */
DO:
  apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME F-Main /* OK */
DO:
    RUN pi-salva.
    IF RETURN-VALUE <> "NOK" THEN
        apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-canal-venda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-canal-venda w-window
ON F5 OF cod-canal-venda IN FRAME F-Main /* Canal Venda */
DO:
  {include/zoomvar.i &prog-zoom=dizoom/z01di232.w
                     &campo=cod-canal-venda
                     &campozoom=cod-canal-venda
                     &FRAME=f-main
                     &campo2=des-canal-venda
                     &campozoom2=descricao
                     &FRAME2=f-main}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-canal-venda w-window
ON LEAVE OF cod-canal-venda IN FRAME F-Main /* Canal Venda */
DO:
   FIND FIRST canal-venda NO-LOCK
        WHERE canal-venda.cod-canal-venda = INPUT FRAME {&FRAME-NAME} cod-canal-venda NO-ERROR.

    IF AVAIL canal-venda THEN
        ASSIGN des-canal-venda:SCREEN-VALUE IN FRAME {&FRAME-NAME} = canal-venda.descricao.
    ELSE 
        ASSIGN des-canal-venda:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-canal-venda w-window
ON MOUSE-SELECT-DBLCLICK OF cod-canal-venda IN FRAME F-Main /* Canal Venda */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-cond-pagto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pagto w-window
ON F5 OF i-cod-cond-pagto IN FRAME F-Main /* Cond Pagto */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad039.w
                       &campo=i-cod-cond-pagto
                       &campozoom=cod-cond-pag
                       &frame=f-main
                       &campo2=des-cond-pagto
                       &campozoom2=descricao
                       &frame2=f-main}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pagto w-window
ON LEAVE OF i-cod-cond-pagto IN FRAME F-Main /* Cond Pagto */
DO:
    FIND FIRST cond-pagto NO-LOCK
         WHERE cond-pagto.cod-cond-pag = INPUT FRAME {&FRAME-NAME} i-cod-cond-pagto NO-ERROR. 

    IF AVAIL cond-pagto THEN
        ASSIGN des-cond-pagto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cond-pagto.descricao.
    ELSE 
        ASSIGN des-cond-pagto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pagto w-window
ON MOUSE-SELECT-DBLCLICK OF i-cod-cond-pagto IN FRAME F-Main /* Cond Pagto */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME nome-transp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nome-transp w-window
ON F5 OF nome-transp IN FRAME F-Main /* Transportador */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad268.w"
                     &campo=des-transportador
                     &campozoom=nome
                     &campo2=nome-transp
                     &campozoom2=nome-abrev} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nome-transp w-window
ON LEAVE OF nome-transp IN FRAME F-Main /* Transportador */
DO:
    FIND FIRST transporte NO-LOCK
         WHERE transporte.nome-abrev = INPUT FRAME {&FRAME-NAME} nome-transp NO-ERROR.

    IF AVAIL transporte THEN
        ASSIGN des-transportador:SCREEN-VALUE IN FRAME {&FRAME-NAME} = transporte.nome.
    ELSE 
        ASSIGN des-transportador:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nome-transp w-window
ON MOUSE-SELECT-DBLCLICK OF nome-transp IN FRAME F-Main /* Transportador */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-window 


/* ***************************  Main Block  *************************** */

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
  DISPLAY i-cod-cond-pagto des-cond-pagto nome-transp des-transportador 
          cod-canal-venda des-canal-venda cod-priori ed-observacoes 
          ed-cond-espec 
      WITH FRAME F-Main IN WINDOW w-window.
  ENABLE RECT-1 i-cod-cond-pagto nome-transp cod-canal-venda cod-priori 
         ed-observacoes ed-cond-espec bt-ok bt-cancelar bt-ajuda 
      WITH FRAME F-Main IN WINDOW w-window.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
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
  
  {utp/ut9000.i "XX9999" "9.99.99.999"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND FIRST ped-venda NO-LOCK
       WHERE ROWID(ped-venda) = r-rowid NO-ERROR.
    
  ASSIGN i-cod-cond-pagto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ped-venda.cod-cond-pag   )
         nome-transp     :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ped-venda.nome-transp    )
         cod-canal-venda :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ped-venda.cod-canal-venda)
         cod-priori      :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ped-venda.cod-priori     )
         ed-observacoes  :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ped-venda.observacoes    )
         ed-cond-espec   :SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ped-venda.cond-espec     ).

  APPLY 'LEAVE' TO i-cod-cond-pagto IN FRAME {&FRAME-NAME}.
  APPLY 'LEAVE' TO nome-transp IN FRAME {&FRAME-NAME}.
  APPLY 'LEAVE' TO cod-canal-venda IN FRAME {&FRAME-NAME}.

  IF i-cod-cond-pagto:LOAD-MOUSE-POINTER ("image/lupa.cur") THEN.
  IF nome-transp:LOAD-MOUSE-POINTER ("image/lupa.cur") THEN.
  IF cod-canal-venda:LOAD-MOUSE-POINTER ("image/lupa.cur") THEN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva w-window 
PROCEDURE pi-salva :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST cond-pagto NO-LOCK
     WHERE cond-pagto.cod-cond-pag = INPUT FRAME {&FRAME-NAME} i-cod-cond-pagto NO-ERROR. 

IF NOT AVAIL cond-pagto THEN DO:
    RUN utp/ut-msgs.p (INPUT "Show",
                       INPUT 17006,
                       INPUT "Condiá∆o de Pagamento n∆o cadastrada!").
    RETURN "NOK".
END.

FIND FIRST transporte NO-LOCK
     WHERE transporte.nome-abrev = INPUT FRAME {&FRAME-NAME} nome-transp NO-ERROR.

IF NOT AVAIL transporte THEN DO:
    RUN utp/ut-msgs.p (INPUT "Show",
                       INPUT 17006,
                       INPUT "Transportador n∆o cadastrado!").
    RETURN "NOK".
END.

FIND FIRST canal-venda NO-LOCK
     WHERE canal-venda.cod-canal-venda = INPUT FRAME {&FRAME-NAME} cod-canal-venda NO-ERROR.

IF NOT AVAIL canal-venda THEN DO:
    RUN utp/ut-msgs.p (INPUT "Show",
                       INPUT 17006,
                       INPUT "Canal de venda n∆o cadastrado!").
    RETURN "NOK".
END.

FIND CURRENT ped-venda EXCLUSIVE-LOCK.

ASSIGN ped-venda.cod-cond-pag    = INPUT FRAME {&FRAME-NAME} i-cod-cond-pagto 
       ped-venda.nome-transp     = INPUT FRAME {&FRAME-NAME} nome-transp     
       ped-venda.cod-canal-venda = INPUT FRAME {&FRAME-NAME} cod-canal-venda 
       ped-venda.cod-priori      = INPUT FRAME {&FRAME-NAME} cod-priori      
       ped-venda.observacoes     = INPUT FRAME {&FRAME-NAME} ed-observacoes  
       ped-venda.cond-espec      = INPUT FRAME {&FRAME-NAME} ed-cond-espec.

FIND CURRENT ped-venda NO-LOCK.

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this JanelaDetalhe, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

