&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
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
{include/i-prgvrs.i esftp9004 2.00.00.000}

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

DEFINE TEMP-TABLE tt-unid-negoc 
    FIELD cdn_unid_negoc LIKE unid_negoc.cdn_unid_negoc
    FIELD cod_unid_negoc LIKE unid_negoc.cod_unid_negoc
    FIELD des_unid_negoc LIKE unid_negoc.des_unid_negoc.

DEFINE TEMP-TABLE tt-canal-venda 
    FIELD cod-canal-venda LIKE canal-venda.cod-canal-venda
    FIELD descricao       LIKE canal-venda.descricao.

DEFINE TEMP-TABLE tt-unid-neg-canal-vend
    FIELD cdn_unid_negoc  LIKE unid_negoc.cdn_unid_negoc
    FIELD cod-canal-venda LIKE canal-venda.cod-canal-venda.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-canal-unid

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-unid-neg-canal-vend tt-canal-venda ~
tt-unid-negoc

/* Definitions for BROWSE br-canal-unid                                 */
&Scoped-define FIELDS-IN-QUERY-br-canal-unid tt-unid-neg-canal-vend.cdn_unid_negoc tt-unid-neg-canal-vend.cod-canal-venda   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-canal-unid   
&Scoped-define SELF-NAME br-canal-unid
&Scoped-define QUERY-STRING-br-canal-unid FOR EACH tt-unid-neg-canal-vend WHERE tt-unid-neg-canal-vend.cdn_unid_neg = tt-unid-negoc.cdn_unid_neg
&Scoped-define OPEN-QUERY-br-canal-unid OPEN QUERY {&SELF-NAME} FOR EACH tt-unid-neg-canal-vend WHERE tt-unid-neg-canal-vend.cdn_unid_neg = tt-unid-negoc.cdn_unid_neg.
&Scoped-define TABLES-IN-QUERY-br-canal-unid tt-unid-neg-canal-vend
&Scoped-define FIRST-TABLE-IN-QUERY-br-canal-unid tt-unid-neg-canal-vend


/* Definitions for BROWSE br-canal-venda                                */
&Scoped-define FIELDS-IN-QUERY-br-canal-venda tt-canal-venda.cod-canal-venda tt-canal-venda.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-canal-venda   
&Scoped-define SELF-NAME br-canal-venda
&Scoped-define QUERY-STRING-br-canal-venda FOR EACH tt-canal-venda
&Scoped-define OPEN-QUERY-br-canal-venda OPEN QUERY {&SELF-NAME} FOR EACH tt-canal-venda .
&Scoped-define TABLES-IN-QUERY-br-canal-venda tt-canal-venda
&Scoped-define FIRST-TABLE-IN-QUERY-br-canal-venda tt-canal-venda


/* Definitions for BROWSE br-unid-negoc                                 */
&Scoped-define FIELDS-IN-QUERY-br-unid-negoc tt-unid-negoc.cdn_unid_negoc tt-unid-negoc.cod_unid_negoc tt-unid-negoc.des_unid_negoc   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-unid-negoc   
&Scoped-define SELF-NAME br-unid-negoc
&Scoped-define QUERY-STRING-br-unid-negoc FOR EACH tt-unid-negoc
&Scoped-define OPEN-QUERY-br-unid-negoc OPEN QUERY {&SELF-NAME} FOR EACH tt-unid-negoc.
&Scoped-define TABLES-IN-QUERY-br-unid-negoc tt-unid-negoc
&Scoped-define FIRST-TABLE-IN-QUERY-br-unid-negoc tt-unid-negoc


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-canal-unid}~
    ~{&OPEN-QUERY-br-canal-venda}~
    ~{&OPEN-QUERY-br-unid-negoc}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button RECT-1 RECT-2 br-unid-negoc ~
br-canal-venda bt-add bt-del br-canal-unid bt-ok bt-ajuda 

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
DEFINE BUTTON bt-add 
     LABEL "Adicionar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-del 
     LABEL "Remover" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-imprime 
     LABEL "&Imprimir" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 95 BY 8.25.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 95 BY 5.46.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 95.57 BY 1.38
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-canal-unid FOR 
      tt-unid-neg-canal-vend SCROLLING.

DEFINE QUERY br-canal-venda FOR 
      tt-canal-venda SCROLLING.

DEFINE QUERY br-unid-negoc FOR 
      tt-unid-negoc SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-canal-unid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-canal-unid w-cadsim _FREEFORM
  QUERY br-canal-unid DISPLAY
      tt-unid-neg-canal-vend.cdn_unid_negoc 
tt-unid-neg-canal-vend.cod-canal-venda
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90.86 BY 4.5
         FONT 7
         TITLE "Unidade de Neg¢cio x Canal de Venda" FIT-LAST-COLUMN.

DEFINE BROWSE br-canal-venda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-canal-venda w-cadsim _FREEFORM
  QUERY br-canal-venda DISPLAY
      tt-canal-venda.cod-canal-venda 
tt-canal-venda.descricao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 44 BY 7.5
         FONT 7
         TITLE "Canal de Venda" FIT-LAST-COLUMN.

DEFINE BROWSE br-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-unid-negoc w-cadsim _FREEFORM
  QUERY br-unid-negoc DISPLAY
      tt-unid-negoc.cdn_unid_negoc
tt-unid-negoc.cod_unid_negoc
tt-unid-negoc.des_unid_negoc
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 44 BY 7.5
         FONT 7
         TITLE "Unidade de Neg¢cio" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     br-unid-negoc AT ROW 1.5 COL 4.14 WIDGET-ID 200
     br-canal-venda AT ROW 1.5 COL 50.86 WIDGET-ID 300
     bt-add AT ROW 9.75 COL 33.14 WIDGET-ID 6
     bt-del AT ROW 9.75 COL 50.86 WIDGET-ID 8
     br-canal-unid AT ROW 11.67 COL 4.14 WIDGET-ID 400
     bt-ok AT ROW 16.92 COL 2.43
     bt-cancela AT ROW 16.92 COL 13.43
     bt-imprime AT ROW 16.92 COL 24.43
     bt-ajuda AT ROW 16.92 COL 85.43
     rt-button AT ROW 16.71 COL 1.43
     RECT-1 AT ROW 1.25 COL 2 WIDGET-ID 2
     RECT-2 AT ROW 11.17 COL 2 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 96.14 BY 17.13
         FONT 7 WIDGET-ID 100.


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
         HEIGHT             = 17.25
         WIDTH              = 97.43
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 115.57
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 115.57
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
/* BROWSE-TAB br-unid-negoc RECT-2 f-cad */
/* BROWSE-TAB br-canal-venda br-unid-negoc f-cad */
/* BROWSE-TAB br-canal-unid bt-del f-cad */
ASSIGN 
       bt-ajuda:POPUP-MENU IN FRAME f-cad       = MENU POPUP-MENU-bt-ajuda:HANDLE.

/* SETTINGS FOR BUTTON bt-cancela IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       bt-cancela:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR BUTTON bt-imprime IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       bt-imprime:HIDDEN IN FRAME f-cad           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-canal-unid
/* Query rebuild information for BROWSE br-canal-unid
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-unid-neg-canal-vend WHERE tt-unid-neg-canal-vend.cdn_unid_neg = tt-unid-negoc.cdn_unid_neg.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-canal-unid */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-canal-venda
/* Query rebuild information for BROWSE br-canal-venda
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-canal-venda .
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-canal-venda */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-unid-negoc
/* Query rebuild information for BROWSE br-unid-negoc
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-unid-negoc.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-unid-negoc */
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


&Scoped-define BROWSE-NAME br-canal-venda
&Scoped-define SELF-NAME br-canal-venda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-canal-venda w-cadsim
ON VALUE-CHANGED OF br-canal-venda IN FRAME f-cad /* Canal de Venda */
DO:
  {&OPEN-QUERY-br-canal-unid}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-unid-negoc
&Scoped-define SELF-NAME br-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-unid-negoc w-cadsim
ON VALUE-CHANGED OF br-unid-negoc IN FRAME f-cad /* Unidade de Neg¢cio */
DO:
  {&OPEN-QUERY-br-canal-unid}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-add w-cadsim
ON CHOOSE OF bt-add IN FRAME f-cad /* Adicionar */
DO:
  IF  AVAIL tt-unid-negoc
  AND AVAIL tt-canal-venda THEN DO:
      IF CAN-FIND (FIRST unid-neg-canal-venda
                   WHERE unid-neg-canal-venda.cod-canal-venda = tt-canal-venda.cod-canal-venda) THEN DO:
          RUN utp/ut-msgs.p (INPUT "SHOW",
                             INPUT "17006",
                             INPUT "J  existe relacionamento para unidade e canal informados.").
          RETURN NO-APPLY.
      END.
      ELSE DO:
          CREATE unid-neg-canal-venda.
          ASSIGN unid-neg-canal-venda.cdn_unid_negoc  = tt-unid-negoc.cdn_unid_negoc  
                 unid-neg-canal-venda.cod-canal-venda = tt-canal-venda.cod-canal-venda.

          CREATE tt-unid-neg-canal-vend.
          ASSIGN tt-unid-neg-canal-vend.cdn_unid_negoc  = tt-unid-negoc.cdn_unid_negoc  
                 tt-unid-neg-canal-vend.cod-canal-venda = tt-canal-venda.cod-canal-venda.
      END.
      {&OPEN-QUERY-br-canal-unid}
  END.
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


&Scoped-define SELF-NAME bt-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del w-cadsim
ON CHOOSE OF bt-del IN FRAME f-cad /* Remover */
DO:
  IF AVAIL tt-unid-neg-canal-vend THEN DO:
      FIND FIRST unid-neg-canal-venda EXCLUSIVE-LOCK
          WHERE unid-neg-canal-venda.cdn_unid_negoc  = tt-unid-neg-canal-vend.cdn_unid_negoc
            AND unid-neg-canal-venda.cod-canal-venda = tt-unid-neg-canal-vend.cod-canal-venda NO-ERROR.
      
      IF AVAIL unid-neg-canal-venda THEN DO:
          DELETE unid-neg-canal-venda.
      END.
      DELETE tt-unid-neg-canal-vend.
  END.

  {&OPEN-QUERY-br-canal-unid}
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
  RUN notify ('update-record':U).
  if return-value <> "adm-error":U then
     apply "close":U to this-procedure.
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


&Scoped-define BROWSE-NAME br-canal-unid
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
  ENABLE rt-button RECT-1 RECT-2 br-unid-negoc br-canal-venda bt-add bt-del 
         br-canal-unid bt-ok bt-ajuda 
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

  {utp/ut9000.i "esftp9004" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  RUN dispatch  IN this-procedure ('enable-fields':U).

  {include/i-inifld.i}

  RUN pi-carrega.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega w-cadsim 
PROCEDURE pi-carrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE tt-unid-negoc.

FOR EACH unid_negoc NO-LOCK:
    CREATE tt-unid-negoc.
    ASSIGN tt-unid-negoc.cdn_unid_negoc = unid_negoc.cdn_unid_negoc
           tt-unid-negoc.cod_unid_negoc = unid_negoc.cod_unid_negoc
           tt-unid-negoc.des_unid_negoc = unid_negoc.des_unid_negoc.
END.

EMPTY TEMP-TABLE tt-canal-venda.

FOR EACH canal-venda 
    WHERE canal-venda.cod-canal-venda = 7 
       OR canal-venda.cod-canal-venda = 8 
       OR canal-venda.cod-canal-venda >= 600  NO-LOCK:

    CREATE tt-canal-venda.
    ASSIGN tt-canal-venda.cod-canal-venda = canal-venda.cod-canal-venda
           tt-canal-venda.descricao       = canal-venda.descricao.     
END.

EMPTY TEMP-TABLE tt-unid-neg-canal-vend.
FOR EACH unid-neg-canal-venda NO-LOCK:
    CREATE tt-unid-neg-canal-vend.
    ASSIGN tt-unid-neg-canal-vend.cdn_unid_negoc  = unid-neg-canal-venda.cdn_unid_negoc  
           tt-unid-neg-canal-vend.cod-canal-venda = unid-neg-canal-venda.cod-canal-venda.
END.

{&OPEN-QUERY-br-canal-venda}
{&OPEN-QUERY-br-unid-negoc}
{&OPEN-QUERY-br-canal-unid}

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-unid-negoc"}
  {src/adm/template/snd-list.i "tt-canal-venda"}
  {src/adm/template/snd-list.i "tt-unid-neg-canal-vend"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

