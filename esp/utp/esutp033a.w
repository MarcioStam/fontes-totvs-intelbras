&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-juridico-processos NO-UNDO LIKE juridico-processos
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESUTP033A 2.04.00.001}  /*** 010000 ***/
/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

{cdp/cdcfgmat.i} /*Defini‡Æo dos pr‚-processadores*/
{cdp/cdcfgcex.i}
{include/i_dbvers.i}

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESUTP033A
&GLOBAL-DEFINE Version           2.04.00.001
&GLOBAL-DEFINE DBOVersion        2.0

&GLOBAL-DEFINE Folder           yes
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Principal,Adicional

&GLOBAL-DEFINE ttTable           tt-juridico-processos
&GLOBAL-DEFINE hDBOTable         h-boes472
&GLOBAL-DEFINE DBOTable          desp-imp

&GLOBAL-DEFINE page0KeyFields    tt-juridico-processos.processo tt-juridico-processos.dt-processo

&GLOBAL-DEFINE page1Fields      tt-juridico-processos.autor tt-juridico-processos.cpf-cnpj tt-juridico-processos.cidade tt-juridico-processos.estado ~
                                tt-juridico-processos.contato tt-juridico-processos.cod-motivo tt-juridico-processos.cod-tipo ~
                                tt-juridico-processos.cod-situacao tt-juridico-processos.cod-solucao tt-juridico-processos.dt-recebimento ~
                                tt-juridico-processos.vara-judicial tt-juridico-processos.objeto-acao tt-juridico-processos.valor-acao ~
                                tt-juridico-processos.valor-danos-cobr tt-juridico-processos.valor-danos-pago
                                 

&GLOBAL-DEFINE page2Fields      tt-juridico-processos.cod-unid-negoc tt-juridico-processos.produto tt-juridico-processos.nr-serie ~
                                tt-juridico-processos.ordem-servico tt-juridico-processos.posto-autorizado tt-juridico-processos.defeito ~
                                tt-juridico-processos.data-compra

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

/* pesquisa */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS tt-juridico-processos.processo ~
tt-juridico-processos.dt-processo 
&Scoped-define ENABLED-TABLES tt-juridico-processos
&Scoped-define FIRST-ENABLED-TABLE tt-juridico-processos
&Scoped-Define ENABLED-OBJECTS btOK btSave btCancel btHelp RECT-1 rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-juridico-processos.processo ~
tt-juridico-processos.dt-processo 
&Scoped-define DISPLAYED-TABLES tt-juridico-processos
&Scoped-define FIRST-DISPLAYED-TABLE tt-juridico-processos


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

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.43 BY 2.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fi-desc-motivo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-situacao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-solucao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-tipo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.72 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 18.67 COL 2
     btSave AT ROW 18.67 COL 13
     btCancel AT ROW 18.67 COL 24
     btHelp AT ROW 18.67 COL 80
     tt-juridico-processos.processo AT ROW 1.42 COL 15.14 COLON-ALIGNED WIDGET-ID 148 FORMAT "x(50)"
          VIEW-AS FILL-IN 
          SIZE 45 BY .88
     tt-juridico-processos.dt-processo AT ROW 2.42 COL 15.14 COLON-ALIGNED WIDGET-ID 146
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     RECT-1 AT ROW 1.17 COL 1.57
     rtToolBar AT ROW 18.42 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.72 BY 19.13
         FONT 1.

DEFINE FRAME fPage2
     tt-juridico-processos.produto AT ROW 1.42 COL 12.57 COLON-ALIGNED WIDGET-ID 160
          VIEW-AS FILL-IN 
          SIZE 44 BY .88
     tt-juridico-processos.data-compra AT ROW 1.46 COL 70.14 COLON-ALIGNED WIDGET-ID 192
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-juridico-processos.nr-serie AT ROW 2.42 COL 12.57 COLON-ALIGNED WIDGET-ID 154
          VIEW-AS FILL-IN 
          SIZE 29.72 BY .88
     tt-juridico-processos.ordem-servico AT ROW 3.42 COL 12.57 COLON-ALIGNED WIDGET-ID 156
          VIEW-AS FILL-IN 
          SIZE 29.72 BY .88
     tt-juridico-processos.posto-autorizado AT ROW 4.42 COL 12.57 COLON-ALIGNED WIDGET-ID 158
          VIEW-AS FILL-IN 
          SIZE 44 BY .88
     tt-juridico-processos.cod-unid-negoc AT ROW 5.42 COL 12.57 COLON-ALIGNED WIDGET-ID 58
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Item 1","Item 1"
          DROP-DOWN-LIST
          SIZE 44 BY 1
     tt-juridico-processos.defeito AT ROW 6.5 COL 14.72 NO-LABEL WIDGET-ID 184
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 68 BY 7.25
     "Investiga‡Æo:" VIEW-AS TEXT
          SIZE 9.14 BY .54 AT ROW 6.58 COL 4.86 WIDGET-ID 188
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.72 ROW 4.92
         SIZE 84.43 BY 12.83
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fPage1
     tt-juridico-processos.autor AT ROW 1.5 COL 13.86 COLON-ALIGNED WIDGET-ID 126
          VIEW-AS FILL-IN 
          SIZE 59 BY .88
     tt-juridico-processos.cidade AT ROW 3.5 COL 14 COLON-ALIGNED WIDGET-ID 128
          VIEW-AS FILL-IN 
          SIZE 47 BY .88
     tt-juridico-processos.estado AT ROW 3.5 COL 68.86 COLON-ALIGNED WIDGET-ID 152
          VIEW-AS FILL-IN 
          SIZE 4.14 BY .88
     tt-juridico-processos.contato AT ROW 4.5 COL 14 COLON-ALIGNED WIDGET-ID 140
          VIEW-AS FILL-IN 
          SIZE 59 BY .88
     tt-juridico-processos.cod-motivo AT ROW 5.5 COL 14 COLON-ALIGNED WIDGET-ID 130
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-desc-motivo AT ROW 5.5 COL 22.29 COLON-ALIGNED NO-LABEL WIDGET-ID 168
     tt-juridico-processos.cod-tipo AT ROW 6.5 COL 14 COLON-ALIGNED WIDGET-ID 134
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-desc-tipo AT ROW 6.5 COL 22.29 COLON-ALIGNED NO-LABEL WIDGET-ID 170
     tt-juridico-processos.cod-situacao AT ROW 7.5 COL 14 COLON-ALIGNED WIDGET-ID 132
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-desc-situacao AT ROW 7.5 COL 22.29 COLON-ALIGNED NO-LABEL WIDGET-ID 174
     tt-juridico-processos.cod-solucao AT ROW 8.5 COL 14 COLON-ALIGNED WIDGET-ID 182
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-desc-solucao AT ROW 8.5 COL 22.29 COLON-ALIGNED NO-LABEL WIDGET-ID 180
     tt-juridico-processos.objeto-acao AT ROW 10.5 COL 14 COLON-ALIGNED WIDGET-ID 184
          VIEW-AS FILL-IN 
          SIZE 59.14 BY .88
     tt-juridico-processos.valor-acao AT ROW 11.5 COL 14 COLON-ALIGNED WIDGET-ID 186
          VIEW-AS FILL-IN 
          SIZE 11.14 BY .88
     tt-juridico-processos.dt-recebimento AT ROW 11.5 COL 45.72 COLON-ALIGNED WIDGET-ID 178
          VIEW-AS FILL-IN 
          SIZE 11.14 BY .88
     tt-juridico-processos.cpf-cnpj AT ROW 2.5 COL 13.86 COLON-ALIGNED WIDGET-ID 188
          VIEW-AS FILL-IN 
          SIZE 22.57 BY .88
     tt-juridico-processos.vara-judicial AT ROW 9.5 COL 14 COLON-ALIGNED WIDGET-ID 190
          VIEW-AS FILL-IN 
          SIZE 59 BY .88
     tt-juridico-processos.valor-danos-cobr AT ROW 12.5 COL 14 COLON-ALIGNED WIDGET-ID 192
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-juridico-processos.valor-danos-pago AT ROW 12.5 COL 45.72 COLON-ALIGNED WIDGET-ID 194
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.72 ROW 4.92
         SIZE 84.43 BY 12.83
         FONT 1 WIDGET-ID 300.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
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
         HEIGHT             = 19.13
         WIDTH              = 90.72
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 146.29
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
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN tt-juridico-processos.processo IN FRAME fpage0
   EXP-FORMAT                                                           */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* SETTINGS FOR FRAME fPage2
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
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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
&Scoped-define SELF-NAME tt-juridico-processos.cod-motivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-juridico-processos.cod-motivo wMaintenanceNoNavigation
ON F5 OF tt-juridico-processos.cod-motivo IN FRAME fPage1 /* C¢d. Motivo */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es467.w"
                         &FieldZoom1="codigo"
                         &FieldScreen1="tt-juridico-processos.cod-motivo"
                         &Frame1="fPage1"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-desc-motivo"
                         &Frame2="fPage1"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-juridico-processos.cod-motivo wMaintenanceNoNavigation
ON LEAVE OF tt-juridico-processos.cod-motivo IN FRAME fPage1 /* C¢d. Motivo */
DO:
    IF AVAIL tt-juridico-processos THEN DO:
        ASSIGN INPUT FRAME fPage1 tt-juridico-processos.cod-motivo.
        FIND FIRST juridico-motivos NO-LOCK
             WHERE juridico-motivos.codigo = tt-juridico-processos.cod-motivo NO-ERROR.
        IF AVAIL juridico-motivos THEN
            ASSIGN fi-desc-motivo:SCREEN-VALUE IN FRAME fPage1 = juridico-motivos.descricao.
        ELSE
            ASSIGN fi-desc-motivo:SCREEN-VALUE IN FRAME fPage1 = "".
    END.
    ELSE DO:
        ASSIGN fi-desc-motivo:SCREEN-VALUE IN FRAME fPage1 = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-juridico-processos.cod-motivo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-juridico-processos.cod-motivo IN FRAME fPage1 /* C¢d. Motivo */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-juridico-processos.cod-situacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-juridico-processos.cod-situacao wMaintenanceNoNavigation
ON F5 OF tt-juridico-processos.cod-situacao IN FRAME fPage1 /* C¢d. Situa‡Æo */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es471.w"
                         &FieldZoom1="codigo"
                         &FieldScreen1="tt-juridico-processos.cod-situacao"
                         &Frame1="fPage1"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-desc-situacao"
                         &Frame2="fPage1"
                         &EnableImplant="NO"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-juridico-processos.cod-situacao wMaintenanceNoNavigation
ON LEAVE OF tt-juridico-processos.cod-situacao IN FRAME fPage1 /* C¢d. Situa‡Æo */
DO:
    IF AVAIL tt-juridico-processos THEN DO:
        ASSIGN INPUT FRAME fPage1 tt-juridico-processos.cod-situacao.
        FIND FIRST juridico-situacoes NO-LOCK
             WHERE juridico-situacoes.codigo = tt-juridico-processos.cod-situacao NO-ERROR.
        IF AVAIL juridico-situacoes THEN
            ASSIGN fi-desc-situacao:SCREEN-VALUE IN FRAME fPage1 = juridico-situacoes.descricao.
        ELSE
            ASSIGN fi-desc-situacao:SCREEN-VALUE IN FRAME fPage1 = "".
    END.
    ELSE DO:
        ASSIGN fi-desc-situacao:SCREEN-VALUE IN FRAME fPage1 = "".
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-juridico-processos.cod-situacao wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-juridico-processos.cod-situacao IN FRAME fPage1 /* C¢d. Situa‡Æo */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-juridico-processos.cod-solucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-juridico-processos.cod-solucao wMaintenanceNoNavigation
ON F5 OF tt-juridico-processos.cod-solucao IN FRAME fPage1 /* C¢d. Solu‡Æo */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es477.w"
                         &FieldZoom1="codigo"
                         &FieldScreen1="tt-juridico-processos.cod-solucao"
                         &Frame1="fPage1"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-desc-solucao"
                         &Frame2="fPage1"
                         &EnableImplant="NO"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-juridico-processos.cod-solucao wMaintenanceNoNavigation
ON LEAVE OF tt-juridico-processos.cod-solucao IN FRAME fPage1 /* C¢d. Solu‡Æo */
DO:
    IF AVAIL tt-juridico-processos THEN DO:
        ASSIGN INPUT FRAME fPage1 tt-juridico-processos.cod-solucao.
        FIND FIRST juridico-solucoes NO-LOCK
             WHERE juridico-solucoes.codigo = tt-juridico-processos.cod-solucao NO-ERROR.
        IF AVAIL juridico-solucoes THEN
            ASSIGN fi-desc-solucao:SCREEN-VALUE IN FRAME fPage1 = juridico-solucoes.descricao.
        ELSE
            ASSIGN fi-desc-solucao:SCREEN-VALUE IN FRAME fPage1 = "".
    END.
    ELSE DO:
        ASSIGN fi-desc-solucao:SCREEN-VALUE IN FRAME fPage1 = "".
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-juridico-processos.cod-solucao wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-juridico-processos.cod-solucao IN FRAME fPage1 /* C¢d. Solu‡Æo */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-juridico-processos.cod-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-juridico-processos.cod-tipo wMaintenanceNoNavigation
ON F5 OF tt-juridico-processos.cod-tipo IN FRAME fPage1 /* C¢d. Tipo */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es468.w"
                         &FieldZoom1="codigo"
                         &FieldScreen1="tt-juridico-processos.cod-tipo"
                         &Frame1="fPage1"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-desc-tipo"
                         &Frame2="fPage1"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-juridico-processos.cod-tipo wMaintenanceNoNavigation
ON LEAVE OF tt-juridico-processos.cod-tipo IN FRAME fPage1 /* C¢d. Tipo */
DO:
    IF AVAIL tt-juridico-processos THEN DO:
        ASSIGN INPUT FRAME fPage1 tt-juridico-processos.cod-tipo.
        FIND FIRST juridico-tipos NO-LOCK
             WHERE juridico-tipos.codigo = tt-juridico-processos.cod-tipo NO-ERROR.
        IF AVAIL juridico-tipos THEN
            ASSIGN fi-desc-tipo:SCREEN-VALUE IN FRAME fPage1 = juridico-tipos.descricao.
        ELSE
            ASSIGN fi-desc-tipo:SCREEN-VALUE IN FRAME fPage1 = "".
    END.
    ELSE DO:
        ASSIGN fi-desc-tipo:SCREEN-VALUE IN FRAME fPage1 = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-juridico-processos.cod-tipo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-juridico-processos.cod-tipo IN FRAME fPage1 /* C¢d. Tipo */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/

 tt-juridico-processos.cod-motivo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
 tt-juridico-processos.cod-tipo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
 tt-juridico-processos.cod-situacao:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
 tt-juridico-processos.cod-solucao:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.

 {maintenancenonavigation/mainblock.i}

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

    if valid-handle(h-boes472) then
        delete procedure h-boes472.

    RETURN "OK":U.

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
    
    IF AVAIL tt-juridico-processos THEN DO:
        APPLY "LEAVE":U TO tt-juridico-processos.cod-motivo   IN FRAME fPage1.
        APPLY "LEAVE":U TO tt-juridico-processos.cod-tipo     IN FRAME fPage1.
        APPLY "LEAVE":U TO tt-juridico-processos.cod-situacao IN FRAME fPage1.
        APPLY "LEAVE":U TO tt-juridico-processos.cod-solucao  IN FRAME fPage1.
    END.
    ELSE
        ASSIGN fi-desc-motivo:SCREEN-VALUE IN FRAME fPage1    = ""
               fi-desc-tipo:SCREEN-VALUE IN FRAME fPage1      = ""
               fi-desc-situacao:SCREEN-VALUE IN FRAME fPage1  = ""
               fi-desc-solucao:SCREEN-VALUE IN FRAME fPage1   = "".
                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    APPLY "ENTRY" TO tt-juridico-processos.processo IN FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-desc AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-esapi015 AS HANDLE      NO-UNDO.

    FOR EACH tt-unid-negoc:
        DELETE tt-unid-negoc.
    END.
    
    RUN esapi/esapi015.p PERSISTENT SET h-esapi015.
    RUN pi-retorna-unidade IN h-esapi015 (OUTPUT TABLE tt-unid-negoc).
    DELETE PROCEDURE h-esapi015.

    ASSIGN tt-juridico-processos.cod-unid-negoc:LIST-ITEM-PAIRS IN FRAME fPage2 = ",".

    FOR EACH tt-unid-negoc BY tt-unid-negoc.cod-unid-negoc:
        ASSIGN c-desc = tt-unid-negoc.cod-unid-negoc + "-" + tt-unid-negoc.descricao.

        tt-juridico-processos.cod-unid-negoc:add-last(c-desc, tt-unid-negoc.cod-unid-negoc) IN FRAME fPage2 NO-ERROR.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "esbo\boes472.p":U THEN DO:
        {btb/btb008za.i1 esbo\boes472.p YES}
        {btb/btb008za.i2 esbo\boes472.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
                  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

