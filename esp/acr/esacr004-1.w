&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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
/*          This .W file was created with the Progress AppBuilder.      */
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

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_empres_usuar    AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_estab_usuar     AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren    AS CHARACTER    NO-UNDO.


DEFINE NEW SHARED VARIABLE l-encerrado AS CHARACTER FORMAT "X(1)":U INITIAL 'A' LABEL "Encerrado" 
    VIEW-AS COMBO-BOX INNER-LINES 5 LIST-ITEM-PAIRS "Todos","T","Abertos","A","Fechados","F" DROP-DOWN-LIST SIZE 16 BY 1 NO-UNDO.
DEFINE NEW SHARED VARIABLE l-frete-sel AS CHARACTER FORMAT "X(1)":U INITIAL 'T' LABEL "Int. AP Frete" 
     VIEW-AS COMBO-BOX INNER-LINES 5 LIST-ITEM-PAIRS "Todos","T","Lanáados","L","N∆o Lanáados","N" DROP-DOWN-LIST SIZE 16 BY 1 NO-UNDO.
DEFINE NEW SHARED VARIABLE l-mp AS CHARACTER FORMAT "X(1)":U INITIAL 'T' LABEL "MatÇria Prima" 
     VIEW-AS COMBO-BOX INNER-LINES 5 LIST-ITEM-PAIRS "Todos","T","MP","M","Consumo","C" DROP-DOWN-LIST SIZE 16 BY 1 NO-UNDO.
DEFINE NEW SHARED VARIABLE l-recebido AS CHARACTER FORMAT "X(1)":U INITIAL 'T' LABEL "Recebido/Env." 
     VIEW-AS COMBO-BOX INNER-LINES 5 LIST-ITEM-PAIRS "Todos","T","Recebidos","T","Enviados","E" DROP-DOWN-LIST SIZE 16 BY 1 NO-UNDO.
DEFINE NEW SHARED VARIABLE l-tipo AS CHARACTER FORMAT "X(256)":U INITIAL 'T' LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 5 LIST-ITEM-PAIRS "Todos","T","Sa°da","S","Entrada","E" DROP-DOWN-LIST SIZE 16 BY 1 NO-UNDO.
DEFINE NEW SHARED VARIABLE l-impostos-sel AS CHARACTER FORMAT "X(1)":U INITIAL 'T' LABEL "Int. AP Imp" 
     VIEW-AS COMBO-BOX INNER-LINES 5 LIST-ITEM-PAIRS "Todos","T","Lanáados","L","N∆o Lanáados","N" DROP-DOWN-LIST SIZE 16 BY 1 NO-UNDO.
DEFINE NEW SHARED VARIABLE c-empresa-fim AS CHARACTER FORMAT "x(30)" INITIAL 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'
     VIEW-AS FILL-IN SIZE 22.57 BY .88.
DEFINE NEW SHARED VARIABLE c-empresa-ini AS CHARACTER FORMAT "x(30)" INITIAL '' LABEL "Empresa" 
     VIEW-AS FILL-IN SIZE 22.57 BY .88.
DEFINE NEW SHARED VARIABLE c-cod-estab-ini AS CHAR FORMAT "X(3)" INITIAL "" LABEL "Estab"
    VIEW-AS FILL-IN SIZE 5 BY .88.
DEFINE NEW SHARED VARIABLE c-cod-estab-fim AS CHAR FORMAT "X(3)" INITIAL "ZZZ"
    VIEW-AS FILL-IN SIZE 5 BY .88.
DEFINE NEW SHARED VARIABLE c-usuario-fim AS CHARACTER FORMAT "x(12)" INITIAL 'ZZZZZZZZZZZZ'
     VIEW-AS FILL-IN SIZE 12 BY .88.
DEFINE NEW SHARED VARIABLE c-usuario-ini AS CHARACTER FORMAT "x(12)" INITIAL '' LABEL "Solicitante" 
     VIEW-AS FILL-IN SIZE 12 BY .88.
DEFINE NEW SHARED VARIABLE cod-usuario-fim AS CHARACTER FORMAT "x(12)" INITIAL ? 
     VIEW-AS FILL-IN SIZE 6 BY .88.
DEFINE NEW SHARED VARIABLE cod-usuario-ini AS CHARACTER FORMAT "x(12)" INITIAL ?  LABEL "Solicitante" 
     VIEW-AS FILL-IN SIZE 6 BY .88.
DEFINE NEW SHARED VARIABLE i-frete-fim AS INTEGER FORMAT ">>>,>>9" INITIAL 999999
     VIEW-AS FILL-IN SIZE 8 BY .88.
DEFINE NEW SHARED VARIABLE i-frete-ini AS INTEGER FORMAT ">>>,>>9" INITIAL 0 LABEL "Fornec. Frete" 
     VIEW-AS FILL-IN SIZE 8 BY .88.
DEFINE NEW SHARED VARIABLE i-imp-fim AS INTEGER FORMAT ">>>,>>9" INITIAL 999999
     VIEW-AS FILL-IN SIZE 8 BY .88.
DEFINE NEW SHARED VARIABLE i-imp-ini AS INTEGER FORMAT ">>>,>>9" INITIAL 0 LABEL "Fornec. Imp" 
     VIEW-AS FILL-IN SIZE 8 BY .88.
DEFINE NEW SHARED VARIABLE i-transp-fim AS INTEGER FORMAT ">>,>>9" INITIAL 99999
     VIEW-AS FILL-IN SIZE 7 BY .88.
DEFINE NEW SHARED VARIABLE i-transp-ini AS INTEGER FORMAT ">>,>>9" INITIAL 0 LABEL "Transportadora" 
     VIEW-AS FILL-IN SIZE 7 BY .88.
DEFINE NEW SHARED VARIABLE c-co AS CHARACTER FORMAT "X(256)":U INITIAL '*' LABEL "Conhecimento" 
     VIEW-AS FILL-IN SIZE 21 BY .88 NO-UNDO.
DEFINE NEW SHARED VARIABLE c-embarque AS CHARACTER FORMAT "X(16)":U LABEL "Embarque" 
     VIEW-AS FILL-IN SIZE 21 BY .88 NO-UNDO.
DEFINE NEW SHARED VARIABLE l-mp-n       AS LOGICAL      NO-UNDO.
DEFINE NEW SHARED VARIABLE l-mp-s       AS LOGICAL      NO-UNDO.
DEFINE NEW SHARED VARIABLE l-frete-n    AS LOGICAL      NO-UNDO.
DEFINE NEW SHARED VARIABLE l-frete-s    AS LOGICAL      NO-UNDO.
DEFINE NEW SHARED VARIABLE l-impostos-n AS LOGICAL      NO-UNDO.
DEFINE NEW SHARED VARIABLE l-impostos-s AS LOGICAL      NO-UNDO.
DEFINE NEW SHARED VARIABLE l-encer-n    AS LOGICAL      NO-UNDO.
DEFINE NEW SHARED VARIABLE l-encer-s    AS LOGICAL      NO-UNDO.
DEFINE NEW SHARED VARIABLE l-recebido-n AS LOGICAL      NO-UNDO.
DEFINE NEW SHARED VARIABLE l-recebido-s AS LOGICAL      NO-UNDO.
DEFINE NEW SHARED VARIABLE l-tipo-n     AS LOGICAL      NO-UNDO.
DEFINE NEW SHARED VARIABLE l-tipo-s     AS LOGICAL      NO-UNDO.

/* Temporary Tables Definitions */
{esp\cms\apb900zd.i}

{esp\cms\apb768za.i}

{esp\cms\apb767zc.i}

/* Temp-table para envio de e-mail */                 
DEFINE TEMP-TABLE tt_mail_fax NO-UNDO
    FIELD ttv_nom_servid            AS CHARACTER    FORMAT "x(30)"
    FIELD ttv_num_porta_servid  AS INTEGER      FORMAT ">>>>9"
    FIELD ttv_log_exchange          AS LOGICAL      FORMAT "Sim/N∆o" INITIAL NO
    FIELD ttv_nom_from              AS CHARACTER    FORMAT "x(50)"
    FIELD ttv_nom_to                AS CHARACTER    FORMAT "x(50)"  LABEL "To"
    FIELD ttv_nom_cc                AS CHARACTER    FORMAT "x(50)"  LABEL "Cc"
    FIELD ttv_nom_subject           AS CHARACTER    FORMAT "x(30)"
    FIELD ttv_nom_message           AS CHARACTER    FORMAT "x(50)"
    FIELD ttv_nom_attachfile    AS CHARACTER    FORMAT "x(30)"
    FIELD ttv_num_imptcia           AS INTEGER      FORMAT "9"
    FIELD ttv_log_envda             AS LOGICAL      FORMAT "Sim/N∆o" INITIAL NO
    FIELD ttv_log_lida              AS LOGICAL      FORMAT "Sim/N∆o" INITIAL NO
    FIELD ttv_cod_format_mail   AS CHARACTER    FORMAT "x(8)"   INITIAL "TEXTO".

DEFINE TEMP-TABLE tt_erros_mail_fax NO-UNDO
    FIELD ttv_cod_erro              AS CHARACTER    FORMAT "x(10)"
    FIELD ttv_des_erro              AS CHARACTER    FORMAT "x(50)"  LABEL "Inconsistància" COLUMN-LABEL "Inconsistància"
    FIELD ttv_des_arquivo           AS CHARACTER    FORMAT "x(255)".
/* Temp-table para envio de e-mail */                 
/*
DEFINE TEMP-TABLE ttUnid_negoc NO-UNDO
    FIELD cod_unid_negoc LIKE unid_negoc.cod_unid_negoc
    INDEX idUnid IS PRIMARY UNIQUE cod_unid_negoc.
*/

def var cp-ct-codigo like conta-programa.ct-codigo extent 10.
def var cp-sc-codigo like conta-programa.sc-codigo extent 10.

DEFINE VARIABLE rs-rec-envia AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Recebe/Envia", 1,
          "Rejeita", 2
     SIZE 23 BY .88 NO-UNDO.

DEF VAR l-confirma     AS LOG  NO-UNDO.
DEF VAR c-arquivo      AS CHAR NO-UNDO.
DEF VAR c-especie      AS CHAR NO-UNDO.
DEF VAR c-nr-docto     AS CHAR NO-UNDO.
DEF VAR da-dt-emis     AS DATE NO-UNDO.
DEF VAR da-dt-venc     AS DATE NO-UNDO.
DEF VAR de-valor       AS DEC  NO-UNDO.
DEF VAR c-ct-codigo    AS CHAR NO-UNDO.
DEF VAR c-sc-codigo    AS CHAR NO-UNDO.
DEF VAR de-valor-mov   AS DEC  NO-UNDO.
DEF VAR iCod-emit-lanc AS INT  NO-UNDO.
DEF VAR c-parcela      AS CHAR NO-UNDO.
DEF VAR cUnid_negoc    AS CHAR FORMAT "X(256)":U 
     LABEL "Unidade de Neg¢cio" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY .88 NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_dwb_user AS CHARACTER  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_cta_ctbl_integr AS RECID  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_ccusto AS RECID  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_plano_ccusto AS RECID  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_fornecedor AS RECID  NO-UNDO.

DEF TEMP-TABLE tt-fedex
    FIELD usuario          LIKE usuar_mestre.cod_usuario
    FIELD numero           LIKE fedex.numero
    FIELD tipo             LIKE fedex.tipo            FORMAT "Entrada/Saida":U
    FIELD empresa          LIKE fedex.empresa         FORMAT "x(30)":U
    FIELD cod_estab        LIKE fedex.cod_estab       FORMAT "X(3)":U
    FIELD material         LIKE fedex.material        FORMAT "x(50)":U
    FIELD conhecimento     LIKE fedex.conhecimento    FORMAT "x(30)":U
    FIELD recebido         LIKE fedex.recebido        FORMAT "Sim/Nao":U
    FIELD lancado-frete    LIKE fedex.lancado-frete   FORMAT "Sim/Nao":U
    FIELD lancado-imp      LIKE fedex.lancado-imp     FORMAT "Sim/Nao":U
    FIELD usuar-mat        LIKE fedex.usuar-mat       FORMAT "x(12)"
    FIELD desc-sdcv        LIKE fedex.desc-sdcv       FORMAT "x(200)"
    FIELD cod-cond-pag     LIKE fedex.cod-cond-pag    FORMAT ">>>>9".

DEF VAR i-nome-programa AS CHAR.
DEF VAR i-ponto         AS INT.
DEF VAR i-sequencia     AS INT.
DEF VAR i-conteudo      AS CHAR.
DEF VAR c-tp-lancto     AS CHAR.
DEF VAR da-dt-venc-icms AS DATE FORMAT "99/99/9999"       NO-UNDO.
DEF VAR de-num-sat      AS DEC  FORMAT ">>>>>>>>>>>>>>>9" NO-UNDO.

{esp/es0018.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Definiá∆o Despesa Embarque */

    DEF TEMP-TABLE tt-desp-embarque NO-UNDO
        FIELD cod-emitente LIKE emitente.cod-emitente
        FIELD nom-emitente LIKE emitente.nome-abrev
        FIELD cod-despesa  LIKE desp-embarque.cod-desp  
        FIELD des-despesa  LIKE desp-imp.descricao
        FIELD des-moeda    LIKE moeda.descricao 
        FIELD val-despesa  LIKE desp-embarque.val-desp
        INDEX fornecec IS PRIMARY
              cod-emitente ASCENDING
              des-despesa  ASCENDING.


    DEF QUERY qr-desp-embarque
        FOR tt-desp-embarque
        SCROLLING.

    DEF BROWSE br-desp-embarque QUERY qr-desp-embarque DISPLAY 
        cod-emitente
        nom-emitente
        cod-despesa 
        des-despesa 
        des-moeda   COLUMN-LABEL "Moeda"
        val-despesa 
      WITH NO-BOX SEPARATORS MULTIPLE
             SIZE 76 BY 15.3
             FONT 1
             BGCOLOR 15.

    DEF RECTANGLE rt_cxcf
        SIZE 1 BY 1
        FGCOLOR 1 EDGE-PIXELS 2.

    DEF BUTTON bt-ok
        LABEL "OK"
        TOOLTIP "OK"
        SIZE 1 BY 1
        AUTO-GO.

    DEFINE VARIABLE v-tot-desp AS DECIMAL FORMAT "->>>,>>>,>>9.99" LABEL "Total Selecionado"    NO-UNDO.

    DEF FRAME f-desp-embarque
        rt_cxcf
             at row 18.00 col 02.00 bgcolor 7 
        br-desp-embarque
             AT ROW 1.21 COL 2
        v-tot-desp
             AT ROW 17 COL 3
        embarque-imp.cod-estabel
             AT ROW 17 COL 35 LABEL "Embarque"
        embarque-imp.embarque   
             AT ROW 17 COL 48 NO-LABEL
        bt-ok
             at row 18.21 col 03.00 font ?
             help "AVA"
        with 1 down side-labels no-validate keep-tab-order three-d
             size-char 79 by 20 default-button bt-ok
             view-as dialog-box
             font 1 fgcolor ? bgcolor 8
             title "Despesas do Embarque".

    /* adjust size of objects in this frame */
    assign bt-ok:width-chars           in frame f-desp-embarque = 10.00
           bt-ok:height-chars          in frame f-desp-embarque = 01.00
           embarque-imp.cod-estabel:width-chars in frame f-desp-embarque = 4
           embarque-imp.embarque:width-chars in frame f-desp-embarque    = 8
           rt_cxcf:width-chars         in frame f-desp-embarque = 76
           rt_cxcf:height-chars        in frame f-desp-embarque = 01.42.


    ON MOUSE-SELECT-CLICK OF br-desp-embarque IN FRAME f-desp-embarque
    DO:

        def var v_num_cont
            as integer
            format ">,>>9":U
            initial 0
            no-undo.

        DEFINE VARIABLE v_log_method AS LOGICAL     NO-UNDO.

        assign v-tot-desp = 0.

        do v_num_cont = 1 to browse br-desp-embarque:num-selected-rows:
           assign v_log_method = browse br-desp-embarque:fetch-selected-row(v_num_cont).
           assign v-tot-desp = v-tot-desp + tt-desp-embarque.val-despesa.
        end.

        display v-tot-desp
                with frame f-desp-embarque.

    END.

    ON MOUSE-EXTEND-CLICK OF br-desp-embarque IN FRAME f-desp-embarque
    DO:
        APPLY 'mouse-select-click' TO br-desp-embarque.
    END. 

    ON " " OF br-desp-embarque IN FRAME f-desp-embarque
    DO:
        APPLY 'mouse-select-click' TO br-desp-embarque.
    END. 

    ASSIGN br-desp-embarque:COLUMN-MOVABLE IN FRAME f-desp-embarque = YES.

/* Fim definiá∆o Despesa Embarque */


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME br-pend

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-fedex

/* Definitions for BROWSE br-pend                                       */
&Scoped-define FIELDS-IN-QUERY-br-pend tt-fedex.usuario tt-fedex.tipo tt-fedex.empresa tt-fedex.cod_estab tt-fedex.material tt-fedex.conhecimento tt-fedex.recebido tt-fedex.lancado-frete tt-fedex.lancado-imp tt-fedex.embarque tt-fedex.usuar-mat tt-fedex.cod-cond-pag tt-fedex.desc-sdcv 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-pend   
&Scoped-define SELF-NAME br-pend
&Scoped-define QUERY-STRING-br-pend FOR EACH tt-fedex
&Scoped-define OPEN-QUERY-br-pend OPEN QUERY {&SELF-NAME} FOR EACH tt-fedex.
&Scoped-define TABLES-IN-QUERY-br-pend tt-fedex
&Scoped-define FIRST-TABLE-IN-QUERY-br-pend tt-fedex


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-br-pend}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btExit btHelp btFiltro btDet ~
btPrint btInc btTroca br-pend btAltera btRecEnvia btFrete btImp btEncerra ~
btNota btExcluir btDesp btCancela btDesp btRetira

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFaixa        LABEL "Faixa"         
       RULE
       MENU-ITEM miDetalhe      LABEL "Detalhe"        ACCELERATOR "ALT-D"
       RULE
       MENU-ITEM miRelat        LABEL "Imprime"       
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU miFedex 
       MENU-ITEM miAltera       LABEL "&Altera"       
       MENU-ITEM miRecEnvia     LABEL "&Rec/Envia"    
       MENU-ITEM miFrete        LABEL "&Frete"        
       MENU-ITEM miImp          LABEL "&Imp"          
       MENU-ITEM miEncerra      LABEL "&Encerra"      
       MENU-ITEM miNota         LABEL "&Nota"         
       MENU-ITEM miExcluir      LABEL "&Excluir"      
       RULE
       MENU-ITEM miCancela      LABEL "&Cancela"      .

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  miFedex        LABEL "&Fedex"        
       SUB-MENU  smHelp         LABEL "A&juda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btAltera 
     LABEL "A&ltera" 
     SIZE 10 BY 1.

DEFINE BUTTON btCancela 
     LABEL "Cancela" 
     SIZE 10 BY 1.

DEFINE BUTTON btDet 
     IMAGE-UP FILE "image/im-det.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-det.bmp":U
     LABEL "Mail" 
     SIZE 4 BY 1.25 TOOLTIP "Detalhe".

DEFINE BUTTON btEncerra 
     LABEL "En&cerra" 
     SIZE 10 BY 1.

DEFINE BUTTON btExcluir 
     LABEL "E&xclui" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image\im-ran.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-ran.bmp":U
     LABEL "Mail" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro".

DEFINE BUTTON btFrete 
     LABEL "Fr&ete" 
     SIZE 10 BY 1.

DEFINE BUTTON btDesp 
     LABEL "Despesas" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btImp 
     LABEL "&Imp" 
     SIZE 10 BY 1.

DEFINE BUTTON btInc 
     IMAGE-UP FILE "image/im-add.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-det.bmp":U
     LABEL "Inclui" 
     SIZE 4 BY 1.25 TOOLTIP "Inclus∆o".

DEFINE BUTTON btNota 
     LABEL "&Nota" 
     SIZE 10 BY 1.

DEFINE BUTTON btPrint 
     IMAGE-UP FILE "image\im-pri.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-pri.bmp":U
     LABEL "Mail" 
     SIZE 4 BY 1.25 TOOLTIP "Relat¢rio".

DEFINE BUTTON btRecEnvia 
     LABEL "&Rec/Envia" 
     SIZE 10 BY 1.

DEFINE BUTTON btRetira 
     LABEL "Re&tira" 
     SIZE 10 BY 1.

DEFINE BUTTON btTroca 
     IMAGE-UP FILE "image/im-carga.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-carga.bmp":U
     LABEL "Troca Usu†rio" 
     SIZE 4 BY 1.25 TOOLTIP "Troca Usu†rio".

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 100 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-pend FOR 
      tt-fedex SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-pend
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-pend C-Win _FREEFORM
  QUERY br-pend NO-LOCK DISPLAY
      tt-fedex.usuario          FORMAT "x(12)":U
      tt-fedex.tipo             FORMAT "Entrada/Saida":U
      tt-fedex.empresa          FORMAT "x(30)":U
      tt-fedex.cod_estab        FORMAT "X(3)":U
      tt-fedex.material         FORMAT "x(50)":U
      tt-fedex.conhecimento     FORMAT "x(30)":U
      tt-fedex.recebido         FORMAT "Sim/Nao":U
      tt-fedex.lancado-frete    FORMAT "Sim/Nao":U
      tt-fedex.lancado-imp      FORMAT "Sim/Nao":U
      tt-fedex.usuar-mat        FORMAT "x(12)"
      tt-fedex.cod-cond-pag     FORMAT ">>>>9"
      tt-fedex.desc-sdcv        FORMAT "x(35)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 100 BY 10.25
         FONT 1 ROW-HEIGHT-CHARS .46 EXPANDABLE.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btExit     AT ROW 1.17 COL 91.86 HELP
          "Sair"
     btHelp     AT ROW 1.17 COL 95.86 HELP
          "Ajuda"
     btFiltro   AT ROW 1.17 COL 2.14 HELP
          "Pesquisa"
     btDet      AT ROW 1.17 COL 6.14 HELP
          "Pesquisa"
     btPrint    AT ROW 1.17 COL 10.14 HELP
          "Pesquisa"
     btInc      AT ROW 1.17 COL 14.14 HELP
          "Pesquisa"
     btTroca    AT ROW 1.17 COL 18.14 HELP
          "Troca Usu†rio"
     br-pend    AT ROW 2.75 COL 1
     btAltera   AT ROW 13   COL 1
     btRecEnvia AT ROW 13   COL 11
     btFrete    AT ROW 13   COL 21
     btImp      AT ROW 13   COL 31
     btEncerra  AT ROW 13   COL 41
     btNota     AT ROW 13   COL 51
     btExcluir  AT ROW 13   COL 61
     btDesp     AT ROW 13   COL 71
     btCancela  AT ROW 13   COL 81
     btRetira   AT ROW 13   COL 91
     rtToolBar  AT ROW 1    COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 100 BY 13.13
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Controle COURRIER - ESACR004"
         HEIGHT             = 13.13
         WIDTH              = 100
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.21
         VIRTUAL-WIDTH      = 146.29
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* BROWSE-TAB br-pend btTroca DEFAULT-FRAME */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-pend
/* Query rebuild information for BROWSE br-pend
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-fedex.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", OUTER"
     _Where[1]         = "fedex.cod-transp >= i-transp-ini
and fedex.cod-transp <= i-transp-fim
and fedex.empresa >= c-empresa-ini
and fedex.empresa <= c-empresa-fim
and fedex.cod_estab >= c-cod-estab-ini
and fedex.cod_estab <= c-cod-estab-fim
and fedex.cod-emit-frete >= i-frete-ini
and fedex.cod-emit-frete <= i-frete-fim
and fedex.cod-emitente-imp >= i-imp-ini
and fedex.cod-emitente-imp <= i-imp-fim
and fedex.cod_usuario      >= cod-usuario-ini
and fedex.cod_usuario      <= cod-usuario-fim
and (fedex.mp = l-mp-s or fedex.mp = l-mp-n)
and (fedex.lancado-frete = l-frete-s or fedex.lancado-frete = l-frete-n)
and (fedex.lancado-imp = l-impostos-s or fedex.lancado-imp = l-impostos-n)
and (fedex.encerrado = l-encer-s or fedex.encerrado = l-encer-n)
and (fedex.recebido = l-recebido-s or fedex.recebido = l-recebido-n)
and (fedex.tipo = l-tipo-s or fedex.tipo = l-tipo-n)
and fedex.conhecimento matches (c-co)
"
     _Query            is OPENED
*/  /* BROWSE br-pend */
&ANALYZE-RESUME

/* ************************  Control Triggers  ************************ */

ON "value-changed" OF br-pend DO:
    ASSIGN br-pend:HELP = "".

    IF  tt-fedex.conhecimento <> ""
    THEN DO:
        FIND FIRST embarque-imp NO-LOCK 
            WHERE  embarque-imp.cod-conhecto-master = tt-fedex.conhecimento NO-ERROR.
        IF AVAIL embarque-imp 
        THEN
            ASSIGN br-pend:HELP = "Embarque: " + embarque-imp.embarque.
    END.
    APPLY "ENTRY" TO br-pend IN FRAME {&FRAME-NAME}.
END.

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Controle COURRIER - ESACR004 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Controle COURRIER - ESACR004 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-pend
&Scoped-define SELF-NAME br-pend
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-pend C-Win
ON MOUSE-SELECT-DBLCLICK OF br-pend IN FRAME DEFAULT-FRAME
DO:
    APPLY 'choose' TO btDet IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-pend C-Win
ON RETURN OF br-pend IN FRAME DEFAULT-FRAME
DO:
    APPLY 'choose' TO btDet IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAltera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAltera C-Win
ON CHOOSE OF btAltera IN FRAME DEFAULT-FRAME /* Altera */
DO:
    FIND FIRST fedex NO-LOCK
        WHERE fedex.numero = tt-fedex.numero NO-ERROR.
    IF AVAIL fedex THEN
        RUN piAlteraSolicitacao IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancela C-Win
ON CHOOSE OF btCancela IN FRAME DEFAULT-FRAME /* Cancela */
DO:
    DEFINE VARIABLE l-ok AS LOGICAL    NO-UNDO.
    FIND FIRST fedex NO-LOCK
        WHERE fedex.numero = tt-fedex.numero NO-ERROR.
    IF AVAIL fedex THEN DO:
        RUN esp/acr/esacr004e.w (INPUT  ROWID(fedex),
                                 OUTPUT l-ok).
        IF l-ok THEN 
            RUN piMontaBrowse.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDet C-Win
ON CHOOSE OF btDet IN FRAME DEFAULT-FRAME /* Mail */
DO:
    IF AVAILABLE tt-fedex AND BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS > 0 THEN DO:
        FIND FIRST fedex NO-LOCK
            WHERE fedex.numero = tt-fedex.numero NO-ERROR.
        RUN esp/acr/esacr004b.w (ROWID(fedex)).
    END.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEncerra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEncerra C-Win
ON CHOOSE OF btEncerra IN FRAME DEFAULT-FRAME /* Encerra */
DO:
    FIND FIRST fedex NO-LOCK
        WHERE fedex.numero = tt-fedex.numero NO-ERROR.
    IF AVAIL fedex THEN
        RUN piEncerraSolicitacao IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcluir C-Win
ON CHOOSE OF btExcluir IN FRAME DEFAULT-FRAME /* Exclui */
DO:
    FIND FIRST fedex NO-LOCK
        WHERE fedex.numero = tt-fedex.numero NO-ERROR.
    IF AVAIL fedex THEN
        RUN piExcluiSolicitacao IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit C-Win
ON CHOOSE OF btExit IN FRAME DEFAULT-FRAME /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro C-Win
ON CHOOSE OF btFiltro IN FRAME DEFAULT-FRAME /* Mail */
DO:
    RUN esp/acr/esacr004a.w.
    RUN piMontaBrowse.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFrete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFrete C-Win
ON CHOOSE OF btFrete IN FRAME DEFAULT-FRAME /* Frete */
DO:
    FIND FIRST fedex NO-LOCK
        WHERE fedex.numero = tt-fedex.numero NO-ERROR.
    IF AVAIL fedex THEN
        RUN piIntegraFreteAP IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btDesp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesp C-Win
ON CHOOSE OF btDesp IN FRAME DEFAULT-FRAME /* Despesa Embarque */
DO:
    FIND FIRST fedex NO-LOCK
        WHERE fedex.numero = tt-fedex.numero NO-ERROR.
    IF AVAIL fedex THEN
        RUN piDespesaEmbarque IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btImp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImp C-Win
ON CHOOSE OF btImp IN FRAME DEFAULT-FRAME /* Imp */
DO:
    FIND FIRST fedex NO-LOCK
        WHERE fedex.numero = tt-fedex.numero NO-ERROR.
    IF AVAIL fedex THEN
        RUN piIntegraImpAP IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btInc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInc C-Win
ON CHOOSE OF btInc IN FRAME DEFAULT-FRAME /* Inclui */
DO:
    RUN esp/acr/esacr004c.w.
    RUN piMontaBrowse.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNota C-Win
ON CHOOSE OF btNota IN FRAME DEFAULT-FRAME /* Nota */
DO:
    FIND FIRST fedex NO-LOCK
        WHERE fedex.numero = tt-fedex.numero NO-ERROR.
    IF AVAIL fedex THEN
        RUN piAlteraNota IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrint
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrint C-Win
ON CHOOSE OF btPrint IN FRAME DEFAULT-FRAME /* Mail */
DO:
  RUN pi-print.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btRecEnvia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRecEnvia C-Win
ON CHOOSE OF btRecEnvia IN FRAME DEFAULT-FRAME /* Rec/Envia */
DO:
    FIND FIRST fedex NO-LOCK
        WHERE fedex.numero = tt-fedex.numero NO-ERROR.
    IF AVAIL fedex THEN DO:
        IF fedex.cod_estab = "" THEN DO:
            MESSAGE "Estabelecimento n∆o preenchido!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN NO-APPLY.
        END.
        RUN piRecebeFedex IN THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btRetira
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRetira C-Win
ON CHOOSE OF btRetira IN FRAME DEFAULT-FRAME /* Retira */
DO:
    FIND FIRST fedex NO-LOCK
        WHERE fedex.numero = tt-fedex.numero NO-ERROR.
    
    IF AVAIL fedex THEN DO:
        IF  NOT fedex.recebido THEN DO:
            MESSAGE "Este COURRIER ainda nao foi Recebido/Enviado" VIEW-AS ALERT-BOX WARNING.
            RETURN NO-APPLY.
        END.

        IF  fedex.usuar-retira <> "" THEN DO:
            MESSAGE "Retirada deste COURRIER j† foi efetuada !" VIEW-AS ALERT-BOX WARNING.
            RETURN NO-APPLY.
        END.

        RUN piRetira IN THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btTroca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btTroca C-Win
ON CHOOSE OF btTroca IN FRAME DEFAULT-FRAME /* Troca Usu†rio */
DO:
    DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
         LABEL "Cancel" 
         SIZE 12 BY 1
         BGCOLOR 8 FONT 1.
    
    DEFINE BUTTON Btn_OK AUTO-GO 
         LABEL "OK" 
         SIZE 12 BY 1
         BGCOLOR 8 FONT 1.
    
    DEFINE VARIABLE c-conhecimento AS CHARACTER FORMAT "x(30)" INITIAL "*" 
         LABEL "Conhecimento" 
         VIEW-AS FILL-IN 
         SIZE 22.57 BY .88 TOOLTIP "Informe o conhecimento para troca ou * para todos".
    
    DEFINE VARIABLE v-cod-usuario-fim AS CHARACTER FORMAT "X(12)" INITIAL "" 
         LABEL "Novo Usu†rio" 
         VIEW-AS FILL-IN 
         SIZE 5.43 BY .88.
    
    DEFINE VARIABLE v-cod-usuario-ini AS CHARACTER FORMAT "X(12)" INITIAL ""
         LABEL "Antigo Usu†rio" 
         VIEW-AS FILL-IN 
         SIZE 5.43 BY .88.
    
    DEFINE RECTANGLE RECT-30
         EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
         SIZE 60 BY 1.54.
    
    DEFINE RECTANGLE RECT-31
         EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
         SIZE 60 BY 1.54.
    
    DEFINE RECTANGLE RECT-32
         EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
         SIZE 60 BY 1.54.
    
    DEFINE RECTANGLE rtToolBar
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 60 BY 1.5
         BGCOLOR 7 .
    
    DEFINE FRAME fAltUsuar
         v-cod-usuario-ini AT ROW 1.46 COL 24 COLON-ALIGNED
         v-cod-usuario-fim AT ROW 3.13 COL 24 COLON-ALIGNED
         c-conhecimento AT ROW 4.83 COL 24 COLON-ALIGNED HELP
              "Informe o conhecimento para troca ou * para todos"
         Btn_OK AT ROW 6.46 COL 2
         Btn_Cancel AT ROW 6.46 COL 14
         RECT-30 AT ROW 1.08 COL 1
         RECT-31 AT ROW 2.79 COL 1
         RECT-32 AT ROW 4.5 COL 1
         rtToolBar AT ROW 6.21 COL 1
         SPACE(0.28) SKIP(0.03)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1
             TITLE "Troca Usu†rios"
             DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.
    
    DISPLAY v-cod-usuario-ini v-cod-usuario-fim c-conhecimento
        WITH FRAME fAltUsuar.
    ENABLE v-cod-usuario-ini v-cod-usuario-fim c-conhecimento Btn_OK Btn_Cancel RECT-30 RECT-31 rtToolBar 
        WITH FRAME fAltUsuar.
    VIEW FRAME fAltUsuar.

    ON  CHOOSE OF Btn_OK IN FRAME fAltUsuar DO:
        
        FIND FIRST fedex NO-LOCK
            WHERE fedex.cod_usuario = INPUT FRAME fAltUsuar v-cod-usuario-ini NO-ERROR.
        IF NOT AVAIL fedex THEN DO:
              MESSAGE "Usu†rio Inicial informado n∆o est† vinculado a nenhum registro Fedex" VIEW-AS ALERT-BOX ERROR.
              APPLY "ENTRY" TO v-cod-usuario-ini IN FRAME fAltUsuar.
              RETURN NO-APPLY.
        END.
        
        FIND FIRST usuar_mestre NO-LOCK
            WHERE usuar_mestre.cod_usuario = INPUT FRAME fAltUsuar v-cod-usuario-fim NO-ERROR.
        IF NOT AVAIL usuar_mestre THEN DO:
            MESSAGE "Usu†rio Final informado n∆o est† cadastrado ou tipo diferente de 1." VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO v-cod-usuario-fim IN FRAME fAltUsuar.
            RETURN NO-APPLY.
        END.
        
        IF INPUT FRAME fAltUsuar c-conhecimento = "*" THEN DO:
            FOR EACH fedex
               WHERE fedex.cod_usuario = INPUT FRAME fAltUsuar v-cod-usuario-ini:
                  ASSIGN fedex.cod_usuario = usuar_mestre.cod_usuario.
            END.
        END.
        ELSE DO:
            FIND FIRST fedex
                WHERE fedex.cod_usuario  = INPUT FRAME fAltUsuar v-cod-usuario-ini
                AND   fedex.conhecimento = INPUT FRAME fAltUsuar c-conhecimento NO-ERROR.
            IF AVAIL fedex THEN 
                ASSIGN fedex.cod_usuario = usuar_mestre.cod_usuario.
            ELSE DO:
                MESSAGE "N∆o encontrado registro Fedex para o usu†rio e conhecimento informados" VIEW-AS ALERT-BOX ERROR.
                APPLY "ENTRY" TO v-cod-usuario-ini IN FRAME fAltUsuar.
                RETURN NO-APPLY.
            END.
        END.
        
        MESSAGE "Alteraá∆o de usu†rio feita com sucesso ! Confirma geraá∆o de relat¢rio de COURRIER Recebidos ?" 
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE l-confirma.
        
        IF  l-confirma THEN DO:
            FIND FIRST usuar_mestre NO-LOCK 
                WHERE  usuar_mestre.cod_usuario = v_cod_usuar_corren USE-INDEX srmstr_id NO-ERROR.
        
            assign c-arquivo = usuar_mestre.nom_dir_spool + "~\" + usuar_mestre.nom_subdir_spool + "~\" + "fedex_rec_" + string(day(today)) + string(month(today)) + string(YEAR(today)) + ".txt".
        
            OUTPUT TO VALUE (c-arquivo).
            PUT UNFORMATTED
                "Tipo;Data Sol;Encerrado;Empresa;Estab;Material;Conhecimento;Recebido;Dt Rec;Conta;CC;MP;Transp;Usuar Mat;Cond Pagto;SDCVs;Motiv Rej;Tipo;Valor;Emiss∆o;Vencimento;Fornecedor;Int;Fatura;ICMS;Tipo;Valor;Emiss∆o;Vencimento;Fornecedor;Int;Fatura;Nota" SKIP.
        
            FOR EACH fedex
                WHERE fedex.recebido = YES
                AND   fedex.dt-rec   = TODAY NO-LOCK:
                PUT UNFORMATTED
                    string(fedex.tipo,"Entrada/Sa°da")       + ';'
                    string(fedex.data-sol,"99/99/9999")      + ';'
                    string(fedex.encerrado,"Sim/N∆o")        + ';'
                    fedex.empresa                            + ';'
                    fedex.cod_estab                          + ';'
                    fedex.material                           + ';'
                    fedex.conhecimento                       + ';'
                    string(fedex.recebido,"Sim/N∆o")         + ';'
                    string(fedex.dt-rec,"99/99/9999")        + ';'
                    fedex.ct-codigo                          + ';'
                    fedex.cc-codigo                          + ';'
                    string(fedex.mp,"Sim/N∆o")               + ';'
                    string(fedex.cod-transp)                 + ';'
                    fedex.usuar-mat                          + ';'
                    string(fedex.cod-cond-pag)               + ';'
                    fedex.desc-sdcv                          + ';'
                    fedex.motivo-rejeicao                    + ';'
                    fedex.freight                            + ';'
                    string(fedex.valor-frete)                + ';'
                    string(fedex.dt-emis-frete,"99/99/9999") + ';'
                    string(fedex.dt-venc-frete,"99/99/9999") + ';'
                    string(fedex.cod-emit-frete)             + ';'
                    string(fedex.dt-ap-frete,"99/99/9999")   + ';'
                    string(fedex.fatura-frete)               + ';'
                    string(fedex.icms)                       + ';'
                    fedex.duties                             + ';'
                    string(fedex.valor-imp)                  + ';'
                    string(fedex.dt-emis-imp,"99/99/9999")   + ';'
                    string(fedex.dt-venc-imp,"99/99/9999")   + ';'
                    string(fedex.cod-emitente-imp)           + ';'
                    string(fedex.dt-ap-imp,"99/99/9999")     + ';'
                    string(fedex.fatura-imp)                 + ';'
                    string(fedex.nota) SKIP.
            END.
            OUTPUT CLOSE.

            MESSAGE "Relat¢rio gerado com sucesso no diret¢rio " c-arquivo " !" VIEW-AS ALERT-BOX INFORMATION.
        END.
    END.
    
    WAIT-FOR "GO":U OF FRAME fAltUsuar.

    RUN piMontaBrowse.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAltera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAltera C-Win
ON CHOOSE OF MENU-ITEM miAltera /* Altera */
DO:
    APPLY 'choose' TO btAltera IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miCancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miCancela C-Win
ON CHOOSE OF MENU-ITEM miCancela /* Cancela */
DO:
    RUN piCancelaSolicitacao IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miDetalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miDetalhe C-Win
ON CHOOSE OF MENU-ITEM miDetalhe /* Detalhe */
DO:
  APPLY "CHOOSE" TO btDet IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miEncerra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miEncerra C-Win
ON CHOOSE OF MENU-ITEM miEncerra /* Encerra */
DO:
    APPLY 'choose' TO btEncerra IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miExcluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miExcluir C-Win
ON CHOOSE OF MENU-ITEM miExcluir /* Excluir */
DO:
    APPLY 'choose' TO btExcluir IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miFaixa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miFaixa C-Win
ON CHOOSE OF MENU-ITEM miFaixa /* Faixa */
DO:
  APPLY "CHOOSE" TO btFiltro IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miFrete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miFrete C-Win
ON CHOOSE OF MENU-ITEM miFrete /* Frete */
DO:
    APPLY 'choose' TO btFrete IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miImp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miImp C-Win
ON CHOOSE OF MENU-ITEM miImp /* Imp */
DO:
    APPLY 'choose' TO btImp IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miNota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miNota C-Win
ON CHOOSE OF MENU-ITEM miNota /* Nota */
DO:
    APPLY 'choose' TO btNota IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miRecEnvia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miRecEnvia C-Win
ON CHOOSE OF MENU-ITEM miRecEnvia /* Rec/Envia */
DO:
    APPLY 'choose' TO btRecEnvia IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miRelat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miRelat C-Win
ON CHOOSE OF MENU-ITEM miRelat /* Imprime */
DO:
  APPLY "CHOOSE" TO btPrint IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    FIND plano_ccusto NO-LOCK
        WHERE plano_ccusto.cod_empresa = v_cod_empres_usuar
          AND plano_ccusto.cod_plano_ccusto = 'Padr∆o'
        NO-ERROR.
    IF AVAILABLE plano_ccusto THEN
        ASSIGN v_rec_plano_ccusto = RECID(plano_ccusto).

    RUN piBuscaContas IN THIS-PROCEDURE.

    ASSIGN c-usuario-ini = v_cod_usuar_corren
           c-usuario-fim = v_cod_usuar_corren.

    RUN enable_UI.

    RUN esp/acr/esacr004a.w.

    RUN piMontaBrowse.   

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
  ENABLE rtToolBar btExit btHelp btFiltro btDet btPrint btInc btTroca br-pend 
         btAltera btRecEnvia btFrete btImp btEncerra btNota btExcluir btDesp btCancela btRetira
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-email C-Win 
PROCEDURE pi-email :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM i-tipo AS INT NO-UNDO.

    DEF VAR cNom_to   AS CHAR NO-UNDO INIT ''.
    DEF VAR cNom_from AS CHAR NO-UNDO INIT ''.
    DEF VAR c-txt-aux AS CHAR NO-UNDO INIT ''.
    DEF VAR v_titulo  AS CHAR NO-UNDO INIT ''.

    FIND usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
    IF AVAILABLE usuar_mestre THEN
        ASSIGN cNom_from = usuar_mestre.cod_e_mail_local.
    
    IF cNom_from = '' THEN
        ASSIGN cNom_from = 'ems@intelbras.com.br'.


    FIND usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = fedex.cod_usuario NO-ERROR.
    IF AVAIL usuar_mestre THEN
        ASSIGN cNom_to = usuar_mestre.cod_e_mail_local.
    
    IF cNom_to = '' THEN DO:
        MESSAGE 'Usu†rio sem endereáo de e-mail cadastrado. E-mail n∆o pode ser enviado.'
            VIEW-AS ALERT-BOX WARNING TITLE 'Envio de e-mail'.
        RETURN.
    END.

    FIND usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = fedex.usuar-mat NO-ERROR.
    IF  AVAIL usuar_mestre THEN DO:
        IF  usuar_mestre.cod_e_mail_local = "" THEN DO:
            MESSAGE 'Usu†rio material sem endereáo de e-mail cadastrado. E-mail n∆o pode ser enviado.'
                VIEW-AS ALERT-BOX WARNING TITLE 'Envio de e-mail'.
            RETURN.
        END.
        ELSE
            ASSIGN cNom_to = cNom_to + ";" + usuar_mestre.cod_e_mail_local.
    END.

    IF  i-tipo = 1 THEN
        ASSIGN v_titulo  = 'COURRIER Enviado/Recebido'
               c-txt-aux = 'O COURRIER discriminado abaixo foi Recebido/Enviado:'.


    IF  i-tipo = 2 THEN
        ASSIGN v_titulo  = 'COURRIER Rejeitado'
               c-txt-aux = 'O COURRIER discriminado abaixo foi Rejeitado. Motiv Rej: ' + STRING(fedex.motivo-rejeicao).


    IF  i-tipo = 3 THEN
        ASSIGN v_titulo  = 'COURRIER Retirado pelo usu†rio: ' + fedex.usuar-retira + ' - tst email: ' + cNom_to
               c-txt-aux = 'O COURRIER discriminado abaixo foi retirado pelo usu†rio: ' + fedex.usuar-retira.

    /* envio de e-mail */
    CREATE tt_mail_fax.
    ASSIGN tt_mail_fax.ttv_nom_to           = cNom_to
           tt_mail_fax.ttv_nom_from         = cNom_from
           tt_mail_fax.ttv_nom_subject      = v_titulo
           tt_mail_fax.ttv_nom_attachfile   = ''
           tt_mail_fax.ttv_num_imptcia      = 2
           tt_mail_fax.ttv_cod_format_mail  = "texto".
    
    ASSIGN tt_mail_fax.ttv_nom_message      = c-txt-aux + CHR(10) + CHR(10) +
                (IF usuar_mestre.nom_usuario            <> "" THEN 'Usuario: '       + usuar_mestre.nom_usuario                          + CHR(10) ELSE '') +
                (IF fedex.tipo              <> ? THEN 'Tipo: '          + STRING(fedex.tipo, 'Entrada/Sa°da')   + CHR(10) ELSE '') +
                (IF fedex.data-sol          <> ? THEN 'Data Sol: '      + STRING(fedex.data-sol, '99/99/9999')  + CHR(10) ELSE '') +
                (IF fedex.encerrado         <> ? THEN 'Encerrado: '     + STRING(fedex.encerrado, 'Sim/N∆o')    + CHR(10) ELSE '') +
                (IF fedex.empresa           <> ? THEN 'Empresa: '       + fedex.empresa                         + CHR(10) ELSE '') +
                (IF fedex.cod_estab         <> ? THEN 'Estab: '         + fedex.cod_estab                       + CHR(10) ELSE '') +
                (IF fedex.material          <> ? THEN 'Material: '      + fedex.material                        + CHR(10) ELSE '') +
                (IF fedex.conhecimento      <> ? THEN 'Conhecimento: '  + fedex.conhecimento                    + CHR(10) ELSE '') +
                (IF fedex.recebido          <> ? THEN 'Recebido: '      + STRING(fedex.recebido, 'Sim/N∆o')     + CHR(10) ELSE '') +
                (IF fedex.dt-rec            <> ? THEN 'Dt Rec: '        + STRING(fedex.dt-rec, '99/99/9999')    + CHR(10) ELSE '') +  
                (IF fedex.ct-codigo         <> ? THEN 'Conta: '         + fedex.ct-codigo                       + CHR(10) ELSE '') +
                (IF fedex.cc-codigo         <> ? THEN 'CC: '            + fedex.cc-codigo                       + CHR(10) ELSE '') +
                (IF fedex.mp                <> ? THEN 'MP: '            + STRING(fedex.mp, 'Sim/N∆o')           + CHR(10) ELSE '') +
                (IF fedex.cod-transp        <> ? THEN 'Transp: '        + STRING(fedex.cod-transp)              + CHR(10) ELSE '') + 
                (IF fedex.usuar-mat         <> ? THEN 'Usuar Mat: '     + STRING(fedex.usuar-mat)               + CHR(10) ELSE '') + 
                (IF fedex.cod-cond-pag      <> ? THEN 'Cond Pagto: '    + STRING(fedex.cod-cond-pag)            + CHR(10) ELSE '') + 
                (IF fedex.desc-sdcv         <> ? THEN 'SDCVs: '         + STRING(fedex.desc-sdcv)               + CHR(10) ELSE '') + 
                (IF fedex.motivo-rejeicao   <> ? 
                 AND i-tipo = 2                  THEN 'Motiv Rej: '     + STRING(fedex.motivo-rejeicao)         + CHR(10) ELSE '') + CHR(10) +
                ' - FRETE' + CHR(10) + CHR(10) +
                (IF fedex.freight           <> ? THEN 'Tipo: '          + fedex.freight                         + CHR(10) ELSE '') +
                (IF fedex.valor-frete       <> ? THEN 'Valor: '         + STRING(fedex.valor-frete, '>>>,>>>,>>9.99')   + CHR(10) ELSE '') +
                (IF fedex.dt-emis-frete     <> ? THEN 'Emiss∆o: '       + STRING(fedex.dt-emis-frete, '99/99/9999')     + CHR(10) ELSE '') +
                (IF fedex.dt-venc-frete     <> ? THEN 'Vencimento: '    + STRING(fedex.dt-venc-frete, '99/99/9999')     + CHR(10) ELSE '') +
                (IF fedex.cod-emit-frete    <> ? THEN 'Fornecedor: '    + STRING(fedex.cod-emit-frete)                  + CHR(10) ELSE '') +
                (IF fedex.dt-ap-frete       <> ? THEN 'Int: '           + STRING(fedex.dt-ap-frete, '99/99/9999')       + CHR(10) ELSE '') +
                (IF fedex.fatura-frete      <> ? THEN 'Fatura: '        + STRING(fedex.fatura-frete)            + CHR(10) ELSE '') +
                (IF fedex.icms              <> ? THEN 'ICMS: '          + STRING(fedex.icms, '>>>,>>>,>>9.99')  + CHR(10) ELSE '') + CHR(10) +
                ' - IMPOSTOS' + CHR(10) + CHR(10) +
                (IF fedex.duties            <> ? THEN 'Tipo: '          + fedex.duties                          + CHR(10) ELSE '') +
                (IF fedex.valor-imp         <> ? THEN 'Valor: '         + STRING(fedex.valor-imp, '>>>,>>>,>>9.99')     + CHR(10) ELSE '') +
                (IF fedex.dt-emis-imp       <> ? THEN 'Emiss∆o: '       + STRING(fedex.dt-emis-imp, '99/99/9999')       + CHR(10) ELSE '') +
                (IF fedex.dt-venc-imp       <> ? THEN 'Vencimento: '    + STRING(fedex.dt-venc-imp, '99/99/9999')       + CHR(10) ELSE '') +
                (IF fedex.cod-emitente-imp  <> ? THEN 'Fornecedor: '    + STRING(fedex.cod-emitente-imp)        + CHR(10) ELSE '') +
                (IF fedex.dt-ap-imp         <> ? THEN 'Int: '           + STRING(fedex.dt-ap-imp, '99/99/9999') + CHR(10) ELSE '') +
                (IF fedex.fatura-imp        <> ? THEN 'Fatura: '        + STRING(fedex.fatura-imp)              + CHR(10) ELSE '') + CHR(10) +
                (IF fedex.nota              <> ? THEN 'Nota: '          + STRING(fedex.nota)                              ELSE '')
        NO-ERROR.
    
                                                                                                                               
    IF  i-tipo = 1 THEN
        ASSIGN c-txt-aux = 'COURRIER discriminado abaixo foi Recebido/Enviado, favor consult†-lo para maiores informaá‰es.'.


    IF  i-tipo = 2 THEN
        ASSIGN c-txt-aux = 'O COURRIER discriminado abaixo foi Rejeitado. Motiv Rej: ' + STRING(fedex.motivo-rejeicao).


    IF  i-tipo = 3 THEN
        ASSIGN  c-txt-aux = 'O COURRIER discriminado abaixo foi retirado pelo usu†rio: ' + fedex.usuar-retira.

    IF ERROR-STATUS:ERROR THEN
        ASSIGN tt_mail_fax.ttv_nom_message  = c-txt-aux + CHR(10) + CHR(10) +
                (IF usuar_mestre.nom_usuario            <> ? THEN 'Usuario: '       + usuar_mestre.nom_usuario                          + CHR(10) ELSE '') +
                (IF fedex.tipo              <> ? THEN 'Tipo: '          + STRING(fedex.tipo, 'Entrada/Sa°da')   + CHR(10) ELSE '') +
                (IF fedex.data-sol          <> ? THEN 'Data Sol: '      + STRING(fedex.data-sol, '99/99/9999')  + CHR(10) ELSE '') +
                (IF fedex.empresa           <> ? THEN 'Empresa: '       + fedex.empresa                         + CHR(10) ELSE '') +
                (IF fedex.cod_estab         <> ? THEN 'Estab: '         + fedex.cod_estab                       + CHR(10) ELSE '') +
                (IF fedex.material          <> ? THEN 'Material: '      + fedex.material                        + CHR(10) ELSE '') +
                (IF fedex.conhecimento      <> ? THEN 'Conhecimento: '  + fedex.conhecimento                    + CHR(10) ELSE '')
               ERROR-STATUS:ERROR           = NO.

    RUN prgtec\btb\btb916za.py (INPUT "1",
                                INPUT  TABLE tt_mail_fax,
                                OUTPUT TABLE tt_erros_mail_fax).

    /* Erro da API de envio de email ser∆o enviados para um arquivo no diret¢rio tempor†rio */
    IF CAN-FIND(FIRST tt_erros_mail_fax) THEN DO:
        FOR EACH tt_erros_mail_fax NO-LOCK:
            MESSAGE "Erro: "       tt_erros_mail_fax.ttv_cod_erro SKIP
                    "Desc Erro: "  tt_erros_mail_fax.ttv_des_erro SKIP
                VIEW-AS ALERT-BOX WARNING TITLE 'Erros envio de e-mail'.
        END.
        MESSAGE 'Apesar do e-mail n∆o ter sido enviado o COURRIER foi recebido.' VIEW-AS ALERT-BOX INFORMATION.
    END.


    FOR EACH tt_mail_fax:
        DELETE tt_mail_fax.
    END.
    FOR EACH tt_erros_mail_fax:
        DELETE tt_erros_mail_fax.
    END.

    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-print C-Win 
PROCEDURE pi-print :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN esp/apb/esapb022.p.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAlteraNota C-Win 
PROCEDURE piAlteraNota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Definitions of the field level widgets                               */
    DEFINE BUTTON Btn_Cancel AUTO-END-KEY LABEL "Cancel" SIZE 10 BY 1 BGCOLOR 8 .
    DEFINE BUTTON Btn_OK AUTO-GO LABEL "OK" SIZE 10 BY 1 BGCOLOR 8 .

    DEFINE VARIABLE cNr-nota-fis    LIKE fedex.nota NO-UNDO
        VIEW-AS FILL-IN
        SIZE 6 BY .88.

    DEFINE RECTANGLE RECT-38 EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL SIZE 46 BY 2.
    DEFINE RECTANGLE RECT-37 EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 46 BY 1.5 BGCOLOR 7 .


    DEFINE FRAME fNotaFedex
         cNr-nota-fis AT ROW 1.25 COL 15
         Btn_OK AT ROW 3.5 COL 2
         Btn_Cancel AT ROW 3.5 COL 13
         RECT-38 AT ROW 1 COL 1
         RECT-37 AT ROW 3.25 COL 1
         /*SPACE(0.00) SKIP(1.74)*/
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1 TITLE "Nota Fiscal COURRIER"
             DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


    /* ************************  Control Triggers  ************************ */
    ON WINDOW-CLOSE OF FRAME fNotaFedex DO:
        APPLY "END-ERROR":U TO SELF.
    END.

    ON GO OF FRAME fNotaFedex DO:
        DO TRANSACTION:
            FIND CURRENT fedex EXCLUSIVE-LOCK.
            ASSIGN fedex.nota = INPUT FRAME fNotaFedex cNr-nota-fis.
        END.
        FIND CURRENT fedex NO-LOCK.

        RUN piMontaBrowse.
    END.


    /* ***************************  Main Block  *************************** */
    IF NOT AVAILABLE fedex OR BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0 THEN
        RETURN 'NOK'.

    /* Seleciona usu†rio autorizados para alterar nota */
    RUN esp\es0018p.p (INPUT "esacr004", /* Nome do programa */
                       INPUT 5,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    /* ** Localiza pelo grupo relacionado ao usu†rio ***/
    FOR EACH usuar_grp_usuar NO-LOCK
        WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
        FIND tt-prog-ponto 
            WHERE tt-prog-ponto.conteudo = usuar_grp_usuar.cod_grp_usuar NO-ERROR.
        IF AVAIL tt-prog-ponto 
           THEN LEAVE.
    END.
    /* ** Localiza pelo usu†rio ***/
    IF NOT AVAIL tt-prog-ponto 
    THEN DO:
         FIND tt-prog-ponto 
             WHERE tt-prog-ponto.conteudo = v_cod_usuar_corren NO-ERROR.
         IF NOT AVAIL tt-prog-ponto 
         THEN DO:
              MESSAGE "Uso exclusivo do Recebimento" VIEW-AS ALERT-BOX WARNING.
              RETURN 'NOK'.
         END.
    END.

    IF NOT fedex.tipo THEN DO:
        MESSAGE "COURRIER de Saida nao exige Nota" VIEW-AS ALERT-BOX WARNING.
        RETURN 'NOK'.
    END.
    IF NOT fedex.mp THEN DO:
        MESSAGE "COURRIER de consumo nao exige Nota" VIEW-AS ALERT-BOX WARNING.
        RETURN 'NOK'.
    END.
    IF NOT fedex.recebido THEN DO:
        MESSAGE "Este COURRIER aind nao foi Recebido/Enviado" VIEW-AS ALERT-BOX WARNING.
        RETURN 'NOK'.
    END.

    ASSIGN cNr-nota-fis = fedex.nota.

    DISPLAY cNr-nota-fis WITH FRAME fNotaFedex.
    ENABLE cNr-nota-fis Btn_OK Btn_Cancel RECT-37 RECT-38
        WITH FRAME fNotaFedex.
    VIEW FRAME fNotaFedex.
    WAIT-FOR GO OF FRAME fNotaFedex.
    HIDE FRAME fNotaFedex.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAlteraSolicitacao C-Win 
PROCEDURE piAlteraSolicitacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Definitions of the field level widgets                               */
    DEFINE BUTTON Btn_Cancel AUTO-END-KEY LABEL "Cancel" SIZE 10 BY 1 BGCOLOR 8 .
    DEFINE BUTTON Btn_OK AUTO-GO LABEL "OK" SIZE 10 BY 1 BGCOLOR 8 .

    DEFINE RECTANGLE RECT-37 EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 70 BY 1.5 BGCOLOR 7 .
    DEFINE RECTANGLE RECT-38 EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL SIZE 70 BY 12.25.


    DEFINE FRAME fAlteraSolic
         fedex.tipo LABEL 'Tipo'
            VIEW-AS COMBO-BOX INNER-LINES 5
            LIST-ITEM-PAIRS "Entrada",YES,"Sa°da",NO
            DROP-DOWN-LIST SIZE 16 BY .88
            AT ROW 1.17 COL 20 COLON-ALIGNED
         fedex.empresa
            VIEW-AS FILL-IN SIZE 25 BY .88
            AT ROW 2.17 COL 20 COLON-ALIGNED
        fedex.cod_estab LABEL "Estab"
            VIEW-AS FILL-IN SIZE 7 BY .88
            AT ROW 3.17 COL 20 COLON-ALIGNED
         fedex.material
            VIEW-AS FILL-IN SIZE 40 BY .88
            AT ROW 4.17 COL 20 COLON-ALIGNED
         fedex.mp
            VIEW-AS FILL-IN SIZE 5 BY .88
            AT ROW 5.17 COL 20 COLON-ALIGNED
         fedex.ct-codigo
            VIEW-AS FILL-IN SIZE 12 BY .88
            AT ROW 6.17 COL 20 COLON-ALIGNED
         fedex.cc-codigo
            VIEW-AS FILL-IN SIZE 10 BY .88
            AT ROW 7.17 COL 20 COLON-ALIGNED
         fedex.duties LABEL "Impostos"
           VIEW-AS COMBO-BOX INNER-LINES 5
           LIST-ITEM-PAIRS "S - Sender","S","R - Receiver","R","3 - 3os","3"
           DROP-DOWN-LIST SIZE 16 BY .88
           AT ROW 8.17 COL 20 COLON-ALIGNED
         fedex.freight LABEL "Frete"
           VIEW-AS COMBO-BOX INNER-LINES 5
           LIST-ITEM-PAIRS "S - Sender","S","R - Receiver","R","3 - 3os","3"
           DROP-DOWN-LIST SIZE 16 BY .88
           AT ROW 9.17 COL 20 COLON-ALIGNED
         fedex.conhecimento LABEL "Conhecimento"
           VIEW-AS FILL-IN SIZE 20 BY .88
           AT ROW 10.17 COL 20 COLON-ALIGNED
         fedex.cod-transp LABEL "Transportador"
           VIEW-AS FILL-IN SIZE 8 BY .88
           AT ROW 11.17 COL 20 COLON-ALIGNED
         "12267 - RAF / 5055 - FEDEX / 13 - UPS / 5145 - DHL / Outro Transportador"
           AT ROW 12.17 COL 10
         Btn_OK AT ROW 13.75 COL 2
         Btn_Cancel AT ROW 13.75 COL 13
         RECT-38 AT ROW 1 COL 1
         RECT-37 AT ROW 13.5 COL 1
         /*SPACE(0.00) SKIP(1.74)*/
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1 TITLE "Altera dados da solicitaá∆o"
             DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.





    /* ************************  Control Triggers  ************************ */
    ON WINDOW-CLOSE OF FRAME fAlteraSolic DO:
        APPLY "END-ERROR":U TO SELF.
    END.

    ON GO OF FRAME fAlteraSolic DO:

       /* FIND cta_ctbl NO-LOCK
            WHERE cta_ctbl.cod_plano_cta_ctbl = 'Padrao'
              AND cta_ctbl.cod_cta_ctbl       = INPUT FRAME fAlteraSolic fedex.ct-codigo
            NO-ERROR.
        IF NOT AVAILABLE cta_ctbl THEN DO:
            MESSAGE "Conta Cont†bil n∆o encontrada" VIEW-AS ALERT-BOX ERROR.
            RETURN 'NOK'.
        END.
        */

        IF NOT CAN-FIND(estabelecimento NO-LOCK 
                        WHERE estabelecimento.cod_estab = INPUT FRAME fAlteraSolic fedex.cod_estab) THEN DO:
            MESSAGE "Estabelecimento n∆o encontrado"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN "NOK".
        END.

        IF fedex.num-pedido <> 0 THEN DO:
            FIND pedido-compr NO-LOCK
                WHERE pedido-compr.num-pedido = fedex.num-pedido
                NO-ERROR.
            IF AVAIL pedido-compr THEN DO:
                IF fedex.cod_estab:SCREEN-VALUE IN FRAME fAlteraSolic <> pedido-compr.cod-estabel THEN DO:
                    MESSAGE "Estabelecimento informado diferente DO Pedido!" SKIP
                        "Pedido: " + STRING(pedido-compr.num-pedido) SKIP
                        "Estab Informado: " + STRING(fedex.cod_estab:SCREEN-VALUE IN FRAME fAlteraSolic) SKIP
                        "Estab Pedido: " + STRING(pedido-compr.cod-estabel)
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    RETURN "NOK".
                END.
            END.
        END.


        IF NOT CAN-FIND(fedex WHERE fedex.conhecimento = INPUT FRAME fAlteraSolic fedex.conhecimento) THEN DO:
            MESSAGE "COURRIER j† registrado"
                VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.

        DO TRANSACTION:
            FIND CURRENT fedex EXCLUSIVE-LOCK.
            ASSIGN INPUT FRAME fAlteraSolic fedex.duties fedex.freight fedex.conhecimento fedex.cod-transp fedex.cod_estab.
        END.
        FIND CURRENT fedex NO-LOCK.

        RUN piMontaBrowse.
    END.


    /* ***************************  Main Block  *************************** */
    IF NOT AVAILABLE fedex OR BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0 THEN
        RETURN 'NOK'.
/*
    IF (v_cod_usuar_corren <> "adm" AND INTEGER(SUBSTRING(v_cod_usuar_corren,3,6)) <> fedex.cod_usuario) AND
       v_cod_usuar_corren <> "adm" THEN DO:
        MESSAGE "Uso exclusivo do Solicitante" VIEW-AS ALERT-BOX WARNING.
        RETURN 'NOK'.
    END.
*/
    IF fedex.recebido THEN DO:
        MESSAGE "Atená∆o! Este COURRIER ja foi Recebido/Enviado." VIEW-AS ALERT-BOX WARNING.
    END. 

    DISPLAY
         fedex.tipo
         fedex.empresa
         fedex.cod_estab
         fedex.material
         fedex.ct-codigo
         fedex.cc-codigo
         fedex.mp
         fedex.duties
         fedex.freight
         fedex.conhecimento
         fedex.cod-transp
        WITH FRAME fAlteraSolic.

    IF fedex.recebido = YES THEN DO:
        ENABLE fedex.cod_estab
            Btn_OK Btn_Cancel 
            WITH FRAME fAlteraSolic.
    END.
    ELSE DO:
        ENABLE
             fedex.duties
             fedex.freight
             fedex.conhecimento
             fedex.cod-transp
             fedex.cod_estab
             Btn_OK Btn_Cancel RECT-37 RECT-38
            WITH FRAME fAlteraSolic.
    END.
    VIEW FRAME fAlteraSolic.
    WAIT-FOR GO OF FRAME fAlteraSolic.
    HIDE FRAME fAlteraSolic.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaContas C-Win 
PROCEDURE piBuscaContas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEFINE VARIABLE lAchou  AS LOGICAL      NO-UNDO INITIAL NO.

    /* es0008 - Include para busca das contas por programa
       19-12-2002 - Flavio Schoenell */

    FOR EACH conta-programa NO-LOCK
        WHERE conta-programa.programa = 'esacr004.w'
        BY conta-programa.indice:
        ASSIGN cp-ct-codigo[conta-programa.indice] = conta-programa.ct-codigo
               cp-sc-codigo[conta-programa.indice] = conta-programa.sc-codigo
               lAchou = YES.
    END.

    IF NOT lAchou THEN
        MESSAGE 'As contas para o programa ESACR004 n∆o est∆o cadastradas.'
            VIEW-AS ALERT-BOX ERROR TITLE 'Configuraá∆o de contas'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCancelaSolicitacao C-Win 
PROCEDURE piCancelaSolicitacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    /* Definitions of the field level widgets                               */
    DEFINE BUTTON Btn_Cancel AUTO-END-KEY LABEL "Cancel" SIZE 10 BY 1 BGCOLOR 8 .
    DEFINE BUTTON Btn_OK AUTO-GO LABEL "OK" SIZE 10 BY 1 BGCOLOR 8 .

    DEFINE VARIABLE rs-cancela  AS INTEGER INITIAL 1
        VIEW-AS RADIO-SET VERTICAL RADIO-BUTTONS "Frete", 1, "Impostos", 2
        SIZE 12 BY 2 NO-UNDO.

    DEFINE RECTANGLE RECT-33 EDGE-PIXELS 2 GRAPHIC-EDGE NO-FILL SIZE 65 BY 8.25.
    DEFINE RECTANGLE RECT-37 EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 1.5 BGCOLOR 7 .
    DEFINE RECTANGLE RECT-38 EDGE-PIXELS 2 GRAPHIC-EDGE NO-FILL SIZE 65 BY 2.25.
    DEFINE RECTANGLE RECT-39 EDGE-PIXELS 2 GRAPHIC-EDGE NO-FILL SIZE 65 BY 1.25.


    DEFINE FRAME fCancela
        fedex.conhecimento
            VIEW-AS FILL-IN SIZE 25 BY .88
            AT ROW 1.17 COL 25 COLON-ALIGNED
        fedex.dt-emis-frete LABEL 'Emiss∆o'
            VIEW-AS FILL-IN SIZE 10 BY .88
            AT ROW 2.17 COL 25 COLON-ALIGNED
        fedex.dt-venc-frete LABEL 'Vencimento'
            VIEW-AS FILL-IN SIZE 10 BY .88
            AT ROW 3.17 COL 25 COLON-ALIGNED
        fedex.fatura-frete LABEL 'Fatura'
            VIEW-AS FILL-IN SIZE 9 BY .88
            AT ROW 4.17 COL 25 COLON-ALIGNED
        fedex.cod-emit-frete LABEL 'Fornecedor'
            VIEW-AS FILL-IN SIZE 6 BY .88
            AT ROW 5.17 COL 25 COLON-ALIGNED
        fedex.valor-frete LABEL 'Frete'
            VIEW-AS FILL-IN SIZE 11 BY .88
            AT ROW 6.17 COL 25 COLON-ALIGNED
    /*    fedex.icms
            VIEW-AS FILL-IN SIZE 8 BY .88
            AT ROW 7.17 COL 25 COLON-ALIGNED*/
        fedex.ct-codigo
            VIEW-AS FILL-IN SIZE 12 BY .88
            AT ROW 7.17 COL 25 COLON-ALIGNED
        fedex.cc-codigo
            VIEW-AS FILL-IN SIZE 12 BY .88
            AT ROW 8.17 COL 25 COLON-ALIGNED


    /*
        'Frete: ' AT ROW 1 COL 4
         fedex.lancado-frete
            VIEW-AS FILL-IN SIZE 4 BY .88
            AT ROW 6.67 COL 17 COLON-ALIGNED
         fedex.dt-ap-frete
            VIEW-AS FILL-IN SIZE 10 BY .88
             AT ROW 7.67 COL 17 COLON-ALIGNED
        'Impostos: ' AT ROW 1 COL 41
         fedex.dt-emis-imp
            VIEW-AS FILL-IN SIZE 10 BY .88
            AT ROW 1.67 COL 49 COLON-ALIGNED
         fedex.dt-venc-imp
            VIEW-AS FILL-IN SIZE 10 BY .88
            AT ROW 2.67 COL 49 COLON-ALIGNED
         fedex.fatura-imp
            VIEW-AS FILL-IN SIZE 9 BY .88
            AT ROW 3.67 COL 49 COLON-ALIGNED
         fedex.cod-emitente-imp
            VIEW-AS FILL-IN SIZE 6 BY .88
            AT ROW 4.67 COL 49 COLON-ALIGNED
         fedex.valor-imp
            VIEW-AS FILL-IN SIZE 11 BY .88
            AT ROW 5.67 COL 49 COLON-ALIGNED
         fedex.lancado-imp
            VIEW-AS FILL-IN SIZE 4 BY .88
            AT ROW 6.67 COL 49 COLON-ALIGNED
         fedex.dt-ap-imp
            VIEW-AS FILL-IN SIZE 10 BY .88
            AT ROW 7.67 COL 49 COLON-ALIGNED
    */
         "Cancelar:" AT ROW 9.67 COL 15
         rs-cancela AT ROW 9.67 COL 25 NO-LABEL
         fedex.icms
            VIEW-AS FILL-IN
            SIZE 6 BY .88
            AT ROW 12.17 COL 25  COLON-ALIGNED
         Btn_OK AT ROW 13.75 COL 2
         Btn_Cancel AT ROW 13.75 COL 13
         RECT-33 AT ROW 1 COL 1
         RECT-38 AT ROW 9.5 COL 1
         RECT-39 AT ROW 12 COL 1
         RECT-37 AT ROW 13.5 COL 1
         /*SPACE(0.00) SKIP(1.74)*/
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1 TITLE "Cancela COURRIER"
             DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


    /* ************************  Control Triggers  ************************ */
    ON WINDOW-CLOSE OF FRAME fCancela DO:
        APPLY "END-ERROR":U TO SELF.
    END.

    ON GO OF FRAME fCancela DO:
        DO TRANSACTION:
            FIND CURRENT fedex EXCLUSIVE-LOCK.
            IF INPUT FRAME fCancela rs-cancela = 1 THEN
                ASSIGN fedex.dt-emis-frete  = ?
                       fedex.dt-venc-frete  = ?
                       fedex.fatura-frete   = 0
                       fedex.cod-emit-frete = 0
                       fedex.valor-frete    = 0
                       fedex.lancado-frete  = no
                       fedex.dt-ap-frete    = ?.        

            ELSE
                ASSIGN fedex.dt-emis-imp    = ?
                       fedex.dt-venc-imp    = ?
                       fedex.fatura-imp     = 0
                       fedex.cod-emitente-imp  = 0
                       fedex.valor-imp      = 0
                       fedex.lancado-imp    = no 
                       fedex.dt-ap-imp      = ?.        

            ASSIGN INPUT FRAME fCancela fedex.icms.

        END.
        FIND CURRENT fedex NO-LOCK.

        {&OPEN-QUERY-{&BROWSE-NAME}}
    END.


    /* ***************************  Main Block  *************************** */
    IF NOT AVAILABLE fedex OR BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0 THEN
        RETURN 'NOK'.

    /* Seleciona usu†rio autorizados para cancelar solicitaá∆o */
    RUN esp\es0018p.p (INPUT "esacr004", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    /* ** Localiza pelo grupo relacionado ao usu†rio ***/
    FOR EACH usuar_grp_usuar NO-LOCK
        WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
        FIND tt-prog-ponto 
            WHERE tt-prog-ponto.conteudo = usuar_grp_usuar.cod_grp_usuar NO-ERROR.
        IF AVAIL tt-prog-ponto 
           THEN LEAVE.
    END.
    /* ** Localiza pelo usu†rio ***/
    IF NOT AVAIL tt-prog-ponto 
    THEN DO:
         FIND tt-prog-ponto 
             WHERE tt-prog-ponto.conteudo = v_cod_usuar_corren NO-ERROR.
         IF NOT AVAIL tt-prog-ponto 
         THEN DO:
              MESSAGE "Uso exclusivo da Controladoria" VIEW-AS ALERT-BOX WARNING.
              RETURN 'NOK'.
         END.
    END.

    DISPLAY
        fedex.conhecimento
        fedex.dt-emis-frete
        fedex.dt-venc-frete
        fedex.fatura-frete
        fedex.cod-emit-frete
        fedex.valor-frete
        fedex.ct-codigo
        fedex.cc-codigo
        rs-cancela
        fedex.icms
        WITH FRAME fCancela.
    ENABLE rs-cancela fedex.icms Btn_OK Btn_Cancel RECT-37 RECT-38 RECT-39
        WITH FRAME fCancela.
    VIEW FRAME fCancela.
    WAIT-FOR GO OF FRAME fCancela.
    HIDE FRAME fCancela.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregaUnidNegoc C-Win 
PROCEDURE piCarregaUnidNegoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pctCodigo       AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pccCodigo       AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pcListUnidNegoc AS CHARACTER    NO-UNDO INITIAL ''.


    IF pctCodigo = '' THEN
        RETURN.

    IF pccCodigo = '' THEN DO:
        ASSIGN pcListUnidNegoc = 'ADM'.
        RETURN.
    END.

/*
    FIND FIRST criter_distrib_cta_ctbl NO-LOCK
            WHERE criter_distrib_cta_ctbl.cod_plano_cta_ctbl    = 'Padr∆o'
              AND criter_distrib_cta_ctbl.cod_cta_ctbl          = pctCodigo
              AND criter_distrib_cta_ctbl.cod_estab             = '101'
              AND criter_distrib_cta_ctbl.dat_inic_valid       <= TODAY
              AND criter_distrib_cta_ctbl.dat_fim_valid        >= TODAY
        NO-ERROR.

    IF AVAILABLE criter_distrib_cta_ctbl AND
       criter_distrib_cta_ctbl.ind_criter_distrib_ccusto <> 'N∆o utiliza' THEN DO:

        IF criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = 'Utiliza todos' THEN DO:
*/
            FOR EACH ccusto_unid_negoc NO-LOCK
                    WHERE ccusto_unid_negoc.cod_plano_ccusto    = 'Padr∆o'
                      AND ccusto_unid_negoc.cod_ccusto          = pccCodigo:

                ASSIGN pcListUnidNegoc = pcListUnidNegoc + (IF pcListUnidNegoc = '' THEN '' ELSE ',') +
                                         ccusto_unid_negoc.cod_unid_negoc.

            END.
/*
        END.
        ELSE DO:
            FOR EACH mapa_distrib_ccusto NO-LOCK
                    WHERE mapa_distrib_ccusto.cod_estab                 = criter_distrib_cta_ctbl.cod_estab
                      AND mapa_distrib_ccusto.cod_mapa_distrib_ccusto   = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto
                      AND mapa_distrib_ccusto.dat_inic_valid           <= TODAY
                      AND mapa_distrib_ccusto.dat_fim_valid            >= TODAY ,
                FIRST item_lista_ccusto NO-LOCK
                      WHERE item_lista_ccusto.cod_estab                     = mapa_distrib_ccusto.cod_estab
                        AND item_lista_ccusto.cod_mapa_distrib_ccusto       = mapa_distrib_ccusto.cod_mapa_distrib_ccusto
                        AND item_lista_ccusto.cod_plano_ccusto              = 'Padr∆o'
                        AND item_lista_ccusto.cod_ccusto                    = pccCodigo,
                EACH ccusto_unid_negoc NO-LOCK
                      WHERE ccusto_unid_negoc.cod_plano_ccusto = item_lista_ccusto.cod_plano_ccusto
                        AND ccusto_unid_negoc.cod_ccusto = item_lista_ccusto.cod_ccusto :

                FIND FIRST ttUnid_negoc NO-LOCK WHERE ttUnid_negoc.cod_unid_negoc = ccusto_unid_negoc.cod_unid_negoc NO-ERROR.
                IF NOT AVAILABLE ttUnid_negoc THEN DO:
                    CREATE ttUnid_negoc.
                    ASSIGN ttUnid_negoc.cod_unid_negoc = ccusto_unid_negoc.cod_unid_negoc.
                END.

            END.

            FOR EACH ttUnid_negoc:
                ASSIGN pcListUnidNegoc = pcListUnidNegoc + (IF pcListUnidNegoc = '' THEN '' ELSE ',') +
                                         ttUnid_negoc.cod_unid_negoc.
                DELETE ttUnid_negoc.
            END.

        END.

    END.
*/
    RETURN 'OK'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCria-AP C-Win 
PROCEDURE piCria-AP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cCod_unid_negoc         AS CHARACTER    NO-UNDO INITIAL ''.
    DEFINE VARIABLE cCod_tip_fluxo_financ   AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cCod_portador           AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cNome-emit              AS CHARACTER    NO-UNDO.
    
    DEF VAR vembarque AS CHAR.

    DEFINE VARIABLE v_cod_refer_impl AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE v_num_aux_2 AS INTEGER    NO-UNDO.
    DEFINE VARIABLE v_num_cont  AS INTEGER    NO-UNDO.
    DEFINE VARIABLE v_num_aux   AS INTEGER    NO-UNDO.

    DEF VAR v_tot_rat   AS DEC NO-UNDO.
    DEF VAR v_tot_aprop AS DEC NO-UNDO.

    RUN piZeraTemp-tables IN THIS-PROCEDURE.

    ASSIGN v_tot_rat = 0.
    FOR EACH fedex-rateio OF fedex NO-LOCK:
        ASSIGN v_tot_rat = v_tot_rat + fedex-rateio.perc_aprop_ctbl.
    END.
    IF  v_tot_rat <> 100
    THEN DO:
         MESSAGE "T°tulo n∆o foi rateado totalmente"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN "NOK".
    END.

    FIND LAST tit_ap NO-LOCK
        WHERE tit_ap.cod_empresa      = v_cod_empres_usuar
          AND tit_ap.cod_estab        = fedex.cod_estab
          AND tit_ap.cod_espec_docto  = c-especie
          AND tit_ap.cod_ser_docto    = "U"
          AND tit_ap.cod_tit_ap       = c-nr-docto
          AND tit_ap.cdn_fornec       = iCod-emit-lanc
        NO-ERROR.
    IF NOT AVAILABLE tit_ap THEN
        ASSIGN c-parcela = "01".
    ELSE
        ASSIGN c-parcela = STRING(INTEGER(tit_ap.cod_parcela) + 1,"99").


    /*Calcula referencia automatica*/
    ASSIGN v_cod_refer_impl = 'F' + substring(STRING(YEAR(today)),3,2)
                                      + STRING(MONTH(TODAY), '99')
                                      + STRING(DAY  (TODAY), '99').

    ASSIGN v_num_aux_2 = INTEGER(THIS-PROCEDURE:HANDLE).
    REPEAT:       
        DO v_num_cont = 1 to 3:
            ASSIGN v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
                   v_cod_refer_impl = v_cod_refer_impl + chr(v_num_aux).
        END.

        FIND FIRST movto_tit_ap NO-LOCK
            WHERE movto_tit_ap.cod_estab   = tit_acr.cod_estab
              AND movto_tit_ap.cod_refer = v_cod_refer_impl
            NO-ERROR.
        IF NOT AVAILABLE movto_tit_ap THEN
            LEAVE.
    END.


    FIND fornec_financ NO-LOCK
        WHERE fornec_financ.cod_empresa = v_cod_empres_usuar
          AND fornec_financ.cdn_fornecedor = iCod-emit-lanc
        NO-ERROR.
    IF AVAILABLE fornec_financ THEN DO:
        ASSIGN cCod_portador         = fornec_financ.cod_portador
               cCod_tip_fluxo_financ = fornec_financ.cod_tip_fluxo_financ.
    END.


    ASSIGN cNome-emit = ''.

    FIND emscad.fornecedor NO-LOCK
        WHERE fornecedor.cod_empresa = v_cod_empres_usuar
          AND fornecedor.cdn_fornecedor = iCod-emit-lanc
        NO-ERROR.
    IF AVAILABLE fornecedor THEN DO:
        FIND pessoa_jurid NO-LOCK WHERE pessoa_jurid.num_pessoa_jurid = fornecedor.num_pessoa NO-ERROR.
        IF AVAILABLE pessoa_jurid THEN
            ASSIGN cNome-emit = pessoa_jurid.nom_pessoa.
    END.
    IF cNome-emit = '' THEN
        ASSIGN cNome-emit = 'Cod. ' + STRING(iCod-emit-lanc).

    RUN pi-verifica-embarque (INPUT fedex.conhecimento,
                              OUTPUT vembarque).

    DO TRANSACTION ON ERROR UNDO, RETURN 'NOK':

        CREATE tt_integr_apb_lote_impl.
        ASSIGN tt_integr_apb_lote_impl.tta_cod_refer                = v_cod_refer_impl
               tt_integr_apb_lote_impl.tta_dat_transacao            = TODAY
               tt_integr_apb_lote_impl.tta_ind_origin_tit_ap        = 'APB'
               tt_integr_apb_lote_impl.tta_cod_estab                = fedex.cod_estab
               tt_integr_apb_lote_impl.tta_val_tot_lote_impl_tit_ap = 0
               tt_integr_apb_lote_impl.ttv_cod_empresa              = v_cod_empres_usuar
               tt_integr_apb_lote_impl.tta_cod_indic_econ           = 'Real'
               /*tt_integr_apb_lote_impl.tta_cod_espec_docto          = c-especie*/ .

        CREATE tt_integr_apb_item_lote_impl_2.
        ASSIGN tt_integr_apb_item_lote_impl_2.ttv_rec_integr_apb_lote_impl  =  RECID(tt_integr_apb_lote_impl)
               tt_integr_apb_item_lote_impl_2.ttv_rec_integr_apb_item_lote  =  RECID(tt_integr_apb_item_lote_impl_2)
               tt_integr_apb_item_lote_impl_2.tta_num_seq_refer             =  1
               tt_integr_apb_item_lote_impl_2.tta_cdn_fornecedor            =  iCod-emit-lanc
               tt_integr_apb_item_lote_impl_2.tta_cod_espec_docto           =  c-especie
               tt_integr_apb_item_lote_impl_2.tta_cod_ser_docto             =  'U'
               tt_integr_apb_item_lote_impl_2.tta_cod_tit_ap                =  c-nr-docto
               tt_integr_apb_item_lote_impl_2.tta_cod_parcela               =  c-parcela
               tt_integr_apb_item_lote_impl_2.tta_dat_emis_docto            =  da-dt-emis
               tt_integr_apb_item_lote_impl_2.tta_dat_vencto_tit_ap         =  da-dt-venc
               tt_integr_apb_item_lote_impl_2.tta_dat_prev_pagto            =  da-dt-venc
               tt_integr_apb_item_lote_impl_2.tta_dat_desconto              =  ?
               tt_integr_apb_item_lote_impl_2.tta_cod_indic_econ            =  'Real'
               tt_integr_apb_item_lote_impl_2.tta_val_tit_ap                =  de-valor
               tt_integr_apb_item_lote_impl_2.tta_val_desconto              =  0
               tt_integr_apb_item_lote_impl_2.tta_num_dias_atraso           =  0
               tt_integr_apb_item_lote_impl_2.tta_val_juros_dia_atraso      =  0
               tt_integr_apb_item_lote_impl_2.tta_val_perc_juros_dia_atraso =  0
               tt_integr_apb_item_lote_impl_2.tta_val_perc_multa_atraso     =  0
               tt_integr_apb_item_lote_impl_2.tta_cod_portad_ext            =  '999'
               tt_integr_apb_item_lote_impl_2.tta_cod_modalid_ext           =  '0'
               tt_integr_apb_item_lote_impl_2.tta_des_text_histor           =  'FEDEX: ' + STRING(fedex.numero) +
                                                                               '  T°tulo: ' + c-nr-docto +
                                                                               '  Empresa: ' + fedex.empresa +
                                                                               '  Conhecimento: ' + fedex.conhecimento +
                                                                               '  Embarque: ' + vembarque +
                                                                               '  SDCVs: ' + fedex.desc-sdcv.
        
        ASSIGN v_tot_aprop = 0.
        FOR EACH fedex-rateio OF fedex NO-LOCK:

            CREATE tt_integr_apb_aprop_ctbl_pend.
            ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote     = RECID(tt_integr_apb_item_lote_impl_2)
                   tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend         = 0
                   tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend    = 0
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl           = "PADRAO"
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl                 = fedex-rateio.cod_cta_ctbl
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc               = fedex-rateio.cod_unid_negoc
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto             = "PADRAO"
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                   = fedex-rateio.cod_ccusto
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ         = cCod_tip_fluxo_financ
                   tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl               = ROUND((de-valor-mov * fedex-rateio.perc_aprop_ctbl / 100), 2)
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_pais                     = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_federac             = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto                  = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto            = ""
                   tt_integr_apb_aprop_ctbl_pend.ttv_cod_tip_fluxo_financ_ext     = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl_ext             = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_sub_cta_ctbl_ext         = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto_ext               = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc_ext           = ""
                   v_tot_aprop                                                    = v_tot_aprop + tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl.

        END.

        /* ** Marreta ***/
        IF v_tot_aprop <> de-valor-mov 
        THEN DO:
             FIND FIRST tt_integr_apb_aprop_ctbl_pend
                  WHERE tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote = RECID(tt_integr_apb_item_lote_impl_2).
             ASSIGN tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl = tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl + (de-valor-mov - v_tot_aprop).
        END.

        /********* PARA OS DOCUMENTOS DE FRETE, O SISTEMA N«O GERA RATEIO
                   ESTE RATEIO S‡ ê UTILIZADO PARA OS DOCUMENTOS DE IMPOSTOS *******/

        IF fedex.icms <> 0 AND c-tp-lancto <> "Frete" THEN DO:
            CREATE tt_integr_apb_aprop_ctbl_pend.
            ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote     = RECID(tt_integr_apb_item_lote_impl_2)
                   tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend         = 0
                   tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend    = 0
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl           = "PADRAO"
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl                 = cp-ct-codigo[2]
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc               = "ADM" 
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto             = "PADRAO"
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                   = cp-sc-codigo[2]
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ         = cCod_tip_fluxo_financ /* Alterado para gerar o rateio no mesmo fluxo do imposto - chamado: 120302 */
                   tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl               = fedex.icms
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_pais                     = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_federac             = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto                  = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto            = ""
                   tt_integr_apb_aprop_ctbl_pend.ttv_cod_tip_fluxo_financ_ext     = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl_ext             = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_sub_cta_ctbl_ext         = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto_ext               = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc_ext           = "".
        END.

        RELEASE tt_integr_apb_lote_impl.
        RELEASE tt_integr_apb_item_lote_impl_2.
        RELEASE tt_integr_apb_aprop_ctbl_pend.
    

        RUN prgfin/apb/apb900zd.py (INPUT 3,
                                    INPUT 'EMS',
                                    INPUT-OUTPUT TABLE tt_integr_apb_item_lote_impl_2).
    END.

    FOR EACH tt_log_erros_atualiz NO-LOCK:
        MESSAGE tt_log_erros_atualiz.ttv_num_mensagem SKIP
                tt_log_erros_atualiz.ttv_des_msg_erro SKIP
                tt_log_erros_atualiz.ttv_des_msg_ajuda
            VIEW-AS ALERT-BOX ERROR TITLE 'Erro na criaá∆o do T°tulo do Contas a Pagar'.
    END.

    IF CAN-FIND(FIRST tt_log_erros_atualiz) THEN
        RETURN 'NOK'.
    ELSE
        RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEncerraSolicitacao C-Win 
PROCEDURE piEncerraSolicitacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE l-conf  AS LOGICAL      NO-UNDO INITIAL NO.

    IF NOT AVAILABLE fedex OR BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0 THEN
        RETURN 'NOK'.

    /* Seleciona usu†rio autorizados para cancelar solicitaá∆o */
    RUN esp\es0018p.p (INPUT "esacr004", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
    /* ** Localiza pelo grupo relacionado ao usu†rio ***/
    FOR EACH usuar_grp_usuar NO-LOCK
        WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
        FIND tt-prog-ponto 
            WHERE tt-prog-ponto.conteudo = usuar_grp_usuar.cod_grp_usuar NO-ERROR.
        IF AVAIL tt-prog-ponto 
           THEN LEAVE.
    END.
    /* ** Localiza pelo usu†rio ***/
    IF NOT AVAIL tt-prog-ponto 
    THEN DO:
         FIND tt-prog-ponto 
             WHERE tt-prog-ponto.conteudo = v_cod_usuar_corren NO-ERROR.
         IF NOT AVAIL tt-prog-ponto 
         THEN DO:
              MESSAGE "Uso exclusivo do Compras" VIEW-AS ALERT-BOX WARNING.
              RETURN 'NOK'.
         END.
    END.

    IF fedex.encerrado THEN DO:
        MESSAGE 'Solicitaá∆o j† est† encerrada' VIEW-AS ALERT-BOX WARNING.
        RETURN 'NOK'.
    END.
    
    MESSAGE "Confirma encerramento da solicitacao" VIEW-AS ALERT-BOX
        QUESTION BUTTONS YES-NO UPDATE l-conf.
    IF l-conf THEN DO:
        DO TRANSACTION:
            FIND CURRENT fedex EXCLUSIVE-LOCK.
            ASSIGN fedex.encerrado = YES.
        END.
        FIND CURRENT fedex NO-LOCK.

        RUN piMontaBrowse.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExcluiSolicitacao C-Win 
PROCEDURE piExcluiSolicitacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE l-conf  AS LOGICAL      NO-UNDO INITIAL NO.

    IF NOT AVAILABLE fedex OR BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0 THEN
        RETURN 'NOK'.

    /* Seleciona usu†rio autorizados para excluir */
    RUN esp\es0018p.p (INPUT "esacr004", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
    /* ** Localiza pelo grupo relacionado ao usu†rio ***/
    FOR EACH usuar_grp_usuar NO-LOCK
        WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
        FIND tt-prog-ponto 
            WHERE tt-prog-ponto.conteudo = usuar_grp_usuar.cod_grp_usuar NO-ERROR.
        IF AVAIL tt-prog-ponto 
           THEN LEAVE.
    END.
    /* ** Localiza pelo usu†rio ***/
    IF NOT AVAIL tt-prog-ponto 
    THEN DO:
         FIND tt-prog-ponto 
             WHERE tt-prog-ponto.conteudo = v_cod_usuar_corren NO-ERROR.
         IF NOT AVAIL tt-prog-ponto 
         THEN DO:
              MESSAGE "Uso exclusivo do Compras" VIEW-AS ALERT-BOX WARNING.
              RETURN 'NOK'.
         END.
    END.

    /* Seleciona usu†rio autorizados para COURIER Recebido/Enviado */
    RUN esp\es0018p.p (INPUT "esacr004", /* Nome do programa */
                       INPUT 2,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
    /* ** Localiza pelo grupo relacionado ao usu†rio ***/
    FOR EACH usuar_grp_usuar NO-LOCK
        WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
        FIND tt-prog-ponto 
            WHERE tt-prog-ponto.conteudo = usuar_grp_usuar.cod_grp_usuar NO-ERROR.
        IF AVAIL tt-prog-ponto 
           THEN LEAVE.
    END.
    /* ** Localiza pelo usu†rio ***/
    IF NOT AVAIL tt-prog-ponto 
    THEN DO:
         FIND tt-prog-ponto 
             WHERE tt-prog-ponto.conteudo = v_cod_usuar_corren NO-ERROR.
         IF  NOT AVAIL tt-prog-ponto 
         AND fedex.recebido
         THEN DO:
              MESSAGE "Uso exclusivo do Compras" VIEW-AS ALERT-BOX WARNING.
              RETURN 'NOK'.
         END.
    END.

    MESSAGE "Confirma exclus∆o da solicitaá∆o" VIEW-AS ALERT-BOX
        QUESTION BUTTONS YES-NO UPDATE l-conf.
    
    IF l-conf THEN DO:
        DO TRANSACTION:
            FIND CURRENT fedex EXCLUSIVE-LOCK.

            IF  fedex.lancado-imp = YES THEN DO:
                MESSAGE "Impostos j† foram lanáados. Exclus∆o n∆o ser† permitida !" VIEW-AS ALERT-BOX WARNING.
                RETURN 'NOK'.
            END.
            
            IF  fedex.lancado-frete = YES THEN DO:
                MESSAGE "Frete j† foi lanáado. Exclus∆o n∆o ser† permitida !" VIEW-AS ALERT-BOX WARNING.
                RETURN 'NOK'.
            END.

            DELETE fedex.
        END.
        RUN piMontaBrowse.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piIntegraFreteAP C-Win 
PROCEDURE piIntegraFreteAP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cListaUnidNegoc AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cNom_pessoa AS CHARACTER FORMAT "X(256)":U 
         VIEW-AS FILL-IN 
         SIZE 40.5 BY .88 NO-UNDO.
    DEFINE VARIABLE cDesc_cta AS CHARACTER FORMAT "X(256)":U 
         VIEW-AS FILL-IN 
         SIZE 34.5 BY .88 NO-UNDO.
    DEFINE VARIABLE cDesc_ccusto AS CHARACTER FORMAT "X(256)":U 
         VIEW-AS FILL-IN 
         SIZE 34.5 BY .88 NO-UNDO.
    DEFINE VARIABLE tgGeraTitAP AS LOGICAL NO-UNDO INITIAL YES
        VIEW-AS TOGGLE-BOX LABEL 'Gera T°tulo no Contas a Pagar'.
    DEFINE VARIABLE tgviracopos AS LOGICAL NO-UNDO INITIAL YES
        VIEW-AS TOGGLE-BOX LABEL 'Viracopos'.
    DEFINE VARIABLE tgEncerraProc AS LOGICAL NO-UNDO INITIAL YES
        VIEW-AS TOGGLE-BOX LABEL 'Encerrar processo'.

    /* Definitions of the field level widgets                               */
    DEFINE BUTTON Btn_Cancel AUTO-END-KEY LABEL "Cancel" SIZE 10 BY 1 BGCOLOR 8 .
    DEFINE BUTTON Btn_OK AUTO-GO LABEL "OK" SIZE 10 BY 1 BGCOLOR 8 .
    DEFINE BUTTON Btn_rateio LABEL "Rateio" SIZE 10 BY 1 BGCOLOR 8 .

    DEFINE RECTANGLE rtBody EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 71 BY 1.5 BGCOLOR 7 .
    DEFINE RECTANGLE rtBtBar EDGE-PIXELS 2 GRAPHIC-EDGE NO-FILL SIZE 71 BY 13.25.


    DEFINE FRAME fFreteCP
        fedex.conhecimento
            VIEW-AS FILL-IN SIZE 25 BY .88
            AT ROW 1.17 COL 21 COLON-ALIGNED
        fedex.dt-emis-frete LABEL 'Emiss∆o'
            VIEW-AS FILL-IN SIZE 10 BY .88
            AT ROW 2.17 COL 21 COLON-ALIGNED
        fedex.dt-venc-frete LABEL 'Vencimento'
            VIEW-AS FILL-IN SIZE 10 BY .88
            AT ROW 3.17 COL 21 COLON-ALIGNED
        fedex.fatura-frete LABEL 'Fatura'
            VIEW-AS FILL-IN SIZE 9 BY .88
            AT ROW 4.17 COL 21 COLON-ALIGNED
        fedex.cod-emit-frete LABEL 'Fornecedor'
            VIEW-AS FILL-IN SIZE 6 BY .88
            AT ROW 5.17 COL 21 COLON-ALIGNED
        cNom_pessoa AT ROW 5.17 COL 27.5 COLON-ALIGNED NO-LABEL
        "12267 - RAF / 5055 - FEDEX / 13 - UPS / 5145 - DHL / Outro Transportador" VIEW-AS TEXT
             SIZE 55.43 BY .54 AT ROW 6.3 COL 15
        fedex.valor-frete LABEL 'Frete'
            VIEW-AS FILL-IN SIZE 11 BY .88
            AT ROW 7.17 COL 21 COLON-ALIGNED
        fedex.icms
            VIEW-AS FILL-IN SIZE 11 BY .88
            AT ROW 8.17 COL 21 COLON-ALIGNED
        btn_rateio AT ROW 9.67 COL 23
        tgGeraTitAP AT ROW 11.17 COL 21
        tgEncerraProc AT ROW 12.17 COL 21
        Btn_OK AT ROW 13.75 COL 2
        Btn_Cancel AT ROW 13.75 COL 13
        rtBtBar AT ROW 1 COL 1
        rtBody AT ROW 13.5 COL 1
         /*SPACE(0.00) SKIP(1.74)*/
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1 TITLE "Frete AP"
             DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


    /* ************************  Control Triggers  ************************ */
    ON WINDOW-CLOSE OF FRAME fFreteCP DO:
        APPLY "END-ERROR":U TO SELF.
    END.

    ON CHOOSE OF btn_rateio IN FRAME fFreteCP DO:

        RUN esp/acr/esacr004f.p(fedex.numero,
                                dec(fedex.valor-frete:screen-value in frame fFreteCP)).

    END.

    ON 'F5':U OF fedex.cod-emit-frete IN FRAME fFreteCP OR
       'MOUSE-SELECT-DBLCLICK' OF fedex.cod-emit-frete IN FRAME fFreteCP DO:

        if  search("prgint/utb/utb031nb.r") = ? and search("prgint/utb/utb031nb.p") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb033na.p".
            else do:
                message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb033na.p"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run prgint/utb/utb031nb.p.

        if v_rec_fornecedor <> ? then do:
            assign cNom_pessoa  = ''.
            find emscad.fornecedor where recid(fornecedor) = v_rec_fornecedor no-lock no-error.
            IF AVAILABLE fornecedor THEN DO:
                ASSIGN fedex.cod-emit-frete:screen-value in frame fFreteCP = string(fornecedor.cdn_fornecedor)
                       cNom_pessoa = fornecedor.nom_pessoa.
            END.
            display cNom_pessoa with frame fFreteCP.
        end /* if */.

        RETURN.
    END.

    ON LEAVE OF fedex.cod-emit-frete IN FRAME fFreteCP DO:
        assign cNom_pessoa  = ''.
        find emscad.fornecedor no-lock
            where fornecedor.cod_empresa = v_cod_empres_usuar
              and fornecedor.cdn_fornecedor = INPUT FRAME fFreteCP fedex.cod-emit-frete
            no-error.

        IF AVAILABLE fornecedor THEN
            ASSIGN cNom_pessoa = fornecedor.nom_pessoa.

        display cNom_pessoa with frame fFreteCP.
        RETURN.
    END.

    ON LEAVE OF fedex.conhecimento IN FRAME fFreteCP DO:

        DEF VAR vembarque AS CHAR.

        RUN pi-verifica-embarque (INPUT INPUT FRAME fFreteCP fedex.conhecimento,
                                  OUTPUT vembarque).

        
        IF vembarque <> "" 
        THEN DO:
             MESSAGE "Embarque " vembarque " !"
                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        
        /*
        IF vembarque <> "" 
        THEN DO:
             ASSIGN tgGeraTitAP = NO
                    tgviracopos = YES.
             DISPLAY tgGeraTitAP WITH FRAME fFreteCP.
             DISABLE tgGeraTitAP WITH FRAME fFreteCP.
             MESSAGE "Embarque " vembarque " realizado em Viracopos, n∆o ir† gerar t°tulo no contas a pagar pelo Courrier !"
                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        ELSE DO:
             ASSIGN tgGeraTitAP = YES
                    tgviracopos = NO.
             DISPLAY tgGeraTitAP WITH FRAME fFreteCP.
             ENABLE tgGeraTitAP WITH FRAME fFreteCP.
        END.*/

    END.

    ON GO OF FRAME fFreteCP DO:

        integra_frete:
        DO TRANSACTION:
            FIND CURRENT fedex EXCLUSIVE-LOCK.

            ASSIGN INPUT FRAME fFreteCP
                tgGeraTitAP 
                tgEncerraProc
                fedex.conhecimento
                fedex.dt-emis-frete
                fedex.dt-venc-frete
                fedex.fatura-frete
                fedex.cod-emit-frete
                fedex.valor-frete
                fedex.icms.

            IF tgGeraTitAP THEN DO:

                ASSIGN c-especie        = "DP"
                       c-nr-docto       = string(trim(INPUT FRAME fFreteCP fedex.fatura-frete)) /* Alterado conforme chamado 107779 - SUBSTRING(TRIM(INPUT FRAME fFreteCP fedex.conhecimento),LENGTH(TRIM(INPUT FRAME fFreteCP fedex.conhecimento)) - 7,8)  */
                       da-dt-emis       = INPUT FRAME fFreteCP fedex.dt-emis-frete
                       da-dt-venc       = INPUT FRAME fFreteCP fedex.dt-venc-frete
                       de-valor         = INPUT FRAME fFreteCP fedex.valor-frete
                       de-valor-mov     = INPUT FRAME fFreteCP fedex.valor-frete /*  - INPUT FRAME fFreteCP fedex.icms */
                       iCod-emit-lanc   = INPUT FRAME fFreteCP fedex.cod-emit-frete
                       c-tp-lancto      = "Frete".

                RUN piCria-AP IN THIS-PROCEDURE.
                IF RETURN-VALUE = 'NOK' THEN
                    UNDO integra_frete, RETURN NO-APPLY.

                ASSIGN fedex.lancado-frete = YES
                       fedex.dt-ap-frete   = TODAY.

            END.

            /* ** Viracopos n∆o gera t°tulo no APB mas marca frete como lanáado ***
            IF tgviracopos THEN
               ASSIGN fedex.lancado-frete = YES
                      fedex.dt-ap-frete   = TODAY. **/

            IF tgEncerraProc THEN
                ASSIGN fedex.encerrado = YES.
        END.

        FIND CURRENT fedex NO-LOCK.

        RUN piMontaBrowse.
    END.


    /* ***************************  Main Block  *************************** */
    IF NOT AVAILABLE fedex OR BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0 THEN
        RETURN 'NOK'.
    
    IF  fedex.freight = "S"
    AND fedex.tipo
    THEN DO:
         MESSAGE "VERIFICAR: Pagamento do Frete indicado como SENDER !" SKIP
             VIEW-AS ALERT-BOX INFORMATION.
    END.

    /* Seleciona usu†rio autorizados para Integrar frete */
    RUN esp\es0018p.p (INPUT "esacr004", /* Nome do programa */
                       INPUT 3,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
    /* ** Localiza pelo grupo relacionado ao usu†rio ***/
    FOR EACH usuar_grp_usuar NO-LOCK
        WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
        FIND tt-prog-ponto 
            WHERE tt-prog-ponto.conteudo = usuar_grp_usuar.cod_grp_usuar NO-ERROR.
        IF AVAIL tt-prog-ponto 
           THEN LEAVE.
    END.
    /* ** Localiza pelo usu†rio ***/
    IF NOT AVAIL tt-prog-ponto 
    THEN DO:
         FIND tt-prog-ponto 
             WHERE tt-prog-ponto.conteudo = v_cod_usuar_corren NO-ERROR.
         IF NOT AVAIL tt-prog-ponto 
         THEN DO:
              MESSAGE "Uso exclusivo da Controladoria" VIEW-AS ALERT-BOX WARNING.
              RETURN 'NOK'.
         END.
    END.

    IF NOT fedex.recebido THEN DO:
        MESSAGE "Este COURRIER ainda nao foi Recebido/Enviado" VIEW-AS ALERT-BOX ERROR.
        RETURN 'NOK'.
    END.
    IF fedex.lancado-frete THEN DO:
        MESSAGE "COURRIER ja integrado com AP. Nao pode ser alterado" VIEW-AS ALERT-BOX ERROR.
        RETURN 'NOK'.
    END.

    /* ** Courrier cadastrado antes da criaá∆o da tabela fedex-ratio ***/
    DO TRANSACTION:
        IF NOT CAN-FIND (FIRST fedex-rateio OF fedex) 
        THEN DO:
             CREATE fedex-rateio.
             ASSIGN fedex-rateio.numero             = fedex.numero
                    fedex-rateio.cod_plano_cta_ctbl = "PADRAO"
                    fedex-rateio.cod_unid_negoc     = "ADM"
                    fedex-rateio.perc_aprop_ctbl    = 100.
             IF fedex.mp 
                THEN ASSIGN fedex-rateio.cod_cta_ctbl = cp-ct-codigo[1]
                            fedex-rateio.cod_ccusto   = cp-sc-codigo[1] .
                ELSE ASSIGN fedex-rateio.cod_cta_ctbl = fedex.ct-codigo
                            fedex-rateio.cod_ccusto   = fedex.cc-codigo.
             IF fedex-rateio.cod_ccusto <> "" 
                THEN ASSIGN fedex-rateio.cod_plano_ccusto = "PADRAO".
        END.
    END.

    DISPLAY
        fedex.conhecimento
        fedex.dt-emis-frete
        fedex.dt-venc-frete
        fedex.fatura-frete
        fedex.cod-emit-frete
        fedex.valor-frete
        fedex.icms
        tgGeraTitAP
        tgEncerraProc
       WITH FRAME fFreteCP.
    ENABLE 
        fedex.conhecimento
        fedex.dt-emis-frete
        fedex.dt-venc-frete
        fedex.fatura-frete
        fedex.cod-emit-frete 
        fedex.valor-frete
        btn_rateio
        tgGeraTitAP
        tgEncerraProc
        Btn_OK Btn_Cancel
       WITH FRAME fFreteCP.

    IF fedex.icms = 0 THEN
        ENABLE fedex.icms WITH FRAME fFreteCP.

    /* ** Tratamento para sempre gerar AP ***/
    ASSIGN tgGeraTitAP = YES.
    DISPLAY tgGeraTitAP WITH FRAME fFreteCP.
    DISABLE tgGeraTitAP WITH FRAME fFreteCP.

    VIEW FRAME fFreteCP.
    WAIT-FOR GO OF FRAME fFreteCP.
    HIDE FRAME fFreteCP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piIntegraImpAP C-Win 
PROCEDURE piIntegraImpAP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cListaUnidNegoc AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cNom_pessoa AS CHARACTER FORMAT "X(256)":U 
         VIEW-AS FILL-IN 
         SIZE 40.5 BY .88 NO-UNDO.
    DEFINE VARIABLE cDesc_cta AS CHARACTER FORMAT "X(256)":U 
         VIEW-AS FILL-IN 
         SIZE 34.5 BY .88 NO-UNDO.
    DEFINE VARIABLE cDesc_ccusto AS CHARACTER FORMAT "X(256)":U 
         VIEW-AS FILL-IN 
         SIZE 34.5 BY .88 NO-UNDO.
    DEFINE VARIABLE tgGeraTitAP AS LOGICAL NO-UNDO INITIAL YES
        VIEW-AS TOGGLE-BOX LABEL 'Gera T°tulo no Contas a Pagar'.
    DEFINE VARIABLE tgviracopos AS LOGICAL NO-UNDO INITIAL YES
        VIEW-AS TOGGLE-BOX LABEL 'Viracopos'.
    DEFINE VARIABLE tgEncerraProc AS LOGICAL NO-UNDO INITIAL YES
        VIEW-AS TOGGLE-BOX LABEL 'Encerrar processo'.

    /* Definitions of the field level widgets                               */
    DEFINE BUTTON Btn_Cancel AUTO-END-KEY LABEL "Cancel" SIZE 10 BY 1 BGCOLOR 8 .
    DEFINE BUTTON Btn_OK AUTO-GO LABEL "OK" SIZE 10 BY 1 BGCOLOR 8 .
    DEFINE BUTTON Btn_rateio LABEL "Rateio" SIZE 10 BY 1 BGCOLOR 8 .

    DEFINE RECTANGLE rtBody EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 71 BY 1.5 BGCOLOR 7 .
    DEFINE RECTANGLE rtBtBar EDGE-PIXELS 2 GRAPHIC-EDGE NO-FILL SIZE 71 BY 13.25.


    DEFINE FRAME fImpCP
        fedex.conhecimento
            VIEW-AS FILL-IN SIZE 21 BY .88
            AT ROW 1.17 COL 21 COLON-ALIGNED
        fedex.dt-emis-imp LABEL 'Emiss∆o'
            VIEW-AS FILL-IN SIZE 10 BY .88
            AT ROW 2.17 COL 21 COLON-ALIGNED
        fedex.dt-venc-imp LABEL 'Vencimento'
            VIEW-AS FILL-IN SIZE 10 BY .88
            AT ROW 3.17 COL 21 COLON-ALIGNED
        fedex.fatura-imp LABEL 'Fatura'
            VIEW-AS FILL-IN SIZE 9 BY .88
            AT ROW 4.17 COL 21 COLON-ALIGNED
        fedex.cod-emitente-imp LABEL 'Fornecedor'
            VIEW-AS FILL-IN SIZE 6 BY .88
            AT ROW 5.17 COL 21 COLON-ALIGNED
        cNom_pessoa AT ROW 5.17 COL 27.5 COLON-ALIGNED NO-LABEL
        "12267 - RAF / 5055 - FEDEX / 13 - UPS / 5145 - DHL / Outro Transportador" VIEW-AS TEXT
             SIZE 55.43 BY .54 AT ROW 6.3 COL 15
        fedex.valor-imp LABEL 'Impostos'
            VIEW-AS FILL-IN SIZE 11 BY .88
            AT ROW 7.17 COL 21 COLON-ALIGNED
        fedex.icms
            VIEW-AS FILL-IN SIZE 11 BY .88
            AT ROW 8.17 COL 21 COLON-ALIGNED
        fedex.dt-venc-icms
            VIEW-AS FILL-IN SIZE 11 BY .88
            AT ROW 8.17 COL 42 COLON-ALIGNED
        fedex.num-sat
            VIEW-AS FILL-IN SIZE 11 BY .88
            AT ROW 9.17 COL 21 COLON-ALIGNED
        btn_rateio AT ROW 10.57 COL 23
        tgGeraTitAP AT ROW 11.87 COL 21
        tgEncerraProc AT ROW 12.67 COL 21
        Btn_OK AT ROW 13.75 COL 2
        Btn_Cancel AT ROW 13.75 COL 13
        rtBtBar AT ROW 1 COL 1
        rtBody AT ROW 13.5 COL 1
        /*SPACE(0.00) SKIP(1.74)*/
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1 TITLE "Imp AP"
             DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


    /* ************************  Control Triggers  ************************ */
    ON WINDOW-CLOSE OF FRAME fImpCP DO:
        APPLY "END-ERROR":U TO SELF.
    END.

    ON 'F5':U OF fedex.cod-emitente-imp IN FRAME fImpCP OR
       'MOUSE-SELECT-DBLCLICK' OF fedex.cod-emitente-imp IN FRAME fImpCP DO:

        if  search("prgint/utb/utb031nb.r") = ? and search("prgint/utb/utb031nb.p") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb033na.p".
            else do:
                message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb033na.p"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run prgint/utb/utb031nb.p.

        if v_rec_fornecedor <> ? then do:
            assign cNom_pessoa  = ''.
            find emscad.fornecedor where recid(fornecedor) = v_rec_fornecedor no-lock no-error.
            IF AVAILABLE fornecedor THEN DO:
                ASSIGN fedex.cod-emitente-imp:screen-value in frame fImpCP = string(fornecedor.cdn_fornecedor)
                       cNom_pessoa = fornecedor.nom_pessoa.
            END.
            display cNom_pessoa with frame fImpCP.
        end /* if */.

        RETURN.
    END.

    ON CHOOSE OF btn_rateio IN FRAME fImpCP DO:

        RUN esp/acr/esacr004f.p(fedex.numero,
                                dec(fedex.valor-imp:screen-value in frame fImpCP) - dec(INPUT FRAME fImpCP fedex.icms)).

    END.

    ON LEAVE OF fedex.cod-emitente-imp IN FRAME fImpCP DO:
        assign cNom_pessoa  = ''.
        find emscad.fornecedor no-lock
            where fornecedor.cod_empresa = v_cod_empres_usuar
              and fornecedor.cdn_fornecedor = INPUT FRAME fImpCP fedex.cod-emitente-imp
            no-error.

        IF AVAILABLE fornecedor THEN
            ASSIGN cNom_pessoa = fornecedor.nom_pessoa.

        display cNom_pessoa with frame fImpCP.

    END.

    ON LEAVE OF fedex.icms IN FRAME fImpCP DO:              
        IF  INPUT FRAME fImpCP fedex.icms = 0 then
            ASSIGN fedex.dt-venc-icms:SENSITIVE IN FRAME fImpCP = NO.
        ELSE
            ASSIGN fedex.dt-venc-icms:SENSITIVE IN FRAME fImpCP = YES.
    END.

    ON LEAVE OF fedex.conhecimento IN FRAME fImpCP DO:

        DEF VAR vembarque AS CHAR.

        RUN pi-verifica-embarque (INPUT INPUT FRAME fImpCP fedex.conhecimento,
                                  OUTPUT vembarque).


        IF vembarque <> "" 
        THEN DO:
             MESSAGE "Embarque " vembarque " !"
                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.

        /*
        IF vembarque <> "" 
        THEN DO:
             ASSIGN tgGeraTitAP = NO
                    tgviracopos = YES.
             DISPLAY tgGeraTitAP WITH FRAME fImpCP.
             DISABLE tgGeraTitAP WITH FRAME fImpCP.
             MESSAGE "Embarque " vembarque " realizado em Viracopos, n∆o ir† gerar t°tulo no contas a pagar pelo Courrier !"
                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        ELSE DO:
            ASSIGN tgGeraTitAP = YES
                   tgviracopos = NO.
            DISPLAY tgGeraTitAP WITH FRAME fImpCP.
            ENABLE tgGeraTitAP WITH FRAME fImpCP.
        END.
        */

    END.

    ON GO OF FRAME fImpCP DO:

        integra_imp:
        DO TRANSACTION:
            FIND CURRENT fedex EXCLUSIVE-LOCK.

            ASSIGN INPUT FRAME fImpCP 
                tgGeraTitAP 
                tgEncerraProc
                fedex.conhecimento
                fedex.dt-emis-imp
                fedex.dt-venc-imp
                fedex.fatura-imp
                fedex.cod-emitente-imp 
                fedex.valor-imp
                fedex.icms
                fedex.dt-venc-icms
                fedex.num-sat.

            IF  tgGeraTitAP THEN DO:
                ASSIGN c-especie        = "DP"
                       c-nr-docto       = STRING(INPUT FRAME fImpCP fedex.fatura-imp)
                       da-dt-emis       = INPUT FRAME fImpCP fedex.dt-emis-imp
                       da-dt-venc       = INPUT FRAME fImpCP fedex.dt-venc-imp
                       de-valor         = INPUT FRAME fImpCP fedex.valor-imp
                       de-valor-mov     = INPUT FRAME fImpCP fedex.valor-imp - INPUT FRAME fImpCP fedex.icms
                       iCod-emit-lanc   = INPUT FRAME fImpCP fedex.cod-emitente-imp
                       da-dt-venc-icms  = INPUT FRAME fImpCP fedex.dt-venc-icms
                       de-num-sat       = INPUT FRAME fImpCP fedex.num-sat
                       c-tp-lancto      = "Impto".

                RUN piCria-AP IN THIS-PROCEDURE.
                IF RETURN-VALUE = 'NOK' THEN
                    UNDO integra_imp, RETURN NO-APPLY.

                ASSIGN fedex.dt-venc-icms = da-dt-venc-icms
                       fedex.num-sat      = de-num-sat
                       fedex.lancado-imp  = YES
                       fedex.dt-ap-imp    = TODAY
                       fedex.parcela      = c-parcela.

            END.

            /* ** Viracopos n∆o gera t°tulo no APB mas marca imposto como lanáado ***
            IF tgviracopos THEN
               ASSIGN fedex.lancado-imp    = YES
                      fedex.dt-ap-imp      = TODAY. ***/

            IF tgEncerraProc THEN
                ASSIGN fedex.encerrado = YES.

        END.

        FIND CURRENT fedex NO-LOCK.

        RUN piMontaBrowse.
    END.


    /* ***************************  Main Block  *************************** */
    IF NOT AVAILABLE fedex OR BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0 THEN
        RETURN 'NOK'.

    IF fedex.duties = "S" 
    AND fedex.tipo
    THEN DO:
         MESSAGE "VERIFICAR: Pagamento do Imposto indicado como SENDER !" SKIP
             VIEW-AS ALERT-BOX INFORMATION.
    END.

    /* Seleciona usu†rio autorizados para Integrar ImpAP */
    RUN esp\es0018p.p (INPUT "esacr004", /* Nome do programa */
                       INPUT 3,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
    /* ** Localiza pelo grupo relacionado ao usu†rio ***/
    FOR EACH usuar_grp_usuar NO-LOCK
        WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
        FIND tt-prog-ponto 
            WHERE tt-prog-ponto.conteudo = usuar_grp_usuar.cod_grp_usuar NO-ERROR.
        IF AVAIL tt-prog-ponto 
           THEN LEAVE.
    END.
    /* ** Localiza pelo usu†rio ***/
    IF NOT AVAIL tt-prog-ponto 
    THEN DO:
         FIND tt-prog-ponto 
             WHERE tt-prog-ponto.conteudo = v_cod_usuar_corren NO-ERROR.
         IF NOT AVAIL tt-prog-ponto 
         THEN DO:
              MESSAGE "Uso exclusivo da Controladoria" VIEW-AS ALERT-BOX WARNING.
              RETURN 'NOK'.
         END.
    END.

    IF NOT fedex.recebido THEN DO:
        MESSAGE "Este COURRIER ainda nao foi Recebido/Enviado" VIEW-AS ALERT-BOX ERROR.
        RETURN 'NOK'.
    END.
    IF fedex.lancado-imp THEN DO:
        MESSAGE "COURRIER ja integrado com AP. Nao pode ser alterado" VIEW-AS ALERT-BOX ERROR.
        RETURN 'NOK'.
    END.

    /* ** Courrier cadastrado antes da criaá∆o da tabela fedex-ratio ***/
    DO TRANSACTION:
        IF NOT CAN-FIND (FIRST fedex-rateio OF fedex) 
        THEN DO:
             CREATE fedex-rateio.
             ASSIGN fedex-rateio.numero             = fedex.numero
                    fedex-rateio.cod_plano_cta_ctbl = "PADRAO"
                    fedex-rateio.cod_unid_negoc     = "ADM"
                    fedex-rateio.perc_aprop_ctbl    = 100.
             IF fedex.mp 
                THEN ASSIGN fedex-rateio.cod_cta_ctbl = cp-ct-codigo[1]
                            fedex-rateio.cod_ccusto   = cp-sc-codigo[1] .
                ELSE ASSIGN fedex-rateio.cod_cta_ctbl = fedex.ct-codigo
                            fedex-rateio.cod_ccusto   = fedex.cc-codigo.
             IF fedex-rateio.cod_ccusto <> "" 
                THEN ASSIGN fedex-rateio.cod_plano_ccusto = "PADRAO".
        END.
    END.

    DISPLAY fedex.conhecimento
            fedex.dt-emis-imp
            fedex.dt-venc-imp
            fedex.fatura-imp
            fedex.cod-emitente-imp
            fedex.valor-imp
            fedex.icms
            fedex.dt-venc-icms
            fedex.num-sat
            tgGeraTitAP
            tgEncerraProc
            WITH FRAME fImpCP.
    ENABLE fedex.conhecimento
           fedex.dt-emis-imp
           fedex.dt-venc-imp
           fedex.fatura-imp
           fedex.cod-emitente-imp 
           fedex.valor-imp
           fedex.dt-venc-icms
           fedex.num-sat
           tgGeraTitAP
           tgEncerraProc
           Btn_Rateio Btn_OK Btn_Cancel
           WITH FRAME fImpCP.

    IF fedex.icms = 0 THEN
        ENABLE fedex.icms WITH FRAME fImpCP.

    /* ** Tratamento para sempre gerar AP ***/
    ASSIGN tgGeraTitAP = YES.
    DISPLAY tgGeraTitAP WITH FRAME fImpCP.
    DISABLE tgGeraTitAP WITH FRAME fImpCP.

    VIEW FRAME fImpCP.
    WAIT-FOR GO OF FRAME fImpCP.
    HIDE FRAME fImpCP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMontaBrowse C-Win 
PROCEDURE piMontaBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-fedex.

    IF  c-embarque <> "*"
    THEN DO:
        FIND FIRST embarque-imp NO-LOCK 
            WHERE  embarque-imp.embarque = c-embarque NO-ERROR.

        IF  NOT AVAIL embarque-imp
        THEN DO:
            {&OPEN-QUERY-{&BROWSE-NAME}}
             RETURN.
        END.
        ELSE
            ASSIGN c-co = embarque-imp.cod-conhecto-master. 
    END.

    IF SESSION:SET-WAIT-STATE("general") THEN.

    FOR EACH fedex
          WHERE fedex.cod-transp        >= i-transp-ini
            AND fedex.cod-transp        <= i-transp-fim
            AND fedex.empresa           >= c-empresa-ini
            AND fedex.empresa           <= c-empresa-fim
            AND fedex.cod_estab         >= c-cod-estab-ini
            AND fedex.cod_estab         <= c-cod-estab-fim
            AND fedex.cod-emit-frete    >= i-frete-ini
            AND fedex.cod-emit-frete    <= i-frete-fim
            AND fedex.cod-emitente-imp  >= i-imp-ini
            AND fedex.cod-emitente-imp  <= i-imp-fim
            AND (fedex.mp                = l-mp-s 
            OR   fedex.mp                = l-mp-n)
            AND (fedex.lancado-frete     = l-frete-s 
            OR   fedex.lancado-frete     = l-frete-n)
            AND (fedex.lancado-imp       = l-impostos-s 
            OR   fedex.lancado-imp       = l-impostos-n)
            AND (fedex.encerrado         = l-encer-s 
            OR   fedex.encerrado         = l-encer-n)
            AND (fedex.recebido          = l-recebido-s 
            OR   fedex.recebido          = l-recebido-n)
            AND (fedex.tipo              = l-tipo-s 
            OR   fedex.tipo              = l-tipo-n)
            AND  fedex.conhecimento MATCHES (c-co) NO-LOCK:

        FIND FIRST usuar_mestre NO-LOCK
             WHERE usuar_mestre.cod_usuario = fedex.cod_usuario NO-ERROR.
        IF AVAIL usuar_mestre THEN 
            IF usuar_mestre.cod_usuario < c-usuario-ini
            OR usuar_mestre.cod_usuario > c-usuario-fim THEN NEXT.

        CREATE tt-fedex.
        ASSIGN tt-fedex.numero           = fedex.numero
               tt-fedex.tipo             = fedex.tipo              
               tt-fedex.empresa          = fedex.empresa 
               tt-fedex.cod_estab        = fedex.cod_estab
               tt-fedex.material         = fedex.material          
               tt-fedex.conhecimento     = fedex.conhecimento      
               tt-fedex.recebido         = fedex.recebido          
               tt-fedex.lancado-frete    = fedex.lancado-frete     
               tt-fedex.lancado-imp      = fedex.lancado-imp
               tt-fedex.usuario          = IF AVAIL usuar_mestre THEN usuar_mestre.cod_usuario ELSE "Eliminado"
               tt-fedex.usuar-mat        = fedex.usuar-mat   
               tt-fedex.cod-cond-pag     = fedex.cod-cond-pag
               tt-fedex.desc-sdcv        = fedex.desc-sdcv.
    END.
    
    {&OPEN-QUERY-{&BROWSE-NAME}}

    IF SESSION:SET-WAIT-STATE("") THEN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRecebeFedex C-Win 
PROCEDURE piRecebeFedex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    /* Definitions of the field level widgets                               */
    DEFINE BUTTON Btn_Cancel AUTO-END-KEY LABEL "Cancel" SIZE 10 BY 1 BGCOLOR 8 .
    DEFINE BUTTON Btn_OK AUTO-GO LABEL "OK" SIZE 10 BY 1 BGCOLOR 8 .

    DEFINE RECTANGLE RECT-38 EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL SIZE 48 BY 12.20 .
    DEFINE RECTANGLE RECT-37 EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 48 BY 1.5 BGCOLOR 7 .


    DEFINE FRAME fRecFedex
         rs-rec-envia NO-LABEL
         AT ROW 1.45 COL 12 COLON-ALIGNED
         fedex.conhecimento LABEL "Conhecimento"
            VIEW-AS FILL-IN SIZE 20 BY .88
            AT ROW 3.17 COL 17 COLON-ALIGNED
         fedex.duties LABEL "Impostos"
            VIEW-AS COMBO-BOX INNER-LINES 5
            LIST-ITEM-PAIRS "S - Sender","S","R - Receiver","R","3 - 3os","3"
            DROP-DOWN-LIST SIZE 16 BY .88
            AT ROW 4.17 COL 17 COLON-ALIGNED
         fedex.freight LABEL "Frete"
            VIEW-AS COMBO-BOX INNER-LINES 5
            LIST-ITEM-PAIRS "S - Sender","S","R - Receiver","R","3 - 3os","3"
            DROP-DOWN-LIST SIZE 16 BY .88
            AT ROW 5.17 COL 17 COLON-ALIGNED
         fedex.motivo-rejeicao LABEL "Motivo Rejeiá∆o"
            VIEW-AS EDITOR SIZE 30 BY 5
            AT ROW 7.17 COL 14 COLON-ALIGNED            
         Btn_OK AT ROW 13.75 COL 2.5
         Btn_Cancel AT ROW 13.75 COL 13.5
         RECT-38 AT ROW 1.2 COL 1.5
         RECT-37 AT ROW 13.5 COL 1.5
         /*SPACE(0.00) SKIP(1.74)*/
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1 TITLE "Recebe COURRIER"
             DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


    /* ************************  Control Triggers  ************************ */
    ON WINDOW-CLOSE OF FRAME fRecFedex DO:
        APPLY "END-ERROR":U TO SELF.
    END.

    ON GO OF FRAME fRecFedex DO:
        DO TRANSACTION:
            FIND CURRENT fedex EXCLUSIVE-LOCK.

            IF  INPUT FRAME fRecFedex rs-rec-envia = 1 THEN DO: /* recebe/envia */
                ASSIGN INPUT FRAME fRecFedex fedex.conhecimento fedex.duties fedex.freight .
                ASSIGN fedex.recebido = YES
                       fedex.dt-rec   = TODAY.
            END.
            ELSE DO: /* rejeita */
                ASSIGN INPUT FRAME fRecFedex fedex.motivo-rejeicao .
                ASSIGN fedex.recebido = NO
                       fedex.dt-rec   = ?.
            END.
        END.
        
        FIND CURRENT fedex NO-LOCK.

        IF  INPUT FRAME fRecFedex rs-rec-envia = 1 THEN
            RUN pi-email IN THIS-PROCEDURE (INPUT 1).
        ELSE
            RUN pi-email IN THIS-PROCEDURE (INPUT 2).

        RUN piMontaBrowse.
    END.

    ON VALUE-CHANGED OF rs-rec-envia IN FRAME fRecFedex DO:
       IF  INPUT FRAME fRecFedex rs-rec-envia = 2 THEN
           ASSIGN fedex.conhecimento:SENSITIVE    IN FRAME fRecFedex = NO
                  fedex.duties:SENSITIVE          IN FRAME fRecFedex = NO
                  fedex.freight:SENSITIVE         IN FRAME fRecFedex = NO
                  fedex.motivo-rejeicao:SENSITIVE IN FRAME fRecFedex = YES.
       ELSE
           ASSIGN fedex.conhecimento:SENSITIVE    IN FRAME fRecFedex = YES
                  fedex.duties:SENSITIVE          IN FRAME fRecFedex = YES
                  fedex.freight:SENSITIVE         IN FRAME fRecFedex = YES
                  fedex.motivo-rejeicao:SENSITIVE IN FRAME fRecFedex = NO.
    END.

    /* ***************************  Main Block  *************************** */
    IF NOT AVAILABLE fedex OR BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0 THEN
        RETURN 'NOK'.

    /* Seleciona usu†rio autorizados para Receber Fedex */
    RUN esp\es0018p.p (INPUT "esacr004", /* Nome do programa */
                       INPUT 4,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
    /* ** Localiza pelo grupo relacionado ao usu†rio ***/
    FOR EACH usuar_grp_usuar NO-LOCK
        WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
        FIND tt-prog-ponto 
            WHERE tt-prog-ponto.conteudo = usuar_grp_usuar.cod_grp_usuar NO-ERROR.
        IF AVAIL tt-prog-ponto 
           THEN LEAVE.
    END.
    /* ** Localiza pelo usu†rio ***/
    IF NOT AVAIL tt-prog-ponto 
    THEN DO:
         FIND tt-prog-ponto 
             WHERE tt-prog-ponto.conteudo = v_cod_usuar_corren NO-ERROR.
         IF NOT AVAIL tt-prog-ponto 
         THEN DO:
              MESSAGE "Uso exclusivo do Recebimento/Expedicao" VIEW-AS ALERT-BOX WARNING.
              RETURN 'NOK'.
         END.
    END.

    IF fedex.recebido THEN DO:
        MESSAGE "Este COURRIER ja foi Recebido/Enviado" VIEW-AS ALERT-BOX WARNING.
        RETURN 'NOK'.
    END.

    DISPLAY fedex.conhecimento fedex.duties fedex.freight WITH FRAME fRecFedex.
    ENABLE rs-rec-envia fedex.conhecimento fedex.duties fedex.freight fedex.motivo-rejeicao Btn_OK Btn_Cancel RECT-37 RECT-38
        WITH FRAME fRecFedex.
    VIEW FRAME fRecFedex.
    APPLY "value-changed" TO rs-rec-envia IN FRAME fRecFedex.
    
    WAIT-FOR GO OF FRAME fRecFedex.
    HIDE FRAME fRecFedex.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetira C-Win 
PROCEDURE piRetira :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Definitions of the field level widgets                               */
    DEFINE BUTTON Btn_Cancel AUTO-END-KEY LABEL "Cancel" SIZE 10 BY 1 BGCOLOR 8 .
    DEFINE BUTTON Btn_OK AUTO-GO LABEL "OK" SIZE 10 BY 1 BGCOLOR 8 .

    DEFINE RECTANGLE RECT-38 EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL SIZE 48 BY 6.20 .
    DEFINE RECTANGLE RECT-37 EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 48 BY 1.5 BGCOLOR 7 .

    DEFINE FRAME fRetira
         fedex.usuar-retira LABEL "Usu†rio Retirada"
            VIEW-AS FILL-IN SIZE 20 BY .88
            AT ROW 2.17 COL 17 COLON-ALIGNED
         fedex.dt-retira LABEL "Data Retirada"
            VIEW-AS FILL-IN SIZE 20 BY .88
            AT ROW 3.17 COL 17 COLON-ALIGNED
         Btn_OK AT ROW 6.75 COL 2.5
         Btn_Cancel AT ROW 6.75 COL 13.5
         RECT-38 AT ROW 1.2 COL 1.5
         RECT-37 AT ROW 6.5 COL 1.5
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1 TITLE "Retirada COURRIER"
             DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


    /* ************************  Control Triggers  ************************ */
    ON WINDOW-CLOSE OF FRAME fRetira DO:
        APPLY "END-ERROR":U TO SELF.
    END.

    ON GO OF FRAME fRetira DO:
        MESSAGE "Confirma retirada nesta data ?" 
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE l-confirma.
        
        IF  l-confirma THEN DO:
            DO TRANSACTION:
                FIND CURRENT fedex EXCLUSIVE-LOCK.
    
                ASSIGN fedex.usuar-retira = v_cod_usuar_corren
                       fedex.dt-retira    = TODAY.
            END.
            
            RUN pi-email IN THIS-PROCEDURE (INPUT 3).
        END.

        RUN piMontaBrowse.
    END.

    /* ***************************  Main Block  *************************** */
    IF  NOT AVAILABLE fedex 
    OR  BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0 THEN
        RETURN 'NOK'.

    ASSIGN fedex.usuar-retira:SCREEN-VALUE IN FRAME fRetira = v_cod_usuar_corren
           fedex.dt-retira:SCREEN-VALUE    IN FRAME fRetira = string(TODAY,"99/99/9999").

    ENABLE Btn_OK Btn_Cancel RECT-37 RECT-38 WITH FRAME fRetira.
    VIEW FRAME fRetira.
    
    WAIT-FOR GO OF FRAME fRetira.
    HIDE FRAME fRetira.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piZeraTemp-tables C-Win 
PROCEDURE piZeraTemp-tables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH tt_integr_apb_lote_impl EXCLUSIVE-LOCK:
        DELETE tt_integr_apb_lote_impl.
    END.
    
    FOR EACH tt_integr_apb_item_lote_impl_2 EXCLUSIVE-LOCK:
        DELETE tt_integr_apb_item_lote_impl_2.
    END.
    
    FOR EACH tt_integr_apb_aprop_ctbl_pend EXCLUSIVE-LOCK:
        DELETE tt_integr_apb_aprop_ctbl_pend.
    END.
    
    FOR EACH tt_log_erros_atualiz EXCLUSIVE-LOCK:
        DELETE tt_log_erros_atualiz. 
    END.
    
    FOR EACH tt_cancelamento_estorno_apb  EXCLUSIVE-LOCK:
        DELETE tt_cancelamento_estorno_apb. 
    END.

    FOR EACH tt_log_erros_estorn_cancel_apb EXCLUSIVE-LOCK:
        DELETE tt_log_erros_estorn_cancel_apb. 
    END.

    FOR EACH tt_log_erros_tit_ap_alteracao EXCLUSIVE-LOCK:
        DELETE tt_log_erros_tit_ap_alteracao.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piZeraTemp-tables C-Win 
PROCEDURE pi-verifica-embarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-conhecimento AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-embarque     AS CHARACTER NO-UNDO.

    ASSIGN p-embarque = "".

    FIND embarque-imp NO-LOCK 
        /* ** 204 WHERE embarque-imp.nr-conhecimento = p-conhecimento NO-ERROR. ***/
        WHERE embarque-imp.cod-conhecto-master = p-conhecimento NO-ERROR.
    IF AVAIL embarque-imp 
    THEN DO:
         FOR FIRST ordens-embarque 
             FIELDS(numero-ordem) 
             WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
               AND ordens-embarque.embarque    = embarque-imp.embarque NO-LOCK:
         END.
        
         IF NOT AVAIL ordens-embarque 
            THEN RETURN.
        
        FIND ordem-compra NO-LOCK
            WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-ERROR.
        
        IF NOT AVAIL ordem-compra 
           THEN RETURN.
        
        FOR EACH docum-est FIELDS(cod-emitente nat-oper ce-atual char-1) 
            WHERE docum-est.cod-emitente = ordem-compra.cod-emitente NO-LOCK:
        
            IF SUBSTRING(docum-est.char-1,1,12) <> embarque-imp.embarque 
               THEN NEXT.
            
            /* *** Tratamento para Viracopos
            IF docum-est.nat-oper = "310101"
            OR docum-est.nat-oper = "310201"
            OR docum-est.nat-oper = "355101"
            OR docum-est.nat-oper = "394901"
               THEN ASSIGN p-embarque = embarque-imp.embarque. ***/

            ASSIGN p-embarque = embarque-imp.embarque.
            RETURN.
        
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE piDespesaEmbarque:

    /* Seleciona usu†rio autorizados para Integrar frete */
    RUN esp\es0018p.p (INPUT "esacr004", /* Nome do programa */
                       INPUT 3,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
    /* ** Localiza pelo grupo relacionado ao usu†rio ***/
    FOR EACH usuar_grp_usuar NO-LOCK
        WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
        FIND tt-prog-ponto 
            WHERE tt-prog-ponto.conteudo = usuar_grp_usuar.cod_grp_usuar NO-ERROR.
        IF AVAIL tt-prog-ponto 
           THEN LEAVE.
    END.
    /* ** Localiza pelo usu†rio ***/
    IF NOT AVAIL tt-prog-ponto 
    THEN DO:
         FIND tt-prog-ponto 
             WHERE tt-prog-ponto.conteudo = v_cod_usuar_corren NO-ERROR.
         IF NOT AVAIL tt-prog-ponto 
         THEN DO:
              MESSAGE "Uso exclusivo da Controladoria" VIEW-AS ALERT-BOX WARNING.
              RETURN 'NOK'.
         END.
    END.

    FIND embarque-imp NO-LOCK
        /* ** 204 WHERE embarque-imp.nr-conhecimento = fedex.conhecimento NO-ERROR. ***/
        WHERE embarque-imp.cod-conhecto-master = fedex.conhecimento NO-ERROR.
    IF NOT AVAIL embarque-imp 
    THEN DO:
         MESSAGE "Embarque n∆o localizado para o Conhecimento " fedex.conhecimento
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN.
    END.

    EMPTY TEMP-TABLE tt-desp-embarque.

    FOR EACH desp-embarque NO-LOCK  
        WHERE desp-embarque.cod-estabel   = embarque-imp.cod-estabel 
          AND desp-embarque.embarque      = embarque-imp.embarque: 
        FIND emitente NO-LOCK
            WHERE emitente.cod-emitente = desp-embarque.cod-emitente NO-ERROR.
        FIND moeda NO-LOCK
            WHERE moeda.mo-codigo = desp-embarque.mo-codigo NO-ERROR.
        FIND desp-imp NO-LOCK
            WHERE desp-imp.cod-desp = desp-embarque.cod-desp NO-ERROR.
        CREATE tt-desp-embarque.
        ASSIGN tt-desp-embarque.cod-emitente = desp-embarque.cod-emitente
               tt-desp-embarque.nom-emitente = emitente.nome-abrev
               tt-desp-embarque.cod-despesa  = desp-embarque.cod-desp
               tt-desp-embarque.des-despesa  = desp-imp.descricao
               tt-desp-embarque.des-moeda    = moeda.descricao
               tt-desp-embarque.val-despesa  = desp-embarque.val-desp.
    END.

    VIEW FRAME f-desp-embarque.

    concil_block:
    DO ON ERROR UNDO concil_block, RETRY concil_block
                     ON ENDKEY UNDO concil_block, LEAVE concil_block:

         ENABLE br-desp-embarque bt-ok WITH FRAME f-desp-embarque.

         DISP embarque-imp.cod-estabel
              embarque-imp.embarque    WITH FRAME f-desp-embarque.

         OPEN QUERY qr-desp-embarque
              FOR EACH tt-desp-embarque NO-LOCK.

         WAIT-FOR GO OF FRAME f-desp-embarque.

    END.

    HIDE FRAME f-desp-embarque.


END.
