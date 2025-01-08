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
{include/i-prgvrs.i esccp034 2.00.00.000}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{esp/es0018.i}

define variable wh-imprime as handle no-undo.
DEFINE VARIABLE wh-pesquisa AS HANDLE      NO-UNDO.

DEFINE TEMP-TABLE tt-ordem-compra     LIKE ordem-compra
    FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-matriz-rat-ordem LIKE matriz-rat-ordem
    FIELD r-rowid AS ROWID.

DEFINE BUFFER b-tt-matriz-rat-ordem FOR tt-matriz-rat-ordem.
DEFINE BUFFER b-matriz-rat-ordem FOR matriz-rat-ordem.

{upc/btb910za-upc.i}
{utp/ut-glob.i}

IF NOT VALID-HANDLE (h_api_cta_ctbl) THEN
    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
IF NOT VALID-HANDLE (h_api_ccusto) THEN
    run prgint/utb/utb742za.py persistent set h_api_ccusto.

def new global shared var v_rec_unid_negoc
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

DEFINE VARIABLE p_cod_plano_ccusto   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE p_cod_plano_cta_ctbl AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-matriz

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-matriz-rat-ordem tt-ordem-compra

/* Definitions for BROWSE br-matriz                                     */
&Scoped-define FIELDS-IN-QUERY-br-matriz tt-matriz-rat-ordem.ct-codigo tt-matriz-rat-ordem.sc-codigo tt-matriz-rat-ordem.perc-rateio tt-matriz-rat-ordem.char-2   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-matriz   
&Scoped-define SELF-NAME br-matriz
&Scoped-define QUERY-STRING-br-matriz FOR EACH tt-matriz-rat-ordem
&Scoped-define OPEN-QUERY-br-matriz OPEN QUERY {&SELF-NAME} FOR EACH tt-matriz-rat-ordem.
&Scoped-define TABLES-IN-QUERY-br-matriz tt-matriz-rat-ordem
&Scoped-define FIRST-TABLE-IN-QUERY-br-matriz tt-matriz-rat-ordem


/* Definitions for BROWSE br-ordem                                      */
&Scoped-define FIELDS-IN-QUERY-br-ordem tt-ordem-compra.numero-ordem tt-ordem-compra.it-codigo tt-ordem-compra.ct-codigo tt-ordem-compra.sc-codigo tt-ordem-compra.cod-unid-negoc tt-ordem-compra.cod-comprado tt-ordem-compra.qt-solic tt-ordem-compra.preco-fornec fn-situacao-ordem() @ tt-ordem-compra.char-2   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-ordem tt-ordem-compra.it-codigo ~
 tt-ordem-compra.ct-codigo ~
 tt-ordem-compra.sc-codigo ~
tt-ordem-compra.cod-unid-negoc   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-ordem tt-ordem-compra
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-ordem tt-ordem-compra
&Scoped-define SELF-NAME br-ordem
&Scoped-define QUERY-STRING-br-ordem FOR EACH tt-ordem-compra
&Scoped-define OPEN-QUERY-br-ordem OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem-compra.
&Scoped-define TABLES-IN-QUERY-br-ordem tt-ordem-compra
&Scoped-define FIRST-TABLE-IN-QUERY-br-ordem tt-ordem-compra


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-matriz}~
    ~{&OPEN-QUERY-br-ordem}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button RECT-1 i-num-pedido br-ordem ~
ed-narrativa br-matriz bt-inclui bt-modifica bt-elimina bt-ok bt-cancela ~
bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS i-num-pedido c-cod-estabel c-desc-estab ~
d-data c-cod-emitente c-nome-emit ed-narrativa d-total-perc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-situacao-ordem w-cadsim 
FUNCTION fn-situacao-ordem RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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

DEFINE BUTTON bt-elimina 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-imprime 
     LABEL "&Imprimir" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-inclui 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-modifica 
     LABEL "Modificar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE ed-narrativa AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 89.86 BY 4.5 NO-UNDO.

DEFINE VARIABLE c-cod-emitente AS CHARACTER FORMAT "X(09)":U 
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabel" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 32.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-emit AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE d-data AS DATE FORMAT "99/99/9999":U 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 10.43 BY .88 NO-UNDO.

DEFINE VARIABLE d-total-perc AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE 4.72 BY .67 NO-UNDO.

DEFINE VARIABLE i-num-pedido AS INTEGER FORMAT ">>>>>>>9":U INITIAL 0 
     LABEL "Pedido" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90.29 BY 3.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.38
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-matriz FOR 
      tt-matriz-rat-ordem SCROLLING.

DEFINE QUERY br-ordem FOR 
      tt-ordem-compra SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-matriz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-matriz w-cadsim _FREEFORM
  QUERY br-matriz DISPLAY
      tt-matriz-rat-ordem.ct-codigo   COLUMN-LABEL "Conta":U
tt-matriz-rat-ordem.sc-codigo         COLUMN-LABEL "Centro Custo":U
tt-matriz-rat-ordem.perc-rateio       COLUMN-LABEL "%":U
tt-matriz-rat-ordem.char-2            COLUMN-LABEL "Unid. Negoc.":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89.86 BY 4.38
         FONT 7
         TITLE "Matriz de Rateio" FIT-LAST-COLUMN.

DEFINE BROWSE br-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-ordem w-cadsim _FREEFORM
  QUERY br-ordem DISPLAY
      tt-ordem-compra.numero-ordem
tt-ordem-compra.it-codigo WIDTH 8
tt-ordem-compra.ct-codigo WIDTH 8
tt-ordem-compra.sc-codigo COLUMN-LABEL "Centro Custo":U WIDTH 9
tt-ordem-compra.cod-unid-negoc COLUMN-LABEL "Un.Neg.":U
tt-ordem-compra.cod-comprado
tt-ordem-compra.qt-solic
tt-ordem-compra.preco-fornec
fn-situacao-ordem() @ tt-ordem-compra.char-2 COLUMN-LABEL "Situaá∆o" WIDTH 15


ENABLE tt-ordem-compra.it-codigo 
       tt-ordem-compra.ct-codigo 
       tt-ordem-compra.sc-codigo
       tt-ordem-compra.cod-unid-negoc
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89.86 BY 5.25
         FONT 7
         TITLE "Ordens de Compra" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     i-num-pedido AT ROW 1.75 COL 9 COLON-ALIGNED WIDGET-ID 2
     c-cod-estabel AT ROW 1.75 COL 27 COLON-ALIGNED WIDGET-ID 18
     c-desc-estab AT ROW 1.75 COL 36.14 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     d-data AT ROW 1.75 COL 75.57 COLON-ALIGNED WIDGET-ID 22
     c-cod-emitente AT ROW 2.75 COL 9 COLON-ALIGNED WIDGET-ID 4
     c-nome-emit AT ROW 2.75 COL 19.14 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     br-ordem AT ROW 4.5 COL 2.14 WIDGET-ID 200
     ed-narrativa AT ROW 10 COL 2.14 NO-LABEL WIDGET-ID 26
     br-matriz AT ROW 14.75 COL 2.14 WIDGET-ID 300
     bt-inclui AT ROW 19.25 COL 2.14 WIDGET-ID 10
     bt-modifica AT ROW 19.25 COL 12.43 WIDGET-ID 12
     bt-elimina AT ROW 19.25 COL 22.72 WIDGET-ID 14
     bt-ok AT ROW 21.08 COL 3
     bt-cancela AT ROW 21.08 COL 14
     bt-imprime AT ROW 21.08 COL 25
     bt-ajuda AT ROW 21.08 COL 81.29
     d-total-perc AT ROW 19.29 COL 83.43 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     "%" VIEW-AS TEXT
          SIZE 1.29 BY .54 AT ROW 19.33 COL 90.57 WIDGET-ID 24
     rt-button AT ROW 20.88 COL 2
     RECT-1 AT ROW 1.25 COL 1.72 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 92 BY 21.29
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
         TITLE              = "Manutená∆o <Insira o complemento>"
         HEIGHT             = 21.42
         WIDTH              = 91.43
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 147.72
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 147.72
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
/* BROWSE-TAB br-ordem c-nome-emit f-cad */
/* BROWSE-TAB br-matriz ed-narrativa f-cad */
ASSIGN 
       bt-ajuda:POPUP-MENU IN FRAME f-cad       = MENU POPUP-MENU-bt-ajuda:HANDLE.

/* SETTINGS FOR BUTTON bt-imprime IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       bt-imprime:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-emitente IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estab IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-emit IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-data IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-total-perc IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       ed-narrativa:READ-ONLY IN FRAME f-cad        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-matriz
/* Query rebuild information for BROWSE br-matriz
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-matriz-rat-ordem.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-matriz */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-ordem
/* Query rebuild information for BROWSE br-ordem
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem-compra.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-ordem */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Manutená∆o <Insira o complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Manutená∆o <Insira o complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-ordem
&Scoped-define SELF-NAME br-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ordem w-cadsim
ON ROW-LEAVE OF br-ordem IN FRAME f-cad /* Ordens de Compra */
DO:
    IF  tt-ordem-compra.it-codigo:READ-ONLY IN BROWSE br-ordem = NO THEN DO:
        FIND FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = tt-ordem-compra.it-codigo NO-ERROR.
        IF  NOT AVAIL ITEM THEN DO:
            RUN utp/ut-msgs.p (INPUT "show", INPUT 17006, INPUT "ITEM: " + tt-ordem-compra.it-codigo + " n∆o cadastrado!").
            RETURN NO-APPLY.
        END.
        IF  ITEM.tipo-contr <> 4 THEN DO:
            RUN utp/ut-msgs.p (INPUT "show", INPUT 17006, INPUT "ITEM: " + tt-ordem-compra.it-codigo + " n∆o Ç dÇbito direto!").
            RETURN NO-APPLY.
        END.
    END. /* IF  tt-ordem-compra.it-codigo:READ-ONLY IN BROWSE br-ordem = NO THEN DO: */

    IF valid-handle(h_api_ccusto) THEN RUN pi_busca_plano_ccusto_empresa IN h_api_ccusto (INPUT  "" /*v_cod_empres_usuar*/ ,
                                                                                          INPUT  TODAY,
                                                                                          OUTPUT p_cod_plano_ccusto,
                                                                                          OUTPUT TABLE tt_log_erro).
    
    IF valid-handle(h_api_cta_ctbl) THEN RUN pi_busca_plano_cta_ctbl_empresa IN h_api_cta_ctbl (INPUT  "" /*v_cod_empres_usuar*/ ,
                                                                                                INPUT  TODAY,
                                                                                                OUTPUT p_cod_plano_cta_ctbl,
                                                                                                OUTPUT TABLE tt_log_erro).

    IF  tt-ordem-compra.ct-codigo <> "" THEN DO: /*s¢ valida se a conta nao estiver em branco para evitar de ficar preso no campo*/
        RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  "",                        /* EMPRESA EMS 2 */
                                                           INPUT  "",                        /* ESTABELECIMENTO EMS2 */
                                                           INPUT  "",                        /* PLANO CONTAS */
                                                           INPUT  tt-ordem-compra.ct-codigo, /* CONTA */
                                                           INPUT  TODAY,                     /* DT TRANSACAO */
                                                           OUTPUT p_log_ccusto,              /* UTILIZA CCUSTO ? */
                                                           OUTPUT TABLE tt_log_erro).        /* ERROS */

        IF  NOT p_log_ccusto
        AND tt-ordem-compra.sc-codigo <> "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show", INPUT 17006, INPUT "Conta n∆o utiliza centro de custo.").
            RETURN NO-APPLY.
        END. /* IF  NOT p_log_ccusto ... */
        
        RUN pi_valida_conta_contabil in h_api_cta_ctbl (INPUT  v_cod_empres_usuar,                        /* EMPRESA EMS2 */
                                                        INPUT  c-cod-estabel:SCREEN-VALUE IN FRAME f-cad, /* ESTABELECIMENTO EMS2 */
                                                        INPUT  tt-ordem-compra.cod-unid-negoc,            /* UNIDADE NEGÖCIO */
                                                        INPUT  p_cod_plano_cta_ctbl,                      /* PLANO CONTAS */ 
                                                        INPUT  tt-ordem-compra.ct-codigo,                 /* CONTA */
                                                        INPUT  p_cod_plano_ccusto,                        /* PLANO CCUSTO */ 
                                                        INPUT  tt-ordem-compra.sc-codigo,                 /* CCUSTO */
                                                        INPUT  TODAY,                                     /* DATA TRANSACAO */
                                                        OUTPUT TABLE tt_log_erro).                        /* ERROS */
        FOR EACH tt_log_erro:
            RUN utp/ut-msgs.p (INPUT "show", INPUT 17006, INPUT tt_log_erro.ttv_des_msg_ajuda  + "~~" + tt_log_erro.ttv_des_msg_erro).
            RETURN NO-APPLY.
        END. /* FOR EACH tt_log_erro: */
        
        /* Valida todas as matrizes com a nova conta */
        FOR EACH  matriz-rat-ordem NO-LOCK
            WHERE matriz-rat-ordem.numero-ordem = tt-ordem-compra.numero-ordem:

            IF  CAN-FIND (FIRST b-matriz-rat-ordem
                          WHERE b-matriz-rat-ordem.numero-ordem = tt-ordem-compra.numero-ordem
                            AND b-matriz-rat-ordem.sc-codigo    = matriz-rat-ordem.sc-codigo
                            AND rowid(b-matriz-rat-ordem)       <> rowid(matriz-rat-ordem))  THEN DO:
                RUN utp/ut-msgs.p (INPUT "show", INPUT 17006, INPUT "J† existe matriz de rateio com a conta e sub-conta informados").
                RETURN NO-APPLY.
            END. /* IF  CAN-FIND (FIRST b-matriz-rat-ordem */
             
            RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  "",                         /* EMPRESA EMS 2 */
                                                               INPUT  "",                         /* ESTABELECIMENTO EMS2 */
                                                               INPUT  "",                         /* PLANO CONTAS */
                                                               INPUT  matriz-rat-ordem.ct-codigo, /* CONTA */
                                                               INPUT  TODAY,                      /* DT TRANSACAO */
                                                               OUTPUT p_log_ccusto,               /* UTILIZA CCUSTO ? */
                                                               OUTPUT TABLE tt_log_erro).         /* ERROS */

            IF  (NOT p_log_ccusto
            AND matriz-rat-ordem.sc-codigo <> "")
            AND tt-ordem-compra.sc-codigo  <> "" THEN DO:
                RUN utp/ut-msgs.p (INPUT "show", INPUT 17006, INPUT "Conta n∆o utiliza centro de custo." + "~~" + "Conta n∆o utiliza centro de custo e um ou mais registros da matriz de rateio possui centro de custo informado.").
                RETURN NO-APPLY.
            END. /* IF  NOT p_log_ccusto ... */

            RUN pi_valida_conta_contabil in h_api_cta_ctbl (INPUT  v_cod_empres_usuar,           /* EMPRESA EMS2 */
                                                            INPUT  c-cod-estabel:SCREEN-VALUE IN FRAME f-cad,                /* ESTABELECIMENTO EMS2 */
                                                            INPUT  SUBSTRING(matriz-rat-ordem.char-2,1,3), /* UNIDADE NEGÖCIO */
                                                            INPUT  p_cod_plano_cta_ctbl,                           /* PLANO CONTAS */ 
                                                            INPUT  matriz-rat-ordem.ct-codigo,    /* CONTA */
                                                            INPUT  p_cod_plano_ccusto,           /* PLANO CCUSTO */ 
                                                            INPUT  matriz-rat-ordem.sc-codigo,   /* CCUSTO */
                                                            INPUT  TODAY,                        /* DATA TRANSACAO */
                                                            OUTPUT TABLE tt_log_erro).           /* ERROS */
            FOR EACH tt_log_erro:
                RUN utp/ut-msgs.p (INPUT "show", INPUT 17006, INPUT tt_log_erro.ttv_des_msg_ajuda  + "~~" + "Encontrada inconsistencia na conta da matriz de rateio: " + tt_log_erro.ttv_des_msg_erro).
                RETURN NO-APPLY.
            END. /* FOR EACH tt_log_erro: */
        END. /* FOR EACH  matriz-rat-ordem NO-LOCK */

/* Comentada a obrigatoriedade de matriz de rateio conforme indicado por Gizelle Grabolle - 20/05/2014, Ös 9h00. */
/*         IF  tt-ordem-compra.it-codigo <> "INVESTI"                                                                                                                                                                         */
/*         AND NOT CAN-FIND(FIRST tt-prog-ponto WHERE tt-prog-ponto.conteudo = tt-ordem-compra.ct-codigo) THEN DO:                                                                                                            */
/*             IF  NOT CAN-FIND(FIRST matriz-rat-ordem                                                                                                                                                                        */
/*                              WHERE matriz-rat-ordem.numero-ordem   = tt-ordem-compra.numero-ordem                                                                                                                          */
/*                              AND   matriz-rat-ordem.sc-codigo      = tt-ordem-compra.sc-codigo) THEN DO:                                                                                                                   */
/*                 RUN utp/ut-msgs.p (INPUT "show", INPUT 17006, INPUT "Alteraá∆o cancelada!"  + "~~" + "Deve existir pelo menos uma matriz de rateio para o centro de custo informado. Alteraá∆o na tela ser† desfeita.":U). */
/*                 APPLY "LEAVE":U TO i-num-pedido IN FRAME f-cad.                                                                                                                                                            */
/*                 RETURN NO-APPLY.                                                                                                                                                                                           */
/*             END. /* IF  NOT CAN-FIND(FIRST matriz-rat-ordem ... */                                                                                                                                                         */
/*         END. /* IF  tt-ordem-compra.it-codigo <> "INVESTI" ... */                                                                                                                                                          */

        FIND FIRST ordem-compra EXCLUSIVE-LOCK
            WHERE rowid(ordem-compra) = tt-ordem-compra.r-rowid NO-ERROR.
        
        IF  AVAIL ordem-compra THEN DO:
            ASSIGN ordem-compra.ct-codigo      = tt-ordem-compra.ct-codigo
                   ordem-compra.sc-codigo      = tt-ordem-compra.sc-codigo
                   ordem-compra.it-codigo      = tt-ordem-compra.it-codigo
                   ordem-compra.cod-unid-negoc = tt-ordem-compra.cod-unid-negoc.

            FIND FIRST int-desp-cta-ctbl NO-LOCK
                 WHERE int-desp-cta-ctbl.cod-cta-ctbl = tt-ordem-compra.ct-codigo NO-ERROR.
    
            IF  AVAIL int-desp-cta-ctbl THEN
                ASSIGN ordem-compra.tp-despesa = int-desp-cta-ctbl.tp-codigo.

            FOR EACH   matriz-rat-ordem EXCLUSIVE-LOCK
                WHERE  matriz-rat-ordem.numero-ordem = ordem-compra.numero-ordem:

                /* Se a conta cont†bl informada for relacionada com o centro de custo da matriz de rateio, ok, pode mudar */
                RUN pi_valida_conta_contabil in h_api_cta_ctbl (INPUT  v_cod_empres_usuar,                        /* EMPRESA EMS2 */
                                                                INPUT  c-cod-estabel:SCREEN-VALUE IN FRAME f-cad, /* ESTABELECIMENTO EMS2 */
                                                                INPUT  SUBSTRING(matriz-rat-ordem.char-2,1,3),    /* UNIDADE NEGÖCIO */
                                                                INPUT  p_cod_plano_cta_ctbl,                      /* PLANO CONTAS */ 
                                                                INPUT  ordem-compra.ct-codigo,                    /* CONTA da OC*/
                                                                INPUT  p_cod_plano_ccusto,                        /* PLANO CCUSTO */ 
                                                                INPUT  matriz-rat-ordem.sc-codigo,                /* CCUSTO */
                                                                INPUT  TODAY,                                     /* DATA TRANSACAO */
                                                                OUTPUT TABLE tt_log_erro).                        /* ERROS */

                IF  NOT can-find(FIRST tt_log_erro)
                AND matriz-rat-ordem.sc-codigo <> "" THEN DO: 
                    IF  tt-ordem-compra.it-codigo <> "INVESTI"
                        AND NOT CAN-FIND(FIRST tt-prog-ponto WHERE tt-prog-ponto.conteudo = tt-ordem-compra.ct-codigo) THEN DO:
                        ASSIGN matriz-rat-ordem.ct-codigo = ordem-compra.ct-codigo.
                    END.
                END.

            END. /* FOR EACH   matriz-rat-ordem EXCLUSIVE-LOCK */

            FIND CURRENT ordem-compra NO-LOCK.

            FOR EACH   prazo-compra EXCLUSIVE-LOCK
                WHERE  prazo-compra.numero-ordem = ordem-compra.numero-ordem:
                ASSIGN prazo-compra.it-codigo = ordem-compra.it-codigo.
            END. /* FOR EACH   prazo-compra EXCLUSIVE-LOCK */
    
            FOR EACH   cotacao-item EXCLUSIVE-LOCK
                WHERE  cotacao-item.numero-ordem = ordem-compra.numero-ordem:
                ASSIGN cotacao-item.it-codigo = ordem-compra.it-codigo.
            END. /* FOR EACH   cotacao-item EXCLUSIVE-LOCK */
        END. /* IF  AVAIL ordem-compra THEN DO: */
        
        IF  tt-ordem-compra.it-codigo <> "INVESTI"
        AND NOT CAN-FIND(FIRST tt-prog-ponto WHERE tt-prog-ponto.conteudo = tt-ordem-compra.ct-codigo) THEN DO:
            RUN pi-carrega-matriz.
        END. /* IF  tt-ordem-compra.it-codigo <> "INVESTI" ... */

    END. /* IF  tt-ordem-compra.ct-codigo <> "" THEN DO: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ordem w-cadsim
ON VALUE-CHANGED OF br-ordem IN FRAME f-cad /* Ordens de Compra */
DO:
  RUN pi-carrega-matriz.

  ASSIGN ed-narrativa:SCREEN-VALUE IN FRAME f-cad = tt-ordem-compra.narrativa.

  FIND FIRST ITEM NO-LOCK
      WHERE ITEM.it-codigo = tt-ordem-compra.it-codigo NO-ERROR.
  
  IF ITEM.tipo-contr = 4 THEN
      ASSIGN tt-ordem-compra.it-codigo:READ-ONLY IN BROWSE br-ordem = NO.
  ELSE 
      ASSIGN tt-ordem-compra.it-codigo:READ-ONLY IN BROWSE br-ordem = YES.
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


&Scoped-define SELF-NAME bt-elimina
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-elimina w-cadsim
ON CHOOSE OF bt-elimina IN FRAME f-cad /* Eliminar */
DO:
    IF AVAIL tt-matriz-rat-ordem THEN
        FIND FIRST matriz-rat-ordem EXCLUSIVE-LOCK
            WHERE ROWID(matriz-rat-ordem) = tt-matriz-rat-ordem.r-rowid.

    DELETE matriz-rat-ordem.
    RUN pi-carrega-matriz.
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


&Scoped-define SELF-NAME bt-inclui
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inclui w-cadsim
ON CHOOSE OF bt-inclui IN FRAME f-cad /* Incluir */
DO:
    IF AVAIL tt-ordem-compra THEN DO:
    
        RUN esp/ccp/esccp034a.w (INPUT "add",
                                 INPUT tt-ordem-compra.numero-ordem,
                                 INPUT ?,
                                 INPUT "",
                                 INPUT "",
                                 INPUT 0,
                                 INPUT "",
                                 INPUT "").

        RUN pi-carrega-matriz.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-modifica
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-modifica w-cadsim
ON CHOOSE OF bt-modifica IN FRAME f-cad /* Modificar */
DO:
    IF AVAIL tt-matriz-rat-ordem THEN DO:
        RUN esp/ccp/esccp034a.w (INPUT "mod",
                                 INPUT tt-ordem-compra.numero-ordem,
                                 INPUT tt-matriz-rat-ordem.r-rowid,
                                 INPUT tt-matriz-rat-ordem.ct-codigo,
                                 INPUT tt-matriz-rat-ordem.sc-codigo,
                                 INPUT tt-matriz-rat-ordem.perc-rateio,
                                 INPUT tt-matriz-rat-ordem.char-1,
                                 INPUT substring(tt-matriz-rat-ordem.char-2,1,3)).

        FIND FIRST matriz-rat-ordem NO-LOCK
            WHERE ROWID(matriz-rat-ordem) = tt-matriz-rat-ordem.r-rowid NO-ERROR.

        IF AVAIL matriz-rat-ordem THEN DO:

            ASSIGN tt-matriz-rat-ordem.ct-codigo   = matriz-rat-ordem.ct-codigo   
                   tt-matriz-rat-ordem.sc-codigo   = matriz-rat-ordem.sc-codigo   
                   tt-matriz-rat-ordem.perc-rateio = matriz-rat-ordem.perc-rateio
                   tt-matriz-rat-ordem.char-2      = matriz-rat-ordem.char-2.

            DISPLAY matriz-rat-ordem.ct-codigo   @ tt-matriz-rat-ordem.ct-codigo   WITH BROWSE br-matriz.
            DISPLAY matriz-rat-ordem.sc-codigo   @ tt-matriz-rat-ordem.sc-codigo   WITH BROWSE br-matriz.
            DISPLAY matriz-rat-ordem.perc-rateio @ tt-matriz-rat-ordem.perc-rateio WITH BROWSE br-matriz.
            DISPLAY matriz-rat-ordem.char-2      @ tt-matriz-rat-ordem.char-2      WITH BROWSE br-matriz.
        END.
    END.
    RUN pi-total-perc. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* OK */
DO:
    IF AVAIL tt-matriz-rat-ordem THEN DO:
        IF INPUT FRAME f-cad i-num-pedido <> 0 
        AND d-total-perc <> 100 THEN DO:
            RUN utp/ut-msgs.p (INPUT "Show",
                               INPUT 27979,
                               INPUT "Percentual de rateio informado diferente de 100%!").
        END.
    END.

    apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-emitente w-cadsim
ON LEAVE OF c-cod-emitente IN FRAME f-cad /* Emitente */
DO:
    FOR FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = int(c-cod-emitente:SCREEN-VALUE IN FRAME f-cad):
    END.

    IF AVAIL emitente THEN DO:
        ASSIGN c-nome-emit:SCREEN-VALUE IN FRAME f-cad = emitente.nome-emit.
    END.
    ELSE DO:
        ASSIGN c-nome-emit:SCREEN-VALUE IN FRAME f-cad = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel w-cadsim
ON LEAVE OF c-cod-estabel IN FRAME f-cad /* Estabel */
DO:
  FIND FIRST estabelec NO-LOCK
      WHERE estabelec.cod-estabel = pedido-compr.cod-estabel NO-ERROR.

  IF AVAIL estabelec THEN DO:
      ASSIGN c-desc-estab:SCREEN-VALUE IN FRAME f-cad = estabelec.nome.
  END.
  ELSE DO:
      ASSIGN c-desc-estab:SCREEN-VALUE IN FRAME f-cad = "".  
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-num-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-num-pedido w-cadsim
ON F5 OF i-num-pedido IN FRAME f-cad /* Pedido */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in295"
                     &campo="i-num-pedido"
                     &campozoom="num-pedido"
                     &frame="f-cad"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-num-pedido w-cadsim
ON LEAVE OF i-num-pedido IN FRAME f-cad /* Pedido */
DO:
  FOR FIRST pedido-compr   NO-LOCK
      WHERE pedido-compr.num-pedido = INPUT FRAME f-cad i-num-pedido:
  END.

  IF AVAIL pedido-compr THEN DO:
      ASSIGN c-cod-emitente:SCREEN-VALUE IN FRAME f-cad = string(pedido-compr.cod-emitente)
             c-cod-estabel :SCREEN-VALUE IN FRAME f-cad = string(pedido-compr.cod-estabel)
             d-data        :SCREEN-VALUE IN FRAME f-cad = string(pedido-compr.data-pedido).
  END.
  ELSE DO:
      ASSIGN c-cod-emitente:SCREEN-VALUE IN FRAME f-cad = ""
             c-cod-estabel :SCREEN-VALUE IN FRAME f-cad = "".
  END.

  RUN pi-carrega-ordem.

  APPLY "LEAVE" TO c-cod-emitente.
  APPLY "LEAVE" TO c-cod-estabel.
  APPLY "VALUE-CHANGED" TO br-ordem.

  IF AVAIL tt-matriz-rat-ordem THEN DO:
      IF INPUT FRAME f-cad i-num-pedido <> 0 
      AND d-total-perc <> 100 THEN DO:
          RUN utp/ut-msgs.p (INPUT "Show",
                             INPUT 27979,
                             INPUT "Percentual de rateio informado diferente de 100%!").
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-num-pedido w-cadsim
ON MOUSE-SELECT-DBLCLICK OF i-num-pedido IN FRAME f-cad /* Pedido */
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


&Scoped-define BROWSE-NAME br-matriz
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

RUN esp/es0018p.p (INPUT "ESSDCV005":U,
                 INPUT 1,
                 INPUT 0,
                 INPUT "":U,
                 OUTPUT TABLE tt-prog-ponto).

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

IF i-num-pedido:LOAD-MOUSE-POINTER ("image/lupa.cur") THEN.
    
&Scoped-define SELF-NAME tt-ordem-compra.cod-unid-negoc
ON F5 OF tt-ordem-compra.cod-unid-negoc IN BROWSE br-ordem /* Sub-Conta */
DO:
    run prgint/utb/utb011ka.p.
    if v_rec_unid_negoc <> ?
    then do:
        find first unid_negoc where recid(unid_negoc) = v_rec_unid_negoc no-lock no-error.
        assign tt-ordem-compra.cod-unid-negoc:SCREEN-VALUE IN BROWSE br-ordem = string(unid_negoc.cod_unid_negoc).
    end /* if */.
                       
    APPLY "ENTRY":U TO tt-ordem-compra.cod-unid-negoc IN BROWSE br-ordem.
END.

ON MOUSE-SELECT-DBLCLICK OF tt-ordem-compra.cod-unid-negoc IN BROWSE br-ordem /* Conta */
DO:
    APPLY "F5":U TO tt-ordem-compra.cod-unid-negoc IN BROWSE br-ordem.
END.

&Scoped-define SELF-NAME tt-ordem-compra.it-codigo
ON F5 OF tt-ordem-compra.it-codigo IN BROWSE br-ordem /* Sub-Conta */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                       &campo=tt-ordem-compra.it-codigo
                       &campozoom=it-codigo
                       &BROWSE=br-ordem}
                       
    APPLY "ENTRY":U TO tt-ordem-compra.it-codigo IN BROWSE br-ordem.
END.

ON MOUSE-SELECT-DBLCLICK OF tt-ordem-compra.it-codigo IN BROWSE br-ordem /* Conta */
DO:
    APPLY "F5":U TO tt-ordem-compra.it-codigo IN BROWSE br-ordem.
END.

&Scoped-define SELF-NAME tt-ordem-compra.ct-codigo
ON F5 OF tt-ordem-compra.ct-codigo IN BROWSE br-ordem /* Conta */
DO:
     ASSIGN v_ind_finalid_cta = "(nenhum)".
     RUN pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT "",
                                                    INPUT "CEP",
                                                    INPUT "",
                                                    INPUT v_ind_finalid_cta,
                                                    INPUT TODAY,
                                                    OUTPUT v_cod_conta,
                                                    OUTPUT v_des_titulo_conta,
                                                    OUTPUT v_ind_finalid_cta,
                                                    OUTPUT TABLE tt_log_erro).    
      
      IF v_cod_conta <> "" THEN
          ASSIGN tt-ordem-compra.ct-codigo:SCREEN-VALUE IN BROWSE br-ordem = v_cod_conta.
                 
END.

ON LEAVE OF tt-ordem-compra.ct-codigo IN BROWSE br-ordem /* Conta */
DO:
    IF AVAILABLE tt-ordem-compra THEN DO:
        ASSIGN INPUT BROWSE br-ordem tt-ordem-compra.ct-codigo.
    END.
END.

ON LEAVE OF tt-ordem-compra.it-codigo IN BROWSE br-ordem /* Conta */
DO:
    IF AVAILABLE tt-ordem-compra THEN DO:
        ASSIGN INPUT BROWSE br-ordem tt-ordem-compra.it-codigo.
    END.
END.

ON LEAVE OF tt-ordem-compra.cod-unid-negoc IN BROWSE br-ordem /* Conta */
DO:
    IF AVAILABLE tt-ordem-compra THEN DO:
        ASSIGN INPUT BROWSE br-ordem tt-ordem-compra.cod-unid-negoc.
    END.
END.

ON MOUSE-SELECT-DBLCLICK OF tt-ordem-compra.ct-codigo IN BROWSE br-ordem /* Conta */
DO:
    APPLY "F5":U TO tt-ordem-compra.ct-codigo IN BROWSE br-ordem.
END.

&Scoped-define SELF-NAME tt-ordem-compra.sc-codigo
ON F5 OF tt-ordem-compra.sc-codigo IN BROWSE br-ordem /* Sub-Conta */
DO:
    RUN pi_zoom_ccusto IN h_api_ccusto (INPUT "",
                                        INPUT "",
                                        INPUT "",
                                        INPUT today,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_titulo_ccusto,
                                        OUTPUT TABLE tt_log_erro).
  
    IF v_cod_ccusto <> "" THEN
        ASSIGN tt-ordem-compra.sc-codigo:SCREEN-VALUE IN BROWSE br-ordem = v_cod_ccusto.
END.


ON LEAVE OF tt-ordem-compra.sc-codigo IN BROWSE br-ordem /* Sub-Conta */
DO:
    IF AVAILABLE tt-ordem-compra THEN DO:
        ASSIGN INPUT BROWSE br-ordem tt-ordem-compra.sc-codigo.
    END.
END.


ON MOUSE-SELECT-DBLCLICK OF tt-ordem-compra.sc-codigo IN BROWSE br-ordem /* Sub-Conta */
DO:
    APPLY "F5":U TO tt-ordem-compra.sc-codigo IN BROWSE br-ordem.
END.

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
  DISPLAY i-num-pedido c-cod-estabel c-desc-estab d-data c-cod-emitente 
          c-nome-emit ed-narrativa d-total-perc 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE rt-button RECT-1 i-num-pedido br-ordem ed-narrativa br-matriz 
         bt-inclui bt-modifica bt-elimina bt-ok bt-cancela bt-ajuda 
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

  {utp/ut9000.i "ESCCP034" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch  IN this-procedure ('enable-fields':U).

  {include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-matriz w-cadsim 
PROCEDURE pi-carrega-matriz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH tt-matriz-rat-ordem:
    DELETE tt-matriz-rat-ordem.
END.
ASSIGN d-total-perc = 0.
FOR EACH matriz-rat-ordem 
    WHERE matriz-rat-ordem.numero-ordem = tt-ordem-compra.numero-ordem NO-LOCK:
    CREATE tt-matriz-rat-ordem.
    BUFFER-COPY matriz-rat-ordem TO tt-matriz-rat-ordem.
    ASSIGN tt-matriz-rat-ordem.r-rowid = ROWID(matriz-rat-ordem).
END.

RUN pi-total-perc.

{&open-query-br-matriz}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-ordem w-cadsim 
PROCEDURE pi-carrega-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH tt-ordem-compra:
    DELETE tt-ordem-compra.
END.

FOR EACH ordem-compra OF pedido-compr NO-LOCK:
    CREATE tt-ordem-compra.
    BUFFER-COPY ordem-compra TO tt-ordem-compra.
    ASSIGN tt-ordem-compra.r-rowid = ROWID(ordem-compra).
END.

{&open-query-br-ordem}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-total-perc w-cadsim 
PROCEDURE pi-total-perc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN d-total-perc = 0.

FOR EACH b-tt-matriz-rat-ordem:
    ASSIGN d-total-perc = d-total-perc + b-tt-matriz-rat-ordem.perc-rateio.
END.

DISPLAY d-total-perc WITH FRAME f-cad.

IF d-total-perc > 100 THEN
    ASSIGN d-total-perc:FGCOLOR = 12.
ELSE IF d-total-perc < 100 THEN
    ASSIGN d-total-perc:FGCOLOR = 9.
ELSE 
    ASSIGN d-total-perc:FGCOLOR = 2.
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
  {src/adm/template/snd-list.i "tt-ordem-compra"}
  {src/adm/template/snd-list.i "tt-matriz-rat-ordem"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-situacao-ordem w-cadsim 
FUNCTION fn-situacao-ordem RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN string({ininc/i02in274.i 04 tt-ordem-compra.situacao}).   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

