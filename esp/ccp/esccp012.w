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
{include/i-prgvrs.i esccp012 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esccp012
&GLOBAL-DEFINE Version        2.04.00.000

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   <Folder1 ,Folder 2 ,... , Folder8>

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              bt-vapara-ori bt-vapara-dest c-comprador-ori c-cod-estabel c-comprador-dest ~
                              br-ori br-dest bt-item bt-tudo fi-fornec
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF BUFFER b-item FOR ITEM.
DEF BUFFER b-item-uni-estab FOR item-uni-estab.

DEF TEMP-TABLE ttitem
    FIELD selec        AS LOG FORMAT "*/ "
    FIELD cod-comprado LIKE ITEM.cod-comprado
    FIELD it-codigo    LIKE ITEM.it-codigo
    FIELD desc-item    LIKE ITEM.desc-item
    FIELD cod-estabel  LIKE item-uni-estab.cod-estabel
    INDEX ttitem1 
          selec it-codigo cod-estabel
    INDEX ttitem2 
          it-codigo cod-estabel
    INDEX ttitem3
          cod-comprado cod-estabel it-codigo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-dest

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES b-item-uni-estab b-item ttITEM

/* Definitions for BROWSE br-dest                                       */
&Scoped-define FIELDS-IN-QUERY-br-dest b-item-uni-estab.cod-estabel b-item-uni-estab.it-codigo b-item.desc-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-dest   
&Scoped-define SELF-NAME br-dest
&Scoped-define QUERY-STRING-br-dest FOR EACH b-item-uni-estab NO-LOCK                            WHERE b-item-uni-estab.cod-comprado = c-comprador-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME}                              AND b-item-uni-estab.cod-estabel  = c-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME}, ~
                                  FIRST b-item NO-LOCK                            WHERE b-item.it-codigo = b-item-uni-estab.it-codigo
&Scoped-define OPEN-QUERY-br-dest OPEN QUERY {&SELF-NAME} FOR EACH b-item-uni-estab NO-LOCK                            WHERE b-item-uni-estab.cod-comprado = c-comprador-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME}                              AND b-item-uni-estab.cod-estabel  = c-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME}, ~
                                  FIRST b-item NO-LOCK                            WHERE b-item.it-codigo = b-item-uni-estab.it-codigo.
&Scoped-define TABLES-IN-QUERY-br-dest b-item-uni-estab b-item
&Scoped-define FIRST-TABLE-IN-QUERY-br-dest b-item-uni-estab
&Scoped-define SECOND-TABLE-IN-QUERY-br-dest b-item


/* Definitions for BROWSE br-ori                                        */
&Scoped-define FIELDS-IN-QUERY-br-ori ttitem.selec ttITEM.cod-comprado ttITEM.cod-estabel ttITEM.it-codigo ttITEM.desc-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-ori   
&Scoped-define SELF-NAME br-ori
&Scoped-define QUERY-STRING-br-ori FOR EACH ttITEM
&Scoped-define OPEN-QUERY-br-ori OPEN QUERY {&SELF-NAME} FOR EACH ttITEM.
&Scoped-define TABLES-IN-QUERY-br-ori ttITEM
&Scoped-define FIRST-TABLE-IN-QUERY-br-ori ttITEM


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-dest}~
    ~{&OPEN-QUERY-br-ori}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btQueryJoins btReportsJoins ~
btExit btHelp c-comprador-ori c-cod-estabel fi-fornec bt-vapara-ori ~
c-comprador-dest bt-vapara-dest c-nome-ori c-nome-dest br-ori br-dest ~
bt-item bt-tudo 
&Scoped-Define DISPLAYED-OBJECTS c-comprador-ori c-cod-estabel fi-fornec ~
c-comprador-dest c-nome-ori c-nome-dest 

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
DEFINE BUTTON bt-item 
     IMAGE-UP FILE "adeicon/next-u.bmp":U
     LABEL "Button 3" 
     SIZE 7 BY 2.

DEFINE BUTTON bt-tudo 
     IMAGE-UP FILE "adeicon/forwrd-u.bmp":U
     LABEL "Button 4" 
     SIZE 7 BY 2.

DEFINE BUTTON bt-vapara-dest 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "" 
     SIZE 6 BY 1.13.

DEFINE BUTTON bt-vapara-ori 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "" 
     SIZE 6 BY 1.13.

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

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "X(5)":U INITIAL "*" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE c-comprador-dest AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE c-comprador-ori AS CHARACTER FORMAT "X(12)":U INITIAL "*" 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE c-nome-dest AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .79 NO-UNDO.

DEFINE VARIABLE c-nome-ori AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .79 NO-UNDO.

DEFINE VARIABLE fi-fornec AS CHARACTER FORMAT "X(12)":U INITIAL "*" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 112 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-dest FOR 
      b-item-uni-estab, 
      b-item SCROLLING.

DEFINE QUERY br-ori FOR 
      ttITEM SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-dest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-dest wWindow _FREEFORM
  QUERY br-dest DISPLAY
      b-item-uni-estab.cod-estabel FORMAT "x(3)" WIDTH 2
      b-item-uni-estab.it-codigo FORMAT "x(10)"
      b-item.desc-item
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 51 BY 16.54
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE br-ori
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-ori wWindow _FREEFORM
  QUERY br-ori DISPLAY
      ttitem.selec label "*" WIDTH 1
  ttITEM.cod-comprado FORMAT "X(12)"
  ttITEM.cod-estabel  FORMAT "x(3)"  WIDTH 2
 ttITEM.it-codigo     FORMAT "x(10)"
 ttITEM.desc-item
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 51 BY 16.54
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 97 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 101 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 105 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 109 HELP
          "Ajuda"
     c-comprador-ori AT ROW 3.5 COL 2 NO-LABEL
     c-cod-estabel AT ROW 3.5 COL 18.43 NO-LABEL WIDGET-ID 2
     fi-fornec AT ROW 3.5 COL 29.14 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     bt-vapara-ori AT ROW 3.5 COL 41.72
     c-comprador-dest AT ROW 3.5 COL 60 COLON-ALIGNED NO-LABEL
     bt-vapara-dest AT ROW 3.5 COL 74
     c-nome-ori AT ROW 4.75 COL 2 NO-LABEL
     c-nome-dest AT ROW 4.75 COL 60 COLON-ALIGNED NO-LABEL
     br-ori AT ROW 6 COL 2
     br-dest AT ROW 6 COL 62
     bt-item AT ROW 10.04 COL 54
     bt-tudo AT ROW 13.04 COL 54
     "Fornecedor" VIEW-AS TEXT
          SIZE 12 BY .54 AT ROW 2.75 COL 31 WIDGET-ID 234
     "Estabelecimento" VIEW-AS TEXT
          SIZE 12 BY .54 AT ROW 2.75 COL 18.29 WIDGET-ID 4
     "Comprador de Origem" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 2.75 COL 2
     "Comprador de Destino" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 2.75 COL 62
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 112.86 BY 23.25
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
         HEIGHT             = 23.25
         WIDTH              = 112.86
         MAX-HEIGHT         = 23.25
         MAX-WIDTH          = 112.86
         VIRTUAL-HEIGHT     = 23.25
         VIRTUAL-WIDTH      = 112.86
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB br-ori c-nome-dest fpage0 */
/* BROWSE-TAB br-dest br-ori fpage0 */
ASSIGN 
       br-dest:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

ASSIGN 
       br-ori:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-comprador-ori IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-nome-ori IN FRAME fpage0
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-dest
/* Query rebuild information for BROWSE br-dest
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH b-item-uni-estab NO-LOCK
                           WHERE b-item-uni-estab.cod-comprado = c-comprador-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                             AND b-item-uni-estab.cod-estabel  = c-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                           FIRST b-item NO-LOCK
                           WHERE b-item.it-codigo = b-item-uni-estab.it-codigo
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-dest */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-ori
/* Query rebuild information for BROWSE br-ori
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttITEM
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-ori */
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


&Scoped-define BROWSE-NAME br-ori
&Scoped-define SELF-NAME br-ori
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ori wWindow
ON MOUSE-SELECT-DBLCLICK OF br-ori IN FRAME fpage0
DO:
   APPLY "return" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ori wWindow
ON RETURN OF br-ori IN FRAME fpage0
DO:
    assign ttitem.selec = NOT ttitem.selec.
    br-ori:REFRESH().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-item wWindow
ON CHOOSE OF bt-item IN FRAME fpage0 /* Button 3 */
DO:
  IF c-comprador-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN DO:
      MESSAGE "O comprador Destino deve ser informado"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.

      RETURN NO-APPLY.


  END.

  DO TRANSACTION:
     FOR EACH ttitem WHERE ttitem.selec NO-LOCK,
        FIRST ITEM WHERE ITEM.it-codigo = ttitem.it-codigo NO-LOCK:

         /*ASSIGN ITEM.cod-comprado = c-comprador-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME}.*/
         FOR EACH item-uni-estab EXCLUSIVE-LOCK
            WHERE item-uni-estab.it-codigo = ITEM.it-codigo
              AND item-uni-estab.cod-estabel = ttitem.cod-estabel:
             ASSIGN ITEM-uni-estab.cod-comprado = c-comprador-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
         END.

         DELETE ttitem.
     END.
     
  END.

    {&open-query-br-ori}
    {&open-query-br-dest}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-tudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-tudo wWindow
ON CHOOSE OF bt-tudo IN FRAME fpage0 /* Button 4 */
DO:
    IF c-comprador-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN DO:
      MESSAGE "O comprador Destino deve ser informado"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.

      RETURN NO-APPLY.


  END.

  DO TRANSACTION:
     FOR EACH ttitem NO-LOCK,
         FIRST ITEM WHERE ITEM.it-codigo = ttitem.it-codigo NO-LOCK:

         /*ASSIGN ITEM.cod-comprado = c-comprador-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME}.*/

         FOR EACH item-uni-estab EXCLUSIVE-LOCK
            WHERE item-uni-estab.it-codigo   = ITEM.it-codigo
              AND item-uni-estab.cod-estabel = ttitem.cod-estabel:
             ASSIGN item-uni-estab.cod-comprado = c-comprador-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
         END.
         DELETE ttitem.
     END.
  END.
  
    {&open-query-br-ori}
    {&open-query-br-dest}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-vapara-dest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-vapara-dest wWindow
ON CHOOSE OF bt-vapara-dest IN FRAME fpage0
DO:
    

    FIND usuar-mater NO-LOCK
           WHERE usuar-mater.cod-usuario = c-comprador-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-ERROR.
      IF NOT AVAIL usuar-mater OR
          NOT usuar-mater.usuar-comprador THEN DO:
          MESSAGE "Usu†rio n∆o cadastrado ou n∆o Ç comprador"
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
          RETURN NO-APPLY.
      END.

      ASSIGN c-nome-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} = usuar-mater.nome.





   {&open-query-br-dest}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-vapara-ori
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-vapara-ori wWindow
ON CHOOSE OF bt-vapara-ori IN FRAME fpage0
DO:

    DEFINE VARIABLE c-cod-fornec AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-cod-fornec AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l-continua   AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.

    ASSIGN c-nome-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

    IF c-comprador-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "*" AND c-comprador-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN DO:
        FIND usuar-mater NO-LOCK
             WHERE usuar-mater.cod-usuario = c-comprador-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-ERROR.
        IF NOT AVAIL usuar-mater OR
            NOT usuar-mater.usuar-comprador THEN DO:
            MESSAGE "Usu†rio n∆o cadastrado ou n∆o Ç comprador"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN NO-APPLY.
        END.
        ASSIGN c-nome-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME} = usuar-mater.nome.
    END.
  
    FOR EACH ttitem:
        DELETE ttitem.
    END.
    
    /*FOR EACH ITEM WHERE ITEM.cod-comprado = c-comprador-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK:
        CREATE ttitem.
        ASSIGN ttitem.selec = NO
               ttitem.it-codigo = ITEM.it-codigo
               ttitem.desc-item = ITEM.desc-item.
    END.*/

    ASSIGN i-cod-fornec = INT(fi-fornec:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        ASSIGN c-cod-fornec = "*".
    ELSE
        ASSIGN c-cod-fornec = fi-fornec:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar IN h-acomp (INPUT "Carregando Itens").

    FOR EACH item-uni-estab NO-LOCK
       WHERE ((TRIM(c-comprador-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> "*"
         AND   item-uni-estab.cod-comprado = TRIM(c-comprador-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME}))
          OR  (TRIM(c-comprador-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = "*" 
         AND   item-uni-estab.cod-comprado <> ""))
         AND ((TRIM(c-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> "*"
         AND   item-uni-estab.cod-estabel = TRIM(c-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME}))
          OR  (TRIM(c-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = "*"
         AND   item-uni-estab.cod-estabel <> "")),
       FIRST ITEM NO-LOCK
       WHERE ITEM.it-codigo = item-uni-estab.it-codigo:

        RUN pi-acompanhar IN h-acomp (INPUT item-uni-estab.it-codigo).

        ASSIGN l-continua = NO.
        IF TRIM(c-cod-fornec) <> "*" THEN DO:
            IF CAN-FIND(FIRST item-fornec-estab NO-LOCK
                        WHERE item-fornec-estab.it-codigo    = ITEM.it-codigo
                          AND item-fornec-estab.cod-emitente = i-cod-fornec 
                          AND item-fornec-estab.cod-estabel  = item-uni-estab.cod-estabel
                          AND item-fornec-estab.ativo) THEN
                ASSIGN l-continua = YES.
        END.
        ELSE IF c-cod-fornec = "*" AND CAN-FIND(FIRST item-fornec-estab NO-LOCK
                                                WHERE item-fornec-estab.it-codigo    = ITEM.it-codigo
                                                  AND item-fornec-estab.cod-estabel  = item-uni-estab.cod-estabel
                                                  AND item-fornec-estab.ativo) THEN
            ASSIGN l-continua = YES.
        ELSE
            ASSIGN l-continua = YES.

        IF l-continua THEN DO:
            CREATE ttitem.
            ASSIGN ttitem.selec = NO
                   ttitem.cod-comprado = item-uni-estab.cod-comprado
                   ttitem.it-codigo    = ITEM.it-codigo
                   ttitem.desc-item    = ITEM.desc-item
                   ttitem.cod-estabel  = item-uni-estab.cod-estabel.
        END.
    END.
    {&open-query-br-ori}

    RUN pi-finalizar IN h-acomp.

    ASSIGN h-acomp = ?.

    IF c-comprador-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN
        APPLY "choose" TO bt-vapara-dest IN FRAME {&FRAME-NAME}.

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


&Scoped-define BROWSE-NAME br-dest
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


