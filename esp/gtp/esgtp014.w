&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgmov           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-doc-fiscal NO-UNDO LIKE doc-fiscal
       field nome-emit like emitente.nome-emit.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESGTP014 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESGTP014
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              fi-cod-estabel-ini fi-cod-estabel-fim fi-dt-emissao-ini fi-dt-emissao-fim ~
                              fi-cfop-ini fi-cfop-fim fi-cod-emitente-ini fi-cod-emitente-fim br-notas bt-confirma bt-sair
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-acomp  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-progam AS HANDLE NO-UNDO.

DEFINE VARIABLE v-dat-tmp        AS DATE        NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-notas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-doc-fiscal

/* Definitions for BROWSE br-notas                                      */
&Scoped-define FIELDS-IN-QUERY-br-notas tt-doc-fiscal.cod-estabel ~
tt-doc-fiscal.cod-emitente ~
tt-doc-fiscal.nome-emit @ tt-doc-fiscal.nome-emit tt-doc-fiscal.nr-doc-fis ~
tt-doc-fiscal.serie tt-doc-fiscal.nat-operacao tt-doc-fiscal.dt-docto ~
tt-doc-fiscal.vl-cont-doc 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-notas 
&Scoped-define QUERY-STRING-br-notas FOR EACH tt-doc-fiscal NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-notas OPEN QUERY br-notas FOR EACH tt-doc-fiscal NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-notas tt-doc-fiscal
&Scoped-define FIRST-TABLE-IN-QUERY-br-notas tt-doc-fiscal


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-notas}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-cod-estabel-ini fi-cod-estabel-fim ~
fi-dt-emissao-ini fi-dt-emissao-fim fi-cfop-ini fi-cfop-fim ~
fi-cod-emitente-ini fi-cod-emitente-fim bt-confirma bt-sair br-notas ~
btQueryJoins btReportsJoins btExit btHelp IMAGE-01 IMAGE-02 IMAGE-05 ~
IMAGE-06 IMAGE-7 IMAGE-8 IMAGE-9 IMAGE-10 RECT-1 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-estabel-ini fi-cod-estabel-fim ~
fi-dt-emissao-ini fi-dt-emissao-fim fi-cfop-ini fi-cfop-fim ~
fi-cod-emitente-ini fi-cod-emitente-fim 

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

DEFINE VARIABLE fi-cfop-fim AS CHARACTER FORMAT "x(4)":U INITIAL "ZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cfop-ini AS CHARACTER FORMAT "x(4)":U 
     LABEL "CFOP" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-emitente-fim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 9999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-emitente-ini AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
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

DEFINE IMAGE IMAGE-01
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-02
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
     SIZE 110 BY 2.75.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-notas FOR 
      tt-doc-fiscal SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-notas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-notas wWindow _STRUCTURED
  QUERY br-notas NO-LOCK DISPLAY
      tt-doc-fiscal.cod-estabel FORMAT "X(3)":U
      tt-doc-fiscal.cod-emitente COLUMN-LABEL "Fornec" FORMAT ">>>>>>>>9":U
            WIDTH 9
      tt-doc-fiscal.nome-emit @ tt-doc-fiscal.nome-emit COLUMN-LABEL "Nome" FORMAT "x(40)":U
            WIDTH 40
      tt-doc-fiscal.nr-doc-fis COLUMN-LABEL "Docto" FORMAT "x(16)":U
            WIDTH 11.72
      tt-doc-fiscal.serie FORMAT "x(5)":U
      tt-doc-fiscal.nat-operacao FORMAT "x(06)":U WIDTH 9.57
      tt-doc-fiscal.dt-docto COLUMN-LABEL "Data" FORMAT "99/99/9999":U
            WIDTH 11.43
      tt-doc-fiscal.vl-cont-doc COLUMN-LABEL "Valor" FORMAT ">>,>>>,>>>,>>9.99":U
            WIDTH 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 110 BY 17.25
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-cod-estabel-ini AT ROW 1.5 COL 17 COLON-ALIGNED HELP
          "C¢digo Estabelecimento"
     fi-cod-estabel-fim AT ROW 1.5 COL 38.43 COLON-ALIGNED HELP
          "C¢digo Estabelecimento" NO-LABEL WIDGET-ID 14
     fi-dt-emissao-ini AT ROW 2.5 COL 17 COLON-ALIGNED
     fi-dt-emissao-fim AT ROW 2.5 COL 38.43 COLON-ALIGNED NO-LABEL
     fi-cfop-ini AT ROW 1.5 COL 70 COLON-ALIGNED
     fi-cfop-fim AT ROW 1.5 COL 89.43 COLON-ALIGNED NO-LABEL
     fi-cod-emitente-ini AT ROW 2.5 COL 70 COLON-ALIGNED
     fi-cod-emitente-fim AT ROW 2.5 COL 89.43 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     bt-confirma AT ROW 1.42 COL 107 HELP
          "Filtrar objetos expedidos pelos Correios" WIDGET-ID 20
     bt-sair AT ROW 2.58 COL 107 HELP
          "Sair do programa" WIDGET-ID 18
     br-notas AT ROW 4.25 COL 2 WIDGET-ID 200
     btQueryJoins AT ROW 1 COL 153 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1 COL 157 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1 COL 161 HELP
          "Sair"
     btHelp AT ROW 1 COL 165 HELP
          "Ajuda"
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
   Temp-Tables and Buffers:
      TABLE: tt-doc-fiscal T "?" NO-UNDO mgmov doc-fiscal
      ADDITIONAL-FIELDS:
          field nome-emit like emitente.nome-emit
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 20.71
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
/* BROWSE-TAB br-notas bt-sair fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-notas
/* Query rebuild information for BROWSE br-notas
     _TblList          = "Temp-Tables.tt-doc-fiscal"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.tt-doc-fiscal.cod-estabel
     _FldNameList[2]   > Temp-Tables.tt-doc-fiscal.cod-emitente
"cod-emitente" "Fornec" ? "integer" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"tt-doc-fiscal.nome-emit @ tt-doc-fiscal.nome-emit" "Nome" "x(40)" ? ? ? ? ? ? ? no ? no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-doc-fiscal.nr-doc-fis
"nr-doc-fis" "Docto" ? "character" ? ? ? ? ? ? no ? no no "11.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.tt-doc-fiscal.serie
     _FldNameList[6]   > Temp-Tables.tt-doc-fiscal.nat-operacao
"nat-operacao" ? ? "character" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-doc-fiscal.dt-docto
"dt-docto" "Data" ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-doc-fiscal.vl-cont-doc
"vl-cont-doc" "Valor" ? "decimal" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-notas */
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


&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma wWindow
ON CHOOSE OF bt-confirma IN FRAME fpage0 /* Filtrar */
DO:
    ASSIGN fi-cod-estabel-ini  = INPUT FRAME {&FRAME-NAME} fi-cod-estabel-ini
           fi-cod-estabel-fim  = INPUT FRAME {&FRAME-NAME} fi-cod-estabel-fim
           fi-dt-emissao-ini   = INPUT FRAME {&FRAME-NAME} fi-dt-emissao-ini
           fi-dt-emissao-fim   = INPUT FRAME {&FRAME-NAME} fi-dt-emissao-fim
           fi-cfop-ini         = INPUT FRAME {&FRAME-NAME} fi-cfop-ini
           fi-cfop-fim         = INPUT FRAME {&FRAME-NAME} fi-cfop-fim
           fi-cod-emitente-ini = INPUT FRAME {&FRAME-NAME} fi-cod-emitente-ini.
           fi-cod-emitente-fim = INPUT FRAME {&FRAME-NAME} fi-cod-emitente-fim.

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


&Scoped-define BROWSE-NAME br-notas
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

    EMPTY TEMP-TABLE tt-doc-fiscal.
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

EMPTY TEMP-TABLE tt-doc-fiscal.

ASSIGN fi-cfop-fim = fi-cfop-fim + "ZZ".

DO v-dat-tmp = fi-dt-emissao-ini TO fi-dt-emissao-fim:

    bloco-doc-fiscal:
    FOR EACH  doc-fiscal NO-LOCK
        WHERE doc-fiscal.dt-docto = v-dat-tmp:

        RUN pi-acompanhar IN h-acomp (INPUT STRING(doc-fiscal.dt-docto,"99/99/9999")).

        IF  doc-fiscal.cod-estabel < fi-cod-estabel-ini  OR
            doc-fiscal.cod-estabel > fi-cod-estabel-fim 
        THEN
            NEXT bloco-doc-fiscal.

        IF  doc-fiscal.cod-emitente < fi-cod-emitente-ini OR
            doc-fiscal.cod-emitente > fi-cod-emitente-fim
        THEN
            NEXT bloco-doc-fiscal.

        IF  doc-fiscal.nat-operacao < fi-cfop-ini OR
            doc-fiscal.nat-operacao > fi-cfop-fim
        THEN
            NEXT bloco-doc-fiscal.


        CREATE tt-doc-fiscal.
        BUFFER-COPY doc-fiscal TO tt-doc-fiscal.

        FIND emitente NO-LOCK
            WHERE emitente.cod-emitente = doc-fiscal.cod-emitente NO-ERROR.

        IF  AVAIL emitente
        THEN
            ASSIGN tt-doc-fiscal.nome-emit = emitente.nome-emit.

    END. /* FOR EACH  doc-fiscal NO-LOCK */
END. /* DO v-dat-tmp = fi-dt-emissao-ini TO fi-dt-emissao-fim: */

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

{&OPEN-QUERY-br-notas}
SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

