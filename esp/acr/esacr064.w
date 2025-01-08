&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i ESACR064 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESACR064 ACR}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

DEFINE TEMP-TABLE tt_excecao_envio_sc
    FIELD raiz_cnpj LIKE excecao_envio_sc.raiz_cnpj
    FIELD nom_cliente AS CHAR FORMAT "X(40)"
    FIELD lg_devolucao AS LOGICAL
    FIELD lg_cancelamento AS LOGICAL
    INDEX idx_excecao raiz_cnpj.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-excecoes

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt_excecao_envio_sc

/* Definitions for BROWSE br-excecoes                                   */
&Scoped-define FIELDS-IN-QUERY-br-excecoes tt_excecao_envio_sc.raiz_cnpj tt_excecao_envio_sc.nom_cliente tt_excecao_envio_sc.lg_devolucao tt_excecao_envio_sc.lg_cancelamento   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-excecoes   
&Scoped-define SELF-NAME br-excecoes
&Scoped-define QUERY-STRING-br-excecoes FOR EACH tt_excecao_envio_sc NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-excecoes OPEN QUERY {&SELF-NAME} FOR EACH tt_excecao_envio_sc NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-excecoes tt_excecao_envio_sc
&Scoped-define FIRST-TABLE-IN-QUERY-br-excecoes tt_excecao_envio_sc


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br-excecoes}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 v_cdn_cliente ~
v_nom_abrev v_cod_cnpj lg-devolucao bt_gravar-2 bt_gravar lg-cancelamento ~
br-excecoes bt-ok bt-cancelar bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS v_cdn_cliente v_nom_abrev v_cod_cnpj ~
v_raiz_cnpj v_nom_cliente lg-devolucao lg-cancelamento 

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

DEFINE BUTTON bt_gravar 
     IMAGE-UP FILE "image/im-ok.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-chck2.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE BUTTON bt_gravar-2 
     IMAGE-UP FILE "image/gr-eli.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE VARIABLE v_cdn_cliente AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "C¢digo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE v_cod_cnpj AS CHARACTER FORMAT "99.999.999/9999-99":U INITIAL "000000000000000" 
     LABEL "CNPJ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE v_nom_abrev AS CHARACTER FORMAT "X(12)":U 
     LABEL "Nome Abrev" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE v_nom_cliente AS CHARACTER FORMAT "X(40)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE v_raiz_cnpj AS CHARACTER FORMAT "99.999.999":U 
     LABEL "Raiz CPNJ" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 48 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48 BY 3.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48 BY 4.

DEFINE VARIABLE lg-cancelamento AS LOGICAL INITIAL yes 
     LABEL "NÆo Envia Cancelamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.

DEFINE VARIABLE lg-devolucao AS LOGICAL INITIAL yes 
     LABEL "NÆo Envia Devolu‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-excecoes FOR 
      tt_excecao_envio_sc SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-excecoes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-excecoes w-window _FREEFORM
  QUERY br-excecoes NO-LOCK DISPLAY
      tt_excecao_envio_sc.raiz_cnpj FORMAT "99999999":U
      tt_excecao_envio_sc.nom_cliente FORMAT "X(40)":U COLUMN-LABEL "Cliente"
      tt_excecao_envio_sc.lg_devolucao FORMAT "X/":U COLUMN-LABEL "Devol"
      tt_excecao_envio_sc.lg_cancelamento FORMAT "X/":U COLUMN-LABEL "Can"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 48 BY 8.25 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     v_cdn_cliente AT ROW 1.5 COL 13 COLON-ALIGNED WIDGET-ID 2
     v_nom_abrev AT ROW 2.5 COL 13 COLON-ALIGNED WIDGET-ID 4
     v_cod_cnpj AT ROW 3.5 COL 13 COLON-ALIGNED WIDGET-ID 6
     v_raiz_cnpj AT ROW 5.25 COL 13 COLON-ALIGNED WIDGET-ID 14
     v_nom_cliente AT ROW 6.25 COL 13 COLON-ALIGNED WIDGET-ID 20
     lg-devolucao AT ROW 7.25 COL 15 WIDGET-ID 16
     bt_gravar-2 AT ROW 7.63 COL 40.86 WIDGET-ID 30
     bt_gravar AT ROW 7.63 COL 45 WIDGET-ID 8
     lg-cancelamento AT ROW 8.04 COL 15 WIDGET-ID 18
     br-excecoes AT ROW 9.25 COL 2 WIDGET-ID 200
     bt-ok AT ROW 18 COL 3
     bt-cancelar AT ROW 18 COL 14
     bt-ajuda AT ROW 18 COL 39
     "Busca:" VIEW-AS TEXT
          SIZE 7 BY .67 AT ROW 1 COL 3 WIDGET-ID 28
     RECT-1 AT ROW 17.75 COL 2
     RECT-2 AT ROW 1.25 COL 2 WIDGET-ID 10
     RECT-3 AT ROW 5 COL 2 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 50 BY 18.42 WIDGET-ID 100.


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
         TITLE              = "<insert Custom SmartWindow title>"
         HEIGHT             = 18.42
         WIDTH              = 49.86
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
/* BROWSE-TAB br-excecoes lg-cancelamento F-Main */
/* SETTINGS FOR FILL-IN v_nom_cliente IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v_raiz_cnpj IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-excecoes
/* Query rebuild information for BROWSE br-excecoes
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt_excecao_envio_sc NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-excecoes */
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


&Scoped-define BROWSE-NAME br-excecoes
&Scoped-define SELF-NAME br-excecoes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-excecoes w-window
ON MOUSE-SELECT-CLICK OF br-excecoes IN FRAME F-Main
DO:
    GET CURRENT br-excecoes.
    IF AVAIL tt_excecao_envio_sc THEN DO:
        ASSIGN v_raiz_cnpj = tt_excecao_envio_sc.raiz_cnpj
               v_nom_cliente = tt_excecao_envio_sc.nom_cliente
               lg-devolucao = tt_excecao_envio_sc.lg_devolucao
               lg-cancelamento = tt_excecao_envio_sc.lg_cancelamento.
        DISPLAY v_raiz_cnpj
                v_nom_cliente
                lg-devolucao
                lg-cancelamento
            WITH FRAME {&FRAME-NAME}.
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


&Scoped-define SELF-NAME bt_gravar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_gravar w-window
ON CHOOSE OF bt_gravar IN FRAME F-Main
DO:

    ASSIGN v_raiz_cnpj = INPUT FRAME {&FRAME-NAME} v_raiz_cnpj
           v_nom_cliente = INPUT FRAME {&FRAME-NAME} v_nom_cliente
           lg-devolucao = INPUT FRAME {&FRAME-NAME} lg-devolucao
           lg-cancelamento = INPUT FRAME {&FRAME-NAME} lg-cancelamento.

    IF v_raiz_cnpj = "" THEN
        RETURN NO-APPLY.

    FIND excecao_envio_sc EXCLUSIVE-LOCK
        WHERE excecao_envio_sc.raiz_cnpj = v_raiz_cnpj
        NO-ERROR.
    IF NOT AVAIL excecao_envio_sc THEN DO:
        CREATE excecao_envio_sc.
        ASSIGN excecao_envio_sc.raiz_cnpj = v_raiz_cnpj.
    END.
    ASSIGN excecao_envio_sc.lg_devolucao = lg-devolucao
          excecao_envio_sc.lg_cancelamento = lg-cancelamento.
  
    RUN pi-carrega-tt-browse.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_gravar-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_gravar-2 w-window
ON CHOOSE OF bt_gravar-2 IN FRAME F-Main
DO:

    ASSIGN v_raiz_cnpj = INPUT FRAME {&FRAME-NAME} v_raiz_cnpj
           v_nom_cliente = INPUT FRAME {&FRAME-NAME} v_nom_cliente
           lg-devolucao = INPUT FRAME {&FRAME-NAME} lg-devolucao
           lg-cancelamento = INPUT FRAME {&FRAME-NAME} lg-cancelamento.

    IF v_raiz_cnpj = "" THEN
        RETURN NO-APPLY.

    FIND excecao_envio_sc EXCLUSIVE-LOCK
        WHERE excecao_envio_sc.raiz_cnpj = v_raiz_cnpj
        NO-ERROR.
    IF AVAIL excecao_envio_sc THEN
        DELETE excecao_envio_sc.
  
    RUN pi-carrega-tt-browse.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v_cdn_cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v_cdn_cliente w-window
ON LEAVE OF v_cdn_cliente IN FRAME F-Main /* C¢digo */
DO:
  RUN pi-busca-cliente.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v_cod_cnpj
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v_cod_cnpj w-window
ON LEAVE OF v_cod_cnpj IN FRAME F-Main /* CNPJ */
DO:
  RUN pi-busca-cliente.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v_nom_abrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v_nom_abrev w-window
ON LEAVE OF v_nom_abrev IN FRAME F-Main /* Nome Abrev */
DO:
  RUN pi-busca-cliente.
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
  DISPLAY v_cdn_cliente v_nom_abrev v_cod_cnpj v_raiz_cnpj v_nom_cliente 
          lg-devolucao lg-cancelamento 
      WITH FRAME F-Main IN WINDOW w-window.
  ENABLE RECT-1 RECT-2 RECT-3 v_cdn_cliente v_nom_abrev v_cod_cnpj lg-devolucao 
         bt_gravar-2 bt_gravar lg-cancelamento br-excecoes bt-ok bt-cancelar 
         bt-ajuda 
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
  
  {utp/ut9000.i "ESACR064" "1.00.00.000"}

  RUN pi-carrega-tt-browse.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-cliente w-window 
PROCEDURE pi-busca-cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-nome-matriz AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-continua AS LOGICAL  INITIAL YES   NO-UNDO.

    ASSIGN v_cdn_cliente = INPUT FRAME {&FRAME-NAME} v_cdn_cliente
           v_nom_abrev = INPUT FRAME {&FRAME-NAME} v_nom_abrev
           v_cod_cnpj = INPUT FRAME {&FRAME-NAME} v_cod_cnpj
           v_raiz_cnpj = "".

    IF v_cdn_cliente <> 0 THEN DO:
        FIND emscad.cliente NO-LOCK
            WHERE emscad.cliente.cod_empresa = v_cdn_empres_usuar
              AND emscad.cliente.cdn_cliente = v_cdn_cliente
            NO-ERROR.
        IF AVAIL cliente THEN DO:
            FIND emitente NO-LOCK
                WHERE emitente.nome-abrev = emscad.cliente.nom_abrev
                NO-ERROR.
            IF AVAIL emitente THEN DO:
                IF emitente.nome-matriz <> "" THEN DO:
                    ASSIGN c-nome-matriz = emitente.nome-matriz.
                    FIND emitente NO-LOCK
                        WHERE emitente.nome-abrev = c-nome-matriz
                        NO-ERROR.
                END.
                ASSIGN l-continua = NO.
            END.
        END.
    END.

    IF l-continua AND v_nom_abrev <> "" THEN DO:
        FIND emitente NO-LOCK
            WHERE emitente.nome-abrev = v_nom_abrev
            NO-ERROR.
        IF AVAIL emitente THEN DO:
            IF emitente.nome-matriz <> "" THEN DO:
                ASSIGN c-nome-matriz = emitente.nome-matriz.
                FIND emitente NO-LOCK
                    WHERE emitente.nome-abrev = c-nome-matriz
                    NO-ERROR.
            END.
            ASSIGN l-continua = NO.
        END.
    END.

    IF l-continua AND v_cod_cnpj > "" THEN DO:
        FIND emitente NO-LOCK
            WHERE emitente.cgc = v_cod_cnpj
            NO-ERROR.
        IF AVAIL emitente THEN DO:
            IF emitente.nome-matriz <> "" THEN DO:
                ASSIGN c-nome-matriz = emitente.nome-matriz.
                FIND emitente NO-LOCK
                    WHERE emitente.nome-abrev = c-nome-matriz
                    NO-ERROR.
            END.
            ASSIGN l-continua = NO.
        END.
    END.
    
    IF NOT l-continua AND AVAIL emitente THEN DO:
        ASSIGN v_raiz_cnpj = SUBSTRING(emitente.cgc,1,8)
               v_nom_cliente = STRING(emitente.nome-emit,"X(40)").
    END.

    IF l-continua OR NOT AVAIL emitente THEN DO:
        ASSIGN v_raiz_cnpj = ""
               v_nom_cliente = "NAO ENCONTRADO".
    END.

    DISP v_raiz_cnpj
         v_nom_cliente WITH FRAME {&FRAME-NAME}.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-tt-browse w-window 
PROCEDURE pi-carrega-tt-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE tt_excecao_envio_sc NO-ERROR.

DEFINE VARIABLE c-nome-matriz AS CHARACTER   NO-UNDO.

FOR EACH excecao_envio_sc NO-LOCK:
    FIND FIRST emitente NO-LOCK
        WHERE SUBSTRING(emitente.cgc,1,8) = excecao_envio_sc.raiz_cnpj
        NO-ERROR.
    IF AVAIL emitente THEN DO:
        IF emitente.nome-matriz <> "" THEN DO:
            ASSIGN c-nome-matriz = emitente.nome-matriz.
            FIND emitente NO-LOCK /* Reposiciona tabela emitente na matriz */
                WHERE emitente.nome-abrev = c-nome-matriz
                NO-ERROR.
        END.
    END.

    CREATE tt_excecao_envio_sc.
    ASSIGN tt_excecao_envio_sc.raiz_cnpj = excecao_envio_sc.raiz_cnpj
           tt_excecao_envio_sc.lg_devolucao = excecao_envio_sc.lg_devolucao
           tt_excecao_envio_sc.lg_cancelamento = excecao_envio_sc.lg_cancelamento
           tt_excecao_envio_sc.nom_cliente = STRING(emitente.nome-emit,"X(40)").
END.

ASSIGN v_raiz_cnpj = ""
       v_nom_cliente = ""
       lg-devolucao = YES
       lg-cancelamento = YES.
DISP v_raiz_cnpj
     v_nom_cliente 
     lg-devolucao
     lg-cancelamento
    WITH FRAME {&FRAME-NAME}.

{&open-query-br-excecoes}

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
  {src/adm/template/snd-list.i "tt_excecao_envio_sc"}

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

