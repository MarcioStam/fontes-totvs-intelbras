&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
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
{include/i-prgvrs.i ESCCP017 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCCP017
&GLOBAL-DEFINE Version        1

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Processos, Lotes/µreas

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              bt-selecao bt-impressao
&GLOBAL-DEFINE page1Widgets   br-processo bt-inclui-proc bt-exclui-proc bt-consulta-proc bt-impressao-proc
&GLOBAL-DEFINE page2Widgets   br-lotes bt-inclui-lote bt-exclui-lote bt-avaliacao-lote ~
                              bt-consulta-lote br-areas bt-incluir-area bt-excluir-area ~
                              bt-parecer bt-consulta-area
  

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def temp-table tt-param2            no-undo
    field nr-processo-ini           like homologacao.nr-processo
    field nr-processo-fim           like homologacao.nr-processo
    field dt-inicio-ini             as date
    field dt-inicio-fim             as date
    field dt-termino-ini            as date
    field dt-termino-fim            as date
    field it-codigo-ini             like item.it-codigo
    field it-codigo-fim             like item.it-codigo
    field fm-codigo-ini             like item.fm-codigo
    field fm-codigo-fim             like item.fm-codigo
    field cod-emitente-ini          like emitente.cod-emitente
    field cod-emitente-fim          like emitente.cod-emitente.
/**/    
def temp-table tt-situacao      no-undo
    like situacao
    field lg-usa        as log.    

def var lg-ok           as log                  no-undo.

def var wh-query        as widget-handle        no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-areas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES teste centro-custo lote-hml tipo-lote ~
tt-param2 homologacao item fabricante tt-situacao

/* Definitions for BROWSE br-areas                                      */
&Scoped-define FIELDS-IN-QUERY-br-areas centro-custo.descricao teste.data-parecer   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-areas   
&Scoped-define SELF-NAME br-areas
&Scoped-define QUERY-STRING-br-areas FOR EACH teste of lote-hml, ~
                                   each centro-custo                            where centro-custo.cc-codigo = teste.cc-codigo no-lock
&Scoped-define OPEN-QUERY-br-areas OPEN QUERY {&SELF-NAME} FOR EACH teste of lote-hml, ~
                                   each centro-custo                            where centro-custo.cc-codigo = teste.cc-codigo no-lock.
&Scoped-define TABLES-IN-QUERY-br-areas teste centro-custo
&Scoped-define FIRST-TABLE-IN-QUERY-br-areas teste
&Scoped-define SECOND-TABLE-IN-QUERY-br-areas centro-custo


/* Definitions for BROWSE br-lotes                                      */
&Scoped-define FIELDS-IN-QUERY-br-lotes lote-hml.nr-lote tipo-lote.descricao lote-hml.quantidade lote-hml.situacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-lotes   
&Scoped-define SELF-NAME br-lotes
&Scoped-define QUERY-STRING-br-lotes FOR EACH lote-hml of homologacao no-lock, ~
                                   each tipo-lote of lote-hml                             no-lock
&Scoped-define OPEN-QUERY-br-lotes OPEN QUERY {&SELF-NAME} FOR EACH lote-hml of homologacao no-lock, ~
                                   each tipo-lote of lote-hml                             no-lock.
&Scoped-define TABLES-IN-QUERY-br-lotes lote-hml tipo-lote
&Scoped-define FIRST-TABLE-IN-QUERY-br-lotes lote-hml
&Scoped-define SECOND-TABLE-IN-QUERY-br-lotes tipo-lote


/* Definitions for BROWSE br-processo                                   */
&Scoped-define FIELDS-IN-QUERY-br-processo homologacao.nr-processo homologacao.data-inicio homologacao.it-codigo item.descricao-1 + item.descricao-2 item.un fabricante.nome tt-situacao.descricao homologacao.data-ult-sit   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-processo   
&Scoped-define SELF-NAME br-processo
&Scoped-define QUERY-STRING-br-processo FOR each tt-param2, ~
                                   EACH homologacao no-lock                            where homologacao.nr-processo    >= tt-param2.nr-processo-ini                              and homologacao.nr-processo    <= tt-param2.nr-processo-fim                              and homologacao.data-inicio    >= tt-param2.dt-inicio-ini                              and homologacao.data-inicio    <= tt-param2.dt-inicio-fim                              and ((homologacao.data-termino >= tt-param2.dt-termino-ini                              and   homologacao.data-termino <= tt-param2.dt-termino-fim)                               or   homologacao.data-termino = ?), ~
                                   each item no-lock                            where item.it-codigo  = homologacao.it-codigo                              and item.it-codigo >= tt-param2.it-codigo-ini                              and item.it-codigo <= tt-param2.it-codigo-fim                              and item.fm-codigo >= tt-param2.fm-codigo-ini                              and item.fm-codigo <= tt-param2.fm-codigo-fim, ~
                                   each fabricante no-lock                            where fabricante.cod-fabric  = homologacao.cod-fabric                              and fabricante.cod-fabric >= tt-param2.cod-emitente-ini                              and fabricante.cod-fabric <= tt-param2.cod-emitente-fim, ~
                                   each tt-situacao                            where tt-situacao.cod-situacao = homologacao.situacao                              and tt-situacao.lg-usa                         NO-LOCK  by item.it-codigo INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-processo OPEN QUERY {&SELF-NAME} FOR each tt-param2, ~
                                   EACH homologacao no-lock                            where homologacao.nr-processo    >= tt-param2.nr-processo-ini                              and homologacao.nr-processo    <= tt-param2.nr-processo-fim                              and homologacao.data-inicio    >= tt-param2.dt-inicio-ini                              and homologacao.data-inicio    <= tt-param2.dt-inicio-fim                              and ((homologacao.data-termino >= tt-param2.dt-termino-ini                              and   homologacao.data-termino <= tt-param2.dt-termino-fim)                               or   homologacao.data-termino = ?), ~
                                   each item no-lock                            where item.it-codigo  = homologacao.it-codigo                              and item.it-codigo >= tt-param2.it-codigo-ini                              and item.it-codigo <= tt-param2.it-codigo-fim                              and item.fm-codigo >= tt-param2.fm-codigo-ini                              and item.fm-codigo <= tt-param2.fm-codigo-fim, ~
                                   each fabricante no-lock                            where fabricante.cod-fabric  = homologacao.cod-fabric                              and fabricante.cod-fabric >= tt-param2.cod-emitente-ini                              and fabricante.cod-fabric <= tt-param2.cod-emitente-fim, ~
                                   each tt-situacao                            where tt-situacao.cod-situacao = homologacao.situacao                              and tt-situacao.lg-usa                         NO-LOCK  by item.it-codigo INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-processo tt-param2 homologacao item ~
fabricante tt-situacao
&Scoped-define FIRST-TABLE-IN-QUERY-br-processo tt-param2
&Scoped-define SECOND-TABLE-IN-QUERY-br-processo homologacao
&Scoped-define THIRD-TABLE-IN-QUERY-br-processo item
&Scoped-define FOURTH-TABLE-IN-QUERY-br-processo fabricante
&Scoped-define FIFTH-TABLE-IN-QUERY-br-processo tt-situacao


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-processo}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-br-areas}~
    ~{&OPEN-QUERY-br-lotes}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btQueryJoins btReportsJoins ~
btExit btHelp bt-selecao bt-impressao 

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
DEFINE BUTTON bt-impressao 
     IMAGE-UP FILE "image/gr-rel.bmp":U
     LABEL "Button 3" 
     SIZE 4 BY 1.13 TOOLTIP "Relat¢rio".

DEFINE BUTTON bt-selecao 
     IMAGE-UP FILE "image/gr-sel.bmp":U
     LABEL "Button 1" 
     SIZE 4 BY 1.13 TOOLTIP "Seleá∆o".

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

DEFINE BUTTON bt-consulta-proc 
     LABEL "Consultar" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-exclui-proc 
     LABEL "Excluir" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-impressao-proc 
     LABEL "Imprimir" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-inclui-proc 
     LABEL "Incluir" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-avaliacao-lote 
     LABEL "Avaliar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-consulta-area 
     LABEL "Consultar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-consulta-lote 
     LABEL "Consultar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-exclui-lote 
     LABEL "Excluir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-excluir-area 
     LABEL "Excluir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-inclui-lote 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-incluir-area 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-parecer 
     LABEL "Parecer" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-areas FOR 
      teste, 
      centro-custo SCROLLING.

DEFINE QUERY br-lotes FOR 
      lote-hml, 
      tipo-lote SCROLLING.

DEFINE QUERY br-processo FOR 
      tt-param2, 
      homologacao, 
      item, 
      fabricante, 
      tt-situacao SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-areas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-areas wWindow _FREEFORM
  QUERY br-areas DISPLAY
      centro-custo.descricao      column-label "µrea"
teste.data-parecer          column-label "Data"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 40 BY 10
         FONT 1
         TITLE "µreas" FIT-LAST-COLUMN.

DEFINE BROWSE br-lotes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-lotes wWindow _FREEFORM
  QUERY br-lotes DISPLAY
      lote-hml.nr-lote        label "Nr"
tipo-lote.descricao     label "Tipo de Lote"
lote-hml.quantidade     label "QTD"
lote-hml.situacao       label "Sit"     format "Abe/Fec"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 41 BY 10
         FONT 1
         TITLE "Lotes" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.

DEFINE BROWSE br-processo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-processo wWindow _FREEFORM
  QUERY br-processo NO-LOCK DISPLAY
      homologacao.nr-processo                 label "Proc"        format ">>>9"
homologacao.data-inicio                 label "Data"
homologacao.it-codigo                   label "Item"        format "x(9)" 
item.descricao-1 + item.descricao-2     label "Descricao"   format "x(36)"
item.un                                 label "UN"
fabricante.nome                         label "Fabricante"
tt-situacao.descricao                   label "Situacao"
homologacao.data-ult-sit                label "Data Situacao"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 84 BY 10.75
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
     bt-selecao AT ROW 1.25 COL 12 WIDGET-ID 2
     bt-impressao AT ROW 1.25 COL 16 WIDGET-ID 4
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 15.04
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     br-lotes AT ROW 1.25 COL 2 WIDGET-ID 400
     br-areas AT ROW 1.25 COL 44 WIDGET-ID 500
     bt-inclui-lote AT ROW 11.25 COL 2 WIDGET-ID 2
     bt-exclui-lote AT ROW 11.25 COL 12 WIDGET-ID 4
     bt-avaliacao-lote AT ROW 11.25 COL 22 WIDGET-ID 6
     bt-consulta-lote AT ROW 11.25 COL 32 WIDGET-ID 16
     bt-incluir-area AT ROW 11.25 COL 44 WIDGET-ID 8
     bt-excluir-area AT ROW 11.25 COL 54 WIDGET-ID 10
     bt-parecer AT ROW 11.25 COL 64 WIDGET-ID 12
     bt-consulta-area AT ROW 11.25 COL 74 WIDGET-ID 14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1 WIDGET-ID 300.

DEFINE FRAME fPage1
     br-processo AT ROW 1 COL 1 WIDGET-ID 200
     bt-inclui-proc AT ROW 11.75 COL 1 WIDGET-ID 2
     bt-exclui-proc AT ROW 11.75 COL 13 WIDGET-ID 4
     bt-consulta-proc AT ROW 11.75 COL 25 WIDGET-ID 6
     bt-impressao-proc AT ROW 11.75 COL 37 WIDGET-ID 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
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
         HEIGHT             = 15.17
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB br-processo 1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB br-lotes 1 fPage2 */
/* BROWSE-TAB br-areas br-lotes fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-areas
/* Query rebuild information for BROWSE br-areas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH teste of lote-hml,
                            each centro-custo
                           where centro-custo.cc-codigo = teste.cc-codigo no-lock.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-areas */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-lotes
/* Query rebuild information for BROWSE br-lotes
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH lote-hml of homologacao no-lock,
                            each tipo-lote of lote-hml
                            no-lock.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-lotes */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-processo
/* Query rebuild information for BROWSE br-processo
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR each tt-param2,
                            EACH homologacao no-lock
                           where homologacao.nr-processo    >= tt-param2.nr-processo-ini
                             and homologacao.nr-processo    <= tt-param2.nr-processo-fim
                             and homologacao.data-inicio    >= tt-param2.dt-inicio-ini
                             and homologacao.data-inicio    <= tt-param2.dt-inicio-fim
                             and ((homologacao.data-termino >= tt-param2.dt-termino-ini
                             and   homologacao.data-termino <= tt-param2.dt-termino-fim)
                              or   homologacao.data-termino = ?),
                            each item no-lock
                           where item.it-codigo  = homologacao.it-codigo
                             and item.it-codigo >= tt-param2.it-codigo-ini
                             and item.it-codigo <= tt-param2.it-codigo-fim
                             and item.fm-codigo >= tt-param2.fm-codigo-ini
                             and item.fm-codigo <= tt-param2.fm-codigo-fim,
                            each fabricante no-lock
                           where fabricante.cod-fabric  = homologacao.cod-fabric
                             and fabricante.cod-fabric >= tt-param2.cod-emitente-ini
                             and fabricante.cod-fabric <= tt-param2.cod-emitente-fim,
                            each tt-situacao
                           where tt-situacao.cod-situacao = homologacao.situacao
                             and tt-situacao.lg-usa
                        NO-LOCK  by item.it-codigo INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-processo */
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


&Scoped-define BROWSE-NAME br-lotes
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME br-lotes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-lotes wWindow
ON VALUE-CHANGED OF br-lotes IN FRAME fPage2 /* Lotes */
DO:
  {&OPEN-QUERY-br-areas}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-processo
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-processo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-processo wWindow
ON VALUE-CHANGED OF br-processo IN FRAME fPage1
DO:
  {&OPEN-QUERY-br-lotes}
  {&OPEN-QUERY-br-areas}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-avaliacao-lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-avaliacao-lote wWindow
ON CHOOSE OF bt-avaliacao-lote IN FRAME fPage2 /* Avaliar */
DO:
    if avail lote-hml
    then do:
        find first teste of lote-hml no-lock no-error.
        if not avail teste
        then do:
            run utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17567,
                               INPUT "Lote n∆o possui pareceres.").
            return no-apply.
        end.
        find first teste of lote-hml
             where teste.data-parecer = ? no-lock no-error.
        if avail teste
        then do:
            run utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17567,
                               INPUT "Lote possui †reas sem parecer informado").
            return no-apply.
        end.
        run esp/ccp/esccp017e.w (input rowid(homologacao),
                                 input rowid(lote-hml),
                                 input yes).
                                 
        {&OPEN-QUERY-br-lotes}                                        
        {&OPEN-QUERY-br-processo}                                        
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-consulta-area
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-consulta-area wWindow
ON CHOOSE OF bt-consulta-area IN FRAME fPage2 /* Consultar */
DO:
  run esp/ccp/esccp017g.w (input rowid(teste),
                           input no).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-consulta-lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-consulta-lote wWindow
ON CHOOSE OF bt-consulta-lote IN FRAME fPage2 /* Consultar */
DO:
  run esp/ccp/esccp017e.w (input rowid(homologacao),
                           input rowid(lote-hml),
                           input no).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-consulta-proc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-consulta-proc wWindow
ON CHOOSE OF bt-consulta-proc IN FRAME fPage1 /* Consultar */
DO:
  run esp/ccp/esccp017c.w (input rowid(homologacao)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-exclui-lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exclui-lote wWindow
ON CHOOSE OF bt-exclui-lote IN FRAME fPage2 /* Excluir */
DO:
    if avail lote-hml
    then do:
        if lote-hml.situacao = no 
        then do:
            run utp/ut-msgs.p (INPUT "SHOW":U, 
                               INPUT 17567, 
                               INPUT "Lote Fechado. N∆o pode ser alterado").
            return no-apply.
        end.
        find first teste of lote-hml no-lock no-error.
        if avail teste 
        then do:
            run utp/ut-msgs.p (INPUT "SHOW":U, 
                               INPUT 17567, 
                               INPUT "Lote possui parecer(es). N∆o pode ser exclu°do").
            return no-apply.
        end.
        else do:
            find current lote-hml exclusive-lock.
            delete lote-hml.
            
            
            {&OPEN-QUERY-br-lotes}
            {&OPEN-QUERY-br-areas}
            {&OPEN-QUERY-br-processo}
            

        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-exclui-proc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exclui-proc wWindow
ON CHOOSE OF bt-exclui-proc IN FRAME fPage1 /* Excluir */
DO:
    if avail homologacao
    then do:
        find first lote-hml of homologacao no-lock no-error.
        if avail lote-hml 
        then do:
            run utp/ut-msgs.p (INPUT "SHOW":U, 
                               INPUT 17567, 
                               INPUT "Processo possui Lotes. N∆o pode ser exclu°do").
            return no-apply.
        end.
        
        find current homologacao exclusive-lock.
        delete homologacao.
        
        {&OPEN-QUERY-br-processo}
                
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-excluir-area
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excluir-area wWindow
ON CHOOSE OF bt-excluir-area IN FRAME fPage2 /* Excluir */
DO:
    if avail teste
    then do:
        if lote-hml.situacao = no 
        then do:
            message "Lote Fechado. Tem certeza que quer excluir ?"
                    view-as alert-box question buttons yes-no
                    update lg-exclui as logical.
            if not lg-exclui 
            then return no-apply.
        end.
        find current teste exclusive-lock.
        delete teste.
        find current lote-hml exclusive-lock.
        assign lote-hml.situacao = yes.
        find current lote-hml no-lock.

        {&OPEN-QUERY-br-lotes}
        {&OPEN-QUERY-br-areas}                                        
         
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-impressao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-impressao wWindow
ON CHOOSE OF bt-impressao IN FRAME fpage0 /* Button 3 */
DO:
    run esp/ccp/esccp017h.w (input table tt-param2,
                             input table tt-situacao,
                             input ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-impressao-proc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-impressao-proc wWindow
ON CHOOSE OF bt-impressao-proc IN FRAME fPage1 /* Imprimir */
DO:
   run esp/ccp/esccp017h.w (input table tt-param2,
                            input table tt-situacao,
                            input rowid(homologacao)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-inclui-lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inclui-lote wWindow
ON CHOOSE OF bt-inclui-lote IN FRAME fPage2 /* Incluir */
DO:
  if avail homologacao
  then do:
      run esp/ccp/esccp017d.w (input rowid(homologacao)).
      
      {&OPEN-QUERY-br-lotes}
      {&OPEN-QUERY-br-areas}     

  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-inclui-proc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inclui-proc wWindow
ON CHOOSE OF bt-inclui-proc IN FRAME fPage1 /* Incluir */
DO:
  run esp/ccp/esccp017b.w.
  
  run piOpenQuery.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-incluir-area
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir-area wWindow
ON CHOOSE OF bt-incluir-area IN FRAME fPage2 /* Incluir */
DO:
    if not avail lote-hml
    then do:
        run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17567, 
                           INPUT "N∆o existe Lote.").
        return no-apply.
    end.
    
    if not lote-hml.situacao 
    then do:
        run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17567, 
                           INPUT "Lote Fechado n∆o Pode ser Alterado.").
        return no-apply.
    end.
    
    run esp/ccp/esccp017f.w (input rowid(homologacao),
                             input rowid(lote-hml)).
    
    {&OPEN-QUERY-br-areas}                                        


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-parecer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-parecer wWindow
ON CHOOSE OF bt-parecer IN FRAME fPage2 /* Parecer */
DO:
    if not avail lote-hml
    then do:
        run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17567, 
                           INPUT "N∆o existe Lote.").
        return no-apply.
    end.
    
    if not avail teste
    then do:
        run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17567, 
                           INPUT "N∆o existe µrea").
        return no-apply.
    end.
    
    if lote-hml.situacao = no /* fechado */ 
    then do:
        run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17567, 
                           INPUT "N∆o Ç poss°vel atualizar lotes fechados.").
        return no-apply.
    end.
        
    find usuar_univ where usuar_univ.cod_usuario = c-seg-usuario no-lock no-error.
    if not avail usuar_univ
    then do:
        run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17567, 
                           INPUT "Usu†rio n∆o cadastrado. Informe o respons†vel.").
        return no-apply.
    end.
    
    find first ponto-programa
         where ponto-programa.nome-programa = "esccp017"
           and ponto-programa.ponto         = 1
           and ponto-programa.tipo          = 4     /*conta*/ 
           no-lock no-error.
    find first conteudo-programa
         where conteudo-programa.cod-programa = ponto-programa.cod-programa
           and conteudo-programa.sequencia    = 2
           no-lock no-error.

    IF LOOKUP(usuar_univ.cod_ccusto,conteudo-programa.conteudo) = 0 AND
       usuar_univ.cod_ccusto <> teste.cc-codigo AND
       c-seg-usuario <> "adm" then do:
        run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17567, 
                           INPUT "Usu†rio n∆o pertence Ö †rea selecionada. N∆o pode atualizar Parecer.").
        return no-apply.
    end.
    
    if teste.data-parecer <> ? 
    then do:
        message "Parecer j† informado para esta †rea. Continua ?"
                 view-as alert-box question buttons yes-no
                 update lg-parecer as logical.
        if not lg-parecer 
        then return no-apply.
    end.

    
    run esp/ccp/esccp017g.w (input rowid(teste),
                             input yes).
    {&OPEN-QUERY-br-lotes}
    {&OPEN-QUERY-br-areas}
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-selecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-selecao wWindow
ON CHOOSE OF bt-selecao IN FRAME fpage0 /* Button 1 */
DO:
  run esp/ccp/esccp017a.w (input-output table tt-param2,
                           INPUT-OUTPUT TABLE tt-situacao,
                                 output lg-ok).
  if lg-ok
  THEN DO:
      IF  SESSION:SET-WAIT-STATE("general") THEN.
      run piOpenQuery.
      IF  SESSION:SET-WAIT-STATE("") THEN.
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


&Scoped-define BROWSE-NAME br-areas
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

    create tt-param2.

    assign tt-param2.nr-processo-ini      = 0
           tt-param2.nr-processo-fim      = 999999
           tt-param2.dt-inicio-ini        = 01/01/0001
           tt-param2.dt-inicio-fim        = 12/31/9999
           tt-param2.dt-termino-ini       = 01/01/0001
           tt-param2.dt-termino-fim       = 12/31/9999
           tt-param2.it-codigo-ini        = ""
           tt-param2.it-codigo-fim        = "ZZZZZZZZZZZZZZZZ"
           tt-param2.fm-codigo-ini        = ""
           tt-param2.fm-codigo-fim        = "ZZZZZZZZ"
           tt-param2.cod-emitente-ini     = 0
           tt-param2.cod-emitente-fim     = 999999999.     
           
    for each situacao no-lock:
        
        create tt-situacao.
        buffer-copy situacao to tt-situacao.
        ASSIGN tt-situacao.lg-usa = YES.
    end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piOpenQuery wWindow 
PROCEDURE piOpenQuery :
{&OPEN-QUERY-br-processo}
    {&OPEN-QUERY-br-lotes}
    {&OPEN-QUERY-br-areas}
      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

