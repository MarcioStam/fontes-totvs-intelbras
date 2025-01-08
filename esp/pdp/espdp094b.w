&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
          mgmov            PROGRESS
*/
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
{include/i-prgvrs.i ESPDP094B 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESPDP094B MFT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

DEF TEMP-TABLE tt-ped-item NO-UNDO LIKE ped-item.

DEF VAR de-vl-alocado  LIKE ped-venda.vl-tot-ped.

DEFINE VARIABLE de-saldo   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-alocado AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dt-aux     AS DATE      NO-UNDO.
DEFINE VARIABLE c-depos    AS CHARACTER NO-UNDO.

/* Parameters Definitions ---                                           */

DEF INPUT PARAM TABLE FOR tt-ped-item.
DEF INPUT PARAM p-cod-estabel LIKE ped-venda.cod-estabel NO-UNDO.
DEF INPUT PARAM p-nr-pedcli   LIKE ped-venda.nr-pedcli NO-UNDO.
DEF INPUT PARAM p-nome-abrev  LIKE ped-venda.nome-abrev NO-UNDO.


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
&Scoped-define BROWSE-NAME br-ped-item

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ped-item ITEM ped-ent

/* Definitions for BROWSE br-ped-item                                   */
&Scoped-define FIELDS-IN-QUERY-br-ped-item tt-ped-item.it-codigo ITEM.desc-item tt-ped-item.dt-entrega tt-ped-item.qt-pedida (tt-ped-item.qt-pedida - tt-ped-item.qt-atendida) @ de-saldo tt-ped-item.qt-log-aloca fnDeposAloc(ped-ent.nome-abrev ,ped-ent.nr-pedcli ,ped-ent.nr-sequencia , ped-ent.it-codigo ,ped-ent.cod-refer ,ped-ent.nr-entrega ) @ c-depos (tt-ped-item.qt-log-aloca * tt-ped-item.vl-preuni) @ de-alocado   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-ped-item   
&Scoped-define SELF-NAME br-ped-item
&Scoped-define QUERY-STRING-br-ped-item FOR EACH tt-ped-item NO-LOCK                            WHERE tt-ped-item.nome-abrev = p-nome-abrev                              AND tt-ped-item.nr-pedcli  = p-nr-pedcli, ~
                                  FIRST ITEM NO-LOCK                            WHERE ITEM.it-codigo = tt-ped-item.it-codigo, ~
                                  EACH ped-ent OF tt-ped-item NO-LOCK  INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-ped-item OPEN QUERY {&SELF-NAME} FOR EACH tt-ped-item NO-LOCK                            WHERE tt-ped-item.nome-abrev = p-nome-abrev                              AND tt-ped-item.nr-pedcli  = p-nr-pedcli, ~
                                  FIRST ITEM NO-LOCK                            WHERE ITEM.it-codigo = tt-ped-item.it-codigo, ~
                                  EACH ped-ent OF tt-ped-item NO-LOCK  INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-ped-item tt-ped-item ITEM ped-ent
&Scoped-define FIRST-TABLE-IN-QUERY-br-ped-item tt-ped-item
&Scoped-define SECOND-TABLE-IN-QUERY-br-ped-item ITEM
&Scoped-define THIRD-TABLE-IN-QUERY-br-ped-item ped-ent


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br-ped-item}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-15 br-ped-item bt-ok bt-cancelar ~
bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-estabel fi-nr-pedcli fi-cliente ~
fi-valor-alocado 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD FnDeposAloc w-window 
FUNCTION FnDeposAloc RETURNS CHARACTER
  ( c-nome-abrev    AS CHAR,  
    c-nr-pedcli     AS CHAR,  
    i-nr-sequencia  AS INT , 
    c-it-codigo     AS CHAR,  
    c-cod-refer     AS CHAR,  
    i-nr-entrega    AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
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

DEFINE VARIABLE fi-cliente AS CHARACTER FORMAT "X(12)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-pedcli AS CHARACTER FORMAT "X(16)":U 
     LABEL "Pedido" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-valor-alocado AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Alocado" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 115 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 115 BY 10.75.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-ped-item FOR 
      tt-ped-item, 
      ITEM, 
      ped-ent SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-ped-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-ped-item w-window _FREEFORM
  QUERY br-ped-item NO-LOCK DISPLAY
      tt-ped-item.it-codigo    FORMAT "x(16)":U                                                 WIDTH 9
ITEM.desc-item                                                                            WIDTH 34
tt-ped-item.dt-entrega   FORMAT '99/99/9999'                    COLUMN-LABEL "Dt.Entrega" WIDTH 9
tt-ped-item.qt-pedida    FORMAT ">>,>>>,>>9.9999":U                                       WIDTH 12
(tt-ped-item.qt-pedida - tt-ped-item.qt-atendida) @ de-saldo    COLUMN-LABEL "Qt Saldo"   WIDTH 12
tt-ped-item.qt-log-aloca FORMAT ">>,>>>,>>9.9999":U             COLUMN-LABEL "Qt Aloca"   WIDTH 12
fnDeposAloc(ped-ent.nome-abrev ,ped-ent.nr-pedcli ,ped-ent.nr-sequencia , ped-ent.it-codigo ,ped-ent.cod-refer  ,ped-ent.nr-entrega ) @ c-depos COLUMN-LABEL "Dep" WIDTH 4
(tt-ped-item.qt-log-aloca * tt-ped-item.vl-preuni) @ de-alocado COLUMN-LABEL "Vl Alocado"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 111 BY 8
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     fi-cod-estabel AT ROW 1.75 COL 14 COLON-ALIGNED WIDGET-ID 4
     fi-nr-pedcli AT ROW 1.75 COL 36 COLON-ALIGNED WIDGET-ID 6
     fi-cliente AT ROW 1.75 COL 64 COLON-ALIGNED WIDGET-ID 8
     fi-valor-alocado AT ROW 1.75 COL 97.43 COLON-ALIGNED WIDGET-ID 10
     br-ped-item AT ROW 3.25 COL 3.57 WIDGET-ID 200
     bt-ok AT ROW 12.21 COL 3
     bt-cancelar AT ROW 12.21 COL 14
     bt-ajuda AT ROW 12.21 COL 104.57
     RECT-1 AT ROW 12 COL 1
     RECT-15 AT ROW 1.25 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 116 BY 12.58
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: JanelaDetalhe
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta Itens do Pedido"
         HEIGHT             = 12.5
         WIDTH              = 115.14
         MAX-HEIGHT         = 21.13
         MAX-WIDTH          = 117.14
         VIRTUAL-HEIGHT     = 21.13
         VIRTUAL-WIDTH      = 117.14
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
/* BROWSE-TAB br-ped-item fi-valor-alocado F-Main */
/* SETTINGS FOR FILL-IN fi-cliente IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cod-estabel IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nr-pedcli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-valor-alocado IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-ped-item
/* Query rebuild information for BROWSE br-ped-item
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ped-item NO-LOCK
                           WHERE tt-ped-item.nome-abrev = p-nome-abrev
                             AND tt-ped-item.nr-pedcli  = p-nr-pedcli,
                           FIRST ITEM NO-LOCK
                           WHERE ITEM.it-codigo = tt-ped-item.it-codigo,
                           EACH ped-ent OF tt-ped-item NO-LOCK  INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-ped-item */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* Consulta Itens do Pedido */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* Consulta Itens do Pedido */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-ped-item
&Scoped-define SELF-NAME br-ped-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ped-item w-window
ON ROW-DISPLAY OF br-ped-item IN FRAME F-Main
DO:
    IF (tt-ped-item.dt-entrega > TODAY AND tt-ped-item.dt-entrega < dt-aux) OR 
       tt-ped-item.dt-entrega > dt-aux THEN DO:
    
       ASSIGN tt-ped-item.it-codigo    :FGCOLOR IN BROWSE br-ped-item = 15
              ITEM.desc-item           :FGCOLOR IN BROWSE br-ped-item = 15
              tt-ped-item.dt-entrega   :FGCOLOR IN BROWSE br-ped-item = 15
              tt-ped-item.qt-pedida    :FGCOLOR IN BROWSE br-ped-item = 15
              de-saldo                 :FGCOLOR IN BROWSE br-ped-item = 15 
              tt-ped-item.qt-log-aloca :FGCOLOR IN BROWSE br-ped-item = 15
              c-depos                  :FGCOLOR IN BROWSE br-ped-item = 15
              de-alocado               :FGCOLOR IN BROWSE br-ped-item = 15.

       IF tt-ped-item.dt-entrega > dt-aux THEN
          ASSIGN tt-ped-item.it-codigo    :BGCOLOR IN BROWSE br-ped-item = 1      
                 ITEM.desc-item           :BGCOLOR IN BROWSE br-ped-item = 1
                 tt-ped-item.dt-entrega   :BGCOLOR IN BROWSE br-ped-item = 1
                 tt-ped-item.qt-pedida    :BGCOLOR IN BROWSE br-ped-item = 1
                 de-saldo                 :BGCOLOR IN BROWSE br-ped-item = 1
                 tt-ped-item.qt-log-aloca :BGCOLOR IN BROWSE br-ped-item = 1
                 c-depos                  :BGCOLOR IN BROWSE br-ped-item = 1
                 de-alocado               :BGCOLOR IN BROWSE br-ped-item = 1.
       ELSE
          ASSIGN tt-ped-item.it-codigo    :BGCOLOR IN BROWSE br-ped-item = 7      
                 ITEM.desc-item           :BGCOLOR IN BROWSE br-ped-item = 7
                 tt-ped-item.dt-entrega   :BGCOLOR IN BROWSE br-ped-item = 7
                 tt-ped-item.qt-pedida    :BGCOLOR IN BROWSE br-ped-item = 7
                 de-saldo                 :BGCOLOR IN BROWSE br-ped-item = 7
                 tt-ped-item.qt-log-aloca :BGCOLOR IN BROWSE br-ped-item = 7
                 c-depos                  :BGCOLOR IN BROWSE br-ped-item = 7
                 de-alocado               :BGCOLOR IN BROWSE br-ped-item = 7.
    END.
    

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
  apply "close":U to this-procedure.
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
  DISPLAY fi-cod-estabel fi-nr-pedcli fi-cliente fi-valor-alocado 
      WITH FRAME F-Main IN WINDOW w-window.
  ENABLE RECT-1 RECT-15 br-ped-item bt-ok bt-cancelar bt-ajuda 
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

   /* espdp094b.w */

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}
  
  {utp/ut9000.i "ESPDP094B" "1.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* atualiza campos da tela com parametros */
  ASSIGN fi-cod-estabel:SCREEN-VALUE IN FRAME f-main = p-cod-estabel
         fi-nr-pedcli  :SCREEN-VALUE IN FRAME f-main = p-nr-pedcli
         fi-cliente    :SCREEN-VALUE IN FRAME f-main = p-nome-abrev.

  assign dt-aux = DATE(MONTH(TODAY), 25,YEAR(TODAY))
         dt-aux = dt-aux + 15
         dt-aux = DATE(month(dt-aux), 01,YEAR(dt-aux)) - 1.

  FOR EACH ped-item NO-LOCK
     WHERE ped-item.nome-abrev = p-nome-abrev
       AND ped-item.nr-pedcli  = p-nr-pedcli 
       AND ped-item.cod-sit-item <= 2:

      FIND FIRST tt-ped-item OF ped-item NO-ERROR.

      IF NOT AVAIL tt-ped-item THEN DO:
         /*IF ped-item.dt-entrega <= TODAY THEN NEXT.*/

         CREATE tt-ped-item.
         BUFFER-COPY ped-item TO tt-ped-item.
      END.                                   
  END.



  /* valor alocado total */
  FOR EACH tt-ped-item
     WHERE tt-ped-item.nome-abrev = p-nome-abrev
       AND tt-ped-item.nr-pedcli  = p-nr-pedcli NO-LOCK:

      ASSIGN fi-valor-alocado = fi-valor-alocado + (tt-ped-item.qt-log-aloca * tt-ped-item.vl-preuni).             
  END.

  ASSIGN fi-valor-alocado:SCREEN-VALUE IN FRAME f-main = STRING(fi-valor-alocado).

  /* carrega browse de itens do pedido: tt-ped-item vindo da tela principal */
  {&OPEN-QUERY-br-ped-item}

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-ped-item"}
  {src/adm/template/snd-list.i "ITEM"}
  {src/adm/template/snd-list.i "ped-ent"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION FnDeposAloc w-window 
FUNCTION FnDeposAloc RETURNS CHARACTER
  ( c-nome-abrev    AS CHAR,  
    c-nr-pedcli     AS CHAR,  
    i-nr-sequencia  AS INT , 
    c-it-codigo     AS CHAR,  
    c-cod-refer     AS CHAR,  
    i-nr-entrega    AS INT) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND FIRST ped-saldo 
       WHERE ped-saldo.nome-abrev  = c-nome-abrev  
         AND ped-saldo.nr-pedcli   = c-nr-pedcli   
         AND ped-saldo.nr-seq-item = i-nr-sequencia
         AND ped-saldo.it-codigo   = c-it-codigo   
         AND ped-saldo.cod-refer   = c-cod-refer   
         AND ped-saldo.nr-entrega  = i-nr-entrega 
  NO-LOCK NO-ERROR.

  IF AVAIL ped-saldo THEN
     RETURN ped-saldo.cod-depos.   /* Function return value. */
  ELSE 
     RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

