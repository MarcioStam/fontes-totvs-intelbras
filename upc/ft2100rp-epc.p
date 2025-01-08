/* DEF VAR h-cd9500      AS HANDLE NO-UNDO. */
DEF VAR h-escrm001api AS HANDLE.
DEF VAR r-conta-ft    AS ROWID  NO-UNDO.

{include/i-epc200.i1} 
{utp/utapi019.i}
{esp/es0006a.i}
{esp/es0006.i}  
{esp/es0018.i}
{cdp/cd0666.i}
{esinc/es0000.i}
{esapi/esapi010tt.i} /****** TEMP-TABLE tt-email *****/

DEFINE VAR c-lista-email AS CHAR NO-UNDO.

def new shared var r-nota         as rowid.
DEF BUFFER b-nota-fiscal    FOR nota-fiscal.
DEF BUFFER b-nota-fiscalEnd FOR nota-fiscal.
DEFINE VARIABLE deposEntrePosto AS CHARACTER   NO-UNDO.

DEF VAR i-empresa    like param-global.empresa-prin NO-UNDO.

define stream arq-erro.
DEFINE stream arq-email.
DEFINE VARIABLE h-esft066 AS HANDLE      NO-UNDO.
DEFINE TEMP-TABLE tt-import NO-UNDO
    FIELD cnpj        AS CHAR
    FIELD serie       AS CHAR
    FIELD nr-nota-fis AS CHAR
    FIELD ds-chave    AS CHAR
    FIELD codigo      AS CHAR
    FIELD indefinido1 AS CHAR FORMAT "x(100)"
    FIELD indefinido2 AS CHAR FORMAT "x(100)"
    FIELD indefinido3 AS CHAR FORMAT "x(100)"
    FIELD iLinha      AS INT
    FIELD FullPath    AS CHAR
    FIELD FILENAME    AS CHAR
    INDEX ch_principal cnpj serie nr-nota-fis.
DEFINE TEMP-TABLE tt-docum-est NO-UNDO LIKE docum-est
    FIELD r-Rowid AS ROWID. 
def temp-table tt-item-doc-est no-undo
    field rw-it-nota-fisc   as rowid
    field quant-devol       like item-doc-est.quantidade
    field preco-devol       like item-doc-est.preco-total extent 0
    field cod-depos         like item-doc-est.cod-depos
    field reabre-pd         like item-doc-est.reabre-pd
    field vl-desconto       like item-doc-est.pr-total-cmi.
     
DEFINE TEMP-TABLE tt-conta NO-UNDO
       FIELD sequen-nf      AS INTE
       FIELD conta-contabil LIKE movto-estoq.conta-contabil
       FIELD ct-icms-ft     LIKE movto-estoq.ct-codigo
       FIELD sc-icms-ft     LIKE movto-estoq.sc-codigo
       FIELD ct-ipi-ft      LIKE movto-estoq.ct-codigo
       FIELD sc-ipi-ft      LIKE movto-estoq.sc-codigo
       FIELD ct-cofins-ft   LIKE movto-estoq.ct-codigo
       FIELD sc-cofins-ft   LIKE movto-estoq.sc-codigo
       FIELD ct-pis-ft      LIKE movto-estoq.ct-codigo
       FIELD sc-pis-ft      LIKE movto-estoq.sc-codigo
       FIELD cod-unid-negoc LIKE movto-estoq.cod-unid-negoc
       INDEX chapri         AS PRIMARY UNIQUE sequen-nf.

{method/dbotterr.i}
def new global shared var c-seg-usuario           as char    no-undo.
def input param pIndEvent as char no-undo.
def input-output param table for tt-epc.


def  var  c-ct-cusven    as char no-undo.
DEF VAR l-gera-mail      AS LOGICAL NO-UNDO.
def var h-boin090  as handle.
def var h-boin176  as handle.
def var c-nr-pedido        as char format "x(1000)" no-undo.
def var c-tit-ped          as char format "x(100)" no-undo.
def var c-dados-empresa    as char format "x(300)" no-undo.
def var c-dados-cliente    as char format "x(400)" no-undo.
def var c-imagem           as char format "x(120)" no-undo.    
def var c-titulo           as char  no-undo.
DEF VAR c-email-nobreaks   AS CHAR FORMAT "x(300)" NO-UNDO.

DEFINE VARIABLE c-data AS CHARACTER   NO-UNDO.
DEFINE TEMP-TABLE tt-saldo-terc no-undo
                  field rw-saldo  as rowid
                  field cod-depos as char.
DEFINE VARIABLE l-rejeita-nota AS LOGICAL     NO-UNDO.
DEFINE VARIABLE dt-ini         AS DATE        NO-UNDO.

DEF BUFFER b-natur-oper for natur-oper.
DEF BUFFER b-estabelec FOR estabelec.

CASE pIndEvent:
    WHEN "Point-one" THEN DO:
        
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event     = pIndEvent
            AND   tt-epc.cod-parameter = "nota-fiscal-rowid":

            FOR FIRST nota-fiscal NO-LOCK
                WHERE ROWID(nota-fiscal) = TO-ROWID(tt-epc.val-parameter):

            FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.

            /*91246*/
            IF  nota-fiscal.idi-sit-nf-eletro <> 3 
            AND nota-fiscal.idi-sit-nf-eletro <> 12
            AND nota-fiscal.idi-sit-nf-eletro <> 13
            AND natur-oper.tipo <> 3 THEN DO:      
                PUT UNFORMATTED SKIP "Nota Fiscal n∆o foi atualizada. Seu uso n∆o est† autorizado pela Sefaz. " + nota-fiscal.cod-estabel + "/" + nota-fiscal.serie + "/" + nota-fiscal.nr-nota-fis SKIP.
                ASSIGN tt-epc.val-parameter = "error".
                RETURN "NOK":U.
            END. 
            
            /*Valida conta-ft
            FIND FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

            RUN cdp/cd9500.p PERSISTENT SET h-cd9500.

            FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
                FOR EACH fat-ser-lote OF it-nota-fisc NO-LOCK:
                    FIND FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-ERROR.
    
                    RUN pi-cd9500 IN h-cd9500(INPUT  nota-fiscal.cod-estabel,
                                              INPUT  emitente.cod-gr-cli,
                                              INPUT  ROWID(ITEM),
                                              INPUT  it-nota-fisc.nat-operacao,
                                              INPUT  it-nota-fisc.serie,
                                              INPUT  fat-ser-lote.cod-depos,
                                              INPUT  nota-fiscal.cod-canal-venda,
                                              OUTPUT r-conta-ft).

                    IF NOT AVAIL conta-ft
                    OR ROWID(conta-ft) <> r-conta-ft THEN DO:
                        FIND FIRST conta-ft NO-LOCK
                            WHERE ROWID(conta-ft) = r-conta-ft NO-ERROR.
                    
                        IF NOT AVAIL conta-ft THEN DO:
                        PUT UNFORMATTED SKIP
                            "Parametrizaá∆o no CD0309 inexistente para nota: " 
                            + nota-fiscal.cod-estabel + " / " 
                            + nota-fiscal.serie       + " / "
                            + nota-fiscal.nr-nota-fis SKIP.
                                
                        ASSIGN tt-epc.val-parameter = "error".
                        RETURN "NOK":U.
                        END.
                    END.
                END.
            END.
            */

            /*Comentado conforme chamado 94098*/
            /*IF NOTA-FISCAL.SERIE = "R2" OR
               NOTA-FISCAL.SERIE = "R1" THEN DO:

                PUT skip
                    "Nao Ç possivel atualizar serie R, nota desconsiderada : " 
                    nota-fiscal.cod-estabel      " / "
                    nota-fiscal.serie            " / "
                    nota-fiscal.nr-nota-fis       SKIP.
                 ASSIGN tt-epc.val-parameter = "error".
                 RETURN "NOK":U.
            END.*/
            
            /*Se a condiá∆o de pagamento for 555(BNDES) Ç enviado
                    e-mail para o(a) atendente do pedido*/
            IF nota-fiscal.cod-cond-pag = 555 THEN DO:
               FOR FIRST ped-venda
                   WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli NO-LOCK:
                      FOR FIRST atendente
                         WHERE atendente.cd-oper = integer(ped-venda.tp-pedido) NO-LOCK:
                                  
                           RUN piEnviaEmailAtendente(INPUT atendente.email,
                                                     INPUT "NF Pedido com condiá∆o BNDES",
                                                     INPUT "Caro(a) atendente " + atendente.nm-oper + "." + CHR(13)
                                                         + "Foi gerado Nota Fiscal n£mero: " + nota-fiscal.nr-nota-fis + CHR(13)
                                                         + "Pedido n£mero: " + ped-venda.nr-pedcli + CHR(13)
                                                         + "Condiá∆o de pagamento 555 (BNDES)").
                      END.
               END.
            END.

            /*Se o item 4990750 for faturado envia e-mail 
            para o(a) atendente do pedido****************************************************************************************/
            FIND ped-venda
               WHERE ped-venda.nr-pedcli =  nota-fiscal.nr-pedcli 
                 AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli NO-LOCK NO-ERROR.

            FIND FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

            EMPTY TEMP-TABLE tt-prog-ponto.
            
            RUN esp/es0018p.p (INPUT "FT2100", /* Nome do programa */
                               INPUT 2,        /* Ponto do programa */
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto) NO-ERROR.

            ASSIGN c-email-nobreaks = "".
            FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:

                FIND FIRST ITEM NO-LOCK
                     WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-ERROR.
                
                FIND FIRST atendente NO-LOCK
                     WHERE atendente.cd-oper = integer(ped-venda.tp-pedido) NO-ERROR.

                IF AVAIL atendente THEN DO:
                    IF it-nota-fisc.it-codigo = "4990750" THEN DO:
                         RUN piEnviaEmailAtendente(INPUT atendente.email,
                                                   INPUT "Faturado Licenáa de Softphone",
                                                   INPUT "Caro(a) atendente " + atendente.nm-oper + "." + CHR(13)
                                                       + "Na Nota Fiscal n£mero: " + nota-fiscal.nr-nota-fis
                                                       + " e pedido n£mero: " + ped-venda.nr-pedcli
                                                       + " foi faturado o produto " + it-nota-fisc.it-codigo
                                                       + "(Licenáa para Softphone),"
                                                       + "com a quantidade: "  + string(it-nota-fisc.qt-faturada[1]) + "," + CHR(13)
                                                       + "por gentileza gravar a licenáa para o CNPJ do cliente final.").
                   END.

                   IF CAN-FIND (FIRST tt-prog-ponto
                                WHERE tt-prog-ponto.conteudo = it-nota-fisc.it-codigo) THEN DO:
                        ASSIGN c-email-nobreaks = c-email-nobreaks + ITEM.desc-item + "," + "com a quantidade: "  + string(it-nota-fisc.qt-faturada[1]) + CHR(10).
                   END.
                END.
            END.

            IF  c-email-nobreaks <> "" AND AVAIL atendente THEN DO:
                DEF VAR c-transp AS CHAR FORMAT "x(100)" NO-UNDO.
                FIND transporte NO-LOCK   
                    WHERE transporte.nome-abrev = nota-fiscal.nome-transp NO-ERROR.

                RUN piEnviaEmailAtendente(INPUT atendente.email,
                                          INPUT "Faturamento Baterias e Nobreaks",
                                          INPUT "Caro(a) atendente " + string(atendente.nm-oper) + "." + CHR(13)
                                              + "Na Nota Fiscal n£mero: " + string(nota-fiscal.nr-nota-fis) + (IF  AVAIL transporte THEN " - " + transporte.nome ELSE "")
                                              + " e pedido n£mero: " + string(ped-venda.nr-pedcli)
                                              + ". Foram faturados os produtos: " + chr(10) + c-email-nobreaks + ".").
            END.
           /*********************************************************************************************************************/
            
            IF (nota-fiscal.ind-sit-nota = 1 OR
                nota-fiscal.dt-confirma = ?) THEN DO:

                    assign r-nota = rowid(nota-fiscal).

                    IF nota-fiscal.ind-sit-nota = 2 THEN DO:
                        /*run ftp/ft0503a.p . */
                    END. /* IF nota-fiscal.ind-sit-nota = 2 THEN DO: */
                    ELSE DO:
                        /*run ftp/ft0503a.p . */

                        /* Nota Ç impressa automaticamente ent∆o, atualiza a situaá∆o */
                        /*FIND FIRST ponto-programa
                            where ponto-programa.nome-programa = "esft067"
                              AND ponto-programa.ponto         = 2 NO-LOCK NO-ERROR.
                        IF AVAIL ponto-programa THEN DO:

                            IF CAN-FIND(FIRST conteudo-programa NO-LOCK
                                        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa 
                                          AND conteudo-programa.conteudo     = nota-fiscal.cod-estabel) THEN DO:

                                FIND FIRST fat-comercial
                                    WHERE fat-comercial.cod-estabel = nota-fiscal.cod-estabel
                                      AND fat-comercial.serie       = nota-fiscal.serie      
                                      AND fat-comercial.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
                                IF AVAIL fat-comercial THEN DO:
                                    FIND FIRST b-nota-fiscal
                                         WHERE b-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel                    
                                           AND b-nota-fiscal.serie       = nota-fiscal.serie                         
                                           AND b-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis EXCLUSIVE-LOCK NO-ERROR.
                                    IF AVAIL b-nota-fiscal THEN DO:
                                        ASSIGN b-nota-fiscal.ind-sit-nota = 1.
                                    END. /* IF AVAIL b-nota-fiscal THEN DO: */
                                    FIND CURRENT b-nota-fiscal NO-LOCK NO-ERROR.
                                    RELEASE b-nota-fiscal.

                                END. /* IF AVAIL fat-comercial THEN DO: */

                            END. /* IF NOT CAN-FIND(FIRST conteudo-programa NO-LOCK */
                        END. /* IF AVAIL ponto-programa THEN DO: */*/
                    END.

                    FIND natur-oper
                        WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
                        NO-LOCK NO-ERROR.
                    IF natur-oper.especie-doc = "NFD" AND
                       natur-oper.tipo = 2 THEN
                       RUN pi-envia-email-devolucao.

                    IF CAN-FIND(FIRST rowErrors) THEN DO:
                         ASSIGN tt-epc.val-parameter = "error".
                         RETURN "NOK":U.
                    END.

                    FOR FIRST int-nota-fiscal NO-LOCK
                        WHERE int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel   
                        AND   int-nota-fiscal.serie       = nota-fiscal.serie         
                        AND   int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis:

                         
                        
                        IF nota-fiscal.nr-pedcli = "" THEN DO:
                            FIND FIRST ped-fiscal NO-LOCK
                                WHERE ped-fiscal.nr-pedido        = int(int-nota-fiscal.cod-usuario-solic) NO-ERROR.
                            /* O Campo int-nota-fiscal.cod-usuario-solic est† sendo usado 
                               para gravar o c¢digo do pedido da solicitaá∆o. */
                            IF  AVAIL ped-fiscal /*AND ped-fiscal.cod-estabel <> "104"*/ THEN DO:
                                FIND usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuario = ped-fiscal.usuario-magnus NO-ERROR.
                                IF AVAIL usuar_mestre THEN
                                   RUN piEnviaEmail (INPUT usuar_mestre.cod_e_mail_local, INPUT STRING(ped-fiscal.nr-pedido), input "Emissao Nota Fiscal Extra").

                            END.
                        END.
                    END.

                    FIND estabelec
                         WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel
                         NO-LOCK NO-ERROR.
                    /* TMS find first nota-fiscal-tr exclusive-lock
                        where nota-fiscal-tr.cod-estabel = nota-fiscal.cod-estabel
                        and   nota-fiscal-tr.cd-serie    = nota-fiscal.serie
                        and   nota-fiscal-tr.nr-nf       = int(nota-fiscal.nr-nota-fis)
                        and   nota-fiscal-tr.cgc-rem     = estabelec.cgc no-error.
                    IF AVAIL nota-fiscal-tr THEN
                       ASSIGN nota-fiscal-tr.qt-volumes = int(nota-fiscal.nr-volumes).*/

                   /* FIND natur-oper
                        WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
                        NO-LOCK NO-ERROR.
                    IF AVAIL  natur-oper AND
                       natur-oper.baixa-estoq = NO THEN DO:
                        FIND b-nota-fiscal
                             WHERE rowid(b-nota-fiscal) = rowid(nota-fiscal) EXCLUSIVE-LOCK NO-ERROR.
                        IF AVAIL b-nota-fiscal THEN DO:
                           ASSIGN b-nota-fiscal.dt-saida = b-nota-fiscal.dt-emis-nota.
                        END.

                    END. */

                    IF nota-fiscal.nr-pedcli <> "" THEN DO:
                        FIND FIRST int-ped-venda
                            WHERE int-ped-venda.nr-pedido               = INT(nota-fiscal.nr-pedcli) 
                              AND SUBSTRING(int-ped-venda.char-1, 11,1) = "S" NO-LOCK NO-ERROR.
                        IF AVAIL int-ped-venda THEN
                           FIND b-nota-fiscal
                                WHERE rowid(b-nota-fiscal) = rowid(nota-fiscal) EXCLUSIVE-LOCK NO-ERROR.
                            IF AVAIL b-nota-fiscal THEN DO:
                                ASSIGN b-nota-fiscal.dt-saida = b-nota-fiscal.dt-emis-nota.
                        END.
                           
                    END.

                    
                    /* TMS release nota-fiscal-tr. */
                    FIND emitente
                         WHERE emitente.cod-emitente = nota-fiscal.cod-emitente
                         NO-LOCK NO-ERROR.
                    if avail natur-oper and
                       natur-oper.tipo = 2 and
                       emitente.cod-suframa <> "" THEN DO:       
                       run esp/ftp/esftp042rp.p (input nota-fiscal.cod-estabel,
                                                 input nota-fiscal.serie,
                                                 input nota-fiscal.nr-nota-fis).                               
                     end.

                END.
               
            END.  /* FOR FIRST nota-fiscal NO-LOCK*/
        END. /* FOR FIRST tt-epc */
    END.
    WHEN "end-ft2100" then do:
        find first tt-epc 
             where tt-epc.cod-event     = pindevent 
               and tt-epc.cod-parameter = "l-desfaz" no-error.
       
        IF tt-epc.val-parameter = "no" THEN DO:

            find first tt-epc 
                 where tt-epc.cod-event     = pindevent 
                   and tt-epc.cod-parameter = "nota-fiscal rowid" no-error.
            if  avail tt-epc then do:
                find first nota-fiscal no-lock where
                     rowid(nota-fiscal) = to-rowid(tt-epc.val-parameter) no-error.
                IF not avail nota-fiscal then next.
    
                FIND natur-oper
                     WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR.
               
                Inclui-nota:
                do transaction on stop undo, return "nok" on error undo,return 'nok':
                    find first tt-epc 
                         where tt-epc.cod-event     = pindevent 
                           and tt-epc.cod-parameter = "i-tipo-atual" NO-LOCK NO-ERROR.
    
                   /* IF  INT(tt-epc.val-parameter) = 1 AND
                        natur-oper.transf AND 
                        natur-oper.nat-comp <> "" THEN DO:
                         run upc/ft2100c-upc.p (input        rowid(nota-fiscal),
                                                input        1,
                                                input        nota-fiscal.dt-saida,                                     
                                                input-output l-rejeita-nota).
                         if  l-rejeita-nota then
                             undo, RETURN "NOK".
                    END.  */
                END. 
    
                /* Incidente 1156 - Contabilizaá∆o de notas de devoluáa‰ da ASTEC por unidade de negocio do item/familia */
                FIND int-natur-oper WHERE
                     int-natur-oper.nat-operacao = natur-oper.nat-operacao NO-LOCK NO-ERROR.
    
                FIND FIRST param-global NO-LOCK NO-ERROR.
    
                ASSIGN i-empresa = param-global.empresa-prin.
    
                find estabelec where
                     estabelec.cod-estabel = nota-fiscal.cod-estabel no-lock no-error.
    
                run cdp/cd9970.p (input rowid(estabelec),
                                  output i-empresa).
                FIND ped-fiscal
                     WHERE ped-fiscal.cod-estabel = nota-fiscal.cod-estabel
                       AND ped-fiscal.serie       = nota-fiscal.serie
                       AND ped-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
    
                for each movto-estoq use-index documento
                   where movto-estoq.serie-docto  = nota-fiscal.serie
                     and movto-estoq.nro-docto    = nota-fiscal.nr-nota-fis
                     and movto-estoq.cod-emitente = nota-fiscal.cod-emitente
                     and movto-estoq.nat-operacao = nota-fiscal.nat-operacao exclusive-lock:
    
                    IF movto-estoq.it-codigo <> "" THEN DO:
                        RUN pi-atualiza-movto.
                    END.
                    ELSE DO:
                        FIND FIRST tt-conta
                             WHERE tt-conta.sequen-nf = movto-estoq.sequen-nf NO-ERROR.
                        IF AVAIL tt-conta THEN DO:
                            IF AVAIL int-natur-oper 
                            AND int-natur-oper.contab-unid-neg THEN DO:
                                ASSIGN movto-estoq.cod-unid-negoc = tt-conta.cod-unid-negoc.
                                IF TRIM(movto-estoq.referencia) = "ICMS" THEN
                                    ASSIGN movto-estoq.conta-contabil = tt-conta.conta-contabil
                                           movto-estoq.ct-codigo      = tt-conta.ct-icms-ft
                                           movto-estoq.sc-codigo      = tt-conta.sc-icms-ft.
                                ELSE IF TRIM(movto-estoq.referencia) = "IPI" THEN
                                    ASSIGN movto-estoq.conta-contabil = tt-conta.conta-contabil
                                           movto-estoq.ct-codigo      = tt-conta.ct-ipi-ft
                                           movto-estoq.sc-codigo      = tt-conta.sc-ipi-ft.
                                ELSE IF TRIM(movto-estoq.referencia) = "COFINS" THEN
                                    ASSIGN movto-estoq.conta-contabil = tt-conta.conta-contabil
                                           movto-estoq.ct-codigo      = tt-conta.ct-cofins-ft
                                           movto-estoq.sc-codigo      = tt-conta.sc-cofins-ft.
                                ELSE IF TRIM(movto-estoq.referencia) = "PIS" THEN
                                    ASSIGN movto-estoq.conta-contabil = tt-conta.conta-contabil
                                           movto-estoq.ct-codigo      = tt-conta.ct-pis-ft
                                           movto-estoq.sc-codigo      = tt-conta.sc-pis-ft.
                            END.
                            IF AVAIL ped-fiscal AND
                                 substring(tt-conta.conta-contabil,1,1) = "4" THEN DO: /* somente troca a conta que iniciam com 4 */
                                 ASSIGN movto-estoq.sc-codigo      = ped-fiscal.sc-codigo.
                            END.
                            ELSE DO:
                                FIND FIRST int-unid-neg-natur
                                    WHERE  int-unid-neg-natur.cod-estabel    = nota-fiscal.cod-estabel
                                      AND  int-unid-neg-natur.cod-unid-negoc = movto-estoq.cod-unid-negoc
                                      AND  int-unid-neg-natur.nat-operacao   = nota-fiscal.nat-operacao NO-LOCK NO-ERROR.
                                IF AVAIL int-unid-neg-natur THEN
                                    ASSIGN movto-estoq.sc-codigo      = int-unid-neg-natur.sc-codigo.
    
                            END.
                         END.
                    END. 
                END. /* FOR EACH movto-estoq  */

                /* Controle das notas atualizadas no estoque mas ainda nao integradas com o WMS */
                IF INT(tt-epc.val-parameter) = 1 /* Atualizacao */ 
                    AND NOT CAN-FIND( FIRST integra-mft-wms-notas 
                                      WHERE integra-mft-wms-notas.cod-estabel = nota-fiscal.cod-estabel
                                        and integra-mft-wms-notas.serie       = nota-fiscal.serie      
                                        and integra-mft-wms-notas.nr-nota-fis = nota-fiscal.nr-nota-fis )  THEN DO:

                    FOR EACH fat-ser-lote OF nota-fiscal NO-LOCK,
                        FIRST deposito OF fat-ser-lote 
                            WHERE deposito.log-gera-wms = YES NO-LOCK,
                        FIRST it-nota-fisc NO-LOCK
                              WHERE it-nota-fisc.cod-estabel = fat-ser-lote.cod-estabel
                                AND it-nota-fisc.serie       = fat-ser-lote.serie      
                                AND it-nota-fisc.nr-nota-fis = fat-ser-lote.nr-nota-fis
                                AND it-nota-fisc.nr-seq-fat  = fat-ser-lote.nr-seq-fat 
                                AND it-nota-fisc.it-codigo   = fat-ser-lote.it-codigo
                                AND it-nota-fisc.baixa-estoq:

                        FIND FIRST item-uni-estab NO-LOCK
                             WHERE item-uni-estab.cod-estabel = fat-ser-lote.cod-estabel
                               AND item-uni-estab.it-codigo   = fat-ser-lote.it-codigo
                               AND item-uni-estab.nr-linha = 20 NO-ERROR.

                        IF  AVAIL item-uni-estab THEN
                            NEXT.

                        FIND FIRST int-wms-nf-atualiz NO-LOCK
                            WHERE int-wms-nf-atualiz.cod-estabel = fat-ser-lote.cod-estabel
                              and int-wms-nf-atualiz.serie       = fat-ser-lote.serie      
                              and int-wms-nf-atualiz.nr-nota-fis = fat-ser-lote.nr-nota-fis
                              and int-wms-nf-atualiz.nr-seq-fat  = fat-ser-lote.nr-seq-fat 
                              and int-wms-nf-atualiz.it-codigo   = fat-ser-lote.it-codigo NO-ERROR.

                        IF NOT AVAIL int-wms-nf-atualiz THEN DO:
                            CREATE int-wms-nf-atualiz.
                            ASSIGN int-wms-nf-atualiz.cod-estabel = fat-ser-lote.cod-estabel
                                   int-wms-nf-atualiz.serie       = fat-ser-lote.serie      
                                   int-wms-nf-atualiz.nr-nota-fis = fat-ser-lote.nr-nota-fis
                                   int-wms-nf-atualiz.nr-seq-fat  = fat-ser-lote.nr-seq-fat 
                                   int-wms-nf-atualiz.it-codigo   = fat-ser-lote.it-codigo  
                                   int-wms-nf-atualiz.cod-depos   = fat-ser-lote.cod-depos  
                                   int-wms-nf-atualiz.qt-baixada  = fat-ser-lote.qt-baixada[1]. 
                        END.
                        ELSE
                            ASSIGN int-wms-nf-atualiz.qt-baixada = int-wms-nf-atualiz.qt-baixada + fat-ser-lote.qt-baixada[1].
                    END.
                END.
                
                IF INT(tt-epc.val-parameter) = 2 /* Desatualizacao */ THEN DO: 
                    FOR EACH int-wms-nf-atualiz EXCLUSIVE-LOCK
                        WHERE int-wms-nf-atualiz.cod-estabel = nota-fiscal.cod-estabel
                          and int-wms-nf-atualiz.serie       = nota-fiscal.serie      
                          and int-wms-nf-atualiz.nr-nota-fis = nota-fiscal.nr-nota-fis:

                        DELETE int-wms-nf-atualiz.
                    END.
                END.

                /** INI - Luciano Leonhardt
                *** Verifica se o Dep¢sito Ç Externo...
                *** 
                *** Se for, Transfere saldo-estoq para alocado, com objetivo de garantir que o estabelecimento n∆o fature a quantidade 
                *** antes que o mesmo esteja fisicamente na unidade.
                *** Deposito EPE
                **/
                //Envio
                find estabelec 
                    where estabelec.cod-estabel = nota-fiscal.cod-estabel no-lock no-error.
                if substr(estabelec.char-1,396,1) <> 'S' then next.

                FOR  EACH it-nota-fisc NO-LOCK
                    WHERE it-nota-fisc.cod-estabel  = nota-fiscal.cod-estabel
                      AND it-nota-fisc.serie        = nota-fiscal.serie
                      AND it-nota-fisc.nr-nota-fis  = nota-fiscal.nr-nota-fis:

                    ASSIGN deposEntrePosto = "".
                    
                    //Estabelecimento 105 Ç do entre-posto
                    find first int-estabel-ressuprimento no-lock
                         where int-estabel-ressuprimento.cod-estabel = estabelec.cod-estabel
                           and int-estabel-ressuprimento.nome-abrev  = it-nota-fisc.nome-ab-cli no-error.
                    if not avail int-estabel-ressuprimento then next. 

                    for first int-estabel-origem-ressup 
                        where int-estabel-origem-ressup.cod-estabel-origem = estabelec.cod-estabel :
                        assign deposEntrePosto = int-estabel-origem-ressup.cod-depos-ressup.
                    end.

                    //Deposito do Entreposto Ç Externo?
                    IF CAN-FIND(FIRST deposito NO-LOCK
                                WHERE deposito.cod-depos    =  deposEntrePosto
                                  AND deposito.ind-tipo-dep = 2)  //Deposito Externo)
                    THEN DO:
                        FOR FIRST saldo-estoq NO-LOCK 
                            WHERE saldo-estoq.cod-depos     = deposEntrePosto
                              AND saldo-estoq.cod-estabel   = it-nota-fisc.cod-estabel
                              AND saldo-estoq.cod-localiz   = it-nota-fisc.cod-localiz
                              AND saldo-estoq.it-codigo     = it-nota-fisc.it-codigo
                              AND saldo-estoq.cod-refer     = it-nota-fisc.cod-refer:
                    
                            IF INT(tt-epc.val-parameter) = 1 /* Atualizacao */
                            THEN DO:

                                IF NOT CAN-FIND(FIRST int-it-nota-fisc-alocado NO-LOCK
                                                WHERE int-it-nota-fisc-alocado.cod-estabel  = it-nota-fisc.cod-estabel
                                                  AND int-it-nota-fisc-alocado.serie        = it-nota-fisc.serie      
                                                  AND int-it-nota-fisc-alocado.nr-nota-fis  = it-nota-fisc.nr-nota-fis
                                                  AND int-it-nota-fisc-alocado.nr-seq-fat   = it-nota-fisc.nr-seq-fat 
                                                  AND int-it-nota-fisc-alocado.it-codigo    = it-nota-fisc.it-codigo  
                                                  AND int-it-nota-fisc-alocado.cod-depos    = saldo-estoq.cod-depos)
                                THEN DO:
                                    CREATE  int-it-nota-fisc-alocado.
                                    ASSIGN  int-it-nota-fisc-alocado.cod-estabel    = it-nota-fisc.cod-estabel
                                            int-it-nota-fisc-alocado.serie          = it-nota-fisc.serie      
                                            int-it-nota-fisc-alocado.nr-nota-fis    = it-nota-fisc.nr-nota-fis
                                            int-it-nota-fisc-alocado.nr-seq-fat     = it-nota-fisc.nr-seq-fat 
                                            int-it-nota-fisc-alocado.it-codigo      = it-nota-fisc.it-codigo
                                            int-it-nota-fisc-alocado.cod-depos      = saldo-estoq.cod-depos
                                            int-it-nota-fisc-alocado.cod-localiz    = saldo-estoq.cod-localiz
                                            int-it-nota-fisc-alocado.cod-refer      = saldo-estoq.cod-refer
                                            int-it-nota-fisc-alocado.qt-faturada    = it-nota-fisc.qt-faturada[1]
                                            int-it-nota-fisc-alocado.log-recebida   = NO
                                            int-it-nota-fisc-alocado.data-recebida  = ?
                                            int-it-nota-fisc-alocado.qt-recebida    = 0 .
                                END.
                            END.
                            ELSE DO:
                                /* Desatualizacao */
                                FOR  FIRST int-it-nota-fisc-alocado EXCLUSIVE-LOCK
                                     WHERE int-it-nota-fisc-alocado.cod-estabel  = it-nota-fisc.cod-estabel
                                       AND int-it-nota-fisc-alocado.serie        = it-nota-fisc.serie      
                                       AND int-it-nota-fisc-alocado.nr-nota-fis  = it-nota-fisc.nr-nota-fis
                                       AND int-it-nota-fisc-alocado.nr-seq-fat   = it-nota-fisc.nr-seq-fat 
                                       AND int-it-nota-fisc-alocado.it-codigo    = it-nota-fisc.it-codigo  
                                       AND int-it-nota-fisc-alocado.cod-depos    = saldo-estoq.cod-depos:

                                       DELETE int-it-nota-fisc-alocado.

                                END.
                            END.
                        END.
                    END.
                END.
                /** FIM - Luciano Leonhardt **/
            END. /* avail tt-epc nota-fiscal */
        END. /* tt-epc.val-parameter = "no" */ 
    END. /* WHEN "end-ft2100" then do: */
    WHEN "alter-tt-param" then do:
        /* Incidente 49404 */
        ASSIGN dt-ini = DATE('01/' + string(MONTH(TODAY)) + '/' + string(YEAR(TODAY))).

        FOR EACH nota-fiscal NO-LOCK  
            WHERE nota-fiscal.dt-emis-nota >= dt-ini
              AND nota-fiscal.dt-emis-nota <= TODAY,
            EACH it-nota-fisc OF nota-fiscal NO-LOCK
            WHERE it-nota-fisc.baixa-estoq = YES:

            IF nota-fiscal.dt-confirma = ? THEN NEXT.

            IF NOT CAN-FIND(FIRST movto-estoq
                            WHERE movto-estoq.cod-estabel  = nota-fiscal.cod-estabel
                              AND movto-estoq.it-codigo    = it-nota-fisc.it-codigo
                              AND movto-estoq.nro-docto    = nota-fiscal.nr-nota-fis
                              AND movto-estoq.serie-docto  = nota-fiscal.serie 
                              AND movto-estoq.cod-emitente = nota-fiscal.cod-emitente) THEN DO:

                FIND FIRST b-nota-fiscalEnd
                    WHERE rowid(b-nota-fiscalEnd) = rowid(nota-fiscal) EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL b-nota-fiscalEnd THEN DO:
                    ASSIGN b-nota-fiscalEnd.dt-confirma = ?.
                END.

                FIND CURRENT b-nota-fiscalEnd NO-LOCK NO-ERROR.
                RELEASE b-nota-fiscalEnd.

            END. /* IF NOT CAN-FIND(FIRST movto-estoq */

        END. /* FOR EACH nota-fiscal NO-LOCK */
    END. /* WHEN "end_ft2100rp" then do: */

   
END CASE.

RETURN "ok".

/* Rotinas Especificas */
PROCEDURE piEnviaEmail:
    DEFINE INPUT PARAM cDestinatarioEmail AS CHAR NO-UNDO.
    DEFINE INPUT PARAM c-nr-pedido        AS CHARACTER.
    DEFINE INPUT PARAM c-assunto          AS CHARACTER.
    
    DEFINE VARIABLE cMensagem            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE vArqMail             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lErro       AS LOGICAL      NO-UNDO INITIAL NO.

    IF cDestinatarioEmail = '' THEN return.

    FOR EACH tt-mail.
        DELETE tt-mail.
    END.

    ASSIGN cMensagem = "Confirmaá∆o de Emiss∆o de Nota Fiscal" + CHR(10) + CHR(10) + 
                       "Foi emitida a nota fiscal de n£mero " + STRING(nota-fiscal.nr-nota-fis) + 
                       ", referente ao pedido n£mero " + c-nr-pedido  + 
                       ". A mesma estar† dispon°vel na expediá∆o aguardando material para embarque ou retira. Mais informaá‰es, Ramais: 9612 e 9752." + CHR(10) + CHR(10) + 
                       "Setor Fiscal" + CHR(10) + CHR(10) .

    ASSIGN c-nr-pedido = "".
    for each it-nota-fisc of nota-fiscal,
        first item fields(it-codigo desc-item) no-lock 
        where item.it-codigo = it-nota-fisc.it-codigo:
        IF  c-nr-pedido = "" THEN
            ASSIGN c-nr-pedido = "99" 
                   cMensagem   = cMensagem + 
                                 "Item    Descricao                                       Qt" + CHR(10) +
                                 "------- ------------------------------------ -------------" + CHR(10).
        ASSIGN cMensagem = cMensagem +
                           string(it-nota-fisc.it-codigo,"x(07)")  + ' ' +
                           string(item.desc-item,"X(36)")          + ' ' +
                           string(it-nota-fisc.qt-faturada[1],">>>>,>>9.9999") + CHR(10).
    end.
    ASSIGN vArqMail = SESSION:TEMP-DIRECTORY + "EnvMailNF.txt".
    OUTPUT STREAM arq-email TO VALUE(vArqMail).
    PUT STREAM arq-email cMensagem FORMAT 'x(2000)'.
    OUTPUT STREAM arq-email CLOSE.
    CREATE tt-mail.
    ASSIGN tt-mail.Destinatario  = cDestinatarioEmail
           tt-mail.Assunto       = c-Assunto
           tt-mail.Mensagem      = cMensagem
           tt-mail.Arquivo       = vArqMail.
        /*CHR(10) + CHR(10) + */

    FOR FIRST usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = c-seg-usuario:
        ASSIGN tt-mail.Remetente = usuar_mestre.cod_e_mail_local.
    END.
    IF tt-mail.Remetente = "" THEN
        ASSIGN tt-mail.Remetente = "ems@intelbras.com.br".

    RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                          OUTPUT TABLE tt-erro).
    
    /*Conforme alinhado com a C†tia, para n∆o dar erro em unix.*/
    IF  OPSYS <> "UNIX":U THEN DO:
        FOR EACH tt-erro:
            MESSAGE tt-erro.mensagem
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
    END.

    FOR EACH tt-mail:
        DELETE tt-mail.
    END.

END PROCEDURE.


PROCEDURE pi-envia-email-devolucao:
    DEFINE VARIABLE pCodUsuario AS CHAR NO-UNDO.

    DEFINE VARIABLE cDestinatarioEmail   AS CHARACTER  NO-UNDO INITIAL ''.
    DEFINE VARIABLE cMensagem            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE vArqMail             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lErro       AS LOGICAL      NO-UNDO INITIAL NO.
    

    IF nota-fiscal.cod-estabel BEGINS "6" THEN
        ASSIGN cDestinatarioEmail = "financeiro@decio.ind.br".
    ELSE DO:
       IF nota-fiscal.cod-estabel = "301" or
          nota-fiscal.cod-estabel = "103" THEN
          ASSIGN cDestinatarioEmail = "michele.castro@maxcom.ind.br".
       ELSE
           ASSIGN cDestinatarioEmail = "grupo.contasapagar@intelbras.com.br".
    END.

    FOR EACH tt-mail.
        DELETE tt-mail.
    END.
    FIND emitente
         WHERE emitente.cod-emitente = nota-fiscal.cod-emitente
         NO-LOCK NO-ERROR.

    ASSIGN cMensagem = "Faturamento emitiu NF de devoluá∆o Nß " + STRING(nota-fiscal.nr-nota-fis) + 
                       ", fornecedor " + string(nota-fiscal.cod-emitente) + " - " + emitente.nome-emit +  CHR(10) + 
                       "Favor efetuar baixa da mesma "   + CHR(10) + CHR(10) +
                       "Valor Mercadoria : " + STRING(nota-fiscal.vl-mercad) + CHR(10) + 
                       "     Valor Total : " + STRING(nota-fiscal.vl-tot-nota) + CHR(10) + CHR(10) .

/* Comentado para pegar a logica a segui e inserir natureza e condiá∆o de pagamento conforme chamado - 122317
    ASSIGN cMensagem   = cMensagem + 
                             "Item    Descricao                                       Qt Nota Origem" + CHR(10) +
                             "------- ------------------------------------ ------------- -----------" + CHR(10).

    for each it-nota-fisc of nota-fiscal,
        first item fields(it-codigo desc-item) no-lock 
        where item.it-codigo = it-nota-fisc.it-codigo:
        ASSIGN cMensagem = cMensagem +
                           string(it-nota-fisc.it-codigo,"x(07)")  + ' ' +
                           string(item.desc-item,"X(36)")          + ' ' +
                           string(it-nota-fisc.qt-faturada[1],">>>>,>>9.9999") + " " +
                           it-nota-fisc.nr-docum +  CHR(10).
    end. */
    
    /* Conforme chamado 122317 */
    ASSIGN cMensagem   = cMensagem + 
                             "Item    Descricao                                       Qt Nota Origem Natureza  Cond Pag               " + CHR(10) +
                             "------- ------------------------------------ ------------- ----------- --------- -----------------------" + CHR(10).

    for each it-nota-fisc of nota-fiscal,
        first item fields(it-codigo desc-item) no-lock 
        where item.it-codigo = it-nota-fisc.it-codigo:
        ASSIGN cMensagem = cMensagem +
                           string(it-nota-fisc.it-codigo,"x(07)")  + ' ' +
                           string(item.desc-item,"X(36)")          + ' ' +
                           string(it-nota-fisc.qt-faturada[1],">>>>,>>9.9999") + " " +
                           string(it-nota-fisc.nr-docum,"x(11)") + ' ' +
                           it-nota-fisc.nat-docum + "    ".
                          /* CHR(10). */
        
       /* Busca Nota de origem ou entrada */
       FOR EACH docum-est WHERE
                docum-est.serie-docto  = it-nota-fisc.serie-docum AND
                docum-est.nro-docto    = it-nota-fisc.nr-docum    AND
                docum-est.cod-emitente = it-nota-fisc.cd-emitente AND
                docum-est.nat-operacao = it-nota-fisc.nat-docum
                NO-LOCK,
          FIRST item-doc-est OF docum-est WHERE
                item-doc-est.it-codigo = it-nota-fisc.it-codigo
                NO-LOCK.

           IF item-doc-est.num-pedido <> 0 
           THEN DO:
                FIND FIRST pedido-compr WHERE
                           pedido-compr.num-pedido = item-doc-est.num-pedido
                           NO-LOCK NO-ERROR.

                IF AVAIL pedido-compr 
                THEN DO:
                    FIND FIRST cond-pagto WHERE
                               cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag
                               NO-LOCK NO-ERROR.

                    IF AVAIL cond-pagto 
                    THEN ASSIGN cMensagem = cMensagem 
                                          + string(pedido-compr.cod-cond-pag)
                                          + " - "
                                          + string(cond-pagto.descricao,"X(19)")
                                          + CHR(10).
                END.
           END.
           ELSE DO:
              FIND FIRST rat-ordem OF item-doc-est
                         NO-LOCK NO-ERROR.

              IF AVAIL rat-ordem 
              THEN DO:
                 FIND FIRST pedido-compr WHERE
                            pedido-compr.num-pedido = rat-ordem.num-pedido
                            NO-LOCK NO-ERROR.
                 
                 IF AVAIL pedido-compr 
                 THEN DO:
                     FIND FIRST cond-pagto WHERE
                                cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag
                                NO-LOCK NO-ERROR.
                 
                     IF AVAIL cond-pagto 
                     THEN ASSIGN cMensagem = cMensagem 
                                           + string(pedido-compr.cod-cond-pag)
                                           + " - "
                                           + string(cond-pagto.descricao,"X(19)")
                                           + CHR(10).
                 END.
              END.
           END.
       END.
    END.

    ASSIGN vArqMail = SESSION:TEMP-DIRECTORY + "EnvMailNF.txt".
    OUTPUT STREAM arq-email TO VALUE(vArqMail).
    PUT STREAM arq-email cMensagem FORMAT 'x(2000)'.
    OUTPUT STREAM arq-email CLOSE.
    CREATE tt-mail.
    ASSIGN tt-mail.Destinatario  = cDestinatarioEmail
           tt-mail.Assunto       = "Devolucao de Nota Fiscal."
           tt-mail.Mensagem      = cMensagem
           tt-mail.Arquivo       = vArqMail.
        /*CHR(10) + CHR(10) + */

    FOR FIRST usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = c-seg-usuario:
        ASSIGN tt-mail.Remetente = usuar_mestre.cod_e_mail_local.
    END.
    IF tt-mail.Remetente = "" THEN
        ASSIGN tt-mail.Remetente = "ems@intelbras.com.br".

    RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                          OUTPUT TABLE tt-erro).
    
    IF  OPSYS <> "UNIX":U THEN DO:
        FOR EACH tt-erro:
            MESSAGE tt-erro.mensagem
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
    END.

    FOR EACH tt-mail:
        DELETE tt-mail.
    END.

END PROCEDURE.


PROCEDURE pi-gera-html:

    def var c-nr-pedido        as char format "x(1000)" no-undo.
    def var c-tit-ped          as char format "x(100)" no-undo.
    def var c-dados-empresa    as char format "x(300)" no-undo.
    def var c-dados-cliente    as char format "x(400)" no-undo.
    def var c-total            AS char format "x(400)" no-undo.
    def var c-imagem           as char format "x(120)" no-undo.    
    DEFINE VARIABLE c-data          AS CHARACTER   NO-UNDO.
    
    run html-inicio ("Situaá∆o do Pedido").

    FIND estabelec
        WHERE estabelec.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.
    find emitente where
         emitente.cod-emitente = estabelec.cod-emitente no-lock no-error.

    assign c-data      = string(day(ped-venda.dt-emissao),"99") 
                       + "/"
                       + string(month(ped-venda.dt-emissao),"99")
                       + "/"
                       + string(year(ped-venda.dt-emissao), "9999")
           c-nr-pedido = CHR(10) 
                       + "<TH> <FONT FACE="
                       + chr(34)
                       + "Times New Roman"
                       + chr(34)
                       + " SIZE=3> Nr.: "
                       + string(ped-venda.nr-pedido, ">>>,>>9")
                       + " - "
                       + c-data
                       + trim(string("")) + "<BR>" 
                       + "<B> Nr.NF..: </B>" + nota-fiscal.nr-nota-fis
                       + trim(string("")) + "<BR>" 
                       + "<B> Emissao..: </B>" + STRING(nota-fiscal.dt-emis-nota)
                       + trim(string("")) + "<BR>" 
                       + "<B> Transportadora: </B>" + nota-fiscal.nome-transp
                       + "</FONT> </TH>"                       
           c-dados-empresa = "<B>" + estabelec.nome + "</B><BR>"
                           + "<B>Endereáo:</B> " + estabelec.endereco + " - " + estabelec.bairro + "<BR>"
                           + "<B>Cidade:</B> " + estabelec.cidade + "," + estabelec.estado + "<BR>"
                           + trim(string("")) + "<BR>"                          
                           + "<B>Fone:</B> "
                           + emitente.telefone[1]
                           + "<BR>"
                           + "<B>Home:</B> " + emitente.home-page
                           + "<BR>"                          
                           + "<B>CNPJ:</B> " + trim(string(estabelec.cgc)) + "<BR>"
                           + "<B>I.Estadual:</B> " + trim(string(estabelec.ins-estadual))
                           + "<BR>" .                             
   
   FIND emitente
        WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR.

   ASSIGN c-dados-cliente =  "<B>Cliente:</B> " + string(emitente.cod-emitente) + " - " + emitente.nome-abrev + "</B>"
                              + "<BR>"                              
                              + "<B>Raz∆o Social:</B> " + trim(emitente.nome-emit)  
                              + "<BR>"
                              + "<B>Endereáo:</B> " + emitente.endereco + " - " + emitente.bairro
                              + "<BR>"
                              + "<B>Cidade:</B> " + emitente.cidade + " - " + emitente.estado
                              + "<BR>"
                              + "<B>Fone:</B> " + emitente.telefone[1] + "  -  " + "<B>Fax:</B> " + emitente.telefax
                              + "<BR>"
                              + "<B>CNPJ:</B> " + emitente.cgc 
                              + "<BR>"                              
                              
           
           c-tit-ped      = "<FONT FACE="
                            + chr(34)
                            + "Times New Roman"
                            + chr(34)
                            + " SIZE=3>Itens de Pedido Atendidos"
                            + "</FONT>".
    if estabelec.cod-estabel = "301" OR
       estabelec.cod-estabel = "103" then
/*        assign c-imagem = '<td width="15%" rowspan="5"><img src="logo_maxcom.jpg" width="142" height="23"></td>'. */
         assign  c-imagem   = "<TH> <FONT FACE=" + chr(34) + "Arial Black, sans-serif" + chr(34) + " SIZE=5 COLOR=#33FF66> Maxcom </FONT> </TH>". 
    if estabelec.cod-estabel = "101" then
/*        assign c-imagem = '<td width="15%" rowspan="5"><img src="logo_maxcom.jpg" width="142" height="23"></td>'. */
         assign  c-imagem   = "<TH> <FONT FACE=" + chr(34) + "Arial Black, sans-serif" + chr(34) + " SIZE=5 COLOR=#33FF66> Intelbras - Matriz </FONT> </TH>". 
    if estabelec.cod-estabel = "102" then
/*        assign c-imagem = '<td width="15%" rowspan="5"><img src="logo_maxcom.jpg" width="142" height="23"></td>'. */
         assign  c-imagem   = "<TH> <FONT FACE=" + chr(34) + "Arial Black, sans-serif" + chr(34) + " SIZE=5 COLOR=#33FF66> Intelbras </FONT> </TH>". 
    if estabelec.cod-estabel = "104" then
/*        assign c-imagem = '<td width="15%" rowspan="5"><img src="logo_maxcom.jpg" width="142" height="23"></td>'. */
         assign  c-imagem   = "<TH> <FONT FACE=" + chr(34) + "Arial Black, sans-serif" + chr(34) + " SIZE=5 COLOR=#33FF66> Intelbras </FONT> </TH>". 
    


    run html-ini-tab.
    
    run html-ini-lin-tab.
    put c-imagem skip.

    run html-cab-tab(c-tit-ped).
    
    put c-nr-pedido skip . 
    
    run html-fim-lin-tab.
    run html-fim-tab.
    
    run html-ini-tab.
    run html-ini-lin-tab.    
    
    put "<TD ALIGN=" '"'  
      + "left" 
      + '"' ">" trim(c-dados-empresa) format "x(400)" "</TD>"  skip.
    
    put " <TD ALIGN=" '"' 
        + "left" 
        + '"' ">"  trim(c-dados-cliente) format "x(400)" "</TD>" skip. 
    run html-fim-lin-tab.
    run html-fim-tab.

    run html-ini-tab.
    run html-ini-lin-tab.    
        
    ASSIGN c-total = "<B>Total Nota Fiscal:</B> " + STRING(nota-fiscal.vl-tot-nota,">>>,>>>,>>9.99") .

    put " <TD ALIGN=" '"' 
        + "left" 
        + '"' ">"
         trim(c-total) FORMAT "x(40)"  "</TD>" skip. 

    put " <TD ALIGN=" '"' 
        + "left" 
        + '"' ">" ped-venda.observacoes "</TD>" skip. 

    run html-fim-lin-tab.
    run html-fim-tab.

END PROCEDURE.

PROCEDURE pi-atualiza-movto.
    DEF VAR c-unid-neg AS CHAR NO-UNDO.

    FIND it-nota-fisc
        WHERE it-nota-fisc.cod-estabel  = movto-estoq.cod-estabel
          AND it-nota-fisc.serie        = movto-estoq.serie-docto
          AND it-nota-fisc.nr-nota-fis  = movto-estoq.nro-docto
          AND it-nota-fisc.nr-seq-fat   = movto-estoq.sequen-nf
          AND it-nota-fisc.it-codigo    = movto-estoq.it-codigo NO-LOCK NO-ERROR.

    IF  AVAIL it-nota-fisc
    THEN
        ASSIGN c-unid-neg = it-nota-fisc.cod-unid-neg.
    
    IF c-unid-neg <> "" THEN DO:
        IF AVAIL int-natur-oper 
        AND int-natur-oper.contab-unid-neg THEN DO:
            FIND FIRST int-unid-neg-natur
                 WHERE int-unid-neg-natur.cod-estabel  = movto-estoq.cod-estabel
                   AND int-unid-neg-natur.cod-unid-neg = c-unid-neg
                   AND int-unid-neg-natur.nat-operacao = movto-estoq.nat-operacao NO-ERROR.
            IF AVAIL int-unid-neg-natur 
            THEN DO:
                assign movto-estoq.conta-contabil = int-unid-neg-natur.ct-codigo + int-unid-neg-natur.sc-codigo
                       movto-estoq.ct-codigo      = int-unid-neg-natur.ct-codigo
                       movto-estoq.sc-codigo      = int-unid-neg-natur.sc-codigo.
    
                FIND FIRST tt-conta
                     WHERE tt-conta.sequen-nf = movto-estoq.sequen-nf NO-ERROR.
                IF NOT AVAIL tt-conta 
                THEN DO:
                    CREATE tt-conta.
                    ASSIGN tt-conta.conta-contabil = int-unid-neg-natur.ct-codigo + int-unid-neg-natur.sc-codigo
                           tt-conta.sequen-nf      = movto-estoq.sequen-nf
                           tt-conta.ct-icms-ft     = int-unid-neg-natur.ct-codigo
                           tt-conta.sc-icms-ft     = int-unid-neg-natur.sc-codigo
                           tt-conta.ct-ipi-ft      = int-unid-neg-natur.ct-codigo
                           tt-conta.sc-ipi-ft      = int-unid-neg-natur.sc-codigo
                           tt-conta.ct-cofins-ft   = int-unid-neg-natur.ct-codigo
                           tt-conta.sc-cofins-ft   = int-unid-neg-natur.sc-codigo
                           tt-conta.ct-pis-ft      = int-unid-neg-natur.ct-codigo
                           tt-conta.sc-pis-ft      = int-unid-neg-natur.sc-codigo
                           tt-conta.cod-unid-negoc = c-unid-neg.
                END.
            END.
        END.
    END.
    IF AVAIL ped-fiscal AND /* Se for uma nota de solicitaá∆o de nota fiscal ent∆o considera o ccusto informado na solicitaá∆o */
       substring(movto-estoq.ct-codigo,1,1) = "4" THEN DO: /* somente troca a conta que iniciam com 4 */
       ASSIGN movto-estoq.sc-codigo      = ped-fiscal.sc-codigo.
    END.
    RETURN "OK".
END PROCEDURE.

PROCEDURE piEnviaEmailAtendente :
    
    DEFINE INPUT  PARAM pDestino   AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHARACTER NO-UNDO.
    
    FIND FIRST param-global NO-LOCK NO-ERROR.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.
    
    empty temp-table tt-envio2.
    empty temp-table tt-mensagem.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
           tt-envio2.destino           = pDestino                 /* Destinatˇrio       */ 
           tt-envio2.remetente         = "ems@intelbras.com.br"   /* Remetente          */ 
           tt-envio2.assunto           = pAssunto                 /* Assunto            */
           tt-envio2.arq-anexo         = ""                      /* Arquivo Temporˇrio */
           tt-envio2.formato           = "TEXTO".
    
    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem    = 1
           tt-mensagem.mensagem        = pDescEmail + CHR(13). /* Mensagem */
    
    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).
    
    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF AVAIL tt-erros 
    THEN DO:
         OUTPUT TO erros-ava.LOG APPEND.

         FOR EACH tt-erros:
             DISP tt-erros.cod-erro
                  tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
         END.
         OUTPUT CLOSE.
    END.

    IF VALID-HANDLE(h-utapi019) 
       THEN DELETE PROCEDURE h-utapi019. 
    
END PROCEDURE.
