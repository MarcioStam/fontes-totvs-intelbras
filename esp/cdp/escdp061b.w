&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-usuar-nat-operacao NO-UNDO LIKE usuar-nat-operacao
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-usuar_mestre NO-UNDO LIKE usuar_mestre
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
{include/i-prgvrs.i ESCDP061A 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESCDP061A
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-usuar-nat-operacao
&GLOBAL-DEFINE hDBOTable         h-dbo642
&GLOBAL-DEFINE DBOTable          usuar-nat-operacao

&GLOBAL-DEFINE ttParent          tt-usuar_mestre
&GLOBAL-DEFINE DBOParentTable    usuar_mestre

&GLOBAL-DEFINE page0KeyFields    c-nat-operacao-ini c-nat-operacao-fim
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-usuar_mestre.cod_usuario tt-usuar_mestre.nom_usuario 
&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       

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
&Scoped-Define ENABLED-FIELDS tt-usuar_mestre.cod_usuario ~
tt-usuar_mestre.nom_usuario 
&Scoped-define ENABLED-TABLES tt-usuar_mestre
&Scoped-define FIRST-ENABLED-TABLE tt-usuar_mestre
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar c-nat-operacao-ini ~
fi-denominacao c-nat-operacao-fim fi-denominacao-2 btOK btSave btCancel ~
btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-usuar_mestre.cod_usuario ~
tt-usuar_mestre.nom_usuario 
&Scoped-define DISPLAYED-TABLES tt-usuar_mestre
&Scoped-define FIRST-DISPLAYED-TABLE tt-usuar_mestre
&Scoped-Define DISPLAYED-OBJECTS c-nat-operacao-ini fi-denominacao ~
c-nat-operacao-fim fi-denominacao-2 

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

DEFINE VARIABLE c-nat-operacao-fim AS CHARACTER FORMAT "x(6)" 
     LABEL "Nat de Opera‡ao Final" 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88.

DEFINE VARIABLE c-nat-operacao-ini AS CHARACTER FORMAT "x(6)" 
     LABEL "Nat Opera‡ao Inicial" 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88.

DEFINE VARIABLE fi-denominacao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .88 NO-UNDO.

DEFINE VARIABLE fi-denominacao-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-usuar_mestre.cod_usuario AT ROW 1.5 COL 19 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .88
     tt-usuar_mestre.nom_usuario AT ROW 1.5 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 46 BY .88
     c-nat-operacao-ini AT ROW 2.5 COL 19 COLON-ALIGNED HELP
          "Codigo da natureza de operacao" WIDGET-ID 6
     fi-denominacao AT ROW 2.5 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     c-nat-operacao-fim AT ROW 3.46 COL 19 COLON-ALIGNED HELP
          "Codigo da natureza de operacao" WIDGET-ID 14
     fi-denominacao-2 AT ROW 3.46 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     btOK AT ROW 6.92 COL 2
     btSave AT ROW 6.92 COL 13
     btCancel AT ROW 6.92 COL 24
     btHelp AT ROW 6.92 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 6.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.72 BY 7.42
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-usuar-nat-operacao T "?" NO-UNDO mgesp usuar-nat-operacao
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-usuar_mestre T "?" NO-UNDO mgcad usuar_mestre
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
         HEIGHT             = 7.42
         WIDTH              = 90.72
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90.86
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90.86
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
   FRAME-NAME                                                           */
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
    /*RUN saveRecord IN THIS-PROCEDURE.*/
    RUN createFaixa IN h-dbo642 (INPUT INPUT FRAME fpage0 tt-usuar_mestre.cod_usuario,
                                 INPUT INPUT FRAME fpage0 c-nat-operacao-ini,
                                 INPUT INPUT FRAME fpage0 c-nat-operacao-fim).

    RUN openQueriesSon IN phCaller.
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN createFaixa IN h-dbo642 (INPUT INPUT FRAME fpage0 tt-usuar_mestre.cod_usuario,
                                 INPUT INPUT FRAME fpage0 c-nat-operacao-ini,
                                 INPUT INPUT FRAME fpage0 c-nat-operacao-fim).
    RUN openQueriesSon IN phCaller.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nat-operacao-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-operacao-fim wMaintenanceNoNavigation
ON F5 OF c-nat-operacao-fim IN FRAME fpage0 /* Nat de Opera‡ao Final */
DO:
 {method/ZoomFields.i &ProgramZoom="inzoom/z04in245.w"
                         &FieldZoom1="nat-operacao"
                         &FieldScreen1="c-nat-operacao-fim"
                         &Frame1="fPage0"
                         &FieldZoom2="denominacao"
                         &FieldScreen2="fi-denominacao-2"
                         &Frame2="fPage0"
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-operacao-fim wMaintenanceNoNavigation
ON LEAVE OF c-nat-operacao-fim IN FRAME fpage0 /* Nat de Opera‡ao Final */
DO:
    FIND FIRST natur-oper
        WHERE natur-oper.nat-operacao = INPUT FRAME fpage0 c-nat-operacao-fim NO-LOCK NO-ERROR.
        
    IF AVAILABLE natur-oper THEN
        ASSIGN fi-denominacao-2 = natur-oper.denominacao.
               
    ELSE IF INPUT FRAME fpage0 c-nat-operacao-fim = "*" THEN
        ASSIGN fi-denominacao-2 = "Todas":U.
               
    ELSE
        ASSIGN fi-denominacao-2 = "":U.
               
    DISP fi-denominacao-2
        WITH FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-operacao-fim wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-nat-operacao-fim IN FRAME fpage0 /* Nat de Opera‡ao Final */
DO:
  APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nat-operacao-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-operacao-ini wMaintenanceNoNavigation
ON F5 OF c-nat-operacao-ini IN FRAME fpage0 /* Nat Opera‡ao Inicial */
DO:
 {method/ZoomFields.i &ProgramZoom="inzoom/z04in245.w"
                         &FieldZoom1="nat-operacao"
                         &FieldScreen1="c-nat-operacao-ini"
                         &Frame1="fPage0"
                         &FieldZoom2="denominacao"
                         &FieldScreen2="fi-denominacao"
                         &Frame2="fPage0"
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-operacao-ini wMaintenanceNoNavigation
ON LEAVE OF c-nat-operacao-ini IN FRAME fpage0 /* Nat Opera‡ao Inicial */
DO:
    FIND FIRST natur-oper
        WHERE natur-oper.nat-operacao = INPUT FRAME fpage0 c-nat-operacao-ini NO-LOCK NO-ERROR.
        
    IF AVAILABLE natur-oper THEN
        ASSIGN fi-denominacao = natur-oper.denominacao.
               
    ELSE IF INPUT FRAME fpage0 c-nat-operacao-ini = "*" THEN
        ASSIGN fi-denominacao = "Todas":U.
               
    ELSE
        ASSIGN fi-denominacao = "":U.
              

    DISP fi-denominacao
        WITH FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-operacao-ini wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-nat-operacao-ini IN FRAME fpage0 /* Nat Opera‡ao Inicial */
DO:
  APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

IF c-nat-operacao-ini:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
     IN FRAME fPage0 THEN.

IF c-nat-operacao-fim:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
     IN FRAME fPage0 THEN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    IF pcAction = "add" OR pcAction = "copy" THEN
        ASSIGN tt-usuar-nat-operacao.cod-usuar = tt-usuar_mestre.cod_usuario.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

