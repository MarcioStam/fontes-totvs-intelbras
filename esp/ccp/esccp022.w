&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esccp022 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esccp022
&GLOBAL-DEFINE Version        001

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              fi-num-pedido fi-dt-fatur cb-tipo br-ordens bt-atualiza

&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def temp-table tt-ordem         no-undo
    field numero-ordem          like ordem-compra.numero-ordem
    field data-emissao          like ordem-compra.data-emissao
    field it-codigo             like ordem-compra.it-codigo FORMAT "x(07)"
    field desc-item             like item.desc-item         FORMAT "x(40)"
    FIELD quantidade            LIKE ordem-compra.qt-solic
    FIELD preco-fornec          LIKE ordem-compra.preco-fornec
    FIELD valor-fornec          AS DECIMAL FORMAT ">,>>>,>>9.99999"
    FIELD cotacao               AS DECIMAL FORMAT ">>9.99999999"
    FIELD preco                 AS DECIMAL FORMAT ">,>>>,>>9.99999"
    FIELD valor-real            AS DECIMAL FORMAT ">,>>>,>>9.99999".
    
    
DEF VAR h-acomp AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-ordens

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ordem

/* Definitions for BROWSE br-ordens                                     */
&Scoped-define FIELDS-IN-QUERY-br-ordens tt-ordem.numero-ordem tt-ordem.data-emissao tt-ordem.it-codigo tt-ordem.desc-item tt-ordem.quantidade tt-ordem.preco-fornec tt-ordem.valor-fornec tt-ordem.cotacao tt-ordem.preco tt-ordem.valor-real   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-ordens   
&Scoped-define SELF-NAME br-ordens
&Scoped-define QUERY-STRING-br-ordens FOR EACH tt-ordem
&Scoped-define OPEN-QUERY-br-ordens OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem.
&Scoped-define TABLES-IN-QUERY-br-ordens tt-ordem
&Scoped-define FIRST-TABLE-IN-QUERY-br-ordens tt-ordem


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-ordens}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-vl-tot-fornec fi-vl-tot-real ~
fi-num-pedido fi-dt-fatur cb-tipo bt-atualiza br-ordens btQueryJoins ~
btReportsJoins btExit btHelp rtToolBar-2 
&Scoped-Define DISPLAYED-OBJECTS fi-vl-tot-fornec fi-vl-tot-real ~
fi-num-pedido fi-dt-fatur cb-tipo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-atualiza 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "bt atualiza 2" 
     SIZE 4 BY 1.13.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE cb-tipo AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Cotaá∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Data Pedido",1,
                     "Dia anterior ao faturamento",2,
                     "MÇdia da semana anterior ao faturamento",3,
                     "MÇdia do màs anterior ao fatutamento",4,
                     "Èltimo dia do màs anterior ao faturamento",5
     DROP-DOWN-LIST
     SIZE 45.57 BY 1 NO-UNDO.

DEFINE VARIABLE fi-dt-fatur AS DATE FORMAT "99/99/9999" 
     LABEL "Dt. Faturamento" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-num-pedido AS INTEGER FORMAT ">>>>>,>>9" INITIAL 0 
     LABEL "Pedido":R8 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-tot-fornec AS DECIMAL FORMAT "->,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Total Fornec" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE fi-vl-tot-real AS DECIMAL FORMAT "->,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Total" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88
     FGCOLOR 3  NO-UNDO.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 128 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-ordens FOR 
      tt-ordem SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-ordens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-ordens wWindow _FREEFORM
  QUERY br-ordens DISPLAY
      tt-ordem.numero-ordem       column-label "Ordem"      WIDTH 8
    tt-ordem.data-emissao       column-label "Emiss∆o"      WIDTH 8.5
    tt-ordem.it-codigo          column-label "Item"         format "x(07)" WIDTH 7
    tt-ordem.desc-item          column-label "Descriá∆o"    format "x(30)" WIDTH 30
    tt-ordem.quantidade         COLUMN-LABEL "Quantidade"   WIDTH 12
    tt-ordem.preco-fornec       COLUMN-LABEL "Preco Fornec" WIDTH 9.5
    tt-ordem.valor-fornec       COLUMN-LABEL "Valor Fornec" WIDTH 11
    tt-ordem.cotacao            COLUMN-LABEL "Cotaá∆o"      WIDTH 9.5
    tt-ordem.preco              COLUMN-LABEL "Preco"        WIDTH 9.5
    tt-ordem.valor-real         COLUMN-LABEL "Valor"        WIDTH 11
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 126.29 BY 13.75
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-vl-tot-fornec AT ROW 19.25 COL 66 COLON-ALIGNED WIDGET-ID 58
     fi-vl-tot-real AT ROW 19.25 COL 109 COLON-ALIGNED WIDGET-ID 60
     fi-num-pedido AT ROW 2.75 COL 38 COLON-ALIGNED HELP
          "N£mero do Pedido de Compra" WIDGET-ID 52
     fi-dt-fatur AT ROW 2.75 COL 70.57 COLON-ALIGNED WIDGET-ID 54
     cb-tipo AT ROW 3.88 COL 38 COLON-ALIGNED WIDGET-ID 56
     bt-atualiza AT ROW 3.75 COL 86.57 WIDGET-ID 50
     br-ordens AT ROW 5.25 COL 2.72 WIDGET-ID 300
     btQueryJoins AT ROW 1.13 COL 112.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 116.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 120.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 124.57 HELP
          "Ajuda"
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 128.57 BY 19.79
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 19.79
         WIDTH              = 128.57
         MAX-HEIGHT         = 23.5
         MAX-WIDTH          = 128.57
         VIRTUAL-HEIGHT     = 23.5
         VIRTUAL-WIDTH      = 128.57
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-ordens bt-atualiza fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-ordens
/* Query rebuild information for BROWSE br-ordens
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-ordens */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-atualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-atualiza wWindow
ON CHOOSE OF bt-atualiza IN FRAME fpage0 /* bt atualiza 2 */
DO:
    ASSIGN INPUT FRAME fPage0 fi-num-pedido fi-dt-fatur cb-tipo.
    
    FIND FIRST pedido-compr NO-LOCK
         WHERE pedido-compr.num-pedido = fi-num-pedido NO-ERROR.
    IF NOT AVAIL pedido-compr THEN DO:
        MESSAGE "Pedido de Compra n∆o encontrado!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE IF NOT CAN-FIND(FIRST ordem-compra NO-LOCK
                         WHERE ordem-compra.num-pedido = pedido-compr.num-pedido
                           AND ordem-compra.mo-codigo = 1) THEN DO:
        MESSAGE "Somente pedidos de compra de ordens em dolar ser∆o verificados! Favor informe um pedido em dolar."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE IF fi-dt-fatur = ? THEN DO:
        MESSAGE "Informe a data de faturamento da nota!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE IF cb-tipo = 0 OR cb-tipo = ? THEN DO:
        MESSAGE "Selecione o tipo de c†lculo!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE DO:
        ASSIGN fi-vl-tot-fornec = 0
               fi-vl-tot-real   = 0.

        DISP fi-vl-tot-fornec
             fi-vl-tot-real  WITH FRAME fPage0.

        RUN pi-carrega.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo wWindow
ON VALUE-CHANGED OF cb-tipo IN FRAME fpage0 /* Cotaá∆o */
DO:
    APPLY "choose" TO bt-atualiza IN FRAME fPage0.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-dt-fatur
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-dt-fatur wWindow
ON RETURN OF fi-dt-fatur IN FRAME fpage0 /* Dt. Faturamento */
DO:
    APPLY "choose" TO bt-atualiza IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-num-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-pedido wWindow
ON RETURN OF fi-num-pedido IN FRAME fpage0 /* Pedido */
DO:
    APPLY "choose" TO bt-atualiza IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-ordens
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    APPLY "entry" TO fi-num-pedido IN FRAME fPage0.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega wWindow 
PROCEDURE pi-carrega :
DEFINE VARIABLE dt-data   AS DATE     NO-UNDO.
    DEFINE VARIABLE data-ini  AS DATE     NO-UNDO.
    DEFINE VARIABLE data-fim  AS DATE     NO-UNDO.
    DEFINE VARIABLE i-dia-ini AS INTEGER  NO-UNDO.
    DEFINE VARIABLE data-fat  AS DATE     NO-UNDO.
    DEFINE VARIABLE dt-aux    AS DATE        NO-UNDO.
    
    DEFINE VARIABLE de-cota-data-pedido      AS DECIMAL  format ">>9.99999999"   NO-UNDO.
    DEFINE VARIABLE de-cota-data-ant         AS DECIMAL  format ">>9.99999999"   NO-UNDO.
    DEFINE VARIABLE de-cota-ultdia-ant       AS DECIMAL  format ">>9.99999999"   NO-UNDO.
    DEFINE VARIABLE de-cota-media-semana-ant AS DECIMAL  format ">>9.99999999"   NO-UNDO.
    DEFINE VARIABLE de-cota-media-mes-ant    AS DECIMAL  format ">>9.99999999"   NO-UNDO.
    
    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

    DEFINE VARIABLE de-vl-tot-fornec AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-vl-tot-real   AS DECIMAL     NO-UNDO.

    RUN utp/ut-acomp.p persistent set h-acomp.  
    RUN pi-inicializar in h-acomp (input "Consultando Ordens...").

    for each tt-ordem:
        delete tt-ordem.
    end.
    
    ASSIGN de-vl-tot-fornec = 0
           de-vl-tot-real   = 0.

    FOR EACH pedido-compr NO-LOCK
       WHERE pedido-compr.num-pedido = fi-num-pedido:

        ASSIGN data-fat = fi-dt-fatur
               dt-data  = pedido-compr.data-pedido
               data-ini = data-fat - (5 + WEEKDAY(data-fat))
               data-fim = data-ini + 4
               i-dia-ini = DAY(data-fat).

        /*mes faturamento*/
        FOR EACH cotacao NO-LOCK
           WHERE cotacao.ano-periodo = STRING(YEAR(data-fat),"9999") + STRING(MONTH(data-fat),"99")
             AND cotacao.mo-codigo = 1:

            IF DAY(data-fat) <> 01  THEN
                ASSIGN de-cota-data-ant         = cotacao.cotacao[DAY(data-fat) - 1].

            IF MONTH(data-fat) = MONTH(data-ini) THEN DO:
                IF MONTH(data-ini) = MONTH(data-fim) THEN DO:
                    DO i-cont = DAY(data-ini) TO DAY(data-fim):
                        ASSIGN de-cota-media-semana-ant = de-cota-media-semana-ant + cotacao.cotacao[i-cont].
                    END.
                    ASSIGN de-cota-media-semana-ant = de-cota-media-semana-ant / 5.
                END.
                ELSE DO:
                    ASSIGN i-cont = DAY(data-fim).
                    DO i-cont = 1 TO i-cont:
                        ASSIGN de-cota-media-semana-ant = de-cota-media-semana-ant + cotacao.cotacao[i-cont].
                    END.
                END.
            END.
        END.

        /*mes anterior faturamento*/
        ASSIGN dt-aux = data-fat - day(data-fat). /*ultimo dia mes anterior faturamento*/
        FOR EACH cotacao NO-LOCK
           WHERE cotacao.ano-periodo = STRING(YEAR(dt-aux),"9999") + STRING(MONTH(dt-aux),"99")
             AND cotacao.mo-codigo = 1:

            IF DAY(data-fat) = 01  THEN
                ASSIGN de-cota-data-ant         = cotacao.cotacao[DAY(dt-aux)].

            ASSIGN de-cota-ultdia-ant       = cotacao.cotacao[day(dt-aux)]
                   de-cota-media-mes-ant    = cotacao.cota-mensal.


            IF MONTH(data-fat) <> MONTH(data-ini) THEN DO:
                IF MONTH(data-ini) = MONTH(data-fim) THEN DO:
                    DO i-cont = DAY(data-ini) TO DAY(data-fim):
                        ASSIGN de-cota-media-semana-ant = de-cota-media-semana-ant + cotacao.cotacao[i-cont].
                    END.
                    ASSIGN de-cota-media-semana-ant = de-cota-media-semana-ant / 5.
                END.
                ELSE DO:
                    DO i-cont = DAY(data-ini) TO DAY(dt-aux):
                        ASSIGN de-cota-media-semana-ant = de-cota-media-semana-ant + cotacao.cotacao[i-cont].
                    END.
                    ASSIGN de-cota-media-semana-ant = de-cota-media-semana-ant / 5.
                END.
            END.
        END.

        /*mes pedido*/
        FOR EACH cotacao NO-LOCK
           WHERE cotacao.ano-periodo = STRING(YEAR(dt-data),"9999") + STRING(MONTH(dt-data),"99")
             AND cotacao.mo-codigo = 1:

            ASSIGN de-cota-data-pedido = cotacao.cotacao[DAY(dt-data)].
        END.

        FOR EACH ordem-compra NO-LOCK
           WHERE ordem-compra.num-pedido = pedido-compr.num-pedido
             AND ordem-compra.mo-codigo = 1,
            FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = ordem-compra.it-codigo:

            RUN pi-acompanhar IN h-acomp (INPUT "Ordem: " + string(ordem-compra.numero-ordem)).          

            create tt-ordem.
            assign tt-ordem.numero-ordem = ordem-compra.numero-ordem
                   tt-ordem.data-emissao = ordem-compra.data-emissao
                   tt-ordem.it-codigo    = ordem-compra.it-codigo
                   tt-ordem.desc-item    = item.desc-item
                   tt-ordem.quantidade   = ordem-compra.qt-solic
                   tt-ordem.preco-fornec = ordem-compra.preco-fornec
                   tt-ordem.valor-fornec = ordem-compra.preco-fornec * ordem-compra.qt-solic.

            CASE cb-tipo:
                WHEN 1 THEN DO: /*data pedido*/
                    ASSIGN tt-ordem.cotacao  = de-cota-data-pedido
                           tt-ordem.preco    = ordem-compra.preco-fornec * de-cota-data-pedido.
                END.
                WHEN 2 THEN DO: /*data anterior ao faturamento*/
                    ASSIGN tt-ordem.cotacao  = de-cota-data-ant
                           tt-ordem.preco    = ordem-compra.preco-fornec * de-cota-data-ant.
                END.
                WHEN 3 THEN DO: /*media semana anterior faturamento*/
                    ASSIGN tt-ordem.cotacao  = de-cota-media-semana-ant
                           tt-ordem.preco    = ordem-compra.preco-fornec * de-cota-media-semana-ant.
                END.
                WHEN 4 THEN DO: /*media mes anterior faturamento*/
                    ASSIGN tt-ordem.cotacao  = de-cota-media-mes-ant
                           tt-ordem.preco    = ordem-compra.preco-fornec * de-cota-media-mes-ant.
                END.
                WHEN 5 THEN DO: /*ultimo dia do mes anterior ao faturamento*/
                    ASSIGN tt-ordem.cotacao  = de-cota-ultdia-ant
                           tt-ordem.preco    = ordem-compra.preco-fornec * de-cota-ultdia-ant.
                END.
            END CASE.

            ASSIGN tt-ordem.valor-real = tt-ordem.preco * tt-ordem.quantidade
                   de-vl-tot-fornec    = de-vl-tot-fornec + tt-ordem.valor-fornec
                   de-vl-tot-real      = de-vl-tot-real   + tt-ordem.valor-real.
        END.
    END.
                  
    
    RUN pi-finalizar in h-acomp.
    
    {&OPEN-QUERY-br-ordens}               

    ASSIGN fi-vl-tot-fornec = de-vl-tot-fornec
           fi-vl-tot-real   = de-vl-tot-real.

    DISP fi-vl-tot-fornec
         fi-vl-tot-real  WITH FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

