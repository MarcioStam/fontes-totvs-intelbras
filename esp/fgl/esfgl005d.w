&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esfgl005d 9.99.99.999}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esfgl005d
&GLOBAL-DEFINE Version        2.0

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE page0Widgets   btOK btCancel BtFile c-editor fiFile


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


DEF INPUT PARAM p-rowid-int-rateio AS ROWID NO-UNDO.

DEF TEMP-TABLE tt-int-rateio-plan NO-UNDO LIKE int-rateio-plan.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-7 RECT-8 btFile fiFile ~
c-editor btOK btCancel btHelp 
&Scoped-Define DISPLAYED-OBJECTS fiFile c-editor 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-editor AS CHARACTER INITIAL "As informaá‰es dentro do arquivo devem estar separadas por ~{ ~; }" 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 85 BY 5.5
     BGCOLOR 15 FGCOLOR 12 .

DEFINE VARIABLE fiFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 70 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.86 BY 2.38.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 6.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFile AT ROW 2.58 COL 74.57 HELP
          "Escolha do nome do arquivo" WIDGET-ID 16
     fiFile AT ROW 2.67 COL 4 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL WIDGET-ID 18
     c-editor AT ROW 5.5 COL 3.43 NO-LABEL WIDGET-ID 10
     btOK AT ROW 12 COL 2.43
     btCancel AT ROW 12 COL 13.43
     btHelp AT ROW 12 COL 80.29 WIDGET-ID 20
     "Informar o arquivo para importaá∆o:" VIEW-AS TEXT
          SIZE 25 BY .67 AT ROW 1.5 COL 3.72 WIDGET-ID 8
     "Informaá‰es Importantes:" VIEW-AS TEXT
          SIZE 18 BY .67 AT ROW 4.67 COL 3 WIDGET-ID 12
     rtToolBar AT ROW 11.79 COL 1
     RECT-7 AT ROW 1.88 COL 2.14 WIDGET-ID 6
     RECT-8 AT ROW 5 COL 2 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 12.29
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 12.42
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
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
       c-editor:READ-ONLY IN FRAME fpage0        = TRUE.

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


&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wWindow
ON CHOOSE OF btFile IN FRAME fpage0
DO:
    def var c-File as char no-undo.
    def var l-ok  as logical no-undo.

    DEF VAR cModelRTF AS CHAR  NO-UNDO.
    
    SYSTEM-DIALOG GET-FILE c-File
       FILTERS "*.csv" "*.csv",
               "*.*" "*.*"
       DEFAULT-EXTENSION "csv"
       INITIAL-DIR "modelos" 
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok.
    
    ASSIGN fiFile:SCREEN-VALUE IN FRAME fpage0 = c-File.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:

    DEF BUFFER b-tt-int-rateio-plan FOR tt-int-rateio-plan.

    EMPTY TEMP-TABLE tt-int-rateio-plan.
    
    FIND FIRST int-rateio no-lock
        WHERE rowid(int-rateio) = p-rowid-int-rateio NO-ERROR.

    IF  trim(fiFile:SCREEN-VALUE IN FRAME fpage0)  = ""
    OR SEARCH(input frame fpage0 fiFile:screen-value) = ? THEN DO:
        run utp/ut-msgs.p (input "show", input 17006 , input "Arquivo Inv†lido ou Inexistente.").   
        RETURN NO-APPLY.
    END.

    run utp/ut-msgs.p (input "show",
                       input 27100 ,
                       input "A importaá∆o eliminar† todos os registros atuais. " + "~~" + "Confirma a importaá∆o dos Rateios constantes no arquivo para a base de dados?").   
        
    IF  RETURN-VALUE = "YES" THEN DO:
        DEFINE VARIABLE c-linha AS CHARACTER FORMAT "x(200)".

        INPUT FROM VALUE(fiFile:SCREEN-VALUE IN FRAME fpage0).

        DEF VAR i AS INTEGER NO-UNDO.
        DEF VAR c-erro-geral AS CHAR FORMAT "X(2000)" NO-UNDO.
        DEF VAR c-erro       AS CHAR FORMAT "X(2000)" NO-UNDO.
        DEF VAR de-tot-rat   AS DEC NO-UNDO.

        REPEAT: 

            IMPORT UNFORMATTED c-linha.
            
            IF  NUM-ENTRIES(c-linha, ";") <  4 THEN 
                NEXT.

            IF  entry(1, c-linha, ";") <> "" THEN
                ASSIGN c-erro = "".
                RUN pi-valida-campos (input entry(1, c-linha, ";"),
                                      INPUT entry(2, c-linha, ";"),
                                      input entry(3, c-linha, ";"),
                                      input entry(4, c-linha, ";"),
                                      OUTPUT c-erro ). 
            IF  c-erro <> "" THEN
                ASSIGN c-erro-geral = c-erro-geral + CHR(10) + "Linha 1: " + c-erro + CHR(10).
            ELSE DO:
            
                IF  NOT CAN-FIND (FIRST b-tt-int-rateio-plan
                                 WHERE b-tt-int-rateio-plan.tipo-rateio      = int-rateio.tipo-rateio 
                                   and b-tt-int-rateio-plan.competencia      = int-rateio.competencia 
                                   and b-tt-int-rateio-plan.cod-estabel      = int-rateio.cod-estabel 
                                   and b-tt-int-rateio-plan.cod-estabel-rat  = entry(1, c-linha, ";") 
                                   and b-tt-int-rateio-plan.cod-centro-custo = entry(2, c-linha, ";") 
                                   and b-tt-int-rateio-plan.cod-unid-neg     = entry(3, c-linha, ";") 
                                   ) THEN DO:


                    CREATE tt-int-rateio-plan.
                    ASSIGN tt-int-rateio-plan.tipo-rateio      = int-rateio.tipo-rateio
                           tt-int-rateio-plan.competencia      = int-rateio.competencia
                           tt-int-rateio-plan.cod-estabel      = int-rateio.cod-estabel
                           tt-int-rateio-plan.cod-estabel-rat  = entry(1, c-linha, ";")
                           tt-int-rateio-plan.cod-centro-custo = entry(2, c-linha, ";")
                           tt-int-rateio-plan.cod-unid-neg     = entry(3, c-linha, ";")
                           tt-int-rateio-plan.vl-perc-rateio   = dec(entry(4, c-linha, ";")).

                    de-tot-rat = de-tot-rat + tt-int-rateio-plan.vl-perc-rateio.

                END.
            END.
    
            i = i + 1.

            IF  c-linha = "" THEN
                LEAVE.
        END.              

        INPUT CLOSE.

        IF  c-erro-geral <> "" THEN DO:
            run utp/ut-msgs.p (input "show", input 17006 , input "Erros encontrados." + "~~" + c-erro-geral). 
            RETURN NO-APPLY.
        END.


        IF  de-tot-rat <> 100 THEN DO:
            run utp/ut-msgs.p (input "show", input 17006 , input "% Total do rateio n∆o fecha em 100%. Informado: " + STRING(de-tot-rat)).   
            RETURN NO-APPLY.
        END.

        IF  c-erro-geral = "" THEN DO TRANS:

            /* Eliminando Registros Anteriores */
            FOR EACH int-rateio-plan EXCLUSIVE-LOCK
                WHERE int-rateio-plan.tipo-rateio      = int-rateio.tipo-rateio
                  AND int-rateio-plan.competencia      = int-rateio.competencia
                  AND int-rateio-plan.cod-estabel      = int-rateio.cod-estabel:
                  DELETE int-rateio-plan.
            END.

            /* Cria os novos registros com base na arquivo importado */
            FOR EACH tt-int-rateio-plan:
                
                FIND FIRST int-rateio-plan EXCLUSIVE-LOCK
                    WHERE int-rateio-plan.tipo-rateio      = tt-int-rateio-plan.tipo-rateio
                      AND int-rateio-plan.competencia      = tt-int-rateio-plan.competencia
                      AND int-rateio-plan.cod-estabel      = tt-int-rateio-plan.cod-estabel
                      AND int-rateio-plan.cod-estabel-rat  = tt-int-rateio-plan.cod-estabel-rat
                      AND int-rateio-plan.cod-centro-custo = tt-int-rateio-plan.cod-centro-custo
                      AND int-rateio-plan.cod-unid-neg     = tt-int-rateio-plan.cod-unid-neg NO-ERROR.


                IF  NOT AVAIL int-rateio-plan THEN DO:
                    CREATE int-rateio-plan.
                    BUFFER-COPY tt-int-rateio-plan EXCEPT char-1 TO int-rateio-plan.

                END.
                ELSE DO:
                    run utp/ut-msgs.p (input "show", input 17006 , input "Rateio j† existente " + "~~" + 
                                                                         "Tipo Rateio......: " + STRING(tt-int-rateio-plan.tipo-rateio)      + CHR(10) +   
                                                                         "Competància......: " + SUBSTR(tt-int-rateio-plan.competencia, 5,1) + "/" + SUBSTR(tt-int-rateio-plan.competencia, 1,4) + CHR(10) +
                                                                         "Estabelecimento..: " + STRING(tt-int-rateio-plan.cod-estabel)      + CHR(10) +
                                                                         "Estabelec Rateio.: " + STRING(tt-int-rateio-plan.cod-estabel-rat)  + CHR(10) +
                                                                         "Centro Custo.....: " + STRING(tt-int-rateio-plan.cod-centro-custo) + CHR(10) +
                                                                         "Unidade Neg¢cio..: " + STRING(tt-int-rateio-plan.cod-unid-neg)).
                    UNDO, RETURN NO-APPLY.
                END.
                
            END.
        END.



    END.
    
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDisplay wWindow 
PROCEDURE AfterDisplay :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
c-editor:SCREEN-VALUE IN FRAME fpage0 = "1) O campo de valor do rateio deve possuir do m†ximo 2 casas decimais truncadas. " + chr(10) + chr(10) +    
                                        "2) As informaá‰es dentro do arquivo devem estar separadas por ; (ponto e v°rgula) " + chr(10) + 
                                        "Os campos s∆o: C¢digo do Estabelecimento, C¢digo do Centro de Custo, C¢digo da Unidade de Neg¢cio" + CHR(10) + " e o Percentual de rateio. " + chr(10) +
                                        "Exempo de arquivo: " + chr(10) +
                                        "105;12100;NET;10,00" + chr(10) +
                                        "104;12100;CEN;12,11".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-campos wWindow 
PROCEDURE pi-valida-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT  PARAM c-estab    AS CHAR    NO-UNDO.
DEF INPUT  PARAM c-custo    AS CHAR    NO-UNDO.
DEF INPUT  PARAM c-unid-neg AS CHAR    NO-UNDO.
DEF INPUT  PARAM c-perc     AS CHAR    NO-UNDO.
DEF OUTPUT PARAM c-erro    AS CHAR    NO-UNDO.

DEF BUFFER b-aux FOR int-rateio.

FIND b-aux NO-LOCK
    WHERE ROWID(b-aux) = p-rowid-int-rateio NO-ERROR.

/* Valida Estabelecimento */
FIND FIRST estabelec NO-LOCK
    WHERE estabelec.cod-estabel = c-estab NO-ERROR.

IF  NOT AVAIL estabelec THEN
    ASSIGN c-erro = "Estabelecimento Inv†lido: " + c-estab + CHR(10).

/* Valida Centro de Custo */
FIND FIRST emscad.ccusto NO-LOCK
     WHERE emscad.ccusto.cod_ccusto = c-custo NO-ERROR.
IF  NOT AVAIL emscad.ccusto THEN
    ASSIGN c-erro = c-erro + "Centro de custo inv†lido: " + c-custo + CHR(10).

/* Valida Unidade Neg¢cio */
FIND FIRST unid-negoc NO-LOCK
    WHERE unid-negoc.cod-unid-negoc = c-unid-neg NO-ERROR.

IF  NOT AVAIL unid-negoc THEN
    ASSIGN c-erro = c-erro +  "Unidade de Neg¢cio Inv†lida: " + c-unid-neg + CHR(10).

/* Valida % Rateio */
IF  DEC(c-perc) = 0 THEN
    ASSIGN c-erro = c-erro +  "% de Rateio Inv†lida: " + c-perc + CHR(10).

IF  NOT CAN-FIND(FIRST cc_uni_estab
                   WHERE cc_uni_estab.cod_ccusto     = c-custo
                     AND cc_uni_estab.cod_unid_negoc = c-unid-neg
                     AND cc_uni_estab.cod_estab      = c-estab)  THEN 
     ASSIGN c-erro = c-erro +  "Relacionamento entre Estabelecimento " + c-estab + ", Centro de custo " + c-custo + ", e unidade de neg¢cio " + c-unid-neg + " inexistente. Deve ser cadastrada no programa ESFGL001: " + CHR(10).

IF  NOT CAN-FIND (FIRST b-aux
                     WHERE b-aux.tipo-rateio = b-aux.tipo-rateio 
                       and b-aux.competencia = b-aux.competencia 
                       and b-aux.cod-estabel = b-aux.cod-estabel) THEN
    ASSIGN c-erro = c-erro +  "Linha de dados n∆o est† relacionada ao registro de rateio corrente" + CHR(10).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

