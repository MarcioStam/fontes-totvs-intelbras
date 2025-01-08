&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
{include/i-prgvrs.i esesb005 2.00.00.001}  /*** 010002 ***/
/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* TMS {vfp/vfcfgtrp.i}*/

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esesb013
&GLOBAL-DEFINE Version        2.00.00.001
&GLOBAL-DEFINE VersionLayout  2.00           

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Parƒmetros, ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO


&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution

&GLOBAL-DEFINE page6Text      text-destino text-modo

&GLOBAL-DEFINE page0Widgets   btCancel btOk  
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page4Fields    c-arq-bi c-arq-fat c-arq-benef c-arq-saida rs-opcao rs-apuracao bt-bi bt-fat bt-benef
                              
&GLOBAL-DEFINE page6Fields    cFile 

DEF VAR adm-broker-hdl AS HANDLE NO-UNDO.

def new global shared var h-facelift as handle no-undo.

IF NOT VALID-HANDLE(h-facelift) THEN
  RUN btb/btb901zo.p PERSISTENT SET h-facelift.

/* Parameters Definitions ---                                           */

define temp-table tt-param no-undo
    FIELD destino     AS INTEGER
    FIELD arquivo     AS CHAR format "x(35)"
    FIELD usuario     AS CHAR format "x(12)"
    FIELD data-exec   AS DATE
    FIELD hora-exec   AS INTEGER
    FIELD c-arq-bi    AS CHAR
    FIELD c-arq-fat   AS CHAR
    FIELD c-arq-benef AS CHAR
    FIELD rs-opcao    AS INTEGER
    FIELD rs-apuracao AS INTEGER
    FIELD c-arq-saida AS CHAR.
    

define temp-table tt-digita 
    FIELD canal-central AS INTEGER .

define buffer b-tt-digita for tt-digita.


/* Transfer Definitions */
def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.


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
&Scoped-Define ENABLED-OBJECTS rtToolBar btOk btCancel 

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

DEFINE BUTTON btOk 
     LABEL "&Executar" 
     SIZE 15.29 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON bt-benef 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-bi 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-fat 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-arq-benef AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo Base Calc Benef¡cios (esesb009)" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .88 NO-UNDO.

DEFINE VARIABLE c-arq-bi AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo dados B.I." 
     VIEW-AS FILL-IN 
     SIZE 49 BY .88 NO-UNDO.

DEFINE VARIABLE c-arq-fat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo Faturamento (esftp001)" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .88 NO-UNDO.

DEFINE VARIABLE c-arq-saida AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo Concilia‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .88 NO-UNDO.

DEFINE VARIABLE rs-apuracao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Por Filial", 1,
"Centralizado", 2
     SIZE 22 BY .75 NO-UNDO.

DEFINE VARIABLE rs-opcao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Tudo", 1,
"Apenas Diferen‡as", 2
     SIZE 28 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 10.21.

DEFINE RECTANGLE RECT-136
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 1.5.

DEFINE RECTANGLE RECT-137
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 1.5.

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
     SIZE 27.72 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOk AT ROW 15.71 COL 2.57
     btCancel AT ROW 15.71 COL 19.14
     rtToolBar AT ROW 15.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 16.25
         FONT 1.

DEFINE FRAME fpage4
     bt-bi AT ROW 2.92 COL 81 HELP
          "Escolha do nome do arquivo" WIDGET-ID 72
     c-arq-bi AT ROW 3 COL 29.43 COLON-ALIGNED WIDGET-ID 48
     bt-fat AT ROW 3.92 COL 81 HELP
          "Escolha do nome do arquivo" WIDGET-ID 74
     c-arq-fat AT ROW 4 COL 29.43 COLON-ALIGNED WIDGET-ID 50
     bt-benef AT ROW 4.92 COL 81 HELP
          "Escolha do nome do arquivo" WIDGET-ID 76
     c-arq-benef AT ROW 5 COL 29.43 COLON-ALIGNED WIDGET-ID 52
     rs-opcao AT ROW 7 COL 31 NO-LABEL WIDGET-ID 54
     rs-apuracao AT ROW 9 COL 31 NO-LABEL WIDGET-ID 64
     c-arq-saida AT ROW 10.5 COL 26 COLON-ALIGNED WIDGET-ID 62
     "Apura‡Æo" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 8.25 COL 29 WIDGET-ID 70
     "Visualizar:" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 6.25 COL 29 WIDGET-ID 60
     "Concilia‡Æo bases de faturamento:" VIEW-AS TEXT
          SIZE 25.14 BY .54 AT ROW 1.46 COL 4.86 WIDGET-ID 40
     RECT-12 AT ROW 1.79 COL 2 WIDGET-ID 8
     RECT-136 AT ROW 6.5 COL 28 WIDGET-ID 58
     RECT-137 AT ROW 8.5 COL 28 WIDGET-ID 68
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.5
         SIZE 86 BY 11.92
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btConfigImpr AT ROW 3.58 COL 43.29 HELP
          "Configura‡Æo da impressora"
     btFile AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
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
         AT COL 3 ROW 2.5
         SIZE 85 BY 11.92
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
         TITLE              = "Apura‡Æo Benef¡cios Canais"
         HEIGHT             = 15.96
         WIDTH              = 90.72
         MAX-HEIGHT         = 28.38
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.38
         VIRTUAL-WIDTH      = 195.14
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
ASSIGN FRAME fpage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fpage4
                                                                        */
ASSIGN 
       c-arq-saida:READ-ONLY IN FRAME fpage4        = TRUE.

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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage4
/* Query rebuild information for FRAME fpage4
     _Query            is NOT OPENED
*/  /* FRAME fpage4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport /* Apura‡Æo Benef¡cios Canais */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport /* Apura‡Æo Benef¡cios Canais */
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage4
&Scoped-define SELF-NAME bt-benef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-benef wReport
ON CHOOSE OF bt-benef IN FRAME fpage4
DO:
    def var cArqConv  as char no-undo.

    assign cArqConv = replace(input frame fPage4 c-arq-benef, "/":U, "~\":U).
    SYSTEM-DIALOG GET-FILE cArqConv
       FILTERS "*.csv":U "*.csv":U,
               "*.*":U "*.*":U
       ASK-OVERWRITE 
       DEFAULT-EXTENSION "lst":U
       INITIAL-DIR session:temp-directory

       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then do:
        assign c-arq-benef = replace(cArqConv, "~\":U, "/":U).
        display c-arq-benef with frame fPage4.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-bi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-bi wReport
ON CHOOSE OF bt-bi IN FRAME fpage4
DO:
    def var cArqConv  as char no-undo.

    assign cArqConv = replace(input frame fPage4 c-arq-bi, "/":U, "~\":U).
    SYSTEM-DIALOG GET-FILE cArqConv
       FILTERS "*.csv":U "*.csv":U,
               "*.*":U "*.*":U
       ASK-OVERWRITE 
       DEFAULT-EXTENSION "lst":U
       INITIAL-DIR session:temp-directory
   
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then do:
        assign c-arq-bi = replace(cArqConv, "~\":U, "/":U).
        display c-arq-bi with frame fPage4.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fat wReport
ON CHOOSE OF bt-fat IN FRAME fpage4
DO:
    def var cArqConv  as char no-undo.

    assign cArqConv = replace(input frame fPage4 c-arq-fat, "/":U, "~\":U).
    SYSTEM-DIALOG GET-FILE cArqConv
       FILTERS "*.csv":U "*.csv":U,
               "*.*":U "*.*":U
       ASK-OVERWRITE 
       DEFAULT-EXTENSION "lst":U
       INITIAL-DIR session:temp-directory

       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then do:
        assign c-arq-fat = replace(cArqConv, "~\":U, "/":U).
        display c-arq-fat with frame fPage4.
    end.

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
&Scoped-define SELF-NAME btOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOk wReport
ON CHOOSE OF btOk IN FRAME fpage0 /* Executar */
DO:
   
    RUN piExecute.

    
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
        when "1" then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes.
        end.
        when "2" then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no.
        end.
        when "3" then do:
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


/*--- L¢gica para inicializa‡Æo do programam ---*/

{report/mainblock.i}

  RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME fpage4:HANDLE).
 
 ASSIGN c-arq-saida:SCREEN-VALUE IN FRAME fpage4 = SESSION:TEMP-DIRECTORY + "Conciliacao.csv" .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDestroyInterface wReport 
PROCEDURE AfterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     
      ASSIGN c-arq-saida:SCREEN-VALUE IN FRAME fpage4 = SESSION:TEMP-DIRECTORY + "Conciliacao.csv" .
      RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeInitializeInterface wReport 
PROCEDURE BeforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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

define var r-tt-digita as rowid no-undo.

/* Valida para que o mˆs/ano seja imediatamente posterior ao £timo per¡odo executado */
/* IF  INPUT FRAME fpage4 rs-tipo = 2 THEN DO:                                                                              */
/*                                                                                                                          */
/*     run utp/ut-msgs.p (input "show", input 27100, input "Aten‡Æo! Execu‡Æo da Apura‡Æo de Benef¡cios" + "~~" +           */
/*                        "Nesta Op‡Æo, vocˆ ir  efetuar a apura‡Æo de benef¡cios oficialmente para os Canais. Confirma?"). */
/*     IF  RETURN-VALUE <> "YES" THEN                                                                                       */
/*         RETURN.                                                                                                          */
/* END.                                                                                                                     */


&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN                                     
/*** Relatorio ***/                                                                          
do on error undo, return error on stop  undo, return error:                                  
    {report/rpexa.i}                                                                         
                                                                                             
    if input frame fPage6 rsDestiny = 2 and                                                  
       input frame fPage6 rsExecution = 1 then do:                                           
        run utp/ut-vlarq.p (input input frame fPage6 cFile).                                 
                                                                                             
        if return-value = "NOK":U then do:                                                   
            run utp/ut-msgs.p (input "show", input 73, input "").                            
            apply "ENTRY":U to cFile in frame fPage6.                                        
            return error.                                                                    
        end.                                                                                 
    end.                                                                                     
                                                                                             
    create tt-param.                                                                         
    assign tt-param.usuario         = c-seg-usuario                                          
           tt-param.destino         = input frame fPage6 rsDestiny                           
           tt-param.data-exec       = today                                                  
           tt-param.hora-exec       = time                                                   
           tt-param.c-arq-bi        = INPUT FRAME fpage4 c-arq-bi
           tt-param.c-arq-fat       = INPUT FRAME fpage4 c-arq-fat
           tt-param.c-arq-benef     = INPUT FRAME fpage4 c-arq-benef
           tt-param.c-arq-saida     = INPUT FRAME fpage4 c-arq-saida
           tt-param.rs-opcao        = INPUT FRAME fpage4 rs-opcao
           tt-param.rs-apuracao     = INPUT FRAME fpage4 rs-apuracao.
           
                                                                                             
    if tt-param.destino = 1                                                                  
    then                                                                                     
        assign tt-param.arquivo = "".                                                        
    else if  tt-param.destino = 2                                                            
         then assign tt-param.arquivo = input frame fPage6 cFile.                            
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U. 
                                                                                             

    /* Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados            
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */               
                                                                                             
    /* Executar do programa RP.P que ir  criar o relat¢rio */                                
    {report/rpexb.i}                                                                         
                                                                                             
    SESSION:SET-WAIT-STATE("GENERAL":U).                                                     
                                                                                             
    {report/rprun.i esp/esb/esesb013rp.p}                                                    
                                                                                             
    {report/rpexc.i}                                                                         
                                                                                             
    SESSION:SET-WAIT-STATE("":U).                                                            
                                                                                             
    {report/rptrm.i}                                                                         
end.                                                                                         
&ENDIF                                                                                       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

