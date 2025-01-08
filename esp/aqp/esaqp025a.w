&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i ESAQP025A 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESAQP025A
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

/*
&GLOBAL-DEFINE ttTable           tt-auditoria-geral
&GLOBAL-DEFINE hDBOTable         h-boes671
&GLOBAL-DEFINE DBOTable          auditoria-geral*/


&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Widgets      btOK btCancel ~
                                 c-cod-unid-negoc ~
                                 v-dt-amostragem i-qt-apar-test ~
                                 i-nr-seq-tipo-lote l-log-revisado ~
                                 i-qt-prod-lote i-qtd-prod-revis i-qtd-problema ~
                                 c-descricao fi-nr-linha

/*&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields*/

define temp-table tt-reinspecao like auditoria-geral.

/* Parameters Definitions ---                                          */
define input parameter pRowid as rowid no-undo.

/* Local Variable Definitions ---                                       */
define buffer bf-auditoria-geral for auditoria-geral.
                                                

DEFINE VARIABLE wh-pesquisa AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

{esp/es0018.i}

def new Global shared var c-seg-usuario  as char format "x(12)" no-undo.

def new global shared var v_cod_estab_usuar
    as character
    format "x(3)"
    label "Estabelecimento"
    column-label "Estab"
    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-41 RECT-42 fi-desc-estabel ~
fi-desc-produto c-cod-audit-origem c-des-auditor i-cont-reinspecao ~
c-cod-unid-negoc fi-desc-unid-negoc fi-ge-codigo fi-desc-ge fi-nr-linha ~
fi-desc-linha v-dt-amostragem i-qt-apar-test i-nr-seq-tipo-lote ~
fi-desc-tipo-lote l-log-revisado i-qt-prod-lote i-qtd-prod-revis ~
i-qtd-problema c-descricao btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estabel fi-desc-estabel ~
i-nr-seq-auditoria i-it-codigo fi-desc-produto rs-ind-amostragem ~
c-cod-audit-origem c-des-auditor i-cont-reinspecao c-cod-unid-negoc ~
fi-desc-unid-negoc fi-ge-codigo fi-desc-ge fi-nr-linha fi-desc-linha ~
v-dt-amostragem i-qt-apar-test i-nr-seq-tipo-lote fi-desc-tipo-lote ~
l-log-revisado i-qt-prod-lote i-qtd-prod-revis i-qtd-problema c-descricao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-descricao AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 80 BY 3.25.

DEFINE VARIABLE c-cod-audit-origem AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Amostragem Origem" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "x(5)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE c-cod-unid-negoc AS CHARACTER FORMAT "x(3)" 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-des-auditor AS CHARACTER FORMAT "x(30)" 
     LABEL "Funcion rio" 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .88.

DEFINE VARIABLE fi-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-ge AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-linha AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-produto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-tipo-lote AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-unid-negoc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ge-codigo AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Grupo Estoque" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-linha AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Linha Produ‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE i-cont-reinspecao AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Nr Reinspe‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE i-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Produto" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE i-nr-seq-auditoria AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Amostragem" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE i-nr-seq-tipo-lote AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Lote" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE i-qt-apar-test AS DECIMAL FORMAT ">>>,>>>,>>9.9999" INITIAL 0 
     LABEL "Qtd Aparelhos Testados" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE i-qt-prod-lote AS DECIMAL FORMAT ">>>,>>>,>>9.9999" INITIAL 0 
     LABEL "Quantidade Lote" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE i-qtd-problema AS DECIMAL FORMAT ">>>,>>>,>>9.9999" INITIAL 0 
     LABEL "Qtde. Problema" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE i-qtd-prod-revis AS DECIMAL FORMAT ">>>,>>>,>>9.9999" INITIAL 0 
     LABEL "Qtde. Revisada" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE v-dt-amostragem AS DATE FORMAT "99/99/9999" 
     LABEL "Data Amostragem" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE VARIABLE rs-ind-amostragem AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Di ria", 1,
"Reinspe‡Æo", 2,
"Acompanhamento", 3
     SIZE 38 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-41
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.5.

DEFINE RECTANGLE RECT-42
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 12.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE l-log-revisado AS LOGICAL INITIAL no 
     LABEL "Lote Revisado" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-cod-estabel AT ROW 1.25 COL 19 COLON-ALIGNED WIDGET-ID 6
     fi-desc-estabel AT ROW 1.25 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     i-nr-seq-auditoria AT ROW 1.25 COL 73 COLON-ALIGNED WIDGET-ID 2
     i-it-codigo AT ROW 2.25 COL 19 COLON-ALIGNED WIDGET-ID 8
     fi-desc-produto AT ROW 2.25 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     rs-ind-amostragem AT ROW 4.25 COL 19 NO-LABEL WIDGET-ID 28
     c-cod-audit-origem AT ROW 4.25 COL 73 COLON-ALIGNED WIDGET-ID 44
     c-des-auditor AT ROW 5.25 COL 17 COLON-ALIGNED WIDGET-ID 48
     i-cont-reinspecao AT ROW 5.25 COL 73 COLON-ALIGNED WIDGET-ID 46
     c-cod-unid-negoc AT ROW 6.25 COL 17 COLON-ALIGNED WIDGET-ID 4
     fi-desc-unid-negoc AT ROW 6.25 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     fi-ge-codigo AT ROW 7.25 COL 17 COLON-ALIGNED WIDGET-ID 32
     fi-desc-ge AT ROW 7.25 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     fi-nr-linha AT ROW 8.25 COL 17 COLON-ALIGNED WIDGET-ID 34
     fi-desc-linha AT ROW 8.25 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     v-dt-amostragem AT ROW 9.25 COL 17 COLON-ALIGNED WIDGET-ID 50
     i-qt-apar-test AT ROW 9.25 COL 67.29 COLON-ALIGNED WIDGET-ID 16
     i-nr-seq-tipo-lote AT ROW 10.25 COL 17 COLON-ALIGNED WIDGET-ID 14
     fi-desc-tipo-lote AT ROW 10.25 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     l-log-revisado AT ROW 10.25 COL 69 WIDGET-ID 22
     i-qt-prod-lote AT ROW 11.25 COL 17 COLON-ALIGNED WIDGET-ID 18
     i-qtd-prod-revis AT ROW 11.25 COL 41.86 COLON-ALIGNED WIDGET-ID 20
     i-qtd-problema AT ROW 11.25 COL 67.14 COLON-ALIGNED WIDGET-ID 56
     c-descricao AT ROW 12.5 COL 5 NO-LABEL WIDGET-ID 24
     btOK AT ROW 16.21 COL 2
     btCancel AT ROW 16.21 COL 13
     btHelp2 AT ROW 16.21 COL 80
     rtToolBar AT ROW 16 COL 1
     RECT-41 AT ROW 1 COL 1 WIDGET-ID 52
     RECT-42 AT ROW 3.75 COL 1.29 WIDGET-ID 54
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 92.14 BY 16.54
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.63
         WIDTH              = 90
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 92.14
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 92.14
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-it-codigo IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-nr-seq-auditoria IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       i-nr-seq-auditoria:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR RADIO-SET rs-ind-amostragem IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

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


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN "NOK".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    DEFINE VARIABLE d-dt-limite-alt AS DATE        NO-UNDO.

    IF DAY(TODAY) < 8 THEN
       ASSIGN d-dt-limite-alt = TODAY - DAY(TODAY)
              d-dt-limite-alt = d-dt-limite-alt - DAY(d-dt-limite-alt).
    ELSE
       ASSIGN d-dt-limite-alt = TODAY - DAY(TODAY).

    IF input frame fPage0 v-dt-amostragem <= d-dt-limite-alt THEN DO:
       EMPTY TEMP-TABLE tt-prog-ponto.
       RUN esp/es0018p.p (INPUT "esaqp010":U,
                          INPUT 1,
                          INPUT 0,
                          INPUT "":U,
                          OUTPUT TABLE tt-prog-ponto).
       FIND FIRST tt-prog-ponto 
            WHERE tt-prog-ponto.conteudo = c-seg-usuario NO-ERROR.
       IF NOT AVAIL tt-prog-ponto THEN DO:
          MESSAGE "J  ultrapassou a data limite para altera‡Æo. "
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          RETURN NO-APPLY.
       END.
    END.

    find last bf-auditoria-geral no-lock no-error.
    if avail bf-auditoria-geral then
        assign i-nr-seq-auditoria:screen-value in frame fPage0 = string(bf-auditoria-geral.nr-seq-auditoria + 1).
    else
        assign i-nr-seq-auditoria:screen-value in frame fPage0 = "1".

    find first auditoria-geral exclusive-lock
         where auditoria-geral.nr-seq-auditoria = input frame fPage0 i-nr-seq-auditoria no-error.
    if not avail auditoria-geral then
        create auditoria-geral.

    assign auditoria-geral.nr-seq-auditoria  = input frame fPage0 i-nr-seq-auditoria
           auditoria-geral.cod-estabel       = input frame fPage0 c-cod-estabel
           auditoria-geral.it-codigo         = input frame fPage0 i-it-codigo
           auditoria-geral.des-auditor       = input frame fPage0 c-des-auditor
           auditoria-geral.cod-audit-origem  = input frame fPage0 c-cod-audit-origem
           auditoria-geral.cod-unid-negoc    = input frame fPage0 c-cod-unid-negoc
           auditoria-geral.dt-amostragem     = input frame fPage0 v-dt-amostragem    
           auditoria-geral.qt-apar-test      = input frame fPage0 i-qt-apar-test
           auditoria-geral.nr-seq-tipo-lote  = input frame fPage0 i-nr-seq-tipo-lote
           auditoria-geral.log-revisado      = input frame fPage0 l-log-revisado
           auditoria-geral.qt-prod-lote      = input frame fPage0 i-qt-prod-lote
           auditoria-geral.qtd-prod-revis    = input frame fPage0 i-qtd-prod-revis
           auditoria-geral.qt-problema       = input frame fPage0 i-qtd-problema
           auditoria-geral.descricao         = input frame fPage0 c-descricao
           auditoria-geral.nr-linha          = input frame fPage0 fi-nr-linha
           auditoria-geral.ind-amostragem    = 2.    

    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 15825,
                       INPUT "Gerada amostragem de n£mero " + string(auditoria-geral.nr-seq-auditoria) + ".").

    RETURN-VALUE = "OK".
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wWindow
ON F5 OF c-cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:

    {method/ZoomFields.i &ProgramZoom="adzoom/z12ad107.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="c-cod-estabel"
                         &Frame1="fPage0"
                         &FieldZoom2="nome"
                         &FieldScreen2="fi-desc-estabel"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wWindow
ON LEAVE OF c-cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:

    ASSIGN fi-desc-estabel:SCREEN-VALUE IN FRAME fPage0 = "".

    FOR FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = INPUT FRAME fPage0 c-cod-estabel:

        ASSIGN fi-desc-estabel:SCREEN-VALUE IN FRAME fPage0 = estabelec.nome.

    END.

    RUN pi-busca-linha.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:

    APPLY "F5":U TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc wWindow
ON F5 OF c-cod-unid-negoc IN FRAME fpage0 /* Unidade Neg¢cio */
DO:

    {method/ZoomFields.i &ProgramZoom="inzoom/z01in745.w"
                         &FieldZoom1="cod-unid-negoc"
                         &FieldScreen1="c-cod-unid-negoc"
                         &Frame1="fPage0"
                         &FieldZoom2="des-unid-negoc"
                         &FieldScreen2="fi-desc-unid-negoc"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc wWindow
ON LEAVE OF c-cod-unid-negoc IN FRAME fpage0 /* Unidade Neg¢cio */
DO:

    ASSIGN fi-desc-unid-negoc:SCREEN-VALUE IN FRAME fPage0 = "".

    FOR FIRST unid-negoc NO-LOCK
        WHERE unid-negoc.cod-unid-negoc = INPUT FRAME fPage0 c-cod-unid-negoc:

        ASSIGN fi-desc-unid-negoc:SCREEN-VALUE IN FRAME fPage0 = unid-negoc.des-unid-negoc.

    END.
    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cod-unid-negoc IN FRAME fpage0 /* Unidade Neg¢cio */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ge-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ge-codigo wWindow
ON F5 OF fi-ge-codigo IN FRAME fpage0 /* Grupo Estoque */
DO:

    {include/zoomvar.i &prog-zoom=inzoom/z01in142.w
                        &campo=fi-ge-codigo
                        &campozoom=ge-codigo}

        /*
    {include/zoomvar.i &prog-zoom="inzoom/z01in142.w"
                       &campo="fi-ge-codigo"
                       &campozoom="ge-codigo"
                       &frame="fPage0"
                       &campo2="fi-desc-ge"
                       &campozoom2="descricao"
                       &frame2="fPage0"}
                       */


        /*
    {method/ZoomFields.i &ProgramZoom="inzoom/z01in142.w"
                         &FieldZoom1="ge-codigo"
                         &FieldScreen1="fi-ge-codigo"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-desc-ge"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
                         */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ge-codigo wWindow
ON LEAVE OF fi-ge-codigo IN FRAME fpage0 /* Grupo Estoque */
DO:

    ASSIGN fi-desc-ge:SCREEN-VALUE IN FRAME fpage0 = "".

    FOR FIRST grup-estoque NO-LOCK
        WHERE grup-estoque.ge-codigo = INPUT FRAME fpage0 fi-ge-codigo:

        ASSIGN fi-desc-ge:SCREEN-VALUE IN FRAME fpage0 = grup-estoque.descricao.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ge-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-ge-codigo IN FRAME fpage0 /* Grupo Estoque */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nr-linha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-linha wWindow
ON F5 OF fi-nr-linha IN FRAME fpage0 /* Linha Produ‡Æo */
DO:

    {include/zoomvar.i &prog-zoom="inzoom/z01in186.w"
                       &campo="fi-nr-linha"
                       &campozoom="nr-linha"
                       &frame="fPage0"
                       &campo2="fi-desc-linha"
                       &campozoom2="descricao"
                       &frame2="fPage0"}

        /*
    {method/ZoomFields.i &ProgramZoom="inzoom/z03in186.w"
                         &FieldZoom1="nr-linha"
                         &FieldScreen1="fi-nr-linha"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-desc-linha"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-linha wWindow
ON LEAVE OF fi-nr-linha IN FRAME fpage0 /* Linha Produ‡Æo */
DO:

    ASSIGN fi-desc-linha:SCREEN-VALUE IN FRAME fPage0 = "".

    FOR FIRST lin-prod NO-LOCK
        WHERE lin-prod.cod-estabel = INPUT FRAME fPage0 c-cod-estabel
          AND lin-prod.nr-linha    = INPUT FRAME fPage0 fi-nr-linha:

        ASSIGN fi-desc-linha:SCREEN-VALUE IN FRAME fPage0 = lin-prod.descricao.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-linha wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-nr-linha IN FRAME fpage0 /* Linha Produ‡Æo */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-it-codigo wWindow
ON F5 OF i-it-codigo IN FRAME fpage0 /* Produto */
DO:

    {method/ZoomFields.i &ProgramZoom="inzoom/z22in172.w"
                         &FieldZoom1="it-codigo"
                         &FieldScreen1="i-it-codigo"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao-1"
                         &FieldScreen2="fi-desc-produto"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-it-codigo wWindow
ON LEAVE OF i-it-codigo IN FRAME fpage0 /* Produto */
DO:

    ASSIGN fi-desc-produto:SCREEN-VALUE IN FRAME fPage0 = "".

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = INPUT FRAME fPage0 i-it-codigo:

        ASSIGN fi-desc-produto:SCREEN-VALUE IN FRAME fPage0 = ITEM.desc-item
               fi-ge-codigo:SCREEN-VALUE IN FRAME fPage0 = STRING(ITEM.ge-codigo).

    END.

    RUN pi-busca-linha.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-it-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF i-it-codigo IN FRAME fpage0 /* Produto */
DO:

    APPLY "F5":U TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-nr-seq-tipo-lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-seq-tipo-lote wWindow
ON F5 OF i-nr-seq-tipo-lote IN FRAME fpage0 /* Lote */
DO:

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es678.w"
                         &FieldZoom1="nr-seq-tipo-lote"
                         &FieldScreen1="i-nr-seq-tipo-lote"
                         &Frame1="fPage0"
                         &FieldZoom2="des-lote"
                         &FieldScreen2="fi-desc-tipo-lote"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-seq-tipo-lote wWindow
ON LEAVE OF i-nr-seq-tipo-lote IN FRAME fpage0 /* Lote */
DO:

    ASSIGN fi-desc-tipo-lote:SCREEN-VALUE IN FRAME fpage0 = "".

    FOR FIRST aq-tipo-lote NO-LOCK
        WHERE aq-tipo-lote.nr-seq-tipo-lote = INPUT FRAME fPage0 i-nr-seq-tipo-lote:

        ASSIGN fi-desc-tipo-lote:SCREEN-VALUE IN FRAME fpage0 = aq-tipo-lote.des-lote.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-seq-tipo-lote wWindow
ON MOUSE-MENU-DBLCLICK OF i-nr-seq-tipo-lote IN FRAME fpage0 /* Lote */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayWidgets wWindow 
PROCEDURE afterDisplayWidgets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME fPage0:
        find first auditoria-geral no-lock 
             where rowid(auditoria-geral) = pRowid no-error.
        if avail auditoria-geral then do:
            
            ASSIGN c-des-auditor:SCREEN-VALUE = auditoria-geral.des-auditor
                   c-cod-estabel:SCREEN-VALUE = auditoria-geral.cod-estabel.

            
            assign i-nr-seq-auditoria:sensitive in frame fPage0 = no.
            
            ASSIGN rs-ind-amostragem = 2.
            
            DISP rs-ind-amostragem.
            assign rs-ind-amostragem:sensitive in frame fPage0 = no.
            
            assign i-it-codigo:screen-value in frame fPage0        = string(auditoria-geral.it-codigo)
                   c-cod-audit-origem:screen-value in frame fPage0 = string(auditoria-geral.nr-seq-auditoria)
                   c-cod-unid-negoc:screen-value in frame fPage0   = auditoria-geral.cod-unid-negoc
                   /*fi-ge-codigo:screen-value in frame fPage0       = tt-reinspecao.*/
                   fi-nr-linha:screen-value in frame fPage0        = string(auditoria-geral.nr-linha)
                   v-dt-amostragem:screen-value in frame fPage0    = string(auditoria-geral.dt-amostragem)
                   i-qt-apar-test:screen-value in frame fPage0     = string(auditoria-geral.qt-apar-test)
                   i-nr-seq-tipo-lote:screen-value in frame fPage0 = string(auditoria-geral.nr-seq-tipo-lote)
                   l-log-revisado:checked in frame fPage0          = auditoria-geral.log-revisado
                   i-qt-prod-lote:screen-value in frame fPage0     = string(auditoria-geral.qt-prod-lote)
                   i-qtd-prod-revis:screen-value in frame fPage0   = string(auditoria-geral.qtd-prod-revis)
                   i-qtd-problema:screen-value in frame fPage0     = string(auditoria-geral.qt-problema)
                   c-descricao:screen-value in frame fPage0        = auditoria-geral.descricao.
            
            APPLY "LEAVE" TO c-cod-estabel.
            APPLY "LEAVE" TO i-it-codigo.
            APPLY "LEAVE" TO c-cod-unid-negoc.
            APPLY "LEAVE" TO fi-ge-codigo.
            APPLY "LEAVE" TO fi-nr-linha.
            APPLY "LEAVE" TO i-nr-seq-tipo-lote.
        end.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-linha wWindow 
PROCEDURE pi-busca-linha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*ASSIGN fi-nr-linha:SCREEN-VALUE IN FRAME fPage0 = "".*/

    /*FOR FIRST item-uni-estab NO-LOCK
        WHERE item-uni-estab.cod-estabel = INPUT FRAME fPage0 c-cod-estabel
        AND   item-uni-estab.it-codigo   = INPUT FRAME fPage0 i-it-codigo:

        ASSIGN fi-nr-linha:SCREEN-VALUE IN FRAME fPage0 = string(item-uni-estab.nr-linha).

    END.*/

    APPLY "LEAVE" TO fi-nr-linha IN FRAME fPage0.
    APPLY "LEAVE" TO c-cod-estabel IN FRAME fPage0.
    APPLY "LEAVE" TO i-it-codigo IN FRAME fPage0.
    APPLY "LEAVE" TO c-cod-unid-negoc IN FRAME fPage0.
    APPLY "LEAVE" TO fi-ge-codigo IN FRAME fPage0.
    APPLY "LEAVE" TO fi-nr-linha IN FRAME fPage0.
    APPLY "LEAVE" TO i-nr-seq-tipo-lote IN FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

