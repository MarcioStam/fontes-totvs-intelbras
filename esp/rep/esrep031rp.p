/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*:T*******************************************************************************
**
**  Programa.: esp/rep/esrep031rp.p
**  Objetivo.: Gerar Notas Industrializaá∆o
**  Criaá∆o..: 06/05/2010 - Gustavo Eduardo Tamanini - SQL WORKS
**
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESREP031RP 2.00.00.002}

{utp/ut-glob.i}
{include/i-rpvar.i}

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHAR FORMAT "x(35)":U
    FIELD usuario           AS CHAR FORMAT "x(12)":U
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    FIELD cod-estabel       LIKE docum-est.cod-estabel
    FIELD serie             LIKE docum-est.serie
    FIELD nro-docto         AS INTEGER FORMAT "9999999":U
    FIELD nat-retorno       LIKE docum-est.nat-operacao
    FIELD nat-servico       LIKE docum-est.nat-operacao
    FIELD num-pedido        LIKE pedido-compr.num-pedido
    FIELD nr-ord-prod       LIKE ord-prod.nr-ord-prod
    FIELD dt-trans          LIKE docum-est.dt-trans
    FIELD cod-depos-ret     LIKE saldo-terc.cod-depos
    FIELD cod-depos-serv    LIKE saldo-terc.cod-depos
    FIELD cod-fornec        LIKE emitente.cod-emitente
    FIELD it-codigo         LIKE ITEM.it-codigo
    FIELD qtd               LIKE saldo-terc.quantidade
    FIELD cod-modalid-frete LIKE modalid-frete.cod-modalid-frete.
    
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita       AS RAW.

/* Definiá∆o da temp-table tt-docum-est */
DEFINE TEMP-TABLE tt-docum-est NO-UNDO LIKE docum-est
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-docum-est-aux NO-UNDO LIKE docum-est
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-item-doc-est NO-UNDO LIKE item-doc-est
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-dupli-apagar NO-UNDO LIKE dupli-apagar
    FIELD r-Rowid AS ROWID.
/* inbo/boin404re.i1 */

DEFINE TEMP-TABLE tt-it-terc NO-UNDO 
    FIELD sequencia     LIKE componente.sequencia
    FIELD it-codigo     LIKE componente.it-codigo
    FIELD nr-ord-prod   LIKE componente.nr-ord-prod
    FIELD quantidade    LIKE componente.quantidade
    FIELD preco-unit    LIKE item-doc-est.preco-unit extent 0
    FIELD preco-total   LIKE componente.preco-total  extent 0
    FIELD data-corte    LIKE componente.dt-retorno
    FIELD cod-depos     LIKE componente.cod-depos
    FIELD cod-refer     LIKE componente.cod-refer
    FIELD rw-reservas   AS   ROWID
    FIELD aux           AS   CHAR
    INDEX seq
          sequencia .

DEF TEMP-TABLE tt-saldo-terc NO-UNDO LIKE saldo-terc.

/* Function */
FUNCTION fnNf   RETURNS CHAR (p-tipo AS INTEGER) FORWARD.
FUNCTION fnData RETURNS DATE () FORWARD.

{cdp/cd0666.i} /* definiá∆o da temp-table de erros */   
{method/dbotterr.i}       

DEF TEMP-TABLE tt-erro-aux NO-UNDO LIKE tt-erro.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

DEF VAR h-acomp            AS HANDLE               NO-UNDO.
DEF VAR c-lb-erro          AS CHAR FORMAT "x(10)"  NO-UNDO.
DEF VAR c-lb-mensagem      AS CHAR FORMAT "x(15)"  NO-UNDO.
DEF VAR c-espaco           AS CHAR FORMAT "x(130)" NO-UNDO.
DEF VAR c-conta-transit    AS CHAR                 NO-UNDO.
DEF VAR i-seq-item         AS INTEG NO-UNDO INITIAL 0.
DEF VAR c-estado-emit      AS CHAR                 NO-UNDO.
DEF VAR l-cabec            AS LOGICAL              NO-UNDO.
DEF VAR h-boin090          AS HANDLE               NO-UNDO.
DEF VAR h-boin176          AS HANDLE               NO-UNDO.
DEF VAR h-boin404re        AS HANDLE               NO-UNDO.
DEF VAR h-boin092          AS HANDLE               NO-UNDO.
DEF VAR i-seq-erro         AS INTEG NO-UNDO INITIAL 0.
DEF VAR r-rowid-docum      AS ROWID                NO-UNDO.
DEF VAR i-numer-ordem      LIKE ordem-compr.numero-ordem NO-UNDO.

DEF VAR l-erro AS LOGICAL.


ASSIGN l-erro = FALSE.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST empresa NO-LOCK
     WHERE empresa.ep-codigo = param-global.empresa-pri.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Gera Notas Industrializaá∆o Pres°dio":U
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       /*c-programa     = "ESREP031":U
       c-versao       = "2.04":U
       c-revisao      = "000":U*/ .
       
FORM tt-erro-aux.cd-erro "-"   
     tt-erro-aux.mensagem FORMAT "x(117)"
     WITH WIDTH 132 FRAME f-erros STREAM-IO. 

{utp/ut-liter.i Erro *}
ASSIGN tt-erro-aux.cd-erro:LABEL IN FRAME f-erros = TRIM(RETURN-VALUE).

{utp/ut-liter.i Descriá∆o *}
ASSIGN tt-erro-aux.mensagem:LABEL IN FRAME f-erros = TRIM(RETURN-VALUE)
       c-lb-mensagem                               = TRIM(RETURN-VALUE).   

{utp/ut-liter.i Mensagem *}
ASSIGN c-lb-erro = TRIM(RETURN-VALUE)
       c-espaco  = FILL("-", 10) + "   " + FILL("-", 117).

FORM tt-docum-est-aux.cod-estabel        FORMAT "x(6)"      COLUMN-LABEL "Estab"
     tt-docum-est-aux.serie        AT 10 FORMAT "x(5)"      COLUMN-LABEL "Serie"             
     tt-docum-est-aux.nro-docto    AT 18 FORMAT "x(7)"      COLUMN-LABEL "Documento"    
     tt-docum-est-aux.cod-emitente AT 30 FORMAT ">>>>>>>>9" COLUMN-LABEL "Emitente"        
     tt-docum-est-aux.nat-operacao AT 42 FORMAT "x(12)"     COLUMN-LABEL "Nat Operaá∆o" 
    WITH WIDTH 132 FRAME f-nf STREAM-IO. 

FORM SKIP(1)
     "SELEÄ«O":U  AT 13 SKIP(1)
     tt-param.cod-estabel       FORMAT "x(3)":U       LABEL "Estabelecimento":U  COLON 40 SKIP
     tt-param.serie             FORMAT "x(5)":U       LABEL "Serie":U            COLON 40 SKIP
     tt-param.nro-docto         FORMAT "9999999":U    LABEL "Documento":U        COLON 40 SKIP
     tt-param.nat-retorno       FORMAT "x(6)":U       LABEL "Natureza Retorno":U COLON 40 SKIP
     tt-param.nat-servico       FORMAT "x(6)":U       LABEL "Natureza Serviáo":U COLON 40 SKIP
     tt-param.num-pedido                              LABEL "Pedido":U           COLON 40 SKIP
     i-numer-ordem                                    LABEL "Ordem Compra":U     COLON 40 SKIP
     tt-param.nr-ord-prod       FORMAT ">>>,>>>,>>9"  LABEL "Ordem Produá∆o":U   COLON 40 SKIP
     tt-param.dt-trans          FORMAT "99/99/9999":U LABEL "Data Transaá∆o":U   COLON 40 SKIP
     tt-param.cod-depos-ret     FORMAT "x(3)":U       LABEL "Dep¢sito Retorno":U COLON 40 SKIP
     tt-param.cod-depos-serv    FORMAT "x(3)":U       LABEL "Dep¢sito Serviáo":U COLON 40 SKIP
     tt-param.cod-fornec        FORMAT ">>>>>>>>9":U  LABEL "Fornecedor":U       COLON 40 SKIP
     tt-param.it-codigo         FORMAT "x(16)":U      LABEL "Item":U             COLON 40 SKIP
     tt-param.qtd               FORMAT ">>>>>,>>9.99" LABEL "Quantidade":U       COLON 40 SKIP
     tt-param.cod-modalid-frete FORMAT "x(8)":U       LABEL "Modalidade Frete":U COLON 40 
     SKIP(1)
     "IMPRESS«O":U AT 13 SKIP(1)
     tt-param.arquivo        FORMAT "x(80)":U      LABEL "Destino":U          COLON 40 SKIP
     tt-param.usuario        FORMAT "x(12)":U      LABEL "Usu†rio":U          COLON 40 SKIP(1)
    WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-impressao.

EMPTY TEMP-TABLE tt-docum-est.
EMPTY TEMP-TABLE tt-docum-est-aux.
EMPTY TEMP-TABLE tt-item-doc-est.
EMPTY TEMP-TABLE tt-erro.
EMPTY TEMP-TABLE tt-erro-aux.
EMPTY TEMP-TABLE tt-dupli-apagar.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Gerando_Nota_Retorno *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

DO ON STOP UNDO, LEAVE:
    RUN pi-initialize-hdl.
 
    FIND FIRST estab-mat WHERE
               estab-mat.cod-estabel = tt-param.cod-estabel NO-LOCK NO-ERROR.
    FIND FIRST emitente WHERE
               emitente.cod-emitente = tt-param.cod-fornec NO-LOCK NO-ERROR.
    ASSIGN c-estado-emit = IF AVAIL emitente THEN emitente.estado ELSE "".

    RUN pi-gera-nf-retorno.
    EMPTY TEMP-TABLE tt-docum-est.

    RUN pi-transf-tt-erro.
    RUN pi-gera-nf-serv.

    RUN pi-transf-tt-erro.
    RUN pi-impressao.
END.

RUN pi-destroy-hdl.

PAGE.
DISPLAY tt-param.cod-estabel
        tt-param.serie      
        tt-param.nro-docto  
        tt-param.nat-retorno
        tt-param.nat-servico
        tt-param.num-pedido 
        i-numer-ordem
        tt-param.nr-ord-prod
        tt-param.dt-trans   
        tt-param.cod-depos-ret
        tt-param.cod-depos-serv
        tt-param.cod-fornec 
        tt-param.it-codigo  
        tt-param.qtd
        tt-param.cod-modalid-frete
        tt-param.arquivo 
        tt-param.usuario 
    WITH FRAME f-impressao.

{include/i-rpclo.i}

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.
 
IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp. 


IF l-erro THEN
    RETURN "NOK":U.
ELSE 
    RETURN "OK":U.

PROCEDURE pi-gera-nf-retorno:
    /** Retorno **/
    FIND FIRST natur-oper WHERE
               natur-oper.nat-operacao = tt-param.nat-retorno NO-LOCK NO-ERROR.

    ASSIGN c-conta-transit  = "".    
    RUN defaultContaTransit (OUTPUT c-conta-transit).

    IF AVAIL natur-oper AND
             natur-oper.terceiros THEN DO:       

        CREATE tt-docum-est.
        ASSIGN tt-docum-est.serie-docto    = tt-param.serie               
               tt-docum-est.nro-docto      = STRING(tt-param.nro-docto,"9999999")
               tt-docum-est.cod-emitente   = tt-param.cod-fornec
               tt-docum-est.nat-operacao   = tt-param.nat-retorno
               tt-docum-est.cod-observa    = 1 /* Insdustrial */
               tt-docum-est.cod-estabel    = tt-param.cod-estabel
               tt-docum-est.estab-fisc     = tt-param.cod-estabel
               tt-docum-est.conta-transit  = c-conta-transit
               tt-docum-est.dt-emissao     = tt-param.dt-trans
               tt-docum-est.dt-trans       = tt-param.dt-trans
               tt-docum-est.usuario        = c-seg-usuario
               tt-docum-est.uf             = c-estado-emit
               tt-docum-est.via-transp     = 1
               tt-docum-est.mod-frete      = 1
               tt-docum-est.nff            = NO
               tt-docum-est.dt-venc-ipi    = TODAY
               tt-docum-est.dt-venc-icm    = TODAY
               tt-docum-est.tot-valor      = 0
               tt-docum-est.esp-docto      = 21
               tt-docum-est.observacao     = (IF tt-docum-est.observacao <> "":U AND tt-docum-est.observacao <> ? THEN (tt-docum-est.observacao + CHR(10)) ELSE "":U) + "Ordem Produá∆o: ":U + TRIM(STRING(tt-param.nr-ord-prod)) + CHR(10) + "Matr°cula: ":U + TRIM(STRING(c-seg-usuario)) + CHR(10) NO-ERROR.

        ASSIGN OVERLAY(tt-docum-est.char-2, 143, 8) = tt-param.cod-modalid-frete.

        RUN pi-acompanhar IN h-acomp (INPUT tt-docum-est.nro-docto).
    END.

    ASSIGN tt-docum-est.rec-fisico  = NO
           tt-docum-est.origem      = ""
           tt-docum-est.pais-origem = "RE1001" NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO: 
        ASSIGN i-seq-erro = i-seq-erro + 1.
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = i-seq-erro
               tt-erro.cd-erro  = ERROR-STATUS:GET-NUMBER(1)
               tt-erro.mensagem = ERROR-STATUS:GET-MESSAGE(1) + fnNf(1).

        ASSIGN l-erro = TRUE.

        RETURN "NOK":U.
    END.

    IF NOT CAN-FIND (FIRST tt-erro) THEN DO:
        IF AVAIL natur-oper AND
                 natur-oper.terceiros THEN DO:
 
            RUN validateDados (INPUT 1).
            IF RETURN-VALUE = "OK" THEN DO:
               FIND FIRST ord-prod WHERE
                          ord-prod.nr-ord-prod = tt-param.nr-ord-prod NO-LOCK NO-ERROR.

               RUN executeCreateItembyOrdProd (INPUT tt-param.nr-ord-prod,
                                               INPUT ord-prod.it-codigo,
                                               INPUT tt-param.qtd,
                                               INPUT TODAY,
                                               INPUT tt-param.cod-depos-ret).
                IF RETURN-VALUE = "OK":U THEN DO:
                    RUN executeSelectSaldoTerc.
                    IF RETURN-VALUE = "NOK" THEN
                        ASSIGN l-erro = TRUE.
                END.
                ELSE
                    ASSIGN l-erro = TRUE.
            END.
            ELSE
                ASSIGN l-erro = TRUE.

            RETURN RETURN-VALUE.
        END.
    END.
    ELSE DO:
        ASSIGN l-erro = TRUE.
        RETURN "NOK":U.
    END.

END PROCEDURE.

PROCEDURE pi-gera-nf-serv:
    {utp/ut-liter.i Gerando_Nota_Serviáo *}
    RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

    /** Servico **/
    FIND FIRST natur-oper WHERE
               natur-oper.nat-operacao = tt-param.nat-servico NO-LOCK NO-ERROR.
    FIND FIRST ordem-compra WHERE 
               ordem-compra.num-pedido = tt-param.num-pedido NO-LOCK NO-ERROR.
    FIND FIRST ITEM WHERE
               ITEM.it-codigo = tt-param.it-codigo NO-LOCK NO-ERROR.

    FIND FIRST prazo-compra OF ordem-compra NO-LOCK NO-ERROR.

    ASSIGN c-conta-transit  = ""           
           i-seq-item       = 0
           i-numer-ordem    = ordem-compra.numero-ordem.

    RUN defaultContaTransit (OUTPUT c-conta-transit).

    CREATE tt-docum-est.
    ASSIGN tt-docum-est.serie-docto    = tt-param.serie           
           tt-docum-est.nro-docto      = STRING(tt-param.nro-docto,"9999999")
           tt-docum-est.cod-emitente   = tt-param.cod-fornec
           tt-docum-est.nat-operacao   = tt-param.nat-servico
           tt-docum-est.cod-observa    = 1 /* Industrial */
           tt-docum-est.cod-estabel    = tt-param.cod-estabel
           tt-docum-est.estab-fisc     = tt-param.cod-estabel
           tt-docum-est.conta-transit  = c-conta-transit
           tt-docum-est.dt-emissao     = tt-param.dt-trans
           tt-docum-est.dt-trans       = tt-param.dt-trans
           tt-docum-est.usuario        = c-seg-usuario
           tt-docum-est.uf             = c-estado-emit
           tt-docum-est.via-transp     = 1
           tt-docum-est.mod-frete      = 1
           tt-docum-est.nff            = NO
           tt-docum-est.dt-venc-ipi    = TODAY
           tt-docum-est.dt-venc-icm    = TODAY
         /*tt-docum-est.tot-valor      = ordem-compra.preco-orig * ordem-compra.qt-solic
           tt-docum-est.tot-peso       = ordem-compra.qt-solic * ITEM.peso-liquido
           tt-docum-est.valor-mercad   = ordem-compra.preco-orig * ordem-compra.qt-solic ** Produto Padr∆o ir† calcular os totais. **/
           tt-docum-est.esp-docto      = 21
           tt-docum-est.observacao     = (IF tt-docum-est.observacao <> "":U AND tt-docum-est.observacao <> ? THEN (tt-docum-est.observacao + CHR(10)) ELSE "":U) + "Ordem Produá∆o: ":U + TRIM(STRING(tt-param.nr-ord-prod)) + CHR(10) + "Matr°cula: ":U + TRIM(STRING(c-seg-usuario)) + CHR(10) NO-ERROR.

    ASSIGN OVERLAY(tt-docum-est.char-2, 143, 8) = tt-param.cod-modalid-frete.

    RUN pi-acompanhar IN h-acomp (INPUT tt-docum-est.nro-docto).

    ASSIGN tt-docum-est.rec-fisico  = NO
           /*tt-docum-est.origem      = "I" */
           tt-docum-est.pais-origem = "RE1001".

    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = i-seq-erro
               tt-erro.cd-erro  = ERROR-STATUS:GET-NUMBER(1)
               tt-erro.mensagem = ERROR-STATUS:GET-MESSAGE(1) + fnNf(2).

        ASSIGN l-erro = TRUE.

        RETURN "NOK":U.
    END.

    IF NOT CAN-FIND (FIRST tt-erro) THEN DO:
        RUN validateDados (INPUT 2).
        IF RETURN-VALUE = "OK" THEN DO:
            FIND FIRST param-re WHERE param-re.usuario = tt-docum-est.usuario NO-LOCK NO-ERROR.
            IF AVAIL param-re THEN
                ASSIGN i-seq-item = param-re.seq-item-um.
            ELSE
                ASSIGN i-seq-item = 5.

            CREATE tt-item-doc-est.
            ASSIGN tt-item-doc-est.it-codigo      = tt-param.it-codigo
                   tt-item-doc-est.cod-refer      = ""
                   tt-item-doc-est.num-pedido     = ordem-compra.num-pedido
                   tt-item-doc-est.numero-ordem   = ordem-compra.numero-ordem
                   tt-item-doc-est.parcela        = 1
                   tt-item-doc-est.encerra-pa     = NO
                   tt-item-doc-est.nr-ord-prod    = 0
                   tt-item-doc-est.cod-roteiro    = ""
                   tt-item-doc-est.op-codigo      = 0
                   tt-item-doc-est.item-pai       = ""
                   tt-item-doc-est.conta-contabil = ""
                   tt-item-doc-est.baixa-ce       = YES
                   tt-item-doc-est.etiquetas      = 0
                   tt-item-doc-est.qt-do-forn     = prazo-compra.qtd-do-forn
                   tt-item-doc-est.quantidade     = ordem-compra.qt-solic
                   tt-item-doc-est.preco-total[1] = ordem-compra.pre-unit-for * tt-item-doc-est.quantidade
                   tt-item-doc-est.preco-unit[1]  = ordem-compra.pre-unit-for
                   tt-item-doc-est.desconto       = 0                   
                   tt-item-doc-est.despesas       = 0
                   tt-item-doc-est.peso-liquido   = ITEM.peso-liquido * tt-item-doc-est.quantidade
                   tt-item-doc-est.cod-depos      = tt-param.cod-depos-serv
                   tt-item-doc-est.cod-localiz    = ""
                   tt-item-doc-est.lote           = ""
                   tt-item-doc-est.dt-vali-lote   = ?
                   tt-item-doc-est.class-fiscal   = IF AVAIL ITEM THEN ITEM.class-fisc ELSE ""
                   tt-item-doc-est.aliquota-ipi   = 0
                   tt-item-doc-est.cd-trib-ipi    = 0
                   tt-item-doc-est.base-ipi       = 0
                   tt-item-doc-est.valor-ipi      = 0
                   tt-item-doc-est.aliquota-iss   = 0
                   tt-item-doc-est.cd-trib-iss    = 1 /* default e aliquota iss Ç 0 */
                   tt-item-doc-est.base-iss       = 0
                   tt-item-doc-est.valor-iss      = 0
                   tt-item-doc-est.aliquota-icm   = 0
                   tt-item-doc-est.cd-trib-icm    = 0
                   tt-item-doc-est.base-icm       = 0
                   tt-item-doc-est.valor-icm      = 0
                   tt-item-doc-est.base-subs      = 0                   
                   tt-item-doc-est.icm-complem    = 0
                   tt-item-doc-est.narrativa      = ""
                   tt-item-doc-est.icm-outras     = 0
                   tt-item-doc-est.ipi-outras     = 0
                   tt-item-doc-est.iss-outras     = 0
                   tt-item-doc-est.icm-ntrib      = 0
                   tt-item-doc-est.ipi-ntrib      = 0
                   tt-item-doc-est.iss-ntrib      = 0
            NO-ERROR.

            ASSIGN tt-item-doc-est.serie-docto  = tt-param.serie
                   tt-item-doc-est.nro-docto    = STRING(tt-param.nro-docto,"9999999")
                   tt-item-doc-est.cod-emitente = tt-param.cod-fornec
                   tt-item-doc-est.nat-operacao = tt-param.nat-servico
                   tt-item-doc-est.sequencia    = i-seq-item.

            IF ERROR-STATUS:ERROR THEN DO: 
                ASSIGN i-seq-erro = i-seq-erro + 1.
                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = i-seq-erro
                       tt-erro.cd-erro  = ERROR-STATUS:GET-NUMBER(1)
                       tt-erro.mensagem = ERROR-STATUS:GET-MESSAGE(1) + fnNf(2).

                ASSIGN l-erro = TRUE.

                RETURN "NOK":U.
            END.

            IF NOT CAN-FIND(tt-erro) THEN DO:
                RUN emptyRowErrors IN h-boin176.
                RUN setRecord      IN h-boin176 (INPUT TABLE tt-item-doc-est).
                RUN createRecord   IN h-boin176.
 
                IF RETURN-VALUE = "NOK":U THEN DO:
                    RUN getRowErrors IN h-boin176 (OUTPUT TABLE RowErrors).
                    IF CAN-FIND(FIRST RowErrors) THEN DO:
                        FOR EACH RowErrors:
                            ASSIGN i-seq-erro = i-seq-erro + 1.
                            CREATE tt-erro.
                            ASSIGN tt-erro.i-sequen = i-seq-erro
                                   tt-erro.cd-erro  = RowErrors.errorNumber
                                   tt-erro.mensagem = RowErrors.errorDescription + " *Criaá∆o Item " + fnNf(2).
                        END.

                        ASSIGN l-erro = TRUE.

                        RETURN "NOK":U.
                    END.
                END.

                IF VALID-HANDLE(h-boin176) THEN
                    RUN TransferTotalItensNota IN h-boin176 (INPUT tt-item-doc-est.cod-emitente,
                                                             INPUT tt-item-doc-est.serie-docto,
                                                             INPUT tt-item-doc-est.nro-docto,
                                                             INPUT tt-item-doc-est.nat-operacao).

                IF VALID-HANDLE(h-boin092) THEN DO:
                    RUN setRowidDocumEst IN h-boin092 (r-rowid-docum).
                    RUN setConstraintOfDocumEst IN h-boin092 (INPUT tt-item-doc-est.cod-emitente,
                                                              INPUT tt-item-doc-est.serie-docto,
                                                              INPUT tt-item-doc-est.nro-docto,
                                                              INPUT tt-item-doc-est.nat-operacao).

                    RUN openQueryStatic  IN h-boin092 (INPUT "ofDocumEst") NO-ERROR.
                    RUN newRecord        IN h-boin092.
                    RUN getRecord        IN h-boin092 (OUTPUT TABLE tt-dupli-apagar).

                    FIND FIRST tt-dupli-apagar NO-LOCK NO-ERROR.
                    IF AVAIL tt-dupli-apagar THEN
                        ASSIGN tt-dupli-apagar.dt-vencim = fnData().

                    RUN emptyRowErrors   IN h-boin092.
                    RUN setRecord        IN h-boin092 (INPUT TABLE tt-dupli-apagar).
                    RUN createRecord     IN h-boin092.

                    IF RETURN-VALUE = "NOK":U THEN DO:

                        ASSIGN l-erro = TRUE.

                        RUN getRowErrors IN h-boin092 (OUTPUT TABLE RowErrors).
                        IF CAN-FIND(FIRST RowErrors) THEN DO:
                            FOR EACH RowErrors:
                                ASSIGN i-seq-erro = i-seq-erro + 1.
                                CREATE tt-erro.
                                ASSIGN tt-erro.i-sequen = i-seq-erro
                                       tt-erro.cd-erro  = RowErrors.errorNumber
                                       tt-erro.mensagem = RowErrors.errorDescription + " *Geraá∆o Duplicata " + fnNf(2).
                            END.
                            RETURN "NOK":U.
                        END.
                    END.
                END.
            END.
        END.
        ELSE 
            ASSIGN l-erro = TRUE.
    END.
    ELSE
        RETURN "NOK":U.
END PROCEDURE.

PROCEDURE pi-impressao:
    IF CAN-FIND (FIRST tt-docum-est-aux) THEN DO:
        ASSIGN l-cabec = YES.
        {utp/ut-liter.i Listando_Documento *}
        RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE ).

        FOR EACH tt-docum-est-aux NO-LOCK:
            IF  l-cabec THEN DO:
                {utp/ut-liter.i NOTAS_GERADAS * R}
                DISP RETURN-VALUE                         AT 25 FORMAT "x(40)" 
                     FILL('-',LENGTH(TRIM(RETURN-VALUE))) AT 25 FORMAT "x(40)" 
                     WITH FRAME f-2 WIDTH 80 STREAM-IO.
                l-cabec = FALSE.
            END.

            DISP tt-docum-est-aux.cod-estabel
                 tt-docum-est-aux.serie
                 tt-docum-est-aux.nro-docto
                 tt-docum-est-aux.cod-emitente
                 tt-docum-est-aux.nat-operacao
                WITH DOWN FRAME f-nf.
            DOWN WITH FRAME f-nf.
            RUN pi-acompanhar IN h-acomp (INPUT tt-docum-est-aux.nro-docto).
        END.
    END.

    IF  CAN-FIND (FIRST tt-erro-aux
                  WHERE tt-erro-aux.cd-erro = 18796
                     OR tt-erro-aux.cd-erro = 18799
                     /*OR tt-erro-aux.cd-erro = 27905*/ ) THEN DO:

        {utp/ut-liter.i NOTAS_COM_ADVERT“NCIA * R}

        DISP RETURN-VALUE                         AT 25 FORMAT "x(40)" 
             FILL('-',LENGTH(TRIM(RETURN-VALUE))) AT 25 FORMAT "x(40)"
            WITH FRAME f-1 WIDTH 132 STREAM-IO.

        {utp/ut-liter.i Listando_Advertàncias *}
        RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE ).

        FOR EACH tt-erro-aux NO-LOCK
           WHERE tt-erro-aux.cd-erro = 18796
              OR tt-erro-aux.cd-erro = 18799
              /*OR tt-erro-aux.cd-erro = 27905*/
           BREAK BY tt-erro-aux.i-sequen:

            IF  FIRST-OF(tt-erro-aux.i-sequen)
                AND tt-erro-aux.i-sequen > 0 THEN DO:
                PUT SKIP(1)
                    c-lb-erro     TO 10 
                    c-lb-mensagem AT 14 SKIP
                    c-espaco            SKIP.
            END.
            PUT tt-erro-aux.cd-erro
                " - "
                tt-erro-aux.mensagem SKIP.
        END.
    END.

    IF CAN-FIND (FIRST tt-erro-aux
                 WHERE tt-erro-aux.cd-erro <> 18796
                   AND tt-erro-aux.cd-erro <> 18799
                   /*AND tt-erro-aux.cd-erro <> 27905*/ ) THEN DO:

        {utp/ut-liter.i NOTAS_REJEITADAS * R}
        DISP RETURN-VALUE                         AT 25 FORMAT "x(40)"
             FILL('-',LENGTH(TRIM(RETURN-VALUE))) AT 25 FORMAT "x(40)"
            WITH FRAME f-1 WIDTH 132 STREAM-IO.

        {utp/ut-liter.i Listando_Erros *}
        RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE ).

        FOR EACH tt-erro-aux NO-LOCK
            WHERE tt-erro-aux.cd-erro <> 18796
              AND tt-erro-aux.cd-erro <> 18799
              /*AND tt-erro-aux.cd-erro <> 27905*/
            BREAK BY tt-erro-aux.i-sequen:

            DISP tt-erro-aux.cd-erro
                 tt-erro-aux.mensagem
                WITH WIDTH 132 DOWN FRAME f-erros.
            DOWN WITH FRAME f-erros.
        END.
    END.
END PROCEDURE.

PROCEDURE validateDados:
    DEFINE INPUT PARAM p-tipo AS INTEGER NO-UNDO.
    /** p-tipo = 1 - Retorno
                 2 - Servico **/

    FIND FIRST tt-docum-est NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-docum-est THEN RETURN "nok":U.
 
    FIND FIRST docum-est WHERE
               docum-est.cod-emitente = tt-docum-est.cod-emitente AND
               docum-est.serie-docto  = tt-docum-est.serie-docto  AND
               docum-est.nro-docto    = tt-docum-est.nro-docto    AND
               docum-est.nat-operacao = tt-docum-est.nat-operacao NO-LOCK NO-ERROR.
    IF AVAIL docum-est
         AND docum-est.ce-atual THEN DO:
         ASSIGN i-seq-erro = i-seq-erro + 1.
         CREATE tt-erro.
         ASSIGN tt-erro.i-sequen = i-seq-erro
                tt-erro.cd-erro  = 1
                tt-erro.mensagem = "Ja existe esta nota atualizada no sistema. Documento: " + tt-docum-est.nro-docto + fnNf(p-tipo).
         RETURN "NOK":U.
    END.

    IF NOT AVAIL docum-est THEN DO:
        RUN emptyRowErrors IN h-boin090.
        RUN setRecord      IN h-boin090 (INPUT TABLE tt-docum-est).
        RUN createRecord   IN h-boin090.
 
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN h-boin090 (OUTPUT TABLE RowErrors).
            IF  CAN-FIND(FIRST RowErrors) THEN DO:
                FOR EACH RowErrors:
                    ASSIGN i-seq-erro = i-seq-erro + 1.
                    CREATE tt-erro.
                    ASSIGN tt-erro.i-sequen = i-seq-erro
                           tt-erro.cd-erro  = RowErrors.errorNumber
                           tt-erro.mensagem = RowErrors.errorDescription + fnNf(p-tipo).
                END.
                RUN emptyRowErrors IN h-boin090.
                RETURN "NOK":U.
            END.
        END.
        ELSE DO:
            CREATE tt-docum-est-aux.
            BUFFER-COPY tt-docum-est TO tt-docum-est-aux.

            /*Notas do presidio n∆o necessitam conferància, gera com nota-completa marcado*/
            FIND FIRST int-docum-est EXCLUSIVE-LOCK
                 WHERE int-docum-est.serie-docto  = tt-docum-est.serie-docto
                   AND int-docum-est.nro-docto    = tt-docum-est.nro-docto
                   AND int-docum-est.cod-emitente = tt-docum-est.cod-emitente
                   AND int-docum-est.nat-operacao = tt-docum-est.nat-operacao  NO-ERROR.
            
            IF NOT AVAIL int-docum-est THEN DO:
                CREATE int-docum-est.
                ASSIGN int-docum-est.serie-docto  = tt-docum-est.serie-docto 
                       int-docum-est.nro-docto    = tt-docum-est.nro-docto   
                       int-docum-est.cod-emitente = tt-docum-est.cod-emitente
                       int-docum-est.nat-operacao = tt-docum-est.nat-operacao.
            END.
            
            ASSIGN int-docum-est.nota-completa = YES.
            
            RELEASE int-docum-est.
        END.
    END.

    IF NOT CAN-FIND (FIRST RowErrors) THEN DO:
        RUN getRowid IN h-boin090 (OUTPUT r-rowid-docum).
        /*--- reposiciona a BO de docum-est ---*/
        RUN repositionRecord IN h-boin090 (INPUT r-rowid-docum).        
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE defaultContaTransit:
    DEF OUTPUT PARAM pi-conta-transit LIKE docum-est.conta-transit NO-UNDO.

    IF  NOT AVAIL natur-oper 
    OR  NOT AVAIL estab-mat THEN 
        RETURN "NOK":U.

    IF  natur-oper.transf THEN 
        ASSIGN pi-conta-transit = estab-mat.cod-cta-transf-unif + estab-mat.cod-ccusto-transf-unif.
    ELSE 
    IF  natur-oper.terceiros
    AND natur-oper.tp-oper-terc <> 4 THEN DO:       /* N∆o considera Faturamento Consignaá∆o */
        IF  natur-oper.tp-oper-terc = 1 THEN                                        /* Entrada Benef */
            ASSIGN pi-conta-transit  = estab-mat.cod-cta-e-benef-unif + estab-mat.cod-ccusto-e-benef-unif.   
        ELSE IF natur-oper.tp-oper-terc = 2 THEN                                    /* Retorno Benef */
            ASSIGN pi-conta-transit  = estab-mat.cod-cta-saida-benef-unif + estab-mat.cod-ccusto-saida-benef-unif.
        ELSE IF natur-oper.tp-oper-terc = 5 THEN                                    /* Devol Consig */
            ASSIGN pi-conta-transit  = estab-mat.cod-cta-saida-consig-unif + estab-mat.cod-ccusto-saida-consig-unif.
        ELSE 
            ASSIGN pi-conta-transit  = estab-mat.cod-cta-e-consig-unif + estab-mat.cod-ccusto-e-consig-unif.                 /* Compra Consig */
    END.
    ELSE 
    /*IF  tt-param.cod-observa = 3 THEN  /* devolucao */
        ASSIGN pi-conta-transit  = estab-mat.conta-dev-cli.
    ELSE*/ 
    IF  natur-oper.tipo-compra = 2 THEN /* Nota de frete */
    DO:
        ASSIGN pi-conta-transit  = estab-mat.cod-cta-frete-unif + estab-mat.cod-ccusto-frete-unif.
    END.
    ELSE
        ASSIGN pi-conta-transit  = estab-mat.cod-cta-fornec-unif + estab-mat.cod-ccusto-fornec-unif.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE executeCreateItembyOrdProd:
    DEF INPUT PARAM piNrOrdProd         LIKE item-doc-est.nr-ord-prod  NO-UNDO.
    DEF INPUT PARAM piItemPai           LIKE item-doc-est.it-codigo    NO-UNDO.
    DEF INPUT PARAM piQuantidade        LIKE item-doc-est.quantidade   NO-UNDO.
    DEF INPUT PARAM piDtRetorno         AS DATE                        NO-UNDO.
    DEF INPUT PARAM piCodDepos          LIKE item-doc-est.cod-depos    NO-UNDO.

    /* Envia conteudo da temp-table para BO */     
    RUN setTTItemEstrut IN h-boin404re (INPUT TABLE tt-it-terc).

    /* limpa a temp-table de erros */
    RUN emptyRowErrors IN h-boin404re.

    /* Validata e cria a temp-table dos itens terceiros */
    RUN createItemEstrutbyOrdProd IN h-boin404re (piNrOrdProd,
                                                  piItemPai,
                                                  piQuantidade,
                                                  piDtRetorno,
                                                  piCodDepos).

    IF  RETURN-VALUE = "NOK":U THEN DO:
        RUN getRowErrors IN h-boin404re (OUTPUT TABLE RowErrors).
        IF  CAN-FIND(FIRST RowErrors) THEN DO:
            FOR EACH RowErrors:
                ASSIGN i-seq-erro = i-seq-erro + 1.
                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = i-seq-erro
                       tt-erro.cd-erro  = RowErrors.errorNumber
                       tt-erro.mensagem = RowErrors.errorDescription + "*Criaá∆o Item " + fnNf(1).
            END.
            RETURN "NOK":U.
        END.
    END.
 
    /* Retorna conteudo da temp-table para tela */     
    RUN getTTItemEstrut IN h-boin404re (OUTPUT TABLE tt-it-terc).
 
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE executeSelectSaldoTerc:
    IF NOT CAN-FIND(FIRST tt-it-terc) THEN
        RETURN "NOK":U.

    /* Envia conteudo da temp-table para BO */     
    RUN setTTItemEstrut IN h-boin404re (INPUT TABLE tt-it-terc).

    /* Elimina Temp-Table de Erros */
    RUN emptyRowErrors IN h-boin404re.

    /* Faz fifo no saldo-terc e cria itens da nota de retorno */
    RUN selectSaldoTercbyFIFO IN h-boin404re (h-boin090,
                                              h-boin176,
                                              tt-docum-est.cod-emitente,
                                              tt-docum-est.cod-estabel,
                                              tt-docum-est.nat-operacao,
                                              1, /* Tipo de operacao - Rec. Fisico */ 
                                              tt-docum-est.dt-trans).

    RUN getRowErrors IN h-boin404re (OUTPUT TABLE RowErrors).
    IF  CAN-FIND(FIRST RowErrors) THEN DO:
        FOR EACH RowErrors:
            ASSIGN i-seq-erro = i-seq-erro + 1.
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = i-seq-erro
                   tt-erro.cd-erro  = RowErrors.errorNumber
                   tt-erro.mensagem = RowErrors.errorDescription + fnNf(1).
        END.
    END.
    RUN emptyRowErrors IN h-boin404re.

    IF CAN-FIND (FIRST RowErrors WHERE
                       RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

FUNCTION fnNf RETURN CHAR (p-tipo AS INTEGER).
    IF p-tipo = 1 THEN
        RETURN " (Nota Fiscal de Retorno)".
    ELSE
        RETURN " (Nota Fiscal de Serviáo)".
END FUNCTION.

FUNCTION fnData RETURN DATE ().
    DEFINE VARIABLE i-mes AS INTEGER FORMAT "99"   NO-UNDO.
    DEFINE VARIABLE i-ano AS INTEGER FORMAT "9999" NO-UNDO.

    IF MONTH(TODAY) = 12 THEN
        ASSIGN i-mes = 1 
               i-ano = YEAR(TODAY) + 1.
    ELSE
        ASSIGN i-mes = MONTH(TODAY) + 1
               i-ano = YEAR(TODAY).

    RETURN DATE("07/" + STRING(i-mes,"99") + "/":U + STRING(i-ano,"9999")).
END FUNCTION.

PROCEDURE pi-transf-tt-erro:
    IF CAN-FIND(FIRST tt-erro) THEN DO:
        FOR EACH tt-erro:
            ASSIGN i-seq-erro = i-seq-erro + 1.
            CREATE tt-erro-aux.
            BUFFER-COPY tt-erro EXCEPT i-sequen TO tt-erro-aux.
            ASSIGN tt-erro-aux.i-sequen = i-seq-erro.
        END.
        EMPTY TEMP-TABLE tt-erro.
    END.
END PROCEDURE.

PROCEDURE pi-initialize-hdl:
    IF  NOT VALID-HANDLE(h-boin090) THEN
        RUN inbo/boin090.p PERSISTENT SET h-boin090.

    RUN openQueryStatic IN h-boin090 (INPUT "Main":U).

    IF  NOT VALID-HANDLE(h-boin404re) THEN
        RUN inbo/boin404re.p PERSISTENT SET h-boin404re.

    IF  NOT VALID-HANDLE(h-boin176) THEN
        RUN inbo/boin176.p PERSISTENT SET h-boin176.

    RUN openQueryStatic IN h-boin176 (INPUT "Main":U).

    IF  NOT VALID-HANDLE(h-boin092) THEN
        RUN inbo/boin092.p PERSISTENT SET h-boin092.

END PROCEDURE.

PROCEDURE pi-destroy-hdl:
    IF VALID-HANDLE(h-boin090) THEN DO:
        RUN destroy IN h-boin090.
        ASSIGN h-boin090 = ?.
    END.
    IF VALID-HANDLE(h-boin176) THEN DO:
        RUN destroy IN h-boin176.
        ASSIGN h-boin176 = ?.
    END.
    IF VALID-HANDLE(h-boin404re) THEN DO:
        RUN destroy IN h-boin404re.
        ASSIGN h-boin404re = ?.
    END.
    IF VALID-HANDLE(h-boin092) THEN DO:
        RUN destroy IN h-boin092.
        ASSIGN h-boin092 = ?.
    END.
END.

