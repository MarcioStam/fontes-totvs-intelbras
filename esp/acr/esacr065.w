&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-window 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESACR065 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESACR065 ACR}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

DEFINE TEMP-TABLE tt-excecao-cliente
    FIELD cod-cliente  LIKE int-excecao-dev-cliente.cod-cliente
    FIELD nome-cliente AS CHAR FORMAT "X(40)"
    INDEX idx-codigo cod-cliente.
          

DEFINE TEMP-TABLE tt-excecao-gr-cli
    FIELD cod-gr-cli  LIKE int-excecao-dev-cliente.cod-gr-cli
    FIELD ds-gr-cli   AS CHAR FORMAT "X(40)"
    INDEX idx-codigo cod-gr-cli.


DEFINE VARIABLE v_cod_cliente_exc AS INTEGER     NO-UNDO.
DEFINE VARIABLE v_cod_gr_cli_exc  AS CHARACTER   NO-UNDO.


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-cliente

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-excecao-cliente tt-excecao-gr-cli

/* Definitions for BROWSE br-cliente                                    */
&Scoped-define FIELDS-IN-QUERY-br-cliente tt-excecao-cliente.cod-cliente tt-excecao-cliente.nome-cliente   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-cliente   
&Scoped-define SELF-NAME br-cliente
&Scoped-define QUERY-STRING-br-cliente FOR EACH tt-excecao-cliente
&Scoped-define OPEN-QUERY-br-cliente OPEN QUERY {&SELF-NAME} FOR EACH tt-excecao-cliente.
&Scoped-define TABLES-IN-QUERY-br-cliente tt-excecao-cliente
&Scoped-define FIRST-TABLE-IN-QUERY-br-cliente tt-excecao-cliente


/* Definitions for BROWSE br-gr-cli                                     */
&Scoped-define FIELDS-IN-QUERY-br-gr-cli tt-excecao-gr-cli.cod-gr-cli   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-gr-cli   
&Scoped-define SELF-NAME br-gr-cli
&Scoped-define QUERY-STRING-br-gr-cli FOR EACH tt-excecao-gr-cli
&Scoped-define OPEN-QUERY-br-gr-cli OPEN QUERY {&SELF-NAME} FOR EACH tt-excecao-gr-cli.
&Scoped-define TABLES-IN-QUERY-br-gr-cli tt-excecao-gr-cli
&Scoped-define FIRST-TABLE-IN-QUERY-br-gr-cli tt-excecao-gr-cli


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br-cliente}~
    ~{&OPEN-QUERY-br-gr-cli}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-4 RECT-136 RECT-137 ~
rs-inclusao v_cdn_cliente v_cdn_gr_cli v_nom_abrev v_cod_cnpj bt-gravar ~
br-cliente br-gr-cli bt-elimina-cliente bt-elimina-gr-cli bt-ok bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS rs-inclusao v_cdn_cliente v_cdn_gr_cli ~
v_nom_cliente v_nom_abrev v_cod_cnpj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-window AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 13 BY 1.21.

DEFINE BUTTON bt-elimina-cliente 
     LABEL "Eliminar" 
     SIZE 13.86 BY .92.

DEFINE BUTTON bt-elimina-gr-cli 
     LABEL "Eliminar" 
     SIZE 13.86 BY .92.

DEFINE BUTTON bt-gravar 
     IMAGE-UP FILE "adeicon/check.bmp":U
     LABEL "Button 1" 
     SIZE 21 BY 1.25.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "Fechar" 
     SIZE 13 BY 1.21.

DEFINE VARIABLE v_cdn_cliente AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "C¢digo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE v_cdn_gr_cli AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Grupo Cobran‡a" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE v_cod_cnpj AS CHARACTER FORMAT "x(14)":U 
     LABEL "CNPJ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE v_nom_abrev AS CHARACTER FORMAT "X(12)":U 
     LABEL "Nome Abrev" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE v_nom_cliente AS CHARACTER FORMAT "X(40)":U 
     LABEL "Nome" 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE rs-inclusao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cliente", 1,
"Grupo de Cobran‡a", 2
     SIZE 43 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 115.14 BY 1.71
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-136
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 55 BY 4.5.

DEFINE RECTANGLE RECT-137
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 55 BY 4.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 114 BY 9.75.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 58 BY 1.92.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-cliente FOR 
      tt-excecao-cliente SCROLLING.

DEFINE QUERY br-gr-cli FOR 
      tt-excecao-gr-cli SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-cliente w-window _FREEFORM
  QUERY br-cliente DISPLAY
      tt-excecao-cliente.cod-cliente  FORMAT ">>>>>>>9":U COLUMN-LABEL "C¢digo"
      tt-excecao-cliente.nome-cliente FORMAT "X(40)":U COLUMN-LABEL "Nome Cliente"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 54.72 BY 8.5 ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.

DEFINE BROWSE br-gr-cli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-gr-cli w-window _FREEFORM
  QUERY br-gr-cli DISPLAY
      tt-excecao-gr-cli.cod-gr-cli  FORMAT "X(4)":U COLUMN-LABEL "Grupo Cobran‡a"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 54.72 BY 8.5 ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     rs-inclusao AT ROW 2.46 COL 42.29 NO-LABEL WIDGET-ID 56
     v_cdn_cliente AT ROW 4.5 COL 15 COLON-ALIGNED WIDGET-ID 48
     v_cdn_gr_cli AT ROW 5.25 COL 81 COLON-ALIGNED WIDGET-ID 62
     v_nom_cliente AT ROW 5.46 COL 15 COLON-ALIGNED WIDGET-ID 20
     v_nom_abrev AT ROW 6.46 COL 15 COLON-ALIGNED WIDGET-ID 4
     v_cod_cnpj AT ROW 7.46 COL 15 COLON-ALIGNED WIDGET-ID 6
     bt-gravar AT ROW 9.25 COL 50 WIDGET-ID 66
     br-cliente AT ROW 11.38 COL 3.29 WIDGET-ID 200
     br-gr-cli AT ROW 11.38 COL 62 WIDGET-ID 300
     bt-elimina-cliente AT ROW 20 COL 3.14 WIDGET-ID 68
     bt-elimina-gr-cli AT ROW 20 COL 62 WIDGET-ID 70
     bt-ok AT ROW 21.29 COL 3
     bt-ajuda AT ROW 21.29 COL 102
     " Adicionar Exce‡Æo por:" VIEW-AS TEXT
          SIZE 21 BY .67 AT ROW 1.63 COL 32.86 WIDGET-ID 36
     "Parƒmetros:" VIEW-AS TEXT
          SIZE 13 BY .67 AT ROW 1 COL 3 WIDGET-ID 28
     RECT-1 AT ROW 21.04 COL 1.86
     RECT-2 AT ROW 1.25 COL 3 WIDGET-ID 10
     RECT-4 AT ROW 2 COL 31 WIDGET-ID 38
     RECT-136 AT ROW 4.25 COL 4 WIDGET-ID 72
     RECT-137 AT ROW 4.25 COL 61 WIDGET-ID 74
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 116.57 BY 21.75 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: JanelaDetalhe
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert Custom SmartWindow title>"
         HEIGHT             = 21.92
         WIDTH              = 116.86
         MAX-HEIGHT         = 30
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 30
         VIRTUAL-WIDTH      = 195.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-window 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-window.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB br-cliente bt-gravar F-Main */
/* BROWSE-TAB br-gr-cli br-cliente F-Main */
/* SETTINGS FOR FILL-IN v_nom_cliente IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-cliente
/* Query rebuild information for BROWSE br-cliente
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-excecao-cliente.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-cliente */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-gr-cli
/* Query rebuild information for BROWSE br-gr-cli
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-excecao-gr-cli.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-gr-cli */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* <insert Custom SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* <insert Custom SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-cliente
&Scoped-define SELF-NAME br-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-cliente w-window
ON MOUSE-SELECT-CLICK OF br-cliente IN FRAME F-Main
DO:
    IF br-cliente:NUM-SELECTED-ROWS > 0 THEN
        GET CURRENT br-cliente.
    IF AVAIL tt-excecao-cliente THEN
        ASSIGN v_cod_cliente_exc = tt-excecao-cliente.cod-cliente.
    ELSE
        ASSIGN v_cod_cliente_exc = 0.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-gr-cli
&Scoped-define SELF-NAME br-gr-cli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-gr-cli w-window
ON MOUSE-SELECT-CLICK OF br-gr-cli IN FRAME F-Main
DO:
    IF br-gr-cli:NUM-SELECTED-ROWS > 0 THEN
        GET CURRENT br-gr-cli.

    IF AVAIL tt-excecao-gr-cli THEN
        ASSIGN v_cod_gr_cli_exc = tt-excecao-gr-cli.cod-gr-cli.
    ELSE
        ASSIGN v_cod_gr_cli_exc = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-window
ON CHOOSE OF bt-ajuda IN FRAME F-Main /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-elimina-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-elimina-cliente w-window
ON CHOOSE OF bt-elimina-cliente IN FRAME F-Main /* Eliminar */
DO:

    IF v_cod_cliente_exc > 0 THEN DO:

         FIND int-excecao-dev-cliente EXCLUSIVE-LOCK
            WHERE int-excecao-dev-cliente.id-identificacao = 1 /* cliente */
              AND int-excecao-dev-cliente.cod-cliente      = v_cod_cliente_exc NO-ERROR.

         IF AVAIL int-excecao-dev-cliente THEN
            DELETE int-excecao-dev-cliente.

         RUN pi-carrega-tt-browse-cliente.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-elimina-gr-cli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-elimina-gr-cli w-window
ON CHOOSE OF bt-elimina-gr-cli IN FRAME F-Main /* Eliminar */
DO:

    IF v_cod_gr_cli_exc <> "" THEN DO:

         FIND int-excecao-dev-cliente EXCLUSIVE-LOCK
            WHERE int-excecao-dev-cliente.id-identificacao = 2 /* grupo */
              AND int-excecao-dev-cliente.cod-gr-cli       = v_cod_gr_cli_exc NO-ERROR.

         IF AVAIL int-excecao-dev-cliente THEN
            DELETE int-excecao-dev-cliente.

         RUN pi-carrega-tt-browse-gr-cli.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-gravar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-gravar w-window
ON CHOOSE OF bt-gravar IN FRAME F-Main /* Button 1 */
DO:
   
    FIND emitente NO-LOCK
        WHERE emitente.cod-emit = INPUT FRAME {&FRAME-NAME} v_cdn_cliente
        NO-ERROR.

    IF  NOT AVAIL emitente THEN
        RETURN NO-APPLY.

    IF  emitente.nome-abrev <> emitente.nome-matriz THEN DO:
        run utp/ut-msgs.p (input "show", input 17006, input "Emitente nÆo ‚ Matriz" + "~~" +                                   
                           "As exce‡äes devem ser cadastradas apenas pela Matriz").
        RETURN NO-APPLY.
    END.

    IF INPUT FRAME {&FRAME-NAME} rs-inclusao = 1 THEN DO: /* Cliente */

        FIND int-excecao-dev-cliente EXCLUSIVE-LOCK
            WHERE int-excecao-dev-cliente.id-identificacao = 1
              AND int-excecao-dev-cliente.cod-cliente      = v_cdn_cliente
            NO-ERROR.
        IF NOT AVAIL int-excecao-dev-cliente THEN DO:
            CREATE int-excecao-dev-cliente.
            ASSIGN int-excecao-dev-cliente.cod-cliente      = v_cdn_cliente
                   int-excecao-dev-cliente.id-identificacao = 1.
        END.

        RUN pi-carrega-tt-browse-cliente.
    END.
    ELSE DO: /* Grupo Cliente */


        FIND int-excecao-dev-cliente EXCLUSIVE-LOCK
            WHERE int-excecao-dev-cliente.id-identificacao = 2
              AND int-excecao-dev-cliente.cod-gr-cli       = string(INPUT FRAME {&FRAME-NAME} v_cdn_gr_cli)
            NO-ERROR.
        IF NOT AVAIL int-excecao-dev-cliente THEN DO:
            CREATE int-excecao-dev-cliente.
            ASSIGN int-excecao-dev-cliente.cod-gr-cli       = string(INPUT FRAME {&FRAME-NAME} v_cdn_gr_cli)
                   int-excecao-dev-cliente.id-identificacao = 2.
       END.


       RUN pi-carrega-tt-browse-gr-cli.
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME F-Main /* Fechar */
DO:
  apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-inclusao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-inclusao w-window
ON VALUE-CHANGED OF rs-inclusao IN FRAME F-Main
DO:
  
    ASSIGN v_cdn_cliente = 0
           v_nom_abrev   = ""
           v_cod_cnpj    = ""
           v_cdn_gr_cli  = 0.

    DISPLAY v_cdn_cliente
            v_nom_abrev  
            v_cod_cnpj   
            v_cdn_gr_cli WITH FRAME {&FRAME-NAME}.


    IF INPUT FRAME {&FRAME-NAME} rs-inclusao = 1 THEN DO: /* Cliente */

        ENABLE v_cdn_cliente
               v_nom_abrev
               v_cod_cnpj WITH FRAME {&FRAME-NAME}.

        DISABLE v_cdn_gr_cli WITH FRAME {&FRAME-NAME}.
    END.
    ELSE DO:

        DISABLE v_cdn_cliente
                v_nom_abrev
                v_cod_cnpj WITH FRAME {&FRAME-NAME}.

        ENABLE v_cdn_gr_cli WITH FRAME {&FRAME-NAME}.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v_cdn_cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v_cdn_cliente w-window
ON LEAVE OF v_cdn_cliente IN FRAME F-Main /* C¢digo */
DO:
    
    /*
    ASSIGN v_cdn_cliente = INPUT FRAME {&FRAME-NAME} v_cdn_cliente
           v_nom_abrev   = INPUT FRAME {&FRAME-NAME} v_nom_abrev
           v_cod_cnpj    = INPUT FRAME {&FRAME-NAME} v_cod_cnpj.

      */

   IF INPUT FRAME {&FRAME-NAME} v_cdn_cliente <> 0 THEN DO:
                                  
        FIND emitente NO-LOCK
            WHERE emitente.cod-emit = INPUT FRAME {&FRAME-NAME} v_cdn_cliente
            NO-ERROR.

        IF AVAIL emitente THEN
            ASSIGN v_nom_cliente = emitente.nome-emit
                   v_cdn_cliente = emitente.cod-emit
                   v_nom_abrev   = emitente.nome-abrev
                   v_cod_cnpj    = emitente.cgc.
        ELSE
            ASSIGN v_nom_cliente = "NAO ENCONTRADO"
                   v_nom_cliente = ""
                   v_cdn_cliente = 0
                   v_nom_abrev   = ""
                   v_cod_cnpj    = "".
    END.  
    ELSE
        ASSIGN v_nom_cliente = "NAO ENCONTRADO"
               v_cdn_cliente = 0
               v_nom_abrev   = ""
               v_cod_cnpj    = "".

              
    DISP v_nom_cliente 
         v_cdn_cliente
         v_nom_abrev  
         v_cod_cnpj WITH FRAME {&FRAME-NAME}.

                             
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v_cod_cnpj
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v_cod_cnpj w-window
ON LEAVE OF v_cod_cnpj IN FRAME F-Main /* CNPJ */
DO:
    
                                 /*
    ASSIGN v_cdn_cliente = INPUT FRAME {&FRAME-NAME} v_cdn_cliente
           v_nom_abrev   = INPUT FRAME {&FRAME-NAME} v_nom_abrev
           v_cod_cnpj    = INPUT FRAME {&FRAME-NAME} v_cod_cnpj.
                                   */


    IF INPUT FRAME {&FRAME-NAME} v_cod_cnpj <> "" THEN DO:
                                  
        FIND emitente NO-LOCK
            WHERE emitente.cgc = INPUT FRAME {&FRAME-NAME} v_cod_cnpj
            NO-ERROR.

        IF AVAIL emitente THEN
            ASSIGN v_nom_cliente = emitente.nome-emit
                   v_cdn_cliente = emitente.cod-emit
                   v_nom_abrev   = emitente.nome-abrev
                   v_cod_cnpj    = emitente.cgc.
        ELSE
            ASSIGN v_nom_cliente = "NAO ENCONTRADO"
                   v_nom_cliente = ""
                   v_cdn_cliente = 0
                   v_nom_abrev   = ""
                   v_cod_cnpj    = "".
    END.  
    ELSE
        ASSIGN v_nom_cliente = "NAO ENCONTRADO"
               v_cdn_cliente = 0
               v_nom_abrev   = ""
               v_cod_cnpj    = "".

              
    DISP v_nom_cliente 
         v_cdn_cliente
         v_nom_abrev  
         v_cod_cnpj WITH FRAME {&FRAME-NAME}.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v_nom_abrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v_nom_abrev w-window
ON LEAVE OF v_nom_abrev IN FRAME F-Main /* Nome Abrev */
DO:              
  /*         
    ASSIGN v_cdn_cliente = INPUT FRAME {&FRAME-NAME} v_cdn_cliente
           v_nom_abrev   = INPUT FRAME {&FRAME-NAME} v_nom_abrev
           v_cod_cnpj    = INPUT FRAME {&FRAME-NAME} v_cod_cnpj.
    */


    IF INPUT FRAME {&FRAME-NAME} v_nom_abrev <> "" THEN DO:
        
        FIND emitente NO-LOCK
            WHERE emitente.nome-abrev = INPUT FRAME {&FRAME-NAME} v_nom_abrev
            NO-ERROR.
    
        IF AVAIL emitente THEN 
            ASSIGN v_nom_cliente = emitente.nome-emit
                   v_cdn_cliente = emitente.cod-emit
                   v_nom_abrev   = emitente.nome-abrev
                   v_cod_cnpj    = emitente.cgc.
        ELSE 
            ASSIGN v_nom_cliente = "NAO ENCONTRADO"
                   v_cdn_cliente = 0
                   v_nom_abrev   = ""
                   v_cod_cnpj    = "".
    END.
    ELSE
        ASSIGN v_nom_cliente = "NAO ENCONTRADO"
               v_nom_cliente = ""
               v_cdn_cliente = 0
               v_nom_abrev   = ""
               v_cod_cnpj    = "".
     
   
    
    DISP v_nom_cliente 
         v_cdn_cliente
         v_nom_abrev  
         v_cod_cnpj WITH FRAME {&FRAME-NAME}.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-cliente
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-window 


/* ***************************  Main Block  *************************** */




/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-window  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-window  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-window  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
  THEN DELETE WIDGET w-window.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-window  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY rs-inclusao v_cdn_cliente v_cdn_gr_cli v_nom_cliente v_nom_abrev 
          v_cod_cnpj 
      WITH FRAME F-Main IN WINDOW w-window.
  ENABLE RECT-1 RECT-2 RECT-4 RECT-136 RECT-137 rs-inclusao v_cdn_cliente 
         v_cdn_gr_cli v_nom_abrev v_cod_cnpj bt-gravar br-cliente br-gr-cli 
         bt-elimina-cliente bt-elimina-gr-cli bt-ok bt-ajuda 
      WITH FRAME F-Main IN WINDOW w-window.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW w-window.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-window 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-window 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-window 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/


  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}
  
  {utp/ut9000.i "ESACR065" "1.00.00.000"}


  RUN pi-carrega-tt-browse-cliente.
  RUN pi-carrega-tt-browse-gr-cli.




  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .


  DISABLE v_cdn_gr_cli WITH FRAME {&FRAME-NAME}.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-tt-browse-cliente w-window 
PROCEDURE pi-carrega-tt-browse-cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-excecao-cliente NO-ERROR.



FOR EACH int-excecao-dev-cliente NO-LOCK
    WHERE int-excecao-dev-cliente.id-identificacao = 1: /* Cliente */
        
    CREATE tt-excecao-cliente.
    ASSIGN tt-excecao-cliente.cod-cliente  = int-excecao-dev-cliente.cod-cliente.

    FOR FIRST emscad.cliente NO-LOCK WHERE
        cliente.cdn_cliente = int-excecao-dev-cliente.cod-cliente:
        ASSIGN tt-excecao-cliente.nome-cliente = cliente.nom_pessoa.
    END.
END.

/*
ASSIGN v_nom_cliente = "".

DISP v_nom_cliente 
    WITH FRAME {&FRAME-NAME}.
  */

{&open-query-br-cliente}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-tt-browse-gr-cli w-window 
PROCEDURE pi-carrega-tt-browse-gr-cli :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-excecao-gr-cli NO-ERROR.


FOR EACH int-excecao-dev-cliente NO-LOCK
    WHERE int-excecao-dev-cliente.id-identificacao = 2: /* Grupo Cliente */
        
    CREATE tt-excecao-gr-cli.
    ASSIGN tt-excecao-gr-cli.cod-gr-cli  = int-excecao-dev-cliente.cod-gr-cli.

END.

/*
ASSIGN v_nom_cliente = "".

DISP v_nom_cliente 
    WITH FRAME {&FRAME-NAME}.
  */

{&open-query-br-gr-cli}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-window  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-excecao-gr-cli"}
  {src/adm/template/snd-list.i "tt-excecao-cliente"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-window 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

