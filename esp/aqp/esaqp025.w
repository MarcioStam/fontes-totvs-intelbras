&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESAQP025 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF*/

CREATE WIDGET-POOL.

{upc/btb910za-upc.i} /* Defini‡Æo da vari vel New Global Shared "v_cod_estab_usuar" */

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-pesquisa AS widget-handle      NO-UNDO.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESAQP025
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE page0Widgets   bt-filtro-geral rs-tip-audit i-nr-seq-aud-proc dt-faixa-ini dt-faixa-fim c-cod-estabel i-nr-seq-tipo-lote c-des-auditor i-nr-linha c-it-codigo i-nr-seq-procedimento i-nr-seq-setor c-unid-negoc btAmostragem btProced tg-revisados tg-nao-revisados
&GLOBAL-DEFINE page1Widgets   br-auditorias
&GLOBAL-DEFINE page2Widgets   

&GLOBAL-DEFINE page1Browse      brAuditorias

&GLOBAL-DEFINE hDBOParent       h-boes671
&GLOBAL-DEFINE DBOParentTable   auditoria-geral
&GLOBAL-DEFINE DBOParentDestroy TRUE

/* Local Variable Definitions ---                                       */
DEFINE variable i-cont         as int       no-undo.
define variable h-boin745      as handle    no-undo.
DEFINE variable {&hDBOParent}  as handle    no-undo.
define variable c-desc-uneg    as character no-undo.
define variable hColuna        as handle    no-undo.
define variable h-prog-amostr  as handle    no-undo.
define variable i-nr-seq-audit as int       no-undo.
define variable c-desc-audit   as character no-undo.

/* Buffer Definitions ---                                                */
define buffer bf-auditoria-geral for auditoria-geral.
define buffer bf-aud-procedimento for aud-procedimento.

/* Temp-table Definitions ---                                            */
define temp-table tt-auditorias no-undo
    field tip-amostragem    as char format "x(20)" label "Tipo Auditoria" 
    field nr-seq-auditoria  as int  label "Amostra/Proced"
    field cod-estabel       as char format "x(05)" label "Estab"
    field it-codigo         as char format "x(16)" label "Produto"
    field des-auditor       as char format "x(30)" label "Auditor"
    field cod-unid-negoc    as char format "x(20)" label "UN Neg¢cio"
    field qtd-testada       as int  label "Qt Testada"
    field nr-linha          as int  label "Linha Produ‡Æo"
    field dt-auditoria      as date label "Data"
    field des-setor         as char format "x(20)" label "Setor"
    field anexo             as char label "Anexo?"
    field log-revisao       as log.

define temp-table tt-reinspecao like auditoria-geral.

def new global shared var v_cod_estab_usuar
    as character
    format "x(5)"
    label "Estabelecimento"
    column-label "Estab"
    no-undo.

DEFINE VARIABLE h-esaqp010 AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-auditorias

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-auditorias

/* Definitions for BROWSE br-auditorias                                 */
&Scoped-define FIELDS-IN-QUERY-br-auditorias tip-amostragem nr-seq-auditoria cod-estabel it-codigo des-auditor cod-unid-negoc qtd-testada nr-linha dt-auditoria des-setor anexo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-auditorias   
&Scoped-define SELF-NAME br-auditorias
&Scoped-define QUERY-STRING-br-auditorias FOR EACH tt-auditorias by tt-auditorias.dt-auditoria desc
&Scoped-define OPEN-QUERY-br-auditorias OPEN QUERY {&SELF-NAME} FOR EACH tt-auditorias by tt-auditorias.dt-auditoria desc.
&Scoped-define TABLES-IN-QUERY-br-auditorias tt-auditorias
&Scoped-define FIRST-TABLE-IN-QUERY-br-auditorias tt-auditorias


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-auditorias}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtKeys RECT-14 RECT-15 rs-tip-audit ~
i-nr-seq-aud-proc i-nr-seq-tipo-lote v_desc_tipo_lote dt-faixa-ini ~
i-nr-linha dt-faixa-fim c-it-codigo c-cod-estabel c-des-auditor ~
tg-revisados i-nr-seq-procedimento tg-nao-revisados i-nr-seq-setor ~
c-unid-negoc bt-filtro-geral btAmostragem btProced btReinsp btAcomp 
&Scoped-Define DISPLAYED-OBJECTS rs-tip-audit i-nr-seq-aud-proc ~
i-nr-seq-tipo-lote v_desc_tipo_lote dt-faixa-ini i-nr-linha ~
v_des_linha_produc dt-faixa-fim c-it-codigo v_des_produto c-cod-estabel ~
c-des-auditor tg-revisados i-nr-seq-procedimento v_des_procedimento ~
tg-nao-revisados i-nr-seq-setor v_des_setor c-unid-negoc v_des_unid_negoc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-filtro-geral 
     IMAGE-UP FILE "image\im-sav":U
     LABEL "bt filtro geral" 
     SIZE 5.14 BY 1.

DEFINE BUTTON btAcomp 
     LABEL "Acompanha" 
     SIZE 10 BY 1.

DEFINE BUTTON btAmostragem 
     LABEL "Amostragem" 
     SIZE 10 BY 1.

DEFINE BUTTON btProced 
     LABEL "Procedimento" 
     SIZE 10.86 BY 1.

DEFINE BUTTON btReinsp 
     LABEL "Reinspe‡Æo" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "x(5)" 
     LABEL "Estabel" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .79 NO-UNDO.

DEFINE VARIABLE c-des-auditor AS CHARACTER FORMAT "x(30)" 
     LABEL "Auditor" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Produto" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE c-unid-negoc AS CHARACTER FORMAT "X(5)":U 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE dt-faixa-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     LABEL "Data Final" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE dt-faixa-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Inicial" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-linha AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Linha Produ‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE i-nr-seq-aud-proc AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Amostra/Procedimento" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-seq-procedimento AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Procedimento" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88.

DEFINE VARIABLE i-nr-seq-setor AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Setor" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-seq-tipo-lote AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Tipo de Lote" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE v_desc_tipo_lote AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE v_des_linha_produc AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88.

DEFINE VARIABLE v_des_procedimento AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88.

DEFINE VARIABLE v_des_produto AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88.

DEFINE VARIABLE v_des_setor AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE v_des_unid_negoc AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE rs-tip-audit AS INTEGER INITIAL 5 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Di ria", 1,
"Reinspe‡Æo", 2,
"Acompanhamento", 3,
"Procedimentos", 4,
"Todos", 5
     SIZE 56 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 100 BY 1.5.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 100 BY 8.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 100 BY 1.25.

DEFINE VARIABLE tg-nao-revisados AS LOGICAL INITIAL yes 
     LABEL "Lotes NÆo Revisados" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE tg-revisados AS LOGICAL INITIAL yes 
     LABEL "Lotes Revisados" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-auditorias FOR 
      tt-auditorias SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-auditorias
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-auditorias wWindow _FREEFORM
  QUERY br-auditorias DISPLAY
      tip-amostragem   
 nr-seq-auditoria
 cod-estabel      
 it-codigo
 des-auditor
 cod-unid-negoc   
 qtd-testada      
 nr-linha         
 dt-auditoria     
 des-setor     
 anexo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 99 BY 10
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     rs-tip-audit AT ROW 1.17 COL 30 NO-LABEL WIDGET-ID 10
     i-nr-seq-aud-proc AT ROW 2.5 COL 42 COLON-ALIGNED WIDGET-ID 16
     i-nr-seq-tipo-lote AT ROW 4 COL 44 COLON-ALIGNED WIDGET-ID 68
     v_desc_tipo_lote AT ROW 4 COL 52.43 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     dt-faixa-ini AT ROW 5 COL 11 COLON-ALIGNED WIDGET-ID 22
     i-nr-linha AT ROW 5 COL 47 COLON-ALIGNED HELP
          "Numero da Linha de Produ‡Æo" WIDGET-ID 38
     v_des_linha_produc AT ROW 5 COL 52.43 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     dt-faixa-fim AT ROW 6 COL 11 COLON-ALIGNED WIDGET-ID 24
     c-it-codigo AT ROW 6 COL 34 COLON-ALIGNED HELP
          "C¢digo do Item" WIDGET-ID 32
     v_des_produto AT ROW 6 COL 52.43 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     c-cod-estabel AT ROW 7 COL 11 COLON-ALIGNED WIDGET-ID 26
     c-des-auditor AT ROW 7 COL 34 COLON-ALIGNED HELP
          "C¢digo do Item" WIDGET-ID 74
     tg-revisados AT ROW 8.25 COL 5 WIDGET-ID 70
     i-nr-seq-procedimento AT ROW 8.58 COL 40 COLON-ALIGNED WIDGET-ID 40
     v_des_procedimento AT ROW 8.58 COL 52.43 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     tg-nao-revisados AT ROW 9.25 COL 5 WIDGET-ID 72
     i-nr-seq-setor AT ROW 9.58 COL 40 COLON-ALIGNED WIDGET-ID 42
     v_des_setor AT ROW 9.58 COL 52.43 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     c-unid-negoc AT ROW 10.58 COL 45 COLON-ALIGNED WIDGET-ID 56
     v_des_unid_negoc AT ROW 10.58 COL 52.43 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     bt-filtro-geral AT ROW 10.58 COL 95 WIDGET-ID 62
     btAmostragem AT ROW 22.17 COL 1.14
     btProced AT ROW 22.17 COL 11 WIDGET-ID 8
     btReinsp AT ROW 22.17 COL 21.72
     btAcomp AT ROW 22.17 COL 31.72
     "Tipo Auditoria:" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 1.38 COL 19.72 WIDGET-ID 60
     rtKeys AT ROW 1 COL 1 WIDGET-ID 2
     RECT-14 AT ROW 2.25 COL 1 WIDGET-ID 18
     RECT-15 AT ROW 3.75 COL 1 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 100.29 BY 22.33
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     br-auditorias AT ROW 1 COL 1 WIDGET-ID 200
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 11.88
         SIZE 100 BY 10.25
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
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 22.33
         WIDTH              = 100
         MAX-HEIGHT         = 22.58
         MAX-WIDTH          = 108.14
         VIRTUAL-HEIGHT     = 22.58
         VIRTUAL-WIDTH      = 108.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN v_des_linha_produc IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v_des_procedimento IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v_des_produto IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v_des_setor IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v_des_unid_negoc IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB br-auditorias 1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-auditorias
/* Query rebuild information for BROWSE br-auditorias
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-auditorias by tt-auditorias.dt-auditoria desc.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-auditorias */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-auditorias
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-auditorias
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-auditorias wWindow
ON VALUE-CHANGED OF br-auditorias IN FRAME fPage1
DO:
    define variable c-tip-amostragem as char no-undo.
    define variable i-nr-seq-audit   as int  no-undo.
    
    if avail tt-auditorias then
        assign hColuna   = br-auditorias:get-browse-column(1):buffer-field in frame fPage1
               c-tip-amostragem = string(hColuna:buffer-value, hColuna:format)
               hColuna   = br-auditorias:get-browse-column(2):buffer-field in frame fPage1
               i-nr-seq-audit = int(string(hColuna:buffer-value, hColuna:format)).

    if c-tip-amostragem = "Di ria" then do:
        assign btAcomp:sensitive in frame fPage0 = yes.
        /*find first bf-auditoria-geral no-lock
             where bf-auditoria-geral.nr-seq-auditoria = i-nr-seq-audit no-error.
        if avail bf-auditoria-geral 
        AND can-find (last auditoria-visual
                        where auditoria-visual.nr-seq-auditoria = auditoria-geral.nr-seq-auditoria) then
            assign btReinsp:sensitive in frame fPage0 = yes. 
        else
            assign btReinsp:sensitive in frame fPage0 = no. */
    end.
    else
        assign /*btReinsp:sensitive in frame fPage0 = no*/
               btAcomp:sensitive in frame fPage0 = no.

    assign btReinsp:sensitive in frame fPage0 = NO.

    if avail tt-auditorias THEN DO:
       assign btReinsp:sensitive in frame fPage0 = YES.
/*        FIND FIRST auditoria-visual NO-LOCK                           */
/*             WHERE auditoria-visual.nr-seq-auditoria = i-nr-seq-audit */
/*               AND auditoria-visual.log-revisao      = YES NO-ERROR.  */
/*        IF AVAIL auditoria-visual THEN                                */
/*           assign btReinsp:sensitive in frame fPage0 = yes.           */
/*        ELSE                                                          */
/*           assign btReinsp:sensitive in frame fPage0 = NO.            */

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-filtro-geral
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtro-geral wWindow
ON CHOOSE OF bt-filtro-geral IN FRAME fpage0 /* bt filtro geral */
DO:
    if input frame fPage0 i-nr-seq-aud-proc = 0 then
        run carregaBrowseGeral.
    else
        run carregaBrowseCodigo.

    apply 'value-changed' to br-auditorias in frame fPage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAcomp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAcomp wWindow
ON CHOOSE OF btAcomp IN FRAME fpage0 /* Acompanha */
DO:
    define variable i-nr-seq-audit as int no-undo.
    define variable i-new-seq-audit as int no-undo.

    if avail tt-auditorias then
        assign hColuna   = br-auditorias:get-browse-column(2):buffer-field in frame fPage1
               i-nr-seq-audit = int(string(hColuna:buffer-value, hColuna:format)).
    
    
    RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 27100, INPUT "Gerar Acompanhamento." + "~~" + "Auditoria gerou acompanhamento?":U).
    if return-value = "yes" then do:
        find last auditoria-geral no-error.
        if avail auditoria-geral then
            assign i-new-seq-audit = auditoria-geral.nr-seq-auditoria + 1.

        find first bf-auditoria-geral no-lock
             where bf-auditoria-geral.nr-seq-auditoria = i-nr-seq-audit no-error.
        if avail bf-auditoria-geral then do:
            create auditoria-geral.
            assign auditoria-geral.ind-amostragem   = 3
                   auditoria-geral.nr-seq-auditoria = i-new-seq-audit.
            buffer-copy bf-auditoria-geral 
                except bf-auditoria-geral.ind-amostragem  
                       bf-auditoria-geral.nr-seq-auditoria to auditoria-geral .

            FOR FIRST auditoria-geral NO-LOCK
                WHERE auditoria-geral.nr-seq-auditoria = i-new-seq-audit:

                RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 15825,
                       INPUT "Gerada amostragem de n£mero " + string(auditoria-geral.nr-seq-auditoria) + ".").


                SESSION:SET-WAIT-STATE("GENERAL":U).  
                RUN esp/aqp/esaqp010.w PERSISTENT SET h-esaqp010.
                RUN InitializeInterface IN h-esaqp010.
                RUN repositionRecord IN h-esaqp010 (INPUT ROWID(auditoria-geral)).
                SESSION:SET-WAIT-STATE("":U).  

            END.

        end.
    end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAmostragem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAmostragem wWindow
ON CHOOSE OF btAmostragem IN FRAME fpage0 /* Amostragem */
DO:
    assign wWindow:sensitive = no.
    
    if avail tt-auditorias then do:
        assign hColuna        = br-auditorias:get-browse-column(1):buffer-field in frame fPage1
               c-desc-audit   = string(hColuna:buffer-value, hColuna:format)
               hColuna        = br-auditorias:get-browse-column(2):buffer-field in frame fPage1
               i-nr-seq-audit = int(string(hColuna:buffer-value, hColuna:format)).

        RUN esp/aqp/esaqp010.w persistent set h-prog-amostr.
        find first bf-auditoria-geral no-lock
             where bf-auditoria-geral.nr-seq-auditoria = i-nr-seq-audit no-error.
        run initializeInterface in h-prog-amostr.
        run pi-posiciona-audit in h-prog-amostr (input rowid(bf-auditoria-geral)).
        
    end.
    else do:
        RUN esp/aqp/esaqp010.w.
    end.

    
    ASSIGN wWindow:SENSITIVE = YES.
    assign h-prog-amostr = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btProced
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btProced wWindow
ON CHOOSE OF btProced IN FRAME fpage0 /* Procedimento */
DO:
    assign wWindow:sensitive = no.

    if avail tt-auditorias then do:
        assign hColuna        = br-auditorias:get-browse-column(1):buffer-field in frame fPage1
               c-desc-audit   = string(hColuna:buffer-value, hColuna:format)
               hColuna        = br-auditorias:get-browse-column(2):buffer-field in frame fPage1
               i-nr-seq-audit = int(string(hColuna:buffer-value, hColuna:format)).
        
        find first bf-aud-procedimento no-lock
             where bf-aud-procedimento.nr-seq-aud-proced = i-nr-seq-audit no-error.

        RUN esp/aqp/esaqp009.w persistent set h-prog-amostr.
        run initializeInterface in h-prog-amostr.
        run pi-posiciona-proced in h-prog-amostr (input rowid(bf-aud-procedimento)).
        
    end.
    else do:
        RUN esp/aqp/esaqp009.w.
    end.

    
    ASSIGN wWindow:SENSITIVE = YES.
    assign h-prog-amostr = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReinsp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReinsp wWindow
ON CHOOSE OF btReinsp IN FRAME fpage0 /* Reinspe‡Æo */
DO:
    
    assign wWindow:sensitive = no.

    assign hColuna   = br-auditorias:get-browse-column(2):buffer-field in frame fPage1
           i-nr-seq-audit = int(string(hColuna:buffer-value, hColuna:format)).
    
    RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 27100, INPUT "Gerar Reinspe‡Æo." + "~~" + "Libera auditoria para nova reinspe‡Æo?":U).
    if return-value = "yes" then do:
        find first bf-auditoria-geral exclusive-lock
             where bf-auditoria-geral.nr-seq-auditoria = i-nr-seq-audit no-error.
        if avail bf-auditoria-geral then do:
            ASSIGN wWindow:SENSITIVE = NO.
            run esp/aqp/esaqp025a.w (input rowid(bf-auditoria-geral)).
            if return-value = "OK":U then
                assign bf-auditoria-geral.cont-reinspecao = bf-auditoria-geral.cont-reinspecao + 1.
            ASSIGN wWindow:SENSITIVE = yes.
        end.
    end.

    assign wWindow:sensitive = yes.
    apply 'choose' to bt-filtro-geral.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-des-auditor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-des-auditor wWindow
ON F5 OF c-des-auditor IN FRAME fpage0 /* Auditor */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                       &campo="c-it-codigo"
                       &campozoom="it-codigo"
                       &campo2="v_des_produto"
                       &campozoom2="desc-item"
                       &frame="fPage0"}
                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-des-auditor wWindow
ON LEAVE OF c-des-auditor IN FRAME fpage0 /* Auditor */
DO:
  FIND FIRST item NO-LOCK
       WHERE item.it-codigo = INPUT FRAME fPage0 c-it-codigo NO-ERROR.
  IF AVAIL item THEN
      ASSIGN v_des_produto:SCREEN-VALUE IN FRAME fPage0 = item.desc-item.
  ELSE
      ASSIGN v_des_produto:SCREEN-VALUE IN FRAME fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-des-auditor wWindow
ON MOUSE-SELECT-DBLCLICK OF c-des-auditor IN FRAME fpage0 /* Auditor */
DO:
  APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON F5 OF c-it-codigo IN FRAME fpage0 /* Produto */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                       &campo="c-it-codigo"
                       &campozoom="it-codigo"
                       &campo2="v_des_produto"
                       &campozoom2="desc-item"
                       &frame="fPage0"}
                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON LEAVE OF c-it-codigo IN FRAME fpage0 /* Produto */
DO:
  FIND FIRST item NO-LOCK
       WHERE item.it-codigo = INPUT FRAME fPage0 c-it-codigo NO-ERROR.
  IF AVAIL item THEN
      ASSIGN v_des_produto:SCREEN-VALUE IN FRAME fPage0 = item.desc-item.
  ELSE
      ASSIGN v_des_produto:SCREEN-VALUE IN FRAME fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF c-it-codigo IN FRAME fpage0 /* Produto */
DO:
  APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-unid-negoc wWindow
ON F5 OF c-unid-negoc IN FRAME fpage0 /* Unidade Neg¢cio */
DO:
  /*&if "{&bf_mat_versao_ems}" >= "2.062" &then   */
   {method/ZoomFields.i
          &ProgramZoom="inzoom/z01in745.w"
          &FieldZoom1="cod-unid-negoc"
          &FieldScreen1="c-unid-negoc"
          &Frame1="fPage0"
          &FieldZoom2="des-unid-negoc"
          &FieldScreen2="v_des_unid_negoc"
          &Frame2="fPage0"
          &EnableImplant="no"}
   /*&endif  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-unid-negoc wWindow
ON LEAVE OF c-unid-negoc IN FRAME fpage0 /* Unidade Neg¢cio */
DO:
  
  run SetConstraintCodigo in h-boin745(input input frame fPage0 c-unid-negoc,
                                       input input frame fPage0 c-unid-negoc).
  run openQueryStatic     in h-boin745(input "Codigo":U).
  if return-value = "OK" then do:
      run getCharField in h-boin745(input "des-unid-negoc",
                                    output c-desc-uneg).
      assign v_des_unid_negoc:screen-value in frame fPage0 = c-desc-uneg. 
  end.
  else
      assign v_des_unid_negoc:screen-value in frame fPage0 = "". 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-unid-negoc wWindow
ON MOUSE-SELECT-DBLCLICK OF c-unid-negoc IN FRAME fpage0 /* Unidade Neg¢cio */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-nr-linha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-linha wWindow
ON F5 OF i-nr-linha IN FRAME fpage0 /* Linha Produ‡Æo */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in186.w"
                      &campo="i-nr-linha"
                      &campozoom="nr-linha"
                      &campo2="v_des_linha_produc"
                      &campozoom2="descricao"
                      &frame="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-linha wWindow
ON LEAVE OF i-nr-linha IN FRAME fpage0 /* Linha Produ‡Æo */
DO:
  FIND FIRST lin-prod NO-LOCK
       WHERE lin-prod.cod-estabel = v_cod_estab_usuar
         AND lin-prod.nr-linha = INPUT FRAME fPage0 i-nr-linha NO-ERROR.
  IF AVAIL lin-prod THEN
      ASSIGN v_des_linha_produc:SCREEN-VALUE IN FRAME fPage0 = lin-prod.descricao.
  ELSE
      ASSIGN v_des_linha_produc:SCREEN-VALUE IN FRAME fPage0 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-linha wWindow
ON MOUSE-SELECT-DBLCLICK OF i-nr-linha IN FRAME fpage0 /* Linha Produ‡Æo */
DO:
  APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-nr-seq-procedimento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-seq-procedimento wWindow
ON F5 OF i-nr-seq-procedimento IN FRAME fpage0 /* Procedimento */
DO:

    {method/ZoomFields.i
          &ProgramZoom="eszoom/z01es667.w"
          &FieldZoom1="nr-seq-procedimento"
          &FieldScreen1="i-nr-seq-procedimento"
          &Frame1="fPage0"
          &FieldZoom2="des-procedimento"
          &FieldScreen2="v_des_procedimento"
          &Frame2="fPage0"
          &EnableImplant="no"}
          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-seq-procedimento wWindow
ON LEAVE OF i-nr-seq-procedimento IN FRAME fpage0 /* Procedimento */
DO:
  FIND FIRST aq-procedimento NO-LOCK
       WHERE aq-procedimento.nr-seq-procedimento = INPUT FRAME fPage0 i-nr-seq-procedimento NO-ERROR.
  IF AVAIL aq-procedimento THEN
      ASSIGN v_des_procedimento:SCREEN-VALUE IN FRAME fPage0 = aq-procedimento.des-procedimento.
  ELSE
      ASSIGN v_des_procedimento:SCREEN-VALUE IN FRAME fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-seq-procedimento wWindow
ON MOUSE-SELECT-DBLCLICK OF i-nr-seq-procedimento IN FRAME fpage0 /* Procedimento */
DO:
  APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-nr-seq-setor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-seq-setor wWindow
ON F5 OF i-nr-seq-setor IN FRAME fpage0 /* Setor */
DO:
  /*&if "{&bf_mat_versao_ems}" >= "2.062" &then   */
   {method/ZoomFields.i
          &ProgramZoom="eszoom\z01es666.w"
          &FieldZoom1="nr-seq-setor"
          &FieldScreen1="i-nr-seq-setor"
          &Frame1="fPage0"
          &FieldZoom2="des-setor"
          &FieldScreen2="v_des_setor"
          &Frame2="fPage0"
          &EnableImplant="no"}
   /*&endif  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-seq-setor wWindow
ON LEAVE OF i-nr-seq-setor IN FRAME fpage0 /* Setor */
DO:
  find first aq-setor no-lock
       where aq-setor.nr-seq-setor = input frame fPage0 i-nr-seq-setor no-error.
  if avail aq-setor then
      assign v_des_setor:screen-value in frame fPage0 = aq-setor.des-setor.
  else
      assign v_des_setor:screen-value in frame fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-seq-setor wWindow
ON MOUSE-SELECT-DBLCLICK OF i-nr-seq-setor IN FRAME fpage0 /* Setor */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-nr-seq-tipo-lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-seq-tipo-lote wWindow
ON F5 OF i-nr-seq-tipo-lote IN FRAME fpage0 /* Tipo de Lote */
DO:

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es678.w"
                         &FieldZoom1="nr-seq-tipo-lote"
                         &FieldScreen1="i-nr-seq-tipo-lote"
                         &Frame1="fPage0"
                         &FieldZoom2="des-lote"
                         &FieldScreen2="v_desc_tipo_lote"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-seq-tipo-lote wWindow
ON LEAVE OF i-nr-seq-tipo-lote IN FRAME fpage0 /* Tipo de Lote */
DO:

    ASSIGN v_desc_tipo_lote:SCREEN-VALUE IN FRAME fpage0 = "".

    FOR FIRST aq-tipo-lote NO-LOCK
        WHERE aq-tipo-lote.nr-seq-tipo-lote = INPUT FRAME fPage0 i-nr-seq-tipo-lote:

        ASSIGN v_desc_tipo_lote:SCREEN-VALUE IN FRAME fpage0 = aq-tipo-lote.des-lote.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-seq-tipo-lote wWindow
ON MOUSE-SELECT-DBLCLICK OF i-nr-seq-tipo-lote IN FRAME fpage0 /* Tipo de Lote */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-tip-audit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tip-audit wWindow
ON VALUE-CHANGED OF rs-tip-audit IN FRAME fpage0
DO:
  if input frame fPage0 rs-tip-audit <> 4 then do:
      assign i-nr-seq-tipo-lote:sensitive in frame fPage0 = yes
             i-nr-linha:sensitive in frame fPage0         = yes
             c-it-codigo:sensitive in frame fPage0        = yes.

      assign i-nr-seq-procedimento:sensitive in frame fPage0 = no
             i-nr-seq-setor:sensitive in frame fPage0        = no
             c-unid-negoc:sensitive in frame fPage0          = no.
  end.
  else do:
      assign i-nr-seq-tipo-lote:sensitive in frame fPage0   = no
             i-nr-linha:sensitive in frame fPage0           = no
             c-it-codigo:sensitive in frame fPage0          = no.

      assign i-nr-seq-procedimento:sensitive in frame fPage0 = yes
             i-nr-seq-setor:sensitive in frame fPage0        = yes
             c-unid-negoc:sensitive in frame fPage0          = yes.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

i-nr-seq-tipo-lote:load-mouse-pointer("image/lupa.cur") IN FRAME fPage0.
i-nr-linha:load-mouse-pointer("image/lupa.cur") IN FRAME fPage0.
c-it-codigo:load-mouse-pointer("image/lupa.cur") IN FRAME fPage0.
i-nr-seq-procedimento:load-mouse-pointer("image/lupa.cur") IN FRAME fPage0.
i-nr-seq-setor:load-mouse-pointer("image/lupa.cur") IN FRAME fPage0.
c-unid-negoc:load-mouse-pointer("image/lupa.cur") IN FRAME fPage0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if not valid-handle(h-boin745) then
        run inbo/boin745.p persistent set h-boin745.

    IF NOT VALID-HANDLE({&hDBOParent}) then
        run esbo/boes671.p persistent set {&hDBOParent}. 
    
    run openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.

    assign dt-faixa-ini:screen-value in frame fPage0  = string(date(month(today),01,year(today)))
           dt-faixa-fim:screen-value in frame fPage0  = string(today)
           c-cod-estabel:screen-value in frame fPage0 = v_cod_estab_usuar.

    apply 'value-changed' to rs-tip-audit.
    apply 'choose' to bt-filtro-geral.

    return "OK":U.

    /*ASSIGN des-auditoria:SENSITIVE IN FRAME fPage1 = YES.

    if pcAction <> "ADD" then
        assign btSave:sensitive in frame fPage0 = no.
    
    FIND FIRST aq-teste NO-LOCK
         WHERE aq-teste.nr-seq-teste = piSeqTeste NO-ERROR.
    IF AVAIL aq-teste THEN DO:
        ASSIGN i-nr-seq-teste:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(aq-teste.nr-seq-teste)
               c-des-teste:SCREEN-VALUE IN FRAME {&FRAME-NAME}    = aq-teste.des-teste.
        
        IF piSeqAudit <> 0 THEN DO: /* Altera‡Æo*/
            ASSIGN i-seq-audit:SCREEN-VALUE IN FRAME fPage1   = string(piSeqAudit)
                   des-auditoria:SCREEN-VALUE IN FRAME fPage1 = aq-teste.auditoria[piSeqAudit].
        END.
        ELSE DO:
            DO i-cont = 1 TO 20:
                IF aq-teste.auditoria[i-cont] = "" THEN DO:
                    ASSIGN i-seq-audit:SCREEN-VALUE IN FRAME fPage1 = STRING(i-cont).
                    LEAVE.
                END.
            END.
        END.
    END.

    apply 'entry' to des-auditoria in frame fPage1.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaBrowseCodigo wWindow 
PROCEDURE carregaBrowseCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    empty temp-table tt-auditorias.
    if input frame fPage0 rs-tip-audit <> 4 then do:

        find first auditoria-geral no-lock
             where auditoria-geral.nr-seq-auditoria = input frame fPage0 i-nr-seq-aud-proc 
               and (if input frame fPage0 rs-tip-audit = 5 then auditoria-geral.ind-amostragem <> 0 else 
                        auditoria-geral.ind-amostragem   = input frame fPage0 rs-tip-audit) no-error.
        if avail auditoria-geral then do:
           find first tt-auditorias 
                where tt-auditorias.nr-seq-auditoria = auditoria-geral.nr-seq-auditoria no-error.
           if not avail tt-auditorias then do:
               create tt-auditorias.
               assign tt-auditorias.nr-seq-auditoria = auditoria-geral.nr-seq-auditoria. 
           end.
        
           run SetConstraintCodigo in h-boin745(input auditoria-geral.cod-unid-negoc,
                                                input auditoria-geral.cod-unid-negoc).
           run openQueryStatic     in h-boin745(input "Codigo":U).
           if return-value = "OK" then do:
               run getCharField in h-boin745(input "des-unid-negoc",
                                             output c-desc-uneg).
               assign tt-auditorias.cod-unid-negoc = c-desc-uneg. 
           end.
           else
               assign tt-auditorias.cod-unid-negoc = "". 
            
           find first item-uni-estab no-lock
                where item-uni-estab.cod-estabel = auditoria-geral.cod-estabel
                  and item-uni-estab.it-codigo   = auditoria-geral.it-codigo no-error.
           if avail item-uni-estab then
               assign tt-auditorias.nr-linha = item-uni-estab.nr-linha.
           else
               assign tt-auditorias.nr-linha = 0.
        
           assign tt-auditorias.cod-estabel       = auditoria-geral.cod-estabel   
                  tt-auditorias.it-codigo         = auditoria-geral.it-codigo     
                  tt-auditorias.qtd-testada       = auditoria-geral.qt-apar-test
                  tt-auditorias.dt-auditoria      = auditoria-geral.dt-amostragem 
                  tt-auditorias.log-revisao       = auditoria-geral.log-revisado.
        
           case auditoria-geral.ind-amostragem:
               when 1 then
                   assign tt-auditorias.tip-amostragem = "Di ria".
               when 2 then
                   assign tt-auditorias.tip-amostragem = "Reinspe‡Æo".
               when 3 then
                   assign tt-auditorias.tip-amostragem = "Acompanhamento".
           end case.
        
           if can-find(first auditoria-anexo
                       where auditoria-anexo.nr-seq-auditoria = auditoria-geral.nr-seq-auditoria) then
               assign tt-auditorias.anexo = "Sim".
           else
               assign tt-auditorias.anexo = "NÆo".
        
        end.


        if input frame fPage0 rs-tip-audit = 5 then do:
            find first aud-procedimento no-lock
                 where aud-procedimento.nr-seq-aud-proced = input frame fPage0 i-nr-seq-aud-proc no-error.
            if avail aud-procedimento then do:
            
                find first tt-auditorias 
                     where tt-auditorias.nr-seq-auditoria = aud-procedimento.nr-seq-aud-proced 
                       and tt-auditorias.tip-amostragem   = "Procedimento" no-error.
                if not avail tt-auditorias then do:
                    create tt-auditorias.
                    assign tt-auditorias.nr-seq-auditoria = aud-procedimento.nr-seq-aud-proced
                           tt-auditorias.tip-amostragem   = "Procedimento". 
                end.
            
                run SetConstraintCodigo in h-boin745(input aud-procedimento.cod-unid-negoc,
                                                     input aud-procedimento.cod-unid-negoc).
                run openQueryStatic     in h-boin745(input "Codigo":U).
                if return-value = "OK" then do:
                    run getCharField in h-boin745(input "des-unid-negoc",
                                                  output c-desc-uneg).
                    assign tt-auditorias.cod-unid-negoc = c-desc-uneg. 
                end.
                else
                    assign tt-auditorias.cod-unid-negoc = "". 
                
                find first aq-setor no-lock
                     where aq-setor.nr-seq-setor = aud-procedimento.nr-seq-setor no-error.
                if avail aq-setor then
                    assign tt-auditorias.des-setor = aq-setor.des-setor.
                else
                    assign tt-auditorias.des-setor = "".
                
                assign tt-auditorias.cod-estabel       = aud-procedimento.cod-estabel   
                       tt-auditorias.dt-auditoria      = aud-procedimento.dt-auditoria.
            end.
        end.
    end.
    else do:
        find first aud-procedimento no-lock
             where aud-procedimento.nr-seq-aud-proced = input frame fPage0 i-nr-seq-aud-proc no-error.
        if avail aud-procedimento then do:
            find first tt-auditorias 
                 where tt-auditorias.nr-seq-auditoria = aud-procedimento.nr-seq-aud-proced 
                   and tt-auditorias.tip-amostragem   = "Procedimento" no-error.
            if not avail tt-auditorias then do:
                create tt-auditorias.
                assign tt-auditorias.nr-seq-auditoria = aud-procedimento.nr-seq-aud-proced
                       tt-auditorias.tip-amostragem   = "Procedimento". 
            end.
       
            run SetConstraintCodigo in h-boin745(input aud-procedimento.cod-unid-negoc,
                                                 input aud-procedimento.cod-unid-negoc).
            run openQueryStatic     in h-boin745(input "Codigo":U).
            if return-value = "OK" then do:
                run getCharField in h-boin745(input "des-unid-negoc",
                                              output c-desc-uneg).
                assign tt-auditorias.cod-unid-negoc = c-desc-uneg. 
            end.
            else
                assign tt-auditorias.cod-unid-negoc = "". 
            
            find first aq-setor no-lock
                 where aq-setor.nr-seq-setor = aud-procedimento.nr-seq-setor no-error.
            if avail aq-setor then
                assign tt-auditorias.des-setor = aq-setor.des-setor.
            else
                assign tt-auditorias.des-setor = "".
            
            assign tt-auditorias.cod-estabel       = aud-procedimento.cod-estabel   
                   tt-auditorias.dt-auditoria      = aud-procedimento.dt-auditoria.
        end.
    end.

   {&open-query-br-auditorias}

    apply 'value-changed' to br-auditorias in frame fPage1.
    
    IF NOT AVAIL tt-auditorias THEN
        ASSIGN btAcomp:sensitive in frame fPage0      = no.
    ELSE
        ASSIGN btAcomp:sensitive in frame fPage0      = yes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaBrowseGeral wWindow 
PROCEDURE carregaBrowseGeral :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    empty temp-table tt-auditorias.
    if input frame fPage0 rs-tip-audit <> 4 then do:
        for each auditoria-geral no-lock
           where auditoria-geral.dt-amostragem   >= input frame fPage0 dt-faixa-ini
             and auditoria-geral.dt-amostragem   <= input frame fPage0 dt-faixa-fim
             /*first item no-lock
             where item.it-codigo = auditoria-geral.it-codigo*/
             break by auditoria-geral.it-codigo:

            IF auditoria-geral.log-revisado AND NOT tg-revisados:CHECKED IN FRAME fPage0 THEN
                NEXT.
            
            IF NOT auditoria-geral.log-revisado AND NOT tg-nao-revisados:CHECKED IN FRAME fPage0 THEN
                NEXT.

            if input frame fPage0 rs-tip-audit <> 5 and
               auditoria-geral.ind-amostragem <> input frame fPage0 rs-tip-audit then
                next.
        
            if input frame fPage0 c-cod-estabel  <> "" and 
               auditoria-geral.cod-estabel <> input frame fPage0 c-cod-estabel then
                next.
        
            if input frame fPage0 i-nr-seq-tipo-lote   <> 0 and 
               auditoria-geral.nr-seq-tipo-lote <> input frame fPage0 i-nr-seq-tipo-lote then
                next.
        
            if input frame fPage0 c-it-codigo <> "" and /** C¢digo produto informado **/
               input frame fPage0 c-it-codigo <> auditoria-geral.it-codigo then
                next.
        
            if input frame fPage0 i-nr-linha  <> 0 and
               input frame fPage0 i-nr-linha  <> auditoria-geral.nr-linha then /** Linha de produ‡Æo informada **/
                next.

            if input frame fPage0 c-des-auditor  <> "" and 
               auditoria-geral.des-auditor <> input frame fPage0 c-des-auditor then
                next.

            find first tt-auditorias 
                 where tt-auditorias.nr-seq-auditoria = auditoria-geral.nr-seq-auditoria no-error.
            if not avail tt-auditorias then do:
                create tt-auditorias.
                assign tt-auditorias.nr-seq-auditoria = auditoria-geral.nr-seq-auditoria. 
            end.

            run SetConstraintCodigo in h-boin745(input auditoria-geral.cod-unid-negoc,
                                                 input auditoria-geral.cod-unid-negoc).
            run openQueryStatic     in h-boin745(input "Codigo":U).
            if return-value = "OK" then do:
                run getCharField in h-boin745(input "des-unid-negoc",
                                              output c-desc-uneg).
                assign tt-auditorias.cod-unid-negoc = c-desc-uneg. 
            end.
            else
                assign tt-auditorias.cod-unid-negoc = "". 
            
            find first item-uni-estab no-lock
                 where item-uni-estab.cod-estabel = auditoria-geral.cod-estabel
                   and item-uni-estab.it-codigo   = auditoria-geral.it-codigo no-error.
                
            assign tt-auditorias.cod-estabel       = auditoria-geral.cod-estabel   
                   tt-auditorias.it-codigo         = auditoria-geral.it-codigo     
                   tt-auditorias.qtd-testada       = auditoria-geral.qt-apar-test   
                   tt-auditorias.nr-linha          = if avail item-uni-estab then item-uni-estab.nr-linha else 0    
                   tt-auditorias.dt-auditoria      = auditoria-geral.dt-amostragem 
                   tt-auditorias.log-revisao       = auditoria-geral.log-revisado
                   tt-auditorias.des-auditor       = auditoria-geral.des-auditor.

            case auditoria-geral.ind-amostragem:
                when 1 then
                    assign tt-auditorias.tip-amostragem = "Di ria".
                when 2 then
                    assign tt-auditorias.tip-amostragem = "Reinspe‡Æo".
                when 3 then
                    assign tt-auditorias.tip-amostragem = "Acompanhamento".
            end case.

            if can-find(first auditoria-anexo
                        where auditoria-anexo.nr-seq-auditoria = auditoria-geral.nr-seq-auditoria) then
                assign tt-auditorias.anexo = "Sim".
            else
                assign tt-auditorias.anexo = "NÆo".
        
        end.

        if input frame fPage0 rs-tip-audit = 5 then do:
            for each aud-procedimento no-lock
               where aud-procedimento.dt-auditoria >= input frame fPage0 dt-faixa-ini
                 and aud-procedimento.dt-auditoria <= input frame fPage0 dt-faixa-fim:
            
                if input frame fPage0 c-cod-estabel  <> "" and 
                   aud-procedimento.cod-estabel <> input frame fPage0 c-cod-estabel then
                    next.
            
                if input frame fPage0 i-nr-seq-procedimento  <> 0 and 
                   aud-procedimento.nr-seq-procedimento <> input frame fPage0 i-nr-seq-procedimento then
                    next.
            
                if input frame fPage0 i-nr-seq-setor  <> 0 and 
                   aud-procedimento.nr-seq-setor <> input frame fPage0 i-nr-seq-setor then
                    next.
            
                if input frame fPage0 c-unid-negoc  <> "" and 
                   aud-procedimento.cod-unid-negoc <> input frame fPage0 c-unid-negoc then
                    next.
            
                find first tt-auditorias 
                     where tt-auditorias.nr-seq-auditoria = aud-procedimento.nr-seq-aud-proced 
                       and tt-auditorias.tip-amostragem   = "Procedimento" no-error.
                if not avail tt-auditorias then do:
                    create tt-auditorias.
                    assign tt-auditorias.nr-seq-auditoria = aud-procedimento.nr-seq-aud-proced
                           tt-auditorias.tip-amostragem   = "Procedimento". 
                end.
            
                run SetConstraintCodigo in h-boin745(input aud-procedimento.cod-unid-negoc,
                                                     input aud-procedimento.cod-unid-negoc).
                run openQueryStatic     in h-boin745(input "Codigo":U).
                if return-value = "OK" then do:
                    run getCharField in h-boin745(input "des-unid-negoc",
                                                  output c-desc-uneg).
                    assign tt-auditorias.cod-unid-negoc = c-desc-uneg. 
                end.
                else
                    assign tt-auditorias.cod-unid-negoc = "". 
            
                find first aq-setor no-lock
                     where aq-setor.nr-seq-setor = aud-procedimento.nr-seq-setor no-error.
                if avail aq-setor then
                    assign tt-auditorias.des-setor = aq-setor.des-setor.
                else
                    assign tt-auditorias.des-setor = "".
            
                assign tt-auditorias.cod-estabel       = aud-procedimento.cod-estabel   
                       tt-auditorias.dt-auditoria      = aud-procedimento.dt-auditoria.
            end.
        end.
    end.
    else do:
        for each aud-procedimento no-lock
           where aud-procedimento.dt-auditoria >= input frame fPage0 dt-faixa-ini
             and aud-procedimento.dt-auditoria <= input frame fPage0 dt-faixa-fim:
            
            if input frame fPage0 c-cod-estabel  <> "" and 
               aud-procedimento.cod-estabel <> input frame fPage0 c-cod-estabel then
                next.

            if input frame fPage0 i-nr-seq-procedimento  <> 0 and 
               aud-procedimento.nr-seq-procedimento <> input frame fPage0 i-nr-seq-procedimento then
                next.

            if input frame fPage0 i-nr-seq-setor  <> 0 and 
               aud-procedimento.nr-seq-setor <> input frame fPage0 i-nr-seq-setor then
                next.

            if input frame fPage0 c-unid-negoc  <> "" and 
               aud-procedimento.cod-unid-negoc <> input frame fPage0 c-unid-negoc then
                next.

            find first tt-auditorias 
                 where tt-auditorias.nr-seq-auditoria = aud-procedimento.nr-seq-aud-proced 
                   and tt-auditorias.tip-amostragem   = "Procedimento" no-error.
            if not avail tt-auditorias then do:
                create tt-auditorias.
                assign tt-auditorias.nr-seq-auditoria = aud-procedimento.nr-seq-aud-proced
                       tt-auditorias.tip-amostragem   = "Procedimento". 
            end.

            run SetConstraintCodigo in h-boin745(input aud-procedimento.cod-unid-negoc,
                                                 input aud-procedimento.cod-unid-negoc).
            run openQueryStatic     in h-boin745(input "Codigo":U).
            if return-value = "OK" then do:
                run getCharField in h-boin745(input "des-unid-negoc",
                                              output c-desc-uneg).
                assign tt-auditorias.cod-unid-negoc = c-desc-uneg. 
            end.
            else
                assign tt-auditorias.cod-unid-negoc = "". 

            find first aq-setor no-lock
                 where aq-setor.nr-seq-setor = aud-procedimento.nr-seq-setor no-error.
            if avail aq-setor then
                assign tt-auditorias.des-setor = aq-setor.des-setor.
            else
                assign tt-auditorias.des-setor = "".

            assign tt-auditorias.cod-estabel       = aud-procedimento.cod-estabel   
                   tt-auditorias.dt-auditoria      = aud-procedimento.dt-auditoria.
        end.
    end.

    {&open-query-br-auditorias}
    
    IF NOT AVAIL tt-auditorias THEN
        assign btAcomp:sensitive in frame fPage0      = no.
    ELSE
        ASSIGN btAcomp:sensitive in frame fPage0      = yes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaRegistro wWindow 
PROCEDURE validaRegistro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*IF INPUT FRAME fPage1 des-auditoria = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Auditoria incorreto." + "~~" + "Descri‡Æo da auditoria deve ser informada.":U).
        RETURN "NOK":U.
    END.

    RETURN "OK":U.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

