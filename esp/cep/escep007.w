&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttabastecedor NO-UNDO LIKE abastecedor
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
{include/i-prgvrs.i escep007 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCEP007
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

&GLOBAL-DEFINE ttTable        ttabastecedor
&GLOBAL-DEFINE hDBOTable      boabastecedor
&GLOBAL-DEFINE DBOTable       abastecedor

&GLOBAL-DEFINE page0KeyFields 
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    

&GLOBAL-DEFINE BrowseName brMain
&GLOBAL-DEFINE FRAME-NAME fpage0

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE c-nome-ini LIKE {&ttTable}.nome NO-UNDO VIEW-AS FILL-IN SIZE 16 BY 0.88.
DEFINE VARIABLE c-depos-ini LIKE {&ttTable}.cod-depos NO-UNDO VIEW-AS FILL-IN SIZE 4 BY 0.88.
DEF VAR c-nome-fim LIKE c-nome-ini NO-UNDO INIT "ZZZZZZZZZZZZZZZ".
DEF VAR c-depos-fim LIKE c-depos-ini NO-UNDO INIT "ZZZ".

DEFINE VARIABLE c-impressora AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

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
&Scoped-define INTERNAL-TABLES ttabastecedor deposito

/* Definitions for BROWSE brMain                                        */
&Scoped-define FIELDS-IN-QUERY-brMain ttabastecedor.nome ttabastecedor.cod-depos deposito.nome   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brMain   
&Scoped-define SELF-NAME brMain
&Scoped-define QUERY-STRING-brMain FOR EACH ttabastecedor, ~
           FIRST deposito WHERE deposito.cod-dep = ttabastecedor.cod-depos
&Scoped-define OPEN-QUERY-brMain OPEN QUERY {&SELF-NAME} FOR EACH ttabastecedor, ~
           FIRST deposito WHERE deposito.cod-dep = ttabastecedor.cod-depos.
&Scoped-define TABLES-IN-QUERY-brMain ttabastecedor deposito
&Scoped-define FIRST-TABLE-IN-QUERY-brMain ttabastecedor
&Scoped-define SECOND-TABLE-IN-QUERY-brMain deposito


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brMain}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btQueryJoins btReportsJoins btExit ~
btHelp brMain btAdd-2 btDelete-2 btTag 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
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
DEFINE BUTTON btAdd-2 
     LABEL "&Incluir" 
     SIZE 10 BY 1 TOOLTIP "Incluir".

DEFINE BUTTON btDelete-2 
     LABEL "&Eliminar" 
     SIZE 10 BY 1 TOOLTIP "Eliminar".

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

DEFINE BUTTON btTag 
     LABEL "&Etiqueta" 
     SIZE 10 BY 1 TOOLTIP "Imprimir etiqueta".

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brMain FOR 
      ttabastecedor, 
      deposito SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brMain wMaintenance _FREEFORM
  QUERY brMain DISPLAY
      ttabastecedor.nome
     ttabastecedor.cod-depos
     deposito.nome
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 50 BY 8.75
         FONT 1 TOOLTIP "Selecione a linha e duplo clique para imprimir etiqueta".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     brMain AT ROW 3 COL 21
     btAdd-2 AT ROW 11.75 COL 21
     btDelete-2 AT ROW 11.75 COL 31
     btTag AT ROW 11.75 COL 42
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
      TABLE: ttabastecedor T "?" NO-UNDO mgesp abastecedor
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brMain
/* Query rebuild information for BROWSE brMain
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttabastecedor,
    FIRST deposito WHERE deposito.cod-dep = ttabastecedor.cod-depos.
     _END_FREEFORM
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
ON MOUSE-SELECT-DBLCLICK OF brMain IN FRAME fpage0
DO:
    IF BROWSE brMain:NUM-ITERATIONS > 0 
    AND BROWSE brMain:NUM-SELECTED-ROWS > 0 THEN DO:
        BROWSE brMain:FETCH-SELECTED-ROW(1).
        FIND CURRENT ttabastecedor NO-ERROR.
        ASSIGN c-nome-ini  = ttabastecedor.nome
               c-nome-fim  = c-nome-ini
               c-depos-ini = ttabastecedor.cod-depos
               c-depos-fim = c-depos-ini.
        APPLY "choose" TO btTag IN FRAME fPage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd-2 wMaintenance
ON CHOOSE OF btAdd-2 IN FRAME fpage0 /* Incluir */
DO:
    wMaintenance:SENSITIVE = NO.
    RUN esp/cep/escep007a.w (INPUT THIS-PROCEDURE,
                             INPUT {&hDBOTable}).
    wMaintenance:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete-2 wMaintenance
ON CHOOSE OF btDelete-2 IN FRAME fpage0 /* Eliminar */
DO:
    IF BROWSE brMain:NUM-ITERATIONS > 0 
    AND BROWSE brMain:NUM-SELECTED-ROWS > 0    
        THEN DO:
        BROWSE brMain:FETCH-SELECTED-ROW(1).
        run utp/ut-msgs.p (input "show",
                           input 550,
                           input "").
        IF RETURN-VALUE = "yes" THEN DO:
            FIND CURRENT ttabastecedor NO-ERROR.
            RUN emptyRowErrors IN {&hDBOTable} NO-ERROR.        
            RUN repositionRecord IN {&hDBOTable} (INPUT ttabastecedor.r-rowid).  
            RUN deleteRecord IN {&hDBOTable}.
            RUN getrowerrors IN {&hDBOTable} (OUTPUT TABLE rowerrors).
            IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
                {method/ShowMessage.i1}.
                {method/ShowMessage.i2 &Modal="YES"}.
                {method/ShowMessage.i3}.
                RETURN NO-APPLY.
            END.
            DELETE ttabastecedor.
            RUN pi-open-query.
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


&Scoped-define SELF-NAME btTag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btTag wMaintenance
ON CHOOSE OF btTag IN FRAME fpage0 /* Etiqueta */
DO:
  RUN pi-seleciona-etiquetas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
                                         OUTPUT TABLE ttabastecedor).
    RUN pi-open-query.
    
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
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "esbo/boes001.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes001.p YES}
        {btb/btb008za.i2 esbo/boes001.p '' {&hDBOTable}}
    END.
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-imprime-etiquetas wMaintenance 
PROCEDURE pi-imprime-etiquetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-nome-ini LIKE {&ttTable}.nome NO-UNDO.
    DEF INPUT PARAM p-nome-fim LIKE p-nome-ini NO-UNDO.
    DEFINE INPUT PARAM p-depos-ini LIKE {&ttTable}.cod-depos NO-UNDO.
    DEF INPUT PARAM p-depos-fim LIKE p-depos-ini NO-UNDO.
    DEF INPUT PARAM p-impressora AS CHAR NO-UNDO.
    
    FOR FIRST imprsor_usuar FIELDS (nom_disposit_so) no-lock
        where imprsor_usuar.nom_impressora = p-impressora
        and   imprsor_usuar.cod_usuario    = c-seg-usuario
        use-index imprsrsr_id,
        FIRST impressora FIELDS () NO-LOCK OF imprsor_usuar,
        FIRST tip_imprsor FIELDS (cod_pag_carac_conver) NO-LOCK of impressora:

        output to value(imprsor_usuar.nom_disposit_so)
               page-size 0
               convert target tip_imprsor.cod_pag_carac_conver . 

        for each abastecedor no-lock
           where abastecedor.nome >= p-nome-ini
             and abastecedor.nome <= p-nome-fim
             and abastecedor.cod-depos >= p-depos-ini
             and abastecedor.cod-depos <= p-depos-fim:

               PUT UNFORMATTED
                   "^XA" SKIP

                   "^PW832"      SKIP   /* Novo comando para zebra 600 */
                   "^JUS"        SKIP   /* Novo comando para zebra 600 */

                   "^FO60,160,^BAN,50,y,n,n^BY2,^FD"
                   ("T" + abastecedor.cod-depos + "-" + abastecedor.nome) format "x(20)" SKIP
                   "^FS^XZ" SKIP.
        end.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-open-query wMaintenance 
PROCEDURE pi-open-query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY brMain FOR EACH ttabastecedor,
    FIRST deposito WHERE deposito.cod-dep = ttabastecedor.cod-depos.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seleciona-etiquetas wMaintenance 
PROCEDURE pi-seleciona-etiquetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btConfigImpr 
         IMAGE-UP FILE "image\im-cfprt":U
         LABEL "" 
         SIZE 4 BY 1.

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
    
    DEF VAR cPrinter AS CHAR NO-UNDO.
    DEF VAR cLayout AS CHAR NO-UNDO.
    DEF VAR cAuxFile AS CHAR NO-UNDO.

    DEFINE FRAME fSeleciona
        c-nome-ini   AT ROW 1.21 COL 15.0 COLON-ALIGNED LABEL "Abastecedor Inicial"
        c-nome-fim   AT ROW 2.21 COL 15.0 COLON-ALIGNED LABEL "Abastecedor Final"
        c-depos-ini  AT ROW 3.21 COL 15.0 COLON-ALIGNED LABEL "Dep¢sito Inicial"
        c-depos-fim  AT ROW 4.21 COL 15.0 COLON-ALIGNED LABEL "Dep¢sito Final" 
        c-impressora AT ROW 5.21 COL 15.0 COLON-ALIGNED LABEL "Impressora" 
        btConfigImpr      AT ROW 5.21 COL 55  HELP "Configura‡Æo da impressora"
        btSelecionaOK     AT ROW 6.63 COL 2.14
        btSelecionaCancel AT ROW 6.63 COL 13
        rtGoToButton      AT ROW 6.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Sele‡Æo" FONT 1
             DEFAULT-BUTTON btSelecionaOK CANCEL-BUTTON btSelecionaCancel.
    
    ON "CHOOSE":U OF btSelecionaOK IN FRAME fSeleciona DO:
        ASSIGN INPUT FRAME fSeleciona c-nome-ini 
               INPUT FRAME fSeleciona c-nome-fim 
               INPUT FRAME fSeleciona c-depos-ini
               INPUT FRAME fSeleciona c-depos-fim
               INPUT FRAME fSeleciona c-impressora.

        IF NUM-ENTRIES(c-impressora, ":") > 0 
        AND NOT CAN-FIND(FIRST imprsor_usuar no-lock
        where imprsor_usuar.nom_impressora = ENTRY(1, c-impressora, ":")
        and   imprsor_usuar.cod_usuario    = c-seg-usuario) 
        OR NUM-ENTRIES(c-impressora, ":") = 0 THEN DO:
            RUN utp/ut-msgs.p ("show",
                               4711,
                               ?).
            RETURN NO-APPLY.
        END.


        RUN pi-imprime-etiquetas (INPUT c-nome-ini, 
                                        c-nome-fim, 
                                        c-depos-ini,
                                        c-depos-fim,
                                        ENTRY(1, c-impressora, ":")).

        APPLY "GO":U TO FRAME fSeleciona.
    END.

    ON "CHOOSE":U OF btConfigImpr IN FRAME fSeleciona DO:
        run utp/ut-impr.w (input-output cPrinter, 
                           input-output cLayout, 
                           input-output cAuxFile).
        if cAuxFile = "" then
          assign c-impressora = cPrinter + ":":U + cLayout.
        else
          assign c-impressora = cPrinter + ":":U + cLayout + ":":U + cAuxFile.  
        DISP c-impressora WITH FRAME fSeleciona.

    END.
    
    ENABLE c-nome-ini c-depos-ini c-nome-fim c-depos-fim btSelecionaOK btSelecionaCancel 
           btConfigImpr
        WITH FRAME fSeleciona. 

    IF c-impressora = "" THEN
        FOR FIRST imprsor_usuar FIELDS (nom_impressora) no-lock
            where imprsor_usuar.nom_impressora MATCHES "*zebra*"
            and   imprsor_usuar.cod_usuario    = c-seg-usuario,
            FIRST layout_impres FIELDS (cod_layout_impres) no-lock
            where layout_impres.nom_impressora    = imprsor_usuar.nom_impressora:
            c-impressora = imprsor_usuar.nom_impressora + ":":U + layout_impres.cod_layout_impres.
        END.

    ASSIGN c-nome-ini:SCREEN-VALUE IN FRAME fSeleciona  = c-nome-ini
           c-nome-fim:SCREEN-VALUE IN FRAME fSeleciona  = c-nome-fim
           c-depos-ini:SCREEN-VALUE IN FRAME fSeleciona = c-depos-ini
           c-depos-fim:SCREEN-VALUE IN FRAME fSeleciona = c-depos-fim
           c-impressora:SCREEN-VALUE = c-impressora.
    
    WAIT-FOR "GO":U OF FRAME fSeleciona.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

