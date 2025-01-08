&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgmov           PROGRESS
          mgesp           PROGRESS
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
compile \\tsclient\c\fontes\esp\cep\escep048.w save into c:\temp\esp\cep.
*******************************************************************************/
{include/i-prgvrs.i escep048 2.04.000.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escep048
&GLOBAL-DEFINE Version        2.04.000.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   ITENS,DESTINO

&GLOBAL-DEFINE page0Widgets   btExit btHelp 
&GLOBAL-DEFINE page1Widgets   br-exp br-ae
&GLOBAL-DEFINE page2Widgets   cb-impressora fi-descricao rs-destino

/* Parameters Definitions ---                                           */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEF VAR c-it-codigo AS CHAR NO-UNDO.
DEF VAR i-quantidade AS DECIMAL NO-UNDO.

DEFINE VARIABLE p-msg-erro AS CHARACTER   NO-UNDO.

{esp/es0478.i "new"}
{esp/es0478-rpc.i}
{upc\btb910za-upc.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-ae

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ae-item saldo-estoq item

/* Definitions for BROWSE br-ae                                         */
&Scoped-define FIELDS-IN-QUERY-br-ae ae-item.nr-ae ae-item.sequencia ~
ae-item.localizacao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-ae 
&Scoped-define QUERY-STRING-br-ae FOR EACH ae-item ~
      WHERE ae-item.cod-estabel = v_cod_estab_usuar ~
 and ae-item.it-codigo = c-it-codigo ~
 AND ae-item.situacao = FALSE ~
 AND ae-item.data = today NO-LOCK ~
    BY ae-item.nr-ae ~
       BY ae-item.sequencia ~
        BY ae-item.localizacao INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-ae OPEN QUERY br-ae FOR EACH ae-item ~
      WHERE ae-item.cod-estabel = v_cod_estab_usuar ~
 and ae-item.it-codigo = c-it-codigo ~
 AND ae-item.situacao = FALSE ~
 AND ae-item.data = today NO-LOCK ~
    BY ae-item.nr-ae ~
       BY ae-item.sequencia ~
        BY ae-item.localizacao INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-ae ae-item
&Scoped-define FIRST-TABLE-IN-QUERY-br-ae ae-item


/* Definitions for BROWSE br-exp                                        */
&Scoped-define FIELDS-IN-QUERY-br-exp saldo-estoq.it-codigo item.desc-item ~
saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada @ saldo-estoq.qtidade-atu 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-exp 
&Scoped-define QUERY-STRING-br-exp FOR EACH saldo-estoq ~
      WHERE saldo-estoq.cod-estabel = v_cod_estab_usuar ~
 and saldo-estoq.cod-depos = "exp" ~
 and saldo-estoq.cod-localiz = "localizar" ~
 AND (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada) > 0 NO-LOCK, ~
      FIRST item OF saldo-estoq NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-exp OPEN QUERY br-exp FOR EACH saldo-estoq ~
      WHERE saldo-estoq.cod-estabel = v_cod_estab_usuar ~
 and saldo-estoq.cod-depos = "exp" ~
 and saldo-estoq.cod-localiz = "localizar" ~
 AND (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada) > 0 NO-LOCK, ~
      FIRST item OF saldo-estoq NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-exp saldo-estoq item
&Scoped-define FIRST-TABLE-IN-QUERY-br-exp saldo-estoq
&Scoped-define SECOND-TABLE-IN-QUERY-br-exp item


/* Definitions for FRAME fPage1                                         */

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
     SIZE 61 BY 2.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-ae FOR 
      ae-item SCROLLING.

DEFINE QUERY br-exp FOR 
      saldo-estoq, 
      item
    FIELDS(item.desc-item) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-ae
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-ae wWindow _STRUCTURED
  QUERY br-ae NO-LOCK DISPLAY
      ae-item.nr-ae FORMAT "9999999":U
      ae-item.sequencia COLUMN-LABEL "Seq" FORMAT "999":U
      ae-item.localizacao FORMAT "x(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 58 BY 10
         FONT 1
         TITLE "".

DEFINE BROWSE br-exp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-exp wWindow _STRUCTURED
  QUERY br-exp NO-LOCK DISPLAY
      saldo-estoq.it-codigo FORMAT "x(16)":U
      item.desc-item FORMAT "x(36)":U
      saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada @ saldo-estoq.qtidade-atu COLUMN-LABEL "Saldo" FORMAT "->>>,>>>,>>9.9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 58 BY 10
         FONT 1
         TITLE "Saldo do Dep¢sito EXP - Localizar".


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

DEFINE FRAME fPage2
     rs-destino AT ROW 2.5 COL 11 NO-LABEL
     cb-impressora AT ROW 7.5 COL 11 NO-LABEL
     fi-descricao AT ROW 7.5 COL 25 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     "Destino" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 1.75 COL 10
     "Impressora" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 6.5 COL 10
     RECT-3 AT ROW 2 COL 8
     RECT-4 AT ROW 6.75 COL 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.6 ROW 3.71
         SIZE 84.4 BY 12.75
         FONT 1.

DEFINE FRAME fPage1
     br-exp AT ROW 2 COL 14 HELP
          "Selecione o item e pressione RETURN para transferir"
     br-ae AT ROW 2 COL 14 HELP
          "Selecione o item e pressione RETURN para transferir"
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.6 ROW 3.7 SCROLLABLE 
         FONT 1.


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
         MAX-HEIGHT         = 27.17
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.17
         VIRTUAL-WIDTH      = 146.29
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
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
   Size-to-Fit                                                          */
/* BROWSE-TAB br-exp 1 fPage1 */
/* BROWSE-TAB br-ae br-exp fPage1 */
ASSIGN 
       FRAME fPage1:SCROLLABLE       = FALSE.

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

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-ae
/* Query rebuild information for BROWSE br-ae
     _TblList          = "mgesp.ae-item"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED"
     _OrdList          = "mgesp.ae-item.nr-ae|yes,mgesp.ae-item.sequencia|yes,mgesp.ae-item.localizacao|yes"
     _Where[1]         = "mgesp.ae-item.cod-estabel = v_cod_estab_usuar
 and mgesp.ae-item.it-codigo = c-it-codigo
 AND mgesp.ae-item.situacao = FALSE
 AND mgesp.ae-item.data = today"
     _FldNameList[1]   = mgesp.ae-item.nr-ae
     _FldNameList[2]   > mgesp.ae-item.sequencia
"ae-item.sequencia" "Seq" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[3]   = mgesp.ae-item.localizacao
     _Query            is NOT OPENED
*/  /* BROWSE br-ae */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-exp
/* Query rebuild information for BROWSE br-exp
     _TblList          = "mgmov.saldo-estoq,mgcad.item OF mgmov.saldo-estoq"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED"
     _Where[1]         = "mgmov.saldo-estoq.cod-estabel = v_cod_estab_usuar
 and mgmov.saldo-estoq.cod-depos = ""exp""
 and mgmov.saldo-estoq.cod-localiz = ""localizar""
 AND (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada) > 0"
     _FldNameList[1]   = mgmov.saldo-estoq.it-codigo
     _FldNameList[2]   > mgcad.item.desc-item
"item.desc-item" ? "x(36)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[3]   > "_<CALC>"
"saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada @ saldo-estoq.qtidade-atu" "Saldo" "->>>,>>>,>>9.9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _Query            is NOT OPENED
*/  /* BROWSE br-exp */
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


&Scoped-define BROWSE-NAME br-exp
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-exp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-exp wWindow
ON RETURN OF br-exp IN FRAME fPage1 /* Saldo do Dep¢sito EXP - Localizar */
DO:
  IF SELF:NUM-ITERATIONS > 0 AND SELF:NUM-SELECTED-ROWS > 0 THEN DO:
      SELF:FETCH-SELECTED-ROW(1).
      FIND FIRST contenedor no-lock 
          WHERE contenedor.it-codigo = saldo-estoq.it-codigo NO-ERROR.
      IF NOT AVAIL contenedor THEN DO:
          RUN ShowMessage (1, "Contenedor n∆o cadastrado", "").
          RETURN NO-APPLY.
      END.
      i-quantidade = saldo-estoq.qtidade-atu - mgmov.saldo-estoq.qt-alocada.
      RUN pedeQuantidade (INPUT-OUTPUT i-quantidade) NO-ERROR.
      IF RETURN-VALUE = "OK" THEN DO:
          RUN Transfere NO-ERROR.
          c-it-codigo = saldo-estoq.it-codigo.
          DO WITH FRAME fpage1:
              BROWSE br-ae:TITLE = SUBSTITUTE("Avisos de Entrada para &1", saldo-estoq.it-codigo).
              SELF:HIDDEN = YES.
              BROWSE br-ae:VISIBLE = YES.
              {&OPEN-QUERY-br-ae}
              APPLY "entry" TO br-ae IN FRAME fpage1.
              PAUSE MESSAGE "Pressione alguma tecla para continuar".
              SELF:HIDDEN = NO.
              BROWSE br-ae:VISIBLE = NO.
              APPLY "entry" TO br-exp IN FRAME fpage1.
          END.
      END.
  END.
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
      @ fi-descricao WITH FRAME fpage2.
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
              DISP impressora.des_impressora @ fi-descricao WITH FRAME fpage2.
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
          DISP ENTRY(1, cb-impressora:PRIVATE-DATA) @ fi-descricao WITH FRAME fpage2.
      END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-ae
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

{window/MainBlock.i}

{&OPEN-QUERY-br-exp}

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
    APPLY "value-changed" TO rs-destino IN FRAME fpage2.
    BROWSE br-ae:HIDDEN = YES.
    APPLY "entry" TO br-exp IN FRAME fpage1.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pedeQuantidade wWindow 
PROCEDURE pedeQuantidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT-OUTPUT PARAM p-quantidade AS DEC NO-UNDO.

    /* Definitions of the field level widgets                               */
    DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
         LABEL "Cancela" 
         SIZE 10 BY 1
         BGCOLOR 8 .
    
    DEFINE BUTTON Btn_OK AUTO-GO 
         LABEL "Confirma" 
         SIZE 10 BY 1
         BGCOLOR 8 .
    
    DEFINE VARIABLE fi-quantidade AS DECIMAL FORMAT ">,>>>,>>9.9999":U INITIAL 0.00 
         LABEL "Quantidade" 
         VIEW-AS FILL-IN 
         SIZE 15 BY .88 NO-UNDO.
    
    DEFINE RECTANGLE RECT-5
         EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
         SIZE 64 BY 1.25.
    
    DEFINE RECTANGLE RECT-6
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 64 BY 1.5
         BGCOLOR 7 .

    /* ************************  Frame Definitions  *********************** */
    
    DEFINE FRAME f-qtde
         fi-quantidade AT ROW 1.17 COL 25 COLON-ALIGNED
         Btn_OK AT ROW 2.5 COL 2
         Btn_Cancel AT ROW 2.5 COL 12
         RECT-5 AT ROW 1 COL 1
         RECT-6 AT ROW 2.25 COL 1
         SPACE(0.13) SKIP(0.00)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1
             TITLE "Quantidade para transferir"
             DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.

    ASSIGN 
           FRAME f-qtde:SCROLLABLE       = FALSE
           FRAME f-qtde:ROW              = 1
           FRAME f-qtde:COLUMN           = 1.

    ON 'choose':U OF Btn_Cancel IN FRAME f-qtde
    DO:
        RETURN "NOK".
    END.

    ON 'choose':U OF Btn_OK IN FRAME f-qtde
    DO:
        p-quantidade = INPUT fi-quantidade.
        RETURN "OK".
    END.

    DISPLAY p-quantidade @ fi-quantidade 
        WITH FRAME f-qtde.
    ENABLE RECT-5 RECT-6 fi-quantidade Btn_OK Btn_Cancel 
        WITH FRAME f-qtde.
    WAIT-FOR GO OF FRAME f-qtde.
    HIDE FRAME f-qtde.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Transfere wWindow 
PROCEDURE Transfere :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR c-dispositivo AS CHAR NO-UNDO.
    
    DO WITH FRAME fpage1:
        STATUS DEFAULT "Processando a transferància. Por favor aguarde".
        SESSION:SET-WAIT-STATE("GENERAL":U).
        ASSIGN i-barra        = INPUT FRAME fpage2 rs-destino.

        FOR FIRST imprsor_usuar FIELDS (nom_disposit_so) no-lock
            where imprsor_usuar.nom_impressora = INPUT FRAME fpage2 cb-impressora
            and   imprsor_usuar.cod_usuario    = c-seg-usuario
            use-index imprsrsr_id:
            c-dispositivo = imprsor_usuar.nom_disposit_so.
        END.
        l-deu-erro = NO.

        run esp/es0478-n.p (
              input saldo-estoq.it-codigo,                           /* item */
              input "exp",                                           /* deposito de saida */                
              input "localizar",                                     /* local de saida */
              input i-quantidade,                                    /* quantidade total */
              input "EXP",                                           /* deposito de entrada */
              input 0,                                               /* numero docto */
              input "TRA",                                           /* serie */
              input string(today) + " - " + string(time,"HH:MM:SS"), /* historico */
              input 0,                                               /* numero do AE */
              input 0,                                               /* sequencia do AE */
              input 0,                                               /* roteiro */  
              input 0,                                               /* nota */
              input no,                                              /* baixa parcial */
              input no,                                              /* devolucao ou transferencia */
              input contenedor.lote-multipl,                         /* contenedor */
              input 0,                                               /* fornecedor */
              input 1,                                               /* sequencia inicial */
              input no,                                              /* usa local informado */
              input "",                                              /* local destino */
              input today,                                           /* data movto-estoq */
              input ?,                                               /* Validade da AE */
              input "escep048," + c-dispositivo,                     /* Campo Caracter livre */
              input v_cod_estab_usuar,
              output table tt-etiqueta,
              OUTPUT p-msg-erro).   
              
        SESSION:SET-WAIT-STATE("":U).
        STATUS DEFAULT.
        IF l-deu-erro THEN RUN trata-erro.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trata-erro wWindow 
PROCEDURE trata-erro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var i-saldo-ae    like ae-item.quantidade format ">>>,>>>,>>9" NO-UNDO.
    if c-it-codigo <> "" then do:
        find item where item.it-codigo = c-it-codigo no-lock no-error.
        if avail item then do:
            output to value(session:TEMP-DIRECTORY + "escep048.log") APPEND CONVERT TARGET SESSION:CHARSET.
            disp "==> " item.it-codigo format "x(7)"
                 item.descricao-1 + item.descricao-2 format "x(36)" skip
                 "    "  "Ocorreu um erro na transferencia" skip
                 with width 300 no-labels frame f-imp-erro.
            disp "    Saldo Alm:" saldo-estoq.qtidade-atu skip
                 "   Qt Alocada:" saldo-estoq.qt-alocada
                 saldo-estoq.cod-localiz skip with frame f-imp-erro.

            assign i-saldo-ae = 0.
            for each ae-item no-lock
               where ae-item.cod-estabel = v_cod_estab_usuar 
               and ae-item.it-codigo = c-it-codigo:
                assign i-saldo-ae = i-saldo-ae + quantidade.
            end.
            disp "     Saldo AE: " i-saldo-ae skip
                 "      Usuario: " userid("mgadm")  skip
                 "    Data/Hora: " today " - " string(time,"HH:MM:SS")
                 
                 with frame f-imp-erro.       

            output close.
        end.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

