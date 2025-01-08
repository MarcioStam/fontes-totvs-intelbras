&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESAPB020 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESAPB020
&GLOBAL-DEFINE Version        2.04.00.001
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Parƒmetros

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          NO
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE page0Widgets   btOk btCancel btHelp2
&GLOBAL-DEFINE page4Widgets   
&GLOBAL-DEFINE page6Widgets   rsDestiny btConfigImpr btFile rsExecution 
&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo c-conta-ava c-email-importacao c-email-imposto de-val-max-ava de-val-min-parcial dt-pagto rs-conciliacao rs-email

&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page6Fields    cFile

/* Parameters Definitions ---                                           */

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar      AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_estab_usuar       AS CHAR NO-UNDO.

/*Tabelas temporarias*/
{esp/apb/esapb020.i}
{esp/es0018.i}

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.

def stream s-imp.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl  AS HANDLE       NO-UNDO.

DEF TEMP-TABLE tt_concil NO-UNDO
    FIELD num_id_tt_concil      AS INT
    FIELD cod_tip_reg           AS INT
    FIELD cod_estab             LIKE tit_ap.cod_estab     
    FIELD cdn_fornec            LIKE tit_ap.cdn_fornec    
    FIELD cod_espec             LIKE tit_ap.cod_espec     
    FIELD cod_ser               LIKE tit_ap.cod_ser      
    FIELD cod_tit_ap            LIKE tit_ap.cod_tit_ap
    FIELD cod_parcela           LIKE tit_ap.cod_parcela
    FIELD dat_transacao         LIKE tit_ap.dat_transacao
    FIELD cod_indic_econ        LIKE tit_ap.cod_indic_econ
    FIELD val_sdo               LIKE tit_ap.val_sdo
    FIELD log_conf              AS LOG LABEL "Status" FORMAT "Sim/NÆo" 
    FIELD des_status            AS CHAR LABEL "Op‡Æo" FORMAT "x(30)"
  INDEX tt_concil
        num_id_tt_concil        ASCENDING
        cod_tip_reg             ASCENDING
        cod_estab               ASCENDING
        cdn_fornec              ASCENDING
        cod_espec               ASCENDING
        cod_ser                 ASCENDING
        cod_tit_ap              ASCENDING
        cod_parcela             ASCENDING
  INDEX tt_concil_tit
        cod_estab               ASCENDING
        cdn_fornec              ASCENDING
        cod_espec               ASCENDING
        cod_ser                 ASCENDING
        cod_tit_ap              ASCENDING
        cod_parcela             ASCENDING.

def temp-table tt_log_erros_atualiz no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac"
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento".

def temp-table tt_log_erros_tit_ap_alteracao no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_cod_tip_msg_dwb              as character format "x(12)" label "Tipo Mensagem" column-label "Tipo Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda_1              as character format "x(250)"
    field ttv_wgh_focus                    as widget-handle format ">>>>>>9".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-vis 
     LABEL "&Visualizar" 
     SIZE 10 BY 1 TOOLTIP "Visualizar antes de executar".

DEFINE BUTTON btCancel 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 6.5.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 37.86 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE c-conta-ava AS CHARACTER FORMAT "x(08)":U 
     LABEL "Conta AVA" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE c-email-importacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Importa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 72 BY .79 NO-UNDO.

DEFINE VARIABLE c-email-imposto AS CHARACTER FORMAT "X(256)":U 
     LABEL "Imposto" 
     VIEW-AS FILL-IN 
     SIZE 72 BY .79 NO-UNDO.

DEFINE VARIABLE de-val-max-ava AS DECIMAL FORMAT ">,>>9.99":U INITIAL 0 
     LABEL "Valor M ximo AVA" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE de-val-min-parcial AS DECIMAL FORMAT ">,>>9.99":U INITIAL 0 
     LABEL "Vl Min Parcial" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 TOOLTIP "Valor m¡nimo para concilia‡äes parciais" NO-UNDO.

DEFINE VARIABLE dt-pagto AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Pagamento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 TOOLTIP "Para agendamento peri¢dico no RPW informe ?" NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 6.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 7.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rs-conciliacao AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Imposto", 1,
"Importa‡Æo", 2,
"Nacional", 3,
"Verbas", 4,
"Todos", 5
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE rs-email AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Conciliadas", 1,
"NÆo Conciliadas", 2,
"Ambas", 3
     SIZE 37 BY 1 NO-UNDO.

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 38 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 23 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 /*42*/ BY 1.75.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 /*39*/ BY 4.5.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 /*42*/ BY 1.75.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 2.5.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44.14 BY 2.96.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37 BY 3.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-vis AT ROW 16.46 COL 3 WIDGET-ID 2
     btOK AT ROW 16.46 COL 14
     btCancel AT ROW 16.46 COL 25
     btHelp2 AT ROW 16.5 COL 81
     rtToolBar AT ROW 16.25 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 92.29 BY 17.04
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage6
     rs-conciliacao AT ROW 2.5 COL 2.9 NO-LABEL WIDGET-ID 2
     dt-pagto AT ROW 2.5 COL 65 COLON-ALIGNED WIDGET-ID 6
     de-val-max-ava AT ROW 3.5 COL 65 COLON-ALIGNED WIDGET-ID 8
     c-conta-ava AT ROW 4.5 COL 65 COLON-ALIGNED WIDGET-ID 10
     rs-email AT ROW 5.25 COL 3 NO-LABEL WIDGET-ID 12
     c-email-imposto AT ROW 7.75 COL 9 COLON-ALIGNED WIDGET-ID 32
     c-email-importacao AT ROW 8.75 COL 9 COLON-ALIGNED WIDGET-ID 34
     rsDestiny AT ROW 11 COL 3 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btConfigImpr AT ROW 12.33 COL 40.86 HELP
          "Configura‡Æo da impressora"
     btFile AT ROW 12.33 COL 40.86 HELP
          "Escolha do nome do arquivo"
     cFile AT ROW 12.38 COL 3 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 11 COL 49 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 10.25 COL 1 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 10.25 COL 46 COLON-ALIGNED NO-LABEL
     de-val-min-parcial AT ROW 5.5 COL 65 COLON-ALIGNED WIDGET-ID 36
     " Tipo Concilia‡Æo" VIEW-AS TEXT
          SIZE 12.86 BY .54 AT ROW 1.75 COL 2.43 WIDGET-ID 18
     " Destinat rios E-mail" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 7 COL 3 WIDGET-ID 30
     " Enviar E-mail Com" VIEW-AS TEXT
          SIZE 13.57 BY .54 AT ROW 4.5 COL 3 WIDGET-ID 26
     " Parƒmetros" VIEW-AS TEXT
          SIZE 8.57 BY .54 AT ROW 1.75 COL 48.57 WIDGET-ID 22
     RECT-7 AT ROW 10.54 COL 2
     RECT-9 AT ROW 10.5 COL 47
     RECT-12 AT ROW 2 COL 2 WIDGET-ID 16
     RECT-13 AT ROW 2 COL 48 WIDGET-ID 20
     RECT-14 AT ROW 4.75 COL 2 WIDGET-ID 24
     RECT-15 AT ROW 7.25 COL 2 WIDGET-ID 28
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 87.43 BY 13.21
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 3.5
         SIZE 84.43 BY 9.46
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     RECT-11 AT ROW 1.5 COL 4 WIDGET-ID 20
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17.04
         WIDTH              = 92.29
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 28.21
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{report/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR BUTTON bt-vis IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-vis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-vis wReport
ON CHOOSE OF bt-vis IN FRAME fpage0 /* Visualizar */
DO:
    ASSIGN rs-conciliacao     = INPUT FRAME fpage6 rs-conciliacao
           dt-pagto           = INPUT FRAME fpage6 dt-pagto
           de-val-max-ava     = INPUT FRAME fpage6 de-val-max-ava
           de-val-min-parcial = INPUT FRAME fpage6 de-val-min-parcial
           c-conta-ava        = INPUT FRAME fpage6 c-conta-ava.

    {esp/apb/esapb020.i2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wReport
ON CHOOSE OF btConfigImpr IN FRAME fPage6
DO:
   {report/rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wReport
ON CHOOSE OF btFile IN FRAME fPage6
DO:
    {report/rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wReport
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
   do  on error undo, return no-apply:
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage6
DO:
    do  with frame fPage6:
        case self:screen-value:
            when "1":U then do:
                assign cFile:sensitive       = no
                       cFile:visible         = yes
                       btFile:visible        = no
                       btConfigImpr:visible  = yes.
            end.
            when "2":U then do:
                assign cFile:sensitive       = yes
                       cFile:visible         = yes
                       btFile:visible        = yes
                       btConfigImpr:visible  = no.
            end.
            when "3":U then do:
                assign cFile:visible         = no
                       cFile:sensitive       = no
                       btFile:visible        = no
                       btConfigImpr:visible  = no.
            END.
        end case.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage6
DO:
   IF  INPUT FRAME fpage6 rsExecution = 1
   THEN DO:
       ASSIGN dt-pagto = TODAY.
       DISPLAY dt-pagto WITH FRAME fpage6.
       ENABLE  bt-vis   WITH FRAME fpage0.
       ENABLE  dt-pagto WITH FRAME fpage6.
   END.
   ELSE DO:
       ASSIGN dt-pagto = TODAY.
       DISPLAY dt-pagto WITH FRAME fpage6.
       DISABLE bt-vis   WITH FRAME fpage0.
       DISABLE dt-pagto WITH FRAME fpage6.
   END.

   {report/rprse.i}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{report/mainblock.i}

VIEW FRAME fpage6.

ENABLE c-conta-ava c-email-importacao c-email-imposto de-val-max-ava de-val-min-parcial dt-pagto rs-conciliacao rs-email WITH FRAME fpage6.
APPLY "entry" TO rs-conciliacao IN FRAME fpage6.

ASSIGN dt-pagto = TODAY.

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT  "esapb020",
                   INPUT  1,
                   INPUT  0,
                   INPUT  "",
                   OUTPUT TABLE tt-prog-ponto).

FOR EACH tt-prog-ponto:

    IF  NUM-ENTRIES(tt-prog-ponto.conteudo,"#") > 1
    THEN DO:
        IF  tt-prog-ponto.conteudo BEGINS "VlMaxAva" 
        THEN 
            ASSIGN de-val-max-ava = DECIMAL(ENTRY(2,tt-prog-ponto.conteudo,"#")) / 100.

        IF  tt-prog-ponto.conteudo BEGINS "VlMinParcial" 
        THEN 
            ASSIGN de-val-min-parcial = DECIMAL(ENTRY(2,tt-prog-ponto.conteudo,"#")) / 100.

        IF  tt-prog-ponto.conteudo BEGINS "ContaAva" 
        THEN 
            ASSIGN c-conta-ava = ENTRY(2,tt-prog-ponto.conteudo,"#").

        IF  tt-prog-ponto.conteudo BEGINS "EmailImposto" 
        THEN 
            ASSIGN c-email-imposto = ENTRY(2,tt-prog-ponto.conteudo,"#").

        IF  tt-prog-ponto.conteudo BEGINS "EmailImportacao" 
        THEN 
            ASSIGN c-email-importacao = ENTRY(2,tt-prog-ponto.conteudo,"#").
    END.
END.

ASSIGN rsExecution    = 1
       rs-conciliacao = 3
       rs-email       = 2.

DISP dt-pagto
     de-val-max-ava
     de-val-min-parcial
     c-conta-ava
     c-email-imposto
     c-email-importacao
     rs-conciliacao
     rs-email
     rsExecution
     WITH FRAME fpage6.

APPLY "value-changed" TO rsExecution IN FRAME fpage6.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wReport 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-visualizar wReport 
PROCEDURE pi-visualizar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define var r-tt-digita as rowid no-undo.

/*:T** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}

    /*15/02/2005 - tech1007 - Teste alterado pois RTF nÆo ‚ mais op‡Æo de Destino*/
    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.
    
    /*:T Coloque aqui as valida‡äes da p gina de Digita‡Æo, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p gina e colocar
       o focus no campo com problemas */
    /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/
    
    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */
    
    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario            = c-seg-usuario
           tt-param.destino            = input frame fPage6 rsDestiny
           tt-param.data-exec          = today
           tt-param.hora-exec          = TIME
           tt-param.i-tipo-concilia    = INPUT FRAME fpage6 rs-conciliacao  
           tt-param.dt-pagto           = INPUT FRAME fpage6 dt-pagto          
           tt-param.de-val-max-ava     = INPUT FRAME fpage6 de-val-max-ava    
           tt-param.de-val-min-parcial = INPUT FRAME fpage6 de-val-min-parcial
           tt-param.c-conta-ava        = INPUT FRAME fpage6 c-conta-ava       
           tt-param.i-tipo-email       = INPUT FRAME fpage6 rs-email      
           tt-param.c-email-imposto    = INPUT FRAME fpage6 c-email-imposto   
           tt-param.c-email-importacao = INPUT FRAME fpage6 c-email-importacao
           tt-param.cod_empres_usuar   = v_cod_empres_usuar
           tt-param.cod_estab_usuar    = v_cod_estab_usuar.

    IF  input frame fPage6 rsExecution = 2 THEN
        ASSIGN tt-param.dt-pagto = ?.
    
    if tt-param.destino = 1 then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
        then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i esp/apb/esapb020rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

