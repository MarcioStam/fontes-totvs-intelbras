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
{include/i-prgvrs.i esofp008 9.99.99.999}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esofp008
&GLOBAL-DEFINE Version        2.00.00.000
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Importar

&GLOBAL-DEFINE PGPAR          YES

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   fi-estabel-ini ~
                              fi-estabel-fim ~
                              fi-serie-ini ~
                              fi-serie-fim ~
                              fi-nota-ini ~
                              fi-nota-fim ~
                              dt-emis-ini ~
                              dt-emis-fim ~
                              fi-data-venc ~
                              fi-imprime ~
                              tg-ativo

/* Parameters Definitions ---                                           */
{esp/ofp/esofp008tt.i}

DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.

/* Vari†veis */

DEFINE VARIABLE c-imprime AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-estado AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont-nota AS INTEGER     NO-UNDO.
DEFINE VARIABLE total-erro AS INTEGER     NO-UNDO.

DEFINE VARIABLE c-empresa        AS CHARACTER   NO-UNDO FORMAT "x(40)":U.
DEFINE VARIABLE c-titulo-relat   AS CHARACTER   NO-UNDO FORMAT "x(50)":U.
DEFINE VARIABLE c-rodape         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-aux            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-vl-icmsub-it  AS DECIMAL     NO-UNDO.
/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-mensagem NO-UNDO
    FIELD sequencia     AS INTEGER   FORMAT ">,>>>,>>9":U LABEL "Sequencia":U     COLUMN-LABEL "Seq":U
    FIELD tipo-mensagem AS CHARACTER FORMAT "x(12)":U     LABEL "Tipo Mensagem":U COLUMN-LABEL "Tipo Msg":U
    FIELD mensagem      AS CHARACTER FORMAT "x(125)":U     LABEL "Mensagem":U      COLUMN-LABEL "Mensagem":U
    INDEX ch-primario IS PRIMARY UNIQUE
        sequencia
    INDEX ch-tipo-mensagem
        tipo-mensagem
        sequencia.

/* Stream Definitions ---                                               */

DEFINE STREAM str-rp.
DEFINE STREAM str-xml.

/* Form Definitions ---                                                 */

FORM HEADER
    FILL("-":U, 132) FORMAT "x(132)":U 
    c-empresa c-titulo-relat AT 50
    "P†gina:":U AT 120 PAGE-NUMBER AT 128 FORMAT ">>>>9":U 
    FILL("-":U, 112) FORMAT "x(110)":U TODAY FORMAT "99/99/9999":U
    "-":U STRING(TIME, "HH:MM:SS":U) (1)
    WITH STREAM-IO WIDTH 132 NO-LABELS NO-BOX PAGE-TOP FRAME f-cabec.

FORM HEADER
    c-rodape FORMAT "x(132)":U
    WITH STREAM-IO WIDTH 132 NO-LABELS NO-BOX PAGE-BOTTOM FRAME f-rodape.

FORM tt-mensagem.tipo-mensagem
     tt-mensagem.mensagem
    WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 140 FRAME f-mensagem.

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
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE dt-emis-fim AS DATE FORMAT "99/99/9999":U INITIAL 01/01/13 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE dt-emis-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/11 
     LABEL "Data Emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-data-venc AS DATE FORMAT "99/99/9999":U 
     LABEL "Data de Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .79 NO-UNDO.

DEFINE VARIABLE fi-estabel-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabel-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-imprime AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nota-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nota-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Nota" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-serie-fim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-serie-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.92.

DEFINE VARIABLE tg-ativo AS LOGICAL INITIAL no 
     LABEL "Usar essa data de vencimento" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     fi-estabel-ini AT ROW 1.75 COL 26 COLON-ALIGNED WIDGET-ID 36
     fi-estabel-fim AT ROW 1.75 COL 50.14 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     fi-serie-ini AT ROW 2.75 COL 26 COLON-ALIGNED WIDGET-ID 28
     fi-serie-fim AT ROW 2.75 COL 50.14 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     fi-nota-ini AT ROW 3.75 COL 19 COLON-ALIGNED WIDGET-ID 20
     fi-nota-fim AT ROW 3.75 COL 50.14 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     dt-emis-ini AT ROW 4.75 COL 19 COLON-ALIGNED WIDGET-ID 12
     dt-emis-fim AT ROW 4.75 COL 50.14 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     fi-data-venc AT ROW 6.75 COL 19 COLON-ALIGNED WIDGET-ID 42
     tg-ativo AT ROW 6.75 COL 37 WIDGET-ID 54
     fi-imprime AT ROW 11 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     "Se n∆o assinalada, a data de vencimento padr∆o ser† 3 dias ap¢s a data de hoje." VIEW-AS TEXT
          SIZE 69 BY .88 AT ROW 7.75 COL 6 WIDGET-ID 58
     "Destino" VIEW-AS TEXT
          SIZE 8 BY .88 AT ROW 10 COL 10 WIDGET-ID 50
     IMAGE-5 AT ROW 4.75 COL 36 WIDGET-ID 14
     IMAGE-6 AT ROW 4.75 COL 49.29 WIDGET-ID 16
     IMAGE-15 AT ROW 3.75 COL 36 WIDGET-ID 22
     IMAGE-16 AT ROW 3.75 COL 49.29 WIDGET-ID 24
     IMAGE-17 AT ROW 2.75 COL 36 WIDGET-ID 30
     IMAGE-18 AT ROW 2.75 COL 49.29 WIDGET-ID 32
     IMAGE-19 AT ROW 1.75 COL 36 WIDGET-ID 38
     IMAGE-20 AT ROW 1.75 COL 49.29 WIDGET-ID 40
     RECT-8 AT ROW 10.33 COL 6 WIDGET-ID 48
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 1.25
         SIZE 84.43 BY 14.58
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
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 27.46
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 27.46
         VIRTUAL-WIDTH      = 195.14
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
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
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
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
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    do  on error undo, return no-apply:
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tg-ativo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-ativo wWindow
ON VALUE-CHANGED OF tg-ativo IN FRAME fPage1 /* Usar essa data de vencimento */
DO:
  IF tg-ativo:screen-value = "YES" THEN
      fi-data-venc:SENSITIVE IN FRAME fpage1 = YES.
  ELSE
      fi-data-venc:SENSITIVE IN FRAME fpage1 = NO.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN fi-data-venc:SENSITIVE IN FRAME fpage1 = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeInitializeInterface wWindow 
PROCEDURE BeforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-mensagem.
        DELETE tt-mensagem.
    END.
    
    ASSIGN dt-emis-fim = DATE(TODAY)
           dt-emis-ini = DATE(TODAY)
           fi-imprime = "C:\temp\Lote_GNRE.xml"
           fi-data-venc:SENSITIVE IN FRAME fpage1 = NO.

    ASSIGN INPUT FRAME fpage1 fi-data-venc
           INPUT FRAME fpage1 tg-ativo.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-produto wWindow 
PROCEDURE pi-busca-produto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST int-item-uf
        WHERE int-item-uf.it-codigo = it-nota-fisc.it-codigo
          AND int-item-uf.protocolo <> ? NO-LOCK NO-ERROR.
    IF AVAIL int-item-uf THEN DO:
        IF SUBSTRING(int-item-uf.protocolo,1,3) = "192" OR
           SUBSTRING(int-item-uf.protocolo,1,3) = "106" OR
           SUBSTRING(int-item-uf.protocolo,1,3) = "198" OR
           SUBSTRING(int-item-uf.protocolo,1,3) = "117" THEN
            ASSIGN c-aux = c-aux + "<c26_produto>11</c26_produto>" .
    END.
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar produto de origem               PRODUTO N«O ENCONTRADO").
        RETURN "NOK".
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-mensagem wWindow 
PROCEDURE pi-cria-mensagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-tipo-mensagem LIKE tt-mensagem.tipo-mensagem NO-UNDO.
    DEFINE INPUT  PARAMETER p-mensagem      LIKE tt-mensagem.mensagem      NO-UNDO.

    DEFINE VARIABLE v-sequencia LIKE tt-mensagem.sequencia NO-UNDO.

    FIND LAST tt-mensagem NO-ERROR.

    ASSIGN v-sequencia = IF AVAILABLE tt-mensagem THEN tt-mensagem.sequencia + 1 ELSE 1.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.sequencia     = v-sequencia
           tt-mensagem.tipo-mensagem = p-tipo-mensagem
           tt-mensagem.mensagem      = p-mensagem.

    RELEASE tt-mensagem.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-imprime-mensagem wWindow 
PROCEDURE pi-imprime-mensagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.

    IF NOT CAN-FIND(FIRST tt-mensagem) THEN
        RETURN "OK":U.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    FIND FIRST mgcad.empresa
        WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.
    
    ASSIGN c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
           c-titulo-relat = "LOG de geraá∆o do XML para o GNRE":U
           c-rodape       = "DATASUL - Espec°fico Intelbras - ":U + c-prg-obj + " - V:":U + c-prg-vrs
           c-rodape       = FILL("-":U, 132 - LENGTH(c-rodape)) + c-rodape.
    
    ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "log-esofp008.txt":U.
    
    OUTPUT STREAM str-rp TO VALUE(c-arquivo) PAGED PAGE-SIZE 64 CONVERT TARGET "iso8859-1":U.
    
    VIEW STREAM str-rp FRAME f-cabec.
    VIEW STREAM str-rp FRAME f-rodape.

    /* Imprimindo informaá‰es */
    FOR EACH tt-mensagem:
        DISPLAY STREAM str-rp
                tt-mensagem.tipo-mensagem
                tt-mensagem.mensagem
            WITH FRAME f-mensagem.
        DOWN STREAM str-rp WITH FRAME f-mensagem.
    END.
    
    OUTPUT STREAM str-rp CLOSE.
    
    OS-COMMAND NO-WAIT VALUE(c-arquivo) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-xml-1 wWindow 
PROCEDURE pi-xml-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* UF favorecida AP - PR - RS                                                               */
/* ê feito preenchimento do:                                                                */
/*                                                                                          */
/*UF favorecida                                                                             */
/*CNPJ - Raz∆o Social - Endereáo - UF - Municipio todos do emitente                         */
/*Receita - Documento de Origem - Data de Vencimento - Data de Pagamento - Valor Principal  */


    ASSIGN c-aux = c-aux + "<TDadosGNRE>" 
        + "<c01_UfFavorecida>" + trim(nota-fiscal.estado) + "</c01_UfFavorecida>" 
        + "<c02_receita>100099</c02_receita>" 
        + "<c27_tipoIdentificacaoEmitente>1</c27_tipoIdentificacaoEmitente>" 
        + "<c03_idContribuinteEmitente>" .

    FIND FIRST estabelec
         WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel 
           AND estabelec.cgc <> ? NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN c-aux = c-aux  + "<CNPJ>" + trim(estabelec.cgc) + "</CNPJ>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                              INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar CNPJ de origem               CNPJ N«O ENCONTRADO"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux  + "</c03_idContribuinteEmitente>" 
          + "<c28_tipoDocOrigem>10</c28_tipoDocOrigem>" 
          + "<c04_docOrigem>" + trim(nota-fiscal.nr-nota-fis) + "</c04_docOrigem>" 
          + "<c06_valorPrincipal>" + trim(REPLACE(STRING(TRUNCATE(de-vl-icmsub-it, 2), ">>>>>>>>>9.99"), SESSION:NUMERIC-DECIMAL-POINT, ".":U)) + "</c06_valorPrincipal>" .

    IF fi-data-venc <> ? AND fi-data-venc > today AND tg-ativo = YES THEN
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(fi-data-venc) + "</c14_dataVencimento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(TODAY + 3) + "</c14_dataVencimento>" .

    ASSIGN c-aux = c-aux + "<c16_razaoSocialEmitente>" + trim(estabelec.nome) + "</c16_razaoSocialEmitente>" 
        + "<c18_enderecoEmitente>" + trim(estabelec.endereco) + "</c18_enderecoEmitente>" .

    IF estabelec.cidade = "Sao Jose" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>16602</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Santa Rita do Sapuca°" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>59605</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Manaus" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>02603</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Palhoáa" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>11900</c19_municipioEmitente>" .
    ELSE DO:
        
        RUN pi-cria-mensagem (INPUT "Erro",
                              INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar cidade de origem " + estabelec.cidade + " CIDADE N«O ENCONTRADA"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux + "<c20_ufEnderecoEmitente>" + trim(estabelec.estado) + "</c20_ufEnderecoEmitente>" .

    IF nota-fiscal.ins-estadual <> ? AND nota-fiscal.ins-estadual <> "ISENTO" THEN
        ASSIGN c-aux = c-aux + "<c36_inscricaoEstadualDestinatario>" + trim(replace(nota-fiscal.ins-estadual,".","")) + "</c36_inscricaoEstadualDestinatario>" .
    ELSE DO:
        IF nota-fiscal.ins-estadual = ? OR nota-fiscal.ins-estadual = "" THEN
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO EM BRANCO"). 
        ELSE
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO ISENTO"). 
            RETURN "NOK".
    END.

    
    IF fi-data-venc <> ? AND fi-data-venc > today AND tg-ativo = YES THEN
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(fi-data-venc) + "</c33_dataPagamento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(TODAY + 3) + "</c33_dataPagamento>" .
    RUN pi-dados-destinatario.

     ASSIGN c-aux = c-aux + "<c39_camposExtras>"
        + "<campoExtra>" .

/*            Para a vers∆o TOTVS 11 ser†:                   */
/*            &if  "{&bf_dis_versao_ems}"  >=  "2.07"  &then */
/*            nota-fiscal.cod-chave-aces-nf-eletro           */
/*            &ENDIF                                         */
/*                                                           */
    ASSIGN c-aux = c-aux + "<codigo>74</codigo>"
        + "<tipo>T</tipo>"
        + "<valor>" +  nota-fiscal.cod-chave-aces-nf-eletro + "</valor>"
        + "</campoExtra>"
        + "</c39_camposExtras>".

    ASSIGN c-aux = c-aux + "</TDadosGNRE>".

    RUN pi-cria-mensagem (INPUT "Informaá∆o",
                          INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + "                                                                 OK"). 

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-dados-destinatario wWindow 
PROCEDURE pi-dados-destinatario:
    /* Desativado por enquanto
    FIND emitente
        WHERE emitente.cod-emitente = nota-fiscal.cod-emitente
        NO-LOCK NO-ERROR.
    FOR FIRST cidade
        WHERE cidade.cidade = emitente.cidade
        AND CIDADE.PAIS = emitente.pais
        AND CIDADE.ESTADO = emitente.estado NO-LOCK:
    END.
    IF emitente.natureza = 1 THEN
       ASSIGN c-aux = c-aux + "<c34_tipoIdentificacaoDestinatario>2</c34_tipoIdentificacaoDestinatario> "
              c-aux = c-aux + "<c35_idContribuinteDestinatario>
                               <CPF>" + emitente.cgc + "</CPF> </c35_idContribuinteDestinatario>".
    ELSE
       ASSIGN c-aux = c-aux + "<c34_tipoIdentificacaoDestinatario>1</c34_tipoIdentificacaoDestinatario> "
              c-aux = c-aux + "<c35_idContribuinteDestinatario>
                              <CNPJ>" + emitente.cgc + "</CNPJ> </c35_idContribuinteDestinatario>".



    ASSIGN c-aux = c-aux +  "<c38_municipioDestinatario>" + STRING(CIDADE.CDN-DOMIC-FISC) + "</c38_municipioDestinatario>".
    */
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-xml-10 wWindow 
PROCEDURE pi-xml-10 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* UF favorecida PI - RR                                                                    */
/* ê feito preenchimento do:                                                                */
/*                                                                                          */
/*UF favorecida                                                                             */
/*CNPJ - Raz∆o Social - Endereáo - UF - Municipio todos do emitente                         */
/*Receita - Produto - Documento de Origem - Data de Vencimento - Data de Pagamento                    */
/*Per°odo de Referància - Valor Principal                                                   */
               
    ASSIGN c-aux = c-aux + "<TDadosGNRE>" 
        + "<c01_UfFavorecida>" + trim(nota-fiscal.estado) + "</c01_UfFavorecida>" 
        + "<c02_receita>100099</c02_receita>" .

    RUN pi-busca-produto.

/*     FIND FIRST int-item-uf                                                                                                                                                                */
/*         WHERE int-item-uf.it-codigo = it-nota-fisc.it-codigo                                                                                                                              */
/*           AND int-item-uf.protocolo <> ? NO-LOCK NO-ERROR.                                                                                                                                */
/*     IF AVAIL int-item-uf THEN DO:                                                                                                                                                         */
/*         IF SUBSTRING(int-item-uf.protocolo,1,3) = "192" OR                                                                                                                                */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "106" OR                                                                                                                                */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "198" OR                                                                                                                                */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "117" THEN                                                                                                                              */
/*             ASSIGN c-aux = c-aux + "<c26_produto>11</c26_produto>" .                                                                                                                      */
/*     END.                                                                                                                                                                                  */
/*     ELSE DO:                                                                                                                                                                              */
/*         RUN pi-cria-mensagem (INPUT "Erro",                                                                                                                                               */
/*                       INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar produto de origem               PRODUTO N«O ENCONTRADO").  */
/*         RETURN "NOK".                                                                                                                                                                     */
/*     END.                                                                                                                                                                                  */

    ASSIGN c-aux = c-aux + "<c27_tipoIdentificacaoEmitente>1</c27_tipoIdentificacaoEmitente>" 
        + "<c03_idContribuinteEmitente>" .

    FIND FIRST estabelec
         WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel 
           AND estabelec.cgc <> ? NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN c-aux = c-aux  + "<CNPJ>" + trim(estabelec.cgc) + "</CNPJ>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar CNPJ de origem               CNPJ N«O ENCONTRADO"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux  + "</c03_idContribuinteEmitente>" 
          + "<c28_tipoDocOrigem>10</c28_tipoDocOrigem>" 
          + "<c04_docOrigem>" + trim(nota-fiscal.nr-nota-fis) + "</c04_docOrigem>" 
          + "<c10_valorTotal>" + trim(REPLACE(STRING(TRUNCATE(de-vl-icmsub-it, 2), ">>>>>>>>>9.99"), SESSION:NUMERIC-DECIMAL-POINT, ".":U)) + "</c10_valorTotal>" .

    IF fi-data-venc <> ? AND fi-data-venc > date(today) THEN
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(fi-data-venc) + "</c14_dataVencimento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(TODAY + 3) + "</c14_dataVencimento>" .

    ASSIGN c-aux = c-aux + "<c16_razaoSocialEmitente>" + trim(estabelec.nome) + "</c16_razaoSocialEmitente>" 
        + "<c18_enderecoEmitente>" + trim(estabelec.endereco) + "</c18_enderecoEmitente>" .

    IF estabelec.cidade = "Sao Jose" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>16602</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Santa Rita do Sapuca°" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>59605</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Manaus" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>02603</c19_municipioEmitente>" .
        ELSE IF estabelec.cidade = "Palhoáa" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>11900</c19_municipioEmitente>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar cidade de origem               CIDADE N«O ENCONTRADA"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux + "<c20_ufEnderecoEmitente>" + trim(estabelec.estado) + "</c20_ufEnderecoEmitente>" .

    IF nota-fiscal.ins-estadual <> ? AND nota-fiscal.ins-estadual <> "ISENTO" THEN
        ASSIGN c-aux = c-aux + "<c36_inscricaoEstadualDestinatario>" + trim(replace(nota-fiscal.ins-estadual,".","")) + "</c36_inscricaoEstadualDestinatario>" .
    ELSE DO:
        IF nota-fiscal.ins-estadual = ? OR nota-fiscal.ins-estadual = "" THEN
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO EM BRANCO"). 
        ELSE
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO ISENTO"). 
            RETURN "NOK".
    END.

    IF fi-data-venc <> ? AND fi-data-venc > today AND tg-ativo = YES THEN
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(fi-data-venc) + "</c33_dataPagamento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(TODAY + 3) + "</c33_dataPagamento>" .
    RUN pi-dados-destinatario.
    ASSIGN c-aux = c-aux + "<c05_referencia>" 
        + "<mes>" + STRING(MONTH(nota-fiscal.dt-emis-nota),"99":U) + "</mes>"  
        + "<ano>" + string(year(nota-fiscal.dt-emis-nota),"9999":U) + "</ano>"  
        + "</c05_referencia>" 
        + "<c39_camposExtras>" 
        + "<campoExtra>" .

/*            Para a vers∆o TOTVS 11 ser†:                   */
/*            &if  "{&bf_dis_versao_ems}"  >=  "2.07"  &then */
/*            nota-fiscal.cod-chave-aces-nf-eletro           */
/*            &ENDIF                                         */
/*                                                           */
    ASSIGN c-aux = c-aux + "<codigo>" + nota-fiscal.cod-chave-aces-nf-eletro + "</codigo>" 
        + "<tipo>C</tipo>" 
        + "</campoExtra>" 
        + "</c39_camposExtras>" 
        + "</TDadosGNRE>".

    RUN pi-cria-mensagem (INPUT "Informaá∆o",
                          INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + "                                                                 OK"). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-xml-11 wWindow 
PROCEDURE pi-xml-11 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* UF favorecida MT                                                                         */
/* ê feito preenchimento do:                                                                */
/*                                                                                          */
/*UF favorecida                                                                             */
/*CNPJ - Raz∆o Social - Endereáo - UF - Municipio todos do emitente                         */
/*Receita - Documento de Origem - Data de Vencimento - Data de Pagamento                    */
/*Per°odo de Referància - Valor Principal                                                   */

    ASSIGN c-aux = c-aux + "<TDadosGNRE>" 
        + "<c01_UfFavorecida>" + trim(nota-fiscal.estado) + "</c01_UfFavorecida>" 
        + "<c02_receita>100099</c02_receita>" 
        + "<c25_detalhamentoReceita>000017</c25_detalhamentoReceita>" 
        + "<c27_tipoIdentificacaoEmitente>1</c27_tipoIdentificacaoEmitente>" 
        + "<c03_idContribuinteEmitente>" .

    FIND FIRST estabelec
         WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel 
           AND estabelec.cgc <> ? NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN c-aux = c-aux  + "<CNPJ>" + trim(estabelec.cgc) + "</CNPJ>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar CNPJ de origem               CNPJ N«O ENCONTRADO"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux + "</c03_idContribuinteEmitente>" 
          + "<c28_tipoDocOrigem>10</c28_tipoDocOrigem>" 
          + "<c04_docOrigem>" + trim(nota-fiscal.nr-nota-fis) + "</c04_docOrigem>" 
          + "<c06_valorPrincipal>" + trim(REPLACE(STRING(TRUNCATE(de-vl-icmsub-it, 2), ">>>>>>>>>9.99"), SESSION:NUMERIC-DECIMAL-POINT, ".":U)) + "</c06_valorPrincipal>" .

    IF fi-data-venc <> ? AND fi-data-venc > date(today) THEN
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(fi-data-venc) + "</c14_dataVencimento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(TODAY + 3) + "</c14_dataVencimento>" .

    ASSIGN c-aux = c-aux + "<c16_razaoSocialEmitente>" + trim(estabelec.nome) + "</c16_razaoSocialEmitente>" 
        + "<c18_enderecoEmitente>" + trim(estabelec.endereco) + "</c18_enderecoEmitente>" .

    IF estabelec.cidade = "Sao Jose" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>16602</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Santa Rita do Sapuca°" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>59605</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Manaus" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>02603</c19_municipioEmitente>" .
        ELSE IF estabelec.cidade = "Palhoáa" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>11900</c19_municipioEmitente>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar cidade de origem               CIDADE N«O ENCONTRADA"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux + "<c20_ufEnderecoEmitente>" + trim(estabelec.estado) + "</c20_ufEnderecoEmitente>" .

    IF nota-fiscal.ins-estadual <> ? AND nota-fiscal.ins-estadual <> "ISENTO" THEN
        ASSIGN c-aux = c-aux + "<c36_inscricaoEstadualDestinatario>" + trim(replace(nota-fiscal.ins-estadual,".","")) + "</c36_inscricaoEstadualDestinatario>" .
    ELSE DO:
        IF nota-fiscal.ins-estadual = ? OR nota-fiscal.ins-estadual = "" THEN
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO EM BRANCO"). 
        ELSE
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO ISENTO"). 
            RETURN "NOK".
    END.

    IF fi-data-venc <> ? AND fi-data-venc > today AND tg-ativo = YES THEN
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(fi-data-venc) + "</c33_dataPagamento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(TODAY + 3) + "</c33_dataPagamento>" .
    
    RUN pi-dados-destinatario.

    ASSIGN c-aux = c-aux + "<c05_referencia>" 
        + "<mes>" + STRING(MONTH(nota-fiscal.dt-emis-nota),"99":U) + "</mes>"  
        + "<ano>" + string(year(nota-fiscal.dt-emis-nota),"9999":U) + "</ano>"  
        + "</c05_referencia>" 
        + "</TDadosGNRE>".
    
    RUN pi-cria-mensagem (INPUT "Informaá∆o",
                          INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + "                                                                 OK"). 
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-xml-12 wWindow 
PROCEDURE pi-xml-12 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* UF favorecida MA                                                                         */
/* ê feito preenchimento do:                                                                */
/*                                                                                          */
/*UF favorecida                                                                             */
/*CNPJ - Raz∆o Social - Endereáo - UF - Municipio todos do emitente                         */
/*Receita - Produto - Documento de Origem - Data de Vencimento - Data de Pagamento                    */
/*Per°odo de Referància - Valor Principal                                                   */
               
    ASSIGN c-aux = c-aux + "<TDadosGNRE>" 
        + "<c01_UfFavorecida>" + trim(nota-fiscal.estado) + "</c01_UfFavorecida>" 
        + "<c02_receita>100099</c02_receita>" 
        + "<c25_detalhamentoReceita>000013</c25_detalhamentoReceita>" .

    RUN pi-busca-produto.

/*     FIND FIRST int-item-uf                                                                                                                                                               */
/*         WHERE int-item-uf.it-codigo = it-nota-fisc.it-codigo                                                                                                                             */
/*           AND int-item-uf.protocolo <> ? NO-LOCK NO-ERROR.                                                                                                                               */
/*     IF AVAIL int-item-uf THEN DO:                                                                                                                                                        */
/*         IF SUBSTRING(int-item-uf.protocolo,1,3) = "192" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "106" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "198" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "117" THEN                                                                                                                             */
/*             ASSIGN c-aux = c-aux + "<c26_produto>11</c26_produto>" .                                                                                                                     */
/*     END.                                                                                                                                                                                 */
/*     ELSE DO:                                                                                                                                                                             */
/*         RUN pi-cria-mensagem (INPUT "Erro",                                                                                                                                              */
/*                       INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar produto de origem               PRODUTO N«O ENCONTRADO"). */
/*         RETURN "NOK".                                                                                                                                                                    */
/*     END.                                                                                                                                                                                 */

    ASSIGN c-aux = c-aux + "<c27_tipoIdentificacaoEmitente>1</c27_tipoIdentificacaoEmitente>" 
        + "<c03_idContribuinteEmitente>" .

    FIND FIRST estabelec
         WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel 
           AND estabelec.cgc <> ? NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN c-aux = c-aux  + "<CNPJ>" + trim(estabelec.cgc) + "</CNPJ>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar CNPJ de origem               CNPJ N«O ENCONTRADO"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux  + "</c03_idContribuinteEmitente>" 
          + "<c28_tipoDocOrigem>10</c28_tipoDocOrigem>" 
          + "<c04_docOrigem>" + trim(nota-fiscal.nr-nota-fis) + "</c04_docOrigem>" 
          + "<c10_valorTotal>" + trim(REPLACE(STRING(TRUNCATE(de-vl-icmsub-it, 2), ">>>>>>>>>9.99"), SESSION:NUMERIC-DECIMAL-POINT, ".":U)) + "</c10_valorTotal>" .

    IF fi-data-venc <> ? AND fi-data-venc > date(today) THEN
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(fi-data-venc) + "</c14_dataVencimento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(TODAY + 3) + "</c14_dataVencimento>" .

    ASSIGN c-aux = c-aux + "<c16_razaoSocialEmitente>" + trim(estabelec.nome) + "</c16_razaoSocialEmitente>" 
        + "<c18_enderecoEmitente>" + trim(estabelec.endereco) + "</c18_enderecoEmitente>" .

    IF estabelec.cidade = "Sao Jose" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>16602</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Santa Rita do Sapuca°" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>59605</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Manaus" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>02603</c19_municipioEmitente>" .
        ELSE IF estabelec.cidade = "Palhoáa" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>11900</c19_municipioEmitente>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar cidade de origem               CIDADE N«O ENCONTRADA"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux + "<c20_ufEnderecoEmitente>" + trim(estabelec.estado) + "</c20_ufEnderecoEmitente>" .

    IF nota-fiscal.ins-estadual <> ? AND nota-fiscal.ins-estadual <> "ISENTO" THEN
        ASSIGN c-aux = c-aux + "<c36_inscricaoEstadualDestinatario>" + trim(replace(nota-fiscal.ins-estadual,".","")) + "</c36_inscricaoEstadualDestinatario>" .
    ELSE DO:
        IF nota-fiscal.ins-estadual = ? OR nota-fiscal.ins-estadual = "" THEN
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO EM BRANCO"). 
        ELSE
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO ISENTO"). 
            RETURN "NOK".
    END.

    IF fi-data-venc <> ? AND fi-data-venc > today AND tg-ativo = YES THEN
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(fi-data-venc) + "</c33_dataPagamento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(TODAY + 3) + "</c33_dataPagamento>" .
    RUN pi-dados-destinatario.
    ASSIGN c-aux = c-aux + "<c05_referencia>" 
        + "<mes>" + STRING(MONTH(nota-fiscal.dt-emis-nota),"99":U) + "</mes>"  
        + "<ano>" + string(year(nota-fiscal.dt-emis-nota),"9999":U) + "</ano>"  
        + "</c05_referencia>" 
        + "</TDadosGNRE>". 

    RUN pi-cria-mensagem (INPUT "Informaá∆o",
                          INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + "                                                                 OK"). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-xml-13 wWindow 
PROCEDURE pi-xml-13 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* UF favorecida TO                                                                         */
/* ê feito preenchimento do:                                                                */
/*                                                                                          */
/*UF favorecida                                                                             */
/*CNPJ - Raz∆o Social - Endereáo - UF - Municipio todos do emitente                         */
/*Receita - Produto - Documento de Origem - Data de Vencimento - Data de Pagamento                    */
/*Per°odo de Referància - Valor Principal                                                   */
               
    ASSIGN c-aux = c-aux + "<TDadosGNRE>" 
        + "<c01_UfFavorecida>" + trim(nota-fiscal.estado) + "</c01_UfFavorecida>" 
        + "<c02_receita>100099</c02_receita>" 
        + "<c25_detalhamentoReceita>000005</c25_detalhamentoReceita>" .

    RUN pi-busca-produto.

/*     FIND FIRST int-item-uf                                                                                                                                                               */
/*         WHERE int-item-uf.it-codigo = it-nota-fisc.it-codigo                                                                                                                             */
/*           AND int-item-uf.protocolo <> ? NO-LOCK NO-ERROR.                                                                                                                               */
/*     IF AVAIL int-item-uf THEN DO:                                                                                                                                                        */
/*         IF SUBSTRING(int-item-uf.protocolo,1,3) = "192" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "106" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "198" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "117" THEN                                                                                                                             */
/*             ASSIGN c-aux = c-aux + "<c26_produto>11</c26_produto>" .                                                                                                                     */
/*     END.                                                                                                                                                                                 */
/*     ELSE DO:                                                                                                                                                                             */
/*         RUN pi-cria-mensagem (INPUT "Erro",                                                                                                                                              */
/*                       INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar produto de origem               PRODUTO N«O ENCONTRADO"). */
/*         RETURN "NOK".                                                                                                                                                                    */
/*     END.                                                                                                                                                                                 */

    ASSIGN c-aux = c-aux + "<c27_tipoIdentificacaoEmitente>1</c27_tipoIdentificacaoEmitente>" 
        + "<c03_idContribuinteEmitente>" .

    FIND FIRST estabelec
         WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel 
           AND estabelec.cgc <> ? NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN c-aux = c-aux + "<CNPJ>" + trim(estabelec.cgc) + "</CNPJ>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar CNPJ de origem               CNPJ N«O ENCONTRADO"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux  + "</c03_idContribuinteEmitente>" 
          + "<c28_tipoDocOrigem>10</c28_tipoDocOrigem>" 
          + "<c04_docOrigem>" + trim(nota-fiscal.nr-nota-fis) + "</c04_docOrigem>" 
          + "<c10_valorTotal>" + trim(REPLACE(STRING(TRUNCATE(de-vl-icmsub-it, 2), ">>>>>>>>>9.99"), SESSION:NUMERIC-DECIMAL-POINT, ".":U)) + "</c10_valorTotal>" .

    IF fi-data-venc <> ? AND fi-data-venc > date(today) THEN
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(fi-data-venc) + "</c14_dataVencimento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(TODAY + 3) + "</c14_dataVencimento>" .

    ASSIGN c-aux = c-aux + "<c16_razaoSocialEmitente>" + trim(estabelec.nome) + "</c16_razaoSocialEmitente>" 
        + "<c18_enderecoEmitente>" + trim(estabelec.endereco) + "</c18_enderecoEmitente>" .

    IF estabelec.cidade = "Sao Jose" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>16602</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Santa Rita do Sapuca°" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>59605</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Manaus" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>02603</c19_municipioEmitente>" .
        ELSE IF estabelec.cidade = "Palhoáa" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>11900</c19_municipioEmitente>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar cidade de origem               CIDADE N«O ENCONTRADA"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux + "<c20_ufEnderecoEmitente>" + trim(estabelec.estado) + "</c20_ufEnderecoEmitente>" .

    IF nota-fiscal.ins-estadual <> ? AND nota-fiscal.ins-estadual <> "ISENTO" THEN
        ASSIGN c-aux = c-aux + "<c36_inscricaoEstadualDestinatario>" + trim(replace(nota-fiscal.ins-estadual,".","")) + "</c36_inscricaoEstadualDestinatario>" .
    ELSE DO:
        IF nota-fiscal.ins-estadual = ? OR nota-fiscal.ins-estadual = "" THEN
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO EM BRANCO"). 
        ELSE
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO ISENTO"). 
            RETURN "NOK".
    END.


    IF fi-data-venc <> ? AND fi-data-venc > today AND tg-ativo = YES THEN
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(fi-data-venc) + "</c33_dataPagamento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(TODAY + 3) + "</c33_dataPagamento>" .
    RUN pi-dados-destinatario.
    ASSIGN c-aux = c-aux + "<c05_referencia>" 
        + "<mes>" + STRING(MONTH(nota-fiscal.dt-emis-nota),"99":U) + "</mes>"  
        + "<ano>" + string(year(nota-fiscal.dt-emis-nota),"9999":U) + "</ano>"  
        + "</c05_referencia>" 
        + "</TDadosGNRE>".             

    RUN pi-cria-mensagem (INPUT "Informaá∆o",
                          INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + "                                                                 OK"). 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-xml-2 wWindow 
PROCEDURE pi-xml-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* UF favorecida AC - MG - RO                                                               */
/* ê feito preenchimento do:                                                                */
/*                                                                                          */
/*UF favorecida                                                                             */
/*CNPJ - Raz∆o Social - Endereáo - UF - Municipio todos do emitente                         */
/*Receita - Documento de Origem - Data de Vencimento - Data de Pagamento                    */
/*Per°odo de Referància - Valor Principal                                                   */

    ASSIGN c-aux = c-aux + "<TDadosGNRE>" 
        + "<c01_UfFavorecida>" + trim(nota-fiscal.estado) + "</c01_UfFavorecida>" 
        + "<c02_receita>100099</c02_receita>" 
        + "<c27_tipoIdentificacaoEmitente>1</c27_tipoIdentificacaoEmitente>" 
        + "<c03_idContribuinteEmitente>" .

    FIND FIRST estabelec
         WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel 
           AND estabelec.cgc <> ? NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN c-aux = c-aux + "<CNPJ>" + trim(estabelec.cgc) + "</CNPJ>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar CNPJ de origem               CNPJ N«O ENCONTRADO"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux  + "</c03_idContribuinteEmitente>" 
          + "<c28_tipoDocOrigem>10</c28_tipoDocOrigem>" 
          + "<c04_docOrigem>" + trim(nota-fiscal.nr-nota-fis) + "</c04_docOrigem>" 
          + "<c06_valorPrincipal>" + trim(REPLACE(STRING(TRUNCATE(de-vl-icmsub-it, 2), ">>>>>>>>>9.99"), SESSION:NUMERIC-DECIMAL-POINT, ".":U)) + "</c06_valorPrincipal>" .

    IF fi-data-venc <> ? AND fi-data-venc > date(today) THEN
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(fi-data-venc) + "</c14_dataVencimento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(TODAY + 3) + "</c14_dataVencimento>" .

    ASSIGN c-aux = c-aux + "<c16_razaoSocialEmitente>" + trim(estabelec.nome) + "</c16_razaoSocialEmitente>" 
        + "<c18_enderecoEmitente>" + trim(estabelec.endereco) + "</c18_enderecoEmitente>" .

    IF estabelec.cidade = "Sao Jose" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>16602</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Santa Rita do Sapuca°" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>59605</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Manaus" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>02603</c19_municipioEmitente>" .
        ELSE IF estabelec.cidade = "Palhoáa" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>11900</c19_municipioEmitente>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar cidade de origem               CIDADE N«O ENCONTRADA"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux + "<c20_ufEnderecoEmitente>" + trim(estabelec.estado) + "</c20_ufEnderecoEmitente>" .

    IF nota-fiscal.ins-estadual <> ? AND nota-fiscal.ins-estadual <> "ISENTO" THEN
        ASSIGN c-aux = c-aux + "<c36_inscricaoEstadualDestinatario>" + trim(replace(nota-fiscal.ins-estadual,".","")) + "</c36_inscricaoEstadualDestinatario>" .
    ELSE DO:
        IF nota-fiscal.ins-estadual = ? OR nota-fiscal.ins-estadual = "" THEN
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO EM BRANCO"). 
        ELSE
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO ISENTO"). 
            RETURN "NOK".
    END.


    IF fi-data-venc <> ? AND fi-data-venc > today AND tg-ativo = YES THEN
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(fi-data-venc) + "</c33_dataPagamento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(TODAY + 3) + "</c33_dataPagamento>" .
    RUN pi-dados-destinatario.
    ASSIGN c-aux = c-aux + "<c05_referencia>" 
        + "<mes>" + STRING(MONTH(nota-fiscal.dt-emis-nota),"99":U) + "</mes>"  
        + "<ano>" + string(year(nota-fiscal.dt-emis-nota),"9999":U) + "</ano>"  
        + "</c05_referencia>" 
        + "</TDadosGNRE>".

    RUN pi-cria-mensagem (INPUT "Informaá∆o",
                          INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + "                                                                 OK"). 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-xml-3 wWindow 
PROCEDURE pi-xml-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* UF favorecida AM - BH - SE                                                               */
/* ê feito preenchimento do:                                                                */
/*                                                                                          */
/*UF favorecida                                                                             */
/*CNPJ - Raz∆o Social - Endereáo - UF - Municipio todos do emitente                         */
/*Receita - Produto - Documento de Origem - Data de Vencimento - Data de Pagamento                    */
/*Per°odo de Referància - Valor Principal                                                   */
               
    ASSIGN c-aux = c-aux + "<TDadosGNRE>" 
        + "<c01_UfFavorecida>" + trim(nota-fiscal.estado) + "</c01_UfFavorecida>" 
        + "<c02_receita>100099</c02_receita>" .

    RUN pi-busca-produto.

/*     FIND FIRST int-item-uf                                                                                                                                                               */
/*         WHERE int-item-uf.it-codigo = it-nota-fisc.it-codigo                                                                                                                             */
/*           AND int-item-uf.protocolo <> ? NO-LOCK NO-ERROR.                                                                                                                               */
/*     IF AVAIL int-item-uf THEN DO:                                                                                                                                                        */
/*         IF SUBSTRING(int-item-uf.protocolo,1,3) = "192" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "106" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "198" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "117" THEN                                                                                                                             */
/*             ASSIGN c-aux = c-aux + "<c26_produto>11</c26_produto>" .                                                                                                                     */
/*     END.                                                                                                                                                                                 */
/*     ELSE DO:                                                                                                                                                                             */
/*         RUN pi-cria-mensagem (INPUT "Erro",                                                                                                                                              */
/*                       INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar produto de origem               PRODUTO N«O ENCONTRADO"). */
/*         RETURN "NOK".                                                                                                                                                                    */
/*     END.                                                                                                                                                                                 */

    ASSIGN c-aux = c-aux + "<c27_tipoIdentificacaoEmitente>1</c27_tipoIdentificacaoEmitente>" 
        + "<c03_idContribuinteEmitente>" .

    FIND FIRST estabelec
         WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel 
           AND estabelec.cgc <> ? NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN c-aux = c-aux + "<CNPJ>" + trim(estabelec.cgc) + "</CNPJ>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar CNPJ de origem               CNPJ N«O ENCONTRADO"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux + "</c03_idContribuinteEmitente>" 
          + "<c28_tipoDocOrigem>10</c28_tipoDocOrigem>" 
          + "<c04_docOrigem>" + trim(nota-fiscal.nr-nota-fis) + "</c04_docOrigem>" 
          + "<c06_valorPrincipal>" + trim(REPLACE(STRING(TRUNCATE(de-vl-icmsub-it, 2), ">>>>>>>>>9.99"), SESSION:NUMERIC-DECIMAL-POINT, ".":U)) + "</c06_valorPrincipal>" .

    IF fi-data-venc <> ? AND fi-data-venc > date(today) THEN
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(fi-data-venc) + "</c14_dataVencimento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(TODAY + 3) + "</c14_dataVencimento>" .

    ASSIGN c-aux = c-aux + "<c16_razaoSocialEmitente>" + trim(estabelec.nome) + "</c16_razaoSocialEmitente>" 
        + "<c18_enderecoEmitente>" + trim(estabelec.endereco) + "</c18_enderecoEmitente>" .

    IF estabelec.cidade = "Sao Jose" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>16602</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Santa Rita do Sapuca°" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>59605</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Manaus" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>02603</c19_municipioEmitente>" .
        ELSE IF estabelec.cidade = "Palhoáa" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>11900</c19_municipioEmitente>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar cidade de origem               CIDADE N«O ENCONTRADA"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux + "<c20_ufEnderecoEmitente>" + trim(estabelec.estado) + "</c20_ufEnderecoEmitente>" .

    IF nota-fiscal.ins-estadual <> ? AND nota-fiscal.ins-estadual <> "ISENTO" THEN
        ASSIGN c-aux = c-aux + "<c36_inscricaoEstadualDestinatario>" + trim(replace(nota-fiscal.ins-estadual,".","")) + "</c36_inscricaoEstadualDestinatario>" .
    ELSE DO:
        IF nota-fiscal.ins-estadual = ? OR nota-fiscal.ins-estadual = "" THEN
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO EM BRANCO"). 
        ELSE
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO ISENTO"). 
            RETURN "NOK".
    END.

    IF fi-data-venc <> ? AND fi-data-venc > today AND tg-ativo = YES THEN
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(fi-data-venc) + "</c33_dataPagamento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(TODAY + 3) + "</c33_dataPagamento>" .
    RUN pi-dados-destinatario.
    ASSIGN c-aux = c-aux + "<c05_referencia>" 
        + "<periodo>0</periodo>" 
        + "<mes>" + STRING(MONTH(nota-fiscal.dt-emis-nota),"99":U) + "</mes>"  
        + "<ano>" + string(year(nota-fiscal.dt-emis-nota),"9999":U) + "</ano>"  
        + "</c05_referencia>" 
        + "</TDadosGNRE>".                                       

    RUN pi-cria-mensagem (INPUT "Informaá∆o",
                          INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + "                                                                 OK"). 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-xml-4 wWindow 
PROCEDURE pi-xml-4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* UF favorecida AL - CE - MS                                                               */
/* ê feito preenchimento do:                                                                */
/*                                                                                          */
/*UF favorecida                                                                             */
/*CNPJ - Raz∆o Social - Endereáo - UF - Municipio todos do emitente                         */
/*Receita - Documento de Origem - Data de Vencimento - Data de Pagamento                    */
/*Produto - Valor Principal                                                                 */
 
    ASSIGN c-aux = c-aux + "<TDadosGNRE>" 
        + "<c01_UfFavorecida>" + nota-fiscal.estado + "</c01_UfFavorecida>" 
        + "<c02_receita>100099</c02_receita>" .

    RUN pi-busca-produto.

/*     FIND FIRST int-item-uf                                                                                                                                                               */
/*         WHERE int-item-uf.it-codigo = it-nota-fisc.it-codigo                                                                                                                             */
/*           AND int-item-uf.protocolo <> ? NO-LOCK NO-ERROR.                                                                                                                               */
/*     IF AVAIL int-item-uf THEN DO:                                                                                                                                                        */
/*         IF SUBSTRING(int-item-uf.protocolo,1,3) = "192" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "106" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "198" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "117" THEN                                                                                                                             */
/*             ASSIGN c-aux = c-aux + "<c26_produto>11</c26_produto>" .                                                                                                                     */
/*     END.                                                                                                                                                                                 */
/*     ELSE DO:                                                                                                                                                                             */
/*         RUN pi-cria-mensagem (INPUT "Erro",                                                                                                                                              */
/*                       INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar produto de origem               PRODUTO N«O ENCONTRADO"). */
/*         RETURN "NOK".                                                                                                                                                                    */
/*     END.                                                                                                                                                                                 */

    ASSIGN c-aux = c-aux + "<c27_tipoIdentificacaoEmitente>1</c27_tipoIdentificacaoEmitente>" 
        + "<c03_idContribuinteEmitente>" .

    FIND FIRST estabelec
         WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel 
           AND estabelec.cgc <> ? NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN c-aux = c-aux + "<CNPJ>" + trim(estabelec.cgc) + "</CNPJ>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar CNPJ de origem               CNPJ N«O ENCONTRADO"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux + "</c03_idContribuinteEmitente>" 
          + "<c28_tipoDocOrigem>10</c28_tipoDocOrigem>" 
          + "<c04_docOrigem>" + trim(nota-fiscal.nr-nota-fis) + "</c04_docOrigem>" 
          + "<c06_valorPrincipal>" + trim(REPLACE(STRING(TRUNCATE(de-vl-icmsub-it, 2), ">>>>>>>>>9.99"), SESSION:NUMERIC-DECIMAL-POINT, ".":U)) + "</c06_valorPrincipal>" .

    IF fi-data-venc <> ? AND fi-data-venc > date(today) THEN
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(fi-data-venc) + "</c14_dataVencimento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(TODAY + 3) + "</c14_dataVencimento>" .

    ASSIGN c-aux = c-aux + "<c16_razaoSocialEmitente>" + trim(estabelec.nome) + "</c16_razaoSocialEmitente>" 
        + "<c18_enderecoEmitente>" + trim(estabelec.endereco) + "</c18_enderecoEmitente>" .

    IF estabelec.cidade = "Sao Jose" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>16602</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Santa Rita do Sapuca°" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>59605</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Manaus" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>02603</c19_municipioEmitente>" .
        ELSE IF estabelec.cidade = "Palhoáa" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>11900</c19_municipioEmitente>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar cidade de origem               CIDADE N«O ENCONTRADA"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux + "<c20_ufEnderecoEmitente>" + trim(estabelec.estado) + "</c20_ufEnderecoEmitente>" .

    IF nota-fiscal.ins-estadual <> ? AND nota-fiscal.ins-estadual <> "ISENTO" THEN
        ASSIGN c-aux = c-aux + "<c36_inscricaoEstadualDestinatario>" + trim(replace(nota-fiscal.ins-estadual,".","")) + "</c36_inscricaoEstadualDestinatario>" .
    ELSE DO:
        IF nota-fiscal.ins-estadual = ? OR nota-fiscal.ins-estadual = "" THEN
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO EM BRANCO"). 
        ELSE
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO ISENTO"). 
            RETURN "NOK".
    END.

    IF fi-data-venc <> ? AND fi-data-venc > today AND tg-ativo = YES THEN
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(fi-data-venc) + "</c33_dataPagamento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(TODAY + 3) + "</c33_dataPagamento>" .
    RUN pi-dados-destinatario.
    ASSIGN c-aux = c-aux + "</TDadosGNRE>".

    RUN pi-cria-mensagem (INPUT "Informaá∆o",
                          INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + "                                                                 OK"). 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-xml-5 wWindow 
PROCEDURE pi-xml-5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* UF favorecida SC                                                                         */
/* ê feito preenchimento do:                                                                */
/*                                                                                          */
/*UF favorecida                                                                             */
/*CNPJ - Raz∆o Social - Endereáo - UF - Municipio todos do emitente                         */
/*Receita - Documento de Origem - Data de Vencimento - Data de Pagamento                    */
/*Produto - Valor Principal                                                                 */

    ASSIGN c-aux = c-aux + "<TDadosGNRE>" 
        + "<c01_UfFavorecida>" + trim(nota-fiscal.estado) + "</c01_UfFavorecida>" 
        + "<c02_receita>100099</c02_receita>" .

    RUN pi-busca-produto.
    
/*     FIND FIRST int-item-uf                                                                                                                                                               */
/*         WHERE int-item-uf.it-codigo = it-nota-fisc.it-codigo                                                                                                                             */
/*           AND int-item-uf.protocolo <> ? NO-LOCK NO-ERROR.                                                                                                                               */
/*     IF AVAIL int-item-uf THEN DO:                                                                                                                                                        */
/*         IF SUBSTRING(int-item-uf.protocolo,1,3) = "192" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "106" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "198" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "117" THEN                                                                                                                             */
/*             ASSIGN c-aux = c-aux + "<c26_produto>11</c26_produto>" .                                                                                                                     */
/*     END.                                                                                                                                                                                 */
/*     ELSE DO:                                                                                                                                                                             */
/*         RUN pi-cria-mensagem (INPUT "Erro",                                                                                                                                              */
/*                       INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar produto de origem               PRODUTO N«O ENCONTRADO"). */
/*         RETURN "NOK".                                                                                                                                                                    */
/*     END.                                                                                                                                                                                 */

    ASSIGN c-aux = c-aux + "<c27_tipoIdentificacaoEmitente>1</c27_tipoIdentificacaoEmitente>" 
        + "<c03_idContribuinteEmitente>" .

    FIND FIRST estabelec
         WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel 
           AND estabelec.cgc <> ? NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN c-aux = c-aux + "<CNPJ>" + trim(estabelec.cgc) + "</CNPJ>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar CNPJ de origem               CNPJ N«O ENCONTRADO"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux + "</c03_idContribuinteEmitente>" 
          + "<c28_tipoDocOrigem>10</c28_tipoDocOrigem>" 
          + "<c04_docOrigem>" + trim(nota-fiscal.nr-nota-fis) + "</c04_docOrigem>" 
          + "<c10_valorTotal>" + trim(REPLACE(STRING(TRUNCATE(de-vl-icmsub-it, 2), ">>>>>>>>>9.99"), SESSION:NUMERIC-DECIMAL-POINT, ".":U)) + "</c10_valorTotal>" .

    IF fi-data-venc <> ? AND fi-data-venc > date(today) THEN
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(fi-data-venc) + "</c14_dataVencimento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(TODAY + 3) + "</c14_dataVencimento>" .

    ASSIGN c-aux = c-aux + "<c16_razaoSocialEmitente>" + trim(estabelec.nome) + "</c16_razaoSocialEmitente>" 
        + "<c18_enderecoEmitente>" + trim(estabelec.endereco) + "</c18_enderecoEmitente>" .

    IF estabelec.cidade = "Sao Jose" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>16602</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Santa Rita do Sapuca°" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>59605</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Manaus" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>02603</c19_municipioEmitente>" .
        ELSE IF estabelec.cidade = "Palhoáa" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>11900</c19_municipioEmitente>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar cidade de origem               CIDADE N«O ENCONTRADA"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux + "<c20_ufEnderecoEmitente>" + trim(estabelec.estado) + "</c20_ufEnderecoEmitente>" .

    IF nota-fiscal.ins-estadual <> ? AND nota-fiscal.ins-estadual <> "ISENTO" THEN
        ASSIGN c-aux = c-aux + "<c36_inscricaoEstadualDestinatario>" + trim(replace(nota-fiscal.ins-estadual,".","")) + "</c36_inscricaoEstadualDestinatario>" .
    ELSE DO:
        IF nota-fiscal.ins-estadual = ? OR nota-fiscal.ins-estadual = "" THEN
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO EM BRANCO"). 
        ELSE
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO ISENTO"). 
            RETURN "NOK".
    END.


    IF fi-data-venc <> ? AND fi-data-venc > today AND tg-ativo = YES THEN
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(fi-data-venc) + "</c33_dataPagamento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(TODAY + 3) + "</c33_dataPagamento>" .
    RUN pi-dados-destinatario.
    ASSIGN c-aux = c-aux + "</TDadosGNRE>".

    RUN pi-cria-mensagem (INPUT "Informaá∆o",
                          INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + "                                                                 OK"). 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-xml-6 wWindow 
PROCEDURE pi-xml-6 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* UF favorecida PA                                                                         */
/* ê feito preenchimento do:                                                                */
/*                                                                                          */
/*UF favorecida                                                                             */
/*CNPJ - Raz∆o Social - Endereáo - UF - Municipio todos do emitente                         */
/*Receita - Documento de Origem - Data de Vencimento - Data de Pagamento                    */
/*Per°odo de Referància - Valor Principal                                                   */    
    
    ASSIGN c-aux = c-aux + "<TDadosGNRE>" 
        + "<c01_UfFavorecida>" + trim(nota-fiscal.estado) + "</c01_UfFavorecida>" 
        + "<c02_receita>100099</c02_receita>" 
        + "<c27_tipoIdentificacaoEmitente>1</c27_tipoIdentificacaoEmitente>" 
        + "<c03_idContribuinteEmitente>" .

    FIND FIRST estabelec
         WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel 
           AND estabelec.cgc <> ? NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN c-aux = c-aux + "<CNPJ>" + trim(estabelec.cgc) + "</CNPJ>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar CNPJ de origem               CNPJ N«O ENCONTRADO"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux + "</c03_idContribuinteEmitente>" 
          + "<c28_tipoDocOrigem>10</c28_tipoDocOrigem>" 
          + "<c04_docOrigem>" + trim(nota-fiscal.nr-nota-fis) + "</c04_docOrigem>" 
          + "<c10_valorTotal>" + trim(REPLACE(STRING(TRUNCATE(de-vl-icmsub-it, 2), ">>>>>>>>>9.99"), SESSION:NUMERIC-DECIMAL-POINT, ".":U)) + "</c10_valorTotal>" .

    IF fi-data-venc <> ? AND fi-data-venc > date(today) THEN
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(fi-data-venc) + "</c14_dataVencimento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(TODAY + 3) + "</c14_dataVencimento>" .

    ASSIGN c-aux = c-aux + "<c16_razaoSocialEmitente>" + trim(estabelec.nome) + "</c16_razaoSocialEmitente>" 
        + "<c18_enderecoEmitente>" + trim(estabelec.endereco) + "</c18_enderecoEmitente>" .
        
    IF estabelec.cidade = "Sao Jose" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>16602</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Santa Rita do Sapuca°" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>59605</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Manaus" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>02603</c19_municipioEmitente>" .
        ELSE IF estabelec.cidade = "Palhoáa" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>11900</c19_municipioEmitente>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar cidade de origem               CIDADE N«O ENCONTRADA"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux + "<c20_ufEnderecoEmitente>" + trim(estabelec.estado) + "</c20_ufEnderecoEmitente>" .

    IF nota-fiscal.ins-estadual <> ? AND nota-fiscal.ins-estadual <> "ISENTO" THEN
        ASSIGN c-aux = c-aux + "<c36_inscricaoEstadualDestinatario>" + trim(replace(nota-fiscal.ins-estadual,".","")) + "</c36_inscricaoEstadualDestinatario>" .
    ELSE DO:
        IF nota-fiscal.ins-estadual = ? OR nota-fiscal.ins-estadual = "" THEN
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO EM BRANCO"). 
        ELSE
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO ISENTO"). 
            RETURN "NOK".
    END.


    IF fi-data-venc <> ? AND fi-data-venc > today AND tg-ativo = YES THEN
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(fi-data-venc) + "</c33_dataPagamento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(TODAY + 3) + "</c33_dataPagamento>" .
    RUN pi-dados-destinatario.
    ASSIGN c-aux = c-aux + "<c05_referencia>" 
        + "<mes>" + STRING(MONTH(nota-fiscal.dt-emis-nota),"99":U) + "</mes>"  
        + "<ano>" + string(year(nota-fiscal.dt-emis-nota),"9999":U) + "</ano>"  
        + "</c05_referencia>" 
        + "</TDadosGNRE>".

    RUN pi-cria-mensagem (INPUT "Informaá∆o",
                          INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + "                                                                 OK"). 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-xml-7 wWindow 
PROCEDURE pi-xml-7 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* UF favorecida DF                                                                         */
/* ê feito preenchimento do:                                                                */
/*                                                                                          */
/*UF favorecida                                                                             */
/*CNPJ - Raz∆o Social - Endereáo - UF - Municipio todos do emitente                         */
/*Receita - Produto - Documento de Origem - Data de Vencimento - Data de Pagamento                    */
/*Per°odo de Referància - Valor Principal                                                   */
               
    ASSIGN c-aux = c-aux + "<TDadosGNRE>" 
        + "<c01_UfFavorecida>" + trim(nota-fiscal.estado) + "</c01_UfFavorecida>" 
        + "<c02_receita>100099</c02_receita>" 
        + "<c25_detalhamentoReceita>000015</c25_detalhamentoReceita>" .

    RUN pi-busca-produto.

/*     FIND FIRST int-item-uf                                                                                                                                                               */
/*         WHERE int-item-uf.it-codigo = it-nota-fisc.it-codigo                                                                                                                             */
/*           AND int-item-uf.protocolo <> ? NO-LOCK NO-ERROR.                                                                                                                               */
/*     IF AVAIL int-item-uf THEN DO:                                                                                                                                                        */
/*         IF SUBSTRING(int-item-uf.protocolo,1,3) = "192" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "106" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "198" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "117" THEN                                                                                                                             */
/*             ASSIGN c-aux = c-aux + "<c26_produto>11</c26_produto>" .                                                                                                                     */
/*     END.                                                                                                                                                                                 */
/*     ELSE DO:                                                                                                                                                                             */
/*         RUN pi-cria-mensagem (INPUT "Erro",                                                                                                                                              */
/*                       INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar produto de origem               PRODUTO N«O ENCONTRADO"). */
/*         RETURN "NOK".                                                                                                                                                                    */
/*     END.                                                                                                                                                                                 */

    ASSIGN c-aux = c-aux + "<c27_tipoIdentificacaoEmitente>1</c27_tipoIdentificacaoEmitente>" 
        + "<c03_idContribuinteEmitente>" .

    FIND FIRST estabelec
         WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel 
           AND estabelec.cgc <> ? NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN c-aux = c-aux + "<CNPJ>" + trim(estabelec.cgc) + "</CNPJ>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar CNPJ de origem               CNPJ N«O ENCONTRADO"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux + "</c03_idContribuinteEmitente>" 
          + "<c28_tipoDocOrigem>10</c28_tipoDocOrigem>" 
          + "<c04_docOrigem>" + trim(nota-fiscal.nr-nota-fis) + "</c04_docOrigem>" 
          + "<c10_valorTotal>" + trim(REPLACE(STRING(TRUNCATE(de-vl-icmsub-it, 2), ">>>>>>>>>9.99"), SESSION:NUMERIC-DECIMAL-POINT, ".":U)) + "</c10_valorTotal>" .

    IF fi-data-venc <> ? AND fi-data-venc > date(today) THEN
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(fi-data-venc) + "</c14_dataVencimento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(TODAY + 3) + "</c14_dataVencimento>" .

    ASSIGN c-aux = c-aux + "<c16_razaoSocialEmitente>" + trim(estabelec.nome) + "</c16_razaoSocialEmitente>" 
        + "<c18_enderecoEmitente>" + trim(estabelec.endereco) + "</c18_enderecoEmitente>" .

    IF estabelec.cidade = "Sao Jose" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>16602</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Santa Rita do Sapuca°" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>59605</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Manaus" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>02603</c19_municipioEmitente>" .
        ELSE IF estabelec.cidade = "Palhoáa" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>11900</c19_municipioEmitente>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar cidade de origem               CIDADE N«O ENCONTRADA"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux + "<c20_ufEnderecoEmitente>" + trim(estabelec.estado) + "</c20_ufEnderecoEmitente>" .

    IF nota-fiscal.ins-estadual <> ? AND nota-fiscal.ins-estadual <> "ISENTO" THEN
        ASSIGN c-aux = c-aux + "<c36_inscricaoEstadualDestinatario>" + trim(replace(nota-fiscal.ins-estadual,".","")) + "</c36_inscricaoEstadualDestinatario>" .
    ELSE DO:
        IF nota-fiscal.ins-estadual = ? OR nota-fiscal.ins-estadual = "" THEN
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO EM BRANCO"). 
        ELSE
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO EM BRANCO"). 
            RETURN "NOK".
    END.


    IF fi-data-venc <> ? AND fi-data-venc > today AND tg-ativo = YES THEN
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(fi-data-venc) + "</c33_dataPagamento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(TODAY + 3) + "</c33_dataPagamento>" .
    RUN pi-dados-destinatario.
    ASSIGN c-aux = c-aux + "<c05_referencia>" 
        + "<mes>" + STRING(MONTH(nota-fiscal.dt-emis-nota),"99":U) + "</mes>"  
        + "<ano>" + string(year(nota-fiscal.dt-emis-nota),"9999":U) + "</ano>"  
        + "<parcela>01</parcela>" 
        + "</c05_referencia>"
        + "</TDadosGNRE>".             

    RUN pi-cria-mensagem (INPUT "Informaá∆o",
                          INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + "                                                                 OK"). 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-xml-8 wWindow 
PROCEDURE pi-xml-8 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* UF favorecida GO - PE - RN                                                               */
/* ê feito preenchimento do:                                                                */
/*                                                                                          */
/*UF favorecida                                                                             */
/*CNPJ - Raz∆o Social - Endereáo - UF - Municipio todos do emitente                         */
/*Receita - Produto - Documento de Origem - Data de Vencimento - Data de Pagamento                    */
/*Per°odo de Referància - Valor Principal                                                   */
               
    ASSIGN c-aux = c-aux + "<TDadosGNRE>" 
        + "<c01_UfFavorecida>" + trim(nota-fiscal.estado) + "</c01_UfFavorecida>" 
        + "<c02_receita>100099</c02_receita>" .

    RUN pi-busca-produto.

/*     FIND FIRST int-item-uf                                                                                                                                                               */
/*         WHERE int-item-uf.it-codigo = it-nota-fisc.it-codigo                                                                                                                             */
/*           AND int-item-uf.protocolo <> ? NO-LOCK NO-ERROR.                                                                                                                               */
/*     IF AVAIL int-item-uf THEN DO:                                                                                                                                                        */
/*         IF SUBSTRING(int-item-uf.protocolo,1,3) = "192" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "106" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "198" OR                                                                                                                               */
/*            SUBSTRING(int-item-uf.protocolo,1,3) = "117" THEN                                                                                                                             */
/*             ASSIGN c-aux = c-aux + "<c26_produto>11</c26_produto>" .                                                                                                                     */
/*     END.                                                                                                                                                                                 */
/*     ELSE DO:                                                                                                                                                                             */
/*         RUN pi-cria-mensagem (INPUT "Erro",                                                                                                                                              */
/*                       INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar produto de origem               PRODUTO N«O ENCONTRADO"). */
/*         RETURN "NOK".                                                                                                                                                                    */
/*     END.                                                                                                                                                                                 */

    ASSIGN c-aux = c-aux + "<c27_tipoIdentificacaoEmitente>1</c27_tipoIdentificacaoEmitente>" 
        + "<c03_idContribuinteEmitente>" .

    FIND FIRST estabelec
         WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel 
           AND estabelec.cgc <> ? NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN c-aux = c-aux + "<CNPJ>" + trim(estabelec.cgc) + "</CNPJ>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar CNPJ de origem               CNPJ N«O ENCONTRADO"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux + "</c03_idContribuinteEmitente>" 
          + "<c28_tipoDocOrigem>10</c28_tipoDocOrigem>" 
          + "<c04_docOrigem>" + trim(nota-fiscal.nr-nota-fis) + "</c04_docOrigem>" 
          + "<c06_valorPrincipal>" + trim(REPLACE(STRING(TRUNCATE(de-vl-icmsub-it, 2), ">>>>>>>>>9.99"), SESSION:NUMERIC-DECIMAL-POINT, ".":U)) + "</c06_valorPrincipal>" .

    IF fi-data-venc <> ? AND fi-data-venc > date(today) THEN
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(fi-data-venc) + "</c14_dataVencimento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(TODAY + 3) + "</c14_dataVencimento>" .

    ASSIGN c-aux = c-aux + "<c16_razaoSocialEmitente>" + trim(estabelec.nome) + "</c16_razaoSocialEmitente>" 
        + "<c18_enderecoEmitente>" + trim(estabelec.endereco) + "</c18_enderecoEmitente>" .

    IF estabelec.cidade = "Sao Jose" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>16602</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Santa Rita do Sapuca°" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>59605</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Manaus" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>02603</c19_municipioEmitente>" .
        ELSE IF estabelec.cidade = "Palhoáa" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>11900</c19_municipioEmitente>" .
    ELSE DO:
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar cidade de origem               CIDADE N«O ENCONTRADA"). 
        RETURN "NOK".
    END.

    ASSIGN c-aux = c-aux + "<c20_ufEnderecoEmitente>" + trim(estabelec.estado) + "</c20_ufEnderecoEmitente>" .

    IF nota-fiscal.ins-estadual <> ? AND nota-fiscal.ins-estadual <> "ISENTO" THEN
        ASSIGN c-aux = c-aux + "<c36_inscricaoEstadualDestinatario>" + trim(replace(nota-fiscal.ins-estadual,".","")) + "</c36_inscricaoEstadualDestinatario>" .
    ELSE DO:
        IF nota-fiscal.ins-estadual = ? OR nota-fiscal.ins-estadual = "" THEN
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO EM BRANCO"). 
        ELSE
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO ISENTO"). 
            RETURN "NOK".
    END.


    IF fi-data-venc <> ? AND fi-data-venc > today AND tg-ativo = YES THEN
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(fi-data-venc) + "</c33_dataPagamento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(TODAY + 3) + "</c33_dataPagamento>" .
    RUN pi-dados-destinatario.
    ASSIGN c-aux = c-aux + "<c05_referencia>" 
        + "<mes>" + STRING(MONTH(nota-fiscal.dt-emis-nota),"99":U) + "</mes>"  
        + "<ano>" + string(year(nota-fiscal.dt-emis-nota),"9999":U) + "</ano>"  
        + "</c05_referencia>" 
        + "</TDadosGNRE>".                                 

    RUN pi-cria-mensagem (INPUT "Informaá∆o",
                          INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + "                                                                 OK"). 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-xml-9 wWindow 
PROCEDURE pi-xml-9 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* UF favorecida PB                                                                         */
/* ê feito preenchimento do:                                                                */
/*                                                                                          */
/*UF favorecida                                                                             */
/*CNPJ - Raz∆o Social - Endereáo - UF - Municipio todos do emitente                         */
/*Receita - Documento de Origem - Data de Vencimento - Data de Pagamento                    */
/*Per°odo de Referància - Valor Principal                                                   */

    ASSIGN c-aux = c-aux + "<TDadosGNRE>" 
        + "<c01_UfFavorecida>" + trim(nota-fiscal.estado) + "</c01_UfFavorecida>" 
        + "<c02_receita>100099</c02_receita>" 
        + "<c27_tipoIdentificacaoEmitente>1</c27_tipoIdentificacaoEmitente>" 
        + "<c03_idContribuinteEmitente>" .

    FIND FIRST estabelec
         WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel 
           AND estabelec.cgc <> ? NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN c-aux = c-aux + "<CNPJ>" + trim(estabelec.cgc) + "</CNPJ>" .
    ELSE
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar CNPJ de origem               CNPJ N«O ENCONTRADO"). 

    ASSIGN c-aux = c-aux + "</c03_idContribuinteEmitente>" 
          + "<c06_valorPrincipal>" + trim(REPLACE(STRING(TRUNCATE(de-vl-icmsub-it, 2), ">>>>>>>>>9.99"), SESSION:NUMERIC-DECIMAL-POINT, ".":U)) + "</c06_valorPrincipal>" .

    IF fi-data-venc <> ? AND fi-data-venc > date(today) THEN
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(fi-data-venc) + "</c14_dataVencimento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c14_dataVencimento>" + ISO-DATE(TODAY + 3) + "</c14_dataVencimento>" .

    ASSIGN c-aux = c-aux + "<c16_razaoSocialEmitente>" + trim(estabelec.nome) + "</c16_razaoSocialEmitente>" 
        + "<c18_enderecoEmitente>" + trim(estabelec.endereco) + "</c18_enderecoEmitente>" .

    IF estabelec.cidade = "Sao Jose" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>16602</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Santa Rita do Sapuca°" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>59605</c19_municipioEmitente>" .
    ELSE IF estabelec.cidade = "Manaus" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>02603</c19_municipioEmitente>" .
        ELSE IF estabelec.cidade = "Palhoáa" THEN
        ASSIGN c-aux = c-aux + "<c19_municipioEmitente>11900</c19_municipioEmitente>" .
    ELSE
        RUN pi-cria-mensagem (INPUT "Erro",
                      INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " n∆o foi poss°vel encontrar cidade de origem               CIDADE N«O ENCONTRADA"). 

    ASSIGN c-aux = c-aux + "<c20_ufEnderecoEmitente>" + trim(estabelec.estado) + "</c20_ufEnderecoEmitente>" .

    IF nota-fiscal.ins-estadual <> ? AND nota-fiscal.ins-estadual <> "ISENTO" THEN
        ASSIGN c-aux = c-aux + "<c36_inscricaoEstadualDestinatario>" + trim(replace(nota-fiscal.ins-estadual,".","")) + "</c36_inscricaoEstadualDestinatario>" .
    ELSE DO:
        IF nota-fiscal.ins-estadual = ? OR nota-fiscal.ins-estadual = "" THEN
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO EM BRANCO"). 
        ELSE
            RUN pi-cria-mensagem (INPUT "Erro",
                                  INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + " est† com a inscris∆o estadual do destinat†rio              INSCRIÄ«O ESTADUAL DESTINATµRIO ISENTO"). 
    END.


    IF fi-data-venc <> ? AND fi-data-venc > today AND tg-ativo = YES THEN
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(fi-data-venc) + "</c33_dataPagamento>" .
    ELSE 
        ASSIGN c-aux = c-aux + "<c33_dataPagamento>" + ISO-DATE(TODAY + 3) + "</c33_dataPagamento>" .
    RUN pi-dados-destinatario.
    ASSIGN c-aux = c-aux + "<c05_referencia>" 
        + "<mes>" + STRING(MONTH(nota-fiscal.dt-emis-nota),"99":U) + "</mes>"  
        + "<ano>" + string(year(nota-fiscal.dt-emis-nota),"9999":U) + "</ano>"  
        + "</c05_referencia>" 
        + "</TDadosGNRE>".

    RUN pi-cria-mensagem (INPUT "Informaá∆o",
                          INPUT "Nota Fiscal: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + "                                                                 OK"). 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wWindow 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
       para o programa RP.P */
    
    create tt-param-aux.
    assign tt-param-aux.estabel-ini      = INPUT FRAME fpage1 fi-estabel-ini      
           tt-param-aux.estabel-fim      = INPUT FRAME fpage1 fi-estabel-fim     
           tt-param-aux.serie-ini        = INPUT FRAME fpage1 fi-serie-ini       
           tt-param-aux.serie-fim        = INPUT FRAME fpage1 fi-serie-fim      
           tt-param-aux.nota-ini         = INPUT FRAME fpage1 fi-nota-ini      
           tt-param-aux.nota-fim         = INPUT FRAME fpage1 fi-nota-fim      
           tt-param-aux.dt-emis-nota-ini = INPUT FRAME fpage1 dt-emis-ini
           tt-param-aux.dt-emis-nota-fim = INPUT FRAME fpage1 dt-emis-fim
           tt-param-aux.data-venc        = INPUT FRAME fpage1 fi-data-venc.

    ASSIGN INPUT FRAME fpage1 fi-data-venc
           INPUT FRAME fpage1 tg-ativo.

    ASSIGN c-imprime = fi-imprime:SCREEN-VALUE IN FRAME fpage1.

    IF tg-ativo:SCREEN-VALUE = "NO" THEN
        run piImprimexml.
    ELSE DO:
        IF fi-data-venc > TODAY THEN
            run piImprimexml.
        ELSE
            MESSAGE "A data de vencimento tem que ser maior que a data de hoje."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END.
    
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimexml wWindow 
PROCEDURE piImprimexml :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  run utp/ut-acomp.p persistent set h-acomp.  
  run pi-inicializar in h-acomp (input "Imprimindo...").
  
    OUTPUT STREAM str-xml TO VALUE(c-imprime).

       ASSIGN c-aux = ""
              c-empresa = ""
              c-titulo-relat = "" 
              c-rodape = ""       
              c-rodape = "".
       ASSIGN c-aux = c-aux + '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>' 
                            + '<TLote_GNRE xmlns="http://www.gnre.pe.gov.br">' 
                            + "<guias>" .

       PUT STREAM str-xml UNFORMAT c-aux SKIP.

       ASSIGN c-aux = "".
       FOR EACH tt-mensagem.
           DELETE tt-mensagem.
       END.

    
       bk-nota-fiscal:
       FOR EACH nota-fiscal NO-LOCK 
           WHERE nota-fiscal.cod-estabel  >= tt-param-aux.estabel-ini 
             AND nota-fiscal.cod-estabel  <= tt-param-aux.estabel-fim 
             AND nota-fiscal.serie        >= tt-param-aux.serie-ini 
             AND nota-fiscal.serie        <= tt-param-aux.serie-fim 
             AND nota-fiscal.nr-nota-fis  >= tt-param-aux.nota-ini 
             AND nota-fiscal.nr-nota-fis  <= tt-param-aux.nota-fim
             AND nota-fiscal.dt-emis-nota >= tt-param-aux.dt-emis-nota-ini
             AND nota-fiscal.dt-emis-nota <= tt-param-aux.dt-emis-nota-fim
             AND nota-fiscal.dt-cancel    = ?:
           
           IF CAN-FIND (FIRST it-nota-fisc NO-LOCK
               WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
                 AND it-nota-fisc.serie       = nota-fiscal.serie
                 AND it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
                 AND it-nota-fisc.vl-icmsub-it <> 0) THEN DO:
              ASSIGN de-vl-icmsub-it = 0.
              FOR each it-nota-fisc NO-LOCK
                   WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
                     AND it-nota-fisc.serie       = nota-fiscal.serie
                     AND it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
                     AND it-nota-fisc.vl-icmsub-it <> 0:
                  ASSIGN de-vl-icmsub-it = de-vl-icmsub-it + it-nota-fisc.vl-icmsub-it.
              END.

               ASSIGN i-cont-nota = i-cont-nota + 1.
               
               RUN pi-acompanhar in h-acomp (input "Gerando XML...      Nr Nota: " + nota-fiscal.nr-nota-fis).
               
               ASSIGN c-estado = nota-fiscal.estado
                      c-aux = "".

                CASE c-estado:
                   WHEN "AP" OR
                   WHEN "PR" OR
                   WHEN "RS" THEN
                       RUN pi-xml-1.
                   WHEN "AC" OR
                   WHEN "MG" OR
                   WHEN "RO" THEN
                       RUN pi-xml-2.
                   WHEN "AM" OR
                   WHEN "BA" OR
                   WHEN "SE" THEN
                       RUN pi-xml-3.
                   WHEN "AL" OR 
                   WHEN "CE" OR 
                   WHEN "MS" THEN
                       RUN pi-xml-4.
                   WHEN "SC" THEN
                       RUN pi-xml-5.
                   WHEN "PA" THEN
                       RUN pi-xml-6.
                   WHEN "DF" THEN 
                       RUN pi-xml-7.
                   WHEN "GO" OR
                   WHEN "PE" OR
                   WHEN "RN" THEN
                       RUN pi-xml-8.
                   WHEN "PB" THEN
                       RUN pi-xml-9.
                   WHEN "PI" OR
                   WHEN "RR" THEN
                       RUN pi-xml-10.
                   WHEN "MT" THEN
                       RUN pi-xml-11.
                   WHEN "MA" THEN
                       RUN pi-xml-12.
                   WHEN "TO" THEN
                       RUN pi-xml-13.
               END CASE.

               IF RETURN-VALUE = "NOK" THEN
                   NEXT bk-nota-fiscal.
               
               PUT STREAM str-xml UNFORMAT c-aux SKIP.
           END.
       END.
    
       ASSIGN c-aux = "".
       ASSIGN c-aux = c-aux + "</guias>"  
                            + "</TLote_GNRE>".

       PUT STREAM str-xml UNFORMAT c-aux SKIP.

    OUTPUT STREAM str-xml CLOSE.

    RUN pi-imprime-mensagem.

    MESSAGE "Gerado XML com sucesso na pasta: " + c-imprime
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

