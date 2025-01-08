&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/*:T *******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*
{include/i-prgvrs.i XX9999 9.99.99.999}
  */
/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
/* Parameters Definitions ---                                           */
/* Local Variable Definitions ---                                       */
DEF VAR hproc AS HANDLE.
DEF VAR h-prog AS HANDLE.
def var i-cont      as int.
def var c-label     as char extent 120.
def var c-linha     as char.
def var i-comp      as int.
DEF VAR l-ok        AS LOG EXTENT 12.
DEF VAR i-mes       AS INT EXTENT 12.
DEF VAR i-ano       AS INT EXTENT 12.
DEF VAR c-mes-ant   AS CHAR.
DEF VAR c-ano-ant   AS CHAR.
DEF VAR de-cotacao  AS DEC FORMAT ">>>9.999999".
DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.
DEF VAR c-usuario AS CHAR NO-UNDO.
DEF VAR i-ano-x AS INT.
DEF VAR c-cc-codigo AS CHAR.
DEF VAR c-segur AS CHAR.
DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.
DEF VAR l-teste AS LOGICAL NO-UNDO.
DEF VAR c-connect LIKE servid_rpc.des_carg_rpc NO-UNDO.

def var v_log_method
    as logical
    format "Sim/NÆo"
    initial yes
    no-undo.

DEF TEMP-TABLE tt-usu
    FIELD cc AS CHAR 
    INDEX cc IS PRIMARY cc.

{esp/es0018.i}

def temp-table tt-display
    FIELD acao          AS CHAR FORMAT "x(3)" LABEL ""
    FIELD ind_espec_cta_ctbl  AS CHAR LABEL ""
    FIELD cod_cta_ctbl  AS CHAR FORMAT "x(8)" LABEL "Conta"
    FIELD descricao     AS CHAR FORMAT "x(1000)"
    FIELD tot-mes       AS DEC FORMAT "->>>,>>>,>>9" EXTENT 12 LABEL ""
    FIELD real-mes      AS DEC FORMAT "->>>,>>>,>>9" EXTENT 12 LABEL ""
    FIELD var-mes       AS DEC FORMAT "->>9.9"       EXTENT 12 LABEL ""
    FIELD tot-acum      AS DEC FORMAT "->>>,>>>,>>9" LABEL "Or‡ado Acum"
    FIELD real-acum     AS DEC FORMAT "->>>,>>>,>>9" LABEL "Real Acum"
    FIELD var-acum      AS DEC FORMAT "->>>9.9"           LABEL "% Acum"
    INDEX codigo is PRIMARY cod_cta_ctbl.



/* teste */
DEF TEMP-TABLE tt-dados-consulta
    FIELD cod_estab                     AS CHAR FORMAT "x(3)"
    FIELD origem                        AS CHAR FORMAT "x(3)"
    FIELD ind_natur_lancto_ctbl         AS CHAR FORMAT "X(3)"
    FIELD cod_emitente                  AS INT FORMAT ">>>,>>>,>>9"
    FIELD nome_emitente                 AS CHAR FORMAT "X(40)"
    FIELD dt_transacao                  AS DATE FORMAT "99/99/9999"
    FIELD cod_espec_docto               AS CHAR FORMAT "x(3)"
    FIELD cod_ser_docto                 AS CHAR FORMAT "x(3)"
    FIELD cod_tit_ap                    AS CHAR FORMAT "x(10)"
    FIELD cod_parcela                   AS CHAR FORMAT "x(2)"
    FIELD val_aprop_ctbl                AS DEC FORMAT ">>>,>>>,>>9.99".

DEF TEMP-TABLE tt-dados-consulta-aux
    FIELD origem                        AS CHAR FORMAT "x(3)"
    FIELD ind_natur_lancto_ctbl         AS CHAR FORMAT "X(3)"
    FIELD cod_emitente                  AS INT FORMAT ">>>,>>>,>>9"
    FIELD nome_emitente                 AS CHAR FORMAT "X(40)"
    FIELD dt_transacao                  AS DATE FORMAT "99/99/9999"
    FIELD cod_espec_docto               AS CHAR FORMAT "x(3)"
    FIELD cod_ser_docto                 AS CHAR FORMAT "x(3)"
    FIELD cod_tit_ap                    AS CHAR FORMAT "x(10)"
    FIELD cod_parcela                   AS CHAR FORMAT "x(2)"
    FIELD val_aprop_ctbl                AS DEC FORMAT ">>>,>>>,>>9.99".



  
DEF BUFFER btt-display FOR tt-display.


DEF TEMP-TABLE tt-uni
    FIELD unidade AS CHAR
    FIELD divisao AS CHAR
    FIELD cod_ccusto AS CHAR 
    INDEX codigo IS PRIMARY unidade divisao cod_ccusto.

    {utp\utapi001.i}
  
    
    {esp\cep\escep014.i}


DEF TEMP-TABLE tt-conta
    FIELD cod_cta_ctbl AS CHAR
    FIELD mes AS INT
    FIELD ano AS INT
    FIELD valor-orcado AS DEC
    FIELD valor-real AS DEC
    INDEX cod_cta_ctbl IS PRIMARY cod_cta_ctbl.


DEF TEMP-TABLE tt-conta-tot
    FIELD cod_cta_ctbl AS CHAR
    FIELD valor-orcado AS DEC FORMAT "->>>,>>>,>>9.999999" EXTENT 12
    FIELD valor-real AS DEC FORMAT "->>>,>>>,>>9.999999" EXTENT 12
    INDEX cod_cta_ctbl IS PRIMARY cod_cta_ctbl.

DEF TEMP-TABLE tt-estoque
    FIELD cod_cta_ctbl AS CHAR
    FIELD dia AS INT FORMAT "99"
    FIELD mes AS INT
    FIELD ano AS INT
    FIELD valor AS DEC FORMAT "->>>,>>>,>>9.999999" 
    INDEX cod_cta_ctbl IS PRIMARY cod_cta_ctbl.

DEF TEMP-TABLE tt-estoque-tot
    FIELD cod_cta_ctbl AS CHAR
    FIELD dia AS INT FORMAT "99"
    FIELD valor AS DEC FORMAT "->>>,>>>,>>9.999999" EXTENT 12
    INDEX cod_cta_ctbl IS PRIMARY cod_cta_ctbl.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-display

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 tt-display.acao tt-display.cod_cta_ctbl tt-display.descricao tt-display.tot-mes[1] tt-display.real-mes[1] tt-display.var-mes[1] tt-display.tot-mes[2] tt-display.real-mes[2] tt-display.var-mes[2] tt-display.tot-mes[3] tt-display.real-mes[3] tt-display.var-mes[3] tt-display.tot-mes[4] tt-display.real-mes[4] tt-display.var-mes[4] tt-display.tot-mes[5] tt-display.real-mes[5] tt-display.var-mes[5] tt-display.tot-mes[6] tt-display.real-mes[6] tt-display.var-mes[6] tt-display.tot-mes[7] tt-display.real-mes[7] tt-display.var-mes[7] tt-display.tot-mes[8] tt-display.real-mes[8] tt-display.var-mes[8] tt-display.tot-mes[9] tt-display.real-mes[9] tt-display.var-mes[9] tt-display.tot-mes[10] tt-display.real-mes[10] tt-display.var-mes[10] tt-display.tot-mes[11] tt-display.real-mes[11] tt-display.var-mes[11] tt-display.tot-mes[12] tt-display.real-mes[12] tt-display.var-mes[12] tt-display.tot-acum tt-display.real-acum tt-display.var-acum   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 real-mes   
&Scoped-define SELF-NAME BROWSE-3
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH tt-display     WHERE tt-display.acao <> "" NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY {&SELF-NAME} FOR EACH tt-display     WHERE tt-display.acao <> "" NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 tt-display
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 tt-display


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-5 RECT-6 rt-button bt-expande ~
bt-contrai bt-contrai-2 bt_seg l-ccusto-ativo l-ccusto-inativo l-orcado ~
l-realizado l-variacao l-origem cb-mes[1] cb-ano[1] cb-mes[7] cb-ano[7] ~
cb-mes[8] cb-ano[8] bt-preenche cb-mes[9] cb-ano[9] cb-mes[2] cb-ano[2] ~
cb-mes[10] cb-ano[10] cb-mes[3] cb-ano[3] cb-mes[11] cb-ano[11] cb-mes[4] ~
cb-ano[4] cb-mes[12] cb-ano[12] cb-mes[5] cb-ano[5] bt-importa cb-mes[6] ~
cb-ano[6] BROWSE-3 
&Scoped-Define DISPLAYED-OBJECTS l-ccusto-ativo l-ccusto-inativo l-orcado ~
l-realizado l-variacao l-origem cb-mes[1] cb-ano[1] cb-mes[7] cb-ano[7] ~
cb-mes[8] cb-ano[8] cb-mes[9] cb-ano[9] cb-mes[2] cb-ano[2] cb-mes[10] ~
cb-ano[10] cb-mes[3] cb-ano[3] cb-mes[11] cb-ano[11] cb-mes[4] cb-ano[4] ~
cb-mes[12] cb-ano[12] cb-mes[5] cb-ano[5] cb-mes[6] cb-ano[6] 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE ChTreeview AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chChTreeview AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-contrai 
     LABEL "--" 
     SIZE 4 BY 1.25 TOOLTIP "Clique aqui para minimizar o plano de contas".

DEFINE BUTTON bt-contrai-2 
     IMAGE-UP FILE "image/intelbras/dolar.ico":U
     LABEL "--" 
     SIZE 4 BY 1.25 TOOLTIP "Clique aqui para mostrar somente analiticas com valor".

DEFINE BUTTON bt-expande 
     LABEL "++" 
     SIZE 4 BY 1.25 TOOLTIP "Clique aqui para expandir o plano de contas".

DEFINE BUTTON bt-importa 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "Importa Arquivos" 
     SIZE 4 BY 1 TOOLTIP "Abre grafico com os dados selecionados no browse"
     BGCOLOR 15 FGCOLOR 11 .

DEFINE BUTTON bt-limpa 
     LABEL "Limpa" 
     SIZE 7 BY .75.

DEFINE BUTTON bt-preenche 
     LABEL "Preenche" 
     SIZE 7 BY .75.

DEFINE BUTTON bt_seg 
     IMAGE-UP FILE "image/im-segur.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-segur":U
     LABEL "Det" 
     SIZE 4 BY 1.25 TOOLTIP "Seguran‡a Or‡amento".

DEFINE BUTTON t-grafico 
     IMAGE-UP FILE "image/im-grf.bmp":U
     LABEL "Gr fico" 
     SIZE 4 BY 1.25 TOOLTIP "Abre grafico com os dados selecionados no browse".

DEFINE VARIABLE cb-ano AS CHARACTER FORMAT "X(256)":U  EXTENT 12
     VIEW-AS COMBO-BOX INNER-LINES 9
     LIST-ITEMS "2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE cb-mes AS CHARACTER FORMAT "X(256)":U  EXTENT 12
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Jan","1",
                     "Fev","2",
                     "Mar","3",
                     "Abr","4",
                     "Mai","5",
                     "Jun","6",
                     "Jul","7",
                     "Ago","8",
                     "Set","9",
                     "Out","10",
                     "Nov","11",
                     "Dez","12"
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 2.5.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 7.5.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 65 BY 1.46
     BGCOLOR 7 .

DEFINE VARIABLE l-ccusto-ativo AS LOGICAL INITIAL yes 
     LABEL "CCusto Ativo" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-ccusto-inativo AS LOGICAL INITIAL yes 
     LABEL "CCusto Inativo" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-orcado AS LOGICAL INITIAL yes 
     LABEL "Or‡ado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-origem AS LOGICAL INITIAL no 
     LABEL "Origem" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-realizado AS LOGICAL INITIAL yes 
     LABEL "Realizado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-variacao AS LOGICAL INITIAL yes 
     LABEL "Varia‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      tt-display SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 w-livre _FREEFORM
  QUERY BROWSE-3 NO-LOCK DISPLAY
      tt-display.acao
       tt-display.cod_cta_ctbl
       tt-display.descricao
       tt-display.tot-mes[1]
       tt-display.real-mes[1]
       tt-display.var-mes[1]  
       tt-display.tot-mes[2]  
       tt-display.real-mes[2]
       tt-display.var-mes[2]  
       tt-display.tot-mes[3]  
       tt-display.real-mes[3]
       tt-display.var-mes[3]  
       tt-display.tot-mes[4]  
       tt-display.real-mes[4]
       tt-display.var-mes[4]  
       tt-display.tot-mes[5]  
       tt-display.real-mes[5]
       tt-display.var-mes[5]  
       tt-display.tot-mes[6]  
       tt-display.real-mes[6]
       tt-display.var-mes[6]  
       tt-display.tot-mes[7]  
       tt-display.real-mes[7]
       tt-display.var-mes[7]  
       tt-display.tot-mes[8]  
       tt-display.real-mes[8]
       tt-display.var-mes[8]  
       tt-display.tot-mes[9]  
       tt-display.real-mes[9]
       tt-display.var-mes[9]  
       tt-display.tot-mes[10]  
       tt-display.real-mes[10]
       tt-display.var-mes[10]  
       tt-display.tot-mes[11]  
       tt-display.real-mes[11]
       tt-display.var-mes[11]
       tt-display.tot-mes[12]  
       tt-display.real-mes[12]
       tt-display.var-mes[12]
       tt-display.tot-acum     
       tt-display.real-acum
       tt-display.var-acum
       ENABLE real-mes
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS DROP-TARGET SIZE 111 BY 10.38
         FONT 3
         TITLE "".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-expande AT ROW 1.17 COL 56
     bt-contrai AT ROW 1.17 COL 61
     bt-contrai-2 AT ROW 1.17 COL 66
     bt_seg AT ROW 1.17 COL 81
     t-grafico AT ROW 1.17 COL 87
     l-ccusto-ativo AT ROW 1.54 COL 4
     l-ccusto-inativo AT ROW 1.54 COL 24
     l-orcado AT ROW 2.75 COL 4
     l-realizado AT ROW 2.75 COL 13
     l-variacao AT ROW 2.75 COL 24
     l-origem AT ROW 2.75 COL 34
     cb-mes[1] AT ROW 4 COL 4.72 COLON-ALIGNED
     cb-ano[1] AT ROW 4 COL 12 COLON-ALIGNED NO-LABEL
     cb-mes[7] AT ROW 4 COL 28 COLON-ALIGNED
     cb-ano[7] AT ROW 4 COL 35 COLON-ALIGNED NO-LABEL
     cb-mes[8] AT ROW 5 COL 28 COLON-ALIGNED
     cb-ano[8] AT ROW 5 COL 35 COLON-ALIGNED NO-LABEL
     bt-preenche AT ROW 5.25 COL 7
     bt-limpa AT ROW 5.25 COL 15
     cb-mes[9] AT ROW 6 COL 28 COLON-ALIGNED
     cb-ano[9] AT ROW 6 COL 35 COLON-ALIGNED NO-LABEL
     cb-mes[2] AT ROW 6.25 COL 4.72 COLON-ALIGNED
     cb-ano[2] AT ROW 6.25 COL 12 COLON-ALIGNED NO-LABEL
     cb-mes[10] AT ROW 7 COL 28 COLON-ALIGNED
     cb-ano[10] AT ROW 7 COL 35 COLON-ALIGNED NO-LABEL
     cb-mes[3] AT ROW 7.25 COL 4.72 COLON-ALIGNED
     cb-ano[3] AT ROW 7.25 COL 12 COLON-ALIGNED NO-LABEL
     cb-mes[11] AT ROW 8 COL 28 COLON-ALIGNED
     cb-ano[11] AT ROW 8 COL 35 COLON-ALIGNED NO-LABEL
     cb-mes[4] AT ROW 8.25 COL 4.72 COLON-ALIGNED
     cb-ano[4] AT ROW 8.25 COL 12 COLON-ALIGNED NO-LABEL
     cb-mes[12] AT ROW 9 COL 28 COLON-ALIGNED
     cb-ano[12] AT ROW 9 COL 35 COLON-ALIGNED NO-LABEL
     cb-mes[5] AT ROW 9.25 COL 4.72 COLON-ALIGNED
     cb-ano[5] AT ROW 9.25 COL 12 COLON-ALIGNED NO-LABEL
     bt-importa AT ROW 10 COL 41
     cb-mes[6] AT ROW 10.25 COL 4.72 COLON-ALIGNED
     cb-ano[6] AT ROW 10.25 COL 12 COLON-ALIGNED NO-LABEL
     BROWSE-3 AT ROW 11.67 COL 1
     RECT-5 AT ROW 1.21 COL 2
     RECT-6 AT ROW 3.75 COL 2
     rt-button AT ROW 1 COL 47
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 111.14 BY 21.54
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-livre ASSIGN
         HIDDEN             = YES
         TITLE              = "es0940 - Controle Or‡ament rio"
         HEIGHT             = 21.54
         WIDTH              = 111.14
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.21
         VIRTUAL-WIDTH      = 146.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = 18
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-livre 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-3 cb-ano[6] f-cad */
ASSIGN 
       BROWSE-3:NUM-LOCKED-COLUMNS IN FRAME f-cad     = 3
       BROWSE-3:COLUMN-RESIZABLE IN FRAME f-cad       = TRUE.

/* SETTINGS FOR BUTTON bt-limpa IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       bt-limpa:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR BUTTON t-grafico IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       t-grafico:HIDDEN IN FRAME f-cad           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-display
    WHERE tt-display.acao <> "" NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME ChTreeview ASSIGN
       FRAME           = FRAME f-cad:HANDLE
       ROW             = 2.5
       COLUMN          = 47
       HEIGHT          = 8.75
       WIDTH           = 65
       HIDDEN          = no
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      ChTreeview:NAME = "ChTreeview":U .
/* ChTreeview OCXINFO:CREATE-CONTROL from: {6C00BE45-F188-11D2-8CE6-00A0D21A0A6B} type: TreeView4GL */
      ChTreeview:MOVE-AFTER(l-ccusto-inativo:HANDLE IN FRAME f-cad).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* es0940 - Controle Or‡ament rio */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* es0940 - Controle Or‡ament rio */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  
  hproc:DISCONNECT().
  DELETE OBJECT hproc.  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&Scoped-define SELF-NAME BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 w-livre
ON MOUSE-SELECT-DBLCLICK OF BROWSE-3 IN FRAME f-cad
DO:

/*teste*/
    IF tt-display.ind_espec_cta_ctbl = "Analitica" 
    OR tt-display.ind_espec_cta_ctbl = "Origem" 
       THEN RETURN NO-APPLY.

    DEF VAR X AS CHAR.

    ASSIGN X = ENTRY(1,tt-display.cod_cta_ctbl,"0").

    DEF VAR l-continua AS LOG.
    DEF VAR r-rowid    AS ROWID.
    
    ASSIGN r-rowid = ROWID(tt-display).

    IF tt-display.acao = "++" 
    THEN DO:

         ASSIGN tt-display.acao = "--".

         ASSIGN l-continua = YES.

         FOR EACH btt-display
            WHERE LENGTH(ENTRY(1,btt-display.cod_cta_ctbl,"0")) = LENGTH(ENTRY(1,tt-display.cod_cta_ctbl,"0")) + 1 
              AND NUM-ENTRIES(btt-display.cod_cta_ctbl,"0")     = NUM-ENTRIES(tt-display.cod_cta_ctbl,"0") - 1 
              AND btt-display.cod_cta_ctbl BEGINS ENTRY(1,tt-display.cod_cta_ctbl,"0")
              AND btt-display.cod_cta_ctbl <> tt-display.cod_cta_ctbl.

             ASSIGN btt-display.acao = "++"
                    l-continua       = NO.

             IF btt-display.ind_espec_cta_ctbl = "Analitica"  
                THEN ASSIGN btt-display.acao = "....".

             IF btt-display.ind_espec_cta_ctbl = "Origem"  
             THEN do:
                 ASSIGN btt-display.acao = "###".
             END.

         END.

         IF l-continua  
         THEN DO:

             FOR EACH btt-display
                WHERE btt-display.cod_cta_ctbl BEGINS ENTRY(1,tt-display.cod_cta_ctbl,"0")
                  AND btt-display.cod_cta_ctbl <> tt-display.cod_cta_ctbl.
                 ASSIGN btt-display.acao = "++".

                 IF btt-display.ind_espec_cta_ctbl = "Analitica"  THEN
                    ASSIGN btt-display.acao = "....".

                 IF btt-display.ind_espec_cta_ctbl = "Origem"  
                 THEN do:
                     ASSIGN btt-display.acao = "###".
                 END.
   
             END.

         END.

    END.
    ELSE DO:

        ASSIGN tt-display.acao = "++".

        FOR EACH btt-display
          WHERE  btt-display.cod_cta_ctbl > tt-display.cod_cta_ctbl
            AND btt-display.cod_cta_ctbl BEGINS ENTRY(1,tt-display.cod_cta_ctbl,"0").

             ASSIGN btt-display.acao = "".

         END.

    END.


    {&OPEN-QUERY-{&BROWSE-NAME}}

    REPOSITION {&browse-name} TO ROWID r-rowid.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-contrai
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-contrai w-livre
ON CHOOSE OF bt-contrai IN FRAME f-cad /* -- */
DO:
     
     FOR EACH btt-display:
         ASSIGN btt-display.acao = "".
     END.
     
     FIND FIRST btt-display NO-ERROR.
     IF AVAIL btt-display THEN
         ASSIGN btt-display.acao = "++".

   {&OPEN-QUERY-{&BROWSE-NAME}}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-contrai-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-contrai-2 w-livre
ON CHOOSE OF bt-contrai-2 IN FRAME f-cad /* -- */
DO:
     
     FOR EACH btt-display:

         ASSIGN btt-display.acao = "...".

         IF btt-display.ind_espec_cta_ctbl = "sintetica" THEN 
            ASSIGN btt-display.acao = "".

         IF  btt-display.tot-acum  = 0 
         AND btt-display.real-acum = 0 
             THEN ASSIGN btt-display.acao = "".

         /*teste*/
         IF btt-display.ind_espec_cta_ctbl = "origem" THEN 
            ASSIGN btt-display.acao = "###".


     END.
     
     {&OPEN-QUERY-{&BROWSE-NAME}}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-expande
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-expande w-livre
ON CHOOSE OF bt-expande IN FRAME f-cad /* ++ */
DO:
     DEF VAR X AS CHAR.
     IF AVAIL tt-display THEN
         ASSIGN X = ENTRY(1,tt-display.cod_cta_ctbl,"0").

     DEF VAR l-continua AS LOG.
     DEF VAR r-rowid AS ROWID.
     IF AVAIL tt-display THEN
         ASSIGN r-rowid = ROWID(tt-display).

     
     FOR EACH btt-display:
         ASSIGN btt-display.acao = "--".
         IF btt-display.ind_espec_cta_ctbl = "Analitica" THEN
             ASSIGN btt-display.acao = "....".
         /*teste*/
         IF btt-display.ind_espec_cta_ctbl = "Origem" THEN
             ASSIGN btt-display.acao = "####".

     END.
     
   {&OPEN-QUERY-{&BROWSE-NAME}}


    IF r-rowid <> ? THEN
        REPOSITION {&browse-name} TO ROWID r-rowid.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-importa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importa w-livre
ON CHOOSE OF bt-importa IN FRAME f-cad /* Importa Arquivos */
DO:
    

     ASSIGN INPUT FRAME {&FRAME-NAME} cb-mes
            INPUT FRAME {&FRAME-NAME} cb-ano.

     EMPTY TEMP-TABLE tt-periodo.

     DO i-cont = 1 TO 12.
         CREATE tt-periodo.
         ASSIGN tt-periodo.mes = string(int(cb-mes[i-cont]),"99")
                tt-periodo.ano = cb-ano[i-cont].
     END.

     RUN pi-monta.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-limpa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-limpa w-livre
ON CHOOSE OF bt-limpa IN FRAME f-cad /* Limpa */
DO:
  DO i-cont = 1 TO 12:

      ASSIGN cb-mes[i-cont] = ""
             cb-ano[i-cont] = "".
        
  END.

  DEF VAR X AS LOG.
  ASSIGN X = cb-mes[2]:EDIT-CLEAR().


  ASSIGN cb-mes[2]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
         cb-ano[2]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
       cb-mes[3]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
         cb-ano[3]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
       cb-mes[4]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
         cb-ano[4]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
       cb-mes[5]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
         cb-ano[5]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
       cb-mes[6]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
         cb-ano[6]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
       cb-mes[7]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
         cb-ano[7]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
       cb-mes[8]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
         cb-ano[8]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
       cb-mes[9]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
         cb-ano[9]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
       cb-mes[10]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
         cb-ano[10]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
       cb-mes[11]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
         cb-ano[11]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   cb-mes[12]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
         cb-ano[12]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
      
      
      .


  MESSAGE cb-mes[2]
      VIEW-AS ALERT-BOX INFO BUTTONS OK.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-preenche
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-preenche w-livre
ON CHOOSE OF bt-preenche IN FRAME f-cad /* Preenche */
DO:
  ASSIGN cb-mes[1]
         cb-ano[1].

  IF cb-mes[1] = "" OR cb-ano[1] = "" THEN RETURN NO-APPLY.


  ASSIGN i-ano-x = int(cb-ano[1]).

  DO i-cont = 1 TO 11:

      ASSIGN cb-mes[i-cont + 1] = string(int(cb-mes[i-cont]) + 1).

      IF int(cb-mes[i-cont + 1]) = 13 THEN
          ASSIGN cb-mes[i-cont + 1] = "1"
                 i-ano-x = i-ano-x + 1.

      ASSIGN cb-ano[i-cont + 1] = string(i-ano-x,"9999").
        
  END.
  DISPLAY cb-mes 
          cb-ano
          WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_seg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_seg w-livre
ON CHOOSE OF bt_seg IN FRAME f-cad /* Det */
DO:
    RUN esp/es0512-2.p.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[10] w-livre
ON VALUE-CHANGED OF cb-ano[10] IN FRAME f-cad
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[10] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[10] <> "" THEN 
        RUN pi-tree.
    */    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[11]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[11] w-livre
ON VALUE-CHANGED OF cb-ano[11] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[11] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[11] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[12]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[12] w-livre
ON VALUE-CHANGED OF cb-ano[12] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[12] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[12] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[1] w-livre
ON VALUE-CHANGED OF cb-ano[1] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[1] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[1] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[2] w-livre
ON VALUE-CHANGED OF cb-ano[2] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[2] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[2] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[3] w-livre
ON VALUE-CHANGED OF cb-ano[3] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[3] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[3] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[4] w-livre
ON VALUE-CHANGED OF cb-ano[4] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[4] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[4] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[5] w-livre
ON VALUE-CHANGED OF cb-ano[5] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[5] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[5] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[6] w-livre
ON VALUE-CHANGED OF cb-ano[6] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[6] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[6] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[7] w-livre
ON VALUE-CHANGED OF cb-ano[7] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[7] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[7] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[8] w-livre
ON VALUE-CHANGED OF cb-ano[8] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[8] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[8] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano[9] w-livre
ON VALUE-CHANGED OF cb-ano[9] IN FRAME f-cad
DO:
    /*
  IF  INPUT FRAME {&FRAME-NAME} cb-mes[9] <> "" 
  AND INPUT FRAME {&FRAME-NAME} cb-ano[9] <> "" THEN 
    RUN pi-tree.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[10] w-livre
ON VALUE-CHANGED OF cb-mes[10] IN FRAME f-cad /* cb-mes */
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[10] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[10] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[11]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[11] w-livre
ON VALUE-CHANGED OF cb-mes[11] IN FRAME f-cad /* cb-mes */
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[11] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[11] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[12]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[12] w-livre
ON VALUE-CHANGED OF cb-mes[12] IN FRAME f-cad /* cb-mes */
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[12] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[12] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[1] w-livre
ON VALUE-CHANGED OF cb-mes[1] IN FRAME f-cad /* cb-mes */
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[1] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[1] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[2] w-livre
ON VALUE-CHANGED OF cb-mes[2] IN FRAME f-cad /* cb-mes */
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[2] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[2] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[3] w-livre
ON VALUE-CHANGED OF cb-mes[3] IN FRAME f-cad /* cb-mes */
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[3] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-mes[3] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[4] w-livre
ON VALUE-CHANGED OF cb-mes[4] IN FRAME f-cad /* cb-mes */
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[4] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[4] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[5] w-livre
ON VALUE-CHANGED OF cb-mes[5] IN FRAME f-cad /* cb-mes */
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[5] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[5] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[6] w-livre
ON VALUE-CHANGED OF cb-mes[6] IN FRAME f-cad /* cb-mes */
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[6] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[6] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[7] w-livre
ON VALUE-CHANGED OF cb-mes[7] IN FRAME f-cad /* cb-mes */
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[7] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[7] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[8] w-livre
ON VALUE-CHANGED OF cb-mes[8] IN FRAME f-cad /* cb-mes */
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[8] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[8] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-mes[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-mes[9] w-livre
ON VALUE-CHANGED OF cb-mes[9] IN FRAME f-cad /* cb-mes */
DO:
    /*
    IF  INPUT FRAME {&FRAME-NAME} cb-mes[9] <> "" 
    AND INPUT FRAME {&FRAME-NAME} cb-ano[9] <> "" THEN 
        RUN pi-tree.
        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ChTreeview
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ChTreeview w-livre
ON ENTRY OF ChTreeview /* TreeView4GL */
DO:
  
    assign v_log_method = session:set-wait-state('general').
  
    ASSIGN c-cc-codigo = "".
    
    ASSIGN c-segur = "empresa".

    FIND FIRST tt-usu WHERE tt-usu.cc = c-segur NO-ERROR.
    IF AVAIL tt-usu THEN

        RUN  rpc/orcamento.p  /* ON SERVER  hproc */( 
                             INPUT "empresa",
                             INPUT TABLE tt-periodo,
                             OUTPUT TABLE tt-conta,
                             OUTPUT TABLE tt-conta-tot,
                             OUTPUT TABLE tt-estoque,
                             OUTPUT TABLE tt-estoque-tot
                            )  .   
    
    
    RUN carrega.

    assign browse browse-3:title = "Total da Empresa".

    assign v_log_method = session:set-wait-state("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ChTreeview w-livre OCX.OnChange
PROCEDURE ChTreeview.TreeView4GL.OnChange .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  Required for OCX.
    NodeInfo
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-NodeInfo AS CHARACTER NO-UNDO.

    assign v_log_method = session:set-wait-state('general').
    
    ASSIGN c-segur = {nodeprivate.i}.

    ASSIGN c-cc-codigo = "".

    IF {nodeprivate.i} BEGINS "CC" THEN
        ASSIGN c-cc-codigo = ENTRY(2,{nodeprivate.i},":")
               c-cc-codigo = SUBSTRING(c-cc-codigo,4,5).

    IF c-segur BEGINS "UNI" 
    OR c-segur BEGINS "DIV" 
    OR c-segur BEGINS "CC" THEN ASSIGN c-segur = ENTRY(2,c-segur,":").

    /*fabiano*/        
    IF c-segur BEGINS "I"
    OR c-segur BEGINS "E"
       THEN FIND tt-usu WHERE tt-usu.cc = c-segur NO-ERROR.
       /* ** Corre‡Æo seguran‡a ***
       ELSE FIND FIRST tt-usu WHERE tt-usu.cc MATCHES("*" + substring(c-segur, 4, 5) + "*") NO-ERROR. ***/
       ELSE FIND FIRST tt-usu WHERE tt-usu.cc MATCHES("*" + c-cc-codigo + "*") NO-ERROR.

    IF AVAIL tt-usu THEN
        RUN rpc/orcamento.p  /* ON SERVER  hproc */( 
                             INPUT {nodeprivate.i},
                             INPUT TABLE tt-periodo,
                             OUTPUT TABLE tt-conta,
                             OUTPUT TABLE tt-conta-tot,
                             OUTPUT TABLE tt-estoque,
                             OUTPUT TABLE tt-estoque-tot
                            )  .   

   
    RUN carrega.

    assign browse browse-3:title = {nodeprivate.i}.

    assign v_log_method = session:set-wait-state("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME t-grafico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-grafico w-livre
ON CHOOSE OF t-grafico IN FRAME f-cad /* Gr fico */
DO:
    for each tt-atributos:
        delete tt-atributos.
    end.
    for each tt-dados:
        delete tt-dados.
    end.
    for each tt-erros:
        delete tt-erros.
    end.
    for each tt-sets:
        delete tt-sets.
    end.
    for each tt-points:
        delete tt-points.
    end.

    create tt-atributos.
    assign tt-atributos.numgraph = 1
           tt-atributos.cod-versao-integracao = 3
           tt-atributos.graphtitle = tt-display.descricao
           tt-atributos.graphtype  = 6
           tt-atributos.graphstyle = 4.

    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 1
           tt-sets.legendtext = "M x"
           tt-sets.colorset   = 9.
    create tt-sets.
    assign tt-sets.numgraph  = 1
           tt-sets.numset    = 2
           tt-sets.legendtext = "Sal"
           tt-sets.colorset   = 0.
    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 3
           tt-sets.legendtext = "Seg"
           tt-sets.colorset   = 12.
 
    def var conta as int initial 0.

    assign conta = 0.
    
    do i-cont = 1 to 12:
        IF i-mes[i-cont] <> 0 THEN DO:
            create tt-points.
            assign tt-points.numgraph = 1
                   tt-points.numpoint = conta
                   tt-points.labeltext = c-label[i-cont].

           
        END.
    end.
  
    run utp\utapi001.p (Input  table tt-atributos,
                        Input  table tt-points,
                        Input  table tt-sets,
                        Input  table tt-dados,
                        Input  table tt-ylabels,
                        Output table tt-erros).
    
     FOR EACH tt-erros:
            MESSAGE tt-erros.cod-erro tt-erros.desc-erro
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
     END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-livre 


IF c-seg-usuario <> "" THEN
    ASSIGN c-usuario = c-seg-usuario.

IF v_cod_usuar_corren <> "" THEN
    ASSIGN c-usuario = v_cod_usuar_corren.

EMPTY TEMP-TABLE tt-prog-ponto.
RUN esp/es0018p.p (INPUT "ambiente":U, INPUT 1, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto NO-ERROR.

IF AVAILABLE tt-prog-ponto               AND
   tt-prog-ponto.conteudo = "PRODUCAO":U THEN
    ASSIGN l-teste = NO.
ELSE
    ASSIGN l-teste = YES.

IF  l-teste THEN DO:
    FIND FIRST servid_rpc NO-LOCK
        WHERE  servid_rpc.des_servid_rpc MATCHES "*teste*"
        AND    servid_rpc.log_servid_rpc_dispon = TRUE NO-ERROR.
    IF  AVAIL  servid_rpc 
    THEN ASSIGN c-connect = TRIM(servid_rpc.des_carg_rpc).
END.
ELSE DO:
    /* a definir com o Braun, quando producao tiver dois servidores RPC */

    FIND FIRST servid_rpc NO-LOCK
        WHERE  servid_rpc.des_servid_rpc MATCHES "*produ*"
        AND    servid_rpc.log_servid_rpc_dispon = TRUE NO-ERROR.
    IF  AVAIL  servid_rpc 
    THEN ASSIGN c-connect = TRIM(servid_rpc.des_carg_rpc).
END.

IF  c-connect = "" THEN DO:
    MESSAGE 'NÆo existe servidor RPC cadastrado. Processo interrompido.' VIEW-AS ALERT-BOX ERROR TITLE 'Erro RPC'.
    QUIT.
END.

CREATE SERVER hproc.

/* atualiza rela‡Æo de acessos do usu rio */

EMPTY TEMP-TABLE tt-usu.
ASSIGN c-cc-codigo = "".

FOR EACH usuario-cc-orc NO-LOCK
    WHERE usuario-cc-orc.cod-usuario = c-usuario.

    /* Fabiano - retirar condicional quando implementado o tratamento de empresa e estabelecimento */
    if not can-find(first tt-usu
                    where tt-usu.cc = usuario-cc-orc.cod-ccusto)
    then do:
         CREATE tt-usu.
         ASSIGN tt-usu.cc = usuario-cc-orc.cod-ccusto.
    end.

END.
 
ON mouse-select-dblclick OF tt-display.real-mes IN BROWSE browse-3 
DO:
   
     IF tt-display.ind_espec_cta_ctbl = "sintetica" THEN DO:
         MESSAGE "O detalhamento s¢ est  dispon¡vel para contas Anal¡ticas"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.

     END.

     FIND FIRST centro-custo NO-LOCK
         WHERE  centro-custo.cc-codigo MATCHES("*" + c-cc-codigo + "*") NO-ERROR.
     IF NOT AVAIL centro-custo THEN DO:
         MESSAGE "O detalhamento s¢ est  dispon¡vel para centros de custos"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.

         RETURN NO-APPLY.
     END.

     RUN menu-es\es0940a.w (INPUT INT(cb-mes[FRAME-INDEX]) ,
                            INPUT INT(cb-ano[FRAME-INDEX]) ,
                            INPUT tt-display.cod_cta_ctbl  ,
                            INPUT c-cc-codigo).

END.

ON any-key OF tt-display.real-mes IN BROWSE browse-3 
DO:
   
     IF KEYLABEL(LASTKEY) <> "tab" THEN
        RETURN NO-APPLY.
END.

 
/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-livre  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'panel/p-exihel.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-exihel ).
       RUN set-position IN h_p-exihel ( 1.17 , 95.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             t-grafico:HANDLE IN FRAME f-cad , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-livre  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carrega w-livre 
PROCEDURE carrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def var da-data-ini as date.
def var da-data-fim as date.
def var v_cont      as int.

    EMPTY TEMP-TABLE tt-display.

    IF NOT AVAIL tt-usu THEN do:
        {&open-query-{&browse-name}}
        NEXT.
    END.



    FOR EACH cta_ctbl NO-LOCK
     WHERE cta_ctbl.cod_cta_ctbl >= "40000000"
       AND cta_ctbl.cod_cta_ctbl  < "42000000":
      CREATE tt-display.
      assign tt-display.cod_cta_ctbl = cta_ctbl.cod_cta_ctbl
             tt-display.descricao = FILL(" ",(length(entry(1,cta_ctbl.cod_cta_ctbl,"0")) * 2 )) + cta_ctbl.des_tit_ctbl
             tt-display.ind_espec_cta_ctbl = cta_ctbl.ind_espec_cta_ctbl.

       FIND tt-conta-tot WHERE tt-conta-tot.cod_cta_ctbl = tt-display.cod_cta_ctbl NO-ERROR.


       IF AVAIL tt-conta-tot THEN DO:

           DO i-cont = 1 TO 12:
                    ASSIGN tt-display.tot-mes[i-cont]  = tt-conta-tot.valor-orcado[i-cont] 
                           tt-display.real-mes[i-cont] = tt-conta-tot.valor-real[i-cont]
                           tt-display.var-mes[i-cont] = (tt-conta-tot.valor-real[i-cont] * 100 ) / tt-conta-tot.valor-orcado[i-cont] 
                           tt-display.tot-acum = tt-display.tot-acum + tt-conta-tot.valor-orcado[i-cont]
                           tt-display.real-acum = tt-display.real-acum + tt-conta-tot.valor-real[i-cont]
                           tt-display.var-acum = (tt-display.real-acum * 100 ) / tt-display.tot-acum.


                    IF  INPUT FRAME {&FRAME-NAME} l-origem = YES 
                    THEN DO:

                           /* teste */    
                           IF cta_ctbl.ind_espec_cta_ctbl = "analitica" 
                           AND cb-mes[i-cont] <> "" 
                           AND cb-ano[i-cont] <> "" 
                           THEN do:
                           
                                FIND centro-custo NO-LOCK
                                WHERE centro-custo.cc-codigo MATCHES("*" + c-cc-codigo + "*") NO-ERROR.
                           
                                IF AVAIL centro-custo 
                                THEN DO:
            
                                    ASSIGN da-data-ini = DATE("1" + "/" + STRING(cb-mes[i-cont]) + "/" + STRING(cb-ano[i-cont]))
                                           da-data-fim = da-data-ini + 30.
                                 
                                    DO WHILE MONTH(da-data-fim) <> MONTH(da-data-ini):
                                        ASSIGN da-data-fim = da-data-fim - 1.
                                    END.
                                 
                                    FIND centro-custo NO-LOCK
                                         WHERE centro-custo.cc-codigo MATCHES("*" + c-cc-codigo + "*") NO-ERROR.
                                 
                                    EMPTY TEMP-TABLE tt-dados-consulta.

                                    IF AVAIL centro-custo 
                                    THEN DO:

                                         FOR EACH estabelecimento NO-LOCK
                                             WHERE estabelecimento.cod_empresa = '1':
                                
                                             IF estabelecimento.cod_estab = '102' 
                                                THEN NEXT.
                                 
                                             RUN  menu-es\es0940aa.p (INPUT estabelecimento.cod_estab,
                                                                      INPUT "padrao",
                                                                      INPUT cta_ctbl.cod_cta_ctbl,
                                                                      INPUT centro-custo.cc-codigo,
                                                                      INPUT da-data-ini,
                                                                      INPUT da-data-fim,
                                                                      OUTPUT TABLE tt-dados-consulta-aux).     

                                             FOR EACH tt-dados-consulta-aux.
                                                 CREATE tt-dados-consulta.
                                                 ASSIGN tt-dados-consulta.cod_estab             =  estabelecimento.cod_estab
                                                        tt-dados-consulta.origem                =  tt-dados-consulta-aux.origem               
                                                        tt-dados-consulta.ind_natur_lancto_ctbl =  tt-dados-consulta-aux.ind_natur_lancto_ctbl
                                                        tt-dados-consulta.cod_emitente          =  tt-dados-consulta-aux.cod_emitente         
                                                        tt-dados-consulta.nome_emitente         =  tt-dados-consulta-aux.nome_emitente        
                                                        tt-dados-consulta.dt_transacao          =  tt-dados-consulta-aux.dt_transacao         
                                                        tt-dados-consulta.cod_espec_docto       =  tt-dados-consulta-aux.cod_espec_docto      
                                                        tt-dados-consulta.cod_ser_docto         =  tt-dados-consulta-aux.cod_ser_docto        
                                                        tt-dados-consulta.cod_tit_ap            =  tt-dados-consulta-aux.cod_tit_ap           
                                                        tt-dados-consulta.cod_parcela           =  tt-dados-consulta-aux.cod_parcela          
                                                        tt-dados-consulta.val_aprop_ctbl        =  tt-dados-consulta-aux.val_aprop_ctbl.
                                             END.

                                         END.

                                    END.
                                 
                                    ASSIGN v_cont = 1.

                                    FOR EACH tt-dados-consulta:
                                    
                                          assign v_cont = v_cont + 2.
                                          CREATE btt-display.
                                          assign btt-display.cod_cta_ctbl       = cta_ctbl.cod_cta_ctbl + string(v_cont)
                                                 btt-display.descricao          = '               ' + tt-dados-consulta.cod_estab + ' - ' + tt-dados-consulta.origem + ' - ' + tt-dados-consulta.ind_natur_lancto_ctbl
                                                                                  + ' - Emitente: ' + string(tt-dados-consulta.cod_emitente) + ' - ' + tt-dados-consulta.nome_emitente 
                                                                                  + ' - Data: ' + string(tt-dados-consulta.dt_transacao) + ' - Esp: ' + tt-dados-consulta.cod_espec_docto
                                                                                  + ' - Ser: ' + tt-dados-consulta.cod_ser_docto + ' - Nota: ' + tt-dados-consulta.cod_tit_ap
                                                                                  + ' - Parc: ' + tt-dados-consulta.cod_parcela
                                                 btt-display.ind_espec_cta_ctbl = 'Origem'
                                                 btt-display.real-mes[i-cont] = if tt-dados-consulta.ind_natur_lancto_ctbl = 'DB' then tt-dados-consulta.val_aprop_ctbl
                                                                                                                                  else (tt-dados-consulta.val_aprop_ctbl * (-1)).
                                    END.
                                       
                                END.       
                           
                           END.

                    END.
                   
            END.
       END.

       IF cta_ctbl.cod_cta_ctbl = "40000000" THEN
              ASSIGN tt-display.acao = "++"
                     tt-display.descricao =  cta_ctbl.des_tit_ctbl.
    
       IF cta_ctbl.ind_espec_cta_ctbl = "analitica" THEN
              ASSIGN tt-display.descricao = "  " + tt-display.descricao.
    
    
    END.


  FOR EACH tt-display.
       DO i-cont = 1 TO 12:
           IF tt-display.var-mes[i-cont] > 999 THEN 
               ASSIGN tt-display.var-mes[i-cont] = 999.9.
           
           IF tt-display.var-mes[i-cont] < -999 THEN 
               ASSIGN tt-display.var-mes[i-cont] = -999.9.

       END.
       IF tt-display.var-acum > 999  THEN
               ASSIGN tt-display.var-acum = 999.9.

       IF tt-display.var-acum < -999 THEN
              ASSIGN tt-display.var-acum = -999.9.


  END.



      {&open-query-{&browse-name}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load w-livre  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "menu-es/es0940-1.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chChTreeview = ChTreeview:COM-HANDLE
    UIB_S = chChTreeview:LoadControls( OCXFile, "ChTreeview":U).

  RUN DISPATCH IN THIS-PROCEDURE("initialize-controls":U) NO-ERROR.
END.
ELSE MESSAGE "es0940-1.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-livre  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
  THEN DELETE WIDGET w-livre.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-livre  _DEFAULT-ENABLE
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
  DISPLAY l-ccusto-ativo l-ccusto-inativo l-orcado l-realizado l-variacao 
          l-origem cb-mes[1] cb-ano[1] cb-mes[7] cb-ano[7] cb-mes[8] cb-ano[8] 
          cb-mes[9] cb-ano[9] cb-mes[2] cb-ano[2] cb-mes[10] cb-ano[10] 
          cb-mes[3] cb-ano[3] cb-mes[11] cb-ano[11] cb-mes[4] cb-ano[4] 
          cb-mes[12] cb-ano[12] cb-mes[5] cb-ano[5] cb-mes[6] cb-ano[6] 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE RECT-5 RECT-6 rt-button bt-expande bt-contrai bt-contrai-2 bt_seg 
         l-ccusto-ativo l-ccusto-inativo l-orcado l-realizado l-variacao 
         l-origem cb-mes[1] cb-ano[1] cb-mes[7] cb-ano[7] cb-mes[8] cb-ano[8] 
         bt-preenche cb-mes[9] cb-ano[9] cb-mes[2] cb-ano[2] cb-mes[10] 
         cb-ano[10] cb-mes[3] cb-ano[3] cb-mes[11] cb-ano[11] cb-mes[4] 
         cb-ano[4] cb-mes[12] cb-ano[12] cb-mes[5] cb-ano[5] bt-importa 
         cb-mes[6] cb-ano[6] BROWSE-3 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-livre.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-livre 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  
 /* 
  {include/i-logfin.i}
   */
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-livre 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-livre 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
/*  run pi-before-initialize.
 
  {include/win-size.i}
  {utp/ut9000.i "XX9999" "9.99.99.999"}
  */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  ASSIGN cb-mes[1]:LABEL  IN FRAME {&FRAME-NAME} = "1"
         cb-mes[2]:LABEL  IN FRAME {&FRAME-NAME} = "2"
         cb-mes[3]:LABEL  IN FRAME {&FRAME-NAME} = "3"
         cb-mes[4]:LABEL  IN FRAME {&FRAME-NAME} = "4"
         cb-mes[5]:LABEL  IN FRAME {&FRAME-NAME} = "5"
         cb-mes[6]:LABEL  IN FRAME {&FRAME-NAME} = "6"
         cb-mes[7]:LABEL  IN FRAME {&FRAME-NAME} = "7"
         cb-mes[8]:LABEL  IN FRAME {&FRAME-NAME} = "8"
         cb-mes[9]:LABEL  IN FRAME {&FRAME-NAME} = "9"
         cb-mes[10]:LABEL IN FRAME {&FRAME-NAME} = "10"
         cb-mes[11]:LABEL IN FRAME {&FRAME-NAME} = "11"
         cb-mes[12]:LABEL IN FRAME {&FRAME-NAME} = "12".
  
  /* Code placed here will execute AFTER standard behavior.    */
/*
  run pi-after-initialize.
  
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-monta w-livre 
PROCEDURE pi-monta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    chChTreeview:TreeView4GL:clear().     
    chChTreeview:TreeView4GL:TreeRefresh = false.

    ASSIGN i-comp = 0.
    
    EMPTY TEMP-TABLE tt-uni.


    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "ES0940":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-dir-saida = replace(tt-prog-ponto.conteudo, "/", "~\").

        IF SUBSTRING(c-dir-saida, LENGTH(c-dir-saida), 1) <> "~\" THEN
            ASSIGN c-dir-saida = c-dir-saida + "~\".
    END.

    INPUT FROM VALUE (c-dir-saida + "cc-unidade.csv").
    REPEAT:
        IMPORT UNFORMATTED c-linha.
        CREATE tt-uni.
        
        ASSIGN i-comp = i-comp + 1.

        ASSIGN tt-uni.unidade    = ENTRY(1,c-linha,";")
               tt-uni.divisao    = ENTRY(2,c-linha,";")
               tt-uni.cod_ccusto = STRING(INT(ENTRY(3,c-linha,";")),"99999999").
    END.
    INPUT CLOSE.

    run utp/ut-perc.p persistent set h-prog.
    run pi-inicializar in h-prog (input "Atualizando  rvore", i-comp).

    chChTreeview:TreeView4GL:addnodes( "0~t" + "Total da Empresa" + "~t0,1~t1~t~tEmpresa" ).

    FOR EACH tt-uni
        BREAK BY tt-uni.unidade
              BY tt-uni.divisao
              BY tt-uni.cod_ccusto:
        
        IF FIRST-OF(tt-uni.unidade) THEN
            chChTreeview:TreeView4GL:addnodes( "1~t" + tt-uni.unidade + "~t0,1~t1~t~tUNI:" + tt-uni.unidade ).

        IF FIRST-OF(tt-uni.divisao) THEN
            chChTreeview:TreeView4GL:addnodes( "2~t" + tt-uni.divisao + "~t0,1~t1~t~tDIV:" + tt-uni.unidade + tt-uni.divisao ).

        FIND emscad.ccusto NO-LOCK
            WHERE emscad.ccusto.cod_empresa      = '1'
              AND emscad.ccusto.cod_plano_ccusto = "Padrao"
              AND emscad.ccusto.cod_ccusto       = SUBSTRING(tt-uni.cod_ccusto, 4, 5) NO-ERROR.

        /* ** Filtro CCusto ***/
        IF  AVAIL emscad.ccusto
        THEN DO:
             IF  INPUT FRAME {&FRAME-NAME} l-ccusto-inativo = NO 
             AND emscad.ccusto.dat_fim_valid < TODAY
                 THEN NEXT.
             IF  INPUT FRAME {&FRAME-NAME} l-ccusto-ativo = NO 
             AND emscad.ccusto.dat_fim_valid >= TODAY 
                 THEN NEXT.
        END.

        /*Fabiano - Tratar mais de uma unidade por centro de custo*/
        FIND centro-custo NO-LOCK
             WHERE centro-custo.cc-codigo = SUBSTRING(tt-uni.cod_ccusto,4,5) NO-ERROR.
        IF AVAIL centro-custo THEN
            chChTreeview:TreeView4GL:addnodes( "3~t" + tt-uni.cod_ccusto + " - " + centro-custo.descricao + "~t0,1~t1~t~tCC:" + tt-uni.cod_ccusto).
        ELSE
            chChTreeview:TreeView4GL:addnodes( "3~t" + tt-uni.cod_ccusto + " - " + "Sem Descricao" + "~t0,1~t1~t~tCC:" + tt-uni.cod_ccusto).

        run pi-acompanhar in h-prog.
        RUN pi-registro in h-prog (input string(tt-uni.cod_ccusto)).

    END.

    run pi-finalizar in h-prog.
    chChTreeview:TreeView4GL:TreeRefresh = true.
   
    apply "entry" to ChTreeview.
    
    RUN troca-label. 
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-livre  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-display"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-livre 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  /*
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).
  
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE troca-cor w-livre 
PROCEDURE troca-cor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN tt-display.cod_cta_ctbl:column-bgcolor IN BROWSE browse-3 = 18
           tt-display.descricao:column-bgcolor IN BROWSE browse-3 = 18.

    ASSIGN tt-display.tot-mes[1]:column-bgcolor IN BROWSE browse-3 = 17
           tt-display.tot-mes[3]:column-bgcolor IN BROWSE browse-3 = 17
           tt-display.tot-mes[5]:column-bgcolor IN BROWSE browse-3 = 17
           tt-display.tot-mes[7]:column-bgcolor IN BROWSE browse-3 = 17
           tt-display.tot-mes[9]:column-bgcolor IN BROWSE browse-3 = 17
           tt-display.tot-mes[11]:column-bgcolor IN BROWSE browse-3 = 17
           tt-display.tot-acum:column-bgcolor IN BROWSE browse-3 = 18.
    
    ASSIGN tt-display.real-mes[1]:column-bgcolor IN BROWSE browse-3 = 17
           tt-display.real-mes[3]:column-bgcolor IN BROWSE browse-3 = 17
           tt-display.real-mes[5]:column-bgcolor IN BROWSE browse-3 = 17
           tt-display.real-mes[7]:column-bgcolor IN BROWSE browse-3 = 17
           tt-display.real-mes[9]:column-bgcolor IN BROWSE browse-3 = 17
           tt-display.real-mes[11]:column-bgcolor IN BROWSE browse-3 = 17
           tt-display.real-acum:column-bgcolor IN BROWSE browse-3 = 18.
    
    ASSIGN tt-display.var-mes[1]:column-bgcolor IN BROWSE browse-3 = 17
           tt-display.var-mes[3]:column-bgcolor IN BROWSE browse-3 = 17
           tt-display.var-mes[5]:column-bgcolor IN BROWSE browse-3 = 17
           tt-display.var-mes[7]:column-bgcolor IN BROWSE browse-3 = 17
           tt-display.var-mes[9]:column-bgcolor IN BROWSE browse-3 = 17
           tt-display.var-mes[11]:column-bgcolor IN BROWSE browse-3 = 17
           tt-display.var-acum:column-bgcolor IN BROWSE browse-3 = 18.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE troca-label w-livre 
PROCEDURE troca-label :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN troca-visivel.


assign i-mes                                            = 0
       i-ano                                            = 0
       tt-display.descricao:label    IN BROWSE browse-3 = "Descri‡Æo"
       tt-display.descricao:width    IN BROWSE browse-3 = 36.

IF  INPUT FRAME {&FRAME-NAME} cb-mes[1] <> "" 
AND INPUT FRAME {&FRAME-NAME} cb-ano[1] <> "" THEN 
    ASSIGN i-mes[1]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-mes[1])
           i-ano[1]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-ano[1])
           tt-display.tot-mes[1]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.real-mes[1]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.var-mes[1]:WIDTH  IN BROWSE browse-3 = 6
           tt-display.tot-mes[1]:LABEL  IN BROWSE browse-3 = "Orc " + TRIM(cb-mes[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))   
           tt-display.real-mes[1]:LABEL IN BROWSE browse-3 = "Real " + TRIM(cb-mes[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.var-mes[1]:LABEL  IN BROWSE browse-3 = "%" + TRIM(cb-mes[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME})   + "/" + TRIM(substring(cb-ano[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2)). 
ELSE ASSIGN tt-display.tot-mes[1]:VISIBLE IN BROWSE browse-3 = NO
            tt-display.real-mes[1]:VISIBLE  IN BROWSE browse-3 = NO
            tt-display.var-mes[1]:VISIBLE  IN BROWSE browse-3 = NO.



IF  INPUT FRAME {&FRAME-NAME} cb-mes[2] <> "" 
AND INPUT FRAME {&FRAME-NAME} cb-ano[2] <> "" THEN 
    ASSIGN i-mes[2]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-mes[2])
           i-ano[2]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-ano[2])
           tt-display.tot-mes[2]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.real-mes[2]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.var-mes[2]:WIDTH  IN BROWSE browse-3 = 6
           tt-display.tot-mes[2]:LABEL  IN BROWSE browse-3 = "Orc " + TRIM(cb-mes[2]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[2]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.real-mes[2]:LABEL IN BROWSE browse-3 = "Real " + TRIM(cb-mes[2]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[2]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.var-mes[2]:LABEL  IN BROWSE browse-3 = "%" + TRIM(cb-mes[2]:SCREEN-VALUE IN FRAME {&FRAME-NAME})   + "/" + trim(substring(cb-ano[2]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2)).
ELSE ASSIGN tt-display.tot-mes[2]:VISIBLE IN BROWSE browse-3 = NO
            tt-display.real-mes[2]:VISIBLE  IN BROWSE browse-3 = NO
            tt-display.var-mes[2]:VISIBLE  IN BROWSE browse-3 = NO.

IF  INPUT FRAME {&FRAME-NAME} cb-mes[3] <> "" 
AND INPUT FRAME {&FRAME-NAME} cb-mes[3] <> "" THEN 
    ASSIGN i-mes[3]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-mes[3])
           i-ano[3]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-ano[3])
           tt-display.tot-mes[3]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.real-mes[3]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.var-mes[3]:WIDTH  IN BROWSE browse-3 = 6
           tt-display.tot-mes[3]:LABEL  IN BROWSE browse-3 = "Orc " + TRIM(cb-mes[3]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[3]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.real-mes[3]:LABEL IN BROWSE browse-3 = "Real " + TRIM(cb-mes[3]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[3]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.var-mes[3]:LABEL  IN BROWSE browse-3 = "%" + TRIM(cb-mes[3]:SCREEN-VALUE IN FRAME {&FRAME-NAME})   + "/" + trim(substring(cb-ano[3]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2)).
ELSE ASSIGN tt-display.tot-mes[3]:VISIBLE IN BROWSE browse-3 = NO
            tt-display.real-mes[3]:VISIBLE  IN BROWSE browse-3 = NO
            tt-display.var-mes[3]:VISIBLE  IN BROWSE browse-3 = NO.

IF  INPUT FRAME {&FRAME-NAME} cb-mes[4] <> "" 
AND INPUT FRAME {&FRAME-NAME} cb-ano[4] <> "" THEN 
    ASSIGN i-mes[4]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-mes[4])
           i-ano[4]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-ano[4])
           tt-display.tot-mes[4]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.real-mes[4]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.var-mes[4]:WIDTH  IN BROWSE browse-3 = 6
           tt-display.tot-mes[4]:LABEL  IN BROWSE browse-3 = "Orc " + TRIM(cb-mes[4]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[4]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.real-mes[4]:LABEL IN BROWSE browse-3 = "Real " + TRIM(cb-mes[4]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[4]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.var-mes[4]:LABEL  IN BROWSE browse-3 = "%" + TRIM(cb-mes[4]:SCREEN-VALUE IN FRAME {&FRAME-NAME})   + "/" + trim(substring(cb-ano[4]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2)).
ELSE ASSIGN tt-display.tot-mes[4]:VISIBLE IN BROWSE browse-3 = NO
            tt-display.real-mes[4]:VISIBLE  IN BROWSE browse-3 = NO
            tt-display.var-mes[4]:VISIBLE  IN BROWSE browse-3 = NO.

IF  INPUT FRAME {&FRAME-NAME} cb-mes[5] <> "" 
AND INPUT FRAME {&FRAME-NAME} cb-ano[5] <> "" THEN 
    ASSIGN i-mes[5]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-mes[5])
           i-ano[5]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-ano[5])
           tt-display.tot-mes[5]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.real-mes[5]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.var-mes[5]:WIDTH  IN BROWSE browse-3 = 6
           tt-display.tot-mes[5]:LABEL  IN BROWSE browse-3 = "Orc " + TRIM(cb-mes[5]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[5]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.real-mes[5]:LABEL IN BROWSE browse-3 = "Real " + TRIM(cb-mes[5]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[5]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.var-mes[5]:LABEL  IN BROWSE browse-3 = "%" + TRIM(cb-mes[5]:SCREEN-VALUE IN FRAME {&FRAME-NAME})   + "/" + trim(substring(cb-ano[5]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2)).
ELSE ASSIGN tt-display.tot-mes[5]:VISIBLE IN BROWSE browse-3 = NO
            tt-display.real-mes[5]:VISIBLE  IN BROWSE browse-3 = NO
            tt-display.var-mes[5]:VISIBLE  IN BROWSE browse-3 = NO.

IF  INPUT FRAME {&FRAME-NAME} cb-mes[6] <> "" 
AND INPUT FRAME {&FRAME-NAME} cb-ano[6] <> "" THEN 
    ASSIGN i-mes[6]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-mes[6])
           i-ano[6]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-ano[6])
           tt-display.tot-mes[6]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.real-mes[6]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.var-mes[6]:WIDTH  IN BROWSE browse-3 = 6
           tt-display.tot-mes[6]:LABEL  IN BROWSE browse-3 = "Orc " + TRIM(cb-mes[6]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[6]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.real-mes[6]:LABEL IN BROWSE browse-3 = "Real " + TRIM(cb-mes[6]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[6]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.var-mes[6]:LABEL  IN BROWSE browse-3 = "%" + TRIM(cb-mes[6]:SCREEN-VALUE IN FRAME {&FRAME-NAME})   + "/" + trim(substring(cb-ano[6]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2)).
ELSE ASSIGN tt-display.tot-mes[6]:VISIBLE IN BROWSE browse-3 = NO
            tt-display.real-mes[6]:VISIBLE  IN BROWSE browse-3 = NO
            tt-display.var-mes[6]:VISIBLE  IN BROWSE browse-3 = NO.

IF  INPUT FRAME {&FRAME-NAME} cb-mes[7] <> "" 
AND INPUT FRAME {&FRAME-NAME} cb-ano[7] <> "" THEN 
    ASSIGN i-mes[7]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-mes[7])
           i-ano[7]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-ano[7])
           tt-display.tot-mes[7]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.real-mes[7]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.var-mes[7]:WIDTH  IN BROWSE browse-3 = 6
           tt-display.tot-mes[7]:LABEL  IN BROWSE browse-3 = "Orc " + TRIM(cb-mes[7]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[7]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.real-mes[7]:LABEL IN BROWSE browse-3 = "Real " + TRIM(cb-mes[7]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[7]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.var-mes[7]:LABEL  IN BROWSE browse-3 = "%" + TRIM(cb-mes[7]:SCREEN-VALUE IN FRAME {&FRAME-NAME})   + "/" + trim(substring(cb-ano[7]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2)).
ELSE ASSIGN tt-display.tot-mes[7]:VISIBLE IN BROWSE browse-3 = NO
            tt-display.real-mes[7]:VISIBLE  IN BROWSE browse-3 = NO
            tt-display.var-mes[7]:VISIBLE  IN BROWSE browse-3 = NO.

IF  INPUT FRAME {&FRAME-NAME} cb-mes[8] <> "" 
AND INPUT FRAME {&FRAME-NAME} cb-ano[8] <> "" THEN 
    ASSIGN i-mes[8]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-mes[8])
           i-ano[8]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-ano[8])
           tt-display.tot-mes[8]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.real-mes[8]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.var-mes[8]:WIDTH  IN BROWSE browse-3 = 6
           tt-display.tot-mes[8]:LABEL  IN BROWSE browse-3 = "Orc " + TRIM(cb-mes[8]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[8]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.real-mes[8]:LABEL IN BROWSE browse-3 = "Real " + TRIM(cb-mes[8]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[8]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))           
           tt-display.var-mes[8]:LABEL  IN BROWSE browse-3 = "%" + TRIM(cb-mes[8]:SCREEN-VALUE IN FRAME {&FRAME-NAME})   + "/" + trim(substring(cb-ano[8]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2)).
ELSE ASSIGN tt-display.tot-mes[8]:VISIBLE IN BROWSE browse-3 = NO
            tt-display.real-mes[8]:VISIBLE  IN BROWSE browse-3 = NO
            tt-display.var-mes[8]:VISIBLE  IN BROWSE browse-3 = NO.

IF  INPUT FRAME {&FRAME-NAME} cb-mes[9] <> "" 
AND INPUT FRAME {&FRAME-NAME} cb-ano[9] <> "" THEN 
    ASSIGN i-mes[9]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-mes[9])
           i-ano[9]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-ano[9])
           tt-display.tot-mes[9]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.real-mes[9]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.var-mes[9]:WIDTH  IN BROWSE browse-3 = 6
           tt-display.tot-mes[9]:LABEL  IN BROWSE browse-3 = "Orc " + TRIM(cb-mes[9]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[9]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.real-mes[9]:LABEL IN BROWSE browse-3 = "Real " + TRIM(cb-mes[9]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[9]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.var-mes[9]:LABEL  IN BROWSE browse-3 = "%" + TRIM(cb-mes[9]:SCREEN-VALUE IN FRAME {&FRAME-NAME})   + "/" + trim(substring(cb-ano[9]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2)).
ELSE ASSIGN tt-display.tot-mes[9]:VISIBLE IN BROWSE browse-3 = NO
            tt-display.real-mes[9]:VISIBLE  IN BROWSE browse-3 = NO
            tt-display.var-mes[9]:VISIBLE  IN BROWSE browse-3 = NO.

IF  INPUT FRAME {&FRAME-NAME} cb-mes[10] <> "" 
AND INPUT FRAME {&FRAME-NAME} cb-ano[10] <> "" THEN 
    ASSIGN i-mes[10]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-mes[10])
           i-ano[10]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-ano[10])
           tt-display.tot-mes[10]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.real-mes[10]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.var-mes[10]:WIDTH  IN BROWSE browse-3 = 6
           tt-display.tot-mes[10]:LABEL  IN BROWSE browse-3 = "Orc " + TRIM(cb-mes[10]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[10]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.real-mes[10]:LABEL IN BROWSE browse-3 = "Real " + TRIM(cb-mes[10]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[10]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.var-mes[10]:LABEL  IN BROWSE browse-3 = "%" + TRIM(cb-mes[10]:SCREEN-VALUE IN FRAME {&FRAME-NAME})   + "/" + trim(substring(cb-ano[10]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2)).
ELSE ASSIGN tt-display.tot-mes[10]:VISIBLE IN BROWSE browse-3 = NO
            tt-display.real-mes[10]:VISIBLE  IN BROWSE browse-3 = NO
            tt-display.var-mes[10]:VISIBLE  IN BROWSE browse-3 = NO.

IF  INPUT FRAME {&FRAME-NAME} cb-mes[11] <> "" 
AND INPUT FRAME {&FRAME-NAME} cb-ano[11] <> "" THEN 
    ASSIGN i-mes[11]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-mes[11])
           i-ano[11]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-ano[11])
           tt-display.tot-mes[11]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.real-mes[11]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.var-mes[11]:WIDTH  IN BROWSE browse-3 = 6
           tt-display.tot-mes[11]:LABEL  IN BROWSE browse-3 = "Orc " + TRIM(cb-mes[11]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[11]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.real-mes[11]:LABEL IN BROWSE browse-3 = "Real " + TRIM(cb-mes[11]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[11]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.var-mes[11]:LABEL  IN BROWSE browse-3 = "%" + TRIM(cb-mes[11]:SCREEN-VALUE IN FRAME {&FRAME-NAME})   + "/" + trim(substring(cb-ano[11]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2)).
ELSE ASSIGN tt-display.tot-mes[11]:VISIBLE IN BROWSE browse-3 = NO
            tt-display.real-mes[11]:VISIBLE  IN BROWSE browse-3 = NO
            tt-display.var-mes[11]:VISIBLE  IN BROWSE browse-3 = NO.

IF  INPUT FRAME {&FRAME-NAME} cb-mes[12] <> "" 
AND INPUT FRAME {&FRAME-NAME} cb-ano[12] <> "" THEN 
    ASSIGN i-mes[12]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-mes[12])
           i-ano[12]                                        = INT(INPUT FRAME {&FRAME-NAME} cb-ano[12])
           tt-display.tot-mes[12]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.real-mes[12]:WIDTH  IN BROWSE browse-3 = 13
           tt-display.var-mes[12]:WIDTH  IN BROWSE browse-3 = 6
           tt-display.tot-mes[12]:LABEL  IN BROWSE browse-3 = "Orc " + TRIM(cb-mes[12]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[12]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.real-mes[12]:LABEL IN BROWSE browse-3 = "Real " + TRIM(cb-mes[12]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[12]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2))
           tt-display.var-mes[12]:LABEL  IN BROWSE browse-3 = "%"   + TRIM(cb-mes[12]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + "/" + trim(substring(cb-ano[12]:SCREEN-VALUE IN FRAME {&FRAME-NAME},3,2)).
ELSE ASSIGN tt-display.tot-mes[12]:VISIBLE IN BROWSE browse-3 = NO
            tt-display.real-mes[12]:VISIBLE  IN BROWSE browse-3 = NO
            tt-display.var-mes[12]:VISIBLE  IN BROWSE browse-3 = NO.







END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE troca-visivel w-livre 
PROCEDURE troca-visivel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN troca-cor.

IF  INPUT FRAME {&FRAME-NAME} l-orcado = NO THEN
    ASSIGN tt-display.tot-mes[1]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.tot-mes[2]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.tot-mes[3]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.tot-mes[4]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.tot-mes[5]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.tot-mes[6]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.tot-mes[7]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.tot-mes[8]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.tot-mes[9]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.tot-mes[10]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.tot-mes[11]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.tot-mes[12]:VISIBLE IN BROWSE browse-3 = NO.
    
IF  INPUT FRAME {&FRAME-NAME} l-realizado = NO THEN
    ASSIGN tt-display.real-mes[1]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.real-mes[2]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.real-mes[3]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.real-mes[4]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.real-mes[5]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.real-mes[6]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.real-mes[7]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.real-mes[8]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.real-mes[9]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.real-mes[10]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.real-mes[11]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.real-mes[12]:VISIBLE IN BROWSE browse-3 = NO.
    
IF  INPUT FRAME {&FRAME-NAME} l-variacao = NO THEN
    ASSIGN tt-display.var-mes[1]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.var-mes[2]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.var-mes[3]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.var-mes[4]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.var-mes[5]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.var-mes[6]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.var-mes[7]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.var-mes[8]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.var-mes[9]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.var-mes[10]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.var-mes[11]:VISIBLE IN BROWSE browse-3 = NO
           tt-display.var-mes[12]:VISIBLE IN BROWSE browse-3 = NO.
    

IF  INPUT FRAME {&FRAME-NAME} l-orcado = yes THEN
    ASSIGN tt-display.tot-mes[1]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.tot-mes[2]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.tot-mes[3]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.tot-mes[4]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.tot-mes[5]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.tot-mes[6]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.tot-mes[7]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.tot-mes[8]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.tot-mes[9]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.tot-mes[10]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.tot-mes[11]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.tot-mes[12]:VISIBLE IN BROWSE browse-3 = yes.
    
IF  INPUT FRAME {&FRAME-NAME} l-realizado = yes THEN
    ASSIGN tt-display.real-mes[1]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.real-mes[2]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.real-mes[3]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.real-mes[4]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.real-mes[5]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.real-mes[6]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.real-mes[7]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.real-mes[8]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.real-mes[9]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.real-mes[10]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.real-mes[11]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.real-mes[12]:VISIBLE IN BROWSE browse-3 = yes.
    
IF  INPUT FRAME {&FRAME-NAME} l-variacao = yes THEN
    ASSIGN tt-display.var-mes[1]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.var-mes[2]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.var-mes[3]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.var-mes[4]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.var-mes[5]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.var-mes[6]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.var-mes[7]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.var-mes[8]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.var-mes[9]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.var-mes[10]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.var-mes[11]:VISIBLE IN BROWSE browse-3 = yes
           tt-display.var-mes[12]:VISIBLE IN BROWSE browse-3 = yes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

