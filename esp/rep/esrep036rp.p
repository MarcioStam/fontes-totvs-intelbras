{include/i-prgvrs.i ESREP036 2.04.00.005} 

/* DEF TEMP-TABLE tt-item-devol-cli NO-UNDO                           */
/*     FIELD rw-it-nota-fisc   AS ROWID                               */
/*     FIELD quant-devol       LIKE item-doc-est.quantidade           */
/*     FIELD preco-devol       LIKE item-doc-est.preco-total EXTENT 0 */
/*     FIELD cod-depos         LIKE item-doc-est.cod-depos            */
/*     FIELD reabre-pd         LIKE item-doc-est.reabre-pd            */
/*     FIELD vl-desconto       LIKE item-doc-est.pr-total-cmi.        */

{inbo/boin176.i4 tt-item-devol-cli } /* DefiniÓ“o tt-item-devol-cli */

DEFINE TEMP-TABLE tt-docum-est NO-UNDO LIKE movind.docum-est
       field r-Rowid as rowid.

DEFINE VARIABLE aux-c-char            AS CHAR EXTENT 50              NO-UNDO.
DEFINE VARIABLE aux-i-num-var         AS INT  EXTENT 2               NO-UNDO.
DEFINE VARIABLE aux-i-tamanho         AS INT  EXTENT 2               NO-UNDO.
DEFINE VARIABLE aux-i-cont            AS INT                         NO-UNDO.
DEFINE VARIABLE l-ipi-bicms           AS LOG  FORM "Sim/Nao"         NO-UNDO.
DEFINE VARIABLE l-frete-bipi          AS LOG  FORM "Sim/Nao"         NO-UNDO.
DEFINE VARIABLE l-ind-bipi            AS LOG  FORM "Bruto/Liquido"   NO-UNDO.
DEFINE VARIABLE l-ipi-tot-nota        AS LOG  FORM "Sim/Nao"         NO-UNDO.
DEFINE VARIABLE l-ind-biss            AS LOG  FORM "Bruto/Liquido"   NO-UNDO.
DEFINE VARIABLE c-modelo-cupom-fiscal AS CHAR FORM "x(2)"            NO-UNDO.
DEFINE VARIABLE l-atu-cota            AS LOG  FORM "Sim/N∆o"         NO-UNDO.
DEFINE VARIABLE wh-imprime            AS HANDLE                      NO-UNDO.
DEFINE VARIABLE c-desc-aux            AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE l-erro                AS LOGICAL INITIAL NO          NO-UNDO.
DEFINE VARIABLE i-nr-pedido           AS INTEGER  INITIAL 0          NO-UNDO.
DEFINE VARIABLE r-row-id-docum-est    AS ROWID                       NO-UNDO.
DEFINE VARIABLE c-arq                 AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-estab               LIKE estabelec.cod-estabel     NO-UNDO.
DEFINE VARIABLE c-estabel             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nr-nota-fis         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-serie               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-depos           AS CHARACTER   NO-UNDO.

DEF BUFFER b-estabelec  FOR estabelec.
DEF BUFFER b-natur-oper FOR natur-oper.
DEF BUFFER b-natur-comp FOR natur-oper.
DEF BUFFER b-estab      FOR estabelec.
                     
{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}
{cdp/cdcfgcex.i}
{utp/ut-glob.i}
{cdp/cd0666.i}
{method/dbotterr.i}
{include/i-rpvar.i}

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

define temp-table tt-param no-undo
    FIELD cod-estabel    LIKE estabelec.cod-estabel
    FIELD nr-nota-fis    LIKE nota-fiscal.nr-nota-fis
    FIELD serie          LIKE nota-fiscal.serie
    FIELD cod-deposito   LIKE deposito.cod-depos
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG.

assign aux-i-num-var[1] = 7. /* Sempre que for criada uma nova variavel nesse 
                                programa, devera  ser  acrescentado  um  para 
                                essa variavel.*/

ASSIGN aux-i-tamanho[1] = 5. /*Variaveis para CD0604*/

DEF VAR h-boin176 AS HANDLE NO-UNDO.
DEF VAR h-boin090 AS HANDLE NO-UNDO.

DEFINE VARIABLE h-acomp     AS HANDLE     NO-UNDO.
run utp/ut-acomp.p persistent set h-acomp.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

FIND FIRST tt-param NO-LOCK NO-ERROR.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "T°tulos por Referància"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESREP003"
       c-versao       = "2.04"
       c-revisao      = "005".

/* ***************************  Main Block  *************************** */

{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

RUN pi-inicializar in h-acomp ("Gerando..").

ASSIGN c-estabel     = tt-param.cod-estabel
       c-nr-nota-fis = tt-param.nr-nota-fis
       c-serie       = tt-param.serie
       c-cod-depos   = tt-param.cod-depos.

IF NOT CAN-FIND (FIRST deposito
                 WHERE deposito.cod-depos = c-cod-depos) THEN DO:
    RUN pi-erro-nota (INPUT 17006,
                      INPUT "N∆o encontrado dep¢sito para chave informada.").
END.
 
FIND FIRST nota-fiscal NO-LOCK
     WHERE nota-fiscal.cod-estabel = c-estabel
       AND nota-fiscal.nr-nota-fis = c-nr-nota-fis
       AND nota-fiscal.serie       = c-serie NO-ERROR.

IF NOT AVAIL nota-fiscal THEN DO:
    RUN pi-erro-nota (INPUT 17006,
                      INPUT "N∆o encontrada documento de sa°da para chave informada.").
END.
ELSE DO:

    IF nota-fiscal.dt-confirma = ? THEN DO:
        RUN pi-erro-nota (INPUT 17006,
                          INPUT "Nota Fiscal n∆o atualizada no estoque.").
    END.
    FIND FIRST b-estabelec NO-LOCK
         WHERE b-estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.

    FIND FIRST b-natur-oper NO-LOCK
         WHERE b-natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.  

    IF b-natur-oper.especie-doc <> "NFT" THEN DO:
        RUN pi-erro-nota (INPUT 17006,
                          INPUT "N∆o ser† poss°vel fazer o retorno, natureza da nota n∆o Ç de transferància.").
    END.

    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = b-natur-oper.nat-comp NO-ERROR.

    IF NOT AVAIL natur-oper THEN DO:
        RUN pi-erro-nota (INPUT 17006,
                          INPUT "N∆o encontrada natureza de operaá∆o complementar para a natureza " + b-natur-oper.nat-operacao).
    END.
    
    IF CAN-FIND (FIRST docum-est 
                 WHERE docum-est.nro-docto    = nota-fiscal.nr-nota-fis
                   AND docum-est.serie-docto  = nota-fiscal.serie
                   AND docum-est.cod-emitente = b-estabelec.cod-emitente
                   AND docum-est.nat-oper     = natur-oper.nat-operacao) THEN DO:  

        RUN pi-erro-nota (INPUT 17006,
                          INPUT "J† existe nota no recebimento com a chave informada.").
    END.
END.

IF l-erro THEN DO:
    /*imprime erros*/
    FOR EACH tt-erro:
        PUT UNFORMATTED tt-erro.mensagem SKIP.
    END.
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
    RETURN "NOK":U.
END.

ASSIGN l-erro = NO.

IF  NOT VALID-HANDLE(h-boin176) THEN DO:
    RUN inbo/boin176.p PERSISTENT SET h-boin176.
    RUN openQueryStatic IN h-boin176 (INPUT "Main":U).
END.

IF  NOT VALID-HANDLE(h-boin090) THEN DO:
    RUN inbo/boin090.p PERSISTENT SET h-boin090.
    RUN openQueryStatic IN h-boin090 (INPUT "Main":U).
END.

blk_principal:
DO TRANSACTION ON ERROR UNDO, LEAVE
               ON STOP  UNDO, LEAVE:

    FIND FIRST param-estoq NO-LOCK NO-ERROR.
    
    FIND FIRST nota-fiscal NO-LOCK
        WHERE  nota-fiscal.cod-estabel = c-estabel
          AND  nota-fiscal.serie       = c-serie
          AND  nota-fiscal.nr-nota-fis = c-nr-nota-fis NO-ERROR.
    
    FIND FIRST ped-transf NO-LOCK
        WHERE  ped-transf.cod-estabel = nota-fiscal.cod-estabel
          AND  ped-transf.serie       = nota-fiscal.serie
          AND  ped-transf.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.

    IF  AVAIL  ped-transf THEN
        ASSIGN c-cod-depos = ped-transf.cod-depos-dest.
    
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
    
    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.
    
    RUN pi-leitura-dos-itens.

    IF RETURN-VALUE = "NOK":U THEN 
        UNDO blk_principal, LEAVE blk_principal.
        

    /*RUN pi-recalculo-itens.*/
END.

IF  VALID-HANDLE(h-boin176) THEN RUN destroy IN h-boin176.
IF  VALID-HANDLE(h-boin090) THEN RUN destroy IN h-boin090.

ASSIGN h-boin176 = ?
       h-boin090 = ?.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

IF l-erro THEN DO:
    FOR EACH tt-erro:
        PUT UNFORMATTED tt-erro.mensagem SKIP.
    END.
END.
ELSE DO:
    PUT UNFORMATTED "Documento gerado com sucesso no re1001" SKIP.
END.

{include/i-rpclo.i}
RETURN "OK".


PROCEDURE pi-erro-nota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER cod-mensag  AS INTEGER                      NO-UNDO.
    DEF INPUT PARAMETER c-parametro AS CHAR                         NO-UNDO.

    CREATE tt-erro.
    ASSIGN tt-erro.cd-erro  = cod-mensag
           tt-erro.mensagem = c-parametro
           l-erro   = YES.

END PROCEDURE.

/* PROCEDURE pi-gera-docum-est :                                                                                   */
/* /*------------------------------------------------------------------------------                                */
/*   Purpose:                                                                                                      */
/*   Parameters:  <none>                                                                                           */
/*   Notes:                                                                                                        */
/* ------------------------------------------------------------------------------*/                                */
/*     FIND FIRST estabelec NO-LOCK                                                                                */
/*         WHERE estabelec.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.                                       */
/*                                                                                                                 */
/*     FIND FIRST b-estabelec NO-LOCK                                                                              */
/*         WHERE b-estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.                                       */
/*                                                                                                                 */
/*     FIND FIRST b-natur-oper NO-LOCK                                                                             */
/*         WHERE b-natur-oper.nat-operacao = it-nota-fisc.nat-operacao NO-ERROR.                                   */
/*                                                                                                                 */
/*     FIND FIRST natur-oper NO-LOCK                                                                               */
/*          WHERE natur-oper.nat-operacao = b-natur-oper.nat-comp NO-ERROR.                                        */
/*                                                                                                                 */
/*     FIND FIRST transporte NO-LOCK                                                                               */
/*         WHERE transporte.nome-abrev = nota-fiscal.nome-transp NO-ERROR.                                         */
/*                                                                                                                 */
/*     ASSIGN c-serie = IF nota-fiscal.serie = "1." THEN "1" ELSE nota-fiscal.serie.                               */
/*                                                                                                                 */
/*     IF YES THEN DO aux-i-cont = 1 TO aux-i-num-var[1]:                                                          */
/*         ASSIGN aux-c-char[aux-i-cont] =                                                                         */
/*                    SUBSTR( natur-oper.char-2,                                                                   */
/*                            aux-i-tamanho[1] * (aux-i-cont - 1) + 1,                                             */
/*                            aux-i-tamanho[1]).                                                                   */
/*     END.                                                                                                        */
/*                                                                                                                 */
/*     /* Grava os conteudos de aux-c-char para variavel */                                                        */
/*     ELSE DO  aux-i-cont = 1 to aux-i-num-var[1]:                                                                */
/*         ASSIGN SUBSTR( natur-oper.char-2,                                                                       */
/*                        aux-i-tamanho[1] * (aux-i-cont - 1) + 1,                                                 */
/*                        aux-i-tamanho[1]) =                                                                      */
/*              SUBSTR(STRING(aux-c-char[aux-i-cont], "x(50)"), 1, aux-i-tamanho[1]).                              */
/*     END.                                                                                                        */
/*                                                                                                                 */
/*     ASSIGN l-ipi-bicms           = aux-c-char[1] = "1"                                                          */
/*            l-frete-bipi          = aux-c-char[2] = "1"                                                          */
/*            l-ind-bipi            = aux-c-char[3] = "1"                                                          */
/*            l-ipi-tot-nota        = aux-c-char[4] = "1"                                                          */
/*            l-ind-biss            = aux-c-char[5] = "1"                                                          */
/*            c-modelo-cupom-fiscal = aux-c-char[6]                                                                */
/*            l-atu-cota            = aux-c-char[7] = "1".                                                         */
/*                                                                                                                 */
/*     CREATE docum-est.                                                                                           */
/*     ASSIGN docum-est.cod-emitente  = b-estabelec.cod-emitente                                                   */
/*            docum-est.cod-estabel   = estabelec.cod-estabel                                                      */
/*            docum-est.cod-observa   = if natur-oper.log-2 then 2 else 1 /*natur-oper.log-2 = nota de comercio*/  */
/*            docum-est.conta-transit = param-estoq.conta-transf                                                   */
/*            docum-est.ct-transit    = param-estoq.ct-tr-transf                                                   */
/*            docum-est.sc-transit    = param-estoq.sc-tr-transf                                                   */
/*            docum-est.dt-emissao    = nota-fiscal.dt-emis-nota                                                   */
/*            docum-est.dt-trans      = TODAY                                                                      */
/*            docum-est.dt-venc-icm   = docum-est.dt-trans                                                         */
/*            docum-est.dt-venc-ipi   = docum-est.dt-trans                                                         */
/*            docum-est.esp-docto     = 23 /*NFT*/                                                                 */
/*            docum-est.estab-de-or   = nota-fiscal.cod-estabel                                                    */
/*            docum-est.estab-fisc    = estabelec.cod-estabel                                                      */
/*            docum-est.nat-operacao  = natur-oper.nat-operacao                                                    */
/*            docum-est.nro-docto     = nota-fiscal.nr-nota-fis                                                    */
/*            docum-est.observacao    = nota-fiscal.observ-nota                                                    */
/*            docum-est.pais-origem   = "RE1001"                                                                   */
/*            docum-est.serie-docto   = c-serie                                                                    */
/*            docum-est.tipo-docto    = natur-oper.tipo                                                            */
/*            docum-est.uf            = nota-fiscal.estado /*nota-fiscal.uf*/                                      */
/*            docum-est.usuario       = v_cod_usuar_corren                                                         */
/*            docum-est.via-transp    = IF AVAIL transporte THEN transporte.via-transp else 1                      */
/*            docum-est.sit-atual     = 2                                                                          */
/*            docum-est.cod-chave-aces-nf-eletro = nota-fiscal.cod-chave-aces-nf-eletro                            */
/*            OVERLAY(docum-est.char-2,143, 8) = SUBSTRING(nota-fiscal.char-2,201,8).                              */
/*                                                                                                                 */
/*     FIND FIRST emitente NO-LOCK                                                                                 */
/*          WHERE emitente.cod-emitente = docum-est.cod-emitente NO-ERROR.                                         */
/*                                                                                                                 */
/*     FIND FIRST loc-entr NO-LOCK                                                                                 */
/*          WHERE loc-entr.nome-abrev = emitente.nome-abrev                                                        */
/*            AND loc-entr.cod-entrega = "Padrao"  NO-ERROR.                                                       */
/*                                                                                                                 */
/*     IF AVAIL loc-entr THEN DO:                                                                                  */
/*         ASSIGN docum-est.cod-entrega = "Padrao"                                                                 */
/*                docum-est.endereco    = loc-entr.endereco                                                        */
/*                docum-est.bairro      = loc-entr.bairro                                                          */
/*                docum-est.cep         = loc-entr.cep                                                             */
/*                docum-est.cidade      = loc-entr.cidade                                                          */
/*                docum-est.uf          = loc-entr.estado                                                          */
/*                docum-est.pais        = loc-entr.pais                                                            */
/*                docum-est.log-consid-ender-nf-saida = YES.                                                       */
/*     END.                                                                                                        */
/*     ELSE DO:                                                                                                    */
/*         ASSIGN docum-est.cod-entrega = nota-fiscal.cod-entrega                                                  */
/*                docum-est.endereco    = nota-fiscal.endereco                                                     */
/*                docum-est.bairro      = nota-fiscal.bairro                                                       */
/*                docum-est.cep         = nota-fiscal.cep                                                          */
/*                docum-est.cidade      = nota-fiscal.cidade                                                       */
/*                docum-est.uf          = nota-fiscal.estado                                                       */
/*                docum-est.pais        = nota-fiscal.pais                                                         */
/*                docum-est.log-consid-ender-nf-saida = YES.                                                       */
/*     END.                                                                                                        */
/*                                                                                                                 */
/*     ASSIGN r-row-id-docum-est = rowid(docum-est).                                                               */
/*                                                                                                                 */
/*     &if  defined(bf_mat_conta_estab) &then                                                                      */
/*         FIND FIRST b-estab NO-LOCK                                                                              */
/*              WHERE b-estab.cod-estabel = docum-est.cod-estabel NO-ERROR.                                        */
/*                                                                                                                 */
/*         FOR FIRST estab-mat                                                                                     */
/*             FIELDS ( cod-estabel conta-transf  cod-cta-transf-unif cod-ccusto-transf-unif)                      */
/*             WHERE estab-mat.cod-estabel = b-estab.cod-estabel NO-LOCK: END.                                     */
/*                                                                                                                 */
/*         IF AVAIL estab-mat THEN DO:                                                                             */
/*             ASSIGN docum-est.ct-transit = estab-mat.cod-cta-transf-unif                                         */
/*                    docum-est.sc-transit = estab-mat.cod-ccusto-transf-unif.                                     */
/*         END.                                                                                                    */
/*     &endif                                                                                                      */
/*                                                                                                                 */
/* END PROCEDURE.                                                                                                  */

PROCEDURE pi-cria-docum-via-bo:
        /*--- Procede com a atualiza∂∆o do documento ---*/
    
    IF NOT VALID-HANDLE(h-boin090) THEN
        run inbo/boin090.p persistent set h-boin090.
    
    RUN emptyRowErrors IN h-boin090.
    EMPTY TEMP-TABLE tt-docum-est.
    
    FIND FIRST estabelec NO-LOCK
        WHERE estabelec.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
    
    FIND FIRST b-estabelec NO-LOCK
        WHERE b-estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.

    FIND FIRST b-natur-oper NO-LOCK
        WHERE b-natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.        

    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = b-natur-oper.nat-comp NO-ERROR.

    FIND FIRST transporte NO-LOCK
        WHERE transporte.nome-abrev = nota-fiscal.nome-transp NO-ERROR.

    ASSIGN c-serie = IF nota-fiscal.serie = "1." THEN "1" ELSE nota-fiscal.serie.

    IF YES THEN DO aux-i-cont = 1 TO aux-i-num-var[1]:
        ASSIGN aux-c-char[aux-i-cont] = 
                   SUBSTR( natur-oper.char-2, 
                           aux-i-tamanho[1] * (aux-i-cont - 1) + 1,
                           aux-i-tamanho[1]). 
    END.

    /* Grava os conteudos de aux-c-char para variavel */
    ELSE DO  aux-i-cont = 1 to aux-i-num-var[1]:
        ASSIGN SUBSTR( natur-oper.char-2,
                       aux-i-tamanho[1] * (aux-i-cont - 1) + 1,
                       aux-i-tamanho[1]) = 
             SUBSTR(STRING(aux-c-char[aux-i-cont], "x(50)"), 1, aux-i-tamanho[1]).
    END.

    ASSIGN l-ipi-bicms           = aux-c-char[1] = "1"
           l-frete-bipi          = aux-c-char[2] = "1"
           l-ind-bipi            = aux-c-char[3] = "1"
           l-ipi-tot-nota        = aux-c-char[4] = "1"
           l-ind-biss            = aux-c-char[5] = "1"
           c-modelo-cupom-fiscal = aux-c-char[6]
           l-atu-cota            = aux-c-char[7] = "1".   

    CREATE tt-docum-est.
    ASSIGN tt-docum-est.cod-emitente  = b-estabelec.cod-emitente
           tt-docum-est.cod-estabel   = estabelec.cod-estabel
           tt-docum-est.cod-observa   = if natur-oper.log-2 then 2 else 1 /*natur-oper.log-2 = nota de comercio*/
           tt-docum-est.conta-transit = param-estoq.conta-transf
           tt-docum-est.ct-transit    = param-estoq.ct-tr-transf
           tt-docum-est.sc-transit    = param-estoq.sc-tr-transf
           tt-docum-est.dt-emissao    = nota-fiscal.dt-emis-nota
           tt-docum-est.dt-trans      = TODAY
           tt-docum-est.dt-venc-icm   = tt-docum-est.dt-trans
           tt-docum-est.dt-venc-ipi   = tt-docum-est.dt-trans
           tt-docum-est.esp-docto     = 23 /*NFT*/
           tt-docum-est.estab-de-or   = nota-fiscal.cod-estabel
           tt-docum-est.estab-fisc    = estabelec.cod-estabel
           tt-docum-est.nat-operacao  = natur-oper.nat-operacao
           tt-docum-est.nro-docto     = nota-fiscal.nr-nota-fis
           tt-docum-est.observacao    = nota-fiscal.observ-nota
           tt-docum-est.pais-origem   = "RE1001"
           tt-docum-est.serie-docto   = c-serie
           tt-docum-est.tipo-docto    = natur-oper.tipo
           tt-docum-est.uf            = nota-fiscal.estado /*nota-fiscal.uf*/
           tt-docum-est.usuario       = v_cod_usuar_corren
           tt-docum-est.via-transp    = IF AVAIL transporte THEN transporte.via-transp else 1
           tt-docum-est.sit-atual     = 2
           tt-docum-est.cod-chave-aces-nf-eletro = nota-fiscal.cod-chave-aces-nf-eletro.
           OVERLAY(tt-docum-est.char-2,143, 8) = SUBSTRING(nota-fiscal.char-2,201,8).
      

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = tt-docum-est.cod-emitente NO-ERROR.

    FIND FIRST loc-entr NO-LOCK
         WHERE loc-entr.nome-abrev = emitente.nome-abrev
           AND loc-entr.cod-entrega = "Padrao"  NO-ERROR.

    IF AVAIL loc-entr THEN DO:
        ASSIGN tt-docum-est.cod-entrega = "Padrao"
               tt-docum-est.endereco    = loc-entr.endereco
               tt-docum-est.bairro      = loc-entr.bairro
               tt-docum-est.cep         = loc-entr.cep
               tt-docum-est.cidade      = loc-entr.cidade
               tt-docum-est.uf          = loc-entr.estado
               tt-docum-est.pais        = loc-entr.pais
               tt-docum-est.log-consid-ender-nf-saida = YES.
    END.
    ELSE DO:
        ASSIGN tt-docum-est.cod-entrega = nota-fiscal.cod-entrega
               tt-docum-est.endereco    = nota-fiscal.endereco
               tt-docum-est.bairro      = nota-fiscal.bairro
               tt-docum-est.cep         = nota-fiscal.cep
               tt-docum-est.cidade      = nota-fiscal.cidade
               tt-docum-est.uf          = nota-fiscal.estado
               tt-docum-est.pais        = nota-fiscal.pais
               tt-docum-est.log-consid-ender-nf-saida = YES.
    END.

    &if  defined(bf_mat_conta_estab) &then
        FIND FIRST b-estab NO-LOCK
             WHERE b-estab.cod-estabel = tt-docum-est.cod-estabel NO-ERROR.

        FOR FIRST estab-mat 
            FIELDS ( cod-estabel conta-transf  cod-cta-transf-unif cod-ccusto-transf-unif)
            WHERE estab-mat.cod-estabel = b-estab.cod-estabel NO-LOCK: END.

        IF AVAIL estab-mat THEN DO:
            ASSIGN tt-docum-est.ct-transit = estab-mat.cod-cta-transf-unif  
                   tt-docum-est.sc-transit = estab-mat.cod-ccusto-transf-unif.
        END.                       
    &endif

    RUN openQueryStatic IN h-boin090 (INPUT "Main").
    RUN setRecord IN h-boin090 (INPUT TABLE tt-docum-est).
    RUN createRecord IN h-boin090.

    IF RETURN-VALUE = "NOK":U THEN DO:
       RUN getRowErrors IN h-boin090 (OUTPUT TABLE RowErrors).
       RETURN "NOK":U.
    END.

    IF  NOT CAN-FIND (FIRST RowErrors) THEN DO:
        RUN getRowid IN h-boin090 (OUTPUT r-row-id-docum-est).
        /*--- reposiciona a BO de docum-est ---*/
        RUN repositionRecord IN h-boin090 (INPUT r-row-id-docum-est). 

        IF RETURN-VALUE = "NOK":U THEN DO:
           RUN getRowErrors IN h-boin090 (OUTPUT TABLE RowErrors).
           RETURN "NOK":U.
        END.

        FIND FIRST docum-est NO-LOCK 
             WHERE rowid(docum-est) = r-row-id-docum-est NO-ERROR.
        IF AVAIL docum-est THEN DO:
           FOR EACH rat-lote OF docum-est EXCLUSIVE-LOCK:
               ASSIGN rat-lote.cod-depos = c-cod-depos.
           END.
        END.
        
    END.

    RETURN "OK".

END.

PROCEDURE pi-leitura-dos-itens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    RUN pi-cria-docum-via-bo. /*cria o docum-est temporariamente para gerar o log p/ multiplanta*/

    IF  RETURN-VALUE = "NOK" THEN DO:
        ASSIGN l-erro = NO.
        FOR EACH RowErrors 
            WHERE RowErrors.ErrorSubType = "ERROR":U:
            
            RUN pi-erro-nota (INPUT 17006,
                              INPUT "Erro: " + STRING(RowErrors.ErrorNumber) + " - Descriá∆o: " + RowErrors.ErrorDescription   ).
            ASSIGN l-erro = YES.
            
        END.        
    
        IF l-erro THEN
            RETURN "NOK":U.
    END.
    /*

    FIND FIRST docum-est EXCLUSIVE-LOCK
        WHERE ROWID(docum-est) = r-row-id-docum-est  NO-ERROR.

    FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK 
        /*BREAK BY it-nota-fisc.nat-operacao  /* Gera uma nota no recebimento para cada natureza do faturamento*/
              BY it-nota-fisc.nr-seq-fat*/ :

        RUN pi-acompanhar IN h-acomp (INPUT "Lendo item: " + it-nota-fisc.it-codigo).

        FIND FIRST item-uni-estab NO-LOCK
             WHERE item-uni-estab.cod-estabel = nota-fiscal.cod-estabel
               AND item-uni-estab.it-codigo   = it-nota-fisc.it-codigo  NO-ERROR.
    
        IF NOT AVAIL item-uni-estab THEN DO:
            RUN pi-erro-nota (INPUT 17006,
                              INPUT STRING("Item (" + it-nota-fisc.it-codigo + ") n∆o relacionado com o Estabelecimento (" + nota-fiscal.cod-estabel + ")!")).
        END.
    
        IF item-uni-estab.deposito-pad = "" THEN DO:
            RUN pi-erro-nota (INPUT 17006,
                              INPUT STRING("Deposito em branco no cadastro cd1112 para o item " + nota-fiscal.cod-estabel + " " + it-nota-fisc.it-codigo)).
        END.

        IF item-uni-estab.tp-desp-padrao = ? THEN DO:
            RUN pi-erro-nota (INPUT 17006,
                              INPUT STRING("Tipo de despesa em branco no cadastro cd1112 para o item " + nota-fiscal.cod-estabel + " " + it-nota-fisc.it-codigo)).
        END.

        IF item-uni-estab.cod-unid-negoc = "" THEN DO:
            RUN pi-erro-nota (INPUT 17006,
                              INPUT STRING("Unidade de neg¢cio em branco no cadastro cd1112 para o item " + nota-fiscal.cod-estabel + " " + it-nota-fisc.it-codigo)).
        END.

        IF NOT CAN-FIND (FIRST mgcad.localizacao
                         WHERE mgcad.localizacao.cod-estabel = item-uni-estab.cod-estabel
                           AND mgcad.localizacao.cod-localiz = item-uni-estab.cod-localiz) THEN DO:        
            RUN pi-erro-nota (INPUT 17006,
                              INPUT STRING("Localizaá∆o " + item-uni-estab.cod-localiz + " n∆o cadastrada para o estabelecimento " + item-uni-estab.cod-estabel + " item " + it-nota-fisc.it-codigo)).
        END.

        IF NOT l-erro THEN DO:
            /*
            IF FIRST-OF(it-nota-fisc.nat-operacao) THEN DO:
                RUN pi-gera-docum-est. /*cria o docum-est temporariamente para gerar o log p/ multiplanta*/
                
                RUN goToKey IN h-boin090 (INPUT docum-est.serie-docto,
                                          INPUT docum-est.nro-docto, 
                                          INPUT docum-est.cod-emitente,
                                          INPUT docum-est.nat-operacao).
            END.   
                
            FIND FIRST docum-est EXCLUSIVE-LOCK
                WHERE ROWID(docum-est) = r-row-id-docum-est  NO-ERROR.
            */
            EMPTY TEMP-TABLE tt-item-devol-cli.
            CREATE tt-item-devol-cli.
            ASSIGN tt-item-devol-cli.rw-it-nota-fisc = ROWID(it-nota-fisc)
                   tt-item-devol-cli.quant-devol     = it-nota-fisc.qt-faturada[1]
                   tt-item-devol-cli.preco-devol     = it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[1]. /* item-doc-est.qt-do-forn. */

            RUN createItemOfNotaFiscal IN h-boin176 (INPUT h-boin090,
                                                     INPUT TABLE tt-item-devol-cli).

            RUN getRowErrors IN h-boin176 (OUTPUT TABLE RowErrors).
    
            IF  CAN-FIND (FIRST RowErrors) then do:

                FOR EACH RowErrors:
                    IF  RowErrors.errorsubtype <> "WARNING":U THEN DO:
                        RUN pi-erro-nota (INPUT 17006, INPUT "Item: " + it-nota-fisc.it-codigo + " / Seq: " + STRING(it-nota-fisc.nr-seq-fat) + " - " + RowErrors.errordescription).
                    END.
                END.
            END.
    
            FIND FIRST b-natur-comp NO-LOCK
                WHERE b-natur-comp.nat-operacao = it-nota-fisc.nat-operacao NO-ERROR.
            IF  NOT AVAIL b-natur-comp  THEN DO:
                RUN pi-erro-nota (INPUT 17006, INPUT "N∆o foi informada natureza complementar para a natureza " +  b-natur-comp.nat-operacao).
            END.

            /*** Executa o openQuery da BO pra atualizar o registro inclu°do ***/
            RUN openQueryStatic IN h-boin176 (INPUT "OfDocumEst":U).
            
            FIND FIRST item-doc-est EXCLUSIVE-LOCK
                 WHERE item-doc-est.cod-emitente = docum-est.cod-emitente
                   AND item-doc-est.serie-docto  = docum-est.serie-docto
                   AND item-doc-est.nat-operacao = docum-est.nat-operacao
                   AND item-doc-est.nro-docto    = docum-est.nro-docto
                   AND item-doc-est.it-codigo    = it-nota-fisc.it-codigo
                   AND item-doc-est.seq-comp     = it-nota-fisc.nr-seq-fat  NO-ERROR.

            ASSIGN item-doc-est.base-icm[1]    = it-nota-fisc.vl-bicms-it
                   item-doc-est.base-ipi[1]    = it-nota-fisc.vl-bipi-it
                   item-doc-est.base-iss[1]    = it-nota-fisc.vl-biss-it
                   item-doc-est.base-subs[1]   = it-nota-fisc.vl-bsubs-it
                   item-doc-est.icm-complem[1] = it-nota-fisc.vl-icmscomp-it
                   item-doc-est.icm-ntrib[1]   = it-nota-fisc.vl-icmsnt-it
                   item-doc-est.icm-outras[1] = it-nota-fisc.vl-icmsou-it
                   item-doc-est.ipi-ntrib[1]  = it-nota-fisc.vl-ipint-it
                   item-doc-est.ipi-outras[1] = it-nota-fisc.vl-ipiou-it
                   item-doc-est.iss-ntrib[1]  = it-nota-fisc.vl-issnt-it
                   item-doc-est.iss-outras[1] = it-nota-fisc.vl-issou-it
                   item-doc-est.valor-icm[1]  = it-nota-fisc.vl-icms-it
                   item-doc-est.valor-ipi[1]  = it-nota-fisc.vl-ipi-it
                   item-doc-est.valor-iss[1]  = it-nota-fisc.vl-iss-it
                   item-doc-est.vl-subs[1]    = it-nota-fisc.vl-icmsub-it
                   item-doc-est.despesas[1]   = it-nota-fisc.vl-despes-it
                   item-doc-est.pr-total-cmi  = it-nota-fisc.vl-frete-it
                   /*item-doc-est.nat-of        = b-natur-comp.nat-comp*/ .
        
            IF  i-nr-pedido <> 0 THEN DO:
                FIND FIRST it-ped-fiscal NO-LOCK
                    WHERE  it-ped-fiscal.nr-pedido = i-nr-pedido
                    AND    it-ped-fiscal.it-codigo = item-doc-est.it-codigo NO-ERROR.
                IF  AVAIL  it-ped-fiscal THEN
                    ASSIGN c-cod-depos = it-ped-fiscal.cod-depos.
            END.
        
            /*  Tratamento do desconto do item */
            IF  (  nota-fiscal.perc-desco1 
                 + nota-fiscal.perc-desco2 
                 + it-nota-fisc.per-des-item 
                 + DEC(SUBSTR(it-nota-fisc.char-1,1,14)) > 0)
            THEN 
                ASSIGN item-doc-est.preco-unit[1]  = it-nota-fisc.vl-preori
                       item-doc-est.preco-total[1] = it-nota-fisc.vl-merc-ori
                       item-doc-est.desconto[1]    = it-nota-fisc.vl-merc-ori
                                                   - it-nota-fisc.vl-merc-liq
                       item-doc-est.desconto[1]    = IF  item-doc-est.desconto[1] < 0
                                                     THEN 0 
                                                     ELSE item-doc-est.desconto[1].
            ELSE
                ASSIGN item-doc-est.preco-total[1] = it-nota-fisc.vl-merc-liq. 
        
            FOR EACH rat-lote OF item-doc-est:
                ASSIGN rat-lote.cod-depos = c-cod-depos.
            END.
            
            RUN pi-totaliza-documento.  
        END. /*IF NOT l-erro*/
    END.
    */

    IF l-erro THEN
        RETURN "NOK":U.

END PROCEDURE.

PROCEDURE pi-recalculo-itens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN docum-est.base-icm      =    0
           docum-est.base-ipi      =    0
           docum-est.base-subs     =    0
           docum-est.despesa-nota  =    0
           docum-est.icm-complem   =    0
           docum-est.icm-deb-cre   =    0
           docum-est.ipi-deb-cre   =    0
           docum-est.ipi-outras    =    0
           docum-est.tot-desconto  =    0
           docum-est.tot-peso      =    0
           docum-est.valor-mercad  =    0
           docum-est.valor-outras  =    0
           docum-est.vl-subs       =    0
           docum-est.tot-valor     =    0.

    FOR EACH item-doc-est OF docum-est NO-LOCK:
        RUN pi-acompanhar IN h-acomp (INPUT "Recalculando item: " + item-doc-est.it-codigo).
        
        ASSIGN docum-est.base-icm = docum-est.base-icm
                                  +  (item-doc-est.base-icm[1]
                                  *  int(((item-doc-est.cd-trib-icm = 1 /*T*/)   or
                                          (item-doc-est.cd-trib-icm = 4 /*R*/)   or
                                          (item-doc-est.cd-trib-icm = 5 /*D*/)))
                                                    /**** int(can-do(1,4,5 /*"T,R,D"*/, item-doc-est.cd-trib-icm)) ***/
                                  +  (item-doc-est.icm-outras[1]
                                  *  int(item-doc-est.cd-trib-icm = 3 /*"O"*/))).

        ASSIGN docum-est.base-ipi = docum-est.base-ipi 
                                  +  (item-doc-est.base-ipi[1] 
                                  *  int(((item-doc-est.cd-trib-ipi = 1 /*T*/)   or
                                          (item-doc-est.cd-trib-ipi = 4 /*R*/)))
                                  +  (item-doc-est.ipi-outras[1]
                                  *  int(item-doc-est.cd-trib-ipi = 3 /*O*/
                                      or(item-doc-est.cd-trib-ipi = 1 /*T*/      
                                     and item-doc-est.aliquota-ipi = 0 )))).

         ASSIGN docum-est.base-subs     = docum-est.base-subs    + item-doc-est.base-subs[1]
                docum-est.despesa-nota  = docum-est.despesa-nota + item-doc-est.despesas[1]
                docum-est.icm-complem   = docum-est.icm-complem  + item-doc-est.icm-complem[1]
                docum-est.icm-deb-cre   = docum-est.icm-deb-cre  + item-doc-est.valor-icm[1]
                docum-est.ipi-deb-cre   = docum-est.ipi-deb-cre  + item-doc-est.valor-ipi[1]
                docum-est.ipi-outras    = docum-est.ipi-outras   +  item-doc-est.ipi-outras[1] *  INT(item-doc-est.cd-trib-ipi = 3)
                docum-est.tot-desconto  = docum-est.tot-desconto + item-doc-est.desconto[1]
                docum-est.tot-peso      = docum-est.tot-peso     + item-doc-est.peso-liquido
                docum-est.valor-mercad  = docum-est.valor-mercad + item-doc-est.preco-total[1]
                docum-est.valor-outras  = docum-est.despesa-nota 
                docum-est.vl-subs       = docum-est.vl-subs      + item-doc-est.vl-subs[1].

          ASSIGN docum-est.tot-valor = docum-est.tot-valor 
                                     + item-doc-est.valor-ipi[1]
                                     + item-doc-est.preco-total[1]
                                     + item-doc-est.despesas[1]
                                     - item-doc-est.desconto[1]
                                     + item-doc-est.vl-pis-subs
                                     + item-doc-est.vl-cofins-subs. 
    END.
END PROCEDURE.

PROCEDURE pi-totaliza-documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN gotokey IN h-boin176 (INPUT  item-doc-est.serie-docto,
                              INPUT  item-doc-est.nro-docto, 
                              INPUT  item-doc-est.cod-emitente, 
                              INPUT  item-doc-est.nat-operacao, 
                              INPUT  item-doc-est.sequencia).

    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN pi-erro-nota (INPUT 17006,
                          INPUT "Item n∆o encontrado").
        RETURN "NOK":U.
    END.

    RUN setDocumEst IN h-boin176.

    RUN recalculateImposto IN h-boin176 ( INPUT item-doc-est.qt-do-forn,
                                          INPUT item-doc-est.preco-unit[1],
                                          INPUT item-doc-est.preco-total[1],
                                          INPUT item-doc-est.desconto[1],
                                          INPUT item-doc-est.despesas[1],
                                          INPUT item-doc-est.pr-total-cmi,
                                          INPUT item-doc-est.peso-liquido,
                                          INPUT dec(substring(item-doc-est.char-2,819,13)),
                                          INPUT item-doc-est.aliquota-ipi,
                                          INPUT item-doc-est.cd-trib-ipi,
                                          INPUT item-doc-est.aliquota-iss,
                                          INPUT item-doc-est.cd-trib-iss,
                                          INPUT item-doc-est.aliquota-icm,
                                          INPUT item-doc-est.cd-trib-icm,
                                          input IF item-doc-est.val-perc-rep-ipi <> 0 THEN STRING(item-doc-est.val-perc-rep-ipi) ELSE string(dec(substring(item-doc-est.char-2,1,6)) / 10000), /* perc ipi */
                                          input IF item-doc-est.val-perc-red-icms <> 0 THEN STRING(item-doc-est.val-perc-red-icms) ELSE string(dec(substring(item-doc-est.char-2,7,6)) / 10000), /* perc icm */
                                          INPUT item-doc-est.log-2,
                                          INPUT item-doc-est.idi-tributac-pis,
                                          INPUT item-doc-est.val-aliq-pis,
                                          INPUT item-doc-est.idi-tributac-cofins,
                                          INPUT item-doc-est.val-aliq-cofins,
                                          INPUT YES ).


    RUN getDecField IN h-boin176 ( INPUT "ipi-ntrib[1]":U, OUTPUT c-desc-aux ).
    ASSIGN item-doc-est.ipi-ntrib[1] = DEC(c-desc-aux).

    RUN getDecField IN h-boin176 ( INPUT "ipi-outras[1]":U, OUTPUT c-desc-aux ).
    ASSIGN item-doc-est.ipi-outras[1] = DEC(c-desc-aux).

    RUN getDecField IN h-boin176 ( INPUT "base-ipi[1]":U, OUTPUT c-desc-aux ).
    ASSIGN item-doc-est.base-ipi[1] = DEC(c-desc-aux).
    
    RUN getDecField IN h-boin176 ( INPUT "valor-ipi[1]":U, OUTPUT c-desc-aux ).
    ASSIGN item-doc-est.valor-ipi[1] = DEC(c-desc-aux).
    
    RUN getDecField IN h-boin176 ( INPUT "preco-unit[1]":U, OUTPUT c-desc-aux ).
    ASSIGN item-doc-est.preco-unit[1] = DEC(c-desc-aux).

    RUN getDecField IN h-boin176 ( INPUT "pr-total-cmi":U, OUTPUT c-desc-aux ).
    ASSIGN item-doc-est.pr-total-cmi = DEC(c-desc-aux).

    RUN getDecField IN h-boin176 ( INPUT "despesas[1]":U, OUTPUT c-desc-aux ).
    ASSIGN item-doc-est.despesas[1] = DEC(c-desc-aux).

    RUN getDecField IN h-boin176 ( INPUT "base-iss[1]":U, OUTPUT c-desc-aux ).
    ASSIGN item-doc-est.base-iss[1] = DEC(c-desc-aux).

    RUN getDecField IN h-boin176 ( INPUT "valor-iss[1]":U, OUTPUT c-desc-aux ).
    ASSIGN item-doc-est.valor-iss[1] = DEC(c-desc-aux).

    RUN getDecField IN h-boin176 ( INPUT "iss-ntrib[1]":U, OUTPUT c-desc-aux ).
    ASSIGN item-doc-est.iss-ntrib[1] = DEC(c-desc-aux).

    RUN getDecField IN h-boin176 ( INPUT "iss-outras[1]":U, OUTPUT c-desc-aux ).
    ASSIGN item-doc-est.iss-outras[1] = DEC(c-desc-aux).
    RUN recalculateImposto IN h-boin176 ( INPUT item-doc-est.qt-do-forn, 
                                          INPUT item-doc-est.preco-unit[1], 
                                          INPUT item-doc-est.preco-total[1],
                                          INPUT item-doc-est.desconto[1],
                                          INPUT item-doc-est.despesas[1],
                                          INPUT item-doc-est.pr-total-cmi,
                                          INPUT item-doc-est.peso-liquido,
                                          INPUT dec(substring(item-doc-est.char-2,819,13)),
                                          INPUT item-doc-est.aliquota-ipi,
                                          INPUT item-doc-est.cd-trib-ipi,
                                          INPUT item-doc-est.aliquota-iss,
                                          INPUT item-doc-est.cd-trib-iss,
                                          INPUT item-doc-est.aliquota-icm,
                                          INPUT item-doc-est.cd-trib-icm,
                                          input IF item-doc-est.val-perc-rep-ipi <> 0 THEN STRING(item-doc-est.val-perc-rep-ipi) ELSE string(dec(substring(item-doc-est.char-2,1,6)) / 10000), /* perc ipi */
                                          input IF item-doc-est.val-perc-red-icms <> 0 THEN STRING(item-doc-est.val-perc-red-icms) ELSE string(dec(substring(item-doc-est.char-2,7,6)) / 10000), /* perc icm */
                                          INPUT item-doc-est.log-2,
                                          INPUT item-doc-est.idi-tributac-pis,
                                          INPUT item-doc-est.val-aliq-pis,
                                          INPUT item-doc-est.idi-tributac-cofins,
                                          INPUT item-doc-est.val-aliq-cofins,
                                          INPUT NO ).
           
    RUN getDecField IN h-boin176 ( INPUT "val-base-calc-cofins":U, OUTPUT c-desc-aux ).
    ASSIGN item-doc-est.val-base-calc-cofins = DEC(c-desc-aux).

    RUN getDecField IN h-boin176 ( INPUT "valor-pis":U, OUTPUT c-desc-aux ).
    ASSIGN  item-doc-est.valor-pis = DEC(c-desc-aux).

    RUN getDecField IN h-boin176 ( INPUT "base-pis":U, OUTPUT c-desc-aux ).
    ASSIGN  item-doc-est.base-pis = DEC(c-desc-aux).

    RUN getDecField IN h-boin176 ( INPUT "val-cofins":U, OUTPUT c-desc-aux ).
    ASSIGN item-doc-est.val-cofins = DEC(c-desc-aux).
END PROCEDURE.
