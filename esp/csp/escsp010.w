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
{include/i-prgvrs.i ESCSP010 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCSP010
&GLOBAL-DEFINE Version        2.04.00.000
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Parƒmetro,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk btCancel btHelp2
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page4Widgets   rsTpEstado btParam 
&GLOBAL-DEFINE page6Widgets   rsDestiny btConfigImpr btFile rsExecution tgParametro

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page4Text      text-estado
&GLOBAL-DEFINE page6Text      text-destino text-modo text-param

&GLOBAL-DEFINE page2Fields    cEstabel dtEmisIni dtEmisFin dtMovtoIni dtMovtoFin
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page6Fields    cFile

/* Include Definitions ---                                              */
{esp/csp/escsp010.i} /* Defini‡Æo da temp-table tt-param, tt-digita e tt-raw-digita */
{upc/btb910za-upc.i} /* Defini‡Æo da vari vel global contendo o estabelecimento do
                        usu rio - v_cod_estab_usuar */
{utp/ut-glob.i}

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE raw-param        AS RAW         NO-UNDO.

DEFINE VARIABLE l-ok             AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-arq-digita     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-terminal       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-rtf            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-layout     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-temp       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-modelo-default AS CHARACTER   NO-UNDO.

DEFINE STREAM s-imp.

/* Usado no Dialog 'Mais Parƒmetros' */
DEFINE VARIABLE deFaixaIni       AS DECIMAL FORMAT "->>9.99":U NO-UNDO.
DEFINE VARIABLE deFaixaFin       AS DECIMAL FORMAT "->>9.99":U NO-UNDO.
DEFINE VARIABLE lListaZero       AS LOGICAL                    NO-UNDO.
DEFINE VARIABLE dtEstrutura      AS DATE                       NO-UNDO.
DEFINE VARIABLE dtOperacao       AS DATE                       NO-UNDO.

/* Utilizado no zoom e leave do 'Estabelecimento' */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE      NO-UNDO.

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
     SIZE 10 BY 1 TOOLTIP "Fechar".

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1 TOOLTIP "Ajuda".

DEFINE BUTTON btOK 
     LABEL "&Executar" 
     SIZE 10 BY 1 TOOLTIP "Executar".

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE cDescEstabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE cEstabel AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 TOOLTIP "Estabelecimento"
     FONT 1 NO-UNDO.

DEFINE VARIABLE dtEmisFin AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 TOOLTIP "Data EmissÆo Final"
     FONT 1 NO-UNDO.

DEFINE VARIABLE dtEmisIni AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data EmissÆo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 TOOLTIP "Data EmissÆo Inicial"
     FONT 1 NO-UNDO.

DEFINE VARIABLE dtMovtoFin AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 TOOLTIP "Data Movimentos Final"
     FONT 1 NO-UNDO.

DEFINE VARIABLE dtMovtoIni AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data Movtos" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 TOOLTIP "Data Movimentos Inicial"
     FONT 1 NO-UNDO.

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

DEFINE BUTTON btParam 
     IMAGE-UP FILE "image/im-expan.bmp":U
     LABEL "Mais Parƒmetros..." 
     SIZE 9.72 BY 1.17 TOOLTIP "Mais Parƒmetros...".

DEFINE VARIABLE text-estado AS CHARACTER FORMAT "X(256)":U INITIAL " Tipo Estado" 
      VIEW-AS TEXT 
     SIZE 10.57 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsTpEstado AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todas", 1,
"Iniciada", 2,
"Terminada", 3,
"Finalizada", 4
     SIZE 13.29 BY 5.08 TOOLTIP "Tipo Estado" NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 16.29 BY 5.96.

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

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL " Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-param AS CHARACTER FORMAT "X(256)":U INITIAL " Parƒ³metros de ImpressÆo" 
      VIEW-AS TEXT 
     SIZE 19.86 BY .63
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

DEFINE VARIABLE tgParametro AS LOGICAL INITIAL yes 
     LABEL "Imprimir P gina de Par³ƒmetros?" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .83 TOOLTIP "Imprimir P gina de Par³ƒmetros?" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2 HELP
          "Executar"
     btCancel AT ROW 16.75 COL 13 HELP
          "Fechar"
     btHelp2 AT ROW 16.75 COL 80 HELP
          "Ajuda"
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     cFile AT ROW 3.58 COL 3 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configura‡Æo da impressora"
     rsExecution AT ROW 5.75 COL 3.29 HELP
          "Modo de Execu‡Æo" NO-LABEL
     tgParametro AT ROW 7.92 COL 3.43 HELP
          "Imprimir P gina de Par³ƒmetros?"
     text-destino AT ROW 1.63 COL 1.14 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.14 COLON-ALIGNED NO-LABEL
     text-param AT ROW 7.17 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2
     RECT-9 AT ROW 5.29 COL 2
     RECT-10 AT ROW 7.46 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage2
     cEstabel AT ROW 1.5 COL 15.86 HELP
          "Estabelecimento"
     cDescEstabel AT ROW 1.5 COL 33.29 COLON-ALIGNED HELP
          "Descri‡Æo Estabelecimento" NO-LABEL NO-TAB-STOP 
     dtEmisIni AT ROW 2.5 COL 17.72 HELP
          "Data EmissÆo Inicial"
     dtEmisFin AT ROW 2.5 COL 49.29 HELP
          "Data EmissÆo Final" NO-LABEL
     dtMovtoIni AT ROW 3.5 COL 18.29 HELP
          "Data Movimentos Inicial"
     dtMovtoFin AT ROW 3.5 COL 49.29 HELP
          "Data Movimentos Final" NO-LABEL
     IMAGE-1 AT ROW 2.5 COL 40.72
     IMAGE-2 AT ROW 2.5 COL 46.29
     IMAGE-3 AT ROW 3.5 COL 40.72
     IMAGE-4 AT ROW 3.5 COL 46.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage4
     rsTpEstado AT ROW 2.17 COL 4.14 HELP
          "Tipo Estado" NO-LABEL
     btParam AT ROW 9.54 COL 2.57 HELP
          "Mais Parƒmetros..."
     text-estado AT ROW 1.33 COL 3.43 NO-LABEL
     RECT-1 AT ROW 1.63 COL 2.57
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
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN cDescEstabel IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cEstabel IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN dtEmisFin IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN dtEmisIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN dtMovtoFin IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN dtMovtoIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FILL-IN text-estado IN FRAME fPage4
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-estado:PRIVATE-DATA IN FRAME fPage4     = 
                "Tipo Estado".

/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

ASSIGN 
       text-param:PRIVATE-DATA IN FRAME fPage6     = 
                "Parƒ³metros de ImpressÆo".

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
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParam wReport
ON CHOOSE OF btParam IN FRAME fPage4 /* Mais Parƒmetros... */
DO:
    RUN piMaisParametros.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME cEstabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cEstabel wReport
ON F5 OF cEstabel IN FRAME fPage2 /* Estabelecimento */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=cEstabel
                       &campozoom=cod-estabel
                       &campo2=cDescEstabel
                       &campozoom2=nome
                       &frame=fPage2}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cEstabel wReport
ON LEAVE OF cEstabel IN FRAME fPage2 /* Estabelecimento */
DO:
    {include/leave.i &tabela=estabelec
                     &atributo-ref=nome
                     &variavel-ref=cDescEstabel
                     &where="estabelec.cod-estabel = input frame fPage2 cEstabel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cEstabel wReport
ON MOUSE-SELECT-DBLCLICK OF cEstabel IN FRAME fPage2 /* Estabelecimento */
DO:
    APPLY "F5":U TO SELF.
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
        /*Alterado 15/02/2005 - tech1007 - Condi‡Æo removida pois RTF nÆo ‚ mais um destino
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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{report/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     Inicializar campos.
  Parameters:  NÆo h .
  Notes:       NÆo h .
------------------------------------------------------------------------------*/
    IF cEstabel:LOAD-MOUSE-POINTER ("image/lupa.cur":U) IN FRAME fPage2 THEN.

    &IF "{&ems_dbtype}":U = "MSS":U &THEN
        ASSIGN dtEmisIni  = 01/01/1800
               dtMovtoIni = 01/01/1800.
    &ELSE
        ASSIGN dtEmisIni  = 01/01/0001
               dtMovtoIni = 01/01/0001.
    &ENDIF

    ASSIGN cEstabel   = v_cod_estab_usuar
           dtEmisFin  = TODAY
           dtMovtoFin = TODAY
           rsTpEstado = 1
           deFaixaIni  = -999.99
           deFaixaFin  = 999.99
           lListaZero  = YES
           dtEstrutura = TODAY
           dtOperacao  = TODAY
           tgParametro = YES.

    DISPLAY cEstabel
            dtEmisIni
            dtEmisFin
            dtMovtoIni
            dtMovtoFin
        WITH FRAME fPage2.

    DISPLAY rsTpEstado
        WITH FRAME fPage4.

    DISPLAY tgParametro
        WITH FRAME fPage6.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     Executar o relat¢rio.
  Parameters:  NÆo h .
  Notes:       NÆo h .
------------------------------------------------------------------------------*/
    DO ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
        {report/rpexa.i}

        IF INPUT FRAME fPage6 rsDestiny   = 2 AND
           INPUT FRAME fPage6 rsExecution = 1 THEN DO:
            RUN utp/ut-vlarq.p (INPUT INPUT FRAME fPage6 cFile).

            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 73,
                                   INPUT "":U).

                APPLY "ENTRY":U TO cFile IN FRAME fPage6.
                RETURN ERROR.
            END.
        END.

        /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
           apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
           problemas e colocar o focus no campo com problemas */
        FIND FIRST estabelec
            WHERE estabelec.cod-estabel = INPUT FRAME fPage2 cEstabel NO-LOCK NO-ERROR.

        IF NOT AVAILABLE estabelec THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 56,
                               INPUT "Estabelecimento":U).

            APPLY "ENTRY":U TO cEstabel IN FRAME fPage2.
            RETURN ERROR.
        END.

        /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
           para o programa RP.P */
        CREATE tt-param.
        ASSIGN tt-param.usuario         = c-seg-usuario
               tt-param.destino         = INPUT FRAME fPage6 rsDestiny
               tt-param.data-exec       = TODAY
               tt-param.hora-exec       = TIME.

        IF tt-param.destino = 1 THEN
            ASSIGN tt-param.arquivo = "":U.
        ELSE DO:
            IF  tt-param.destino = 2 THEN
                ASSIGN tt-param.arquivo = INPUT FRAME fPage6 cFile.
            ELSE
                ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.
        END.

        /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
           como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
        ASSIGN tt-param.cod-estabel     = INPUT FRAME fPage2 cEstabel
               tt-param.dt-emissao-ini  = INPUT FRAME fPage2 dtEmisIni
               tt-param.dt-emissao-fin  = INPUT FRAME fPage2 dtEmisFin
               tt-param.dt-movto-ini    = INPUT FRAME fPage2 dtMovtoIni
               tt-param.dt-movto-fin    = INPUT FRAME fPage2 dtMovtoFin
               tt-param.ind-estado      = INPUT FRAME fPage4 rsTpEstado
               tt-param.variacao-ini    = deFaixaIni
               tt-param.variacao-fin    = deFaixaFin
               tt-param.lista-zero      = lListaZero
               tt-param.dt-corte-estrut = dtEstrutura
               tt-param.dt-corte-operac = dtOperacao
               tt-param.l-imp-param     = INPUT FRAME fPage6 tgParametro.
        
        /*:T Executar do programa RP.P que ir  criar o relat¢rio */
        {report/rpexb.i}

        SESSION:SET-WAIT-STATE("GENERAL":U).

        {report/rprun.i esp/csp/escsp010rp.p}

        {report/rpexc.i}

        SESSION:SET-WAIT-STATE("":U).

        {report/rptrm.i}
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMaisParametros wReport 
PROCEDURE piMaisParametros :
/*------------------------------------------------------------------------------
  Purpose:     Tela (Dialog) com demais parƒmetros.
  Parameters:  NÆo h .
  Notes:       NÆo h .
------------------------------------------------------------------------------*/
    DEFINE VARIABLE fiFaixaIni AS DECIMAL FORMAT "->>9.99":U INITIAL 0
        LABEL "Faixa Varia‡Æo":U
        VIEW-AS FILL-IN
        SIZE 9 BY .88 TOOLTIP "Faixa Varia‡Æo Inicial":U NO-UNDO.

    DEFINE IMAGE IMAGE-5
        FILENAME "image/im-fir.bmp":U
        SIZE 3 BY .88.

    DEFINE IMAGE IMAGE-6
        FILENAME "image/im-las.bmp":U
        SIZE 3 BY .88.

    DEFINE VARIABLE fiFaixaFin AS DECIMAL FORMAT "->>9.99":U INITIAL 0
        VIEW-AS FILL-IN
        SIZE 9 BY .88 TOOLTIP "Faixa Varia‡Æo Final":U NO-UNDO.

    DEFINE VARIABLE tgListaZero AS LOGICAL INITIAL YES
        LABEL "Lista Varia‡Æo Zero?":U
        VIEW-AS TOGGLE-BOX
        SIZE 22 BY .75 TOOLTIP "Lista Varia‡Æo Zero?":U NO-UNDO.

    DEFINE RECTANGLE RECT-1
        EDGE-PIXELS 2 GRAPHIC-EDGE NO-FILL
        SIZE 50.14 BY 2.71.

    DEFINE VARIABLE fiEstrutura AS DATE FORMAT "99/99/9999":U
        LABEL "Corte Estrutura":U
        VIEW-AS FILL-IN
        SIZE 15 BY .88 TOOLTIP "Data Corte Estrutura":U NO-UNDO.

    DEFINE VARIABLE fiOperacao AS DATE FORMAT "99/99/9999":U
        LABEL "Corte Opera‡äes":U
        VIEW-AS FILL-IN
        SIZE 15 BY .88 TOOLTIP "Data Corte Opera‡äes":U NO-UNDO.

    DEFINE RECTANGLE RECT-2
        EDGE-PIXELS 2 GRAPHIC-EDGE NO-FILL
        SIZE 50.14 BY 2.58.

    DEFINE BUTTON btOK2 AUTO-GO
        LABEL "&OK":U
        SIZE 10 BY 1 TOOLTIP "OK":U 
        BGCOLOR 8.

    DEFINE BUTTON btCancel2 AUTO-END-KEY
        LABEL "&Cancelar":U
        SIZE 10 BY 1 TOOLTIP "Cancelar":U 
        BGCOLOR 8.

    DEFINE BUTTON btAjuda2
        LABEL "&Ajuda":U
        SIZE 10 BY 1 TOOLTIP "Ajuda":U
        BGCOLOR 8.

    DEFINE RECTANGLE rtButton
        EDGE-PIXELS 2 GRAPHIC-EDGE
        SIZE 50.14 BY 1.42
        BGCOLOR 7.

    DEFINE FRAME D-Dialog
        fiFaixaIni  AT ROW 1.88 COL 15.14 COLON-ALIGNED HELP "Faixa Varia‡Æo Inicial":U
        IMAGE-5     AT ROW 1.88 COL 26.43
        IMAGE-6     AT ROW 1.88 COL 32
        fiFaixaFin  AT ROW 1.88 COL 33.14 COLON-ALIGNED HELP "Faixa Varia‡Æo Final":U NO-LABEL
        tgListaZero AT ROW 2.96 COL 17.14               HELP "Lista Varia‡Æo Zero?":U
        RECT-1      AT ROW 1.33 COL  1.57
        fiEstrutura AT ROW 4.58 COL 20.57 COLON-ALIGNED HELP "Data Corte Estrutura":U
        fiOperacao  AT ROW 5.67 COL 20.57 COLON-ALIGNED HELP "Data Corte Opera‡äes":U
        RECT-2      AT ROW 4.25 COL  1.57
        btOK2       AT ROW 7.42 COL  2.57               HELP "OK":U
        btCancel2   AT ROW 7.42 COL 13.57               HELP "Cancelar":U
        btAjuda2    AT ROW 7.42 COL 40.86               HELP "Ajuda":U
        rtButton    AT ROW 7.17 COL  1.57
        SPACE(0.55) SKIP(0.03)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
             SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE FONT 1
             TITLE "Mais Parƒmetros... - ":U + c-prg-obj + " - ":U + c-prg-vrs + " - ":U + v_nom_razao_social
             DEFAULT-BUTTON btOK2 CANCEL-BUTTON btCancel2.

    ON "CHOOSE":U OF btOK2 IN FRAME D-Dialog DO:
        ASSIGN deFaixaIni  = INPUT FRAME D-Dialog fiFaixaIni
               deFaixaFin  = INPUT FRAME D-Dialog fiFaixaFin
               lListaZero  = INPUT FRAME D-Dialog tgListaZero
               dtEstrutura = INPUT FRAME D-Dialog fiEstrutura
               dtOperacao  = INPUT FRAME D-Dialog fiOperacao.

        APPLY "GO":U TO FRAME D-Dialog.
    END.

    ON "CHOOSE":U OF btAjuda2 IN FRAME D-Dialog DO:
        {include/ajuda.i}
    END.

    ASSIGN fiFaixaIni  = deFaixaIni 
           fiFaixaFin  = deFaixaFin 
           tgListaZero = lListaZero 
           fiEstrutura = dtEstrutura
           fiOperacao  = dtOperacao.

    DISPLAY fiFaixaIni
            fiFaixaFin
            tgListaZero
            fiEstrutura
            fiOperacao
        WITH FRAME D-Dialog.

    ENABLE fiFaixaIni
           fiFaixaFin
           tgListaZero
           fiEstrutura
           fiOperacao
           btOK2
           btCancel2
           btAjuda2
        WITH FRAME D-Dialog.

    WAIT-FOR "GO":U OF FRAME D-Dialog.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

