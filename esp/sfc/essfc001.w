&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*********************************************************************************/
{include/i-prgvrs.i ESSFC001 2.04.01.003}
{include/i-license-manager.i ESSFC001 FGL}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESSFC001
&GLOBAL-DEFINE Version        1

&GLOBAL-DEFINE WindowType     Master /*/Detail*/

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   FOLDER 

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp btParam btRefresh
                              
&GLOBAL-DEFINE page1Widgets   brTable btReimprime btRepParcial btRepTotal btLimpa

&GLOBAL-DEFINE page2Widgets   fiEtiqueta 

DEF BUFFER b-ord-prod FOR ord-prod.
DEF BUFFER b-item FOR ITEM.
DEF BUFFER b-operacao FOR mgcad.operacao.
DEF BUFFER b-rot-item FOR rot-item.
/* fiQtOrdProd */
/* Parameters Definitions ---                                           */
/*DEFINE VARIABLE hShowMsg AS HANDLE     NO-UNDO.*/
/*{method/dbotterr.i}*/
/*{sfc\sfapi009.i}*/
FIND FIRST param-global NO-LOCK.
FIND FIRST param-estoq  NO-LOCK.
  
{cdp\cd0666.i}
{cep\ceapi001k.i}        /* Definicao de temp-table do movto-estoq */
{cdp/cd9590.i}
{esapi\esapi006tt.i}


 /* Local Variable Definitions ---                                       */
 DEFINE VARIABLE cNomeImp      AS CHAR                    NO-UNDO.
 DEFINE VARIABLE vDatReporte   AS DATE INITIAL TODAY      NO-UNDO.
 DEFINE VARIABLE pNaoImprimir  AS LOG  INITIAL NO         NO-UNDO.
 DEFINE VARIABLE pProcuraSaldo AS LOG  INITIAL YES        NO-UNDO.
 DEFINE VARIABLE l-ver-sel     AS LOG                     NO-UNDO.
 DEFINE VARIABLE v-linha       AS CHARACTER               NO-UNDO.
 DEFINE VARIABLE c-etiqueta    AS CHARACTER               NO-UNDO.
 DEFINE VARIABLE i-it-digito   AS INTEGER                 NO-UNDO.
 DEFINE VARIABLE c-it-codigo   AS CHARACTER               NO-UNDO.
 DEFINE VARIABLE i-qtd-cont    AS INT                     NO-UNDO.
 DEFINE VARIABLE i-nr-cont     AS INT FORMAT ">>9"        NO-UNDO.
 DEFINE VARIABLE c-depos-ent   LIKE deposito.cod-depos    NO-UNDO. 
 DEFINE VARIABLE c-depos-sai   LIKE deposito.cod-depos    NO-UNDO. 
 DEFINE VARIABLE cReturn       AS CHARACTER               NO-UNDO.
 DEFINE VARIABLE l-continua    AS LOGICAL                 NO-UNDO.
 DEFINE VARIABLE l-erro-3      AS LOGICAL                 NO-UNDO.
 DEFINE VARIABLE l-erro        AS LOGICAL                 NO-UNDO.
 DEFINE VARIABLE vTipoReporte  AS CHAR INITIAL "SELETIVO" NO-UNDO.
 DEFINE VARIABLE i-nr-itens    AS INTEGER                 NO-UNDO.
 DEFINE VARIABLE c-cod-localiz AS CHARACTER               NO-UNDO.
 DEF VAR c-conta-contabil LIKE conta-contab.conta-contabil   NO-UNDO.
 DEFINE VARIABLE h-cdapi024 AS HANDLE      NO-UNDO.
 DEFINE VARIABLE h-ceapi001k AS HANDLE      NO-UNDO.
 DEFINE VARIABLE c-unid-negoc AS CHARACTER   NO-UNDO.

 def var c-usuario       as   char .
 def var c-senha         as   char.
 def var c-codigo        as   char format "x(26)".
 def var i-nr-linha      like item.nr-linha.
 def var c-msg-erro      as   char format "x(70)".
 def var c-digito        as   int  format "9" initial 0.
 def var c-quantidade    as   char format "x(06)".
 def var c-ae            as   char format "x(07)".
 def var c-sequencia     as   char format "x(03)".
 def var c-linha         as   char.
 def var da-prox-ae-item as   date.
 def var c-anterior      as   char format "x(40)".
 def var i-quantidade    as   dec.
 def var i-qtd-cont-1    as   int.
 def var de-saldo-linha  like saldo-estoq.qtidade-atu.
 def var c-log as char format "x(80)".
 def var i-nr-req like requisicao.nr-requisicao.
 def var c-serie         as   char format "x(3)". 

 def var c-deposito      as   char format "x(19)".
 def var c-cod-dep       like deposito.cod-depos.
 def var i-qtd-par       as int.
 def var c-enche         as   char.
 def var l-segue         as   log  format "Zim/Nao".
 DEFINE VARIABLE l-perm AS LOGICAL    NO-UNDO.
 DEF VAR cImpSelec       AS CHAR.
 def var lg-achou        as logical.

 DEFINE VARIABLE cTesteEtiqueta AS CHARACTER  INIT "" NO-UNDO.
 DEFINE VARIABLE vArquivo       AS CHARACTER  NO-UNDO.
 DEFINE STREAM LOG.
 DEFINE STREAM sGodoex.
 DEFINE STREAM sZebra.
 DEFINE STREAM sDisp.


def temp-table tt-rep
    field serie like movto-estoq.serie-docto
    field it-codigo like movto-estoq.it-codigo
    field quantidade as dec format ">>>>9" label "QTD"
    field tipo as logical format "N/S"  /* normal/seletivo */
    field hora as char format "x(5)"
    field nr-ae AS INT /*like ae-item.nr-ae*/
    field cod-depos-ent   like movto-estoq.cod-depos
    field sequencia AS INT /*like ae-item.sequencia*/
    FIELD desc-item         LIKE ITEM.desc-item
    FIELD nr-ord-prod LIKE ord-prod.nr-ord-prod
    FIELD cEtiqueta AS CHAR
    index codigo is primary it-codigo.


{esapi\esapi001tt.i}
{esp/es0018.i}
DEF VAR cReporte AS CHAR NO-UNDO.

DEF VAR vLinha   AS CHAR NO-UNDO.
{upc\btb910za-upc.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTable

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-rep

/* Definitions for BROWSE brTable                                       */
&Scoped-define FIELDS-IN-QUERY-brTable tt-rep.serie tt-rep.it-codigo tt-rep.desc-item tt-rep.quantidade tt-rep.hora tt-rep.tipo tt-rep.cod-depos-ent tt-rep.nr-ae tt-rep.sequencia tt-rep.nr-ord-prod   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable   
&Scoped-define SELF-NAME brTable
&Scoped-define QUERY-STRING-brTable FOR EACH tt-rep NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brTable OPEN QUERY {&SELF-NAME} FOR EACH tt-rep NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brTable tt-rep
&Scoped-define FIRST-TABLE-IN-QUERY-brTable tt-rep


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btRefresh btParam btQueryJoins ~
btReportsJoins btExit btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miParam        LABEL "&Param"        
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btParam 
     IMAGE-UP FILE "image/im-param.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-param.bmp":U
     LABEL "Param" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btRefresh 
     IMAGE-UP FILE "image/im-undo.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-undo.bmp":U
     LABEL "Param" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btLimpa 
     LABEL "LIMPA" 
     SIZE 14 BY 2.75.

DEFINE BUTTON btReimprime 
     LABEL "REIMPRIME" 
     SIZE 14 BY 2.75.

DEFINE BUTTON btRepParcial 
     LABEL "PARCIAL" 
     SIZE 14 BY 2.75.

DEFINE BUTTON btRepTotal 
     LABEL "TOTAL" 
     SIZE 14 BY 2.75.

DEFINE VARIABLE fiEtiqueta AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable FOR 
      tt-rep SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable wWindow _FREEFORM
  QUERY brTable NO-LOCK DISPLAY
      tt-rep.serie                       COLUMN-LABEL "Ser."
         tt-rep.it-codigo   FORMAT "x(7)"   COLUMN-LABEL "Item         "
         tt-rep.desc-item   FORMAT "x(30)"  COLUMN-LABEL "Descriá∆o    "
         tt-rep.quantidade  FORMAT ">>,>>9" COLUMN-LABEL "QTD "
         tt-rep.hora                        COLUMN-LABEL "Hora "
         tt-rep.tipo                        COLUMN-LABEL "Tp "
         tt-rep.cod-depos-ent               COLUMN-LABEL "Dep "
         tt-rep.nr-ae                       COLUMN-LABEL "AE"
         tt-rep.sequencia                   COLUMN-LABEL "Seq"
         tt-rep.nr-ord-prod                 COLUMN-LABEL "Ordem"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 12.25
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btRefresh AT ROW 1.13 COL 1.72 HELP
          "Consultas relacionadas"
     btParam AT ROW 1.13 COL 70.72 HELP
          "Consultas relacionadas"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     brTable AT ROW 1 COL 1
     btRepTotal AT ROW 13.25 COL 1
     btRepParcial AT ROW 13.25 COL 20
     btReimprime AT ROW 13.25 COL 58
     btLimpa AT ROW 13.25 COL 76
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.75
         SIZE 90 BY 15.25
         FONT 1.

DEFINE FRAME fPage2
     fiEtiqueta AT ROW 6 COL 32.14 COLON-ALIGNED NO-LABEL
     "Etiqueta C¢digo Barras" VIEW-AS TEXT
          SIZE 15.43 BY .54 AT ROW 5.25 COL 36.43
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.75
         SIZE 89.72 BY 12.25
         FONT 1.


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
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.21
         VIRTUAL-WIDTH      = 146.29
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
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
  NOT-VISIBLE,                                                          */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable 1 fPage1 */
/* SETTINGS FOR FRAME fPage2
   NOT-VISIBLE                                                          */
/* SETTINGS FOR FILL-IN fiEtiqueta IN FRAME fPage2
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable
/* Query rebuild information for BROWSE brTable
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-rep NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brTable */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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


&Scoped-define BROWSE-NAME brTable
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brTable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTable wWindow
ON VALUE-CHANGED OF brTable IN FRAME fPage1
DO:
  IF AVAIL tt-rep THEN
    ASSIGN fiEtiqueta = tt-rep.cEtiqueta
           fiEtiqueta:SCREEN-VALUE IN FRAME fPage2 = tt-rep.cEtiqueta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btLimpa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLimpa wWindow
ON CHOOSE OF btLimpa IN FRAME fPage1 /* LIMPA */
DO:
    FOR EACH   tt-rep:
        DELETE tt-rep.
    END.
    RUN PiFrameEtiqueta(2).
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParam wWindow
ON CHOOSE OF btParam IN FRAME fpage0 /* Param */
OR CHOOSE OF MENU-ITEM miParam IN MENU mbMain DO:

    RUN esp/sfc/essfc001a.w (INPUT-OUTPUT cNomeImp,
                             INPUT-OUTPUT vDatReporte,
                             INPUT-OUTPUT pNaoImprimir,
                             INPUT-OUTPUT pProcuraSaldo).

    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btRefresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRefresh wWindow
ON CHOOSE OF btRefresh IN FRAME fpage0 /* Param */
DO:
    RUN PiFrameEtiqueta(2).
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btReimprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReimprime wWindow
ON CHOOSE OF btReimprime IN FRAME fPage1 /* REIMPRIME */
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Emerson alterou dia 10/07/2013 - Multi Estabelecimento.      
------------------------------------------------------------------------------*/
    
DO:
    DEF VAR v_nom_disposit_so AS CHAR NO-UNDO.
    DEFINE VARIABLE cPrinter AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cLayout AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h_esapi020 AS HANDLE NO-UNDO.

    IF AVAIL tt-rep THEN DO:

        IF tt-rep.nr-ae = 0 THEN DO:
           RUN utp/ut-msgs.p (INPUT "show":U, 
                              INPUT 17567, 
                              INPUT "Nao e possivel reimprimir AE zero!").
           RETURN NO-APPLY.
        END.
    
        /* Verifica se usu†rio escolheu impressora */
        IF cNomeImp = "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "Nenuma impressora Selecionada. Escolha uma impressora antes de reimprimir.").
            RETURN NO-APPLY.
        END.
        
        FOR EACH  ae-item NO-LOCK WHERE
                  ae-item.cod-estabel = v_cod_estab_usuar and
                  ae-item.nr-ae = tt-rep.nr-ae :
    
            /* Imprime Etiqueta de AE */
    
            IF NOT valid-handle(h_esapi020) THEN 
                RUN esapi/esapi020.p PERSISTENT SET h_esapi020.
    
            RUN pi-imprime-AE IN h_esapi020 (INPUT cNomeImp,
                                             INPUT ae-item.cod-estabel,
                                             INPUT ae-item.nr-ae,
                                             INPUT ae-item.sequencia,      
                                             INPUT c-seg-usuario).
    
            
        END.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btRepParcial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRepParcial wWindow
ON CHOOSE OF btRepParcial IN FRAME fPage1 /* PARCIAL */
DO:
    ASSIGN cReporte = "PARCIAL".
    RUN PiFrameEtiqueta(1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btRepTotal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRepTotal wWindow
ON CHOOSE OF btRepTotal IN FRAME fPage1 /* TOTAL */
DO:
    ASSIGN cReporte = "TOTAL".
    RUN PiFrameEtiqueta(1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME fiEtiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiEtiqueta wWindow
ON RETURN OF fiEtiqueta IN FRAME fPage2
DO:
  APPLY "U1" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiEtiqueta wWindow
ON U1 OF fiEtiqueta IN FRAME fPage2
DO:
    RUN piProcessaReporte(INPUT cReporte).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{btb/btb008za.i0} 
{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    HIDE FRAME fPage2.
    VIEW FRAME fPage1.

    FOR FIRST imprsor_usuar NO-LOCK
        WHERE imprsor_usuar.cod_usuario = c-seg-usuario
        AND   imprsor_usuar.log_imprsor_princ:

        FOR FIRST layout_impres NO-LOCK
            WHERE layout_impres.nom_impressora = imprsor_usuar.nom_impressora
            AND   layout_impres.log_layout_impres_princ:

            ASSIGN cNomeImp = layout_impres.nom_impressora + ":" +
                              layout_impres.cod_layout_impres.

        END.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeInitializeInterface wWindow 
PROCEDURE BeforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN fiEtiqueta = cTesteEtiqueta.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piChecaSeletivo wWindow 
PROCEDURE piChecaSeletivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    find first reporte-seletivo 
         where reporte-seletivo.it-codigo     = c-it-codigo
           and reporte-seletivo.data-inicial <= today
           and reporte-seletivo.data-final   >= today
           and reporte-seletivo.quant-saldo  > 0 
           and reporte-seletivo.situacao      = no
           no-lock no-error.
    if avail reporte-seletivo then 
    DO:
        DEFINE VARIABLE txtTipoReporte AS CHARACTER FORMAT "X(70)":U 
            INIT "Existe reporte seletivo programado. Reportar 'Normal' ou 'Seletivo' ?"
            VIEW-AS TEXT 
            SIZE 55 BY .88 NO-UNDO.
        
        DEFINE BUTTON btGoToNormal 
             LABEL "&Normal" 
             SIZE 10 BY 1
             BGCOLOR 8.
        
        DEFINE BUTTON btGoToSeletivo
             LABEL "&Seletivo" 
             SIZE 10 BY 1
             BGCOLOR 8.
        
        DEFINE RECTANGLE rtGoToButton
             EDGE-PIXELS 2 GRAPHIC-EDGE  
             SIZE 60 BY 1.5
             BGCOLOR 7.
    
        DEFINE RECTANGLE rtGoToFields
             EDGE-PIXELS 2 GRAPHIC-EDGE
             SIZE 60 BY 1.5
             BGCOLOR 8.
    
        DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
        
        DEFINE FRAME fReporte
               txtTipoReporte    AT ROW 1.25 COL 5   NO-LABEL
               rtGoToFields      AT ROW 1    COL 1
               btGoToSeletivo    AT ROW 3    COL 2.14
               btGoToNormal      AT ROW 3    COL 13
               rtGoToButton      AT ROW 2.7  COL 1
            SPACE(0.28)
            WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
                 THREE-D SCROLLABLE TITLE "Tipo Reporte Produá∆o" FONT 1
                 DEFAULT-BUTTON btGoToSeletivo CANCEL-BUTTON btGoToNormal.
    
    
        ON "CHOOSE":U OF btGoToSeletivo IN FRAME fReporte DO:
            ASSIGN vTipoReporte = "Seletivo".
            APPLY "GO":U TO FRAME fReporte.
        END.
        ON "CHOOSE":U OF btGoToNormal IN FRAME fReporte DO:
            ASSIGN vTipoReporte = "Normal".
            APPLY "GO":U TO FRAME fReporte.
        END.
        DISP txtTipoReporte
             WITH FRAME fReporte.
        ENABLE btGoToSeletivo btGoToNormal
               WITH FRAME fReporte.
        
        WAIT-FOR "GO":U OF FRAME fReporte.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PiFrameEtiqueta wWindow 
PROCEDURE PiFrameEtiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pTipoFrame AS INT.
    IF pTipoFrame = 1 THEN /* pede reporte */
    DO:

        EMPTY TEMP-TABLE tt-prog-ponto.

        RUN esp/es0018p.p (INPUT "bloq-rep", /* Nome do programa */
                           INPUT 1,          /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto).    
    
        IF CAN-FIND(FIRST tt-prog-ponto NO-LOCK 
                    WHERE entry(1, tt-prog-ponto.conteudo, ";") = v_cod_estab_usuar
                    AND   entry(2, tt-prog-ponto.conteudo, ";") = "bloqueia") THEN DO:

            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17006, 
                               INPUT "Reportes est∆o bloqueados para realizaá∆o do Planejamento. Aguarde liberaá∆o.").
            ASSIGN fiEtiqueta:SCREEN-VALUE IN FRAME fPage2 = cTesteEtiqueta.
            ASSIGN fiEtiqueta:SCREEN-VALUE IN FRAME fPage2 = "".
            RUN PiFrameEtiqueta(2).
            RETURN ERROR.

        END.

        /**/
        
        HIDE FRAME fPage1.
        VIEW FRAME fPage2.

        APPLY "ENTRY" TO fiEtiqueta.
        
    END.
    ELSE DO:
        HIDE FRAME fPage2.
        VIEW FRAME fPage1.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPedeLocaliz wWindow 
PROCEDURE piPedeLocaliz :
DEFINE VARIABLE fiCodLocaliz AS CHARACTER FORMAT "X(16)":U 
        LABEL "Localizacao"
        VIEW-AS FILL-IN
        SIZE 16 BY .88 NO-UNDO.

    DEFINE BUTTON btGoToOK 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE BUTTON btGoToCancela
         LABEL "&Cancela" 
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 60 BY 1.5
         BGCOLOR 7.

    DEFINE RECTANGLE rtGoToFields
         EDGE-PIXELS 2 GRAPHIC-EDGE
         SIZE 60 BY 1.5
         BGCOLOR 8.

    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

    DEFINE FRAME f-atu-loc
           fiCodLocaliz     AT ROW 1.25 COL 15
           rtGoToFields     AT ROW 1    COL 1
           btGoToOK         AT ROW 3    COL 2.14
           btGoToCancela    AT ROW 3    COL 13
           rtGoToButton     AT ROW 2.7  COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Informe Localizaá∆o" FONT 1
             DEFAULT-BUTTON btGoToOk CANCEL-BUTTON btGoToOK.


    ON "CHOOSE":U OF btGoToCancela IN FRAME f-atu-loc DO:
        APPLY "GO":U TO FRAME f-atu-loc.
    END.

    ON "CHOOSE":U OF btGoToOK IN FRAME f-atu-loc DO:
        ASSIGN c-cod-localiz = INPUT FRAME f-atu-loc fiCodLocaliz.
        APPLY "GO":U TO FRAME f-atu-loc.
    END.

    DISP c-cod-localiz @ fiCodLocaliz
         WITH FRAME f-atu-loc.

    ENABLE btGoToOK btGoToCancela fiCodLocaliz
           WITH FRAME f-atu-loc.

    WAIT-FOR "GO":U OF FRAME f-atu-loc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPedeQuantidade wWindow 
PROCEDURE piPedeQuantidade :
DEFINE INPUT PARAM pTipo AS INT.

    DEFINE BUTTON    btGoToOK     AUTO-GO LABEL "&OK" SIZE 10 BY 1 BGCOLOR 8.
    DEFINE RECTANGLE rtGoToFields EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 60 BY 1.3 BGCOLOR 8.
    DEFINE RECTANGLE rtGoToButton EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 60 BY 1.5 BGCOLOR 7.
    DEFINE VARIABLE  fiQuantidade AS INTEGER LABEL "Localizacao" VIEW-AS FILL-IN SIZE 16 BY .88 NO-UNDO.

    DEFINE FRAME fQuantidade
           fiQuantidade     AT ROW 1.25 COL 15
           rtGoToFields     AT ROW 1    COL 1
           btGoToOK         AT ROW 3    COL 2.14
           rtGoToButton     AT ROW 2.7  COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Informe Quantidade" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToOK.

    ON "CHOOSE":U OF btGoToOK IN FRAME fQuantidade DO:
        ASSIGN i-quantidade = INPUT FRAME fQuantidade fiQuantidade.
        IF pTipo = 1 THEN
        DO:
            IF i-quantidade > int(c-quantidade) THEN 
            DO:
                MESSAGE "Quantidade Invalida"
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                RETURN NO-APPLY.
            END.
        END.
        ELSE IF pTipo = 2 THEN
        DO:
            IF i-quantidade > i-qtd-cont-1 THEN
            DO:
                MESSAGE "Quantidade deve ser menor ou igual a do contenedor."
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                RETURN NO-APPLY.
            END.
        END.
        APPLY "GO":U TO FRAME fQuantidade.
    END.

    DISP i-quantidade @ fiQuantidade
         WITH FRAME fQuantidade.

    ENABLE btGoToOK fiQuantidade
           WITH FRAME fQuantidade.

    WAIT-FOR "GO":U OF FRAME fQuantidade.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piProcessaReporte wWindow 
PROCEDURE piProcessaReporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Emerson alterou dia 10/07/2013 - Multi Estabelecimento.      
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pTipoReporte AS CHAR NO-UNDO.

    DEF VAR l-operacao AS LOG.
    
    DEF BUFFER b-ord FOR ord-prod.
    DEF VAR r-row AS ROWID NO-UNDO.

    ASSIGN c-etiqueta = INPUT FRAME fPage2 fiEtiqueta
           v-linha    = SUBSTRING(c-etiqueta,1,15). 

    FOR EACH tt-erro. DELETE tt-erro. END.
    /* BLOCO */ 
    DO: 
        /* Valida etiqueta do reporte */
        
        run esp/es0135.p(INPUT v-linha, output i-it-digito).
        if i-it-digito <> int(substring(c-etiqueta,16,1)) then do:
           run utp/ut-msgs.p (INPUT "show":U, 
                              INPUT 17567, 
                              INPUT "Erro de leitura. " + CHR(10) + 
                                    "Digito verificador n∆o confere.").

           ASSIGN fiEtiqueta:SCREEN-VALUE IN FRAME fPage2 = "".
           RUN PiFrameEtiqueta(2).
           RETURN ERROR.
        END.
        
       
        ASSIGN c-it-codigo = substring(c-etiqueta,1,7)
               i-qtd-cont  = int(substring(c-etiqueta,8,5))
               i-nr-cont   = int(substring(c-etiqueta,13,3)).
               
        FOR FIRST ITEM NO-LOCK 
            WHERE ITEM.it-codigo = c-it-codigo:
        END.
        IF NOT AVAIL ITEM THEN DO:
            run utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "Item n∆o Cadastrado.").
            ASSIGN fiEtiqueta:SCREEN-VALUE IN FRAME fPage2 = "".
            RUN PiFrameEtiqueta(2).
            RETURN ERROR.
        END.
        
        /* Identifica dep¢sitos de Entrada e Sa°da para reporte */
        RUN esapi\esapi005.p (INPUT  ITEM.it-codigo,
                              INPUT  v_cod_estab_usuar,
                              OUTPUT c-depos-ent,
                              OUTPUT c-depos-sai,
                              OUTPUT cReturn).
                          
                              
        IF  cReturn = "NOK" THEN DO:
            run utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "A linha de produá∆o do Item deve ser definida.").
            ASSIGN fiEtiqueta:SCREEN-VALUE IN FRAME fPage2 = "".
            RUN PiFrameEtiqueta(2).
            RETURN ERROR.
        END.
    
        /* verifica se existe ordem aberta para o item */

        FOR EACH b-ord  NO-LOCK
            WHERE b-ord.cod-estabel = v_cod_estab_usuar
            AND   b-ord.it-codigo   = c-it-codigo
            AND   b-ord.estado      = 6, /* Iniciada */ 
            FIRST lin-prod 
                WHERE lin-prod.cod-estabel = b-ord.cod-estabel 
                  AND lin-prod.nr-linha    = b-ord.nr-linha    
                  AND lin-prod.sum-requis  = 1 NO-LOCK
            BY b-ord.nr-ord-prod:
            ASSIGN r-row = ROWID(b-ord).
            LEAVE.
        END.

        FIND ord-prod NO-LOCK
             WHERE rowid(ord-prod) = r-row NO-ERROR.

        IF  NOT AVAIL ord-prod THEN DO:
            FOR EACH b-ord  NO-LOCK
                WHERE b-ord.cod-estabel = v_cod_estab_usuar
                AND   b-ord.it-codigo   = c-it-codigo
                AND   b-ord.estado     < 7, /* Finalizada/Terminada */
                FIRST lin-prod 
                    WHERE lin-prod.cod-estabel = b-ord.cod-estabel 
                      AND lin-prod.nr-linha    = b-ord.nr-linha 
                      AND lin-prod.sum-requis  = 1 NO-LOCK
                BY b-ord.nr-ord-prod:
                ASSIGN r-row = ROWID(b-ord).
                LEAVE.
            END.
        END.

        FIND ord-prod NO-LOCK
             WHERE rowid(ord-prod) = r-row NO-ERROR.

        IF  NOT AVAIL ord-prod THEN DO:
            run utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "N∆o h† Ordens de Produá∆o abertas para o item: " + c-it-codigo + 
                                     ", no estabelecimento " + v_cod_estab_usuar + ".").
            ASSIGN fiEtiqueta:SCREEN-VALUE IN FRAME fPage2 = cTesteEtiqueta.
            ASSIGN fiEtiqueta:SCREEN-VALUE IN FRAME fPage2 = "".
            RUN PiFrameEtiqueta(2).
            RETURN ERROR.
        END. 
        ELSE DO:
            /* Verifica tipo de Requisiá∆o do item */

            FOR FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = ord-prod.it-codigo:
                RUN esapi\esapi006.p ( INPUT ROWID(ITEM),  /* Rowid */
                                       INPUT "",           /* Refer */
                                       INPUT 1,            /* Quantidade */
                                       INPUT 0,            /* Quantidade Liq */
                                       INPUT 0,            /* N°vel */
                                       INPUT-OUTPUT TABLE tt-estrutura,
                                       INPUT TODAY,        /* Data Corte */
                                       INPUT YES,          /* Recursivo */
                                       INPUT 19,           /* N°veis */
                                       INPUT ord-prod.cod-estabel).       /* Estabel */
                FOR EACH tt-estrutura
                    WHERE tt-estrutura.log-fantasma = NO:
                    FOR FIRST item-uni-estab FIELDS(it-codigo tipo-requis) NO-LOCK
                        WHERE item-uni-estab.cod-estabel = ord-prod.cod-estabel
                        AND   item-uni-estab.it-codigo   = tt-estrutura.es-codigo:
                        IF  item-uni-estab.tipo-requis = 3 THEN DO:
                            run utp/ut-msgs.p (INPUT "show":U, 
                                               INPUT 17567, 
                                               INPUT "O Componente " + tt-estrutura.es-codigo + " Ç do tipo de REPORTE GGF, favor verificar.").
                            ASSIGN fiEtiqueta:SCREEN-VALUE IN FRAME fPage2 = cTesteEtiqueta.
                            ASSIGN fiEtiqueta:SCREEN-VALUE IN FRAME fPage2 = "".
                            RUN PiFrameEtiqueta(2).
                            RETURN ERROR.
                        END.
                    END.
                END.
            END.
            
        END.

        IF  pTipoReporte = "PARCIAL" THEN  
            RUN esp\sfc\essfc001b.w(INPUT ITEM.it-codigo,
                                    INPUT-OUTPUT i-qtd-cont).
        IF  i-qtd-cont = 0 THEN
            RETURN ERROR.

        IF  i-qtd-cont > (ord-prod.qt-ordem - ord-prod.qt-produzida) THEN DO:
            
            run utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "Quantidade excede Saldo da Ordem." + CHR(10) + 
                                     "N£mero Ordem: " + STRING(ord-prod.nr-ord-prod) + CHR(10) + 
                                     "Saldo: "        + STRING(ord-prod.qt-ordem - ord-prod.qt-produzida) + CHR(10) + 
                                     "Utilize o reporte parcial para esta quantidade.").
            
            ASSIGN fiEtiqueta:SCREEN-VALUE IN FRAME fPage2 = "".
            RUN PiFrameEtiqueta(2).
            RETURN ERROR.
        END.
        
        /* Seletivo */
        RUN piChecaSeletivo.

        ASSIGN l-Continua = YES.

        RUN piValidaLocaliz. 

        IF NOT l-Continua THEN 
        DO:
            run utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "Localizaá∆o Inv†lida. Reporte Cancelado.").
            ASSIGN fiEtiqueta:SCREEN-VALUE IN FRAME fPage2 = "".
            RUN PiFrameEtiqueta(2).
            RETURN ERROR.
        END.

        /* Verifica se usu†rio selecionou impressora */
        IF cNomeImp = "" THEN DO:
            IF CAN-FIND (FIRST param-depos 
                            WHERE param-depos.cod-estabel = v_cod_estab_usuar AND
                                  param-depos.cod-depos = c-depos-ent AND
                                  param-depos.cria-ae = YES) THEN DO:
                run utp/ut-msgs.p (INPUT "show":U, 
                                   INPUT 17567, 
                                   INPUT "Impressora n∆o selecionada.").
                
            END.
        END.

        FOR EACH ttRepApi. DELETE ttRepApi. END.
        CREATE ttRepApi.
        ASSIGN ttRepApi.nr-ord-produ    = ord-prod.nr-ord-produ
               ttRepApi.op-codigo       = i-nr-cont
               ttRepApi.qt-reporte      = i-qtd-cont
               ttRepApi.depos-ent       = c-depos-ent
               ttRepApi.depos-sai       = c-depos-sai
               ttRepApi.c-enche         = cReporte
               ttRepApi.cEtiqueta       = c-etiqueta
               ttRepApi.c-nome-imp      = cNomeImp
               ttRepApi.cNomeLayout     = cNomeImp
               ttRepApi.nao-imprimir    = pNaoImprimir
               ttRepApi.procura-saldo   = pProcuraSaldo
               ttRepApi.da-data-reporte = vDatReporte  
               ttRepApi.l-ver-sel       = l-ver-sel
               ttRepApi.c-localizacao   = c-cod-localiz
               ttRepApi.linha           = vLinha.

        ASSIGN l-operacao = YES.
        FIND FIRST b-operacao OF item NO-LOCK NO-ERROR.
        IF NOT AVAIL b-operacao THEN ASSIGN l-operacao = NO.
        
        IF l-operacao = NO THEN DO:
            FIND FIRST b-rot-item OF item NO-LOCK NO-ERROR.
            IF NOT AVAIL b-rot-item THEN DO:
                run utp/ut-msgs.p (INPUT "show":U, 
                                   INPUT 17567, 
                                   INPUT "Item deve possuir uma operaá∆o ou roteiro cadastrado. Reporte n∆o pode ser efetuado!").
                RETURN ERROR.
            END.
        END.
        ASSIGN l-operacao = YES.
        FIND FIRST oper-ord 
             WHERE oper-ord.nr-ord-prod = ord-prod.nr-ord-prod NO-LOCK no-error.
        IF NOT AVAIL oper-ord THEN ASSIGN l-operacao = NO.
        
        IF l-operacao = NO THEN DO:
            run utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "A ORDEM " + string(ord-prod.nr-ord-prod) + " deve possuir uma operaá∆o cadastrada. Reporte n∆o pode ser efetuado! ").
            RETURN ERROR.
        END.

        RUN esapi\esapi001-n.p (input v_cod_estab_usuar, 
                                INPUT TABLE ttRepApi, 
                                INPUT vTipoReporte, 
                                OUTPUT TABLE tt-erro, 
                                INPUT-OUTPUT TABLE tt-rep).
        
        IF CAN-FIND (FIRST tt-erro) THEN DO:
           RUN cdp\cd0666.w (INPUT TABLE tt-erro).
           
           RETURN ERROR.
        END. 
    END. /* BLOCO: */
   
    RUN PiFrameEtiqueta(2).
    {&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaLocaliz wWindow 
PROCEDURE piValidaLocaliz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Emerson alterou dia 10/07/2013 - Multi Estabelecimento.
------------------------------------------------------------------------------*/
    FIND FIRST param-depos 
        WHERE param-depos.cod-estabel = v_cod_estab_usuar AND
              param-depos.cod-depos   = c-depos-ent NO-LOCK NO-ERROR.
    IF NOT AVAIL param-depos THEN ASSIGN c-cod-localiz = "".
    
    IF param-depos.loc-autom = NO THEN ASSIGN c-cod-localiz = "".
    ELSE DO: 
        RUN piPedeLocaliz.

        FIND FIRST local 
            WHERE local.cod-estabel = v_cod_estab_usuar
              AND local.cod-depos = c-depos-ent
              AND local.localizacao = c-cod-localiz NO-LOCK NO-ERROR.
        IF NOT AVAIL local THEN DO:
            ASSIGN l-continua = NO.
            
        END.
    END.
          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trata-erro wWindow 
PROCEDURE trata-erro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   disp skip(1) c-msg-erro skip(2)
        with frame f-segue row 06 centered no-labels
        title " A T E N C A O ! ! ! ! ".
   assign l-segue = no.
   REPEAT:
       REPEAT:
           update l-segue label "Voce leu a mensagem acima?" help "Sim/Nao"
           validate(l-segue = yes,"A pergunta deve ser respondida")
           WITH SIDE-LABELS FRAME f-segue 
                VIEW-AS DIALOG-BOX KEEP-TAB-ORDER NO-UNDERLINE 
                THREE-D SCROLLABLE TITLE "A T E N C A O ! ! ! ! " FONT 2.
           hide frame f-segue no-pause.
           IF l-segue THEN LEAVE.
       END.
       IF l-segue THEN LEAVE.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

