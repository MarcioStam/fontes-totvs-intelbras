&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i esccp018 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esccp018
&GLOBAL-DEFINE Version        001

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              
&GLOBAL-DEFINE page1Widgets   cod-estabel-ini cod-estabel-fim cod-comprado-ini cod-comprado-fim ~
                              it-codigo-ini it-codigo-fim dt-ini dt-fim numero-ordem-ini ~
                              numero-ordem-fim planejador-ini planejador-fim bt-atualiza ~
                              br-ordens bt-marca bt-desmarca bt-marca-todos bt-desmarca-todos ~
                              bt-elimina
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def temp-table tt-ordem         no-undo
    field lg-marca              as log      format "*/ "
    field cod-comprado          like ordem-compra.cod-comprado
    field numero-ordem          like ordem-compra.numero-ordem
    field data-emissao          like ordem-compra.data-emissao
    field data-entrega          like prazo-compra.data-entrega
    field it-codigo             like ordem-compra.it-codigo
    field desc-item             like item.desc-item
    field ordem-servic          like ordem-compra.ordem-servic.

{cdp/cd0666.i}

DEF TEMP-TABLE tt-ord-prod      NO-UNDO LIKE ord-prod USE-INDEX codigo 
    FIELD dt-disponibilidade    AS DATE
    FIELD ind-tipo-movto        AS INTEGER
    FIELD faixa-numeracao       AS INTEGER INIT 1
    FIELD verifica-compras      AS LOGICAL 
    FIELD aloca-reserva         AS LOGICAL INIT ?
    FIELD aloca-lote            AS LOGICAL INIT ?
    FIELD rw-ord-prod           AS ROWID
    FIELD gera-relacionamentos  AS LOGICAL INIT YES
    FIELD gera-reservas         AS LOGICAL INIT YES
    FIELD prog-seg              AS CHAR
    FIELD seg-usuario           AS CHAR
    FIELD ep-codigo-usuario     AS CHAR
    FIELD cod-versao-integracao AS INTEGER FORMAT "999"
    FIELD considera-dias-desl   AS LOGICAL INIT NO.

DEF TEMP-TABLE tt-reapro    NO-UNDO
    FIELD it-codigo         LIKE ord-prod.it-codigo
    FIELD cod-refer         LIKE ord-prod.cod-refer
    FIELD descricao         AS CHAR FORMAT "x(36)"
    FIELD un                LIKE reservas.un
    FIELD quant-orig        LIKE reservas.quant-orig.
    
    
DEF VAR h-acomp AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-ordens

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ordem

/* Definitions for BROWSE br-ordens                                     */
&Scoped-define FIELDS-IN-QUERY-br-ordens tt-ordem.lg-marca tt-ordem.cod-comprado tt-ordem.numero-ordem tt-ordem.data-emissao tt-ordem.data-entrega tt-ordem.it-codigo tt-ordem.desc-item tt-ordem.ordem-servic   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-ordens   
&Scoped-define SELF-NAME br-ordens
&Scoped-define QUERY-STRING-br-ordens FOR EACH tt-ordem
&Scoped-define OPEN-QUERY-br-ordens OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem.
&Scoped-define TABLES-IN-QUERY-br-ordens tt-ordem
&Scoped-define FIRST-TABLE-IN-QUERY-br-ordens tt-ordem


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-ordens}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btQueryJoins btReportsJoins ~
btExit btHelp 

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

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-atualiza 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "Button 2" 
     SIZE 4 BY 1.13.

DEFINE BUTTON bt-desmarca 
     LABEL "Desmarca" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-desmarca-todos 
     LABEL "Desmarca Todos" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-elimina 
     LABEL "Elimina" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-marca 
     LABEL "Marca" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-marca-todos 
     LABEL "Marca Todos" 
     SIZE 12 BY 1.

DEFINE VARIABLE cod-comprado-fim AS CHARACTER FORMAT "x(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE cod-comprado-ini AS CHARACTER FORMAT "x(12)" 
     LABEL "Comprador" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE cod-estabel-fim AS CHARACTER FORMAT "X(3)" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE cod-estabel-ini AS CHARACTER FORMAT "X(3)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE dt-fim AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE dt-ini AS DATE FORMAT "99/99/9999" 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE it-codigo-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE it-codigo-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE numero-ordem-fim AS INTEGER FORMAT "zzzzz9,99" INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE numero-ordem-ini AS INTEGER FORMAT "zzzzz9,99" INITIAL 0 
     LABEL "Ordem":R7 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE planejador-fim AS CHARACTER FORMAT "x(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE planejador-ini AS CHARACTER FORMAT "x(12)" 
     LABEL "Planejador" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-39
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-40
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-41
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-42
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-43
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-44
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-45
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-46
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-ordens FOR 
      tt-ordem SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-ordens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-ordens wWindow _FREEFORM
  QUERY br-ordens DISPLAY
      tt-ordem.lg-marca           column-label ""
    tt-ordem.cod-comprado       column-label "Comprador"
    tt-ordem.numero-ordem       column-label "Ordem"
    tt-ordem.data-emissao       column-label "EmissÆo"
    tt-ordem.data-entrega       column-label "Entrega"
    tt-ordem.it-codigo          column-label "Item"         format "x(07)"
    tt-ordem.desc-item          column-label "Descri‡Æo"    format "x(25)"
    tt-ordem.ordem-servic       column-label "Ord Serv"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 81 BY 10
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
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
         SIZE 90 BY 21.5
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     cod-estabel-ini AT ROW 1.5 COL 21 RIGHT-ALIGNED WIDGET-ID 8
     cod-estabel-fim AT ROW 1.5 COL 52 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     cod-comprado-ini AT ROW 2.5 COL 30 RIGHT-ALIGNED WIDGET-ID 6
     cod-comprado-fim AT ROW 2.5 COL 52 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     it-codigo-ini AT ROW 3.5 COL 34 RIGHT-ALIGNED WIDGET-ID 20
     it-codigo-fim AT ROW 3.5 COL 52 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     dt-ini AT ROW 4.5 COL 27 RIGHT-ALIGNED WIDGET-ID 28
     dt-fim AT ROW 4.5 COL 52 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     numero-ordem-ini AT ROW 5.5 COL 34 RIGHT-ALIGNED WIDGET-ID 36
     numero-ordem-fim AT ROW 5.5 COL 52 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     bt-atualiza AT ROW 6.42 COL 74 WIDGET-ID 50
     planejador-ini AT ROW 6.5 COL 30 RIGHT-ALIGNED WIDGET-ID 44
     planejador-fim AT ROW 6.5 COL 52 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     br-ordens AT ROW 7.75 COL 3 WIDGET-ID 200
     bt-marca AT ROW 17.75 COL 3 WIDGET-ID 52
     bt-desmarca AT ROW 17.75 COL 15 WIDGET-ID 54
     bt-marca-todos AT ROW 17.75 COL 27 WIDGET-ID 56
     bt-desmarca-todos AT ROW 17.75 COL 39 WIDGET-ID 58
     bt-elimina AT ROW 17.75 COL 72 WIDGET-ID 60
     IMAGE-1 AT ROW 1.5 COL 35.29 WIDGET-ID 10
     IMAGE-2 AT ROW 1.5 COL 50.72 WIDGET-ID 12
     IMAGE-3 AT ROW 2.5 COL 35.29 WIDGET-ID 14
     IMAGE-4 AT ROW 2.5 COL 50.72 WIDGET-ID 16
     IMAGE-39 AT ROW 3.5 COL 35.29 WIDGET-ID 22
     IMAGE-40 AT ROW 3.5 COL 50.72 WIDGET-ID 24
     IMAGE-41 AT ROW 4.5 COL 35.29 WIDGET-ID 30
     IMAGE-42 AT ROW 4.5 COL 50.72 WIDGET-ID 32
     IMAGE-43 AT ROW 5.5 COL 35.29 WIDGET-ID 38
     IMAGE-44 AT ROW 5.5 COL 50.72 WIDGET-ID 40
     IMAGE-45 AT ROW 6.5 COL 35.29 WIDGET-ID 46
     IMAGE-46 AT ROW 6.5 COL 50.72 WIDGET-ID 48
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 18.25
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
         HEIGHT             = 21.5
         WIDTH              = 90
         MAX-HEIGHT         = 23.5
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 23.5
         VIRTUAL-WIDTH      = 90
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
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB br-ordens planejador-fim fPage1 */
/* SETTINGS FOR FILL-IN cod-comprado-ini IN FRAME fPage1
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN cod-estabel-ini IN FRAME fPage1
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN dt-ini IN FRAME fPage1
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN it-codigo-ini IN FRAME fPage1
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN numero-ordem-ini IN FRAME fPage1
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN planejador-ini IN FRAME fPage1
   ALIGN-R                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-ordens
/* Query rebuild information for BROWSE br-ordens
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-ordens */
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


&Scoped-define BROWSE-NAME br-ordens
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-ordens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ordens wWindow
ON MOUSE-SELECT-DBLCLICK OF br-ordens IN FRAME fPage1
DO:
  if tt-ordem.lg-marca
  then apply 'choose' to bt-desmarca in frame fPage1.
  else apply 'choose' to bt-marca in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-atualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-atualiza wWindow
ON CHOOSE OF bt-atualiza IN FRAME fPage1 /* Button 2 */
DO:
  run piOpenQuery.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desmarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desmarca wWindow
ON CHOOSE OF bt-desmarca IN FRAME fPage1 /* Desmarca */
DO:
   assign tt-ordem.lg-marca = no.
  disp tt-ordem.lg-marca
       with browse br-ordens.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desmarca-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desmarca-todos wWindow
ON CHOOSE OF bt-desmarca-todos IN FRAME fPage1 /* Desmarca Todos */
DO:
  for each tt-ordem:
      assign tt-ordem.lg-marca = no.
  end.
  
  br-ordens:refresh().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-elimina
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-elimina wWindow
ON CHOOSE OF bt-elimina IN FRAME fPage1 /* Elimina */
DO:
    
    disable triggers for load of reservas.
    disable triggers for load of ext-ord.
    disable triggers for load of oper-ord.
    disable triggers for load of pert-ordem.
    disable triggers for load of split-operac.
    disable triggers for load of op-sfc.
    disable triggers for load of ord-prod.
    
    RUN utp/ut-acomp.p persistent set h-acomp.  
    RUN pi-inicializar in h-acomp (input "Eliminando Ordens...").   
    
    for each tt-ordem
       where tt-ordem.lg-marca = yes:
       
        for first ordem-compra
            where ordem-compra.numero-ordem = tt-ordem.numero-ordem:
           
            RUN pi-acompanhar IN h-acomp (INPUT "Ordem: " + string(ordem-compra.numero-ordem)).
           
            for each prazo-compra of ordem-compra:
                delete prazo-compra.
            end.
           
            find ord-prod NO-LOCK where ord-prod.nr-ord-prod = ordem-compra.ordem-servic no-error.
            if avail ord-prod and ord-prod.estado = 1 then do:

                FOR EACH tt-ord-prod:
                    DELETE tt-ord-prod.
                END.
        
                CREATE tt-ord-prod.
                ASSIGN tt-ord-prod.cod-versao-integracao = 003
                       tt-ord-prod.ind-tipo-movto        = 3
                       tt-ord-prod.nr-ord-produ          = ord-prod.nr-ord-produ
                       tt-ord-prod.verifica-compras      = NO.
                
                DO TRANSACTION ON ERROR UNDO ON STOP UNDO:
                    RUN cpp/cpapi301.p (INPUT-OUTPUT TABLE tt-ord-prod,
                                        INPUT-OUTPUT TABLE tt-reapro,
                                        INPUT-OUTPUT TABLE tt-erro,
                                        YES).
                
                    IF CAN-FIND (FIRST tt-erro)  THEN DO:
                        FOR EACH tt-erro:
                            RUN utp/ut-msgs.p (INPUT "show",
                                               INPUT 17006,
                                               INPUT tt-erro.mensagem).
                        END.
                    END.                                                                                                                       
                END.

                /*for each reservas exclusive-lock 
                   where reservas.nr-ord-prod = ord-prod.nr-ord-prod:
                    delete reservas.
                end.
                for each ext-ord of ord-prod exclusive-lock:
                    delete ext-ord.
                end.
                for each oper-ord exclusive-lock where oper-ord.nr-ord-prod = ord-prod.nr-ord-prod:
                    delete oper-ord.
                end.
                for each pert-ordem of ord-prod exclusive-lock:
                    delete pert-ordem.
                end.
                for each split-operac of ord-prod exclusive-lock:
                    delete split-operac.
                end.
                for each op-sfc exclusive-lock where op-sfc.nr-ord-prod = ord-prod.nr-ord-prod:
                    delete op-sfc.
                end.
                FOR EACH req-sum WHERE req-sum.nr-req-sum = ord-prod.nr-ord-produ EXCLUSIVE-LOCK:
                    DELETE req-sum.
                END.
                FOR EACH cab-req-sum WHERE cab-req-sum.nr-req-sum = ord-prod.nr-ord-produ EXCLUSIVE-LOCK:
                    DELETE cab-req-sum.
                END.
                
                delete ord-prod.*/
                
            end.

            for each cotacao-item
               where cotacao-item.numero-ordem = ordem-compra.numero-ordem:
                delete cotacao-item.
            end.
             
            delete ordem-compra.
            delete tt-ordem.
        end.
    end.
    
 
    RUN pi-finalizar in h-acomp.
    
    br-ordens:refresh().        
       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca wWindow
ON CHOOSE OF bt-marca IN FRAME fPage1 /* Marca */
DO:
  assign tt-ordem.lg-marca = yes.
  disp tt-ordem.lg-marca
       with browse br-ordens.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca-todos wWindow
ON CHOOSE OF bt-marca-todos IN FRAME fPage1 /* Marca Todos */
DO:
  for each tt-ordem:
      assign tt-ordem.lg-marca = yes.
  end.
  
  br-ordens:refresh().
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


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piOpenQuery wWindow 
PROCEDURE piOpenQuery :
RUN utp/ut-acomp.p persistent set h-acomp.  
    RUN pi-inicializar in h-acomp (input "Consultando Ordens...").

    for each tt-ordem:
        delete tt-ordem.
    end.
    
    for each ordem-compra no-lock
        where (ordem-compra.situacao     = 5
          or ordem-compra.situacao       = 1
          or ordem-compra.situacao       = 3)
          and ordem-compra.cod-comprado >= frame fPage1 cod-comprado-ini
          and ordem-compra.cod-comprado <= frame fPage1 cod-comprado-fim
          and ordem-compra.cod-estabel  >= frame fPage1 cod-estabel-ini
          and ordem-compra.cod-estabel  <= frame fPage1 cod-estabel-fim
          and ordem-compra.numero-ordem >= frame fPage1 numero-ordem-ini
          and ordem-compra.numero-ordem <= frame fPage1 numero-ordem-fim
          and ordem-compra.it-codigo    >= frame fPage1 it-codigo-ini
          and ordem-compra.it-codigo    <= frame fPage1 it-codigo-fim
          and ordem-compra.it-codigo    <> "",
         each prazo-compra no-lock
        where prazo-compra.numero-ordem  = ordem-compra.numero-ordem
          and prazo-compra.data-entrega >= frame fPage1 dt-ini
          and prazo-compra.data-entrega <= frame fPage1 dt-fim,
        first item no-lock 
        where item.it-codigo     = ordem-compra.it-codigo
          and item.cd-planejado >= frame fPage1 planejador-ini
          and item.cd-planejado <= frame fPage1 planejador-fim
            break by ordem-compra.cod-comprado
                  by ordem-compra.numero-ordem:
                  
        RUN pi-acompanhar IN h-acomp (INPUT "Ordem: " + string(ordem-compra.numero-ordem)).          
                  
        create tt-ordem.
        assign tt-ordem.cod-comprado = ordem-compra.cod-comprado
               tt-ordem.numero-ordem = ordem-compra.numero-ordem
               tt-ordem.data-emissao = ordem-compra.data-emissao
               tt-ordem.data-entrega = prazo-compra.data-entrega
               tt-ordem.it-codigo    = ordem-compra.it-codigo
               tt-ordem.desc-item    = item.desc-item
               tt-ordem.ordem-servic = ordem-compra.ordem-servic.
    end.
    
    RUN pi-finalizar in h-acomp.
    
    {&OPEN-QUERY-br-ordens}               
    
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

