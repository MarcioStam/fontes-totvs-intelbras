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
{include/i-prgvrs.i ESSDCV004 2.06.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESSDCV004
&GLOBAL-DEFINE Version        2.06.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   <Folder1 ,Folder 2 ,... , Folder8>

&GLOBAL-DEFINE page0Widgets   text-registro rsExportar fiDiretorio btPesquisar ~
                              btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE c-arquivo-pesq AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-ok           AS LOGICAL     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar rsExportar btPesquisar fiDiretorio ~
btOK btCancel btHelp2 text-registro 
&Scoped-Define DISPLAYED-OBJECTS rsExportar fiDiretorio text-registro 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Exportar" 
     SIZE 10 BY 1.

DEFINE BUTTON btPesquisar 
     IMAGE-UP FILE "image/im-sea.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sea.bmp":U
     LABEL "Pesquisar" 
     SIZE 4 BY 1.13.

DEFINE VARIABLE fiDiretorio AS CHARACTER FORMAT "X(180)":U 
     LABEL "Diret¢rio Sa¡da" 
     VIEW-AS FILL-IN 
     SIZE 61 BY .88 NO-UNDO.

DEFINE VARIABLE text-registro AS CHARACTER FORMAT "X(20)":U INITIAL "Registro:" 
      VIEW-AS TEXT 
     SIZE 6.29 BY .88 NO-UNDO.

DEFINE VARIABLE rsExportar AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Moeda", 1,
"Mensagem", 2
     SIZE 22 BY .88 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     rsExportar AT ROW 2.75 COL 18.86 HELP
          "Dado a ser exportado" NO-LABEL
     btPesquisar AT ROW 3.75 COL 80.14 HELP
          "Pesquisar diret¢rio"
     fiDiretorio AT ROW 3.88 COL 16.86 COLON-ALIGNED HELP
          "Diret¢rio de sa¡da dos arquivos"
     btOK AT ROW 6.75 COL 2 HELP
          "Exportar"
     btCancel AT ROW 6.75 COL 13 HELP
          "Cancelar"
     btHelp2 AT ROW 6.75 COL 80 HELP
          "Ajuda"
     text-registro AT ROW 2.75 COL 10.43 COLON-ALIGNED NO-LABEL
     rtToolBar AT ROW 6.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 7
         FONT 1 WIDGET-ID 100.


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
         HEIGHT             = 7
         WIDTH              = 90
         MAX-HEIGHT         = 7
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 7
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
ASSIGN 
       text-registro:PRIVATE-DATA IN FRAME fpage0     = 
                "Registro".

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
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
ON CHOOSE OF btOK IN FRAME fpage0 /* Exportar */
DO:
    RUN piExecutar IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPesquisar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPesquisar wWindow
ON CHOOSE OF btPesquisar IN FRAME fpage0 /* Pesquisar */
DO:
    ASSIGN c-arquivo-pesq = REPLACE(INPUT FRAME fPage0 fiDiretorio, "/":U, "~\":U).

    SYSTEM-DIALOG GET-DIR c-arquivo-pesq
        INITIAL-DIR c-arquivo-pesq
        UPDATE l-ok.

    IF l-ok THEN DO:
        ASSIGN fiDiretorio = REPLACE(c-arquivo-pesq, "/":U, "~\":U).

        DISPLAY fiDiretorio
            WITH FRAME fPage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiDiretorio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiDiretorio wWindow
ON / OF fiDiretorio IN FRAME fpage0 /* Diret¢rio Sa¡da */
DO:
    APPLY "~\":U TO SELF.

    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN rsExportar  = 1
           fiDiretorio = "":U.

    FIND FIRST usuar_mestre
        WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.

    IF AVAILABLE usuar_mestre THEN DO:
        IF usuar_mestre.nom_dir_spool <> "":U THEN DO:
            FILE-INFO:FILE-NAME = usuar_mestre.nom_dir_spool.

            IF FILE-INFO:FULL-PATHNAME          <> ?    AND
               FILE-INFO:FULL-PATHNAME          <> "":U AND
               INDEX(FILE-INFO:FILE-TYPE, "D":U) > 0    THEN DO:
                ASSIGN fiDiretorio = REPLACE(FILE-INFO:FULL-PATHNAME, "/":U, "~\":U).

                IF usuar_mestre.nom_subdir_spool <> "":U THEN DO:
                    OS-CREATE-DIR VALUE(fiDiretorio + "~\":U + usuar_mestre.nom_subdir_spool) NO-ERROR.

                    FILE-INFO:FILE-NAME = fiDiretorio + "~\":U + usuar_mestre.nom_subdir_spool.

                    IF FILE-INFO:FULL-PATHNAME          <> ?    AND
                       FILE-INFO:FULL-PATHNAME          <> "":U AND
                       INDEX(FILE-INFO:FILE-TYPE, "D":U) > 0    THEN DO:
                        ASSIGN fiDiretorio = REPLACE(FILE-INFO:FULL-PATHNAME, "/":U, "~\":U).
                    END.
                END.
            END.
        END.
    END.

    IF fiDiretorio = "":U THEN
        ASSIGN fiDiretorio = REPLACE(SESSION:TEMP-DIRECTORY, "/":U, "~\":U).

    DISPLAY fiDiretorio
            rsExportar
        WITH FRAME fPage0.

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
    DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-diretorio-aux AS CHARACTER   NO-UNDO.

    ASSIGN INPUT FRAME fPage0 rsExportar
                              fiDiretorio.

    ASSIGN fiDiretorio = REPLACE(fiDiretorio, "/":U, "~\":U).

    DISPLAY fiDiretorio
        WITH FRAME fPage0.

    FILE-INFO:FILE-NAME = fiDiretorio.

    IF FILE-INFO:FULL-PATHNAME           = ?    OR
       FILE-INFO:FULL-PATHNAME           = "":U OR
       INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0    THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Diret¢rio informado ‚ inv lido!":U).

        APPLY "ENTRY":U TO fiDiretorio IN FRAME fPage0.

        RETURN "NOK":U.
    END.

    IF  NOT VALID-HANDLE(h-acomp)                OR
        h-acomp:TYPE      <> "PROCEDURE":U       OR
       (h-acomp:FILE-NAME <> "utp/ut-acomp.p":U  AND
        h-acomp:FILE-NAME <> "utp/ut-acomp.r":U) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Exportando dados...":U).

    CASE rsExportar:
        WHEN 1 THEN DO:
            ASSIGN c-diretorio-aux = fiDiretorio + "~\moeda-":U + REPLACE(STRING(TODAY, "99/99/9999":U), "/":U, ".":U) + "-":U + REPLACE(STRING(TIME, "hh:mm:ss":U), ":":U, ".":U) + ".txt":U.

            OUTPUT TO VALUE(c-diretorio-aux) CONVERT TARGET "iso8859-1":U.
            FOR EACH moeda NO-LOCK:
                IF VALID-HANDLE(h-acomp) THEN
                    RUN pi-acompanhar IN h-acomp (INPUT "Mensagem ":U + TRIM(STRING(moeda.mo-codigo, ">9":U))).

                PUT UNFORMATTED TRIM(STRING(moeda.mo-codigo, ">9":U)) "#SEP#":U
                                TRIM(moeda.descricao)                 SKIP.
            END.
            OUTPUT CLOSE.
        END.
        WHEN 2 THEN DO:
            ASSIGN c-diretorio-aux = fiDiretorio + "~\mensagem-":U + REPLACE(STRING(TODAY, "99/99/9999":U), "/":U, ".":U) + "-":U + REPLACE(STRING(TIME, "hh:mm:ss":U), ":":U, ".":U).

            OS-CREATE-DIR VALUE(c-diretorio-aux) NO-ERROR.

            IF ERROR-STATUS:ERROR THEN
                ASSIGN c-diretorio-aux = fiDiretorio.

            FOR EACH mensagem NO-LOCK:
                IF VALID-HANDLE(h-acomp) THEN
                    RUN pi-acompanhar IN h-acomp (INPUT "Mensagem ":U + TRIM(STRING(mensagem.cod-mensagem, ">>9":U))).

                OUTPUT TO VALUE(c-diretorio-aux + "~\mensagem-":U + TRIM(STRING(mensagem.cod-mensagem, ">>9":U)) + ".txt":U) CONVERT TARGET "iso8859-1":U.
                PUT UNFORMATTED TRIM(STRING(mensagem.cod-mensagem, ">>9":U)) "#SEP#":U
                                TRIM(mensagem.descricao)                     "#SEP#":U
                                mensagem.texto-mensag                        SKIP.
                OUTPUT CLOSE.
            END.
        END.
    END CASE.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.

    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 15825,
                       INPUT "Arquivo exportado com sucesso!~~Arquivo exportado com sucesso em:":U + CHR(10) + c-diretorio-aux).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

