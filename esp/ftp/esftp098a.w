&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
          emsfnd           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-colab-deb-cred-final NO-UNDO LIKE colab-deb-cred-final
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt_usuar_mestre NO-UNDO LIKE usuar_mestre
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*****************************************************************************
** Programa: esp/ftp/esftp097a.w
** Vers∆o..: 1.00
** Data....: 20/11/2013
** Autor...: Estevan KrÅger - Sensus
** Obs.....: Cadastro de Sal†rio Vari†vel do Colaborador
*****************************************************************************/
{include/i-prgvrs.i ESFTP097A 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESFTP097A
&GLOBAL-DEFINE Version           2.00.00.001

&GLOBAL-DEFINE Folder            NO

&GLOBAL-DEFINE ttTable           tt-colab-deb-cred-final
&GLOBAL-DEFINE hDBOTable         h-boes662
&GLOBAL-DEFINE DBOTable          boes662

&GLOBAL-DEFINE ttParent          tt_usuar_mestre
&GLOBAL-DEFINE DBOParentTable    h-esbofn017

&GLOBAL-DEFINE page0KeyFields    tt-colab-deb-cred-final.cod-mov    ~
                                 tt-colab-deb-cred-final.dt-movto
&GLOBAL-DEFINE page0Fields       tt-colab-deb-cred-final.deb-cred   ~
                                 tt-colab-deb-cred-final.valor      ~
                                 tt-colab-deb-cred-final.historico
&GLOBAL-DEFINE page0ParentFields tt_usuar_mestre.cod_usuario        ~
                                 tt_usuar_mestre.nom_usuario

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE      NO-UNDO.
DEFINE                   VARIABLE wh-pesquisa    AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-implanta     AS LOGICAL.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt_usuar_mestre.cod_usuario ~
tt_usuar_mestre.nom_usuario tt-colab-deb-cred-final.cod-mov ~
tt-colab-deb-cred-final.dt-movto tt-colab-deb-cred-final.deb-cred ~
tt-colab-deb-cred-final.valor tt-colab-deb-cred-final.historico 
&Scoped-define ENABLED-TABLES tt_usuar_mestre tt-colab-deb-cred-final
&Scoped-define FIRST-ENABLED-TABLE tt_usuar_mestre
&Scoped-define SECOND-ENABLED-TABLE tt-colab-deb-cred-final
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar RECT-2 c-desc-mov btOK ~
btSave btCancel btHelp text-1 
&Scoped-Define DISPLAYED-FIELDS tt_usuar_mestre.cod_usuario ~
tt_usuar_mestre.nom_usuario tt-colab-deb-cred-final.cod-mov ~
tt-colab-deb-cred-final.dt-movto tt-colab-deb-cred-final.deb-cred ~
tt-colab-deb-cred-final.valor tt-colab-deb-cred-final.historico 
&Scoped-define DISPLAYED-TABLES tt_usuar_mestre tt-colab-deb-cred-final
&Scoped-define FIRST-DISPLAYED-TABLE tt_usuar_mestre
&Scoped-define SECOND-DISPLAYED-TABLE tt-colab-deb-cred-final
&Scoped-Define DISPLAYED-OBJECTS c-desc-mov text-1 

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

DEFINE VARIABLE c-desc-mov AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 66.33 BY .87 NO-UNDO.

DEFINE VARIABLE text-1 AS CHARACTER FORMAT "X(12)":U INITIAL "Hist¢rico:" 
      VIEW-AS TEXT 
     SIZE 6.56 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 7.47.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.2.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.43
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     tt_usuar_mestre.cod_usuario AT ROW 1.2 COL 13.33 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 8.67 BY .87
     tt_usuar_mestre.nom_usuario AT ROW 1.2 COL 22.33 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 61.67 BY .87
     tt-colab-deb-cred-final.cod-mov AT ROW 2.2 COL 13.33 COLON-ALIGNED WIDGET-ID 8
          LABEL "Movimento"
          VIEW-AS FILL-IN 
          SIZE 4 BY .87
     c-desc-mov AT ROW 2.2 COL 17.67 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     tt-colab-deb-cred-final.dt-movto AT ROW 3.2 COL 13.33 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 9 BY .87
     tt-colab-deb-cred-final.deb-cred AT ROW 4.7 COL 29.56 NO-LABEL WIDGET-ID 28
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "DÇbito", yes,
"CrÇdito", no
          SIZE 31.56 BY .8
     tt-colab-deb-cred-final.valor AT ROW 5.7 COL 13.33 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 9 BY .87
     tt-colab-deb-cred-final.historico AT ROW 6.7 COL 15.33 NO-LABEL WIDGET-ID 32
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 70.67 BY 4.93
     btOK AT ROW 12.17 COL 2
     btSave AT ROW 12.17 COL 13
     btCancel AT ROW 12.17 COL 24
     btHelp AT ROW 12.17 COL 80
     text-1 AT ROW 6.73 COL 6.78 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 11.9 COL 1
     RECT-2 AT ROW 4.33 COL 1 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 12.43
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-colab-deb-cred-final T "?" NO-UNDO mgesp colab-deb-cred-final
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt_usuar_mestre T "?" NO-UNDO emsfnd usuar_mestre
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
         TITLE              = "Inclui/Modifica DÇbito/CrÇdito Final"
         HEIGHT             = 12.37
         WIDTH              = 90.22
         MAX-HEIGHT         = 32.53
         MAX-WIDTH          = 213.33
         VIRTUAL-HEIGHT     = 32.53
         VIRTUAL-WIDTH      = 213.33
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
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-colab-deb-cred-final.cod-mov IN FRAME fPage0
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

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

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation /* Inclui/Modifica DÇbito/CrÇdito Final */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation /* Inclui/Modifica DÇbito/CrÇdito Final */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fPage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fPage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fPage0 /* OK */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fPage0 /* Salvar */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-colab-deb-cred-final.cod-mov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-colab-deb-cred-final.cod-mov wMaintenanceNoNavigation
ON F5 OF tt-colab-deb-cred-final.cod-mov IN FRAME fPage0 /* Movimento */
DO:
    {include/zoomvar.i &prog-zoom="eszoom/z01es272"
                       &campo="tt-colab-deb-cred-final.cod-mov"
                       &campozoom="cod-mov"
                       &frame="fPage0"
                       &campo2="c-desc-mov"
                       &campozoom2="descricao"
                       &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-colab-deb-cred-final.cod-mov wMaintenanceNoNavigation
ON LEAVE OF tt-colab-deb-cred-final.cod-mov IN FRAME fPage0 /* Movimento */
DO:
    ASSIGN INPUT FRAME fPage0 tt-colab-deb-cred-final.cod-mov.

    FIND FIRST mov-comis NO-LOCK
        WHERE  mov-comis.cod-mov = tt-colab-deb-cred-final.cod-mov NO-ERROR.

    ASSIGN c-desc-mov = IF AVAIL mov-comis THEN mov-comis.descricao ELSE "".

    DISPLAY c-desc-mov
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-colab-deb-cred-final.cod-mov wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-colab-deb-cred-final.cod-mov IN FRAME fPage0 /* Movimento */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
tt-colab-deb-cred-final.cod-mov:LOAD-MOUSE-POINTER("image/lupa.cur":U)    IN FRAME fPage0.

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

    IF  pcAction = "Add" THEN DO:
        ASSIGN tt-colab-deb-cred-final.dt-movto = TODAY.

        DISPLAY tt-colab-deb-cred-final.dt-movto
            WITH FRAME fPage0.
    END.

    DISPLAY text-1
        WITH FRAME fPage0.

    APPLY "LEAVE" TO tt-colab-deb-cred-final.cod-mov    IN FRAME fPage0.

    RETURN "OK":U.
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

    ASSIGN {&ttTable}.cod-colab = {&ttParent}.cod_usuario.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

