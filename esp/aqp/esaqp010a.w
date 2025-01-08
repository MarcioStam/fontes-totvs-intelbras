&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-auditoria-geral NO-UNDO LIKE auditoria-geral
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
{include/i-prgvrs.i ESAQP010A 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESAQP010A
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-auditoria-geral
&GLOBAL-DEFINE hDBOTable         h-boes671
&GLOBAL-DEFINE DBOTable          auditoria-geral


&GLOBAL-DEFINE page0KeyFields     
&GLOBAL-DEFINE page0Fields       tt-auditoria-geral.cod-estabel tt-auditoria-geral.it-codigo ~
                                 tt-auditoria-geral.dt-amostragem tt-auditoria-geral.qt-apar-test ~
                                 tt-auditoria-geral.nr-seq-tipo-lote ~
                                 tt-auditoria-geral.qt-prod-lote tt-auditoria-geral.qt-problema~
                                 tt-auditoria-geral.descricao ~ tt-auditoria-geral.log-double-sample ~
                                 tt-auditoria-geral.nr-linha tt-auditoria-geral.sigla cb-turno

/*&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields*/

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
/*DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.*/
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
/*DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.*/

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

DEFINE VARIABLE wh-pesquisa AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

def new Global shared var c-seg-usuario  as char format "x(12)" no-undo.

def new global shared var v_cod_estab_usuar
    as character
    format "x(3)"
    label "Estabelecimento"
    column-label "Estabel"
    no-undo.

{esp/es0018.i}

DEFINE VARIABLE d-dt-limite-alt AS DATE        NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-auditoria-geral.sigla ~
tt-auditoria-geral.log-double-sample tt-auditoria-geral.cod-estabel ~
tt-auditoria-geral.it-codigo tt-auditoria-geral.cod-unid-negoc ~
tt-auditoria-geral.nr-linha tt-auditoria-geral.nr-seq-tipo-lote ~
tt-auditoria-geral.qt-apar-test tt-auditoria-geral.dt-amostragem ~
tt-auditoria-geral.qt-prod-lote tt-auditoria-geral.log-revisado ~
tt-auditoria-geral.qtd-prod-revis tt-auditoria-geral.log-bloqueio ~
tt-auditoria-geral.qtd-prod-bloq tt-auditoria-geral.descricao ~
tt-auditoria-geral.qt-problema 
&Scoped-define ENABLED-TABLES tt-auditoria-geral
&Scoped-define FIRST-ENABLED-TABLE tt-auditoria-geral
&Scoped-Define ENABLED-OBJECTS tg-lei-informatica fi-desc-estabel ~
fi-desc-produto fi-desc-unid-negoc fi-ge-codigo fi-desc-ge fi-desc-linha ~
fi-desc-tipo-lote btOK btSave btCancel btHelp cb-turno rtToolBar RECT-41 ~
RECT-42 
&Scoped-Define DISPLAYED-FIELDS tt-auditoria-geral.sigla ~
tt-auditoria-geral.log-double-sample tt-auditoria-geral.cod-estabel ~
tt-auditoria-geral.nr-seq-auditoria tt-auditoria-geral.it-codigo ~
tt-auditoria-geral.cod-audit-origem tt-auditoria-geral.des-auditor ~
tt-auditoria-geral.cont-reinspecao tt-auditoria-geral.cod-unid-negoc ~
tt-auditoria-geral.nr-linha tt-auditoria-geral.nr-seq-tipo-lote ~
tt-auditoria-geral.qt-apar-test tt-auditoria-geral.dt-amostragem ~
tt-auditoria-geral.qt-prod-lote tt-auditoria-geral.log-revisado ~
tt-auditoria-geral.qtd-prod-revis tt-auditoria-geral.log-bloqueio ~
tt-auditoria-geral.qtd-prod-bloq tt-auditoria-geral.descricao ~
tt-auditoria-geral.qt-problema 
&Scoped-define DISPLAYED-TABLES tt-auditoria-geral
&Scoped-define FIRST-DISPLAYED-TABLE tt-auditoria-geral
&Scoped-Define DISPLAYED-OBJECTS tg-lei-informatica fi-desc-estabel ~
fi-desc-produto rs-ind-amostragem fi-desc-unid-negoc fi-ge-codigo ~
fi-desc-ge fi-desc-linha fi-desc-tipo-lote cb-turno 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-turno-char wMaintenanceNoNavigation 
FUNCTION fn-turno-char RETURNS INTEGER
  ( pTurno AS CHAR /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-turno-int wMaintenanceNoNavigation 
FUNCTION fn-turno-int RETURNS CHAR
  ( pTurno AS INT /* parameter-definitions */ )  FORWARD.

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

DEFINE VARIABLE cb-turno AS CHARACTER FORMAT "X(20)" INITIAL "0" 
     LABEL "Turno" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "Geral","1§ Turno","2§ Turno","3§ Turno" 
     DROP-DOWN-LIST
     SIZE 16 BY 1.

DEFINE VARIABLE fi-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-ge AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-linha AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-produto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-tipo-lote AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-unid-negoc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ge-codigo AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Grupo Estoque" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE rs-ind-amostragem AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Di ria", 1,
"Reinspe‡Æo", 2,
"Acompanhamento", 3
     SIZE 38 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-41
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.5.

DEFINE RECTANGLE RECT-42
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 12.13.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89.57 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-lei-informatica AS LOGICAL INITIAL no 
     LABEL "Lei Inform tica" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 TOOLTIP "Lei Inform tica" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-auditoria-geral.sigla AT ROW 7.75 COL 76 COLON-ALIGNED WIDGET-ID 70
          LABEL "C‚lula"
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     tt-auditoria-geral.log-double-sample AT ROW 9.63 COL 47.29 WIDGET-ID 64
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .83
     tg-lei-informatica AT ROW 9.58 COL 33.14 WIDGET-ID 60
     tt-auditoria-geral.cod-estabel AT ROW 1.5 COL 19 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     fi-desc-estabel AT ROW 1.5 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     tt-auditoria-geral.nr-seq-auditoria AT ROW 1.5 COL 73 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-auditoria-geral.it-codigo AT ROW 2.5 COL 19 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     fi-desc-produto AT ROW 2.5 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     rs-ind-amostragem AT ROW 4.08 COL 19 NO-LABEL WIDGET-ID 28
     tt-auditoria-geral.cod-audit-origem AT ROW 4.08 COL 73 COLON-ALIGNED WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-auditoria-geral.des-auditor AT ROW 5 COL 17 COLON-ALIGNED WIDGET-ID 48
          LABEL "Auditor"
          VIEW-AS FILL-IN 
          SIZE 22.57 BY .88
     tt-auditoria-geral.cont-reinspecao AT ROW 5 COL 73 COLON-ALIGNED WIDGET-ID 46
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-auditoria-geral.cod-unid-negoc AT ROW 5.92 COL 17 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-desc-unid-negoc AT ROW 5.92 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     fi-ge-codigo AT ROW 6.83 COL 17 COLON-ALIGNED WIDGET-ID 32
     fi-desc-ge AT ROW 6.83 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     tt-auditoria-geral.nr-linha AT ROW 7.75 COL 17 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     fi-desc-linha AT ROW 7.75 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     tt-auditoria-geral.nr-seq-tipo-lote AT ROW 8.67 COL 17 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     fi-desc-tipo-lote AT ROW 8.67 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     tt-auditoria-geral.qt-apar-test AT ROW 9.58 COL 17 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-auditoria-geral.dt-amostragem AT ROW 10.5 COL 17 COLON-ALIGNED WIDGET-ID 50
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-auditoria-geral.qt-prod-lote AT ROW 11.42 COL 17 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-auditoria-geral.log-revisado AT ROW 10.5 COL 33.14 WIDGET-ID 22
          VIEW-AS TOGGLE-BOX
          SIZE 13 BY .83
     tt-auditoria-geral.qtd-prod-revis AT ROW 11.42 COL 43.29 COLON-ALIGNED WIDGET-ID 20
          LABEL "Qtde Revisada"
          VIEW-AS FILL-IN 
          SIZE 12.72 BY .88
     tt-auditoria-geral.log-bloqueio AT ROW 10.5 COL 47.29 WIDGET-ID 58
          LABEL "Lote Bloqueado"
          VIEW-AS TOGGLE-BOX
          SIZE 13 BY .83
     tt-auditoria-geral.qtd-prod-bloq AT ROW 12.33 COL 17 COLON-ALIGNED WIDGET-ID 56
          LABEL "Qtde Bloqueada"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-auditoria-geral.descricao AT ROW 13.25 COL 5 NO-LABEL WIDGET-ID 24
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 80 BY 2.5
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.72 BY 16.71
         FONT 1 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     btOK AT ROW 16.5 COL 2
     btSave AT ROW 16.5 COL 13
     btCancel AT ROW 16.5 COL 24
     btHelp AT ROW 16.5 COL 80
     cb-turno AT ROW 10.46 COL 67 COLON-ALIGNED WIDGET-ID 66
     tt-auditoria-geral.qt-problema AT ROW 12.33 COL 43.29 COLON-ALIGNED WIDGET-ID 72
          VIEW-AS FILL-IN 
          SIZE 12.72 BY .88
     rtToolBar AT ROW 16.25 COL 1
     RECT-41 AT ROW 1.25 COL 1 WIDGET-ID 52
     RECT-42 AT ROW 3.88 COL 1 WIDGET-ID 54
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.72 BY 16.71
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-auditoria-geral T "?" NO-UNDO mgesp auditoria-geral
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
         HEIGHT             = 16.67
         WIDTH              = 90.43
         MAX-HEIGHT         = 28
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28
         VIRTUAL-WIDTH      = 195.14
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN tt-auditoria-geral.cod-audit-origem IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-auditoria-geral.cont-reinspecao IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-auditoria-geral.des-auditor IN FRAME fpage0
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX tt-auditoria-geral.log-bloqueio IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-auditoria-geral.nr-seq-auditoria IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       tt-auditoria-geral.nr-seq-auditoria:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       tt-auditoria-geral.qt-problema:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN tt-auditoria-geral.qtd-prod-bloq IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-auditoria-geral.qtd-prod-revis IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR RADIO-SET rs-ind-amostragem IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-auditoria-geral.sigla IN FRAME fpage0
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
    IF pcAction = "ADD" OR
       pcAction = "COPY" THEN DO:
        find last auditoria-geral no-lock no-error.
        if avail auditoria-geral then
            assign tt-auditoria-geral.nr-seq-auditoria:screen-value in frame fPage0 = string(auditoria-geral.nr-seq-auditoria + 1).
        else
            assign tt-auditoria-geral.nr-seq-auditoria:screen-value in frame fPage0 = "1".
    end.

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
    IF pcAction = "ADD" OR
       pcAction = "COPY" THEN DO:
        find last auditoria-geral no-lock no-error.
        if avail auditoria-geral then
            assign tt-auditoria-geral.nr-seq-auditoria:screen-value in frame fPage0 = string(auditoria-geral.nr-seq-auditoria + 1).
        else
            assign tt-auditoria-geral.nr-seq-auditoria:screen-value in frame fPage0 = "1".
    end.

    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-auditoria-geral.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.cod-estabel wMaintenanceNoNavigation
ON F5 OF tt-auditoria-geral.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:

    {method/ZoomFields.i &ProgramZoom="adzoom/z12ad107.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="tt-auditoria-geral.cod-estabel"
                         &Frame1="fPage0"
                         &FieldZoom2="nome"
                         &FieldScreen2="fi-desc-estabel"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-auditoria-geral.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:

    ASSIGN fi-desc-estabel:SCREEN-VALUE IN FRAME fPage0 = "".

    FOR FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = INPUT FRAME fPage0 tt-auditoria-geral.cod-estabel:

        ASSIGN fi-desc-estabel:SCREEN-VALUE IN FRAME fPage0 = estabelec.nome.

    END.

    RUN pi-busca-linha.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.cod-estabel wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-auditoria-geral.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:

    APPLY "F5":U TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-auditoria-geral.cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.cod-unid-negoc wMaintenanceNoNavigation
ON F5 OF tt-auditoria-geral.cod-unid-negoc IN FRAME fpage0 /* Unidade Neg¢cio */
DO:

    {method/ZoomFields.i &ProgramZoom="inzoom/z01in745.w"
                         &FieldZoom1="cod-unid-negoc"
                         &FieldScreen1="tt-auditoria-geral.cod-unid-negoc"
                         &Frame1="fPage0"
                         &FieldZoom2="des-unid-negoc"
                         &FieldScreen2="fi-desc-unid-negoc"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.cod-unid-negoc wMaintenanceNoNavigation
ON LEAVE OF tt-auditoria-geral.cod-unid-negoc IN FRAME fpage0 /* Unidade Neg¢cio */
DO:

    ASSIGN fi-desc-unid-negoc:SCREEN-VALUE IN FRAME fPage0 = "".

    FOR FIRST unid-negoc NO-LOCK
        WHERE unid-negoc.cod-unid-negoc = INPUT FRAME fPage0 tt-auditoria-geral.cod-unid-negoc:

        ASSIGN fi-desc-unid-negoc:SCREEN-VALUE IN FRAME fPage0 = unid-negoc.des-unid-negoc.

    END.
    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.cod-unid-negoc wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-auditoria-geral.cod-unid-negoc IN FRAME fpage0 /* Unidade Neg¢cio */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ge-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ge-codigo wMaintenanceNoNavigation
ON F5 OF fi-ge-codigo IN FRAME fpage0 /* Grupo Estoque */
DO:

    {include/zoomvar.i &prog-zoom=inzoom/z01in142.w
                        &campo=fi-ge-codigo
                        &campozoom=ge-codigo}

        /*
    {include/zoomvar.i &prog-zoom="inzoom/z01in142.w"
                       &campo="fi-ge-codigo"
                       &campozoom="ge-codigo"
                       &frame="fPage0"
                       &campo2="fi-desc-ge"
                       &campozoom2="descricao"
                       &frame2="fPage0"}
                       */


        /*
    {method/ZoomFields.i &ProgramZoom="inzoom/z01in142.w"
                         &FieldZoom1="ge-codigo"
                         &FieldScreen1="fi-ge-codigo"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-desc-ge"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
                         */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ge-codigo wMaintenanceNoNavigation
ON LEAVE OF fi-ge-codigo IN FRAME fpage0 /* Grupo Estoque */
DO:

    ASSIGN fi-desc-ge:SCREEN-VALUE IN FRAME fpage0 = "".

    FOR FIRST grup-estoque NO-LOCK
        WHERE grup-estoque.ge-codigo = INPUT FRAME fpage0 fi-ge-codigo:

        ASSIGN fi-desc-ge:SCREEN-VALUE IN FRAME fpage0 = grup-estoque.descricao.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ge-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fi-ge-codigo IN FRAME fpage0 /* Grupo Estoque */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-auditoria-geral.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.it-codigo wMaintenanceNoNavigation
ON F5 OF tt-auditoria-geral.it-codigo IN FRAME fpage0 /* Produto */
DO:

    {method/ZoomFields.i &ProgramZoom="inzoom/z22in172.w"
                         &FieldZoom1="it-codigo"
                         &FieldScreen1="tt-auditoria-geral.it-codigo"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao-1"
                         &FieldScreen2="fi-desc-produto"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.it-codigo wMaintenanceNoNavigation
ON LEAVE OF tt-auditoria-geral.it-codigo IN FRAME fpage0 /* Produto */
DO:
    ASSIGN fi-desc-produto:SCREEN-VALUE IN FRAME fPage0 = "".

    IF INPUT FRAME fPage0 tt-auditoria-geral.it-codigo <> "" 
    THEN DO:
       FIND FIRST item-mat NO-LOCK
            WHERE item-mat.cod-ean =  INPUT FRAME fPage0 tt-auditoria-geral.it-codigo NO-ERROR.
      
       IF AVAIL item-mat THEN DO:
           ASSIGN tt-auditoria-geral.it-codigo:SCREEN-VALUE IN FRAME fPage0 = item-mat.it-codigo.
       END.
    END.

     ASSIGN tg-lei-informatica:BGCOLOR IN FRAME fPage0 = ?.

    FOR FIRST item NO-LOCK
        WHERE item.it-codigo = INPUT FRAME fPage0 tt-auditoria-geral.it-codigo:

        ASSIGN fi-desc-produto:SCREEN-VALUE IN FRAME fPage0 = item.desc-item
               fi-ge-codigo   :SCREEN-VALUE IN FRAME fPage0 = STRING(item.ge-codigo).

        FIND FIRST int-portaria-movto NO-LOCK
             WHERE int-portaria-movto.it-codigo = item.it-codigo
               AND int-portaria-movto.dt-fim = ?
               AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
        
        ASSIGN tg-lei-informatica:CHECKED IN FRAME fPage0 = AVAIL int-portaria-movto
               tg-lei-informatica:BGCOLOR IN FRAME fPage0 = IF AVAIL int-portaria-movto
                                                                THEN 12
                                                                ELSE ?.
    
    END.

/*     FOR FIRST item-uni-estab NO-LOCK                                                                       */
/*         WHERE item-uni-estab.cod-estabel = tt-auditoria-geral.cod-estabel:SCREEN-VALUE IN FRAME fPage0     */
/*           AND item-uni-estab.it-codigo   = tt-auditoria-geral.it-codigo  :SCREEN-VALUE IN FRAME fPage0:    */
/*                                                                                                            */
/*         ASSIGN tt-auditoria-geral.nr-linha:SCREEN-VALUE IN FRAME fPage0 = string(item-uni-estab.nr-linha). */
/*     END.                                                                                                   */

    IF  pcAction <> "UPDATE" THEN DO:
        FOR FIRST auditoria-lote NO-LOCK
            WHERE auditoria-lote.it-codigo = tt-auditoria-geral.it-codigo  :SCREEN-VALUE IN FRAME fPage0:
            
            ASSIGN tt-auditoria-geral.qt-prod-lote:SCREEN-VALUE IN FRAME fPage0 = STRING(auditoria-lote.qt-prod-lote)
                   tt-auditoria-geral.qt-apar-test:SCREEN-VALUE IN FRAME fPage0 = STRING(auditoria-lote.qt-apar-test). 
        END.
        ASSIGN tt-auditoria-geral.nr-seq-tipo-lote:SCREEN-VALUE IN FRAME fPage0 = "1".
    END.

    

    RUN pi-busca-linha.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.it-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-auditoria-geral.it-codigo IN FRAME fpage0 /* Produto */
DO:

    APPLY "F5":U TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.it-codigo wMaintenanceNoNavigation
ON RETURN OF tt-auditoria-geral.it-codigo IN FRAME fpage0 /* Produto */
DO:
  APPLY "leave" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-auditoria-geral.nr-linha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.nr-linha wMaintenanceNoNavigation
ON F5 OF tt-auditoria-geral.nr-linha IN FRAME fpage0 /* Linha Produ‡Æo */
DO:

    {include/zoomvar.i &prog-zoom="inzoom/z01in186.w"
                       &campo="tt-auditoria-geral.nr-linha"
                       &campozoom="nr-linha"
                       &frame="fPage0"
                       &campo2="fi-desc-linha"
                       &campozoom2="descricao"
                       &frame2="fPage0"}

        /*
    {method/ZoomFields.i &ProgramZoom="inzoom/z03in186.w"
                         &FieldZoom1="nr-linha"
                         &FieldScreen1="fi-nr-linha"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-desc-linha"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.nr-linha wMaintenanceNoNavigation
ON LEAVE OF tt-auditoria-geral.nr-linha IN FRAME fpage0 /* Linha Produ‡Æo */
DO:

    ASSIGN fi-desc-linha:SCREEN-VALUE IN FRAME fPage0 = "".

    FOR FIRST lin-prod NO-LOCK
        WHERE lin-prod.cod-estabel = INPUT FRAME fPage0 tt-auditoria-geral.cod-estabel
          AND lin-prod.nr-linha    = INPUT FRAME fPage0 tt-auditoria-geral.nr-linha:

        ASSIGN fi-desc-linha:SCREEN-VALUE IN FRAME fPage0 = lin-prod.descricao.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.nr-linha wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-auditoria-geral.nr-linha IN FRAME fpage0 /* Linha Produ‡Æo */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-auditoria-geral.nr-seq-tipo-lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.nr-seq-tipo-lote wMaintenanceNoNavigation
ON F5 OF tt-auditoria-geral.nr-seq-tipo-lote IN FRAME fpage0 /* Tipo de Lote */
DO:

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es678.w"
                         &FieldZoom1="nr-seq-tipo-lote"
                         &FieldScreen1="tt-auditoria-geral.nr-seq-tipo-lote"
                         &Frame1="fPage0"
                         &FieldZoom2="des-lote"
                         &FieldScreen2="fi-desc-tipo-lote"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.nr-seq-tipo-lote wMaintenanceNoNavigation
ON LEAVE OF tt-auditoria-geral.nr-seq-tipo-lote IN FRAME fpage0 /* Tipo de Lote */
DO:
    ASSIGN fi-desc-tipo-lote:SCREEN-VALUE IN FRAME fpage0 = "".

    FOR FIRST aq-tipo-lote NO-LOCK
        WHERE aq-tipo-lote.nr-seq-tipo-lote = INPUT FRAME fPage0 tt-auditoria-geral.nr-seq-tipo-lote:

        ASSIGN fi-desc-tipo-lote:SCREEN-VALUE IN FRAME fpage0 = aq-tipo-lote.des-lote.
    END.

/*     IF INTEGER(tt-auditoria-geral.nr-seq-tipo-lote:SCREEN-VALUE) > 1 THEN DO:                                                            */
/*         RUN utp/ut-msgs.p (INPUT "SHOW",                                                                                                 */
/*                            INPUT 15825,                                                                                                  */
/*                            INPUT "Lote piloto e lan‡amento~~Bloquear o lote, aguardar libera‡Æo das fases:  Lote piloto e lan‡amento."). */
/*     END.                                                                                                                                 */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.nr-seq-tipo-lote wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-auditoria-geral.nr-seq-tipo-lote IN FRAME fpage0 /* Tipo de Lote */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-auditoria-geral.sigla
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.sigla wMaintenanceNoNavigation
ON F5 OF tt-auditoria-geral.sigla IN FRAME fpage0 /* C‚lula */
DO:
        {method/zoomfields.i &ProgramZoom="eszoom/z01es244.w"
                             &FieldZoom1="sigla"        
                             &FieldScreen1="tt-auditoria-geral.sigla"
                             &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.sigla wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-auditoria-geral.sigla IN FRAME fpage0 /* C‚lula */
DO:
    APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-auditoria-geral.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-auditoria-geral.it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-auditoria-geral.cod-unid-negoc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
fi-ge-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-auditoria-geral.nr-linha:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-auditoria-geral.sigla:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-auditoria-geral.nr-seq-tipo-lote:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDisplayFields wMaintenanceNoNavigation 
PROCEDURE AfterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME fPage0:

        IF pcAction = "ADD" THEN DO:
    
            ASSIGN tt-auditoria-geral.dt-amostragem:SCREEN-VALUE = string(TODAY, "99/99/9999").
    
        END.

        IF pcAction = "ADD" OR
           pcAction = "COPY" THEN DO:
            ASSIGN tt-auditoria-geral.cod-estabel:SCREEN-VALUE = v_cod_estab_usuar.
                   
        END.
        else
            assign tt-auditoria-geral.nr-seq-auditoria:screen-value in frame fPage0 = string(tt-auditoria-geral.nr-seq-auditoria)
                   /*tt-auditoria-geral.des-auditor:screen-value in frame fPage0 = tt-auditoria-geral.des-auditor*/
                   tt-auditoria-geral.cod-unid-negoc:screen-value in frame fPage0 = tt-auditoria-geral.cod-unid-negoc.

        ASSIGN tt-auditoria-geral.des-auditor:SCREEN-VALUE = c-seg-usuario.
                   
        ASSIGN cb-turno:SCREEN-VALUE  = fn-turno-int(tt-auditoria-geral.cod-turno).
        

        ASSIGN rs-ind-amostragem = tt-auditoria-geral.ind-amostragem.

        DISP rs-ind-amostragem.

        APPLY "LEAVE" TO tt-auditoria-geral.cod-estabel.
        APPLY "LEAVE" TO tt-auditoria-geral.it-codigo.
        APPLY "LEAVE" TO tt-auditoria-geral.cod-unid-negoc.
        APPLY "LEAVE" TO fi-ge-codigo.
        APPLY "LEAVE" TO tt-auditoria-geral.nr-linha.
        APPLY "LEAVE" TO tt-auditoria-geral.nr-seq-tipo-lote.

        ASSIGN tt-auditoria-geral.log-revisado:checked in frame fPage0        = tt-auditoria-geral.log-revisado
               tt-auditoria-geral.qtd-prod-revis:screen-value in frame fPage0 = string(tt-auditoria-geral.qtd-prod-revis)
               tt-auditoria-geral.log-bloqueio:CHECKED IN FRAME fPage0        = tt-auditoria-geral.log-bloqueio
               tt-auditoria-geral.qtd-prod-bloq:SCREEN-VALUE IN FRAME fPage0  = STRING(tt-auditoria-geral.qtd-prod-bloq)
               tt-auditoria-geral.qt-problema:SCREEN-VALUE IN FRAME fPage0  = STRING(tt-auditoria-geral.qt-problema)
               tt-auditoria-geral.log-double-sample:CHECKED IN FRAME fPage0   = tt-auditoria-geral.log-double-sample.
        
        IF tt-auditoria-geral.log-revisado THEN
            ASSIGN tt-auditoria-geral.qtd-prod-revis:SENSITIVE IN FRAME fPage0 = YES.
        ELSE
            ASSIGN tt-auditoria-geral.qtd-prod-revis:SENSITIVE IN FRAME fPage0 = NO.

        IF tt-auditoria-geral.log-bloqueio THEN
            ASSIGN tt-auditoria-geral.qtd-prod-bloq:SENSITIVE IN FRAME fPage0 = YES.
        ELSE
            ASSIGN tt-auditoria-geral.qtd-prod-bloq:SENSITIVE IN FRAME fPage0 = NO.

            
        ASSIGN tt-auditoria-geral.qt-problema:SENSITIVE IN FRAME fPage0 = NO.

        
    END.

    IF DAY(TODAY) < 8 THEN
       ASSIGN d-dt-limite-alt = TODAY - DAY(TODAY)
              d-dt-limite-alt = d-dt-limite-alt - DAY(d-dt-limite-alt).
    ELSE
       ASSIGN d-dt-limite-alt = TODAY - DAY(TODAY).

    IF tt-auditoria-geral.dt-amostragem < d-dt-limite-alt THEN DO:
       EMPTY TEMP-TABLE tt-prog-ponto.
       RUN esp/es0018p.p (INPUT "esaqp010":U,
                          INPUT 1,
                          INPUT 0,
                          INPUT "":U,
                          OUTPUT TABLE tt-prog-ponto).
       FIND FIRST tt-prog-ponto 
            WHERE tt-prog-ponto.conteudo = c-seg-usuario NO-ERROR.
       IF NOT AVAIL tt-prog-ponto THEN
          ASSIGN tt-auditoria-geral.dt-amostragem:READ-ONLY IN FRAME fPage0 = YES.
       ELSE
          ASSIGN tt-auditoria-geral.dt-amostragem:READ-ONLY IN FRAME fPage0 = NO.
    END.
    ELSE
       ASSIGN tt-auditoria-geral.dt-amostragem:READ-ONLY IN FRAME fPage0 = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterSaveFields wMaintenanceNoNavigation 
PROCEDURE AfterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAIL tt-auditoria-geral THEN DO:

        ASSIGN tt-auditoria-geral.nr-seq-auditoria  = input frame fPage0 tt-auditoria-geral.nr-seq-auditoria
               tt-auditoria-geral.ind-amostragem    = INPUT FRAME fpage0 rs-ind-amostragem
               tt-auditoria-geral.des-auditor       = input frame fPage0 tt-auditoria-geral.des-auditor
               tt-auditoria-geral.cod-unid-negoc    = input frame fPage0 tt-auditoria-geral.cod-unid-negoc
               tt-auditoria-geral.nr-linha          = input frame fPage0 tt-auditoria-geral.nr-linha
               tt-auditoria-geral.sigla             = input frame fPage0 tt-auditoria-geral.sigla
               tt-auditoria-geral.qtd-prod-revis    = INPUT FRAME fPage0 tt-auditoria-geral.qtd-prod-revis
               tt-auditoria-geral.qtd-prod-bloq     = INPUT FRAME fPage0 tt-auditoria-geral.qtd-prod-bloq
               tt-auditoria-geral.qt-problema       = INPUT FRAME fPage0 tt-auditoria-geral.qt-problema
               tt-auditoria-geral.log-double-sample = INPUT FRAME fPage0 tt-auditoria-geral.log-double-sample
               tt-auditoria-geral.cod-turno         = fn-turno-char(INPUT FRAME fPage0 cb-turno).


    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-linha wMaintenanceNoNavigation 
PROCEDURE pi-busca-linha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*ASSIGN tt-auditoria-geral.nr-linha:SCREEN-VALUE IN FRAME fPage0 = "".*/

    FOR FIRST item-uni-estab NO-LOCK
        WHERE item-uni-estab.cod-estabel = tt-auditoria-geral.cod-estabel:SCREEN-VALUE IN FRAME fPage0
        AND   item-uni-estab.it-codigo   = tt-auditoria-geral.it-codigo:SCREEN-VALUE IN FRAME fPage0:

        ASSIGN tt-auditoria-geral.cod-unid-negoc:screen-value in frame fPage0 = string(item-uni-estab.cod-unid-negoc).

        IF pcAction = "ADD" then
            assign tt-auditoria-geral.nr-linha:SCREEN-VALUE IN FRAME fPage0 = string(item-uni-estab.nr-linha).

    END.
     
    APPLY "LEAVE" TO tt-auditoria-geral.cod-unid-negoc IN FRAME fPage0.
    APPLY "LEAVE" TO fi-ge-codigo IN FRAME fPage0.
    APPLY "LEAVE" TO tt-auditoria-geral.nr-linha IN FRAME fPage0.

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
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-turno-char wMaintenanceNoNavigation 
FUNCTION fn-turno-char RETURNS INTEGER
  ( pTurno AS CHAR /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE pTurno:
      WHEN "Geral"    then return 0.
      WHEN "1§ Turno" then return 1.
      WHEN "2§ Turno" then return 2.
      WHEN "3§ Turno" then return 3.
  END CASE.                       


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-turno-int wMaintenanceNoNavigation 
FUNCTION fn-turno-int RETURNS CHAR
  ( pTurno AS INT /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE pTurno:
      WHEN  0 then return "Geral"   .
      WHEN  1 then return "1§ Turno".
      WHEN  2 then return "2§ Turno".
      WHEN  3 then return "3§ Turno".
  END CASE.                       


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

