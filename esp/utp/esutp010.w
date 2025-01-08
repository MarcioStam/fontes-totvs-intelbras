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
{include/i-prgvrs.i ESUTP010 2.06.00.001}

DEFINE TEMP-TABLE tt-equipamentos NO-UNDO LIKE equipamentos
    FIELD cc-codigo    LIKE cc-equipamentos.cc-codigo
    FIELD r-rowid   AS ROWID
    INDEX cod-estabel equipamento cc-codigo.

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esutp010
&GLOBAL-DEFINE Version        2.06.00.001

&GLOBAL-DEFINE WindowType     detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Equipamentos

&GLOBAL-DEFINE page0Widgets   cb-pesquisa fi-valor bt-carrega btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   br-equipamentos btDetalhe


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-esutp002 AS HANDLE      NO-UNDO.

{upc/btb910za-upc.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-equipamentos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-equipamentos

/* Definitions for BROWSE br-equipamentos                               */
&Scoped-define FIELDS-IN-QUERY-br-equipamentos tt-equipamentos.equipamento tt-equipamentos.descricao tt-equipamentos.cc-codigo fn-departamento(INPUT tt-equipamentos.cc-codigo) tt-equipamentos.ct-codigo fn-tipo(INPUT tt-equipamentos.tipo) tt-equipamentos.cod-estabel fn-fornec(tt-equipamentos.fornecedor) tt-equipamentos.marca tt-equipamentos.modelo tt-equipamentos.serie-equipamento tt-equipamentos.serie-acessorio tt-equipamentos.ind-situacao tt-equipamentos.cod_usuario tt-equipamentos.val-limite tt-equipamentos.cargo tt-equipamentos.obs-situacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-equipamentos   
&Scoped-define SELF-NAME br-equipamentos
&Scoped-define QUERY-STRING-br-equipamentos FOR EACH tt-equipamentos NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-equipamentos OPEN QUERY {&SELF-NAME} FOR EACH tt-equipamentos NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-equipamentos tt-equipamentos
&Scoped-define FIRST-TABLE-IN-QUERY-br-equipamentos tt-equipamentos


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-equipamentos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar btQueryJoins ~
btReportsJoins btExit btHelp bt-carrega cb-pesquisa fi-valor btOK btCancel ~
btHelp2 
&Scoped-Define DISPLAYED-OBJECTS cb-pesquisa fi-valor 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-departamento wWindow 
FUNCTION fn-departamento RETURNS CHARACTER
  (INPUT c-cc AS CHARACTER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-fornec wWindow 
FUNCTION fn-fornec RETURNS CHARACTER
  (INPUT i-fornec AS INTEGER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-tipo wWindow 
FUNCTION fn-tipo RETURNS CHARACTER
  (INPUT i-tipo AS INTEGER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
DEFINE BUTTON bt-carrega 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.04.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
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

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

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

DEFINE VARIABLE cb-pesquisa AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 1 
     LABEL "Pesquisa" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEM-PAIRS "Equipamento",1,
                     "Descri‡Æo",2,
                     "Conta Cont bil",3,
                     "Centro de Custo",4,
                     "Estabelecimento",5,
                     "Tipo",6,
                     "Fornecedor",7,
                     "S‚rie Equipamentos",8,
                     "S‚rie Acess¢rios",9,
                     "Situacao Celular",10,
                     "Matr¡cula",11,
                     "Valor Limite",12
     DROP-DOWN-LIST
     SIZE 20.43 BY 1 NO-UNDO.

DEFINE VARIABLE fi-valor AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 107 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 107 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btDetalhe 
     LABEL "&Detalhe" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-equipamentos FOR 
      tt-equipamentos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-equipamentos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-equipamentos wWindow _FREEFORM
  QUERY br-equipamentos NO-LOCK DISPLAY
      tt-equipamentos.equipamento FORMAT "x(20)"
      tt-equipamentos.descricao   FORMAT "x(50)"
      tt-equipamentos.cc-codigo FORMAT "x(10)"
      fn-departamento(INPUT tt-equipamentos.cc-codigo) FORMAT "x(35)" COLUMN-LABEL "Departamento"
      tt-equipamentos.ct-codigo FORMAT "x(10)"
      fn-tipo(INPUT tt-equipamentos.tipo) FORMAT "x(14)" COLUMN-LABEL "Tipo"
      tt-equipamentos.cod-estabel FORMAT "x(04)"
      fn-fornec(tt-equipamentos.fornecedor) FORMAT "x(20)" COLUMN-LABEL "Fornecedor"
      tt-equipamentos.marca
      tt-equipamentos.modelo
      tt-equipamentos.serie-equipamento
      tt-equipamentos.serie-acessorio
      tt-equipamentos.ind-situacao
      tt-equipamentos.cod_usuario
      tt-equipamentos.val-limite
      tt-equipamentos.cargo
      tt-equipamentos.obs-situacao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 101 BY 10.08
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 91.43 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 95.43 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 99.43 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 103.43 HELP
          "Ajuda"
     bt-carrega AT ROW 3.04 COL 92 HELP
          "V  Para" WIDGET-ID 14
     cb-pesquisa AT ROW 3.13 COL 11.43 COLON-ALIGNED WIDGET-ID 10
     fi-valor AT ROW 3.13 COL 32.14 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     btOK AT ROW 18.58 COL 2
     btCancel AT ROW 18.58 COL 13
     btHelp2 AT ROW 18.58 COL 97.43
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 18.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 107.43 BY 19.13
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     br-equipamentos AT ROW 1.71 COL 2
     btDetalhe AT ROW 11.79 COL 2 HELP
          "Detalhe do Equipamento"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 5.71
         SIZE 103 BY 12.29
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
         TITLE              = ""
         HEIGHT             = 19.13
         WIDTH              = 107.43
         MAX-HEIGHT         = 21.63
         MAX-WIDTH          = 107.43
         VIRTUAL-HEIGHT     = 21.63
         VIRTUAL-WIDTH      = 107.43
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB br-equipamentos 1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-equipamentos
/* Query rebuild information for BROWSE br-equipamentos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-equipamentos NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-equipamentos */
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

  IF  VALID-HANDLE(h_api_ccusto) 
  THEN
      delete object h_api_ccusto.

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-equipamentos
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-equipamentos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-equipamentos wWindow
ON MOUSE-SELECT-DBLCLICK OF br-equipamentos IN FRAME fPage1
DO:
    APPLY "RETURN":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-equipamentos wWindow
ON RETURN OF br-equipamentos IN FRAME fPage1
DO:
    APPLY "CHOOSE":U TO btDetalhe IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-carrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-carrega wWindow
ON CHOOSE OF bt-carrega IN FRAME fpage0 /* Go To */
DO:
    DEFINE VARIABLE i-pesquisa AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-valor    AS CHARACTER   NO-UNDO.

    ASSIGN i-pesquisa = INT(cb-pesquisa:SCREEN-VALUE IN FRAME fPage0)
           c-valor   = fi-valor:SCREEN-VALUE IN FRAME fPage0.

  RUN pi-carrega-dados IN THIS-PROCEDURE (INPUT i-pesquisa,
                                          INPUT c-valor).
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDetalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhe wWindow
ON CHOOSE OF btDetalhe IN FRAME fPage1 /* Detalhe */
DO:
    CURRENT-WINDOW:SENSITIVE = NO.
    SESSION:SET-WAIT-STATE("GENERAL":U).

    IF AVAILABLE tt-equipamentos THEN DO:
        IF NOT VALID-HANDLE(h-esutp002) THEN
            RUN esp/utp/esutp002.w PERSISTENT SET h-esutp002.

        IF VALID-HANDLE(h-esutp002)                      AND
           h-esutp002:TYPE      = "PROCEDURE":U          AND
           h-esutp002:FILE-NAME = "esp/utp/esutp002.w":U THEN DO:
            RUN dispatch IN h-esutp002 (INPUT "Initialize":U).

            RUN repositionRecord IN h-esutp002 (INPUT tt-equipamentos.r-rowid).

            WAIT-FOR CLOSE OF h-esutp002.
        END.
    END.

    SESSION:SET-WAIT-STATE("":U).
    CURRENT-WINDOW:SENSITIVE = YES.
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


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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


&Scoped-define SELF-NAME fi-valor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-valor wWindow
ON RETURN OF fi-valor IN FRAME fpage0
DO:
  APPLY "choose" TO bt-carrega IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

run prgint\utb\utb742za.py persistent set h_api_ccusto.

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDetroyInterface wWindow 
PROCEDURE beforeDetroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-esutp002) THEN
        DELETE PROCEDURE h-esutp002.

    ASSIGN h-esutp002 = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-dados wWindow 
PROCEDURE pi-carrega-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-pesquisa AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-valor    AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-valor AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-valor AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-valor AS DECIMAL     NO-UNDO.

    FOR EACH tt-equipamentos:
        DELETE tt-equipamentos.
    END.

    ASSIGN c-valor = "*" + TRIM(p-valor) + "*".
    CASE p-pesquisa:
        WHEN 1 THEN DO:
            /*Equipamento*/
            FOR EACH equipamentos NO-LOCK
               WHERE equipamentos.equipamento MATCHES c-valor:

                IF NOT CAN-FIND(FIRST cc-equipamentos OF equipamentos NO-LOCK) THEN DO:
                    FIND FIRST tt-equipamentos NO-LOCK
                         WHERE tt-equipamentos.equipamento = equipamentos.equipamento NO-ERROR.
                    IF NOT AVAIL tt-equipamentos THEN DO:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = ""
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
                ELSE DO:
                    FOR EACH cc-equipamentos OF equipamentos NO-LOCK:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = cc-equipamentos.cc-codigo
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
            END.
        END.
        WHEN 2 THEN DO:
            /*Descri‡Æo*/
            FOR EACH equipamentos NO-LOCK
               WHERE equipamentos.descricao MATCHES c-valor:
                IF NOT CAN-FIND(FIRST cc-equipamentos OF equipamentos NO-LOCK) THEN DO:
                    FIND FIRST tt-equipamentos NO-LOCK
                         WHERE tt-equipamentos.equipamento = equipamentos.equipamento NO-ERROR.
                    IF NOT AVAIL tt-equipamentos THEN DO:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = ""
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
                ELSE DO:
                    FOR EACH cc-equipamentos OF equipamentos NO-LOCK:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = cc-equipamentos.cc-codigo
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
            END.
        END.
        WHEN 3 THEN DO:
            /*Conta Cont bil*/
            FOR EACH equipamentos NO-LOCK
               WHERE equipamentos.ct-codigo MATCHES c-valor:

                IF NOT CAN-FIND(FIRST cc-equipamentos OF equipamentos NO-LOCK) THEN DO:
                    FIND FIRST tt-equipamentos NO-LOCK
                         WHERE tt-equipamentos.equipamento = equipamentos.equipamento NO-ERROR.
                    IF NOT AVAIL tt-equipamentos THEN DO:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = ""
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
                ELSE DO:
                    FOR EACH cc-equipamentos OF equipamentos NO-LOCK:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = cc-equipamentos.cc-codigo
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
            END.
        END.
        WHEN 4 THEN DO:
            /*Centro de Custo*/
            FOR EACH cc-equipamentos NO-LOCK
               WHERE cc-equipamentos.cc-codigo MATCHES c-valor,
               FIRST equipamentos NO-LOCK
               WHERE equipamentos.cod-estabel = cc-equipamentos.cod-estabel
                 AND equipamentos.equipamento = cc-equipamentos.equipamento:

                CREATE tt-equipamentos.
                BUFFER-COPY equipamentos TO tt-equipamentos.
                ASSIGN tt-equipamentos.cc-codigo = cc-equipamentos.cc-codigo
                       tt-equipamentos.r-rowid   = ROWID(equipamentos).
            END.
        END.
        WHEN 5 THEN DO:
            /*Estabelecimento*/
            FOR EACH equipamentos NO-LOCK
               WHERE equipamentos.cod-estabel = p-valor:
                IF NOT CAN-FIND(FIRST cc-equipamentos OF equipamentos NO-LOCK) THEN DO:
                    FIND FIRST tt-equipamentos NO-LOCK
                         WHERE tt-equipamentos.equipamento = equipamentos.equipamento NO-ERROR.
                    IF NOT AVAIL tt-equipamentos THEN DO:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = ""
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
                ELSE DO:
                    FOR EACH cc-equipamentos OF equipamentos NO-LOCK:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = cc-equipamentos.cc-codigo
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
            END.
        END.
        WHEN 6 THEN DO:
            /*Tipo*/
            ASSIGN i-valor = INT(p-valor) NO-ERROR.
            IF ERROR-STATUS:ERROR OR i-valor = ? THEN DO:
                MESSAGE "Tipo inv lido, deve ser um valor inteiro"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
            FOR EACH equipamentos NO-LOCK
               WHERE equipamentos.tipo = i-valor:
                IF NOT CAN-FIND(FIRST cc-equipamentos OF equipamentos NO-LOCK) THEN DO:
                    FIND FIRST tt-equipamentos NO-LOCK
                         WHERE tt-equipamentos.equipamento = equipamentos.equipamento NO-ERROR.
                    IF NOT AVAIL tt-equipamentos THEN DO:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = ""
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
                ELSE DO:
                    FOR EACH cc-equipamentos OF equipamentos NO-LOCK:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = cc-equipamentos.cc-codigo
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
            END.
        END.
        WHEN 7 THEN DO:
            /*Fornecedor*/
            ASSIGN i-valor = INT(p-valor) NO-ERROR.
            IF ERROR-STATUS:ERROR OR i-valor = ? THEN DO:
                MESSAGE "Fornecedor inv lido, deve ser um valor inteiro"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
            FOR EACH equipamentos NO-LOCK
               WHERE equipamentos.fornecedor = i-valor:
                IF NOT CAN-FIND(FIRST cc-equipamentos OF equipamentos NO-LOCK) THEN DO:
                    FIND FIRST tt-equipamentos NO-LOCK
                         WHERE tt-equipamentos.equipamento = equipamentos.equipamento NO-ERROR.
                    IF NOT AVAIL tt-equipamentos THEN DO:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = ""
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
                ELSE DO:
                    FOR EACH cc-equipamentos OF equipamentos NO-LOCK:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = cc-equipamentos.cc-codigo
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
            END.
        END.
        WHEN 8 THEN DO:
            /*Serie Equip*/
            FOR EACH equipamentos NO-LOCK
               WHERE equipamentos.serie-equipamento MATCHES c-valor:
                IF NOT CAN-FIND(FIRST cc-equipamentos OF equipamentos NO-LOCK) THEN DO:
                    FIND FIRST tt-equipamentos NO-LOCK
                         WHERE tt-equipamentos.equipamento = equipamentos.equipamento NO-ERROR.
                    IF NOT AVAIL tt-equipamentos THEN DO:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = ""
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
                ELSE DO:
                    FOR EACH cc-equipamentos OF equipamentos NO-LOCK:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = cc-equipamentos.cc-codigo
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
            END.
        END.
        WHEN 9 THEN DO:
            /*Serie Acess*/
            FOR EACH equipamentos NO-LOCK
               WHERE equipamentos.serie-acessorio MATCHES c-valor:
                IF NOT CAN-FIND(FIRST cc-equipamentos OF equipamentos NO-LOCK) THEN DO:
                    FIND FIRST tt-equipamentos NO-LOCK
                         WHERE tt-equipamentos.equipamento = equipamentos.equipamento NO-ERROR.
                    IF NOT AVAIL tt-equipamentos THEN DO:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = ""
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
                ELSE DO:
                    FOR EACH cc-equipamentos OF equipamentos NO-LOCK:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = cc-equipamentos.cc-codigo
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
            END.
        END.
        WHEN 10 THEN DO:
            /*Situacao Cel*/
            ASSIGN i-valor = INT(p-valor) NO-ERROR.
            IF ERROR-STATUS:ERROR OR i-valor = ? THEN DO:
                MESSAGE "Situa‡Æo inv lida, deve ser um valor inteiro"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
            FOR EACH equipamentos NO-LOCK
               WHERE equipamentos.ind-situacao = i-valor:
                IF NOT CAN-FIND(FIRST cc-equipamentos OF equipamentos NO-LOCK) THEN DO:
                    FIND FIRST tt-equipamentos NO-LOCK
                         WHERE tt-equipamentos.equipamento = equipamentos.equipamento NO-ERROR.
                    IF NOT AVAIL tt-equipamentos THEN DO:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = ""
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
                ELSE DO:
                    FOR EACH cc-equipamentos OF equipamentos NO-LOCK:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = cc-equipamentos.cc-codigo
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
            END.
        END.
        WHEN 11 THEN DO:
            /*Matricula*/
            IF ERROR-STATUS:ERROR OR i-valor = ? THEN DO:
                MESSAGE "Matricula inv lida, deve ser um valor inteiro"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
            FOR EACH equipamentos NO-LOCK
               WHERE equipamentos.cod_usuario = p-valor:
                IF NOT CAN-FIND(FIRST cc-equipamentos OF equipamentos NO-LOCK) THEN DO:
                    FIND FIRST tt-equipamentos NO-LOCK
                         WHERE tt-equipamentos.equipamento = equipamentos.equipamento NO-ERROR.
                    IF NOT AVAIL tt-equipamentos THEN DO:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = ""
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
                ELSE DO:
                    FOR EACH cc-equipamentos OF equipamentos NO-LOCK:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = cc-equipamentos.cc-codigo
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
            END.
        END.
        WHEN 12 THEN DO:
            /*valor limite*/
            ASSIGN de-valor = DEC(p-valor) NO-ERROR.
            IF ERROR-STATUS:ERROR OR i-valor = ? THEN DO:
                MESSAGE "Valor Limite inv lido, deve ser um valor decimal"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
            FOR EACH equipamentos NO-LOCK
               WHERE equipamentos.val-limite = de-valor:
                IF NOT CAN-FIND(FIRST cc-equipamentos OF equipamentos NO-LOCK) THEN DO:
                    FIND FIRST tt-equipamentos NO-LOCK
                         WHERE tt-equipamentos.equipamento = equipamentos.equipamento NO-ERROR.
                    IF NOT AVAIL tt-equipamentos THEN DO:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = ""
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
                ELSE DO:
                    FOR EACH cc-equipamentos OF equipamentos NO-LOCK:
                        CREATE tt-equipamentos.
                        BUFFER-COPY equipamentos TO tt-equipamentos.
                        ASSIGN tt-equipamentos.cc-codigo = cc-equipamentos.cc-codigo
                               tt-equipamentos.r-rowid   = ROWID(equipamentos).
                    END.
                END.
            END.
        END.

        OTHERWISE DO:
            MESSAGE "Op‡Æo de pesquisa inv lida!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
    END CASE.

    {&OPEN-QUERY-br-equipamentos}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-departamento wWindow 
FUNCTION fn-departamento RETURNS CHARACTER
  (INPUT c-cc AS CHARACTER /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt_log_erro.
    run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,    /* EMPRESA EMS2 */
                                               input  "",                     /* CODIGO DO PLANO CCUSTO */
                                               input  c-cc,                   /* CCUSTO */
                                               input  today,                  /* DATA DE TRANSACAO */
                                               output v_des_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). 

    RETURN v_des_titulo_ccusto.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-fornec wWindow 
FUNCTION fn-fornec RETURNS CHARACTER
  (INPUT i-fornec AS INTEGER /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-fornec AS CHARACTER   NO-UNDO.

    FIND FIRST fornec-equipamentos NO-LOCK
         WHERE fornec-equipamentos.fornecedor = i-fornec NO-ERROR.
    IF AVAIL fornec-equipamentos THEN
        ASSIGN c-fornec = TRIM(STRING(i-fornec)) + "-" + fornec-equipamentos.nome.
    ELSE
        ASSIGN c-fornec = TRIM(STRING(i-fornec)) + "-" + "NÆo Cadastrado".


    RETURN c-fornec.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-tipo wWindow 
FUNCTION fn-tipo RETURNS CHARACTER
  (INPUT i-tipo AS INTEGER /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-tipo AS CHARACTER   NO-UNDO.

    FIND FIRST tipo-equipamentos NO-LOCK
         WHERE tipo-equipamentos.codigo = i-tipo NO-ERROR.
    IF AVAIL tipo-equipamentos THEN
        ASSIGN c-tipo = TRIM(STRING(i-tipo)) + "-" + TRIM(tipo-equipamentos.descricao).

    RETURN c-tipo.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

