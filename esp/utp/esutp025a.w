&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-acordo-contrato NO-UNDO LIKE acordo-contrato
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-acordo-tipo NO-UNDO LIKE acordo-tipo
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESUTP025B 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESUTP025A
&GLOBAL-DEFINE Version           2.04.00.001

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Contrato

&GLOBAL-DEFINE ttTable           tt-acordo-contrato
&GLOBAL-DEFINE hDBOTable         h-boes464
&GLOBAL-DEFINE DBOTable          acordo-contrato

&GLOBAL-DEFINE page0KeyFields    tt-acordo-contrato.nr-acordo tt-acordo-contrato.data-vigencia tt-acordo-contrato.raiz-cnpj ~
                                 tt-acordo-contrato.cod-estabel tt-acordo-contrato.cod-unid-negoc tt-acordo-contrato.fm-cod-com tt-acordo-contrato.ativo
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields       tt-acordo-contrato.id-faturamento tt-acordo-contrato.id-situacao tt-acordo-contrato.id-devolucoes  ~
                                 tt-acordo-contrato.observacoes tt-acordo-contrato.id-base-calculo tt-acordo-contrato.dt-vencto-contrato

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-unid-negoc NO-UNDO
    FIELD cod-unid-negoc AS CHARACTER
    FIELD descricao      AS CHARACTER.

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-acordo-contrato.nr-acordo ~
tt-acordo-contrato.data-vigencia tt-acordo-contrato.raiz-cnpj ~
tt-acordo-contrato.cod-estabel tt-acordo-contrato.cod-unid-negoc ~
tt-acordo-contrato.fm-cod-com tt-acordo-contrato.ativo 
&Scoped-define ENABLED-TABLES tt-acordo-contrato
&Scoped-define FIRST-ENABLED-TABLE tt-acordo-contrato
&Scoped-Define ENABLED-OBJECTS fi-nome-emit fi-desc-estab fi-desc-familia ~
btOK btSave btCancel btHelp rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-acordo-contrato.nr-acordo ~
tt-acordo-contrato.data-vigencia tt-acordo-contrato.raiz-cnpj ~
tt-acordo-contrato.cod-estabel tt-acordo-contrato.cod-unid-negoc ~
tt-acordo-contrato.fm-cod-com tt-acordo-contrato.ativo 
&Scoped-define DISPLAYED-TABLES tt-acordo-contrato
&Scoped-define FIRST-DISPLAYED-TABLE tt-acordo-contrato
&Scoped-Define DISPLAYED-OBJECTS fi-nome-emit fi-desc-estab fi-desc-familia 

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

DEFINE VARIABLE fi-desc-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-familia AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-emit AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37 BY 2.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 19 BY 2.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 19 BY 2.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-acordo-contrato.nr-acordo AT ROW 1.29 COL 19 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-acordo-contrato.data-vigencia AT ROW 1.29 COL 64.57 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     tt-acordo-contrato.raiz-cnpj AT ROW 2.29 COL 19 COLON-ALIGNED WIDGET-ID 14 FORMAT "x(14)"
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     fi-nome-emit AT ROW 2.29 COL 34.29 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     tt-acordo-contrato.cod-estabel AT ROW 3.29 COL 19 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     fi-desc-estab AT ROW 3.29 COL 24.29 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     tt-acordo-contrato.cod-unid-negoc AT ROW 4.29 COL 19 COLON-ALIGNED WIDGET-ID 58
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Item 1","Item 1"
          DROP-DOWN-LIST
          SIZE 56 BY 1
     tt-acordo-contrato.fm-cod-com AT ROW 5.29 COL 19 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     fi-desc-familia AT ROW 5.29 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     btOK AT ROW 20 COL 2
     btSave AT ROW 20 COL 13
     btCancel AT ROW 20 COL 24
     btHelp AT ROW 20 COL 80
     tt-acordo-contrato.ativo AT ROW 5.29 COL 79.43 WIDGET-ID 60
          VIEW-AS TOGGLE-BOX
          SIZE 8 BY .83
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 19.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 20.21
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tt-acordo-contrato.id-faturamento AT ROW 1.96 COL 7.57 NO-LABEL WIDGET-ID 8
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Sem IPI", 0,
"Com IPI", 1
          SIZE 13.43 BY 1.75
     tt-acordo-contrato.id-devolucoes AT ROW 1.96 COL 43.86 NO-LABEL WIDGET-ID 24
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Considera", 0,
"N∆o Considera", 9
          SIZE 15 BY 1.75
     tt-acordo-contrato.id-situacao AT ROW 1.96 COL 64.29 NO-LABEL WIDGET-ID 28
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Acordo Formal", 0,
"Provis∆o p/ VPC", 1
          SIZE 15.14 BY 1.75
     tt-acordo-contrato.id-base-calculo AT ROW 1.88 COL 23 NO-LABEL WIDGET-ID 42
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Sem ST", 0,
"Com ST", 1
          SIZE 15.14 BY 1.96
     tt-acordo-contrato.dt-vencto-contrato AT ROW 4.21 COL 12.43 COLON-ALIGNED WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-acordo-contrato.observacoes AT ROW 5.25 COL 14.43 NO-LABEL WIDGET-ID 32
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 69 BY 6.5
     "Devoluá‰es:" VIEW-AS TEXT
          SIZE 9.72 BY .54 AT ROW 1.25 COL 42.72 WIDGET-ID 18
     "Situaá∆o:" VIEW-AS TEXT
          SIZE 7.72 BY .54 AT ROW 1.25 COL 63.29 WIDGET-ID 22
     "Faturamento:" VIEW-AS TEXT
          SIZE 9.72 BY .54 AT ROW 1.25 COL 4.29 WIDGET-ID 14
     "Observaá‰es:" VIEW-AS TEXT
          SIZE 9.72 BY .54 AT ROW 5.33 COL 4.57 WIDGET-ID 34
     RECT-1 AT ROW 1.54 COL 3 WIDGET-ID 12
     RECT-2 AT ROW 1.54 COL 41.43 WIDGET-ID 16
     RECT-3 AT ROW 1.54 COL 62 WIDGET-ID 20
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.88
         SIZE 84.43 BY 11.04
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-acordo-contrato T "?" NO-UNDO mgesp acordo-contrato
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-acordo-tipo T "?" NO-UNDO mgesp acordo-tipo
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
         HEIGHT             = 20.21
         WIDTH              = 90
         MAX-HEIGHT         = 21.63
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 21.63
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fPage1:MOVE-AFTER-TAB-ITEM (fi-desc-familia:HANDLE IN FRAME fpage0)
       XXTABVALXX = FRAME fPage1:MOVE-BEFORE-TAB-ITEM (btOK:HANDLE IN FRAME fpage0)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FILL-IN tt-acordo-contrato.raiz-cnpj IN FRAME fpage0
   EXP-FORMAT                                                           */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
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
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-acordo-contrato.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-acordo-contrato.cod-estabel wMaintenanceNoNavigation
ON F5 OF tt-acordo-contrato.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                        &campo=tt-acordo-contrato.cod-estabel
                        &campozoom=cod-estabel
                        &campo2=fi-desc-estab
                        &campozoom2=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-acordo-contrato.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-acordo-contrato.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    IF AVAIL tt-acordo-contrato THEN DO:
        ASSIGN INPUT FRAME fPage0 tt-acordo-contrato.cod-estabel.

        IF tt-acordo-contrato.cod-estabel = ? THEN DO:
            ASSIGN fi-desc-estab:SCREEN-VALUE IN FRAME fPage0 = "TODOS".
        END.
        ELSE DO:
            FIND FIRST estabelec NO-LOCK
                 WHERE estabelec.cod-estabel = tt-acordo-contrato.cod-estabel NO-ERROR.
            IF AVAILABLE(estabelec) THEN
                ASSIGN fi-desc-estab:SCREEN-VALUE IN FRAME fPage0 = estabelec.nome.
            ELSE
                ASSIGN fi-desc-estab:SCREEN-VALUE IN FRAME fPage0 = "".
        END.
    END.
    ELSE DO:
        ASSIGN fi-desc-estab:SCREEN-VALUE IN FRAME fPage0 = "".
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-acordo-contrato.cod-estabel wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-acordo-contrato.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-acordo-contrato.fm-cod-com
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-acordo-contrato.fm-cod-com wMaintenanceNoNavigation
ON LEAVE OF tt-acordo-contrato.fm-cod-com IN FRAME fpage0 /* Familia */
DO:
    IF AVAIL tt-acordo-contrato THEN DO:
        ASSIGN INPUT FRAME fPage0 tt-acordo-contrato.fm-cod-com.

        IF tt-acordo-contrato.fm-cod-com = ? THEN
            ASSIGN fi-desc-familia:SCREEN-VALUE IN FRAME fPage0 = "Todas".
        ELSE DO:
            FIND FIRST fam-comerc NO-LOCK
                 WHERE fam-comerc.fm-cod-com = tt-acordo-contrato.fm-cod-com NO-ERROR.
            IF AVAILABLE(fam-comerc) THEN
                ASSIGN fi-desc-familia:SCREEN-VALUE IN FRAME fPage0 = fam-comerc.descricao.
            ELSE
                ASSIGN fi-desc-familia:SCREEN-VALUE IN FRAME fPage0 = "".
        END.
    END.
    ELSE DO:
        ASSIGN fi-desc-familia:SCREEN-VALUE IN FRAME fPage0 = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-acordo-contrato.raiz-cnpj
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-acordo-contrato.raiz-cnpj wMaintenanceNoNavigation
ON LEAVE OF tt-acordo-contrato.raiz-cnpj IN FRAME fpage0 /* Cliente */
DO:
    IF AVAIL tt-acordo-contrato THEN DO:
        FIND FIRST emitente NO-LOCK
             WHERE emitente.cgc BEGINS tt-acordo-contrato.raiz-cnpj:SCREEN-VALUE NO-ERROR.
        IF AVAIL emitente THEN
            ASSIGN fi-nome-emit:SCREEN-VALUE IN FRAME fPage0 = emitente.nome-emit.
        ELSE
            ASSIGN fi-nome-emit:SCREEN-VALUE IN FRAME fPage0 = "".
    END.
    ELSE DO:
        ASSIGN fi-nome-emit:SCREEN-VALUE IN FRAME fPage0 = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

tt-acordo-contrato.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

{maintenancenonavigation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF pcAction = "ADD" THEN
        ASSIGN tt-acordo-contrato.fm-cod-com:SCREEN-VALUE IN FRAME fPage0 = ?
               tt-acordo-contrato.cod-estabel:SCREEN-VALUE IN FRAME fPage0 = ?.

    ASSIGN tt-acordo-contrato.ativo:SENSITIVE IN FRAME fPage0     = YES.

    APPLY "leave" TO tt-acordo-contrato.raiz-cnpj       IN FRAME fPage0.
    APPLY "leave" TO tt-acordo-contrato.cod-estabel     IN FRAME fPage0.
    APPLY "leave" TO tt-acordo-contrato.fm-cod-com      IN FRAME fPage0.

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

    ASSIGN tt-acordo-contrato.nr-acordo:SENSITIVE IN FRAME fPage0 = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    APPLY "entry" TO tt-acordo-contrato.nr-acordo IN FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-carrega-unidades.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-unidades wMaintenanceNoNavigation 
PROCEDURE pi-carrega-unidades :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-desc AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-esapi015 AS HANDLE      NO-UNDO.

    FOR EACH tt-unid-negoc:
        DELETE tt-unid-negoc.
    END.
    
    RUN esapi/esapi015.p PERSISTENT SET h-esapi015.
    RUN pi-retorna-unidade IN h-esapi015 (OUTPUT TABLE tt-unid-negoc).
    DELETE PROCEDURE h-esapi015.

    ASSIGN tt-acordo-contrato.cod-unid-negoc:LIST-ITEM-PAIRS IN FRAME fPage0 = ",".
    ASSIGN c-desc = "? - TODAS".
    /*Ç salvo como 1 no banco de dados para todas, combobox n∆o permite ?*/
    tt-acordo-contrato.cod-unid-negoc:add-last(c-desc, '1') IN FRAME fPage0.
    FOR EACH tt-unid-negoc BY tt-unid-negoc.cod-unid-negoc:
        ASSIGN c-desc = tt-unid-negoc.cod-unid-negoc + "-" + tt-unid-negoc.descricao.

        tt-acordo-contrato.cod-unid-negoc:add-last(c-desc, tt-unid-negoc.cod-unid-negoc) IN FRAME fPage0 NO-ERROR.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este mÇtodo somente Ç executado quando a vari†vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/

    FIND LAST acordo-contrato NO-LOCK NO-ERROR.
    IF AVAIL acordo-contrato THEN
        ASSIGN tt-acordo-contrato.nr-acordo:SCREEN-VALUE IN FRAME fPage0 = STRING(acordo-contrato.nr-acordo + 1).
    ELSE
        ASSIGN tt-acordo-contrato.nr-acordo:SCREEN-VALUE IN FRAME fPage0 = "1".
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

