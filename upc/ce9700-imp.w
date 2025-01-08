&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i CE9700-IMP 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        CE9700-IMP
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel cInputFile btInputFile text-entrada text-ex
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   




/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.
DEFINE VARIABLE hDBOsc076 AS HANDLE      NO-UNDO.
/* DEFINE INPUT PARAM p-wgh-object AS HANDLE.     */
/* DEFINE INPUT PARAM p-row-table  AS ROWID.      */
/* DEFINE INPUT PARAM wh-brSon1-ce9700 AS HANDLE. */

DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-depos-entr-ce9700   AS WIDGET-HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-depos-saida-ce9700  AS WIDGET-HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-num-docto-transf-ce9700 AS WIDGET-HANDLE           NO-UNDO.

&GLOBAL-DEFINE ROW-NUM-DEFINED YES

DEFINE TEMP-TABLE tt-item-docto-transf-depos NO-UNDO LIKE item-docto-transf-depos
&IF "{&ROW-NUM-DEFINED}":U = "YES":U &THEN
    FIELD RowNum AS INTEGER INIT 1
&ENDIF
    FIELD r-Rowid AS ROWID.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-12 btInputFile cInputFile ~
btOK btCancel text-ex 
&Scoped-Define DISPLAYED-OBJECTS cInputFile text-ex 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btInputFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE cInputFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 72 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE text-entrada AS CHARACTER FORMAT "X(256)":U INITIAL "Arquivo de Entrada (CSV)" 
      VIEW-AS TEXT 
     SIZE 18 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-ex AS CHARACTER FORMAT "X(256)":U INITIAL "Ex: <item>~;<lote>~;<dt.validade>~;<quantid.>" 
      VIEW-AS TEXT 
     SIZE 73 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 3.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 85 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btInputFile AT ROW 2 COL 81 HELP
          "Escolha do nome do arquivo" WIDGET-ID 2
     cInputFile AT ROW 2.13 COL 8 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL WIDGET-ID 4
     btOK AT ROW 4.96 COL 2
     btCancel AT ROW 4.96 COL 13
     text-entrada AT ROW 1.25 COL 9 NO-LABEL WIDGET-ID 8
     text-ex AT ROW 3.25 COL 7 COLON-ALIGNED NO-LABEL
     rtToolBar AT ROW 4.75 COL 1
     RECT-12 AT ROW 1.5 COL 7 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85.72 BY 5.29
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 5.92
         WIDTH              = 86.43
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 111.86
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 111.86
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN text-entrada IN FRAME fpage0
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-entrada:PRIVATE-DATA IN FRAME fpage0     = 
                "Arquivo de Entrada (CSV)".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

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

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
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


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btInputFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInputFile wWindow
ON CHOOSE OF btInputFile IN FRAME fpage0
DO:
    def var c-arq-conv  as char            no-undo.
    def var l-ok        as logical init NO no-undo.

    assign cInputFile = replace(input frame fPage0 cInputFile, "/", "\").

    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.csv" "*.csv",
               "*.*" "*.*"
       DEFAULT-EXTENSION "*.*"
       INITIAL-DIR "spool" 
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok.

    if  l-ok = yes then do:
        assign cInputFile = replace(c-arq-conv, "\", "/"). 
        display cInputFile with frame fPage0.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    ASSIGN INPUT FRAME fPage0 cInputFile.

    IF SEARCH(cInputFile) = ? THEN
        MESSAGE "Arquivo inexistente!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
    ELSE DO:
        RUN pi-importa.
        
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa wWindow 
PROCEDURE pi-importa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-linha AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-erro  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v-data-valid AS DATE        NO-UNDO.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Importando..").

IF NOT VALID-HANDLE(hDBOsc076) THEN
    RUN scbo/bosc076.p PERSISTENT SET hDBOsc076.

RUN openQueryStatic IN hDBOsc076 (INPUT "Main":U).

INPUT FROM VALUE(cInputFile) CONVERT SOURCE "iso8859-1".
OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + 'ce9700-erros' + ".tmp").

ASSIGN l-erro = NO.

blk_import:
DO TRANS ON ERROR UNDO blk_import, LEAVE blk_import:
    REPEAT:
        IMPORT UNFORMATTED c-linha.
    
        RUN pi-acompanhar IN h-acomp (INPUT "Item C¢digo: " + STRING(ENTRY(1,c-linha,";"))).
    
        FIND FIRST ITEM NO-LOCK 
             WHERE ITEM.it-codigo = ENTRY(1,c-linha,";") NO-ERROR.
    
        IF NOT AVAIL ITEM THEN
            NEXT.
    
        IF CAN-FIND(FIRST item-docto-transf-depos
                    WHERE item-docto-transf-depos.num-docto-transf = int(wh-num-docto-transf-ce9700:SCREEN-VALUE)
                      AND item-docto-transf-depos.cod-item         = ENTRY(1,c-linha,";")              
                      AND item-docto-transf-depos.cod-refer        = ""
                      AND item-docto-transf-depos.cod-lote         = ENTRY(2,c-linha,";")) THEN DO:
            NEXT.
        END.  

        RUN emptyRowErrors IN hDBOsc076.
        
        EMPTY TEMP-TABLE tt-item-docto-transf-depos.
    
        FIND LAST item-docto-transf-depos NO-LOCK
            WHERE item-docto-transf-depos.num-docto-transf = int(wh-num-docto-transf-ce9700:SCREEN-VALUE) NO-ERROR.
        
        CREATE tt-item-docto-transf-depos.
        ASSIGN tt-item-docto-transf-depos.cod-item         = ENTRY(1,c-linha,";") 
               tt-item-docto-transf-depos.cod-localiz-sai  = ""
               tt-item-docto-transf-depos.cod-localiz-ent  = ""
               tt-item-docto-transf-depos.cod-lote         = ENTRY(2,c-linha,";")
               tt-item-docto-transf-depos.cod-refer        = ""
               tt-item-docto-transf-depos.idi-sit-docto    = 1
               tt-item-docto-transf-depos.num-docto-transf = int(wh-num-docto-transf-ce9700:SCREEN-VALUE)
               tt-item-docto-transf-depos.num-seq          = IF AVAIL item-docto-transf-depos THEN item-docto-transf-depos.num-seq + 10 ELSE 10
               tt-item-docto-transf-depos.qtd-atual-item   = 0
               tt-item-docto-transf-depos.qtd-item         = DEC(ENTRY(4,c-linha,";")).
        
        ASSIGN v-data-valid = DATE(ENTRY(3,c-linha,";")) NO-ERROR.
        IF NOT ERROR-STATUS:ERROR
           THEN ASSIGN tt-item-docto-transf-depos.dat-livre-1 = v-data-valid.
        
        FIND FIRST item NO-LOCK 
             WHERE item.it-codigo = tt-item-docto-transf-depos.cod-item NO-ERROR.
        
        RUN setRecord    IN hDBOsc076 (INPUT TABLE tt-item-docto-transf-depos).
        RUN createRecord IN hDBOsc076.
        
        IF RETURN-VALUE <> "OK":U THEN DO:
            RUN getRowErrors IN hDBOsc076 (OUTPUT TABLE RowErrors).
    
            FOR EACH RowErrors:
                PUT UNFORMATTED RowErrors.errordescription SKIP.
                ASSIGN l-erro = YES.
            END.
        END.
    END.

    IF l-erro THEN DO:
        DOS SILENT START NOTEPAD VALUE(SESSION:TEMP-DIRECTORY + 'ce9700-erros' + ".tmp").
        UNDO blk_import.
    END.
END.

DELETE PROCEDURE hDBOsc076.

RUN pi-finalizar IN h-acomp.
INPUT CLOSE.
OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

