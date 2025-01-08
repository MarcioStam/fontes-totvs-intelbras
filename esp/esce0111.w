&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/********************************************************************************

*******************************************************************************/

{include/i-prgvrs.i ESCE0111 2.00.00.001 } /*** 010001***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESCE0111 MCE}
&ENDIF

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
/* Obs: Retirar o valor do preprocessador para as p ginas que nÆo existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA 
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGDIG f-pg-dig
&GLOBAL-DEFINE PGIMP f-pg-imp

/* Include Com as Vari veis Globais */
{utp/ut-glob.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgman.i} /*Miniflexibiliza‡Æo. Utilizado no EMS 2.03 - NÇO ELIMINAR
                 * Vari vel preprocessador bf_man_203 */

/* Parameters Definitions ---                                           */

&IF DEFINED (bf_man_per_ppm) &THEN
    {cdp/cd0666.i}
    {cpp/cpapi020.i}
    {cpp/cpapi020.i1} /* Fun‡äes p/ Fator de Concentra‡Æo */
&ENDIF

/* Temporary Table Definitions ---                                      */

define temp-table tt-param NO-UNDO
    field destino          as integer
    field arquivo          as char
    field usuario          as char
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    FIELD lote             LIKE saldo-estoq.lote
    FIELD dt-vali-lote     LIKE saldo-estoq.dt-vali-lote
    FIELD dt-referencia    LIKE saldo-estoq.dt-vali-lote
    field i-tipo-exec      AS INTEGER.

define temp-table tt-altera NO-UNDO
    field it-codigo     like item.it-codigo
    field descricao     as char format "x(60)"
    field un            like item.un
    field new-it-codigo like item.it-codigo
    field new-un        like item.un
    field fator-conv    as decimal format ">,>>9.99999"
    field ge-codigo     like item.ge-codigo
    field old-ge-codigo like item.ge-codigo.

define temp-table tt-troca no-undo
    field it-codigo     like item.it-codigo
    field un            like item.un
    field descricao     as char format "x(36)"
    index id is primary unique it-codigo.

define temp-table tt-digita no-undo
    field it-codigo     like item.it-codigo
    field un            like item.un
    field descricao     as char format "x(36)"
    index id is primary unique it-codigo.

define buffer b-tt-troca for tt-troca.

/* Transfer Definitions */                    
def var raw-param        as raw no-undo.

def temp-table tt-raw-digita NO-UNDO
   field raw-digita      as raw.

DEF VAR p-item-ini     AS CHAR INIT "" NO-UNDO.
DEF VAR p-item-fim     AS CHAR INIT "ZZZZZZZZZZZZZZZZ" NO-UNDO.
DEF VAR p-familia-ini  AS CHAR INIT "" NO-UNDO.
DEF VAR p-familia-fim  AS CHAR INIT "ZZZZZZZZ" NO-UNDO.
DEF VAR p-ge-ini       AS INT  INIT 0 NO-UNDO.
DEF VAR p-ge-fim       AS INT  INIT 99 NO-UNDO.
DEF VAR p-ge-conv      AS INT  INIT 0 NO-UNDO.
DEF VAR p-un-conv      AS CHAR INIT "" NO-UNDO.
DEF VAR p-fator-conv   AS DEC  INIT 1 NO-UNDO.
DEF VAR p-dt-corte     AS date INIT today NO-UNDO.

/* Local Variable Definitions ---           */
def var l-ok               as log     no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-tabela           as char    no-undo.

def var de-fator           as dec     no-undo.
def var i-ge               as int     no-undo.
def var c-importa          as char    no-undo.
def var c-layout           as char    no-undo.
def var c-reg              as char    no-undo.
def var c-item-a           as char    no-undo.
def var c-item-n           as char    no-undo.
def var c-un-ant           as char    no-undo.
def var c-un-atu           as char    no-undo.
def var c-desc             as char    no-undo.
def var l-altera           as log     no-undo.
DEF VAR c-it-codigo-ant    LIKE ITEM.it-codigo NO-UNDO.

def var r-tt-altera        as rowid   no-undo.
def var r-tt-troca       as rowid   no-undo.
def var l-erro             as log     no-undo.
def var i-old-ge-codigo    like item.ge-codigo no-undo.

/* Defini‡Æo de variaveis auxiliares adapter EAI Itens*/
&IF DEFINED (bf_man_204) &THEN 
    {include/i_dbeai.i}
    DEF VAR lIsSubscribed  AS LOG NO-UNDO.
    DEF VAR eai_valid_item AS LOG NO-UNDO.
 &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-par
&Scoped-define BROWSE-NAME br-digita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-troca

/* Definitions for BROWSE br-troca                                      */
&Scoped-define FIELDS-IN-QUERY-br-troca tt-troca.it-codigo tt-troca.un tt-troca.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-troca tt-troca.it-codigo   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-troca tt-troca
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-troca tt-troca
&Scoped-define SELF-NAME br-troca
&Scoped-define QUERY-STRING-br-troca FOR EACH tt-troca
&Scoped-define OPEN-QUERY-br-troca OPEN QUERY br-troca FOR EACH tt-troca.
&Scoped-define TABLES-IN-QUERY-br-troca tt-troca
&Scoped-define FIRST-TABLE-IN-QUERY-br-troca tt-troca


/* Definitions for FRAME f-pg-dig                                       */

/* Definitions for FRAME f-pg-sel                                       */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-pg-sel ~
    ~{&OPEN-QUERY-br-troca}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-lote dt-vali-lote RADIO-SET-1 ~
dt-referencia 
&Scoped-Define DISPLAYED-OBJECTS c-lote dt-vali-lote RADIO-SET-1 ~
dt-referencia 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
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

DEFINE VARIABLE c-listagem AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63 NO-UNDO.

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

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE c-lote AS CHARACTER FORMAT "X(40)":U 
     LABEL "Lote" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE dt-referencia AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Referˆncia" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE dt-vali-lote AS DATE FORMAT "99/99/9999":U 
     LABEL "Validade Lote" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Altera movimentos a partir de:", 1,
"Altera movimentos at‚", 2
     SIZE 34 BY 3 NO-UNDO.

DEFINE BUTTON bt-alterar-2 
     LABEL "Alterar" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-faixa 
     LABEL "Faixa" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-inserir-2 
     LABEL "Inserir" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-layout-elimina 
     LABEL "Layout" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-retirar-2 
     LABEL "Retirar" 
     SIZE 15 BY 1.

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
     SIZE 15.86 BY 1.21.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 79 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 7 .

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
DEFINE QUERY br-troca FOR 
      tt-troca SCROLLING.
&ANALYZE-RESUME
DEFINE QUERY br-digita FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-digita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-digita C-Win _FREEFORM
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 71 BY 9
         BGCOLOR 15 FONT 1.

DEFINE BROWSE br-troca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-troca C-Win _FREEFORM
  QUERY br-troca DISPLAY
      tt-troca.it-codigo
      tt-troca.un
      tt-troca.descricao
ENABLE
      tt-troca.it-codigo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 75 BY 9
         BGCOLOR 15 FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execu‡Æo do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Cancelar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     rt-folder-left AT ROW 2.54 COL 2.14
     RECT-6 AT ROW 13.75 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     RECT-1 AT ROW 14.29 COL 2
     rt-folder-top AT ROW 2.54 COL 2.14
     im-pg-dig AT ROW 1.5 COL 17.86
     im-pg-par AT ROW 1.5 COL 17.86
     im-pg-imp AT ROW 1.5 COL 33.57
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-dig
     br-digita AT ROW 1.75 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.43 ROW 3
         SIZE 75.14 BY 10.5.

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     bt-config-impr AT ROW 3.58 COL 43.29 HELP
          "Configura‡Æo da impressora"
     bt-arquivo AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     c-arquivo AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 5.75 COL 3 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     c-listagem AT ROW 7.25 COL 1 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 75.5 BY 10.5.

DEFINE FRAME f-pg-par
     c-lote AT ROW 2.25 COL 27 COLON-ALIGNED WIDGET-ID 4
     dt-vali-lote AT ROW 3.25 COL 27 COLON-ALIGNED WIDGET-ID 2
     RADIO-SET-1 AT ROW 6.5 COL 5 NO-LABEL WIDGET-ID 8
     dt-referencia AT ROW 7.5 COL 55 COLON-ALIGNED WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.86 ROW 3
         SIZE 74.72 BY 10.5.

DEFINE FRAME f-pg-sel
     br-troca AT ROW 1 COL 1
     bt-inserir-2 AT ROW 10 COL 1
     bt-alterar-2 AT ROW 10 COL 16
     bt-retirar-2 AT ROW 10 COL 31
     bt-layout-elimina AT ROW 10 COL 46
     bt-faixa AT ROW 10 COL 61
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.43 ROW 3
         SIZE 75.14 BY 10.5.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Altera‡Æo no C¢digo do Item"
         HEIGHT             = 15.46
         WIDTH              = 82.14
         MAX-HEIGHT         = 28.83
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.83
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
                                                                        */
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
                "Execu‡Æo".

/* SETTINGS FOR FRAME f-pg-par
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* BROWSE-TAB br-troca 1 f-pg-sel */
/* SETTINGS FOR BUTTON bt-alterar-2 IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-retirar-2 IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-relat
                                                                        */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-relat
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

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-troca
/* Query rebuild information for BROWSE br-troca
     _START_FREEFORM
OPEN QUERY br-troca FOR EACH tt-troca.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-troca */
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
ON END-ERROR OF C-Win /* Altera‡Æo no C¢digo do Item */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Altera‡Æo no C¢digo do Item */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-troca
&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME br-troca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-troca C-Win
ON DEL OF br-troca IN FRAME f-pg-sel
DO:
   apply 'choose' to bt-retirar-2 in frame f-pg-sel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-troca C-Win
ON END-ERROR OF br-troca IN FRAME f-pg-sel
ANYWHERE 
DO:

    if  br-troca:new-row in frame f-pg-sel then do:
        if  avail tt-troca then
            delete tt-troca.
        if  br-troca:delete-current-row() in frame f-pg-sel then. 
    end.                                                               
    else do:
        get current br-troca.
        display tt-troca.it-codigo
                tt-troca.un
                tt-troca.descricao
                with browse br-troca.
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-troca C-Win
ON INS OF br-troca IN FRAME f-pg-sel
DO:
   apply 'choose' to bt-inserir-2 in frame f-pg-sel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-troca C-Win
ON OFF-END OF br-troca IN FRAME f-pg-sel
DO:
   apply 'entry' to bt-inserir-2 in frame f-pg-sel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-troca C-Win
ON ROW-DISPLAY OF br-troca IN FRAME f-pg-sel
DO:
  if avail tt-troca then do:
     enable bt-alterar-2 bt-retirar-2 with frame {&frame-name}.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-troca C-Win
ON ROW-LEAVE OF br-troca IN FRAME f-pg-sel
DO:


    /*  aqui que a grava‡Æo da linha da temp-table ‚ efetivada.
       Por‚m as valida‡äes dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment rio */

    if br-troca:NEW-ROW in frame f-pg-sel then 
    do transaction on error undo, return no-apply:
        create tt-troca.
        assign input browse br-troca tt-troca.it-codigo
               input browse br-troca tt-troca.descricao
               input browse br-troca tt-troca.un.

    end. 
    else if num-results('br-troca') > 0 then do transaction on error undo, return no-apply:
        br-troca:FETCH-SELECTED-ROW(1).
        assign input browse br-troca tt-troca.it-codigo
               input browse br-troca tt-troca.descricao
               input browse br-troca tt-troca.un.
    end.

    if br-troca:new-row then br-troca:create-result-list-entry() in frame f-pg-sel.       

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


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME bt-alterar-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-alterar-2 C-Win
ON CHOOSE OF bt-alterar-2 IN FRAME f-pg-sel /* Alterar */
DO:
  if  br-troca:num-selected-rows > 0 then 
     apply 'entry' to tt-troca.it-codigo in browse br-troca. 
  else
     return no-apply.
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
   apply "close" to this-procedure.
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
   if  can-find (first tt-troca) then
   do  on error undo, return no-apply:
       run pi-executar.
   end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME bt-inserir-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inserir-2 C-Win
ON CHOOSE OF bt-inserir-2 IN FRAME f-pg-sel /* Inserir */
DO:
    if  num-results('br-troca') > 0 then do:
        if  br-troca:insert-row('after') in frame f-pg-sel then.
    end.
    else do transaction:
        create tt-troca.
        open query br-troca
             for each tt-troca.
        apply 'entry' to tt-troca.it-codigo in browse br-troca. 
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-layout-elimina
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-layout-elimina C-Win
ON CHOOSE OF bt-layout-elimina IN FRAME f-pg-sel /* Layout */
DO:
    run esp/esce0111a.w (output c-importa).
    run pi-importa-arquivo (input "elimina":U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-retirar-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-retirar-2 C-Win
ON CHOOSE OF bt-retirar-2 IN FRAME f-pg-sel /* Retirar */
DO:
    if  br-troca:num-selected-rows > 0 then do on error undo, return no-apply:
        get current br-troca.
        delete tt-troca.
        if  br-troca:delete-current-row() in frame f-pg-sel then.
    end.

    if num-results ("br-troca") = 0 then 
       disable bt-alterar-2 bt-retirar-2 with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
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
&Scoped-define BROWSE-NAME br-digita
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.


{utp/ut9000.i "ESCE0111" "2.00.00.001"}

FIND FIRST param-global NO-LOCK NO-ERROR.
/* inicializa‡äes do template de relat¢rio */
{include/i-rpini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Testes do Browse br-troca */

/* Zoom p/ br-troca */
on  f5 of tt-troca.it-codigo in browse br-troca 
or  mouse-select-dblclick  of tt-troca.it-codigo in browse br-troca do:
    run pi-main-aux (input 4).
end.

/* Testa item digitado */
on  leave of tt-troca.it-codigo in browse br-troca do:
    run pi-main-aux (input 5).
end.

{include/i-rplbl.i}

{utp/ut-liter.i Troca Controle}
&if "{&PGSEL}" <> "" &then
    create text wh-label-sel
        assign frame        = frame f-relat:handle
               format       = "x(12)"
               screen-value = return-value
               width        = 12
               row          = 1.8
               col          = im-pg-sel:col in frame f-relat + 1.7
               visible      = yes
         triggers:
             on  mouse-select-click
                 apply "mouse-select-click" to im-pg-sel in frame f-relat.
         end triggers.
&endif

{utp/ut-liter.i Troca}
&if "{&PGDIG}" <> "" &then
    create text wh-label-dig
        assign frame        = frame f-relat:handle
               format       = "x(12)"
               screen-value = return-value
               width        = 12
               row          = 1.8
               col          = im-pg-sel:col in frame f-relat + 1.7
               visible      = yes
         triggers:
             on  mouse-select-click
                 apply "mouse-select-click" to im-pg-dig in frame f-relat.
         end triggers.
&endif

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.

    assign bt-faixa:hidden    in frame f-pg-sel = yes
           bt-faixa:sensitive in frame f-pg-sel = no.

    {include/i-rpmbl.i}

    /*{utp/ut-liter.i Listar_Itens * r}
    assign c-listagem = return-value.
    assign c-listagem:screen-value in frame f-pg-imp = return-value.*/
    
    RUN pi-main-block.

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
  ENABLE im-pg-dig im-pg-par im-pg-imp im-pg-sel bt-executar bt-cancelar 
         bt-ajuda 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY rs-destino c-arquivo rs-execucao c-listagem 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  ENABLE RECT-7 RECT-9 rs-destino bt-config-impr bt-arquivo c-arquivo 
         rs-execucao c-listagem 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  VIEW FRAME f-pg-dig IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-dig}
  ENABLE br-troca bt-inserir-2 bt-layout-elimina bt-faixa 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  DISPLAY c-lote dt-vali-lote RADIO-SET-1 dt-referencia 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  ENABLE c-lote dt-vali-lote RADIO-SET-1 dt-referencia 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy C-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  &IF DEFINED (bf_man_per_ppm) &THEN
    if param-global.modulo-per-ppm and
       valid-handle (h-cpapi020) then
        run pi-finalizar in h-cpapi020.
  &ENDIF

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize C-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

do  on error undo, return error
    on stop  undo, return error:     

    {include/i-rpexa.i}

    if  input frame f-pg-imp rs-destino = 2 then do:
        run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).
        if  return-value = "nok" then do:
            run utp/ut-msgs.p (input "show", input 73, input "").
            apply 'mouse-select-click' to im-pg-imp in frame f-relat.
            apply 'entry' to c-arquivo in frame f-pg-imp.
            return error.
        end.
    end.

    /* Coloque aqui as valida‡äes da p gina de Digita‡Æo, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p gina e colocar
       o focus no campo com problemas */

    for each tt-troca no-lock:
        assign r-tt-troca = rowid(tt-troca).

        /* Valida‡Æo de duplicidade de registro na temp-table tt-troca */
        find first b-tt-troca where b-tt-troca.it-codigo = tt-troca.it-codigo and 
                                     rowid(b-tt-troca) <> rowid(tt-troca) no-lock no-error.
        if avail b-tt-troca then do:
            apply "MOUSE-SELECT-CLICK":U to im-pg-sel in frame f-relat.
            reposition br-troca to rowid rowid(b-tt-troca).

            run utp/ut-msgs.p (input "show", input 108, input "").
            apply "ENTRY":U to tt-troca.it-codigo in browse br-troca.

            return error.
        END.

        if  not can-find(item where 
                         item.it-codigo = tt-troca.it-codigo) then do:
            assign browse br-troca:CURRENT-COLUMN = tt-troca.it-codigo:HANDLE in browse br-troca.

            apply "MOUSE-SELECT-CLICK":U to im-pg-sel in frame f-relat.
            reposition br-troca to rowid r-tt-troca.

            {utp/ut-table.i mgind item 1}
            run utp/ut-msgs.p (input 'show', input 56, input return-value).
            apply "ENTRY":U to tt-troca.it-codigo in browse br-troca.

            return error.
        end.
    end.

    find first param-global no-lock no-error.
    if  not avail param-global then do:
        run utp/ut-msgs.p (input "show", input 16, input "").
        return error.
    end.
    find first param-estoq no-lock no-error.
    if  not avail param-estoq then do:
        run utp/ut-msgs.p (input "show", input 1059, input "").
        return error.
    end.

    IF TRIM(c-lote:SCREEN-VALUE IN FRAME f-pg-par) = "" THEN DO:

        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 2158, INPUT "":U).
        APPLY "ENTRY":U TO c-lote IN FRAME f-pg-par.
        RETURN ERROR.
    END.

    IF DATE(dt-vali-lote:SCREEN-VALUE IN FRAME f-pg-par) = ? THEN DO:

        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 15021, INPUT "":U).
        APPLY "ENTRY":U TO dt-vali-lote IN FRAME f-pg-par.
        RETURN ERROR.
    END.

    IF DATE(dt-vali-lote:SCREEN-VALUE IN FRAME f-pg-par) < TODAY THEN DO:

        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 26638, INPUT "":U).
        APPLY "ENTRY":U TO dt-vali-lote IN FRAME f-pg-par.
        RETURN ERROR.
    END.

    IF DATE(dt-referencia:SCREEN-VALUE IN FRAME f-pg-par) = ? OR DATE(dt-referencia:SCREEN-VALUE IN FRAME f-pg-par) > TODAY THEN DO:

        RUN utp/ut-msgs.p (INPUT 'show',
                           INPUT 17006,
                           INPUT "Data de referˆncia inv lida!").

        APPLY "ENTRY":U TO dt-referencia IN FRAME f-pg-par.
        RETURN ERROR.
    END.

    create tt-param.
    assign tt-param.usuario       = c-seg-usuario
           tt-param.destino       = input frame f-pg-imp rs-destino
           tt-param.data-exec     = today
           tt-param.hora-exec     = time
           tt-param.lote          = INPUT FRAME f-pg-par c-lote
           tt-param.dt-vali-lote  = INPUT FRAME f-pg-par dt-vali-lote
           tt-param.dt-referencia = INPUT FRAME f-pg-par dt-referencia
           tt-param.i-tipo-exec   = INPUT FRAME f-pg-par radio-set-1.

    for each tt-troca:

        create tt-digita.
        assign tt-digita.it-codigo     = tt-troca.it-codigo   
               tt-digita.un            = tt-troca.un          
               tt-digita.descricao     = tt-troca.descricao.

    end.

    if  tt-param.destino = 1 then
        assign tt-param.arquivo = "".
    else
    if  tt-param.destino = 2 then 
        assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
    else
        assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".

    /* Coloque aqui a l¢gica de grava‡Æo dos parƒmtros e sele‡Æo na temp-table
       tt-param */ 

     {include/i-rpexb.i}

    if  session:set-wait-state("general") then.

    {include/i-rprun.i esp/esce0111rp.p}
    {include/i-rpexc.i}

    if  session:set-wait-state("") then.

    {include/i-rptrm.i}

    for each tt-digita:
        delete tt-digita.
    end.

    for each tt-troca:
        delete tt-troca.
    end.
    
    {&OPEN-QUERY-br-troca}

    if num-results ("br-troca") = 0 then 
       disable bt-alterar-2 bt-retirar-2 with frame f-pg-sel.
    else 
       enable bt-alterar-2 bt-retirar-2 with frame f-pg-sel.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa-arquivo C-Win 
PROCEDURE pi-importa-arquivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param c-opcao as char no-undo.
    ASSIGN l-altera = YES.

    if  c-importa <> "" then do:

        input from value(c-importa) NO-ECHO NO-CONVERT.

        repeat:

            import unformatted c-reg.

            assign c-item-a = right-trim(substr(c-reg,1,16))
                   c-item-n = right-trim(substr(c-reg,17,16))
                   c-un-ant = substr(c-reg,33,2)
                   c-un-atu = substr(c-reg,35,2)
                   i-ge     = integer(substr(c-reg, 37, 2))
                   de-fator = decimal(substr(c-reg, 39, 15)).

           find item
                where item.it-codigo   = c-item-a no-lock no-error.

           if c-opcao = "elimina":U then do:
              if not can-find (tt-troca where   /*Op‡Æo Layout*/
                               tt-troca.it-codigo = c-item-a) then do:
                 create tt-troca.
                 assign tt-troca.it-codigo = c-item-a
                        tt-troca.un        = if avail item then item.un else "".
                        tt-troca.descricao = if avail item then item.desc-item else "".
              end.
           end.    
        end.
        input close.
    end.

    OPEN QUERY br-troca FOR EACH tt-troca.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-main-aux C-Win 
PROCEDURE pi-main-aux :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter p-logica as integer no-undo.

    case p-logica:
        when 4 then do:
            if  not avail tt-troca 
                and not br-troca:new-row in frame f-pg-sel then
                    return no-apply.
            run pi-zoomvar-aux.
        end.
        when 5 then do:
            if num-results('br-troca') > 0 then do:
                find item
                    where item.it-codigo = tt-troca.it-codigo:screen-value
                    in browse br-troca no-lock no-error.
                if  avail item then do:
                    disp item.desc-item                        @ tt-troca.descricao
                         item.un                               @ tt-troca.un
                         with browse br-troca.
                end.
                else do:
                    disp "" @ tt-troca.descricao
                         "" @ tt-troca.un
                         with browse br-troca.
                end.
            end.
        end.
    end case.

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-main-block C-Win 
PROCEDURE pi-main-block :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF CAN-FIND(FIRST funcao
            WHERE funcao.cd-funcao = "spp-sgt"
              AND   funcao.ativo   = YES)  THEN DO:

    &IF "{&PGSEL}" <> "" &THEN
        HIDE FRAME {&PGSEL}.

        /* Facelift */
        &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
        /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
        IF VALID-HANDLE(wh-label-sel) THEN
            ASSIGN wh-label-sel:BGCOLOR = 18.
        &ENDIF

        im-pg-sel:LOAD-IMAGE("IMAGE/im-flddn":U) IN FRAME f-relat  .
        im-pg-sel:MOVE-TO-BOTTOM() IN FRAME f-relat.
        ASSIGN im-pg-sel:HEIGHT IN FRAME f-relat = 1
               im-pg-sel:ROW    IN FRAME f-relat = 1.6 .

        
    &ENDIF
    &IF "{&PGDIG}" <> "" &THEN
        VIEW FRAME {&PGDIG}.
        
        /* Facelift */
        &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
        /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
        IF VALID-HANDLE(wh-label-dig) THEN
            ASSIGN wh-label-dig:BGCOLOR = 17.
        &ENDIF

        
            RUN pi-first-child (INPUT FRAME {&PGDIG}:HANDLE).
                 im-pg-dig:LOAD-IMAGE("IMAGE/im-fldup":U) IN FRAME f-relat.
            ASSIGN im-pg-dig:HEIGHT IN FRAME f-relat = 1.20
                   im-pg-dig:ROW    IN FRAME f-relat = 1.5.


        
    &ENDIF
    &IF "{&PGIMP}" <> "" &THEN
        HIDE FRAME {&PGIMP}.
        
        /* Facelift */
        &IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
        /**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
        IF VALID-HANDLE(wh-label-imp) THEN
            ASSIGN wh-label-imp:BGCOLOR = 18.
        &ENDIF

        im-pg-imp:LOAD-IMAGE("IMAGE/im-flddn":U) IN FRAME f-relat .
        im-pg-imp:MOVE-TO-BOTTOM() IN FRAME f-relat .
        ASSIGN im-pg-imp:HEIGHT IN FRAME f-relat = 1
               im-pg-imp:ROW    IN FRAME f-relat = 1.6.
    &ENDIF
    

    ASSIGN im-pg-sel:SENSITIVE IN FRAME f-relat = NO
           wh-label-sel:SENSITIVE = NO.

END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina C-Win 
PROCEDURE pi-troca-pagina :
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoomvar-aux C-Win 
PROCEDURE pi-zoomvar-aux :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {include/zoomvar.i &prog-zoom=inzoom/z01in172.w
                       &campo=tt-troca.it-codigo
                       &campozoom=it-codigo
                       &browse=br-troca}.
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
  {src/adm/template/snd-list.i "tt-troca"}

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

