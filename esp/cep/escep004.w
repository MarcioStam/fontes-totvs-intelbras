&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttae-item NO-UNDO LIKE ae-item
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
{include/i-prgvrs.i escep004 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCEP004
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

&GLOBAL-DEFINE ttTable        ttae-item
&GLOBAL-DEFINE hDBOTable      boae-item
&GLOBAL-DEFINE DBOTable       ae-item

&GLOBAL-DEFINE page0KeyFields 
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

def var v-ae         as char format "x(07)".
def var v-sequencia  as char format "x(03)".
DEFINE VARIABLE v-nr-ae LIKE {&ttTable}.nr-ae NO-UNDO VIEW-AS FILL-IN SIZE 8 BY 0.88.
DEF VAR v-sequencia-ini AS INT FORMAT ">>>>9" NO-UNDO VIEW-AS FILL-IN SIZE 8 BY 0.88.
DEF VAR v-sequencia-fim LIKE v-sequencia-ini.
def var v-it-codigo  like item.it-codigo.
DEF VAR v-nom-dir-spool AS CHAR NO-UNDO.
DEF VAR i-seq AS INTEGER NO-UNDO.
{upc/btb910za-upc.i} /* Definiá∆o do estabelecimento do usu†rio */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttae-item

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 ttae-item.situacao ttae-item.cod-depos ttae-item.data ttae-item.data-fabricacao ttae-item.data-validade ttae-item.impresso ttae-item.it-codigo ttae-item.localizacao ttae-item.nf ttae-item.nr-ae ttae-item.quantidade ttae-item.roteiro ttae-item.sequencia   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1   
&Scoped-define SELF-NAME BROWSE-1
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH ttae-item
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY {&SELF-NAME} FOR EACH ttae-item.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 ttae-item
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 ttae-item


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-codigo btUpdate btQueryJoins ~
btReportsJoins btExit BROWSE-1 btHelp rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS fi-codigo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
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

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

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

DEFINE BUTTON btUpdate 
     LABEL "&Atualizar" 
     SIZE 10 BY 1 TOOLTIP "Atualizar".

DEFINE VARIABLE fi-codigo AS CHARACTER FORMAT "X(26)":U 
     LABEL "Leitora" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 TOOLTIP "Informe o item" NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      ttae-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 wMaintenance _FREEFORM
  QUERY BROWSE-1 DISPLAY
      ttae-item.situacao WIDTH 7
      ttae-item.cod-depos 
    ttae-item.data 
    ttae-item.data-fabricacao 
    ttae-item.data-validade 
    ttae-item.impresso 
    ttae-item.it-codigo 
    ttae-item.localizacao 
    ttae-item.nf 
    ttae-item.nr-ae 
    ttae-item.quantidade  format ">>>>>>>>9"
    ttae-item.roteiro 
    ttae-item.sequencia format "99999" width 7
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS NO-TAB-STOP SIZE 88 BY 8.75
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-codigo AT ROW 1.29 COL 24.57 AUTO-RETURN 
     btUpdate AT ROW 11.75 COL 89 RIGHT-ALIGNED
     btDelete AT ROW 1.13 COL 1.57 HELP
          "Elimina ocorrància corrente"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas" NO-TAB-STOP 
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados" NO-TAB-STOP 
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     BROWSE-1 AT ROW 3 COL 2
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda" NO-TAB-STOP 
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 12.13
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttae-item T "?" NO-UNDO mgesp ae-item
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
         HEIGHT             = 12.17
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
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-1 btExit fpage0 */
/* SETTINGS FOR BUTTON btDelete IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btUpdate IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-codigo IN FRAME fpage0
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttae-item.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
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


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    IF INPUT fi-codigo > "" THEN DO:
        RUN pi-leitora.  
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
            {method/ShowMessage.i1}.
            {method/ShowMessage.i2 &Modal="YES"}.
            {method/ShowMessage.i3}.
            APPLY "entry" TO fi-codigo IN FRAME fPage0.
            FOR EACH RowErrors:
                RUN printLog(RowErrors.errordescription).
            END.
            RETURN NO-APPLY.
        END.
    END.

    IF BROWSE BROWSE-1:NUM-ITERATIONS > 0 THEN DO:
        IF INPUT fi-codigo = "" THEN
            RUN pi-question (INPUT "Confirma exclus∆o?",
                             INPUT "AEs baixados n∆o ser∆o eliminados").
        IF RETURN-VALUE = "yes" OR INPUT fi-codigo > "" THEN DO:
            RUN emptyRowErrors IN {&hDBOTable} NO-ERROR.        
            IF INPUT fi-codigo = "" THEN DO:
                RUN setConstraintByItemSequencia IN {&hDBOTable} (INPUT v_cod_estab_usuar,
                                                                  INPUT "",
                                                                  INPUT "ZZZZZZZZZZZZZZZZ",
                                                                  INPUT v-nr-ae,
                                                                  INPUT v-nr-ae,
                                                                  INPUT v-sequencia-ini,
                                                                  INPUT v-sequencia-fim,
                                                                  INPUT NO,
                                                                  INPUT ?).
                RUN openQueryStatic IN {&hDBOTable} (INPUT "ByItemSequencia":U) NO-ERROR.
                RUN deleteRecordBatch IN {&hDBOTable}.
                RUN getrowerrors IN {&hDBOTable} (OUTPUT TABLE rowerrors).
                IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
                    {method/ShowMessage.i1}.
                    {method/ShowMessage.i2 &Modal="YES"}.
                    {method/ShowMessage.i3}.
                    RETURN NO-APPLY.
                END.
            END.
            ELSE DO:
                RUN deleteRecord IN {&hDBOTable}.
                RUN getrowerrors IN {&hDBOTable} (OUTPUT TABLE rowerrors).
                IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
                    {method/ShowMessage.i1}.
                    {method/ShowMessage.i2 &Modal="YES"}.
                    {method/ShowMessage.i3}.
                    RETURN NO-APPLY.
                END.
            END.
            EMPTY TEMP-TABLE ttae-item.
            OPEN QUERY BROWSE-1 FOR EACH ttae-item.
            fi-codigo = "".
            DISP fi-codigo WITH FRAME fPage0.
            APPLY "entry" TO fi-codigo IN FRAME fPage0.
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


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
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


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Atualizar */
DO:
    RUN pi-atualizar.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-codigo wMaintenance
ON LEAVE OF fi-codigo IN FRAME fpage0 /* Leitora */
DO:
  IF INPUT fi-codigo > "" THEN DO:
      DISABLE btUpdate WITH FRAME fPage0.
      APPLY "choose" TO btDelete IN FRAME fPage0.
  END.
  ELSE
      ENABLE btUpdate WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-codigo wMaintenance
ON RETURN OF fi-codigo IN FRAME fpage0 /* Leitora */
DO:
  APPLY "leave" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
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
    ENABLE ALL WITH FRAME fPage0.
    APPLY "entry" TO fi-codigo IN FRAME fPage0.
    FOR FIRST usuar_mestre FIELDS (nom_dir_spool) NO-LOCK
        WHERE usuar_mestre.cod_usuar = c-seg-usuario:
        v-nom-dir-spool = usuar_mestre.nom_dir_spool.
    END.
    IF v-nom-dir-spool = "" THEN v-nom-dir-spool = SESSION:TEMP-DIRECTORY.
    IF v-nom-dir-spool > "" 
    AND lookup(SUBSTRING(v-nom-dir-spool, LENGTH(v-nom-dir-spool), 1), "/,\") = 0 THEN
        v-nom-dir-spool = v-nom-dir-spool + "/".
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
       {&hDBOTable}:FILE-NAME <> "esbo/boes010.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes010.p YES}
        {btb/btb008za.i2 esbo/boes010.p '' {&hDBOTable}}
    END.
    
    run setConstraintMain in {&hDBOTable} (input v_cod_estab_usuar). 
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualizar wMaintenance 
PROCEDURE pi-atualizar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR iqtd AS INTEGER NO-UNDO.

    DEFINE BUTTON btSelecionaCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btSelecionaOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE FRAME fSeleciona
        v-nr-ae           AT ROW 1.21 COL 15.0 COLON-ALIGNED 
        v-sequencia-ini   AT ROW 2.21 COL 15.0 COLON-ALIGNED LABEL "SeqÅància Inicial"
        v-sequencia-fim   AT ROW 3.21 COL 15.0 COLON-ALIGNED LABEL "SeqÅància Final"
        btSelecionaOK     AT ROW 4.63 COL 2.14
        btSelecionaCancel AT ROW 4.63 COL 13
        rtGoToButton      AT ROW 4.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Seleá∆o" FONT 1
             DEFAULT-BUTTON btSelecionaOK CANCEL-BUTTON btSelecionaCancel.
    
    ON "CHOOSE":U OF btSelecionaOK IN FRAME fSeleciona DO:
        ASSIGN INPUT FRAME fSeleciona v-nr-ae        
               INPUT FRAME fSeleciona v-sequencia-ini 
               INPUT FRAME fSeleciona v-sequencia-fim.

        RUN setConstraintByAE IN {&hDBOTable} (INPUT v_cod_estab_usuar,
                                               INPUT v-nr-ae,
                                               INPUT v-nr-ae,
                                               INPUT v-sequencia-ini,
                                               INPUT v-sequencia-fim).
        RUN openQueryStatic IN {&hDBOTable} (INPUT "ByAE":U) NO-ERROR.
        RUN getBatchRecords IN {&hDBOTable} (INPUT ?,
                                             INPUT ?,
                                             INPUT ?,
                                             OUTPUT iqtd,
                                             OUTPUT TABLE ttae-item).

        OPEN QUERY BROWSE-1 FOR EACH ttae-item.

        APPLY "GO":U TO FRAME fSeleciona.
    END.

    ENABLE v-nr-ae         btSelecionaOK btSelecionaCancel 
           v-sequencia-ini
           v-sequencia-fim
        WITH FRAME fSeleciona. 

    ASSIGN v-nr-ae:SCREEN-VALUE IN FRAME fSeleciona          = string(v-nr-ae)        
           v-sequencia-ini:SCREEN-VALUE IN FRAME fSeleciona  = string(v-sequencia-ini)
           v-sequencia-fim:SCREEN-VALUE IN FRAME fSeleciona  = string(v-sequencia-fim).
    
    WAIT-FOR "GO":U OF FRAME fSeleciona.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leitora wMaintenance 
PROCEDURE pi-leitora :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-codigo as char format "x(26)" NO-UNDO VIEW-AS FILL-IN SIZE 27 BY 0.88.
    DEF VAR iqtd AS INTEGER NO-UNDO.
    def var c-digito     as int  format "9" initial 0.
    def var c-quantidade as char format "x(06)".
    def var c-linha      as char format "x(20)".
    DEF VAR i-sequencia AS INT NO-UNDO.
    def var i-it-digito  as integer format "9" initial 0.

    ASSIGN c-codigo = trim(INPUT FRAME fPage0 fi-codigo). 

    EMPTY TEMP-TABLE RowErrors.

    CASE LENGTH(c-codigo):
        WHEN 23 THEN DO:
           assign c-digito     = int(substring(c-codigo,23,1))
                  v-it-codigo  = substring(c-codigo,1,7) 
                  c-quantidade = substring(c-codigo,8,5) 
                  v-ae         = substring(c-codigo,13,7)
                  v-sequencia  = substring(c-codigo,20,3)
                  c-linha      = v-it-codigo + c-quantidade + v-ae + v-sequencia.
        END.
        WHEN 26 THEN DO:
            assign v-it-codigo = substring(c-codigo,7,7)
                  c-quantidade = substring(c-codigo,14,6)
                      c-digito = int(substring(c-codigo,26,1))
                       c-linha = substring(c-codigo,1,25).
        END.
        OTHERWISE DO:
            CREATE RowErrors.
            ASSIGN i-sequencia = i-sequencia + 1
                   RowErrors.errorsequence = i-sequencia
                   RowErrors.errornumber   = 0
                   RowErrors.errordescription = "Tamanho da Etiqueta Incorreto. Chame o Respons†vel"
                   RowErrors.errortype = "error"
                   RowErrors.errorhelp = RowErrors.errordescription.
            RETURN.
        END.
    END CASE.
    run esp/es0135(input c-linha, output i-it-digito).
    if c-digito <> i-it-digito then do:
        CREATE RowErrors.
        ASSIGN i-sequencia = i-sequencia + 1
               RowErrors.errorsequence = i-sequencia
               RowErrors.errornumber   = 0
               RowErrors.errordescription = "D°gito verificador n∆o confere - Erro na leitura"
               RowErrors.errortype = "error"
               RowErrors.errorhelp = RowErrors.errordescription.
        RETURN.
    end.
    IF NOT CAN-FIND(FIRST item 
                    where item.it-codigo = v-it-codigo no-lock) THEN DO:
        CREATE RowErrors.
        ASSIGN i-sequencia = i-sequencia + 1
               RowErrors.errorsequence = i-sequencia
               RowErrors.errornumber   = 0
               RowErrors.errordescription = "Item n∆o cadastrado"
               RowErrors.errortype = "error"
               RowErrors.errorhelp = RowErrors.errordescription.
        RETURN.
    END.

    RUN setConstraintByAE IN {&hDBOTable} (INPUT v_cod_estab_usuar,
                                           INPUT int(v-ae),
                                           INPUT int(v-ae),
                                           INPUT int(v-sequencia),
                                           INPUT int(v-sequencia)).
    RUN openQueryStatic IN {&hDBOTable} (INPUT "ByAE":U) NO-ERROR.
    RUN getRecord IN {&hDBOTable} (OUTPUT TABLE ttae-item).
    FIND FIRST ttae-item NO-ERROR.

    IF NOT AVAIL ttae-item THEN DO:
        CREATE RowErrors.
        ASSIGN i-sequencia = i-sequencia + 1
               RowErrors.errorsequence = i-sequencia
               RowErrors.errornumber   = 0
               RowErrors.errordescription = "N∆o existe registro de AE"
               RowErrors.errortype = "error"
               RowErrors.errorhelp = RowErrors.errordescription.
        RETURN.
    END.
    IF ttae-item.situacao THEN DO:
        CREATE RowErrors.
        ASSIGN i-sequencia = i-sequencia + 1
               RowErrors.errorsequence = i-sequencia
               RowErrors.errornumber   = 0
               RowErrors.errordescription = "AE j† Baixado"
               RowErrors.errortype = "error"
               RowErrors.errorhelp = RowErrors.errordescription.
        RETURN.
    END.
    OPEN QUERY BROWSE-1 FOR EACH ttae-item.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-question wMaintenance 
PROCEDURE pi-question :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-texto-msg AS CHAR NO-UNDO.
    DEF INPUT PARAM p-help-msg AS CHAR NO-UNDO.

    def var v_msg_val           as char     no-undo 
        view-as editor size-char 61 by 1.7 
        scrollbar-vertical.
    def var v_msg_hlp           as char     no-undo 
        view-as editor size-char 50 by 3
        scrollbar-vertical font 2.
    def var c-ajuda             as char format "x(7)" no-undo view-as text size 7 by 1 INIT "Ajuda".

    def image im_msg_ico     file "image/im-mqerr".
    def rectangle rt_help    size-char 52 by 4 edge-pixels 2 bgcolor 8.
    def rectangle rt_button  size-char 61 by 1.42 edge-pixels 1 bgcolor 7.
    def button bt_yes         label "&Sim" size-char 10 by 1 auto-go.
    def button bt_no         label "&N∆o" size-char 10 by 1 auto-go.
    
    def frame f_msg_help
        v_msg_val    at row 1.5 col 2
        im_msg_ico   at row 4.5 col  4
        v_msg_hlp    at row 4.5 col 12
        rt_help      at row 4.0 col 11
        c-ajuda      at row 3.5 col 14 
        rt_button    at row 8.5 col 2 space(1)
        bt_yes        at row 8.71 col 3
        bt_no        at row 8.71 col 14
        skip(0.5)
        with three-d no-label view-as DIALOG-BOX TITLE "Pergunta".

    on cursor-right of 
        bt_yes, bt_no    apply "TAB" to self.
    on cursor-left of
        bt_yes, bt_no    apply "SHIFT-TAB" to self.
     
    on choose of bt_yes
        return "yes".
    on choose of bt_no 
        return "no".
    on end-error of frame f_msg_help do:
        if bt_no:HIDDEN in frame f_msg_help = no then 
            return "no".
        else return "yes".
    end.
    im_msg_ico:load-image("image/im-mqqst").
 
    assign v_msg_val = p-texto-msg.
    assign v_msg_hlp = p-help-msg + chr(10) + "".

    assign bt_no:hidden in frame f_msg_help = no
           bt_no:sensitive in frame f_msg_help = yes
           bt_yes:hidden in frame f_msg_help = no     
           bt_yes:sensitive in frame f_msg_help = yes. 
    assign v_msg_val:read-only in frame f_msg_help = yes
           v_msg_hlp:read-only in frame f_msg_help = yes.

    VIEW FRAME f_msg_help.
    DISP c-ajuda v_msg_val v_msg_hlp WITH FRAME f_msg_help.
    ENABLE v_msg_val v_msg_hlp WITH FRAME f_msg_help.
    apply "entry" to bt_no.
    wait-for choose of bt_yes or choose of bt_no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE printLog wMaintenance 
PROCEDURE printLog :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-msg-erro AS CHAR format "x(70)" NO-UNDO.
    def var i-saldo-ae like ae-item.quantidade format ">>>,>>>,>>9".
    def var c-etiqueta as char format "x(19)".

    if v-it-codigo <> "" then do:
       find item where 
            item.it-codigo = v-it-codigo no-lock no-error.
         if avail item then do:
           IF SEARCH(v-nom-dir-spool + "erros-es0104") NE ? THEN
               OUTPUT TO VALUE(v-nom-dir-spool + "erros-es0104") APPEND CONVERT TARGET SESSION:CHARSET.
           ELSE 
               OUTPUT TO VALUE(v-nom-dir-spool + "erros-es0104") CONVERT TARGET SESSION:CHARSET.
           disp "==> " item.it-codigo format "x(7)"
           item.descricao-1 + item.descricao-2 format "x(36)" skip
           "    "  p-msg-erro skip
           with width 300 no-labels frame f-imp-erro STREAM-IO.
           for each saldo-estoq no-lock
              where saldo-estoq.it-codigo = v-it-codigo :
                disp "    Saldo Alm:"  saldo-estoq.qtidade-atu 
                      saldo-estoq.cod-localiz skip with frame f-imp-erro STREAM-IO.
           end.
           assign i-saldo-ae = 0.
           for each ae-item 
              where ae-item.cod-estabel = v_cod_estab_usuar 
              and ae-item.it-codigo = v-it-codigo              :
                  assign i-saldo-ae = i-saldo-ae + quantidade.
           end.
           disp "     Saldo AE: " i-saldo-ae skip
                "      Usu†rio: " c-etiqueta  skip
                "    Data/Hora: " today " - " string(time,"HH:MM:SS")
                with frame f-imp-erro STREAM-IO.       
           output close.
         end.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

