&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-juridico-andamentos NO-UNDO LIKE juridico-andamentos
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-juridico-processos NO-UNDO LIKE juridico-processos
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
{include/i-prgvrs.i ESUTP033B 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESUTP033B
&GLOBAL-DEFINE Version           2.04.00.001

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-juridico-andamentos
&GLOBAL-DEFINE hDBOTable         h-boes473
&GLOBAL-DEFINE DBOTable          usu-equipamentos

&GLOBAL-DEFINE ttParent          tt-juridico-processos
&GLOBAL-DEFINE DBOParentTable    h-boes472

&GLOBAL-DEFINE page0ParentFields tt-juridico-processos.processo
&GLOBAL-DEFINE page0KeyFields    tt-juridico-andamentos.dt-prevista tt-juridico-andamentos.cod-acao
&GLOBAL-DEFINE page0Fields       tt-juridico-andamentos.hora tt-juridico-andamentos.dt-efetiva tt-juridico-andamentos.comentarios



/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS tt-juridico-processos.processo ~
tt-juridico-andamentos.dt-prevista tt-juridico-andamentos.cod-acao ~
tt-juridico-andamentos.hora tt-juridico-andamentos.dt-efetiva ~
tt-juridico-andamentos.comentarios 
&Scoped-define ENABLED-TABLES tt-juridico-processos tt-juridico-andamentos
&Scoped-define FIRST-ENABLED-TABLE tt-juridico-processos
&Scoped-define SECOND-ENABLED-TABLE tt-juridico-andamentos
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar rtKeys-2 fi-desc-acao btOK ~
btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-juridico-processos.processo ~
tt-juridico-andamentos.dt-prevista tt-juridico-andamentos.cod-acao ~
tt-juridico-andamentos.hora tt-juridico-andamentos.dt-efetiva ~
tt-juridico-andamentos.comentarios 
&Scoped-define DISPLAYED-TABLES tt-juridico-processos ~
tt-juridico-andamentos
&Scoped-define FIRST-DISPLAYED-TABLE tt-juridico-processos
&Scoped-define SECOND-DISPLAYED-TABLE tt-juridico-andamentos
&Scoped-Define DISPLAYED-OBJECTS fi-desc-acao 

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

DEFINE VARIABLE fi-desc-acao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.5.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-juridico-processos.processo AT ROW 1.25 COL 16 COLON-ALIGNED WIDGET-ID 34 FORMAT "x(50)"
          VIEW-AS FILL-IN 
          SIZE 45 BY .88
     tt-juridico-andamentos.dt-prevista AT ROW 2.25 COL 16 COLON-ALIGNED WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-juridico-andamentos.cod-acao AT ROW 3.25 COL 16 COLON-ALIGNED WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-desc-acao AT ROW 3.25 COL 24.29 COLON-ALIGNED NO-LABEL WIDGET-ID 168
     tt-juridico-andamentos.hora AT ROW 5.25 COL 16 COLON-ALIGNED WIDGET-ID 170
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-juridico-andamentos.dt-efetiva AT ROW 6.25 COL 16 COLON-ALIGNED WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-juridico-andamentos.comentarios AT ROW 7.25 COL 18 NO-LABEL WIDGET-ID 2
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 70 BY 2.75
     btOK AT ROW 11.25 COL 2
     btSave AT ROW 11.25 COL 13
     btCancel AT ROW 11.25 COL 24
     btHelp AT ROW 11.25 COL 80
     "Coment rios:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 7.29 COL 8.86 WIDGET-ID 42
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 11 COL 1
     rtKeys-2 AT ROW 4.92 COL 1 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 11.63
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-juridico-andamentos T "?" NO-UNDO mgesp juridico-andamentos
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-juridico-processos T "?" NO-UNDO mgesp juridico-processos
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
         HEIGHT             = 11.63
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-juridico-processos.processo IN FRAME fpage0
   EXP-FORMAT                                                           */
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


&Scoped-define SELF-NAME tt-juridico-andamentos.cod-acao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-juridico-andamentos.cod-acao wMaintenanceNoNavigation
ON F5 OF tt-juridico-andamentos.cod-acao IN FRAME fpage0 /* C¢d. A‡Æo */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es470.w"
                         &FieldZoom1="codigo"
                         &FieldScreen1="tt-juridico-andamentos.cod-acao"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-desc-acao"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-juridico-andamentos.cod-acao wMaintenanceNoNavigation
ON LEAVE OF tt-juridico-andamentos.cod-acao IN FRAME fpage0 /* C¢d. A‡Æo */
DO:
    IF AVAIL tt-juridico-andamentos THEN DO:
        ASSIGN INPUT FRAME fPage0 tt-juridico-andamentos.cod-acao.
        FIND FIRST juridico-acoes NO-LOCK
             WHERE juridico-acoes.codigo = tt-juridico-andamentos.cod-acao NO-ERROR.
        IF AVAIL juridico-acoes THEN
            ASSIGN fi-desc-acao:SCREEN-VALUE IN FRAME fPage0 = juridico-acoes.descricao.
        ELSE
            ASSIGN fi-desc-acao:SCREEN-VALUE IN FRAME fPage0 = "".
    END.
    ELSE DO:
        ASSIGN fi-desc-acao:SCREEN-VALUE IN FRAME fPage0 = "".
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-juridico-andamentos.cod-acao wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-juridico-andamentos.cod-acao IN FRAME fpage0 /* C¢d. A‡Æo */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
tt-juridico-andamentos.cod-acao:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

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

    if avail tt-juridico-andamentos then do:
        apply 'leave' to tt-juridico-andamentos.cod-acao in frame fPage0.
    end.
    

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
    
    assign tt-juridico-andamentos.processo = tt-juridico-processos.processo.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

