&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttae-item NO-UNDO LIKE ae-item
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i escep011 2.04.000.000}

CREATE WIDGET-POOL.


&GLOBAL-DEFINE Program        escep011
&GLOBAL-DEFINE Version        2.04.000.002


DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_impres_layout    AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_nom_disposit_so  AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_tit_prog_dtsul   AS CHAR NO-UNDO.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escep011
&GLOBAL-DEFINE Version        2.04.000.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Requisiá∆o,Hist¢rico,Destino

&GLOBAL-DEFINE page0Widgets   btExit btHelp btConfirma btCancela 
&GLOBAL-DEFINE page1Widgets    
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   btConfigImpr fiPrinter
&GLOBAL-DEFINE ttTable        ttae-item
&GLOBAL-DEFINE hDBOTable      boes010
&GLOBAL-DEFINE DBOTable       ae-item

/* Parameters Definitions ---                                           */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE {&hDBOTable}      AS   HANDLE              NO-UNDO.
DEFINE VARIABLE wh-pesquisa       AS   HANDLE              NO-UNDO.
DEFINE VARIABLE i-page            AS   INT                 NO-UNDO.
DEFINE VARIABLE v-it-codigo       AS   CHAR                NO-UNDO.
DEFINE VARIABLE v-ae              LIKE ttae-item.nr-ae     NO-UNDO.
DEFINE VARIABLE v-sequencia       LIKE ttae-item.sequencia NO-UNDO.
DEFINE VARIABLE v-quantidade      AS   INT FORMAT ">>>>9"  NO-UNDO.
DEFINE VARIABLE c-programa        AS   CHAR                NO-UNDO.
DEFINE VARIABLE v-localizacao     AS   CHAR                NO-UNDO.
DEFINE VARIABLE c-imp-old         AS   CHAR                NO-UNDO.
DEFINE VARIABLE v-parcial         AS   LOGICAL             NO-UNDO.
DEFINE VARIABLE v-permite-parcial AS   LOGICAL             NO-UNDO.
DEFINE VARIABLE v-permite-quebra  AS   LOGICAL             NO-UNDO.
DEFINE VARIABLE v-conta           AS   CHAR EXTENT 2       NO-UNDO.
DEFINE VARIABLE v-subconta        AS   CHAR EXTENT 2       NO-UNDO.
DEFINE VARIABLE l-usuario         AS   LOGICAL             NO-UNDO.
DEFINE VARIABLE c-old-usuario     AS   CHAR                NO-UNDO.
DEFINE VARIABLE h-acomp           AS   HANDLE              NO-UNDO.
DEFINE VARIABLE h-cdapi024        AS   HANDLE              NO-UNDO.
DEFINE VARIABLE h-ceapi001k       AS   HANDLE              NO-UNDO.
DEFINE VARIABLE h_esapi020        AS   HANDLE              NO-UNDO.
DEFINE VARIABLE cPrinter          AS   CHARACTER           NO-UNDO.
DEFINE VARIABLE cAuxFile          AS   CHARACTER           NO-UNDO.
DEFINE VARIABLE cLayout           AS   CHARACTER           NO-UNDO.

{cep/ceapi001k.i}
{cdp/cd9590.i}
{esp/es0018.i}
{upc/btb910za-upc.i}
{include/boerrtab.i}

DEF TEMP-TABLE tt-prog-ponto2 LIKE tt-prog-ponto.
DEF TEMP-TABLE tt-prog-ponto1 LIKE tt-prog-ponto.

c-programa = "{&Program}".

RUN esp\es0018p.p (INPUT c-programa,
                   INPUT 2,
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto2).
FOR FIRST tt-prog-ponto2:
    v-conta[1] = tt-prog-ponto2.conteudo.
END.

DEF TEMP-TABLE ttae-item-aux LIKE ttae-item.


/** Unificaá∆o de conceito **/
DEFINE VARIABLE v_cod_cta_ctbl AS CHARACTER   NO-UNDO.
DEFINE VARIABLE p-finalidade AS CHARACTER   NO-UNDO.
DEFINE VARIABLE p_cod_format_cta_ctbl AS CHARACTER   NO-UNDO.
DEFINE VARIABLE p_cod_format_ccusto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_finalid AS CHARACTER   NO-UNDO.
DEFINE VARIABLE p_cod_format_inic AS CHARACTER   NO-UNDO.
DEFINE VARIABLE p_cod_format_fim AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-ccusto-inicial AS character no-undo.
DEFINE VARIABLE c-ccusto-final AS character no-undo.
DEFINE VARIABLE costCenterAlreadyEnabled AS LOGICAL NO-UNDO.
DEFINE VARIABLE log_controla_sensitive AS LOGICAL NO-UNDO.
DEFINE VARIABLE cErroAux AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cInputErro AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-seq-erros-api-ctb-cc AS INTEGER     NO-UNDO.


DEFINE VARIABLE wh-pesquisa-un AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_unid_negoc AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btExit btHelp 

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
DEFINE BUTTON btCancela 
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Cancela"
     FONT 4.

DEFINE BUTTON btConfirma 
     IMAGE-UP FILE "image/im-sav.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sav.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Confirma"
     FONT 4.

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

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE fi-cod-depos AS CHARACTER FORMAT "x(3)" 
     LABEL "Dep¢sito de Sa°da" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fi-codigo AS CHARACTER FORMAT "X(26)":U 
     LABEL "C¢digo de Barras" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 TOOLTIP "Informe o item" NO-UNDO.

DEFINE VARIABLE fi-ct-codigo AS CHARACTER FORMAT "x(20)" 
     LABEL "Conta" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 48 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-unid-negoc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-localizacao AS CHARACTER FORMAT "x(12)" 
     LABEL "Localizaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-ae AS INTEGER FORMAT "9999999" INITIAL 0 
     LABEL "AE/SeqÅància" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-quant-inf AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Quantidade Informada" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-quantidade AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Quantidade" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-sc-codigo AS CHARACTER FORMAT "x(20)" 
     LABEL "Centro Custo" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-sequencia AS INTEGER FORMAT "999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fi-titulo AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unid-negoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unid Negoc" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 1.25.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 5.25.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 4.5.

DEFINE VARIABLE fi-historico AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 66 SCROLLBAR-VERTICAL
     SIZE 80 BY 10
     BGCOLOR 15  NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "Configuraá∆o da impressora" 
     SIZE 4 BY 1 TOOLTIP "Configuraá∆o da impressora".

DEFINE VARIABLE fiPrinter AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 44 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY 2.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btCancela AT ROW 1.13 COL 1.72 HELP
          "Sair"
     btConfirma AT ROW 1.13 COL 5.72 HELP
          "Sair"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda" NO-TAB-STOP 
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.25
         FONT 1.

DEFINE FRAME fPage3
     btConfigImpr AT ROW 4.04 COL 62.57 HELP
          "Configuraá∆o da impressora" WIDGET-ID 32
     fiPrinter AT ROW 4.13 COL 18 NO-LABEL WIDGET-ID 34 NO-TAB-STOP 
     "Destino:" VIEW-AS TEXT
          SIZE 7.29 BY .54 AT ROW 3.25 COL 12.72 WIDGET-ID 28
     RECT-4 AT ROW 3.46 COL 11 WIDGET-ID 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.6 ROW 3.71
         SIZE 84 BY 12.75
         FONT 1.

DEFINE FRAME fpage2
     fi-historico AT ROW 2.5 COL 2 NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE 
         AT COL 3.6 ROW 3.7
         SIZE 84 BY 13.25
         BGCOLOR 8 FONT 1.

DEFINE FRAME fPage1
     fi-codigo AT ROW 1.17 COL 16 COLON-ALIGNED
     fi-it-codigo AT ROW 2.42 COL 16 COLON-ALIGNED NO-TAB-STOP 
     fi-desc-item AT ROW 2.42 COL 33.57 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fi-quantidade AT ROW 3.42 COL 16 COLON-ALIGNED NO-TAB-STOP 
     fi-nr-ae AT ROW 4.42 COL 16 COLON-ALIGNED NO-TAB-STOP 
     fi-sequencia AT ROW 4.42 COL 26 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fi-cod-depos AT ROW 5.42 COL 16 COLON-ALIGNED NO-TAB-STOP 
     fi-nome AT ROW 5.42 COL 20.57 COLON-ALIGNED HELP
          "Descriá∆o do Dep¢sito" NO-LABEL NO-TAB-STOP 
     fi-localizacao AT ROW 6.42 COL 16 COLON-ALIGNED NO-TAB-STOP 
     fi-quant-inf AT ROW 7.75 COL 16 COLON-ALIGNED
     fi-ct-codigo AT ROW 8.75 COL 16 COLON-ALIGNED
     fi-titulo AT ROW 8.75 COL 36 COLON-ALIGNED HELP
          "T°tulo da conta cont†bil" NO-LABEL NO-TAB-STOP 
     fi-sc-codigo AT ROW 9.75 COL 16 COLON-ALIGNED
     fi-descricao AT ROW 9.75 COL 36 COLON-ALIGNED HELP
          "Descriá∆o" NO-LABEL NO-TAB-STOP 
     fi-unid-negoc AT ROW 10.75 COL 16 COLON-ALIGNED WIDGET-ID 2
     fi-desc-unid-negoc AT ROW 10.75 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     "/" VIEW-AS TEXT
          SIZE 1.57 BY .79 AT ROW 4.42 COL 26.43
     RECT-5 AT ROW 1 COL 1
     RECT-6 AT ROW 2.25 COL 1
     RECT-7 AT ROW 7.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 3.71 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttae-item T "?" NO-UNDO mgesp ae-item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17.25
         WIDTH              = 90
         MAX-HEIGHT         = 27.17
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.17
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

{esp/ShowMsg.i}
{window/window.i}
{esp/eslib.i}
{btb/btb008za.i0}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fpage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON btCancela IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btConfirma IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
   Size-to-Fit                                                          */
ASSIGN 
       FRAME fPage1:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN fi-cod-depos IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-codigo IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-ct-codigo IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME fPage1
   NO-ENABLE                                                            */
ASSIGN 
       fi-desc-item:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN fi-descricao IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-localizacao IN FRAME fPage1
   NO-ENABLE                                                            */
ASSIGN 
       fi-nome:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN fi-quant-inf IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-sc-codigo IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-titulo IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fpage2
                                                                        */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR BUTTON btConfigImpr IN FRAME fPage3
   NO-ENABLE                                                            */
ASSIGN 
       fiPrinter:READ-ONLY IN FRAME fPage3        = TRUE.

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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage2
/* Query rebuild information for FRAME fpage2
     _Query            is NOT OPENED
*/  /* FRAME fpage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
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


&Scoped-define SELF-NAME btCancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancela wWindow
ON CHOOSE OF btCancela IN FRAME fpage0
DO:

    fi-historico:SCREEN-VALUE IN FRAME fpage2 = "".
    DISABLE fi-codigo fi-ct-codigo fi-quant-inf fi-sc-codigo fi-unid-negoc WITH FRAME fpage1.
    DISABLE fi-historico WITH FRAME fpage2.
    CLEAR FRAME fpage1 ALL NO-PAUSE.
    APPLY "entry" TO fi-codigo IN FRAME fpage1.    

    RUN pi-pede-usuario.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wWindow
ON CHOOSE OF btConfigImpr IN FRAME fPage3 /* Configuraá∆o da impressora */
DO:
    RUN piSelectPrinter IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btConfirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfirma wWindow
ON CHOOSE OF btConfirma IN FRAME fpage0
DO:
    DEF VAR c-usuario AS INT.
    DEF VAR c-conta LIKE conta-contab.ct-codigo.
    DEF VAR c-custo LIKE conta-contab.sc-codigo.
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

    IF fi-codigo:SCREEN-VALUE IN FRAME fpage1 = "" THEN DO:
        MESSAGE "ê necess†rio digitar o c¢digo de barras"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        LEAVE.
    END.
    IF int(fi-quant-inf:SCREEN-VALUE IN FRAME fpage1) = 0 THEN DO:
        MESSAGE "ê necess†rio informar a quantidade"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        LEAVE.
    END.
    IF fi-ct-codigo:SCREEN-VALUE IN FRAME fpage1 = "" THEN DO:
        MESSAGE "ê necess†rio informar a conta"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        LEAVE.
    END.
    

    IF fi-ct-codigo:SCREEN-VALUE IN FRAME fpage1 BEGINS "4" THEN DO:
       
        FOR FIRST param-global NO-LOCK:
        END.
       
        EMPTY TEMP-TABLE tt_log_erro.

        if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.    

        RUN pi_valida_conta_contabil IN h_api_cta_ctbl (INPUT  param-global.empresa-prin   , /** CΩdigo da Empresa do EMS2.                      **/
                                                        INPUT  ""                    , /** CΩdigo do Estabelecimento do EMS2.              **/
                                                        INPUT  ""                    , /** CΩdigo da Unidade de Neg´cio                    **/
                                                        INPUT  ""                    , /** CΩdigo do Plano de Contas                       **/ 
                                                        INPUT  INPUT FRAME fPage1 fi-ct-codigo     , /** CΩdigo da Conta                                 **/
                                                        INPUT  ""                    , /** CΩdigo do Plano de Centro de Custo              **/
                                                        INPUT  INPUT FRAME fPage1 fi-sc-codigo     , /** CΩdigo do Centro de Custo                       **/
                                                        INPUT  TODAY, /** Data da TransaØ o                               **/
                                                        OUTPUT TABLE tt_log_erro)    . /** Erros ocorridos durante a execuªío do m≤todo    **/

        FOR EACH tt_log_erro NO-LOCK:

            {utp/ut-liter.i "CΩdigo Erro Financeiro: "}
            ASSIGN cErroAux = RETURN-VALUE + CHR(01) + STRING(tt_log_erro.ttv_num_cod_erro).
            ASSIGN cInputErro = tt_log_erro.ttv_des_msg_erro + '~~~~' + tt_log_erro.ttv_des_msg_ajuda + '~~~~' + cErroAux.
            RUN utp/ut-msgs.p("show", 52046, cInputErro).


            if valid-handle(h_api_cta_ctbl) then
                delete object h_api_cta_ctbl.

            RETURN NO-APPLY.

        END.

        IF NOT CAN-FIND(FIRST tt_log_erro) THEN DO:

            if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.    

            run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  "",                 /* EMPRESA EMS 2 */
                                                             input  "",                 /* ESTABELECIMENTO EMS2 */
                                                             input  "",                 /* PLANO CONTAS */
                                                             input  INPUT FRAME fPage1 fi-ct-codigo,          /* CONTA */
                                                             input  today,              /* DT TRANSACAO */
                                                             output p_log_ccusto,    /* UTILIZA CCUSTO ? */
                                                             output table tt_log_erro). /* ERROS */

            IF p_log_ccusto THEN DO:

                IF fi-sc-codigo:SCREEN-VALUE IN FRAME fpage1 = "" THEN DO:
                    MESSAGE "ê necess†rio informar o centro de custo"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.

                    if valid-handle(h_api_cta_ctbl) then
                        delete object h_api_cta_ctbl.

                    IF VALID-HANDLE(h_api_ccusto) THEN
                        DELETE OBJECT h_api_ccusto.

                    LEAVE.
                END.

            END.

        END.

        if valid-handle(h_api_cta_ctbl) then
                delete object h_api_cta_ctbl.

        IF VALID-HANDLE(h_api_ccusto) THEN
            DELETE OBJECT h_api_ccusto.

        /**/

        IF INPUT FRAME fpage2 fi-historico = "" THEN DO:
           RUN ShowMessage(1, "Hist¢rico n∆o informado",
                           "Hist¢rico deve ser informado").
           APPLY "entry" TO fi-historico IN FRAME fpage2.
           RETURN NO-APPLY.    
        END.

        IF INPUT FRAME fpage1 fi-quant-inf > INPUT FRAME fpage1 fi-quantidade THEN DO:
           RUN ShowMessage(1, "Quantidade informada incorreta",
                           "Quantidade informada deve ser menor que a quantidade no AE").
           APPLY "entry" TO fi-quant-inf IN FRAME fpage1.
           RETURN NO-APPLY.    
        END.
        v-parcial = INPUT FRAME fpage1 fi-quant-inf < INPUT FRAME fpage1 fi-quantidade.

        FOR EACH tt-movto:
            DELETE tt-movto.
        END.

        /**/

        IF fi-sc-codigo:SCREEN-VALUE <> "" THEN DO:
    
            FOR FIRST cc_uni_estab NO-LOCK
                WHERE cc_uni_estab.cod_estab  = v_cod_estab_usuar
                AND   cc_uni_estab.cod_ccusto = fi-sc-codigo:SCREEN-VALUE:

                if fi-unid-negoc:SCREEN-VALUE <> cc_uni_estab.cod_unid_negoc THEN DO:

                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 17006,
                                       INPUT "Unidade de Neg¢cio inv†lida para CC: " + fi-sc-codigo:SCREEN-VALUE + " - Estab: " + v_cod_estab_usuar + ". Informe a Unidade do CC: " + cc_uni_estab.cod_unid_negoc + ". ~~ Para este Centro de Custo, utilizar unidade " + cc_uni_estab.cod_unid_negoc + ", conforme Planilha de Centros de Custo dispon°vel na INTRANET.").

                    RETURN NO-APPLY.

                END.

            END.

            IF NOT AVAIL cc_uni_estab THEN DO:

                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "CC: " + fi-sc-codigo:SCREEN-VALUE + " - Estab: " + v_cod_estab_usuar + " n∆o possui Unidade de Neg¢cio relacionada (ESFGL001). Solicitar o cadastro Ö Controladoria.").

                RETURN NO-APPLY.

            END.
    
        END.


        /**/

        EMPTY TEMP-TABLE tt-erro.
        EMPTY TEMP-TABLE RowErrors.

        CREATE tt-movto. /* saida */
        ASSIGN tt-movto.cod-versao-integracao = 001
                tt-movto.cod-prog-orig = "{&Program}"
                tt-movto.cod-depos   = lower(INPUT FRAME fpage1 fi-cod-depos)
                tt-movto.cod-localiz = v-localizacao
                tt-movto.cod-estabel = v_cod_estab_usuar
                tt-movto.ct-codigo   = INPUT FRAME fpage1 fi-ct-codigo 
                tt-movto.sc-codigo   = INPUT FRAME fpage1 fi-sc-codigo
                tt-movto.cod-unid-negoc = INPUT FRAME fPage1 fi-unid-negoc
                tt-movto.esp-docto   = 28
                tt-movto.it-codigo   = INPUT FRAME fpage1 fi-it-codigo
                tt-movto.nro-docto   = STRING(v-ae)
                tt-movto.cod-emitente = 0
                tt-movto.quantidade  =  if v-parcial 
                                        then INPUT FRAME fpage1 fi-quant-inf 
                                        else INPUT FRAME fpage1 fi-quantidade
                tt-movto.serie-docto = INPUT FRAME fpage1 fi-sequencia
                tt-movto.tipo-trans  = 2     /* saida */
                tt-movto.un          = item.un
                tt-movto.num-sequen  = 1
                tt-movto.dt-trans    = today
                tt-movto.descricao-db = INPUT FRAME fpage2 fi-historico
                tt-movto.usuario      = c-seg-usuario.

        IF ITEM.tipo-con-est = 3 THEN DO: /* Item Controlado por Lote */ 
           ASSIGN tt-movto.lote = "GENERICO".
        END.

        RUN pi-inicializar in h-acomp (input "Executando...").
        RUN pi-desabilita-cancela IN h-acomp.

        RUN pi-valida-usuario-responsavel.

        IF RETURN-VALUE = "OK" THEN DO:
            RUN pi-acompanhar in h-acomp (input "Gerando movimentaá∆o...").

            run cep/ceapi001k.p persistent set h-ceapi001k.
            if  valid-handle (h-ceapi001k) then do:
                run pi-execute IN h-ceapi001k (input-output table tt-movto,
                                               input-output table tt-erro, 
                                               input        yes).
        
                delete procedure h-ceapi001k.
                assign h-ceapi001k = ?.
            end.

        END.

        RUN pi-finalizar IN h-acomp.

        FOR EACH tt-erro:
            CREATE RowErrors.
            ASSIGN RowErrors.errorsequence    = tt-erro.i-sequen
                   RowErrors.errornumber      = tt-erro.cd-erro
                   RowErrors.errordescription = tt-erro.mensagem
                   RowErrors.errortype        = "ERROR":U
                   RowErrors.ErrorSubType     = "ERROR":U
                   RowErrors.errorhelp        = tt-erro.mensagem.
        END.
        IF CAN-FIND(FIRST RowErrors WHERE 
                          RowErrors.errortype = "ERROR":U) THEN DO:
           {method/ShowMessage.i1}.
           {method/ShowMessage.i2 &Modal="YES"}.
           {method/ShowMessage.i3}.
           IF v-parcial THEN
              APPLY "entry" TO fi-quant-inf IN FRAME fpage1.
           ELSE
              IF item.tipo-requis = 3 THEN
                 APPLY "entry" TO fi-sc-codigo IN FRAME fpage1.
              ELSE 
                 APPLY "entry" TO fi-ct-codigo IN FRAME fpage1.
              RETURN NO-APPLY.
        END.
        ttae-item.situacao = YES.

        RUN setConstraintByAE IN {&hDBOTable} (INPUT v_cod_estab_usuar,
                                               INPUT v-ae,
                                               INPUT v-ae,
                                               INPUT v-sequencia,
                                               INPUT v-sequencia).
        RUN openQueryStatic IN {&hDBOTable} (INPUT "ByAE":U) NO-ERROR.
        RUN setrecord IN {&hDBOTable} (INPUT TABLE ttae-item).  
        RUN updaterecord IN {&hDBOTable}.                        
        IF v-parcial THEN RUN pi-gera-ae.

        APPLY "choose" TO btCancela IN FRAME fpage0.  

        ENABLE fi-codigo fi-ct-codigo fi-quant-inf /*fi-sc-codigo*/ WITH FRAME fpage1.
    
        APPLY "ENTRY" TO fi-codigo IN FRAME fpage1.
    END.
    ELSE DO:
        MESSAGE "Conta incorreta. Informe uma conta permitida." VIEW-AS ALERT-BOX INFO BUTTONS OK.
        LEAVE.
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fi-cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos wWindow
ON LEAVE OF fi-cod-depos IN FRAME fPage1 /* Dep¢sito de Sa°da */
DO:
  {include/leave.i &tabela=deposito
                   &atributo-ref=nome
                   &variavel-ref=fi-nome
                   &where="deposito.cod-dep = fi-cod-depos:screen-value in frame fpage1"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-codigo wWindow
ON ENTRY OF fi-codigo IN FRAME fPage1 /* C¢digo de Barras */
DO:
    SESSION:DATA-ENTRY-RETURN = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-codigo wWindow
ON RETURN OF fi-codigo IN FRAME fPage1 /* C¢digo de Barras */
DO:
    RUN pi-valida-codigo.
    IF RETURN-VALUE = "NOK" THEN DO:
        SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    RUN pi-requisicao.
    IF RETURN-VALUE = "NOK" THEN DO:
        SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ct-codigo wWindow
ON LEAVE OF fi-ct-codigo IN FRAME fPage1 /* Conta */
DO:
    /*
    {include/leave.i &tabela=conta
                     &atributo-ref=titulo
                     &variavel-ref=fi-titulo
                     &where="conta.ct-codigo = fi-ct-codigo:screen-value in frame fpage1"}
                     */

    IF INPUT FRAME fPage1 fi-ct-codigo <> "" THEN DO:

        /* Leave do campo de Conta */
        ASSIGN v_cod_conta = INPUT FRAME fPage1 fi-ct-codigo.
        
        EMPTY TEMP-TABLE tt_log_erro.
        if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.    
            run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (INPUT "",
                                                      INPUT "",
                                                      INPUT-OUTPUT v_cod_conta,
                                                      INPUT TODAY,
                                                      OUTPUT v_des_titulo_conta,
                                                      OUTPUT v_num_tip_cta_ctbl,
                                                      OUTPUT v_num_sit_cta_ctbl,
                                                      OUTPUT v_ind_finalid_cta,
                                                      OUTPUT TABLE tt_log_erro).

    END.

    /***/

    /** Instancia aplicativo **/
{method/showmessage.i1}

/** cria rowerrors **/
FOR EACH tt_log_erro NO-LOCK:
        CREATE RowErrors.
        
        ASSIGN RowErrors.errorNumber = tt_log_erro.ttv_num_cod_erro
               RowErrors.errorHelp   = tt_log_erro.ttv_des_msg_ajuda
               RowErrors.errorDescription = tt_log_erro.ttv_des_msg_erro
           RowErrors.errorsequence = i-seq-erros-api-ctb-cc
           i-seq-erros-api-ctb-cc = i-seq-erros-api-ctb-cc + 1.

END.

IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:
    /** Mostra caixa com erros **/
    {method/showmessage.i2 &Modal="YES"}
END.
/** Limpa temp-tables de erros **/
{method/showmessage.i3}


/*limpa RowErrors para que nío haja lixo na proxima vez que executar*/
EMPTY TEMP-TABLE RowErrors.


    /****/

    IF CAN-FIND(FIRST tt_log_erro) THEN DO:
        ASSIGN fi-sc-codigo:SENSITIVE IN FRAME fPage1 = FALSE
               fi-sc-codigo:SCREEN-VALUE IN FRAME fPage1 = ""
               fi-sc-codigo:FORMAT IN FRAME fPage1 = "x(20)"
               fi-ct-codigo:FORMAT IN FRAME fPage1 = "x(20)" NO-ERROR.
        RETURN.
    END.

    ASSIGN fi-ct-codigo:SCREEN-VALUE IN FRAME fPage1 = v_cod_conta
           fi-titulo:SCREEN-VALUE IN FRAME fPage1 = v_des_titulo_conta.
        
        IF p_cod_format_cta_ctbl <> "" THEN
        ASSIGN fi-ct-codigo:FORMAT IN FRAME fPage1 = p_cod_format_cta_ctbl NO-ERROR.
    
    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (INPUT "",
                                                       INPUT "",
                                                       INPUT "",
                                                       INPUT v_cod_conta,
                                                       INPUT TODAY,
                                                       OUTPUT p_log_ccusto,
                                                       OUTPUT TABLE tt_log_erro).
    
    IF p_log_ccusto THEN DO:
                ASSIGN costCenterAlreadyEnabled = fi-sc-codigo:SENSITIVE IN FRAME fPage1.
                IF fi-ct-codigo:SENSITIVE IN FRAME fPage1 THEN
                        ASSIGN fi-sc-codigo:SENSITIVE IN FRAME fPage1 = TRUE.
                
        run pi_retorna_formato_ccusto in h_api_ccusto (INPUT "",
                                                       INPUT "",
                                                       INPUT "",
                                                       OUTPUT p_cod_format_ccusto,
                                                       OUTPUT TABLE tt_log_erro).
        
                run pi_retorna_valor_inic_fim_formato in h_api_ccusto (INPUT p_cod_format_ccusto,
                                                       OUTPUT c-ccusto-inicial,
                                                       OUTPUT c-ccusto-final,
                                                       OUTPUT TABLE tt_log_erro).

                IF INPUT FRAME fPage1 fi-sc-codigo = "" THEN DO:
                        ASSIGN fi-sc-codigo:SCREEN-VALUE IN FRAME fPage1 = c-ccusto-inicial NO-ERROR.
                END.

                IF p_cod_format_ccusto <> "" THEN
                        ASSIGN fi-sc-codigo:FORMAT IN FRAME fPage1 = p_cod_format_ccusto NO-ERROR.
                
                if valid-handle(h_api_cta_ctbl) then
                        delete object h_api_cta_ctbl.
            if valid-handle(h_api_ccusto) then
                        delete object h_api_ccusto.
                
                IF NOT costCenterAlreadyEnabled THEN DO:
                        APPLY 'entry' to fi-sc-codigo IN FRAME fPage1.
                        
                        return no-apply.
                END.
    END.
    ELSE DO:
        ASSIGN fi-sc-codigo:SENSITIVE IN FRAME fPage1 = FALSE
               fi-sc-codigo:SCREEN-VALUE IN FRAME fPage1 = ""
               fi-descricao:SCREEN-VALUE IN FRAME fPage1 = ""
               fi-sc-codigo:FORMAT IN FRAME fPage1 = "x(20)" NO-ERROR.
    END.
        
        if valid-handle(h_api_cta_ctbl) then
                delete object h_api_cta_ctbl.
    if valid-handle(h_api_ccusto) then
                delete object h_api_ccusto.
                     
    v-conta[IF item.tipo-requis = 3 THEN 1 ELSE 2] = SELF:SCREEN-VALUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ct-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-ct-codigo IN FRAME fPage1 /* Conta */
OR F5 OF fi-ct-codigo IN FRAME fpage1 DO:


    /*
    {include/zoomvar.i &prog-zoom="adzoom/z01ad049"
                       &campo="fi-ct-codigo"
                       &campozoom="ct-codigo"
                       &frame="fpage1"
                       &campo2="fi-sc-codigo"
                       &campozoom2="sc-codigo"
                       &frame2="fpage1"
                       &campo3="fi-titulo"
                       &campozoom3="titulo"
                       &frame3="fpage1"}
                       */

    ASSIGN l-implanta = YES.
        
    if not valid-handle(h_api_cta_ctbl) then 
                run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
    
        assign v_cod_finalid = "(nenhum)".
        
    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT "",
                                                  INPUT "CEP",
                                                  INPUT "",
                                                  INPUT v_cod_finalid,
                                                  INPUT TODAY,
                                                  OUTPUT v_cod_cta_ctbl,
                                                  OUTPUT v_des_titulo_conta,
                                                  OUTPUT p-finalidade,
                                                  OUTPUT TABLE tt_log_erro).
    /*{cdp/cdunif001b.i1}*/
        
        IF v_cod_cta_ctbl <> "" THEN
                        ASSIGN fi-ct-codigo:SCREEN-VALUE IN FRAME fPage1 = v_cod_cta_ctbl.
                               fi-titulo:SCREEN-VALUE IN FRAME fPage1 = v_des_titulo_conta.

        if valid-handle(h_api_cta_ctbl) then
                                        delete object h_api_cta_ctbl.  

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON LEAVE OF fi-it-codigo IN FRAME fPage1 /* Item */
DO:
    {include/leave.i &tabela=ITEM
                     &atributo-ref=desc-item
                     &variavel-ref=fi-desc-item
                     &where="item.it-codigo = fi-it-codigo:screen-value in frame fpage1"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-sc-codigo wWindow
ON LEAVE OF fi-sc-codigo IN FRAME fPage1 /* Centro Custo */
DO: 

    ASSIGN v_cod_ccusto = INPUT FRAME fPage1 fi-sc-codigo.

    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.

    run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                               input  "",                  /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,        /* CCUSTO */
                                               input TODAY,                /* DATA DE TRANSACAO */
                                               output v_des_titulo_ccusto, /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro).  /* ERROS */
    
    ASSIGN fi-descricao:SCREEN-VALUE IN FRAME fPage1 = v_des_titulo_ccusto.     

    if valid-handle(h_api_ccusto) then
                delete object h_api_ccusto.
  
    v-subconta[IF item.tipo-requis = 3 THEN 1 ELSE 2] = SELF:SCREEN-VALUE.

    /**/

    IF self:SCREEN-VALUE <> "" THEN DO:

        FOR FIRST cc_uni_estab NO-LOCK
            WHERE cc_uni_estab.cod_estab  = v_cod_estab_usuar
            AND   cc_uni_estab.cod_ccusto = self:SCREEN-VALUE:

            ASSIGN fi-unid-negoc:SCREEN-VALUE = cc_uni_estab.cod_unid_negoc.

        END.

    END.   
           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-sc-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-sc-codigo IN FRAME fPage1 /* Centro Custo */
OR F5 OF fi-sc-codigo IN FRAME fpage1 DO:

    /*
    IF fi-ct-codigo:SENSITIVE IN FRAME fpage1 THEN
        APPLY "f5" TO fi-ct-codigo IN FRAME fpage1.
    ELSE DO:
        {include/zoomvar.i &prog-zoom="adzoom/z01ad246"
                           &campo="fi-sc-codigo"
                           &campozoom="sc-codigo"
                           &frame="fpage1"
                           &campo2="fi-descricao"
                           &campozoom2="descricao"
                           &frame2="fpage1"}
    END.
    */


    FIND FIRST param-global NO-LOCK NO-ERROR.
    ASSIGN i-ep-codigo-usuario = param-global.empresa-prin
           l-implanta          = YES.

    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.

    run pi_zoom_ccusto in h_api_ccusto (INPUT "",
                                        INPUT "",
                                        INPUT "",
                                        INPUT today,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_titulo_ccusto,
                                        OUTPUT TABLE tt_log_erro).
    
    if v_cod_ccusto <> "" then
                ASSIGN fi-sc-codigo:SCREEN-VALUE IN FRAME fPage1 = v_cod_ccusto
                       fi-descricao:SCREEN-VALUE IN FRAME fPage1 = v_des_titulo_ccusto.
        
    if valid-handle(h_api_ccusto) then
                delete object h_api_ccusto.   


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-unid-negoc wWindow
ON F5 OF fi-unid-negoc IN FRAME fPage1 /* Unid Negoc */
DO:

    IF SEARCH("prgint/utb/utb011ka.p") <> ? OR
       SEARCH("prgint/utb/utb011ka.r") <> ? THEN DO:

        RUN prgint/utb/utb011ka.p PERSISTENT SET wh-pesquisa-un.

        IF v_cod_unid_negoc <> " ":U THEN
            ASSIGN fi-unid-negoc = v_cod_unid_negoc.

        DISPLAY fi-unid-negoc 
            WITH FRAME fPage1.

        APPLY "LEAVE":U TO fi-unid-negoc  IN FRAME fPage1.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-unid-negoc wWindow
ON LEAVE OF fi-unid-negoc IN FRAME fPage1 /* Unid Negoc */
DO:

    ASSIGN INPUT FRAME fPage1 fi-unid-negoc.

    FIND FIRST unid_negoc NO-LOCK
        WHERE unid_negoc.cod_unid_negoc = fi-unid-negoc NO-ERROR.
    
    IF AVAIL unid_negoc THEN
        ASSIGN fi-desc-unid-negoc:SCREEN-VALUE IN FRAME fPage1 = unid_negoc.des_unid_negoc.
    ELSE 
        ASSIGN fi-desc-unid-negoc:SCREEN-VALUE IN FRAME fPage1 = "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
fi-ct-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage1.
fi-sc-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage1.
fi-unid-negoc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage1.

{window/MainBlock.i}



/*  */
    RUN esp\es0018p.p (INPUT "escep011",
                       INPUT 3,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
/* Fim seleá∆o usu†rio */


    DISABLE fi-codigo fi-ct-codigo fi-quant-inf fi-sc-codigo fi-unid-negoc WITH FRAME fpage1.


     /*
      fi-codigo:SENSITIVE IN FRAME fpage1 = FALSE.
      fi-quant-inf:SENSITIVE IN FRAME fpage1 = FALSE.
      fi-ct-codigo:SENSITIVE IN FRAME fpage1 = FALSE.
      fi-sc-codigo:SENSITIVE IN FRAME fpage1 = FALSE.
      */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterchangePage wWindow 
PROCEDURE AfterchangePage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN getCurrentFolder IN hFolder (OUTPUT i-page).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterdestroyInterface wWindow 
PROCEDURE AfterdestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(hWindowStyles) THEN
        DELETE PROCEDURE hWindowStyles.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterinitializeInterface wWindow 
PROCEDURE AfterinitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    RUN initializeDBOs.
    RUN pi-carrega-permissoes.
    RUN pi-pede-usuario.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforedestroyInterface wWindow 
PROCEDURE BeforedestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        &IF "{&hDBOTable}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable}) THEN
                RUN destroy IN {&hDBOTable}.
        &ENDIF

        &IF "{&hDBOTable2}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable2}) THEN
                RUN destroy IN {&hDBOTable2}.
        &ENDIF

        &IF "{&hDBOTable3}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable3}) THEN
                RUN destroy IN {&hDBOTable3}.
        &ENDIF

        &IF "{&hDBOTable4}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable4}) THEN
                RUN destroy IN {&hDBOTable4}.
        &ENDIF

        &IF "{&hDBOTable5}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable5}) THEN
                RUN destroy IN {&hDBOTable5}.
        &ENDIF
        
        &IF "{&hDBOTable6}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable6}) THEN
                RUN destroy IN {&hDBOTable6}.
        &ENDIF

        &IF "{&hDBOTable7}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable7}) THEN
                RUN destroy IN {&hDBOTable7}.
        &ENDIF

        &IF "{&hDBOTable8}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable8}) THEN
                RUN destroy IN {&hDBOTable8}.
        &ENDIF

        &IF "{&hDBOTable9}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable9}) THEN
                RUN destroy IN {&hDBOTable9}.
        &ENDIF
        
        &IF "{&hDBOTable10}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable10}) THEN
                RUN destroy IN {&hDBOTable10}.
        &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "esbo/boes010.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes010.p YES}
        {btb/btb008za.i2 esbo/boes010.p '' {&hDBOTable}}
    END.
    
    run setConstraintMain in {&hDBOTable} (input v_cod_estab_usuar).

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mostraMensagemPanico wWindow 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-permissoes wWindow 
PROCEDURE pi-carrega-permissoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN esp\es0018p.p (INPUT c-programa,
                       INPUT 1,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto1).

    v-permite-quebra = CAN-FIND(FIRST tt-prog-ponto1 
                                WHERE tt-prog-ponto.conteudo = c-seg-usuario).

    ASSIGN v-permite-parcial = YES.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-erro wWindow 
PROCEDURE pi-cria-erro :
DEF INPUT PARAMETER p-mensagem AS CHAR NO-UNDO.

    CREATE RowErrors.
    ASSIGN RowErrors.errorsequence    = 1
           RowErrors.errornumber      = 2
           RowErrors.errordescription = p-mensagem
           RowErrors.errortype        = "ERROR":U
           RowErrors.ErrorSubType     = "ERROR":U
           RowErrors.errorhelp        = p-mensagem.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-ae wWindow 
PROCEDURE pi-gera-ae :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var i-sequencia as int no-undo.
    
    find last mgesp.ae-item no-lock
        where mgesp.ae-item.cod-estabel = v_cod_estab_usuar
        and   mgesp.ae-item.nr-ae       = ttae-item.nr-ae no-error.
        
    i-sequencia = if avail mgesp.ae-item then mgesp.ae-item.sequencia + 1 else 1.
    
    create ae-item.
    assign ae-item.cod-estabel          = v_cod_estab_usuar
           ae-item.nr-ae                = ttae-item.nr-ae
           ae-item.sequencia            = i-sequencia
           ae-item.it-codigo            = INPUT FRAME fpage1 fi-it-codigo 
           ae-item.localizacao          = ttae-item.localizacao
           ae-item.quantidade           = ttae-item.quantidade - INPUT FRAME fpage1 fi-quant-inf
           ae-item.data                 = ttae-item.data
           ae-item.roteiro              = ttae-item.roteiro
           ae-item.nf                   = ttae-item.nf
           ae-item.impresso             = YES
           ae-item.situacao             = NO
           ae-item.cod-depos            = INPUT FRAME fpage1 fi-cod-depos.
           
    RUN pi-imprime-etiquetas (INPUT ttae-item.nr-ae, INPUT i-sequencia).
        
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-ae-old wWindow 
PROCEDURE pi-gera-ae-old :
/* Atená∆o procedimento desativado 

/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR r-rowid AS ROWID NO-UNDO.
    DEF VAR p-nr-ae AS INT NO-UNDO.
    DEF VAR p-seq AS INT NO-UNDO.



    EMPTY TEMP-TABLE ttae-item-aux.

    create ttae-item-aux.
    assign ttae-item-aux.it-codigo   = INPUT FRAME fpage1 fi-it-codigo
           ttae-item-aux.nr-ae       = ttae-item.nr-ae
           ttae-item-aux.sequencia   = 0
           ttae-item-aux.localizacao = ttae-item.localizacao
           ttae-item-aux.quantidade  = ttae-item.quantidade - INPUT FRAME fpage1 fi-quant-inf
           ttae-item-aux.data        = ttae-item.data
           ttae-item-aux.roteiro     = ttae-item.roteiro
           ttae-item-aux.nf          = ttae-item.nf
           ttae-item-aux.impresso    = YES
           ttae-item-aux.situacao    = NO
           ttae-item-aux.cod-depos   = INPUT FRAME fpage1 fi-cod-depos.
    

    RUN emptyRowErrors IN {&hDBOTable} NO-ERROR.        
    RUN openQueryStatic IN {&hDBOTable} (INPUT "first":U) NO-ERROR.
    RUN setrecord IN {&hDBOTable} (INPUT TABLE ttae-item-aux).

    RUN beforeCreateRecord IN {&hDBOTable} (OUTPUT p-nr-ae, OUTPUT p-seq).        

    RUN createrecord IN {&hDBOTable}.             


/*
    MESSAGE "ae: " ttae-item-aux.nr-ae "p-nr-ae: " p-nr-ae "p-seq: " p-seq
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/



    RUN getrowerrors IN {&hDBOTable} (OUTPUT TABLE rowerrors).
    

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
        {method/ShowMessage.i1}.
        {method/ShowMessage.i2 &Modal="YES"}.
        {method/ShowMessage.i3}.
        RETURN "NOK".
    END.

    RUN getRowid IN {&hDBOTable} (OUTPUT r-rowid).

    RUN pi-imprime-etiquetas (INPUT p-nr-ae, INPUT p-seq).
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-imprime-etiquetas wWindow 
PROCEDURE pi-imprime-etiquetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* DEF INPUT PARAM p-rowid AS ROWID NO-UNDO.*/

    DEF INPUT PARAM p-nr-ae AS INT NO-UNDO.
    DEF INPUT PARAM p-seq AS INT NO-UNDO.


    FOR FIRST ae-item NO-LOCK       WHERE
        ae-item.cod-estabel = v_cod_estab_usuar and
        ae-item.nr-ae    = p-nr-ae AND
        ae-item.sequencia = p-seq:

        /*
        RUN imprimeAE(INPUT INPUT FRAME fpage3 cb-impressora,
                      INPUT INPUT FRAME fpage3 rs-destino,
                      INPUT ae-item.nr-ae,
                      INPUT ae-item.sequencia,
                      INPUT ae-item.sequencia).
        */

        IF NOT valid-handle(h_esapi020) THEN RUN esapi/esapi020.p PERSISTENT SET h_esapi020.

        RUN pi-imprime-AE IN h_esapi020 (INPUT INPUT FRAME fpage3 fiPrinter,
                                         INPUT ae-item.cod-estabel,
                                         INPUT ae-item.nr-ae,
                                         INPUT ae-item.sequencia,      
                                         INPUT c-seg-usuario).

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pede-usuario wWindow 
PROCEDURE pi-pede-usuario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR first-time AS LOGICAL NO-UNDO INIT YES.  


  c-old-usuario = v_cod_usuar_corren.
  
  fi-codigo:SENSITIVE IN FRAME fpage1 = TRUE.
  fi-quant-inf:SENSITIVE IN FRAME fpage1 = TRUE.
  fi-ct-codigo:SENSITIVE IN FRAME fpage1 = TRUE.
  fi-sc-codigo:SENSITIVE IN FRAME fpage1 = TRUE.
  fi-unid-negoc:SENSITIVE IN FRAME fpage1 = TRUE.
  ENABLE fi-codigo fi-ct-codigo fi-quant-inf fi-sc-codigo fi-unid-negoc WITH FRAME fpage1.

  l-usuario = YES.

  APPLY "ENTRY" TO fi-codigo IN FRAME fPage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-requisicao wWindow 
PROCEDURE pi-requisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR iRowsReturned AS INTEGER NO-UNDO.
    DEF VAR da-prox-ae-item AS DATE NO-UNDO.
    DEF VAR c-anterior AS CHAR NO-UNDO.

    IF v-ae > 0 THEN DO:
        RUN setConstraintByAE IN {&hDBOTable} (INPUT v_cod_estab_usuar,
                                               INPUT v-ae,
                                               INPUT v-ae,
                                               INPUT v-sequencia,
                                               INPUT v-sequencia).
        RUN openQueryStatic IN {&hDBOTable} (INPUT "ByAE2":U) NO-ERROR.
        RUN getRecord IN {&hDBOTable} (OUTPUT TABLE ttae-item).
        FOR FIRST ttae-item:
            DISP ttae-item.cod-depos @ fi-cod-depos 
                 ttae-item.localizacao @ fi-localizacao WITH FRAME fpage1.
            APPLY "leave" TO fi-cod-depos IN FRAME fpage1.
            if congelado (input v_cod_estab_usuar,
                          INPUT v-it-codigo,
                          INPUT INPUT FRAME fpage1 fi-cod-depos,
                          INPUT ?)
            THEN DO:
                RUN ShowMessage(1, "Item/Dep¢sito/Localizaá∆o de Origem Congelada", "Item/Dep¢sito/Localizaá∆o de origem congelada para invent†rio").
                RETURN "NOK".
            END.

            IF  l-unidade-negocio
            AND l-mat-unid-negoc THEN DO:
    
                run cdp/cdapi024.p persistent set h-cdapi024.
                if  valid-handle(h-cdapi024) then do:
                    run retornaUnidadeNegocio IN h-cdapi024 (input v_cod_estab_usuar,
                                                             input INPUT FRAME fPage1 fi-it-codigo,
                                                             input INPUT FRAME fPage1 fi-cod-depos,
                                                             output fi-unid-negoc).

                    DISP fi-unid-negoc WITH FRAME fPage1.

                    APPLY "LEAVE" TO fi-unid-negoc IN FRAME fPage1.
        
                    delete procedure h-cdapi024.
                    assign h-cdapi024 = ?.
                end.
        
    
            end.

            ASSIGN v-localizacao = ttae-item.localizacao
                   v-parcial     = NO.
            RUN setConstraintByFIFO IN {&hDBOTable} (INPUT v_cod_estab_usuar,
                                                     INPUT v-it-codigo,
                                                     INPUT v-it-codigo,
                                                     INPUT 01/01/1900,
                                                     INPUT 12/31/2999,
                                                     INPUT NO,
                                                     INPUT ?).
            RUN openQueryStatic IN {&hDBOTable} (INPUT "ByFIFO":U) NO-ERROR.
            RUN getBatchRecords IN {&hDBOTable} (INPUT ?,
                                                 INPUT NO,
                                                 INPUT ?,
                                                 OUTPUT iRowsReturned,
                                                 OUTPUT TABLE ttae-item-aux).

            FOR EACH ttae-item-aux use-index fifo
                WHERE ttae-item-aux.cod-depos = INPUT FRAME fpage1 fi-cod-depos:
                IF NOT CAN-FIND(FIRST ae-bloqueado 
                                where ae-bloqueado.cod-estabel = v_cod_estab_usuar
                                and   ae-bloqueado.nr-ae = ttae-item-aux.nr-ae NO-LOCK) THEN DO:
                    ASSIGN da-prox-ae-item = ttae-item-aux.data
                           c-anterior = substitute("Existe lote com data anterior:~nAE &1/&2 - &3 - &4", 
                                                   trim(string(ttae-item-aux.nr-ae)),
                                                   STRING(ttae-item-aux.sequencia,"999"),
                                                   string(ttae-item-aux.data),
                                                   ttae-item-aux.localizacao).
                    LEAVE.
                END.
            END.
            /*
            IF NOT ttae-item.situacao AND ttae-item.data > da-prox-ae-item THEN DO:
                IF v-permite-quebra THEN DO:
                    RUN ShowMessage(3, "Existe lote com data anterior", c-anterior + ".~n~nConfirma quebra de seqÅància?").
                    IF RETURN-VALUE = "no" THEN DO:
                        RETURN "NOK".
                    END.
                END.
                ELSE DO:
                    RUN ShowMessage(1, "Existe lote com data anterior", c-anterior).
                    RETURN "NOK".
                END.
            END.
            */
            IF ttae-item.situacao THEN DO:
                RUN ShowMessage(1, "AE baixado", 
                                substitute("AE &1/&2 j† est† baixado", STRING(v-ae), STRING(v-sequencia,"999"))).
                RETURN "NOK".
            END.
            IF ttae-item.quantidade = v-quantidade THEN DO:
                if congelado (input v_cod_estab_usuar,
                              INPUT v-it-codigo,
                              INPUT INPUT FRAME fpage1 fi-cod-depos,
                              INPUT v-localizacao)
                THEN DO:
                    RUN ShowMessage(1, "Item/Dep¢sito/Localizaá∆o de Origem Congelada", "Item/Dep¢sito/Localizaá∆o de origem congelada para invent†rio").
                    RETURN "NOK".
                END.
            END.
            ELSE DO:
                RUN ShowMessage(1, "Quantidade n∆o confere", 
                                substitute("Quantidade Informada &1 n∆o confere com a quantidade do AE: &2", STRING(v-quantidade), STRING(ttae-item.quantidade))).
                RETURN "NOK".
            END.
        END.
        IF NOT AVAIL ttae-item THEN DO:
            RUN ShowMessage(1, "AE n∆o cadastrado", 
                            substitute("AE &1/&2 n∆o est† cadastrado", STRING(v-ae), STRING(v-sequencia,"999"))).
            RETURN "NOK".
        END.

        ASSIGN fi-historico  = ""
               fi-ct-codigo = v-conta[2]
               fi-sc-codigo = v-subconta[2].

        IF item.tipo-requis = 3 THEN DO:
            ASSIGN fi-ct-codigo = v-conta[1]
                   fi-sc-codigo = v-subconta[1]
                   fi-historico  = "Requisiá∆o de material de consumo via c¢digo de barras".
            DISPLAY fi-ct-codigo WITH FRAME fpage1.

            DISABLE fi-ct-codigo WITH FRAME fpage1.
            /*FOR FIRST conta FIELDS (titulo) NO-LOCK
                WHERE conta.ct-codigo = fi-ct-codigo:
                DISP conta.titulo @ fi-titulo WITH FRAME fpage1.
            END.*/
        END.
        ELSE ENABLE fi-ct-codigo WITH FRAME fpage1.
        DISP fi-ct-codigo fi-sc-codigo WITH FRAME fpage1.
        DISP fi-historico WITH FRAME fpage2.
        APPLY "leave" TO fi-ct-codigo IN FRAME fpage1.
        APPLY "leave" TO fi-sc-codigo IN FRAME fpage1.
        ENABLE fi-sc-codigo fi-quant-inf WITH FRAME fpage1.
        ENABLE fi-historico WITH FRAME fpage2.
        IF v-permite-parcial THEN DO:
            ENABLE fi-quant-inf WITH FRAME fpage1.
            APPLY "entry" TO fi-quant-inf IN FRAME fpage1.
        END.
        ELSE DO:
            DISABLE fi-quant-inf WITH FRAME fpage1.
            IF fi-ct-codigo:SENSITIVE IN FRAME fpage1 THEN
                APPLY "entry" TO fi-ct-codigo IN FRAME fpage1.
            ELSE
                APPLY "entry" TO fi-sc-codigo IN FRAME fpage1.
        END.







        /*
        ASSIGN fi-historico  = ""
               fi-ct-codigo = v-conta[2]
               fi-sc-codigo = v-subconta[2].

        IF item.tipo-requis = 3 THEN DO:
            ASSIGN fi-ct-codigo = v-conta[1]
                   fi-sc-codigo = v-subconta[1]
                   fi-historico  = "Requisiá∆o de material de consumo via c¢digo de barras".
            DISPLAY fi-ct-codigo WITH FRAME fpage1.

            DISABLE fi-ct-codigo WITH FRAME fpage1.
            FOR FIRST conta FIELDS (titulo) NO-LOCK
                WHERE conta.ct-codigo = fi-ct-codigo:
                DISP conta.titulo @ fi-titulo WITH FRAME fpage1.
            END.
        END.
        ELSE 
            ENABLE fi-ct-codigo WITH FRAME fpage1.

        DISP fi-ct-codigo fi-sc-codigo WITH FRAME fpage1.
        DISP fi-historico WITH FRAME fpage2.
        APPLY "leave" TO fi-ct-codigo IN FRAME fpage1.
        APPLY "leave" TO fi-sc-codigo IN FRAME fpage1.
        ENABLE fi-sc-codigo fi-quant-inf WITH FRAME fpage1.
        ENABLE fi-historico WITH FRAME fpage2.
        IF v-permite-parcial THEN DO:
            ENABLE fi-quant-inf WITH FRAME fpage1.
            APPLY "entry" TO fi-quant-inf IN FRAME fpage1.
        END.
        ELSE DO:
            DISABLE fi-quant-inf WITH FRAME fpage1.
            IF fi-ct-codigo:SENSITIVE IN FRAME fpage1 THEN
                APPLY "entry" TO fi-ct-codigo IN FRAME fpage1.
            ELSE
                APPLY "entry" TO fi-sc-codigo IN FRAME fpage1.
        END.
        */
        
        RETURN "OK". 
        
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-codigo wWindow 
PROCEDURE pi-valida-codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-codigo as char NO-UNDO.
    DEF VAR iqtd AS INTEGER NO-UNDO.
    def var c-digito     as int  format "9" initial 0.
    def var c-linha      as char format "x(20)".
    DEF VAR i-sequencia AS INT NO-UNDO.
    def var i-it-digito  as integer format "9" initial 0.
    def var c-quantidade as char format "x(06)".
    DEF VAR c-ae AS CHAR NO-UNDO.
    DEF VAR c-sequencia AS CHAR NO-UNDO.

    ASSIGN c-codigo = trim(INPUT FRAME fpage1 fi-codigo). 

    CASE LENGTH(c-codigo):
        WHEN 23 THEN DO:
           assign c-digito     = int(substring(c-codigo,23,1))
                  v-it-codigo  = substring(c-codigo,1,7) 
                  c-quantidade = substring(c-codigo,8,5) 
                  c-ae         = substring(c-codigo,13,7)
                  c-sequencia  = substring(c-codigo,20,3)
                  c-linha      = v-it-codigo + c-quantidade + c-ae + c-sequencia
                  v-ae         = INT(c-ae)
                  v-quantidade = INT(c-quantidade)
                  v-sequencia  = INT(c-sequencia).
        END.
        WHEN 26 THEN DO:
            assign v-it-codigo = substring(c-codigo,7,7)
                  c-quantidade = substring(c-codigo,14,6)
                      c-digito = int(substring(c-codigo,26,1))
                       c-linha = substring(c-codigo,1,25)
                  v-quantidade = INT(c-quantidade)
                          v-ae = 0
                   v-sequencia = 0.
        END.
        OTHERWISE DO:
            RUN ShowMessage(1, "Tamanho da Etiqueta Incorreto", "Tamanho da Etiqueta Incorreto. Chame o Respons†vel").
            return "NOK".
        END.
    END CASE.

    run esp/es0135(input c-linha, output i-it-digito).
    IF c-digito <> i-it-digito then do:
        RUN ShowMessage(1, "D°gito verificador n∆o confere", "D°gito verificador n∆o confere - Erro na leitura").
        return "NOK".
    END.

    FOR FIRST item FIELDS (tipo-requis un) NO-LOCK WHERE
              item.it-codigo = v-it-codigo:
    END.

    IF NOT AVAIL ITEM THEN DO:
        RUN ShowMessage(1, "Item n∆o cadastrado", substitute("Item &1 n∆o est† cadastrado", TRIM(v-it-codigo))).
        RETURN "NOK".
    END.

    DISP v-it-codigo  @ fi-it-codigo
         v-quantidade @ fi-quantidade
         v-ae         @ fi-nr-ae
         v-sequencia  @ fi-sequencia
        WITH FRAME fpage1.

    DISP v-quantidade @ fi-quant-inf
        WITH FRAME fpage1.

    APPLY "leave" TO fi-it-codigo IN FRAME fpage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-usuario-responsavel wWindow 
PROCEDURE pi-valida-usuario-responsavel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-assunto  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.

    FIND FIRST usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-ERROR.
    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = tt-movto.it-codigo NO-ERROR.

    ASSIGN c-assunto = "Ol†," + "~n" +
                        "O usu†rio " + c-seg-usuario + "-" + (IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "") + " fez uma requisiá∆o de material para: " + "~n" +
                        "Estabelecimento: " + tt-movto.cod-estabel    + "~n" +
                        "Dep¢sito: "        + tt-movto.cod-depos      + "~n" +
                        "Item: "            + tt-movto.it-codigo + "-" + (IF AVAIL ITEM THEN ITEM.desc-item ELSE "") + "~n" +
                        "Quantidade: "      + TRIM(STRING(tt-movto.quantidade,">>>,>>>,>>9.99999")) + "~n" +
                        "Localizaá∆o: "     + tt-movto.cod-localiz    + "~n" +
                        "Documento: "       + tt-movto.nro-docto      + "~n" +
                        "Data: "            + STRING(tt-movto.dt-trans,"99/99/9999") + "~n" +
                        "Hora: "            + STRING(TIME,"HH:MM:SS")       + "~n" +
                        "Conta: "           + tt-movto.ct-codigo      + "~n" +
                        "Centro Custo: "    + tt-movto.sc-codigo      + "~n".

    IF tt-movto.cod-estabel = "101" AND tt-movto.ct-codigo BEGINS "4" THEN DO:
       FIND FIRST int-centro-custo NO-LOCK
            WHERE int-centro-custo.cod-estabel    = tt-movto.cod-estabel
              AND int-centro-custo.cc-codigo      = tt-movto.sc-codigo 
              AND int-centro-custo.cod-unid-negoc = tt-movto.cod-unid-negoc NO-ERROR.
       IF AVAIL int-centro-custo THEN DO:
           RUN pi-acompanhar in h-acomp (input "Enviando e-mail...").

           IF NOT AVAIL usuar_mestre OR usuar_mestre.cod_e_mail_local = "" THEN DO:
                RUN enviaMail (INPUT "ems@intelbras.com.br",
                               INPUT "grupo.contabil@intelbras.com.br;grupo.custos@intelbras.com.br",
                               INPUT "ESCEP011-Requisiá∆o Materiais",
                               INPUT "O usu†rio " + c-seg-usuario + "-" + (IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "") + " est† tentando fazer requisiá∆o de material e n∆o foi encontrado cadastro do e-mail para o usu†rio. Favor verificar!", 
                               INPUT "").
                ASSIGN c-mensagem = "N∆o Ç poss°vel fazer requisiá∆o, n∆o foi encontrado cadastro do usu†rio para matr°cula: " + STRING(int-centro-custo.cod_usuario) + " sendo que est† cadastrado como supervisor do Centro de custo " + tt-movto.sc-codigo + ". Favor entrar em contato com Setor Controladoria!".
                RUN pi-cria-erro (INPUT c-mensagem).
                RETURN "NOK".
           END.
           ELSE DO:
               RUN enviaMail (INPUT "ems@intelbras.com.br",
                              INPUT usuar_mestre.cod_e_mail_local,
                              INPUT "ESCEP011-Requisiá∆o Materiais",
                              INPUT c-assunto,
                              INPUT "").
           END.
       END.
       ELSE DO:
           RUN enviaMail (INPUT "ems@intelbras.com.br",
                          INPUT "grupo.contabil@intelbras.com.br;grupo.custos@intelbras.com.br",
                          INPUT "ESCEP011-Requisiá∆o Materiais",
                          INPUT "O usu†rio " + c-seg-usuario + "-" + (IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "") + " est† tentando fazer requisiá∆o de material e n∆o existe supervisor cadastrado para Centro de custo " + tt-movto.sc-codigo + ". Favor verificar!",
                          INPUT "").
           ASSIGN c-mensagem = "N∆o Ç possevel fazer requisiá∆o, n∆o existe supervisor cadastrado para Centro de custo " + tt-movto.sc-codigo + ". Favor entrar em contato com a †rea cont†bil atravÇs do e-mail grupo.contabil@intelbras.com.br".
           RUN pi-cria-erro (INPUT c-mensagem).
           RETURN "NOK":U.
       END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSelectPrinter wWindow 
PROCEDURE piSelectPrinter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cTempFile AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cAuxFile  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cPrev     AS CHARACTER   NO-UNDO.

    ASSIGN INPUT FRAME fPage3 fiPrinter.

    ASSIGN cPrev     = fiPrinter
           cTempFile = REPLACE(fiPrinter, ":":U, ",":U).

    IF fiPrinter <> "":U THEN DO:
        IF NUM-ENTRIES(cTempFile) = 4 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile) + ":":U + ENTRY(4, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 3 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 2 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = "":U.
    END.

    RUN utp/ut-impr.w (INPUT-OUTPUT cPrinter,
                       INPUT-OUTPUT cLayout,
                       INPUT-OUTPUT cAuxFile).

    IF cAuxFile = "":U THEN
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout.
    ELSE
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout + ":":U + cAuxFile.

    IF fiPrinter = ":":U THEN
        ASSIGN fiPrinter = cPrev.

    DISPLAY fiPrinter
        WITH FRAME fPage3.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

