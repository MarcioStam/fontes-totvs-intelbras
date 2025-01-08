&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME esesb008d
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS esesb008d 
{include/i-prgvrs.i esesb008d 2.00.00.000}


CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.

DEF TEMP-TABLE tt-usuario-beneficio NO-UNDO LIKE int-usuario-beneficio
    FIELD nome AS CHAR FORMAT "X(60)"
    FIELD r-rowid AS ROWID.

DEF BUFFER b-tt-usuario-beneficio FOR tt-usuario-beneficio.

DEF TEMP-TABLE tt-permissoes NO-UNDO
    FIELD cod-usuario  AS CHAR
    FIELD tp-permissao AS INTE
    FIELD descricao    AS CHAR FORMAT "X(60)".

DEF TEMP-TABLE tt-lista NO-UNDO
    FIELD tp-permissao AS INTE
    FIELD descricao    AS CHAR FORMAT "X(60)".

DEF BUFFER b-int-usuario-beneficio FOR int-usuario-beneficio.

{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-lista

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-lista tt-permissoes tt-usuario-beneficio

/* Definitions for BROWSE br-lista                                      */
&Scoped-define FIELDS-IN-QUERY-br-lista tt-lista.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-lista   
&Scoped-define SELF-NAME br-lista
&Scoped-define QUERY-STRING-br-lista FOR EACH tt-lista
&Scoped-define OPEN-QUERY-br-lista OPEN QUERY {&SELF-NAME} FOR EACH tt-lista.
&Scoped-define TABLES-IN-QUERY-br-lista tt-lista
&Scoped-define FIRST-TABLE-IN-QUERY-br-lista tt-lista


/* Definitions for BROWSE br-permissoes                                 */
&Scoped-define FIELDS-IN-QUERY-br-permissoes tt-permissoes.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-permissoes   
&Scoped-define SELF-NAME br-permissoes
&Scoped-define QUERY-STRING-br-permissoes FOR EACH tt-permissoes
&Scoped-define OPEN-QUERY-br-permissoes OPEN QUERY {&SELF-NAME} FOR EACH tt-permissoes.
&Scoped-define TABLES-IN-QUERY-br-permissoes tt-permissoes
&Scoped-define FIRST-TABLE-IN-QUERY-br-permissoes tt-permissoes


/* Definitions for BROWSE br-usuario-beneficio                          */
&Scoped-define FIELDS-IN-QUERY-br-usuario-beneficio tt-usuario-beneficio.cod-usuario tt-usuario-beneficio.nome tt-usuario-beneficio.mestre   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-usuario-beneficio   
&Scoped-define SELF-NAME br-usuario-beneficio
&Scoped-define QUERY-STRING-br-usuario-beneficio FOR EACH tt-usuario-beneficio
&Scoped-define OPEN-QUERY-br-usuario-beneficio OPEN QUERY {&SELF-NAME} FOR EACH tt-usuario-beneficio.
&Scoped-define TABLES-IN-QUERY-br-usuario-beneficio tt-usuario-beneficio
&Scoped-define FIRST-TABLE-IN-QUERY-br-usuario-beneficio tt-usuario-beneficio


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-lista}~
    ~{&OPEN-QUERY-br-permissoes}~
    ~{&OPEN-QUERY-br-usuario-beneficio}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button rt-button-2 RECT-125 RECT-129 ~
RECT-130 bt-goto-emitente bt-exit fi-usuario br-usuario-beneficio bt-novo ~
bt-altera-2 br-lista br-permissoes bt-direita bt-esquerda bt-ok bt-cancela 
&Scoped-Define DISPLAYED-OBJECTS fi-usuario fi-nome 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNome esesb008d 
FUNCTION fnNome RETURNS CHARACTER
  ( INPUT p-codigo AS CHAR /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR esesb008d AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-altera-2 
     IMAGE-UP FILE "adeicon/cross.bmp":U
     LABEL "" 
     SIZE 5 BY 1.25 TOOLTIP "Elimina todas as permiss‰es de acesso".

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancela" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-direita 
     IMAGE-UP FILE "adeicon/next-au.bmp":U
     LABEL "Button 2" 
     SIZE 6 BY 1.13 TOOLTIP "Conceder permiss∆o".

DEFINE BUTTON bt-esquerda 
     IMAGE-UP FILE "adeicon/prev-au.bmp":U
     LABEL "" 
     SIZE 6 BY 1.13 TOOLTIP "Retirar permiss∆o".

DEFINE BUTTON bt-exit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-DOWN FILE "image\ii-exi":U
     LABEL "" 
     SIZE 4 BY 1.17.

DEFINE BUTTON bt-goto-emitente 
     IMAGE-UP FILE "IMAGE/im-enter.bmp":U
     LABEL "" 
     SIZE 4 BY 1.17 TOOLTIP "Localizar Usu†rio".

DEFINE BUTTON bt-novo 
     IMAGE-UP FILE "adeicon/new.bmp":U
     LABEL "" 
     SIZE 5 BY 1.25 TOOLTIP "Novo Usu†rio".

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&Fechar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-usuario AS CHARACTER FORMAT "x(12)":U 
     LABEL "Usu†rio" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-125
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98.29 BY 7.08.

DEFINE RECTANGLE RECT-129
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 6.29.

DEFINE RECTANGLE RECT-130
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 6.29.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 98.29 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE rt-button-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 98.29 BY 1.38
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-lista FOR 
      tt-lista SCROLLING.

DEFINE QUERY br-permissoes FOR 
      tt-permissoes SCROLLING.

DEFINE QUERY br-usuario-beneficio FOR 
      tt-usuario-beneficio SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-lista
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-lista esesb008d _FREEFORM
  QUERY br-lista DISPLAY
      tt-lista.descricao            COLUMN-LABEL "Permiss‰es"   WIDTH 30  COLUMN-FGCOLOR 4 COLUMN-FONT 1
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 43.14 BY 5.75
         FONT 7
         TITLE "Lista" ROW-HEIGHT-CHARS .6 FIT-LAST-COLUMN.

DEFINE BROWSE br-permissoes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-permissoes esesb008d _FREEFORM
  QUERY br-permissoes DISPLAY
      tt-permissoes.descricao   COLUMN-LABEL ""    WIDTH 45 COLUMN-FGCOLOR 9 COLUMN-FONT 1
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 43.14 BY 5.67
         FONT 7
         TITLE "Operaá‰es permitidas para este Usu†rio" ROW-HEIGHT-CHARS .6 FIT-LAST-COLUMN.

DEFINE BROWSE br-usuario-beneficio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-usuario-beneficio esesb008d _FREEFORM
  QUERY br-usuario-beneficio DISPLAY
      tt-usuario-beneficio.cod-usuario  COLUMN-LABEL "Movto"      WIDTH 15
      tt-usuario-beneficio.nome         COLUMN-LABEL "Nome"       WIDTH 45
      tt-usuario-beneficio.mestre       COLUMN-LABEL "Usu†rio Mestre" WIDTH 15
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 6.46
         FONT 7
         TITLE "Usu†rio X Pemiss∆o Benef°cios" ROW-HEIGHT-CHARS .6 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-goto-emitente AT ROW 1.13 COL 68.86 HELP
          "Localizar usu†rio na lista abaixo" WIDGET-ID 64
     bt-exit AT ROW 1.13 COL 95.86 WIDGET-ID 58
     fi-usuario AT ROW 1.25 COL 8 COLON-ALIGNED WIDGET-ID 56
     fi-nome AT ROW 1.25 COL 27.43 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     br-usuario-beneficio AT ROW 2.79 COL 3 WIDGET-ID 200
     bt-novo AT ROW 2.79 COL 93.72 WIDGET-ID 68
     bt-altera-2 AT ROW 4.08 COL 93.72 WIDGET-ID 70
     br-lista AT ROW 10.25 COL 2.86 WIDGET-ID 300
     br-permissoes AT ROW 10.25 COL 56.14 WIDGET-ID 400
     bt-direita AT ROW 11.71 COL 48.14 WIDGET-ID 74
     bt-esquerda AT ROW 12.96 COL 48.14 WIDGET-ID 76
     bt-ok AT ROW 16.96 COL 2.57
     bt-cancela AT ROW 16.96 COL 89.72
     rt-button AT ROW 16.75 COL 2
     rt-button-2 AT ROW 1 COL 2 WIDGET-ID 60
     RECT-125 AT ROW 2.46 COL 2 WIDGET-ID 72
     RECT-129 AT ROW 10 COL 2 WIDGET-ID 84
     RECT-130 AT ROW 10 COL 55.29 WIDGET-ID 86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1.04
         SIZE 99.72 BY 17.42
         FONT 7.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW esesb008d ASSIGN
         HIDDEN             = YES
         TITLE              = "Permiss∆o de usu†rios"
         HEIGHT             = 17.29
         WIDTH              = 100
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = yes
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB esesb008d 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW esesb008d
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB br-usuario-beneficio fi-nome f-cad */
/* BROWSE-TAB br-lista bt-altera-2 f-cad */
/* BROWSE-TAB br-permissoes br-lista f-cad */
ASSIGN 
       bt-cancela:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR FILL-IN fi-nome IN FRAME f-cad
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(esesb008d)
THEN esesb008d:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-lista
/* Query rebuild information for BROWSE br-lista
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-lista.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-lista */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-permissoes
/* Query rebuild information for BROWSE br-permissoes
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-permissoes.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-permissoes */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-usuario-beneficio
/* Query rebuild information for BROWSE br-usuario-beneficio
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-usuario-beneficio
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-usuario-beneficio */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME esesb008d
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL esesb008d esesb008d
ON END-ERROR OF esesb008d /* Permiss∆o de usu†rios */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL esesb008d esesb008d
ON WINDOW-CLOSE OF esesb008d /* Permiss∆o de usu†rios */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-usuario-beneficio
&Scoped-define SELF-NAME br-usuario-beneficio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-usuario-beneficio esesb008d
ON MOUSE-SELECT-CLICK OF br-usuario-beneficio IN FRAME f-cad /* Usu†rio X Pemiss∆o Benef°cios */
DO:
  RUN pi-carrega-lista. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-usuario-beneficio esesb008d
ON VALUE-CHANGED OF br-usuario-beneficio IN FRAME f-cad /* Usu†rio X Pemiss∆o Benef°cios */
DO: 
    RUN pi-carrega-lista. 
    RUN pi-carrega-permissoes. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-altera-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-altera-2 esesb008d
ON CHOOSE OF bt-altera-2 IN FRAME f-cad
DO:
  
    IF  NOT AVAIL tt-usuario-beneficio THEN
        RETURN NO-APPLY.

    IF  tt-usuario-beneficio.mestre THEN DO:
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "Usu†rio Mestre." + "~~" + 
                                "N∆o Ç poss°vel eliminaá∆o de usu†rio mestre").
        RETURN NO-APPLY.
    END.

    DO TRANS:
        FOR EACH int-usuario-beneficio EXCLUSIVE-LOCK
            WHERE int-usuario-beneficio.cod-usuario = tt-usuario-beneficio.cod-usuario:

            DELETE int-usuario-beneficio.
        END.

        RELEASE int-usuario-beneficio NO-ERROR.
    END.

    RUN pi-carrega-usuarios.
    RUN pi-carrega-lista. 
    RUN pi-carrega-permissoes. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela esesb008d
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Cancela */
DO:
  
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-direita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-direita esesb008d
ON CHOOSE OF bt-direita IN FRAME f-cad /* Button 2 */
DO:
    IF  NOT AVAIL tt-lista THEN
        RETURN "OK".
    
    IF  NOT AVAIL tt-usuario-beneficio THEN
        RETURN "OK".

    
    DO TRANS:
        CREATE int-usuario-beneficio.
        ASSIGN int-usuario-beneficio.cod-usuario  = tt-usuario-beneficio.cod-usuario
               int-usuario-beneficio.tp-permissao = tt-lista.tp-permissao.

        RELEASE int-usuario-beneficio.

        CREATE tt-permissoes.
        ASSIGN tt-permissoes.cod-usuario  = tt-usuario-beneficio.cod-usuario
               tt-permissoes.tp-permissao = tt-lista.tp-permissao
               tt-permissoes.descricao    = tt-lista.descricao.
    END.

    RUN pi-carrega-lista.
    RUN pi-carrega-permissoes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-esquerda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-esquerda esesb008d
ON CHOOSE OF bt-esquerda IN FRAME f-cad
DO:
   IF  NOT AVAIL tt-permissoes THEN
       RETURN "OK".
  
   IF  NOT AVAIL tt-usuario-beneficio THEN
       RETURN "OK".
  
   DO TRANS:

      FIND FIRST int-usuario-beneficio EXCLUSIVE-LOCK
          WHERE int-usuario-beneficio.cod-usuario  = tt-permissoes.cod-usuario
            AND int-usuario-beneficio.tp-permissao = tt-permissoes.tp-permissao NO-ERROR.

      IF  AVAIL int-usuario-beneficio AND NOT int-usuario-beneficio.mestre THEN
          DELETE int-usuario-beneficio.
          
      RELEASE int-usuario-beneficio.
     
  END.

  RUN pi-carrega-lista.
  RUN pi-carrega-permissoes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exit esesb008d
ON CHOOSE OF bt-exit IN FRAME f-cad
DO:
  APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-goto-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-goto-emitente esesb008d
ON CHOOSE OF bt-goto-emitente IN FRAME f-cad
DO:
    DEF VAR c-nome AS CHAR NO-UNDO.
    DEF BUFFER b-tt-usuario-beneficio FOR tt-usuario-beneficio.

    FIND FIRST usuar_mestre NO-LOCK
        WHERE usuar_mestre.cod_usuario = fi-usuario:SCREEN-VALUE IN FRAME f-cad NO-ERROR.

    IF  NOT AVAIL usuar_mestre THEN DO:
        RUN utp/ut-msgs.p(input "show":U, 
                          input 17006,
                          input "Usu†rio n∆o existe no cadastro geral de usu†rios do sistema.").
        RETURN NO-APPLY.
    END.
    ELSE 
        ASSIGN c-nome = usuar_mestre.nom_usuario.

    FIND FIRST b-tt-usuario-beneficio 
        WHERE b-tt-usuario-beneficio.cod-usuario = fi-usuario:SCREEN-VALUE IN FRAME f-cad NO-ERROR.

   IF  NOT AVAIL b-tt-usuario-beneficio THEN DO:
       RUN utp/ut-msgs.p(input "show":U, 
                         input 17006,
                         input "Usu†rio n∆o localizado.").
       APPLY "entry" TO fi-usuario IN FRAME f-cad.
       RETURN NO-APPLY.
   END.
 
   ASSIGN fi-nome:SCREEN-VALUE IN FRAME f-cad = c-nome.
   
   REPOSITION br-usuario-beneficio TO ROWID ROWID(b-tt-usuario-beneficio).
   APPLY "value-changed" TO br-usuario-beneficio IN FRAME f-cad.
   APPLY "row-display" TO br-usuario-beneficio IN FRAME f-cad.
  
   RETURN "OK".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-novo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-novo esesb008d
ON CHOOSE OF bt-novo IN FRAME f-cad
DO:
    DEF VAR r-rowid-novo AS ROWID NO-UNDO.
    
    FIND FIRST int-usuario-beneficio NO-LOCK
        WHERE int-usuario-beneficio.cod-usuario = c-seg-usuario NO-ERROR.

    IF  NOT AVAIL int-usuario-beneficio THEN DO:
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "Usu†rio " + c-seg-usuario + " n∆o tem pemiss‰es para esta operaá∆o" + "~~" + 
                                "Usu†rio deve possuir permiss∆o mestre para acessar esse programa.").
        RETURN NO-APPLY.
    END.


    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    
    RUN esp/esb/esesb008d-01.w (OUTPUT r-rowid-novo).

    IF  r-rowid-novo <> ? THEN DO:
        RUN pi-carrega-usuarios.
        FIND FIRST b-tt-usuario-beneficio NO-LOCK
            WHERE rowid(b-tt-usuario-beneficio) = r-rowid-novo NO-ERROR.

        IF  AVAIL b-tt-usuario-beneficio THEN DO:
            
            REPOSITION br-usuario-beneficio TO ROWID ROWID(b-tt-usuario-beneficio).
            APPLY "value-changed" TO br-usuario-beneficio IN FRAME f-cad.
            APPLY "row-display" TO br-usuario-beneficio IN FRAME f-cad.
        END.
    END.
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok esesb008d
ON CHOOSE OF bt-ok IN FRAME f-cad /* Fechar */
DO:
          
    /*
    RUN notify ('update-record':U).
    if return-value <> "adm-error":U then */
     apply "close":U to this-procedure.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-usuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-usuario esesb008d
ON LEAVE OF fi-usuario IN FRAME f-cad /* Usu†rio */
DO:
  
    FIND FIRST usuar_mestre NO-LOCK
        WHERE usuar_mestre.cod_usuario = fi-usuario:SCREEN-VALUE IN FRAME f-cad NO-ERROR.

    IF  AVAIL usuar_mestre THEN 
        fi-nome:SCREEN-VALUE IN FRAME f-cad = usuar_mestre.nom_usuario.
    ELSE
        fi-nome:SCREEN-VALUE IN FRAME f-cad = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-lista
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK esesb008d 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects esesb008d  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available esesb008d  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI esesb008d  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(esesb008d)
  THEN DELETE WIDGET esesb008d.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI esesb008d  _DEFAULT-ENABLE
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
  DISPLAY fi-usuario fi-nome 
      WITH FRAME f-cad IN WINDOW esesb008d.
  ENABLE rt-button rt-button-2 RECT-125 RECT-129 RECT-130 bt-goto-emitente 
         bt-exit fi-usuario br-usuario-beneficio bt-novo bt-altera-2 br-lista 
         br-permissoes bt-direita bt-esquerda bt-ok bt-cancela 
      WITH FRAME f-cad IN WINDOW esesb008d.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW esesb008d.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy esesb008d 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display esesb008d 
PROCEDURE local-display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit esesb008d 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize esesb008d 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "ISGT008d" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  EMPTY TEMP-TABLE tt-usuario-beneficio.  

  FIND FIRST int-usuario-beneficio NO-LOCK
      WHERE int-usuario-beneficio.cod-usuario = c-seg-usuario NO-ERROR.
  
  IF  NOT AVAIL int-usuario-beneficio
  OR  AVAIL int-usuario-beneficio AND NOT int-usuario-beneficio.mestre THEN DO:

      RUN utp/ut-msgs.p(INPUT "show",
                INPUT 17006,
                INPUT "Usu†rio " + c-seg-usuario + " n∆o tem autorizaá∆o para acessar este programa.").
      RUN notify ('cancel-record':U).
      APPLY "close":U to this-procedure.

  END.

  RUN pi-carrega-usuarios.
  RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME f-cad:HANDLE ).

  RUN dispatch  IN this-procedure ('enable-fields':U).
  
  RUN dispatch  IN this-procedure ('display-fields':U).

  {include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-lista esesb008d 
PROCEDURE pi-carrega-lista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-lista.
    
    IF  NOT AVAIL tt-usuario-beneficio THEN 
        RETURN "OK".

    FOR EACH int-benef-funcao NO-LOCK:

        FIND FIRST int-usuario-beneficio
            WHERE int-usuario-beneficio.cod-usuario  = tt-usuario-beneficio.cod-usuario
              AND int-usuario-beneficio.tp-permissao = int-benef-funcao.tp-permissao NO-LOCK NO-ERROR.

        IF  NOT AVAIL int-usuario-beneficio THEN DO:
            CREATE tt-lista.
            ASSIGN tt-lista.tp-permissao = int-benef-funcao.tp-permissao
                   tt-lista.descricao    = int-benef-funcao.descricao.
        END.
               
    END.

    {&open-query-br-lista}

    APPLY "value-changed" TO br-lista IN FRAME f-cad.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-permissoes esesb008d 
PROCEDURE pi-carrega-permissoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-permissoes.
    
    IF  NOT AVAIL tt-usuario-beneficio THEN 
        RETURN "OK".

    FOR EACH int-usuario-beneficio
        WHERE int-usuario-beneficio.cod-usuario = tt-usuario-beneficio.cod-usuario
        ,FIRST int-benef-funcao NO-LOCK
             WHERE int-benef-funcao.tp-permissao = int-usuario-beneficio.tp-permissao:
        CREATE tt-permissoes.
        ASSIGN tt-permissoes.cod-usuario  = int-usuario-beneficio.cod-usuario
               tt-permissoes.tp-permissao = int-usuario-beneficio.tp-permissao
               tt-permissoes.descricao    = int-benef-funcao.descricao.
    END.

    {&open-query-br-permissoes}

    APPLY "value-changed" TO br-permissoes IN FRAME f-cad.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-usuarios esesb008d 
PROCEDURE pi-carrega-usuarios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-usuario-beneficio.
    
    FOR EACH int-usuario-beneficio NO-LOCK
        ,FIRST usuar_mestre NO-LOCK
            WHERE usuar_mestre.cod_usuario = int-usuario-beneficio.cod-usuario
        BREAK BY int-usuario-beneficio.cod-usuario:
          
        IF  FIRST-OF (int-usuario-beneficio.cod-usuario) THEN DO:
            CREATE tt-usuario-beneficio.
            ASSIGN tt-usuario-beneficio.cod-usuario  = int-usuario-beneficio.cod-usuario
                   tt-usuario-beneficio.nome         = usuar_mestre.nom_usuario
                   tt-usuario-beneficio.mestre       = int-usuario-beneficio.mestre
                   tt-usuario-beneficio.r-rowid      = ROWID(int-usuario-beneficio).
        END.
    END.

    {&open-query-br-usuario-beneficio}

    APPLY "value-changed" TO br-usuario-beneficio IN FRAME f-cad.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records esesb008d  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-usuario-beneficio"}
  {src/adm/template/snd-list.i "tt-permissoes"}
  {src/adm/template/snd-list.i "tt-lista"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed esesb008d 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNome esesb008d 
FUNCTION fnNome RETURNS CHARACTER
  ( INPUT p-codigo AS CHAR /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND FIRST usuar_mestre NO-LOCK
      WHERE usuar_mestre.cod_usuario = p-codigo NO-ERROR.

  IF  AVAIL usuar_mestre THEN
      RETURN usuar_mestre.nom_usuario.
  ELSE
      RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

