&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/***********************************************************************
**  Programa..: DP0301-UPCW
**  Autor.....: Nicolas Martinez
**  Data......: Setembro/2021 - Desenvolvimento
**  Descricao.: Importa estrutura DP
**  Versao....: 001 20/09/2021
**                  Desenvolvimento Programa
************************************************************************/
{include/i-prgvrs.i DP0301-UPCW 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        DP0301-UPCW
&GLOBAL-DEFINE Version        000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         no
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 c-item-dp i-num-proces-item c-desc-item c-descricao c-arq-imp e-formato bt-importacao rd-opcao


/* Parameters Definitions ---                                           */
{include/i-vrtab.i dp-proces-item}
{esp/es0018.i}
/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h_q01mf613 AS HANDLE NO-UNDO.

DEF STREAM s-import.
DEF var h-acomp      as handle no-undo.

DEF VAR c-position   AS CHAR NO-UNDO EXTENT 8.
DEF VAR i-seq        AS INTE NO-UNDO.
def var c-letra      as CHAR NO-UNDO.
DEF VAR c-letra-controle AS CHAR.
def var c-parte         as char.
def var c-parte1        as char.
def var c-pos           as char.
def var c-pos-ant       as char.
def var c-pos-inc       as char.
def var c-pos-inc-tt    as char.
def var l-fechou        as log.
def var l-erro          as log.
def var c-pos-ini       as char format "x(15)".
def var c-pos-fim       as char format "x(15)".

DEF TEMP-TABLE tt-dp-estrut NO-UNDO LIKE dp-estrut.
DEF BUFFER b-tt-dp-estrut FOR tt-dp-estrut.

/* Local Variable Definitions ---                                       */
def temp-table tt-pos
    field letra    as char format "X(15)"     
    field ord      as dec
    field pos      as char format "x(15)"  
    index tt-pos is primary unique 
          letra 
          ord
    index ordem 
          letra
          pos.

def temp-table tt-string
    field letra    as char
    field pos      as char
    index formato 
          letra.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-1 RECT-2 RECT-3 ~
btQueryJoins btReportsJoins btExit btHelp c-item-dp c-desc-item ~
i-num-proces-item c-descricao bt-importacao c-arq-imp rd-opcao e-formato ~
btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS c-item-dp c-desc-item i-num-proces-item ~
c-descricao c-arq-imp rd-opcao e-formato 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-importacao 
     IMAGE-UP FILE "image/im-sea1.bmp":U
     LABEL "" 
     SIZE 3.86 BY 1.08 TOOLTIP "Localiza Arquivo".

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

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

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
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

DEFINE VARIABLE e-formato AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 87.43 BY 2.25 NO-UNDO.

DEFINE VARIABLE c-arq-imp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 64.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-dp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-proces-item AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     LABEL "Vers∆o" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE rd-opcao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Sobrepor Estrutura", 1,
"Acrescentar Estrutura", 2
     SIZE 55 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.54.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.54.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.96.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


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
     c-item-dp AT ROW 3 COL 13.43 COLON-ALIGNED WIDGET-ID 4
     c-desc-item AT ROW 3 COL 25.57 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     i-num-proces-item AT ROW 4.04 COL 13.43 COLON-ALIGNED WIDGET-ID 6
     c-descricao AT ROW 4.04 COL 25.57 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     bt-importacao AT ROW 5.63 COL 80 HELP
          "Localiza Arquivo" WIDGET-ID 24
     c-arq-imp AT ROW 5.71 COL 13.29 COLON-ALIGNED WIDGET-ID 16
     rd-opcao AT ROW 6.75 COL 20.57 NO-LABEL WIDGET-ID 26
     e-formato AT ROW 8.88 COL 2.29 NO-LABEL WIDGET-ID 18
     btOK AT ROW 11.92 COL 2
     btCancel AT ROW 11.92 COL 13
     btHelp2 AT ROW 11.92 COL 80
     "Formato Arquivo" VIEW-AS TEXT
          SIZE 11.57 BY .54 AT ROW 8.17 COL 3 WIDGET-ID 22
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 11.71 COL 1
     RECT-1 AT ROW 2.71 COL 1.57 WIDGET-ID 2
     RECT-2 AT ROW 5.46 COL 1.57 WIDGET-ID 14
     RECT-3 AT ROW 8.46 COL 1.57 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 13.08
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
         HEIGHT             = 12.17
         WIDTH              = 90
         MAX-HEIGHT         = 27.63
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.63
         VIRTUAL-WIDTH      = 146.29
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


&Scoped-define SELF-NAME bt-importacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importacao wWindow
ON CHOOSE OF bt-importacao IN FRAME fpage0
DO:
    def var c-arq-conv  as char no-undo.
    def var l-ok        as logical init no.

    assign c-arq-conv ="".

    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.csv" "*.csv",
               "*.txt" "*.txt", 
               "*.*" "*.*"
       DEFAULT-EXTENSION "csv"
       MUST-EXIST
       USE-FILENAME
       TITLE 'Importar do arquivo'
       UPDATE l-ok.

    IF l-ok THEN DO:
        assign c-arq-imp = c-arq-conv.
        display c-arq-imp with frame fpage0.
    END.

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


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:

    IF INPUT frame fpage0 c-arq-imp:screen-value = "" 
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Informe um Arquivo!").

        return 'NOK':U.
    END.

    if search(INPUT frame fpage0 c-arq-imp:screen-value) = ? 
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Arquivo ou Diret¢rio n∆o encontrados!").

        return 'NOK':U.
    END.

    IF NOT AVAIL dp-proces-item 
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Item vers∆o n∆o cadastrado!").

        return 'NOK':U.
    END.

    IF dp-proces-item.ind-aprov <> 1 
    THEN DO:

        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Situaá∆o da vers∆o n∆o permite importaá∆o!" + "~~" + 
                                 "Apenas vers‰es com situaá∆o ABERTO podem ser alteradas").

        return 'NOK':U.

    END.
/*
    IF CAN-FIND(FIRST dp-estrut WHERE
                      dp-estrut.item-dp         = dp-proces-item.item-dp
                  AND dp-estrut.num-proces-item = dp-proces-item.num-proces-item) 
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Importaá∆o n∆o liberada" + "~~" + 
                                     "J† existe uma estrutura cadastrada para a vers∆o"  ).

        return 'NOK':U.
    END. */

    RUN pi-importa.

    IF RETURN-VALUE <> "NOK" 
    THEN RUN utp/ut-msgs.p (INPUT 'show',
                            INPUT 15825,
                            INPUT "Importaá∆o Efetuada com Sucesso.~~" +
                                  "ATENÄ«O: atualize o registro no DP0301 para visualizar a estrutura importada").

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

find dp-proces-item where rowid(dp-proces-item) = gr-dp-proces-item no-error.

ASSIGN c-item-dp:SENSITIVE         IN FRAME fPage0 = NO
       i-num-proces-item:SENSITIVE IN FRAME fPage0 = NO
       c-desc-item:SENSITIVE       IN FRAME fPage0 = NO
       c-descricao:SENSITIVE       IN FRAME fPage0 = NO
       e-formato:SENSITIVE         IN FRAME fPage0 = NO.

if avail dp-proces-item
then do:
  
    FIND FIRST dp-item WHERE
               dp-item.item-dp = dp-proces-item.item-dp
               NO-LOCK NO-ERROR.

    ASSIGN c-arq-imp:SCREEN-VALUE         IN FRAME fPage0 = "" //SESSION:TEMP-DIRECTORY
           c-item-dp:SCREEN-VALUE         IN FRAME fPage0 = dp-proces-item.item-dp
           c-desc-item:SCREEN-VALUE       IN FRAME fPage0 = dp-item.desc-item WHEN AVAIL dp-item
           i-num-proces-item:SCREEN-VALUE IN FRAME fPage0 = string(dp-proces-item.num-proces-item)
           c-descricao:SCREEN-VALUE       IN FRAME fPage0 = dp-proces-item.descricao
           e-formato:SCREEN-VALUE         IN FRAME fPage0 = "LibRef;Description;Quantity;Layer;Designator;Footprint;Comment;Montagem" 
                                                          + CHR(13) 
                                                          + "1310092;Capacitor SMD MLC 0805 X7R 100V Ò10% 680pF;1;Top;C1;0805C;680pF/100V;Pasta Top"
                                                          + CHR(13)
                                                          + "1313711;Capacitor EARD PTH 6311  16 V Ò20% 220 uF;1;Top;C3;CAP_EARD_PTH;220uF/16V;Manual".

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa wWindow 
PROCEDURE pi-importa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

INPUT STREAM s-import FROM VALUE(c-arq-imp:SCREEN-VALUE IN FRAME fPage0).

RUN utp/ut-acomp.p persistent set h-acomp.  

RUN pi-inicializar in h-acomp (input "Importando...").

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "dp0301-upcw", /* Nome do programa */
                 INPUT 1,            /* Ponto do programa */
                 INPUT 0,
                 INPUT "",
                 OUTPUT TABLE tt-prog-ponto).

ASSIGN i-seq = 0.
FOR EACH tt-dp-estrut: DELETE tt-dp-estrut. END.

IF INPUT rd-opcao = 1
THEN DO:
    FOR EACH dp-estrut where 
             dp-estrut.num-proces-item = dp-proces-item.num-proces-item
         and dp-estrut.item-dp         = dp-proces-item.item-dp
             EXCLUSIVE-LOCK:

        DELETE dp-estrut.        
    END.

END.
ELSE DO:

    FIND LAST dp-estrut where 
              dp-estrut.num-proces-item = dp-proces-item.num-proces-item
          and dp-estrut.item-dp         = dp-proces-item.item-dp
              NO-LOCK NO-ERROR.

    IF AVAIL dp-estrut THEN
    ASSIGN i-seq = dp-estrut.sequencia.
END.

REPEAT ON ERROR UNDO, LEAVE
       ON STOP  UNDO, LEAVE TRANSACTION:    

    //Limpa Imp
    ASSIGN c-position[1] = ""
           c-position[2] = ""
           c-position[3] = ""
           c-position[4] = ""
           c-position[5] = ""
           c-position[6] = ""
           c-position[7] = ""
           c-position[8] = "".

    IMPORT STREAM s-import DELIMITER ";"
        c-position[1] /* LibRef = Componente */
        c-position[2] /* Description */
        c-position[3] /* Quantity = Quantidade componente */
        c-position[4] /* Layer  */
        c-position[5] /* Designator = Local de Montagem*/
        c-position[6] /* Footprint */
        c-position[7] /* Comment */
        c-position[8] /* Montagem */.

    IF c-position[1] = "LibRef" THEN NEXT.

    IF c-position[8] <> "" 
    THEN DO:

        IF NOT CAN-FIND(FIRST tt-prog-ponto WHERE
                              ENTRY(1,tt-prog-ponto.conteudo,",") = SUBSTRING(dp-proces-item.item-dp,1,3) AND
                              ENTRY(2,tt-prog-ponto.conteudo,",") = c-position[8]) 
        THEN NEXT.
    END.

    ASSIGN i-seq = i-seq + 10. /* Sequencia de 10 em 10 */

    RUN pi-acompanhar IN h-acomp (INPUT "Item: " + c-position[1]).

    find tt-dp-estrut where 
         tt-dp-estrut.num-proces-item = dp-proces-item.num-proces-item
    and  tt-dp-estrut.item-dp         = dp-proces-item.item-dp
    and  tt-dp-estrut.sequencia       = i-seq
    and  tt-dp-estrut.es-codigo       = STRING(trim(c-position[1])) no-lock no-error.

    ASSIGN c-letra          = ""
           c-letra-controle = "".

    IF NOT AVAIL tt-dp-estrut 
    THEN DO:
        
        FOR EACH tt-pos: DELETE tt-pos. END.

        CREATE tt-dp-estrut.
        ASSIGN tt-dp-estrut.num-proces-item = dp-proces-item.num-proces-item
               tt-dp-estrut.item-dp         = dp-proces-item.item-dp        
               tt-dp-estrut.sequencia       = i-seq                         
               tt-dp-estrut.es-codigo       = STRING(trim(c-position[1]))
               tt-dp-estrut.qtd-compon      = DEC(c-position[3]).

        if tt-dp-estrut.qtd-compon = ? then 
          assign tt-dp-estrut.quant-usada = ?.
        else 
          assign tt-dp-estrut.quant-usada  = tt-dp-estrut.qtd-compon.

        RUN piMontaLayout (INPUT c-position[5]).

        FOR EACH tt-string:
            DELETE tt-string.
        END.

        RUN piMontaPos.

        IF LENGTH(c-letra) > 55 THEN DO:

            MESSAGE "Item: " tt-dp-estrut.es-codigo SKIP
                    c-letra SKIP(2)
                    "A quantidade de posiá‰es extrapolou o tamanho do campo. Ser† salvo somente o tamanho poss°vel: "  SKIP(2)
                    c-letra-controle
                        VIEW-AS ALERT-BOX.

            ASSIGN c-letra = c-letra-controle.

        END.

        ASSIGN tt-dp-estrut.local-montag = c-letra.

    END.
    ELSE DO:

       ASSIGN tt-dp-estrut.qtd-compon      = tt-dp-estrut.qtd-compon + DEC(c-position[3])
              tt-dp-estrut.quant-usada     = tt-dp-estrut.qtd-compon.

       RUN piMontaLayout (INPUT c-position[5]).

       FOR EACH tt-string:
           DELETE tt-string.
       END.

       RUN piMontaPos.

       IF LENGTH(c-letra) > 55 THEN DO:

            MESSAGE "Item: " tt-dp-estrut.es-codigo SKIP
                    c-letra SKIP(2)
                    "A quantidade de posiá‰es extrapolou o tamanho do campo. Ser† salvo somente o tamanho poss°vel: "  SKIP(2)
                    c-letra-controle
                        VIEW-AS ALERT-BOX.

           ASSIGN c-letra = c-letra-controle.

       END.

       ASSIGN tt-dp-estrut.local-montag = c-letra.

    END.
END.

INPUT STREAM s-import CLOSE.

BLOCO:
DO TRANSACTION:
    FOR EACH tt-dp-estrut:
        find dp-estrut where 
             dp-estrut.num-proces-item = tt-dp-estrut.num-proces-item
        and  dp-estrut.item-dp         = tt-dp-estrut.item-dp
        and  dp-estrut.sequencia       = tt-dp-estrut.sequencia
        and  dp-estrut.es-codigo       = tt-dp-estrut.es-codigo
             no-lock no-error.
    
        /* Validaá‰es */
        RUN pi-validate.
    
        IF RETURN-VALUE = "NOK" 
        THEN DO:

            IF VALID-HANDLE(h-acomp) THEN run pi-finalizar in h-acomp.
            UNDO BLOCO, return 'NOK':U.

        END.

        IF NOT AVAIL dp-estrut 
        THEN DO:
            CREATE dp-estrut.
            BUFFER-COPY tt-dp-estrut TO dp-estrut.
    
            RELEASE dp-estrut.
        END.
    END.
END.

IF VALID-HANDLE(h-acomp) THEN 
   RUN pi-finalizar in h-acomp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate wWindow 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR p-ativo AS LOGICAL NO-UNDO.
  DEF VAR p-itemob AS CHAR NO-UNDO.

  if not can-find(first item
                  where item.it-codigo = tt-dp-estrut.es-codigo
                  no-lock)
  then do:        
     run utp/ut-msgs.p (input "show",
                        input 90,
                        input tt-dp-estrut.es-codigo).

     return 'NOK':U.
  end.
  else do:
     if tt-dp-estrut.es-codigo = "" then do:
         /* Inicio -- Projeto Internacional */
         {utp/ut-liter.i "Componente" *}
         run utp/ut-msgs.p (input "show",
                            input 164,
                            input RETURN-VALUE).
         return 'NOK':U.
     end.    
  end.
/* Conforme solicitado pela †rea n∆o mostra mais a mensagem de item duplicado  
  /*** Validaá∆o de chave duplicada ***/
  if can-find(first b-tt-dp-estrut 
              where b-tt-dp-estrut.item-dp           = tt-dp-estrut.item-dp
              and   b-tt-dp-estrut.num-proces-item   = tt-dp-estrut.num-proces-item
              and   b-tt-dp-estrut.es-codigo         = tt-dp-estrut.es-codigo  
              and   b-tt-dp-estrut.num-proces-compon = tt-dp-estrut.num-proces-compon
              AND   b-tt-dp-estrut.sequencia        <> tt-dp-estrut.sequencia
              no-lock)
  then do:
     
     run utp/ut-msgs.p (input "show",
                        input 15570,
                        input tt-dp-estrut.es-codigo + "~~" + tt-dp-estrut.item-dp).
  end.                             
*/
  /* Validaá‰es UPC dp0301b-upc.p */
  FIND FIRST estrutura WHERE estrutura.it-codigo = tt-dp-estrut.es-codigo NO-LOCK NO-ERROR.
  IF NOT AVAIL estrutura THEN DO:
      FIND FIRST ITEM WHERE ITEM.it-codigo = tt-dp-estrut.es-codigo
          NO-LOCK NO-ERROR.
      IF AVAIL ITEM AND item.cod-obsoleto <> 1 THEN DO:
          MESSAGE "Componente Obsoleto. N∆o pode ser usado." SKIP
                  "Item do arquivo: " tt-dp-estrut.es-codigo
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
          
          RETURN "NOK".
      END.
  END.
  ELSE DO:
      RUN esp/verifica-estrutura.p (INPUT tt-dp-estrut.es-codigo,
                                    OUTPUT p-ativo,
                                    OUTPUT p-itemob).
  
      IF p-ativo = NO THEN DO:
          MESSAGE "Item " p-itemob " esta Obsoleto. N∆o pode ser usado." SKIP
              "Item do arquivo: " tt-dp-estrut.es-codigo
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
                  
              RETURN "NOK".
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piConverte wWindow 
PROCEDURE piConverte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param c-pos as char no-undo.
   def output param de-num as dec no-undo.

   def var c-carac as char    no-undo.
   def var c-mult  as char    no-undo.
   def var i-cont  as integer no-undo.
   def var l-alfa  as logical no-undo.
   
   def var de-mult as decimal no-undo.

   assign c-mult = "100000000000000000000000000000".
   do i-cont = 1 to length(trim(c-pos)):
      assign c-carac = c-carac 
                     + string(asc(caps(substring(c-pos,i-cont,1)))).
      if asc(caps(substring(c-pos,i-cont,1))) >= 65 then do: 
         l-alfa = yes.
      end.
   end.
   if l-alfa then do:
      assign de-mult = dec(substring(c-mult,1,((30 - length(c-carac)) + 1)))
             de-num = (dec(c-carac) * de-mult).
   end.
   else 
      assign de-num = dec(c-pos).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PiCriaSegmento wWindow 
PROCEDURE PiCriaSegmento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param c-letra as char no-undo.
   def input param c-ini   as char no-undo.
   def input param c-fim   as char no-undo.
   def input param l-alfa  as logical no-undo.
   def var c-carac as char    no-undo.
   def var i       as integer no-undo.
   def var ini     as int     no-undo.
   def var fim     as int     no-undo.
   
   if l-alfa = no then do:
      assign ini = int(c-ini)
             fim = int(c-fim).
      do i = ini to fim:
         assign c-carac  = caps(string(i)).
         find first tt-pos where tt-pos.letra = c-letra 
                             and tt-pos.pos   = trim(c-carac)
                           no-error.
         if not avail tt-pos then do:                  
            create tt-pos.
            assign tt-pos.letra   = caps(c-letra)
                   tt-pos.pos     = trim(c-carac). 
            if trim(tt-pos.pos) = "0" then 
               assign tt-pos.pos = "".
            run PiConverte(trim(c-carac), output tt-pos.ord).       
         end.          
      end.
   end.
   else do:
      if c-ini = c-fim then do:
         find first tt-pos where tt-pos.letra = c-letra 
                             and tt-pos.pos   = trim(c-ini)
                           no-error.
         if not avail tt-pos then do:                  
            create tt-pos.
            assign tt-pos.letra   = caps(c-letra)
                   tt-pos.pos     = caps(trim(c-ini)).
            if trim(tt-pos.pos) = "0" then 
               assign tt-pos.pos = "".
            run PiConverte(trim(c-ini), output tt-pos.ord).
         end.
      end.   
      else do:
         do i = asc(caps(c-ini)) to asc(caps(c-fim)):
            find first tt-pos where tt-pos.letra = c-letra
                                and tt-pos.pos   = chr(i)
                              no-error.
            if not avail tt-pos then do:                  
               create tt-pos.
               assign tt-pos.letra   = caps(c-letra)
                      tt-pos.pos     = chr(i).
               if trim(tt-pos.pos) = "0" then 
                  assign tt-pos.pos = "".
               run PiConverte(chr(i), output tt-pos.ord).
            end.
         end.
      end.          
   end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMontaLayout wWindow 
PROCEDURE piMontaLayout :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    define input parameter fi-layout as character no-undo.

    DEFINE VARIABLE c-layout AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-entradas AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-loc AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-pos AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-teste AS INTEGER     NO-UNDO.

    DEFINE VARIABLE c-letra AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-numero AS CHAR     NO-UNDO.
    DEFINE VARIABLE d-ord AS DECIMAL     NO-UNDO.


    ASSIGN c-layout = trim(replace(fi-layout, " ", "")).


    DO i-entradas = 1 TO LENGTH(c-layout):

        ASSIGN c-letra = SUBSTRING(c-layout, i-entradas, 1).

        IF asc(c-letra) = 44                            OR          /* V°rgula */
          (ASC(c-letra) >= 48 AND ASC(c-letra) <= 57)   OR          /* N£meros */
          (ASC(c-letra) >= 65 AND ASC(c-letra) <= 90)   OR          /* Letras mai£sculas */  
          (ASC(c-letra) >= 97 AND ASC(c-letra) <= 122)  THEN DO:    /* Letras min£sculas */

        END.
        ELSE DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Caracteres inv†lidos na string do Layout.~~" + 
                                     "Item: " + c-position[1] + " Designator: " + c-position[5] ).

            RETURN "NOK":U.

        END.

    END.

    DO i-entradas = 1 TO NUM-ENTRIES(c-layout, ","):

        ASSIGN c-loc = ENTRY(i-entradas, c-layout)
               i-pos = LENGTH(c-loc)
               c-letra = ""
               i-numero = ?.

        REPEAT:

            ASSIGN i-teste = int(SUBSTRING(c-loc, i-pos, 1)) NO-ERROR.

            IF ERROR-STATUS:ERROR THEN DO:

                ASSIGN c-letra = SUBSTRING(c-loc, 1, i-pos).

                IF i-pos < LENGTH(c-loc) THEN
                    ASSIGN i-numero = SUBSTRING(c-loc, i-pos + 1, LENGTH(c-loc) - LENGTH(c-letra)).

                LEAVE.

            END.

            IF i-pos < 1 THEN
                LEAVE.

            ASSIGN i-pos = i-pos - 1.
            
        END.

        IF i-pos > 1 
        THEN DO:

            IF (ASC(SUBSTRING(c-letra, i-pos, 1)) >= 65 AND ASC(SUBSTRING(c-letra, i-pos, 1)) <= 90)   OR          /* Letras mai£sculas */  
               (ASC(SUBSTRING(c-letra, i-pos, 1)) >= 97 AND ASC(SUBSTRING(c-letra, i-pos, 1)) <= 122)  
            THEN DO:
                IF i-numero = ? 
                THEN ASSIGN i-numero = SUBSTRING(c-letra, i-pos, 1)
                            c-letra  = SUBSTRING(c-loc, 1, i-pos - 1).
            END.
        END.

        run PiConverte(STRING(i-numero), output d-ord).

        IF NOT CAN-FIND(FIRST tt-pos
                        WHERE tt-pos.letra = c-letra
                        AND   tt-pos.ord   = d-ord) THEN DO:

            CREATE tt-pos.
            ASSIGN tt-pos.letra = c-letra
                   tt-pos.ord   = d-ord
                   tt-pos.pos   = string(i-numero).

        END.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMontaPos wWindow 
PROCEDURE piMontaPos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def var de-cont as decimal no-undo.
   def var de-dif  as decimal no-undo.
   def var l-traco as logical no-undo.
   def var c-ult-pos as char no-undo.
   DEF VAR i-aux AS INTEGER NO-UNDO.

   for each tt-pos break by tt-pos.letra 
                         by tt-pos.ord:

       IF tt-pos.ord = ? THEN NEXT.

       if first-of(tt-pos.letra) then do:
          create tt-string.
          assign tt-string.letra = tt-pos.letra
                 tt-string.pos   = trim(tt-pos.pos)
                 de-cont         = tt-pos.ord.
                 l-traco         = no.
          next.       
       end.
     
       assign de-dif = tt-pos.ord - de-cont.   
       if de-dif > 1 and de-dif <> 10000000000000000000000000000 then do:
          if l-traco = yes then 
             assign tt-string.pos = trim(tt-string.pos)
                                  + "-"
                                  + trim(c-ult-pos)
                                  + ","
                                  + trim(tt-pos.pos)
                    l-traco       = no.
          else
             assign tt-string.pos = trim(tt-string.pos)
                                  + ","
                                  + trim(tt-pos.pos).
          assign de-cont = tt-pos.ord.
       end.
       else do: 
          assign de-cont = tt-pos.ord
                 l-traco = yes
                 c-ult-pos = tt-pos.pos.
          if last-of(tt-pos.letra) then do:
             assign tt-string.pos = trim(tt-string.pos)
                                  + "-"
                                  + trim(tt-pos.pos).
          end.                        
       end.                           
       if substring(tt-string.pos,1,1) = "," then 
          assign tt-string.pos 
               = substring(tt-string.pos,2,length(tt-string.pos)).
   end.
   assign c-letra = "".
   for each tt-string:

       if c-letra <> "" then 
          assign c-letra = c-letra + ";".

       assign c-letra = c-letra 
                      + trim(tt-string.letra)
                      + (if tt-string.pos <> "" then "(" else "")         
                      + trim(tt-string.pos)
                      + (if tt-string.pos <> "" then ")" else "").

        /*IF length(c-letra) <= 55  THEN
            ASSIGN c-letra-controle = c-letra.*/

   end.                   

    IF LENGTH(c-letra) > 55 THEN DO:
   
        DO i-aux = 55 TO 1 BY -1:
        
            CASE SUBSTRING(c-letra, i-aux, 1):
        
                WHEN ";" THEN DO:
        
                    ASSIGN c-letra-controle = SUBSTRING(c-letra, 1, i-aux - 1).
                    LEAVE.
        
                END.
        
                WHEN "," THEN DO:
        
                    ASSIGN  c-letra-controle = SUBSTRING(c-letra, 1, i-aux - 1) + ")".
                    LEAVE.
        
                END.
        
                WHEN ")" THEN DO:
        
                    ASSIGN c-letra-controle = SUBSTRING(c-letra, 1, i-aux).
                    LEAVE.
        
                END.
        
        
            END CASE.
        
        END.

    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

