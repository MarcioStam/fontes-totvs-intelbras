&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgmov           PROGRESS
*/
&Scoped-define WINDOW-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/*:T *******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCEP025 2.04.00.000}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&SCOPED-DEFINE RPC-CALL       esp/cep/escep015rpc.r
        

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

  
   
{esp/ShowMsg.i}   
{upc\btb910za-upc.i}
{esp/es0018.i}
{esp/utp/acesso-rpc.i}

def temp-table tt-ae
    field c-selecionado as logical format "*/ " label "S" initial no 
    field nr-ae like ae-item.nr-ae format ">>>>>>9"
    field sequencia like ae-item.sequencia format ">>9"
    field quantidade like ae-item.quantidade.

def var l-congelado AS logical.
def var i-tipo      LIKE local.cod-tipo.
def var h-acomp     AS handle no-undo.
def var dt-trans    LIKE movto-estoq.dt-trans.
def var dt-validade AS date format "99/99/9999".
def var c-livre     AS char format "X(100)".
def var i-nr-ae-ini LIKE ae-item.nr-ae.
def var i-nr-ae-fim LIKE ae-item.nr-ae initial 999999.
def var i-seq-ini   LIKE ae-item.sequencia.
def var i-seq-fim   LIKE ae-item.sequencia initial 999.
def var i-nr-ae     LIKE ae-item.nr-ae.
DEF VAR c-vago      AS CHAR.
DEF VAR hproc AS HANDLE NO-UNDO.

def temp-table tt-vago
    field localizacao   like local.localizacao
    field it-codigo     like item.it-codigo
    field saldo         like saldo-estoq.qtidade-atu
    index codigo is primary localizacao.

DEF TEMP-TABLE tt-transf NO-UNDO
    FIELD it-codigo AS CHAR
    FIELD depos AS CHAR
    FIELD localizacao AS CHAR
    FIELD quantidade AS DEC
    FIELD nr-ae AS INT
    FIELD sequencia AS INT
    FIELD loc-dest AS CHAR
    FIELD usuario AS CHAR
    INDEX codigo nr-ae sequencia.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-aes

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ae saldo-estoq

/* Definitions for BROWSE br-aes                                        */
&Scoped-define FIELDS-IN-QUERY-br-aes tt-ae.c-selecionado tt-ae.nr-ae tt-ae.sequencia tt-ae.quantidade   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-aes   
&Scoped-define SELF-NAME br-aes
&Scoped-define QUERY-STRING-br-aes FOR EACH tt-ae                               by tt-ae.nr-ae                               by tt-ae.sequencia
&Scoped-define OPEN-QUERY-br-aes OPEN QUERY {&SELF-NAME} FOR EACH tt-ae                               by tt-ae.nr-ae                               by tt-ae.sequencia.
&Scoped-define TABLES-IN-QUERY-br-aes tt-ae
&Scoped-define FIRST-TABLE-IN-QUERY-br-aes tt-ae


/* Definitions for BROWSE br-saldos                                     */
&Scoped-define FIELDS-IN-QUERY-br-saldos saldo-estoq.it-codigo ~
saldo-estoq.qtidade-atu 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-saldos 
&Scoped-define QUERY-STRING-br-saldos FOR EACH saldo-estoq ~
      WHERE saldo-estoq.cod-estabel = v_cod_estab_usuar ~
and saldo-estoq.cod-depos = input frame {&frame-name} c-depos ~
and saldo-estoq.cod-localiz = input frame {&frame-name} c-loc-dest ~
and saldo-estoq.qtidade-atu > 0 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-saldos OPEN QUERY br-saldos FOR EACH saldo-estoq ~
      WHERE saldo-estoq.cod-estabel = v_cod_estab_usuar ~
and saldo-estoq.cod-depos = input frame {&frame-name} c-depos ~
and saldo-estoq.cod-localiz = input frame {&frame-name} c-loc-dest ~
and saldo-estoq.qtidade-atu > 0 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-saldos saldo-estoq
&Scoped-define FIRST-TABLE-IN-QUERY-br-saldos saldo-estoq


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-aes}~
    ~{&OPEN-QUERY-br-saldos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-inclui br-aes br-saldos RECT-7 rt-button 
&Scoped-Define DISPLAYED-OBJECTS c-it-codigo c-desc-item c-depos c-local ~
c-loc-dest 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 c-it-codigo c-depos c-local c-loc-dest 
&Scoped-define List-2 bt-ok bt-cancela 
&Scoped-define List-3 br-aes bt-todos bt-ini-fim bt-referencia bt-confirma 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-programa 
       MENU-ITEM mi-consultas   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
       MENU-ITEM mi-imprimir    LABEL "&Relat¢rios"    ACCELERATOR "CTRL-P"
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-livre MENUBAR
       SUB-MENU  mi-programa    LABEL "&Nome-do-Programa"
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancela 
     IMAGE-UP FILE "image/im-cancel.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "Cancela" 
     SIZE 4 BY 1.25 TOOLTIP "Cancela Transferància".

DEFINE BUTTON bt-confirma 
     LABEL "&Confirma" 
     SIZE 14 BY 1.13 TOOLTIP "Confirma Seleá∆o".

DEFINE BUTTON bt-inclui 
     IMAGE-UP FILE "image/im-add.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-add.bmp":U
     LABEL "Transfere" 
     SIZE 4 BY 1.25 TOOLTIP "Transfere".

DEFINE BUTTON bt-ini-fim 
     LABEL "&Inicio-Fim" 
     SIZE 14 BY 1.13 TOOLTIP "Seleá∆o de registros por faixa".

DEFINE BUTTON bt-ok 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-chck1.bmp":U
     LABEL "Confirma" 
     SIZE 4 BY 1.25 TOOLTIP "Confirma".

DEFINE BUTTON bt-referencia 
     LABEL "&Referància" 
     SIZE 14 BY 1.13 TOOLTIP "Seleciona registros".

DEFINE BUTTON bt-todos 
     LABEL "&Todos" 
     SIZE 14 BY 1.13 TOOLTIP "Seleciona todos os registros".

DEFINE VARIABLE c-depos AS CHARACTER FORMAT "X(3)":U 
     LABEL "Saida" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-loc-dest AS CHARACTER FORMAT "X(20)":U 
     LABEL "Entrada" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE c-local AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.72 BY 3.5.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89.72 BY 1.46
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-aes FOR 
      tt-ae SCROLLING.

DEFINE QUERY br-saldos FOR 
      saldo-estoq SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-aes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-aes w-livre _FREEFORM
  QUERY br-aes DISPLAY
      tt-ae.c-selecionado 
    tt-ae.nr-ae 
    tt-ae.sequencia 
    tt-ae.quantidade
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 56 BY 10
         FONT 1
         TITLE "AE" FIT-LAST-COLUMN.

DEFINE BROWSE br-saldos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-saldos w-livre _STRUCTURED
  QUERY br-saldos NO-LOCK DISPLAY
      saldo-estoq.it-codigo FORMAT "x(16)":U WIDTH 13.43
      saldo-estoq.qtidade-atu FORMAT "->>>,>>>,>>9.9999":U WIDTH 13.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 30.72 BY 11
         FONT 1
         TITLE "Saldos do Local" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-inclui AT ROW 1.17 COL 2 HELP
          "Transfere"
     c-it-codigo AT ROW 2.75 COL 18 COLON-ALIGNED
     c-desc-item AT ROW 2.75 COL 32 COLON-ALIGNED NO-LABEL
     c-depos AT ROW 3.75 COL 18 COLON-ALIGNED
     c-local AT ROW 3.75 COL 24 COLON-ALIGNED NO-LABEL
     c-loc-dest AT ROW 4.75 COL 18 COLON-ALIGNED
     bt-ok AT ROW 1.17 COL 6 HELP
          "Confirma"
     bt-cancela AT ROW 1.17 COL 10 HELP
          "Cancela Transferància"
     br-aes AT ROW 6.25 COL 1
     br-saldos AT ROW 6.25 COL 60
     bt-todos AT ROW 16.25 COL 1 HELP
          "Seleciona todos os registros"
     bt-ini-fim AT ROW 16.25 COL 15 HELP
          "Seleá∆o de registros por faixa"
     bt-referencia AT ROW 16.25 COL 29 HELP
          "Seleciona registros"
     bt-confirma AT ROW 16.25 COL 43 HELP
          "Confirma Seleá∆o"
     RECT-7 AT ROW 2.5 COL 1
     rt-button AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.29 BY 17.04
         FONT 1.


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
         TITLE              = "Transferància de Localizaá∆o"
         HEIGHT             = 18.58
         WIDTH              = 91.29
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.21
         VIRTUAL-WIDTH      = 195.14
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
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-aes bt-cancela f-cad */
/* BROWSE-TAB br-saldos br-aes f-cad */
/* SETTINGS FOR BROWSE br-aes IN FRAME f-cad
   3                                                                    */
/* SETTINGS FOR BUTTON bt-cancela IN FRAME f-cad
   NO-ENABLE 2                                                          */
/* SETTINGS FOR BUTTON bt-confirma IN FRAME f-cad
   NO-ENABLE 3                                                          */
/* SETTINGS FOR BUTTON bt-ini-fim IN FRAME f-cad
   NO-ENABLE 3                                                          */
/* SETTINGS FOR BUTTON bt-ok IN FRAME f-cad
   NO-ENABLE 2                                                          */
/* SETTINGS FOR BUTTON bt-referencia IN FRAME f-cad
   NO-ENABLE 3                                                          */
/* SETTINGS FOR BUTTON bt-todos IN FRAME f-cad
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN c-depos IN FRAME f-cad
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-codigo IN FRAME f-cad
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN c-loc-dest IN FRAME f-cad
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN c-local IN FRAME f-cad
   NO-ENABLE 1                                                          */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-aes
/* Query rebuild information for BROWSE br-aes
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ae
                              by tt-ae.nr-ae
                              by tt-ae.sequencia.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-aes */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-saldos
/* Query rebuild information for BROWSE br-saldos
     _TblList          = "mgmov.saldo-estoq"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "saldo-estoq.cod-estabel = v_cod_estab_usuar
and saldo-estoq.cod-depos = input frame {&frame-name} c-depos
and saldo-estoq.cod-localiz = input frame {&frame-name} c-loc-dest
and saldo-estoq.qtidade-atu > 0"
     _FldNameList[1]   > mgmov.saldo-estoq.it-codigo
"saldo-estoq.it-codigo" ? ? "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > mgmov.saldo-estoq.qtidade-atu
"saldo-estoq.qtidade-atu" ? ? "decimal" ? ? ? ? ? ? no ? no no "13.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-saldos */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* Transferància de Localizaá∆o */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */

  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* Transferància de Localizaá∆o */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-aes
&Scoped-define SELF-NAME br-aes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-aes w-livre
ON HELP OF br-aes IN FRAME f-cad /* AE */
DO:
  APPLY "choose" TO bt-confirma.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-aes w-livre
ON MOUSE-SELECT-DBLCLICK OF br-aes IN FRAME f-cad /* AE */
DO:
  APPLY "RETURN" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-aes w-livre
ON RETURN OF br-aes IN FRAME f-cad /* AE */
DO:
    assign tt-ae.c-selecionado = NOT tt-ae.c-selecionado.
    Br-aes:REFRESH().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-livre
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Cancela */
DO:
  DISABLE {&list-1} WITH FRAME {&FRAME-NAME}.
  DISABLE {&list-2} WITH FRAME {&FRAME-NAME}.

  ASSIGN /*c-depos:SCREEN-VALUE     IN FRAME f-cad = ""*/
         c-desc-item:SCREEN-VALUE IN FRAME f-cad = "" 
         c-it-codigo:SCREEN-VALUE IN FRAME f-cad = "" 
         /*c-local:SCREEN-VALUE     IN FRAME f-cad = "" */
         /*c-loc-dest:SCREEN-VALUE  IN FRAME f-cad = "" */.

  FOR EACH tt-ae:
      DELETE tt-ae.
  END.

  {&OPEN-QUERY-br-aes}
  {&OPEN-QUERY-br-saldos}

  DISABLE {&list-3} WITH FRAME {&FRAME-NAME}.

  ENABLE bt-inclui
      WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma w-livre
ON CHOOSE OF bt-confirma IN FRAME f-cad /* Confirma */
DO:
    IF AVAIL tt-ae THEN
        RUN pi-confirma.
    ELSE DO:
        MESSAGE "N∆o h† AE's selecionadas"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-inclui
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inclui w-livre
ON CHOOSE OF bt-inclui IN FRAME f-cad /* Transfere */
DO:
  ENABLE {&list-1} WITH FRAME {&FRAME-NAME}.
  ENABLE {&list-2} WITH FRAME {&FRAME-NAME}.
  DISABLE bt-inclui WITH FRAME {&FRAME-NAME}.

  FOR EACH tt-ae:
      DELETE tt-ae.
  END.

  {&OPEN-QUERY-br-aes}


  ASSIGN /*c-depos:SCREEN-VALUE     IN FRAME f-cad = ""*/
         c-desc-item:SCREEN-VALUE IN FRAME f-cad = "" 
         c-it-codigo:SCREEN-VALUE IN FRAME f-cad = "" 
         /*c-local:SCREEN-VALUE     IN FRAME f-cad = "" 
         c-loc-dest:SCREEN-VALUE  IN FRAME f-cad = ""*/. 
   
  {&OPEN-QUERY-br-saldos}

  APPLY "entry" TO c-it-codigo IN FRAME {&FRAME-NAME}.

  APPLY "choose" TO bt-inclui IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ini-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ini-fim w-livre
ON CHOOSE OF bt-ini-fim IN FRAME f-cad /* Inicio-Fim */
DO:
    assign i-nr-ae-ini = tt-ae.nr-ae
           i-nr-ae-fim = tt-ae.nr-ae
           i-seq-ini   = tt-ae.sequencia
           i-seq-fim   = tt-ae.sequencia.
    
    RUN pi-selecao.

    for each tt-ae
       where (tt-ae.nr-ae       >= i-nr-ae-ini
         and  tt-ae.sequencia   >= i-seq-ini
         and  tt-ae.sequencia   <= i-seq-fim)
         and (tt-ae.nr-ae       <= i-nr-ae-fim
         and  tt-ae.sequencia   >= i-seq-ini
         and  tt-ae.sequencia   <= i-seq-fim):
         assign tt-ae.c-selecionado = yes.
    end.
    br-aes:refresh().
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-livre
ON CHOOSE OF bt-ok IN FRAME f-cad /* Confirma */
DO:



    FIND FIRST deposito NO-LOCK WHERE
               deposito.cod-depos = INPUT FRAME f-cad c-depos NO-ERROR.
    IF NOT AVAIL deposito THEN DO:
       MESSAGE "Dep¢sito n∆o cadastrado" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
       APPLY "entry" TO c-depos.
       RETURN NO-APPLY.
    END.

    FIND FIRST local NO-LOCK WHERE
               local.cod-estabel = v_cod_estab_usuar and
               local.cod-depos   = INPUT FRAME f-cad c-depos AND
               local.localizacao = INPUT FRAME f-cad c-local NO-ERROR.
    IF NOT AVAIL local                     AND 
        INPUT FRAME f-cad c-local <> ""    AND
        INPUT FRAME f-cad c-depos <> "inj" THEN DO:
        MESSAGE "Localizaá∆o n∆o cadastrada" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        APPLY "entry" TO c-local.
        RETURN NO-APPLY.
    END.

    FIND FIRST local NO-LOCK WHERE
               local.cod-estabel = v_cod_estab_usuar and
               local.cod-depos   = INPUT FRAME f-cad c-depos AND
               local.localizacao = INPUT FRAME f-cad c-loc-dest NO-ERROR.
    IF NOT AVAIL local                    AND 
       INPUT FRAME f-cad c-depos <> "inj" THEN DO:
       MESSAGE "Localizaá∆o n∆o cadastrada" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
       APPLY "entry" TO c-loc-dest.
       RETURN NO-APPLY.
    END.

    FIND first local NO-LOCK WHERE
               local.cod-estabel = v_cod_estab_usuar and
               local.cod-depos   = INPUT FRAME f-cad c-depos and
               local.localizacao = INPUT FRAME f-cad c-loc-dest NO-ERROR.
    FIND first item-tipo-loc NO-LOCK WHERE
               item-tipo-loc.it-codigo = INPUT FRAME f-cad c-it-codigo AND
               item-tipo-loc.cod-estabel = v_cod_estab_usuar and
               item-tipo-loc.cod-depos = INPUT FRAME f-cad c-depos  and
               item-tipo-loc.cod-tipo  = local.cod-tipo  NO-ERROR.
    IF NOT AVAIL item-tipo-loc THEN DO:
       MESSAGE "Esta localizaá∆o n∆o pode ser usada por este item" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
       APPLY "choose" TO bt-inclui.
       RETURN NO-APPLY.
    END.

    ENABLE {&list-3} WITH FRAME {&FRAME-NAME}.
    DISABLE {&list-1} WITH FRAME {&FRAME-NAME}.
    DISABLE bt-ok WITH FRAME {&FRAME-NAME}.
    RUN open-ae.
    {&OPEN-QUERY-br-saldos}  


    
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-referencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-referencia w-livre
ON CHOOSE OF bt-referencia IN FRAME f-cad /* Referància */
DO:
    for each tt-ae
       where tt-ae.nr-ae         = i-nr-ae
         and tt-ae.sequencia    >= i-seq-ini
         and tt-ae.sequencia    <= i-seq-fim:
        assign tt-ae.c-selecionado = yes.
    end.
    br-aes:refresh().
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-todos w-livre
ON CHOOSE OF bt-todos IN FRAME f-cad /* Todos */
DO:
    for each tt-ae:
        assign tt-ae.c-selecionado = yes.
    end.
    br-aes:refresh().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos w-livre
ON F5 OF c-depos IN FRAME f-cad /* Saida */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                       &campo="c-depos"
                       &campozoom="cod-depos"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos w-livre
ON MOUSE-SELECT-DBLCLICK OF c-depos IN FRAME f-cad /* Saida */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo w-livre
ON F5 OF c-it-codigo IN FRAME f-cad /* Item */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in172.w"
                       &campo="c-it-codigo"
                       &campozoom="it-codigo"
                       &campo2="c-desc-item"
                       &campozoom2="desc-item"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo w-livre
ON LEAVE OF c-it-codigo IN FRAME f-cad /* Item */
DO:
  FIND FIRST ITEM NO-LOCK
      WHERE ITEM.it-codigo = INPUT FRAME {&FRAME-NAME} c-it-codigo NO-ERROR.
  ASSIGN c-desc-item:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAIL ITEM THEN ITEM.desc-item ELSE "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo w-livre
ON MOUSE-SELECT-DBLCLICK OF c-it-codigo IN FRAME f-cad /* Item */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-loc-dest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-loc-dest w-livre
ON F5 OF c-loc-dest IN FRAME f-cad /* Entrada */
DO:
    RUN pi-local-dest.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-loc-dest w-livre
ON MOUSE-SELECT-DBLCLICK OF c-loc-dest IN FRAME f-cad /* Entrada */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-loc-dest w-livre
ON RETURN OF c-loc-dest IN FRAME f-cad /* Entrada */
DO:
  APPLY "choose" TO bt-ok.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-local
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-local w-livre
ON F5 OF c-local IN FRAME f-cad
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} c-depos
           INPUT FRAME {&FRAME-NAME} c-it-codigo
           i-nr-ae = i-nr-ae-ini.      

    RUN esp/cep/escep015A.w (INPUT-OUTPUT c-local,
                             INPUT-OUTPUT c-depos,     
                             INPUT-OUTPUT c-it-codigo, 
                             INPUT-OUTPUT i-nr-ae-ini, 
                             INPUT-OUTPUT i-seq-ini,   
                             INPUT-OUTPUT i-seq-fim,   
                             INPUT-OUTPUT i-nr-ae).     
    DISP c-local 
        WITH FRAME f-cad.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-local w-livre
ON MOUSE-SELECT-DBLCLICK OF c-local IN FRAME f-cad
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-consultas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-consultas w-livre
ON CHOOSE OF MENU-ITEM mi-consultas /* Consultas */
DO:
  RUN pi-consulta IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo w-livre
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-imprimir w-livre
ON CHOOSE OF MENU-ITEM mi-imprimir /* Relat¢rios */
DO:
  RUN pi-imprimir IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-programa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-programa w-livre
ON MENU-DROP OF MENU mi-programa /* Nome-do-Programa */
DO:
  run pi-disable-menu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sair w-livre
ON CHOOSE OF MENU-ITEM mi-sair /* Sair */
DO:
  RUN pi-sair IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-livre
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-livre 


/* ***************************  Main Block  *************************** */

c-it-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name}.
c-local:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name}.
c-loc-dest:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name}.
c-depos:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name}.

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}




/* FIM */

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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'panel/p-exihel.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-exihel ).
       RUN set-position IN h_p-exihel ( 1.17 , 74.14 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             bt-confirma:HANDLE IN FRAME f-cad , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE congelado w-livre 
PROCEDURE congelado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter co-it-codigo like item.it-codigo.
    def input parameter co-cod-depos like saldo-estoq.cod-depos.
    def input parameter co-localizacao like saldo-estoq.cod-localiz.

    if co-localizacao <> ? then do:
        find saldo-estoq no-lock
             where saldo-estoq.cod-estabel = v_cod_estab_usuar
               and saldo-estoq.cod-depos   = co-cod-depos
               and saldo-estoq.it-codigo   = co-it-codigo
               and saldo-estoq.cod-localiz = co-localizacao no-error.
        if not avail saldo-estoq then do:
            assign l-congelado = no.
            /*RETURN "NOK".*/
        end.
        ELSE DO:
            find int-saldo-estoq no-lock 
                 where int-saldo-estoq.cod-estabel = saldo-estoq.cod-estabel
                   and int-saldo-estoq.cod-depos   = saldo-estoq.cod-depos
                   and int-saldo-estoq.it-codigo   = saldo-estoq.it-codigo
                   and int-saldo-estoq.cod-localiz = saldo-estoq.cod-localiz no-error.
            if avail int-saldo-estoq and int-saldo-estoq.log-congelado then 
                assign l-congelado = yes.
            else    
                assign l-congelado = no.
        END.
    end.
    else do:
        assign l-congelado = no.
        for each saldo-estoq FIELDS(cod-estabel cod-depos it-codigo cod-localiz) no-lock 
             where saldo-estoq.cod-estabel = v_cod_estab_usuar
               and saldo-estoq.cod-depos   = co-cod-depos
               and saldo-estoq.it-codigo   = co-it-codigo :
            find int-saldo-estoq no-lock 
                 where int-saldo-estoq.cod-estabel = saldo-estoq.cod-estabel
                   and int-saldo-estoq.cod-depos   = saldo-estoq.cod-depos
                   and int-saldo-estoq.it-codigo   = saldo-estoq.it-codigo
                   and int-saldo-estoq.cod-localiz = saldo-estoq.cod-localiz no-error.
            if avail int-saldo-estoq and int-saldo-estoq.log-congelado then 
                assign l-congelado = yes.
        end.
    end.


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
  DISPLAY c-it-codigo c-desc-item c-depos c-local c-loc-dest 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE bt-inclui br-aes br-saldos RECT-7 rt-button 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
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

  {utp/ut9000.i "ESCEP015" "2.04.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  run pi-after-initialize.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mostraMensagemPanico w-livre 
PROCEDURE mostraMensagemPanico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN ShowMessage (1, "Erro na execuá∆o", 
                      "Ocorreu um erro durante a execuá∆o de um procedimento " +
                      "remoto que impede que esta operaá∆o continue.~n" +
                      "Por favor repita esta operaá∆o mais tarde").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE open-ae w-livre 
PROCEDURE open-ae :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    for each tt-ae:
        delete tt-ae.
    end.

    for each ae-item no-lock
       where ae-item.cod-estabel = v_cod_estab_usuar
         and ae-item.it-codigo   = INPUT FRAME f-cad c-it-codigo
         and ae-item.localizacao = INPUT FRAME f-cad c-local
         and ae-item.situacao    = NO:
         create tt-ae.
         assign tt-ae.nr-ae      = ae-item.nr-ae
                tt-ae.sequencia  = ae-item.sequencia
                tt-ae.quantidade = ae-item.quantidade.
    end.

    {&OPEN-QUERY-br-aes}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-confirma w-livre 
PROCEDURE pi-confirma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR c-msg-erro AS CHAR NO-UNDO.


    /* main-block */

    IF NOT VALID-HANDLE(hproc) THEN DO:
        RUN conecta-rpc IN THIS-PROCEDURE (output hproc).
        
        IF RETURN-VALUE = "NOK" THEN DO:
            RUN ShowMessage (1, "Erro na conex∆o com o servidor RPC", 
                                "N∆o foi poss°vel conectar o servidor RPC. Encaminhe esta mensagem para TIC. Mensagem:" + c-msg-erro).
        
            APPLY "CLOSE":U TO THIS-PROCEDURE.
        END.
    END.
    
    /* Autenticaá∆o usu†rio TOTVS11 RPC */
    create tt-control-prog.
    assign tt-control-prog.cod-versao-integracao = 1.
    
    assign tt-control-prog.wgh-servid-rpc = hproc.
    
    run btb/btb923za.p (input-output table tt-control-prog).

    /* main-block */

    ASSIGN INPUT FRAME {&FRAME-NAME}
            c-it-codigo
            c-depos
            c-loc-dest.

   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Gerando AE").

   EMPTY TEMP-TABLE tt-transf.

   for each tt-ae
      where tt-ae.c-selecionado:

        run pi-acompanhar in h-acomp (INPUT "AE: " + string(tt-ae.nr-ae)    + " " + string(tt-ae.sequencia)).
   
        find ae-item NO-LOCK 
           where ae-item.cod-estabel = v_cod_estab_usuar
             and ae-item.nr-ae      = tt-ae.nr-ae
             and ae-item.sequencia  = tt-ae.sequencia
             and ae-item.it-codigo  = c-it-codigo NO-ERROR.
        run congelado(input c-it-codigo,
                      input c-depos,
                      input ae-item.localizacao).

        if l-congelado then do:
            message "Item/Deposito/Localizacao de Origem Congelada para Inventario." view-as alert-box.
            APPLY "choose" TO bt-cancela.
            APPLY "choose" TO bt-inclui.
            RETURN.
        end.
                      
        run congelado(input c-it-codigo,
                      input c-depos,
                      input c-loc-dest).

        if l-congelado then do:
           message "Item/Deposito/Localizacao de Destino Congelada para Inventario." view-as alert-box.
           APPLY "choose" TO bt-cancela.
           APPLY "choose" TO bt-inclui.
           RETURN.
        end.

        CREATE tt-transf.
        ASSIGN tt-transf.it-codigo   = c-it-codigo
               tt-transf.depos       = c-depos
               tt-transf.localizacao = ae-item.localizacao
               tt-transf.quantidade  = ae-item.quantidade
               tt-transf.nr-ae       = ae-item.nr-ae    
               tt-transf.sequencia   = ae-item.sequencia
               tt-transf.loc-dest    = c-loc-dest
               tt-transf.usuario     = c-seg-usuario.
             
    end.

    RUN pi-finalizar IN h-acomp.

    IF VALID-HANDLE(hproc) THEN DO:
        SESSION:SET-WAIT-STATE("GENERAL":U).
        RUN {&RPC-CALL} ON SERVER hproc (input v_cod_estab_usuar,
                                         INPUT TABLE tt-transf,
                                         OUTPUT c-msg-erro).
        SESSION:SET-WAIT-STATE("":U).
        
        if return-value = "NOK" then do:
           IF c-msg-erro > "" THEN DO:
               RUN ShowMessage (1, entry(1, c-msg-erro, "|"), 
                                IF NUM-ENTRIES(c-msg-erro, "|") = 2 THEN entry(2, c-msg-erro, "|") ELSE "" ) .
           END.
           APPLY "choose" TO bt-cancela.
           APPLY "choose" TO bt-inclui.
        end.
        ELSE DO:
           message "Transferencia executada com sucesso" view-as alert-box.
           APPLY "choose" TO bt-cancela.
           APPLY "choose" TO bt-inclui.
        end.

    END.
    ELSE DO:
        RUN ShowMessage (1, "Erro na conex∆o com o servidor RPC", 
                            "N∆o foi poss°vel conectar o servidor RPC. Entre em contato com o respons†vel em TI").
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.

    /* destroy */
    RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
  hproc = ?.


  RELEASE ae-item.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-local-dest w-livre 
PROCEDURE pi-local-dest :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

find first local no-lock
     where local.cod-estabel = v_cod_estab_usuar
       and local.cod-depos   = INPUT FRAME f-cad c-depos
       and local.localizacao = INPUT FRAME f-cad c-local no-error.
IF AVAIL local THEN 
    assign i-tipo = local.cod-tipo.   

find first item-tipo-loc no-lock
     where item-tipo-loc.it-codigo = INPUT FRAME f-cad c-it-codigo
       and item-tipo-loc.cod-estabel = v_cod_estab_usuar
       and item-tipo-loc.cod-tipo  = i-tipo no-error.
if avail item-tipo-loc then 
      assign c-vago = string(item-tipo-loc.quantidade,">>,>>>,>>9.99").
else assign c-vago = "0".

for each tt-vago:
  delete tt-vago.
end.

for each local NO-LOCK
   where local.cod-estabel = v_cod_estab_usuar
     and local.cod-depos = INPUT FRAME f-cad c-depos,
    each item-tipo-loc no-lock
   where item-tipo-loc.it-codigo  = INPUT FRAME f-cad c-it-codigo
     and item-tipo-loc.cod-estabel = v_cod_estab_usuar
     and item-tipo-loc.cod-tipo   = local.cod-tipo:
      find first saldo-estoq use-index estabel-dep
          where saldo-estoq.cod-estabel = v_cod_estab_usuar
            and saldo-estoq.cod-depos   = INPUT FRAME f-cad c-depos
            and saldo-estoq.cod-localiz = local.localizacao 
            and saldo-estoq.qtidade-atu > 0 no-lock no-error.
      if avail saldo-estoq then do:
          for each saldo-estoq FIELDS(cod-estabel cod-depos cod-localiz qtidade-atu it-codigo) use-index estabel-dep no-lock
          where saldo-estoq.cod-estabel = v_cod_estab_usuar
            and saldo-estoq.cod-depos   = INPUT FRAME f-cad c-depos
            and saldo-estoq.cod-localiz = local.localizacao
            and saldo-estoq.qtidade-atu > 0:
              create tt-vago.
              assign tt-vago.localizacao = local.localizacao
                     tt-vago.it-codigo   = saldo-estoq.it-codigo
                     tt-vago.saldo       = saldo-estoq.qtidade-atu.
          end.
      end.    
      else do:
          create tt-vago.
          assign tt-vago.localizacao = local.localizacao
                 tt-vago.it-codigo   = ""
                 tt-vago.saldo       = 0.
      end.
end.

RUN esp\cep\escep015b.w (INPUT TABLE tt-vago, 
                         INPUT c-vago,
                         OUTPUT c-loc-dest).

DISPLAY c-loc-dest
    WITH FRAME f-cad.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-selecao w-livre 
PROCEDURE pi-selecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 12 BY 1.13
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 12 BY 1.13
     BGCOLOR 8 .

DEFINE VARIABLE fi-nr-ae-fim AS INTEGER FORMAT "9999999" INITIAL 0 
     LABEL "Nr AE" 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88.

DEFINE VARIABLE fi-nr-ae-ini AS INTEGER FORMAT "9999999" INITIAL 0 
     LABEL "Nr AE" 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88.

DEFINE VARIABLE fi-seq-fim AS INTEGER FORMAT "999" INITIAL 0 
     LABEL "Sequencia" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88.

DEFINE VARIABLE fi-seq-ini AS INTEGER FORMAT "999" INITIAL 0 
     LABEL "Sequencia" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 64.14 BY 1.75
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 64.14 BY 2.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 64.14 BY 2.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fselecao
     fi-nr-ae-ini AT ROW 2 COL 19 COLON-ALIGNED
     fi-seq-ini AT ROW 2 COL 43 COLON-ALIGNED
     fi-nr-ae-fim AT ROW 4.25 COL 19 COLON-ALIGNED
     fi-seq-fim AT ROW 4.25 COL 43 COLON-ALIGNED
     Btn_OK AT ROW 6.08 COL 2
     Btn_Cancel AT ROW 6.08 COL 14
     RECT-10 AT ROW 5.75 COL 1
     RECT-8 AT ROW 1.25 COL 1
     RECT-9 AT ROW 3.5 COL 1
     " Inicial" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 1 COL 2
     " Final" VIEW-AS TEXT
          SIZE 4 BY .54 AT ROW 3.33 COL 2
     SPACE(59.13) SKIP(3.70)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "Seleá∆o de AEs"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.

ON CHOOSE OF Btn_OK IN FRAME fselecao /* OK */
DO:
  ASSIGN i-nr-ae-ini = INPUT FRAME fselecao fi-nr-ae-ini
         i-seq-ini   = INPUT FRAME fselecao fi-seq-ini
         i-nr-ae-fim = INPUT FRAME fselecao fi-nr-ae-fim
         i-seq-fim   = INPUT FRAME fselecao fi-seq-fim.
END.

ASSIGN fi-nr-ae-ini = i-nr-ae-ini
       fi-seq-ini   = i-seq-ini
       fi-nr-ae-fim = i-nr-ae-fim
       fi-seq-fim   = i-seq-fim.

DISPLAY fi-nr-ae-ini fi-seq-ini fi-nr-ae-fim fi-seq-fim 
  WITH FRAME fselecao.
ENABLE fi-nr-ae-ini fi-seq-ini fi-nr-ae-fim fi-seq-fim Btn_OK Btn_Cancel 
     RECT-10 RECT-8 RECT-9 
  WITH FRAME fselecao.
VIEW FRAME fselecao.

WAIT-FOR GO OF FRAME fselecao.

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
  {src/adm/template/snd-list.i "saldo-estoq"}
  {src/adm/template/snd-list.i "tt-ae"}

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

