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
{include/i-prgvrs.i es0950 2.06.00.002}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        es0950
&GLOBAL-DEFINE Version        2.06.00.002
&GLOBAL-DEFINE VersionLayout  1

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,ImpressÆo

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
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo

&GLOBAL-DEFINE page2Fields    ini-data fim-data ini-conta fim-conta l-despesa l-previa l-resultado ini-ccusto fim-ccusto ini-item fim-item ini-estab fim-estab cod_cenar_ctbl l-33 l-ACR l-APB l-APL l-CEP l-CMG l-FAS l-FGL l-FTP l-of
&GLOBAL-DEFINE page6Fields    cFile

{esp/es0950tt.i}

/* Transfer Definitions */

def var raw-param        as raw no-undo.


def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-temp         as char    no-undo.
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.

def stream s-imp.

DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

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
     SIZE 88 BY 1.42
     BGCOLOR 7 .

def new global shared var v_rec_cenar_ctbl
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

DEFINE VARIABLE fim-ccusto AS CHARACTER FORMAT "x(05)" INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .79 NO-UNDO.

DEFINE VARIABLE fim-conta AS CHARACTER FORMAT "X(8)":U INITIAL "99999999" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE fim-data AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .79 NO-UNDO.

DEFINE VARIABLE fim-estab AS CHARACTER FORMAT "x(03)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .79 NO-UNDO.

DEFINE VARIABLE fim-item AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16.86 BY .79 NO-UNDO.

DEFINE VARIABLE ini-ccusto AS CHARACTER FORMAT "x(05)" 
     LABEL "CCusto" 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .79 NO-UNDO.

DEFINE VARIABLE ini-conta AS CHARACTER FORMAT "X(8)":U INITIAL "0" 
     LABEL "Conta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE ini-data AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Transa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .79 NO-UNDO.

DEFINE VARIABLE ini-estab AS CHARACTER FORMAT "x(03)" 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .79 NO-UNDO.

DEFINE VARIABLE ini-item AS CHARACTER FORMAT "x(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 16.86 BY .79 NO-UNDO.

DEFINE VARIABLE cod_cenar_ctbl AS CHARACTER FORMAT "X(8)":U INITIAL "FISCAL"
     LABEL "Cen rio" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 11.21.

DEFINE VARIABLE l-33 AS LOGICAL INITIAL no 
     LABEL "Esp‚cie 33" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE l-previa AS LOGICAL INITIAL no 
     LABEL "Pr‚via" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE l-resultado AS LOGICAL INITIAL no 
     LABEL "Apura‡Æo de Resultado" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE l-ACR AS LOGICAL INITIAL yes 
     LABEL "Contas a Receber" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.14 BY .83 NO-UNDO.

DEFINE VARIABLE l-APB AS LOGICAL INITIAL yes 
     LABEL "Contas a Pagar" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.14 BY .83 NO-UNDO.

DEFINE VARIABLE l-APL AS LOGICAL INITIAL yes 
     LABEL "Aplica‡äes Empr‚stimos" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.14 BY .83 NO-UNDO.

DEFINE VARIABLE l-CEP AS LOGICAL INITIAL yes 
     LABEL "Estoque" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.14 BY .83 NO-UNDO.

DEFINE VARIABLE l-CMG AS LOGICAL INITIAL yes 
     LABEL "Caixa e Bancos" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.14 BY .83 NO-UNDO.

DEFINE VARIABLE l-despesa AS LOGICAL INITIAL yes 
     LABEL "Somente Contas de Despesa" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.

DEFINE VARIABLE l-FAS AS LOGICAL INITIAL yes 
     LABEL "Ativo Fixo" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.14 BY .83 NO-UNDO.

DEFINE VARIABLE l-FGL AS LOGICAL INITIAL yes 
     LABEL "Contabilidade Fiscal" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.14 BY .83 NO-UNDO.

DEFINE VARIABLE l-FTP AS LOGICAL INITIAL yes 
     LABEL "Faturamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.14 BY .83 NO-UNDO.

DEFINE VARIABLE l-of AS LOGICAL INITIAL no 
     LABEL "Obriga‡äes Fiscais" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.43 BY .83 NO-UNDO.

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
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.86 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 3
     btCancel AT ROW 16.75 COL 14
     btHelp2 AT ROW 16.75 COL 79
     rtToolBar AT ROW 16.5 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     ini-estab AT ROW 2.71 COL 26.57 COLON-ALIGNED
     fim-estab AT ROW 2.71 COL 54.57 COLON-ALIGNED NO-LABEL
     ini-data AT ROW 3.71 COL 16.71 WIDGET-ID 14
     fim-data AT ROW 3.71 COL 56.57 NO-LABEL WIDGET-ID 16
     ini-conta AT ROW 4.71 COL 26.57 COLON-ALIGNED WIDGET-ID 56
     fim-conta AT ROW 4.71 COL 54.57 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     ini-ccusto AT ROW 5.71 COL 26.57 COLON-ALIGNED WIDGET-ID 14
     fim-ccusto AT ROW 5.71 COL 54.57 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     ini-item AT ROW 6.71 COL 26.57 COLON-ALIGNED WIDGET-ID 56
     fim-item AT ROW 6.71 COL 54.57 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     cod_cenar_ctbl AT ROW 7.71 COL 26.57 COLON-ALIGNED WIDGET-ID 56
     l-despesa AT ROW 8.71 COL 9.86
     l-previa  AT ROW 8.71 COL 36.86
     l-resultado  AT ROW 8.71 COL 50.86
     l-33 AT ROW 9.71 COL 9.86
     l-of AT ROW 9.71 COL 36.86 WIDGET-ID 80
     l-ACR AT ROW 10.71 COL 9.86
     l-FTP AT ROW 10.75 COL 24.86
     l-CMG AT ROW 10.71 COL 36.86
     l-FGL AT ROW 10.71 COL 50.86
     l-APB AT ROW 11.71 COL 9.86
     l-CEP AT ROW 11.71 COL 24.86
     l-FAS AT ROW 11.71 COL 36.86
     l-APL AT ROW 11.71 COL 50.86
     IMAGE-11 AT ROW 2.71 COL 40.57
     IMAGE-12 AT ROW 2.71 COL 53.57
     IMAGE-1 AT ROW 3.71 COL 40.57
     IMAGE-2 AT ROW 3.71 COL 53.57
     IMAGE-5 AT ROW 4.71 COL 40.57 WIDGET-ID 18
     IMAGE-6 AT ROW 4.71 COL 53.57 WIDGET-ID 20
     IMAGE-7 AT ROW 5.71 COL 40.57
     IMAGE-8 AT ROW 5.71 COL 53.57
     IMAGE-9 AT ROW 6.71 COL 45.57 WIDGET-ID 18
     IMAGE-10 AT ROW 6.71 COL 53.57 WIDGET-ID 20
     RECT-11 AT ROW 2.08 COL 3.43 WIDGET-ID 78
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.96
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configura‡Æo da impressora"
     rsExecution AT ROW 6 COL 2.86 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5.25 COL 3.14 NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.5 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 11.96
         FONT 1 WIDGET-ID 100.


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

{report/report.i}

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
   Custom                                                               */
/* SETTINGS FOR FILL-IN fim-data IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN ini-data IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME fPage6
   ALIGN-L                                                              */
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

/* zoom cen rio cont bil */
ON  F5 OF cod_cenar_ctbl IN FRAME fPage2 
OR  MOUSE-SELECT-DBLCLICK OF cod_cenar_ctbl IN FRAME fPage2 DO:
    
    if  search("prgint/utb/utb076ka.r") = ? and search("prgint/utb/utb076ka.p") = ? then do:
        message "Programa execut vel nÆo foi encontrado: prgint/utb/utb076ka.p" view-as alert-box error buttons ok.
        return.
    end.
    else
        run prgint/utb/utb076ka.p.

    if  v_rec_cenar_ctbl <> ? then do:
        find cenar_ctbl where recid(cenar_ctbl) = v_rec_cenar_ctbl no-lock no-error.
        assign cod_cenar_ctbl:screen-value in frame fPage2 = string(cenar_ctbl.cod_cenar_ctbl).

    end.
    apply "entry" to cod_cenar_ctbl in frame fPage2.
end.

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
   do  on error undo, return no-apply:

       IF  INPUT FRAME fpage2 cod_cenar_ctbl = "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Cen rio cont bil nÆo foi informado !":U).
            RETURN NO-APPLY.
       END.

       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME ini-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ini-ccusto wReport
ON LEAVE OF ini-ccusto IN FRAME fPage2 /* CCusto */
OR LEAVE OF fim-ccusto
DO:

    ASSIGN ini-ccusto fim-ccusto.

    IF ini-ccusto <> "" OR fim-ccusto <> "ZZZZZ" THEN DO:
         ASSIGN  l-despesa = YES.
         DISP    l-despesa WITH FRAME fPage2.
         DISABLE l-despesa WITH FRAME fPage2.
    END.
    ELSE ENABLE l-despesa WITH FRAME fPage2.

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
                   .
                   /*Fim alteracao 15/02/2005*/
        end.
        when "2":U then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no
                   .
        end.
        when "3":U then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no
                   .
        END.
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


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{report/mainblock.i}

cod_cenar_ctbl:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage2.

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
DEFINE VARIABLE dt-periodo AS DATE        NO-UNDO.

do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}

    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */

    create tt-param.
    assign tt-param.usuario        = c-seg-usuario
           tt-param.destino        = input frame fPage6 rsDestiny
           tt-param.data-exec      = today
           tt-param.hora-exec      = time
           tt-param.ini-data       = INPUT FRAME fPage2 ini-data
           tt-param.fim-data       = INPUT FRAME fPage2 fim-data
           tt-param.ini-conta      = INPUT FRAME fPage2 ini-conta
           tt-param.fim-conta      = INPUT FRAME fPage2 fim-conta
           tt-param.l-despesa      = INPUT FRAME fPage2 l-despesa
           tt-param.l-previa       = INPUT FRAME fPage2 l-previa
           tt-param.l-resultado    = INPUT FRAME fPage2 l-resultado
           tt-param.ini-ccusto     = INPUT FRAME fPage2 ini-ccusto
           tt-param.fim-ccusto     = INPUT FRAME fPage2 fim-ccusto
           tt-param.ini-item       = INPUT FRAME fPage2 ini-item
           tt-param.fim-item       = INPUT FRAME fPage2 fim-item
           tt-param.ini-estab      = INPUT FRAME fPage2 ini-estab
           tt-param.fim-estab      = INPUT FRAME fPage2 fim-estab
           tt-param.l-ACR          = INPUT FRAME fPage2 l-ACR
           tt-param.l-APB          = INPUT FRAME fPage2 l-APB
           tt-param.l-APL          = INPUT FRAME fPage2 l-APL
           tt-param.l-CEP          = INPUT FRAME fPage2 l-CEP
           tt-param.l-CMG          = INPUT FRAME fPage2 l-CMG
           tt-param.l-FAS          = INPUT FRAME fPage2 l-FAS
           tt-param.l-FGL          = INPUT FRAME fPage2 l-FGL
           tt-param.l-FTP          = INPUT FRAME fPage2 l-FTP
           tt-param.l-33           = INPUT FRAME fPage2 l-33
           tt-param.l-of           = INPUT FRAME fpage2 l-of
           tt-param.cod_cenar_ctbl = INPUT FRAME fpage2 cod_cenar_ctbl.

    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
        then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i esp/es0950rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

