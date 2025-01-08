&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttlin-prod NO-UNDO LIKE lin-prod
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP008 2.04.00.000}


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP008
&GLOBAL-DEFINE Version        2.04.00.000

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1


&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         NO
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         NO
&GLOBAL-DEFINE Save           NO

&GLOBAL-DEFINE ttTable        ttlin-prod
&GLOBAL-DEFINE hDBOTable      hbolin-prod
&GLOBAL-DEFINE DBOTable       lin-prod

&GLOBAL-DEFINE ttTable1       ttlinha-item
&GLOBAL-DEFINE hDBOTable1     hbolinha-item
&GLOBAL-DEFINE DBOTable1      linha-item


&GLOBAL-DEFINE page0KeyFields ttlin-prod.cod-estabel ttlin-prod.nr-linha ttlin-prod.descricao

&GLOBAL-DEFINE page0Fields    

&GLOBAL-DEFINE page1Fields    fi-item 

&GLOBAL-DEFINE page1Browse    br-linha


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

DEFINE VARIABLE wh-pesquisa                       AS HANDLE       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl  AS HANDLE       NO-UNDO.



DEF TEMP-TABLE tt-Linha-item
    FIELD cod-estabel LIKE linha-item.cod-estabel
    FIELD it-codigo   LIKE Linha-item.it-codigo
    FIELD nr-linha    LIKE Linha-item.nr-linha
    FIELD minimo      LIKE Linha-item.minimo
    FIELD maximo      LIKE Linha-item.maximo.



DEFINE BUTTON    btGoToOK     AUTO-GO LABEL "&OK" SIZE 10 BY 1 BGCOLOR 8.
DEFINE BUTTON    btGoToCancel AUTO-GO LABEL "&Cancela" SIZE 10 BY 1 BGCOLOR 8.

DEFINE RECTANGLE rtGoToFields  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 8.3 BGCOLOR 8.
DEFINE RECTANGLE rtGoToButton  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 72 BY 1.5 BGCOLOR 7.

DEFINE VARIABLE c-item      LIKE linha-item.it-codigo   LABEL "Item"      VIEW-AS FILL-IN  SIZE 10 BY .88 NO-UNDO.
DEFINE VARIABLE c-descricao LIKE lin-prod.descricao     LABEL ""          VIEW-AS FILL-IN  SIZE 50 BY .88 NO-UNDO.
DEFINE VARIABLE i-minimo    LIKE linha-item.minimo      LABEL "M¡nimo"    VIEW-AS FILL-IN  SIZE 10 BY .88 NO-UNDO.
DEFINE VARIABLE i-maximo    LIKE linha-item.maximo      LABEL "M ximo"    VIEW-AS FILL-IN  SIZE 10 BY .88 NO-UNDO.

DEF VAR valida AS INT.
DEF VAR l-resp AS LOGICAL INITIAL NO NO-UNDO.

DEFINE VARIABLE cestrado1     LIKE ae-entrada.estrado[1]  FORMAT "x(3)"   LABEL "Volumes"       VIEW-AS FILL-IN  SIZE 05 BY .88 NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-linha

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-linha-item

/* Definitions for BROWSE br-linha                                      */
&Scoped-define FIELDS-IN-QUERY-br-linha tt-linha-item.cod-estabel tt-linha-item.nr-linha tt-linha-item.it-codigo tt-linha-item.minimo tt-linha-item.maximo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-linha   
&Scoped-define SELF-NAME br-linha
&Scoped-define QUERY-STRING-br-linha FOR EACH tt-linha-item
&Scoped-define OPEN-QUERY-br-linha OPEN QUERY {&SELF-NAME} FOR EACH tt-linha-item.
&Scoped-define TABLES-IN-QUERY-br-linha tt-linha-item
&Scoped-define FIRST-TABLE-IN-QUERY-br-linha tt-linha-item


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-linha}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttlin-prod.cod-estabel ttlin-prod.nr-linha ~
ttlin-prod.descricao 
&Scoped-define ENABLED-TABLES ttlin-prod
&Scoped-define FIRST-ENABLED-TABLE ttlin-prod
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS ttlin-prod.cod-estabel ttlin-prod.nr-linha ~
ttlin-prod.descricao 
&Scoped-define DISPLAYED-TABLES ttlin-prod
&Scoped-define FIRST-DISPLAYED-TABLE ttlin-prod


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miUndo         LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image\im-copy":U
     IMAGE-INSENSITIVE FILE "image\ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image\im-era":U
     IMAGE-INSENSITIVE FILE "image\ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUndo 
     IMAGE-UP FILE "image\im-undo":U
     IMAGE-INSENSITIVE FILE "image\ii-undo":U
     LABEL "Undo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-alterar 
     LABEL "Alterar" 
     SIZE 10 BY 1.25.

DEFINE BUTTON bt-excluir 
     LABEL "Excluir" 
     SIZE 10 BY 1.25.

DEFINE BUTTON bt-incluir 
     LABEL "Incluir" 
     SIZE 10 BY 1.25.

DEFINE BUTTON bt-procura 
     LABEL "Procura..." 
     SIZE 9 BY 1.13.

DEFINE VARIABLE fi-item AS CHARACTER FORMAT "X(7)":U 
     LABEL "C¢digo item" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-linha FOR 
      tt-linha-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-linha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-linha wMaintenance _FREEFORM
  QUERY br-linha DISPLAY
      tt-linha-item.cod-estabel                       COLUMN-LABEL "Estab"
        tt-linha-item.nr-linha                          COLUMN-LABEL "Num. Linha"
        tt-linha-item.it-codigo                         COLUMN-LABEL "C¢digo Item"
        tt-linha-item.minimo      FORMAT ">>>>>>>>>9"   COLUMN-LABEL "M¡nimo"
        tt-linha-item.maximo      FORMAT ">>>>>>>>>9"   COLUMN-LABEL "M ximo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 86 BY 8.25
         FONT 1 ROW-HEIGHT-CHARS .46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrˆncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrˆncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrˆncia"
     btLast AT ROW 1.13 COL 13.57 HELP
          "éltima ocorrˆncia"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V  Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrˆncia"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrˆncia corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrˆncia corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrˆncia corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz altera‡äes"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela altera‡äes"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma altera‡äes"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     ttlin-prod.cod-estabel AT ROW 3 COL 23 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 5 BY .79
     ttlin-prod.nr-linha AT ROW 4 COL 23 COLON-ALIGNED
          LABEL "Linha Produ‡Æo":R17
          VIEW-AS FILL-IN 
          SIZE 5 BY .79
     ttlin-prod.descricao AT ROW 4 COL 29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 48 BY .79
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.71
         FONT 1.

DEFINE FRAME fPage1
     bt-procura AT ROW 2 COL 24
     fi-item AT ROW 2.25 COL 10 COLON-ALIGNED
     br-linha AT ROW 3.5 COL 3
     bt-incluir AT ROW 12 COL 3
     bt-alterar AT ROW 12 COL 13
     bt-excluir AT ROW 12 COL 23
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 5
         SIZE 90 BY 12.5
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttlin-prod T "?" NO-UNDO mgcad lin-prod
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.71
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,                                                          */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN ttlin-prod.descricao IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttlin-prod.nr-linha IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB br-linha fi-item fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-linha
/* Query rebuild information for BROWSE br-linha
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-linha-item.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-linha */
&ANALYZE-RESUME

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

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fpage0
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fpage0 wMaintenance
ON ENTRY OF FRAME fpage0
DO:
    br-linha:SENSITIVE IN FRAME fpage1 = TRUE.  
    bt-procura:SENSITIVE IN FRAME fpage1 = TRUE. 
    bt-incluir:SENSITIVE IN FRAME fpage1 = TRUE. 
    bt-alterar:SENSITIVE IN FRAME fpage1 = TRUE. 
    bt-excluir:SENSITIVE IN FRAME fpage1 = TRUE. 
    fi-item:SENSITIVE IN FRAME fpage1 = TRUE. 

    RUN Monta.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-linha
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-linha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-linha wMaintenance
ON MOUSE-SELECT-DBLCLICK OF br-linha IN FRAME fPage1
DO:
    APPLY 'choose' TO bt-alterar IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-alterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-alterar wMaintenance
ON CHOOSE OF bt-alterar IN FRAME fPage1 /* Alterar */
DO:
    DEFINE FRAME fDadosLinhaItemAltera
           c-item       AT ROW 01.50  COL 10 COLON-ALIGN 
           c-descricao  AT ROW 01.50  COL 21 COLON-ALIGN 
           i-minimo     AT ROW 02.85  COL 10 COLON-ALIGN 
           i-maximo     AT ROW 04.20  COL 10 COLON-ALIGN 
           btGoToOK     AT ROW 06.00  COL 2.14
           btGoToCancel AT ROW 06.00  COL 13.14
           rtGoToButton AT ROW 05.75  COL 1
           SPACE(0.28)
           WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
           THREE-D SCROLLABLE TITLE "Linha item" FONT 1 
           DEFAULT-BUTTON btGoToOK.  
           
    c-item:SCREEN-VALUE   IN FRAME fDadosLinhaItemAltera = tt-linha-item.it-codigo.
    i-minimo:SCREEN-VALUE IN FRAME fDadosLinhaItemAltera = STRING(tt-linha-item.minimo).
    i-maximo:SCREEN-VALUE IN FRAME fDadosLinhaItemAltera = STRING(tt-linha-item.maximo).
    
    FIND FIRST ITEM WHERE
         ITEM.it-codigo = c-item:SCREEN-VALUE IN FRAME fDadosLinhaItemAltera NO-LOCK NO-ERROR.
    IF AVAIL ITEM THEN DO:
       c-descricao:SCREEN-VALUE IN FRAME fDadosLinhaItemAltera = ITEM.descricao-1.
    END.

    
    ON  "CHOOSE":U OF btGoToOK IN FRAME fDadosLinhaItemAltera DO:
        ASSIGN valida = 2.
        IF STRING(i-minimo:SCREEN-VALUE IN FRAME fDadosLinhaItemAltera) = "" OR
           STRING(i-maximo:SCREEN-VALUE IN FRAME fDadosLinhaItemAltera) = "" THEN DO:
           MESSAGE " necess rio preencher todos os campos!"
               VIEW-AS ALERT-BOX INFO BUTTONS OK.    
           ASSIGN valida = 1.
        END.

        IF int(i-minimo:SCREEN-VALUE IN FRAME fDadosLinhaItemAltera) > 
           int(i-maximo:SCREEN-VALUE IN FRAME fDadosLinhaItemAltera) THEN DO:
           MESSAGE "O valor m¡nimo deve ser menor ou igual ao m ximo"
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
           ASSIGN valida = 1.
        END.
        
        IF valida = 2 THEN DO:
           FIND FIRST linha-item WHERE
                linha-item.cod-estabel = tt-linha-item.cod-estabel AND
                linha-item.nr-linha  = int(tt-linha-item.nr-linha) AND
                linha-item.it-codigo = tt-linha-item.it-codigo     NO-ERROR.
           IF AVAIL linha-item THEN DO:
               ASSIGN linha-item.minimo    = int(i-minimo:SCREEN-VALUE IN FRAME fDadosLinhaItemAltera)
                      linha-item.maximo    = int(i-maximo:SCREEN-VALUE IN FRAME fDadosLinhaItemAltera).
               APPLY "GO":U TO FRAME fDadosLinhaItemAltera.
               RUN Monta.  
               ASSIGN valida = 2.
           END.
        END.
        find first tt-linha-item
            where tt-linha-item.it-codigo = c-item:SCREEN-VALUE IN FRAME fDadosLinhaItemAltera no-error.
        reposition br-linha to rowid rowid(tt-linha-item).
        browse br-linha:refresh().
    END.


    ON  "CHOOSE":U OF btGoToCancel IN FRAME fDadosLinhaItemAltera DO:
        APPLY "GO":U TO FRAME fDadosLinhaItemAltera.
    END.


    ENABLE i-minimo 
           i-maximo 
           btGoToOK 
           btGoToCancel
           WITH FRAME fDadosLinhaItemAltera.

    WAIT-FOR "GO":U OF FRAME fDadosLinhaItemAltera. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-excluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excluir wMaintenance
ON CHOOSE OF bt-excluir IN FRAME fPage1 /* Excluir */
DO:

    def var c-it-codigo as char no-undo init ?.
    
    MESSAGE "Deseja excluir o registro selecionado?" 
             UPDATE l-resp
             VIEW-AS ALERT-BOX
             QUESTION BUTTONS YES-NO
             TITLE "ExclusÆo de dados".

    IF l-resp = YES THEN DO:
        FIND FIRST linha-item WHERE
             linha-item.cod-estabel = tt-linha-item.cod-estabel AND
             linha-item.nr-linha    = tt-linha-item.nr-linha  AND
             linha-item.it-codigo   = tt-linha-item.it-codigo NO-ERROR.
        IF AVAIL linha-item THEN DO:
           find last tt-linha-item 
               where tt-linha-item.it-codigo < linha-item.it-codigo no-error.    
           if avail tt-linha-item then c-it-codigo = tt-linha-item.it-codigo.
           DELETE linha-item.
           RUN monta.
           if c-it-codigo ne ? then do:
                find first tt-linha-item
                    where tt-linha-item.it-codigo = c-it-codigo no-error.
                reposition br-linha to rowid rowid(tt-linha-item).
                browse br-linha:refresh().
           end.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir wMaintenance
ON CHOOSE OF bt-incluir IN FRAME fPage1 /* Incluir */
DO:

    DEFINE FRAME fDadosLinhaItem
           c-item       AT ROW 01.50  COL 10 COLON-ALIGN 
           c-descricao  AT ROW 01.50  COL 21 COLON-ALIGN 
           i-minimo     AT ROW 02.85  COL 10 COLON-ALIGN 
           i-maximo     AT ROW 04.20  COL 10 COLON-ALIGN 
           btGoToOK     AT ROW 06.00  COL 2.14
           btGoToCancel AT ROW 06.00  COL 13.14
           rtGoToButton AT ROW 05.75  COL 1
           SPACE(0.28)
           WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
           THREE-D SCROLLABLE TITLE "Linha item" FONT 1 
           DEFAULT-BUTTON btGoToOK.  

 
    ON "LEAVE":U OF c-item IN FRAME fDadosLinhaItem DO:
        IF c-item:SCREEN-VALUE IN FRAME fDadosLinhaItem <> "" THEN DO:
           FIND FIRST ITEM WHERE
                ITEM.it-codigo = c-item:SCREEN-VALUE IN FRAME fDadosLinhaItem NO-LOCK NO-ERROR.
           IF AVAIL ITEM THEN DO:
              c-descricao:SCREEN-VALUE IN FRAME fDadosLinhaItem = ITEM.descricao-1.
           END.
           ELSE DO:
              MESSAGE "Item nÆo cadastrado"
                  VIEW-AS ALERT-BOX INFO BUTTONS OK.
              c-descricao:SCREEN-VALUE IN FRAME fDadosLinhaItem = "".
              c-item:SCREEN-VALUE IN FRAME fDadosLinhaItem = "".
           END.
        END.
    END.



    ON  "CHOOSE":U OF btGoToOK IN FRAME fDadosLinhaItem DO:
        ASSIGN valida = 2.
        IF c-item:SCREEN-VALUE IN FRAME fDadosLinhaItem           = "" OR 
           STRING(i-minimo:SCREEN-VALUE IN FRAME fDadosLinhaItem) = "" OR
           STRING(i-maximo:SCREEN-VALUE IN FRAME fDadosLinhaItem) = "" THEN DO:
           MESSAGE " necess rio preencher todos os campos!"
               VIEW-AS ALERT-BOX INFO BUTTONS OK.    
           ASSIGN valida = 1.
           /* APPLY "CHOOSE":U OF bt-incluir IN FRAME fpage1. */
        END.

        FIND FIRST linha-item WHERE
             linha-item.cod-estabel = ttlin-prod.cod-estabel AND
             linha-item.nr-linha  = ttlin-prod.nr-linha AND
             linha-item.it-codigo = c-item:SCREEN-VALUE IN FRAME fDadosLinhaItem NO-ERROR.

        IF AVAIL linha-item THEN DO:
            MESSAGE "Item j  cadastrado para esta linha, neste estabelecimento."
                VIEW-AS ALERT-BOX INFO BUTTONS OK.    
            ASSIGN valida = 1.
        END.
        
        IF int(i-minimo:SCREEN-VALUE IN FRAME fDadosLinhaItem) > 
           int(i-maximo:SCREEN-VALUE IN FRAME fDadosLinhaItem) THEN DO:
           MESSAGE "O valor m¡nimo deve ser menor ou igual ao m ximo"
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
           ASSIGN valida = 1.
        END.
        
        IF valida = 2 THEN DO:
            CREATE linha-item.
            ASSIGN linha-item.cod-estabel = ttlin-prod.cod-estabel
                   linha-item.nr-linha  = int(ttlin-prod.nr-linha)
                   linha-item.it-codigo = c-item:SCREEN-VALUE IN FRAME fDadosLinhaItem   
                   linha-item.minimo    = int(i-minimo:SCREEN-VALUE IN FRAME fDadosLinhaItem)
                   linha-item.maximo    = int(i-maximo:SCREEN-VALUE IN FRAME fDadosLinhaItem).
            APPLY "GO":U TO FRAME fDadosLinhaItem.
            RUN Monta.  
            ASSIGN valida = 2.
        END.
    END.



    ON  "CHOOSE":U OF btGoToCancel IN FRAME fDadosLinhaItem DO:
        APPLY "GO":U TO FRAME fDadosLinhaItem.
    END.


    ENABLE c-item     
           i-minimo 
           i-maximo 
           btGoToOK 
           btGoToCancel
           WITH FRAME fDadosLinhaItem.

    WAIT-FOR "GO":U OF FRAME fDadosLinhaItem. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-procura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-procura wMaintenance
ON CHOOSE OF bt-procura IN FRAME fPage1 /* Procura... */
DO:
  
    FOR EACH tt-linha-item:
        DELETE tt-linha-item.
    END.
    {&OPEN-QUERY-br-linha}
                             
                           
    FOR EACH linha-item WHERE
        linha-item.cod-estabel = ttlin-prod.cod-estabel AND
        linha-item.nr-linha = ttlin-prod.nr-linha AND
        linha-item.it-codigo BEGINS fi-item:SCREEN-VALUE: 
        CREATE tt-linha-item.
                ASSIGN tt-linha-item.cod-estabel = linha-item.cod-estabel
                       tt-linha-item.nr-linha   = linha-item.nr-linha
                       tt-linha-item.it-codigo  = linha-item.it-codigo
                       tt-linha-item.minimo     = linha-item.minimo
                       tt-linha-item.maximo     = linha-item.maximo. 
    END.

    {&OPEN-QUERY-br-linha}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN cancelRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fpage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fpage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
    RUN Monta.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
    RUN Monta.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fpage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
    RUN Monta.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
    RUN Monta.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
    RUN Monta.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/ZoomReposition.i &ProgramZoom="eszoom/z01esin186.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fpage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    RUN undoRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    APPLY 'entry':U TO {&ttTable}.nr-linha IN FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE c-cod-estabel  LIKE {&ttTable}.cod-estabel  NO-UNDO VIEW-AS FILL-IN SIZE 4  BY 0.88.
    DEFINE VARIABLE i-nr-linha  LIKE {&ttTable}.nr-linha  NO-UNDO VIEW-AS FILL-IN SIZE 4  BY 0.88. 
    /* DEFINE VARIABLE c-it-codigo LIKE {&ttTable}.it-codigo NO-UNDO VIEW-AS FILL-IN SIZE 10 BY 0.88.  */


    DEFINE FRAME fGoToRecord
        c-cod-estabel     AT ROW 1.21 COL 17.72 COLON-ALIGNED
        i-nr-linha        AT ROW 2.21 COL 17.72 COLON-ALIGNED 
        /* c-it-codigo       AT ROW 2.21 COL 17.72 COLON-ALIGNED  */
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Linha de Produ‡Æo" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN  /* c-it-codigo  */
               c-cod-estabel 
               i-nr-linha. 

        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
        RUN goToID IN {&hDBOTable} (/* INPUT c-it-codigo, */ INPUT c-cod-estabel, INPUT i-nr-linha).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Linha de Produ‡Æo":U).            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-cod-estabel
           i-nr-linha 
           /* c-it-codigo  */
           btGoToOK 
           btGoToCancel 
           WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "inbo/boin186.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin186.p YES}
        {btb/btb008za.i2 inbo/boin186.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintmain IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "main":U) NO-ERROR.
    
    RETURN "OK":U.

/*

    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "inbo/boin186.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin186.p YES}
        {btb/btb008za.i2 inbo/boin186.p '' {&hDBOParent}} 
    END.
    
    RUN setConstraintMain IN {&hDBOParent} ("Main") NO-ERROR.
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.

*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Monta wMaintenance 
PROCEDURE Monta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                           
    FOR EACH tt-linha-item:
        DELETE tt-linha-item.
    END.
    {&OPEN-QUERY-br-linha}
                             
                           
    FOR EACH linha-item WHERE
        linha-item.cod-estabel = ttlin-prod.cod-estabel AND
        linha-item.nr-linha = ttlin-prod.nr-linha: 
        CREATE tt-linha-item.
                ASSIGN tt-linha-item.cod-estabel = linha-item.cod-estabel
                       tt-linha-item.nr-linha    = linha-item.nr-linha
                       tt-linha-item.it-codigo   = linha-item.it-codigo
                       tt-linha-item.minimo      = linha-item.minimo
                       tt-linha-item.maximo      = linha-item.maximo.
    END.

    {&OPEN-QUERY-br-linha}
                             

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

