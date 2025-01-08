&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-equipamentos NO-UNDO LIKE equipamentos
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
{include/i-prgvrs.i ESUTP002A 1.00.00.000}  /*** 010000 ***/
/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

{cdp/cdcfgmat.i} /*Definiá∆o dos prÇ-processadores*/
{cdp/cdcfgcex.i}
{include/i_dbvers.i}

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESUTP002A
&GLOBAL-DEFINE Version           1.00.00.000
&GLOBAL-DEFINE DBOVersion        2.0

&GLOBAL-DEFINE ttTable           tt-equipamentos
&GLOBAL-DEFINE hDBOTable         h-boes407
&GLOBAL-DEFINE DBOTable          desp-imp

&GLOBAL-DEFINE page0KeyFields    tt-equipamentos.cod-estabel tt-equipamentos.equipamento
&GLOBAL-DEFINE page0Fields       tt-equipamentos.descricao tt-equipamentos.tipo tt-equipamentos.ct-codigo tt-equipamentos.val-limite ~
                                 tt-equipamentos.fornecedor tt-equipamentos.marca tt-equipamentos.modelo tt-equipamentos.serie-equipamento tt-equipamentos.serie-acessorio ~
                                 tt-equipamentos.cod_usuario tt-equipamentos.cargo tt-equipamentos.ind-utiliz tt-equipamentos.obs-situacao tt-equipamentos.ind-cobranca ~
                                 tt-equipamentos.cod_gestor_cobranca tt-equipamentos.ind-situacao tg-desc-integral

                                 
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

def new global shared var v_rec_usuar_mestre
    as recid
    format ">>>>>>9"
    initial ?
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
&Scoped-Define ENABLED-FIELDS tt-equipamentos.cod-estabel ~
tt-equipamentos.equipamento tt-equipamentos.descricao ~
tt-equipamentos.ct-codigo tt-equipamentos.fornecedor ~
tt-equipamentos.ind-utiliz tt-equipamentos.marca tt-equipamentos.modelo ~
tt-equipamentos.serie-equipamento tt-equipamentos.serie-acessorio ~
tt-equipamentos.ind-situacao tt-equipamentos.obs-situacao ~
tt-equipamentos.cargo tt-equipamentos.ind-cobranca ~
tt-equipamentos.val-limite tt-equipamentos.tipo tt-equipamentos.cod_usuario ~
tt-equipamentos.cod_gestor_cobranca 
&Scoped-define ENABLED-TABLES tt-equipamentos
&Scoped-define FIRST-ENABLED-TABLE tt-equipamentos
&Scoped-Define ENABLED-OBJECTS tg-desc-integral fi-desc-estabel ~
fi-desc-conta fi-nome-fornec fi-nome-usuario fi-nome-gestor btOK btSave ~
btCancel btHelp fi-desc-tipo RECT-2 RECT-1 rtToolBar RECT-3 RECT-4 RECT-5 ~
RECT-6 
&Scoped-Define DISPLAYED-FIELDS tt-equipamentos.cod-estabel ~
tt-equipamentos.equipamento tt-equipamentos.descricao ~
tt-equipamentos.ct-codigo tt-equipamentos.fornecedor ~
tt-equipamentos.ind-utiliz tt-equipamentos.marca tt-equipamentos.modelo ~
tt-equipamentos.serie-equipamento tt-equipamentos.serie-acessorio ~
tt-equipamentos.ind-situacao tt-equipamentos.obs-situacao ~
tt-equipamentos.cargo tt-equipamentos.ind-cobranca ~
tt-equipamentos.val-limite tt-equipamentos.tipo tt-equipamentos.cod_usuario ~
tt-equipamentos.cod_gestor_cobranca 
&Scoped-define DISPLAYED-TABLES tt-equipamentos
&Scoped-define FIRST-DISPLAYED-TABLE tt-equipamentos
&Scoped-Define DISPLAYED-OBJECTS tg-desc-integral fi-desc-estabel ~
fi-desc-conta fi-nome-fornec fi-nome-usuario fi-nome-gestor fi-desc-tipo 

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

DEFINE VARIABLE fi-desc-conta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-tipo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-fornec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-gestor AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-usuario AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.43 BY 3.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.43 BY 16.75.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 3.33.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 6.54.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 2.29.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 2.42.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-desc-integral AS LOGICAL INITIAL no 
     LABEL "Desconta Integral" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 TOOLTIP "Descontar o valor integral da conta na folha de pagamento" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tg-desc-integral AT ROW 18.75 COL 65 WIDGET-ID 154
     tt-equipamentos.cod-estabel AT ROW 1.75 COL 17 COLON-ALIGNED WIDGET-ID 24
          LABEL "Estabelecimento"
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     fi-desc-estabel AT ROW 1.75 COL 21.14 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     tt-equipamentos.equipamento AT ROW 2.75 COL 9.28 WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 22.57 BY .88
     tt-equipamentos.descricao AT ROW 2.75 COL 39.86 COLON-ALIGNED NO-LABEL WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 41.72 BY .88
     tt-equipamentos.ct-codigo AT ROW 6.13 COL 16.86 COLON-ALIGNED WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .88
     fi-desc-conta AT ROW 6.13 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     tt-equipamentos.fornecedor AT ROW 7.13 COL 17 COLON-ALIGNED WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-nome-fornec AT ROW 7.13 COL 23.29 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     tt-equipamentos.ind-utiliz AT ROW 8.96 COL 19.29 NO-LABEL WIDGET-ID 130
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Ambos", 0,
"Celular", 1,
"Chip", 2
          SIZE 27.72 BY .79
     tt-equipamentos.marca AT ROW 9.79 COL 17.14 COLON-ALIGNED WIDGET-ID 134
          VIEW-AS FILL-IN 
          SIZE 23.14 BY .88
     tt-equipamentos.modelo AT ROW 9.75 COL 53.29 COLON-ALIGNED WIDGET-ID 136
          VIEW-AS FILL-IN 
          SIZE 27 BY .88
     tt-equipamentos.serie-equipamento AT ROW 10.75 COL 17.29 COLON-ALIGNED WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 23 BY .88
     tt-equipamentos.serie-acessorio AT ROW 10.71 COL 53.29 COLON-ALIGNED WIDGET-ID 60
          VIEW-AS FILL-IN 
          SIZE 27 BY .88
     tt-equipamentos.ind-situacao AT ROW 11.79 COL 19.29 NO-LABEL WIDGET-ID 126
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Ativo", 0,
"Bloqueado", 1,
"Cancelado", 2
          SIZE 31.72 BY .71
     tt-equipamentos.obs-situacao AT ROW 12.5 COL 19.29 NO-LABEL WIDGET-ID 138
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 63 BY 2.54
     fi-nome-usuario AT ROW 15.92 COL 24.72 COLON-ALIGNED NO-LABEL WIDGET-ID 122
     tt-equipamentos.cargo AT ROW 16.88 COL 17.14 COLON-ALIGNED WIDGET-ID 64
          VIEW-AS FILL-IN 
          SIZE 63 BY .88
     tt-equipamentos.ind-cobranca AT ROW 18.83 COL 19.43 NO-LABEL WIDGET-ID 116
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Nenhum", 0,
"Tarifador", 1,
"Excel", 2
          SIZE 24.72 BY .79
     tt-equipamentos.val-limite AT ROW 18.75 COL 53 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     fi-nome-gestor AT ROW 19.71 COL 24.72 COLON-ALIGNED NO-LABEL WIDGET-ID 120
     btOK AT ROW 21.75 COL 2.29
     btSave AT ROW 21.75 COL 13.29
     btCancel AT ROW 21.75 COL 24.29
     btHelp AT ROW 21.75 COL 80.29
     tt-equipamentos.tipo AT ROW 5.17 COL 16.86 COLON-ALIGNED WIDGET-ID 148
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-desc-tipo AT ROW 5.17 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 146
     tt-equipamentos.cod_usuario AT ROW 15.92 COL 17 COLON-ALIGNED WIDGET-ID 156
          LABEL "Matr°cula"
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.72 BY 22.08
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     tt-equipamentos.cod_gestor_cobranca AT ROW 19.71 COL 14.86 COLON-ALIGNED WIDGET-ID 158
          LABEL "Gestor"
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     "Dados:" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 4.71 COL 6.72 WIDGET-ID 80
     "Celular:" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 8.38 COL 6.72 WIDGET-ID 84
     "Usu†rio:" VIEW-AS TEXT
          SIZE 6.29 BY .54 AT ROW 15.38 COL 6.86 WIDGET-ID 94
     "Tarifador:" VIEW-AS TEXT
          SIZE 7.29 BY .54 AT ROW 18.13 COL 6.86 WIDGET-ID 98
     "Tipo Cobranáa:" VIEW-AS TEXT
          SIZE 10.86 BY .54 AT ROW 18.92 COL 8.57 WIDGET-ID 124
     "Observaá‰es:" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 13.13 COL 9.29 WIDGET-ID 140
     "Utilizaá∆o:" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 9.04 COL 12 WIDGET-ID 142
     "Situaá∆o:" VIEW-AS TEXT
          SIZE 6.86 BY .54 AT ROW 11.79 COL 12.14 WIDGET-ID 144
     RECT-2 AT ROW 4.5 COL 1.72
     RECT-1 AT ROW 1.17 COL 1.57
     rtToolBar AT ROW 21.5 COL 1.29
     RECT-3 AT ROW 4.92 COL 4.72 WIDGET-ID 78
     RECT-4 AT ROW 8.71 COL 4.72 WIDGET-ID 82
     RECT-5 AT ROW 15.67 COL 4.72 WIDGET-ID 92
     RECT-6 AT ROW 18.46 COL 4.72 WIDGET-ID 96
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.72 BY 22.08
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-equipamentos T "?" NO-UNDO mgesp equipamentos
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
         HEIGHT             = 22.08
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN tt-equipamentos.cod-estabel IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-equipamentos.cod_gestor_cobranca IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-equipamentos.cod_usuario IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-equipamentos.equipamento IN FRAME fpage0
   ALIGN-L                                                              */
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
    ASSIGN tt-equipamentos.log-desconta-integral = INPUT FRAME {&FRAME-NAME} tg-desc-integral.
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
    ASSIGN tt-equipamentos.log-desconta-integral = INPUT FRAME {&FRAME-NAME} tg-desc-integral.
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-equipamentos.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.cod-estabel wMaintenanceNoNavigation
ON F5 OF tt-equipamentos.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                        &campo=tt-equipamentos.cod-estabel
                        &campozoom=cod-estabel
                        &campo2=fi-desc-estabel
                        &campozoom2=nome}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-equipamentos.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:

    assign input frame fPage0 tt-equipamentos.cod-estabel.

    {include/leave.i &tabela=estabelec
                    &atributo-ref=nome
                    &variavel-ref=fi-desc-estabel
                    &where="estabelec.cod-estabel = tt-equipamentos.cod-estabel"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.cod-estabel wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-equipamentos.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-equipamentos.cod_gestor_cobranca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.cod_gestor_cobranca wMaintenanceNoNavigation
ON F5 OF tt-equipamentos.cod_gestor_cobranca IN FRAME fpage0 /* Gestor */
DO:
    RUN sec/sec000ka.p /*prg_sea_usuar_mestre*/.
    IF  v_rec_usuar_mestre <> ? THEN DO:
        FIND usuar_mestre NO-LOCK
            WHERE RECID(usuar_mestre) = v_rec_usuar_mestre NO-ERROR.
    
        DISP usuar_mestre.cod_usuar @ tt-equipamentos.cod_gestor_cobranca WITH FRAME fpage0.
        APPLY "leave" TO tt-equipamentos.cod_gestor_cobranca IN FRAME fpage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.cod_gestor_cobranca wMaintenanceNoNavigation
ON LEAVE OF tt-equipamentos.cod_gestor_cobranca IN FRAME fpage0 /* Gestor */
DO:
    assign input frame fPage0 tt-equipamentos.cod_gestor_cobranca.

    IF tt-equipamentos.cod_gestor_cobranca <> "" THEN DO:
        FIND FIRST usuar_mestre NO-LOCK
             WHERE usuar_mestre.cod_usuario = tt-equipamentos.cod_gestor_cobranca NO-ERROR.
        IF AVAIL usuar_mestre THEN DO:
            ASSIGN fi-nome-gestor:SCREEN-VALUE IN FRAME fPage0= usuar_mestre.nom_usuario.
        END.
        ELSE DO:
            ASSIGN fi-nome-gestor:SCREEN-VALUE IN FRAME fPage0= "".
        END.
    END.
    ELSE ASSIGN fi-nome-gestor:SCREEN-VALUE IN FRAME fPage0= "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.cod_gestor_cobranca wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-equipamentos.cod_gestor_cobranca IN FRAME fpage0 /* Gestor */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-equipamentos.cod_usuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.cod_usuario wMaintenanceNoNavigation
ON F5 OF tt-equipamentos.cod_usuario IN FRAME fpage0 /* Matr°cula */
DO:
    RUN sec/sec000ka.p /*prg_sea_usuar_mestre*/.
    IF  v_rec_usuar_mestre <> ? THEN DO:
        FIND usuar_mestre NO-LOCK
            WHERE RECID(usuar_mestre) = v_rec_usuar_mestre NO-ERROR.
    
        DISP usuar_mestre.cod_usuar @ tt-equipamentos.cod_usuario WITH FRAME fpage0.
        APPLY "leave" TO tt-equipamentos.cod_usuario IN FRAME fpage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.cod_usuario wMaintenanceNoNavigation
ON LEAVE OF tt-equipamentos.cod_usuario IN FRAME fpage0 /* Matr°cula */
DO:
  assign input frame fPage0 tt-equipamentos.cod_usuario.

    IF tt-equipamentos.cod_usuario <> "" THEN DO:
        FIND FIRST usuar_mestre NO-LOCK
             WHERE usuar_mestre.cod_usuario = tt-equipamentos.cod_usuario NO-ERROR.
        IF AVAIL usuar_mestre THEN DO:
            ASSIGN fi-nome-usuario:SCREEN-VALUE IN FRAME fPage0= usuar_mestre.nom_usuario.
        END.
        ELSE DO:
            ASSIGN fi-nome-usuario:SCREEN-VALUE IN FRAME fPage0= "".
        END.
    END.
    ELSE ASSIGN fi-nome-usuario:SCREEN-VALUE IN FRAME fPage0= "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.cod_usuario wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-equipamentos.cod_usuario IN FRAME fpage0 /* Matr°cula */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-equipamentos.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.ct-codigo wMaintenanceNoNavigation
ON F5 OF tt-equipamentos.ct-codigo IN FRAME fpage0 /* Conta */
DO:

    {include/zoomvar.i &prog-zoom="adzoom/z01ad049"
                       &campo="tt-equipamentos.ct-codigo"
                       &campozoom="ct-codigo"
                       &frame="fpage0"
                       &campo2="fi-desc-conta"
                       &campozoom2="titulo"
                       &frame2="fpage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.ct-codigo wMaintenanceNoNavigation
ON LEAVE OF tt-equipamentos.ct-codigo IN FRAME fpage0 /* Conta */
DO:
    ASSIGN INPUT FRAME fPage0 tt-equipamentos.ct-codigo.
    
    ASSIGN fi-desc-conta  = ''.
    FIND cta_ctbl NO-LOCK
        WHERE cta_ctbl.cod_plano_cta_ctbl = 'Padr∆o'
          AND cta_ctbl.cod_cta_ctbl = INPUT FRAME fPage0 tt-equipamentos.ct-codigo NO-ERROR.

    IF AVAILABLE cta_ctbl THEN
        ASSIGN fi-desc-conta = cta_ctbl.des_tit_ctbl.

    DISPLAY fi-desc-conta WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.ct-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-equipamentos.ct-codigo IN FRAME fpage0 /* Conta */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-equipamentos.fornecedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.fornecedor wMaintenanceNoNavigation
ON F5 OF tt-equipamentos.fornecedor IN FRAME fpage0 /* Fornecedor */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es425.w"
                         &FieldZoom1="fornecedor"
                         &FieldScreen1="tt-equipamentos.fornecedor"
                         &Frame1="fPage0"
                         &FieldZoom2="nome"
                         &FieldScreen2="fi-nome-fornec"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.fornecedor wMaintenanceNoNavigation
ON LEAVE OF tt-equipamentos.fornecedor IN FRAME fpage0 /* Fornecedor */
DO:
    ASSIGN INPUT FRAME fPage0 tt-equipamentos.fornecedor.
    {include/leave.i &tabela=fornec-equipamentos
                     &atributo-ref=nome
                     &variavel-ref=fi-nome-fornec
                     &where="fornec-equipamentos.fornecedor = tt-equipamentos.fornecedor"}  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.fornecedor wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-equipamentos.fornecedor IN FRAME fpage0 /* Fornecedor */
DO:
   apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-equipamentos.tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.tipo wMaintenanceNoNavigation
ON F5 OF tt-equipamentos.tipo IN FRAME fpage0 /* Tipo */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es503.w"
                         &FieldZoom1="codigo"
                         &FieldScreen1="tt-equipamentos.tipo"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-desc-tipo"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.tipo wMaintenanceNoNavigation
ON LEAVE OF tt-equipamentos.tipo IN FRAME fpage0 /* Tipo */
DO:
    assign input frame fPage0 tt-equipamentos.tipo.

    {include/leave.i &tabela=tipo-equipamentos
                    &atributo-ref=descricao
                    &variavel-ref=fi-desc-tipo
                    &where="tipo-equipamentos.codigo = tt-equipamentos.tipo"}  
                    

    IF pcAction = "add" THEN DO:
       IF input frame fPage0 tt-equipamentos.tipo = 2 THEN
           ASSIGN tt-equipamentos.val-limite:SCREEN-VALUE IN FRAME fpage0 = "100".
       ELSE
           ASSIGN tt-equipamentos.val-limite:SCREEN-VALUE IN FRAME fpage0 = "0".
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.tipo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-equipamentos.tipo IN FRAME fpage0 /* Tipo */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializaá∆o do programam ---*/
 tt-equipamentos.tipo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
 tt-equipamentos.ct-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
 tt-equipamentos.fornecedor:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
 tt-equipamentos.cod_usuario:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
 tt-equipamentos.cod_gestor_cobranca:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
 
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

    if valid-handle(h-boes407) then
        delete procedure h-boes407.

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
    
    IF pcAction = "add" THEN
        ASSIGN tt-equipamentos.tipo:SCREEN-VALUE IN FRAME fPage0 = "0".

    IF AVAIL tt-equipamentos THEN DO:
        APPLY "LEAVE":U TO tt-equipamentos.cod-estabel IN FRAME fPage0.
        APPLY "LEAVE":U TO tt-equipamentos.tipo   IN FRAME fPage0.
        APPLY "LEAVE":U TO tt-equipamentos.ct-codigo   IN FRAME fPage0.
        APPLY "LEAVE":U TO tt-equipamentos.cod_usuario IN FRAME fPage0.
        APPLY "LEAVE":U TO tt-equipamentos.cod_gestor_cobranca   IN FRAME fPage0.
    END.
    ELSE
        ASSIGN fi-desc-estabel:SCREEN-VALUE IN FRAME fPage0    = ""
               fi-desc-tipo:SCREEN-VALUE IN FRAME fPage0       = ""
               fi-desc-conta:SCREEN-VALUE IN FRAME fPage0      = ""
               fi-nome-usuario:SCREEN-VALUE IN FRAME fPage0    = ""
               fi-nome-gestor:SCREEN-VALUE IN FRAME fPage0     = "".

    RETURN "OK":U.
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

    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "esbo\boes407.p":U THEN DO:
        {btb/btb008za.i1 esbo\boes407.p YES}
        {btb/btb008za.i2 esbo\boes407.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
                  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

