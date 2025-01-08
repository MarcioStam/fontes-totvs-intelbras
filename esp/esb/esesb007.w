&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgmov           PROGRESS
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
DEFINE VARIABLE c-lista-cod-sit-ped  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-sit-ped        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lista-cod-sit-aval AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-sit-aval       AS CHARACTER   NO-UNDO.

ASSIGN c-lista-cod-sit-ped  = "Aberto,Atendido Parcial,Atendido Total,Pendente,Suspenso,Cancelado,Fatur BalcÆo"
       c-lista-cod-sit-aval = "NÆo Avaliado,Avaliado,Aprovado,NÆo Aprovado,Pendente Informa‡Æo".

DEFINE TEMP-TABLE tt-ped-venda LIKE ped-venda
    FIELD r-rowid AS ROWID.

{utp\ut-glob.i}
{method/dbotterr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-pedidos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ped-venda

/* Definitions for BROWSE br-pedidos                                    */
&Scoped-define FIELDS-IN-QUERY-br-pedidos tt-ped-venda.nr-pedido tt-ped-venda.dt-emissao tt-ped-venda.dt-entrega tt-ped-venda.cod-cond-pag tt-ped-venda.nome-transp tt-ped-venda.cod-canal-venda entry(tt-ped-venda.cod-sit-ped, c-lista-cod-sit-ped) @ c-cod-sit-ped entry(tt-ped-venda.cod-sit-aval, c-lista-cod-sit-aval) @ c-cod-sit-aval tt-ped-venda.cod-priori tt-ped-venda.observacoes tt-ped-venda.cond-espec   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-pedidos   
&Scoped-define SELF-NAME br-pedidos
&Scoped-define QUERY-STRING-br-pedidos FOR EACH tt-ped-venda
&Scoped-define OPEN-QUERY-br-pedidos OPEN QUERY {&SELF-NAME} FOR EACH tt-ped-venda.
&Scoped-define TABLES-IN-QUERY-br-pedidos tt-ped-venda
&Scoped-define FIRST-TABLE-IN-QUERY-br-pedidos tt-ped-venda


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-pedidos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button RECT-1 nr-pedido-ini nr-pedido-fim ~
bt-seleciona dt-emissao-ini dt-emissao-fim br-pedidos bt-altera bt-suspend ~
bt-ok 
&Scoped-Define DISPLAYED-OBJECTS nr-pedido-ini nr-pedido-fim dt-emissao-ini ~
dt-emissao-fim 

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

DEFINE BUTTON bt-altera 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Alterar" 
     SIZE 4 BY 1.08.

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

DEFINE BUTTON bt-seleciona 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "" 
     SIZE 4 BY 1.08.

DEFINE BUTTON bt-suspend 
     IMAGE-UP FILE "image\im-ngrava":U
     IMAGE-INSENSITIVE FILE "image\ii-ngrava":U
     LABEL "Button 1" 
     SIZE 4 BY 1.08.

DEFINE VARIABLE dt-emissao-fim LIKE ped-venda.dt-emissao
     VIEW-AS FILL-IN 
     SIZE 13.86 BY .88 NO-UNDO.

DEFINE VARIABLE dt-emissao-ini LIKE ped-venda.dt-emissao
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE nr-pedido-fim AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE nr-pedido-ini LIKE ped-venda.nr-pedido
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 107.57 BY 2.5.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 110 BY 1.38
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-pedidos FOR 
      tt-ped-venda SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-pedidos w-cadsim _FREEFORM
  QUERY br-pedidos DISPLAY
      tt-ped-venda.nr-pedido
      tt-ped-venda.dt-emissao
      tt-ped-venda.dt-entrega
      tt-ped-venda.cod-cond-pag COLUMN-LABEL "Cond. Pag."
      tt-ped-venda.nome-transp WIDTH 13
      tt-ped-venda.cod-canal-venda
entry(tt-ped-venda.cod-sit-ped,  c-lista-cod-sit-ped)  @ c-cod-sit-ped  FORMAT "x(20)":U COLUMN-LABEL "Situa‡Æo"
entry(tt-ped-venda.cod-sit-aval, c-lista-cod-sit-aval) @ c-cod-sit-aval FORMAT "x(19)":U COLUMN-LABEL "Aval. Cr‚d."
      tt-ped-venda.cod-priori COLUMN-LABEL "Prioridade"
      tt-ped-venda.observacoes
      tt-ped-venda.cond-espec
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 107.57 BY 10.5
         FONT 7
         TITLE "Pedidos" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     nr-pedido-ini AT ROW 1.75 COL 37 COLON-ALIGNED HELP
          "N£mero do pedido" WIDGET-ID 2
     nr-pedido-fim AT ROW 1.75 COL 55 COLON-ALIGNED HELP
          "N£mero do pedido" NO-LABEL WIDGET-ID 6
     bt-seleciona AT ROW 2.63 COL 71.86 WIDGET-ID 52
     dt-emissao-ini AT ROW 2.75 COL 37 COLON-ALIGNED HELP
          "Data em que o pedido foi emitido pelo representante/cliente" WIDGET-ID 56
     dt-emissao-fim AT ROW 2.75 COL 55.14 COLON-ALIGNED HELP
          "Data em que o pedido foi emitido pelo representante/cliente" NO-LABEL WIDGET-ID 58
     br-pedidos AT ROW 4.5 COL 3.29 HELP
          "" WIDGET-ID 200
     bt-altera AT ROW 15.21 COL 3.43 WIDGET-ID 60
     bt-suspend AT ROW 15.21 COL 7.72 WIDGET-ID 64
     bt-ok AT ROW 16.96 COL 4
     bt-cancela AT ROW 16.96 COL 14
     bt-imprime AT ROW 16.96 COL 25
     bt-ajuda AT ROW 16.96 COL 101
     rt-button AT ROW 16.75 COL 2
     RECT-1 AT ROW 1.5 COL 3.29 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 111.29 BY 17.29
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
         HEIGHT             = 17.33
         WIDTH              = 112.14
         MAX-HEIGHT         = 22.54
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22.54
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
/* BROWSE-TAB br-pedidos dt-emissao-fim f-cad */
/* SETTINGS FOR BUTTON bt-ajuda IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       bt-ajuda:HIDDEN IN FRAME f-cad           = TRUE
       bt-ajuda:POPUP-MENU IN FRAME f-cad       = MENU POPUP-MENU-bt-ajuda:HANDLE.

/* SETTINGS FOR BUTTON bt-cancela IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       bt-cancela:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR BUTTON bt-imprime IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       bt-imprime:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR FILL-IN dt-emissao-fim IN FRAME f-cad
   LIKE = mgmov.ped-venda.dt-emissao EXP-SIZE                          */
/* SETTINGS FOR FILL-IN dt-emissao-ini IN FRAME f-cad
   LIKE = mgmov.ped-venda.dt-emissao EXP-SIZE                          */
/* SETTINGS FOR FILL-IN nr-pedido-ini IN FRAME f-cad
   LIKE = mgmov.ped-venda.nr-pedido EXP-SIZE                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-pedidos
/* Query rebuild information for BROWSE br-pedidos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ped-venda.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-pedidos */
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


&Scoped-define SELF-NAME bt-altera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-altera w-cadsim
ON CHOOSE OF bt-altera IN FRAME f-cad /* Alterar */
DO:
    IF AVAIL tt-ped-venda THEN DO:
        RUN esp/esb/esesb007a.w (INPUT tt-ped-venda.r-rowid).
    END.

    FIND FIRST ped-venda NO-LOCK
         WHERE ROWID(ped-venda) = tt-ped-venda.r-rowid NO-ERROR.

    BUFFER-COPY ped-venda TO tt-ped-venda.

    br-pedidos:REFRESH().
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
  RUN notify ('update-record':U).
  if return-value <> "adm-error":U then
     apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-seleciona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-seleciona w-cadsim
ON CHOOSE OF bt-seleciona IN FRAME f-cad
DO:
  RUN pi-carrega-dados.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-suspend
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-suspend w-cadsim
ON CHOOSE OF bt-suspend IN FRAME f-cad /* Button 1 */
DO: 

    DEFINE VARIABLE i-cod-motivo     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-desc-motivo    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE da-data          AS DATE        NO-UNDO.
    DEFINE VARIABLE l-resultado      AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE bo-ped-venda-rct AS HANDLE      NO-UNDO.
    DEFINE VARIABLE bo-ped-venda-sus AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hShowMsg         AS HANDLE      NO-UNDO.


    RUN pdp/pd4000a.w(INPUT  (IF  tt-ped-venda.cod-sit-ped = 5
                                  THEN "Reativa‡Æo"
                                  ELSE "SuspensÆo"),
                      OUTPUT i-cod-motivo,
                      OUTPUT c-desc-motivo,
                      OUTPUT da-data,
                      OUTPUT l-resultado).

    IF l-resultado THEN DO:
    
        IF  tt-ped-venda.cod-sit-ped = 5 THEN DO:

            IF  SESSION:SET-WAIT-STATE("general") THEN.
                IF NOT VALID-HANDLE(bo-ped-venda-rct) 
                OR bo-ped-venda-rct:TYPE <> "PROCEDURE":U 
                OR bo-ped-venda-rct:FILE-NAME <> "dibo/bodi159rct.p":U THEN
                     RUN dibo/bodi159rct.p PERSISTENT SET bo-ped-venda-rct.

            RUN setUserLog IN bo-ped-venda-rct (INPUT c-seg-usuario).

            RUN validateReactivation IN bo-ped-venda-rct (INPUT  tt-ped-venda.r-rowid,
                                                          OUTPUT TABLE Rowerrors).

            IF SESSION:SET-WAIT-STATE("") THEN.

            IF CAN-FIND(first RowErrors) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal=YES} 
            END.
    
            IF NOT CAN-FIND(FIRST RowErrors
                            WHERE RowErrors.ErrorSubType = "Error":U) THEN DO:

                RUN emptyRowErrors IN bo-ped-venda-rct.                        
                RUN updateReactivation IN bo-ped-venda-rct (INPUT  tt-ped-venda.r-rowid,
                                                            INPUT  tt-ped-venda.cod-mot-canc-cot,
                                                            INPUT  c-desc-motivo).
                RUN getRowErrors IN bo-ped-venda-rct (OUTPUT TABLE RowErrors). 
                IF CAN-FIND(FIRST RowErrors) THEN DO:
                    {method/showmessage.i1}
                    {method/showmessage.i2 &Modal=YES} 
                END.                                                       
                
            END.
        END.
        ELSE DO:

            IF NOT VALID-HANDLE(bo-ped-venda-sus) 
            OR bo-ped-venda-sus:type <> "PROCEDURE":U 
            OR bo-ped-venda-sus:FILE-NAME <> "dibo/bodi159sus.p":U THEN
                RUN dibo/bodi159sus.p PERSISTENT SET bo-ped-venda-sus.
               

            RUN setUserLog IN bo-ped-venda-sus (INPUT c-seg-usuario).               

            IF SESSION:SET-WAIT-STATE("general") THEN.

            RUN validateSuspension IN bo-ped-venda-sus (INPUT  tt-ped-venda.r-rowid,
                                                        OUTPUT TABLE Rowerrors).

            IF SESSION:SET-WAIT-STATE("") THEN.

            IF CAN-FIND(FIRST RowErrors) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal=YES} 
            END.
    

            IF NOT CAN-FIND(FIRST RowErrors
                            WHERE RowErrors.ErrorSubType = "Error":U) THEN DO:
                RUN updateSuspension in bo-ped-venda-sus (INPUT tt-ped-venda.r-rowid,
                                                          INPUT tt-ped-venda.cod-mot-canc-cot,
                                                          INPUT c-desc-motivo).

                RUN getRowErrors IN bo-ped-venda-sus (OUTPUT TABLE RowErrors). 
                IF CAN-FIND(FIRST RowErrors) THEN DO:
                    {method/showmessage.i1}
                    {method/showmessage.i2 &Modal=YES} 
                END.                                                       
            END.
        END.
     END.

     FIND FIRST ped-venda NO-LOCK
         WHERE ROWID(ped-venda) = tt-ped-venda.r-rowid NO-ERROR.

    BUFFER-COPY ped-venda TO tt-ped-venda.

    br-pedidos:REFRESH().
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


&Scoped-define BROWSE-NAME br-pedidos
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
  DISPLAY nr-pedido-ini nr-pedido-fim dt-emissao-ini dt-emissao-fim 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE rt-button RECT-1 nr-pedido-ini nr-pedido-fim bt-seleciona 
         dt-emissao-ini dt-emissao-fim br-pedidos bt-altera bt-suspend bt-ok 
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

  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch  IN this-procedure ('enable-fields':U).

  {include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-dados w-cadsim 
PROCEDURE pi-carrega-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE tt-ped-venda.

/*FOR EACH atendente NO-LOCK
   WHERE atendente.user_magnus = c-seg-usuario:*/

    FOR EACH ped-venda NO-LOCK
       WHERE ped-venda.nr-pedido  >= INPUT FRAME f-cad nr-pedido-ini
         AND ped-venda.nr-pedido  <= INPUT FRAME f-cad nr-pedido-fim
         AND ped-venda.dt-emissao >= INPUT FRAME f-cad dt-emissao-ini
         AND ped-venda.dt-emissao <= INPUT FRAME f-cad dt-emissao-fim
          /*AND ped-venda.tp-pedido  = STRING(atendente.cd-oper)*/:

        CREATE tt-ped-venda.
        BUFFER-COPY ped-venda TO tt-ped-venda.
        ASSIGN tt-ped-venda.r-rowid = ROWID(ped-venda).

    END.

/*END.*/

{&OPEN-QUERY-br-pedidos}

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
  {src/adm/template/snd-list.i "tt-ped-venda"}

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

