&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emscad             PROGRESS
          emsmov             PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&SCOPED-DEFINE NomProg   ESAPB007-2
&SCOPED-DEFINE DescProg  Baixa CPO X Nota Representante - FAT

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{esinc\es0000.i}

/* Temp-table API Alteracao titulo */
{esp/cms/apb767zc.i}
    
def var de_vl_comissao  as dec format "->>,>>>,>>9.99".
def var de_vl_comis_s_ir as dec format "->>,>>>,>>9.99".

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar AS CHARACTER FORMAT "x(3)":U  LABEL "Empresa" COLUMN-LABEL "Empresa" NO-UNDO.
def new global shared var v_rec_fornecedor
    as recid
    format ">>>>>>9":U
    no-undo.

def var de_vl_impto_ir      as dec format "->>,>>>,>>9.99".
def var de_vl_comissao_liq  as dec format "->>,>>>,>>9.99".
def var de_vl_deb           as dec format "->>,>>>,>>9.99".
def var de_vl_cred          as dec format "->>,>>>,>>9.99".
DEF VAR l_abre_query AS LOGICAL INITIAL NO NO-UNDO.
DEF VAR l_abre_query_ant AS LOGICAL INITIAL NO NO-UNDO.

def temp-table tt_repres
    field cdn_repres     LIKE representante.cdn_repres.

def temp-table tt_imp
    FIELD cod_estab      LIKE tit_ap.cod_estab
    FIELD cdn_fornecedor LIKE emscad.fornecedor.cdn_fornecedor
    FIELD nom_abrev      LIKE emscad.fornecedor.nom_abrev
    field cdn_repres     LIKE representante.cdn_repres
    field nom_abrev_r    LIKE representante.nom_abrev
    field cod_ser_docto  LIKE tit_ap.cod_ser_docto column-label "Sr" format "X(03)"
    FIELD cod_espec_docto LIKE tit_ap.cod_espec_docto
    field cod_tit_ap     LIKE tit_ap.cod_tit_ap  column-label "Docto" format "X(10)"
    field num_id_tit_ap  LIKE tit_ap.num_id_tit_ap  
    field cod_parcela    AS CHAR FORMAT "x(5)" column-label "Parc"
    field dat_vencto_tit_ap LIKE tit_ap.dat_vencto_tit_ap format "99/99/9999" column-label "Dt Vcto"
    field dat_liquidac_tit_ap LIKE tit_ap.dat_liquidac_tit_ap   format "99/99/9999" column-label "Dt Baixa"
    field dat_pedido            as date format "99/99/9999" column-label "Dt Pedido"
    field cdn_cliente           LIKE emscad.cliente.cdn_cliente column-label "Cliente"
    field nom_abrev_c           LIKE emscad.cliente.nom_abrev
    field nom_cidade_c          LIKE pessoa_fisic.nom_cidade
    field cod_unid_federac_c    LIKE  pessoa_fisic.cod_unid_federac
    field val_origin_tit_ap     LIKE tit_ap.val_origin_tit_ap format ">>,>>>,>>9.99" 
    FIELD val_sdo_tit_ap        LIKE tit_ap.val_sdo_tit_ap format ">>,>>>,>>9.99" COLUMN-LABEL "Valor s/IR"
    field val_perc_comis_repres LIKE repres_tit_acr.val_perc_comis_repres format ">>9.99" 
    field val_base              as dec format ">>,>>>,>>9.99" column-label "Valor Base"
    field cod_e_mail            LIKE pessoa_fisic.cod_e_mail
    index tt-imprime is primary cdn_fornecedor
                                cod_espec_docto
                                cod_ser_docto   
                                cod_tit_ap      
                                cod_parcela.    
    
    def temp-table tt-comis-deb-cred LIKE mgesp.comis-deb-cred
    FIELD descricao   LIKE mov-comis.descricao
    FIELD selecao     AS CHAR FORMAT 'x(1)' LABEL '' COLUMN-LABEL 'Seleá∆o'.

DEF TEMP-TABLE tt_antecip NO-UNDO
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"                                               
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"                                           
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"                                               
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"                                
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"                                                      
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"                                                       
    field tta_dat_transacao                AS DATE format "99/99/9999" label "Dt Transaá∆o" column-label "Dt Transaá∆o"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    field tta_val_tit_ap                   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor T°tulo" column-label "Vl T°tulo"
    FIELD tta_selecao                      AS CHAR FORMAT 'x(1)' LABEL '' COLUMN-LABEL 'Seleá∆o'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frame-1
&Scoped-define BROWSE-NAME br-movto

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt_imp

/* Definitions for BROWSE br-movto                                      */
&Scoped-define FIELDS-IN-QUERY-br-movto tt_imp.cdn_fornecedor tt_imp.cod_ser_docto tt_imp.cod_tit_ap tt_imp.cod_parcela tt_imp.dat_vencto_tit_ap tt_imp.val_origin_tit_ap tt_imp.val_sdo_tit_ap
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-movto   
&Scoped-define SELF-NAME br-movto
&Scoped-define QUERY-STRING-br-movto FOR EACH tt_imp
&Scoped-define OPEN-QUERY-br-movto OPEN QUERY {&SELF-NAME} FOR EACH tt_imp.
&Scoped-define TABLES-IN-QUERY-br-movto tt_imp
&Scoped-define FIRST-TABLE-IN-QUERY-br-movto tt_imp


/* Definitions for FRAME frame-1                                        */
&Scoped-define OPEN-BROWSERS-IN-QUERY-frame-1 ~
    ~{&OPEN-QUERY-br-movto}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-det-outros fornec data-ini data-fim ~
data-bxa bt-atualiza bt_sea1 br-movto vl-comis-fis ~
vl-outros-db vl-ir vl-liquido vl-bruto-apb vl-liquido-apb ~
bt-confirma bt-gera-ir bt-gera-avma bt-gera-avmn bt-estorno btExit bt-con-repres vl-outros-cr  ~
IMAGE-27 IMAGE-28 RECT-30 RECT-32 RECT-8 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS fornec data-ini data-fim data-bxa ~
vl-comis-fis vl-outros-db vl-ir vl-liquido vl-bruto-apb vl-liquido-apb ~
vl-outros-cr ~
 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

DEF BUFFER b_tt_imp FOR tt_imp.

/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-con-repres 
     LABEL "Relaá∆o Repres" 
     SIZE 12.72 BY 1.

def button bt_sea1
    label "Psq"
    tooltip "Pesquisa"
    image-up file "image/im-sea1"
    image-insensitive file "image/ii-sea1"
    size 4 by 1.

DEFINE BUTTON bt-atualiza 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON bt-confirma 
     LABEL "Confirma - Gera NF" 
     SIZE 19 BY 1.

DEFINE BUTTON bt-gera-ir
     LABEL "Gera IR - CPO" 
     SIZE 19 BY 1.

DEFINE BUTTON bt-gera-avma
     LABEL "Gera AVA(+) - CPO" 
     SIZE 19 BY 1.

DEFINE BUTTON bt-gera-avmn
     LABEL "Gera AVA (-) - CPO" 
     SIZE 19 BY 1.

DEFINE BUTTON bt-estorno
     LABEL "Estorna AVAs" 
     SIZE 19 BY 1.

DEFINE BUTTON bt-det-outros 
     LABEL "Detalhe DB/CR" 
     SIZE 12 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.


def new global shared var v_rec_tit_ap
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

DEFINE VARIABLE fornec AS INTEGER FORMAT ">>>,>>>,>>9":U /* INITIAL 12890 */
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 10.43 BY .88 NO-UNDO.

DEFINE VARIABLE data-ini AS DATE FORMAT "99/99/9999":U /* INITIAL 02/01/2009 */
     LABEL "Data Movto" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE data-fim AS DATE FORMAT "99/99/9999":U /* INITIAL 02/28/2009 */
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE data-bxa AS DATE FORMAT "99/99/9999":U /* INITIAL 03/10/2009 */
     LABEL "Data Baixa" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE vl-comis-fis AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Vl Base" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE vl-bruto-apb AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Vl Bruto APB" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE vl-liquido-apb AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Vl Liquido APB" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE vl-ir AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Vl IR" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE vl-liquido AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Vl L°quido" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE vl-outros-cr AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Outros CR" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE vl-outros-db AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Outros DB" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEF VAR v_ct_codigo LIKE conta-programa.ct-codigo NO-UNDO.

DEFINE IMAGE IMAGE-27
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 27 BY 10.5.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 106 BY 12.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 106 BY 2.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 108 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-movto FOR 
      tt_imp SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-movto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-movto C-Win _FREEFORM
  QUERY br-movto NO-LOCK DISPLAY
    tt_imp.cod_estab
    tt_imp.cdn_fornecedor 
    tt_imp.cod_tit_ap   WIDTH 11   
    tt_imp.cod_parcela   WIDTH 6   
    tt_imp.dat_vencto_tit_ap
    tt_imp.val_origin_tit_ap
    tt_imp.val_sdo_tit_ap LABEL 'Vl S/IR'
   ((tt_imp.val_sdo_tit_ap - tt_imp.val_origin_tit_ap) * -1) LABEL "Valor IR     "
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 75 BY 10.5
         FONT 1 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frame-1

     fornec   AT ROW 3.29 COL 09.29 COLON-ALIGNED
     bt_sea1  AT ROW 3.23 COL 22.00
     data-ini AT ROW 3.29 COL 35.00 COLON-ALIGNED
     data-fim AT ROW 3.29 COL 51.72 COLON-ALIGNED NO-LABEL
     data-bxa AT ROW 3.29 COL 72.29 COLON-ALIGNED

     bt-atualiza   AT ROW 3.22 COL 84.50
     bt-con-repres AT ROW 3.22 COL 93.00
     br-movto      AT ROW 5.25 COL 03.43

     vl-comis-fis AT ROW 05.50 COL 91 COLON-ALIGNED
     vl-ir        AT ROW 06.50 COL 91 COLON-ALIGNED
     vl-liquido   AT ROW 07.50 COL 91 COLON-ALIGNED

     vl-outros-db  AT ROW 09.50 COL 91 COLON-ALIGNED
     vl-outros-cr  AT ROW 10.50 COL 91 COLON-ALIGNED
     bt-det-outros AT ROW 11.50 COL 93

     vl-bruto-apb   AT ROW 13.50 COL 91 COLON-ALIGNED
     vl-liquido-apb AT ROW 14.50 COL 91 COLON-ALIGNED

     bt-gera-avma AT ROW 17.25 COL 05
     bt-gera-avmn AT ROW 17.25 COL 25
     bt-gera-ir   AT ROW 17.25 COL 45
     bt-estorno   AT ROW 17.25 COL 65
     bt-confirma  AT ROW 17.25 COL 85
     btExit       AT ROW 01.13 COL 104.14 HELP "Sair"
     
     IMAGE-27  AT ROW 3.29 COL 47.14
     IMAGE-28  AT ROW 3.29 COL 50.72
     RECT-30   AT ROW 5.25 COL 80
     RECT-32   AT ROW 5 COL 2
     RECT-8    AT ROW 2.75 COL 2
     rtToolBar AT ROW 1 COL 1

    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 108 BY 17.54
         FONT 1.


def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
def rectangle rt_mold
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.

DEFINE VARIABLE v_val_ava       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_des_historico AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_log_method    AS LOGICAL     NO-UNDO.

def frame f_ava
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 7.75 col 02.00 bgcolor 7 
    v_val_ava
         at row 01.75 col 10 colon-aligned label "Valor AVA"
         help "Valor AVA"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_des_historico
       at row 02.75 col 03.00 no-label
       view-as editor max-chars 2000 scrollbar-vertical
       size 42 by 4
       bgcolor 15 font 2
    bt_ok
         at row 07.96 col 03.00 font ?
         help "OK"
    bt_can
         at row 07.96 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 48.14 by 09.58
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Geraá∆o AVA - CPO".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars               in frame f_ava = 10.00
           bt_can:height-chars              in frame f_ava = 01.00
           bt_ok:width-chars                in frame f_ava = 10.00
           bt_ok:height-chars               in frame f_ava = 01.00
           rt_cxcf:width-chars              in frame f_ava = 44.72
           rt_cxcf:height-chars             in frame f_ava = 01.42
           rt_mold:width-chars              in frame f_ava = 44.72
           rt_mold:height-chars             in frame f_ava = 06.17.

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
         TITLE              = "{&DescProg} - {&NomProg}"
         HEIGHT             = 17.38
         WIDTH              = 107.43
         MAX-HEIGHT         = 28.46
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.46
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frame-1
   Custom                                                               */
/* BROWSE-TAB br-movto bt-atualiza frame-1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* {DescProg} - {NomProg} */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* {DescProg} - {NomProg} */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME bt-con-repres
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-con-repres C-Win
ON CHOOSE OF bt-con-repres IN FRAME frame-1 /* Antecip/Emprest */
DO:

     RUN esp/apb/esapb007d-2.w(INT(fornec:SCREEN-VALUE IN FRAME frame-1)).
     ASSIGN l_abre_query_ant = NO.
       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-atualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-atualiza C-Win
ON CHOOSE OF bt-atualiza IN FRAME frame-1
DO:

  RUN pi-valida.
  FOR EACH tt_imp:
      DELETE tt_imp.
  END.

  FOR EACH tt-comis-deb-cred:
      DELETE tt-comis-deb-cred.
  END.

  FOR EACH tt_antecip:
      DELETE tt_antecip.
  END.

  IF RETURN-VALUE = 'OK' THEN  DO:
      
      ASSIGN l_abre_query     = YES
             l_abre_query_ant = YES.

      RUN piAtualizaBrowser.

      RUN pi-comis-deb-cred.
      
      RUN piLista_variavel.
      
      ENABLE bt-con-repres bt-gera-ir bt-gera-avma bt-gera-avmn bt-estorno bt-confirma bt-det-outros WITH FRAME {&FRAME-NAME}.

      {&OPEN-QUERY-{&BROWSE-NAME}}


  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

ON CHOOSE OF bt_sea1 IN FRAME FRAME-1
DO:

    RUN prgint/utb/utb031nb.p.

    IF v_rec_fornecedor <> ?
    THEN DO:
         FIND emscad.fornecedor NO-LOCK 
            WHERE RECID(emscad.fornecedor) = v_rec_fornecedor NO-ERROR.
         IF AVAIL emscad.fornecedor
            THEN ASSIGN fornec:SCREEN-VALUE IN FRAME frame-1 = STRING(emscad.fornecedor.cdn_fornec).
    END.

END.


&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma C-Win
ON CHOOSE OF bt-confirma IN FRAME frame-1 /* Confirma */
DO:

    IF CAN-FIND(FIRST tt_imp 
                WHERE tt_imp.cdn_fornec <> 0) 
    THEN DO: 
       
        IF DECIMAL(vl-liquido-apb:SCREEN-VALUE IN FRAME frame-1) <= 0
        THEN DO:
             MESSAGE "Valor Liquido do T°tulo APB Ç menor ou igual Ö 0 (zero) !"
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
             RETURN NO-APPLY.
        END.

        IF  DECIMAL(vl-ir:SCREEN-VALUE IN FRAME frame-1) <> ROUND(DECIMAL(vl-bruto-apb:SCREEN-VALUE IN FRAME frame-1) * 0.015, 2)
        AND ROUND(DECIMAL(vl-bruto-apb:SCREEN-VALUE IN FRAME frame-1) * 0.015, 2) >= 10
        THEN DO: 

             FIND int-emitente NO-LOCK
                WHERE int-emitente.cod-emitente = tt_imp.cdn_fornecedor NO-ERROR.
             IF NOT AVAIL int-emitente
             OR (AVAIL int-emitente AND
                 int-emitente.ind-forma-tributo <> 3)
             THEN DO: /* n∆o optante pelo SIMPLES, deve apresentar a mensagem */
                  /* ** Pode haver diferenáa entre o arredondamento das CPOs com o Valor total das CPOs, por isso solicita confirmaá∆o ***/
                  MESSAGE "Diferenáa no calculo do Valor de IR, confirma geraá∆o da NF ?" SKIP(1)
                          "Soma de IR das CPOs: " DECIMAL(vl-ir:SCREEN-VALUE IN FRAME frame-1) SKIP
                          "Valor Base * 1,5%: " ROUND(DECIMAL(vl-bruto-apb:SCREEN-VALUE IN FRAME frame-1) * 0.015, 2)
                        VIEW-AS ALERT-BOX  QUESTION BUTTONS YES-NO TITLE "Geraá∆o AVA(-)" UPDATE choice AS LOGICAL.
      
                  IF CHOICE = NO 
                  THEN DO: 
                       RETURN NO-APPLY.
                  END.

             END.

        END.

        RUN esp/apb/esapb007a-2.w(INPUT TABLE tt_imp,
                                  INPUT 0 /*v_cdn_repres*/,    
                                  INPUT date(data-ini:SCREEN-VALUE IN FRAME frame-1), 
                                  INPUT date(data-fim:SCREEN-VALUE IN FRAME frame-1),
                                  INPUT date(data-bxa:screen-value in frame frame-1),  
                                  INPUT INT(fornec:SCREEN-VALUE IN FRAME frame-1),
                                  INPUT DECIMAL(vl-bruto-apb:SCREEN-VALUE IN FRAME frame-1), /* Valor total da comiss∆o mais DB e CR */
                                  INPUT DECIMAL(vl-ir:SCREEN-VALUE IN FRAME frame-1),        /* Valor doc imposto */
                                  INPUT DECIMAL(vl-outros-cr:SCREEN-VALUE IN FRAME frame-1),
                                  INPUT DECIMAL(vl-outros-db:SCREEN-VALUE IN FRAME frame-1),
                                  INPUT TABLE tt-comis-deb-cred,
                                  INPUT TABLE tt_antecip).
       FOR EACH tt_imp EXCLUSIVE-LOCK:
           DELETE tt_imp.
       END.

       {&OPEN-QUERY-{&BROWSE-NAME}}
       ASSIGN fornec   = 0
              data-ini = ?
              data-fim = ?
              data-bxa = TODAY.
       DISP data-ini
            data-fim
            data-bxa 
            fornec WITH FRAME {&FRAME-NAME}.

    END.
    ELSE DO:
        MESSAGE 'N∆o existem t°tulos para serem baixados!' VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME bt-gera-avmn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-gera-avmn C-Win
ON CHOOSE OF bt-gera-avmn IN FRAME frame-1
DO:

       IF AVAIL tt_imp 
       THEN DO:
            FIND tit_ap NO-LOCK
               WHERE tit_ap.cod_estab     = tt_imp.cod_estab 
                 AND tit_ap.num_id_tit_ap = tt_imp.num_id_tit_ap NO-ERROR.
            FOR EACH movto_tit_ap OF tit_ap NO-LOCK
                WHERE movto_tit_ap.ind_trans_ap_abrev = "AVMN"
                  AND movto_tit_ap.LOG_movto_estordo  = NO,
                FIRST aprop_ctbl_ap OF movto_tit_ap 
                WHERE aprop_ctbl_ap.cod_cta_ctbl = v_ct_codigo:
                MESSAGE "CPO j† possui AVA(-) correspondente ao IR, o saldo n∆o poder† ser alterado !"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN NO-APPLY.
            END.

            ASSIGN v_val_ava       = 0
                   v_des_historico = "".

            VIEW FRAME f_ava.

            filter_block:
            do on error undo filter_block, retry filter_block
                             on endkey undo filter_block, leave filter_block:
                display bt_can
                        bt_ok
                        v_val_ava
                        v_des_historico
                        with frame f_ava.
                enable all with frame f_ava.

                wait-for go of frame f_ava.

                assign input frame f_ava v_val_ava
                       input frame f_ava v_des_historico.

                MESSAGE "Confirma geraá∆o do AVA(-) na CPO no valor de: " v_val_ava " ?" 
                      VIEW-AS ALERT-BOX  QUESTION BUTTONS YES-NO TITLE "Geraá∆o AVA(-)" UPDATE choice AS LOGICAL.

                IF CHOICE = NO 
                THEN DO: 
                     HIDE FRAME f_ava.
                     RETURN NO-APPLY.
                END.

                ASSIGN v_log_method = SESSION:SET-WAIT-STATE("General").
                RUN piAcerto_ir_cpo(INPUT 2,
                                    INPUT v_val_ava,
                                    INPUT v_des_historico).
    
                RUN piAtualizaBrowser.
                RUN piLista_variavel.
                ENABLE bt-con-repres bt-gera-ir bt-gera-avma bt-gera-avmn bt-estorno bt-confirma bt-det-outros WITH FRAME {&FRAME-NAME}.
                {&OPEN-QUERY-{&BROWSE-NAME}}
                ASSIGN v_log_method = session:SET-WAIT-STATE("").

            END.

            HIDE FRAME f_ava.

       END.
      
END.

&Scoped-define SELF-NAME bt-gera-avma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-gera-avma C-Win
ON CHOOSE OF bt-gera-avma IN FRAME frame-1
DO:

       IF AVAIL tt_imp 
       THEN DO:
            FIND tit_ap NO-LOCK
               WHERE tit_ap.cod_estab     = tt_imp.cod_estab 
                 AND tit_ap.num_id_tit_ap = tt_imp.num_id_tit_ap NO-ERROR.
            FOR EACH movto_tit_ap OF tit_ap NO-LOCK
                WHERE movto_tit_ap.ind_trans_ap_abrev = "AVMN"
                  AND movto_tit_ap.LOG_movto_estordo  = NO,
                FIRST aprop_ctbl_ap OF movto_tit_ap 
                WHERE aprop_ctbl_ap.cod_cta_ctbl = v_ct_codigo:
                MESSAGE "CPO j† possui AVA(-) correspondente ao IR, o saldo n∆o poder† ser alterado !"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN NO-APPLY.
            END.

            ASSIGN v_val_ava       = 0
                   v_des_historico = "".

            VIEW FRAME f_ava.

            filter_block:
            do on error undo filter_block, retry filter_block
                             on endkey undo filter_block, leave filter_block:
                display bt_can
                        bt_ok
                        v_val_ava
                        v_des_historico
                        with frame f_ava.
                enable all with frame f_ava.

                wait-for go of frame f_ava.

                assign input frame f_ava v_val_ava
                       input frame f_ava v_des_historico.

                MESSAGE "Confirma geraá∆o do AVA(+) na CPO no valor de: " v_val_ava " ?" 
                      VIEW-AS ALERT-BOX  QUESTION BUTTONS YES-NO TITLE "Geraá∆o AVA(+)" UPDATE choice AS LOGICAL.

                IF CHOICE = NO 
                THEN DO: 
                     HIDE FRAME f_ava.
                     RETURN NO-APPLY.
                END.

                ASSIGN v_log_method = SESSION:SET-WAIT-STATE("General").
                RUN piAcerto_ir_cpo(INPUT 3,
                                    INPUT v_val_ava,
                                    INPUT v_des_historico).
    
                RUN piAtualizaBrowser.
                RUN piLista_variavel.
                ENABLE bt-con-repres bt-gera-ir bt-gera-avma bt-gera-avmn bt-estorno bt-confirma bt-det-outros WITH FRAME {&FRAME-NAME}.
                {&OPEN-QUERY-{&BROWSE-NAME}}
                ASSIGN v_log_method = session:SET-WAIT-STATE("").

            END.

            HIDE FRAME f_ava.

       END.
      
END.


&Scoped-define SELF-NAME bt-gera-ir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-gera-ir C-Win
ON CHOOSE OF bt-gera-ir IN FRAME frame-1
DO:

      DEFINE VARIABLE v_val_dif AS DECIMAL     NO-UNDO.

      FIND int-emitente NO-LOCK
         WHERE int-emitente.cod-emitente = tt_imp.cdn_fornecedor NO-ERROR.
      IF AVAIL int-emitente 
      AND int-emitente.ind-forma-tributo = 3 
      THEN DO: /* SIMPLES */
           MESSAGE "Fornecedor optante pelo SIMPLES, n∆o retÇm IR!"
                   VIEW-AS ALERT-BOX INFO BUTTONS OK.
           RETURN NO-APPLY.
      END.

      IF AVAIL tt_imp 
      THEN DO:
           FIND tit_ap NO-LOCK
              WHERE tit_ap.cod_estab     = tt_imp.cod_estab 
                AND tit_ap.num_id_tit_ap = tt_imp.num_id_tit_ap NO-ERROR.
           FOR EACH movto_tit_ap OF tit_ap NO-LOCK
               WHERE movto_tit_ap.ind_trans_ap_abrev = "AVMN"
                 AND movto_tit_ap.LOG_movto_estordo  = NO,
               FIRST aprop_ctbl_ap OF movto_tit_ap 
               WHERE aprop_ctbl_ap.cod_cta_ctbl = v_ct_codigo:
               MESSAGE "CPO j† possui AVA(-) correspondente ao IR, no valor de " movto_tit_ap.val_movto_ap " !"
                       VIEW-AS ALERT-BOX INFO BUTTONS OK.
               RETURN NO-APPLY.
           END.

           FIND FIRST impto_vincul_fornec NO-LOCK
                WHERE impto_vincul_fornec.cod_empresa       = v_cod_empres_usuar
                  AND impto_vincul_fornec.cdn_fornecedor    = tt_imp.cdn_fornecedor 
                  AND impto_vincul_fornec.cod_classif_impto = '8045' NO-ERROR.
           IF NOT AVAIL impto_vincul_fornec 
           THEN DO:
                MESSAGE "Fornecedor n∆o possui imposto relacionado !"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN NO-APPLY.
           END.

           ASSIGN v_val_dif = 0.
           IF NOT CAN-FIND(FIRST b_tt_imp
                           WHERE b_tt_imp.val_sdo_tit_ap = b_tt_imp.val_origin_tit_ap
                             AND RECID(b_tt_imp) <> RECID(tt_imp)) 
              THEN ASSIGN v_val_dif = (ROUND(de_vl_comissao * 0.015, 2) - (ROUND(tit_ap.val_sdo_tit_ap * 0.015, 2) + de_vl_impto_ir)).

           MESSAGE "Confirma geraá∆o do AVA de IR na CPO no valor de: " ROUND(tit_ap.val_sdo_tit_ap * 0.015, 2) + v_val_dif " ?" 
                 VIEW-AS ALERT-BOX  QUESTION BUTTONS YES-NO TITLE "Geraá∆o AVA - IR" UPDATE choice AS LOGICAL.

           IF CHOICE = NO 
              THEN RETURN NO-APPLY.
             
           ASSIGN v_log_method = SESSION:SET-WAIT-STATE("General").
           RUN piAcerto_ir_cpo(INPUT 1,
                               INPUT (ROUND(tit_ap.val_sdo_tit_ap * 0.015, 2) + v_val_dif),
                               INPUT "").
           ASSIGN v_log_method = SESSION:SET-WAIT-STATE("").

           RUN piAtualizaBrowser.
           RUN piLista_variavel.
           ENABLE bt-con-repres bt-gera-ir bt-gera-avma bt-gera-avmn bt-estorno bt-confirma bt-det-outros WITH FRAME {&FRAME-NAME}.
           {&OPEN-QUERY-{&BROWSE-NAME}}

      END.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME bt-estorno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-estorno C-Win
ON CHOOSE OF bt-estorno IN FRAME frame-1
DO:

      IF AVAIL tt_imp 
      THEN DO:
           FIND tit_ap NO-LOCK
              WHERE tit_ap.cod_estab     = tt_imp.cod_estab 
                AND tit_ap.num_id_tit_ap = tt_imp.num_id_tit_ap NO-ERROR.
           IF AVAIL tit_ap 
           THEN DO:
                ASSIGN v_rec_tit_ap = RECID(tit_ap).
                RUN prgfin/apb/apb721aa.p.

                APPLY "choose" TO bt-atualiza IN FRAME frame-1.

           END.
      END.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME bt-det-outros
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-det-outros C-Win
ON CHOOSE OF bt-det-outros IN FRAME frame-1 /* Detalhes Outros */
DO:
    FIND FIRST tt_imp NO-LOCK
         WHERE tt_imp.cdn_fornec <> 0 NO-ERROR.
    IF AVAIL tt_imp
    THEN DO: 
         RUN esp/apb/esapb007c-2.w(INPUT tt_imp.cdn_fornec /*v_cdn_repres*/,    
                                   INPUT date(data-ini:SCREEN-VALUE IN FRAME frame-1), 
                                   INPUT date(data-fim:SCREEN-VALUE IN FRAME frame-1),
                                   INPUT-OUTPUT TABLE tt-comis-deb-cred,
                                   INPUT l_abre_query).
         ASSIGN l_abre_query = NO.

         ASSIGN de_vl_deb  = 0
                de_vl_cred = 0.

         FOR EACH tt-comis-deb-cred
             WHERE selecao = "*":
             IF tt-comis-deb-cred.deb-cred 
               THEN ASSIGN de_vl_deb  = de_vl_deb  - tt-comis-deb-cred.valor.
               ELSE ASSIGN de_vl_cred = de_vl_cred + tt-comis-deb-cred.valor.             
         END.

         RUN piLista_variavel.

    END.
    ELSE DO:
         MESSAGE 'N∆o existem t°tulos para serem baixados!' VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit C-Win
ON CHOOSE OF btExit IN FRAME frame-1 /* Exit */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Conta para AVA IR */
FIND FIRST conta-programa NO-LOCK
     WHERE conta-programa.programa = 'esapb007a'
       AND conta-programa.indice   = 1 NO-ERROR.
IF AVAIL conta-programa THEN
   ASSIGN v_ct_codigo = conta-programa.ct-codigo.

ASSIGN data-bxa = TODAY.

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

    RUN enable_UI.

   IF NOT THIS-PROCEDURE:PERSISTENT THEN
       WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

DISABLE data-bxa vl-comis-fis vl-outros-cr vl-outros-db vl-ir vl-liquido vl-bruto-apb vl-liquido-apb
    WITH FRAME frame-1.

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
    DISPLAY fornec data-ini data-fim data-bxa   
            vl-comis-fis vl-outros-db vl-ir vl-liquido vl-bruto-apb vl-liquido-apb
            vl-outros-cr  
        WITH FRAME frame-1 IN WINDOW C-Win.
    ENABLE bt-det-outros fornec data-ini data-fim data-bxa bt-atualiza bt_sea1
           br-movto bt-gera-ir bt-gera-avma bt-gera-avmn bt-estorno bt-confirma btExit bt-con-repres
           IMAGE-27 IMAGE-28 RECT-30 RECT-32 RECT-8 rtToolBar 
        WITH FRAME frame-1 IN WINDOW C-Win.
    {&OPEN-BROWSERS-IN-QUERY-frame-1}
    VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-comis-deb-cred C-Win 
PROCEDURE pi-comis-deb-cred :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
    ASSIGN de_vl_cred = 0
           de_vl_deb  = 0. 
    
    RUN pi-verifica-repres.

    FOR EACH tt_repres:
        FOR EACH comis-deb-cred NO-LOCK  
            WHERE comis-deb-cred.cod-rep     = tt_repres.cdn_repres
              AND comis-deb-cred.dt-mov     >= DATE(data-ini:SCREEN-VALUE IN FRAME frame-1) 
              AND comis-deb-cred.dt-mov     <= DATE(data-fim:SCREEN-VALUE IN FRAME frame-1) 
              AND comis-deb-cred.base-final  = NO,
            FIRST mov-comis NO-LOCK  
                WHERE mov-comis.cod-mov = comis-deb-cred.cod-mov:
            IF comis-deb-cred.deb-cred 
               THEN ASSIGN de_vl_deb  = de_vl_deb  - comis-deb-cred.valor.
               ELSE ASSIGN de_vl_cred = de_vl_cred + comis-deb-cred.valor.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida C-Win 
PROCEDURE pi-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST emscad.fornecedor NO-LOCK
        WHERE emscad.fornecedor.cdn_fornec = int(fornec:SCREEN-VALUE IN FRAME frame-1) NO-ERROR.
    IF NOT AVAIL emscad.fornecedor THEN DO:
        MESSAGE 'Fornecedor n∆o cadastrado!' VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN 'NOK'.
    END.
    IF emscad.fornecedor.cod_grp_fornec <> '20' THEN DO:
       MESSAGE 'Fornecedor n∆o pertence ao Grupo de Fornecedores 20(COMISSÂES)!' VIEW-AS ALERT-BOX INFO BUTTONS OK.
       RETURN 'NOK'.
    END.
    
    IF (date(data-ini:SCREEN-VALUE IN FRAME frame-1) > date(data-fim:SCREEN-VALUE IN FRAME frame-1)) OR
       (date(data-fim:SCREEN-VALUE IN FRAME frame-1) < date(data-ini:SCREEN-VALUE IN FRAME frame-1)) THEN DO:
        MESSAGE 'Data Movto inv†lida!' VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN 'NOK'.
    END.
    
    IF date(data-bxa:SCREEN-VALUE IN FRAME frame-1) < date(data-ini:SCREEN-VALUE IN FRAME frame-1) THEN DO:
        MESSAGE 'Data Baixa inv†lida!' VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN 'NOK'.
    END.
    
    RETURN 'OK'.
    
    END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-repres C-Win 
PROCEDURE pi-verifica-repres :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FOR EACH tt_repres:
        DELETE tt_repres.
    END.
    FIND FIRST emscad.fornecedor NO-LOCK
        WHERE emscad.fornecedor.cod_empresa = v_cod_empres_usuar
        AND   emscad.fornecedor.cdn_fornec  = INT(fornec:SCREEN-VALUE IN FRAME frame-1) NO-ERROR.
    IF AVAIL emscad.fornecedor THEN DO:
       FOR EACH representante NO-LOCK
           WHERE representante.cod_empresa = emscad.fornecedor.cod_empresa
             AND representante.num_pessoa  = emscad.fornecedor.num_pessoa:
           CREATE tt_repres.
           ASSIGN tt_repres.cdn_repres = representante.cdn_repres.
       END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piacerto_ir_cpo C-Win 
PROCEDURE piacerto_ir_cpo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
     DEF INPUT PARAM p_ind_ava    AS INT  NO-UNDO. /* ** 1 - AVA de IR / 2 - AVA(-) de ajuste no saldo da CPO / 3 - AVA(+) de ajuste no saldo da CPO ***/
     DEF INPUT PARAM p_val_ava    AS DEC  NO-UNDO. /* ** Valor do AVA ***/
     DEF INPUT PARAM p_des_histor AS CHAR NO-UNDO. /* ** Hist¢rico da Movimentaá∆o ***/

     DEF VAR v_cod_refer LIKE tit_ap.cod_refer NO-UNDO.
     DEF VAR l_erro_api  AS LOG INIT NO.
     DEF VAR v_arq_api_ir AS CHAR NO-UNDO.
          
     ASSIGN data-bxa = DATE(data-bxa:SCREEN-VALUE IN FRAME frame-1) /*data-bxa IN FRAME {&FRAME-NAME}*/.

     RUN piReferencia (INPUT data-bxa,
                       INPUT '1',
                       OUTPUT v_cod_refer).   
     
     /*Cria temp-table com as informaá‰es dos t°tulos para alteraá∆o no APB. */       
      CREATE tt_tit_ap_alteracao_base_1.
      ASSIGN tt_tit_ap_alteracao_base_1.ttv_cod_usuar_corren             =  v_cod_usuar_corren
             tt_tit_ap_alteracao_base_1.tta_cod_empresa                  =  tit_ap.cod_empresa
             tt_tit_ap_alteracao_base_1.tta_cod_estab                    =  tit_ap.cod_estab
             tt_tit_ap_alteracao_base_1.tta_num_id_tit_ap                =  tit_ap.num_id_tit_ap
             tt_tit_ap_alteracao_base_1.ttv_rec_tit_ap                   =  RECID(tt_tit_ap_alteracao_base_1)
             tt_tit_ap_alteracao_base_1.tta_cdn_fornecedor               =  tit_ap.cdn_fornecedor
             tt_tit_ap_alteracao_base_1.tta_cod_espec_docto              =  tit_ap.cod_espec_docto
             tt_tit_ap_alteracao_base_1.tta_cod_ser_docto                =  tit_ap.cod_ser_docto
             tt_tit_ap_alteracao_base_1.tta_cod_tit_ap                   =  tit_ap.cod_tit_ap
             tt_tit_ap_alteracao_base_1.tta_cod_parcela                  =  tit_ap.cod_parcela
             tt_tit_ap_alteracao_base_1.ttv_dat_transacao                =  data-bxa
             tt_tit_ap_alteracao_base_1.ttv_cod_refer                    =  v_cod_refer 
             tt_tit_ap_alteracao_base_1.tta_dat_emis_docto               =  ?
             tt_tit_ap_alteracao_base_1.tta_dat_vencto_tit_ap            =  ?
             tt_tit_ap_alteracao_base_1.tta_dat_prev_pagto               =  ?
             tt_tit_ap_alteracao_base_1.tta_dat_ult_pagto                =  ?                  
             tt_tit_ap_alteracao_base_1.tta_num_dias_atraso              =  tit_ap.num_dias_atraso
             tt_tit_ap_alteracao_base_1.tta_val_perc_multa_atraso        =  tit_ap.val_perc_multa_atraso
             tt_tit_ap_alteracao_base_1.tta_val_juros_dia_atraso         =  tit_ap.val_juros_dia_atraso
             tt_tit_ap_alteracao_base_1.tta_val_perc_juros_dia_atraso    =  tit_ap.val_perc_juros_dia_atraso
             tt_tit_ap_alteracao_base_1.tta_dat_desconto                 =  ?
             tt_tit_ap_alteracao_base_1.tta_val_perc_desc                =  tit_ap.val_perc_desc      
             tt_tit_ap_alteracao_base_1.tta_val_desconto                 =  tit_ap.val_desconto   
             tt_tit_ap_alteracao_base_1.tta_cod_portador                 =  tit_ap.cod_portador     
             tt_tit_ap_alteracao_base_1.ttv_cod_portador_mov             =  ""                 
             tt_tit_ap_alteracao_base_1.tta_log_pagto_bloqdo             =  tit_ap.log_pagto_bloqdo
             tt_tit_ap_alteracao_base_1.tta_cod_seguradora               =  tit_ap.cod_seguradora  
             tt_tit_ap_alteracao_base_1.tta_cod_apol_seguro              =  tit_ap.cod_apol_seguro
             tt_tit_ap_alteracao_base_1.tta_cod_arrendador               =  tit_ap.cod_arrendador   
             tt_tit_ap_alteracao_base_1.tta_cod_contrat_leas             =  tit_ap.cod_contrat_leas  
             tt_tit_ap_alteracao_base_1.tta_ind_tip_espec_docto          =  tit_ap.ind_tip_espec_docto 
             tt_tit_ap_alteracao_base_1.tta_cod_indic_econ               =  tit_ap.cod_indic_econ  
             tt_tit_ap_alteracao_base_1.tta_num_seq_refer                =  ?
             tt_tit_ap_alteracao_base_1.ttv_ind_motiv_alter_val_tit_ap   =  "Alteraá∆o"
             tt_tit_ap_alteracao_base_1.ttv_wgh_lista                    =  ?           
             tt_tit_ap_alteracao_base_1.ttv_log_gera_ocor_alter_valores  =  NO                 
             tt_tit_ap_alteracao_base_1.tta_cb4_tit_ap_bco_cobdor        =  ""
             tt_tit_ap_alteracao_base_1.tta_cod_histor_padr              =  ""
             tt_tit_ap_alteracao_base_1.tta_des_histor_padr              =  p_des_histor                 
             tt_tit_ap_alteracao_base_1.tta_ind_sit_tit_ap               =  tit_ap.ind_sit_tit_ap    
             tt_tit_ap_alteracao_base_1.tta_cod_forma_pagto              =  tit_ap.cod_forma_pagto   
             tt_tit_ap_alteracao_base_1.tta_cod_estab_ext                =  "" .

    IF p_ind_ava = 1
    OR p_ind_ava = 2
       THEN tt_tit_ap_alteracao_base_1.tta_val_sdo_tit_ap =  tit_ap.val_sdo_tit_ap - p_val_ava.
       ELSE tt_tit_ap_alteracao_base_1.tta_val_sdo_tit_ap =  tit_ap.val_sdo_tit_ap + p_val_ava.
    
    IF p_ind_ava = 1 
    THEN DO:
         CREATE tt_tit_ap_alteracao_rateio.
         ASSIGN tt_tit_ap_alteracao_rateio.ttv_rec_tit_ap           = RECID(tt_tit_ap_alteracao_base_1)
                tt_tit_ap_alteracao_rateio.tta_cod_estab            = tit_ap.cod_estab
                tt_tit_ap_alteracao_rateio.tta_cod_refer            = v_cod_refer
                tt_tit_ap_alteracao_rateio.tta_num_seq_refer        = 1
                tt_tit_ap_alteracao_rateio.tta_cod_tip_fluxo_financ = ''
                tt_tit_ap_alteracao_rateio.tta_cod_plano_cta_ctbl   = "Padrao"
                tt_tit_ap_alteracao_rateio.tta_cod_cta_ctbl         = v_ct_codigo
                tt_tit_ap_alteracao_rateio.tta_cod_unid_negoc       = ''
                tt_tit_ap_alteracao_rateio.tta_cod_plano_ccusto     = '' 
                tt_tit_ap_alteracao_rateio.tta_cod_ccusto           = ''
                tt_tit_ap_alteracao_rateio.tta_val_aprop_ctbl       = ABS(p_val_ava)
                tt_tit_ap_alteracao_rateio.ttv_ind_tip_rat          = 'Valor'
                tt_tit_ap_alteracao_rateio.tta_num_id_tit_ap        = tit_ap.num_id_tit_ap.
    END.

    /* Roda API - Alteraá∆o de t°tulo*/ 
    FIND FIRST tt_tit_ap_alteracao_base_1 NO-LOCK NO-ERROR.

    IF AVAIL tt_tit_ap_alteracao_base_1 THEN 
    DO:
     RUN prgfin/apb/apb767zc.py (INPUT 1,
                                 INPUT "APB",
                                 INPUT '',        /*cod_matriz_trad_org_ext*/
                                 INPUT-OUTPUT TABLE tt_tit_ap_alteracao_base_1,
                                 INPUT-OUTPUT TABLE tt_tit_ap_alteracao_rateio,
                                 OUTPUT TABLE tt_log_erros_tit_ap_alteracao).
    END.
      
    /*Zera API*/
    FOR EACH tt_tit_ap_alteracao_base_1:
       DELETE tt_tit_ap_alteracao_base_1.
    END.

    FOR EACH tt_tit_ap_alteracao_rateio:
       DELETE tt_tit_ap_alteracao_rateio.
    END.
    
    FIND FIRST tt_log_erros_tit_ap_alteracao NO-LOCK 
         WHERE tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 6542 NO-ERROR.
    IF AVAIL tt_log_erros_tit_ap_alteracao THEN 
    DO:
      l_erro_api = YES.
      ASSIGN v_arq_api_ir = session:temp-directory + "erro_ava_ir.txt".
      OUTPUT TO VALUE(v_arq_api_ir).
      
      /* Erros na execuá∆o da API */
      PUT 'Ocorreram o(s) seguinte(s) erro(s) na ALTERAÄ«O (AVA) do novo t°tulo de comiss∆o no Contas a Pagar:' SKIP. 
      FOR EACH tt_log_erros_tit_ap_alteracao NO-LOCK:
        PUT   "Estab: "     tt_log_erros_tit_ap_alteracao.tta_cod_estab       " ; "       
                             "Fornec: "    tt_log_erros_tit_ap_alteracao.tta_cdn_fornecedor  " ; "     
                             "Espec: "     tt_log_erros_tit_ap_alteracao.tta_cod_espec_docto " ; "    
                             "SÇrie "      tt_log_erros_tit_ap_alteracao.tta_cod_ser_docto   " ; "    
                             "T°tulo: "    tt_log_erros_tit_ap_alteracao.tta_cod_tit_ap      " ; "    
                             "Parc: "      tt_log_erros_tit_ap_alteracao.tta_cod_parcela     " ; "    
                             "Num Msg: "   tt_log_erros_tit_ap_alteracao.ttv_num_mensagem    " ; "       
                             "Desc Msg: "  tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro    " ; "       
                             "Ajuda Msg: " tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda FORMAT "x(200)" " ; " skip. 
      END.
      OUTPUT CLOSE.
    END.

    /*Ocorreu erro na API*/
    IF l_erro_api THEN
    DO:
      MESSAGE 'Ocorreram erros na ALTERAÄ«O no t°tulo de comiss∆o no Contas a Pagar:' SKIP
              'Favor verificar o arquivo: ' v_arq_api_ir VIEW-AS ALERT-BOX INFO BUTTONS OK.
      DISABLE bt-con-repres bt-gera-ir bt-gera-avma bt-gera-avmn bt-estorno bt-confirma bt-det-outros WITH FRAME {&FRAME-NAME}.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaBrowser C-Win 
PROCEDURE piAtualizaBrowser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE v_val_ir AS DECIMAL     NO-UNDO.

    RUN pi-verifica-repres.
    
    FOR EACH tt_imp:
        DELETE tt_imp.
    END.
    
    ASSIGN de_vl_comissao     = 0
           de_vl_comis_s_ir   = 0
           de_vl_impto_ir     = 0
           de_vl_comissao_liq = 0.
    
    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa = v_cod_empres_usuar:

        FOR EACH tit_ap no-lock
            WHERE tit_ap.cod_estab           = estabelecimento.cod_estab
              AND tit_ap.cdn_fornecedor      = INT(fornec:SCREEN-VALUE IN FRAME frame-1) 
              AND tit_ap.cod_espec_docto     = "CPO"
              AND tit_ap.dat_liquidac_tit_ap = 12/31/9999
              AND tit_ap.dat_transacao      >= DATE(data-ini:SCREEN-VALUE IN FRAME frame-1)
              AND tit_ap.dat_transacao      <= DATE(data-fim:SCREEN-VALUE IN FRAME frame-1)
              AND tit_ap.val_sdo_tit_ap     > 0:
            
            FIND FIRST movto_tit_ap OF tit_ap NO-LOCK
                 WHERE movto_tit_ap.ind_trans_ap_abrev = "IMPL" 
                   AND movto_tit_ap.log_movto_estordo  = YES NO-ERROR.
            IF AVAIL movto_tit_ap THEN
              NEXT.
        
            ASSIGN v_val_ir = 0.
            FOR EACH movto_tit_ap OF tit_ap NO-LOCK
                WHERE movto_tit_ap.ind_trans_ap_abrev = "AVMN"
                  AND movto_tit_ap.LOG_movto_estordo  = NO,
                FIRST aprop_ctbl_ap OF movto_tit_ap 
                WHERE aprop_ctbl_ap.cod_cta_ctbl = v_ct_codigo:
                ASSIGN v_val_ir = v_val_ir + movto_tit_ap.val_movto_ap.
            END.
    
    
            CREATE tt_imp.
            ASSIGN tt_imp.cod_estab             = tit_ap.cod_estab
                   tt_imp.cdn_fornecedor        = tit_ap.cdn_fornec
                   tt_imp.cod_ser_docto         = tit_ap.cod_ser_docto
                   tt_imp.cod_espec_docto       = tit_ap.cod_espec_docto
                   tt_imp.cod_tit_ap            = tit_ap.cod_tit_ap
                   tt_imp.num_id_tit_ap         = tit_ap.num_id_tit_ap
                   tt_imp.cod_parcela           = string(tit_ap.cod_parcela,"99")
                   tt_imp.dat_vencto_tit_ap     = tit_ap.dat_vencto_tit_ap 
                   tt_imp.dat_liquidac_tit_ap   = tit_ap.dat_liquidac_tit_ap 
                   tt_imp.cdn_cliente           = tit_ap.cdn_fornec
                   tt_imp.val_origin_tit_ap     = tit_ap.val_sdo_tit_ap + v_val_ir /* sdo atual + IR*/
                   tt_imp.val_sdo_tit_ap        = tit_ap.val_sdo_tit_ap            /* sdo sem IR    */.
        
            ASSIGN de_vl_comissao    = de_vl_comissao   + tt_imp.val_origin_tit_ap
                   de_vl_comis_s_ir  = de_vl_comis_s_ir + tit_ap.val_sdo_tit_ap.
    
        END.

    END.


    IF de_vl_comissao <> 0 
       THEN ASSIGN de_vl_impto_ir     = de_vl_comissao - de_vl_comis_s_ir
                   de_vl_comissao_liq = de_vl_comissao - de_vl_impto_ir.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLista_variavel C-Win 
PROCEDURE piLista_variavel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN vl-comis-fis:SCREEN-VALUE IN FRAME frame-1   = string(de_vl_comissao)
           vl-ir:SCREEN-VALUE IN FRAME frame-1          = STRING(de_vl_impto_ir)
           vl-liquido:SCREEN-VALUE IN FRAME frame-1     = STRING(de_vl_comissao_liq)
           vl-outros-db:SCREEN-VALUE IN FRAME frame-1   = STRING(de_vl_deb)
           vl-outros-cr:SCREEN-VALUE IN FRAME frame-1   = STRING(de_vl_cred)
           vl-bruto-apb:SCREEN-VALUE IN FRAME frame-1   = STRING(de_vl_comissao)
           vl-liquido-apb:SCREEN-VALUE IN FRAME frame-1 = STRING(de_vl_comissao_liq + de_vl_deb + de_vl_cred).   

   IF  de_vl_impto_ir <> ROUND(de_vl_comissao * 0.015, 2)
   AND ROUND(de_vl_comissao * 0.015, 2) >= 10
   THEN DO: 
        ASSIGN vl-ir:FGCOLOR IN FRAME frame-1 = 12.
   END.
   ELSE DO: 
        ASSIGN vl-ir:FGCOLOR IN FRAME frame-1 = ?.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piReferencia C-Win 
PROCEDURE piReferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM p_data AS DATE NO-UNDO.
    DEF INPUT  PARAM p_seq  AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p_cod_refer AS CHAR NO-UNDO.
    
    
    DEF VAR v_data_aux  AS CHAR            NO-UNDO.
    def var v_num_aux   as integer         no-undo. 
    def var v_num_aux_2 as integer         no-undo. 
    def var v_num_cont  as integer         no-undo. 
    
    
    assign v_data_aux  = string(p_data,"99999999")
           p_cod_refer = substring(v_data_aux,1,2)
                       + substring(p_seq,1,4)
           v_num_aux_2 = integer(this-procedure:handle).

    do  v_num_cont = 1 to 7:
        assign v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               p_cod_refer = p_cod_refer + chr(v_num_aux).
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
