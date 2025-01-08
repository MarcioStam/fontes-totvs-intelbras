&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttFabricante NO-UNDO LIKE fabricante
       field r-rowid as rowid
       .
DEFINE TEMP-TABLE ttItem-Fabric NO-UNDO LIKE item-fabric
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
{include/i-prgvrs.i es0002a 1.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           es0002a
&GLOBAL-DEFINE Version           1.00.00.000

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      ITEM

&GLOBAL-DEFINE ttTable           ttItem-Fabric
&GLOBAL-DEFINE hDBOTable         hDBOItem-Fabric
&GLOBAL-DEFINE DBOTable          Item-Fabric

&GLOBAL-DEFINE ttParent          ttFabricante
&GLOBAL-DEFINE DBOParentTable    Fabricante

&GLOBAL-DEFINE page0KeyFields    ttItem-Fabric.it-codigo
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields ttFabricante.cod-fabric ~
                                 ttFabricante.nome-abrev
&GLOBAL-DEFINE page1Fields       c-it-fabric ~
                                 ttItem-Fabric.referencia ~
                                 ttItem-Fabric.validade



/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEF VAR c-it-fabric AS CHAR FORMAT "x(60)" NO-UNDO.

DEF VAR hDBOitem AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttFabricante.cod-fabric ~
ttFabricante.nome-abrev ttItem-Fabric.it-codigo 
&Scoped-define ENABLED-TABLES ttFabricante ttItem-Fabric
&Scoped-define FIRST-ENABLED-TABLE ttFabricante
&Scoped-define SECOND-ENABLED-TABLE ttItem-Fabric
&Scoped-Define ENABLED-OBJECTS btOK btSave btCancel btHelp rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttFabricante.cod-fabric ~
ttFabricante.nome-abrev ttItem-Fabric.it-codigo 
&Scoped-define DISPLAYED-TABLES ttFabricante ttItem-Fabric
&Scoped-define FIRST-DISPLAYED-TABLE ttFabricante
&Scoped-define SECOND-DISPLAYED-TABLE ttItem-Fabric
&Scoped-Define DISPLAYED-OBJECTS cDescricao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDesc-Item wMaintenanceNoNavigation 
FUNCTION fnDesc-Item RETURNS CHARACTER
   ( INPUT cIt-Codigo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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

DEFINE VARIABLE cDescricao AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 34 BY .67 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttFabricante.cod-fabric AT ROW 1.25 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.14 BY .79
     ttFabricante.nome-abrev AT ROW 2.04 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .79
     ttItem-Fabric.it-codigo AT ROW 3 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .79
     btOK AT ROW 16.63 COL 2
     btSave AT ROW 16.63 COL 13
     btCancel AT ROW 16.63 COL 24
     btHelp AT ROW 16.63 COL 80
     cDescricao AT ROW 3 COL 49 COLON-ALIGNED NO-LABEL
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 16.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     c-it-fabric AT ROW 5 COL 23 COLON-ALIGNED LABEL "Item Fabricante"
          VIEW-AS FILL-IN 
          SIZE 50 BY .79
     ttItem-Fabric.referencia AT ROW 5.79 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .79
     ttItem-Fabric.validade AT ROW 6.58 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .79
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5.75
         SIZE 84.43 BY 9.88
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttFabricante T "?" NO-UNDO mgesp fabricante
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
          
      END-FIELDS.
      TABLE: ttItem-Fabric T "?" NO-UNDO mgesp item-fabric
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
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN cDescricao IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
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


&Scoped-define SELF-NAME ttItem-Fabric.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttItem-Fabric.it-codigo wMaintenanceNoNavigation
ON F5 OF ttItem-Fabric.it-codigo IN FRAME fpage0 /* Item */
DO:
   

    {include/zoomvar.i &prog-zoom="inzoom/z01in172.w"
                      &campo="ttItem-fabric.it-codigo"
                      &campozoom="it-codigo"
                      &frame="fPage0"}

/*    {method/ZoomFields.i &ProgramZoom="adzoom/z02ad098.w"
                         &FieldZoom1="nome-abrev"
                         &FieldScreen1="ttItem-Fabric.it-codigo"
                         &Frame1="fPage0"
                         &EnableImplant="Yes"}

    
  */  
  /*  {method/ZoomFields.i &ProgramZoom="inzoom/z02in172.w"
                         &FieldZoom1="it-codigo"
                         &FieldScreen1="ttItem-Fabric.it-codigo"
                         &Frame1="fPage0"}
    */
  /*  
    {method/ZoomFields.i &ProgramZoom="inzoom/z01in172.w"
                         &FieldZoom1="it-codigo"
                         &FieldScreen1="ttItem-Fabric.it-codigo"
                         &Frame1="fPage0"
                         &RunMethod="Run setVariable in hProgramZoom (Input 'item')."
                         &EnableImplant="NO"}
    */                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttItem-Fabric.it-codigo wMaintenanceNoNavigation
ON LEAVE OF ttItem-Fabric.it-codigo IN FRAME fpage0 /* Item */
DO:
  /* ASSIGN cDescricao:SCREEN-VALUE IN FRAME {&frame-name} = fnDesc-Item(ttItem-fabric.it-codigo:SCREEN-VALUE).
   IF fnDesc-Item(ttItem-fabric.it-codigo:SCREEN-VALUE) = "" THEN DO:
       MESSAGE "Item nÆo cadastrado ou Descri‡Æo Inv lida" VIEW-AS ALERT-BOX.
       RETURN NO-APPLY.

   END.*/


    {method/ReferenceFields.i 
      &HandleDBOLeave="hDBOitem"
      &KeyValue1="ttitem-fabric.it-codigo:SCREEN-VALUE IN FRAME fPage0"
      &FieldName1="desc-item"
      &FieldScreen1="cdescricao"
      &Frame1="fPage0"}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/MainBlock.i}

ttitem-fabric.it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage0.


{btb/btb008za.i1 inbo/boin172.p YES}
{btb/btb008za.i2 inbo/boin172.p '' hDBOitem}
RUN openQuery IN hDBOItem (INPUT "1":U) NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(hDBOitem) THEN
        RUN destroy IN hDBOitem.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveFields wMaintenanceNoNavigation 
PROCEDURE afterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN ttItem-Fabric.it-fabric  = c-it-fabric:SCREEN-VALUE IN FRAME fPage1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    APPLY "LEAVE":U TO ttitem-fabric.it-codigo IN FRAME fPage0.
    ASSIGN c-it-fabric:SCREEN-VALUE IN FRAME fPage1 = ttItem-fabric.it-fabric.
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
    ASSIGN ttItem-Fabric.cod-fabric = ttFabricante.cod-fabric.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDesc-Item wMaintenanceNoNavigation 
FUNCTION fnDesc-Item RETURNS CHARACTER
   ( INPUT cIt-Codigo AS CHAR ) :
  /*------------------------------------------------------------------------------
    Purpose:  
      Notes:  
  ------------------------------------------------------------------------------*/

    DEF VAR cDesc-Item AS CHAR NO-UNDO.
    
    {esinc/es0001.i} 
    
        /*
    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = pcitem NO-ERROR.
    IF AVAIL ITEM THEN
       ASSIGN cDesc-ItemAux = ITEM.desc-item.
          */

    RETURN cDesc-Item.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

