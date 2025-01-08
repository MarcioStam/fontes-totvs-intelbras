&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
*******************************************************************************/
{include/i-prgvrs.i ESFTP080 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP080
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btExit

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-desc-item AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-item      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE r-rowid     AS ROWID       NO-UNDO.
DEFINE VARIABLE i-seq       AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont      AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-ok        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-acomp     AS HANDLE      NO-UNDO.

DEFINE BUFFER bf-seq-item FOR seq-item.

DEFINE TEMP-TABLE tt-seq-item NO-UNDO LIKE seq-item
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-itens NO-UNDO LIKE seq-item
    FIELD r-rowid AS ROWID.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-itens

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES seq-item

/* Definitions for BROWSE br-itens                                      */
&Scoped-define FIELDS-IN-QUERY-br-itens seq-item.sequencia ~
seq-item.it-codigo fnDescItem(seq-item.it-codigo) @ c-desc-item 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-itens 
&Scoped-define QUERY-STRING-br-itens FOR EACH seq-item NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-itens OPEN QUERY br-itens FOR EACH seq-item NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-itens seq-item
&Scoped-define FIRST-TABLE-IN-QUERY-br-itens seq-item


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-itens}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btExit bt-importar bt-layout ~
bt-reordena br-itens bt-cima bt-baixo bt-incluir bt-eliminar ~
bt-elimina-todas bt-va-para 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem wWindow 
FUNCTION fnDescItem RETURNS CHARACTER
  ( pCod-item AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-baixo 
     IMAGE-UP FILE "image/down-black.ico":U
     LABEL "Para Baixo" 
     SIZE 5 BY 1.13 TOOLTIP "Mover para Baixo".

DEFINE BUTTON bt-cima 
     IMAGE-UP FILE "image/up-black.ico":U
     LABEL "Para Cima" 
     SIZE 5 BY 1.13 TOOLTIP "Mover para Cima".

DEFINE BUTTON bt-elimina-todas 
     LABEL "Elimina Todos" 
     SIZE 12 BY 1.13.

DEFINE BUTTON bt-eliminar 
     LABEL "&Eliminar" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-importar 
     LABEL "Importar de Arquivo" 
     SIZE 15 BY 1 TOOLTIP "Importar Itens de um arquivo".

DEFINE BUTTON bt-incluir 
     LABEL "&Incluir" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-layout 
     LABEL "Layout" 
     SIZE 8.14 BY 1 TOOLTIP "Exemplo de Layout para Importaá∆o".

DEFINE BUTTON bt-reordena 
     LABEL "Reordenar" 
     SIZE 9 BY 1 TOOLTIP "Reordenar Sequàncias".

DEFINE BUTTON bt-va-para 
     LABEL "&V† Para" 
     SIZE 12 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-itens FOR 
      seq-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-itens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-itens wWindow _STRUCTURED
  QUERY br-itens NO-LOCK DISPLAY
      seq-item.sequencia FORMAT ">>>>9":U WIDTH 6
      seq-item.it-codigo FORMAT "x(16)":U WIDTH 12.43
      fnDescItem(seq-item.it-codigo) @ c-desc-item COLUMN-LABEL "Descriá∆o" FORMAT "x(100)":U
            WIDTH 60.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 83.57 BY 13.75
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btExit AT ROW 1.13 COL 86.57 HELP
          "Sair"
     bt-importar AT ROW 1.29 COL 2 HELP
          "Importar Itens de um arquivo .csv" WIDGET-ID 14
     bt-layout AT ROW 1.29 COL 17.14 HELP
          "Exemplo de Layout para Importaá∆o" WIDGET-ID 16
     bt-reordena AT ROW 1.29 COL 26.14 HELP
          "Reordena as sequàncias dos Itens" WIDGET-ID 12
     br-itens AT ROW 2.75 COL 1.43 WIDGET-ID 200
     bt-cima AT ROW 8 COL 85.43 HELP
          "Mover Item para cima" WIDGET-ID 6
     bt-baixo AT ROW 9.17 COL 85.43 HELP
          "Mover Item para baixo" WIDGET-ID 8
     bt-incluir AT ROW 16.71 COL 1.57 HELP
          "Inserir um novo Item" WIDGET-ID 2
     bt-eliminar AT ROW 16.71 COL 13.72 HELP
          "Eliminar o Item selecionado" WIDGET-ID 4
     bt-elimina-todas AT ROW 16.71 COL 41 WIDGET-ID 18
     bt-va-para AT ROW 16.71 COL 73 WIDGET-ID 10
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.83
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
         HEIGHT             = 16.83
         WIDTH              = 90
         MAX-HEIGHT         = 27.54
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 27.54
         VIRTUAL-WIDTH      = 182.86
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB br-itens bt-reordena fpage0 */
ASSIGN 
       br-itens:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-itens
/* Query rebuild information for BROWSE br-itens
     _TblList          = "mgesp.seq-item"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > mgesp.seq-item.sequencia
"seq-item.sequencia" ? ? "integer" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > mgesp.seq-item.it-codigo
"seq-item.it-codigo" ? ? "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fnDescItem(seq-item.it-codigo) @ c-desc-item" "Descriá∆o" "x(100)" ? ? ? ? ? ? ? no ? no no "60.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-itens */
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


&Scoped-define SELF-NAME bt-baixo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-baixo wWindow
ON CHOOSE OF bt-baixo IN FRAME fpage0 /* Para Baixo */
DO:
    RUN pi-para-baixo IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cima
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cima wWindow
ON CHOOSE OF bt-cima IN FRAME fpage0 /* Para Cima */
DO:
    RUN pi-para-cima IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-elimina-todas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-elimina-todas wWindow
ON CHOOSE OF bt-elimina-todas IN FRAME fpage0 /* Elimina Todos */
DO:
  MESSAGE "Confirma a Eliminaá∆o de Todas as Sequencias? "
                   SKIP(1)
                   

                 VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
                         TITLE "" UPDATE choice AS LOGICAL.
           IF choice = TRUE THEN DO:
               FOR EACH seq-item EXCLUSIVE-LOCK:
                   DELETE seq-item.
               END.
               MESSAGE "Sequencias Eliminadas com Sucesso!!!"
                   VIEW-AS ALERT-BOX INFO BUTTONS OK.

           END.
      {&OPEN-QUERY-br-itens}

    RETURN "OK":U.            
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-eliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar wWindow
ON CHOOSE OF bt-eliminar IN FRAME fpage0 /* Eliminar */
DO:
    IF  AVAIL seq-item THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 550,
                           INPUT "":U).
        IF  RETURN-VALUE = "YES":U THEN DO:
            FIND CURRENT seq-item EXCLUSIVE-LOCK NO-ERROR.
            DELETE seq-item.
            {&OPEN-QUERY-br-itens}
        END.
    END.

    RUN pi-controla-botoes IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-importar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importar wWindow
ON CHOOSE OF bt-importar IN FRAME fpage0 /* Importar de Arquivo */
DO:
    RUN pi-importar-itens IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir wWindow
ON CHOOSE OF bt-incluir IN FRAME fpage0 /* Incluir */
DO:
    RUN esp/ftp/esftp080a.w (OUTPUT r-rowid).

    {&OPEN-QUERY-br-itens}

    REPOSITION br-itens TO ROWID r-rowid NO-ERROR.

    RUN pi-controla-botoes IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-layout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-layout wWindow
ON CHOOSE OF bt-layout IN FRAME fpage0 /* Layout */
DO:
    RUN pi-layout IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-reordena
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-reordena wWindow
ON CHOOSE OF bt-reordena IN FRAME fpage0 /* Reordenar */
DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 28084,
                       INPUT "Deseja refazer a sequància dos Itens?~~Ao clicar em Sim, as sequàncias dos Itens ser∆o refeitas de 10 em 10.").
    IF  RETURN-VALUE = "YES":U THEN
        RUN pi-reordena IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-va-para
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-va-para wWindow
ON CHOOSE OF bt-va-para IN FRAME fpage0 /* V† Para */
DO:
    RUN goToItem IN THIS-PROCEDURE.
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


&Scoped-define BROWSE-NAME br-itens
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {&OPEN-QUERY-br-itens}

    ENABLE br-itens
           bt-incluir
           bt-importar
           bt-layout
           bt-elimina-todas
        WITH FRAME fPage0.

    RUN pi-controla-botoes IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToItem wWindow 
PROCEDURE goToItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE c-it-codigo LIKE item.it-codigo NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-it-codigo    AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 10 BY .88
        btGoToOK       AT ROW 2.63 COL 2.14
        btGoToCancel   AT ROW 2.63 COL 13
        rtGoToButton   AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Item" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-it-codigo.

        FIND FIRST seq-item NO-LOCK
            WHERE  seq-item.it-codigo = c-it-codigo NO-ERROR.
        IF  NOT AVAIL  seq-item THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Item":U).
            RETURN NO-APPLY.
        END.
        
        /*:T Reposiciona registro com base em um rowid */
        REPOSITION br-itens TO ROWID ROWID(seq-item) NO-ERROR.

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-it-codigo btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-controla-botoes wWindow 
PROCEDURE pi-controla-botoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  CAN-FIND(FIRST seq-item) THEN DO:
        ENABLE bt-eliminar
               bt-cima
               bt-baixo
               bt-va-para
               bt-reordena
            WITH FRAME fPage0.
    END.
    ELSE DO:
        DISABLE bt-eliminar
                bt-cima
                bt-baixo
                bt-va-para
                bt-reordena
            WITH FRAME fPage0.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importar-itens wWindow 
PROCEDURE pi-importar-itens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Solicitar arquivo que ser† importado */
    SYSTEM-DIALOG GET-FILE c-arquivo
            TITLE      "Importar Sequància dos Itens"
            FILTERS    "Arquivos de texto (*.csv)" "*.csv"
            INITIAL-DIR SESSION:TEMP-DIRECTORY
            MUST-EXIST
            USE-FILENAME
            UPDATE l-ok.

    IF  NOT l-ok THEN
        RETURN "NOK":U.


    IF  NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar IN h-acomp (INPUT "Importando Notas").

    EMPTY TEMP-TABLE tt-itens.

    /* Importa os Itens de um arquivo */
    INPUT FROM VALUE(c-arquivo) NO-ECHO.
    REPEAT:
        ASSIGN i-cont = i-cont + 1.

        RUN pi-acompanhar IN h-acomp (INPUT "Importando linha " + STRING(i-cont)).

        CREATE tt-itens.
        IMPORT DELIMITER ";" tt-itens.
    END.
    INPUT CLOSE.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.


    FOR EACH  tt-itens NO-LOCK
        WHERE tt-itens.sequencia <> 0
        AND   tt-itens.it-codigo <> "":

        /* Validaá‰es */
        IF  NOT CAN-FIND(FIRST item NO-LOCK
                         WHERE item.it-codigo = tt-itens.it-codigo) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.errorNumber      = 56
                   rowErrors.errorDescription = "Item inexistente."
                   rowErrors.errorHelp        = "Verifique se existe uma ocorrància para o(a) Item informado(a) em seu cadastro.".
            NEXT.
        END.
    
        IF  CAN-FIND(FIRST seq-item NO-LOCK
                     WHERE seq-item.sequencia = tt-itens.sequencia) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.errorNumber      = 17006
                   rowErrors.errorDescription = "Sequància j† cadastrada!"
                   rowErrors.errorHelp        = "A sequància " + STRING(tt-itens.sequencia) + " j† est† cadastrada!".
            NEXT.
        END.
    
        IF  CAN-FIND(FIRST seq-item NO-LOCK
                     WHERE seq-item.it-codigo = tt-itens.it-codigo) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.errorNumber      = 17006
                   rowErrors.errorDescription = "Item j† cadastrado!"
                   rowErrors.errorHelp        = "J† existe uma outra sequància informada para o Item (" + tt-itens.it-codigo + ")!".
            NEXT.
        END.


        CREATE seq-item.
        ASSIGN seq-item.sequencia = tt-itens.sequencia
               seq-item.it-codigo = tt-itens.it-codigo.
    END.

    IF  CAN-FIND(FIRST rowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
        {method/showmessage.i3}
    END.

    {&OPEN-QUERY-br-itens}

    RUN pi-controla-botoes IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-layout wWindow 
PROCEDURE pi-layout :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUTTON btLayoutFechar AUTO-END-KEY 
         LABEL "&Fechar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE c-editor AS CHARACTER   NO-UNDO.

    ASSIGN c-editor = FILL("-",124)                         + CHR(13) +
                      FILL(" ",46) + "Layout de Importaá∆o" + CHR(13) +
                      FILL("-",124)                         + CHR(13) + CHR(13) +
                      "O arquivo com os itens a serem importados deve seguir o padr∆o abaixo:" + CHR(13) +
                      "Sequància;C¢d Item" + CHR(13) + CHR(13) +
                      "10;0000001" + CHR(13) +
                      "20;0000002" + CHR(13) +
                      "30;0000003" + CHR(13).
    
    DEFINE FRAME fLayout
        c-editor        AT ROW 1.21 COL 1 COLON-ALIGNED VIEW-AS EDITOR SIZE 54 BY 6.5 NO-LABEL
        btLayoutFechar  AT ROW 8.03 COL 2
        rtGoToButton    AT ROW 7.78 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Layout de Importaá∆o" FONT 1
              DEFAULT-BUTTON btLayoutFechar.

    DISPLAY c-editor
        WITH FRAME fLayout.

    ENABLE btLayoutFechar
        WITH FRAME fLayout. 
    
    WAIT-FOR "GO":U OF FRAME fLayout.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-para-baixo wWindow 
PROCEDURE pi-para-baixo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  AVAIL seq-item THEN DO:
        FIND CURRENT seq-item EXCLUSIVE-LOCK NO-ERROR.

        FIND FIRST bf-seq-item EXCLUSIVE-LOCK
            WHERE  bf-seq-item.sequencia > seq-item.sequencia NO-ERROR.
        IF  AVAIL  bf-seq-item THEN DO:
            ASSIGN c-item                = bf-seq-item.it-codigo
                   bf-seq-item.it-codigo = seq-item.it-codigo
                   seq-item.it-codigo    = c-item
                   r-rowid               = ROWID(bf-seq-item).
        END.
        FIND CURRENT seq-item NO-LOCK NO-ERROR.

        {&OPEN-QUERY-br-itens}

        REPOSITION br-itens TO ROWID r-rowid NO-ERROR.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-para-cima wWindow 
PROCEDURE pi-para-cima :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  AVAIL seq-item THEN DO:
        FIND CURRENT seq-item EXCLUSIVE-LOCK NO-ERROR.

        FIND LAST bf-seq-item EXCLUSIVE-LOCK
            WHERE bf-seq-item.sequencia < seq-item.sequencia NO-ERROR.
        IF  AVAIL bf-seq-item THEN DO:
            ASSIGN c-item                = bf-seq-item.it-codigo
                   bf-seq-item.it-codigo = seq-item.it-codigo
                   seq-item.it-codigo    = c-item
                   r-rowid               = ROWID(bf-seq-item).
        END.
        FIND CURRENT seq-item NO-LOCK NO-ERROR.

        {&OPEN-QUERY-br-itens}

        REPOSITION br-itens TO ROWID r-rowid NO-ERROR.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reordena wWindow 
PROCEDURE pi-reordena :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-seq-item.

    ASSIGN i-seq = 0.
    FOR EACH seq-item EXCLUSIVE-LOCK
        BY   seq-item.sequencia:
        ASSIGN i-seq = i-seq + 10.

        CREATE tt-seq-item.
        ASSIGN tt-seq-item.sequencia = i-seq
               tt-seq-item.it-codigo = seq-item.it-codigo.

        DELETE seq-item.
    END.

    FOR EACH tt-seq-item NO-LOCK:
        CREATE seq-item.
        ASSIGN seq-item.sequencia = tt-seq-item.sequencia
               seq-item.it-codigo = tt-seq-item.it-codigo.
    END.

    {&OPEN-QUERY-br-itens}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem wWindow 
FUNCTION fnDescItem RETURNS CHARACTER
  ( pCod-item AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST item FIELDS(it-codigo desc-item) NO-LOCK
        WHERE item.it-codigo = pCod-item: END.

    ASSIGN c-desc-item = IF AVAIL item THEN item.desc-item ELSE "".

    RETURN c-desc-item.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

