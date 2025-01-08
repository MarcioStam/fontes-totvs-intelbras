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

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
DEF VAR hproc AS HANDLE NO-UNDO.
DEF VAR hprog AS HANDLE NO-UNDO.

&SCOPED-DEFINE TESTE 
&SCOPED-DEFINE SERVIDOR-PRODUCAO rpc22pr   

DEF VAR op AS INT.

{esp/utp/esutp001.i}

DEFINE TEMP-TABLE tt-impressao LIKE tt-tarifador.
    
DEF BUFFER b-tt-tarifador FOR tt-tarifador.

DEF VAR v-id    AS CHAR NO-UNDO.
DEF VAR v-ramal AS CHARACTER FORMAT "x(20)" LABEL "Ramal" VIEW-AS FILL-IN SIZE 21 BY 0.88.
DEF VAR v-numero AS CHARACTER FORMAT "x(40)" LABEL "N£mero" VIEW-AS FILL-IN SIZE 41 BY 0.88.
DEF VAR v-mestre AS LOGICAL NO-UNDO.
DEF VAR v-alterado AS LOGICAL NO-UNDO.

define var c-empresa       as character format "x(40)"      no-undo.
define var c-titulo-relat  as character format "x(50)"      no-undo.
define var c-sistema       as character format "x(25)"      no-undo.
define var i-numper-x      as integer   format "ZZ"         no-undo.
define var da-iniper-x     as date      format "99/99/9999" no-undo.
define var da-fimper-x     as date      format "99/99/9999" no-undo.
define var c-rodape        as character                     no-undo.
define var v_num_count     as integer                       no-undo.
define var c-arq-control   as character                     no-undo.
define var i-page-size-rel as integer                       no-undo.
define var c-programa      as character format "x(08)"      no-undo.
define var c-versao        as character format "x(04)"      no-undo.
define var c-revisao       as character format "999"        no-undo.
define var c-impressora   as character                      no-undo.
define var c-layout       as character                      no-undo.
DEF VAR c-prg-obj AS CHAR NO-UNDO.
DEF VAR c-prg-vrs AS CHAR NO-UNDO.

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Conferància de Ligaá∆o Telefìnica"
       c-empresa      = 'Intelbras S/A - Ind.Tel.Eletr.Brasileira'
       c-programa     = "ESUTP001"
       c-versao       = "2.04"
       c-revisao      = "000"
       c-prg-obj      = c-programa
       c-prg-vrs      = c-versao + "." + c-revisao.

form header
    fill("-", 132) format "x(132)" skip
    c-empresa c-titulo-relat 
    "P†gina:":U at 120 page-number  at 128 format ">>>>9" skip
    fill("-", 112) format "x(110)" today format "99/99/9999"
    "-" string(time, "HH:MM:SS":U) skip(1)
    with stream-io width 132 no-labels no-box page-top frame f-cabec.

c-rodape = "DATASUL - ":U + c-sistema + " - " + c-prg-obj + " - V:":U + c-prg-vrs.
c-rodape = fill("-", 132 - length(c-rodape)) + c-rodape.

form header
    c-rodape format "x(132)"
    with stream-io width 132 no-labels no-box page-bottom frame f-rodape.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BROWSE-9

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-tarifador

/* Definitions for BROWSE BROWSE-9                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-9 tt-tarifador.tipo tt-tarifador.data tt-tarifador.hora tt-tarifador.numero tt-tarifador.localidade tt-tarifador.uf tt-tarifador.finalidade tt-tarifador.avaliado tt-tarifador.valor tt-tarifador.duracao tt-tarifador.ramal   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-9   
&Scoped-define SELF-NAME BROWSE-9
&Scoped-define QUERY-STRING-BROWSE-9 FOR EACH tt-tarifador      by tt-tarifador.tipo by tt-tarifador.data by tt-tarifador.hora
&Scoped-define OPEN-QUERY-BROWSE-9 OPEN QUERY BROWSE-9 FOR EACH tt-tarifador      by tt-tarifador.tipo by tt-tarifador.data by tt-tarifador.hora.
&Scoped-define TABLES-IN-QUERY-BROWSE-9 tt-tarifador
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-9 tt-tarifador


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btLogin btExit btHelp BROWSE-9 ~
fi-valor-total 
&Scoped-Define DISPLAYED-OBJECTS fi-valor-total 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-BROWSE-9 
       MENU-ITEM m_Cadastrar_na_Agenda LABEL "Cadastrar na Agenda".


/* Definitions of the field level widgets                               */
DEFINE BUTTON btAgenda 
     IMAGE-UP FILE "image/im-ampr3.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Agenda de Telefones"
     FONT 4.

DEFINE BUTTON btAutomatico 
     LABEL "Autom†tico" 
     SIZE 9.14 BY 1 TOOLTIP "Faz cobranáa autom†tica atravÇs da agenda".

DEFINE BUTTON btEstornar 
     LABEL "Estornar" 
     SIZE 7.29 BY 1 TOOLTIP "Estornar cobranáas j† avaliadas".

DEFINE BUTTON btExcel 
     IMAGE-UP FILE "image/excel.bmp":U
     LABEL "Exporta Excel" 
     SIZE 4 BY 1.25 TOOLTIP "Exporta em formato para excel"
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25 TOOLTIP "Sair"
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25 TOOLTIP "Ajuda"
     FONT 4.

DEFINE BUTTON btLogin 
     IMAGE-UP FILE "image/im-fornec.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Login"
     FONT 4.

DEFINE BUTTON btNumero 
     LABEL "&N£mero" 
     SIZE 8 BY 1 TOOLTIP "N£mero".

DEFINE BUTTON btParticular 
     LABEL "Particular" 
     SIZE 8 BY 1 TOOLTIP "Particular".

DEFINE BUTTON btRamal 
     LABEL "&Ramal" 
     SIZE 8 BY 1 TOOLTIP "Ramal".

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25 TOOLTIP "Relat¢rio das Ligaá‰es Avaliadas"
     FONT 4.

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25 TOOLTIP "Confirma alteraá‰es"
     FONT 4.

DEFINE BUTTON btServico 
     LABEL "Serviáo" 
     SIZE 8 BY 1 TOOLTIP "Serviáo".

DEFINE BUTTON btTodos 
     LABEL "Tudo Particular" 
     SIZE 11 BY 1 TOOLTIP "Tudo Particular".

DEFINE BUTTON btTodos-2 
     LABEL "Tudo Serviáo" 
     SIZE 11 BY 1 TOOLTIP "Tudo Serviáo".

DEFINE VARIABLE fi-valor-total AS DECIMAL FORMAT ">>>>,>>9.99" INITIAL 0 
     LABEL "Valor Total R$" 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 110 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-9 FOR 
      tt-tarifador SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-9 C-Win _FREEFORM
  QUERY BROWSE-9 DISPLAY
      tt-tarifador.tipo WIDTH 3.5
     tt-tarifador.data       
     tt-tarifador.hora WIDTH 6
     tt-tarifador.numero WIDTH 13    
     tt-tarifador.localidade FORMAT "x(80)" WIDTH 35
     tt-tarifador.uf WIDTH 2.3       
     tt-tarifador.finalidade 
     tt-tarifador.avaliado COLUMN-LABEL "Conf"  
     tt-tarifador.valor
     tt-tarifador.duracao
     tt-tarifador.ramal COLUMN-LABEL "Ramal" WIDTH 8.75
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 109.57 BY 12.29
         FONT 1
         TITLE "Tarifador" TOOLTIP "Duplo-clique para alterar finalidade".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btSave AT ROW 1.13 COL 1.57 HELP
          "Confirma alteraá‰es"
     btAgenda AT ROW 1.13 COL 86.43 HELP
          "Agenda de Telefones" WIDGET-ID 8
     btExcel AT ROW 1.13 COL 90.57 HELP
          "Exporta dados em formato excel" WIDGET-ID 10
     btReportsJoins AT ROW 1.13 COL 94.57 HELP
          "Relat¢rio das Ligaá‰es do Usu†rio"
     btLogin AT ROW 1.13 COL 98.57 HELP
          "Login"
     btExit AT ROW 1.13 COL 102.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 106.57 HELP
          "Ajuda"
     BROWSE-9 AT ROW 2.88 COL 1.57 HELP
          "Duplo-clique para alterar finalidade"
     btRamal AT ROW 15.25 COL 8.72 RIGHT-ALIGNED
     btNumero AT ROW 15.25 COL 16.86 RIGHT-ALIGNED
     btParticular AT ROW 15.25 COL 27.29 RIGHT-ALIGNED
     btServico AT ROW 15.25 COL 35.43 RIGHT-ALIGNED
     btTodos AT ROW 15.25 COL 46.72 RIGHT-ALIGNED
     btTodos-2 AT ROW 15.25 COL 57.86 RIGHT-ALIGNED
     btEstornar AT ROW 15.25 COL 69.72 RIGHT-ALIGNED HELP
          "Estornar cobranáas j† avaliadas" WIDGET-ID 6
     btAutomatico AT ROW 15.25 COL 79 RIGHT-ALIGNED HELP
          "Faz cobranáa autom†tica atravÇs da agenda" WIDGET-ID 4
     fi-valor-total AT ROW 15.25 COL 110.01 RIGHT-ALIGNED NO-TAB-STOP 
     "CCR-Celular Regional   CCE-Celular Estadual   CCN-Celular Nacional" VIEW-AS TEXT
          SIZE 67.29 BY 1 AT ROW 1.29 COL 7.29 WIDGET-ID 12
          BGCOLOR 7 FGCOLOR 14 FONT 3
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 110.57 BY 15.54
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Conferància de Ligaá∆o Telefìnica - ESUTP001 - 2.04.00.000"
         HEIGHT             = 15.54
         WIDTH              = 110.57
         MAX-HEIGHT         = 39.79
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 39.79
         VIRTUAL-WIDTH      = 182.86
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 1
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT C-Win:LOAD-ICON("image/monitor.ico":U) THEN
    MESSAGE "Unable to load icon: image/monitor.ico"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

{esp/es0018.i}
{esp/utp/acesso-rpc.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-9 btHelp DEFAULT-FRAME */
ASSIGN 
       BROWSE-9:POPUP-MENU IN FRAME DEFAULT-FRAME             = MENU POPUP-MENU-BROWSE-9:HANDLE
       BROWSE-9:COLUMN-RESIZABLE IN FRAME DEFAULT-FRAME       = TRUE.

/* SETTINGS FOR BUTTON btAgenda IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btAutomatico IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR BUTTON btEstornar IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR BUTTON btExcel IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btNumero IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR BUTTON btParticular IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR BUTTON btRamal IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR BUTTON btReportsJoins IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btSave IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btServico IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR BUTTON btTodos IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR BUTTON btTodos-2 IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN fi-valor-total IN FRAME DEFAULT-FRAME
   ALIGN-R                                                              */
ASSIGN 
       fi-valor-total:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-9
/* Query rebuild information for BROWSE BROWSE-9
     _START_FREEFORM
OPEN QUERY BROWSE-9 FOR EACH tt-tarifador
     by tt-tarifador.tipo by tt-tarifador.data by tt-tarifador.hora.
     _END_FREEFORM
     _Query            is NOT OPENED
*/  /* BROWSE BROWSE-9 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Conferància de Ligaá∆o Telefìnica - ESUTP001 - 2.04.00.000 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Conferància de Ligaá∆o Telefìnica - ESUTP001 - 2.04.00.000 */
DO:
  /* This event will close the window and terminate the procedure.  */
  IF v-alterado THEN DO:
      RUN pi-message(3, "Descarta alteraá‰es?",
                     "Foram efetuadas alteraá‰es nos registros. Deseja descart†-las?").
      IF RETURN-VALUE = "no" THEN RETURN NO-APPLY.
  END.

  RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
  hproc = ?.

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  QUIT.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-9
&Scoped-define SELF-NAME BROWSE-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-9 C-Win
ON F3 OF BROWSE-9 IN FRAME DEFAULT-FRAME /* Tarifador */
DO:
    IF v-mestre AND AVAIL tt-tarifador THEN DO:
        IF v-alterado THEN DO:
            RUN pi-message(3, "Descarta alteraá‰es?",
                           "Foram efetuadas alteraá‰es nos registros. Deseja descart†-las?").
            IF RETURN-VALUE = "no" THEN RETURN NO-APPLY.
        END.
    
        DEFINE VARIABLE c-erro AS CHARACTER   NO-UNDO.
        IF NOT AVAIL tt-tarifador THEN DO:
            MESSAGE "Selecione o registro do browser para ser cadastrado!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        ELSE DO:
            DEF VAR v-matricula AS CHAR   FORMAT "X(12)" LABEL "Usu†rio" VIEW-AS FILL-IN SIZE 6 BY 0.88.
    
            DEFINE BUTTON btCancelar AUTO-END-KEY 
                 LABEL "&Cancelar" 
                 SIZE 10 BY 1
                 BGCOLOR 8.
    
            DEFINE BUTTON btOK AUTO-GO 
                 LABEL "&OK" 
                 SIZE 10 BY 1
                 BGCOLOR 8.
    
            DEFINE VARIABLE v-finalidade AS LOGICAL
                 LABEL "Finalidade"
                 VIEW-AS RADIO-SET HORIZONTAL
                 RADIO-BUTTONS 
                "Particular", YES,
                "Serviáo", NO
                 SIZE 30 BY 1 NO-UNDO.
    
            DEFINE RECTANGLE rtButton
                 EDGE-PIXELS 2 GRAPHIC-EDGE  
                 SIZE 80 BY 1.42
                 BGCOLOR 7.
    
            DEFINE FRAME fCobrar
                v-matricula      AT ROW 1.21 COL 11.0 COLON-ALIGNED 
                v-finalidade     AT ROW 2.21 COL 11.0 COLON-ALIGNED 
                btOK             AT ROW 4.63 COL 2.14
                btCancelar       AT ROW 4.63 COL 13
                rtButton         AT ROW 4.38 COL 1
                SPACE(0.28)
                WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
                     THREE-D SCROLLABLE TITLE "Incluir Telefone" FONT 1
                     DEFAULT-BUTTON btOK CANCEL-BUTTON btCancelar.
    
            ASSIGN  v-matricula:SCREEN-VALUE IN FRAME fCobrar = "".
    
            ON "leave":U OF v-matricula IN FRAME fCobrar DO:
                ASSIGN INPUT FRAME fCobrar v-matricula.
    
                RUN esp/utp/esutp001rpc.p PERSISTENT SET hprog ON SERVER hproc.
                IF VALID-HANDLE(hprog) THEN DO:
                    SESSION:SET-WAIT-STATE("GENERAL":U).
                    ASSIGN c-erro = "".
                    RUN validaMatricula IN hProg(INPUT v-matricula, OUTPUT c-erro).
                    SESSION:SET-WAIT-STATE("":U).
                    IF c-erro <> "" THEN DO:
                        MESSAGE c-erro
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    END.
                    DELETE PROCEDURE hprog.
                    hprog = ?.
                END.
                ELSE DO:
                    MESSAGE "N∆o foi poss°vel conectar ao servidor RPC. Favor fazer login novamente."
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    APPLY "GO":U TO FRAME fCobrar.
                END.
    
            END.
    
            ON "CHOOSE":U OF btOK IN FRAME fCobrar DO:
                ASSIGN INPUT FRAME fCobrar v-matricula v-finalidade.
    
                RUN esp/utp/esutp001rpc.p PERSISTENT SET hprog ON SERVER hproc.
                IF VALID-HANDLE(hprog) THEN DO:
                    SESSION:SET-WAIT-STATE("GENERAL":U).
                    ASSIGN c-erro = "".
                    RUN avaliarParaOutros IN hprog (INPUT tt-tarifador.r-rowid,  /*rowid*/
                                                    INPUT v-id,                  /*matricula mestre*/
                                                    INPUT v-matricula,           /*usuario que solicitou a ligacao*/
                                                    INPUT v-finalidade,          /*finalidade - particular/servico*/
                                                    OUTPUT c-erro).
                    SESSION:SET-WAIT-STATE("":U).
                    IF c-erro = "" THEN DO:
                        MESSAGE "Registro avaliado e ser† cobrado da matr°cula informada!"
                            VIEW-AS ALERT-BOX INFO BUTTONS OK. 

                        RUN pi-refresh.
                        APPLY "GO":U TO FRAME fCobrar.
                    END.
                    ELSE DO:
                        MESSAGE c-erro
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    END.
                    DELETE PROCEDURE hprog.
                    hprog = ?.
                END.
                ELSE DO:
                    MESSAGE "N∆o foi poss°vel conectar ao servidor RPC. Favor fazer login novamente."
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    APPLY "GO":U TO FRAME fCobrar.
                END.
            END.
    
            ENABLE v-matricula v-finalidade
                   btOK btCancelar 
                WITH FRAME fCobrar. 
    
            /*ASSIGN v-numero:SCREEN-VALUE IN FRAME fCobrar = v-numero.        */
    
            WAIT-FOR "GO":U OF FRAME fCobrar.

            OPEN QUERY BROWSE-9 FOR EACH tt-tarifador 
              by tt-tarifador.tipo by tt-tarifador.data by tt-tarifador.hora.        
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-9 C-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-9 IN FRAME DEFAULT-FRAME /* Tarifador */
DO:
    IF SELF:NUM-ITERATIONS > 0 AND SELF:NUM-SELECTED-ROWS > 0 THEN DO:
        SELF:FETCH-SELECTED-ROW(1).
        FIND CURRENT tt-tarifador.
        ASSIGN tt-tarifador.finalidade  = NOT tt-tarifador.finalidade
               tt-tarifador.avaliado    = YES
               tt-tarifador.cod_usuario = v-id
               v-alterado               = YES.
        IF tt-tarifador.finalidade THEN
            fi-valor-total = fi-valor-total + tt-tarifador.valor.
        ELSE
            fi-valor-total = fi-valor-total - tt-tarifador.valor.

        DISP tt-tarifador.finalidade tt-tarifador.avaliado WITH BROWSE browse-9.
        DISP fi-valor-total WITH FRAME {&FRAME-NAME}.

        RUN pi-muda-cor.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-9 C-Win
ON ROW-DISPLAY OF BROWSE-9 IN FRAME DEFAULT-FRAME /* Tarifador */
DO:
  RUN pi-muda-cor.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAgenda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAgenda C-Win
ON CHOOSE OF btAgenda IN FRAME DEFAULT-FRAME
DO:
    IF v-alterado THEN DO:
        RUN pi-message(3, "Descarta alteraá‰es?",
                       "Foram efetuadas alteraá‰es nos registros. Deseja descart†-las?").
        IF RETURN-VALUE = "no" THEN RETURN NO-APPLY.
    END.

    SESSION:SET-WAIT-STATE("GENERAL":U).
    ASSIGN v-alterado = NO
           c-win:SENSITIVE = FALSE.

    EMPTY TEMP-TABLE tt-tarifador.
    OPEN QUERY BROWSE-9 FOR EACH tt-tarifador 
        by tt-tarifador.tipo by tt-tarifador.data by tt-tarifador.hora.        

    RUN esp/utp/esutp001a.w (INPUT hProc, INPUT v-id).
    ASSIGN c-win:SENSITIVE = TRUE.
    SESSION:SET-WAIT-STATE("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAutomatico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAutomatico C-Win
ON CHOOSE OF btAutomatico IN FRAME DEFAULT-FRAME /* Autom†tico */
DO:
    ASSIGN op = 3.
    RUN pi-automatico.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEstornar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEstornar C-Win
ON CHOOSE OF btEstornar IN FRAME DEFAULT-FRAME /* Estornar */
DO:
    IF v-alterado THEN DO:
        RUN pi-message(3, "Descarta alteraá‰es?",
                       "Foram efetuadas alteraá‰es nos registros. Deseja descart†-las?").
        IF RETURN-VALUE = "no" THEN RETURN NO-APPLY.
    END.

    SESSION:SET-WAIT-STATE("GENERAL":U).
    ASSIGN v-alterado = NO
           c-win:SENSITIVE = FALSE.

    EMPTY TEMP-TABLE tt-tarifador.
    OPEN QUERY BROWSE-9 FOR EACH tt-tarifador 
        by tt-tarifador.tipo by tt-tarifador.data by tt-tarifador.hora.        

    RUN esp/utp/esutp001b.w (INPUT hProc, INPUT v-id, INPUT v-mestre).
    ASSIGN c-win:SENSITIVE = TRUE.
    SESSION:SET-WAIT-STATE("":U).

    /*Recalcula valor a pagar*/
    RUN esp/utp/esutp001rpc.p PERSISTENT SET hprog ON SERVER hproc.
    IF VALID-HANDLE(hprog) THEN DO:
        SESSION:SET-WAIT-STATE("GENERAL":U).
        RUN obtemValorTotal IN hprog (INPUT v-id, OUTPUT fi-valor-total).
        SESSION:SET-WAIT-STATE("":U).
        DISP fi-valor-total WITH FRAME {&FRAME-NAME}.
        fi-valor-total:PRIVATE-DATA IN FRAME {&FRAME-NAME} = STRING(fi-valor-total).
        DELETE PROCEDURE hprog.
        hprog = ?.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcel C-Win
ON CHOOSE OF btExcel IN FRAME DEFAULT-FRAME /* Exporta Excel */
DO:
  RUN pi-excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit C-Win
ON CHOOSE OF btExit IN FRAME DEFAULT-FRAME /* Exit */
DO:
    IF v-alterado THEN DO:
        RUN pi-message(3, "Descarta alteraá‰es?",
                       "Foram efetuadas alteraá‰es nos registros. Deseja descart†-las?").
        IF RETURN-VALUE = "no" THEN RETURN NO-APPLY.
    END.
    RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
    hproc = ?.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    QUIT.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLogin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLogin C-Win
ON CHOOSE OF btLogin IN FRAME DEFAULT-FRAME
DO:
    IF v-alterado THEN DO:
        RUN pi-message(3, "Descarta alteraá‰es?",
                       "Foram efetuadas alteraá‰es nos registros. Deseja descart†-las?").
        IF RETURN-VALUE = "no" THEN RETURN NO-APPLY.
    END.

    RUN pi-login.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNumero
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNumero C-Win
ON CHOOSE OF btNumero IN FRAME DEFAULT-FRAME /* N£mero */
DO:
    op = 2.
    RUN pi-numero.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btParticular
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParticular C-Win
ON CHOOSE OF btParticular IN FRAME DEFAULT-FRAME /* Particular */
DO:
    IF BROWSE-9:NUM-ITERATIONS > 0 AND BROWSE-9:NUM-SELECTED-ROWS > 0 THEN DO:
        BROWSE-9:FETCH-SELECTED-ROW(1).
        FIND CURRENT tt-tarifador.
        ASSIGN fi-valor-total           = fi-valor-total + tt-tarifador.valor WHEN NOT tt-tarifador.finalidade
               tt-tarifador.finalidade  = YES
               tt-tarifador.avaliado    = YES
               tt-tarifador.cod_usuario = v-id
               v-alterado               = YES.

        DISP tt-tarifador.finalidade tt-tarifador.avaliado WITH BROWSE browse-9.
        DISP fi-valor-total WITH FRAME {&FRAME-NAME}.

        RUN pi-muda-cor.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btRamal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRamal C-Win
ON CHOOSE OF btRamal IN FRAME DEFAULT-FRAME /* Ramal */
DO:
    op = 1.
    RUN pi-ramal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins C-Win
ON CHOOSE OF btReportsJoins IN FRAME DEFAULT-FRAME /* Reports Joins */
DO:
  RUN pi-imprime.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave C-Win
ON CHOOSE OF btSave IN FRAME DEFAULT-FRAME /* Save */
DO:
  RUN pi-message(3, "Confirma alteraá‰es?", "").
  IF RETURN-VALUE = "yes" THEN DO:
      RUN esp/utp/esutp001rpc.p PERSISTENT SET hprog ON SERVER hproc.
      IF VALID-HANDLE(hprog) THEN DO:
          SESSION:SET-WAIT-STATE("GENERAL":U).
          RUN atualizaRegistros IN hprog (INPUT TABLE tt-tarifador,
                                          INPUT v-id).
          RUN obtemValorTotal IN hprog (INPUT v-id, OUTPUT fi-valor-total).
          SESSION:SET-WAIT-STATE("":U).
          DISP fi-valor-total WITH FRAME {&FRAME-NAME}.
          ASSIGN fi-valor-total:PRIVATE-DATA IN FRAME {&FRAME-NAME} = STRING(fi-valor-total)
                 v-alterado = NO.

          /*busca registros no rpc - para atualizar brose*/
          RUN pi-refresh.

          DELETE PROCEDURE hprog.
          hprog = ?.
        END.
        
        OPEN QUERY BROWSE-9 FOR EACH tt-tarifador 
          by tt-tarifador.tipo by tt-tarifador.data by tt-tarifador.hora.        
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btServico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btServico C-Win
ON CHOOSE OF btServico IN FRAME DEFAULT-FRAME /* Serviáo */
DO:
    IF BROWSE-9:NUM-ITERATIONS > 0 AND BROWSE-9:NUM-SELECTED-ROWS > 0 THEN DO:
        BROWSE-9:FETCH-SELECTED-ROW(1).
        FIND CURRENT tt-tarifador.
        ASSIGN fi-valor-total           = fi-valor-total - tt-tarifador.valor WHEN tt-tarifador.finalidade
               tt-tarifador.finalidade  = NO
               tt-tarifador.avaliado    = YES
               tt-tarifador.cod_usuario = v-id
               v-alterado               = YES.

        DISP tt-tarifador.finalidade tt-tarifador.avaliado WITH BROWSE browse-9.
        DISP fi-valor-total WITH FRAME {&FRAME-NAME}.

        RUN pi-muda-cor.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btTodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btTodos C-Win
ON CHOOSE OF btTodos IN FRAME DEFAULT-FRAME /* Tudo Particular */
DO:
    /*DEFINE VARIABLE i-quant-reg AS INTEGER     NO-UNDO.

    ASSIGN i-quant-reg = 0.
    FOR EACH b-tt-tarifador:
        ASSIGN i-quant-reg = i-quant-reg + 1.
    END.

    IF i-quant-reg > 100 THEN DO:
        RUN pi-message (1, "N∆o Ç permitido marcar mais de 100 registros como Particular.",
                        "Somente Ç permitido selecionar atÇ 100 registros como Particular, favor utilizar filtro para selecionar ligaá‰es.").
        RETURN NO-APPLY.
    END.
    ELSE DO:*/
        RUN pi-message(3, "Deseja marcar tudo como particular?",
                         "Todas as ligaá‰es acima no browser ser∆o marcadas como particular. Confirma?").
        IF RETURN-VALUE = "NO" THEN
            RETURN NO-APPLY.

        FOR EACH b-tt-tarifador:
            IF NOT b-tt-tarifador.finalidade THEN
                fi-valor-total = fi-valor-total + b-tt-tarifador.valor.
            assign b-tt-tarifador.avaliado = yes
                   b-tt-tarifador.finalidade = YES.
        END.
        v-alterado = YES.
        OPEN QUERY BROWSE-9 FOR EACH tt-tarifador
        WHERE tt-tarifador.avaliado = YES 
        by tt-tarifador.tipo by tt-tarifador.data by tt-tarifador.hora.
        DISP fi-valor-total WITH FRAME {&FRAME-NAME}.
    /*END.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btTodos-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btTodos-2 C-Win
ON CHOOSE OF btTodos-2 IN FRAME DEFAULT-FRAME /* Tudo Serviáo */
DO:
    /*DEFINE VARIABLE i-quant-reg AS INTEGER     NO-UNDO.

    ASSIGN i-quant-reg = 0.
    FOR EACH b-tt-tarifador:
        ASSIGN i-quant-reg = i-quant-reg + 1.
    END.

    IF i-quant-reg > 100 THEN DO:
        RUN pi-message (1, "N∆o Ç permitido marcar mais de 100 registros como Serviáo.",
                        "Somente Ç permitido selecionar atÇ 100 registros como Serviáo, favor utilizar filtro para selecionar ligaá‰es.").
        RETURN NO-APPLY.
    END.
    ELSE DO:*/
        RUN pi-message(3, "Deseja marcar tudo como serviáo?",
                         "Todas as ligaá‰es acima no browser ser∆o marcadas como serviáo. Confirma?").
        IF RETURN-VALUE = "NO" THEN
            RETURN NO-APPLY.

        FOR EACH b-tt-tarifador:
            assign b-tt-tarifador.avaliado = yes
                   b-tt-tarifador.finalidade = NO.
        END.
        ASSIGN v-alterado = YES
               fi-valor-total = DEC(fi-valor-total:PRIVATE-DATA IN FRAME {&FRAME-NAME}).
        OPEN QUERY BROWSE-9 FOR EACH tt-tarifador
        WHERE tt-tarifador.avaliado = YES 
        by tt-tarifador.tipo by tt-tarifador.data by tt-tarifador.hora.
        DISP fi-valor-total WITH FRAME {&FRAME-NAME}.
    /*END.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Cadastrar_na_Agenda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Cadastrar_na_Agenda C-Win
ON CHOOSE OF MENU-ITEM m_Cadastrar_na_Agenda /* Cadastrar na Agenda */
DO:
  DEFINE VARIABLE c-erro AS CHARACTER   NO-UNDO.
  IF NOT AVAIL tt-tarifador THEN DO:
      MESSAGE "Selecione o registro do browser para ser cadastrado!"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
  END.
  ELSE DO:

      DEF VAR v-ramal      AS CHARACTER FORMAT "x(12)" LABEL "Ramal" VIEW-AS FILL-IN SIZE 13 BY 0.88.
      DEF VAR v-numero     AS CHARACTER FORMAT "x(40)" LABEL "N£mero" VIEW-AS FILL-IN SIZE 41 BY 0.88.
      /*DEF VAR v-finalidade AS LOGICAL   FORMAT "Particular/Serviáo" LABEL "Finalidade" VIEW-AS RADIO-SET .*/
      DEF VAR v-descricao  AS CHARACTER FORMAT "x(40)" LABEL "Descriá∆o" VIEW-AS FILL-IN SIZE 41 BY 0.88.
      DEF VAR v-observ     AS CHARACTER FORMAT "x(60)" LABEL "Observaá‰es" VIEW-AS FILL-IN SIZE 61 BY 0.88.

      DEFINE BUTTON btCancelar AUTO-END-KEY 
           LABEL "&Cancelar" 
           SIZE 10 BY 1
           BGCOLOR 8.

      DEFINE BUTTON btOK AUTO-GO 
           LABEL "&OK" 
           SIZE 10 BY 1
           BGCOLOR 8.

      DEFINE RECTANGLE rtButton
           EDGE-PIXELS 2 GRAPHIC-EDGE  
           SIZE 80 BY 1.42
           BGCOLOR 7.

      DEFINE VARIABLE v-finalidade AS LOGICAL
           LABEL "Finalidade"
           VIEW-AS RADIO-SET HORIZONTAL
           RADIO-BUTTONS 
          "Particular", YES,
          "Serviáo", NO
           SIZE 30 BY 1 NO-UNDO.

      DEFINE FRAME fIncluir
          v-ramal         AT ROW 1.21 COL 11.0 COLON-ALIGNED 
          v-numero        AT ROW 2.21 COL 11.0 COLON-ALIGNED 
          v-finalidade    AT ROW 3.21 COL 11.0 COLON-ALIGNED 
          v-descricao     AT ROW 4.21 COL 11.0 COLON-ALIGNED 
          v-observ        AT ROW 5.21 COL 11.0 COLON-ALIGNED 
          btOK          AT ROW 10.63 COL 2.14
          btCancelar    AT ROW 10.63 COL 13
          rtButton      AT ROW 10.38 COL 1
          SPACE(0.28)
          WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
               THREE-D SCROLLABLE TITLE "Incluir Telefone" FONT 1
               DEFAULT-BUTTON btOK CANCEL-BUTTON btCancelar.

      ASSIGN  v-ramal:SCREEN-VALUE IN FRAME fIncluir      = tt-tarifador.ramal
              v-numero:SCREEN-VALUE IN FRAME fIncluir     = tt-tarifador.numero
              v-finalidade:SCREEN-VALUE IN FRAME fIncluir = STRING(tt-tarifador.finalidade).

      ON "CHOOSE":U OF btOK IN FRAME fIncluir DO:
          ASSIGN INPUT FRAME fIncluir v-ramal v-numero v-finalidade v-descricao v-observ.

          RUN esp/utp/esutp001rpc.p PERSISTENT SET hprog ON SERVER hproc.
          IF VALID-HANDLE(hprog) THEN DO:
              EMPTY TEMP-TABLE tt-agenda-tarifador.
              SESSION:SET-WAIT-STATE("GENERAL":U).
              ASSIGN c-erro = "".
              RUN incluirAgendaUsuario IN hprog (INPUT v-id, INPUT v-ramal, INPUT v-numero, INPUT v-finalidade, INPUT v-descricao, INPUT v-observ, OUTPUT c-erro).
              SESSION:SET-WAIT-STATE("":U).
              IF c-erro = "" THEN DO:
                  MESSAGE "Registro cadastrado com sucesso!"
                      VIEW-AS ALERT-BOX INFO BUTTONS OK. 
                  APPLY "GO":U TO FRAME fIncluir.
              END.
              ELSE DO:
                  MESSAGE c-erro
                      VIEW-AS ALERT-BOX INFO BUTTONS OK.
              END.
              DELETE PROCEDURE hprog.
              hprog = ?.
          END.
          ELSE DO:
              MESSAGE "N∆o foi poss°vel conectar ao servidor RPC. Favor fazer login novamente."
                  VIEW-AS ALERT-BOX INFO BUTTONS OK.
              APPLY "GO":U TO FRAME fIncluir.
          END.
      END.

      ENABLE v-ramal v-numero v-finalidade v-descricao v-observ
             btOK btCancelar 
          WITH FRAME fIncluir. 

      /*ASSIGN v-numero:SCREEN-VALUE IN FRAME fIncluir = v-numero.        */

      WAIT-FOR "GO":U OF FRAME fIncluir.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
RUN conecta-rpc IN THIS-PROCEDURE (output hproc).
IF RETURN-VALUE = "NOK" THEN DO:
  RUN pi-message(1, "Erro na conex∆o com o servidor RPC",
                 "N∆o foi poss°vel conectar o servidor RPC. Entre em contato com o respons†vel em TI").
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

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
  RUN pi-login.
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
  DISPLAY fi-valor-total 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE rtToolBar btLogin btExit btHelp BROWSE-9 fi-valor-total 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-automatico C-Win 
PROCEDURE pi-automatico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE de-valor-automatica AS DECIMAL     NO-UNDO.

    IF v-alterado THEN DO:
        RUN pi-message(3, "Descarta alteraá‰es?",
                       "Foram efetuadas alteraá‰es nos registros. Deseja descart†-las?").
        IF RETURN-VALUE = "no" THEN 
            RETURN NO-APPLY.
    END.

    ASSIGN v-alterado = NO.

    RUN esp/utp/esutp001rpc.p PERSISTENT SET hprog ON SERVER hproc.
    IF VALID-HANDLE(hprog) THEN DO:
        EMPTY TEMP-TABLE tt-tarifador.
        SESSION:SET-WAIT-STATE("GENERAL":U).
        RUN obtemLigacoesAutomaticas IN hprog (INPUT v-id, OUTPUT TABLE tt-tarifador, OUTPUT de-valor-automatica).
        
        IF CAN-FIND(FIRST tt-tarifador) THEN
            ASSIGN v-alterado = YES.

        fi-valor-total = DEC(fi-valor-total:PRIVATE-DATA IN FRAME {&FRAME-NAME}) + de-valor-automatica.
        DISP fi-valor-total WITH FRAME {&FRAME-NAME}.
        SESSION:SET-WAIT-STATE("":U).
        BROWSE browse-9:TITLE = SUBSTITUTE("Ligaá‰es Agenda Autom†tica: (&1)", trim(STRING(v-id))).
        OPEN QUERY BROWSE-9 FOR EACH tt-tarifador 
            by tt-tarifador.tipo by tt-tarifador.data by tt-tarifador.hora.        
        ASSIGN btTodos:SENSITIVE IN FRAME {&FRAME-NAME} = BROWSE browse-9:NUM-ITERATIONS > 0
               btTodos-2:SENSITIVE IN FRAME {&FRAME-NAME} = btTodos:SENSITIVE IN FRAME {&FRAME-NAME}
               btSave:SENSITIVE IN FRAME {&FRAME-NAME} = btTodos:SENSITIVE IN FRAME {&FRAME-NAME}
               btParticular:SENSITIVE IN FRAME {&FRAME-NAME} = btTodos:SENSITIVE IN FRAME {&FRAME-NAME} 
               btServico:SENSITIVE IN FRAME {&FRAME-NAME} = btTodos:SENSITIVE IN FRAME {&FRAME-NAME}.
        DELETE PROCEDURE hprog.
        hprog = ?.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-excel C-Win 
PROCEDURE pi-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.
    ASSIGN c-arquivo = "c:\temp\tarifador.txt".

    OUTPUT TO VALUE(c-arquivo).
    
    PUT UNFORMATTED 
        "Tipo;Data;Hora;Numero;Localidade;UF;Valor;Duracao;Ramal;" SKIP.

    FOR EACH tt-tarifador:
        PUT UNFORMATTED 
            tt-tarifador.tipo        ";"
            tt-tarifador.data        ";"
            tt-tarifador.hora        ";"
            tt-tarifador.numero      ";"
            tt-tarifador.localidade  ";"
            tt-tarifador.uf          ";"
            tt-tarifador.valor       ";"
            tt-tarifador.duracao     ";"
            tt-tarifador.ramal       ";" SKIP.
    END.
    OUTPUT CLOSE.

    OS-COMMAND NO-WAIT notepad VALUE(c-arquivo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-imprime C-Win 
PROCEDURE pi-imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR c-arquivo AS CHAR NO-UNDO.
DEFINE VARIABLE c-mestre AS CHAR FORMAT "X(12)"   NO-UNDO.
DEFINE VARIABLE de-valor AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-total AS DECIMAL     NO-UNDO.

c-arquivo = SESSION:TEMP-DIRECTORY.
IF LENGTH(c-arquivo) > 0 AND LOOKUP(SUBSTRING(c-arquivo, LENGTH(c-arquivo)), "/,\") = 0 THEN
    c-arquivo = c-arquivo + "\".
c-arquivo = c-arquivo + STRING(v-id) + STRING(TIME) + ".tmp".

OUTPUT TO VALUE(c-arquivo) page-size 62 CONVERT TARGET SESSION:CHARSET.

view frame f-cabec.
view frame f-rodape.

RUN esp/utp/esutp001rpc.p PERSISTENT SET hprog ON SERVER hproc.
IF VALID-HANDLE(hprog) THEN DO:
    SESSION:SET-WAIT-STATE("GENERAL":U).
    RUN obtemLigacoesParaListagem IN hprog (INPUT v-id, OUTPUT TABLE tt-impressao).
    SESSION:SET-WAIT-STATE("":U).
    DELETE PROCEDURE hprog.
    hprog = ?.
END.

ASSIGN c-mestre = "".

IF CAN-FIND(FIRST tt-impressao NO-LOCK 
            WHERE NOT tt-impressao.cobrado) THEN DO:

    PUT UNFORMATTED "PENDENTES " SKIP(1)
        "Tipo Data     Hora     Duracao  Numero          Localidade                     UF      Valor Dt.Aval. Avaliador Ramal     " AT 01 SKIP
        "---- -------- -------- -------- --------------- ------------------------------ -- ---------- -------- --------- ----------" AT 01 SKIP.
    ASSIGN de-total = 0.
    FOR EACH tt-impressao NO-LOCK
       WHERE NOT tt-impressao.cobrado
        BREAK BY tt-impressao.tipo
              BY tt-impressao.data
              BY tt-impressao.hora: 

        ASSIGN c-mestre = IF tt-impressao.matr_mestre = "" THEN tt-impressao.cod_usuario ELSE tt-impressao.matr_mestre.

        PUT UNFORMATTED 
             tt-impressao.tipo                                   AT 01
             tt-impressao.data format "99/99/99"                 AT 06
             tt-impressao.hora                                   AT 15
             tt-impressao.duracao                                AT 24
             tt-impressao.numero format "x(15)"                  AT 33
             tt-impressao.localidade format "x(30)"              AT 49
             tt-impressao.uf                                     AT 80
             tt-impressao.valor    FORMAT ">>>,>>9.99"           TO 92
             tt-impressao.dt-avaliac FORMAT "99/99/99"           AT 94
             c-mestre                                            AT 103
             tt-impressao.ramal     FORMAT "x(10)"               AT 113 SKIP.

        ASSIGN de-total = de-total + tt-impressao.valor.
    END.
    PUT UNFORMATTED 
        "----------"                           TO 92 SKIP
        "Total"                                TO 81 
        de-total FORMAT ">>>,>>9.99"           TO 92
        FILL("-",132) FORMAT "x(132)" AT 01 SKIP(2).
END.

IF CAN-FIND(FIRST tt-impressao NO-LOCK 
            WHERE tt-impressao.cobrado) THEN DO:

    PUT UNFORMATTED "PAGAS" SKIP(1)
        "Tipo Data     Hora     Duracao  Numero          Localidade                     UF      Valor Dt.Aval. Avaliador Pago   Ramal     " AT 01 SKIP
        "---- -------- -------- -------- --------------- ------------------------------ -- ---------- -------- --------- ------ ----------" AT 01 SKIP.

    ASSIGN de-total = 0.
    FOR EACH tt-impressao NO-LOCK
       WHERE tt-impressao.cobrado
        BREAK BY tt-impressao.periodo-cobranca DESCENDING
              BY tt-impressao.tipo
              BY tt-impressao.data
              BY tt-impressao.hora: 

        IF FIRST-OF(tt-impressao.periodo-cobranca) THEN DO:
            ASSIGN de-valor = 0.
        END.

        ASSIGN de-valor = de-valor + tt-impressao.valor
               de-total = de-total + tt-impressao.valor
               c-mestre = IF tt-impressao.matr_mestre = "" THEN tt-impressao.cod_usuario ELSE tt-impressao.matr_mestre.

        PUT UNFORMATTED 
            tt-impressao.tipo                                   AT 01
            tt-impressao.data format "99/99/99"                 AT 06
            tt-impressao.hora                                   AT 15
            tt-impressao.duracao                                AT 24
            tt-impressao.numero format "x(15)"                  AT 33
            tt-impressao.localidade format "x(30)"              AT 49
            tt-impressao.uf                                     AT 80
            tt-impressao.valor    FORMAT ">>>,>>9.99"           TO 92
            tt-impressao.dt-avaliac FORMAT "99/99/99"           AT 94
            c-mestre                                            AT 103
            tt-impressao.periodo-cobranca                       AT 113 
            tt-impressao.ramal     FORMAT "x(10)"               AT 120 SKIP.

        IF LAST-OF(tt-impressao.periodo-cobranca) THEN DO:
            PUT UNFORMATTED 
                "----------"                           TO 92 SKIP
                "Sub-Total"                            TO 81 
                de-valor FORMAT ">>>,>>9.99"           TO 92 SKIP.

            ASSIGN de-valor = 0.
        END.
    END.

    PUT UNFORMATTED 
        "----------"                           TO 92 SKIP
        "Total"                                TO 81 
        de-total FORMAT ">>>,>>9.99"           TO 92
        FILL("-",132) FORMAT "x(132)" AT 01 SKIP(2).
END.
    

OUTPUT CLOSE.
OS-COMMAND NO-WAIT notepad VALUE(c-arquivo).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-login C-Win 
PROCEDURE pi-login :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btLoginCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btLoginOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtLoginButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.

    DEF VAR c-id AS CHAR NO-UNDO FORMAT "x(12)" VIEW-AS FILL-IN SIZE 13 BY 0.88.
    DEF VAR v-senha AS CHAR NO-UNDO FORMAT "x(11)" VIEW-AS FILL-IN SIZE 13 BY 0.88.
    
    DEFINE FRAME fLogin
        c-id           AT ROW 1.21 COL 15.0 COLON-ALIGNED LABEL "Usu†rio" 
        help "Nome do usu†rio"
        v-senha        AT ROW 2.21 COL 15.0 COLON-ALIGNED LABEL "CPF" PASSWORD-FIELD
        help "Senha do usu†rio"
        btLoginOK     AT ROW 3.63 COL 2.14
        btLoginCancel AT ROW 3.63 COL 13
        rtLoginButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Login" FONT 1
             DEFAULT-BUTTON btLoginOK CANCEL-BUTTON btLoginCancel.

    ON "CHOOSE":U OF btLoginOK IN FRAME fLogin DO:
        ASSIGN INPUT FRAME fLogin c-id        
               INPUT FRAME fLogin v-senha.

        RUN esp/utp/esutp001rpc.p PERSISTENT SET hprog ON SERVER hproc.
        IF VALID-HANDLE(hprog) THEN DO:
            RUN obtemRamal IN hprog (INPUT c-id,
                                     INPUT v-senha,
                                     OUTPUT v-ramal).

            IF v-ramal = ? OR c-id = "" OR v-senha = "" THEN DO:
                RUN pi-message (1, "Colaborador n∆o encontrado",
                                "Confira o usu†rio e CPF informados").
                APPLY "entry" TO c-id IN FRAME fLogin.
                RETURN NO-APPLY.
            END.

            ASSIGN v-id = c-id.

            EMPTY TEMP-TABLE tt-tarifador.
            OPEN QUERY BROWSE-9 FOR EACH tt-tarifador 
                by tt-tarifador.tipo by tt-tarifador.data by tt-tarifador.hora.        

            SESSION:SET-WAIT-STATE("GENERAL":U).
            ASSIGN v-mestre = NO.
            RUN isMatriculaMestre IN hprog (INPUT c-id, OUTPUT v-mestre).
            RUN obtemValorTotal IN hprog (INPUT c-id, OUTPUT fi-valor-total).
            SESSION:SET-WAIT-STATE("":U).
            DISP fi-valor-total WITH FRAME {&FRAME-NAME}.
            fi-valor-total:PRIVATE-DATA IN FRAME {&FRAME-NAME} = STRING(fi-valor-total).
            BROWSE browse-9:TITLE = v-id.
            ENABLE btNumero btRamal btAgenda btAutomatico btEstornar btExcel btReportsJoins WITH FRAME {&FRAME-NAME}.
            DELETE PROCEDURE hprog.
            hprog = ?.
        END.
        APPLY "GO":U TO FRAME fLogin.
    END.
    ON 'choose':U OF btLoginCancel IN FRAME fLogin DO:
        APPLY "GO":U TO FRAME fLogin.
        RETURN NO-APPLY.
    END.

    ENABLE c-id         btLoginOK btLoginCancel 
           v-senha
        WITH FRAME fLogin. 

    ASSIGN c-id:SCREEN-VALUE IN FRAME fLogin     = c-id        
           v-senha:SCREEN-VALUE IN FRAME fLogin  = v-senha
           v-senha:BLANK IN FRAME fLogin = YES
           v-alterado = NO.
    
    WAIT-FOR "GO":U OF FRAME fLogin.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-message C-Win 
PROCEDURE pi-message :
def input param p-tipo AS INT no-undo.
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
    def button bt_yes        label "&OK" size-char 10 by 1 auto-go.
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
        with three-d no-label view-as DIALOG-BOX TITLE "Pergunta" DEFAULT-BUTTON bt_yes.

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
    CASE p-tipo:
        WHEN 1 THEN do:
            im_msg_ico:load-image("image/im-mqerr").
            frame f_msg_help:TITLE = "Erro".
            assign bt_no:hidden in frame f_msg_help = YES
                   bt_no:sensitive in frame f_msg_help = NO
                   bt_yes:hidden in frame f_msg_help = NO     
                   bt_yes:sensitive in frame f_msg_help = YES. 
        END.
        WHEN 2 THEN do:
            im_msg_ico:load-image("image/im-mqwar").
            frame f_msg_help:TITLE = "Advertància".
            assign bt_no:hidden in frame f_msg_help = YES
                   bt_no:sensitive in frame f_msg_help = NO
                   bt_yes:hidden in frame f_msg_help = NO     
                   bt_yes:sensitive in frame f_msg_help = YES. 
        END.
        WHEN 3 THEN do:
            im_msg_ico:load-image("image/im-mqqst").
            frame f_msg_help:TITLE = "Pergunta".
            assign bt_no:hidden in frame f_msg_help = no
                   bt_no:sensitive in frame f_msg_help = yes
                   bt_yes:hidden in frame f_msg_help = no     
                   bt_yes:sensitive in frame f_msg_help = yes.
            bt_yes:label in frame f_msg_help = "&Sim".
        END.
        WHEN 4 THEN do:
            im_msg_ico:load-image("image/im-mqinf").
            frame f_msg_help:TITLE = "Informaá∆o".
            assign bt_no:hidden in frame f_msg_help = YES
                   bt_no:sensitive in frame f_msg_help = NO
                   bt_yes:hidden in frame f_msg_help = NO     
                   bt_yes:sensitive in frame f_msg_help = YES. 
        END.
    END CASE.
 
    assign v_msg_val = p-texto-msg.
    assign v_msg_hlp = p-help-msg + chr(10) + "".

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-muda-cor C-Win 
PROCEDURE pi-muda-cor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF AVAIL tt-tarifador THEN DO:
        IF tt-tarifador.avaliado THEN DO:
            IF tt-tarifador.finalidade THEN DO:
                /*Particular*/
                ASSIGN tt-tarifador.tipo:BGCOLOR IN BROWSE BROWSE-9       = 14
                       tt-tarifador.data:BGCOLOR IN BROWSE BROWSE-9       = 14
                       tt-tarifador.hora:BGCOLOR IN BROWSE BROWSE-9       = 14
                       tt-tarifador.numero:BGCOLOR IN BROWSE BROWSE-9     = 14
                       tt-tarifador.localidade:BGCOLOR IN BROWSE BROWSE-9 = 14
                       tt-tarifador.uf:BGCOLOR IN BROWSE BROWSE-9         = 14
                       tt-tarifador.finalidade:BGCOLOR IN BROWSE BROWSE-9 = 14
                       tt-tarifador.avaliado:BGCOLOR IN BROWSE BROWSE-9   = 14
                       tt-tarifador.valor:BGCOLOR IN BROWSE BROWSE-9      = 14
                       tt-tarifador.duracao:BGCOLOR IN BROWSE BROWSE-9    = 14
                       tt-tarifador.ramal:BGCOLOR IN BROWSE BROWSE-9      = 14.
            END.
            ELSE DO:
                /*Servico*/
                ASSIGN tt-tarifador.tipo:BGCOLOR IN BROWSE BROWSE-9       = 11
                       tt-tarifador.data:BGCOLOR IN BROWSE BROWSE-9       = 11
                       tt-tarifador.hora:BGCOLOR IN BROWSE BROWSE-9       = 11
                       tt-tarifador.numero:BGCOLOR IN BROWSE BROWSE-9     = 11
                       tt-tarifador.localidade:BGCOLOR IN BROWSE BROWSE-9 = 11
                       tt-tarifador.uf:BGCOLOR IN BROWSE BROWSE-9         = 11
                       tt-tarifador.finalidade:BGCOLOR IN BROWSE BROWSE-9 = 11
                       tt-tarifador.avaliado:BGCOLOR IN BROWSE BROWSE-9   = 11
                       tt-tarifador.valor:BGCOLOR IN BROWSE BROWSE-9      = 11
                       tt-tarifador.duracao:BGCOLOR IN BROWSE BROWSE-9    = 11
                       tt-tarifador.ramal:BGCOLOR IN BROWSE BROWSE-9      = 11.
            END.
        END.
        ELSE DO:
            /*N∆o avaliado*/
            ASSIGN tt-tarifador.tipo:BGCOLOR IN BROWSE BROWSE-9       = ?
                   tt-tarifador.data:BGCOLOR IN BROWSE BROWSE-9       = ?
                   tt-tarifador.hora:BGCOLOR IN BROWSE BROWSE-9       = ?
                   tt-tarifador.numero:BGCOLOR IN BROWSE BROWSE-9     = ?
                   tt-tarifador.localidade:BGCOLOR IN BROWSE BROWSE-9 = ?
                   tt-tarifador.uf:BGCOLOR IN BROWSE BROWSE-9         = ?
                   tt-tarifador.finalidade:BGCOLOR IN BROWSE BROWSE-9 = ?
                   tt-tarifador.avaliado:BGCOLOR IN BROWSE BROWSE-9   = ?
                   tt-tarifador.valor:BGCOLOR IN BROWSE BROWSE-9      = ?
                   tt-tarifador.duracao:BGCOLOR IN BROWSE BROWSE-9    = ?
                   tt-tarifador.ramal:BGCOLOR IN BROWSE BROWSE-9      = ?.
        END.
    END.
    ELSE DO:
        /*Sem registros*/
        ASSIGN tt-tarifador.tipo:BGCOLOR IN BROWSE BROWSE-9       = ?
               tt-tarifador.data:BGCOLOR IN BROWSE BROWSE-9       = ?
               tt-tarifador.hora:BGCOLOR IN BROWSE BROWSE-9       = ?
               tt-tarifador.numero:BGCOLOR IN BROWSE BROWSE-9     = ?
               tt-tarifador.localidade:BGCOLOR IN BROWSE BROWSE-9 = ?
               tt-tarifador.uf:BGCOLOR IN BROWSE BROWSE-9         = ?
               tt-tarifador.finalidade:BGCOLOR IN BROWSE BROWSE-9 = ?
               tt-tarifador.avaliado:BGCOLOR IN BROWSE BROWSE-9   = ?
               tt-tarifador.valor:BGCOLOR IN BROWSE BROWSE-9      = ?
               tt-tarifador.duracao:BGCOLOR IN BROWSE BROWSE-9    = ?
               tt-tarifador.ramal:BGCOLOR IN BROWSE BROWSE-9      = ?.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-numero C-Win 
PROCEDURE pi-numero :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btSelecaoCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btSelecaoOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtSelecaoButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.

    DEFINE FRAME fSelecao
        v-numero           AT ROW 1.21 COL 10.0 COLON-ALIGNED 
        btSelecaoOK     AT ROW 2.63 COL 2.14
        btSelecaoCancel AT ROW 2.63 COL 13
        rtSelecaoButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Filtro - Digite n£mero para qual foi ligado!" FONT 1
             DEFAULT-BUTTON btSelecaoOK CANCEL-BUTTON btSelecaoCancel.
    
    ON "CHOOSE":U OF btSelecaoOK IN FRAME fSelecao DO:
        ASSIGN INPUT FRAME fSelecao v-numero.        

        IF v-numero = "" THEN DO:
            MESSAGE "Deve ser informado um n£mero para efetuar a busca!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN NO-APPLY.
        END.
        ELSE IF LENGTH(v-numero) < 4 THEN DO:
            MESSAGE "Deve ser informado pelo menos 4 d°gitos do n£mero do telefone!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN NO-APPLY.
        END. 
        ELSE DO:
            IF v-alterado THEN DO:
                RUN pi-message(3, "Descarta alteraá‰es?",
                               "Foram efetuadas alteraá‰es nos registros. Deseja descart†-las?").
                IF RETURN-VALUE = "no" THEN do:
                    APPLY "entry" TO v-numero IN FRAME fSelecao.
                    RETURN NO-APPLY.
                END.
                v-alterado = NO.
            END.
            RUN esp/utp/esutp001rpc.p PERSISTENT SET hprog ON SERVER hproc.
            IF VALID-HANDLE(hprog) THEN DO:
                EMPTY TEMP-TABLE tt-tarifador.
                SESSION:SET-WAIT-STATE("GENERAL":U).
                RUN obtemLigacoesPorNumero IN hprog (INPUT v-numero, OUTPUT TABLE tt-tarifador).
                fi-valor-total = DEC(fi-valor-total:PRIVATE-DATA IN FRAME {&FRAME-NAME}).
                DISP fi-valor-total WITH FRAME {&FRAME-NAME}.
                SESSION:SET-WAIT-STATE("":U).
                BROWSE browse-9:TITLE = SUBSTITUTE("Ligaá‰es para o N£mero: &1 - &2", trim(v-numero), trim(STRING(v-id))).
                OPEN QUERY BROWSE-9 FOR EACH tt-tarifador 
                    by tt-tarifador.tipo by tt-tarifador.data by tt-tarifador.hora.        
                ASSIGN btTodos:SENSITIVE IN FRAME {&FRAME-NAME} = BROWSE browse-9:NUM-ITERATIONS > 0
                       btTodos-2:SENSITIVE IN FRAME {&FRAME-NAME} = btTodos:SENSITIVE IN FRAME {&FRAME-NAME}
                       btSave:SENSITIVE IN FRAME {&FRAME-NAME} = btTodos:SENSITIVE IN FRAME {&FRAME-NAME}
                       btParticular:SENSITIVE IN FRAME {&FRAME-NAME} = btTodos:SENSITIVE IN FRAME {&FRAME-NAME} 
                       btServico:SENSITIVE IN FRAME {&FRAME-NAME} = btTodos:SENSITIVE IN FRAME {&FRAME-NAME}.
                DELETE PROCEDURE hprog.
                hprog = ?.
            END.
            APPLY "GO":U TO FRAME fSelecao.
        END.
    END.

    ENABLE v-numero         btSelecaoOK btSelecaoCancel 
        WITH FRAME fSelecao. 

    ASSIGN v-numero:SCREEN-VALUE IN FRAME fSelecao          = v-numero.        
    
    WAIT-FOR "GO":U OF FRAME fSelecao.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ramal C-Win 
PROCEDURE pi-ramal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btSelecaoCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btSelecaoOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtSelecaoButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.

    DEFINE FRAME fSelecao
        v-ramal           AT ROW 1.21 COL 15.0 COLON-ALIGNED 
        btSelecaoOK     AT ROW 2.63 COL 2.14
        btSelecaoCancel AT ROW 2.63 COL 13
        rtSelecaoButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Filtro - Digite o ramal que deseja consultar!" FONT 1
             DEFAULT-BUTTON btSelecaoOK CANCEL-BUTTON btSelecaoCancel.
    
    ON "CHOOSE":U OF btSelecaoOK IN FRAME fSelecao DO:
        IF v-alterado THEN DO:
            RUN pi-message(3, "Descarta alteraá‰es?",
                           "Foram efetuadas alteraá‰es nos registros. Deseja descart†-las?").
            IF RETURN-VALUE = "no" THEN do:
                APPLY "entry" TO v-ramal IN FRAME fSelecao.
                RETURN NO-APPLY.
            END.
            v-alterado = NO.
        END.
        RUN esp/utp/esutp001rpc.p PERSISTENT SET hprog ON SERVER hproc.
        IF VALID-HANDLE(hprog) THEN DO:
            ASSIGN INPUT FRAME fSelecao v-ramal.        
            EMPTY TEMP-TABLE tt-tarifador.
            SESSION:SET-WAIT-STATE("GENERAL":U).

            RUN obtemLigacoesPorRamal IN hprog (INPUT v-ramal, OUTPUT TABLE tt-tarifador).
            fi-valor-total = DEC(fi-valor-total:PRIVATE-DATA IN FRAME {&FRAME-NAME}).
            DISP fi-valor-total WITH FRAME {&FRAME-NAME}.

            SESSION:SET-WAIT-STATE("":U).
            BROWSE browse-9:TITLE = SUBSTITUTE("Ligaá‰es do Ramal: &1 - &2", trim(v-ramal), TRIM(string(v-id))).

            OPEN QUERY BROWSE-9 FOR EACH tt-tarifador 
                by tt-tarifador.tipo by tt-tarifador.data by tt-tarifador.hora.

            ASSIGN btTodos:SENSITIVE IN FRAME {&FRAME-NAME} = BROWSE browse-9:NUM-ITERATIONS > 0
                   btTodos-2:SENSITIVE IN FRAME {&FRAME-NAME} = btTodos:SENSITIVE IN FRAME {&FRAME-NAME}
                   btSave:SENSITIVE IN FRAME {&FRAME-NAME} = btTodos:SENSITIVE IN FRAME {&FRAME-NAME}
                   btParticular:SENSITIVE IN FRAME {&FRAME-NAME} = btTodos:SENSITIVE IN FRAME {&FRAME-NAME} 
                   btServico:SENSITIVE IN FRAME {&FRAME-NAME} = btTodos:SENSITIVE IN FRAME {&FRAME-NAME}.
            DELETE PROCEDURE hprog.
            hprog = ?.
        END.
        APPLY "GO":U TO FRAME fSelecao.
    END.

    ENABLE v-ramal         btSelecaoOK btSelecaoCancel 
        WITH FRAME fSelecao. 

    ASSIGN v-ramal:SCREEN-VALUE IN FRAME fSelecao          = v-ramal.        
    
    WAIT-FOR "GO":U OF FRAME fSelecao.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-refresh C-Win 
PROCEDURE pi-refresh :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
      EMPTY TEMP-TABLE tt-tarifador.
      
      IF op = 1  THEN
          RUN obtemLigacoesPorRamal IN hprog (INPUT v-ramal, OUTPUT TABLE tt-tarifador).
      ELSE IF op = 2 THEN
          RUN obtemLigacoesPorNumero IN hprog (INPUT v-numero, OUTPUT TABLE tt-tarifador).
      ELSE IF op = 3  THEN
          RUN obtemLigacoesPorRamal IN hprog (INPUT v-ramal, OUTPUT TABLE tt-tarifador).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

