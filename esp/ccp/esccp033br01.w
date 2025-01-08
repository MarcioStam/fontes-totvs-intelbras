&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCCP033br01 2.00.02.042 } /*** 010242 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esccp033br01 MUT}
&ENDIF

/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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
&Scop adm-attribute-dlg support/browserd.w

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{cdp/cdcfgman.i} /******* Include para mini-flexibiliza‡Æo *********/
{esp/ccp/esccp032.i22} /*cdp/cd0666.i*/   /* defini»’o da tt-erro            */
{esp/ccp/esccp032.i24} /*cpapi020.i*/ /*** tt-balanceia  ***/
{esp/ccp/esccp032.i25} /*cpapi020.i1*/ /******* funcoes p/ fator de concentracao e ppm ***/

{esp/es0018.i}

def var l-usa-unid-negoc as logical initial no no-undo.
def var da-data-aux as date   no-undo.

DEFINE VARIABLE l-apenas-oem AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-clientes-oem AS CHARACTER   NO-UNDO.

&IF defined(bf_man_206b) &THEN
    if(can-find(funcao where funcao.cd-funcao = "ems2-unidade-negocio" and
                funcao.ativo     = yes)) then do:
        assign l-usa-unid-negoc = yes.
    end.
&ENDIF

def var de-quantidade  as decimal format "->>>,>>>,>>9.9999" init 0 no-undo.

def temp-table tt-depositos
    field cod-estabel like estabelec.cod-estabel column-label "Cod Estabel"
    field cod-depos   like deposito.cod-depos    column-label "Cod Deposito".

def temp-table tt-estoq no-undo
    field tipo         as char format "x(08)"
    field referencia   as char format "x(85)"
    field quantidade   like de-quantidade
    field dt-inicio    as date format "99/99/9999"
    field dt-termino   as date format "99/99/9999"
    field saldo        as decimal format "->>>>>>,>>9.9999"
    field observ       as char format "x(18)" 
    field item-pai     as char 
    field unid-negoc   as char format "x(3)"
    index codigo is primary dt-termino tipo.

def buffer b-tt-estoq  for tt-estoq.
def buffer b-periodo   for periodo.
def buffer b-ped-item  for ped-item.
def buffer b-item      for item.
def buffer b1-item     for item.
def buffer b-ped-ent     for ped-ent.
def buffer b3-item       for item.

def var de-saldo-inic      as decimal format "->>>>>,>>9.9999".
def var de-saldo-inic-teor as decimal format "->>>>>,>>9.9999".
def var de-saldo-terc      as decimal format "->>>>>,>>9.9999".
def var de-saldo-terc-teor as decimal format "->>>>>,>>9.9999".

def var l-altera       as logical init no no-undo.
def var de-quant-segur like item.quant-segur no-undo.
def var de-saldo       as decimal format "->>>>>,>>9.9999".
def var de-saldo-aloc  as decimal format "->>>>>,>>9.9999" no-undo init 0.
def var de-saldo-item  as decimal format "->>>>>,>>9.9999" no-undo init 0.
def var de-saldo-res   as decimal format "->>>>>,>>9.9999" no-undo init 0.
def var de-ped-saldo   as decimal no-undo.
def var de-qt-min      as decimal no-undo.
def var de-qt-dlt      as decimal no-undo.
def var de-qt-seg      as decimal no-undo.
def var i-dias-dlt     as integer no-undo.
def var de-vezes       as decimal no-undo.
def var i-tam-per      as integer no-undo.
def var da-inicio      as date format "99/99/9999" no-undo.
def var da-termino     as date format "99/99/9999" no-undo.
def var da-termino-f   as date format "99/99/9999" no-undo.
def var da-dat         as date format "99/99/9999" no-undo.
def var da-dat-in      as date format "99/99/9999" no-undo.
def var i-nr-dias      as integer no-undo.
def var i-ressup       as integer no-undo.
def var i-res-var      as integer no-undo.
def var i-resto        as integer no-undo.
def var i-ind          as integer no-undo.
def var i-numero       like prazo-compra.numero-ordem no-undo.
def var i-cont         as integer no-undo.
def var c-cli          like ped-venda.nr-pedcli no-undo.
def var c-ped          like ped-venda.nome-abrev no-undo.
def var c-liter        as char format "x(18)" extent 15 no-undo.
def var c-data         as char format "x(12)" no-undo.
def var da-op-corte    as date init ? no-undo.
def var c-handle as char no-undo.
def var h-handle as handle no-undo.

def new global shared var gr-reservas     as rowid  no-undo.
def new global shared var gr-ord-prod     as rowid  no-undo.
def new global shared var gr-ordem-compra as rowid  no-undo.
def new global shared var gr-ped-venda    as rowid  no-undo.
def new global shared var gr-item-esccp033         as rowid  no-undo.

def new global shared var l-ord-comp-esccp033   as logical   init yes no-undo.
def new global shared var l-ord-prod-esccp033   as logical   init NO no-undo.
def new global shared var l-planejada-esccp033  as logical   init yes no-undo.
def new global shared var l-res-comp-esccp033   as logical   init yes no-undo.
def new global shared var l-res-plan-esccp033   as logical   init yes no-undo.
def new global shared var l-sald-est-esccp033   as logical   init yes no-undo.

def new global shared var l-sald-terc-esccp033  as logical   init YES no-undo.

def new global shared var l-remessa-esccp033     as logical init YES no-undo.
def new global shared var l-entrada-esccp033     as logical init YES no-undo.
def new global shared var l-transfer-esccp033    as logical init yes no-undo.
def new global shared var l-remessa-con-esccp033 as logical init YES no-undo.
def new global shared var l-ent-con-esccp033     as logical init YES no-undo.

def new global shared var l-pedidos-esccp033    as logical   init yes   no-undo.
def new global shared var l-cred-aprov-esccp033 as logical   init yes   no-undo.
def new global shared var l-depositos-esccp033  as logical              no-undo.
def new global shared var p-remessa    as logical   init yes   no-undo.
def new global shared var p-entrada    as logical   init yes   no-undo.
def new global shared var p-transfer   as logical   init yes   no-undo.
def new global shared var p-re-con     as logical   init yes   no-undo.
def new global shared var p-en-con     as logical   init yes   no-undo.
def new global shared var i-benefic-esccp033    as integer   init 2     no-undo.
def new global shared var c-estab-ini-esccp033  as character init "104"    no-undo.
def new global shared var c-estab-fim-esccp033  as character init "110" no-undo.
&IF defined(bf_man_206b) &THEN
    def new global shared var c-unid-negoc-ini-esccp033  as character init ""      no-undo.
    def new global shared var c-unid-negoc-fim-esccp033  as character init "ZZZ"   no-undo.
&ENDIF
def new global shared var da-dt-corte-esccp033  as date format "99/99/9999" init "12/31/9999" no-undo.
def new global shared var da-dt-plan-esccp033   as date format "99/99/9999" init "12/31/9999" no-undo.
def new global shared var i-cod-plano-esccp033  like pl-prod.cd-plano  INIT 4 no-undo.
def new global SHARED var c-cod-refer  like ref-item.cod-refer     no-undo.

DEF NEW GLOBAL SHARED VAR l-apenas-oem-intelbras-esccp033 AS LOGICAL INIT YES NO-UNDO.

def var da-dt-corte    as date format "99/99/9999" init "12/31/9999". 
def var l-ord-comp     as logical init yes no-undo.
def var l-res-comp     as logical init yes no-undo.
def var l-pedidos      as logical init yes no-undo.
def var da-dt-plan     as date format "99/99/9999" init "12/31/9999".

/* definicao da tt-epc */
{include/i-epc200.i1}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-estoq

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table tt-estoq.tipo tt-estoq.referencia tt-estoq.quantidade string (tt-estoq.dt-termino, "99/99/9999") @ c-data tt-estoq.unid-negoc tt-estoq.saldo tt-estoq.observ   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table   
&Scoped-define SELF-NAME br-table
&Scoped-define QUERY-STRING-br-table FOR EACH tt-estoq NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-table OPEN QUERY {&SELF-NAME} FOR EACH tt-estoq NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-table tt-estoq
&Scoped-define FIRST-TABLE-IN-QUERY-br-table tt-estoq


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-table bt-detalhar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
class-fiscal||y|mgind.item.class-fiscal
cod-comprado||y|mgind.item.cod-comprado
it-codigo||y|mgind.item.it-codigo
fm-codigo||y|mgind.item.fm-codigo
ge-codigo||y|mgind.item.ge-codigo
nr-linha||y|mgind.item.nr-linha
cd-tag||y|mgind.item.cd-tag
nat-despesa||y|mgind.item.nat-despesa
cd-planejado||y|mgind.item.cd-planejado
cod-refer||y|mgind.item.cod-refer
un||y|mgind.item.un
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "class-fiscal,cod-comprado,it-codigo,fm-codigo,ge-codigo,nr-linha,cd-tag,nat-despesa,cd-planejado,cod-refer,un"':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS>
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE>
<FILTER-ATTRIBUTES>
************************
* Initialize Filter Attributes */
RUN set-attribute-list IN THIS-PROCEDURE ('
  Filter-Value=':U).
/************************
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-detalhar 
     LABEL "&Detalhar" 
     SIZE 12 BY 1.08.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      tt-estoq SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table B-table-Win _FREEFORM
  QUERY br-table NO-LOCK DISPLAY
      tt-estoq.tipo format "x(05)"
      tt-estoq.referencia WIDTH 30
      tt-estoq.quantidade
      string (tt-estoq.dt-termino, "99/99/9999") @ c-data
      tt-estoq.unid-negoc  
      tt-estoq.saldo
      tt-estoq.observ
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 88 BY 7.04.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br-table AT ROW 1 COL 1
     bt-detalhar AT ROW 8 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 8.13
         WIDTH              = 88.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{include/c-browse.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br-table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-estoq NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is NOT OPENED
*/  /* BROWSE br-table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br-table
&Scoped-define SELF-NAME br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON MOUSE-SELECT-DBLCLICK OF br-table IN FRAME F-Main
DO:
  if bt-detalhar:sensitive in frame {&frame-name} then do:
     RUN New-State('DblClick':U).
     Apply 'Choose' to bt-detalhar.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON ROW-ENTRY OF br-table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON ROW-LEAVE OF br-table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON VALUE-CHANGED OF br-table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
    
  {src/adm/template/brschnge.i}
  run new-state('New-Line|':U + string(rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}))).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-detalhar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-detalhar B-table-Win
ON CHOOSE OF bt-detalhar IN FRAME F-Main /* Detalhar */
DO:

    if avail tt-estoq then do:
      Case tt-estoq.tipo:
           when c-liter[5] then do:
                        assign i-numero = integer(entry(1, tt-estoq.referencia, " ")). /*integer (substring (tt-estoq.referencia, 1, 11)).*/
                                find  reservas where
                                          reservas.nr-ord-prod = i-numero
                                  and reservas.it-codigo = item.it-codigo no-lock no-error.
                                if avail reservas then do:
                                        assign gr-reservas = rowid (reservas).
                                        run cpp/cp0508.w.
                                end.
                                else do:
                                        for each reservas where
                                                         reservas.nr-ord-prod = i-numero
                                                 and reservas.it-codigo = item.it-codigo
                                                 and reservas.dt-reserva = tt-estoq.dt-termino no-lock:
                                                assign de-saldo-res = reservas.quant-orig - reservas.quant-aloc - reservas.quant-atend.
                                                if de-saldo-res = (tt-estoq.quantidade * (-1)) then do:
                                                   assign gr-reservas = rowid (reservas).
                                                   run cpp/cp0508.w.
                                                   leave.
                                                end.
                                        end.
                end.
           end.
    
           when c-liter[1] then do:
                assign i-numero = integer(entry(1, tt-estoq.referencia, " ")). /*integer (substring (tt-estoq.referencia, 1, 11)).*/
                find ord-prod where 
                     ord-prod.nr-ord-produ = i-numero
                     no-lock no-error.
                if avail ord-prod then do:
                   assign gr-ord-prod = rowid (ord-prod).
                   run cdp/cd9070.w.
                end.
           end.
    
           when c-liter[3] OR WHEN c-liter[2] then do:
                do i-cont = 1 to 9:
                   if substr (tt-estoq.referencia, i-cont, 1) = "/" then do:
                      assign i-numero = i-cont - 1.
                      leave.
                   end.
                   else
                       assign i-numero = i-cont.
                end.
                assign i-numero = integer (substr (tt-estoq.referencia, 1, i-numero)).
                find first ordem-compra where
                     ordem-compra.numero-ordem = i-numero no-lock no-error.
                if avail ordem-compra then do:
                   assign gr-ordem-compra = rowid (ordem-compra).
                   run ccp/cc0505.w.
                end.
           end.
    
           when c-liter[6] then do:
               IF NUM-ENTRIES(tt-estoq.referencia, "/") > 2 THEN DO:
                   RUN getValuePedido (INPUT tt-estoq.referencia,
                                       INPUT NUM-ENTRIES(tt-estoq.referencia, "/"),
                                       OUTPUT c-cli, 
                                       OUTPUT c-ped).
               END.
               ELSE assign c-cli = entry(1, tt-estoq.referencia, "/")  /*substr (tt-estoq.referencia, 1, 12)*/
                           c-ped = entry(2, tt-estoq.referencia, "/"). /*substr (tt-estoq.referencia, 14, 12).*/
                find ped-venda use-index ch-pedido where
                     ped-venda.nome-abrev = c-cli and
                     ped-venda.nr-pedcli = c-ped no-lock no-error.
                if avail ped-venda then do:
                   assign gr-ped-venda = rowid (ped-venda).
                   run pdp/pd1001.w.
                end.
           end.
    
           when c-liter[7] or when c-liter[8] then do:
                assign gr-item-esccp033 = rowid (item).
                run plp/pl0704.w.
           end.                        
      end. 
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF
FIND FIRST param-global NO-LOCK NO-ERROR.

{utp/ut-liter.i O_P * r}
assign c-liter[1] = trim (return-value).

{utp/ut-liter.i O_C* * r}
assign c-liter[2] = trim (return-value).

{utp/ut-liter.i O_C * r}
assign c-liter[3] = trim (return-value).

{utp/ut-liter.i O.S. * r}
assign c-liter[4] = trim (return-value).

{utp/ut-liter.i Res * r}
assign c-liter[5] = trim (return-value).

{utp/ut-liter.i P_V * r}
assign c-liter[6] = trim (return-value).

{utp/ut-liter.i O_Pl * r}
assign c-liter[7] = trim (return-value).

{utp/ut-liter.i R_Pl * r}
assign c-liter[8] = trim (return-value).

{utp/ut-liter.i Negativo * r}
assign c-liter[9] = trim (return-value).

{utp/ut-liter.i Abaixo_Qt_Segur * r}
assign c-liter[10] = trim (return-value).

{utp/ut-liter.i Tipo * r}
assign tt-estoq.tipo:label = trim (return-value).

{utp/ut-liter.i Inf_Complementares * r}
assign tt-estoq.referencia:label = trim (return-value).

IF param-global.modulo-per-ppm THEN DO:
    {utp/ut-liter.i Quantidade_Te¢rica * r}
    assign tt-estoq.quantidade:label = trim (return-value).
END.
ELSE DO:
    {utp/ut-liter.i Quantidade * r}
    assign tt-estoq.quantidade:label = trim (return-value).
END.

{utp/ut-liter.i Data * r}
assign c-data:label in browse {&browse-name} = trim (return-value).

{utp/ut-liter.i U._Neg * r}
assign tt-estoq.unid-negoc:label = trim (return-value).

IF param-global.modulo-per-ppm THEN DO:
    {utp/ut-liter.i Saldo_Te¢rico * r}
    assign tt-estoq.saldo:label = trim (return-value).
END.
ELSE DO:
    {utp/ut-liter.i Saldo * r}
    assign tt-estoq.saldo:label = trim (return-value).
END.

{utp/ut-liter.i Observa‡äes * r}
assign tt-estoq.observ:label = trim (return-value).

/* calacula a simula‡Æo de estoque */
{esp/ccp/esccp032.i20}   /* cdp/cd0284.i */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR Filter-Value AS CHAR NO-UNDO.

  /* Copy 'Filter-Attributes' into local variables. */
  RUN get-attribute ('Filter-Value':U).
  Filter-Value = RETURN-VALUE.

  /* No Foreign keys are accepted by this SmartObject. */

  {&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValuePedido B-table-Win 
PROCEDURE getValuePedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM cInfoPedido LIKE tt-estoq.referencia.
DEFINE INPUT PARAM iEntrada AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAM c-cli LIKE ped-item.nome-abrev.
DEFINE OUTPUT PARAM c-ped LIKE ped-item.nr-pedcli.

DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

ASSIGN i-cont = 1.
REPEAT :
    ASSIGN c-cli = c-cli + ENTRY(i-cont, cInfoPedido, "/")
           i-cont = i-cont + 1.

    IF CAN-FIND(FIRST ped-venda NO-LOCK WHERE 
                      ped-venda.nome-abrev = c-cli) THEN DO:
        ASSIGN c-ped = SUBSTRING(cInfoPedido, LENGTH(c-cli) + 2, LENGTH(cInfoPedido) - LENGTH(c-cli)).
    END.

    FIND FIRST ped-venda NO-LOCK
        WHERE ped-venda.nome-abrev = c-cli AND
              ped-venda.nr-pedcli = c-ped NO-ERROR.
    IF AVAIL ped-venda THEN LEAVE.

    ASSIGN c-cli = c-cli + "/".

END.

/*ASSIGN c-cli = ENTRY(1, cInfoPedido, "/").
DO i = 2 TO NUM-ENTRIES(cInfoPedido, "/"):
    IF i = 2 THEN
    ASSIGN c-ped = ENTRY(i, cInfoPedido, "/").
    ELSE ASSIGN c-ped = c-ped + "/" + ENTRY(i, cInfoPedido, "/").
END.

FIND FIRST ped-venda NO-LOCK
    WHERE ped-venda.nr-pedcli = c-ped AND
          ped-venda.nome-abrev = c-cli NO-ERROR.
MESSAGE AVAIL ped-venda
    VIEW-AS ALERT-BOX INFO BUTTONS OK.*/



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy B-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  IF VALID-HANDLE(h-cpapi020) THEN
      DELETE PROCEDURE h-cpapi020.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  
  ASSIGN tt-estoq.unid-negoc:VISIBLE IN BROWSE {&browse-name} = NO.
  
  &IF defined(bf_man_206b) &THEN
    IF l-usa-unid-negoc THEN
        ASSIGN tt-estoq.unid-negoc:VISIBLE IN BROWSE {&browse-name} = YES.
  &ENDIF
  
  IF CAN-FIND(FIRST param-global WHERE param-global.modulo-per-ppm) THEN DO:
      run cpp/cpapi020.p persistent set h-cpapi020(INPUT-OUTPUT table tt-balanceia,
                                                   input-output table tt-erro,
                                                   INPUT        YES,
                                                   input-OUTPUT TABLE tt-veiculos).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view B-table-Win 
PROCEDURE local-view :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  apply 'value-changed':U to {&browse-name} in frame {&frame-name}.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartBrowser, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calc-sim-estoque B-table-Win 
PROCEDURE pi-calc-sim-estoque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input  parameter r-item               as rowid   no-undo.
def input  parameter p-cod-refer          as char    no-undo.
def output parameter p-de-saldo-inic      as decimal no-undo.
def output parameter p-de-saldo-inic-teor as decimal no-undo.
def output parameter p-de-quant-segur     as decimal no-undo.
def output parameter p-de-saldo-terc      as decimal no-undo.
def output parameter p-de-saldo-terc-teor as decimal no-undo.

DEF VAR i-nr-linha-ini AS INT NO-UNDO.
DEF VAR i-nr-linha-fim AS INT NO-UNDO.
DEF VAR c-plan-ini     LIKE ITEM.cd-planejado NO-UNDO.
DEF VAR c-plan-fim     LIKE ITEM.cd-planejado NO-UNDO.


RUN set-cursor IN adm-broker-hdl (INPUT "WAIT":U).

find first param-global no-lock no-error.
find item where rowid (item) = r-item no-lock no-error.

FIND b-item WHERE rowid(b-item) = r-item NO-LOCK NO-ERROR.

ASSIGN c-cod-refer = p-cod-refer
       l-apenas-oem = l-apenas-oem-intelbras-esccp033
       da-dt-corte = da-dt-corte-esccp033
       l-ord-comp = l-ord-comp-esccp033
       l-res-comp = l-res-comp-esccp033
       l-pedidos = l-pedidos-esccp033
       da-dt-plan = da-dt-plan-esccp033.


RUN pi-simulacao-estoque(BUFFER b-item,
                         INPUT l-sald-est-esccp033, 
                         INPUT l-remessa-esccp033,
                         INPUT l-entrada-esccp033,
                         INPUT l-transfer-esccp033,
                         INPUT l-remessa-con-esccp033, 
                         INPUT l-ent-con-esccp033,
                         INPUT c-plan-ini,
                         INPUT c-plan-fim,
                         INPUT i-nr-linha-ini,
                         INPUT i-nr-linha-fim,
                         INPUT l-sald-terc-esccp033,
                         INPUT c-estab-ini-esccp033,
                         INPUT c-estab-fim-esccp033,
                         INPUT l-ord-prod-esccp033,
                         INPUT i-benefic-esccp033,
                         INPUT l-cred-aprov-esccp033,
                         INPUT l-planejada-esccp033,
                         INPUT l-res-plan-esccp033,
                         INPUT i-cod-plano-esccp033
                         &IF defined(bf_man_206b) &THEN
                            ,INPUT c-unid-negoc-ini-esccp033,
                             INPUT c-unid-negoc-fim-esccp033
                         &ENDIF
                         ).
IF param-global.modulo-per-ppm AND 
    AVAIL ITEM AND ITEM.tipo-formula >= 2 AND ITEM.tipo-formula <= 3 THEN
    assign de-saldo = de-saldo-inic-teor.
ELSE
    assign de-saldo = de-saldo-inic.

for each tt-estoq:
    if tt-estoq.tipo = c-liter[5] or
       tt-estoq.tipo = c-liter[6] or
       tt-estoq.tipo = c-liter[8] then do:
        assign de-saldo      = de-saldo - tt-estoq.quantidade
               de-quantidade = (tt-estoq.quantidade * (-1)).
    end.
    else
        assign de-saldo = de-saldo
                        + if tt-estoq.tipo = c-liter[2] then
                          0
                        else
                            tt-estoq.quantidade
               de-quantidade = tt-estoq.quantidade.

    assign tt-estoq.obs = if de-saldo < 0 
                          then c-liter[9]
                          else if de-saldo < de-quant-segur
                               then c-liter[10]
                               else ""
           tt-estoq.saldo = de-saldo
           tt-estoq.quantidade = de-quantidade.
end.

assign p-de-saldo-inic      = de-saldo-inic
       p-de-saldo-inic-teor = de-saldo-inic-teor
       p-de-quant-segur     = de-quant-segur
       p-de-saldo-terc      = de-saldo-terc
       p-de-saldo-terc-teor = de-saldo-terc-teor.

IF param-global.modulo-per-ppm AND 
    AVAIL ITEM AND ITEM.tipo-formula >= 2 AND ITEM.tipo-formula <= 3 THEN DO:
    {utp/ut-liter.i Quantidade_Te¢rica * r}
    assign tt-estoq.quantidade:label IN BROWSE br-table = trim (return-value).
    {utp/ut-liter.i Saldo_Te¢rico * r}
    assign tt-estoq.saldo:label IN BROWSE br-table = trim (return-value).
END.
ELSE DO:
    {utp/ut-liter.i Quantidade * r}
    assign tt-estoq.quantidade:LABEL IN BROWSE br-table = trim (return-value).
    {utp/ut-liter.i Saldo * r}
    assign tt-estoq.saldo:LABEL IN BROWSE br-table = trim (return-value).
END.

{&OPEN-QUERY-{&BROWSE-NAME}}

assign bt-detalhar:sensitive in frame {&frame-name} = (num-results ("br-table") > 0).

RUN set-cursor IN adm-broker-hdl (INPUT "").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-parametros B-table-Win 
PROCEDURE pi-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

run esp/ccp/esccp033a.w (input-output table tt-depositos).

RUN get-link-handle IN adm-broker-hdl
   (INPUT this-procedure,
    INPUT "record-source",
    OUTPUT c-handle).

assign h-handle = widget-handle (c-handle).

run dispatch in h-handle ('row-available':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-upc B-table-Win 
PROCEDURE pi-upc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /**********************************************************************
    ** UPC Especifica
    ** Podem ser passados parametros para ela afim de reutilizar o codigo
    ** se houver necessidade.
    **********************************************************************/ 

    def input param p-ind-event        as char          no-undo.
    def input param p-ind-object       as char          no-undo.
    def input param p-wgh-object       as handle        no-undo.
    def input param p-wgh-frame        as widget-handle no-undo.
    def input param p-cod-table        as char          no-undo.
    def input param p-row-table        as rowid         no-undo.

    &IF DEFINED(OriginalName) <> 0 &THEN
         ASSIGN THIS-PROCEDURE:PRIVATE-DATA = "{&OriginalName}".
    &ELSE
         ASSIGN THIS-PROCEDURE:PRIVATE-DATA = THIS-PROCEDURE:file-name.
    &ENDIF

    /* DPC */
    if  c-nom-prog-dpc-mg97 <> ""
    and c-nom-prog-dpc-mg97 <> ? then do:

        run value(c-nom-prog-dpc-mg97) (input p-ind-event, 
                                        input p-ind-object,
                                        input p-wgh-object,
                                        input p-wgh-frame,
                                        input p-cod-table,
                                        input p-row-table).    

    end.

    /* APPC */
    if  c-nom-prog-appc-mg97 <> ""
    and c-nom-prog-appc-mg97 <> ? then do:           

        run value(c-nom-prog-appc-mg97) (input p-ind-event, 
                                         input p-ind-object,
                                         input p-wgh-object,
                                         input p-wgh-frame,
                                         input p-cod-table,
                                         input p-row-table).    

    end.                                       

    /* UPC */
    if  c-nom-prog-upc-mg97 <> ""
    and c-nom-prog-upc-mg97 <> ? then do:
        run value(c-nom-prog-upc-mg97) (input p-ind-event, 
                                        input p-ind-object,
                                        input p-wgh-object,
                                        input p-wgh-frame,
                                        input p-cod-table,
                                        input p-row-table).    
    end.               


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "class-fiscal" "item" "class-fiscal"}
  {src/adm/template/sndkycas.i "cod-comprado" "item" "cod-comprado"}
  {src/adm/template/sndkycas.i "it-codigo" "item" "it-codigo"}
  {src/adm/template/sndkycas.i "fm-codigo" "item" "fm-codigo"}
  {src/adm/template/sndkycas.i "ge-codigo" "item" "ge-codigo"}
  {src/adm/template/sndkycas.i "nr-linha" "item" "nr-linha"}
  {src/adm/template/sndkycas.i "cd-tag" "item" "cd-tag"}
  {src/adm/template/sndkycas.i "nat-despesa" "item" "nat-despesa"}
  {src/adm/template/sndkycas.i "cd-planejado" "item" "cd-planejado"}
  {src/adm/template/sndkycas.i "cod-refer" "item" "cod-refer"}
  {src/adm/template/sndkycas.i "un" "item" "un"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

