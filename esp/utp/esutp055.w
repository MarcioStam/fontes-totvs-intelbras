&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*****************************************************************************
**     Programa.........: esp/utp/esutp005.p
**     Descricao .......: 
**     Versao...........: 1.00.001
**     Autor............: Gustavo
**     Criado...........: 17/06/2011
**     Desc. Atualiza‡Æo: 
**     Autor............: 
*******************************************************************************/

CREATE WIDGET-POOL.
&SCOPED-DEFINE NomProg   ESUTP055
&SCOPED-DEFINE DescProg  Importa‡Æo Correios

DEFINE VARIABLE c-periodo       AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-dir-arquivo   AS CHARACTER FORMAT "x(100)"  NO-UNDO.
DEFINE VARIABLE i-reg-fatura    AS INTEGER                    NO-UNDO.
DEFINE VARIABLE de-valor-fatura AS DECIMAL                    NO-UNDO.
DEFINE VARIABLE h-acomp         AS HANDLE                     NO-UNDO.

DEFINE VARIABLE i-linha        AS INTEGER                     NO-UNDO.
DEFINE VARIABLE c-linha        AS CHARACTER FORMAT "x(78)"    NO-UNDO.
                                                              
DEFINE VARIABLE c-fatura       AS CHARACTER FORMAT "x(11)"    NO-UNDO.
DEFINE VARIABLE c-contrato     AS CHARACTER FORMAT "x(11)"    NO-UNDO.
DEFINE VARIABLE c-origem       AS CHARACTER FORMAT "x(30)"    NO-UNDO.
DEFINE VARIABLE i-cliente      AS INTEGER                     NO-UNDO.
DEFINE VARIABLE c-nr-cartao    AS CHARACTER FORMAT "x(10)"    NO-UNDO.
DEFINE VARIABLE c-cc-codigo    AS CHARACTER FORMAT "x(55)"    NO-UNDO.
                                                              
DEFINE VARIABLE de-desconto    AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE i-erro         AS INTEGER                     NO-UNDO.
DEFINE VARIABLE de-valor-total AS DECIMAL                     NO-UNDO.

DEFINE TEMP-TABLE tt-total
    FIELD ct-codigo    AS CHARACTER FORMAT "x(20)"
    FIELD cc-codigo    AS CHARACTER FORMAT "x(20)"
    FIELD valor        AS DECIMAL.

DEF TEMP-TABLE tt-dados-post
    FIELD tipo              AS INTEGER                         
    field nr-contrato       AS CHARACTER FORMAT  "x(20)" 
    field nr-fatura         AS CHARACTER FORMAT  "x(20)"
    field cod-cliente       AS INTEGER   format ">>>>>>9" 
    field nr-cartao         AS CHARACTER FORMAT  "x(20)"
    field ct-codigo         AS CHARACTER FORMAT "x(08)"
    field cc-codigo         AS CHARACTER FORMAT "x(05)" 
    field servico           AS CHARACTER FORMAT "x(40)"
    FIELD servico-adicional AS CHARACTER FORMAT "x(20)"         
    field dt-postagem       AS DATE
    field nr-docto          AS CHAR           /* CHARACTER FORMAT "X(10)" */
    field cod-destino       AS INT FORMAT ">>>>9"                                          
    field un-postagem       AS CHAR FORMAT "x(40)"                                         
    FIELD peso              AS INT                                                         
    field qtde              AS INT
    field vl-unit           AS DEC 
    field vl-serv           AS DEC
    field vl-desc           AS DEC
    field valor             AS DEC
    FIELD origem-postagem   AS CHAR.

DEFINE TEMP-TABLE tt-cc NO-UNDO
    FIELD nr-cartao LIKE correios-cartao.nr-cartao
    FIELD ct-codigo LIKE correios-cartao.ct-codigo
    FIELD cc-codigo AS CHARACTER FORMAT "x(08)"
    FIELD percentual AS DECIMAL FORMAT ">>9.99"
    INDEX chave nr-cartao ct-codigo cc-codigo.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD linha     AS INTEGER 
    FIELD cod-erro  AS INTEGER
    FIELD descricao AS CHARACTER FORMAT "x(100)".

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD arquivo AS CHAR
    FIELD marcado AS LOGICAL FORMAT "*/ ".

DEFINE VARIABLE hProgramZoom AS HANDLE         NO-UNDO.
DEFINE VARIABLE l-implanta   AS LOGICAL        NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa  AS WIDGET-HANDLE  NO-UNDO.

DEFINE BUFFER b-tt-dados-post FOR tt-dados-post.

DEF VAR cArq        AS CHAR FORMAT "X(20)" NO-UNDO.
DEF VAR cArqCaminho AS CHAR FORMAT "X(50)" NO-UNDO.
DEF VAR cArqId      AS CHAR FORMAT "X(20)" NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-relat
&Scoped-define BROWSE-NAME brDigita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE brDigita                                      */
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.marcado tt-digita.arquivo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita   
&Scoped-define SELF-NAME brDigita
&Scoped-define QUERY-STRING-brDigita FOR EACH tt-digita
&Scoped-define OPEN-QUERY-brDigita OPEN QUERY {&SELF-NAME} FOR EACH tt-digita.
&Scoped-define TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-brDigita tt-digita


/* Definitions for FRAME f-relat                                        */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-relat ~
    ~{&OPEN-QUERY-brDigita}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brDigita bt-carregar bt-remover fi-arquivo ~
bt-importacao bt-fechar bt-executar RECT-2 RECT-9 
&Scoped-Define DISPLAYED-OBJECTS fi-arquivo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-carregar 
     LABEL "Carregar" 
     SIZE 12.57 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 11.14 BY 1 TOOLTIP "Imprimir"
     FONT 1.

DEFINE BUTTON bt-fechar 
     LABEL "Fechar" 
     SIZE 11.14 BY 1 TOOLTIP "Fechar/Salvar"
     FONT 1.

DEFINE BUTTON bt-importacao 
     IMAGE-UP FILE "image/im-sea1.bmp":U
     LABEL "" 
     SIZE 3.86 BY 1.08 TOOLTIP "Localiza Arquivo".

DEFINE BUTTON bt-remover 
     LABEL "Remover Arq" 
     SIZE 13.72 BY 1 TOOLTIP "Remover Arquivo Selecionado".

DEFINE VARIABLE fi-arquivo AS CHARACTER FORMAT "X(100)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 52 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 91 BY 1.54
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDigita FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDigita C-Win _FREEFORM
  QUERY brDigita DISPLAY
      tt-digita.marcado COLUMN-LABEL " X "
tt-digita.arquivo FORMAT "x(100)" COLUMN-LABEL "Arquivo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 7.5
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     brDigita AT ROW 1.17 COL 2 WIDGET-ID 100
     bt-carregar AT ROW 11.29 COL 71.43 WIDGET-ID 50
     bt-remover AT ROW 8.75 COL 2.14 WIDGET-ID 48
     fi-arquivo AT ROW 11.38 COL 9 COLON-ALIGNED
     bt-importacao AT ROW 11.25 COL 63 HELP
          "Localiza Arquivo"
     bt-fechar AT ROW 13.13 COL 13.72
     bt-executar AT ROW 13.13 COL 2
     "Parƒmetros:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 10.5 COL 2.57
          FONT 6
     RECT-2 AT ROW 12.83 COL 1
     RECT-9 AT ROW 10.75 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.29 BY 13.42
         FONT 1
         DEFAULT-BUTTON bt-executar.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "{&DescProg} - {&NomProg}"
         HEIGHT             = 13.42
         WIDTH              = 91.29
         MAX-HEIGHT         = 33.04
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 33.04
         VIRTUAL-WIDTH      = 182.86
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 1
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-relat
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB brDigita 1 f-relat */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDigita
/* Query rebuild information for BROWSE brDigita
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-digita.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDigita */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-relat
/* Query rebuild information for FRAME f-relat
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME f-relat */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* {DescProg} - {NomProg} */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* {DescProg} - {NomProg} */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDigita
&Scoped-define SELF-NAME brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita C-Win
ON MOUSE-SELECT-DBLCLICK OF brDigita IN FRAME f-relat
DO:
    ASSIGN tt-digita.marcado = NOT(tt-digita.marcado).

    DISPLAY tt-digita.marcado WITH BROWSE brDigita.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-carregar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-carregar C-Win
ON CHOOSE OF bt-carregar IN FRAME f-relat /* Carregar */
DO:
    EMPTY TEMP-TABLE tt-digita.

    ASSIGN INPUT FRAME f-relat fi-arquivo.

    ASSIGN FILE-INFO:FILE-NAME = fi-arquivo.
    IF FILE-INFO:PATHNAME                 <> ?  AND 
       SUBSTRING(FILE-INFO:FILE-TYPE,1,1) = "D" THEN DO:
        EMPTY TEMP-TABLE tt-digita.

        INPUT FROM OS-DIR(fi-arquivo).        
        REPEAT:
            IMPORT cArq cArqCaminho cArqId.
            
            IF SEARCH(cArqCaminho) <> ? THEN DO:
                IF SUBSTRING(cArqCaminho,LENGTH(cArqCaminho) - 2,3) = "txt" THEN DO:
                    IF NOT CAN-FIND(FIRST tt-digita
                                    WHERE tt-digita.arquivo = cArqCaminho) THEN DO:
                        CREATE tt-digita.
                        ASSIGN tt-digita.arquivo = cArqCaminho.                           
                    END.
                END.
            END.
        END.
        INPUT CLOSE.
    END.
    ELSE DO:
        IF FILE-INFO:PATHNAME = ? THEN
            MESSAGE "Diret¢rio Inv lido!" 
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

        IF SUBSTRING(FILE-INFO:FILE-TYPE,1,1) = "F" THEN
            MESSAGE "Informe um Diret¢rio!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

    {&OPEN-QUERY-brDigita}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar C-Win
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
    FOR EACH tt-digita:
        IF SEARCH(tt-digita.arquivo) = ? THEN DO:
            MESSAGE "Arquivo (tt-digita.arquivo) nÆo encontrado. Favor informar um arquivo v lido!"
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN NO-APPLY.
        END.
    END.
   
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar in h-acomp (input "Verifica‡Æo...").

    RUN pi-importa.    

    RUN pi-finalizar in h-acomp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fechar C-Win
ON CHOOSE OF bt-fechar IN FRAME f-relat /* Fechar */
DO:
  APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-importacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importacao C-Win
ON CHOOSE OF bt-importacao IN FRAME f-relat
DO:
    DEF VAR c-arq-conv  AS CHAR                NO-UNDO.

    ASSIGN c-arq-conv ="".

    SYSTEM-DIALOG GET-DIR c-arq-conv
                  INITIAL-DIR SESSION:TEMP-DIRECTORY.

    ASSIGN fi-arquivo = c-arq-conv.
    DISPLAY fi-arquivo WITH FRAME f-relat.

    IF c-arq-conv <> "" THEN DO:
        EMPTY TEMP-TABLE tt-digita.

        INPUT FROM OS-DIR(c-arq-conv).        
        REPEAT:
            IMPORT cArq cArqCaminho cArqId.
            
            IF SEARCH(cArqCaminho) <> ? THEN DO:
                IF SUBSTRING(cArqCaminho,LENGTH(cArqCaminho) - 2,3) = "txt" THEN DO:
                    IF NOT CAN-FIND(FIRST tt-digita
                                    WHERE tt-digita.arquivo = cArqCaminho) THEN DO:
                        CREATE tt-digita.
                        ASSIGN tt-digita.arquivo = cArqCaminho.                           
                    END.
                END.
            END.
        END.
        INPUT CLOSE.
    END.

    {&OPEN-QUERY-brDigita}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-remover
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-remover C-Win
ON CHOOSE OF bt-remover IN FRAME f-relat /* Remover Arq */
DO:
    FOR EACH tt-digita
       WHERE tt-digita.marcado:
        DELETE tt-digita.
    END.

    {&OPEN-QUERY-brDigita}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.

    IF NOT THIS-PROCEDURE:PERSISTENT THEN 
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY fi-arquivo 
      WITH FRAME f-relat IN WINDOW C-Win.
  ENABLE brDigita bt-carregar bt-remover fi-arquivo bt-importacao bt-fechar 
         bt-executar RECT-2 RECT-9 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-centro-custo C-Win 
PROCEDURE pi-centro-custo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cc-codigo AS CHARACTER NO-UNDO.

    DEFINE VARIABLE i-cont         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-centro-custo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lista        AS CHARACTER   NO-UNDO.

    ASSIGN c-lista        = "0123456789"
           c-centro-custo = "".

    find first correios-cartao where  
               correios-cartao.nr-cartao = c-nr-cartao no-error.
    if avail correios-cartao THEN DO:

        IF correios-cartao.cc-codigo[1] <> "" AND
           correios-cartao.perc-rateio[1] = 100  THEN DO:

            CREATE tt-cc.
            ASSIGN tt-cc.nr-cartao   = correios-cartao.nr-cartao
                   tt-cc.ct-codigo   = correios-cartao.ct-codigo
                   tt-cc.cc-codigo   = correios-cartao.cc-codigo[1]
                   tt-cc.percentual  = correios-cartao.perc-rateio[1].
        END.
        ELSE DO:
            DO i-cont = 1 TO 10:
                IF correios-cartao.cc-codigo[i-cont] <> "" AND
                   correios-cartao.perc-rateio[i-cont] <> 0  THEN DO:
    
                    CREATE tt-cc.
                    ASSIGN tt-cc.nr-cartao   = correios-cartao.nr-cartao     
                           tt-cc.ct-codigo   = correios-cartao.ct-codigo     
                           tt-cc.cc-codigo   = correios-cartao.cc-codigo[i-cont]  
                           tt-cc.percentual  = correios-cartao.perc-rateio[i-cont].
                END.
            END.
        END.
    END.
    ELSE DO:
        ASSIGN i-erro = i-erro + 1.

        CREATE tt-erro.
        ASSIGN tt-erro.linha     = i-erro
               tt-erro.cod-erro  = 1
               tt-erro.descricao = "Nao encontrato centro de custo para o cartao: " + STRING(c-nr-cartao) + " - cc enviado pelo correio: " + c-centro-custo.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-correios C-Win 
PROCEDURE pi-correios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE de-valor         AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-linha-aux      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-cont           AS INTEGER     NO-UNDO.
    DEFINE VARIABLE da-data-desconto AS DATE        NO-UNDO.
    DEFINE VARIABLE de-rateio        AS DECIMAL     NO-UNDO.

    DEFINE VARIABLE de-valor-antes   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-valor-depois  AS DECIMAL     NO-UNDO.

    EMPTY TEMP-TABLE tt-dados-post.

    ASSIGN de-desconto = 0
           i-erro      = 0.

    EMPTY TEMP-TABLE tt-erro.

    FOR EACH tt-digita:

        INPUT FROM VALUE(tt-digita.arquivo) NO-CONVERT.
        REPEAT:
            IMPORT UNFORMATTED c-linha.
    
            ASSIGN c-linha = TRIM(c-linha).
    
            IF SUBSTRING(c-linha,1,7) = "1Fatura" THEN 
               ASSIGN c-fatura   = trim(substring(ENTRY(2,c-linha,":"),1,11))
                      c-contrato = trim(substring(ENTRY(3,c-linha,":"),1,11)).
    
            IF SUBSTRING(c-linha,1,7) = "2Origem" THEN
               ASSIGN c-origem = trim(ENTRY(2,ENTRY(2,c-linha,":"),"-")).
    
           IF  SUBSTRING(c-linha,1,1)  =  "4"         AND 
               SUBSTRING(c-linha,1,10) <> "4Postagem" THEN DO:
    
               CREATE tt-dados-post.
               ASSIGN tt-dados-post.nr-docto = SUBSTRING(c-linha,42,10).
           END.    
        END.
        INPUT CLOSE.

    END.

    FOR EACH tt-dados-post:
        FIND FIRST b-tt-dados-post
             WHERE b-tt-dados-post.nr-docto = tt-dados-post.nr-docto 
               AND ROWID(b-tt-dados-post) <> ROWID(tt-dados-post) NO-LOCK NO-ERROR.
        IF NOT AVAIL b-tt-dados-post THEN
            DELETE tt-dados-post.
    END.

    OUTPUT TO "C:/temp/esutp055.txt".
    IF CAN-FIND (FIRST tt-dados-post) THEN DO:
        PUT UNFORMATTED "Nr Docto Duplicado" SKIP.
        FOR EACH tt-dados-post:
            PUT UNFORMATTED tt-dados-post.nr-docto SKIP.
        END.
    END.
    ELSE DO:
        PUT UNFORMATTED "Nenhum Documento Duplicado!" SKIP.
    END.
    OUTPUT TO CLOSE.

    def var h-prog as handle no-undo.
    run utp/ut-utils.p persistent set h-prog.
    
    run Execute in h-prog(input "C:/temp/esutp055.txt",
                          input "").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa C-Win 
PROCEDURE pi-importa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-erros  AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-primeiro AS LOGICAL     NO-UNDO.

    DEFINE VARIABLE de-valor AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-total AS DECIMAL     NO-UNDO.

    DEFINE VARIABLE i-quant          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-total-fatura  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-tempo         AS DECIMAL     NO-UNDO.
    
    FOR EACH tt-erro:
        DELETE tt-erro.
    END.

    FOR EACH tt-dados-post:
        DELETE tt-dados-post.
    END.

    FOR EACH tt-total:
        DELETE tt-total.
    END.

    ASSIGN i-reg-fatura    = 0
           de-valor-fatura = 0
           de-valor-total  = 0.
    
    RUN pi-correios.
   
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

