&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
&SCOPED-DEFINE NomProg   ESUTP050
&SCOPED-DEFINE DescProg  Importaá∆o Correios

DEFINE VARIABLE c-periodo       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-dir-arquivo   AS CHARACTER FORMAT "x(100)"  NO-UNDO.
DEFINE VARIABLE i-reg-fatura    AS INTEGER   NO-UNDO.
DEFINE VARIABLE de-valor-fatura AS DECIMAL   NO-UNDO.
DEFINE VARIABLE h-acomp         AS HANDLE NO-UNDO.

DEFINE VARIABLE i-linha AS INTEGER  NO-UNDO.
DEFINE VARIABLE c-linha AS CHARACTER FORMAT "x(78)"  NO-UNDO.

DEFINE VARIABLE c-fatura       AS CHARACTER FORMAT "x(11)"  NO-UNDO.
DEFINE VARIABLE c-contrato     AS CHARACTER FORMAT "x(11)"  NO-UNDO.
DEFINE VARIABLE c-origem       AS CHARACTER FORMAT "x(30)"  NO-UNDO.
DEFINE VARIABLE i-cliente      AS INTEGER                   NO-UNDO.
DEFINE VARIABLE c-nr-cartao    AS CHARACTER FORMAT "x(10)"  NO-UNDO.
DEFINE VARIABLE c-cc-codigo AS CHARACTER FORMAT "x(55)"  NO-UNDO.

DEFINE VARIABLE de-desconto AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-erro      AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-valor-total AS DECIMAL     NO-UNDO.

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

DEFINE VARIABLE hProgramZoom AS HANDLE         NO-UNDO.
DEFINE VARIABLE l-implanta   AS LOGICAL        NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa  AS WIDGET-HANDLE  NO-UNDO.

DEFINE BUFFER b-tt-dados-post FOR tt-dados-post.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-relat

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-estabel fi-periodo fi-arquivo ~
bt-importacao bt-fechar bt-executar RECT-10 RECT-2 RECT-9 
&Scoped-Define DISPLAYED-OBJECTS fi-estabel fi-nome-estabel fi-periodo ~
fi-arquivo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
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

DEFINE VARIABLE fi-arquivo AS CHARACTER FORMAT "X(100)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 52 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabel AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE fi-nome-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo AS CHARACTER FORMAT "9999/99":U INITIAL "000000" 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66.86 BY 4.25.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 66.86 BY 1.54
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66.86 BY 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     fi-estabel AT ROW 1.88 COL 12.29 COLON-ALIGNED WIDGET-ID 36
     fi-nome-estabel AT ROW 1.88 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     fi-periodo AT ROW 2.88 COL 12.29 COLON-ALIGNED WIDGET-ID 4
     fi-arquivo AT ROW 6.38 COL 9 COLON-ALIGNED
     bt-importacao AT ROW 6.29 COL 63.29 HELP
          "Localiza Arquivo"
     bt-fechar AT ROW 8.29 COL 13.72
     bt-executar AT ROW 8.29 COL 2
     "ParÉmetros:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 5.42 COL 4
          FONT 6
     "Envio:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 1 COL 4
          FONT 6
     RECT-10 AT ROW 1 COL 1
     RECT-2 AT ROW 8 COL 1
     RECT-9 AT ROW 5.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 67 BY 8.58
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
         HEIGHT             = 8.58
         WIDTH              = 67
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
/* SETTINGS FOR FILL-IN fi-nome-estabel IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

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


&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar C-Win
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
    ASSIGN c-dir-arquivo = INPUT FRAME f-relat fi-arquivo
           c-periodo     = INPUT FRAME f-relat fi-periodo.
    
    IF c-periodo = "000000" OR LENGTH(c-periodo) <> 6 THEN DO:
        MESSAGE "Per°odo inv†lido, Ç obrigat¢rio informar o per°odo AAAAMM!"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        APPLY "entry" TO fi-periodo IN FRAME f-relat.
        RETURN NO-APPLY.
    END.
    ELSE DO:
        IF INT(SUBSTRING(c-periodo,5,2)) < 0 OR
           INT(SUBSTRING(c-periodo,5,2)) > 12 THEN DO:
            MESSAGE "Màs do Per°odo Ç inv†lido, favor informar màs v†lido!"
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            APPLY "entry" TO fi-periodo IN FRAME f-relat.
            RETURN NO-APPLY.
        END.
    END.

    IF SEARCH(c-dir-arquivo) = ? THEN DO:
        MESSAGE "Arquivo n∆o encontrado. Favor informar um arquivo v†lido!"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        APPLY "entry" TO fi-arquivo IN FRAME f-relat.
        RETURN NO-APPLY.
    END.
    
    FIND FIRST correios NO-LOCK
        WHERE correios.mes-ref = c-periodo NO-ERROR.
    IF AVAIL correios THEN DO:
        MESSAGE "Per°odo informado j† foi importado, favor verificar o per°odo!"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        APPLY "entry" TO fi-arquivo IN FRAME f-relat.
        RETURN NO-APPLY.
    END.
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar in h-acomp (input "Verificaá∆o...").

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
    def var c-arq-conv  as char no-undo.
    def var l-ok        as logical init no.

    assign c-arq-conv ="".

    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.txt" "*.txt",
               "*.csv" "*.csv",
               "*.*" "*.*"
       DEFAULT-EXTENSION "csv"
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


&Scoped-define SELF-NAME fi-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estabel C-Win
ON F5 OF fi-estabel IN FRAME f-relat /* Estabelecimento */
DO:
  
   {include/zoomvar.i &prog-zoom="adzoom/z01Ad107.w"
                       &campo=fi-estabel
                       &campozoom=cod-estabel
                       &campo2=fi-nome-estabel  
                       &campozoom2=nome
                       &Frame=f-relat}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estabel C-Win
ON LEAVE OF fi-estabel IN FRAME f-relat /* Estabelecimento */
DO:
    ASSIGN INPUT FRAME f-relat fi-estabel.
    
    {include/leave.i &tabela=estabelec
                     &atributo-ref=nome
                     &variavel-ref=fi-nome-estabel
                     &where="estabelec.cod-estabel = string(fi-estabel)"}  
                     
   
                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estabel C-Win
ON MOUSE-SELECT-DBLCLICK OF fi-estabel IN FRAME f-relat /* Estabelecimento */
DO:
   apply "F5":U to self.
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

    ASSIGN fi-periodo:SCREEN-VALUE IN FRAME f-relat = STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99").

    fi-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME f-relat.

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
  DISPLAY fi-estabel fi-nome-estabel fi-periodo fi-arquivo 
      WITH FRAME f-relat IN WINDOW C-Win.
  ENABLE fi-estabel fi-periodo fi-arquivo bt-importacao bt-fechar bt-executar 
         RECT-10 RECT-2 RECT-9 
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
   
    IF NOT CAN-FIND(FIRST tt-erro NO-LOCK) 
    THEN DO:
         MESSAGE "Arquivo com "  TRIM(STRING(i-reg-fatura,">>>,>>>,>>9")) " registros, totalizando um valor de: " TRIM(STRING(de-valor-fatura,">>>,>>>,>>>,>>9.99")) SKIP
                 "Confirma importaá∆o?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
             TITLE "Importaá∆o" UPDATE l-confirma AS LOGICAL.
    
         IF l-confirma 
         THEN DO:
             RUN pi-inicializar in h-acomp (input "Gravando Informaá‰es...").
    
             ASSIGN de-total-fatura = 0
                    l-erros         = NO.

             BLOCO:
             DO TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO :
                 FOR EACH tt-dados-post:
    
                     RUN pi-acompanhar in h-acomp (input "Gerando Tabela Correios : " + tt-dados-post.nr-cartao ).
    
                     FIND FIRST correios NO-LOCK WHERE
                                correios.cod-estabel = INPUT FRAME f-relat fi-estabel AND
                                correios.mes-ref     = INPUT FRAME f-relat fi-periodo AND
                                correios.nr-contrato = tt-dados-post.nr-contrato AND
                                correios.nr-fatura   = tt-dados-post.nr-fatura   AND
                                correios.cod-cliente = tt-dados-post.cod-cliente AND
                                correios.nr-cartao   = tt-dados-post.nr-cartao   AND
                                correios.servico     = tt-dados-post.servico     AND 
                                correios.dt-postagem = tt-dados-post.dt-postagem AND
                                correios.nr-docto    = tt-dados-post.nr-docto    NO-ERROR.
                     IF NOT AVAIL correios THEN DO:
                        CREATE correios.       
                        ASSIGN correios.cod-estabel       = INPUT FRAME f-relat fi-estabel
                               correios.mes-ref           = INPUT FRAME f-relat fi-periodo   
                               correios.nr-contrato       = tt-dados-post.nr-contrato
                               correios.nr-fatura         = tt-dados-post.nr-fatura  
                               correios.cod-cliente       = tt-dados-post.cod-cliente
                               correios.nr-cartao         = tt-dados-post.nr-cartao  
                               correios.servico           = tt-dados-post.servico    
                               correios.dt-postagem       = tt-dados-post.dt-postagem
                               correios.nr-docto          = tt-dados-post.nr-docto 
                               correios.peso              = tt-dados-post.peso       
                               correios.qtde              = tt-dados-post.qtde       
                               correios.valor             = tt-dados-post.valor 
                               correios.cod-destino       = tt-dados-post.cod-destino     
                               correios.un-postagem       = tt-dados-post.un-postagem
                               correios.servico-adicional = tt-dados-post.servico-adicional
                               correios.origem-postagem   = tt-dados-post.origem-postagem
                               correios.ct-codigo         = tt-dados-post.ct-codigo
                               correios.cc-codigo         = tt-dados-post.cc-codigo. 
                     END.
                     ELSE DO:
    
                         CREATE tt-erro.
                         ASSIGN tt-erro.linha     = i-erro
                                tt-erro.cod-erro  = 1
                                tt-erro.descricao = "J† existe registro para chave cartao: " + STRING(c-nr-cartao) + " - centro de custo: " + correios.cc-codigo + " per°odo: " + correios.mes-ref.
    
                         ASSIGN l-erros = YES.
                         UNDO BLOCO, LEAVE BLOCO.
                     END.
                 END.
             END.
             IF NOT l-erros THEN
                 MESSAGE "Arquivo importado com sucesso!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
             ELSE 
                 MESSAGE "Ocorreu algum erro na importaá∆o, provavelmente existe registro repetido no arquivo!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
         END.
         ELSE DO:
             MESSAGE "Processo cancelado! Nenhum registro foi importado!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
         END.
    END.

    IF CAN-FIND(FIRST tt-erro NO-LOCK) 
    THEN DO:
        OUTPUT TO VALUE("c:\temp\errosImportacao.txt").
         
         PUT UNFORMATTED 
              "Linha  Erro    Descricao" AT 01
              "------ ------- ----------------------------------------------------------------------------------------------------" AT 01 SKIP.
         FOR EACH tt-erro:
             PUT UNFORMATTED    
                 tt-erro.linha     AT 01
                 tt-erro.cod-erro  AT 08
                 tt-erro.descricao AT 16.
         END.
         OUTPUT CLOSE.
         MESSAGE "Ocorreu algum erro na importaá∆o dos registros, importaá∆o n∆o foi efetuada!" SKIP
                 "Erros foram gerados no arquivo c:\temp\errosImportacao.txt" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
         OS-COMMAND NO-WAIT notepad VALUE("c:\temp\errosImportacao.txt").
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

    DEFINE VARIABLE de-valor    AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-linha-aux AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-cont      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE da-data-desconto AS DATE        NO-UNDO.
    DEFINE VARIABLE de-rateio      AS DECIMAL     NO-UNDO.

    DEFINE VARIABLE de-valor-antes  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-valor-depois AS DECIMAL     NO-UNDO.

    ASSIGN de-desconto = 0
           i-erro      = 0.

    EMPTY TEMP-TABLE tt-erro.

    INPUT FROM VALUE(c-dir-arquivo) NO-CONVERT.
    REPEAT:
        IMPORT UNFORMATTED c-linha.

        ASSIGN c-linha = TRIM(c-linha).
        
        IF SUBSTRING(c-linha,1,7) = "1Fatura" THEN 
           ASSIGN c-fatura   = trim(substring(ENTRY(2,c-linha,":"),1,11))
                  c-contrato = trim(substring(ENTRY(3,c-linha,":"),1,11)).
                 
        IF SUBSTRING(c-linha,1,7) = "2Origem" THEN
           ASSIGN c-origem = trim(ENTRY(2,ENTRY(2,c-linha,":"),"-")).

        /*IF SUBSTRING(c-linha,1,8) = "2Cliente" THEN
           ASSIGN i-cliente = int(ENTRY(1,ENTRY(2,c-linha,":"),"-")).*/

        ASSIGN i-cliente = 1.

        IF SUBSTRING(c-linha,1,3) = "2Nr" THEN DO:

            ASSIGN c-nr-cartao    = trim(ENTRY(1,TRIM(ENTRY(2,c-linha,":")),"-"))
                   c-cc-codigo = trim(ENTRY(2,TRIM(ENTRY(2,c-linha,":")),"-")).

            RUN pi-centro-custo(INPUT c-cc-codigo).

            RUN pi-acompanhar in h-acomp (input "Nr Cartao : " + c-nr-cartao ).

            ASSIGN i-reg-fatura = i-reg-fatura + 1. 
        END.
          
        IF SUBSTRING(c-linha,1,1) = "3 " AND
           NOT CAN-FIND(FIRST tt-erro NO-LOCK) 
        THEN DO:
           IF SUBSTRING(c-linha,1,10) <> "3 Postagem" THEN DO:
              FIND FIRST tt-dados-post NO-LOCK WHERE 
                         tt-dados-post.tipo         = 1                               AND 
                         tt-dados-post.nr-contrato  = c-contrato                      AND
                         tt-dados-post.nr-fatura    = c-fatura                        AND
                         tt-dados-post.cod-cliente  = i-cliente                       AND 
                         tt-dados-post.nr-cartao    = c-nr-cartao                     AND
                         tt-dados-post.servico      = trim(SUBSTRING(c-linha,15,40))  AND
                         tt-dados-post.dt-post      = DATE(SUBSTRING(c-linha,3,10))   AND
                         tt-dados-post.nr-docto     = SUBSTRING(c-linha,55,10)        AND
                         tt-dados-post.cod-destino  = int(SUBSTRING(c-linha,102,5))   AND
                         tt-dados-post.un-postagem  = trim(SUBSTRING(c-linha,111,40)) NO-ERROR.
              IF NOT AVAIL tt-dados-post THEN DO:
                 CREATE tt-dados-post.
                 ASSIGN tt-dados-post.tipo         = 1                              
                        tt-dados-post.nr-contrato  = c-contrato                     
                        tt-dados-post.nr-fatura    = c-fatura                       
                        tt-dados-post.cod-cliente  = i-cliente                      
                        tt-dados-post.nr-cartao    = c-nr-cartao                      
                        tt-dados-post.servico      = trim(SUBSTRING(c-linha,15,40)) 
                        tt-dados-post.dt-post      = DATE(SUBSTRING(c-linha,3,10))  
                        tt-dados-post.servico-adicional = SUBSTRING(c-linha,67,20)  
                        tt-dados-post.nr-docto          = SUBSTRING(c-linha,55,10)     
                        tt-dados-post.cod-destino       = int(SUBSTRING(c-linha,102,5))  
                        tt-dados-post.un-postagem       = trim(SUBSTRING(c-linha,111,40)) 
                        tt-dados-post.origem-postagem   = c-origem
                        tt-dados-post.ct-codigo         = ""
                        tt-dados-post.cc-codigo         = "".
              END.
              
              ASSIGN tt-dados-post.peso       = tt-dados-post.peso    + INT(SUBSTRING(c-linha,151,10))
                     tt-dados-post.qtd        = tt-dados-post.qtd     + INT(SUBSTRING(c-linha,163,7))
                     tt-dados-post.vl-unit    = tt-dados-post.vl-unit + DEC(SUBSTRING(c-linha,172,21)) / 100
                     tt-dados-post.vl-serv    = tt-dados-post.vl-serv + DEC(SUBSTRING(c-linha,193,21)) / 100
                     tt-dados-post.vl-desc    = tt-dados-post.vl-desc + DEC(SUBSTRING(c-linha,215,21)) / 100
                     tt-dados-post.valor      = tt-dados-post.valor   + DEC(SUBSTRING(c-linha,237,21)) / 100.

              ASSIGN de-valor-fatura = de-valor-fatura + DEC(SUBSTRING(c-linha,237,21)) / 100.
           END.
        END.

        IF SUBSTRING(c-linha,1,1) = "5" 
        THEN DO:
            ASSIGN c-linha-aux = SUBSTRING(c-linha,LENGTH(c-linha) - 15,16).

            IF SUBSTRING(c-linha-aux,LENGTH(c-linha-aux),1) = "C" THEN DO:
                ASSIGN c-linha-aux = TRIM(REPLACE(REPLACE(REPLACE(c-linha-aux,"C",""),",",""),".","")).
                ASSIGN de-valor = DEC(c-linha-aux) / 100 NO-ERROR.

                IF de-valor <> ? AND de-valor > 0 THEN DO:
                    ASSIGN de-desconto = de-desconto + (de-valor * -1).
                    ASSIGN da-data-desconto = DATE(SUBSTRING(c-linha,3,10)) NO-ERROR.
                END.
            END.
        END.

    END.
    INPUT CLOSE.

    FOR EACH tt-cc NO-LOCK
       WHERE tt-cc.percentual = 100:
        
        FOR EACH tt-dados-post NO-LOCK
           WHERE tt-dados-post.nr-cartao = tt-cc.nr-cartao
             AND tt-dados-post.ct-codigo = "": 

                
           ASSIGN tt-dados-post.ct-codigo = tt-cc.ct-codigo
                  tt-dados-post.cc-codigo = tt-cc.cc-codigo.


          FIND FIRST tt-total NO-LOCK
               WHERE tt-total.ct-codigo = tt-dados-post.ct-codigo 
                 AND tt-total.cc-codigo = tt-dados-post.cc-codigo NO-ERROR.
          IF NOT AVAIL tt-total THEN DO:
              CREATE tt-total.
              ASSIGN tt-total.ct-codigo = tt-dados-post.ct-codigo
                     tt-total.cc-codigo = tt-dados-post.cc-codigo.
          END.
          ASSIGN tt-total.valor = tt-total.valor + tt-dados-post.valor.
        END.
    END.

    ASSIGN i-cont = 0.
    FOR EACH tt-dados-post NO-LOCK
       WHERE tt-dados-post.ct-codigo = "": 

       ASSIGN de-valor = 0.

       FOR EACH tt-cc NO-LOCK
          WHERE tt-cc.nr-cartao = tt-dados-post.nr-cartao
            AND tt-cc.percentual <> 100:


            ASSIGN i-cont = i-cont + 1.
            CREATE b-tt-dados-post.
            BUFFER-COPY tt-dados-post EXCEPT cod-cliente TO b-tt-dados-post.
            ASSIGN b-tt-dados-post.cod-cliente = i-cont
                   b-tt-dados-post.vl-unit    = ROUND(tt-dados-post.vl-unit * (tt-cc.percentual / 100),2)
                   b-tt-dados-post.vl-serv    = ROUND(tt-dados-post.vl-serv * (tt-cc.percentual / 100),2)
                   b-tt-dados-post.vl-desc    = 0
                   b-tt-dados-post.valor      = ROUND(tt-dados-post.valor   * (tt-cc.percentual / 100),2)
                   b-tt-dados-post.ct-codigo = tt-cc.ct-codigo
                   b-tt-dados-post.cc-codigo = tt-cc.cc-codigo.

            ASSIGN de-valor = de-valor + b-tt-dados-post.valor.

            FIND FIRST tt-total NO-LOCK
                 WHERE tt-total.ct-codigo = b-tt-dados-post.ct-codigo 
                   AND tt-total.cc-codigo = b-tt-dados-post.cc-codigo NO-ERROR.
            IF NOT AVAIL tt-total THEN DO:
                CREATE tt-total.
                ASSIGN tt-total.ct-codigo = b-tt-dados-post.ct-codigo
                       tt-total.cc-codigo = b-tt-dados-post.cc-codigo.
            END.
            ASSIGN tt-total.valor = tt-total.valor + b-tt-dados-post.valor.

       END.


       IF tt-dados-post.valor <> de-valor THEN DO:

           ASSIGN b-tt-dados-post.vl-unit    = b-tt-dados-post.vl-unit + (tt-dados-post.valor - de-valor)
                  b-tt-dados-post.vl-serv    = b-tt-dados-post.vl-serv + (tt-dados-post.valor - de-valor)
                  b-tt-dados-post.vl-desc    = 0             
                  b-tt-dados-post.valor      = b-tt-dados-post.valor   + (tt-dados-post.valor - de-valor)
                  tt-total.valor             = tt-total.valor          + (tt-dados-post.valor - de-valor).
       END.

       DELETE tt-dados-post.
    END.

    ASSIGN i-cont = 0
           de-valor-total = 0.
    FOR EACH tt-total 
        WHERE tt-total.ct-codigo <> "41110010" 
        BREAK BY tt-total.valor DESCENDING:

        ASSIGN i-cont = i-cont + 1
               de-valor-total = de-valor-total + tt-total.valor.

        IF i-cont >= 5 THEN LEAVE.
    END.

    ASSIGN i-cont    = 0
           de-rateio = 0.

    FOR EACH tt-total 
        WHERE tt-total.ct-codigo <> "41110010"  
        BREAK BY tt-total.valor DESCENDING:

        ASSIGN i-cont    = i-cont + 1
               de-rateio = de-rateio + (ROUND(de-desconto * (tt-total.valor / de-valor-total),2)).

        CREATE tt-dados-post.
        ASSIGN tt-dados-post.tipo              = 1
               tt-dados-post.nr-contrato       = c-contrato
               tt-dados-post.nr-fatura         = c-fatura
               tt-dados-post.cod-cliente       = 9
               tt-dados-post.nr-cartao         = "desconto"
               tt-dados-post.servico           = "desconto"
               tt-dados-post.dt-post           = da-data-desconto
               tt-dados-post.nr-docto          = "D" + STRING(i-cont)
               tt-dados-post.cod-destino       = 99999
               tt-dados-post.un-postagem       = "desconto"
               tt-dados-post.origem-postagem   = "desconto"
               tt-dados-post.servico-adicional = ""
               tt-dados-post.ct-codigo         = tt-total.ct-codigo
               tt-dados-post.cc-codigo         = tt-total.cc-codigo
               tt-dados-post.peso              = 0
               tt-dados-post.qtd               = 0
               tt-dados-post.vl-unit           = ROUND(de-desconto * (tt-total.valor / de-valor-total),2)
               tt-dados-post.vl-serv           = ROUND(de-desconto * (tt-total.valor / de-valor-total),2)
               tt-dados-post.vl-desc           = 0
               tt-dados-post.valor             = ROUND(de-desconto * (tt-total.valor / de-valor-total),2).

        IF de-rateio <> de-desconto AND i-cont = 5 THEN
            ASSIGN tt-dados-post.vl-unit    = tt-dados-post.vl-unit + (de-desconto - de-rateio)
                   tt-dados-post.vl-serv    = tt-dados-post.vl-serv + (de-desconto - de-rateio)
                   tt-dados-post.vl-desc    = 0             
                   tt-dados-post.valor      = tt-dados-post.valor   + (de-desconto - de-rateio).
              
        ASSIGN de-valor-fatura = de-valor-fatura + tt-dados-post.valor.

        IF i-cont >= 5 THEN LEAVE.
    END.

    ASSIGN de-valor-fatura = 0.

    FOR EACH tt-dados-post:
        ASSIGN de-valor-fatura = de-valor-fatura + tt-dados-post.valor.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

