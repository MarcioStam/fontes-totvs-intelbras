&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
{include/i-prgvrs.i esesb019 2.00.00.001}  /*** 010002 ***/
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
&GLOBAL-DEFINE Program        esesb019
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
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page4Fields    fi-ultimo cb-trimestre cb-ano rs-tipo fi-periodo
&GLOBAL-DEFINE page6Fields    cFile 

DEF VAR adm-broker-hdl AS HANDLE NO-UNDO.

def new global shared var h-facelift as handle no-undo.

IF NOT VALID-HANDLE(h-facelift) THEN
  RUN btb/btb901zo.p PERSISTENT SET h-facelift.

/* Parameters Definitions ---                                           */

define temp-table tt-param no-undo
    FIELD destino        AS INTEGER
    FIELD arquivo        AS CHAR format "x(35)"
    FIELD usuario        AS CHAR format "x(12)"
    FIELD data-exec      AS DATE
    FIELD hora-exec      AS INTEGER
    FIELD dt-periodo-ini AS DATE
    FIELD dt-periodo-fim AS DATE
    FIELD trimestre      AS CHAR
    FIELD ano            AS CHAR
    FIELD rs-tipo     AS INTEGER.

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


DEF VAR da-per-ini AS DATE NO-UNDO.
DEF VAR da-per-fim AS DATE NO-UNDO.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

/* Defini‡Æo da tt-central-filial */

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

DEFINE VARIABLE cb-ano AS CHARACTER FORMAT "X(256)":U 
     LABEL "de" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     LIST-ITEMS "2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030","2031","2032","2033","2034","2035","2036","2037","2038","2039","2040","2041","2042","2044","2045","2046","2047","2048","2049","2050" 
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE cb-trimestre AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "T1","T2","T3","T4" 
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE fi-periodo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 40 BY .88
     FGCOLOR 9 FONT 0 NO-UNDO.

DEFINE VARIABLE fi-ultimo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 15 BY .88
     FGCOLOR 9 FONT 0 NO-UNDO.

DEFINE VARIABLE rs-tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Pr‚via", 1,
"Oficial", 2
     SIZE 28 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 2.75.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 2.75.

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
     cb-trimestre AT ROW 5.04 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     cb-ano AT ROW 5.04 COL 16 COLON-ALIGNED WIDGET-ID 18
     rs-tipo AT ROW 9 COL 31 NO-LABEL WIDGET-ID 22
     fi-ultimo AT ROW 2.38 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     fi-periodo AT ROW 5.04 COL 26.43 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     "Encerrar Trimestre:" VIEW-AS TEXT
          SIZE 13 BY .54 AT ROW 3.75 COL 5 WIDGET-ID 52
     "éltimo Trimestre Encerrado:" VIEW-AS TEXT
          SIZE 20 BY .54 AT ROW 2.5 COL 4 WIDGET-ID 48
     "Tipo de Execu‡Æo:" VIEW-AS TEXT
          SIZE 13.43 BY .54 AT ROW 7.75 COL 5 WIDGET-ID 28
     RECT-13 AT ROW 4 COL 4 WIDGET-ID 14
     RECT-16 AT ROW 8 COL 4 WIDGET-ID 44
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.88
         SIZE 85 BY 12
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
         AT COL 3 ROW 2.88
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
         TITLE              = "Finaliza‡Æo de Contas Correntes e Migra‡Æo de Saldo Empenhado"
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
       fi-periodo:READ-ONLY IN FRAME fpage4        = TRUE.

ASSIGN 
       fi-ultimo:READ-ONLY IN FRAME fpage4        = TRUE.

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
ON END-ERROR OF wReport /* Finaliza‡Æo de Contas Correntes e Migra‡Æo de Saldo Empenhado */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport /* Finaliza‡Æo de Contas Correntes e Migra‡Æo de Saldo Empenhado */
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


&Scoped-define FRAME-NAME fpage4
&Scoped-define SELF-NAME cb-ano
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano wReport
ON VALUE-CHANGED OF cb-ano IN FRAME fpage4 /* de */
DO:
  RUN pi-define-trimestre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-trimestre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-trimestre wReport
ON VALUE-CHANGED OF cb-trimestre IN FRAME fpage4
DO:
  RUN pi-define-trimestre.
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

  APPLY "VALUE-CHANGED" TO cb-ano IN FRAME fpage4.

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
     
     RUN pi-default-trimestre.
     
     RUN pi-define-trimestre.

    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-default-trimestre wReport 
PROCEDURE pi-default-trimestre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR i-ano     AS INTEGER NO-UNDO.
    DEF VAR i-mes     AS INTEGER NO-UNDO.
    
    ASSIGN i-ano = integer(cb-ano:SCREEN-VALUE IN FRAME fpage4).

    /* BUSCAR éLTIMO PERÖODO ATIVO */
    FIND LAST int-cc-benef NO-LOCK
        WHERE int-cc-benef.id-status = 1 NO-ERROR.

    IF  NOT AVAIL int-cc-benef THEN
        RETURN "NOK".

    IF  MONTH(int-cc-benef.dt-periodo-ini) = 10 THEN
        ASSIGN cb-trimestre:SCREEN-VALUE IN FRAME fpage4 = "T4"                                            
                     cb-ano:SCREEN-VALUE IN FRAME fpage4 = STRING(YEAR(TODAY) - 1)                         
                  fi-ultimo:SCREEN-VALUE IN FRAME fpage4 = "T3 de " + STRING(YEAR(TODAY) - 1) + ".".       
    
    IF  MONTH(int-cc-benef.dt-periodo-ini) = 1 THEN
        ASSIGN cb-trimestre:SCREEN-VALUE IN FRAME fpage4 = "T1"
                     cb-ano:SCREEN-VALUE IN FRAME fpage4 = STRING(YEAR(TODAY))
                  fi-ultimo:SCREEN-VALUE IN FRAME fpage4 = "T4 de " + STRING(YEAR(TODAY) - 1) + ".".

    IF  MONTH(int-cc-benef.dt-periodo-ini) = 4 THEN
        ASSIGN cb-trimestre:SCREEN-VALUE IN FRAME fpage4 = "T2"
                     cb-ano:SCREEN-VALUE IN FRAME fpage4 = STRING(YEAR(TODAY))
                  fi-ultimo:SCREEN-VALUE IN FRAME fpage4 = "T1 de " + STRING(YEAR(TODAY) ) + ".".
    IF  MONTH(int-cc-benef.dt-periodo-ini) = 7 THEN
        ASSIGN cb-trimestre:SCREEN-VALUE IN FRAME fpage4 = "T3"                                                                                                                                                                                  
                     cb-ano:SCREEN-VALUE IN FRAME fpage4 = STRING(YEAR(TODAY))                                                                                                                                                                   
                  fi-ultimo:SCREEN-VALUE IN FRAME fpage4 = "T2 de " + STRING(YEAR(TODAY) ) + ".".                                                                                                                                                

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-define-trimestre wReport 
PROCEDURE pi-define-trimestre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR i-ano     AS INTEGER NO-UNDO.
    
    ASSIGN i-ano = integer(cb-ano:SCREEN-VALUE IN FRAME fpage4).

    CASE cb-trimestre:SCREEN-VALUE IN FRAME fpage4:
        WHEN "T1" THEN ASSIGN da-per-ini = DATE(01, 01, i-ano)
                              da-per-fim = DATE(03, 31, i-ano).
        WHEN "T2" THEN ASSIGN da-per-ini = DATE(04, 01, i-ano)
                              da-per-fim = DATE(06, 30, i-ano).  
        WHEN "T3" THEN ASSIGN da-per-ini = DATE(07, 01, i-ano)
                              da-per-fim = DATE(09, 30, i-ano).  
        WHEN "T4" THEN ASSIGN da-per-ini = DATE(10, 01, i-ano)
                              da-per-fim = DATE(12, 31, i-ano).  
    END CASE.

    ASSIGN fi-periodo:SCREEN-VALUE IN FRAME fpage4 = "Referente …s Contas Correntes de " + STRING(da-per-ini) + " at‚ " + STRING(da-per-fim) + "." .

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
/*     IF  INPUT FRAME fpage4 rs-tipo = 2                                                                    */
/*     THEN DO:                                                                                              */
/*                                                                                                           */
/*         IF  MONTH(TODAY) <> 1                                                                             */
/*         AND MONTH(TODAY) <> 4                                                                             */
/*         AND MONTH(TODAY) <> 7  THEN DO:                                                                   */
/*             run utp/ut-msgs.p (input "show", input 17006, input "Per¡odo selecionado ‚ inv ldo" + "~~" +  */
/*                                 "O processo s¢ pode ser executado no in¡cio de cada trimestre.").         */
/*             RETURN NO-APPLY.                                                                              */
/*                                                                                                           */
/*         END.                                                                                              */
/*     END.                                                                                                  */

    /* OFICIAL */
    IF  rs-tipo:SCREEN-VALUE IN FRAME fpage4 = "2" THEN DO:
        /*CONFIRMA A EXECU€ÇO OFICIAL*/
        run utp/ut-msgs.p (input "show", input 27100, input "Aten‡Æo! Finaliza‡Æo de Contas Corrente e Migra‡Æo de Empenho de benef¡cios" + "~~" +
                           "Nesta Op‡Æo, as contas correntes do Trimestre selecionado serÆo Finalizadas e as solicita‡äes abertas serÆo transferidas de trimestre, mantendo o valor empenhado para os canais. Confirma?").
        IF  RETURN-VALUE <> "YES" THEN 
            RETURN NO-APPLY.
    END.

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
           tt-param.dt-periodo-ini  = da-per-ini
           tt-param.dt-periodo-fim  = da-per-fim
           tt-param.rs-tipo         = INPUT FRAME fpage4 rs-tipo
           tt-param.trimestre       = INPUT FRAME fpage4 cb-trimestre
           tt-param.ano             = INPUT FRAME fpage4 cb-ano.
                                                                                             
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
                                                                                             
    {report/rprun.i esp/esb/esesb019rp.p}                                                    
                                                                                             
    {report/rpexc.i}                                                                         
                                                                                             
    SESSION:SET-WAIT-STATE("":U).                                                            
                                                                                             
    {report/rptrm.i}                                                                         
end.                                                                                         
&ENDIF                                                                                       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

