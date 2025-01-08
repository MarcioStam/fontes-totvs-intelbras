&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-relat 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esccp040 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/*:T Preprocessadores do Template de Relat¢rio                            */
/*:T Obs: Retirar o valor do preprocessador para as p ginas que nÆo existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA 
&GLOBAL-DEFINE PGPAR 
&GLOBAL-DEFINE PGDIG
&GLOBAL-DEFINE PGIMP f-pg-imp

&GLOBAL-DEFINE RTF   NO
  
/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */
{esp/ccp/esccp040tt.i}

/* Transfer Definitions */

DEFINE VARIABLE raw-param        as raw no-undo.

/* Local Variable Definitions ---                                       */

def var l-ok               as logical no-undo.
def var c-terminal         as char    no-undo.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est  rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.


DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-page            AS INTEGER             NO-UNDO INITIAL 1.
DEFINE VARIABLE hProgramZoom AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-imp

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-7 RECT-9 rs-destino bt-arquivo ~
bt-config-impr c-arquivo rs-execucao 
&Scoped-Define DISPLAYED-OBJECTS rs-destino c-arquivo rs-execucao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-relat AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-config-impr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-arquivo AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.79.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE c-nr-embarque AS CHARACTER FORMAT "x(12)":U INITIAL "0" 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-corte AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     LABEL "Data de Corte" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-plan AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     LABEL "Data de Corte para Ordens Planejadas" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab-ini AS CHARACTER FORMAT "x(5)" 
     LABEL "Estabelcimento" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-titulo AS CHARACTER FORMAT "X(256)":U INITIAL "Ordens de Compra de Beneficiamento" 
     LABEL "" 
      VIEW-AS TEXT 
     SIZE 27 BY .67 NO-UNDO.

DEFINE VARIABLE fi-unid-negoc-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unid-negoc-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-cd-plano AS INTEGER FORMAT ">>9" INITIAL 5 
     LABEL "Plano":R7 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE txt-saldo-terc AS CHARACTER FORMAT "X(256)" INITIAL "Considera Saldos em Terceiros" 
      VIEW-AS TEXT 
     SIZE 21.72 BY .67 NO-UNDO.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-benefic AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Considera", 1,
"NÆo Considera", 2,
"Demonstra", 3
     SIZE 72 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 74.57 BY 1.5.

DEFINE RECTANGLE RECT-38
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32.86 BY 6.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41.29 BY 8.

DEFINE RECTANGLE RECT-41
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32.57 BY 1.83.

DEFINE RECTANGLE RECT-42
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 74.57 BY 5.75.

DEFINE VARIABLE l-en-con2 AS LOGICAL INITIAL yes 
     LABEL "Entrada em Consigna‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .71 NO-UNDO.

DEFINE VARIABLE l-entrada2 AS LOGICAL INITIAL yes 
     LABEL "Entrada p/ Beneficiamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .71 NO-UNDO.

DEFINE VARIABLE l-re-con2 AS LOGICAL INITIAL yes 
     LABEL "Remessa em Consigna‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .71 NO-UNDO.

DEFINE VARIABLE l-remessa2 AS LOGICAL INITIAL yes 
     LABEL "Remessa p/ Beneficiamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .71 NO-UNDO.

DEFINE VARIABLE l-transfer2 AS LOGICAL INITIAL yes 
     LABEL "Transferˆncia" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .71 NO-UNDO.

DEFINE VARIABLE tb-cred-aprov AS LOGICAL INITIAL yes 
     LABEL "Apenas Pedidos com Cr‚dito Aprovado?" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .71 NO-UNDO.

DEFINE VARIABLE tb-ord-comp AS LOGICAL INITIAL no 
     LABEL "Considera Ordens de Compra?" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .71 NO-UNDO.

DEFINE VARIABLE tb-ord-prod AS LOGICAL INITIAL no 
     LABEL "Considera Ordens de Produ‡Æo?" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .71 NO-UNDO.

DEFINE VARIABLE tb-pedidos AS LOGICAL INITIAL yes 
     LABEL "Considera Pedidos em Carteira?" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .71 NO-UNDO.

DEFINE VARIABLE tb-planejada AS LOGICAL INITIAL no 
     LABEL "Considera Ordens Planejadas?" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .71 NO-UNDO.

DEFINE VARIABLE tb-res-comp AS LOGICAL INITIAL yes 
     LABEL "Considera Reservas Comprometidas?" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .71 NO-UNDO.

DEFINE VARIABLE tb-res-plan AS LOGICAL INITIAL yes 
     LABEL "Considera Reservas Planejadas?" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .71 NO-UNDO.

DEFINE VARIABLE tb-sald-est AS LOGICAL INITIAL yes 
     LABEL "Considera Saldo em Estoque?" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .71 NO-UNDO.

DEFINE VARIABLE tb-sald-terc AS LOGICAL INITIAL yes 
     LABEL "Considera Saldo em Poder de Terceiros?" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .71 NO-UNDO.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Fechar" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 15 BY 1.

DEFINE IMAGE im-pg-imp
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 79 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 17.38
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0    
     SIZE .43 BY 11.21
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0    
     SIZE .43 BY 17.17
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     bt-executar AT ROW 20.25 COL 3 HELP
          "Dispara a execu‡Æo do relat¢rio"
     bt-cancelar AT ROW 20.25 COL 18.57 HELP
          "Fechar"
     bt-ajuda AT ROW 20.25 COL 65 HELP
          "Ajuda"
     RECT-1 AT ROW 20 COL 2
     RECT-6 AT ROW 19.75 COL 2.14
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder AT ROW 2.5 COL 2
     im-pg-imp AT ROW 1.5 COL 17.86
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 20.54
         DEFAULT-BUTTON bt-executar WIDGET-ID 100.

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 2.29 COL 4.86 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL WIDGET-ID 12
     bt-arquivo AT ROW 3.38 COL 44.86 HELP
          "Escolha do nome do arquivo" WIDGET-ID 2
     bt-config-impr AT ROW 3.38 COL 44.86 HELP
          "Configura‡Æo da impressora" WIDGET-ID 4
     c-arquivo AT ROW 3.42 COL 4.86 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL WIDGET-ID 6
     rs-execucao AT ROW 5.67 COL 4.43 HELP
          "Modo de Execu‡Æo" NO-LABEL WIDGET-ID 16
     text-destino AT ROW 1.71 COL 5.43 NO-LABEL WIDGET-ID 20
     text-modo AT ROW 4.92 COL 2.72 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     RECT-7 AT ROW 2 COL 3.72 WIDGET-ID 8
     RECT-9 AT ROW 5.13 COL 3.57 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.83
         SIZE 76.72 BY 16.71 WIDGET-ID 100.

DEFINE FRAME f-pg-sel
     fi-estab-ini AT ROW 1.96 COL 52 RIGHT-ALIGNED WIDGET-ID 18
     c-nr-embarque AT ROW 2.96 COL 52 RIGHT-ALIGNED WIDGET-ID 28
     fi-unid-negoc-ini AT ROW 3.96 COL 52 RIGHT-ALIGNED WIDGET-ID 22
     fi-unid-negoc-fim AT ROW 3.96 COL 65 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     fi-dt-corte AT ROW 4.96 COL 56 RIGHT-ALIGNED WIDGET-ID 12
     fi-dt-plan AT ROW 5.96 COL 56 RIGHT-ALIGNED WIDGET-ID 14
     tb-ord-comp AT ROW 8.13 COL 5.86 WIDGET-ID 66
     l-remessa2 AT ROW 8.33 COL 48 WIDGET-ID 52
     tb-ord-prod AT ROW 8.88 COL 5.86 WIDGET-ID 68
     l-entrada2 AT ROW 9.33 COL 48 WIDGET-ID 6
     tb-planejada AT ROW 9.63 COL 5.86 WIDGET-ID 30
     l-transfer2 AT ROW 10.33 COL 48 WIDGET-ID 54
     tb-res-comp AT ROW 10.38 COL 5.86 WIDGET-ID 32
     tb-res-plan AT ROW 11.13 COL 5.86 WIDGET-ID 34
     l-re-con2 AT ROW 11.33 COL 48 WIDGET-ID 50
     tb-sald-est AT ROW 11.88 COL 5.86 WIDGET-ID 36
     l-en-con2 AT ROW 12.33 COL 48 WIDGET-ID 4
     tb-sald-terc AT ROW 12.63 COL 5.86 WIDGET-ID 38
     tb-pedidos AT ROW 13.38 COL 5.86 WIDGET-ID 70
     i-cd-plano AT ROW 14.08 COL 56 COLON-ALIGNED WIDGET-ID 2
     tb-cred-aprov AT ROW 14.13 COL 5.86 WIDGET-ID 62
     rs-benefic AT ROW 16.38 COL 3.29 NO-LABEL WIDGET-ID 46
     txt-saldo-terc AT ROW 7.25 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     fi-titulo AT ROW 15.58 COL 2.43 WIDGET-ID 42
     "Sele‡Æo" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 1.25 COL 3.72 WIDGET-ID 74
     IMAGE-3 AT ROW 3.96 COL 54 WIDGET-ID 24
     IMAGE-4 AT ROW 3.96 COL 63.29 WIDGET-ID 26
     RECT-41 AT ROW 13.67 COL 43.72 WIDGET-ID 60
     RECT-40 AT ROW 7.5 COL 2 WIDGET-ID 58
     RECT-38 AT ROW 7.5 COL 43.72 WIDGET-ID 56
     RECT-2 AT ROW 15.92 COL 2 WIDGET-ID 44
     RECT-42 AT ROW 1.5 COL 2 WIDGET-ID 72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.83
         SIZE 76.72 BY 16.71
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-relat
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-relat ASSIGN
         HIDDEN             = YES
         TITLE              = "<Title>"
         HEIGHT             = 20.58
         WIDTH              = 81.57
         MAX-HEIGHT         = 24.88
         MAX-WIDTH          = 160.43
         VIRTUAL-HEIGHT     = 24.88
         VIRTUAL-WIDTH      = 160.43
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-relat 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-relat
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-pg-imp
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Execu‡Æo".

/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FILL-IN c-nr-embarque IN FRAME f-pg-sel
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-dt-corte IN FRAME f-pg-sel
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-dt-plan IN FRAME f-pg-sel
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-estab-ini IN FRAME f-pg-sel
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-titulo IN FRAME f-pg-sel
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-unid-negoc-fim IN FRAME f-pg-sel
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN fi-unid-negoc-ini IN FRAME f-pg-sel
   NO-DISPLAY ALIGN-R                                                   */
/* SETTINGS FOR FILL-IN txt-saldo-terc IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-relat
                                                                        */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-left IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-right IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-top IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
THEN w-relat:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-imp
/* Query rebuild information for FRAME f-pg-imp
     _Query            is NOT OPENED
*/  /* FRAME f-pg-imp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-sel
/* Query rebuild information for FRAME f-pg-sel
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON END-ERROR OF w-relat /* <Title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON WINDOW-CLOSE OF w-relat /* <Title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-relat
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo w-relat
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    {include/i-rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-relat
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Fechar */
DO:
   apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-config-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr w-relat
ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:
   {include/i-rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar w-relat
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
   do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME c-nr-embarque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-embarque w-relat
ON F5 OF c-nr-embarque IN FRAME f-pg-sel /* Embarque */
DO:
   {method/ZoomFields.i &ProgramZoom="cxzoom/z10cx220.w"
                         &FieldZoom1="embarque"
                         &FieldScreen1="c-nr-embarque"
                         &Frame1="f-pg-sel"
                         &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-embarque w-relat
ON MOUSE-SELECT-DBLCLICK OF c-nr-embarque IN FRAME f-pg-sel /* Embarque */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-estab-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estab-ini w-relat
ON F5 OF fi-estab-ini IN FRAME f-pg-sel /* Estabelcimento */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=fi-estab-ini
                     &campozoom=cod-estabel}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estab-ini w-relat
ON MOUSE-SELECT-DBLCLICK OF fi-estab-ini IN FRAME f-pg-sel /* Estabelcimento */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cd-plano
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-plano w-relat
ON MOUSE-SELECT-DBLCLICK OF i-cd-plano IN FRAME f-pg-sel /* Plano */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-imp w-relat
ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel w-relat
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino w-relat
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp
DO:
    do  with frame f-pg-imp:
        case self:screen-value:
            when "1" then do:
                assign c-arquivo:sensitive    = no
                       bt-arquivo:visible     = no
                       bt-config-impr:visible = yes
                       .
            end.
            when "2" then do:
                assign c-arquivo:sensitive     = yes
                       bt-arquivo:visible      = yes
                       bt-config-impr:visible  = no
                       .
            end.
            when "3" then do:
                assign c-arquivo:sensitive     = no
                       bt-arquivo:visible      = no
                       bt-config-impr:visible  = no
                       .
            end.
        end case.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao w-relat
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME tb-planejada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-planejada w-relat
ON VALUE-CHANGED OF tb-planejada IN FRAME f-pg-sel /* Considera Ordens Planejadas? */
DO:
  if input frame {&frame-name} tb-planejada or 
     input frame {&frame-name} tb-res-plan  then 
     enable i-cd-plano with frame {&frame-name}.
  else 
     disable i-cd-plano with frame {&frame-name}.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-res-plan
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-res-plan w-relat
ON VALUE-CHANGED OF tb-res-plan IN FRAME f-pg-sel /* Considera Reservas Planejadas? */
DO:
  if input frame {&frame-name} tb-planejada or 
     input frame {&frame-name} tb-res-plan  then 
     enable i-cd-plano with frame {&frame-name}.
  else 
     disable i-cd-plano with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-sald-terc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-sald-terc w-relat
ON VALUE-CHANGED OF tb-sald-terc IN FRAME f-pg-sel /* Considera Saldo em Poder de Terceiros? */
DO:
  assign l-remessa2:sensitive  in frame {&frame-name} = tb-sald-terc:checked in frame {&frame-name}
         l-remessa2:checked    in frame {&frame-name} = tb-sald-terc:checked in frame {&frame-name}
         l-entrada2:sensitive  in frame {&frame-name} = tb-sald-terc:checked in frame {&frame-name}
         l-entrada2:checked    in frame {&frame-name} = tb-sald-terc:checked in frame {&frame-name}
         l-transfer2:sensitive in frame {&frame-name} = tb-sald-terc:checked in frame {&frame-name}
         l-transfer2:checked   in frame {&frame-name} = tb-sald-terc:checked in frame {&frame-name}
         l-re-con2:sensitive   in frame {&frame-name} = tb-sald-terc:checked in frame {&frame-name}
         l-re-con2:checked     in frame {&frame-name} = tb-sald-terc:checked in frame {&frame-name}
         l-en-con2:sensitive   in frame {&frame-name} = tb-sald-terc:checked in frame {&frame-name}
         l-en-con2:checked     in frame {&frame-name} = tb-sald-terc:checked in frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-relat 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "esccp040" "1.00.00.000"}

/*:T inicializa‡äes do template de relat¢rio */
{include/i-rpini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

{include/i-rplbl.i}

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.
    
    ASSIGN fi-estab-ini:screen-value      in frame f-pg-sel = "105":U
           fi-unid-negoc-fim:screen-value in frame f-pg-sel = "ZZZ":U.

    IF c-nr-embarque:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-sel THEN.

    {include/i-rpmbl.i}
  
    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-relat  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-relat  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-relat  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
  THEN DELETE WIDGET w-relat.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-relat  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE im-pg-imp im-pg-sel bt-executar bt-cancelar bt-ajuda 
      WITH FRAME f-relat IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY rs-destino c-arquivo rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  ENABLE RECT-7 RECT-9 rs-destino bt-arquivo bt-config-impr c-arquivo 
         rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  DISPLAY fi-estab-ini c-nr-embarque fi-dt-corte fi-dt-plan tb-ord-comp 
          l-remessa2 tb-ord-prod l-entrada2 tb-planejada l-transfer2 tb-res-comp 
          tb-res-plan l-re-con2 tb-sald-est l-en-con2 tb-sald-terc tb-pedidos 
          i-cd-plano tb-cred-aprov rs-benefic txt-saldo-terc fi-titulo 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  ENABLE IMAGE-3 IMAGE-4 RECT-41 RECT-40 RECT-38 RECT-2 RECT-42 fi-estab-ini 
         c-nr-embarque fi-unid-negoc-ini fi-unid-negoc-fim fi-dt-corte 
         fi-dt-plan tb-ord-comp l-remessa2 tb-ord-prod l-entrada2 tb-planejada 
         l-transfer2 tb-res-comp tb-res-plan l-re-con2 tb-sald-est l-en-con2 
         tb-sald-terc tb-pedidos i-cd-plano tb-cred-aprov rs-benefic 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  VIEW w-relat.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-relat 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar w-relat 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
do on error undo, return error on stop  undo, return error:
    {include/i-rpexa.i}
    if input frame f-pg-imp rs-destino = 2 and
       input frame f-pg-imp rs-execucao = 1 then do:
        run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "").
            
            apply "MOUSE-SELECT-CLICK":U to im-pg-imp in frame f-relat.
            apply "ENTRY":U to c-arquivo in frame f-pg-imp.
            return error.
        end.
    end.

    /*---[ cria‡Æo tt-param ]-----------------------------------------------------*/
    create tt-param.
    assign tt-param.usuario        = c-seg-usuario
           tt-param.destino        = input frame f-pg-imp rs-destino
           tt-param.data-exec      = today
           tt-param.hora-exec      = TIME
           tt-param.cd-plano       = input frame f-pg-sel i-cd-plano
           tt-param.benefic        = input frame f-pg-sel rs-benefic
           tt-param.dt-corte       = input frame f-pg-sel fi-dt-corte       
           tt-param.dt-plan        = input frame f-pg-sel fi-dt-plan       
           tt-param.estab-ini      = input frame f-pg-sel fi-estab-ini     
           tt-param.estab-fim      = tt-param.estab-ini /* ficar  usando o mesmo do estabelecimento inicial */
           tt-param.unid-negoc-fim = input frame f-pg-sel fi-unid-negoc-fim
           tt-param.unid-negoc-ini = input frame f-pg-sel fi-unid-negoc-ini
           tt-param.embarque       = input frame f-pg-sel c-nr-embarque
           tt-param.en-con2        = l-en-con2:checked     in frame f-pg-sel  
           tt-param.entrada2       = l-entrada2:checked    in frame f-pg-sel  
           tt-param.re-con2        = l-re-con2:checked     in frame f-pg-sel  
           tt-param.remessa2       = l-remessa2:checked    in frame f-pg-sel  
           tt-param.transfer2      = l-transfer2:checked   in frame f-pg-sel  
           tt-param.cred-aprov     = tb-cred-aprov:checked in frame f-pg-sel  
           tt-param.ord-comp       = tb-ord-comp:checked   in frame f-pg-sel  
           tt-param.ord-prod       = tb-ord-prod:checked   in frame f-pg-sel  
           tt-param.pedidos        = tb-pedidos:checked    in frame f-pg-sel  
           tt-param.planejada      = tb-planejada:checked  in frame f-pg-sel  
           tt-param.res-comp       = tb-res-comp:checked   in frame f-pg-sel  
           tt-param.res-plan       = tb-res-plan:checked   in frame f-pg-sel  
           tt-param.sald-est       = tb-sald-est:checked   in frame f-pg-sel  
           tt-param.sald-terc      = tb-sald-terc:checked  in frame f-pg-sel  
           .
                    
    if tt-param.destino = 1 
    then assign tt-param.arquivo = "".
    else if  tt-param.destino = 2
         then assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".lst":U.
    /*Fim alteracao 14/02/2005*/

    /*:T Coloque aqui a/l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    
    
    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {include/i-rpexb.i}
    
    SESSION:SET-WAIT-STATE("general":U).
    
    {include/i-rprun.i esp/ccp/esccp040rp.p}
    
    {include/i-rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {include/i-rptrm.i}
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina w-relat 
PROCEDURE pi-troca-pagina :
/*:T------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-relat  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this w-relat, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-relat 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
  
  run pi-trata-state (p-issuer-hdl, p-state).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

