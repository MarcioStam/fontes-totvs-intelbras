&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttcar-familia-item NO-UNDO LIKE car-familia-item
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttfamilia-item NO-UNDO LIKE familia-item
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
{include/i-prgvrs.i ESCEP034C 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESCEP034C
&GLOBAL-DEFINE Version           2.04.00.001

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           ttcar-familia-item
&GLOBAL-DEFINE hDBOTable         hboes026
&GLOBAL-DEFINE DBOTable          car-familia-item

&GLOBAL-DEFINE ttParent          ttfamilia-item
&GLOBAL-DEFINE DBOParent         familia-item

&GLOBAL-DEFINE page0KeyFields    ttcar-familia-item.cod-sub-familia ttcar-familia-item.Descricao ttcar-familia-item.cod-car-familia
&GLOBAL-DEFINE page0Fields       ttcar-familia-item.abreviatura ttcar-familia-item.cod-sub-familia ttcar-familia-item.Descricao ttcar-familia-item.cod-car-familia
&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       
&GLOBAL-DEFINE hDBOSon1         hboes174

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.
/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE shared VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.

DEFINE VARIABLE i-nr-sub-familia AS INTEGER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttcar-familia-item.cod-sub-familia ~
ttcar-familia-item.cod-car-familia ttcar-familia-item.Descricao ~
ttcar-familia-item.abreviatura 
&Scoped-define ENABLED-TABLES ttcar-familia-item
&Scoped-define FIRST-ENABLED-TABLE ttcar-familia-item
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar rtFields btOK btSave ~
btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS ttcar-familia-item.cod-sub-familia ~
ttcar-familia-item.cod-car-familia ttcar-familia-item.Descricao ~
ttcar-familia-item.abreviatura 
&Scoped-define DISPLAYED-TABLES ttcar-familia-item
&Scoped-define FIRST-DISPLAYED-TABLE ttcar-familia-item
&Scoped-Define DISPLAYED-OBJECTS fi-sub-Descricao 

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

DEFINE VARIABLE fi-sub-Descricao AS CHARACTER FORMAT "x(35)" 
     VIEW-AS FILL-IN 
     SIZE 36.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rtFields
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.25.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttcar-familia-item.cod-sub-familia AT ROW 1.17 COL 23 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     fi-sub-Descricao AT ROW 1.17 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 14 NO-TAB-STOP 
     ttcar-familia-item.cod-car-familia AT ROW 2.17 COL 23 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     ttcar-familia-item.Descricao AT ROW 3.17 COL 23 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 36.14 BY .88
     ttcar-familia-item.abreviatura AT ROW 4.38 COL 23 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     btOK AT ROW 5.75 COL 2
     btSave AT ROW 5.75 COL 13
     btCancel AT ROW 5.75 COL 24
     btHelp AT ROW 5.75 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 5.5 COL 1
     rtFields AT ROW 4.25 COL 1 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 6.17
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttcar-familia-item T "?" NO-UNDO mgesp car-familia-item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttfamilia-item T "?" NO-UNDO mgesp familia-item
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
         HEIGHT             = 6.13
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
/* SETTINGS FOR FILL-IN fi-sub-Descricao IN FRAME fpage0
   NO-ENABLE                                                            */
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


&Scoped-define SELF-NAME ttcar-familia-item.abreviatura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcar-familia-item.abreviatura wMaintenanceNoNavigation
ON LEAVE OF ttcar-familia-item.abreviatura IN FRAME fpage0 /* Abreviatura */
DO:
    ASSIGN ttcar-familia-item.descricao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
           ttcar-familia-item.abreviatura:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
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
    ASSIGN i-nr-sub-familia = int(ttcar-familia-item.cod-sub-familia:SCREEN-VALUE IN FRAME fPage0).

    RUN saveRecord IN THIS-PROCEDURE.

    IF RETURN-VALUE = "OK" THEN DO:
        ASSIGN ttcar-familia-item.cod-sub-familia:SCREEN-VALUE IN FRAME fPage0  = STRING(i-nr-sub-familia).
        APPLY "leave" TO ttcar-familia-item.cod-sub-familia IN FRAME fPage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcar-familia-item.cod-sub-familia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcar-familia-item.cod-sub-familia wMaintenanceNoNavigation
ON F5 OF ttcar-familia-item.cod-sub-familia IN FRAME fpage0 /* Sub-Familia */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es174.w"
                         &FieldZoom1="cod-sub-familia"
                         &FieldScreen1="ttcar-familia-item.cod-sub-familia"
                         &Frame1="fPage0"
                         &FieldZoom2="Descricao"
                         &FieldScreen2="fi-sub-Descricao"
                         &Frame2="fPage0"
                         &RunMethod="RUN setaVariable IN hProgramZoom (INPUT ttfamilia-item.cod-familia)."
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcar-familia-item.cod-sub-familia wMaintenanceNoNavigation
ON LEAVE OF ttcar-familia-item.cod-sub-familia IN FRAME fpage0 /* Sub-Familia */
DO:
    run gotoKey in {&hDBOSon1} (input ttfamilia-item.cod-familia,
                                input input frame fPage0 ttcar-familia-item.cod-sub-familia).
                                
    if return-value = "OK" then 
        run getCharField in {&hDBOSon1} (input "descricao", output fi-sub-Descricao).                           
    ELSE
        ASSIGN fi-sub-descricao = "".

    disp fi-sub-Descricao with frame fPage0.    
    
    if pcAction = "ADD":U then do with frame fPage0:
        find last car-familia-item 
            where car-familia-item.cod-familia = ttfamilia-item.cod-familia
              and car-familia-item.cod-sub-familia = input frame fPage0 ttcar-familia-item.cod-sub-familia
                  no-lock no-error.
        if avail car-familia-item then 
             assign ttcar-familia-item.cod-car-familia:screen-value = 
                string(car-familia-item.cod-car-familia + 1).
        else assign ttcar-familia-item.cod-car-familia:screen-value = "0".

    end.      
    
    return "OK".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcar-familia-item.cod-sub-familia wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttcar-familia-item.cod-sub-familia IN FRAME fpage0 /* Sub-Familia */
DO:
  apply "f5" to self.
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

    if pcAction = "Update" then
        disable {&page0KeyFields} with frame fPage0.
    apply "leave" to ttcar-familia-item.cod-sub-familia in frame fPage0.     
    ttcar-familia-item.cod-sub-familia:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

    disable ttcar-familia-item.descricao with frame fPage0.
      
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

    RUN setFamilyDesc IN {&hDBOTable} (INPUT INPUT FRAME fPage0 ttcar-familia-item.abreviatura).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    ttcar-familia-item.cod-familia = ttfamilia-item.cod-familia.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

