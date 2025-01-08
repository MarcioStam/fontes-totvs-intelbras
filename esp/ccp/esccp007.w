&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgmov           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttalt-ped NO-UNDO LIKE alt-ped
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttcotacao-item NO-UNDO LIKE cotacao-item
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttordem-compra NO-UNDO LIKE ordem-compra
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttpedido-compr NO-UNDO LIKE pedido-compr
       field r-rowid as rowid
       FIELD RowNum AS INTEGER INIT 1
       INDEX iSeq AS PRIMARY RowNum
       .



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esccp007 2.04.000.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esccp007
&GLOBAL-DEFINE Version        2.04.000.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   E-Mail,Serviáo

&GLOBAL-DEFINE page0Widgets   btExit btHelp ~
                              btAcao
&GLOBAL-DEFINE page1Widgets   fi-arq-htm fi-email fi-num-pedido btFile
&GLOBAL-DEFINE page2Widgets   fi-num-pedido
&GLOBAL-DEFINE ttTable        ttpedido-compr
&GLOBAL-DEFINE hDBOTable      dboin295
&GLOBAL-DEFINE DBOTable       boin295
&GLOBAL-DEFINE ttTable2       ttordem-compra
&GLOBAL-DEFINE hDBOTable2     dboin274
&GLOBAL-DEFINE DBOTable2      boin274
&GLOBAL-DEFINE ttTable3       ttcotacao-item
&GLOBAL-DEFINE hDBOTable3     dboin082
&GLOBAL-DEFINE DBOTable3      boin082
&GLOBAL-DEFINE ttTable4       ttalt-ped
&GLOBAL-DEFINE hDBOTable4     dboin011
&GLOBAL-DEFINE DBOTable4      boin011

{upc\btb910za-upc.i}

/* Parameters Definitions ---                                           */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable2} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable3} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable4} AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

DEF VAR l-ok AS LOGICAL NO-UNDO.
DEF VAR wh-num-pedido AS WIDGET-HANDLE NO-UNDO.
DEF VAR i-page AS INT NO-UNDO INIT 1.
def var de-preco-conv     as decimal no-undo.
def var c-data         as char  no-undo.
def var da-novo-emb    as date format "99/99/9999" NO-UNDO.
def var c-via-trans        as char no-undo extent 9 initial ["Rodovi†ria","AÇrea","Mar°tima","Ferrovi†ria","Rodoferrovi†ria","Rodofluvial","Rodoaerovi†ria","Outras","AÇrea e Mar°tima"].
def var c-incoterm         as char no-undo.
def var i-via              as integer no-undo.
DEF VAR c-remetente        AS CHAR NO-UNDO INIT "ems@intelbras.com.br".
def var de-preco-total     as decimal                              no-undo.
DEF VAR c_imagem_usada  AS CHAR NO-UNDO.
DEFINE VARIABLE c-narrativa  AS CHARACTER   NO-UNDO.

def temp-table tt-ordens NO-UNDO
    field oc              as char format "x(20)" 
    field it-codigo       as char format "x(7)"
    field descricao       as char format "x(60)" 
    field un              as char format "x(2)"
    field pn              as char format "x(60)"
    field classif         as char format "x(12)"
    field qtd             as char format "x(16)"
    field preco-unit      as char format "x(13)"
    field al-ipi          as char format "x(6)"
    field preco-tot       as char format "x(14)"
    field dt-embarque     as char format "x(100)"
    field situacao        as char format "x(9)"
    field nr-conhecimento as char format "x(15)"
    field desc-moeda      as char format "x(15)"
    index chave
          oc
          it-codigo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar rtToolBar-2 btExit btHelp btAcao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-atualiza-cotacao wWindow 
FUNCTION fn-atualiza-cotacao RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-atualiza-pedido wWindow 
FUNCTION fn-atualiza-pedido RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-atualza-ordem wWindow 
FUNCTION fn-atualza-ordem RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-cria-altped wWindow 
FUNCTION fn-cria-altped RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relatærios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte∑do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btAcao 
     LABEL "&Gerar" 
     SIZE 10 BY 1.

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

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 87.43 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE fi-arq-htm AS CHARACTER FORMAT "X(55)":U 
     LABEL "Arquivo HTML" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE fi-email AS CHARACTER FORMAT "X(200)":U 
     LABEL "E-Mail" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE fi-num-pedido AS INTEGER FORMAT ">>>>>,>>9" INITIAL 0 
     LABEL "Pedido":R8 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda" NO-TAB-STOP 
     btAcao AT ROW 16.25 COL 3.57
     rtToolBar AT ROW 16 COL 1.72
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     fi-num-pedido AT ROW 1.25 COL 15 COLON-ALIGNED HELP
          "N∑mero do Pedido de Compra"
     fi-email AT ROW 2.25 COL 15 COLON-ALIGNED
     fi-arq-htm AT ROW 3.25 COL 15 COLON-ALIGNED
     btFile AT ROW 3.25 COL 67 HELP
          "Escolha do nome do arquivo"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1.

DEFINE FRAME fPage2
     fi-num-pedido AT ROW 1.25 COL 15 COLON-ALIGNED HELP
          "N∑mero do Pedido de Compra"
          LABEL "Pedido":R8 FORMAT ">>>>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1
         TITLE "Altera o Tipo de Compra do Pedido para ServiÁo".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttalt-ped T "?" NO-UNDO mgmov alt-ped
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttcotacao-item T "?" NO-UNDO mgmov cotacao-item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttordem-compra T "?" NO-UNDO mgmov ordem-compra
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttpedido-compr T "?" NO-UNDO mgmov pedido-compr
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
          FIELD RowNum AS INTEGER INIT 1
          INDEX iSeq AS PRIMARY RowNum
          
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
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

{esp/es0006a.i}
{esp/es0006.i}
{esp/eslib.i}
{esp/ShowMsg.i}
{window/window.i}
{btb/btb008za.i0}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
ASSIGN 
       btAcao:PRIVATE-DATA IN FRAME fpage0     = 
                "&Gerar,&Alterar".

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FRAME fPage2
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

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
     _Options          = "SHARE-LOCK KEEP-EMPTY"
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


&Scoped-define SELF-NAME btAcao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAcao wWindow
ON CHOOSE OF btAcao IN FRAME fpage0 /* Gerar */
DO:
    FIND FIRST pedido-compr NO-LOCK
        WHERE pedido-compr.num-pedido = INT(wh-num-pedido:SCREEN-VALUE) NO-ERROR.
    IF NOT AVAIL pedido-compr THEN DO:
        RUN ShowMessage (1, "Pedido de compra n∆o cadastrado", "").
        run setFolder IN hFolder (input i-page).
        APPLY "entry" TO wh-num-pedido.
        RETURN NO-APPLY.
    END.
    APPLY "leave" TO fi-arq-htm IN FRAME fpage1.
    IF i-page = 1 THEN DO:
        IF INPUT FRAME fpage1 fi-email = "" THEN DO:
            RUN ShowMessage (1, "Endere˛o de E-Mail n∆o informado", "").
            run setFolder IN hFolder (input i-page).
            APPLY "entry" TO fi-email IN FRAME fpage1.
            RETURN NO-APPLY.
        END.
        IF INPUT FRAME fpage1 fi-arq-htm = "" THEN DO:
            RUN ShowMessage (1, "Arquivo HTML n∆o informado", "").
            run setFolder IN hFolder (input i-page).
            APPLY "entry" TO fi-arq-htm IN FRAME fpage1.
            RETURN NO-APPLY.
        END.
        IF NOT CAN-FIND(FIRST usuar-mater NO-LOCK
            where usuar-mater.cod-usuario = pedido-compr.responsavel 
            and   usuar-mater.usuar-comprador) THEN DO:
            RUN ShowMessage (1, "Responsﬂvel do pedido n∆o informado", 
                             "O responsﬂvel pelo peddio de compra n∆o foi informado. Por favor atualizar").
            run setFolder IN hFolder (input i-page).
            APPLY "entry" TO wh-num-pedido.
            RETURN NO-APPLY.
        END.
        ASSIGN INPUT FRAME fpage1 fi-arq-htm fi-email fi-num-pedido.
        RUN piGera.
    END.
    ELSE RUN piAtualizaOrdens.
  
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wWindow
ON CHOOSE OF btFile IN FRAME fPage1
DO:
    SYSTEM-DIALOG GET-FILE fi-arq-htm
      FILTERS "HTML(*.htm*)" "*.htm*",
              "Todos os arquivos(*.*)" "*.*"
      INITIAL-FILTER 1
      ASK-OVERWRITE 
      DEFAULT-EXTENSION "html"
      SAVE-AS
      UPDATE l-ok.

    IF l-ok THEN DISP fi-arq-htm WITH FRAME fpage1.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fi-arq-htm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-arq-htm wWindow
ON LEAVE OF fi-arq-htm IN FRAME fPage1 /* Arquivo HTML */
DO:
    IF R-INDEX(INPUT fi-arq-htm, ".htm") = 0
    AND R-INDEX(INPUT fi-arq-htm, ".html") = 0 THEN 
        DISP INPUT fi-arq-htm + ".html" @ fi-arq-htm WITH FRAME fpage1.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-email
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-email wWindow
ON ENTRY OF fi-email IN FRAME fPage1 /* E-Mail */
DO:
    FIND FIRST pedido-compr NO-LOCK
        WHERE  pedido-compr.num-pedido = INPUT FRAME fpage1 fi-num-pedido NO-ERROR.
    IF  NOT AVAIL pedido-compr THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 2,
                           INPUT "Pedido Compra" + "~~" + "Pedido nro. " + TRIM(INPUT FRAME fpage1 fi-num-pedido)).
        APPLY 'ENTRY':U TO fi-num-pedido IN FRAME fPage1.
        RETURN NO-APPLY.
    END. /* IF NOT AVAIL ... */  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-num-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-pedido wWindow
ON F5 OF fi-num-pedido IN FRAME fPage1 /* Pedido */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in295"
                       &campo="fi-num-pedido"
                       &campozoom="num-pedido"
                       &frame="fPage1"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-pedido wWindow
ON LEAVE OF fi-num-pedido IN FRAME fPage1 /* Pedido */
DO:
       FIND FIRST pedido-compr NO-LOCK
           WHERE pedido-compr.num-pedido = INPUT FRAME fpage1 fi-num-pedido NO-ERROR.
       IF  AVAIL pedido-compr THEN DO:

           fi-email = "".
           FOR EACH  int-cont-emit NO-LOCK
               WHERE int-cont-emit.cod-emitente = pedido-compr.cod-emitente
                 AND int-cont-emit.log-recebe-po,
               FIRST cont-emit FIELDS (e-mail) NO-LOCK
               WHERE cont-emit.cod-emitente = int-cont-emit.cod-emitente
               AND   cont-emit.sequencia    = int-cont-emit.sequencia:

               IF  fi-email = "" THEN
                   ASSIGN fi-email = cont-emit.e-mail.
               ELSE 
                   ASSIGN fi-email = fi-email + "," + cont-emit.e-mail.

           END. /* FOR FIRST int-cont-emit NO-LOCK */
           FOR FIRST usuar-mater NO-LOCK
               where usuar-mater.cod-usuario = pedido-compr.responsavel 
               and   usuar-mater.usuar-comprador:
               assign fi-email = fi-email + "," + usuar-mater.e-mail.
           END. /* FOR FIRST usuar-mater NO-LOCK */

           DISP fi-email WITH FRAME fpage1.

       END. /* IF  AVAIL pedido-compr THEN DO: */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-pedido wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-num-pedido IN FRAME fPage1 /* Pedido */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME fi-num-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-pedido wWindow
ON F5 OF fi-num-pedido IN FRAME fPage2 /* Pedido */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in295"
                       &campo="fi-num-pedido"
                       &campozoom="num-pedido"
                       &frame="fPage2"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-pedido wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-num-pedido IN FRAME fPage2 /* Pedido */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- Lægica para inicializaá∆o do programam ---*/
DEF TEMP-TABLE RowErrors2 LIKE RowErrors.
fi-num-pedido:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
fi-num-pedido:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.

{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterchangePage wWindow 
PROCEDURE AfterchangePage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN getCurrentFolder IN hFolder (OUTPUT i-page).
  ASSIGN btAcao:LABEL IN FRAME fpage0 = ENTRY(i-page, btAcao:PRIVATE-DATA IN FRAME fpage0).
  
  IF i-page = 1 THEN
      wh-num-pedido = fi-num-pedido:HANDLE IN FRAME fpage1.
  ELSE
      wh-num-pedido = fi-num-pedido:HANDLE IN FRAME fpage2.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterdestroyInterface wWindow 
PROCEDURE AfterdestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*--- Destræi os Servidores RPC inicializados pelos DBOs ---*/
    {btb/btb008za.i3}
        
    /*Alteracao para deletar da memæria o WindowStyles e o btb008za.p*/
    IF VALID-HANDLE(h-servid-rpc) THEN
    DO:
       DELETE PROCEDURE h-servid-rpc.
       ASSIGN h-servid-rpc = ?. /*Garantir que a variﬂvel n∆o vai mais apontar para nenhum handle de outro objeto - este problema apareceu na v9.1B com Windows2000*/
    END.

    IF VALID-HANDLE(hWindowStyles) THEN
        DELETE PROCEDURE hWindowStyles.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterinitializeInterface wWindow 
PROCEDURE AfterinitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DISABLE {&List-1} WITH FRAME fPage1.
    
    FOR FIRST param-global NO-LOCK: END.
    FOR first param-compra no-lock: END.
    
    FOR FIRST usuar_mestre FIELDS (cod_e_mail_local)
        WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK:
        c-remetente = usuar_mestre.cod_e_mail_local .
    END.    
    
    RUN initializeDBOs.
    
    ASSIGN fi-arq-htm:SCREEN-VALUE IN FRAME fpage1 = SESSION:TEMP-DIRECTORY + "ped"
           c-tam-tab                               = "700".
           
    return "OK".
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforedestroyInterface wWindow 
PROCEDURE BeforedestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        &IF "{&hDBOTable}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable}) THEN
                RUN destroy IN {&hDBOTable}.
        &ENDIF

        &IF "{&hDBOTable2}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable2}) THEN
                RUN destroy IN {&hDBOTable2}.
        &ENDIF

        &IF "{&hDBOTable3}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable3}) THEN
                RUN destroy IN {&hDBOTable3}.
        &ENDIF

        &IF "{&hDBOTable4}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable4}) THEN
                RUN destroy IN {&hDBOTable4}.
        &ENDIF

        &IF "{&hDBOTable5}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable5}) THEN
                RUN destroy IN {&hDBOTable5}.
        &ENDIF
        
        &IF "{&hDBOTable6}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable6}) THEN
                RUN destroy IN {&hDBOTable6}.
        &ENDIF

        &IF "{&hDBOTable7}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable7}) THEN
                RUN destroy IN {&hDBOTable7}.
        &ENDIF

        &IF "{&hDBOTable8}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable8}) THEN
                RUN destroy IN {&hDBOTable8}.
        &ENDIF

        &IF "{&hDBOTable9}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable9}) THEN
                RUN destroy IN {&hDBOTable9}.
        &ENDIF
        
        &IF "{&hDBOTable10}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable10}) THEN
                RUN destroy IN {&hDBOTable10}.
        &ENDIF


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "inbo/boin295.r":U THEN DO:
        {btb/btb008za.i1 inbo/boin295.r YES}
        {btb/btb008za.i2 inbo/boin295.r '' {&hDBOTable}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable} ("Main") NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE({&hDBOTable2}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "inbo/boin274.r":U THEN DO:
        {btb/btb008za.i1 inbo/boin274.r YES}
        {btb/btb008za.i2 inbo/boin274.r '' {&hDBOTable2}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable2} ("Main") NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable2} (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE({&hDBOTable3}) OR
       {&hDBOTable3}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable3}:FILE-NAME <> "inbo/boin082.r":U THEN DO:
        {btb/btb008za.i1 inbo/boin082.r YES}
        {btb/btb008za.i2 inbo/boin082.r '' {&hDBOTable3}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable3} ("Main") NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable3} (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE({&hDBOTable4}) OR
       {&hDBOTable4}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable4}:FILE-NAME <> "inbo/boin011.r":U THEN DO:
        {btb/btb008za.i1 inbo/boin011.r YES}
        {btb/btb008za.i2 inbo/boin011.r '' {&hDBOTable4}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable4} ("Main") NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable4} (INPUT "Main":U) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-pedido wWindow 
PROCEDURE pi-atualiza-pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var de-cotacao as dec format ">>9.9999" NO-UNDO.
    def var i-num-casa-dec as DEC NO-UNDO.
    def var de-fator-conver as DEC NO-UNDO.
    def buffer b-prazo-compra for prazo-compra.

   find tb-pr-cc where tb-pr-cc.nr-tab = cotacao-item.nr-tab
        and tb-pr-cc.cod-emitente = emitente.cod-emitente 
        and tb-pr-cc.cod-cond-pag = pedido-compr.cod-cond-pag no-lock 
        no-error.
   if not avail tb-pr-cc then do:
       RUN ShowMessage (1, "N∆o foi encontrada tabela de preáos para atualizaá∆o", "").
       RETURN "NOK".
   end.
   
   /*find mgesp.int-tb-pr-cc of tb-pr-cc no-lock no-error.
   if avail int-tb-pr-cc then    
       assign de-cotacao = int-tb-pr-cc.valor-dolar.
   ELSE RUN ShowMessage (2, "N∆o foi encontrado valor do Dolar negociado", "").*/
      
   if de-cotacao = 0 then
      assign de-cotacao = 1.

   EMPTY TEMP-TABLE ttordem-compra.
   CREATE ttordem-compra.
   EMPTY TEMP-TABLE ttcotacao-item.
   CREATE ttcotacao-item.
   
   for each ordem-compra NO-LOCK
       where ordem-compra.cod-emitente = emitente.cod-emitente
         and ordem-compra.num-pedido = fi-num-pedido
         and ordem-compra.situacao = 2,
         each prazo-compra no-lock
        where prazo-compra.numero-ordem = ordem-compra.numero-ordem
          and prazo-compra.quant-saldo > 0,
         each item-tab of tb-pr-cc no-lock
        where item-tab.it-codigo = ordem-compra.it-codigo:
          find first b-prazo-compra
               where b-prazo-compra.numero-ordem = ordem-compra.numero-ordem
                 and b-prazo-compra.parcela > 1 no-lock no-error.
                 
          if avail b-prazo-compra then do:
              RUN ShowMessage (1, SUBSTITUTE("A ordem &1 do pedido &2 tem mais de uma parcela", 
                                             trim(STRING(ordem-compra.numero-ordem)),
                                             TRIM(STRING(ordem-compra.num-pedido))),
                                             "A ordem n∆o ser† alterada").
              next.          
          end.
/*          disp ordem-compra.numero-ordem
               prazo-compra.parcela
               ordem-compra.preco-unit
               ordem-compra.pre-unit-for
               ordem-compra.preco-fornec 
               . */
      
        FIND FIRST ttordem-compra NO-ERROR.
        ttordem-compra.r-rowid = ROWID(ordem-compra).

        
        find cotacao-item NO-LOCK
             where cotacao-item.numero-ordem = ordem-compra.numero-ordem
               and cotacao-item.cod-emitente = ordem-compra.cod-emitente
               and cotacao-item.cot-aprovada.
/*               disp cotacao-item.preco-unit
                    cotacao-item.pre-unit-for
                    cotacao-item.preco-fornec. */

        FIND FIRST ttcotacao-item NO-ERROR.
        ttcotacao-item.r-rowid = ROWID(cotacao-item).

        FIND FIRST item-fornec-estab NO-LOCK
             WHERE item-fornec-estab.it-codigo    = ordem-compra.it-codigo
               AND item-fornec-estab.cod-emitente = ordem-compra.cod-emitente
               AND item-fornec-estab.cod-estabel  = ordem-compra.cod-estabel NO-ERROR.

        find item-fornec
             where item-fornec.it-codigo = item-tab.it-codigo
               and item-fornec.cod-emitente = tb-pr-cc.cod-emitente no-lock.

        IF AVAIL item-fornec-estab THEN
            assign i-num-casa-dec = exp(10,item-fornec-estab.num-casa-dec).
        ELSE IF AVAIL item-fornec THEN 
            assign i-num-casa-dec = exp(10,item-fornec.num-casa-dec).
        
                    
        IF AVAIL item-fornec-estab THEN
            assign de-fator-conver = item-fornec-estab.fator-conver / i-num-casa-dec.
        ELSE IF AVAIL item-fornec THEN 
            assign de-fator-conver = item-fornec.fator-conver / i-num-casa-dec.
        

/*        disp item-tab.pr-item * de-fator-conver format ">>9.9999".       */

   
        assign ttordem-compra.mo-codigo  = 0
               ttordem-compra.preco-unit = (item-tab.pr-item +
                                         (item-tab.pr-item                                         * (tb-pr-cc.valor-taxa / 100)))
                                         * 
                                         de-fator-conver * 
                                         de-cotacao
               + if not tb-pr-cc.codigo-ipi then 
               (( (item-tab.pr-item +
                   (item-tab.pr-item                                                            * (tb-pr-cc.valor-taxa / 100)))
               * de-fator-conver * de-cotacao) * item-tab.aliquota-ipi / 100)
               else 0 
               ttcotacao-item.mo-codigo = 0
               ttcotacao-item.preco-unit = (item-tab.pr-item +
                                         (item-tab.pr-item                                                              * (tb-pr-cc.valor-taxa / 100)))
                                         * 
                                         de-fator-conver * 
                                         de-cotacao
               + if not tb-pr-cc.codigo-ipi then 
               ((( item-tab.pr-item +
                        (item-tab.pr-item * (tb-pr-cc.valor-taxa / 100)))
               
               * de-fator-conver * de-cotacao) * item-tab.aliquota-ipi / 100)
               else 0 
               ttordem-compra.pre-unit-for = (item-tab.pr-item +
                           (item-tab.pr-item *  (tb-pr-cc.valor-taxa / 100)))
               * de-cotacao
               + if not tb-pr-cc.codigo-ipi then 
               ((( item-tab.pr-item +
                    (item-tab.pr-item                                                              * (tb-pr-cc.valor-taxa / 100)))
               
               * de-cotacao) * item-tab.aliquota-ipi / 100)
               else 0 
               ttordem-compra.preco-fornec = (item-tab.pr-item +
               (item-tab.pr-item * 
               (tb-pr-cc.valor-taxa / 100)))
               
               * de-cotacao
               ttcotacao-item.pre-unit-for = (item-tab.pr-item +
               (item-tab.pr-item *  (tb-pr-cc.valor-taxa / 100)))
               * de-cotacao 
               + if not tb-pr-cc.codigo-ipi then 
               (((item-tab.pr-item +
                (item-tab.pr-item * (tb-pr-cc.valor-t~axa / 100)))
               
               * de-cotacao) * item-tab.aliquota-ipi / 100)
               else 0 
               ttcotacao-item.preco-fornec = (item-tab.pr-item +
               (item-tab.pr-item  * (tb-pr-cc.valor-t~axa / 100)))
               
               * de-cotacao
               ttordem-compra.aliquota-icm = item-tab.aliquota-icm
               ttcotacao-item.aliquota-icm = item-tab.aliquota-icm
               ttordem-compra.aliquota-ipi = item-tab.aliquota-ipi
               ttcotacao-item.aliquota-ipi = item-tab.aliquota-ipi.
               
             EMPTY TEMP-TABLE ttalt-ped.
             create ttalt-ped.
             assign ttalt-ped.num-pedido = ordem-compra.num-pedido
                    ttalt-ped.numero-ordem = ordem-compra.numero-ordem
                    ttalt-ped.parcela = prazo-compra.parcela
                    ttalt-ped.data = today
                    ttalt-ped.preco =  (item-tab.pr-item +
                                         (item-tab.pr-item                                           * (tb-pr-cc.valor-taxa / 100)))
                                         * 
                                         de-fator-conver * 
                                         de-cotacao
               + if not tb-pr-cc.codigo-ipi then 
               (( (item-tab.pr-item +
                   (item-tab.pr-item * (tb-pr-cc.valor-taxa / 100)))
               * de-fator-conver * de-cotacao) * item-tab.aliquota-ipi / 100)
               else 0 

                    ttalt-ped.hora = string(time,"hh:mm:ss")
                    ttalt-ped.usuario = c-seg-usuario
                    ttalt-ped.data-entrega = prazo-compra.data-entrega
                    ttalt-ped.observacao = "Atualizaá∆o de tabela de preáos"
                    ttalt-ped.quantidade = prazo-compra.quantidade
                    ttalt-ped.cod-cond-pag = ?. 

         EMPTY TEMP-TABLE RowErrors2.
         FOR FIRST ITEM FIELDS () NO-LOCK
             WHERE ITEM.it-codigo = ttordem-compra.it-codigo:
         END.
         fn-atualza-ordem().
         FOR EACH RowErrors:
             CREATE RowErrors2.
             BUFFER-COPY RowErrors TO RowErrors2.
         END.
         fn-atualiza-cotacao().
         FOR EACH RowErrors:
             CREATE RowErrors2.
             BUFFER-COPY RowErrors TO RowErrors2.
         END.
         fn-cria-altped().
         FOR EACH RowErrors:
             CREATE RowErrors2.
             BUFFER-COPY RowErrors TO RowErrors2.
         END.

         IF CAN-FIND(FIRST RowErrors2) THEN DO:
             EMPTY TEMP-TABLE RowErrors.
             FOR EACH RowErrors2:
                 CREATE RowErrors.
                 BUFFER-COPY RowErrors2 TO RowErrors.
             END.
             {method/ShowMessage.i1}.
             {method/ShowMessage.i2 &Modal="YES"}.
             {method/ShowMessage.i3}.
             UNDO, RETURN "NOK".
         END.
         
         ELSE RUN ShowMessage (2, SUBSTITUTE("Foi alterada a ordem &1 do pedido &2", 
                                              trim(STRING(ordem-compra.numero-ordem)),
                                              TRIM(STRING(ordem-compra.num-pedido))),
                                               "").
               
   end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-ordens wWindow 
PROCEDURE pi-cria-tt-ordens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    create tt-ordens.
    assign tt-ordens.oc = string(ordem-compra.numero-ordem)
           tt-ordens.it-codigo     = (if prazo-compra.it-codigo = "" then 
                                         "&nbsp;"
                                      else
                                         prazo-compra.it-codigo)
           tt-ordens.un            = (IF AVAIL item-fornec-estab THEN item-fornec-estab.un ELSE (if avail item-fornec then item-fornec.un else item.un))
           tt-ordens.al-ipi        = string(ordem-compra.aliquota-ipi,">>9.99")
           tt-ordens.qtd 
                 = string(round(prazo-compra.qtd-sal-forn, 2),">>,>>>,>>9.99")
           tt-ordens.preco-unit = string(de-preco-conv, ">>,>>>,>>9.9999")
           tt-ordens.preco-tot  = string(de-preco-total,">>>,>>>,>>9.99").
           /*
           tt-ordens.preco-tot  = string(round((de-preco-conv 
                            * prazo-compra.qtd-sal-forn),2), ">>>,>>>,>>9.99").
            */
           .
                             
       IF  item.tipo-contr = 4 /*DÇbito Direto*/ 
       AND AVAIL cotacao-item THEN DO:
           ASSIGN tt-ordens.classif = TRIM(REPLACE(SUBSTRING(cotacao-item.char-1, 81, 20), ".":U, "":U)).
       END.
       ELSE DO:
           ASSIGN tt-ordens.classif = item.class-fiscal.
       END.

       IF  AVAIL cotacao-item THEN DO:
           FIND FIRST moeda NO-LOCK
               WHERE  moeda.mo-codigo = cotacao-item.mo-codigo NO-ERROR.
           IF  AVAIL moeda
           THEN ASSIGN tt-ordens.desc-moeda = moeda.descricao.
           ELSE ASSIGN tt-ordens.desc-moeda = "".
       END. /* IF AVAIL cotacao-item THEN DO: */

       assign c-data = string((prazo-compra.data-entrega), "99/99/9999")
              tt-ordens.dt-embarque = "<TD ALIGN="
                                    + chr(34)
                                    + "center"
                                    + chr(34)
                                    + "><FONT COLOR=#4066E1 SIZE=2><I><B>"
                                    + substring(c-data,1,2) 
                                    + "/" 
                                    + substring(c-data,4,2)
                                    + substring(c-data,6,5)
                                    + "</B></I></FONT></TD>".
    
    /* part number */

    if avail item-fornec-estab then do:
         FIND FIRST int-item-for-PN NO-LOCK
            WHERE int-item-for-PN.cod-emitente = item-fornec-estab.cod-emitente
              AND int-item-for-PN.it-codigo    = item-fornec-estab.it-codigo NO-ERROR.

        IF  AVAIL int-item-for-PN AND int-item-for-PN.item-do-forn <> "" then do:
            find mgesp.item-fabric
                 where string(item-fabric.cod-fabric) = int-item-for-PN.item-do-forn 
                   and item-fabric.it-codigo = item-fornec-estab.it-codigo no-lock no-error.
            if avail item-fabric then do:
                find mgesp.fabricante 
                     where fabricante.cod-fabric = item-fabric.cod-fabric no-lock.
                assign tt-ordens.pn = fabricante.nome-abrev + "-" + 
                                      item-fabric.it-fabric.
            end.
        end.
    end.
    ELSE if avail item-fornec then do:
         
        FIND FIRST int-item-for-PN NO-LOCK
            WHERE int-item-for-PN.cod-emitente = item-fornec.cod-emitente
              AND int-item-for-PN.it-codigo    = item-fornec.it-codigo NO-ERROR.
        
        if  AVAIL int-item-for-PN AND int-item-for-PN.item-do-forn <> "" then do:
            find mgesp.item-fabric
                 where string(item-fabric.cod-fabric) = int-item-for-PN.item-do-forn 
                   and item-fabric.it-codigo = item-fornec.it-codigo no-lock no-error.
            if avail item-fabric then do:
                find mgesp.fabricante 
                     where fabricante.cod-fabric = item-fabric.cod-fabric no-lock.
                assign tt-ordens.pn = fabricante.nome-abrev + "-" + 
                                      item-fabric.it-fabric.
            end.
        end.
    end.
    
                                           
    if ordem-compra.narrativa <> "" then do:
             assign tt-ordens.descricao = tt-ordens.descricao
                                        + trim(ordem-compra.narrativa) +
                                        "<BR>".
    end.
    else if avail item-fornec-estab and item-fornec-estab.narrativa <> "" and item.it-codigo <> "" 
         THEN assign tt-ordens.descricao = tt-ordens.descricao + trim(item-fornec-estab.narrativa) + "<BR>".
         else if avail item-fornec and item-fornec.narrativa <> "" and item.it-codigo <> "" 
              THEN assign tt-ordens.descricao = tt-ordens.descricao + trim(item-fornec.narrativa) + "<BR>".
              else DO:
                   /*rotina para buscar narrativa do estabelecimento*/
                   RUN esp/es0205.p(INPUT ordem-compra.cod-estabel, INPUT ordem-compra.it-codigo, OUTPUT c-narrativa).
            
                   assign tt-ordens.descricao    = c-narrativa + " - P/N - " + item.it-codigo + "<BR>".
              END.

    assign tt-ordens.descricao = "<TD ALIGN=" + chr(34) + "left" + chr(34) + ">"
                               + tt-ordens.descricao + tt-ordens.pn  
                               + "</TD>".

       assign tt-ordens.situacao = "<TD ALIGN="
                                 + chr(34)
                                 + "center"
                                 + chr(34)
                                 + "><FONT COLOR=#"
                                 + (if prazo-compra.situacao = 6 then
                                       "000000><B>Recebida</B>"
                                    else if prazo-compra.situacao = 4 then
                                        "E63333><B>Cancelada</B>"
                                    else 
                                        "238E68><B>Previsao</B>")
                                 + "</FONT></TD>"
              tt-ordens.nr-conhecimento = "&nbsp;" 
              c-incoterm  = if c-incoterm <> "&nbsp;" and c-incoterm <> "" then
                               c-incoterm
                            else
                               "&nbsp;"
              c-via-trans = if c-via-trans[pedido-compr.via-transp] <> "&nbsp;"                             and c-via-trans[pedido-compr.via-transp] <> ""
                            then c-via-trans[pedido-compr.via-transp]
                            else "&nbsp;".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaOrdens wWindow 
PROCEDURE piAtualizaOrdens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN INPUT FRAME fpage2 fi-num-pedido.

    for each ordem-compra EXCLUSIVE-LOCK
        where ordem-compra.num-pedido = fi-num-pedido:
        assign ordem-compra.natureza = 2.
    end.    
    RUN ShowMessage (2, "Ordens atualizadas com sucesso", "").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGera wWindow 
PROCEDURE piGera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var c-agente           as char no-undo.
def var c-embarque         as char no-undo.
def var c-desembarque      as char no-undo.
def var de-total-compras   as dec  no-undo.
def var c-mess-err         as char no-undo.
def var c-nr-pedido        as char format "x(100)" no-undo.
def var c-tit-ped          as char format "x(100)" no-undo.
def var c-dados-empresa    as char format "x(300)" no-undo.
def var c-dados-fornecedor as char format "x(300)" no-undo.
def var c-imagem           as char format "x(100)" no-undo.
def var c-complementos     as char format "x(300)" no-undo.
def var c-mensagem1        as char format "x(500)" no-undo.
def var c-comentario1      as char format "x(500)" no-undo.
def var c-titulo           as char no-undo.           
def var de-total-geral     as dec  no-undo.
def var de-total-sipi      as dec  no-undo.
def var de-preco-sipi      as dec  no-undo.
def var de-ipi             as dec  no-undo.
def var de-preco-tot-aux   like de-preco-total NO-UNDO.
def var de-desc-total      like de-preco-total NO-UNDO.
def var de-enc             as DEC NO-UNDO.
def var de-enc-total       like ordem-compra.preco-unit NO-UNDO.
DEF VAR c-descricao        AS CHAR FORMAT "x(80)" no-undo.
DEF VAR ind AS INT NO-UNDO.

    find emitente no-lock
         where emitente.cod-emitente = pedido-compr.cod-emitente NO-ERROR.
    find transporte no-lock
         where  transporte.cod-transp = pedido-compr.cod-transp NO-ERROR.
    find first ordem-compra no-lock
         where ordem-compra.num-pedido = pedido-compr.num-pedido NO-ERROR.
    find first cotacao-item no-lock
         where cotacao-item.numero-ordem = ordem-compra.numero-ordem                
         and cotacao-item.cot-aprovada NO-ERROR.
    if AVAIL cotacao-item AND cotacao-item.mo-codigo <> 0 and emitente.natureza <> 3 then do:
        STATUS DEFAULT "Pedido em Dolar para fornecedor nacional. Atualizando, aguarde...".
        run pi-atualiza-pedido.
        STATUS DEFAULT.
    end.

    find estabelec where
         estabelec.cod-estabel = pedido-compr.cod-estabel no-lock no-error.

    EMPTY TEMP-TABLE tt-ordens.
    output to value(fi-arq-htm) CONVERT TARGET SESSION:CHARSET.

    run html-inicio("Pedido de Compra").

    find emitente where emitente.cod-emitente 
                      = pedido-compr.cod-emitente
                  no-lock no-error.

    ASSIGN c-descricao = "".
    find cond-pagto where cond-pagto.cod-cond-pag 
                        = pedido-compr.cod-cond-pag
                     no-lock no-error.

    IF NOT AVAIL cond-pagto OR pedido-compr.cod-cond-pag = 0 THEN DO:
        FIND FIRST cond-especif OF pedido-compr NO-LOCK NO-ERROR.
        DO ind = 1 TO 12:
            IF cond-especif.perc-pagto[ind] <> 0 THEN
                ASSIGN c-descricao = c-descricao + cond-especif.comentarios[ind] + " ".
        END.
    END.
    ELSE
        ASSIGN c-descricao = cond-pagto.descricao.

    find comprador where comprador.cod-comprado 
                       = pedido-compr.responsavel
                   no-lock no-error.
    for each ordem-compra where ordem-compra.num-pedido 
                              = pedido-compr.num-pedido
                          no-lock,
        each prazo-compra where prazo-compra.numero-ordem
                              = ordem-compra.numero-ordem
                          no-lock:

        find item where item.it-codigo = prazo-compra.it-codigo
                  no-lock no-error.

        FIND FIRST item-fornec-estab NO-LOCK
             WHERE item-fornec-estab.it-codigo    = ordem-compra.it-codigo
               AND item-fornec-estab.cod-emitente = ordem-compra.cod-emitente
               AND item-fornec-estab.cod-estabel  = ordem-compra.cod-estabel NO-ERROR.

        find item-fornec where item-fornec.it-codigo
                             = ordem-compra.it-codigo
                           and item-fornec.cod-emite
                             = ordem-compra.cod-emite
                         no-lock no-error.
        find narrativa where narrativa.it-codigo 
                           = ordem-compra.it-codigo
                       no-lock no-error.

/* -----------------------  CALCULO PRECO UNITARIO  ------------------------- */
            if  ordem-compra.mo-codigo > 0 then do:
                IF  emitente.natureza >= 3 THEN DO:
                    run cdp/cd0812.p (input ordem-compra.mo-codigo,
                                     input 0,
                                     input ordem-compra.preco-fornec,
                                     input pedido-compr.data-pedido,
                                     output de-preco-conv).
                   if   de-preco-conv = ?
                   then de-preco-conv = ordem-compra.preco-fornec.
                END.
                ELSE de-preco-conv = ordem-compra.preco-fornec.
            end.
            else de-preco-conv = ordem-compra.preco-fornec.
/* -----------------------  CALCULO DE VALORES  ----------------------------- */
                assign de-preco-tot-aux = de-preco-conv *
                                          prazo-compra.qtd-sal-forn.

                assign de-desc-total = 0
                       de-enc        = 0
                       de-ipi        = 0.

                if param-compra.log-1 = no then do:
                   /* ------ CALCULO I.P.I. SOBRE PRECO LIQUIDO ------ */
                   if ordem-compra.perc-descto > 0 then
                      assign de-desc-total = de-preco-tot-aux *
                                             ordem-compra.perc-descto / 100.

                   if ordem-compra.taxa-financ = no then do:
                      assign de-enc = de-preco-tot-aux - de-desc-total.

                      run ccp/cc9020.p (input  yes,
                                        input  ordem-compra.cod-cond-pag,
                                        input  ordem-compra.valor-taxa,
                                        input  ordem-compra.nr-dias-taxa,
                                        input  de-enc,
                                        output de-enc-total).
                      assign de-enc = round(de-enc-total - de-enc,1).
                   end.
                   else assign de-enc-total = de-preco-tot-aux
                                            - de-desc-total.

                   if ordem-compra.aliquota-ipi > 0
                   then assign de-ipi = de-enc-total *
                                        ordem-compra.aliquota-ipi / 100.
                end.
                else do:
                     /* ------ CALCULO I.P.I. SOBRE PRECO BRUTO ------ */
                     if ordem-compra.taxa-financ = no then do:
                        run ccp/cc9020.p (input  yes,
                                          input  ordem-compra.cod-cond-pag,
                                          input  ordem-compra.valor-taxa,
                                          input  ordem-compra.nr-dias-taxa,
                                          input  de-preco-tot-aux,
                                          output de-enc-total).

                        assign de-enc = round(de-enc-total
                                            - de-preco-tot-aux,1).
                     end.
                     else assign de-enc-total = de-preco-tot-aux.

                     if ordem-compra.aliquota-ipi > 0
                     then assign de-ipi = de-enc-total *
                                          ordem-compra.aliquota-ipi / 100.

                     if ordem-compra.perc-descto > 0
                     then assign de-desc-total = (de-enc-total + de-ipi)
                                               * ordem-compra.perc-descto
                                               / 100.
                end.

                assign de-preco-total = de-preco-tot-aux
                                      + de-enc
                                     + (if ordem-compra.codigo-ipi = no then
                                           de-ipi
                                        else 0)
                                      - de-desc-total
                       de-preco-sipi  = de-preco-tot-aux
                                      + de-enc
                                      - de-desc-total
                       de-total-sipi  = de-total-sipi  + de-preco-sipi
                       de-total-geral = de-total-geral
                                      + de-preco-total.

        assign c-desembarque = "SAO JOSE/SANTA CATARINA/BRAZIL".

        if ordem-compra.natureza = 2 then do:
           run pi-cria-tt-ordens.
           next.
        end.
        find first cotacao-item where cotacao-item.numero-ordem 
                                    = ordem-compra.numero-ordem
                                  and cotacao-item.cod-emitente
                                    = ordem-compra.cod-emitente
                                no-lock no-error.
        if not avail cotacao-item then next.
        run pi-cria-tt-ordens.
    end.

    assign c-data      = string(day(pedido-compr.data-pedido),"99") 
                       + "/"
                       + string(month(pedido-compr.data-pedido),"99")
                       + "/"
                       + string(year(pedido-compr.data-pedido), "9999")
           c-nr-pedido = "<TH> <FONT FACE="
                       + chr(34)
                       + "Times New Roman"
                       + chr(34)
                       + " SIZE=3> Nr.: "
                       + string(pedido-compr.num-pedido, ">>>,>>9")
                       + " - "
                       + c-data
                       + "</FONT> </TH>"
           c-dados-empresa = "<B>" + estabelec.nome + "</B><BR>"
                           + estabelec.endereco + "<BR>"
                           + estabelec.bairro + ", CEP " + trim(string(estabelec.cep)) + "<BR>" 
                           + estabelec.cidade + "," + estabelec.estado + "<BR>"
                           + trim(string("")) + "<BR>"
                           + trim(string("")) + "<BR>"
                           + trim(string(estabelec.cgc)) + "<BR>"
                           + trim(string(estabelec.ins-estadual)) + "<BR>"
                           + "Comprador: "
                           + usuar-mater.nome
                           + "<BR>E-mail: "
                           + usuar-mater.e-mail
                           + "<BR>Fone: "
                           + usuar-mater.telefone[1]
           c-dados-fornecedor = "<B>Fornecedor:</B><BR>"
                              + emitente.nome-emit
                              + " - " 
                              + string(emitente.cod-emitente)
                              + "<BR>"
                              + emitente.endereco
                              + "                    "
                              + emitente.bairro
                              + "<BR>"
                              + emitente.cidade
                              + " - "
                              + emitente.estado
                              + "<BR>"
                              + "Fone: "
                              + emitente.telefone[1]
                              + "<BR>"
                              + "Fax: "
                              + emitente.telefax.
    assign c-complementos = "Condicao de Pagamento: "
                          + c-descricao 
                          + "<BR>Via de Transporte: "
                          + c-via-trans[pedido-compr.via-transp]
                          + "<BR>Transportador:" 
                          + transporte.nome
           c-mensagem1    = "" 
           c-comentario1  = ""
           c-tit-ped      = "<FONT FACE="
                            + chr(34)
                            + "Times New Roman"
                            + chr(34)
                            + " SIZE=3>Pedido de Compra"
                            + "</FONT>".

    assign c_imagem_usada = SEARCH("image/logo_intelbras.jpg") 
                         c-imagem       = '<TH><img src= ' + c_imagem_usada + ' border="0" ></TH>'.

    find mensagem where
         mensagem.cod-mensagem = pedido-compr.cod-mensagem
         no-lock no-error.

    /*
    if avail mensagem then do:
       assign c-mensagem1 = c-mensagem1 + "<BR><BR>".
       assign c-mensagem1 = c-mensagem1 + mensagem.texto-mensag.        
    end.

    if pedido-compr.comentarios <> " " then do:
       assign c-mensagem1 = c-mensagem1 + "<BR><BR>".
       assign c-mensagem1 = c-mensagem1 + pedido-compr.comentarios.
    end.
    */

    if avail mensagem then do:
       assign c-mensagem1 = c-mensagem1 + REPLACE(REPLACE(mensagem.texto-mensag,chr(13),"<BR>"),CHR(10),"<BR>"). 
    end.
    
    if pedido-compr.comentarios <> " " then do:
       IF c-comentario1 <> "" THEN 
           ASSIGN c-comentario1 = c-comentario1 + "<BR><BR>".

       assign c-comentario1 = c-comentario1 + REPLACE(REPLACE(pedido-compr.comentarios,chr(13),"<BR>"),CHR(10),"<BR>").
       
    end.
    
    run html-ini-tab.
    run html-ini-lin-tab.

    put c-imagem skip.      /* Antes era "run html-cab-tab(c-imagem)" */

    run html-cab-tab(c-tit-ped).

    put c-nr-pedido skip . /*Antes era "run html-cab-tab(c-nr-pedido)."*/

    run html-fim-lin-tab.
    run html-fim-tab.

    run html-ini-tab.
    run html-ini-lin-tab.

    /******** 
      PUT incluido porque rotina original possui "format" em 60 posicoes 
    *********/

    put "<TD ALIGN=" '"'  
      + "center" 
      + '"' ">" trim(c-dados-empresa) format "x(400)" "</TD>"  skip.
/*       
    run html-fim-lin-tab.
    run html-fim-tab.

    run html-ini-tab.
    run html-ini-lin-tab.
  */  
    /******** 
      PUT incluido porque rotina original possui "format" em 60 posicoes 
    *********/

    put " <TD ALIGN=" '"' 
        + "center" 
        + '"' ">"  trim(c-dados-fornecedor) format "x(350)" "</TD>" skip. 

    run html-fim-lin-tab.
    run html-fim-tab.

    run html-ini-tab.
    run html-ini-lin-tab.
    run html-cab-tab("OC/&ltxPed&gt").
    run html-cab-tab("NCM"). 
    run html-cab-tab("Item").
    run html-cab-tab("Descricao").
    run html-cab-tab("UN").
    run html-cab-tab("Qtd").
    run html-cab-tab("Preco Unit").
    run html-cab-tab("Moeda").
    run html-cab-tab("IPI(%)").
    run html-cab-tab("Preco Total").
    run html-cab-tab("Entrega").
    run html-cab-tab("Status").
    run html-fim-lin-tab.

    assign de-total-compras = 0.
    for each tt-ordens by tt-ordens.it-codigo
                       by tt-ordens.oc:

        if tt-ordens.situacao matches "*Cancelada*" 
        and pedido-compr.situacao = 1 then do:
           next.
        end. 

        run html-ini-lin-tab.
        run html-con-tab(tt-ordens.oc,"right").
        run html-con-tab(tt-ordens.classif,"left"). 
        run html-con-tab(tt-ordens.it-codigo,"left").

        put replace(tt-ordens.descricao,"#MANAUS#","") format "x(450)" skip.

        run html-con-tab(tt-ordens.un,"center").
        run html-con-tab(tt-ordens.qtd,"right").
        run html-con-tab(tt-ordens.preco-unit,"right").
        run html-con-tab(tt-ordens.desc-moeda,"CENTER").
        run html-con-tab(tt-ordens.al-ipi,"right").
        run html-con-tab(tt-ordens.preco-tot,"right").
        put tt-ordens.dt-embarque format "x(90)" skip.
        put tt-ordens.situacao    format "x(80)" skip.

        run html-fim-lin-tab.

        if not (tt-ordens.situacao matches "*Cancelada*") then
           assign de-total-compras = de-total-compras
                                   + dec(tt-ordens.preco-tot).
    end.
    run html-fim-tab.

    run html-ini-tab.
    run html-ini-lin-tab.
    run html-con-tab(("Total: " 
                     + string(de-total-compras, ">>>,>>>,>>9.99")),
                     "center").
    run html-fim-lin-tab.
    run html-fim-tab.

    run html-ini-tab.
    run html-ini-lin-tab.

    /******** 
      PUT incluido porque rotina original possui "format" em 60 posicoes 
    *********/

    put "<TD ALIGN=" '"'
      + "left" 
      + '"' ">" trim(c-complementos) format "x(300)" "</TD>" skip.

    run html-fim-lin-tab.
    run html-fim-tab.

    run html-ini-tab.
    run html-ini-lin-tab.

    /******** 
      PUT incluido porque rotina original possui "format" em 60 posicoes 
    *********/

    put "<TD ALIGN=" '"'  
      + "left" 
      + '"' ">" trim(c-comentario1) format "x(10000)" "</TD>" skip.

    run html-fim-lin-tab.
    run html-fim-tab.

    run html-ini-tab.
    run html-ini-lin-tab.

    put "<TD ALIGN=" '"'  
      + "left" 
      + '"' ">" trim(c-mensagem1) format "x(10000)" "</TD>" skip.

    run html-fim-lin-tab.
    run html-fim-tab.

    run html-fim.

    output close.

    STATUS DEFAULT "Enviando E-Mail...".

    assign c-endereco  = fi-email
           c-arquivo   = fi-arq-htm
           c-arquivo-2 = session:TEMP-DIRECTORY + "purchase-order"
           c-titulo = "Pedido Nr. " + string(fi-num-pedido, ">>>,>>9").

    /*
    FIND mgesp.int-emitente OF emitente NO-LOCK NO-ERROR. 

    IF (AVAIL int-emitente AND int-emitente.b2s) and
       estabelec.cod-estabel <> '103' THEN DO:
        ASSIGN c-texto-html[1] = "Acesse http://b2b.intelbras.com.br e verifique o Pedido Nr. " 
                                  + string(fi-num-pedido, ">>>,>>9") + ".".
        assign c-texto-html[2] = "Confirme o recebimento do pedido no site".
        
             RUN enviaMail (INPUT c-remetente,
                   INPUT c-endereco,
                   INPUT trim(c-titulo),
                   INPUT c-texto-html[1] + "~n" + c-texto-html[2],
                   INPUT "").
    END.
    ELSE do: 
    */
    /*
        ASSIGN c-texto-html[1] = "ATENÄ«O !"                 
               c-texto-html[4] = "Confirme o recebimento do pedido no site"            
               c-texto-html[5] = " "
               c-texto-html[6] =  "Veja em anexo arquivo contendo informacoes sobre o Pedido Nr. " 
                                 + string(fi-num-pedido, ">>>,>>9") + "."
               c-texto-html[7] = "Por favor, verifique e mande-nos uma resposta formal".

        assign c-texto-html[3] = "Acesse http://b2b.intelbras.com.br e verifique o Pedido Nr. " 
                                 + string(fi-num-pedido, ">>>,>>9") + ".". */

        ASSIGN c-texto-html[1] = "Prezados fornecedor," 
               c-texto-html[2] = "Aguardamos a confirmaá∆o de recebimento para o pedido em anexo, bem como, a estimativa de entrega na Intelbras."
	       c-texto-html[3] = "Obrigado!".

        RUN enviaMail(INPUT c-remetente,
                      INPUT c-endereco,
                      INPUT trim(c-titulo),
                      INPUT c-texto-html[1] + "~n" + 
                            c-texto-html[2] + "~n" + 
                            c-texto-html[3] + "~n" + 
                            c-texto-html[4] + "~n" + 
                            c-texto-html[5] + "~n" + 
                            c-texto-html[6] + "~n" + 
                            c-texto-html[7],
                       INPUT c-arquivo).
    /*END.*/

    STATUS DEFAULT.

    if trim(c-mess-err) <> "" then do:
       RUN ShowMessage (1, c-mess-err, "").
    end.
    RUN ShowMessage (2, "E-Mail enviado com sucesso", "").

    EMPTY TEMP-TABLE ttpedido-compr.
    CREATE ttpedido-compr.
    BUFFER-COPY pedido-compr TO ttpedido-compr.
    ttpedido-compr.r-rowid = ROWID(pedido-compr).
    assign ttpedido-compr.impr-pedido = no
           ttpedido-compr.situacao    = 1.

    IF NOT fn-atualiza-pedido() THEN DO:
        {method/ShowMessage.i1}.
        {method/ShowMessage.i2 &Modal="YES"}.
        {method/ShowMessage.i3}.
        UNDO, RETURN "NOK".
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-atualiza-cotacao wWindow 
FUNCTION fn-atualiza-cotacao RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

   RUN emptyRowErrors IN {&hDBOTable3} NO-ERROR.        
   RUN SetConstraintByItCodigo IN {&hDBOTable3} (INPUT ttcotacao-item.it-codigo,
                                                 INPUT ttcotacao-item.numero-ordem,
                                                 INPUT ttcotacao-item.cod-emitente,
                                                 INPUT ttcotacao-item.cod-emitente) NO-ERROR.
   RUN openQueryStatic IN {&hDBOTable3} (INPUT "ByItCodigo":U) NO-ERROR.
   RUN setrecord IN {&hDBOTable3} (INPUT TABLE ttcotacao-item).  
   RUN updaterecord IN {&hDBOTable3}.    
   RUN getRowErrors IN {&hDBOTable3} (OUTPUT TABLE RowErrors).

   IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
       RETURN FALSE.
   END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-atualiza-pedido wWindow 
FUNCTION fn-atualiza-pedido RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   DEF BUFFER b-pedido-compr FOR pedido-compr. 

   /* Esta chamada da boin295 estﬂ ocasionando o bloqueio do registro cotacao-item */

   /*
   
   RUN emptyRowErrors IN {&hDBOTable} NO-ERROR.        
   RUN SetConstraintByPedido IN {&hDBOTable} (INPUT fi-num-pedido) NO-ERROR.
   RUN openQueryStatic IN {&hDBOTable} (INPUT "ByPedido":U) NO-ERROR.
   RUN setrecord IN {&hDBOTable} (INPUT TABLE ttpedido-compr).  
   RUN updaterecord IN {&hDBOTable}.                        
   RUN getRowErrors IN {&hDBOTable} (OUTPUT TABLE RowErrors).
   IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
       RETURN FALSE.
   END.
   
   */

   FIND FIRST b-pedido-compr EXCLUSIVE-LOCK 
       WHERE b-pedido-compr.num-pedido = ttpedido-compr.num-pedido NO-ERROR.
   BUFFER-COPY ttpedido-compr TO b-pedido-compr.
   RELEASE b-pedido-compr.

   RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-atualza-ordem wWindow 
FUNCTION fn-atualza-ordem RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   RUN emptyRowErrors IN {&hDBOTable2} NO-ERROR.        
   RUN SetConstraintByNumeroOrdem IN {&hDBOTable2} (INPUT ttordem-compra.numero-ordem,
                                                    INPUT ttordem-compra.numero-ordem,
                                                    INPUT ROWID(ITEM)) NO-ERROR.
   RUN openQueryStatic IN {&hDBOTable2} (INPUT "ByNumeroOrdem":U) NO-ERROR.
   RUN setrecord IN {&hDBOTable2} (INPUT TABLE ttordem-compra).  
   RUN updaterecord IN {&hDBOTable2}.                        
   RUN getRowErrors IN {&hDBOTable2} (OUTPUT TABLE RowErrors).
   IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
       RETURN FALSE.
   END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-cria-altped wWindow 
FUNCTION fn-cria-altped RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

   RUN emptyRowErrors IN {&hDBOTable4} NO-ERROR.        
   RUN setConstraintMain IN {&hDBOTable4} ("Main") NO-ERROR.
   RUN openQueryStatic IN {&hDBOTable4} (INPUT "Main":U) NO-ERROR.
   RUN setrecord IN {&hDBOTable4} (INPUT TABLE ttalt-ped).  
   RUN createrecord IN {&hDBOTable4}.                        
   RUN getRowErrors IN {&hDBOTable4} (OUTPUT TABLE RowErrors).
   IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
       RETURN FALSE.
   END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

