&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
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
{include/i-prgvrs.i esccp006 2.04.000.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esccp006
&GLOBAL-DEFINE Version        2.04.000.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   E-Mail,Serviáo

&GLOBAL-DEFINE page0Widgets   btExit btHelp ~
                              btAcao
&GLOBAL-DEFINE page1Widgets   fi-arq-htm fi-email fi-num-pedido btFile c-destination
&GLOBAL-DEFINE page2Widgets   fi-num-pedido
&GLOBAL-DEFINE ttTable        tt-pedido-compr
&GLOBAL-DEFINE hDBOTable      dboin295
&GLOBAL-DEFINE DBOTable       boin295

{upc\btb910za-upc.i}

/* Parameters Definitions ---                                           */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

DEF VAR l-ok AS LOGICAL NO-UNDO.
DEF VAR wh-num-pedido AS WIDGET-HANDLE NO-UNDO.
DEF VAR i-page AS INT NO-UNDO INIT 1.
def var de-preco-conv     as decimal no-undo.
def var c-data         as char  no-undo.
def var c-nome-estabelec as char no-undo.
def var da-novo-emb    as date format "99/99/9999" NO-UNDO.
def var c-via-trans        as char no-undo.
def var c-incoterm         as char no-undo.
def var i-via              as integer no-undo.
DEF VAR c-remetente        AS CHAR NO-UNDO INIT "intelbras@intelbras.com.br".
DEF VAR c-descricao        AS CHAR FORMAT "x(80)" no-undo.
DEFINE VARIABLE c-narrativa  AS CHARACTER   NO-UNDO.
DEF VAR ind                AS INT no-undo.
def var i-est-codigo        like estabelec.cod-estabel no-undo.
DEF VAR c_imagem_usada  AS CHAR NO-UNDO.
DEFINE VARIABLE c-hml AS CHARACTER   NO-UNDO.

def temp-table tt-ordens NO-UNDO
    field oc              as char format "x(20)" 
    field it-codigo       as char format "x(7)"
    field descricao       as char format "x(60)" 
    field un              as char format "x(2)"
    field pn              as char format "x(60)"
    field classif         as char format "x(12)"
    field qtd             as char format "x(16)"
    field preco-unit      as char format "x(17)"
    field preco-tot       as char format "x(15)"
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-atualiza-pedido wWindow 
FUNCTION fn-atualiza-pedido RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&RelatΩrios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conteúdo"     
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
     SIZE 4 BY .96.

DEFINE VARIABLE c-destination AS CHARACTER FORMAT "x(100)":U 
     LABEL "Destination" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE fi-arq-htm AS CHARACTER FORMAT "X(45)":U 
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

DEFINE FRAME fPage2
     fi-num-pedido AT ROW 1.25 COL 15 COLON-ALIGNED HELP
          "N£úmero do Pedido de Compra"
          LABEL "Pedido":R8 FORMAT ">>>>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1
         TITLE "Altera o Tipo de Compra do Pedido para Serviáo".

DEFINE FRAME fPage1
     fi-num-pedido AT ROW 1.25 COL 15 COLON-ALIGNED HELP
          "N£mero do Pedido de Compra"
     fi-email AT ROW 2.25 COL 15 COLON-ALIGNED
     btFile AT ROW 3.21 COL 67 HELP
          "Escolha do nome do arquivo"
     fi-arq-htm AT ROW 3.25 COL 15 COLON-ALIGNED
     c-destination AT ROW 7 COL 15 COLON-ALIGNED HELP
          "Final Destination" WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
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
            RUN ShowMessage (1, "Endereáo de E-Mail n∆o informado", "").
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
            RUN ShowMessage (1, "Respons†vel do pedido n∆o informado", 
                             "O respons†vel pelo pedido de compra n∆o foi informado. Por favor atualizar").
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


&Scoped-define FRAME-NAME fPage1
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
        WHERE  pedido-compr.num-pedido = INPUT FRAME fpage1 fi-num-pedido NO-ERROR.
    IF  AVAIL  pedido-compr THEN DO:

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

        END. /* FOR EACH  int-cont-emit NO-LOCK */

        FOR FIRST usuar-mater NO-LOCK
            where usuar-mater.cod-usuario = pedido-compr.responsavel 
            and   usuar-mater.usuar-comprador:
            assign fi-email = fi-email + "," + usuar-mater.e-mail.
        END. /* FOR FIRST usuar-mater NO-LOCK */

        DISP fi-email WITH FRAME fpage1.

        /*---[ Chamado 8860 - Andressa Mokesinski ]------------------------------------------------*/
        find estabelec where estabelec.cod-estabel = pedido-compr.cod-estabel no-lock no-error.
        if  avail estabelec then do:
            assign i-est-codigo = estabelec.cod-estabel.
    
            CASE i-est-codigo:
                WHEN "101" then assign c-destination  = "SAO JOSE/SANTA CATARINA/BRAZIL".
                WHEN "102" then assign c-destination  = "SAO JOSE DOS PINHAIS/PARANA/BRAZIL".
                WHEN "103" then assign c-destination  = "SAO JOSE/SANTA CATARINA/BRAZIL".
                WHEN "104" then assign c-destination  = "SAO JOSE/SANTA CATARINA/BRAZIL".
                WHEN "105" then assign c-destination  = "MANAUS/AMAZONAS/BRAZIL".
                OTHERWISE ASSIGN c-destination = "".
            END CASE.    

            DISP c-destination WITH FRAME fpage1.

        end. /* if  avail estabelec ... */
        /*---[ Chamado 8860 - Andressa Mokesinski ]------------------------------------------------*/
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


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- LΩgica para inicializa?ío do programam ---*/
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
    /*--- DestrΩi os Servidores RPC inicializados pelos DBOs ---*/
    {btb/btb008za.i3}
        
    /*Alteracao para deletar da memΩria o WindowStyles e o btb008za.p*/
    IF VALID-HANDLE(h-servid-rpc) THEN
    DO:
       DELETE PROCEDURE h-servid-rpc.
       ASSIGN h-servid-rpc = ?. /*Garantir que a vari†vel n∆o vai mais apontar para nenhum handle de outro objeto - este problema apareceu na v9.1B com Windows2000*/
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
    
    FOR FIRST param-global NO-LOCK:
    END.
    
    FOR FIRST usuar_mestre FIELDS (cod_e_mail_local)
        WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK:
        IF usuar_mestre.cod_e_mail_local <> "" THEN
            ASSIGN c-remetente = usuar_mestre.cod_e_mail_local.
    END.
    RUN initializeDBOs.
    ASSIGN fi-arq-htm:SCREEN-VALUE IN FRAME fpage1 = SESSION:TEMP-DIRECTORY + "PO"
           c-tam-tab                               = "700".
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
    def input parameter l-existe-embarque as logical no-undo.

    if l-existe-embarque then do:          
       find last pto-itiner where pto-itiner.cod-itiner
                                = cotacao-item.int-1
                            no-lock no-error.
       if not avail pto-itiner then do:
          return.   
       end.    
       find historico-embarque where 
            historico-embarque.cod-estabel = ordem-compra.cod-estabel and
            historico-embarque.embarque    = ordens-embarque.embarque and
            historico-embarque.cod-itiner  = pto-itiner.cod-itiner    and
            historico-embarque.cod-pto-contr = itinerario.pto-despacho no-lock no-error.    
    end.

    create tt-ordens.
    assign tt-ordens.oc = string(ordem-compra.numero-ordem, ">>>,>>9,99")
                        + "/"
                        + string(prazo-compra.parcela, "99")
           tt-ordens.it-codigo     = (if prazo-compra.it-codigo = "" then 
                                         "&nbsp;"
                                      else
                                         prazo-compra.it-codigo)
           tt-ordens.un            = IF AVAIL item-fornec-estab THEN item-fornec-estab.unid-med-for
                                     ELSE (if avail item-fornec THEN item-fornec.un ELSE item.un)
           tt-ordens.qtd 
                  = string(round(prazo-compra.qtd-sal-forn, 2), ">>,>>>,>>9.99")
           tt-ordens.preco-unit = string(de-preco-conv, ">>>>,>>>,>>9.99999")
           tt-ordens.preco-tot  = string(round((de-preco-conv 
                            * prazo-compra.qtd-sal-forn),2), ">>>>,>>>,>>9.99").

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

    if l-existe-embarque = yes then do:
       assign c-data  = (if avail historico-embarque then
                            if historico-embarque.dt-efetiva = ? then
                               string(historico-embarque.dt-ult-previsao, 
                                      "99/99/9999")
                            else
                               string(historico-embarque.dt-efetiva,
                                      "99/99/9999")
                         else
                            "**ERROR**")
              tt-ordens.dt-embarque = "<TD ALIGN="
                                    + chr(34)
                                    + "center"
                                    + chr(34)
                                    + "><FONT COLOR=#4066E1 SIZE=2><I><B>"
                                    + (if avail historico-embarque then
                                          substring(c-data,4,2) 
                                        + "/" 
                                        + substring(c-data,1,2)
                                        + substring(c-data,6,5)
                                       else 
                                          c-data)
                                    + "</B></I></FONT></TD>".
    end.
    else do:
       assign c-data = string((if da-novo-emb <> ? then da-novo-emb else prazo-compra.data-entrega 
                              - (IF AVAIL item-fornec-estab THEN item-fornec-estab.tempo-ressup ELSE (if avail item-fornec then item-fornec.tempo-ressup else 0))
                               + (if avail int-item-fornec then
                                     mgesp.int-item-fornec.tempo-fabric
                                  else 
                                    0)
                                    ), "99/99/9999")
              tt-ordens.dt-embarque = "<TD ALIGN="
                                    + chr(34)
                                    + "center"
                                    + chr(34)
                                    + "><FONT COLOR=#4066E1 SIZE=2><I><B>"
                                    + substring(c-data,4,2) 
                                    + "/" 
                                    + substring(c-data,1,2)
                                    + substring(c-data,6,5)
                                    + "</B></I></FONT></TD>".
    end.
    
    /* part number */

    IF AVAIL item-fornec-estab THEN DO:

        FIND FIRST int-item-for-PN NO-LOCK
            WHERE int-item-for-PN.cod-emitente = item-fornec-estab.cod-emitente
              AND int-item-for-PN.it-codigo    = item-fornec-estab.it-codigo NO-ERROR.

        if AVAIL int-item-for-PN AND int-item-for-PN.item-do-forn <> "" then do:
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
    END.
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
                                                 
    if item.tipo-contr = 4 /* DÇbito Direto */ then do:
        assign tt-ordens.descricao = tt-ordens.descricao
                                     + trim(ordem-compra.narrativa)
                                     + "<BR>".
    end.
    ELSE if avail item-fornec-estab and item-fornec-estab.narrativa <> "" and item.it-codigo <> "" then
            assign tt-ordens.descricao = tt-ordens.descricao + trim(item-fornec-estab.narrativa) + "<BR>".
    ELSE if  avail item-fornec and item-fornec.narrativa <> "" and item.it-codigo <> "" then
          assign tt-ordens.descricao = tt-ordens.descricao + trim(item-fornec.narrativa) + "<BR>". 

/*   nao deve pegar a narrativa do item e sim a descricao.
 
 else  if  avail narrativa
         and narrativa.descricao <> "" then do:
               assign tt-ordens.descricao = tt-ordens.descricao
                                          + trim(narrativa.descricao)
                                          + "<BR>".
    end. */
    else DO:

        /*rotina para buscar narrativa do estabelecimento*/
        RUN esp/es0205.p(INPUT ordem-compra.cod-estabel, INPUT ordem-compra.it-codigo, OUTPUT c-narrativa).

        assign /*c-descricao   = item.descricao-1 + item.descricao-2*/
               tt-ordens.descricao    = c-narrativa + " - P/N - " + item.it-codigo + "<BR>".

        /*assign tt-ordens.descricao = item.descricao-1 + 
                                     item.descricao-2 + "<BR>".*/
    END.

    assign tt-ordens.descricao = "<TD ALIGN=" + chr(34) + "left" + chr(34) + ">"
                               + tt-ordens.descricao + tt-ordens.pn
                               + "</TD>".
    
    if l-existe-embarque = yes then do:                      
       for each embarque-imp 
          where embarque-imp.cod-estabel = ordem-compra.cod-estabel
            and embarque-imp.embarque    = ordens-embarque.embarque no-lock:

           assign tt-ordens.situacao = "<TD ALIGN="
                                     + chr(34)
                                     + "center"
                                     + chr(34)
                                     + "><FONT COLOR=#"
                                     + (if prazo-compra.situacao = 6 then
                                           "000000><B>Received</B>"
                                        else if prazo-compra.situacao = 4 then
                                           "E63333><B>Cancelled</B>"
                                        else 
                                           if                                          trim(embarque-imp.cod-conhecto-master) 
                                           <> "" then
                                              "4066E1><B>Shipped</B>"
                                           else
                                              "238E68><B>Opened</B>")
                                     + "</FONT></TD>"
                  tt-ordens.nr-conhecimento 
                           = (if trim(embarque-imp.cod-conhecto-master) = ""
                              then "&nbsp;"
                              else embarque-imp.cod-conhecto-master).

                                   
                           
           if c-via-trans = "" OR c-via-trans = "&nbsp;" then 
              assign c-incoterm  = embarque-imp.cod-incoterm
                     i-via       = embarque-imp.cod-via-transp
                     c-via-trans = (if i-via = 1 then
                                       "by road"
                                    else if i-via = 2 then
                                       "by plane"
                                    else if i-via = 3 then
                                       "by sea"
                                    else if i-via = 4 then
                                       "by train"
                                    else if i-via = 5 then
                                       "by road and train"
                                    else if i-via = 6 then
                                        "by road and river"
                                    else if i-via = 7 then
                                        "by road and train"
                                    else
                                        "by other ways").
       end.         
    end.
    else do:
       assign tt-ordens.situacao = "<TD ALIGN="
                                 + chr(34)
                                 + "center"
                                 + chr(34)
                                 + "><FONT COLOR=#"
                                 + (if prazo-compra.situacao = 6 then
                                       "000000><B>Received</B>"
                                    else if prazo-compra.situacao = 4 then
                                        "E63333><B>Cancelled</B>"
                                    else 
                                        "238E68><B>Forecast</B>")
                                 + "</FONT></TD>"
              tt-ordens.nr-conhecimento = "&nbsp;" 
              c-incoterm  = if c-incoterm <> "&nbsp;" and c-incoterm <> "" then
                               c-incoterm
                            else
                               "&nbsp;"
              c-via-trans = if c-via-trans <> "&nbsp;" and c-via-trans <> ""
                            then c-via-trans
                            else "&nbsp;".
    end.         

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
    def var c-fone as char no-undo.
    def var c-fax  as char no-undo.
    def var de-total-compras   like ordem-compra.preco-fornec no-undo.
    def var c-mess-err         as char no-undo.
    def var c-nr-pedido        as char format "x(100)" no-undo.
    def var c-tit-ped          as char format "x(100)" no-undo.
    def var c-dados-empresa    as char format "x(300)" no-undo.
    def var c-dados-fornecedor as char format "x(300)" no-undo.
    def var c-imagem           as char format "x(100)" no-undo.
    def var c-complementos     as char format "x(300)" no-undo.
    def var c-mensagem1        as char format "x(600)" no-undo.
    def var c-comentario1      as char format "x(600)" no-undo.
    def var c-titulo           as char  no-undo.

    EMPTY TEMP-TABLE tt-ordens.
    output to value(fi-arq-htm) CONVERT TARGET SESSION:CHARSET.

    run html-inicio("Purchase Order1").
    
    find emitente 
        where emitente.cod-emitente = pedido-compr.cod-emitente
        NO-LOCK no-error.
    
    find cond-pagto 
        where cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag
        no-lock no-error.
    
    ASSIGN c-descricao = ""
           i-est-codigo = "0".

    IF AVAIL cond-pagto THEN DO:
        ASSIGN c-descricao = cond-pagto.descricao.
    END.
    ELSE DO:
       FIND FIRST cond-especif OF pedido-comp NO-LOCK NO-ERROR.
       DO ind = 1 TO 12:
           IF cond-especif.perc-pagto[ind] <> 0 THEN
              ASSIGN c-descricao = c-descricao + 
                                   cond-especif.comentarios[ind] + " ".
       END.
    END.
    
    assign c-via-trans = "".                 
                          
    assign da-novo-emb = ?.
/*    
    find ext-pedido        
         where ext-pedido.num-pedido = pedido-compr.num-pedido
         no-lock no-error.

    if avail ext-pedido  then do:
        if ext-pedido.final-destination <> "" then 
            assign c-desembarque = ext-pedido.final-destination.
        assign c-via-trans   = ext-pedido.shipping-method
               c-embarque    = ext-pedido.place-of-ship
               c-incoterm    = ext-pedido.invoice-validity
               da-novo-emb   = ext-pedido.data-emissao.
    end.   
*/
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

        find FIRST item-fornec 
             where item-fornec.it-codigo = ordem-compra.it-codigo
               and item-fornec.cod-emite = ordem-compra.cod-emite no-lock no-error.
        if avail item-fornec then 
            find mgesp.int-item-fornec of item-fornec no-lock no-error.
        find narrativa where narrativa.it-codigo 
                           = ordem-compra.it-codigo
                       no-lock no-error.
                       
        find estabelec where
             estabelec.cod-estabel = pedido-compr.cod-estabel no-lock no-error.
        if avail estabelec then do:
                assign i-est-codigo = estabelec.cod-estabel.

                CASE i-est-codigo:
                    WHEN "101" then assign /*c-desembarque  = "SAO JOSE/SANTA CATARINA/BRAZIL"*/
                                           c-fone         = "+55-48-3281-9500"
                                           c-fax          = "+55-48-3281-9500".
                    WHEN "102" then assign /*c-desembarque  = "SAO JOSE DOS PINHAIS/PARANA/BRAZIL"*/
                                           c-fone         = "+55-41-3306-9462"
                                           c-fax          = "+55-41-3306-9462".
                    WHEN "103" then assign /*c-desembarque  = "SAO JOSE/SANTA CATARINA/BRAZIL"*/
                                           c-fone         = "+55-48-3281-9559"
                                           c-fax          = "+55-48-3281-9500".
                    WHEN "104" then assign /*c-desembarque  = "SAO JOSE/SANTA CATARINA/BRAZIL"*/
                                           c-fone         = "+55-48-3281-9559"
                                           c-fax          = "+55-48-3281-9559".
                    WHEN "105" then assign /*c-desembarque  = "MANAUS/AMAZONAS/BRAZIL"*/
                                           c-fone         = "+55-92-3237-9673"
                                           c-fax          = "+55-92-3237-9673".
                END CASE.

                /*---[ Conforme chamado 8860, de Andressa Mokesinski, mostra o que foi informado na tela ]---*/
                ASSIGN c-desembarque = INPUT FRAME fpage1 c-destination.
                /*-------------------------------------------------------------------------------------------*/
                
                assign c_imagem_usada   = SEARCH("image/logo_intelbras.jpg") 
                       c-imagem         = '<TH><img src= ' + c_imagem_usada + ' border="0" ></TH>'
                       c-nome-estabelec = estabelec.nome
                       c-dados-empresa  = "<B>" + trim(string(c-nome-estabelec)) + "</B><BR>"
                                        + estabelec.endereco + "<BR>"
                                        + estabelec.bairro + ", CEP " + trim(string(estabelec.cep)) + "<BR>" 
                                        + estabelec.cidade + "," + estabelec.estado + "<BR>"
                                        + "Phone: " + trim(string(c-fone)) + "<BR>"
                                        + "Fax: " + trim(string(c-fax)) + "<BR>"
                                        + "CNPJ: " + trim(string(estabelec.cgc)) + "<BR>"
                                        + "Insc.Est.: " + trim(string(estabelec.ins-estadual)) + "<BR>"
                                        + "Buyer: "
                                        + usuar-mater.nome
                                        + "<BR>E-mail: "
                                        + usuar-mater.e-mail
                                        + "<BR>Phone: 55 "
                                        + usuar-mater.telefone[1].           
        end.
                       
        assign de-preco-conv = ordem-compra.preco-fornec.
 
        if ordem-compra.natureza = 2 then do:
           run pi-cria-tt-ordens(no).
           next.
        end.

        find first cotacao-item where cotacao-item.numero-ordem 
                                    = ordem-compra.numero-ordem
                                  and cotacao-item.cod-emitente
                                    = ordem-compra.cod-emitente
                                  and cotacao-item.cot-aprovada
                                no-lock no-error.
        if not avail cotacao-item then next.

        ASSIGN c-incoterm = trim(substr(cotacao-item.char-1,21,20)).

        
        find itinerario where itinerario.cod-itiner 
                            = cotacao-item.int-1
                        no-lock no-error.
        if avail itinerario then do:
           find pto-contr where pto-contr.cod-pto-contr 
                              = itinerario.pto-embarque
                          no-lock no-error.
           if avail pto-contr then do:               
              assign c-embarque = pto-contr.descricao.
           end.
           else do:
              assign c-embarque = "&nbsp;"
                     c-mess-err 
                   = "Ponto de despacho no itinerario inexistente!".
           end.          
        end.   
        else do:
              assign c-embarque = "&nbsp;"
                     c-mess-err 
                   = "Itinerario inexistente! - Verifique es0846".
        end.
       
        find first ordens-embarque where ordens-embarque.numero-ordem 
                                       = prazo-compra.numero-ordem
                                     and ordens-embarque.parcela
                                       = prazo-compra.parcela
                                   no-lock no-error.
        if not avail ordens-embarque then do:
           run pi-cria-tt-ordens (no).
           next.
        end.
        
        for each ordens-embarque where ordens-embarque.numero-ordem 
                                     = prazo-compra.numero-ordem
                                   and ordens-embarque.parcela
                                     = prazo-compra.parcela
                                 no-lock:
            run pi-cria-tt-ordens (yes).                     
        end.
    
    
    end.                      
 
    FIND transporte 
             where transporte.cod-transp = pedido-compr.cod-transp
                   no-lock no-error.
    assign c-agente = transporte.nome-abrev WHEN AVAIL transporte.               


    assign c-data      = string(month(pedido-compr.data-pedido),"99")
                       + "/"
                       + string(day(pedido-compr.data-pedido),"99")
                       + "/"
                       + string(year(pedido-compr.data-pedido), "9999")
           c-nr-pedido = "<TH> <FONT FACE="
                       + chr(34)
                       + "Times New Roman"
                       + chr(34)
                       + " SIZE=3> #: "
                       + string(pedido-compr.num-pedido, ">>>,>>9")
                       + " - "
                       + c-data
                       + "</FONT> </TH>".                       
        
    assign c-dados-fornecedor = "<B>Supplier:</B><BR>"
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
                              + emitente.pais
                              + "<BR>"
                              + "Phone: "
                              + emitente.telefone[1]
                              + "<BR>"
                              + "Fax: "
                              + emitente.telefax.
    assign c-complementos = "Payment Condition: "
                          + c-descricao
                          + "<BR>Shipping Method: "
                          + c-via-trans
                          + "<BR>Incoterm: "
                          + c-incoterm
                          + "<BR>Cargo Agent: "
                          + c-agente
                          + "<BR>Place of Shipping: "
                          + c-embarque
                          + "<BR>Final Destination: "
                          + c-desembarque.

    ASSIGN c-mensagem1   = ""
           c-comentario1 = "".
    /*case i-est-codigo:
        when "101" then do:                          
            assign c-imagem = "<TH> <FONT FACE="
                            + chr(34)
                            + "Arial Black, sans-serif"
                            + chr(34)
                            + " SIZE=5 COLOR=#238E68> Intelbras S/A</FONT> </TH>"
                   c-mensagem1 = "1) The above quantity is subject "
                            + "to a further review "
                            + "(it may be increased/"
                            + "decreased/cancelled);<BR><BR>"       
                            + "2) Please include the follow information "
                            + "on the Intelbras address in the " 
                            + "Commercial Invoice: CNPJ: " + estabelec.cgc + ";"
                            + "<BR><BR>"
                            + "3) According to the new Brazilian legislation, " 
                            + "the commercial invoice must mention: "      
                            + "total gross weight, total net "             
                            + "weight,  full description of each  item, volume " 
                            + "quantity, manufacturer full name and address."
                            + "<BR><BR>"
                            + "* Carton Marks:"           
                            + "<BR><BR>"
                            + "INTELBRAS S.A.<BR>" 
                            + "SAO JOSE-SC-BRASIL<BR>"
                            + "Mercadoria destinada ao EADI - Portobello - Itajai - SC<BR>" 
                            + "PO Nr. (Please inform the PO" + " number) <BR>"
                            + "Supplier's PN (Please inform your part number) <BR>"
                            + "QUANTITY (Please inform the quantity of pieces per cartoon)<BR>" 
                            + "Gross Weight: (Please inform the gross weight per carton) <BR>"
                            + "Net Weight: (please inform the net weight per carton) <BR>"
                            + "MADE IN (Please inform the country " + "of origin of the goods) <BR>"
                            + "Manufactured Date: You inform with day/week/year or week/year for example 31/12/2001 or 49 / 2001 <BR>"
                            + "Lot number: (Please inform you lot nr.)<BR>" 
                            + "Due time period:  (Please inform us how many months we can keep your product in our warehouse eg.: 20 months. )<BR>".
        end.
        when "102" then do:
            assign c-imagem = "<TH> <FONT FACE="
                            + chr(34)
                            + "Arial Black, sans-serif"
                            + chr(34)
                            + " SIZE=5 COLOR=#238E68> Intelbras S/A </FONT> </TH>"
                   c-mensagem1 = "1) The above quantity is subject "
                            + "to a further review "
                            + "(it may be increased/"
                            + "decreased/cancelled);<BR><BR>"       
                            + "2) Please include the follow information "
                            + "on the Nova address in the " 
                            + "Commercial Invoice: CNPJ: " + estabelec.cgc + ";"
                            + "<BR><BR>"
                            + "3) According to the new Brazilian legislation, " 
                            + "the commercial invoice must mention: "      
                            + "total gross weight, total net "             
                            + "weight,  full description of each  item, volume " 
                            + "quantity, manufacturer full name and address."
                            + "<BR><BR>"
                            + "* Carton Marks:"           
                            + "<BR><BR>"
                            + "Intelbras S/A <BR>" 
                            + "SAO JOSE DOS PINHAIS-PR-BRASIL<BR>"
                            + "PO Nr. (Please inform the PO" + " number) <BR>"
                            + "Supplier's PN (Please inform your part number) <BR>"
                            + "QUANTITY (Please inform the quantity of pieces per cartoon)<BR>" 
                            + "Gross Weight: (Please inform the gross weight per carton) <BR>"
                            + "Net Weight: (please inform the net weight per carton) <BR>"
                            + "MADE IN (Please inform the country " + "of origin of the goods) <BR>"
                            + "Manufactured Date: You inform with day/week/year or week/year for example 31/12/2001 or 49 / 2001 <BR>"
                            + "Lot number: (Please inform you lot nr.)<BR>" 
                            + "Due time period:  (Please inform us how many months we can keep your product in our warehouse eg.: 20 months. )<BR>".        
        end.
        WHEN "105" THEN DO:
            assign c-imagem = "<TH> <FONT FACE="
                            + chr(34)
                            + "Arial Black, sans-serif"
                            + chr(34)
                            + " SIZE=5 COLOR=#238E68> Intelbras S/A</FONT> </TH>"
                   c-mensagem1 = "1) The above quantity is subject "
                            + "to a further review "
                            + "(it may be increased/"
                            + "decreased/cancelled);<BR><BR>"       
                            + "2) Please include the follow information "
                            + "on the Intelbras address in the " 
                            + "Commercial Invoice: CNPJ: " + estabelec.cgc + ";"
                            + "<BR><BR>"
                            + "3) According to the new Brazilian legislation, " 
                            + "the commercial invoice must mention: "      
                            + "total gross weight, total net "             
                            + "weight,  full description of each  item, volume " 
                            + "quantity, manufacturer full name and address."
                            + "<BR><BR>"
                            + "* Carton Marks:"           
                            + "<BR><BR>"
                            + "INTELBRAS S.A.<BR>" 
                            + "MANAUS-AM-BRASIL<BR>"
                            + "Mercadoria destinada ao EADI - Manaus - AM<BR>" 
                            + "PO Nr. (Please inform the PO" + " number) <BR>"
                            + "Supplier's PN (Please inform your part number) <BR>"
                            + "QUANTITY (Please inform the quantity of pieces per cartoon)<BR>" 
                            + "Gross Weight: (Please inform the gross weight per carton) <BR>"
                            + "Net Weight: (please inform the net weight per carton) <BR>"
                            + "MADE IN (Please inform the country " + "of origin of the goods) <BR>"
                            + "Manufactured Date: You inform with day/week/year or week/year for example 31/12/2001 or 49 / 2001 <BR>"
                            + "Lot number: (Please inform you lot nr.)<BR>" 
                            + "Due time period:  (Please inform us how many months we can keep your product in our warehouse eg.: 20 months. )<BR>".

        END.
    end case.
    */

     FIND FIRST int-pedido-compr NO-LOCK
          WHERE int-pedido-compr.num-pedido = pedido-compr.num-pedido NO-ERROR.

     IF  AVAIL int-pedido-compr
     AND int-pedido-compr.tp-pedido = 4 THEN
         ASSIGN c-hml = "HML".
     ELSE 
         ASSIGN c-hml = "".

    assign c-tit-ped = "<FONT FACE="
                     + chr(34)
                     + "Times New Roman"
                     + chr(34)
                     + " SIZE=3>Purchase Order " + c-hml
                     + "</FONT>".
                     
    find mensagem where
         mensagem.cod-mensagem = pedido-compr.cod-mensagem
         no-lock no-error.

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
      + '"' ">" trim(c-dados-empresa) format "x(400)" "</TD>" skip.
/*
    run html-fim-lin-tab.
    run html-fim-tab.

    run html-ini-tab.
    run html-ini-lin-tab.
*/    
    /******** 
      PUT incluido porque rotina original possui "format" em 60 posicoes 
    *********/
    
    put "<TD ALIGN=" '"' 
        + "center" 
        + '"' ">" trim(c-dados-fornecedor) format "x(300)" "</TD>" skip. 
        
    run html-fim-lin-tab.
    run html-fim-tab.

    run html-ini-tab.
    run html-ini-lin-tab.
    run html-cab-tab("OC/Par").
    run html-cab-tab("HS Code").
    run html-cab-tab("Item").
    run html-cab-tab("Description/Part No.").
    run html-cab-tab("UN").
    run html-cab-tab("Qty").
    run html-cab-tab("Unit Price").
    run html-cab-tab("Currency").
    run html-cab-tab("Total Price").
/*       run html-cab-tab("Shipping No.").   */
    run html-cab-tab("Shp Dt (MM/DD/YY)").
/*        run html-cab-tab("Status"). */
    run html-fim-lin-tab.

    assign de-total-compras = 0.


    for each tt-ordens by tt-ordens.it-codigo
                       by tt-ordens.oc:

        if tt-ordens.situacao matches "*Cancelled*" 
        and pedido-compr.situacao = 1 then do:
           next.
        end.
        
        run html-ini-lin-tab.
        run html-con-tab(tt-ordens.oc,"right").
        run html-con-tab(tt-ordens.classif,"left").
        run html-con-tab(tt-ordens.it-codigo,"left").
        
        put tt-ordens.descricao format "x(450)" skip.
          
        run html-con-tab(tt-ordens.un,"center").
        run html-con-tab(tt-ordens.qtd,"right").
        run html-con-tab(tt-ordens.preco-unit,"right").
        run html-con-tab(tt-ordens.desc-moeda,"CENTER").
        run html-con-tab(tt-ordens.preco-tot,"right").
/*            run html-con-tab(tt-ordens.nr-conhecimento,"left").   */
            
            put tt-ordens.dt-embarque format "x(90)" skip.
            
/*           put tt-ordens.situacao    format "x(80)" skip. */
            
            run html-fim-lin-tab.
            
            if not (tt-ordens.situacao matches "*Cancelled*") then
               assign de-total-compras = de-total-compras
                                       + dec(tt-ordens.preco-tot).
            
    end.
    run html-fim-tab.

    run html-ini-tab.
    run html-ini-lin-tab.
    run html-con-tab(("Total Amout: " 
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
           c-texto-html[1]  
         = "A file containing information about PO No. " 
         + string(fi-num-pedido, ">>>,>>9")
         + " is attached to this mail"
           c-texto-html[2]  
         = "Please, check it and send us a formal reply"
           c-titulo = "PO No. " + string(fi-num-pedido, ">>>,>>9").
          
    RUN enviaMail (INPUT c-remetente,
                   INPUT c-endereco,
                   INPUT trim(c-titulo),
                   INPUT c-texto-html[1] + "~n" + c-texto-html[2],
                   INPUT c-arquivo).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-atualiza-pedido wWindow 
FUNCTION fn-atualiza-pedido RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

   RUN emptyRowErrors IN {&hDBOTable} NO-ERROR.        
   RUN SetConstraintByPedido IN {&hDBOTable} (INPUT fi-num-pedido) NO-ERROR.
   RUN openQueryStatic IN {&hDBOTable} (INPUT "ByPedido":U) NO-ERROR.
   RUN setrecord IN {&hDBOTable} (INPUT TABLE ttpedido-compr).  
   RUN updaterecord IN {&hDBOTable}.                        
   IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
       RETURN FALSE.
   END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

