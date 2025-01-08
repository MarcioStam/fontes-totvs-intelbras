&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttcota-rep NO-UNDO LIKE cota-rep
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
&GLOBAL-DEFINE Program        espdp018
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

&GLOBAL-DEFINE ttTable        ttcota-rep
&GLOBAL-DEFINE hDBOTable      hbocota-rep
&GLOBAL-DEFINE DBOTable       cota-rep

&GLOBAL-DEFINE page0KeyFields ttcota-rep.cod-diretoria ttcota-rep.cod-gerente ttcota-rep.cod-rep ttcota-rep.cod-familia ttcota-rep.cod-sub-familia ttcota-rep.periodo

&GLOBAL-DEFINE page0Fields    ttcota-rep.qtde
 

/* Global Variable Definitions ---                                     */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEF VAR op AS INTEGER.



/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.


/*
DEF TEMP-TABLE          ttcota-rep
    FIELD cod-diretoria     LIKE ttcota-rep.cod-diretoria
    FIELD cod-gerente       LIKE ttcota-rep.cod-gerente
    FIELD cod-rep           LIKE ttcota-rep.cod-rep
    FIELD cod-familia       LIKE ttcota-rep.cod-familia
    FIELD cod-sub-familia   LIKE ttcota-rep.cod-sub-familia
    FIELD periodo           LIKE ttcota-rep.periodo
    FIELD qtde              LIKE ttcota-rep.valor
    FIELD no-ab-reppri      LIKE ttcota-rep.no-ab-reppri.
*/


    DEF VAR cDiretor        LIKE ttcota-rep.cod-diretoria.
    DEF VAR cGerente        LIKE ttcota-rep.cod-Gerente.
    DEF VAR cRep            LIKE ttcota-rep.cod-Rep. 
    DEF VAR cFamilia        LIKE ttcota-rep.cod-familia. 
    DEF VAR cSubFamilia     LIKE ttcota-rep.cod-sub-familia.
    DEF VAR cPeriodo        LIKE ttcota-rep.Periodo.
    DEF VAR cQtde           LIKE ttcota-rep.qtde.
    DEF VAR cNo-ab-reppri   LIKE ttcota-rep.no-ab-reppri.
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
&Scoped-Define ENABLED-FIELDS ttcota-rep.cod-diretoria ~
ttcota-rep.cod-gerente ttcota-rep.cod-rep ttcota-rep.cod-familia ~
ttcota-rep.cod-sub-familia ttcota-rep.periodo ttcota-rep.qtde 
&Scoped-define ENABLED-TABLES ttcota-rep
&Scoped-define FIRST-ENABLED-TABLE ttcota-rep
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys RECT-14 btFirst btPrev ~
btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo ~
btCancel btSave btQueryJoins btReportsJoins btExit btHelp bt-importar ~
c-desc-diretoria c-desc-gerente c-desc-representante c-desc-familia ~
c-desc-subfamilia 
&Scoped-Define DISPLAYED-FIELDS ttcota-rep.cod-diretoria ~
ttcota-rep.cod-gerente ttcota-rep.cod-rep ttcota-rep.cod-familia ~
ttcota-rep.cod-sub-familia ttcota-rep.periodo ttcota-rep.qtde 
&Scoped-define DISPLAYED-TABLES ttcota-rep
&Scoped-define FIRST-DISPLAYED-TABLE ttcota-rep
&Scoped-Define DISPLAYED-OBJECTS c-desc-diretoria c-desc-gerente ~
c-desc-representante c-desc-familia c-desc-subfamilia 

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
     SIZE 50 BY .79 NO-UNDO.

DEFINE VARIABLE c-desc-familia AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .79 NO-UNDO.

DEFINE VARIABLE c-desc-gerente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .79 NO-UNDO.

DEFINE VARIABLE c-desc-representante AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .79 NO-UNDO.

DEFINE VARIABLE c-desc-subfamilia AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.75.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 6.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-arquivo-imp 
     IMAGE-UP FILE "adeicon/open.bmp":U
     LABEL "" 
     SIZE 5 BY 1.25.

DEFINE BUTTON bt-cancelar 
     LABEL "Cancelar" 
     SIZE 11 BY 1.13
     FONT 0.

DEFINE BUTTON bt-confirmar 
     LABEL "Confirmar" 
     SIZE 12 BY 1.13
     FONT 0.

DEFINE VARIABLE fi-c-arquivo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 67 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 2.75.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 2.75.


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
     bt-importar AT ROW 1.25 COL 62
     ttcota-rep.cod-diretoria AT ROW 3 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .79
     c-desc-diretoria AT ROW 3 COL 26 COLON-ALIGNED NO-LABEL
     ttcota-rep.cod-gerente AT ROW 4 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .79
     c-desc-gerente AT ROW 4 COL 26 COLON-ALIGNED NO-LABEL
     ttcota-rep.cod-rep AT ROW 5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .79
     c-desc-representante AT ROW 5 COL 26 COLON-ALIGNED NO-LABEL
     ttcota-rep.cod-familia AT ROW 6 COL 20 COLON-ALIGNED
          LABEL "Familia"
          VIEW-AS FILL-IN 
          SIZE 5 BY .79
     c-desc-familia AT ROW 6 COL 26 COLON-ALIGNED NO-LABEL
     ttcota-rep.cod-sub-familia AT ROW 7 COL 20 COLON-ALIGNED
          LABEL "Sub-Familia"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .79
     c-desc-subfamilia AT ROW 7 COL 26 COLON-ALIGNED NO-LABEL
     ttcota-rep.periodo AT ROW 8 COL 20 COLON-ALIGNED
          LABEL "Periodo"
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     ttcota-rep.qtde AT ROW 10 COL 20 COLON-ALIGNED
          LABEL "Quantidade" FORMAT ">>>>>>>9"
          VIEW-AS FILL-IN 
          SIZE 8 BY .79
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
     RECT-14 AT ROW 9.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14.75
         FONT 1.

DEFINE FRAME fPage1
     bt-arquivo-imp AT ROW 2.25 COL 73
     fi-c-arquivo AT ROW 2.5 COL 3 COLON-ALIGNED NO-LABEL
     bt-confirmar AT ROW 5 COL 6
     bt-cancelar AT ROW 5 COL 21
     "Arquivo Importaá∆o" VIEW-AS TEXT
          SIZE 21 BY .54 AT ROW 1.75 COL 5
          FONT 0
     RECT-15 AT ROW 1.25 COL 2
     RECT-16 AT ROW 4.25 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.5
         SIZE 90 BY 9.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttcota-rep T "?" NO-UNDO mgesp cota-rep
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
         HEIGHT             = 10.83
         WIDTH              = 90
         MAX-HEIGHT         = 38.88
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.88
         VIRTUAL-WIDTH      = 182.86
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
/* SETTINGS FOR FILL-IN ttcota-rep.cod-familia IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttcota-rep.cod-sub-familia IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttcota-rep.periodo IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttcota-rep.qtde IN FRAME fpage0
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FRAME fPage1
                                                                        */
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-arquivo-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo-imp wMaintenance
ON CHOOSE OF bt-arquivo-imp IN FRAME fPage1
DO:
  
    DEF VAR c-arq-imp   AS CHAR no-undo.
    DEF VAR l-ok-imp    AS LOGICAL init no.

    ASSIGN c-arq-imp = REPLACE(INPUT FRAME fpage1 fi-c-arquivo, "/", "\").

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

                                                
    IF l-ok-imp = YES THEN DO:
        /* assign c-arq-imp = replace(c-arq-imp, "\", "/"). */
       DISPLAY c-arq-imp @ fi-c-arquivo with frame fpage1.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar wMaintenance
ON CHOOSE OF bt-cancelar IN FRAME fPage1 /* Cancelar */
DO:
    
    HIDE FRAME fpage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirmar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirmar wMaintenance
ON CHOOSE OF bt-confirmar IN FRAME fPage1 /* Confirmar */
DO:

    IF fi-c-arquivo:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Selecione o arquivo para importar"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
       LEAVE.
    END.

    INPUT FROM VALUE(fi-c-arquivo:SCREEN-VALUE IN FRAME {&FRAME-NAME}).                

    REPEAT:    
            IMPORT DELIMITER ";" cDiretor cGerente cRep cFamilia cSubFamilia cPeriodo cQtde.
    
            ASSIGN cperiodo = REPLACE(cPeriodo,"/","").
    

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


            /* Verificando Familia */
            if cfamilia <> 0 then do:
                FIND famc-item NO-LOCK WHERE 
                     famc-item.cod-familia = cFamilia NO-ERROR.
                IF NOT AVAIL famc-item THEN DO:
                   MESSAGE "Familia " cFamilia " n∆o cadastrada no sistema. Importaá∆o cancelada."
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                   LEAVE.
                end.
            END.
            /*****************************/


            /* Verificando Sub Familia */
            if cFamilia <> 0 and cSubFamilia <> 0 then do:
                FIND sub-famc-item NO-LOCK                       WHERE 
                     sub-famc-item.cod-familia     = cFamilia    AND
                     sub-famc-item.cod-sub-familia = cSubFamilia NO-ERROR.
                IF NOT AVAIL sub-famc-item THEN DO:
                   MESSAGE "Sub Familia " cSubFamilia " n∆o cadastrada no sistema. Importaá∆o cancelada."
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                   LEAVE.
                END.
            end.
            /*****************************/



            FIND REPRES NO-LOCK WHERE 
                 REPRES.cod-rep = cRep NO-ERROR.
            IF AVAIL REPRES THEN DO:
               ASSIGN cNo-ab-reppri = REPRES.nome-abrev.
            END.
            ELSE
               ASSIGN cNo-ab-reppri = "".


            CREATE ttcota-rep.
            ASSIGN ttcota-rep.cod-diretoria    = cDiretor
                   ttcota-rep.cod-gerente      = cGerente
                   ttcota-rep.cod-rep          = cRep
                   ttcota-rep.cod-familia      = cFamilia
                   ttcota-rep.cod-sub-familia  = cSubFamilia     
                   ttcota-rep.Periodo          = cPeriodo
                   ttcota-rep.qtde             = cQtde
                   ttcota-rep.no-ab-reppri     = cNo-ab-reppri.
    END.
    

    FOR EACH ttcota-rep:
            IF CAN-FIND (cota-rep WHERE 
                         cota-rep.cod-diretoria     = ttcota-rep.cod-diretoria     AND
                         cota-rep.cod-gerente       = ttcota-rep.cod-gerente       AND
                         cota-rep.cod-rep           = ttcota-rep.cod-rep           AND
                         cota-rep.cod-familia       = ttcota-rep.cod-familia       AND
                         cota-rep.cod-sub-familia   = ttcota-rep.cod-sub-familia   AND
                         cota-rep.periodo           = ttcota-rep.Periodo)          THEN DO:

               FIND FIRST cota-rep
                  WHERE cota-rep.cod-diretoria   = ttcota-rep.cod-diretoria
                    AND cota-rep.cod-gerente     = ttcota-rep.cod-gerente
                    AND cota-rep.cod-rep         = ttcota-rep.cod-rep
                    AND cota-rep.cod-familia     = ttcota-rep.cod-familia
                    AND cota-rep.cod-sub-familia = ttcota-rep.cod-sub-familia
                    AND cota-rep.periodo         = ttcota-rep.Periodo.
               ASSIGN cota-rep.qtde = ttcota-rep.qtde.
               RELEASE cota-rep.
            END.
            ELSE DO:
               CREATE cota-rep.
               ASSIGN cota-rep.cod-diretoria    = ttcota-rep.cod-diretoria
                      cota-rep.cod-gerente      = ttcota-rep.cod-gerente
                      cota-rep.cod-rep          = ttcota-rep.cod-rep
                      cota-rep.cod-familia      = ttcota-rep.cod-familia
                      cota-rep.cod-sub-familia  = ttcota-rep.cod-sub-familia
                      cota-rep.periodo          = ttcota-rep.Periodo
                      cota-rep.qtde             = ttcota-rep.qtde
                      cota-rep.no-ab-reppri     = ttcota-rep.no-ab-reppri.
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
    {method/ZoomReposition.i &ProgramZoom="eszoom\z01es383.w"}
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


&Scoped-define SELF-NAME ttcota-rep.cod-diretoria
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcota-rep.cod-diretoria wMaintenance
ON LEAVE OF ttcota-rep.cod-diretoria IN FRAME fpage0 /* Diretoria */
DO:
    
    FIND diretoria NO-LOCK WHERE 
         diretoria.cod-diretoria = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN c-Desc-diretoria = IF AVAILABLE diretoria THEN diretoria.nome ELSE ''.
    DISPLAY c-Desc-diretoria WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcota-rep.cod-familia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcota-rep.cod-familia wMaintenance
ON LEAVE OF ttcota-rep.cod-familia IN FRAME fpage0 /* Familia */
DO:
    FIND famc-item NO-LOCK WHERE 
         famc-item.cod-familia = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN c-Desc-familia = IF AVAILABLE famc-item THEN famc-item.descricao ELSE ''.
    DISPLAY c-Desc-familia WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcota-rep.cod-gerente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcota-rep.cod-gerente wMaintenance
ON LEAVE OF ttcota-rep.cod-gerente IN FRAME fpage0 /* Gerente */
DO:
  
    FIND gerente NO-LOCK WHERE 
         gerente.cod-gerente = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN c-Desc-gerente = IF AVAILABLE diretoria THEN gerente.nome ELSE ''.
    DISPLAY c-Desc-gerente WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcota-rep.cod-rep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcota-rep.cod-rep wMaintenance
ON LEAVE OF ttcota-rep.cod-rep IN FRAME fpage0 /* Representante */
DO:
  
    FIND REPRES NO-LOCK WHERE 
         REPRES.cod-rep = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN c-Desc-Representante = IF AVAILABLE REPRES THEN REPRES.nome ELSE ''.
    DISPLAY c-Desc-Representante WITH FRAME {&FRAME-NAME}.


    ASSIGN ttcota-rep.no-ab-reppri = IF AVAIL repres then REPRES.nome-abrev ELSE ''.
    /* DISPLAY ttcota-rep.no-ab-reppri WITH FRAME {&FRAME-NAME}. */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcota-rep.cod-sub-familia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcota-rep.cod-sub-familia wMaintenance
ON LEAVE OF ttcota-rep.cod-sub-familia IN FRAME fpage0 /* Sub-Familia */
DO:
    FIND sub-famc-item NO-LOCK                                                  WHERE 
         sub-famc-item.cod-familia = int(ttcota-rep.cod-familia:SCREEN-VALUE)   AND
         sub-famc-item.cod-sub-familia = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN c-Desc-subfamilia = IF AVAILABLE sub-famc-item THEN sub-famc-item.descricao ELSE ''.
    DISPLAY c-Desc-subfamilia WITH FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     APPLY 'leave':U TO {&ttTable}.cod-diretoria   IN FRAME fPage0.
     APPLY 'leave':U TO {&ttTable}.cod-gerente     IN FRAME fPage0.
     APPLY 'leave':U TO {&ttTable}.cod-rep         IN FRAME fPage0.
     APPLY 'leave':U TO {&ttTable}.cod-familia     IN FRAME fpage0.
     APPLY 'leave':U TO {&ttTable}.cod-sub-familia IN FRAME fpage0.
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
    
    DEFINE VARIABLE pcod-diretoria      LIKE {&ttTable}.cod-diretoria   NO-UNDO.
    DEFINE VARIABLE pcod-gerente        LIKE {&ttTable}.cod-gerente     NO-UNDO.
    DEFINE VARIABLE pcod-rep            LIKE {&ttTable}.cod-rep         NO-UNDO.
    DEFINE VARIABLE pcod-familia        LIKE {&ttTable}.cod-familia     NO-UNDO.
    DEFINE VARIABLE pcod-sub-familia    LIKE {&ttTable}.cod-sub-familia NO-UNDO.

    
    DEFINE FRAME fGoToRecord
        pcod-diretoria    AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 5  BY .88
        pcod-gerente      AT ROW 2.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 5  BY .88
        pcod-rep          AT ROW 3.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 7  BY .88
        pcod-familia      AT ROW 4.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 7  BY .88
        pcod-sub-familia  AT ROW 5.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 7  BY .88

        btGoToOK          AT ROW 6.63 COL 2.14
        btGoToCancel      AT ROW 6.63 COL 13
        rtGoToButton      AT ROW 6.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para cota" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN pcod-diretoria
               pcod-gerente
               pcod-rep
               pcod-familia
               pcod-sub-familia.
        
        RUN goToKey IN {&hDBOTable} (INPUT pcod-diretoria, INPUT pcod-gerente, INPUT pcod-rep, INPUT pcod-familia, INPUT pcod-sub-familia).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "cota-rep":U).
            
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
           pcod-familia
           pcod-sub-familia
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
       {&hDBOTable}:FILE-NAME <> "boes383.p":U THEN DO:
        {btb/btb008za.i1 esbo\boes383.p YES}
        {btb/btb008za.i2 esbo\boes383.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintmain IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

