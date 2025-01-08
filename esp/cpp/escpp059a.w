&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-mac-address-param NO-UNDO LIKE mac-address-param
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP059A 2.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP059A
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE INPUT PARAMETER p-acao   AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-rowid  AS ROWID    NO-UNDO.

/*DEFINE VARIABLE p-acao AS CHARACTER  INIT "ADD"  NO-UNDO.
DEFINE VARIABLE p-rowid AS ROWID       NO-UNDO.*/


DEFINE VARIABLE h-boes607  AS HANDLE      NO-UNDO.

{cdp/cd0666.i}
{utp/utapi019.i}
{esp/es0018.i}

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-mac-address-param.faixa ~
tt-mac-address-param.faixa-ini tt-mac-address-param.faixa-fim ~
tt-mac-address-param.alerta tt-mac-address-param.email ~
tt-mac-address-param.dt-criacao 
&Scoped-define ENABLED-TABLES tt-mac-address-param
&Scoped-define FIRST-ENABLED-TABLE tt-mac-address-param
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-1 RECT-3 cnm-usuar btOK ~
btCancel btHelp2 
&Scoped-Define DISPLAYED-FIELDS tt-mac-address-param.faixa ~
tt-mac-address-param.faixa-ini tt-mac-address-param.faixa-fim ~
tt-mac-address-param.alerta tt-mac-address-param.email ~
tt-mac-address-param.dt-criacao 
&Scoped-define DISPLAYED-TABLES tt-mac-address-param
&Scoped-define FIRST-DISPLAYED-TABLE tt-mac-address-param
&Scoped-Define DISPLAYED-OBJECTS cnm-usuar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 tt-mac-address-param.faixa ~
tt-mac-address-param.faixa-ini tt-mac-address-param.faixa-fim ~
tt-mac-address-param.alerta tt-mac-address-param.email ~
tt-mac-address-param.dt-criacao 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRetornaNomeUser wWindow 
FUNCTION fnRetornaNomeUser RETURNS CHARACTER
  ( INPUT ca-usuar AS CHARACTER )  FORWARD.

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
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE cnm-usuar AS CHARACTER FORMAT "x(60)" 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 3.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-mac-address-param.faixa AT ROW 1.5 COL 11.72 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-mac-address-param.faixa-ini AT ROW 2.5 COL 11.72 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-mac-address-param.faixa-fim AT ROW 3.5 COL 11.72 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-mac-address-param.alerta AT ROW 5.25 COL 11.72 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     cnm-usuar AT ROW 5.25 COL 64 COLON-ALIGNED WIDGET-ID 22
     tt-mac-address-param.email AT ROW 6.25 COL 11.72 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 44 BY .88
     tt-mac-address-param.dt-criacao AT ROW 6.25 COL 64 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 9.86 BY .88
     btOK AT ROW 7.96 COL 2
     btCancel AT ROW 7.96 COL 13
     btHelp2 AT ROW 7.96 COL 80
     rtToolBar AT ROW 7.75 COL 1
     RECT-1 AT ROW 1.25 COL 2 WIDGET-ID 2
     RECT-3 AT ROW 5 COL 2 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 8.17
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-mac-address-param T "?" NO-UNDO mgesp mac-address-param
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 8.17
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-mac-address-param.alerta IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN tt-mac-address-param.dt-criacao IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN tt-mac-address-param.email IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN tt-mac-address-param.faixa IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN tt-mac-address-param.faixa-fim IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN tt-mac-address-param.faixa-ini IN FRAME fpage0
   1                                                                    */
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


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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

    RUN pi-salva.

    IF RETURN-VALUE = "OK" THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.

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

    EMPTY TEMP-TABLE tt-mac-address-param.

    RUN esbo/boes607.p PERSISTENT SET h-boes607.
    
    RUN openQueryStatic IN h-boes607 (INPUT "Main").

    ENABLE {&list-1} WITH FRAME fpage0.

    IF p-acao = "MOD" THEN DO:

        DO WITH FRAME fPage0:

            ASSIGN tt-mac-address-param.faixa:SENSITIVE      = FALSE
                   tt-mac-address-param.faixa-ini:SENSITIVE  = FALSE.                   
/*                    tt-mac-address-param.faixa-fim:SENSITIVE = FALSE. */
        END.
    END.


    IF p-acao = "MOD" OR
       p-acao = "COPY" THEN DO:

        RUN repositionRecord IN h-boes607 (INPUT p-rowid).

        RUN getRecord IN h-boes607 (OUTPUT TABLE tt-mac-address-param).

        FIND FIRST tt-mac-address-param NO-LOCK NO-ERROR.

    END.


    IF p-acao = "ADD" THEN DO:

        CREATE tt-mac-address-param.

    END.

    ASSIGN tt-mac-address-param.dt-criacao:SENSITIVE    = FALSE
           cnm-usuar                      :SENSITIVE    = FALSE
           cnm-usuar                      :SCREEN-VALUE = fnRetornaNomeUser(tt-mac-address-param.usuario).

    DISPLAY {&list-1} WITH FRAME fpage0.

    /*DISP tt-mac-address-param.faixa
         tt-mac-address-param.faixa-ini
         tt-mac-address-param.faixa-fim
         tt-mac-address-param.sequencia
         tt-mac-address-param.alerta
         tt-mac-address-param.email
        WITH FRAME fPage0.*/

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-envia-email wWindow 
PROCEDURE pi-envia-email :
DEFINE INPUT PARAMETER p-remetente AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-destino   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-assunto   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-mensagem  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-anexo     AS CHARACTER NO-UNDO.

    FOR EACH tt-envio:
        DELETE tt-envio.
    END.

    FIND FIRST param-global NO-LOCK.

    create tt-envio.
    assign tt-envio.versao-integracao = 1
           tt-envio.exchange          = param-global.log-1
           tt-envio.remetente         = p-remetente
           tt-envio.destino           = p-destino
           tt-envio.assunto           = p-assunto
           tt-envio.mensagem          = p-mensagem
           tt-envio.importancia       = 2
           tt-envio.log-enviada       = no
           tt-envio.log-lida          = no
           tt-envio.acomp             = no.
           tt-envio.arq-anexo         = p-anexo.
           
     run utp/utapi009.p ( input  table tt-envio,
                          output  table tt-erros).

     IF CAN-FIND(FIRST tt-erros) THEN DO:
         FOR EACH tt-erros:
             MESSAGE "Erro envio email : "tt-erros.cod-erro " - " tt-erros.desc-erro VIEW-AS ALERT-BOX.
             DELETE tt-erros.
         END.
     END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva wWindow 
PROCEDURE pi-salva :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAIL tt-mac-address-param THEN DO:

        DO WITH FRAME fPage0:
            ASSIGN {&list-1}.
        END.
        
        ASSIGN tt-mac-address-param.faixa      = UPPER(tt-mac-address-param.faixa)
               tt-mac-address-param.faixa-ini  = UPPER(tt-mac-address-param.faixa-ini)
               tt-mac-address-param.faixa-fim  = UPPER(tt-mac-address-param.faixa-fim)
               tt-mac-address-param.alerta     = UPPER(tt-mac-address-param.alerta)
               tt-mac-address-param.usuario    = v_cod_usuar_corren
               tt-mac-address-param.dt-criacao = TODAY.

        RUN emptyRowErrors IN h-boes607 NO-ERROR.        
        EMPTY TEMP-TABLE tt-erro.
        EMPTY TEMP-TABLE RowErrors.

        RUN setRecord IN h-boes607 (INPUT TABLE tt-mac-address-param).

        IF p-acao = "ADD" OR p-acao = "COPY" THEN DO:
            RUN createRecord IN h-boes607.

            IF RETURN-VALUE = "OK":U
            THEN DO:
                //envia e-mail
                RUN esp/es0018p.p (INPUT "ESCPP059",
                                   INPUT 2,
                                   INPUT 0,
                                   INPUT "",
                                   OUTPUT TABLE tt-prog-ponto).

                FIND FIRST tt-prog-ponto NO-LOCK NO-ERROR.
                
                IF AVAIL tt-prog-ponto 
                THEN DO:

                    RUN pi-envia-email (INPUT "ems@intelbras.com.br":U,
                                INPUT tt-prog-ponto.conteudo,
                                INPUT "Nova Faixa de MAC cadastrada no Totvs":U,
                                INPUT "Mensagem autom†tica, n∆o responder!":U 
                                    + CHR(13)
                                    + CHR(13)
                                    + "Foi inclu°do uma nova faixa de MAC no sistema TOTVS com as seguintes configuraá‰es:"
                                    + CHR(13)
                                    + CHR(13)
                                    + "Faixa Mac: " + STRING(tt-mac-address-param.faixa)
                                    + CHR(13)
                                    + "Faixa Inicial: " + STRING(tt-mac-address-param.faixa-ini)
                                    + CHR(13)
                                    + "Faixa Final: " + STRING(tt-mac-address-param.faixa-fim)
                                    + CHR(13)
                                    + CHR(13)
                                    + "Obs.: Em casos de d£vida, comunique o departamento P&D Corporativo.":U,
                                INPUT "":U).
                
                END.
            END.
        END.
            
        IF p-acao = "MOD" THEN
            RUN updateRecord IN h-boes607.

        RUN getRowErrors IN h-boes607 (OUTPUT TABLE RowErrors).
        
        IF CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.errortype = "EMS") THEN DO:

            FOR EACH RowErrors
                WHERE RowErrors.errortype = "EMS":
                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = RowErrors.ErrorSequence
                       tt-erro.cd-erro  = RowErrors.ErrorNumber
                       tt-erro.mensagem = RowErrors.ErrorDescription.
            END.
            RUN cdp/cd0666.w (INPUT TABLE tt-erro).
            RETURN "NOK".

        END.

        RETURN "OK":U.

    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRetornaNomeUser wWindow 
FUNCTION fnRetornaNomeUser RETURNS CHARACTER
  ( INPUT ca-usuar AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE h-handle AS HANDLE    NO-UNDO.
DEFINE VARIABLE ca-nome  AS CHARACTER NO-UNDO.

RUN esbo/boes607.p PERSISTENT SET h-handle.

RUN piRetornaNomeUser IN h-handle (INPUT  ca-usuar,
                                   OUTPUT ca-nome).

IF VALID-HANDLE(h-handle) THEN
    DELETE PROCEDURE h-handle.

RETURN ca-nome.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

