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

{include/i-prgvrs.i escpp018 2.04.000.000}

/*
CREATE WIDGET-POOL.
*/

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escep029
&GLOBAL-DEFINE Version        2.04.000.000
&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Destino

&GLOBAL-DEFINE page0Widgets   btExit btHelp 
&GLOBAL-DEFINE page1Widgets   c-it-ini c-it-fim c-loc-ini c-loc-fim tg-bloq tg-desb bt-procura fi-bloq fi-desb fi-motivo br-item
&GLOBAL-DEFINE page2Widgets   cb-impressora fi-descricao rs-destino
&GLOBAL-DEFINE ttTable        




DEF TEMP-TABLE tt-item
    FIELD it-codigo         LIKE saldo-estoq.it-codigo
    FIELD descricao         AS CHAR FORMAT "x(60)" 
    FIELD cod-localiz       LIKE saldo-estoq.cod-localiz
    FIELD qtidade-atu       LIKE saldo-estoq.qtidade-atu
    FIELD data              LIKE ae-item.data
    FIELD log-bloqueado     LIKE int-saldo-estoq.log-bloqueado
    FIELD cod-estabel       LIKE int-saldo-estoq.cod-estabel
    FIELD cod-depos         LIKE int-saldo-estoq.cod-depos
    FIELD motivo            LIKE int-saldo-estoq.motivo.





DEF VAR sit AS LOGICAL.
DEF VAR tot-bloq AS DEC FORMAT ">>>>>,>>9".
DEF VAR tot-desb AS DEC FORMAT ">>>>>,>>9".


DEF VAR     cMotivo     LIKE int-saldo-estoq.motivo LABEL "Motivo:" VIEW-AS FILL-IN SIZE 50 BY .88 NO-UNDO.
DEF BUTTON  btGoToOK    AUTO-GO LABEL "&OK" SIZE 10 BY 1 BGCOLOR 8.
DEF BUTTON  btGoToCancel AUTO-GO LABEL "&Cancela" SIZE 10 BY 1 BGCOLOR 8.


DEF BUFFER bint-saldo-estoq FOR int-saldo-estoq.
{upc\btb910za-upc.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-item

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-item

/* Definitions for BROWSE br-item                                       */
&Scoped-define FIELDS-IN-QUERY-br-item tt-item.it-codigo tt-item.descricao tt-item.cod-localiz tt-item.qtidade-atu tt-item.data tt-item.log-bloqueado   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-item   
&Scoped-define SELF-NAME br-item
&Scoped-define QUERY-STRING-br-item FOR EACH tt-item
&Scoped-define OPEN-QUERY-br-item OPEN QUERY {&SELF-NAME} FOR EACH tt-item.
&Scoped-define TABLES-IN-QUERY-br-item tt-item
&Scoped-define FIRST-TABLE-IN-QUERY-br-item tt-item


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-item}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar rtToolBar-2 btExit btHelp ~
btImprimir 

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

DEFINE BUTTON btImprimir 
     LABEL "Imprimir" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 92 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 96 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-procura 
     LABEL "Procura..." 
     SIZE 8 BY 2.

DEFINE VARIABLE c-it-fim AS CHARACTER FORMAT "X(7)":U 
     LABEL "Item Final" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE c-it-ini AS CHARACTER FORMAT "X(7)":U 
     LABEL "Item inicial" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE c-loc-fim AS CHARACTER FORMAT "X(10)":U INITIAL "zzzzzzzzzz" 
     LABEL "Localiza‡Æo final" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE c-loc-ini AS CHARACTER FORMAT "X(10)":U INITIAL "aaaaaaaaaa" 
     LABEL "Localiza‡Æo inicial" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE fi-bloq AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Bloqueado" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .79 NO-UNDO.

DEFINE VARIABLE fi-desb AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Desbloqueado" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .79 NO-UNDO.

DEFINE VARIABLE fi-motivo AS CHARACTER FORMAT "X(50)":U 
     LABEL "Motivo" 
     VIEW-AS FILL-IN 
     SIZE 53 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 57 BY 3.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 19 BY 3.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 14 BY 3.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 92 BY 11.

DEFINE VARIABLE tg-bloq AS LOGICAL INITIAL no 
     LABEL "Bloqueado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-Desb AS LOGICAL INITIAL yes 
     LABEL "Desbloqueado" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

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
DEFINE QUERY br-item FOR 
      tt-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-item wWindow _FREEFORM
  QUERY br-item DISPLAY
      tt-item.it-codigo    FORMAT "X(07)"     COLUMN-LABEL "Cod. Item"
    tt-item.descricao      FORMAT "x(60)"     COLUMN-LABEL "Descri‡Æo"
    tt-item.cod-localiz                     COLUMN-LABEL "Localiza‡Æo"
    tt-item.qtidade-atu                     COLUMN-LABEL "Qtde"
    tt-item.data                            COLUMN-LABEL "Data"    
    tt-item.log-bloqueado                   COLUMN-LABEL "Bloq"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 8.5
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btExit AT ROW 1.13 COL 88 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 92 HELP
          "Ajuda"
     btImprimir AT ROW 19 COL 5
     rtToolBar AT ROW 18.75 COL 3
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 96.86 BY 19.83
         FONT 1.

DEFINE FRAME fPage2
     rs-destino AT ROW 2.67 COL 11 NO-LABEL
     cb-impressora AT ROW 7.5 COL 9 NO-LABEL
     fi-descricao AT ROW 7.5 COL 23 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     "Destino" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 1.75 COL 9
     "Impressora" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 6.5 COL 10
     RECT-3 AT ROW 2 COL 6
     RECT-4 AT ROW 6.75 COL 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 4
         SIZE 85 BY 8.5
         FONT 1.

DEFINE FRAME fPage1
     c-it-ini AT ROW 1.75 COL 14 COLON-ALIGNED
     c-it-fim AT ROW 1.75 COL 42 COLON-ALIGNED
     bt-procura AT ROW 1.75 COL 82
     tg-bloq AT ROW 2 COL 63
     c-loc-ini AT ROW 3 COL 14 COLON-ALIGNED
     c-loc-fim AT ROW 3 COL 42 COLON-ALIGNED
     tg-Desb AT ROW 3 COL 63
     br-item AT ROW 4.75 COL 2
     fi-bloq AT ROW 13.5 COL 9 COLON-ALIGNED
     fi-desb AT ROW 13.5 COL 47 COLON-ALIGNED
     fi-motivo AT ROW 14.5 COL 9 COLON-ALIGNED
     "Situa‡Æo" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 1 COL 60
     RECT-5 AT ROW 1.25 COL 1
     RECT-6 AT ROW 1.25 COL 59
     RECT-7 AT ROW 1.25 COL 79
     RECT-8 AT ROW 4.5 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 4
         SIZE 93 BY 14.75
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
         HEIGHT             = 19.83
         WIDTH              = 96.86
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
/* BROWSE-TAB br-item tg-Desb fPage1 */
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

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-item
/* Query rebuild information for BROWSE br-item
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-item.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-item */
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


&Scoped-define BROWSE-NAME br-item
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-item wWindow
ON MOUSE-SELECT-CLICK OF br-item IN FRAME fPage1
DO:
    ASSIGN fi-motivo:SCREEN-VALUE IN FRAME fpage1 = "".  
    ASSIGN fi-motivo:SCREEN-VALUE IN FRAME fpage1 = tt-item.motivo.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-item wWindow
ON MOUSE-SELECT-DBLCLICK OF br-item IN FRAME fPage1
DO:

    FIND FIRST int-saldo-estoq WHERE
               int-saldo-estoq.cod-estabel = tt-item.cod-estabel  AND
               int-saldo-estoq.cod-depos   = tt-item.cod-depos    AND
               int-saldo-estoq.it-codigo   = tt-item.it-codigo    AND
               int-saldo-estoq.cod-localiz = tt-item.cod-localiz  NO-ERROR. 
    IF AVAIL int-saldo-estoq THEN DO:
       IF int-saldo-estoq.log-bloqueado = NO THEN DO:
           RUN motivo.
           IF cMotivo <> "" THEN
               ASSIGN int-saldo-estoq.log-bloqueado = YES
                      int-saldo-estoq.motivo = cMotivo.
           ELSE DO:
               MESSAGE "Motivo deve ser informado"
                   VIEW-AS ALERT-BOX INFO BUTTONS OK.
               RETURN NO-APPLY.
           END.
          
      END.
       ELSE DO:
          ASSIGN int-saldo-estoq.log-bloqueado = NO
                 int-saldo-estoq.motivo        = "".
       END.
    END.

    APPLY 'choose' TO bt-procura.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-procura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-procura wWindow
ON CHOOSE OF bt-procura IN FRAME fPage1 /* Procura... */
DO:

    FOR EACH tt-item:
        DELETE tt-item.
    END.
    {&OPEN-QUERY-br-item}

    ASSIGN tot-bloq = 0
           tot-desb = 0.


    ASSIGN fi-bloq:SCREEN-VALUE IN FRAME fpage1 = STRING(tot-bloq)
           fi-desb:SCREEN-VALUE IN FRAME fpage1 = STRING(tot-desb)
           fi-motivo:SCREEN-VALUE IN FRAME fpage1 = "".  


    IF tg-bloq:CHECKED = NO  AND
       tg-desb:CHECKED = NO  THEN DO:
       MESSAGE "Selecione a situa‡Æo Bloqueado/Desbloqueado"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
       LEAVE.
    END.


    IF tg-bloq:CHECKED = YES  AND
       tg-desb:CHECKED = NO   THEN DO:
       ASSIGN sit = YES.
       RUN sel-b-d.
    END.


    IF tg-bloq:CHECKED = NO   AND
       tg-desb:CHECKED = YES  THEN DO:
       ASSIGN sit = NO.
       RUN sel-b-d.
    END.


    IF tg-bloq:CHECKED = YES  AND
       tg-desb:CHECKED = YES  THEN DO:
       RUN sel-a.
    END.

    {&OPEN-QUERY-br-item}

    
    ASSIGN fi-bloq:SCREEN-VALUE IN FRAME fpage1 = STRING(tot-bloq)
           fi-desb:SCREEN-VALUE IN FRAME fpage1 = STRING(tot-desb).
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


&Scoped-define SELF-NAME btImprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImprimir wWindow
ON CHOOSE OF btImprimir IN FRAME fpage0 /* Imprimir */
DO:
  RUN IMPRIME.
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


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Motivo wWindow 
PROCEDURE Motivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
        
    END.



    ENABLE cMotivo
           btGoToOK
           btGoToCancel 
           WITH FRAME fMotivo.

    WAIT-FOR "GO":U OF FRAME fMotivo.

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

    FOR EACH saldo-estoq WHERE
             saldo-estoq.cod-localiz >= c-loc-ini:SCREEN-VALUE IN FRAME fpage1  AND
             saldo-estoq.cod-localiz <= c-loc-fim:SCREEN-VALUE IN FRAME fpage1  AND
             saldo-estoq.cod-localiz <> ""                                      AND
             saldo-estoq.it-codigo   >= c-it-ini:SCREEN-VALUE IN FRAME fpage1   AND
             saldo-estoq.it-codigo   <= c-it-fim:SCREEN-VALUE IN FRAME fpage1   AND
             saldo-estoq.cod-depos    = "exp"                                   AND
             saldo-estoq.cod-estabel = v_cod_estab_usuar and
             saldo-estoq.qtidade-atu <> 0 NO-LOCK:

        FIND FIRST bint-saldo-estoq WHERE
              bint-saldo-estoq.cod-estabel   = saldo-estoq.cod-estabel  AND
              bint-saldo-estoq.cod-depos     = saldo-estoq.cod-depos    AND
              bint-saldo-estoq.cod-localiz   = saldo-estoq.cod-localiz  AND
              bint-saldo-estoq.it-codigo     = saldo-estoq.it-codigo NO-LOCK NO-ERROR.
        IF NOT AVAIL bint-saldo-estoq THEN DO:
            CREATE int-saldo-estoq.
            ASSIGN int-saldo-estoq.cod-estabel    = saldo-estoq.cod-estabel
                   int-saldo-estoq.cod-depos      = saldo-estoq.cod-depos
                   int-saldo-estoq.cod-localiz    = saldo-estoq.cod-localiz
                   int-saldo-estoq.it-codigo      = saldo-estoq.it-codigo
                   int-saldo-estoq.log-bloqueado  = NO
                   int-saldo-estoq.cod-refer      = saldo-estoq.cod-refer
                   int-saldo-estoq.lote           = saldo-estoq.lote.
        END.

        FIND FIRST int-saldo-estoq WHERE
              int-saldo-estoq.cod-estabel = saldo-estoq.cod-estabel  AND
              int-saldo-estoq.cod-depos   = saldo-estoq.cod-depos    AND
              int-saldo-estoq.it-codigo   = saldo-estoq.it-codigo    AND
              int-saldo-estoq.cod-localiz = saldo-estoq.cod-localiz NO-LOCK NO-ERROR.
        IF NOT AVAIL int-saldo-estoq THEN NEXT.

        IF int-saldo-estoq.log-bloqueado = YES THEN DO:
            ASSIGN tot-bloq = tot-bloq + saldo-estoq.qtidade-atu.
        END.
        ELSE DO:
            ASSIGN tot-desb = tot-desb + saldo-estoq.qtidade-atu.
        END.

        FIND FIRST ae-item WHERE 
                   ae-item.cod-estabel = saldo-estoq.cod-estabel and   
                   NOT ae-item.situacao                               AND 
                       ae-item.it-codigo   = saldo-estoq.it-codigo    AND 
                       ae-item.localizacao = saldo-estoq.cod-localiz NO-LOCK NO-ERROR.

        FIND FIRST item WHERE item.it-codigo = saldo-estoq.it-codigo NO-LOCK.
                   
        CREATE tt-item.
        ASSIGN  tt-item.it-codigo       = saldo-estoq.it-codigo
                tt-item.descricao       = item.descricao-1 + " " + item.descricao-2
                tt-item.cod-localiz     = saldo-estoq.cod-localiz
                tt-item.qtidade-atu     = saldo-estoq.qtidade-atu
                tt-item.data            = ae-item.data WHEN AVAIL ae-item
                tt-item.log-bloqueado   = int-saldo-estoq.log-bloqueado
                tt-item.cod-estabel     = int-saldo-estoq.cod-estabel
                tt-item.cod-depos       = int-saldo-estoq.cod-depos
                tt-item.motivo          = int-saldo-estoq.motivo.
    END.


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

    FOR EACH saldo-estoq WHERE
             saldo-estoq.cod-localiz >= c-loc-ini:SCREEN-VALUE IN FRAME fpage1  AND
             saldo-estoq.cod-localiz <= c-loc-fim:SCREEN-VALUE IN FRAME fpage1  AND
             saldo-estoq.cod-localiz <> ""                                      AND
             saldo-estoq.it-codigo   >= c-it-ini:SCREEN-VALUE IN FRAME fpage1   AND
             saldo-estoq.it-codigo   <= c-it-fim:SCREEN-VALUE IN FRAME fpage1   AND
             saldo-estoq.cod-depos    = "exp"                                   AND
             saldo-estoq.cod-estabel = v_cod_estab_usuar and
             saldo-estoq.qtidade-atu <> 0 NO-LOCK:
       
        FIND FIRST bint-saldo-estoq WHERE
              bint-saldo-estoq.cod-estabel   = saldo-estoq.cod-estabel  AND
              bint-saldo-estoq.cod-depos     = saldo-estoq.cod-depos    AND
              bint-saldo-estoq.cod-localiz   = saldo-estoq.cod-localiz  AND
              bint-saldo-estoq.it-codigo     = saldo-estoq.it-codigo NO-LOCK NO-ERROR.
        IF NOT AVAIL bint-saldo-estoq THEN DO:
            CREATE int-saldo-estoq.
            ASSIGN int-saldo-estoq.cod-estabel    = saldo-estoq.cod-estabel
                   int-saldo-estoq.cod-depos      = saldo-estoq.cod-depos
                   int-saldo-estoq.cod-localiz    = saldo-estoq.cod-localiz
                   int-saldo-estoq.it-codigo      = saldo-estoq.it-codigo
                   int-saldo-estoq.log-bloqueado  = NO
                   int-saldo-estoq.cod-refer      = saldo-estoq.cod-refer
                   int-saldo-estoq.lote           = saldo-estoq.lote.
        END.
        
        FIND FIRST int-saldo-estoq WHERE
              int-saldo-estoq.cod-estabel   = saldo-estoq.cod-estabel  AND
              int-saldo-estoq.cod-depos     = saldo-estoq.cod-depos    AND
              int-saldo-estoq.cod-localiz   = saldo-estoq.cod-localiz  AND
              int-saldo-estoq.it-codigo     = saldo-estoq.it-codigo    AND
              int-saldo-estoq.log-bloqueado = sit NO-LOCK NO-ERROR.
        IF NOT AVAIL int-saldo-estoq THEN NEXT.
        
        IF int-saldo-estoq.log-bloqueado = YES THEN DO:
            ASSIGN tot-bloq = tot-bloq + saldo-estoq.qtidade-atu.
        END.
        ELSE DO:
            ASSIGN tot-desb = tot-desb + saldo-estoq.qtidade-atu.
        END.
        
        FIND FIRST ae-item WHERE ae-item.cod-estabel = saldo-estoq.cod-estabel and
                     NOT ae-item.situacao                               AND 
                         ae-item.it-codigo   = saldo-estoq.it-codigo    AND 
                         ae-item.localizacao = saldo-estoq.cod-localiz NO-LOCK NO-ERROR.
        
        FIND FIRST item WHERE item.it-codigo = saldo-estoq.it-codigo NO-LOCK.

        CREATE tt-item.
        ASSIGN  tt-item.it-codigo       = saldo-estoq.it-codigo
                tt-item.descricao       = item.descricao-1 + " " + item.descricao-2
                tt-item.cod-localiz     = saldo-estoq.cod-localiz
                tt-item.qtidade-atu     = saldo-estoq.qtidade-atu
                tt-item.data            = ae-item.data WHEN AVAIL ae-item
                tt-item.log-bloqueado   = sit
                tt-item.cod-estabel     = int-saldo-estoq.cod-estabel
                tt-item.cod-depos       = int-saldo-estoq.cod-depos
                tt-item.motivo          = int-saldo-estoq.motivo.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

