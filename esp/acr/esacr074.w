&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESACR074 2.00.00.001}  /*** 010005 ***/
{cdp/cdcfgdis.i} /*  definiá∆o e prÇ-processadores distribuiá∆o */ 
{include/i_dbvers.i}
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

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

/* Preprocessadores do Template de Relat¢rio                            */
/* Obs: Retirar o valor do preprocessador para as p†ginas que n∆o existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA 
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGDIG f-pg-dig
&GLOBAL-DEFINE PGIMP f-pg-imp
/* Include Com as Vari†veis Globais */
{utp/ut-glob.i}
  
/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char
    field usuario          as char
    field data-exec        as date
    field hora-exec        as integer
    field cod-emitente     as integer
    field estab-ini        as char
    field estab-fim        as char
    field vencto-ini       as DATE
    field vencto-fim       as DATE
    field vencto-novo      as DATE
    FIELD matriz           AS LOG
    field imprime-param    as log.

define temp-table tt-digita no-undo
    FIELD v_log_selec          AS LOG                         LABEL "Selec" FORMAT "Sim/N∆o" INITIAL NO
    FIELD v_cod_estab          AS CHAR FORMAT "x(04)"         LABEL "Est"
    FIELD v_cdn_cliente        AS INT                         LABEL "Cliente"
    FIELD v_cod_espec          AS CHAR FORMAT "x(03)"         LABEL "Esp"
    FIELD v_cod_ser            AS CHAR FORMAT "x(03)"         LABEL "Ser"
    FIELD v_cod_tit_acr        AS CHAR FORMAT "x(16)"         LABEL "Titulo"
    FIELD v_cod_parc           AS CHAR FORMAT "x(02)"         LABEL "Parc"
    FIELD v_dat_emis           AS DATE FORMAT "99/99/9999"    LABEL "Emiss∆o"
    FIELD v_dat_vcto           AS DATE FORMAT "99/99/9999"    LABEL "Vencto"
    FIELD v_val_orig           AS DEC  FORMAT "->,>>>,>>9.99" LABEL "Vl Original"
    FIELD v_val_sdo            AS DEC  FORMAT "->,>>>,>>9.99" LABEL "Vl Saldo"
    FIELD v_nom_abrev          AS CHAR FORMAT "x(15)"         LABEL "Nome Abrev"
    FIELD v_moeda_acr          AS CHAR                        LABEL "Moeda"
    FIELD v_num_id_tit_acr     AS INT.

DEF TEMP-TABLE tt-matriz-cliente NO-UNDO 
    FIELD cod-emitente LIKE emitente.cod-emitente.

DEF BUFFER b-tt-digita FOR tt-digita.
DEF BUFFER b-emitente  FOR emitente.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita no-undo
   field raw-digita      as raw.
                    
DEF NEW GLOBAL SHARED VAR v_rec_cliente AS RECID NO-UNDO.

/* Local Variable Definitions ---                                       */

def var v_dat_vencto       as date    format "99/99/9999".
DEF VAR l-ok AS LOG FORMAT "Sim/N∆o" NO-UNDO.
DEF VAR c-terminal AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define BROWSE-NAME br-digita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE br-digita                                     */
&Scoped-define FIELDS-IN-QUERY-br-digita v_log_selec v_cod_estab v_cod_espec v_cod_ser v_cod_tit_acr v_cod_parc v_cdn_cliente v_nom_abrev v_dat_emis v_dat_vcto v_val_orig v_val_sdo v_moeda_acr   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-digita   
&Scoped-define SELF-NAME br-digita
&Scoped-define QUERY-STRING-br-digita FOR EACH tt-digita
&Scoped-define OPEN-QUERY-br-digita OPEN QUERY br-digita FOR EACH tt-digita.
&Scoped-define TABLES-IN-QUERY-br-digita tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-br-digita tt-digita


/* Definitions for FRAME f-pg-dig                                       */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-pg-dig ~
    ~{&OPEN-QUERY-br-digita}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-digita btCarrega btMarca btDesmarca 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCarrega 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25 TOOLTIP "Carrega T°tulos"
     FONT 4.

DEFINE BUTTON btDesmarca 
     IMAGE-UP FILE "C:/OpenSource 12.1.14/ems5/IMAGE/im-ran_n.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25 TOOLTIP "Desmarca todos os t°tulos"
     FONT 4.

DEFINE BUTTON btMarca 
     IMAGE-UP FILE "C:/OpenSource 12.1.14/ems5/IMAGE/im-ran_a.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25 TOOLTIP "Seleciona todos os t°tulos"
     FONT 4.

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

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63 NO-UNDO.

DEFINE VARIABLE text-modo-2 AS CHARACTER FORMAT "X(256)":U INITIAL "ParÉmetros de Impress∆o" 
      VIEW-AS TEXT 
     SIZE 25 BY .63 NO-UNDO.

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

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE tg-imprime-param AS LOGICAL INITIAL yes 
     LABEL "&Imprimir ParÉmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 39 BY .83 NO-UNDO.

DEFINE VARIABLE c-nome-cliente AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE da-venc-novo AS DATE FORMAT "99/99/9999":U 
     LABEL "Nova Data" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 TOOLTIP "Informe a nova data de vencimento" NO-UNDO.

DEFINE VARIABLE i-cliente AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-param
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 10.5.

DEFINE VARIABLE tg-matriz AS LOGICAL INITIAL no 
     LABEL "Considera Matriz ?" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 TOOLTIP "Considera toda estrtura desta matriz ?" NO-UNDO.

DEFINE VARIABLE c-estabelec-fim AS CHARACTER FORMAT "X(256)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-estabelec-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE da-venc-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88 NO-UNDO.

DEFINE VARIABLE da-venc-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63.72 BY 8.92.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE IMAGE im-pg-dig
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-imp
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-par
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
     SIZE 79 BY 11.38
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0    
     SIZE .43 BY 11.21
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0    
     SIZE .43 BY 11.17
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 15 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-digita FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-digita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-digita C-Win _FREEFORM
  QUERY br-digita DISPLAY
      v_log_selec
    v_cod_estab
    v_cod_espec
    v_cod_ser
    v_cod_tit_acr
    v_cod_parc
    v_cdn_cliente
    v_nom_abrev
    v_dat_emis
    v_dat_vcto
    v_val_orig
    v_val_sdo
    v_moeda_acr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 70.86 BY 10.58
         BGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 2.38 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     bt-config-impr AT ROW 3.58 COL 43.29 HELP
          "Configuraá∆o da impressora"
     bt-arquivo AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     c-arquivo AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 5.75 COL 3 HELP
          "Modo de Execuá∆o" NO-LABEL
     tg-imprime-param AT ROW 8.54 COL 3
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     text-modo-2 AT ROW 7.79 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-10 AT ROW 8.08 COL 2.14
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.65
         SIZE 77 BY 11.

DEFINE FRAME f-relat
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execuá∆o do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Fechar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder AT ROW 2.5 COL 2
     rt-folder-left AT ROW 2.54 COL 2.14
     RECT-1 AT ROW 14.29 COL 2
     RECT-6 AT ROW 13.75 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     im-pg-dig AT ROW 1.5 COL 33.57
     im-pg-imp AT ROW 1.5 COL 49.29
     im-pg-par AT ROW 1.5 COL 17.86
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-dig
     br-digita AT ROW 1.17 COL 1.14
     btCarrega AT ROW 1.5 COL 73 HELP
          "Confirma alteraá‰es"
     btMarca AT ROW 3.25 COL 73 HELP
          "Confirma alteraá‰es" WIDGET-ID 2
     btDesmarca AT ROW 5 COL 73 HELP
          "Confirma alteraá‰es" WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.65
         SIZE 77 BY 11.

DEFINE FRAME f-pg-par
     i-cliente AT ROW 3 COL 21 COLON-ALIGNED WIDGET-ID 2
     c-nome-cliente AT ROW 3 COL 33.29 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     tg-matriz AT ROW 4.5 COL 13 WIDGET-ID 4
     da-venc-novo AT ROW 6.25 COL 21 COLON-ALIGNED HELP
          "Informe a nova data de vencimento" WIDGET-ID 8
     rt-param AT ROW 1.25 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.65
         SIZE 77 BY 11.

DEFINE FRAME f-pg-sel
     c-estabelec-ini AT ROW 4.25 COL 33 COLON-ALIGNED
     c-estabelec-fim AT ROW 4.25 COL 48.14 COLON-ALIGNED NO-LABEL
     da-venc-ini AT ROW 5.25 COL 25.57 COLON-ALIGNED
     da-venc-fim AT ROW 5.25 COL 48.14 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 4.25 COL 40.43
     IMAGE-2 AT ROW 4.25 COL 47
     IMAGE-7 AT ROW 5.25 COL 40.43
     IMAGE-8 AT ROW 5.25 COL 47
     RECT-11 AT ROW 2 COL 7
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.65
         SIZE 77 BY 11.


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
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Alteraá∆o Autom†tica Vencimentos ACR"
         HEIGHT             = 15
         WIDTH              = 81.14
         MAX-HEIGHT         = 22.33
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22.33
         VIRTUAL-WIDTH      = 114.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-pg-dig
   FRAME-NAME                                                           */
/* BROWSE-TAB br-digita 1 f-pg-dig */
/* SETTINGS FOR FRAME f-pg-imp
                                                                        */
/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Execuá∆o".

/* SETTINGS FOR FILL-IN text-modo-2 IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-modo-2:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "ParÉmetros de Impress∆o".

/* SETTINGS FOR FRAME f-pg-par
                                                                        */
/* SETTINGS FOR FILL-IN c-nome-cliente IN FRAME f-pg-par
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-digita
/* Query rebuild information for BROWSE br-digita
     _START_FREEFORM
OPEN QUERY br-digita FOR EACH tt-digita.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-digita */
&ANALYZE-RESUME

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

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Alteraá∆o Autom†tica Vencimentos ACR */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Alteraá∆o Autom†tica Vencimentos ACR */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-digita
&Scoped-define SELF-NAME br-digita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita C-Win
ON MOUSE-SELECT-DBLCLICK OF br-digita IN FRAME f-pg-dig
DO:
    DEF VAR v_rec_control AS RECID NO-UNDO.
    DEF VAR v_val_sdo     AS DEC   NO-UNDO.
    DEF VAR v_log_status  AS LOG   NO-UNDO.

    IF  AVAIL tt-digita THEN DO:
        ASSIGN tt-digita.v_log_selec = NOT(tt-digita.v_log_selec).
        ASSIGN v_rec_control = RECID(tt-digita).

        IF br-digita:REFRESH() THEN.

        IF  v_rec_control <> ? THEN 
            REPOSITION br-digita TO RECID v_rec_control.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda C-Win
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo C-Win
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    {include/i-rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar C-Win
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Cancelar */
DO:
   apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-config-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr C-Win
ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:
   {include/i-rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar C-Win
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
   do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define SELF-NAME btCarrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCarrega C-Win
ON CHOOSE OF btCarrega IN FRAME f-pg-dig /* Save */
DO:
    EMPTY TEMP-TABLE tt-digita.

    FOR EACH estabelecimento
        WHERE estabelecimento.cod_empresa  = v_cod_empres_usuar
        AND   estabelecimento.cod_estab   >= c-estabelec-ini:screen-value in frame f-pg-sel
        AND   estabelecimento.cod_estab   <= c-estabelec-fim:screen-value in frame f-pg-sel NO-LOCK:

        DO  v_dat_vencto = date(da-venc-ini:screen-value in frame f-pg-sel) TO date(da-venc-fim:screen-value in frame f-pg-sel):
    
            FOR EACH espec_docto_financ_acr NO-LOCK:
    
                FIND FIRST espec_docto
                    WHERE espec_docto.cod_espec_docto     = espec_docto_financ_acr.cod_espec_docto 
                    AND   espec_docto.ind_tip_espec_docto = "Normal" NO-LOCK NO-ERROR.
    
                IF  NOT AVAIL espec_docto THEN 
                    NEXT.
    
                FOR EACH tit_acr
                    WHERE tit_acr.cod_estab          = estabelecimento.cod_estab
                    AND   tit_acr.cod_espec_docto    = espec_docto.cod_espec_docto
                    AND   tit_acr.log_sdo_tit_acr    = YES 
                    AND   tit_acr.dat_vencto_tit_acr = v_dat_vencto NO-LOCK
                       BY tit_acr.dat_vencto_tit_acr
                       BY tit_acr.cod_tit_acr:
            
                    FIND FIRST tt-matriz-cliente
                        WHERE tt-matriz-cliente.cod-emit = tit_acr.cdn_cliente NO-LOCK NO-ERROR.

                    IF  NOT AVAIL tt-matriz-cliente THEN
                        NEXT.

                    FIND tt-digita
                        WHERE tt-digita.v_cod_estab   = tit_acr.cod_estab   
                        AND   tt-digita.v_cod_espec   = tit_acr.cod_espec   
                        AND   tt-digita.v_cod_ser     = tit_acr.cod_ser     
                        AND   tt-digita.v_cod_tit_acr = tit_acr.cod_tit_acr  
                        AND   tt-digita.v_cod_parc    = tit_acr.cod_parcela NO-LOCK NO-ERROR.
                                                       
                    IF  AVAIL tt-digita THEN 
                        NEXT.
        
                    CREATE tt-digita.
                    ASSIGN tt-digita.v_log_selec      = NO
                           tt-digita.v_cod_estab      = tit_acr.cod_estab
                           tt-digita.v_cdn_cliente    = tit_acr.cdn_cliente
                           tt-digita.v_cod_espec      = tit_acr.cod_espec
                           tt-digita.v_cod_ser        = tit_acr.cod_ser
                           tt-digita.v_cod_tit_acr    = tit_acr.cod_tit_acr
                           tt-digita.v_cod_parc       = tit_acr.cod_parcela
                           tt-digita.v_dat_emis       = tit_acr.dat_emis_docto
                           tt-digita.v_dat_vcto       = tit_acr.dat_vencto_tit_acr
                           tt-digita.v_val_orig       = tit_acr.val_origin
                           tt-digita.v_val_sdo        = tit_acr.val_sdo_tit_acr
                           tt-digita.v_moeda_acr      = tit_acr.cod_indic_econ
                           tt-digita.v_nom_abrev      = tit_acr.nom_abrev
                           tt-digita.v_num_id_tit_acr = tit_acr.num_id_tit_acr.
                END.
            END.
        END.
    END.

    {&OPEN-QUERY-br-digita}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDesmarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesmarca C-Win
ON CHOOSE OF btDesmarca IN FRAME f-pg-dig /* Save */
DO:
    FOR EACH tt-digita
        WHERE tt-digita.v_log_selec = YES EXCLUSIVE-LOCK:
        ASSIGN tt-digita.v_log_selec = NO.
    END.

    OPEN QUERY br-digita 
        FOR EACH tt-digita NO-LOCK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btMarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMarca C-Win
ON CHOOSE OF btMarca IN FRAME f-pg-dig /* Save */
DO:
    FOR EACH tt-digita
        WHERE tt-digita.v_log_selec = NO EXCLUSIVE-LOCK:
        ASSIGN tt-digita.v_log_selec = YES.
    END.

    OPEN QUERY br-digita 
        FOR EACH tt-digita NO-LOCK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME c-estabelec-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estabelec-ini C-Win
ON ENTRY OF c-estabelec-ini IN FRAME f-pg-sel /* Estabelecimento */
DO:
    IF  INPUT FRAME f-pg-sel da-venc-ini = ? THEN
        ASSIGN da-venc-ini:SCREEN-VALUE IN FRAME f-pg-sel = STRING(today)
               da-venc-fim:SCREEN-VALUE IN FRAME f-pg-sel = STRING(today).  

    IF  INPUT FRAME f-pg-par da-venc-novo = ? THEN
        ASSIGN da-venc-novo:SCREEN-VALUE IN FRAME f-pg-par = STRING(today).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estabelec-ini C-Win
ON LEAVE OF c-estabelec-ini IN FRAME f-pg-sel /* Estabelecimento */
DO:  
    IF  INPUT FRAME f-pg-sel da-venc-ini = ? THEN
        ASSIGN da-venc-ini:SCREEN-VALUE  IN FRAME f-pg-sel = STRING(today)
               da-venc-fim:SCREEN-VALUE  IN FRAME f-pg-sel = STRING(today).

    IF  INPUT FRAME f-pg-par da-venc-novo = ? THEN
        ASSIGN da-venc-novo:SCREEN-VALUE IN FRAME f-pg-par = STRING(today).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME i-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cliente C-Win
ON F5 OF i-cliente IN FRAME f-pg-par /* Cliente */
DO:
    IF SEARCH("prgint/utb/utb107ka.r":U) = ? AND
       SEARCH("prgint/utb/utb107ka.p":U) = ? THEN DO:
        MESSAGE "Programa execut†vel n∆o foi encontrado: prgint/utb/utb107ka.p.":U
            VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Erro":U.

        RETURN NO-APPLY.
    END.
    ELSE
        RUN prgint/utb/utb107ka.p.

    IF  v_rec_cliente <> ? THEN DO:
        FIND FIRST emscad.cliente
            WHERE RECID(emscad.cliente) = v_rec_cliente NO-LOCK NO-ERROR.

        IF  AVAIL emscad.cliente THEN DO:
            ASSIGN i-cliente = emscad.cliente.cdn_cliente.

            DISP i-cliente WITH FRAME f-pg-par.
        END.
    END.

    APPLY "LEAVE":U TO i-cliente IN FRAME f-pg-par.
    APPLY "ENTRY":U TO i-cliente IN FRAME f-pg-par.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cliente C-Win
ON LEAVE OF i-cliente IN FRAME f-pg-par /* Cliente */
DO:
    FIND FIRST emitente
        WHERE emitente.cod-emitente = INPUT FRAME f-pg-par i-cliente
        AND   emitente.identific <> 2 NO-LOCK NO-ERROR.

    IF  AVAIL emitente THEN DO:
        ASSIGN c-nome-cliente:SCREEN-VALUE IN FRAME f-pg-par = emitente.nome-abrev.

        EMPTY TEMP-TABLE tt-matriz-cliente.

        IF  INPUT FRAME f-pg-par tg-matriz = YES THEN DO:
            FOR EACH b-emitente
                WHERE b-emitente.nome-matriz = emitente.nome-matriz 
                AND   b-emitente.identific  <> 2 NO-LOCK:
                CREATE tt-matriz-cliente.
                ASSIGN tt-matriz-cliente.cod-emitente = b-emitente.cod-emitente.
            END.
        END.
        ELSE DO:
            CREATE tt-matriz-cliente.
            ASSIGN tt-matriz-cliente.cod-emitente = emitente.cod-emitente.
        END.
    END.
    ELSE DO:
        MESSAGE "Cliente informado n∆o cadastrado !" VIEW-AS ALERT-BOX ERROR.
        ASSIGN c-nome-cliente:SCREEN-VALUE IN FRAME f-pg-par = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cliente C-Win
ON MOUSE-SELECT-DBLCLICK OF i-cliente IN FRAME f-pg-par /* Cliente */
DO:
    IF SEARCH("prgint/utb/utb107ka.r":U) = ? AND
       SEARCH("prgint/utb/utb107ka.p":U) = ? THEN DO:
        MESSAGE "Programa execut†vel n∆o foi encontrado: prgint/utb/utb107ka.p.":U
            VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Erro":U.

        RETURN NO-APPLY.
    END.
    ELSE
        RUN prgint/utb/utb107ka.p.

    IF  v_rec_cliente <> ? THEN DO:
        FIND FIRST emscad.cliente
            WHERE RECID(emscad.cliente) = v_rec_cliente NO-LOCK NO-ERROR.

        IF  AVAIL emscad.cliente THEN DO:
            ASSIGN i-cliente = emscad.cliente.cdn_cliente.

            DISP i-cliente WITH FRAME f-pg-par.
        END.
    END.

    APPLY "LEAVE":U TO i-cliente IN FRAME f-pg-par.
    APPLY "ENTRY":U TO i-cliente IN FRAME f-pg-par.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-dig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-dig C-Win
ON MOUSE-SELECT-CLICK OF im-pg-dig IN FRAME f-relat
DO:
   run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-imp C-Win
ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-par
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-par C-Win
ON MOUSE-SELECT-CLICK OF im-pg-par IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel C-Win
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino C-Win
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp
DO:
do  with frame f-pg-imp:
    case self:screen-value:
        when "1" then do:
            assign c-arquivo:sensitive    = no
                   bt-arquivo:visible     = no
                   bt-config-impr:visible = yes.
        end.
        when "2" then do:
            assign c-arquivo:sensitive     = yes
                   bt-arquivo:visible      = yes
                   bt-config-impr:visible  = no.
        end.
        when "3" then do:
            assign c-arquivo:sensitive     = no
                   bt-arquivo:visible      = no
                   bt-config-impr:visible  = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao C-Win
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME tg-matriz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-matriz C-Win
ON VALUE-CHANGED OF tg-matriz IN FRAME f-pg-par /* Considera Matriz ? */
DO:
    FIND FIRST emitente
        WHERE emitente.cod-emitente = INPUT FRAME f-pg-par i-cliente
        AND   emitente.identific <> 2 NO-LOCK NO-ERROR.

    IF  AVAIL emitente THEN DO:
        ASSIGN c-nome-cliente:SCREEN-VALUE IN FRAME f-pg-par = emitente.nome-abrev.

        EMPTY TEMP-TABLE tt-matriz-cliente.

        IF  INPUT FRAME f-pg-par tg-matriz = YES THEN DO:
            FOR EACH b-emitente
                WHERE b-emitente.nome-matriz = emitente.nome-matriz 
                AND   b-emitente.identific  <> 2 NO-LOCK:
                CREATE tt-matriz-cliente.
                ASSIGN tt-matriz-cliente.cod-emitente = b-emitente.cod-emitente.
            END.
        END.
        ELSE DO:
            CREATE tt-matriz-cliente.
            ASSIGN tt-matriz-cliente.cod-emitente = emitente.cod-emitente.
        END.
    END.
    ELSE DO:
        MESSAGE "Cliente informado n∆o cadastrado !" VIEW-AS ALERT-BOX ERROR.
        ASSIGN c-nome-cliente:SCREEN-VALUE IN FRAME f-pg-par = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-dig
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "ESACR074" "2.00.00.001"}

/* inicializaá‰es do template de relat¢rio */
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

    IF i-cliente:load-mouse-pointer('image/lupa.cur') IN FRAME f-pg-par then.

    RUN enable_UI.
  
    {include/i-rpmbl.i}

    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects C-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available C-Win  _ADM-ROW-AVAILABLE
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
  ENABLE im-pg-dig im-pg-imp im-pg-par im-pg-sel bt-executar bt-cancelar 
         bt-ajuda 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  ENABLE br-digita btCarrega btMarca btDesmarca 
      WITH FRAME f-pg-dig IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-dig}
  DISPLAY rs-destino c-arquivo rs-execucao tg-imprime-param 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  ENABLE RECT-10 RECT-7 RECT-9 rs-destino bt-config-impr bt-arquivo c-arquivo 
         rs-execucao tg-imprime-param 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  DISPLAY i-cliente c-nome-cliente tg-matriz da-venc-novo 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  ENABLE rt-param i-cliente tg-matriz da-venc-novo 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  DISPLAY c-estabelec-ini c-estabelec-fim da-venc-ini da-venc-fim 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  ENABLE IMAGE-1 IMAGE-2 IMAGE-7 IMAGE-8 RECT-11 c-estabelec-ini 
         c-estabelec-fim da-venc-ini da-venc-fim 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit C-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar C-Win 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var r-tt-digita as rowid no-undo.

    do on error undo, return error 
       on stop  undo, return error:
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
        
        /*:T Coloque aqui as validaá‰es da p†gina de Digitaá∆o, lembrando que elas devem
           apresentar uma mensagem de erro cadastrada, posicionar nesta p†gina e colocar
           o focus no campo com problemas */
        /*browse br-digita:SET-REPOSITIONED-ROW (browse br-digita:DOWN, "ALWAYS":U).*/
        
        FIND FIRST tt-digita
            WHERE tt-digita.v_log_selec = YES NO-LOCK NO-ERROR.

        IF  NOT AVAIL tt-digita THEN DO:
            run utp/ut-msgs.p (input "show":U, 
                               input 17006, 
                               input "Nenhum t°tulo foi selecionado !").

            apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
            apply "ENTRY":U to btCarrega in frame f-pg-dig.
            return error.
        END.
        
        /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
           apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
           problemas e colocar o focus no campo com problemas */
        
        IF  INPUT FRAME f-pg-sel c-estabelec-fim < INPUT FRAME f-pg-sel c-estabelec-ini THEN DO:
            run utp/ut-msgs.p (input "show":U, 
                               input 17006, 
                               input "Estabelecimento final n∆o pode ser menor que o estabelecimento inicial !").

            apply "MOUSE-SELECT-CLICK":U to im-pg-sel in frame f-relat.
            apply "ENTRY":U to c-estabelec-ini in frame f-pg-sel.
            return error.
        END.

        IF  INPUT FRAME f-pg-sel da-venc-fim < INPUT FRAME f-pg-sel da-venc-ini THEN DO:
            run utp/ut-msgs.p (input "show":U, 
                               input 17006, 
                               input "Data de vencimento final n∆o pode ser menor que a data de vencimento inicial !").

            apply "MOUSE-SELECT-CLICK":U to im-pg-sel in frame f-relat.
            apply "ENTRY":U to da-venc-ini in frame f-pg-sel.
            return error.
        END.
    
        IF  INPUT FRAME f-pg-par i-cliente = 0 THEN DO:
            run utp/ut-msgs.p (input "show":U, 
                               input 17006, 
                               input "Cliente n∆o informado !").

            apply "MOUSE-SELECT-CLICK":U to im-pg-par in frame f-relat.
            apply "ENTRY":U to i-cliente in frame f-pg-par.
            return error.
        END.

        IF  INPUT FRAME f-pg-par da-venc-novo = ? THEN DO:
            run utp/ut-msgs.p (input "show":U, 
                               input 17006, 
                               input "Nova data de vencimento n∆o foi informada !").

            apply "MOUSE-SELECT-CLICK":U to im-pg-par in frame f-relat.
            apply "ENTRY":U to da-venc-novo in frame f-pg-par.
            return error.
        END.

        /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
           para o programa RP.P */
        
        create tt-param. 
        assign tt-param.usuario       = c-seg-usuario
               tt-param.destino       = input frame f-pg-imp rs-destino
               tt-param.data-exec     = today
               tt-param.hora-exec     = time
               tt-param.estab-ini     = input frame f-pg-sel c-estabelec-ini
               tt-param.estab-fim     = input frame f-pg-sel c-estabelec-fim
               tt-param.vencto-ini    = input frame f-pg-sel da-venc-ini
               tt-param.vencto-fim    = input frame f-pg-sel da-venc-fim
               tt-param.vencto-novo   = INPUT FRAME f-pg-par da-venc-novo
               tt-param.cod-emitente  = INPUT FRAME f-pg-par i-cliente
               tt-param.matriz        = INPUT FRAME f-pg-par tg-matriz
               tt-param.imprime-param = INPUT FRAME f-pg-imp tg-imprime-param.
        
        if  tt-param.destino = 1 then
            assign tt-param.arquivo = "".
        else
        if  tt-param.destino = 2 then 
            assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
        else
            assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".
    
        /*:T Executar do programa RP.P que ir† criar o relat¢rio */
        {include/i-rpexb.i}
        
        SESSION:SET-WAIT-STATE("general":U).
        
        {include/i-rprun.i esp\acr\ESACR074rp.p}
        
        {include/i-rpexc.i}
        
        SESSION:SET-WAIT-STATE("":U).
        
        {include/i-rptrm.i}
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina C-Win 
PROCEDURE pi-troca-pagina :
/*:T------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P†gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records C-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-digita"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed C-Win 
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

