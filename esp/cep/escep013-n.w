&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/
{include/i-prgvrs.i escep013 2.04.000.002}
/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&GLOBAL-DEFINE Program        escep013
&GLOBAL-DEFINE Version        2.04.000.002
&SCOPED-DEFINE RPC-CALL       esp/cep/escep013rpc-n.r
        

def new global shared var v_cod_usuar_corren as char no-undo.
DEF NEW GLOBAL SHARED VAR v_impres_layout AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_nom_disposit_so AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_tit_prog_dtsul AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rotina_intelbras AS CHAR NO-UNDO.
/* DEF NEW GLOBAL SHARED VAR c-estab-usuario   AS CHARACTER NO-UNDO. */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF VAR hprog AS HANDLE NO-UNDO.
DEF VAR hproc AS HANDLE NO-UNDO.
DEF VAR i-acao AS INTEGER NO-UNDO.
DEF VAR c-msg-erro AS CHAR NO-UNDO.
DEF VAR c-deposito AS CHAR NO-UNDO.
DEF VAR c-quantidade AS CHAR FORMAT "x(06)" NO-UNDO.
DEF VAR i-roteiro AS INT NO-UNDO.
DEF VAR i-nf LIKE ae-item.nf NO-UNDO.
DEF VAR i-contenedor LIKE item.lote-multipl NO-UNDO.
DEF VAR i-quantidade AS DEC NO-UNDO.
DEF VAR c-narrativa LIKE ae-bloqueado.narrativa NO-UNDO.
DEF VAR v-narrativa AS CHAR NO-UNDO.
DEF VAR c-it-codigo AS CHAR NO-UNDO.
def var c-loc-dev like movto-estoq.cod-localiz NO-UNDO.
DEFINE VARIABLE c-localizacao AS CHARACTER NO-UNDO.

def temp-table tt-item NO-UNDO 
    field it-codigo     like item.it-codigo
    field nr-ae         like ae-item.nr-ae
    field sequencia     like ae-item.sequencia
    field quantidade    like ae-item.quantidade
    field localizacao   like ae-item.localizacao
    field cod-depos     like deposito.cod-depos.

DEF TEMP-TABLE tt-item-unique LIKE tt-item.

&GLOBAL-DEFINE EXEC-RPC YES
{esp/es0478-rpc.i}


DEF VAR i-nome-programa AS CHAR.
DEF VAR i-ponto AS INT.
DEF VAR i-sequencia AS INT.
DEF VAR i-conteudo AS CHAR.
{esp/es0018.i}
{esp/utp/acesso-rpc.i}
{upc/btb910za-upc.i}
{esp/btb/esbtb003.i}

DEF VAR c-old-usuario AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-item

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-item

/* Definitions for BROWSE br-item                                       */
&Scoped-define FIELDS-IN-QUERY-br-item tt-item.it-codigo tt-item.nr-ae tt-item.sequencia tt-item.quantidade tt-item.localizacao tt-item.cod-depos   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-item   
&Scoped-define SELF-NAME br-item
&Scoped-define QUERY-STRING-br-item FOR EACH tt-item
&Scoped-define OPEN-QUERY-br-item OPEN QUERY {&SELF-NAME} FOR EACH tt-item.
&Scoped-define TABLES-IN-QUERY-br-item tt-item
&Scoped-define FIRST-TABLE-IN-QUERY-br-item tt-item


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-item}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button rtKeys-2 rtKeys-3 bt-novo btExit ~
btHelp br-item 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-estabel c-etiqueta i-etiqueta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 bt-cancel bt-transferencia bt-devolucao bt-parcial ~
bt-pre-formados 
&Scoped-define List-2 bt-cancel bt-transferencia bt-devolucao bt-parcial ~
bt-pre-formados fi-cod-estabel c-etiqueta 
&Scoped-define List-3 bt-novo bt-transferencia bt-devolucao bt-parcial ~
bt-pre-formados 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD finaliza C-Win 
FUNCTION finaliza RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancel 
     IMAGE-UP FILE "image/im-cancel.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "Cancela" 
     SIZE 4 BY 1.25 TOOLTIP "Cancela Transferància".

DEFINE BUTTON bt-devolucao 
     LABEL "&Devoluá∆o" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-novo 
     IMAGE-UP FILE "image/im-add.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-add.bmp":U
     LABEL "Novo" 
     SIZE 4 BY 1.25 TOOLTIP "Inclus∆o de Transferància".

DEFINE BUTTON bt-parcial 
     LABEL "&Parcial" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-pre-formados 
     LABEL "PrÇ-&Formados" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-transferencia 
     LABEL "&Transferància" 
     SIZE 15 BY 1.13.

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

DEFINE VARIABLE c-codigo AS CHARACTER FORMAT "X(26)":U 
     LABEL "C¢digo de Barras" 
     VIEW-AS FILL-IN 
     SIZE 28 BY .88 NO-UNDO.

DEFINE VARIABLE c-dep-e AS CHARACTER FORMAT "X(256)":U 
     LABEL "Deposito Entrada" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-etiqueta AS CHARACTER FORMAT "X(3)":U 
     LABEL "Dep¢sito Destino" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-item AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "X(05)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE i-etiqueta AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Etiquetas" 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89.72 BY 1.46
     BGCOLOR 7 .

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.46.

DEFINE RECTANGLE rtKeys-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-item FOR 
      tt-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-item C-Win _FREEFORM
  QUERY br-item DISPLAY
      tt-item.it-codigo     
    tt-item.nr-ae         
    tt-item.sequencia     
    tt-item.quantidade    
    tt-item.localizacao   
    tt-item.cod-depos
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 9.5
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-novo AT ROW 1.17 COL 2.14 HELP
          "Inclus∆o de Transferància"
     bt-cancel AT ROW 1.17 COL 6.14 HELP
          "Cancela Transferància"
     btExit AT ROW 1.17 COL 82 HELP
          "Sair"
     btHelp AT ROW 1.17 COL 86 HELP
          "Ajuda"
     bt-transferencia AT ROW 3.25 COL 9
     bt-devolucao AT ROW 3.25 COL 28
     bt-parcial AT ROW 3.25 COL 47
     bt-pre-formados AT ROW 3.25 COL 66
     fi-cod-estabel AT ROW 5.25 COL 25 COLON-ALIGNED WIDGET-ID 2
     c-etiqueta AT ROW 6.25 COL 25 COLON-ALIGNED AUTO-RETURN 
     i-etiqueta AT ROW 6.25 COL 82 COLON-ALIGNED
     c-codigo AT ROW 7.25 COL 25 COLON-ALIGNED BLANK  AUTO-RETURN 
     c-dep-e AT ROW 7.25 COL 25 COLON-ALIGNED
     c-item AT ROW 8.25 COL 25 COLON-ALIGNED
     c-desc-item AT ROW 8.25 COL 39 COLON-ALIGNED NO-LABEL
     br-item AT ROW 9.75 COL 1
     rt-button AT ROW 1 COL 1
     rtKeys-2 AT ROW 5.04 COL 1
     rtKeys-3 AT ROW 2.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.5
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Transferància Material Almoxarifado"
         HEIGHT             = 18.5
         WIDTH              = 90
         MAX-HEIGHT         = 19.46
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 19.46
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

{esp/showmsg.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME                                                           */
/* BROWSE-TAB br-item c-desc-item f-cad */
/* SETTINGS FOR BUTTON bt-cancel IN FRAME f-cad
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR BUTTON bt-devolucao IN FRAME f-cad
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR BUTTON bt-novo IN FRAME f-cad
   3                                                                    */
/* SETTINGS FOR BUTTON bt-parcial IN FRAME f-cad
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR BUTTON bt-pre-formados IN FRAME f-cad
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR BUTTON bt-transferencia IN FRAME f-cad
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN c-codigo IN FRAME f-cad
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       c-codigo:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR FILL-IN c-dep-e IN FRAME f-cad
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       c-dep-e:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-cad
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       c-desc-item:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR FILL-IN c-etiqueta IN FRAME f-cad
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN c-item IN FRAME f-cad
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       c-item:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR FILL-IN fi-cod-estabel IN FRAME f-cad
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN i-etiqueta IN FRAME f-cad
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-item
/* Query rebuild information for BROWSE br-item
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-item.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-item */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-cad
/* Query rebuild information for FRAME f-cad
     _Query            is NOT OPENED
*/  /* FRAME f-cad */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Transferància Material Almoxarifado */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
  RUN piDesconecta.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  QUIT.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Transferància Material Almoxarifado */
DO:
  /* This event will close the window and terminate the procedure.  */
    RUN piDesconecta.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    QUIT.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancel C-Win
ON CHOOSE OF bt-cancel IN FRAME f-cad /* Cancela */
DO:
  FOR EACH tt-item:
      DELETE tt-item.
  END.

  ASSIGN i-etiqueta = 0.

  {&OPEN-QUERY-br-item}

  ENABLE bt-novo
      WITH FRAME {&FRAME-NAME}.

  DISABLE {&list-2} 
      WITH FRAME {&FRAME-NAME}.

  DISP i-etiqueta
      WITH FRAME {&FRAME-NAME}.

  ASSIGN c-etiqueta:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = ""
         c-etiqueta:SENSITIVE     IN FRAME {&FRAME-NAME} = NO 
         c-codigo:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = ""
         c-dep-e:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = "" 
         c-desc-item:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" 
         c-item:SCREEN-VALUE      IN FRAME {&FRAME-NAME} = ""
         c-codigo:HIDDEN          IN FRAME {&FRAME-NAME} = YES
         c-dep-e:HIDDEN           IN FRAME {&FRAME-NAME} = YES 
         c-desc-item:HIDDEN       IN FRAME {&FRAME-NAME} = YES 
         c-item:HIDDEN            IN FRAME {&FRAME-NAME} = YES.

  APPLY "entry" TO bt-novo IN FRAME {&FRAME-NAME}.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-devolucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-devolucao C-Win
ON CHOOSE OF bt-devolucao IN FRAME f-cad /* Devoluá∆o */
DO:

    RUN esp/utp/esbtb910zz.w (INPUT hproc, INPUT "{&Program}|{&Version}").
    IF RETURN-VALUE = "NOK" THEN DO:
        RETURN NO-APPLY.
    END.

    RUN pi-busca-estab (INPUT v_cod_usuar_corren).

    DISABLE {&list-3}
        WITH FRAME {&FRAME-NAME}.

    STATUS INPUT "Efetuando Devoluá∆o".

    ASSIGN fi-cod-estabel:SENSITIVE IN FRAME {&FRAME-NAME} = YES
           fi-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_estab_usuar
           c-etiqueta:SENSITIVE     IN FRAME {&FRAME-NAME} = YES
           c-etiqueta:LABEL         IN FRAME {&FRAME-NAME} = "Dep¢sito Origem".

    APPLY "entry" TO c-etiqueta IN FRAME {&FRAME-NAME}.

    ASSIGN i-acao = 2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-novo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-novo C-Win
ON CHOOSE OF bt-novo IN FRAME f-cad /* Novo */
DO:
  
  ENABLE {&list-1} 
      WITH FRAME {&FRAME-NAME}.

  DISABLE bt-novo 
      WITH FRAME {&FRAME-NAME}.

  ASSIGN i-etiqueta    = 0. 

  STATUS INPUT "(T) Transferància; (D) Devoluá∆o; (P) Parcial; (F) PrÇ-Formados".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-parcial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-parcial C-Win
ON CHOOSE OF bt-parcial IN FRAME f-cad /* Parcial */
DO:

    RUN esp/utp/esbtb910zz.w (INPUT hproc, INPUT "{&Program}|{&Version}").
    IF RETURN-VALUE = "NOK" THEN DO:
        RETURN NO-APPLY.
    END.

    RUN pi-busca-estab (INPUT v_cod_usuar_corren).

    DISABLE {&list-3}
        WITH FRAME {&FRAME-NAME}.

    STATUS INPUT "Efetuando Transferància Parcial".

    ASSIGN fi-cod-estabel:SENSITIVE IN FRAME {&FRAME-NAME} = YES
           fi-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_estab_usuar
           c-etiqueta:SENSITIVE     IN FRAME {&FRAME-NAME} = YES
           c-etiqueta:LABEL         IN FRAME {&FRAME-NAME} = "Dep¢sito Destino".

    APPLY "entry" TO c-etiqueta IN FRAME {&FRAME-NAME}.

    ASSIGN i-acao = 3.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-pre-formados
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pre-formados C-Win
ON CHOOSE OF bt-pre-formados IN FRAME f-cad /* PrÇ-Formados */
DO:

    RUN esp/utp/esbtb910zz.w (INPUT hproc, INPUT "{&Program}|{&Version}").
    IF RETURN-VALUE = "NOK" THEN DO:
        RETURN NO-APPLY.
    END.

    RUN pi-busca-estab (INPUT v_cod_usuar_corren).

    STATUS INPUT "Efetuando Transferància de Pre-Formados".
       
    ASSIGN c-etiqueta:LABEL IN FRAME {&FRAME-NAME} = "Dep¢sito Destino".

    ASSIGN fi-cod-estabel:SENSITIVE IN FRAME {&FRAME-NAME} = YES
           fi-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_estab_usuar
           c-etiqueta = v_cod_usuar_corren + "- alm - PF"
           i-acao     = 4
           /*i-etiqueta = 0*/
           c-codigo:HIDDEN    IN FRAME {&FRAME-NAME} = NO
           c-codigo:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    APPLY "entry" TO c-codigo IN FRAME {&FRAME-NAME}.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-transferencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-transferencia C-Win
ON CHOOSE OF bt-transferencia IN FRAME f-cad /* Transferància */
DO:

    RUN esp/utp/esbtb910zz.w (INPUT hproc, INPUT "{&Program}|{&Version}").
    IF RETURN-VALUE = "NOK" THEN DO:
        RETURN NO-APPLY.
    END.

    RUN pi-busca-estab (INPUT v_cod_usuar_corren).

  DISABLE {&list-3}
      WITH FRAME {&FRAME-NAME}.
 
  STATUS INPUT "Efetuando Transferància".

  ASSIGN fi-cod-estabel:SENSITIVE IN FRAME {&FRAME-NAME} = YES
         fi-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_estab_usuar
         c-etiqueta:SENSITIVE IN FRAME {&FRAME-NAME}     = YES
         c-etiqueta:LABEL     IN FRAME {&FRAME-NAME}     = "Dep¢sito Destino".

  APPLY "entry" TO c-etiqueta IN FRAME {&FRAME-NAME}.

  ASSIGN i-acao = 1.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit C-Win
ON CHOOSE OF btExit IN FRAME f-cad /* Exit */
DO:
    RUN piDesconecta.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    QUIT.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-codigo C-Win
ON RETURN OF c-codigo IN FRAME f-cad /* C¢digo de Barras */
DO:
    do transaction on error undo, leave:
       ASSIGN INPUT FRAME {&FRAME-NAME} c-codigo.
       if length(trim(c-codigo)) = 23 then do:
           assign i-quantidade = INT(substring(c-codigo,8,5)) 
                  c-it-codigo  = substring(c-codigo,1,7) NO-ERROR.
       
       end.
       else do: /* 26 digitos */
           assign i-quantidade = int(substring(c-codigo,14,6)) 
                  c-it-codigo  = substring(c-codigo,7,7) NO-ERROR.
       end.
       
       CASE i-acao:
           WHEN 1 THEN RUN pi-transferencia.
           WHEN 3 THEN RUN pi-parcial.
           WHEN 4 THEN RUN pi-pre-formados.
           OTHERWISE APPLY "choose" TO bt-cancel IN FRAME {&FRAME-NAME}.
       END CASE.
       
       IF RETURN-VALUE = "NOK" OR RETURN-VALUE = "RETRY" THEN DO:
           SELF:SCREEN-VALUE = "".
           APPLY "entry" TO c-codigo IN FRAME {&FRAME-NAME}.
       END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-dep-e
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-dep-e C-Win
ON LEAVE OF c-dep-e IN FRAME f-cad /* Deposito Entrada */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} c-dep-e.

    APPLY "entry" TO c-item IN FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-dep-e C-Win
ON RETURN OF c-dep-e IN FRAME f-cad /* Deposito Entrada */
DO:
    APPLY "leave" TO SELF.       

    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-etiqueta C-Win
ON RETURN OF c-etiqueta IN FRAME f-cad /* Dep¢sito Destino */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} c-etiqueta.

    c-deposito = "".
    IF LENGTH(ENTRY(1,c-etiqueta,"-")) = 3 THEN 
        ASSIGN c-deposito = SUBSTRING(c-etiqueta,1,3).
    ELSE IF LENGTH(ENTRY(1,c-etiqueta,"-")) = 4 THEN 
        ASSIGN c-deposito = SUBSTRING(c-etiqueta,2,3).

    CASE i-acao:
        WHEN 1 THEN DO:

            ASSIGN c-codigo:HIDDEN      IN FRAME {&FRAME-NAME} = NO
                   c-codigo:SENSITIVE   IN FRAME {&FRAME-NAME} = YES.

            APPLY "entry" TO c-codigo IN FRAME {&FRAME-NAME}.

            RETURN NO-APPLY.

        END.
        WHEN 2 THEN DO:

            ASSIGN c-item:HIDDEN          IN FRAME {&FRAME-NAME} = NO
                   c-desc-item:HIDDEN     IN FRAME {&FRAME-NAME} = NO 
                   c-item:SENSITIVE       IN FRAME {&FRAME-NAME} = YES 
                   c-dep-e:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = "alm"
                   c-dep-e:HIDDEN         IN FRAME {&FRAME-NAME} = NO
                   c-dep-e:SENSITIVE      IN FRAME {&FRAME-NAME} = YES.

            APPLY "entry" TO c-dep-e IN FRAME {&FRAME-NAME}.

            RETURN NO-APPLY.

        END.
        WHEN 3 THEN DO:

            ASSIGN c-codigo:HIDDEN      IN FRAME {&FRAME-NAME} = NO
                   c-codigo:SENSITIVE   IN FRAME {&FRAME-NAME} = YES.

            APPLY "entry" TO c-codigo IN FRAME {&FRAME-NAME}.

            RETURN NO-APPLY.

        END.

    END CASE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item C-Win
ON RETURN OF c-item IN FRAME f-cad /* Item */
DO:
  APPLY "tab" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item C-Win
ON TAB OF c-item IN FRAME f-cad /* Item */
DO:
  ASSIGN c-desc-item:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

  ASSIGN INPUT FRAME {&FRAME-NAME} c-item.


  RUN pi-devolucao.
  IF RETURN-VALUE = "NOK" OR RETURN-VALUE = "RETRY" THEN DO:
      APPLY "entry" TO c-item IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY. 
  END.
  ASSIGN c-item:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
         c-desc-item:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  APPLY "entry" TO c-item IN FRAME {&FRAME-NAME}.

  RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel C-Win
ON LEAVE OF fi-cod-estabel IN FRAME f-cad /* Estabelecimento */
DO:

    ASSIGN v_cod_estab_usuar = SELF:SCREEN-VALUE.

    RUN inicia.
    RUN atualizaEstabel IN hprog (INPUT SELF:SCREEN-VALUE).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-item
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.

  RUN conecta-rpc IN THIS-PROCEDURE (output hproc).
  IF RETURN-VALUE = "NOK" THEN DO:
      RUN ShowMessage (1, "Erro na conex∆o com o servidor RPC", 
                          "N∆o foi poss°vel conectar o servidor RPC. Entre em contato com o respons†vel em TI").
      APPLY "CLOSE":U TO THIS-PROCEDURE.
      QUIT.
  END.

  ASSIGN v_rotina_intelbras = "escep013".
 
  /*
  RUN esp/utp/esbtb910zz.w (INPUT hproc, INPUT "{&Program}|{&Version}").
  IF RETURN-VALUE = "NOK" THEN DO:
      RUN piDesconecta.
      APPLY "CLOSE":U TO THIS-PROCEDURE.
      QUIT.
  END.
  */
  
  C-Win:TITLE = replace(v_tit_prog_dtsul, "{&Version}", "{&Version} (SEM BANCOS)").

  /* Autenticaá∆o usu†rio TOTVS11 RPC - Carga das variaveis globais */
  create tt-control-prog.
  assign tt-control-prog.cod-versao-integracao = 1.
  
  assign tt-control-prog.wgh-servid-rpc = hproc.
  
  run btb/btb923za.p (input-output table tt-control-prog).
  /* FIM */
 
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY fi-cod-estabel c-etiqueta i-etiqueta 
      WITH FRAME f-cad IN WINDOW C-Win.
  ENABLE rt-button rtKeys-2 rtKeys-3 bt-novo btExit btHelp br-item 
      WITH FRAME f-cad IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimeEtiquetas C-Win 
PROCEDURE imprimeEtiquetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR c-format AS CHAR NO-UNDO.

  FIND FIRST tt-etiqueta NO-ERROR.
  IF AVAIL tt-etiqueta THEN DO:
      OUTPUT TO VALUE(v_nom_disposit_so).
      FOR EACH tt-etiqueta:
         c-format = "x(" + STRING(MAX(1, LENGTH(tt-etiqueta.linha))) + ")".
         PUT tt-etiqueta.linha FORMAT c-format SKIP.
      END.
      OUTPUT CLOSE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE infoDevolucao C-Win 
PROCEDURE infoDevolucao :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-impressora     as CHARACTER NO-UNDO.
    DEFINE VARIABLE c-arq            as CHARACTER NO-UNDO.
    DEFINE VARIABLE c-layout         as CHARACTER NO-UNDO.
    DEFINE VARIABLE c-novo-arq       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE first-time       AS LOGICAL   NO-UNDO INIT YES.  
    DEFINE VARIABLE fi-contenedor    AS INTEGER   FORMAT ">>>,>>9":U        INITIAL 0 LABEL "Contenedor" VIEW-AS FILL-IN SIZE 11 BY .88 NO-UNDO.
    DEFINE VARIABLE fi-nf            AS INTEGER   FORMAT ">>>>>9":U         INITIAL 0 LABEL "NF"         VIEW-AS FILL-IN SIZE 11 BY .88 NO-UNDO.
    DEFINE VARIABLE fi-quantidade    AS DECIMAL   FORMAT ">,>>>,>>9.9999":U INITIAL 0 LABEL "Quantidade" VIEW-AS FILL-IN SIZE 17 BY .88 NO-UNDO.
    DEFINE VARIABLE fi-roteiro       AS INTEGER   FORMAT "->,>>>,>>9":U     INITIAL 0 LABEL "Roteiro"    VIEW-AS FILL-IN SIZE 11 BY .88 NO-UNDO.
    DEFINE VARIABLE fi-local-saida   AS CHARACTER FORMAT "X(20)":U LABEL "Localizaá∆o Origem"  VIEW-AS FILL-IN SIZE 25 BY .88 NO-UNDO.   
    DEFINE VARIABLE fi-local-entrada AS CHARACTER FORMAT "X(20)":U LABEL "Localizaá∆o Destino" VIEW-AS FILL-IN SIZE 25 BY .88 NO-UNDO.
    DEFINE VARIABLE c-arquivo        AS CHARACTER VIEW-AS EDITOR MAX-CHARS 256 SIZE 33 BY .88 BGCOLOR 15  NO-UNDO.                           

    DEFINE BUTTON btConfigImpr IMAGE-UP FILE "image\im-cfprt":U LABEL "" SIZE 4 BY 1. 
    DEFINE BUTTON Btn_Cancel AUTO-END-KEY LABEL "Cancel" SIZE 10 BY 1 BGCOLOR 8 .
    DEFINE BUTTON Btn_OK     AUTO-GO      LABEL "OK"     SIZE 10 BY 1 BGCOLOR 8 .

    DEFINE RECTANGLE RECT-3 EDGE-PIXELS 2 GRAPHIC-EDGE         SIZE 55 BY 1.4 BGCOLOR 7 .
    DEFINE RECTANGLE RECT-4 EDGE-PIXELS 2 GRAPHIC-EDGE NO-FILL SIZE 55 BY 8.25.
    
    /* ************************  Frame Definitions  *********************** */
    
    DEFINE FRAME fDadosDev
         fi-quantidade AT ROW 1.75 COL 15 COLON-ALIGNED
         fi-local-saida AT ROW 2.75 COL 15 COLON-ALIGNED
         fi-local-entrada AT ROW 3.75 COL 15 COLON-ALIGNED
         fi-contenedor AT ROW 4.75 COL 15 COLON-ALIGNED
         fi-roteiro AT ROW 5.75 COL 15 COLON-ALIGNED
         fi-nf AT ROW 6.75 COL 15 COLON-ALIGNED
         btConfigImpr AT ROW 7.75 COL 50.25 HELP "Configuraá∆o da impressora"
         c-arquivo AT ROW 7.75 COL 15 COLON-ALIGNED HELP "Nome do arquivo de destino do relat¢rio" LABEL "Impressora"
         Btn_OK AT ROW 9.67 COL 2
         Btn_Cancel AT ROW 9.67 COL 12
         RECT-3 AT ROW 9.42 COL 1
         RECT-4 AT ROW 1 COL 1
         SPACE(0.42) SKIP(1.87)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1 TITLE "Dados Devoluá∆o" DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.
      
      ON  CHOOSE OF Btn_OK IN FRAME fDadosDev /* OK */ DO:
          ASSIGN INPUT FRAME fDadosDev fi-quantidade
                 INPUT FRAME fDadosDev fi-local-entrada
                 INPUT FRAME fDadosDev fi-local-saida
                 INPUT FRAME fDadosDev fi-contenedor
                 INPUT FRAME fDadosDev fi-nf
                 INPUT FRAME fDadosDev fi-roteiro.

          IF fi-quantidade <= 0  THEN DO:
              RUN ShowMessage (1, "Quantidade deve ser informada", "").
              APPLY "entry" TO fi-quantidade IN FRAME fDadosDev.
              RETURN NO-APPLY.
          END.

          IF fi-contenedor <= 0  THEN DO:
              RUN ShowMessage (1, "Contenedor deve ser informado", "").
              APPLY "entry" TO fi-contenedor IN FRAME fDadosDev.
              RETURN NO-APPLY.
          END.

          IF  c-deposito = "DEV" THEN DO:

              IF  fi-local-saida <> "EQF" 
              AND fi-local-saida <> "SUP" 
              AND fi-local-saida <> "MEC" 
              AND fi-local-saida <> "P&D" 
              AND fi-local-saida <> "MKT" 
              AND fi-local-saida <> "DOC" 
              AND fi-local-saida <> "INJ" 
              AND fi-local-saida <> "IP" THEN DO:
                  RUN ShowMessage (1, "Localizaá∆o Inv†lida. Consulte lista de localizaá‰es", "").
                  APPLY "entry" TO fi-local-saida IN FRAME fDadosDev.
                  RETURN NO-APPLY.
              END.
          END.

          IF fi-local-entrada = ""
          AND (c-dep-e NE "smd" and c-dep-e ne "iao" and c-dep-e ne "iac" and c-dep-e ne "ias" and c-dep-e ne "iat" and c-dep-e ne "cob")
          AND (c-deposito = "plc" 
              or c-deposito = "tel" 
              or c-deposito = "isf" 
              or c-deposito = "smd" 
              or c-deposito = "iao"
              or c-deposito = "iac"
              or c-deposito = "ias"
              or c-deposito = "iat"
              or c-deposito = "cob"
              or c-deposito = "inj" 
              or c-deposito = "esp" 
              or c-deposito = "cnt" 
              or c-deposito = "pci" 
              or c-deposito = "psf" 
              or c-deposito = "pes" 
              or c-deposito = "mes" 
              or c-deposito = "cst"
              or c-deposito = "sec") THEN DO:
              RUN ShowMessage (1, "Localizaá∆o de Destino n∆o informada", "Informe uma localizaá∆o de destino ou DEVOLUCAO").
              APPLY "entry" TO fi-local-entrada IN FRAME fDadosDev.
              RETURN NO-APPLY.
          END.

          IF fi-local-entrada NE "" AND fi-local-entrada NE "DEVOLUCAO" THEN DO:
              run inicia.
              RUN validaLocalEntrada IN hprog (INPUT fi-local-entrada, OUTPUT c-msg-erro).
              finaliza().
              IF RETURN-VALUE = "NOK" THEN DO:
                  RUN ShowMessage (1, entry(1, c-msg-erro, "|"), IF NUM-ENTRIES(c-msg-erro, "|") = 2 THEN entry(2, c-msg-erro, "|") ELSE "" ) .
                  APPLY "entry" TO fi-local-entrada IN FRAME fDadosDev.
                  RETURN NO-APPLY.
              END.
          END.
          ASSIGN i-quantidade  = fi-quantidade
                 c-localizacao = fi-local-saida
                 c-loc-dev     = fi-local-entrada
                 i-contenedor  = fi-contenedor
                 i-nf          = fi-nf
                 i-roteiro     = fi-roteiro.
      END.
    
      ON  CHOOSE OF btConfigImpr IN FRAME fDadosDev DO:
          IF  NOT VALID-HANDLE(hproc) THEN DO:
              IF  first-time THEN
                  RUN conecta-rpc IN THIS-PROCEDURE (output hproc).
              ELSE DO:
                  RUN mostraMensagemPanico.
                  QUIT.
              END.
          END.

          run esp/utp/esut-impr.w (input-output c-impressora, input-output c-layout, input-output c-arq, INPUT hproc).

          if c-arq = "" then
            assign c-novo-arq = c-impressora + ":" + c-layout.
          else
            assign c-novo-arq = c-impressora + ":" + c-layout + ":" + c-arq. 

          IF c-novo-arq NE "" THEN c-arquivo = c-novo-arq.
          ELSE c-arquivo = v_impres_layout.
          DISP c-arquivo WITH FRAME fDadosDev.
      END.

      ON CHOOSE OF Btn_Cancel IN FRAME fDadosDev 
      OR END-ERROR OF FRAME fDadosDev 
      OR ENDKEY OF FRAME fDadosDev ANYWHERE
      DO:
          RETURN "RETRY".
      END.

      ON 'leave':U OF fi-quantidade IN FRAME fDadosDev 
      DO:
          DISP INPUT fi-quantidade @ fi-contenedor WITH FRAME fDadosDev.
          RETURN.
      END.

      c-arquivo = v_impres_layout.
      if (c-dep-e = "smd" or c-dep-e = "iao" or c-dep-e = "iac" or c-dep-e = "ias" or c-dep-e = "iat" or c-dep-e = "cob") then assign fi-local-entrada = "".
      else  
      assign fi-local-entrada =  if (c-deposito = "plc" 
                          or c-deposito = "tel" 
                          or c-deposito = "isf" 
                          or c-deposito = "smd"  
                          or c-deposito = "iao"  
                          or c-deposito = "iac"  
                          or c-deposito = "ias"  
                          or c-deposito = "iat"  
                          or c-deposito = "cob"  
                          or c-deposito = "inj" 
                          or c-deposito = "esp" 
                          or c-deposito = "cnt" 
                          or c-deposito = "pci" 
                          or c-deposito = "psf" 
                          or c-deposito = "pes" 
                          or c-deposito = "mes" 
                          or c-deposito = "cst"
                          or c-deposito = "sec"
                          or c-deposito = "dsk"
                          OR c-deposito = "int") then "DEVOLUCAO" else "".

      run inicia.
      RUN recuperaRoteiro IN hprog (INPUT INPUT FRAME f-cad fi-cod-estabel,
                                    INPUT  c-item,   
                                    INPUT  c-deposito,
                                    INPUT  v_cod_usuar_corren,
                                    OUTPUT fi-roteiro,
                                    OUTPUT fi-nf,     
                                    OUTPUT c-desc-item) NO-ERROR.

      finaliza().

      DISP c-desc-item WITH FRAME {&FRAME-NAME}.
      DISPLAY fi-quantidade fi-local-entrada fi-contenedor fi-roteiro fi-nf btConfigImpr c-arquivo WITH FRAME fDadosDev.
      ENABLE fi-quantidade fi-local-entrada fi-contenedor fi-roteiro fi-nf btConfigImpr Btn_OK Btn_Cancel WITH FRAME fDadosDev.

      IF c-deposito = "HML"
      OR c-deposito = "DEV" THEN ENABLE fi-local-saida WITH FRAME fDadosDev.

      VIEW FRAME fDadosDev.
    
      WAIT-FOR GO OF FRAME fDadosDev.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE infoParcial C-Win 
PROCEDURE infoParcial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-impressora    as char no-undo.
    def var c-arq           as char no-undo.
    def var c-layout        as char no-undo.
    DEF VAR c-novo-arq      AS CHAR NO-UNDO.
    DEF VAR first-time AS LOGICAL NO-UNDO INIT YES.  

    DEFINE VARIABLE c-arquivo AS CHARACTER 
         VIEW-AS EDITOR MAX-CHARS 256
         SIZE 33 BY .88
         BGCOLOR 15  NO-UNDO.
    
    DEFINE BUTTON btConfigImpr 
         IMAGE-UP FILE "image\im-cfprt":U
         LABEL "" 
         SIZE 4 BY 1.
    
    DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
         LABEL "Cancel" 
         SIZE 10 BY 1
         BGCOLOR 8 .

    DEFINE BUTTON Btn_OK AUTO-GO 
         LABEL "OK" 
         SIZE 10 BY 1
         BGCOLOR 8 .
    
    DEFINE VARIABLE fi-contenedor AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
         LABEL "Contenedor" 
         VIEW-AS FILL-IN 
         SIZE 11 BY .88 NO-UNDO.
    
    DEFINE VARIABLE fi-quantidade AS DECIMAL FORMAT ">,>>>,>>9.9999":U INITIAL 0 
         LABEL "Quantidade" 
         VIEW-AS FILL-IN 
         SIZE 17 BY .88 NO-UNDO.
    
    DEFINE RECTANGLE RECT-3
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 55 BY 1.4
         BGCOLOR 7 .
    
    DEFINE RECTANGLE RECT-4
         EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
         SIZE 55 BY 5.25.
    
    
    /* ************************  Frame Definitions  *********************** */
    DEFINE FRAME fDadosPar
         fi-quantidade AT ROW 1.75 COL 15 COLON-ALIGNED
         fi-contenedor AT ROW 2.75 COL 15 COLON-ALIGNED
         btConfigImpr AT ROW 4.75 COL 50.25 HELP
             "Configuraá∆o da impressora"
         c-arquivo AT ROW 4.75 COL 15 COLON-ALIGNED HELP
             "Nome do arquivo de destino do relat¢rio" LABEL "Impressora"
         Btn_OK AT ROW 6.67 COL 2
         Btn_Cancel AT ROW 6.67 COL 12
         RECT-3 AT ROW 6.42 COL 1
         RECT-4 AT ROW 1 COL 1
         SPACE(0.42) SKIP(1.87)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1
             TITLE "Dados Parcial"
             DEFAULT-BUTTON Btn_Ok CANCEL-BUTTON Btn_Cancel.

      ON 'F2' OF FRAME fDadosPar 
      DO:
          RETURN NO-APPLY.
      END.

      ON CHOOSE OF Btn_OK IN FRAME fDadosPar /* OK */DO:
          ASSIGN INPUT FRAME fDadosPar fi-quantidade 
                 INPUT FRAME fDadosPar fi-contenedor.

          IF fi-quantidade <= 0  THEN DO:
              RUN ShowMessage (1, "Quantidade deve ser informada", "").
              APPLY "entry" TO fi-quantidade IN FRAME fDadosPar.
              RETURN NO-APPLY.
          END.
          
          IF fi-contenedor <= 0  THEN DO:
              RUN ShowMessage (1, "Contenedor deve ser informado", "").
              APPLY "entry" TO fi-contenedor IN FRAME fDadosPar.
              RETURN NO-APPLY.
          END.

          IF  i-quantidade <= fi-quantidade 
          AND i-quantidade > 0 THEN DO:
               RUN ShowMessage (1, "Quantidade deve ser menor igual a quantidade lida", 
                                SUBSTITUTE("Quantidade lida: &1", trim(c-quantidade))).
               APPLY "entry" TO fi-quantidade IN FRAME fDadosPar.
               RETURN NO-APPLY.
          END.

          ASSIGN i-quantidade = fi-quantidade
                 i-contenedor = fi-contenedor.

      END.
    
      ON CHOOSE OF btConfigImpr IN FRAME fDadosPar
      DO:
          IF NOT VALID-HANDLE(hproc) THEN DO:
              IF first-time THEN
                  RUN conecta-rpc IN THIS-PROCEDURE (output hproc).
              ELSE DO:
                  RUN mostraMensagemPanico.
                  QUIT.
              END.
          END.

          run esp/utp/esut-impr.w (input-output c-impressora, input-output c-layout, input-output c-arq, INPUT hproc).

          if c-arq = "" then
            assign c-novo-arq = c-impressora + ":" + c-layout.
          else
            assign c-novo-arq = c-impressora + ":" + c-layout + ":" + c-arq. 

          IF c-novo-arq NE "" THEN c-arquivo = c-novo-arq.
          ELSE c-arquivo = v_impres_layout.
          DISP c-arquivo WITH FRAME fDadosPar.
      END.

      ON CHOOSE OF Btn_Cancel IN FRAME fDadosPar 
      OR END-ERROR OF FRAME fDadosPar 
      OR ENDKEY OF FRAME fDadosPar ANYWHERE
      DO:
          RETURN "RETRY".
      END.

      ASSIGN c-arquivo     = v_impres_layout
             fi-contenedor = i-quantidade.

      DISPLAY fi-quantidade fi-contenedor btConfigImpr c-arquivo
          WITH FRAME fDadosPar.
      ENABLE fi-quantidade fi-contenedor btConfigImpr Btn_OK Btn_Cancel 
          WITH FRAME fDadosPar.

      VIEW FRAME fDadosPar.
    
      WAIT-FOR GO OF FRAME fDadosPar.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicia C-Win 
PROCEDURE inicia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR first-time AS LOGICAL NO-UNDO INIT YES.  

  DO WHILE NOT VALID-HANDLE(hprog):
      RUN {&RPC-CALL} PERSISTENT SET hprog ON SERVER hproc TRANSACTION DISTINCT NO-ERROR.
      IF NOT VALID-HANDLE(hproc) THEN DO:
          IF first-time THEN
              RUN conecta-rpc IN THIS-PROCEDURE (output hproc).
          ELSE DO:
              RUN mostraMensagemPanico.
              QUIT.
          END.
      END.
      IF VALID-HANDLE(hprog) THEN RETURN.
      PAUSE 1.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mostra-narrativa C-Win 
PROCEDURE mostra-narrativa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR i AS INTEGER NO-UNDO.

    DEFINE BUTTON Btn_OK AUTO-GO 
         LABEL "OK" 
         SIZE 12 BY 1
         BGCOLOR 8 .
    
    DEFINE RECTANGLE RECT-1
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 64.14 BY 1.5
         BGCOLOR 7 .
    
    DEFINE RECTANGLE RECT-2
         EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
         SIZE 64.14 BY 5.
    
    /* ************************  Frame Definitions  *********************** */
    
    DEFINE FRAME fNarrativa
         c-narrativa[1] AT ROW 1.75 COL 6 COLON-ALIGNED NO-LABEL
              VIEW-AS FILL-IN 
              SIZE 51.14 BY .88
         c-narrativa[2] AT ROW 2.75 COL 6 COLON-ALIGNED NO-LABEL
              VIEW-AS FILL-IN 
              SIZE 51.14 BY .88
         c-narrativa[3] AT ROW 3.75 COL 6 COLON-ALIGNED NO-LABEL
              VIEW-AS FILL-IN 
              SIZE 51.14 BY .88
         c-narrativa[4] AT ROW 4.75 COL 6 COLON-ALIGNED NO-LABEL
              VIEW-AS FILL-IN 
              SIZE 51.14 BY .88
         Btn_OK AT ROW 6.54 COL 2.14
         RECT-1 AT ROW 6.25 COL 1
         RECT-2 AT ROW 1.13 COL 1
         "Narrativa" VIEW-AS TEXT
              SIZE 7 BY .54 AT ROW 1 COL 2
         SPACE(56.13) SKIP(6.20)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1
             TITLE "Narrativa AE Bloqueado"
             DEFAULT-BUTTON Btn_OK.

    DO i = 1 TO 4:
        c-narrativa[i] = ENTRY(i, v-narrativa, "|").
    END.
    
    DISPLAY c-narrativa[1] c-narrativa[2] 
          c-narrativa[3] c-narrativa[4] 
      WITH FRAME fNarrativa.
    ENABLE /*c-narrativa[1] c-narrativa[2] 
         c-narrativa[3] c-narrativa[4]*/ Btn_OK RECT-1 
         RECT-2 
      WITH FRAME fNarrativa.
    VIEW FRAME fNarrativa.
              
    WAIT-FOR GO OF FRAME fNarrativa.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mostraMensagemPanico C-Win 
PROCEDURE mostraMensagemPanico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN ShowMessage (1, "Erro na execuá∆o", 
                      "Ocorreu um erro durante a execuá∆o de um procedimento " +
                      "remoto que impede que esta operaá∆o continue.~n" +
                      "Por favor repita esta operaá∆o mais tarde").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-devolucao C-Win 
PROCEDURE pi-devolucao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN infoDevolucao.

  IF RETURN-VALUE = "RETRY" THEN
      RETURN "RETRY".

  run inicia.

  RUN validaEtiqueta IN hprog
      (INPUT NO,
       INPUT INPUT FRAME f-cad fi-cod-estabel,
       INPUT c-etiqueta,
       INPUT v_cod_usuar_corren,
       OUTPUT c-deposito,
       OUTPUT c-msg-erro).

  IF RETURN-VALUE = "NOK" THEN DO:
      finaliza().
      IF c-msg-erro > "" THEN DO:
          RUN ShowMessage (1, entry(1, c-msg-erro, "|"), 
                           IF NUM-ENTRIES(c-msg-erro, "|") = 2 THEN entry(2, c-msg-erro, "|") ELSE "" ) .
      END.
      RETURN "NOK". 
  END.

  RUN validaDevolucao IN hprog 
      (INPUT INPUT FRAME f-cad fi-cod-estabel,
       INPUT v_cod_usuar_corren,
       INPUT c-deposito,
       INPUT c-dep-e,
       INPUT c-item,
       INPUT i-roteiro,
       INPUT c-localizacao,
       INPUT i-quantidade,
       OUTPUT c-msg-erro).

  IF RETURN-VALUE = "NOK" THEN DO:
      finaliza().
      IF c-msg-erro > "" THEN DO:
          RUN ShowMessage (1, entry(1, c-msg-erro, "|"), 
                           IF NUM-ENTRIES(c-msg-erro, "|") = 2 THEN entry(2, c-msg-erro, "|") ELSE "" ) .
      END.
      RETURN "NOK". 
  END.
  IF c-msg-erro NE "" THEN DO:
      RUN ShowMessage (2, entry(1, c-msg-erro, "|"), 
                       IF NUM-ENTRIES(c-msg-erro, "|") = 2 THEN entry(2, c-msg-erro, "|") ELSE "" ).
  END.

  RUN atualizaLocalEntrada IN hprog (INPUT c-loc-dev).

  /* Autenticaá∆o usu†rio TOTVS11 RPC - Carga das variaveis globais */
  /* Necessario devido a chamada do es0478 */
  create tt-control-prog.
  assign tt-control-prog.cod-versao-integracao = 1.
  
  assign tt-control-prog.wgh-servid-rpc = hproc.
  
  run btb/btb923za.p (input-output table tt-control-prog).
  /* FIM */
  
  RUN efetivaDevolucao IN hprog 
      (INPUT i-nf,
       INPUT i-contenedor,
       INPUT v_cod_usuar_corren + "-" + c-etiqueta,
       input v_nom_disposit_so,
       OUTPUT c-msg-erro).

  IF RETURN-VALUE = "NOK" THEN DO:
      finaliza().
      IF c-msg-erro > "" THEN DO:
          RUN ShowMessage (1, entry(1, c-msg-erro, "|"), 
                           IF NUM-ENTRIES(c-msg-erro, "|") = 2 THEN entry(2, c-msg-erro, "|") ELSE "" ) .
      END.
      RETURN "NOK". 
  END.

  RUN recuperaTT-Etiqueta IN hprog (OUTPUT TABLE tt-etiqueta).

  finaliza().

  RUN imprimeEtiquetas.
  
  RETURN "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-parcial C-Win 
PROCEDURE pi-parcial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN infoParcial.
  IF RETURN-VALUE = "RETRY" THEN 
      RETURN "RETRY".

  run inicia.
  RUN validaEtiqueta IN hprog
      (INPUT YES,
       INPUT INPUT FRAME f-cad fi-cod-estabel,
       INPUT c-etiqueta,
       INPUT v_cod_usuar_corren,
       OUTPUT c-deposito,
       OUTPUT c-msg-erro).

  IF RETURN-VALUE = "NOK" THEN DO:
      finaliza().
      IF c-msg-erro > "" THEN DO:
          RUN ShowMessage (1, entry(1, c-msg-erro, "|"), 
                           IF NUM-ENTRIES(c-msg-erro, "|") = 2 THEN entry(2, c-msg-erro, "|") ELSE "" ) .
      END.
      RETURN "NOK". 
  END.

  RUN validaParcial IN hprog 
      (INPUT INPUT FRAME f-cad fi-cod-estabel,
       INPUT v_cod_usuar_corren,
       INPUT c-codigo,
       INPUT c-deposito,
       OUTPUT c-msg-erro).

  IF RETURN-VALUE = "NOK" THEN DO:
      
      IF c-msg-erro BEGINS "AE BLOQUEADO" THEN DO:
          RUN recuperaNarrativa IN hprog (OUTPUT v-narrativa).
          RUN mostra-narrativa.
      END.
      ELSE IF c-msg-erro > "" THEN DO:
          RUN ShowMessage (1, entry(1, c-msg-erro, "|"), 
                           IF NUM-ENTRIES(c-msg-erro, "|") = 2 THEN entry(2, c-msg-erro, "|") ELSE "" ) .
      END.
      finaliza().
      RETURN "NOK". 
  END.
  IF c-msg-erro NE "" THEN DO:
      RUN ShowMessage (2, entry(1, c-msg-erro, "|"), 
                       IF NUM-ENTRIES(c-msg-erro, "|") = 2 THEN entry(2, c-msg-erro, "|") ELSE "" ).
  END.

  /* Autenticaá∆o usu†rio TOTVS11 RPC - Carga das variaveis globais */
  /* Necessario devido a chamada do es0478 */
  create tt-control-prog.
  assign tt-control-prog.cod-versao-integracao = 1.
  
  assign tt-control-prog.wgh-servid-rpc = hproc.
  
  run btb/btb923za.p (input-output table tt-control-prog).
  /* FIM */
  
  RUN efetivaParcial IN hprog 
      (INPUT i-quantidade,
       INPUT i-contenedor,
       INPUT v_cod_usuar_corren + "-" + c-etiqueta,
       input v_nom_disposit_so,
       OUTPUT c-msg-erro).

  IF RETURN-VALUE = "NOK" THEN DO:
      finaliza().
      IF c-msg-erro > "" THEN DO:
          RUN ShowMessage (1, entry(1, c-msg-erro, "|"), 
                           IF NUM-ENTRIES(c-msg-erro, "|") = 2 THEN entry(2, c-msg-erro, "|") ELSE "" ) .
      END.
      RETURN "NOK". 
  END.

  RUN recuperaTT-Item IN hprog (OUTPUT TABLE tt-item-unique).
  RUN recuperaTT-Etiqueta IN hprog (OUTPUT TABLE tt-etiqueta).
  finaliza().

  RUN imprimeEtiquetas.

  ASSIGN c-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
         i-etiqueta = i-etiqueta + 1.

  FIND FIRST tt-item-unique NO-ERROR.
  IF AVAIL tt-item-unique THEN DO:
      CREATE tt-item.
      BUFFER-COPY tt-item-unique TO tt-item.
      DELETE tt-item-unique.
      {&OPEN-QUERY-br-item}

      DISP i-etiqueta
          WITH FRAME {&FRAME-NAME}.
  END.

  APPLY "ENTRY" TO c-codigo.

  RETURN "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pre-formados C-Win 
PROCEDURE pi-pre-formados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN inicia.
  RUN validaPreFormados IN hprog 
      (INPUT INPUT FRAME f-cad fi-cod-estabel,
       INPUT v_cod_usuar_corren,
       INPUT c-codigo,
       OUTPUT c-msg-erro).

  IF RETURN-VALUE = "NOK" THEN DO:
   
      IF c-msg-erro BEGINS "AE BLOQUEADO" THEN DO:
          RUN recuperaNarrativa IN hprog (OUTPUT v-narrativa).
          RUN mostra-narrativa.
      END.
      ELSE IF c-msg-erro > "" THEN DO:
          RUN ShowMessage (1, entry(1, c-msg-erro, "|"), 
                           IF NUM-ENTRIES(c-msg-erro, "|") = 2 THEN entry(2, c-msg-erro, "|") ELSE "" ) .
      END.
      finaliza().
      RETURN "NOK". 
  END.
  IF c-msg-erro NE "" THEN DO:
      RUN ShowMessage (2, entry(1, c-msg-erro, "|"), 
                       IF NUM-ENTRIES(c-msg-erro, "|") = 2 THEN entry(2, c-msg-erro, "|") ELSE "" ).
  END.

  /* Autenticaá∆o usu†rio TOTVS11 RPC - Carga das variaveis globais */
  /* Necessario devido a chamada do es0478 */
  create tt-control-prog.
  assign tt-control-prog.cod-versao-integracao = 1.
  
  assign tt-control-prog.wgh-servid-rpc = hproc.
  
  run btb/btb923za.p (input-output table tt-control-prog).
  /* FIM */
  
  RUN efetivaPreFormados IN hprog 
      (INPUT v_nom_disposit_so,
       OUTPUT c-msg-erro).

  IF RETURN-VALUE = "NOK" THEN DO:
      finaliza().
      IF c-msg-erro > "" THEN DO:
          RUN ShowMessage (1, entry(1, c-msg-erro, "|"), 
                           IF NUM-ENTRIES(c-msg-erro, "|") = 2 THEN entry(2, c-msg-erro, "|") ELSE "" ) .
      END.
      RETURN "NOK". 
  END.

  RUN recuperaTT-Item IN hprog (OUTPUT TABLE tt-item-unique).
  RUN recuperaTT-Etiqueta IN hprog (OUTPUT TABLE tt-etiqueta).
  finaliza().

  RUN imprimeEtiquetas.

  ASSIGN c-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
         i-etiqueta = i-etiqueta + 1.

  FIND FIRST tt-item-unique NO-ERROR.
  IF AVAIL tt-item-unique THEN DO:
      CREATE tt-item.
      BUFFER-COPY tt-item-unique TO tt-item.
      DELETE tt-item-unique.
      {&OPEN-QUERY-br-item}

      DISP i-etiqueta
          WITH FRAME {&FRAME-NAME}.
  END.

  APPLY "ENTRY" TO c-codigo.

  RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-transferencia C-Win 
PROCEDURE pi-transferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  run inicia.

  RUN validaEtiqueta IN hprog
      (INPUT YES,
       INPUT INPUT FRAME f-cad fi-cod-estabel, 
       INPUT c-etiqueta,
       INPUT v_cod_usuar_corren,
       OUTPUT c-deposito,
       OUTPUT c-msg-erro).
  
  IF RETURN-VALUE = "NOK" THEN DO:
      finaliza().
      IF c-msg-erro > "" THEN DO:
          RUN ShowMessage (1, entry(1, c-msg-erro, "|"), 
                           IF NUM-ENTRIES(c-msg-erro, "|") = 2 THEN entry(2, c-msg-erro, "|") ELSE "" ) .
      END.
      RETURN "NOK". 
  END.

  
  RUN validaTransferencia IN hprog 
      (INPUT INPUT FRAME f-cad fi-cod-estabel,
       INPUT v_cod_usuar_corren,
       INPUT c-codigo,
       INPUT c-deposito,
       OUTPUT c-msg-erro).

  
  IF RETURN-VALUE = "NOK" THEN DO:
      
      IF c-msg-erro BEGINS "AE BLOQUEADO" THEN DO:
          RUN recuperaNarrativa IN hprog (OUTPUT v-narrativa).
          RUN mostra-narrativa.
      END.
      ELSE IF c-msg-erro > "" THEN DO:
          RUN ShowMessage (1, entry(1, c-msg-erro, "|"),
                           IF NUM-ENTRIES(c-msg-erro, "|") = 2 THEN entry(2, c-msg-erro, "|") ELSE "" ) .
      END.
      finaliza().
      RETURN "NOK".
  END.
  IF c-msg-erro NE "" THEN DO:
      RUN ShowMessage (2, entry(1, c-msg-erro, "|"), 
                       IF NUM-ENTRIES(c-msg-erro, "|") = 2 THEN entry(2, c-msg-erro, "|") ELSE "" ).
  END.

  /* Autenticaá∆o usu†rio TOTVS11 RPC - Carga das variaveis globais */
  /* Necessario devido a chamada do es0478 */
  create tt-control-prog.
  assign tt-control-prog.cod-versao-integracao = 1.
  
  assign tt-control-prog.wgh-servid-rpc = hproc.
  
  run btb/btb923za.p (input-output table tt-control-prog).
  /* FIM */
  
  RUN efetivaTransferencia IN hprog 
      (INPUT v_cod_usuar_corren + "-" + c-etiqueta,
       input v_nom_disposit_so,
       OUTPUT c-msg-erro).

  IF RETURN-VALUE = "NOK" THEN DO:
      finaliza().
      IF c-msg-erro > "" THEN DO:
          RUN ShowMessage (1, entry(1, c-msg-erro, "|"), 
                           IF NUM-ENTRIES(c-msg-erro, "|") = 2 THEN entry(2, c-msg-erro, "|") ELSE "" ) .
      END.
      RETURN "NOK". 
  END.

  RUN recuperaTT-Item IN hprog (OUTPUT TABLE tt-item-unique).
  RUN recuperaTT-Etiqueta IN hprog (OUTPUT TABLE tt-etiqueta).
  finaliza().

  RUN imprimeEtiquetas.

  ASSIGN c-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
         i-etiqueta = i-etiqueta + 1.

  FIND FIRST tt-item-unique NO-ERROR.
  IF AVAIL tt-item-unique THEN DO:
      CREATE tt-item.
      BUFFER-COPY tt-item-unique TO tt-item.
      DELETE tt-item-unique.
      {&OPEN-QUERY-br-item}

      DISP i-etiqueta
          WITH FRAME {&FRAME-NAME}.
  END.

  APPLY "ENTRY" TO c-codigo.
  
  RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDesconecta C-Win 
PROCEDURE piDesconecta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF VALID-HANDLE(hprog) THEN DO:
       DELETE PROCEDURE hprog.
       hprog = ?.
   END.
    
   RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
   hproc = ?.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION finaliza C-Win 
FUNCTION finaliza RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF VALID-HANDLE(hprog) THEN DO:
      DELETE PROCEDURE hprog.
      hprog = ?.
  END.

  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

