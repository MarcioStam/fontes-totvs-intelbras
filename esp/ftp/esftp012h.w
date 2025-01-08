&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
          mgmov            PROGRESS
*/
&Scoped-define WINDOW-NAME w-cadsim


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttped-fiscal NO-UNDO LIKE ped-fiscal
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esftp012h 2.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAM TABLE FOR ttped-fiscal.

FIND FIRST ttped-fiscal NO-ERROR.

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.
DEFINE VARIABLE l-proc-ok-aux        AS LOGICAL NO-UNDO.
DEFINE VARIABLE c-ultimo-metodo-exec AS CHAR    NO-UNDO.
DEFINE VARIABLE l-encontrou          AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-aloca-estoque AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE wh-pesquisa     AS HANDLE  NO-UNDO.

{method/dbotterr.i}

def temp-table tt-it-terc-nf no-undo
        field rw-saldo-terc     as rowid
        field sequencia         like saldo-terc.sequencia
        field it-codigo         like saldo-terc.it-codigo
        field cod-refer         like saldo-terc.cod-refer
        field desc-nar          like item.desc-item
        field quantidade        like saldo-terc.quantidade
        field qt-alocada        like saldo-terc.quantidade
        field qt-disponivel     like saldo-terc.quantidade
        field qt-disponivel-inf like saldo-terc.quantidade
        field preco-total       like componente.preco-total[1]
        field preco-total-inf   like componente.preco-total[1]
        field selecionado       as log
        index codigo 
              sequencia
        index selecionado
              selecionado.

DEFINE TEMP-TABLE tt-erro-aloc  NO-UNDO
        FIELD mensagem AS CHARACTER FORMAT "x(250)".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fNotaDev

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button i-nro-docto c-serie c-nat-operacao ~
c-cod-depos bt-ok bt-cancela 
&Scoped-Define DISPLAYED-OBJECTS fi-estab i-nro-docto c-serie ~
c-nat-operacao c-cod-depos 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-bt-ajuda 
       MENU-ITEM mi-sobre       LABEL "Sobre..."      .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-imprime 
     LABEL "&Imprimir" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-cod-depos LIKE it-ped-fiscal.cod-depos
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nat-operacao LIKE docum-est.nat-operacao
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie LIKE docum-est.serie-docto
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-nro-docto LIKE docum-est.nro-docto
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 47 BY 1.38
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fNotaDev
     fi-estab AT ROW 2 COL 17 COLON-ALIGNED WIDGET-ID 10
     i-nro-docto AT ROW 3 COL 17 COLON-ALIGNED HELP
          "" WIDGET-ID 2
     c-serie AT ROW 4 COL 17 COLON-ALIGNED HELP
          "" WIDGET-ID 4
     c-nat-operacao AT ROW 5 COL 17 COLON-ALIGNED HELP
          "" WIDGET-ID 8
     c-cod-depos AT ROW 6 COL 17 COLON-ALIGNED HELP
          "" WIDGET-ID 6
     bt-ok AT ROW 8.96 COL 3
     bt-cancela AT ROW 8.96 COL 14
     bt-imprime AT ROW 8.96 COL 25
     bt-ajuda AT ROW 9 COL 37
     rt-button AT ROW 8.75 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 12.58 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
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
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Manutená∆o <Insira o complemento>"
         HEIGHT             = 9.25
         WIDTH              = 48.43
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-cadsim 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-cadsim
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fNotaDev
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR BUTTON bt-ajuda IN FRAME fNotaDev
   NO-ENABLE                                                            */
ASSIGN 
       bt-ajuda:HIDDEN IN FRAME fNotaDev           = TRUE
       bt-ajuda:POPUP-MENU IN FRAME fNotaDev       = MENU POPUP-MENU-bt-ajuda:HANDLE.

/* SETTINGS FOR BUTTON bt-imprime IN FRAME fNotaDev
   NO-ENABLE                                                            */
ASSIGN 
       bt-imprime:HIDDEN IN FRAME fNotaDev           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-depos IN FRAME fNotaDev
   LIKE = mgesp.it-ped-fiscal.cod-depos EXP-SIZE                        */
/* SETTINGS FOR FILL-IN c-nat-operacao IN FRAME fNotaDev
   LIKE = mgmov.docum-est.nat-operacao EXP-SIZE                         */
/* SETTINGS FOR FILL-IN c-serie IN FRAME fNotaDev
   LIKE = mgmov.docum-est.serie-docto EXP-SIZE                          */
/* SETTINGS FOR FILL-IN fi-estab IN FRAME fNotaDev
   NO-ENABLE                                                            */
ASSIGN 
       fi-estab:READ-ONLY IN FRAME fNotaDev        = TRUE.

/* SETTINGS FOR FILL-IN i-nro-docto IN FRAME fNotaDev
   LIKE = mgmov.docum-est.nro-docto EXP-SIZE                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Manutená∆o <Insira o complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Manutená∆o <Insira o complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-cadsim
ON CHOOSE OF bt-ajuda IN FRAME fNotaDev /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-cadsim
ON CHOOSE OF bt-cancela IN FRAME fNotaDev /* Cancelar */
DO:
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprime w-cadsim
ON CHOOSE OF bt-imprime IN FRAME fNotaDev /* Imprimir */
DO:
run utp/ut-relat.w persistent set wh-imprime (input c-programa-mg97).
if valid-handle(wh-imprime) then
  run dispatch in wh-imprime ('initialize':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME fNotaDev /* OK */
DO:
    DEFINE VARIABLE v-seq-aux AS INTEGER     NO-UNDO.

    FIND FIRST deposito NO-LOCK 
         WHERE deposito.cod-depos = INPUT FRAME fNotaDev c-cod-depos NO-ERROR.
    IF NOT AVAIL deposito THEN DO:
        MESSAGE "Dep¢sito Inv†lido"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN NO-APPLY.
    END.
/*
    IF ttped-fiscal.cod-estabel = "101" AND
       c-cod-depos = "ACA" THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17567, 
                           INPUT "N∆o permitido solicitar do dep¢sito ACA").
        RETURN NO-APPLY.
    END.
*/
    FOR FIRST docum-est 
        WHERE docum-est.cod-estabel  = ttped-fiscal.cod-estabel
          AND docum-est.serie-docto  = INPUT FRAME fNotaDev c-serie
          AND docum-est.nro-docto    = INPUT FRAME fNotaDev i-nro-docto 
          AND docum-est.cod-emitente = ttPed-fiscal.cod-emitente
          AND docum-est.nat-operacao = INPUT FRAME fNotaDev c-nat-operacao NO-LOCK:
    END.

    FIND FIRST item-doc-est OF docum-est NO-LOCK  NO-ERROR.
        /* WHERE item-doc-est.nro-docto    = INPUT FRAME fNotaDev i-nro-docto 
           AND item-doc-est.serie-docto  = INPUT FRAME fNotaDev c-serie
           AND item-doc-est.cod-emitente = ttPed-fiscal.cod-emitente 
           AND item-doc-est.nat-operacao = INPUT FRAME fNotaDev c-nat-operacao NO-ERROR. */
    IF NOT AVAIL item-doc-est THEN DO:
        MESSAGE "Nota fiscal de Entrada n∆o encontrada"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN NO-APPLY.
    END.

    FIND FIRST mgesp.ped-fiscal EXCLUSIVE-LOCK
         WHERE mgesp.ped-fiscal.nr-pedido = ttPed-fiscal.nr-pedido NO-ERROR.

    FIND LAST mgesp.it-ped-fiscal OF mgesp.ped-fiscal NO-LOCK NO-ERROR.
    
    IF AVAIL mgesp.it-ped-fiscal THEN
       ASSIGN v-seq-aux = mgesp.it-ped-fiscal.seq.
    ELSE
       ASSIGN v-seq-aux = 0.

    run geraItensTerceirosTtItTercNf (input  input frame fNotaDev c-serie,
                                      input  input frame fNotaDev i-nro-docto,
                                      input  input frame fNotaDev c-nat-operacao,
                                      output table tt-it-terc-nf,
                                      output l-proc-ok-aux).
    
    find first RowErrors no-lock no-error.
    if  avail RowErrors then do:
        FOR EACH rowerrors:
        
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT rowerrors.errordescription).
            undo, return.
        END.
    end.
    ASSIGN l-encontrou = NO.

    DO TRANS:
        FOR EACH item-doc-est EXCLUSIVE-LOCK 
            WHERE item-doc-est.nro-docto    = INPUT FRAME fNotaDev i-nro-docto 
            AND   item-doc-est.serie-docto  = INPUT FRAME fNotaDev c-serie     
            AND   item-doc-est.cod-emitente = mgesp.ped-fiscal.cod-emitente:

            FIND tt-it-terc-nf
                WHERE tt-it-terc-nf.it-codigo = item-doc-est.it-codigo
                  AND tt-it-terc-nf.sequencia = item-doc-est.sequencia
                  AND tt-it-terc-nf.cod-refer = ITEM-doc-est.cod-refer
                NO-LOCK NO-ERROR.     

            IF NOT AVAIL tt-it-terc-nf THEN NEXT.

            ASSIGN l-encontrou = YES.

            FIND FIRST item 
                 WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-LOCK NO-ERROR.

            FIND FIRST in-grup-estoq NO-LOCK
                 WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.
                  
/*                 IF  AVAIL in-grup-estoq                                                          */
/*                 AND in-grup-estoq.log-ckd THEN DO:                                               */
/*                                                                                                  */
/*                     RUN esp/es0018p.p (INPUT "CKD-PO", /* Nome do programa */                    */
/*                                        INPUT 1,        /* Ponto do programa */                   */
/*                                        INPUT 0,                                                  */
/*                                        INPUT "",                                                 */
/*                                        OUTPUT TABLE tt-prog-ponto) NO-ERROR.                     */
/*                                                                                                  */
/*                     IF CAN-FIND (FIRST tt-prog-ponto                                             */
/*                                  WHERE tt-prog-ponto.conteudo = ped-fiscal.cod-estabel) THEN DO: */
/*                                                                                                  */
/*                         IF  ped-fiscal.nat-oper <> 8                                             */
/*                         AND ped-fiscal.nat-oper <> 9                                             */
/*                         AND ped-fiscal.nat-oper <> 28 THEN DO:                                   */
/*                             NEXT.                                                                */
/*                         END.                                                                     */
/*                     END.                                                                         */
/*                 END.                                                                             */

            ASSIGN v-seq-aux = v-seq-aux + 1.
            FIND FIRST mgesp.it-ped-fiscal EXCLUSIVE-LOCK 
                WHERE mgesp.it-ped-fiscal.nr-pedido = mgesp.ped-fiscal.nr-pedido 
                  AND mgesp.it-ped-fiscal.it-codigo = item-doc-est.it-codigo 
                  AND mgesp.it-ped-fiscal.seq       = v-seq-aux NO-ERROR.
            IF NOT AVAIL mgesp.it-ped-fiscal THEN DO:
               CREATE mgesp.it-ped-fiscal.
               ASSIGN mgesp.it-ped-fiscal.nr-pedido = mgesp.ped-fiscal.nr-pedido
                      mgesp.it-ped-fiscal.it-codigo = item-doc-est.it-codigo
                      mgesp.it-ped-fiscal.seq       = v-seq-aux.
            END.
            ASSIGN mgesp.it-ped-fiscal.aliquota-ipi          = item-doc-est.aliquota-ipi
                   mgesp.it-ped-fiscal.cod-depos             = INPUT FRAME fNotaDev c-cod-depos
                   mgesp.it-ped-fiscal.qtde                  = tt-it-terc-nf.qt-disponivel
                   mgesp.it-ped-fiscal.un                    = item-doc-est.un
                   mgesp.it-ped-fiscal.vl-unit               = item-doc-est.preco-unit[1] /*tt-it-terc-nf.preco-total*/
                   overlay(mgesp.it-ped-fiscal.char-1,61,18) = string(tt-it-terc-nf.rw-saldo-terc)
                   overlay(mgesp.it-ped-fiscal.char-1,11,8)  = item.class-fisc
                   mgesp.it-ped-fiscal.peso-liq-item         = ITEM.peso-liquido
                   mgesp.it-ped-fiscal.peso-bru-item         = ITEM.peso-bruto
                   mgesp.it-ped-fiscal.narrativa             = item-doc-est.narrativa
                   mgesp.it-ped-fiscal.nf-referenciada       = item-doc-est.nro-docto.

            IF ITEM.tipo-contr <> 4 AND
               ITEM.baixa-estoq = YES THEN DO:
                if l-aloca-estoque then do: 

                    FIND FIRST in-grup-estoq NO-LOCK
                         WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.

                    /*Alocaá∆o por lote*/
                    IF ITEM.tipo-con-est = 3 THEN DO:
                        RUN esp/ftp/esftp012f.p (INPUT YES,                           /*p-log-aloca  */
                                                 INPUT it-ped-fiscal.nr-pedido,       /*p-nr-pedido  */
                                                 INPUT it-ped-fiscal.it-codigo,       /*p-it-codigo  */
                                                 INPUT it-ped-fiscal.seq,             /*p-seq        */
                                                 INPUT ttPed-fiscal.cod-estabel,      /*p-cod-estabel*/
                                                 INPUT it-ped-fiscal.cod-localizacao, /*p-cod-localiz*/
                                                 INPUT it-ped-fiscal.cod-depos,       /*p-cod-depos  */
                                                 INPUT it-ped-fiscal.qtde,            /*p-qtde-alocar*/
                                                 OUTPUT TABLE tt-erro-aloc).         
                        FOR FIRST tt-erro-aloc:
                            RUN utp/ut-msgs.p (INPUT "show":U, 
                                                INPUT 17567, 
                                                INPUT tt-erro-aloc.mensagem).
                            UNDO, RETURN.
                        END.
                    END.
                    /*Alocaá∆o sem lote*/
                    ELSE DO:
                        find first saldo-estoq
                             where saldo-estoq.it-codigo   = mgesp.it-ped-fiscal.it-codigo
                               and saldo-estoq.cod-estabel = ttped-fiscal.cod-estabel
                               and saldo-estoq.cod-localiz = mgesp.it-ped-fiscal.cod-localiz
                               and saldo-estoq.cod-depos   = mgesp.it-ped-fiscal.cod-depos no-lock no-error.           
                                
                        if not avail saldo-estoq then do:
                             RUN utp/ut-msgs.p (INPUT "show":U, 
                                                INPUT 17567, 
                                                INPUT "Item sem saldo em estoque " + mgesp.it-ped-fiscal.it-codigo).
                             undo, return.
                        end.
                        if saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped - 
                           saldo-estoq.qt-aloc-prod < dec(it-ped-fiscal.qtde) then do:
                             RUN utp/ut-msgs.p (INPUT "show":U, 
                                                INPUT 17567, 
                                                INPUT "Item com saldo " + string(saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped - 
                                                      saldo-estoq.qt-aloc-prod) + " em estoque menor que a quantidade informada " + string(it-ped-fiscal.qtde) + ", inclus∆o n∆o permitida":U ).
                             undo, return.
                        end.                    
                       
                        find current saldo-estoq exclusive-lock no-error.
                        assign saldo-estoq.qt-alocada = saldo-estoq.qt-alocada + mgesp.it-ped-fiscal.qtde.    
                        release saldo-estoq.
                    END.
                end.
            END.
        END.
    END.
    IF l-encontrou = NO THEN DO:
        MESSAGE "N∆o encontrou nenhum item com saldo terc para esta nota informada"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ASSIGN ped-fiscal.nro-docto           = Int(INPUT FRAME fNotaDev i-nro-docto)
           ped-fiscal.serie-docto         = INPUT FRAME fNotaDev c-serie                    
           overlay(ped-fiscal.char-1,1,6) = INPUT FRAME fNotaDev c-nat-operacao.

    
    RUN notify ('cancel-record':U).
    APPLY "close":U to this-procedure.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nat-operacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-operacao w-cadsim
ON F5 OF c-nat-operacao IN FRAME fNotaDev /* Nat Operaá∆o */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z06in176.w
                       &campo=i-nro-docto
                       &campozoom=nro-docto
                       &frame=fNotaDev
                       &campo2=c-serie
                       &campozoom2=serie-docto
                       &frame2=fNotaDev
                       &campo3=c-nat-operacao
                       &campozoom3=nat-operacao
                       &frame3=fNotaDev}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-operacao w-cadsim
ON LEAVE OF c-nat-operacao IN FRAME fNotaDev /* Nat Operaá∆o */
DO:
    RUN pi-leave.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-operacao w-cadsim
ON MOUSE-SELECT-DBLCLICK OF c-nat-operacao IN FRAME fNotaDev /* Nat Operaá∆o */
DO:
    APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-serie w-cadsim
ON F5 OF c-serie IN FRAME fNotaDev /* SÇrie */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z06in176.w
                       &campo=i-nro-docto
                       &campozoom=nro-docto
                       &frame=fNotaDev
                       &campo2=c-serie
                       &campozoom2=serie-docto
                       &frame2=fNotaDev
                       &campo3=c-nat-operacao
                       &campozoom3=nat-operacao
                       &frame3=fNotaDev}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-serie w-cadsim
ON LEAVE OF c-serie IN FRAME fNotaDev /* SÇrie */
DO:
    RUN pi-leave.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-serie w-cadsim
ON MOUSE-SELECT-DBLCLICK OF c-serie IN FRAME fNotaDev /* SÇrie */
DO:
    APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-nro-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nro-docto w-cadsim
ON F5 OF i-nro-docto IN FRAME fNotaDev /* Documento */
DO:
        {include/zoomvar.i &prog-zoom=inzoom/z06in176.w
                           &campo=i-nro-docto
                           &campozoom=nro-docto
                           &frame=fNotaDev
                           &campo2=c-serie
                           &campozoom2=serie-docto
                           &frame2=fNotaDev
                           &campo3=c-nat-operacao
                           &campozoom3=nat-operacao
                           &frame3=fNotaDev}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nro-docto w-cadsim
ON LEAVE OF i-nro-docto IN FRAME fNotaDev /* Documento */
DO:
    RUN pi-leave.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nro-docto w-cadsim
ON MOUSE-SELECT-DBLCLICK OF i-nro-docto IN FRAME fNotaDev /* Documento */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-cadsim
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-cadsim  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-cadsim  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-cadsim  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
  THEN DELETE WIDGET w-cadsim.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-cadsim  _DEFAULT-ENABLE
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
  DISPLAY fi-estab i-nro-docto c-serie c-nat-operacao c-cod-depos 
      WITH FRAME fNotaDev IN WINDOW w-cadsim.
  ENABLE rt-button i-nro-docto c-serie c-nat-operacao c-cod-depos bt-ok 
         bt-cancela 
      WITH FRAME fNotaDev IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-fNotaDev}
  VIEW w-cadsim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraItensTerceirosTtItTercNf w-cadsim 
PROCEDURE geraItensTerceirosTtItTercNf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input  param p-c-serie-terc      like saldo-terc.serie-docto   no-undo.
    def input  param p-c-nr-nota-terc    like saldo-terc.nro-docto     no-undo.
    def input  param p-c-nat-oper-terc   like saldo-terc.nat-operacao  no-undo.
    def output param table               for tt-it-terc-nf.
    def output param p-l-procedimento-ok as   log                      no-undo.

    DEF BUFFER b-componente FOR componente.

    assign c-ultimo-metodo-exec = replace(program-name(1)," ":U, "~~":U).

    /* Definicao de variaveis locais */
    def var l-proc-ok-aux as log    no-undo.

    for each tt-it-terc-nf exclusive:
        delete tt-it-terc-nf.
    end.

    for each saldo-terc 
        where saldo-terc.nro-docto    = p-c-nr-nota-terc 
        and   saldo-terc.serie-docto  = p-c-serie-terc 
        and   saldo-terc.nat-operacao = p-c-nat-oper-terc 
        and   saldo-terc.cod-emitente = mgesp.ped-fiscal.cod-emitente  no-lock,
        first componente
        where componente.serie-docto  = saldo-terc.serie-docto
        and   componente.nro-docto    = saldo-terc.nro-docto
        and   componente.cod-emitente = saldo-terc.cod-emitente
        and   componente.nat-operacao = saldo-terc.nat-operacao
        and   componente.it-codigo    = saldo-terc.it-codigo
        and   componente.cod-refer    = saldo-terc.cod-refer
        and   componente.sequencia    = saldo-terc.sequencia no-lock:

        FIND ITEM WHERE item.it-codigo = saldo-terc.it-codigo
            NO-LOCK NO-ERROR.
        IF saldo-terc.quantidade - saldo-terc.dec-1 <= 0 THEN NEXT.
        create tt-it-terc-nf.
        assign tt-it-terc-nf.rw-saldo-terc     = rowid(saldo-terc)
               tt-it-terc-nf.sequencia         = saldo-terc.sequencia
               tt-it-terc-nf.it-codigo         = saldo-terc.it-codigo
               tt-it-terc-nf.cod-refer         = saldo-terc.cod-refer
               tt-it-terc-nf.desc-nar          = if  item.tipo-contr = 4 /* D˝bito Direto */
                                                 then substr(item.narrativa,1,60)
                                                 else item.desc-item
               tt-it-terc-nf.quantidade        = saldo-terc.quantidade
               tt-it-terc-nf.qt-alocada        = saldo-terc.dec-1
               tt-it-terc-nf.qt-disponivel     = saldo-terc.quantidade - saldo-terc.dec-1
               tt-it-terc-nf.qt-disponivel-inf = (saldo-terc.quantidade - saldo-terc.dec-1)
               tt-it-terc-nf.preco-total       = componente.preco-total[1]
               tt-it-terc-nf.selecionado       = no.

        for each b-componente
            fields (b-componente.componente
                    b-componente.preco-total[1]
                    b-componente.desconto[1])
            where b-componente.cod-emitente = componente.cod-emitente 
            and   b-componente.nro-comp     = componente.nro-docto    
            and   b-componente.serie-comp   = componente.serie-docto  
            and   b-componente.nat-comp     = componente.nat-operacao 
            and   b-componente.it-codigo    = componente.it-codigo    
            and   b-componente.cod-refer    = componente.cod-refer   
            and   b-componente.seq-comp     = componente.sequencia 
            and   (   b-componente.quantidade <> 0
                   or b-componente.dt-retorno <= mgesp.ped-fiscal.dt-emissao ) no-lock: /* NF Reajuste ate Dt Trans */ 
    

            if  b-componente.componente = 1 then /* Envio */
                assign tt-it-terc-nf.preco-total = tt-it-terc-nf.preco-total + b-componente.preco-total[1].
            else /* Retorno */
                assign tt-it-terc-nf.preco-total = tt-it-terc-nf.preco-total - b-componente.preco-total[1].
        end.

/*         if  natur-oper.tp-oper-terc = 6 then /* Reajuste de preØo */       */
/*             assign tt-it-terc-nf.preco-total = tt-it-terc-nf.preco-total . */

        assign tt-it-terc-nf.preco-total     = if tt-it-terc-nf.preco-total < 0 then 0
                                               else tt-it-terc-nf.preco-total
               tt-it-terc-nf.preco-total-inf = tt-it-terc-nf.preco-total.
    end.

    for each RowErrors
        where RowErrors.ErrorType = "INTERNAL":U:
        delete RowErrors.
    end.

    assign p-l-procedimento-ok = yes. /* Indica que o processo ocorreu por completo */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-cadsim 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-cadsim 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-cadsim 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "esftp012h" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN dispatch  IN this-procedure ('enable-fields':U).

  IF AVAIL ttped-fiscal THEN
      ASSIGN fi-estab:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ttped-fiscal.cod-estab.
  ELSE
      ASSIGN fi-estab:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

  for first mgesp.ponto-programa
      where ponto-programa.nome-programa = "esftp012"
        AND ponto-programa.ponto         = 1,
       EACH mgesp.conteudo-programa NO-LOCK
      WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
        and conteudo-programa.conteudo = "Sim":
      assign l-aloca-estoque = yes.
  end.

  i-nro-docto:load-mouse-pointer ("image/lupa.cur") IN FRAME fNotaDev.
  c-serie:load-mouse-pointer ("image/lupa.cur") IN FRAME fNotaDev.
  c-nat-operacao:load-mouse-pointer ("image/lupa.cur") IN FRAME fNotaDev.

  {include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave w-cadsim 
PROCEDURE pi-leave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST docum-est NO-LOCK
         WHERE docum-est.cod-emitente = ttPed-fiscal.cod-emitente
           AND docum-est.nro-docto    = INPUT FRAME fNotaDev i-nro-docto
           AND docum-est.serie-docto  = INPUT FRAME fNotaDev c-serie
           AND docum-est.nat-operacao = INPUT FRAME fNotaDev c-nat-operacao NO-ERROR.

    ASSIGN c-cod-depos:SCREEN-VALUE IN FRAME fNotaDev = "".
    IF AVAIL docum-est THEN DO:
        FIND FIRST item-doc-est OF docum-est NO-LOCK NO-ERROR.

        IF AVAIL item-doc-est THEN DO:
            FIND FIRST rat-lote NO-LOCK
                 WHERE rat-lote.cod-emitente = item-doc-est.cod-emitente
                   AND rat-lote.nro-docto    = item-doc-est.nro-docto
                   AND rat-lote.serie-docto  = item-doc-est.serie-docto
                   AND rat-lote.nat-operacao = item-doc-est.nat-operacao
                   AND rat-lote.sequencia    = item-doc-est.sequencia NO-ERROR.

            IF AVAIL rat-lote THEN
                ASSIGN c-cod-depos:SCREEN-VALUE IN FRAME fNotaDev = rat-lote.cod-depos.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-cadsim  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-cadsim 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

