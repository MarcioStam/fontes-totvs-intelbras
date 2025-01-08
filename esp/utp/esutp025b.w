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
&GLOBAL-DEFINE Program           ESUTP025B
&GLOBAL-DEFINE Version           2.04.00.001

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Tipo

&GLOBAL-DEFINE ttTable           tt-acordo-tipo
&GLOBAL-DEFINE hDBOTable         h-boes465
&GLOBAL-DEFINE DBOTable          acordo-tipo

&GLOBAL-DEFINE ttParent          tt-acordo-contrato
&GLOBAL-DEFINE DBOParentTable    h-boes464

&GLOBAL-DEFINE page0KeyFields    tt-acordo-tipo.tipo-acordo
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-acordo-contrato.nr-acordo
&GLOBAL-DEFINE page1Fields       tt-acordo-tipo.percentual tt-acordo-tipo.valor-fixo ~
                                 tt-acordo-tipo.forma-pagto tt-acordo-tipo.id-incidencia tt-acordo-tipo.id-pagto


/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

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
tt-acordo-tipo.tipo-acordo 
&Scoped-define ENABLED-TABLES tt-acordo-contrato tt-acordo-tipo
&Scoped-define FIRST-ENABLED-TABLE tt-acordo-contrato
&Scoped-define SECOND-ENABLED-TABLE tt-acordo-tipo
&Scoped-Define ENABLED-OBJECTS fi-desc-acordo btOK btSave btCancel btHelp ~
rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-acordo-contrato.nr-acordo ~
tt-acordo-tipo.tipo-acordo 
&Scoped-define DISPLAYED-TABLES tt-acordo-contrato tt-acordo-tipo
&Scoped-define FIRST-DISPLAYED-TABLE tt-acordo-contrato
&Scoped-define SECOND-DISPLAYED-TABLE tt-acordo-tipo
&Scoped-Define DISPLAYED-OBJECTS fi-desc-acordo 

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

DEFINE VARIABLE fi-desc-acordo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 23 BY 3.04.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 23 BY 3.04.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 22.14 BY 8.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-acordo-contrato.nr-acordo AT ROW 1.29 COL 18.57 COLON-ALIGNED WIDGET-ID 52
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-acordo-tipo.tipo-acordo AT ROW 2.29 COL 18.57 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-desc-acordo AT ROW 2.29 COL 24.86 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     btOK AT ROW 16.63 COL 2
     btSave AT ROW 16.63 COL 13
     btCancel AT ROW 16.63 COL 24
     btHelp AT ROW 16.63 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 16.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tt-acordo-tipo.percentual AT ROW 1.5 COL 16 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .88
     tt-acordo-tipo.valor-fixo AT ROW 2.5 COL 16 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .88
     tt-acordo-tipo.forma-pagto AT ROW 4.04 COL 20.43 NO-LABEL WIDGET-ID 42
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Boleto", 0,
"Desconto", 1,
"Produto", 2
          SIZE 17.86 BY 2.5
     tt-acordo-tipo.id-incidencia AT ROW 7.58 COL 20.43 NO-LABEL WIDGET-ID 54
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Nota Fiscal", 0,
"Faturamento Per¡odo", 1,
"Eventos", 2
          SIZE 19.57 BY 2.5
     tt-acordo-tipo.id-pagto AT ROW 2.42 COL 48.29 NO-LABEL WIDGET-ID 60
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "D + X informado", 0,
"Por NF", 1,
"Por Mˆs", 2,
"Por Bimestre", 2,
"Por Trimestre", 4,
"Por Semestre", 5,
"Por Ano", 6,
"Data Informada", 7
          SIZE 16.86 BY 7.75
     "Forma Pagto:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 3.46 COL 19.14 WIDGET-ID 46
     "Pagamento:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 1.83 COL 46.72 WIDGET-ID 58
     "Incidˆncia:" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 6.92 COL 19.14 WIDGET-ID 52
     RECT-4 AT ROW 3.71 COL 18.14 WIDGET-ID 70
     RECT-5 AT ROW 7.25 COL 18.14 WIDGET-ID 72
     RECT-6 AT ROW 2.08 COL 45.72 WIDGET-ID 74
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5
         SIZE 84.43 BY 10.92
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
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
         HEIGHT             = 17
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

ASSIGN XXTABVALXX = FRAME fPage1:MOVE-AFTER-TAB-ITEM (fi-desc-acordo:HANDLE IN FRAME fpage0)
       XXTABVALXX = FRAME fPage1:MOVE-BEFORE-TAB-ITEM (btOK:HANDLE IN FRAME fpage0)
/* END-ASSIGN-TABS */.

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


&Scoped-define SELF-NAME tt-acordo-tipo.tipo-acordo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-acordo-tipo.tipo-acordo wMaintenanceNoNavigation
ON F5 OF tt-acordo-tipo.tipo-acordo IN FRAME fpage0 /* Tipo Acordo */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es452.w"
                         &FieldZoom1="codigo"
                         &FieldScreen1="tt-acordo-tipo.tipo-acordo"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-desc-acordo"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-acordo-tipo.tipo-acordo wMaintenanceNoNavigation
ON LEAVE OF tt-acordo-tipo.tipo-acordo IN FRAME fpage0 /* Tipo Acordo */
DO:
    ASSIGN INPUT FRAME fPage0 tt-acordo-tipo.tipo-acordo.
    {include/leave.i &tabela=tipo-acordo
                     &atributo-ref=descricao
                     &variavel-ref=fi-desc-acordo
                     &where="tipo-acordo.codigo = tt-acordo-tipo.tipo-acordo"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-acordo-tipo.tipo-acordo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-acordo-tipo.tipo-acordo IN FRAME fpage0 /* Tipo Acordo */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    APPLY "entry" TO tt-acordo-tipo.tipo-acordo IN FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    
    assign tt-acordo-tipo.nr-acordo = tt-acordo-contrato.nr-acordo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

