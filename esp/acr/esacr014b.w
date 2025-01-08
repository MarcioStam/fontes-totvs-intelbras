&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*****************************************************************************
**     Programa.........: esp/acr/esacr003a
**     Descricao .......: Relat¢rio 
**     Versao...........: 1.00.000
**     Autor............: Medeiros
**     Criado...........: 09/12/2004
**     Desc. Atualizaá∆o: 
**     Autor............: 
*******************************************************************************/

CREATE WIDGET-POOL.

DEF VAR c-ant                 AS CHAR.
DEF VAR v_num_ped_exec_rpw    AS INTE.
DEF VAR v_log_det             AS logi INIT NO.
DEF VAR v_cod_exessao         AS CHAR.
DEF VAR c-impressora          AS CHAR.
DEF VAR c-layout              AS CHAR.
DEF VAR wh-exessao            as HANDLE.

DEF VAR i-cont                AS INT.

{esp\acr\esacr014tt.i}

DEF INPUT-OUTPUT PARAM TABLE FOR tt-emitente.
DEF OUTPUT PARAM p-ok AS LOG NO-UNDO.

 /* Vari†veis utilizadas na integraá∆o com o EMS5 */
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usu†rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)":U
    label "Pa°s Empresa Usu†rio"
    column-label "Pa°s"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.

def new global shared var v5_cod_empres_usuar
    as character
    format 'x(3)'
    label 'Empresa'
    column-label 'Empresa'
    no-undo.
def new global shared var v5_cod_estab_usuar
    as character
    format 'x(3)'
    label 'Estabelecimento'
    column-label 'Estab'
    no-undo.
def new global shared var v5_cod_grp_usuar_lst 
    as character 
    label 'Grupo Usu†rios' 
    column-label 'Grupo' 
    no-undo.
def new global shared var v5_cod_idiom_usuar
    as character
    format 'x(8)'
    label 'Idioma'
    column-label 'Idioma'
    no-undo.
def new global shared var v5_cod_pais_empres_usuar
    as character
    format 'x(3)'
    label 'Pa°s Empresa Usu†rio'
    column-label 'Pa°s'
    no-undo.
def new global shared var v5_cod_usuar_corren
    as character
    format 'x(12)'
    label 'Usu†rio Corrente'
    column-label 'Usu†rio Corrente'
    no-undo.
def new global shared var v5_cod_usuar_corren_criptog
    as character
    format 'x(16)'
    no-undo.

DEF NEW GLOBAL SHARED VAR V_Num_Ped_Exec_Corren   AS   INTE   FORM ">>>>>9" NO-UNDO.
DEF NEW GLOBAL SHARED VAR V_Cod_Dwb_User          AS   CHAR   FORM "x(15)"  NO-UNDO. /* usuario corrente */


DEFINE VARIABLE l-av-a AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-ava-fim AS INTEGER FORMAT ">>9" 
     INITIAL 30
     LABEL "A Vencer atÇ"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.
    
DEFINE VARIABLE l-av-b AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-avb-ini AS INTEGER FORMAT ">>9" 
     INITIAL 31
     LABEL "de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-avb-fim AS INTEGER FORMAT ">>9" 
     INITIAL 60
     LABEL "atÇ"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-av-c AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-avc-ini AS INTEGER FORMAT ">>9" 
     INITIAL 61
     LABEL "de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-avc-fim AS INTEGER FORMAT ">>9" 
     INITIAL 90
     LABEL "atÇ"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-av-d AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-avd-ini AS INTEGER FORMAT ">>9" 
     INITIAL 91
     LABEL "de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-avd-fim AS INTEGER FORMAT ">>9" 
     INITIAL 120
     LABEL "atÇ"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-av-e AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-ave-ini AS INTEGER FORMAT ">>9"
     INITIAL 121
     LABEL "de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-ave-fim AS INTEGER FORMAT ">>9" 
     INITIAL 150
     LABEL "atÇ"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-av-f AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-avf-ini AS INTEGER FORMAT ">>9" 
     INITIAL 151
     LABEL "de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-avf-fim AS INTEGER FORMAT ">>9" 
     INITIAL 180
     LABEL "atÇ"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-av-g AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-avg-ini AS INTEGER FORMAT ">>9" 
     INITIAL 181
     LABEL "mais de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-ve-a AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-vea-fim AS INTEGER FORMAT ">>9" 
     INITIAL 30
     LABEL "Vencidos atÇ"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.
    
DEFINE VARIABLE l-ve-b AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-veb-ini AS INTEGER FORMAT ">>9" 
     INITIAL 31
     LABEL "de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-veb-fim AS INTEGER FORMAT ">>9" 
     INITIAL 60
     LABEL "atÇ"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-ve-c AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-vec-ini AS INTEGER FORMAT ">>9" 
     INITIAL 61
     LABEL "de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-vec-fim AS INTEGER FORMAT ">>9" 
     INITIAL 90
     LABEL "atÇ"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-ve-d AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-ved-ini AS INTEGER FORMAT ">>9" 
     INITIAL 91
     LABEL "de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-ved-fim AS INTEGER FORMAT ">>9" 
     INITIAL 120
     LABEL "atÇ"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-ve-e AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-vee-ini AS INTEGER FORMAT ">>9"
     INITIAL 121
     LABEL "de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-vee-fim AS INTEGER FORMAT ">>9" 
     INITIAL 150
     LABEL "atÇ"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-ve-f AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-vef-ini AS INTEGER FORMAT ">>9" 
     INITIAL 151
     LABEL "de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-vef-fim AS INTEGER FORMAT ">>9" 
     INITIAL 180
     LABEL "atÇ"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-ve-g AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-veg-ini AS INTEGER FORMAT ">>9" 
     INITIAL 181
     LABEL "mais de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-relat
&Scoped-define BROWSE-NAME br-planilha

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-emitente emitente

/* Definitions for BROWSE br-planilha                                   */
&Scoped-define FIELDS-IN-QUERY-br-planilha tt-emitente.mail tt-emitente.mail-ger tt-emitente.mail-rep tt-emitente.mail-cont emitente.cod-emitente emitente.nome-abrev tt-emitente.ve-a tt-emitente.ve-b tt-emitente.ve-c tt-emitente.ve-d tt-emitente.ve-e tt-emitente.ve-f tt-emitente.ve-g tt-emitente.av-a tt-emitente.av-b tt-emitente.av-c tt-emitente.av-d tt-emitente.av-e tt-emitente.av-f tt-emitente.av-g tt-emitente.e-mail tt-emitente.e-mail-ger tt-emitente.e-mail-rep tt-emitente.e-mail-cont   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-planilha tt-emitente.mail ~
  tt-emitente.mail-ger ~
  tt-emitente.mail-rep ~
  tt-emitente.mail-cont ~
  tt-emitente.e-mail ~
   tt-emitente.e-mail-ger ~
  tt-emitente.e-mail-rep ~
  tt-emitente.e-mail-cont   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-planilha tt-emitente
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-planilha tt-emitente
&Scoped-define SELF-NAME br-planilha
&Scoped-define QUERY-STRING-br-planilha FOR EACH tt-emitente USE-INDEX valor2, ~
                                   FIRST emitente OF tt-emitente NO-LOCK.  ASSIGN tt-emitente.ve-a:LABEL IN BROWSE {&browse-name} = "Venc ate " + STRING(fx-vea-fim)        tt-emitente.ve-b:LABEL IN BROWSE {&browse-name} = STRING(fx-veb-ini) + " ate " + STRING(fx-veb-fim)        tt-emitente.ve-c:LABEL IN BROWSE {&browse-name} = STRING(fx-vec-ini) + " ate " + STRING(fx-vec-fim)        tt-emitente.ve-d:LABEL IN BROWSE {&browse-name} = STRING(fx-ved-ini) + " ate " + STRING(fx-ved-fim)        tt-emitente.ve-e:LABEL IN BROWSE {&browse-name} = STRING(fx-vee-ini) + " ate " + STRING(fx-vee-fim)        tt-emitente.ve-f:LABEL IN BROWSE {&browse-name} = STRING(fx-vef-ini) + " ate " + STRING(fx-vef-fim)        tt-emitente.ve-g:LABEL IN BROWSE {&browse-name} = "acima de " + STRING(fx-veg-ini).  ASSIGN tt-emitente.av-a:LABEL IN BROWSE {&browse-name} = "A venc ate " + STRING(fx-ava-fim)        tt-emitente.av-b:LABEL IN BROWSE {&browse-name} = STRING(fx-avb-ini) + " ate " + STRING(fx-avb-fim)        tt-emitente.av-c:LABEL IN BROWSE {&browse-name} = STRING(fx-avc-ini) + " ate " + STRING(fx-avc-fim)        tt-emitente.av-d:LABEL IN BROWSE {&browse-name} = STRING(fx-avd-ini) + " ate " + STRING(fx-avd-fim)        tt-emitente.av-e:LABEL IN BROWSE {&browse-name} = STRING(fx-ave-ini) + " ate " + STRING(fx-ave-fim)        tt-emitente.av-f:LABEL IN BROWSE {&browse-name} = STRING(fx-avf-ini) + " ate " + STRING(fx-avf-fim)        tt-emitente.av-g:LABEL IN BROWSE {&browse-name} = "acima de " + STRING(fx-avg-ini).  ASSIGN tt-emitente.ve-a:VISIBLE IN BROWSE {&browse-name} = l-ve-a        tt-emitente.ve-b:VISIBLE IN BROWSE {&browse-name} = l-ve-b        tt-emitente.ve-c:VISIBLE IN BROWSE {&browse-name} = l-ve-c        tt-emitente.ve-d:VISIBLE IN BROWSE {&browse-name} = l-ve-d        tt-emitente.ve-e:VISIBLE IN BROWSE {&browse-name} = l-ve-e        tt-emitente.ve-f:VISIBLE IN BROWSE {&browse-name} = l-ve-f        tt-emitente.ve-g:VISIBLE IN BROWSE {&browse-name} = l-ve-g.  ASSIGN tt-emitente.av-a:VISIBLE IN BROWSE {&browse-name} = l-av-a        tt-emitente.av-b:VISIBLE IN BROWSE {&browse-name} = l-av-b        tt-emitente.av-c:VISIBLE IN BROWSE {&browse-name} = l-av-c        tt-emitente.av-d:VISIBLE IN BROWSE {&browse-name} = l-av-d        tt-emitente.av-e:VISIBLE IN BROWSE {&browse-name} = l-av-e        tt-emitente.av-f:VISIBLE IN BROWSE {&browse-name} = l-av-f        tt-emitente.av-g:VISIBLE IN BROWSE {&browse-name} = l-av-g
&Scoped-define OPEN-QUERY-br-planilha OPEN QUERY {&SELF-NAME} FOR EACH tt-emitente USE-INDEX valor2, ~
                                   FIRST emitente OF tt-emitente NO-LOCK.  ASSIGN tt-emitente.ve-a:LABEL IN BROWSE {&browse-name} = "Venc ate " + STRING(fx-vea-fim)        tt-emitente.ve-b:LABEL IN BROWSE {&browse-name} = STRING(fx-veb-ini) + " ate " + STRING(fx-veb-fim)        tt-emitente.ve-c:LABEL IN BROWSE {&browse-name} = STRING(fx-vec-ini) + " ate " + STRING(fx-vec-fim)        tt-emitente.ve-d:LABEL IN BROWSE {&browse-name} = STRING(fx-ved-ini) + " ate " + STRING(fx-ved-fim)        tt-emitente.ve-e:LABEL IN BROWSE {&browse-name} = STRING(fx-vee-ini) + " ate " + STRING(fx-vee-fim)        tt-emitente.ve-f:LABEL IN BROWSE {&browse-name} = STRING(fx-vef-ini) + " ate " + STRING(fx-vef-fim)        tt-emitente.ve-g:LABEL IN BROWSE {&browse-name} = "acima de " + STRING(fx-veg-ini).  ASSIGN tt-emitente.av-a:LABEL IN BROWSE {&browse-name} = "A venc ate " + STRING(fx-ava-fim)        tt-emitente.av-b:LABEL IN BROWSE {&browse-name} = STRING(fx-avb-ini) + " ate " + STRING(fx-avb-fim)        tt-emitente.av-c:LABEL IN BROWSE {&browse-name} = STRING(fx-avc-ini) + " ate " + STRING(fx-avc-fim)        tt-emitente.av-d:LABEL IN BROWSE {&browse-name} = STRING(fx-avd-ini) + " ate " + STRING(fx-avd-fim)        tt-emitente.av-e:LABEL IN BROWSE {&browse-name} = STRING(fx-ave-ini) + " ate " + STRING(fx-ave-fim)        tt-emitente.av-f:LABEL IN BROWSE {&browse-name} = STRING(fx-avf-ini) + " ate " + STRING(fx-avf-fim)        tt-emitente.av-g:LABEL IN BROWSE {&browse-name} = "acima de " + STRING(fx-avg-ini).  ASSIGN tt-emitente.ve-a:VISIBLE IN BROWSE {&browse-name} = l-ve-a        tt-emitente.ve-b:VISIBLE IN BROWSE {&browse-name} = l-ve-b        tt-emitente.ve-c:VISIBLE IN BROWSE {&browse-name} = l-ve-c        tt-emitente.ve-d:VISIBLE IN BROWSE {&browse-name} = l-ve-d        tt-emitente.ve-e:VISIBLE IN BROWSE {&browse-name} = l-ve-e        tt-emitente.ve-f:VISIBLE IN BROWSE {&browse-name} = l-ve-f        tt-emitente.ve-g:VISIBLE IN BROWSE {&browse-name} = l-ve-g.  ASSIGN tt-emitente.av-a:VISIBLE IN BROWSE {&browse-name} = l-av-a        tt-emitente.av-b:VISIBLE IN BROWSE {&browse-name} = l-av-b        tt-emitente.av-c:VISIBLE IN BROWSE {&browse-name} = l-av-c        tt-emitente.av-d:VISIBLE IN BROWSE {&browse-name} = l-av-d        tt-emitente.av-e:VISIBLE IN BROWSE {&browse-name} = l-av-e        tt-emitente.av-f:VISIBLE IN BROWSE {&browse-name} = l-av-f        tt-emitente.av-g:VISIBLE IN BROWSE {&browse-name} = l-av-g.
&Scoped-define TABLES-IN-QUERY-br-planilha tt-emitente emitente
&Scoped-define FIRST-TABLE-IN-QUERY-br-planilha tt-emitente
&Scoped-define SECOND-TABLE-IN-QUERY-br-planilha emitente


/* Definitions for FRAME f-relat                                        */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-relat ~
    ~{&OPEN-QUERY-br-planilha}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-ok br-planilha bt-salva bt-todos ~
bt-nenhum RECT-2 RECT-30 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-nenhum 
     LABEL "Nenhum" 
     SIZE 11.14 BY 1 TOOLTIP "Nenhum e-mail"
     FONT 1.

DEFINE BUTTON bt-ok 
     LABEL "OK" 
     SIZE 11.14 BY 1 TOOLTIP "OK"
     FONT 1.

DEFINE BUTTON bt-salva 
     LABEL "Fechar" 
     SIZE 11.14 BY 1 TOOLTIP "Fechar/Salvar"
     FONT 1.

DEFINE BUTTON bt-todos 
     LABEL "Todos" 
     SIZE 11.14 BY 1 TOOLTIP "Todos os e-mails v†lidos"
     FONT 1.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 120 BY 1.54
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 119.72 BY 14.54.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-planilha FOR 
      tt-emitente, 
      emitente SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-planilha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-planilha C-Win _FREEFORM
  QUERY br-planilha DISPLAY
      tt-emitente.mail       label "Cliente"
tt-emitente.mail-ger   LABEL "Geren"
tt-emitente.mail-rep   label "Repres"
tt-emitente.mail-cont  LABEL "Contato"
emitente.cod-emitente  label "Emitente"
emitente.nome-abrev    label "Nome Abrev"
tt-emitente.ve-a       label "Venc A"
tt-emitente.ve-b       label "Venc B"
tt-emitente.ve-c       label "Venc C"
tt-emitente.ve-d       LABEL "Venc D"
tt-emitente.ve-e       LABEL "Venc E"
tt-emitente.ve-f       LABEL "Venc F"
tt-emitente.ve-g       LABEL "Venc G"
tt-emitente.av-a       LABEL "A Venc A"
tt-emitente.av-b       LABEL "A Venc B"
tt-emitente.av-c       LABEL "A Venc C"
tt-emitente.av-d       LABEL "A Venc D"
tt-emitente.av-e       LABEL "A Venc E"
tt-emitente.av-f       LABEL "A Venc F"
tt-emitente.av-g       LABEL "A Venc G" 
tt-emitente.e-mail      COLUMN-LABEL "E-mail Cliente"  FORMAT "x(100)" WIDTH 30
tt-emitente.e-mail-ger  COLUMN-LABEL "E-mail Gerente"  FORMAT "x(100)" WIDTH 30
tt-emitente.e-mail-rep  COLUMN-LABEL "E-mail Repres"   FORMAT "x(100)" WIDTH 30
tt-emitente.e-mail-cont COLUMN-LABEL "E-mail Contato"  FORMAT "x(100)" WIDTH 30
    ENABLE tt-emitente.mail
           tt-emitente.mail-ger
           tt-emitente.mail-rep
           tt-emitente.mail-cont
           tt-emitente.e-mail  
           tt-emitente.e-mail-ger
           tt-emitente.e-mail-rep
           tt-emitente.e-mail-cont
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 116 BY 13.75
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     bt-ok AT ROW 16.29 COL 2
     br-planilha AT ROW 1.75 COL 3
     bt-salva AT ROW 16.29 COL 13.72
     bt-todos AT ROW 16.25 COL 96
     bt-nenhum AT ROW 16.25 COL 108
     " Seleá∆o" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1 COL 3
          FONT 6
     RECT-2 AT ROW 16 COL 1
     RECT-30 AT ROW 1.21 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 120.43 BY 16.79
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Seleá∆o E-mail - ESACR014B"
         COLUMN             = 39.14
         ROW                = 7.46
         HEIGHT             = 16.79
         WIDTH              = 120.43
         MAX-HEIGHT         = 29.13
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29.13
         VIRTUAL-WIDTH      = 146.29
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 1
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-relat
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-planilha bt-ok f-relat */
ASSIGN 
       br-planilha:COLUMN-RESIZABLE IN FRAME f-relat       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-planilha
/* Query rebuild information for BROWSE br-planilha
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-emitente USE-INDEX valor2,
                            FIRST emitente OF tt-emitente NO-LOCK.

ASSIGN tt-emitente.ve-a:LABEL IN BROWSE {&browse-name} = "Venc ate " + STRING(fx-vea-fim)
       tt-emitente.ve-b:LABEL IN BROWSE {&browse-name} = STRING(fx-veb-ini) + " ate " + STRING(fx-veb-fim)
       tt-emitente.ve-c:LABEL IN BROWSE {&browse-name} = STRING(fx-vec-ini) + " ate " + STRING(fx-vec-fim)
       tt-emitente.ve-d:LABEL IN BROWSE {&browse-name} = STRING(fx-ved-ini) + " ate " + STRING(fx-ved-fim)
       tt-emitente.ve-e:LABEL IN BROWSE {&browse-name} = STRING(fx-vee-ini) + " ate " + STRING(fx-vee-fim)
       tt-emitente.ve-f:LABEL IN BROWSE {&browse-name} = STRING(fx-vef-ini) + " ate " + STRING(fx-vef-fim)
       tt-emitente.ve-g:LABEL IN BROWSE {&browse-name} = "acima de " + STRING(fx-veg-ini).

ASSIGN tt-emitente.av-a:LABEL IN BROWSE {&browse-name} = "A venc ate " + STRING(fx-ava-fim)
       tt-emitente.av-b:LABEL IN BROWSE {&browse-name} = STRING(fx-avb-ini) + " ate " + STRING(fx-avb-fim)
       tt-emitente.av-c:LABEL IN BROWSE {&browse-name} = STRING(fx-avc-ini) + " ate " + STRING(fx-avc-fim)
       tt-emitente.av-d:LABEL IN BROWSE {&browse-name} = STRING(fx-avd-ini) + " ate " + STRING(fx-avd-fim)
       tt-emitente.av-e:LABEL IN BROWSE {&browse-name} = STRING(fx-ave-ini) + " ate " + STRING(fx-ave-fim)
       tt-emitente.av-f:LABEL IN BROWSE {&browse-name} = STRING(fx-avf-ini) + " ate " + STRING(fx-avf-fim)
       tt-emitente.av-g:LABEL IN BROWSE {&browse-name} = "acima de " + STRING(fx-avg-ini).

ASSIGN tt-emitente.ve-a:VISIBLE IN BROWSE {&browse-name} = l-ve-a
       tt-emitente.ve-b:VISIBLE IN BROWSE {&browse-name} = l-ve-b
       tt-emitente.ve-c:VISIBLE IN BROWSE {&browse-name} = l-ve-c
       tt-emitente.ve-d:VISIBLE IN BROWSE {&browse-name} = l-ve-d
       tt-emitente.ve-e:VISIBLE IN BROWSE {&browse-name} = l-ve-e
       tt-emitente.ve-f:VISIBLE IN BROWSE {&browse-name} = l-ve-f
       tt-emitente.ve-g:VISIBLE IN BROWSE {&browse-name} = l-ve-g.

ASSIGN tt-emitente.av-a:VISIBLE IN BROWSE {&browse-name} = l-av-a
       tt-emitente.av-b:VISIBLE IN BROWSE {&browse-name} = l-av-b
       tt-emitente.av-c:VISIBLE IN BROWSE {&browse-name} = l-av-c
       tt-emitente.av-d:VISIBLE IN BROWSE {&browse-name} = l-av-d
       tt-emitente.av-e:VISIBLE IN BROWSE {&browse-name} = l-av-e
       tt-emitente.av-f:VISIBLE IN BROWSE {&browse-name} = l-av-f
       tt-emitente.av-g:VISIBLE IN BROWSE {&browse-name} = l-av-g.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-planilha */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-relat
/* Query rebuild information for FRAME f-relat
     _Query            is NOT OPENED
*/  /* FRAME f-relat */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Seleá∆o E-mail - ESACR014B */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Seleá∆o E-mail - ESACR014B */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-nenhum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nenhum C-Win
ON CHOOSE OF bt-nenhum IN FRAME f-relat /* Nenhum */
DO:
    FOR EACH tt-emitente:
        ASSIGN tt-emitente.mail      = NO
               tt-emitente.mail-ger  = NO
               tt-emitente.mail-rep  = NO
               tt-emitente.mail-cont = NO.
    END.

    {&OPEN-QUERY-{&BROWSE-NAME}}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok C-Win
ON CHOOSE OF bt-ok IN FRAME f-relat /* OK */
DO:
  ASSIGN p-ok = YES.

  APPLY "close" TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-salva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salva C-Win
ON CHOOSE OF bt-salva IN FRAME f-relat /* Fechar */
DO:
    
    ASSIGN p-ok = NO.
    
    APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-todos C-Win
ON CHOOSE OF bt-todos IN FRAME f-relat /* Todos */
DO:
    FOR EACH tt-emitente:
        IF tt-emitente.e-mail <> "" THEN
            ASSIGN tt-emitente.mail = YES.

        IF tt-emitente.e-mail-ger <> "" THEN
            ASSIGN tt-emitente.mail-ger = YES.

        IF tt-emitente.e-mail-rep <> "" THEN
            ASSIGN tt-emitente.mail-rep = YES.

        IF tt-emitente.e-mail-cont <> "" THEN
            ASSIGN tt-emitente.mail-cont = YES.
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-planilha
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

ON 'leave':U OF tt-emitente.mail IN BROWSE {&browse-name}
DO:
    IF  INPUT BROWSE {&browse-name} tt-emitente.mail 
    AND INPUT BROWSE {&browse-name} tt-emitente.e-mail = "" THEN DO:
        MESSAGE "Cliente sem e-mail cadastrado"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        ASSIGN tt-emitente.mail = NO
               tt-emitente.mail:SCREEN-VALUE IN BROWSE {&browse-name} = "Nao".
    END.
END.

ON 'leave':U OF tt-emitente.mail-ger IN BROWSE {&browse-name} 
DO:
    IF  INPUT BROWSE {&browse-name} tt-emitente.mail-ger 
    AND INPUT BROWSE {&browse-name} tt-emitente.e-mail-ger = "" THEN DO:
        MESSAGE "Gerente sem e-mail cadastrado"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.

        ASSIGN tt-emitente.mail-ger = NO
               tt-emitente.mail-ger:SCREEN-VALUE IN BROWSE {&browse-name} = "Nao".
    END.
END.

ON 'leave':U OF tt-emitente.mail-rep IN BROWSE {&browse-name} 
DO:
    IF  INPUT BROWSE {&browse-name} tt-emitente.mail-rep 
    AND INPUT BROWSE {&browse-name} tt-emitente.e-mail-rep = "" THEN DO:
        MESSAGE "Representante sem e-mail cadastrado"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.

        ASSIGN tt-emitente.mail-rep = NO
               tt-emitente.mail-rep:SCREEN-VALUE IN BROWSE {&browse-name} = "Nao".
    END.
END.

ON 'leave':U OF tt-emitente.mail-cont IN BROWSE {&browse-name} 
DO:
    IF  INPUT BROWSE {&browse-name} tt-emitente.mail-cont
    AND INPUT BROWSE {&browse-name} tt-emitente.e-mail-cont = "" THEN DO:
        MESSAGE "Contato sem e-mail cadastrado"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        ASSIGN tt-emitente.mail-cont = NO
               tt-emitente.mail-cont:SCREEN-VALUE IN BROWSE {&browse-name} = "Nao".
    END.
END.

/*DEFINE VARIABLE h-vea AS HANDLE      NO-UNDO.
ASSIGN h-vea = tt-emitente.ve-a:HANDLE IN BROWSE {&browse-name}.

ASSIGN h-vea:LABEL = "Daniel". */

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN enable_UI.

  RUN pi-recupera-parametros.

  {&OPEN-QUERY-{&BROWSE-NAME}}

  IF NOT THIS-PROCEDURE:PERSISTENT THEN 
     WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  ENABLE bt-ok br-planilha bt-salva bt-todos bt-nenhum RECT-2 RECT-30 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recupera-parametros C-Win 
PROCEDURE pi-recupera-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF V_Cod_Dwb_User = "" THEN 
    ASSIGN V_Cod_Dwb_User = V_Cod_Usuar_Corren.

IF V_Num_Ped_Exec_Corren > 0 THEN DO:
    FIND Ped_Exec_Param NO-LOCK
        WHERE Ped_Exec_Param.num_Ped_Exec = V_Num_Ped_Exec_Corren 
        NO-ERROR.
    IF AVAIL Ped_Exec_Param THEN DO:
        FIND Dwb_Set_List_Param NO-LOCK
            WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr014"
              AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
            NO-ERROR.
       ASSIGN l-ve-a            = LOGICAL(ENTRY(19,dwb_set_list_param.cod_dwb_parameters,chr(10)))
              l-ve-b            = LOGICAL(ENTRY(20,dwb_set_list_param.cod_dwb_parameters,chr(10)))
              l-ve-c            = LOGICAL(ENTRY(21,dwb_set_list_param.cod_dwb_parameters,chr(10)))
              l-ve-d            = LOGICAL(ENTRY(22,dwb_set_list_param.cod_dwb_parameters,chr(10)))
              l-ve-e            = LOGICAL(ENTRY(23,dwb_set_list_param.cod_dwb_parameters,chr(10)))
              l-ve-f            = LOGICAL(ENTRY(24,dwb_set_list_param.cod_dwb_parameters,chr(10)))
              l-ve-g            = LOGICAL(ENTRY(38,dwb_set_list_param.cod_dwb_parameters,chr(10)))
              l-av-a            = LOGICAL(ENTRY(25,dwb_set_list_param.cod_dwb_parameters,chr(10)))
              l-av-b            = LOGICAL(ENTRY(26,dwb_set_list_param.cod_dwb_parameters,chr(10)))
              l-av-c            = LOGICAL(ENTRY(27,dwb_set_list_param.cod_dwb_parameters,chr(10)))
              l-av-d            = LOGICAL(ENTRY(28,dwb_set_list_param.cod_dwb_parameters,chr(10)))
              l-av-e            = LOGICAL(ENTRY(39,dwb_set_list_param.cod_dwb_parameters,chr(10)))
              l-av-f            = LOGICAL(ENTRY(40,dwb_set_list_param.cod_dwb_parameters,chr(10)))
              l-av-g            = LOGICAL(ENTRY(41,dwb_set_list_param.cod_dwb_parameters,chr(10)))
             /* l-grupo           = LOGICAL(ENTRY(30,dwb_set_list_param.cod_dwb_parameters,chr(10))) */
              fx-vea-fim        = INT(ENTRY(42,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-veb-ini        = INT(ENTRY(43,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-veb-fim        = INT(ENTRY(44,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-vec-ini        = INT(ENTRY(45,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-vec-fim        = INT(ENTRY(46,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-ved-ini        = INT(ENTRY(47,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-ved-fim        = INT(ENTRY(48,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-vee-ini        = INT(ENTRY(49,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-vee-fim        = INT(ENTRY(50,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-vef-ini        = INT(ENTRY(51,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-vef-fim        = INT(ENTRY(52,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-veg-ini        = INT(ENTRY(53,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-ava-fim        = INT(ENTRY(54,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-avb-ini        = INT(ENTRY(55,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-avb-fim        = INT(ENTRY(56,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-avc-ini        = INT(ENTRY(57,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-avc-fim        = INT(ENTRY(58,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-avd-ini        = INT(ENTRY(59,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-avd-fim        = INT(ENTRY(60,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-ave-ini        = INT(ENTRY(61,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-ave-fim        = INT(ENTRY(62,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-avf-ini        = INT(ENTRY(63,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-avf-fim        = INT(ENTRY(64,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
              fx-avg-ini        = INT(ENTRY(65,dwb_set_list_param.cod_dwb_parameters,CHR(10))).

    END. /* End do IF AVAIL Ped_Exec_Param */
END. /* end do IF V_Num_Ped_Exec_Corren > 0 */
ELSE DO:
    FIND Dwb_Set_List_Param NO-LOCK
        WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr014"
          AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
        NO-ERROR.
    IF AVAIL Dwb_Set_List_Param THEN DO:
        ASSIGN l-ve-a            = LOGICAL(ENTRY(19,dwb_set_list_param.cod_dwb_parameters,chr(10)))
               l-ve-b            = LOGICAL(ENTRY(20,dwb_set_list_param.cod_dwb_parameters,chr(10)))
               l-ve-c            = LOGICAL(ENTRY(21,dwb_set_list_param.cod_dwb_parameters,chr(10)))
               l-ve-d            = LOGICAL(ENTRY(22,dwb_set_list_param.cod_dwb_parameters,chr(10)))
               l-ve-e            = LOGICAL(ENTRY(23,dwb_set_list_param.cod_dwb_parameters,chr(10)))
               l-ve-f            = LOGICAL(ENTRY(24,dwb_set_list_param.cod_dwb_parameters,chr(10)))
               l-ve-g            = LOGICAL(ENTRY(38,dwb_set_list_param.cod_dwb_parameters,chr(10)))
               l-av-a            = LOGICAL(ENTRY(25,dwb_set_list_param.cod_dwb_parameters,chr(10)))
               l-av-b            = LOGICAL(ENTRY(26,dwb_set_list_param.cod_dwb_parameters,chr(10)))
               l-av-c            = LOGICAL(ENTRY(27,dwb_set_list_param.cod_dwb_parameters,chr(10)))
               l-av-d            = LOGICAL(ENTRY(28,dwb_set_list_param.cod_dwb_parameters,chr(10)))
               l-av-e            = LOGICAL(ENTRY(39,dwb_set_list_param.cod_dwb_parameters,chr(10)))
               l-av-f            = LOGICAL(ENTRY(40,dwb_set_list_param.cod_dwb_parameters,chr(10)))
               l-av-g            = LOGICAL(ENTRY(41,dwb_set_list_param.cod_dwb_parameters,chr(10)))
               fx-vea-fim        = INT(ENTRY(42,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-veb-ini        = INT(ENTRY(43,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-veb-fim        = INT(ENTRY(44,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-vec-ini        = INT(ENTRY(45,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-vec-fim        = INT(ENTRY(46,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-ved-ini        = INT(ENTRY(47,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-ved-fim        = INT(ENTRY(48,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-vee-ini        = INT(ENTRY(49,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-vee-fim        = INT(ENTRY(50,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-vef-ini        = INT(ENTRY(51,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-vef-fim        = INT(ENTRY(52,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-veg-ini        = INT(ENTRY(53,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-ava-fim        = INT(ENTRY(54,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-avb-ini        = INT(ENTRY(55,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-avb-fim        = INT(ENTRY(56,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-avc-ini        = INT(ENTRY(57,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-avc-fim        = INT(ENTRY(58,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-avd-ini        = INT(ENTRY(59,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-avd-fim        = INT(ENTRY(60,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-ave-ini        = INT(ENTRY(61,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-ave-fim        = INT(ENTRY(62,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-avf-ini        = INT(ENTRY(63,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-avf-fim        = INT(ENTRY(64,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
               fx-avg-ini        = INT(ENTRY(65,dwb_set_list_param.cod_dwb_parameters,CHR(10))).

    END. /* End do IF AVAIL Ped_Exec_Param */
END. /* End do ELSE Do - IF V_Num_Ped_Exec_Corren > 0 */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-usuario C-Win 
PROCEDURE pi-vld-usuario :
/* */
FIND prog_dtsul NO-LOCK
    WHERE prog_dtsul.cod_prog_dtsul = "esacr014a" NO-ERROR.

IF AVAIL prog_dtsul THEN 
DO:
  FOR EACH usuar_grp_usuar NO-LOCK
      WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
    IF NOT CAN-FIND(FIRST prog_dtsul_segur NO-LOCK
                    WHERE  prog_dtsul_segur.cod_prog_dtsul = "esacr014a"
                      AND (prog_dtsul_segur.cod_grp_usuar  = usuar_grp_usuar.cod_grp_usuar
                       OR  prog_dtsul_segur.cod_grp_usuar  = "*")) THEN 
    DO:
      MESSAGE "Usu†rio n∆o tem Permiss∆o" SKIP
              "Verifique com o Administrador as permiss‰es para acessar este programa!" VIEW-AS ALERT-BOX ERROR.
      RETURN 'nok'.
    END.
  END.
END.
ELSE 
DO:
  MESSAGE "Programa n∆o Cadastrado no Menu!" VIEW-AS ALERT-BOX ERROR.
  RETURN 'nok'.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_message C-Win 
PROCEDURE pi_message :
/* */
def input param c_action    as char    no-undo.
def input param i_msg       as integer no-undo.
def input param c_param     as char    no-undo.

def var c_prg_msg           as char    no-undo.

assign c_prg_msg = "messages/"
                 + string(trunc(i_msg / 1000,0),"99")
                 + "/msg"
                 + string(i_msg, "99999").

if search(c_prg_msg + ".r") = ? and search(c_prg_msg + ".p") = ? then 
do:
  message "Mensagem nr. " i_msg "!!!" skip
          "Programa Mensagem" c_prg_msg "n∆o encontrado."
          view-as alert-box error.
  return error.
end.
run value(c_prg_msg + ".p") (input c_action, input c_param).
return return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

