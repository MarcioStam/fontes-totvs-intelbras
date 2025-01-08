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
{include/i-prgvrs.i ESUTP058 2.06.00.000}
/*------------------------------------------------------------------------
    File        : ESUTP058.W
    Purpose     : Exporta‡Æo do Centro de Custo e do Aprovador do Centro
                  de Custo.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Outubro de 2012
    Notes       : <none>
----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Local Preprocessors Definitions ---                                  */

&GLOBAL-DEFINE Program        ESUTP058
&GLOBAL-DEFINE Version        2.06.00.000
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Parƒmetro,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   lExpCentroCusto c-ccusto-ini c-ccusto-fim rs-c-ind-movto
&GLOBAL-DEFINE page5Widgets   
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution ~
                              tgParamImpr
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino ~
                              text-modo ~
                              text-param
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Include Definitions ---                                              */

{esp/utp/esutp058.i} /* Defini‡Æo das Temp-Tables */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE raw-param        AS RAW         NO-UNDO.
DEFINE VARIABLE l-ok             AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-terminal       AS CHARACTER   NO-UNDO.

&IF "{&VersionLayout}":U <> "":U &THEN
DEFINE VARIABLE c-arq-layout AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-temp   AS CHARACTER   NO-UNDO.
&ENDIF

&IF "{&RTF}":U = "YES":U &THEN
DEFINE VARIABLE c-rtf            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-modelo-default AS CHARACTER   NO-UNDO.
&ENDIF

&IF "{&PGDIG}":U = "YES":U &THEN
DEFINE BUFFER b-tt-digita FOR tt-digita.
DEFINE VARIABLE c-arq-digita AS CHARACTER   NO-UNDO.
&ENDIF

&IF "{&PGLOG}":U = "YES":U &THEN
DEFINE STREAM s-imp.
&ENDIF

/* Shared Variable Definitions ---                                      */

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est  rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE      NO-UNDO.

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

DEFINE VARIABLE c-ccusto-fim AS CHARACTER FORMAT "X(5)":U INITIAL "99999" 
     LABEL "At‚" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE c-ccusto-ini AS CHARACTER FORMAT "X(5)":U INITIAL "00000" 
     LABEL "De" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE rs-c-ind-movto AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "InclusÆo", "I",
"Altera‡Æo", "A",
"Elimina‡Æo", "E"
     SIZE 12 BY 2 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 3.75.

DEFINE VARIABLE lExpCentroCusto AS LOGICAL INITIAL yes 
     LABEL "Exporta Centro Custo" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY 1.08
     FONT 1 NO-UNDO.

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
     SIZE 7.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL " Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-param AS CHARACTER FORMAT "X(256)":U INITIAL " Parƒmetros de ImpressÆo" 
      VIEW-AS TEXT 
     SIZE 19 BY .63
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
     SIZE 27.86 BY 1.08
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

DEFINE VARIABLE tgParamImpr AS LOGICAL INITIAL yes 
     LABEL "Imprimir P gina de Parƒmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .92 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage4
     lExpCentroCusto AT ROW 1.5 COL 11
     rs-c-ind-movto AT ROW 2.5 COL 33 NO-LABEL WIDGET-ID 14
     c-ccusto-ini AT ROW 2.75 COL 9 COLON-ALIGNED WIDGET-ID 6
     c-ccusto-fim AT ROW 3.75 COL 9 COLON-ALIGNED WIDGET-ID 8
     "Integrar Todos Como:" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 1.75 COL 33 WIDGET-ID 12
     RECT-11 AT ROW 1.25 COL 2 WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.54 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.54 COL 43 HELP
          "Configura‡Æo da impressora"
     rsExecution AT ROW 5.75 COL 3 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 1.14 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.14 COLON-ALIGNED NO-LABEL
     tgParamImpr AT ROW 7.96 COL 3 HELP
          "Imprimir P gina de Parƒmetros?"
     text-param AT ROW 7.17 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2
     RECT-9 AT ROW 5.29 COL 2
     RECT-10 AT ROW 7.46 COL 2
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
ASSIGN FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage4
                                                                        */
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
                "Parƒmetros de ImpressÆo".

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

    ASSIGN lExpCentroCusto   = YES
           c-ccusto-ini      = "00000"
           c-ccusto-fim      = "99999"
           rs-c-ind-movto    = "I".

    DISPLAY lExpCentroCusto
            c-ccusto-ini
            c-ccusto-fim
            rs-c-ind-movto
        WITH FRAME fPage4.

    ASSIGN tgParamImpr = YES.

    DISPLAY tgParamImpr
        WITH FRAME fPage6.

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
        &IF "{&RTF}":U = "YES":U &THEN
        IF (INPUT FRAME fPage6 cModelRTF         = "":U AND
            INPUT FRAME fPage6 l-habilitaRtf)           OR
           (SEARCH(INPUT FRAME fPage6 cModelRTF) = ?    AND
            INPUT FRAME fPage6 rsExecution       = 1    AND
            INPUT FRAME fPage6 l-habilitaRtf)           THEN DO:
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

        &IF "{&PGDIG}":U = "YES":U &THEN
        /*BROWSE brDigita:SET-REPOSITIONED-ROW(BROWSE brDigita:DOWN, "ALWAYS":U).*/

        FOR EACH tt-digita:
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

        IF NOT INPUT FRAME fPage4 lExpCentroCusto THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Parƒmetros inv lidos":U +
                                     "~~":U +
                                     "Para a gera‡Æo do arquivo, deve ser selecionado algum parƒmetro":U).

            APPLY "ENTRY":U TO lExpCentroCusto IN FRAME fPage4.

            RETURN ERROR.
        END.

        /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
           para o programa RP.P */

        CREATE tt-param.
        ASSIGN tt-param.usuario         = c-seg-usuario
               tt-param.destino         = INPUT FRAME fPage6 rsDestiny
               tt-param.data-exec       = TODAY
               tt-param.hora-exec       = TIME
               &IF "{&PGCLA}":U = "YES":U &THEN
               tt-param.classifica      = INPUT FRAME fPage3 rsClassif
               tt-param.desc-classifica = ENTRY((tt-param.classifica - 1) * 2 + 1, rsClassif:RADIO-BUTTONS IN FRAME fPage3)
               &ENDIF
               &IF "{&RTF}":U = "YES":U &THEN
               tt-param.modelo          = INPUT FRAME fPage6 cModelRTF
               tt-param.l-habilitaRtf   = INPUT FRAME fPage6 l-habilitaRtf
               &ENDIF
               tt-param.l-param-impr    = INPUT FRAME fPage6 tgParamImpr.

        IF tt-param.destino = 1 THEN
            ASSIGN tt-param.arquivo = "":U.
        ELSE IF tt-param.destino = 2 THEN
            ASSIGN tt-param.arquivo = INPUT FRAME fPage6 cFile.
        ELSE
            ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.


        /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
           como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */

        ASSIGN tt-param.l-centro-custo  = INPUT FRAME fPage4 lExpCentroCusto
               tt-param.c-ind-movto     = INPUT FRAME fPage4 rs-c-ind-movto
               tt-param.c-ccusto-ini    = ""
               tt-param.c-ccusto-fim    = "".

        IF  tt-param.l-centro-custo = YES
        THEN
            ASSIGN tt-param.c-ccusto-ini = INPUT FRAME fPage4 c-ccusto-ini
                   tt-param.c-ccusto-fim = INPUT FRAME fPage4 c-ccusto-fim.

        /*:T Executar do programa RP.P que ir  criar o relat¢rio */

        {report/rpexb.i}

        SESSION:SET-WAIT-STATE("GENERAL":U).

        {report/rprun.i esp/utp/esutp058rp.p}

        {report/rpexc.i}

        SESSION:SET-WAIT-STATE("":U).

        {report/rptrm.i}
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

