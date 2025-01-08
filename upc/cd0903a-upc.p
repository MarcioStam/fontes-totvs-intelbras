&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{include/i-prgvrs.i cd0903a-upc 2.06.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        cd0903a-upc
&GLOBAL-DEFINE Version        2.06.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    2
&GLOBAL-DEFINE FolderLabels   Layout,Parƒmetro

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   edLayout btEdit
&GLOBAL-DEFINE page2Widgets   textAcao rsTipo textAcao2 rsTipo2 textArquivo cArquivo btPesquisar

/* Parameters Definitions ---                                           */

/* Include Definitions ---                                              */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-item-fam-comerc NO-UNDO
    FIELD it-codigo  LIKE item.it-codigo
    FIELD fm-cod-com LIKE fam-comerc.fm-cod-com
    INDEX chPrimario IS PRIMARY
        it-codigo
    INDEX chFamilia
        fm-cod-com
        it-codigo.

DEFINE TEMP-TABLE ttItensUF-elim NO-UNDO
    FIELD it-codigo   AS CHAR FORMAT "X(16)"
    FIELD uf-orig     AS CHAR FORMAT "X(02)"
    FIELD uf-dest     AS CHAR FORMAT "X(02)"
    FIELD aliq-icms   AS DEC  FORMAT ">>>>9.99<<<"
    FIELD desc-item   AS CHAR FORMAT "X(100)"
    FIELD r-inf-compl AS ROWID
    FIELD r-Rowid     AS ROWID
    INDEX ch-ttItensUF IS PRIMARY UNIQUE it-codigo uf-orig uf-dest
    INDEX ch-UF uf-orig uf-dest.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE hAcomp     AS HANDLE      NO-UNDO.

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
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
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
     SIZE 20 BY 1.

DEFINE VARIABLE edLayout AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 82 BY 10.25
     FONT 2 NO-UNDO.

DEFINE BUTTON btPesquisar 
     IMAGE-UP FILE "image/im-sea.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sea.bmp":U
     LABEL "&Pesquisar" 
     SIZE 4 BY 1.

DEFINE VARIABLE cArquivo AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE textAcao AS CHARACTER FORMAT "X(256)":U INITIAL "Alterar os Itens da Planilha para:" 
      VIEW-AS TEXT 
     SIZE 22.86 BY .67 NO-UNDO.

DEFINE VARIABLE textAcao2 AS CHARACTER FORMAT "X(256)":U INITIAL "Considerar as valida‡äes?" 
      VIEW-AS TEXT 
     SIZE 22.86 BY .67 NO-UNDO.

DEFINE VARIABLE textArquivo AS CHARACTER FORMAT "X(256)":U INITIAL " Arquivo de Importa‡Æo:" 
      VIEW-AS TEXT 
     SIZE 20 BY .63 NO-UNDO.

DEFINE VARIABLE rsTipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Fatur vel", 1,
"NÆo Fatur vel", 2
     SIZE 28 BY .79 NO-UNDO.

DEFINE VARIABLE rsTipo2 AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Considera", 1,
"NÆo Considera", 2
     SIZE 28 BY .79 NO-UNDO.

DEFINE RECTANGLE rtAcao
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.75.

DEFINE RECTANGLE rtAcao2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.75.

DEFINE RECTANGLE rtArquivo
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2 HELP
          "Executar"
     btCancel AT ROW 16.75 COL 13 HELP
          "Fechar"
     btHelp2 AT ROW 16.75 COL 80 HELP
          "Ajuda"
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     edLayout AT ROW 1.25 COL 1 HELP
          "Layout" NO-LABEL
     btEdit AT ROW 11.54 COL 1 HELP
          "Dispara a ImpressÆo do Layout"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 11.67
         FONT 1.

DEFINE FRAME fPage2
     rsTipo2 AT ROW 4.08 COL 3.14 HELP
          "Considera Valida‡äes?" NO-LABEL
     rsTipo AT ROW 7.08 COL 3.14 HELP
          "Exporta‡Æo / Importa‡Æo" NO-LABEL
     cArquivo AT ROW 9.79 COL 3.14 HELP
          "Arquivo Exporta‡Æo / Importa‡Æo" NO-LABEL
     btPesquisar AT ROW 9.79 COL 43.14 HELP
          "Pesquisar Arquivo de Exporta‡Æo / Importa‡Æo"
     textAcao2 AT ROW 3.17 COL 3.14 NO-LABEL
     textAcao AT ROW 6.17 COL 3.14 NO-LABEL
     textArquivo AT ROW 8.71 COL 3.14 NO-LABEL
     rtArquivo AT ROW 9 COL 2
     rtAcao2 AT ROW 3.5 COL 2
     rtAcao AT ROW 6.5 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 11.65
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
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
ASSIGN 
       edLayout:RETURN-INSERTED IN FRAME fPage1  = TRUE
       edLayout:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN textAcao IN FRAME fPage2
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       textAcao:PRIVATE-DATA IN FRAME fPage2     = 
                "Alterar os Itens da Planilha para".

/* SETTINGS FOR FILL-IN textAcao2 IN FRAME fPage2
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       textAcao2:PRIVATE-DATA IN FRAME fPage2     = 
                "Considerar as valida‡äes?".

/* SETTINGS FOR FILL-IN textArquivo IN FRAME fPage2
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btEdit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEdit wWindow
ON CHOOSE OF btEdit IN FRAME fPage1 /* Editar Layout */
DO:
    RUN editarLayout.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
    RUN piExecutar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btPesquisar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPesquisar wWindow
ON CHOOSE OF btPesquisar IN FRAME fPage2 /* Pesquisar */
DO:
    DEFINE VARIABLE cConvFile AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE lOk       AS LOGICAL     NO-UNDO.

    ASSIGN cConvFile = REPLACE(INPUT FRAME fPage2 cArquivo, "/":U, "~\":U).


        SYSTEM-DIALOG GET-FILE cConvFile
            FILTERS "Arquivo Microsoft Excel (*.csv)":U "*.csv":U,
                    "Todos os arquivos (*.*)":U                 "*.*":U
            DEFAULT-EXTENSION "csv":U
            INITIAL-DIR "spool":U 
            USE-FILENAME
            UPDATE lOk.

    IF lOk THEN DO:
        ASSIGN cArquivo = REPLACE(cConvFile, "/":U, "~\":U).

        DISPLAY cArquivo
            WITH FRAME fPage2.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cArquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cArquivo wWindow
ON / OF cArquivo IN FRAME fPage2
DO:
    APPLY "~\":U TO cArquivo IN FRAME fPage2.

    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cArquivo wWindow
ON LEAVE OF cArquivo IN FRAME fPage2
DO:
    ASSIGN cArquivo = REPLACE(INPUT FRAME fPage2 cArquivo, "/":U, "~\":U).

    DISPLAY cArquivo
        WITH FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(hAcomp) THEN
        DELETE PROCEDURE hAcomp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN edLayout:FONT IN FRAME fPage1 = 2.

    ASSIGN edLayout = "+----------------------------------------------------------------------------+":U + CHR(10) +
                      "|                Layout do Arquivo de Importa‡Æo de Itens                    |":U + CHR(10) +
                      "|                que devera ser alterado o campo FATURAVEL                   |":U + CHR(10) +
                      "|----------------------------------------------------------------------------|":U + CHR(10) +
                      "|         Nome do Arquivo: A ser informado.                                  |":U + CHR(10) +
                      "|                 Formato: Arquivo Microsoft Excel (*.csv).                  |":U + CHR(10) +
                      "|----------------------------------------------------------------------------|":U + CHR(10) +
                      "|         Regra 1) Se a op‡Æo for Faturavel                                  |":U + CHR(10) +
                      "|                  Sera alterado os registros DO cd0147 e cd0903             |":U + CHR(10) +
                      "|         Regra 2) Se a op‡Æo for NÆo Faturavel                              |":U + CHR(10) +
                      "|               a) Se informado estabelecimento, sera alterado somente       |":U + CHR(10) +
                      "|                  registros DO cd0147                                       |":U + CHR(10) +
                      "|               b) Se NÇO informado estabelecimento,                         |":U + CHR(10) +
                      "|                  Sera alterado os registros DO cd0147 e cd0903             |":U + CHR(10) +
                      "|----------------------------------------------------------------------------|":U + CHR(10) +
                      "|  Coluna  |  Descri‡Æo                                                      |":U + CHR(10) +
                      "|----------+-----------------------------------------------------------------|":U + CHR(10) +
                      "|      01  |  Estabelecimento                                                |":U + CHR(10) +
                      "|      02  |  Item                                                           |":U + CHR(10) +
                      "|      03  |  Origem                                                         |":U + CHR(10) +
                      "|      04  |  Ft Conv Unidade Tribut vel                                     |":U + CHR(10) +
                      "|          |                                                                 |":U + CHR(10) +
                      "+----------------------------------------------------------------------------+":U.

    DISPLAY edLayout
        WITH FRAME fPage1.

    ASSIGN rsTipo   = 1
           rsTipo2  = 1
           cArquivo = "":U.

    FIND FIRST usuar_mestre
        WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.

    IF AVAILABLE usuar_mestre             AND
       usuar_mestre.nom_dir_spool <> "":U THEN DO:
        ASSIGN cArquivo = REPLACE(usuar_mestre.nom_dir_spool, "/":U, "~\":U).

        IF usuar_mestre.nom_subdir_spool <> "":U THEN DO:
            IF SUBSTRING(cArquivo, LENGTH(cArquivo), 1) <> "~\":U THEN
                ASSIGN cArquivo = cArquivo + "~\":U.

            ASSIGN cArquivo = cArquivo + usuar_mestre.nom_subdir_spool.

            FILE-INFO:FILE-NAME = cArquivo.

            IF FILE-INFO:FULL-PATHNAME           = ?    OR
               FILE-INFO:FULL-PATHNAME           = "":U OR
               INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0    THEN
                ASSIGN cArquivo = REPLACE(usuar_mestre.nom_dir_spool, "/":U, "~\":U).
        END.

        FILE-INFO:FILE-NAME = cArquivo.

        IF FILE-INFO:FULL-PATHNAME           = ?    OR
           FILE-INFO:FULL-PATHNAME           = "":U OR
           INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0    THEN
            ASSIGN cArquivo = "":U.
    END.

    IF cArquivo = "":U THEN DO:
        ASSIGN cArquivo = "C:\temp":U.

        FILE-INFO:FILE-NAME = cArquivo.

        IF FILE-INFO:FULL-PATHNAME           = ?    OR
           FILE-INFO:FULL-PATHNAME           = "":U OR
           INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0    THEN
            ASSIGN cArquivo = "":U.
    END.

    IF cArquivo = "":U THEN DO:
        ASSIGN cArquivo = "C:\tmp":U.

        FILE-INFO:FILE-NAME = cArquivo.

        IF FILE-INFO:FULL-PATHNAME           = ?    OR
           FILE-INFO:FULL-PATHNAME           = "":U OR
           INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0    THEN
            ASSIGN cArquivo = "":U.
    END.

    IF cArquivo = "":U THEN DO:
        ASSIGN cArquivo = REPLACE(SESSION:TEMP-DIRECTORY, "/":U, "~\":U).

        FILE-INFO:FILE-NAME = cArquivo.

        IF FILE-INFO:FULL-PATHNAME           = ?    OR
           FILE-INFO:FULL-PATHNAME           = "":U OR
           INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0    THEN
            ASSIGN cArquivo = "":U.
    END.

    ASSIGN cArquivo = REPLACE(cArquivo, "/":U, "~\":U).

    IF SUBSTRING(cArquivo, LENGTH(cArquivo), 1) <> "~\":U THEN
        ASSIGN cArquivo = cArquivo + "~\":U.

    ASSIGN cArquivo = cArquivo + LC(c-programa-mg97) + ".csv":U.

    DISPLAY rsTipo
            rsTipo2
            cArquivo
        WITH FRAME fPage2.

    APPLY "VALUE-CHANGED":U TO rsTipo  IN FRAME fPage2.
    APPLY "VALUE-CHANGED":U TO rsTipo2 IN FRAME fPage2.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE editarLayout wWindow 
PROCEDURE editarLayout :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-arq-temp AS CHARACTER   NO-UNDO.

    ASSIGN INPUT FRAME fPage1 edLayout.

    ASSIGN c-arq-temp = REPLACE(SESSION:TEMP-DIRECTORY, "/":U, "~\":U).

    IF SUBSTRING(c-arq-temp, LENGTH(c-arq-temp), 1) <> "~\":U THEN
        ASSIGN c-arq-temp = c-arq-temp + "~\":U.

    ASSIGN c-arq-temp = c-arq-temp + "import.txt":U.

    OUTPUT TO VALUE(c-arq-temp) CONVERT TARGET "iso8859-1":U.
    PUT UNFORMATTED edLayout SKIP.
    OUTPUT CLOSE.

    OS-COMMAND NO-WAIT VALUE(c-arq-temp) NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriarMensagem wWindow 
PROCEDURE piCriarMensagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pCodMensagem AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER pParametro   AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE iSequencia AS INTEGER     NO-UNDO.

    FIND LAST RowErrors NO-ERROR.

    ASSIGN iSequencia = IF AVAILABLE RowErrors THEN RowErrors.ErrorSequence + 1 ELSE 1.

    CREATE RowErrors.
    ASSIGN RowErrors.ErrorSequence   = iSequencia
           RowErrors.ErrorType       = "INTERNAL":U
           RowErrors.ErrorNumber     = pCodMensagem
           RowErrors.ErrorParameters = pParametro.

    RUN utp/ut-msgs.p (INPUT "CODTYPE":U,
                       INPUT pCodMensagem,
                       INPUT pParametro).

    IF RETURN-VALUE = "2":U THEN
        ASSIGN RowErrors.ErrorSubType = "WARNING":U.
    ELSE IF RETURN-VALUE = "3":U THEN
        ASSIGN RowErrors.ErrorSubType = "QUESTION":U.
    ELSE IF RETURN-VALUE = "4":U THEN
        ASSIGN RowErrors.ErrorSubType = "INFORMATION":U.
    ELSE
        ASSIGN RowErrors.ErrorSubType = "ERROR":U.

    RUN utp/ut-msgs.p (INPUT "MSG":U,
                       INPUT pCodMensagem,
                       INPUT pParametro).

    ASSIGN RowErrors.ErrorDescription = RETURN-VALUE.

    RUN utp/ut-msgs.p (INPUT "HELP":U,
                       INPUT pCodMensagem,
                       INPUT pParametro).

    ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecutar wWindow 
PROCEDURE piExecutar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-arq-temp  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-bodi538 AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-indice  AS CHARACTER   NO-UNDO.

    DO ON ERROR UNDO, RETURN ERROR
       ON STOP  UNDO, RETURN ERROR:
        IF INPUT FRAME fPage2 rsTipo <> 1 AND
           INPUT FRAME fPage2 rsTipo <> 2 THEN DO:
            IF VALID-HANDLE(hFolder) THEN
                RUN setFolder IN hFolder (INPUT 2).

            APPLY "ENTRY":U TO rsTipo IN FRAME fPage2.

            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Op‡Æo inv lida!":U +
                                     "~~":U +
                                     "Selecione uma das duas op‡äes: ~"Faturavel~" ou ~"NÆo Faturavel~"":U).

            RETURN ERROR.
        END.

        DEFINE VARIABLE c-linha AS CHARACTER   NO-UNDO.

        def var h-acomp      as handle no-undo.

        run utp/ut-acomp.p persistent set h-acomp.             
        RUN pi-inicializar in h-acomp (input "Imprimindo..."). 

        INPUT FROM VALUE(carquivo:SCREEN-VALUE IN FRAME fPage2) CONVERT SOURCE "iso8859-1".

        ASSIGN c-arq-temp = REPLACE(SESSION:TEMP-DIRECTORY, "/":U, "~\":U).
    
        IF SUBSTRING(c-arq-temp, LENGTH(c-arq-temp), 1) <> "~\":U THEN
            ASSIGN c-arq-temp = c-arq-temp + "~\":U.
    
        ASSIGN c-arq-temp = c-arq-temp + "saida.txt":U.
    
        OUTPUT TO VALUE(c-arq-temp) CONVERT TARGET "iso8859-1":U.
        
    
        

        REPEAT:

           IMPORT UNFORMATTED c-linha.

           RUN pi-acompanhar in h-acomp (input "Codigo "  + string(ENTRY(2, c-linha, ";") ) ).

           IF INPUT FRAME fPage2 rsTipo2 = 1 THEN DO: /* Considera Valida‡äes */

               FIND ITEM NO-LOCK 
                   WHERE ITEM.it-codigo =  string(ENTRY(2, c-linha, ";") ) NO-ERROR.
               IF NOT AVAIL ITEM THEN DO:
                    PUT "Item NÆo Encontrado "   string(ENTRY(2, c-linha, ";") ) SKIP.

                   NEXT.
               END.

               FIND FIRST item-mat EXCLUSIVE-LOCK 
                   WHERE item-mat.it-codigo = item.it-codigo NO-ERROR.

               IF ITEM.peso-bruto   = 0
               OR ITEM.peso-liquido = 0 THEN DO:
                   PUT "Item Com Peso NÆo Cadastrado "   string(ENTRY(2, c-linha, ";") ) SKIP.
                   NEXT.
               END.

               IF ITEM.altura       = 0
               OR ITEM.largura      = 0
               OR ITEM.comprim      = 0 THEN DO:
                   PUT "Item Com Medidas NÆo Cadastradas "   string(ENTRY(2, c-linha, ";") ) SKIP.
                   NEXT.
               END.

               IF ITEM.class-fiscal = "" THEN DO:
                   PUT "Item Com Classifica‡Æo Fiscal NÆo Cadastrada "   string(ENTRY(2, c-linha, ";") ) SKIP.
                   NEXT.
               END.

               IF ITEM.fm-cod-com = "" THEN DO:
                   PUT "Item Com Fam¡lia Comercial NÆo Cadastrada "   string(ENTRY(2, c-linha, ";") ) SKIP.
                   NEXT.
               END.

               IF  ITEM.it-codigo BEGINS "4"
               AND item-mat.cod-ean = "" THEN DO:
                   PUT "Item Com - C¢digo EAN ou C¢d GTIN (Trib.) NÆo Cadastrado "   string(ENTRY(2, c-linha, ";") ) SKIP.
                   NEXT.
               END.

               IF  ITEM.cod-dcr-item = "" 
               AND ITEM.codigo-orig  = 4
               AND STRING(ENTRY(1,c-linha, ";")) = "105" THEN DO:
                   PUT "Item Com DCR  NÆo Cadastrado "   string(ENTRY(2, c-linha, ";") ) SKIP.
                   NEXT.
               END.               

           END. /* IF INPUT FRAME fPage2 rsTipo = 1 THEN DO: */

           FIND ITEM EXCLUSIVE-LOCK 
               WHERE ITEM.it-codigo =  string(ENTRY(2, c-linha, ";") ) NO-ERROR.
           IF AVAIL ITEM THEN DO:

               IF string(ENTRY(1, c-linha, ";") ) = ""  THEN DO:
                   IF INPUT FRAME fPage2 rsTipo = 1 THEN
                       ASSIGN ITEM.ind-item-fat = YES.
                   ELSE
                       ASSIGN ITEM.ind-item-fat = NO.

                   ASSIGN ITEM.codigo-orig = int(ENTRY(3, c-linha, ";")).
                   OVERLAY(item.char-1,321,20) = ENTRY(4, c-linha, ";").

                   PUT "Item Alterado " ITEM.it-codigo " Faturavel " ITEM.ind-item-fat SKIP.
                   for each item-uni-estab
                       where item-uni-estab.it-codigo   = item.it-codigo exclusive-lock:
                         IF INPUT FRAME fPage2 rsTipo = 1 THEN
                             assign item-uni-estab.ind-item-fat         = YES.
                         ELSE
                             assign item-uni-estab.ind-item-fat         = NO.
                         PUT "Item do Estabelecimento Alterado " item-uni-estab.it-codigo " Estab : " item-uni-estab.cod-estabel " Faturavel " ITEM-uni-estab.ind-item-fat SKIP.
                   end.
               END.
               ELSE DO:
                   IF string(ENTRY(1, c-linha, ";") ) <> "" THEN DO:
                      IF INPUT FRAME fPage2 rsTipo = 1 THEN DO:
                           ASSIGN ITEM.ind-item-fat = YES.
                           PUT "Item Alterado " ITEM.it-codigo " Faturavel " ITEM.ind-item-fat SKIP.
                      END.

                      ASSIGN ITEM.codigo-orig = int(ENTRY(3, c-linha, ";")).
                      OVERLAY(item.char-1,321,20) = ENTRY(4, c-linha, ";").

                      FOR each item-uni-estab
                           where item-uni-estab.it-codigo   = item.it-codigo 
                            AND  item-uni-estab.cod-estabel = string(ENTRY(1, c-linha, ";") ) exclusive-lock:
                                IF INPUT FRAME fPage2 rsTipo = 1 THEN
                                    assign item-uni-estab.ind-item-fat         = YES.
                                ELSE
                                    assign item-uni-estab.ind-item-fat         = NO.
                                PUT "Item do Estabelecimento Alterado " item-uni-estab.it-codigo " Estab : " item-uni-estab.cod-estabel " Faturavel " ITEM-uni-estab.ind-item-fat SKIP.
                       end.
                    END.
               END.

               /*Atualiza cd0908*/
               IF NOT VALID-HANDLE(h-bodi538) THEN
                   RUN dibo/bodi538.p PERSISTENT SET h-bodi538.
            
               IF ITEM.codigo-orig = 1 
               OR ITEM.codigo-orig = 2 
               OR ITEM.codigo-orig = 3 
               OR ITEM.codigo-orig = 8 THEN DO:

                   FOR EACH unid-feder NO-LOCK
                      WHERE unid-feder.estado <> "EX"
                        AND unid-feder.estado <> "FL"
                        AND unid-feder.estado <> "KY":
            
                       IF unid-feder.estado <> "AM" THEN DO:
                           ASSIGN c-indice = "":U
                                  c-indice = (TRIM(ITEM.it-codigo) + CHR(2) +
                                              TRIM("AM") + CHR(2) +
                                              TRIM(unid-feder.estado)) NO-ERROR.
                       
                           FIND FIRST inf-compl NO-LOCK
                                WHERE inf-compl.cdn-identif = 5
                                  AND inf-compl.cod-indice  = c-indice NO-ERROR. /*Item + UF Orig + UF Dest*/
            
                           IF NOT AVAIL inf-compl THEN DO:
                               RUN pi-Inclui-Altera-ItensUF IN h-bodi538 (INPUT ITEM.it-codigo,
                                                                          INPUT "AM",
                                                                          INPUT unid-feder.estado,
                                                                          INPUT 4).        
                           END.
                       END.
                           
                       IF unid-feder.estado <> "MG" THEN DO:
                           ASSIGN c-indice = "":U
                                  c-indice = (TRIM(ITEM.it-codigo) + CHR(2) +
                                              TRIM("MG") + CHR(2) +
                                              TRIM(unid-feder.estado)) NO-ERROR.
                       
                           FIND FIRST inf-compl NO-LOCK
                                WHERE inf-compl.cdn-identif = 5
                                  AND inf-compl.cod-indice  = c-indice NO-ERROR. /*Item + UF Orig + UF Dest*/
            
                           IF NOT AVAIL inf-compl THEN DO:
                               RUN pi-Inclui-Altera-ItensUF IN h-bodi538 (INPUT ITEM.it-codigo,
                                                                          INPUT "MG",
                                                                          INPUT unid-feder.estado,
                                                                          INPUT 4).
                           END.
                       END.
            
                       IF unid-feder.estado <> "SC" THEN DO:
                           ASSIGN c-indice = "":U
                                  c-indice = (TRIM(ITEM.it-codigo) + CHR(2) +
                                              TRIM("SC") + CHR(2) +
                                              TRIM(unid-feder.estado)) NO-ERROR.
                       
                           FIND FIRST inf-compl NO-LOCK
                                WHERE inf-compl.cdn-identif = 5
                                  AND inf-compl.cod-indice  = c-indice NO-ERROR. /*Item + UF Orig + UF Dest*/
            
                           IF NOT AVAIL inf-compl THEN DO:
                               RUN pi-Inclui-Altera-ItensUF IN h-bodi538 (INPUT ITEM.it-codigo,
                                                                          INPUT "SC",
                                                                          INPUT unid-feder.estado,
                                                                          INPUT 4).
                           END.
                       END.
                   
                       IF unid-feder.estado <> "RS" THEN DO:
                           ASSIGN c-indice = "":U
                                  c-indice = (TRIM(ITEM.it-codigo) + CHR(2) +
                                              TRIM("RS") + CHR(2) +
                                              TRIM(unid-feder.estado)) NO-ERROR.
                       
                           FIND FIRST inf-compl NO-LOCK
                                WHERE inf-compl.cdn-identif = 5
                                  AND inf-compl.cod-indice  = c-indice NO-ERROR. /*Item + UF Orig + UF Dest*/
            
                           IF NOT AVAIL inf-compl THEN DO:
                               RUN pi-Inclui-Altera-ItensUF IN h-bodi538 (INPUT ITEM.it-codigo,
                                                                          INPUT "RS",
                                                                          INPUT unid-feder.estado,
                                                                          INPUT 4).
                           END.
                       END.
            
                   END.
               END.
               ELSE IF ITEM.codigo-orig = 0 
                    OR ITEM.codigo-orig = 4 
                    OR ITEM.codigo-orig = 5 
                    OR ITEM.codigo-orig = 6 
                    OR ITEM.codigo-orig = 7 THEN DO:
            
                   RUN pi-Elimina-ItensUF IN h-bodi538 (INPUT ITEM.it-codigo,
                                                        INPUT ITEM.it-codigo,
                                                        INPUT "",
                                                        INPUT "ZZZZ",
                                                        INPUT "",
                                                        INPUT "ZZZZ",
                                                        OUTPUT TABLE ttItensUF-elim).
               END.
            
               IF VALID-HANDLE(h-bodi538) THEN
                   DELETE PROCEDURE h-bodi538.

           END. /* IF AVAIL ITEM THEN DO: */

        END.
        RUN pi-finalizar in h-acomp.

        INPUT CLOSE.
        
        OUTPUT CLOSE.
        OS-COMMAND NO-WAIT VALUE(c-arq-temp) NO-ERROR.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

