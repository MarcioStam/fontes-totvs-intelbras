&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{utp/ut-glob.i}     /*   Vari†veis globais, para buscar o usu†rio do sistema */

/* Temp-table Definitions ---                                           */
DEF TEMP-TABLE tt-it-nota 
    FIELD it-codigo LIKE ITEM.it-codigo  COLUMN-LABEL "Item"      FORMAT "X(9)"
    FIELD desc-item LIKE ITEM.desc-item  COLUMN-LABEL "Descricao" FORMAT "X(48)"
    FIELD qtd-item  AS   DEC             COLUMN-LABEL "Qtd Falt"  FORMAT "->>>,>>9"
    FIELD qtd-fatur AS   DEC             COLUMN-LABEL "Qtd Fatur" FORMAT ">>>,>>9"
    FIELD qtd-info  AS   DEC             COLUMN-LABEL "Qtd Infor" FORMAT ">>>,>>9"
    FIELD bloqueia  AS   LOG             INITIAL NO
    FIELD valida    AS   LOG             INITIAL YES
    INDEX pri it-codigo.

DEF TEMP-TABLE tt-it-bak LIKE tt-it-nota.

/* Buffers Definitions ---                                              */
DEFINE BUFFER b-ns-volume         FOR ns-volume.
DEFINE BUFFER b2-ns-volume        FOR ns-volume.
DEFINE BUFFER bcaixa-ns-volume    FOR ns-volume.
DEFINE BUFFER br-num-serie-rast   FOR num-serie-rast.
DEFINE BUFFER br-num-serie        FOR num-serie.
DEFINE BUFFER br-ns-volume-caixa  FOR ns-volume.
DEFINE BUFFER br-ns-volume-pallet FOR ns-volume.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-data         AS   CHARACTER           NO-UNDO.
DEFINE VARIABLE c-celula       AS   CHARACTER           NO-UNDO.
DEFINE VARIABLE c-caixa        AS   CHARACTER           NO-UNDO.
DEFINE VARIABLE i-numero       AS   INTEGER             NO-UNDO.
DEFINE VARIABLE i-totProd      AS   INTEGER             NO-UNDO.
DEFINE VARIABLE c-acao         AS   CHARACTER           NO-UNDO.
DEFINE VARIABLE l-ok           AS   LOGICAL             NO-UNDO.
DEFINE VARIABLE l-ok2          AS   LOGICAL             NO-UNDO.
DEFINE VARIABLE l-retornouOK   AS   LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE c-etiq-elimina AS   CHARACTER           NO-UNDO.
DEFINE VARIABLE c-linha        AS   CHARACTER           NO-UNDO.
DEFINE VARIABLE c-arq-conv     AS   CHARACTER           NO-UNDO.
DEFINE VARIABLE c-poserro      AS   CHARACTER           NO-UNDO.
DEFINE VARIABLE h-acomp        AS   HANDLE              NO-UNDO.
DEFINE VARIABLE vit-codigo     LIKE ITEM.it-codigo      NO-UNDO.
DEFINE VARIABLE c-br-pallet    AS   CHARACTER           NO-UNDO.
DEFINE VARIABLE c-br-caixa     AS   CHARACTER           NO-UNDO.

{upc\btb910za-upc.i} /* v_cod_estab_usuar */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME br-etiqueta

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES br-num-serie-rast br-num-serie tt-it-nota

/* Definitions for BROWSE br-etiqueta                                   */
&Scoped-define FIELDS-IN-QUERY-br-etiqueta /* wf-volume.pallet wf-volume.caixa wf-volume.produto*/ f-pallet(br-num-serie.n-serie) @ c-br-pallet f-caixa(br-num-serie.n-serie) @ c-br-caixa br-num-serie.n-serie   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-etiqueta   
&Scoped-define SELF-NAME br-etiqueta
&Scoped-define QUERY-STRING-br-etiqueta FOR EACH br-num-serie-rast     WHERE br-num-serie-rast.cod-estabel = v_cod_estab_usuar     AND   br-num-serie-rast.serie       = INPUT FRAME {&FRAME-NAME} c-serie     AND   br-num-serie-rast.nr-nota-fis = INPUT FRAME {&FRAME-NAME} c-nr-nota-fis, ~
           FIRST br-num-serie         WHERE br-num-serie.n-serie = br-num-serie-rast.n-serie
&Scoped-define OPEN-QUERY-br-etiqueta OPEN QUERY {&SELF-NAME} FOR EACH br-num-serie-rast     WHERE br-num-serie-rast.cod-estabel = v_cod_estab_usuar     AND   br-num-serie-rast.serie       = INPUT FRAME {&FRAME-NAME} c-serie     AND   br-num-serie-rast.nr-nota-fis = INPUT FRAME {&FRAME-NAME} c-nr-nota-fis, ~
           FIRST br-num-serie         WHERE br-num-serie.n-serie = br-num-serie-rast.n-serie.
&Scoped-define TABLES-IN-QUERY-br-etiqueta br-num-serie-rast br-num-serie
&Scoped-define FIRST-TABLE-IN-QUERY-br-etiqueta br-num-serie-rast
&Scoped-define SECOND-TABLE-IN-QUERY-br-etiqueta br-num-serie


/* Definitions for BROWSE br-itens                                      */
&Scoped-define FIELDS-IN-QUERY-br-itens tt-it-nota.it-codigo tt-it-nota.desc-item tt-it-nota.qtd-fatur tt-it-nota.qtd-info tt-it-nota.qtd-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-itens   
&Scoped-define SELF-NAME br-itens
&Scoped-define QUERY-STRING-br-itens FOR EACH tt-it-nota
&Scoped-define OPEN-QUERY-br-itens OPEN QUERY {&SELF-NAME} FOR EACH tt-it-nota.
&Scoped-define TABLES-IN-QUERY-br-itens tt-it-nota
&Scoped-define FIRST-TABLE-IN-QUERY-br-itens tt-it-nota


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-br-etiqueta}~
    ~{&OPEN-QUERY-br-itens}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-17 rtToolBar btAdd btExit btHelp ~
br-itens br-etiqueta btDelEtiq 
&Scoped-Define DISPLAYED-OBJECTS c-nr-nota-fis c-serie c-etiqueta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-caixa C-Win 
FUNCTION f-caixa RETURNS CHARACTER
  ( INPUT p-num-serie AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-pallet C-Win 
FUNCTION f-pallet RETURNS CHARACTER
  ( INPUT p-num-serie AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Arquivo 
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre"        .

DEFINE MENU MbMain MENUBAR
       SUB-MENU  m_Arquivo      LABEL "&Arquivo"      
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelEtiq 
     LABEL "Elimina Volumes" 
     SIZE 15 BY 1.13.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE c-etiqueta AS CHARACTER FORMAT "X(18)":U 
     LABEL "Etiqueta de Pallet/Caixa/Produto" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-nr-nota-fis AS CHARACTER FORMAT "x(16)" 
     LABEL "Nota Fiscal":R17 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE c-serie AS CHARACTER FORMAT "x(5)" 
     LABEL "SÇrie":R7 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 112 BY 3.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 112 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-etiqueta FOR 
      br-num-serie-rast, 
      br-num-serie SCROLLING.

DEFINE QUERY br-itens FOR 
      tt-it-nota SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-etiqueta C-Win _FREEFORM
  QUERY br-etiqueta DISPLAY
      /*      wf-volume.pallet
    wf-volume.caixa
    wf-volume.produto*/
    


f-pallet(br-num-serie.n-serie) @ c-br-pallet    COLUMN-LABEL "Pallet"   FORMAT "X(14)"  WIDTH 15
f-caixa(br-num-serie.n-serie) @ c-br-caixa      COLUMN-LABEL "Caixa"    FORMAT "X(14)"  WIDTH 15
br-num-serie.n-serie                            COLUMN-LABEL "Produto"  FORMAT "X(13)"  WIDTH 14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 48 BY 13.75
         FONT 1 ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.

DEFINE BROWSE br-itens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-itens C-Win _FREEFORM
  QUERY br-itens DISPLAY
      tt-it-nota.it-codigo
     tt-it-nota.desc-item       WIDTH 32
     tt-it-nota.qtd-fatur
     tt-it-nota.qtd-info
     tt-it-nota.qtd-item
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 62 BY 15.25
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btAdd AT ROW 1.17 COL 2 HELP
          "Inclui nova ocorrància"
     btSave AT ROW 1.17 COL 6.14 HELP
          "Confirma alteraá‰es"
     btExit AT ROW 1.17 COL 104 HELP
          "Sair"
     btHelp AT ROW 1.17 COL 108 HELP
          "Ajuda"
     c-nr-nota-fis AT ROW 3 COL 32 COLON-ALIGNED HELP
          "N£mero da nota fiscal"
     c-serie AT ROW 4 COL 32 COLON-ALIGNED HELP
          "SÇrie da nota fiscal"
     c-etiqueta AT ROW 5 COL 32 COLON-ALIGNED HELP
          "Registre a Etiqueta" AUTO-RETURN 
     br-itens AT ROW 6.5 COL 2
     br-etiqueta AT ROW 6.5 COL 65
     btDelEtiq AT ROW 20.5 COL 65
     RECT-17 AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 112.14 BY 21.08
         FONT 1.


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
         TITLE              = "ESFTP019.W - 2.04.000 - Associa Pallet/Caixa/Produto a Nota Fiscal"
         HEIGHT             = 21.08
         WIDTH              = 112.14
         MAX-HEIGHT         = 320
         MAX-WIDTH          = 320
         VIRTUAL-HEIGHT     = 320
         VIRTUAL-WIDTH      = 320
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* BROWSE-TAB br-itens c-etiqueta DEFAULT-FRAME */
/* BROWSE-TAB br-etiqueta br-itens DEFAULT-FRAME */
/* SETTINGS FOR BUTTON btSave IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-etiqueta IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nr-nota-fis IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-serie IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-etiqueta
/* Query rebuild information for BROWSE br-etiqueta
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH br-num-serie-rast
    WHERE br-num-serie-rast.cod-estabel = v_cod_estab_usuar
    AND   br-num-serie-rast.serie       = INPUT FRAME {&FRAME-NAME} c-serie
    AND   br-num-serie-rast.nr-nota-fis = INPUT FRAME {&FRAME-NAME} c-nr-nota-fis,
    FIRST br-num-serie
        WHERE br-num-serie.n-serie = br-num-serie-rast.n-serie.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-etiqueta */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-itens
/* Query rebuild information for BROWSE br-itens
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-it-nota.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-itens */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* ESFTP019.W - 2.04.000 - Associa Pallet/Caixa/Produto a Nota Fiscal */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* ESFTP019.W - 2.04.000 - Associa Pallet/Caixa/Produto a Nota Fiscal */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-etiqueta
&Scoped-define SELF-NAME br-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-etiqueta C-Win
ON ROW-DISPLAY OF br-etiqueta IN FRAME DEFAULT-FRAME
DO:
  
    /*IF wf-volume.bloqueia = YES THEN
     ASSIGN wf-volume.produto:FGCOLOR IN BROWSE br-etiqueta = 12
            wf-volume.caixa:FGCOLOR IN BROWSE br-etiqueta = 12
            wf-volume.pallet:FGCOLOR IN BROWSE br-etiqueta = 12.
  ELSE
     ASSIGN wf-volume.produto:FGCOLOR IN BROWSE br-etiqueta = 0
            wf-volume.caixa:FGCOLOR IN BROWSE br-etiqueta = 0
            wf-volume.pallet:FGCOLOR IN BROWSE br-etiqueta = 0.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-etiqueta C-Win
ON TAB OF br-etiqueta IN FRAME DEFAULT-FRAME
DO:
    ASSIGN c-etiqueta:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = "".
    APPLY "entry" TO c-etiqueta IN FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-itens
&Scoped-define SELF-NAME br-itens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-itens C-Win
ON ROW-DISPLAY OF br-itens IN FRAME DEFAULT-FRAME
DO:
  IF tt-it-nota.qtd-item < 0 OR tt-it-nota.bloqueia = YES THEN
      ASSIGN tt-it-nota.qtd-item:FGCOLOR IN BROWSE br-itens = 12
             tt-it-nota.it-codigo:FGCOLOR IN BROWSE br-itens = 12
             tt-it-nota.desc-item:FGCOLOR IN BROWSE br-itens = 12
             tt-it-nota.qtd-info:FGCOLOR IN BROWSE br-itens = 12
             tt-it-nota.qtd-fatur:FGCOLOR IN BROWSE br-itens = 12.
  ELSE IF tt-it-nota.it-codigo BEGINS "499" THEN
      ASSIGN tt-it-nota.qtd-item:FGCOLOR IN BROWSE br-itens  = 9
             tt-it-nota.it-codigo:FGCOLOR IN BROWSE br-itens = 9
             tt-it-nota.desc-item:FGCOLOR IN BROWSE br-itens = 9
             tt-it-nota.qtd-info:FGCOLOR IN BROWSE br-itens  = 9
             tt-it-nota.qtd-fatur:FGCOLOR IN BROWSE br-itens = 9.
  ELSE
      ASSIGN tt-it-nota.qtd-item:FGCOLOR IN BROWSE br-itens  = 0
             tt-it-nota.it-codigo:FGCOLOR IN BROWSE br-itens = 0
             tt-it-nota.desc-item:FGCOLOR IN BROWSE br-itens = 0
             tt-it-nota.qtd-info:FGCOLOR IN BROWSE br-itens  = 0
             tt-it-nota.qtd-fatur:FGCOLOR IN BROWSE br-itens = 0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-itens C-Win
ON TAB OF br-itens IN FRAME DEFAULT-FRAME
DO:
    ASSIGN c-etiqueta:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = "".
    APPLY "entry" TO c-etiqueta IN FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-itens C-Win
ON VALUE-CHANGED OF br-itens IN FRAME DEFAULT-FRAME
DO:
  {&OPEN-QUERY-br-etiqueta}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd C-Win
ON CHOOSE OF btAdd IN FRAME DEFAULT-FRAME /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:

    FOR EACH tt-it-nota:
        DELETE tt-it-nota.
    END.

    {&OPEN-QUERY-br-itens}
    {&OPEN-QUERY-br-etiqueta}


    ASSIGN c-acao                                            = "Inclui"
           c-etiqueta:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = ""
           c-etiqueta:SENSITIVE       IN FRAME {&FRAME-NAME} = YES
           c-serie:SCREEN-VALUE       IN FRAME {&FRAME-NAME} = ""
           c-serie:SENSITIVE          IN FRAME {&FRAME-NAME} = YES
           c-nr-nota-fis:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
           c-nr-nota-fis:SENSITIVE    IN FRAME {&FRAME-NAME} = YES
           btAdd:SENSITIVE            IN FRAME {&FRAME-NAME} = NO
           btSave:SENSITIVE           IN FRAME {&FRAME-NAME} = YES.
          

    APPLY "entry" TO c-nr-nota-fis IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelEtiq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelEtiq C-Win
ON CHOOSE OF btDelEtiq IN FRAME DEFAULT-FRAME /* Elimina Volumes */
DO:

    MESSAGE "Deseja realmente eliminar ocorrància(s)?" 
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-ok.

    IF l-ok = NO THEN DO:
        RETURN NO-APPLY.
    END.

    IF AVAIL br-num-serie-rast THEN DO:

        FOR FIRST num-serie NO-LOCK
            WHERE num-serie.n-serie = br-num-serie-rast.n-serie:

            FOR FIRST tt-it-nota 
                WHERE tt-it-nota.it-codigo = num-serie.it-codigo:
                
                ASSIGN tt-it-nota.qtd-info = tt-it-nota.qtd-info - 1
                       tt-it-nota.qtd-item  = tt-it-nota.qtd-item  + 1.

                FIND CURRENT br-num-serie-rast EXCLUSIVE-LOCK.

                DELETE br-num-serie-rast.

            END.

        END.

    END.

    {&open-query-br-itens}
    {&open-query-br-etiqueta}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelEtiq C-Win
ON TAB OF btDelEtiq IN FRAME DEFAULT-FRAME /* Elimina Volumes */
DO:
    ASSIGN c-etiqueta:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = "".
    APPLY "entry" TO c-etiqueta IN FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit C-Win
ON CHOOSE OF btExit IN FRAME DEFAULT-FRAME /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp C-Win
ON CHOOSE OF btHelp IN FRAME DEFAULT-FRAME /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave C-Win
ON CHOOSE OF btSave IN FRAME DEFAULT-FRAME /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:

    /*
    DO TRANSACTION:
   
       FIND FIRST wf-volume NO-LOCK 
           WHERE wf-volume.nr-nota-fis = INPUT FRAME {&FRAME-NAME} c-nr-nota-fis
           AND   wf-volume.serie       = INPUT FRAME {&FRAME-NAME} c-serie
           AND   wf-volume.bloqueia    = YES NO-ERROR.

       IF AVAIL wf-volume THEN DO: 
           MESSAGE "Existe(m) produtos incorretos para Nota Fiscal!!"
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
           ASSIGN c-etiqueta:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = "".
           APPLY "entry" TO c-etiqueta IN FRAME {&FRAME-NAME}.
           RETURN NO-APPLY.
       END.

       FIND FIRST tt-it-nota WHERE tt-it-nota.valida = YES
                               AND tt-it-nota.qtd-item <> 0 
                               AND (tt-it-nota.it-codigo < "499"
                                OR  tt-it-nota.it-codigo > "4999999") 
                             NO-LOCK NO-ERROR.

       IF AVAIL tt-it-nota THEN DO:
           MESSAGE "Produtos relacionados a NF est∆o desbalanceados com a mesma." 
                   VIEW-AS ALERT-BOX INFO BUTTONS OK.
           ASSIGN c-etiqueta:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = "".
           APPLY "entry" TO c-etiqueta IN FRAME {&FRAME-NAME}.
           RETURN NO-APPLY.
       END.
    
       ASSIGN i-totProd = 0.
       FIND FIRST wf-volume NO-LOCK 
            WHERE wf-volume.nr-nota-fis = INPUT FRAME {&FRAME-NAME} c-nr-nota-fis
            AND   wf-volume.serie       = INPUT FRAME {&FRAME-NAME} c-serie NO-ERROR.

       FOR EACH it-nota-fisc WHERE it-nota-fisc.cod-estabel = v_cod_estab_usuar
                               AND it-nota-fisc.nr-nota-fis = wf-volume.nr-nota-fis
                               AND it-nota-fisc.serie       = wf-volume.serie 
                             NO-LOCK:
           ASSIGN i-totProd = i-totProd + it-nota-fisc.qt-faturada[1].
       END.
       
       RUN utp/ut-perc.p PERSISTENT SET h-acomp.
       RUN pi-inicializar IN h-acomp (INPUT "Atualizando volumes...", i-totProd).
       RUN pi-desabilita-cancela IN h-acomp.

       FOR EACH wf-volume NO-LOCK
           WHERE wf-volume.nr-nota-fis = INPUT FRAME {&FRAME-NAME} c-nr-nota-fis
           AND   wf-volume.serie       = INPUT FRAME {&FRAME-NAME} c-serie:
           RUN pi-acompanhar IN h-acomp.
           FIND FIRST ns-volume WHERE  ns-volume.volume-filho = wf-volume.produto
                                  AND ns-volume.nr-nota-fis   = ""
                                  AND ns-volume.serie         = "" NO-ERROR.
           IF AVAIL ns-volume THEN DO:
               ASSIGN ns-volume.cod-estabel = v_cod_estab_usuar
                      ns-volume.nr-nota-fis = wf-volume.nr-nota-fis
                      ns-volume.serie       = wf-volume.serie
                      c-etiq-elimina        = ns-volume.volume-pai.
               FIND FIRST b-ns-volume WHERE b-ns-volume.volume-filho = c-etiq-elimina
                                        AND ns-volume.nr-nota-fis    = ""
                                        AND ns-volume.serie          = "" NO-ERROR.
               IF AVAIL b-ns-volume THEN
                  ASSIGN b-ns-volume.cod-estabel = v_cod_estab_usuar
                         b-ns-volume.nr-nota-fis = wf-volume.nr-nota-fis
                         b-ns-volume.serie       = wf-volume.serie.
           END.
       END.
       RUN pi-finalizar IN h-acomp.
    
       MESSAGE "Atualizaá∆o de dados realizada com sucesso!" VIEW-AS ALERT-BOX.
    
       FOR EACH wf-volume 
          WHERE wf-volume.nr-nota-fis = INPUT FRAME {&FRAME-NAME} c-nr-nota-fis
          AND   wf-volume.serie       = INPUT FRAME {&FRAME-NAME} c-serie:
             DELETE wf-volume.
       END.
       EMPTY TEMP-TABLE tt-it-nota.
       */

       DO WITH FRAME {&FRAME-NAME}:

           ASSIGN c-nr-nota-fis:SCREEN-VALUE = ""
                  c-serie:SCREEN-VALUE = "".

       END.

        FOR EACH tt-it-nota:
           DELETE tt-it-nota.
       END.
    
       {&OPEN-QUERY-br-itens}
       {&OPEN-QUERY-br-etiqueta}
    
       ASSIGN c-etiqueta:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = ""
              c-etiqueta:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
              c-serie:SCREEN-VALUE       IN FRAME {&FRAME-NAME} = ""
              c-serie:SENSITIVE          IN FRAME {&FRAME-NAME} = NO
              c-nr-nota-fis:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
              c-nr-nota-fis:SENSITIVE    IN FRAME {&FRAME-NAME} = NO
              btAdd:SENSITIVE            IN FRAME {&FRAME-NAME} = YES
              btSave:SENSITIVE           IN FRAME {&FRAME-NAME} = NO.

    /*END.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-etiqueta C-Win
ON ENTRY OF c-etiqueta IN FRAME DEFAULT-FRAME /* Etiqueta de Pallet/Caixa/Produto */
DO:
    ASSIGN c-etiqueta:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-etiqueta C-Win
ON RETURN OF c-etiqueta IN FRAME DEFAULT-FRAME /* Etiqueta de Pallet/Caixa/Produto */
DO:

  ASSIGN INPUT FRAME {&FRAME-NAME} c-etiqueta
         INPUT FRAME {&FRAME-NAME} c-nr-nota-fis
         INPUT FRAME {&FRAME-NAME} c-serie.  
 
   IF  c-acao = "Inclui" THEN DO:
       CASE SUBSTRING(c-etiqueta,1,3):
           WHEN "ECO" THEN DO:
               labelECO:
               DO  TRANSACTION:

                   FOR EACH  bcaixa-ns-volume NO-LOCK
                       WHERE bcaixa-ns-volume.volume-pai = c-etiqueta:
                   
                       FOR FIRST num-serie-rast NO-LOCK
                           WHERE num-serie-rast.n-serie  = bcaixa-ns-volume.volume-filho,
                           FIRST nota-fiscal NO-LOCK
                           WHERE nota-fiscal.cod-estabel = num-serie-rast.cod-estabel
                           AND   nota-fiscal.serie       = num-serie-rast.serie      
                           AND   nota-fiscal.nr-nota-fis = num-serie-rast.nr-nota-fis
                           AND   nota-fiscal.dt-saida    = ?:
                           
                           MESSAGE "N£mero de SÇrie j† vinculado a Nota Fiscal: ":U STRING(nota-fiscal.nr-nota-fis) 
                                   " Volume: " string(num-serie-rast.nr-volume) ".":U SKIP "Utilize outro N£mero de SÇrie.":U VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                           APPLY "entry" TO c-etiqueta IN FRAME {&FRAME-NAME}.
                           RETURN "NOK":U.
                   
                       END. /* FOR FIRST num-serie-rast NO-LOCK */
                   END. /* FOR EACH  bcaixa-ns-volume NO-LOCK */

                   FIND FIRST ns-volume WHERE ns-volume.volume-filho = c-etiqueta NO-LOCK NO-ERROR.
                   IF  AVAIL ns-volume THEN DO:
                       MESSAGE "CAIXA n∆o pode ser relacionada a NF: CAIXA relacionada a PALLET." SKIP "Deseja Desvincular?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-ok.
                       IF  NOT l-ok THEN DO:
                           APPLY "entry" TO c-etiqueta IN FRAME {&FRAME-NAME}.
                           RETURN NO-APPLY.
                       END. /* IF  NOT l-ok */
                       
                       FOR EACH ns-volume WHERE ns-volume.volume-filho = c-etiqueta:
                           DELETE ns-volume.
                       END. /* FOR EACH ns-volume */
                   END. /* IF  AVAIL ns-volume THEN */
                   
                   FIND FIRST ns-volume WHERE ns-volume.volume-pai = c-etiqueta NO-LOCK NO-ERROR.
                   IF  NOT AVAIL ns-volume THEN DO:
                       MESSAGE "Etiqueta de CAIXA n∆o relacionada a PRODUTO ou PALLET." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                       APPLY "entry" TO c-etiqueta IN FRAME {&FRAME-NAME}.
                       RETURN NO-APPLY.
                   END. /* IF  NOT AVAIL ns-volume THEN DO: */
                   
                   FOR EACH ns-volume WHERE ns-volume.volume-pai  = c-etiqueta:
       
                       RUN pi-processa-temp-tables (INPUT ns-volume.volume-filho).
       
                       IF  RETURN-VALUE = "NOK" THEN do:
                           ASSIGN l-retornouOK = NO.
                           UNDO labelECO, LEAVE labelECO.
                       END. /* IF  RETURN-VALUE */
                       IF  RETURN-VALUE = "QT-AZ" THEN DO:
                           ASSIGN l-retornouOK = ?.
                           UNDO labelECO, LEAVE LabelECO.
                       END. /* IF  RETURN-VALUE */
                   END. /* FOR EACH ns-volume */
               END. /* DO  TRANSACTION: */
           END. /* WHEN "ECO" THEN DO: */
           WHEN "EPA" THEN DO:         
               labelEPA:
               DO  TRANSACTION:
                   IF  NOT CAN-FIND(FIRST ns-volume WHERE ns-volume.volume-pai = c-etiqueta) THEN DO:
                       MESSAGE "Etiqueta de PALLET n∆o relacionada a CAIXA alguma." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                       APPLY "entry" TO c-etiqueta IN FRAME {&FRAME-NAME}.
                       RETURN NO-APPLY.
                   END. /* IF  NOT CAN-FIND(FIRST ns-volume */
       
                   FOR EACH ns-volume WHERE ns-volume.volume-pai  = c-etiqueta NO-LOCK:
                       FOR EACH b-ns-volume WHERE b-ns-volume.volume-pai   = ns-volume.volume-filho:
       
                           RUN pi-processa-temp-tables (INPUT b-ns-volume.volume-filho).
       
                           IF  RETURN-VALUE = "NOK" THEN do:
                               ASSIGN l-retornouOK = no.
                               UNDO labelEPA, LEAVE labelEPA.
                           END. /* IF  RETURN-VALUE */
                           IF  RETURN-VALUE = "QT-AZ" THEN DO:
                               ASSIGN l-retornouOK = ?.
                               UNDO labelEPA, LEAVE LabelEPA.
                           END. /* IF  RETURN-VALUE */
                       END. /* FOR EACH b-ns-volume */
                   END. /* FOR EACH ns-volume */
               END. /* DO  TRANSACTION: */ 
           END. /* WHEN "EPA" THEN DO: */
           OTHERWISE DO:
               DO TRANSACTION:

                   FOR FIRST num-serie-rast NO-LOCK
                       WHERE num-serie-rast.n-serie  = c-etiqueta,
                       FIRST nota-fiscal NO-LOCK
                       WHERE nota-fiscal.cod-estabel = num-serie-rast.cod-estabel
                       AND   nota-fiscal.serie       = num-serie-rast.serie      
                       AND   nota-fiscal.nr-nota-fis = num-serie-rast.nr-nota-fis
                       AND   nota-fiscal.dt-saida    = ?:
                       
                       MESSAGE "N£mero de SÇrie j† vinculado a Nota Fiscal: ":U STRING(nota-fiscal.nr-nota-fis) 
                               " Volume: " string(num-serie-rast.nr-volume) ".":U SKIP "Utilize outro N£mero de SÇrie.":U VIEW-AS ALERT-BOX ERROR BUTTONS OK.

                       APPLY "entry" TO c-etiqueta IN FRAME {&FRAME-NAME}.

                       RETURN "NOK":U.
                   END. /* FOR FIRST num-serie-rast NO-LOCK */ 

                   FIND FIRST ns-volume WHERE ns-volume.volume-filho = c-etiqueta NO-ERROR.
                   IF  AVAIL ns-volume AND ns-volume.volume-pai <> "ECO-INDEFINIDA" THEN DO:
       
                       MESSAGE "PRODUTO n∆o pode ser relacionado a NF: PRODUTO relacionado a CAIXA." SKIP "Deseja Desvincular?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-ok.
                       IF  NOT l-ok THEN DO:
                           APPLY "entry" TO c-etiqueta IN FRAME {&FRAME-NAME}.
                           RETURN NO-APPLY.
                       END. /* IF  NOT l-ok */
                      
                       ASSIGN c-caixa = ns-volume.volume-pai.
       
                       FOR EACH ns-volume WHERE ns-volume.volume-pai = c-caixa:
                           ASSIGN ns-volume.volume-pai = "ECO-INDEFINIDA".
                       END. /* FOR EACH ns-volume */
       
                       FOR EACH ns-volume WHERE ns-volume.volume-filho = c-caixa:
                           DELETE ns-volume.
                       END. /* FOR EACH ns-volume */
                   END. /* IF  AVAIL ns-volume */
                   
                   RUN pi-processa-temp-tables (INPUT c-etiqueta).
                   IF  RETURN-VALUE = "NOK" THEN DO:
                       ASSIGN l-retornouOK = NO.
                       UNDO, LEAVE.
                   END. /* IF  RETURN-VALUE */
                   IF  RETURN-VALUE = "QT-AZ" THEN DO:
                       ASSIGN l-retornouOK = ?.
                       UNDO, LEAVE.
                   END. /* IF  RETURN-VALUE */
               END.
           END. /* OTHERWISE DO: */
       END CASE.
       
       IF  l-retornouOK = NO THEN DO:
           ASSIGN c-etiqueta:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = ""
                  l-retornouOK = YES.
           RETURN NO-APPLY.
       END. /* IF  l-retornouOK = NO */
       
       {&OPEN-QUERY-br-itens}
       {&OPEN-QUERY-br-etiqueta}
   END. /* IF  c-acao = "Inclui" THEN */

   ASSIGN c-etiqueta:SCREEN-VALUE = "".
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-serie C-Win
ON LEAVE OF c-serie IN FRAME DEFAULT-FRAME /* SÇrie */
DO:
  
  IF  c-acao = "Inclui" THEN DO:
      FIND FIRST nota-fiscal NO-LOCK
           WHERE nota-fiscal.cod-estabel = v_cod_estab_usuar
             AND nota-fiscal.serie       = INPUT FRAME {&FRAME-NAME} c-serie
             AND nota-fiscal.nr-nota-fis = INPUT FRAME {&FRAME-NAME} c-nr-nota-fis NO-ERROR.
      IF  NOT AVAIL nota-fiscal THEN DO:
          MESSAGE "Nota Fiscal n∆o cadastrada" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          ASSIGN c-nr-nota-fis:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                 c-serie:SCREEN-VALUE       IN FRAME {&FRAME-NAME} = ""
                 c-etiqueta:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = "".
          APPLY "entry" TO c-nr-nota-fis IN FRAME {&FRAME-NAME}.
          RETURN NO-APPLY.
      END.

      EMPTY TEMP-TABLE tt-it-nota NO-ERROR.
          
      FOR EACH it-nota-fisc OF nota-fiscal:
          FIND FIRST tt-it-nota WHERE tt-it-nota.it-codigo = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.
          IF NOT AVAIL tt-it-nota THEN DO:

             FIND ITEM WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.

             CREATE tt-it-nota.
             ASSIGN tt-it-nota.it-codigo = ITEM.it-codigo
                    tt-it-nota.desc-item = ITEM.desc-item.

             FOR EACH num-serie-rast NO-LOCK
                WHERE num-serie-rast.cod-estabel = v_cod_estab_usuar
                AND   num-serie-rast.serie       = INPUT FRAME {&FRAME-NAME} c-serie
                AND   num-serie-rast.nr-nota-fis = INPUT FRAME {&FRAME-NAME} c-nr-nota-fis:

                 FOR FIRST num-serie NO-LOCK
                     WHERE num-serie.n-serie = num-serie-rast.n-serie
                     AND   num-serie.it-codigo = tt-it-nota.it-codigo:

                    ASSIGN tt-it-nota.qtd-info = tt-it-nota.qtd-info + 1
                           tt-it-nota.qtd-item = tt-it-nota.qtd-item - 1.
                 END.
             END.
          END.

          ASSIGN tt-it-nota.qtd-item  = tt-it-nota.qtd-item  + it-nota-fisc.qt-faturada[1]
                 tt-it-nota.qtd-fatur = tt-it-nota.qtd-fatur + it-nota-fisc.qt-faturada[1].
      END.
      
      {&open-query-br-itens}
      {&OPEN-QUERY-br-etiqueta}
      ASSIGN c-nr-nota-fis:SENSITIVE IN FRAME {&FRAME-NAME} = NO
             c-serie:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
      APPLY "entry" TO c-etiqueta IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.  
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-etiqueta
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
/*ON 'tab':U ANYWHERE 
DO:
    ASSIGN c-etiqueta:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = "".
    APPLY "entry" TO c-etiqueta IN FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
END. */

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
  DISPLAY c-nr-nota-fis c-serie c-etiqueta 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE RECT-17 rtToolBar btAdd btExit btHelp br-itens br-etiqueta btDelEtiq 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-processa-temp-tables C-Win 
PROCEDURE pi-processa-temp-tables :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-etiqueta   AS CHAR NO-UNDO.
    
    FOR FIRST num-serie NO-LOCK
        WHERE num-serie.n-serie = p-etiqueta:
    END.
    IF NOT AVAILABLE num-serie THEN DO:
        RUN utp/ut-msgs.p (INPUT "show", INPUT 17006, INPUT "N£m. de SÇrie n∆o cadastrado.~~N£m. de SÇrie ":U + p-etiqueta + " n∆o cadastrado.":U).
        RETURN "NOK":U.
    END.

    IF  NOT CAN-FIND(FIRST it-nota-fisc
                     WHERE it-nota-fisc.cod-estabel = v_cod_estab_usuar
                     AND   it-nota-fisc.serie       = INPUT FRAME {&FRAME-NAME} c-serie
                     AND   it-nota-fisc.nr-nota-fis = INPUT FRAME {&FRAME-NAME} c-nr-nota-fis
                     AND   it-nota-fisc.it-codigo   = num-serie.it-codigo) THEN DO:
        RUN utp/ut-msgs.p (INPUT "show", INPUT 17006, INPUT "Item n∆o existe na Nota Fiscal.").
        RETURN "NOK":U.
    END.
      
    FOR FIRST tt-it-nota 
        WHERE tt-it-nota.it-codigo = num-serie.it-codigo:
        IF  tt-it-nota.qtd-item = 0 THEN DO:
            RUN utp/ut-msgs.p (INPUT "show", INPUT 17006, INPUT "Quantidade do item " + num-serie.it-codigo + " j† foi totalmente lida.~~Esta transaáÖo n∆o ser† efetivada.").
            RETURN "NOK":U.
        END.
        
        FOR FIRST num-serie-rast NO-LOCK
            WHERE num-serie-rast.cod-estabel = v_cod_estab_usuar
            AND   num-serie-rast.serie       = INPUT FRAME {&FRAME-NAME} c-serie
            AND   num-serie-rast.nr-nota-fis = INPUT FRAME {&FRAME-NAME} c-nr-nota-fis
            AND   num-serie-rast.n-serie     = p-etiqueta:
        END.
        IF  AVAIL num-serie-rast THEN DO:
            RUN utp/ut-msgs.p (INPUT "show", INPUT 17006, INPUT "N£mero de SÇrie j† vinculado a esta Nota Fiscal.~~Utilize outro N£mero de SÇrie.").
            RETURN "NOK":U.
        END.
        
        ASSIGN tt-it-nota.qtd-item    = tt-it-nota.qtd-item - 1
               tt-it-nota.qtd-info    = tt-it-nota.qtd-info + 1.
    
        FOR FIRST num-serie-rast NO-LOCK
            WHERE num-serie-rast.cod-estabel = v_cod_estab_usuar             
            AND   num-serie-rast.serie       = INPUT FRAME {&FRAME-NAME} c-serie       
            AND   num-serie-rast.nr-nota-fis = INPUT FRAME {&FRAME-NAME} c-nr-nota-fis 
            AND   num-serie-rast.n-serie     = p-etiqueta:                             
        END.
    
        IF  NOT AVAIL num-serie-rast THEN DO:
            CREATE num-serie-rast.
            ASSIGN num-serie-rast.cod-estabel   = v_cod_estab_usuar             
                   num-serie-rast.serie         = INPUT FRAME {&FRAME-NAME} c-serie       
                   num-serie-rast.nr-nota-fis   = INPUT FRAME {&FRAME-NAME} c-nr-nota-fis     
                   num-serie-rast.it-codigo     = tt-it-nota.it-codigo
                   num-serie-rast.nr-volume     = 0
                   num-serie-rast.n-serie       = p-etiqueta
                   num-serie-rast.data          = NOW
                   num-serie-rast.usuario       = c-seg-usuario.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-caixa C-Win 
FUNCTION f-caixa RETURNS CHARACTER
  ( INPUT p-num-serie AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST br-ns-volume-caixa NO-LOCK
        WHERE br-ns-volume-caixa.volume-filho = p-num-serie:

        RETURN br-ns-volume-caixa.volume-pai.

    END.

    RETURN "".   /* Function return value. */
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-pallet C-Win 
FUNCTION f-pallet RETURNS CHARACTER
  ( INPUT p-num-serie AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST br-ns-volume-caixa NO-LOCK
        WHERE br-ns-volume-caixa.volume-filho = p-num-serie:

        FOR FIRST br-ns-volume-pallet NO-LOCK
            WHERE br-ns-volume-pallet.volume-filho = br-ns-volume-caixa.volume-pai:

            RETURN br-ns-volume-pallet.volume-pai.

        END.

    END.

    RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

