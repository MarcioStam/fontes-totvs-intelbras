&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttcli-difer NO-UNDO LIKE cli-difer
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esftp0993a 2.06.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esftp093a
&GLOBAL-DEFINE Version        2.06.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btHelp2 btOK
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

&GLOBAL-DEFINE ExcludeBtQueryJoins      YES
&GLOBAL-DEFINE ExcludeBtReportsJoins    YES

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER pcod-emitente AS INTEGER NO-UNDO.

/* Local Variable Definitions ---                                       */
DEF VAR ccc AS CHAR no-undo.
DEF VAR iii AS CHAR no-undo.
{upc/btb910za-upc.i}
IF NOT VALID-HANDLE (h_api_ccusto) THEN
    run prgint/utb/utb742za.py persistent set h_api_ccusto.

{esp/es0018.i}

DEF TEMP-TABLE tt-prog-ponto-tmp
   FIELD nome-programa    LIKE ponto-programa.nome-programa
   FIELD ponto            LIKE ponto-programa.ponto
   FIELD sequencia        LIKE conteudo-programa.sequencia 
   FIELD conteudo         LIKE conteudo-programa.conteudo
   INDEX seq-campo nome-programa ponto sequencia.

DEFINE BUFFER b-ponto-programa FOR ponto-programa.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttcli-difer.descricao 
&Scoped-define ENABLED-TABLES ttcli-difer
&Scoped-define FIRST-ENABLED-TABLE ttcli-difer
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys RECT-43 cDescCliente ~
cNome-emitente cCentroCusto btOK btHelp2 
&Scoped-Define DISPLAYED-FIELDS ttcli-difer.cod-emitente ~
ttcli-difer.cc-codigo ttcli-difer.descricao 
&Scoped-define DISPLAYED-TABLES ttcli-difer
&Scoped-define FIRST-DISPLAYED-TABLE ttcli-difer
&Scoped-Define DISPLAYED-OBJECTS cDescCliente cNome-emitente cCentroCusto 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE cCentroCusto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE cDescCliente AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE cNome-emitente AS CHARACTER FORMAT "x(40)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 5.42.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 82 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttcli-difer.cod-emitente AT ROW 1.25 COL 12 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     cDescCliente AT ROW 1.25 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     cNome-emitente AT ROW 1.25 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     ttcli-difer.cc-codigo AT ROW 2.25 COL 12 COLON-ALIGNED WIDGET-ID 6
          LABEL "Centro de Custo"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     cCentroCusto AT ROW 2.25 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     ttcli-difer.descricao AT ROW 4.25 COL 13 NO-LABEL WIDGET-ID 2
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 67 BY 3.75
     btOK AT ROW 9.17 COL 1.72
     btHelp2 AT ROW 9.17 COL 72.43
     "Descri‡Æo" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 5.92 COL 5 WIDGET-ID 4
     rtToolBar AT ROW 8.96 COL 1
     rtKeys AT ROW 1 COL 1 WIDGET-ID 16
     RECT-43 AT ROW 3.5 COL 1 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 82.43 BY 9.54
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttcli-difer T "?" NO-UNDO mgesp cli-difer
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
         HEIGHT             = 9.58
         WIDTH              = 82.43
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 102.43
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 102.43
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
/* SETTINGS FOR FILL-IN ttcli-difer.cc-codigo IN FRAME fpage0
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN ttcli-difer.cod-emitente IN FRAME fpage0
   NO-ENABLE                                                            */
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


&Scoped-define SELF-NAME ttcli-difer.cc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcli-difer.cc-codigo wWindow
ON LEAVE OF ttcli-difer.cc-codigo IN FRAME fpage0 /* Centro de Custo */
DO:
    ASSIGN ccc = ttcli-difer.cc-codigo:SCREEN-VALUE IN FRAME fpage0
           iii = SUBSTRING(ccc,5).

    IF  iii = "" 
    THEN ASSIGN ttcli-difer.cc-codigo:SCREEN-VALUE IN FRAME fpage0 = "00000"
                cCentroCusto:SCREEN-VALUE IN FRAME fPage0 = "".
    ELSE DO:
        run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                                   input  "",                  /* CODIGO DO PLANO CCUSTO */
                                                   input  ttcli-difer.cc-codigo:SCREEN-VALUE IN FRAME fPage0,   /* CCUSTO */
                                                   input  today,               /* DATA DE TRANSACAO */
                                                   output v_des_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro).  /* ERROS */
        IF NOT CAN-FIND (FIRST tt_log_erro) THEN
            ASSIGN cCentroCusto:SCREEN-VALUE IN FRAME fPage0 = v_des_titulo_ccusto.
        ELSE 
            ASSIGN cCentroCusto:SCREEN-VALUE IN FRAME fPage0 = "".
    END. /* ELSE DO: */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcli-difer.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcli-difer.cod-emitente wWindow
ON LEAVE OF ttcli-difer.cod-emitente IN FRAME fpage0 /* Cliente */
DO:

    FIND FIRST emitente NO-LOCK 
        WHERE  emitente.cod-emitente = INT(ttcli-difer.cod-emitente:SCREEN-VALUE IN FRAME fpage0) NO-ERROR.    
    IF  AVAIL emitente 
    THEN ASSIGN cDescCliente:SCREEN-VALUE   IN FRAME fPage0 = emitente.nome-abrev
                cNome-emitente:SCREEN-VALUE IN FRAME fPage0 = emitente.nome-emit.
    ELSE ASSIGN cDescCliente:SCREEN-VALUE   IN FRAME fPage0 = ""
                cNome-emitente:SCREEN-VALUE IN FRAME fPage0 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    RUN piCarregarTela IN THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregarTela wWindow 
PROCEDURE piCarregarTela :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    FOR EACH  b-ponto-programa NO-LOCK 
        WHERE b-ponto-programa.nome-programa = "esftp010":
        RUN esp\es0018p.p (INPUT b-ponto-programa.nome-programa,
                           INPUT b-ponto-programa.ponto,
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.
        FOR EACH tt-prog-ponto:
            CREATE tt-prog-ponto-tmp.
            BUFFER-COPY tt-prog-ponto TO tt-prog-ponto-tmp.
        END. /* FOR EACH tt-prog-ponto: */
    END. /* FOR EACH  b-ponto-programa NO-LOCK */


    bl-difer:
    FOR EACH cli-difer NO-LOCK
        WHERE cli-difer.cod-emitente = pcod-emitente
        AND   cli-difer.tipo         = FALSE /* Expedi‡Æo */:

        IF CAN-FIND(FIRST tt-prog-ponto-tmp 
                    WHERE tt-prog-ponto-tmp.conteudo = cli-difer.cc-codigo 
                    AND   tt-prog-ponto-tmp.ponto = 4) THEN DO:
            
            ASSIGN ttcli-difer.cod-emitente:screen-value in frame fPage0 = string(pcod-emitente)
                   ttcli-difer.cc-codigo   :screen-value in frame fPage0 = string(cli-difer.cc-codigo)
                   ttcli-difer.descricao   :screen-value in frame fPage0 = cli-difer.descricao.
    
            APPLY "LEAVE":U TO ttcli-difer.cod-emitente IN FRAME fPage0.
            APPLY "LEAVE":U TO ttcli-difer.cc-codigo    IN FRAME fPage0.

            LEAVE bl-difer.

        END.

    END. /* FOR FIRST cli-difer NO-LOCK */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

