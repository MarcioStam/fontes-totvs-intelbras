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
{include/i-prgvrs.i XX9999 9.99.99.999}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escqp014
&GLOBAL-DEFINE Version        3.00.00.000

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp bt-param bt-atualiza btAprovar btRejeitar brFichaCQ
                              
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{esp/cqp/escqp014.i}

def var l-cliente       as logical no-undo.
def var l-nr-ac-ex      as logical no-undo.
def var l-rejeita       as logical no-undo.
def var l-rej-desab     as logical no-undo.
def var l-disab         as logical no-undo.
def var l-cancela       as logical no-undo.
def var l-ok            as logical no-undo.
def var de-inspecao     as date    no-undo.
def var c-op-des        as char    no-undo.
def var c-rejeitado     as char    no-undo.
def var c-codigo        as char    no-undo.
def var c-emite         as char    no-undo.
def var c-texto         as char    no-undo.
def var c-dep-rej       as char    no-undo.
def var r-rej           as rowid   no-undo.
def var i-ord-prod      as integer no-undo.
def var i-oper          as integer no-undo.
def var de-aprov-ant    as integer no-undo.
def var l-fraciona      as logical no-undo.
def var de-qt-aprovada  as integer no-undo.
def var de-qt-apr-cond  as integer no-undo.
def var de-qt-rejeitada as integer no-undo.
def var de-qt-consumida as integer no-undo.
def var de-original     as integer no-undo.
def var iNrTransMovto   as integer no-undo.

def buffer b-ficha-cq    for ficha-cq.


DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE l-loc-unica                         AS LOGICAL      NO-UNDO.
DEFINE VARIABLE l-deleta-erros                      AS LOGICAL      NO-UNDO.
DEFINE VARIABLE c-cod-deposito                      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-cod-localizacao                   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-lote                              AS CHARACTER    NO-UNDO.
DEFINE VARIABLE h-bosc138                           AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-wm9005a                           AS HANDLE       NO-UNDO.
DEFINE VARIABLE hDBOsc032                           AS HANDLE       NO-UNDO.
DEFINE VARIABLE deQtdAprovada                       AS DECIMAL      NO-UNDO.
DEF VAR h-ceapi001k      AS HANDLE NO-UNDO.
DEF VAR h-cdapi024       AS HANDLE NO-UNDO.
DEF VAR c-unid-negoc     AS CHAR NO-UNDO.
DEF VAR c-unid-negoc-des AS CHAR NO-UNDO.
//{method/dbotterr.i}
{cep/ceapi001k.i}
{cdp/cd9590.i}
{cdp/cd0666.i}
DEF BUFFER b-tt-movto FOR tt-movto.

DEFINE TEMP-TABLE ttWm-box-movto NO-UNDO LIKE wm-box-movto
       FIELD id-saldo    LIKE wm-box-saldo.id-saldo
       FIELD id-etiqueta LIKE wm-etiqueta.id-etiqueta
       FIELD RowNum      AS INTEGER
       FIELD r-rowid     AS ROWID
       INDEX w-aux2 IS UNIQUE id-saldo.

DEF TEMP-TABLE tt-box-etiqueta NO-UNDO
    FIELD cod-estabel    LIKE wm-box-movto.cod-estabel
    FIELD cod-local      LIKE wm-box-movto.cod-local
    FIELD id-movto       LIKE wm-box-movto.id-movto
    FIELD ind-tipo-movto LIKE wm-box-movto.ind-tipo-movto
    FIELD id-saldo       like wm-box-saldo-etiqueta.id-saldo
    FIELD id-etiqueta    like wm-box-saldo-etiqueta.id-etiqueta
    FIELD id-agrupador   LIKE wm-etiqueta.id-agrupador
    FIELD tipo-etiq      like wm-etiqueta.ind-sit-agrupador
    FIELD qtd-item       like wm-etiqueta.qtd-item
    FIELD qtd-retirado   like wm-etiqueta.qtd-item-retirado
    FIELD qtd-amostra    LIKE wm-etiqueta.qtd-item-retirado.

DEFINE VARIABLE deQtdRejeitada AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-saldo-endereco AS DECIMAL     NO-UNDO.

DEFINE BUFFER b-wm-box-movto FOR wm-box-movto.
DEFINE BUFFER b-wm-box-movto-ent FOR wm-box-movto.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brFichaCQ

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ficha-cq

/* Definitions for BROWSE brFichaCQ                                     */
&Scoped-define FIELDS-IN-QUERY-brFichaCQ tt-ficha-cq.nr-ficha tt-ficha-cq.des-situacao tt-ficha-cq.cod-estabel tt-ficha-cq.cod-deposito-pad tt-ficha-cq.dt-ficha tt-ficha-cq.it-codigo tt-ficha-cq.desc-item tt-ficha-cq.cod-emitente tt-ficha-cq.nome-abrev tt-ficha-cq.nro-docto tt-ficha-cq.des-origem tt-ficha-cq.skipe-lote tt-ficha-cq.num-pedido tt-ficha-cq.item-critico tt-ficha-cq.qt-original tt-ficha-cq.qt-aprovada tt-ficha-cq.qt-rejeitada tt-ficha-cq.cod-usuario tt-ficha-cq.dt-analise tt-ficha-cq.hr-analise tt-ficha-cq.cod-depos tt-ficha-cq.baixa-estoq tt-ficha-cq.log-wms   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brFichaCQ   
&Scoped-define SELF-NAME brFichaCQ
&Scoped-define QUERY-STRING-brFichaCQ FOR EACH tt-ficha-cq
&Scoped-define OPEN-QUERY-brFichaCQ OPEN QUERY {&SELF-NAME} FOR EACH tt-ficha-cq.
&Scoped-define TABLES-IN-QUERY-brFichaCQ tt-ficha-cq
&Scoped-define FIRST-TABLE-IN-QUERY-brFichaCQ tt-ficha-cq


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brFichaCQ}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 bt-param bt-atualiza ~
btQueryJoins btReportsJoins btExit btHelp brFichaCQ btAprovar btRejeitar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
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
DEFINE BUTTON bt-atualiza 
     IMAGE-UP FILE "image\toolbar\im-chck1":U
     IMAGE-INSENSITIVE FILE "image\toolbar\ii-chck1":U
     LABEL "Atualizar" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON bt-param 
     IMAGE-UP FILE "image\toolbar\im-param":U
     IMAGE-INSENSITIVE FILE "image\toolbar\ii-param":U
     LABEL "Parƒmetros" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btAprovar 
     LABEL "Aprovar" 
     SIZE 15 BY 1.13.

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

DEFINE BUTTON btMotivo 
     LABEL "Motivo" 
     SIZE 15 BY 1.13.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btRejeitar 
     LABEL "Rejeitar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 154 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brFichaCQ FOR 
      tt-ficha-cq SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brFichaCQ
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brFichaCQ wWindow _FREEFORM
  QUERY brFichaCQ DISPLAY
      tt-ficha-cq.nr-ficha          WIDTH 08
          tt-ficha-cq.des-situacao      WIDTH 15
          tt-ficha-cq.cod-estabel       WIDTH 05
          tt-ficha-cq.cod-deposito-pad  
          tt-ficha-cq.dt-ficha          WIDTH 10 
          tt-ficha-cq.it-codigo         WIDTH 15
          tt-ficha-cq.desc-item         WIDTH 45
          tt-ficha-cq.cod-emitente      WIDTH 07
          tt-ficha-cq.nome-abrev        WIDTH 10
          tt-ficha-cq.nro-docto         WIDTH 08
          tt-ficha-cq.des-origem        WIDTH 08
          tt-ficha-cq.skipe-lote
          tt-ficha-cq.num-pedido
          tt-ficha-cq.item-critico
          tt-ficha-cq.qt-original       WIDTH 12
          tt-ficha-cq.qt-aprovada       WIDTH 12
          tt-ficha-cq.qt-rejeitada      WIDTH 12
          tt-ficha-cq.cod-usuario       WIDTH 08
          tt-ficha-cq.dt-analise        WIDTH 10 
          tt-ficha-cq.hr-analise        WIDTH 10
          tt-ficha-cq.cod-depos         WIDTH 05
          tt-ficha-cq.baixa-estoq       WIDTH 10 FORMAT "Sim/NÆo"
          tt-ficha-cq.log-wms           WIDTH 10 FORMAT "Sim/NÆo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 182 BY 24.75
         FONT 10
         TITLE "Monitor Qualidade".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-param AT ROW 1.13 COL 3 HELP
          "Parƒmetros" WIDGET-ID 4
     bt-atualiza AT ROW 1.13 COL 7.29 HELP
          "Atualizar" WIDGET-ID 2
     btQueryJoins AT ROW 1.13 COL 137.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 141.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 145.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 149.72 HELP
          "Ajuda"
     brFichaCQ AT ROW 2.75 COL 1 WIDGET-ID 1000
     btAprovar AT ROW 27.75 COL 1 WIDGET-ID 8
     btRejeitar AT ROW 27.75 COL 16 WIDGET-ID 12
     btMotivo AT ROW 27.75 COL 31 WIDGET-ID 10
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 182.86 BY 28.08
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
         TITLE              = "Monitor Qualidade"
         HEIGHT             = 28.08
         WIDTH              = 182.86
         MAX-HEIGHT         = 28.08
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 28.08
         VIRTUAL-WIDTH      = 182.86
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
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brFichaCQ btHelp fpage0 */
/* SETTINGS FOR BUTTON btMotivo IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brFichaCQ
/* Query rebuild information for BROWSE brFichaCQ
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ficha-cq
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brFichaCQ */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Monitor Qualidade */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Monitor Qualidade */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brFichaCQ
&Scoped-define SELF-NAME brFichaCQ
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brFichaCQ wWindow
ON ROW-DISPLAY OF brFichaCQ IN FRAME fpage0 /* Monitor Qualidade */
DO:

    IF tt-ficha-cq.des-situacao = "Terminado"   THEN ASSIGN tt-ficha-cq.des-situacao:BGCOLOR IN BROWSE brFichaCQ  = 10.
    IF tt-ficha-cq.des-situacao = "Pendente"    THEN ASSIGN tt-ficha-cq.des-situacao:BGCOLOR IN BROWSE brFichaCQ  = 12.
    IF tt-ficha-cq.des-situacao = "Em An lise"  THEN ASSIGN tt-ficha-cq.des-situacao:BGCOLOR IN BROWSE brFichaCQ  = 14.
    IF tt-ficha-cq.item-critico = "X"           THEN ASSIGN tt-ficha-cq.item-critico:BGCOLOR IN BROWSE brFichaCQ  = 12.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brFichaCQ wWindow
ON VALUE-CHANGED OF brFichaCQ IN FRAME fpage0 /* Monitor Qualidade */
DO:

    ASSIGN  btAprovar   :SENSITIVE = (tt-ficha-cq.des-situacao <> "Terminado")
            btRejeitar  :SENSITIVE = btAprovar:SENSITIVE
            btMotivo    :SENSITIVE = (tt-ficha-cq.des-origem = "Compras").
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-atualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-atualiza wWindow
ON CHOOSE OF bt-atualiza IN FRAME fpage0 /* Atualizar */
DO:
    RUN piCriaParametros.
    RUN piAtualiza.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-param
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-param wWindow
ON CHOOSE OF bt-param IN FRAME fpage0 /* Parƒmetros */
DO:
    DEFINE VARIABLE h-windows AS HANDLE      NO-UNDO.
    RUN piCriaParametros.

    ASSIGN  h-windows           = ACTIVE-WINDOW
            h-windows:SENSITIVE = NO.
    RUN esp/cqp/escqp014a.w (INPUT-OUTPUT TABLE tt-parametros).
    ASSIGN h-windows:SENSITIVE = YES.

    //APPLY "choose" TO bt-atualiza.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAprovar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAprovar wWindow
ON CHOOSE OF btAprovar IN FRAME fpage0 /* Aprovar */
DO:
    IF AVAIL tt-ficha-cq
    THEN DO:
        IF tt-ficha-cq.log-wms = NO THEN DO:
            RUN utp/ut-msgs.p ( INPUT "SHOW",
                                INPUT 15825,
                                INPUT "Aprova‡Æo desta ficha deve ser realizada atrav‚s do programa CQ0210~~Aprova‡Æo desta ficha deve ser realizada atrav‚s do programa CQ0210").
            RETURN NO-APPLY.
        END.
        RUN utp/ut-msgs.p ( INPUT "SHOW",
                            INPUT 27100,
                            INPUT "Aprovar Ficha de Inspe‡Æo?~~A Ficha de Inspe‡Æo ser  aprovada integrando Estoque e WMS. Confirma Aprova‡Æo?").
        IF RETURN-VALUE = "yes" THEN
            RUN piAprovar.
        APPLY "choose" TO bt-atualiza.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define SELF-NAME btMotivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMotivo wWindow
ON CHOOSE OF btMotivo IN FRAME fpage0 /* Motivo */
DO:
    IF AVAIL tt-ficha-cq
    THEN DO:
        DEFINE VARIABLE cObservacao AS CHARACTER   NO-UNDO.
        FIND FIRST pedido-compr
             WHERE pedido-compr.num-pedido = tt-ficha-cq.num-pedido
            NO-LOCK NO-ERROR.

        ASSIGN cObservacao = "".
        IF AVAIL pedido-compr
        THEN DO:
            ASSIGN cObservacao = pedido-compr.char-2.
        END.
        RUN upc/cc0300a1-upc.w (INPUT NO,
                                INPUT-OUTPUT cObservacao).
    END.
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


&Scoped-define SELF-NAME btRejeitar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRejeitar wWindow
ON CHOOSE OF btRejeitar IN FRAME fpage0 /* Rejeitar */
DO:
    IF AVAIL tt-ficha-cq
    THEN DO:

        FIND FIRST Wm-roteiro-docto-itens NO-LOCK
             WHERE Wm-roteiro-docto-itens.nr-ficha = tt-ficha-cq.nr-ficha NO-ERROR.
        IF AVAIL Wm-roteiro-docto-itens THEN DO:

            FOR  EACH Wm-box-movto NO-LOCK
                WHERE Wm-box-movto.num-seq-item = Wm-roteiro-docto-itens.num-seq-item
                  AND Wm-box-movto.id-docto     = wm-roteiro-docto-itens.id-docto.

                IF CAN-FIND(FIRST wm-box-saldo NO-LOCK
                            WHERE wm-box-saldo.cod-estabel      = Wm-box-movto.cod-estabel
                              AND wm-box-saldo.cod-local        = Wm-box-movto.cod-local
                              AND wm-box-saldo.cod-item         = Wm-box-movto.cod-item
                              AND wm-box-saldo.cod-refer        = Wm-box-movto.cod-refer
                              AND wm-box-saldo.cod-lote         = Wm-box-movto.cod-lote
                              AND wm-box-saldo.id-movto         = wm-box-movto.id-movto
                              AND (wm-box-saldo.ind-status-saldo <> 3 AND wm-box-saldo.ind-status-saldo <> 7))
                THEN DO:
                    RUN utp/ut-msgs(INPUT "show",
                                    INPUT 17006,
                                    INPUT "Rejei‡Æo NÆo Permitida!~~Para Rejeitar a Ficha CQ o material deve estar Armazenado!" ).
                    RETURN NO-APPLY.
                END.
            END.
        
            RUN utp/ut-msgs.p ( INPUT "SHOW",
                                INPUT 27100,
                                INPUT "Rejeitar Ficha de Inspe‡Æo?~~A Ficha de Inspe‡Æo ser  rejeitada integrando Estoque e WMS. Confirma Rejei‡Æo?").
            IF RETURN-VALUE = "yes"
            THEN DO:
                RUN piRejeitar.
            END.
        END.
        ELSE DO:
            RUN utp/ut-msgs.p ( INPUT "SHOW",
                                INPUT 15825,
                                INPUT "Rejei‡Æo desta ficha deve ser realizada atrav‚s do programa CQ0210~~Rejei‡Æo desta ficha deve ser realizada atrav‚s do programa CQ0210").
            RETURN NO-APPLY.
        END.

        APPLY "choose" TO bt-atualiza.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

brFichaCQ:NUM-LOCKED-COLUMNS IN FRAME fpage0 = 2.
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-saldo wWindow 
PROCEDURE pi-busca-saldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-cod-estabel    AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-cod-local      AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-id-movto       AS DEC  NO-UNDO.
    DEFINE INPUT PARAM p-cod-item       AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-id-box         AS DEC  NO-UNDO.
    DEFINE INPUT PARAM p-dt-transacao   AS DATE NO-UNDO.
    DEFINE INPUT PARAM p-hra-trans      AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-qtd-item       AS DEC  NO-UNDO.
    DEFINE INPUT PARAM p-qti-embalagem  AS DEC  NO-UNDO.
        
    FOR EACH  b-wm-box-movto fields(cod-estabel cod-local id-docto cod-item id-movto) NO-LOCK
        WHERE b-wm-box-movto.cod-estabel    = p-cod-estabel
          AND b-wm-box-movto.cod-local      = p-cod-local
          AND b-wm-box-movto.id-movto      NE p-id-movto
          AND b-wm-box-movto.cod-item       = p-cod-item
          AND b-wm-box-movto.ind-tipo-movto = 2 /* 2- saida */
          AND b-wm-box-movto.id-box         = p-id-box
          AND b-wm-box-movto.qtd-item       = p-qtd-item
          AND b-wm-box-movto.qti-embalagem  = p-qti-embalagem
          AND b-wm-box-movto.dt-transacao  >= p-dt-transacao
          AND (IF b-wm-box-movto.dt-transacao = p-dt-transacao THEN b-wm-box-movto.hra-trans >= p-hra-trans ELSE TRUE)
        BY b-wm-box-movto.dt-transacao
        BY b-wm-box-movto.hra-trans ON ERROR UNDO, THROW.        
        
        IF CAN-FIND(FIRST wm-docto
                    WHERE wm-docto.cod-estabel      = b-wm-box-movto.cod-estabel
                      AND wm-docto.cod-local        = b-wm-box-movto.cod-local
                      AND wm-docto.id-docto         = b-wm-box-movto.id-docto
                      AND wm-docto.ind-origem-docto = 18) THEN DO: /* 18- Transferencia Manual */
            
            FIND FIRST b-wm-box-movto-ent NO-LOCK
                 WHERE b-wm-box-movto-ent.cod-estabel    = b-wm-box-movto.cod-estabel
                   AND b-wm-box-movto-ent.cod-local      = b-wm-box-movto.cod-local                   
                   AND b-wm-box-movto-ent.id-movto       = b-wm-box-movto.id-movto
                   AND b-wm-box-movto-ent.ind-tipo-movto = 1 /* 1- entrada */ NO-ERROR.            
            IF AVAIL b-wm-box-movto-ent THEN DO:

                IF CAN-FIND(FIRST wm-box-saldo
                            WHERE wm-box-saldo.cod-estabel  = b-wm-box-movto-ent.cod-estabel
                              AND wm-box-saldo.cod-local    = b-wm-box-movto-ent.cod-local
                              AND wm-box-saldo.id-docto     = b-wm-box-movto-ent.id-docto                              
                              AND wm-box-saldo.cod-item     = b-wm-box-movto-ent.cod-item   
                              AND wm-box-saldo.id-box       = b-wm-box-movto-ent.id-box) THEN DO:
                                                           
                    IF NOT VALID-HANDLE(h-wm9005a) THEN
                        RUN wmp/wm9005a.p PERSISTENT SET h-wm9005a.
                    
                    RUN EXECUTE IN h-wm9005a (INPUT ROWID(b-Wm-box-movto-ent),
                                              INPUT b-Wm-box-movto-ent.id-box,
                                              INPUT (b-wm-box-movto-ent.qtd-item * b-wm-box-movto-ent.qti-embalagem),
                                              OUTPUT TABLE RowErrors).

                    IF VALID-HANDLE(h-wm9005a) THEN DELETE OBJECT h-wm9005a.

                    IF CAN-FIND(FIRST RowErrors) THEN DO:
                        {method/showmessage.i1}
                        {method/showmessage.i2 &Modal="YES"}
                        {method/showmessage.i3}

                        RETURN "NOK".
                    END.
                    ELSE DO:
                        RETURN "OK".
                    END.
                END.
                ELSE DO:
                    RUN pi-busca-saldo (INPUT b-wm-box-movto-ent.cod-estabel,
                                        INPUT b-wm-box-movto-ent.cod-local,
                                        INPUT b-wm-box-movto-ent.id-movto,
                                        INPUT b-wm-box-movto-ent.cod-item,
                                        INPUT b-wm-box-movto-ent.id-box,
                                        INPUT b-wm-box-movto-ent.dt-transacao,
                                        INPUT b-wm-box-movto-ent.hra-trans,
                                        INPUT b-wm-box-movto-ent.qtd-item,
                                        INPUT b-wm-box-movto-ent.qti-embalagem).

                    IF RETURN-VALUE NE "OK" THEN
                        RETURN "NOK".
                END.
            END.                        
        END.        
    END.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAprovar wWindow 
PROCEDURE piAprovar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
bloco_aprov:
DO TRANSACTION:

    FIND FIRST ficha-cq WHERE ficha-cq.nr-ficha = tt-ficha-cq.nr-ficha NO-LOCK NO-ERROR.
    IF AVAIL ficha-cq
    THEN DO:
        IF  NOT VALID-HANDLE(h-ceapi001k) THEN
            RUN cep/ceapi001k.p persistent set h-ceapi001k.
        IF  NOT VALID-HANDLE(h-cdapi024) THEN
            RUN cdp/cdapi024.p persistent set h-cdapi024.

        /*Incluir logica do cq0210e */
        RUN cep/ceapi014.p (INPUT ficha-cq.it-codigo,
                            INPUT ficha-cq.cod-estabel,
                            OUTPUT c-cod-deposito,
                            OUTPUT c-cod-localizacao,
                            OUTPUT l-loc-unica).

        ASSIGN  deQtdAprovada = ficha-cq.qt-original - (ficha-cq.qt-aprovada + ficha-cq.qt-rejeitada).

        /*Movimento Estoque*/
        RUN piAtualizaEstoque (INPUT c-cod-deposito,
                               INPUT ficha-cq.cod-depos,
                               INPUT ficha-cq.narrativa,
                               INPUT deQtdAprovada).

        IF RETURN-VALUE = "OK" THEN DO:

            FIND CURRENT ficha-cq EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN  ficha-cq.situacao       = 4 /* Terminado */
                    ficha-cq.dt-analise     = TODAY
                    ficha-cq.int-1          = TIME
                    ficha-cq.inspecionado   = YES
                    ficha-cq.qt-aprovada    = ficha-cq.qt-aprovada + deQtdAprovada
                    ficha-cq.cod-resp       = c-seg-usuario
                    ficha-cq.narrativa      = c-texto.
            FIND CURRENT ficha-cq NO-LOCK NO-ERROR.
    
            /*Libera‡Æo CQ*/
            FOR FIRST Wm-roteiro-docto-itens NO-LOCK
                WHERE Wm-roteiro-docto-itens.nr-ficha = ficha-cq.nr-ficha:
            
                FOR EACH  Wm-box-movto FIELDS(cod-item id-box dt-transacao hra-trans 
                                              qtd-item qti-embalagem id-movto qtd-liber-erp) NO-LOCK
                    WHERE wm-box-movto.cod-estabel    = wm-roteiro-docto-itens.cod-estabel
                      AND wm-box-movto.cod-local      = wm-roteiro-docto-itens.cod-local
                      AND Wm-box-movto.id-docto       = wm-roteiro-docto-itens.id-docto
                      AND Wm-box-movto.num-seq-item   = Wm-roteiro-docto-itens.num-seq-item 
                      AND Wm-box-movto.ind-tipo-movto = 1. /* 1- Entrada */ 
            
                    IF CAN-FIND(FIRST wm-box-saldo
                                WHERE wm-box-saldo.cod-estabel  = Wm-roteiro-docto-itens.cod-estabel
                                  AND wm-box-saldo.cod-local    = Wm-roteiro-docto-itens.cod-local
                                  AND wm-box-saldo.id-docto     = Wm-roteiro-docto-itens.id-docto
                                  AND wm-box-saldo.num-seq-item = Wm-roteiro-docto-itens.num-seq-item
                                  AND wm-box-saldo.cod-item     = wm-box-movto.cod-item
                                  AND wm-box-saldo.id-box       = wm-box-movto.id-box) THEN DO:       

                        IF NOT VALID-HANDLE(h-wm9005a) THEN
                            RUN wmp/wm9005a.p PERSISTENT SET h-wm9005a.
                        
                        RUN EXECUTE IN h-wm9005a (INPUT ROWID(Wm-box-movto),
                                                  INPUT Wm-box-movto.id-box,
                                                  INPUT Wm-box-movto.qtd-liber-erp,
                                                  OUTPUT TABLE RowErrors).

                        IF VALID-HANDLE(h-wm9005a) THEN DELETE OBJECT h-wm9005a.                        

                        IF CAN-FIND(FIRST RowErrors) THEN DO:
                            {method/showmessage.i1}
                            {method/showmessage.i2 &Modal="YES"}
                            {method/showmessage.i3}
                            UNDO bloco_aprov, LEAVE bloco_aprov.
                        END.
                    END.  
                    ELSE DO:
                        RUN pi-busca-saldo (INPUT Wm-roteiro-docto-itens.cod-estabel,
                                            INPUT Wm-roteiro-docto-itens.cod-local,
                                            INPUT wm-box-movto.id-movto,
                                            INPUT wm-box-movto.cod-item,
                                            INPUT wm-box-movto.id-box,
                                            INPUT wm-box-movto.dt-transacao,
                                            INPUT wm-box-movto.hra-trans,
                                            INPUT wm-box-movto.qtd-item,
                                            INPUT wm-box-movto.qti-embalagem).                        

                        IF RETURN-VALUE NE "OK" THEN DO:
                            UNDO bloco_aprov, LEAVE bloco_aprov.
                        END.
                    END.
                END.
    
                /*Libera‡Æo CQ*/
                FIND CURRENT wm-roteiro-docto-itens  EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN wm-roteiro-docto-itens.qtd-aprovada  = deQtdAprovada.
                FIND CURRENT wm-roteiro-docto-itens  NO-LOCK NO-ERROR.
    
            END.
        END.            
    END.            
    IF  VALID-HANDLE(h-ceapi001k) THEN DELETE PROCEDURE h-ceapi001k.
    IF  VALID-HANDLE(h-cdapi024)  THEN DELETE PROCEDURE h-cdapi024.
    ASSIGN h-cdapi024  = ?
           h-ceapi001k = ?.

END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualiza wWindow 
PROCEDURE piAtualiza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-ficha-cq.
    blk_ficha:
    FOR  EACH ficha-cq NO-LOCK
        WHERE ficha-cq.nr-ficha         >= tt-parametros.nr-ficha-ini
          AND ficha-cq.nr-ficha         <= tt-parametros.nr-ficha-fim
          AND ficha-cq.dt-ficha         >= tt-parametros.dt-ficha-ini
          AND ficha-cq.dt-ficha         <= tt-parametros.dt-ficha-fim
          AND ficha-cq.it-codigo        >= tt-parametros.it-codigo-ini
          AND ficha-cq.it-codigo        <= tt-parametros.it-codigo-fim
          AND ficha-cq.cod-estabel      >= tt-parametros.cod-estabel-ini
          AND ficha-cq.cod-estabel      <= tt-parametros.cod-estabel-fim
          /*AND ficha-cq.cod-depos        >= tt-parametros.cod-depos-ini
            AND ficha-cq.cod-depos        <= tt-parametros.cod-depos-fim*/
          AND (     ficha-cq.origem     = 1 AND tt-parametros.logOriManual
                OR  ficha-cq.origem     = 2 AND tt-parametros.logOriEstoque
                OR  ficha-cq.origem     = 3 AND tt-parametros.logOriProducao
                OR  ficha-cq.origem     = 4 AND tt-parametros.logOriManualMovtoEstoque)
          AND (     ficha-cq.situacao   = 1 AND tt-parametros.logSitPendente
                OR  ficha-cq.situacao   = 2 AND tt-parametros.logSitEmAnalise
                OR  ficha-cq.situacao   = 3 AND tt-parametros.logSitPendenteRetorno
                OR  ficha-cq.situacao   = 4 AND tt-parametros.logSitTerminado
                OR  ficha-cq.situacao   = 5 AND tt-parametros.logSitCancelado
                OR  ficha-cq.situacao   = 6 AND tt-parametros.logSitPendenteNF):

        FOR FIRST ITEM FIELDS(desc-item) NO-LOCK
            WHERE ITEM.it-codigo = ficha-cq.it-codigo:
            IF  ITEM.desc-item < tt-parametros.desc-item-ini
            AND ITEM.desc-item > tt-parametros.desc-item-fim
            THEN NEXT blk_ficha.
        END.
        FOR FIRST emitente FIELDS(nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = ficha-cq.cod-emitente.
        END.
         
        FIND first wm-roteiro-docto-itens NO-LOCK
             where wm-roteiro-docto-itens.nr-ficha = ficha-cq.nr-ficha NO-ERROR.
        /* Somente WMS */
        IF tt-parametros.logSomenteWMS THEN DO:
            IF NOT AVAIL wm-roteiro-docto-itens THEN
                NEXT.
        END.
        /* Ler transferencias por causa dos CD(112,113)
        FIND FIRST docum-est OF ficha-cq NO-LOCK NO-ERROR.
          IF AVAIL docum-est AND docum-est.esp-docto = 23 THEN DO:
            NEXT.
        END.
        */

        CREATE  tt-ficha-cq.
        ASSIGN  tt-ficha-cq.nr-ficha        = ficha-cq.nr-ficha
                tt-ficha-cq.cod-estabel     = ficha-cq.cod-estabel
                tt-ficha-cq.cod-depos       = ficha-cq.cod-depos
                tt-ficha-cq.dt-ficha        = ficha-cq.dt-ficha 
                tt-ficha-cq.it-codigo       = ficha-cq.it-codigo
                tt-ficha-cq.desc-item       = IF AVAIL ITEM THEN ITEM.desc-item ELSE ""
                tt-ficha-cq.cod-emitente    = ficha-cq.cod-emitente
                tt-ficha-cq.nome-abrev      = IF AVAIL emitente THEN emitente.nome-abrev   ELSE ""
                tt-ficha-cq.nro-docto       = ficha-cq.nro-docto
                tt-ficha-cq.origem          = ficha-cq.origem
                tt-ficha-cq.des-origem      = {ininc/i01in124.i 04 ficha-cq.origem}
                tt-ficha-cq.qt-original     = ficha-cq.qt-original
                tt-ficha-cq.qt-aprovada     = ficha-cq.qt-aprovada
                tt-ficha-cq.qt-rejeitada    = ficha-cq.qt-rejeitada
                tt-ficha-cq.situacao        = ficha-cq.situacao
                tt-ficha-cq.des-situacao    = {ininc/i03in124.i 04 ficha-cq.situacao}
                /*tt-ficha-cq.cod-usuario     = ficha-cq.cod-resp*/
                tt-ficha-cq.dt-analise      = ficha-cq.dt-analise
                tt-ficha-cq.hr-analise      = STRING(ficha-cq.int-1, "HH:MM:SS")
                tt-ficha-cq.baixa-estoq     = ficha-cq.baixa-estoq
                tt-ficha-cq.skipe-lote      = 0
                tt-ficha-cq.log-wms         = AVAIL wm-roteiro-docto-itens
                tt-ficha-cq.rRowid          = ROWID(ficha-cq).

        FIND FIRST item-uni-estab
             WHERE item-uni-estab.cod-estabel   = ficha-cq.cod-estabel
               AND item-uni-estab.it-codigo     = ficha-cq.it-codigo
            NO-LOCK NO-ERROR.

        ASSIGN  tt-ficha-cq.cod-deposito-pad = IF AVAIL item-uni-estab THEN item-uni-estab.deposito-pad ELSE IF AVAIL ITEM THEN ITEM.deposito-pad ELSE "".

        IF  tt-ficha-cq.cod-deposito-pad < tt-parametros.cod-depos-ini
        OR  tt-ficha-cq.cod-deposito-pad > tt-parametros.cod-depos-fim
        THEN DO:
            DELETE tt-ficha-cq.
            NEXT blk_ficha.
        END.

        FOR FIRST it-critico-cq NO-LOCK
            WHERE it-critico-cq.cod-estabel = ficha-cq.cod-estabel
              AND it-critico-cq.it-codigo   = ficha-cq.it-codigo:
            ASSIGN tt-ficha-cq.item-critico = "X".
        END.

        FOR FIRST rat-lote FIELDS (int-1 char-1) NO-LOCK
            WHERE rat-lote.serie-docto  = ficha-cq.serie-docto
              AND rat-lote.nro-docto    = ficha-cq.nro-docto
              AND rat-lote.cod-emitente = ficha-cq.cod-emitente
              AND rat-lote.nat-operacao = ficha-cq.nat-operacao
              AND rat-lote.nr-ficha     = ficha-cq.nr-ficha:

            ASSIGN tt-ficha-cq.skipe-lote = rat-lote.int-1.
            IF rat-lote.char-1 <> ""
            THEN DO:
                ASSIGN  tt-ficha-cq.des-origem  = "Compras"
                        tt-ficha-cq.num-pedido  = INT(rat-lote.char-1).
            END.
        END.

        /* Atualizaando Pedido de Compra */
        FIND FIRST docum-est OF ficha-cq NO-LOCK NO-ERROR.
        IF AVAIL docum-est THEN DO:
            FIND FIRST ordem-compra WHERE
                ordem-compra.numero-ordem = ficha-cq.nr-ordem NO-LOCK NO-ERROR.
            ASSIGN tt-ficha-cq.num-pedido = IF AVAIL ordem-compra THEN ordem-compra.num-pedido ELSE 0.
        END.

        IF  ficha-cq.situacao > 1
        THEN DO:
            FOR FIRST movto-estoq FIELDS(usuario) NO-LOCK
                WHERE movto-estoq.nro-docto     = ficha-cq.nro-docto
                  AND movto-estoq.cod-emitente  = ficha-cq.cod-emitente
                  AND movto-estoq.dt-trans      = ficha-cq.dt-analise
                :
                ASSIGN tt-ficha-cq.cod-usuario = movto-estoq.usuario.
            END.
        END.
    END.
    {&OPEN-QUERY-brFichaCQ}    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaEstoque wWindow 
PROCEDURE piAtualizaEstoque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  parameter pCodDepEnt     as char   no-undo.
    def input  parameter pCodDepSai     as char   no-undo.
    def input  parameter pObservacao    as char   no-undo.
    def input  parameter pQuantidade    as deci   no-undo.

    def var i-insp        as integer no-undo.
    def var i-var-aux     as integer no-undo.
    def var i-var-aux-tot as integer no-undo.
    DEF VAR l-retorno     AS LOGICAL INITIAL NO NO-UNDO.
    def var l-leitura-item-fornec-estab as logical INIT NO                  no-undo.

    find first param-estoq NO-LOCK no-error.

    for each tt-movto:
        delete tt-movto.
    end.
    for each tt-erro:
        delete tt-erro.
    end.

    

    /* BUSCA SALDO DE ESTOQUE REFERENTE A FICHA CQ */
    find first saldo-estoq
        where  saldo-estoq.it-codigo   = ficha-cq.it-codigo
        and    saldo-estoq.cod-estabel = ficha-cq.cod-estabel
        and    saldo-estoq.cod-depos   = ficha-cq.cod-depos
        and    saldo-estoq.cod-localiz = ficha-cq.cod-localiz
        and    saldo-estoq.lote        = ficha-cq.lote 
        AND    saldo-estoq.cod-refer   = ficha-cq.cod-refer
        no-lock no-error.

    FIND FIRST ITEM WHERE ITEM.it-codigo = ficha-cq.it-codigo NO-LOCK NO-ERROR.

    Bloco_WMS:
    DO ON ERROR UNDO,  return 'ADM-ERROR':U:
        /* ATUALIZA MOVIMENTA€ÇO DO ESTOQUE - SAÖDA DO CQ - ORIGEM */
        create tt-movto.
        assign tt-movto.ct-codigo    = param-estoq.ct-tr-transf
               tt-movto.sc-codigo    = param-estoq.sc-tr-transf.

        assign tt-movto.cod-versao-integracao = 1 
               tt-movto.dt-trans       = TODAY
               tt-movto.nro-docto      = ficha-cq.nro-docto
               tt-movto.serie-docto    = ficha-cq.serie-docto
               tt-movto.cod-depos      = pCodDepSai
               tt-movto.cod-estabel    = ficha-cq.cod-estabel
               tt-movto.it-codigo      = ficha-cq.it-codigo
               tt-movto.cod-localiz    = ficha-cq.cod-localiz
               tt-movto.lote           = ficha-cq.lote
               tt-movto.dt-vali-lote   = saldo-estoq.dt-vali-lote
               tt-movto.cod-refer      = ficha-cq.cod-refer
               tt-movto.quantidade     = pQuantidade
               tt-movto.un             = ITEM.un
               tt-movto.esp-docto      = 33
               tt-movto.tipo-trans     = 2
               tt-movto.descricao-db   = pObservacao
               tt-movto.cod-prog-orig  = "V03in218"
               tt-movto.cod-emitente   = ficha-cq.cod-emitente
               tt-movto.usuario        = c-seg-usuario.
            
        IF  l-unidade-negocio
        AND l-mat-unid-negoc THEN DO:
            IF  VALID-HANDLE(h-cdapi024) THEN
                RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT tt-movto.cod-estabel,
                                                         INPUT tt-movto.it-codigo,
                                                         INPUT tt-movto.cod-depos,
                                                         OUTPUT tt-movto.cod-unid-negoc).
            ASSIGN c-unid-negoc = tt-movto.cod-unid-negoc.
        END.
        ELSE
            ASSIGN c-unid-negoc = "".
    
         /* ATUALIZA MOVIMENTA€ÇO DE ESTOQUE - DESTINO */
        create tt-movto.
        assign tt-movto.ct-codigo    = param-estoq.ct-tr-transf
               tt-movto.sc-codigo    = param-estoq.sc-tr-transf.
        assign tt-movto.cod-versao-integracao = 1
               tt-movto.dt-trans      = TODAY
               tt-movto.nro-docto     = ficha-cq.nro-docto
               tt-movto.serie-docto   = ficha-cq.serie-docto
               tt-movto.cod-depos     = pCodDepEnt
               tt-movto.cod-estabel   = ficha-cq.cod-estabel
               tt-movto.it-codigo     = ficha-cq.it-codigo
               tt-movto.cod-localiz   = c-cod-localizacao
               tt-movto.lote          = ficha-cq.lote
               tt-movto.dt-vali-lote  = saldo-estoq.dt-vali-lote
               tt-movto.cod-refer     = ficha-cq.cod-refer
               tt-movto.quantidade    = pQuantidade
               tt-movto.un            = ITEM.un
               tt-movto.esp-docto     = 33
               tt-movto.tipo-trans    = 1
               tt-movto.descricao-db  = pObservacao
               tt-movto.cod-prog-orig = "V03in218"
               tt-movto.usuario       = c-seg-usuario
               tt-movto.cod-emitente  = ficha-cq.cod-emitente
               tt-movto.cod-unid-negoc = IF  l-unidade-negocio AND l-mat-unid-negoc THEN c-unid-negoc ELSE "".
                   
        IF  l-unidade-negocio
        AND l-mat-unid-negoc THEN DO:

            IF  VALID-HANDLE(h-cdapi024) THEN DO:

                /*** Posiciona no registro de saida (origem) ***/
                FIND FIRST b-tt-movto
                     WHERE b-tt-movto.tipo-trans = 2 NO-LOCK NO-ERROR.
    
                /*** Localiza unidade de negocio origem ***/
                RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT b-tt-movto.cod-estabel,
                                                         INPUT b-tt-movto.it-codigo,
                                                         INPUT b-tt-movto.cod-depos,
                                                         OUTPUT c-unid-negoc).

                /*** Localiza unidade de negocio destino ***/
                RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT tt-movto.cod-estabel,
                                                         INPUT tt-movto.it-codigo,
                                                         INPUT tt-movto.cod-depos,
                                                         OUTPUT c-unid-negoc). //c-unid-negoc-des).
    
            END.
        END.

        IF  VALID-HANDLE (h-ceapi001k) THEN DO:
            RUN pi-execute IN h-ceapi001k (input-output table tt-movto,
                                           input-output table tt-erro, 
                                           input              l-deleta-erros).
        END.
    
        /* CHAMADA DO BROWSE QUE MOSTRA AS INCONSISTÒNCIAS DE CRIA€ÇO DO MOVTO-ESTOQ */
        find first tt-erro NO-LOCK no-error.
        if  RETURN-VALUE = "NOK":U
        OR  avail tt-erro then do:
            run cdp/cd0666.w (input table tt-erro).

            RETURN 'NOK':U.
        end.
        DEFINE VARIABLE iNrTransMovto AS INTEGER     NO-UNDO.
        FIND FIRST tt-movto WHERE tt-movto.tipo-trans = 1 //Entrada
            NO-LOCK NO-ERROR.
        ASSIGN iNrTransMovto = IF AVAIL tt-movto THEN tt-movto.nr-trans ELSE 0.
    END.
    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaParametros wWindow 
PROCEDURE piCriaParametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST tt-parametros NO-ERROR.
    IF NOT AVAIL tt-parametros
    THEN DO:
        CREATE  tt-parametros.
        ASSIGN  tt-parametros.nr-ficha-ini              = 0
                tt-parametros.nr-ficha-fim              = 9999999
                tt-parametros.dt-ficha-ini              = 07/31/2021
                tt-parametros.dt-ficha-fim              = TODAY
                tt-parametros.cod-estabel-ini           = ""
                tt-parametros.cod-estabel-fim           = "ZZZZZ"
                tt-parametros.it-codigo-ini             = ""
                tt-parametros.it-codigo-fim             = "ZZZZZZZZZZZZZZZZ"
                tt-parametros.desc-item-ini             = ""
                tt-parametros.desc-item-fim             = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
                tt-parametros.cod-depos-ini             = ""
                tt-parametros.cod-depos-fim             = "ZZZ"
                tt-parametros.numTempoRefresh           = 5
                tt-parametros.logItensCriticos          = NO
                tt-parametros.logOriEstoque             = YES
                tt-parametros.logOriManual              = YES
                tt-parametros.logOriProducao            = YES
                tt-parametros.logOriManualMovtoEstoque  = NO
                tt-parametros.logSitCancelado           = NO
                tt-parametros.logSitEmAnalise           = YES
                tt-parametros.logSitPendente            = YES
                tt-parametros.logSitPendenteNF          = NO
                tt-parametros.logSitPendenteRetorno     = NO
                tt-parametros.logSitTerminado           = NO
                tt-parametros.logSomenteWMS             = YES.

        FOR FIRST usuar-mater
            WHERE usuar-mater.cod-usuario = v_cod_usuar_corren.

            ASSIGN  tt-parametros.cod-estabel-ini           = SUBSTRING(usuar-mater.char-1,16,5)
                    tt-parametros.cod-estabel-fim           = SUBSTRING(usuar-mater.char-1,16,5).
        END.
    END.

    //ASSIGN chCtrlFrame:PSTimer:INTERVAL   = (tt-parametros.numTempoRefresh * 60 * 1000).
                                            /* converter de milissegundos para segundos */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRejeitar wWindow 
PROCEDURE piRejeitar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
blk_rejeitar:
DO TRANSACTION:

    FIND FIRST ficha-cq WHERE ficha-cq.nr-ficha = tt-ficha-cq.nr-ficha NO-LOCK NO-ERROR.
    IF AVAIL ficha-cq
    THEN DO:
        ASSIGN c-texto = "".
        run esp/cqp/escqp014b.w (input-output c-texto).
        IF RETURN-VALUE = 'NOK' THEN DO:
            RETURN NO-APPLY.
        END.

        IF  NOT VALID-HANDLE(h-ceapi001k) THEN
            RUN cep/ceapi001k.p persistent set h-ceapi001k.
        IF  NOT VALID-HANDLE(h-cdapi024) THEN
            RUN cdp/cdapi024.p persistent set h-cdapi024.
        IF NOT VALID-HANDLE(hDBOsc032) THEN
            RUN scbo/bosc032.p persistent set hDBOsc032.

        FIND FIRST estabelec
             WHERE estabelec.cod-estabel = ficha-cq.cod-estabel
            NO-LOCK NO-ERROR.
        ASSIGN  c-dep-rej       = estabelec.dep-rej-cq
                deQtdRejeitada  = ficha-cq.qt-original - (ficha-cq.qt-aprovada + ficha-cq.qt-rejeitada).


        //Movimento Estoque
        RUN piAtualizaEstoque (INPUT c-dep-rej,
                               INPUT ficha-cq.cod-depos,
                               INPUT ficha-cq.narrativa,
                               INPUT deQtdRejeitada).

        //2021.11.17-Por solicita‡Æo da Intelbras o rejeito ser  transferido para deposuto WEX apenas no estoquye.
        RUN piAtualizaEstoque (INPUT "WEX",
                               INPUT c-dep-rej,
                               INPUT SUBSTITUTE("Transferˆncia Movimento [&1] Rejei‡Æo para dep¢sito WEX",STRING(iNrTransMovto)),
                               INPUT deQtdRejeitada).

        IF RETURN-VALUE = "OK"
        THEN DO:
            FIND CURRENT ficha-cq EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN  ficha-cq.situacao       = 4 /* Terminado */
                    ficha-cq.dt-analise     = TODAY
                    ficha-cq.int-1          = TIME
                    ficha-cq.inspecionado   = YES
                    ficha-cq.qt-rejeitada   = ficha-cq.qt-rejeitada + deQtdRejeitada
                    ficha-cq.cod-resp       = c-seg-usuario
                    ficha-cq.narrativa      = c-texto.
            FIND CURRENT ficha-cq NO-LOCK NO-ERROR.
            FIND FIRST rej-ficha
                 WHERE rej-ficha.nr-ficha = ficha-cq.nr-ficha
                 NO-LOCK NO-ERROR.
            if  NOT AVAIL rej-ficha
            THEN DO:
                CREATE  rej-ficha.
                ASSIGN  rej-ficha.nr-ficha      = ficha-cq.nr-ficha
                        rej-ficha.dep-rej       = c-dep-rej
                        rej-ficha.codigo-rejei  = 1
                        rej-ficha.observacao    = c-Texto
                        rej-ficha.qt-rejeitada  = rej-ficha.qt-rejeitada + deQtdRejeitada
                        rej-ficha.quant-rej     = rej-ficha.quant-rej + deQtdRejeitada.
            END.

            FOR FIRST Wm-roteiro-docto-itens NO-LOCK
                WHERE Wm-roteiro-docto-itens.nr-ficha = ficha-cq.nr-ficha:
            
                FIND CURRENT wm-roteiro-docto-itens  EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN wm-roteiro-docto-itens.qtd-rejeitada = wm-roteiro-docto-itens.qtd-rejeitada + deQtdRejeitada.
                FIND CURRENT wm-roteiro-docto-itens  NO-LOCK NO-ERROR.

                FOR  EACH Wm-box-movto NO-LOCK
                    WHERE Wm-box-movto.num-seq-item = Wm-roteiro-docto-itens.num-seq-item
                      and Wm-box-movto.id-docto     = wm-roteiro-docto-itens.id-docto.

                    FOR EACH wm-box-saldo EXCLUSIVE-LOCK
                       WHERE wm-box-saldo.cod-estabel      = Wm-box-movto.cod-estabel
                         AND wm-box-saldo.cod-local        = Wm-box-movto.cod-local
                         AND wm-box-saldo.cod-item         = Wm-box-movto.cod-item
                         AND wm-box-saldo.cod-refer        = Wm-box-movto.cod-refer
                         AND wm-box-saldo.cod-lote         = Wm-box-movto.cod-lote
                         AND wm-box-saldo.id-movto         = wm-box-movto.id-movto
                         AND wm-box-saldo.ind-status-saldo = 7 /* CQ-Armazenado */
                        :

                        FOR EACH wm-box-saldo-etiqueta NO-LOCK
                           WHERE wm-box-saldo-etiqueta.cod-estabel =  wm-box-saldo.cod-estabel 
                             AND wm-box-saldo-etiqueta.cod-local   =  wm-box-saldo.cod-local   
                             AND wm-box-saldo-etiqueta.id-box      =  wm-box-saldo.id-box
                             AND wm-box-saldo-etiqueta.id-docto    =  wm-box-saldo.id-docto
                             AND wm-box-saldo-etiqueta.id-saldo    =  wm-box-saldo.id-saldo:

                            FIND FIRST wm-etiqueta EXCLUSIVE-LOCK
                                 WHERE wm-etiqueta.id-etiqueta = wm-box-saldo-etiqueta.id-etiqueta NO-ERROR.
                            IF AVAIL wm-etiqueta
                            THEN DO:
                                ASSIGN wm-etiqueta.qtd-item-rejtda = wm-etiqueta.qtd-item.
                            END.
                            FIND CURRENT wm-etiqueta NO-LOCK NO-ERROR.
                        END.
                        ASSIGN de-saldo-endereco = wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq.

                        /* quantidade rejeitada ² menor ou igual ao saldo dispon­vel no endere»o */
                        IF deQtdRejeitada <= de-saldo-endereco THEN DO:
                            /* Rejeita todo o wm-box-saldo lido */
                            IF  wm-box-saldo.qtd-item-bloq = 0 AND
                                deQtdRejeitada           = de-saldo-endereco THEN 
                                ASSIGN wm-box-saldo.ind-status-saldo = 5. /* Rejeitado */
                            ELSE 
                                ASSIGN wm-box-saldo.ind-status-saldo = 7. /* CQ-Armazenado */
                        END.
                        ELSE DO:
                            /* Rejeita todo o wm-box-saldo lido */
                            ASSIGN wm-box-saldo.ind-status-saldo = 5. /* Rejeitado */
                        END.
                    END.
                END.
            END.
        END.            
    END.            
    IF  VALID-HANDLE(h-ceapi001k) THEN DELETE PROCEDURE h-ceapi001k.
    IF  VALID-HANDLE(hDBOsc032)   THEN RUN destroy IN hDBOsc032.
    IF  VALID-HANDLE(h-cdapi024)  THEN DELETE PROCEDURE h-cdapi024.
    ASSIGN h-cdapi024  = ?
           h-ceapi001k = ?.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

