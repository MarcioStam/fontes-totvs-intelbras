&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-aud-procedimento NO-UNDO LIKE aud-procedimento
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
{include/i-prgvrs.i ESAQP009A 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESAQP009A
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-aud-procedimento
&GLOBAL-DEFINE hDBOTable         h-boes669
&GLOBAL-DEFINE DBOTable          aud-procedimento

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       tt-aud-procedimento.cod-estabel ~
                                 tt-aud-procedimento.nr-seq-setor ~
                                 tt-aud-procedimento.cod-unid-negoc ~
                                 tt-aud-procedimento.nr-seq-procedimento ~
                                 tt-aud-procedimento.dt-auditoria ~
                                 tt-aud-procedimento.des-auditor ~
                                 tt-aud-procedimento.observacao

&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
/*DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.*/
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
/*DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.*/

/* Local Variable Definitions ---                                       */

define buffer bf-aud-procedimento for aud-procedimento.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
define variable h-boin745     as handle    no-undo.
define variable c-desc-uneg   as character no-undo.

def new Global shared var c-seg-usuario  as char format "x(12)" no-undo.

def new global shared var v_cod_estab_usuar
    as character
    format "x(3)"
    label "Estabelecimento"
    column-label "Estab"
    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-aud-procedimento.cod-estabel ~
tt-aud-procedimento.log-aud-proced tt-aud-procedimento.nr-seq-setor ~
tt-aud-procedimento.cod-unid-negoc tt-aud-procedimento.nr-seq-procedimento ~
tt-aud-procedimento.dt-auditoria tt-aud-procedimento.des-auditor ~
tt-aud-procedimento.observacao 
&Scoped-define ENABLED-TABLES tt-aud-procedimento
&Scoped-define FIRST-ENABLED-TABLE tt-aud-procedimento
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar RECT-12 RECT-13 btOK btSave ~
btCancel btHelp fi-lb-observacao 
&Scoped-Define DISPLAYED-FIELDS tt-aud-procedimento.cod-estabel ~
tt-aud-procedimento.log-aud-proced tt-aud-procedimento.nr-seq-aud-proced ~
tt-aud-procedimento.nr-seq-setor tt-aud-procedimento.cod-unid-negoc ~
tt-aud-procedimento.nr-seq-procedimento tt-aud-procedimento.dt-auditoria ~
tt-aud-procedimento.des-auditor tt-aud-procedimento.observacao 
&Scoped-define DISPLAYED-TABLES tt-aud-procedimento
&Scoped-define FIRST-DISPLAYED-TABLE tt-aud-procedimento
&Scoped-Define DISPLAYED-OBJECTS fi-desc-estabel v_des_setor ~
v_des_unid_negoc v_des_procedimento fi-lb-observacao 

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

DEFINE VARIABLE fi-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-lb-observacao AS CHARACTER FORMAT "X(256)":U INITIAL "Observa‡Æo" 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE VARIABLE v_des_procedimento AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 41.72 BY .88.

DEFINE VARIABLE v_des_setor AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 41.72 BY .88 NO-UNDO.

DEFINE VARIABLE v_des_unid_negoc AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 44.72 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.5.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.5.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-aud-procedimento.cod-estabel AT ROW 1.25 COL 29 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     fi-desc-estabel AT ROW 1.25 COL 36.29 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     tt-aud-procedimento.log-aud-proced AT ROW 2.25 COL 31 WIDGET-ID 20
          LABEL "Auditoria OK"
          VIEW-AS TOGGLE-BOX
          SIZE 11.57 BY .83
     tt-aud-procedimento.nr-seq-aud-proced AT ROW 2.25 COL 78 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     tt-aud-procedimento.nr-seq-setor AT ROW 4 COL 29 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     v_des_setor AT ROW 4 COL 37.29 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     tt-aud-procedimento.cod-unid-negoc AT ROW 5 COL 29 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     v_des_unid_negoc AT ROW 5 COL 34.29 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     tt-aud-procedimento.nr-seq-procedimento AT ROW 6 COL 29 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     v_des_procedimento AT ROW 6 COL 37.14 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     tt-aud-procedimento.dt-auditoria AT ROW 7 COL 29 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-aud-procedimento.des-auditor AT ROW 8 COL 29 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 22.57 BY .88
     tt-aud-procedimento.observacao AT ROW 10.5 COL 10 NO-LABEL WIDGET-ID 66
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 68 BY 4.5
     btOK AT ROW 16 COL 2
     btSave AT ROW 16 COL 13
     btCancel AT ROW 16 COL 24
     btHelp AT ROW 16 COL 80
     fi-lb-observacao AT ROW 9.67 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 15.75 COL 1
     RECT-12 AT ROW 3.75 COL 1 WIDGET-ID 18
     RECT-13 AT ROW 10 COL 1 WIDGET-ID 62
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.33
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
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.33
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
/* SETTINGS FOR FILL-IN fi-desc-estabel IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tt-aud-procedimento.log-aud-proced IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-aud-procedimento.nr-seq-aud-proced IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       tt-aud-procedimento.nr-seq-aud-proced:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FILL-IN v_des_procedimento IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v_des_setor IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v_des_unid_negoc IN FRAME fpage0
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
    if pcAction <> "UPDATE" then do:
        find last bf-aud-procedimento no-lock no-error.
        if avail bf-aud-procedimento then
            assign tt-aud-procedimento.nr-seq-aud-proced:screen-value in frame fPage0 = string(bf-aud-procedimento.nr-seq-aud-proced + 1).
        else
            assign tt-aud-procedimento.nr-seq-aud-proced:screen-value in frame fPage0 = "1".
    end.

    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U then
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    if pcAction <> "UPDATE" then do:
        find last bf-aud-procedimento no-lock no-error.
        if avail bf-aud-procedimento then
            assign tt-aud-procedimento.nr-seq-aud-proced:screen-value in frame fPage0 = string(bf-aud-procedimento.nr-seq-aud-proced + 1).
        else
            assign tt-aud-procedimento.nr-seq-aud-proced:screen-value in frame fPage0 = "1".
    end.

    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-aud-procedimento.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aud-procedimento.cod-estabel wMaintenanceNoNavigation
ON F5 OF tt-aud-procedimento.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:

    {method/ZoomFields.i &ProgramZoom="adzoom/z06ad107.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="tt-aud-procedimento.cod-estabel"
                         &FieldZoom2="nome"
                         &FieldScreen2="fi-desc-estabel"
                         &Frame1="fPage0"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aud-procedimento.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-aud-procedimento.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    ASSIGN fi-desc-estabel:SCREEN-VALUE IN FRAME fPage0 = "".

    FOR FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = INPUT FRAME fPage0 tt-aud-procedimento.cod-estabel:
        ASSIGN fi-desc-estabel:SCREEN-VALUE IN FRAME fPage0 = estabelec.nome.           
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aud-procedimento.cod-estabel wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-aud-procedimento.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-aud-procedimento.cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aud-procedimento.cod-unid-negoc wMaintenanceNoNavigation
ON F5 OF tt-aud-procedimento.cod-unid-negoc IN FRAME fpage0 /* Unidade de Neg¢cio */
DO:

    {method/ZoomFields.i &ProgramZoom="inzoom/z01in745.w"
                         &FieldZoom1="cod-unid-negoc"
                         &FieldScreen1="tt-aud-procedimento.cod-unid-negoc"
                         &FieldZoom2="des-unid-negoc"
                         &FieldScreen2="v_des_unid_negoc"
                         &Frame1="fpage0"
                         &Frame2="fpage0"
                         &EnableImplant="YES"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aud-procedimento.cod-unid-negoc wMaintenanceNoNavigation
ON LEAVE OF tt-aud-procedimento.cod-unid-negoc IN FRAME fpage0 /* Unidade de Neg¢cio */
DO:
    run SetConstraintCodigo in h-boin745(input input frame fPage0 tt-aud-procedimento.cod-unid-negoc,
                                         input input frame fPage0 tt-aud-procedimento.cod-unid-negoc).
    run openQueryStatic     in h-boin745(input "Codigo":U).
    if return-value = "OK" then do:
        run getCharField in h-boin745(input "des-unid-negoc",
                                      output c-desc-uneg).
        assign v_des_unid_negoc:screen-value in frame fPage0 = c-desc-uneg. 
    end.
    else
        assign v_des_unid_negoc:screen-value in frame fPage0 = "". 
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aud-procedimento.cod-unid-negoc wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-aud-procedimento.cod-unid-negoc IN FRAME fpage0 /* Unidade de Neg¢cio */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-aud-procedimento.nr-seq-procedimento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aud-procedimento.nr-seq-procedimento wMaintenanceNoNavigation
ON F5 OF tt-aud-procedimento.nr-seq-procedimento IN FRAME fpage0 /* Procedimento */
DO:

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es667.w"
                         &FieldZoom1="nr-seq-procedimento"
                         &FieldScreen1="tt-aud-procedimento.nr-seq-procedimento"
                         &FieldZoom2="des-procedimento"
                         &FieldScreen2="v_des_procedimento"
                         &Frame1="fpage0"
                         &Frame2="fpage0"
                         &RunMethod="run setaFiltro in hProgramZoom (input frame fPage0 tt-aud-procedimento.nr-seq-setor)."
                         &EnableImplant="YES"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aud-procedimento.nr-seq-procedimento wMaintenanceNoNavigation
ON LEAVE OF tt-aud-procedimento.nr-seq-procedimento IN FRAME fpage0 /* Procedimento */
DO:
    FIND FIRST aq-procedimento NO-LOCK
         WHERE aq-procedimento.nr-seq-procedimento = INPUT FRAME fPage0 tt-aud-procedimento.nr-seq-procedimento 
           and aq-procedimento.nr-seq-setor        = input frame fPage0 tt-aud-procedimento.nr-seq-setor NO-ERROR.
    IF AVAIL aq-procedimento THEN
        ASSIGN v_des_procedimento:SCREEN-VALUE IN FRAME fPage0 = aq-procedimento.des-procedimento.
    ELSE
        ASSIGN v_des_procedimento:SCREEN-VALUE IN FRAME fPage0 = "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aud-procedimento.nr-seq-procedimento wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-aud-procedimento.nr-seq-procedimento IN FRAME fpage0 /* Procedimento */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-aud-procedimento.nr-seq-setor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aud-procedimento.nr-seq-setor wMaintenanceNoNavigation
ON F5 OF tt-aud-procedimento.nr-seq-setor IN FRAME fpage0 /* Setor Auditado */
DO:

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es666.w"
                         &FieldZoom1="nr-seq-setor"
                         &FieldScreen1="tt-aud-procedimento.nr-seq-setor"
                         &FieldZoom2="des-setor"
                         &FieldScreen2="v_des_setor"
                         &Frame1="fPage0"
                         &Frame2="fPage0"
                         &EnableImplant="YES"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aud-procedimento.nr-seq-setor wMaintenanceNoNavigation
ON LEAVE OF tt-aud-procedimento.nr-seq-setor IN FRAME fpage0 /* Setor Auditado */
DO:
    find first aq-setor no-lock
         where aq-setor.nr-seq-setor = input frame fPage0 tt-aud-procedimento.nr-seq-setor no-error.
    if avail aq-setor then
        assign v_des_setor:screen-value in frame fPage0 = aq-setor.des-setor.
    else  
      assign v_des_setor:screen-value in frame fPage0 = "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aud-procedimento.nr-seq-setor wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-aud-procedimento.nr-seq-setor IN FRAME fpage0 /* Setor Auditado */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-aud-procedimento.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-aud-procedimento.nr-seq-setor:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-aud-procedimento.cod-unid-negoc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-aud-procedimento.nr-seq-procedimento:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

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
    case pcAction:
        when "ADD" then
            assign tt-aud-procedimento.cod-estabel:SCREEN-VALUE in frame fPage0 = v_cod_estab_usuar
                   tt-aud-procedimento.log-aud-proced:checked in frame fPage0 = yes
                   tt-aud-procedimento.dt-auditoria:screen-value in frame fPage0 = string(today)
                   tt-aud-procedimento.des-auditor:screen-value in frame fPage0 = c-seg-usuario.
        when "COPY" then
            assign tt-aud-procedimento.cod-estabel:SCREEN-VALUE in frame fPage0 = tt-aud-procedimento.cod-estabel
                   tt-aud-procedimento.log-aud-proced:checked in frame fPage0 = yes.
        when "UPDATE" then
            assign tt-aud-procedimento.cod-estabel:SCREEN-VALUE in frame fPage0 = tt-aud-procedimento.cod-estabel               
                   tt-aud-procedimento.log-aud-proced:checked in frame fPage0 = tt-aud-procedimento.log-aud-proced
                   tt-aud-procedimento.nr-seq-aud-proced:screen-value in frame fPage0 = string(tt-aud-procedimento.nr-seq-aud-proced).
    end case.
    
    assign tt-aud-procedimento.log-aud-proced:sensitive in frame fPage0 = no.

    disp tt-aud-procedimento.log-aud-proced.

    APPLY "LEAVE" TO tt-aud-procedimento.cod-estabel.
    APPLY "LEAVE" TO tt-aud-procedimento.nr-seq-setor.
    APPLY "LEAVE" TO tt-aud-procedimento.cod-unid-negoc.
    APPLY "LEAVE" TO tt-aud-procedimento.nr-seq-procedimento.

    ASSIGN fi-lb-observacao:SCREEN-VALUE = "Observa‡Æo".

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
IF AVAIL tt-aud-procedimento then
    ASSIGN tt-aud-procedimento.nr-seq-aud-proced = input frame fPage0 tt-aud-procedimento.nr-seq-aud-proced.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if not valid-handle(h-boin745) then
        run inbo/boin745.p persistent set h-boin745.

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
    assign tt-aud-procedimento.log-aud-proced = tt-aud-procedimento.log-aud-proced:checked in frame fPage0.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

