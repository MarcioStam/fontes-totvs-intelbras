&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
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
{include/i-prgvrs.i ES0660-V01 2.00.00.001}
{upc\btb910za-upc.i}


/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever  ser MUT                    */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i es0660-v01 MUT}
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
{utp/ut-glob.i}
{utp/utapi019.i}
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
DEFINE VARIABLE de-saldo    LIKE saldo-estoq.qtidade-atu    NO-UNDO.
DEFINE VARIABLE l-mail      AS LOGICAL    INIT YES          NO-UNDO.
DEFINE VARIABLE cMensagem   AS CHARACTER                    NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES reservas-ast
&Scoped-define FIRST-EXTERNAL-TABLE reservas-ast


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR reservas-ast.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS reservas-ast.qt-reserva 
&Scoped-define ENABLED-TABLES reservas-ast
&Scoped-define FIRST-ENABLED-TABLE reservas-ast
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS reservas-ast.cod-estabel ~
reservas-ast.cod-depos reservas-ast.it-codigo reservas-ast.qt-reserva ~
reservas-ast.dt-reserva reservas-ast.cd-usuario ~
reservas-ast.dt-reserva-altera reservas-ast.cd-usuario-altera 
&Scoped-define DISPLAYED-TABLES reservas-ast
&Scoped-define FIRST-DISPLAYED-TABLE reservas-ast
&Scoped-Define DISPLAYED-OBJECTS c-desc-estab c-desc-deposito c-desc-item 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS reservas-ast.cod-estabel ~
reservas-ast.cod-depos reservas-ast.it-codigo 
&Scoped-define ADM-ASSIGN-FIELDS reservas-ast.cod-estabel ~
reservas-ast.dt-reserva reservas-ast.cd-usuario ~
reservas-ast.dt-reserva-altera reservas-ast.cd-usuario-altera 
&Scoped-define ADM-MODIFY-FIELDS reservas-ast.dt-reserva ~
reservas-ast.cd-usuario reservas-ast.dt-reserva-altera ~
reservas-ast.cd-usuario-altera 

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
DEFINE VARIABLE c-desc-deposito AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 3.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 3.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     reservas-ast.cod-estabel AT ROW 1.17 COL 20.57 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-desc-estab AT ROW 1.17 COL 28.14 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     reservas-ast.cod-depos AT ROW 2.17 COL 20.57 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-desc-deposito AT ROW 2.17 COL 28.14 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     reservas-ast.it-codigo AT ROW 3.17 COL 20.57 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-item AT ROW 3.17 COL 38.14 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     reservas-ast.qt-reserva AT ROW 4.67 COL 20.57 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     reservas-ast.dt-reserva AT ROW 5.67 COL 20.57 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     reservas-ast.cd-usuario AT ROW 5.67 COL 62.86 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     reservas-ast.dt-reserva-altera AT ROW 6.67 COL 20.57 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     reservas-ast.cd-usuario-altera AT ROW 6.67 COL 62.86 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgesp.reservas-ast
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
         HEIGHT             = 6.83
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN c-desc-deposito IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN reservas-ast.cd-usuario IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN reservas-ast.cd-usuario-altera IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN reservas-ast.cod-depos IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN reservas-ast.cod-estabel IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN reservas-ast.dt-reserva IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN reservas-ast.dt-reserva-altera IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN reservas-ast.it-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
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

&Scoped-define SELF-NAME reservas-ast.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas-ast.cod-depos V-table-Win
ON F5 OF reservas-ast.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
  
    {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                       &campo="reservas-ast.cod-depos"
                       &campozoom="cod-depos"
                       &frame="f-main"
                       &campo2="c-desc-deposito"
                       &campozoom2="nome"
                       &frame2="f-main"}
                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas-ast.cod-depos V-table-Win
ON LEAVE OF reservas-ast.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
  
    FIND FIRST deposito
        WHERE deposito.cod-depos = INPUT FRAME f-main reservas-ast.cod-depos NO-LOCK NO-ERROR.
    IF AVAIL deposito THEN
        ASSIGN c-desc-deposito:SCREEN-VALUE IN FRAME f-main = deposito.nome.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas-ast.cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF reservas-ast.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
  
    APPLY 'F5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME reservas-ast.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas-ast.cod-estabel V-table-Win
ON F5 OF reservas-ast.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  
  
    {include/zoomvar.i &prog-zoom="inzoom/z01in661.w"
                       &campo="reservas-ast.cod-estabel"
                       &campozoom="cod-estabel"
                       &frame="f-main"
                       &campo2="c-desc-estab"
                       &campozoom2="nome"
                       &frame2="f-main"}
                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas-ast.cod-estabel V-table-Win
ON LEAVE OF reservas-ast.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  
    FIND FIRST estabelec WHERE estabelec.cod-estabel = reservas-ast.cod-estabel:SCREEN-VALUE IN FRAME f-main NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN c-desc-estab:SCREEN-VALUE IN FRAME {&FRAME-NAME} = estabelec.nome.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas-ast.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF reservas-ast.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  
    APPLY 'F5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME reservas-ast.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas-ast.it-codigo V-table-Win
ON F5 OF reservas-ast.it-codigo IN FRAME f-main /* Item */
DO:
  
    {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                       &campo="reservas-ast.it-codigo"
                       &campozoom="it-codigo"
                       &frame="f-main"
                       &campo2="c-desc-item"
                       &campozoom2="desc-item"
                       &frame2="f-main"}
                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas-ast.it-codigo V-table-Win
ON LEAVE OF reservas-ast.it-codigo IN FRAME f-main /* Item */
DO:
  
    FIND FIRST item
        WHERE item.it-codigo = INPUT FRAME f-main reservas-ast.it-codigo NO-LOCK NO-ERROR.
    IF AVAIL item THEN
        ASSIGN c-desc-item:SCREEN-VALUE IN FRAME f-main = item.desc-item.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas-ast.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF reservas-ast.it-codigo IN FRAME f-main /* Item */
DO:
  
    APPLY 'F5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME reservas-ast.qt-reserva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas-ast.qt-reserva V-table-Win
ON LEAVE OF reservas-ast.qt-reserva IN FRAME f-main /* Qtd Reserva */
DO:
  
    FOR EACH saldo-estoq
        WHERE saldo-estoq.cod-estabel = reservas-ast.cod-estabel:SCREEN-VALUE IN FRAME f-main
          AND saldo-estoq.cod-depos   = reservas-ast.cod-depos  :SCREEN-VALUE IN FRAME f-main
          AND saldo-estoq.it-codigo   = reservas-ast.it-codigo  :SCREEN-VALUE IN FRAME f-main NO-LOCK:

        assign de-saldo = de-saldo + (saldo-estoq.qtidade-atu  -
                                     (saldo-estoq.qt-alocada   +
                                      saldo-estoq.qt-aloc-prod +
                                      saldo-estoq.qt-aloc-ped  )).

        IF de-saldo >= INPUT FRAME f-main reservas-ast.qt-reserva THEN DO:

            ASSIGN l-mail = NO.

            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Quantidade dispon¡vel!.~~H , em estoque, quantidade dispon¡vel para atender esta reserva.":U).
            RETURN NO-APPLY.

        END. /* IF saldo-estoq.qt-disponivel >= reservsa-ast.qt-reserva THEN DO: */

    END. /* IF AVAIL saldo-estoq THEN DO: */
    IF l-mail THEN DO:
        assign cMensagem = cMensagem + '~nReserva Gerada: Estab: ' + reservas-ast.cod-estabel:SCREEN-VALUE IN FRAME f-main  + 
                                       ', Dep¢sito: ' + reservas-ast.cod-depos:SCREEN-VALUE IN FRAME f-main                 + 
                                       ', ITEM: ' + reservas-ast.it-codigo:SCREEN-VALUE IN FRAME f-main                     + '~n'.

         /** Manda e-mail **/
         if (cMensagem <> '') THEN DO:

             FOR FIRST mgesp.ponto-programa
                 WHERE ponto-programa.nome-programa = "escep027"
                   AND ponto-programa.ponto         = 2,
                  EACH mgesp.conteudo-programa exclusive-lock
                 WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

                 run enviaMail (input 'ems@intelbras.com.br', input conteudo-programa.conteudo, input 'Reserva AST', input cMensagem).

             END. /* FOR FIRST mgesp.ponto-programa */

         END. /* if (cMensagem <> '') THEN DO: */
    END. /* IF l-mail THEN DO: */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas-ast.qt-reserva V-table-Win
ON VALUE-CHANGED OF reservas-ast.qt-reserva IN FRAME f-main /* Qtd Reserva */
DO:
  
    IF adm-new-record = YES THEN
        ASSIGN reservas-ast.dt-reserva       :SCREEN-VALUE IN FRAME f-main = string(TODAY)
               reservas-ast.cd-usuario       :SCREEN-VALUE IN FRAME f-main = c-seg-usuario
               reservas-ast.dt-reserva-altera:SCREEN-VALUE IN FRAME f-main = string(TODAY)
               reservas-ast.cd-usuario-altera:SCREEN-VALUE IN FRAME f-main = c-seg-usuario .
    ELSE
        ASSIGN reservas-ast.dt-reserva-altera:SCREEN-VALUE IN FRAME f-main = string(TODAY)
               reservas-ast.cd-usuario-altera:SCREEN-VALUE IN FRAME f-main = c-seg-usuario .

  
/*     FOR EACH saldo-estoq                                                                                                               */
/*         WHERE saldo-estoq.cod-estabel = reservas-ast.cod-estabel:SCREEN-VALUE IN FRAME f-main                                          */
/*           AND saldo-estoq.cod-depos   = reservas-ast.cod-depos  :SCREEN-VALUE IN FRAME f-main                                          */
/*           AND saldo-estoq.it-codigo   = reservas-ast.it-codigo  :SCREEN-VALUE IN FRAME f-main NO-LOCK:                                 */
/*                                                                                                                                        */
/*         ASSIGN de-saldo = de-saldo + saldo-estoq.qtidade-atu.                                                                          */
/*                                                                                                                                        */
/*         IF de-saldo >= INPUT FRAME f-main reservas-ast.qt-reserva THEN DO:                                                             */
/*                                                                                                                                        */
/*             ASSIGN l-mail = NO.                                                                                                        */
/*                                                                                                                                        */
/*             RUN utp/ut-msgs.p (INPUT "SHOW":U,                                                                                         */
/*                                INPUT 17006,                                                                                            */
/*                                INPUT "Quantidade dispon¡vel!.~~H , em estoque, quantidade dispon¡vel para atender esta reserva.":U).   */
/*             RETURN NO-APPLY.                                                                                                           */
/*                                                                                                                                        */
/*         END. /* IF saldo-estoq.qt-disponivel >= reservsa-ast.qt-reserva THEN DO: */                                                    */
/*                                                                                                                                        */
/*     END. /* IF AVAIL saldo-estoq THEN DO: */                                                                                           */
/*     IF l-mail THEN DO:                                                                                                                 */
/*         assign cMensagem = cMensagem + '~nReserva Gerada: Estab: ' + reservas-ast.cod-estabel:SCREEN-VALUE IN FRAME f-main  +          */
/*                                        ', Dep¢sito: ' + reservas-ast.cod-depos:SCREEN-VALUE IN FRAME f-main                 +          */
/*                                        ', ITEM: ' + reservas-ast.it-codigo:SCREEN-VALUE IN FRAME f-main                     + '~n'.    */
/*                                                                                                                                        */
/*          /** Manda e-mail **/                                                                                                          */
/*          if (cMensagem <> '') THEN DO:                                                                                                 */
/*                                                                                                                                        */
/*              FOR FIRST mgesp.ponto-programa                                                                                           */
/*                  WHERE ponto-programa.nome-programa = "escep027"                                                                       */
/*                    AND ponto-programa.ponto         = 2,                                                                               */
/*                   EACH mgesp.conteudo-programa exclusive-lock                                                                         */
/*                  WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:                                                   */
/*                                                                                                                                        */
/*                  run enviaMail (input 'ems@intelbras.com.br', input conteudo-programa.conteudo, input 'Reserva AST', input cMensagem). */
/*                                                                                                                                        */
/*              END. /* FOR FIRST mgesp.ponto-programa */                                                                                */
/*                                                                                                                                        */
/*          END. /* if (cMensagem <> '') THEN DO: */                                                                                      */
/*     END. /* IF l-mail THEN DO: */                                                                                                      */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  

if reservas-ast.cod-estabel :load-mouse-pointer ("image/lupa.cur") then.
if reservas-ast.cod-depos   :load-mouse-pointer ("image/lupa.cur") then.
if reservas-ast.it-codigo   :load-mouse-pointer ("image/lupa.cur") then.


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
  {src/adm/template/row-list.i "reservas-ast"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "reservas-ast"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carrega V-table-Win 
PROCEDURE carrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviaMail V-table-Win 
PROCEDURE enviaMail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    define input parameter pRemetente      as character no-undo.
    define input parameter pDestinatario   as character no-undo.
    define input parameter pAssunto        as character no-undo.
    define input parameter pMensagem       as character no-undo.
    
    define variable h-utapi019 as handle      no-undo.

    FOR EACH tt-envio2:
        DELETE tt-envio2.
    END.

    FIND FIRST param-global NO-LOCK NO-ERROR.
    IF AVAIL param-global THEN DO:
        
        create tt-envio2.
        assign tt-envio2.versao-integracao  = 1
               tt-envio2.servidor           = param-global.serv-mail
               tt-envio2.porta              = param-global.porta-mail
               tt-envio2.exchange           = param-global.log-1
               tt-envio2.remetente          = pRemetente
               tt-envio2.destino            = pDestinatario
               tt-envio2.assunto            = pAssunto
               tt-envio2.mensagem           = pMensagem
               tt-envio2.arq-anexo          = ''
               tt-envio2.importancia        = 1
               tt-envio2.log-enviada        = no
               tt-envio2.log-lida           = no
               tt-envio2.acomp              = no
               tt-envio2.formato            = 'TEXTO'.
        
    END. /* IF AVAIL param-global THEN DO: */

/*     FOR EACH tt-envio2:                                        */
/*                                                                */
/*         DISP  tt-envio2.versao-integracao                      */
/*               tt-envio2.servidor                               */
/*               tt-envio2.porta                                  */
/*               tt-envio2.exchange                               */
/*               tt-envio2.remetente                              */
/*               tt-envio2.destino                                */
/*               tt-envio2.assunto                                */
/*               tt-envio2.mensagem                               */
/*               tt-envio2.arq-anexo                              */
/*               tt-envio2.importancia                            */
/*               tt-envio2.log-enviada                            */
/*               tt-envio2.log-lida                               */
/*               tt-envio2.acomp                                  */
/*               tt-envio2.formato          WITH 1 COL WIDTH 400. */
/*                                                                */
/*     END.                                                       */


    run utp/utapi019.p persistent set h-utapi019.
    run pi-execute in h-utapi019 (input table tt-envio2, output table tt-erros).
    delete object h-utapi019.


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

    /*:T Ponha na pi-validate todas as valida‡äes */
    /*:T NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /*:T Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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
    
    FIND FIRST estabelec WHERE estabelec.cod-estabel = reservas-ast.cod-estabel:SCREEN-VALUE IN FRAME f-main NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN c-desc-estab:SCREEN-VALUE IN FRAME {&FRAME-NAME} = estabelec.nome.

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
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
    if adm-new-record = yes THEN DO:
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    END.
    &endif
    DISABLE reservas-ast.dt-reserva        WITH FRAME f-main.
    DISABLE reservas-ast.cd-usuario        WITH FRAME f-main.
    DISABLE reservas-ast.dt-reserva-altera WITH FRAME f-main.
    DISABLE reservas-ast.cd-usuario-altera WITH FRAME f-main.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND FIRST estabelec WHERE estabelec.cod-estabel = reservas-ast.cod-estabel:SCREEN-VALUE IN FRAME f-main NO-LOCK NO-ERROR.
  IF AVAIL estabelec THEN
      ASSIGN c-desc-estab:SCREEN-VALUE IN FRAME {&FRAME-NAME} = estabelec.nome.

  FIND FIRST deposito
      WHERE deposito.cod-depos = INPUT FRAME f-main reservas-ast.cod-depos NO-LOCK NO-ERROR.
  IF AVAIL deposito THEN
      ASSIGN c-desc-deposito:SCREEN-VALUE IN FRAME f-main = deposito.nome.

  FIND FIRST item
      WHERE item.it-codigo = INPUT FRAME f-main reservas-ast.it-codigo NO-LOCK NO-ERROR.
  IF AVAIL item THEN
      ASSIGN c-desc-item:SCREEN-VALUE IN FRAME f-main = item.desc-item.


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
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Valida‡Æo de dicion rio */
    

/*:T    Segue um exemplo de valida‡Æo de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */

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
  {src/adm/template/snd-list.i "reservas-ast"}

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

