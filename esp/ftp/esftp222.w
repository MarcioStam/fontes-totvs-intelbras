&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/* *******************************************************************************
** Scopel Tech Soluction Ltda
**
** by Luciano Leonhardt
** Vers∆o 001 - 08/06/20021
*******************************************************************************/
{include/i-prgvrs.i esftp222 3.00.00.001}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h_p-exihel                  AS HANDLE       NO-UNDO.

{cdp/cdcfgman.i}
{cpp/cpapi001.i}
{cpp/cpapi001.i1} /*tt-aloca, tt-reservas, tt-mat-reciclado*/
{inbo/boin007a.i1} /* Definiªío das temp-tables   */
{cpp/cpapi013.i14} /* Definiªío da ttAlocaReserva */
{cdp/cd0666.i}
{esp/es0018.i}
{method/dbotterr.i}

{esp/ftp/esftp222.i}

DEFINE VARIABLE raw-param           AS RAW NO-UNDO.
DEFINE VARIABLE v-cod-prog-gerado   AS CHARACTER   NO-UNDO INITIAL "esftp222".
DEF VAR v-cod-extens-arq            AS CHARACTER   NO-UNDO INITIAL "pdf".
DEFINE VARIABLE iSelect AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont               AS INTEGER     NO-UNDO.

{esp/pdp/espdp006fn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-monitor-solar

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-monitor-solar tt-aloc-reservas

/* Definitions for BROWSE br-monitor-solar                              */
&Scoped-define FIELDS-IN-QUERY-br-monitor-solar tt-monitor-solar.cod-estabel tt-monitor-solar.nr-ord-prod tt-monitor-solar.it-codigo tt-monitor-solar.nr-pedido tt-monitor-solar.dt-implant tt-monitor-solar.des-sit-solar tt-monitor-solar.des-sit-wms tt-monitor-solar.des-sit-alocacao tt-monitor-solar.des-sit-op tt-monitor-solar.estado tt-monitor-solar.nr-nota-fis tt-monitor-solar.des-sit-nota tt-monitor-solar.des-forma-emis-nf-eletro tt-monitor-solar.des-sit-nf-eletro tt-monitor-solar.num-serie-solar   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-monitor-solar   
&Scoped-define SELF-NAME br-monitor-solar
&Scoped-define QUERY-STRING-br-monitor-solar FOR EACH tt-monitor-solar
&Scoped-define OPEN-QUERY-br-monitor-solar OPEN QUERY {&SELF-NAME} FOR EACH tt-monitor-solar.
&Scoped-define TABLES-IN-QUERY-br-monitor-solar tt-monitor-solar
&Scoped-define FIRST-TABLE-IN-QUERY-br-monitor-solar tt-monitor-solar


/* Definitions for BROWSE br-reservas                                   */
&Scoped-define FIELDS-IN-QUERY-br-reservas tt-aloc-reservas.nr-ord-prod tt-aloc-reservas.it-codigo tt-aloc-reservas.quant-orig tt-aloc-reservas.quant-atend tt-aloc-reservas.quant-aloc tt-aloc-reservas.saldoFnEstoque //tt-aloc-reservas.ind-situacao-alocacao tt-aloc-reservas.des-sit-alocacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-reservas   
&Scoped-define SELF-NAME br-reservas
&Scoped-define QUERY-STRING-br-reservas FOR  EACH tt-aloc-reservas                             WHERE tt-aloc-reservas.nr-ord-prod = tt-monitor-solar.nr-ord-prod
&Scoped-define OPEN-QUERY-br-reservas OPEN QUERY {&SELF-NAME} FOR  EACH tt-aloc-reservas                             WHERE tt-aloc-reservas.nr-ord-prod = tt-monitor-solar.nr-ord-prod.
&Scoped-define TABLES-IN-QUERY-br-reservas tt-aloc-reservas
&Scoped-define FIRST-TABLE-IN-QUERY-br-reservas tt-aloc-reservas


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-monitor-solar}~
    ~{&OPEN-QUERY-br-reservas}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-monitor-solar br-reservas 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-programa 
       MENU-ITEM mi-consultas   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
              DISABLED
       MENU-ITEM mi-imprimir    LABEL "&Relat¢rios"    ACCELERATOR "CTRL-P"
              DISABLED
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X"
              DISABLED.

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
              DISABLED
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     
              DISABLED.

DEFINE MENU m-livre MENUBAR
       SUB-MENU  mi-programa    LABEL "_"             
              DISABLED
       SUB-MENU  m_Ajuda        LABEL "_"             
              DISABLED.


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-exit-2 
     IMAGE-UP FILE "image/toolbar/im-exi":U
     IMAGE-DOWN FILE "image/toolbar/ii-exi":U
     LABEL "" 
     SIZE 5 BY 1.5 TOOLTIP "Sair".

DEFINE BUTTON btAtualiza 
     IMAGE-UP FILE "image/toolbar/im-relo.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-relo.bmp":U
     LABEL "Query Joins" 
     SIZE 5 BY 1.5 TOOLTIP "Atualizar Grid"
     FONT 5.

DEFINE BUTTON btExcel 
     IMAGE-UP FILE "image/toolbar/im-excel":U
     IMAGE-INSENSITIVE FILE "image/toolbar/im-excel.bmp":U
     LABEL "Gerar Excel" 
     SIZE 5 BY 1.5 TOOLTIP "Exporta CSV"
     FONT 5.

DEFINE BUTTON btPrint 
     IMAGE-UP FILE "image/toolbar/im-pri":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-pri":U
     LABEL "Gerar Excel" 
     SIZE 5 BY 1.5 TOOLTIP "Imprimir Seleá∆o"
     FONT 5.

DEFINE BUTTON btSelecao 
     IMAGE-UP FILE "image/toolbar/im-ran":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-ran":U
     LABEL "Seleá∆o" 
     SIZE 5 BY 1.5 TOOLTIP "Filtro"
     FONT 5.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cbImpr AS CHARACTER FORMAT "X(256)":U INITIAL "Sem Impressoras Cadastradas no Sistema Operacional" 
     LABEL "Impressora" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Sem Impressoras Cadastradas no Sistema Operacional","Sem Impressoras Cadastradas no Sistema Operacional"
     DROP-DOWN-LIST
     SIZE 51 BY 1 NO-UNDO.

DEFINE VARIABLE cFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 51 BY .88 NO-UNDO.

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora":U, 1,
"Arquivo":U, 2,
"Terminal":U, 3
     SIZE 44 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE tg-imp-Estrutura AS LOGICAL INITIAL no 
     LABEL "Estrutura" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-imp-folhaRosto AS LOGICAL INITIAL no 
     LABEL "Folha de Rosto" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

DEFINE VARIABLE tg-imp-Manual AS LOGICAL INITIAL no 
     LABEL "Manual" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-imp-notafiscal AS LOGICAL INITIAL no 
     LABEL "Nota Fiscal" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-imp-romaneio AS LOGICAL INITIAL no 
     LABEL "Romaneio" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-reimprimir AS LOGICAL INITIAL no 
     LABEL "ReImprimir" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE BUTTON bt-alocar 
     LABEL "Alocar" 
     SIZE 13 BY 1.

DEFINE BUTTON bt-ord-prod 
     LABEL "Sumarizar" 
     SIZE 13 BY 1.

DEFINE BUTTON bt-rep-ord 
     LABEL "Reportar Ordem Luiz1" 
     SIZE 13 BY 1.

DEFINE BUTTON bt-libera-WMS 
     LABEL "Liberar Saldo" 
     SIZE 13 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-monitor-solar FOR 
      tt-monitor-solar SCROLLING.

DEFINE QUERY br-reservas FOR 
      tt-aloc-reservas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-monitor-solar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-monitor-solar w-livre _FREEFORM
  QUERY br-monitor-solar DISPLAY
      tt-monitor-solar.cod-estabel
    tt-monitor-solar.nr-ord-prod
    tt-monitor-solar.it-codigo
    tt-monitor-solar.nr-pedido
    tt-monitor-solar.dt-implant
    tt-monitor-solar.des-sit-solar
    tt-monitor-solar.des-sit-wms
    tt-monitor-solar.des-sit-alocacao
    tt-monitor-solar.des-sit-op
    tt-monitor-solar.estado
    tt-monitor-solar.nr-nota-fis
    tt-monitor-solar.des-sit-nota
    tt-monitor-solar.des-forma-emis-nf-eletro
    tt-monitor-solar.des-sit-nf-eletro
    tt-monitor-solar.num-serie-solar
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS MULTIPLE SIZE 179 BY 14.25
         TITLE "Monitor Solar".

DEFINE BROWSE br-reservas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-reservas w-livre _FREEFORM
  QUERY br-reservas DISPLAY
      tt-aloc-reservas.nr-ord-prod
    tt-aloc-reservas.it-codigo
tt-aloc-reservas.quant-orig
tt-aloc-reservas.quant-atend
tt-aloc-reservas.quant-aloc
tt-aloc-reservas.saldoFnEstoque
//tt-aloc-reservas.ind-situacao-alocacao
tt-aloc-reservas.des-sit-alocacao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS MULTIPLE SIZE 90 BY 7
         TITLE "Reservas".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     br-monitor-solar AT ROW 5.75 COL 1 WIDGET-ID 200
     br-reservas AT ROW 20.25 COL 1 WIDGET-ID 1800
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 179.57 BY 26.38 WIDGET-ID 100.

DEFINE FRAME frameWMS
     bt-libera-WMS AT ROW 1.25 COL 2 WIDGET-ID 212
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 28 ROW 1.25
         SIZE 25 BY 4.25
         BGCOLOR 17 FONT 10
         TITLE "WMS" WIDGET-ID 1500.

DEFINE FRAME frameProducao
     bt-ord-prod AT ROW 1.25 COL 2 WIDGET-ID 204
     bt-alocar AT ROW 2.25 COL 2 WIDGET-ID 214
     bt-rep-ord AT ROW 3.25 COL 2 WIDGET-ID 208
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 1.25
         SIZE 25 BY 4.25
         BGCOLOR 17 FONT 10
         TITLE "Produá∆o" WIDGET-ID 1400.

DEFINE FRAME frameImprimir
     tg-imp-notafiscal AT ROW 1.25 COL 2 WIDGET-ID 78
     tg-imp-romaneio AT ROW 2 COL 2 WIDGET-ID 90
     tg-imp-Manual AT ROW 2.75 COL 2 WIDGET-ID 92
     tg-imp-Estrutura AT ROW 1.25 COL 14 WIDGET-ID 94
     tg-imp-folhaRosto AT ROW 2 COL 14 WIDGET-ID 96
     tg-reimprimir AT ROW 2.75 COL 14 WIDGET-ID 100
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 54 ROW 1.25
         SIZE 30 BY 4.25
         BGCOLOR 17 FONT 10
         TITLE "Imprimir" WIDGET-ID 1300.

DEFINE FRAME frameAcoes
     btPrint AT ROW 1 COL 2 HELP
          "Gerar Relatorio Excel" WIDGET-ID 174
     btExcel AT ROW 1 COL 7 HELP
          "Gerar Relatorio Excel" WIDGET-ID 226
     btSelecao AT ROW 2.75 COL 2 HELP
          "Seleá∆o" WIDGET-ID 176
     btAtualiza AT ROW 2.75 COL 7 HELP
          "Atualizar" WIDGET-ID 160
     bt-exit-2 AT ROW 2.75 COL 24 WIDGET-ID 178
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 150 ROW 1.25
         SIZE 30 BY 4.25
         BGCOLOR 17 FONT 10
         TITLE "Aá‰es" WIDGET-ID 1700.

DEFINE FRAME frameDestino
     cFile AT ROW 2.25 COL 9 COLON-ALIGNED WIDGET-ID 228
     rsDestiny AT ROW 1.25 COL 11 HELP
          "Destino de Impress∆o do Relat¢rio":U NO-LABEL WIDGET-ID 210
     cbImpr AT ROW 2.25 COL 9 COLON-ALIGNED WIDGET-ID 214
     btFile AT ROW 2.17 COL 58 HELP
          "Escolha do nome do arquivo":U WIDGET-ID 218
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 85 ROW 1.25
         SIZE 64 BY 4.25
         BGCOLOR 17 FONT 10
         TITLE "Destino" WIDGET-ID 1600.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-livre ASSIGN
         HIDDEN             = YES
         TITLE              = "Template Livre <Insira complemento>"
         HEIGHT             = 30
         WIDTH              = 180
         MAX-HEIGHT         = 31.46
         MAX-WIDTH          = 212.43
         VIRTUAL-HEIGHT     = 31.46
         VIRTUAL-WIDTH      = 212.43
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-livre:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-livre 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-livre.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-livre
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME frameAcoes:FRAME = FRAME f-cad:HANDLE
       FRAME frameDestino:FRAME = FRAME f-cad:HANDLE
       FRAME frameImprimir:FRAME = FRAME f-cad:HANDLE
       FRAME frameProducao:FRAME = FRAME f-cad:HANDLE
       FRAME frameWMS:FRAME = FRAME f-cad:HANDLE.

/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME frameAcoes:MOVE-BEFORE-TAB-ITEM (br-monitor-solar:HANDLE IN FRAME f-cad)
       XXTABVALXX = FRAME frameDestino:MOVE-BEFORE-TAB-ITEM (FRAME frameAcoes:HANDLE)
       XXTABVALXX = FRAME frameImprimir:MOVE-BEFORE-TAB-ITEM (FRAME frameDestino:HANDLE)
       XXTABVALXX = FRAME frameWMS:MOVE-BEFORE-TAB-ITEM (FRAME frameImprimir:HANDLE)
       XXTABVALXX = FRAME frameProducao:MOVE-BEFORE-TAB-ITEM (FRAME frameWMS:HANDLE)
/* END-ASSIGN-TABS */.

/* BROWSE-TAB br-monitor-solar frameAcoes f-cad */
/* BROWSE-TAB br-reservas br-monitor-solar f-cad */
/* SETTINGS FOR FRAME frameAcoes
   Custom                                                               */
/* SETTINGS FOR FRAME frameDestino
   Custom                                                               */
/* SETTINGS FOR FRAME frameImprimir
   Custom                                                               */
/* SETTINGS FOR FRAME frameProducao
   Custom                                                               */
/* SETTINGS FOR FRAME frameWMS
   Custom                                                               */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-monitor-solar
/* Query rebuild information for BROWSE br-monitor-solar
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-monitor-solar.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-monitor-solar */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-reservas
/* Query rebuild information for BROWSE br-reservas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR  EACH tt-aloc-reservas
                            WHERE tt-aloc-reservas.nr-ord-prod = tt-monitor-solar.nr-ord-prod.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-reservas */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* Template Livre <Insira complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* Template Livre <Insira complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-monitor-solar
&Scoped-define SELF-NAME br-monitor-solar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-monitor-solar w-livre
ON MOUSE-SELECT-DBLCLICK OF br-monitor-solar IN FRAME f-cad /* Monitor Solar */
DO:
    /*
    IF AVAIL tt-monitor-solar
    THEN DO:
        ASSIGN  tt-monitor-solar.logSelecionado = NOT tt-monitor-solar.logSelecionado
                tt-monitor-solar.logSelecionado:SCREEN-VALUE IN BROWSE br-monitor-solar = STRING(tt-monitor-solar.logSelecionado).
    END.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-monitor-solar w-livre
ON ROW-DISPLAY OF br-monitor-solar IN FRAME f-cad /* Monitor Solar */
DO:
    /*
    IF tt-monitor-solar.ind-situacao-solar = 4
    THEN DO:
        ASSIGN  tt-monitor-solar.logSelecionado     :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-monitor-solar.nr-ord-prod        :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-monitor-solar.nr-pedido          :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-monitor-solar.dt-implant         :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-monitor-solar.it-codigo          :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-monitor-solar.nr-nota-fis        :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-monitor-solar.des-sit-solar      :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-monitor-solar.des-sit-wms        :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-monitor-solar.des-sit-alocacao   :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-monitor-solar.des-sit-op         :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-monitor-solar.estado             :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2.
    END.
    */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-monitor-solar w-livre
ON VALUE-CHANGED OF br-monitor-solar IN FRAME f-cad /* Monitor Solar */
DO:
    IF AVAIL tt-monitor-solar
    THEN DO:
        {&OPEN-QUERY-br-reservas}

    /********************
       RUN pi-carrega-itens.
    
       FIND FIRST int-ped-venda NO-LOCK
            WHERE int-ped-venda.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.

       RUN esp/es0018p.p (INPUT "esftp222":U,
                          INPUT 1,
                          INPUT 0,
                          INPUT "":U,
                          OUTPUT TABLE tt-prog-ponto).
    
       IF int-ped-venda.ind-status-solar = 2 THEN
           ASSIGN bt-liberar-pagto:SENSITIVE IN FRAME f-cad = NO.
       ELSE DO:
           /*S¢ habilita para usu†rios com permiss∆o*/
           IF CAN-FIND (FIRST tt-prog-ponto
                        WHERE tt-prog-ponto.conteudo = c-seg-usuario) THEN DO:
           
               RUN esp/es0018p.p (INPUT "Solar":U,
                                  INPUT 5,
                                  INPUT 0,
                                  INPUT "":U,
                                  OUTPUT TABLE tt-prog-ponto).

               /*S¢ habilita para condiá‰es de pagamento cadastradas*/
               IF CAN-FIND (FIRST tt-prog-ponto
                            WHERE tt-prog-ponto.conteudo = string(tt-ped-venda.cod-cond-pag)) THEN
                   ASSIGN bt-liberar-pagto:SENSITIVE IN FRAME f-cad = YES.
           END.
       END.

       IF int-ped-venda.ind-status-solar = 4 THEN
           ASSIGN bt-faturar:SENSITIVE IN FRAME f-cad = YES.
       ELSE
           ASSIGN bt-faturar:SENSITIVE IN FRAME f-cad = NO.


       IF int-ped-venda.ind-status-solar = 3 THEN
          ASSIGN bt-liberar-pagto:SENSITIVE IN FRAME f-cad = NO.
       ELSE
          ASSIGN bt-liberar-pagto:SENSITIVE IN FRAME f-cad = YES.


       IF tt-ped-venda.des-sit-solar = "Aguardando Separaá∆o" OR 
          tt-ped-venda.des-sit-solar = "Aguardando Lib. Financeira" THEN
          ASSIGN bt-libera-WMS:SENSITIVE IN FRAME f-cad = YES.
       ELSE
          ASSIGN bt-libera-WMS:SENSITIVE IN FRAME f-cad = NO.

    ********************/

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frameProducao
&Scoped-define SELF-NAME bt-alocar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-alocar w-livre
ON CHOOSE OF bt-alocar IN FRAME frameProducao /* Alocar */
DO:
    IF AVAIL tt-monitor-solar
    THEN DO:
        IF br-monitor-solar:NUM-SELECTED-ROWS IN FRAME f-cad > 0
        THEN DO:
            RUN utp/ut-msgs.p ( INPUT "show",
                                INPUT 27100,
                                INPUT "Alocar Ordens Selecionadas?~~Ao confirmar todas as ordens selecionadas no grid ser∆o alocadas por completo." + chr(13) + chr(10) + "Confirma?").
            IF RETURN-VALUE = "yes"
            THEN DO:
                RUN piAlocarOrdens.
            END.
        END.
        ELSE DO:
            RUN utp/ut-msgs.p ( INPUT "show",
                                INPUT 17006,
                                INPUT "Nenhuma ordem selecionada. Verifique!~~Para alocar Ç necess†rio selecionar uma ordem no grid.").
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frameAcoes
&Scoped-define SELF-NAME bt-exit-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exit-2 w-livre
ON CHOOSE OF bt-exit-2 IN FRAME frameAcoes
DO:
  APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frameWMS
&Scoped-define SELF-NAME bt-libera-WMS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-libera-WMS w-livre
ON CHOOSE OF bt-libera-WMS IN FRAME frameWMS /* Liberar Saldo */
DO: 
    IF AVAIL tt-monitor-solar
    THEN DO:
        IF br-monitor-solar:NUM-SELECTED-ROWS IN FRAME f-cad > 0
        THEN DO:
            RUN utp/ut-msgs.p ( INPUT "show",
                                INPUT 27100,
                                INPUT "Liberar Saldo WMS das Ordens Selecionadas?~~Ao confirmar o saldo das ordens selecionadas ser∆o liberadas no WMS." + chr(13) + chr(10) + "Confirma?").
            IF RETURN-VALUE = "yes"
            THEN DO:
                RUN piLiberaSaldoWMS.
            END.
        END.
        ELSE DO:
            RUN utp/ut-msgs.p ( INPUT "show",
                                INPUT 17006,
                                INPUT "Nenhuma ordem selecionada. Verifique!~~Para Liberar o Saldo no WMS Ç necess†rio selecionar uma ordem no grid.").
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frameProducao
&Scoped-define SELF-NAME bt-ord-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ord-prod w-livre
ON CHOOSE OF bt-ord-prod IN FRAME frameProducao /* Sumarizar */
DO:
    IF AVAIL tt-monitor-solar
    THEN DO:
        RUN cpp/cp0304.w.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-rep-ord
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-rep-ord w-livre
ON CHOOSE OF bt-rep-ord IN FRAME frameProducao /* Reportar Ordem Luiz1 */
DO:
    IF AVAIL tt-monitor-solar
    THEN DO:
        IF br-monitor-solar:NUM-SELECTED-ROWS IN FRAME f-cad > 0
        THEN DO:
            RUN utp/ut-msgs.p ( INPUT "show",
                                INPUT 27100,
                                INPUT "Reportar Ordens Selecionadas?~~Ao confirmar todas as ordens selecionadas no grid e diferente de zero ser∆o reportadas por completo." + chr(13) + chr(10) + "Confirma?").
            IF RETURN-VALUE = "yes"
            THEN DO:
                RUN piSolicitaDeposito.

                IF cod-depos-entrada <> ""
                THEN DO:
                   IF CAN-FIND(FIRST aloca-reserva NO-LOCK
                                WHERE aloca-reserva.nr-ord-prod = tt-monitor-solar.nr-ord-prod
                                  AND aloca-reserva.cod-depos   <> "PRO") THEN DO:
                        RUN utp/ut-msgs.p (INPUT "show",
                                           INPUT 17006,
                                           INPUT "Ordem nao estˇ alocada para o PRO.~~Ordem nao estˇ alocada para o PRO. Favor revisar as alocacoes.").
                        RETURN NO-APPLY.
                    END.
                    RUN piReportarOrdens.
                END.
            END.
        END.
        ELSE DO:
            RUN utp/ut-msgs.p ( INPUT "show",
                                INPUT 17006,
                                INPUT "Nenhuma ordem selecionada. Verifique!~~Para reportar Ç necess†rio selecionar uma ordem no grid.").
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frameAcoes
&Scoped-define SELF-NAME btAtualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualiza w-livre
ON CHOOSE OF btAtualiza IN FRAME frameAcoes /* Query Joins */
DO:
    RUN piCarregaDados.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcel w-livre
ON CHOOSE OF btExcel IN FRAME frameAcoes /* Gerar Excel */
DO:
    RUN pi-excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frameDestino
&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile w-livre
ON CHOOSE OF btFile IN FRAME frameDestino
DO:
/*     {report/rparq.i} */
    def var c-arq-conv  as char no-undo.
    DEF VAR l-ok        AS LOG NO-UNDO.

    assign c-arq-conv = replace(input frame frameDestino cFile, "/", CHR(92))
           c-arq-conv = SUBSTRING(c-arq-conv,1,1) + REPLACE(SUBSTRING(c-arq-conv,2),"~\~\","~\").
          
     SYSTEM-DIALOG GET-FILE c-arq-conv
        FILTERS "*.lst" "*.lst",
                "*.*" "*.*"
        ASK-OVERWRITE
        DEFAULT-EXTENSION "lst"
        INITIAL-DIR "spool"
        SAVE-AS
        USE-FILENAME
        UPDATE l-ok.
                     
    if  l-ok = yes then do:
        assign cFile = replace(c-arq-conv, CHR(92), "/").
        display cFile with frame fPage0.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frameAcoes
&Scoped-define SELF-NAME btPrint
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrint w-livre
ON CHOOSE OF btPrint IN FRAME frameAcoes /* Gerar Excel */
DO:
    IF AVAIL tt-monitor-solar
    THEN DO:
        IF br-monitor-solar:NUM-SELECTED-ROWS IN FRAME f-cad > 0
        THEN DO:
            RUN utp/ut-msgs.p ( INPUT "show",
                                INPUT 27100,
                                INPUT "Confirma Impress∆o ?~~Ao confirmar ser† realizado a impress∆o dos documentos: Nota Fiscal, Romaneiro, Manual, Esrtutura Item, Folha de Rosto." + chr(13) + chr(10) + "Confirma?").
            IF RETURN-VALUE = "yes"
            THEN DO:
                RUN piImprimir.
            END.
        END.
        ELSE DO:
            RUN utp/ut-msgs.p ( INPUT "show",
                                INPUT 17006,
                                INPUT "Nenhuma ordem selecionada. Verifique!~~Para imprimir Ç necess†rio selecionar uma ordem no grid.").
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSelecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelecao w-livre
ON CHOOSE OF btSelecao IN FRAME frameAcoes /* Seleá∆o */
DO:

    ASSIGN tt-filtro.tg-openquery = NO.
    RUN esp/ftp/esftp222a.w (INPUT-OUTPUT TABLE tt-filtro).
    
    FIND FIRST tt-filtro NO-LOCK no-error.
    IF tt-filtro.tg-openquery
    THEN DO:
        RUN piCarregaDados.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-programa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-programa w-livre
ON MENU-DROP OF MENU mi-programa /* _ */
DO:
  run pi-disable-menu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frameDestino
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny w-livre
ON ANY-KEY OF rsDestiny IN FRAME frameDestino
DO:
    BELL.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny w-livre
ON MOUSE-SELECT-CLICK OF rsDestiny IN FRAME frameDestino
DO:
    DO WITH FRAME frameDestino:
       case self:screen-value:
            when "1":U then do:
                assign cFile:sensitive         = NO 
                       cFile:visible           = NO
                       btFile:visible          = NO
                       cbImpr:visible          = YES.
            end.
            when "2":U then do:
                assign cFile:sensitive       = yes
                       cFile:visible         = yes
                       btFile:visible        = YES
                       cbImpr:visible        = NO.
            end.
            when "3":U then do:
                assign cFile:visible         = no
                       cFile:sensitive       = no
                       btFile:visible        = NO
                       cbImpr:visible        = NO.
            END.
        end case.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny w-livre
ON VALUE-CHANGED OF rsDestiny IN FRAME frameDestino
DO:
    DO WITH FRAME frameDestino:
       case self:screen-value:
            when "1":U then do:
                assign cFile:sensitive         = NO 
                       cFile:visible           = NO
                       btFile:visible          = NO
                       cbImpr:visible          = YES.
            end.
            when "2":U then do:
                assign cFile:sensitive       = yes
                       cFile:visible         = yes
                       btFile:visible        = YES
                       cbImpr:visible        = NO.
            end.
            when "3":U then do:
                assign cFile:visible         = no
                       cFile:sensitive       = no
                       btFile:visible        = NO
                       cbImpr:visible        = NO.
            END.
        end case.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frameImprimir
&Scoped-define SELF-NAME tg-imp-Manual
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-imp-Manual w-livre
ON VALUE-CHANGED OF tg-imp-Manual IN FRAME frameImprimir /* Manual */
DO:
    ASSIGN tg-imp-notafiscal:CHECKED = tg-imp-Manual:CHECKED.
    APPLY "value-changed" TO tg-imp-notafiscal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-imp-notafiscal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-imp-notafiscal w-livre
ON VALUE-CHANGED OF tg-imp-notafiscal IN FRAME frameImprimir /* Nota Fiscal */
DO:
    ASSIGN  tg-imp-romaneio     :CHECKED = tg-imp-notafiscal:CHECKED
            tg-imp-Manual       :CHECKED = tg-imp-notafiscal:CHECKED
            //tg-imp-romaneio     :SENSITIVE = NOT tg-imp-notafiscal:CHECKED
            //tg-imp-Manual       :SENSITIVE = NOT tg-imp-notafiscal:CHECKED
        .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-imp-romaneio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-imp-romaneio w-livre
ON VALUE-CHANGED OF tg-imp-romaneio IN FRAME frameImprimir /* Romaneio */
DO:
    ASSIGN tg-imp-notafiscal:CHECKED = tg-imp-romaneio:CHECKED.
    APPLY "value-changed" TO tg-imp-notafiscal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-reimprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-reimprimir w-livre
ON VALUE-CHANGED OF tg-reimprimir IN FRAME frameImprimir /* ReImprimir */
DO:
    ASSIGN  tg-imp-notafiscal   :CHECKED = YES
            tg-imp-romaneio     :CHECKED = YES
            tg-imp-Manual       :CHECKED = YES
            tg-imp-Estrutura    :CHECKED = YES
            tg-imp-folhaRosto   :CHECKED = YES
            tg-imp-notafiscal   :SENSITIVE = NOT tg-reimprimir:CHECKED
            tg-imp-romaneio     :SENSITIVE = NOT tg-reimprimir:CHECKED
            tg-imp-Manual       :SENSITIVE = NOT tg-reimprimir:CHECKED
            //tg-imp-Estrutura    :SENSITIVE = NOT tg-reimprimir:CHECKED
            //tg-imp-folhaRosto   :SENSITIVE = NOT tg-reimprimir:CHECKED
        .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-cad
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-livre 


/* ***************************  Main Block  *************************** */

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
  ENABLE br-monitor-solar br-reservas 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  ENABLE bt-ord-prod bt-alocar bt-rep-ord 
      WITH FRAME frameProducao IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-frameProducao}
  ENABLE bt-libera-WMS 
      WITH FRAME frameWMS IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-frameWMS}
  DISPLAY tg-imp-notafiscal tg-imp-romaneio tg-imp-Manual tg-imp-Estrutura 
          tg-imp-folhaRosto tg-reimprimir 
      WITH FRAME frameImprimir IN WINDOW w-livre.
  ENABLE tg-imp-notafiscal tg-imp-romaneio tg-imp-Manual tg-imp-Estrutura 
         tg-imp-folhaRosto tg-reimprimir 
      WITH FRAME frameImprimir IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-frameImprimir}
  DISPLAY cFile rsDestiny cbImpr 
      WITH FRAME frameDestino IN WINDOW w-livre.
  ENABLE cFile rsDestiny cbImpr btFile 
      WITH FRAME frameDestino IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-frameDestino}
  ENABLE btPrint btExcel btSelecao btAtualiza bt-exit-2 
      WITH FRAME frameAcoes IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-frameAcoes}
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
  {include/i-logfin.i}

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
  run pi-before-initialize.

  {include/win-size.i}

  {utp/ut9000.i "esftp222" "3.00.00.001"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  RUN esp/es0018p.p ( INPUT "esftp222":U,
                      INPUT 2,
                      INPUT 0,
                      INPUT "":U,
                      OUTPUT TABLE tt-prog-ponto).
  FOR FIRST tt-prog-ponto:
      //IF ENTRY(1,tt-prog-ponto.conteudo,';') = ped-venda.cod-estabel THEN
      ASSIGN c-deposito = ENTRY(2,tt-prog-ponto.conteudo,';').
  END.

    CREATE  tt-filtro.
    ASSIGN  tt-filtro.cod-estabel-ini           = ENTRY(1,tt-prog-ponto.conteudo,';')
            tt-filtro.cod-estabel-fim           = ENTRY(1,tt-prog-ponto.conteudo,';')
            tt-filtro.dt-implant-ini            = TODAY - 180
            tt-filtro.dt-implant-fim            = TODAY
            tt-filtro.nr-ordem-ini              = 0
            tt-filtro.nr-ordem-fim              = 999999999
            tt-filtro.nr-pedido-ini             = 0
            tt-filtro.nr-pedido-fim             = 999999999
        
            //tt-filtro.dt-implant-ini            = 11/16/2021
            //tt-filtro.dt-implant-fim            = 11/17/2021
            //tt-filtro.nr-ordem-ini              = 1740458
            //tt-filtro.nr-ordem-fim              = 1740458
            //tt-filtro.nr-ordem-ini              = 1741852
            //tt-filtro.nr-ordem-fim              = 1741852
            //tt-filtro.nr-ordem-ini              = 1738809
            //tt-filtro.nr-ordem-fim              = 1738809
            //tt-filtro.nr-pedido-ini             = 2764786
            //tt-filtro.nr-pedido-fim             = 2764786
            //tg-reimprimir       :CHECKED IN FRAME frameImprimir = YES

            tt-filtro.cod-emitente-ini          = 0
            tt-filtro.cod-emitente-fim          = 999999999
            tt-filtro.cod-depos-alocacao        = "WFT"
            tt-filtro.tg-aberto                 = YES
            tt-filtro.tg-atendido-parc          = YES
            tt-filtro.tg-atendido-tot           = NO
            tt-filtro.tg-pendente               = NO
            tt-filtro.tg-suspenso               = YES
            tt-filtro.tg-cancelado              = NO
            tt-filtro.tg-aguardando-lib         = YES
            tt-filtro.tg-aguardando-ger-fci     = YES
            tt-filtro.tg-aguardando-sep         = YES
            tt-filtro.tg-lib-fat                = YES
            tt-filtro.tg-faturado               = YES
            tt-filtro.tg-aloc-pendente          = YES
            tt-filtro.tg-aloc-bloqueada         = YES
            tt-filtro.tg-aloc-parcial           = YES
            tt-filtro.tg-aloc-finalizada        = YES
            tt-filtro.tg-nf-calculada           = YES
            tt-filtro.tg-nf-confirmada          = YES
            tt-filtro.tg-nf-impressa            = YES
            tt-filtro.tg-openquery              = YES
        .

    ASSIGN  tg-imp-notafiscal   :CHECKED IN FRAME frameImprimir = YES
            tg-imp-romaneio     :CHECKED IN FRAME frameImprimir = YES
            tg-imp-Manual       :CHECKED IN FRAME frameImprimir = YES
            tg-imp-Estrutura    :CHECKED IN FRAME frameImprimir = YES
            tg-imp-folhaRosto   :CHECKED IN FRAME frameImprimir = YES
        .

    DEFINE VARIABLE cListPrinter AS CHARACTER   NO-UNDO.
    ASSIGN cListPrinter = SESSION:GET-PRINTERS().
    RUN utp/ut-lstit.p (INPUT-OUTPUT cListPrinter).

    ASSIGN cbImpr:LIST-ITEM-PAIRS   IN FRAME frameDestino = cListPrinter NO-ERROR. /* Localiza Impressoras do Windows */
    ASSIGN cbImpr:SCREEN-VALUE      IN FRAME frameDestino = SESSION:PRINTER-NAME NO-ERROR. /* Impressora default como padr∆o  */

    IF  cbImpr:SCREEN-VALUE IN FRAME frameDestino = ""
    OR  cbImpr:SCREEN-VALUE IN FRAME frameDestino = ? THEN
        ASSIGN cbImpr:SCREEN-VALUE IN FRAME frameDestino = ENTRY(1,cbImpr:LIST-ITEMS IN FRAME frameDestino) NO-ERROR.
  
    APPLY "value-changed" TO rsDestiny IN FRAME frameDestino.

    find usuar_mestre where usuar_mestre.cod_usuario = c-seg-usuario no-lock no-error.
    IF NOT CAN-FIND(FIRST funcao NO-LOCK
                    WHERE funcao.cd-funcao = "spp-danfe"
                    AND   funcao.ativo) THEN DO:
        if avail usuar_mestre then
            assign cFile:SCREEN-VALUE IN FRAME frameDestino = if length(usuar_mestre.nom_subdir_spool) <> 0
                then caps(replace(usuar_mestre.nom_dir_spool, "~\", "~/") + "~/" + replace(usuar_mestre.nom_subdir_spool, "~\", "~/") + "~/" + v-cod-prog-gerado + "~." + v-cod-extens-arq)
                else caps(replace(usuar_mestre.nom_dir_spool, "~\", "~/") + "~/" + v-cod-prog-gerado + "~." + v-cod-extens-arq).
        else
            assign cFile:SCREEN-VALUE IN FRAME frameDestino = caps("spool~/" + v-cod-prog-gerado + "~." + v-cod-extens-arq).
    END.
    ELSE DO:
        if avail usuar_mestre then
            assign cFile:SCREEN-VALUE IN FRAME frameDestino = if length(usuar_mestre.nom_subdir_spool) <> 0
                then caps(replace(usuar_mestre.nom_dir_spool, "~\", "~/") + "~/" + replace(usuar_mestre.nom_subdir_spool, "~\", "~/") + "~/" + v-cod-prog-gerado + string(RANDOM(1,9999999)) + "~." + v-cod-extens-arq)
                else caps(replace(usuar_mestre.nom_dir_spool, "~\", "~/") + "~/" + v-cod-prog-gerado + string(RANDOM(1,9999999)) + "~." + v-cod-extens-arq).
        else
            assign cFile:SCREEN-VALUE IN FRAME frameDestino = caps("spool~/" + v-cod-prog-gerado + string(RANDOM(1,9999999)) + "~." + v-cod-extens-arq).
    END.
    run pi-after-initialize.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-excel w-livre 
PROCEDURE pi-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-ordem   AS CHAR NO-UNDO.
    DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.
    
    DEFINE VAR c-itens AS CHAR NO-UNDO. /*itens sem saldo disponivel*/

    ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "esftp222" + STRING(TIME) + ".csv".
    OUTPUT TO VALUE(c-arquivo) NO-CONVERT.
    
    /*Exporta Pedidos*/
    PUT UNFORMATTED "Pedido;Implantaá∆o;Emitente;Nome;Item Pai;Ord Prod;Estado;Representante;Estabelecimento;Cond. Pagto.;Valor Total;Valor Comiss;Valor Serv;Situaªío;Sit Solar;Entrega;Nat Oper;Transp;Projeto;Itens sem saldo" SKIP.
    FOR EACH tt-monitor-solar:
        FIND FIRST ped-venda
            WHERE ROWID(ped-venda) = tt-monitor-solar.rw-ped-venda
            NO-LOCK NO-ERROR.
    
        ASSIGN c-itens = "".
        FOR EACH ped-item OF ped-venda NO-LOCK:
    
            IF  tt-monitor-solar.it-codigo = ped-item.it-codigo THEN NEXT.
    
            IF fnEstoque(ped-venda.cod-estabel, ped-item.it-codigo, "WFT", "", NO) < (ped-item.qt-pedida - ped-item.qt-atendida) THEN DO:
               IF c-itens = "" THEN
                   ASSIGN c-itens = ped-item.it-codigo + "-" + string(ped-item.qt-pedida).
               ELSE
                   ASSIGN c-itens = c-itens + "|" + ped-item.it-codigo + "-" + string(ped-item.qt-pedida).
            END.
        END.
    
        PUT UNFORMATTED string(ped-venda.nr-pedido   ) + ";" +
                        string(ped-venda.dt-implant  ) + ";" +
                        string(ped-venda.cod-emitente) + ";" +
                        string(ped-venda.nome-abrev  ) + ";" +
                        string(tt-monitor-solar.it-codigo) + ";" +
                        string(tt-monitor-solar.nr-ord-prod) + ";" +
                        string(ped-venda.estado      ) + ";" +
                        string(ped-venda.no-ab-reppri) + ";" +
                        string(ped-venda.cod-estabel ) + ";" +
                        string(ped-venda.cod-cond-pag) + ";" +
                        string(ped-venda.vl-tot-ped  ) + ";" +
                        string(tt-monitor-solar.vlr-comissao) + ";" +
                        string(tt-monitor-solar.vl-serv-inst) + ";" +
                        string({diinc/i03di149.i 04 ped-venda.cod-sit-ped}) + ";" +
                        string(tt-monitor-solar.des-sit-solar) + ";" +
                        string(ped-venda.dt-entrega  ) + ";" +
                        string(ped-venda.nat-operacao) + ";" +
                        string(ped-venda.nome-transp ) + ";" +
                        string(tt-monitor-solar.cod-projeto ) + ";" + 
                        c-itens SKIP.
    
    END.
    
    OUTPUT CLOSE.
    
    OS-COMMAND NO-WAIT VALUE(c-arquivo) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAlocarOrdens w-livre 
PROCEDURE piAlocarOrdens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE h-cpapi001          AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-erro              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-texto             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE logPrimeiro         AS LOGICAL     NO-UNDO.
DEFINE BUFFER bf-tt-monitor-solar   FOR tt-monitor-solar.
DEFINE BUFFER bf-ord-prod           FOR ord-prod.

    FIND FIRST tt-filtro NO-LOCK NO-ERROR.
    ASSIGN cArquivo = SESSION:TEMP-DIRECTORY + "esftp222ALO_" + STRING(TIME) + ".txt".

    OUTPUT STREAM stReporte TO VALUE(cArquivo) CONVERT TARGET "ISO8859-1"  .
    PUT STREAM stReporte UNFORMATTED
        FILL("=", 132)
        SKIP
        "Monitor Solar - Alocaá∆o Reservas"
        SKIP
        FILL("-", 132)
        SKIP
        SPACE(05)
        "Num OP"
        SPACE(06)
        "Item"
        SPACE(12)
        "Dep"
        SPACE(06)
        "Qt.Original"
        SPACE(08)
        "Qt.Atendida"
        SPACE(09)
        "Qt.Alocada"
        SPACE(08)
        "Qt.a Alocar"
        SPACE(02)
        "Observaá∆o"
        SKIP.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Alocando Reservas Ordem").

    DEFINE VARIABLE hDBOAlocaReserva AS HANDLE      NO-UNDO.

    RUN inbo/boin007a.p PERSISTENT SET hDBOAlocaReserva.
    RUN inicializaAPI in hDBOAlocaReserva.    

    ASSIGN  iCont   = 0
            iSelect = 0.
    ASSIGN iSelect = br-monitor-solar:num-selected-rows in frame {&FRAME-NAME}.
    DO iCont = 1 to iSelect:
        if br-monitor-solar:fetch-selected-row(iCont) in frame {&FRAME-NAME}
        THEN DO:
            ASSIGN tt-monitor-solar.logSelecionado = YES.
        END.
    END.
    FOR  EACH tt-monitor-solar
        WHERE tt-monitor-solar.logSelecionado = YES.

        ASSIGN  tt-monitor-solar.logSelecionado = NO
                c-erro  = ""
                c-texto = ""
                iCont   = 0.
        
        FIND bf-ord-prod WHERE ROWID(bf-ord-prod) = tt-monitor-solar.rw-ord-prod NO-LOCK NO-ERROR.
        IF NOT AVAIL bf-ord-prod THEN NEXT.

        //IF bf-ord-prod.estado >= 7 THEN NEXT.

        RUN pi-acompanhar IN h-acomp (INPUT "OP: " + STRING(tt-monitor-solar.nr-ord-prod)).

        FOR  EACH reservas NO-LOCK
            WHERE reservas.nr-ord-prod = tt-monitor-solar.nr-ord-prod:

            EMPTY TEMP-TABLE ttAlocaReserva.
            EMPTY TEMP-TABLE RowErrors.

            PUT STREAM stReporte UNFORMATTED
                reservas.nr-ord-prod    FORMAT ">>>,>>>,>>9"
                SPACE(03)
                reservas.it-codigo      FORMAT "X(16)"
                SPACE(03)
                cod-depos-entrada       FORMAT "X(03)"
                SPACE(03)
                reservas.quant-orig     FORMAT ">>>>>,>>9.9999"
                SPACE(05)
                reservas.quant-atend    FORMAT ">>>>>,>>9.9999"
                SPACE(05)
                reservas.quant-aloc     FORMAT ">>>>>,>>9.9999"
                SPACE(05)
                reservas.quant-orig - reservas.quant-atend - reservas.quant-aloc    FORMAT ">>>>>,>>9.9999"
                .

            IF (reservas.quant-orig - reservas.quant-atend - reservas.quant-aloc) <= 0
            THEN DO:
                PUT STREAM stReporte UNFORMATTED 
                    SPACE(02)
                    "Alocaá∆o j† realizada para a Reserva!"
                    SKIP.
            END.
            ELSE DO:
                FIND FIRST aloca-reserva
                     WHERE aloca-reserva.nr-ord-produ = reservas.nr-ord-produ
                     NO-LOCK NO-ERROR.
    
                //IF (reservas.quant-orig - reservas.quant-atend - reservas.quant-aloc) <= 0 THEN NEXT blk_reservas.
    
                CREATE ttAlocaReserva.
                ASSIGN ttAlocaReserva.nr-ord-produ = reservas.nr-ord-produ
                       ttAlocaReserva.item-pai     = reservas.item-pai
                       ttAlocaReserva.cod-roteiro  = reservas.cod-roteiro
                       ttAlocaReserva.op-codigo    = reservas.op-codigo
                       ttAlocaReserva.it-codigo    = reservas.it-codigo
                       ttAlocaReserva.cod-estabel  = tt-monitor-solar.cod-estabel
                       ttAlocaReserva.cod-depos    = tt-filtro.cod-depos-alocacao
                       ttAlocaReserva.cod-localiz  = reservas.cod-localiz
                       ttAlocaReserva.lote-serie   = reservas.lote-serie
                       ttAlocaReserva.dt-vali-lote = ?
                       ttAlocaReserva.cod-refer    = reservas.cod-refer
                       ttAlocaReserva.quant-aloc   = reservas.quant-orig - reservas.quant-atend - reservas.quant-aloc
                       ttAlocaReserva.estado       = 1 //IF NOT AVAIL aloca-reserva THEN 1 ELSE 2
                       ttAlocaReserva.rowid        = ?.
    
                RUN emptyRowErrors IN hDBOAlocaReserva.
                RUN confirmaAlocacao in hDBOAlocaReserva (input table ttAlocaReserva).
                RUN getRowErrors IN hDBOAlocaReserva (OUTPUT TABLE RowErrors).
        
                IF NOT CAN-FIND(FIRST RowErrors)
                THEN DO:
                    ASSIGN  tt-monitor-solar.ind-situacao-alocacao      = 4
                            tt-monitor-solar.des-sit-alocacao           = ENTRY(tt-monitor-solar.ind-situacao-alocacao,cSituacaoAlocacao).

                    PUT STREAM stReporte UNFORMATTED 
                        SPACE(02)
                        "Alocaá∆o Realizada com Sucesso da Ordem :" + STRING(tt-monitor-solar.nr-ord-prod)
                        SKIP.
                END.
                ELSE DO:
                    ASSIGN logPrimeiro = YES.
                    FOR EACH RowErrors:
                        IF logPrimeiro
                        THEN DO:
                            PUT STREAM stReporte UNFORMATTED
                                SPACE(02)
                                "Erro:" RowErrors.ErrorNumber
                                " - "
                                RowErrors.ErrorDescription
                                SKIP.
                            ASSIGN logPrimeiro = NO.
                        END.
                        ELSE DO:
                            PUT STREAM stReporte UNFORMATTED
                                SPACE(75)
                                "Erro:" RowErrors.ErrorNumber
                                " - "
                                RowErrors.ErrorDescription
                                SKIP.
                        END.
                    END.
                END.
            END.
        END.
    END.

    PUT STREAM stReporte UNFORMATTED
        FILL("-", 132)
        SKIP.
    OUTPUT STREAM stReporte CLOSE.

    OS-COMMAND NO-WAIT VALUE(cArquivo) NO-ERROR.

    RUN pi-finalizar in h-acomp.

    if valid-handle (hDBOAlocaReserva) then do:
        run destroyAPI in hDBOAlocaReserva.
        run destroy in hDBOAlocaReserva.
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregaDados w-livre 
PROCEDURE piCarregaDados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
//DEFINE VARIABLE numOrdProd          AS INTEGER     NO-UNDO.
DEFINE VARIABLE ind-sit-alocacao    AS INTEGER     NO-UNDO.
DEFINE VARIABLE ind-sit-wms         AS INTEGER     NO-UNDO.
DEFINE VARIABLE cItemPai            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNumNotaFiscal      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-saldo-atual AS DECIMAL     NO-UNDO.

EMPTY TEMP-TABLE tt-monitor-solar.
EMPTY TEMP-TABLE tt-aloc-reservas.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

EMPTY TEMP-TABLE tt-aloc-reservas.

RUN pi-inicializar IN h-acomp (INPUT "Carregando Pedidos").
FIND FIRST tt-filtro NO-LOCK NO-ERROR.
blk_pedido:
FOR EACH int-ped-venda NO-LOCK
   WHERE int-ped-venda.cod-projeto  <> ""
     AND int-ped-venda.nr-pedido    >= tt-filtro.nr-pedido-ini
     AND int-ped-venda.nr-pedido    <= tt-filtro.nr-pedido-fim,
   FIRST ped-venda NO-LOCK
   WHERE ped-venda.nr-pedido     = int-ped-venda.nr-pedido
     AND ped-venda.cod-estabel  >= tt-filtro.cod-estabel-ini
     AND ped-venda.cod-estabel  <= tt-filtro.cod-estabel-fim
     AND ped-venda.cod-emitente >= tt-filtro.cod-emitente-ini
     AND ped-venda.cod-emitente <= tt-filtro.cod-emitente-fim
     AND ped-venda.dt-implant   >= tt-filtro.dt-implant-ini
     AND ped-venda.dt-implant   <= tt-filtro.dt-implant-fim:

    IF  NOT tt-filtro.tg-aberto 
    AND ped-venda.cod-sit-ped = 1 THEN
        NEXT blk_pedido.

    IF  NOT tt-filtro.tg-atendido-parc 
    AND ped-venda.cod-sit-ped = 2 THEN
        NEXT blk_pedido.

    IF  NOT tt-filtro.tg-atendido-tot 
    AND ped-venda.cod-sit-ped = 3 THEN
        NEXT blk_pedido.

    IF  NOT tt-filtro.tg-pendente 
    AND ped-venda.cod-sit-ped = 4 THEN
        NEXT blk_pedido.

    IF  NOT tt-filtro.tg-suspenso 
    AND ped-venda.cod-sit-ped = 5 THEN
        NEXT blk_pedido.

    IF  NOT tt-filtro.tg-cancelado 
    AND ped-venda.cod-sit-ped = 6 THEN
        NEXT blk_pedido.

    IF  NOT tt-filtro.tg-aguardando-lib 
    AND int-ped-venda.ind-status-solar = 1 THEN
        NEXT blk_pedido.

    IF  NOT tt-filtro.tg-aguardando-ger-fci 
    AND int-ped-venda.ind-status-solar = 2 THEN
        NEXT blk_pedido.

    IF  NOT tt-filtro.tg-aguardando-sep 
    AND int-ped-venda.ind-status-solar = 3 THEN
        NEXT blk_pedido.

    IF  NOT tt-filtro.tg-lib-fat 
    AND int-ped-venda.ind-status-solar = 4 THEN
        NEXT blk_pedido.

    IF  NOT tt-filtro.tg-faturado 
    AND int-ped-venda.ind-status-solar = 5 THEN
        NEXT blk_pedido.

    /******************************************************************************************/
    ASSIGN cItemPai = "".
    FOR FIRST int-item NO-LOCK
        WHERE int-item.nr-ped-energia = STRING(ped-venda.nr-pedido):
        ASSIGN  cItemPai = int-item.it-codigo.
    END.

    IF cItemPai = "" THEN NEXT.

    /******************************************************************************************/
    FOR FIRST nota-fiscal NO-LOCK 
        WHERE nota-fiscal.nome-ab-cli   = ped-venda.nome-abrev
          AND nota-fiscal.nr-pedcli     = ped-venda.nr-pedcli:

        IF  tt-filtro.tg-nf-calculada   = YES AND nota-fiscal.ind-sit-nota = 1
        OR  tt-filtro.tg-nf-confirmada  = YES AND nota-fiscal.ind-sit-nota = 3
        OR  tt-filtro.tg-nf-impressa    = YES AND nota-fiscal.ind-sit-nota = 2
        THEN.
        ELSE NEXT blk_pedido.
    END.

    /******************************************************************************************/
    FOR FIRST int-item NO-LOCK
        WHERE int-item.nr-ped-energia = STRING(ped-venda.nr-pedcli),
        FIRST ord-prod NO-LOCK 
        WHERE ord-prod.nr-pedido = STRING(ped-venda.nr-pedcli)
          AND ord-prod.it-codigo = int-item.it-codigo.
    END.
    IF NOT AVAIL ord-prod THEN NEXT blk_pedido.
    IF  ord-prod.nr-ord-prod < tt-filtro.nr-ordem-ini
    OR  ord-prod.nr-ord-prod > tt-filtro.nr-ordem-fim
    THEN DO:
        NEXT blk_pedido.
    END.

    IF  ord-prod.nr-ord-prod = 1750295
    OR  CAN-FIND(FIRST tt-monitor-solar WHERE tt-monitor-solar.nr-ord-prod = ord-prod.nr-ord-prod)
    THEN DO:
        NEXT blk_pedido.
    END.


    RUN pi-acompanhar IN h-acomp (INPUT "Pedido: " + ped-venda.nr-pedcli).

    /******************************************************************************************/
    
    ASSIGN ind-sit-wms = 0.
    FOR FIRST wm-docto NO-LOCK 
        WHERE wm-docto.cod-estabel = ped-venda.cod-estabel
          AND wm-docto.cod-local   = c-deposito                     /*deposito de alocaá∆o da ordem CP0319 */
          AND wm-docto.num-docto   = STRING(ord-prod.nr-ord-prod)   /*numero da Ordem de Produá∆o*/
          AND wm-docto.ind-origem-docto = 19:                       /*requisiá∆o material produá∆o */

        ASSIGN ind-sit-wms = wm-docto.ind-sit-docto.

    END.

    /******************************************************************************************/
    ASSIGN ind-sit-alocacao = 0.
    IF ord-prod.estado < 7
    THEN DO:
        blk_alocacao:
        DO:
            blk_alocacao1:
            FOR  EACH reservas NO-LOCK
                WHERE reservas.nr-ord-prod = ord-prod.nr-ord-prod:

                /*IF CAN-FIND(FIRST tt-aloc-reservas
                            WHERE tt-aloc-reservas.nr-ord-prod  = reservas.nr-ord-prod
                              AND tt-aloc-reservas.item-pai     = reservas.item-pai
                              AND tt-aloc-reservas.cod-roteiro  = reservas.cod-roteiro
                              AND tt-aloc-reservas.op-codigo    = reservas.op-codigo
                              AND tt-aloc-reservas.it-codigo    = reservas.it-codigo
                              AND tt-aloc-reservas.cod-refer    = reservas.cod-refer)
                THEN DO:
                    NEXT blk_alocacao1.
                END.
                */
                CREATE tt-aloc-reservas.
                BUFFER-COPY reservas TO tt-aloc-reservas.

                //IF reservas.quant-aloc > 0
                IF  reservas.quant-aloc > 0
                AND (reservas.quant-orig - reservas.quant-atend - reservas.quant-aloc) > 0
                THEN DO:
                    ASSIGN tt-aloc-reservas.ind-situacao-alocacao = 3.
                    ASSIGN tt-aloc-reservas.des-sit-alocacao = ENTRY(tt-aloc-reservas.ind-situacao-alocacao,cSituacaoAlocacao).
                    ASSIGN ind-sit-alocacao = 3. //Parcial
                    LEAVE blk_alocacao.
                END.
                IF  (reservas.quant-orig - reservas.quant-atend - reservas.quant-aloc) = 0
                THEN DO:
                    //IF ind-sit-alocacao <> THEN
                    //IF ind-sit-alocacao = 0 THEN DO:
                        ASSIGN tt-aloc-reservas.ind-situacao-alocacao = 4.
                        ASSIGN tt-aloc-reservas.des-sit-alocacao = ENTRY(tt-aloc-reservas.ind-situacao-alocacao,cSituacaoAlocacao).
                        ASSIGN ind-sit-alocacao = 4. //Finalizada
                        NEXT.
                    //END.
                END.
                IF NOT CAN-FIND(FIRST Saldo-Estoq NO-LOCK
                                WHERE Saldo-Estoq.cod-estabel = ord-prod.cod-estabel
                                  AND Saldo-Estoq.cod-depos   = tt-filtro.cod-depos-alocacao  
                                  AND Saldo-Estoq.cod-localiz = reservas.cod-localiz
                                  AND Saldo-Estoq.lote        = reservas.lote-serie 
                                  AND Saldo-Estoq.it-codigo   = reservas.it-codigo  
                                  AND Saldo-Estoq.cod-refer   = reservas.cod-refer)
                THEN DO:
                    ASSIGN tt-aloc-reservas.ind-situacao-alocacao = 2.
                    ASSIGN tt-aloc-reservas.des-sit-alocacao = ENTRY(tt-aloc-reservas.ind-situacao-alocacao,cSituacaoAlocacao).
                    ASSIGN ind-sit-alocacao = 2. //Bloqueada
                    LEAVE blk_alocacao.
                END.

                ASSIGN de-saldo-atual = 0.

                FOR  EACH Saldo-Estoq NO-LOCK
                    WHERE Saldo-Estoq.cod-estabel = ord-prod.cod-estabel
                      AND Saldo-Estoq.cod-depos   = tt-filtro.cod-depos-alocacao  
                      AND Saldo-Estoq.cod-localiz = reservas.cod-localiz
                      AND Saldo-Estoq.lote        = reservas.lote-serie 
                      AND Saldo-Estoq.it-codigo   = reservas.it-codigo  
                      AND Saldo-Estoq.cod-refer   = reservas.cod-refer:
    
                    ASSIGN de-saldo-atual = de-saldo-atual + fnEstoque(saldo-estoq.cod-estabel, saldo-estoq.it-codigo, saldo-estoq.cod-depos, saldo-estoq.cod-localiz, NO)
                        .
                END.
                IF  (reservas.quant-orig - reservas.quant-aloc) > de-saldo-atual
                THEN DO:
                    ASSIGN  tt-aloc-reservas.ind-situacao-alocacao  = 2
                            tt-aloc-reservas.des-sit-alocacao       = ENTRY(tt-aloc-reservas.ind-situacao-alocacao,cSituacaoAlocacao)
                            tt-aloc-reservas.saldoFnEstoque         = de-saldo-atual
                            ind-sit-alocacao = 2. //Bloqueada
                    LEAVE blk_alocacao.
                END.
                ELSE DO:
                    ASSIGN  tt-aloc-reservas.ind-situacao-alocacao  = 1
                            tt-aloc-reservas.des-sit-alocacao       = ENTRY(tt-aloc-reservas.ind-situacao-alocacao,cSituacaoAlocacao)
                            tt-aloc-reservas.saldoFnEstoque         = de-saldo-atual
                            ind-sit-alocacao = 1. //Pendente
                    LEAVE blk_alocacao.
                END.
            END.
            IF ind-sit-alocacao = 0 THEN DO:
                //MESSAGE "ENTROU AQUI:"  ord-prod.nr-ord-prod VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                ASSIGN tt-aloc-reservas.ind-situacao-alocacao = 1.
                ASSIGN tt-aloc-reservas.des-sit-alocacao = ENTRY(tt-aloc-reservas.ind-situacao-alocacao,cSituacaoAlocacao).
                ASSIGN ind-sit-alocacao = 1. //Pendente
            END.
        END.
    END.
    ELSE DO:
        FOR  EACH reservas NO-LOCK
            WHERE reservas.nr-ord-prod = ord-prod.nr-ord-prod:
            CREATE tt-aloc-reservas.
            BUFFER-COPY reservas TO tt-aloc-reservas.
    
            ASSIGN tt-aloc-reservas.ind-situacao-alocacao = 4.
            ASSIGN tt-aloc-reservas.des-sit-alocacao = ENTRY(tt-aloc-reservas.ind-situacao-alocacao,cSituacaoAlocacao).
            ASSIGN ind-sit-alocacao = 4. //Finalizada
        END.
    END.

    IF  NOT tt-filtro.tg-aloc-pendente  AND ind-sit-alocacao = 1 THEN
        NEXT blk_pedido.

    IF  NOT tt-filtro.tg-aloc-bloqueada AND ind-sit-alocacao = 2 THEN
        NEXT blk_pedido.
    
    IF  NOT tt-filtro.tg-aloc-parcial   AND ind-sit-alocacao = 3 THEN
        NEXT blk_pedido.
    
    IF  NOT tt-filtro.tg-aloc-finalizada AND ind-sit-alocacao = 4 THEN
        NEXT blk_pedido.

    /******************************************************************************************/

    CREATE  tt-monitor-solar.
    ASSIGN  tt-monitor-solar.logSelecionado             = NO
            tt-monitor-solar.nr-ord-prod                = ord-prod.nr-ord-prod
            tt-monitor-solar.nr-pedido                  = ped-venda.nr-pedido
            tt-monitor-solar.dt-implant                 = ped-venda.dt-implant
            tt-monitor-solar.nr-pedcli                  = ped-venda.nr-pedcli
            tt-monitor-solar.cod-estabel                = ped-venda.cod-estabel
            tt-monitor-solar.cod-depos-wms              = c-deposito
            tt-monitor-solar.it-codigo                  = cItemPai
            tt-monitor-solar.nr-nota-fis                = IF AVAIL nota-fiscal THEN nota-fiscal.nr-nota-fis ELSE ""
            tt-monitor-solar.serie                      = IF AVAIL nota-fiscal THEN nota-fiscal.serie ELSE ""
            tt-monitor-solar.des-sit-nota               = IF AVAIL nota-fiscal THEN {diinc/i04di087.i 04 nota-fiscal.ind-sit-nota} ELSE ""
            tt-monitor-solar.des-forma-emis-nf-eletro   = IF AVAIL nota-fiscal THEN {diinc/i01di135.i 04 nota-fiscal.idi-forma-emis-nf-eletro} ELSE ""
            tt-monitor-solar.des-sit-nf-eletro          = IF AVAIL nota-fiscal THEN {diinc/i02di135.i 04 nota-fiscal.idi-sit-nf-eletro} ELSE ""
            tt-monitor-solar.ind-situacao-solar         = int-ped-venda.ind-status-solar
            tt-monitor-solar.des-sit-solar              = IF int-ped-venda.ind-status-solar = 0 THEN "" ELSE ENTRY(int-ped-venda.ind-status-solar,cSituacaoSolar)
            tt-monitor-solar.ind-situacao-wms           = ind-sit-wms
            tt-monitor-solar.des-sit-wms                = IF ind-sit-wms = 0 THEN "DocWMS-N∆oEncontrado" ELSE IF ind-sit-wms = 1 THEN "Pendente" ELSE "Separado"
            tt-monitor-solar.ind-situacao-alocacao      = ind-sit-alocacao
            tt-monitor-solar.des-sit-alocacao           = ENTRY(ind-sit-alocacao,cSituacaoAlocacao)
            tt-monitor-solar.ind-situacao-op            = ord-prod.estado
            tt-monitor-solar.des-sit-op                 = {ininc/i01in271.i 04 ord-prod.estado}
            tt-monitor-solar.estado                     = ped-venda.estado
            tt-monitor-solar.vlr-comissao               = int-ped-venda.vlr-comissao
            tt-monitor-solar.vl-serv-inst               = int-ped-venda.vl-serv-inst
            tt-monitor-solar.cod-projeto                = int-ped-venda.cod-projeto
            tt-monitor-solar.rw-ped-venda               = ROWID(ped-venda)
            tt-monitor-solar.rw-ord-prod                = ROWID(ord-prod)
            tt-monitor-solar.rw-nota-fiscal             = ROWID(nota-fiscal)
            tt-monitor-solar.rw-wm-docto                = ROWID(wm-docto)
            tt-monitor-solar.num-serie-solar            = int-ped-venda.num-serie-solar
        .

END.

{&open-query-br-monitor-solar}
APPLY "value-changed" TO br-monitor-solar IN FRAME f-cad.

RUN pi-finalizar in h-acomp.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimir w-livre 
PROCEDURE piImprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-digita.
    ASSIGN  iCont   = 0
            iSelect = 0.
    ASSIGN iSelect = br-monitor-solar:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}.

    DO iCont = 1 TO iSelect:
        IF  br-monitor-solar:FETCH-SELECTED-ROW(iCont) IN FRAME {&FRAME-NAME}
        THEN DO:
            IF tt-monitor-solar.nr-nota-fis = "" THEN NEXT.
            FIND FIRST nota-fiscal
                 WHERE nota-fiscal.cod-estabel = tt-monitor-solar.cod-estabel
                   AND nota-fiscal.serie       = tt-monitor-solar.serie
                   AND nota-fiscal.nr-nota-fis = tt-monitor-solar.nr-nota-fis
                NO-LOCK NO-ERROR.
    
            IF NOT AVAIL nota-fiscal THEN NEXT.

            CREATE  tt-digita.            
            ASSIGN  tt-digita.cod-estabel       = nota-fiscal.cod-estabel
                    tt-digita.serie             = nota-fiscal.serie      
                    tt-digita.nr-nota-fis       = nota-fiscal.nr-nota-fis
                    tt-digita.cdd-embarq        = nota-fiscal.cdd-embarq
                    tt-digita.it-codigo         = tt-monitor-solar.it-codigo
                    tt-digita.nr-ord-prod       = tt-monitor-solar.nr-ord-prod
                    tt-digita.nr-pedido         = tt-monitor-solar.nr-pedido
                    tt-digita.nr-pedcli         = nota-fiscal.nr-pedcli  
                    tt-digita.nome-transp       = nota-fiscal.nome-transp
                    tt-digita.rw-nota-fiscal    = tt-monitor-solar.rw-nota-fiscal.
        END.
    END.

    /*Cria tt-param*/
    EMPTY TEMP-TABLE tt-param-aux.
    CREATE tt-param-aux.
    ASSIGN tt-param-aux.usuario              = c-seg-usuario
           tt-param-aux.destino              = input frame frameDestino rsDestiny
           tt-param-aux.data-exec            = TODAY
           tt-param-aux.hora-exec            = TIME
           tt-param-aux.v_num_tip_aces_usuar = v_num_tip_aces_usuar
           tt-param-aux.ep-codigo            = i-ep-codigo-usuario
           tt-param-aux.da-dt-saida          = TODAY
           tt-param-aux.c-hr-saida           = STRING(TIME,"HH:MM:SS")
           tt-param-aux.nr-copias            = 1
           tt-param-aux.imprime-bloq         = NO
           tt-param-aux.rs-imprime           = IF tg-reimprimir:CHECKED IN FRAME frameImprimir THEN 2 ELSE 1
           tt-param-aux.rs-imprime           = IF tg-reimprimir:CHECKED IN FRAME frameImprimir THEN 2 ELSE 1

           tt-param-aux.log-imp-notafiscal   = tg-imp-notafiscal :CHECKED IN FRAME frameImprimir
           tt-param-aux.log-imp-romaneio     = tg-imp-romaneio   :CHECKED IN FRAME frameImprimir
           tt-param-aux.log-imp-Manual       = tg-imp-Manual     :CHECKED IN FRAME frameImprimir
           tt-param-aux.log-imp-Estrutura    = tg-imp-Estrutura  :CHECKED IN FRAME frameImprimir
           tt-param-aux.log-imp-folhaRosto   = tg-imp-folhaRosto :CHECKED IN FRAME frameImprimir

           tt-param-aux.impressora-so        = cbImpr:SCREEN-VALUE IN FRAME frameDestino
           tt-param-aux.impressora-so-bloq   = ""
           tt-param-aux.l-gera-danfe-xml     = NO
           tt-param-aux.c-dir-hist-xml       = ""
           tt-param-aux.ind-execucao         = 1.

    IF tt-param-aux.cod-layout = "" THEN
       ASSIGN tt-param-aux.cod-layout = "DANFE-Mod.1":U.

    if  tt-param-aux.destino = 2 then
        assign tt-param-aux.arquivo = input frame frameDestino cFile.
    ELSE
        IF NOT CAN-FIND(FIRST funcao NO-LOCK
                        WHERE funcao.cd-funcao = "spp-danfe":U
                        AND   funcao.ativo)
       THEN
           assign tt-param-aux.arquivo = session:temp-directory + "esftp222":U + REPLACE(STRING(TODAY,"99/99/99"),"/","") + REPLACE(STRING(TIME,"HH:MM:SS"),":","") + ".pdf".
       ELSE
           assign tt-param-aux.arquivo = session:temp-directory + "esftp222":U + REPLACE(STRING(TODAY,"99/99/99"),"/","") + REPLACE(STRING(TIME,"HH:MM:SS"),":","") + string(RANDOM(1,9999999)) + ".pdf".

    ASSIGN raw-param = ?.
    RAW-TRANSFER tt-param-aux to raw-param.

    EMPTY TEMP-TABLE tt-raw-digita.
    FOR EACH tt-digita:
        CREATE tt-raw-digita.
        RAW-TRANSFER tt-digita to tt-raw-digita.raw-digita.
    END. 

    run esp/ftp/esftp222b.p (input raw-param, input table tt-raw-digita).
    
    {&open-query-br-monitor-solar}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimirEstrutura w-livre 
PROCEDURE piImprimirEstrutura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-bcapi016    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-arq-pdf     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-bar-code    AS CHARACTER   NO-UNDO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimirFolhaRosto w-livre 
PROCEDURE piImprimirFolhaRosto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-bcapi016    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-arq-pdf     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-bar-code    AS CHARACTER   NO-UNDO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLiberaSaldoWMS w-livre 
PROCEDURE piLiberaSaldoWMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-depos-origem      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-depos-destino     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-retorno-estoque  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-retorno           AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-usuar-liber       AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE logAlocacao       AS LOGICAL   NO-UNDO.
    
    ASSIGN cArquivo = SESSION:TEMP-DIRECTORY + "esftp222LS-WMS_" + STRING(TIME) + ".txt".
    OUTPUT STREAM stReporte TO VALUE(cArquivo) CONVERT TARGET "ISO8859-1"  .
    PUT STREAM stReporte UNFORMATTED
        FILL("=", 132)
        SKIP
        "Monitor Solar - Libera Saldo WMS"
        SKIP
        FILL("-", 132)
        SKIP
        SPACE(05)
        "Num OP"
        SPACE(03)
        "Item"
        SPACE(11)
        "idDocto"
        SPACE(02)
        "Observaá∆o"
        SKIP.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar IN h-acomp (INPUT "Liberando Saldo WMS").

    RUN esp/es0018p.p (INPUT "esftp222":U,
                       INPUT 2,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    ASSIGN  iCont   = 0
            iSelect = 0.
    ASSIGN iSelect = br-monitor-solar:num-selected-rows in frame {&FRAME-NAME}.

    DO iCont = 1 to iSelect:
        if br-monitor-solar:fetch-selected-row(iCont) in frame {&FRAME-NAME}
        THEN DO:
            ASSIGN tt-monitor-solar.logSelecionado = YES.
        END.
    END.

    blk_libSaldo:
    FOR  EACH tt-monitor-solar
        WHERE tt-monitor-solar.logSelecionado = YES.
        
        EMPTY TEMP-TABLE tt-transfere-aloc.

        ASSIGN  tt-monitor-solar.logSelecionado = NO.

        PUT STREAM stReporte UNFORMATTED
            tt-monitor-solar.nr-ord-prod        FORMAT ">>>,>>>,>>9"
            SPACE(03)
            tt-monitor-solar.it-codigo          FORMAT "X(16)"
            .
        
        /* Valida alocaá∆o antes da liberaá∆o */
        ASSIGN logAlocacao = NO.
        
        aloca-blk:
        FOR  EACH reservas NO-LOCK
                WHERE reservas.nr-ord-prod = tt-monitor-solar.nr-ord-prod.
        
            IF CAN-FIND(FIRST aloca-reserva NO-LOCK
                    WHERE aloca-reserva.nr-ord-prod = reservas.nr-ord-prod
                    AND aloca-reserva.it-codigo = reservas.it-codigo
                    AND aloca-reserva.quant-aloc = reservas.quant-orig
                    AND aloca-reserva.cod-depos   = "WFT")
                AND (reservas.quant-orig - reservas.quant-atend - reservas.quant-aloc) = 0
            THEN DO:
                ASSIGN logAlocacao = YES.
            END.
            ELSE DO:
                    ASSIGN logAlocacao = NO.
                LEAVE aloca-blk.
            END.
        END.
        
        IF  tt-monitor-solar.ind-situacao-alocacao <> 4 OR logAlocacao = NO
        THEN DO:
            PUT STREAM stReporte UNFORMATTED
                SPACE(05)
                SUBSTITUTE("ERRO: Liberaá∆o de Saldo para OP: &1 n∆o permitida, pois n∆o est∆ totalmente alocada.", tt-monitor-solar.nr-ord-prod)
                SKIP.
            NEXT blk_libSaldo.
        END.

        IF tt-monitor-solar.ind-situacao-solar = 4
        THEN DO:
            PUT STREAM stReporte UNFORMATTED
                SPACE(05)
                SUBSTITUTE("ERRO: Liberaá∆o de Saldo para WMS j† foi processada.", "")
                SKIP.
            NEXT blk_libSaldo.
        END.

        IF  NOT CAN-FIND(FIRST wm-docto NO-LOCK 
                         WHERE wm-docto.cod-estabel         = tt-monitor-solar.cod-estabel           /*estabelecimento do pedido de venda*/
                           AND wm-docto.cod-local           = tt-monitor-solar.cod-depos-wms         /*deposito de alocaá∆o da ordem CP0319 */
                           AND wm-docto.num-docto           = STRING(tt-monitor-solar.nr-ord-prod)   /*numero da Ordem de Produá∆o*/
                           AND wm-docto.ind-origem-docto    = 19)                                    /*requisiá∆o material produá∆o */
        THEN DO:
            PUT STREAM stReporte UNFORMATTED
                SPACE(05)
                SUBSTITUTE("ERRO: N∆o encontrado documento WMS com origem Requisiá∆o de Material Produá∆o para a OP: &1", tt-monitor-solar.nr-ord-prod)
                SKIP.
            NEXT blk_libSaldo.
        END.

        EMPTY TEMP-TABLE tt-itens-docto.
        EMPTY TEMP-TABLE tt-transfere-item.

        FOR  EACH wm-docto NO-LOCK 
            WHERE wm-docto.cod-estabel = tt-monitor-solar.cod-estabel           /*estabelecimento do pedido de venda*/
              AND wm-docto.cod-local   = tt-monitor-solar.cod-depos-wms         /*deposito de alocaá∆o da ordem CP0319 */
              AND wm-docto.num-docto   = STRING(tt-monitor-solar.nr-ord-prod)   /*numero da Ordem de Produá∆o*/
              AND wm-docto.ind-origem-docto = 19:                               /*requisiá∆o material produá∆o */

            PUT STREAM stReporte UNFORMATTED
                wm-docto.id-docto                   
                .

            FOR  EACH wm-docto-itens NO-LOCK
                WHERE wm-docto-itens.id-docto = wm-docto.id-docto,
                FIRST wm-local NO-LOCK
                WHERE wm-local.cod-estabel = wm-docto-itens.cod-estabel
                  AND wm-local.cod-local   = wm-docto-itens.cod-local: 

                IF wm-local.cod-deposito = 'PRO' THEN NEXT.

                RUN pi-acompanhar IN h-acomp (INPUT "Lendo Itens Docto WMS: " + wm-docto-itens.cod-item).

                CREATE tt-transfere-item.
                BUFFER-COPY wm-docto-itens TO tt-transfere-item.
                
                FIND FIRST saldo-estoq 
                     WHERE saldo-estoq.cod-depos   = wm-local.cod-deposito
                       AND saldo-estoq.it-codigo   = wm-docto-itens.cod-item
                       AND saldo-estoq.cod-estabel = wm-docto-itens.cod-estabel
                    EXCLUSIVE-LOCK NO-ERROR.

                IF AVAIL saldo-estoq
                THEN DO:
                    IF (saldo-estoq.qt-aloc-prod - wm-docto-itens.qtd-item) > 0
                    THEN DO:
                        ASSIGN saldo-estoq.qt-aloc-prod = saldo-estoq.qt-aloc-prod - wm-docto-itens.qtd-item.

                        CREATE  tt-transfere-aloc.
                        ASSIGN  tt-transfere-aloc.cod-depos   = saldo-estoq.cod-depos  
                                tt-transfere-aloc.it-codigo   = saldo-estoq.it-codigo  
                                tt-transfere-aloc.cod-estabel = saldo-estoq.cod-estabel.
                    END.
                END.
            END.                    

            FOR EACH tt-prog-ponto:
                IF ENTRY(1,tt-prog-ponto.conteudo,';') = tt-monitor-solar.cod-estabel THEN
                    ASSIGN  c-depos-origem   = entry(2,tt-prog-ponto.conteudo,';')
                            c-depos-destino = entry(3,tt-prog-ponto.conteudo,';').
            END.                    

            RUN pi-acompanhar IN h-acomp (INPUT "Fazendo Transferencia").

            RUN esp/ccp/esccp051.p (INPUT STRING(tt-monitor-solar.nr-ord-prod),
                                    INPUT c-depos-origem,   //'WFT',
                                    INPUT c-depos-destino,  //'PRO',
                                    INPUT TABLE tt-transfere-item,
                                    OUTPUT c-retorno-estoque  ).

            IF c-retorno-estoque = ''
            THEN DO:
                PUT STREAM stReporte UNFORMATTED
                    "Retorno:" c-retorno-estoque
                    SKIP.
                NEXT blk_libSaldo.
            END.
               /* Erro de Transferencia */
            IF INDEX(c-retorno-estoque,'ERRO') = 0
            THEN DO:

                IF NOT CAN-FIND(FIRST int-wm-docto
                                WHERE int-wm-docto.cod-estabel  = wm-docto.cod-estabel
                                  AND int-wm-docto.cod-local    = wm-docto.cod-local
                                  AND int-wm-docto.id-docto     = wm-docto.id-docto
                                  //AND int-wm-docto.log-atualizado = YES
                                )
                THEN DO:
                    CREATE int-wm-docto.
                    ASSIGN int-wm-docto.cod-estabel    = wm-docto.cod-estabel 
                           int-wm-docto.cod-local      = wm-docto.cod-local   
                           int-wm-docto.id-docto       = wm-docto.id-docto    
                           int-wm-docto.log-atualizado = YES.
                END.

                FOR  EACH aloca-reserva EXCLUSIVE-LOCK 
                    WHERE aloca-reserva.nr-ord-prod = tt-monitor-solar.nr-ord-prod:
                    ASSIGN aloca-reserva.cod-depos  = c-depos-destino.
                END.

                FIND FIRST int-ped-venda 
                     WHERE int-ped-venda.nr-pedido = tt-monitor-solar.nr-pedido
                     EXCLUSIVE-LOCK NO-ERROR.

                IF AVAIL int-ped-venda
                THEN DO:
                    ASSIGN  int-ped-venda.ind-status-solar      = 4
                            tt-monitor-solar.ind-situacao-solar = 4
                            tt-monitor-solar.des-sit-solar      = ENTRY(int-ped-venda.ind-status-solar,cSituacaoSolar).

                    FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
                END.              

                PUT STREAM stReporte UNFORMATTED
                    SPACE(02)
                    "Transferància realizada com Sucesso".
                
            END.
            ELSE DO:
                PUT STREAM stReporte UNFORMATTED
                    SPACE(02)
                    "ERRO:" c-retorno-estoque.

                FOR  EACH wm-docto-itens NO-LOCK
                    WHERE wm-docto-itens.id-docto = wm-docto.id-docto,
                    FIRST wm-local NO-LOCK
                    WHERE wm-local.cod-estabel = wm-docto-itens.cod-estabel
                      AND wm-local.cod-local   = wm-docto-itens.cod-local : 

                    FIND FIRST saldo-estoq 
                         WHERE saldo-estoq.cod-depos   = wm-local.cod-deposito
                           AND saldo-estoq.it-codigo   = wm-docto-itens.cod-item
                           AND saldo-estoq.cod-estabel = wm-docto-itens.cod-estabel
                        EXCLUSIVE-LOCK NO-ERROR.
                    
                    IF AVAIL saldo-estoq
                    THEN DO:
                        FIND FIRST tt-transfere-aloc
                             WHERE tt-transfere-aloc.cod-depos   = wm-local.cod-deposito
                               AND tt-transfere-aloc.it-codigo   = wm-docto-itens.cod-item
                               AND tt-transfere-aloc.cod-estabel = wm-docto-itens.cod-estabel
                            NO-ERROR.
            
                        IF AVAIL tt-transfere-aloc THEN
                            ASSIGN saldo-estoq.qt-aloc-prod = saldo-estoq.qt-aloc-prod + wm-docto-itens.qtd-item.
                    END.
                END.
            END.
        END.
        PUT STREAM stReporte UNFORMATTED
            SKIP.
    END.

    PUT STREAM stReporte UNFORMATTED
        FILL("-", 132)
        SKIP.
    OUTPUT STREAM stReporte CLOSE.

    OS-COMMAND NO-WAIT VALUE(cArquivo) NO-ERROR.

    {&open-query-br-monitor-solar}
    APPLY "value-changed" TO br-monitor-solar IN FRAME f-cad.
    RUN pi-finalizar in h-acomp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piReportarOrdens w-livre 
PROCEDURE piReportarOrdens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE h-cpapi001          AS HANDLE      NO-UNDO.
DEFINE VARIABLE iCont               AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-erro              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-texto             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE logPrimeiro         AS LOGICAL     NO-UNDO.
DEFINE VARIABLE logAlocacao         AS LOGICAL     NO-UNDO.
DEFINE BUFFER bf-tt-monitor-solar   FOR tt-monitor-solar.
DEFINE BUFFER bf-ord-prod           FOR ord-prod.

    ASSIGN cArquivo = SESSION:TEMP-DIRECTORY + "esftp222OP_" + STRING(TIME) + ".txt".

    OUTPUT STREAM stReporte TO VALUE(cArquivo) CONVERT TARGET "ISO8859-1"  .
    PUT STREAM stReporte UNFORMATTED
        FILL("=", 132)
        SKIP
        "Monitor Solar - Reporte Produá∆o"
        SKIP
        FILL("-", 132)
        SKIP
        SPACE(05)
        "Num OP"
        SPACE(03)
        "Item"
        SPACE(11)
        "Dep.Ent"
        SPACE(02)
        "Dep.Sai"
        SPACE(02)
        "Dt.Reporte"
        SPACE(06)
        "Qt.Reporte"
        SPACE(02)
        "Observaá∆o"
        SKIP.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar IN h-acomp (INPUT "Reportando Ordens").

    RUN cpp/cpapi001.p PERSISTENT SET h-cpapi001 (INPUT-OUTPUT TABLE tt-rep-prod,
                                                  INPUT        TABLE tt-refugo,
                                                  INPUT        TABLE tt-res-neg,
                                                  INPUT        TABLE tt-apont-mob,
                                                  INPUT-OUTPUT TABLE tt-erro,
                                                  INPUT        YES).

    FIND FIRST param-cp NO-LOCK NO-ERROR.

    ASSIGN  iCont   = 0
            iSelect = 0.
    ASSIGN iSelect = br-monitor-solar:num-selected-rows in frame {&FRAME-NAME}.
    DO iCont = 1 to iSelect:
        if br-monitor-solar:fetch-selected-row(iCont) in frame {&FRAME-NAME}
        THEN DO:
            ASSIGN tt-monitor-solar.logSelecionado = YES.
        END.
    END.
    blk_op:
    FOR  EACH tt-monitor-solar
        WHERE tt-monitor-solar.logSelecionado = YES.
        
        ASSIGN  tt-monitor-solar.logSelecionado = NO
                c-erro  = ""
                c-texto = ""
                iCont   = 0.
        EMPTY TEMP-TABLE tt-rep-prod.
        EMPTY TEMP-TABLE tt-refugo.
        EMPTY TEMP-TABLE tt-res-neg.
        EMPTY TEMP-TABLE tt-erro.

        FIND bf-ord-prod WHERE ROWID(bf-ord-prod) = tt-monitor-solar.rw-ord-prod NO-LOCK NO-ERROR.
        IF NOT AVAIL bf-ord-prod THEN NEXT blk_op.
        IF bf-ord-prod.estado >= 7 THEN NEXT blk_op.

        RUN pi-acompanhar IN h-acomp (INPUT "OP: " + STRING(tt-monitor-solar.nr-ord-prod)).

        PUT STREAM stReporte UNFORMATTED
            tt-monitor-solar.nr-ord-prod    FORMAT ">>>,>>>,>>9"
            SPACE(03)
            bf-ord-prod.it-codigo           FORMAT "X(16)"
            SPACE(03)
            cod-depos-entrada               FORMAT "X(03)"
            SPACE(06)
            param-cp.dep-fabrica            FORMAT "X(03)"
            SPACE(02)
            TODAY                           FORMAT "99/99/9999"
            SPACE(02)
            bf-ord-prod.qt-ordem - bf-ord-prod.qt-produzida     FORMAT ">>>>>,>>9.9999"
            .
        /* Valida alocaá∆o antes do reporte */
        ASSIGN logAlocacao = NO.
        
        aloca-blk:
        FOR  EACH reservas NO-LOCK
                WHERE reservas.nr-ord-prod = tt-monitor-solar.nr-ord-prod.
        
            IF CAN-FIND(FIRST aloca-reserva NO-LOCK
                    WHERE aloca-reserva.nr-ord-prod = reservas.nr-ord-prod
                    AND aloca-reserva.it-codigo = reservas.it-codigo
                    AND aloca-reserva.quant-aloc = reservas.quant-orig
                    AND aloca-reserva.cod-depos   = "PRO")
                AND (reservas.quant-orig - reservas.quant-atend - reservas.quant-aloc) = 0
            THEN DO:
                ASSIGN logAlocacao = YES.
            END.
            ELSE DO:
                    ASSIGN logAlocacao = NO.
                LEAVE aloca-blk.
            END.
        END.
        
        IF tt-monitor-solar.ind-situacao-alocacao = 4 /* Finalizada */ AND logAlocacao = YES
        THEN DO:
            CREATE  tt-rep-prod.
            ASSIGN  tt-rep-prod.tipo                    = 1       //1-Ordem, 2-Operaá∆o, 3-Ponto Controle
                    //tt-rep-prod.nr-reporte              = 1
                    tt-rep-prod.nr-ord-produ            = tt-monitor-solar.nr-ord-prod
                    tt-rep-prod.data                    = TODAY
                    tt-rep-prod.qt-reporte              = bf-ord-prod.qt-ordem - bf-ord-prod.qt-produzida
                    tt-rep-prod.it-codigo               = bf-ord-prod.it-codigo
                    tt-rep-prod.nro-docto               = STRING(tt-monitor-solar.nr-ord-prod)
                    tt-rep-prod.cod-depos               = cod-depos-entrada
                    tt-rep-prod.cod-localiz             = ""
                    tt-rep-prod.cod-depos-sai           = param-cp.dep-fabrica
                    tt-rep-prod.cod-local-sai           = ""
                    tt-rep-prod.cod-refer               = ""
                    tt-rep-prod.dt-vali-lote            = ?
                    tt-rep-prod.lote-serie              = ""
                    tt-rep-prod.finaliza-ordem          = YES
                    tt-rep-prod.un                      = bf-ord-prod.un
                .
    
            /****************************Inicio*utilizacao*cpapi001*******************************/
        
            run pi-recebe-tt-rep-prod   in h-cpapi001 (INPUT TABLE tt-rep-prod).
            run pi-valida-rep-prod in h-cpapi001 (input  NO,
                                                  input  tt-monitor-solar.nr-ord-prod,
                                                  output c-erro,
                                                  output c-texto).
        
            DO iCont = 1 TO NUM-ENTRIES(c-erro):
                run utp/ut-msgs.p (input "msg":U,
                                   input int (entry (iCont, c-erro)),
                                   input entry (iCont, c-texto)).
        
                CREATE tt-erro.
                ASSIGN tt-erro.i-seq    = iCont
                       tt-erro.cd-erro  = INT(ENTRY(iCont, c-erro))
                       tt-erro.mensagem = "Nr.: " + ENTRY(iCont, c-erro) + " - " + RETURN-VALUE.
            END.
            IF NOT CAN-FIND(FIRST tt-erro)
            THEN DO:
                /*
                RUN pi-carrega-tt-reservas IN h-cpapi001 (INPUT tt-rep-prod.reserva, 
                                                          INPUT 1, 
                                                          INPUT ?).
                if return-value <> "OK":U THEN
                   run pi-retorna-tt-erro in h-cpapi001 (output table tt-erro). 
                */
    
                RUN pi-processa-reportes IN h-cpapi001 (INPUT-OUTPUT TABLE tt-rep-prod,
                                                        INPUT        TABLE tt-refugo,
                                                        INPUT        TABLE tt-res-neg,
                                                        INPUT-OUTPUT TABLE tt-erro,
                                                        INPUT        YES,
                                                        INPUT        YES).
            END.
    
            IF NOT CAN-FIND(FIRST tt-erro)
            THEN DO:
                FOR FIRST tt-rep-prod NO-LOCK: END.
                PUT STREAM stReporte UNFORMATTED 
                    SPACE(02)
                    "Reporte Realizado com Sucesso. Nr.Reporte:" + STRING(tt-rep-prod.nr-reporte)
                    SKIP.
            END.
            ELSE DO:
                ASSIGN logPrimeiro = YES.
                FOR EACH tt-erro:
                    IF logPrimeiro
                    THEN DO:
                        PUT STREAM stReporte UNFORMATTED
                            SPACE(02)
                            "Erro:" tt-erro.cd-erro
                            " - "
                            tt-erro.mensagem
                            SKIP.
                        ASSIGN logPrimeiro = NO.
                    END.
                    ELSE DO:
                        PUT STREAM stReporte UNFORMATTED
                            SPACE(75)
                            "Erro:" tt-erro.cd-erro
                            " - "
                            tt-erro.mensagem
                            SKIP.
                    END.
                END.
            END.
        END.
        ELSE DO:
            FOR FIRST tt-rep-prod NO-LOCK: END.
            PUT STREAM stReporte UNFORMATTED 
                SPACE(02)
                "Reporte n∆o permitido. Ordem com alocaáao pendente."
                SKIP.
        END.
    END.


    PUT STREAM stReporte UNFORMATTED
        FILL("-", 132)
        SKIP.
    OUTPUT STREAM stReporte CLOSE.

    OS-COMMAND NO-WAIT VALUE(cArquivo) NO-ERROR.

    IF VALID-HANDLE(h-cpapi001)
    THEN DO:
        RUN pi-finalizar IN h-cpapi001.
        ASSIGN h-cpapi001 = ?.
    END.
    RUN pi-finalizar in h-acomp.

        /****************************Fim*utilizacao*cpapi001*******************************/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSolicitaDeposito w-livre 
PROCEDURE piSolicitaDeposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE rwTT        AS ROWID       NO-UNDO.

    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
   DEFINE VARIABLE fi-cod-depos-entrada AS CHARACTER FORMAT "X(03)"
         LABEL "Dep¢sito" 
         VIEW-AS FILL-IN 
         SIZE 14 BY .88 NO-UNDO.

    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    

    DEFINE FRAME fGoToRecord
        fi-cod-depos-entrada     AT ROW 1.5 COL 20 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Dep¢sito Entrada Produá∆o" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN  fi-cod-depos-entrada.

        ASSIGN cod-depos-entrada = fi-cod-depos-entrada.

    END.

    ON "LEAVE" OF fi-cod-depos-entrada IN FRAME fGoToRecord
    DO:
        FIND FIRST deposito
             WHERE deposito.cod-depos = fi-cod-depos-entrada:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF NOT AVAIL deposito
        THEN DO:
            RUN utp/ut-msgs.p ( INPUT "show",
                                INPUT 56,
                                INPUT "Dep¢sito").
            RETURN NO-APPLY.
        END.
    END.

    ENABLE fi-cod-depos-entrada btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.


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
  {src/adm/template/snd-list.i "tt-aloc-reservas"}
  {src/adm/template/snd-list.i "tt-monitor-solar"}

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
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

