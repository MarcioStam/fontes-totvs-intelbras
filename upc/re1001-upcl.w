&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i re1001-upcl 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
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

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.

DEF NEW GLOBAL SHARED VARIABLE gr-docum-est AS ROWID NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button i-cd-servico c-cd-enquadramento ~
bt-ok bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS i-cd-servico c-ds-servico ~
c-cd-enquadramento c-ds-enquadramento i-cd-atividade c-ds-atividade 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-bt-ajuda 
       MENU-ITEM mi-sobre       LABEL "Sobre..."      .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-imprime 
     LABEL "&Imprimir" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-cd-enquadramento AS CHARACTER FORMAT "X(12)":U 
     LABEL "C¢d. Enquadr." 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-ds-atividade AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE c-ds-enquadramento AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE c-ds-servico AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE i-cd-atividade AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Atividade MEI." 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cd-servico AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "C¢d. Servi‡o" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.38
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     i-cd-servico AT ROW 1.67 COL 13.29 COLON-ALIGNED WIDGET-ID 2
     c-ds-servico AT ROW 1.67 COL 27.57 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     c-cd-enquadramento AT ROW 2.67 COL 13.29 COLON-ALIGNED WIDGET-ID 4
     c-ds-enquadramento AT ROW 2.67 COL 27.57 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     i-cd-atividade AT ROW 3.67 COL 13.29 COLON-ALIGNED WIDGET-ID 10
     c-ds-atividade AT ROW 3.67 COL 27.57 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     bt-ok AT ROW 5.21 COL 2
     bt-cancela AT ROW 5.21 COL 13
     bt-imprime AT ROW 5.21 COL 24
     bt-ajuda AT ROW 5.21 COL 69.43
     rt-button AT ROW 5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 12.58 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Manuten‡Æo <Insira o complemento>"
         HEIGHT             = 5.42
         WIDTH              = 80
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = yes
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-cadsim 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-cadsim
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       bt-ajuda:POPUP-MENU IN FRAME f-cad       = MENU POPUP-MENU-bt-ajuda:HANDLE.

/* SETTINGS FOR BUTTON bt-imprime IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       bt-imprime:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR FILL-IN c-ds-atividade IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-ds-enquadramento IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-ds-servico IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cd-atividade IN FRAME f-cad
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Manuten‡Æo <Insira o complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Manuten‡Æo <Insira o complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-cadsim
ON CHOOSE OF bt-ajuda IN FRAME f-cad /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-cadsim
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Cancelar */
DO:
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprime w-cadsim
ON CHOOSE OF bt-imprime IN FRAME f-cad /* Imprimir */
DO:
run utp/ut-relat.w persistent set wh-imprime (input c-programa-mg97).
if valid-handle(wh-imprime) then
  run dispatch in wh-imprime ('initialize':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* OK */
DO:
    RUN pi-valida.

    IF RETURN-VALUE <> "OK" THEN
        RETURN "NOK".

    FIND CURRENT int-docum-est EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAIL int-docum-est THEN DO:
        IF AVAIL docum-est THEN DO:
            CREATE int-docum-est.
            ASSIGN int-docum-est.serie-docto  = docum-est.serie-docto
                   int-docum-est.nro-docto    = docum-est.nro-docto
                   int-docum-est.cod-emitente = docum-est.cod-emitente
                   int-docum-est.nat-operacao = docum-est.nat-operacao.
        END.
    END.

    IF AVAIL int-docum-est THEN
        ASSIGN int-docum-est.cd-servico        = INPUT FRAME f-cad i-cd-servico
               int-docum-est.cd-enquadramento  = INPUT FRAME f-cad c-cd-enquadramento
               int-docum-est.cod-atividade-mei = int(INPUT FRAME f-cad i-cd-atividade).

    FIND CURRENT int-docum-est NO-LOCK NO-ERROR.

    apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cd-enquadramento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-enquadramento w-cadsim
ON ENTRY OF c-cd-enquadramento IN FRAME f-cad /* C¢d. Enquadr. */
DO:
  RUN pi-habilita-ativ-mei.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-enquadramento w-cadsim
ON F5 OF c-cd-enquadramento IN FRAME f-cad /* C¢d. Enquadr. */
DO:
    {include/zoomvar.i &prog-zoom=esp/rep/z01esrep043.w
                       &campo=c-cd-enquadramento
                       &campozoom=cd-enquadramento
                       &campo2=c-ds-enquadramento  
                       &campozoom2=ds-enquadramento
                       &frame=f-cad}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-enquadramento w-cadsim
ON LEAVE OF c-cd-enquadramento IN FRAME f-cad /* C¢d. Enquadr. */
DO:
    FIND FIRST int-enquadramento NO-LOCK
         WHERE int-enquadramento.cd-enquadramento = INPUT FRAME f-cad c-cd-enquadramento NO-ERROR.

    IF AVAIL int-enquadramento THEN
        ASSIGN c-ds-enquadramento:SCREEN-VALUE IN FRAME f-cad = int-enquadramento.ds-enquadramento.
    ELSE 
        ASSIGN c-ds-enquadramento:SCREEN-VALUE IN FRAME f-cad = "".


   RUN pi-habilita-ativ-mei.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-enquadramento w-cadsim
ON MOUSE-SELECT-DBLCLICK OF c-cd-enquadramento IN FRAME f-cad /* C¢d. Enquadr. */
DO:
    APPLY "f5" TO SELF.

    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-enquadramento w-cadsim
ON VALUE-CHANGED OF c-cd-enquadramento IN FRAME f-cad /* C¢d. Enquadr. */
DO:
   RUN pi-habilita-ativ-mei.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cd-atividade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-atividade w-cadsim
ON F5 OF i-cd-atividade IN FRAME f-cad /* Atividade MEI. */
DO:
    {include/zoomvar.i &prog-zoom=esp/rep/esrep045-z01.w
                      &campo=i-cd-atividade
                      &campozoom=cod-atividade
                      &campo2=c-ds-atividade
                      &campozoom2=des-atividade-mei}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-atividade w-cadsim
ON LEAVE OF i-cd-atividade IN FRAME f-cad /* Atividade MEI. */
DO:
    FIND FIRST int-atividade-mei NO-LOCK
         WHERE int-atividade-mei.cod-atividade = INPUT FRAME f-cad i-cd-atividade NO-ERROR.

    IF AVAIL int-atividade-mei THEN
        ASSIGN c-ds-atividade:SCREEN-VALUE IN FRAME f-cad = int-atividade-mei.des-atividade-mei.
    ELSE 
        ASSIGN c-ds-atividade:SCREEN-VALUE IN FRAME f-cad = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-atividade w-cadsim
ON MOUSE-SELECT-DBLCLICK OF i-cd-atividade IN FRAME f-cad /* Atividade MEI. */
DO:
    APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cd-servico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-servico w-cadsim
ON F5 OF i-cd-servico IN FRAME f-cad /* C¢d. Servi‡o */
DO:
   {include/zoomvar.i &prog-zoom=esp/rep/z01esrep044.w
                      &campo=i-cd-servico
                      &campozoom=cd-servico
                      &campo2=c-ds-servico
                      &campozoom2=ds-servico
                      &frame=f-cad}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-servico w-cadsim
ON LEAVE OF i-cd-servico IN FRAME f-cad /* C¢d. Servi‡o */
DO:
    FIND FIRST int-codigo-servico NO-LOCK
         WHERE int-codigo-servico.cd-servico = INPUT FRAME f-cad i-cd-servico NO-ERROR.

    IF AVAIL int-codigo-servico THEN
        ASSIGN c-ds-servico:SCREEN-VALUE IN FRAME f-cad = int-codigo-servico.ds-servico.
    ELSE 
        ASSIGN c-ds-servico:SCREEN-VALUE IN FRAME f-cad = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-servico w-cadsim
ON MOUSE-SELECT-DBLCLICK OF i-cd-servico IN FRAME f-cad /* C¢d. Servi‡o */
DO:
    APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-cadsim
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-cadsim  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-cadsim  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-cadsim  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
  THEN DELETE WIDGET w-cadsim.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-cadsim  _DEFAULT-ENABLE
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
  DISPLAY i-cd-servico c-ds-servico c-cd-enquadramento c-ds-enquadramento 
          i-cd-atividade c-ds-atividade 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE rt-button i-cd-servico c-cd-enquadramento bt-ok bt-cancela bt-ajuda 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-cadsim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-cadsim 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-cadsim 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-cadsim 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "re1001-upcl" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  i-cd-servico:load-mouse-pointer ("image/lupa.cur") IN FRAME f-cad.
  c-cd-enquadramento:load-mouse-pointer ("image/lupa.cur") IN FRAME f-cad.
  i-cd-atividade:load-mouse-pointer ("image/lupa.cur") IN FRAME f-cad.

  /* Code placed here will execute AFTER standard behavior.    */
 FIND FIRST docum-est NO-LOCK
      WHERE ROWID(docum-est) = gr-docum-est NO-ERROR.

 IF AVAIL docum-est THEN DO:
     FIND FIRST int-docum-est OF docum-est NO-LOCK NO-ERROR.

     IF AVAIL int-docum-est THEN
         ASSIGN i-cd-servico:SCREEN-VALUE IN FRAME f-cad = string(int-docum-est.cd-servico)
                c-cd-enquadramento:SCREEN-VALUE IN FRAME f-cad = string(int-docum-est.cd-enquadramento).

     APPLY "leave" TO i-cd-servico IN FRAME f-cad.
     APPLY "leave" TO c-cd-enquadramento IN FRAME f-cad.
 END.

  RUN dispatch  IN this-procedure ('enable-fields':U).

  {include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-ativ-mei w-cadsim 
PROCEDURE pi-habilita-ativ-mei :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF c-cd-enquadramento:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'MEI' THEN
       ASSIGN i-cd-atividade:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    ELSE
       ASSIGN i-cd-atividade:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '0' 
              c-ds-atividade:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''
              i-cd-atividade:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida w-cadsim 
PROCEDURE pi-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FIND FIRST int-codigo-servico NO-LOCK
         WHERE int-codigo-servico.cd-servico = INPUT FRAME f-cad i-cd-servico NO-ERROR.
    
    IF NOT AVAIL int-codigo-servico THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrado servi‡o com a chave informada").
        RETURN "NOK".
    END.

    FIND FIRST int-enquadramento NO-LOCK
         WHERE int-enquadramento.cd-enquadramento = INPUT FRAME f-cad c-cd-enquadramento NO-ERROR.
    
    IF NOT AVAIL int-enquadramento THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo encontrado enquadramento com a chave informada").
        RETURN "NOK".
    END.

    IF c-cd-enquadramento:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'MEI' THEN
    DO:
        FIND int-atividade-mei WHERE int-atividade-mei.cod-atividade = int(i-cd-atividade:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-LOCK NO-ERROR.

        IF NOT AVAIL int-atividade-mei THEN
        DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Informe um Cod.Atividade MEI valido").

            ASSIGN i-cd-atividade:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

            APPLY 'ENTRY' TO i-cd-atividade IN FRAME {&FRAME-NAME}.

            RETURN "NOK".

        END.
    END.






    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-cadsim  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-cadsim 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

