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
{include/i-prgvrs.i escep019 2.04.000.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escep019
&GLOBAL-DEFINE Version        2.04.000.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE page0Widgets   btExit btHelp 
&GLOBAL-DEFINE page1Widgets   fi-cod-depos fi-cod-localiz fi-desc-local fi-nome-dep rs-entrada 
&GLOBAL-DEFINE page2Widgets   fi-nr-ae fi-nr-ae-2 fi-quantidade fi-sequencia fi-sequencia-fim fi-sequencia-ini fi-localizacao btVoltar btTransferir
&GLOBAL-DEFINE page3Widgets   fi-codigo
&GLOBAL-DEFINE page4Widgets   brItem fi-num-etiquetas
                              
/* Parameters Definitions ---                                           */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

def temp-table tt-item NO-UNDO
    field it-codigo like item.it-codigo
    FIELD desc-item LIKE ITEM.desc-item
    field nr-ae like ae-item.nr-ae
    field sequencia like ae-item.sequencia
    field quantidade like ae-item.quantidade
    field localizacao like ae-item.localizacao
    field cod-depos like deposito.cod-depos.

def var c-it-codigo like item.it-codigo NO-UNDO.
def var da-prox-ae-item as DATE NO-UNDO.
def var c-anterior as char format "x(40)" NO-UNDO.
def var reg as RECID NO-UNDO.
def var c-historico as CHAR NO-UNDO.
def var c-etiqueta as char format "x(19)" NO-UNDO.
DEF VAR l-deu-erro AS LOGICAL NO-UNDO.
def var c-codigo as char format "x(26)" NO-UNDO.
def var c-deposito like deposito.cod-depos NO-UNDO.
def var i-quantidade as DEC NO-UNDO.
def var c-msg-erro as char format "x(70)" NO-UNDO.
DEFINE VARIABLE h-cdapi024 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-ceapi001k AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-unid-negoc AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.
                           
{upc\btb910za-upc.i}
{esp/es0007.i} /* Busca conta de transferencia */
{cep/ceapi001k.i}
{cdp/cd9590.i}
{esp/es0018.i}
/*{cdp/cd0666.i} 

   
DEF BUFFER b-tt-erro FOR tt-erro.
  
  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brItem

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-item

/* Definitions for BROWSE brItem                                        */
&Scoped-define FIELDS-IN-QUERY-brItem tt-item.it-codigo tt-item.desc-item tt-item.nr-ae tt-item.sequencia tt-item.quantidade tt-item.localizacao tt-item.cod-depos   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brItem   
&Scoped-define SELF-NAME brItem
&Scoped-define QUERY-STRING-brItem FOR EACH tt-item
&Scoped-define OPEN-QUERY-brItem OPEN QUERY {&SELF-NAME} FOR EACH tt-item.
&Scoped-define TABLES-IN-QUERY-brItem tt-item
&Scoped-define FIRST-TABLE-IN-QUERY-brItem tt-item


/* Definitions for FRAME fPage4                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage4 ~
    ~{&OPEN-QUERY-brItem}

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
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE fi-cod-depos AS CHARACTER FORMAT "x(3)" 
     LABEL "Dep¢sito":R10 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-localiz AS CHARACTER FORMAT "x(10)" 
     LABEL "Localiza‡Æo":R14 
     VIEW-AS FILL-IN 
     SIZE 14.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-local AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-dep AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 41.14 BY .88 NO-UNDO.

DEFINE VARIABLE rs-entrada AS LOGICAL 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Digita‡Æo", yes,
"Leitor", no
     SIZE 12 BY 1.75 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 6.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27.43 BY 2.75.

DEFINE BUTTON btTransferir 
     LABEL "&Transferir" 
     SIZE 10 BY 1.

DEFINE BUTTON btVoltar 
     LABEL "&Voltar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-localizacao AS CHARACTER FORMAT "x(12)" 
     LABEL "Localiza‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-ae AS INTEGER FORMAT "9999999" INITIAL 0 
     LABEL "N£mero do AE" 
     VIEW-AS FILL-IN 
     SIZE 7.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-ae-2 AS INTEGER FORMAT "9999999" INITIAL 0 
     LABEL "Nr AE" 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-quantidade AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Quantidade" 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-sequencia AS INTEGER FORMAT "999" INITIAL 0 
     LABEL "Seqˆncia" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-sequencia-fim AS INTEGER FORMAT "999" INITIAL 0 
     LABEL "Seqˆncia Final" 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .88.

DEFINE VARIABLE fi-sequencia-ini AS INTEGER FORMAT "999" INITIAL 0 
     LABEL "Seqˆncia Inicial" 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .88.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 6.

DEFINE VARIABLE fi-codigo AS CHARACTER FORMAT "X(26)":U 
     LABEL "C¢digo de Barras" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 TOOLTIP "Informe o item" NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 6.

DEFINE VARIABLE fi-num-etiquetas AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "Etiquetas" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     BGCOLOR 15 FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 9.75.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brItem FOR 
      tt-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brItem wWindow _FREEFORM
  QUERY brItem DISPLAY
      tt-item.it-codigo format "x(7)"
    tt-item.desc-item format "x(32)" 
    tt-item.nr-ae
    tt-item.sequencia
    tt-item.quantidade
    tt-item.localizacao
    tt-item.cod-depos
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-BOX NO-ROW-MARKERS SEPARATORS SIZE 69 BY 8
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda" NO-TAB-STOP 
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.33
         FONT 1.

DEFINE FRAME fPage1
     fi-cod-depos AT ROW 1.17 COL 9.57 COLON-ALIGNED HELP
          "Informe o dep¢sito de destino"
     fi-nome-dep AT ROW 1.17 COL 19.57 HELP
          "Descri‡Æo do Dep¢sito" NO-LABEL NO-TAB-STOP 
     fi-cod-localiz AT ROW 2.17 COL 9.57 COLON-ALIGNED HELP
          "Informe o local de destino"
     fi-desc-local AT ROW 2.17 COL 26.57 NO-LABEL NO-TAB-STOP 
     rs-entrada AT ROW 4.25 COL 15 NO-LABEL
     "Deseja entrar com AE's por" VIEW-AS TEXT
          SIZE 20 BY .54 AT ROW 3.5 COL 14
     RECT-12 AT ROW 1 COL 1
     RECT-6 AT ROW 3.75 COL 11.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.5 SCROLLABLE 
         FONT 1.

DEFINE FRAME fPage4
     brItem AT ROW 1.25 COL 11.57
     fi-num-etiquetas AT ROW 9.5 COL 79 RIGHT-ALIGNED NO-TAB-STOP 
     RECT-15 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 8.5
         SIZE 90 BY 9.75
         FONT 1.

DEFINE FRAME fpage3
     fi-codigo AT ROW 3.25 COL 20 HELP
          "Pressione F4 para voltar" AUTO-RETURN 
     RECT-14 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.5
         SIZE 90 BY 6
         FONT 1.

DEFINE FRAME fpage2
     fi-nr-ae AT ROW 1.17 COL 16.72 COLON-ALIGNED AUTO-RETURN 
     fi-it-codigo AT ROW 1.17 COL 50 COLON-ALIGNED NO-TAB-STOP 
     fi-sequencia-ini AT ROW 2.17 COL 16.72 COLON-ALIGNED AUTO-RETURN 
     fi-nr-ae-2 AT ROW 2.17 COL 50 COLON-ALIGNED NO-TAB-STOP 
     fi-sequencia-fim AT ROW 3.17 COL 16.72 COLON-ALIGNED AUTO-RETURN 
     fi-sequencia AT ROW 3.17 COL 50 COLON-ALIGNED NO-TAB-STOP 
     fi-localizacao AT ROW 4.17 COL 50 COLON-ALIGNED NO-TAB-STOP 
     btTransferir AT ROW 4.25 COL 19
     fi-quantidade AT ROW 5.17 COL 50 COLON-ALIGNED NO-TAB-STOP 
     btVoltar AT ROW 5.75 COL 80
     RECT-13 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.5
         SIZE 90 BY 6
         FONT 1
         DEFAULT-BUTTON btTransferir.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window Template
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
         HEIGHT             = 17.33
         WIDTH              = 90
         MAX-HEIGHT         = 19.88
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 19.88
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

{esp/ShowMsg.i}
{window/window.i}
{esp/eslib.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fpage2:FRAME = FRAME fpage0:HANDLE
       FRAME fpage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
   Size-to-Fit                                                          */
ASSIGN 
       FRAME fPage1:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN fi-desc-local IN FRAME fPage1
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       fi-desc-local:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN fi-nome-dep IN FRAME fPage1
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       fi-nome-dep:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FRAME fpage2
                                                                        */
ASSIGN 
       FRAME fpage2:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fi-it-codigo IN FRAME fpage2
   NO-ENABLE                                                            */
ASSIGN 
       fi-it-codigo:READ-ONLY IN FRAME fpage2        = TRUE.

/* SETTINGS FOR FILL-IN fi-localizacao IN FRAME fpage2
   NO-ENABLE                                                            */
ASSIGN 
       fi-localizacao:READ-ONLY IN FRAME fpage2        = TRUE.

/* SETTINGS FOR FILL-IN fi-nr-ae-2 IN FRAME fpage2
   NO-ENABLE                                                            */
ASSIGN 
       fi-nr-ae-2:READ-ONLY IN FRAME fpage2        = TRUE.

/* SETTINGS FOR FILL-IN fi-quantidade IN FRAME fpage2
   NO-ENABLE                                                            */
ASSIGN 
       fi-quantidade:READ-ONLY IN FRAME fpage2        = TRUE.

/* SETTINGS FOR FILL-IN fi-sequencia IN FRAME fpage2
   NO-ENABLE                                                            */
ASSIGN 
       fi-sequencia:READ-ONLY IN FRAME fpage2        = TRUE.

/* SETTINGS FOR FRAME fpage3
                                                                        */
ASSIGN 
       FRAME fpage3:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fi-codigo IN FRAME fpage3
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* BROWSE-TAB brItem RECT-15 fPage4 */
/* SETTINGS FOR FILL-IN fi-num-etiquetas IN FRAME fPage4
   NO-ENABLE ALIGN-R                                                    */
ASSIGN 
       fi-num-etiquetas:READ-ONLY IN FRAME fPage4        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brItem
/* Query rebuild information for BROWSE brItem
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-item.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brItem */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage2
/* Query rebuild information for FRAME fpage2
     _Query            is NOT OPENED
*/  /* FRAME fpage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage3
/* Query rebuild information for FRAME fpage3
     _Query            is NOT OPENED
*/  /* FRAME fpage3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
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


&Scoped-define FRAME-NAME fpage2
&Scoped-define SELF-NAME btTransferir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btTransferir wWindow
ON CHOOSE OF btTransferir IN FRAME fpage2 /* Transferir */
DO:
    DEF VAR l-achou AS LOGICAL NO-UNDO.
    FOR EACH ae-item NO-LOCK                                          WHERE
             ae-item.cod-estabel = v_cod_estab_usuar and
             ae-item.nr-ae = INPUT FRAME fpage2 fi-nr-ae              AND
             ae-item.sequencia >= INPUT FRAME fpage2 fi-sequencia-ini AND
             ae-item.sequencia <= INPUT FRAME fpage2 fi-sequencia-fim AND NOT
             ae-item.situacao:
        l-achou = YES.
        DISP ae-item.it-codigo   @ fi-it-codigo 
             ae-item.nr-ae       @ fi-nr-ae-2
             ae-item.sequencia   @ fi-sequencia 
             ae-item.localizacao @ fi-localizacao
             ae-item.quantidade  @ fi-quantidade
             WITH FRAME fpage2.
    END.

    IF NOT l-achou THEN DO:
       RUN ShowMessage (1, "AE informada nÆo encontrada ou j  baixada", "").
       APPLY "entry" TO fi-nr-ae IN FRAME fpage2.
       RETURN NO-APPLY. 
    END.

    RUN ShowMessage (3, "Confirma a trasferˆncia?", "").
    IF RETURN-VALUE = "no" THEN DO:
       APPLY "entry" TO fi-nr-ae IN FRAME fpage2.
       RETURN NO-APPLY. 
    END.

    DISABLE btTransferir btVoltar WITH FRAME fpage2.
    SESSION:SET-WAIT-STATE("GENERAL":U).
    RUN pi-transfere.  
    SESSION:SET-WAIT-STATE("":U).
    ENABLE btTransferir btVoltar WITH FRAME fpage2.
    IF CAN-FIND(FIRST tt-erro) THEN 
        RUN cdp/cd0666.w (INPUT TABLE tt-erro).

    APPLY "entry" TO fi-nr-ae IN FRAME fpage2.
    RETURN NO-APPLY. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btTransferir wWindow
ON t OF btTransferir IN FRAME fpage2 /* Transferir */
OR T OF btTransferir IN FRAME {&FRAME-NAME} DO:
    APPLY "choose" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btVoltar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVoltar wWindow
ON CHOOSE OF btVoltar IN FRAME fpage2 /* Voltar */
DO:
    HIDE FRAME fpage2.
    HIDE FRAME fpage3.
    VIEW FRAME fpage1.
    APPLY "entry" TO fi-cod-depos IN FRAME fpage1.

    for each tt-item:
        DELETE tt-item.
    end.
    {&OPEN-QUERY-brItem}       
    assign fi-num-etiquetas = 0.
    DISP fi-num-etiquetas WITH FRAME fpage4.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVoltar wWindow
ON v OF btVoltar IN FRAME fpage2 /* Voltar */
OR V OF btVoltar IN FRAME {&FRAME-NAME} DO:
    APPLY "choose" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fi-cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos wWindow
ON F5 OF fi-cod-depos IN FRAME fPage1 /* Dep¢sito */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in084"
                       &campo="fi-nome-dep"
                       &campozoom="nome"
                       &frame="fPage1"
                       &campo2="fi-cod-depos"
                       &campozoom2="cod-depos"
                       &frame2="fPage1"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos wWindow
ON LEAVE OF fi-cod-depos IN FRAME fPage1 /* Dep¢sito */
DO:
    {include/leave.i &tabela=deposito
                     &atributo-ref=nome
                     &variavel-ref=fi-nome-dep
                     &where="deposito.cod-depos = fi-cod-depos:screen-value in frame fPage1"}
    c-deposito = INPUT fi-cod-depos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-depos IN FRAME fPage1 /* Dep¢sito */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-localiz wWindow
ON F5 OF fi-cod-localiz IN FRAME fPage1 /* Localiza‡Æo */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in189"
                       &campo="fi-desc-local"
                       &campozoom="descricao"
                       &frame="fPage1"
                       &campo2="fi-cod-localiz"
                       &campozoom2="cod-localiz"
                       &frame2="fPage1"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-localiz wWindow
ON LEAVE OF fi-cod-localiz IN FRAME fPage1 /* Localiza‡Æo */
DO:
    {include/leave.i &tabela=mgcad.localizacao
                     &atributo-ref=descricao
                     &variavel-ref=fi-desc-local
                     &where="localizacao.cod-localiz = fi-cod-localiz:screen-value in frame fPage1"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-localiz wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-localiz IN FRAME fPage1 /* Localiza‡Æo */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME fi-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-codigo wWindow
ON F4 OF fi-codigo IN FRAME fpage3 /* C¢digo de Barras */
DO:
    APPLY "choose" TO btVoltar IN FRAME fpage2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-codigo wWindow
ON LEAVE OF fi-codigo IN FRAME fpage3 /* C¢digo de Barras */
DO:
    c-codigo = INPUT fi-codigo.  
    RUN pi-leitor.
    DISP "" @ fi-codigo WITH FRAME fpage3.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-codigo wWindow
ON RETURN OF fi-codigo IN FRAME fpage3 /* C¢digo de Barras */
DO:
  APPLY "leave" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME rs-entrada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-entrada wWindow
ON d OF rs-entrada IN FRAME fPage1
OR D OF rs-entrada IN FRAME {&FRAME-NAME} DO:
  rs-entrada:SCREEN-VALUE = "yes".
  APPLY "value-changed" TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-entrada wWindow
ON l OF rs-entrada IN FRAME fPage1
OR L OF rs-entrada IN FRAME {&FRAME-NAME} DO:
    rs-entrada:SCREEN-VALUE = "no".
    APPLY "value-changed" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-entrada wWindow
ON RETURN OF rs-entrada IN FRAME fPage1
OR TAB OF rs-entrada IN FRAME {&FRAME-NAME} DO:
  APPLY "value-changed" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-entrada wWindow
ON VALUE-CHANGED OF rs-entrada IN FRAME fPage1
DO:
  FOR FIRST local NO-LOCK
      WHERE local.cod-estabel = v_cod_estab_usuar
        and local.local = INPUT FRAME fpage1 fi-cod-localiz:
  END.
  IF NOT AVAIL local THEN DO:
      run utp/ut-msgs.p (input "show":U, input 2, input "Local":U).
      APPLY "entry" TO fi-cod-localiz IN FRAME fpage1.
      RETURN NO-APPLY.
  END.
  FOR first tipo-local no-lock 
      WHERE tipo-local.cod-estabel = v_cod_estab_usuar
      and   tipo-local.cod-tipo = local.cod-tipo 
      AND   tipo-local.descricao begins "ENTRE":
  END.
  IF NOT AVAIL tipo-local THEN DO:
      RUN ShowMessage (1, "O tipo do local nÆo ‚ ~"entreposto~"", "").
      APPLY "entry" TO fi-cod-localiz IN FRAME fpage1.
      RETURN NO-APPLY.
  END.
  FOR /*FIRST param-estoq NO-LOCK,*/
      first saldo-estoq no-lock 
      WHERE saldo-estoq.cod-estabel = v_cod_estab_usuar
      and   saldo-estoq.qtidade-atu <> 0  
      and   saldo-estoq.cod-localiz = INPUT FRAME fpage1 fi-cod-localiz 
      and   saldo-estoq.cod-depos = INPUT FRAME fpage1 fi-cod-depos:
      RUN ShowMessage (3, "Local informado possui saldo no sistema", 
                       "Confirma?").
      IF RETURN-VALUE = "no" THEN DO:
          APPLY "entry" TO fi-cod-localiz IN FRAME fpage1.
          RETURN NO-APPLY.
      END.
  END.

  HIDE FRAME fPage1.
  IF INPUT rs-entrada THEN DO:
      VIEW FRAME fPage2.
      APPLY "entry" TO fi-nr-ae IN FRAME fpage2.
  END.
  ELSE DO:
      VIEW FRAME fPage3.
      APPLY "entry" TO fi-codigo IN FRAME fpage3.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brItem
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterdestroyInterface wWindow 
PROCEDURE AfterdestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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
    fi-cod-depos:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
    fi-cod-localiz:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
    APPLY "entry" TO fi-cod-depos IN FRAME fpage1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leitor wWindow 
PROCEDURE pi-leitor PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def var c-digito     as int  format "9" initial 0 NO-UNDO.
   def var c-quantidade as char format "x(06)" NO-UNDO.
   DEF var c-ae         as char format "x(07)" NO-UNDO.
   DEF var c-sequencia  as char format "x(03)" NO-UNDO.
   def var c-linha      as char format "x(20)" NO-UNDO.
   def var i-it-digito  as integer format "9" initial 0 NO-UNDO.
   def var i-cod-emitente like emitente.cod-emitente NO-UNDO.
   def var i-sequencia as INT NO-UNDO.

   if length(trim(c-codigo)) <> 23 and
      length(trim(c-codigo)) <> 26 then do:
      assign c-msg-erro = "Tamanho da Etiqueta Incorreto. Chame o Respons vel".
      run trata-erro.
      DISP "" @ fi-codigo WITH FRAME fpage3.
      RETURN.
   end.   

   if length(trim(c-codigo)) = 23 then do:
      assign c-digito = int(substring(c-codigo,23,1))
             c-it-codigo  = substring(c-codigo,1,7) 
             c-quantidade = substring(c-codigo,8,5) 
             c-ae         = substring(c-codigo,13,7)
             c-sequencia  = substring(c-codigo,20,3)
             c-linha  = c-it-codigo + c-quantidade + c-ae +
                                  c-sequencia.

      run esp/es0135(input c-linha,output i-it-digito).

   end.
   else do: /* 26 digitos */

      assign c-it-codigo = substring(c-codigo,7,7)
             c-quantidade = substring(c-codigo,14,6)
             c-digito = int(substring(c-codigo,26,1))
             c-linha = substring(c-codigo,1,25).
      run esp/es0135(input c-linha, output i-it-digito).
               
      assign i-cod-emitente = int(substring(c-codigo,1,6))
             i-quantidade = int(substring(c-codigo,14,6))
             i-sequencia = int(substring(c-codigo,20,6)).
   end.

   if c-digito <> i-it-digito then do:
      assign c-msg-erro = "D¡gito verificador nÆo confere - Erro na leitura".
      run trata-erro.
      DISP "" @ fi-codigo WITH FRAME fpage3.
      RETURN.
   end.
 
   find item where item.it-codigo = c-it-codigo
        no-lock no-error.
            
   if not avail item then do:
      assign c-msg-erro = "Item nÆo Cadastrado: " + c-it-codigo.
      run trata-erro.
      DISP "" @ fi-codigo WITH FRAME fpage3.
      RETURN.
   end.
      
   find first ae-item use-index fifo              
        where ae-item.cod-estabel = v_cod_estab_usuar
          and ae-item.it-codigo = item.it-codigo 
          and ae-item.situacao = no no-error.
              
   if avail ae-item then 
      assign da-prox-ae-item = ae-item.data
             c-anterior = " AE " + string(ae-item.nr-ae) + "-" +
             string(ae-item.data).
      
   find ae-item 
        where ae-item.cod-estabel = v_cod_estab_usuar
          and ae-item.nr-ae     = int(c-ae)
          and ae-item.it-codigo = c-it-codigo
          and ae-item.sequencia = int(c-sequencia) no-error.

   if avail ae-item and ae-item.situacao = no then do:
 /*  Teste de fifo retirado por solicitacao do SR. Nei via SOS  
  
     if ae-item.data > da-prox-ae-item then do:
         {esp/esbell.i}
         assign reg = recid(ae-item).
         assign c-msg-erro = "Existe lote com data anterior" + c-anterior.
         run trata-erro.
      end.    */
   end.
   else do:
      assign c-msg-erro = "NÆo existe registro de AE / AE j  Baixado".
      run trata-erro.
      DISP "" @ fi-codigo WITH FRAME fpage3.
      RETURN.
   end.

   assign c-historico = ae-item.it-codigo + " - " +
                        string(ae-item.nr-ae) + " - " +
                        string(ae-item.sequencia) + " - " +
                        " - " + string(today) + 
                        " - " + string(time,"HH:MM:SS") + " - " + c-seg-usuario.
   SESSION:SET-WAIT-STATE("GENERAL":U).
   RUN pi-transfere2.
   SESSION:SET-WAIT-STATE("":U).
   IF CAN-FIND(FIRST tt-erro) THEN 
       RUN cdp/cd0666.w (INPUT TABLE tt-erro).
   ELSE RUN ShowMessage (2, "Transferˆncia executada com sucesso", "").
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-transfere wWindow 
PROCEDURE pi-transfere PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DO WITH FRAME fpage2:
       FOR EACH ae-item NO-LOCK                             WHERE
                ae-item.cod-estabel = v_cod_estab_usuar and
                ae-item.nr-ae      = INPUT fi-nr-ae         AND
                ae-item.sequencia >= INPUT fi-sequencia-ini AND
                ae-item.sequencia <= INPUT fi-sequencia-fim AND NOT 
                ae-item.situacao:
           FIND item NO-LOCK WHERE
                item.it-codigo = ae-item.it-codigo NO-ERROR.
           ASSIGN c-it-codigo  = ae-item.it-codigo.

           ASSIGN da-prox-ae-item = ae-item.data
                  c-anterior = " AE " + string(ae-item.nr-ae) + "-" + string(ae-item.data).
      
           IF ae-item.data > da-prox-ae-item THEN DO:
              ASSIGN reg = recid(ae-item).
              ASSIGN c-msg-erro = "Existe lote com data anterior" + c-anterior.
              run trata-erro.
           END.
 
           ASSIGN c-historico = c-etiqueta +
                                " - " + string(today) + 
                                " - " + string(time,"HH:MM:SS") + " - " +
                                 c-seg-usuario.
           RUN pi-transfere2.

           IF RETURN-VALUE = "NOK" THEN DO:
              IF c-msg-erro NE "Ocorreu um erro na transferˆncia" THEN
                  RUN ShowMessage (1, c-msg-erro, "").
              RETURN.  
           END.
       END.

       RUN ShowMessage (2, "Transferˆncia executada com sucesso", "").
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-transfere2 wWindow 
PROCEDURE pi-transfere2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DO TRANSACTION:
       c-msg-erro = "".
       RUN processa-transferencia. 
       IF l-deu-erro THEN DO:
          ASSIGN c-msg-erro = "Ocorreu um erro na transferˆncia" .
          RUN trata-erro.
          undo, RETURN "NOK".
       END.
    END.  /**** DO TRANSACTION  ****/
           
    CREATE tt-item.

    ASSIGN tt-item.it-codigo   = ae-item.it-codigo
           tt-item.desc-item   = ITEM.desc-item
           tt-item.nr-ae       = ae-item.nr-ae
           tt-item.sequencia   = ae-item.sequencia
           tt-item.quantidade  = ae-item.quantidade
           tt-item.localizacao = ae-item.localizacao
           tt-item.cod-depos   = INPUT FRAME fpage1 fi-cod-depos.

    ASSIGN fi-num-etiquetas = 0.
   
    FOR EACH tt-item:
        ASSIGN fi-num-etiquetas = fi-num-etiquetas + 1.
    END.

    DISP fi-num-etiquetas WITH FRAME fpage4.
    {&OPEN-QUERY-brItem}       
    IF fi-num-etiquetas >= BROWSE brItem:NUM-ITERATIONS then 
       reposition brItem to row fi-num-etiquetas - BROWSE brItem:NUM-ITERATIONS.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processa-transferencia wWindow 
PROCEDURE processa-transferencia PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF BUFFER b-ae-item FOR ae-item.

    IF congelado(input v_cod_estab_usuar,
                 input c-it-codigo,                    
                 input INPUT FRAME fpage1 fi-cod-depos,
                 input ae-item.localizacao) then do:

        RUN ShowMessage (1, "Item/Dep¢sito/Localiza‡Æo de Origem Congelada para Invent rio", 
                         SUBSTITUTE("Item/Dep¢sito/Localiza‡Æo de Origem Congelada para Invent rio: &1/&2/&3",
                                    TRIM(c-it-codigo),                                                          
                                    TRIM(INPUT FRAME fpage1 fi-cod-depos),                                      
                                    TRIM(ae-item.localizacao))).                                                
        undo, RETURN.
                  
    END.
                  
    IF congelado(input v_cod_estab_usuar,
                 input c-it-codigo,                      
                 input INPUT FRAME fpage1 fi-cod-depos,  
                 input INPUT FRAME fpage1 fi-cod-localiz) then do:
        RUN ShowMessage (1, "Item/Dep¢sito/Localiza‡Æo de Destino Congelada para Invent rio", 
                         SUBSTITUTE("Item/Dep¢sito/Localiza‡Æo de Origem Congelada para Invent rio: &1/&2/&3",
                                    TRIM(c-it-codigo),
                                    TRIM(INPUT FRAME fpage1 fi-cod-depos),
                                    TRIM(INPUT FRAME fpage1 fi-cod-localiz))).
                  
        undo, RETURN.
                  
    END.

    FOR EACH tt-movto.
        DELETE tt-movto.
    END.

    FOR EACH tt-erro:
        DELETE tt-erro.
    END.

    CREATE tt-movto. /* saida */
    ASSIGN tt-movto.cod-versao-integracao = 001
           tt-movto.cod-prog-orig = "{&Program}"
           tt-movto.cod-depos   = INPUT FRAME fpage1 fi-cod-depos
           tt-movto.cod-localiz = ae-item.localizacao
           tt-movto.cod-estabel = v_cod_estab_usuar
           tt-movto.ct-codigo   = pa-ct-codigo 
           tt-movto.sc-codigo   = pa-sc-codigo
           tt-movto.esp-docto   = 33
           tt-movto.it-codigo   = c-it-codigo
           tt-movto.nro-docto   = trim(string(ae-item.nr-ae))
           tt-movto.quantidade  = ae-item.quantidade
           tt-movto.serie-docto = string(ae-item.sequencia)
           tt-movto.tipo-trans  = 2     /* saida */
           tt-movto.un          = item.un
           tt-movto.num-sequen  = 1
           tt-movto.dt-trans    = today
           tt-movto.descricao-db = c-historico
           tt-movto.usuario      = c-seg-usuario.

    IF  l-unidade-negocio
    AND l-mat-unid-negoc THEN DO:
        run cdp/cdapi024.p persistent set h-cdapi024.
        if  valid-handle(h-cdapi024) then do:
            run retornaUnidadeNegocio IN h-cdapi024 (input tt-movto.cod-estabel,
                                                     input tt-movto.it-codigo,
                                                     input tt-movto.cod-depos,
                                                     output tt-movto.cod-unid-negoc).

            delete procedure h-cdapi024.
            assign h-cdapi024 = ?.
        end.

        ASSIGN c-unid-negoc = tt-movto.cod-unid-negoc.
    end.
    ELSE
        ASSIGN c-unid-negoc = "".

    CREATE tt-movto.   /* entrada */
    ASSIGN tt-movto.cod-versao-integracao = 001
           tt-movto.cod-prog-orig = "{&Program}"
           tt-movto.cod-depos   = INPUT FRAME fpage1 fi-cod-depos
           tt-movto.cod-localiz = INPUT FRAME fpage1 fi-cod-localiz
           tt-movto.cod-estabel = v_cod_estab_usuar
           tt-movto.ct-codigo   = pa-ct-codigo
           tt-movto.sc-codigo   = pa-sc-codigo
           tt-movto.esp-docto   = 33
           tt-movto.it-codigo   = c-it-codigo
           tt-movto.nro-docto   = trim(string(ae-item.nr-ae))
           tt-movto.quantidade  = ae-item.quantidade
           tt-movto.serie-docto = string(ae-item.sequencia)
           tt-movto.tipo-trans  = 1        /* entrada */
           tt-movto.un          = item.un
           tt-movto.num-sequen  = 1
           tt-movto.dt-trans    = today
           tt-movto.descricao-db = c-historico
           tt-movto.usuario      = c-seg-usuario
           tt-movto.cod-unid-negoc = IF  l-unidade-negocio AND l-mat-unid-negoc THEN c-unid-negoc ELSE "".


    run cep/ceapi001k.p persistent set h-ceapi001k.
    if  valid-handle (h-ceapi001k) then do:
        run pi-execute IN h-ceapi001k (input-output table tt-movto,
                                       input-output table tt-erro, 
                                       input        yes).

        delete procedure h-ceapi001k.
        assign h-ceapi001k = ?.
    end.

    FIND FIRST tt-erro no-error.

    IF AVAIL tt-erro then do:
       ASSIGN l-deu-erro = yes.
       UNDO, RETURN.
    END.

    IF NOT AVAIL tt-erro THEN DO:
       FIND FIRST b-ae-item OF ae-item EXCLUSIVE-LOCK NO-ERROR.
       ASSIGN b-ae-item.localizacao = INPUT FRAME fpage1 fi-cod-localiz.
       ASSIGN l-deu-erro = no.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trata-erro wWindow 
PROCEDURE trata-erro PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR i-saldo-ae AS INT NO-UNDO.
    if c-it-codigo <> "" then do:
    
       find item where item.it-codigo = c-it-codigo no-lock no-error.
      
       if avail item then do:


           EMPTY TEMP-TABLE tt-prog-ponto.

            RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                               INPUT 1,
                               INPUT 0,
                               INPUT "":U,
                               OUTPUT TABLE tt-prog-ponto).
            
            FOR FIRST tt-prog-ponto:
            
                ASSIGN c-dir-saida = replace(tt-prog-ponto.conteudo, "/", "~\").
            
                IF SUBSTRING(c-dir-saida, LENGTH(c-dir-saida), 1) <> "~\" THEN
                    ASSIGN c-dir-saida = c-dir-saida + "~\".
            
            END.

            output to VALUE(c-dir-saida + "spool~\erros-escep019") APPEND CONVERT TARGET SESSION:CHARSET.
            disp "==> " item.it-codigo format "x(7)"
                 item.descricao-1 + item.descricao-2 format "x(36)" skip
                 "    "  c-msg-erro skip
                 with width 300 no-labels frame f-imp-erro STREAM-IO.
            for each saldo-estoq no-lock
               where saldo-estoq.cod-estabel = v_cod_estab_usuar
                 AND saldo-estoq.it-codigo = c-it-codigo :
            
                disp "    Saldo Alm:"  saldo-estoq.qtidade-atu 
                            saldo-estoq.cod-localiz skip with frame f-imp-erro STREAM-IO.
            end.
            assign i-saldo-ae = 0.
            for each ae-item 
               where ae-item.cod-estabel = v_cod_estab_usuar
               and ae-item.it-codigo = c-it-codigo:
                assign i-saldo-ae = i-saldo-ae + quantidade.
            end.
            disp "     Saldo AE: " i-saldo-ae skip
                 "      Usuario: " c-etiqueta  skip
                 "    Data/Hora: " today " - " string(time,"HH:MM:SS")
                 
                 with frame f-imp-erro STREAM-IO.       

            output close.
       end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

