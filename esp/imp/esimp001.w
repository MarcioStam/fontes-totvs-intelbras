&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i ESIMP001 2.06.000.003}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESIMP001
&GLOBAL-DEFINE Version        2.06.000.003

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   ParÉmetros 1, E-Mail

&GLOBAL-DEFINE page0Widgets   btExit ~
                              btHelp ~
                              btAcao
&GLOBAL-DEFINE page1Widgets   fi-cod-estabel ~
                              fi-embarque
&GLOBAL-DEFINE page2Widgets   fi-arq-htm ~
                              fi-arq-htm-2 ~
                              fi-email ~
                              btFile ~
                              btFile-2

/* Parameters Definitions ---                                           */

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE      NO-UNDO.

/* Include Definitions ---                                              */

{esp/imp/esimp001tt.i "new"}
{upc/btb910za-upc.i}
{include/i-freeac.i}
{esp/es0018.i} /* Definiá∆o da Temp-Table "tt-prog-ponto" */

/* Local Temp-Table Definitions ---                                     */
DEFINE VARIABLE c-arquivo-aux    AS CHARACTER   NO-UNDO.
DEFINE TEMP-TABLE tt-ordens NO-UNDO
    FIELD embarque     LIKE ordens-embarque.embarque
    FIELD numero-ordem LIKE ordens-embarque.numero-ordem
    FIELD it-codigo    LIKE item.it-codigo
    FIELD descricao    AS CHARACTER FORMAT "x(200)":U
    FIELD class-fiscal AS CHARACTER
    FIELD destaque     AS CHARACTER
    FIELD seq-suframa  AS CHARACTER
    FIELD neces-li     AS CHARACTER
    FIELD numero-Li    AS CHARACTER
    FIELD perc-gatt    AS CHARACTER
    FIELD ex           AS CHARACTER FORMAT "x(3)":U
    FIELD nve          AS CHARACTER FORMAT "x(50)":U
    FIELD quantidade   LIKE ordens-embarque.quantidade
    FIELD un           LIKE prazo-compra.un
    FIELD perc-bruto   AS CHARACTER FORMAT "x(12)":U
    FIELD perc-liq     AS CHARACTER FORMAT "x(12)":U
    FIELD perc-peso-b  AS CHARACTER FORMAT "x(12)":U
    FIELD perc-peso-l  AS CHARACTER FORMAT "x(12)":U
    FIELD preco-unit   AS CHARACTER FORMAT "x(12)":U
    FIELD preco-qtd    AS CHARACTER FORMAT "x(12)":U
    FIELD ge-codigo    LIKE ITEM.ge-codigo
    FIELD desc-ge      LIKE grup-estoq.descricao
    FIELD aliq-clas      AS DEC
    INDEX chPrimario IS PRIMARY
        embarque
        class-fiscal
        it-codigo.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE wh-pesquisa       AS HANDLE              NO-UNDO.
DEFINE VARIABLE i-page            AS INTEGER             NO-UNDO INITIAL 1.
DEFINE VARIABLE c-remetente       AS CHARACTER           NO-UNDO INITIAL "intelbras@intelbras.com.br":U.
DEFINE VARIABLE l-ok              AS LOGICAL             NO-UNDO.
DEFINE VARIABLE c-ci              AS CHARACTER           NO-UNDO FORMAT "x(30)":U.
DEFINE VARIABLE c-titulo          AS CHARACTER           NO-UNDO FORMAT "x(50)":U.
DEFINE VARIABLE c-icms            AS CHARACTER           NO-UNDO FORMAT "x(3)":U.
DEFINE VARIABLE de-tot-invoice    AS DECIMAL             NO-UNDO.
DEFINE VARIABLE c-dt-venc-invoice AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-vl-invoice      AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-tot-invoice     AS CHARACTER           NO-UNDO.
DEFINE VARIABLE de-pr-qtde-tot    AS DECIMAL             NO-UNDO.
DEFINE VARIABLE de-despesa-adic   AS DECIMAL             NO-UNDO.
DEFINE VARIABLE de-brut-tot       AS DECIMAL             NO-UNDO.
DEFINE VARIABLE de-liq-tot        AS DECIMAL             NO-UNDO.
DEFINE VARIABLE de-total-embarque AS DECIMAL             NO-UNDO.
DEFINE VARIABLE c-descricao       AS CHARACTER           NO-UNDO FORMAT "x(200)":U.
DEFINE VARIABLE c-preco-unit      AS CHARACTER           NO-UNDO FORMAT "x(12)":U.
DEFINE VARIABLE c-preco-qtd       AS CHARACTER           NO-UNDO FORMAT "x(12)":U.
DEFINE VARIABLE c-perc-bruto      AS CHARACTER           NO-UNDO FORMAT "x(12)":U.
DEFINE VARIABLE c-perc-liq        AS CHARACTER           NO-UNDO FORMAT "x(12)":U.
DEFINE VARIABLE c-perc-peso-b     AS CHARACTER           NO-UNDO FORMAT "x(12)":U.
DEFINE VARIABLE c-perc-peso-l     AS CHARACTER           NO-UNDO FORMAT "x(12)":U.
DEFINE VARIABLE c-nve             AS CHARACTER           NO-UNDO FORMAT "x(50)":U.
DEFINE VARIABLE c-brut-tot        AS CHARACTER           NO-UNDO FORMAT "x(12)":U.
DEFINE VARIABLE c-liq-tot         AS CHARACTER           NO-UNDO FORMAT "x(12)":U.
DEFINE VARIABLE c-pr-qtde-tot     AS CHARACTER           NO-UNDO FORMAT "x(12)":U.
DEFINE VARIABLE i-peso-bruto      LIKE item.peso-bruto   NO-UNDO.
DEFINE VARIABLE i-peso-liquido    LIKE item.peso-liquido NO-UNDO.
DEFINE VARIABLE c-class-fiscal    AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-destaque        AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-perc-gatt       AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-neces-li        AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-seq-suframa     AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-narrativa       AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-banco           AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-agencia         AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-conta           AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-aliq-ii         AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-log-ex          AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-aliq-ex         AS CHARACTER           NO-UNDO FORMAT "x(3)":U.
DEFINE VARIABLE c-moeda           AS CHARACTER           NO-UNDO.

DEFINE VARIABLE h-boin082i        AS HANDLE              NO-UNDO.
DEFINE VARIABLE de-aliq-ii        AS DECIMAL             NO-UNDO.
DEFINE VARIABLE de-aliq-ipi       AS DECIMAL             NO-UNDO.

DEFINE BUFFER b-ordens-embarque FOR ordens-embarque.

RUN inbo/boin082i.p PERSISTENT SET h-boin082i.

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
&Scoped-define List-1 fi-cod-estabel fi-embarque 
&Scoped-define List-4 fi-arq-htm-2 fi-arq-htm fi-email 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
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
     SIZE 100 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 100 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-embarque AS CHARACTER FORMAT "X(12)" 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 14.86 BY .88 NO-UNDO.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile-2 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE fi-arq-htm AS CHARACTER FORMAT "X(300)":U 
     LABEL "Arquivo CSV" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE fi-arq-htm-2 AS CHARACTER FORMAT "X(300)":U 
     LABEL "Arquivo HTML" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE fi-email AS CHARACTER FORMAT "X(200)":U 
     LABEL "E-Mail" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btExit AT ROW 1.13 COL 92.43 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 96.43 HELP
          "Ajuda" NO-TAB-STOP 
     btAcao AT ROW 16.75 COL 2
     rtToolBar AT ROW 16.54 COL 1
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 100.57 BY 17
         FONT 1.

DEFINE FRAME fPage2
     fi-arq-htm-2 AT ROW 2 COL 15 COLON-ALIGNED WIDGET-ID 4
     fi-arq-htm AT ROW 3.04 COL 15 COLON-ALIGNED
     fi-email AT ROW 4.04 COL 15 COLON-ALIGNED
     btFile-2 AT ROW 1.96 COL 67 HELP
          "Escolha do nome do arquivo" WIDGET-ID 2
     btFile AT ROW 3 COL 67 HELP
          "Escolha do nome do arquivo"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 97.43 BY 11.83
         FONT 1.

DEFINE FRAME fpage1
     fi-cod-estabel AT ROW 1.25 COL 16 COLON-ALIGNED WIDGET-ID 2
     fi-embarque AT ROW 2.25 COL 16 COLON-ALIGNED HELP
          "Informe C¢digo do Embarque"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 97.43 BY 11.83
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window Template
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
         HEIGHT             = 17
         WIDTH              = 100.57
         MAX-HEIGHT         = 31.71
         MAX-WIDTH          = 205.72
         VIRTUAL-HEIGHT     = 31.71
         VIRTUAL-WIDTH      = 205.72
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
/*{esp/eslib.i}*/
{esp/utp/envio-email.i}
{esp/ShowMsg.i}
{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fpage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
ASSIGN 
       btAcao:PRIVATE-DATA IN FRAME fpage0     = 
                "&Gerar,&Alterar".

/* SETTINGS FOR FRAME fpage1
   Custom                                                               */
/* SETTINGS FOR FILL-IN fi-cod-estabel IN FRAME fpage1
   1                                                                    */
/* SETTINGS FOR FILL-IN fi-embarque IN FRAME fpage1
   1                                                                    */
/* SETTINGS FOR FRAME fPage2
   L-To-R,COLUMNS                                                       */
/* SETTINGS FOR FILL-IN fi-arq-htm IN FRAME fPage2
   4                                                                    */
/* SETTINGS FOR FILL-IN fi-arq-htm-2 IN FRAME fPage2
   4                                                                    */
/* SETTINGS FOR FILL-IN fi-email IN FRAME fPage2
   4                                                                    */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage1
/* Query rebuild information for FRAME fpage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage1 */
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

    APPLY "LEAVE":U TO fi-arq-htm   IN FRAME fpage2.
    APPLY "LEAVE":U TO fi-arq-htm-2 IN FRAME fpage2.

    IF NOT CAN-FIND(FIRST embarque-imp NO-LOCK
                    WHERE embarque-imp.cod-estabel = INPUT FRAME fpage1 fi-cod-estabel
                      AND embarque-imp.embarque    = INPUT FRAME fpage1 fi-embarque) THEN DO:

        RUN ShowMessage (INPUT 1,
                         INPUT "Embarque n∆o encontrado":U,
                         INPUT "":U).

        RUN setFolder IN hFolder (INPUT 1).

        APPLY "ENTRY":U TO fi-embarque IN FRAME fpage1.

        RETURN NO-APPLY.
    END.


    IF INPUT FRAME fpage2 fi-arq-htm-2 = "":U THEN DO:
        RUN ShowMessage (INPUT 1,
                         INPUT "Arquivo HTML n∆o informado":U,
                         INPUT "":U).

        RUN setFolder IN hFolder (INPUT 2).

        APPLY "ENTRY":U TO fi-arq-htm-2 IN FRAME fpage2.

        RETURN NO-APPLY.
    END.

    IF INPUT FRAME fpage2 fi-arq-htm = "":U THEN DO:
        RUN ShowMessage (INPUT 1,
                         INPUT "Arquivo CSV n∆o informado":U,
                         INPUT "":U).

        RUN setFolder IN hFolder (INPUT 2).

        APPLY "ENTRY":U TO fi-arq-htm IN FRAME fpage2.

        RETURN NO-APPLY.
    END.

    IF INPUT FRAME fpage2 fi-email = "":U THEN DO:
        RUN ShowMessage (INPUT 1,
                         INPUT "Endereáo de E-Mail n∆o informado":U,
                         INPUT "":U).

        RUN setFolder IN hFolder (INPUT 2).

        APPLY "ENTRY":U TO fi-email IN FRAME fpage2.

        RETURN NO-APPLY.
    END.

    ASSIGN INPUT FRAME fpage1 {&List-1}.
    ASSIGN INPUT FRAME fpage2 {&List-4}.

    
    RUN piGeraTxt IN THIS-PROCEDURE.
    
    RUN piGeraHtml IN THIS-PROCEDURE.

    RUN piGeraMail IN THIS-PROCEDURE.
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


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wWindow
ON CHOOSE OF btFile IN FRAME fPage2
DO:
    SYSTEM-DIALOG GET-FILE fi-arq-htm
      FILTERS "CSV(*.csv*)" "*.csv*",
              "Todos os arquivos(*.*)" "*.*"
      INITIAL-FILTER 1
      ASK-OVERWRITE 
      DEFAULT-EXTENSION "csv"
      SAVE-AS
      UPDATE l-ok.

    IF l-ok THEN DISP fi-arq-htm WITH FRAME fpage2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFile-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile-2 wWindow
ON CHOOSE OF btFile-2 IN FRAME fPage2
DO:
    SYSTEM-DIALOG GET-FILE fi-arq-htm
      FILTERS "HTML(*.htm*)" "*.htm*",
              "Todos os arquivos(*.*)" "*.*"
      INITIAL-FILTER 1
      ASK-OVERWRITE 
      DEFAULT-EXTENSION "html"
      SAVE-AS
      UPDATE l-ok.

    IF l-ok THEN DISP fi-arq-htm WITH FRAME fpage2.
  
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


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME fi-arq-htm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-arq-htm wWindow
ON LEAVE OF fi-arq-htm IN FRAME fPage2 /* Arquivo CSV */
DO:

    /*
    IF  fi-arq-htm:SCREEN-VALUE IN FRAME fpage2 = "" THEN
        ASSIGN fi-arq-htm = SESSION:TEMP-DIRECTORY + "id.csv".

    DISPLAY fi-arq-htm
        WITH FRAME fpage2.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-arq-htm-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-arq-htm-2 wWindow
ON LEAVE OF fi-arq-htm-2 IN FRAME fPage2 /* Arquivo HTML */
DO:
    IF R-INDEX(INPUT fi-arq-htm-2, ".htm":U)  = 0 AND
       R-INDEX(INPUT fi-arq-htm-2, ".html":U) = 0 THEN DO:
        ASSIGN fi-arq-htm-2 = INPUT FRAME fPage2 fi-arq-htm-2 + ".html":U.

        DISPLAY fi-arq-htm-2
            WITH FRAME fpage4.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage1
&Scoped-define SELF-NAME fi-embarque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-embarque wWindow
ON ENTRY OF fi-embarque IN FRAME fpage1 /* Embarque */
DO:
  SELF:PRIVATE-DATA = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-embarque wWindow
ON F5 OF fi-embarque IN FRAME fpage1 /* Embarque */
DO:
    /*{include/zoomvar.i &prog-zoom="eszoom/z01escx220.w"
                       &campo="fi-embarque"
                       &campozoom="embarque"
                       &frame="fPage1"}*/
  
   {method/ZoomFields.i &ProgramZoom="cxzoom/z10cx220.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="fi-cod-estabel"
                         &Frame1="fPage1"
                         &FieldZoom2="embarque"
                         &FieldScreen2="fi-embarque"
                         &Frame2="fPage1"
                         &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-embarque wWindow
ON LEAVE OF fi-embarque IN FRAME fpage1 /* Embarque */
DO:
  DEF VAR c-desc-transp AS CHAR FORMAT "x(15)" NO-UNDO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-embarque wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-embarque IN FRAME fpage1 /* Embarque */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
    {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/*--- Seta cursor do mouse para lupa, quando estiver posicionado sobre o fill-in ---*/
IF fi-embarque:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1 THEN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterChangePage wWindow 
PROCEDURE afterChangePage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN getCurrentFolder IN hFolder (OUTPUT i-page).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST usuar_mestre FIELDS (cod_e_mail_local)
        WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK:

        IF usuar_mestre.cod_e_mail_local <> "":U THEN
            ASSIGN c-remetente = usuar_mestre.cod_e_mail_local
                   fi-email    = usuar_mestre.cod_e_mail_local.
    END.

    ASSIGN fi-cod-estabel = v_cod_estab_usuar
           fi-arq-htm     = SESSION:TEMP-DIRECTORY + "id.csv"
           fi-arq-htm-2   = SESSION:TEMP-DIRECTORY + "id.html".

    DISPLAY fi-cod-estabel
        WITH FRAME fPage1.

    DISPLAY fi-arq-htm
            fi-arq-htm-2
            fi-email
        WITH FRAME fPage2.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-transporte wWindow 
PROCEDURE pi-transporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-via-transp AS INTEGER NO-UNDO.
    DEF OUTPUT PARAM p-desc-via  AS CHAR FORMAT "x(15)" NO-UNDO.

    CASE p-via-transp:
        WHEN 1 THEN ASSIGN p-desc-via = "Rodovi†rio".
        WHEN 2 THEN ASSIGN p-desc-via = "Aerovi†rio".
        WHEN 3 THEN ASSIGN p-desc-via = "Mar°timo".
        WHEN 4 THEN ASSIGN p-desc-via = "Ferrovi†rio".
        WHEN 5 THEN ASSIGN p-desc-via = "Rodoferrovi†rio".
        WHEN 6 THEN ASSIGN p-desc-via = "Rodofluvial".
        WHEN 7 THEN ASSIGN p-desc-via = "Rodoaerovi†rio".
        WHEN 8 THEN ASSIGN p-desc-via = "outros".
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraHtml wWindow 
PROCEDURE piGeraHtml :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    STATUS DEFAULT "Gerando E-mail. Aguarde...":U.

    DEFINE VARIABLE c-transporte AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-val-seguro AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-aux        AS CHARACTER   NO-UNDO.
    
    OUTPUT TO VALUE(fi-arq-htm-2) CONVERT TARGET SESSION:CHARSET.

    FIND FIRST embarque-imp
        WHERE embarque-imp.cod-estabel = fi-cod-estabel
          AND embarque-imp.embarque    = fi-embarque NO-LOCK NO-ERROR.

    FIND FIRST ordens-embarque
        WHERE ordens-embarque.cod-estabel = fi-cod-estabel
          AND ordens-embarque.embarque    = fi-embarque NO-LOCK NO-ERROR.

    FIND FIRST ordem-compra
        WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.
        
    FIND FIRST emitente
        WHERE emitente.cod-emite = ordem-compra.cod-emitente NO-LOCK NO-ERROR.

    ASSIGN c-ci = "":U.

    RUN html-inicio (INPUT "Instrucao de Desembaraco":U).

    ASSIGN c-titulo = emitente.nome-abrev + " - Embarque: ":U + fi-embarque + " - Estabelecimento: ":U + embarque-imp.cod-estabel + " - HOUSE nr.: ":U + embarque-imp.cod-conhecto-master.

    c-icms = "NAO".

    RUN html-titulo (INPUT c-titulo).
    
    RUN html-ini-tab.
    RUN html-ini-lin-tab.
    RUN html-cab-tab-colspan (INPUT "Invoice":U,
                              INPUT "3":U).
    RUN html-fim-lin-tab.

    RUN html-ini-lin-tab.
    RUN html-cab-tab (INPUT "Nr. Invoice":U).
    RUN html-cab-tab (INPUT "Data Vencimento":U).
    RUN html-cab-tab (INPUT "Valor da Invoice":U).
    RUN html-fim-lin-tab.

    ASSIGN de-tot-invoice = 0.

    FOR EACH invoice-emb-imp NO-LOCK
       WHERE invoice-emb-imp.cod-estabel = embarque-imp.cod-estabel
         AND invoice-emb-imp.embarque    = embarque-imp.embarque:

        ASSIGN c-dt-venc-invoice = STRING(invoice-emb-imp.dt-vencim, "99/99/9999":U)
               c-vl-invoice      = STRING(invoice-emb-imp.vl-invoice, ">>>>>,>>>,>>9.99":U)
               de-tot-invoice    = de-tot-invoice + invoice-emb-imp.vl-invoice.

        RUN html-ini-lin-tab.
        RUN html-con-tab(INPUT invoice-emb-imp.nr-invoice,
                         INPUT "left":U).
        RUN html-con-tab(INPUT c-dt-venc-invoice,
                         INPUT "center":U).
        RUN html-con-tab(INPUT c-vl-invoice,
                         INPUT "right":U).
        RUN html-fim-lin-tab.
    END.

    ASSIGN c-tot-invoice = STRING(de-tot-invoice, ">>>>>,>>>,>>9.99":U).

    RUN html-ini-lin-tab.
    RUN html-con-tab (INPUT " ":U,
                      INPUT "center":U).
    RUN html-con-tab (INPUT " ":U,
                      INPUT "center":U).
    RUN html-con-tab (INPUT c-tot-invoice,
                      INPUT "right":U).
    RUN html-fim-tab.

    ASSIGN de-pr-qtde-tot = 0.

    FOR EACH ordens-embarque NO-LOCK
        WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
          AND ordens-embarque.embarque    = embarque-imp.embarque
        BY ordens-embarque.embarque:

        FIND FIRST ordem-compra
            WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.

        IF AVAILABLE ordem-compra THEN
            ASSIGN de-pr-qtde-tot  = de-pr-qtde-tot + (ordens-embarque.quantidade * ordem-compra.preco-unit).
    END.

    RUN html-ini-tab.

    RUN html-ini-lin-tab.
    RUN html-cab-tab(INPUT "Ordem":U).
    RUN html-cab-tab(INPUT "Item":U).
    RUN html-cab-tab(INPUT "Descricao":U).
    RUN html-cab-tab(INPUT "Grupo Estoque":U).
    RUN html-cab-tab(INPUT "Descricao GE":U).
    RUN html-cab-tab(INPUT "Class. Fiscal":U).
    RUN html-cab-tab(INPUT "Aliq II":U).
    RUN html-cab-tab(INPUT "Destaque":U).
    RUN html-cab-tab(INPUT "Sequencial Suframa":U).
    RUN html-cab-tab(INPUT "LI":U).
    RUN html-cab-tab(INPUT "Numero LI":U).
    RUN html-cab-tab(INPUT "Perc. GATT":U).
    RUN html-cab-tab(INPUT "Ex":U).
    RUN html-cab-tab(INPUT "NVE":U).
    RUN html-cab-tab(INPUT "Quantidade":U).
    RUN html-cab-tab(INPUT "UN":U).
    RUN html-cab-tab(INPUT "Peso Bruto":U).
    RUN html-cab-tab(INPUT "Peso Liq.":U).
    RUN html-cab-tab(INPUT "Preco Unit.":U).
    RUN html-cab-tab(INPUT "TOTAL":U).
    RUN html-fim-lin-tab.

    ASSIGN de-brut-tot       = 0
           de-liq-tot        = 0
           de-total-embarque = de-pr-qtde-tot
           de-pr-qtde-tot    = 0.

    EMPTY TEMP-TABLE tt-ordens.

    FOR EACH  ordens-embarque NO-LOCK
        WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
          AND ordens-embarque.embarque    = embarque-imp.embarque:

        FIND FIRST tt-perc
            WHERE tt-perc.reg = RECID(ordens-embarque) NO-ERROR.

        FIND FIRST ordem-compra
            WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.

        FIND FIRST item
            WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

        FIND FIRST int-item
            WHERE int-item.it-codigo = item.it-codigo NO-LOCK NO-ERROR.

        FIND LAST cotacao-item
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
              AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
              AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.

        IF AVAILABLE cotacao-item THEN
            FIND FIRST int-cotacao-item OF cotacao-item NO-LOCK NO-ERROR.

        ASSIGN c-class-fiscal = "":U
               c-destaque     = "":U
               c-perc-gatt    = "":U
               c-neces-li     = "":U
               c-aliq-ii      = "":U
               c-log-ex       = "":U
               c-aliq-ex      = "":U
               c-nve          = "":U.

        IF  item.tipo-contr = 4 /* D≤bito Direto */ THEN DO:
            ASSIGN c-class-fiscal = TRIM(REPLACE(SUBSTRING(cotacao-item.char-1, 81, 20), ".":U, "":U)).

            IF AVAILABLE int-cotacao-item THEN
                ASSIGN c-destaque     = IF int-cotacao-item.destaque = ? THEN "?":U ELSE STRING(int-cotacao-item.destaque, "999":U)
                       c-perc-gatt    = STRING(int-cotacao-item.perc-gatt, ">>9.99":U)
                       c-neces-li     = STRING(int-cotacao-item.log-necessita-li, "Sim/Nío":U)
                       c-log-ex       = STRING(int-cotacao-item.ex-tarifario <> "","Sim/Nío")
                       c-aliq-ex      = IF int-cotacao-item.ex-tarifario <> "":U THEN int-cotacao-item.ex-tarifario ELSE "NA":U
                       c-nve          = IF int-cotacao-item.nve          <> "":U THEN int-cotacao-item.nve          ELSE "&nbsp;":U.
            ELSE
                ASSIGN c-log-ex  = "&nbsp;":U
                       c-aliq-ex = "&nbsp;":U
                       c-nve     = "&nbsp;":U.
                
                
            /*ASSIGN c-aliq-ii = SUBSTRING(cotacao-item.char-1,61,20).*/

            IF  VALID-HANDLE(h-boin082i) THEN DO:

                run setConstraintRowid in h-boin082i (input ROWID(cotacao-item)) no-error.
                run openQueryStatic    in h-boin082i (input "Rowid":U) no-error.
                
                ASSIGN c-aliq-ii = string(DEC(SUBSTRING(cotacao-item.char-1,61,6))). 

            END. /* IF  VALID-HANDLE(h-boin082i) THEN DO: */
        END.
        ELSE DO:
            IF AVAILABLE int-item THEN
                ASSIGN c-log-ex  = STRING(int-item.ex-tarifario <> "","Sim/Nío")
                       c-aliq-ex = IF int-item.ex-tarifario <> "":U THEN int-item.ex-tarifario ELSE "NA":U
                       c-nve     = IF int-item.nve          <> "":U THEN int-item.nve          ELSE "&nbsp;":U.
            ELSE
                ASSIGN c-log-ex  = "&nbsp;":U
                       c-aliq-ex = "&nbsp;":U
                       c-nve     = "&nbsp;":U.

            ASSIGN c-aliq-ii = STRING(SUBSTR(ITEM.char-2,22,6)).
        END.


        IF c-class-fiscal = "":U THEN
            ASSIGN c-class-fiscal = item.class-fiscal.

        IF c-neces-li = "":U THEN
            ASSIGN c-neces-li = STRING(item.log-necessita-li, "Sim/Nío":U).

        IF AVAILABLE int-item THEN DO:
            IF c-destaque = "":U THEN
                ASSIGN c-destaque = IF int-item.destaque = ? THEN "?":U ELSE STRING(int-item.destaque, "999":U).

            IF c-perc-gatt = "":U THEN
                ASSIGN c-perc-gatt = STRING(int-item.perc-gatt, ">>9.99":U).
        END.

        /*rotina para buscar narrativa do estabelecimento*/
        RUN esp/es0204.p (INPUT  ordem-compra.cod-estabel,
                          INPUT  ordem-compra.it-codigo,
                          OUTPUT c-narrativa).

        ASSIGN c-descricao    = "PO - ":U + STRING(ordem-compra.num-pedido, ">>>>>,>>9":U) /*ordens-embarque.embarque*/ + " - ":U + (IF item.tipo-contr = 4 THEN ordem-compra.narrativa ELSE c-narrativa + " - P/N - ":U + item.it-codigo)
               c-descricao    = fn-free-accent(c-descricao)
               c-descricao    = REPLACE(REPLACE(c-descricao, CHR(10), " ":U), CHR(13), " ":U)
               de-brut-tot    = de-brut-tot + (IF AVAILABLE tt-perc THEN (i-peso-bruto * tt-perc.perc-bruto) ELSE item.peso-bruto)
               de-liq-tot     = de-liq-tot + (IF AVAILABLE tt-perc THEN (i-peso-liquido * tt-perc.perc-liq) ELSE item.peso-liquido)
               de-pr-qtde-tot = de-pr-qtde-tot + (ordens-embarque.qt-do-forn * cotacao-item.pre-unit-for)
               c-preco-unit   = STRING(cotacao-item.pre-unit-for, ">>>>>,>>>,>>9.99999":U)
               c-preco-qtd    = STRING((cotacao-item.pre-unit-for * ordens-embarque.qt-do-forn), ">,>>>,>>9.99":U).

        IF AVAILABLE tt-perc THEN
            ASSIGN c-perc-bruto  = STRING(tt-perc.perc-bruto, ">>9.99":U)
                   c-perc-liq    = STRING(tt-perc.perc-liq, ">>9.99":U)
                   c-perc-peso-b = STRING((tt-perc.perc-bruto * i-peso-bruto), ">>,>>9.999999":U)
                   c-perc-peso-l = STRING((tt-perc.perc-liq * i-peso-liquido), ">>,>>9.999999":U).
        ELSE
            ASSIGN c-perc-bruto  = STRING(100, ">>9.99":U)
                   c-perc-liq    = STRING(100, ">>9.99":U)
                   c-perc-peso-b = STRING(item.peso-bruto, ">>,>>9.999999":U)
                   c-perc-peso-l = STRING(item.peso-liquido, ">>,>>9.999999":U).

        FIND FIRST int-item OF item NO-LOCK NO-ERROR.

        IF AVAILABLE int-item THEN
            ASSIGN c-seq-suframa = int-item.seq-suframa.
        ELSE
            ASSIGN c-seq-suframa = "&nbsp;":U.
            
        FIND FIRST licenciam-import-oc 
            WHERE licenciam-import-oc.numero-ordem = ordens-embarque.numero-ordem
              AND licenciam-import-oc.parcela      = ordens-embarque.parcela NO-LOCK NO-ERROR.  
        
        CREATE tt-ordens.
        ASSIGN tt-ordens.embarque     = ordens-embarque.embarque
               tt-ordens.numero-ordem = ordens-embarque.numero-ordem
               tt-ordens.it-codigo    = ITEM.it-codigo
               tt-ordens.descricao    = c-descricao
               tt-ordens.class-fiscal = c-class-fiscal
               tt-ordens.destaque     = c-destaque
               tt-ordens.seq-suframa  = c-seq-suframa
               tt-ordens.neces-li     = c-neces-li
               tt-ordens.numero-li    = if avail licenciam-import-oc then licenciam-import-oc.licenca-import  else '' 
               tt-ordens.perc-gatt    = c-perc-gatt
               tt-ordens.ex           = c-aliq-ex
               tt-ordens.nve          = c-nve
               tt-ordens.quantidade   = ordens-embarque.qt-do-forn
               tt-ordens.un           = IF AVAIL cotacao-item THEN cotacao-item.un ELSE ""
               tt-ordens.perc-bruto   = c-perc-bruto
               tt-ordens.perc-liq     = c-perc-liq
               tt-ordens.perc-peso-b  = c-perc-peso-b
               tt-ordens.perc-peso-l  = c-perc-peso-l
               tt-ordens.preco-unit   = c-preco-unit
               tt-ordens.preco-qtd    = c-preco-qtd
               tt-ordens.ge-codigo    = ITEM.ge-codigo
               tt-ordens.aliq-clas    = DECIMAL(c-aliq-ii).

        FIND grup-estoq NO-LOCK
            WHERE grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.
        IF  AVAIL grup-estoq THEN
            ASSIGN tt-ordens.desc-ge = grup-estoq.descricao.
        
    END.

    FOR EACH tt-ordens
        BREAK BY tt-ordens.embarque:

        RUN html-ini-lin-tab.
        RUN html-con-tab (INPUT tt-ordens.numero-ordem,
                          INPUT "left":U).
        RUN html-con-tab (INPUT tt-ordens.it-codigo,
                          INPUT "left":U).
        RUN html-con-tab (INPUT tt-ordens.descricao,
                          INPUT "left":U).
        RUN html-con-tab (INPUT tt-ordens.ge-codigo,
                          INPUT "left":U).
        RUN html-con-tab (INPUT tt-ordens.desc-ge,
                          INPUT "left":U).
        RUN html-con-tab (INPUT tt-ordens.class-fiscal,
                          INPUT "left":U).
        RUN html-con-tab (INPUT tt-ordens.aliq-clas,
                          INPUT "right":U).
        RUN html-con-tab (INPUT tt-ordens.destaque,
                          INPUT "left":U).
        RUN html-con-tab (INPUT tt-ordens.seq-suframa,
                          INPUT "left":U). 
        RUN html-con-tab (INPUT tt-ordens.neces-li,
                          INPUT "left":U).
        RUN html-con-tab (INPUT tt-ordens.numero-li,
                          INPUT "left":U).
        RUN html-con-tab (INPUT tt-ordens.perc-gatt,
                          INPUT "right":U).
        RUN html-con-tab (INPUT tt-ordens.ex,
                          INPUT "left":U).
        RUN html-con-tab (INPUT tt-ordens.nve,
                          INPUT "left":U).
        RUN html-con-tab (INPUT tt-ordens.quantidade,
                          INPUT "right":U).
        RUN html-con-tab (INPUT tt-ordens.un,
                          INPUT "right":U).
        RUN html-con-tab (INPUT tt-ordens.perc-peso-b,
                          INPUT "right":U).
        RUN html-con-tab (INPUT tt-ordens.perc-peso-l,
                          INPUT "right":U).
        RUN html-con-tab (INPUT tt-ordens.preco-unit, 
                          INPUT "right":U).  
        RUN html-con-tab (INPUT tt-ordens.preco-qtd,
                          INPUT "right":U).
        RUN html-fim-lin-tab.

        IF LAST-OF(tt-ordens.embarque) THEN DO:
            ASSIGN c-brut-tot    = STRING(de-brut-tot, ">>,>>9.999999":U)
                   c-liq-tot     = STRING(de-liq-tot, ">>,>>9.999999":U)
                   c-pr-qtde-tot = STRING(de-pr-qtde-tot, ">,>>>,>>9.99":U).

            RUN html-ini-lin-tab.
            RUN html-con-tab (INPUT " ":U,
                              INPUT "center":U).
            RUN html-con-tab (INPUT " ":U,
                              INPUT "center":U).
            RUN html-con-tab (INPUT " ":U,
                              INPUT "center":U).
            RUN html-con-tab (INPUT " ":U,
                              INPUT "center":U).
            RUN html-con-tab (INPUT " ":U,
                              INPUT "center":U).
            RUN html-con-tab (INPUT " ":U,
                              INPUT "center":U).
            RUN html-con-tab (INPUT " ":U,
                              INPUT "center":U).
            RUN html-con-tab (INPUT " ":U,
                              INPUT "center":U).
            RUN html-con-tab (INPUT " ":U,
                              INPUT "center":U).
            RUN html-con-tab (INPUT " ":U,
                              INPUT "center":U).
            RUN html-con-tab (INPUT " ":U,
                              INPUT "center":U).
            RUN html-con-tab (INPUT " ":U,
                              INPUT "center":U).
            RUN html-con-tab (INPUT " ":U,
                              INPUT "center":U).
            RUN html-con-tab (INPUT " ":U,
                              INPUT "right":U).
            RUN html-con-tab (INPUT " ":U,       
                              INPUT "center":U). 
            RUN html-con-tab (INPUT " ":U,       
                              INPUT "center":U). 
            RUN html-con-tab (INPUT c-brut-tot,
                              INPUT "right":U).
            RUN html-con-tab (INPUT c-liq-tot,
                              INPUT "right":U).
            RUN html-con-tab (INPUT " ":U,       
                              INPUT "center":U). 
            RUN html-con-tab (INPUT c-pr-qtde-tot,
                              INPUT "right":U).
            RUN html-fim-lin-tab.
        END.
    END.

    RUN html-fim.

    OUTPUT CLOSE.

    /*
    /* Converter para xlsx */
    DEF VAR excelappl     AS COM-HANDLE NO-UNDO.
    DEF VAR ChWorkSheet   AS COM-HANDLE NO-UNDO.

    CREATE "excel.application" excelappl.

    ASSIGN c-arquivo-aux = fi-arq-htm-2. 
           c-arquivo-aux = SUBSTR(c-arquivo-aux,1, INDEX(c-arquivo-aux,".")) + "xls".

    excelappl:workbooks:ADD(fi-arq-htm-2).
    excelappl:Workbooks:Item(1):SaveAs(c-arquivo-aux,,,,,,).

    excelappl:quit().


    RELEASE OBJECT excelappl   NO-ERROR.
    RELEASE OBJECT chWorksheet NO-ERROR.
    */
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraMail wWindow 
PROCEDURE piGeraMail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    STATUS DEFAULT "Enviando E-Mail...":U.

    ASSIGN c-endereco      = fi-email
           c-arquivo       = fi-arq-htm-2
           c-arquivo-2     = SESSION:TEMP-DIRECTORY + "desajustes":U
           c-texto-html[1] = "Segue arquivo contendo Instrucoes de desembaraco. ":U.

    RUN enviaMail (INPUT c-remetente,
                   INPUT c-endereco,
                   INPUT TRIM(c-titulo),
                   INPUT c-texto-html[1],
                   INPUT c-arquivo).

    STATUS DEFAULT.

    RUN ShowMessage (INPUT 2,
                     INPUT "E-Mail enviado com sucesso":U,
                     INPUT "":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraTxt wWindow 
PROCEDURE piGeraTxt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    STATUS DEFAULT "Gerando Arquivo Excel. Aguarde...".

    DEFINE VARIABLE c-transporte AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-val-seguro AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-aux        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-dt-aux     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-dt-aux-1   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE fi-arq-csv   AS CHARACTER   NO-UNDO.

    ASSIGN fi-arq-csv = fi-arq-htm.

    OUTPUT TO VALUE(fi-arq-csv) CONVERT TARGET SESSION:CHARSET.

    FIND FIRST embarque-imp
        WHERE  embarque-imp.cod-estabel = fi-cod-estabel
          AND  embarque-imp.embarque    = fi-embarque NO-LOCK NO-ERROR.

    FIND FIRST ordens-embarque
        WHERE  ordens-embarque.cod-estabel = fi-cod-estabel
          AND  ordens-embarque.embarque    = fi-embarque NO-LOCK NO-ERROR.

    FIND FIRST ordem-compra
        WHERE  ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.
    
    FIND FIRST emitente
        WHERE  emitente.cod-emite = ordem-compra.cod-emitente NO-LOCK NO-ERROR.

    ASSIGN c-titulo = emitente.nome-abrev + " - Embarque: ":U + fi-embarque + " - Estabelecimento: ":U + embarque-imp.cod-estabel + " - HOUSE nr.: ":U + embarque-imp.cod-conhecto-master.
    /*       c-icms   = IF tb-icms THEN "SIM":U ELSE "NAO":U.

    PUT c-titulo FORMAT "x(80)":U SKIP.*/
    
    /*PUT "Regime de Tributacao;Natureza do Pedido;Dados Bancarios;Referencia":U FORMAT "x(132)":U SKIP.

    RUN esp/es0018p.p (INPUT  "{&Program}":U, /* Nome Programa */
                       INPUT  1,              /* Ponto */
                       INPUT  0,              /* SeqÅància */
                       INPUT  "":U,           /* Conte£do */
                       OUTPUT TABLE tt-prog-ponto).

    FOR EACH tt-prog-ponto:
        CASE tt-prog-ponto.sequencia:
            WHEN 1 THEN
                ASSIGN c-banco = TRIM(tt-prog-ponto.conteudo).
            WHEN 2 THEN
                ASSIGN c-agencia = TRIM(tt-prog-ponto.conteudo).
            WHEN 3 THEN
                ASSIGN c-conta = TRIM(tt-prog-ponto.conteudo).
        END CASE.
    END.

    PUT UNFORMATTED STRING(fi-reg) ";":U STRING(fi-nat) ";":U "Banco: ":U c-banco " C/C: ":U c-conta " Agencia: ":U c-agencia FORMAT "x(132)":U SKIP.*/

    PUT UNFORMATTED "Forcenecdor:;" + emitente.nome-abrev SKIP.
    PUT UNFORMATTED "Embarque:;" + fi-embarque SKIP.
    PUT UNFORMATTED "Estabelecimento:;" + embarque-imp.cod-estabel SKIP.
    PUT UNFORMATTED "House:;" + embarque-imp.cod-conhecto-house SKIP. 
    /*PUT UNFORMATTED "Regime de Tributacao:;" + fi-reg SKIP.*/
    PUT UNFORMATTED "Banco:;" + c-banco SKIP.
    PUT UNFORMATTED "Conta:;" + c-conta SKIP.
    PUT UNFORMATTED "Agància:;" + c-agencia SKIP.
    PUT UNFORMATTED "Modal:;" + {adinc/i01ad268.i 04 embarque-imp.cod-via-transp} SKIP.
    PUT UNFORMATTED "Recolhimento ICMS:;" + c-icms SKIP(2).

/*     PUT "Navio;Transbordo;Nß Lote;Data Chegada;Transporte":U FORMAT "x(132)":U SKIP.                                                 */
/*                                                                                                                                      */
/*     IF fi-dt-chegada = ? THEN                                                                                                        */
/*         ASSIGN c-aux = "":U.                                                                                                         */
/*     ELSE                                                                                                                             */
/*         ASSIGN c-aux = STRING(fi-dt-chegada).                                                                                        */
/*                                                                                                                                      */
/*     ASSIGN c-transporte = cb-transporte:SCREEN-VALUE IN FRAME fpage2.                                                                */
/*                                                                                                                                      */
/*     PUT STRING(fi-navio) ";":U STRING(fi-transbordo) ";":U STRING(fi-nr-lote) ";":U c-aux ";":U c-transporte FORMAT "x(132)":U SKIP. */
/*     PUT "Solicitaá∆o Numer†rio;Data Desistància;Data Registro;Valor Seguro;Exigància Fiscal":U FORMAT "x(132)":U SKIP.               */

    /*IF fi-dt-desist = ? THEN
        ASSIGN c-aux = "":U.
    ELSE
        ASSIGN c-aux = STRING(fi-dt-desist).

    IF fi-dt-reg = ? THEN
        ASSIGN c-dt-aux = "":U.
    ELSE
        ASSIGN c-dt-aux = STRING(fi-dt-reg).

    ASSIGN c-val-seguro = STRING(fi-val-seguro).

    PUT STRING(fi-solic-num) ";":U c-aux ";":U c-dt-aux ";":U c-val-seguro ";(  ) Sim  (  ) N∆o":U FORMAT "x(132)":U SKIP.
    PUT "Canal Conferància;Data Vistoria Fiscal;Data Exigància Fiscal;Desistància Vistoria;Nß DI":U FORMAT "x(132)":U SKIP.

    IF fi-dt-vist-fiscal = ? THEN
        ASSIGN c-aux = "":U.
    ELSE
        ASSIGN c-aux = STRING(fi-dt-vist-fiscal).

    IF fi-dt-exig-fiscal = ? THEN
        ASSIGN c-dt-aux = "":U.
    ELSE
        ASSIGN c-dt-aux = STRING(fi-dt-exig-fiscal).

    PUT STRING(fi-can-conf) ";":U c-aux ";":U c-dt-aux ";":U "(  ) Sim  (  ) N∆o" ";":U STRING(fi-nr-di) FORMAT "x(132)":U SKIP.
    PUT "Data Recebimento Recibos;Data Conferància F°sica;Recebimento Numer†rios;Data Desembaraáo;Avaria":U FORMAT "x(132)":U SKIP.

    IF fi-dt-rec-recibos = ? THEN
        ASSIGN c-aux = "":U.
    ELSE
        ASSIGN c-aux = STRING(fi-dt-rec-recibos).

    IF fi-dt-chegada = ? THEN
        ASSIGN c-dt-aux = "":U.
    ELSE
        ASSIGN c-dt-aux = STRING(fi-dt-conf-fisica).

    IF fi-dt-desembaraco = ? THEN
        ASSIGN c-dt-aux-1 = "":U.
    ELSE
        ASSIGN c-dt-aux-1 = STRING(fi-dt-desembaraco).

    PUT c-aux ";":U c-dt-aux ";":U STRING(fi-rec-num) ";":U c-dt-aux-1 "(  )  Sim  (  )  N∆o":U FORMAT "x(132)":U SKIP.
    PUT "Master;Veiculo;Transportador/Armador":U FORMAT "x(80)":U SKIP.
    PUT STRING(fi-master) ";":U STRING(fi-veiculo) ";":U STRING(fi-trans) FORMAT "x(80)" SKIP.
    PUT "Frete;Valor do Frete;Data de Embarque;Previsao de Chegada" FORMAT "x(80)" SKIP.
    PUT STRING(fi-frete) ";":U STRING(fi-val-frete) ";":U STRING(fi-dt-emb) ";":U STRING(fi-dt-che) FORMAT "x(80)":U SKIP.

    ASSIGN c-aux = "":U.

    IF fi-nr-pagamento <> 0 THEN
        ASSIGN c-aux = "Nr.Contrato/Banco/Praca;":U.

    ASSIGN c-aux = c-aux + "Pagamento;Via Transporte;Incoterm;Recolhimento ICMS":U.

    PUT c-aux FORMAT "x(132)":U SKIP.

    ASSIGN c-aux = "":U.

    IF fi-nr-pagamento <> 0 THEN
        ASSIGN c-aux = STRING(c-ci) + ";":U.

    ASSIGN c-aux = c-aux + STRING(fi-pagamento) + ";":U + STRING(embarque-imp.cod-via-transp) + ";":U + STRING(embarque-imp.cod-incoterm) + ";":U + STRING(c-icms).

    PUT c-aux FORMAT "x(132)":U SKIP.
    PUT "LIs":U SKIP.

    IF fi-li-1 <> "":U THEN
        ASSIGN c-aux = STRING(fi-li-1) + ";":U.
    ELSE
        ASSIGN c-aux = ";":U.

    IF fi-li-2 <> "":U THEN
        ASSIGN c-aux = c-aux + STRING(fi-li-1) + ";":U.
    ELSE
        ASSIGN c-aux = c-aux + ";":U.

    IF fi-li-3 <> "" THEN
        ASSIGN c-aux = c-aux + STRING(fi-li-1) + ";":U.
    ELSE
        ASSIGN c-aux = c-aux + ";":U.*/

    PUT /*c-aux FORMAT "x(80)":U SKIP*/
        "Invoice":U FORMAT "x(20)":U SKIP
        "Nr. Invoice;Data Vencimento;Valor da Invoice;Moeda":U FORMAT "x(80)":U SKIP.

    ASSIGN de-tot-invoice = 0.

    FOR EACH invoice-emb-imp NO-LOCK
        WHERE invoice-emb-imp.cod-estabel = embarque-imp.cod-estabel
          AND invoice-emb-imp.embarque    = embarque-imp.embarque:

        FIND FIRST moeda NO-LOCK
             WHERE moeda.mo-codigo = invoice-emb-imp.mo-codigo NO-ERROR.

        ASSIGN c-dt-venc-invoice = STRING(invoice-emb-imp.dt-vencim, "99/99/9999":U)
               c-vl-invoice      = trim(STRING(invoice-emb-imp.vl-invoice))
               de-tot-invoice    = de-tot-invoice + invoice-emb-imp.vl-invoice
               c-moeda           = moeda.descricao.
        ASSIGN c-aux = STRING(invoice-emb-imp.nr-invoice) + ";" + c-dt-venc-invoice + ";" + c-vl-invoice + ";" + c-moeda.
        
        PUT UNFORMATTED c-aux SKIP.
    END.

    ASSIGN c-tot-invoice = STRING(de-tot-invoice, ">>>>>,>>>,>>9.99":U).

    IF CAN-FIND (FIRST invoice-emb-imp
                 WHERE invoice-emb-imp.cod-estabel = embarque-imp.cod-estabel
                   AND invoice-emb-imp.embarque    = embarque-imp.embarque) THEN
        PUT ";;":U c-tot-invoice FORMAT "x(40)":U SKIP.

    ASSIGN de-pr-qtde-tot = 0.

    FOR EACH ordens-embarque NO-LOCK
        WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
          AND ordens-embarque.embarque    = embarque-imp.embarque
        BREAK BY ordens-embarque.embarque:

        FIND FIRST ordem-compra
            WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.

        IF AVAILABLE ordem-compra THEN
            ASSIGN de-pr-qtde-tot  = de-pr-qtde-tot + (ordens-embarque.quantidade * ordem-compra.preco-unit).
    END.

    ASSIGN c-aux = "Ordem;Item;Descricao;Grupo Estoque;Descricao GE;Class. Fiscal;Aliq. Imp;Destaque;Sequencial Suframa;LI;Numero LI;Perc.GATT;Ex;NVE;Quantidade;UN;Perc. Bruto;Perc. Liq.;Preco Unit.;TOTAL":U.

    PUT UNFORMATTED c-aux SKIP.

    ASSIGN de-brut-tot       = 0
           de-liq-tot        = 0
           de-total-embarque = de-pr-qtde-tot
           de-pr-qtde-tot    = 0.

    EMPTY TEMP-TABLE tt-ordens.

    FOR EACH  ordens-embarque NO-LOCK
        WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
          AND ordens-embarque.embarque    = embarque-imp.embarque:

        FIND FIRST tt-perc
            WHERE tt-perc.reg = RECID(ordens-embarque) NO-ERROR.

        FIND FIRST ordem-compra
            WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.

        FIND FIRST item
            WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

        FIND FIRST int-item
            WHERE int-item.it-codigo = item.it-codigo NO-LOCK NO-ERROR.

        FIND LAST cotacao-item
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
              AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
              AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.

        IF AVAILABLE cotacao-item THEN
            FIND FIRST int-cotacao-item OF cotacao-item NO-LOCK NO-ERROR.

        ASSIGN c-class-fiscal = "":U
               c-destaque     = "":U
               c-perc-gatt    = "":U
               c-neces-li     = "":U
               c-aliq-ii      = "":U
               c-log-ex       = "":U
               c-aliq-ex      = "":U
               c-nve          = "":U.

        IF  item.tipo-contr = 4 /* DÇbito Direto */ THEN DO:
            ASSIGN c-class-fiscal = TRIM(REPLACE(SUBSTRING(cotacao-item.char-1, 81, 20), ".":U, "":U)).

            IF AVAILABLE int-cotacao-item THEN
                ASSIGN c-destaque     = IF int-cotacao-item.destaque = ? THEN "?":U ELSE STRING(int-cotacao-item.destaque, "999":U)
                       c-perc-gatt    = STRING(int-cotacao-item.perc-gatt, ">>9.99":U)
                       c-neces-li     = STRING(int-cotacao-item.log-necessita-li, "Sim/N∆o":U)
                       c-log-ex       = STRING(int-cotacao-item.ex-tarifario <> "","Sim/N∆o")
                       c-aliq-ex      = IF int-cotacao-item.ex-tarifario <> "":U THEN int-cotacao-item.ex-tarifario ELSE "NA":U
                       c-nve          = IF int-cotacao-item.nve          <> "":U THEN int-cotacao-item.nve          ELSE "&nbsp;":U.
            ELSE
                ASSIGN c-log-ex  = "&nbsp;":U
                       c-aliq-ex = "&nbsp;":U
                       c-nve     = "&nbsp;":U.
                
                
            /*ASSIGN c-aliq-ii = SUBSTRING(cotacao-item.char-1,61,20).*/

            IF  VALID-HANDLE(h-boin082i) THEN DO:
                run setConstraintRowid in h-boin082i (input ROWID(cotacao-item)) no-error.
                run openQueryStatic    in h-boin082i (input "Rowid":U) no-error.

                ASSIGN c-aliq-ii = STRING(DEC(SUBSTRING(cotacao-item.char-1,61,6))).

            END. /* IF  VALID-HANDLE(h-boin082i) THEN DO: */
        END.
        ELSE DO:
            IF AVAILABLE int-item THEN
                ASSIGN c-log-ex  = STRING(int-item.ex-tarifario <> "","Sim/N∆o")
                       c-aliq-ex = IF int-item.ex-tarifario <> "":U THEN int-item.ex-tarifario ELSE "NA":U
                       c-nve     = IF int-item.nve          <> "":U THEN int-item.nve          ELSE "&nbsp;":U.
            ELSE
                ASSIGN c-log-ex  = "&nbsp;":U
                       c-aliq-ex = "&nbsp;":U
                       c-nve     = "&nbsp;":U.


            /* FIND classif-fisc NO-LOCK */
/*                 WHERE classif-fisc.class-fiscal = tt-ordens.class-fiscal NO-ERROR. */
/*             IF  AVAIL classif-fisc THEN */
/*                 ASSIGN c-aliq-ii = SUBSTRING(classif-fisc.char-1,1,20). */

            ASSIGN c-aliq-ii = STRING(SUBSTR(ITEM.char-2,22,6)).
        END.
        
        IF c-class-fiscal = "":U THEN
            ASSIGN c-class-fiscal = item.class-fiscal.

        IF c-neces-li = "":U THEN
            ASSIGN c-neces-li = STRING(item.log-necessita-li, "Sim/N∆o":U).

        IF AVAILABLE int-item THEN DO:
            IF c-destaque = "":U THEN
                ASSIGN c-destaque = IF int-item.destaque = ? THEN "?":U ELSE STRING(int-item.destaque, "999":U).
            IF c-perc-gatt = "":U THEN
                ASSIGN c-perc-gatt = IF int-item.log-gatt THEN STRING(int-item.perc-gatt, ">>9.99":U) ELSE "0,00":U.
        END.

        /*rotina para buscar narrativa do estabelecimento*/
        RUN esp/es0204.p (INPUT  ordem-compra.cod-estabel,
                          INPUT  ordem-compra.it-codigo,
                          OUTPUT c-narrativa).

        ASSIGN c-aux          = "":U
               c-descricao    = "PO - ":U + STRING(ordem-compra.num-pedido, ">>>>>,>>9":U) /*ordens-embarque.embarque*/ + " - ":U + (IF item.tipo-contr = 4 THEN ordem-compra.narrativa ELSE c-narrativa + " - P/N - ":U + item.it-codigo)
               c-descricao    = fn-free-accent(c-descricao)
               c-descricao    = REPLACE(REPLACE(c-descricao, CHR(10), " ":U), CHR(13), " ":U)
               de-brut-tot    = de-brut-tot + (IF AVAILABLE tt-perc THEN (i-peso-bruto * tt-perc.perc-bruto) ELSE item.peso-bruto)
               de-liq-tot     = de-liq-tot + (IF AVAILABLE tt-perc THEN (i-peso-liquido * tt-perc.perc-liq) ELSE item.peso-liquido)
               de-pr-qtde-tot = de-pr-qtde-tot + (ordens-embarque.qt-do-forn * cotacao-item.pre-unit-for)
               c-preco-unit   = STRING(cotacao-item.pre-unit-for, ">>>>>,>>>,>>9.99999":U)
               c-preco-qtd    = STRING((cotacao-item.pre-unit-for * ordens-embarque.qt-do-forn), ">>>,>>>9.99":U).

        IF AVAILABLE tt-perc THEN
            ASSIGN c-perc-bruto  = STRING(tt-perc.perc-bruto, ">>9.99":U)
                   c-perc-liq    = STRING(tt-perc.perc-liq, ">>9.99":U)
                   c-perc-peso-b = STRING((tt-perc.perc-bruto * i-peso-bruto), ">>>>9.999999":U)
                   c-perc-peso-l = STRING((tt-perc.perc-liq * i-peso-liquido), ">>>>9.999999":U).
        ELSE
            ASSIGN c-perc-bruto  = STRING(100, ">>9.99":U)
                   c-perc-liq    = STRING(100, ">>9.99":U)
                   c-perc-peso-b = STRING(item.peso-bruto, ">>>>9.999999":U)
                   c-perc-peso-l = STRING(item.peso-liquido, ">>>>9.999999":U).

        FIND FIRST int-item OF item NO-LOCK NO-ERROR.

        IF AVAILABLE int-item THEN
            ASSIGN c-seq-suframa = int-item.seq-suframa.
        ELSE
            ASSIGN c-seq-suframa = "":U.


        FIND FIRST licenciam-import-oc 
            WHERE licenciam-import-oc.numero-ordem = ordens-embarque.numero-ordem
              AND licenciam-import-oc.parcela      = ordens-embarque.parcela NO-LOCK NO-ERROR.  
        
        CREATE tt-ordens.
        ASSIGN tt-ordens.embarque     = ordens-embarque.embarque
               tt-ordens.numero-ordem = ordens-embarque.numero-ordem
               tt-ordens.it-codigo    = item.it-codigo
               tt-ordens.descricao    = c-descricao
               tt-ordens.class-fiscal = c-class-fiscal
               tt-ordens.destaque     = c-destaque
               tt-ordens.seq-suframa  = c-seq-suframa
               tt-ordens.neces-li     = c-neces-li
               tt-ordens.numero-li    = if avail licenciam-import-oc then licenciam-import-oc.licenca-import  else ''
               tt-ordens.perc-gatt    = IF c-perc-gatt <> ? THEN c-perc-gatt ELSE ""
               tt-ordens.ex           = c-aliq-ex
               tt-ordens.nve          = c-nve
               tt-ordens.quantidade   = ordens-embarque.qt-do-forn
               tt-ordens.un           = IF AVAIL cotacao-item THEN cotacao-item.un ELSE ""
               tt-ordens.perc-bruto   = c-perc-bruto
               tt-ordens.perc-liq     = c-perc-liq
               tt-ordens.perc-peso-b  = c-perc-peso-b
               tt-ordens.perc-peso-l  = c-perc-peso-l
               tt-ordens.preco-unit   = c-preco-unit
               tt-ordens.preco-qtd    = c-preco-qtd
               tt-ordens.ge-codigo    = ITEM.ge-codigo             
               tt-ordens.aliq-clas    = DECIMAL(c-aliq-ii).

        FIND grup-estoq NO-LOCK
            WHERE grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.
        IF  AVAIL grup-estoq THEN
            ASSIGN tt-ordens.desc-ge = grup-estoq.descricao.
        
    END.

    FOR EACH tt-ordens
        BREAK BY tt-ordens.embarque:

        ASSIGN c-aux = STRING(tt-ordens.numero-ordem) + ";":U +
                       tt-ordens.it-codigo            + ";":U +
                       REPLACE(tt-ordens.descricao,";","") + ";":U +
                       STRING(tt-ordens.ge-codigo)    + ";":U +
                       tt-ordens.desc-ge              + ";":U +
                       tt-ordens.class-fiscal         + ";":U +
                       STRING(tt-ordens.aliq-clas)    + ";":U +
                       tt-ordens.destaque             + ";":U +
                       tt-ordens.seq-suframa          + ";":U +
                       tt-ordens.neces-li             + ";":U +
                       tt-ordens.numero-li            + ";":U +
                       tt-ordens.perc-gatt            + ";":U +
                       tt-ordens.ex                   + ";":U +
                       tt-ordens.nve                  + ";":U +
                       STRING(tt-ordens.quantidade)   + ";":U +
                       tt-ordens.un                   + ";":U +
                       tt-ordens.perc-peso-b          + ";":U +
                       tt-ordens.perc-peso-l          + ";":U +
                       tt-ordens.preco-unit           + ";":U +
                       tt-ordens.preco-qtd.

        PUT UNFORMATTED c-aux SKIP.

        IF LAST-OF(tt-ordens.embarque) THEN DO:
            ASSIGN c-brut-tot    = STRING(de-brut-tot, ">>>>9.999999":U)
                   c-liq-tot     = STRING(de-liq-tot, ">>>>9.999999":U)
                   c-pr-qtde-tot = STRING(de-pr-qtde-tot, ">>>>,>>9.99":U)
                   c-aux         = ";;;;;;;;;;;;;;;;":U + c-brut-tot + ";":U + c-liq-tot + ";;":U + c-pr-qtde-tot.

            PUT UNFORMATTED c-aux SKIP.
        END.
    END.

    PUT SKIP(1).
    /*PUT "Dados do Exportador;":U           + TRIM(fi-exportador)       FORMAT "x(132)":U SKIP.
    PUT "Dados do Importador;":U           + TRIM(fi-importador)       FORMAT "x(132)":U SKIP.
    PUT "Dados do Fabricante;":U           + TRIM(fi-fabricante)       FORMAT "x(132)":U SKIP.
    PUT "Pais de Origem;":U                + TRIM(fi-pais)             FORMAT "x(132)":U SKIP.
    PUT "Descricao;":U                     + TRIM(fi-descricao)        FORMAT "x(132)":U SKIP.
    PUT "Preco Unitario e Total;":U        + TRIM(fi-preco-unit-tot)   FORMAT "x(132)":U SKIP.
    PUT "Quantidade/Especie de Volumes;":U + TRIM(fi-qtd-esp-vol)      FORMAT "x(132)":U SKIP.
    PUT "Condicoes/Moeda de Pagamento;":U  + TRIM(fi-cond-moeda-pagto) FORMAT "x(132)":U SKIP.
    PUT "Incoterm;":U                      + TRIM(fi-incoterm)         FORMAT "x(132)":U SKIP.
    PUT "Peso Bruto;":U                    + TRIM(fi-peso-bruto)       FORMAT "x(132)":U SKIP.
    PUT "Peso Liquido;":U                  + TRIM(fi-peso-liq)         FORMAT "x(132)":U SKIP.
    PUT "Rateio de Peso Liquido;":U        + TRIM(fi-rateio-peso-liq)  FORMAT "x(132)":U SKIP.
    PUT "URF de Entrada;":U                + TRIM(fi-urf-entr)         FORMAT "x(132)":U SKIP.
    PUT "URF de Despacho;":U               + TRIM(fi-urf-desp)         FORMAT "x(132)":U SKIP.
    PUT "Destino Mercadoria;":U            + TRIM(fi-destino-merc)     FORMAT "x(132)":U SKIP.*/

    OUTPUT CLOSE.

/*     ASSIGN c-endereco      = fi-email                                                 */
/*            c-arquivo       = fi-arq-csv                                               */
/*            c-texto-html[1] = "Segue arquivo contendo Instrucoes de desembaraco. ":U.  */
/*                                                                                       */
/*                                                                                       */
/*     RUN enviaMail (INPUT c-remetente,                                                 */
/*                    INPUT c-endereco,                                                  */
/*                    INPUT TRIM(c-titulo),                                              */
/*                    INPUT c-texto-html[1],                                             */
/*                    INPUT c-arquivo).                                                  */
/*                                                                                       */
/*     STATUS DEFAULT.                                                                   */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

