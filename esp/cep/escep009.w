&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttae-baixa NO-UNDO LIKE ae-baixa
       field r-rowid as rowid.
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
{include/i-prgvrs.i escpe009 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCEP009
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

&GLOBAL-DEFINE ttTable        ttae-baixa
&GLOBAL-DEFINE hDBOTable      boae-baixa
&GLOBAL-DEFINE DBOTable       ae-baixa
&GLOBAL-DEFINE ttTable2       ttae-item
&GLOBAL-DEFINE hDBOTable2     boae-item
&GLOBAL-DEFINE DBOTable2      ae-item

&GLOBAL-DEFINE page0KeyFields 
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR FORMAT "x(12)" NO-UNDO.

{esp/es0018.i}

DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.

/*
&GLOBAL-DEFINE BrowseName brMain
&GLOBAL-DEFINE FRAME-NAME fpage0
&GLOBAL-DEFINE afterCreateRecord pi-carrega
*/
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable2} AS HANDLE NO-UNDO.
DEF VAR h-boes322 AS HANDLE NO-UNDO.
DEF VAR v-item-ini AS CHAR NO-UNDO FORMAT "x(16)" VIEW-AS FILL-IN SIZE 17 BY 0.88.
DEF VAR v-item-fim AS CHAR NO-UNDO FORMAT "x(16)" VIEW-AS FILL-IN SIZE 17 BY 0.88 INIT "9999999999999999".
DEF VAR iqtd AS INTEGER NO-UNDO.
DEF VAR varquivo AS CHAR NO-UNDO.

DEF TEMP-TABLE ttae-item-aux LIKE ttae-item.

{upc\btb910za-upc.i}

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
&Scoped-define INTERNAL-TABLES ttae-baixa ttae-item

/* Definitions for BROWSE brMain                                        */
&Scoped-define FIELDS-IN-QUERY-brMain ttae-baixa.nr-ae ttae-item.sequencia ~
ttae-item.it-codigo fn-desc-item() @ ttae-item.cod-depos ~
ttae-item.quantidade ttae-baixa.localizacao ttae-baixa.char-1 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brMain 
&Scoped-define QUERY-STRING-brMain FOR EACH ttae-baixa NO-LOCK, ~
      EACH ttae-item WHERE ttae-item.cod-estabel = ttae-baixa.cod-estabel ~
  AND ttae-item.nr-ae = ttae-baixa.nr-ae ~
  AND ttae-item.sequencia = ttae-baixa.sequencia ~
      AND ttae-item.it-codigo >= v-item-ini ~
 AND ttae-item.it-codigo <= v-item-fim NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brMain OPEN QUERY brMain FOR EACH ttae-baixa NO-LOCK, ~
      EACH ttae-item WHERE ttae-item.cod-estabel = ttae-baixa.cod-estabel ~
  AND ttae-item.nr-ae = ttae-baixa.nr-ae ~
  AND ttae-item.sequencia = ttae-baixa.sequencia ~
      AND ttae-item.it-codigo >= v-item-ini ~
 AND ttae-item.it-codigo <= v-item-fim NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brMain ttae-baixa ttae-item
&Scoped-define FIRST-TABLE-IN-QUERY-brMain ttae-baixa
&Scoped-define SECOND-TABLE-IN-QUERY-brMain ttae-item


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brMain}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btFiltro btAtualiza btQueryJoins ~
btReportsJoins btExit btHelp brMain 

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
DEFINE BUTTON btAtualiza 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25 TOOLTIP "Recarrega registros de AEÔs"
     FONT 4.

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
     SIZE 4 BY 1.25 TOOLTIP "Imprimir AEÔs Selecionadas"
     FONT 4.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brMain FOR 
      ttae-baixa, 
      ttae-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brMain wMaintenance _STRUCTURED
  QUERY brMain NO-LOCK DISPLAY
      ttae-baixa.nr-ae FORMAT "9999999":U WIDTH 5
      ttae-item.sequencia FORMAT "999":U
      ttae-item.it-codigo FORMAT "x(16)":U
      fn-desc-item() @ ttae-item.cod-depos COLUMN-LABEL "Descriá∆o" FORMAT "x(36)":U
            WIDTH 42
      ttae-item.quantidade FORMAT ">>>>9":U
      ttae-baixa.localizacao FORMAT "x(12)":U
      ttae-baixa.char-1 FORMAT "x(8)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88.57 BY 10.83
         FONT 1 FIT-LAST-COLUMN TOOLTIP "Duplo clique ou ENTER para baixae/F3-Buscar Pallet".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFiltro AT ROW 1.13 COL 2 HELP
          "Consultas relacionadas"
     btAtualiza AT ROW 1.13 COL 6 HELP
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
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 12.46
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttae-baixa T "?" NO-UNDO mgesp ae-baixa
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
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
         HEIGHT             = 12.46
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
         CONTEXT-HELP-FILE  = "F3 - Buscar Pallet":U
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}
{esp/showmsg.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brMain btHelp fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brMain
/* Query rebuild information for BROWSE brMain
     _TblList          = "Temp-Tables.ttae-baixa,Temp-Tables.ttae-item WHERE Temp-Tables.ttae-baixa ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ","
     _JoinCode[2]      = "Temp-Tables.ttae-item.cod-estabel = Temp-Tables.ttae-baixa.cod-estabel
  AND Temp-Tables.ttae-item.nr-ae = Temp-Tables.ttae-baixa.nr-ae
  AND Temp-Tables.ttae-item.sequencia = Temp-Tables.ttae-baixa.sequencia"
     _Where[2]         = "Temp-Tables.ttae-item.it-codigo >= v-item-ini
 AND Temp-Tables.ttae-item.it-codigo <= v-item-fim"
     _FldNameList[1]   > Temp-Tables.ttae-baixa.nr-ae
"ttae-baixa.nr-ae" ? ? "integer" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.ttae-item.sequencia
     _FldNameList[3]   = Temp-Tables.ttae-item.it-codigo
     _FldNameList[4]   > "_<CALC>"
"fn-desc-item() @ ttae-item.cod-depos" "Descriá∆o" "x(36)" ? ? ? ? ? ? ? no ? no no "42" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.ttae-item.quantidade
     _FldNameList[6]   = Temp-Tables.ttae-baixa.localizacao
     _FldNameList[7]   = Temp-Tables.ttae-baixa.char-1
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


&Scoped-define BROWSE-NAME brMain
&Scoped-define SELF-NAME brMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brMain wMaintenance
ON F3 OF brMain IN FRAME fpage0
DO:
    IF v_cod_estab_usuar = "104" THEN DO:  

        BROWSE brMain:FETCH-SELECTED-ROW(1).
        FIND CURRENT ttae-item NO-ERROR.
        FIND CURRENT ttae-baixa NO-ERROR.

        IF ttae-baixa.char-1 = "" THEN
            ASSIGN ttae-baixa.char-1 = "*".
        ELSE
            ASSIGN ttae-baixa.char-1 = "".

        FIND FIRST ae-baixa OF ttae-baixa NO-ERROR.
        IF AVAIL ae-baixa THEN DO:
            ASSIGN ae-baixa.char-1 = ttae-baixa.char-1.
        END.

        brMain:REFRESH() IN FRAME fPage0.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brMain wMaintenance
ON MOUSE-SELECT-DBLCLICK OF brMain IN FRAME fpage0
DO:
  IF BROWSE brMain:NUM-ITERATIONS > 0 
  AND BROWSE brMain:NUM-SELECTED-ROWS > 0 THEN DO:
      RUN ShowMessage(3, "Confirma a baixa da AE?", "").
      IF RETURN-VALUE = "yes" THEN DO:
          BROWSE brMain:FETCH-SELECTED-ROW(1).
          FIND CURRENT ttae-item NO-ERROR.
          FIND CURRENT ttae-baixa NO-ERROR.

          IF v_cod_estab_usuar = "104" THEN DO:
              IF ttae-baixa.char-1 <> "*" THEN DO:
                  MESSAGE "AE n∆o esta selecionada. N∆o pode ser baixada."
                      VIEW-AS ALERT-BOX INFO BUTTONS OK.
                  RETURN NO-APPLY.
              END.

                /* Retirado Gravaá∆o de Log - TOTVS11 (Emerson)
                EMPTY TEMP-TABLE tt-prog-ponto.
                
                RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                                   INPUT 1,
                                   INPUT 0,
                                   INPUT "":U,
                                   OUTPUT TABLE tt-prog-ponto).
                
                FOR FIRST tt-prog-ponto:
                
                    ASSIGN c-dir-saida = replace(tt-prog-ponto.conteudo, "/", "~\").
                
                    IF SUBSTRING(c-dir-saida, LENGTH(c-dir-saida), 1) <> "~\" THEN
                        ASSIGN c-dir-saida = c-dir-saida + "~\".
                
                END.

              ASSIGN varquivo = c-dir-saida + "em043280~\ae~\ae-baixa-" + v_cod_usuar_corren + ".csv".
              OUTPUT TO VALUE(varquivo) APPEND.
              PUT ttae-item.nr-ae ";"
                  ttae-item.sequencia ";"
                  ttae-item.it-codigo ";"
                  ttae-item.localizacao ";"
                  ttae-baixa.localizacao ";"
                  v_cod_usuar_corren ";"
                  STRING(TODAY) ";"    
                  STRING(TIME,"hh:mm:ss") 
                  SKIP.

              OUTPUT CLOSE. */
          END.
          
          RUN baixaSaldo IN h-boes322 (INPUT v_cod_estab_usuar,
                                       INPUT ttae-item.it-codigo, 
                                       INPUT ttae-baixa.localizacao).

          RUN emptyRowErrors IN {&hDBOTable} NO-ERROR.        
          RUN repositionRecord IN {&hDBOTable} (INPUT ttae-baixa.r-rowid).  
          RUN deleteRecord IN {&hDBOTable}.
          RUN getrowerrors IN {&hDBOTable} (OUTPUT TABLE rowerrors).
          DELETE ttae-baixa.

          brMain:DELETE-CURRENT-ROW() IN FRAME fPage0.

      END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brMain wMaintenance
ON RETURN OF brMain IN FRAME fpage0
DO:
  APPLY "mouse-select-dblclick" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAtualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualiza wMaintenance
ON CHOOSE OF btAtualiza IN FRAME fpage0 /* Query Joins */
DO:
  
  RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
  RUN getBatchRecords IN {&hDBOTable} (INPUT ?,
                                       INPUT ?,
                                       INPUT ?,
                                       OUTPUT iqtd,
                                       OUTPUT TABLE ttae-baixa).

  FOR EACH ttae-baixa
      BREAK BY ttae-baixa.nr-ae:
      IF FIRST-OF(ttae-baixa.nr-ae) THEN DO:
          RUN pi-carrega.
      END.
  END.
  {&OPEN-QUERY-brMain}
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


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    /* RUN showQueryJoins IN THIS-PROCEDURE. */
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    DEF VAR vusuario AS CHAR FORMAT "x(40)" NO-UNDO.
    /*
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
    
    
    DEFINE FRAME fGoToRecord
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.88)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
   /* RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle). */
    {utp/ut-liter.i "Altera Numero de SÇrie"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
    */
        FIND FIRST usuar_mestre NO-LOCK 
            WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.

        IF AVAIL usuar_mestre THEN
            ASSIGN vusuario = usuar_mestre.nom_usuario.
        ELSE
            ASSIGN vusuario = "".
        
        assign varquivo = SESSION:TEMP-DIRECTORY + "ae-baixa.txt".
        output to value(varquivo) CONVERT TARGET "iso8859-1".

        PUT UNFORMATTED
            "LOCALIZAÄÂES SELECIONADAS POR: " vusuario SKIP(1)
            "Localizaá∆o" SPACE(2)
            "AE" SPACE(7)
            "Seq." SPACE(2)
            "Item" 
            SKIP.

        FOR EACH ttae-baixa WHERE ttae-baixa.char-1 = "*" NO-LOCK,
                EACH ttae-item WHERE ttae-item.cod-estabel = ttae-baixa.cod-estabel
                             AND ttae-item.nr-ae = ttae-baixa.nr-ae
                             AND ttae-item.sequencia = ttae-baixa.sequencia
                             AND ttae-item.it-codigo >= v-item-ini
                             AND ttae-item.it-codigo <= v-item-fim NO-LOCK:

            PUT ttae-baixa.localizacao SPACE(1)
                ttae-baixa.nr-ae       SPACE(2)
                ttae-baixa.sequencia   SPACE(3)
                ttae-item.it-codigo
                SKIP.
                
        END.
        
        OUTPUT CLOSE.
        

        /* comando abaixo abre arquivo no bloco de notas. */
        DOS SILENT START NOTEPAD value(varquivo).

      /*  APPLY "GO":U TO FRAME fGoToRecord. */
    /*    
    END.
    
    ENABLE btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.    
    */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDisplayFields wMaintenance 
PROCEDURE AfterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN initializeDBOs IN THIS-PROCEDURE.

    APPLY "choose" TO btAtualiza IN FRAME fPage0.
    

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
       {&hDBOTable}:FILE-NAME <> "esbo/boes005.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes005.p YES}
        {btb/btb008za.i2 esbo/boes005.p '' {&hDBOTable}}
    END.
    
    IF NOT VALID-HANDLE({&hDBOTable2}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "esbo/boes010.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes010.p YES}
        {btb/btb008za.i2 esbo/boes010.p '' {&hDBOTable2}}
    END.

    IF NOT VALID-HANDLE(h-boes322) OR
       h-boes322:TYPE <> "PROCEDURE":U OR
       h-boes322:FILE-NAME <> "esbo/boes322.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes322.p YES}
        {btb/btb008za.i2 esbo/boes322.p '' h-boes322}
    END.
    
    run setConstraintMain in {&hDBOTable} (input v_cod_estab_usuar).
    run setConstraintMain in {&hDBOTable2} (input v_cod_estab_usuar).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega wMaintenance 
PROCEDURE pi-carrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR iqtd AS INTEGER NO-UNDO.
       
    FIND CURRENT ttae-baixa NO-ERROR.

    IF AVAIL ttae-baixa THEN DO:
        RUN setConstraintByAE IN {&hDBOTable2} (input v_cod_estab_usuar,
                                                INPUT ttae-baixa.nr-ae,
                                                INPUT ttae-baixa.nr-ae,
                                                INPUT 0,
                                                INPUT 99999).
        RUN openQueryStatic IN {&hDBOTable2} (INPUT "ByAE2":U) NO-ERROR.

        RUN getBatchRecords IN {&hDBOTable2} (INPUT ?,
                                              INPUT NO,
                                              INPUT 0,
                                              OUTPUT iqtd,
                                              OUTPUT TABLE ttae-item-aux).
        FOR EACH ttae-item-aux:
            IF NOT CAN-FIND(FIRST ttae-item
                            WHERE ttae-item.r-rowid = ttae-item-aux.r-rowid) THEN DO:
                CREATE ttae-item.
                BUFFER-COPY ttae-item-aux TO ttae-item.
            END.
        END.
    END.
    

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
        v-item-ini           AT ROW 1.21 COL 15.0 COLON-ALIGNED LABEL "Item Inicial" 
        v-item-fim           AT ROW 2.21 COL 15.0 COLON-ALIGNED LABEL "Item Final"
        btBuscaOK     AT ROW 3.63 COL 2.14
        btBuscaCancel AT ROW 3.63 COL 13
        rtBuscaButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Faixa" FONT 1
             DEFAULT-BUTTON btBuscaOK CANCEL-BUTTON btBuscaCancel.
    
    ON "CHOOSE":U OF btBuscaOK IN FRAME fBusca DO:
        ASSIGN INPUT FRAME fBusca v-item-ini        
               INPUT FRAME fBusca v-item-fim.
        
        {&OPEN-QUERY-brMain}

        APPLY "GO":U TO FRAME fBusca.
    END.

    ON 'choose':U OF btBuscaCancel IN FRAME fBusca DO:
        APPLY "GO":U TO FRAME fBusca.
        RETURN NO-APPLY.
    END.

    ENABLE v-item-ini         btBuscaOK btBuscaCancel 
           v-item-fim
        WITH FRAME fBusca. 

    ASSIGN v-item-ini:SCREEN-VALUE IN FRAME fBusca          = v-item-ini        
           v-item-fim:SCREEN-VALUE IN FRAME fBusca  = v-item-fim.
    
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
      WHERE ITEM.it-codigo = ttae-item.it-codigo:
      v-result = ITEM.desc-item.
  END.

  RETURN v-result.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

