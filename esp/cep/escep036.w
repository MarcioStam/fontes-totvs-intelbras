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
{include/i-prgvrs.i ESCEP036 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCEP036
&GLOBAL-DEFINE Version        2.04.00.000

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
&GLOBAL-DEFINE hDBOTable      hboes010
&GLOBAL-DEFINE DBOTable       ae-item
  
&GLOBAL-DEFINE page0KeyFields 
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE i-tipo AS INTEGER INITIAL 1.
DEFINE VARIABLE i-fim-it-codigo AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" NO-UNDO.
DEFINE VARIABLE i-fim-cod-depos AS CHARACTER FORMAT "x(3)" INITIAL "ZZZ" NO-UNDO.
DEFINE VARIABLE i-fim-cod-localiz AS CHARACTER FORMAT "x(10)" INITIAL "ZZZZZZZZZZ" NO-UNDO.
DEFINE VARIABLE i-ini-it-codigo AS CHARACTER FORMAT "x(16)" NO-UNDO.
DEFINE VARIABLE i-ini-cod-depos AS CHARACTER FORMAT "x(3)" NO-UNDO.
DEFINE VARIABLE i-ini-cod-localiz AS CHARACTER FORMAT "x(10)" NO-UNDO.

DEF VAR vsaldo LIKE saldo-estoq.qtidade-atu.
DEF VAR vsaldo-rec LIKE saldo-estoq.qtidade-atu.
DEF VAR vae AS LOGICAL INITIAL NO.


DEF BUFFER b-saldo-estoq FOR saldo-estoq.

/* Local Variable Definitions (DBOs Handles) --- */

DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO. 


def var hboes121 as handle no-undo.
{upc\btb910za-upc.i}
def temp-table tt-display no-undo
    field it-codigo like item.it-codigo
    field desc-item like item.desc-item format "x(49)"
    FIELD cod-depos LIKE local.cod-depos
    field localizacao like ae-item.localizacao
    field saldo like saldo-estoq.qtidade-atu
    field fm-codigo like familia.fm-codigo
    FIELD qtd-max  LIKE item-tipo-loc.qt-max-entreposto
    FIELD saldo-rec LIKE saldo-estoq.qtidade-atu
    index codigo it-codigo.

def temp-table tt-itens-saldo no-undo
   field it-codigo like item.it-codigo
   field cod-depos like local.cod-depos
   field localizacao like local.localizacao
   field saldo like saldo-estoq.qtidade-atu
   FIELD qtd-max  LIKE item-tipo-loc.qt-max-entreposto
   index codigo it-codigo cod-depos localizacao.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDisplay

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-display

/* Definitions for BROWSE brDisplay                                     */
&Scoped-define FIELDS-IN-QUERY-brDisplay it-codigo desc-item cod-depos localizacao saldo saldo-rec /* seq-ini seq-fim */   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDisplay   
&Scoped-define SELF-NAME brDisplay
&Scoped-define QUERY-STRING-brDisplay FOR EACH tt-display
&Scoped-define OPEN-QUERY-brDisplay OPEN QUERY {&SELF-NAME} FOR EACH tt-display.
&Scoped-define TABLES-IN-QUERY-brDisplay tt-display
&Scoped-define FIRST-TABLE-IN-QUERY-brDisplay tt-display


/* Definitions for FRAME fpage0                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btOK btFiltro btrec ~
btQueryJoins btReportsJoins btExit btHelp brDisplay 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miExecutar     LABEL "&Executar"      ACCELERATOR "F1"
       MENU-ITEM miFiltrar      LABEL "&Filtrar"      
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
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image/im-fil.bmp":U
     LABEL "Filtro":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btOK 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "OK" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btrec 
     IMAGE-UP FILE "adeicon/prevw-d.bmp":U
     LABEL "Filtro":L 
     SIZE 4 BY 1.25 TOOLTIP "Saldo Rec".

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 92 BY 15.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 92 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDisplay FOR 
      tt-display SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDisplay
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDisplay wMaintenance _FREEFORM
  QUERY brDisplay DISPLAY
      it-codigo 
 desc-item 
 cod-depos COLUMN-LABEL "Dep"
 localizacao column-label "Entreposto"
 saldo column-label "Saldo"
 saldo-rec COLUMN-LABEL "Saldo Rec"
 /* seq-ini column-label "Seq Ini"
 seq-fim column-label "Seq Fim" */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN NO-AUTO-VALIDATE NO-ROW-MARKERS SEPARATORS SIZE 90 BY 15
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 1.13 COL 1.57 HELP
          "Atualiza informaá‰es" WIDGET-ID 2
     btFiltro AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior" WIDGET-ID 4
     btrec AT ROW 1.13 COL 71.86 HELP
          "Ocorrància anterior" WIDGET-ID 6
     btQueryJoins AT ROW 1.13 COL 76.43 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 80.43 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 84.43 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 88.43 HELP
          "Ajuda"
     brDisplay AT ROW 2.83 COL 2 WIDGET-ID 200
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 92.57 BY 17.21
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
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
         HEIGHT             = 17.21
         WIDTH              = 92.57
         MAX-HEIGHT         = 17.21
         MAX-WIDTH          = 92.57
         VIRTUAL-HEIGHT     = 17.21
         VIRTUAL-WIDTH      = 92.57
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
   FRAME-NAME                                                           */
/* BROWSE-TAB brDisplay btHelp fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDisplay
/* Query rebuild information for BROWSE brDisplay
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-display.
     _END_FREEFORM
     _Query            is NOT OPENED
*/  /* BROWSE brDisplay */
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


&Scoped-define BROWSE-NAME brDisplay
&Scoped-define SELF-NAME brDisplay
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDisplay wMaintenance
ON MOUSE-SELECT-DBLCLICK OF brDisplay IN FRAME fpage0
DO:
  APPLY "RETURN" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDisplay wMaintenance
ON RETURN OF brDisplay IN FRAME fpage0
DO:
   
    RUN esp\cep\escep036a.w (INPUT tt-display.it-codigo,
                             INPUT tt-display.cod-depos,
                             INPUT tt-display.localizacao,
                             INPUT tt-display.saldo,
                             INPUT tt-display.qtd-max).

    APPLY "CHOOSE" TO btok.
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
ON CHOOSE OF btFiltro IN FRAME fpage0 /* Filtro */
OR CHOOSE OF btFiltro in frame fPage0 DO:
    DEFINE BUTTON btFiltroCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btFiltroOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtFiltroButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.

    DEFINE VARIABLE r-tipo AS integer
         LABEL "Tipo"
         VIEW-AS RADIO-SET HORIZONTAL
         RADIO-BUTTONS 
              "Com Saldo", 1,
              "Todos", 2
         SIZE 20 BY 1.10 init 1.
    
    
    DEFINE VARIABLE fi-fim-it-codigo AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
         VIEW-AS FILL-IN 
         SIZE 14.14 BY .88 NO-UNDO.
    
    DEFINE VARIABLE fi-fim-cod-depos AS CHARACTER FORMAT "x(3)" INITIAL "ZZZ" 
         VIEW-AS FILL-IN 
         SIZE 5.14 BY .88 NO-UNDO.

    DEFINE VARIABLE fi-fim-cod-localiz AS CHARACTER FORMAT "x(10)" INITIAL "ZZZZZZZZZZ" 
         VIEW-AS FILL-IN 
         SIZE 14.14 BY .88 NO-UNDO.
    
    
    DEFINE VARIABLE fi-ini-it-codigo AS CHARACTER FORMAT "x(16)" 
         LABEL "Item":R14 
         VIEW-AS FILL-IN 
         SIZE 14.14 BY .88 NO-UNDO.
    
    DEFINE VARIABLE fi-ini-cod-depos AS CHARACTER FORMAT "x(3)" 
         LABEL "Deposito":R9 
         VIEW-AS FILL-IN 
         SIZE 5.14 BY .88 NO-UNDO.
    
    
    DEFINE VARIABLE fi-ini-cod-localiz AS CHARACTER FORMAT "x(10)" 
         LABEL "Localizaá∆o":R14 
         VIEW-AS FILL-IN 
         SIZE 14.14 BY .88 NO-UNDO.
    
    
    DEFINE IMAGE IMAGE-1
         FILENAME "image\im-fir":U
         SIZE 3 BY .88.
    
    DEFINE IMAGE IMAGE-2
         FILENAME "image\im-las":U
         SIZE 3 BY .88.
    
    DEFINE IMAGE IMAGE-3
         FILENAME "image\im-fir":U
         SIZE 3 BY .88.
    
    DEFINE IMAGE IMAGE-4
         FILENAME "image\im-las":U
         SIZE 3 BY .88.

    DEFINE IMAGE IMAGE-5
         FILENAME "image\im-fir":U
         SIZE 3 BY .88.
    
    DEFINE IMAGE IMAGE-6
         FILENAME "image\im-las":U
         SIZE 3 BY .88.
        
    DEFINE FRAME fFiltro
        fi-ini-it-codigo AT ROW 1.17 COL 9 COLON-ALIGNED
        fi-fim-it-codigo AT ROW 1.17 COL 35.5 NO-LABEL
        fi-ini-cod-depos AT ROW 2.17 COL 9 COLON-ALIGNED
        fi-fim-cod-depos AT ROW 2.17 COL 35.57 NO-LABEL
        fi-ini-cod-localiz AT ROW 3.17 COL 9 COLON-ALIGNED 
        fi-fim-cod-localiz AT ROW 3.17 COL 35.5 NO-LABEL 
        r-tipo AT ROW 4.17 COL 9

        btFiltroOK AT ROW 5.17 COL 2.14
        btFiltroCancel AT ROW 5.17 COL 13
        IMAGE-1 AT ROW 1.17 COL 26 
        IMAGE-2 AT ROW 1.17 COL 32 
        IMAGE-3 AT ROW 2.17 COL 26 
        IMAGE-4 AT ROW 2.17 COL 32
        IMAGE-5 AT ROW 3.17 COL 26 
        IMAGE-6 AT ROW 3.17 COL 32
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Filtro" FONT 1
             DEFAULT-BUTTON btFiltroOK CANCEL-BUTTON btFiltroCancel.
    
    ON "CHOOSE":U OF btFiltroOK IN FRAME fFiltro DO:
        ASSIGN r-tipo
               fi-ini-it-codigo
               fi-fim-it-codigo
               fi-ini-cod-depos
               fi-fim-cod-depos
               fi-ini-cod-localiz 
               fi-fim-cod-localiz.
        ASSIGN i-tipo            = r-tipo
               i-ini-it-codigo   = fi-ini-it-codigo
               i-fim-it-codigo   = fi-fim-it-codigo
               i-ini-cod-depos   = fi-ini-cod-depos
               i-fim-cod-depos   = fi-fim-cod-depos
               i-ini-cod-localiz = fi-ini-cod-localiz
               i-fim-cod-localiz = fi-fim-cod-localiz.
               
        {&OPEN-QUERY-{&QUERY-NAME}}               
        
        APPLY "GO":U TO FRAME fFiltro.
    END.
    
    ON WINDOW-CLOSE OF FRAME fFiltro /* <insert dialog title> */
    DO:
      APPLY "END-ERROR":U TO SELF.
    END.
    
    ASSIGN r-tipo             = i-tipo
           fi-ini-it-codigo   = i-ini-it-codigo
           fi-fim-it-codigo   = i-fim-it-codigo
           fi-ini-cod-depos   = i-ini-cod-depos
           fi-fim-cod-depos   = i-fim-cod-depos
           fi-ini-cod-localiz = i-ini-cod-localiz
           fi-fim-cod-localiz = i-fim-cod-localiz.
           
    
    disp r-tipo
         fi-ini-it-codigo
         fi-fim-it-codigo
         fi-ini-cod-depos
         fi-fim-cod-depos
         fi-ini-cod-localiz 
         fi-fim-cod-localiz
        WITH FRAME fFiltro. 

    ENABLE r-tipo
           fi-ini-it-codigo
           fi-fim-it-codigo 
           fi-ini-cod-depos
           fi-fim-cod-depos
           fi-ini-cod-localiz
           fi-fim-cod-localiz btFiltroOK btFiltroCancel 
        WITH FRAME fFiltro. 
    
    WAIT-FOR "GO":U OF FRAME fFiltro.
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


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenance
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    
    def var iqtd as int no-undo.
    
  
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    EMPTY TEMP-TABLE tt-itens-saldo.
    
    run obtemItensEntrepostoNivelCritico in hboes121 (INPUT v_cod_estab_usuar,
                                                      INPUT i-ini-it-codigo,
                                                      INPUT i-fim-it-codigo,
                                                      INPUT i-ini-cod-depos,
                                                      INPUT i-fim-cod-depos,
                                                      input i-ini-cod-localiz,
                                                      input i-fim-cod-localiz,
                                                      output table tt-itens-saldo).
    
   

    empty temp-table tt-display. 
    
    IF i-tipo = 1 THEN DO:
        for each tt-itens-saldo:
            ASSIGN vae = NO.
            FOR EACH ae-item NO-LOCK where ae-item.cod-estabel = v_cod_estab_usuar
                                     AND ae-item.cod-depos  = tt-itens-saldo.cod-depos
                                     and ae-item.it-codigo  = tt-itens-saldo.it-codigo     
                                     and ae-item.situacao   = NO,
                EACH mgesp.local WHERE local.cod-estabel = ae-item.cod-estabel AND
                                        local.cod-depos   = ae-item.cod-depos AND
                                        local.localizacao = ae-item.localizacao and
                                        local.entreposto  = NO NO-LOCK:
        
                ASSIGN vae = YES.
                LEAVE.
            END.
                
            IF vae = YES THEN DO:
                find first item no-lock
                        where item.it-codigo = tt-itens-saldo.it-codigo no-error.
                create tt-display.
                assign tt-display.it-codigo   = tt-itens-saldo.it-codigo
                       tt-display.desc-item   = item.desc-item           
                       tt-display.cod-depos   = tt-itens-saldo.cod-depos
                       tt-display.localizacao = tt-itens-saldo.localizacao
                       tt-display.saldo       = tt-itens-saldo.saldo                                         
                       tt-display.fm-codigo   = item.fm-codigo
                       tt-display.qtd-max     = tt-itens-saldo.qtd-max.
            END.
        END.
    END.
    ELSE DO:
        for each tt-itens-saldo:
            find first item no-lock
                    where item.it-codigo = tt-itens-saldo.it-codigo no-error.
            create tt-display.
            assign tt-display.it-codigo   = tt-itens-saldo.it-codigo
                   tt-display.desc-item   = item.desc-item           
                   tt-display.cod-depos   = tt-itens-saldo.cod-depos
                   tt-display.localizacao = tt-itens-saldo.localizacao
                   tt-display.saldo       = tt-itens-saldo.saldo                                         
                   tt-display.fm-codigo   = item.fm-codigo
                   tt-display.qtd-max     = tt-itens-saldo.qtd-max.
        end.
    END.

    /* Se n∆o tiver saldo em outra localizaá∆o, verifica se existe no REC */
    FOR EACH tt-display:
        ASSIGN vsaldo = 0
               vsaldo-rec = 0.
        FOR EACH saldo-estoq no-lock
          WHERE saldo-estoq.cod-localiz <> tt-display.localizacao AND
                saldo-estoq.it-codigo   = tt-display.it-codigo AND
                saldo-estoq.cod-depos   = tt-display.cod-depos AND
                saldo-estoq.cod-estabel = v_cod_estab_usuar:
            
           IF saldo-estoq.qtidade-atu <= 0 THEN NEXT.

           ASSIGN vsaldo = vsaldo + saldo-estoq.qtidade-atu.
        END.
        IF vsaldo = 0 THEN DO:
            FOR EACH b-saldo-estoq no-lock
              WHERE b-saldo-estoq.cod-estabel = v_cod_estab_usuar AND
                    b-saldo-estoq.cod-depos   = "rec" AND
                    b-saldo-estoq.it-codigo   = tt-display.it-codigo:
                
               IF b-saldo-estoq.qtidade-atu <= 0 THEN NEXT.
    
               ASSIGN vsaldo-rec = vsaldo-rec + b-saldo-estoq.qtidade-atu.
            END.
        END.
        IF vsaldo-rec <> 0 THEN
            ASSIGN tt-display.saldo-rec = vsaldo-rec.
    END.
    
    &scop SELF-NAME brDisplay
    
    {&OPEN-QUERY-brDisplay}
    
    &undef SELF-NAME
    
    SESSION:SET-WAIT-STATE("":U).
    
  
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


&Scoped-define SELF-NAME btrec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btrec wMaintenance
ON CHOOSE OF btrec IN FRAME fpage0 /* Filtro */
OR CHOOSE OF btrec in frame fPage0 DO:
    FOR EACH tt-display:
        IF tt-display.saldo-rec > 0 THEN NEXT.
        DELETE tt-display.
    END.

    {&OPEN-QUERY-brDisplay}
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


&Scoped-define SELF-NAME miExecutar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miExecutar wMaintenance
ON CHOOSE OF MENU-ITEM miExecutar /* Executar */
DO:
  apply "choose" to btOK in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miFiltrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miFiltrar wMaintenance
ON CHOOSE OF MENU-ITEM miFiltrar /* Filtrar */
DO:
  apply "choose" to btFiltro in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if valid-handle(hboes121) then
        run destroy in hboes121.
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
        
    display brDisplay with frame fPage0.
    enable brDisplay btFiltro btOK btrec with frame fPage0.

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
    
/*     RUN setConstraint<Description> IN {&hDBOTable} (<pamameters>) NO-ERROR. */
/*     RUN openQueryStatic IN {&hDBOTable} (INPUT "<QueryName>":U) NO-ERROR. */


    IF NOT VALID-HANDLE(hboes121) OR
       hboes121:TYPE <> "PROCEDURE":U OR
       hboes121:FILE-NAME <> "esbo/boes121.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes121.p YES}
        {btb/btb008za.i2 esbo/boes121.p '' hboes121}
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

