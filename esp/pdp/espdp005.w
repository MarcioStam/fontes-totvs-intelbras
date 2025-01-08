&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
          mgmov            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttAtendente NO-UNDO LIKE atendente
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttped-venda NO-UNDO LIKE ped-venda
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESPDP005 2.04.04.007}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          ESPDP005
&GLOBAL-DEFINE Version          2.04.04.007

&GLOBAL-DEFINE Folder           NO
&GLOBAL-DEFINE InitialPage      0
&GLOBAL-DEFINE FolderLabels     Pedidos

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           NO

&GLOBAL-DEFINE AddParent        NO
&GLOBAL-DEFINE CopyParent       NO
&GLOBAL-DEFINE UpdateParent     NO
&GLOBAL-DEFINE DeleteParent     NO

&GLOBAL-DEFINE AddSon1          NO
&GLOBAL-DEFINE CopySon1         NO
&GLOBAL-DEFINE UpdateSon1       NO
&GLOBAL-DEFINE DeleteSon1       NO
&GLOBAL-DEFINE DetailSon1       NO

&GLOBAL-DEFINE ttParent         ttAtendente
&GLOBAL-DEFINE hDBOParent       hAtendente
&GLOBAL-DEFINE DBOParentTable   atendente
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           ttPed-venda
&GLOBAL-DEFINE hDBOSon1         hPed-venda
&GLOBAL-DEFINE DBOSon1Table     ped-venda
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE page0Fields      ttAtendente.cd-oper ttAtendente.nm-oper fi-bloqueado fi-bloqueado-3 fi-incompleto fi-fob set-cod-priori-10 bt-full-screen

&GLOBAL-DEFINE page0Widgets     set-cod-priori-10
&GLOBAL-DEFINE page1Browse      brSon1

&SCOPED-DEFINE ENABLED-OBJECTS  set-cod-priori-10

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR gr-ped-venda      AS ROWID         NO-UNDO.

DEF VAR r-ant AS ROWID NO-UNDO.

DEF VAR c-descsit AS CHAR FORMAT "x(20)"            LABEL "CrÇdito".
DEF VAR i-cond    AS INT  FORMAT ">>9"              LABEL "C. Pg".
DEF VAR d-parc    AS DEC  FORMAT ">,>>>,>>>,>>9.99" LABEL "Vl Parcela".
DEF VAR d-taxa    AS DEC  FORMAT ">>9.999999"       LABEL "Tx".
DEF VAR i-base    AS INT  FORMAT ">>9"              LABEL "Car".
DEF VAR c-frete   AS CHAR FORMAT "x(20)"            LABEL "Frete".
DEF VAR c-sit     AS CHAR FORMAT "x(20)"            LABEL "Sit. Ped".
DEF VAR i-parc    AS INT  FORMAT ">9"               LABEL "P".
DEF VAR c-natcli  AS CHAR FORMAT "x(03)"            LABEL "Nat".
DEF VAR h-pedido             AS HANDLE NO-UNDO.
DEF VAR i-priori AS INT NO-UNDO.
DEF VAR c-atendente AS CHAR NO-UNDO.
DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-origem   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cat AS CHARACTER   NO-UNDO.
DEF VAR c-cod-transp AS INT.  
DEF VAR c-sigla-transp AS CHAR.
DEFINE VARIABLE d-peso-tot AS DECIMAL NO-UNDO.
DEFINE VARIABLE l-suframa AS LOGICAL     NO-UNDO.

&GLOBAL-DEFINE mouse-select-dblclick1 YES
&GLOBAL-DEFINE NumRowsReturned  1000
&GLOBAL-DEFINE off-end1         YES
&GLOBAL-DEFINE off-home1        YES

def var i-cod-motivo          as int  no-undo.
def var c-desc-motivo         as char no-undo.
def var da-data               as date no-undo.
def var l-resultado           as log  no-undo.

def var bo-ped-venda-rct as handle no-undo.
def var bo-ped-venda-sus as handle no-undo.
def var bo-ped-venda     as handle no-undo.
def var h-espdp045       as handle no-undo.

def temp-table ttped-venda-aux  like ttped-venda.

DEFINE VARIABLE h-pd4000      AS HANDLE NO-UNDO.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usuˇrio Corrente"
    column-label "Usuˇrio Corrente"
    no-undo.

DEFINE VARIABLE r-rowid-atual   AS ROWID       NO-UNDO.
DEFINE VARIABLE r-proximo-rowid AS ROWID       NO-UNDO.
DEFINE BUFFER b-ttped-venda FOR ttped-venda.

/* parametro ordena browser */
DEFINE VARIABLE c-ordena-campo  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-ordem         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-parametro     AS LOGICAL INIT YES NO-UNDO.

/* Utilizado para impedir que se abra 2 pd4000 ao mesmo tempo */
define new global shared var wh-dt-entrega-pd4000  as widget-handle no-undo.

DEFINE VARIABLE deWidth      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deWidthDif   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deHeight     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deheightDif  AS DECIMAL     NO-UNDO.

def var iStyle                           as integer   no-undo init ?.
def var iOldMenu                         as integer   no-undo.
def var dColWin                          as decimal   no-undo.
def var dRowWin                          as decimal   no-undo.
def var dHeiWin                          as decimal   no-undo.
def var dWidWin                          as decimal   no-undo.
DEFINE VARIABLE hbtb        AS HANDLE.
DEFINE VARIABLE h_frame     AS WIDGET     NO-UNDO.
DEFINE VARIABLE p-wgh-frame AS WIDGET     NO-UNDO.
DEFINE VARIABLE h_fpage0    AS WIDGET     NO-UNDO.
DEFINE VARIABLE h_fpage1    AS WIDGET     NO-UNDO.

{utp/ut-glob.i}

procedure LockWindowUpdate external {&user} :
   def input  parameter hWndLock as long.
end procedure.

procedure GetWindowLongA external "user32.dll":
   def input  parameter hwnd   as long.
   def input  parameter nIndex as long.
   def return parameter returnValue as long.
end procedure.

procedure SetWindowLongA external "user32.dll":
   def input  parameter hwnd        as long.
   def input  parameter nIndex      as long.
   def input  parameter dwNewlong   as long.
   def return parameter returnValue as long.
end procedure.

procedure Bit_Remove external "PROEXTRA.DLL" :
   def input-output parameter Flags   as long.
   def input        parameter OldFlag as long.
end procedure.

procedure GetMenu external "user32.dll":
   def input  parameter iHwnd as long.
   def return parameter hMenu as long.
end procedure.

procedure SetMenu external "user32.dll":
   def input parameter iHwnd as long.
   def input parameter hMenu as long.
end procedure.

DEF VAR de-dif-largura AS DEC NO-UNDO.
DEF VAR de-dif-altura AS DEC NO-UNDO.

DEF VAR fpage0_altura_ini     AS DEC NO-UNDO.
DEF VAR fpage0_largura_ini    AS DEC NO-UNDO.
DEF VAR fpage1_altura_ini     AS DEC NO-UNDO.
DEF VAR fpage1_largura_ini    AS DEC NO-UNDO.
DEF VAR rtParent_largura_ini  AS DEC NO-UNDO.
DEF VAR brson1_largura_ini    AS DEC NO-UNDO.
DEF VAR brson1_altura_ini     AS DEC NO-UNDO.
DEF VAR window_largura_ini    AS DEC NO-UNDO.
DEF VAR window_altura_ini     AS DEC NO-UNDO.
DEF VAR rtToolBar_largura_ini AS DEC NO-UNDO.



DEF VAR l-ampliou AS LOG INIT NO NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttped-venda int-ped-venda pd-vendor ~
cond-pagto int-cond-pagto emitente

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 fnDescSit(ttped-venda.cod-sit-aval) @ c-descsit fnSit(ttped-venda.cod-sit-ped) @ c-sit ttped-venda.cod-priori ttped-venda.cod-emitente ttped-venda.nome-abrev ttped-venda.estado fnCanalCliente(ttped-venda.nr-pedido,ttped-venda.cod-estabel, ttped-venda.cod-emitente) @ c-cat ttped-venda.cod-gr-cli ttped-venda.no-ab-reppri ttped-venda.cod-estabel ttped-venda.nr-pedcli fnCond() @ i-cond fnParc() @ i-parc fnValorParc() @ d-parc ttped-venda.vl-liq-abe fnPesoTotal(ttped-venda.nome-abrev,ttped-venda.nr-pedcli) @ d-peso-tot ttped-venda.dt-entrega ttped-venda.nome-transp ttped-venda.nat-operacao fnTaxa() @ d-taxa fnBase() @ i-base fnorigem() @ c-origem fnmensagem() @ c-mensagem ttped-venda.desc-bloq-cr ttped-venda.nome-tr-red ttped-venda.cond-redespa   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define SELF-NAME brSon1
&Scoped-define OPEN-QUERY-brSon1 RUN pi-ordena. IF c-ordena-campo = '' THEN DO:     IF ttAtendente.cd-oper >= 94 then         OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                 first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                 EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                 FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                 FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                 FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK           BY ttped-venda.cod-sit-ped           BY ttped-venda.cod-sit-aval           BY ttped-venda.no-ab-reppri           BY ttped-venda.nome-abrev           BY ttped-venda.cod-priori.     ELSE         OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                 first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                 EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                 FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                 FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                 FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK           BY ttped-venda.cod-sit-aval           BY ttped-venda.no-ab-reppri           BY ttped-venda.nome-abrev           BY ttped-venda.cod-priori. END. ELSE DO:     IF c-ordena-campo = "c-descsit" THEN DO:         IF l-parametro  THEN             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-sit-aval             .         ELSE             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-sit-aval DESCENDING             .     END.     IF c-ordena-campo = "c-sit" THEN DO:         IF l-parametro  THEN             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-sit-ped             .         ELSE             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-sit-ped DESCENDING             .     END.     IF c-ordena-campo = "cod-priori" THEN DO:         IF l-parametro  THEN             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-priori             .         ELSE             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-priori DESCENDING             .     END.     IF c-ordena-campo = "cod-emitente" THEN DO:         IF l-parametro  THEN             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-emitente             .         ELSE             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-emitente DESCENDING             .     END.     IF c-ordena-campo = "nome-abrev" THEN DO:         IF l-parametro  THEN             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.nome-abrev             .         ELSE             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.nome-abrev DESCENDING             .     END.     IF c-ordena-campo = "cod-gr-cli" THEN DO:         IF l-parametro  THEN             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-gr-cli             .         ELSE             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-gr-cli DESCENDING             .     END.     IF c-ordena-campo = "no-ab-reppri" THEN DO:         IF l-parametro  THEN             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.no-ab-reppri             .         ELSE             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.no-ab-reppri DESCENDING             .     END.     IF c-ordena-campo = "nr-pedcli" THEN DO:         IF l-parametro  THEN             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.nr-pedcli             .         ELSE             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.nr-pedcli DESCENDING             .     END.     IF c-ordena-campo = "vl-liq-abe" THEN DO:         IF l-parametro  THEN             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.vl-liq-abe             .         ELSE             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.vl-liq-abe DESCENDING             .     END.     IF c-ordena-campo = "dt-entrega" THEN DO:         IF l-parametro  THEN             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.dt-entrega             .         ELSE             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.dt-entrega DESCENDING             .     END.     IF c-ordena-campo = "nome-transp" THEN DO:         IF l-parametro  THEN             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.nome-transp             .         ELSE             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.nome-transp DESCENDING             .     END.     IF c-ordena-campo = "i-cond" THEN DO:         IF l-parametro  THEN             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-cond-pag             .         ELSE             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-cond-pag DESCENDING             .     END.     IF c-ordena-campo = "d-parc" THEN DO:         IF l-parametro  THEN             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.vl-liq-abe             .         ELSE             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.vl-liq-abe DESCENDING             .     END.     IF c-ordena-campo = "estado" THEN DO:         IF l-parametro  THEN             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.estado             .         ELSE             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.estado DESCENDING             .     END.     IF c-ordena-campo = "desc-bloq-cr" THEN DO:         IF l-parametro  THEN             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.desc-bloq-cr.          ELSE             OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK, ~
                     first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK, ~
                     EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK, ~
                     FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.desc-bloq-cr DESCENDING.      END.                                                                                                                                                                                                                            END.
&Scoped-define TABLES-IN-QUERY-brSon1 ttped-venda int-ped-venda pd-vendor ~
cond-pagto int-cond-pagto emitente
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 ttped-venda
&Scoped-define SECOND-TABLE-IN-QUERY-brSon1 int-ped-venda
&Scoped-define THIRD-TABLE-IN-QUERY-brSon1 pd-vendor
&Scoped-define FOURTH-TABLE-IN-QUERY-brSon1 cond-pagto
&Scoped-define FIFTH-TABLE-IN-QUERY-brSon1 int-cond-pagto
&Scoped-define SIXTH-TABLE-IN-QUERY-brSon1 emitente


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttAtendente.cd-oper ttAtendente.nm-oper 
&Scoped-define ENABLED-TABLES ttAtendente
&Scoped-define FIRST-ENABLED-TABLE ttAtendente
&Scoped-Define ENABLED-OBJECTS rtToolBar rtParent btFirst btPrev btNext ~
btLast btGoTo btQueryJoins btReportsJoins btExit btHelp bt-full-screen ~
set-cod-priori-10 set-orcamento fi-fob fi-incompleto fi-bloqueado ~
fi-bloqueado-3 
&Scoped-Define DISPLAYED-FIELDS ttAtendente.cd-oper ttAtendente.nm-oper 
&Scoped-define DISPLAYED-TABLES ttAtendente
&Scoped-define FIRST-DISPLAYED-TABLE ttAtendente
&Scoped-Define DISPLAYED-OBJECTS set-cod-priori-10 set-orcamento fi-fob ~
fi-incompleto fi-bloqueado fi-bloqueado-3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 fPage0 brSon1 fPage1 
&Scoped-define List-2 bt-limpa-observ btDetail btSaldo btPriori btReat ~
bt-espdp054 bt-espdp006 bt-espdp003 bt-transf-dep 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnBase wMasterDetail 
FUNCTION fnBase RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCanalCliente wMasterDetail 
FUNCTION fnCanalCliente RETURNS CHARACTER
  ( p-nr-pedido AS INT,
    p-cod-estabel AS CHAR,
    p-cod-emitente AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCond wMasterDetail 
FUNCTION fnCond RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCredito wMasterDetail 
FUNCTION fnCredito RETURNS CHARACTER
  ( p-sit AS INTEGER,
    p-flex AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescSit wMasterDetail 
FUNCTION fnDescSit RETURNS CHARACTER
  ( p-sit AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnFrete wMasterDetail 
FUNCTION fnFrete RETURNS CHARACTER
  ( p-frete AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnmensagem wMasterDetail 
FUNCTION fnmensagem RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNatCli wMasterDetail 
FUNCTION fnNatCli RETURNS CHARACTER
  ( p-cod-emitente AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnorigem wMasterDetail 
FUNCTION fnorigem RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnParc wMasterDetail 
FUNCTION fnParc RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPesoTotal wMasterDetail 
FUNCTION fnPesoTotal RETURNS DECIMAL
  ( INPUT p-nome-abrev AS CHARACTER,
    INPUT p-nr-pedcli  AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSit wMasterDetail 
FUNCTION fnSit RETURNS CHARACTER
  ( p-ped AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTaxa wMasterDetail 
FUNCTION fnTaxa RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnValorParc wMasterDetail 
FUNCTION fnValorParc RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miDetail       LABEL "Detalhar"       ACCELERATOR "CTRL-D"
       MENU-ITEM miSaldo        LABEL "Saldo Items"    ACCELERATOR "CTRL-S"
       MENU-ITEM miPriori       LABEL "Prioridade"     ACCELERATOR "CTRL-P"
       MENU-ITEM miReat         LABEL "Suspender/Reativar" ACCELERATOR "CTRL-R"
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-full-screen 
     IMAGE-UP FILE "image/tela-inteira.bmp":U
     LABEL "Maximizar" 
     SIZE 4.43 BY 1.13 TOOLTIP "Maximizar/Restaurar tela".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE fi-bloqueado AS CHARACTER FORMAT "X(256)":U INITIAL "Item Bloqueado ou Reprovado por valor" 
      VIEW-AS TEXT 
     SIZE 44 BY .75
     BGCOLOR 2 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE fi-bloqueado-3 AS CHARACTER FORMAT "X(256)":U INITIAL "Transportadora Fora do Padr∆o" 
      VIEW-AS TEXT 
     SIZE 36 BY .75
     BGCOLOR 15 FGCOLOR 13 FONT 0 NO-UNDO.

DEFINE VARIABLE fi-fob AS CHARACTER FORMAT "X(256)":U INITIAL "FOB" 
      VIEW-AS TEXT 
     SIZE 44 BY .75
     BGCOLOR 14 FONT 0 NO-UNDO.

DEFINE VARIABLE fi-incompleto AS CHARACTER FORMAT "X(256)":U INITIAL "Pedido Incompleto" 
      VIEW-AS TEXT 
     SIZE 44 BY .75
     BGCOLOR 1 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 165 BY 4.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE-PIXELS 1162 BY 36
     BGCOLOR 7 .

DEFINE VARIABLE set-cod-priori-10 AS LOGICAL INITIAL no 
     LABEL "Listar com Prioridade 10" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE VARIABLE set-orcamento AS LOGICAL INITIAL no 
     LABEL "Listar Oráamentos" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE BUTTON bt-espdp003 
     LABEL "ESPDP003" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-espdp006 
     LABEL "ESPDP006" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-espdp054 
     LABEL "ESPDP054" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-limpa-observ 
     LABEL "Limpa Observ." 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-transf-dep 
     LABEL "TRANSF.ATENDENTE" 
     SIZE 17 BY 1.

DEFINE BUTTON btDetail 
     LABEL "Detalhar" 
     SIZE 10 BY 1.

DEFINE BUTTON btPriori 
     LABEL "Priori/Atend" 
     SIZE 10 BY 1.

DEFINE BUTTON btReat 
     LABEL "Reat/Susp" 
     SIZE 10.14 BY 1.

DEFINE BUTTON btSaldo 
     LABEL "Saldo Items" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      ttped-venda, 
      int-ped-venda, 
      pd-vendor, 
      cond-pagto, 
      int-cond-pagto, 
      emitente SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 NO-LOCK DISPLAY
      fnDescSit(ttped-venda.cod-sit-aval) @ c-descsit COLUMN-LABEL "Cr" FORMAT "x(2)":U WIDTH 2
      fnSit(ttped-venda.cod-sit-ped) @ c-sit COLUMN-LABEL "Sit" FORMAT "x(11)":U WIDTH 9
      ttped-venda.cod-priori COLUMN-LABEL "Pr" FORMAT "99":U WIDTH 2
      ttped-venda.cod-emitente COLUMN-LABEL "Codigo" FORMAT "99999999":U WIDTH 9
      ttped-venda.nome-abrev COLUMN-LABEL "Nome Abrev" FORMAT "x(12)":U WIDTH 12
      ttped-venda.estado COLUMN-LABEL "UF" FORMAT "x(2)":U WIDTH 2
      fnCanalCliente(ttped-venda.nr-pedido,ttped-venda.cod-estabel, ttped-venda.cod-emitente) @ c-cat  COLUMN-LABEL "Canal" 
      ttped-venda.cod-gr-cli COLUMN-LABEL "Gr" FORMAT "99":U WIDTH 2
      ttped-venda.no-ab-reppri COLUMN-LABEL "Repres" FORMAT "x(12)":U WIDTH 12
      ttped-venda.cod-estabel COLUMN-LABEL "Estab" FORMAT "x(4)":U WIDTH 5
      ttped-venda.nr-pedcli COLUMN-LABEL "Pedido" FORMAT "x(12)":U WIDTH 8
      fnCond() @ i-cond COLUMN-LABEL "C.Pg" FORMAT ">>9":U WIDTH 4
      fnParc() @ i-parc COLUMN-LABEL "P" FORMAT ">9":U WIDTH 2
      fnValorParc() @ d-parc COLUMN-LABEL "Vl Parcela" FORMAT ">,>>>,>>>,>>9.99":U WIDTH 10
      ttped-venda.vl-liq-abe COLUMN-LABEL "Vl Aberto" FORMAT ">,>>>,>>>,>>9.99":U WIDTH 10
      fnPesoTotal(ttped-venda.nome-abrev,ttped-venda.nr-pedcli) @ d-peso-tot COLUMN-LABEL "Peso Total" FORMAT ">>>>,>>9.9999" WIDTH 10
      ttped-venda.dt-entrega FORMAT "99/99/9999":U WIDTH 11
      ttped-venda.nome-transp COLUMN-LABEL "Transporte" FORMAT "x(12)":U WIDTH 13
      ttped-venda.nat-operacao COLUMN-LABEL "CFOP" FORMAT "x(6)":U WIDTH 6
      fnTaxa() @ d-taxa COLUMN-LABEL "Tx" FORMAT ">>9.9999":U WIDTH 6
      fnBase() @ i-base COLUMN-LABEL "Car" FORMAT ">>9":U WIDTH 3
      fnorigem() @ c-origem     COLUMN-LABEL "Origem" FORMAT "x(40)" WIDTH 40
      fnmensagem() @ c-mensagem COLUMN-LABEL "Mens. Alocaá∆o Autom." FORMAT "x(2000)"  WIDTH 20      
      ttped-venda.desc-bloq-cr COLUMN-LABEL "Motivo Liberaá∆o/Bloqueio CrÇdito" FORMAT "x(200)" WIDTH 130
      ttped-venda.nome-tr-red  COLUMN-LABEL "Transp Redesp" FORMAT "x(50)" WIDTH 60
      ttped-venda.cond-redespa  COLUMN-LABEL "ID Projeto" FORMAT "x(50)" WIDTH 60
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 162 BY 17
          &ELSE SIZE-PIXELS 1134 BY 408 &ENDIF
         FONT 2 ROW-HEIGHT-CHARS .54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.72 HELP
          "V† Para"
     btQueryJoins AT ROW 1.13 COL 134.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 138.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 142.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 146.57 HELP
          "Ajuda"
     bt-full-screen AT ROW 1.21 COL 85.14 WIDGET-ID 46
     ttAtendente.cd-oper AT ROW 4 COL 12 COLON-ALIGNED
          LABEL "Atendente"
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     ttAtendente.nm-oper AT ROW 4 COL 16.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 34 BY .88
     set-cod-priori-10 AT ROW 4 COL 56 WIDGET-ID 40
     set-orcamento AT ROW 5 COL 56 WIDGET-ID 30
     fi-fob AT ROW 3 COL 119.72 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     fi-incompleto AT ROW 3.92 COL 119.72 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     fi-bloqueado AT ROW 4.75 COL 119.72 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     fi-bloqueado-3 AT ROW 5.5 COL 79 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     "Cliente SUFRAMA" VIEW-AS TEXT
          SIZE 19 BY .75 AT ROW 3 COL 81 WIDGET-ID 4
          FGCOLOR 2 FONT 0
     "Pedidos Normais" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 4 COL 81 WIDGET-ID 6
          FGCOLOR 9 FONT 0
     "Pedidos Vendor/Intelbras Clube" VIEW-AS TEXT
          SIZE 35 BY .75 AT ROW 4.75 COL 81 WIDGET-ID 8
          FGCOLOR 12 FONT 0
     rtToolBar AT Y 0 X 0
     rtParent AT ROW 2.75 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 0 Y 0
         SIZE-PIXELS 1168 BY 623
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT Y 12 X 7 HELP
          "Click na coluna para ordenar"
     bt-limpa-observ AT ROW 18.58 COL 71.14 HELP
          "Limpa Observaá∆o de Lib.Faturamento Autom†tica" WIDGET-ID 12
     btDetail AT ROW 18.71 COL 1.86
     btSaldo AT ROW 18.71 COL 12.43
     btPriori AT ROW 18.71 COL 23 HELP
          "Altera prioridade / atendente"
     btReat AT ROW 18.71 COL 33.72
     bt-espdp054 AT ROW 18.71 COL 114.29 WIDGET-ID 10
     bt-espdp006 AT ROW 18.71 COL 125.29 WIDGET-ID 4
     bt-espdp003 AT ROW 18.71 COL 136.29 WIDGET-ID 6
     bt-transf-dep AT ROW 18.71 COL 147.29 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.14 ROW 7.25
         SIZE 164.86 BY 19.5
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttAtendente T "?" NO-UNDO mgesp atendente
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttped-venda T "?" NO-UNDO mgmov ped-venda
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMasterDetail ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 26.04
         WIDTH              = 168
         MAX-HEIGHT         = 28.13
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.13
         VIRTUAL-WIDTH      = 195.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMasterDetail 
/* ************************* Included-Libraries *********************** */

{masterdetail/masterdetail.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMasterDetail
  NOT-VISIBLE,                                                          */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME 1                                                         */
ASSIGN 
       FRAME fPage0:SELECTABLE       = TRUE.

/* SETTINGS FOR FILL-IN ttAtendente.cd-oper IN FRAME fPage0
   EXP-LABEL                                                            */
ASSIGN 
       fi-bloqueado:READ-ONLY IN FRAME fPage0        = TRUE.

ASSIGN 
       fi-bloqueado-3:READ-ONLY IN FRAME fPage0        = TRUE.

ASSIGN 
       fi-fob:READ-ONLY IN FRAME fPage0        = TRUE.

ASSIGN 
       fi-incompleto:READ-ONLY IN FRAME fPage0        = TRUE.

/* SETTINGS FOR FRAME fPage1
   1                                                                    */
/* BROWSE-TAB brSon1 1 fPage1 */
/* SETTINGS FOR BROWSE brSon1 IN FRAME fPage1
   1                                                                    */
ASSIGN 
       brSon1:MAX-DATA-GUESS IN FRAME fPage1         = 1000
       brSon1:PRIVATE-DATA IN FRAME fPage1           = 
                "Click na coluna para ordenar"
       brSon1:ALLOW-COLUMN-SEARCHING IN FRAME fPage1 = TRUE
       brSon1:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE.

/* SETTINGS FOR BUTTON bt-espdp003 IN FRAME fPage1
   2                                                                    */
/* SETTINGS FOR BUTTON bt-espdp006 IN FRAME fPage1
   2                                                                    */
/* SETTINGS FOR BUTTON bt-espdp054 IN FRAME fPage1
   2                                                                    */
/* SETTINGS FOR BUTTON bt-limpa-observ IN FRAME fPage1
   2                                                                    */
/* SETTINGS FOR BUTTON bt-transf-dep IN FRAME fPage1
   2                                                                    */
/* SETTINGS FOR BUTTON btDetail IN FRAME fPage1
   2                                                                    */
/* SETTINGS FOR BUTTON btPriori IN FRAME fPage1
   2                                                                    */
/* SETTINGS FOR BUTTON btReat IN FRAME fPage1
   2                                                                    */
/* SETTINGS FOR BUTTON btSaldo IN FRAME fPage1
   2                                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
RUN pi-ordena.
IF c-ordena-campo = '' THEN DO:
    IF ttAtendente.cd-oper >= 94 then
        OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
          first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
          EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
          FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
          FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
          FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK
          BY ttped-venda.cod-sit-ped
          BY ttped-venda.cod-sit-aval
          BY ttped-venda.no-ab-reppri
          BY ttped-venda.nome-abrev
          BY ttped-venda.cod-priori.
    ELSE
        OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
          first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
          EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
          FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
          FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
          FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK
          BY ttped-venda.cod-sit-aval
          BY ttped-venda.no-ab-reppri
          BY ttped-venda.nome-abrev
          BY ttped-venda.cod-priori.
END.
ELSE DO:
    IF c-ordena-campo = "c-descsit" THEN DO:
        IF l-parametro  THEN
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-sit-aval
            .
        ELSE
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-sit-aval DESCENDING
            .
    END.
    IF c-ordena-campo = "c-sit" THEN DO:
        IF l-parametro  THEN
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-sit-ped
            .
        ELSE
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-sit-ped DESCENDING
            .
    END.
    IF c-ordena-campo = "cod-priori" THEN DO:
        IF l-parametro  THEN
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-priori
            .
        ELSE
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-priori DESCENDING
            .
    END.
    IF c-ordena-campo = "cod-emitente" THEN DO:
        IF l-parametro  THEN
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-emitente
            .
        ELSE
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-emitente DESCENDING
            .
    END.
    IF c-ordena-campo = "nome-abrev" THEN DO:
        IF l-parametro  THEN
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.nome-abrev
            .
        ELSE
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.nome-abrev DESCENDING
            .
    END.
    IF c-ordena-campo = "cod-gr-cli" THEN DO:
        IF l-parametro  THEN
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-gr-cli
            .
        ELSE
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-gr-cli DESCENDING
            .
    END.
    IF c-ordena-campo = "no-ab-reppri" THEN DO:
        IF l-parametro  THEN
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.no-ab-reppri
            .
        ELSE
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.no-ab-reppri DESCENDING
            .
    END.
    IF c-ordena-campo = "nr-pedcli" THEN DO:
        IF l-parametro  THEN
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.nr-pedcli
            .
        ELSE
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.nr-pedcli DESCENDING
            .
    END.
    IF c-ordena-campo = "vl-liq-abe" THEN DO:
        IF l-parametro  THEN
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.vl-liq-abe
            .
        ELSE
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.vl-liq-abe DESCENDING
            .
    END.
    IF c-ordena-campo = "dt-entrega" THEN DO:
        IF l-parametro  THEN
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.dt-entrega
            .
        ELSE
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.dt-entrega DESCENDING
            .
    END.
    IF c-ordena-campo = "nome-transp" THEN DO:
        IF l-parametro  THEN
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.nome-transp
            .
        ELSE
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.nome-transp DESCENDING
            .
    END.
    IF c-ordena-campo = "i-cond" THEN DO:
        IF l-parametro  THEN
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-cond-pag
            .
        ELSE
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.cod-cond-pag DESCENDING
            .
    END.
    IF c-ordena-campo = "d-parc" THEN DO:
        IF l-parametro  THEN
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.vl-liq-abe
            .
        ELSE
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.vl-liq-abe DESCENDING
            .
    END.
    IF c-ordena-campo = "estado" THEN DO:
        IF l-parametro  THEN
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.estado
            .
        ELSE
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.estado DESCENDING
            .
    END.
    IF c-ordena-campo = "desc-bloq-cr" THEN DO:
        IF l-parametro  THEN
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.desc-bloq-cr.

        ELSE
            OPEN QUERY {&SELF-NAME} FOR EACH ttped-venda NO-LOCK,
              first int-ped-venda where int-ped-venda.nr-pedido = ttped-venda.nr-pedido and int-ped-venda.cod-estabel = ttped-venda.cod-estabel OUTER-JOIN NO-LOCK,
              EACH pd-vendor OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST int-cond-pagto OF ttped-venda OUTER-JOIN NO-LOCK,
              FIRST emitente WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-LOCK BY ttped-venda.desc-bloq-cr DESCENDING.

    END.



                                                                                                                                                                                                                        END.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-MAXIMIZED OF wMasterDetail
DO:
    
      ASSIGN FRAME fPage0:WIDTH          = CURRENT-WINDOW:WIDTH
             FRAME fPage0:HEIGHT         = CURRENT-WINDOW:HEIGHT
             FRAME fPage0:WIDTH-CHARS    = CURRENT-WINDOW:WIDTH-CHARS
             FRAME fPage0:HEIGHT-CHARS   = CURRENT-WINDOW:HEIGHT-CHARS
             FRAME fPage0:VIRTUAL-WIDTH  = FRAME fPage0:WIDTH
             FRAME fPage0:VIRTUAL-HEIGHT = FRAME fPage0:HEIGHT
             deWidthDif                  = CURRENT-WINDOW:WIDTH - deWidth
             deHeightDif                 = CURRENT-WINDOW:HEIGHT - deHeight.

    /*
    ASSIGN vCodEstabel:COLUMN                     IN FRAME fPage0 = vCodEstabel:COLUMN                     IN FRAME fPage0 + (deWidthDif / 2)
           vCodEstabel:SIDE-LABEL-HANDLE:COLUMN   IN FRAME fPage0 = vCodEstabel:SIDE-LABEL-HANDLE:COLUMN   IN FRAME fPage0 + (deWidthDif / 2)
           vCodUnidNegoc:COLUMN                   IN FRAME fPage0 = vCodUnidNegoc:COLUMN                   IN FRAME fPage0 + (deWidthDif / 2)
           vCodUnidNegoc:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 = vCodUnidNegoc:SIDE-LABEL-HANDLE:COLUMN IN FRAME fPage0 + (deWidthDif / 2)
           vPeriodoIni:COLUMN                     IN FRAME fPage0 = vPeriodoIni:COLUMN                     IN FRAME fPage0 + (deWidthDif / 2)
           vPeriodoIni:SIDE-LABEL-HANDLE:COLUMN   IN FRAME fPage0 = vPeriodoIni:SIDE-LABEL-HANDLE:COLUMN   IN FRAME fPage0 + (deWidthDif / 2)
           IMAGE-1:COLUMN                         IN FRAME fPage0 = IMAGE-1:COLUMN                         IN FRAME fPage0 + (deWidthDif / 2)
           IMAGE-2:COLUMN                         IN FRAME fPage0 = IMAGE-2:COLUMN                         IN FRAME fPage0 + (deWidthDif / 2)
           vPeriodoFin:COLUMN                     IN FRAME fPage0 = vPeriodoFin:COLUMN                     IN FRAME fPage0 + (deWidthDif / 2)
           vDiasMes:COLUMN                        IN FRAME fPage0 = vDiasMes:COLUMN                        IN FRAME fPage0 + (deWidthDif / 2)
           vDiasMes:SIDE-LABEL-HANDLE:COLUMN      IN FRAME fPage0 = vDiasMes:SIDE-LABEL-HANDLE:COLUMN      IN FRAME fPage0 + (deWidthDif / 2)
           btFil:COLUMN                           IN FRAME fPage0 = btFil:COLUMN                           IN FRAME fPage0 +  deWidthDif
           btExit:COLUMN                          IN FRAME fPage0 = btExit:COLUMN                          IN FRAME fPage0 +  deWidthDif
           RECT-11:WIDTH                          IN FRAME fPage0 = RECT-11:WIDTH                          IN FRAME fPage0 +  deWidthDif
           brEstoque:WIDTH                        IN FRAME fPage0 = brEstoque:WIDTH                        IN FRAME fPage0 +  deWidthDif
           brEstoque:HEIGHT                       IN FRAME fPage0 = brEstoque:HEIGHT                       IN FRAME fPage0 +  deHeightDif.
           */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON ALT-CURSOR-DOWN OF brSon1 IN FRAME fPage1
DO:
    brSon1:SELECT-NEXT-ROW() NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON ALT-CURSOR-UP OF brSon1 IN FRAME fPage1
DO:
    brSon1:SELECT-PREV-ROW() NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON MOUSE-SELECT-DBLCLICK OF brSon1 IN FRAME fPage1
DO:
  APPLY "choose" TO btDetail IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON RETURN OF brSon1 IN FRAME fPage1
DO:
  APPLY "choose" TO btDetail IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON ROW-DISPLAY OF brSon1 IN FRAME fPage1
DO:
   FIND FIRST emitente NO-LOCK
      WHERE emitente.nome-abrev = ttped-venda.nome-abrev NO-ERROR.
    FIND FIRST int-cond-pagto NO-LOCK
        WHERE  int-cond-pagto.cod-cond-pag = ttped-venda.cod-cond-pag NO-ERROR.
    ASSIGN l-suframa = (emitente.cod-suframa <> "").

    ASSIGN c-descsit:BGCOLOR                IN BROWSE brSon1 = ?
           ttped-venda.cod-priori:BGCOLOR   IN BROWSE brSon1 = ?
           ttped-venda.cod-emitente:BGCOLOR IN BROWSE brSon1 = ?
           ttped-venda.nome-abrev:BGCOLOR   IN BROWSE brSon1 = ?
           ttped-venda.estado:BGCOLOR       IN BROWSE brSon1 = ?
           c-cat:BGCOLOR                    IN BROWSE brSon1 = ?
           ttped-venda.cod-gr-cli:BGCOLOR   IN BROWSE brSon1 = ?
           ttped-venda.no-ab-reppri:BGCOLOR IN BROWSE brSon1 = ?
           ttped-venda.cod-estabel:BGCOLOR  IN BROWSE brSon1 = ?
           ttped-venda.nr-pedcli:BGCOLOR    IN BROWSE brSon1 = ?
           i-cond:BGCOLOR                   IN BROWSE brSon1 = ?
           d-peso-tot:BGCOLOR               IN BROWSE brSon1 = ?
           i-parc:BGCOLOR                   IN BROWSE brSon1 = ?
           d-parc:BGCOLOR                   IN BROWSE brSon1 = ?
           ttped-venda.vl-liq-abe:BGCOLOR   IN BROWSE brSon1 = ?
           d-taxa:BGCOLOR                   IN BROWSE brSon1 = ?
           i-base:BGCOLOR                   IN BROWSE brSon1 = ?
           ttped-venda.dt-entrega:BGCOLOR   IN BROWSE brSon1 = ?
           ttped-venda.nome-transp:BGCOLOR  IN BROWSE brSon1 = ?
           ttped-venda.nat-operacao:BGCOLOR IN BROWSE brSon1 = ?
           c-sit:BGCOLOR                    IN BROWSE brSon1 = ?
           c-origem:BGCOLOR                 IN BROWSE brSon1 = ?
           c-mensagem:BGCOLOR               IN BROWSE brSon1 = ?
           ttped-venda.desc-bloq-cr:BGCOLOR IN BROWSE brSon1 = ?
           ttped-venda.nome-tr-red:BGCOLOR  IN BROWSE brSon1 = ?.

    ASSIGN c-descsit:FGCOLOR                IN BROWSE brSon1 = 9
           ttped-venda.cod-priori:FGCOLOR   IN BROWSE brSon1 = 9
           ttped-venda.cod-emitente:FGCOLOR IN BROWSE brSon1 = 9
           ttped-venda.nome-abrev:FGCOLOR   IN BROWSE brSon1 = 9
           d-peso-tot:FGCOLOR               IN BROWSE brSon1 = 9
           ttped-venda.estado:FGCOLOR       IN BROWSE brSon1 = 9
           c-cat:FGCOLOR                    IN BROWSE brSon1 = 9
           ttped-venda.cod-gr-cli:FGCOLOR   IN BROWSE brSon1 = 9
           ttped-venda.no-ab-reppri:FGCOLOR IN BROWSE brSon1 = 9
           ttped-venda.cod-estabel:FGCOLOR  IN BROWSE brSon1 = 9
           ttped-venda.nr-pedcli:FGCOLOR    IN BROWSE brSon1 = 9
           i-cond:FGCOLOR                   IN BROWSE brSon1 = 9
           i-parc:FGCOLOR                   IN BROWSE brSon1 = 9
           d-parc:FGCOLOR                   IN BROWSE brSon1 = 9
           ttped-venda.vl-liq-abe:FGCOLOR   IN BROWSE brSon1 = 9
           d-taxa:FGCOLOR                   IN BROWSE brSon1 = 9
           i-base:FGCOLOR                   IN BROWSE brSon1 = 9
           ttped-venda.dt-entrega:FGCOLOR   IN BROWSE brSon1 = 9
           ttped-venda.nome-transp:FGCOLOR  IN BROWSE brSon1 = 9
           ttped-venda.nat-operacao:FGCOLOR IN BROWSE brSon1 = 9          
           c-sit:FGCOLOR                    IN BROWSE brSon1 = 9
           c-origem:FGCOLOR                 IN BROWSE brSon1 = 9
           c-mensagem:FGCOLOR               IN BROWSE brSon1 = 9
           ttped-venda.desc-bloq-cr:FGCOLOR IN BROWSE brSon1 = 9
           ttped-venda.nome-tr-red:FGCOLOR IN BROWSE  brSon1 = 9.

    IF ttped-venda.completo = NO  THEN /* Linha azul escuro com letras brancas */
        ASSIGN c-descsit:BGCOLOR                IN BROWSE brSon1 = 1
               ttped-venda.cod-priori:BGCOLOR   IN BROWSE brSon1 = 1
               ttped-venda.cod-emitente:BGCOLOR IN BROWSE brSon1 = 1
               ttped-venda.nome-abrev:BGCOLOR   IN BROWSE brSon1 = 1
               ttped-venda.estado:BGCOLOR       IN BROWSE brSon1 = 1
               d-peso-tot:BGCOLOR               IN BROWSE brSon1 = 1
               ttped-venda.cod-gr-cli:BGCOLOR   IN BROWSE brSon1 = 1
               c-cat:BGCOLOR                    IN BROWSE brSon1 = 1
               ttped-venda.no-ab-reppri:BGCOLOR IN BROWSE brSon1 = 1
               ttped-venda.cod-estabel:BGCOLOR  IN BROWSE brSon1 = 1
               ttped-venda.nr-pedcli:BGCOLOR    IN BROWSE brSon1 = 1
               i-cond:BGCOLOR                   IN BROWSE brSon1 = 1
               i-parc:BGCOLOR                   IN BROWSE brSon1 = 1
               d-parc:BGCOLOR                   IN BROWSE brSon1 = 1
               ttped-venda.vl-liq-abe:BGCOLOR   IN BROWSE brSon1 = 1
               d-taxa:BGCOLOR                   IN BROWSE brSon1 = 1
               i-base:BGCOLOR                   IN BROWSE brSon1 = 1
               ttped-venda.dt-entrega:BGCOLOR   IN BROWSE brSon1 = 1
               ttped-venda.nome-transp:BGCOLOR  IN BROWSE brSon1 = 1
               ttped-venda.nat-operacao:BGCOLOR IN BROWSE brSon1 = 1
               c-sit:BGCOLOR                    IN BROWSE brSon1 = 1
               c-origem:BGCOLOR                 IN BROWSE brSon1 = 1
               c-mensagem:BGCOLOR               IN BROWSE brSon1 = 1
               ttped-venda.desc-bloq-cr:BGCOLOR IN BROWSE brSon1 = 1
               ttped-venda.nome-tr-red:BGCOLOR  IN BROWSE brSon1 = 1

               c-descsit:FGCOLOR                IN BROWSE brSon1 = 15
               ttped-venda.cod-priori:FGCOLOR   IN BROWSE brSon1 = 15
               ttped-venda.cod-emitente:FGCOLOR IN BROWSE brSon1 = 15
               ttped-venda.nome-abrev:FGCOLOR   IN BROWSE brSon1 = 15
               ttped-venda.estado:FGCOLOR       IN BROWSE brSon1 = 15
               d-peso-tot:FGCOLOR               IN BROWSE brSon1 = 15
               c-cat:FGCOLOR                    IN BROWSE brSon1 = 15
               ttped-venda.cod-gr-cli:FGCOLOR   IN BROWSE brSon1 = 15
               ttped-venda.no-ab-reppri:FGCOLOR IN BROWSE brSon1 = 15
               ttped-venda.cod-estabel:FGCOLOR  IN BROWSE brSon1 = 15
               ttped-venda.nr-pedcli:FGCOLOR    IN BROWSE brSon1 = 15
               i-cond:FGCOLOR                   IN BROWSE brSon1 = 15
               i-parc:FGCOLOR                   IN BROWSE brSon1 = 15
               d-parc:FGCOLOR                   IN BROWSE brSon1 = 15
               ttped-venda.vl-liq-abe:FGCOLOR   IN BROWSE brSon1 = 15
               d-taxa:FGCOLOR                   IN BROWSE brSon1 = 15
               i-base:FGCOLOR                   IN BROWSE brSon1 = 15
               ttped-venda.dt-entrega:FGCOLOR   IN BROWSE brSon1 = 15
               ttped-venda.nome-transp:FGCOLOR  IN BROWSE brSon1 = 15
               ttped-venda.nat-operacao:FGCOLOR IN BROWSE brSon1 = 15
               c-sit:FGCOLOR                    IN BROWSE brSon1 = 15
               c-origem:FGCOLOR                 IN BROWSE brSon1 = 15
               c-mensagem:FGCOLOR               IN BROWSE brSon1 = 15
               ttped-venda.desc-bloq-cr:FGCOLOR IN BROWSE brSon1 = 15
               ttped-venda.nome-tr-red:FGCOLOR  IN BROWSE brSon1 = 15.
                                                                   
/*     ELSE                                                                   */
/*         if ttped-venda.cod-sit-aval = 3 AND                                */
/*            ttped-venda.dt-entrega   < today and                            */
/*            ttped-venda.cod-sit-ped <> 3 then                               */
/*                                                                            */
/*             ASSIGN c-descsit:FGCOLOR                IN BROWSE brSon1 = 13  */
/*                    ttped-venda.cod-priori:FGCOLOR   IN BROWSE brSon1 = 13  */
/*                    ttped-venda.cod-emitente:FGCOLOR IN BROWSE brSon1 = 13  */
/*                    ttped-venda.nome-abrev:FGCOLOR   IN BROWSE brSon1 = 13  */
/*                    ttped-venda.estado:FGCOLOR       IN BROWSE brSon1 = 13  */
/*                    c-cat:FGCOLOR                    IN BROWSE brSon1 = 13  */
/*                    ttped-venda.cod-gr-cli:FGCOLOR   IN BROWSE brSon1 = 13  */
/*                    ttped-venda.no-ab-reppri:FGCOLOR IN BROWSE brSon1 = 13  */
/*                    ttped-venda.nr-pedcli:FGCOLOR    IN BROWSE brSon1 = 13  */
/*                    i-cond:FGCOLOR                   IN BROWSE brSon1 = 13  */
/*                    i-parc:FGCOLOR                   IN BROWSE brSon1 = 13  */
/*                    d-parc:FGCOLOR                   IN BROWSE brSon1 = 13  */
/*                    ttped-venda.vl-liq-abe:FGCOLOR   IN BROWSE brSon1 = 13  */
/*                    d-taxa:FGCOLOR                   IN BROWSE brSon1 = 13  */
/*                    i-base:FGCOLOR                   IN BROWSE brSon1 = 13  */
/*                    ttped-venda.dt-entrega:FGCOLOR   IN BROWSE brSon1 = 13  */
/*                    ttped-venda.nome-transp:FGCOLOR  IN BROWSE brSon1 = 13  */
/*                    ttped-venda.nat-operacao:FGCOLOR IN BROWSE brSon1 = 13  */
/*                    c-sit:FGCOLOR                    IN BROWSE brSon1 = 13  */
/*                    c-origem:FGCOLOR                 IN BROWSE brSon1 = 13  */
/*                    c-mensagem:FGCOLOR               IN BROWSE brSon1 = 13  */
/*                    ttped-venda.desc-bloq-cr:FGCOLOR IN BROWSE brSon1 = 13. */
        ELSE 
            /* Se for VENDOR ou pedido da SupplierCard (Intelbras Clube), deixa a linha em vermelho */
            IF  AVAIL pd-vendor OR
                (AVAIL int-cond-pagto AND SUBSTRING(int-cond-pagto.char-1,4,1) = "S") THEN
                ASSIGN c-descsit:FGCOLOR                IN BROWSE brSon1 = 12
                       ttped-venda.cod-priori:FGCOLOR   IN BROWSE brSon1 = 12
                       ttped-venda.cod-emitente:FGCOLOR IN BROWSE brSon1 = (IF l-suframa THEN 2 ELSE 12)
                       ttped-venda.nome-abrev:FGCOLOR   IN BROWSE brSon1 = (IF l-suframa THEN 2 ELSE 12)
                       ttped-venda.estado:FGCOLOR       IN BROWSE brSon1 = (IF l-suframa THEN 2 ELSE 12) 
                       c-cat:FGCOLOR                    IN BROWSE brSon1 = 12
                       d-peso-tot:FGCOLOR               IN BROWSE brSon1 = 12
                       ttped-venda.cod-gr-cli:FGCOLOR   IN BROWSE brSon1 = 12
                       ttped-venda.no-ab-reppri:FGCOLOR IN BROWSE brSon1 = 12
                       ttped-venda.cod-estabel:FGCOLOR  IN BROWSE brSon1 = 12
                       ttped-venda.nr-pedcli:FGCOLOR    IN BROWSE brSon1 = 12
                       i-cond:FGCOLOR                   IN BROWSE brSon1 = 12
                       i-parc:FGCOLOR                   IN BROWSE brSon1 = 12
                       d-parc:FGCOLOR                   IN BROWSE brSon1 = 12
                       ttped-venda.vl-liq-abe:FGCOLOR   IN BROWSE brSon1 = 12
                       d-taxa:FGCOLOR                   IN BROWSE brSon1 = 12
                       i-base:FGCOLOR                   IN BROWSE brSon1 = 12
                       ttped-venda.dt-entrega:FGCOLOR   IN BROWSE brSon1 = 12
                       ttped-venda.nome-transp:FGCOLOR  IN BROWSE brSon1 = 12
                       ttped-venda.nat-operacao:FGCOLOR IN BROWSE brSon1 = 12
                       c-sit:FGCOLOR                    IN BROWSE brSon1 = 12
                       c-origem:FGCOLOR                 IN BROWSE brSon1 = 12
                       c-mensagem:FGCOLOR               IN BROWSE brSon1 = 12
                       ttped-venda.desc-bloq-cr:FGCOLOR IN BROWSE brSon1 = 12
                       ttped-venda.nome-tr-red:FGCOLOR  IN BROWSE brSon1 = 12.
            ELSE IF l-suframa THEN
                    ASSIGN c-descsit:FGCOLOR                IN BROWSE brSon1 = 2
                           ttped-venda.cod-priori:FGCOLOR   IN BROWSE brSon1 = 2
                           ttped-venda.cod-emitente:FGCOLOR IN BROWSE brSon1 = 2
                           ttped-venda.nome-abrev:FGCOLOR   IN BROWSE brSon1 = 2
                           ttped-venda.estado:FGCOLOR       IN BROWSE brSon1 = 2 
                           c-cat:FGCOLOR                    IN BROWSE brSon1 = 2
                           d-peso-tot:FGCOLOR               IN BROWSE brSon1 = 2
                           ttped-venda.cod-gr-cli:FGCOLOR   IN BROWSE brSon1 = 2
                           ttped-venda.no-ab-reppri:FGCOLOR IN BROWSE brSon1 = 2
                           ttped-venda.cod-estabel:FGCOLOR  IN BROWSE brSon1 = 2
                           ttped-venda.nr-pedcli:FGCOLOR    IN BROWSE brSon1 = 2
                           i-cond:FGCOLOR                   IN BROWSE brSon1 = 2
                           i-parc:FGCOLOR                   IN BROWSE brSon1 = 2
                           d-parc:FGCOLOR                   IN BROWSE brSon1 = 2
                           ttped-venda.vl-liq-abe:FGCOLOR   IN BROWSE brSon1 = 2
                           d-taxa:FGCOLOR                   IN BROWSE brSon1 = 2
                           i-base:FGCOLOR                   IN BROWSE brSon1 = 2
                           ttped-venda.dt-entrega:FGCOLOR   IN BROWSE brSon1 = 2
                           ttped-venda.nome-transp:FGCOLOR  IN BROWSE brSon1 = 2
                           ttped-venda.nat-operacao:FGCOLOR IN BROWSE brSon1 = 2
                           c-sit:FGCOLOR                    IN BROWSE brSon1 = 2
                           c-origem:FGCOLOR                 IN BROWSE brSon1 = 2
                           c-mensagem:FGCOLOR               IN BROWSE brSon1 = 2
                           ttped-venda.desc-bloq-cr:FGCOLOR IN BROWSE brSon1 = 2
                           ttped-venda.nome-tr-red:FGCOLOR  IN BROWSE brSon1 = 2.
                ELSE
                    IF  ttped-venda.cidade-cif = "":U THEN
                        ASSIGN c-descsit:BGCOLOR                IN BROWSE brSon1 = 14
                               ttped-venda.cod-priori:BGCOLOR   IN BROWSE brSon1 = 14
                               ttped-venda.cod-emitente:BGCOLOR IN BROWSE brSon1 = 14
                               ttped-venda.nome-abrev:BGCOLOR   IN BROWSE brSon1 = 14
                               ttped-venda.estado:BGCOLOR       IN BROWSE brSon1 = 14
                               c-cat:BGCOLOR                    IN BROWSE brSon1 = 14
                               ttped-venda.cod-gr-cli:BGCOLOR   IN BROWSE brSon1 = 14
                               ttped-venda.no-ab-reppri:BGCOLOR IN BROWSE brSon1 = 14
                               ttped-venda.cod-estabel:BGCOLOR  IN BROWSE brSon1 = 14
                               ttped-venda.nr-pedcli:BGCOLOR    IN BROWSE brSon1 = 14
                               i-cond:BGCOLOR                   IN BROWSE brSon1 = 14
                               d-peso-tot:BGCOLOR               IN BROWSE brSon1 = 14
                               i-parc:BGCOLOR                   IN BROWSE brSon1 = 14
                               d-parc:BGCOLOR                   IN BROWSE brSon1 = 14
                               ttped-venda.vl-liq-abe:BGCOLOR   IN BROWSE brSon1 = 14
                               d-taxa:BGCOLOR                   IN BROWSE brSon1 = 14
                               i-base:BGCOLOR                   IN BROWSE brSon1 = 14
                               ttped-venda.dt-entrega:BGCOLOR   IN BROWSE brSon1 = 14
                               ttped-venda.nome-transp:BGCOLOR  IN BROWSE brSon1 = 14
                               ttped-venda.nat-operacao:BGCOLOR IN BROWSE brSon1 = 14
                               c-sit:BGCOLOR                    IN BROWSE brSon1 = 14
                               c-origem:BGCOLOR                 IN BROWSE brSon1 = 14
                               c-mensagem:BGCOLOR               IN BROWSE brSon1 = 14
                               ttped-venda.desc-bloq-cr:BGCOLOR IN BROWSE brSon1 = 14
                               ttped-venda.nome-tr-red:BGCOLOR  IN BROWSE brson1 = 14.

    
    DEF VAR l-bloqueado AS LOGICAL INIT NO NO-UNDO.

    FOR EACH ped-item
        OF ttped-venda NO-LOCK:

        IF CAN-FIND(FIRST int-ped-item NO-LOCK
                        WHERE int-ped-item.nome-abrev   = ped-item.nome-abrev
                          AND int-ped-item.nr-pedcli    = ped-item.nr-pedcli
                          AND int-ped-item.nr-sequencia = ped-item.nr-sequencia
                          AND int-ped-item.it-codigo    = ped-item.it-codigo
                          AND int-ped-item.cod-refer    = ped-item.cod-refer
                          AND (int-ped-item.ind-status-preco = 1 OR int-ped-item.ind-status-preco = 3)) THEN
              ASSIGN l-bloqueado = YES.

    END.

    IF  l-bloqueado THEN DO:

        ASSIGN c-descsit:BGCOLOR                IN BROWSE brSon1 = 2
               ttped-venda.cod-priori:BGCOLOR   IN BROWSE brSon1 = 2
               ttped-venda.cod-emitente:BGCOLOR IN BROWSE brSon1 = 2
               ttped-venda.nome-abrev:BGCOLOR   IN BROWSE brSon1 = 2
               ttped-venda.estado:BGCOLOR       IN BROWSE brSon1 = 2
               ttped-venda.cod-gr-cli:BGCOLOR   IN BROWSE brSon1 = 2
               c-cat:BGCOLOR                    IN BROWSE brSon1 = 2
               d-peso-tot:BGCOLOR               IN BROWSE brSon1 = 2
               ttped-venda.no-ab-reppri:BGCOLOR IN BROWSE brSon1 = 2
               ttped-venda.cod-estabel:BGCOLOR  IN BROWSE brSon1 = 2
               ttped-venda.nr-pedcli:BGCOLOR    IN BROWSE brSon1 = 2
               i-cond:BGCOLOR                   IN BROWSE brSon1 = 2
               i-parc:BGCOLOR                   IN BROWSE brSon1 = 2
               d-parc:BGCOLOR                   IN BROWSE brSon1 = 2
               ttped-venda.vl-liq-abe:BGCOLOR   IN BROWSE brSon1 = 2
               d-taxa:BGCOLOR                   IN BROWSE brSon1 = 2
               i-base:BGCOLOR                   IN BROWSE brSon1 = 2
               ttped-venda.dt-entrega:BGCOLOR   IN BROWSE brSon1 = 2
               ttped-venda.nome-transp:BGCOLOR  IN BROWSE brSon1 = 2
               ttped-venda.nat-operacao:BGCOLOR IN BROWSE brSon1 = 2
               c-sit:BGCOLOR                    IN BROWSE brSon1 = 2
               c-origem:BGCOLOR                 IN BROWSE brSon1 = 2
               c-mensagem:BGCOLOR               IN BROWSE brSon1 = 2
               ttped-venda.desc-bloq-cr:BGCOLOR IN BROWSE brSon1 = 2
               ttped-venda.nome-tr-red:BGCOLOR  IN BROWSE brSon1 = 2.

        ASSIGN c-descsit:FGCOLOR                IN BROWSE brSon1 = 15
               ttped-venda.cod-priori:FGCOLOR   IN BROWSE brSon1 = 15
               ttped-venda.cod-emitente:FGCOLOR IN BROWSE brSon1 = 15
               ttped-venda.nome-abrev:FGCOLOR   IN BROWSE brSon1 = 15
               ttped-venda.estado:FGCOLOR       IN BROWSE brSon1 = 15
               c-cat:FGCOLOR                    IN BROWSE brSon1 = 15
               d-peso-tot:FGCOLOR               IN BROWSE brSon1 = 15
               ttped-venda.cod-gr-cli:FGCOLOR   IN BROWSE brSon1 = 15
               ttped-venda.no-ab-reppri:FGCOLOR IN BROWSE brSon1 = 15
               ttped-venda.cod-estabel:FGCOLOR  IN BROWSE brSon1 = 15
               ttped-venda.nr-pedcli:FGCOLOR    IN BROWSE brSon1 = 15
               i-cond:FGCOLOR                   IN BROWSE brSon1 = 15
               i-parc:FGCOLOR                   IN BROWSE brSon1 = 15
               d-parc:FGCOLOR                   IN BROWSE brSon1 = 15
               ttped-venda.vl-liq-abe:FGCOLOR   IN BROWSE brSon1 = 15
               d-taxa:FGCOLOR                   IN BROWSE brSon1 = 15
               i-base:FGCOLOR                   IN BROWSE brSon1 = 15
               ttped-venda.dt-entrega:FGCOLOR   IN BROWSE brSon1 = 15
               ttped-venda.nome-transp:FGCOLOR  IN BROWSE brSon1 = 15
               ttped-venda.nat-operacao:FGCOLOR IN BROWSE brSon1 = 15
               c-sit:FGCOLOR                    IN BROWSE brSon1 = 15
               c-origem:FGCOLOR                 IN BROWSE brSon1 = 15
               c-mensagem:FGCOLOR               IN BROWSE brSon1 = 15
               ttped-venda.desc-bloq-cr:FGCOLOR IN BROWSE brSon1 = 15
               ttped-venda.nome-tr-red:FGCOLOR  IN BROWSE brSon1 = 15.
  
    END.
    IF ttped-venda.tp-pedido <> "21" AND 
       ttped-venda.tp-pedido <> "22" AND
       ttped-venda.tp-pedido <> "23" AND
       ttped-venda.tp-pedido <> "24" AND
       ttped-venda.tp-pedido <> "18" AND
       ttped-venda.tp-pedido <> "80" THEN
       RUN pi-valida-transportadora.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON START-SEARCH OF brSon1 IN FRAME fPage1
DO:
   /* DEFINE VARIABLE h-coluna AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-coluna AS CHARACTER   NO-UNDO.

    ASSIGN h-coluna = br-alternativo:CURRENT-COLUMN
           c-coluna = h-coluna:NAME.
    {&open-query-brson1}*/

    {&open-query-brson1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-espdp003
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-espdp003 wMasterDetail
ON CHOOSE OF bt-espdp003 IN FRAME fPage1 /* ESPDP003 */
DO:
    IF AVAIL ttPed-venda THEN DO:
        ASSIGN gr-ped-venda = ttped-venda.r-rowid.
        FIND ped-venda
             WHERE ROWID(ped-venda) = gr-ped-venda.
        RUN esp/pdp/espdp003.w.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-espdp006
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-espdp006 wMasterDetail
ON CHOOSE OF bt-espdp006 IN FRAME fPage1 /* ESPDP006 */
DO:
    IF AVAIL ttPed-venda THEN DO:

        ASSIGN gr-ped-venda  = ttped-venda.r-rowid
               r-rowid-atual = ttped-venda.r-rowid.
        RUN esp/pdp/espdp006.w.
        
        brSon1:SELECT-NEXT-ROW().

        IF r-rowid-atual = ttped-venda.r-rowid THEN
            brSon1:SELECT-PREV-ROW().

        ASSIGN r-proximo-rowid = ttped-venda.r-rowid.

        IF r-rowid-atual = ttped-venda.r-rowid THEN
            ASSIGN r-proximo-rowid = ?.

        ASSIGN r-rowid-atual = ?.

        ASSIGN gr-ped-venda = ?.

        RUN afterdisplayFields.

        FIND FIRST ttped-venda
            WHERE ttped-venda.r-rowid = r-proximo-rowid NO-LOCK NO-ERROR.

        IF AVAILABLE ttped-venda THEN
            REPOSITION brSon1 TO ROWID ROWID(ttped-venda).

        ASSIGN r-proximo-rowid = ?.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-espdp054
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-espdp054 wMasterDetail
ON CHOOSE OF bt-espdp054 IN FRAME fPage1 /* ESPDP054 */
DO:
    IF AVAIL ttped-venda THEN DO:
        FIND FIRST ped-item OF ttped-venda NO-LOCK NO-ERROR.

        IF AVAIL ped-item THEN DO:
            IF NOT VALID-HANDLE(h-espdp045) THEN
                RUN esp/pdp/espdp054.w PERSISTENT SET h-espdp045.
    
            IF VALID-HANDLE(h-espdp045) THEN DO:
                RUN initializeInterface IN h-espdp045.
                
                RUN pi-reposiona IN h-espdp045 (INPUT ROWID(ped-item)).            
    
                WAIT-FOR CLOSE OF h-espdp045.        
            END.
        END.
        ELSE
            RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                               INPUT 5919, 
                               INPUT STRING(ttped-venda.nr-pedcli)).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME bt-full-screen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-full-screen wMasterDetail
ON CHOOSE OF bt-full-screen IN FRAME fPage0 /* Maximizar */
DO:
    IF  l-ampliou = NO THEN
        l-ampliou = YES.
    ELSE
        l-ampliou = NO.
    
    RUN pi-fullscreen.
    
    /*Maximizou*/
    IF  l-ampliou THEN DO:
        ASSIGN de-dif-largura = {&WINDOW-NAME}:WIDTH  - window_largura_ini 
               de-dif-altura  = {&WINDOW-NAME}:HEIGHT - window_altura_ini 
               h_fpage0:WIDTH                  = fpage0_largura_ini    + de-dif-largura
               h_fpage0:HEIGHT                 = fpage0_altura_ini     + de-dif-altura 
               h_fpage1:WIDTH                  = fpage1_largura_ini    + de-dif-largura
               h_fpage1:HEIGHT                 = fpage1_altura_ini     + de-dif-altura 
               brSon1:WIDTH  IN FRAME fpage1   = brson1_largura_ini    + de-dif-largura
               brSon1:HEIGHT IN FRAME fpage1   = brson1_altura_ini     + de-dif-altura 
               rtParent:WIDTH IN FRAME fpage0  = rtParent_largura_ini  + de-dif-largura
               rtToolBar:WIDTH IN FRAME fpage0 = rtToolBar_largura_ini + de-dif-largura.
              
    END.
    ELSE DO: /* Voltou ao tamanho original */
        ASSIGN de-dif-largura  = 0   
               de-dif-altura   = 0 
               {&WINDOW-NAME}:WIDTH            = window_largura_ini            
               {&WINDOW-NAME}:HEIGHT           = window_altura_ini
               brSon1:WIDTH  IN FRAME fpage1   = brson1_largura_ini              
               brSon1:HEIGHT IN FRAME fpage1   = brson1_altura_ini     
               rtParent:WIDTH IN FRAME fpage0  = rtParent_largura_ini
               rtToolBar:WIDTH IN FRAME fpage0 = rtToolBar_largura_ini.    
    END.              
 
    ASSIGN btDetail:ROW IN FRAME fpage1        = brSon1:ROW IN FRAME fpage1 + brSon1:HEIGHT IN FRAME fpage1 + .05.
           btSaldo:ROW IN FRAME fpage1         = brSon1:ROW IN FRAME fpage1 + brSon1:HEIGHT IN FRAME fpage1 + .05.
           btPriori:ROW IN FRAME fpage1        = brSon1:ROW IN FRAME fpage1 + brSon1:HEIGHT IN FRAME fpage1 + .05.
           btReat:ROW IN FRAME fpage1          = brSon1:ROW IN FRAME fpage1 + brSon1:HEIGHT IN FRAME fpage1 + .05.
           bt-limpa-observ:ROW IN FRAME fpage1 = brSon1:ROW IN FRAME fpage1 + brSon1:HEIGHT IN FRAME fpage1 + .05.
           bt-espdp054:ROW IN FRAME fpage1     = brSon1:ROW IN FRAME fpage1 + brSon1:HEIGHT IN FRAME fpage1 + .05.
           bt-espdp006:ROW IN FRAME fpage1     = brSon1:ROW IN FRAME fpage1 + brSon1:HEIGHT IN FRAME fpage1 + .05.
           bt-espdp003:ROW IN FRAME fpage1     = brSon1:ROW IN FRAME fpage1 + brSon1:HEIGHT IN FRAME fpage1 + .05.
           bt-transf-dep:ROW IN FRAME fpage1   = brSon1:ROW IN FRAME fpage1 + brSon1:HEIGHT IN FRAME fpage1 + .05.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-limpa-observ
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-limpa-observ wMasterDetail
ON CHOOSE OF bt-limpa-observ IN FRAME fPage1 /* Limpa Observ. */
DO:
    DEFINE VARIABLE h-coluna AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-query AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-ordena-campo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-linhas  AS INTEGER     NO-UNDO.

    DEFINE VARIABLE i AS INTEGER     NO-UNDO.
    

    DO i = 1 TO brSon1:NUM-SELECTED-ROWS:
        brSon1:FETCH-SELECTED-ROW(i).

        ASSIGN gr-ped-venda  = ttped-venda.r-rowid
               r-rowid-atual = ttped-venda.r-rowid.

        
        FIND int-ped-venda
            WHERE int-ped-venda.nr-pedido = ttped-venda.nr-pedido
              AND int-ped-venda.cod-estabel = ttped-venda.cod-estabel
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL int-ped-venda THEN
            ASSIGN int-ped-venda.mensagem = "".
    END.

    brSon1:REFRESH().
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-transf-dep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-transf-dep wMasterDetail
ON CHOOSE OF bt-transf-dep IN FRAME fPage1 /* TRANSF.ATENDENTE */
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
 DO:
    DEFINE VARIABLE v_num_cont AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_num_lin  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l-sel      AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-mensagem AS CHARACTER    NO-UNDO.

    for FIRST mgesp.ponto-programa
        where ponto-programa.nome-programa = "espdp005"
          AND ponto-programa.ponto = 1,
         EACH mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        ASSIGN v_num_lin = brSon1:num-iterations.
        do  v_num_cont = 1 to v_num_lin:
            ASSIGN l-sel = brSon1:fetch-selected-row(v_num_cont) NO-ERROR.
            IF l-sel THEN DO:
                IF ENTRY(1,conteudo-programa.conteudo) = v_cod_usuar_corren THEN DO:
                    FIND FIRST ped-venda WHERE ped-venda.nome-abrev  = ttped-venda.nome-abrev AND
                                                ped-venda.nr-pedcli  = ttped-venda.nr-pedcli EXCLUSIVE-LOCK NO-ERROR.

                    IF ENTRY(3,conteudo-programa.conteudo) = "DEPOSITO" AND
                       ENTRY(2,conteudo-programa.conteudo) = PED-VENDA.tp-pedido  THEN DO:
                        IF AVAIL ped-venda THEN DO:
                            ASSIGN c-mensagem = c-mensagem + ped-venda.nr-pedcli + ",". 
                            ASSIGN ped-venda.tp-pedido = ENTRY(4,conteudo-programa.conteudo).
                            DELETE ttped-venda.  
                        END.
                    END.

                    IF ENTRY(3,conteudo-programa.conteudo) = "ASTEC" AND
                       ENTRY(2,conteudo-programa.conteudo) = PED-VENDA.tp-pedido THEN DO:
                          IF AVAIL ped-venda THEN DO:
                              ASSIGN c-mensagem = c-mensagem + ped-venda.nr-pedcli + ",". 
                              ASSIGN ped-venda.tp-pedido = ENTRY(4,conteudo-programa.conteudo).
                              DELETE ttped-venda.
                          END.
                    END.
                END.

                IF AVAIL ped-venda THEN DO:
                   FIND CURRENT ped-venda NO-LOCK.
                   RELEASE ped-venda NO-ERROR.
                END.
            END.
        END.    

        IF ENTRY(1,conteudo-programa.conteudo) = v_cod_usuar_corren THEN DO:
            IF c-mensagem <> "" THEN DO:
                message "Pedidos " c-mensagem  " Transferidos para o Atendente " ENTRY(4,conteudo-programa.conteudo) 
                                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
        END.
    END.
    brSon1:REFRESH().

 END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetail wMasterDetail
ON CHOOSE OF btDetail IN FRAME fPage1 /* Detalhar */
DO:

    IF  VALID-HANDLE(wh-dt-entrega-pd4000) AND NOT VALID-HANDLE(h-pd4000) THEN DO:
        run utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Atená∆o, j† existe uma Tela do PD4000 aberta em sua sess∆o EMS, favor fechar a tela recÇm aberta. ~~ " + 
                                 "Por restriá‰es tÇcnicas, n∆o Ç poss°vel trabalhar com mais de uma tela do PD4000 na mesma sess∆o do EMS.").

        RETURN "OK".

    END.

    IF AVAIL ttPed-venda THEN DO:
        ASSIGN gr-ped-venda = ttped-venda.r-rowid.
        IF NOT VALID-HANDLE(h-pd4000) THEN DO:
            RUN pdp/pd4000.w PERSISTENT SET h-pd4000.
            RUN dispatch IN h-pd4000 ('initialize') no-error.
            RUN repositionRecord IN h-pd4000 (INPUT gr-ped-venda).
        END.
        ELSE
            RUN repositionRecord IN h-pd4000 (INPUT gr-ped-venda).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMasterDetail
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMasterDetail
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMasterDetail
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btPriori
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPriori wMasterDetail
ON CHOOSE OF btPriori IN FRAME fPage1 /* Priori/Atend */
DO:
    IF AVAIL ttPed-venda THEN DO:
        FIND int-emitente
            WHERE int-emitente.cod-emitente = ttPed-venda.cod-emitente NO-LOCK NO-ERROR.


        IF ttped-venda.cod-priori = 44 AND
           int-emitente.ind-participa-canais = 993520001 THEN DO:
            MESSAGE "Cliente participante programa de canais e pedido oráamento, n∆o Ç permitido alterar prioridade"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        ELSE
            RUN pi-altera-prioridade.
            
    END.
            
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMasterDetail
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btReat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReat wMasterDetail
ON CHOOSE OF btReat IN FRAME fPage1 /* Reat/Susp */
DO:
    IF AVAIL ttPed-venda THEN DO:
        RUN pi-ativa-suspende.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMasterDetail
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btSaldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSaldo wMasterDetail
ON CHOOSE OF btSaldo IN FRAME fPage1 /* Saldo Items */
DO:
    IF AVAIL ttPed-venda THEN DO:
        ASSIGN gr-ped-venda = ttped-venda.r-rowid.
        RUN esp/pdp/espdp005a.w.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miDetail wMasterDetail
ON CHOOSE OF MENU-ITEM miDetail /* Detalhar */
DO:
  APPLY "CHOOSE" TO btDetail IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miPriori
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miPriori wMasterDetail
ON CHOOSE OF MENU-ITEM miPriori /* Prioridade */
DO:
  APPLY "CHOOSE" TO btPriori IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miReat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miReat wMasterDetail
ON CHOOSE OF MENU-ITEM miReat /* Suspender/Reativar */
DO:
    APPLY "CHOOSE" TO btReat IN FRAME fPage1.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miSaldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miSaldo wMasterDetail
ON CHOOSE OF MENU-ITEM miSaldo /* Saldo Items */
DO:
  APPLY "CHOOSE" TO btSaldo IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME set-cod-priori-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL set-cod-priori-10 wMasterDetail
ON VALUE-CHANGED OF set-cod-priori-10 IN FRAME fPage0 /* Listar com Prioridade 10 */
DO:
  RUN afterDisplayFields. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME set-orcamento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL set-orcamento wMasterDetail
ON VALUE-CHANGED OF set-orcamento IN FRAME fPage0 /* Listar Oráamentos */
DO:
  RUN afterDisplayFields. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{masterdetail/MainBlock.i}

ASSIGN h_fpage0  = frame fPage0:HANDLE
       h_fpage1  = frame fPage1:handle.


ASSIGN  window_largura_ini    = {&WINDOW-NAME}:WIDTH  
        window_altura_ini     = {&WINDOW-NAME}:HEIGHT 
        fpage0_largura_ini    = h_fpage0:WIDTH
        fpage0_altura_ini     = h_fpage0:HEIGHT
        fpage1_largura_ini    = h_fpage1:WIDTH 
        fpage1_altura_ini     = h_fpage1:HEIGHT
        brson1_largura_ini    = brSon1:WIDTH  IN FRAME fpage1
        brson1_altura_ini     = brSon1:HEIGHT IN FRAME fpage1
        rtParent_largura_ini  = rtParent:WIDTH IN FRAME fpage0
        rtToolBar_largura_ini = rtToolBar:WIDTH IN FRAME fpage0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterControlToolBar wMasterDetail 
PROCEDURE afterControlToolBar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
for FIRST mgesp.ponto-programa
    where ponto-programa.nome-programa = "espdp005"
      AND ponto-programa.ponto = 1,
     EACH mgesp.conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
    IF ENTRY(1,conteudo-programa.conteudo) = v_cod_usuar_corren THEN DO:
        IF ENTRY(3,conteudo-programa.conteudo) = "DEPOSITO" THEN DO:           
            
            DISABLE btFirst
                    btPrev
                    btNext
                    btLast
                    btGoto
                WITH FRAME fPage0.    
            ASSIGN MENU-ITEM miFirst:SENSITIVE IN MENU smFile = FALSE  
                   MENU-ITEM miPrev:SENSITIVE IN MENU smFile = FALSE   
                   MENU-ITEM miNext:SENSITIVE IN MENU smFile = FALSE    
                   MENU-ITEM miLast:SENSITIVE IN MENU smFile = FALSE
                   MENU-ITEM miGoto:SENSITIVE IN MENU smFile = FALSE.

        END.
    END.
END.

bt-full-screen:SENSITIVE IN FRAME fpage0 = YES.
/* Include custom  Main Block code for SmartWindows. */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDestroyInterface wMasterDetail 
PROCEDURE AfterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*--- Destr¢i os Servidores RPC inicializados pelos DBOs ---*/
/*    {btb/btb008za.i3}
        
    /*Alteracao para deletar da mem¢ria o WindowStyles e o btb008za.p*/
    IF VALID-HANDLE(h-servid-rpc) THEN
    DO:
       DELETE PROCEDURE h-servid-rpc.
       ASSIGN h-servid-rpc = ?. /*Garantir que a vari†vel n∆o vai mais apontar para nenhum handle de outro objeto - este problema apareceu na v9.1B com Windows2000*/
    END.

    IF VALID-HANDLE(hWindowStyles) THEN
        DELETE PROCEDURE hWindowStyles.
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR i-returned AS INT NO-UNDO.

ENABLE set-cod-priori-10 WITH FRAME fpage0.
ENABLE set-orcamento WITH FRAME fpage0.
EMPTY TEMP-TABLE ttped-venda.

RUN linkToAtendente IN {&hDBOSon1} (INPUT {&hDBOParent}).
IF set-cod-priori-10:CHECKED AND
   set-orcamento:CHECKED THEN 
    RUN openQueryStatic IN {&hDBOSon1} (INPUT "Todos":U).
ELSE
    IF set-cod-priori-10:CHECKED THEN
       RUN openQueryStatic IN {&hDBOSon1} (INPUT "Prioridade10":U).
    ELSE
        IF set-orcamento:CHECKED THEN
            RUN openQueryStatic IN {&hDBOSon1} (INPUT "Orcamento":U).
        
        ELSE
            RUN openQueryStatic IN {&hDBOSon1} (INPUT "byAtendente":U).

RUN getBatchRecords IN {&hDBOSon1} ( INPUT ?,
                                     INPUT ?,
                                     INPUT ?,
                                     OUTPUT i-returned,
                                     OUTPUT TABLE ttPed-venda).
IF i-returned = 0 THEN DO:
    DISABLE btDetail
            btSaldo
            btPriori
            btReat
            bt-espdp054
            bt-limpa-observ
        WITH FRAME fPage1.            
ASSIGN MENU-ITEM miDetail:SENSITIVE IN MENU smFile = FALSE
       MENU-ITEM miSaldo:SENSITIVE IN MENU smFile = FALSE
       MENU-ITEM miReat:SENSITIVE IN MENU smFile = FALSE
       MENU-ITEM miPriori:SENSITIVE IN MENU smFile = FALSE.
END.
ELSE DO:
    ENABLE btDetail 
           btSaldo
           btPriori
           btReat
           bt-espdp054
           bt-limpa-observ
        WITH FRAME fPage1.

ASSIGN MENU-ITEM miDetail:SENSITIVE IN MENU smFile = TRUE
       MENU-ITEM miSaldo:SENSITIVE IN MENU smFile = TRUE
       MENU-ITEM miReat:SENSITIVE IN MENU smFile = TRUE
       MENU-ITEM miPriori:SENSITIVE IN MENU smFile = TRUE.             
END.
    
for FIRST mgesp.ponto-programa
    where ponto-programa.nome-programa = "espdp005"
      AND ponto-programa.ponto = 1,
     EACH mgesp.conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
    IF ENTRY(1,conteudo-programa.conteudo) = v_cod_usuar_corren THEN DO:
        IF ENTRY(3,conteudo-programa.conteudo) = "DEPOSITO" THEN DO:
            DISABLE bt-espdp006
                WITH FRAME fPage1.    

            ENABLE bt-espdp003
                WITH FRAME fPage1. 
            
            ENABLE bt-transf-dep
                WITH FRAME fPage1. 

            DISABLE btDetail
                    btSaldo
                    btPriori
                    btReat
                WITH FRAME fPage1.            
                   
            ASSIGN MENU-ITEM miDetail:SENSITIVE IN MENU smFile = FALSE
                   MENU-ITEM miSaldo:SENSITIVE IN MENU smFile = FALSE
                   MENU-ITEM miReat:SENSITIVE IN MENU smFile = FALSE
                   MENU-ITEM miPriori:SENSITIVE IN MENU smFile = FALSE.

        END.
        IF ENTRY(3,conteudo-programa.conteudo) = "ASTEC" THEN DO:
            DISABLE bt-espdp003
                WITH FRAME fPage1.    
            ENABLE bt-transf-dep
                WITH FRAME fPage1. 
        END.
    END.
    ELSE DO:
        ENABLE bt-espdp006
               WITH FRAME fPage1. 
    END.
END.
                                     
fi-incompleto:FGCOLOR IN FRAME fpage0 = 15.
fi-incompleto:BGCOLOR IN FRAME fpage0 = 1.
fi-fob:FGCOLOR IN FRAME fpage0 = ?.
fi-fob:BGCOLOR IN FRAME fpage0 = 14.
fi-bloqueado:FGCOLOR IN FRAME fpage0 = 15.
fi-bloqueado:BGCOLOR IN FRAME fpage0 = 2.

{&OPEN-QUERY-{&BROWSE-NAME}}                                     
                                



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroyInterface wMasterDetail 
PROCEDURE beforeDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF VALID-HANDLE(h-pd4000) THEN RUN pi-finalizar     IN h-pd4000.
IF VALID-HANDLE(h-pd4000) THEN RUN destroyInterface IN h-pd4000.
IF VALID-HANDLE(h-pd4000) THEN DELETE PROCEDURE        h-pd4000.

IF VALID-HANDLE(bo-ped-venda-rct) THEN RUN destroyBO IN bo-ped-venda-rct.
IF VALID-HANDLE(bo-ped-venda-rct) THEN DELETE PROCEDURE bo-ped-venda-rct.

IF VALID-HANDLE(bo-ped-venda-sus) THEN RUN destroyBO IN bo-ped-venda-sus.
IF VALID-HANDLE(bo-ped-venda-sus) THEN DELETE PROCEDURE bo-ped-venda-sus.

IF VALID-HANDLE(bo-ped-venda) THEN RUN destroy IN bo-ped-venda.
IF VALID-HANDLE(bo-ped-venda)     THEN DELETE PROCEDURE bo-ped-venda.

IF VALID-HANDLE({&hDBOParent})    THEN DELETE PROCEDURE {&hDBOParent}.
IF VALID-HANDLE({&hDBOSon1})      THEN DELETE PROCEDURE {&hDBOSon1}.
IF VALID-HANDLE(h-espdp045)       THEN DELETE PROCEDURE h-espdp045.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE i-atendente LIKE {&ttParent}.cd-oper LABEL "Atendente" VIEW-AS FILL-IN SIZE 4 BY .88 NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        i-atendente AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Atendente" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-atendente.
        
        /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT i-atendente).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Atendente":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE i-atendente btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "esbo/boes013.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes013.p YES}
        {btb/btb008za.i2 esbo/boes013.p '' {&hDBOParent}} 
    END.
    
    RUN setConstraintMain IN {&hDBOParent} NO-ERROR.
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "esbo/esbodi159.p":U THEN DO:
        {btb/btb008za.i1 esbo/esbodi159.p YES}
        {btb/btb008za.i2 esbo/esbodi159.p '' {&hDBOSon1}} 
    END.    


        for FIRST mgesp.ponto-programa
            where ponto-programa.nome-programa = "espdp005"
              AND ponto-programa.ponto = 1,
             EACH mgesp.conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
            IF ENTRY(1,conteudo-programa.conteudo) = v_cod_usuar_corren THEN DO:
                IF ENTRY(3,conteudo-programa.conteudo) = "DEPOSITO" THEN DO:
                    ASSIGN TTATENDENTE.CD-OPER:SCREEN-VALUE  IN FRAME FPAGE0 =  "95".
                    RUN goToKey IN {&hDBOParent} (INPUT "95").
                    IF RETURN-VALUE = "NOK":U THEN DO:
                        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Atendente":U).
    
                        RETURN NO-APPLY.
                    END.
    
                    /*:T Retorna rowid do registro corrente do DBO */
                    RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
    
                    /*:T Reposiciona registro com base em um rowid */
                    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
                END.
            END.
        END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/                                                 

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-prioridade wMasterDetail 
PROCEDURE pi-altera-prioridade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN i-priori = ttped-venda.cod-priori.
    ASSIGN c-atendente = ttped-venda.tp-pedido.
    
    RUN esp\pdp\espdp005b.w (INPUT-OUTPUT i-priori,
                                         INPUT-OUTPUT c-atendente).
    
    IF i-priori <> ttped-venda.cod-priori OR c-atendente <> ttped-venda.tp-pedido THEN DO:
        FIND FIRST ped-venda
            WHERE ped-venda.nome-abrev = ttped-venda.nome-abrev
              AND ped-venda.nr-pedcli  = ttped-venda.nr-pedcli EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL ped-venda THEN DO:
            ASSIGN ttped-venda.cod-priori = i-priori
                   ped-venda.cod-priori = ttped-venda.cod-priori.

            FIND FIRST int-ped-venda EXCLUSIVE-LOCK 
                 WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
            IF AVAIL int-ped-venda THEN DO:
                ASSIGN int-ped-venda.cod-priori-orig = ped-venda.cod-priori.
            END.

            FIND FIRST atendente NO-LOCK
                WHERE atendente.cd-oper = int(c-atendente) NO-ERROR.

            IF  AVAIL atendente THEN
                ASSIGN ttped-venda.tp-pedido = STRING(INT(c-atendente),"99").
                       
            ASSIGN ped-venda.tp-pedido = ttped-venda.tp-pedido.
            
            brSon1:REFRESH() IN FRAME fPage1.
            
            RUN afterdisplayfields.
            
        END.
        
    END.

    IF AVAIL ped-venda THEN DO:
        FIND CURRENT ped-venda NO-LOCK.
        RELEASE ped-venda NO-ERROR.
        
    END.
   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ativa-suspende wMasterDetail 
PROCEDURE pi-ativa-suspende :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
RUN esp/pdp/espdp005c.p (INPUT ttped-venda.observacoes,
                         INPUT ttped-venda.cond-espec).
/*     RUN utp/ut-msgs.p (INPUT "show":U,                                              */
/*                        INPUT 15825,                                                 */
/*                        INPUT "Observaá‰es do pedido:~~" + ttped-venda.observacoes). */

    if not valid-handle(bo-ped-venda) or
       bo-ped-venda:type <> "PROCEDURE":U or
       bo-ped-venda:file-name <> "dibo/bodi159.p":U then
        run dibo/bodi159.p persistent set bo-ped-venda.

    
    run pdp/pd4000a.w(input  (if  ttped-venda.cod-sit-ped = 5
                                  then "Reativaá∆o"
                                  else "Suspens∆o"),
                      output i-cod-motivo,
                      output c-desc-motivo,
                      output da-data,
                      output l-resultado).
    
    if  l-resultado then do:
    
        if  ttped-venda.cod-sit-ped = 5 then do:
    
            if  session:set-wait-state("general") then.
                if not valid-handle(bo-ped-venda-rct) or
                   bo-ped-venda-rct:type <> "PROCEDURE":U or
                   bo-ped-venda-rct:file-name <> "dibo/bodi159rct.p":U then
                     run dibo/bodi159rct.p persistent set bo-ped-venda-rct.
    
            run setUserLog in bo-ped-venda-rct (input c-seg-usuario).
    
            run validateReactivation in bo-ped-venda-rct (input  ttped-venda.r-rowid,
                                                          output table Rowerrors).
    
            if  session:set-wait-state("") then.
    
    
            if  can-find(first RowErrors) then do:
                {method/ShowMessage.i1}
                {method/ShowMessage.i2 &Modal=YES}
            end.
    
            if  not can-find(first RowErrors
                             where RowErrors.ErrorSubType = "Error":U) then do:
                run emptyRowErrors in bo-ped-venda-rct.                        
                run updateReactivation in bo-ped-venda-rct (input  ttped-venda.r-rowid,
                                                            INPUT  ttped-venda.cod-mot-canc-cot,
                                                            input  c-desc-motivo).
                run getRowErrors in bo-ped-venda-rct (output table RowErrors). 
                if  can-find(first RowErrors) then do:
                    {method/ShowMessage.i1}
                    {method/ShowMessage.i2 &Modal=YES}
                end.                                                       
    
                run reloadOrder in bo-ped-venda (input  ttped-venda.r-rowid,
                                                 output table ttped-venda-aux).
                if  return-value = "OK":U then do:
                    find first ttped-venda-aux.
                    buffer-copy ttped-venda-aux to ttped-venda.
                    delete ttped-venda-aux.
                end.
            end.
        end.
        else do:
    
            if not valid-handle(bo-ped-venda-sus) or
               bo-ped-venda-sus:type <> "PROCEDURE":U or
               bo-ped-venda-sus:file-name <> "dibo/bodi159sus.p":U then
               run dibo/bodi159sus.p persistent set bo-ped-venda-sus.
               
    
            run setUserLog in bo-ped-venda-sus (input c-seg-usuario).               
    
            if  session:set-wait-state("general") then.
    
            run validateSuspension in bo-ped-venda-sus (input  ttped-venda.r-rowid,
                                                        output table Rowerrors).
    
            if  session:set-wait-state("") then.
    
            if  can-find(first RowErrors) then do:
                {method/ShowMessage.i1}
                {method/ShowMessage.i2 &Modal=YES}
            end.
    
    
            if  not can-find(first RowErrors
                             where RowErrors.ErrorSubType = "Error":U) then do:
                run updateSuspension in bo-ped-venda-sus (input  ttped-venda.r-rowid,
                                                          INPUT  ttped-venda.cod-mot-canc-cot,
                                                          input  c-desc-motivo).
                run reloadOrder in bo-ped-venda (input  ttped-venda.r-rowid,
                                                 output table ttped-venda-aux).
                if  return-value = "OK":U then do:
                    find first ttped-venda-aux.
                    buffer-copy ttped-venda-aux to ttped-venda.
                    delete ttped-venda-aux.
                end.
            end.
        end.
    
        brSon1:REFRESH() IN FRAME fPage1.
    
     end.

     IF VALID-HANDLE(bo-ped-venda-rct) THEN RUN destroyBO IN bo-ped-venda-rct.
     IF VALID-HANDLE(bo-ped-venda-rct) THEN DELETE PROCEDURE bo-ped-venda-rct.

     IF VALID-HANDLE(bo-ped-venda-sus) THEN RUN destroyBO IN bo-ped-venda-sus.
     IF VALID-HANDLE(bo-ped-venda-sus) THEN DELETE PROCEDURE bo-ped-venda-sus.

     IF VALID-HANDLE(bo-ped-venda) THEN RUN destroy IN bo-ped-venda.
     IF VALID-HANDLE(bo-ped-venda)     THEN DELETE PROCEDURE bo-ped-venda.


     IF AVAIL ped-venda THEN DO:
         FIND CURRENT ped-venda NO-LOCK.
         RELEASE ped-venda NO-ERROR.
     END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-fullscreen wMasterDetail 
PROCEDURE pi-fullscreen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def var hWinParent as int no-undo.
   def var iCurStyle  as int no-undo.
   def var iOldStyle  as int no-undo.

   assign hWinParent = GetParent({&window-name}:hwnd).

   run LockWindowUpdate (input {&window-name}:hwnd).

   if iStyle = ? then do:
      run GetMenu (input  hWinParent,
                   output iOldMenu).
      run SetMenu (hWinParent,0).
      run GetWindowLongA (input  hWinParent,
                          input  -16,
                          output iCurStyle).
      run Bit_Remove     (input-output iCurStyle,
                          input        12582912).
      run Bit_Remove     (input-output iCurStyle,
                          input        262144).
      run SetWindowLongA (input  hWinParent,
                          input  -16,
                          input  iCurStyle,
                          output iOldStyle).
      assign dColWin               = {&window-name}:col
             dRowWin               = {&window-name}:row
             dHeiWin               = {&window-name}:height
             dWidWin               = {&window-name}:width
             {&window-name}:width  = session:width  - 4
             {&window-name}:height = session:height - 1
             {&window-name}:col    = 1
             {&window-name}:row    = 1
             iStyle                = iOldStyle.
   end.
   else do:
      run SetMenu (hWinParent,iOldMenu).
      run SetWindowLongA (hWinParent, -16, istyle, output iOldStyle).
      assign {&window-name}:col    = dColWin
             {&window-name}:row    = dRowWin
             {&window-name}:height = dHeiWin
             {&window-name}:width  = dWidWin
             iStyle                = ?.
   end.

   apply "window-resized" to {&window-name}.

   run LockWindowUpdate (input 0).
   return "ok".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ordena wMasterDetail 
PROCEDURE pi-ordena :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE h-coluna AS HANDLE      NO-UNDO.
  DEFINE VARIABLE h-query AS HANDLE      NO-UNDO.
  DEFINE VARIABLE i-linhas  AS INTEGER     NO-UNDO.

  FOR EACH ttped-venda EXCLUSIVE-LOCK:
      if ttped-venda.cod-sit-aval = 3 THEN DO:
          ASSIGN ttped-venda.desc-bloq-cr = ttped-venda.desc-forc-cr.
      END.
  END.

  ASSIGN h-coluna = SELF:CURRENT-COLUMN NO-ERROR.

  ASSIGN l-parametro    = IF l-parametro = YES THEN NO ELSE YES
         c-ordena-campo = '' .
 
  IF NOT ERROR-STATUS:ERROR AND
     VALID-HANDLE(h-coluna) AND
     h-coluna <> ?          THEN DO:
     
      IF c-ordena-campo = "" THEN
          ASSIGN c-ordena-campo = STRING(h-coluna:NAME).
      ELSE DO:
          IF c-ordena-campo = STRING(h-coluna:NAME) THEN
              ASSIGN c-ordena-campo = STRING(h-coluna:NAME) + " descending".
          ELSE
              ASSIGN c-ordena-campo = STRING(h-coluna:NAME).
      END.

      ASSIGN h-query  = SELF:QUERY NO-ERROR.
      IF  c-ordena-campo = "c-descsit"    OR 
          c-ordena-campo = "c-sit"        OR 
          c-ordena-campo = "cod-priori"   OR 
          c-ordena-campo = "cod-emitente" OR 
          c-ordena-campo = "nome-abrev"   OR 
          /*
          c-ordena-campo = "c-cat"        OR 
          */
          c-ordena-campo = "cod-gr-cli"   OR 
          c-ordena-campo = "no-ab-reppri" OR 
          c-ordena-campo = "nr-pedcli"    OR 
          c-ordena-campo = "i-cond"       OR 
          c-ordena-campo = "i-parc"       OR 
          c-ordena-campo = "d-parc"       OR 
          c-ordena-campo = "vl-liq-abe"   OR 
          c-ordena-campo = "dt-entrega"   OR 
          c-ordena-campo = "nome-transp"  OR 
          /*
          c-ordena-campo = "nat-operacao" OR 
          c-ordena-campo = "d-taxa"       OR 
          c-ordena-campo = "i-base"       OR 
          c-ordena-campo = "c-mensagem"   OR 
          */
          c-ordena-campo = "estado"       OR
          c-ordena-campo = "desc-bloq-cr" 
          THEN DO:
          
      END.
      ELSE DO:
          MESSAGE "Nao Ç poss°vel ordenar por esta coluna"
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ordena2 wMasterDetail 
PROCEDURE pi-ordena2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-transportadora wMasterDetail 
PROCEDURE pi-valida-transportadora :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    IF ttped-venda.nome-abrev-tri <> "" THEN DO:

        FOR FIRST loc-entr NO-LOCK WHERE
            loc-entr.nome-abrev  = ttped-venda.nome-abrev-tri AND
            loc-entr.cod-entrega = ttped-venda.cod-entrega:
            /* Busca Transportadora - Incidente 26358 */
            RUN esp/crm/escrm107.p (INPUT ttped-venda.cod-estabel,
                                    INPUT STRING(ttped-venda.cod-emitente),
                                    INPUT loc-entr.cidade,
                                    INPUT loc-entr.estado,
                                    INPUT 0,
                                    INPUT loc-entr.cep,
                                    OUTPUT c-cod-transp,
                                    OUTPUT c-sigla-transp).

            IF c-cod-transp = ? THEN DO:
                
                RETURN "NOK":U.
            END. /* IF c-cod-transp = ? THEN DO: */

            RELEASE transporte.
        END. /* FOR FIRST loc-entr WHERE */

    END. /* IF VALID-HANDLE(wh-nome-abrev-tri-pd4000) AND wh-nome-abrev-tri-pd4000:SCREEN-VALUE <> "" THEN DO: */
    ELSE DO:
        FOR FIRST loc-entr NO-LOCK WHERE
            loc-entr.nome-abrev  = ttped-venda.nome-abrev AND
            loc-entr.cod-entrega = ttped-venda.cod-entrega:   
            /* Busca Transportadora - Incidente 26358 */
            RUN esp/crm/escrm107.p (INPUT ttped-venda.cod-estabel,
                                    INPUT STRING(ttped-venda.cod-emitente),
                                    INPUT loc-entr.cidade,
                                    INPUT loc-entr.estado,
                                    INPUT 0,
                                    INPUT loc-entr.cep,
                                    OUTPUT c-cod-transp,
                                    OUTPUT c-sigla-transp).

            IF c-cod-transp = ? THEN DO:
                RETURN "NOK":U.
            END.


        END. /* FOR FIRST loc-entr WHERE */

    END. /* ELSE DO: */
    FOR FIRST transporte WHERE transporte.cod-transp = c-cod-transp NO-LOCK:
    END. /* FOR FIRST transporte WHERE transporte.cod-transp = c-cod-transp NO-LOCK: */
    IF transporte.nome-abrev <> ttped-venda.nome-transp OR
        NOT AVAIL transporte OR 
        c-cod-transp = ?  THEN DO:
            ASSIGN c-descsit:FGCOLOR                IN BROWSE brSon1 = 13
                   ttped-venda.cod-priori:FGCOLOR   IN BROWSE brSon1 = 13
                   ttped-venda.cod-emitente:FGCOLOR IN BROWSE brSon1 = 13
                   ttped-venda.nome-abrev:FGCOLOR   IN BROWSE brSon1 = 13
                   ttped-venda.estado:FGCOLOR       IN BROWSE brSon1 = 13
                   c-cat:FGCOLOR                    IN BROWSE brSon1 = 13
                   ttped-venda.cod-gr-cli:FGCOLOR   IN BROWSE brSon1 = 13
                   ttped-venda.no-ab-reppri:FGCOLOR IN BROWSE brSon1 = 13
                   ttped-venda.cod-estabel:FGCOLOR  IN BROWSE brSon1 = 13
                   ttped-venda.nr-pedcli:FGCOLOR    IN BROWSE brSon1 = 13
                   i-cond:FGCOLOR                   IN BROWSE brSon1 = 13
                   d-peso-tot:FGCOLOR               IN BROWSE brSon1 = 13
                   i-parc:FGCOLOR                   IN BROWSE brSon1 = 13
                   d-parc:FGCOLOR                   IN BROWSE brSon1 = 13
                   ttped-venda.vl-liq-abe:FGCOLOR   IN BROWSE brSon1 = 13
                   d-taxa:FGCOLOR                   IN BROWSE brSon1 = 13
                   i-base:FGCOLOR                   IN BROWSE brSon1 = 13
                   ttped-venda.dt-entrega:FGCOLOR   IN BROWSE brSon1 = 13
                   ttped-venda.nome-transp:FGCOLOR  IN BROWSE brSon1 = 13
                   ttped-venda.nat-operacao:FGCOLOR IN BROWSE brSon1 = 13
                   c-sit:FGCOLOR                    IN BROWSE brSon1 = 13
                   c-mensagem:FGCOLOR               IN BROWSE brSon1 = 13
                   ttped-venda.desc-bloq-cr:FGCOLOR IN BROWSE brSon1 = 13.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnBase wMasterDetail 
FUNCTION fnBase RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF AVAIL pd-vendor THEN        
    RETURN pd-vendor.dias-base.
  ELSE
    RETURN 0. 
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCanalCliente wMasterDetail 
FUNCTION fnCanalCliente RETURNS CHARACTER
  ( p-nr-pedido AS INT,
    p-cod-estabel AS CHAR,
    p-cod-emitente AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN c-cat = "".

  FIND FIRST ped-venda NO-LOCK
       WHERE ped-venda.nr-pedido = p-nr-pedido NO-ERROR.

  FIND FIRST repres NO-LOCK
       WHERE repres.nome-abrev = ped-venda.no-ab-reppri NO-ERROR.

  FIND FIRST int-ped-venda NO-LOCK
      WHERE int-ped-venda.nr-pedido   = p-nr-pedido
        AND int-ped-venda.cod-estabel = p-cod-estabel NO-ERROR.

  IF AVAIL int-ped-venda THEN DO:
      FIND FIRST int-ped-venda2
          WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
            AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido  NO-LOCK NO-ERROR.
      IF AVAIL int-ped-venda2 AND int-ped-venda2.int-1 <> 0 THEN
          ASSIGN c-cat = string(int-ped-venda2.int-1).
      ELSE DO:
          FIND FIRST grupo-canais-clientes
              WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
          IF AVAIL grupo-canais-clientes THEN
              ASSIGN c-cat = string(grupo-canais-clientes.cod-gr-canais).
      END. 
           
  END.

  RETURN c-cat.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCond wMasterDetail 
FUNCTION fnCond RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  IF AVAIL pd-vendor THEN        
    RETURN pd-vendor.cod-cond-cli.
  ELSE
    RETURN ttped-venda.cod-cond-pag.
    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCredito wMasterDetail 
FUNCTION fnCredito RETURNS CHARACTER
  ( p-sit AS INTEGER,
    p-flex AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
/*        IF ttped-venda.nr-pedcli = "1196596" then                      */
/*                                 MESSAGE ttped-venda.desc-forc-cr SKIP */
/*                                     ttped-venda.desc-bloq-cr          */
/*                                 VIEW-AS ALERT-BOX INFO BUTTONS OK.    */

if p-sit = 3 THEN DO:
    ASSIGN ttped-venda.desc-bloq-cr = ttped-venda.desc-forc-cr.
END.
RETURN ttped-venda.desc-bloq-cr.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescSit wMasterDetail 
FUNCTION fnDescSit RETURNS CHARACTER
  ( p-sit AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

if p-sit = 3 then
   RETURN "AP".
else do:
   if p-sit = 4 then
      RETURN "RE".
   else 
      RETURN "NA".
end.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnFrete wMasterDetail 
FUNCTION fnFrete RETURNS CHARACTER
  ( p-frete AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
if p-frete = "" then
    RETURN "FOB".
else 
    RETURN "CIF".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnmensagem wMasterDetail 
FUNCTION fnmensagem RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
FIND int-ped-venda
    WHERE int-ped-venda.nr-pedido = ttped-venda.nr-pedido
      AND int-ped-venda.cod-estabel = ttped-venda.cod-estabel
    NO-LOCK NO-ERROR.
IF AVAIL int-ped-venda THEN
    RETURN int-ped-venda.mensagem.
ELSE
     RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNatCli wMasterDetail 
FUNCTION fnNatCli RETURNS CHARACTER
  ( p-cod-emitente AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = p-cod-emitente NO-ERROR.
    IF AVAIL emitente THEN DO:
        IF emitente.natureza = 1 THEN 
            RETURN "PF".
        ELSE IF emitente.natureza = 2 THEN 
            RETURN "PJ".
        ELSE IF emitente.natureza = 3 THEN 
            RETURN "ES".
        ELSE IF emitente.natureza = 4 THEN 
            RETURN "TR".
        ELSE 
            RETURN "".
    END.
    ELSE RETURN "".
       

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnorigem wMasterDetail 
FUNCTION fnorigem RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
FIND int-ped-venda
    WHERE int-ped-venda.nr-pedido = ttped-venda.nr-pedido
      AND int-ped-venda.cod-estabel = ttped-venda.cod-estabel
    NO-LOCK NO-ERROR.
IF AVAIL int-ped-venda THEN
    RETURN int-ped-venda.origem.
ELSE
     RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnParc wMasterDetail 
FUNCTION fnParc RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF AVAIL cond-pagto THEN        
    RETURN cond-pagto.num-parcelas.
  ELSE
    RETURN 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPesoTotal wMasterDetail 
FUNCTION fnPesoTotal RETURNS DECIMAL
  ( INPUT p-nome-abrev AS CHARACTER,
    INPUT p-nr-pedcli  AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE d-peso-total AS DECIMAL NO-UNDO.
DEFINE BUFFER b-ped-item   FOR ped-item.
DEFINE BUFFER b-natur-oper FOR natur-oper.
DEFINE BUFFER b-item       FOR item.

FOR EACH  b-ped-item
    WHERE b-ped-item.nome-abrev = p-nome-abrev
    AND   b-ped-item.nr-pedcli  = p-nr-pedcli
    AND   b-ped-item.cod-sit-item < 3 NO-LOCK,
    FIRST b-natur-oper
    WHERE b-natur-oper.nat-operacao = b-ped-item.nat-operacao NO-LOCK,
    FIRST b-item
    WHERE b-item.it-codigo = b-ped-item.it-codigo NO-LOCK:
    
    ASSIGN d-peso-total = d-peso-total + ((b-ped-item.qt-pedida - b-ped-item.qt-atendida) * b-item.peso-bruto).
END.

RETURN d-peso-total.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSit wMasterDetail 
FUNCTION fnSit RETURNS CHARACTER
  ( p-ped AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    if p-ped = 1 then
       RETURN "Aberto".
    else
    if p-ped = 2 then 
       RETURN "At. Parcial".
    else
    if p-ped = 3 then 
       RETURN "At. Total".
    else
    if p-ped = 4 then 
       RETURN "Pendente".
    else
    if p-ped = 5 then 
       RETURN "Suspenso".
    else
    if p-ped = 6 then 
       RETURN "Cancelado".
    ELSE        
    if p-ped = 7 then 
       RETURN "Fat. Balc∆o".
       

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTaxa wMasterDetail 
FUNCTION fnTaxa RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF AVAIL pd-vendor THEN        
    RETURN pd-vendor.taxa-cliente * 100.
  ELSE
    RETURN 0.00.
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnValorParc wMasterDetail 
FUNCTION fnValorParc RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
IF AVAIL cond-pagto THEN
    RETURN ttped-venda.vl-liq-abe / cond-pagto.num-parcelas.
ELSE
    RETURN ttped-venda.vl-liq-abe.
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

