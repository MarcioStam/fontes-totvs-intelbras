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

{include/i-prgvrs.i escpp030 2.04.000.000}


CREATE WIDGET-POOL.


/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escep030
&GLOBAL-DEFINE Version        2.04.000.000
&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o,Destino

&GLOBAL-DEFINE page0Widgets   btExit btHelp
&GLOBAL-DEFINE page1Widgets   c-it-codigo fi-saldo bt-procura br-ae-item bt-transfere fi-qtde-transf
&GLOBAL-DEFINE page2Widgets   cb-impressora fi-descricao rs-destino
&GLOBAL-DEFINE ttTable        




DEF TEMP-TABLE tt-ae-item
    FIELD it-codigo    LIKE ae-item.it-codigo
    FIELD nr-ae        LIKE ae-item.nr-ae
    FIELD quantidade   LIKE ae-item.quantidade
    FIELD data         LIKE ae-item.data.


DEF VAR tot-Saldo   AS INT.
DEF VAR l-conf      AS LOG FORMAT "Sim/Nao".
DEF VAR i-conten    LIKE contenedor.lote-multipl.
DEF VAR de-qtde     AS DEC.
DEF VAR de-saldo    AS dec.
DEF VAR c-historico AS char.
DEF VAR c-local     LIKE ae-item.localizacao.
DEF VAR dt-trans    LIKE movto-estoq.dt-trans.
DEF VAR dt-validade AS date format "99/99/9999".
DEF VAR c-livre     AS char format "X(100)".

DEFINE VARIABLE p-msg-erro AS CHARACTER   NO-UNDO.


{esp/es0478.i "new"}
{esp/es0478-rpc.i}
{upc\btb910za-upc.i}
{esp/es0018.i}

 /*
{esp/es0478.i} /* definicao de variaveis */
{esp/es0007.i} /* busca conta de transferencia */
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-ae-item

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ae-item

/* Definitions for BROWSE br-ae-item                                    */
&Scoped-define FIELDS-IN-QUERY-br-ae-item tt-ae-item.it-codigo tt-ae-item.nr-ae tt-ae-item.quantidade tt-ae-item.data   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-ae-item   
&Scoped-define SELF-NAME br-ae-item
&Scoped-define QUERY-STRING-br-ae-item FOR EACH tt-ae-item
&Scoped-define OPEN-QUERY-br-ae-item OPEN QUERY {&SELF-NAME} FOR EACH tt-ae-item.
&Scoped-define TABLES-IN-QUERY-br-ae-item tt-ae-item
&Scoped-define FIRST-TABLE-IN-QUERY-br-ae-item tt-ae-item


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-ae-item}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btExit btHelp 

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

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 77 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-procura 
     LABEL "Procura..." 
     SIZE 9 BY 1.25.

DEFINE BUTTON bt-transfere 
     LABEL "Transferir..." 
     SIZE 9 BY 1.13.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(7)":U 
     LABEL "Item inicial" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE fi-qtde-transf AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Qtde. Transferir" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE fi-saldo AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Saldo total" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE fi-saldo-estoq AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Saldo em estoque localizado" 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 1.75.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 11.5.

DEFINE VARIABLE cb-impressora AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "1 - Barra", 1,
"2 - Barra2", 2,
"3 - Zebra", 3
     SIZE 12 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 23 BY 4.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66 BY 2.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-ae-item FOR 
      tt-ae-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-ae-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-ae-item wWindow _FREEFORM
  QUERY br-ae-item DISPLAY
      tt-ae-item.it-codigo         COLUMN-LABEL "C¢digo do Item" 
      tt-ae-item.nr-ae             COLUMN-LABEL "N£mero  AE"
      tt-ae-item.quantidade        COLUMN-LABEL "Quantidade"
      tt-ae-item.data              COLUMN-LABEL "Data da AE"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 69 BY 9.25
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btExit AT ROW 1.13 COL 69 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 73 HELP
          "Ajuda"
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.72 BY 17.88
         FONT 1.

DEFINE FRAME fPage1
     bt-procura AT ROW 1.5 COL 24
     c-it-codigo AT ROW 1.75 COL 8 COLON-ALIGNED
     fi-saldo-estoq AT ROW 1.75 COL 58 COLON-ALIGNED
     br-ae-item AT ROW 3.75 COL 2
     bt-transfere AT ROW 13.25 COL 62
     fi-saldo AT ROW 13.5 COL 10 COLON-ALIGNED
     fi-qtde-transf AT ROW 13.5 COL 45 COLON-ALIGNED
     RECT-5 AT ROW 1.25 COL 1
     RECT-8 AT ROW 3.25 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 4
         SIZE 73 BY 14
         FONT 1.

DEFINE FRAME fPage2
     rs-destino AT ROW 2.67 COL 11 NO-LABEL
     cb-impressora AT ROW 7.5 COL 9 NO-LABEL
     fi-descricao AT ROW 7.5 COL 23 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     "Impressora" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 6.5 COL 10
     "Destino" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 1.75 COL 9
     RECT-3 AT ROW 2 COL 6
     RECT-4 AT ROW 6.75 COL 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 4
         SIZE 73 BY 8.5
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
         TITLE              = ""
         HEIGHT             = 17.79
         WIDTH              = 77.86
         MAX-HEIGHT         = 19.83
         MAX-WIDTH          = 96.86
         VIRTUAL-HEIGHT     = 19.83
         VIRTUAL-WIDTH      = 96.86
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
  NOT-VISIBLE,                                                          */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB br-ae-item fi-saldo-estoq fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR COMBO-BOX cb-impressora IN FRAME fPage2
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-descricao IN FRAME fPage2
   NO-ENABLE                                                            */
ASSIGN 
       fi-descricao:READ-ONLY IN FRAME fPage2        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-ae-item
/* Query rebuild information for BROWSE br-ae-item
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ae-item.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-ae-item */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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


&Scoped-define SELF-NAME fpage0
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fpage0 wWindow
ON ENTRY OF FRAME fpage0
DO:
    fi-saldo:SENSITIVE IN FRAME fpage1 = FALSE.  
    fi-saldo-estoq:SENSITIVE IN FRAME fpage1 = FALSE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-ae-item
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-ae-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ae-item wWindow
ON MOUSE-SELECT-CLICK OF br-ae-item IN FRAME fPage1
DO:
    /*
    ASSIGN fi-motivo:SCREEN-VALUE IN FRAME fpage1 = "".  
    ASSIGN fi-motivo:SCREEN-VALUE IN FRAME fpage1 = tt-item.motivo.  
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ae-item wWindow
ON MOUSE-SELECT-DBLCLICK OF br-ae-item IN FRAME fPage1
DO:
  /*
    FIND FIRST int-saldo-estoq WHERE
               int-saldo-estoq.cod-estabel = tt-item.cod-estabel  AND
               int-saldo-estoq.cod-depos   = tt-item.cod-depos    AND
               int-saldo-estoq.it-codigo   = tt-item.it-codigo    AND
               int-saldo-estoq.cod-localiz = tt-item.cod-localiz  NO-ERROR. 
    IF AVAIL int-saldo-estoq THEN DO:
       IF int-saldo-estoq.log-bloqueado = NO THEN DO:
          ASSIGN int-saldo-estoq.log-bloqueado = YES.
          RUN motivo.
      END.
       ELSE DO:
          ASSIGN int-saldo-estoq.log-bloqueado = NO
                 int-saldo-estoq.motivo        = "".
       END.
    END.

    APPLY 'choose' TO bt-procura.
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-procura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-procura wWindow
ON CHOOSE OF bt-procura IN FRAME fPage1 /* Procura... */
DO:
    FOR EACH tt-ae-item:
        DELETE tt-ae-item.
    END.
    {&OPEN-QUERY-br-ae-item}

    tot-Saldo = 0.
    de-saldo  = 0.

    fi-saldo:SCREEN-VALUE IN FRAME fpage1 = string(tot-Saldo).
    fi-saldo-estoq:SCREEN-VALUE IN FRAME fpage1 = string(de-saldo).
    fi-qtde-transf:SCREEN-VALUE IN FRAME fpage1 = string(de-saldo).



    FOR EACH ae-item use-index fifo                                         WHERE
             ae-item.cod-estabel = v_cod_estab_usuar and
             ae-item.it-codigo   = c-it-codigo:SCREEN-VALUE IN FRAME fpage1 AND
         NOT ae-item.situacao                                               AND 
             ae-item.cod-depos = "EXP"                                      AND 
             ae-item.localizacao <> "":
         CREATE tt-ae-item.
                ASSIGN tt-ae-item.it-codigo  = ae-item.it-codigo
                       tt-ae-item.nr-ae      = ae-item.nr-ae
                       tt-ae-item.quantidade = ae-item.quantidade
                       tt-ae-item.data       = ae-item.data.          
         tot-Saldo = tot-Saldo + ae-item.quantidade.   
    END.

    fi-saldo:SCREEN-VALUE IN FRAME fpage1 = string(tot-Saldo).

    {&OPEN-QUERY-br-ae-item}


    FOR EACH saldo-estoq NO-LOCK                     WHERE
             saldo-estoq.cod-estabel = v_cod_estab_usuar and
             saldo-estoq.cod-depos    = "exp"        AND
             saldo-estoq.cod-localiz <> ""           AND 
             saldo-estoq.it-codigo    = c-it-codigo:SCREEN-VALUE IN FRAME fpage1:
        FIND int-saldo-estoq                                        WHERE
             int-saldo-estoq.cod-estabel = saldo-estoq.cod-estabel  AND 
             int-saldo-estoq.cod-depos   = saldo-estoq.cod-depos    AND
             int-saldo-estoq.it-codigo   = saldo-estoq.it-codigo    AND
             int-saldo-estoq.cod-localiz = saldo-estoq.cod-localiz  AND
             int-saldo-estoq.log-bloqueado                          NO-LOCK NO-ERROR.

        IF AVAIL int-saldo-estoq THEN NEXT.

        ASSIGN de-saldo = de-saldo + (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada).

    END.

    fi-saldo-estoq:SCREEN-VALUE IN FRAME fpage1 = string(de-saldo).

    fi-qtde-transf:SCREEN-VALUE IN FRAME fpage1 = string(de-saldo).


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-transfere
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-transfere wWindow
ON CHOOSE OF bt-transfere IN FRAME fPage1 /* Transferir... */
DO:           
    IF INT(fi-saldo-estoq:SCREEN-VALUE IN FRAME fpage1) < INT(fi-qtde-transf:SCREEN-VALUE IN FRAME fpage1) THEN DO:
       MESSAGE "Qtde informada n∆o pode ser maior que o saldo em estoque"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
       LEAVE.
    END.

    
    ASSIGN l-conf = NO.
    MESSAGE "Confirma a transferencia" UPDATE l-conf.

    IF l-conf THEN DO:
       FOR EACH ae-item USE-INDEX fifo                                          WHERE
                ae-item.cod-estabel = v_cod_estab_usuar and
                ae-item.it-codigo    = c-it-codigo:SCREEN-VALUE IN FRAME fpage1 AND
            NOT ae-item.situacao                                                AND 
                ae-item.localizacao <> "":

            FIND FIRST int-saldo-estoq NO-LOCK                           WHERE
                       int-saldo-estoq.cod-estabel = ae-item.cod-estabel and 
                       int-saldo-estoq.cod-depos   = "exp"               AND 
                       int-saldo-estoq.cod-localiz = ae-item.localizacao AND
                       int-saldo-estoq.it-codigo   = ae-item.it-codigo   AND
                       int-saldo-estoq.log-bloqueado                     NO-ERROR.
            IF AVAIL int-saldo-estoq THEN DO:
               MESSAGE "Ae " ae-item.nr-ae " com saldo bloqueado" 
                      VIEW-AS ALERT-BOX.
               NEXT.
            END.

            FIND FIRST contenedor NO-LOCK WHERE
                       contenedor.it-codigo = int-saldo-estoq.it-codigo NO-ERROR.
            IF AVAIL contenedor THEN
               ASSIGN i-conten = contenedor.lote-multipl.
            ELSE
               ASSIGN i-conten = 0.

            ASSIGN de-qtde = de-qtde - ae-item.quantidade.

            DO /*TRANSACTION*/ :
               ASSIGN c-historico = "Transf es0754  - " + USERID("mgadm") +
                                    " - " + STRING(TODAY) +  " - "        +
                                     STRING(time,"HH:MM:SS")
                      c-local     = ae-item.localizacao
                      dt-trans    = TODAY.
              
               RUN esp/es0478-n.p 
                  (INPUT ae-item.it-codigo,     /* item                */
                   INPUT "EXP",                 /* deposito de saida   */ 
                   INPUT ae-item.localizacao,   /* local de saida      */
                   INPUT ae-item.quantidade,    /* quantidade total    */
                   INPUT "EXP",                 /* deposito de entrada */
                   INPUT ae-item.nr-ae,         /* numero docto        */
                   INPUT ae-item.sequencia,     /* serie               */
                   INPUT c-historico,           /* historico           */
                   INPUT ae-item.nr-ae,         /* numero do AE        */
                   INPUT ae-item.sequencia,     /* sequencia do AE     */
                   INPUT ae-item.roteiro,       /* roteiro             */  
                   INPUT 0,                     /* nota                */
                   INPUT no,                    /* baixa parcial       */
                   INPUT no,                    /* devolucao ou transferencia */
                   INPUT i-conten,              /* contenedor          */
                   INPUT 0,                     /* fornecedor          */
                   INPUT 1,                     /* sequencia inicial   */
                   INPUT yes,                   /* usa local informado */
                   INPUT "",                    /* local informado     */
                   INPUT dt-trans,              /* data movto-estoq    */
                   INPUT ae-item.data-validade, /* Validade da AE      */
                   INPUT c-livre,               /* Campo Caracter livre */
                   input ae-item.cod-estabel,   /* C¢digo do estabelecimento */
                   output table tt-etiqueta,
                   OUTPUT p-msg-erro).   
            END.

            IF l-deu-erro THEN UNDO, RETRY. 

            ASSIGN ae-item.situacao = yes.

            FIND FIRST int-saldo-estoq                               WHERE
                       int-saldo-estoq.cod-estabel = ae-item.cod-estabel and
                       int-saldo-estoq.it-codigo = ae-item.it-codigo AND
                       int-saldo-estoq.cod-depos = "exp"             AND
                       int-saldo-estoq.cod-localiz = c-local         NO-ERROR.

            IF NOT AVAIL int-saldo-estoq THEN DO:
               CREATE int-saldo-estoq.
               ASSIGN int-saldo-estoq.cod-estabel = ae-item.cod-estabel
                      int-saldo-estoq.it-codigo   = ae-item.it-codigo
                      int-saldo-estoq.cod-depos   = "exp" 
                      int-saldo-estoq.cod-localiz = c-local.
            END.

            ASSIGN int-saldo-estoq.log-baixado = no. 

            FIND FIRST ae-baixa NO-LOCK                       WHERE
                       ae-baixa.cod-estabel = ae-item.cod-estabel and
                       ae-baixa.nr-ae = ae-item.nr-ae         AND
                       ae-baixa.sequencia = ae-item.sequencia NO-ERROR.
            IF NOT AVAIL ae-baixa THEN DO:
               CREATE ae-baixa.
               ASSIGN ae-baixa.cod-estabel = ae-item.cod-estabel
                      ae-baixa.nr-ae       = ae-item.nr-ae 
                      ae-baixa.sequencia   = ae-item.sequencia
                      ae-baixa.localizacao = c-local.
            END.

            IF de-qtde <= 0 THEN
               LEAVE.
       END.

       /* MESSAGE de-qtde VIEW-AS ALERT-BOX. */

       IF de-qtde > 0 THEN
          MESSAGE "A qtde informada foi maior que o saldo nas AE`s. Verifique..." 
                  VIEW-AS ALERT-BOX.

       HIDE MESSAGE NO-PAUSE.
       MESSAGE "Fim Transferencia...".
    END.


    APPLY 'choose' TO bt-procura.  

    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME cb-impressora
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-impressora wWindow
ON VALUE-CHANGED OF cb-impressora IN FRAME fPage2
DO:
  DISP ENTRY(cb-impressora:LOOKUP(cb-impressora:SCREEN-VALUE), cb-impressora:PRIVATE-DATA)
      @ fi-descricao WITH FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino wWindow
ON VALUE-CHANGED OF rs-destino IN FRAME fPage2
DO:
  DEF VAR i-cont AS INTEGER NO-UNDO.

  CASE INPUT rs-destino:
      WHEN 1 OR WHEN 2 THEN DO:
          FOR FIRST impressora FIELDS (nom_impressora des_impressora) NO-LOCK
              WHERE impressora.nom_impressora = IF INPUT rs-destino = 1 THEN "eqf-barra" ELSE "eqf-barra2":
              cb-impressora:LIST-ITEMS = "".
              cb-impressora:INSERT(impressora.nom_impressora, 1).
              cb-impressora:SCREEN-VALUE = cb-impressora:ENTRY(1).
              cb-impressora:PRIVATE-DATA = impressora.des_impressora.
              DISP impressora.des_impressora @ fi-descricao WITH FRAME fPage2.
          END.
      END.
      WHEN 3 THEN DO:
          cb-impressora:LIST-ITEMS = "".
          i-cont = 0.
          cb-impressora:PRIVATE-DATA = "".
          FOR EACH impressora FIELDS (nom_impressora des_impressora) NO-LOCK
              WHERE impressora.des_impressora MATCHES "*zebra*"
              AND can-find(FIRST imprsor_usuar no-lock
                           where imprsor_usuar.nom_impressora = impressora.nom_impressora
                           and   imprsor_usuar.cod_usuario    = c-seg-usuario):
              i-cont = i-cont + 1.
              cb-impressora:INSERT(impressora.nom_impressora, i-cont).
              cb-impressora:PRIVATE-DATA = cb-impressora:PRIVATE-DATA + impressora.des_impressora + ",".
          END.
          cb-impressora:SCREEN-VALUE = cb-impressora:ENTRY(1).
          DISP ENTRY(1, cb-impressora:PRIVATE-DATA) @ fi-descricao WITH FRAME fPage2.
      END.
  END CASE.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime wWindow 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    /* DEF VAR i-cont AS INT NO-UNDO. */
    DEF VAR c-contagem AS CHAR.
    DEF VAR p-nom-impressora AS CHAR NO-UNDO.
    DEF VAR p-destino AS INTEGER NO-UNDO.
    DEF VAR contador AS INT.
    DEF VAR op AS INT.
    DEF VAR v-contagem AS INT.
    DEF VAR cont-tot AS INT.
    DEF VAR cont-final AS INT.

    ASSIGN op = 1.

    /* sem localizaá∆o */
    IF c-loc-ini:SCREEN-VALUE = "" AND
       c-loc-fim:SCREEN-VALUE = "" THEN DO:

        FOR EACH inventario WHERE
                 inventario.it-codigo   >= c-it-ini:SCREEN-VALUE IN FRAME fpage1      AND
                 inventario.it-codigo   <= c-it-fim:SCREEN-VALUE IN FRAME fpage1      AND
                 inventario.dt-saldo    =  date(da-data:SCREEN-VALUE IN FRAME fpage1) AND
                 inventario.cod-depos   =  c-cod-depos:SCREEN-VALUE IN FRAME fpage1, 
            EACH item NO-LOCK WHERE
                 item.it-codigo = inventario.it-codigo BREAK BY inventario.it-codigo
                                                         BY item.fm-codigo:

            ASSIGN op = 2.
    
            IF (inventario.val-apurado[2] <> ?                          AND 
               (inventario.val-apurado[2] = inventario.val-apurado[1])) OR
                inventario.val-apurado[3] <> ?                          THEN DO:
                NEXT.
            END.
    
            FIND saldo-estoq                                      WHERE
                 saldo-estoq.it-codigo   = inventario.it-codigo   AND
                 saldo-estoq.cod-depos   = inventario.cod-depos   AND
                 saldo-estoq.cod-localiz = inventario.cod-localiz NO-LOCK NO-ERROR.
            IF AVAIL saldo-estoq THEN DO:
               IF saldo-estoq.qtidade-atu = inventario.val-apurado[1] OR
                  saldo-estoq.qtidade-atu = inventario.val-apurado[2] THEN DO:
                  MESSAGE
                       "Quantidade atual do estoque Ç igual ao valor apurado da contagem!"
                      VIEW-AS ALERT-BOX INFO BUTTONS OK.
                  NEXT.
               END.
            END.
    
            IF inventario.val-apurado[3] = ? THEN 
               ASSIGN c-contagem = "***** 3a. Contagem *****".
            IF inventario.val-apurado[2] = ? THEN 
               ASSIGN c-contagem = "***** 2a. Contagem *****".
            IF inventario.val-apurado[1] = ? THEN
               ASSIGN c-contagem = "***** 1a. Contagem *****".
    
            IF v-contagem = 1 AND 
               c-contagem <> "***** 1a. Contagem *****" THEN DO: 
               NEXT.                                        
            END.
    
            IF v-contagem <> 2 AND
               c-contagem = "***** 2a. Contagem *****" THEN DO:
                NEXT.                                        
            END.
    
            IF v-contagem <> 3 AND
               c-contagem = "***** 3a. Contagem *****" THEN DO:
               NEXT.                                        
            END.
                                                              
            IF AVAIL saldo-estoq THEN DO:
               FIND int-saldo-estoq WHERE
                    int-saldo-estoq.cod-estabel = saldo-estoq.cod-estabel AND
                    int-saldo-estoq.cod-depos   = saldo-estoq.cod-depos   AND
                    int-saldo-estoq.cod-localiz = saldo-estoq.cod-localiz AND
                    int-saldo-estoq.lote        = saldo-estoq.lote        AND
                    int-saldo-estoq.it-codigo   = saldo-estoq.it-codigo   AND
                    int-saldo-estoq.cod-refer   = saldo-estoq.cod-refer   NO-ERROR.
                IF NOT AVAIL int-saldo-estoq THEN
                   BUFFER-COPY saldo-estoq TO int-saldo-estoq.
    
                ASSIGN int-saldo-estoq.log-congelado = yes.
                FIND CURRENT int-saldo-estoq NO-LOCK.
            END.
    
        
    
            /* inicio Impress∆o */    
            FOR FIRST imprsor_usuar FIELDS (nom_disposit_so) no-lock
                WHERE imprsor_usuar.nom_impressora = INPUT FRAME fpage2 cb-impressora AND
                      imprsor_usuar.cod_usuario    = c-seg-usuario:
                OUTPUT TO VALUE(imprsor_usuar.nom_disposit_so) page-size 0.
            END.
            
            
            /* output to spool/inv-etq.  */
            IF rs-destino = 3 THEN 
               {esp/es0291B.i}
            ELSE                     
               {esp/es0291Z.i}. 
            /* output close. */
    
            MESSAGE " ". pause 0.
    
            
            IF rs-destino = 3 then  
               UNIX silent impesc spool/inv-etq.
            ELSE 
               IF rs-destino = 1 then 
                  UNIX silent lp -d barra spool/inv-etq > /dev/null.
               ELSE
                  IF rs-destino = 2 then
                     UNIX silent lp -d barra2 spool/inv-etq > /dev/null.
            /* Fim impress∆o */
    
    
    
            ASSIGN contador = contador + 1.
            IF contador = 9 THEN DO:
               page.
               ASSIGN contador = 0.
            END.
    
            IF LAST-OF(item.fm-codigo) THEN 
               PAGE.

        END.

        IF op = 1 THEN
            MESSAGE "Informaá‰es insuficientes para a impress∆o"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.



    /* com localizaá∆o */
    ELSE DO:
        FOR EACH inventario WHERE
                 inventario.it-codigo   >= c-it-ini:SCREEN-VALUE IN FRAME fpage1      AND
                 inventario.it-codigo   <= c-it-fim:SCREEN-VALUE IN FRAME fpage1      AND
                 inventario.dt-saldo    =  date(da-data:SCREEN-VALUE IN FRAME fpage1) AND
                 inventario.cod-depos   =  c-cod-depos:SCREEN-VALUE IN FRAME fpage1   AND
                 inventario.cod-localiz >= c-loc-ini:SCREEN-VALUE IN FRAME fpage1     AND 
                 inventario.cod-localiz <= c-loc-fim:SCREEN-VALUE IN FRAME fpage1,                                    
            EACH item NO-LOCK WHERE
                 item.it-codigo = inventario.it-codigo BREAK BY inventario.cod-localiz
                                                             BY item.fm-codigo:

            ASSIGN op = 2.
    
            IF (inventario.val-apurado[2] <> ?                          AND 
               (inventario.val-apurado[2] = inventario.val-apurado[1])) OR
                inventario.val-apurado[3] <> ?                          THEN DO:
                NEXT.
            END.
    
            FIND saldo-estoq                                      WHERE
                 saldo-estoq.it-codigo   = inventario.it-codigo   AND
                 saldo-estoq.cod-depos   = inventario.cod-depos   AND
                 saldo-estoq.cod-localiz = inventario.cod-localiz NO-LOCK NO-ERROR.
            IF AVAIL saldo-estoq THEN DO:
               IF saldo-estoq.qtidade-atu = inventario.val-apurado[1] OR
                  saldo-estoq.qtidade-atu = inventario.val-apurado[2] THEN DO:
                  MESSAGE "Quantidade atual do estoque Ç igual ao valor apurado da contagem!"
                      VIEW-AS ALERT-BOX INFO BUTTONS OK.
                  NEXT.
               END.
            END.
    
            IF inventario.val-apurado[3] = ? THEN 
               ASSIGN c-contagem = "***** 3a. Contagem *****".
            IF inventario.val-apurado[2] = ? THEN 
               ASSIGN c-contagem = "***** 2a. Contagem *****".
            IF inventario.val-apurado[1] = ? THEN
               ASSIGN c-contagem = "***** 1a. Contagem *****".
    
            IF v-contagem = 1 AND 
               c-contagem <> "***** 1a. Contagem *****" THEN DO: 
               NEXT.                                        
            END.
    
            IF v-contagem <> 2 AND
               c-contagem = "***** 2a. Contagem *****" THEN DO:
                NEXT.                                        
            END.
    
            IF v-contagem <> 3 AND
               c-contagem = "***** 3a. Contagem *****" THEN DO:
               NEXT.                                        
            END.
                                                              
            IF AVAIL saldo-estoq THEN DO:
               FIND int-saldo-estoq WHERE
                    int-saldo-estoq.cod-estabel = saldo-estoq.cod-estabel AND
                    int-saldo-estoq.cod-depos   = saldo-estoq.cod-depos   AND
                    int-saldo-estoq.cod-localiz = saldo-estoq.cod-localiz AND
                    int-saldo-estoq.lote        = saldo-estoq.lote        AND
                    int-saldo-estoq.it-codigo   = saldo-estoq.it-codigo   AND
                    int-saldo-estoq.cod-refer   = saldo-estoq.cod-refer   NO-ERROR.
                IF NOT AVAIL int-saldo-estoq THEN
                   BUFFER-COPY saldo-estoq TO int-saldo-estoq.
    
                ASSIGN int-saldo-estoq.log-congelado = yes.
                FIND CURRENT int-saldo-estoq NO-LOCK.
            END.
    
        
    
            /* inicio Impress∆o */    
            FOR FIRST imprsor_usuar FIELDS (nom_disposit_so) no-lock
                WHERE imprsor_usuar.nom_impressora = INPUT FRAME fpage2 cb-impressora AND
                      imprsor_usuar.cod_usuario    = c-seg-usuario:
                OUTPUT TO VALUE(imprsor_usuar.nom_disposit_so) page-size 0.
            END.
            
            
            /* output to spool/inv-etq.  */
            IF rs-destino = 3 THEN 
               {esp/es0291B.i}
            ELSE                     
               {esp/es0291Z.i}. 
            /* output close. */
    
            MESSAGE " ". pause 0.
    
            
            IF rs-destino = 3 then  
               UNIX silent impesc spool/inv-etq.
            ELSE 
               IF rs-destino = 1 then 
                  UNIX silent lp -d barra spool/inv-etq > /dev/null.
               ELSE
                  IF rs-destino = 2 then
                     UNIX silent lp -d barra2 spool/inv-etq > /dev/null.
            /* Fim impress∆o */
    
    
    
            ASSIGN contador = contador + 1.
            IF contador = 9 THEN DO:
               page.
               ASSIGN contador = 0.
            END.
    
            IF LAST-OF(item.fm-codigo) THEN 
               PAGE.

        END.

        IF op = 1 THEN
            MESSAGE "Informaá‰es insuficientes para a impress∆o"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.


*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Motivo wWindow 
PROCEDURE Motivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    DEFINE FRAME fMotivo
           cMotivo        AT ROW 01.17  COL 18 COLON-ALIGN COLUMN-LABEL "Motivo:"
           btGoToOK       AT ROW 02.70  COL 2.14
           btGoToCancel   AT ROW 02.70  COL 13.14
           SPACE(0.28)
           WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Motivo do bloqueio" FONT 1
             DEFAULT-BUTTON btGoToOK.


    ON "CHOOSE":U OF btGoToOK IN FRAME fMotivo
    DO:
        SESSION:SET-WAIT-STATE("general":U).
        SESSION:SET-WAIT-STATE("":U).
        ASSIGN cMotivo.
        APPLY "GO":U TO FRAME fMotivo.
        ASSIGN int-saldo-estoq.motivo = cMotivo:SCREEN-VALUE IN FRAME fMotivo.
    END.



    ENABLE cMotivo
           btGoToOK
           btGoToCancel 
           WITH FRAME fMotivo.

    WAIT-FOR "GO":U OF FRAME fMotivo.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sel-a wWindow 
PROCEDURE sel-a :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    FOR EACH saldo-estoq                                                        WHERE
             saldo-estoq.it-codigo   >= c-it-ini:SCREEN-VALUE IN FRAME fpage1   AND
             saldo-estoq.it-codigo   <= c-it-fim:SCREEN-VALUE IN FRAME fpage1   AND
             saldo-estoq.cod-localiz >= c-loc-ini:SCREEN-VALUE IN FRAME fpage1  AND
             saldo-estoq.cod-localiz <= c-loc-fim:SCREEN-VALUE IN FRAME fpage1  AND
             saldo-estoq.cod-localiz <> ""                                      AND
             saldo-estoq.cod-depos    = "exp"                                   AND
             saldo-estoq.qtidade-atu <> 0,
        FIRST int-saldo-estoq WHERE
              int-saldo-estoq.cod-estabel = saldo-estoq.cod-estabel  AND
              int-saldo-estoq.cod-depos   = saldo-estoq.cod-depos    AND
              int-saldo-estoq.it-codigo   = saldo-estoq.it-codigo    AND
              int-saldo-estoq.cod-localiz = saldo-estoq.cod-localiz, 
        FIRST item WHERE
              item.it-codigo = saldo-estoq.it-codigo:


              IF int-saldo-estoq.log-bloqueado = YES THEN DO:
                 ASSIGN tot-bloq = tot-bloq + saldo-estoq.qtidade-atu.
              END.
              ELSE DO:
                 ASSIGN tot-desb = tot-desb + saldo-estoq.qtidade-atu.
              END.


              FIND FIRST ae-item WHERE 
                     NOT ae-item.situacao                               AND 
                         ae-item.it-codigo   = saldo-estoq.it-codigo    AND 
                         ae-item.localizacao = saldo-estoq.cod-localiz  NO-ERROR.

              FIND FIRST item-estab NO-LOCK WHERE
                         item-estab.cod-estabel = saldo-estoq.cod-estabel AND
                         item-estab.it-codigo   = saldo-estoq.it-codigo   NO-ERROR.
                   
              CREATE tt-item.
                    ASSIGN  tt-item.it-codigo       = saldo-estoq.it-codigo
                            tt-item.descricao-1     = item.descricao-1
                            tt-item.descricao-2     = item.descricao-2
                            tt-item.cod-localiz     = saldo-estoq.cod-localiz
                            tt-item.qtidade-atu     = saldo-estoq.qtidade-atu
                            tt-item.data            = ae-item.data
                            tt-item.log-bloqueado   = int-saldo-estoq.log-bloqueado
                            tt-item.cod-estabel     = int-saldo-estoq.cod-estabel
                            tt-item.cod-depos       = int-saldo-estoq.cod-depos
                            tt-item.motivo          = int-saldo-estoq.motivo.
    END.

*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sel-b-d wWindow 
PROCEDURE sel-b-d :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    FOR EACH saldo-estoq                                                        WHERE
             saldo-estoq.it-codigo   >= c-it-ini:SCREEN-VALUE IN FRAME fpage1   AND
             saldo-estoq.it-codigo   <= c-it-fim:SCREEN-VALUE IN FRAME fpage1   AND
             saldo-estoq.cod-localiz >= c-loc-ini:SCREEN-VALUE IN FRAME fpage1  AND
             saldo-estoq.cod-localiz <= c-loc-fim:SCREEN-VALUE IN FRAME fpage1  AND
             saldo-estoq.cod-localiz <> ""                                      AND
             saldo-estoq.cod-depos    = "exp"                                   AND
             saldo-estoq.qtidade-atu <> 0,
        FIRST int-saldo-estoq WHERE
              int-saldo-estoq.cod-estabel   = saldo-estoq.cod-estabel  AND
              int-saldo-estoq.cod-depos     = saldo-estoq.cod-depos    AND
              int-saldo-estoq.it-codigo     = saldo-estoq.it-codigo    AND
              int-saldo-estoq.cod-localiz   = saldo-estoq.cod-localiz  AND
              int-saldo-estoq.log-bloqueado = sit,
        FIRST item WHERE
              item.it-codigo = saldo-estoq.it-codigo:

              IF int-saldo-estoq.log-bloqueado = YES THEN DO:
                 ASSIGN tot-bloq = tot-bloq + saldo-estoq.qtidade-atu.
              END.
              ELSE DO:
                 ASSIGN tot-desb = tot-desb + saldo-estoq.qtidade-atu.
              END.

              FIND FIRST ae-item WHERE 
                     NOT ae-item.situacao                               AND 
                         ae-item.it-codigo   = saldo-estoq.it-codigo    AND 
                         ae-item.localizacao = saldo-estoq.cod-localiz  NO-ERROR.

              FIND FIRST item-estab NO-LOCK WHERE
                         item-estab.cod-estabel = saldo-estoq.cod-estabel AND
                         item-estab.it-codigo   = saldo-estoq.it-codigo   NO-ERROR.

              CREATE tt-item.
                    ASSIGN  tt-item.it-codigo       = saldo-estoq.it-codigo
                            tt-item.descricao-1     = item.descricao-1
                            tt-item.descricao-2     = item.descricao-2
                            tt-item.cod-localiz     = saldo-estoq.cod-localiz
                            tt-item.qtidade-atu     = saldo-estoq.qtidade-atu
                            tt-item.data            = ae-item.data
                            tt-item.log-bloqueado   = sit
                            tt-item.cod-estabel     = int-saldo-estoq.cod-estabel
                            tt-item.cod-depos       = int-saldo-estoq.cod-depos
                            tt-item.motivo          = int-saldo-estoq.motivo.
    END.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

