&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
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
{include/i-prgvrs.i ESGTP013 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESGTP013
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              fi-cod-estabel-ini fi-cod-estabel-fim fi-dt-emissao-ini fi-dt-emissao-fim ~
                              fi-uf-ini fi-uf-fim ~
                              fi-nr-nota-fisc-ini fi-nr-nota-fisc-fim ~
                              fi-cod-emitente brDetalhe bt-confirma ~
                              fi-serie-ini fi-serie-fim fi-embarque bt-sair
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-acomp  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-progam AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-dados NO-UNDO
    FIELD cod-estabel    LIKE docum-est.cod-estabel
    FIELD serie          LIKE docum-est.serie
    FIELD nro-docto      LIKE docum-est.nro-docto
    FIELD cod-emitente   LIKE docum-est.cod-emitente
    FIELD nat-operacao   LIKE docum-est.nat-operacao
    FIELD dt-trans       LIKE docum-est.dt-trans
    FIELD valor-mercad   LIKE docum-est.valor-mercad
    FIELD valor-frete    LIKE docum-est.valor-frete
    FIELD peso-bruto-tot LIKE docum-est.peso-bruto-tot
    FIELD uf             LIKE docum-est.uf
    FIELD cidade         LIKE docum-est.cidade
    FIELD cod-incoterm   LIKE embarque-imp.cod-incoterm
    FIELD embarque       LIKE embarque-imp.embarque
    FIELD data-DI        LIKE embarque-imp.data-DI  
    FIELD vl-desp-13     LIKE desp-embarque.val-desp
    FIELD vl-desp-31     LIKE desp-embarque.val-desp
    FIELD vl-desp-59     LIKE desp-embarque.val-desp
    FIELD declaracao-imp LIKE embarque-imp.declaracao-import
    FIELD des-origem       AS CHAR
    FIELD nom-fornec       AS CHAR
    FIELD des-modal        AS CHAR
    FIELD des-itinerario   AS CHAR
    FIELD FI               AS CHAR
    FIELD natureza         AS CHAR
    INDEX id-docto
            serie       
            nro-docto   
            cod-emitente
            nat-operacao.

DEF TEMP-TABLE tt-cfop-frete NO-UNDO
    FIELD cod-cfop AS CHAR
    INDEX id-cfop
            cod-cfop.

DEF TEMP-TABLE tt-desp-imp NO-UNDO
    FIELD cod-desp AS INT
    INDEX id-desp
            cod-desp.

DEFINE VARIABLE v-dat-tmp        AS DATE        NO-UNDO.
DEFINE VARIABLE v-num-entr-param AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-cod-cfop-nf    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-log-nf-ok      AS LOGICAL     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDetalhe

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-dados

/* Definitions for BROWSE brDetalhe                                     */
&Scoped-define FIELDS-IN-QUERY-brDetalhe tt-dados.cod-estabel tt-dados.serie tt-dados.nro-docto tt-dados.nat-operacao tt-dados.cod-emitente tt-dados.nom-fornec tt-dados.natureza tt-dados.dt-trans tt-dados.valor-mercad tt-dados.valor-frete tt-dados.peso-bruto-tot tt-dados.uf tt-dados.cidade tt-dados.des-origem tt-dados.embarque tt-dados.cod-incoterm tt-dados.des-itinerario tt-dados.des-modal tt-dados.declaracao-imp tt-dados.data-DI tt-dados.vl-desp-13 tt-dados.vl-desp-31 tt-dados.vl-desp-59 tt-dados.FI   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDetalhe   
&Scoped-define SELF-NAME brDetalhe
&Scoped-define QUERY-STRING-brDetalhe FOR EACH tt-dados
&Scoped-define OPEN-QUERY-brDetalhe OPEN QUERY {&SELF-NAME} FOR EACH tt-dados.
&Scoped-define TABLES-IN-QUERY-brDetalhe tt-dados
&Scoped-define FIRST-TABLE-IN-QUERY-brDetalhe tt-dados


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brDetalhe}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-cod-estabel-ini fi-cod-estabel-fim ~
fi-nr-nota-fisc-ini fi-nr-nota-fisc-fim fi-dt-emissao-ini fi-dt-emissao-fim ~
fi-serie-ini fi-serie-fim fi-embarque fi-uf-ini fi-uf-fim fi-cod-emitente ~
bt-confirma bt-sair brDetalhe btQueryJoins btReportsJoins btExit IMAGE-03 ~
btHelp IMAGE-04 IMAGE-01 IMAGE-02 IMAGE-05 IMAGE-06 IMAGE-7 IMAGE-8 IMAGE-9 ~
IMAGE-10 RECT-1 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-estabel-ini fi-cod-estabel-fim ~
fi-nr-nota-fisc-ini fi-nr-nota-fisc-fim fi-dt-emissao-ini fi-dt-emissao-fim ~
fi-serie-ini fi-serie-fim fi-embarque fi-uf-ini fi-uf-fim fi-cod-emitente 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-confirma 
     IMAGE-UP FILE "image/im-enter.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-enter.bmp":U
     LABEL "Filtrar" 
     SIZE 4 BY 1.13 TOOLTIP "Filtrar notas fiscais"
     FONT 4.

DEFINE BUTTON bt-sair 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Sair" 
     SIZE 4 BY 1.13 TOOLTIP "Sair do programa"
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.42
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.42
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.42
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.42
     FONT 4.

DEFINE VARIABLE fi-cod-emitente AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel-fim AS CHARACTER FORMAT "x(03)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel-ini AS CHARACTER FORMAT "x(03)" 
     LABEL "Estabelecimento":R15 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-emissao-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-emissao-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/1000 
     LABEL "Data Entrada" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-embarque AS CHARACTER FORMAT "X(12)":U 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-nota-fisc-fim AS CHARACTER FORMAT "x(7)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-nota-fisc-ini AS CHARACTER FORMAT "x(7)" 
     LABEL "Nr Nota Fiscal":R17 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-serie-fim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-serie-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-uf-fim AS CHARACTER FORMAT "x(2)":U INITIAL "ZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-uf-ini AS CHARACTER FORMAT "x(2)":U 
     LABEL "UF" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-01
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-02
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-03
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-04
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-05
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-06
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 110 BY 4.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDetalhe FOR 
      tt-dados SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDetalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDetalhe wWindow _FREEFORM
  QUERY brDetalhe DISPLAY
      tt-dados.cod-estabel                       COLUMN-LABEL "Est"     
tt-dados.serie                                                 WIDTH 3
tt-dados.nro-docto                         COLUMN-LABEL "Nota"       WIDTH 6
tt-dados.nat-operacao                 
tt-dados.cod-emitente                      COLUMN-LABEL "Fornecedor"
tt-dados.nom-fornec        FORMAT "x(60)"  COLUMN-LABEL "Nome"       WIDTH 40
tt-dados.natureza          FORMAT "x(15)"  COLUMN-LABEL "Tipo Fornec" 
tt-dados.dt-trans                          COLUMN-LABEL "Entrada"
tt-dados.valor-mercad                      COLUMN-LABEL "Valor Nota"
tt-dados.valor-frete                                                 WIDTH 9
tt-dados.peso-bruto-tot                    COLUMN-LABEL "Peso"       WIDTH 9
tt-dados.uf                                                     
tt-dados.cidade            FORMAT "x(60)"                           WIDTH 20
tt-dados.des-origem        FORMAT "x(10)" COLUMN-LABEL "Origem"     WIDTH 8
tt-dados.embarque          FORMAT "x(12)" COLUMN-LABEL "Embarque"   WIDTH 11
tt-dados.cod-incoterm  
tt-dados.des-itinerario    FORMAT "x(60)" COLUMN-LABEL "Itiner rio" WIDTH 30  
tt-dados.des-modal         FORMAT "x(15)" COLUMN-LABEL "Modal"      WIDTH 15
tt-dados.declaracao-imp    FORMAT "x(20)" COLUMN-LABEL "DI"         WIDTH 15
tt-dados.data-DI                          COLUMN-LABEL "Data DI"      
tt-dados.vl-desp-13                       COLUMN-LABEL "Armaz. Infraero"
tt-dados.vl-desp-31                       COLUMN-LABEL "Armaz. Porto"
tt-dados.vl-desp-59                       COLUMN-LABEL "Armaz. Guarulhos"
tt-dados.FI                FORMAT "x(10)" COLUMN-LABEL "FI"         WIDTH 30
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-COLUMN-SCROLLING SEPARATORS SIZE 110 BY 16.5
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-cod-estabel-ini AT ROW 1.5 COL 17 COLON-ALIGNED HELP
          "C¢digo Estabelecimento"
     fi-cod-estabel-fim AT ROW 1.5 COL 38.43 COLON-ALIGNED HELP
          "C¢digo Estabelecimento" NO-LABEL WIDGET-ID 14
     fi-nr-nota-fisc-ini AT ROW 1.5 COL 65 COLON-ALIGNED HELP
          "N£mero da nota fiscal"
     fi-nr-nota-fisc-fim AT ROW 1.5 COL 89.29 COLON-ALIGNED HELP
          "N£mero da nota fiscal" NO-LABEL
     fi-dt-emissao-ini AT ROW 2.5 COL 17 COLON-ALIGNED
     fi-dt-emissao-fim AT ROW 2.5 COL 38.43 COLON-ALIGNED NO-LABEL
     fi-serie-ini AT ROW 2.5 COL 65 COLON-ALIGNED WIDGET-ID 2
     fi-serie-fim AT ROW 2.5 COL 89.29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     fi-embarque AT ROW 3.5 COL 65 COLON-ALIGNED WIDGET-ID 24
     fi-uf-ini AT ROW 3.5 COL 17 COLON-ALIGNED
     fi-uf-fim AT ROW 3.5 COL 38.43 COLON-ALIGNED NO-LABEL
     fi-cod-emitente AT ROW 4.5 COL 65 COLON-ALIGNED
     bt-confirma AT ROW 1.5 COL 107 HELP
          "Filtrar objetos expedidos pelos Correios" WIDGET-ID 20
     bt-sair AT ROW 2.75 COL 107 HELP
          "Sair do programa" WIDGET-ID 18
     brDetalhe AT ROW 6 COL 2
     btQueryJoins AT ROW 1 COL 153 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1 COL 157 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1 COL 161 HELP
          "Sair"
     btHelp AT ROW 1 COL 165 HELP
          "Ajuda"
     IMAGE-03 AT ROW 3.5 COL 29.57
     IMAGE-04 AT ROW 3.5 COL 37
     IMAGE-01 AT ROW 2.5 COL 29.57
     IMAGE-02 AT ROW 2.5 COL 37
     IMAGE-05 AT ROW 1.5 COL 82.57
     IMAGE-06 AT ROW 1.5 COL 88
     IMAGE-7 AT ROW 2.5 COL 82.57 WIDGET-ID 6
     IMAGE-8 AT ROW 2.5 COL 88 WIDGET-ID 8
     IMAGE-9 AT ROW 1.5 COL 29.57 WIDGET-ID 10
     IMAGE-10 AT ROW 1.5 COL 37 WIDGET-ID 12
     RECT-1 AT ROW 1.25 COL 2 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 170.57 BY 27.92
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
         HEIGHT             = 21.71
         WIDTH              = 111.57
         MAX-HEIGHT         = 32.5
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 32.5
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB brDetalhe bt-sair fpage0 */
ASSIGN 
       brDetalhe:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE
       brDetalhe:COLUMN-MOVABLE IN FRAME fpage0         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDetalhe
/* Query rebuild information for BROWSE brDetalhe
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-dados.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDetalhe */
&ANALYZE-RESUME

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


&Scoped-define BROWSE-NAME brDetalhe
&Scoped-define SELF-NAME brDetalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDetalhe wWindow
ON MOUSE-SELECT-DBLCLICK OF brDetalhe IN FRAME fpage0
DO:
/*     IF AVAIL tt-dados AND tt-dados.r-nf-tr <> ?THEN DO:                    */
/*         SESSION:SET-WAIT-STATE("GENERAL":U).                               */
/*         RUN gtp/gt0703.w PERSISTENT SET h-progam.                          */
/*         IF  VALID-HANDLE (h-progam) THEN DO:                               */
/*             RUN initializeInterface IN h-progam.                           */
/*             IF  RETURN-VALUE = "OK":U THEN                                 */
/*                 RUN repositionRecord IN h-progam (INPUT tt-dados.r-nf-tr). */
/*         END.                                                               */
/*         SESSION:SET-WAIT-STATE("":U).                                      */
/*     END.                                                                   */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma wWindow
ON CHOOSE OF bt-confirma IN FRAME fpage0 /* Filtrar */
DO:
    ASSIGN fi-cod-estabel-ini  = INPUT FRAME {&FRAME-NAME} fi-cod-estabel-ini
           fi-cod-estabel-fim  = INPUT FRAME {&FRAME-NAME} fi-cod-estabel-fim
           fi-dt-emissao-ini   = INPUT FRAME {&FRAME-NAME} fi-dt-emissao-ini
           fi-dt-emissao-fim   = INPUT FRAME {&FRAME-NAME} fi-dt-emissao-fim
           fi-uf-ini           = INPUT FRAME {&FRAME-NAME} fi-uf-ini
           fi-uf-fim           = INPUT FRAME {&FRAME-NAME} fi-uf-fim
           fi-nr-nota-fisc-ini = INPUT FRAME {&FRAME-NAME} fi-nr-nota-fisc-ini
           fi-nr-nota-fisc-fim = INPUT FRAME {&FRAME-NAME} fi-nr-nota-fisc-fim
           fi-serie-ini        = INPUT FRAME {&FRAME-NAME} fi-serie-ini
           fi-serie-fim        = INPUT FRAME {&FRAME-NAME} fi-serie-fim
           fi-embarque         = INPUT FRAME {&FRAME-NAME} fi-embarque
           fi-cod-emitente     = INPUT FRAME {&FRAME-NAME} fi-cod-emitente.

    RUN pi-carrega-dados.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sair wWindow
ON CHOOSE OF bt-sair IN FRAME fpage0 /* Sair */
APPLY "CLOSE":U TO THIS-PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

APPLY "ENTRY" TO fi-cod-estabel-ini IN FRAME fpage0.

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

    ASSIGN fi-dt-emissao-fim = DATE("01/" + STRING(MONTH(TODAY)) + "/" + STRING(YEAR(TODAY))) - 1
           fi-dt-emissao-ini = DATE("01/" + STRING(MONTH(fi-dt-emissao-fim)) + "/" + STRING(YEAR(fi-dt-emissao-fim))).

    DISP fi-dt-emissao-ini
         fi-dt-emissao-fim
        WITH FRAME fPage0.

    /* Identificar parƒmetros para filtro de notas */
    EMPTY TEMP-TABLE tt-cfop-frete.
    EMPTY TEMP-TABLE tt-desp-imp.

    FOR FIRST mgesp.ponto-programa
        WHERE ponto-programa.nome-programa = "esgtp013"
          AND ponto-programa.ponto         = 1,
         EACH mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
            
        IF  conteudo-programa.conteudo                  <> "" AND
            NUM-ENTRIES(conteudo-programa.conteudo,";")  > 1
        THEN DO:
            IF  ENTRY(1,conteudo-programa.conteudo,";") = "CFOP_FRETE"
            THEN DO:
                DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                    CREATE tt-cfop-frete.
                    ASSIGN tt-cfop-frete.cod-cfop = ENTRY(v-num-entr-param,conteudo-programa.conteudo,";").
                END.
            END.

            IF  ENTRY(1,conteudo-programa.conteudo,";") = "DESP_IMP"
            THEN DO:
                DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                    CREATE tt-desp-imp.
                    ASSIGN tt-desp-imp.cod-desp = INT(ENTRY(v-num-entr-param,conteudo-programa.conteudo,";")).
                END.
            END.

        END.
    END. /* FOR FIRST mgesp.ponto-programa */

    APPLY "ENTRY" TO fi-cod-estabel-ini IN FRAME fpage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-dados wWindow 
PROCEDURE pi-carrega-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE("GENERAL":U).

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Buscando_dados *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

EMPTY TEMP-TABLE tt-dados.

DO v-dat-tmp = fi-dt-emissao-ini TO fi-dt-emissao-fim:

    bloco-docum-est:
    FOR EACH  docum-est NO-LOCK
        WHERE docum-est.dt-trans     = v-dat-tmp
          AND docum-est.cod-estabel >= fi-cod-estabel-ini
          AND docum-est.cod-estabel <= fi-cod-estabel-fim:

        RUN pi-acompanhar IN h-acomp (INPUT STRING(docum-est.dt-trans,"99/99/9999")).

        IF  fi-cod-emitente <> 0 AND
            docum-est.cod-emitente <> fi-cod-emitente
        THEN
            NEXT bloco-docum-est.

        IF  docum-est.uf < fi-uf-ini OR
            docum-est.uf > fi-uf-fim
        THEN
            NEXT bloco-docum-est.

        IF  docum-est.nro-docto < fi-nr-nota-fisc-ini OR
            docum-est.nro-docto > fi-nr-nota-fisc-fim
        THEN
            NEXT bloco-docum-est.

        IF  docum-est.serie < fi-serie-ini OR
            docum-est.serie > fi-serie-fim
        THEN
            NEXT bloco-docum-est.

        ASSIGN v-cod-cfop-nf = SUBSTR(docum-est.nat-operacao,1,4).

        FIND FIRST tt-cfop-frete NO-LOCK
            WHERE  tt-cfop-frete.cod-cfop = v-cod-cfop-nf NO-ERROR.

        IF AVAIL tt-cfop-frete
        THEN
            NEXT bloco-docum-est.
            
        CREATE tt-dados.
        ASSIGN tt-dados.cod-estabel    = docum-est.cod-estabel
               tt-dados.serie          = docum-est.serie          
               tt-dados.nro-docto      = docum-est.nro-docto      
               tt-dados.cod-emitente   = docum-est.cod-emitente   
               tt-dados.nat-operacao   = docum-est.nat-operacao   
               tt-dados.dt-trans       = docum-est.dt-trans       
               tt-dados.valor-mercad   = docum-est.valor-mercad   
               tt-dados.peso-bruto-tot = docum-est.peso-bruto-tot 
               tt-dados.uf             = docum-est.uf             
               tt-dados.cidade         = docum-est.cidade
               tt-dados.des-origem     = "Nacional"
               tt-dados.cod-incoterm   = ""
               tt-dados.des-itinerario = ""
               tt-dados.FI             = ""
               v-log-nf-ok             = NO.
               
        find first emitente no-lock
            where emitente.cod-emitente = docum-est.cod-emitente no-error.
            
        if avail emitente then
            assign tt-dados.natureza = {adinc/i03ad098.i 04 emitente.natureza} .
        
        /* Busca Despesas Acess¢rias */
        bloco-despesa-aces:
        FOR EACH despesa-aces OF docum-est NO-LOCK:

            ASSIGN v-cod-cfop-nf = SUBSTR(despesa-aces.nat-oper-ac,1,4).
    
            FIND FIRST tt-cfop-frete NO-LOCK
                WHERE  tt-cfop-frete.cod-cfop = v-cod-cfop-nf NO-ERROR.
    
            IF AVAIL tt-cfop-frete
            THEN
                ASSIGN v-log-nf-ok          = YES
                       tt-dados.valor-frete = tt-dados.valor-frete + despesa-aces.valor.
        END.
       
        /* Busca Documentos de Importa‡Æo */
        FIND natur-oper NO-LOCK
            WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-ERROR.

        IF  AVAIL natur-oper AND
                  natur-oper.mercado = 2 /* Externo */
        THEN DO:
            ASSIGN tt-dados.des-origem = "Importado".

            FOR EACH  docum-est-cex NO-LOCK
                WHERE docum-est-cex.serie-docto  = docum-est.serie-docto
                  AND docum-est-cex.nro-docto    = string(docum-est.nro-docto)
                  AND docum-est-cex.cod-emitente = docum-est.cod-emitente
                  AND docum-est-cex.nat-operacao = docum-est.nat-operacao:

                FIND FIRST tt-desp-imp NO-LOCK
                    WHERE  tt-desp-imp.cod-desp = docum-est-cex.cod-desp NO-ERROR.

                IF  AVAIL tt-desp-imp
                THEN
                    ASSIGN v-log-nf-ok          = YES
                           tt-dados.valor-frete = tt-dados.valor-frete + docum-est-cex.val-desp.
            END. /* FOR EACH  docum-est-cex NO-LOCK */

            /* Busca Dados Embarque e Processo Importa‡Æo */
            bloco-item-doc-est:
            FOR EACH item-doc-est OF docum-est NO-LOCK:

                IF  tt-dados.cod-incoterm   <> "" AND 
                    tt-dados.des-itinerario <> ""
                THEN
                    LEAVE bloco-item-doc-est.

                IF  item-doc-est.numero-ordem <> 0
                THEN DO:
                    FIND FIRST ordens-embarque NO-LOCK
                        WHERE  ordens-embarque.numero-ordem = item-doc-est.numero-ordem
                          AND  ordens-embarque.parcela      = item-doc-est.parcela  NO-ERROR.

                    IF  AVAIL ordens-embarque
                    THEN DO:
                        FIND FIRST embarque-imp NO-LOCK
                            WHERE  embarque-imp.cod-estabel = docum-est.cod-estabel 
                              AND  embarque-imp.embarque    = ordens-embarque.embarque NO-ERROR.

                        IF  AVAIL embarque-imp THEN DO:
                            
                            ASSIGN tt-dados.cod-incoterm   = embarque-imp.cod-incoterm
                                   tt-dados.embarque       = embarque-imp.embarque
                                   tt-dados.des-modal      = {adinc/i01ad268.i 04 embarque-imp.cod-via-transp}
                                   tt-dados.declaracao-imp = embarque-imp.declaracao-import
                                   tt-dados.data-DI        = embarque-imp.data-DI.
                                   
                            for each desp-embarque no-lock 
                                where desp-embarque.embarque = embarque-imp.embarque:
                                
                                if desp-embarque.cod-desp = 13 then
                                    assign tt-dados.vl-desp-13 = desp-embarque.val-desp. 
                                    
                                if desp-embarque.cod-desp = 31 then
                                    assign tt-dados.vl-desp-31 = desp-embarque.val-desp.
                                    
                                if desp-embarque.cod-desp = 59 then
                                    assign tt-dados.vl-desp-59 = desp-embarque.val-desp. 
                            end.   
                                           
                        END.
                        
                        FIND FIRST processo-imp NO-LOCK
                            WHERE  processo-imp.cod-estabel = docum-est.cod-estabel
                              AND  processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp NO-ERROR.

                        IF  AVAIL processo-imp
                        THEN DO:
                            ASSIGN tt-dados.des-itinerario = STRING(processo-imp.cod-itiner).

                            FIND itinerario NO-LOCK
                                WHERE itinerario.cod-itiner = processo-imp.cod-itiner NO-ERROR.

                            IF  AVAIL itinerario
                            THEN
                                ASSIGN tt-dados.des-itinerario = tt-dados.des-itinerario + " - " + itinerario.descricao.
                        END.
                    END. /* IF  AVAIL ordens-embarque */
                END. /* IF  item-doc-est.numero-ordem <> 0 */
            END. /* FOR EACH item-doc-est OF docum-est NO-LOCK: */
        END. /* IF  AVAIL natur-oper AND */

        
        /* Busca Notas de Rateio */
        FOR EACH  rat-docum  NO-LOCK
            WHERE rat-docum.nf-emitente = docum-est.cod-emitente
              AND rat-docum.nf-nat-oper = docum-est.nat-operacao
              AND rat-docum.nf-nro      = docum-est.nro-docto
              AND rat-docum.nf-serie    = docum-est.serie-docto:

            ASSIGN v-cod-cfop-nf = SUBSTR(rat-docum.nat-operacao,1,4).
    
            FIND FIRST tt-cfop-frete NO-LOCK
                WHERE  tt-cfop-frete.cod-cfop = v-cod-cfop-nf NO-ERROR.
    
            IF AVAIL tt-cfop-frete
            THEN DO:
                FOR EACH item-doc-est OF docum-est NO-LOCK:
                    FIND FIRST movto-estoq NO-LOCK
                        WHERE  movto-estoq.serie        = rat-docum.serie
                          AND  movto-estoq.nro-docto    = rat-docum.nro-docto    
                          AND  movto-estoq.cod-emitente = rat-docum.cod-emitente       
                          AND  movto-estoq.nat-operacao = rat-docum.nat-operacao
                          AND  movto-estoq.esp-docto    = 18 /* NC */
                          AND  movto-estoq.it-codigo    = item-doc-est.it-codigo NO-ERROR.

                    IF  AVAIL movto-estoq
                    THEN
                        ASSIGN v-log-nf-ok          = YES
                               tt-dados.valor-frete = tt-dados.valor-frete + movto-estoq.valor-mat-m[1].
                END. /* FOR EACH item-doc-est OF docum-est NO-LOCK: */
            END. /* IF AVAIL tt-cfop-frete */
        END. /* FOR EACH  rat-docum  NO-LOCK */

        IF  v-log-nf-ok = NO
        THEN DO:
            DELETE tt-dados.
            NEXT bloco-docum-est.
        END.

        FIND emitente NO-LOCK
            WHERE emitente.cod-emitente = docum-est.cod-emitente NO-ERROR.

        IF  AVAIL emitente
        THEN
            ASSIGN tt-dados.nom-fornec = emitente.nome-emit.

    END. /* FOR EACH  docum-est NO-LOCK */
END. /* DO v-dat-tmp = fi-dt-emissao-ini TO fi-dt-emissao-fim: */

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

IF fi-embarque <> '' THEN
    FOR EACH tt-dados
        WHERE tt-dados.embarque <> fi-embarque:
        DELETE tt-dados.
    END.

{&OPEN-QUERY-brDetalhe}
SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

