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

{include/i-prgvrs.i cd0356-upca 2.06.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        cd0356-upca
&GLOBAL-DEFINE Version        2.06.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    2
&GLOBAL-DEFINE FolderLabels   Layout,Parƒmetro

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   edLayout btEdit
&GLOBAL-DEFINE page2Widgets   textArquivo cArquivo btPesquisar

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
     SIZE 63.86 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE textArquivo AS CHARACTER FORMAT "X(256)":U INITIAL " Arquivo de Importa‡Æo:" 
      VIEW-AS TEXT 
     SIZE 20 BY .63 NO-UNDO.

DEFINE RECTANGLE rtArquivo
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 2.


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
     btPesquisar AT ROW 6.25 COL 77 HELP
          "Pesquisar Arquivo de Exporta‡Æo / Importa‡Æo"
     cArquivo AT ROW 6.33 COL 12.14 HELP
          "Arquivo Exporta‡Æo / Importa‡Æo" NO-LABEL
     textArquivo AT ROW 5.25 COL 12.14 NO-LABEL
     rtArquivo AT ROW 5.54 COL 11
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
                      "|                Layout do Arquivo de Importa‡Æo de C¢d Enq.IPI              |":U + CHR(10) +
                      "|----------------------------------------------------------------------------|":U + CHR(10) +
                      "|         Nome do Arquivo: A ser informado.                                  |":U + CHR(10) +
                      "|                 Formato: Arquivo Microsoft Excel (*.csv).                  |":U + CHR(10) +
                      "|                 Obs.Os campos do tipo caracter utilizam o parƒmetro        |":U + CHR(10) +
                      "|                     gen‚rico asterisco Ë*Ì e os campos num‚ricos utilizam  |":U + CHR(10) +
                      "|                     o parƒmetro Ë0Ì para todos.                            |":U + CHR(10) +
                      "|----------------------------------------------------------------------------|":U + CHR(10) +
                      "|  Coluna  |  Descri‡Æo                                                      |":U + CHR(10) +
                      "|----------+-----------------------------------------------------------------|":U + CHR(10) +
                      "|      01  |  Aliquota                                                       |":U + CHR(10) +
                      "|      02  |  Descri‡Æo                                                      |":U + CHR(10) +
                      "|      03  |  E/S - Entrada ou Saida                                         |":U + CHR(10) +
                      "|      04  |  Data Inic Validade                                             |":U + CHR(10) +
                      "|      05  |  Estabelecimento                                                |":U + CHR(10) +
                      "|      06  |  Natureza de Opera‡Æo                                           |":U + CHR(10) +
                      "|      07  |  Classifica‡Æo Fiscal                                           |":U + CHR(10) +
                      "|      08  |  Codigo do Item                                                 |":U + CHR(10) +
                      "|      09  |  UF Cliente / Fornecedor                                        |":U + CHR(10) +
                      "|      10  |  C¢digo Emitente                                                |":U + CHR(10) +
                      "|      11  |  % Combate Pobreza                                              |":U + CHR(10) +
                      "|      12  |  Aliquota Interna UF Dest.                                      |":U + CHR(10) +
                      "+----------------------------------------------------------------------------+":U.

    DISPLAY edLayout
        WITH FRAME fPage1.

    ASSIGN cArquivo = "":U.

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

    DISPLAY cArquivo
        WITH FRAME fPage2.

    
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
    DEFINE VARIABLE c-arq-temp      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-idi-tip-docto AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-cont          AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-grupoEmit     AS INTEGER NO-UNDO.

    DO ON ERROR UNDO, RETURN ERROR
       ON STOP  UNDO, RETURN ERROR:
/*         IF INPUT FRAME fPage2 rsTipo <> 1 AND                                                                */
/*            INPUT FRAME fPage2 rsTipo <> 2 THEN DO:                                                           */
/*             IF VALID-HANDLE(hFolder) THEN                                                                    */
/*                 RUN setFolder IN hFolder (INPUT 2).                                                          */
/*                                                                                                              */
/*             APPLY "ENTRY":U TO rsTipo IN FRAME fPage2.                                                       */
/*                                                                                                              */
/*             RUN utp/ut-msgs.p (INPUT "SHOW":U,                                                               */
/*                                INPUT 17006,                                                                  */
/*                                INPUT "Op‡Æo inv lida!":U +                                                   */
/*                                      "~~":U +                                                                */
/*                                      "Selecione uma das duas op‡äes: ~"Faturavel~" ou ~"NÆo Faturavel~"":U). */
/*                                                                                                              */
/*             RETURN ERROR.                                                                                    */
/*         END.                                                                                                 */

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
        
        ASSIGN i-cont       = 0
               i-grupoEmit  = 00.
        

        REPEAT:

           IMPORT UNFORMATTED c-linha.
           ASSIGN i-cont = i-cont + 1.

           RUN pi-acompanhar in h-acomp (input "Codigo "  + string(ENTRY(2, c-linha, ";") ) ).

     
               IF string(ENTRY(3, c-linha, ";") ) <> "E" AND
                  string(ENTRY(3, c-linha, ";") ) <> "S" THEN DO:
                   PUT i-cont " Segunda coluna devera ter a informacao E ou S para Entrada ou Saida , e foi informado "   string(ENTRY(3, c-linha, ";") ) SKIP.
                  NEXT.
               END.
               IF string(ENTRY(5, c-linha, ";") )  <> "*" THEN DO:
                   FIND estabelec
                       WHERE estabelec.cod-estabel  = string(ENTRY(5, c-linha, ";") )  
                       NO-LOCK NO-ERROR.
                   IF NOT AVAIL estabelec THEN DO:
                       PUT i-cont " Estabelecimento NÆo Cadastrado "   string(ENTRY(5, c-linha, ";") ) SKIP.
                       NEXT.
                   END.
               END.
               IF string(ENTRY(6, c-linha, ";") )  <> "*" THEN DO:
                   FIND natur-oper
                       WHERE natur-oper.nat-operacao = string(ENTRY(6, c-linha, ";") )  
                       NO-LOCK NO-ERROR.
                   IF NOT AVAIL natur-oper THEN DO:
                       PUT i-cont " Natureza de Opera‡Æo NÆo Cadastrada "   string(ENTRY(6, c-linha, ";") ) SKIP.
                       NEXT.
                   END.
               END.

               IF string(ENTRY(7, c-linha, ";") )  <> "*" THEN DO:
                   FIND classif-fisc
                       WHERE classif-fisc.class-fiscal = string(ENTRY(7, c-linha, ";") )  
                       NO-LOCK NO-ERROR.
                   IF NOT AVAIL classif-fisc THEN DO:
                       PUT i-cont " Classifica‡Æo Fiscal NÆo Cadastrada "   string(ENTRY(7, c-linha, ";") ) SKIP.
                       NEXT.
                   END.
               END.


               IF string(ENTRY(8, c-linha, ";") )  <> "*" THEN DO:
                   FIND ITEM NO-LOCK 
                       WHERE ITEM.it-codigo =  string(ENTRY(8, c-linha, ";") ) NO-ERROR.
                   IF NOT AVAIL ITEM THEN DO:
                        PUT i-cont " Item NÆo Encontrado "   string(ENTRY(8, c-linha, ";") ) SKIP.

                       NEXT.
                   END.
               END.



               IF int(string(ENTRY(10, c-linha, ";") ))  <> 0 THEN DO:
                   FIND emitente NO-LOCK 
                       WHERE emitente.cod-emitente =  int(string(ENTRY(10, c-linha, ";") )) NO-ERROR.
                   IF NOT AVAIL emitente THEN DO:
                        PUT i-cont "  Cliente NÆo Encontrado "   string(ENTRY(10, c-linha, ";") ) SKIP.

                       NEXT.
                   END.
               END.

               IF string(ENTRY(9, c-linha, ";") ) <> '' THEN DO: /* UF Cliente/Fornecedor */
                   FIND FIRST mgcad.cidade WHERE cidade.estado = string(ENTRY(9, c-linha, ";") ) NO-LOCK NO-ERROR.
                   IF AVAIL cidade THEN
                       ASSIGN i-grupoEmit = INTEGER(substring(string(cidade.cdn-munpio-ibge),1,2)).
               END. /* IF string(ENTRY(9, c-linha, ";") ) <> '' THEN DO: */

               ASSIGN i-idi-tip-docto = IF  string(ENTRY(3, c-linha, ";") ) = "E" THEN 1 ELSE 2   .

                /*
                sit-tribut-relacto.cdn-tribut 
                sit-tribut-relacto.idi-tip-docto 
                sit-tribut-relacto.cod-estab 
                sit-tribut-relacto.cod-natur-operac 
                sit-tribut-relacto.cod-ncm 
                sit-tribut-relacto.cod-item 
                sit-tribut-relacto.cdn-grp-emit 
                sit-tribut-relacto.cdn-emitente 
                sit-tribut-relacto.dat-valid-inic 
                sit-tribut-relacto.cdn-sit-tribut
                */

                
               FIND FIRST sit-tribut-relacto
                   WHERE sit-tribut-relacto.cdn-tribut       = 21                                                               
                     AND sit-tribut-relacto.idi-tip-docto    = i-idi-tip-docto
                     AND sit-tribut-relacto.cod-estab        = string(ENTRY(5, c-linha, ";") )                                  
                     AND sit-tribut-relacto.cod-natur-operac = string(ENTRY(6, c-linha, ";") )                                  
                     AND sit-tribut-relacto.cod-ncm          = string(ENTRY(7, c-linha, ";") )                                  
                     AND sit-tribut-relacto.cod-item         = string(ENTRY(8, c-linha, ";") )                                  
                     AND sit-tribut-relacto.cdn-grp-emit     = i-grupoEmit
                     AND sit-tribut-relacto.cdn-emitente     = int(string(ENTRY(10, c-linha, ";") ))                            
                     AND sit-tribut-relacto.dat-valid-inic   = date(string(ENTRY(4, c-linha, ";") ))                            
                     AND sit-tribut-relacto.cdn-sit-tribut   = int(string(ENTRY(1, c-linha, ";") )) NO-LOCK NO-ERROR.
                     
               IF AVAIL sit-tribut-relacto THEN DO:
               
                   PUT i-cont " Registro ja Existe na base, registro desconsiderado" 
                      string(ENTRY(1, c-linha, ";") ) ";"
                      string(ENTRY(2, c-linha, ";") )                              ";"
                      string(ENTRY(3, c-linha, ";") )                              ";"
                      date(string(ENTRY(4, c-linha, ";") ))                        ";"
                      string(ENTRY(5, c-linha, ";") )                              ";"
                      string(ENTRY(6, c-linha, ";") )                              ";"
                      string(ENTRY(7, c-linha, ";") )                              ";"
                      string(ENTRY(8, c-linha, ";") )                              ";" 
                      string(ENTRY(9, c-linha, ";") )                              ";" 
                      int(string(ENTRY(10, c-linha, ";") ))                        ";" SKIP.
                   NEXT.
                END.

               FIND sit-tribut
                    WHERE sit-tribut.cdn-tribut     = 21
                      AND sit-tribut.cdn-sit-tribut = int(string(ENTRY(1, c-linha, ";") ))
                   NO-LOCK NO-ERROR.
               IF NOT AVAIL sit-tribut THEN DO:
                   CREATE sit-tribut.
                   ASSIGN  sit-tribut.cdn-tribut     = 21                                     
                           sit-tribut.cdn-sit-tribut = int(string(ENTRY(1, c-linha, ";") ))
                           sit-tribut.dsl-sit-tribut = string(ENTRY(2, c-linha, ";") )
                           sit-tribut.val-livre-1    = int(SUBstring(STRING(ENTRY(1, c-linha, ";") ),1,2))   .
               END.
                      

               CREATE sit-tribut-relacto.
               ASSIGN sit-tribut-relacto.cdn-tribut       = 21
                      sit-tribut-relacto.cdn-sit-tribut   = int(string(ENTRY(1, c-linha, ";") ))
                      sit-tribut-relacto.idi-tip-docto    = i-idi-tip-docto
                      sit-tribut-relacto.dat-valid-inic   = date(string(ENTRY(4, c-linha, ";") ))
                      sit-tribut-relacto.cod-estab        = string(ENTRY(5, c-linha, ";") )      
                      sit-tribut-relacto.cod-natur-operac = string(ENTRY(6, c-linha, ";") )      
                      sit-tribut-relacto.cod-ncm          = string(ENTRY(7, c-linha, ";") )      
                      sit-tribut-relacto.cod-item         = string(ENTRY(8, c-linha, ";") )      
                      sit-tribut-relacto.cod-livre-1      = string(ENTRY(9, c-linha, ";") )
                      sit-tribut-relacto.cdn-grp-emit     = i-grupoEmit
                      sit-tribut-relacto.cdn-emitente     = int(string(ENTRY(10, c-linha, ";") ))
                      sit-tribut-relacto.val-livre-1      = DEC(STRING(ENTRY(11, c-linha, ";") ))
                      sit-tribut-relacto.val-livre-2      = DEC(STRING(ENTRY(12, c-linha, ";") )).

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

