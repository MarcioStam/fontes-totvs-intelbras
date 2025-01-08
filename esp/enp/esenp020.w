&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESENP020 2.00.00.000}
/*------------------------------------------------------------------------
    File        : ESENP020.W
    Purpose     : Listagem de Operaá‰es da Estrutura do Item
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Outubro de 2012
    Notes       : <none>
----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessors Definitions ---                                        */

&GLOBAL-DEFINE Program        ESENP020
&GLOBAL-DEFINE Version        2.00.00.000
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o,ParÉmetro,Digitaá∆o,Impress∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   tgArqCSV ~
                              btPesqArqCSV
&GLOBAL-DEFINE page5Widgets   brDigita ~
                              btAdd ~
                              btUpdate ~
                              btDelete ~
                              btSave ~
                              btOpen
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution ~
                              tgParam
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      text-entrada
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino ~
                              text-modo ~
                              text-param
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    fiCodEstabel ~
                              fiCodEstabelfin ~
                              fiItCodigoIni ~
                              fiItCodigoFin ~
                              fiDtCorte
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    fiArqCSV tg-imprime-desc tg-lista-obsoletos 
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Include Definitions ---                                              */

{esp/enp/esenp020.i}
{upc/btb910za-upc.i}

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE raw-param  AS RAW         NO-UNDO.
DEFINE VARIABLE l-ok       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-terminal AS CHARACTER   NO-UNDO.

&IF "{&PGLAY}":U = "YES":U &THEN
DEFINE VARIABLE c-arq-layout AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-temp   AS CHARACTER   NO-UNDO.
DEFINE STREAM s-imp.
&ENDIF

&IF "{&PGDIG}":U = "YES":U &THEN
DEFINE VARIABLE c-arq-digita AS CHARACTER   NO-UNDO.
&ENDIF

&IF "{&RTF}":U = "YES":U &THEN
DEFINE VARIABLE c-rtf            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-modelo-default AS CHARACTER   NO-UNDO.
&ENDIF

/* Buffer Definitions ---                                               */

&IF "{&PGDIG}":U = "YES":U &THEN
DEFINE BUFFER b-tt-digita FOR tt-digita.
&ENDIF

/* Shared Variable Definitions ---                                      */

&IF "{&RTF}":U = "YES":U &THEN
/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est† rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE      NO-UNDO.
&ENDIF

/* Stream Definitions ---                                               */

&IF "{&PGLAY}":U = "YES":U &THEN
DEFINE STREAM s-imp.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDigita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE brDigita                                      */
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.it-codigo tt-digita.desc-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita tt-digita.it-codigo   
&Scoped-define ENABLED-TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brDigita tt-digita
&Scoped-define SELF-NAME brDigita
&Scoped-define QUERY-STRING-brDigita FOR EACH tt-digita
&Scoped-define OPEN-QUERY-brDigita OPEN QUERY brDigita FOR EACH tt-digita.
&Scoped-define TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-brDigita tt-digita


/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-brDigita}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fiCodEstabel LIKE gm-estab.cod-estabel
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodEstabelfin LIKE gm-estab.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE fiDtCorte AS DATE FORMAT "99/99/9999":U 
     LABEL "Data de Corte" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fiItCodigoFin LIKE estrutura.it-codigo
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fiItCodigoIni LIKE estrutura.it-codigo
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON btPesqArqCSV 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE fiArqCSV AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE text-entrada AS CHARACTER FORMAT "X(256)":U INITIAL " Arquivo CSV" 
      VIEW-AS TEXT 
     SIZE 9.86 BY .63
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.

DEFINE VARIABLE tg-imprime-desc AS LOGICAL INITIAL no 
     LABEL "Imprime Descriá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-lista-obsoletos AS LOGICAL INITIAL yes 
     LABEL "Listar Itens Obsoletos" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY 1.08 NO-UNDO.

DEFINE VARIABLE tgArqCSV AS LOGICAL INITIAL no 
     LABEL "Gerar Arquivo CSV" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY 1.08
     FONT 1 NO-UNDO.

DEFINE BUTTON btAdd 
     LABEL "Inserir" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btDelete 
     LABEL "Retirar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btOpen 
     LABEL "Recuperar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btUpdate 
     LABEL "Alterar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 6.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL " Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-param AS CHARACTER FORMAT "X(256)":U INITIAL " ParÉmetros de Impress∆o" 
      VIEW-AS TEXT 
     SIZE 19 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.86 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.

DEFINE VARIABLE tgParam AS LOGICAL INITIAL yes 
     LABEL "Imprimir P†gina de ParÉmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .92 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDigita FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDigita wReport _FREEFORM
  QUERY brDigita DISPLAY
      tt-digita.it-codigo
      tt-digita.desc-item
      ENABLE
      tt-digita.it-codigo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 82 BY 8.75
         BGCOLOR 15 FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage4
     tgArqCSV AT ROW 1.25 COL 3 HELP
          "Gerar Arquivo CSV?"
     tg-lista-obsoletos AT ROW 1.25 COL 30.29 WIDGET-ID 4
     tg-imprime-desc AT ROW 2.25 COL 3 WIDGET-ID 2
     btPesqArqCSV AT ROW 9.71 COL 43.14 HELP
          "Escolha do nome do arquivo CSV"
     fiArqCSV AT ROW 9.79 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio CSV" NO-LABEL
     text-entrada AT ROW 8.75 COL 3.14 NO-LABEL
     RECT-12 AT ROW 9 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage5
     brDigita AT ROW 1.25 COL 1
     btAdd AT ROW 10 COL 1
     btUpdate AT ROW 10 COL 16
     btDelete AT ROW 10 COL 31
     btSave AT ROW 10 COL 46
     btOpen AT ROW 10 COL 61
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.54 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.54 COL 43 HELP
          "Configuraá∆o da impressora"
     rsExecution AT ROW 5.75 COL 2.86 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 3.14 NO-LABEL
     text-modo AT ROW 4.96 COL 3.14 NO-LABEL
     tgParam AT ROW 7.96 COL 3.14 HELP
          "Imprimir P†gina de ParÉmetros?"
     text-param AT ROW 7.08 COL 3.14 NO-LABEL
     RECT-7 AT ROW 1.92 COL 2
     RECT-9 AT ROW 5.25 COL 2
     RECT-10 AT ROW 7.38 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage2
     fiCodEstabel AT ROW 1.5 COL 26 COLON-ALIGNED HELP
          "C¢digo do Estabelecimento"
          LABEL "Estabelecimento"
     fiCodEstabelfin AT ROW 1.5 COL 48.29 COLON-ALIGNED HELP
          "C¢digo do Estabelecimento" NO-LABEL WIDGET-ID 6
     fiItCodigoIni AT ROW 2.5 COL 13.42 HELP
          "C¢digo do Item Inicial"
          LABEL "Item"
     fiItCodigoFin AT ROW 2.5 COL 50.29 HELP
          "C¢digo do Item Final" NO-LABEL
     fiDtCorte AT ROW 3.5 COL 21.43 COLON-ALIGNED HELP
          "Data de Corte"
     IMAGE-1 AT ROW 2.5 COL 35.29
     IMAGE-2 AT ROW 2.5 COL 47.29
     IMAGE-3 AT ROW 1.5 COL 35.29 WIDGET-ID 2
     IMAGE-4 AT ROW 1.5 COL 47.29 WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{report/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN fiCodEstabel IN FRAME fPage2
   LIKE = mgcad.gm-estab.cod-estabel EXP-LABEL EXP-HELP EXP-SIZE        */
/* SETTINGS FOR FILL-IN fiCodEstabelfin IN FRAME fPage2
   LIKE = mgcad.gm-estab.cod-estabel EXP-LABEL EXP-HELP EXP-SIZE        */
/* SETTINGS FOR FILL-IN fiItCodigoFin IN FRAME fPage2
   ALIGN-L LIKE = mgcad.estrutura.it-codigo EXP-LABEL EXP-HELP EXP-SIZE */
/* SETTINGS FOR FILL-IN fiItCodigoIni IN FRAME fPage2
   ALIGN-L LIKE = mgcad.estrutura.it-codigo EXP-LABEL EXP-HELP EXP-SIZE */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FILL-IN text-entrada IN FRAME fPage4
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-entrada:PRIVATE-DATA IN FRAME fPage4     = 
                "Arquivo CSV".

/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brDigita 1 fPage5 */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
/* SETTINGS FOR FILL-IN text-destino IN FRAME fPage6
   ALIGN-L                                                              */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME fPage6
   ALIGN-L                                                              */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execuá∆o".

/* SETTINGS FOR FILL-IN text-param IN FRAME fPage6
   ALIGN-L                                                              */
ASSIGN 
       text-param:PRIVATE-DATA IN FRAME fPage6     = 
                "ParÉmetros de Impress∆o".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDigita
/* Query rebuild information for BROWSE brDigita
     _START_FREEFORM
OPEN QUERY brDigita FOR EACH tt-digita.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDigita */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDigita
&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON DEL OF brDigita IN FRAME fPage5
DO:
    APPLY "CHOOSE":U TO btDelete IN FRAME fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON END-ERROR OF brDigita IN FRAME fPage5
ANYWHERE DO:
    IF brDigita:NEW-ROW IN FRAME fPage5 THEN DO:
        IF AVAILABLE tt-digita THEN
            DELETE tt-digita.

        IF brDigita:DELETE-CURRENT-ROW() IN FRAME fPage5 THEN.
    END.
    ELSE DO:
        GET CURRENT brDigita.

        DISPLAY tt-digita.it-codigo
                tt-digita.desc-item
            WITH BROWSE brDigita.
    END.

    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ENTER OF brDigita IN FRAME fPage5
ANYWHERE DO:
    APPLY "TAB":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON INS OF brDigita IN FRAME fPage5
DO:
    APPLY "CHOOSE":U TO btAdd IN FRAME fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-END OF brDigita IN FRAME fPage5
DO:
    APPLY "ENTRY":U TO btAdd IN FRAME fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-HOME OF brDigita IN FRAME fPage5
DO:
    APPLY "ENTRY":U TO btOpen IN FRAME fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-ENTRY OF brDigita IN FRAME fPage5
DO:
    /*:T trigger para inicializar campos da temp table de digitaá∆o */
    IF brDigita:NEW-ROW IN FRAME fPage5 THEN DO:
        IF AVAILABLE tt-digita THEN DO:
            FIND FIRST item
                WHERE item.it-codigo = INPUT BROWSE brDigita tt-digita.it-codigo NO-LOCK NO-ERROR.

            ASSIGN tt-digita.desc-item = IF AVAILABLE item THEN item.desc-item ELSE "":U.

            DISPLAY tt-digita.desc-item
                WITH BROWSE brDigita.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-LEAVE OF brDigita IN FRAME fPage5
DO:
    /*:T ê aqui que a gravaá∆o da linha da temp-table Ç efetivada.
       PorÇm as validaá‰es dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment†rio */

    IF brDigita:NEW-ROW IN FRAME fPage5 THEN DO TRANSACTION ON ERROR UNDO, RETURN NO-APPLY:
        CREATE tt-digita.
        ASSIGN INPUT BROWSE brDigita tt-digita.it-codigo
               INPUT BROWSE brDigita tt-digita.desc-item.

        brDigita:CREATE-RESULT-LIST-ENTRY() IN FRAME fPage5.

        FIND FIRST item
            WHERE item.it-codigo = INPUT BROWSE brDigita tt-digita.it-codigo NO-LOCK NO-ERROR.

        ASSIGN tt-digita.desc-item = IF AVAILABLE item THEN item.desc-item ELSE "":U.

        DISPLAY tt-digita.desc-item
            WITH BROWSE brDigita.

        ASSIGN INPUT BROWSE brDigita tt-digita.desc-item.
    END.
    ELSE DO TRANSACTION ON ERROR UNDO, RETURN NO-APPLY:
        IF AVAILABLE tt-digita THEN DO:
            FIND FIRST item
                WHERE item.it-codigo = INPUT BROWSE brDigita tt-digita.it-codigo NO-LOCK NO-ERROR.

            ASSIGN tt-digita.desc-item = IF AVAILABLE item THEN item.desc-item ELSE "":U.

            DISPLAY tt-digita.desc-item
                WITH BROWSE brDigita.

            ASSIGN INPUT BROWSE brDigita tt-digita.it-codigo
                   INPUT BROWSE brDigita tt-digita.desc-item.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wReport
ON CHOOSE OF btAdd IN FRAME fPage5 /* Inserir */
DO:
    ASSIGN btUpdate:SENSITIVE IN FRAME fPage5 = YES
           btDelete:SENSITIVE IN FRAME fPage5 = YES
           btSave:SENSITIVE   IN FRAME fPage5 = YES.

    IF NUM-RESULTS("brDigita":U) > 0 THEN
        brDigita:INSERT-ROW("AFTER":U) IN FRAME fPage5.
    ELSE DO TRANSACTION:
        CREATE tt-digita.

        OPEN QUERY brDigita FOR EACH tt-digita.

        APPLY "ENTRY":U TO tt-digita.it-codigo IN BROWSE brDigita. 
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wReport
ON CHOOSE OF btConfigImpr IN FRAME fPage6
DO:
   {report/rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wReport
ON CHOOSE OF btDelete IN FRAME fPage5 /* Retirar */
DO:
    IF brDigita:NUM-SELECTED-ROWS > 0 THEN DO ON ERROR UNDO, RETURN NO-APPLY:
        GET CURRENT brDigita.

        DELETE tt-digita.

        IF brDigita:DELETE-CURRENT-ROW() IN FRAME fPage5 THEN.
    END.

    IF NUM-RESULTS("brDigita":U) = 0 THEN
        ASSIGN btUpdate:SENSITIVE IN FRAME fPage5 = NO
               btDelete:SENSITIVE IN FRAME fPage5 = NO
               btSave:SENSITIVE   IN FRAME fPage5 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wReport
ON CHOOSE OF btFile IN FRAME fPage6
DO:
    {report/rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wReport
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
   do  on error undo, return no-apply:
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btOpen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOpen wReport
ON CHOOSE OF btOpen IN FRAME fPage5 /* Recuperar */
DO:
    {report/rprcd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btPesqArqCSV
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPesqArqCSV wReport
ON CHOOSE OF btPesqArqCSV IN FRAME fPage4
DO:
    DEFINE VARIABLE cConvFile AS CHARACTER   NO-UNDO.

    ASSIGN cConvFile = REPLACE(INPUT FRAME fPage4 fiArqCSV, "/":U, "~\":U).

    SYSTEM-DIALOG GET-FILE cConvFile
        FILTERS "Arquivo CSV (separado por ponto e v°rgula) (*.csv)":U "*.csv":U,
                "Todos os Arquivos (*.*)":U                            "*.*":U
       ASK-OVERWRITE
       SAVE-AS
       DEFAULT-EXTENSION "csv":U
       INITIAL-DIR "spool":U
       USE-FILENAME
       UPDATE l-ok.

    IF l-ok THEN DO:
        ASSIGN fiArqCSV = REPLACE(cConvFile, "~\":U, "/":U).

        DISPLAY fiArqCSV
            WITH FRAME fPage4.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wReport
ON CHOOSE OF btSave IN FRAME fPage5 /* Salvar */
DO:
    {report/rpsvd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wReport
ON CHOOSE OF btUpdate IN FRAME fPage5 /* Alterar */
DO:
    APPLY "ENTRY":U TO tt-digita.it-codigo IN BROWSE brDigita.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage6
DO:
do  with frame fPage6:
    case self:screen-value:
        when "1":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes
                   /*Alterado 15/02/2005 - tech1007 - Alterado para suportar adequadamente com a 
                     funcionalidade de RTF*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = NO
                   l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
                   l-habilitaRtf = NO
                   &endif
                   .
                   /*Fim alteracao 15/02/2005*/
        end.
        when "2":U then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   .
        end.
        when "3":U then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   .
            /*Alterado 15/02/2005 - tech1007 - Teste para funcionar corretamente no WebEnabler*/
            &IF "{&RTF}":U = "YES":U &THEN
            IF VALID-HANDLE(hWenController) THEN DO:
                ASSIGN l-habilitaRtf:sensitive  = NO
                       l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
                       l-habilitaRtf = NO.
            END.
            &endif
            /*Fim alteracao 15/02/2005*/
        END.
        /*Alterado 15/02/2005 - tech1007 - Condiá∆o removida pois RTF n∆o Ç mais um destino
        when "4":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes
                   text-ModelRtf:VISIBLE   = YES
                   rect-rtf:VISIBLE       = YES
                   blModelRtf:VISIBLE       = yes.
        end.
        Fim alteracao 15/02/2005*/
    end case.
end.
&IF "{&RTF}":U = "YES":U &THEN
RUN pi-habilitaRtf.  
&endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage6
DO:
   {report/rprse.i}

   APPLY "VALUE-CHANGED":U TO tgArqCSV IN FRAME fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME tgArqCSV
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgArqCSV wReport
ON VALUE-CHANGED OF tgArqCSV IN FRAME fPage4 /* Gerar Arquivo CSV */
DO:
    IF SELF:CHECKED THEN DO:
        ENABLE fiArqCSV
               btPesqArqCSV
            WITH FRAME fPage4.

        ASSIGN fiArqCSV:BGCOLOR IN FRAME fPage4 = 15.

        CASE INPUT FRAME fPage6 rsExecution:
            WHEN 1 THEN DO:
                FIND FIRST usuar_mestre
                    WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.

                IF AVAILABLE usuar_mestre THEN
                    ASSIGN fiArqCSV = IF LENGTH(usuar_mestre.nom_subdir_spool) <> 0
                                      THEN CAPS(REPLACE(usuar_mestre.nom_dir_spool, "~\":U, "~/":U) + "~/":U + REPLACE(usuar_mestre.nom_subdir_spool, "~\":U, "~/":U) + "~/":U + c-programa-mg97 + ".csv":U)
                                      ELSE CAPS(REPLACE(usuar_mestre.nom_dir_spool, "~\":U, "~/":U) + "~/":U + c-programa-mg97 + ".csv":U).
                ELSE
                    ASSIGN fiArqCSV = CAPS("spool/":U + c-programa-mg97 + ".csv":U).
            END.
            WHEN 2 THEN
                ASSIGN fiArqCSV = CAPS(c-programa-mg97 + ".csv":U).
        END CASE.

        DISPLAY fiArqCSV
            WITH FRAME fPage4.
    END.
    ELSE DO:
        ASSIGN fiArqCSV = "":U.

        DISPLAY fiArqCSV
            WITH FRAME fPage4.

        ASSIGN fiArqCSV:BGCOLOR IN FRAME fPage4 = ?.

        DISABLE fiArqCSV
                btPesqArqCSV
            WITH FRAME fPage4.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{report/mainblock.i}

ON "ENTER":U      OF fiArqCSV IN FRAME fPage4 OR
   "RETURN":U     OF fiArqCSV IN FRAME fPage4 OR
   "CTRL-ENTER":U OF fiArqCSV IN FRAME fPage4 OR
   "CTRL-J":U     OF fiArqCSV IN FRAME fPage4 OR
   "CTRL-Z":U     OF fiArqCSV IN FRAME fPage4 do:
    RETURN NO-APPLY.
END.

ON "~\":U OF fiArqCSV IN FRAME fPage4 DO:
    APPLY "/":U TO fiArqCSV IN FRAME fPage4.

    RETURN NO-APPLY.
END.

ON "LEAVE":U OF fiArqCSV IN FRAME fPage4 DO:
    ASSIGN fiArqCSV = TRIM(CAPS(REPLACE(INPUT FRAME fPage4 fiArqCSV, "~\":U, "/":U))).

    DISPLAY fiArqCSV
        WITH FRAME fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*Alterado 17/02/2005 - tech1007 - Foi criado essa procedure para que seja realizado a inicializaá∆o
      correta dos componentes do RTF quando executado em ambiente local e no WebEnabler.*/
    &IF "{&RTF}":U = "YES":U &THEN
    IF VALID-HANDLE(hWenController) THEN DO:
        ASSIGN l-habilitaRtf:SENSITIVE    IN FRAME fPage6 = NO
               l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "NO":U
               l-habilitaRtf                              = NO.
    END.

    RUN pi-habilitaRtf.
    &ENDIF
    /*Fim alteracao 17/02/2005*/

    ASSIGN fiCodEstabel    = v_cod_estab_usuar
           fiCodEstabelfin = v_cod_estab_usuar.

    RUN utp/ut-limit.p (INPUT "MIN":U,
                        INPUT fiItCodigoIni:HANDLE:FORMAT IN FRAME fPage2).

    ASSIGN fiItCodigoIni = RETURN-VALUE.

    RUN utp/ut-limit.p (INPUT "MAX":U,
                        INPUT fiItCodigoFin:HANDLE:FORMAT IN FRAME fPage2).

    ASSIGN fiItCodigoFin = RETURN-VALUE.

    ASSIGN fiDtCorte = TODAY.

    DISPLAY fiCodEstabel
            fiCodEstabelfin
            fiItCodigoIni
            fiItCodigoFin
            fiDtCorte
        WITH FRAME fPage2.

    ASSIGN tgArqCSV = YES.

    DISPLAY tgArqCSV
        WITH FRAME fPage4.

    APPLY "VALUE-CHANGED":U TO tgArqCSV IN FRAME fPage4.

    ASSIGN tgParam = YES.

    DISPLAY tgParam
        WITH FRAME fPage6.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE r-tt-digita AS ROWID       NO-UNDO.

    &IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
    /*:T** Relatorio ***/
    DO ON ERROR UNDO, RETURN ERROR
       ON STOP  UNDO, RETURN ERROR:
        {report/rpexa.i}

        /*15/02/2005 - tech1007 - Teste alterado pois RTF n∆o Ç mais opá∆o de Destino*/
        IF INPUT FRAME fPage6 rsDestiny   = 2 AND
           INPUT FRAME fPage6 rsExecution = 1 THEN DO:
            RUN utp/ut-vlarq.p (INPUT INPUT FRAME fPage6 cFile).

            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN setFolder IN hFolder (INPUT 4).

                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 73,
                                   INPUT "":U).

                APPLY "ENTRY":U TO cFile IN FRAME fPage6.

                RETURN ERROR.
            END.
        END.

        /*16/02/2005 - tech1007 - Teste alterado para validar o modelo informado quando for RTF*/
        &IF "{&RTF}":U = "YES":U &THEN
        IF (INPUT FRAME fPage6 cModelRTF         = "":U AND
            INPUT FRAME fPage6 l-habilitaRtf     = YES) OR
           (SEARCH(INPUT FRAME fPage6 cModelRTF) = ?    AND
            INPUT FRAME fPage6 rsExecution       = 1    AND
            INPUT FRAME fPage6 l-habilitaRtf     = YES) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 73,
                               INPUT "":U).

            /*30/12/2004 - tech1007 - Evento removido pois causa problemas no WebEnabler*/
            /*APPLY "CHOOSE":U TO blModelRtf IN FRAME fPage6.*/

            RETURN ERROR.
        END.
        &ENDIF


        /*:T Coloque aqui as validaá‰es da p†gina de Digitaá∆o, lembrando que elas devem
           apresentar uma mensagem de erro cadastrada, posicionar nesta p†gina e colocar
           o focus no campo com problemas */

        &IF "{&PGDIG}":U = "YES":U &THEN
        /*BROWSE brDigita:SET-REPOSITIONED-ROW(BROWSE brDigita:DOWN, "ALWAYS":U).*/

        FOR EACH tt-digita NO-LOCK:
            ASSIGN r-tt-digita = ROWID(tt-digita).

            /*:T Validaá∆o de duplicidade de registro na temp-table tt-digita */
            FIND FIRST b-tt-digita
                WHERE b-tt-digita.it-codigo = tt-digita.it-codigo
                  AND ROWID(b-tt-digita)   <> ROWID(tt-digita) NO-LOCK NO-ERROR.

            IF AVAILABLE b-tt-digita THEN DO:
                REPOSITION brDigita TO ROWID ROWID(b-tt-digita).
                RUN setFolder IN hFolder (INPUT 3).

                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 108,
                                   INPUT "":U).

                APPLY "ENTRY":U TO tt-digita.it-codigo IN BROWSE brDigita.

                RETURN ERROR.
            END.

            /*:T As demais validaá‰es devem ser feitas aqui */
            FIND FIRST item
                WHERE item.it-codigo = tt-digita.it-codigo NO-LOCK NO-ERROR.

            IF NOT AVAILABLE item THEN DO:
                RUN setFolder IN hFolder (INPUT 3).

                ASSIGN BROWSE brDigita:CURRENT-COLUMN = tt-digita.it-codigo:HANDLE IN BROWSE brDigita.

                REPOSITION brDigita TO ROWID r-tt-digita.

                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 2,
                                   INPUT "Item":U).

                APPLY "ENTRY":U TO tt-digita.it-codigo IN BROWSE brDigita.

                RETURN ERROR.
            END.
        END.
        &ENDIF


        /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem
           apresentar uma mensagem de erro cadastrada, posicionar na p†gina com
           problemas e colocar o focus no campo com problemas */

        IF INPUT FRAME fPage4 tgArqCSV        AND
           INPUT FRAME fPage6 rsExecution = 1 THEN DO:
            ASSIGN c-arq-aux = INPUT FRAME fPage4 fiArqCSV
                   c-arq-aux = REPLACE(c-arq-aux, "/":U, "~\":U).

            IF R-INDEX(c-arq-aux, "~\":U) > 0 THEN DO:
                ASSIGN FILE-INFO:FILE-NAME = SUBSTRING(c-arq-aux, 1, R-INDEX(c-arq-aux, "~\":U)).

                IF FILE-INFO:FULL-PATHNAME         = ?     OR
                   NOT FILE-INFO:FILE-TYPE MATCHES "*D*":U THEN DO:
                    RUN setFolder IN hFolder (INPUT 2).

                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                       INPUT 17006,
                                       INPUT "Diret¢rio informado no caminho do Arquivo CSV n∆o encontrado":U +
                                             "~~":U +
                                             "Diret¢rio informado no caminho do Arquivo CSV para destino relat¢rio em CSV n∆o existe em seu sistema de arquivos.":U).

                    APPLY "ENTRY":U TO fiArqCSV IN FRAME fPage4.

                    RETURN ERROR.
                END.
            END.
        END.


        /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
           para o programa RP.P */

        CREATE tt-param.
        ASSIGN tt-param.usuario         = c-seg-usuario
               tt-param.destino         = INPUT FRAME fPage6 rsDestiny
               tt-param.data-exec       = TODAY
               tt-param.hora-exec       = TIME
               &IF "{&PGCLA}":U = "YES":U &THEN
               tt-param.classifica      = INPUT FRAME fPage3 rsClassif
               tt-param.desc-classifica = ENTRY((tt-param.classifica - 1) * 2 + 1, rsClassif:RADIO-BUTTONS IN FRAME fPage3)
               &ENDIF
               &IF "{&RTF}":U = "YES":U &THEN
               tt-param.modelo          = INPUT FRAME fPage6 cModelRTF
               tt-param.l-habilitaRtf    = INPUT FRAME fPage6 l-habilitaRtf
               &ENDIF
               .

        IF tt-param.destino = 1 THEN
            ASSIGN tt-param.arquivo = "":U.
        ELSE IF tt-param.destino = 2 THEN
            ASSIGN tt-param.arquivo = INPUT FRAME fPage6 cFile.
        ELSE
            ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.


        /*:T Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
           como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */

        ASSIGN tt-param.cod-estabel     = INPUT FRAME fPage2 fiCodEstabel
               tt-param.cod-estabel-fin = INPUT FRAME fPage2 fiCodEstabelfin
               tt-param.it-codigo-ini   = INPUT FRAME fPage2 fiItCodigoIni
               tt-param.it-codigo-fin   = INPUT FRAME fPage2 fiItCodigoFin
               tt-param.dt-corte        = INPUT FRAME fPage2 fiDtCorte
               tt-param.gerar-csv       = INPUT FRAME fPage4 tgArqCSV
               tt-param.arq-csv         = INPUT FRAME fPage4 fiArqCSV
               tt-param.lista-obsoletos = INPUT FRAME fPage4 tg-lista-obsoletos
               tt-param.param-impr      = INPUT FRAME fPage6 tgParam
               tt-param.imprime-desc    = tg-imprime-desc:CHECKED IN FRAME fPage4.


        /*:T Executar do programa RP.P que ir† criar o relat¢rio */

        {report/rpexb.i}

        SESSION:SET-WAIT-STATE("GENERAL":U).

        {report/rprun.i esp/enp/esenp020rp.p}

        {report/rpexc.i}

        SESSION:SET-WAIT-STATE("":U).

        {report/rptrm.i}

        IF INPUT FRAME fPage6 rsExecution = 1 THEN
            OS-COMMAND NO-WAIT VALUE(tt-param.arq-csv).
    END.
    &ELSE
    /*:T** Importacao/Exportacao ***/
    DO ON ERROR UNDO, RETURN ERROR
       ON STOP  UNDO, RETURN ERROR:
        {report/rpexa.i}

        IF INPUT FRAME fPage7 rsDestiny   = 2 AND
           INPUT FRAME fPage7 rsExecution = 1 THEN DO:
            RUN utp/ut-vlarq.p (INPUT INPUT FRAME fPage7 cDestinyFile).

            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 73,
                                   INPUT "":U).

                APPLY "ENTRY":U TO cDestinyFile IN FRAME fPage7.

                RETURN ERROR.
            END.
        END.

        ASSIGN FILE-INFO:FILE-NAME = INPUT FRAME fPage4 cInputFile.

        IF FILE-INFO:PATHNAME             = ? AND
           INPUT FRAME fPage7 rsExecution = 1 THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 326,
                               INPUT cInputFile).

            APPLY "ENTRY":U TO cInputFile IN FRAME fPage4.

            RETURN ERROR.
        END.


        /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas
           devem apresentar uma mensagem de erro cadastrada, posicionar na p†gina
           com problemas e colocar o focus no campo com problemas */

        CREATE tt-param.
        ASSIGN tt-param.usuario         = c-seg-usuario
               tt-param.destino         = INPUT FRAME fPage7 rsDestiny
               tt-param.todos           = INPUT FRAME fPage7 rsAll
               tt-param.arq-entrada     = INPUT FRAME fPage4 cInputFile
               tt-param.data-exec       = TODAY
               tt-param.hora-exec       = TIME.

        IF tt-param.destino = 1 THEN
            ASSIGN tt-param.arq-destino = "":U.
        ELSE IF tt-param.destino = 2 THEN
            ASSIGN tt-param.arq-destino = INPUT FRAME fPage7 cDestinyFile.
        ELSE
            ASSIGN tt-param.arq-destino = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.


        /*:T Coloque aqui a l¢gica de gravaá∆o dos parÉmtros e seleá∆o na temp-table
           tt-param */

        ASSIGN tt-param.lista-obsoletos = INPUT FRAME fPage4 tg-lista-obsoletos.

        {report/imexb.i}

        IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN.

        {report/imrun.i xxp/xx9999rp.p}

        {report/imexc.i}
            
        IF SESSION:SET-WAIT-STATE("":U) THEN.

        {report/imtrm.i tt-param.arq-destino tt-param.destino}
    END.
    &ENDIF

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

