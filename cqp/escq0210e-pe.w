&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          emsfnd           PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF TEMP-TABLE tt-gera-transf NO-UNDO
    FIELD l-considera   AS CHAR FORMAT "x(01)" LABEL "Perda?"
    FIELD cod-estabel   LIKE ficha-cq.cod-estabel
    FIELD nr-ficha      LIKE ficha-cq.nr-ficha
    FIELD it-codigo     LIKE ficha-cq.it-codigo
    FIELD desc-item     LIKE ITEM.desc-item
    FIELD dt-fabricacao AS DATE FORMAT "99/99/9999" LABEL "DT Fabrica‡Æo"
    FIELD quantidade    LIKE ficha-cq.qt-original
    FIELD dep-saida     LIKE ficha-cq.cod-depos
    FIELD loc-saida     LIKE ficha-cq.cod-localiz
    FIELD cod-refer     LIKE ficha-cq.cod-refer
    FIELD lote          LIKE ficha-cq.lote
    FIELD dep-entrada   LIKE saldo-estoq.cod-depos
    FIELD loc-entrada   LIKE saldo-estoq.cod-localiz
    FIELD dt-trans      LIKE movto-estoq.dt-trans
    FIELD nro-docto     LIKE movto-estoq.nro-docto   
    FIELD serie-docto   LIKE movto-estoq.serie-docto
    FIELD narrativa     LIKE ficha-cq.narrativa
    FIELD cod-emitente  LIKE ficha-cq.cod-emitente
    FIELD cod-rej       LIKE cod-rejeicao.codigo-rejei
    FIELD nat-operacao  LIKE ficha-cq.nat-operacao
    FIELD obs           LIKE ficha-cq.narrativa
    FIELD ct-codigo     AS CHAR
    FIELD sc-codigo     AS CHAR. 
DEF BUFFER b-tt-gera-transf FOR tt-gera-transf.

def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.
def var c-formato-conta      as char no-undo.
def var c-formato-ccusto     as char no-undo. 

/* Vari veis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
/* Vari veis centro de custo */ 
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo.
def var v_log_utz_ccusto     as log    no-undo. 

def var i-empresa like param-global.empresa-prin INITIAL "1" no-undo.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Numero" column-label "Numero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistencia".

/*--- Variÿveis definidas para que se possa utilizar o zoom 
      feito em Smart Objects ---*/
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.
DEFINE VARIABLE l-implanta AS LOGICAL INITIAL NO.

/** Parametros **/
DEF INPUT-OUTPUT PARAM TABLE FOR tt-gera-transf.
DEF OUTPUT PARAM l-ok AS LOG.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-gera-transf movto-estoq

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 tt-gera-transf.l-considera tt-gera-transf.nr-ficha tt-gera-transf.dt-fabricacao tt-gera-transf.it-codigo tt-gera-transf.desc-item tt-gera-transf.quantidade tt-gera-transf.lote   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3   
&Scoped-define SELF-NAME BROWSE-3
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH tt-gera-transf     BY tt-gera-transf.it-codigo
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY {&SELF-NAME} FOR EACH tt-gera-transf     BY tt-gera-transf.it-codigo.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 tt-gera-transf
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 tt-gera-transf


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}
&Scoped-define QUERY-STRING-F-Main FOR EACH movto-estoq SHARE-LOCK
&Scoped-define OPEN-QUERY-F-Main OPEN QUERY F-Main FOR EACH movto-estoq SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-F-Main movto-estoq
&Scoped-define FIRST-TABLE-IN-QUERY-F-Main movto-estoq


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-3 rt-button RECT-5 d-dt-trans c-conta ~
c-ccusto bt-ok bt-cancela 
&Scoped-Define DISPLAYED-OBJECTS d-dt-trans c-conta c-ccusto 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-ccusto AS CHARACTER FORMAT "x(20)":U 
     LABEL "Centro Custo" 
     VIEW-AS FILL-IN 
     SIZE 20.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-conta AS CHARACTER FORMAT "x(20)":U 
     LABEL "Conta" 
     VIEW-AS FILL-IN 
     SIZE 20.43 BY .88 NO-UNDO.

DEFINE VARIABLE d-dt-trans AS DATE FORMAT "99/99/9999" INITIAL 11/14/18 
     LABEL "Data Transa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 4.75.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 62 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      tt-gera-transf SCROLLING.

DEFINE QUERY F-Main FOR 
      movto-estoq SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _FREEFORM
  QUERY BROWSE-3 DISPLAY
      tt-gera-transf.l-considera
      tt-gera-transf.nr-ficha
      tt-gera-transf.dt-fabricacao LABEL "DT Fabrica‡Æo"
      tt-gera-transf.it-codigo     
      tt-gera-transf.desc-item
      tt-gera-transf.quantidade    
      tt-gera-transf.lote
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 61.72 BY 10.5 ROW-HEIGHT-CHARS .58 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-3 AT ROW 1 COL 1.29 WIDGET-ID 200
     d-dt-trans AT ROW 2.5 COL 87 COLON-ALIGNED WIDGET-ID 60
     c-conta AT ROW 3.5 COL 87 COLON-ALIGNED WIDGET-ID 54
     c-ccusto AT ROW 4.5 COL 87 COLON-ALIGNED WIDGET-ID 56
     bt-ok AT ROW 12.25 COL 2 HELP
          "Ok" WIDGET-ID 6
     bt-cancela AT ROW 12.25 COL 12 HELP
          "Cancela" WIDGET-ID 4
     "Dados de Sa¡da:" VIEW-AS TEXT
          SIZE 14 BY .88 AT ROW 1.5 COL 71 WIDGET-ID 22
          FONT 1
     rt-button AT ROW 12 COL 1 WIDGET-ID 10
     RECT-5 AT ROW 1.75 COL 66 WIDGET-ID 62
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 128.14 BY 12.54 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Retorno Roteiros p/ Perda"
         HEIGHT             = 12.54
         WIDTH              = 128.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 128.14
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 128.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-3 TEXT-1 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-gera-transf
    BY tt-gera-transf.it-codigo
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _TblList          = "emsfnd.movto-estoq"
     _Query            is OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Retorno Roteiros p/ Perda */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Retorno Roteiros p/ Perda */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.

END.

&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela W-Win
ON CHOOSE OF bt-cancela IN FRAME F-Main /* Cancelar */
DO:
{include/cancefil.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&Scoped-define SELF-NAME BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 W-Win
ON ENTRY OF BROWSE-3 IN FRAME F-Main
DO:

    FIND FIRST tt-gera-transf NO-LOCK NO-ERROR.

    IF AVAIL tt-gera-transf THEN DO:

        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = tt-gera-transf.cod-estabel NO-ERROR.

        IF AVAIL estabelec THEN DO: 
            
            ASSIGN i-empresa = estabelec.ep-codigo.

            /* Retorna formato da conta contabil */
            run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                               input  "",                 /* PLANO CONTAS */
                                                               input  d-dt-trans:SCREEN-VALUE IN FRAME F-Main,/* DATA DE TRANSACAO */
                                                               output c-formato-conta,    /* FORMATO CONTA */
                                                               output table tt_log_erro). /* ERROS */
            /* Retorna formato do centro de custo */
            run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                           input  "",                 /* PLANO CCUSTO */
                                                           input  d-dt-trans:SCREEN-VALUE IN FRAME F-Main,/* DATA DE TRANSACAO */
                                                           output c-formato-ccusto,   /* FORMATO CCUSTO */
                                                           output table tt_log_erro). /* ERROS */ 
           
            /* Formatando conta e centro de custo */
            if c-formato-conta <> "" then do:
                assign c-conta:format  in frame {&FRAME-NAME} = c-formato-conta.
            end.
            if c-formato-ccusto <> "" then do:
                assign c-ccusto:format in frame {&FRAME-NAME} = c-formato-ccusto.
            end. 

        END.

    END.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-3 IN FRAME F-Main
DO:

    if avail tt-gera-transf then do:

        if tt-gera-transf.l-considera = "*":R THEN DO:
    
            assign tt-gera-transf.l-considera = " ".

            ASSIGN tt-gera-transf.l-considera:FONT      IN BROWSE BROWSE-3 = 1
                   tt-gera-transf.nr-ficha:FONT         IN BROWSE BROWSE-3 = 1
                   tt-gera-transf.dt-fabricacao:FONT    IN BROWSE BROWSE-3 = 1
                   tt-gera-transf.it-codigo:FONT        IN BROWSE BROWSE-3 = 1
                   tt-gera-transf.desc-item:FONT        IN BROWSE BROWSE-3 = 1   
                   tt-gera-transf.quantidade:FONT       IN BROWSE BROWSE-3 = 1  
                   tt-gera-transf.lote:FONT             IN BROWSE BROWSE-3 = 1 

                   tt-gera-transf.l-considera:BGCOLOR   IN BROWSE BROWSE-3 = ? 
                   tt-gera-transf.nr-ficha:BGCOLOR      IN BROWSE BROWSE-3 = ? 
                   tt-gera-transf.dt-fabricacao:BGCOLOR IN BROWSE BROWSE-3 = ? 
                   tt-gera-transf.it-codigo:BGCOLOR     IN BROWSE BROWSE-3 = ? 
                   tt-gera-transf.desc-item:BGCOLOR     IN BROWSE BROWSE-3 = ? 
                   tt-gera-transf.quantidade:BGCOLOR    IN BROWSE BROWSE-3 = ? 
                   tt-gera-transf.lote:BGCOLOR          IN BROWSE BROWSE-3 = ?.
        END.

        ELSE DO:
    
            assign tt-gera-transf.l-considera = "*":R.

            ASSIGN tt-gera-transf.l-considera:FONT      IN BROWSE BROWSE-3 = 6
                   tt-gera-transf.nr-ficha:FONT         IN BROWSE BROWSE-3 = 6
                   tt-gera-transf.dt-fabricacao:FONT    IN BROWSE BROWSE-3 = 6
                   tt-gera-transf.it-codigo:FONT        IN BROWSE BROWSE-3 = 6
                   tt-gera-transf.desc-item:FONT        IN BROWSE BROWSE-3 = 6   
                   tt-gera-transf.quantidade:FONT       IN BROWSE BROWSE-3 = 6  
                   tt-gera-transf.lote:FONT             IN BROWSE BROWSE-3 = 6 

                   tt-gera-transf.l-considera:BGCOLOR   IN BROWSE BROWSE-3 = 8 
                   tt-gera-transf.nr-ficha:BGCOLOR      IN BROWSE BROWSE-3 = 8 
                   tt-gera-transf.dt-fabricacao:BGCOLOR IN BROWSE BROWSE-3 = 8 
                   tt-gera-transf.it-codigo:BGCOLOR     IN BROWSE BROWSE-3 = 8 
                   tt-gera-transf.desc-item:BGCOLOR     IN BROWSE BROWSE-3 = 8 
                   tt-gera-transf.quantidade:BGCOLOR    IN BROWSE BROWSE-3 = 8 
                   tt-gera-transf.lote:BGCOLOR          IN BROWSE BROWSE-3 = 8.    
        END.

        disp tt-gera-transf.l-considera with browse BROWSE-3.

    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok W-Win
ON CHOOSE OF bt-ok IN FRAME F-Main /* OK */
DO:

    IF c-conta:SCREEN-VALUE IN FRAME F-Main = "" THEN DO:

        RUN utp/ut-msgs.p (INPUT 'show',
                           INPUT 17006,
                           INPUT "Conta cont bil nÆo cadastrada!"
                           + "~~" +
                           "Deve ser informada uma conta para baixa do estoque.").
    
        APPLY "entry":U TO c-conta IN FRAME F-Main.
        RETURN NO-APPLY.


    END.

    IF v_log_utz_ccusto = YES AND (c-ccusto:SCREEN-VALUE IN FRAME F-Main = "" OR int(c-ccusto:SCREEN-VALUE IN FRAME F-Main) = 0) THEN DO:

        RUN utp/ut-msgs.p (INPUT 'show',
                           INPUT 17006,
                           INPUT "Centro de custo nÆo cadastrado!"
                           + "~~" +
                           "A conta informada utilizada centro de custo, o mesmo dever  ser informado.").
    
        APPLY "entry":U TO c-ccusto IN FRAME F-Main.
        RETURN NO-APPLY.

    END.

    FIND FIRST tt-gera-transf NO-LOCK
         WHERE tt-gera-transf.l-considera = "*" NO-ERROR.

    IF NOT AVAIL tt-gera-transf THEN DO:

           RUN utp/ut-msgs.p (INPUT 'show',
                              INPUT 17006,
                              INPUT "Sele‡Æo de roteiros inv lida!"
                              + "~~" +
                              "Nenhum roteiro foi selecionado para Perda.").
    
           APPLY "entry":U TO d-dt-trans IN FRAME F-Main.
           RETURN NO-APPLY.
    END.
   
    RUN pi-commit.
    
    IF l-ok = YES THEN
   
    APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto W-Win
ON F5 OF c-ccusto IN FRAME F-Main /* Centro Custo */
DO:
   IF v_log_utz_ccusto THEN DO:
       run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                           input "",                  /* CODIGO DO PLANO CCUSTO */
                                           input "",                  /* UNIDADE DE NEGOCIO */
                                           input d-dt-trans:SCREEN-VALUE IN FRAME F-Main, /* DATA DE TRANSACAO */
                                           output v_cod_ccusto,       /* CODIGO CCUSTO */
                                           output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                           output table tt_log_erro). /* ERROS */ 
       if return-value = "OK" then
           ASSIGN SELF:SCREEN-VALUE = v_cod_ccusto.    
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto W-Win
ON LEAVE OF c-ccusto IN FRAME F-Main /* Centro Custo */
DO:
    {cdp/cd9998.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto W-Win
ON MOUSE-SELECT-DBLCLICK OF c-ccusto IN FRAME F-Main /* Centro Custo */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-conta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta W-Win
ON ENTRY OF c-conta IN FRAME F-Main /* Conta */
DO:
  ASSIGN c-conta:FORMAT in frame F-Main = "x(20)".
  ENABLE c-ccusto WITH FRAME F-Main.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta W-Win
ON F5 OF c-conta IN FRAME F-Main /* Conta */
run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "CEP",              /* MàDULO */
                                               input  "",                 /* PLANO DE CONTAS */
                                               input  "(nenhum)",         /* FINALIDADES */
                                               input  d-dt-trans:SCREEN-VALUE IN FRAME F-Main, /* DATA TRANSACAO */
                                               output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                               output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                               output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                               output table tt_log_erro). /* ERROS */ 

   if return-value = "OK" THEN
       ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta W-Win
ON LEAVE OF c-conta IN FRAME F-Main /* Conta */
DO:
    assign self:format = "x(20)".
    ASSIGN v_cod_cta_ctbl = INPUT c-conta.

    FIND FIRST tt-gera-transf NO-LOCK NO-ERROR.

    /* Busca dados da conta cont˜bil */
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        d-dt-trans:SCREEN-VALUE IN FRAME F-Main, /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUAø°O DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */
   
    IF RETURN-VALUE = "OK" THEN DO:
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN SELF:FORMAT = c-formato-conta.

        /* Verifica se a conta utiliza centro de custo */
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                           input  tt-gera-transf.cod-estabel, /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,     /* CONTA */
                                                           input  d-dt-trans:SCREEN-VALUE IN FRAME F-Main, /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */
        IF v_log_utz_ccusto THEN DO:
            ENABLE c-ccusto WITH FRAME F-Main.
        END.
        ELSE DO:
            ASSIGN c-ccusto:SCREEN-VALUE = "".
            DISABLE c-ccusto WITH FRAME F-Main.
        END.
        /************************************************/
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta W-Win
ON MOUSE-SELECT-DBLCLICK OF c-conta IN FRAME F-Main /* Conta */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


if c-ccusto:load-mouse-pointer("image/lupa.cur") THEN.

{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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

  {&OPEN-QUERY-F-Main}
  GET FIRST F-Main.
  DISPLAY d-dt-trans c-conta c-ccusto 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-3 rt-button RECT-5 d-dt-trans c-conta c-ccusto bt-ok bt-cancela 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy W-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  IF  VALID-HANDLE(h_api_cta_ctbl) THEN delete object h_api_cta_ctbl.
  IF  VALID-HANDLE(h_api_ccusto)   THEN delete object h_api_ccusto.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/

   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  {&OPEN-QUERY-{&BROWSE-NAME}}

  /* Code placed here will execute AFTER standard behavior.    */

  /* Handle da API Conta Contÿbil */
  run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
  /* Handle da API Centro Custo */
  run prgint\utb\utb742za.py persistent set h_api_ccusto.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-commit W-Win 
PROCEDURE pi-commit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
ASSIGN l-ok = NO.

FOR EACH tt-gera-transf.

    ASSIGN tt-gera-transf.ct-codigo = REPLACE(c-conta:SCREEN-VALUE IN FRAME F-Main, ".", "")
           tt-gera-transf.sc-codigo = REPLACE(c-ccusto:SCREEN-VALUE IN FRAME F-Main, ".", "")
           tt-gera-transf.dt-trans  = date(d-dt-trans:SCREEN-VALUE IN FRAME F-Main).

    ASSIGN l-ok = YES.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "movto-estoq"}
  {src/adm/template/snd-list.i "tt-gera-transf"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

