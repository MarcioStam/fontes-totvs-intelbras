&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*****************************************************************************
**     Programa.........: esp/utp/esutp005.p
**     Descricao .......: Importaá∆o Telefonia.
**     Versao...........: 1.00.001
**     Autor............: Raphael Paini
**     Criado...........: 01/06/2008
**     Desc. Atualizaá∆o: 
**     Autor............: 
*******************************************************************************/

CREATE WIDGET-POOL.
&SCOPED-DEFINE NomProg   ESUTP005
&SCOPED-DEFINE DescProg  Importaá∆o Telefonia
&SCOPED-DEFINE VerProg   2.06.001

DEFINE VARIABLE v-cod-versao      AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-linha           AS CHARACTER             NO-UNDO.
DEFINE VARIABLE v-cod-equito-desc AS CHARACTER             NO-UNDO.
DEFINE VARIABLE v-cod-equito-ajus AS CHARACTER             NO-UNDO.
DEFINE VARIABLE v-cod-equito-plan AS CHARACTER             NO-UNDO.
DEFINE VARIABLE v-cod-equito-tmp  AS CHARACTER             NO-UNDO.
DEFINE VARIABLE i-cont            AS INTEGER               NO-UNDO.
DEFINE VARIABLE i-erro            AS INTEGER               NO-UNDO.
DEFINE VARIABLE v-num-segs        AS INTEGER               NO-UNDO.
DEFINE VARIABLE v-val-movto       AS DECIMAL               NO-UNDO.
DEFINE VARIABLE v-log-erro-imp    AS LOGICAL               NO-UNDO.
DEFINE VARIABLE h-acomp           AS HANDLE                NO-UNDO.
DEFINE VARIABLE hProgramZoom      AS HANDLE                NO-UNDO.
DEFINE VARIABLE v-cod-cnpj      LIKE emitente.cgc          NO-UNDO.
DEFINE VARIABLE v-cod-fornec    LIKE emitente.cod-emitente NO-UNDO.
DEFINE VARIABLE v-cod-periodo   LIKE telefonia.mes-ref     NO-UNDO.
DEFINE VARIABLE v-cod-fatura    LIKE telefonia.nr-fatura   NO-UNDO.
DEFINE VARIABLE de-valor-n-ident  AS DECIMAL               NO-UNDO.
DEFINE VARIABLE i-qtd-fones       AS INTEGER               NO-UNDO.
DEFINE VARIABLE c-servico AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD linha     AS INTEGER 
    FIELD cod-erro  AS INTEGER
    FIELD descricao AS CHARACTER FORMAT "x(100)".

DEFINE TEMP-TABLE tt-dados NO-UNDO
    FIELD cod-estabel AS CHARACTER
    FIELD nr-fatura   AS CHARACTER 
    FIELD mes-ref     AS CHARACTER
    FIELD equipamento AS CHARACTER
    FIELD plano       AS CHARACTER
    FIELD tp-serv     AS CHARACTER 
    FIELD data        AS DATE     
    FIELD hora        AS CHARACTER
    FIELD origem      AS CHARACTER
    FIELD destino     AS CHARACTER
    FIELD num-cham    AS CHARACTER
    FIELD duracao     AS CHARACTER
    FIELD valor       AS DECIMAL
    INDEX id-equipto
            cod-estabel
            nr-fatura  
            mes-ref    
            equipamento.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-relat
&Scoped-define BROWSE-NAME br-dados-fatura

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-dados tt-erro

/* Definitions for BROWSE br-dados-fatura                               */
&Scoped-define FIELDS-IN-QUERY-br-dados-fatura tt-dados.equipamento tt-dados.valor tt-dados.tp-serv tt-dados.data tt-dados.hora tt-dados.num-cham IF v-cod-fornec <> 3 THEN fn-duracao(DEC(tt-dados.duracao)) ELSE "0" @ tt-dados.duracao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-dados-fatura   
&Scoped-define SELF-NAME br-dados-fatura
&Scoped-define QUERY-STRING-br-dados-fatura FOR EACH tt-dados
&Scoped-define OPEN-QUERY-br-dados-fatura OPEN QUERY br-dados-fatura     FOR EACH tt-dados.
&Scoped-define TABLES-IN-QUERY-br-dados-fatura tt-dados
&Scoped-define FIRST-TABLE-IN-QUERY-br-dados-fatura tt-dados


/* Definitions for BROWSE br-erros                                      */
&Scoped-define FIELDS-IN-QUERY-br-erros tt-erro.linha tt-erro.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-erros   
&Scoped-define SELF-NAME br-erros
&Scoped-define QUERY-STRING-br-erros FOR EACH tt-erro
&Scoped-define OPEN-QUERY-br-erros OPEN QUERY br-erros     FOR EACH tt-erro.
&Scoped-define TABLES-IN-QUERY-br-erros tt-erro
&Scoped-define FIRST-TABLE-IN-QUERY-br-erros tt-erro


/* Definitions for FRAME f-relat                                        */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-relat ~
    ~{&OPEN-QUERY-br-dados-fatura}~
    ~{&OPEN-QUERY-br-erros}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rs-layout-febraban fi-arquivo bt-importacao ~
bt-imp bt-gravar bt-sair rs-visualizar br-dados-fatura br-erros RECT-9 ~
RECT-10 
&Scoped-Define DISPLAYED-OBJECTS rs-layout-febraban fi-arquivo ~
fi-fornecedor fi-nome-fornec fi-nr-fatura fi-periodo rs-visualizar ~
fi-valor-fatura 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-conv-dat C-Win 
FUNCTION fn-conv-dat RETURNS DATE
  ( p-valor AS CHARACTER, p-mascara AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-conv-dec C-Win 
FUNCTION fn-conv-dec RETURNS DECIMAL
  ( p-valor AS CHARACTER, p-decimais AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-conv-hor C-Win 
FUNCTION fn-conv-hor RETURNS CHARACTER
  ( p-valor AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-duracao C-Win 
FUNCTION fn-duracao RETURNS CHARACTER
  ( INPUT p-qtd-segs AS DEC )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-gravar 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "Gravar" 
     SIZE 4 BY 1 TOOLTIP "Gravar dados importados"
     FONT 1.

DEFINE BUTTON bt-imp 
     IMAGE-UP FILE "image/im-ascii.bmp":U
     LABEL "Importar" 
     SIZE 4 BY 1 TOOLTIP "Importar arquivo"
     FONT 1.

DEFINE BUTTON bt-importacao 
     IMAGE-UP FILE "image/im-sea1.bmp":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Localizar Arquivo".

DEFINE BUTTON bt-sair 
     IMAGE-UP FILE "image/im-exi.bmp":U
     LABEL "Sair" 
     SIZE 4 BY 1 TOOLTIP "Fechar o programa"
     FONT 1.

DEFINE VARIABLE fi-arquivo AS CHARACTER FORMAT "X(200)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE fi-fornecedor AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-nome-fornec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-fatura AS CHARACTER FORMAT "X(15)":U 
     LABEL "Nr. Fatura" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo AS CHARACTER FORMAT "9999/99":U INITIAL "0000/00" 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-valor-fatura AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     LABEL "Valor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE rs-layout-febraban AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Claro - Nextel - Oi - Vivo", 1,
"GVT", 2,
"Embratel", 3,
"Embratel 0800", 4,
"TIM", 5
     SIZE 55 BY 1 NO-UNDO.

DEFINE VARIABLE rs-visualizar AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Fatura", 1,
"Erros", 2
     SIZE 11 BY 2 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 14.43 BY 4.63.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76.57 BY 4.63.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-dados-fatura FOR 
      tt-dados SCROLLING.

DEFINE QUERY br-erros FOR 
      tt-erro SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-dados-fatura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-dados-fatura C-Win _FREEFORM
  QUERY br-dados-fatura DISPLAY
      tt-dados.equipamento                                 COLUMN-LABEL "Equipamento" FORMAT "x(19)"
tt-dados.valor                                       COLUMN-LABEL "Valor"       FORMAT "->>>,>>9.99"
tt-dados.tp-serv                                     COLUMN-LABEL "Serviáo"     FORMAT "x(80)" WIDTH 28
tt-dados.data                                        COLUMN-LABEL "Data"        FORMAT "99/99/9999"
tt-dados.hora                                        COLUMN-LABEL "Hora"        FORMAT "x(08)"
tt-dados.num-cham                                    COLUMN-LABEL "Nr. Chamado" FORMAT "x(19)"
IF  v-cod-fornec <> 3 THEN fn-duracao(DEC(tt-dados.duracao)) ELSE "0" @ tt-dados.duracao COLUMN-LABEL "Duraá∆o"     FORMAT "x(10)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 91.29 BY 13.75
         FONT 1.

DEFINE BROWSE br-erros
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-erros C-Win _FREEFORM
  QUERY br-erros DISPLAY
      tt-erro.linha     COLUMN-LABEL "Linha" FORMAT ">,>>>,>>9"
tt-erro.descricao COLUMN-LABEL "Erro"  FORMAT "x(90)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 91.29 BY 13.75
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     rs-layout-febraban AT ROW 1.54 COL 14.29 NO-LABEL WIDGET-ID 56
     fi-arquivo AT ROW 2.63 COL 12 COLON-ALIGNED
     fi-fornecedor AT ROW 3.75 COL 12 COLON-ALIGNED WIDGET-ID 36
     fi-nome-fornec AT ROW 3.75 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     fi-nr-fatura AT ROW 4.75 COL 12 COLON-ALIGNED WIDGET-ID 6
     fi-periodo AT ROW 4.75 COL 42 COLON-ALIGNED WIDGET-ID 4
     bt-importacao AT ROW 2.58 COL 69.14 HELP
          "Localiza Arquivo"
     bt-imp AT ROW 2.58 COL 73.14
     bt-gravar AT ROW 3.67 COL 69.14 WIDGET-ID 44
     bt-sair AT ROW 3.67 COL 73.14
     rs-visualizar AT ROW 1.75 COL 80 NO-LABEL WIDGET-ID 48
     fi-valor-fatura AT ROW 4.75 COL 57 COLON-ALIGNED WIDGET-ID 46
     br-dados-fatura AT ROW 6.17 COL 1.72 WIDGET-ID 100
     br-erros AT ROW 6.17 COL 1.72 WIDGET-ID 200
     " ParÉmetros:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 1 COL 2.72
     "Operadora:" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 1.71 COL 6.29 WIDGET-ID 60
     " Visualizar" VIEW-AS TEXT
          SIZE 9 BY .67 AT ROW 1 COL 79.29 WIDGET-ID 54
     RECT-9 AT ROW 1.38 COL 1.43
     RECT-10 AT ROW 1.38 COL 78.57 WIDGET-ID 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 92 BY 19.04
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "{&DescProg} - {&NomProg} - {&VerProg}"
         HEIGHT             = 19.04
         WIDTH              = 92
         MAX-HEIGHT         = 33.04
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 33.04
         VIRTUAL-WIDTH      = 195.14
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
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
/* BROWSE-TAB br-dados-fatura fi-valor-fatura f-relat */
/* BROWSE-TAB br-erros br-dados-fatura f-relat */
ASSIGN 
       br-dados-fatura:COLUMN-RESIZABLE IN FRAME f-relat       = TRUE
       br-dados-fatura:COLUMN-MOVABLE IN FRAME f-relat         = TRUE.

ASSIGN 
       br-erros:COLUMN-RESIZABLE IN FRAME f-relat       = TRUE
       br-erros:COLUMN-MOVABLE IN FRAME f-relat         = TRUE.

/* SETTINGS FOR FILL-IN fi-fornecedor IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nome-fornec IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nr-fatura IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-valor-fatura IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-dados-fatura
/* Query rebuild information for BROWSE br-dados-fatura
     _START_FREEFORM
OPEN QUERY br-dados-fatura
    FOR EACH tt-dados.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-dados-fatura */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-erros
/* Query rebuild information for BROWSE br-erros
     _START_FREEFORM
OPEN QUERY br-erros
    FOR EACH tt-erro.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-erros */
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
ON END-ERROR OF C-Win /* {DescProg} - {NomProg} - {VerProg} */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* {DescProg} - {NomProg} - {VerProg} */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-gravar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-gravar C-Win
ON CHOOSE OF bt-gravar IN FRAME f-relat /* Gravar */
DO:
    FIND FIRST tt-erro NO-LOCK NO-ERROR.

    IF  AVAIL tt-erro
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Gravaá∆o n∆o permitida~~Existem erros no processo de importaá∆o, verifique e corrija estes para realizar a gravaá∆o.").
        RETURN NO-APPLY.
    END.

    FIND FIRST tt-dados NO-LOCK NO-ERROR.

    IF  NOT AVAIL tt-dados
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Gravaá∆o n∆o permitida~~N∆o existem dados importados para realizar a gravaá∆o.").
        RETURN NO-APPLY.
    END.

    /* Sa°da - Heron */
    IF  CAN-FIND(FIRST tipo-servico
                 WHERE tipo-servico.tipo-serv = 0) THEN DO:
    
        OUTPUT TO value(SESSION:TEMP-DIRECTORY + 'servicos-naodefinidos.txt') NO-CONVERT.

        FOR EACH tipo-servico NO-LOCK
            WHERE tipo-servico.tipo-serv = 0:

            PUT tipo-servico.servico SKIP.
        END. /* FOR EACH tipo-servico NO-LOCK */

        OUTPUT CLOSE.
    END. /* IF  CAN-FIND(FIRST tipo-servico */

    /* Validaá∆o - Maicon */
    FOR FIRST tipo-servico NO-LOCK
        WHERE tipo-servico.tipo-serv = 0:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "PROCESSO INTERROMPIDO. Existem Serviáos sem o Tipo atribu°do." + '~~' + 
                                 "Relaá∆o dos serviáos N∆o Definidos est† no arquivo; " + CHR(10) + 
                                 caps(string(SESSION:TEMP-DIRECTORY + 'servicos-naodefinidos.txt')) +  " ." + CHR(10) + CHR(10) +
                                 "Favor classifica-los no programa ESUTP062.").

        RUN esp/utp/esutp062.w.

        RETURN NO-APPLY.

    END.

    RUN pi-gravar.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imp C-Win
ON CHOOSE OF bt-imp IN FRAME f-relat /* Importar */
DO:
    ASSIGN fi-valor-fatura = 0.

    IF  INPUT FRAME f-relat rs-layout-febraban = 2
    THEN 
        DISPLAY 0  @ fi-valor-fatura
                "" @ fi-nr-fatura
                fi-valor-fatura
                WITH FRAME f-relat.

    ASSIGN fi-arquivo = INPUT FRAME f-relat fi-arquivo.

    IF SEARCH(fi-arquivo) = ? 
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Arquivo n∆o encontrado. Favor informar um arquivo v†lido!").
        APPLY "entry" TO fi-arquivo IN FRAME f-relat.
        RETURN NO-APPLY.
    END.

    FOR EACH tt-erro:
        DELETE tt-erro.
    END.

    FOR EACH tt-dados:
        DELETE tt-dados.
    END.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar in h-acomp (input "Verificando...").

    ASSIGN v-cod-periodo = ""
           v-cod-cnpj    = ""
           v-cod-versao  = ""
           v-cod-fatura  = ""
           v-cod-fornec  = 0.

    CASE INPUT FRAME f-relat rs-layout-febraban:
        WHEN(1) THEN RUN pi-importa-febraban-v2.
        WHEN(2) THEN RUN pi-importa-febraban-v3r0.
        WHEN(3) THEN RUN pi-importa-embratel.
        WHEN(4) THEN RUN pi-importa-embratel-0800.
        WHEN(5) THEN RUN pi-importa-tim.
    END CASE.

    FIND FIRST tt-erro NO-LOCK NO-ERROR.

    IF  AVAIL tt-erro
    THEN
        ASSIGN rs-visualizar = 2.
    ELSE
        ASSIGN rs-visualizar = 1.

    IF AVAIL tt-dados THEN DO:

        FOR EACH tt-dados:

            /*IF index(tt-dados.tp-serv, "R$") <> 0 THEN
                ASSIGN c-servico = ENTRY(1, tt-dados.tp-serv, "R$").
            ELSE 
                ASSIGN c-servico = tt-dados.tp-serv.*/

            ASSIGN c-servico = tt-dados.tp-serv.

            IF tt-dados.tp-serv BEGINS "Parcela do Aparelho" THEN
                ASSIGN c-servico = "Parcela do Aparelho".

            IF tt-dados.tp-serv BEGINS "DESC 12 MESES INTERNET" THEN
                ASSIGN c-servico = "DESC 12 MESES INTERNET".

            IF tt-dados.tp-serv BEGINS "SERVIÄO DESCONTO 24" THEN
                ASSIGN c-servico = "SERVIÄO DESCONTO 24".

            IF tt-dados.tp-serv BEGINS "DESCONTO VIVO INTERNET" THEN
                ASSIGN c-servico = "DESCONTO VIVO INTERNET".

            IF tt-dados.tp-serv BEGINS "Valor Referente ao N£mero Vivo" THEN
                ASSIGN c-servico = "Valor Referente ao N£mero Vivo".

            IF NOT CAN-FIND(FIRST tipo-servico
                            WHERE tipo-servico.servico = c-servico) THEN DO:

                CREATE tipo-servico.
                ASSIGN tipo-servico.servico = c-servico
                       tipo-servico.descricao = ""
                       tipo-servico.tipo-serv = 0 /* N∆o Definido */.

            END.

        END.

        RELEASE tipo-servico.

    END.

    DISPLAY rs-visualizar WITH FRAME f-relat.
    APPLY "value-changed" TO rs-visualizar IN FRAME f-relat.

    IF  VALID-HANDLE(h-acomp)
    THEN
        RUN pi-finalizar in h-acomp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-importacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importacao C-Win
ON CHOOSE OF bt-importacao IN FRAME f-relat
DO:
    def var c-arq-conv  as char no-undo.
    def var l-ok        as logical init no.

    assign c-arq-conv ="".

    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.txt" "*.txt",
               "*.csv" "*.csv",
               "*.tab" "*.tab",
               "*.*" "*.*"
       DEFAULT-EXTENSION "txt"
       MUST-EXIST
       USE-FILENAME
       TITLE 'Importar do arquivo'
       UPDATE l-ok.

    IF l-ok THEN DO:
        assign fi-arquivo = c-arq-conv.
        display fi-arquivo with frame f-relat.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sair C-Win
ON CHOOSE OF bt-sair IN FRAME f-relat /* Sair */
DO:
  APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-fornecedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fornecedor C-Win
ON F5 OF fi-fornecedor IN FRAME f-relat /* Fornecedor */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es425.w"
                         &FieldZoom1="fornecedor"
                         &FieldScreen1="fi-fornecedor"
                         &Frame1="f-relat"
                         &FieldZoom2="nome"
                         &FieldScreen2="fi-nome-fornec"
                         &Frame2="f-relat"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fornecedor C-Win
ON LEAVE OF fi-fornecedor IN FRAME f-relat /* Fornecedor */
DO:
    ASSIGN INPUT FRAME f-relat fi-fornecedor.
    
    {include/leave.i &tabela=fornec-equipamentos
                     &atributo-ref=nome
                     &variavel-ref=fi-nome-fornec
                     &where="fornec-equipamentos.fornecedor = fi-fornecedor"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fornecedor C-Win
ON MOUSE-SELECT-DBLCLICK OF fi-fornecedor IN FRAME f-relat /* Fornecedor */
DO:
   apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-valor-fatura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-valor-fatura C-Win
ON F5 OF fi-valor-fatura IN FRAME f-relat /* Valor */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es425.w"
                         &FieldZoom1="fornecedor"
                         &FieldScreen1="fi-fornecedor"
                         &Frame1="f-relat"
                         &FieldZoom2="nome"
                         &FieldScreen2="fi-nome-fornec"
                         &Frame2="f-relat"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-valor-fatura C-Win
ON LEAVE OF fi-valor-fatura IN FRAME f-relat /* Valor */
DO:
    ASSIGN INPUT FRAME f-relat fi-fornecedor.
    
    {include/leave.i &tabela=fornec-equipamentos
                     &atributo-ref=nome
                     &variavel-ref=fi-nome-fornec
                     &where="fornec-equipamentos.fornecedor = fi-fornecedor"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-valor-fatura C-Win
ON MOUSE-SELECT-DBLCLICK OF fi-valor-fatura IN FRAME f-relat /* Valor */
DO:
   apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-layout-febraban
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-layout-febraban C-Win
ON VALUE-CHANGED OF rs-layout-febraban IN FRAME f-relat
DO:
    DISPLAY 0  @ fi-fornecedor
            0  @ fi-valor-fatura
            "" @ fi-nome-fornec
            "" @ fi-nr-fatura
            "" @ fi-arquivo
            "0000/00" @ fi-periodo 
            WITH FRAME f-relat.

    FOR EACH tt-erro:
        DELETE tt-erro.
    END.

    FOR EACH tt-dados:
        DELETE tt-dados.
    END.

    ASSIGN rs-visualizar = 1.
    DISPLAY rs-visualizar WITH FRAME f-relat.
    APPLY "value-changed" TO rs-visualizar IN FRAME f-relat.

    IF  INPUT FRAME f-relat rs-layout-febraban = 1 OR
        INPUT FRAME f-relat rs-layout-febraban = 3 OR
        INPUT FRAME f-relat rs-layout-febraban = 4 OR
        INPUT FRAME f-relat rs-layout-febraban = 5
    THEN 
        ENABLE fi-fornecedor fi-nr-fatura fi-periodo WITH FRAME f-relat.
    ELSE
        DISABLE fi-fornecedor fi-nr-fatura fi-periodo WITH FRAME f-relat.

    IF  INPUT FRAME f-relat rs-layout-febraban = 2
    THEN 
        ENABLE fi-fornecedor fi-periodo WITH FRAME f-relat.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-visualizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-visualizar C-Win
ON VALUE-CHANGED OF rs-visualizar IN FRAME f-relat
DO:
    IF  INPUT FRAME f-relat rs-visualizar = 1
    THEN DO:
        HIDE br-erros.
        VIEW br-dados-fatura.
        OPEN QUERY br-dados-fatura
            FOR EACH tt-dados.
    END.
    ELSE DO:
        HIDE br-dados-fatura.
        VIEW br-erros.
        OPEN QUERY br-erros
            FOR EACH tt-erro.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-dados-fatura
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

    ASSIGN rs-visualizar     = 1
           v-cod-equito-desc = ""
           v-cod-equito-ajus = ""
           v-cod-equito-tmp  = "".

    /* Identificar equipamento genÇrico para descontos e ajustes */
    FOR FIRST mgesp.ponto-programa
        WHERE ponto-programa.nome-programa = "esutp005"
          AND ponto-programa.ponto         = 1,
         EACH mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
            
        IF  conteudo-programa.conteudo                  <> "" AND
            NUM-ENTRIES(conteudo-programa.conteudo,";")  > 1
        THEN DO:
            IF  ENTRY(1,conteudo-programa.conteudo,";") = "DESCONTOS"
            THEN
                ASSIGN v-cod-equito-desc = ENTRY(2,conteudo-programa.conteudo,";").

            IF  ENTRY(1,conteudo-programa.conteudo,";") = "AJUSTES"
            THEN
                ASSIGN v-cod-equito-ajus = ENTRY(2,conteudo-programa.conteudo,";").

            IF  ENTRY(1,conteudo-programa.conteudo,";") = "PLANOS"
            THEN
                ASSIGN v-cod-equito-plan = ENTRY(2,conteudo-programa.conteudo,";").
        END.
    END.

    DISPLAY rs-visualizar WITH FRAME f-relat.
    APPLY "value-changed" TO rs-visualizar      IN FRAME f-relat.
    APPLY "value-changed" TO rs-layout-febraban IN FRAME f-relat.

    IF  fi-fornecedor:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-relat THEN.

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
  DISPLAY rs-layout-febraban fi-arquivo fi-fornecedor fi-nome-fornec 
          fi-nr-fatura fi-periodo rs-visualizar fi-valor-fatura 
      WITH FRAME f-relat IN WINDOW C-Win.
  ENABLE rs-layout-febraban fi-arquivo bt-importacao bt-imp bt-gravar bt-sair 
         rs-visualizar br-dados-fatura br-erros RECT-9 RECT-10 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ajustes C-Win 
PROCEDURE pi-ajustes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST equipamentos NO-LOCK
        WHERE  equipamentos.equipamento = TRIM(SUBSTRING(c-linha,79,16)) NO-ERROR.

    IF  AVAIL equipamentos 
    THEN
        ASSIGN v-cod-equito-tmp = equipamentos.equipamento.
    ELSE DO:
        FIND FIRST equipamentos NO-LOCK
            WHERE  equipamentos.equipamento = v-cod-equito-ajus NO-ERROR.

        IF  NOT AVAIL equipamentos OR
            v-cod-equito-ajus = ""
        THEN DO:
            ASSIGN i-erro = i-erro + 1.
            CREATE tt-erro.
            ASSIGN tt-erro.linha     = i-cont
                   tt-erro.cod-erro  = i-erro
                   tt-erro.descricao = "Equipamento para AJUSTES n∆o est† cadastrado no programa ES0018.".
            NEXT.
        END.
        ELSE
            ASSIGN v-cod-equito-tmp = v-cod-equito-ajus.
    END.

    IF CAN-FIND(FIRST  fatura-equipamentos NO-LOCK
                 WHERE fatura-equipamentos.cod-estabel = equipamentos.cod-estabel
                   AND fatura-equipamentos.equipamento = v-cod-equito-tmp
                   AND fatura-equipamentos.fornecedor  = v-cod-fornec
                   AND fatura-equipamentos.mes-ref     = v-cod-periodo
                   AND fatura-equipamentos.nr-fatura   = v-cod-fatura) 
    THEN DO:
        ASSIGN i-erro = i-erro + 1.
        CREATE tt-erro.
        ASSIGN tt-erro.linha     = i-cont
               tt-erro.cod-erro  = i-erro
               tt-erro.descricao = "Ja foi importado fatura para Est: " + equipamentos.cod-estabel + 
                                   " -Equipamento: " + v-cod-equito-tmp + " -Periodo: " + v-cod-periodo + " -Fatura: " + v-cod-fatura.
        NEXT.
    END.
    ELSE DO:
        IF NOT CAN-FIND(FIRST tt-dados
                        WHERE tt-dados.cod-estabel = equipamentos.cod-estabel
                          AND tt-dados.nr-fatura   = v-cod-fatura
                          AND tt-dados.mes-ref     = v-cod-periodo
                          AND tt-dados.equipamento = v-cod-equito-tmp
                          AND tt-dados.data        = fn-conv-dat(TRIM(SUBSTRING(c-linha,174,8)), "AAAAMMDD":U)
                          AND tt-dados.hora        = fn-conv-hor(TRIM(SUBSTRING(c-linha,182,6)))
                          AND tt-dados.num-cham    = ""
                          AND tt-dados.tp-serv     = TRIM(SUBSTRING(c-linha,102,40))) 
        THEN DO:
            CREATE tt-dados.
            ASSIGN tt-dados.cod-estabel = equipamentos.cod-estabel
                   tt-dados.nr-fatura   = v-cod-fatura
                   tt-dados.mes-ref     = v-cod-periodo
                   tt-dados.equipamento = v-cod-equito-tmp
                   tt-dados.data        = fn-conv-dat(TRIM(SUBSTRING(c-linha,174,8)), "AAAAMMDD":U) 
                   tt-dados.hora        = fn-conv-hor(TRIM(SUBSTRING(c-linha,182,6)))               
                   tt-dados.duracao     = "0"
                   tt-dados.num-cham    = ""
                   tt-dados.tp-serv     = TRIM(SUBSTRING(c-linha,102,40)).
        END.
        
        IF  TRIM(SUBSTRING(c-linha,160,1)) = "-"
        THEN
            ASSIGN v-val-movto = fn-conv-dec(TRIM(SUBSTRING(c-linha,161,13)),2) * -1.
        ELSE
            ASSIGN v-val-movto = fn-conv-dec(TRIM(SUBSTRING(c-linha,161,13)),2).

        ASSIGN tt-dados.valor  = tt-dados.valor  + v-val-movto
               fi-valor-fatura = fi-valor-fatura + v-val-movto.

        DISPLAY fi-valor-fatura WITH FRAME f-relat.
    END. /* ELSE IF CAN-FIND(FIRST fatura-equipamentos NO-LOCK */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gravar C-Win 
PROCEDURE pi-gravar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE v-val-fatura-equipto  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE cont-fat-equip        AS INTEGER     NO-UNDO.

    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 27100,
                       INPUT "Confirma gravaá∆o da fatura?").

    IF  RETURN-VALUE = "yes"
    THEN DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        RUN pi-inicializar in h-acomp (input "Gravando Informaá‰es...").

        ASSIGN v-val-fatura-equipto = 0.
        
        FOR EACH tt-dados NO-LOCK 
            BREAK BY tt-dados.cod-estabel
                  BY tt-dados.equipamento
                  BY tt-dados.mes-ref
                  BY tt-dados.nr-fatura:
            
            IF  FIRST-OF(tt-dados.equipamento) THEN ASSIGN cont-fat-equip = cont-fat-equip + 1.
        END.

        FOR EACH tt-dados 
            BREAK BY tt-dados.cod-estabel
                  BY tt-dados.equipamento
                  BY tt-dados.mes-ref
                  BY tt-dados.nr-fatura:

                RUN pi-acompanhar IN h-acomp (INPUT " Equip.: " + STRING(tt-dados.equipamento)).   

            FIND FIRST telefonia EXCLUSIVE-LOCK
                 WHERE telefonia.cod-estabel = tt-dados.cod-estabel
                   AND telefonia.fornecedor  = v-cod-fornec
                   AND telefonia.nr-fatura   = tt-dados.nr-fatura
                   AND telefonia.mes-ref     = tt-dados.mes-ref
                   AND telefonia.servico     = tt-dados.tp-serv
                   AND telefonia.plano       = tt-dados.plano
                   AND telefonia.equipamento = tt-dados.equipamento
                   AND telefonia.data        = tt-dados.data
                   AND telefonia.hora        = tt-dados.hora
                   AND telefonia.numero      = tt-dados.num-cham NO-ERROR.

            IF NOT AVAIL telefonia THEN DO:
                CREATE telefonia.
                ASSIGN telefonia.cod-estabel = tt-dados.cod-estabel
                       telefonia.fornecedor  = v-cod-fornec
                       telefonia.nr-fatura   = tt-dados.nr-fatura
                       telefonia.mes-ref     = tt-dados.mes-ref
                       telefonia.servico     = tt-dados.tp-serv
                       telefonia.plano       = tt-dados.plano
                       telefonia.equipamento = tt-dados.equipamento
                       telefonia.data        = tt-dados.data
                       telefonia.hora        = tt-dados.hora
                       telefonia.numero      = tt-dados.num-cham
                       telefonia.destino     = tt-dados.destino
                       telefonia.duracao     = IF v-cod-fornec <> 3 THEN STRING(int(DEC(tt-dados.duracao) * 60),"hh:mm:ss") ELSE tt-dados.duracao
                       telefonia.origem      = tt-dados.origem
                       telefonia.valor       = tt-dados.valor.
            END. /* IF NOT AVAIL telefonia */
            ELSE DO:
                ASSIGN v-num-segs = 0.

                IF  NUM-ENTRIES(telefonia.duracao,":") = 3
                THEN
                    ASSIGN v-num-segs = INT(ENTRY(1,telefonia.duracao,":")) * 3600
                           v-num-segs = v-num-segs + INT(ENTRY(2,telefonia.duracao,":")) * 60
                           v-num-segs = v-num-segs + INT(ENTRY(3,telefonia.duracao,":")).

                IF  NUM-ENTRIES(tt-dados.duracao,":") = 3
                THEN
                    ASSIGN v-num-segs = v-num-segs + INT(ENTRY(1,tt-dados.duracao,":")) * 3600
                           v-num-segs = v-num-segs + INT(ENTRY(2,tt-dados.duracao,":")) * 60
                           v-num-segs = v-num-segs + INT(ENTRY(3,tt-dados.duracao,":")).

                ASSIGN telefonia.duracao = STRING(v-num-segs,"hh:mm:ss")
                       telefonia.valor   = telefonia.valor   + tt-dados.valor. 
            END.

            RELEASE telefonia.

            ASSIGN v-val-fatura-equipto = v-val-fatura-equipto + tt-dados.valor. 

            IF  LAST-OF(tt-dados.nr-fatura) 
            THEN DO:
                RUN pi-acompanhar IN h-acomp (INPUT "Fatura: " + STRING(tt-dados.nr-fatura) + " Equip.: " + STRING(tt-dados.equipamento)).

                CREATE fatura-equipamentos.
                ASSIGN fatura-equipamentos.cod-estabel = tt-dados.cod-estabel
                       fatura-equipamentos.equipamento = tt-dados.equipamento
                       fatura-equipamentos.fornecedor  = v-cod-fornec
                       fatura-equipamentos.mes-ref     = tt-dados.mes-ref    
                       fatura-equipamentos.nr-fatura   = tt-dados.nr-fatura  
                       fatura-equipamentos.val-fatura  = IF v-cod-fornec = 4 THEN v-val-fatura-equipto + (de-valor-n-ident / cont-fat-equip) ELSE v-val-fatura-equipto.
                       fatura-equipamentos.manual      = NO.

                RELEASE fatura-equipamentos.
                ASSIGN v-val-fatura-equipto = 0.
                       
                       
            END. /* IF  LAST-OF(tt-dados.nr-fatura) */
        END. /* FOR EACH tt-dados */
        ASSIGN de-valor-n-ident = 0.

        RUN pi-finalizar in h-acomp.

        EMPTY TEMP-TABLE tt-dados.
        EMPTY TEMP-TABLE tt-erro.

        APPLY "value-changed" TO rs-visualizar IN FRAME f-relat.
        
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 15825,
                           INPUT "Gravaá∆o concluida").
        
    END. /* IF  RETURN-VALUE = "yes" */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa-embratel C-Win 
PROCEDURE pi-importa-embratel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dt-data AS DATE      NO-UNDO.
    DEFINE VARIABLE c-duracao AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE de-valor  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-equipamento AS CHARACTER   NO-UNDO.
    
    ASSIGN i-cont        = 0
           i-erro        = 0
           v-cod-fornec  = INPUT FRAME f-relat fi-fornecedor
           v-cod-periodo = INPUT FRAME f-relat fi-periodo
           v-cod-fatura  = INPUT FRAME f-relat fi-nr-fatura.

    IF (INT(v-cod-periodo) = 0 OR
        v-cod-fornec       = 0 OR
        v-cod-fatura       = "")
    THEN DO:
        RUN pi-finalizar in h-acomp.
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Fornecedor, per°odo ou fatura inv†lidos.~~Preencha corretamente estas informaá‰es em tela.").
        RETURN.
    END.

    RUN pi-inicializar in h-acomp (input "Importando Faturas...").

    INPUT FROM VALUE(fi-arquivo) NO-CONVERT.

    REPEAT:
        IMPORT UNFORMATTED c-linha.

        ASSIGN i-cont = i-cont + 1.

        RUN pi-acompanhar IN h-acomp (INPUT "EMBRATEL - Linha: " + STRING(i-cont)).
        IF i-cont = 1 THEN DO:
            ASSIGN dt-data = DATE(ENTRY(4,c-linha,";")) NO-ERROR.
            IF NUM-ENTRIES(c-linha,";") <> 16 OR ERROR-STATUS:ERROR THEN DO:
                ASSIGN i-erro = i-erro + 1.
                CREATE tt-erro.
                ASSIGN tt-erro.linha     = 0
                       tt-erro.cod-erro  = i-erro
                       tt-erro.descricao = "Layout do Fornecedor nao confere com layout do arquivo informado.".
                RETURN "NOK".
            END.
        END.

        ASSIGN dt-data  = DATE(ENTRY(4,c-linha,";")) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            ASSIGN i-erro = i-erro + 1.
            CREATE tt-erro.
            ASSIGN tt-erro.linha     = i-cont
                   tt-erro.cod-erro  = i-erro
                   tt-erro.descricao = "Nao foi possivel converter campo data: " + ENTRY(8,c-linha,";") + ".".
        END.

        ASSIGN c-duracao    = STRING(INT(DEC(entry(13,c-linha,";")) * 60)) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            ASSIGN i-erro = i-erro + 1.
            CREATE tt-erro.
            ASSIGN tt-erro.linha     = i-cont
                   tt-erro.cod-erro  = i-erro
                   tt-erro.descricao = "Nao foi possivel converter campo duracao: " + ENTRY(12,c-linha,";") + ".".
        END.

        ASSIGN de-valor = DEC(ENTRY(15,c-linha,";")) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            ASSIGN i-erro = i-erro + 1.
            CREATE tt-erro.
            ASSIGN tt-erro.linha     = i-cont
                   tt-erro.cod-erro  = i-erro
                   tt-erro.descricao = "Nao foi possivel converter campo valor: " + ENTRY(15,c-linha,";") + ".".
        END.
        
        ASSIGN c-equipamento = TRIM(ENTRY(2,c-linha,";"))
               c-equipamento = REPLACE(c-equipamento," ","").

        IF INDEX(c-equipamento,"-") <> 0 THEN DO:
            FIND FIRST equipamentos NO-LOCK
                 WHERE equipamentos.equipamento = SUBSTRING(ENTRY(2,c-equipamento,"-"),1,10) NO-ERROR.
            IF NOT AVAIL equipamentos THEN 
                FIND FIRST equipamentos NO-LOCK
                     WHERE equipamentos.equipamento = ENTRY(1,c-equipamento,"-") NO-ERROR.
                
            IF AVAIL equipamentos THEN ASSIGN c-equipamento = equipamentos.equipamento.
            
        END.
        ELSE DO:
            FIND FIRST equipamentos NO-LOCK
                 WHERE equipamentos.equipamento = SUBSTRING(c-equipamento,1,10) NO-ERROR.
            IF NOT AVAIL equipamento THEN
                FIND FIRST equipamentos NO-LOCK
                     WHERE equipamentos.equipamento = SUBSTRING(c-equipamento,LENGTH(c-equipamento) - 10,11) NO-ERROR.
            IF AVAIL equipamentos THEN
                ASSIGN c-equipamento = equipamentos.equipamento.
        END.
            

        FIND FIRST equipamentos NO-LOCK
             WHERE equipamentos.equipamento = c-equipamento NO-ERROR.
        IF NOT AVAIL equipamentos THEN DO:
            ASSIGN i-erro = i-erro + 1.
            CREATE tt-erro.
            ASSIGN tt-erro.linha     = i-cont
                   tt-erro.cod-erro  = i-erro
                   tt-erro.descricao = "Equipamento: " + STRING(c-equipamento) + " nao cadastrado.".
        END.
        ELSE IF CAN-FIND(FIRST fatura-equipamentos NO-LOCK
                         WHERE fatura-equipamentos.cod-estabel = equipamentos.cod-estabel
                           AND fatura-equipamentos.equipamento = equipamentos.equipamento
                           AND fatura-equipamentos.fornecedor  = v-cod-fornec
                           AND fatura-equipamentos.mes-ref     = v-cod-periodo
                           AND fatura-equipamentos.nr-fatura   = v-cod-fatura) THEN DO:
            ASSIGN i-erro = i-erro + 1.
            CREATE tt-erro.
            ASSIGN tt-erro.linha     = i-cont
                   tt-erro.cod-erro  = i-erro
                   tt-erro.descricao = "Ja foi importado fatura para Est: " + equipamentos.cod-estabel + 
                                       " -Equipamento: " + equipamentos.equipamento + " -Periodo:" + v-cod-periodo + " -Fatura: " + v-cod-fatura.
        END.
        ELSE DO:
            CREATE tt-dados.
            ASSIGN tt-dados.cod-estabel = equipamentos.cod-estabel 
                   tt-dados.data        = dt-data
                   tt-dados.mes-ref     = v-cod-periodo
                   tt-dados.nr-fatura   = v-cod-fatura
                   tt-dados.duracao     = c-duracao
                   tt-dados.equipamento = c-equipamento
                   tt-dados.plano       = entry(7,c-linha,";")
                   tt-dados.tp-serv     = entry(3,c-linha,";")
                   tt-dados.hora        = entry(9,c-linha,";")
                   tt-dados.origem      = entry(11,c-linha,";")
                   tt-dados.destino     = entry(12,c-linha,";")
                   tt-dados.num-cham    = entry(6,c-linha,";")
                   tt-dados.valor       = de-valor
                   fi-valor-fatura      = fi-valor-fatura + de-valor.

            DISPLAY fi-valor-fatura WITH FRAME f-relat.
        END.
    END.
    INPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa-embratel-0800 C-Win 
PROCEDURE pi-importa-embratel-0800 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dt-data       AS DATE        NO-UNDO.
    DEFINE VARIABLE c-duracao     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE de-valor      AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-equipamento AS CHARACTER   NO-UNDO.

    ASSIGN i-cont        = 0
           i-erro        = 0
           v-cod-fornec  = INPUT FRAME f-relat fi-fornecedor
           v-cod-periodo = INPUT FRAME f-relat fi-periodo
           v-cod-fatura  = INPUT FRAME f-relat fi-nr-fatura.

    IF (INT(v-cod-periodo) = 0 OR
        v-cod-fornec       = 0 OR
        v-cod-fatura       = "")
    THEN DO:
        RUN pi-finalizar in h-acomp.
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Fornecedor, per°odo ou fatura inv†lidos.~~Preencha corretamente estas informaá‰es em tela.").
        RETURN.
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Importando Faturas...":U).

    INPUT FROM VALUE(fi-arquivo) NO-CONVERT.
    REPEAT:
        IMPORT UNFORMATTED c-linha.

        ASSIGN c-linha = REPLACE(c-linha,CHR(34),"").

        ASSIGN i-cont = i-cont + 1.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "0800 Embratel - Linha: ":U + STRING(i-cont)).

        IF NUM-ENTRIES(c-linha, ";":U) < 9 OR 
           NUM-ENTRIES(c-linha, ";":U) > 10
        THEN DO:
            CREATE tt-erro.
            ASSIGN i-erro            = i-erro + 1
                   tt-erro.linha     = i-cont
                   tt-erro.cod-erro  = i-erro
                   tt-erro.descricao = "Layout do Fornecedor nao confere com layout do arquivo informado.".
            LEAVE.
        END.

        ASSIGN dt-data = DATE(TRIM(ENTRY(1, c-linha, ";":U))) NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            CREATE tt-erro.
            ASSIGN i-erro            = i-erro + 1
                   tt-erro.linha     = i-cont
                   tt-erro.cod-erro  = i-erro
                   tt-erro.descricao = "Campo ~"Data~" inv†lida. Linha: ":U + STRING(i-cont).
        END.

        ASSIGN c-duracao = STRING(INTEGER(DECIMAL(TRIM(ENTRY(5, c-linha, ";":U))) * 60)) NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            CREATE tt-erro.
            ASSIGN i-erro            = i-erro + 1
                   tt-erro.linha     = i-cont
                   tt-erro.cod-erro  = i-erro
                   tt-erro.descricao = "":U.
        END.

        ASSIGN de-valor = DECIMAL(TRIM(ENTRY(9, c-linha, ";":U))) NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            CREATE tt-erro.
            ASSIGN i-erro            = i-erro + 1
                   tt-erro.linha     = i-cont
                   tt-erro.cod-erro  = i-erro
                   tt-erro.descricao = "Campo ~"Valor~" inv†lido. Linha: ":U + STRING(i-cont).
        END.

        IF  de-valor <> 0
        THEN
            ASSIGN de-valor = de-valor / 0.7135. /* Acrescenter impostos */
        
        ASSIGN c-equipamento = TRIM(ENTRY(7, c-linha, ";":U))
               c-equipamento = REPLACE(c-equipamento, " ":U, "":U).

        IF INDEX(c-equipamento, "-":U) <> 0 THEN DO:
            FIND FIRST equipamentos
                WHERE equipamentos.equipamento = SUBSTRING(ENTRY(2, c-equipamento, "-":U), 1, 10) NO-LOCK NO-ERROR.

            IF NOT AVAILABLE equipamentos THEN
                FIND FIRST equipamentos
                    WHERE equipamentos.equipamento = ENTRY(1, c-equipamento, "-":U) NO-LOCK NO-ERROR.

            IF AVAILABLE equipamentos THEN
                ASSIGN c-equipamento = equipamentos.equipamento.
        END.
        ELSE DO:
            FIND FIRST equipamentos
                WHERE equipamentos.equipamento = SUBSTRING(c-equipamento, 1, 10) NO-LOCK NO-ERROR.

            IF NOT AVAILABLE equipamento THEN
                FIND FIRST equipamentos
                    WHERE equipamentos.equipamento = SUBSTRING(c-equipamento, LENGTH(c-equipamento) - 10, 11) NO-LOCK NO-ERROR.

            IF AVAILABLE equipamentos THEN
                ASSIGN c-equipamento = equipamentos.equipamento.
        END.

        FIND FIRST equipamentos
            WHERE equipamentos.equipamento = c-equipamento NO-LOCK NO-ERROR.

        IF NOT AVAILABLE equipamentos THEN DO:
            CREATE tt-erro.
            ASSIGN i-erro            = i-erro + 1
                   tt-erro.linha     = i-cont
                   tt-erro.cod-erro  = i-erro
                   tt-erro.descricao = "Campo ~"Equipamento~" inv†lido. Linha: ":U + STRING(i-cont).
        END.
        ELSE IF CAN-FIND(FIRST fatura-equipamentos NO-LOCK
                         WHERE fatura-equipamentos.cod-estabel = equipamentos.cod-estabel
                           AND fatura-equipamentos.equipamento = equipamentos.equipamento
                           AND fatura-equipamentos.fornecedor  = v-cod-fornec
                           AND fatura-equipamentos.mes-ref     = v-cod-periodo
                           AND fatura-equipamentos.nr-fatura   = v-cod-fatura) THEN DO:
            CREATE tt-erro.
            ASSIGN i-erro            = i-erro + 1
                   tt-erro.linha     = i-cont
                   tt-erro.cod-erro  = i-erro
                   tt-erro.descricao = "J† foi importado fatura para: ":U +
                                       "Estab: ":U   + equipamentos.cod-estabel + " - ":U +
                                       "Equip: ":U   + equipamentos.equipamento + " - ":U +
                                       "Periodo: ":U + v-cod-periodo + " - ":U +
                                       "Fatura: ":U  + v-cod-fatura + ". Linha: ":U + STRING(i-cont).
        END.

        IF NOT CAN-FIND(FIRST tt-erro
                        WHERE tt-erro.linha = i-cont) THEN DO:
            CREATE tt-dados.
            ASSIGN tt-dados.cod-estabel = equipamentos.cod-estabel 
                   tt-dados.data        = dt-data
                   tt-dados.mes-ref     = v-cod-periodo
                   tt-dados.nr-fatura   = v-cod-fatura
                   tt-dados.duracao     = c-duracao
                   tt-dados.equipamento = c-equipamento
                   tt-dados.plano       = TRIM(ENTRY(8, c-linha, ";":U))
                   tt-dados.tp-serv     = TRIM(ENTRY(6, c-linha, ";":U))
                   tt-dados.hora        = TRIM(ENTRY(2, c-linha, ";":U))
                   tt-dados.origem      = TRIM(ENTRY(4, c-linha, ";":U))
                   tt-dados.destino     = "":U
                   tt-dados.num-cham    = TRIM(ENTRY(3, c-linha, ";":U))
                   tt-dados.valor       = de-valor 
                   fi-valor-fatura      = fi-valor-fatura + de-valor.

            DISPLAY fi-valor-fatura WITH FRAME f-relat.
        END.
    END.
    INPUT CLOSE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa-febraban-v2 C-Win 
PROCEDURE pi-importa-febraban-v2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN pi-inicializar in h-acomp (input "Importando Fatura...").

    INPUT FROM VALUE(fi-arquivo) NO-CONVERT.
    
    ASSIGN i-cont = 0 
           i-erro = 0.
                                 

    REPEAT:
        IMPORT UNFORMATTED c-linha.
        
        ASSIGN i-cont = i-cont + 1.

        RUN pi-acompanhar IN h-acomp (INPUT "Linha: " + STRING(i-cont)).

        IF  i-cont = 2
        THEN DO:
            IF  v-cod-versao =  "V3R0" /* Vers∆o de layout febraban */
            THEN DO:
                RUN pi-finalizar in h-acomp.
                INPUT CLOSE.
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Layout divergente.~~ A vers∆o do layout no arquivo est† incompat°vel com a vers∆o do sistema importador, podem ocorrer erros de importaá∆o. Contate a TIC para validar o layout.").
                LEAVE.
            END.
        END.

        CASE SUBSTRING(c-linha,1,1):
            /* Tipo 0 - Header */
            WHEN("0")
            THEN
                ASSIGN v-cod-periodo = INPUT FRAME f-relat fi-periodo
                       v-cod-versao  = TRIM(SUBSTRING(c-linha,165,4))
                       v-cod-fatura  = INPUT FRAME f-relat fi-nr-fatura
                       v-cod-fornec  = INPUT FRAME f-relat fi-fornecedor.

            /* Tipo 3 - Bilhetaá∆o */
            WHEN "3":U 
            THEN DO:
                RUN pi-valida-fatura-equipto (INPUT  TRIM(SUBSTRING(c-linha,  60,  2)) + TRIM(SUBSTRING(c-linha,  62, 10)),
                                              INPUT  v-cod-fornec, 
                                              INPUT  v-cod-periodo,
                                              INPUT  v-cod-fatura,
                                              OUTPUT v-log-erro-imp).
                IF  v-log-erro-imp = NO
                THEN DO:
                    IF NOT CAN-FIND(FIRST tt-dados
                                    WHERE tt-dados.cod-estabel = equipamentos.cod-estabel
                                      AND tt-dados.nr-fatura   = v-cod-fatura
                                      AND tt-dados.mes-ref     = v-cod-periodo
                                      AND tt-dados.equipamento = equipamentos.equipamento
                                      AND tt-dados.data        = fn-conv-dat(TRIM(SUBSTRING(c-linha,  89,  8)), "AAAAMMDD":U)
                                      AND tt-dados.hora        = fn-conv-hor(TRIM(SUBSTRING(c-linha, 231,  6)))
                                      AND tt-dados.num-cham    = TRIM(SUBSTRING(c-linha, 153,  3)) + TRIM(SUBSTRING(c-linha, 156,  4)) + TRIM(SUBSTRING(c-linha, 160, 10))
                                      AND tt-dados.tp-serv     = TRIM(SUBSTRING(c-linha, 181,  50))) THEN DO:
                        CREATE tt-dados.
                        ASSIGN tt-dados.cod-estabel = equipamentos.cod-estabel
                               tt-dados.nr-fatura   = v-cod-fatura
                               tt-dados.mes-ref     = v-cod-periodo
                               tt-dados.equipamento = equipamentos.equipamento
                               tt-dados.data        = fn-conv-dat(TRIM(SUBSTRING(c-linha,  89,  8)), "AAAAMMDD":U)
                               tt-dados.hora        = fn-conv-hor(TRIM(SUBSTRING(c-linha, 231,  6)))
                               tt-dados.num-cham    =             TRIM(SUBSTRING(c-linha, 153,  3)) + TRIM(SUBSTRING(c-linha, 156,  4)) + TRIM(SUBSTRING(c-linha, 160, 10))
                               tt-dados.tp-serv     =             TRIM(SUBSTRING(c-linha, 181,  50)).
                    END.

                    IF TRIM(SUBSTRING(c-linha, 266, 1)) = "-":U THEN
                        ASSIGN v-val-movto = fn-conv-dec(TRIM(SUBSTRING(c-linha, 272, 13)), 2) * -1.
                    ELSE
                        ASSIGN v-val-movto = fn-conv-dec(TRIM(SUBSTRING(c-linha, 272, 13)), 2).

                    ASSIGN tt-dados.duracao = STRING(DECIMAL(tt-dados.duracao) + fn-conv-dec(TRIM(SUBSTRING(c-linha, 172,  6)), 1))
                           tt-dados.valor   = tt-dados.valor  + v-val-movto
                           fi-valor-fatura  = fi-valor-fatura + v-val-movto.

                    DISPLAY fi-valor-fatura WITH FRAME f-relat.
                END.
            END. /* WHEN "3":U */

            /* Tipo 4 - Serviáos */
            WHEN "4":U 
            THEN DO:
                if TRIM(SUBSTRING(c-linha,  60,  2)) + TRIM(SUBSTRING(c-linha,  62, 10)) <> "" then do:
                RUN pi-valida-fatura-equipto (INPUT  TRIM(SUBSTRING(c-linha,  60,  2)) + TRIM(SUBSTRING(c-linha,  62, 10)),
                                              INPUT  v-cod-fornec, 
                                              INPUT  v-cod-periodo,
                                              INPUT  v-cod-fatura,
                                              OUTPUT v-log-erro-imp).
                IF  v-log-erro-imp = NO
                THEN DO:
                    IF NOT CAN-FIND(FIRST tt-dados
                                    WHERE tt-dados.cod-estabel = equipamentos.cod-estabel
                                      AND tt-dados.nr-fatura   = v-cod-fatura
                                      AND tt-dados.mes-ref     = v-cod-periodo
                                      AND tt-dados.equipamento = equipamentos.equipamento
                                      AND tt-dados.data        = fn-conv-dat(TRIM(SUBSTRING(c-linha,  87,  8)), "AAAAMMDD":U)
                                      AND tt-dados.hora        = fn-conv-hor(TRIM(SUBSTRING(c-linha, 176,  6)))
                                      AND tt-dados.num-cham    = TRIM(SUBSTRING(c-linha, 151,  3)) + TRIM(SUBSTRING(c-linha, 154,  4)) + TRIM(SUBSTRING(c-linha, 158, 10))
                                      AND tt-dados.tp-serv     = TRIM(SUBSTRING(c-linha, 218, 40))) THEN DO:
                        CREATE tt-dados.
                        ASSIGN tt-dados.cod-estabel = equipamentos.cod-estabel
                               tt-dados.nr-fatura   = v-cod-fatura
                               tt-dados.mes-ref     = v-cod-periodo
                               tt-dados.equipamento = equipamentos.equipamento
                               tt-dados.data        = fn-conv-dat(TRIM(SUBSTRING(c-linha,  87,  8)), "AAAAMMDD":U)
                               tt-dados.hora        = fn-conv-hor(TRIM(SUBSTRING(c-linha, 176,  6)))
                               tt-dados.num-cham    =             TRIM(SUBSTRING(c-linha, 151,  3)) + TRIM(SUBSTRING(c-linha, 154,  4)) + TRIM(SUBSTRING(c-linha, 158, 10))
                               tt-dados.tp-serv     =             TRIM(SUBSTRING(c-linha, 218, 40)).

                        IF  tt-dados.tp-serv = ""
                        THEN
                            ASSIGN tt-dados.tp-serv = TRIM(SUBSTRING(c-linha, 185, 30)).

                    END.

                    IF TRIM(SUBSTRING(c-linha, 258, 1)) = "-":U THEN
                        ASSIGN v-val-movto = fn-conv-dec(TRIM(SUBSTRING(c-linha, 259, 13)), 2) * -1.
                    ELSE
                        ASSIGN v-val-movto = fn-conv-dec(TRIM(SUBSTRING(c-linha, 259, 13)), 2).

                    ASSIGN tt-dados.duracao = STRING(DECIMAL(tt-dados.duracao) + fn-conv-dec(TRIM(SUBSTRING(c-linha, 170,  6)), 1))
                           tt-dados.valor   = tt-dados.valor + v-val-movto
                           fi-valor-fatura  = fi-valor-fatura + v-val-movto.

                    DISPLAY fi-valor-fatura WITH FRAME f-relat.
                END.
                END.
                ELSE DO:
                    IF TRIM(SUBSTRING(c-linha, 258, 1)) = "-":U THEN
                        ASSIGN v-val-movto = fn-conv-dec(TRIM(SUBSTRING(c-linha, 259, 13)), 2) * -1.
                    ELSE
                        ASSIGN v-val-movto = fn-conv-dec(TRIM(SUBSTRING(c-linha, 259, 13)), 2).


                    ASSIGN de-valor-n-ident  = de-valor-n-ident + v-val-movto
                           fi-valor-fatura  = fi-valor-fatura + v-val-movto.

                        DISPLAY fi-valor-fatura WITH FRAME f-relat.
                END.
            END. /* WHEN "4":U */

            /* Tipo 5 - Descontos */
            WHEN "5":U 
            THEN DO:
                FIND FIRST equipamentos NO-LOCK
                    WHERE  equipamentos.equipamento = TRIM(SUBSTRING(c-linha,  85,  2)) + TRIM(SUBSTRING(c-linha,  87, 10)) NO-ERROR.

                IF  AVAIL equipamentos 
                THEN
                    ASSIGN v-cod-equito-tmp = equipamentos.equipamento.
                ELSE DO:
                    FIND FIRST equipamentos NO-LOCK
                        WHERE  equipamentos.equipamento = v-cod-equito-desc NO-ERROR.

                    IF  NOT AVAIL equipamentos OR
                        v-cod-equito-desc = ""
                    THEN DO:
                        ASSIGN i-erro = i-erro + 1.
                        CREATE tt-erro.
                        ASSIGN tt-erro.linha     = i-cont
                               tt-erro.cod-erro  = i-erro
                               tt-erro.descricao = "Equipamento para DESCONTOS n∆o est† cadastrado no programa ES0018.".
                        NEXT.
                    END.
                    ELSE
                        ASSIGN v-cod-equito-tmp = v-cod-equito-desc.
                END.
                    
                IF CAN-FIND(FIRST fatura-equipamentos NO-LOCK
                                 WHERE fatura-equipamentos.cod-estabel = equipamentos.cod-estabel
                                   AND fatura-equipamentos.equipamento = v-cod-equito-tmp
                                   AND fatura-equipamentos.fornecedor  = v-cod-fornec
                                   AND fatura-equipamentos.mes-ref     = v-cod-periodo
                                   AND fatura-equipamentos.nr-fatura   = v-cod-fatura) 
                THEN DO:
                    ASSIGN i-erro = i-erro + 1.
                    CREATE tt-erro.
                    ASSIGN tt-erro.linha     = i-cont
                           tt-erro.cod-erro  = i-erro
                           tt-erro.descricao = "Ja foi importado fatura para Est: " + equipamentos.cod-estabel + 
                                               " -Equipamento: " + v-cod-equito-tmp + " -Periodo:" + v-cod-periodo + " -Fatura: " + v-cod-fatura.
                    NEXT.
                END.
                ELSE DO:
                    IF NOT CAN-FIND(FIRST tt-dados
                                    WHERE tt-dados.cod-estabel = equipamentos.cod-estabel
                                      AND tt-dados.nr-fatura   = v-cod-fatura
                                      AND tt-dados.mes-ref     = v-cod-periodo
                                      AND tt-dados.equipamento = v-cod-equito-tmp
                                      AND tt-dados.data        = fn-conv-dat(TRIM(SUBSTRING(c-linha, 212,  8)), "AAAAMMDD":U)
                                      AND tt-dados.hora        = fn-conv-hor(TRIM(SUBSTRING(c-linha, 220,  6)))
                                      AND tt-dados.num-cham    = "":U
                                      AND tt-dados.tp-serv     = TRIM(SUBSTRING(c-linha, 100, 80))) THEN DO:
                        CREATE tt-dados.
                        ASSIGN tt-dados.cod-estabel = equipamentos.cod-estabel
                               tt-dados.nr-fatura   = v-cod-fatura
                               tt-dados.mes-ref     = v-cod-periodo
                               tt-dados.equipamento = v-cod-equito-tmp
                               tt-dados.data        = fn-conv-dat(TRIM(SUBSTRING(c-linha, 212,  8)), "AAAAMMDD":U)
                               tt-dados.hora        = fn-conv-hor(TRIM(SUBSTRING(c-linha, 220,  6)))
                               tt-dados.duracao     = STRING(DECIMAL("0":U))
                               tt-dados.num-cham    = "":U
                               tt-dados.tp-serv     =             TRIM(SUBSTRING(c-linha, 100, 80)).
                    END.

                    IF TRIM(SUBSTRING(c-linha, 180, 1)) = "-":U THEN
                        ASSIGN v-val-movto = fn-conv-dec(TRIM(SUBSTRING(c-linha, 199, 13)), 2) * -1.
                    ELSE
                        ASSIGN v-val-movto = fn-conv-dec(TRIM(SUBSTRING(c-linha, 199, 13)), 2).

                    ASSIGN tt-dados.valor  = tt-dados.valor  + v-val-movto
                           fi-valor-fatura = fi-valor-fatura + v-val-movto.

                    DISPLAY fi-valor-fatura WITH FRAME f-relat.
                END.
            END. /* WHEN "5":U */
        END CASE.

        IF  i-cont             = 1 AND
           (INT(v-cod-periodo) = 0 OR
            v-cod-fornec       = 0 OR
            v-cod-fatura       = "")
        THEN DO:
            RUN pi-finalizar in h-acomp.
            INPUT CLOSE.
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Fornecedor, per°odo ou fatura inv†lidos.~~O arquivo informado n∆o possui os dados b†sicos da fatura para importaá∆o. Contate a TIC para validar o layout do arquivo.").
            LEAVE.
        END.
    END. /* REPEAT */
    INPUT CLOSE.

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa-febraban-v3r0 C-Win 
PROCEDURE pi-importa-febraban-v3r0 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN pi-inicializar in h-acomp (input "Importando Fatura...").

    INPUT FROM VALUE(fi-arquivo) NO-CONVERT.
    
    ASSIGN i-cont        = 0 
           i-erro        = 0
           v-cod-periodo = INPUT FRAME f-relat fi-periodo.

    IF  INT(v-cod-periodo) = 0
    THEN DO:
        RUN pi-finalizar in h-acomp.
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Per°odo inv†lido.~~Preencha corretamente esta informaá∆o em tela.").
        RETURN.
    END.

    REPEAT:
        IMPORT UNFORMATTED c-linha.

        ASSIGN i-cont         = i-cont + 1
               v-log-erro-imp = NO.

        RUN pi-acompanhar IN h-acomp (INPUT "Linha: " + STRING(i-cont)).

        IF  i-cont = 2
        THEN DO:
            IF  v-cod-versao <> "V3R0" /* Vers∆o de layout febraban */
            THEN DO:
                RUN pi-finalizar in h-acomp.
                INPUT CLOSE.
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Layout divergente.~~ A vers∆o do layout no arquivo est† incompat°vel com a vers∆o do sistema importador, podem ocorrer erros de importaá∆o. Contate a TIC para validar o layout.").
                LEAVE.
            END.
            DISPLAY v-cod-fatura  @ fi-nr-fatura WITH FRAME f-relat.
        END.

        CASE SUBSTRING(c-linha,1,2):
            /* Tipo 00 - Header */
            WHEN("00")
            THEN
                ASSIGN v-cod-periodo = INPUT FRAME f-relat fi-periodo
                       v-cod-cnpj    = TRIM(SUBSTRING(c-linha,89,14))
                       v-cod-versao  = TRIM(SUBSTRING(c-linha,165,4))
                       v-cod-fatura  = STRING(INT(TRIM(SUBSTRING(c-linha,169,16))))
                       v-cod-fornec  = INPUT FRAME f-relat fi-fornecedor.

            /* Tipo 30 - Chamadas */
            WHEN "30":U 
            THEN DO:
                RELEASE tt-dados.
                RUN pi-valida-fatura-equipto (INPUT  TRIM(SUBSTRING(c-linha,84,16)),
                                              INPUT  v-cod-fornec, 
                                              INPUT  v-cod-periodo,
                                              INPUT  v-cod-fatura,
                                              OUTPUT v-log-erro-imp).
                IF  v-log-erro-imp = NO
                THEN DO:
                    FIND FIRST tt-dados
                         WHERE tt-dados.cod-estabel = equipamentos.cod-estabel
                           AND tt-dados.nr-fatura   = v-cod-fatura
                           AND tt-dados.mes-ref     = v-cod-periodo
                           AND tt-dados.equipamento = equipamentos.equipamento
                           AND tt-dados.data        = fn-conv-dat(TRIM(SUBSTRING(c-linha,100,8)), "AAAAMMDD":U)
                           AND tt-dados.hora        = fn-conv-hor(TRIM(SUBSTRING(c-linha,227,6)))
                           AND tt-dados.num-cham    = TRIM(SUBSTRING(c-linha,164,17))
                           AND tt-dados.tp-serv     = TRIM(SUBSTRING(c-linha,202,25)) NO-ERROR.
                    IF  NOT AVAIL tt-dados
                    THEN DO:
                        CREATE tt-dados.
                        ASSIGN tt-dados.cod-estabel = equipamentos.cod-estabel                                 
                               tt-dados.nr-fatura   = v-cod-fatura                                             
                               tt-dados.mes-ref     = v-cod-periodo                                            
                               tt-dados.equipamento = equipamentos.equipamento                                 
                               tt-dados.data        = fn-conv-dat(TRIM(SUBSTRING(c-linha,100,8)), "AAAAMMDD":U)
                               tt-dados.hora        = fn-conv-hor(TRIM(SUBSTRING(c-linha,227,6)))    
                               tt-dados.duracao     = "0"
                               tt-dados.num-cham    = TRIM(SUBSTRING(c-linha,164,17))                          
                               tt-dados.tp-serv     = TRIM(SUBSTRING(c-linha,202,25)).
                    END.
                    ASSIGN v-val-movto      = fn-conv-dec(TRIM(SUBSTRING(c-linha,238,13)),2)
                           tt-dados.duracao = STRING(INTEGER(tt-dados.duracao) + INTEGER(TRIM(SUBSTRING(c-linha,189,7))))
                           tt-dados.valor   = tt-dados.valor  + v-val-movto
                           fi-valor-fatura  = fi-valor-fatura + v-val-movto.

                    DISPLAY fi-valor-fatura WITH FRAME f-relat.
                END. /* IF  v-log-erro-imp = NO */
            END. /* WHEN "30":U  */

            /* Tipo 40 - Serviáos */
            WHEN "40":U 
            THEN DO:
                RELEASE tt-dados.
                RUN pi-valida-fatura-equipto (INPUT  TRIM(SUBSTRING(c-linha,84,16)),
                                              INPUT  v-cod-fornec, 
                                              INPUT  v-cod-periodo,
                                              INPUT  v-cod-fatura,
                                              OUTPUT v-log-erro-imp).
                IF  v-log-erro-imp = NO
                THEN DO:
                    FIND FIRST tt-dados
                         WHERE tt-dados.cod-estabel = equipamentos.cod-estabel
                           AND tt-dados.nr-fatura   = v-cod-fatura
                           AND tt-dados.mes-ref     = v-cod-periodo
                           AND tt-dados.equipamento = equipamentos.equipamento
                           AND tt-dados.data        = fn-conv-dat(TRIM(SUBSTRING(c-linha,100,8)), "AAAAMMDD":U)
                           AND tt-dados.hora        = fn-conv-hor(TRIM(SUBSTRING(c-linha,143,6)))              
                           AND tt-dados.num-cham    = TRIM(SUBSTRING(c-linha,110,17))                          
                           AND tt-dados.tp-serv     = TRIM(SUBSTRING(c-linha,155,25)) NO-ERROR.
                    
                    IF  NOT AVAIL tt-dados
                    THEN DO:
                        CREATE tt-dados.
                        ASSIGN tt-dados.cod-estabel = equipamentos.cod-estabel
                               tt-dados.nr-fatura   = v-cod-fatura
                               tt-dados.mes-ref     = v-cod-periodo
                               tt-dados.equipamento = equipamentos.equipamento
                               tt-dados.data        = fn-conv-dat(TRIM(SUBSTRING(c-linha,100,8)), "AAAAMMDD":U)
                               tt-dados.hora        = fn-conv-hor(TRIM(SUBSTRING(c-linha,143,6)))
                               tt-dados.duracao     = "0"
                               tt-dados.num-cham    = TRIM(SUBSTRING(c-linha,110,17))
                               tt-dados.tp-serv     = TRIM(SUBSTRING(c-linha,155,25))
                               tt-dados.plano       = TRIM(SUBSTRING(c-linha,155,25)).
                    END.
                    ASSIGN v-val-movto     = fn-conv-dec(TRIM(SUBSTRING(c-linha,180,13)),2)
                           tt-dados.valor  = tt-dados.valor  + v-val-movto
                           fi-valor-fatura = fi-valor-fatura + v-val-movto.
                    DISPLAY fi-valor-fatura WITH FRAME f-relat.
                END. /* IF  v-log-erro-imp = NO */
            END. /* WHEN "40":U */

            /* Tipo 50 - Descontos */
            WHEN "50":U 
            THEN DO:
                FIND FIRST equipamentos NO-LOCK
                    WHERE  equipamentos.equipamento = TRIM(SUBSTRING(c-linha,79,16)) NO-ERROR.

                IF  AVAIL equipamentos 
                THEN
                    ASSIGN v-cod-equito-tmp = equipamentos.equipamento.
                ELSE DO:
                    FIND FIRST equipamentos NO-LOCK
                        WHERE  equipamentos.equipamento = v-cod-equito-desc NO-ERROR.

                    IF  NOT AVAIL equipamentos OR
                        v-cod-equito-desc = ""
                    THEN DO:
                        ASSIGN i-erro = i-erro + 1.
                        CREATE tt-erro.
                        ASSIGN tt-erro.linha     = i-cont
                               tt-erro.cod-erro  = i-erro
                               tt-erro.descricao = "Equipamento para DESCONTOS n∆o est† cadastrado no programa ES0018.".
                        NEXT.
                    END.
                    ELSE
                        ASSIGN v-cod-equito-tmp = v-cod-equito-desc.
                END.

                IF CAN-FIND(FIRST  fatura-equipamentos NO-LOCK
                             WHERE fatura-equipamentos.cod-estabel = equipamentos.cod-estabel
                               AND fatura-equipamentos.equipamento = v-cod-equito-tmp
                               AND fatura-equipamentos.fornecedor  = v-cod-fornec
                               AND fatura-equipamentos.mes-ref     = v-cod-periodo
                               AND fatura-equipamentos.nr-fatura   = v-cod-fatura) 
                THEN DO:
                    ASSIGN i-erro = i-erro + 1.
                    CREATE tt-erro.
                    ASSIGN tt-erro.linha     = i-cont
                           tt-erro.cod-erro  = i-erro
                           tt-erro.descricao = "Ja foi importado fatura para Est: " + equipamentos.cod-estabel + 
                                               " -Equipamento: " + v-cod-equito-tmp + " -Periodo: " + v-cod-periodo + " -Fatura: " + v-cod-fatura.
                    NEXT.
                END.
                ELSE DO:
                    IF NOT CAN-FIND(FIRST tt-dados
                                    WHERE tt-dados.cod-estabel = equipamentos.cod-estabel
                                      AND tt-dados.nr-fatura   = v-cod-fatura
                                      AND tt-dados.mes-ref     = v-cod-periodo
                                      AND tt-dados.equipamento = v-cod-equito-tmp
                                      AND tt-dados.data        = fn-conv-dat(TRIM(SUBSTRING(c-linha,172,8)), "AAAAMMDD":U)
                                      AND tt-dados.hora        = fn-conv-hor(TRIM(SUBSTRING(c-linha,180,6)))
                                      AND tt-dados.num-cham    = ""
                                      AND tt-dados.tp-serv     = TRIM(SUBSTRING(c-linha,102,25))) 
                    THEN DO:
                        CREATE tt-dados.
                        ASSIGN tt-dados.cod-estabel = equipamentos.cod-estabel
                               tt-dados.nr-fatura   = v-cod-fatura
                               tt-dados.mes-ref     = v-cod-periodo
                               tt-dados.equipamento = v-cod-equito-tmp
                               tt-dados.data        = fn-conv-dat(TRIM(SUBSTRING(c-linha,172,8)), "AAAAMMDD":U)
                               tt-dados.hora        = fn-conv-hor(TRIM(SUBSTRING(c-linha,180,6)))
                               tt-dados.duracao     = "0"
                               tt-dados.num-cham    = ""
                               tt-dados.tp-serv     = TRIM(SUBSTRING(c-linha,102,25)).
                    END.

                    ASSIGN v-val-movto     = (fn-conv-dec(TRIM(SUBSTRING(c-linha,159,13)),2) * -1)
                           tt-dados.valor  = tt-dados.valor  + v-val-movto
                           fi-valor-fatura = fi-valor-fatura + v-val-movto.
                    DISPLAY fi-valor-fatura WITH FRAME f-relat.
                END. /* ELSE IF CAN-FIND(FIRST fatura-equipamentos NO-LOCK */
            END. /* WHEN "50":U */


            /* Tipo 60 - Planos */
            WHEN "60":U 
            THEN DO:
                RUN pi-planos.
            END. /* WHEN "60":U */

            /* Tipo 70 - AJUSTES */
            WHEN "70":U 
            THEN DO:
                RUN pi-ajustes.
            END. /* WHEN "70":U */
        END CASE.

        IF  i-cont             = 1 AND
           (INT(v-cod-periodo) = 0 OR
            v-cod-fornec       = 0 OR
            v-cod-fatura       = "")
        THEN DO:
            RUN pi-finalizar in h-acomp.
            INPUT CLOSE.
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Fornecedor, per°odo ou fatura inv†lidos.~~O arquivo informado n∆o possui os dados b†sicos da fatura para importaá∆o. Contate a TIC para validar o layout do arquivo.").
            LEAVE.
        END.
    END. /* REPEAT: */
    INPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa-tim C-Win 
PROCEDURE pi-importa-tim :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-linha       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-cont        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-erro        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE dt-data       AS DATE        NO-UNDO.
    DEFINE VARIABLE de-valor      AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-equipamento AS CHARACTER   NO-UNDO.

    ASSIGN i-cont        = 0
           i-erro        = 0
           v-cod-fornec  = INPUT FRAME f-relat fi-fornecedor
           v-cod-periodo = INPUT FRAME f-relat fi-periodo
           v-cod-fatura  = INPUT FRAME f-relat fi-nr-fatura.

    IF (INT(v-cod-periodo) = 0 OR
        v-cod-fornec       = 0 OR
        v-cod-fatura       = "")
    THEN DO:
        RUN pi-finalizar in h-acomp.
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Fornecedor, per°odo ou fatura inv†lidos.~~Preencha corretamente estas informaá‰es em tela.").
        RETURN.
    END.

    RUN pi-inicializar in h-acomp (input "Importando Faturas...").
    
    INPUT FROM VALUE(fi-arquivo) NO-CONVERT.
    
    ASSIGN i-cont = 0
           i-erro = 0.

    REPEAT:
        IMPORT UNFORMATTED c-linha.

        ASSIGN i-cont = i-cont + 1.

        RUN pi-acompanhar IN h-acomp (INPUT "TIM - Linha: " + STRING(i-cont)).

        /*Ignora primeira linha, layout do arquivo*/
        IF i-cont = 1 OR 
           (TRIM(ENTRY(4,c-linha,CHR(9))) <> "" AND 
            TRIM(ENTRY(7,c-linha,CHR(9))) = "Total de Uso") THEN NEXT.

        IF NUM-ENTRIES(c-linha,CHR(9)) < 20 THEN DO:
            ASSIGN i-erro = i-erro + 1.
            CREATE tt-erro.
            ASSIGN tt-erro.cod-erro  = i-erro
                   tt-erro.descricao = "Layout do Fornecedor nao confere com layout do arquivo informado, favor verificar.".
            RETURN "NOK".
        END.
        
        ASSIGN dt-data  = DATE(ENTRY(8,c-linha,CHR(9))) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            ASSIGN i-erro = i-erro + 1.
            CREATE tt-erro.
            ASSIGN tt-erro.cod-erro  = i-erro
                   tt-erro.descricao = "Linha: " + STRING(i-cont) + " nao foi possivel converter campo data: " + ENTRY(8,c-linha,CHR(9)) + ".".
        END.

        ASSIGN de-valor = DEC(ENTRY(15,c-linha,CHR(9))) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            ASSIGN i-erro = i-erro + 1.
            CREATE tt-erro.
            ASSIGN tt-erro.cod-erro  = i-erro
                   tt-erro.descricao = "Linha: " + STRING(i-cont) + " nao foi possivel converter campo valor: " + ENTRY(15,c-linha,CHR(9)) + ".".
        END.

        IF de-valor <> ? THEN DO:       

            IF SUBSTRING(entry(4,c-linha,CHR(9)),1,1) = "0" THEN
                ASSIGN c-equipamento = replace(entry(4,c-linha,CHR(9)),"-","")
                       c-equipamento = SUBSTRING(c-equipamento,2,LENGTH(c-equipamento)).
            ELSE
                ASSIGN c-equipamento = replace(entry(4,c-linha,CHR(9)),"-","").

            IF c-equipamento = "" THEN DO:
                IF SUBSTRING(entry(7,c-linha,CHR(9)),1,35) = "Total de Assinatura do Plano Acesso" THEN DO:
                    ASSIGN c-equipamento = TRIM(SUBSTRING(entry(7,c-linha,CHR(9)),36,30)) 
                           c-equipamento = replace(c-equipamento,"-","")
                           c-equipamento = SUBSTRING(c-equipamento,2,LENGTH(c-equipamento)).
                END.
                ELSE NEXT.
            END.

            FIND FIRST equipamentos NO-LOCK
                 WHERE equipamentos.equipamento = c-equipamento NO-ERROR.
            IF  NOT AVAIL equipamentos 
            THEN DO:
                ASSIGN i-erro = i-erro + 1.
                CREATE tt-erro.
                ASSIGN tt-erro.linha     = i-cont
                       tt-erro.cod-erro  = i-erro
                       tt-erro.descricao = "Equipamento: " + c-equipamento + " nao cadastrado. " + 
                                           (IF TRIM(ENTRY(4,c-linha,CHR(9))) <> "" 
                                            THEN TRIM(ENTRY(4,c-linha,CHR(9))) 
                                            ELSE TRIM(entry(7,c-linha,CHR(9)))).
            END.
            ELSE IF CAN-FIND(FIRST fatura-equipamentos NO-LOCK
                             WHERE fatura-equipamentos.cod-estabel = equipamentos.cod-estabel
                               AND fatura-equipamentos.equipamento = equipamentos.equipamento
                               AND fatura-equipamentos.fornecedor  = v-cod-fornec
                               AND fatura-equipamentos.mes-ref     = v-cod-periodo
                               AND fatura-equipamentos.nr-fatura   = v-cod-fatura) THEN DO:
                ASSIGN i-erro = i-erro + 1.
                CREATE tt-erro.
                ASSIGN tt-erro.linha     = i-cont
                       tt-erro.cod-erro  = i-erro
                       tt-erro.descricao = "Ja foi importado fatura para Est: " + equipamentos.cod-estabel + 
                                           " -Equipamento: " + equipamentos.equipamento + " -Periodo:" + v-cod-periodo + " -Fatura: " + v-cod-fatura.
            END.
            ELSE DO:
                CREATE tt-dados.
                ASSIGN tt-dados.cod-estabel = equipamentos.cod-estabel
                       tt-dados.equipamento = c-equipamento
                       tt-dados.plano       = entry(5,c-linha,CHR(9))
                       tt-dados.tp-serv     = entry(7,c-linha,CHR(9))
                       tt-dados.data        = dt-data
                       tt-dados.valor       = de-valor
                       tt-dados.hora        = entry(9,c-linha,CHR(9))
                       tt-dados.origem      = entry(10,c-linha,CHR(9))
                       tt-dados.destino     = entry(11,c-linha,CHR(9))
                       tt-dados.num-cham    = replace(entry(12,c-linha,CHR(9)),"-","")
                       tt-dados.duracao     = entry(14,c-linha,CHR(9))
                       tt-dados.mes-ref     = v-cod-periodo
                       tt-dados.nr-fatura   = v-cod-fatura
                       fi-valor-fatura      = fi-valor-fatura + de-valor.

                DISPLAY fi-valor-fatura WITH FRAME f-relat.
            END.
        END.
    END.

    INPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-planos C-Win 
PROCEDURE pi-planos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST equipamentos NO-LOCK
        WHERE  equipamentos.equipamento = TRIM(SUBSTRING(c-linha,79,16)) NO-ERROR.

    IF  AVAIL equipamentos 
    THEN
        ASSIGN v-cod-equito-tmp = equipamentos.equipamento.
    ELSE DO:
        FIND FIRST equipamentos NO-LOCK
            WHERE  equipamentos.equipamento = v-cod-equito-plan NO-ERROR.

        IF  NOT AVAIL equipamentos OR
            v-cod-equito-plan = ""
        THEN DO:
            ASSIGN i-erro = i-erro + 1.
            CREATE tt-erro.
            ASSIGN tt-erro.linha     = i-cont
                   tt-erro.cod-erro  = i-erro
                   tt-erro.descricao = "Equipamento para PLANOS n∆o est† cadastrado no programa ES0018.".
            NEXT.
        END.
        ELSE
            ASSIGN v-cod-equito-tmp = v-cod-equito-plan.
    END.

    IF CAN-FIND(FIRST  fatura-equipamentos NO-LOCK
                 WHERE fatura-equipamentos.cod-estabel = equipamentos.cod-estabel
                   AND fatura-equipamentos.equipamento = v-cod-equito-tmp
                   AND fatura-equipamentos.fornecedor  = v-cod-fornec
                   AND fatura-equipamentos.mes-ref     = v-cod-periodo
                   AND fatura-equipamentos.nr-fatura   = v-cod-fatura) 
    THEN DO:
        ASSIGN i-erro = i-erro + 1.
        CREATE tt-erro.
        ASSIGN tt-erro.linha     = i-cont
               tt-erro.cod-erro  = i-erro
               tt-erro.descricao = "Ja foi importado fatura para Est: " + equipamentos.cod-estabel + 
                                   " -Equipamento: " + v-cod-equito-tmp + " -Periodo: " + v-cod-periodo + " -Fatura: " + v-cod-fatura.
        NEXT.
    END.
    ELSE DO:
        IF NOT CAN-FIND(FIRST tt-dados
                        WHERE tt-dados.cod-estabel = equipamentos.cod-estabel
                          AND tt-dados.nr-fatura   = v-cod-fatura
                          AND tt-dados.mes-ref     = v-cod-periodo
                          AND tt-dados.equipamento = v-cod-equito-tmp
                          AND tt-dados.data        = fn-conv-dat(TRIM(SUBSTRING(c-linha,96,8)), "AAAAMMDD":U)
                          AND tt-dados.hora        = fn-conv-hor("0")
                          AND tt-dados.num-cham    = ""
                          AND tt-dados.tp-serv     = TRIM(SUBSTRING(c-linha,192,25))) 
        THEN DO:
            CREATE tt-dados.
            ASSIGN tt-dados.cod-estabel = equipamentos.cod-estabel
                   tt-dados.nr-fatura   = v-cod-fatura
                   tt-dados.mes-ref     = v-cod-periodo
                   tt-dados.equipamento = v-cod-equito-tmp
                   tt-dados.data        = fn-conv-dat(TRIM(SUBSTRING(c-linha,96,8)), "AAAAMMDD":U)
                   tt-dados.hora        = fn-conv-hor("0")
                   tt-dados.duracao     = "0"
                   tt-dados.num-cham    = ""
                   tt-dados.tp-serv     = TRIM(SUBSTRING(c-linha,192,25)).
        END.

        ASSIGN v-val-movto     = fn-conv-dec(TRIM(SUBSTRING(c-linha,217,13)),2)
               tt-dados.valor  = tt-dados.valor  + v-val-movto
               fi-valor-fatura = fi-valor-fatura + v-val-movto.
        DISPLAY fi-valor-fatura WITH FRAME f-relat.
    END. /* ELSE IF CAN-FIND(FIRST fatura-equipamentos NO-LOCK */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-fatura-equipto C-Win 
PROCEDURE pi-valida-fatura-equipto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT  PARAMETER p-cod-equipto AS CHAR NO-UNDO. 
    DEFINE INPUT  PARAMETER p-cod-fornec  AS INT  NO-UNDO. 
    DEFINE INPUT  PARAMETER p-cod-periodo AS CHAR  NO-UNDO. 
    DEFINE INPUT  PARAMETER p-cod-fatura  AS CHAR NO-UNDO. 
    DEFINE OUTPUT PARAMETER p-log-erro AS LOG   NO-UNDO.

     

    FIND FIRST equipamentos NO-LOCK
        WHERE  equipamentos.equipamento = p-cod-equipto NO-ERROR.

    IF NOT AVAIL equipamentos THEN DO:
        IF trim(SUBSTRING(c-linha, 218, 21)) = "Consumo Compartilhado" THEN DO:
               FOR EACH tt-dados NO-LOCK
                  BREAK BY tt-dados.cod-estabel 
                        BY tt-dados.nr-fatura   
                        BY tt-dados.mes-ref     
                        BY tt-dados.equipamento :

                  IF  FIRST-OF(tt-dados.equipamento) THEN
                        ASSIGN i-qtd-fones = i-qtd-fones + 1.
               END.
               FOR EACH tt-dados EXCLUSIVE-LOCK
                    BREAK BY tt-dados.cod-estabel 
                          BY tt-dados.nr-fatura   
                          BY tt-dados.mes-ref     
                          BY tt-dados.equipamento :
                        
                    IF  FIRST-OF(tt-dados.equipamento) THEN
                        ASSIGN tt-dados.valor  = tt-dados.valor + (de-valor-n-ident / i-qtd-fones).
                       
               END. 
        END.
        ELSE DO:
            ASSIGN i-erro     = i-erro + 1
                   p-log-erro = YES.
            CREATE tt-erro.
            ASSIGN tt-erro.linha     = i-cont
                   tt-erro.cod-erro  = i-erro
                   tt-erro.descricao = "Equipamento: " + p-cod-equipto + " nao cadastrado.".
        END.
    END.
    ELSE DO:
        IF CAN-FIND(FIRST  fatura-equipamentos NO-LOCK
                     WHERE fatura-equipamentos.cod-estabel = equipamentos.cod-estabel
                       AND fatura-equipamentos.equipamento = equipamentos.equipamento
                       AND fatura-equipamentos.fornecedor  = v-cod-fornec
                       AND fatura-equipamentos.mes-ref     = v-cod-periodo
                       AND fatura-equipamentos.nr-fatura   = v-cod-fatura) 
        THEN DO:
            ASSIGN i-erro     = i-erro + 1
                   p-log-erro = YES.
            CREATE tt-erro.
            ASSIGN tt-erro.linha     = i-cont
                   tt-erro.cod-erro  = i-erro
                   tt-erro.descricao = "Ja foi importado fatura para Est: " + equipamentos.cod-estabel + 
                                       " -Equipamento: " + equipamentos.equipamento + " -Periodo: " + v-cod-periodo + " -Fatura: " + v-cod-fatura.
        END.
    END.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-conv-dat C-Win 
FUNCTION fn-conv-dat RETURNS DATE
  ( p-valor AS CHARACTER, p-mascara AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-pos-year    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-pos-month   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-pos-day     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-length-year AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-year-aux    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-month-aux   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-day-aux     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE dt-aux        AS DATE        NO-UNDO.

    IF LENGTH(p-mascara) = 6 THEN
        ASSIGN i-length-year = 2.
    ELSE IF LENGTH(p-mascara) = 8 THEN
        ASSIGN i-length-year = 4.
    ELSE
        RETURN ?.

    CASE p-mascara:
        WHEN "DDMMAA":U   OR
        WHEN "DDMMAAAA":U OR
        WHEN "DDMMYY":U   OR
        WHEN "DDMMYYYY":U THEN DO:
            ASSIGN i-pos-year  = 5
                   i-pos-month = 3
                   i-pos-day   = 1.
        END.
        WHEN "MMDDAA":U   OR
        WHEN "MMDDAAAA":U OR
        WHEN "MMDDYY":U   OR
        WHEN "MMDDYYYY":U THEN DO:
            ASSIGN i-pos-year  = 5
                   i-pos-month = 1
                   i-pos-day   = 3.
        END.
        WHEN "AAMMDD":U   OR
        WHEN "AAAAMMDD":U OR
        WHEN "YYMMDD":U   OR
        WHEN "YYYYMMDD":U THEN DO:
            ASSIGN i-pos-year  = 1.

            IF i-length-year = 2 THEN
                ASSIGN i-pos-month = 3
                       i-pos-day   = 5.
            ELSE IF i-length-year = 4 THEN
                ASSIGN i-pos-month = 5
                       i-pos-day   = 7.
            ELSE
                RETURN ?.
        END.
        OTHERWISE
            RETURN ?.
    END CASE.

    ASSIGN i-year-aux = INTEGER(SUBSTRING(p-valor, i-pos-year, i-length-year)) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN ?.

    ASSIGN i-month-aux = INTEGER(SUBSTRING(p-valor, i-pos-month, 2)) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN ?.

    ASSIGN i-day-aux = INTEGER(SUBSTRING(p-valor, i-pos-day, 2)) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN ?.

    ASSIGN dt-aux = DATE(i-month-aux, i-day-aux, i-year-aux) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN ?.
    ELSE
        RETURN dt-aux.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-conv-dec C-Win 
FUNCTION fn-conv-dec RETURNS DECIMAL
  ( p-valor AS CHARACTER, p-decimais AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE de-aux AS DECIMAL     NO-UNDO.

    ASSIGN p-valor = TRIM(REPLACE(REPLACE(p-valor, ".":U, "":U), ",":U, "":U)).

    ASSIGN de-aux = DECIMAL(SUBSTRING(p-valor, 1, LENGTH(p-valor) - p-decimais)) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN ?.

    ASSIGN de-aux = de-aux + (DECIMAL(SUBSTRING(p-valor, (LENGTH(p-valor) - p-decimais) + 1, 2)) / EXP(10, p-decimais)) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN ?.

    RETURN de-aux.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-conv-hor C-Win 
FUNCTION fn-conv-hor RETURNS CHARACTER
  ( p-valor AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    ASSIGN p-valor = TRIM(p-valor).

    IF INDEX(p-valor, ":":U) <> 0 THEN
        RETURN p-valor.

    IF LENGTH(p-valor) = 4 THEN
        RETURN SUBSTRING(p-valor, 1, 2) + ":":U + SUBSTRING(p-valor, 3, 2).
    ELSE IF LENGTH(p-valor) = 6 THEN
        RETURN SUBSTRING(p-valor, 1, 2) + ":":U + SUBSTRING(p-valor, 3, 2) + ":":U + SUBSTRING(p-valor, 5, 2).
    ELSE
        RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-duracao C-Win 
FUNCTION fn-duracao RETURNS CHARACTER
  ( INPUT p-qtd-segs AS DEC ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE v-qtd-horas    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v-qtd-minutos  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v-qtd-segundos AS INTEGER     NO-UNDO.
    
    IF  p-qtd-segs <> ? AND
        p-qtd-segs > 0
    THEN DO:
        ASSIGN v-qtd-horas    = TRUNCATE(p-qtd-segs / 3600, 0)
               p-qtd-segs     = p-qtd-segs - (v-qtd-horas * 3600)
               v-qtd-minutos  = TRUNCATE(p-qtd-segs / 60, 0)
               v-qtd-segundos = p-qtd-segs - (v-qtd-minutos * 60).
    
        RETURN STRING(v-qtd-horas,">99") + ":" + STRING(v-qtd-minutos,"99") + ":" + STRING(v-qtd-segundos,"99").   
    END.
    ELSE
        RETURN "0".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

