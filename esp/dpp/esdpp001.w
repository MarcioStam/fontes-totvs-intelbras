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
{include/i-prgvrs.i ESDPP001 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESDPP001
&GLOBAL-DEFINE Version        2.04.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp
&GLOBAL-DEFINE page1Widgets   br-posicao BtInc BtDel bt-ok bt-cancela
&GLOBAL-DEFINE page2Widgets   rs-tipo FiPosIni FiLetra FiPosFim fi-layout ~
                              BtOk BtCancel

/* Parameters Definitions ---                                           */
DEF NEW GLOBAL SHARED VAR vRowdp-estrut     AS ROWID NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-local-montag   AS WIDGET-HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
def temp-table tt-pos
    field letra    as char format "X(15)"     
    field ord      as dec
    field pos      as char format "x(15)"  
    index tt-pos is primary unique 
          letra 
          ord
    index ordem 
          letra
          pos.
                              
def temp-table tt-string
    field letra    as char
    field pos      as char
    index formato 
          letra.

def buffer b-dp-estrut for dp-estrut.
def buffer b-tt-pos    for tt-pos.

def var l-texto         as log.
def var l-conf as logical format "Sim/Nao".
def var l-tem as logical.
def var l-alterou       as log  no-undo initial no.
def var c-local         as char no-undo.
def var i-ind           as int.
def var i               as int.
def var i-ind1          as int.
def var c-letra         as char.
DEF VAR c-letra-controle AS CHAR.
def var c-parte         as char.
def var c-parte1        as char.
def var c-pos           as char.
def var c-pos-ant       as char.
def var c-pos-inc       as char.
def var c-pos-inc-tt    as char.
def var l-fechou        as log.
def var l-erro          as log.
def var c-pos-ini       as char format "x(15)".
def var c-pos-fim       as char format "x(15)".
def var c-msg           as char init "<I>Inclui   <E>Elimina   <F1>Sair".
DEFINE VARIABLE i-testa AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-local-montag-anterior AS CHARACTER   NO-UNDO.

{esp\enp\esenp001.i1}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-posicao

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-pos

/* Definitions for BROWSE br-posicao                                    */
&Scoped-define FIELDS-IN-QUERY-br-posicao tt-pos.letra tt-pos.pos   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-posicao   
&Scoped-define SELF-NAME br-posicao
&Scoped-define QUERY-STRING-br-posicao FOR EACH tt-pos NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-posicao OPEN QUERY {&SELF-NAME} FOR EACH tt-pos NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-posicao tt-pos
&Scoped-define FIRST-TABLE-IN-QUERY-br-posicao tt-pos


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-posicao}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btQueryJoins btReportsJoins ~
btExit btHelp 

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

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-cancela 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btDel 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btInc 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar-4
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89.72 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-layout AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 79 BY .88 NO-UNDO.

DEFINE VARIABLE FiLetra AS CHARACTER FORMAT "X(15)":U 
     LABEL "Letra" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE FiPosFim AS CHARACTER FORMAT "X(6)":U 
     LABEL "Posi‡Æo Final" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE FiPosIni AS CHARACTER FORMAT "X(6)":U 
     LABEL "Posi‡Æo Inicial" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE lb-layout AS CHARACTER FORMAT "X(256)":U INITIAL "Utilizar Local de Montagem enviado pelo Layout" 
      VIEW-AS TEXT 
     SIZE 33 BY .67 NO-UNDO.

DEFINE VARIABLE rs-tipo AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "1", 1,
"2", 2
     SIZE 2.29 BY 7.21 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 3.75.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 1.75.

DEFINE RECTANGLE rtToolBar-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89.72 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-posicao FOR 
      tt-pos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-posicao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-posicao wWindow _FREEFORM
  QUERY br-posicao NO-LOCK DISPLAY
      tt-pos.letra 
    tt-pos.pos
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 42 BY 13
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     br-posicao AT ROW 1.25 COL 22.72
     bt-ok AT ROW 14.75 COL 1.72 WIDGET-ID 2
     btInc AT ROW 14.75 COL 22.72
     btDel AT ROW 14.75 COL 33.57
     bt-cancela AT ROW 14.75 COL 80 WIDGET-ID 4
     rtToolBar-4 AT ROW 14.5 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.75
         SIZE 90 BY 15
         FONT 1.

DEFINE FRAME fPage2
     rs-tipo AT ROW 1.58 COL 3.72 NO-LABEL WIDGET-ID 8
     FiLetra AT ROW 2 COL 35.14 COLON-ALIGNED
     FiPosIni AT ROW 3 COL 35.14 COLON-ALIGNED
     FiPosFim AT ROW 4 COL 35.14 COLON-ALIGNED
     fi-layout AT ROW 6.5 COL 6.14 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     btOK AT ROW 14.71 COL 2
     btCancel AT ROW 14.71 COL 13
     lb-layout AT ROW 5.67 COL 6.14 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     RECT-1 AT ROW 1.5 COL 7.14
     rtToolBar-3 AT ROW 14.5 COL 1
     RECT-33 AT ROW 6 COL 7.14 WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.75
         SIZE 90 BY 15
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
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

{window/window.i}

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
                                                                        */
/* BROWSE-TAB br-posicao rtToolBar-4 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-posicao
/* Query rebuild information for BROWSE br-posicao
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-pos NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-posicao */
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela wWindow
ON CHOOSE OF bt-cancela IN FRAME fPage1 /* Cancelar */
DO:

    EMPTY TEMP-TABLE tt-pos.

    ASSIGN wh-local-montag:SCREEN-VALUE = c-local-montag-anterior
           c-letra                      = c-local-montag-anterior.

    RUN AfterInitializeInterface.

    APPLY "CHOOSE" TO btExit IN FRAME fpage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok wWindow
ON CHOOSE OF bt-ok IN FRAME fPage1 /* OK */
DO:

    APPLY "CHOOSE" TO btExit IN FRAME fpage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fPage2 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDel wWindow
ON CHOOSE OF btDel IN FRAME fPage1 /* Eliminar */
DO:
    IF AVAIL tt-pos THEN
    DO:
        run utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 27100, 
                           INPUT "Confirma a exclusao da posicao?").
        IF RETURN-VALUE = "YES" THEN
           DELETE tt-pos.
        {&OPEN-QUERY-Br-Posicao}
    END.
    /*APPLY "CLOSE":U TO THIS-PROCEDURE.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    FOR EACH tt-string:
        DELETE tt-string.
    END.
    
    RUN piMontaPos.
    
    IF LENGTH(c-letra) > 40 THEN DO:

        MESSAGE c-letra SKIP(2)
                "Para prosseguir com o cadastro, favor eliminar os caracteres a mais seguindo a informa‡Æo abaixo: "  SKIP(2)
                c-letra-controle
                    VIEW-AS ALERT-BOX.

        ASSIGN c-letra = c-letra-controle.

        RETURN 'nok'.

    END.


    FIND CURRENT dp-estrut EXCLUSIVE-LOCK NO-ERROR.
    IF l-alterou AND AVAIL dp-estrut THEN 
        RUN upc/dp0301ax-upc.p (INPUT ROWID(dp-estrut), 
                                INPUT "NO", 
                                INPUT dp-estrut.local-montag).
     
    /*ASSIGN dp-estrut.local-montag = c-letra.*/
    FIND CURRENT dp-estrut NO-LOCK NO-ERROR.
    IF l-alterou AND AVAIL dp-estrut THEN DO:
        RUN upc/dp0301ax-upc.p (INPUT ROWID(dp-estrut), 
                                INPUT "YES", 
                                INPUT "").
    END.
    
    ASSIGN wh-local-montag:SCREEN-VALUE = c-letra /*dp-estrut.local-montag*/ .
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btInc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInc wWindow
ON CHOOSE OF btInc IN FRAME fPage1 /* Incluir */
DO:
    HIDE FRAME fPage1.
    ASSIGN fiPosIni:SENSITIVE IN FRAME fPage2 = YES.
    VIEW FRAME fPage2.
    APPLY "ENTRY" TO FiLetra IN FRAME fPage2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fPage2 /* OK */
DO:
    DEFINE VARIABLE l-erro AS LOGICAL    NO-UNDO.

    ASSIGN INPUT FiLetra
           INPUT fiPosIni
           INPUT fiPosFim
           INPUT fi-layout
           INPUT rs-tipo.


    IF rs-tipo = 1 THEN DO:

        /* Se for letra, s¢ pode ter um caracter */
        ASSIGN i-testa = int(fiPosIni) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
    
            IF LENGTH(fiPosIni) > 1 THEN DO:
    
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Quando utilizar Letra na Sequencia, a mesma s¢ pode conter UM caracter.").
    
                RETURN NO-APPLY.
    
            END.
    
        END.
    
        ASSIGN i-testa = int(fiPosFim) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
    
            IF LENGTH(fiPosFim) > 1 THEN DO:
    
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Quando utilizar Letra na Sequencia, a mesma s¢ pode conter UM caracter.").
    
                RETURN NO-APPLY.
    
            END.
    
        END.
    
    
        RUN piTestaPosicao(INPUT fiPosIni,
                           OUTPUT l-erro).  /* l-erro quer dizer alfanum */
        IF l-erro = ? THEN DO:
           MESSAGE "Caracteres invalidos na string" 
                    VIEW-AS ALERT-BOX.
           RETURN NO-APPLY.
        END.
        ELSE IF l-erro = NO THEN DO:
            IF DEC(FiPosini) > DEC(FiPosfim) THEN DO:
               MESSAGE "Posicao inicial maior que posicao final" 
                       VIEW-AS ALERT-BOX.
               RETURN NO-APPLY.
            END.
        END.
    
        IF FiPosini > FiPosfim THEN DO:
           MESSAGE "Posicao inicial maior que posicao final" 
                   VIEW-AS ALERT-BOX.
           RETURN NO-APPLY.
        END.
    
        /* Ana Claudia falou que haver  posi‡äe de at‚ 3 casas decimais
        ELSE ASSIGN FiPosfim = FiPosini.*/
    
        DO TRANSACTION:
            HIDE FRAME fPage2.
            VIEW FRAME fPage1.
            RUN piCriaSegmento(INPUT FiLetra,
                               INPUT FiPosIni, 
                               INPUT FiPosFim, 
                               INPUT l-erro).
            FOR EACH tt-string:
                DELETE tt-string.
            END.
            RUN piMontaPos.
            IF LENGTH(c-letra) > 40 THEN 
               run utp/ut-msgs.p (INPUT "show":U, 
                                  INPUT 27979, 
                                  INPUT "A quantidade de posicoes estrapolou o tamanho do campo. Favor eliminar as ultimas posi‡äes de montagem." + CHR(13) + c-letra).
        END.

    END.
    ELSE DO:

        RUN piMontaLayout.

        IF RETURN-VALUE = "OK" THEN DO:

            HIDE FRAME fPage2.
            VIEW FRAME fPage1.

        END.

    END.

    {&OPEN-QUERY-Br-Posicao}
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME rs-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo wWindow
ON VALUE-CHANGED OF rs-tipo IN FRAME fPage2
DO:

    DO WITH FRAME fpage2:

        ASSIGN fiLetra:SENSITIVE = (SELF:INPUT-VALUE = 1)
               fiPosIni:SENSITIVE = (SELF:INPUT-VALUE = 1)
               fiPosFim:SENSITIVE = (SELF:INPUT-VALUE = 1)
               fi-layout:SENSITIVE = (SELF:INPUT-VALUE = 2).

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-posicao
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    VIEW FRAME fPage1.
    HIDE FRAME fPage2.

    DEFINE VARIABLE l-erro AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cLocalMontagem AS CHARACTER  NO-UNDO.

    FOR FIRST dp-estrut 
        WHERE ROWID(dp-estrut) = vRowdp-estrut.
        ASSIGN l-texto = NO.
    END.
    /*IF NOT AVAIL dp-estrut THEN RETURN "NOK".*/
    ASSIGN cLocalMontagem = wh-local-montag:SCREEN-VALUE
           cLocalMontagem = REPLACE(cLocalMontagem,"),",");")
           cLocalMontagem = REPLACE(cLocalMontagem,") ,",");")
           cLocalMontagem = REPLACE(cLocalMontagem," ","").

    ASSIGN c-local-montag-anterior = wh-local-montag:SCREEN-VALUE.

    /*
    ASSIGN cLocalMontagem = wh-local-montag:SCREEN-VALUE
           cLocalMontagem = REPLACE(cLocalMontagem,",",";")
           cLocalMontagem = REPLACE(cLocalMontagem," ","").
    */

    RUN piTestaLocalMont(INPUT  cLocalMontagem /*dp-estrut.local-montag*/ , 
                         OUTPUT l-erro).
    IF l-erro THEN DO:
       MESSAGE "Local de montagem esta fora dos padroes permitidos."
               "Sera considerado como texto" VIEW-AS ALERT-BOX.
       ASSIGN l-texto = YES.
       RUN upc/dp0301ax-upc.p (INPUT vRowdp-estrut, 
                               INPUT "YES", 
                               INPUT "").
    END.
    ELSE IF l-texto = NO THEN 
    DO:
         IF INDEX(cLocalMontagem /*dp-estrut.local-montag*/ ,";") = 0 AND 
            INDEX(cLocalMontagem /*dp-estrut.local-montag*/ ,"(") = 0 THEN DO:
            RUN piCriaSegmento(INPUT cLocalMontagem /*dp-estrut.local-montag*/ ,
                               INPUT "",
                               INPUT "", 
                               INPUT YES).
         END.
         ELSE DO i = 1 TO NUM-ENTRIES(cLocalMontagem /*dp-estrut.local-montag*/ ,";"):
             ASSIGN c-local = ENTRY(i,cLocalMontagem /*dp-estrut.local-montag*/ ,";").
             IF INDEX(c-local,"(") = 0 THEN DO:
                 ASSIGN c-letra = c-local
                        c-parte = "".
                 RUN piCriaSegmento(INPUT c-letra,
                                    INPUT "",
                                    INPUT "",
                                    INPUT yes).

             END.
             ELSE DO:
                 ASSIGN c-letra = substr(c-local,1,index(c-local,"(") - 1)
                        c-parte = substr(c-local,
                                         index(c-local,"(") + 1, 
                                         index(c-local,")") - (index(c-local,"(") + 1)).
                 DO i-ind = 1 TO NUM-ENTRIES(c-parte,","):
                    ASSIGN c-parte1 = ENTRY(i-ind,c-parte,",") NO-ERROR.
                    IF index(c-parte1,"-") <> 0 THEN DO:
                        ASSIGN c-pos-ini = ENTRY(1,c-parte1,"-")
                               c-pos-fim = ENTRY(2,c-parte1,"-").
                        IF ASC(CAPS(c-pos-ini)) >= 65 THEN DO:
                            RUN piCriaSegmento(INPUT c-letra, 
                                               INPUT c-pos-ini, 
                                               INPUT c-pos-fim, 
                                               INPUT YES).
                        END.
                        ELSE DO:
                            RUN piCriaSegmento(INPUT c-letra, 
                                               INPUT c-pos-ini, 
                                               INPUT c-pos-fim, 
                                               INPUT NO).
                        END.
                    END.
                    ELSE DO:
                        RUN piCriaSegmento(INPUT c-letra, 
                                           INPUT c-parte1, 
                                           INPUT c-parte1, 
                                           INPUT YES).
                    END.
                 END.
             END.
         END. /* ELSE DO i = 1 TO NUM-ENTRIES(dp-estrut.local-montag,";"): */
    END. /* ELSE IF l-texto = NO THEN  */
   
    IF NOT l-texto THEN DO:
       {&OPEN-QUERY-Br-Posicao}
    END.

    APPLY "VALUE-CHANGED" TO rs-tipo IN FRAME fpage2.

    ASSIGN lb-layout:SCREEN-VALUE = "Utilizar Local de Montagem enviado pelo Layout".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piConverte wWindow 
PROCEDURE piConverte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param c-pos as char no-undo.
   def output param de-num as dec no-undo.

   def var c-carac as char    no-undo.
   def var c-mult  as char    no-undo.
   def var i-cont  as integer no-undo.
   def var l-alfa  as logical no-undo.
   
   def var de-mult as decimal no-undo.

   assign c-mult = "100000000000000000000000000000".
   do i-cont = 1 to length(trim(c-pos)):
      assign c-carac = c-carac 
                     + string(asc(caps(substring(c-pos,i-cont,1)))).
      if asc(caps(substring(c-pos,i-cont,1))) >= 65 then do: 
         l-alfa = yes.
      end.
   end.
   if l-alfa then do:
      assign de-mult = dec(substring(c-mult,1,((30 - length(c-carac)) + 1)))
             de-num = (dec(c-carac) * de-mult).
   end.
   else 
      assign de-num = dec(c-pos).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaSegmento wWindow 
PROCEDURE piCriaSegmento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param c-letra as char no-undo.
   def input param c-ini   as char no-undo.
   def input param c-fim   as char no-undo.
   def input param l-alfa  as logical no-undo.
   def var c-carac as char    no-undo.
   def var i       as integer no-undo.
   def var ini     as int     no-undo.
   def var fim     as int     no-undo.
   
   if l-alfa = no then do:
      assign ini = int(c-ini)
             fim = int(c-fim).
      do i = ini to fim:
         assign c-carac  = caps(string(i)).
         find first tt-pos where tt-pos.letra = c-letra 
                             and tt-pos.pos   = trim(c-carac)
                           no-error.
         if not avail tt-pos then do:                  
            create tt-pos.
            assign tt-pos.letra   = caps(c-letra)
                   tt-pos.pos     = trim(c-carac). 
            if trim(tt-pos.pos) = "0" then 
               assign tt-pos.pos = "".
            run PiConverte(trim(c-carac), output tt-pos.ord).       
         end.          
      end.
   end.
   else do:
      if c-ini = c-fim then do:
         find first tt-pos where tt-pos.letra = c-letra 
                             and tt-pos.pos   = trim(c-ini)
                           no-error.
         if not avail tt-pos then do:                  
            create tt-pos.
            assign tt-pos.letra   = caps(c-letra)
                   tt-pos.pos     = caps(trim(c-ini)).
            if trim(tt-pos.pos) = "0" then 
               assign tt-pos.pos = "".
            run PiConverte(trim(c-ini), output tt-pos.ord).
         end.
      end.   
      else do:
         do i = asc(caps(c-ini)) to asc(caps(c-fim)):
            find first tt-pos where tt-pos.letra = c-letra
                                and tt-pos.pos   = chr(i)
                              no-error.
            if not avail tt-pos then do:                  
               create tt-pos.
               assign tt-pos.letra   = caps(c-letra)
                      tt-pos.pos     = chr(i).
               if trim(tt-pos.pos) = "0" then 
                  assign tt-pos.pos = "".
               run PiConverte(chr(i), output tt-pos.ord).
            end.
         end.
      end.          
   end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMontaLayout wWindow 
PROCEDURE piMontaLayout :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-layout AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-entradas AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-loc AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-pos AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-teste AS INTEGER     NO-UNDO.

    DEFINE VARIABLE c-letra AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-numero AS INTEGER     NO-UNDO.
    DEFINE VARIABLE d-ord AS DECIMAL     NO-UNDO.


    ASSIGN c-layout = trim(replace(fi-layout, " ", "")).


    DO i-entradas = 1 TO LENGTH(c-layout):

        ASSIGN c-letra = SUBSTRING(c-layout, i-entradas, 1).

        IF asc(c-letra) = 44                            OR          /* V¡rgula */
          (ASC(c-letra) >= 48 AND ASC(c-letra) <= 57)   OR          /* N£meros */
          (ASC(c-letra) >= 65 AND ASC(c-letra) <= 90)   OR          /* Letras mai£sculas */  
          (ASC(c-letra) >= 97 AND ASC(c-letra) <= 122)  THEN DO:    /* Letras min£sculas */

        END.
        ELSE DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Caracteres inv lidos na string do Layout.").

            APPLY "ENTRY" TO fi-layout IN FRAME fpage2.

            RETURN "NOK":U.

        END.

    END.

    DO i-entradas = 1 TO NUM-ENTRIES(c-layout, ","):

        ASSIGN c-loc = ENTRY(i-entradas, c-layout)
               i-pos = LENGTH(c-loc)
               c-letra = ""
               i-numero = ?.
             
        REPEAT:

            ASSIGN i-teste = int(SUBSTRING(c-loc, i-pos, 1)) NO-ERROR.

            IF ERROR-STATUS:ERROR THEN DO:

                ASSIGN c-letra = SUBSTRING(c-loc, 1, i-pos).

                IF i-pos < LENGTH(c-loc) THEN
                    ASSIGN i-numero = INT(SUBSTRING(c-loc, i-pos + 1, LENGTH(c-loc) - LENGTH(c-letra))).

                LEAVE.

            END.

            IF i-pos < 1 THEN
                LEAVE.

            ASSIGN i-pos = i-pos - 1.
            
        END.

        run PiConverte(STRING(i-numero), output d-ord).

        IF NOT CAN-FIND(FIRST tt-pos
                        WHERE tt-pos.letra = c-letra
                        AND   tt-pos.ord   = d-ord) THEN DO:

            CREATE tt-pos.
            ASSIGN tt-pos.letra = c-letra
                   tt-pos.ord   = d-ord
                   tt-pos.pos   = string(i-numero).

        END.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PiMontaPos wWindow 
PROCEDURE PiMontaPos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def var de-cont as decimal no-undo.
   def var de-dif  as decimal no-undo.
   def var l-traco as logical no-undo.
   def var c-ult-pos as char no-undo.
   DEF VAR i-aux AS INTEGER NO-UNDO.

   
   for each tt-pos break by tt-pos.letra 
                         by tt-pos.ord:
       if first-of(tt-pos.letra) then do:
          create tt-string.
          assign tt-string.letra = tt-pos.letra
                 tt-string.pos   = trim(tt-pos.pos)
                 de-cont         = tt-pos.ord.
                 l-traco         = no.
          next.       
       end.
       
       assign de-dif = tt-pos.ord - de-cont.   
       if de-dif > 1 and de-dif <> 10000000000000000000000000000 then do:
          if l-traco = yes then 
             assign tt-string.pos = trim(tt-string.pos)
                                  + "-"
                                  + trim(c-ult-pos)
                                  + ","
                                  + trim(tt-pos.pos)
                    l-traco       = no.
          else
             assign tt-string.pos = trim(tt-string.pos)
                                  + ","
                                  + trim(tt-pos.pos).
          assign de-cont = tt-pos.ord.
       end.
       else do: 
          assign de-cont = tt-pos.ord
                 l-traco = yes
                 c-ult-pos = tt-pos.pos.
          if last-of(tt-pos.letra) then do:
             assign tt-string.pos = trim(tt-string.pos)
                                  + "-"
                                  + trim(tt-pos.pos).
          end.                        
       end.                           
       if substring(tt-string.pos,1,1) = "," then 
          assign tt-string.pos 
               = substring(tt-string.pos,2,length(tt-string.pos)).
   end.
   assign c-letra = "".
   for each tt-string:

       if c-letra <> "" then 
          assign c-letra = c-letra + ";".

       assign c-letra = c-letra 
                      + trim(tt-string.letra)
                      + (if tt-string.pos <> "" then "(" else "")         
                      + trim(tt-string.pos)
                      + (if tt-string.pos <> "" then ")" else "").

        /*IF length(c-letra) <= 55  THEN
            ASSIGN c-letra-controle = c-letra.*/

   end.                   

    
    IF LENGTH(c-letra) > 40 /*55*/ THEN DO:
   
        DO i-aux = 40 /*55*/ TO 1 BY -1:
        
            CASE SUBSTRING(c-letra, i-aux, 1):
        
                WHEN ";" THEN DO:
        
                    ASSIGN c-letra-controle = SUBSTRING(c-letra, 1, i-aux - 1).
                    LEAVE.
        
                END.
        
                WHEN "," THEN DO:
        
                    ASSIGN  c-letra-controle = SUBSTRING(c-letra, 1, i-aux - 1) + ")".
                    LEAVE.
        
                END.
        
                WHEN ")" THEN DO:
        
                    ASSIGN c-letra-controle = SUBSTRING(c-letra, 1, i-aux).
                    LEAVE.
        
                END.
        
        
            END CASE.
        
        END.

    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTestaPosicao wWindow 
PROCEDURE piTestaPosicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input  param c-ini  as char    no-undo.
   def output param l-erro as logical no-undo.

   def var c-tipo-ini as char extent 15 no-undo.
   def var i-cont  as integer no-undo.
   def var i-car   as integer no-undo.
   

   do i-cont = 1 to length(trim(c-ini)):
      assign i-car = asc(caps(substring(c-ini,i-cont,1)))
             c-tipo-ini[i-cont] = (if i-car >= 65 and i-car <= 90 then "A"
                                   else if i-car >= 48 and i-car <= 57 then "N"
                                   else "X")
             l-erro = (if c-tipo-ini[i-cont] = "X" then ? else 
                       if c-tipo-ini[i-cont] = "A" then yes else no).
      if l-erro = yes or l-erro = ? then leave.
   end.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

