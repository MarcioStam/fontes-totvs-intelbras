&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESBCP003 2.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESBCP003
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   bt-limpar bt-sair bt-excluir br-etiqueta
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-esapi003    AS HANDLE    NO-UNDO.

{c:\fontes11\cdp/cd0666.i} /* tt-erros */
{c:\fontes11\esapi/esapi003tt.i}

RUN esapi/esapi003.p PERSISTENT SET h-esapi003.

DEFINE VARIABLE c-etiqueta-pai AS CHARACTER NO-UNDO.
DEFINE VARIABLE g-etiq-pallet  AS CHARACTER NO-UNDO.

DEF BUFFER b-ns-volume FOR ns-volume.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-etiqueta

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ns-volume

/* Definitions for BROWSE br-etiqueta                                   */
&Scoped-define FIELDS-IN-QUERY-br-etiqueta tt-ns-volume.volume-filho tt-ns-volume.data tt-ns-volume.nome-usuar   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-etiqueta   
&Scoped-define SELF-NAME br-etiqueta
&Scoped-define QUERY-STRING-br-etiqueta FOR EACH tt-ns-volume
&Scoped-define OPEN-QUERY-br-etiqueta OPEN QUERY {&SELF-NAME} FOR EACH tt-ns-volume.
&Scoped-define TABLES-IN-QUERY-br-etiqueta tt-ns-volume
&Scoped-define FIRST-TABLE-IN-QUERY-br-etiqueta tt-ns-volume


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-etiqueta}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-17 f-tipo br-etiqueta bt-excluir ~
bt-limpar bt-gravar bt-sair 
&Scoped-Define DISPLAYED-OBJECTS f-etiqueta f-quantidade f-tipo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnQtdeFilho wWindow 
FUNCTION fnQtdeFilho RETURNS INTEGER
  ( INPUT c-etiq-pai AS CHARACTER,
    INPUT c-etiq-filho AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-excluir 
     LABEL "Excluir (F7)" 
     SIZE 9 BY 1.13.

DEFINE BUTTON bt-gravar 
     LABEL "Gravar (F9)" 
     SIZE 9 BY 1.13.

DEFINE BUTTON bt-limpar 
     LABEL "Limpar (F8)" 
     SIZE 9 BY 1.13.

DEFINE BUTTON bt-sair 
     LABEL "Sair(esc)" 
     SIZE 9 BY 1.13.

DEFINE VARIABLE f-etiqueta AS CHARACTER FORMAT "X(15)":U 
     LABEL "Etiqueta" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE f-quantidade AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Qtd Item Caixa" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE f-tipo AS CHARACTER FORMAT "X(10)":U 
     LABEL "Tipo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 2.58.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-etiqueta FOR 
      tt-ns-volume SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-etiqueta wWindow _FREEFORM
  QUERY br-etiqueta DISPLAY
      tt-ns-volume.volume-filho  COLUMN-LABEL "C¢d.Etiqueta"
      tt-ns-volume.data                                                  WIDTH 15
      tt-ns-volume.nome-usuar    COLUMN-LABEL "Usu†rio"   FORMAT "X(40)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 44 BY 7.75
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     f-etiqueta AT ROW 1.46 COL 12 COLON-ALIGNED HELP
          "Registre a Etiqueta" WIDGET-ID 42 AUTO-RETURN 
     f-quantidade AT ROW 2.5 COL 12 COLON-ALIGNED HELP
          "Qtd Item Caixa" WIDGET-ID 44
     f-tipo AT ROW 2.5 COL 30.14 COLON-ALIGNED WIDGET-ID 18
     br-etiqueta AT ROW 4 COL 2 WIDGET-ID 200
     bt-excluir AT ROW 11.75 COL 2 WIDGET-ID 48
     bt-limpar AT ROW 11.75 COL 11.29 WIDGET-ID 50
     bt-gravar AT ROW 11.75 COL 20.57 WIDGET-ID 52
     bt-sair AT ROW 11.75 COL 37 WIDGET-ID 40
     RECT-17 AT ROW 1.25 COL 2 WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 45.72 BY 12.5
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
         HEIGHT             = 12.5
         WIDTH              = 45.72
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
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
/* BROWSE-TAB br-etiqueta f-tipo fpage0 */
/* SETTINGS FOR FILL-IN f-etiqueta IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-quantidade IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-etiqueta
/* Query rebuild information for BROWSE br-etiqueta
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ns-volume.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-etiqueta */
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
ON F7 OF wWindow
DO:
    RUN piExcluiVolume.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON F8 OF wWindow
DO:
    RUN piLimpar.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON F9 OF wWindow
DO:
    RUN piGravar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
    IF VALID-HANDLE(h-esapi003) THEN
        DELETE PROCEDURE h-esapi003.

    /* This event will close the window and terminate the procedure.  */
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-excluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excluir wWindow
ON CHOOSE OF bt-excluir IN FRAME fpage0 /* Excluir (F7) */
DO:
    RUN piExcluiVolume.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-gravar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-gravar wWindow
ON CHOOSE OF bt-gravar IN FRAME fpage0 /* Gravar (F9) */
DO:
    RUN piGravar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-limpar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-limpar wWindow
ON CHOOSE OF bt-limpar IN FRAME fpage0 /* Limpar (F8) */
DO:
    RUN piLimpar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sair wWindow
ON CHOOSE OF bt-sair IN FRAME fpage0 /* Sair(esc) */
DO:
  APPLY 'CLOSE' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-etiqueta wWindow
ON F7 OF f-etiqueta IN FRAME fpage0 /* Etiqueta */
DO:
    APPLY "CHOOSE" TO bt-excluir.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-etiqueta wWindow
ON F8 OF f-etiqueta IN FRAME fpage0 /* Etiqueta */
DO:
    APPLY "CHOOSE" TO bt-limpar.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-etiqueta wWindow
ON F9 OF f-etiqueta IN FRAME fpage0 /* Etiqueta */
DO:
    APPLY "CHOOSE" TO bt-gravar.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-etiqueta wWindow
ON RETURN OF f-etiqueta IN FRAME fpage0 /* Etiqueta */
DO:
    IF c-etiqueta-pai = "" THEN
        RUN piBuscaEtiqPai.
    ELSE
        RUN piBuscaEtiqFilho(YES).

    IF RETURN-VALUE = "NOK" THEN
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-etiqueta
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

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
ENABLE f-etiqueta 
       WITH FRAME {&FRAME-NAME}. .

{&OPEN-QUERY-{&BROWSE-NAME}}

APPLY "ENTRY" TO f-etiqueta.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaEtiqFilho wWindow 
PROCEDURE piBuscaEtiqFilho :
/*------------------------------------------------------------------------------
  Purpose: Realiza validaá‰es leitura etiqueta filho    
  Notes:   Carlos Daniel - 29/02/2016
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER lcria_volume AS LOGICAL NO-UNDO.

DEFINE BUFFER bf-tt-ns-volume FOR tt-ns-volume.

DO WITH FRAME fPage0:

    IF DYNAMIC-FUNCTION("fnRetornaTpEtiq" IN h-esapi003,f-etiqueta:SCREEN-VALUE) = "PALLET"  THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "A etiqueta informada refere-se Ö um Pallet e n∆o pode ser utilizada como filha.",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.
        ASSIGN f-etiqueta:SCREEN-VALUE = "".
        RETURN "NOK".
    END.


    IF lcria_volume THEN DO:
        FIND FIRST bf-tt-ns-volume
            WHERE bf-tt-ns-volume.volume-filho = f-etiqueta:SCREEN-VALUE NO-ERROR.
        
        IF AVAIL bf-tt-ns-volume THEN DO:
            /*RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Etiqueta inv†lida~~A etiqueta j† est† vinculada a Caixa/Pallet " + bf-tt-ns-volume.volume-pai + ".").*/
            {&WINDOW-NAME}:SENSITIVE = FALSE.
            RUN esp/clt/esclt006.w (INPUT "Etiqueta inv†lida~~A etiqueta j† est† vinculada a Caixa/Pallet " + bf-tt-ns-volume.volume-pai + ".",
                                    INPUT NO).
            {&WINDOW-NAME}:SENSITIVE = YES.
            
            ASSIGN f-etiqueta:SCREEN-VALUE = "".
            RETURN "NOK".
        END.
        
        RUN piValidaEtiq(INPUT c-etiqueta-pai,
                         INPUT f-etiqueta:SCREEN-VALUE,
                         INPUT YES).
        
        IF RETURN-VALUE <> "OK" THEN DO:
            ASSIGN f-etiqueta:SCREEN-VALUE = "".
            RETURN "NOK".
        END.
        
        RUN piCriaVolume(INPUT c-etiqueta-pai,
                         INPUT f-etiqueta:SCREEN-VALUE).
        IF RETURN-VALUE <> "OK" THEN DO:
            ASSIGN f-etiqueta:SCREEN-VALUE = "".
            RETURN "NOK".
        END.
    END.
    

    IF fnQtdeFilho(f-etiqueta:SCREEN-VALUE,"") = INTEGER(f-quantidade:SCREEN-VALUE) THEN DO:
        IF f-tipo:SCREEN-VALUE = "CAIXA" THEN DO:
            ASSIGN g-etiq-pallet = "".

            RUN piChamaLeituraPallet.

            IF g-etiq-pallet <> "" THEN DO:
                IF DYNAMIC-FUNCTION("fnRetornaTpEtiq" IN h-esapi003,g-etiq-pallet) <> "PALLET"  THEN DO:
                    {&WINDOW-NAME}:SENSITIVE = FALSE.
                    RUN esp/clt/esclt006.w (INPUT "Etiqueta informada n∆o Ç referente a um Pallet.",
                                            INPUT NO).
                    {&WINDOW-NAME}:SENSITIVE = TRUE.
                    RUN piBuscaEtiqFilho(NO).
                    RETURN.
                END.
                
                RUN piValidaEtiqPL(INPUT g-etiq-pallet,
                                   INPUT c-etiqueta-pai,
                                   INPUT NO).
                
                IF RETURN-VALUE <> "OK" THEN DO:
                    RUN piBuscaEtiqFilho(NO).
                    RETURN.
                END.

                CREATE tt-ns-volume.
                ASSIGN tt-ns-volume.volume-pai   = g-etiq-pallet
                       tt-ns-volume.volume-filho = c-etiqueta-pai
                       tt-ns-volume.sequencia    = 1
                       tt-ns-volume.data         = NOW
                       tt-ns-volume.usuario      = c-seg-usuario
                       tt-ns-volume.tipo         = "PALLET"
                       g-etiq-pallet             = "".
            END.
        END.
        
        RUN piGravaVolume.
        IF RETURN-VALUE = "OK" THEN DO:
            /*RUN utp/ut-msgs.p (INPUT "SHOW",
                               INPUT 15825,
                               INPUT "Etiqueta de " + f-tipo:SCREEN-VALUE + " vinculada com sucesso.").*/
            {&WINDOW-NAME}:SENSITIVE = FALSE.
            RUN esp/clt/esclt006.w (INPUT "Etiqueta de " + f-tipo:SCREEN-VALUE + " vinculada com sucesso.",
                                    INPUT NO).
            {&WINDOW-NAME}:SENSITIVE = YES.

            RUN piLimpar.
        END.
    END.
    ELSE DO:
        ASSIGN f-etiqueta:SCREEN-VALUE = "".
        
    IF f-tipo:SCREEN-VALUE = "PALLET" THEN
        ASSIGN bt-gravar:SENSITIVE = YES.

        APPLY "ENTRY" TO f-etiqueta.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaEtiqPai wWindow 
PROCEDURE piBuscaEtiqPai :
/*------------------------------------------------------------------------------
  Purpose: Busca dados etiqueta pai e popula campos em tela
  Notes:   Carlos Daniel - 02/02/2016
------------------------------------------------------------------------------*/
DEFINE VARIABLE f-item      AS CHARACTER NO-UNDO.
DEFINE VARIABLE f-desc-item AS CHARACTER NO-UNDO.
EMPTY TEMP-TABLE tt-ns-volume.

RUN piBuscaEtiquetaPai IN h-esapi003 (INPUT  f-etiqueta:SCREEN-VALUE IN FRAME fPage0,
                                      OUTPUT f-tipo,
                                      OUTPUT f-quantidade,
                                      OUTPUT f-item,
                                      OUTPUT f-desc-item,
                                      OUTPUT TABLE tt-ns-volume).

IF RETURN-VALUE = "OK" THEN DO:
    DISP f-tipo f-quantidade WITH FRAME fPage0.

    ASSIGN c-etiqueta-pai          = f-etiqueta:SCREEN-VALUE IN FRAME fPage0
           f-etiqueta:SCREEN-VALUE = "".

    {&OPEN-QUERY-BR-ETIQUETA}
    APPLY "ENTRY" TO f-etiqueta.
END.
ELSE DO:
    {&WINDOW-NAME}:SENSITIVE = FALSE.
    RUN esp/clt/esclt006.w (INPUT RETURN-VALUE,
                            INPUT NO).
    {&WINDOW-NAME}:SENSITIVE = YES.
    RUN piLimpar.
    RETURN "NOK".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piChamaLeituraPallet wWindow 
PROCEDURE piChamaLeituraPallet :
/*------------------------------------------------------------------------------
  Purpose: Cria dialog para receber leitura etiqueta de pallet    
  Notes:   Carlos Daniel - 01/03/2016
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-etiq-pallet AS CHARACTER FORMAT "X(13)"
     LABEL "Etiq.Pallet"
     VIEW-AS FILL-IN 
     SIZE 15 BY .75 NO-UNDO.

DEFINE BUTTON btPalletCancel AUTO-END-KEY
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8.

DEFINE BUTTON btPalletOK 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8.

DEFINE RECTANGLE rtPalletButton
     EDGE-PIXELS 2 GRAPHIC-EDGE 
     SIZE 30 BY 1.42
     BGCOLOR 7.

DEFINE FRAME fPalletRecord
    c-etiq-pallet   AT ROW 1.21 COL 7.72 COLON-ALIGNED VIEW-AS FILL-IN FORMAT "X(13)"

    btPalletOK      AT ROW 2.63 COL 2.14
    btPalletCancel  AT ROW 2.63 COL 13
    rtPalletButton  AT ROW 2.38 COL 1
    SPACE(0.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
         THREE-D SCROLLABLE TITLE "Pallet" FONT 1
         DEFAULT-BUTTON btPalletOK CANCEL-BUTTON btPalletCancel.

ON "RETURN":U OF c-etiq-pallet IN FRAME fPalletRecord DO:
    ASSIGN c-etiq-pallet.

    ASSIGN g-etiq-pallet = c-etiq-pallet.
    APPLY "GO":U TO FRAME fPalletRecord.
END.

ENABLE c-etiq-pallet btPalletCancel
    WITH FRAME fPalletRecord.

WAIT-FOR "GO":U OF FRAME fPalletRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaVolume wWindow 
PROCEDURE piCriaVolume :
/*------------------------------------------------------------------------------
  Purpose: Cria registros tt-ns-volume conforme leitura das etiquetas
  Notes:   Carlos Daniel - 04/02/2016
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-etiqueta-pai   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER c-etiqueta-filho AS CHARACTER NO-UNDO.

DEFINE BUFFER bf-tt-ns-volume FOR tt-ns-volume.

DEFINE VARIABLE c-tipo AS CHARACTER NO-UNDO.

ASSIGN c-tipo = DYNAMIC-FUNCTION("fnRetornaTpEtiq" IN h-esapi003,c-etiqueta-filho).

FIND FIRST bf-tt-ns-volume WHERE bf-tt-ns-volume.tipo <> c-tipo NO-ERROR.
IF AVAIL bf-tt-ns-volume THEN DO:
    /*RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 17006,
                       INPUT "Etiqueta inv†lida~~Essa etiqueta Ç de " + c-tipo + ", diferente das demais que foram lidas que s∆o do tipo " + bf-tt-ns-volume.tipo + ".").*/
    {&WINDOW-NAME}:SENSITIVE = FALSE.
    RUN esp/clt/esclt006.w (INPUT "Etiqueta inv†lida~~Essa etiqueta Ç de " + c-tipo + ", diferente das demais que foram lidas que s∆o do tipo " + bf-tt-ns-volume.tipo + ".",
                            INPUT NO).
    {&WINDOW-NAME}:SENSITIVE = YES.

    ASSIGN f-etiqueta:SCREEN-VALUE IN FRAME fPage0 = "".
    APPLY "ENTRY" TO f-etiqueta.
    RETURN "NOK".
END.

CREATE tt-ns-volume.
ASSIGN tt-ns-volume.volume-pai   = c-etiqueta-pai
       tt-ns-volume.volume-filho = c-etiqueta-filho
       tt-ns-volume.sequencia    = 1
       tt-ns-volume.data         = NOW
       tt-ns-volume.usuario      = c-seg-usuario
       tt-ns-volume.nome-usuar   = DYNAMIC-FUNCTION("fnRetornaNmUsuar" IN h-esapi003,tt-ns-volume.usuario)
       tt-ns-volume.tipo         = c-tipo.

{&OPEN-QUERY-BR-ETIQUETA}

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExcluiVolume wWindow 
PROCEDURE piExcluiVolume :
/*------------------------------------------------------------------------------
  Purpose: Chama rotina para eliminaá∆o dos vinculos da etiqueta selecionada    
  Notes:   Carlos Daniel - 01/03/2016
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-mensagem AS CHARACTER NO-UNDO.

IF f-tipo:SCREEN-VALUE IN FRAME fPage0 = "CAIXA" THEN
    ASSIGN c-mensagem = "Confirma desativaá∆o da etiqueta de CAIXA?~~Todos os N£meros de sÇrie ser∆o desvinculados desta CAIXA. Esta CAIXA ser† desvinculada do PALLET.".
ELSE IF f-tipo:SCREEN-VALUE = "PALLET" THEN
    ASSIGN c-mensagem = "Confirma desativaá∆o da etiqueta de PALLET?~~Todas as CAIXAS ser∆o desvinculadas deste PALLET.".

{&WINDOW-NAME}:SENSITIVE = FALSE.
RUN esp/clt/esclt006.w (INPUT c-mensagem,
                        INPUT YES).
{&WINDOW-NAME}:SENSITIVE = YES.

IF NOT LOGICAL(RETURN-VALUE) THEN
    RETURN.

RUN piExcluiVolume IN h-esapi003 (INPUT c-etiqueta-pai).

IF RETURN-VALUE = "OK" THEN DO:
    /*RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 15825,
                       INPUT "Etiqueta eliminada com sucesso~~Etiqueta eliminada com sucesso.").*/

    {&WINDOW-NAME}:SENSITIVE = FALSE.
    RUN esp/clt/esclt006.w (INPUT "Etiqueta eliminada com sucesso~~Etiqueta eliminada com sucesso.",
                            INPUT NO).
    {&WINDOW-NAME}:SENSITIVE = YES.
    RUN piLimpar.
    RETURN "OK".
END.
ELSE DO:
    {&WINDOW-NAME}:SENSITIVE = FALSE.
    RUN esp/clt/esclt006.w (INPUT RETURN-VALUE,
                            INPUT NO).
    {&WINDOW-NAME}:SENSITIVE = YES.
    RETURN "NOK".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGravar wWindow 
PROCEDURE piGravar :
/*------------------------------------------------------------------------------
  Purpose: Grava dados vinculados ao pallet    
  Notes:   Carlos Daniel - 20/05/2016
------------------------------------------------------------------------------*/
{&WINDOW-NAME}:SENSITIVE = FALSE.
RUN esp/clt/esclt006.w (INPUT "O Pallet ainda n∆o est† completo, deseja finalizar assim mesmo?",
                        INPUT YES).
{&WINDOW-NAME}:SENSITIVE = TRUE.

IF NOT LOGICAL(RETURN-VALUE) THEN
    RETURN.

RUN piGravaVolume IN h-esapi003 (INPUT TABLE tt-ns-volume).

IF RETURN-VALUE <> "OK" THEN DO:
    {&WINDOW-NAME}:SENSITIVE = FALSE.
    RUN esp/clt/esclt006.w (INPUT "Erro ao gravar etiqueta.",
                            INPUT NO).
    {&WINDOW-NAME}:SENSITIVE = TRUE.
    RETURN "NOK".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGravaVolume wWindow 
PROCEDURE piGravaVolume :
/*------------------------------------------------------------------------------
  Purpose: Efetiva gravaá∆o dos registros na ns-volume
  Notes:   Carlos Daniel - 01/03/2016
------------------------------------------------------------------------------*/
RUN piGravaVolume IN h-esapi003 (INPUT TABLE tt-ns-volume).

IF RETURN-VALUE <> "OK" THEN DO:
    /*RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 17006,
                       INPUT "Erro ao gravar etiqueta~~Erro ao gravar etiqueta.").*/
    {&WINDOW-NAME}:SENSITIVE = FALSE.
    RUN esp/clt/esclt006.w (INPUT "Erro ao gravar etiqueta~~Erro ao gravar etiqueta.",
                            INPUT NO).
    {&WINDOW-NAME}:SENSITIVE = YES.
    RETURN "NOK".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLimpar wWindow 
PROCEDURE piLimpar :
/*------------------------------------------------------------------------------
  Purpose: Limpa campos tela e browser
  Notes:   Carlos Daniel - 01/03/2016
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE tt-ns-volume.

{&OPEN-QUERY-BR-ETIQUETA}

DO WITH FRAME fPage0:
    ASSIGN f-etiqueta  :SCREEN-VALUE = ""
           f-tipo      :SCREEN-VALUE = ""
           f-quantidade:SCREEN-VALUE = ""
           c-etiqueta-pai            = ""
           g-etiq-pallet             = "".

    APPLY "ENTRY" TO f-etiqueta.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaEtiq wWindow 
PROCEDURE piValidaEtiq :
/*------------------------------------------------------------------------------
  Purpose: Chama rotina para validaá∆o etiqueta
  Notes:   Carlos Daniel - 01/03/2016
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-etiqueta-pai   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER c-etiqueta-filho AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER l-valida-cx      AS LOGICAL   NO-UNDO.

IF fnQtdeFilho(c-etiqueta-pai,c-etiqueta-filho) >= INTEGER(f-quantidade:SCREEN-VALUE IN FRAME fPage0) THEN DO:
    /*RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 17006,
                       INPUT "Etiqueta inv†lida~~Capacidade total da etiqueta j† utilizado, favor verificar.").*/
    {&WINDOW-NAME}:SENSITIVE = FALSE.
    RUN esp/clt/esclt006.w (INPUT "Etiqueta inv†lida~~Capacidade total da etiqueta j† utilizado, favor verificar.",
                            INPUT NO).
    {&WINDOW-NAME}:SENSITIVE = YES.
    RETURN "NOK".
END.

RUN piValidaEtiqueta IN h-esapi003 (INPUT c-etiqueta-pai,
                                    INPUT c-etiqueta-filho,
                                    INPUT l-valida-cx,
                                    OUTPUT TABLE tt-erro).

/*IF CAN-FIND(FIRST tt-erro) THEN DO:
    RUN esp/cdp/escdp666.w(INPUT TABLE tt-erro).
    ASSIGN f-etiqueta:SCREEN-VALUE IN FRAME fPage0 = "".
    APPLY "ENTRY" TO f-etiqueta.
    RETURN "NOK".
END.*/

IF RETURN-VALUE <> "OK" THEN DO:
    {&WINDOW-NAME}:SENSITIVE = FALSE.
    RUN esp/clt/esclt006.w (INPUT RETURN-VALUE,
                            INPUT NO).
    {&WINDOW-NAME}:SENSITIVE = YES.
    ASSIGN f-etiqueta:SCREEN-VALUE IN FRAME fPage0 = "".
    APPLY "ENTRY" TO f-etiqueta.
    RETURN "NOK".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaEtiqPL wWindow 
PROCEDURE piValidaEtiqPL :
/*------------------------------------------------------------------------------
  Purpose: Chama rotina para validaá∆o etiqueta
  Notes:   Carlos Daniel - 06/05/2016
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-etiqueta-pai   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER c-etiqueta-filho AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER l-valida-cx      AS LOGICAL   NO-UNDO.

IF fnQtdeFilho(c-etiqueta-pai,c-etiqueta-filho) > DYNAMIC-FUNCTION("fnRetornaCapacidade" IN h-esapi003,c-etiqueta-pai) THEN DO:
    /*RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 17006,
                       INPUT "Etiqueta inv†lida~~Capacidade total da etiqueta j† utilizado, favor verificar.").*/
    {&WINDOW-NAME}:SENSITIVE = FALSE.
    RUN esp/clt/esclt006.w (INPUT "Etiqueta inv†lida~~Capacidade total da etiqueta j† utilizado, favor verificar.",
                            INPUT NO).
    {&WINDOW-NAME}:SENSITIVE = YES.
    RETURN "NOK".
END.

RUN piValidaEtiqueta IN h-esapi003 (INPUT c-etiqueta-pai,
                                    INPUT c-etiqueta-filho,
                                    INPUT l-valida-cx,
                                    OUTPUT TABLE tt-erro).

/*IF CAN-FIND(FIRST tt-erro) THEN DO:
    RUN esp/cdp/escdp666.w(INPUT TABLE tt-erro).
    ASSIGN f-etiqueta:SCREEN-VALUE IN FRAME fPage0 = "".
    APPLY "ENTRY" TO f-etiqueta.
    RETURN "NOK".
END.*/

IF RETURN-VALUE <> "OK" THEN DO:
    {&WINDOW-NAME}:SENSITIVE = FALSE.
    RUN esp/clt/esclt006.w (INPUT RETURN-VALUE,
                            INPUT NO).
    {&WINDOW-NAME}:SENSITIVE = YES.
    ASSIGN f-etiqueta:SCREEN-VALUE IN FRAME fPage0 = "".
    APPLY "ENTRY" TO f-etiqueta.
    RETURN "NOK".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnQtdeFilho wWindow 
FUNCTION fnQtdeFilho RETURNS INTEGER
  ( INPUT c-etiq-pai AS CHARACTER,
    INPUT c-etiq-filho AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Retorna quantidade de filhos da etiqueta pai 
    Notes: Carlos Daniel - 01/03/2016
------------------------------------------------------------------------------*/
IF DYNAMIC-FUNCTION("fnRetornaTpEtiq" IN h-esapi003,c-etiq-filho) = "CAIXA" OR c-etiq-filho = "" THEN DO:

    RETURN DYNAMIC-FUNCTION("fnRetornaQtdePC" IN h-esapi003,INPUT c-etiq-pai,INPUT TABLE tt-ns-volume).
END.
ELSE DO:
    FOR EACH tt-ns-volume:
        ACCUMULATE tt-ns-volume.volume-pai (COUNT).
    END.
    
    RETURN ACCUM COUNT tt-ns-volume.volume-pai.   /* Function return value. */
END.

RETURN 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

