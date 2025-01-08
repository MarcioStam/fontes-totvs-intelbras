&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esftp088 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esftp088 MFT}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

{cdp/cdcfgdis.i}

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esftp088
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Parƒmetro,ImpressÆo

&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGIMP          YES

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2


&GLOBAL-DEFINE page4Widgets   c-cod-estabel  ~
                              c-serie        ~
                              c-nr-nota-fis-ini c-nr-nota-fis-fim  ~
                              d-dt-inut ~
                              rs-reabre ~
                              cb-inutiliza-denega ~
                              c-motivo

&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution ~

     
&GLOBAL-DEFINE page4Text      c-texto-1 
&GLOBAL-DEFINE page6Text      text-destino text-modo

&GLOBAL-DEFINE page6Fields    cFile


/* Parameters Definitions ---                                           */

define temp-table tt-param no-undo
    field destino           as integer
    field arquivo           as char format "x(35)"
    field usuario           as char format "x(12)"
    field data-exec         as date
    field hora-exec         as integer
    field cod-estabel       like nota-fiscal.cod-estabel
    field serie             like nota-fiscal.serie
    field nr-nota-fis-ini   like nota-fiscal.nr-nota-fis
    field nr-nota-fis-fim   like nota-fiscal.nr-nota-fis
    field dt-inut           like nota-fiscal.dt-cancela
    field motivo            like nota-fiscal.desc-cancela
    field reabre-resumo     as logical
    .


/* {eqp/eq9999.i} */
/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita NO-UNDO
   field raw-digita      as raw.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.

def stream s-imp.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE cb-inutiliza-denega-parametro-ft2201 AS INTEGER NO-UNDO.
{utp/ut-glob.i}
DEFINE VARIABLE c-arquivo-usuar AS CHARACTER  NO-UNDO.

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
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE c-motivo AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 73 BY 4.

DEFINE VARIABLE c-cod-estabel LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-nota-fis-fim AS CHARACTER FORMAT "x(16)" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE c-nr-nota-fis-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Nr Nota Fiscal":R17 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE c-serie AS CHARACTER FORMAT "x(5)" 
     LABEL "S‚rie":R7 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-texto-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Motivo Inutiliza‡Æo" 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE d-dt-inut AS DATE FORMAT "99/99/9999" 
     LABEL "Data Inutiliza‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE cb-inutiliza-denega AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Inutiliza", 1,
"Denega", 2
     SIZE 33 BY 1.75
     FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 5.25.

DEFINE VARIABLE rs-reabre AS LOGICAL INITIAL no 
     LABEL "Reabre Resumo" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

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

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 2 
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
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage4
     cb-inutiliza-denega AT ROW 6.75 COL 23 NO-LABEL WIDGET-ID 2
     c-cod-estabel AT ROW 1.5 COL 21 COLON-ALIGNED HELP
          ""
     c-serie AT ROW 2.5 COL 21 COLON-ALIGNED
     c-nr-nota-fis-ini AT ROW 3.5 COL 21 COLON-ALIGNED
     c-nr-nota-fis-fim AT ROW 3.5 COL 45.72 COLON-ALIGNED NO-LABEL
     d-dt-inut AT ROW 4.5 COL 21 COLON-ALIGNED
     rs-reabre AT ROW 5.5 COL 23
     c-motivo AT ROW 9.5 COL 3 NO-LABEL
     c-texto-1 AT ROW 8.25 COL 2 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 3.5 COL 40.43
     IMAGE-2 AT ROW 3.5 COL 44.43
     RECT-11 AT ROW 8.75 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.25
         SIZE 76.86 BY 13.67
         FONT 1.

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
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 11.96
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
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

{report/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage4
   Custom                                                               */
/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME fPage4
   LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                          */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
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
   do  on error undo, leave:
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON F5 OF c-cod-estabel IN FRAME fPage4 /* Estab */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo="c-cod-estabel"
                       &campozoom="cod-estabel"
                       &frame="fPage4"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON LEAVE OF c-cod-estabel IN FRAME fPage4 /* Estab */
DO:
/*     &IF "{&BF_DIS_VERSAO_EMS}":U >= "2.062":U &THEN                       */
/*         ASSIGN c-eq-cod-estabel = INPUT FRAME fPage4 c-cod-estabel.       */
/*                                                                           */
/*         /* Engenharia Separacao MFT x Embarques */                        */
/*         {eqp/eq9999.i1}                                                   */
/*                                                                           */
/*         ASSIGN rs-reabre:CHECKED IN FRAME fPage4 = l-eq-log-reabre-resum. */
/*     &ENDIF                                                                */
    
    
    RETURN "OK":U.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME fPage4 /* Estab */
DO:
    APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-serie wReport
ON F5 OF c-serie IN FRAME fPage4 /* S‚rie */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z03in407.w"
                       &campo="c-serie"
                       &campozoom="serie"
                       &frame="fPage4"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-serie wReport
ON MOUSE-SELECT-DBLCLICK OF c-serie IN FRAME fPage4 /* S‚rie */
DO:
    APPLY 'F5':U TO SELF.
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


/*--- L¢gica para inicializa‡Æo do programa ---*/
{report/mainblock.i}

IF NOT CAN-FIND(FIRST funcao WHERE
                      funcao.cd-funcao = 'spp-nfe':U AND
                      funcao.ativo) THEN DO:

   RUN utp/ut-msgs.p (INPUT "show":U, INPUT 17006, INPUT "Fun‡Æo Nota Fiscal Eletr“nica nÆo est  ativa":U).
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN "OK":U.
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

 FIND FIRST para-fat NO-LOCK NO-ERROR.

 c-cod-estabel:load-mouse-pointer('image/lupa.cur':U) IN FRAME fPage4.
 c-serie:load-mouse-pointer('image/lupa.cur':U)       IN FRAME fPage4.
 
 ASSIGN rsDestiny:SCREEN-VALUE IN FRAME fPage6 = '3':U
        d-dt-inut:SCREEN-VALUE IN FRAME fPage4 = STRING(TODAY, '99/99/9999':U).



 FIND FIRST user-coml
      WHERE user-coml.usuario = c-seg-usuario NO-LOCK NO-ERROR.

 ASSIGN rs-reabre:SENSITIVE IN FRAME fPage4 = AVAIL user-coml AND 
                                              SUBSTR(user-coml.char-1,14,1) = "Y":U.
 
 APPLY "VALUE-CHANGED" TO rsDestiny IN FRAME fPage6. 

    
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

DEFINE VARIABLE l-reabre AS LOGICAL NO-UNDO.

DEF BUFFER b-nota-fiscal FOR nota-fiscal.
DEF BUFFER b-natur-oper  FOR natur-oper.

do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}

    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).

        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.

    IF NOT CAN-FIND(FIRST ser-estab  
                    WHERE ser-estab.serie       = INPUT FRAME fPage4 c-serie
                      AND ser-estab.cod-estabel = INPUT FRAME fPage4 c-cod-estabel) THEN DO:

       run utp/ut-msgs.p (input "show":U, input 2, input "S‚rie X Estabelecimento":U).
       apply "ENTRY":U to c-cod-estabel in frame fPage4.
       return error.
    END.

   
    IF NOT CAN-FIND(FIRST ser-estab  
                    WHERE ser-estab.serie       = INPUT FRAME fPage4 c-serie
                      AND ser-estab.cod-estabel = INPUT FRAME fPage4 c-cod-estabel
                      AND ser-estab.log-nf-eletro) THEN DO:
        run utp/ut-msgs.p (input "show":U, input 33439, input "":U).
        apply "ENTRY":U to c-cod-estabel in frame fPage4.
        return error.
    END.

    /***************** Antigo baca para mudar o status da nota para REJEITADA *******************/
    DO TRANS:
        FOR EACH nota-fiscal EXCLUSIVE-LOCK
            WHERE nota-fiscal.cod-estabel   = INPUT FRAME fPage4 c-cod-estabel
              AND nota-fiscal.serie         = INPUT FRAME fPage4 c-serie
              AND nota-fiscal.nr-nota-fis  >= INPUT FRAME fPage4 c-nr-nota-fis-ini
              AND nota-fiscal.nr-nota-fis  <= INPUT FRAME fPage4 c-nr-nota-fis-fim :
    
             IF  nota-fiscal.idi-sit-nf-eletro <> 1 AND
                 nota-fiscal.idi-sit-nf-eletro <> 11 AND  
                 nota-fiscal.idi-sit-nf-eletro <> 5 THEN DO:
    
                 run utp/ut-msgs.p (input "show":U, input 99999, "Status da Nota nao ‚ NF-e Gerada nao pode ser alterado o status"). 
                 return error.
             END.
             ELSE DO:
                ASSIGN nota-fiscal.idi-sit-nf-eletro = 5
                       nota-fiscal.ind-sit-nota = 2. 
             END.
        END.
    END.
    /************************************** fim baca *******************************************/

    /* Valida modelo da NF-e */
    FOR FIRST nota-fiscal  
        WHERE nota-fiscal.serie        = INPUT FRAME fPage4 c-serie
          AND nota-fiscal.cod-estabel  = INPUT FRAME fPage4 c-cod-estabel
          AND nota-fiscal.nr-nota-fis >= INPUT FRAME fPage4 c-nr-nota-fis-ini
          AND nota-fiscal.nr-nota-fis <= INPUT FRAME fPage4 c-nr-nota-fis-fim NO-LOCK,
        FIRST natur-oper WHERE
              natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK:

       FOR EACH b-nota-fiscal  
          WHERE b-nota-fiscal.serie        = INPUT FRAME fPage4 c-serie
            AND b-nota-fiscal.cod-estabel  = INPUT FRAME fPage4 c-cod-estabel
            AND b-nota-fiscal.nr-nota-fis >= INPUT FRAME fPage4 c-nr-nota-fis-ini
            AND b-nota-fiscal.nr-nota-fis <= INPUT FRAME fPage4 c-nr-nota-fis-fim NO-LOCK,
          FIRST b-natur-oper WHERE
                b-natur-oper.nat-operacao = b-nota-fiscal.nat-operacao AND
                b-natur-oper.cod-model-nf-eletro <> natur-oper.cod-model-nf-eletro
           NO-LOCK:
           
           run utp/ut-msgs.p (input "show":U, input 33440, input ""). 
           apply "ENTRY":U to c-nr-nota-fis-ini in frame fPage4.
           return error.
       END.
    END.

    FOR FIRST param-nf-estab NO-LOCK
        WHERE param-nf-estab.cod-estabel = INPUT FRAME fPage4 c-cod-estabel: END.

    /* Somente notas com situacao = Uso Autorizado ou Rejeitada podem ser inutilizadas */

    FOR FIRST nota-fiscal  
        WHERE nota-fiscal.serie        = INPUT FRAME fPage4 c-serie
          AND nota-fiscal.cod-estabel  = INPUT FRAME fPage4 c-cod-estabel
          AND nota-fiscal.nr-nota-fis >= INPUT FRAME fPage4 c-nr-nota-fis-ini
          AND nota-fiscal.nr-nota-fis <= INPUT FRAME fPage4 c-nr-nota-fis-fim
          AND nota-fiscal.idi-sit-nf-eletro <> 1 
          AND nota-fiscal.idi-sit-nf-eletro <> 5
          AND (NOT AVAIL param-nf-estab 
               OR (AVAIL param-nf-estab AND param-nf-estab.idi-tip-emis-nf-eletro = 1))
          NO-LOCK:
 
       run utp/ut-msgs.p (input "show":U, input 33441, input string(nota-fiscal.nr-nota-fis)). 
       apply "ENTRY":U to c-nr-nota-fis-ini in frame fPage4.
       return error.
    END.

   
    /* Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    IF  rs-reabre:SENSITIVE IN FRAME fPage4 THEN
        ASSIGN l-reabre = INPUT FRAME fPage4 rs-reabre.


    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.cod-estabel     = INPUT FRAME fPage4 c-cod-estabel
           tt-param.serie           = INPUT FRAME fPage4 c-serie
           tt-param.nr-nota-fis-ini = INPUT FRAME fPage4 c-nr-nota-fis-ini
           tt-param.nr-nota-fis-fim = INPUT FRAME fPage4 c-nr-nota-fis-fim
           tt-param.dt-inut         = INPUT FRAME fPage4 d-dt-inut
           tt-param.motivo          = INPUT FRAME fPage4 c-motivo
           tt-param.reabre-resumo   = l-reabre
           .

    ASSIGN cb-inutiliza-denega-parametro-ft2201 = INT(INPUT FRAME fPage4 cb-inutiliza-denega).

    if tt-param.destino = 1 
    then assign tt-param.arquivo = "".
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".

     
    /* Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */

    /* Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}

    SESSION:SET-WAIT-STATE("general":U).

    {report/rprun.i ftp/ft2201rp.p}

    {report/rpexc.i}

    SESSION:SET-WAIT-STATE("":U).

    {report/rptrm.i}
end.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

