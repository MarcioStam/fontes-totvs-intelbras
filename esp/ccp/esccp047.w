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
{include/i-prgvrs.i ESCCP047 2.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
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

DEF NEW GLOBAL SHARED VAR gr-item-tab  AS ROWID NO-UNDO.

DEF NEW GLOBAL SHARED VAR g-dt-limite-cc9014-upc AS DATE NO-UNDO.
DEF NEW GLOBAL SHARED VAR g-justif-cc9014-upc    AS CHARACTER FORMAT "X(500)":U NO-UNDO.

define variable wh-imprime as handle no-undo.

DEFINE VARIABLE c-situacao  AS CHARACTER NO-UNDO.
DEFINE VARIABLE d-dt-limite AS DATE      NO-UNDO.     

{upc/btb910za-upc.i}
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                       AS HANDLE       NO-UNDO.

{esp/imp/esimp000.i1} /*tt-emb*/

DEFINE TEMP-TABLE tt-prazo-compra LIKE prazo-compra
    FIELD num-pedido   LIKE ordem-compra.num-pedido
    FIELD embarque     LIKE ordens-embarque.embarque
    FIELD preco-fornec LIKE cotacao-item.preco-fornec
    FIELD mo-codigo    LIKE cotacao-item.mo-codigo
    FIELD situacao-emb   AS INT
    FIELD l-selecionado  AS LOG FORMAT "*/"
    FIELD l-pode-alterar AS LOG
    FIELD r-rowid        AS ROWID
    FIELD dat-limite     AS DATE
    FIELD cod-estabel    LIKE ordens-embarque.cod-estabel.

DEFINE BUFFER b-tt-prazo-compra FOR tt-prazo-compra.

DEFINE VARIABLE c-sit-emb AS CHARACTER   NO-UNDO.

// DEFINE INPUT PARAM p-row-table   AS ROWID.
// DEFINE INPUT PARAM p-cod-estabel AS CHAR.
// DEFINE INPUT PARAM p-dt-limite   AS DATE.
// DEFINE INPUT-OUTPUT PARAM p-motivo  AS CHAR.
// DEFINE OUTPUT PARAM TABLE FOR tt-prazo-compra.

DEF BUFFER b-tt-prazo-compra-aux FOR tt-prazo-compra.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-ordem-compra

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-prazo-compra

/* Definitions for BROWSE br-ordem-compra                               */
&Scoped-define FIELDS-IN-QUERY-br-ordem-compra tt-prazo-compra.l-selecionado tt-prazo-compra.dat-limite tt-prazo-compra.cod-estabel tt-prazo-compra.num-pedido tt-prazo-compra.numero-ordem tt-prazo-compra.parcela fnSituacaoParcela(tt-prazo-compra.situacao) @ c-situacao tt-prazo-compra.qtd-sal-forn tt-prazo-compra.preco-fornec tt-prazo-compra.embarque fnSitEmb(tt-prazo-compra.situacao-emb) @ c-sit-emb   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-ordem-compra   
&Scoped-define SELF-NAME br-ordem-compra
&Scoped-define QUERY-STRING-br-ordem-compra FOR EACH tt-prazo-compra
&Scoped-define OPEN-QUERY-br-ordem-compra OPEN QUERY {&SELF-NAME} FOR EACH tt-prazo-compra.
&Scoped-define TABLES-IN-QUERY-br-ordem-compra tt-prazo-compra
&Scoped-define FIRST-TABLE-IN-QUERY-br-ordem-compra tt-prazo-compra


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-ordem-compra}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button RECT-1 bt-enter c-cod-estabel-ini ~
c-cod-estabel-fim c-it-codigo i-cod-emitente i-num-pedido br-ordem-compra ~
bt-ok bt-nenhum bt-marca bt-desmarca bt-Alterar c-motivo bt-sair 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estabel-ini c-cod-estabel-fim ~
c-it-codigo i-cod-emitente i-num-pedido c-motivo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSitEmb w-cadsim 
FUNCTION fnSitEmb RETURNS CHARACTER
  ( p-sit-emb AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSituacaoParcela w-cadsim 
FUNCTION fnSituacaoParcela RETURNS CHARACTER
  ( p-situacao AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-Alterar AUTO-GO 
     LABEL "&Alterar Preáo" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-desmarca AUTO-GO 
     LABEL "&Desmarca" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-enter 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON bt-marca AUTO-GO 
     LABEL "&Marca" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-nenhum AUTO-GO 
     LABEL "&Nenhum" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&Todos" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-sair AUTO-GO 
     LABEL "&Fechar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-motivo AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 102.86 BY 2.5 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-fim AS CHARACTER FORMAT "X(3)":U 
     LABEL "atÇ" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .79 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .79 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "x(14)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 TOOLTIP "Fornecedor" NO-UNDO.

DEFINE VARIABLE i-num-pedido AS INTEGER FORMAT ">>>>>,>>9" INITIAL 0 
     LABEL "Pedido":R8 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 103 BY 1.29.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 103 BY 1.38
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-ordem-compra FOR 
      tt-prazo-compra SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-ordem-compra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-ordem-compra w-cadsim _FREEFORM
  QUERY br-ordem-compra DISPLAY
      tt-prazo-compra.l-selecionado COLUMN-LABEL "*"
 tt-prazo-compra.dat-limite  COLUMN-LABEL "A Partir de" FORMAT "99/99/9999"
 tt-prazo-compra.cod-estabel COLUMN-LABEL "Estab"
 tt-prazo-compra.num-pedido
 tt-prazo-compra.numero-ordem
 tt-prazo-compra.parcela
 fnSituacaoParcela(tt-prazo-compra.situacao) @ c-situacao COLUMN-LABEL "Situaá∆o" FORMAT "X(14)"
 tt-prazo-compra.qtd-sal-forn 
 tt-prazo-compra.preco-fornec
 tt-prazo-compra.embarque
 fnSitEmb(tt-prazo-compra.situacao-emb) @ c-sit-emb COLUMN-LABEL "Sit. Emb."
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 103 BY 10.5
         FONT 7
         TITLE "Parcelas" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-enter AT ROW 1.42 COL 89.72 WIDGET-ID 50
     c-cod-estabel-ini AT ROW 1.46 COL 7.57 COLON-ALIGNED WIDGET-ID 18
     c-cod-estabel-fim AT ROW 1.46 COL 16.57 COLON-ALIGNED WIDGET-ID 20
     c-it-codigo AT ROW 1.46 COL 27.29 COLON-ALIGNED HELP
          "C¢digo Item" WIDGET-ID 44
     i-cod-emitente AT ROW 1.46 COL 55.72 COLON-ALIGNED WIDGET-ID 46
     i-num-pedido AT ROW 1.46 COL 76 COLON-ALIGNED HELP
          "N£mero do Pedido de Compra" WIDGET-ID 48
     br-ordem-compra AT ROW 2.75 COL 2 WIDGET-ID 200
     bt-ok AT ROW 13.38 COL 2.29
     bt-nenhum AT ROW 13.38 COL 12.86 WIDGET-ID 2
     bt-marca AT ROW 13.38 COL 23.29 WIDGET-ID 4
     bt-desmarca AT ROW 13.38 COL 33.86 WIDGET-ID 6
     bt-Alterar AT ROW 13.5 COL 94.57 WIDGET-ID 14
     c-motivo AT ROW 15.21 COL 2.14 NO-LABEL WIDGET-ID 10
     bt-sair AT ROW 18.13 COL 2.72 WIDGET-ID 12
     "Motivo:" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 14.42 COL 2.14 WIDGET-ID 8
     rt-button AT ROW 17.92 COL 2
     RECT-1 AT ROW 1.25 COL 2 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 105 BY 18.5
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
         HEIGHT             = 18.58
         WIDTH              = 104.72
         MAX-HEIGHT         = 28.33
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.33
         VIRTUAL-WIDTH      = 195.14
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
/* BROWSE-TAB br-ordem-compra i-num-pedido f-cad */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-ordem-compra
/* Query rebuild information for BROWSE br-ordem-compra
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-prazo-compra.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-ordem-compra */
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


&Scoped-define BROWSE-NAME br-ordem-compra
&Scoped-define SELF-NAME br-ordem-compra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ordem-compra w-cadsim
ON MOUSE-SELECT-DBLCLICK OF br-ordem-compra IN FRAME f-cad /* Parcelas */
DO:
    FOR EACH b-tt-prazo-compra
       WHERE b-tt-prazo-compra.numero-ordem = tt-prazo-compra.numero-ordem
         AND b-tt-prazo-compra.l-pode-alterar:

        ASSIGN b-tt-prazo-compra.l-selecionado = NOT b-tt-prazo-compra.l-selecionado.
    END.

    br-ordem-compra:REFRESH().

    RUN pi-habilita-botao-alteracao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ordem-compra w-cadsim
ON ROW-DISPLAY OF br-ordem-compra IN FRAME f-cad /* Parcelas */
DO:
   IF NOT tt-prazo-compra.l-pode-alterar THEN DO:
       ASSIGN tt-prazo-compra.l-selecionado:BGCOLOR IN BROWSE br-ordem-compra = 8 
              tt-prazo-compra.num-pedido   :BGCOLOR IN BROWSE br-ordem-compra = 8
              tt-prazo-compra.numero-ordem :BGCOLOR IN BROWSE br-ordem-compra = 8
              tt-prazo-compra.parcela      :BGCOLOR IN BROWSE br-ordem-compra = 8
              c-situacao                   :BGCOLOR IN BROWSE br-ordem-compra = 8
              tt-prazo-compra.qtd-sal-forn :BGCOLOR IN BROWSE br-ordem-compra = 8
              tt-prazo-compra.preco-fornec :BGCOLOR IN BROWSE br-ordem-compra = 8
              tt-prazo-compra.embarque     :BGCOLOR IN BROWSE br-ordem-compra = 8
              c-sit-emb :BGCOLOR IN BROWSE br-ordem-compra = 8.
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ordem-compra w-cadsim
ON VALUE-CHANGED OF br-ordem-compra IN FRAME f-cad /* Parcelas */
DO:
  RUN pi-habilita-botao-alteracao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-Alterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-Alterar w-cadsim
ON CHOOSE OF bt-Alterar IN FRAME f-cad /* Alterar Preáo */
DO:
    
    ASSIGN INPUT FRAME f-cad c-motivo.
    

    IF  CAN-FIND(FIRST b-tt-prazo-compra-aux
                    WHERE b-tt-prazo-compra-aux.l-selecionado = YES) THEN DO:
        IF LENGTH(c-motivo) < 10 THEN DO:
            RUN utp\ut-msgs.p ("show",
                               17006,
                               "Devem ser informados ao menos 10 caracteres no campo motivo.").
            RETURN NO-APPLY.
        END.
        ELSE DO:
            /* Alteraá∆o do preáo conforme inicialmente era feito pela upc do escc047.p*/
            def var i-num-casa-dec as dec.
            def var de-fator-conver as dec.
    
            FOR EACH b-tt-prazo-compra-aux
               WHERE b-tt-prazo-compra-aux.l-selecionado
                BREAK BY b-tt-prazo-compra-aux.numero-ordem:
    
                IF FIRST-OF(b-tt-prazo-compra-aux.numero-ordem) THEN DO:
    

                    FIND FIRST ordem-compra EXCLUSIVE-LOCK
                         WHERE ordem-compra.numero-ordem = b-tt-prazo-compra-aux.numero-ordem NO-ERROR.
    
                    FIND FIRST cotacao-item EXCLUSIVE-LOCK 
                         WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                           AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                           AND cotacao-item.cot-aprovada NO-ERROR.
                
                    find item-fornec
                         where item-fornec.it-codigo = item-tab.it-codigo
                           and item-fornec.cod-emitente = tb-pr-cc.cod-emitente no-lock.
    
                    CREATE alt-ped.
                    ASSIGN alt-ped.num-pedido   = ordem-compra.num-pedido
                           alt-ped.numero-ordem = ordem-compra.numero-ordem
                           alt-ped.parcela      = b-tt-prazo-compra-aux.parcela
                           alt-ped.preco        = ordem-compra.preco-unit.
                    
                    assign i-num-casa-dec = exp(10,item-fornec.num-casa-dec).
                                
                    assign de-fator-conver = item-fornec.fator-conver / i-num-casa-dec.    
            
                    assign ordem-compra.preco-unit = item-tab.pr-item * de-fator-conver 
                           + if not tb-pr-cc.codigo-ipi then 
                           ((item-tab.pr-item * de-fator-conver) * item-tab.aliquota-ipi / 100)
                           else 0 
            
                           cotacao-item.preco-unit = item-tab.pr-item * de-fator-conver  
                           + if not tb-pr-cc.codigo-ipi then 
                           ((item-tab.pr-item * de-fator-conver) * item-tab.aliquota-ipi / 100)
                           else 0 
                           ordem-compra.pre-unit-for = item-tab.pr-item
                           + if not tb-pr-cc.codigo-ipi then 
                           ((item-tab.pr-item) * item-tab.aliquota-ipi / 100)
                           else 0 
                           ordem-compra.preco-fornec = item-tab.pr-item
                           cotacao-item.pre-unit-for = item-tab.pr-item
                           + if not tb-pr-cc.codigo-ipi then 
                           ((item-tab.pr-item) * item-tab.aliquota-ipi / 100)
                           else 0 
                           cotacao-item.preco-fornec = item-tab.pr-item
                           ordem-compra.aliquota-icm = item-tab.aliquota-icm
                           cotacao-item.aliquota-icm = item-tab.aliquota-icm
                           ordem-compra.aliquota-ipi = item-tab.aliquota-ipi
                           cotacao-item.aliquota-ipi = item-tab.aliquota-ipi.
    
                 ASSIGN alt-ped.data         = today
                        alt-ped.char-1       = STRING(ordem-compra.preco-unit) + "|" + "0" + "|" + "?"
                        alt-ped.hora         = string(time,"hh:mm:ss")
                        alt-ped.usuario      = c-seg-usuario
                        alt-ped.data-entrega = b-tt-prazo-compra-aux.data-entrega
                        alt-ped.observacao   = c-motivo
                        alt-ped.quantidade   = ?
                        alt-ped.cod-cond-pag = ?. 
                END.
    
            END.
        END.
    END.

    APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desmarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desmarca w-cadsim
ON CHOOSE OF bt-desmarca IN FRAME f-cad /* Desmarca */
DO:
    FOR EACH b-tt-prazo-compra
       WHERE b-tt-prazo-compra.numero-ordem = tt-prazo-compra.numero-ordem:
    
        ASSIGN b-tt-prazo-compra.l-selecionado = NO.
    END.
    
    br-ordem-compra:REFRESH().
    RUN pi-habilita-botao-alteracao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-enter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-enter w-cadsim
ON CHOOSE OF bt-enter IN FRAME f-cad
DO:
    ASSIGN INPUT FRAME f-cad c-it-codigo.
    IF c-it-codigo = "" THEN DO:
        MESSAGE "Item n∆o pode ser igual a branco!" VIEW-AS ALERT-BOX ERROR.
        APPLY "entry" TO c-it-codigo IN FRAME f-cad.
    END.
    ELSE DO:
        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = c-it-codigo NO-ERROR.
        IF NOT AVAIL ITEM THEN DO:
            MESSAGE "Item inexistente!" VIEW-AS ALERT-BOX ERROR.
            APPLY "entry" TO c-it-codigo IN FRAME f-cad.
        END.
        ELSE DO:
            IF gr-item-tab <> ? THEN DO:
                FIND item-tab NO-LOCK
                    WHERE ROWID (item-tab) = gr-item-tab NO-ERROR.
                IF AVAIL item-tab THEN DO:
                    FIND LAST int-item-tab NO-LOCK
                        WHERE int-item-tab.cod-emitente   = item-tab.cod-emitente  
                          AND int-item-tab.cdn-fabrican   = item-tab.cdn-fabrican  
                          AND int-item-tab.des-referencia = item-tab.des-referencia
                          AND int-item-tab.cod-cond-pag   = item-tab.cod-cond-pag  
                          AND int-item-tab.nr-tab         = item-tab.nr-tab        
                          AND int-item-tab.dt-inicio      = item-tab.dt-inicio     
                          AND int-item-tab.it-codigo      = item-tab.it-codigo     
                          AND int-item-tab.quant-min      = item-tab.quant-min NO-ERROR.
                    IF AVAIL int-item-tab THEN DO:
                        ASSIGN c-motivo = TRIM (int-item-tab.justificativa).
                    END.
                END.
                DISP c-motivo WITH FRAME f-cad.
            END.
            RUN pi-carrega-tt.
        END.            
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca w-cadsim
ON CHOOSE OF bt-marca IN FRAME f-cad /* Marca */
DO:
    FOR EACH b-tt-prazo-compra
       WHERE b-tt-prazo-compra.numero-ordem = tt-prazo-compra.numero-ordem
         AND b-tt-prazo-compra.l-pode-alterar:
    
        ASSIGN b-tt-prazo-compra.l-selecionado = YES.
    END.
    
    br-ordem-compra:REFRESH().
    RUN pi-habilita-botao-alteracao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-nenhum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nenhum w-cadsim
ON CHOOSE OF bt-nenhum IN FRAME f-cad /* Nenhum */
DO:
  FOR EACH tt-prazo-compra:
       ASSIGN tt-prazo-compra.l-selecionado = NO.
   END.

   br-ordem-compra:REFRESH().
   RUN pi-habilita-botao-alteracao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* Todos */
DO:
    FOR EACH tt-prazo-compra
       WHERE tt-prazo-compra.l-pode-alterar:
        ASSIGN tt-prazo-compra.l-selecionado = YES.
    END.

    br-ordem-compra:REFRESH().
    RUN pi-habilita-botao-alteracao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sair w-cadsim
ON CHOOSE OF bt-sair IN FRAME f-cad /* Fechar */
DO:
    EMPTY TEMP-TABLE tt-prazo-compra.
    APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo w-cadsim
ON F5 OF c-it-codigo IN FRAME f-cad /* Item */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z02in172.w
                        &campo=c-it-codigo
                        &campozoom=it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo w-cadsim
ON LEAVE OF c-it-codigo IN FRAME f-cad /* Item */
DO:
    ASSIGN INPUT FRAME f-cad c-it-codigo.
    IF c-it-codigo = "" THEN DO:
        MESSAGE "Item n∆o pode ser igual a branco!" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    ELSE DO:
        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = c-it-codigo NO-ERROR.
        IF NOT AVAIL ITEM THEN DO:
            MESSAGE "Item inexistente!" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo w-cadsim
ON MOUSE-SELECT-DBLCLICK OF c-it-codigo IN FRAME f-cad /* Item */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente w-cadsim
ON F5 OF i-cod-emitente IN FRAME f-cad /* Fornecedor */
DO:
   {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
                           &campo=i-cod-emitente
                           &campozoom=cod-emitente
                           &FRAME=f-cad}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente w-cadsim
ON LEAVE OF i-cod-emitente IN FRAME f-cad /* Fornecedor */
DO:
   ASSIGN INPUT FRAME f-cad i-cod-emitente.
   IF i-cod-emitente > 0 THEN DO:
       FIND emitente NO-LOCK
           WHERE emitente.cod-emitente = i-cod-emitente NO-ERROR.
       IF NOT AVAIL emitente THEN DO:
           MESSAGE "Fornecedor inexistente!" VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.
       END.
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
    ASSIGN INPUT FRAME f-cad i-num-pedido.
    IF i-num-pedido > 0 THEN DO:
        FIND pedido-compr NO-LOCK
            WHERE pedido-compr.num-pedido = i-num-pedido NO-ERROR.
        IF NOT AVAIL pedido-comp THEN DO:
            MESSAGE "Pedido de Compra inexistente!" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
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
  DISPLAY c-cod-estabel-ini c-cod-estabel-fim c-it-codigo i-cod-emitente 
          i-num-pedido c-motivo 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE rt-button RECT-1 bt-enter c-cod-estabel-ini c-cod-estabel-fim 
         c-it-codigo i-cod-emitente i-num-pedido br-ordem-compra bt-ok 
         bt-nenhum bt-marca bt-desmarca bt-Alterar c-motivo bt-sair 
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

  {utp/ut9000.i "ESCCP047" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  ASSIGN c-cod-estabel-ini:SCREEN-VALUE IN FRAME f-cad = v_cod_estab_usuar
         c-cod-estabel-fim:SCREEN-VALUE IN FRAME f-cad = v_cod_estab_usuar.

  IF g-dt-limite-cc9014-upc <> ? THEN
      ASSIGN d-dt-limite = g-dt-limite-cc9014-upc.
  ELSE
      ASSIGN d-dt-limite = TODAY.

  IF g-justif-cc9014-upc <> "" THEN
      ASSIGN c-motivo:SCREEN-VALUE IN FRAME f-cad = g-justif-cc9014-upc.

  RUN dispatch  IN this-procedure ('enable-fields':U).

  // RUN pi-carrega-tt.

  {include/i-inifld.i}

  IF gr-item-tab <> ? THEN DO:
      FIND item-tab NO-LOCK
          WHERE ROWID (item-tab) = gr-item-tab NO-ERROR.
      IF AVAIL item-tab THEN DO:
          ASSIGN c-cod-estabel-ini:SCREEN-VALUE IN FRAME f-cad = item-tab.cod-estabel
                 c-cod-estabel-fim:SCREEN-VALUE IN FRAME f-cad = item-tab.cod-estabel
                 c-it-codigo:SCREEN-VALUE IN FRAME f-cad       = item-tab.it-codigo
                 i-cod-emitente:SCREEN-VALUE IN FRAME f-cad    = STRING (item-tab.cod-emitente).          
          FIND item-tab NO-LOCK
              WHERE ROWID (item-tab) = gr-item-tab NO-ERROR.
          IF AVAIL item-tab THEN DO:
              FIND LAST int-item-tab NO-LOCK
                  WHERE int-item-tab.cod-emitente   = item-tab.cod-emitente  
                    AND int-item-tab.cdn-fabrican   = item-tab.cdn-fabrican  
                    AND int-item-tab.des-referencia = item-tab.des-referencia
                    AND int-item-tab.cod-cond-pag   = item-tab.cod-cond-pag  
                    AND int-item-tab.nr-tab         = item-tab.nr-tab        
                    AND int-item-tab.dt-inicio      = item-tab.dt-inicio     
                    AND int-item-tab.it-codigo      = item-tab.it-codigo     
                    AND int-item-tab.quant-min      = item-tab.quant-min NO-ERROR.
              IF AVAIL int-item-tab THEN DO:
                  ASSIGN c-motivo = TRIM (int-item-tab.justificativa).
                  DISPLAY c-motivo
                          WITH FRAME f-cad.                  
              END.
          END.
          APPLY "choose" TO bt-enter IN FRAME f-cad.
      END.      
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-posicao w-cadsim 
PROCEDURE pi-busca-posicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-emb.

    FOR EACH  embarque-imp NO-LOCK
        WHERE embarque-imp.situacao    = 1 /* N∆o Encerrado */
        AND   embarque-imp.cod-estabel = ordens-embarque.cod-estabel
        AND   embarque-imp.embarque    = ordens-embarque.embarque:

        {esp/imp/esimp000.i}   
        
    END. /* FOR EACH  embarque-imp NO-LOCK */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-tt w-cadsim 
PROCEDURE pi-carrega-tt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR i-cod-fornec-ini AS INT NO-UNDO.
DEF VAR i-cod-fornec-fim AS INT NO-UNDO.
DEF VAR i-num-pedido-ini AS INT NO-UNDO.
DEF VAR i-num-pedido-fim AS INT NO-UNDO.

EMPTY TEMP-TABLE tt-prazo-compra.

IF i-cod-emitente > 0 THEN
    ASSIGN i-cod-fornec-ini = i-cod-emitente
           i-cod-fornec-fim = i-cod-emitente.
ELSE
    ASSIGN i-cod-fornec-ini = 0
           i-cod-fornec-fim = 999999999.

IF i-num-pedido > 0 THEN
    ASSIGN i-num-pedido-ini = i-num-pedido
           i-num-pedido-fim = i-num-pedido.
ELSE
    ASSIGN i-num-pedido-ini = 0
           i-num-pedido-fim = 999999999.

IF i-num-pedido = 0 THEN DO:
    FOR FIRST item-tab NO-LOCK
        WHERE ROWID(item-tab) = gr-item-tab,
        FIRST tb-pr-cc NO-LOCK 
        WHERE tb-pr-cc.cod-emitente  = item-tab.cod-emitente  
          AND tb-pr-cc.cod-cond-pag  = item-tab.cod-cond-pag  
          AND tb-pr-cc.nr-tab        = item-tab.nr-tab        
          AND tb-pr-cc.nome-abrev    = item-tab.nome-abrev:
        FOR EACH ordem-compra NO-LOCK 
           WHERE ordem-compra.it-codigo    = item-tab.it-codigo
             AND ordem-compra.situacao     = 2 /*"C"*/
             AND ordem-compra.num-pedido   >= i-num-pedido-ini
             AND ordem-compra.num-pedido   <= i-num-pedido-fim
             AND ordem-compra.cod-estabel  >= INPUT FRAME f-cad c-cod-estabel-ini
             AND ordem-compra.cod-estabel  <= INPUT FRAME f-cad c-cod-estabel-fim
             AND ordem-compra.cod-emitente >= i-cod-fornec-ini
             AND ordem-compra.cod-emitente <= i-cod-fornec-fim,
            EACH prazo-compra NO-LOCK 
           WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
             AND prazo-compra.data-entrega > d-dt-limite
             /*AND prazo-compra.quant-saldo > 0*/:

            FIND FIRST cotacao-item NO-LOCK 
                 WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                   AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                   AND cotacao-item.cot-aprovada NO-ERROR.

            IF NOT AVAIL cotacao-item THEN 
                NEXT.

            FIND FIRST ordens-embarque NO-LOCK
                 WHERE ordens-embarque.numero-ordem  = prazo-compra.numero-ordem
                   AND ordens-embarque.parcela       = prazo-compra.parcela NO-ERROR.

            IF AVAIL ordens-embarque THEN DO:
                RUN pi-busca-posicao. 

                FIND FIRST tt-emb NO-ERROR.
            END.

            CREATE tt-prazo-compra.
            BUFFER-COPY prazo-compra TO tt-prazo-compra.
            ASSIGN tt-prazo-compra.r-rowid      = ROWID(prazo-compra)
                   tt-prazo-compra.num-pedido   = ordem-compra.num-pedido
                   tt-prazo-compra.preco-fornec = cotacao-item.preco-fornec
                   tt-prazo-compra.mo-codigo    = cotacao-item.mo-codigo
                   tt-prazo-compra.embarque     = IF AVAIL ordens-embarque THEN ordens-embarque.embarque ELSE ''
                   tt-prazo-compra.situacao-emb = IF AVAIL tt-emb THEN tt-emb.situacao ELSE 0
                   tt-prazo-compra.l-pode-alterar = YES
                   tt-prazo-compra.cod-estabel  = ordem-compra.cod-estabel.

            /*Parcelas nessas situaá‰es n∆o pode altrar*/
            IF (AVAIL tt-emb
            AND tt-emb.situacao <> 99 /*AGT*/
            AND tt-emb.situacao <> 96 /*INST*/
            AND tt-emb.situacao <> 97 /*MANUT*/
            AND tt-emb.situacao <> 1) /*PREV*/
             OR prazo-compra.quant-saldo <= 0 THEN DO:
                ASSIGN tt-prazo-compra.l-pode-alterar = NO.
            END.
        END.

        /*Tendo uma parcela que nao pode altrar na ordem bloqueia alteraá∆o de todas as parcelas da ordem*/
        FOR EACH b-tt-prazo-compra
           WHERE NOT b-tt-prazo-compra.l-pode-alterar:

            FOR EACH tt-prazo-compra
               WHERE tt-prazo-compra.numero-ordem = b-tt-prazo-compra.numero-ordem:
                ASSIGN tt-prazo-compra.l-pode-alterar = NO.
            END.
        END.
    END.
END.
ELSE DO:
    FOR FIRST item-tab NO-LOCK
        WHERE ROWID(item-tab) = gr-item-tab,
        FIRST tb-pr-cc NO-LOCK 
        WHERE tb-pr-cc.cod-emitente  = item-tab.cod-emitente  
          AND tb-pr-cc.cod-cond-pag  = item-tab.cod-cond-pag  
          AND tb-pr-cc.nr-tab        = item-tab.nr-tab        
          AND tb-pr-cc.nome-abrev    = item-tab.nome-abrev:
        FOR EACH ordem-compra NO-LOCK 
           WHERE ordem-compra.it-codigo    = item-tab.it-codigo
             AND ordem-compra.num-pedido   = i-num-pedido-ini
             AND ordem-compra.situacao     = 2 /*"C"*/
             AND ordem-compra.cod-estabel  >= INPUT FRAME f-cad c-cod-estabel-ini
             AND ordem-compra.cod-estabel  <= INPUT FRAME f-cad c-cod-estabel-fim
             AND ordem-compra.cod-emitente >= i-cod-fornec-ini
             AND ordem-compra.cod-emitente <= i-cod-fornec-fim,
            EACH prazo-compra NO-LOCK 
           WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
             AND prazo-compra.data-entrega > d-dt-limite
             /*AND prazo-compra.quant-saldo > 0*/:
            FIND FIRST cotacao-item NO-LOCK 
                 WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                   AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                   AND cotacao-item.cot-aprovada NO-ERROR.

            IF NOT AVAIL cotacao-item THEN 
                NEXT.

            FIND FIRST ordens-embarque NO-LOCK
                 WHERE ordens-embarque.numero-ordem  = prazo-compra.numero-ordem
                   AND ordens-embarque.parcela       = prazo-compra.parcela NO-ERROR.

            IF AVAIL ordens-embarque THEN DO:
                RUN pi-busca-posicao. 

                FIND FIRST tt-emb NO-ERROR.
            END.

            CREATE tt-prazo-compra.
            BUFFER-COPY prazo-compra TO tt-prazo-compra.
            ASSIGN tt-prazo-compra.r-rowid      = ROWID(prazo-compra)
                   tt-prazo-compra.num-pedido   = ordem-compra.num-pedido
                   tt-prazo-compra.preco-fornec = cotacao-item.preco-fornec
                   tt-prazo-compra.mo-codigo    = cotacao-item.mo-codigo
                   tt-prazo-compra.embarque     = IF AVAIL ordens-embarque THEN ordens-embarque.embarque ELSE ''
                   tt-prazo-compra.situacao-emb = IF AVAIL tt-emb THEN tt-emb.situacao ELSE 0
                   tt-prazo-compra.l-pode-alterar = YES
                   tt-prazo-compra.cod-estabel  = ordem-compra.cod-estabel.

            /*Parcelas nessas situaá‰es n∆o pode altrar*/
            IF (AVAIL tt-emb
            AND tt-emb.situacao <> 99 /*AGT*/
            AND tt-emb.situacao <> 96 /*INST*/
            AND tt-emb.situacao <> 97 /*MANUT*/
            AND tt-emb.situacao <> 1) /*PREV*/
             OR prazo-compra.quant-saldo <= 0 THEN DO:
                ASSIGN tt-prazo-compra.l-pode-alterar = NO.
            END.
        END.

        /*Tendo uma parcela que nao pode altrar na ordem bloqueia alteraá∆o de todas as parcelas da ordem*/
        FOR EACH b-tt-prazo-compra
           WHERE NOT b-tt-prazo-compra.l-pode-alterar:

            FOR EACH tt-prazo-compra
               WHERE tt-prazo-compra.numero-ordem = b-tt-prazo-compra.numero-ordem:
                ASSIGN tt-prazo-compra.l-pode-alterar = NO.
            END.
        END.
    END.
END.

{&open-query-br-ordem-compra}
RUN pi-habilita-botao-alteracao.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-botao-alteracao w-cadsim 
PROCEDURE pi-habilita-botao-alteracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  CAN-FIND(FIRST b-tt-prazo-compra-aux
                    WHERE b-tt-prazo-compra-aux.l-selecionado = YES) THEN
       ASSIGN bt-Alterar:SENSITIVE IN FRAME f-cad = YES
              c-motivo:SENSITIVE IN FRAME f-cad = YES.
    ELSE
       ASSIGN bt-Alterar:SENSITIVE in FRAME f-cad = NO
              c-motivo:SENSITIVE IN FRAME f-cad = NO.


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
  {src/adm/template/snd-list.i "tt-prazo-compra"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSitEmb w-cadsim 
FUNCTION fnSitEmb RETURNS CHARACTER
  ( p-sit-emb AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    CASE p-sit-emb:
        WHEN 99 THEN RETURN "Agt".
        WHEN 1  THEN RETURN "Prev".
        WHEN 2  THEN RETURN "Embar".
        WHEN 98 THEN RETURN "DI".
        WHEN 3  THEN RETURN "Desp".
        WHEN 4  THEN RETURN "NF".
    END CASE.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSituacaoParcela w-cadsim 
FUNCTION fnSituacaoParcela RETURNS CHARACTER
  ( p-situacao AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    RETURN {ininc/i02in274.i 04 p-situacao}.
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

