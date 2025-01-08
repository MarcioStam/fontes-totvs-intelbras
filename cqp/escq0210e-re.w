&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
    FIELD l-considera   AS CHAR FORMAT "x(01)" LABEL "Rejeita Roteiro?"
    FIELD cod-estabel   LIKE ficha-cq.cod-estabel
    FIELD nr-ficha      LIKE ficha-cq.nr-ficha
    FIELD it-codigo     LIKE ficha-cq.it-codigo
    FIELD desc-item     LIKE ITEM.desc-item
    FIELD dt-fabricacao AS DATE FORMAT "99/99/9999" LABEL "DT Fabricaá∆o"
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

/*--- Variˇveis definidas para que se possa utilizar o zoom 
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
&Scoped-define INTERNAL-TABLES tt-gera-transf

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 tt-gera-transf.l-considera tt-gera-transf.nr-ficha tt-gera-transf.dt-fabricacao tt-gera-transf.it-codigo tt-gera-transf.desc-item tt-gera-transf.quantidade tt-gera-transf.lote   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 tt-gera-transf.dt-fabricacao   
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-3 tt-gera-transf
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-3 tt-gera-transf
&Scoped-define SELF-NAME BROWSE-3
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH tt-gera-transf     BY tt-gera-transf.it-codigo
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY {&SELF-NAME} FOR EACH tt-gera-transf     BY tt-gera-transf.it-codigo.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 tt-gera-transf
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 tt-gera-transf


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button RECT-1 RECT-2 RECT-3 BROWSE-3 ~
c-cod-depos-ent c-cod-localiz-ent bt-confirma d-data-fabric i-codigo-rejei ~
c-observacao bt-ok bt-cancela 
&Scoped-Define DISPLAYED-OBJECTS c-cod-depos-ent c-desc-dep ~
c-cod-localiz-ent c-desc-local d-data-fabric i-codigo-rejei c-descricao ~
c-observacao 

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

DEFINE BUTTON bt-confirma 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-cod-depos-ent LIKE deposito.cod-depos
     LABEL "Deposito Entrada" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-cod-localiz-ent AS CHARACTER FORMAT "x(12)" 
     LABEL "Localizaá∆o Entrada" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-desc-dep LIKE deposito.nome
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-local AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-observacao AS CHARACTER FORMAT "x(50)" 
     LABEL "Observaá∆o":R15 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE d-data-fabric AS DATE FORMAT "99/99/9999" INITIAL 01/01/001 
     LABEL "Data Fabricaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-codigo-rejei AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Motivo Rejeiá∆o.":R20 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY 4.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY 3.25.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY 3.25.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 62 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      tt-gera-transf SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _FREEFORM
  QUERY BROWSE-3 DISPLAY
      tt-gera-transf.l-considera
      tt-gera-transf.nr-ficha
      tt-gera-transf.dt-fabricacao LABEL "DT Fabricaá∆o"
      tt-gera-transf.it-codigo     
      tt-gera-transf.desc-item
      tt-gera-transf.quantidade    
      tt-gera-transf.lote
  ENABLE
      tt-gera-transf.dt-fabricacao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 61.72 BY 10.5 ROW-HEIGHT-CHARS .58 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-3 AT ROW 1 COL 1.29 WIDGET-ID 200
     c-cod-depos-ent AT ROW 2.5 COL 83 COLON-ALIGNED HELP
          "" WIDGET-ID 12
          LABEL "Deposito Entrada"
          FONT 1
     c-desc-dep AT ROW 2.5 COL 91 COLON-ALIGNED HELP
          "Descriá∆o do Dep¢sito" NO-LABEL WIDGET-ID 14
     c-cod-localiz-ent AT ROW 3.75 COL 83 COLON-ALIGNED WIDGET-ID 16
     c-desc-local AT ROW 3.75 COL 97 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     bt-confirma AT ROW 7 COL 99 WIDGET-ID 36 NO-TAB-STOP 
     d-data-fabric AT ROW 7.25 COL 83 COLON-ALIGNED HELP
          "Data de fabricaá∆o" WIDGET-ID 24
     i-codigo-rejei AT ROW 10 COL 83 COLON-ALIGNED WIDGET-ID 46
     c-descricao AT ROW 10 COL 92 NO-LABEL WIDGET-ID 48
     c-observacao AT ROW 11.25 COL 78 COLON-ALIGNED WIDGET-ID 50
     bt-ok AT ROW 12.25 COL 2 HELP
          "Ok" WIDGET-ID 6
     bt-cancela AT ROW 12.25 COL 12 HELP
          "Cancela" WIDGET-ID 4
     "Condiá‰es p/ Rejeiá∆o:" VIEW-AS TEXT
          SIZE 19 BY .88 AT ROW 9 COL 69 WIDGET-ID 44
          FONT 1
     "Processa Alteraá∆o Data Fabricaá∆o:" VIEW-AS TEXT
          SIZE 27 BY .88 AT ROW 5.5 COL 69 WIDGET-ID 40
          FONT 1
     "Dados de Entrada:" VIEW-AS TEXT
          SIZE 14 BY .88 AT ROW 1.25 COL 69 WIDGET-ID 22
          FONT 1
     rt-button AT ROW 12 COL 1 WIDGET-ID 10
     RECT-1 AT ROW 1.5 COL 64 WIDGET-ID 20
     RECT-2 AT ROW 5.75 COL 64 WIDGET-ID 38
     RECT-3 AT ROW 9.25 COL 64 WIDGET-ID 42
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 128.14 BY 12.71 WIDGET-ID 100.


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
         TITLE              = "Retorno Roteiros Rejeitados"
         HEIGHT             = 12.71
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
/* BROWSE-TAB BROWSE-3 RECT-3 F-Main */
/* SETTINGS FOR FILL-IN c-cod-depos-ent IN FRAME F-Main
   LIKE = mgcad2.deposito.cod-depos EXP-LABEL EXP-SIZE                  */
/* SETTINGS FOR FILL-IN c-desc-dep IN FRAME F-Main
   NO-ENABLE LIKE = mgcad2.deposito.nome EXP-LABEL EXP-SIZE             */
/* SETTINGS FOR FILL-IN c-desc-local IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Retorno Roteiros Rejeitados */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Retorno Roteiros Rejeitados */
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


&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma W-Win
ON CHOOSE OF bt-confirma IN FRAME F-Main /* Save */
DO:    
    FOR EACH tt-gera-transf.

        ASSIGN tt-gera-transf.dt-fabricacao = date(d-data-fabric:SCREEN-VALUE IN FRAME F-Main).

    END.
    
   {&OPEN-QUERY-{&BROWSE-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok W-Win
ON CHOOSE OF bt-ok IN FRAME F-Main /* OK */
DO:
    DEFINE VARIABLE d-data-fabric     AS DATE        NO-UNDO.
    DEFINE VARIABLE d-data-valid-lote AS DATE        NO-UNDO.
    DEFINE VARIABLE i-dias-val        AS INTEGER     NO-UNDO.

    IF CAN-FIND (FIRST tt-gera-transf
                 WHERE tt-gera-transf.dt-fabricacao = ?) THEN DO:
    
        RUN utp/ut-msgs.p (INPUT 'show',
                           INPUT 17006,
                           INPUT "Data de fabricaá∆o inv†lida!"
                           + "~~" +
                           "A data de fabricaá∆o deve ser preenchida.").
            RETURN NO-APPLY.
    END.
    
    IF CAN-FIND (FIRST tt-gera-transf
                 WHERE tt-gera-transf.dt-fabricacao > TODAY) THEN DO:
    
        RUN utp/ut-msgs.p (INPUT 'show',
                           INPUT 17006,
                           INPUT "Data de fabricaá∆o inv†lida!"
                           + "~~" +
                           "A data de fabricaá∆o n∆o pode ser maior que hoje.").
        RETURN NO-APPLY.
    END.

    FOR EACH b-tt-gera-transf:
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = b-tt-gera-transf.it-codigo NO-ERROR.

        FIND FIRST ficha-cq NO-LOCK
             WHERE ficha-cq.nr-ficha = b-tt-gera-transf.nr-ficha NO-ERROR.

        IF ITEM.tipo-con-est = 3 THEN DO: /* Item Controlado por Lote */
            FOR FIRST familia NO-LOCK 
                WHERE familia.fm-codigo = item.fm-codigo:
            
                ASSIGN i-dias-val = 1.
                FOR FIRST int-familia OF familia NO-LOCK:
                    ASSIGN i-dias-val = int-familia.meses-validade * 30.
                END.
            END.
            
            ASSIGN d-data-fabric     = b-tt-gera-transf.dt-fabricacao
                   d-data-valid-lote = DATE("01/" + string(month(date(d-data-fabric + i-dias-val)),"99") + "/" + string(YEAR(date(d-data-fabric + i-dias-val)),"9999")).
            
            IF d-data-valid-lote < TODAY THEN DO:
                RUN utp/ut-msgs.p (INPUT 'show',
                                   INPUT 17006,
                                   INPUT "Data de validade inv†lida!"
                                   + "~~" +
                                   "Data de Validade n∆o pode ser menor do que a data atual!").
                RETURN NO-APPLY.
            END.
        END.
        /* CKD precisa ser lote */
        IF CAN-FIND(first in-grup-estoq 
                    where in-grup-estoq.ge-codigo = ITEM.ge-codigo
                      AND in-grup-estoq.log-ckd   = YES) THEN DO:
           IF ITEM.tipo-con-est <> 3 THEN DO:
              RUN utp/ut-msgs.p(INPUT "show",
                                INPUT 17006,
                                INPUT "Item " + ITEM.it-codigo + " CKD sem ser lote!~~Liberaá∆o de CKD apenas Ç permitido para itens controlados por lote.").
              RETURN NO-APPLY.    
           END.
        END.
    END.
    
    FIND FIRST tt-gera-transf NO-LOCK
         WHERE tt-gera-transf.l-considera = "*" NO-ERROR.

    IF NOT AVAIL tt-gera-transf THEN DO:

           RUN utp/ut-msgs.p (INPUT 'show',
                              INPUT 17006,
                              INPUT "Seleá∆o de roteiros inv†lida!"
                              + "~~" +
                              "Nenhum roteiro foi selecionado para Rejeiá∆o.").
    
           APPLY "entry":U TO c-cod-depos-ent IN FRAME F-Main.
           RETURN NO-APPLY.
    END.
 
    FIND FIRST deposito NO-LOCK
         WHERE deposito.cod-depos = c-cod-depos-ent:SCREEN-VALUE IN FRAME F-Main NO-ERROR.

    IF AVAIL deposito THEN DO: 
      
      IF deposito.ind-dep-rej = NO THEN DO:
    
           RUN utp/ut-msgs.p (INPUT 'show',
                              INPUT 17006,
                              INPUT "Dep¢sito de entrada inv†lido!"
                              + "~~" +
                              "Para esta transaá∆o deve ser utilizado um deposito de Rejeiá∆o.").
    
           APPLY "entry":U TO c-cod-depos-ent IN FRAME F-Main.
           RETURN NO-APPLY.

      END.

    END.

    ELSE DO:

         RUN utp/ut-msgs.p (INPUT 'show',
                            INPUT 17006,
                            INPUT "Dep¢sito de entrada n∆o cadastrado!"
                            + "~~" +
                            "Informe um dep¢sito de entrada v†lido.").
    
         APPLY "entry":U TO c-cod-depos-ent IN FRAME F-Main.
         RETURN NO-APPLY.

    END.

    FIND FIRST mgind.localizacao NO-LOCK
         WHERE localizacao.cod-estabel = tt-gera-transf.cod-estabel
           AND localizacao.cod-depos   = c-cod-depos-ent:SCREEN-VALUE IN FRAME F-Main
           AND localizacao.cod-localiz = c-cod-localiz-ent:SCREEN-VALUE IN FRAME F-Main NO-ERROR.

    IF NOT AVAIL localizacao THEN DO:

        RUN utp/ut-msgs.p (INPUT 'show',
                           INPUT 17006,
                           INPUT "Localizaá∆o de entrada n∆o cadastrada!"
                           + "~~" +
                           "Informe uma localizaá∆o de entrada v†lida.").
    
        APPLY "entry":U TO c-cod-localiz-ent IN FRAME F-Main.
        RETURN NO-APPLY.

    END.

    FIND FIRST cod-rejeicao NO-LOCK
         WHERE cod-rejeicao.codigo-rejei = int(i-codigo-rejei:SCREEN-VALUE IN FRAME F-Main) NO-ERROR.

    IF NOT AVAIL cod-rejeicao THEN DO:

        RUN utp/ut-msgs.p (INPUT 'show',
                           INPUT 17006,
                           INPUT "Codigo de rejeiá∆o n∆o cadastrado!"
                           + "~~" +
                           "Informe um codigo de rejeiá∆o v†lido.").
    
        APPLY "entry":U TO i-codigo-rejei IN FRAME F-Main.
        RETURN NO-APPLY.

    END.

    ELSE DO:
 
       IF cod-rejeicao.tipo-rejeicao <> 1 THEN DO:

            RUN utp/ut-msgs.p (INPUT 'show',
                               INPUT 17006,
                               INPUT "Codigo de rejeiá∆o inv†lido!"
                               + "~~" +
                               "Verifique o tipo do codigo de rejeiá∆o informado.").
    
            APPLY "entry":U TO i-codigo-rejei IN FRAME F-Main.
            RETURN NO-APPLY.

       END.

    END.


   
    RUN pi-commit.
    
    IF l-ok = YES THEN
   
    APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-depos-ent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos-ent W-Win
ON F5 OF c-cod-depos-ent IN FRAME F-Main /* Deposito Entrada */
DO:
  /* ZOOM SMART OBJECT */
  {include/zoomvar.i &prog-zoom=inzoom/z01in084.w
                     &campo="c-cod-depos-ent"
                     &campozoom="cod-depos"
                     &frame="F-Main"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos-ent W-Win
ON LEAVE OF c-cod-depos-ent IN FRAME F-Main /* Deposito Entrada */
DO:

  FIND FIRST deposito NO-LOCK
       WHERE deposito.cod-depos = c-cod-depos-ent:SCREEN-VALUE IN FRAME F-Main NO-ERROR.

  IF AVAIL deposito THEN DO:

      assign c-desc-dep:screen-value in frame F-Main = deposito.nome.

  END.

  ELSE DO:

      assign c-desc-dep:screen-value in frame F-Main = "".

  END.

END.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos-ent W-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-depos-ent IN FRAME F-Main /* Deposito Entrada */
DO:
   APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-localiz-ent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-localiz-ent W-Win
ON F5 OF c-cod-localiz-ent IN FRAME F-Main /* Localizaá∆o Entrada */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z02in189.w"
                     &campo=c-cod-localiz-ent
                     &campozoom=cod-localiz}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-localiz-ent W-Win
ON LEAVE OF c-cod-localiz-ent IN FRAME F-Main /* Localizaá∆o Entrada */
DO:

  FIND FIRST mgind.localizacao NO-LOCK
       WHERE localizacao.cod-estabel = tt-gera-transf.cod-estabel
         AND localizacao.cod-depos   = c-cod-depos-ent:SCREEN-VALUE IN FRAME F-Main
         AND localizacao.cod-localiz = c-cod-localiz-ent:SCREEN-VALUE IN FRAME F-Main NO-ERROR.

  IF AVAIL localizacao THEN DO:

      assign c-desc-local:screen-value in frame F-Main = localizacao.descricao.

  END.

  ELSE DO:

      assign c-desc-local:screen-value in frame F-Main = "".

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-localiz-ent W-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-localiz-ent IN FRAME F-Main /* Localizaá∆o Entrada */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-codigo-rejei
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-codigo-rejei W-Win
ON F5 OF i-codigo-rejei IN FRAME F-Main /* Motivo Rejeiá∆o. */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in047.w
                     &campo=i-codigo-rejei
                     &campozoom=codigo-rejei}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-codigo-rejei W-Win
ON LEAVE OF i-codigo-rejei IN FRAME F-Main /* Motivo Rejeiá∆o. */
DO:
  {include/leave.i &tabela=cod-rejeicao
                   &atributo-ref=descricao
                   &variavel-ref=c-descricao
                   &where="cod-rejeicao.codigo-rejei = input frame {&frame-name} i-codigo-rejei"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-codigo-rejei W-Win
ON MOUSE-SELECT-DBLCLICK OF i-codigo-rejei IN FRAME F-Main /* Motivo Rejeiá∆o. */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


if c-cod-localiz-ent:load-mouse-pointer("image/lupa.cur") THEN.
if i-codigo-rejei:load-mouse-pointer("image/lupa.cur") THEN.

/* Include custom  Main Block code for SmartWindows. */
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
  DISPLAY c-cod-depos-ent c-desc-dep c-cod-localiz-ent c-desc-local 
          d-data-fabric i-codigo-rejei c-descricao c-observacao 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE rt-button RECT-1 RECT-2 RECT-3 BROWSE-3 c-cod-depos-ent 
         c-cod-localiz-ent bt-confirma d-data-fabric i-codigo-rejei 
         c-observacao bt-ok bt-cancela 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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

    ASSIGN tt-gera-transf.dep-entrada = c-cod-depos-ent:SCREEN-VALUE IN FRAME F-Main
           tt-gera-transf.loc-entrada = c-cod-localiz-ent:SCREEN-VALUE IN FRAME F-Main
           tt-gera-transf.cod-rej     = int(i-codigo-rejei:SCREEN-VALUE IN FRAME F-Main)
           tt-gera-transf.obs         = c-observacao:SCREEN-VALUE IN FRAME F-Main.

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

