&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
          mgmov            PROGRESS
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
{include/i-prgvrs.i esclt005 2.06.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esclt005
&GLOBAL-DEFINE Version        2.06.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   fi-emb ccod-estabel cCod-Depos cestado icod-transp brNotas bt-sair fi-volumes fi-tot-col tg-fracionado
                              
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE pit-codigo           AS   CHARACTER          NO-UNDO.
DEFINE VARIABLE lcompleto            AS   LOGICAL            NO-UNDO.
DEFINE VARIABLE i-contador           AS   INTEGER            NO-UNDO.
DEFINE VARIABLE c-nr-serie-principal LIKE num-serie.n-serie  NO-UNDO. 
DEFINE VARIABLE i-conta-serie        AS   INTEGER            NO-UNDO.
DEFINE VARIABLE c-tipo-aux           AS   CHARACTER          NO-UNDO.
DEFINE VARIABLE l-volta              AS   LOGICAL            NO-UNDO.
DEFINE VARIABLE l-retorno-astec      AS   LOGICAL            NO-UNDO.
DEFINE VARIABLE vqtd-col             LIKE volume-nf.qtde-col NO-UNDO.
DEFINE VARIABLE h-acomp              AS   HANDLE             NO-UNDO.
DEFINE VARIABLE i-volumes            AS   INTEGER            NO-UNDO.
DEFINE VARIABLE i-tot-col            AS   INTEGER            NO-UNDO.
{esp/es0018.i}
{upc/btb910za-upc.i}

/* Buffers Definitions ---                                              */

/* Temp-tables Definitions ---                                          */
DEF TEMP-TABLE tt-prog-ponto-tmp
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.   
DEF BUFFER b-ponto-programa FOR ponto-programa.
DEF BUFFER bconf-volume-nf  FOR conf-volume-nf.
DEF BUFFER bvolume-nf       FOR volume-nf.

DEF TEMP-TABLE ttvolume-nf
    FIELD cod-estabel LIKE volume-nf.cod-estabel
    FIELD serie       LIKE volume-nf.serie
    FIELD nr-nota-fis LIKE volume-nf.nr-nota-fis
    FIELD tot-vol     LIKE volume-nf.nr-volume
    FIELD qtd-col     LIKE volume-nf.nr-volume
    INDEX ch-pri cod-estabel serie nr-nota-fis.

DEFINE TEMP-TABLE tt-prog-ponto-quarentena NO-UNDO LIKE tt-prog-ponto.
DEFINE TEMP-TABLE ttvolume-nfAux NO-UNDO LIKE ttvolume-nf.

DEFINE VARIABLE v-qtde     LIKE volume-nf.qtde     NO-UNDO.
DEFINE VARIABLE v-qtde-col LIKE volume-nf.qtde-col NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brNotas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttvolume-nf

/* Definitions for BROWSE brNotas                                       */
&Scoped-define FIELDS-IN-QUERY-brNotas ttvolume-nf.cod-estabel ttvolume-nf.serie ttvolume-nf.nr-nota-fis ttvolume-nf.tot-vol ttvolume-nf.qtd-col   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brNotas   
&Scoped-define SELF-NAME brNotas
&Scoped-define QUERY-STRING-brNotas FOR EACH ttvolume-nf
&Scoped-define OPEN-QUERY-brNotas OPEN QUERY {&SELF-NAME} FOR EACH ttvolume-nf.
&Scoped-define TABLES-IN-QUERY-brNotas ttvolume-nf
&Scoped-define FIRST-TABLE-IN-QUERY-brNotas ttvolume-nf


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brNotas}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tg-fracionado ccod-estabel cCod-depos ~
fi-volumes icod-transp cestado fi-etiq-volume bt-sair brNotas fi-tot-col ~
fi-emb RECT-19 
&Scoped-Define DISPLAYED-OBJECTS tg-fracionado ccod-estabel cCod-depos ~
fi-volumes icod-transp cestado fi-etiq-volume cnome-abrev fi-tot-col fi-emb 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-sair 
     LABEL "Sair(esc)" 
     SIZE-PIXELS 63 BY 27
     FONT 4.

DEFINE VARIABLE cCod-depos LIKE fat-ser-lote.cod-depos
     LABEL "Dep" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 50 BY 21 NO-UNDO.

DEFINE VARIABLE ccod-estabel AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 56 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE cestado AS CHARACTER FORMAT "X(04)":U 
     LABEL "UF" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 42 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE cnome-abrev AS CHARACTER FORMAT "x(12)":U 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 147 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-emb LIKE embarque.cdd-embarq
     LABEL "Emb" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 56 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-etiq-volume AS CHARACTER FORMAT "X(21)":U 
     LABEL "Volume" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 154 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-tot-col AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE-PIXELS 35 BY 16
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-volumes AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE-PIXELS 35 BY 16
     FONT 4 NO-UNDO.

DEFINE VARIABLE icod-transp AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Transp" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 56 BY 21
     FONT 4 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE-PIXELS 320 BY 75.

DEFINE VARIABLE tg-fracionado AS LOGICAL INITIAL no 
     LABEL "Frac" 
     VIEW-AS TOGGLE-BOX
     SIZE 5.72 BY .83 TOOLTIP "Fracionado" NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brNotas FOR 
      ttvolume-nf SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brNotas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brNotas wWindow _FREEFORM
  QUERY brNotas DISPLAY
      ttvolume-nf.cod-estabel COLUMN-LABEL "Estab":U
      ttvolume-nf.serie       COLUMN-LABEL "SÇrie":U
      ttvolume-nf.nr-nota-fis COLUMN-LABEL "Nr.Nota Fiscal":U
      ttvolume-nf.tot-vol     COLUMN-LABEL "   Volumes NF":U
      ttvolume-nf.qtd-col     COLUMN-LABEL "Qtde.Coletada":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 46 BY 7
          &ELSE SIZE-PIXELS 320 BY 170 &ENDIF
         FONT 4 ROW-HEIGHT-CHARS .54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tg-fracionado AT ROW 2.25 COL 39 WIDGET-ID 72
     ccod-estabel AT Y 6 X 42 COLON-ALIGNED WIDGET-ID 66
     cCod-depos AT Y 6 X 134 COLON-ALIGNED HELP
          "C¢digo do dep¢sito" WIDGET-ID 68
          LABEL "Dep" FORMAT "x(3)"
     fi-volumes AT Y 252 X 169 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     icod-transp AT Y 30 X 42 COLON-ALIGNED WIDGET-ID 50
     cestado AT Y 54 X 42 COLON-ALIGNED WIDGET-ID 54
     fi-etiq-volume AT Y 54 X 307 RIGHT-ALIGNED WIDGET-ID 4
     bt-sair AT Y 270 X 252 WIDGET-ID 40
     cnome-abrev AT Y 30 X 98 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     brNotas AT Y 78 X 0 WIDGET-ID 200
     fi-tot-col AT Y 252 X 244 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     fi-emb AT Y 6 X 236 COLON-ALIGNED HELP
          "C¢digo - Decimal Embarque" WIDGET-ID 70
          LABEL "Emb"
          FONT 4
     "F5 - Status dos Volumes" VIEW-AS TEXT
          SIZE-PIXELS 151 BY 13 AT Y 258 X 7 WIDGET-ID 8
          FONT 4
     "ENTER - Detalhe Volumes" VIEW-AS TEXT
          SIZE-PIXELS 151 BY 13 AT Y 274 X 7 WIDGET-ID 56
          FONT 4
     RECT-19 AT Y 3 X 0 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


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
         HEIGHT-P           = 299
         WIDTH-P            = 320
         MAX-HEIGHT-P       = 702
         MAX-WIDTH-P        = 1366
         VIRTUAL-HEIGHT-P   = 702
         VIRTUAL-WIDTH-P    = 1366
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 4
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
   FRAME-NAME Size-to-Fit Custom                                        */
/* BROWSE-TAB brNotas cnome-abrev fpage0 */
ASSIGN 
       FRAME fpage0:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN cCod-depos IN FRAME fpage0
   LIKE = mgmov.fat-ser-lote.cod-depos EXP-LABEL EXP-FORMAT EXP-SIZE    */
/* SETTINGS FOR FILL-IN cnome-abrev IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-emb IN FRAME fpage0
   LIKE = mgcad.embarque.cdd-embarq EXP-LABEL EXP-SIZE                  */
/* SETTINGS FOR FILL-IN fi-etiq-volume IN FRAME fpage0
   ALIGN-R                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brNotas
/* Query rebuild information for BROWSE brNotas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttvolume-nf
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brNotas */
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
  /*IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.  
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


&Scoped-define BROWSE-NAME brNotas
&Scoped-define SELF-NAME brNotas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brNotas wWindow
ON F5 OF brNotas IN FRAME fpage0
DO:

    {&WINDOW-NAME}:SENSITIVE = NO.
    {&WINDOW-NAME}:HIDDEN    = YES.
    RUN esp/clt/esclt005b.w (INPUT INPUT FRAME fPage0 fi-volumes,
                             INPUT TABLE ttvolume-nf).
    {&WINDOW-NAME}:HIDDEN    = NO.
    {&WINDOW-NAME}:SENSITIVE = YES.

    ASSIGN fi-etiq-volume:SENSITIVE IN FRAME fPage0 = TRUE.
    APPLY "entry":U TO fi-etiq-volume IN FRAME fPage0.
    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brNotas wWindow
ON MOUSE-SELECT-DBLCLICK OF brNotas IN FRAME fpage0
DO:
    IF  CAN-FIND(FIRST ttvolume-nf) THEN DO:
        EMPTY TEMP-TABLE ttvolume-nfAux NO-ERROR.
    
        FIND CURRENT ttvolume-nf NO-ERROR.
        IF  AVAIL ttvolume-nf THEN DO:
            CREATE ttvolume-nfAux.
            BUFFER-COPY ttvolume-nf TO ttvolume-nfAux NO-ERROR.
        END. /* IF  AVAIL ttvolume-nf */
    
        {&WINDOW-NAME}:SENSITIVE = NO.
        {&WINDOW-NAME}:HIDDEN    = YES.
        RUN esp/clt/esclt005a.w (INPUT TABLE ttvolume-nfAux,
                                 INPUT INPUT FRAME fpage0 tg-fracionado).
        {&WINDOW-NAME}:HIDDEN    = NO.
        {&WINDOW-NAME}:SENSITIVE = YES.

        APPLY "ENTRY":U TO fi-etiq-volume IN FRAME fPage0.
    END. /* IF  CAN-FIND(FIRST ttvolume-nf) */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brNotas wWindow
ON RETURN OF brNotas IN FRAME fpage0
DO:
    APPLY "mouse-select-dblclick":U TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brNotas wWindow
ON ROW-DISPLAY OF brNotas IN FRAME fpage0
DO:
    IF  ttvolume-nf.tot-vol <> ttvolume-nf.qtd-col 
    THEN ASSIGN ttvolume-nf.cod-estabel:FGCOLOR IN BROWSE brNotas = 12 /* vermelho */
                ttvolume-nf.serie:FGCOLOR       IN BROWSE brNotas = 12
                ttvolume-nf.nr-nota-fis:FGCOLOR IN BROWSE brNotas = 12
                ttvolume-nf.tot-vol:FGCOLOR     IN BROWSE brNotas = 12
                ttvolume-nf.qtd-col:FGCOLOR     IN BROWSE brNotas = 12.
    ELSE ASSIGN ttvolume-nf.cod-estabel:FGCOLOR IN BROWSE brNotas = 09 /* azul */
                ttvolume-nf.serie:FGCOLOR       IN BROWSE brNotas = 09
                ttvolume-nf.nr-nota-fis:FGCOLOR IN BROWSE brNotas = 09
                ttvolume-nf.tot-vol:FGCOLOR     IN BROWSE brNotas = 09
                ttvolume-nf.qtd-col:FGCOLOR     IN BROWSE brNotas = 09.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sair wWindow
ON CHOOSE OF bt-sair IN FRAME fpage0 /* Sair(esc) */
DO:
  APPLY 'CLOSE' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cCod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cCod-depos wWindow
ON RETURN OF cCod-depos IN FRAME fpage0 /* Dep */
DO:
    APPLY "LEAVE":U TO SELF.    
    APPLY "ENTRY":U TO fi-emb IN FRAME fPage0.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ccod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel wWindow
ON ENTRY OF ccod-estabel IN FRAME fpage0 /* Estab */
DO:
    ccod-estabel:SET-SELECTION(1,200).   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel wWindow
ON RETURN OF ccod-estabel IN FRAME fpage0 /* Estab */
DO:
    APPLY "ENTRY":U TO cCod-depos IN FRAME fPage0.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cestado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cestado wWindow
ON LEAVE OF cestado IN FRAME fpage0 /* UF */
DO:
    ASSIGN cestado:SCREEN-VALUE IN FRAME {&FRAME-NAME} = CAPS(INPUT FRAME {&FRAME-NAME} cestado).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cestado wWindow
ON RETURN OF cestado IN FRAME fpage0 /* UF */
DO:
    DEF VAR l-existe-depos AS LOG NO-UNDO.

    RUN pi-busca-EmbarqueQuarentena.
    ASSIGN cestado:SCREEN-VALUE IN FRAME {&FRAME-NAME} = CAPS(INPUT FRAME {&FRAME-NAME} cestado).
    
    IF INPUT FRAME fPage0 cestado <> "" AND 
        NOT CAN-FIND(FIRST unid-feder
                     WHERE unid-feder.estado = INPUT FRAME {&FRAME-NAME} cestado) THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "Estado " + INPUT FRAME fPage0 cestado + " n∆o encontrado.",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.
        APPLY "ENTRY":U TO cestado IN FRAME fPage0.
        RETURN NO-APPLY.
    END. /* IF  NOT CAN-FIND(FIRST unid-feder */
    
    EMPTY TEMP-TABLE ttvolume-nf NO-ERROR.
    ASSIGN i-volumes = 0
           i-tot-col = 0.

    RUN esp/clt/clt-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Buscando notas ...":U).

    FIND FIRST transporte NO-LOCK
        WHERE  transporte.cod-transp = INPUT FRAME fPage0 icod-transp NO-ERROR.

    
    FOR EACH  nota-fiscal USE-INDEX ch-distancia NO-LOCK 
        WHERE nota-fiscal.nome-transp = transporte.nome-abrev
          AND nota-fiscal.cod-estabel = INPUT FRAME fpage0 ccod-estabel
          AND nota-fiscal.dt-saida    = ? 
          AND nota-fiscal.dt-cancela  = ? 
          AND nota-fiscal.cdd-embarq <> 0 
          AND (nota-fiscal.dt-emis-nota >= TODAY - 60
          AND  nota-fiscal.dt-emis-nota <= TODAY):

        RUN pi-acompanhar IN h-acomp (INPUT "Nota : " + STRING(nota-fiscal.nr-nota-fis)).

        /* Se encontrar nota-fiscal cujo embarque seja o de quarentena, ignora */
        IF CAN-FIND(FIRST tt-prog-ponto-quarentena
                    WHERE   ENTRY(1, tt-prog-ponto-quarentena.conteudo, ";")  = nota-fiscal.cod-estabel
                    AND int(ENTRY(2, tt-prog-ponto-quarentena.conteudo, ";")) = nota-fiscal.cdd-embarq) THEN NEXT.

        IF nota-fiscal.nome-transp <> transporte.nome-abrev THEN NEXT.
        IF INPUT FRAME fPage0 cestado <> "" AND
           nota-fiscal.estado <> INPUT FRAME fPage0 cestado THEN NEXT.

        IF INPUT FRAME fPage0 fi-emb <> 0 AND
           nota-fiscal.cdd-embarq <> INPUT FRAME fPage0 fi-emb THEN NEXT.
        /* Existe devoluá∆o de nota */
        IF  CAN-FIND(FIRST devol-cli
                     WHERE devol-cli.cod-estabel = nota-fiscal.cod-estabel
                     AND   devol-cli.serie       = nota-fiscal.serie
                     AND   devol-cli.nr-nota-fis = nota-fiscal.nr-nota-fis) THEN NEXT.

        
        /* Verificar se existe fat-ser-lote para a nota com o dep¢sito informado */
        IF  INPUT FRAME fPage0 cCod-depos <> "" THEN DO:
            ASSIGN l-existe-depos = NO.
            FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
                FOR EACH fat-ser-lote
                    WHERE fat-ser-lote.cod-estabel = it-nota-fisc.cod-estabel
                      AND fat-ser-lote.serie       = it-nota-fisc.serie
                      AND fat-ser-lote.nr-nota-fis = it-nota-fisc.nr-nota-fis
                      AND fat-ser-lote.nr-seq-fat  = it-nota-fisc.nr-seq-fat NO-LOCK:
                      IF  fat-ser-lote.cod-depos = INPUT FRAME fPage0 cCod-depos THEN DO:
                          ASSIGN l-existe-depos = YES.
                          LEAVE.
                      END.
                END.
                IF  l-existe-depos THEN
                    LEAVE.
            END.

            IF  NOT l-existe-depos THEN
                NEXT.
        END.

        FOR FIRST natur-oper NO-LOCK WHERE
                  natur-oper.nat-operacao = nota-fiscal.nat-operacao:
        END. /* FOR FIRST natur-oper */
        {esinc/es0004.i} /* ValidaNaturezasImpress∆oNFs */

        RUN defineAstec.
        IF l-retorno-astec THEN NEXT.

        FIND LAST volume-nf 
            WHERE volume-nf.cod-estabel = nota-fiscal.cod-estabel 
              AND volume-nf.serie       = nota-fiscal.serie      
              AND volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
        IF NOT AVAIL volume-nf THEN NEXT.

        IF tg-fracionado:CHECKED IN FRAME fPage0 = YES AND volume-nf.varios-itens = NO THEN NEXT.

        IF  NOT CAN-FIND(FIRST ttvolume-nf
                         WHERE ttvolume-nf.cod-estabel = nota-fiscal.cod-estabel
                         AND   ttvolume-nf.serie       = nota-fiscal.serie      
                         AND   ttvolume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis) THEN DO:
            CREATE ttvolume-nf.
            ASSIGN ttvolume-nf.cod-estabel = nota-fiscal.cod-estabel
                   ttvolume-nf.serie       = nota-fiscal.serie      
                   ttvolume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                   ttvolume-nf.tot-vol     = volume-nf.nr-volume
                   i-volumes               = i-volumes + volume-nf.nr-volume.

            FOR EACH  bconf-volume-nf NO-LOCK
                WHERE bconf-volume-nf.cod-estabel = ttvolume-nf.cod-estabel
                AND   bconf-volume-nf.serie       = ttvolume-nf.serie
                AND   bconf-volume-nf.nr-nota-fis = ttvolume-nf.nr-nota-fis:
                ASSIGN ttvolume-nf.qtd-col = ttvolume-nf.qtd-col + 1
                       i-tot-col           = i-tot-col + 1.
                       
                       
            END. /* FOR EACH  bconf-volume-nf NO-LOCK */

           


        END. /* IF  NOT CAN-FIND(FIRST ttvolume-nf */
        
    END. /* FOR EACH nota-fiscal */
    RUN pi-finalizar IN h-acomp.

    {&OPEN-QUERY-brNotas}

    ASSIGN fi-volumes:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(i-volumes)
           fi-tot-col:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(i-tot-col).
    
    IF  NOT CAN-FIND(FIRST ttvolume-nf) THEN DO:
        ASSIGN icod-transp:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.
        APPLY "ENTRY":U TO icod-transp IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END. /* IF  NOT CAN-FIND(FIRST ttvolume-nf) */
    ELSE DO:
        ASSIGN fi-etiq-volume:SENSITIVE IN FRAME fPage0 = TRUE.
        APPLY "entry":U TO fi-etiq-volume IN FRAME fPage0.
        RETURN NO-APPLY.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cestado wWindow
ON TAB OF cestado IN FRAME fpage0 /* UF */
DO:
    APPLY 'return':U TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-emb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-emb wWindow
ON RETURN OF fi-emb IN FRAME fpage0 /* Emb */
DO:
    APPLY "LEAVE":U TO SELF.    
    APPLY "ENTRY":U TO icod-transp IN FRAME fPage0.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-etiq-volume
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-etiq-volume wWindow
ON F5 OF fi-etiq-volume IN FRAME fpage0 /* Volume */
DO:
    {&WINDOW-NAME}:SENSITIVE = NO.
    {&WINDOW-NAME}:HIDDEN    = YES.
    RUN esp/clt/esclt005b.w (INPUT INPUT FRAME fPage0 fi-volumes,
                             INPUT TABLE ttvolume-nf).
    {&WINDOW-NAME}:HIDDEN    = NO.
    {&WINDOW-NAME}:SENSITIVE = YES.

    ASSIGN fi-etiq-volume:SENSITIVE IN FRAME fPage0 = TRUE.
    APPLY "entry":U TO fi-etiq-volume IN FRAME fPage0.
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-etiq-volume wWindow
ON RETURN OF fi-etiq-volume IN FRAME fpage0 /* Volume */
DO:
    if input fi-etiq-volume = "" then return no-apply.
        
    ASSIGN INPUT FRAME fPage0 fi-etiq-volume.

    IF NOT CAN-FIND(FIRST ttvolume-nf
                    WHERE ttvolume-nf.cod-estabel = SUBSTRING(fi-etiq-volume,1,3)             
                    and   ttvolume-nf.serie       = STRING(INT(SUBSTRING(fi-etiq-volume,4,3)))
                    and   ttvolume-nf.nr-nota-fis = SUBSTRING(fi-etiq-volume,7,7)) THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "Volume inv†lido." + CHR(10) + "Volume n∆o pertence a nenhuma nota listada.",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.
        ASSIGN fi-etiq-volume = "".
        disp fi-etiq-volume with frame fPage0.
        APPLY "entry" TO fi-etiq-volume IN FRAME fPage0.
        RETURN NO-APPLY.
    END. /* IF NOT CAN-FIND(FIRST ttvolume-nf */

    IF  LENGTH(fi-etiq-volume) <> 21 THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "C¢digo de Barras inv†lido." + CHR(10) + "C¢digo de Barras coletado n∆o Ç correspondente ao volume.",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.
        ASSIGN fi-etiq-volume = "".
        disp fi-etiq-volume with frame fPage0.
        APPLY "entry" TO fi-etiq-volume IN FRAME fPage0.
        RETURN NO-APPLY.
    END. /* IF  LENGTH(fi-etiq-volume) */
    
    FIND FIRST volume-nf NO-LOCK
        WHERE  volume-nf.cod-estabel = SUBSTRING(fi-etiq-volume,1,3)             
        AND    volume-nf.serie       = STRING(INT(SUBSTRING(fi-etiq-volume,4,3))) 
        AND    volume-nf.nr-nota-fis = SUBSTRING(fi-etiq-volume,7,7)             
        AND    volume-nf.nr-volume   = INT(SUBSTRING(fi-etiq-volume,14,4)) NO-ERROR.
    IF  NOT AVAIL volume-nf THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "Etiqueta inv†lida." + CHR(10) + "Volume n∆o encontrado no sistema.",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.
        ASSIGN fi-etiq-volume = "".
        disp fi-etiq-volume with frame fPage0.
        APPLY "entry" TO fi-etiq-volume IN FRAME fPage0.
        RETURN NO-APPLY.
    END. /* IF  NOT AVAIL volume-nf */
    
    FOR EACH  bvolume-nf NO-LOCK 
        WHERE bvolume-nf.cod-estabel = volume-nf.cod-estabel 
        AND   bvolume-nf.serie       = volume-nf.serie 
        AND   bvolume-nf.nr-nota-fis = volume-nf.nr-nota-fis 
        AND   bvolume-nf.nr-volume   = volume-nf.nr-volume:

        IF  bvolume-nf.qtde <> bvolume-nf.qtde-col THEN DO:

            {&WINDOW-NAME}:SENSITIVE = FALSE.
            RUN esp/clt/esclt006.w (INPUT "Volume Incompleto." + CHR(10) + "Volume possui itens n∆o coletados. Caixa esta incompleta.",
                                    INPUT NO).
            {&WINDOW-NAME}:SENSITIVE = TRUE.

            ASSIGN fi-etiq-volume = "".
            disp fi-etiq-volume with frame fPage0.
            APPLY "entry" TO fi-etiq-volume IN FRAME fPage0.
            RETURN NO-APPLY.

        END. /* IF  bvolume-nf.qtde <> bvolume-nf.qtde-col */
    END. /* FOR EACH  bvolume-nf NO-LOCK */

    IF  NOT CAN-FIND(FIRST conf-volume-nf
                     WHERE conf-volume-nf.cod-estabel = volume-nf.cod-estabel
                     AND   conf-volume-nf.serie       = volume-nf.serie      
                     AND   conf-volume-nf.nr-nota-fis = volume-nf.nr-nota-fis
                     AND   conf-volume-nf.nr-volume   = volume-nf.nr-volume) THEN DO:
        CREATE conf-volume-nf.
        ASSIGN conf-volume-nf.cod-estabel = volume-nf.cod-estabel 
               conf-volume-nf.serie       = volume-nf.serie       
               conf-volume-nf.nr-nota-fis = volume-nf.nr-nota-fis 
               conf-volume-nf.nr-volume   = volume-nf.nr-volume  
               conf-volume-nf.usuario     = v_cod_usuar_corren
               conf-volume-nf.data-col    = TODAY.
    
        FIND FIRST ttvolume-nf
            WHERE  ttvolume-nf.cod-estabel = volume-nf.cod-estabel 
            AND    ttvolume-nf.serie       = volume-nf.serie       
            AND    ttvolume-nf.nr-nota-fis = volume-nf.nr-nota-fis NO-ERROR.
        IF  AVAIL  ttvolume-nf THEN 
            ASSIGN ttvolume-nf.qtd-col = ttvolume-nf.qtd-col + 1
                   i-tot-col           = i-tot-col + 1.

        {&OPEN-QUERY-brNotas}
        APPLY "entry":U TO SELF.
    END. /* IF  NOT CAN-FIND(FIRST conf-volume-nf */
    ELSE DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "Volume j† coletado." + CHR(10) + "Volume desta Nota Fiscal j† foi coletado.",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.
        APPLY "entry" TO fi-etiq-volume IN FRAME fPage0.
        RETURN NO-APPLY.
    END. /* ELSE DO: */

    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME icod-transp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL icod-transp wWindow
ON ENTRY OF icod-transp IN FRAME fpage0 /* Transp */
DO:
   IF  icod-transp:SET-SELECTION(1,200) THEN. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL icod-transp wWindow
ON LEAVE OF icod-transp IN FRAME fpage0 /* Transp */
DO:

    FIND FIRST transporte NO-LOCK
        WHERE  transporte.cod-transp = INPUT FRAME fPage0 icod-transp NO-ERROR.
    IF  AVAIL  transporte THEN
        ASSIGN cnome-abrev:SCREEN-VALUE IN FRAME fPage0 = transporte.nome-abrev.
    ELSE 
        ASSIGN cnome-abrev:SCREEN-VALUE IN FRAME fPage0 = "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL icod-transp wWindow
ON RETURN OF icod-transp IN FRAME fpage0 /* Transp */
DO:
    IF  NOT CAN-FIND(FIRST transporte
                     WHERE transporte.cod-transp = INPUT FRAME fPage0 icod-transp) THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "Transportador " + INPUT FRAME fPage0 icod-transp + " n∆o encontrado.",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.
        CLEAR FRAME fPage0 ALL.
        APPLY "ENTRY":U TO icod-transp IN FRAME fPage0.
        RETURN NO-APPLY.
    END. /* IF  NOT CAN-FIND(FIRST transporte */
    ELSE DO:
        APPLY "LEAVE":U TO SELF.
        APPLY "ENTRY":U TO cestado IN FRAME fPage0.
        RETURN NO-APPLY.
    END. /* ELSE DO: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

RUN pi-busca-EmbarqueQuarentena.
ASSIGN fi-etiq-volume:SENSITIVE IN FRAME fPage0 = FALSE.

ASSIGN ccod-estabel:SCREEN-VALUE IN FRAME fPage0 = v_cod_estab_usuar.

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

    ASSIGN ccod-estabel:SCREEN-VALUE IN FRAME fPage0 = v_cod_estab_usuar.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE defineAstec wWindow 
PROCEDURE defineAstec :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    ASSIGN l-retorno-astec = NO.
    IF AVAIL ped-venda
    AND  nota-fiscal.nome-transp <> "Sedex"
    AND (ped-venda.tp-pedido = "99"  OR 
         ped-venda.tp-pedido = "9"   OR
         ped-venda.tp-pedido = "94") THEN ASSIGN l-retorno-astec = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-EmbarqueQuarentena wWindow 
PROCEDURE pi-busca-EmbarqueQuarentena :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-prog-ponto NO-ERROR.
    EMPTY TEMP-TABLE tt-prog-ponto-quarentena NO-ERROR.

    RUN esp/es0018p.p (INPUT "esftp093",
                   INPUT 1, 
                   INPUT 0,
                   INPUT "", 
                   OUTPUT TABLE tt-prog-ponto-quarentena).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

