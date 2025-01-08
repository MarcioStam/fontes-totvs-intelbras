&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttitem-tipo-loc NO-UNDO LIKE item-tipo-loc
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
{include/i-prgvrs.i escpe010 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCEP010
&GLOBAL-DEFINE Version        1

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   <Folder1 ,Folder 2 ,... , Folder8>

&GLOBAL-DEFINE First          NO
&GLOBAL-DEFINE Prev           NO
&GLOBAL-DEFINE Next           NO
&GLOBAL-DEFINE Last           NO
&GLOBAL-DEFINE GoTo           NO
&GLOBAL-DEFINE Search         NO

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         NO
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         NO
&GLOBAL-DEFINE Save           NO

&GLOBAL-DEFINE ttTable        ttitem-tipo-loc
&GLOBAL-DEFINE hDBOTable      boitem-tipo-loc
&GLOBAL-DEFINE DBOTable       item-tipo-loc

&GLOBAL-DEFINE page0KeyFields 
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    

&GLOBAL-DEFINE BrowseName brMain
&GLOBAL-DEFINE FRAME-NAME fpage0
&GLOBAL-DEFINE onDblClick onDblClick
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

def var v-cod-tipo-ini     like item-tipo-loc.cod-tipo NO-UNDO VIEW-AS FILL-IN SIZE 4 BY 0.88.
def var v-cod-tipo-fim     like item-tipo-loc.cod-tipo init "999" NO-UNDO  VIEW-AS FILL-IN SIZE 4 BY 0.88.
def var v-it-codigo-ini    like item-tipo-loc.it-codigo NO-UNDO  VIEW-AS FILL-IN SIZE 17 BY 0.88.
def var v-it-codigo-fim    like item-tipo-loc.it-codigo init "ZZZZZZZZZZZZZZZ" NO-UNDO  VIEW-AS FILL-IN SIZE 17 BY 0.88.
def var v-depos-ini        like deposito.cod-depos NO-UNDO  VIEW-AS FILL-IN SIZE 4 BY 0.88.
def var v-depos-fim        like deposito.cod-depos init "ZZZ" NO-UNDO  VIEW-AS FILL-IN SIZE 4 BY 0.88.
def var v-estabel-ini      like estabelec.cod-estabel NO-UNDO  VIEW-AS FILL-IN SIZE 4 BY 0.88.
def var v-estabel-fim      like estabelec.cod-estabel init "ZZZ" NO-UNDO  VIEW-AS FILL-IN SIZE 4 BY 0.88.
def var v-qtde             as log NO-UNDO.
DEF VAR v-qtde-max         AS DECIMAL NO-UNDO INIT 99999999999.
DEF VAR v-sel              AS LOGICAL NO-UNDO.
DEF VAR iqtd               AS INTEGER NO-UNDO.
{upc/btb910za-upc.i} /* Defini‡Æo do estabelecimento do usu rio */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brMain

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttitem-tipo-loc

/* Definitions for BROWSE brMain                                        */
&Scoped-define FIELDS-IN-QUERY-brMain ttitem-tipo-loc.it-codigo ~
fn-desc-item() ttitem-tipo-loc.cod-tipo ttitem-tipo-loc.sequencia ~
ttitem-tipo-loc.mistura ttitem-tipo-loc.quantidade ~
ttitem-tipo-loc.compartilha ttitem-tipo-loc.qtd-comp ~
ttitem-tipo-loc.cod-depos ttitem-tipo-loc.cod-estabel ~
ttitem-tipo-loc.qt-max-entreposto ttitem-tipo-loc.qt-seg-entreposto ~
ttitem-tipo-loc.local-entreposto 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brMain 
&Scoped-define QUERY-STRING-brMain FOR EACH ttitem-tipo-loc ~
      WHERE ttitem-tipo-loc.it-codigo >= v-it-codigo-ini ~
 AND ttitem-tipo-loc.it-codigo <= v-it-codigo-fim ~
 AND ttitem-tipo-loc.cod-estabel >= v-estabel-ini ~
 AND ttitem-tipo-loc.cod-estabel <= v-estabel-fim ~
 AND ttitem-tipo-loc.cod-depos >= v-depos-ini ~
 AND ttitem-tipo-loc.cod-depos <= v-depos-fim ~
 AND ttitem-tipo-loc.cod-tipo >= v-cod-tipo-ini ~
 AND ttitem-tipo-loc.cod-tipo <= v-cod-tipo-fim ~
 AND ttitem-tipo-loc.quantidade <= v-qtde-max NO-LOCK
&Scoped-define OPEN-QUERY-brMain OPEN QUERY brMain FOR EACH ttitem-tipo-loc ~
      WHERE ttitem-tipo-loc.it-codigo >= v-it-codigo-ini ~
 AND ttitem-tipo-loc.it-codigo <= v-it-codigo-fim ~
 AND ttitem-tipo-loc.cod-estabel >= v-estabel-ini ~
 AND ttitem-tipo-loc.cod-estabel <= v-estabel-fim ~
 AND ttitem-tipo-loc.cod-depos >= v-depos-ini ~
 AND ttitem-tipo-loc.cod-depos <= v-depos-fim ~
 AND ttitem-tipo-loc.cod-tipo >= v-cod-tipo-ini ~
 AND ttitem-tipo-loc.cod-tipo <= v-cod-tipo-fim ~
 AND ttitem-tipo-loc.quantidade <= v-qtde-max NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brMain ttitem-tipo-loc
&Scoped-define FIRST-TABLE-IN-QUERY-brMain ttitem-tipo-loc


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brMain}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 rtToolBar btFiltro btQueryJoins ~
btReportsJoins btExit btHelp brMain btIncluir btAlterar btCopiar btEliminar ~
fi-it-codigo rs-zerados 
&Scoped-Define DISPLAYED-OBJECTS fi-it-codigo rs-zerados 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-item wMaintenance 
FUNCTION fn-desc-item RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
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
DEFINE BUTTON btAlterar 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btCopiar 
     LABEL "&Copiar" 
     SIZE 10 BY 1.

DEFINE BUTTON btEliminar 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image/im-fil.bmp":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro"
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btIncluir 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

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

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE rs-zerados AS LOGICAL 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Sim", yes,
"NÆo", no
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brMain FOR 
      ttitem-tipo-loc SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brMain wMaintenance _STRUCTURED
  QUERY brMain NO-LOCK DISPLAY
      ttitem-tipo-loc.it-codigo FORMAT "x(16)":U
      fn-desc-item() COLUMN-LABEL "Descri‡Æo" FORMAT "x(36)":U
            WIDTH 34
      ttitem-tipo-loc.cod-tipo FORMAT ">>>9":U
      ttitem-tipo-loc.sequencia COLUMN-LABEL "Seq" FORMAT ">>9":U
      ttitem-tipo-loc.mistura FORMAT "Sim/Nao":U
      ttitem-tipo-loc.quantidade COLUMN-LABEL "Qtd Total" FORMAT ">>>>,>>9":U
            WIDTH 8.72
      ttitem-tipo-loc.compartilha COLUMN-LABEL "Comp" FORMAT "Sim/Nao":U
            WIDTH 4
      ttitem-tipo-loc.qtd-comp COLUMN-LABEL "Qt Comp" FORMAT ">>>>,>>9":U
            WIDTH 8.72
      ttitem-tipo-loc.cod-depos COLUMN-LABEL "Dep" FORMAT "x(3)":U
            WIDTH 4
      ttitem-tipo-loc.cod-estabel FORMAT "x(3)":U WIDTH 4
      ttitem-tipo-loc.qt-max-entreposto FORMAT ">>>>>,>>>,>>9.99999":U
      ttitem-tipo-loc.qt-seg-entreposto FORMAT ">>>>>,>>>,>>9.99999":U
      ttitem-tipo-loc.local-entreposto FORMAT "x(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 88.57 BY 8.83
         FONT 1 FIT-LAST-COLUMN TOOLTIP "Duplo-clique para alterar linha".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFiltro AT ROW 1.13 COL 2 HELP
          "Consultas relacionadas"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     brMain AT ROW 2.5 COL 1.57
     btIncluir AT ROW 11.75 COL 2
     btAlterar AT ROW 11.75 COL 12
     btCopiar AT ROW 11.75 COL 22
     btEliminar AT ROW 11.75 COL 32
     fi-it-codigo AT ROW 11.75 COL 89 RIGHT-ALIGNED
     rs-zerados AT ROW 12.75 COL 89 RIGHT-ALIGNED NO-LABEL
     "Somente itens com quantidade zero?" VIEW-AS TEXT
          SIZE 25.86 BY .79 AT ROW 12.79 COL 52.14
     RECT-1 AT ROW 11.5 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 13
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttitem-tipo-loc T "?" NO-UNDO mgesp item-tipo-loc
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
         HEIGHT             = 12.88
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
{esp/BrowseMgnt.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brMain btHelp fpage0 */
/* SETTINGS FOR FILL-IN fi-it-codigo IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR RADIO-SET rs-zerados IN FRAME fpage0
   ALIGN-R                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brMain
/* Query rebuild information for BROWSE brMain
     _TblList          = "Temp-Tables.ttitem-tipo-loc"
     _Options          = "NO-LOCK"
     _TblOptList       = ","
     _Where[1]         = "Temp-Tables.ttitem-tipo-loc.it-codigo >= v-it-codigo-ini
 AND Temp-Tables.ttitem-tipo-loc.it-codigo <= v-it-codigo-fim
 AND Temp-Tables.ttitem-tipo-loc.cod-estabel >= v-estabel-ini
 AND Temp-Tables.ttitem-tipo-loc.cod-estabel <= v-estabel-fim
 AND Temp-Tables.ttitem-tipo-loc.cod-depos >= v-depos-ini
 AND Temp-Tables.ttitem-tipo-loc.cod-depos <= v-depos-fim
 AND Temp-Tables.ttitem-tipo-loc.cod-tipo >= v-cod-tipo-ini
 AND Temp-Tables.ttitem-tipo-loc.cod-tipo <= v-cod-tipo-fim
 AND Temp-Tables.ttitem-tipo-loc.quantidade <= v-qtde-max"
     _FldNameList[1]   = Temp-Tables.ttitem-tipo-loc.it-codigo
     _FldNameList[2]   > "_<CALC>"
"fn-desc-item()" "Descri‡Æo" "x(36)" ? ? ? ? ? ? ? no ? no no "34" yes no no "U" "" ""
     _FldNameList[3]   = Temp-Tables.ttitem-tipo-loc.cod-tipo
     _FldNameList[4]   > Temp-Tables.ttitem-tipo-loc.sequencia
"ttitem-tipo-loc.sequencia" "Seq" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[5]   = Temp-Tables.ttitem-tipo-loc.mistura
     _FldNameList[6]   > Temp-Tables.ttitem-tipo-loc.quantidade
"ttitem-tipo-loc.quantidade" "Qtd Total" ">>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" ""
     _FldNameList[7]   > Temp-Tables.ttitem-tipo-loc.compartilha
"ttitem-tipo-loc.compartilha" "Comp" ? "logical" ? ? ? ? ? ? no ? no no "4" yes no no "U" "" ""
     _FldNameList[8]   > Temp-Tables.ttitem-tipo-loc.qtd-comp
"ttitem-tipo-loc.qtd-comp" "Qt Comp" ">>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" ""
     _FldNameList[9]   > Temp-Tables.ttitem-tipo-loc.cod-depos
"ttitem-tipo-loc.cod-depos" "Dep" ? "character" ? ? ? ? ? ? no ? no no "4" yes no no "U" "" ""
     _FldNameList[10]   > Temp-Tables.ttitem-tipo-loc.cod-estabel
"ttitem-tipo-loc.cod-estabel" ? ? "character" ? ? ? ? ? ? no ? no no "4" yes no no "U" "" ""
     _FldNameList[11]   = Temp-Tables.ttitem-tipo-loc.qt-max-entreposto
     _FldNameList[12]   = Temp-Tables.ttitem-tipo-loc.qt-seg-entreposto
     _FldNameList[13]   = Temp-Tables.ttitem-tipo-loc.local-entreposto
     _Query            is OPENED
*/  /* BROWSE brMain */
&ANALYZE-RESUME

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


&Scoped-define SELF-NAME btAlterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAlterar wMaintenance
ON CHOOSE OF btAlterar IN FRAME fpage0 /* Alterar */
DO:
    IF BROWSE brMain:NUM-ITERATIONS > 0 
    AND BROWSE brMain:NUM-SELECTED-ROWS > 0 THEN DO:
        BROWSE brMain:FETCH-SELECTED-ROW(1).
    
        wMaintenance:SENSITIVE = NO.
        RUN esp/cep/escep010a.w (INPUT THIS-PROCEDURE, 
                                 INPUT {&hDBOTable}, 
                                 INPUT "update",
                                 INPUT ttitem-tipo-loc.r-rowid).
        wMaintenance:SENSITIVE = YES.    
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopiar wMaintenance
ON CHOOSE OF btCopiar IN FRAME fpage0 /* Copiar */
DO:
    IF BROWSE brMain:NUM-ITERATIONS > 0 
    AND BROWSE brMain:NUM-SELECTED-ROWS > 0 THEN DO:
        BROWSE brMain:FETCH-SELECTED-ROW(1).
    
        wMaintenance:SENSITIVE = NO.
        RUN esp/cep/escep010a.w (INPUT THIS-PROCEDURE, 
                                 INPUT {&hDBOTable}, 
                                 INPUT "copy",
                                 INPUT ttitem-tipo-loc.r-rowid).
        wMaintenance:SENSITIVE = YES.    
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEliminar wMaintenance
ON CHOOSE OF btEliminar IN FRAME fpage0 /* Eliminar */
DO:
    IF BROWSE brMain:NUM-ITERATIONS > 0 
    AND BROWSE brMain:NUM-SELECTED-ROWS > 0    
        THEN DO:
        BROWSE brMain:FETCH-SELECTED-ROW(1).
        run utp/ut-msgs.p (input "show",
                           input 550,
                           input "").
        IF RETURN-VALUE = "yes" THEN DO:
            RUN repositionRecord IN {&hDBOTable} (INPUT ttitem-tipo-loc.r-rowid).
            RUN emptyRowErrors IN {&hDBOTable}.
            RUN deleteRecord IN {&hDBOTable}.
            RUN getRowErrors IN {&hDBOTable} (OUTPUT TABLE RowErrors).
            IF CAN-FIND(FIRST RowErrors) THEN DO:
                {method/ShowMessage.i1}.
                {method/ShowMessage.i2 &Modal="YES"}.
                {method/ShowMessage.i3}. 
                RETURN NO-APPLY.
            END.
            DELETE ttitem-tipo-loc.
            {&OPEN-QUERY-brMain}  
        END.

    END.
  
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


&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro wMaintenance
ON CHOOSE OF btFiltro IN FRAME fpage0 /* Query Joins */
DO:
  RUN pi-filtro.
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


&Scoped-define SELF-NAME btIncluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIncluir wMaintenance
ON CHOOSE OF btIncluir IN FRAME fpage0 /* Incluir */
DO:
   wMaintenance:SENSITIVE = NO.
   RUN esp/cep/escep010a.w (INPUT THIS-PROCEDURE, 
                            INPUT {&hDBOTable}, 
                            INPUT "add",
                            INPUT ?).
   wMaintenance:SENSITIVE = YES.    
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


&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wMaintenance
ON LEAVE OF fi-it-codigo IN FRAME fpage0 /* Item */
DO:
  IF NOT v-sel THEN DO:
      IF INPUT fi-it-codigo NE "" THEN
          ASSIGN v-it-codigo-ini = INPUT fi-it-codigo
                 v-it-codigo-fim = INPUT fi-it-codigo
                 iqtd = ?.
      ELSE
          ASSIGN v-it-codigo-ini = ""
                 v-it-codigo-fim = "ZZZZZZZZZZZZZZZZ"
                 iqtd = 40.

      RUN setConstraintSequencia IN {&hDBOTable} (INPUT v-it-codigo-ini,
                                                  INPUT v-it-codigo-fim,
                                                  input v_cod_estab_usuar,
                                                  input v_cod_estab_usuar,
                                                  INPUT "",    
                                                  INPUT "ZZZ",
                                                  INPUT 0,
                                                  INPUT 999,
                                                  INPUT 0,  
                                                  INPUT 999).  

      RUN openQueryStatic IN {&hDBOTable} (INPUT "Sequencia":U) NO-ERROR.

      SESSION:SET-WAIT-STATE("GENERAL":U).
      STATUS DEFAULT "Lendo registros, aguarde...".
      RUN getBatchRecords IN {&hDBOTable} (INPUT ?,
                                           INPUT ?,
                                           INPUT iqtd,
                                           OUTPUT iqtd,
                                           OUTPUT TABLE ttitem-tipo-loc).

      SESSION:SET-WAIT-STATE("":U).
      STATUS DEFAULT "".
      {&OPEN-QUERY-brMain}  
  END.
  v-sel = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wMaintenance
ON RETURN OF fi-it-codigo IN FRAME fpage0 /* Item */
DO:
  APPLY "leave" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-zerados
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-zerados wMaintenance
ON ANY-PRINTABLE OF rs-zerados IN FRAME fpage0
DO:
  CASE CAPS(keylabel(LASTKEY)):
      WHEN "S" THEN rs-zerados:SCREEN-VALUE IN FRAME fPage0 = "yes".
      WHEN "N" THEN rs-zerados:SCREEN-VALUE IN FRAME fPage0 = "no".
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-zerados wMaintenance
ON VALUE-CHANGED OF rs-zerados IN FRAME fpage0
DO:
  IF INPUT rs-zerados THEN
      v-qtde-max = 0.
  ELSE v-qtde-max = 99999999999.
  {&OPEN-QUERY-brMain}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brMain
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDisplayFields wMaintenance 
PROCEDURE AfterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR iqtd AS INTEGER NO-UNDO.

    RUN initializeDBOs IN THIS-PROCEDURE.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    RUN getBatchRecords IN {&hDBOTable} (INPUT ?,
                                         INPUT ?,
                                         INPUT 40,
                                         OUTPUT iqtd,
                                         OUTPUT TABLE ttitem-tipo-loc).
    {&OPEN-QUERY-brMain}
    rs-zerados:SCREEN-VALUE IN FRAME fPage0 = "no".    
    ENABLE ALL WITH FRAME fPage0.
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

    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "esbo/boes115.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes115.p YES}
        {btb/btb008za.i2 esbo/boes115.p '' {&hDBOTable}}
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE onDblClick wMaintenance 
PROCEDURE onDblClick :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    APPLY "choose" TO btAlterar IN FRAME fPage0.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-filtro wMaintenance 
PROCEDURE pi-filtro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR iqtd AS INT NO-UNDO.

    DEFINE BUTTON btBuscaCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btBuscaOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtBuscaButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.

    
    DEFINE FRAME fBusca
        v-cod-tipo-ini            AT ROW 1.21 COL 15.0 COLON-ALIGNED LABEL "Tipo Inicial" 
        v-cod-tipo-fim            AT ROW 2.21 COL 15.0 COLON-ALIGNED LABEL "Tipo Final"
        v-it-codigo-ini           AT ROW 3.21 COL 15.0 COLON-ALIGNED LABEL "Item Inicial"
        v-it-codigo-fim           AT ROW 4.21 COL 15.0 COLON-ALIGNED LABEL "Item Final"  
        v-depos-ini               AT ROW 5.21 COL 15.0 COLON-ALIGNED LABEL "Dep¢sito Inicial"
        v-depos-fim               AT ROW 6.21 COL 15.0 COLON-ALIGNED LABEL "Dep¢sito Final"  
        btBuscaOK     AT ROW 7.63 COL 2.14
        btBuscaCancel AT ROW 7.63 COL 13
        rtBuscaButton      AT ROW 7.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Faixa" FONT 1
             DEFAULT-BUTTON btBuscaOK CANCEL-BUTTON btBuscaCancel.
    
    ON "CHOOSE":U OF btBuscaOK IN FRAME fBusca DO:
        ASSIGN INPUT FRAME fBusca v-cod-tipo-ini        
               INPUT FRAME fBusca v-cod-tipo-fim
               INPUT FRAME fBusca v-it-codigo-ini  
               INPUT FRAME fBusca v-it-codigo-fim 
               INPUT FRAME fBusca v-depos-ini  
               INPUT FRAME fBusca v-depos-fim. 

        RUN setConstraintSequencia IN {&hDBOTable} (INPUT v-it-codigo-ini,
                                                    INPUT v-it-codigo-fim,
                                                    input v_cod_estab_usuar,
                                                    input v_cod_estab_usuar,                                                    
                                                    INPUT v-depos-ini,    
                                                    INPUT v-depos-fim,
                                                    INPUT 0,
                                                    INPUT 999,
                                                    INPUT v-cod-tipo-ini,  
                                                    INPUT v-cod-tipo-fim).  

        RUN openQueryStatic IN {&hDBOTable} (INPUT "Sequencia":U) NO-ERROR.

        IF v-it-codigo-ini = "" 
        AND v-it-codigo-fim = "ZZZZZZZZZZZZZZZ"
        AND v-depos-ini = ""
        AND v-depos-fim = "ZZZ"
        AND v-cod-tipo-ini = 0
        AND v-cod-tipo-fim = 999 THEN iqtd = 40.
        ELSE iqtd = ?.

        SESSION:SET-WAIT-STATE("GENERAL":U).
        STATUS DEFAULT "Lendo registros, aguarde...".
        RUN getBatchRecords IN {&hDBOTable} (INPUT ?,
                                             INPUT ?,
                                             INPUT iqtd,
                                             OUTPUT iqtd,
                                             OUTPUT TABLE ttitem-tipo-loc).

        SESSION:SET-WAIT-STATE("":U).
        STATUS DEFAULT "".
        {&OPEN-QUERY-brMain}

        v-sel = YES.
        APPLY "GO":U TO FRAME fBusca.
    END.

    ON 'choose':U OF btBuscaCancel IN FRAME fBusca DO:
        APPLY "GO":U TO FRAME fBusca.
        RETURN NO-APPLY.
    END.

    ENABLE v-cod-tipo-ini 
           v-cod-tipo-fim 
           v-it-codigo-ini
           v-it-codigo-fim
           v-depos-ini    
           v-depos-fim   
           btBuscaOK btBuscaCancel 
        WITH FRAME fBusca. 

    ASSIGN v-cod-tipo-ini:SCREEN-VALUE IN FRAME fBusca  = string(v-cod-tipo-ini)        
           v-cod-tipo-fim:SCREEN-VALUE IN FRAME fBusca  = string(v-cod-tipo-fim)
           v-it-codigo-ini:SCREEN-VALUE IN FRAME fBusca  = v-it-codigo-ini 
           v-it-codigo-fim:SCREEN-VALUE IN FRAME fBusca  = v-it-codigo-fim 
           v-depos-ini:SCREEN-VALUE IN FRAME fBusca  = v-depos-ini 
           v-depos-fim:SCREEN-VALUE IN FRAME fBusca  = v-depos-fim. 
    
    WAIT-FOR "GO":U OF FRAME fBusca.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-item wMaintenance 
FUNCTION fn-desc-item RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR v-result AS CHAR NO-UNDO.  
  FOR FIRST ITEM FIELDS (desc-item) NO-LOCK
      WHERE ITEM.it-codigo = ttitem-tipo-loc.it-codigo:
      v-result = ITEM.desc-item.
  END.

  RETURN v-result.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

