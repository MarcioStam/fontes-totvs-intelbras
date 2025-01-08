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
{include/i-prgvrs.i XX9999 9.99.99.999}

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

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
def var hprogramzoom as handle no-undo.
DEFINE VARIABLE wh-pesquisa                       AS HANDLE       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_bem_pat_epc AS RECID FORMAT ">>>>>>9":U INITIAL ? NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button RECT-1 c-estab c-serie c-nr-nf ~
i-nr-seq-fat c-item da-vigencia bt-ok bt-cancela 
&Scoped-Define DISPLAYED-OBJECTS c-estab c-serie c-nr-nf i-nr-seq-fat ~
c-item da-vigencia 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-estab AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-item AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-nf AS CHARACTER FORMAT "X(16)":U 
     LABEL "Nr Nota" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie AS CHARACTER FORMAT "X(5)":U 
     LABEL "S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE da-vigencia AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Vigˆncia" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-seq-fat AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Seq Fat" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39 BY 7.5.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 38.86 BY 1.38
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     c-estab AT ROW 2 COL 11 COLON-ALIGNED WIDGET-ID 2
     c-serie AT ROW 3 COL 11 COLON-ALIGNED WIDGET-ID 6
     c-nr-nf AT ROW 4 COL 11 COLON-ALIGNED WIDGET-ID 8
     i-nr-seq-fat AT ROW 5 COL 11 COLON-ALIGNED WIDGET-ID 10
     c-item AT ROW 6 COL 11 COLON-ALIGNED WIDGET-ID 12
     da-vigencia AT ROW 7 COL 11 COLON-ALIGNED WIDGET-ID 16
     bt-ok AT ROW 9.46 COL 2.86
     bt-cancela AT ROW 9.46 COL 30.14
     rt-button AT ROW 9.25 COL 2
     RECT-1 AT ROW 1.5 COL 2 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 41.14 BY 9.63 WIDGET-ID 100.


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
         HEIGHT             = 9.63
         WIDTH              = 41.29
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
   L-To-R                                                               */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartWindowCues" w-cadsim _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/*:T SmartWindow,uib,50050
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
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


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-cadsim
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Cancelar */
DO:
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* OK */
DO:
  /*RUN notify ('update-record':U).*/

    FIND bem_pat NO-LOCK
        WHERE RECID(bem_pat) = v_rec_bem_pat_epc  NO-ERROR.

    FIND it-nota-fisc NO-LOCK
        WHERE it-nota-fisc.cod-estabel = INPUT c-estab
          AND it-nota-fisc.serie       = INPUT c-serie 
          AND it-nota-fisc.nr-nota-fis = INPUT c-nr-nf
          AND it-nota-fisc.nr-seq-fat  = INPUT i-nr-seq-fat
          AND it-nota-fisc.it-codigo   = INPUT c-item NO-ERROR.

    IF  NOT AVAIL it-nota-fisc THEN DO:
        RUN utp/ut-msgs.p ("show",
                           17006,
                           "Item da nota fiscal inexistente").
        RETURN no-apply.
    END.

    FIND FIRST INT_bem_pat_nf NO-LOCK
        WHERE INT_bem_pat_nf.cod_cta_pat     = bem_pat.cod_cta_pat    
          AND INT_bem_pat_nf.num_bem_pat     = bem_pat.num_bem_pat    
          AND INT_bem_pat_nf.num_seq_bem_pat = bem_pat.num_seq_bem_pat
          AND INT_bem_pat_nf.cod-estab       = it-nota-fisc.cod-estabel
          AND INT_bem_pat_nf.serie           = it-nota-fisc.serie      
          AND INT_bem_pat_nf.nr-nota-fis     = it-nota-fisc.nr-nota-fis
          AND INT_bem_pat_nf.nr-seq-fat      = it-nota-fisc.nr-seq-fat 
          AND INT_bem_pat_nf.it-codigo       = it-nota-fisc.it-codigo  NO-ERROR.


    IF  AVAIL INT_bem_pat_nf THEN DO:
        RUN utp/ut-msgs.p ("show",
                           17006,
                           "Relacionamento do item da nota com Bem j  existente").
        RETURN no-apply.
    END.

    IF  INPUT da-vigencia = ? THEN DO:
        RUN utp/ut-msgs.p ("show",
                           17006,
                           "Data de vigˆncia deve ser informada.").
        RETURN no-apply.
    END.
    
    FIND nota-fiscal OF it-nota-fisc NO-LOCK NO-ERROR.

    DO TRANS:
        CREATE INT_bem_pat_nf.
        ASSIGN INT_bem_pat_nf.cod_cta_pat     = bem_pat.cod_cta_pat     
               INT_bem_pat_nf.num_bem_pat     = bem_pat.num_bem_pat     
               INT_bem_pat_nf.num_seq_bem_pat = bem_pat.num_seq_bem_pat 
               INT_bem_pat_nf.cod_estab       = bem_pat.cod_estab
               INT_bem_pat_nf.cod-estab       = it-nota-fisc.cod-estabel
               INT_bem_pat_nf.serie           = it-nota-fisc.serie      
               INT_bem_pat_nf.nr-nota-fis     = it-nota-fisc.nr-nota-fis
               INT_bem_pat_nf.nr-seq-fat      = it-nota-fisc.nr-seq-fat 
               INT_bem_pat_nf.it-codigo       = it-nota-fisc.it-codigo  
               INT_bem_pat_nf.cod-emitente    = nota-fiscal.cod-emitente
               INT_bem_pat_nf.nat-operacao    = nota-fiscal.nat-operacao
               INT_bem_pat_nf.dt-emis-nota    = nota-fiscal.dt-emis-nota
               INT_bem_pat_nf.dt-vigencia     = INPUT da-vigencia.

    END.

  
     apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab w-cadsim
ON F5 OF c-estab IN FRAME f-cad /* Estab */
DO:
  
    {include/zoomvar.i &prog-zoom = dizoom/z04di088.w
                     &campo = i-nr-seq-fat
                     &campozoom = nr-seq-fat
                     &campo2 = c-estab
                     &campozoom2 = cod-estabel
                     &campo3 = c-serie
                     &campozoom3 = serie
                     &campo4 = c-nr-nf
                     &campozoom4 = nr-nota-fis
                     &campo5 = c-item
                     &campozoom5 = it-codigo
                     }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab w-cadsim
ON MOUSE-SELECT-DBLCLICK OF c-estab IN FRAME f-cad /* Estab */
DO:
    APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item w-cadsim
ON F5 OF c-item IN FRAME f-cad /* Item */
DO:
     {include/zoomvar.i &prog-zoom = dizoom/z04di088.w
                      &campo = i-nr-seq-fat
                      &campozoom = nr-seq-fat
                      &campo2 = c-estab
                      &campozoom2 = cod-estabel
                      &campo3 = c-serie
                      &campozoom3 = serie
                      &campo4 = c-nr-nf
                      &campozoom4 = nr-nota-fis
                      &campo5 = c-item
                      &campozoom5 = it-codigo
                      }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item w-cadsim
ON MOUSE-SELECT-DBLCLICK OF c-item IN FRAME f-cad /* Item */
DO:
    APPLY "f5" TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nr-nf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-nf w-cadsim
ON F5 OF c-nr-nf IN FRAME f-cad /* Nr Nota */
DO:
  
    {include/zoomvar.i &prog-zoom = dizoom/z04di088.w
                     &campo = i-nr-seq-fat
                     &campozoom = nr-seq-fat
                     &campo2 = c-estab
                     &campozoom2 = cod-estabel
                     &campo3 = c-serie
                     &campozoom3 = serie
                     &campo4 = c-nr-nf
                     &campozoom4 = nr-nota-fis
                     &campo5 = c-item
                     &campozoom5 = it-codigo
                     }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-nf w-cadsim
ON MOUSE-SELECT-DBLCLICK OF c-nr-nf IN FRAME f-cad /* Nr Nota */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-serie w-cadsim
ON F5 OF c-serie IN FRAME f-cad /* S‚rie */
DO:
  
    {include/zoomvar.i &prog-zoom = dizoom/z04di088.w
                     &campo = i-nr-seq-fat
                     &campozoom = nr-seq-fat
                     &campo2 = c-estab
                     &campozoom2 = cod-estabel
                     &campo3 = c-serie
                     &campozoom3 = serie
                     &campo4 = c-nr-nf
                     &campozoom4 = nr-nota-fis
                     &campo5 = c-item
                     &campozoom5 = it-codigo
                     }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-serie w-cadsim
ON MOUSE-SELECT-DBLCLICK OF c-serie IN FRAME f-cad /* S‚rie */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-nr-seq-fat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-seq-fat w-cadsim
ON F5 OF i-nr-seq-fat IN FRAME f-cad /* Seq Fat */
DO:
  
    {include/zoomvar.i &prog-zoom = dizoom/z04di088.w
                     &campo = i-nr-seq-fat
                     &campozoom = nr-seq-fat
                     &campo2 = c-estab
                     &campozoom2 = cod-estabel
                     &campo3 = c-serie
                     &campozoom3 = serie
                     &campo4 = c-nr-nf
                     &campozoom4 = nr-nota-fis
                     &campo5 = c-item
                     &campozoom5 = it-codigo
                     }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-seq-fat w-cadsim
ON MOUSE-SELECT-DBLCLICK OF i-nr-seq-fat IN FRAME f-cad /* Seq Fat */
DO:
  APPLY "f5" TO SELF.
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
  DISPLAY c-estab c-serie c-nr-nf i-nr-seq-fat c-item da-vigencia 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE rt-button RECT-1 c-estab c-serie c-nr-nf i-nr-seq-fat c-item 
         da-vigencia bt-ok bt-cancela 
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

  {utp/ut9000.i "XX9999" "9.99.99.999"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /*
  /* Code placed here will execute AFTER standard behavior.    */
  find first <tabela> no-lock no-error. 
  if not avail <tabela> 
  then RUN notify IN THIS-PROCEDURE ('add-record':U).
  else RUN new-state ('update-begin':U).
  */
  RUN dispatch  IN this-procedure ('enable-fields':U).

  {include/i-inifld.i}

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

