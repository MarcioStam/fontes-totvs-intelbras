&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-emitente NO-UNDO LIKE emitente
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-pagto-vpc NO-UNDO LIKE pagto-vpc
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-vpc NO-UNDO LIKE vpc
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
{include/i-prgvrs.i ESUTP061a 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESUTO061a
&GLOBAL-DEFINE Version           2.04.00.001

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Comercial,CheckList,Observa‡äes

&GLOBAL-DEFINE ttTable           tt-vpc
&GLOBAL-DEFINE hDBOTable         h-boes455
&GLOBAL-DEFINE DBOTable          vpc

&GLOBAL-DEFINE ttParent          tt-emitente
&GLOBAL-DEFINE DBOParentTable    h-boad098

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-emitente.cod-emitente tt-emitente.nome-emit tt-emitente.cod-rep
&GLOBAL-DEFINE page1Fields       tt-vpc.forma-pagto tt-vpc.cod-estab tt-vpc.tipo-acordo tt-vpc.tipo-verba ~
                                 tt-vpc.data-evento tt-vpc.data-vencto ~
                                 tt-vpc.valor tt-vpc.email-repres tt-vpc.data-trans
&GLOBAL-DEFINE page2Fields       tt-vpc.empenho tt-vpc.comprovacao tt-vpc.id-pagto tt-vpc.num-pagto
&GLOBAL-DEFINE page3Fields       tt-vpc.observacoes

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

DEFINE TEMP-TABLE tt-unid-negoc NO-UNDO
    FIELD cod-unid-negoc AS CHARACTER
    FIELD descricao      AS CHARACTER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-emitente.cod-emitente ~
tt-emitente.nome-emit tt-emitente.cod-rep tt-vpc.nr-vpc 
&Scoped-define ENABLED-TABLES tt-emitente tt-vpc
&Scoped-define FIRST-ENABLED-TABLE tt-emitente
&Scoped-define SECOND-ENABLED-TABLE tt-vpc
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-emitente.cod-emitente ~
tt-emitente.nome-emit tt-emitente.cod-rep tt-vpc.nr-vpc 
&Scoped-define DISPLAYED-TABLES tt-emitente tt-vpc
&Scoped-define FIRST-DISPLAYED-TABLE tt-emitente
&Scoped-define SECOND-DISPLAYED-TABLE tt-vpc


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

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fi-desc-acordo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-verba AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32.72 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44.29 BY 2.42.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44.29 BY 1.42.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35.29 BY 2.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-emitente.cod-emitente AT ROW 1.29 COL 16 COLON-ALIGNED WIDGET-ID 36
          LABEL "Fornecedor":R10
          VIEW-AS FILL-IN 
          SIZE 7.57 BY .88
     tt-emitente.nome-emit AT ROW 1.29 COL 23.86 COLON-ALIGNED NO-LABEL WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 46.14 BY .88
     tt-emitente.cod-rep AT ROW 2.25 COL 64 COLON-ALIGNED WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-vpc.nr-vpc AT ROW 2.29 COL 16 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     btOK AT ROW 16.75 COL 2
     btSave AT ROW 16.75 COL 13
     btCancel AT ROW 16.75 COL 24
     btHelp AT ROW 16.75 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.57 BY 17.17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tt-vpc.forma-pagto AT ROW 1.5 COL 13.57 NO-LABEL WIDGET-ID 42
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Boleto", 0,
"Desconto", 1,
"Produto", 2,
"Dep¢sito", 3
          SIZE 39.43 BY 1
     tt-vpc.data-trans AT ROW 1.5 COL 68 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-vpc.cod-estabel AT ROW 2.5 COL 11.57 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     fi-desc-estabel AT ROW 2.5 COL 16.86 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     tt-vpc.usuario-trans AT ROW 2.5 COL 68 COLON-ALIGNED WIDGET-ID 24
          LABEL "Usu rio Transa‡Æo"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tt-vpc.tipo-acordo AT ROW 3.5 COL 11.57 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-desc-acordo AT ROW 3.5 COL 17.86 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     tt-vpc.data-liberacao AT ROW 3.5 COL 68 COLON-ALIGNED WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-vpc.tipo-verba AT ROW 4.5 COL 11.57 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-desc-verba AT ROW 4.5 COL 17.86 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     tt-vpc.usuario-liberacao AT ROW 4.5 COL 68 COLON-ALIGNED WIDGET-ID 66
          VIEW-AS FILL-IN 
          SIZE 15.86 BY .88
     tt-vpc.data-evento AT ROW 5.5 COL 11.57 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-vpc.nro-docto AT ROW 5.5 COL 68 COLON-ALIGNED WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tt-vpc.data-vencto AT ROW 6.5 COL 11.57 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-vpc.serie-docto AT ROW 6.5 COL 68 COLON-ALIGNED WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-vpc.valor AT ROW 7.5 COL 11.57 COLON-ALIGNED WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-vpc.cod-esp AT ROW 7.5 COL 68 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-vpc.email-repres AT ROW 8.5 COL 11.57 COLON-ALIGNED WIDGET-ID 12
          LABEL "Email Repres" FORMAT "x(100)"
          VIEW-AS FILL-IN 
          SIZE 73.43 BY .88
     "Forma Pagto:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 1.67 COL 4.14 WIDGET-ID 46
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.14 ROW 5
         SIZE 87.86 BY 10.92
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fPage2
     tt-vpc.empenho AT ROW 2.25 COL 8 WIDGET-ID 2
          VIEW-AS TOGGLE-BOX
          SIZE 11.57 BY .83
     tt-vpc.comprovacao AT ROW 3.25 COL 8 WIDGET-ID 4
          LABEL "Comprova‡Æo(CD/Foto/Tabl¢ide,etc)"
          VIEW-AS TOGGLE-BOX
          SIZE 30 BY .83
     tt-vpc.id-pagto AT ROW 5.5 COL 8 NO-LABEL WIDGET-ID 6
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Boleto", 0,
"Duplicata", 1,
"Nota Debito", 2,
"Pedido", 3
          SIZE 42.29 BY .92
     tt-vpc.num-pagto AT ROW 6.42 COL 6.14 COLON-ALIGNED NO-LABEL WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 41.72 BY .88
     tt-vpc.situacao AT ROW 8.46 COL 7.86 NO-LABEL WIDGET-ID 10
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Bloqueado", 0,
"Liberado", 1,
"Finalizado", 2,
"Cancelado", 3
          SIZE 42.29 BY 1
     "Situa‡Æo VPC:" VIEW-AS TEXT
          SIZE 10.43 BY .54 AT ROW 7.88 COL 7.72 WIDGET-ID 20
     "Pagamento:" VIEW-AS TEXT
          SIZE 9.29 BY .54 AT ROW 4.88 COL 7.72 WIDGET-ID 16
     RECT-1 AT ROW 5.21 COL 7 WIDGET-ID 14
     RECT-2 AT ROW 8.21 COL 7 WIDGET-ID 18
     RECT-3 AT ROW 2 COL 6.72 WIDGET-ID 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.14 ROW 5
         SIZE 87.86 BY 10.92
         FONT 1 WIDGET-ID 400.

DEFINE FRAME fPage3
     tt-vpc.observacoes AT ROW 1.67 COL 2 NO-LABEL WIDGET-ID 2
          VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 2000 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 85 BY 9.5
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.14 ROW 5
         SIZE 87.86 BY 10.92
         FONT 1 WIDGET-ID 600.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-emitente T "?" NO-UNDO mgcad emitente
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-pagto-vpc T "?" NO-UNDO mgesp pagto-vpc
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-vpc T "?" NO-UNDO mgesp vpc
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
         HEIGHT             = 17.17
         WIDTH              = 90.57
         MAX-HEIGHT         = 39.67
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 39.67
         VIRTUAL-WIDTH      = 182.86
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-emitente.cod-emitente IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN tt-vpc.email-repres IN FRAME fPage1
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN tt-vpc.usuario-trans IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR TOGGLE-BOX tt-vpc.comprovacao IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage3
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-vpc.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-vpc.cod-estabel wMaintenanceNoNavigation
ON F5 OF tt-vpc.cod-estabel IN FRAME fPage1 /* Estab */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                        &campo=tt-vpc.cod-estabel
                        &campozoom=cod-estabel
                        &campo2=fi-desc-estabel
                        &campozoom2=nome}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-vpc.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-vpc.cod-estabel IN FRAME fPage1 /* Estab */
DO:
    assign input frame fPage1 tt-vpc.cod-estabel.

    {include/leave.i &tabela=estabelec
                    &atributo-ref=nome
                    &variavel-ref=fi-desc-estabel
                    &where="estabelec.cod-estabel = tt-vpc.cod-estabel"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-vpc.cod-estabel wMaintenanceNoNavigation
ON LEFT-MOUSE-DBLCLICK OF tt-vpc.cod-estabel IN FRAME fPage1 /* Estab */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-vpc.tipo-acordo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-vpc.tipo-acordo wMaintenanceNoNavigation
ON F5 OF tt-vpc.tipo-acordo IN FRAME fPage1 /* Tipo Acordo */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es452.w"
                         &FieldZoom1="codigo"
                         &FieldScreen1="tt-vpc.tipo-acordo"
                         &Frame1="fPage1"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-desc-acordo"
                         &Frame2="fPage1"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-vpc.tipo-acordo wMaintenanceNoNavigation
ON LEAVE OF tt-vpc.tipo-acordo IN FRAME fPage1 /* Tipo Acordo */
DO:
    ASSIGN INPUT FRAME fPage1 tt-vpc.tipo-acordo.
    {include/leave.i &tabela=tipo-acordo
                     &atributo-ref=descricao
                     &variavel-ref=fi-desc-acordo
                     &where="tipo-acordo.codigo = tt-vpc.tipo-acordo"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-vpc.tipo-acordo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-vpc.tipo-acordo IN FRAME fPage1 /* Tipo Acordo */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-vpc.tipo-verba
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-vpc.tipo-verba wMaintenanceNoNavigation
ON F5 OF tt-vpc.tipo-verba IN FRAME fPage1 /* Tipo Verba */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es454.w"
                         &FieldZoom1="codigo"
                         &FieldScreen1="tt-vpc.tipo-verba"
                         &Frame1="fPage1"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-desc-verba"
                         &Frame2="fPage1"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-vpc.tipo-verba wMaintenanceNoNavigation
ON LEAVE OF tt-vpc.tipo-verba IN FRAME fPage1 /* Tipo Verba */
DO:
    ASSIGN INPUT FRAME fPage1 tt-vpc.tipo-verba.
    {include/leave.i &tabela=tipo-verba
                     &atributo-ref=descricao
                     &variavel-ref=fi-desc-verba
                     &where="tipo-verba.codigo = tt-vpc.tipo-verba"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-vpc.tipo-verba wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-vpc.tipo-verba IN FRAME fPage1 /* Tipo Verba */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
tt-vpc.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-vpc.tipo-acordo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-vpc.tipo-verba:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.

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

    /*if avail tt-emitente then do:
        apply 'leave' to tt-emitente.cod-estabel in frame fPage0.
        apply 'leave' to tt-cc-equipamentos.cc-codigo in frame fPage0.
    end.*/



    IF pcAction = "ADD" THEN DO:
        ASSIGN tt-vpc.data-trans:SCREEN-VALUE        IN FRAME fPage1 = STRING(TODAY,"99/99/9999")
               tt-vpc.usuario-trans:SCREEN-VALUE     IN FRAME fPage1 = c-seg-usuario
               tt-vpc.data-liberacao:SCREEN-VALUE    IN FRAME fPage1 = ""
               tt-vpc.usuario-liberacao:SCREEN-VALUE IN FRAME fPage1 = ""
               tt-vpc.nro-docto:SCREEN-VALUE         IN FRAME fPage1 = ""
               tt-vpc.serie:SCREEN-VALUE             IN FRAME fPage1 = ""
               tt-vpc.cod-esp:SCREEN-VALUE           IN FRAME fPage1 = ""
               tt-vpc.situacao:SCREEN-VALUE          IN FRAME fPage2 = "1".

        FIND FIRST emitente NO-LOCK 
             WHERE emitente.cod-emitente = tt-emitente.cod-emitente NO-ERROR.
        IF AVAIL emitente THEN DO:
            FIND FIRST repres NO-LOCK
                 WHERE repres.cod-rep = emitente.cod-rep NO-ERROR.
            IF AVAIL repres THEN DO:
                ASSIGN tt-vpc.email-repres:SCREEN-VALUE IN FRAME fPage1 = repres.e-mail.
            END.
        END.
    END.
    ELSE IF pcAction = "update" THEN DO:
        ASSIGN tt-vpc.data-trans:SCREEN-VALUE        IN FRAME fPage1 = STRING(tt-vpc.data-trans,"99/99/9999")
               tt-vpc.usuario-trans:SCREEN-VALUE     IN FRAME fPage1 = tt-vpc.usuario-trans
               tt-vpc.data-liberacao:SCREEN-VALUE    IN FRAME fPage1 = STRING(tt-vpc.data-liberacao,"99/99/9999")
               tt-vpc.usuario-liberacao:SCREEN-VALUE IN FRAME fPage1 = tt-vpc.usuario-liberacao
               tt-vpc.nro-docto:SCREEN-VALUE         IN FRAME fPage1 = tt-vpc.nro-docto
               tt-vpc.serie:SCREEN-VALUE             IN FRAME fPage1 = tt-vpc.serie
               tt-vpc.cod-esp:SCREEN-VALUE           IN FRAME fPage1 = tt-vpc.cod-esp
               tt-vpc.situacao:SCREEN-VALUE          IN FRAME fPage2 = STRING(tt-vpc.situacao).

        ASSIGN tt-vpc.nr-vpc:SCREEN-VALUE IN FRAME fPage0 = STRING(tt-vpc.nr-vpc).
    END.

    IF AVAIL tt-vpc THEN DO:
        APPLY "leave" TO tt-vpc.cod-estabel IN FRAME fPage1.
        APPLY "leave" TO tt-vpc.tipo-acordo IN FRAME fPage1.
        APPLY "leave" TO tt-vpc.tipo-verba IN FRAME fPage1.
    END.
    
    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAIL tt-vpc THEN DO:
/*         IF tt-vpc.situacao <> 0 THEN DO:              */
            DISABLE {&page3Fields} WITH FRAME fPage3.
            DISABLE {&page1Fields} WITH FRAME fPage1.
            DISABLE btok  WITH FRAME fPage0.

/*             ENABLE tt-vpc.cod-esp                                      */
/*                    WITH FRAME fPage1.                                  */
/*                                                                        */
/*             ASSIGN tt-vpc.cod-esp:READ-ONLY   IN FRAME fPage1 = YES.   */
/*                                                                        */
/*             ASSIGN tt-vpc.observacoes:SENSITIVE IN FRAME fPage3 = YES  */
/*                    tt-vpc.observacoes:READ-ONLY IN FRAME fPage3 = YES. */
 /*       END.*/
/*                                                                                                  */
/*         IF tt-vpc.situacao <> 1 THEN DO:                                                         */
/*             IF tt-vpc.situacao = 0 THEN DO:                                                      */
/*                 FIND FIRST param-vpc NO-LOCK                                                     */
/*                      WHERE param-vpc.cod-estabel = tt-vpc.cod-estabel NO-ERROR.                  */
/*                 IF AVAIL param-vpc AND LOOKUP(c-seg-usuario,param-vpc.aprovadores) <> 0 THEN DO: */
/*                     ASSIGN tt-vpc.data-trans:SENSITIVE IN FRAME fPage1 = YES.                    */
/*                 END.                                                                             */
/*                 ELSE DO:                                                                         */
/*                     ASSIGN tt-vpc.data-trans:SENSITIVE IN FRAME fPage1 = NO.                     */
/*                 END.                                                                             */
/*             END.                                                                                 */
/*         END.                                                                                     */
/*                                                                                                  */
/*         IF tt-vpc.situacao <= 1 THEN DO:                                                         */
/*             ENABLE tt-vpc.forma-pagto WITH FRAME fPage1.                                         */
/*         END.                                                                                     */
/*                                                                                                  */
/*         IF tt-vpc.situacao = 3 THEN DO:                                                          */
            DISABLE {&page2Fields} WITH FRAME fPage2.
/*         END. */
    END.

    RETURN "OK".
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
    
    /*RUN pi-carrega-unidades.*/

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-unidades wMaintenanceNoNavigation 
PROCEDURE pi-carrega-unidades :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*     DEFINE VARIABLE c-desc AS CHARACTER   NO-UNDO.                                                      */
/*     DEFINE VARIABLE h-esapi015 AS HANDLE      NO-UNDO.                                                  */
/*                                                                                                         */
/*     FOR EACH tt-unid-negoc:                                                                             */
/*         DELETE tt-unid-negoc.                                                                           */
/*     END.                                                                                                */
/*                                                                                                         */
/*     RUN esapi/esapi015.p PERSISTENT SET h-esapi015.                                                     */
/*     RUN pi-retorna-unidade IN h-esapi015 (OUTPUT TABLE tt-unid-negoc).                                  */
/*     DELETE PROCEDURE h-esapi015.                                                                        */
/*                                                                                                         */
/*     ASSIGN tt-vpc.cod-unid-negoc:LIST-ITEM-PAIRS IN FRAME fPage1 = ",".                                 */
/*                                                                                                         */
/*     FOR EACH tt-unid-negoc BY tt-unid-negoc.cod-unid-negoc:                                             */
/*         ASSIGN c-desc = tt-unid-negoc.cod-unid-negoc + "-" + tt-unid-negoc.descricao.                   */
/*                                                                                                         */
/*         tt-vpc.cod-unid-negoc:add-last(c-desc, tt-unid-negoc.cod-unid-negoc) IN FRAME fPage1 NO-ERROR.  */
/*     END.                                                                                                */

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
    
    assign tt-vpc.cod-emitente  = tt-emitente.cod-emitente
           tt-vpc.nr-vpc        = INT(tt-vpc.nr-vpc:SCREEN-VALUE IN FRAME fPage0)
           tt-vpc.data-trans    = DATE(tt-vpc.data-trans:SCREEN-VALUE IN FRAME fPage1)
           tt-vpc.usuario-trans = tt-vpc.usuario-trans:SCREEN-VALUE IN FRAME fPage1.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

