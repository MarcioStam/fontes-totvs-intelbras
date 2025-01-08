&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttint-nota-fiscal NO-UNDO LIKE int-nota-fiscal
       FIELD r-rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esftp042 2.01.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esftp042
&GLOBAL-DEFINE Version        2.01.00.001

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   PIN

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            no
&GLOBAL-DEFINE Copy           no
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         no
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ExcludeBtQueryJoins           YES
&GLOBAL-DEFINE ExcludeBtReportsJoins         YES
&GLOBAL-DEFINE ExcludeBtHelp                 YES


&GLOBAL-DEFINE ttTable        ttint-nota-fiscal
&GLOBAL-DEFINE hDBOTable      h-boes360
&GLOBAL-DEFINE DBOTable       int-nota-fiscal

&GLOBAL-DEFINE page0KeyFields ttint-nota-fiscal.cod-estabel ttint-nota-fiscal.serie ttint-nota-fiscal.nr-nota-fis  
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    ttint-nota-fiscal.nr-pin 
&GLOBAL-DEFINE page2Fields    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE h-boes360 AS HANDLE NO-UNDO.
def var c-email as char format "x(50)".

DEFINE VAR c-arquivo AS CHAR   NO-UNDO.
DEFINE VAR l-ok      AS LOG    NO-UNDO.
DEFINE VAR h-acomp   AS HANDLE NO-UNDO.
DEFINE VAR c-linha   AS CHAR   NO-UNDO.
DEFINE VAR h-open    AS HANDLE NO-UNDO.
DEFINE VAR i-nota    AS INT    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttint-nota-fiscal.cod-estabel ~
ttint-nota-fiscal.serie ttint-nota-fiscal.nr-nota-fis 
&Scoped-define ENABLED-TABLES ttint-nota-fiscal
&Scoped-define FIRST-ENABLED-TABLE ttint-nota-fiscal
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btFirst btPrev btNext ~
btLast btGoTo btSearch btUpdate btUndo btCancel btSave btExit bt-importa ~
BtHelp 
&Scoped-Define DISPLAYED-FIELDS ttint-nota-fiscal.cod-estabel ~
ttint-nota-fiscal.serie ttint-nota-fiscal.nr-nota-fis 
&Scoped-define DISPLAYED-TABLES ttint-nota-fiscal
&Scoped-define FIRST-DISPLAYED-TABLE ttint-nota-fiscal


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
DEFINE BUTTON bt-importa 
     IMAGE-UP FILE "image/excel.jpg":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Atualizar PIN".

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\im-can":U
     LABEL "Cancel" 
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

DEFINE BUTTON BtHelp 
     IMAGE-UP FILE "image/im-hel.bmp":U
     LABEL "Button 2" 
     SIZE 4 BY 1.13.

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
     SIZE 90 BY 3.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-suframa 
     IMAGE-UP FILE "image/ii-mens.bmp":U
     LABEL "Reenvia E-mail arquivo PIN" 
     SIZE 6 BY 1.13 TOOLTIP "Reenvia E-mail arquivo PIN".


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
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrància corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz alteraá‰es"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela alteraá‰es"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma alteraá‰es"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     bt-importa AT ROW 1.17 COL 62 WIDGET-ID 14
     BtHelp AT ROW 1.25 COL 87 WIDGET-ID 10
     ttint-nota-fiscal.cod-estabel AT ROW 3 COL 30 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 6 BY .79
     ttint-nota-fiscal.serie AT ROW 4 COL 30 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 6 BY .79
     ttint-nota-fiscal.nr-nota-fis AT ROW 5 COL 30 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 13 BY .79
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     bt-suframa AT ROW 3.75 COL 55 RIGHT-ALIGNED WIDGET-ID 14
     ttint-nota-fiscal.nr-pin AT ROW 4 COL 24 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 12 BY .79
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 8 ROW 7.5
         SIZE 77 BY 8.75
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttint-nota-fiscal T "?" NO-UNDO mgesp int-nota-fiscal
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
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
         HEIGHT             = 17
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR BUTTON bt-suframa IN FRAME fPage1
   ALIGN-R                                                              */
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


&Scoped-define SELF-NAME bt-importa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importa wMaintenance
ON CHOOSE OF bt-importa IN FRAME fpage0
DO:
    RUN esp/ftp/esftp042b.w (OUTPUT c-arquivo,
                             OUTPUT l-ok).

    IF l-ok AND SEARCH(c-arquivo) <> ? THEN DO:
        RUN pi-importa.

        MESSAGE "Importaáao finalizada"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-suframa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-suframa wMaintenance
ON CHOOSE OF bt-suframa IN FRAME fPage1 /* Reenvia E-mail arquivo PIN */
DO:
    find nota-fiscal
         where nota-fiscal.cod-estabel = input frame fPage0 ttint-nota-fiscal.cod-estabel
           and nota-fiscal.serie       = input frame fpage0 ttint-nota-fiscal.serie
           and nota-fiscal.nr-nota-fis = input frame fpage0 ttint-nota-fiscal.nr-nota-fis
           no-lock no-error.
    if avail nota-fiscal then do: 
       find natur-oper
            where natur-oper.nat-operacao = nota-fiscal.nat-operacao 
            no-lock no-error.
          if avail natur-oper and
             natur-oper.tipo = 2 then do:
             find emitente
                  where emitente.cod-emitente = nota-fiscal.cod-emitente no-lock no-error.
             if avail emitente and
                emitente.cod-suframa <> "" then do:   
                run esp/ftp/esftp042rp (input nota-fiscal.cod-estabel,
                                        input nota-fiscal.serie,
                                        input nota-fiscal.nr-nota-fis).  
                
                if nota-fiscal.cod-estabel = "102" then
                    assign c-email = "renee.severino@intelbras.com.br,adrianaw@intelbras.com.br,claudia.wedel@intelbras.com.br".
                else
                    if nota-fiscal.cod-estabel = "301" OR 
                        nota-fiscal.cod-estabel = "103" then
                        assign c-email = "analucia@maxcom.ind.br".                             
                    else 
                        IF nota-fiscal.nr-pedcli <> "" THEN DO:
                            FIND ped-venda
                                 WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli
                                   AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                                 NO-LOCK no-error.
                            IF avail ped-venda THEN do:                                
                               FIND atendente WHERE atendente.cd-oper = int(ped-venda.tp-pedido)
                                    NO-LOCK NO-ERROR.
                               IF AVAIL atendente THEN DO:                                   
                                  assign c-email = atendente.email.
                               END.
                               ELSE DO:
                                    assign c-email = "anderson.cenci@intelbras.com.br".
                               END.
                            END.
                            ELSE DO:
                                 assign c-email = "anderson.cenci@intelbras.com.br".
                            END.
                        END.
                        ELSE DO:
                            for each cli-dif no-lock
                                where cli-dif.cod-emitente = nota-fiscal.cod-emitente:             
                                assign c-email = c-email + cli-dif.e-mail + ",".
                            end.
    
                        END.
                    
                /*message "Email enviado" view-as alert-box.*/
             end.                           
             else do:
                    message "Cliente sem C¢digo de Suframa " emitente.cod-emitente skip emitente.nome-emit view-as alert-box.
             end.
         end.
         else do:
               message "Natureza de  Operaá∆o inexistente ou n∆o Ç uma Nota de Saida" view-as alert-box.
         end.
    END.
    else do:
                  RUN utp/ut-msgs.p (INPUT "show":U,
                                     INPUT 2,
                                     INPUT "Nota Fiscal").  
    end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN cancelRecord IN THIS-PROCEDURE.
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

    {method/ZoomReposition.i &ProgramZoom="eszoom/z01es360.w"}
    
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


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/mainblock.i}
enable bt-importa with frame fpage0.

ENABLE bt-suframa WITH FRAME fpage1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
    
    DEFINE VARIABLE c-cod-estabel  LIKE ttint-nota-fiscal.cod-estabel NO-UNDO.
    DEFINE VARIABLE c-serie        LIKE ttint-nota-fiscal.serie       NO-UNDO.
    DEFINE VARIABLE c-nr-nota-fis  LIKE ttint-nota-fiscal.nr-nota-fis NO-UNDO.
    DEFINE FRAME fGoToRecord
        c-cod-estabel format "x(05)" AT ROW 1.21 COL 17.72  COLON-ALIGNED
        c-serie       format "x(05)" AT ROW 2.21 COL 17.72  COLON-ALIGNED
        c-nr-nota-fis format "x(09)" AT ROW 3.21 COL 17.72 COLON-ALIGNED        
        btGoToOK          AT ROW 4.63 COL 2.14
        btGoToCancel      AT ROW 4.63 COL 13
        rtGoToButton      AT ROW 4.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Extens∆o da Nota Fiscal" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V† Para Extens∆o da Nota Fiscal"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-cod-estabel c-serie c-nr-nota-fis.
        FIND nota-fiscal
             WHERE nota-fiscal.cod-estabel = c-cod-estabel
               AND nota-fiscal.serie = c-serie
               AND nota-fiscal.nr-nota-fis = c-nr-nota-fis
             NO-LOCK NO-ERROR.
        
        IF NOT AVAIL nota-fiscal  THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "nota-fiscal":U).
            RETURN NO-APPLY.

        END.
        ELSE DO:
            
            RUN goToKey IN {&hDBOTable} (INPUT c-cod-estabel , INPUT c-serie, input c-nr-nota-fis ).
            
            IF RETURN-VALUE = "NOK":U THEN DO:
                CREATE int-nota-fiscal.
                ASSIGN int-nota-fiscal.cod-estabel = c-cod-estabel
                       int-nota-fiscal.serie       = c-serie
                       int-nota-fiscal.nr-nota-fis = c-nr-nota-fis.
                RELEASE int-nota-fiscal.
                RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
                RUN goToKey IN {&hDBOTable} (INPUT c-cod-estabel , INPUT c-serie, input c-nr-nota-fis ).
                
            END.
        END.
        

        
        /*:T Retorna rowid do registro corrente do DBO */
        
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-cod-estabel c-serie c-nr-nota-fis btGoToOK btGoToCancel 
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
       {&hDBOTable}:FILE-NAME <> "boes360.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes360.p YES}
        {btb/btb008za.i2 esbo/boes360.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa wMaintenance 
PROCEDURE pi-importa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo..").

    INPUT FROM VALUE(c-arquivo) CONVERT SOURCE "iso8859-1".
        OUTPUT TO "C:\temp\log_esftp042.log".
     
        REPEAT TRANSACTION:
            IMPORT UNFORMATTED c-linha.
     
            RUN pi-acompanhar IN h-acomp (INPUT "Nota" + STRING(ENTRY(3,c-linha,";"))).
     
            ASSIGN i-nota = int(ENTRY(3,c-linha,";")).
     
            FIND FIRST nota-fiscal NO-LOCK
                 WHERE nota-fiscal.cod-estabel = ENTRY(1,c-linha,";")
                   AND nota-fiscal.serie       = ENTRY(2,c-linha,";")
                   AND nota-fiscal.nr-nota-fis = string(i-nota,"9999999") NO-ERROR.
            IF NOT AVAIL nota-fiscal THEN DO:
                PUT "Nota nao encontrada. " ENTRY(3,c-linha,";") + " " + ENTRY(2,c-linha,";") + " " + ENTRY(1,c-linha,";") FORMAT "x(40)" SKIP.
            END.
            ELSE DO:
                FIND FIRST int-nota-fiscal EXCLUSIVE-LOCK
                     WHERE int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                       AND int-nota-fiscal.serie       = nota-fiscal.serie
                       AND int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
                IF AVAIL int-nota-fiscal THEN DO:
                    IF int-nota-fiscal.nr-pin <> int(ENTRY(4,c-linha,";")) THEN DO:
                        ASSIGN int-nota-fiscal.nr-pin = int(ENTRY(4,c-linha,";")).
                        PUT "PIN atualizado " +  string(i-nota,"9999999") + " " + ENTRY(2,c-linha,";") + " " + ENTRY(1,c-linha,";") + " " + STRING(ENTRY(4,c-linha,";")) FORMAT "x(40)" SKIP.
                    END.
                    ELSE
                        PUT "Nota " + string(i-nota,"9999999") + " com o mesmo numero de PIN do arquivo" FORMAT "x(60)" SKIP.
                END.
            END.
        END.
        OUTPUT CLOSE.
            
   RUN pi-finalizar IN h-acomp.     
   INPUT CLOSE.
   
   
   RUN utp/ut-utils.p PERSISTENT SET h-open.
   RUN Execute IN h-open(INPUT "C:\temp\log_esftp042.log",
                         INPUT "").
   DELETE PROCEDURE h-open.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

