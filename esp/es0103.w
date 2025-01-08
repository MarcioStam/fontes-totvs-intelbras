&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ES0103 2.06.00.000}
/*------------------------------------------------------------------------
    File        : XX9999.W
    Purpose     : <none>
    Syntax      : <none>
    Description : <none>

    Author(s)   : <none>
    Created     : <none>
    Notes       : <none>
----------------------------------------------------------------------*/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessors Definitions ---                                        */

&GLOBAL-DEFINE Program        ES0103
&GLOBAL-DEFINE Version        2.00.00.000
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   ParÉmetro,Impress∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   
&GLOBAL-DEFINE page5Widgets   
&GLOBAL-DEFINE page6Widgets   rsDestiny btConfigImpr btFile rsExecution l-habilitaRtf btModelRtf
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo text-rtf text-ModelRtf
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    tg-emails c-emails ed-descricao
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile cModelRTF
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Include Definitions ---                                              */
{esp/es0018.i}

/* Definiá∆o das Temp-tables tt-param, tt-digita e tt-raw-digita */
define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo lΩgico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG
    /*Fim alteracao 15/02/2005*/
    FIELD tipo-data        AS INTEGER
    FIELD l-emails         AS LOG
    FIELD emails           AS CHAR.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE raw-param        AS RAW         NO-UNDO.
DEFINE VARIABLE l-ok             AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-arq-digita     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-terminal       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-rtf            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-layout     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-temp       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-modelo-default AS CHARACTER   NO-UNDO.

/* Stream Definitions ---                                               */

DEFINE STREAM s-imp.

/* Buffer Definitions ---                                               */

DEFINE BUFFER b-tt-digita FOR tt-digita.

/* Shared Definitions ---                                               */

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est†
  rodando no WebEnabler*/
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
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE ed-descricao AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-VERTICAL
     SIZE 74 BY 4.75 NO-UNDO.

DEFINE VARIABLE c-emails AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 74 BY 2.75.

DEFINE VARIABLE tg-emails AS LOGICAL INITIAL yes 
     LABEL "Envia E-mail" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btModelRtf 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE cModelRTF AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-ModelRtf AS CHARACTER FORMAT "X(256)":U INITIAL "Modelo:" 
      VIEW-AS TEXT 
     SIZE 6.86 BY .67 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL " Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-rtf AS CHARACTER FORMAT "X(256)":U INITIAL " Rich Text Format (RTF)" 
      VIEW-AS TEXT 
     SIZE 17.86 BY .67 NO-UNDO.

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

DEFINE RECTANGLE rect-rtf
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 3.21.

DEFINE VARIABLE l-habilitaRtf AS LOGICAL INITIAL no 
     LABEL "RTF" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.


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

DEFINE FRAME fPage4
     ed-descricao AT ROW 1.25 COL 6 NO-LABEL WIDGET-ID 20
     tg-emails AT ROW 7.71 COL 10.29 WIDGET-ID 2
     c-emails AT ROW 7.71 COL 21.14 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     "E-mail" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 6.46 COL 13 WIDGET-ID 12
     RECT-13 AT ROW 6.71 COL 6 WIDGET-ID 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 13
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configuraá∆o da impressora"
     l-habilitaRtf AT ROW 5.58 COL 3.14
     cModelRTF AT ROW 7.29 COL 3.14 HELP
          "Nome do arquivo de modelo" NO-LABEL
     btModelRtf AT ROW 7.29 COL 43 HELP
          "Escolha o arquivo de modelo"
     rsExecution AT ROW 9.5 COL 3.14 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 3.14 NO-LABEL
     text-rtf AT ROW 5 COL 3.14 NO-LABEL
     text-ModelRtf AT ROW 6.54 COL 3.14 NO-LABEL
     text-modo AT ROW 8.75 COL 3.14 NO-LABEL
     rect-rtf AT ROW 5.29 COL 2
     RECT-7 AT ROW 1.92 COL 2
     RECT-9 AT ROW 9 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 13
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window Template
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
ASSIGN FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR EDITOR ed-descricao IN FRAME fPage4
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       ed-descricao:READ-ONLY IN FRAME fPage4        = TRUE.

/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       btModelRtf:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       cModelRTF:HIDDEN IN FRAME fPage6           = TRUE.

/* SETTINGS FOR FILL-IN text-destino IN FRAME fPage6
   ALIGN-L                                                              */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-ModelRtf IN FRAME fPage6
   ALIGN-L                                                              */
ASSIGN 
       text-ModelRtf:HIDDEN IN FRAME fPage6           = TRUE
       text-ModelRtf:PRIVATE-DATA IN FRAME fPage6     = 
                "Modelo:".

/* SETTINGS FOR FILL-IN text-modo IN FRAME fPage6
   ALIGN-L                                                              */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execuá∆o".

/* SETTINGS FOR FILL-IN text-rtf IN FRAME fPage6
   ALIGN-L                                                              */
ASSIGN 
       text-rtf:HIDDEN IN FRAME fPage6           = TRUE
       text-rtf:PRIVATE-DATA IN FRAME fPage6     = 
                "Rich Text Format(RTF)".

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


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btModelRtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModelRtf wReport
ON CHOOSE OF btModelRtf IN FRAME fPage6
DO:
    DEFINE VARIABLE cFile AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-ok  AS LOGICAL     NO-UNDO.

    ASSIGN cModelRTF = REPLACE(INPUT FRAME {&FRAME-NAME} cModelRTF, "/", "~\").

    SYSTEM-DIALOG GET-FILE cFile
        FILTERS "Rich Text Format (*.rtf)":U "*.rtf":U,
                "Todos os arquivos (*.*)":U  "*.*":U
        DEFAULT-EXTENSION "rtf":U
        INITIAL-DIR "modelos":U
        MUST-EXIST
        USE-FILENAME
        UPDATE l-ok.

    IF l-ok THEN
        ASSIGN cModelRTF:SCREEN-VALUE IN FRAME {&FRAME-NAME} = REPLACE(cFile, "~\":U, "/":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME ed-descricao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ed-descricao wReport
ON RETURN OF ed-descricao IN FRAME fPage4
DO:
    DISP ed-descricao WITH FRAME fpage4.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME l-habilitaRtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-habilitaRtf wReport
ON VALUE-CHANGED OF l-habilitaRtf IN FRAME fPage6 /* RTF */
DO:
    &IF DEFINED(RTF) <> 0 AND "{&RTF}":U = "YES":U &THEN
    RUN pi-habilitaRtf.  
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage6
DO:
    DO WITH FRAME fPage6:
        CASE SELF:SCREEN-VALUE :
            WHEN "1":U THEN DO:
                ASSIGN cFile:SENSITIVE                            = NO
                       cFile:VISIBLE                              = YES
                       btFile:VISIBLE                             = NO
                       btConfigImpr:VISIBLE                       = YES
                       /*Alterado 15/02/2005 - tech1007 - Alterado para suportar adequadamente com a 
                         funcionalidade de RTF*/
                       &IF DEFINED(RTF) <> 0 AND "{&RTF}":U = "YES":U &THEN
                       l-habilitaRtf:SENSITIVE                    = NO
                       l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "NO":U
                       l-habilitaRtf                              = NO
                       &ENDIF
                       .
                       /*Fim alteracao 15/02/2005*/
            END.
            WHEN "2":U THEN DO:
                ASSIGN cFile:SENSITIVE         = YES
                       cFile:VISIBLE           = YES
                       btFile:VISIBLE          = YES
                       btConfigImpr:VISIBLE    = NO
                       &IF DEFINED(RTF) <> 0 AND "{&RTF}":U = "YES":U &THEN
                       l-habilitaRtf:SENSITIVE = YES
                       &ENDIF
                       .
            END.
            WHEN "3":U THEN DO:
                assign cFile:VISIBLE           = NO
                       cFile:SENSITIVE         = NO
                       btFile:VISIBLE          = NO
                       btConfigImpr:VISIBLE    = NO
                       &IF DEFINED(RTF) <> 0 AND "{&RTF}":U = "YES":U &THEN
                       l-habilitaRtf:SENSITIVE = YES
                       &ENDIF
                       .

                /*Alterado 15/02/2005 - tech1007 - Teste para funcionar corretamente no WebEnabler*/
                &IF DEFINED(RTF) <> 0 AND "{&RTF}":U = "YES":U &THEN
                IF VALID-HANDLE(hWenController) THEN DO:
                    ASSIGN l-habilitaRtf:SENSITIVE                    = NO
                           l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "NO":U
                           l-habilitaRtf                              = NO.
                END.
                &ENDIF
                /*Fim alteracao 15/02/2005*/
            END.
            /*Alterado 15/02/2005 - tech1007 - Condiá∆o removida pois RTF n∆o Ç mais um destino
            WHEN "4":U THEN DO:
                ASSIGN cFile:SENSITIVE       = NO
                       cFile:VISIBLE         = YES
                       btFile:VISIBLE        = NO
                       btConfigImpr:VISIBLE  = YES
                       text-ModelRtf:VISIBLE = YES
                       rect-rtf:VISIBLE      = YES
                       blModelRtf:VISIBLE    = YES.
            END.
            Fim alteracao 15/02/2005*/
        END CASE.
    END.

    &IF DEFINED(RTF) <> 0 AND "{&RTF}":U = "YES":U &THEN
    RUN pi-habilitaRtf.  
    &ENDIF
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME tg-emails
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-emails wReport
ON VALUE-CHANGED OF tg-emails IN FRAME fPage4 /* Envia E-mail */
DO:
    IF tg-emails:INPUT-VALUE IN FRAME fPage4 THEN
        ASSIGN c-emails:SENSITIVE IN FRAME fPage4 = YES.
    ELSE 
        ASSIGN c-emails:SENSITIVE IN FRAME fPage4 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{report/mainblock.i}

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

    RUN esp/es0018p.p (INPUT "ES0103", /* Nome do programa */
                       INPUT 1,         /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
    FOR EACH tt-prog-ponto:
        CASE tt-prog-ponto.sequencia:
            WHEN 0 THEN ASSIGN c-emails  = tt-prog-ponto.conteudo.
        END.
    END.

    ASSIGN ed-descricao = "Monitorando: " + CHR(10) +
                          " - Propath do banco" + CHR(10) +
                          " - Handle preso" + CHR(10).
                          
    DISP c-emails
         ed-descricao WITH FRAME fpage4.  

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

    /*:T** Relatorio ***/
    DO ON ERROR UNDO, RETURN ERROR
       ON STOP  UNDO, RETURN ERROR:
        {report/rpexa.i}

        /*15/02/2005 - tech1007 - Teste alterado pois RTF n∆o Ç mais opá∆o de Destino*/
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

        /*16/02/2005 - tech1007 - Teste alterado para validar o modelo informado quando for RTF*/
        &IF DEFINED(RTF) <> 0 AND "{&RTF}":U = "YES":U &THEN
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
        /*
        &IF DEFINED(PGDIG) <> 0 AND "{&PGDIG}":U = "YES":U &THEN
        /*BROWSE brDigita:SET-REPOSITIONED-ROW(BROWSE brDigita:DOWN, "ALWAYS":U).*/

        FOR EACH tt-digita NO-LOCK:
            ASSIGN r-tt-digita = ROWID(tt-digita).

            /*:T Validaá∆o de duplicidade de registro na temp-table tt-digita */
            FIND FIRST b-tt-digita
                WHERE b-tt-digita.ordem   = tt-digita.ordem
                  AND ROWID(b-tt-digita) <> ROWID(tt-digita) NO-LOCK NO-ERROR.

            IF AVAILABLE b-tt-digita THEN DO:
                REPOSITION brDigita TO ROWID ROWID(b-tt-digita).

                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 108,
                                   INPUT "":U).

                APPLY "ENTRY":U TO tt-digita.ordem IN BROWSE brDigita.

                RETURN ERROR.
            END.

            /*:T As demais validaá‰es devem ser feitas aqui */
            IF tt-digita.ordem <= 0 THEN DO:
                ASSIGN BROWSE brDigita:CURRENT-COLUMN = tt-digita.ordem:HANDLE IN BROWSE brDigita.

                REPOSITION brDigita TO ROWID r-tt-digita.

                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 99999,
                                   INPUT "":U).

                APPLY "ENTRY":U TO tt-digita.ordem IN BROWSE brDigita.

                RETURN ERROR.
            END.
        END.
        &ENDIF
        */

        /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
           apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
           problemas e colocar o focus no campo com problemas */



        /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
           para o programa RP.P */

        CREATE tt-param.
        assign tt-param.usuario         = c-seg-usuario
               tt-param.destino         = INPUT FRAME fPage6 rsDestiny
               tt-param.data-exec       = TODAY
               tt-param.hora-exec       = TIME
               /*&IF DEFINED(PGCLA) <> 0 AND "{&PGCLA}":U = "YES":U &THEN
               tt-param.classifica      = INPUT FRAME fPage3 rsClassif
               tt-param.desc-classifica = ENTRY((tt-param.classifica - 1) * 2 + 1, rsClassif:RADIO-BUTTONS IN FRAME fPage3)
               &ENDIF*/
               &IF DEFINED(RTF) <> 0 AND "{&RTF}":U = "YES":U &THEN
               tt-param.modelo          = INPUT FRAME fPage6 cModelRTF
               tt-param.l-habilitaRtf   = INPUT FRAME fPage6 l-habilitaRtf
               &ENDIF
               tt-param.l-emails        = INPUT FRAME fPage4 tg-emails
               tt-param.emails          = INPUT FRAME fPage4 c-emails.

        IF tt-param.destino = 1 THEN
            ASSIGN tt-param.arquivo = "":U.
        ELSE IF tt-param.destino = 2 THEN
            ASSIGN tt-param.arquivo = INPUT FRAME fPage6 cFile.
        ELSE
            ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.


        /*:T Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
           como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */



        /*:T Executar do programa RP.P que ir† criar o relat¢rio */
        {report/rpexb.i}

        IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN.

        {report/rprun.i esp\es0103rp.p}

        {report/rpexc.i}

        IF SESSION:SET-WAIT-STATE("":U) THEN.

        {report/rptrm.i}
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

