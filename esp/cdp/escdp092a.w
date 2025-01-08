&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i ESCDP092A 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP092A
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK btCancel

/* Parameters Definitions ---                                           */
DEFINE INPUT       PARAMETER pType           AS CHARACTER   NO-UNDO. /* Create or Update */
DEFINE INPUT       PARAMETER pmarketplace AS CHAR     NO-UNDO.
DEFINE INPUT       PARAMETER ploja        AS CHAR     NO-UNDO.
DEFINE INPUT-OUTPU PARAMETER pRow-table      AS ROWID       NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE r-rowid  AS ROWID       NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-1 RECT-5 c-marketplace ~
c-descricao c-loja c-forma-pagto i-cod-cond-pag c-portador c-cod-adm-cartao ~
c-cod-bandeira c-cod-carteira i-dias-venc tg-ind-fat-aut btOK btCancel 
&Scoped-Define DISPLAYED-OBJECTS c-marketplace c-descricao c-loja ~
c-forma-pagto i-cod-cond-pag c-portador c-cod-adm-cartao c-cod-bandeira ~
c-cod-carteira i-dias-venc tg-ind-fat-aut 

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

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-cod-adm-cartao AS CHARACTER FORMAT "x(5)" 
     LABEL "Administradora" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE c-cod-bandeira AS CHARACTER FORMAT "x(3)" 
     LABEL "Cod Bandeira" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-carteira AS CHARACTER FORMAT "x(3)" 
     LABEL "Carteira" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88.

DEFINE VARIABLE c-forma-pagto AS CHARACTER FORMAT "x(16)" 
     LABEL "Forma Pagto" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88.

DEFINE VARIABLE c-loja AS CHARACTER FORMAT "x(16)" 
     LABEL "Loja" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88.

DEFINE VARIABLE c-marketplace AS CHARACTER FORMAT "x(16)" 
     LABEL "Marketplace" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88.

DEFINE VARIABLE c-portador AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Portador" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE i-cod-cond-pag AS INTEGER FORMAT ">>>9" INITIAL 0 
     LABEL "Cond Pagto" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE i-dias-venc AS INTEGER FORMAT ">>>9" INITIAL 0 
     LABEL "Dias Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.08.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 8.92.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-ind-fat-aut AS LOGICAL INITIAL no 
     LABEL "Fatura Autom tico" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     c-marketplace AT ROW 1.25 COL 18 COLON-ALIGNED WIDGET-ID 2
     c-descricao AT ROW 1.25 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     c-loja AT ROW 2.25 COL 18 COLON-ALIGNED WIDGET-ID 4
     c-forma-pagto AT ROW 3.5 COL 18 COLON-ALIGNED WIDGET-ID 8
     i-cod-cond-pag AT ROW 4.5 COL 18 COLON-ALIGNED WIDGET-ID 10
     c-portador AT ROW 5.5 COL 18 COLON-ALIGNED WIDGET-ID 12
     c-cod-adm-cartao AT ROW 6.5 COL 18 COLON-ALIGNED WIDGET-ID 48
     c-cod-bandeira AT ROW 7.5 COL 18 COLON-ALIGNED WIDGET-ID 50
     c-cod-carteira AT ROW 8.5 COL 18 COLON-ALIGNED WIDGET-ID 52
     i-dias-venc AT ROW 9.5 COL 18 COLON-ALIGNED WIDGET-ID 54
     tg-ind-fat-aut AT ROW 10.5 COL 20 WIDGET-ID 16
     btOK AT ROW 12.71 COL 2
     btCancel AT ROW 12.75 COL 12.57
     rtToolBar AT ROW 12.5 COL 1
     RECT-1 AT ROW 1.17 COL 1.43 WIDGET-ID 26
     RECT-5 AT ROW 3.33 COL 1 WIDGET-ID 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 13.17
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
         TITLE              = "Inclui/Modifica Unidade de Neg¢cio x Tabela de Pre‡o"
         HEIGHT             = 13.17
         WIDTH              = 90
         MAX-HEIGHT         = 28.33
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 28.33
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
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Inclui/Modifica Unidade de Neg¢cio x Tabela de Pre‡o */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Inclui/Modifica Unidade de Neg¢cio x Tabela de Pre‡o */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fPage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fPage0 /* OK */
DO:
    RUN pi-salvar IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "OK" THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN c-marketplace = pmarketplace
           c-loja        = ploja.

    FIND FIRST int-pedido-param
         WHERE int-pedido-param.marketplace = c-marketplace NO-LOCK NO-ERROR.
    IF AVAIL int-pedido-param THEN DO:
        ASSIGN c-descricao = int-pedido-param.descricao.
    END.

    CASE pType:
        WHEN "Create":U THEN DO:
            
        END.
        WHEN "Update":U THEN DO:

            FIND FIRST int-pedido-param-pagto NO-LOCK
                WHERE  ROWID(int-pedido-param-pagto) = pRow-table NO-ERROR.
            IF  AVAIL  int-pedido-param THEN
                ASSIGN c-forma-pagto    = int-pedido-param-pagto.forma-pagto
                       i-cod-cond-pag   = int-pedido-param-pagto.cod-cond-pag
                       c-portador       = int-pedido-param-pagto.portador
                       c-cod-adm-cartao = int-pedido-param-pagto.cod-adm-cartao
                       c-cod-bandeira   = int-pedido-param-pagto.cod-bandeira
                       c-cod-carteira   = int-pedido-param-pagto.cod-carteira
                       i-dias-venc      = int-pedido-param-pagto.dias-venc
                       tg-ind-fat-aut   = int-pedido-param-pagto.ind-fat-aut.
        END.
        OTHERWISE .
    END CASE.

    ENABLE c-forma-pagto   
           i-cod-cond-pag
           c-portador      
           c-cod-adm-cartao
           c-cod-bandeira  
           c-cod-carteira  
           i-dias-venc
           tg-ind-fat-aut
        WITH FRAME fPage0.

    DISP c-marketplace
         c-loja
         c-descricao
         c-forma-pagto   
         i-cod-cond-pag
         c-portador      
         c-cod-adm-cartao
         c-cod-bandeira  
         c-cod-carteira  
         i-dias-venc
         tg-ind-fat-aut
        WITH FRAME fPage0.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salvar wWindow 
PROCEDURE pi-salvar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN INPUT FRAME fPage0 c-forma-pagto      
           INPUT FRAME fPage0 i-cod-cond-pag
           INPUT FRAME fPage0 c-portador         
           INPUT FRAME fPage0 c-cod-adm-cartao   
           INPUT FRAME fPage0 c-cod-bandeira     
           INPUT FRAME fPage0 c-cod-carteira     
           INPUT FRAME fPage0 i-dias-venc
           INPUT FRAME fPage0 tg-ind-fat-aut.        

    CASE pType:
        WHEN "Create":U OR
        WHEN "Copy":U   THEN DO:
            CREATE int-pedido-param-pagto.
            ASSIGN int-pedido-param-pagto.marketplace  = c-marketplace
                   int-pedido-param-pagto.loja         = c-loja.
        END.
        WHEN "Update":U THEN DO:
            FIND FIRST int-pedido-param-pagto EXCLUSIVE-LOCK
                WHERE  ROWID(int-pedido-param-pagto) = pRow-table NO-ERROR.
            IF  NOT AVAIL int-pedido-param-pagto THEN
                RETURN "NOK":U.
        END.
        OTHERWISE .
    END CASE.

    ASSIGN int-pedido-param-pagto.forma-pagto    = c-forma-pagto      
           int-pedido-param-pagto.cod-cond-pag   = i-cod-cond-pag
           int-pedido-param-pagto.portador       = c-portador         
           int-pedido-param-pagto.cod-adm-cartao = c-cod-adm-cartao   
           int-pedido-param-pagto.cod-bandeira   = c-cod-bandeira     
           int-pedido-param-pagto.cod-carteira   = c-cod-carteira     
           int-pedido-param-pagto.dias-venc      = i-dias-venc
           int-pedido-param-pagto.ind-fat-aut    = tg-ind-fat-aut
           r-rowid                               = ROWID(int-pedido-param-pagto).

    /* Retorna o Rowid do registro Criado/Alterado */
    ASSIGN pRow-table = ROWID(int-pedido-param-pagto).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

