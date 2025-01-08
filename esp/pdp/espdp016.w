&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttmeta-rep NO-UNDO LIKE meta-rep
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
{include/i-prgvrs.i XX9999 9.99.99.999}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        espdp016
&GLOBAL-DEFINE Version        2.00.04.000

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            YES
&GLOBAL-DEFINE Copy           YES
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         YES
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        ttmeta-rep
&GLOBAL-DEFINE hDBOTable      hbometa-rep
&GLOBAL-DEFINE DBOTable       meta-rep

&GLOBAL-DEFINE page0KeyFields ttmeta-rep.cod-estabel ttmeta-rep.cod-diretoria ttmeta-rep.cod-gerente ttmeta-rep.cod-rep ttmeta-rep.periodo

&GLOBAL-DEFINE page0Fields    ttmeta-rep.valor
 

/* Global Variable Definitions ---                                     */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEF VAR op AS INTEGER.



/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.



DEF TEMP-TABLE tt-meta-rep
    FIELD cod-estabel   LIKE meta-rep.cod-estabel
    FIELD cod-diretoria LIKE meta-rep.cod-diretoria
    FIELD cod-gerente   LIKE meta-rep.cod-gerente
    FIELD cod-rep       LIKE meta-rep.cod-rep
    FIELD periodo       LIKE meta-rep.periodo
    FIELD valor         LIKE meta-rep.valor
    FIELD no-ab-reppri  LIKE meta-rep.no-ab-reppri.


DEF VAR cEstabel LIKE meta-rep.cod-estabel.
DEF VAR cDiretor LIKE meta-rep.cod-diretor.
DEF VAR cGerente LIKE meta-rep.cod-Gerente.
DEF VAR cRep     LIKE meta-rep.cod-Rep.
DEF VAR cPeriodo LIKE meta-rep.Periodo.
DEF VAR cValor   LIKE meta-rep.valor.
DEF VAR cNo-ab-reppri LIKE meta-rep.no-ab-reppri.
DEF VAR confirma AS LOGICAL INITIAL NO NO-UNDO.

DEF VAR c-arq-imp AS CHAR FORMAT "x(30)".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttmeta-rep.cod-estabel ~
ttmeta-rep.cod-diretoria ttmeta-rep.cod-gerente ttmeta-rep.cod-rep ~
ttmeta-rep.periodo ttmeta-rep.Valor 
&Scoped-define ENABLED-TABLES ttmeta-rep
&Scoped-define FIRST-ENABLED-TABLE ttmeta-rep
&Scoped-Define ENABLED-OBJECTS RECT-4 rtKeys rtToolBar btFirst btPrev ~
btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo ~
btCancel btSave btQueryJoins btReportsJoins btExit btHelp bt-importar ~
c-nome-estabel c-desc-diretoria c-desc-gerente c-desc-representante 
&Scoped-Define DISPLAYED-FIELDS ttmeta-rep.cod-estabel ~
ttmeta-rep.cod-diretoria ttmeta-rep.cod-gerente ttmeta-rep.cod-rep ~
ttmeta-rep.periodo ttmeta-rep.Valor 
&Scoped-define DISPLAYED-TABLES ttmeta-rep
&Scoped-define FIRST-DISPLAYED-TABLE ttmeta-rep
&Scoped-Define DISPLAYED-OBJECTS c-nome-estabel c-desc-diretoria ~
c-desc-gerente c-desc-representante 

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
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
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
DEFINE BUTTON bt-importar 
     LABEL "Importar" 
     SIZE 8 BY 1.13.

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

DEFINE VARIABLE c-desc-diretoria AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-gerente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-representante AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-estabel AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.5.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-arquivo-imp 
     IMAGE-UP FILE "image/im-sea1.bmp":U
     LABEL "" 
     SIZE 3.86 BY 1.08 TOOLTIP "Localiza Arquivo".

DEFINE BUTTON bt-cancelar 
     LABEL "Cancelar" 
     SIZE 12 BY 1.13.

DEFINE BUTTON bt-confirmar 
     LABEL "Confirmar" 
     SIZE 12 BY 1.13.

/** Chamado 10948 - Aumentei o tamanho do campo de arquivo **/
DEFINE VARIABLE fi-c-arquivo AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 67 BY .88 TOOLTIP "Destino"
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.5.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrància"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrància corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrància corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz alteraá‰es"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela alteraá‰es"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma alteraá‰es"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     bt-importar AT ROW 1.25 COL 63
     ttmeta-rep.cod-estabel AT ROW 3 COL 19 COLON-ALIGNED WIDGET-ID 2
          LABEL "Estabelecimento"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-nome-estabel AT ROW 3 COL 25.43 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     ttmeta-rep.cod-diretoria AT ROW 4 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-diretoria AT ROW 4 COL 25.43 COLON-ALIGNED NO-LABEL
     ttmeta-rep.cod-gerente AT ROW 5 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-gerente AT ROW 5 COL 25.43 COLON-ALIGNED NO-LABEL
     ttmeta-rep.cod-rep AT ROW 6 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-representante AT ROW 6 COL 25.43 COLON-ALIGNED NO-LABEL
     ttmeta-rep.periodo AT ROW 7 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     ttmeta-rep.Valor AT ROW 8.75 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.14 BY .88
     RECT-4 AT ROW 8.42 COL 1
     rtKeys AT ROW 2.75 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 11.25
         FONT 1.

DEFINE FRAME fpage1
     bt-arquivo-imp AT ROW 2.25 COL 72 HELP
          "Localiza Arquivo"
     fi-c-arquivo AT ROW 2.5 COL 4 HELP
          "Destino" NO-LABEL
     bt-confirmar AT ROW 5 COL 5
     bt-cancelar AT ROW 5 COL 19
     " Arquivo Importaá∆o" VIEW-AS TEXT
          SIZE 17 BY .54 AT ROW 1.75 COL 4
          FONT 6
     RECT-9 AT ROW 1.25 COL 1
     RECT-13 AT ROW 4.25 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.5
         SIZE 90 BY 7.25 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttmeta-rep T "?" NO-UNDO mgesp meta-rep
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
         HEIGHT             = 9
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
ASSIGN FRAME fpage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN ttmeta-rep.cod-estabel IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fpage1
                                                                        */
/* SETTINGS FOR FILL-IN fi-c-arquivo IN FRAME fpage1
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

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


&Scoped-define FRAME-NAME fpage1
&Scoped-define SELF-NAME bt-arquivo-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo-imp wMaintenance
ON CHOOSE OF bt-arquivo-imp IN FRAME fpage1
DO:
    def var c-arq-imp   as char no-undo.
    def var l-ok-imp    as logical init no.

    assign c-arq-imp = replace(input frame fpage1 fi-c-arquivo, "/", "\").

    SYSTEM-DIALOG GET-FILE c-arq-imp
       FILTERS "*.lst" "*.lst",
               "*.csv" "*.csv",
               "*.txt" "*.txt", 
               "*.*" "*.*"
       DEFAULT-EXTENSION "csv"
       INITIAL-DIR "spool" 
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok-imp.

                                                
   if  l-ok-imp = yes then do:
        /* assign c-arq-imp = replace(c-arq-imp, "\", "/"). */
        display c-arq-imp @ fi-c-arquivo with frame fpage1.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar wMaintenance
ON CHOOSE OF bt-cancelar IN FRAME fpage1 /* Cancelar */
DO:
    HIDE FRAME fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirmar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirmar wMaintenance
ON CHOOSE OF bt-confirmar IN FRAME fpage1 /* Confirmar */
DO:

    INPUT FROM VALUE(fi-c-arquivo:SCREEN-VALUE IN FRAME {&FRAME-NAME}).                

    REPEAT:    
            IMPORT DELIMITER ";" cEstabel cDiretor cGerente cRep cPeriodo cValor.
    
            ASSIGN cperiodo = REPLACE(cPeriodo,"/","").


            /* Verificando estabelecimento */
            IF  NOT CAN-FIND(FIRST estabelec NO-LOCK
                             WHERE estabelec.cod-estabel = cEstabel) THEN DO:
                MESSAGE "Estabelecimento " cEstabel " n∆o cadastrado no sistema. Importaá∆o cancelada."
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                LEAVE.
            END.
            

            /* Verificando diretoria */
            FIND diretoria NO-LOCK WHERE 
                 diretoria.cod-diretoria = cDiretor NO-ERROR.
            IF NOT AVAIL diretoria THEN DO:
               MESSAGE "Diretoria " cDiretor " n∆o cadastrada no sistema. Importaá∆o cancelada."
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
               LEAVE.
            END.
            /***************************/


            /* Verificando gerente */
            FIND gerente NO-LOCK WHERE 
                 gerente.cod-gerente = cGerente NO-ERROR.
            IF NOT AVAIL gerente THEN DO:
               MESSAGE "Gerente " cGerente " n∆o cadastrado no sistema. Importaá∆o cancelada."
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
               LEAVE.
            END.
            /***************************/
    

            /* Verificando representante */
            FIND REPRES NO-LOCK WHERE 
                 REPRES.cod-rep = cRep NO-ERROR.
            IF NOT AVAIL repres THEN DO:
               MESSAGE "Representante " cRep " n∆o cadastrado no sistema. Importaá∆o cancelada."
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
               LEAVE.
            END.
            /*****************************/


            FIND REPRES NO-LOCK WHERE 
                 REPRES.cod-rep = cRep NO-ERROR.
            IF AVAIL REPRES THEN DO:
               ASSIGN cNo-ab-reppri = REPRES.nome-abrev.
            END.
            ELSE
               ASSIGN cNo-ab-reppri = "".


            CREATE tt-meta-rep.
            ASSIGN tt-meta-rep.cod-estabel   = cEstabel
                   tt-meta-rep.cod-diretoria = cDiretor
                   tt-meta-rep.cod-gerente   = cGerente
                   tt-meta-rep.cod-rep       = cRep
                   tt-meta-rep.Periodo       = cPeriodo
                   tt-meta-rep.Valor         = cValor
                   tt-meta-rep.no-ab-reppri  = cNo-ab-reppri.
    END.
    
    FOR EACH tt-meta-rep:
             FIND FIRST meta-rep WHERE
                        meta-rep.cod-estabel   = tt-meta-rep.cod-estabel   AND
                        meta-rep.cod-diretoria = tt-meta-rep.cod-diretoria AND
                        meta-rep.cod-gerente   = tt-meta-rep.cod-gerente   AND
                        meta-rep.cod-rep       = tt-meta-rep.cod-rep       AND
                        meta-rep.periodo       = tt-meta-rep.Periodo       NO-ERROR.
             IF AVAIL meta-rep THEN DO:
                ASSIGN meta-rep.valor         = tt-meta-rep.Valor.
             END.
             ELSE DO:
                CREATE meta-rep.
                ASSIGN meta-rep.cod-estabel   = tt-meta-rep.cod-estabel
                       meta-rep.cod-diretoria = tt-meta-rep.cod-diretoria
                       meta-rep.cod-gerente   = tt-meta-rep.cod-gerente
                       meta-rep.cod-rep       = tt-meta-rep.cod-rep
                       meta-rep.periodo       = tt-meta-rep.Periodo
                       meta-rep.valor         = tt-meta-rep.Valor
                       meta-rep.no-ab-reppri  = tt-meta-rep.no-ab-reppri.
             END.
    END.
    
    INPUT CLOSE.
    
    MESSAGE "Importaá∆o conclu°da com sucesso"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
    RUN setConstraintmain IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "main":U) NO-ERROR.
    
    RUN getFirst IN THIS-PROCEDURE.
        
    ASSIGN btfirst:SENSITIVE IN FRAME fpage0 = YES.
    APPLY "choose" TO btfirst IN FRAME fpage0.


    HIDE FRAME fpage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-importar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importar wMaintenance
ON CHOOSE OF bt-importar IN FRAME fpage0 /* Importar */
DO:

    
    VIEW FRAME fpage1.


/*
    MESSAGE "Informe o diret¢rio e o nome do arquivo para importar:" 
                 UPDATE c-arquivo AS CHAR FORMAT "x(30)".
*/
/*
    ASSIGN c-arquivo = fi-c-arquivo:SCREEN-VALUE IN FRAME fpage1.
*/

/*
    ASSIGN INPUT FRAME fpage0 c-arquivo.
*/

/*
    INPUT FROM VALUE(c-arquivo).                

*/

/*
    MESSAGE "Confirma importaá∆o do arquivo?" UPDATE confirma
             VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO.
*/             

    /*

    IF confirma = YES THEN DO:
        REPEAT:    
            IMPORT DELIMITER ";" cDiretor cGerente cRep cPeriodo cValor.
    
            ASSIGN cperiodo = REPLACE(cPeriodo,"/","").
    
            CREATE tt-meta-rep.
            ASSIGN tt-meta-rep.cod-diretoria = cDiretor
                   tt-meta-rep.cod-gerente   = cGerente
                   tt-meta-rep.cod-rep       = cRep
                   tt-meta-rep.Periodo       = cPeriodo
                   tt-meta-rep.Valor         = cValor.
        END.
    
        FOR EACH tt-meta-rep:
            IF CAN-FIND (meta-rep
               WHERE meta-rep.cod-diretoria = tt-meta-rep.cod-diretoria
               AND   meta-rep.cod-gerente   = tt-meta-rep.cod-gerente
               AND   meta-rep.cod-rep       = tt-meta-rep.cod-rep
               AND   meta-rep.periodo       = tt-meta-rep.Periodo) THEN DO:
               NEXT.
            END.
            ELSE DO:
               CREATE meta-rep.
               ASSIGN meta-rep.cod-diretoria = tt-meta-rep.cod-diretoria
                      meta-rep.cod-gerente   = tt-meta-rep.cod-gerente
                      meta-rep.cod-rep       = tt-meta-rep.cod-rep
                      meta-rep.periodo       = tt-meta-rep.Periodo
                      meta-rep.valor         = tt-meta-rep.Valor.
            END.
        END.
    
        INPUT CLOSE.
    
        MESSAGE "Importaá∆o conclu°da com sucesso"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
        RUN setConstraintmain IN {&hDBOTable} NO-ERROR.
        RUN openQueryStatic IN {&hDBOTable} (INPUT "main":U) NO-ERROR.
    
        RUN getFirst IN THIS-PROCEDURE.
        
        ASSIGN btfirst:SENSITIVE IN FRAME fpage0 = YES.
        APPLY "choose" TO btfirst IN FRAME fpage0.
    END.
    ELSE
        LEAVE.



        HIDE FRAME fpage1.
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
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
    {method/ZoomReposition.i &ProgramZoom="eszoom\z01es345.w"}
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


&Scoped-define SELF-NAME ttmeta-rep.cod-diretoria
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttmeta-rep.cod-diretoria wMaintenance
ON LEAVE OF ttmeta-rep.cod-diretoria IN FRAME fpage0 /* Diretoria */
DO:
  
    FIND diretoria NO-LOCK WHERE 
         diretoria.cod-diretoria = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN c-Desc-diretoria = IF AVAILABLE diretoria THEN diretoria.nome ELSE ''.
    DISPLAY c-Desc-diretoria WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttmeta-rep.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttmeta-rep.cod-estabel wMaintenance
ON LEAVE OF ttmeta-rep.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    ASSIGN INPUT FRAME fPage0 ttmeta-rep.cod-estabel.

    FIND FIRST estabelec NO-LOCK
        WHERE  estabelec.cod-estabel = ttmeta-rep.cod-estabel NO-ERROR.

    ASSIGN c-nome-estabel = IF AVAIL estabelec THEN estabelec.nome ELSE "".

    DISPLAY c-nome-estabel WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttmeta-rep.cod-gerente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttmeta-rep.cod-gerente wMaintenance
ON ENTRY OF ttmeta-rep.cod-gerente IN FRAME fpage0 /* Gerente */
DO:
  
    IF NOT CAN-FIND(diretoria
       WHERE diretoria.cod-diretoria = STRING(ttmeta-rep.cod-diretoria:SCREEN-VALUE)) THEN DO:
       MESSAGE "C¢digo diretoria n∆o cadastrado!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
       ttmeta-rep.cod-diretoria:SCREEN-VALUE = "0". 
       APPLY "entry" TO ttmeta-rep.cod-diretoria IN FRAME fpage0. 
       RETURN NO-APPLY.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttmeta-rep.cod-gerente wMaintenance
ON LEAVE OF ttmeta-rep.cod-gerente IN FRAME fpage0 /* Gerente */
DO:
    FIND gerente NO-LOCK WHERE 
         gerente.cod-gerente = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN c-Desc-gerente = IF AVAILABLE diretoria THEN gerente.nome ELSE ''.
    DISPLAY c-Desc-gerente WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttmeta-rep.cod-rep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttmeta-rep.cod-rep wMaintenance
ON ENTRY OF ttmeta-rep.cod-rep IN FRAME fpage0 /* Representante */
DO:

    IF NOT CAN-FIND(gerente
       WHERE gerente.cod-gerente = INT(ttmeta-rep.cod-gerente:SCREEN-VALUE)) THEN DO:
       MESSAGE "C¢digo gerente n∆o cadastrado!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
       ttmeta-rep.cod-gerente:SCREEN-VALUE = "0". 
       APPLY "entry" TO ttmeta-rep.cod-gerente IN FRAME fpage0. 
       RETURN NO-APPLY.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttmeta-rep.cod-rep wMaintenance
ON LEAVE OF ttmeta-rep.cod-rep IN FRAME fpage0 /* Representante */
DO:
  
    FIND REPRES NO-LOCK WHERE 
         REPRES.cod-rep = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN c-Desc-Representante = IF AVAILABLE REPRES THEN REPRES.nome ELSE ''.
    DISPLAY c-Desc-Representante WITH FRAME {&FRAME-NAME}.


    ASSIGN ttmeta-rep.no-ab-reppri = IF AVAIL repres then REPRES.nome-abrev ELSE ''.
    /* DISPLAY ttmeta-rep.no-ab-reppri WITH FRAME {&FRAME-NAME}. */




END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttmeta-rep.cod-rep wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttmeta-rep.cod-rep IN FRAME fpage0 /* Representante */
OR 'F5' OF {&SELF-NAME} IN FRAME {&FRAME-NAME} DO:
        assign l-implanta = yes.
        {include/zoomvar.i &prog-zoom="adzoom/z01ad229.w"
                         &campo=ttmeta-rep.cod-rep
                         &campozoom=cod-rep
                         &campo2=c-Desc-Representante
                         &campozoom2=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttmeta-rep.periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttmeta-rep.periodo wMaintenance
ON ENTRY OF ttmeta-rep.periodo IN FRAME fpage0 /* Periodo */
DO:
    IF NOT CAN-FIND(repres
       WHERE repres.cod-rep = INT(ttmeta-rep.cod-rep:SCREEN-VALUE)) THEN DO:
       MESSAGE "C¢digo representante n∆o cadastrado!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
       ttmeta-rep.cod-rep:SCREEN-VALUE = "0". 
       APPLY "entry" TO ttmeta-rep.cod-rep IN FRAME fpage0. 
       RETURN NO-APPLY.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDestroyInterface wMaintenance 
PROCEDURE AfterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*--- Destr¢i os Servidores RPC inicializados pelos DBOs ---*/
    
    
    /*
    {btb/btb008za.i3}
        
    /*Alteracao para deletar da mem¢ria o WindowStyles e o btb008za.p*/
    IF VALID-HANDLE(h-servid-rpc) THEN
    DO:
       DELETE PROCEDURE h-servid-rpc.
       ASSIGN h-servid-rpc = ?. /*Garantir que a vari†vel n∆o vai mais apontar para nenhum handle de outro objeto - este problema apareceu na v9.1B com Windows2000*/
    END.

    IF VALID-HANDLE(hWindowStyles) THEN
        DELETE PROCEDURE hWindowStyles.
        
        */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

     APPLY 'leave':U TO {&ttTable}.cod-estabel     IN FRAME fPage0.
     APPLY 'leave':U TO {&ttTable}.cod-diretoria   IN FRAME fPage0.
     APPLY 'leave':U TO {&ttTable}.cod-gerente     IN FRAME fPage0.
     APPLY 'leave':U TO {&ttTable}.cod-rep         IN FRAME fPage0.

     ENABLE bt-importar WITH FRAME fpage0. 

     bt-importar:SENSITIVE IN FRAME fpage0 = TRUE.
     bt-confirmar:SENSITIVE IN FRAME fpage1 = TRUE.
     bt-cancelar:SENSITIVE IN FRAME fpage1 = TRUE.
     bt-arquivo-imp:SENSITIVE IN FRAME fpage1 = TRUE.
     fi-c-arquivo:SENSITIVE IN FRAME fpage1 = TRUE.

     HIDE FRAME fpage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterEnableFields wMaintenance 
PROCEDURE AfterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   
                                        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
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
    
    DEFINE VARIABLE pcod-diretoria LIKE {&ttTable}.cod-diretoria  NO-UNDO.
    DEFINE VARIABLE pcod-gerente   LIKE {&ttTable}.cod-gerente    NO-UNDO.
    DEFINE VARIABLE pcod-rep       LIKE {&ttTable}.cod-rep        NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        pcod-diretoria    AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 5  BY .88
        pcod-gerente      AT ROW 2.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 5 BY .88
        pcod-rep          AT ROW 3.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 7  BY .88
        btGoToOK          AT ROW 4.63 COL 2.14
        btGoToCancel      AT ROW 4.63 COL 13
        rtGoToButton      AT ROW 4.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para cota" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN pcod-diretoria
               pcod-gerente
               pcod-rep.
        
        RUN goToKey IN {&hDBOTable} (INPUT pcod-diretoria, INPUT pcod-gerente, INPUT pcod-rep).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "meta-rep":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE pcod-diretoria 
           pcod-gerente 
           pcod-rep 
           btGoToOK btGoToCancel 
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
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "boes345.p":U THEN DO:
        {btb/btb008za.i1 esbo\boes345.p YES}
        {btb/btb008za.i2 esbo\boes345.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintmain IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

