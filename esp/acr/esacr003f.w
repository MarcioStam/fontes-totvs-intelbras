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
{include/i-prgvrs.i esacr003f 9.99.99.999}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esacr003f
&GLOBAL-DEFINE Version        2.0

&GLOBAL-DEFINE WindowType     ThinWindow

&GLOBAL-DEFINE page0Widgets   btOK btCancel br-emit-a br-emit-b


/* Parameters Definitions ---                                           */

/* mgesp Variable Definitions ---                                       */

DEF INPUT PARAM p-nome-matriz AS CHAR NO-UNDO.
DEF INPUT PARAM p-cod-emitente AS INTEGER NO-UNDO.

DEF TEMP-TABLE tt-emit-a
    FIELD cod-emitente AS INTEGER
    FIELD nome         AS CHAR FORMAT "X(60)"
    FIELD cgc          AS CHAR FORMAT "X(20)"
    FIELD situacao     AS CHAR FORMAT "X(30)".

DEF TEMP-TABLE tt-emit-b
    FIELD cod-emitente AS INTEGER
    FIELD nome         AS CHAR FORMAT "X(60)"
    FIELD cgc          AS CHAR FORMAT "X(20)"
    FIELD situacao     AS CHAR FORMAT "X(30)".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-emit-a

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-emit-a tt-emit-b

/* Definitions for BROWSE br-emit-a                                     */
&Scoped-define FIELDS-IN-QUERY-br-emit-a tt-emit-a.cod-emitente tt-emit-a.nome tt-emit-a.cgc tt-emit-a.situacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-emit-a   
&Scoped-define SELF-NAME br-emit-a
&Scoped-define QUERY-STRING-br-emit-a FOR EACH tt-emit-a
&Scoped-define OPEN-QUERY-br-emit-a OPEN QUERY {&SELF-NAME} FOR EACH tt-emit-a.
&Scoped-define TABLES-IN-QUERY-br-emit-a tt-emit-a
&Scoped-define FIRST-TABLE-IN-QUERY-br-emit-a tt-emit-a


/* Definitions for BROWSE br-emit-b                                     */
&Scoped-define FIELDS-IN-QUERY-br-emit-b tt-emit-b.cod-emitente tt-emit-b.nome tt-emit-b.cgc tt-emit-b.situacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-emit-b   
&Scoped-define SELF-NAME br-emit-b
&Scoped-define QUERY-STRING-br-emit-b FOR EACH tt-emit-b
&Scoped-define OPEN-QUERY-br-emit-b OPEN QUERY {&SELF-NAME} FOR EACH tt-emit-b.
&Scoped-define TABLES-IN-QUERY-br-emit-b tt-emit-b
&Scoped-define FIRST-TABLE-IN-QUERY-br-emit-b tt-emit-b


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-emit-a}~
    ~{&OPEN-QUERY-br-emit-b}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-8 RECT-9 fi-mat-grupo ~
Desc1 fi-mat-canal Desc2 br-emit-a br-emit-b btOK btCancel btHelp 
&Scoped-Define DISPLAYED-OBJECTS fi-mat-grupo Desc1 fi-mat-canal ~
Desc2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE Desc1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE Desc2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE fi-mat-canal AS CHARACTER FORMAT "X(256)":U 
     LABEL "Matriz Gr. Canais" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-mat-grupo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Matriz Gr. Econom." 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73 BY 11.25.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73.29 BY 11.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 147.57 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-emit-a FOR 
      tt-emit-a SCROLLING.

DEFINE QUERY br-emit-b FOR 
      tt-emit-b SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-emit-a
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-emit-a wWindow _FREEFORM
  QUERY br-emit-a DISPLAY
      tt-emit-a.cod-emitente  COLUMN-LABEL "C¢digo"      FORMAT ">>>>>>>9"   WIDTH 8
      tt-emit-a.nome          COLUMN-LABEL "Nome"        WIDTH 40
      tt-emit-a.cgc           COLUMN-LABEL "CGC"         WIDTH 16
      tt-emit-a.situacao      COLUMN-LABEL "Sit Cr‚dito"  WIDTH 16
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 71 BY 8.5
         FONT 1
         TITLE "Grupo Econ“mico" ROW-HEIGHT-CHARS .54 TOOLTIP "Grupo Econ“mico".

DEFINE BROWSE br-emit-b
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-emit-b wWindow _FREEFORM
  QUERY br-emit-b DISPLAY
      tt-emit-b.cod-emitente  COLUMN-LABEL "C¢digo"      FORMAT ">>>>>>>>9"   WIDTH 8
      tt-emit-b.nome          COLUMN-LABEL "Nome"        WIDTH 40
      tt-emit-b.cgc           COLUMN-LABEL "CGC"         WIDTH 16
      tt-emit-b.situacao      COLUMN-LABEL "Sit Cr‚dito"  WIDTH 16
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 71 BY 8.5
         FONT 1
         TITLE "Grupo Canais" ROW-HEIGHT-CHARS .54 TOOLTIP "Grupo Canais".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-mat-grupo AT ROW 2.25 COL 15.43 COLON-ALIGNED WIDGET-ID 26
     Desc1 AT ROW 2.25 COL 24.72 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     fi-mat-canal AT ROW 2.25 COL 90 COLON-ALIGNED WIDGET-ID 32
     Desc2 AT ROW 2.25 COL 99.29 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     br-emit-a AT ROW 3.75 COL 3 HELP
          "Estabelecimentos participantes do mesmo Grupo Econ“mico" WIDGET-ID 300
     br-emit-b AT ROW 3.75 COL 77.14 HELP
          "Estabelecimentos participantes do mesmo Grupo de Canais" WIDGET-ID 200
     btOK AT ROW 13 COL 2.29
     btCancel AT ROW 13 COL 13.43
     btHelp AT ROW 13 COL 138.29 WIDGET-ID 20
     rtToolBar AT ROW 12.79 COL 1.43
     RECT-8 AT ROW 1.33 COL 2.14 WIDGET-ID 22
     RECT-9 AT ROW 1.33 COL 76 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 148.72 BY 13.38
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
         HEIGHT             = 13.38
         WIDTH              = 151.43
         MAX-HEIGHT         = 17.83
         MAX-WIDTH          = 154.72
         VIRTUAL-HEIGHT     = 17.83
         VIRTUAL-WIDTH      = 154.72
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
/* BROWSE-TAB br-emit-a Desc2 fpage0 */
/* BROWSE-TAB br-emit-b br-emit-a fpage0 */
ASSIGN 
       br-emit-a:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = TRUE
       br-emit-a:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE
       br-emit-a:COLUMN-MOVABLE IN FRAME fpage0         = TRUE.

ASSIGN 
       br-emit-b:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = TRUE
       br-emit-b:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

ASSIGN 
       Desc1:READ-ONLY IN FRAME fpage0        = TRUE.

ASSIGN 
       Desc2:READ-ONLY IN FRAME fpage0        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-emit-a
/* Query rebuild information for BROWSE br-emit-a
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-emit-a
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-emit-a */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-emit-b
/* Query rebuild information for BROWSE br-emit-b
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-emit-b
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-emit-b */
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


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
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


&Scoped-define BROWSE-NAME br-emit-a
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDisplay wWindow 
PROCEDURE AfterDisplay :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
  RUN pi-cria-tt.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt wWindow 
PROCEDURE pi-cria-tt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    EMPTY TEMP-TABLE tt-emit-a.
    EMPTY TEMP-TABLE tt-emit-b.

    DEF VAR c-situacao AS CHAR FORMAT "X(30)" NO-UNDO.

    FIND emitente NO-LOCK
        WHERE emitente.nome-abrev = p-nome-matriz NO-ERROR.

    IF  AVAIL emitente THEN
        ASSIGN fi-mat-grupo:SCREEN-VALUE IN FRAME fpage0  = string(emitente.cod-emitente)
               Desc1:SCREEN-VALUE IN FRAME fpage0 = emitente.nome-emit.

    /* Carreta Grupo Canais */
    FOR EACH emitente NO-LOCK
        WHERE emitente.nome-matriz = p-nome-matriz:

        IF  emitente.identific = 2 THEN 
            NEXT.

        CASE emitente.ind-cre-cli:
            WHEN 1 THEN c-situacao = "Normal".
            WHEN 2 THEN c-situacao = "Autom tico".
            WHEN 3 THEN c-situacao = "S¢ Imp Ped".
            WHEN 4 THEN c-situacao = "Suspenso".
            WHEN 5 THEN c-situacao = "Pg … Vista".
        END CASE.

        CREATE tt-emit-a.
        ASSIGN tt-emit-a.cod-emitente = emitente.cod-emitente
               tt-emit-a.nome         = emitente.nome-emit
               tt-emit-a.cgc          = emitente.cgc
               tt-emit-a.situacao     = c-situacao.
    END.
             
    /* Carrega Grupo Econ“mico */
    FIND FIRST int-emitente-canal NO-LOCK
        WHERE int-emitente-canal.cod-emitente = p-cod-emitente NO-ERROR.

    IF AVAIL int-emitente-canal  THEN DO:
        FIND emitente NO-LOCK
            WHERE emitente.cod-emitente = int-emitente-canal.cod-emitente-matriz NO-ERROR.

        ASSIGN fi-mat-canal:SCREEN-VALUE IN FRAME fpage0  = string(emitente.cod-emitente)
               Desc2:SCREEN-VALUE IN FRAME fpage0 = emitente.nome-emit.

        FOR EACH int-emitente-canal NO-LOCK
             WHERE int-emitente-canal.cod-emitente-matriz = int(fi-mat-canal:SCREEN-VALUE IN FRAME fpage0)
             , FIRST int-emitente NO-LOCK
                 WHERE int-emitente.cod-emitente = int-emitente-canal.cod-emitente /*Filial*/
                   AND int-emitente.ind-participa-canais = 993520001
                   AND int-emitente.ind-apuracao-beneficio = 993520000 /*filial apura centralizada*/ 
              , FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = int-emitente.cod-emitente.
         
             IF AVAIL int-emitente THEN DO:

                 CASE emitente.ind-cre-cli:
                     WHEN 1 THEN c-situacao = "Normal".
                     WHEN 2 THEN c-situacao = "Autom tico".
                     WHEN 3 THEN c-situacao = "S¢ Imp Ped".
                     WHEN 4 THEN c-situacao = "Suspenso".
                     WHEN 5 THEN c-situacao = "Pg … Vista".
                 END CASE.

                 CREATE tt-emit-b.
                 ASSIGN tt-emit-b.cod-emitente = emitente.cod-emitente
                        tt-emit-b.nome         = emitente.nome-emit
                        tt-emit-b.cgc          = emitente.cgc
                        tt-emit-b.situacao     = c-situacao.
             END.
         END.
    END.



    {&open-query-br-emit-a}
    {&open-query-br-emit-b}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

