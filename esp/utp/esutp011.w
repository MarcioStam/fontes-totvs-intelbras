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
{include/i-prgvrs.i ESUTP011 1.00.00.000}

DEFINE TEMP-TABLE tt-equipamentos NO-UNDO LIKE equipamentos
    FIELD cc-codigo    LIKE cc-equipamentos.cc-codigo
    FIELD cc-codigo2   LIKE cc-equipamentos.cc-codigo
    FIELD selec        AS LOGICAL FORMAT "*/"
    FIELD r-rowid      AS ROWID
    FIELD r-cc         AS ROWID 
    INDEX cod-estabel equipamento cc-codigo.

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esutp011
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Equipamentos

&GLOBAL-DEFINE page0Widgets   fi-cc-de bt-carrega btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   br-equipamentos fi-cc-para btTodos btNenhum


/* Parameters Definitions ---                                           */

{upc/btb910za-upc.i} /* Defini‡Æo da vari vel New Global Shared "v_cod_estab_usuar" */


/* Local Variable Definitions ---                                       */

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
&Scoped-define FIELDS-IN-QUERY-br-equipamentos tt-equipamentos.selec tt-equipamentos.equipamento tt-equipamentos.descricao tt-equipamentos.ct-codigo tt-equipamentos.cc-codigo tt-equipamentos.cc-codigo2   
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
btReportsJoins btExit btHelp bt-carrega fi-cc-de btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-cc-de 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-cc-valido wWindow 
FUNCTION f-cc-valido RETURNS LOGICAL
  ( INPUT p-cc-codigo AS CHAR )  FORWARD.

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
     LABEL "Executar" 
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

DEFINE VARIABLE fi-cc-de AS CHARACTER FORMAT "X(08)":U 
     LABEL "Centro Custo DE" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 105 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 105 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btNenhum 
     LABEL "Nenhum" 
     SIZE 9.29 BY 1.

DEFINE BUTTON btTodos 
     LABEL "Todos" 
     SIZE 9.29 BY 1.

DEFINE VARIABLE fi-cc-para AS CHARACTER FORMAT "X(08)":U 
     LABEL "Centro Custo PARA" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-equipamentos FOR 
      tt-equipamentos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-equipamentos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-equipamentos wWindow _FREEFORM
  QUERY br-equipamentos NO-LOCK DISPLAY
      tt-equipamentos.selec       FORMAT "*/" COLUMN-LABEL ""
      tt-equipamentos.equipamento
      tt-equipamentos.descricao
      tt-equipamentos.ct-codigo   FORMAT "x(10)"
      tt-equipamentos.cc-codigo   FORMAT "x(10)" COLUMN-LABEL "CC. DE"
      tt-equipamentos.cc-codigo2  FORMAT "x(10)" COLUMN-LABEL "CC. PARA"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 99 BY 10.88
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 89.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 93.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 97.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 101.57 HELP
          "Ajuda"
     bt-carrega AT ROW 2.63 COL 33.14 HELP
          "V  Para" WIDGET-ID 14
     fi-cc-de AT ROW 2.71 COL 17 COLON-ALIGNED WIDGET-ID 12
     btOK AT ROW 18.58 COL 2
     btCancel AT ROW 18.58 COL 13
     btHelp2 AT ROW 18.58 COL 95.57
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 18.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 105 BY 19.13
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     btTodos AT ROW 1.46 COL 31.72 WIDGET-ID 20
     btNenhum AT ROW 1.46 COL 41.14 WIDGET-ID 22
     fi-cc-para AT ROW 1.5 COL 15 COLON-ALIGNED WIDGET-ID 18
     br-equipamentos AT ROW 2.63 COL 2 WIDGET-ID 200
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.79
         SIZE 101.43 BY 12.96
         FONT 1 WIDGET-ID 100.


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
         HEIGHT             = 19.13
         WIDTH              = 105
         MAX-HEIGHT         = 21.63
         MAX-WIDTH          = 105.14
         VIRTUAL-HEIGHT     = 21.63
         VIRTUAL-WIDTH      = 105.14
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
/* BROWSE-TAB br-equipamentos fi-cc-para fPage1 */
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
    DEFINE VARIABLE c-para-cc AS CHARACTER   NO-UNDO.
    
    ASSIGN c-para-cc = INPUT fi-cc-para:SCREEN-VALUE IN FRAME fPage1.
    
    IF AVAIL tt-equipamentos THEN DO:
        IF c-para-cc = "" THEN DO:
            MESSAGE "Informe Centro Custo PARA."
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        ELSE DO:

            IF NOT f-cc-valido(c-para-cc) THEN DO:
                MESSAGE "Centro de custo inv lido!"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
            ELSE DO:
                ASSIGN tt-equipamentos.selec = NOT tt-equipamentos.selec.

                ASSIGN tt-equipamentos.cc-codigo2 = IF tt-equipamentos.selec THEN c-para-cc ELSE "".

                DISP tt-equipamentos.selec
                     tt-equipamentos.cc-codigo2 WITH BROWSE br-equipamentos.

                RUN pi-cor-browser.
            END.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-equipamentos wWindow
ON ROW-DISPLAY OF br-equipamentos IN FRAME fPage1
DO:
  RUN pi-cor-browser.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-carrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-carrega wWindow
ON CHOOSE OF bt-carrega IN FRAME fpage0 /* Go To */
DO:
  RUN pi-carrega-dados IN THIS-PROCEDURE (INPUT fi-cc-de:SCREEN-VALUE IN FRAME fPage0).
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btNenhum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNenhum wWindow
ON CHOOSE OF btNenhum IN FRAME fPage1 /* Nenhum */
DO:
    IF AVAIL tt-equipamentos THEN DO:
        FOR EACH tt-equipamentos:
            ASSIGN tt-equipamentos.selec = NO
                   tt-equipamentos.cc-codigo2 = "".
        END.
    END.
    ELSE DO:
        MESSAGE "NÆo existe equipamentos para alterar, favor carregar dados!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

     {&OPEN-QUERY-br-equipamentos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
    /*APPLY "CLOSE":U TO THIS-PROCEDURE.*/
    IF CAN-FIND(FIRST tt-equipamentos WHERE tt-equipamentos.selec) THEN DO:

        MESSAGE "Confirma altera‡Æo?" UPDATE v-confirma AS LOGICAL 
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO.

        IF v-confirma THEN DO:
            DEFINE BUFFER b-cc FOR cc-equipamentos.
            FOR EACH tt-equipamentos NO-LOCK WHERE tt-equipamentos.selec,
                FIRST cc-equipamentos EXCLUSIVE-LOCK 
                WHERE ROWID(cc-equipamentos) = tt-equipamentos.r-cc:

                FIND FIRST b-cc NO-LOCK
                     WHERE b-cc.cod-estabel = cc-equipamentos.cod-estabel
                       AND b-cc.equipamento = cc-equipamentos.equipamento
                       AND b-cc.cc-codigo   = tt-equipamentos.cc-codigo2 NO-ERROR.
                IF NOT AVAIL b-cc THEN
                    ASSIGN cc-equipamentos.cc-codigo = tt-equipamentos.cc-codigo2.
            END.
        END.
        ASSIGN fi-cc-para:SCREEN-VALUE IN FRAME fPage1 = "".
        APPLY "choose" TO bt-carrega IN FRAME fPage0.
    END.
    ELSE DO:
        MESSAGE "Nenhum equipamentos alterado, favor selecionar equipamentos!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btTodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btTodos wWindow
ON CHOOSE OF btTodos IN FRAME fPage1 /* Todos */
DO:
    /*APPLY "CLOSE":U TO THIS-PROCEDURE.*/
    DEFINE VARIABLE c-para-cc AS CHARACTER   NO-UNDO.
    
    ASSIGN c-para-cc = INPUT fi-cc-para:SCREEN-VALUE IN FRAME fPage1.
    
    IF AVAIL tt-equipamentos THEN DO:
        IF c-para-cc = "" THEN DO:
            MESSAGE "Informe Centro Custo PARA."
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        ELSE DO:

            IF NOT f-cc-valido(c-para-cc) THEN DO:
                MESSAGE "Centro de custo inv lido!"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
            ELSE DO:
                FOR EACH tt-equipamentos:
                    ASSIGN tt-equipamentos.selec = YES
                           tt-equipamentos.cc-codigo2 = c-para-cc.
                END.
            END.
        END.
    END.
    ELSE DO:
        MESSAGE "NÆo existe equipamentos para alterar, favor carregar dados!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

     {&OPEN-QUERY-br-equipamentos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME fi-cc-de
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-de wWindow
ON RETURN OF fi-cc-de IN FRAME fpage0 /* Centro Custo DE */
DO:
  APPLY "choose" TO bt-carrega IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fi-cc-para
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-para wWindow
ON RETURN OF fi-cc-para IN FRAME fPage1 /* Centro Custo PARA */
DO:
  APPLY "choose" TO bt-carrega IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-dados wWindow 
PROCEDURE pi-carrega-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-valor    AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-valor AS CHARACTER   NO-UNDO.
    FOR EACH tt-equipamentos:
        DELETE tt-equipamentos.
    END.

    ASSIGN c-valor = "*" + TRIM(p-valor) + "*".
    /*Centro de Custo*/
    FOR EACH cc-equipamentos NO-LOCK
       WHERE cc-equipamentos.cc-codigo MATCHES c-valor,
       FIRST equipamentos NO-LOCK
       WHERE equipamentos.cod-estabel = cc-equipamentos.cod-estabel
         AND equipamentos.equipamento = cc-equipamentos.equipamento:

        CREATE tt-equipamentos.
        BUFFER-COPY equipamentos TO tt-equipamentos.
        ASSIGN tt-equipamentos.cc-codigo = cc-equipamentos.cc-codigo
               tt-equipamentos.r-rowid   = ROWID(equipamentos)
               tt-equipamentos.r-cc      = ROWID(cc-equipamentos).
    END.

    {&OPEN-QUERY-br-equipamentos}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cor-browser wWindow 
PROCEDURE pi-cor-browser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF AVAIL tt-equipamentos AND tt-equipamentos.selec THEN DO:
        ASSIGN tt-equipamentos.selec:BGCOLOR IN BROWSE br-equipamentos = 3
               tt-equipamentos.equipamento:BGCOLOR IN BROWSE br-equipamentos = 3
               tt-equipamentos.descricao:BGCOLOR IN BROWSE br-equipamentos = 3
               tt-equipamentos.ct-codigo:BGCOLOR IN BROWSE br-equipamentos = 3
               tt-equipamentos.cc-codigo:BGCOLOR IN BROWSE br-equipamentos = 3
               tt-equipamentos.cc-codigo2:BGCOLOR IN BROWSE br-equipamentos = 3.
        
    END.
    ELSE DO:
        ASSIGN tt-equipamentos.selec:BGCOLOR IN BROWSE br-equipamentos = 15
               tt-equipamentos.equipamento:BGCOLOR IN BROWSE br-equipamentos = 15
               tt-equipamentos.descricao:BGCOLOR IN BROWSE br-equipamentos = 15
               tt-equipamentos.ct-codigo:BGCOLOR IN BROWSE br-equipamentos = 15
               tt-equipamentos.cc-codigo:BGCOLOR IN BROWSE br-equipamentos = 15
               tt-equipamentos.cc-codigo2:BGCOLOR IN BROWSE br-equipamentos = 15.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-cc-valido wWindow 
FUNCTION f-cc-valido RETURNS LOGICAL
  ( INPUT p-cc-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    RUN prgint/utb/utb742za.py persistent set h_api_ccusto.

    ASSIGN v_cod_ccusto = p-cc-codigo.

    EMPTY TEMP-TABLE tt_log_erro.

    run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,       /* CCUSTO */
                                               input TODAY,              /* DATA DE TRANSACAO */
                                               output v_des_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */

    IF VALID-HANDLE(h_api_ccusto) THEN
        DELETE OBJECT h_api_ccusto.

    IF CAN-FIND(FIRST tt_log_erro) THEN
        RETURN FALSE.
    ELSE
        RETURN TRUE.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

