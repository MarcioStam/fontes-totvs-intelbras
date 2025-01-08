&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i ESPFT044 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP044
&GLOBAL-DEFINE Version        1
&GLOBAL-DEFINE VersionLayout  1

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          no
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
&GLOBAL-DEFINE page2Fields    fi-cat-ini fi-cat-fim fi-sequencia-ini fi-sequencia-fim fi-dt-emissao-ini fi-dt-emissao-fim rs-situacao fi-cliente-ini fi-cliente-fim fi-nfe-ini fi-nfe-fim fi-nome-cli-ini fi-nome-cli-fim
                              
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page6Fields    cFile


/* Parameters Definitions ---                                           */
{esp\ftp\esftp044e.i}

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.

def stream s-imp.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK-2 btCancel-2 btCancel-3 btOK ~
btCancel btHelp2 

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

DEFINE BUTTON btCancel-2 
     IMAGE-UP FILE "image/im-las.bmp":U
     LABEL "Fechar" 
     SIZE 4 BY 1.

DEFINE BUTTON btCancel-3 
     IMAGE-UP FILE "image/im-las.bmp":U
     LABEL "Fechar" 
     SIZE 4 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK-2 
     IMAGE-UP FILE "image/im-faixa.bmp":U
     LABEL "Executar" 
     SIZE 6 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 83 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE fi-cat-fim AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cat-ini AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "CAT" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cliente-fim AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 9999999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cliente-ini AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Cod. Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-dt-emissao-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/2999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE fi-dt-emissao-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/1900 
     LABEL "Dt. EmissÆo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE fi-nfe-fim AS CHARACTER FORMAT "X(09)":U INITIAL "ZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-nfe-ini AS CHARACTER FORMAT "X(08)":U 
     LABEL "Nota Fiscal Entrada" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-nome-cli-fim AS CHARACTER FORMAT "X(30)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 28 BY .79 NO-UNDO.

DEFINE VARIABLE fi-nome-cli-ini AS CHARACTER FORMAT "X(08)":U 
     LABEL "Nome Cliente" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .79 NO-UNDO.

DEFINE VARIABLE fi-sequencia-fim AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 7 BY .79 NO-UNDO.

DEFINE VARIABLE fi-sequencia-ini AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Sequencia" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .79 NO-UNDO.

DEFINE IMAGE IMAGE-15
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-16
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-17
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-18
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-19
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-20
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-21
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-22
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-23
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-24
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY 1.

DEFINE VARIABLE rs-situacao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Realizado", 1,
"NÆo Realizado", 2,
"Ambos", 3
     SIZE 34 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 1.75.

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
     SIZE 46.72 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 57.72 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 48 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73.86 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73.86 BY 1.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK-2 AT ROW 3.75 COL 44 WIDGET-ID 6
     btCancel-2 AT ROW 4 COL 44 WIDGET-ID 2
     btCancel-3 AT ROW 4 COL 48 WIDGET-ID 4
     btOK AT ROW 12 COL 3
     btCancel AT ROW 12 COL 14
     btHelp2 AT ROW 12 COL 74
     rtToolBar AT ROW 11.75 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85.57 BY 12.33
         FONT 1.

DEFINE FRAME fPage2
     fi-cat-ini AT ROW 1.25 COL 14 COLON-ALIGNED WIDGET-ID 2
     fi-cat-fim AT ROW 1.25 COL 50 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     fi-sequencia-ini AT ROW 2.08 COL 14 COLON-ALIGNED
     fi-sequencia-fim AT ROW 2.08 COL 50 COLON-ALIGNED NO-LABEL
     fi-dt-emissao-ini AT ROW 3.08 COL 14 COLON-ALIGNED WIDGET-ID 52
     fi-dt-emissao-fim AT ROW 3.08 COL 50 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     fi-cliente-ini AT ROW 4.08 COL 14 COLON-ALIGNED WIDGET-ID 70
     fi-cliente-fim AT ROW 4.08 COL 50 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     fi-nome-cli-ini AT ROW 5.08 COL 14 COLON-ALIGNED WIDGET-ID 90
     fi-nome-cli-fim AT ROW 5.08 COL 50 COLON-ALIGNED NO-LABEL WIDGET-ID 88
     fi-nfe-ini AT ROW 6.08 COL 14.14 COLON-ALIGNED WIDGET-ID 82
     fi-nfe-fim AT ROW 6.08 COL 50 COLON-ALIGNED NO-LABEL WIDGET-ID 80
     rs-situacao AT ROW 7.75 COL 21 NO-LABEL WIDGET-ID 66
     IMAGE-3 AT ROW 2.25 COL 48 WIDGET-ID 8
     IMAGE-4 AT ROW 2.25 COL 44 WIDGET-ID 10
     IMAGE-15 AT ROW 1.25 COL 48 WIDGET-ID 46
     IMAGE-16 AT ROW 1.25 COL 44 WIDGET-ID 48
     IMAGE-17 AT ROW 3.25 COL 48 WIDGET-ID 54
     IMAGE-18 AT ROW 3.25 COL 44 WIDGET-ID 56
     RECT-11 AT ROW 7.25 COL 12 WIDGET-ID 64
     IMAGE-19 AT ROW 4.25 COL 48 WIDGET-ID 72
     IMAGE-20 AT ROW 4.25 COL 44 WIDGET-ID 74
     IMAGE-21 AT ROW 6.25 COL 48 WIDGET-ID 84
     IMAGE-22 AT ROW 6.25 COL 44 WIDGET-ID 86
     IMAGE-23 AT ROW 5.25 COL 48 WIDGET-ID 92
     IMAGE-24 AT ROW 5.25 COL 44 WIDGET-ID 94
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 80.43 BY 8.5
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 51 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 51 HELP
          "Configura‡Æo da impressora"
     cFile AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.75 COL 3 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 80.43 BY 7
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
         HEIGHT             = 12.5
         WIDTH              = 85.72
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.29
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
/* SETTINGS FOR FRAME fPage6
                                                                        */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

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


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel-2 wReport
ON CHOOSE OF btCancel-2 IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel-3 wReport
ON CHOOSE OF btCancel-3 IN FRAME fpage0 /* Fechar */
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
   DO ON ERROR UNDO, RETURN NO-APPLY:
      RUN piExecute.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK-2 wReport
ON CHOOSE OF btOK-2 IN FRAME fpage0 /* Executar */
DO:
   DO ON ERROR UNDO, RETURN NO-APPLY:
      RUN piExecute.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME fi-cat-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cat-fim wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cat-fim IN FRAME fPage2
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cat-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cat-ini wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cat-ini IN FRAME fPage2 /* CAT */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
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
                   btConfigImpr:visible  = yes.
        end.
        when "2":U then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no.
        end.
        when "3":U then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no.
        end.
    end case.
end.
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


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/* ***************************  Main Block  *************************** */

/*
fi-Cod-Emitente:load-mouse-pointer ("image/lupa.cur") in frame fpage2.
fi-Cod-Representante:load-mouse-pointer ("image/lupa.cur") in frame fpage2.
*/

/* Include custom  Main Block code for SmartWindows. */
/*
{src/adm/template/windowmn.i}
*/



    /*:T--- L¢gica para inicializa‡Æo do programam ---*/
    {report/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR r-tt-digita AS ROWID NO-UNDO.

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
/*:T** Relatorio ***/
 
DO ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    {report/rpexa.i}
    
    IF INPUT frame fPage6 rsDestiny   = 2 AND
       INPUT frame fPage6 rsExecution = 1 THEN DO:
       RUN utp/ut-vlarq.p (input input frame fPage6 cFile).
        
       IF RETURN-VALUE = "NOK":U THEN DO:
          RUN utp/ut-msgs.p (input "show":U, input 73, input "":U).
          APPLY "ENTRY":U to cFile in frame fPage6.
          RETURN error.
       END.
    END.
    
    /*:T Coloque aqui as valida‡äes da p gina de Digita‡Æo, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p gina e colocar
       o focus no campo com problemas */
    /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/
    
    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    
    CREATE tt-param.
    ASSIGN tt-param.usuario         = c-seg-usuario
           tt-param.destino         = INPUT frame fPage6 rsDestiny
           tt-param.data-exec       = TODAY
           tt-param.hora-exec       = TIME.

    DO WITH FRAME fPage2:
        assign tt-param.fi-cat-ini              = int(INPUT fi-cat-ini:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-cat-fim              = int(INPUT fi-cat-fim:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-sequencia-ini        = int(INPUT fi-sequencia-ini:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-sequencia-fim        = int(INPUT fi-sequencia-fim:SCREEN-VALUE IN FRAME fpage2)               
               tt-param.fi-dt-emissao-ini       = date(INPUT fi-dt-emissao-ini:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-dt-emissao-fim       = date(INPUT fi-dt-emissao-fim:SCREEN-VALUE IN FRAME fpage2) 
               tt-param.fi-nfe-ini              = INPUT fi-nfe-ini:SCREEN-VALUE IN FRAME fpage2              
               tt-param.fi-nfe-fim              = INPUT fi-nfe-fim:SCREEN-VALUE IN FRAME fpage2                             
               tt-param.fi-cliente-ini          = int(INPUT fi-cliente-ini:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-cliente-fim          = int(INPUT fi-cliente-fim:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-nome-cli-ini         = INPUT fi-nome-cli-ini:SCREEN-VALUE IN FRAME fpage2
               tt-param.fi-nome-cli-fim         = INPUT fi-nome-cli-fim:SCREEN-VALUE IN FRAME fpage2               
               tt-param.rs-situacao             = int(INPUT rs-situacao:SCREEN-VALUE IN FRAME fpage2).
              
    END.

    IF tt-param.destino = 1 then 
       ASSIGN tt-param.arquivo = "":U.
    ELSE 
       IF tt-param.destino = 2 THEN
          ASSIGN tt-param.arquivo = input frame fPage6 cFile.
       ELSE
          ASSIGN tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    
    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    

    {report/rprun.i esp\ftp\esftp044erp.p}
    

    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
END.


&ELSE

/*:T** Importacao/Exportacao ***/
DO ON ERROR UNDO, RETURN ERROR
   ON STOP UNDO, RETURN ERROR:     

    {report/rpexa.i}

   IF INPUT FRAME fPage7 rsDestiny   = 2 AND
      INPUT FRAME fPage7 rsExecution = 1 THEN DO:
      RUN utp/ut-vlarq.p (input input frame fPage7 cDestinyFile).
      IF RETURN-VALUE = "NOK":U then do:
         RUN utp/ut-msgs.p (input "SHOW":U,
                            input 73,
                            input "":U).
         APPLY "ENTRY":U to cDestinyFile in frame fPage7.                   
         RETURN error.
      END.
   END.
    
   ASSIGN file-info:file-name = input frame fPage4 cInputFile.
   IF FILE-INFO:pathname = ? AND
      INPUT frame fPage7 rsExecution = 1 then do:
      RUN utp/ut-msgs.p (input "SHOW":U,
                         input 326,
                         input cInputFile).                               
      APPLY "ENTRY":U to cInputFile in frame fPage4.                
      RETURN error.
   END. 
            
    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p gina 
       com problemas e colocar o focus no campo com problemas             */    
         
   CREATE tt-param.
   ASSIGN tt-param.usuario         = c-seg-usuario
          tt-param.destino         = input frame fPage7 rsDestiny
          tt-param.todos           = input frame fPage7 rsAll
          tt-param.arq-entrada     = input frame fPage4 cInputFile
          tt-param.data-exec       = today
          tt-param.hora-exec       = time.

   IF tt-param.destino = 1 then
      ASSIGN tt-param.arq-destino = "":U.
   ELSE
      IF tt-param.destino = 2 then 
         ASSIGN tt-param.arq-destino = input frame fPage7 cDestinyFile.
      ELSE
         ASSIGN tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp":U.

    /*:T Coloque aqui a l¢gica de grava‡Æo dos parƒmtros e sele‡Æo na temp-table tt-param */ 

   {report/imexb.i}

   IF SESSION:set-wait-state("GENERAL":U) then.

      {report/imrun.i xxp/xx9999rp.p}

   {report/imexc.i}

   IF SESSION:set-wait-state("":U) then.
    
      {report/imtrm.i tt-param.arq-destino tt-param.destino}
    
END.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

