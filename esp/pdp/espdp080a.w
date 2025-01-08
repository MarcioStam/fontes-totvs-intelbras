&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/* PCTCompile:: ems2cad */

/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESPDP080a 1.00.00.000}
{utp/ut-glob.i}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESPDP080a
&GLOBAL-DEFINE Version        1.00.00.000
&GLOBAL-DEFINE VersionLayout  001

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels 

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          NO
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          NO
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btexecutar      ~
                              br-reservas-ast ~
                              btHelp2         ~
                              btcancel        ~
                              bt-marcar       ~
                              bt-marcar-todos ~
                              bt-desmarcar    ~
                              bt-desmarcar-todos
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets  
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets  
&GLOBAL-DEFINE page5Widgets  
&GLOBAL-DEFINE page6Widgets  
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text     
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text     
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page5Fields
&GLOBAL-DEFINE page6Fields
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */
{esp/pdp/espdp080tt.i}

/* Transfer Definitions */

DEFINE VARIABLE h-espdp080 AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-reservas-ast

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-reservas-ast

/* Definitions for BROWSE br-reservas-ast                               */
&Scoped-define FIELDS-IN-QUERY-br-reservas-ast tt-reservas-ast.it-codigo tt-reservas-ast.desc-item tt-reservas-ast.cod-estabel tt-reservas-ast.cod-depos tt-reservas-ast.dt-reserva tt-reservas-ast.qt-reserva tt-reservas-ast.data-limite   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-reservas-ast   
&Scoped-define SELF-NAME br-reservas-ast
&Scoped-define QUERY-STRING-br-reservas-ast FOR EACH tt-reservas-ast NO-LOCK
&Scoped-define OPEN-QUERY-br-reservas-ast OPEN QUERY {&SELF-NAME} FOR EACH tt-reservas-ast NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-reservas-ast tt-reservas-ast
&Scoped-define FIRST-TABLE-IN-QUERY-br-reservas-ast tt-reservas-ast


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-reservas-ast}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-marcar btCancel btHelp2 btexecutar ~
bt-marcar-todos bt-desmarcar bt-desmarcar-todos rtToolBar RECT-19 ~
br-reservas-ast IMAGE-39 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnBuscaDescEstab wReport 
FUNCTION fnBuscaDescEstab RETURNS CHARACTER
  ( INPUT c-estabel AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnBuscaNrCaixa wReport 
FUNCTION fnBuscaNrCaixa RETURNS INTEGER
  ( INPUT c-estabel AS CHARACTER,
    INPUT c-item    AS CHARACTER,
    INPUT i-linha   AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem wReport 
FUNCTION fnDescItem RETURNS CHARACTER
  ( INPUT c-item AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-desmarcar 
     LABEL "Desmarcar" 
     SIZE 15 BY .88.

DEFINE BUTTON bt-desmarcar-todos 
     LABEL "Desmarcar todos" 
     SIZE 15 BY .88.

DEFINE BUTTON bt-marcar 
     LABEL "Marcar" 
     SIZE 15 BY .88.

DEFINE BUTTON bt-marcar-todos 
     LABEL "Marcar todos" 
     SIZE 15 BY .88.

DEFINE BUTTON btCancel 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btexecutar 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "" 
     SIZE 5 BY 1.25.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE IMAGE IMAGE-39
     FILENAME "adeicon/blank":U
     SIZE 9.14 BY 2.67.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 91 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 91 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-reservas-ast FOR 
      tt-reservas-ast SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-reservas-ast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-reservas-ast wReport _FREEFORM
  QUERY br-reservas-ast NO-LOCK DISPLAY
      tt-reservas-ast.it-codigo   COLUMN-LABEL "Item"
      tt-reservas-ast.desc-item   COLUMN-LABEL "Descri‡Æo" FORMAT "X(50)"
      tt-reservas-ast.cod-estabel COLUMN-LABEL "Estab"
      tt-reservas-ast.cod-depos   COLUMN-LABEL "Dep"
      tt-reservas-ast.dt-reserva  COLUMN-LABEL "Dt.Reserva"
      tt-reservas-ast.qt-reserva  COLUMN-LABEL "Qtde."
      tt-reservas-ast.data-limite COLUMN-LABEL "Dt.Limite"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 91 BY 12.17
         FONT 1 ROW-HEIGHT-CHARS .56 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-marcar AT ROW 15.21 COL 2 WIDGET-ID 66
     btCancel AT ROW 16.63 COL 5.43
     btHelp2 AT ROW 16.63 COL 80
     btexecutar AT ROW 1.25 COL 5.43 WIDGET-ID 62
     bt-marcar-todos AT ROW 15.21 COL 17.14 WIDGET-ID 68
     bt-desmarcar AT ROW 15.21 COL 32.29 WIDGET-ID 70
     bt-desmarcar-todos AT ROW 15.21 COL 47.43 WIDGET-ID 72
     br-reservas-ast AT ROW 3 COL 2 WIDGET-ID 200
     rtToolBar AT ROW 16.42 COL 2
     RECT-19 AT ROW 1.13 COL 2 WIDGET-ID 56
     IMAGE-39 AT ROW 4.75 COL 32 WIDGET-ID 64
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 93.14 BY 17.13
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
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = "Eliminar reservas"
         HEIGHT             = 17.42
         WIDTH              = 93.14
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.14
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{report/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME Custom                                        */
/* BROWSE-TAB br-reservas-ast RECT-19 fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-reservas-ast
/* Query rebuild information for BROWSE br-reservas-ast
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-reservas-ast NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE br-reservas-ast */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport /* Eliminar reservas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport /* Eliminar reservas */
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-reservas-ast
&Scoped-define SELF-NAME br-reservas-ast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-reservas-ast wReport
ON ROW-DISPLAY OF br-reservas-ast IN FRAME fpage0
DO:
    IF tt-reservas-ast.lselecionado THEN
        ASSIGN tt-reservas-ast.it-codigo  :BGCOLOR IN BROWSE br-reservas-ast = 11
               tt-reservas-ast.desc-item  :BGCOLOR IN BROWSE br-reservas-ast = 11
               tt-reservas-ast.cod-estabel:BGCOLOR IN BROWSE br-reservas-ast = 11
               tt-reservas-ast.cod-depos  :BGCOLOR IN BROWSE br-reservas-ast = 11
               tt-reservas-ast.dt-reserva :BGCOLOR IN BROWSE br-reservas-ast = 11
               tt-reservas-ast.qt-reserva :BGCOLOR IN BROWSE br-reservas-ast = 11
               tt-reservas-ast.data-limite:BGCOLOR IN BROWSE br-reservas-ast = 11.
    ELSE
        ASSIGN tt-reservas-ast.it-codigo  :BGCOLOR IN BROWSE br-reservas-ast = 15
               tt-reservas-ast.desc-item  :BGCOLOR IN BROWSE br-reservas-ast = 15
               tt-reservas-ast.cod-estabel:BGCOLOR IN BROWSE br-reservas-ast = 15
               tt-reservas-ast.cod-depos  :BGCOLOR IN BROWSE br-reservas-ast = 15
               tt-reservas-ast.dt-reserva :BGCOLOR IN BROWSE br-reservas-ast = 15
               tt-reservas-ast.qt-reserva :BGCOLOR IN BROWSE br-reservas-ast = 15
               tt-reservas-ast.data-limite:BGCOLOR IN BROWSE br-reservas-ast = 15.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desmarcar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desmarcar wReport
ON CHOOSE OF bt-desmarcar IN FRAME fpage0 /* Desmarcar */
DO:
    IF AVAIL tt-reservas-ast THEN
        ASSIGN tt-reservas-ast.lselecionado = NO.
    {&OPEN-QUERY-BR-RESERVAS-AST}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desmarcar-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desmarcar-todos wReport
ON CHOOSE OF bt-desmarcar-todos IN FRAME fpage0 /* Desmarcar todos */
DO:
    FOR EACH tt-reservas-ast:
        ASSIGN tt-reservas-ast.lselecionado = NO.
    END.
    {&OPEN-QUERY-BR-RESERVAS-AST}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marcar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marcar wReport
ON CHOOSE OF bt-marcar IN FRAME fpage0 /* Marcar */
DO:
    IF AVAIL tt-reservas-ast THEN
        ASSIGN tt-reservas-ast.lselecionado = YES.
    {&OPEN-QUERY-BR-RESERVAS-AST}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marcar-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marcar-todos wReport
ON CHOOSE OF bt-marcar-todos IN FRAME fpage0 /* Marcar todos */
DO:
    FOR EACH tt-reservas-ast:
        ASSIGN tt-reservas-ast.lselecionado = YES.
    END.
    {&OPEN-QUERY-BR-RESERVAS-AST}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btexecutar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btexecutar wReport
ON CHOOSE OF btexecutar IN FRAME fpage0
DO:
    IF NOT CAN-FIND(FIRST tt-reservas-ast
                    WHERE tt-reservas-ast.lselecionado) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Elimina‡Æo inv lida~~NÆo foi selecionado nenhuma reserva para eliminar.").
    END.
    ELSE
        RUN piEliminaReservas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wReport
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
   
{report/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN piBuscaReservas.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wReport 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaReservas wReport 
PROCEDURE piBuscaReservas :
/*------------------------------------------------------------------------------
  Purpose: Busca reservas do usu rio logado    
  Notes: Carlos Daniel - 06/07/2016
------------------------------------------------------------------------------*/
RUN esp/pdp/espdp080api.p PERSISTENT SET h-espdp080.

RUN piBuscaReservas IN h-espdp080 (OUTPUT TABLE tt-reservas-ast).

IF VALID-HANDLE(h-espdp080) THEN
    DELETE PROCEDURE h-espdp080.

{&OPEN-QUERY-br-reservas-ast}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEliminaReservas wReport 
PROCEDURE piEliminaReservas :
/*------------------------------------------------------------------------------
  Purpose: Chama proc para eliminar reservas selecionadas
  Notes:   Carlos Daniel - 06/07/2016
------------------------------------------------------------------------------*/
DEFINE VARIABLE lerro AS LOGICAL NO-UNDO.

RUN utp/ut-msgs.p (INPUT "SHOW",
                   INPUT 27100,
                   INPUT "Confirma‡Æo~~Deseja eliminar a(s) reserva(s) selecionada(s)?.").

IF RETURN-VALUE <> "YES" THEN
    RETURN.

RUN esp/pdp/espdp080api.p PERSISTENT SET h-espdp080.

RUN piEliminaReservas IN h-espdp080 (INPUT TABLE tt-reservas-ast,
                                     OUTPUT lerro).

IF VALID-HANDLE(h-espdp080) THEN
    DELETE PROCEDURE h-espdp080.

IF lerro THEN
    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 17006,
                       INPUT "Erro~~Erro ao tentar eliminar as reservas selecionadas.").
ELSE DO:
    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 15825,
                       INPUT "Confirma‡Æo~~Reserva(s) eliminada(s) com sucesso.").
    RUN piBuscaReservas.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnBuscaDescEstab wReport 
FUNCTION fnBuscaDescEstab RETURNS CHARACTER
  ( INPUT c-estabel AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Busca descri‡Æo do estabelecimento na biblioteca lib_procedure e 
           coloca no campo desc-estab do frame fPage3 
    Notes: Carlos Daniel 01/07/2014 - Chamado 924 
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-lib      AS HANDLE    NO-UNDO.
    DEFINE VARIABLE desc-estab AS CHARACTER NO-UNDO.

    RUN lib_procedure.p PERSISTENT SET h-lib.

    RUN piRetornaDescEstab IN h-lib(INPUT  c-estabel,
                                    OUTPUT desc-estab).

    IF VALID-HANDLE(h-lib) THEN
        DELETE PROCEDURE h-lib.

    RETURN desc-estab.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnBuscaNrCaixa wReport 
FUNCTION fnBuscaNrCaixa RETURNS INTEGER
  ( INPUT c-estabel AS CHARACTER,
    INPUT c-item    AS CHARACTER,
    INPUT i-linha   AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Busca n£mero de caixas do item 
    Notes: Carlos Daniel 03/07/2014 - Chamado 924 
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-bocpp003 AS HANDLE  NO-UNDO.
    DEFINE VARIABLE i-nrCaixa  AS INTEGER NO-UNDO.

    RUN cppbo/bocpp003.p PERSISTENT SET h-bocpp003.

    RUN pi-RetornaNrCaixas IN h-bocpp003(INPUT c-estabel,
                                         INPUT c-item,
                                         INPUT i-linha,
                                         OUTPUT i-nrCaixa).

    IF VALID-HANDLE(h-bocpp003) THEN
        DELETE PROCEDURE h-bocpp003.

    RETURN i-nrCaixa.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem wReport 
FUNCTION fnDescItem RETURNS CHARACTER
  ( INPUT c-item AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Retorna descri‡Æo do Item 
    Notes: Carlos Daniel 27/06/2014 - Chamado 924 
------------------------------------------------------------------------------*/
  FOR FIRST item FIELDS(desc-item)
      WHERE item.it-codigo = c-item NO-LOCK:
  
      RETURN item.desc-item. 
  END.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

