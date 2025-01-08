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
{include/i-prgvrs.i ESCPP009 2.06.00.000}

&GLOBAL-DEFINE BrowseName   brMain
&GLOBAL-DEFINE FRAME-NAME   fpage0
&GLOBAL-DEFINE WindowType   Master

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */

&GLOBAL-DEFINE Program        ESCCP009
&GLOBAL-DEFINE Version        2.06.00.000

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Itens

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         NO
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         NO
&GLOBAL-DEFINE Save           NO

&GLOBAL-DEFINE page0Fields    fi-estab-ini fi-estab-fim ~
                              fi-Comprador-ini fi-Comprador-fim ~
                              fi-dt-emissao-ini fi-dt-emissao-fim ~
                              fi-periodo-ini fi-periodo-fim ~
                              fi-pedido-ini fi-pedido-fim ~
                              fi-item-ini fi-item-fim ~
                              fi-fornecedor-ini fi-fornecedor-fim
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields
    
&GLOBAL-DEFINE page0widgets   fi-estab-ini fi-estab-fim ~
                              fi-Comprador-ini fi-Comprador-fim ~
                              fi-dt-emissao-ini fi-dt-emissao-fim ~
                              fi-periodo-ini fi-periodo-fim ~
                              fi-pedido-ini fi-pedido-fim ~
                              fi-item-ini fi-item-fim ~
                              fi-fornecedor-ini fi-fornecedor-fim ~
                              brMain ~
                              btAtualizar ~
                              btExit ~
                              btHelp ~
                              btMarcaDesmarca ~
                              btQueryJoins ~
                              btReportsJoins ~
                              btSelecionar ~
                              btMarcaDesmarcaUm


/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-ordens NO-UNDO
    FIELD sel          AS LOGICAL FORMAT "*/ ":U
    FIELD it-codigo    LIKE ordem-compra.it-codigo
    FIELD cod-estabel  LIKE ordem-compra.cod-estabel
    FIELD cod-comprado LIKE ordem-compra.cod-comprado
    FIELD cod-emitente LIKE ordem-compra.cod-emitente
    FIELD nome-abrev   LIKE emitente.nome-abrev
    FIELD num-pedido   LIKE ordem-compra.num-pedido
    FIELD numero-ordem LIKE ordem-compra.numero-ordem
    FIELD parcela      LIKE prazo-compra.parcela
    FIELD data-entrega LIKE prazo-compra.data-entrega
    FIELD nova-data    LIKE prazo-compra.data-entrega
    FIELD contato      LIKE cont-emit.nome
    FIELD telefone     LIKE cont-emit.telefone
    FIELD quantidade   LIKE prazo-compra.quantidade
    INDEX codigo IS PRIMARY
        data-entrega
        it-codigo
        cod-emitente.

DEFINE TEMP-TABLE tt-embarque NO-UNDO
    FIELD embarque AS CHARACTER FORMAT "x(16)":U.
                                
/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-bocx225    AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-conf       AS LOGICAL     NO-UNDO FORMAT "Sim/Nao":U.
DEFINE VARIABLE l-altera     AS LOGICAL     NO-UNDO FORMAT "Situaá∆o/Data":U.
DEFINE VARIABLE da-nova-data AS DATE        NO-UNDO FORMAT "99/99/9999":U INITIAL TODAY.
DEFINE VARIABLE c-motivo     AS CHARACTER   NO-UNDO FORMAT "x(60)":U.

/**** Chamado: 56936 ***/
DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.
DEFINE VARIABLE c-email-provisorio AS CHARACTER   NO-UNDO FORMAT "x(2000)":U.
DEFINE VARIABLE c-email            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-destinatario     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-motivo-sit       AS CHARACTER   NO-UNDO FORMAT "x(60)":U.
{utp/utapi009.i}
{esp/es0018.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brMain

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ordens

/* Definitions for BROWSE brMain                                        */
&Scoped-define FIELDS-IN-QUERY-brMain sel it-codigo cod-estabel cod-comprado cod-emitente nome-abrev num-pedido substring(string(numero-ordem),1,6) @ tt-ordens.numero-ordem parcela quantidade data-entrega contato telefone   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brMain   
&Scoped-define SELF-NAME brMain
&Scoped-define QUERY-STRING-brMain FOR EACH tt-ordens
&Scoped-define OPEN-QUERY-brMain OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens.
&Scoped-define TABLES-IN-QUERY-brMain tt-ordens
&Scoped-define FIRST-TABLE-IN-QUERY-brMain tt-ordens


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brMain}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-estab-ini fi-estab-fim fi-Comprador-ini ~
fi-Comprador-fim fi-dt-emissao-ini fi-dt-emissao-fim fi-periodo-ini ~
fi-periodo-fim fi-pedido-ini fi-pedido-fim fi-fornecedor-ini ~
fi-fornecedor-fim fi-item-ini fi-item-fim btSelecionar brMain ~
btMarcaDesmarcaUm btMarcaDesmarca btAtualizar btQueryJoins btReportsJoins ~
btExit btHelp RECT-1 rtToolBar-2 
&Scoped-Define DISPLAYED-OBJECTS fi-estab-ini fi-estab-fim fi-Comprador-ini ~
fi-Comprador-fim fi-dt-emissao-ini fi-dt-emissao-fim fi-periodo-ini ~
fi-periodo-fim fi-pedido-ini fi-pedido-fim fi-fornecedor-ini ~
fi-fornecedor-fim fi-item-ini fi-item-fim 

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
DEFINE BUTTON btAtualizar 
     LABEL "Atualizar" 
     SIZE 13 BY 1.13.

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

DEFINE BUTTON btMarcaDesmarca 
     LABEL "Marca Todos" 
     SIZE 15 BY 1.13.

DEFINE BUTTON btMarcaDesmarcaUm 
     LABEL "Marca Selecionado" 
     SIZE 19 BY 1.13.

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

DEFINE BUTTON btSelecionar 
     LABEL "Selecionar" 
     SIZE 12 BY 1.13.

DEFINE VARIABLE fi-Comprador-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-Comprador-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Comprador" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-emissao-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-emissao-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab-fim AS CHARACTER FORMAT "X(03)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab-ini AS CHARACTER FORMAT "X(03)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-fornecedor-fim AS INTEGER FORMAT "99999999":U INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-fornecedor-ini AS INTEGER FORMAT "99999999":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-item-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-item-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-pedido-fim AS INTEGER FORMAT "999999":U INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-pedido-ini AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "Pedido" 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Per°odo" 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 118 BY 7.29.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 120 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brMain FOR 
      tt-ordens SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brMain wWindow _FREEFORM
  QUERY brMain DISPLAY
      sel           COLUMN-LABEL "Sel"
     it-codigo     FORMAT "x(7)"       COLUMN-LABEL "Item C¢digo"
     cod-estabel   COLUMN-LABEL "Est" FORMAT "x(03)" WIDTH 3
     cod-comprado  COLUMN-LABEL "Comprador"
     cod-emitente  COLUMN-LABEL "Fornecedor"
     nome-abrev    COLUMN-LABEL "Nome"
     num-pedido    COLUMN-LABEL "Pedido"
     substring(string(numero-ordem),1,6) @ tt-ordens.numero-ordem column-label "Ordem"  format "999999"
     parcela       FORMAT ">9"         COLUMN-LABEL "Parc"
     quantidade    FORMAT "->>>,>>>,>>9.99" COLUMN-LABEL "Quantidade"
     data-entrega  FORMAT "99/99/9999" COLUMN-LABEL "Entrega"
     contato       COLUMN-LABEL "Contato"
     telefone      COLUMN-LABEL "Telefone"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 118 BY 9.5
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-estab-ini AT ROW 2.75 COL 57 RIGHT-ALIGNED
     fi-estab-fim AT ROW 2.75 COL 62 COLON-ALIGNED NO-LABEL
     fi-Comprador-ini AT ROW 3.75 COL 57 RIGHT-ALIGNED
     fi-Comprador-fim AT ROW 3.75 COL 62 COLON-ALIGNED NO-LABEL
     fi-dt-emissao-ini AT ROW 4.75 COL 57 RIGHT-ALIGNED
     fi-dt-emissao-fim AT ROW 4.75 COL 62 COLON-ALIGNED NO-LABEL
     fi-periodo-ini AT ROW 5.75 COL 57 RIGHT-ALIGNED
     fi-periodo-fim AT ROW 5.75 COL 62 COLON-ALIGNED NO-LABEL
     fi-pedido-ini AT ROW 6.75 COL 57 RIGHT-ALIGNED
     fi-pedido-fim AT ROW 6.75 COL 62 COLON-ALIGNED NO-LABEL
     fi-fornecedor-ini AT ROW 7.75 COL 57 RIGHT-ALIGNED
     fi-fornecedor-fim AT ROW 7.75 COL 62 COLON-ALIGNED NO-LABEL
     fi-item-ini AT ROW 8.75 COL 57 RIGHT-ALIGNED
     fi-item-fim AT ROW 8.75 COL 62 COLON-ALIGNED NO-LABEL
     btSelecionar AT ROW 8.5 COL 107.14
     brMain AT ROW 10.04 COL 2
     btMarcaDesmarcaUm AT ROW 19.58 COL 2
     btMarcaDesmarca AT ROW 19.58 COL 22
     btAtualizar AT ROW 19.58 COL 38
     btQueryJoins AT ROW 1.13 COL 104.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 108.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 112.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 116.72 HELP
          "Ajuda"
     RECT-1 AT ROW 2.58 COL 2
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 120 BY 20
         FONT 1.


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
         TITLE              = "Atualizaá∆o da Data de Entrega"
         HEIGHT             = 20
         WIDTH              = 120
         MAX-HEIGHT         = 20
         MAX-WIDTH          = 120
         VIRTUAL-HEIGHT     = 20
         VIRTUAL-WIDTH      = 120
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
/* BROWSE-TAB brMain btSelecionar fpage0 */
ASSIGN 
       brMain:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

/* SETTINGS FOR FILL-IN fi-Comprador-ini IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-dt-emissao-ini IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-estab-ini IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-fornecedor-ini IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-item-ini IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-pedido-ini IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-periodo-ini IN FRAME fpage0
   ALIGN-R                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brMain
/* Query rebuild information for BROWSE brMain
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brMain */
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
ON END-ERROR OF wWindow /* Atualizaá∆o da Data de Entrega */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Atualizaá∆o da Data de Entrega */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brMain
&Scoped-define SELF-NAME brMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brMain wWindow
ON MOUSE-SELECT-DBLCLICK OF brMain IN FRAME fpage0
DO:
    ASSIGN tt-ordens.sel = NOT tt-ordens.sel.

    Brmain:REFRESH().

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brMain wWindow
ON RETURN OF brMain IN FRAME fpage0
DO:
    APPLY "choose" TO btMarcaDesmarcaUm IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAtualizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualizar wWindow
ON CHOOSE OF btAtualizar IN FRAME fpage0 /* Atualizar */
DO:
    IF NOT AVAIL tt-ordens THEN NEXT.

    MESSAGE "Deseja alterar (Situaá∆o/Data)? " UPDATE l-altera.

    IF l-altera THEN DO:
     /**** Chamado: 56936 ***/
    /*         run utp/ut-msgs.p(input "show",                                                                                                          */
    /*                           input 17006,                                                                                                           */
    /*                           input 'Opá∆o Desabilitada. Utilize cc0300.~~Estamos alterando este procedimento, favor entrar em contato com a TIC.'). */
    /*         RETURN NO-APPLY.                                                                                                                         */

        RUN pi-situacao.

        /**** Chamado: 56936 ***/
        IF c-email-provisorio <> '' THEN DO:

            RUN pi-retorna-email(INPUT c-seg-usuario, OUTPUT c-email).
            IF c-email = '' THEN
                ASSIGN c-email = "ems@intelbras.com.br".

            RUN esp/es0018p.p (INPUT "esccp009",
                               INPUT 1,
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto).

            FOR EACH tt-prog-ponto
               WHERE tt-prog-ponto.nome-programa = "esccp009"
                 AND tt-prog-ponto.ponto         = 1:
                ASSIGN c-destinatario = c-destinatario + tt-prog-ponto.conteudo + ";".
            END.

            RUN pi-email(/*Remetente   */ INPUT c-email,
                         /*Destinatario*/ INPUT c-destinatario, 
                         /*Assunto     */ INPUT "Alteraá∆o Situaá∆o ESCCP009",
                         /*Mensagem    */ INPUT c-email-provisorio,
                         /*Anexo       */ INPUT "").
        END.

        FOR EACH tt-ordens:
            DELETE tt-ordens.
        END.
    END.
    ELSE DO:
        RUN pi-data.

        IF RETURN-VALUE <> "NOK":U THEN DO:
            FOR EACH tt-ordens:
                DELETE tt-ordens.
            END.

            FOR EACH prazo-compra NO-LOCK
                WHERE (prazo-compra.situacao      = 2
                   OR  prazo-compra.situacao      = 3
                   OR  prazo-compra.situacao      = 5
                   OR  prazo-compra.situacao      = 1)
                  AND  prazo-compra.data-entrega >= da-nova-data
                  AND  prazo-compra.data-entrega <= da-nova-data
                  AND  prazo-compra.quant-saldo  > 0,
                FIRST ordem-compra NO-LOCK
                WHERE  ordem-compra.numero-ordem  = prazo-compra.numero-ordem
                  AND  ordem-compra.it-codigo    >= fi-item-ini:SCREEN-VALUE
                  AND  ordem-compra.it-codigo    <= fi-item-fim:SCREEN-VALUE
                  AND  ordem-compra.data-emissao >= DATE(fi-dt-emissao-ini:SCREEN-VALUE)
                  AND  ordem-compra.data-emissao <= DATE(fi-dt-emissao-fim:SCREEN-VALUE)
                  AND (ordem-compra.situacao      = 2
                   OR  ordem-compra.situacao      = 3
                   OR  ordem-compra.situacao      = 5
                   OR  ordem-compra.situacao      = 1)
                  AND  ordem-compra.num-pedido   >= INTEGER(fi-pedido-ini:SCREEN-VALUE)
                  AND  ordem-compra.num-pedido   <= INTEGER(fi-pedido-fim:SCREEN-VALUE)
                  AND  ordem-compra.cod-comprado >= fi-comprador-ini:SCREEN-VALUE
                  AND  ordem-compra.cod-comprado <= fi-comprador-fim:SCREEN-VALUE
                  AND  ordem-compra.cod-emitente >= INTEGER(fi-fornecedor-ini:SCREEN-VALUE)
                  AND  ordem-compra.cod-emitente <= INTEGER(fi-fornecedor-fim:SCREEN-VALUE),
                FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = ordem-compra.cod-emitente:

                FIND FIRST cont-emit
                    WHERE cont-emit.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

                CREATE tt-ordens.
                ASSIGN tt-ordens.it-codigo    = ordem-compra.it-codigo
                       tt-ordens.cod-comprado = ordem-compra.cod-comprado
                       tt-ordens.cod-emitente = ordem-compra.cod-emitente
                       tt-ordens.nome-abrev   = emitente.nome-abrev
                       tt-ordens.num-pedido   = ordem-compra.num-pedido
                       tt-ordens.numero-ordem = ordem-compra.numero-ordem
                       tt-ordens.parcela      = prazo-compra.parcela
                       tt-ordens.data-entrega = prazo-compra.data-entrega
                       tt-ordens.contato      = cont-emit.nome     WHEN AVAILABLE cont-emit
                       tt-ordens.telefone     = cont-emit.telefone WHEN AVAILABLE cont-emit
                       tt-ordens.quantidade   = prazo-compra.quant-saldo.
            END.
        END.
    END.

    {&OPEN-QUERY-BrMain}

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


&Scoped-define SELF-NAME btMarcaDesmarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMarcaDesmarca wWindow
ON CHOOSE OF btMarcaDesmarca IN FRAME fpage0 /* Marca Todos */
DO:
    IF btMarcaDesmarca:LABEL = "Marca Todos" THEN DO:
        FOR EACH tt-ordens:
            ASSIGN tt-ordens.sel = YES.
        END.
        btMarcaDesmarca:LABEL = "Desmarca Todos".
    END.
    ELSE DO:
        FOR EACH tt-ordens:
            ASSIGN tt-ordens.sel = NO.
        END.
        btMarcaDesmarca:LABEL = "Marca Todos".
    END.

    {&OPEN-QUERY-BrMain}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btMarcaDesmarcaUm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMarcaDesmarcaUm wWindow
ON CHOOSE OF btMarcaDesmarcaUm IN FRAME fpage0 /* Marca Selecionado */
DO:
  /*assign de-saldo-atu = 0.*/
  assign tt-ordens.sel = NOT tt-ordens.sel.
  

  Brmain:REFRESH().

  /* run pi-totaliza.  */ 

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


&Scoped-define SELF-NAME btSelecionar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelecionar wWindow
ON CHOOSE OF btSelecionar IN FRAME fpage0 /* Selecionar */
DO:
    STATUS DEFAULT "Aguarde, processando pesquisa... ".

    FOR EACH tt-ordens:
        DELETE tt-ordens.
    END.

    FOR EACH ordem-compra USE-INDEX estab-item-sit NO-LOCK
        WHERE  ordem-compra.cod-estabel   >= fi-estab-ini:SCREEN-VALUE
          AND  ordem-compra.cod-estabel   <= fi-estab-fim:SCREEN-VALUE 
          AND  ordem-compra.it-codigo     >= fi-item-ini:SCREEN-VALUE
          AND  ordem-compra.it-codigo     <= fi-item-fim:SCREEN-VALUE
          AND (ordem-compra.situacao       = 2
           OR  ordem-compra.situacao       = 3
           OR  ordem-compra.situacao       = 5
           OR  ordem-compra.situacao       = 1)
          AND  ordem-compra.num-pedido    >= INTEGER(fi-pedido-ini:SCREEN-VALUE)
          AND  ordem-compra.num-pedido    <= INTEGER(fi-pedido-fim:SCREEN-VALUE)
          AND  ordem-compra.cod-emitente  >= INTEGER(fi-fornecedor-ini:SCREEN-VALUE)
          AND  ordem-compra.cod-emitente  <= INTEGER(fi-fornecedor-fim:SCREEN-VALUE)
          AND  ordem-compra.cod-comprado  >= fi-comprador-ini:SCREEN-VALUE
          AND  ordem-compra.cod-comprado  <= fi-comprador-fim:SCREEN-VALUE
          AND  ordem-compra.data-emissao  >= DATE(fi-dt-emissao-ini:SCREEN-VALUE)
          AND  ordem-compra.data-emissao  <= DATE(fi-dt-emissao-fim:SCREEN-VALUE),
        EACH prazo-compra USE-INDEX ordem-sit NO-LOCK
        WHERE  prazo-compra.numero-ordem  = ordem-compra.numero-ordem
          AND  prazo-compra.data-entrega >= DATE(fi-periodo-ini:SCREEN-VALUE)
          AND  prazo-compra.data-entrega <= DATE(fi-periodo-fim:SCREEN-VALUE)
          AND (prazo-compra.situacao      = 1
           OR  prazo-compra.situacao      = 2
           OR  prazo-compra.situacao      = 3
           OR  prazo-compra.situacao      = 5)
          AND  prazo-compra.quant-saldo   > 0,
        FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = ordem-compra.cod-emitente:

        FIND FIRST cont-emit
            WHERE cont-emit.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

        CREATE tt-ordens.
        ASSIGN tt-ordens.it-codigo    = ordem-compra.it-codigo
               tt-ordens.cod-estabel  = ordem-compra.cod-estabel
               tt-ordens.cod-comprado = ordem-compra.cod-comprado
               tt-ordens.cod-emitente = ordem-compra.cod-emitente
               tt-ordens.nome-abrev   = emitente.nome-abrev
               tt-ordens.num-pedido   = ordem-compra.num-pedido
               tt-ordens.numero-ordem = ordem-compra.numero-ordem
               tt-ordens.parcela      = prazo-compra.parcela
               tt-ordens.data-entrega = prazo-compra.data-entrega
               tt-ordens.contato      = cont-emit.nome     WHEN AVAILABLE cont-emit
               tt-ordens.telefone     = cont-emit.telefone WHEN AVAILABLE cont-emit
               tt-ordens.quantidade   = prazo-compra.quant-saldo.
    END.

    {&OPEN-QUERY-BrMain}

    STATUS DEFAULT "":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Data wWindow 
PROCEDURE pi-Data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-seq      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cont     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    IF AVAILABLE param-global AND
       param-global.modulo-07 THEN DO:

        EMPTY TEMP-TABLE RowErrors.

        ASSIGN i-seq = 0.

        ordens:
        FOR EACH tt-ordens
            WHERE tt-ordens.sel = YES:

            FIND FIRST ordem-compra
                WHERE ordem-compra.numero-ordem = tt-ordens.numero-ordem NO-LOCK NO-ERROR.

            IF NOT AVAILABLE ordem-compra THEN
                NEXT ordens.

            FIND FIRST emitente
                WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.

            IF NOT AVAILABLE emitente THEN
                NEXT ordens.

            IF emitente.natureza > 2 THEN DO:
                FIND FIRST pedido-compr
                    WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.

                FIND FIRST prazo-compra
                    WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                      AND prazo-compra.parcela      = tt-ordens.parcela NO-LOCK NO-ERROR.

                IF NOT AVAILABLE pedido-compr OR
                   NOT AVAILABLE prazo-compra THEN
                    NEXT ordens.

                IF NOT VALID-HANDLE(h-bocx225)               OR
                   h-bocx225:TYPE      <> "PROCEDURE":U      OR
                   h-bocx225:FILE-NAME <> "cxbo/bocx225.p":U THEN
                    RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.

                IF VALID-HANDLE(h-bocx225) THEN
                    RUN procuraEmbarqueCompras IN h-bocx225 (INPUT  pedido-compr.num-pedido,
                                                             INPUT  ordem-compra.numero-ordem,
                                                             INPUT  prazo-compra.parcela,
                                                             OUTPUT TABLE tt-embarque).

                IF VALID-HANDLE(h-bocx225) THEN
                    DELETE PROCEDURE h-bocx225.

                ASSIGN h-bocx225 = ?.

                ASSIGN i-cont     = 0
                       c-mensagem = "":U.

                FOR EACH tt-embarque:
                    ASSIGN i-cont = i-cont + 1.

                    IF i-cont = 1 THEN
                        ASSIGN c-mensagem = tt-embarque.embarque.
                    ELSE
                        ASSIGN c-mensagem = c-mensagem + ", ":U + tt-embarque.embarque.
                END.

                IF i-cont >= 1 THEN DO:
                    ASSIGN i-seq = i-seq + 1.

                    CREATE RowErrors.
                    ASSIGN RowErrors.ErrorSequence    = i-seq
                           RowErrors.ErrorNumber      = 17006
                           RowErrors.ErrorType        = "EMS":U
                           RowErrors.ErrorSubType     = "Error":U
                           RowErrors.ErrorDescription = "Atená∆o: Vocà pode ter alterado uma parcela vinculada a um embarque.":U
                           RowErrors.ErrorHelp        = "A Ordem de Compra " + TRIM(STRING(prazo-compra.numero-ordem, "zzzzz9,99":U)) + ", Parcela ":U + TRIM(STRING(prazo-compra.parcela, ">>>>9":U)) + ", est† vinculada ao(s) embarque(s) ":U + c-mensagem + ".":U + CHR(10) +
                                                        "Para fazer alteraá∆o, favor desvincular a(s) parcela(s) do(s) embarque(s) antes de efetuar a alteraá∆o.":U
                           RowErrors.ErrorParameters  = "Atená∆o: Vocà pode ter alterado uma parcela vinculada a um embarque.":U +
                                                        "~~":U +
                                                        "A Ordem de Compra " + TRIM(STRING(prazo-compra.numero-ordem, "zzzzz9,99":U)) + ", Parcela ":U + TRIM(STRING(prazo-compra.parcela, ">>>>9":U)) + ", est† vinculada ao(s) embarque(s) ":U + c-mensagem + ".":U + CHR(10) +
                                                        "Para fazer alteraá∆o, favor desvincular a(s) parcela(s) do(s) embarque(s) antes de efetuar a alteraá∆o.":U.
                END. /* IF i-cont >= 1 THEN DO: */
            END. /* IF emitente.natureza > 2 THEN DO: */
        END. /* FOR EACH tt-ordens
                    WHERE tt-ordens.sel = YES: */

        IF CAN-FIND(FIRST RowErrors) THEN DO:
            {method/ShowMessage.i1}
            {method/ShowMessage.i2 &Modal="YES"}
            {method/ShowMessage.i3}

            RETURN "NOK":U.
        END.
    END. /* IF AVAILABLE param-global AND
               param-global.modulo-07 THEN DO: */


    UPDATE da-nova-data LABEL "Nova Data" VALIDATE(da-nova-data >= TODAY,
           "A data deve ser maior ou igual a hoje")                SKIP
           c-motivo LABEL "Motivo"
           WITH ROW 8 CENTERED OVERLAY SIDE-LABELS FRAME f-page0.
           
           
    MESSAGE "A †rea de inform†tica n∆o tem como recuperar informaá‰es alteradas" SKIP
            "por este programa. Portanto s¢ confirme a alteraá∆o com "           SKIP
            "ABSOLUTA CERTEZA da alteraá∆o que esta fazendo"
            VIEW-AS ALERT-BOX TITLE "**** ATENÄ«O - INFORMAÄ«O IMPORTANTE ***".
    
    ASSIGN l-conf = NO.
           
    MESSAGE "Confirma Alteraá∆o de TODAS as entregas SELECIONADAS para " 
             da-nova-data UPDATE l-conf.

    HIDE FRAME f-page0 NO-PAUSE.
    
    IF NOT l-conf THEN NEXT.

    MESSAGE "Altera data original ? " UPDATE l-conf.
    
    FOR EACH tt-ordens WHERE
             tt-ordens.sel:
        FIND ordem-compra NO-LOCK WHERE
             ordem-compra.numero-ordem = tt-ordens.numero-ordem.
        FIND emitente NO-LOCK WHERE
             emitente.cod-emitente = ordem-compra.cod-emitente.
        FIND prazo-compra WHERE
             prazo-compra.numero-ordem = tt-ordens.numero-ordem AND
             prazo-compra.parcela      = tt-ordens.parcela.
        CREATE alt-ped.
        ASSIGN alt-ped.num-pedido = ordem-compra.num-pedido
               alt-ped.numero-ordem = ordem-compra.numero-ordem
               alt-ped.parcela = prazo-compra.parcela
               alt-ped.data = TODAY
               alt-ped.hora = STRING(time,"hh:mm:ss")
               alt-ped.usuario = USERID("mgadm")
               alt-ped.data-entrega = prazo-compra.data-entrega
               alt-ped.observacao = c-motivo
               alt-ped.quantidade = prazo-compra.quantidade
               alt-ped.cod-cond-pag = ?. 

        ASSIGN prazo-compra.data-entrega = da-nova-data.

        DELETE tt-ordens.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Situacao wWindow 
PROCEDURE pi-Situacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i-seq      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cont     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    IF AVAILABLE param-global AND
       param-global.modulo-07 THEN DO:

        EMPTY TEMP-TABLE RowErrors.

        ASSIGN i-seq = 0.

        ordens:
        FOR EACH tt-ordens
            WHERE tt-ordens.sel = YES:

            FIND FIRST ordem-compra
                WHERE ordem-compra.numero-ordem = tt-ordens.numero-ordem NO-LOCK NO-ERROR.

            IF NOT AVAILABLE ordem-compra THEN
                NEXT ordens.

            FIND FIRST emitente
                WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.

            IF NOT AVAILABLE emitente THEN
                NEXT ordens.

            IF emitente.natureza > 2 THEN DO:
                FIND FIRST pedido-compr
                    WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.

                FIND FIRST prazo-compra
                    WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                      AND prazo-compra.parcela      = tt-ordens.parcela NO-LOCK NO-ERROR.

                IF NOT AVAILABLE pedido-compr OR
                   NOT AVAILABLE prazo-compra THEN
                    NEXT ordens.

                IF NOT VALID-HANDLE(h-bocx225)               OR
                   h-bocx225:TYPE      <> "PROCEDURE":U      OR
                   h-bocx225:FILE-NAME <> "cxbo/bocx225.p":U THEN
                    RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.

                IF VALID-HANDLE(h-bocx225) THEN
                    RUN procuraEmbarqueCompras IN h-bocx225 (INPUT  pedido-compr.num-pedido,
                                                             INPUT  ordem-compra.numero-ordem,
                                                             INPUT  prazo-compra.parcela,
                                                             OUTPUT TABLE tt-embarque).

                IF VALID-HANDLE(h-bocx225) THEN
                    DELETE PROCEDURE h-bocx225.

                ASSIGN h-bocx225 = ?.

                ASSIGN i-cont     = 0
                       c-mensagem = "":U.

                FOR EACH tt-embarque:
                    ASSIGN i-cont = i-cont + 1.

                    IF i-cont = 1 THEN
                        ASSIGN c-mensagem = tt-embarque.embarque.
                    ELSE
                        ASSIGN c-mensagem = c-mensagem + ", ":U + tt-embarque.embarque.
                END.

                IF i-cont >= 1 THEN DO:
                    ASSIGN i-seq = i-seq + 1.

                    CREATE RowErrors.
                    ASSIGN RowErrors.ErrorSequence    = i-seq
                           RowErrors.ErrorNumber      = 17006
                           RowErrors.ErrorType        = "EMS":U
                           RowErrors.ErrorSubType     = "Error":U
                           RowErrors.ErrorDescription = "Atená∆o: Vocà pode ter alterado uma parcela vinculada a um embarque.":U
                           RowErrors.ErrorHelp        = "A Ordem de Compra " + TRIM(STRING(prazo-compra.numero-ordem, "zzzzz9,99":U)) + ", Parcela ":U + TRIM(STRING(prazo-compra.parcela, ">>>>9":U)) + ", est† vinculada ao(s) embarque(s) ":U + c-mensagem + ".":U + CHR(10) +
                                                        "Para fazer alteraá∆o, favor desvincular a(s) parcela(s) do(s) embarque(s) antes de efetuar a alteraá∆o.":U
                           RowErrors.ErrorParameters  = "Atená∆o: Vocà pode ter alterado uma parcela vinculada a um embarque.":U +
                                                        "~~":U +
                                                        "A Ordem de Compra " + TRIM(STRING(prazo-compra.numero-ordem, "zzzzz9,99":U)) + ", Parcela ":U + TRIM(STRING(prazo-compra.parcela, ">>>>9":U)) + ", est† vinculada ao(s) embarque(s) ":U + c-mensagem + ".":U + CHR(10) +
                                                        "Para fazer alteraá∆o, favor desvincular a(s) parcela(s) do(s) embarque(s) antes de efetuar a alteraá∆o.":U.
                END. /* IF i-cont >= 1 THEN DO: */
            END. /* IF emitente.natureza > 2 THEN DO: */
        END. /* FOR EACH tt-ordens
                    WHERE tt-ordens.sel = YES: */

        IF CAN-FIND(FIRST RowErrors) THEN DO:
            {method/ShowMessage.i1}
            {method/ShowMessage.i2 &Modal="YES"}
            {method/ShowMessage.i3}

            RETURN "NOK":U.
        END.
    END.


    /**** Chamado: 56936 ***/
    UPDATE c-motivo-sit LABEL "Motivo"
           WITH ROW 8 CENTERED OVERLAY SIDE-LABELS FRAME f-page0.

    MESSAGE "Confirma Alteraá∆o de TODAS as ordens SELECIONADAS para situaá∆o RECEBIDA" UPDATE l-conf.
    HIDE FRAME f-nova-data NO-PAUSE.

    HIDE FRAME f-page0 NO-PAUSE.

    IF NOT l-conf THEN NEXT.

    /**** Chamado: 56936 ***/
    ASSIGN c-email-provisorio = "Usu†rio: " + c-seg-usuario + CHR(13) + 
                                "Motivo: " + c-motivo-sit + CHR(13) + CHR(13) +
                                "Item;Estabel;Comprador;Fornec;Nome;Pedido;Ordem;Parc;Data;Qtde" + CHR(13).

    FOR EACH tt-ordens WHERE
             tt-ordens.sel:

        /**** Chamado: 56936 ***/
        ASSIGN c-email-provisorio = c-email-provisorio + 
                                    string(tt-ordens.it-codigo)    + ";" +
                                    string(tt-ordens.cod-estabel)  + ";" +
                                    string(tt-ordens.cod-comprado) + ";" +
                                    string(tt-ordens.cod-emitente) + ";" +
                                    string(tt-ordens.nome-abrev)   + ";" +
                                    string(tt-ordens.num-pedido)   + ";" +
                                    string(tt-ordens.numero-ordem) + ";" +
                                    string(tt-ordens.parcela)      + ";" +
                                    string(tt-ordens.data-entrega) + ";" +
                                    string(tt-ordens.quantidade)   + ";" + CHR(13).

        FIND prazo-compra WHERE 
             prazo-compra.numero-ordem = tt-ordens.numero-ordem AND
             prazo-compra.parcela      = tt-ordens.parcela NO-ERROR.
        ASSIGN prazo-compra.situacao     = 6
               prazo-compra.quant-rec    = prazo-compra.quantidade
               prazo-compra.quant-saldo  = 0
               prazo-compra.qtd-sal-forn = 0.
        RELEASE prazo-compra.

        FIND FIRST prazo-compra NO-LOCK 
            WHERE  prazo-compra.numero-ordem = tt-ordens.numero-ordem
              AND  prazo-compra.situacao    <> 4           /* Eliminada */
              AND  prazo-compra.situacao    <> 6 NO-ERROR. /* Recebida  */

        IF  NOT AVAIL prazo-compra
        THEN DO:
            FIND ordem-compra EXCLUSIVE-LOCK 
                WHERE ordem-compra.numero-ordem = tt-ordens.numero-ordem NO-ERROR.

            IF  AVAIL ordem-compra
            THEN DO:
                ASSIGN ordem-compra.situacao = 6.
                RELEASE ordem-compra.
            END.
        END.
        DELETE tt-ordens.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/**** Chamado: 56936 ***/
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-email wWindow 
PROCEDURE pi-email :

    DEFINE INPUT PARAMETER p-remetente AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-destino   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-assunto   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-mensagem  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-anexo     AS CHARACTER NO-UNDO.

    FOR EACH tt-envio:
        DELETE tt-envio.
    END.

    FIND FIRST param-global NO-LOCK.

    create tt-envio.
    assign tt-envio.versao-integracao = 1
           tt-envio.exchange          = param-global.log-1
           tt-envio.remetente         = p-remetente
           tt-envio.destino           = p-destino
           tt-envio.assunto           = p-assunto
           tt-envio.mensagem          = p-mensagem
           tt-envio.importancia       = 2
           tt-envio.log-enviada       = no
           tt-envio.log-lida          = no
           tt-envio.acomp             = no.
           tt-envio.arq-anexo         = p-anexo.
           
     run utp/utapi009.p ( input  table tt-envio,
                          output  table tt-erros).
    
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/**** Chamado: 56936 ***/
PROCEDURE pi-retorna-email:
    DEFINE  INPUT PARAMETER p-usuario AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-email   AS CHARACTER NO-UNDO.

    ASSIGN p-email = "".
    FIND FIRST emsfnd.usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuario = p-usuario NO-ERROR.
    IF AVAIL usuar_mestre AND usuar_mestre.cod_e_mail_local <> "" THEN 
        ASSIGN p-email = usuar_mestre.cod_e_mail_local.

END PROCEDURE.
