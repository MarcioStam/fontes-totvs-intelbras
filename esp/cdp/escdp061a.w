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

&GLOBAL-DEFINE page0KeyFields    tt-usuar-nat-operacao.nat-operacao
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
tt-usuar_mestre.nom_usuario tt-usuar-nat-operacao.nat-operacao 
&Scoped-define ENABLED-TABLES tt-usuar_mestre tt-usuar-nat-operacao
&Scoped-define FIRST-ENABLED-TABLE tt-usuar_mestre
&Scoped-define SECOND-ENABLED-TABLE tt-usuar-nat-operacao
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar fi-denominacao fi-tipo btOK ~
btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-usuar_mestre.cod_usuario ~
tt-usuar_mestre.nom_usuario tt-usuar-nat-operacao.nat-operacao 
&Scoped-define DISPLAYED-TABLES tt-usuar_mestre tt-usuar-nat-operacao
&Scoped-define FIRST-DISPLAYED-TABLE tt-usuar_mestre
&Scoped-define SECOND-DISPLAYED-TABLE tt-usuar-nat-operacao
&Scoped-Define DISPLAYED-OBJECTS fi-denominacao fi-tipo 

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

DEFINE VARIABLE fi-denominacao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tipo AS CHARACTER FORMAT "X(80)":U 
     LABEL "Tipo" 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.25.

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
     tt-usuar-nat-operacao.nat-operacao AT ROW 2.5 COL 19 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .88
     fi-denominacao AT ROW 2.5 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     fi-tipo AT ROW 3.5 COL 19 COLON-ALIGNED
     btOK AT ROW 5.83 COL 2
     btSave AT ROW 5.83 COL 13
     btCancel AT ROW 5.83 COL 24
     btHelp AT ROW 5.83 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 5.58 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.72 BY 6.25
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
         HEIGHT             = 6.25
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

    RUN valida.
    
    IF RETURN-VALUE = "NOK" THEN RETURN.

    RUN createManual IN h-dbo642 (INPUT INPUT FRAME fPage0 tt-usuar_mestre.cod_usuario,
                                  INPUT INPUT FRAME fPage0 tt-usuar-nat-operacao.nat-operacao).
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
    RUN valida.
    IF RETURN-VALUE = "NOK" THEN RETURN.

    RUN createManual IN h-dbo642 (INPUT INPUT FRAME fPage0 tt-usuar_mestre.cod_usuario,
                                  INPUT INPUT FRAME fPage0 tt-usuar-nat-operacao.nat-operacao).
    RUN openQueriesSon IN phCaller.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-usuar-nat-operacao.nat-operacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-usuar-nat-operacao.nat-operacao wMaintenanceNoNavigation
ON F5 OF tt-usuar-nat-operacao.nat-operacao IN FRAME fpage0 /* Natureza de Operação */
DO:
 {method/ZoomFields.i &ProgramZoom="inzoom/z04in245.w"
                         &FieldZoom1="nat-operacao"
                         &FieldScreen1="tt-usuar-nat-operacao.nat-operacao"
                         &Frame1="fPage0"
                         &FieldZoom2="denominacao"
                         &FieldScreen2="fi-denominacao"
                         &Frame2="fPage0"
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-usuar-nat-operacao.nat-operacao wMaintenanceNoNavigation
ON LEAVE OF tt-usuar-nat-operacao.nat-operacao IN FRAME fpage0 /* Natureza de Operação */
DO:
    FIND FIRST natur-oper
        WHERE natur-oper.nat-operacao = INPUT FRAME fpage0 tt-usuar-nat-operacao.nat-operacao NO-LOCK NO-ERROR.
        
    IF AVAILABLE natur-oper THEN
        ASSIGN fi-denominacao = natur-oper.denominacao
               fi-tipo        = {ininc/i06in245.i 04 natur-oper.tipo}.
    ELSE IF INPUT FRAME fpage0 tt-usuar-nat-operacao.nat-operacao = "*" THEN
        ASSIGN fi-denominacao = "Todas":U
               fi-tipo        = "":U.
    ELSE
        ASSIGN fi-denominacao = "":U
               fi-tipo        = "":U.

    DISP fi-denominacao
         fi-tipo
        WITH FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-usuar-nat-operacao.nat-operacao wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-usuar-nat-operacao.nat-operacao IN FRAME fpage0 /* Natureza de Operação */
DO:
  APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

IF tt-usuar-nat-operacao.nat-operacao:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida wMaintenanceNoNavigation 
PROCEDURE Valida :
IF NOT CAN-FIND (FIRST usuar-nat-operacao
                     WHERE usuar-nat-operacao.cod-usuario  = tt-usuar_mestre.cod_usuario:SCREEN-VALUE IN FRAME fpage0
                       AND usuar-nat-operacao.nat-operacao =  tt-usuar-nat-operacao.nat-operacao:SCREEN-VALUE IN FRAME fpage0) THEN DO:
      FIND FIRST emsfnd.usuar_mestre
                WHERE emsfnd.usuar_mestre.cod_usuario =  tt-usuar_mestre.cod_usuario:SCREEN-VALUE IN FRAME fpage0  NO-LOCK NO-ERROR.

        IF NOT AVAILABLE emsfnd.usuar_mestre THEN DO:
            MESSAGE "Usuario Nao Cadastrado"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN "NOK":U.
        END.
        FIND FIRST natur-oper
            WHERE natur-oper.nat-operacao =  tt-usuar-nat-operacao.nat-operacao:SCREEN-VALUE IN FRAME fpage0
               OR "*"                     =  tt-usuar-nat-operacao.nat-operacao:SCREEN-VALUE IN FRAME fpage0 NO-LOCK NO-ERROR.

        IF NOT AVAILABLE natur-oper THEN DO:
            MESSAGE "Natureza nÆo Cadastrada"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN "NOK":U.                                    
        END.
    END.
    ELSE DO:
           MESSAGE "Registro Ja cadastrado "
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

