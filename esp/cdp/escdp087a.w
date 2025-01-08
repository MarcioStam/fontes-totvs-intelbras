&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-portaria-item NO-UNDO LIKE int-portaria-item
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
{include/i-prgvrs.i ESCDP087A 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESCDP087A
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-int-portaria-item
&GLOBAL-DEFINE hDBOTable         h-boes042
&GLOBAL-DEFINE DBOTable          int-portaria-item

&GLOBAL-DEFINE page0KeyFields    tt-int-portaria-item.it-codigo tt-int-portaria-item.cod-estabel
&GLOBAL-DEFINE page0Fields       tt-int-portaria-item.desc-mctic tt-int-portaria-item.produto-base tt-int-portaria-item.ncm-base

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

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
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-int-portaria-item.it-codigo ~
tt-int-portaria-item.cod-estabel tt-int-portaria-item.ncm-base ~
tt-int-portaria-item.produto-base tt-int-portaria-item.desc-mctic 
&Scoped-define ENABLED-TABLES tt-int-portaria-item
&Scoped-define FIRST-ENABLED-TABLE tt-int-portaria-item
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar c-desc-item c-desc-estab ~
c-familia c-familia-com c-ncm tg-ind-item-fat c-cod-orig c-aliq-ipi ~
c-cod-unid-negoc btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-int-portaria-item.it-codigo ~
tt-int-portaria-item.cod-estabel tt-int-portaria-item.ncm-base ~
tt-int-portaria-item.produto-base tt-int-portaria-item.desc-mctic 
&Scoped-define DISPLAYED-TABLES tt-int-portaria-item
&Scoped-define FIRST-DISPLAYED-TABLE tt-int-portaria-item
&Scoped-Define DISPLAYED-OBJECTS c-desc-item c-desc-estab c-familia ~
c-familia-com c-ncm tg-ind-item-fat c-cod-orig c-aliq-ipi c-cod-unid-negoc 

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

DEFINE VARIABLE c-aliq-ipi AS CHARACTER FORMAT "X(256)":U 
     LABEL "Aliq. IPI" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-orig AS CHARACTER FORMAT "X(2)":U 
     LABEL "Origem" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-unid-negoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unid. Neg¢c." 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE c-familia AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fam¡lia" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-familia-com AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fam¡lia Comercial" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-ncm AS CHARACTER FORMAT "X(256)":U 
     LABEL "NCM" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-ind-item-fat AS LOGICAL INITIAL no 
     LABEL "Item Fatur vel" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.43 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-int-portaria-item.it-codigo AT ROW 1.25 COL 17 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-desc-item AT ROW 1.25 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     tt-int-portaria-item.cod-estabel AT ROW 2.25 COL 17 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     c-desc-estab AT ROW 2.25 COL 21.29 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     c-familia AT ROW 3.75 COL 17 COLON-ALIGNED WIDGET-ID 48
     c-familia-com AT ROW 3.75 COL 39 COLON-ALIGNED WIDGET-ID 50
     c-ncm AT ROW 3.75 COL 57 COLON-ALIGNED WIDGET-ID 52
     tg-ind-item-fat AT ROW 3.75 COL 70 WIDGET-ID 54
     c-cod-orig AT ROW 4.75 COL 17 COLON-ALIGNED WIDGET-ID 46
     c-aliq-ipi AT ROW 4.75 COL 39 COLON-ALIGNED WIDGET-ID 44
     c-cod-unid-negoc AT ROW 4.75 COL 57 COLON-ALIGNED WIDGET-ID 34
     tt-int-portaria-item.ncm-base AT ROW 5.75 COL 17 COLON-ALIGNED WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-int-portaria-item.produto-base AT ROW 6.75 COL 19 NO-LABEL WIDGET-ID 60
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 70 BY 4
     tt-int-portaria-item.desc-mctic AT ROW 11 COL 19 NO-LABEL WIDGET-ID 36
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 70 BY 4
     btOK AT ROW 19.75 COL 2
     btSave AT ROW 19.75 COL 13
     btCancel AT ROW 19.75 COL 24
     btHelp AT ROW 19.75 COL 80
     "Produto Base:" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 7 COL 9 WIDGET-ID 62
     "Descri‡Æo MCTIC:" VIEW-AS TEXT
          SIZE 13 BY .88 AT ROW 11.25 COL 6 WIDGET-ID 40
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 19.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 20.13
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-int-portaria-item T "?" NO-UNDO mgesp int-portaria-item
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
         HEIGHT             = 20.13
         WIDTH              = 90
         MAX-HEIGHT         = 21.38
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 21.38
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


&Scoped-define SELF-NAME tt-int-portaria-item.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-portaria-item.cod-estabel wMaintenanceNoNavigation
ON F5 OF tt-int-portaria-item.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
      {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=tt-int-portaria-item.cod-estabel
                       &campozoom=cod-estabel
                       &campo2=c-desc-estab
                       &campozoom2=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-portaria-item.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-int-portaria-item.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    FIND FIRST estabelec WHERE estabelec.cod-estabel = tt-int-portaria-item.cod-estabel:SCREEN-VALUE IN FRAME fPage0 NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN 
        ASSIGN c-desc-estab:screen-value in frame fPage0 = estabelec.nome.
    ELSE 
        ASSIGN c-desc-estab:SCREEN-VALUE IN FRAME fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-portaria-item.cod-estabel wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-int-portaria-item.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-portaria-item.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-portaria-item.it-codigo wMaintenanceNoNavigation
ON F5 OF tt-int-portaria-item.it-codigo IN FRAME fpage0 /* Item */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                       &campo="tt-int-portaria-item.it-codigo"
                       &campozoom="it-codigo"
                       &campo2="c-desc-item"
                       &campozoom2="desc-item"
                       &frame="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-portaria-item.it-codigo wMaintenanceNoNavigation
ON LEAVE OF tt-int-portaria-item.it-codigo IN FRAME fpage0 /* Item */
DO:
    FIND FIRST item WHERE item.it-codigo = tt-int-portaria-item.it-codigo:SCREEN-VALUE IN FRAME fPage0 NO-LOCK NO-ERROR.
    IF AVAIL ITEM AND ITEM.it-codigo <> "" THEN 
        ASSIGN c-desc-item:screen-value in frame fPage0      = item.desc-item
               c-familia:screen-value in frame fPage0        = item.fm-codigo
               c-familia-com:screen-value in frame fPage0    = item.fm-cod-com
               c-ncm:screen-value in frame fPage0            = item.class-fiscal
               c-cod-orig:screen-value in frame fPage0       = STRING(item.codigo-orig)
               c-aliq-ipi:screen-value in frame fPage0       = STRING(item.aliquota-ipi)
               c-cod-unid-negoc:screen-value IN FRAME fPage0 = item.cod-unid-negoc
               tg-ind-item-fat:CHECKED IN FRAME fPage0       = item.ind-item-fat.
    
    ELSE 
        ASSIGN c-desc-item:SCREEN-VALUE IN FRAME fPage0      = "Produto Base Beneficiado"
               c-familia:screen-value in frame fPage0        = ""
               c-familia-com:screen-value in frame fPage0    = ""
               c-ncm:screen-value in frame fPage0            = ""
               c-cod-orig:screen-value in frame fPage0       = ""
               c-aliq-ipi:screen-value in frame fPage0       = ""
               c-cod-unid-negoc:screen-value IN FRAME fPage0 = ""
               tg-ind-item-fat:CHECKED IN FRAME fPage0       = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-portaria-item.it-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-int-portaria-item.it-codigo IN FRAME fpage0 /* Item */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-int-portaria-item.it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-int-portaria-item.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

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

    FIND FIRST item WHERE item.it-codigo = tt-int-portaria-item.it-codigo NO-LOCK NO-ERROR.
    IF AVAIL ITEM AND ITEM.it-codigo <> "" THEN 
        ASSIGN c-desc-item:screen-value in frame fPage0      = item.desc-item
               c-familia:screen-value in frame fPage0        = item.fm-codigo
               c-familia-com:screen-value in frame fPage0    = item.fm-cod-com
               c-ncm:screen-value in frame fPage0            = item.class-fiscal
               c-cod-orig:screen-value in frame fPage0       = STRING(item.codigo-orig)
               c-aliq-ipi:screen-value in frame fPage0       = STRING(item.aliquota-ipi)
               c-cod-unid-negoc:screen-value IN FRAME fPage0 = item.cod-unid-negoc
               tg-ind-item-fat:CHECKED IN FRAME fPage0       = item.ind-item-fat.
    
    ELSE 
        ASSIGN c-desc-item:SCREEN-VALUE IN FRAME fPage0      = "Produto Base Beneficiado"
               c-familia:screen-value in frame fPage0        = ""
               c-familia-com:screen-value in frame fPage0    = ""
               c-ncm:screen-value in frame fPage0            = ""
               c-cod-orig:screen-value in frame fPage0       = ""
               c-aliq-ipi:screen-value in frame fPage0       = ""
               c-cod-unid-negoc:screen-value IN FRAME fPage0 = ""
               tg-ind-item-fat:CHECKED IN FRAME fPage0       = NO.
    
    FIND FIRST estabelec WHERE estabelec.cod-estabel = tt-int-portaria-item.cod-estabel NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN ASSIGN c-desc-estab:screen-value in frame fPage0 = estabelec.nome.
    ELSE ASSIGN c-desc-estab:SCREEN-VALUE IN FRAME fPage0 = "".
    
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

