&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-matriz-rat-ordem NO-UNDO LIKE matriz-rat-ordem
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-ordem-compra NO-UNDO LIKE ordem-compra
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i cc0300logmr1 2.00.00.001}  /*** 010001 ***/
/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          cc0300logmr1
&GLOBAL-DEFINE Version          2.00.00.001

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       O

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-matriz-rat-ordem
&GLOBAL-DEFINE hDBOTable         h-boin691
&GLOBAL-DEFINE DBOTable          matriz-rat-ordem

&GLOBAL-DEFINE ttParent          tt-ordem-compra
&GLOBAL-DEFINE hDBOParent        h-boin274
&GLOBAL-DEFINE DBOParentTable    ordem-compra

&GLOBAL-DEFINE page0KeyFields    tt-matriz-rat-ordem.numero-ordem ~
                                 tt-matriz-rat-ordem.sc-codigo ~
                                 tt-matriz-rat-ordem.ct-codigo ~
                                 tt-matriz-rat-ordem.conta-contabil 

&GLOBAL-DEFINE page0Fields       tt-matriz-rat-ordem.perc-rateio ~
                                 c-narrativa
                                 

&GLOBAL-DEFINE page0ParentFields 


/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOParent}  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin641na    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad246na    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad047na    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad049na    AS HANDLE NO-UNDO.


DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

DEF VAR i-seq-erro       as INT     NO-UNDO.
DEF VAR c-descricao      AS CHAR    NO-UNDO.
def var c-centro-custo   as CHAR    no-undo.
def var i-empres-usuar   as int     no-undo.
DEF VAR c-param          AS CHAR    NO-UNDO.
def var l-CtCodigo       as log     no-undo.
def var l-SCCodigo       as log     no-undo.
def var l-CodUtiliz      as log     no-undo.
def var l-classif        as log     no-undo.
DEF VAR l-valida-perc    AS LOG     NO-UNDO.
DEF VAR l-bt-incluir     AS LOG     NO-UNDO.
def var i-nat-desp       as int     no-undo.
def new Global shared var c-seg-usuario  as char format "x(12)" no-undo.
def new global shared var v_cdn_empres_usuar   like mgcad.empresa.ep-codigo        no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-matriz-rat-ordem.numero-ordem ~
tt-matriz-rat-ordem.sc-codigo tt-matriz-rat-ordem.ct-codigo ~
tt-matriz-rat-ordem.conta-contabil tt-matriz-rat-ordem.perc-rateio 
&Scoped-define ENABLED-TABLES tt-matriz-rat-ordem
&Scoped-define FIRST-ENABLED-TABLE tt-matriz-rat-ordem
&Scoped-Define ENABLED-OBJECTS c-desc-ct-codigo c-desc-conta-contabil ~
c-narrativa btOK btSave btCancel btHelp RECT-01 RECT-02 rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-matriz-rat-ordem.numero-ordem ~
tt-matriz-rat-ordem.sc-codigo tt-matriz-rat-ordem.ct-codigo ~
tt-matriz-rat-ordem.conta-contabil tt-matriz-rat-ordem.perc-rateio 
&Scoped-define DISPLAYED-TABLES tt-matriz-rat-ordem
&Scoped-define FIRST-DISPLAYED-TABLE tt-matriz-rat-ordem
&Scoped-Define DISPLAYED-OBJECTS c-desc-sc-codigo c-desc-ct-codigo ~
c-desc-conta-contabil c-narrativa 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

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

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-narrativa AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 50 BY 4 TOOLTIP "Narrativa" NO-UNDO.

DEFINE VARIABLE c-desc-conta-contabil AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .79 NO-UNDO.

DEFINE VARIABLE c-desc-ct-codigo AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .79 NO-UNDO.

DEFINE VARIABLE c-desc-sc-codigo AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-01
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90.14 BY 4.25.

DEFINE RECTANGLE RECT-02
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90.14 BY 5.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-matriz-rat-ordem.numero-ordem AT ROW 1.25 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .79
     tt-matriz-rat-ordem.sc-codigo AT ROW 2.25 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .79
     c-desc-sc-codigo AT ROW 2.25 COL 42 COLON-ALIGNED NO-LABEL
     tt-matriz-rat-ordem.ct-codigo AT ROW 3.25 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .79
     c-desc-ct-codigo AT ROW 3.25 COL 42 COLON-ALIGNED NO-LABEL
     tt-matriz-rat-ordem.conta-contabil AT ROW 4.25 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.57 BY .79
     c-desc-conta-contabil AT ROW 4.25 COL 51 COLON-ALIGNED NO-LABEL
     tt-matriz-rat-ordem.perc-rateio AT ROW 5.5 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .88
    "Narrativa:" VIEW-AS TEXT
         SIZE 8 BY .88 AT ROW 6.5 COL 34 RIGHT-ALIGNED
     c-narrativa AT ROW 6.5 COL 34 NO-LABEL
     btOK AT ROW 11.25 COL 2
     btSave AT ROW 11.25 COL 13
     btCancel AT ROW 11.25 COL 24
     btHelp AT ROW 11.25 COL 80
     RECT-01 AT ROW 1 COL 1
     RECT-02 AT ROW 5.25 COL 1
     rtToolBar AT ROW 11 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 11.67
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-matriz-rat-ordem T "?" NO-UNDO movind matriz-rat-ordem
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-ordem-compra T "?" NO-UNDO movind ordem-compra
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 11.79
         WIDTH              = 90.14
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN c-desc-sc-codigo IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR TEXT-LITERAL "Narrativa:"
          SIZE 8 BY .88 AT ROW 6.5 COL 33 RIGHT-ALIGNED                 */

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

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

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO: 
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO: 
    RUN piValida IN THIS-PROCEDURE.

    RUN getRowErrors IN {&hDBOTable} (OUTPUT TABLE RowErrors).
    FIND FIRST RowErrors NO-ERROR.
    IF AVAIL RowErrors THEN DO:
        {method/ShowMessage.i1}
        {method/ShowMessage.i2}
        return no-apply.
    END.
    ELSE ASSIGN c-narrativa:SCREEN-VALUE IN FRAME fpage0 = "".

    RUN saveRecord IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "OK":U THEN DO:
        RUN afterDisplayFields IN phCaller.
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN piValida IN THIS-PROCEDURE.

    RUN getRowErrors IN {&hDBOTable} (OUTPUT TABLE RowErrors).
    FIND FIRST RowErrors NO-ERROR.
    IF AVAIL RowErrors THEN DO:
        {method/ShowMessage.i1}
        {method/ShowMessage.i2}
        return no-apply.
    END.
    ELSE ASSIGN c-narrativa:SCREEN-VALUE IN FRAME fpage0 = "".

    RUN saveRecord IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "OK":U THEN DO:
        RUN afterDisplayFields IN phCaller.

        APPLY "ENTRY":U TO tt-matriz-rat-ordem.sc-codigo.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-matriz-rat-ordem.conta-contabil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-matriz-rat-ordem.conta-contabil wMaintenanceNoNavigation
ON F5 OF tt-matriz-rat-ordem.conta-contabil IN FRAME fpage0 /* Conta Cont bil */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad049.w"
                       &campo="tt-matriz-rat-ordem.conta-contabil"
                       &campozoom="conta-contabil"
                       &campo2="c-desc-conta-contabil"
                       &campozoom2="titulo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-matriz-rat-ordem.conta-contabil wMaintenanceNoNavigation
ON LEAVE OF tt-matriz-rat-ordem.conta-contabil IN FRAME fpage0 /* Conta Cont bil */
DO:
    RUN piDescCContabil IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-matriz-rat-ordem.conta-contabil wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-matriz-rat-ordem.conta-contabil IN FRAME fpage0 /* Conta Cont bil */
DO:
   apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-matriz-rat-ordem.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-matriz-rat-ordem.ct-codigo wMaintenanceNoNavigation
ON F5 OF tt-matriz-rat-ordem.ct-codigo IN FRAME fpage0 /* Conta */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad047.w"
                       &campo="tt-matriz-rat-ordem.ct-codigo"
                       &campozoom="ct-codigo"
                       &campo2="c-desc-ct-codigo"
                       &campozoom2="titulo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-matriz-rat-ordem.ct-codigo wMaintenanceNoNavigation
ON LEAVE OF tt-matriz-rat-ordem.ct-codigo IN FRAME fpage0 /* Conta */
DO:
    RUN piDescConta IN THIS-PROCEDURE.
    ASSIGN tt-matriz-rat-ordem.conta-contabil:SCREEN-VALUE IN FRAME fpage0 = tt-matriz-rat-ordem.ct-codigo:SCREEN-VALUE IN FRAME fpage0 + 
                                                                             tt-matriz-rat-ordem.sc-codigo:SCREEN-VALUE IN FRAME fpage0.
    RUN piDescCContabil IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-matriz-rat-ordem.ct-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-matriz-rat-ordem.ct-codigo IN FRAME fpage0 /* Conta */
DO:
   apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-matriz-rat-ordem.sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-matriz-rat-ordem.sc-codigo wMaintenanceNoNavigation
ON F5 OF tt-matriz-rat-ordem.sc-codigo IN FRAME fpage0 /* Sub-Conta */
DO:
    /* O zoom de sub conta nÆo est  retornando a descri‡Æo. Tem que alterar o zoom na procedure pi-retorna-valor. */
    {include/zoomvar.i &prog-zoom="adzoom/z01ad246.w"
                       &campo="tt-matriz-rat-ordem.sc-codigo"
                       &campozoom="sc-codigo"
                       &campo2="c-desc-sc-codigo"
                       &campozoom2="descricao"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-matriz-rat-ordem.sc-codigo wMaintenanceNoNavigation
ON LEAVE OF tt-matriz-rat-ordem.sc-codigo IN FRAME fpage0 /* Sub-Conta */
DO:
    RUN piDescCCusto IN THIS-PROCEDURE.
    ASSIGN tt-matriz-rat-ordem.conta-contabil:SCREEN-VALUE IN FRAME fpage0 = tt-matriz-rat-ordem.ct-codigo:SCREEN-VALUE IN FRAME fpage0 + 
                                                                             tt-matriz-rat-ordem.sc-codigo:SCREEN-VALUE IN FRAME fpage0.
    RUN piDescCContabil IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-matriz-rat-ordem.sc-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-matriz-rat-ordem.sc-codigo IN FRAME fpage0 /* Sub-Conta */
DO:
   apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/MainBlock.i}

if tt-matriz-rat-ordem.sc-codigo:load-mouse-pointer ("image/lupa.cur") then.
if tt-matriz-rat-ordem.ct-codigo:load-mouse-pointer ("image/lupa.cur") then.
if tt-matriz-rat-ordem.conta-contabil:load-mouse-pointer ("image/lupa.cur") then.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE AfterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {method/ShowMessage.i3}

    IF VALID-HANDLE(h-boin641na) THEN DO: 
        DELETE PROCEDURE h-boin641na.
        ASSIGN h-boin641na = ?.
    END.

    IF VALID-HANDLE(h-boad047na) THEN DO: 
        DELETE PROCEDURE h-boad047na.
        ASSIGN h-boad047na = ?.
    END.

    IF VALID-HANDLE(h-boad049na) THEN DO: 
        DELETE PROCEDURE h-boad049na.
        ASSIGN h-boad049na = ?.
    END.

    IF VALID-HANDLE(h-boad246na) THEN DO: 
        DELETE PROCEDURE h-boad246na.
        ASSIGN h-boad246na = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterdisplayFields wMaintenanceNoNavigation 
PROCEDURE afterdisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN piHabilitaCampos IN {&hDBOTable} (INPUT tt-ordem-compra.r-rowid,
                                          INPUT c-seg-usuario,
                                          OUTPUT l-CtCodigo,
                                          OUTPUT l-SCCodigo,
                                          OUTPUT l-CodUtiliz,
                                          OUTPUT l-classif,
                                          OUTPUT i-nat-desp,
                                          OUTPUT c-centro-custo).

    /* Para a Log¡stica estou colocando como defaul as vari veis para YES para habilitar sempre */
    ASSIGN l-classif  = YES.

    CASE pcAction:
        WHEN "Add":U THEN DO:
/*            IF l-classif THEN
                ASSIGN l-CTCodigo = YES.
            ELSE
                ASSIGN l-CTCodigo  = NO. */

            ASSIGN l-CTCodigo = YES
                   l-SCCodigo = YES
                   tt-matriz-rat-ordem.ct-codigo:SCREEN-VALUE IN FRAME fpage0 = tt-ordem-compra.ct-codigo
                   tt-matriz-rat-ordem.sc-codigo:SCREEN-VALUE IN FRAME fpage0 = c-centro-custo
                   tt-matriz-rat-ordem.numero-ordem:SCREEN-VALUE IN FRAME fpage0 = string(tt-ordem-compra.numero-ordem).
        END.
        WHEN "Update":U THEN DO:
            ASSIGN c-narrativa:SCREEN-VALUE IN FRAME fpage0 = tt-matriz-rat-ordem.char-1
                   l-CtCodigo  = NO
                   l-SCCodigo  = NO.

            RUN piDescConta  IN THIS-PROCEDURE.
            RUN piDescCContabil IN THIS-PROCEDURE.
        END.
    END CASE.
    RUN piDescCCusto IN THIS-PROCEDURE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF pcAction <> "Update":U THEN DO:
        DO WITH FRAME fPage0:
            IF l-CtCodigo  = NO THEN DISABLE tt-matriz-rat-ordem.ct-codigo.
            IF l-SCCodigo  = NO THEN DISABLE tt-matriz-rat-ordem.sc-codigo.
            DISABLE tt-matriz-rat-ordem.numero-ordem.
            DISABLE tt-matriz-rat-ordem.conta-contabil.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN c-param = pcAction.

    CASE pcAction:
        WHEN "Copy" THEN DO:
            ASSIGN c-param = "cop".
        END.
        WHEN "Update" THEN DO:
            ASSIGN c-param = "mod".
        END.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    /*--- Verifica se o DBO j  est  inicializado ---*/
    /* Utiliza‡Æo */
    IF NOT VALID-HANDLE(h-boin641na) THEN DO:
        RUN inbo/boin641na.p PERSISTENT SET h-boin641na.
    END.
    RUN openQueryStatic IN h-boin641na (INPUT "Main":u).

    /* Conta */
    IF NOT VALID-HANDLE(h-boad047na) THEN DO:
        RUN adbo/boad047na.p PERSISTENT SET h-boad047na.
    END.
    RUN openQueryStatic IN h-boad047na (INPUT "Main":u).

    /* Conta Cont bil */
    IF NOT VALID-HANDLE(h-boad049na) THEN DO:
        RUN adbo/boad049na.p PERSISTENT SET h-boad049na.
    END.
    RUN openQueryStatic IN h-boad049na (INPUT "Main":u).

    /* Centro de Custo*/
    IF NOT VALID-HANDLE(h-boad246na) THEN DO:
        RUN adbo/boad246na.p PERSISTENT SET h-boad246na.
    END.
    RUN openQueryStatic IN h-boad246na (INPUT "Main":u).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDescCContabil wMaintenanceNoNavigation 
PROCEDURE piDescCContabil :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    RUN goToChContaContabil IN h-boad049na (INPUT v_cdn_empres_usuar, INPUT tt-matriz-rat-ordem.conta-contabil:SCREEN-VALUE IN FRAME fpage0).
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getCharField IN h-boad049na (INPUT "titulo":U, OUTPUT c-descricao).
        ASSIGN c-desc-conta-contabil:SCREEN-VALUE IN FRAME fpage0 = c-descricao.
    END.
    ELSE ASSIGN c-desc-conta-contabil:SCREEN-VALUE IN FRAME fpage0 = "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDescCCusto wMaintenanceNoNavigation 
PROCEDURE piDescCCusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    RUN gotoKey IN h-boad246na (INPUT tt-matriz-rat-ordem.sc-codigo:SCREEN-VALUE IN FRAME fpage0).
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getCharField IN h-boad246na (INPUT "descricao":U, OUTPUT c-descricao).
        ASSIGN c-desc-sc-codigo:SCREEN-VALUE IN FRAME fpage0 = c-descricao.
    END.
    ELSE ASSIGN c-desc-sc-codigo:SCREEN-VALUE IN FRAME fpage0 = "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDescConta wMaintenanceNoNavigation 
PROCEDURE piDescConta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    RUN gotoKey IN h-boad047na (INPUT tt-matriz-rat-ordem.ct-codigo:SCREEN-VALUE IN FRAME fpage0).
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getCharField IN h-boad047na (INPUT "titulo":U, OUTPUT c-descricao).
        ASSIGN c-desc-ct-codigo:SCREEN-VALUE IN FRAME fpage0 = c-descricao.
    END.
    ELSE ASSIGN c-desc-ct-codigo:SCREEN-VALUE IN FRAME fpage0 = "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValida wMaintenanceNoNavigation 
PROCEDURE piValida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    RUN emptyRowErrors IN {&hDBOTable}.

    RUN saveFields IN THIS-PROCEDURE.

    ASSIGN tt-matriz-rat-ordem.char-1 = c-narrativa.

    RUN setRecord IN {&hDBOTable} (INPUT TABLE tt-matriz-rat-ordem).
    RUN validateMatrizRateio IN {&hDBOTable} (INPUT c-param,
                                              INPUT "",
                                              INPUT tt-ordem-compra.cod-estabel,
                                              INPUT c-seg-usuario,
                                              INPUT i-nat-desp,
                                              INPUT l-classif,
                                              INPUT l-SCCodigo).

    RUN getRecord IN {&hDBOTable} (OUTPUT TABLE tt-matriz-rat-ordem).
    FIND FIRST tt-matriz-rat-ordem NO-ERROR.
    
    ASSIGN tt-matriz-rat-ordem.ct-codigo:SCREEN-VALUE IN FRAME fpage0 = tt-matriz-rat-ordem.ct-codigo
           tt-matriz-rat-ordem.conta-contabil:SCREEN-VALUE IN FRAME fpage0 = tt-matriz-rat-ordem.conta-contabil.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    if pcAction = "ADD" or
       pcAction = "COPY" then
       assign {&ttTable}.numero-ordem = {&ttParent}.numero-ordem.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

