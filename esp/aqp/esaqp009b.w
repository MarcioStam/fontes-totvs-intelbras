&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-aud-procedimento NO-UNDO LIKE aud-procedimento
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-nc-aud-procedimento NO-UNDO LIKE nc-aud-procedimento
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESAQP009B 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESAQP009B
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-nc-aud-procedimento
&GLOBAL-DEFINE hDBOTable         h-boes670
&GLOBAL-DEFINE DBOTable          nc-aud-procedimento

&GLOBAL-DEFINE ttParent          tt-aud-procedimento
&GLOBAL-DEFINE DBOParentTable    h-boes669

&GLOBAL-DEFINE page0KeyFields    tt-nc-aud-procedimento.nr-seq-nconfor
&GLOBAL-DEFINE page0Fields       tt-nc-aud-procedimento.nr-cartao tt-nc-aud-procedimento.descricao
&GLOBAL-DEFINE page0ParentFields tt-aud-procedimento.nr-seq-aud-proced

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
define buffer bf-aud-proced for aud-procedimento.

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
&Scoped-Define ENABLED-FIELDS tt-aud-procedimento.nr-seq-aud-proced ~
tt-nc-aud-procedimento.nr-seq-nconfor tt-nc-aud-procedimento.nr-cartao ~
tt-nc-aud-procedimento.descricao 
&Scoped-define ENABLED-TABLES tt-aud-procedimento tt-nc-aud-procedimento
&Scoped-define FIRST-ENABLED-TABLE tt-aud-procedimento
&Scoped-define SECOND-ENABLED-TABLE tt-nc-aud-procedimento
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar RECT-12 RECT-13 btOK btSave ~
btCancel btHelp fi-lb-observacao 
&Scoped-Define DISPLAYED-FIELDS tt-aud-procedimento.nr-seq-aud-proced ~
tt-nc-aud-procedimento.nr-seq-nconfor tt-nc-aud-procedimento.nr-cartao ~
tt-nc-aud-procedimento.descricao 
&Scoped-define DISPLAYED-TABLES tt-aud-procedimento tt-nc-aud-procedimento
&Scoped-define FIRST-DISPLAYED-TABLE tt-aud-procedimento
&Scoped-define SECOND-DISPLAYED-TABLE tt-nc-aud-procedimento
&Scoped-Define DISPLAYED-OBJECTS c-des-nao-confor fi-lb-observacao 

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

DEFINE VARIABLE c-des-nao-confor AS CHARACTER FORMAT "x(50)" 
     VIEW-AS FILL-IN 
     SIZE 52 BY .88 NO-UNDO.

DEFINE VARIABLE fi-lb-observacao AS CHARACTER FORMAT "X(256)":U INITIAL "Observa‡Æo" 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.5.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 10.25.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-aud-procedimento.nr-seq-aud-proced AT ROW 1.25 COL 28 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     tt-nc-aud-procedimento.nr-seq-nconfor AT ROW 2.25 COL 28 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     c-des-nao-confor AT ROW 2.25 COL 33.72 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     tt-nc-aud-procedimento.nr-cartao AT ROW 4 COL 41 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 22.57 BY .88
     tt-nc-aud-procedimento.descricao AT ROW 6.5 COL 3 NO-LABEL WIDGET-ID 10
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 86 BY 9
     btOK AT ROW 16.63 COL 2
     btSave AT ROW 16.63 COL 13
     btCancel AT ROW 16.63 COL 24
     btHelp AT ROW 16.63 COL 80
     fi-lb-observacao AT ROW 5.42 COL 2 NO-LABEL WIDGET-ID 14
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 16.38 COL 1
     RECT-12 AT ROW 3.75 COL 1 WIDGET-ID 8
     RECT-13 AT ROW 5.75 COL 1 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 79 ROW 1.5
         SIZE 5 BY .71
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-aud-procedimento T "?" NO-UNDO mgesp aud-procedimento
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-nc-aud-procedimento T "?" NO-UNDO mgesp nc-aud-procedimento
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-des-nao-confor IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-lb-observacao IN FRAME fpage0
   ALIGN-L                                                              */
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
    IF RETURN-VALUE = "OK":U then do:
        find first bf-aud-proced exclusive-lock
             where bf-aud-proced.nr-seq-aud-proced = {&ttParent}.nr-seq-aud-proced no-error.
        if avail bf-aud-proced then
            assign bf-aud-proced.log-aud-proced   = no.

        APPLY "CLOSE":U TO THIS-PROCEDURE.
    end.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN saveRecord IN THIS-PROCEDURE.

    if return-value = "OK":U then do:
        find first bf-aud-proced exclusive-lock
             where bf-aud-proced.nr-seq-aud-proced = {&ttParent}.nr-seq-aud-proced no-error.
        if avail bf-aud-proced then
            assign bf-aud-proced.log-aud-proced   = no.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-nc-aud-procedimento.nr-seq-nconfor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-nc-aud-procedimento.nr-seq-nconfor wMaintenanceNoNavigation
ON F5 OF tt-nc-aud-procedimento.nr-seq-nconfor IN FRAME fpage0 /* NÆo Conformidade */
DO:
  {method/ZoomFields.i &ProgramZoom="eszoom/z01es668.w"
                       &FieldZoom1="nr-seq-nconfor"
                       &FieldScreen1="tt-nc-aud-procedimento.nr-seq-nconfor"
                       &Frame1="fPage0"
                       &FieldZoom2="des-nao-confor"
                       &FieldScreen2="c-des-nao-confor"
                       &enableImplant="NO"
                       &Frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-nc-aud-procedimento.nr-seq-nconfor wMaintenanceNoNavigation
ON LEAVE OF tt-nc-aud-procedimento.nr-seq-nconfor IN FRAME fpage0 /* NÆo Conformidade */
DO:
    find first aq-nao-confor no-lock
         where aq-nao-confor.nr-seq-nconfor = input frame fPage0 tt-nc-aud-procedimento.nr-seq-nconfor no-error.
    if avail aq-nao-confor then
        assign c-des-nao-confor:screen-value in frame fPage0 = aq-nao-confor.des-nao-confor.
    else
        assign c-des-nao-confor:screen-value in frame fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-nc-aud-procedimento.nr-seq-nconfor wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-nc-aud-procedimento.nr-seq-nconfor IN FRAME fpage0 /* NÆo Conformidade */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-nc-aud-procedimento.nr-seq-nconfor:load-mouse-pointer("image/lupa.cur") IN FRAME fPage0.

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

    ASSIGN fi-lb-observacao:SCREEN-VALUE IN FRAME fPage0 = "Observa‡Æo".

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
    ASSIGN {&ttTable}.nr-seq-aud-proced = {&ttParent}.nr-seq-aud-proced.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

