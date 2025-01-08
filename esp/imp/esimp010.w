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
{include/i-prgvrs.i ESIMP010 2.06.00.000}
/*------------------------------------------------------------------------
    File        : ESIMP010.W
    Purpose     : Importa‡Æo da Informa‡Æo do Modal do Embarque.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Maio de 2013
    Notes       : <none>
----------------------------------------------------------------------*/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESIMP010 MIM}
&ENDIF

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessors Definitions ---                                        */

&GLOBAL-DEFINE Program        ESIMP010
&GLOBAL-DEFINE Version        2.06.00.000
&GLOBAL-DEFINE VersionLayout  000

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Layout,Parƒmetro,Log

&GLOBAL-DEFINE PGLAY          YES
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          NO
&GLOBAL-DEFINE PGLOG          YES

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   edLayout btEdit
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   btInputFile
&GLOBAL-DEFINE page5Widgets   
&GLOBAL-DEFINE page6Widgets   
&GLOBAL-DEFINE page7Widgets   rsAll rsDestiny btConfigImprDest btDestinyFile rsExecution
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      text-entrada
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      
&GLOBAL-DEFINE page7Text      text-imprime text-destino text-modo
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    cInputFile 
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    
&GLOBAL-DEFINE page7Fields    cDestinyFile
&GLOBAL-DEFINE page8Fields    

/* Include Definitions ---                                              */

/* Defini‡Æo das Temp-tables tt-param, tt-digita e tt-raw-digita */
{esp/imp/esimp010.i}

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

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est 
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

DEFINE BUTTON btEdit 
     LABEL "Editar Layout" 
     SIZE 20 BY 1
     FONT 1.

DEFINE VARIABLE edLayout AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 82 BY 8.75
     FONT 2 NO-UNDO.

DEFINE BUTTON btInputFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cInputFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE text-entrada AS CHARACTER FORMAT "X(256)":U INITIAL "Arquivo de Entrada" 
      VIEW-AS TEXT 
     SIZE 14.86 BY .63
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.

DEFINE BUTTON btConfigImprDest 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btDestinyFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cDestinyFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 7.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-imprime AS CHARACTER FORMAT "X(256)":U INITIAL " Imprime" 
      VIEW-AS TEXT 
     SIZE 7.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL " Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsAll AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Rejeitados", 2
     SIZE 34 BY .79
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

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.

DEFINE RECTANGLE rect-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.

DEFINE RECTANGLE rect-rtf-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 3.21.


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

DEFINE FRAME fPage7
     rsAll AT ROW 2.25 COL 3.14 NO-LABEL
     rsDestiny AT ROW 4.33 COL 3.14 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btDestinyFile AT ROW 5.67 COL 43.14 HELP
          "Escolha do nome do arquivo"
     btConfigImprDest AT ROW 5.67 COL 43.14 HELP
          "Configura‡Æo da impressora"
     cDestinyFile AT ROW 5.75 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 7.96 COL 3.14 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-imprime AT ROW 1.46 COL 3.14 NO-LABEL
     text-destino AT ROW 3.58 COL 3.14 NO-LABEL
     text-modo AT ROW 7.21 COL 3.14 NO-LABEL
     rect-8 AT ROW 7.5 COL 2
     RECT-11 AT ROW 1.75 COL 2
     rect-rtf-2 AT ROW 3.88 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage1
     edLayout AT ROW 1.25 COL 1 NO-LABEL
     btEdit AT ROW 10.04 COL 1 HELP
          "Dispara a ImpressÆo do Layout"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage4
     cInputFile AT ROW 9.79 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btInputFile AT ROW 9.79 COL 43.14 HELP
          "Escolha do nome do arquivo"
     text-entrada AT ROW 8.75 COL 4.14 NO-LABEL
     RECT-12 AT ROW 9 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage7:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage1
                                                                        */
ASSIGN 
       edLayout:RETURN-INSERTED IN FRAME fPage1  = TRUE
       edLayout:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FILL-IN text-entrada IN FRAME fPage4
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-entrada:PRIVATE-DATA IN FRAME fPage4     = 
                "Arquivo de Entrada".

/* SETTINGS FOR FRAME fPage7
                                                                        */
/* SETTINGS FOR FILL-IN text-destino IN FRAME fPage7
   ALIGN-L                                                              */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage7     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-imprime IN FRAME fPage7
   ALIGN-L                                                              */
ASSIGN 
       text-imprime:PRIVATE-DATA IN FRAME fPage7     = 
                "Imprime".

/* SETTINGS FOR FILL-IN text-modo IN FRAME fPage7
   ALIGN-L                                                              */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage7     = 
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage7
/* Query rebuild information for FRAME fPage7
     _Query            is NOT OPENED
*/  /* FRAME fPage7 */
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


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME btConfigImprDest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImprDest wReport
ON CHOOSE OF btConfigImprDest IN FRAME fPage7
DO:
    {report/imimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDestinyFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDestinyFile wReport
ON CHOOSE OF btDestinyFile IN FRAME fPage7
DO:
    {report/imarq.i cDestinyFile fPage7}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btEdit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEdit wReport
ON CHOOSE OF btEdit IN FRAME fPage1 /* Editar Layout */
DO:
    {report/imedl.i}
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btInputFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInputFile wReport
ON CHOOSE OF btInputFile IN FRAME fPage4
DO:
/*     {report/imarq.i cInputFile fPage4} */

    DEFINE VARIABLE cConvFile AS CHARACTER   NO-UNDO.

    ASSIGN cConvFile = REPLACE(INPUT FRAME fPage4 cInputfile, "/":U, "~\":U).

    SYSTEM-DIALOG GET-FILE cConvFile
        FILTERS "CSV (separado por ponto e v¡rgula) (*.csv)":U "*.csv":U,
                "Todos os arquivos (*.*)":U "*.*":U
        DEFAULT-EXTENSION "csv":U
        INITIAL-DIR "spool":U
        USE-FILENAME
        UPDATE l-ok.

    IF l-ok THEN DO:
        ASSIGN cInputFile = REPLACE(cConvFile, "~\":U, "/":U).

        DISPLAY cInputFile
            WITH FRAME fPage4.
    END.
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


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage7
DO:
do  with frame fPage7:
    case self:screen-value:
        when "1":U then do:
            assign cDestinyFile:sensitive     = no
                   cDestinyFile:visible       = yes
                   btDestinyFile:visible      = no
                   btConfigImprDest:visible   = yes.
        end.
        when "2":U then do:
            assign cDestinyFile:sensitive     = yes
                   cDestinyFile:visible       = yes
                   btDestinyFile:visible      = yes
                   btConfigImprDest:visible   = no.
        end.
        when "3":U then do:
            assign cDestinyFile:sensitive     = no
                   cDestinyFile:visible       = no
                   btDestinyFile:visible      = no
                   btConfigImprDest:visible   = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage7
DO:
   {report/imrse.i}
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*Alterado 17/02/2005 - tech1007 - Foi criado essa procedure para que seja realizado a inicializa‡Æo
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

    &IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
    /*:T** Relatorio ***/
    DO ON ERROR UNDO, RETURN ERROR
       ON STOP  UNDO, RETURN ERROR:
        {report/rpexa.i}

        /*15/02/2005 - tech1007 - Teste alterado pois RTF nÆo ‚ mais op‡Æo de Destino*/
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

        /*:T Coloque aqui as valida‡äes da p gina de Digita‡Æo, lembrando que elas devem
           apresentar uma mensagem de erro cadastrada, posicionar nesta p gina e colocar
           o focus no campo com problemas */
        &IF DEFINED(PGDIG) <> 0 AND "{&PGDIG}":U = "YES":U &THEN
        /*BROWSE brDigita:SET-REPOSITIONED-ROW(BROWSE brDigita:DOWN, "ALWAYS":U).*/

        FOR EACH tt-digita NO-LOCK:
            ASSIGN r-tt-digita = ROWID(tt-digita).

            /*:T Valida‡Æo de duplicidade de registro na temp-table tt-digita */
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

            /*:T As demais valida‡äes devem ser feitas aqui */
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


        /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
           apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
           problemas e colocar o focus no campo com problemas */



        /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
           para o programa RP.P */

        CREATE tt-param.
        assign tt-param.usuario         = c-seg-usuario
               tt-param.destino         = INPUT FRAME fPage6 rsDestiny
               tt-param.data-exec       = TODAY
               tt-param.hora-exec       = TIME
               &IF DEFINED(PGCLA) <> 0 AND "{&PGCLA}":U = "YES":U &THEN
               tt-param.classifica      = INPUT FRAME fPage3 rsClassif
               tt-param.desc-classifica = ENTRY((tt-param.classifica - 1) * 2 + 1, rsClassif:RADIO-BUTTONS IN FRAME fPage3)
               &ENDIF
               &IF DEFINED(RTF) <> 0 AND "{&RTF}":U = "YES":U &THEN
               tt-param.modelo          = INPUT FRAME fPage6 cModelRTF
               tt-param.l-habilitaRtf   = INPUT FRAME fPage6 l-habilitaRtf
               &ENDIF
               .

        IF tt-param.destino = 1 THEN
            ASSIGN tt-param.arquivo = "":U.
        ELSE IF tt-param.destino = 2 THEN
            ASSIGN tt-param.arquivo = INPUT FRAME fPage6 cFile.
        ELSE
            ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.


        /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
           como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */



        /*:T Executar do programa RP.P que ir  criar o relat¢rio */
        {report/rpexb.i}

        IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN.

        {report/rprun.i xxp/xx9999rp.p}

        {report/rpexc.i}

        IF SESSION:SET-WAIT-STATE("":U) THEN.

        {report/rptrm.i}
    END.
    &ELSE
    /*:T** Importacao/Exportacao ***/
    DO ON ERROR UNDO, RETURN ERROR
       ON STOP  UNDO, RETURN ERROR:
        {report/rpexa.i}

        IF INPUT FRAME fPage7 rsDestiny   = 2 AND
           INPUT FRAME fPage7 rsExecution = 1 THEN DO:
            RUN utp/ut-vlarq.p (INPUT INPUT FRAME fPage7 cDestinyFile).

            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 73,
                                   INPUT "":U).

                APPLY "ENTRY":U TO cDestinyFile IN FRAME fPage7.

                RETURN ERROR.
            END.
        END.

        ASSIGN FILE-INFO:FILE-NAME = INPUT FRAME fPage4 cInputFile.

        IF FILE-INFO:PATHNAME             = ? AND
           INPUT FRAME fPage7 rsExecution = 1 THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 326,
                               INPUT cInputFile).

            APPLY "ENTRY":U TO cInputFile IN FRAME fPage4.

            RETURN ERROR.
        END.


        /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas
           devem apresentar uma mensagem de erro cadastrada, posicionar na p gina 
           com problemas e colocar o focus no campo com problemas */

        CREATE tt-param.
        assign tt-param.usuario     = c-seg-usuario
               tt-param.destino     = INPUT FRAME fPage7 rsDestiny
               tt-param.todos       = INPUT FRAME fPage7 rsAll
               tt-param.arq-entrada = REPLACE(INPUT FRAME fPage4 cInputFile, "~\":U, "/":U)
               tt-param.data-exec   = TODAY
               tt-param.hora-exec   = TIME.

        IF tt-param.destino = 1 THEN
            ASSIGN tt-param.arq-destino = "":U.
        ELSE IF tt-param.destino = 2 THEN
            ASSIGN tt-param.arq-destino = INPUT FRAME fPage7 cDestinyFile.
        ELSE
            ASSIGN tt-param.arq-destino = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.

        ASSIGN tt-param.arq-destino = REPLACE(tt-param.arq-destino, "~\":U, "/":U).


        /*:T Coloque aqui a l¢gica de grava‡Æo dos parƒmtros e sele‡Æo na temp-table
           tt-param */



        /*:T Executar do programa RP.P que ir  importar/exportar arquivo */
        {report/imexb.i}

        IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN.

        {report/imrun.i esp/imp/esimp010rp.p}

        {report/imexc.i}

        IF SESSION:SET-WAIT-STATE("":U) THEN.

        {report/imtrm.i tt-param.arq-destino tt-param.destino}
    END.
    &ENDIF

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

