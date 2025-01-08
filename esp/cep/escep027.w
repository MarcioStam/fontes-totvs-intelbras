&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgmov           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCEP027 2.04.000.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCEP027
&GLOBAL-DEFINE Version        2.04.000.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   ITENS,DESTINO

&GLOBAL-DEFINE page0Widgets   btExit btHelp btAtualiza
&GLOBAL-DEFINE page1Widgets   br-aca br-ae
&GLOBAL-DEFINE page2Widgets   fiPrinter btConfigImpr

/* Parameters Definitions ---                                           */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cPrinter    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAuxFile    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout     AS CHARACTER   NO-UNDO.

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEF VAR c-it-codigo AS CHAR NO-UNDO.
DEF VAR i-quantidade AS DECIMAL NO-UNDO.
DEF VAR l-sem-localiz AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE p-msg-erro AS CHARACTER   NO-UNDO.

def var raw-param        as raw no-undo.

{esp/es0478.i "new"}
{esp/es0478-rpc.i}
{upc/btb910za-upc.i}
{esp/cep/escep027tt.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-aca

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES saldo-estoq item ae-item

/* Definitions for BROWSE br-aca                                        */
&Scoped-define FIELDS-IN-QUERY-br-aca saldo-estoq.it-codigo item.desc-item saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada @ saldo-estoq.qtidade-atu   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-aca   
&Scoped-define SELF-NAME br-aca
&Scoped-define OPEN-QUERY-br-aca IF v_cod_estab_usuar = "104" OR v_cod_estab_usuar = "106" THEN     OPEN QUERY {&SELF-NAME} FOR EACH saldo-estoq           WHERE saldo-estoq.cod-estabel = v_cod_estab_usuar             AND saldo-estoq.cod-depos = "ACA"             AND (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada) > 0 NO-LOCK, ~
                 FIRST item OF saldo-estoq NO-LOCK INDEXED-REPOSITION.  ELSE     OPEN QUERY {&SELF-NAME} FOR EACH saldo-estoq           WHERE saldo-estoq.cod-estabel = v_cod_estab_usuar             AND saldo-estoq.cod-depos = "ACA"             AND (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada) > 0 NO-LOCK, ~
                 FIRST item OF saldo-estoq           WHERE item.it-codigo BEGINS "4"              OR item.it-codigo BEGINS "5"  NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-aca saldo-estoq item
&Scoped-define FIRST-TABLE-IN-QUERY-br-aca saldo-estoq
&Scoped-define SECOND-TABLE-IN-QUERY-br-aca item


/* Definitions for BROWSE br-ae                                         */
&Scoped-define FIELDS-IN-QUERY-br-ae ae-item.nr-ae ae-item.sequencia ~
ae-item.localizacao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-ae 
&Scoped-define QUERY-STRING-br-ae FOR EACH ae-item ~
      WHERE ae-item.cod-estabel = v_cod_estab_usuar ~
 and ae-item.it-codigo = c-it-codigo ~
 AND ae-item.situacao = FALSE ~
 AND ae-item.data = today NO-LOCK ~
    BY ae-item.nr-ae ~
       BY ae-item.sequencia ~
        BY ae-item.localizacao INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-ae OPEN QUERY br-ae FOR EACH ae-item ~
      WHERE ae-item.cod-estabel = v_cod_estab_usuar ~
 and ae-item.it-codigo = c-it-codigo ~
 AND ae-item.situacao = FALSE ~
 AND ae-item.data = today NO-LOCK ~
    BY ae-item.nr-ae ~
       BY ae-item.sequencia ~
        BY ae-item.localizacao INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-ae ae-item
&Scoped-define FIRST-TABLE-IN-QUERY-br-ae ae-item


/* Definitions for FRAME fPage1                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btAtualiza btExit btHelp 

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
DEFINE BUTTON btAtualiza DEFAULT 
     LABEL "Atualiza Fam°lia" 
     SIZE 15 BY 1.25 TOOLTIP "Atualiza Fam°lia".

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
     SIZE 51 BY 1.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-aca FOR 
      saldo-estoq, 
      item SCROLLING.

DEFINE QUERY br-ae FOR 
      ae-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-aca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-aca wWindow _FREEFORM
  QUERY br-aca NO-LOCK DISPLAY
      saldo-estoq.it-codigo FORMAT "x(16)":U
      item.desc-item FORMAT "x(36)":U
      saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada @ saldo-estoq.qtidade-atu COLUMN-LABEL "Saldo" FORMAT "->>>,>>>,>>9.9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 58 BY 10
         FONT 1
         TITLE "Saldo do Dep¢sito ACA".

DEFINE BROWSE br-ae
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-ae wWindow _STRUCTURED
  QUERY br-ae NO-LOCK DISPLAY
      ae-item.nr-ae FORMAT "9999999":U
      ae-item.sequencia COLUMN-LABEL "Seq" FORMAT "999":U
      ae-item.localizacao FORMAT "x(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 58 BY 10
         FONT 1
         TITLE "".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btAtualiza AT ROW 1.13 COL 1.72
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda" NO-TAB-STOP 
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.33
         FONT 1.

DEFINE FRAME fPage2
     btConfigImpr AT ROW 3.21 COL 56.57 HELP
          "Configuraá∆o da impressora" WIDGET-ID 22
     fiPrinter AT ROW 3.29 COL 12 NO-LABEL WIDGET-ID 24 NO-TAB-STOP 
     RECT-4 AT ROW 3 COL 11
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.6 ROW 3.71
         SIZE 84.4 BY 12.75
         FONT 1.

DEFINE FRAME fPage1
     br-ae AT ROW 2 COL 14 HELP
          "Selecione o item e pressione RETURN para transferir"
     br-aca AT ROW 2 COL 14 HELP
          "Selecione o item e pressione RETURN para transferir"
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.6 ROW 3.7 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window Template
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
         HEIGHT             = 17.33
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
   Size-to-Fit                                                          */
/* BROWSE-TAB br-ae 1 fPage1 */
/* BROWSE-TAB br-aca br-ae fPage1 */
ASSIGN 
       FRAME fPage1:SCROLLABLE       = FALSE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
ASSIGN 
       fiPrinter:READ-ONLY IN FRAME fPage2        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-aca
/* Query rebuild information for BROWSE br-aca
     _START_FREEFORM
IF v_cod_estab_usuar = "104" or 
   v_cod_estab_usuar = "106" THEN
    OPEN QUERY {&SELF-NAME} FOR EACH saldo-estoq
          WHERE saldo-estoq.cod-estabel = v_cod_estab_usuar
            AND saldo-estoq.cod-depos = "ACA"
            AND (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada) > 0 NO-LOCK,
          FIRST item OF saldo-estoq NO-LOCK INDEXED-REPOSITION.

ELSE
    OPEN QUERY {&SELF-NAME} FOR EACH saldo-estoq
          WHERE saldo-estoq.cod-estabel = v_cod_estab_usuar
            AND saldo-estoq.cod-depos = "ACA"
            AND (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada) > 0 NO-LOCK,
          FIRST item OF saldo-estoq
          WHERE item.it-codigo BEGINS "4"
             OR item.it-codigo BEGINS "5"  NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED"
     _Where[1]         = "mgmov.saldo-estoq.cod-estabel = v_cod_estab_usuar
 and mgmov.saldo-estoq.cod-depos = ""ACA""
 AND (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada) > 0"
     _Where[2]         = "mgcad.item.it-codigo BEGINS ""4""
 OR mgcad.item.it-codigo BEGINS ""5"" "
     _Query            is NOT OPENED
*/  /* BROWSE br-aca */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-ae
/* Query rebuild information for BROWSE br-ae
     _TblList          = "mgesp.ae-item"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED"
     _OrdList          = "mgesp.ae-item.nr-ae|yes,mgesp.ae-item.sequencia|yes,mgesp.ae-item.localizacao|yes"
     _Where[1]         = "mgesp.ae-item.cod-estabel = v_cod_estab_usuar
 and mgesp.ae-item.it-codigo = c-it-codigo
 AND mgesp.ae-item.situacao = FALSE
 AND mgesp.ae-item.data = today"
     _FldNameList[1]   = mgesp.ae-item.nr-ae
     _FldNameList[2]   > mgesp.ae-item.sequencia
"ae-item.sequencia" "Seq" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = mgesp.ae-item.localizacao
     _Query            is NOT OPENED
*/  /* BROWSE br-ae */
&ANALYZE-RESUME

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


&Scoped-define BROWSE-NAME br-aca
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-aca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-aca wWindow
ON RETURN OF br-aca IN FRAME fPage1 /* Saldo do Dep¢sito ACA */
DO:
  IF SELF:NUM-ITERATIONS > 0 AND SELF:NUM-SELECTED-ROWS > 0 THEN DO:
      SELF:FETCH-SELECTED-ROW(1).
      IF v_cod_estab_usuar = "101" THEN DO:
          MESSAGE "Funá∆o retirada do sistema. Transferància n∆o foi efetivada."
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      END.
      ELSE DO:
          FIND FIRST contenedor no-lock 
              WHERE contenedor.it-codigo = saldo-estoq.it-codigo NO-ERROR.
          IF NOT AVAIL contenedor THEN DO:
              RUN ShowMessage (1, "Contenedor n∆o cadastrado", "").
              RETURN NO-APPLY.
          END.
          i-quantidade = saldo-estoq.qtidade-atu - mgmov.saldo-estoq.qt-alocada.
    
          IF i-quantidade = 0 THEN DO:
              RUN ShowMessage (1, "Item sem saldo", "").
              {&OPEN-QUERY-br-aca}
              RETURN NO-APPLY.    
          END.
    
          RUN pedeQuantidade (INPUT-OUTPUT i-quantidade, OUTPUT l-sem-localiz) NO-ERROR.
          IF RETURN-VALUE = "OK" THEN DO:
              ASSIGN c-it-codigo = saldo-estoq.it-codigo.
              RUN Transfere NO-ERROR.
    
              IF NOT l-sem-localiz THEN DO:
                  DO WITH FRAME fpage1:
                      BROWSE br-ae:TITLE = SUBSTITUTE("Avisos de Entrada para &1", saldo-estoq.it-codigo).
                      SELF:HIDDEN = YES.
                      BROWSE br-ae:VISIBLE = YES.
                      {&OPEN-QUERY-br-ae}
                      APPLY "entry" TO br-ae IN FRAME fpage1.
                      IF NOT l-sem-localiz THEN PAUSE MESSAGE "Pressione alguma tecla para continuar".
                      SELF:HIDDEN = NO.
                      BROWSE br-ae:VISIBLE = NO.
                      APPLY "entry" TO br-aca IN FRAME fpage1.
                  END.
              END.
              ELSE DO:
                  br-aca:REFRESH() IN FRAME fPage1.
                  MESSAGE "Item transferido, n∆o foi gerado AE"
                      VIEW-AS ALERT-BOX INFO BUTTONS OK.
              END.
          END.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btAtualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualiza wWindow
ON CHOOSE OF btAtualiza IN FRAME fpage0 /* Atualiza Fam°lia */
DO:
  RUN piExecute.

  /*RUN esp/es0973.p.
  {&OPEN-QUERY-br-aca}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wWindow
ON CHOOSE OF btConfigImpr IN FRAME fPage2 /* Configuraá∆o da impressora */
DO:
    RUN piSelectPrinter IN THIS-PROCEDURE.
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

{window/MainBlock.i}

{&OPEN-QUERY-br-aca}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
    
    BROWSE br-ae:HIDDEN = YES.
    APPLY "entry" TO br-aca IN FRAME fpage1.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pedeQuantidade wWindow 
PROCEDURE pedeQuantidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT-OUTPUT PARAM p-quantidade AS DECIMAL   NO-UNDO.
    DEF OUTPUT       PARAM p-sem-localiz  AS LOGICAL   NO-UNDO.
    
    /* Definitions of the field level widgets                               */
    DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
         LABEL "Cancela" 
         SIZE 10 BY 1
         BGCOLOR 8 .
    
    DEFINE BUTTON Btn_OK AUTO-GO 
         LABEL "Confirma" 
         SIZE 10 BY 1
         BGCOLOR 8 .
    
    DEFINE VARIABLE fi-quantidade AS DECIMAL FORMAT ">,>>>,>>9.9999":U INITIAL 0.00 
         LABEL "Quantidade" 
         VIEW-AS FILL-IN 
         SIZE 15 BY .88 NO-UNDO.
    
    DEFINE VARIABLE tg-sem-localiz AS LOGICAL FORMAT "Sim/N∆o":U INITIAL "no"
         LABEL "Transfere sem localizaá∆o, n∆o gera AE" 
         VIEW-AS TOGGLE-BOX
         SIZE 35 BY .88 NO-UNDO.

    DEFINE RECTANGLE RECT-5
         EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
         SIZE 64 BY 1.25.
    
    DEFINE RECTANGLE RECT-6
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 64 BY 1.5
         BGCOLOR 7 .

    /* ************************  Frame Definitions  *********************** */
    
    DEFINE FRAME f-qtde
         fi-quantidade AT ROW 1.17 COL 12 COLON-ALIGNED
         tg-sem-localiz  AT ROW 1.17 COL 28 COLON-ALIGNED
         Btn_OK AT ROW 2.5 COL 2
         Btn_Cancel AT ROW 2.5 COL 12
         RECT-5 AT ROW 1 COL 1
         RECT-6 AT ROW 2.25 COL 1
         SPACE(0.13) SKIP(0.00)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1
             TITLE "Quantidade para transferir"
             DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.

    ASSIGN 
           FRAME f-qtde:SCROLLABLE       = FALSE
           FRAME f-qtde:ROW              = 1
           FRAME f-qtde:COLUMN           = 1.

    ON 'choose':U OF Btn_Cancel IN FRAME f-qtde
    DO:
        RETURN "NOK".
    END.

    ON 'value-changed':U OF tg-sem-localiz IN FRAME f-qtde DO:
        IF INPUT tg-sem-localiz THEN DO:
            MESSAGE "Transferencia sem localizaá∆o, n∆o ser† gerada AE"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
    END.

    ON 'choose':U OF Btn_OK IN FRAME f-qtde
    DO:
        ASSIGN p-quantidade = INPUT fi-quantidade
               p-sem-localiz  = INPUT tg-sem-localiz.

        RETURN "OK".
    END.

    DISPLAY p-quantidade @ fi-quantidade 
            tg-sem-localiz
        WITH FRAME f-qtde.
    ENABLE RECT-5 RECT-6 fi-quantidade Btn_OK Btn_Cancel 
           tg-sem-localiz
        WITH FRAME f-qtde.
    WAIT-FOR GO OF FRAME f-qtde.
    HIDE FRAME f-qtde.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wWindow 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    define var r-tt-digita as rowid no-undo.
    def var i-num-ped-exec-rpw as integer no-undo.
    
    do on error undo, return error on stop  undo, return error:
        /*:T Coloque aqui as validaá‰es da p†gina de Digitaá∆o, lembrando que elas devem
           apresentar uma mensagem de erro cadastrada, posicionar nesta p†gina e colocar
           o focus no campo com problemas */
        /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/
        
        /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
           apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
           problemas e colocar o focus no campo com problemas */
        
        
        
        /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
           para o programa RP.P */
        
        create tt-param.
        assign tt-param.usuario         = c-seg-usuario
               tt-param.data-exec       = today
               tt-param.hora-exec       = time
               tt-param.cod-estabel     = v_cod_estab_usuar
               tt-param.arquivo         = "escep027-" + STRING(TODAY,"999999") + "-" + STRING(TIME) + ".lst"
               tt-param.destino         = 2.
        
        SESSION:SET-WAIT-STATE("GENERAL":U).
        
        raw-transfer tt-param    to raw-param.

        run btb/btb911zb.p (input c-programa-mg97,
                            input "esp/cep/escep027rp.p":U,
                            input c-versao-mg97,
                            input 97,
                            input tt-param.arquivo,
                            input tt-param.destino,
                            input raw-param,
                            input table tt-raw-digita,
                            output i-num-ped-exec-rpw).
        if i-num-ped-exec-rpw <> 0 then                     
          run utp/ut-msgs.p (input "show":U, 
                             input 4169, 
                             input string(i-num-ped-exec-rpw)).                      
      
        SESSION:SET-WAIT-STATE("":U).
        
    end.

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

    ASSIGN INPUT FRAME fPage2 fiPrinter.

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
        WITH FRAME fPage2.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Transfere wWindow 
PROCEDURE Transfere :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR c-dispositivo AS CHAR NO-UNDO.
    
    DO WITH FRAME fpage1:
        STATUS DEFAULT "Processando a transferància. Por favor aguarde".
        SESSION:SET-WAIT-STATE("GENERAL":U).

        ASSIGN c-dispositivo = INPUT FRAME fPage2 fiPrinter.
        
        run esp/es0478-n.p (
              input saldo-estoq.it-codigo,                           /* item */
              input "ACA",                                           /* deposito de saida */                
              input saldo-estoq.cod-localiz,                         /* local de saida */
              input i-quantidade,                                    /* quantidade total */
              input "EXP",                                           /* deposito de entrada */
              input 0,                                               /* numero docto */
              input "TRA",                                           /* serie */
              input string(today) + " - " + string(time,"HH:MM:SS"), /* historico */
              input 0,                                               /* numero do AE */
              input 0,                                               /* sequencia do AE */
              input 0,                                               /* roteiro */  
              input 0,                                               /* nota */
              input no,                                              /* baixa parcial */
              input no,                                              /* devolucao ou transferencia */
              input contenedor.lote-multipl,                         /* contenedor */
              input 0,                                               /* fornecedor */
              input 1,                                               /* sequencia inicial */
              input /*no*/ l-sem-localiz,                            /* usa local informado */
              input "",                                              /* local destino */
              input today,                                           /* data movto-estoq */
              input ?,                                               /* Validade da AE */
              input "escep027," + c-dispositivo,                     /* Campo Caracter livre */
              input v_cod_estab_usuar,                               /* C¢digo do estabelecimento */
              output table tt-etiqueta,
              OUTPUT p-msg-erro).   
              
        SESSION:SET-WAIT-STATE("":U).
        STATUS DEFAULT.

        IF c-it-codigo <> "" THEN DO:
            find item where item.it-codigo = c-it-codigo no-lock no-error.
            IF AVAIL ITEM THEN DO:
                FIND FIRST int-familia NO-LOCK
                     WHERE int-familia.fm-codigo = ITEM.fm-codigo NO-ERROR.
                IF AVAIL int-familia THEN DO:
                    IF int-familia.oem OR DAY(TODAY) > 26 THEN DO:
                        RUN enviaMail (INPUT "ems@intelbras.com.br",
                                       INPUT "grupo.faturamento@intelbras.com.br",
                                       INPUT "Disponivel Faturamento - Item: " + c-it-codigo + " - " + ITEM.desc-item,
                                       INPUT "Foi disponibilizado para faturamento o Item: " + c-it-codigo + " - " + ITEM.desc-item + " - Quantidade: " + TRIM(STRING(i-quantidade,">,>>>,>>9.9999")) + ".",
                                       INPUT "").
                    END.
                END.
            END.
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
    def var i-saldo-ae    like ae-item.quantidade format ">>>,>>>,>>9" NO-UNDO.
    if c-it-codigo <> "" then do:
        find item where item.it-codigo = c-it-codigo no-lock no-error.
        if avail item then do:
            output to value(session:TEMP-DIRECTORY + "escep027.log") APPEND CONVERT TARGET SESSION:CHARSET.
            disp "==> " item.it-codigo format "x(7)"
                 item.descricao-1 + item.descricao-2 format "x(36)" skip
                 "    "  "Ocorreu um erro na transferencia" skip
                 with width 300 no-labels frame f-imp-erro.
            disp "    Saldo Alm:" saldo-estoq.qtidade-atu skip
                 "   Qt Alocada:" saldo-estoq.qt-alocada
                 saldo-estoq.cod-localiz skip with frame f-imp-erro.

            assign i-saldo-ae = 0.
            for each ae-item no-lock
               where ae-item.cod-estabel = v_cod_estab_usuar 
               and ae-item.it-codigo = c-it-codigo:
                assign i-saldo-ae = i-saldo-ae + quantidade.
            end.
            disp "     Saldo AE: " i-saldo-ae skip
                 "      Usuario: " userid("mgadm")  skip
                 "    Data/Hora: " today " - " string(time,"HH:MM:SS")
                 
                 with frame f-imp-erro.       

            output close.
        end.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

