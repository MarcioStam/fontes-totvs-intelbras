&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-auditoria-adicional NO-UNDO LIKE auditoria-adicional
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-auditoria-geral NO-UNDO LIKE auditoria-geral
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-auditoria-visual NO-UNDO LIKE auditoria-visual
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
{include/i-prgvrs.i ESAQP010C 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF*/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESAQP010C
&GLOBAL-DEFINE Version           1.00.00.000

&GLOBAL-DEFINE Folder            no
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-auditoria-adicional
&GLOBAL-DEFINE hDBOTable         h-DBOes673
&GLOBAL-DEFINE DBOTable          auditoria-adicional

&GLOBAL-DEFINE ttParent          tt-auditoria-geral
&GLOBAL-DEFINE DBOParentTable    auditoria-geral

&GLOBAL-DEFINE page0KeyFields    tt-auditoria-adicional.nr-seq-teste tt-auditoria-adicional.nr-serie
&GLOBAL-DEFINE page0Fields       tt-auditoria-adicional.det-teste tt-auditoria-adicional.narrativa[1] tt-auditoria-adicional.narrativa[2] tt-auditoria-adicional.narrativa[3] tt-auditoria-adicional.narrativa[4] tt-auditoria-adicional.narrativa[5] tt-auditoria-adicional.narrativa[6] cb-ind-sit-teste tt-auditoria-adicional.log-habilita-ns
&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       

&GLOBAL-DEFINE ttSon2           tt-auditoria-visual
&GLOBAL-DEFINE hDBOSon2         h-boes672
&GLOBAL-DEFINE DBOSon2Table     auditoria-visual
&GLOBAL-DEFINE DBOSon2Destroy   TRUE

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
define variable v_codigo_teste    as int           no-undo.
define variable wh-txt-1          as widget-handle no-undo.
define variable wh-txt-2          as widget-handle no-undo.
define variable wh-txt-3          as widget-handle no-undo.
define variable wh-txt-4          as widget-handle no-undo.
define variable wh-txt-5          as widget-handle no-undo.
define variable wh-txt-6          as widget-handle no-undo.
define variable h-esaqp010b       as handle        no-undo.
define variable l-cadastrou-prob  as logical       no-undo.

define new global shared variable l-cadteste-chamador as log            no-undo.
define new global shared variable h-prog-chamador     as handle         no-undo.

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
&Scoped-Define ENABLED-FIELDS tt-auditoria-adicional.nr-seq-teste ~
tt-auditoria-adicional.nr-serie tt-auditoria-adicional.log-habilita-ns ~
tt-auditoria-adicional.det-teste tt-auditoria-adicional.narrativa[1] ~
tt-auditoria-adicional.narrativa[2] tt-auditoria-adicional.narrativa[3] ~
tt-auditoria-adicional.narrativa[4] tt-auditoria-adicional.narrativa[5] ~
tt-auditoria-adicional.narrativa[6] 
&Scoped-define ENABLED-TABLES tt-auditoria-adicional
&Scoped-define FIRST-ENABLED-TABLE tt-auditoria-adicional
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar RECT-17 cb-ind-sit-teste ~
btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-auditoria-adicional.nr-seq-teste ~
tt-auditoria-adicional.nr-serie tt-auditoria-adicional.log-habilita-ns ~
tt-auditoria-adicional.det-teste tt-auditoria-adicional.narrativa[1] ~
tt-auditoria-adicional.narrativa[2] tt-auditoria-adicional.narrativa[3] ~
tt-auditoria-adicional.narrativa[4] tt-auditoria-adicional.narrativa[5] ~
tt-auditoria-adicional.narrativa[6] 
&Scoped-define DISPLAYED-TABLES tt-auditoria-adicional
&Scoped-define FIRST-DISPLAYED-TABLE tt-auditoria-adicional
&Scoped-Define DISPLAYED-OBJECTS des-teste cb-ind-sit-teste 

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

DEFINE VARIABLE cb-ind-sit-teste AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 1 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEM-PAIRS "OK",1,
                     "NÇO OK",2,
                     "AGUARDANDO",3
     DROP-DOWN-LIST
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE des-teste AS CHARACTER FORMAT "X(70)":U 
     VIEW-AS FILL-IN 
     SIZE 65 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 15.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-auditoria-adicional.nr-seq-teste AT ROW 1.5 COL 10.57 COLON-ALIGNED WIDGET-ID 46
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     des-teste AT ROW 1.5 COL 19.57 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     cb-ind-sit-teste AT ROW 2.5 COL 10.57 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     tt-auditoria-adicional.nr-serie AT ROW 2.5 COL 54.57 COLON-ALIGNED WIDGET-ID 6
          LABEL "Rastreabilidade"
          VIEW-AS FILL-IN 
          SIZE 30 BY .88
     tt-auditoria-adicional.log-habilita-ns AT ROW 2.58 COL 31.14 WIDGET-ID 52
          VIEW-AS TOGGLE-BOX
          SIZE 10 BY .83
     tt-auditoria-adicional.det-teste AT ROW 4.21 COL 10 NO-LABEL WIDGET-ID 42
          VIEW-AS EDITOR
          SIZE 80 BY 2
     tt-auditoria-adicional.narrativa[1] AT ROW 7.38 COL 2 NO-LABEL WIDGET-ID 14
          VIEW-AS EDITOR
          SIZE 88 BY 1.75
     tt-auditoria-adicional.narrativa[2] AT ROW 9.75 COL 2 NO-LABEL WIDGET-ID 16
          VIEW-AS EDITOR
          SIZE 88 BY 1.75
     tt-auditoria-adicional.narrativa[3] AT ROW 12.17 COL 2 NO-LABEL WIDGET-ID 18
          VIEW-AS EDITOR
          SIZE 88 BY 1.75
     tt-auditoria-adicional.narrativa[4] AT ROW 14.58 COL 2 NO-LABEL WIDGET-ID 20
          VIEW-AS EDITOR
          SIZE 88 BY 1.75
     tt-auditoria-adicional.narrativa[5] AT ROW 16.96 COL 2 NO-LABEL WIDGET-ID 22
          VIEW-AS EDITOR
          SIZE 88 BY 1.75
     tt-auditoria-adicional.narrativa[6] AT ROW 19.5 COL 2 NO-LABEL WIDGET-ID 24
          VIEW-AS EDITOR
          SIZE 88 BY 1.75
     btOK AT ROW 22.13 COL 2
     btSave AT ROW 22.13 COL 13
     btCancel AT ROW 22.13 COL 24
     btHelp AT ROW 22.13 COL 80
     "Observ.:" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 4.21 COL 4 WIDGET-ID 56
     "Situa‡Æo:" VIEW-AS TEXT
          SIZE 6.57 BY .54 AT ROW 2.63 COL 6 WIDGET-ID 54
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 21.88 COL 1
     RECT-17 AT ROW 6.5 COL 1 WIDGET-ID 44
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 23.08
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-auditoria-adicional T "?" NO-UNDO mgesp auditoria-adicional
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-auditoria-geral T "?" NO-UNDO mgesp auditoria-geral
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-auditoria-visual T "?" NO-UNDO mgesp auditoria-visual
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
         HEIGHT             = 23.08
         WIDTH              = 90
         MAX-HEIGHT         = 23.08
         MAX-WIDTH          = 100.86
         VIRTUAL-HEIGHT     = 23.08
         VIRTUAL-WIDTH      = 100.86
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
/* SETTINGS FOR FILL-IN des-teste IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-auditoria-adicional.nr-serie IN FRAME fpage0
   EXP-LABEL                                                            */
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
    
    if l-cadastrou-prob then do:
        RUN utp/ut-msgs.p (INPUT "SHOW", 
                           INPUT 15825, 
                           INPUT "Os problemas cadastrados para o teste com status NOK devem ser eliminados.").

    end.

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
    ASSIGN tt-auditoria-adicional.ind-sit-teste = INPUT FRAME fPage0 cb-ind-sit-teste.

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
    ASSIGN tt-auditoria-adicional.ind-sit-teste = INPUT FRAME fPage0 cb-ind-sit-teste.
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN
        ASSIGN tt-auditoria-adicional.nr-seq-teste:SCREEN-VALUE = "0"
               des-teste                          :SCREEN-VALUE = ""
               tt-auditoria-adicional.nr-serie    :SCREEN-VALUE = ""
               cb-ind-sit-teste                   :SCREEN-VALUE = "1"
               tt-auditoria-adicional.det-teste   :SCREEN-VALUE = ""
               tt-auditoria-adicional.narrativa[1]:SCREEN-VALUE = ""
               tt-auditoria-adicional.narrativa[2]:SCREEN-VALUE = ""
               tt-auditoria-adicional.narrativa[3]:SCREEN-VALUE = ""
               tt-auditoria-adicional.narrativa[4]:SCREEN-VALUE = "" 
               tt-auditoria-adicional.narrativa[5]:SCREEN-VALUE = ""
               tt-auditoria-adicional.narrativa[6]:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ind-sit-teste
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ind-sit-teste wMaintenanceNoNavigation
ON VALUE-CHANGED OF cb-ind-sit-teste IN FRAME fpage0
DO:
    if input frame fPage0 cb-ind-sit-teste = 2 then do:
        assign wMaintenanceNoNavigation:sensitive = no.
        run esp/aqp/esaqp010b.w persistent set h-esaqp010b (input ?,
                                                            input prParent,
                                                            input "ADD",
                                                            input phCaller,
                                                            input 2).
        run pi-prog-chamador in h-esaqp010b (input yes,
                                             input this-procedure).

        run esp/aqp/esaqp010b.w (input ?,
                                 input prParent,
                                 input "ADD",
                                 input phCaller,
                                 input 2).

        
                           
        assign wMaintenanceNoNavigation:sensitive = yes
               h-esaqp010b = ?.
    end.
    else do:
        if l-cadastrou-prob then do:
            RUN utp/ut-msgs.p (INPUT "SHOW", 
                               INPUT 15825, 
                               INPUT "Os problemas cadastrados para o teste com status NOK devem ser eliminados.").
        
        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-auditoria-adicional.log-habilita-ns
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-adicional.log-habilita-ns wMaintenanceNoNavigation
ON VALUE-CHANGED OF tt-auditoria-adicional.log-habilita-ns IN FRAME fpage0 /* Habilita NS */
DO:
    IF NOT SELF:CHECKED THEN DO:
        ASSIGN tt-auditoria-adicional.nr-serie:SCREEN-VALUE IN FRAME fPage0 = ""
               tt-auditoria-adicional.nr-serie:SENSITIVE IN FRAME fPage0 = NO.
    END.
    ELSE DO:
        ASSIGN tt-auditoria-adicional.nr-serie:SENSITIVE IN FRAME fPage0 = YES.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-auditoria-adicional.nr-seq-teste
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-adicional.nr-seq-teste wMaintenanceNoNavigation
ON F5 OF tt-auditoria-adicional.nr-seq-teste IN FRAME fpage0 /* Teste */
DO:
   {method/ZoomFields.i &ProgramZoom="eszoom/Z01ES676.w"
                        &FieldZoom1="nr-seq-teste"
                        &FieldScreen1="tt-auditoria-adicional.nr-seq-teste"
                        &Frame1="fPage0"
                        &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-adicional.nr-seq-teste wMaintenanceNoNavigation
ON LEAVE OF tt-auditoria-adicional.nr-seq-teste IN FRAME fpage0 /* Teste */
DO:
    ASSIGN INPUT FRAME fPage0 tt-auditoria-adicional.nr-seq-teste.

    FIND FIRST aq-teste NO-LOCK
         WHERE aq-teste.nr-seq-teste = tt-auditoria-adicional.nr-seq-teste NO-ERROR.

    IF AVAIL aq-teste THEN
        ASSIGN des-teste:SCREEN-VALUE IN FRAME fPage0 = aq-teste.des-teste.
    ELSE 
        ASSIGN des-teste:SCREEN-VALUE IN FRAME fPage0 = "".

    RUN pi-ativa-campos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-adicional.nr-seq-teste wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-auditoria-adicional.nr-seq-teste IN FRAME fpage0 /* Teste */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-auditoria-adicional.nr-seq-teste:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage0.

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
    define variable v_popula_cb as char no-undo.
    
/*     for each aq-teste no-lock                                                                                                      */
/*     break by aq-teste.des-teste:                                                                                                   */
/*         if first-of(aq-teste.des-teste) then                                                                                       */
/*             assign v_codigo_teste = aq-teste.nr-seq-teste.                                                                         */
/*                                                                                                                                    */
/*         assign v_popula_cb = v_popula_cb + aq-teste.des-teste + "," + string(aq-teste.nr-seq-teste) + ",".                         */
/*     end.                                                                                                                           */
/*     assign tt-auditoria-adicional.nr-seq-teste:list-item-pairs in frame fPage0 = substring(v_popula_cb,1,LENGTH(v_popula_cb) - 1). */
    
    
    if  pcAction = "ADD" then
        assign tt-auditoria-adicional.nr-seq-teste:screen-value in frame fPage0 = string(v_codigo_teste)
               cb-ind-sit-teste:screen-value in frame fPage0 = "1"
               tt-auditoria-adicional.log-habilita-ns:CHECKED in frame fPage0 = YES.
    else
        assign tt-auditoria-adicional.nr-seq-teste:screen-value in frame fPage0 = string(tt-auditoria-adicional.nr-seq-teste)
               tt-auditoria-adicional.log-habilita-ns:CHECKED in frame fPage0 = tt-auditoria-adicional.log-habilita-ns
               cb-ind-sit-teste:SCREEN-VALUE IN FRAME fPage0 = STRING(tt-auditoria-adicional.ind-sit-teste)
               tt-auditoria-adicional.nr-serie:screen-value in frame fPage0 = string(tt-auditoria-adicional.nr-serie)
               tt-auditoria-adicional.det-teste:screen-value in frame fPage0 = string(tt-auditoria-adicional.det-teste)
               tt-auditoria-adicional.narrativa[1]:screen-value in frame fPage0 = string(tt-auditoria-adicional.narrativa[1])
               tt-auditoria-adicional.narrativa[2]:screen-value in frame fPage0 = string(tt-auditoria-adicional.narrativa[2])
               tt-auditoria-adicional.narrativa[3]:screen-value in frame fPage0 = string(tt-auditoria-adicional.narrativa[3])
               tt-auditoria-adicional.narrativa[4]:screen-value in frame fPage0 = string(tt-auditoria-adicional.narrativa[4])
               tt-auditoria-adicional.narrativa[5]:screen-value in frame fPage0 = string(tt-auditoria-adicional.narrativa[5])
               tt-auditoria-adicional.narrativa[6]:screen-value in frame fPage0 = string(tt-auditoria-adicional.narrativa[6]).
    
    apply 'leave' to tt-auditoria-adicional.nr-seq-teste.
    apply 'value-changed' to tt-auditoria-adicional.log-habilita-ns.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroyInterface wMaintenanceNoNavigation 
PROCEDURE beforeDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

assign l-cadteste-chamador = no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayFields wMaintenanceNoNavigation 
PROCEDURE beforeDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if  pcAction = "ADD" then
        assign tt-auditoria-adicional.nr-seq-teste:screen-value in frame fPage0 = string(v_codigo_teste).
    else
        assign tt-auditoria-adicional.nr-seq-teste:screen-value in frame fPage0 = string(tt-auditoria-adicional.nr-seq-teste).

    return "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ativa-campos wMaintenanceNoNavigation 
PROCEDURE pi-ativa-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DO WITH FRAME fPage0:
    
        define variable h-frame as handle no-undo.
    
        IF VALID-HANDLE(wh-txt-1) THEN
            ASSIGN wh-txt-1:screen-value = ""
                   tt-auditoria-adicional.narrativa[1]:screen-value = "".
        IF VALID-HANDLE(wh-txt-2) THEN
            ASSIGN wh-txt-2:screen-value = ""
                   tt-auditoria-adicional.narrativa[2]:screen-value = "".
        IF VALID-HANDLE(wh-txt-3) THEN
            ASSIGN wh-txt-3:screen-value = ""
                   tt-auditoria-adicional.narrativa[3]:screen-value = "".
        IF VALID-HANDLE(wh-txt-4) THEN
            ASSIGN wh-txt-4:screen-value = ""
                   tt-auditoria-adicional.narrativa[4]:screen-value = "".
        IF VALID-HANDLE(wh-txt-5) THEN
            ASSIGN wh-txt-5:screen-value = ""
                   tt-auditoria-adicional.narrativa[5]:screen-value = "".
        IF VALID-HANDLE(wh-txt-6) THEN
            ASSIGN wh-txt-6:screen-value = ""
                   tt-auditoria-adicional.narrativa[6]:screen-value = "".
    
        find first aq-teste no-lock
             where aq-teste.nr-seq-teste = input frame fPage0 tt-auditoria-adicional.nr-seq-teste no-error.
        if avail aq-teste then do:
            assign h-frame = frame fPage0:handle.
            
            if aq-teste.auditoria[1] <> "" then do:
                create text wh-txt-1
                assign frame        = h-frame
                       format       = "x(30)"
                       width        = 30
                       height       = 0.54
                       screen-value = aq-teste.auditoria[1]
                       row          = 6.8
                       col          = 3
                       fgcolor      = 0
                       visible      = yes.
    
                assign tt-auditoria-adicional.narrativa[1]:sensitive in frame fPage0 = yes.
            end.
            else
                assign tt-auditoria-adicional.narrativa[1]:sensitive in frame fPage0 = no.
                
            if aq-teste.auditoria[2] <> "" then do:
                create text wh-txt-2
                assign frame        = h-frame
                       format       = "x(30)"
                       width        = 30
                       height       = 0.54
                       screen-value = aq-teste.auditoria[2]
                       row          = 9.13
                       col          = 3
                       fgcolor      = 0
                       visible      = yes.
    
                assign tt-auditoria-adicional.narrativa[2]:sensitive in frame fPage0 = yes.
            end.
            else
                assign tt-auditoria-adicional.narrativa[2]:sensitive in frame fPage0 = no.
    
            if aq-teste.auditoria[3] <> "" then do:
                create text wh-txt-3
                assign frame        = h-frame
                       format       = "x(30)"
                       width        = 30
                       height       = 0.54
                       screen-value = aq-teste.auditoria[3]
                       row          = 11.55
                       col          = 3
                       fgcolor      = 0
                       visible      = yes.
    
                assign tt-auditoria-adicional.narrativa[3]:sensitive in frame fPage0 = yes.
            end.
            else
                assign tt-auditoria-adicional.narrativa[3]:sensitive in frame fPage0 = no.
    
            if aq-teste.auditoria[4] <> "" then do:
                create text wh-txt-4
                assign frame        = h-frame
                       format       = "x(30)"
                       width        = 30
                       height       = 0.54
                       screen-value = aq-teste.auditoria[4]
                       row          = 14.00
                       col          = 3
                       fgcolor      = 0
                       visible      = yes.
    
                assign tt-auditoria-adicional.narrativa[4]:sensitive in frame fPage0 = yes.
            end.
            else
                assign tt-auditoria-adicional.narrativa[4]:sensitive in frame fPage0 = no.
                
            if aq-teste.auditoria[5] <> "" then do:
                create text wh-txt-5
                assign frame        = h-frame
                       format       = "x(30)"
                       width        = 30
                       height       = 0.54
                       screen-value = aq-teste.auditoria[5]
                       row          = 16.40
                       col          = 3
                       fgcolor      = 0
                       visible      = yes.
    
                assign tt-auditoria-adicional.narrativa[5]:sensitive in frame fPage0 = yes.
            end.
            else
                assign tt-auditoria-adicional.narrativa[5]:sensitive in frame fPage0 = no.
                
            if aq-teste.auditoria[6] <> "" then do:
                create text wh-txt-6
                assign frame        = h-frame
                       format       = "x(30)"
                       width        = 30
                       height       = 0.54
                       screen-value = aq-teste.auditoria[6]
                       row          = 18.95
                       col          = 3
                       fgcolor      = 0
                       visible      = yes.
    
                assign tt-auditoria-adicional.narrativa[6]:sensitive in frame fPage0 = yes.
            end.
            else
                assign tt-auditoria-adicional.narrativa[6]:sensitive in frame fPage0 = no.
        end.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-log-prob wMaintenanceNoNavigation 
PROCEDURE pi-atualiza-log-prob :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input param p-cadastrou-prob as log no-undo.

assign l-cadastrou-prob = p-cadastrou-prob.

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

    assign tt-auditoria-adicional.nr-seq-auditoria = tt-auditoria-geral.nr-seq-auditoria.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

