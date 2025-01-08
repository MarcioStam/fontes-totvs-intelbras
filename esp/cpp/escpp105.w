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
{include/i-prgvrs.i ESCPP105 2.00.00.000}
{include/i-license-manager.i ESCPP105 FGL}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP105
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btCancel btHelp2 fi-num-pedido br1 BtGerar ~
                              btImpQrCode btImpEtq btImpMod btImpDuo btExcel ~
                              btImpCodBarra btReimp
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE cPrinter    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAuxFile    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-carregou  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-esapi016  AS HANDLE      NO-UNDO.
 
DEF VAR c-msg-erro AS CHAR NO-UNDO.
DEF VAR i-cont     AS INTE NO-UNDO.

{esp/es0018.i}
{upc/btb910za-upc.i}
{esapi/esapi023.i}      /* ttitem / ttarq / tt-mac-address */
{esapi/esapi016.i}
{cdp/cd0666.i}

{esp/showmsg.i}

DEFINE TEMP-TABLE ttitem2 NO-UNDO
    FIELD it-codigo  LIKE ordem-compra.it-codigo
    FIELD qt-imp-prod  AS INTEGER
    INDEX item1 it-codigo.

/* Parameters Definitions ---                                           */
DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE NEW SHARED VARIABLE h-acomp AS HANDLE NO-UNDO.
DEF VAR wh-pesquisa AS HANDLE NO-UNDO.

DEFINE VARIABLE h-api023   AS HANDLE    NO-UNDO.

DEFINE TEMP-TABLE tt-erro-geral NO-UNDO LIKE tt-erro.

DEFINE BUFFER b-ttitem FOR ttitem.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttitem ttitem2

/* Definitions for BROWSE br1                                           */
&Scoped-define FIELDS-IN-QUERY-br1 marcado ttitem.it-codigo desc-item qt-pedido gerado-ns gerado-mac ttitem2.qt-imp-prod   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br1   
&Scoped-define SELF-NAME br1
&Scoped-define QUERY-STRING-br1 FOR EACH ttitem NO-LOCK, ~
               EACH ttitem2 WHERE              ttitem2.it-codigo = ttitem.it-codigo              NO-LOCK
&Scoped-define OPEN-QUERY-br1 OPEN QUERY {&SELF-NAME}     FOR EACH ttitem NO-LOCK, ~
               EACH ttitem2 WHERE              ttitem2.it-codigo = ttitem.it-codigo              NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br1 ttitem ttitem2
&Scoped-define FIRST-TABLE-IN-QUERY-br1 ttitem
&Scoped-define SECOND-TABLE-IN-QUERY-br1 ttitem2


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br1 btExcel btQueryJoins btReportsJoins ~
btExit btHelp btCancel btHelp2 fi-num-pedido fi-email btGerar btImpQrCode ~
btImpEtq btImpMod btImpDuo btImpCodBarra btReimp rtToolBar-2 rtToolBar ~
RECT-1 RECT-3 RECT-4 
&Scoped-Define DISPLAYED-OBJECTS fi-num-pedido femitente fnome fi-email 

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
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExcel 
     IMAGE-UP FILE "image/excel.bmp":U
     LABEL "Excel" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btGerar 
     LABEL "Gerar NS" 
     SIZE 10 BY 1 TOOLTIP "Gerar numero de serie e MAC".

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btImpCodBarra 
     LABEL "Cod.Barra" 
     SIZE 10 BY 1 TOOLTIP "Imprime Codigo de Barra".

DEFINE BUTTON btImpDuo 
     LABEL "Imp. Etq Duo" 
     SIZE 10 BY 1 TOOLTIP "Imprime Etiquetas do Produto DUO".

DEFINE BUTTON btImpEtq 
     LABEL "Imp. Etq Prod" 
     SIZE 10 BY 1 TOOLTIP "Imprime Etiquetas do Produto".

DEFINE BUTTON btImpMod 
     LABEL "Imp. Etq Mod" 
     SIZE 10 BY 1 TOOLTIP "Imprime Etiquetas do m¢dulo".

DEFINE BUTTON btImpQrCode 
     LABEL "Imp. QrCode" 
     SIZE 10 BY 1 TOOLTIP "Imprime Etiquetas de Qr Code".

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReimp 
     LABEL "Reimp" 
     SIZE 5 BY 1 TOOLTIP "Imprime Codigo de Barra".

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE femitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornecedor":R15 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-email AS CHARACTER FORMAT "X(256)":U 
     LABEL "email" 
     VIEW-AS FILL-IN 
     SIZE 74 BY .88 NO-UNDO.

DEFINE VARIABLE fi-num-pedido AS INTEGER FORMAT ">>>>>,>>9" INITIAL 0 
     LABEL "Pedido":R8 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fnome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 101.57 BY 3.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 55.57 BY 2.25.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 17.86 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 28 BY 2.25
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 101.72 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br1 FOR 
      ttitem, 
      ttitem2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br1 wWindow _FREEFORM
  QUERY br1 DISPLAY
      marcado     COLUMN-LABEL "*"         
 ttitem.it-codigo   COLUMN-LABEL "Item"       FORMAT "x(7)"  WIDTH 9
 desc-item   COLUMN-LABEL "Descricao"  FORMAT "x(50)"
 qt-pedido   COLUMN-LABEL "Qt.Pedido"                    WIDTH 10   
 gerado-ns   COLUMN-LABEL "NS Gerados"  FORMAT ">,>>>,>>9"  WIDTH 10
 gerado-mac  COLUMN-LABEL "Mac Gerados" FORMAT ">,>>>,>>9"  WIDTH 10
 ttitem2.qt-imp-prod COLUMN-LABEL "Qtd Etq Prod Imp" FORMAT ">>>,>>>,>>9"  WIDTH 10
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 101.72 BY 7.92
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     br1 AT ROW 6.38 COL 1.29 WIDGET-ID 200
     btExcel AT ROW 1.13 COL 45.29 WIDGET-ID 132
     btQueryJoins AT ROW 1.13 COL 82.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 86.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 90.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 94.57 HELP
          "Ajuda"
     btCancel AT ROW 16.04 COL 3
     btHelp2 AT ROW 16.04 COL 14.14
     fi-num-pedido AT ROW 3 COL 14.43 COLON-ALIGNED HELP
          "N£mero do Pedido de Compra" WIDGET-ID 110
     femitente AT ROW 4 COL 14.43 COLON-ALIGNED HELP
          "Fornecedor Inicial" WIDGET-ID 102
     fnome AT ROW 4 COL 27.43 COLON-ALIGNED NO-LABEL WIDGET-ID 108
     fi-email AT ROW 5 COL 14.43 COLON-ALIGNED WIDGET-ID 118
     btGerar AT ROW 16.08 COL 29.72 WIDGET-ID 120
     btImpQrCode AT ROW 16.08 COL 40.86 WIDGET-ID 122
     btImpEtq AT ROW 16.08 COL 52 WIDGET-ID 124
     btImpMod AT ROW 16.08 COL 63.14 WIDGET-ID 128
     btImpDuo AT ROW 16.08 COL 74.29 WIDGET-ID 130
     btImpCodBarra AT ROW 16 COL 86 WIDGET-ID 134
     btReimp AT ROW 16 COL 96 WIDGET-ID 144
     "* Itens selecionados" VIEW-AS TEXT
          SIZE 13.86 BY .54 AT ROW 14.33 COL 2 WIDGET-ID 126
     "Utilizado por Manaus" VIEW-AS TEXT
          SIZE 15.86 BY .54 AT ROW 15.21 COL 50.57 WIDGET-ID 138
     "Utilizado SC" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 15.25 COL 87.72 WIDGET-ID 142
     rtToolBar-2 AT ROW 1 COL 1.29
     rtToolBar AT ROW 15 COL 1
     RECT-1 AT ROW 2.75 COL 1.43 WIDGET-ID 2
     RECT-3 AT ROW 15 COL 29.29 WIDGET-ID 136
     RECT-4 AT ROW 15 COL 85.14 WIDGET-ID 140
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 102 BY 16.42
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Gera Num.Serie com Mac por PO"
         HEIGHT             = 16.33
         WIDTH              = 102
         MAX-HEIGHT         = 28
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28
         VIRTUAL-WIDTH      = 195.14
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
/* BROWSE-TAB br1 1 fpage0 */
/* SETTINGS FOR FILL-IN femitente IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fnome IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       fnome:READ-ONLY IN FRAME fpage0        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br1
/* Query rebuild information for BROWSE br1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME}
    FOR EACH ttitem NO-LOCK,
        EACH ttitem2 WHERE
             ttitem2.it-codigo = ttitem.it-codigo
             NO-LOCK.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br1 */
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
ON END-ERROR OF wWindow /* Gera Num.Serie com Mac por PO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Gera Num.Serie com Mac por PO */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br1
&Scoped-define SELF-NAME br1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br1 wWindow
ON MOUSE-SELECT-DBLCLICK OF br1 IN FRAME fpage0
DO:
    if ttitem.marcado = yes then
        ASSIGN ttitem.marcado = NO.    
    ELSE DO:
       /*
        FOR FIRST item-ean NO-LOCK
            WHERE ITEM-ean.it-codigo = ttitem.it-codigo:
        END.

        IF ttitem.qt-pedido - ttitem.gerado-ns  <= 0 AND
           ttitem.qt-pedido  + (ttitem.qt-pedido  * ttItem.buffer-mac / 100) - ttitem.gerado-mac <= 0 THEN DO:

            ASSIGN c-msg-erro = "Item nÆo pode ser selecionado|" +
                     SUBSTITUTE("Todos os Num.S‚rie e MACs para o Item &1 j  foram gerados",
                                TRIM(ttitem.it-codigo)).
            
            RUN ShowMessage (1, ENTRY(1, c-msg-erro, "|"), 
                                ENTRY(2, c-msg-erro, "|")).

            RETURN NO-APPLY.
        END. */
        ASSIGN ttitem.marcado = yes.
    END.
    {&open-query-br1}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcel wWindow
ON CHOOSE OF btExcel IN FRAME fpage0 /* Excel */
DO: 
    DEFINE VARIABLE l-pid AS LOGICAL NO-UNDO.

    EMPTY TEMP-TABLE tt-erro.

    ASSIGN i-cont = 0.

    FOR EACH ttitem NO-LOCK.
        IF ttitem.marcado = YES
        THEN ASSIGN i-cont = i-cont + 1.
    END.
    
    IF i-cont > 1 
    THEN DO:
    
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro   = 17006
               tt-erro.mensagem = "Selecione apenas um item para gerar ou imprimir o QR Code".

        RUN cdp/cd0666.w (INPUT TABLE tt-erro).

        RETURN "NOK".

    END.

    IF i-cont = 0 
    THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro   = 17006
               tt-erro.mensagem = "Selecione um item para gerar ou imprimir o QR Code".

        RUN cdp/cd0666.w (INPUT TABLE tt-erro).

        RETURN "NOK".
    END.

    /* Gera‡Æo Planilha PID */
    FOR EACH ttitem NO-LOCK:
        IF ttitem.marcado = YES THEN DO:
           FIND FIRST item-ean 
                WHERE item-ean.it-codigo = ttitem.it-codigo 
           NO-LOCK NO-ERROR.

           IF AVAIL item-ean THEN DO:
              IF LENGTH(item-ean.nc) > 3 THEN 
                 ASSIGN l-pid = YES.
           END.                                               
        END.
    END.  

    IF NOT l-pid THEN
       RUN piGeraExcel.
    ELSE 
       RUN piImprimeExcelPID.

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


&Scoped-define SELF-NAME btGerar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGerar wWindow
ON CHOOSE OF btGerar IN FRAME fpage0 /* Gerar NS */
DO:
    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Gera‡Æo de Seriais e MAC"). 
    RUN geracaoNS.
    RUN pi-finalizar IN h-acomp.
    ASSIGN h-acomp = ?.
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


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btImpCodBarra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImpCodBarra wWindow
ON CHOOSE OF btImpCodBarra IN FRAME fpage0 /* Cod.Barra */
DO:
    FIND FIRST pedido-compr NO-LOCK 
         WHERE pedido-compr.num-pedido = INPUT FRAME fPage0 fi-num-pedido NO-ERROR.
    IF NOT AVAIL pedido-compr THEN DO:
       RUN utp/ut-msgs.p (INPUT 'show':U,
                          INPUT 17006,
                          INPUT 'PO informado nao localizado').
       RETURN NO-APPLY.
    END.

    ASSIGN i-cont = 0.

    FOR EACH  num-serie  NO-LOCK
        WHERE num-serie.num-pedido = INPUT FRAME fPage0 fi-num-pedido:

        ASSIGN i-cont = i-cont + 1.
    END. 

    IF i-cont = 0 THEN DO:
       RUN utp/ut-msgs.p (INPUT 'show':U,
                          INPUT 17006,
                          INPUT 'Nao localizado NS para PO informado').
       RETURN NO-APPLY.
    END.                                                                  
   
    FOR FIRST num-serie NO-LOCK
        WHERE num-serie.num-pedido = INPUT FRAME fPage0 fi-num-pedido:
        FIND FIRST item-ean NO-LOCK
             WHERE item-ean.it-codigo = num-serie.it-codigo NO-ERROR.
        IF AVAIL item-ean THEN DO:
            IF NOT item-ean.log-banda-ku THEN DO:
                RUN utp/ut-msgs.p (INPUT 'show':U,
                                   INPUT 17006,
                                    INPUT 'NÆo ‚ poss¡vel imprimir para este item ~~ Apenas Item Banda KU podem ser impresso').
                RETURN NO-APPLY.
            END.
        END.             
    END.
    
    RUN esp/cpp/escpp105f.w(INPUT INPUT FRAME fPage0 fi-num-pedido).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btImpDuo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImpDuo wWindow
ON CHOOSE OF btImpDuo IN FRAME fpage0 /* Imp. Etq Duo */
DO:
    EMPTY TEMP-TABLE tt-erro.

    ASSIGN i-cont = 0.

    FOR EACH ttitem NO-LOCK.
        IF ttitem.marcado = YES
        THEN ASSIGN i-cont = i-cont + 1.
    END.
    
    IF i-cont > 1 
    THEN DO:
    
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro   = 17006
               tt-erro.mensagem  = "Selecione apenas um item para gerar ou imprimir a etiqueta DUO".

        RUN cdp/cd0666.w (INPUT TABLE tt-erro).

        RETURN "NOK".

    END.

    IF i-cont = 0 
    THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro   = 17006
               tt-erro.mensagem  = "Selecione um item para gerar ou imprimir a etiqueta DUO".

        RUN cdp/cd0666.w (INPUT TABLE tt-erro).

        RETURN "NOK".
    END.

    RUN esp/es0018p.r (INPUT "MOD-DUO",
                       INPUT 1,
                       INPUT 0,
                       INPUT "", 
                       OUTPUT TABLE tt-prog-ponto).
    
    FIND FIRST tt-prog-ponto NO-LOCK.

    IF NOT AVAIL tt-prog-ponto 
    THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro   = 17006
               tt-erro.mensagem  = "Modelo DUO nÆo parametrizado".

        RUN cdp/cd0666.w (INPUT TABLE tt-erro).

        RETURN "NOK".
    END.

    FIND FIRST ttitem WHERE
               ttitem.marcado = YES
               NO-ERROR.

    FIND FIRST item-mod-etiq 
         WHERE item-mod-etiq.it-codigo  = ttitem.it-codigo
           AND item-mod-etiq.cod-modelo = INT(tt-prog-ponto.conteudo)
               NO-LOCK NO-ERROR.

    IF NOT AVAIL item-mod-etiq 
    THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro   = 17006
               tt-erro.mensagem  = "Item sem modelo DUO cadastrado".

        RUN cdp/cd0666.w (INPUT TABLE tt-erro).

        RETURN "NOK".
    END.

    RUN esp/cpp/escpp105d.w(INPUT INPUT FRAME fPage0 fi-num-pedido,
                            INPUT ttitem.it-codigo).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btImpEtq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImpEtq wWindow
ON CHOOSE OF btImpEtq IN FRAME fpage0 /* Imp. Etq Prod */
DO:

    EMPTY TEMP-TABLE tt-erro.

    ASSIGN i-cont = 0.

    FOR EACH ttitem NO-LOCK.
        IF ttitem.marcado = YES
        THEN ASSIGN i-cont = i-cont + 1.
    END.
    
    IF i-cont > 1 
    THEN DO:
    
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro   = 17006
               tt-erro.mensagem  = "Selecione apenas um item para gerar ou imprimir o etiqueta do Produto".

        RUN cdp/cd0666.w (INPUT TABLE tt-erro).

        RETURN "NOK".

    END.

    IF i-cont = 0 
    THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro   = 17006
               tt-erro.mensagem  = "Selecione um item para gerar ou imprimir o etiqueta do Produto".

        RUN cdp/cd0666.w (INPUT TABLE tt-erro).

        RETURN "NOK".
    END.

    FIND FIRST ttitem WHERE
               ttitem.marcado = YES
               NO-ERROR.

    RUN esp/cpp/escpp105b.w(INPUT INPUT FRAME fPage0 fi-num-pedido,
                            INPUT ttitem.it-codigo).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btImpMod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImpMod wWindow
ON CHOOSE OF btImpMod IN FRAME fpage0 /* Imp. Etq Mod */
DO:
    /*
    EMPTY TEMP-TABLE tt-erro.

    ASSIGN i-cont = 0.

    FOR EACH ttitem NO-LOCK.
        IF ttitem.marcado = YES
        THEN ASSIGN i-cont = i-cont + 1.
    END.
    
    IF i-cont > 1 
    THEN DO:
    
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro   = 17006
               tt-erro.mensagem = "Selecione apenas um item para gerar ou imprimir a Etiqueta".

        RUN cdp/cd0666.w (INPUT TABLE tt-erro).

        RETURN "NOK".

    END.

    IF i-cont = 0 
    THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro   = 17006
               tt-erro.mensagem = "Selecione um item para gerar ou imprimir a Etiqueta".

        RUN cdp/cd0666.w (INPUT TABLE tt-erro).

        RETURN "NOK".
    END.
    */
    RUN esp/cpp/escpp105c.w(INPUT INPUT FRAME fPage0 fi-num-pedido,
                            INPUT TABLE ttItem).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btImpQrCode
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImpQrCode wWindow
ON CHOOSE OF btImpQrCode IN FRAME fpage0 /* Imp. QrCode */
DO:
    
    EMPTY TEMP-TABLE tt-erro.

    ASSIGN i-cont = 0.

    FOR EACH ttitem NO-LOCK.
        IF ttitem.marcado = YES
        THEN ASSIGN i-cont = i-cont + 1.
    END.
    
    IF i-cont > 1 
    THEN DO:
    
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro   = 17006
               tt-erro.mensagem = "Selecione apenas um item para gerar ou imprimir o QR Code".

        RUN cdp/cd0666.w (INPUT TABLE tt-erro).

        RETURN "NOK".

    END.

    IF i-cont = 0 
    THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro   = 17006
               tt-erro.mensagem = "Selecione um item para gerar ou imprimir o QR Code".

        RUN cdp/cd0666.w (INPUT TABLE tt-erro).

        RETURN "NOK".
    END.

    /* Valida permiss’o para reimprimir */
    FOR EACH tt-prog-ponto: DELETE tt-prog-ponto. END.

    RUN esp\es0018p.p (INPUT "escpp105a",   /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    FIND tt-prog-ponto WHERE 
         tt-prog-ponto.conteudo = c-seg-usuario NO-ERROR.

    IF NOT AVAIL tt-prog-ponto THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Usuario sem permissÆo para imprimir.").
        
        RETURN "NOK":U.
    END.
      
    FOR EACH ttitem NO-LOCK
        WHERE ttitem.marcado = YES,
        FIRST item-ean WHERE item-ean.it-codigo = ttitem.it-codigo:

        IF LENGTH(item-ean.nc) > 3 THEN DO:
           FOR EACH num-serie NO-LOCK 
               WHERE num-serie.num-pedido = INPUT FRAME fPage0 fi-num-pedido:

               IF trim(substring(num-serie.char-1,50)) = '' THEN DO:
                   RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                      INPUT 17006,
                                      INPUT "SN ' + num-serie.n-serie ' nao possui DSK informado").
                    
                     RETURN "NOK":U.
               END.
           END.       
        END.          
    END.

    RUN esp/cpp/escpp105a.w(INPUT INPUT FRAME fPage0 fi-num-pedido,
                            INPUT TABLE ttItem).
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


&Scoped-define SELF-NAME btReimp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReimp wWindow
ON CHOOSE OF btReimp IN FRAME fpage0 /* Reimp */
DO:
    FIND FIRST pedido-compr NO-LOCK
         WHERE pedido-compr.num-pedido = INPUT FRAME fPage0 fi-num-pedido NO-ERROR.
    IF NOT AVAIL pedido-compr THEN DO:
       RUN utp/ut-msgs.p (INPUT 'show':U,
                          INPUT 17006,
                          INPUT 'PO informado nao localizado').
       RETURN NO-APPLY.
    END.

    ASSIGN i-cont = 0.

    FOR EACH num-serie NO-LOCK
        WHERE num-serie.num-pedido = INPUT FRAME fPage0 fi-num-pedido:
        ASSIGN i-cont = i-cont + 1.
    END. 

    IF i-cont = 0 THEN DO:
       RUN utp/ut-msgs.p (INPUT 'show':U,
                          INPUT 17006,
                          INPUT 'Nao localizado NS para PO informado').
       RETURN NO-APPLY.
    END.           

    FOR FIRST num-serie NO-LOCK
        WHERE num-serie.num-pedido = INPUT FRAME fPage0 fi-num-pedido:
        FIND FIRST item-ean NO-LOCK
             WHERE item-ean.it-codigo = num-serie.it-codigo NO-ERROR.
        IF AVAIL item-ean THEN DO:
            IF NOT item-ean.log-banda-ku THEN DO:
                RUN utp/ut-msgs.p (INPUT 'show':U,
                                   INPUT 17006,
                                    INPUT 'NÆo ‚ poss¡vel imprimir para este item ~~ Apenas Item Banda KU podem ser impresso').
                RETURN NO-APPLY.
            END.
        END.             
    END.

    /* Banda KU escpp105 - NÆo imprimir a data */
    RUN esp/cpp/escpp066A.w (INPUT YES).
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


&Scoped-define SELF-NAME femitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL femitente wWindow
ON MOUSE-SELECT-DBLCLICK OF femitente IN FRAME fpage0 /* Fornecedor */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad098.w"
                       &campo="femitente"    
                       &campo2="fnome"
                       &campozoom="cod-emitente"
                       &campozoom2="nome-emit"
                       &frame="fpage0"
                       &frame2="fpage0"}
                       
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-num-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-pedido wWindow
ON RETURN OF fi-num-pedido IN FRAME fpage0 /* Pedido */
DO:
    IF  INPUT FRAME {&FRAME-NAME} fi-num-pedido <> "0" THEN DO:
        ASSIGN fi-email:SCREEN-VALUE = "".

        IF NOT VALID-HANDLE(h-acomp) THEN
            RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
        RUN pi-inicializar in h-acomp (input "Carregando..."). 

        RUN pi-acompanhar IN h-acomp (INPUT "Carregando...").

        RUN pi-carrega-ttitem.

        RUN pi-finalizar IN h-acomp.
        ASSIGN h-acomp = ?.

    END.
  //APPLY "LEAVE":U  TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-pedido wWindow
ON TAB OF fi-num-pedido IN FRAME fpage0 /* Pedido */
DO:
  APPLY "RETURN":U  TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/*
IF c-it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.
IF c-sigla:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.

  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
FOR FIRST imprsor_usuar NO-LOCK
    WHERE imprsor_usuar.cod_usuario = c-seg-usuario
    AND   imprsor_usuar.log_imprsor_princ:

    FOR FIRST layout_impres NO-LOCK
        WHERE layout_impres.nom_impressora = imprsor_usuar.nom_impressora
        AND   layout_impres.log_layout_impres_princ:

        ASSIGN fiPrinter:SCREEN-VALUE IN FRAME fPage0 = layout_impres.nom_impressora + ":" +
                                                        layout_impres.cod_layout_impres.
    END.
END.

ASSIGN cb-modelo:SENSITIVE IN FRAME fPage0 = NO.

APPLY "ENTRY" TO c-it-codigo IN FRAME fPage0.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geracaoNS wWindow 
PROCEDURE geracaoNS :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE h-esapi016 AS HANDLE NO-UNDO.

RUN esapi/esapi016.p PERSISTENT SET h-esapi016.

EMPTY TEMP-TABLE tt-erro-geral NO-ERROR.

RUN pi-seta-titulo IN h-acomp (INPUT "Efetivando cria‡Æo dos Seriais":U).

FOR EACH ttItem 
    WHERE ttitem.marcado = YES
    AND   ttitem.qt-pedido - ttitem.gerado-ns > 0:

    RUN pi-acompanhar IN h-acomp (INPUT "Item: " + ttItem.it-codigo).

    EMPTY TEMP-TABLE tt-lista-ns NO-ERROR.

    RUN piGeraNSeMAC IN h-esapi016 (INPUT ttItem.it-codigo,
                                INPUT 1,  /* Colocado um modelo com tipo 1 - N£mero de S‚rie para gerar os N£meros de S‚rie */
                                INPUT "",
                                INPUT (ttitem.qt-pedido - ttitem.gerado-ns),
                                INPUT 0,
                                INPUT INPUT FRAME fPage0 fi-num-pedido,
                                INPUT "",
                                INPUT 3,
                                INPUT NO,  /* Tratamento ASTEC */
                                INPUT "",
                                INPUT "",
                                OUTPUT TABLE tt-lista-ns).

    IF  RETURN-VALUE <> "OK":U THEN DO:
        EMPTY TEMP-TABLE tt-erro NO-ERROR.
        RUN piRetornaErros IN h-esapi016 (OUTPUT TABLE tt-erro).
        
        FOR EACH tt-erro:
            CREATE tt-erro-geral.
            BUFFER-COPY tt-erro TO tt-erro-geral.
        END. /* FOR EACH tt-erro: */
    END. /* IF  RETURN-VALUE <> "OK":U THEN DO: */
    
END. /* FOR EACH ttItem WHERE ttitem.marcado */

IF  CAN-FIND(FIRST tt-erro-geral) THEN DO:
    RUN cdp/cd0666.w (INPUT TABLE tt-erro-geral).
    DELETE PROCEDURE h-esapi016.
    RETURN "NOK":U.
END. /* IF  CAN-FIND(FIRST tt-erro-geral) */

DELETE PROCEDURE h-esapi016.

/* atualiza browse */
RUN pi-carrega-ttitem.

RETURN "OK".

END PROCEDURE.


.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-ttitem wWindow 
PROCEDURE pi-carrega-ttitem :
/*------------------------------------------------------------------------------
  Purpose: Chama de forma persistent a proc para criar a ttItem e demais TTs
    Notes: Carlos Daniel - 21/09/2015
------------------------------------------------------------------------------*/
DEFINE VARIABLE i-emitente AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-nome     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-email    AS CHARACTER NO-UNDO.

DEFINE VARIABLE i-cont         AS INTEGER NO-UNDO.
DEFINE VARIABLE i-cont-imp     AS INTEGER NO-UNDO.
DEFINE VARIABLE vqtd-it-pedido AS INTEGER NO-UNDO.

RUN esapi/esapi023.p PERSISTENT SET h-api023.

RUN piValidaPedidoComp IN h-api023(INPUT INTEGER(fi-num-pedido:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                   OUTPUT i-emitente,
                                   OUTPUT c-nome,
                                   OUTPUT c-email,
                                   OUTPUT TABLE tt-erro).

IF RETURN-VALUE NE 'OK' THEN DO:
    RUN cdp/cd0666.w( INPUT TABLE tt-erro).

    ASSIGN femitente:SCREEN-VALUE = "0"
           fnome    :SCREEN-VALUE = ""
           fi-email :SCREEN-VALUE = "".

    RETURN 'NOK'.
END.

ASSIGN femitente:SCREEN-VALUE = STRING(i-emitente)
       fnome    :SCREEN-VALUE = c-nome
       fi-email :SCREEN-VALUE = c-email WHEN fi-email :SCREEN-VALUE = "".

/*
RUN piCarrega_ttItem IN h-api023 (INPUT INTEGER(fi-num-pedido:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                  OUTPUT TABLE ttItem,
                                  OUTPUT TABLE tt-mac-address,
                                  OUTPUT TABLE ttArq).
*/

EMPTY TEMP-TABLE ttitem. 
EMPTY TEMP-TABLE ttitem2.
EMPTY TEMP-TABLE tt-mac-address.
EMPTY TEMP-TABLE ttArq.

FOR FIRST pedido-comp
    WHERE pedido-comp.num-pedido = INTEGER(fi-num-pedido:SCREEN-VALUE IN FRAME {&FRAME-NAME}) 
          NO-LOCK:

    FOR EACH  ordem-compra
        WHERE ordem-compra.num-pedido = pedido-compr.num-pedido
              NO-LOCK,
         EACH item-ean WHERE
              item-ean.it-codigo = ordem-compra.it-codigo AND
              item-ean.qtd-mac  <> 0
              NO-LOCK
        BREAK BY ordem-compra.num-pedido
              BY ordem-compra.it-codigo:

        IF ordem-compra.it-codigo <> "" THEN DO:

            FIND FIRST item WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

            IF  FIRST-OF(ordem-compra.it-codigo) THEN DO:

                ASSIGN vqtd-it-pedido = 0.

                CREATE ttitem.
                ASSIGN ttitem.it-codigo = ordem-compra.it-codigo
                       ttitem.desc-item = item.desc-item.

                CREATE ttitem2.
                ASSIGN ttitem2.it-codigo = ordem-compra.it-codigo.

                FOR FIRST int-item-fornec FIELDS(buffer-mac)
                    WHERE int-item-fornec.it-codigo    = ordem-compra.it-codigo
                    AND   int-item-fornec.cod-emitente = ordem-compra.cod-emitente NO-LOCK:

                    ASSIGN ttItem.buffer-mac = int-item-fornec.buffer-mac.
                END.

            END. /* IF  FIRST-OF(ordem-compra.it-codigo) */

            ASSIGN vqtd-it-pedido = vqtd-it-pedido + INTEGER(ordem-compra.qt-solic).

            IF  LAST-OF(ordem-compra.it-codigo) THEN DO:

                ASSIGN ttitem.qt-pedido = vqtd-it-pedido
                       i-cont     = 0
                       i-cont-imp = 0.

                FOR EACH num-serie NO-LOCK
                    WHERE num-serie.num-pedido = pedido-compr.num-pedido
                    AND   num-serie.it-codigo  = ordem-compra.it-codigo:

                    ASSIGN i-cont = i-cont + 1.

                    IF num-serie.log-2 = YES 
                    THEN ASSIGN i-cont-imp = i-cont-imp + 1.

                    CREATE ttarq.
                    ASSIGN ttarq.it-codigo  = ttitem.it-codigo
                           ttarq.num-serie  = num-serie.n-serie.
                END.

                ASSIGN ttitem.gerado-ns = i-cont
                       i-cont           = 0.

                FOR EACH mac-address NO-LOCK
                    WHERE mac-address.num-pedido = pedido-compr.num-pedido
                    AND   mac-address.it-codigo  = ordem-compra.it-codigo:
                    //AND   mac-address.impresso   = TRUE:

                    ASSIGN i-cont = i-cont + 1.

                    CREATE tt-mac-address.
                    ASSIGN tt-mac-address.it-codigo = ttitem.it-codigo
                           tt-mac-address.mac       = mac-address.mac
                           tt-mac-address.impresso  = mac-address.impresso.
                END.

                ASSIGN ttitem.gerado-mac   = i-cont
                       ttitem2.qt-imp-prod = i-cont-imp.

            END. /* IF  LAST-OF(ordem-compra.it-codigo) */
        END. /* IF c-it-codigo <> "" THEN DO: */
    END. /* FOR EACH  ordem-compra NO-LOCK */
END. /* FOR FIRST pedido-comp NO-LOCK */

IF VALID-HANDLE(h-api023) THEN
    DELETE PROCEDURE h-api023.

{&OPEN-QUERY-BR1}

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraExcel wWindow 
PROCEDURE piGeraExcel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cArqConv AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-ok     AS LOGICAL     NO-UNDO.

    DEFINE VARIABLE l-pid    AS LOGICAL     NO-UNDO.

    DEFINE BUTTON btFile
        IMAGE-UP FILE "image/im-sea.bmp":U
        IMAGE-INSENSITIVE FILE "image/ii-sea":U
        SIZE 4 BY 1.
        
    DEFINE VARIABLE cFile AS CHARACTER
        VIEW-AS EDITOR MAX-CHARS 256
        SIZE 40 BY 0.88
        BGCOLOR 15 NO-UNDO.

    DEFINE RECTANGLE rtFile
        EDGE-PIXELS 2 GRAPHIC-EDGE NO-FILL
        SIZE 49 BY 2.33.

    DEFINE BUTTON btExecutar AUTO-GO
         LABEL "&Executar":U
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE BUTTON btCancel AUTO-END-KEY
         LABEL "&Cancelar":U
         SIZE 10 BY 1
         BGCOLOR 8.

    /*DEFINE VARIABLE tgAbrir AS LOGICAL INITIAL NO
        LABEL "Abrir arquivo ao finalizar":U
        VIEW-AS TOGGLE-BOX
        SIZE 20 BY 0.83
        BGCOLOR 7 NO-UNDO.*/

    DEFINE RECTANGLE rtButton
        EDGE-PIXELS 2 GRAPHIC-EDGE
        SIZE 49 BY 1.42
        BGCOLOR 7.
    
    DEFINE FRAME fExportExcel
        " Arquivo":U VIEW-AS TEXT
            SIZE 7 BY .54 AT ROW 1.04 COL 3.43
        cFile             AT ROW 2.13 COL 3.86  NO-LABEL
        btFile            AT ROW 2.04 COL 44.14
        rtFile            AT ROW 1.29 COL 1.43
        btExecutar        AT ROW 4    COL 2.43
        btCancel          AT ROW 4    COL 12.93
        /*tgAbrir           AT ROW 4.20 COL 26.93*/
        rtButton          AT ROW 3.79 COL 1.43
        /*SPACE(0.24)*/
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Exportar para Excel" FONT 1
             DEFAULT-BUTTON btExecutar CANCEL-BUTTON btCancel.
    
    ON "CHOOSE":U OF btExecutar IN FRAME fExportExcel DO:
       
       RUN piImprimeExcel (INPUT REPLACE(INPUT FRAME fExportExcel cFile, "\":U, "/":U),
                           INPUT NO /*(INPUT FRAME fExportExcel tgAbrir)*/ ).

    END.

    ON "CHOOSE":U OF btFile IN FRAME fExportExcel DO:
        ASSIGN cArqConv = REPLACE(INPUT FRAME fExportExcel cFile, "/":U, "\":U).

        SYSTEM-DIALOG GET-FILE cArqConv
            FILTERS "Arquivos .CSV":U  "*.csv":U,
                    "Todos Arquivos":U "*.*":U
        ASK-OVERWRITE
        DEFAULT-EXTENSION "csv":U
        INITIAL-DIR SESSION:TEMP-DIRECTORY
        SAVE-AS
        USE-FILENAME
        UPDATE l-ok.

        IF l-ok THEN DO:
            ASSIGN cFile = CAPS(REPLACE(cArqConv, "\":U, "/":U)).

            DISPLAY cFile
                WITH FRAME fExportExcel.
        END.
    END.

    ENABLE cFile btFile btExecutar btCancel /*tgAbrir*/
        WITH FRAME fExportExcel.

    FIND FIRST usuar_mestre
        WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.

    IF AVAILABLE usuar_mestre THEN DO:
        ASSIGN cFile = IF LENGTH(usuar_mestre.nom_subdir_spool) <> 0
                            THEN CAPS(REPLACE(usuar_mestre.nom_dir_spool, "\":U, "/":U) + "/":U + REPLACE(usuar_mestre.nom_subdir_spool, "\":U, "/":U) + "/":U + c-programa-mg97 + "-":U + STRING(INPUT FRAME fPage0 fi-num-pedido) + ".csv":U)
                            ELSE CAPS(REPLACE(usuar_mestre.nom_dir_spool, "\":U, "/":U) + "/":U + c-programa-mg97 + "-":U + "-":U + REPLACE(STRING(TODAY, "99/99/99":U), "/":U, "":U) + "-":U + REPLACE(STRING(TIME, "HH:MM:SS":U), ":":U, "":U) + ".csv":U).

        IF LENGTH(usuar_mestre.nom_subdir_spool) <> 0 THEN DO:
            IF SEARCH(CAPS(REPLACE(usuar_mestre.nom_dir_spool, "\":U, "/":U) + "/":U + REPLACE(usuar_mestre.nom_subdir_spool, "\":U, "/":U))) = ? THEN DO:
                OS-CREATE-DIR VALUE(CAPS(REPLACE(usuar_mestre.nom_dir_spool, "\":U, "/":U) + "/":U + REPLACE(usuar_mestre.nom_subdir_spool, "\":U, "/":U))) NO-ERROR.
            END.
        END.
    END.
    ELSE
        ASSIGN cFile = CAPS(REPLACE(SESSION:TEMP-DIRECTORY, "\":U, "/":U) + c-programa-mg97 + "-":U + STRING(INPUT FRAME fPage0 fi-num-pedido) + ".csv":U).


    DISPLAY cFile
        WITH FRAME fExportExcel.
    
    WAIT-FOR "GO":U OF FRAME fExportExcel.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimeExcel wWindow 
PROCEDURE piImprimeExcel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER cArquivo AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER lAbrir   AS LOGICAL     NO-UNDO.

    DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-prog  AS HANDLE      NO-UNDO.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Exportando dados para Excel...":U).

    OUTPUT TO VALUE(cArquivo) CONVERT TARGET SESSION:CHARSET.

    FIND FIRST ttitem WHERE
               ttitem.marcado = YES
               NO-ERROR.

    FIND FIRST item-ean WHERE
               item-ean.it-codigo = ttitem.it-codigo
               NO-LOCK NO-ERROR.

    IF AVAIL item-ean 
    THEN DO:
        FOR EACH num-serie WHERE
                 num-serie.num-pedido = INPUT FRAME fPage0 fi-num-pedido AND
                 num-serie.it-codigo  = ttitem.it-codigo
                 NO-LOCK.
        
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "NS: ":U + num-serie.n-serie).

            PUT UNFORMATTED
                    STRING(num-serie.num-pedido)                             + ";":U
                    STRING(num-serie.n-serie)                                + ";":U
                    STRING(item-ean.nome-abrev)                              + ";":U
                    STRING(num-serie.ch-acesso)                              + ";":U.
                    
            FOR EACH mac-address USE-INDEX num-serie
               WHERE mac-address.n-serie = num-serie.n-serie
                     NO-LOCK.

                PUT UNFORMATTED
                    STRING(mac-address.mac)                             + ";":U.

            END.
        
            PUT UNFORMATTED
                    ""                             + ";":U
                    SKIP.
        END.
    END.

    
    OUTPUT CLOSE.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    IF lAbrir THEN DO:
        IF NOT VALID-HANDLE(h-prog) THEN
            RUN utp/ut-utils.p PERSISTENT SET h-prog.

        IF VALID-HANDLE(h-prog) THEN
            RUN execute IN h-prog(INPUT REPLACE(cArquivo, "/":U, "\":U),
                                  INPUT "":U).

        IF VALID-HANDLE(h-prog) THEN
            DELETE PROCEDURE h-prog.
    END.
    ELSE
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT "Arquivo gerado com sucesso!":U +
                                 "~~":U +
                                 "Arquivo gerado em: ":U + REPLACE(cArquivo, "/":U, "\":U)).

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimeExcelPID wWindow 
PROCEDURE piImprimeExcelPID :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO. 
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO. 
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.

    DEFINE VARIABLE i-cont  AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-col   AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-aux   AS INTEGER NO-UNDO.
    DEFINE VARIABLE h-acomp AS HANDLE  NO-UNDO.
    DEFINE VARIABLE h-prog  AS HANDLE  NO-UNDO.

    DEFINE VARIABLE c-coluna AS CHARACTER EXTENT 26 INITIAL ["A","B","C","D","E","F","G","H","I","J",
                                                             "K","L","M","N","O","P","Q","R","S","T",
                                                             "U","V","W","X","Y","Z"].

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Exportando dados para Excel...":U).

    
    /* Cria a Nova Aplicacao Excel object */ 
    CREATE "Excel.Application" chExcelApplication. 

    /* Cria o arquivo */ 
    chWorkbook = chExcelApplication:Workbooks:ADD().

    chexcelapplication:worksheets:ITEM(1):SELECT.
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    ASSIGN chexcelapplication:Range('A1'):VALUE = 'PO'
           chexcelapplication:Range('B1'):VALUE = 'PID'
           chexcelapplication:Range('C1'):VALUE = 'SN'
           chexcelapplication:Range('D1'):VALUE = 'DSK'
           chexcelapplication:Range('E1'):VALUE = 'SC'
           chexcelapplication:Range('F1'):VALUE = 'MAC1'.

    ASSIGN i-cont = 2.

    FOR EACH ttitem
        WHERE ttitem.marcado = YES,
        FIRST item-ean WHERE
               item-ean.it-codigo = ttitem.it-codigo NO-LOCK:

        IF LENGTH(item-ean.nc) <= 3 THEN NEXT.

        FOR EACH num-serie WHERE
                 num-serie.num-pedido = INPUT FRAME fPage0 fi-num-pedido AND
                 num-serie.it-codigo  = ttitem.it-codigo
                 NO-LOCK.
        
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "NS: ":U + num-serie.n-serie).

            ASSIGN chexcelapplication:Range('A' + string(i-cont)):VALUE = num-serie.num-pedido

                   chexcelapplication:Range('B' + string(i-cont)):NumberFormat = '@'
                   chexcelapplication:Range('B' + string(i-cont)):VALUE = item-ean.nc
                   
                   chexcelapplication:Range('C' + string(i-cont)):NumberFormat = '@'
                   chexcelapplication:Range('C' + string(i-cont)):VALUE = STRING(num-serie.n-serie) 
                   chexcelapplication:Range('D' + string(i-cont)):VALUE = '' /* DSK */
                   
                   chexcelapplication:Range('E' + string(i-cont)):NumberFormat = '@'
                   chexcelapplication:Range('E' + string(i-cont)):VALUE = STRING(num-serie.ch-acesso).

            ASSIGN i-aux = 1
                   i-col = 6.
                    
            FOR EACH mac-address USE-INDEX num-serie
                WHERE mac-address.n-serie = num-serie.n-serie NO-LOCK:

                IF i-col > 6 THEN
                   ASSIGN chexcelapplication:Range(c-coluna[i-col] + '1'):VALUE = 'MAC' + string(i-aux).

                ASSIGN chexcelapplication:Range(c-coluna[i-col] + string(i-cont)):NumberFormat = '@'
                       chexcelapplication:Range(c-coluna[i-col] + string(i-cont)):VALUE = mac-address.mac.

                ASSIGN i-col = i-col + 1
                       i-aux = i-aux + 1.
            END.

            ASSIGN i-cont = i-cont + 1.
            
        END.                          

    END.

    chexcelapplication:Cells:SELECT.
    chexcelapplication:Cells:EntireColumn:AutoFit.
    
    chexcelapplication:VISIBLE = YES.
    
    RELEASE OBJECT chExcelApplication.
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.
    
    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

