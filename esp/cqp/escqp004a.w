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
{include/i-prgvrs.i escqp004 2.04.000.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escqp004
&GLOBAL-DEFINE Version        2.04.000.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Dados,Narrativa

&GLOBAL-DEFINE page0Widgets   btCancela btOK fi-desc-item fi-it-codigo fi-quantidade
&GLOBAL-DEFINE page1Widgets   fi-cod-fabric fi-contenedor ~
                              fi-dt-fabricacao  fi-nome-abrev ~
                              tb-homologado fi-codigo-rejei fi-descricao
&GLOBAL-DEFINE page2Widgets   c-narrativa
&GLOBAL-DEFINE page3Widgets   fi-codigo-rejei fi-descricao fi-dt-fabricacao ~
                              cb-local fi-localizacao fi-contenedor
&GLOBAL-DEFINE page4Widgets   fi-cod-depos fi-nome fi-localizacao fi-contenedor 

/* Parameters Definitions ---                                           */
DEF INPUT PARAM p-rec-ficha-cq AS ROWID NO-UNDO.
DEF INPUT PARAM p-tipo AS INT NO-UNDO.
/* 1 = Aprovar
   2 = Condicional
   3 = Rejeitar
   4 = Outros
*/   
DEFINE OUTPUT PARAMETER pcod-fabric AS CHARACTER NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
def SHARED var i-lote-multiplo-s LIKE item.lote-multipl NO-UNDO.
DEF SHARED VAR l-troca-s AS LOGICAL NO-UNDO.
DEFINE SHARED VARIABLE i-contenedor-s AS DECIMAL NO-UNDO.
def SHARED var c-mensagem-mail-s as CHAR NO-UNDO.
def SHARED var i-quantidade-s   like ficha-cq.qt-original NO-UNDO.
def SHARED var i-cod-fabric-s   as int NO-UNDO.
def SHARED var dt-validade-s as DATE NO-UNDO.
def SHARED var i-cod-rej-s like cod-rejeicao.codigo-rejei NO-UNDO.
def SHARED var c-narrativa-s  like ficha-cq.narrativa NO-UNDO.
def SHARED var c-localizacao-s like movto-estoq.cod-localiz NO-UNDO.
def SHARED var c-depos-ent-s like deposito.cod-depos NO-UNDO.

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEF VAR i-dias-val AS INTEGER NO-UNDO.
DEF VAR wh-codigo-rejei AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-contenedor AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-dt-fabricacao AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-localizacao AS WIDGET-HANDLE NO-UNDO.
DEF VAR l-folder-principal AS LOGICAL NO-UNDO.
def var c-remetente as char no-undo.
{upc/btb910za-upc.i}

def new global shared var c-estabelec like estabelec.cod-estabel no-undo.
def new global shared var c-deposito  like deposito.cod-depos    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-20 btOK btCancela 
&Scoped-Define DISPLAYED-OBJECTS fi-it-codigo fi-desc-item fi-quantidade 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 fi-cod-depos 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancela 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 52 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-quantidade AS DECIMAL FORMAT ">>>>>,>>9.9999" INITIAL 0 
     LABEL "Quantidade Condicional":R22 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE fi-cod-fabric AS INTEGER FORMAT ">,>>>,>>9" INITIAL 0 
     LABEL "Fabricante" 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-codigo-rejei AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "C¢digo Rejeiá∆o" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-contenedor AS DECIMAL FORMAT ">>>,>>9":U INITIAL 1 
     LABEL "Contenedor" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(30)" 
     VIEW-AS FILL-IN 
     SIZE 30.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-fabricacao AS DATE FORMAT "99/99/9999" 
     LABEL "Data Fabricaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-abrev AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE tb-homologado AS LOGICAL INITIAL no 
     LABEL "Fabricante n∆o homologado" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.

DEFINE VARIABLE c-narrativa AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
     SIZE 80 BY 4
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE cb-local AS CHARACTER FORMAT "X(07)":U 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "EQF","SUP","MEC","P&D","MKT","DOC","INJ","IP","FAL","ANALISE" 
     DROP-DOWN-LIST
     SIZE 12.72 BY 1 NO-UNDO.

DEFINE VARIABLE fi-localizacao AS CHARACTER FORMAT "X(07)":U 
     LABEL "Localizaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-depos AS CHARACTER FORMAT "x(3)" 
     LABEL "Dep¢sito":R10 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 29.72 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-it-codigo AT ROW 1.17 COL 17 COLON-ALIGNED HELP
          "C¢digo do Item" NO-TAB-STOP 
     fi-desc-item AT ROW 1.17 COL 35.57 NO-LABEL NO-TAB-STOP 
     fi-quantidade AT ROW 2.17 COL 17 COLON-ALIGNED
     btOK AT ROW 9.29 COL 2
     btCancela AT ROW 9.29 COL 12
     RECT-20 AT ROW 9 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 9.63
         FONT 1.

DEFINE FRAME fpage2
     c-narrativa AT ROW 1.17 COL 3 NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE 
         AT COL 4 ROW 4.25
         SIZE 84 BY 4.25
         BGCOLOR 8 FONT 1.

DEFINE FRAME fpage3
     fi-codigo-rejei AT ROW 1.17 COL 13 COLON-ALIGNED
          LABEL "C¢digo Rejeiá∆o" FORMAT ">>9"
          VIEW-AS FILL-IN 
          SIZE 3.57 BY .88
     fi-descricao AT ROW 1.17 COL 16.86 COLON-ALIGNED NO-LABEL FORMAT "X(30)"
          VIEW-AS FILL-IN 
          SIZE 30.57 BY .88 NO-TAB-STOP 
     fi-dt-fabricacao AT ROW 2.17 COL 13 COLON-ALIGNED
          LABEL "Data Fabricaá∆o" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     fi-localizacao AT ROW 3.17 COL 13 COLON-ALIGNED HELP
          "Digite a localizaá∆o ou seleciona na caixa ao lado"
     cb-local AT ROW 3.17 COL 22.29 COLON-ALIGNED NO-LABEL
     fi-contenedor AT ROW 4.17 COL 13 COLON-ALIGNED
          LABEL "Contenedor" FORMAT ">>>,>>9":U
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 4 ROW 4.25
         SIZE 84 BY 4.25
         FONT 1.

DEFINE FRAME fpage4
     fi-cod-depos AT ROW 1.17 COL 13 COLON-ALIGNED
     fi-nome AT ROW 1.17 COL 18.29 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fi-localizacao AT ROW 2.13 COL 13 COLON-ALIGNED HELP
          "Digite a localizaá∆o ou seleciona na caixa ao lado" WIDGET-ID 2
          LABEL "Localizaá∆o" FORMAT "X(10)":U
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     fi-contenedor AT ROW 3.17 COL 13 COLON-ALIGNED
          LABEL "Contenedor" FORMAT ">>>,>>9":U
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 4 ROW 4.25
         SIZE 84 BY 4.25
         FONT 1.

DEFINE FRAME fpage1
     fi-contenedor AT ROW 1.17 COL 13 COLON-ALIGNED
     fi-cod-fabric AT ROW 2.17 COL 13 COLON-ALIGNED HELP
          "Informe o codigo do fabricante"
     fi-nome-abrev AT ROW 2.17 COL 23 COLON-ALIGNED HELP
          "Informe o nome do fabricante" NO-LABEL NO-TAB-STOP 
     tb-homologado AT ROW 2.17 COL 51
     fi-codigo-rejei AT ROW 3.17 COL 13 COLON-ALIGNED
     fi-dt-fabricacao AT ROW 3.17 COL 13 COLON-ALIGNED
     fi-descricao AT ROW 3.17 COL 17.29 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 4 ROW 4.25
         SIZE 84 BY 4.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 9.67
         WIDTH              = 90
         MAX-HEIGHT         = 19.88
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 19.88
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{esp/ShowMsg.i}
{window/window.i}
{esp/eslib.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fpage1:FRAME = FRAME fpage0:HANDLE
       FRAME fpage2:FRAME = FRAME fpage0:HANDLE
       FRAME fpage3:FRAME = FRAME fpage0:HANDLE
       FRAME fpage4:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME fpage0
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       fi-desc-item:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN fi-it-codigo IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       fi-it-codigo:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN fi-quantidade IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fpage1
                                                                        */
ASSIGN 
       FRAME fpage1:SENSITIVE        = FALSE.

/* SETTINGS FOR FILL-IN fi-descricao IN FRAME fpage1
   NO-ENABLE                                                            */
ASSIGN 
       fi-descricao:READ-ONLY IN FRAME fpage1        = TRUE.

/* SETTINGS FOR FILL-IN fi-nome-abrev IN FRAME fpage1
   NO-ENABLE                                                            */
ASSIGN 
       fi-nome-abrev:READ-ONLY IN FRAME fpage1        = TRUE.

/* SETTINGS FOR FRAME fpage2
                                                                        */
/* SETTINGS FOR FRAME fpage3
                                                                        */
ASSIGN 
       FRAME fpage3:SENSITIVE        = FALSE.

/* SETTINGS FOR COMBO-BOX cb-local IN FRAME fpage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-contenedor IN FRAME fpage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-descricao IN FRAME fpage3
   NO-ENABLE                                                            */
ASSIGN 
       fi-descricao:READ-ONLY IN FRAME fpage3        = TRUE.

/* SETTINGS FOR FILL-IN fi-localizacao IN FRAME fpage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fpage4
                                                                        */
ASSIGN 
       FRAME fpage4:SENSITIVE        = FALSE.

/* SETTINGS FOR FILL-IN fi-cod-depos IN FRAME fpage4
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-contenedor IN FRAME fpage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-localizacao IN FRAME fpage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nome IN FRAME fpage4
   NO-ENABLE                                                            */
ASSIGN 
       fi-nome:READ-ONLY IN FRAME fpage4        = TRUE.

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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage1
/* Query rebuild information for FRAME fpage1
     _Query            is NOT OPENED
*/  /* FRAME fpage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage2
/* Query rebuild information for FRAME fpage2
     _Query            is NOT OPENED
*/  /* FRAME fpage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage3
/* Query rebuild information for FRAME fpage3
     _Query            is NOT OPENED
*/  /* FRAME fpage3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage4
/* Query rebuild information for FRAME fpage4
     _Query            is NOT OPENED
*/  /* FRAME fpage4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
    APPLY "choose":U TO btCancela IN FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "choose":U TO btCancela IN FRAME fpage0.
  RETURN "NOK".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancela wWindow
ON CHOOSE OF btCancela IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN "NOK".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:

    IF fi-quantidade:SENSITIVE IN FRAME fpage0 THEN DO:
        IF (INPUT FRAME fpage0 fi-quantidade + ficha-cq.qt-aprovada +
            ficha-cq.qt-apr-cond + ficha-cq.qt-rejeitada) > ficha-cq.qt-original THEN DO:
            RUN ShowMessage (1, "Quantidade informada incorreta", "Quantidade deve ser menor ou igual a quantidade original").
            APPLY "entry" TO fi-quantidade IN FRAME fpage0.
            RETURN NO-APPLY.
        END.
        i-quantidade-s = INPUT FRAME fpage0 fi-quantidade.
    END.

    /*
    IF int(wh-contenedor:screen-value) NE i-lote-multiplo-s THEN DO:
        run manda-mail.
    END.
    */

    if i-quantidade-s / int(wh-contenedor:screen-value) >= 1000 then do:
       RUN ShowMessage (1, "Quantidade ir† gerar mais de 1000 seqÅàncias", 
                        SUBSTITUTE("Quantidade ir† gerar mais de 1000 seqÅàncias: &1",
                        TRIM(STRING(i-quantidade-s / int(wh-contenedor:screen-value))))).
       l-folder-principal = NO.
       run setFolder IN hFolder (input 1).
       APPLY "entry" TO wh-contenedor.
       RETURN NO-APPLY.
    end.


    ASSIGN i-contenedor-s = int(wh-contenedor:screen-value)
           c-narrativa-s  = INPUT FRAME fpage2 c-narrativa
           c-localizacao-s = "".
    CASE p-tipo:
        WHEN 1 OR WHEN 3 THEN DO WITH FRAME fpage1:
            IF fi-cod-fabric:SENSITIVE IN FRAME fpage1 THEN DO:
                IF INPUT FRAME fpage1 tb-homologado THEN DO:
                    RUN ShowMessage (3, "Fabricante n∆o selecionado", 
                                     "O Fabricante n∆o foi selecionado. Continua?").
                    IF RETURN-VALUE = "no" THEN DO:
                        run setFolder IN hFolder (input 1).
                        APPLY "entry" TO fi-cod-fabric IN FRAME fpage1.
                        RETURN NO-APPLY.
                    END.
                    i-cod-fabric-s = 0.
                END.
                ELSE IF NOT CAN-FIND(FIRST mgesp.item-fabric NO-LOCK
                                     WHERE item-fabric.cod-fabric = INPUT FRAME fpage1 fi-cod-fabric
                                     AND   item-fabric.it-codigo  = ficha-cq.it-codigo) THEN DO:
                    RUN ShowMessage (1, "Fabricante n∆o cadastrado para este item", 
                                     "O fabricante informado n∆o tem nenhuma ocorrància para este item").
                    run setFolder IN hFolder (input 1).
                    APPLY "entry" TO fi-cod-fabric IN FRAME fpage1.
                    RETURN NO-APPLY.
                END.
                i-cod-fabric-s = INPUT FRAME fpage1 fi-cod-fabric.
            END.
            ELSE i-cod-fabric-s = INPUT FRAME fpage1 fi-cod-fabric.
        END.
        OTHERWISE DO:
            i-cod-fabric-s = 0.
        END.
    END CASE.

    if p-tipo <> 4 then do:
        IF wh-codigo-rejei NE ? THEN DO:        
            IF NOT CAN-FIND(FIRST cod-rejeicao NO-LOCK
                            where cod-rejeicao.codigo-rejei = int(wh-codigo-rejei:screen-value)) THEN DO:
               RUN ShowMessage (1, "C¢digo de Rejeiá∆o n∆o cadastrado", "").
               l-folder-principal = NO.
               run setFolder IN hFolder (input 1).
               APPLY "entry" to wh-codigo-rejei.
               RETURN NO-APPLY.
            END.
            ASSIGN i-cod-rej-s   = int(wh-codigo-rejei:screen-value).
        END.
    
        IF date(wh-dt-fabricacao:screen-value) NE ? THEN DO:
            if p-tipo <> 4 then do:
                IF date(wh-dt-fabricacao:screen-value) > TODAY THEN DO:
                    RUN ShowMessage (1, "Data de fabricaá∆o superior a data corrente", 
                                     "Data de fabricaá∆o deve ser igual ou menor a data corrente").
                    l-folder-principal = NO.
                    run setFolder IN hFolder (input 1).
                    APPLY "entry" TO wh-dt-fabricacao.
                    RETURN NO-APPLY.
                END.
                FOR first familia no-lock 
                    WHERE familia.fm-codigo = item.fm-codigo:
                    assign i-dias-val = 1.
                    FOR mgesp.int-familia of familia NO-LOCK:
                        assign i-dias-val = int-familia.meses-validade * 30.
                    END.
                END.
        
                assign dt-validade-s  = date(wh-dt-fabricacao:screen-value) + i-dias-val.
        
                if dt-validade-s <= today then do:
                    RUN ShowMessage (3, "Item com prazo de validade vencido", 
                                     "O item est† com o prazo de validade vencido. Continua?").
                    IF RETURN-VALUE = "no" THEN DO:
                        dt-validade-s = ?.
                        RETURN "NOK".
                    END.
                 end.
             end.
        END.
        else do:
            RUN ShowMessage (1, "Data de fabricaá∆o n∆o informada", 
                             "ê obrigat¢rio informar uma data de fabricaá∆o").
            l-folder-principal = NO.
            run setFolder IN hFolder (input 1).
            APPLY "entry" TO wh-dt-fabricacao.
            RETURN NO-APPLY.
        end.
    end.
    
    IF wh-localizacao NE ?
        AND wh-localizacao:SENSITIVE THEN DO:
        IF wh-localizacao:SCREEN-VALUE = "" THEN DO:
            RUN ShowMessage (1, "Localizaá∆o n∆o informada", 
                                 "Informe uma localizaá∆o").
            l-folder-principal = NO.
            run setFolder IN hFolder (input 1).
            APPLY "entry" to wh-localizacao.
            RETURN NO-APPLY.
        END.
        c-localizacao-s = wh-localizacao:SCREEN-VALUE.
    END.
    
    ASSIGN c-depos-ent-s = INPUT FRAME fpage4 fi-cod-depos
           pcod-fabric   = string(INPUT FRAME fPage1 fi-cod-fabric).

    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME cb-local
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-local wWindow
ON VALUE-CHANGED OF cb-local IN FRAME fpage3
DO:
  DISP cb-local:SCREEN-VALUE @ fi-localizacao WITH FRAME fpage3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage4
&Scoped-define SELF-NAME fi-cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos wWindow
ON F5 OF fi-cod-depos IN FRAME fpage4 /* Dep¢sito */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in084"
                       &campo="fi-nome"
                       &campozoom="nome"
                       &frame="fPage4"
                       &campo2="fi-cod-depos"
                       &campozoom2="cod-depos"
                       &frame2="fPage4"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos wWindow
ON LEAVE OF fi-cod-depos IN FRAME fpage4 /* Dep¢sito */
DO:
    {include/leave.i &tabela=deposito
                     &atributo-ref=nome
                     &variavel-ref=fi-nome
                     &where="deposito.cod-depos = fi-cod-depos:screen-value in frame fPage4"}
                     
    IF INPUT fi-cod-depos = "HML" THEN DO:
        ENABLE fi-localizacao WITH FRAME fpage4.
        ASSIGN fi-localizacao:READ-ONLY IN FRAME fPage4 = YES
               fi-localizacao:BGCOLOR  = 15.
        APPLY "entry" TO fi-localizacao IN FRAME fpage4.
        RETURN NO-APPLY.
    END.
    ELSE DO:
        ASSIGN fi-localizacao:SCREEN-VALUE IN FRAME fPage4 = ""
               fi-localizacao:BGCOLOR  = ?.
        DISABLE fi-localizacao WITH FRAME fpage4.
    END.
        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-depos IN FRAME fpage4 /* Dep¢sito */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage1
&Scoped-define SELF-NAME fi-cod-fabric
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-fabric wWindow
ON F5 OF fi-cod-fabric IN FRAME fpage1 /* Fabricante */
DO:

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es110.w"
                         &FieldZoom1="cod-fabric"
                         &FieldScreen1="fi-cod-fabric"
                         &Frame1="{&FRAME-NAME}"
                         &EnableImplant="NO"
                         &RunMethod="run setInitials in hProgramZoom (input ficha-cq.it-codigo, input ficha-cq.it-codigo)."}
/*
    {include/zoomvar.i &prog-zoom="eszoom/z01es110.w"
                       &campo="fi-cod-fabric"
                       &campozoom="cod-fabric"
                       &frame="fpage1"
                       &parametros="run setInitials in wh-pesquisa (input ficha-cq.it-codigo, input ficha-cq.it-codigo)."}
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-fabric wWindow
ON LEAVE OF fi-cod-fabric IN FRAME fpage1 /* Fabricante */
DO:
    IF INPUT fi-cod-fabric NE 1000000 THEN DO:
        {include/leave.i &tabela=mgesp.fabricante
                         &atributo-ref=nome-abrev
                         &variavel-ref=fi-nome-abrev
                         &where="mgesp.fabricante.cod-fabric = input frame fpage1 fi-cod-fabric"}
    END.
    ELSE
        DISP "N∆o homologado" @ fi-nome-abrev WITH FRAME fpage1.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-fabric wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-fabric IN FRAME fpage1 /* Fabricante */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME fi-codigo-rejei
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-codigo-rejei wWindow
ON F5 OF fi-codigo-rejei IN FRAME fpage3 /* C¢digo Rejeiá∆o */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in047"
                       &campo2="fi-codigo-rejei"
                       &campozoom2="codigo-rejei"
                       &frame2="fpage3"
                       &campo="fi-descricao"
                       &campozoom="descricao"
                       &frame="fpage3"}
                       
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-codigo-rejei wWindow
ON LEAVE OF fi-codigo-rejei IN FRAME fpage3 /* C¢digo Rejeiá∆o */
DO:
    {include/leave.i &tabela=cod-rejeicao
                     &atributo-ref=descricao
                     &variavel-ref=fi-descricao
                     &where="cod-rejeicao.codigo-rejei = input frame fpage3 fi-codigo-rejei"}
    IF INPUT fi-codigo-rejei = 4 THEN
        DISABLE cb-local fi-contenedor fi-localizacao WITH FRAME fpage3.
    ELSE
        ENABLE cb-local fi-contenedor fi-localizacao WITH FRAME fpage3.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-codigo-rejei wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-codigo-rejei IN FRAME fpage3 /* C¢digo Rejeiá∆o */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage1
&Scoped-define SELF-NAME fi-codigo-rejei
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-codigo-rejei wWindow
ON F5 OF fi-codigo-rejei IN FRAME fpage1 /* C¢digo Rejeiá∆o */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in047"
                       &campo2="fi-codigo-rejei"
                       &campozoom2="codigo-rejei"
                       &frame2="fpage1"
                       &campo="fi-descricao"
                       &campozoom="descricao"
                       &frame="fpage1"}
                       
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-codigo-rejei wWindow
ON LEAVE OF fi-codigo-rejei IN FRAME fpage1 /* C¢digo Rejeiá∆o */
DO:
    {include/leave.i &tabela=cod-rejeicao
                     &atributo-ref=descricao
                     &variavel-ref=fi-descricao
                     &where="cod-rejeicao.codigo-rejei = input frame fpage1 fi-codigo-rejei"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-codigo-rejei wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-codigo-rejei IN FRAME fpage1 /* C¢digo Rejeiá∆o */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON LEAVE OF fi-it-codigo IN FRAME fpage0 /* Item */
DO:
    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=fi-desc-item
                     &where="item.it-codigo = fi-it-codigo:screen-value in frame fpage0"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage4
&Scoped-define SELF-NAME fi-localizacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-localizacao wWindow
ON F5 OF fi-localizacao IN FRAME fpage4 /* Localizaá∆o */
DO:
    assign c-estabelec = ficha-cq.cod-estabel
           c-deposito  = fi-cod-depos:SCREEN-VALUE IN FRAME fPage4.

    {include/zoomvar.i &prog-zoom=inzoom/z04in189.w
                      &campo=fi-localizacao
                      &campozoom=cod-localiz
                      &frame=fPage4}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-localizacao wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-localizacao IN FRAME fpage4 /* Localizaá∆o */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME fi-localizacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-localizacao wWindow
ON LEAVE OF fi-localizacao IN FRAME fpage3 /* Localizaá∆o */
DO:
  IF cb-local:LOOKUP(fi-localizacao:INPUT-VALUE) = 0 THEN DO:
      DISP "" @ fi-localizacao WITH FRAME fpage3.
      RETURN.
  END.
  ELSE do:
      cb-local:SCREEN-VALUE = caps(fi-localizacao:SCREEN-VALUE).
      APPLY "entry" TO fi-contenedor IN FRAME fpage3.
      RETURN.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage1
&Scoped-define SELF-NAME tb-homologado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-homologado wWindow
ON VALUE-CHANGED OF tb-homologado IN FRAME fpage1 /* Fabricante n∆o homologado */
DO:
  IF INPUT tb-homologado THEN DO WITH FRAME fpage1:
      fi-cod-fabric:PRIVATE-DATA = fi-cod-fabric:SCREEN-VALUE.
      DISP 1000000 @ fi-cod-fabric.
      APPLY "leave" TO fi-cod-fabric IN FRAME fpage1.
      IF p-tipo = 1 THEN
          APPLY "entry" TO fi-dt-fabricacao IN FRAME fpage1.
      ELSE
         APPLY "entry" TO fi-codigo-rejei IN FRAME fpage1.
      RETURN.
  END.
  ELSE DO WITH FRAME fpage1:
      DISP fi-cod-fabric:PRIVATE-DATA @ fi-cod-fabric.
      APPLY "leave" TO fi-cod-fabric IN FRAME fpage1.
      APPLY "entry" TO fi-cod-fabric IN FRAME fpage1.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterchangePage wWindow 
PROCEDURE AfterchangePage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    l-folder-principal = NOT l-folder-principal.
    IF l-folder-principal THEN
        CASE p-tipo:
            WHEN 2 THEN DO:
                HIDE FRAME fpage1.
                VIEW FRAME fpage3.
                APPLY "entry" TO fi-codigo-rejei IN FRAME fpage3.
            END.
            WHEN 4 THEN DO:
                HIDE FRAME fpage1.
                VIEW FRAME fpage4.
                APPLY "entry" TO fi-cod-depos IN FRAME fpage4.
            END.
        END CASE.
    ELSE APPLY "entry" TO c-narrativa IN FRAME fpage2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterinitializeInterface wWindow 
PROCEDURE AfterinitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR wh-label AS WIDGET-HANDLE NO-UNDO.
    DEF VAR wh-label2 AS WIDGET-HANDLE NO-UNDO.

    fi-localizacao:load-mouse-pointer ("image~\lupa.cur") in frame fPage4.

    FOR FIRST ficha-cq NO-LOCK
        WHERE ROWID(ficha-cq) = p-rec-ficha-cq:
    END.
    ASSIGN wh-label      = fi-quantidade:SIDE-LABEL-HANDLE IN FRAME fpage0
           fi-quantidade = ficha-cq.qt-original -
                           ficha-cq.qt-aprovada -
                           ficha-cq.qt-apr-cond -
                           ficha-cq.qt-rejeitada.

    DISP ficha-cq.it-codigo @ fi-it-codigo fi-quantidade WITH FRAME fpage0. 
    APPLY "leave" TO fi-it-codigo IN FRAME fpage0.
    DISP fi-quantidade WITH FRAME fpage0.
    c-narrativa:SCREEN-VALUE IN FRAME fpage2 = c-narrativa-s.
    FIND mgesp.item-fabric no-lock 
        where item-fabric.it-codigo = ficha-cq.it-codigo no-error.
    if avail item-fabric THEN DO:
        assign i-cod-fabric-s = item-fabric.cod-fabric.
        DISP i-cod-fabric-s @ fi-cod-fabric WITH FRAME fpage1.
        APPLY "leave" TO fi-cod-fabric IN FRAME fpage1.
        DISABLE fi-cod-fabric /*tb-homologado*/ WITH FRAME fpage1.
    END.
    ELSE i-cod-fabric-s = ?.

    ASSIGN wh-contenedor    = fi-contenedor:HANDLE IN FRAME fpage1
           wh-codigo-rejei  = ?
           wh-dt-fabricacao = ?
           wh-localizacao   = ?.

    CASE p-tipo:
        WHEN 1 THEN DO WITH FRAME fpage1:
            HIDE FRAME fpage3.
            HIDE FRAME fpage4.
            HIDE fi-codigo-rejei fi-descricao IN FRAME fpage1.
            DISABLE fi-codigo-rejei fi-descricao.
            ASSIGN fi-codigo-rejei:VISIBLE IN FRAME fpage1 = NO
                   fi-codigo-rejei:SENSITIVE IN FRAME fpage1 = NO.
            wh-label:SCREEN-VALUE = "Quantidade Aprovada":r22.
            fi-cod-fabric:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage1.
            wh-dt-fabricacao = fi-dt-fabricacao:HANDLE IN FRAME fpage1.
        END.
        WHEN 3 THEN DO WITH FRAME fpage1:
            HIDE FRAME fpage3.
            HIDE FRAME fpage4.
            ASSIGN fi-dt-fabricacao:ROW IN FRAME fpage1 = fi-dt-fabricacao:ROW IN FRAME fpage1 + 1.0
                   wh-label2 = fi-dt-fabricacao:SIDE-LABEL-HANDLE IN FRAME fpage1
                   wh-label2:ROW = fi-dt-fabricacao:ROW IN FRAME fpage1
                   wh-label:SCREEN-VALUE = "Quantidade Condicional".
            fi-codigo-rejei:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage1.
            wh-codigo-rejei = fi-codigo-rejei:HANDLE IN FRAME fpage1.
            wh-dt-fabricacao = fi-dt-fabricacao:HANDLE IN FRAME fpage1.
        END.
        WHEN 2 THEN DO WITH FRAME fpage3:
            HIDE FRAME fpage1.
            HIDE FRAME fpage4.
            cb-local:SCREEN-VALUE IN FRAME fpage3 = cb-local:ENTRY(1).
            wh-label:SCREEN-VALUE = "Quantidade Rejeitada":r22.
            fi-codigo-rejei:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage3.
            ASSIGN wh-contenedor    = fi-contenedor:HANDLE IN FRAME fpage3
                   wh-codigo-rejei  = fi-codigo-rejei:HANDLE IN FRAME fpage3
                   wh-dt-fabricacao = fi-dt-fabricacao:HANDLE IN FRAME fpage3
                   wh-localizacao   = fi-localizacao:HANDLE IN FRAME fpage3.
        END.
        WHEN 4 THEN DO WITH FRAME fpage4:
            HIDE FRAME fpage1.
            HIDE FRAME fpage3.
            /*cb-local2:SCREEN-VALUE IN FRAME fpage4 = cb-local2:ENTRY(1).*/
            fi-cod-depos:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage4.
            ASSIGN wh-contenedor    = fi-contenedor:HANDLE IN FRAME fpage4
                   wh-localizacao   = fi-localizacao:HANDLE IN FRAME fpage4.
        END.
    END CASE.
    ASSIGN wh-contenedor:SCREEN-VALUE = string(i-contenedor-s)
           wh-contenedor:SENSITIVE = l-troca-s or v_cod_estab_usuar = "102" /* Nova */.

    FRAME fpage4:MOVE-AFTER-TAB-ITEM(fi-quantidade:HANDLE).
    FRAME fpage3:MOVE-AFTER-TAB-ITEM(fi-quantidade:HANDLE).
    FRAME fpage2:MOVE-AFTER-TAB-ITEM(fi-quantidade:HANDLE).
    FRAME fpage1:MOVE-AFTER-TAB-ITEM(fi-quantidade:HANDLE).

    APPLY "entry" TO fi-quantidade IN FRAME fpage0.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE manda-mail wWindow 
PROCEDURE manda-mail PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR c-comprador AS CHAR NO-UNDO.
    DEF VAR c-texto AS CHAR NO-UNDO.
    find emitente where emitente.cod-emitente = ficha-cq.cod-emitente no-lock NO-ERROR.

    find usuar-mater 
          where usuar-mater.cod-usuario = item.cod-comprado 
            and usuar-mater.usuar-comprador no-lock no-error.
    if avail usuar-mater then 
       assign c-comprador = usuar-mater.e-mail.
    else do:
        if item.cod-estabel = "101" then
            assign c-comprador = "agilson@intelbras.com.br".
        else if item.cod-estabel = '102' then
            assign c-comprador = 'william.tonello@intelbras.com.br '.
    end.
    
    if item.cod-estabel = '101' then
        assign c-comprador = c-comprador + ",allison@intelbras.com.br "
               c-remetente = "intelbras@intelbras.com.br".
    else
        assign c-remetente = "nova@nova.inf.br".

    
    find usuar_mestre where
         usuar_mestre.cod_usuar = c-seg-usuario no-lock no-error.
    if avail usuar_mestre then
        assign c-remetente = usuar_mestre.cod_e_mail_local.
        
    c-texto = substitute("O contenedor do item : &1 - &2~nDo comprador : &3~nDo fornecedor: &4 - &5~nDo documento: &6 - &7 - &8~n",
                         TRIM(item.it-codigo),
                         TRIM(ITEM.desc-item),
                         TRIM(item.cod-comprado),
                         trim(STRING(emitente.cod-emit)),
                         TRIM(emitente.nome-abrev),
                         TRIM(ficha-cq.nro-docto),
                         TRIM(ficha-cq.serie-docto),
                         TRIM(ficha-cq.nat-operacao)) +
              SUBSTITUTE("Foi alterado de: &1 para: &2 no recebimento.~nOBS.:&3~nFavor verificar os cadastros do item.",
                         TRIM(STRING(i-lote-multiplo-s)),
                         TRIM(STRING(i-contenedor-s)),
                         TRIM(c-mensagem-mail-s)).

    RUN enviaMail(INPUT c-remetente, 
                  INPUT c-comprador,
                  INPUT "Alteraá∆o de Contenedor no Recebimento",
                  INPUT c-texto,
                  INPUT "").

/*  Retirada geraá∆o de log em 10/07/2006 em funá∆o de n∆o ter sido consultado nenhuma vez no £ltimo ano
/**** O ARQUIVO ABAIXO E CRIADO 1 VEZ POR MES E RODADO O PROGRAMA ****/    
/**** ES0637 QUE ENVIA E-MAIL PARA O VIRGILIO E ELIMINA O ARQUIVO ****/

    output to "\\Intel200\erp$\ems204\spool\cont-virgilio.txt" append.
    put item.it-codigo format "X(07)" " "
        item.descricao-1
        item.descricao-2 " "
        item.cod-comprado " "
        emitente.cod-emit " "
        emitente.nome-abrev " "
        ficha-cq.nro-docto " "
        ficha-cq.serie-docto " "
        ficha-cq.nat-operacao " "
        i-lote-multiplo-s " "
        i-contenedor-s  " " skip.
    output close.
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

