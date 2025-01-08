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
{include/i-prgvrs.i ESPFT056 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP056
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
&GLOBAL-DEFINE page2Fields    tb-envia-e-mail fi-estab-ini fi-estab-fim fi-cod-repres-ini fi-cod-repres-fim fi-cod-emitente-ini fi-cod-emitente-fim fi-periodo-ini fi-periodo-fim rs-previa-oficial perc-ir
                              
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page6Fields    cFile


/* Parameters Definitions ---                                           */
{esp\ftp\esftp056.i}

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.

def stream s-imp.
{upc\btb910za-upc.i}

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

DEFINE VARIABLE fi-cod-emitente-fim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 9999999 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-emitente-ini AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-repres-fim AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-repres-ini AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Representante" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab-fim AS CHARACTER FORMAT "X(3)":U INITIAL "999" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo-fim AS CHARACTER FORMAT "X(256)":U INITIAL "200901" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo-ini AS CHARACTER FORMAT "X(256)":U INITIAL "200901" 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE perc-ir AS CHARACTER FORMAT "X(256)":U INITIAL "1,50" 
     LABEL "% IR" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

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

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY 1.

DEFINE VARIABLE rs-previa-oficial AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Pr‚via", 1,
"Oficial", 2
     SIZE 28 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 2.5.

DEFINE VARIABLE tb-envia-e-mail AS LOGICAL INITIAL no 
     LABEL "Envia e-mail para os Representantes" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .83 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER INITIAL "c:~\temp~\comissoes~\esftp056.lst" 
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

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 2 
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

DEFINE VARIABLE tb-parametros-auto AS LOGICAL INITIAL no 
     LABEL "Periodo Autom tico" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK-2 AT ROW 3.75 COL 44 WIDGET-ID 6
     btCancel-2 AT ROW 4 COL 44 WIDGET-ID 2
     btCancel-3 AT ROW 4 COL 48 WIDGET-ID 4
     btOK AT ROW 12.75 COL 3
     btCancel AT ROW 12.75 COL 14
     btHelp2 AT ROW 12.75 COL 74
     rtToolBar AT ROW 12.5 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85 BY 13.25
         FONT 1.

DEFINE FRAME fPage2
     fi-estab-ini AT ROW 1.5 COL 29 COLON-ALIGNED WIDGET-ID 2
     fi-estab-fim AT ROW 1.5 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     fi-cod-repres-ini AT ROW 2.5 COL 27 COLON-ALIGNED
     fi-cod-repres-fim AT ROW 2.5 COL 41 COLON-ALIGNED NO-LABEL
     fi-cod-emitente-ini AT ROW 3.5 COL 26 COLON-ALIGNED WIDGET-ID 80
     fi-cod-emitente-fim AT ROW 3.5 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 82
     fi-periodo-ini AT ROW 4.5 COL 26 COLON-ALIGNED WIDGET-ID 52
     fi-periodo-fim AT ROW 4.5 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     perc-ir AT ROW 5.5 COL 26 COLON-ALIGNED WIDGET-ID 72
     rs-previa-oficial AT ROW 7.25 COL 25 NO-LABEL WIDGET-ID 66
     tb-envia-e-mail AT ROW 8.25 COL 26 WIDGET-ID 70
     IMAGE-3 AT ROW 2.5 COL 36 WIDGET-ID 8
     IMAGE-4 AT ROW 2.5 COL 40 WIDGET-ID 10
     IMAGE-15 AT ROW 1.5 COL 36 WIDGET-ID 46
     IMAGE-16 AT ROW 1.5 COL 40 WIDGET-ID 48
     RECT-11 AT ROW 6.75 COL 13 WIDGET-ID 64
     IMAGE-17 AT ROW 3.5 COL 36 WIDGET-ID 76
     IMAGE-18 AT ROW 3.5 COL 40 WIDGET-ID 78
     IMAGE-19 AT ROW 4.5 COL 36 WIDGET-ID 84
     IMAGE-20 AT ROW 4.5 COL 40 WIDGET-ID 86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 80.43 BY 9.5
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
     tb-parametros-auto AT ROW 7.75 COL 25 WIDGET-ID 2
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 80.43 BY 9.25
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
         HEIGHT             = 13.71
         WIDTH              = 88.86
         MAX-HEIGHT         = 30.17
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 30.17
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
&Scoped-define SELF-NAME fi-estab-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estab-fim wReport
ON MOUSE-SELECT-DBLCLICK OF fi-estab-fim IN FRAME fPage2
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-estab-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estab-ini wReport
ON MOUSE-SELECT-DBLCLICK OF fi-estab-ini IN FRAME fPage2 /* Estabelecimento */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-previa-oficial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-previa-oficial wReport
ON MOUSE-SELECT-CLICK OF rs-previa-oficial IN FRAME fPage2
DO:
/*     IF rs-previa-oficial:SCREEN-VALUE IN FRAME fpage2 = "1" THEN   */
/*         ASSIGN tb-envia-e-mail:SCREEN-VALUE IN FRAME fpage2 = "No" */
/*                tb-envia-e-mail = NO                                */
/*                tb-envia-e-mail:SENSITIVE IN FRAME fpage2 = NO.     */
/*     ELSE                                                           */
/*         ASSIGN tb-envia-e-mail:SENSITIVE IN FRAME fpage2 = yes.    */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wReport 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   ASSIGN tb-parametros-auto:SENSITIVE IN FRAME fpage6 = YES.
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
        assign tt-param.fi-estab-ini            = string(INPUT fi-estab-ini:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-estab-fim            = string(INPUT fi-estab-fim:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-cod-repres-ini       = int(INPUT fi-cod-repres-ini:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-cod-repres-fim       = int(INPUT fi-cod-repres-fim:SCREEN-VALUE IN FRAME fpage2)               
               tt-param.fi-periodo-ini          = INPUT fi-periodo-ini:SCREEN-VALUE IN FRAME fpage2
               tt-param.fi-periodo-fim          = INPUT fi-periodo-fim:SCREEN-VALUE IN FRAME fpage2               
               tt-param.fi-cod-emitente-ini     = INT(INPUT fi-cod-emitente-ini:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-cod-emitente-fim     = INT(INPUT fi-cod-emitente-fim:SCREEN-VALUE IN FRAME fpage2)
               tt-param.rs-previa-oficial       = int(INPUT rs-previa-oficial:SCREEN-VALUE IN FRAME fpage2)
               tt-param.envia-e-mail            = INPUT frame fPage2 tb-envia-e-mail
               tt-param.fi-perc-ir              = dec(INPUT FRAME fPage2 perc-ir)
               tt-param.agendamento             = logical(INPUT tb-parametros-auto:SCREEN-VALUE IN FRAME fpage6).
              
    END.
        

    IF tt-param.rs-previa-oficial = 2 then do:
        IF  tt-param.fi-estab-ini = "101" 
        THEN DO:
            find first comissao-fat
                 where comissao-fat.periodo = INPUT fi-periodo-ini:SCREEN-VALUE IN FRAME fpage2
                   and comissao-fat.cod-estabel >= tt-param.fi-estab-ini
                   and comissao-fat.cod-estabel <= tt-param.fi-estab-fim
                   AND comissao-fat.id-tipo-inform = 3
                 no-lock no-error.
            if NOT avail comissao-fat THEN DO:
                  message "Inadimplencia nÆo calculada para o per¡odo":U view-as alert-box.

                 RETURN error.
            end.

        END.
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

    {report/rprun.i esp\ftp\esftp056rp.p}
    

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

