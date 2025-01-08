&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*****************************************************************************
**     Programa.........: esp/esacpp023
**     Descricao .......: 
**     Versao...........: 1.00.000
**     Autor............: Clayton Antunes
**     Criado...........: 09/08/2006
*******************************************************************************/


{include/i-prgvrs.i XX9999 2.04.00.002}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escpp023
&GLOBAL-DEFINE Version        2.04.00.002
&GLOBAL-DEFINE VersionLayout  1

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o,Impress∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          NO
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO


&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page4Widgets   
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution
&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo

&GLOBAL-DEFINE page2Fields    rs-opcao c-it-cod tg-selecionar                             
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page6Fields    cfile 

/* Parameters Definitions ---                                           */

{esp\cpp\escpp023tt.i}
/* Transfer Definitions */

def var raw-param        as raw no-undo.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.

def stream s-imp.



DEF VAR opc AS INT INITIAL 1.



CREATE WIDGET-POOL.

DEF STREAM STREAM_1.
DEF VAR c-ant                 AS CHAR.
DEF VAR v_num_ped_exec_rpw    AS INTE.
DEF VAR v_log_det             AS logi INIT NO.
DEF VAR v_cod_exessao         AS CHAR.
DEF VAR c-impressora          AS CHAR.
DEF VAR c-layout              AS CHAR.
DEF VAR wh-exessao            as HANDLE.



DEF VAR rs-val AS INT INITIAL 1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-selecionado

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE br-selecionado                                */
&Scoped-define FIELDS-IN-QUERY-br-selecionado tt-digita.selecionado tt-digita.componente tt-digita.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-selecionado   
&Scoped-define SELF-NAME br-selecionado
&Scoped-define QUERY-STRING-br-selecionado FOR EACH tt-digita
&Scoped-define OPEN-QUERY-br-selecionado OPEN QUERY {&SELF-NAME} FOR EACH tt-digita.
&Scoped-define TABLES-IN-QUERY-br-selecionado tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-br-selecionado tt-digita


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-br-selecionado}

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
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON bt-desmarca 
     LABEL "Desmarca" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-desmarca-todos 
     LABEL "Desmarca Todos" 
     SIZE 13 BY 1.

DEFINE BUTTON bt-marca 
     LABEL "Marca" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-marca-todos 
     LABEL "Marca Todos" 
     SIZE 12 BY 1.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-cod AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE rs-opcao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Pequena", 1,
"Media", 3,
"Grande", 2
     SIZE 27.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 2.38.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 7.75.

DEFINE VARIABLE tg-selecionar AS LOGICAL INITIAL no 
     LABEL "Selecionar Componentes?" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cfile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 69.86 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 6.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 7.86 BY .63
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
     SIZE 42 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80.86 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-selecionado FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-selecionado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-selecionado wReport _FREEFORM
  QUERY br-selecionado DISPLAY
      tt-digita.selecionado COLUMN-LABEL "" FORMAT "*/"
 tt-digita.componente  COLUMN-LABEL "Componente" FORMAT "x(16)"
 tt-digita.descricao   COLUMN-LABEL "Descriá∆o"  FORMAT "x(60)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 80 BY 5.17
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 14.25 COL 2
     btCancel AT ROW 14.25 COL 13
     btHelp2 AT ROW 14.25 COL 80
     rtToolBar AT ROW 14 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14.63
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     btConfigImpr AT ROW 3.5 COL 74 HELP
          "Configuraá∆o da impressora"
     btFile AT ROW 3.5 COL 74 HELP
          "Escolha do nome do arquivo"
     cfile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 6 COL 4 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5.25 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.5 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 10.71
         FONT 1.

DEFINE FRAME fPage2
     rs-opcao AT ROW 1.46 COL 13.14 NO-LABEL
     c-it-cod AT ROW 2.46 COL 10.86 COLON-ALIGNED
     c-desc-item AT ROW 2.46 COL 24.14 COLON-ALIGNED NO-LABEL
     tg-selecionar AT ROW 3.88 COL 3 WIDGET-ID 8
     br-selecionado AT ROW 4.96 COL 3 WIDGET-ID 100
     bt-marca AT ROW 10.21 COL 3.14 WIDGET-ID 52
     bt-desmarca AT ROW 10.21 COL 15.14 WIDGET-ID 54
     bt-marca-todos AT ROW 10.21 COL 27.14 WIDGET-ID 56
     bt-desmarca-todos AT ROW 10.21 COL 39.14 WIDGET-ID 58
     "Opá∆o:" VIEW-AS TEXT
          SIZE 5 BY .88 AT ROW 1.42 COL 7.72 WIDGET-ID 10
     RECT-27 AT ROW 1.25 COL 2
     RECT-29 AT ROW 3.71 COL 2 WIDGET-ID 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 10.71
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
         HEIGHT             = 14.63
         WIDTH              = 90
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.14
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.14
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

{Report\Report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB br-selecionado tg-selecionar fPage2 */
/* SETTINGS FOR FRAME fPage6
                                                                        */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execuá∆o".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-selecionado
/* Query rebuild information for BROWSE br-selecionado
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-digita.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-selecionado */
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


&Scoped-define BROWSE-NAME br-selecionado
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME br-selecionado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-selecionado wReport
ON MOUSE-SELECT-DBLCLICK OF br-selecionado IN FRAME fPage2
DO:
    IF AVAIL tt-digita THEN DO:
        IF tt-digita.selecionado THEN 
            APPLY 'choose' TO bt-desmarca IN FRAME fPage2.
        ELSE 
            APPLY 'choose' TO bt-marca IN FRAME fPage2.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-selecionado wReport
ON ROW-DISPLAY OF br-selecionado IN FRAME fPage2
DO:
  RUN pi-cor-browser.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desmarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desmarca wReport
ON CHOOSE OF bt-desmarca IN FRAME fPage2 /* Desmarca */
DO:
    if avail tt-digita then do:
        assign tt-digita.selecionado = no.
        disp tt-digita.selecionado with browse br-selecionado.
    end.

    RUN pi-cor-browser.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desmarca-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desmarca-todos wReport
ON CHOOSE OF bt-desmarca-todos IN FRAME fPage2 /* Desmarca Todos */
DO:
    for each tt-digita:
        assign tt-digita.selecionado = no.
    end.
  
    RUN pi-cor-browser.
        
    br-selecionado:refresh() no-error.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca wReport
ON CHOOSE OF bt-marca IN FRAME fPage2 /* Marca */
DO:
    if avail tt-digita then do:
        assign tt-digita.selecionado = yes.
        disp tt-digita.selecionado with browse br-selecionado.
    end.

    RUN pi-cor-browser.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca-todos wReport
ON CHOOSE OF bt-marca-todos IN FRAME fPage2 /* Marca Todos */
DO:
    for each tt-digita:
        assign tt-digita.selecionado = yes.
    end.
  
    RUN pi-cor-browser.

    br-selecionado:refresh() no-error.
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
    /*
    DEF VAR tempini AS INT.
    DEF VAR tempfim AS INT.


    ASSIGN tempini = int(l-inicial:SCREEN-VALUE IN FRAME fpage6)
           tempfim = int(l-final:SCREEN-VALUE IN FRAME fpage6).
                                

    IF rs-val = 1 THEN DO: 
       IF tempini > tempfim THEN DO:
          MESSAGE "Linha inicial n∆o pode ser maior que a Linha final!"
                   VIEW-AS ALERT-BOX INFO BUTTONS OK.
          LEAVE.
       END.

       IF tempini <= 0 THEN DO:
          MESSAGE "Linha inicial tem que ser maior que zero."
                   VIEW-AS ALERT-BOX INFO BUTTONS OK.
          LEAVE.
       END.

    END.
    */    
        

    do  on error undo, return no-apply:
       run piExecute.
   end.
   
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME c-it-cod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-cod wReport
ON LEAVE OF c-it-cod IN FRAME fPage2 /* Item */
DO:

    FOR EACH tt-digita:
        DELETE tt-digita.
    END.

    ASSIGN tg-selecionar:SCREEN-VALUE IN FRAME fPage2 = "no".

    {&OPEN-QUERY-br-selecionado}


    FIND item WHERE 
         item.it-codigo = c-it-cod:SCREEN-VALUE IN FRAME fpage2 NO-LOCK NO-ERROR.
    IF NOT AVAIL item THEN DO:
       MESSAGE "Item n∆o cadastrado".
       c-it-cod:SCREEN-VALUE IN FRAME fpage2 = "".
       c-desc-item:SCREEN-VALUE IN FRAME fpage2 = "".
    END.
    ELSE DO:
       ASSIGN c-desc-item:SCREEN-VALUE IN FRAME fpage2 = item.descricao-1 + item.descricao-2.
    END.

    APPLY "value-changed" TO tg-selecionar IN FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-opcao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-opcao wReport
ON VALUE-CHANGED OF rs-opcao IN FRAME fPage2
DO:
/*     CASE INPUT FRAME {&FRAME-NAME} rs-opcao: */
/*         WHEN 1 THEN DO:                      */
/*             ASSIGN opc = 1.                  */
/*         END.                                 */
/*         WHEN 2 THEN DO:                      */
/*             ASSIGN opc = 2.                  */
/*         END.                                 */
/*         WHEN 3 THEN DO:                      */
/*             ASSIGN opc = 3.                  */
/*         END.                                 */
/*     END CASE.                                */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage6
DO:

/*
    CASE INPUT FRAME {&FRAME-NAME} rsDestiny:

        WHEN 1 THEN DO:
            rs-seleciona:VISIBLE IN FRAME fpage6  = YES.

        END.
        
        WHEN 2 THEN DO:
            rs-seleciona:VISIBLE IN FRAME fpage6 = NO.

        END.

        WHEN 3 THEN DO:
            rs-seleciona:VISIBLE IN FRAME fpage6 = NO.

        END.

    END CASE.
*/


/*
do with frame fPage6:
    case self:screen-value:
        when "1":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes
                   rs-seleciona:VISIBLE  = YES.
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
                   rs-seleciona:VISIBLE  = NO.
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
                   rs-seleciona:VISIBLE  = NO.
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
*/


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage6
DO:
   {report/rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tg-selecionar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-selecionar wReport
ON VALUE-CHANGED OF tg-selecionar IN FRAME fPage2 /* Selecionar Componentes? */
DO:
    FOR EACH tt-digita:
        DELETE tt-digita.
    END.

    DO WITH FRAME fPage2:
        IF INPUT tg-selecionar THEN DO:
            ENABLE br-selecionado bt-marca bt-desmarca bt-marca-todos bt-desmarca-todos.
            RUN pi-carrega-componentes.
        END.
        ELSE DO:
            DISABLE br-selecionado bt-marca bt-desmarca bt-marca-todos bt-desmarca-todos.
        END.
    END.

    {&OPEN-QUERY-br-selecionado}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/* ***************************  Main Block  *************************** */

{report/MainBlock.i}

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
    ASSIGN l-habilitaRtf:sensitive IN FRAME fPage6 = NO
           l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
           l-habilitaRtf = NO.
           
END.
RUN pi-habilitaRtf.
&endif
/*Fim alteracao 17/02/2005*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-componentes wReport 
PROCEDURE pi-carrega-componentes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-it-codigo AS CHARACTER   NO-UNDO.

    ASSIGN c-it-codigo = c-it-cod:SCREEN-VALUE IN FRAME fPage2.

    IF NOT CAN-FIND(FIRST ITEM WHERE ITEM.it-codigo = c-it-codigo) THEN DO:
        MESSAGE "Item n∆o cadastrado! Informar Item v†lido." 
            VIEW-AS ALERT-BOX.
    END.
    ELSE DO:
        FOR EACH estrutura NO-LOCK     
           WHERE estrutura.it-codigo = c-it-codigo
             AND estrutura.data-inicio <= TODAY
             AND estrutura.data-termino > TODAY:

           FIND FIRST item NO-LOCK 
                WHERE item.it-codigo = estrutura.es-codigo NO-ERROR.

           CREATE tt-digita.
           ASSIGN tt-digita.selecionado = FALSE
                  tt-digita.componente  = estrutura.es-codigo
                  tt-digita.descricao   = IF AVAIL item THEN STRING(item.descricao-1 + item.descricao-2) ELSE "".
        END.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cor-browser wReport 
PROCEDURE pi-cor-browser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF AVAIL tt-digita AND tt-digita.selecionado THEN DO:
        ASSIGN tt-digita.selecionado:BGCOLOR IN BROWSE br-selecionado = 3
               tt-digita.componente:BGCOLOR IN BROWSE br-selecionado = 3
               tt-digita.descricao:BGCOLOR IN BROWSE br-selecionado = 3.
        
    END.
    ELSE DO:
        ASSIGN tt-digita.selecionado:BGCOLOR IN BROWSE br-selecionado = 15
               tt-digita.componente:BGCOLOR IN BROWSE br-selecionado = 15
               tt-digita.descricao:BGCOLOR IN BROWSE br-selecionado = 15.
    END.
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

define var r-tt-digita as rowid no-undo.

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
/*:T** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}
                    
    CREATE tt-param.
    ASSIGN tt-param.usuario         = c-seg-usuario
           tt-param.destino         = INPUT frame fPage6 rsDestiny
           tt-param.data-exec       = TODAY
           tt-param.hora-exec       = TIME.

    ASSIGN tt-param.cod-item    = INPUT FRAME fpage2 c-it-cod
           tt-param.c-descricao = INPUT FRAME fpage2 c-desc-item
           tt-param.Ident       = INPUT FRAME fPage2 rs-opcao
           tt-param.l-parcial   = INPUT FRAME fPage2 tg-selecionar.

    IF tt-param.destino = 1 then 
       ASSIGN tt-param.arquivo = "":U.
    ELSE 
       IF tt-param.destino = 2 THEN
          ASSIGN tt-param.arquivo = input frame fPage6 cFile.
       ELSE
          ASSIGN tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.

    for each tt-raw-digita:
        delete tt-raw-digita.
    end.
    for each tt-digita:
        create tt-raw-digita.
        raw-transfer tt-digita to tt-raw-digita.raw-digita.
    end.  

    /*:T Executar do programa RP.P que ir† criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).

    {report/rprun.i esp/cpp/escpp023rp.p}

    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}


END.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

