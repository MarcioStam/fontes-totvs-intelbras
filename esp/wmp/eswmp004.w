&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-consim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-consim 
/*:T *******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESWMP004 2.00.00.001}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Include com a Definicao da Temp-Table RowErrors */
{method/dbotterr.i}

DEFINE TEMP-TABLE tt-doca NO-UNDO
    FIELD cod-estabel        LIKE wm-docto.cod-estabel
    FIELD des-estab          AS CHAR FORMAT "x(12)"
    FIELD cod-local          LIKE wm-docto.cod-local
    FIELD des-local          AS CHAR FORMAT "x(12)"
    FIELD cod-doca           LIKE wm-docto.cod-doca
    FIELD des-doca           AS CHAR FORMAT "x(12)"
    FIELD id-tarefa          LIKE wm-tarefa-docto.id-tarefa
    FIELD val-etiq-separacao AS DEC FORMAT ">>>>>>>>>>>>>>9"
    FIELD dt-implan-docto    LIKE wm-docto.dt-implan-docto.

DEFINE TEMP-TABLE tt-detalhe-doca NO-UNDO
    FIELD id-tarefa      LIKE wm-tarefa-docto.id-tarefa
    FIELD id-movto       LIKE wm-box-movto.id-movto
    FIELD dt-fim-tarefa  LIKE wm-tarefa-docto.dt-fim-tarefa 
    FIELD hr-fim-tarefa  LIKE wm-tarefa-docto.hr-fim-tarefa 
    FIELD cod-usuario    LIKE wm-tarefa-docto.cod-usuario
    FIELD cod-item       LIKE wm-item.cod-item
    FIELD des-item       LIKE wm-item.des-item
    FIELD localiz        As Character Format 'X(19)':U.

DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.

DEF VAR IdEtiqIni        AS DEC  INITIAL 0               NO-UNDO.
DEF VAR IdEtiqFin        AS DEC  INITIAL 999999999999999 NO-UNDO.
DEF VAR DtImplantacaoIni AS DATE INITIAL TODAY           NO-UNDO.
DEF VAR DtImplantacaoFin AS DATE INITIAL TODAY           NO-UNDO.
DEF VAR BtOk             AS LOGICAL INITIAL NO           NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-consim
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME brDetalheDoca

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-detalhe-doca tt-doca

/* Definitions for BROWSE brDetalheDoca                                 */
&Scoped-define FIELDS-IN-QUERY-brDetalheDoca tt-detalhe-doca.id-tarefa tt-detalhe-doca.localiz tt-detalhe-doca.cod-item tt-detalhe-doca.des-item tt-detalhe-doca.dt-fim-tarefa string(tt-detalhe-doca.hr-fim-tarefa,"HH:MM:SS") tt-detalhe-doca.cod-usuario   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDetalheDoca   
&Scoped-define SELF-NAME brDetalheDoca
&Scoped-define QUERY-STRING-brDetalheDoca FOR EACH tt-detalhe-doca
&Scoped-define OPEN-QUERY-brDetalheDoca OPEN QUERY {&SELF-NAME} FOR EACH tt-detalhe-doca.
&Scoped-define TABLES-IN-QUERY-brDetalheDoca tt-detalhe-doca
&Scoped-define FIRST-TABLE-IN-QUERY-brDetalheDoca tt-detalhe-doca


/* Definitions for BROWSE brDoca                                        */
&Scoped-define FIELDS-IN-QUERY-brDoca tt-doca.val-etiq-separacao tt-doca.dt-implan-docto tt-doca.cod-doca tt-doca.des-doca tt-doca.cod-estabel tt-doca.des-estab tt-doca.cod-local tt-doca.des-local   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDoca   
&Scoped-define SELF-NAME brDoca
&Scoped-define QUERY-STRING-brDoca FOR EACH tt-doca
&Scoped-define OPEN-QUERY-brDoca OPEN QUERY {&SELF-NAME} FOR EACH tt-doca.
&Scoped-define TABLES-IN-QUERY-brDoca tt-doca
&Scoped-define FIRST-TABLE-IN-QUERY-brDoca tt-doca


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-brDetalheDoca}~
    ~{&OPEN-QUERY-brDoca}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button RECT-3 RECT-4 btFiltro btAtualizar ~
btExit brDoca brDetalheDoca 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-consim AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btAtualizar 
     IMAGE-UP FILE "image/im-relo.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Atualizar".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image\im-fil":U
     IMAGE-INSENSITIVE FILE "image\ii-fil":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Op‡äes de filtro".

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 147.43 BY 10.75.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 147.43 BY 11.88.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 142.43 BY 1.46
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDetalheDoca FOR 
      tt-detalhe-doca SCROLLING.

DEFINE QUERY brDoca FOR 
      tt-doca SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDetalheDoca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDetalheDoca w-consim _FREEFORM
  QUERY brDetalheDoca DISPLAY
      tt-detalhe-doca.id-tarefa
tt-detalhe-doca.localiz LABEL "Localiza‡Æo"
tt-detalhe-doca.cod-item
tt-detalhe-doca.des-item
tt-detalhe-doca.dt-fim-tarefa
string(tt-detalhe-doca.hr-fim-tarefa,"HH:MM:SS") FORMAT "x(08)" LABEL "Hora Fim Tarefa"
tt-detalhe-doca.cod-usuario
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 141 BY 8.92 FIT-LAST-COLUMN.

DEFINE BROWSE brDoca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDoca w-consim _FREEFORM
  QUERY brDoca DISPLAY
      tt-doca.val-etiq-separacao LABEL "Etiqueta" FORMAT ">>>>>>>>>>>>>>9"
tt-doca.dt-implan-docto
tt-doca.cod-doca
tt-doca.des-doca LABEL "Descri‡Æo" FORMAT "x(12)"
tt-doca.cod-estabel
tt-doca.des-estab LABEL "Descri‡Æo" FORMAT "x(20)"
tt-doca.cod-local
tt-doca.des-local LABEL "Descri‡Æo" FORMAT "x(20)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 141.57 BY 11.13 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     btFiltro AT ROW 1.21 COL 2 WIDGET-ID 14
     btAtualizar AT ROW 1.21 COL 6.14 WIDGET-ID 10
     btExit AT ROW 1.21 COL 139.43 HELP
          "Sair" WIDGET-ID 16
     brDoca AT ROW 3.46 COL 2.43 WIDGET-ID 200
     brDetalheDoca AT ROW 15.29 COL 2.57 WIDGET-ID 300
     rt-button AT ROW 1.08 COL 1.57
     RECT-3 AT ROW 15 COL 1.57 WIDGET-ID 6
     RECT-4 AT ROW 2.96 COL 1.57 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 148.29 BY 27.54 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-consim
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-consim ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta <Insira complemento>"
         HEIGHT             = 23.38
         WIDTH              = 143.72
         MAX-HEIGHT         = 28.04
         MAX-WIDTH          = 148.29
         VIRTUAL-HEIGHT     = 28.04
         VIRTUAL-WIDTH      = 148.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-consim 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-consim
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB brDoca btExit fMain */
/* BROWSE-TAB brDetalheDoca brDoca fMain */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-consim)
THEN w-consim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDetalheDoca
/* Query rebuild information for BROWSE brDetalheDoca
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-detalhe-doca.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDetalheDoca */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDoca
/* Query rebuild information for BROWSE brDoca
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-doca.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDoca */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-consim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-consim w-consim
ON END-ERROR OF w-consim /* Consulta <Insira complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-consim w-consim
ON WINDOW-CLOSE OF w-consim /* Consulta <Insira complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDoca
&Scoped-define SELF-NAME brDoca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDoca w-consim
ON VALUE-CHANGED OF brDoca IN FRAME fMain
DO:
    RUN pi-carrega-detalhe (INPUT tt-doca.val-etiq-separacao).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAtualizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualizar w-consim
ON CHOOSE OF btAtualizar IN FRAME fMain
DO:
    RUN pi-carrega-doca.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit w-consim
ON CHOOSE OF btExit IN FRAME fMain /* Exit */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro w-consim
ON CHOOSE OF btFiltro IN FRAME fMain
DO:
  RUN esp\wmp\ESWMP004a.w (INPUT-OUTPUT IdEtiqIni,
                        INPUT-OUTPUT IdEtiqFin,
                        INPUT-OUTPUT DtImplantacaoIni,
                        INPUT-OUTPUT DtImplantacaoFin,
                        INPUT-OUTPUT BtOk).

  APPLY "CHOOSE" TO btAtualizar IN FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDetalheDoca
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-consim 


/* ***************************  Main Block  *************************** */


/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

    APPLY "CHOOSE" TO btAtualizar IN FRAME fMain.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-consim  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-consim  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-consim  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-consim)
  THEN DELETE WIDGET w-consim.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-consim  _DEFAULT-ENABLE
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
  ENABLE rt-button RECT-3 RECT-4 btFiltro btAtualizar btExit brDoca 
         brDetalheDoca 
      WITH FRAME fMain IN WINDOW w-consim.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW w-consim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-consim 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-consim 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-consim 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  /*run pi-before-initialize.*/ 

  {utp/ut9000.i "ESWMP004" "2.00.00.001"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /*run pi-after-initialize.*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-detalhe w-consim 
PROCEDURE pi-carrega-detalhe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-val-etiq-separacao LIKE es-wm-box-movto-etiq.val-etiq-separacao.

    FOR EACH tt-detalhe-doca:
        DELETE tt-detalhe-doca.
    END.
    
    FOR EACH es-wm-box-movto-etiq NO-LOCK
       WHERE es-wm-box-movto-etiq.val-etiq-separacao = p-val-etiq-separacao:

        FOR EACH wm-tarefa-docto-itens NO-LOCK
           WHERE wm-tarefa-docto-itens.id-tarefa = es-wm-box-movto-etiq.id-tarefa
             AND wm-tarefa-docto-itens.id-movto  = es-wm-box-movto-etiq.id-movto
             AND wm-tarefa-docto-itens.ind-tipo-movto = 2: /* Saida */
    
            FIND FIRST wm-box-movto NO-LOCK
                 WHERE wm-box-movto.id-movto = es-wm-box-movto-etiq.id-movto 
                   AND wm-box-movto.ind-tipo-movto = 2 NO-ERROR.
            IF NOT AVAIL wm-box-movto THEN NEXT.

            FIND FIRST wm-box NO-LOCK
                 WHERE wm-box.cod-estabel = wm-box-movto.cod-estabel
                 AND   wm-box.cod-local   = wm-box-movto.cod-local
                 AND   wm-box.id-box      = wm-box-movto.id-box NO-ERROR.

            FIND FIRST wm-item NO-LOCK
                 WHERE wm-item.cod-item = wm-box-movto.cod-item NO-ERROR.

                CREATE tt-detalhe-doca.
                ASSIGN tt-detalhe-doca.id-movto       = es-wm-box-movto-etiq.id-movto
                       tt-detalhe-doca.localiz        = wm-box.cod-bloco   + '/':U + 
                                                        wm-box.cod-rua     + '/':U + 
                                                        wm-box.cod-nivel   + '/':U + 
                                                        wm-box.cod-coluna  + '/':U + 
                                                        If wm-box.ind-posicao-box = 1 Then 'E' Else 'D'
                       tt-detalhe-doca.id-tarefa      = es-wm-box-movto-etiq.id-tarefa
                       tt-detalhe-doca.dt-fim-tarefa  = wm-tarefa-docto-itens.dt-fim-tarefa
                       tt-detalhe-doca.hr-fim-tarefa  = wm-tarefa-docto-itens.hr-fim-tarefa
                       tt-detalhe-doca.cod-usuario    = wm-tarefa-docto-itens.cod-usuario
                       tt-detalhe-doca.cod-item       = wm-box-movto.cod-item
                       tt-detalhe-doca.des-item       = wm-item.des-item.
        END.
    END.
    
    {&OPEN-QUERY-brDetalheDoca}
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-doca w-consim 
PROCEDURE pi-carrega-doca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp(INPUT "Aguarde, carregando Documentos...").

FOR EACH tt-doca:
    DELETE tt-doca.
END.

FOR EACH tt-detalhe-doca:
    DELETE tt-detalhe-doca.
END.

FOR EACH wm-docto NO-LOCK
   WHERE wm-docto.dt-implan-docto >= DtImplantacaoIni
     AND wm-docto.dt-implan-docto <= DtImplantacaoFin,
   FIRST es-wm-box-movto-etiq NO-LOCK
   WHERE es-wm-box-movto-etiq.val-etiq-separacao >= IdEtiqIni
     AND es-wm-box-movto-etiq.val-etiq-separacao <= IdEtiqFin
     AND es-wm-box-movto-etiq.cod-estabel         = wm-docto.cod-estabel
     AND es-wm-box-movto-etiq.cod-local           = wm-docto.cod-local
     AND es-wm-box-movto-etiq.id-docto            = wm-docto.id-docto:

    FIND FIRST wm-doca NO-LOCK
         WHERE wm-doca.cod-doca = wm-docto.cod-doca NO-ERROR.

    FIND FIRST wm-estab NO-LOCK
         WHERE wm-estab.cod-estabel = wm-docto.cod-estabel NO-ERROR.

    FIND FIRST wm-local NO-LOCK
         WHERE wm-local.cod-local = wm-docto.cod-local NO-ERROR.

    CREATE tt-doca.
    ASSIGN tt-doca.cod-doca           = wm-docto.cod-doca
          /* tt-doca.des-doca           = IF AVAIL wm-doca THEN wm-doca.des-doca ELSE ""*/
           tt-doca.cod-local          = wm-docto.cod-local
           tt-doca.cod-estabel        = wm-docto.cod-estabel
           tt-doca.id-tarefa          = es-wm-box-movto-etiq.id-tarefa
           tt-doca.val-etiq-separacao = es-wm-box-movto-etiq.val-etiq-separacao
           tt-doca.des-estab          = IF AVAIL wm-estab THEN wm-estab.nom-estabel ELSE ""
           tt-doca.des-local          = IF AVAIL wm-local THEN wm-local.nom-local   ELSE ""
           tt-doca.dt-implan-docto    = wm-docto.dt-implan-docto.
END.

RUN pi-finalizar in h-acomp.
{&OPEN-QUERY-brDoca}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-consim  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-doca"}
  {src/adm/template/snd-list.i "tt-detalhe-doca"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-consim 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  /*run pi-trata-state (p-issuer-hdl, p-state).*/ 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

