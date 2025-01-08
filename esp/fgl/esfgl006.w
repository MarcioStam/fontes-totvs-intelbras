&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
{include/i-prgvrs.i esfgl006 2.00.00.001}  /*** 010002 ***/
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
&GLOBAL-DEFINE Program        esfgl006
&GLOBAL-DEFINE Version        2.00.00.001
&GLOBAL-DEFINE VersionLayout  2.00           

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   ParÉmetros, Impress∆o

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
&GLOBAL-DEFINE page4Fields    rs-tipo cb-mes-ini cb-ano-ini fi-tipo-rateio-ini fi-tipo-rateio-fim fi-estab-ini fi-estab-fim
&GLOBAL-DEFINE page6Fields    cFile 

DEF VAR adm-broker-hdl AS HANDLE NO-UNDO.

def new global shared var h-facelift as handle no-undo.

IF NOT VALID-HANDLE(h-facelift) THEN
  RUN btb/btb901zo.p PERSISTENT SET h-facelift.

/* Parameters Definitions ---                                           */

define temp-table tt-param no-undo
    FIELD destino            AS INTEGER
    FIELD arquivo            AS CHAR format "x(35)"
    FIELD usuario            AS CHAR format "x(12)"
    FIELD data-exec          AS DATE
    FIELD hora-exec          AS INTEGER
    FIELD fi-tipo-rateio-ini AS INTEGER
    FIELD fi-tipo-rateio-fim AS INTEGER
    FIELD mes-ini            AS INTEGER
    FIELD mes-fim            AS INTEGER
    FIELD ano-ini            AS INTEGER
    FIELD ano-fim            AS INTEGER
    FIELD fi-estab-ini       AS CHAR
    FIELD fi-estab-fim       AS CHAR
    FIELD tp-exec            AS INT.

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

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

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

DEFINE VARIABLE cb-ano-ini AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE cb-mes-ini AS CHARACTER FORMAT "X(256)":U INITIAL "01" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 5.57 BY 1 NO-UNDO.

DEFINE VARIABLE fi-estab-fim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-estab-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-tipo-rateio-fim AS INTEGER FORMAT ">>>>>9":U INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .79 NO-UNDO.

DEFINE VARIABLE fi-tipo-rateio-ini AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "Tipo Rateio" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .79 NO-UNDO.

DEFINE IMAGE IMAGE-17
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Simulaá∆o", 1,
"Contabilizaá∆o", 2
     SIZE 26 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73 BY 10.25.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 2.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 5.75.

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

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
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
     fi-tipo-rateio-ini AT ROW 4.25 COL 26 COLON-ALIGNED WIDGET-ID 66
     fi-tipo-rateio-fim AT ROW 4.25 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 80
     fi-estab-ini AT ROW 5.25 COL 26 COLON-ALIGNED WIDGET-ID 84
     fi-estab-fim AT ROW 5.25 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 82
     cb-mes-ini AT ROW 6.25 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     cb-ano-ini AT ROW 6.25 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     rs-tipo AT ROW 9.88 COL 31 NO-LABEL WIDGET-ID 94
     "Execuá∆o" VIEW-AS TEXT
          SIZE 7.86 BY .54 AT ROW 9 COL 39 WIDGET-ID 100
     "Faixa de Seleá∆o" VIEW-AS TEXT
          SIZE 12 BY .54 AT ROW 2.71 COL 37 WIDGET-ID 104
     "Competància:" VIEW-AS TEXT
          SIZE 9.5 BY .54 AT ROW 6.42 COL 18.43 WIDGET-ID 60
     RECT-13 AT ROW 2 COL 7 WIDGET-ID 14
     IMAGE-17 AT ROW 4.25 COL 46 WIDGET-ID 68
     IMAGE-18 AT ROW 4.25 COL 39 WIDGET-ID 70
     IMAGE-23 AT ROW 5.25 COL 46 WIDGET-ID 86
     IMAGE-24 AT ROW 5.25 COL 39 WIDGET-ID 88
     RECT-14 AT ROW 9.25 COL 12 WIDGET-ID 98
     RECT-15 AT ROW 3 COL 12 WIDGET-ID 102
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.5
         SIZE 85 BY 11.92
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     btConfigImpr AT ROW 3.58 COL 43.29 HELP
          "Configuraá∆o da impressora"
     btFile AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     cFile AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.75 COL 3 HELP
          "Modo de Execuá∆o" NO-LABEL
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
         TITLE              = "Conferància e Efetivaá∆o de Rateio"
         HEIGHT             = 16.33
         WIDTH              = 92
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
ON END-ERROR OF wReport /* Conferància e Efetivaá∆o de Rateio */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport /* Conferància e Efetivaá∆o de Rateio */
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


/*--- L¢gica para inicializaá∆o do programam ---*/

{report/mainblock.i}

  RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME fpage4:HANDLE).

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
      
  ASSIGN cb-mes-ini:SCREEN-VALUE in FRAME fpage4 = STRING(MONTH(TODAY), "99")
         cb-ano-ini:SCREEN-VALUE in FRAME fpage4 = STRING(YEAR(TODAY),"9999").
   
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
    
    DEF VAR c-data-ini AS CHAR NO-UNDO.
    DEF VAR c-data-fim AS CHAR NO-UNDO.
    DEF VAR c-comp-ini AS CHAR NO-UNDO.
    DEF VAR c-comp-fim AS CHAR NO-UNDO.
    DEF VAR de-tot-faturas AS DEC NO-UNDO.
    DEF VAR c-erro AS CHAR FORMAT "X(300)" NO-UNDO.
    
    ASSIGN c-comp-ini = string(int(cb-ano-ini:SCREEN-VALUE IN FRAME fpage4), "9999") + string(int(cb-mes-ini:SCREEN-VALUE IN FRAME fpage4), "99").

    ASSIGN c-data-ini = cb-ano-ini:SCREEN-VALUE IN FRAME fpage4 + cb-mes-ini:SCREEN-VALUE IN FRAME fpage4.

    IF  INT(fi-tipo-rateio-ini:SCREEN-VALUE IN FRAME fpage4) > INT(fi-tipo-rateio-fim:SCREEN-VALUE IN FRAME fpage4) THEN DO:
        run utp/ut-msgs.p (input "show", input 17006, input "Faixa de Tipo de Rateio Ç inv†lda" + "~~" +
                            "Tipo de Rateio final Ç menor que o inicial").
        RETURN NO-APPLY.
    END.

    IF  fi-estab-ini:SCREEN-VALUE IN FRAME fpage4 > fi-estab-fim:SCREEN-VALUE IN FRAME fpage4 THEN DO:
        run utp/ut-msgs.p (input "show", input 17006, input "Faixa de Estabelecimentos Ç inv†ldo" + "~~" +
                            "Estabelecimento final Ç menor que o inicial.").
        RETURN NO-APPLY.
    END.

        /* VALIDA PERMISS«O DE CONTABILIZAÄ«O*/
    FOR EACH int-rateio NO-LOCK
        WHERE int-rateio.tipo-rateio >= int(fi-tipo-rateio-ini:SCREEN-VALUE IN FRAME fpage4)
          AND int-rateio.tipo-rateio <= int(fi-tipo-rateio-fim:SCREEN-VALUE IN FRAME fpage4)
          AND int-rateio.competencia  = c-comp-ini 
          AND int-rateio.cod-estabel >= fi-estab-ini:SCREEN-VALUE IN FRAME fpage4
          AND int-rateio.cod-estabel <= fi-estab-fim:SCREEN-VALUE IN FRAME fpage4
          AND int-rateio.id-status    = 2: /*Liberado*/

          RUN esp/fgl/esfglapi001.p (INPUT ROWID(int-rateio),
                                     INPUT c-seg-usuario,
                                     INPUT "C",
                                     OUTPUT c-erro).
        IF  RETURN-VALUE <> "OK" THEN DO:
            run utp/ut-msgs.p (INPUT "show", 
                               INPUT 17006, 
                               INPUT c-erro + "~~" +
                               "Rateio............: " + STRING(int-rateio.tipo-rateio) + CHR(10) + 
                               "Competància..: " + SUBSTR(int-rateio.competencia,5,2) + "/" + SUBSTR(int-rateio.competencia,1,4) +  CHR(10) + 
                               "Estab..............: " + int-rateio.cod-estabel       ). 
            RETURN NO-APPLY.
        END.
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
    assign tt-param.usuario            = c-seg-usuario                                          
           tt-param.destino            = input frame fPage6 rsDestiny                           
           tt-param.data-exec          = today                                                  
           tt-param.hora-exec          = time                                                   
           tt-param.mes-ini            = int(cb-mes-ini:SCREEN-VALUE IN FRAME fpage4)
           tt-param.ano-ini            = int(cb-ano-ini:SCREEN-VALUE IN FRAME fpage4)
           tt-param.fi-tipo-rateio-ini = int(fi-tipo-rateio-ini:SCREEN-VALUE IN FRAME fpage4)
           tt-param.fi-tipo-rateio-fim = int(fi-tipo-rateio-fim:SCREEN-VALUE IN FRAME fpage4)
           tt-param.fi-estab-ini       = fi-estab-ini:SCREEN-VALUE IN FRAME fpage4
           tt-param.fi-estab-fim       = fi-estab-fim:SCREEN-VALUE IN FRAME fpage4
           tt-param.tp-exec            = INT(rs-tipo:SCREEN-VALUE IN FRAME fpage4).
                                                                                             
    if tt-param.destino = 1                                                                  
    then                                                                                     
        assign tt-param.arquivo = "".                                                        
    else if  tt-param.destino = 2                                                            
         then assign tt-param.arquivo = input frame fPage6 cFile.                            
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U. 
                                                                                             
    /* Executar do programa RP.P que ir† criar o relat¢rio */                                
    {report/rpexb.i}                                                                         
                                                                                             
    SESSION:SET-WAIT-STATE("GENERAL":U).                                                     
    
    {report/rprun.i esp/fgl/esfgl006rp.p}                                                    
                                                                                             
    {report/rpexc.i}                                                                         
                                                                                             
    SESSION:SET-WAIT-STATE("":U).                                                            
                                                                                             
    {report/rptrm.i}                                                                         
end.                                                                                         
&ENDIF                                                                                       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

