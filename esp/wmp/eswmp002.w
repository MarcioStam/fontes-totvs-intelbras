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
{include/i-prgvrs.i ES-WM002 2.00.00.001}

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

DEFINE TEMP-TABLE tt-embarque NO-UNDO
    FIELD num-docto       LIKE wm-docto.num-docto
    FIELD nr-embarque     LIKE wm-docto.nr-embarque
    FIELD data-integracao AS DATE FORMAT "99/99/9999"
    FIELD cod-transp      AS INT
    FIELD nom-trans       AS CHAR
    FIELD estado          AS CHAR
    FIELD vl-nota         AS DEC
    FIELD nr-pallet       AS INT
    FIELD nr-caixa        AS INT
    FIELD nr-fracionados  AS INT
    FIELD data-inicio     AS DATE FORMAT "99/99/9999"
    FIELD hr-inicio       AS CHAR
    FIELD perc-conclusao  AS DEC
    FIELD dt-finalizacao  AS DATE FORMAT "99/99/9999"
    FIELD hr-finalizacao  AS CHAR
    FIELD qtd-blocos      AS INT
    FIELD doca-exp        AS INT
    FIELD cod-estabel     LIKE wm-docto.cod-estabel 
    FIELD cod-local       LIKE wm-docto.cod-local   
    FIELD id-docto        LIKE wm-docto.id-docto    
    INDEX codigo cod-estabel cod-local id-docto.

DEFINE TEMP-TABLE tt-tarefa NO-UNDO
    FIELD id-docto          LIKE wm-docto.id-docto
    FIELD id-movto          LIKE wm-tarefa-docto-itens.id-movto
    FIELD cod-estabel       LIKE wm-docto.cod-estabel
    FIELD cod-local         LIKE wm-docto.cod-local
    FIELD cod-item          LIKE wm-docto-itens.cod-item
    FIELD qtd-item          LIKE wm-docto-itens.qtd-item
    FIELD bloco             AS CHAR
    FIELD nr-pallet         AS INT
    FIELD nr-fracionado     AS INT
    FIELD nr-caixa          AS INT
    FIELD data-inicio       AS DATE
    FIELD hora-inicio       AS CHAR
    FIELD perc-conclusao    AS DEC
    FIELD data-finalizacao  AS DATE
    FIELD hora-finalizacao  AS CHAR
    FIELD usuario-tarefa    AS CHAR
    FIELD id-tarefa         LIKE wm-tarefa-docto.id-tarefa 
    INDEX idx1 id-docto cod-estabel cod-local.

DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.

DEF VAR d-perc-conclusao AS DEC FORMAT ">>9,99" NO-UNDO.

DEF VAR c-num-docto-ini     AS CHARACTER FORMAT "X(16)" INIT "" NO-UNDO.
DEF VAR c-num-docto-fin     AS CHARACTER FORMAT "X(16)" INIT "ZZZZZZZZZZZZZZZZ" NO-UNDO.
DEF VAR dt-DtImplantacaoIni AS DATE INIT TODAY NO-UNDO.
DEF VAR dt-DtImplantacaoFin AS DATE INIT TODAY NO-UNDO.
DEF VAR i-nr-embarque-ini   AS INTEGER INIT 0         NO-UNDO.
DEF VAR i-nr-embarque-fin   AS INTEGER INIT 999       NO-UNDO.
DEF VAR l-bt-ok             AS LOG                    NO-UNDO.

DEF VAR hDBOWm-box-movto    AS HANDLE NO-UNDO.
DEF VAR wh-pesquisa         AS HANDLE NO-UNDO.

DEF TEMP-TABLE ttRowErrors NO-UNDO LIKE RowErrors.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-consim
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME brEmbarque

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-embarque tt-tarefa

/* Definitions for BROWSE brEmbarque                                    */
&Scoped-define FIELDS-IN-QUERY-brEmbarque tt-embarque.num-docto tt-embarque.nr-embarque tt-embarque.data-integracao tt-embarque.cod-trans tt-embarque.nom-trans tt-embarque.estado tt-embarque.vl-nota tt-embarque.nr-pallet tt-embarque.nr-caixa tt-embarque.nr-fracionados tt-embarque.data-inicio tt-embarque.hr-inicio tt-embarque.perc-conclusao tt-embarque.dt-finalizacao tt-embarque.hr-finalizacao tt-embarque.qtd-blocos tt-embarque.doca-exp   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brEmbarque tt-embarque.doca-exp   
&Scoped-define ENABLED-TABLES-IN-QUERY-brEmbarque tt-embarque
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brEmbarque tt-embarque
&Scoped-define SELF-NAME brEmbarque
&Scoped-define QUERY-STRING-brEmbarque FOR EACH tt-embarque
&Scoped-define OPEN-QUERY-brEmbarque OPEN QUERY {&SELF-NAME} FOR EACH tt-embarque.
&Scoped-define TABLES-IN-QUERY-brEmbarque tt-embarque
&Scoped-define FIRST-TABLE-IN-QUERY-brEmbarque tt-embarque


/* Definitions for BROWSE brTarefa                                      */
&Scoped-define FIELDS-IN-QUERY-brTarefa tt-tarefa.bloco tt-tarefa.id-tarefa tt-tarefa.cod-item tt-tarefa.qtd-item tt-tarefa.nr-pallet tt-tarefa.nr-caixa tt-tarefa.nr-fracionado tt-tarefa.data-inicio tt-tarefa.hora-inicio tt-tarefa.perc-conclusao tt-tarefa.data-finalizacao tt-tarefa.hora-finalizacao tt-tarefa.usuario-tarefa   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTarefa tt-tarefa.usuario-tarefa   
&Scoped-define ENABLED-TABLES-IN-QUERY-brTarefa tt-tarefa
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brTarefa tt-tarefa
&Scoped-define SELF-NAME brTarefa
&Scoped-define QUERY-STRING-brTarefa FOR EACH tt-tarefa
&Scoped-define OPEN-QUERY-brTarefa OPEN QUERY {&SELF-NAME} FOR EACH tt-tarefa.
&Scoped-define TABLES-IN-QUERY-brTarefa tt-tarefa
&Scoped-define FIRST-TABLE-IN-QUERY-brTarefa tt-tarefa


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-brEmbarque}~
    ~{&OPEN-QUERY-brTarefa}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button RECT-3 RECT-4 btFiltro btAtualizar ~
btExit brEmbarque btSalva-embarque brTarefa btSalvaTarefa 

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
     SIZE 4 BY 1.25 TOOLTIP "Opá‰es de filtro".

DEFINE BUTTON btSalva-embarque 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Confirmar Doca".

DEFINE BUTTON btSalvaTarefa 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Confirmar Usu†rio".

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 147.43 BY 11.17.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 147.43 BY 11.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 147.43 BY 1.46
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brEmbarque FOR 
      tt-embarque SCROLLING.

DEFINE QUERY brTarefa FOR 
      tt-tarefa SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brEmbarque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brEmbarque w-consim _FREEFORM
  QUERY brEmbarque DISPLAY
      tt-embarque.num-docto
tt-embarque.nr-embarque     LABEL "Embarque"
tt-embarque.data-integracao LABEL "Data de Integraá∆o"
tt-embarque.cod-trans       LABEL "Transportadora"
tt-embarque.nom-trans       LABEL "Nome" FORMAT "x(20)"
tt-embarque.estado          LABEL "UF" FORMAT "x(02)"
tt-embarque.vl-nota         LABEL "Valor Nota"
tt-embarque.nr-pallet       LABEL "Nr Pal" FORMAT ">>>>9"
tt-embarque.nr-caixa        LABEL "Nr Cai" FORMAT ">>>>9"
tt-embarque.nr-fracionados  LABEL "Nr Fra" FORMAT ">>>>9"
tt-embarque.data-inicio     LABEL "Data In°cio"
tt-embarque.hr-inicio       LABEL "Hora In°cio"
tt-embarque.perc-conclusao  LABEL "% Conclus∆o"
tt-embarque.dt-finalizacao  LABEL "Data TÇrmino"
tt-embarque.hr-finalizacao  LABEL "Hora TÇrmino"
tt-embarque.qtd-blocos      LABEL "Qtd. Blocos"
tt-embarque.doca-exp        LABEL "Doca de Expediá∆o"

    ENABLE tt-embarque.doca-exp
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 141.57 BY 10.25 FIT-LAST-COLUMN.

DEFINE BROWSE brTarefa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTarefa w-consim _FREEFORM
  QUERY brTarefa DISPLAY
      tt-tarefa.bloco           LABEL "Bloco" FORMAT "x(01)"
tt-tarefa.id-tarefa LABEL "ID Tarefa" FORMAT ">>>>>>>>>9"
tt-tarefa.cod-item LABEL "Item" 
tt-tarefa.qtd-item LABEL "Quantidade" FORMAT ">>>,>>>,>>9.9999"
tt-tarefa.nr-pallet       LABEL "Nr Pal"     FORMAT ">>>>9"
tt-tarefa.nr-caixa        LABEL "Nr Cai"      FORMAT ">>>>9"
tt-tarefa.nr-fracionado   LABEL "Nr Fra" FORMAT ">>>>9"
tt-tarefa.data-inicio     LABEL "Data In°" FORMAT "99/99/9999"
tt-tarefa.hora-inicio     LABEL "Hora In°"    FORMAT "x(10)"
tt-tarefa.perc-conclusao  LABEL "% Conclus∆o"
tt-tarefa.data-finalizacao LABEL "Data Final" FORMAT "99/99/9999"
tt-tarefa.hora-finalizacao LABEL "Hora Final" FORMAT "x(10)"
tt-tarefa.usuario-tarefa  LABEL "Usuario"
ENABLE tt-tarefa.usuario-tarefa
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 141.57 BY 10.25 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     btFiltro AT ROW 1.21 COL 2 WIDGET-ID 14
     btAtualizar AT ROW 1.21 COL 6.14 WIDGET-ID 10
     btExit AT ROW 1.21 COL 144.14 HELP
          "Sair" WIDGET-ID 16
     brEmbarque AT ROW 3.46 COL 2.43 WIDGET-ID 200
     btSalva-embarque AT ROW 3.46 COL 144.43 WIDGET-ID 20
     brTarefa AT ROW 14.88 COL 2.43 WIDGET-ID 300
     btSalvaTarefa AT ROW 14.92 COL 144.43 WIDGET-ID 18
     rt-button AT ROW 1.08 COL 1.57
     RECT-3 AT ROW 14.58 COL 1.57 WIDGET-ID 6
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
         HEIGHT             = 24.88
         WIDTH              = 148.29
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
/* BROWSE-TAB brEmbarque btExit fMain */
/* BROWSE-TAB brTarefa btSalva-embarque fMain */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-consim)
THEN w-consim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brEmbarque
/* Query rebuild information for BROWSE brEmbarque
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-embarque.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brEmbarque */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTarefa
/* Query rebuild information for BROWSE brTarefa
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-tarefa.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brTarefa */
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


&Scoped-define BROWSE-NAME brEmbarque
&Scoped-define SELF-NAME brEmbarque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brEmbarque w-consim
ON ROW-LEAVE OF brEmbarque IN FRAME fMain
DO:

    ASSIGN tt-embarque.doca-exp = INPUT BROWSE brEmbarque tt-embarque.doca-exp.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brEmbarque w-consim
ON VALUE-CHANGED OF brEmbarque IN FRAME fMain
DO:
  RUN pi-carrega-tarefa (INPUT tt-embarque.cod-estabel,
                         INPUT tt-embarque.cod-local,
                         INPUT tt-embarque.id-docto,
                         INPUT 2).
    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brTarefa
&Scoped-define SELF-NAME brTarefa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTarefa w-consim
ON MOUSE-SELECT-DBLCLICK OF brTarefa IN FRAME fMain
DO:
    
    /*
    assign l-implanta = yes. 

    {include/zoomvar.i &prog-zoom="sczoom/z01sc079.w"
                       &campo1=tt-tarefa.usuario-tarefa
                       &campozoom1=usuario
                       &BROWSE = {&browse-name}}
    */                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTarefa w-consim
ON ROW-LEAVE OF brTarefa IN FRAME fMain
DO:

    ASSIGN tt-tarefa.usuario-tarefa = tt-tarefa.usuario-tarefa:SCREEN-VALUE IN BROWSE brTarefa.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAtualizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualizar w-consim
ON CHOOSE OF btAtualizar IN FRAME fMain
DO:

    RUN pi-carrega-embarque.
    IF AVAIL tt-embarque THEN
    RUN pi-carrega-tarefa (INPUT tt-embarque.cod-estabel,
                           INPUT tt-embarque.cod-local,
                           INPUT tt-embarque.id-docto,
                           INPUT 2).
    

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

  RUN esp/wmp/eswmp002a.w(INPUT-OUTPUT c-num-docto-ini,
                       INPUT-OUTPUT c-num-docto-fin,
                       INPUT-OUTPUT dt-DtImplantacaoIni,
                       INPUT-OUTPUT dt-DtImplantacaofin,
                       INPUT-OUTPUT i-nr-embarque-ini,
                       INPUT-OUTPUT i-nr-embarque-fin,
                       INPUT-OUTPUT l-bt-ok).


    RUN pi-carrega-embarque IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSalva-embarque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSalva-embarque w-consim
ON CHOOSE OF btSalva-embarque IN FRAME fMain
DO:
    FOR EACH tt-embarque:
        FIND FIRST wm-docto EXCLUSIVE-LOCK
             WHERE wm-docto.ind-tipo-trans  = 2
               AND wm-docto.num-docto       = tt-embarque.num-docto
               AND wm-docto.nr-embarque     = tt-embarque.nr-embarque
               AND wm-docto.dt-implan-docto = tt-embarque.data-integracao NO-ERROR.
        IF AVAIL wm-docto THEN DO:
            FIND FIRST wm-doca NO-LOCK
                 WHERE wm-doca.cod-doca = INPUT BROWSE brEmbarque tt-embarque.doca-exp NO-ERROR.
            IF NOT AVAIL wm-doca THEN DO:
                run utp/ut-msgs.p(input "show",
                                  input 17006,
                                  input "Doca " + STRING(tt-embarque.doca-exp) + " n∆o est† cadastrada.").
                APPLY "ENTRY" TO tt-embarque.doca-exp IN BROWSE brEmbarque.
                RETURN 'ADM-ERROR':U.
            END.
            ELSE 
                ASSIGN wm-docto.cod-doca = tt-embarque.doca-exp.

        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSalvaTarefa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSalvaTarefa w-consim
ON CHOOSE OF btSalvaTarefa IN FRAME fMain
DO:
    /* Grava Usuarios responsaveis pela tarefa de picking */
    FOR EACH tt-tarefa:
        
        FIND FIRST wm-tarefa-docto-itens EXCLUSIVE-LOCK
             WHERE wm-tarefa-docto-itens.id-tarefa      = tt-tarefa.id-tarefa
               AND wm-tarefa-docto-itens.id-movto       = tt-tarefa.id-movto
               AND wm-tarefa-docto-itens.ind-tipo-movto = 2 NO-ERROR.
        IF AVAIL wm-tarefa-docto-itens THEN DO:
            FIND FIRST usuario-scm NO-LOCK
                 WHERE usuario-scm.usuario = tt-tarefa.usuario-tarefa:SCREEN-VALUE IN BROWSE brTarefa NO-ERROR.
            IF NOT AVAIL usuario-scm THEN  DO:
                run utp/ut-msgs.p(input "show",
                                  input 17006,
                                  input "Usu†rio  " + STRING(tt-tarefa.usuario-tarefa) + " n∆o est† cadastrado.").
                APPLY "ENTRY" TO tt-tarefa.usuario-tarefa IN BROWSE brTarefa.
                RETURN 'ADM-ERROR':U.
            END.
            ELSE 
                ASSIGN wm-tarefa-docto-itens.cod-usuario = tt-tarefa.usuario-tarefa.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brEmbarque
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
  ENABLE rt-button RECT-3 RECT-4 btFiltro btAtualizar btExit brEmbarque 
         btSalva-embarque brTarefa btSalvaTarefa 
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

  {utp/ut9000.i "eswmp002" "2.00.00.001"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /*run pi-after-initialize.*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-embarque w-consim 
PROCEDURE pi-carrega-embarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR i-concluido AS INT.
DEF VAR i-tot-tarefa AS INT.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp(INPUT "Aguarde, carregando Documentos...").

FOR EACH tt-embarque:
    DELETE tt-embarque.
END.

FOR EACH wm-docto NO-LOCK
   WHERE wm-docto.ind-tipo-trans  = 2
     AND wm-docto.num-docto       >= c-num-docto-ini
     AND wm-docto.num-docto       <= c-num-docto-fin
     AND wm-docto.nr-embarque     >= i-nr-embarque-ini
     AND wm-docto.nr-embarque     <= i-nr-embarque-fin
     AND wm-docto.dt-implan-docto >= dt-DtImplantacaoIni 
     AND wm-docto.dt-implan-docto <= dt-DtImplantacaoFin :

    run pi-acompanhar in h-acomp(input 'Documentos: ' + string(wm-docto.num-docto)).

    FIND FIRST pre-fatur NO-LOCK 
         WHERE pre-fatur.nr-embarque = wm-docto.nr-embarque NO-ERROR.
    FIND FIRST transporte NO-LOCK
         WHERE transporte.nome-abrev = pre-fatur.nome-transp NO-ERROR.
    FIND FIRST emitente NO-LOCK
        WHERE emitente.nome-abrev = pre-fatur.nome-abrev NO-ERROR.

    CREATE tt-embarque.
    ASSIGN tt-embarque.num-docto       = wm-docto.num-docto
           tt-embarque.cod-estabel     = wm-docto.cod-estabel
           tt-embarque.cod-local       = wm-docto.cod-local  
           tt-embarque.id-docto        = wm-docto.id-docto
           tt-embarque.nr-embarque     = wm-docto.nr-embarque
           tt-embarque.data-integracao = wm-docto.dt-implan-docto
           tt-embarque.cod-transp      = IF AVAIL transporte THEN transporte.cod-transp ELSE 0
           tt-embarque.nom-trans       = IF AVAIL pre-fatur THEN transporte.nome-abrev ELSE ""
           tt-embarque.estado          = IF AVAIL emitente THEN emitente.estado ELSE ""
           tt-embarque.vl-nota         = 0
           tt-embarque.qtd-blocos      = 0
           tt-embarque.doca-exp        = wm-docto.cod-doca.

    FOR EACH wm-docto-itens NO-LOCK
       WHERE wm-docto-itens.cod-estabel = wm-docto.cod-estabel 
         AND wm-docto-itens.cod-local   = wm-docto.cod-local   
         AND wm-docto-itens.id-docto    = wm-docto.id-docto:

        FOR EACH wm-box-movto NO-LOCK
           WHERE wm-box-movto.cod-estabel    = wm-docto-itens.cod-estabel
             AND wm-box-movto.cod-local      = wm-docto-itens.cod-local  
             AND wm-box-movto.id-docto       = wm-docto-itens.id-docto   
             AND wm-box-movto.num-seq-item   = wm-docto-itens.num-seq-item
             AND wm-box-movto.ind-tipo-movto = 2: /* Saida */

            FIND FIRST wm-item-embalagem-local NO-LOCK
                 WHERE wm-item-embalagem-local.cod-estabel = wm-docto-itens.cod-estabel  AND
                       wm-item-embalagem-local.cod-local   = wm-docto-itens.cod-local    AND
                       wm-item-embalagem-local.cod-item    = wm-docto-itens.cod-item     NO-ERROR.
            ASSIGN tt-embarque.nr-pallet     = tt-embarque.nr-pallet + TRUNCATE(wm-box-movto.qtd-item / wm-item-embalagem-local.qtd-item-emb,0)
                   tt-embarque.nr-caixa      = tt-embarque.nr-caixa + TRUNCATE(wm-box-movto.qtd-item / wm-item-embalagem-local.qtd-emb-item,0)
                   tt-embarque.nr-fracionado = tt-embarque.nr-fracionado + wm-box-movto.qtd-item MODULO wm-item-embalagem-local.qtd-emb-item.

            FIND FIRST wm-tarefa-docto NO-LOCK
                 WHERE wm-tarefa-docto.cod-estabel = wm-docto.cod-estabel
                   AND wm-tarefa-docto.cod-local   = wm-docto.cod-local
                   AND wm-tarefa-docto.id-docto    = wm-docto.id-docto NO-ERROR.
            IF AVAIL wm-tarefa-docto THEN DO:
                ASSIGN tt-embarque.data-inicio    = wm-tarefa-docto.dt-inicio-tarefa 
                       tt-embarque.hr-inicio      = string(wm-tarefa-docto.hr-inicio-tarefa, "HH:MM:SS") 
                       tt-embarque.dt-finalizacao = wm-tarefa-docto.dt-fim-tarefa 
                       tt-embarque.hr-finalizacao = string(wm-tarefa-docto.hr-fim-tarefa, "HH:MM:SS").
                FOR EACH wm-tarefa-docto-itens 
                   WHERE wm-tarefa-docto-itens.cod-estabel = wm-box-movto.cod-estabel  
                     AND wm-tarefa-docto-itens.cod-local   = wm-box-movto.cod-local 
                     AND wm-tarefa-docto-itens.id-movto    = wm-box-movto.id-movto NO-LOCK
                    BREAK BY wm-tarefa-docto-itens.id-docto:

                    IF wm-tarefa-docto-itens.dt-fim-tarefa <> ?  THEN DO:
                        ASSIGN i-concluido = i-concluido + 1.
                    END.

                    ASSIGN i-tot-tarefa = i-tot-tarefa + 1.

                END.
            END.
        END.
    END.
    ASSIGN tt-embarque.perc-conclusao = (i-concluido / i-tot-tarefa) * 100
           i-concluido  = 0
           i-tot-tarefa = 0.
END.
RUN pi-finalizar in h-acomp.
{&OPEN-QUERY-brEmbarque}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-tarefa w-consim 
PROCEDURE pi-carrega-tarefa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM p-cod-estabel LIKE wm-docto.cod-estabel.
    DEFINE INPUT PARAM p-cod-local   LIKE wm-docto.cod-local.
    DEFINE INPUT PARAM p-id-docto    LIKE wm-docto.id-docto.
    DEFINE INPUT PARAM p-tipo-movto  LIKE wm-docto.ind-tipo-trans.

    DEF VAR i-concluido2 AS INT.
    DEF VAR i-tot-tarefa2 AS INT.

    FOR EACH tt-tarefa:
        DELETE tt-tarefa.
    END.
    
    FIND FIRST wm-docto NO-LOCK
         WHERE wm-docto.cod-estabel    = p-cod-estabel
           AND wm-docto.cod-local      = p-cod-local  
           AND wm-docto.id-docto       = p-id-docto   
           AND wm-docto.ind-tipo-trans = p-tipo-movto NO-ERROR.
    IF NOT AVAIL wm-docto THEN NEXT.
    
    FOR EACH wm-docto-itens EXCLUSIVE-LOCK
       WHERE wm-docto-itens.cod-estabel    = wm-docto.cod-estabel
         AND wm-docto-itens.cod-local      = wm-docto.cod-local  
         AND wm-docto-itens.id-docto       = wm-docto.id-docto:
        
        FOR EACH wm-box-movto NO-LOCK
           WHERE wm-box-movto.cod-estabel    = wm-docto-itens.cod-estabel
             AND wm-box-movto.cod-local      = wm-docto-itens.cod-local  
             AND wm-box-movto.id-docto       = wm-docto-itens.id-docto   
             AND wm-box-movto.num-seq-item   = wm-docto-itens.num-seq-item
             AND wm-box-movto.ind-tipo-movto = 2: /* Saida */
            
            FIND FIRST wm-box NO-LOCK
                 WHERE wm-box.cod-estabel = wm-box-movto.cod-estabel AND
                       wm-box.cod-local   = wm-box-movto.cod-local   AND
                       wm-box.id-box      = wm-box-movto.id-box      NO-ERROR.

            CREATE tt-tarefa.
            ASSIGN tt-tarefa.id-docto         = wm-box-movto.id-docto
                   tt-tarefa.cod-estabel      = wm-box-movto.cod-estabel
                   tt-tarefa.cod-local        = wm-box-movto.cod-local
                   tt-tarefa.bloco            = wm-box.cod-bloco
                   tt-tarefa.cod-item         = wm-docto-itens.cod-item
                   tt-tarefa.qtd-item         = wm-box-movto.qtd-item.
                   
            FIND FIRST wm-item-embalagem-local NO-LOCK
                 WHERE wm-item-embalagem-local.cod-estabel = wm-docto-itens.cod-estabel  AND
                       wm-item-embalagem-local.cod-local   = wm-docto-itens.cod-local    AND
                       wm-item-embalagem-local.cod-item    = wm-docto-itens.cod-item     NO-ERROR.

            ASSIGN tt-tarefa.nr-pallet     = TRUNCATE(wm-box-movto.qtd-item / wm-item-embalagem-local.qtd-item-emb,0)
                   tt-tarefa.nr-caixa      = TRUNCATE(wm-box-movto.qtd-item / wm-item-embalagem-local.qtd-emb-item,0)
                   tt-tarefa.nr-fracionado = wm-box-movto.qtd-item MODULO wm-item-embalagem-local.qtd-emb-item.

            FIND FIRST wm-tarefa-docto NO-LOCK
                 WHERE wm-tarefa-docto.cod-estabel = wm-docto-itens.cod-estabel
                   AND wm-tarefa-docto.cod-local   = wm-docto-itens.cod-local
                   AND wm-tarefa-docto.id-docto    = wm-docto-itens.id-docto NO-ERROR.
            IF AVAIL wm-tarefa-docto THEN DO:
                FOR EACH wm-tarefa-docto-itens 
                   WHERE wm-tarefa-docto-itens.cod-estabel = wm-box-movto.cod-estabel  
                     AND wm-tarefa-docto-itens.cod-local   = wm-box-movto.cod-local 
                     AND wm-tarefa-docto-itens.id-movto    = wm-box-movto.id-movto NO-LOCK
                    BREAK BY wm-tarefa-docto-itens.id-movto :

                    ASSIGN tt-tarefa.id-tarefa        = wm-tarefa-docto-itens.id-tarefa 
                           tt-tarefa.id-movto         = wm-tarefa-docto-itens.id-movto
                           tt-tarefa.data-inicio      = wm-tarefa-docto-itens.dt-inicio-tarefa 
                           tt-tarefa.hora-inicio      = string(wm-tarefa-docto-itens.hr-inicio-tarefa, "HH:MM:SS") 
                           tt-tarefa.data-finalizacao = wm-tarefa-docto-itens.dt-fim-tarefa 
                           tt-tarefa.hora-finalizacao = string(wm-tarefa-docto-itens.hr-fim-tarefa, "HH:MM:SS")
                           tt-tarefa.usuario-tarefa   = wm-tarefa-docto-itens.cod-usuario.

                    IF wm-tarefa-docto-itens.hr-fim-tarefa <> 0 AND wm-tarefa-docto-itens.hr-fim-tarefa <> ? THEN DO:
                        ASSIGN i-concluido2 = i-concluido2 + 1.
                    END.
                    
                    ASSIGN i-tot-tarefa2 = i-tot-tarefa2 + 1.
                    IF LAST-OF(wm-tarefa-docto-itens.id-movto) THEN DO:
                    
                        ASSIGN tt-tarefa.perc-conclusao = (i-concluido2 / i-tot-tarefa2) * 100.
                    END.
                END.
                ASSIGN i-concluido2  = 0
                       i-tot-tarefa2 = 0.
                       
            END.
        END.
    END.
    {&OPEN-QUERY-brTarefa}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCreateError w-consim 
PROCEDURE piCreateError :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pErrorNumber     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pErrorParameters AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorType       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorSubType    AS CHARACTER NO-UNDO.

    DEFINE VARIABLE i-sequencia AS INTEGER NO-UNDO.

    FIND LAST ttRowErrors NO-LOCK NO-ERROR.
    IF AVAIL ttRowErrors THEN
        ASSIGN i-sequencia = ttRowErrors.ErrorSequence + 1.
    ELSE    
        ASSIGN i-sequencia = 1.

    RUN utp/ut-msgs.p (INPUT "msg",
                       INPUT pErrorNumber,
                       INPUT pErrorParameters).  

    FIND FIRST ttRowErrors 
         WHERE ttRowErrors.ErrorDescription = RETURN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAIL ttRowErrors THEN DO:
        CREATE ttRowErrors.
        ASSIGN ttRowErrors.ErrorSequence    = i-sequencia
               ttRowErrors.ErrorNumber      = pErrorNumber
               ttRowErrors.ErrorParameters  = pErrorParameters
               ttRowErrors.ErrorType        = pErrorType
               ttRowErrors.ErrorSubType     = pErrorSubType
               ttRowErrors.ErrorDescription = RETURN-VALUE.

        RUN utp/ut-msgs.p (INPUT "help",
                           INPUT ttRowErrors.ErrorNumber,
                           INPUT ttRowErrors.ErrorParameters).  
        ASSIGN ttRowErrors.ErrorHelp = RETURN-VALUE.
    END.

    RETURN "OK":U.    


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
  {src/adm/template/snd-list.i "tt-tarefa"}
  {src/adm/template/snd-list.i "tt-embarque"}

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

