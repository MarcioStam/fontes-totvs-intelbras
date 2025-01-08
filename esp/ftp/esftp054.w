&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttped-fiscal NO-UNDO LIKE ped-fiscal
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
{include/i-prgvrs.i ESFTP054 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esftp054
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Solic.NF

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         YES
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        ttped-fiscal
&GLOBAL-DEFINE hDBOTable      hBoes150
&GLOBAL-DEFINE DBOTable       ped-fiscal

&GLOBAL-DEFINE page0KeyFields ttped-fiscal.nr-pedido
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1KeyFields 
&GLOBAL-DEFINE page1Fields    ttped-fiscal.sc-codigo ttped-fiscal.motivo
&GLOBAL-DEFINE page2Fields    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

DEFINE VARIABLE c-email-usuario  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE  c-email-sup AS CHARACTER   NO-UNDO.
DEFINE VARIABLE  c-supervisor AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-aloca-estoque AS LOGICAL     NO-UNDO.
def var i-solicitacao as integer.


def temp-table tt-item
    field it-codigo    like item.it-codigo
    field nr-sequencia like it-ped-fiscal.seq.
                


DEF TEMP-TABLE tt-item-alocados
    FIELD cod-estabel AS CHARACTER
    FIELD it-codigo LIKE item.it-codigo
    FIELD cod-depos LIKE saldo-estoq.cod-depos
    FIELD cod-localiz LIKE saldo-estoq.cod-localiz
    FIELD quantidade  AS DECIMAL
    INDEX ch-principal it-codigo cod-depos cod-localiz.
DEFINE VARIABLE c-item AS CHARACTER   NO-UNDO.

def buffer b-it-ped-fiscal for it-ped-fiscal.
def buffer b-ped-fiscal for ped-fiscal.
def buffer b-wt-fat-ser-lote for wt-fat-ser-lote.

def var h-acomp      as handle no-undo.
{upc\btb910za-upc.i}

{utp/utapi019.i}

DEFINE VARIABLE c-natureza-auxiliar LIKE natureza-ped-fiscal.natureza NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttped-fiscal.nr-pedido 
&Scoped-define ENABLED-TABLES ttped-fiscal
&Scoped-define FIRST-ENABLED-TABLE ttped-fiscal
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave bt-aprovar bt-ajusta-alocacao btQueryJoins btReportsJoins btExit ~
btHelp 
&Scoped-Define DISPLAYED-FIELDS ttped-fiscal.nr-pedido 
&Scoped-define DISPLAYED-TABLES ttped-fiscal
&Scoped-define FIRST-DISPLAYED-TABLE ttped-fiscal


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
       MENU-ITEM miCopy         LABEL "&Copiar"       
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
DEFINE BUTTON bt-ajusta-alocacao 
     IMAGE-UP FILE "adeicon/dbdown.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Ajusta Alocaá∆o".

DEFINE BUTTON bt-aprovar 
     IMAGE-UP FILE "adeicon/dog.bmp":U
     LABEL "Button 1" 
     SIZE 4 BY 1.25 TOOLTIP "Aprovar Foráado".

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
     SIZE 90 BY 1.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE c-cliente AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE c-natureza AS CHARACTER FORMAT "X(256)":U 
     LABEL "Natureza de Operaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Situaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 5.5.


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
     bt-aprovar AT ROW 1.13 COL 59 HELP
          "Aprovar Pedido de Notas Fiscais" WIDGET-ID 4
     bt-ajusta-alocacao AT ROW 1.13 COL 63 HELP
          "Ajusta alocaá∆o do pedido" WIDGET-ID 6
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     ttped-fiscal.nr-pedido AT ROW 3 COL 38 COLON-ALIGNED WIDGET-ID 2
          LABEL "Pedido"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.25
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     ttped-fiscal.cod-estabel AT ROW 1.71 COL 25 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     c-situacao AT ROW 1.71 COL 52 COLON-ALIGNED WIDGET-ID 2
     c-cliente AT ROW 2.71 COL 25 COLON-ALIGNED WIDGET-ID 10
     c-natureza AT ROW 3.71 COL 25 COLON-ALIGNED WIDGET-ID 12
     ttped-fiscal.nr-nota-fis AT ROW 4.71 COL 25 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     ttped-fiscal.dt-emissao AT ROW 4.71 COL 57.29 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     ttped-fiscal.sc-codigo AT ROW 5.71 COL 25 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     ttped-fiscal.motivo AT ROW 7.38 COL 15.14 NO-LABEL WIDGET-ID 6
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 66 BY 5.75
     "Motivo Retorno:" VIEW-AS TEXT
          SIZE 11 BY .54 AT ROW 7.42 COL 3.72 WIDGET-ID 8
     RECT-4 AT ROW 1.42 COL 2.14 WIDGET-ID 20
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5.71
         SIZE 84.43 BY 12.75
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttped-fiscal T "?" NO-UNDO mgesp ped-fiscal
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
         HEIGHT             = 18.25
         WIDTH              = 90
         MAX-HEIGHT         = 27.5
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 27.5
         VIRTUAL-WIDTH      = 195.14
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
/* SETTINGS FOR FILL-IN ttped-fiscal.nr-pedido IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN c-cliente IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-natureza IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-situacao IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ttped-fiscal.cod-estabel IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ttped-fiscal.dt-emissao IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ttped-fiscal.nr-nota-fis IN FRAME fPage1
   NO-ENABLE                                                            */
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


&Scoped-define SELF-NAME bt-ajusta-alocacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajusta-alocacao wMaintenance
ON CHOOSE OF bt-ajusta-alocacao IN FRAME fpage0
DO:
    RUN utp/ut-msgs.p (INPUT "show":U, 
                       INPUT 27100, 
                       INPUT "Confirma Ajuste na Alocaá∆o?":U).
    if  RETURN-VALUE = "yes" then do:
        FIND FIRST mgesp.ped-fiscal NO-LOCK
            WHERE  mgesp.ped-fiscal.nr-pedido = ttped-fiscal.nr-pedido NO-ERROR.
        IF  AVAIL ped-fiscal THEN ASSIGN i-solicitacao  = ped-fiscal.nr-pedido.

        RUN pi-ajusta.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-aprovar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-aprovar wMaintenance
ON CHOOSE OF bt-aprovar IN FRAME fpage0 /* Button 1 */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:
    DEFINE VARIABLE c-motivo-email AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-email AS CHARACTER   NO-UNDO.

    IF ttped-fiscal.situacao <> 1 THEN DO:
        MESSAGE "Situaá∆o N∆o permite Aprovaá∆o"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN.
    END.
    IF ttped-fiscal.motivo:SCREEN-VALUE IN FRAME fpage1 = "" THEN DO:
        MESSAGE "Informe Motivo de aprovaá∆o foráada"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE DO:
    
        MESSAGE "Confirma Aprovaá∆o?" 
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                    TITLE "" UPDATE choice AS LOGICAL.
      CASE choice:
         WHEN TRUE THEN /* Yes */
          DO:
             FIND mgesp.ped-fiscal
                  WHERE mgesp.ped-fiscal.nr-pedido = ttped-fiscal.nr-pedido
                  EXCLUSIVE-LOCK NO-ERROR.
             ASSIGN mgesp.ped-fiscal.situacao = 2
                    mgesp.ped-fiscal.motivo = mgesp.ped-fiscal.motivo + " Usuar.Aprovou : " + v_cod_usuar_corren + " - Data: " + STRING(TODAY,"99/99/9999") + " Motivo: " + trim(ttped-fiscal.motivo:SCREEN-VALUE IN FRAME fpage1)
                    mgesp.ped-fiscal.dt-aprovacao = TODAY.
             
             ASSIGN c-motivo-email = ttped-fiscal.motivo:SCREEN-VALUE IN FRAME fpage1.
             RUN cancelRecord IN THIS-PROCEDURE.

             FIND FIRST emsfnd.usuar_mestre NO-LOCK
                         WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
             IF NOT AVAIL usuar_mestre THEN DO:
                 MESSAGE "Usuario nao encontrado, e-mail nao enviado " v_cod_usuar_corren
                     VIEW-AS ALERT-BOX INFO BUTTONS OK.
                 RETURN.
             END.

             ASSIGN c-email-usuario = usuar_mestre.cod_e_mail_local.

             FIND FIRST emsfnd.usuar_mestre NO-LOCK
                         WHERE usuar_mestre.cod_usuario = mgesp.ped-fiscal.usuario-magnus NO-ERROR.
             IF NOT AVAIL usuar_mestre THEN DO:
                 MESSAGE "Usuario nao encontrado, e-mail nao enviado " mgesp.ped-fiscal.usuario-magnus
                     VIEW-AS ALERT-BOX INFO BUTTONS OK.
                 RETURN.
             END.

             ASSIGN c-email = usuar_mestre.cod_e_mail_local.

             IF AVAIL usuar_mestre  THEN DO:
                  RUN BuscaSupervisor.
                  RUN piEnviaEmail (INPUT c-email-usuario,
                                    INPUT trim(c-email) + "," + c-email-sup,
                                    INPUT "Solicitaá∆o Aprovada por : " + v_cod_usuar_corren + STRING(mgesp.ped-fiscal.nr-pedido),
                                    INPUT c-motivo-email,
                                    INPUT "").
                        
             END.
             MESSAGE "Aprovaá∆o Efetuada, e-mail enviado para " c-email + "," + c-email-sup VIEW-AS ALERT-BOX.
                
             
          END.
          WHEN FALSE THEN /* No */
          DO:
             RETURN NO-APPLY.
          END.
         OTHERWISE /* Cancel */
             STOP.
         END CASE.
    END.
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
    IF ttped-fiscal.situacao = 3 and
       can-find(FIRST wt-docto WHERE wt-docto.seq-wt-docto = ttped-fiscal.seq-wt-docto) THEN DO:
        MESSAGE "Solicitaá∆o ja relacionado ao documento " string(ttped-fiscal.seq-wt-docto) skip
                "Para Excluir devera ser eliminado o documento no ft4003"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE 
        IF ttped-fiscal.situacao = 5 /* Atendido  */ OR
           ttped-fiscal.situacao = 6 /* Reprovado */ THEN DO:
            MESSAGE "Situaá∆o n∆o Permite Exclus∆o"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        ELSE DO:
            BLOCO:
            DO TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:
                if l-aloca-estoque then do:
                    for each mgesp.it-ped-fiscal
                        where mgesp.it-ped-fiscal.nr-pedido = ttped-fiscal.nr-pedido no-lock,
                        FIRST item 
                        WHERE ITEM.it-codigo = mgesp.it-ped-fiscal.it-codigo NO-LOCK:
                        
                        IF ITEM.tipo-contr <> 4 THEN DO:
                            find first saldo-estoq
                                where saldo-estoq.it-codigo      = mgesp.it-ped-fiscal.it-codigo
                                     and saldo-estoq.cod-estabel = v_cod_estab_usuar
                                     and saldo-estoq.cod-localiz = ""
                                     and saldo-estoq.cod-depos   = mgesp.it-ped-fiscal.cod-depos
                                     no-lock no-error.
                    
                             if avail saldo-estoq then do:
                                if saldo-estoq.qt-alocada < dec(it-ped-fiscal.qtde) then do:
                                   message "Quantidade Alocada " saldo-estoq.qt-alocada " Menor que Quantidade do item " mgesp.it-ped-fiscal.qtde " Item " mgesp.it-ped-fiscal.it-codigo " Deposito " mgesp.it-ped-fiscal.cod-depos view-as alert-box.
                                   UNDO BLOCO, LEAVE BLOCO.
                                end.
                                find current saldo-estoq exclusive-lock no-error.
                                assign saldo-estoq.qt-alocada = saldo-estoq.qt-alocada - mgesp.it-ped-fiscal.qtde.
                                release saldo-estoq.
                             end.
                             else do:
                                   message "Saldo em Estoque n∆o Encontrado para Item: " mgesp.it-ped-fiscal.it-codigo " Deposito: " mgesp.it-ped-fiscal.cod-depos view-as alert-box.
                                   UNDO BLOCO, LEAVE BLOCO.
                             end.
                        END.
                    END.
                END. 

                RUN deleteRecord IN THIS-PROCEDURE.
            END. /*do trans*/
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
OR  CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:

    DEFINE VARIABLE c-motivo-email AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-email AS CHARACTER   NO-UNDO.

    FIND mgesp.ped-fiscal
        WHERE mgesp.ped-fiscal.nr-pedido = ttped-fiscal.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
    IF  AVAIL ped-fiscal THEN
        ASSIGN mgesp.ped-fiscal.sc-codigo = ttped-fiscal.sc-codigo:SCREEN-VALUE IN FRAME fpage1.

    IF c-situacao:SCREEN-VALUE in frame fpage1 = "Atendido" THEN DO:
        RUN cancelRecord IN THIS-PROCEDURE.
    END.  /* IF c-situacao:SCREEN-VALUE in frame fpage1 = "Atendido" THEN DO: */
    ELSE DO:
        MESSAGE "Confirma Retorno para Solicitante?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "" UPDATE choice AS LOGICAL.
        CASE choice:
            WHEN TRUE THEN /* Yes */ DO:
                FIND mgesp.ped-fiscal
                    WHERE mgesp.ped-fiscal.nr-pedido = ttped-fiscal.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL ped-fiscal THEN
                    ASSIGN mgesp.ped-fiscal.situacao  = 0
                           mgesp.ped-fiscal.motivo    = mgesp.ped-fiscal.motivo + " Usuar.Retornou : " + v_cod_usuar_corren + " - Data: " + STRING(TODAY,"99/99/9999") + " Motivo: " + trim(ttped-fiscal.motivo:SCREEN-VALUE IN FRAME fpage1).

                IF  c-natureza-auxiliar <> ? 
                AND c-natureza-auxiliar <> 0 THEN 
                    ASSIGN mgesp.ped-fiscal.nat-oper = c-natureza-auxiliar.

                ASSIGN c-motivo-email = ttped-fiscal.motivo:SCREEN-VALUE IN FRAME fpage1.
                RUN cancelRecord IN THIS-PROCEDURE.

                FIND FIRST emsfnd.usuar_mestre NO-LOCK
                    WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
                IF  NOT AVAIL usuar_mestre THEN DO:
                    RUN utp/ut-msgs.p (INPUT 'show':U,
                                       INPUT 17006,
                                       INPUT 'Processo interrompido.' + '~~' + 'Usu†rio n∆o encontrado, e-mail n∆o enviado.' ).
                    RETURN.
                END.
                ELSE ASSIGN c-email-usuario = usuar_mestre.cod_e_mail_local.

                FIND FIRST emsfnd.usuar_mestre NO-LOCK
                    WHERE usuar_mestre.cod_usuario = mgesp.ped-fiscal.usuario-magnus NO-ERROR.
                IF  NOT AVAIL usuar_mestre THEN DO:
                    RUN utp/ut-msgs.p (INPUT 'show':U,
                                        INPUT 17006,
                                        INPUT 'Processo interrompido.' + '~~' + 'Usu†rio ' + STRING(mgesp.ped-fiscal.usuario-magnus) + ' n∆o encontrado, e-mail n∆o enviado.' ).
                    RETURN.
                END.
                ELSE ASSIGN c-email = usuar_mestre.cod_e_mail_local.

                IF  AVAIL usuar_mestre THEN DO:
                    RUN piEnviaEmail (INPUT c-email-usuario,
                                      INPUT c-email,
                                      INPUT "Solicitaá∆o Retornada para Correá∆o : " + STRING(mgesp.ped-fiscal.nr-pedido),
                                      INPUT c-motivo-email,
                                      INPUT "").

                END.
                RUN utp/ut-msgs.p (INPUT 'show':U,
                                   INPUT 15825,
                                   INPUT 'Retorno efetuado.' + '~~' + 'E-mail enviado para ' + c-email).
            END.
            WHEN FALSE THEN /* No */ DO:
                RUN cancelRecord IN THIS-PROCEDURE.
            END.
            OTHERWISE /* Cancel */ STOP.
        END CASE.
    END. /* IF c-situacao:SCREEN-VALUE in frame fpage1 <> "Atendido" THEN DO: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/ZoomReposition.i &ProgramZoom="eszoom/z01es150.w"}
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

/*     IF ttped-fiscal.situacao = 3 and                                                              */
/*        can-find(FIRST wt-docto WHERE wt-docto.seq-wt-docto = ttped-fiscal.seq-wt-docto) THEN DO:  */
/*         MESSAGE "Solicitaá∆o ja relacionado ao documento " string(ttped-fiscal.seq-wt-docto) skip */
/*                 "Para retornar devera ser eliminado o documento no ft4003"                        */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                    */
/*     END.                                                                                          */
/*     ELSE                                                                                          */

        IF (ttped-fiscal.situacao = 0                    OR
            ttped-fiscal.situacao = 5 /* Atendido    */  OR
            ttped-fiscal.situacao = 6 /* Reprovado */ )THEN DO:
            MESSAGE "Situaá∆o n∆o Permite retorno para Solicitante"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        ELSE DO: 
            IF (ttped-fiscal.situacao = 3 /* A Faturar   */)THEN DO:
                RUN updateRecord IN THIS-PROCEDURE.
                ASSIGN ttped-fiscal.dt-emissao:SENSITIVE IN FRAME fPage1 = NO 
                       ttped-fiscal.nr-nota-fis :SENSITIVE IN FRAME fPage1 = NO 
                       ttped-fiscal.motivo      :SENSITIVE IN FRAME fPage1 = YES.
            END.
            ELSE DO:
                ASSIGN bt-aprovar:SENSITIVE = YES.
                RUN updateRecord IN THIS-PROCEDURE.
            END.

        END.
            
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME c-natureza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-natureza wMaintenance
ON F5 OF c-natureza IN FRAME fPage1 /* Natureza de Operaá∆o */
DO:
    {method/zoomfields.i &ProgramZoom="eszoom/z01es741.w"
                         &FieldZoom1="natureza"
                         &FieldScreen1="c-natureza"
                         &Frame1="fpage1"
                         &enableImplant="NO"}  
                         

                         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-natureza wMaintenance
ON LEAVE OF c-natureza IN FRAME fPage1 /* Natureza de Operaá∆o */
DO:
    ASSIGN INPUT FRAME fPage1 c-natureza.

    FIND FIRST natureza-ped-fiscal NO-LOCK
        WHERE  natureza-ped-fiscal.natureza = int(c-natureza) NO-ERROR.
    IF  AVAIL  natureza-ped-fiscal THEN
        ASSIGN c-natureza-auxiliar = int(c-natureza)
               c-natureza          = c-natureza + " - " + natureza-ped-fiscal.descricao.

    DISP c-natureza WITH FRAME fpage1.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-natureza wMaintenance
ON MOUSE-SELECT-DBLCLICK OF c-natureza IN FRAME fPage1 /* Natureza de Operaá∆o */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttped-fiscal.sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-fiscal.sc-codigo wMaintenance
ON F5 OF ttped-fiscal.sc-codigo IN FRAME fPage1 /* Sub-Conta */
DO:
  
    FIND FIRST param-global NO-LOCK NO-ERROR.
    ASSIGN i-ep-codigo-usuario = param-global.empresa-prin
           l-implanta          = YES.

    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.

    run pi_zoom_ccusto in h_api_ccusto (INPUT "",
                                        INPUT "",
                                        INPUT "",
                                        INPUT today,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_titulo_ccusto,
                                        OUTPUT TABLE tt_log_erro).
    
    if v_cod_ccusto <> "" then
                ASSIGN ttped-fiscal.sc-codigo:SCREEN-VALUE IN FRAME fPage1 = v_cod_ccusto.
        
    if valid-handle(h_api_ccusto) then
                delete object h_api_ccusto.   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-fiscal.sc-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttped-fiscal.sc-codigo IN FRAME fPage1 /* Sub-Conta */
DO:
  
    APPLY 'f5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
    for first mgesp.ponto-programa
        where ponto-programa.nome-programa = "esftp012",
         EACH mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          and conteudo-programa.conteudo = "Sim":
        assign l-aloca-estoque = yes.
    end.
{maintenance/mainblock.i}

c-natureza:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage1.
ttped-fiscal.sc-codigo:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    ASSIGN c-natureza-auxiliar = 0.

    CASE ttped-fiscal.situacao:
        WHEN 0 THEN ASSIGN c-situacao:SCREEN-VALUE in frame fpage1 = "Digitado".
        WHEN 1 THEN ASSIGN c-situacao:SCREEN-VALUE in frame fpage1 = "A Liberar".
        WHEN 2 THEN ASSIGN c-situacao:SCREEN-VALUE in frame fpage1 = "A Relacionar".
        WHEN 3 THEN ASSIGN c-situacao:SCREEN-VALUE in frame fpage1 = "A Faturar".
        WHEN 4 THEN ASSIGN c-situacao:SCREEN-VALUE in frame fpage1 = "Atendido Parcialmente". 
        WHEN 5 THEN ASSIGN c-situacao:SCREEN-VALUE in frame fpage1 = "Atendido". 
        WHEN 6 THEN ASSIGN c-situacao:SCREEN-VALUE in frame fpage1 = "Reprovado".
    END CASE.


    FIND emitente
         WHERE emitente.cod-emitente = ttped-fiscal.cod-emitente NO-LOCK NO-ERROR.

    ASSIGN ttped-fiscal.nr-pedido:SCREEN-VALUE   IN FRAME fpage0 = string(ttped-fiscal.nr-pedido)
           ttped-fiscal.sc-codigo:SCREEN-VALUE   IN FRAME fpage1 = ttped-fiscal.sc-codigo
           c-cliente:SCREEN-VALUE                IN FRAME fpage1 = emitente.nome-emit
           ttped-fiscal.cod-estabel:SCREEN-VALUE IN FRAME fpage1 = ttped-fiscal.cod-estabel
           bt-aprovar:SENSITIVE                  IN FRAME fpage0 = FALSE
           bt-ajusta-alocacao:SENSITIVE          IN FRAME fpage0 = TRUE
           ttped-fiscal.dt-emissao:SCREEN-VALUE  IN FRAME fpage1 = ""
           ttped-fiscal.nr-nota-fis:SCREEN-VALUE IN FRAME fpage1 = "".     

    FIND FIRST natureza-ped-fiscal NO-LOCK
        WHERE  natureza-ped-fiscal.natureza = int(ttPed-fiscal.nat-oper) NO-ERROR.
    IF  AVAIL natureza-ped-fiscal 
    THEN ASSIGN c-natureza:SCREEN-VALUE IN FRAME fpage1 = STRING(natureza-ped-fiscal.natureza) + " - " + STRING(natureza-ped-fiscal.descricao).
    ELSE ASSIGN c-natureza:SCREEN-VALUE IN FRAME fpage1 = "".

    IF  ttped-fiscal.situacao = 5 /* Atendido */ THEN DO:
        FOR EACH  ped-fiscal NO-LOCK
            WHERE ped-fiscal.nr-pedido    = ttped-fiscal.nr-pedido  
              AND ped-fiscal.cod-emitente = ttped-fiscal.cod-emitente:
                                     
            FIND FIRST nota-fiscal NO-LOCK
                WHERE  nota-fiscal.cod-estabel = mgesp.ped-fiscal.cod-estabel    
                  AND  nota-fiscal.nr-nota-fis = mgesp.ped-fiscal.nr-nota-fis   
                  AND  nota-fiscal.serie       = mgesp.ped-fiscal.serie NO-ERROR.
            IF  AVAIL nota-fiscal THEN
                ASSIGN ttped-fiscal.dt-emissao:SCREEN-VALUE IN FRAME fpage1 = string(nota-fiscal.dt-emis-nota)
                       ttped-fiscal.nr-nota-fis:SCREEN-VALUE  IN FRAME fpage1 = nota-fiscal.nr-nota-fis.       
        END. /* FOR EACH  ped-fiscal NO-LOCK */
    END. /* IF  ttped-fiscal.situacao = 5 THEN DO: */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuscaSupervisor wMaintenance 
PROCEDURE BuscaSupervisor :
FIND FIRST mgesp.int-centro-custo NO-LOCK
        WHERE  int-centro-custo.cod-estabel = mgesp.ped-fiscal.cod-estabel
        AND    int-centro-custo.cc-codigo   = mgesp.ped-fiscal.sc-codigo NO-ERROR.

    IF  NOT AVAIL int-centro-custo THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 17006,
                           INPUT 'Centro de Custo n∆o encontrado.').
    END.
    ELSE DO:
        FIND FIRST usuar_mestre NO-LOCK
            WHERE  usuar_mestre.cod_usuario = int-centro-custo.cod_usuario NO-ERROR.
        IF  AVAIL usuar_mestre THEN DO:
            IF  usuar_mestre.cod_e_mail_local = "" THEN DO:
                RUN utp/ut-msgs.p (INPUT 'show':U,
                                   INPUT 17006,
                                   INPUT "E-mail do Supervisor " + string(int-centro-custo.cod_usuario) + " em branco.").
            END.
            ELSE ASSIGN c-email-sup  = usuar_mestre.cod_e_mail_local
                        c-supervisor = usuar_mestre.cod_usuario.
        END.
        ELSE DO:
            RUN utp/ut-msgs.p (INPUT 'show':U,
                               INPUT 17006,
                               INPUT "Supervisor n∆o cadastrado.").
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
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
    
    DEFINE VARIABLE i-nr-pedido LIKE {&ttTable}.nr-pedido NO-UNDO.
                               
    
    DEFINE FRAME fGoToRecord
        i-nr-pedido       AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 10 BY .88
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Ped Fiscal" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Ped_Fiscal"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-nr-pedido.
        
        RUN goToKey IN {&hDBOTable} (INPUT i-nr-pedido ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Ped-fiscal":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE i-nr-pedido btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
    Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF  NOT VALID-HANDLE({&hDBOTable}) 
    OR  {&hDBOTable}:TYPE <> "PROCEDURE":U 
    OR  {&hDBOTable}:FILE-NAME <> "<DBOProgram>":U THEN DO:
        {btb/btb008za.i1 esbo/boes150.p YES}
        {btb/btb008za.i2 esbo/boes150.p '' {&hDBOTable}}
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
      
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ajusta wMaintenance 
PROCEDURE pi-ajusta :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
run utp/ut-acomp.p persistent set h-acomp.  
RUN pi-inicializar in h-acomp (input "Ajustando...").

OUTPUT TO c:\temp\fat-ser-lote_todos.txt.

for each  b-ped-fiscal
    where b-ped-fiscal.nr-pedido = i-solicitacao no-lock:


    for each b-it-ped-fiscal where
             b-it-ped-fiscal.nr-pedido = b-ped-fiscal.nr-pedido no-lock:

        /*ignora itens controlados por lote*/
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo    = b-it-ped-fiscal.it-codigo
               AND ITEM.tipo-con-est = 3 NO-ERROR.

        IF AVAIL ITEM THEN
            NEXT.

        FOR EACH  ITEM NO-LOCK
            WHERE ITEM.it-codigo = b-it-ped-fiscal.it-codigo
            AND   ITEM.baixa-estoq = YES:
        
            RUN pi-acompanhar in h-acomp (input "Item " + ITEM.it-codigo ).
            
            PUT "" skip
                "Item " ITEM.it-codigo SKIP
                "" SKIP.
                        
            find tt-item NO-LOCK 
                where tt-item.it-codigo = item.it-codigo no-error.
            if  not avail tt-item then do:
                create tt-item.
                assign tt-item.it-codigo    = item.it-codigo.
            end.    
            else next.
                
            FOR EACH  saldo-estoq EXCLUSIVE-LOCK
                WHERE saldo-estoq.it-codigo = ITEM.it-codigo:
                ASSIGN saldo-estoq.qt-alocada = 0.
            END. /* FOR EACH  saldo-estoq */
        
            FOR EACH  it-pre-fat NO-LOCK
                WHERE it-pre-fat.it-codigo = ITEM.it-codigo,
                FIRST pre-fatur OF it-pre-fat NO-LOCK
                WHERE pre-fatur.cod-sit-pre = 1,
                EACH  it-dep-fat NO-LOCK
                WHERE it-dep-fat.nr-embarque  = it-pre-fat.nr-embarque  
                  AND it-dep-fat.nr-resumo    = it-pre-fat.nr-resumo    
                  AND it-dep-fat.nome-abrev   = it-pre-fat.nome-abrev   
                  AND it-dep-fat.nr-pedcli    = it-pre-fat.nr-pedcli    
                  AND it-dep-fat.cod-estabel  = pre-fatur.cod-estabel  
                  AND it-dep-fat.nr-sequencia = it-pre-fat.nr-sequencia 
                  AND it-dep-fat.it-codigo    = it-pre-fat.it-codigo    
                  AND it-dep-fat.cod-refer    = it-pre-fat.cod-refer    
                  AND it-dep-fat.nr-entrega   = it-pre-fat.nr-entrega:
        
                RUN pi-acompanhar in h-acomp (input "Pre-fatur " + ITEM.it-codigo ).
        
                PUT "Embarque " it-pre-fat.nr-embarque 
                    " Pedido " it-pre-fat.nr-pedcli
                    " Deposito " it-dep-fat.cod-depos
                    " Localizacao " it-dep-fat.cod-localiz
                    "qtde Alocada " it-pre-fat.qt-alocada SKIP. 
        
                RUN pi-atualiza-temp-table (INPUT pre-fatur.cod-estabel,
                                            INPUT it-pre-fat.it-codigo,
                                            INPUT it-dep-fat.cod-depos,
                                            INPUT it-dep-fat.cod-localiz,
                                            INPUT it-dep-fat.qt-alocada).
            END. /* FOR EACH  it-pre-fat NO-LOCK */
            
            FOR EACH  wt-fat-ser-lote no-LOCK
                WHERE wt-fat-ser-lote.it-codigo = ITEM.it-codigo,
                FIRST wt-docto OF wt-fat-ser-lote NO-LOCK
                WHERE wt-docto.nr-pedcli = "":
        
                RUN pi-acompanhar in h-acomp (input "wt-fat-ser-lote " + ITEM.it-codigo ).
        
                PUT  "FAT-SER-LOTE Nota Fiscal " wt-fat-ser-lote.seq-wt-docto
                     " Deposito " wt-fat-ser-lote.cod-depos
                     " Quantidade " wt-fat-ser-lote.quantidade[1] SKIP.
                find b-wt-fat-ser-lote exclusive-lock 
                    where rowid(b-wt-fat-ser-lote) = rowid(wt-fat-ser-lote) no-error.    
                ASSIGN b-wt-fat-ser-lote.log-1 = YES.
                release b-wt-fat-ser-lote.

                RUN pi-atualiza-temp-table (INPUT wt-docto.cod-estabel,
                                            INPUT wt-fat-ser-lote.it-codigo,
                                            INPUT wt-fat-ser-lote.cod-depos,
                                            INPUT wt-fat-ser-lote.cod-localiz,
                                            INPUT wt-fat-ser-lote.quantidade[1]).
            END. /* FOR EACH  wt-fat-ser-lote no-LOCK */
        
            FOR EACH  fat-ser-lote EXCLUSIVE-LOCK
                WHERE fat-ser-lote.it-codigo = ITEM.it-codigo,
                FIRST nota-fiscal OF fat-ser-lote NO-LOCK
                WHERE nota-fiscal.dt-confirma = ?
                AND   nota-fiscal.dt-cancel   = ?:
        
                RUN pi-acompanhar in h-acomp (input "fat-ser-lote " + ITEM.it-codigo ).
        
                PUT  "FAT-SER-LOTE Nota Fiscal " fat-ser-lote.nr-nota-fis
                                  " Dt Emissao " nota-fiscal.dt-emis-nota
                                    " Deposito " fat-ser-lote.cod-depos
                                      " Pedido " nota-fiscal.nr-pedcli     FORMAT "x(7)"
                                    " qt Baixa " fat-ser-lote.qt-baixada[1] SKIP.
                    
                ASSIGN fat-ser-lote.log-1 = YES.
                RUN pi-atualiza-temp-table (INPUT nota-fiscal.cod-estabel,
                                            INPUT fat-ser-lote.it-codigo,
                                            INPUT fat-ser-lote.cod-depos,
                                            INPUT fat-ser-lote.cod-localiz,
                                            INPUT fat-ser-lote.qt-baixada[1]).
            END. /* FOR EACH  fat-ser-lote EXCLUSIVE-LOCK */
            
            FOR EACH  mgesp.it-ped-fiscal NO-LOCK
                WHERE it-ped-fiscal.it-codigo = ITEM.it-codigo:
                
                RUN pi-acompanhar in h-acomp (input "it-ped-fiscal " + ITEM.it-codigo ).

                FIND mgesp.ped-fiscal
                    WHERE ped-fiscal.nr-pedido = it-ped-fiscal.nr-pedido NO-LOCK NO-ERROR.
                
                RUN pi-atualiza-temp-table (INPUT ped-fiscal.cod-estabel,
                                            INPUT it-ped-fiscal.it-codigo,
                                            INPUT it-ped-fiscal.cod-depos,
                                            INPUT it-ped-fiscal.cod-localiz,
                                            INPUT 0).
        
                IF  ped-fiscal.situacao < 5  THEN DO:
                    put " Ped fiscal " ped-fiscal.cod-estabel
                        " IT-PED-FISCAL " it-ped-fiscal.nr-pedido 
                        " Data Emissao " ped-fiscal.dt-emissao 
                        " Deposito " it-ped-fiscal.cod-depos
                        " Quandidade  " it-ped-fiscal.qtde SKIP.
        
                    RUN pi-atualiza-temp-table (INPUT ped-fiscal.cod-estabel,
                                                INPUT it-ped-fiscal.it-codigo,
                                                INPUT it-ped-fiscal.cod-depos,
                                                INPUT it-ped-fiscal.cod-localiz,
                                                INPUT it-ped-fiscal.qtde).
                END. /* IF  ped-fiscal.situacao < 5  THEN DO: */
            END. /* FOR EACH  mgesp.it-ped-fiscal NO-LOCK */
        END. /* FOR EACH  ITEM NO-LOCK */
    END. /* for each b-it-ped-fiscal where */
end. /* for each  b-ped-fiscal */

PUT SKIP 
    "ITEM             ESTABEL  DEP LOCAL                QUANTIDADE                      QTDE ATU  QT ALOC PED   QT ALOCADA      QTDE" SKIP
    "---------------- -------- --- ------------------- -----------             ----------------- ------------ ------------ ---------" SKIP.

FOR EACH tt-item-alocados:
    for each  saldo-estoq EXCLUSIVE-LOCK
        where saldo-estoq.it-codigo   = tt-item-alocados.it-codigo
        and   saldo-estoq.cod-estabel = tt-item-alocados.cod-estabel
        and   saldo-estoq.cod-depos   = tt-item-alocados.cod-depos
        and   saldo-estoq.cod-local   = tt-item-alocados.cod-localiz:

        RUN pi-acompanhar in h-acomp (input "Atualizando Quantidade Alocada  " + saldo-estoq.it-codigo ).

        put tt-item-alocados.it-codigo " " tt-item-alocados.cod-estabel " " tt-item-alocados.cod-depos " " tt-item-alocados.cod-localiz
            " " tt-item-alocados.quantidade 
            " SALDO-ESTOQ " saldo-estoq.qtidade-atu  saldo-estoq.qt-aloc-ped saldo-estoq.qt-alocada 
            tt-item-alocados.quantidade SKIP.

        ASSIGN saldo-estoq.qt-alocada = tt-item-alocados.quantidade.
    end. /* for each  saldo-estoq EXCLUSIVE-LOCK */
END.

RELEASE saldo-estoq.

OUTPUT CLOSE.
DOS SILENT NOTEPAD c:\temp\fat-ser-lote_todos.txt.

RUN pi-finalizar in h-acomp.





END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-temp-table wMaintenance 
PROCEDURE pi-atualiza-temp-table :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER c-cod-estabel AS   CHARACTER                 NO-UNDO.
    DEF INPUT PARAMETER c-it-codigo   LIKE it-ped-fiscal.it-codigo   NO-UNDO.
    DEF INPUT PARAMETER c-cod-depos   LIKE it-ped-fiscal.cod-depos   NO-UNDO.
    DEF INPUT PARAMETER c-cod-localiz LIKE it-ped-fiscal.cod-localiz NO-UNDO.
    DEF INPUT PARAMETER de-qtde       LIKE it-ped-fiscal.qtde        NO-UNDO.

    FIND ITEM
        WHERE ITEM.it-codigo = c-it-codigo NO-LOCK NO-ERROR.
    IF ITEM.tipo-contr <> 4 AND
       ITEM.baixa-estoq = YES THEN DO:
    

        FIND tt-item-alocados
            WHERE tt-item-alocados.cod-estabel = c-cod-estabel
              AND tt-item-alocados.it-codigo   = c-it-codigo
              AND tt-item-alocados.cod-depos   = c-cod-depos
              AND tt-item-alocados.cod-localiz = c-cod-localiz
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL tt-item-alocados THEN DO:
            CREATE tt-item-alocados.
            assign tt-item-alocados.cod-estabel = c-cod-estabel
                   tt-item-alocados.it-codigo   = c-it-codigo
                   tt-item-alocados.cod-depos   = c-cod-depos
                   tt-item-alocados.cod-localiz = c-cod-localiz.
    
        END.
        ASSIGN tt-item-alocados.quantidade  = tt-item-alocados.quantidade + de-qtde.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEnviaEmail wMaintenance 
PROCEDURE piEnviaEmail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.

    DEFINE VARIABLE c-lst-arq AS CHARACTER  NO-UNDO.
    
    DEF VAR icont AS INT. 
    FOR FIRST param-global NO-LOCK:
    END.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.
    FOR EACH tt-envio2.   DELETE tt-envio2.   END.
    FOR EACH tt-mensagem. DELETE tt-mensagem. END.
    
    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
           tt-envio2.destino           = pDestino     /* Destinat†rio       */ 
           tt-envio2.remetente         = premetente        /* Remetente          */ 
           tt-envio2.assunto           = pAssunto          /* Assunto            */
           tt-envio2.arq-anexo         = pArquivo              /* Arquivo Tempor†rio */
           tt-envio2.formato           = "TEXTO".
    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = pDescEmail + CHR(13). /* Mensagem           */

    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).
    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF AVAIL tt-erros THEN
       OUTPUT TO erros-comerc.LOG APPEND.
    FOR EACH tt-erros:
        DISP tt-erros.cod-erro
             tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
    END.
    OUTPUT CLOSE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

