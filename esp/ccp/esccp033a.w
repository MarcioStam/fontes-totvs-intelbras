&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-window 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCCP033A 2.00.01.005}  /*** 010105 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esccp033a MCC}
&ENDIF

{cdp/cdcfgman.i}

/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var l-usa-unid-negoc as logical initial no no-undo.

&IF defined(bf_man_206b) &THEN
    if(can-find(funcao where funcao.cd-funcao = "ems2-unidade-negocio" and
                funcao.ativo     = yes)) then do:
        assign l-usa-unid-negoc = yes.
    end.
&ENDIF


&IF DEFINED(bf_man_206b) &THEN        
    DEF VAR h-cdapi024    AS HANDLE NO-UNDO.
&ENDIF

def temp-table tt-depositos
    field cod-estabel like estabelec.cod-estabel column-label "Cod Estabel"
    field cod-depos   like deposito.cod-depos    column-label "Cod Deposito".

def new global shared var l-ord-comp-esccp033   as logical   no-undo.
def new global shared var l-ord-prod-esccp033   as logical   no-undo.
def new global shared var l-planejada-esccp033  as logical   no-undo.
def new global shared var l-res-comp-esccp033   as logical   no-undo.
def new global shared var l-res-plan-esccp033   as logical   no-undo.
def new global shared var l-sald-est-esccp033   as logical   no-undo.
def new global shared var l-sald-terc-esccp033  as logical   no-undo.
def new global shared var l-pedidos-esccp033    as logical   no-undo.
def new global shared var l-cred-aprov-esccp033 as logical   no-undo.
def new global shared var l-depositos-esccp033  as logical   no-undo.


def new global shared var l-remessa-esccp033     as logical   init yes no-undo.
def new global shared var l-entrada-esccp033     as logical   init yes no-undo.
def new global shared var l-transfer-esccp033    as logical   init yes no-undo.
def new global shared var l-remessa-con-esccp033 as logical   init yes no-undo.
def new global shared var l-ent-con-esccp033     as logical   init yes no-undo.


def new global shared var i-benefic-esccp033    as integer   no-undo.
def new global shared var c-estab-ini-esccp033  as character no-undo.
def new global shared var c-estab-fim-esccp033  as character no-undo.
&IF defined(bf_man_206b) &THEN
    def new global shared var c-unid-negoc-ini-esccp033  as character no-undo.
    def new global shared var c-unid-negoc-fim-esccp033  as character no-undo.
&ENDIF
def new global shared var da-dt-corte-esccp033  as date      no-undo.
def new global shared var da-dt-plan-esccp033   as date      no-undo.
def new global shared var i-cod-plano-esccp033  like pl-prod.cd-plano no-undo.

DEF NEW GLOBAL SHARED VAR l-apenas-oem-intelbras-esccp033 AS LOGICAL NO-UNDO.

def input-output parameter table for tt-depositos.

def var li-bt-benefic as char extent 3 no-undo.
def var l-cancelar as logical no-undo.
def var l-erro as logical no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES pl-prod

/* Definitions for FRAME F-Main                                         */
&Scoped-define QUERY-STRING-F-Main FOR EACH pl-prod NO-LOCK
&Scoped-define OPEN-QUERY-F-Main OPEN QUERY F-Main FOR EACH pl-prod NO-LOCK.
&Scoped-define TABLES-IN-QUERY-F-Main pl-prod
&Scoped-define FIRST-TABLE-IN-QUERY-F-Main pl-prod


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-41 RECT-40 RECT-38 RECT-1 RECT-2 ~
RECT-39 rt-buttom RECT-42 tb-ord-comp l-remessa-esccp0332 tb-ord-prod ~
tb-planejada l-entrada-esccp0332 tb-res-comp l-transfer-esccp0332 ~
tb-res-plan l-re-con2 tb-sald-est l-en-con2 tb-sald-terc tb-pedidos ~
tb-cred-aprov i-cd-plano tb-depositos rs-benefic fi-estab-ini fi-estab-fim ~
fi-dt-corte fi-dt-plan tg-apenas-oem bt-ok bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS tb-ord-comp l-remessa-esccp0332 ~
tb-ord-prod tb-planejada l-entrada-esccp0332 tb-res-comp ~
l-transfer-esccp0332 tb-res-plan l-re-con2 tb-sald-est l-en-con2 ~
tb-sald-terc tb-pedidos tb-cred-aprov i-cd-plano tb-depositos rs-benefic ~
fi-estab-ini fi-estab-fim fi-dt-corte fi-dt-plan tg-apenas-oem ~
txt-saldo-terc fi-titulo fi-titulo-1 fi-titulo-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-window AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE fi-dt-corte AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-plan AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab-ini LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-titulo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 35 BY .63 NO-UNDO.

DEFINE VARIABLE fi-titulo-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 13 BY .63 NO-UNDO.

DEFINE VARIABLE fi-titulo-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16.57 BY .63 NO-UNDO.

DEFINE VARIABLE fi-unid-negoc-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unid-negoc-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE i-cd-plano AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Plano":R7 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE txt-saldo-terc AS CHARACTER FORMAT "X(256)":U INITIAL "Considera Saldos em Terceiros" 
      VIEW-AS TEXT 
     SIZE 30 BY .67 NO-UNDO.

DEFINE VARIABLE rs-benefic AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "", 1,
"", 2,
"", 3
     SIZE 26 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 3.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20.57 BY 3.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 21.43 BY 3.5.

DEFINE RECTANGLE RECT-38
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32.57 BY 6.21.

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81.86 BY 2.5.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48.43 BY 8.38.

DEFINE RECTANGLE RECT-41
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32.57 BY 2.04.

DEFINE RECTANGLE RECT-42
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81.86 BY 1.25.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 81.86 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE l-en-con2 AS LOGICAL INITIAL no 
     LABEL "Entrada em Consigna‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 29.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-entrada-esccp0332 AS LOGICAL INITIAL yes 
     LABEL "Entrada p/ Beneficiamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83 NO-UNDO.

DEFINE VARIABLE l-re-con2 AS LOGICAL INITIAL no 
     LABEL "Remessa em Consigna‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.

DEFINE VARIABLE l-remessa-esccp0332 AS LOGICAL INITIAL yes 
     LABEL "Remessa p/ Beneficiamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.43 BY .83 NO-UNDO.

DEFINE VARIABLE l-transfer-esccp0332 AS LOGICAL INITIAL yes 
     LABEL "Transferˆncia" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.43 BY .83 NO-UNDO.

DEFINE VARIABLE tb-cred-aprov AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 44.72 BY .75 NO-UNDO.

DEFINE VARIABLE tb-depositos AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 45.29 BY .75 NO-UNDO.

DEFINE VARIABLE tb-ord-comp AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 44.43 BY .75 NO-UNDO.

DEFINE VARIABLE tb-ord-prod AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 44.29 BY .75 NO-UNDO.

DEFINE VARIABLE tb-pedidos AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 44.43 BY .75 NO-UNDO.

DEFINE VARIABLE tb-planejada AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 44.43 BY .75 NO-UNDO.

DEFINE VARIABLE tb-res-comp AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 44.29 BY .75 NO-UNDO.

DEFINE VARIABLE tb-res-plan AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 44.57 BY .63 NO-UNDO.

DEFINE VARIABLE tb-sald-est AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY .75 NO-UNDO.

DEFINE VARIABLE tb-sald-terc AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 44.14 BY .75 NO-UNDO.

DEFINE VARIABLE tg-apenas-oem AS LOGICAL INITIAL no 
     LABEL "Somente Pedidos OEM" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY F-Main FOR 
      pl-prod SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     tb-ord-comp AT ROW 1.38 COL 3.57
     l-remessa-esccp0332 AT ROW 2.08 COL 51.43
     tb-ord-prod AT ROW 2.13 COL 3.57
     tb-planejada AT ROW 3 COL 3.57
     l-entrada-esccp0332 AT ROW 3.04 COL 51.43
     tb-res-comp AT ROW 3.83 COL 3.57
     l-transfer-esccp0332 AT ROW 4 COL 51.43
     tb-res-plan AT ROW 4.75 COL 3.57
     l-re-con2 AT ROW 4.88 COL 51.43
     tb-sald-est AT ROW 5.42 COL 3.57
     l-en-con2 AT ROW 5.83 COL 51.43
     tb-sald-terc AT ROW 6.25 COL 3.57
     tb-pedidos AT ROW 7.04 COL 3.57
     tb-cred-aprov AT ROW 7.88 COL 3.57
     i-cd-plano AT ROW 8.13 COL 60.72 COLON-ALIGNED
     tb-depositos AT ROW 8.58 COL 3.57
     rs-benefic AT ROW 10.5 COL 9.57 NO-LABEL
     fi-estab-ini AT ROW 11.13 COL 47 COLON-ALIGNED HELP
          ""
     fi-unid-negoc-ini AT ROW 11.13 COL 69.43 COLON-ALIGNED
     fi-estab-fim AT ROW 12.13 COL 47 COLON-ALIGNED HELP
          ""
     fi-unid-negoc-fim AT ROW 12.13 COL 69.43 COLON-ALIGNED
     fi-dt-corte AT ROW 14 COL 36.72 COLON-ALIGNED
     fi-dt-plan AT ROW 15 COL 36.72 COLON-ALIGNED
     tg-apenas-oem AT ROW 16.5 COL 28.72 WIDGET-ID 6
     bt-ok AT ROW 18 COL 2
     bt-cancela AT ROW 18 COL 13
     bt-ajuda AT ROW 18 COL 71.57
     txt-saldo-terc AT ROW 1 COL 50 COLON-ALIGNED NO-LABEL
     fi-titulo AT ROW 9.88 COL 1 COLON-ALIGNED NO-LABEL
     fi-titulo-1 AT ROW 9.88 COL 39 COLON-ALIGNED NO-LABEL
     fi-titulo-2 AT ROW 9.88 COL 60.43 COLON-ALIGNED NO-LABEL
     RECT-41 AT ROW 7.58 COL 50.29
     RECT-40 AT ROW 1.25 COL 1
     RECT-38 AT ROW 1.25 COL 50.29
     RECT-1 AT ROW 10.17 COL 1
     RECT-2 AT ROW 10.17 COL 40
     RECT-39 AT ROW 13.75 COL 1
     rt-buttom AT ROW 17.75 COL 1
     RECT-3 AT ROW 10.17 COL 61.43
     RECT-42 AT ROW 16.33 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 82.29 BY 19.71.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "Parƒmetros da Simula‡Æo de Estoque"
         HEIGHT             = 18.33
         WIDTH              = 82.43
         MAX-HEIGHT         = 29.04
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 29.04
         VIRTUAL-WIDTH      = 195.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-window 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-window.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-estab-fim IN FRAME F-Main
   LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                          */
/* SETTINGS FOR FILL-IN fi-estab-ini IN FRAME F-Main
   LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                          */
/* SETTINGS FOR FILL-IN fi-titulo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-titulo-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-titulo-2 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       fi-titulo-2:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN fi-unid-negoc-fim IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fi-unid-negoc-fim:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN fi-unid-negoc-ini IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fi-unid-negoc-ini:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR RECTANGLE RECT-3 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       RECT-3:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN txt-saldo-terc IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       txt-saldo-terc:PRIVATE-DATA IN FRAME F-Main     = 
                "Obsoleto".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _TblList          = "pl-prod"
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* Parƒmetros da Simula‡Æo de Estoque */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* Parƒmetros da Simula‡Æo de Estoque */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-window
ON CHOOSE OF bt-ajuda IN FRAME F-Main /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-window
ON CHOOSE OF bt-cancela IN FRAME F-Main /* Cancelar */
DO:
  apply 'close' to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME F-Main /* OK */
DO:
  assign l-erro = no.
  
  do with frame {&frame-name}:
     assign l-ord-comp-esccp033    = tb-ord-comp:checked
            l-ord-prod-esccp033    = tb-ord-prod:checked
            l-planejada-esccp033   = tb-planejada:checked
            l-res-comp-esccp033    = tb-res-comp:checked
            l-res-plan-esccp033    = tb-res-plan:checked
            l-sald-est-esccp033    = tb-sald-est:checked
            l-sald-terc-esccp033   = tb-sald-terc:checked
            l-pedidos-esccp033     = tb-pedidos:checked
            l-cred-aprov-esccp033  = tb-cred-aprov:checked
            i-benefic-esccp033     = input rs-benefic
            da-dt-corte-esccp033   = input fi-dt-corte
            da-dt-plan-esccp033    = input fi-dt-plan
            l-depositos-esccp033   = tb-depositos:checked
            c-estab-ini-esccp033   = input fi-estab-ini
            c-estab-fim-esccp033   = input fi-estab-fim
            l-remessa-esccp033     = l-remessa-esccp0332:checked
            l-entrada-esccp033     = l-entrada-esccp0332:checked
            l-transfer-esccp033    = l-transfer-esccp0332:checked
            l-remessa-con-esccp033 = l-re-con2:checked
            l-ent-con-esccp033     = l-en-con2:checked
            i-cod-plano-esccp033   = input i-cd-plano
            l-apenas-oem-intelbras-esccp033 = tg-apenas-oem:CHECKED    
         .

     &IF defined(bf_man_206b) &THEN
        assign c-unid-negoc-ini-esccp033 = fi-unid-negoc-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               c-unid-negoc-fim-esccp033 = fi-unid-negoc-fim:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
     &ENDIF
  end.
  assign l-cancelar = no.

  if l-depositos-esccp033 then 
     run cdp/cd0284b1.w (input-output table tt-depositos,
                         output       l-cancelar).
  else
     for each tt-depositos NO-LOCK:
         delete tt-depositos.
     end.
      
  if l-planejada-esccp033 or l-res-plan-esccp033 then do:
     find first pl-prod where pl-prod.cd-plano = input frame {&frame-name} i-cd-plano 
          no-lock no-error.

     if not avail pl-prod or 
        (avail pl-prod and pl-prod.pl-estado = 2) then do:
        run utp/ut-msgs.p (input "show":U, 
                           input 19591, 
                           input return-value).
        apply 'mouse-select-click':U to i-cd-plano in frame {&frame-name}.
        apply 'entry':U to i-cd-plano in frame {&frame-name}.
        assign l-erro = yes.
     end.
  end.
  
  if not l-erro then
     if l-cancelar then 
        for each tt-depositos NO-LOCK:
            delete tt-depositos.
        end.
     else                                             
        apply 'close':U to this-procedure.   
  else
     return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-estab-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estab-fim w-window
ON F5 OF fi-estab-fim IN FRAME F-Main /* Estab */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=fi-estab-fim
                     &campozoom=cod-estabel}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estab-fim w-window
ON MOUSE-SELECT-DBLCLICK OF fi-estab-fim IN FRAME F-Main /* Estab */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-estab-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estab-ini w-window
ON F5 OF fi-estab-ini IN FRAME F-Main /* Estab */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=fi-estab-ini
                     &campozoom=cod-estabel}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estab-ini w-window
ON MOUSE-SELECT-DBLCLICK OF fi-estab-ini IN FRAME F-Main /* Estab */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cd-plano
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-plano w-window
ON MOUSE-SELECT-DBLCLICK OF i-cd-plano IN FRAME F-Main /* Plano */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-planejada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-planejada w-window
ON VALUE-CHANGED OF tb-planejada IN FRAME F-Main
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-res-plan w-window
ON VALUE-CHANGED OF tb-res-plan IN FRAME F-Main
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-sald-terc w-window
ON VALUE-CHANGED OF tb-sald-terc IN FRAME F-Main
DO:
  assign l-remessa-esccp0332:sensitive  in frame {&frame-name} = tb-sald-terc:checked in frame {&frame-name}
         l-remessa-esccp0332:checked    in frame {&frame-name} = tb-sald-terc:checked in frame {&frame-name}
         l-entrada-esccp0332:sensitive  in frame {&frame-name} = tb-sald-terc:checked in frame {&frame-name}
         l-entrada-esccp0332:checked    in frame {&frame-name} = tb-sald-terc:checked in frame {&frame-name}
         l-transfer-esccp0332:sensitive in frame {&frame-name} = tb-sald-terc:checked in frame {&frame-name}
         l-transfer-esccp0332:checked   in frame {&frame-name} = tb-sald-terc:checked in frame {&frame-name}
         l-re-con2:sensitive   in frame {&frame-name} = tb-sald-terc:checked in frame {&frame-name}
         l-re-con2:checked     in frame {&frame-name} = tb-sald-terc:checked in frame {&frame-name}
         l-en-con2:sensitive   in frame {&frame-name} = tb-sald-terc:checked in frame {&frame-name}
         l-en-con2:checked     in frame {&frame-name} = tb-sald-terc:checked in frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-window 


/* ***************************  Main Block  *************************** */

do with frame {&frame-name}:
     {utp/ut-liter.i Considera_Ordens_de_Compra? MCD r}
     assign tb-ord-comp:label = return-value.
     
     {utp/ut-liter.i Considera_Ordens_de_Produ‡Æo? MCD r}
     assign tb-ord-prod:label = return-value.
     
     {utp/ut-liter.i Considera_Ordens_Planejadas? MCD r}
     assign tb-planejada:label = return-value.
     
     {utp/ut-liter.i Considera_Reservas_Comprometidas? MCD r}
     assign tb-res-comp:label = return-value.
     
     {utp/ut-liter.i Considera_Reservas_Planejadas? MCD r}
     assign tb-res-plan:label = return-value.
     
     {utp/ut-liter.i Considera_Saldo_em_Estoque? MCD r}
     assign tb-sald-est:label = return-value.
     
     {utp/ut-liter.i Considera_Saldo_em_Poder_de_Terceiros? MCD r}
     assign tb-sald-terc:label = return-value.
            
     
     {utp/ut-liter.i Considera_Pedidos_em_Carteira? MCD r}
     assign tb-pedidos:label = return-value.
     
     {utp/ut-liter.i Apenas_Pedidos_com_Cr‚dito_Aprovado? MCD r}
     assign tb-cred-aprov:label = return-value.
     
     {utp/ut-liter.i Ordens_de_Compra_de_Beneficiamento MCD r}
     assign fi-titulo = return-value.
     
     {utp/ut-liter.i Estabelec MCD r}
     assign fi-titulo-1 = return-value.
     
     {utp/ut-liter.i Data_de_Corte MCD l}
     assign fi-dt-corte:label = trim (return-value).
     
     {utp/ut-liter.i Data_de_Corte_para_Ordens_Planejadas MCD l}
     assign fi-dt-plan:label = trim (return-value).
     
     {utp/ut-liter.i Informa_Depositos? MCD r}
     assign tb-depositos:label = return-value.
     
     {utp/ut-liter.i Inicial * l}
     assign fi-estab-ini:label = return-value.
     
     {utp/ut-liter.i Final * l}
     assign fi-estab-fim:label = return-value.

     &IF defined(bf_man_206b) &THEN
        if l-usa-unid-negoc then do:
            {utp/ut-field.i mgind unid-negoc cod-unid-negoc 1}
            assign fi-titulo-2 = trim(return-value).
            
            {utp/ut-liter.i Inicial * l}
            assign fi-unid-negoc-ini:label = return-value.
        
            {utp/ut-liter.i Final * l}
            assign fi-unid-negoc-fim:label = return-value.
        end.
     &ENDIF
     
     {utp/ut-liter.i Considera MCD r}
     assign li-bt-benefic[1] = return-value.
     
     {utp/ut-liter.i NÆo_Considera MCD r}
     assign li-bt-benefic[2] = return-value.
     
     {utp/ut-liter.i Demonstra MCD r}
     assign li-bt-benefic[3] = return-value.
     
     {utp/ut-liter.i Remessa_em_Consigna‡Æo MCD r}
     assign l-re-con2:label = return-value.

     {utp/ut-liter.i Remessa_p/_Beneficiamento MCD r}
     assign l-remessa-esccp0332:label = return-value.
     
     {utp/ut-liter.i Entrada_p/_Beneficiamento MCD r}
     assign l-entrada-esccp0332:label = return-value.
     
     {utp/ut-liter.i Transferˆncia MCD r}
     assign l-transfer-esccp0332:label = return-value.
     
     {utp/ut-liter.i Entrada_em_Consigna‡Æo MCD r}
     assign l-en-con2:label = return-value.
     
     {utp/ut-liter.i Saldo_em_Poder_de_Terceiros MCD r}
     assign txt-saldo-terc = return-value.
     
     assign rs-benefic:radio-buttons = li-bt-benefic[1] + ", 1," +
                                       li-bt-benefic[2] + ", 2," +
                                       li-bt-benefic[3] + ", 3".
                                       
     if fi-estab-ini:load-mouse-pointer ("image/lupa.cur") then.
     if fi-estab-fim:load-mouse-pointer ("image/lupa.cur") then.
     
  end.
  
  assign tb-ord-comp   = l-ord-comp-esccp033
         tb-ord-prod   = l-ord-prod-esccp033
         tb-planejada  = l-planejada-esccp033
         tb-res-comp   = l-res-comp-esccp033
         tb-res-plan   = l-res-plan-esccp033
         tb-sald-est   = l-sald-est-esccp033
         tb-sald-terc  = l-sald-terc-esccp033
         tb-pedidos    = l-pedidos-esccp033
         tb-cred-aprov = l-cred-aprov-esccp033
         rs-benefic    = i-benefic-esccp033
         fi-dt-corte   = da-dt-corte-esccp033
         fi-dt-plan    = da-dt-plan-esccp033
         tb-depositos  = l-depositos-esccp033
         fi-estab-ini  = c-estab-ini-esccp033
         fi-estab-fim  = c-estab-fim-esccp033
         l-remessa-esccp0332    = l-remessa-esccp033
         l-entrada-esccp0332    = l-entrada-esccp033
         l-transfer-esccp0332   = l-transfer-esccp033
         l-re-con2     = l-remessa-con-esccp033
         l-en-con2     = l-ent-con-esccp033
         tg-apenas-oem = l-apenas-oem-intelbras-esccp033.

  &IF defined(bf_man_206b) &THEN
        if l-usa-unid-negoc then do:
            
            assign fi-unid-negoc-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-unid-negoc-ini-esccp033
                   fi-unid-negoc-fim:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-unid-negoc-fim-esccp033.
        end.
  &ENDIF
  
  if not l-planejada-esccp033 or not l-res-plan-esccp033 then 
     assign i-cd-plano:sensitive in frame {&frame-name} = no.

  &IF defined(bf_man_206b) &THEN
        if l-usa-unid-negoc then do:
        
            RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.

            assign fi-titulo-2:hidden       in frame {&frame-name} = false
                   fi-unid-negoc-ini:hidden in frame {&frame-name} = false
                   fi-unid-negoc-fim:hidden in frame {&frame-name} = false
                   RECT-3:hidden            in frame {&frame-name} = false.

        end.
  &ENDIF
 /* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-window  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-window  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-window  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
  THEN DELETE WIDGET w-window.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-window  _DEFAULT-ENABLE
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

  {&OPEN-QUERY-F-Main}
  GET FIRST F-Main.
  DISPLAY tb-ord-comp l-remessa-esccp0332 tb-ord-prod tb-planejada 
          l-entrada-esccp0332 tb-res-comp l-transfer-esccp0332 tb-res-plan 
          l-re-con2 tb-sald-est l-en-con2 tb-sald-terc tb-pedidos tb-cred-aprov 
          i-cd-plano tb-depositos rs-benefic fi-estab-ini fi-estab-fim 
          fi-dt-corte fi-dt-plan tg-apenas-oem txt-saldo-terc fi-titulo 
          fi-titulo-1 fi-titulo-2 
      WITH FRAME F-Main IN WINDOW w-window.
  ENABLE RECT-41 RECT-40 RECT-38 RECT-1 RECT-2 RECT-39 rt-buttom RECT-42 
         tb-ord-comp l-remessa-esccp0332 tb-ord-prod tb-planejada 
         l-entrada-esccp0332 tb-res-comp l-transfer-esccp0332 tb-res-plan 
         l-re-con2 tb-sald-est l-en-con2 tb-sald-terc tb-pedidos tb-cred-aprov 
         i-cd-plano tb-depositos rs-benefic fi-estab-ini fi-estab-fim 
         fi-dt-corte fi-dt-plan tg-apenas-oem bt-ok bt-cancela bt-ajuda 
      WITH FRAME F-Main IN WINDOW w-window.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW w-window.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-window 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  &IF DEFINED(bf_man_206b) &THEN    
    IF VALID-HANDLE(h-cdapi024) THEN DO:
                run pi-finalizar in h-cdapi024.
                ASSIGN h-cdapi024 = ?.
            END.
  &ENDIF

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-window 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}
  run pi-before-initialize.
       
  /* Dispatch standard ADM method.                             */
{utp/ut9000.i "ESCCP033A" "2.00.01.005"}
  
  assign tb-ord-comp   = l-ord-comp-esccp033
         tb-ord-prod   = l-ord-prod-esccp033  
         tb-planejada  = l-planejada-esccp033  
         tb-res-comp   = l-res-comp-esccp033   
         tb-res-plan   = l-res-plan-esccp033
         tb-sald-est   = l-sald-est-esccp033   
         tb-sald-terc  = l-sald-terc-esccp033
         tb-pedidos    = l-pedidos-esccp033     
         tb-cred-aprov = l-cred-aprov-esccp033
         tb-depositos  = l-depositos-esccp033
         l-remessa-esccp0332    = l-remessa-esccp033
         l-entrada-esccp0332    = l-entrada-esccp033
         l-transfer-esccp0332   = l-transfer-esccp033
         l-re-con2     = l-remessa-con-esccp033
         l-en-con2     = l-ent-con-esccp033
         rs-benefic    = i-benefic-esccp033
         c-estab-ini-esccp033   = c-estab-ini-esccp033
         c-estab-fim-esccp033   = c-estab-fim-esccp033
         fi-dt-corte   = da-dt-corte-esccp033
         fi-dt-plan    = da-dt-plan-esccp033
         i-cd-plano    = i-cod-plano-esccp033
         tg-apenas-oem = l-apenas-oem-intelbras-esccp033.

  &IF defined(bf_man_206b) &THEN
        if l-usa-unid-negoc then do:
            assign fi-unid-negoc-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-unid-negoc-ini-esccp033
                   fi-unid-negoc-fim:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF c-unid-negoc-fim-esccp033 <> "" THEN c-unid-negoc-fim-esccp033 ELSE "ZZZ".
        end.
  &ENDIF
         
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  if l-sald-terc-esccp033 = no then
  assign l-remessa-esccp0332:sensitive  in frame {&frame-name} = no
         l-remessa-esccp0332:checked    in frame {&frame-name} = no
         l-entrada-esccp0332:sensitive  in frame {&frame-name} = no
         l-entrada-esccp0332:checked    in frame {&frame-name} = no
         l-transfer-esccp0332:sensitive in frame {&frame-name} = no
         l-transfer-esccp0332:checked   in frame {&frame-name} = no
         l-re-con2:sensitive   in frame {&frame-name} = no
         l-re-con2:checked     in frame {&frame-name} = no
         l-en-con2:sensitive   in frame {&frame-name} = no
         l-en-con2:checked     in frame {&frame-name} = no.

  if not l-planejada-esccp033 and not l-res-plan-esccp033 then 
     assign i-cd-plano:sensitive in frame {&frame-name} = no.
  else 
     assign i-cd-plano:sensitive in frame {&frame-name} = yes.
     
  &IF DEFINED(bf_man_206b) &THEN
      if l-usa-unid-negoc then do:
          assign fi-titulo-2:sensitive           in frame {&frame-name} = YES
                 fi-unid-negoc-ini:sensitive     in frame {&frame-name} = yes
                 fi-unid-negoc-fim:sensitive     in frame {&frame-name} = yes.
      end.
  &ENDIF
  
  APPLY "value-changed" TO tb-sald-terc.

  /* Code placed here will execute AFTER standard behavior.    */
  
  run pi-after-initialize.
  END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-window  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "pl-prod"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-window 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

