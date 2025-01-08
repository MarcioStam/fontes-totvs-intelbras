
def input        param rw-nota-fiscal   as rowid   no-undo.
def input        param i-tipo-movto     as integer no-undo.
def input        param da-dt-saida      as date    no-undo.
def input-output param l-rejeita-nota   as logical no-undo.

DEF NEW GLOBAL SHARED VAR l-imprime-notas-exito-ft2100 AS LOGICAL NO-UNDO.
DEF NEW GLOBAL SHARED var l-imprime-ft2100             AS LOGICAL NO-UNDO.
DEF NEW GLOBAL SHARED TEMP-TABLE tt-it-nota-fis-ft2100 NO-UNDO
                       FIELD nr-seq-fat  LIKE it-nota-fisc.nr-seq-fat
                       FIELD it-codigo   LIKE fat-ser-lote.it-codigo
                       FIELD cod-refer   AS CHAR
                       FIELD cod-depos   LIKE fat-ser-lote.cod-depos
                       FIELD cod-localiz LIKE fat-ser-lote.cod-localiz
                       FIELD nr-serlote  LIKE fat-ser-lote.nr-serlote
                       FIELD qt-baixada  LIKE fat-ser-lote.qt-baixada[1].

{cdp/cd0666.i}              /* Definiá∆o TT-ERRO */
{method/dbotterr.i}
/* {ftp/ft2100.i1}             /* Definiá∆o Vari†vel Impress∆o */ */
DEFINE VARIABLE c-desc-aux AS CHARACTER   NO-UNDO.
def var aux-c-char    as char extent 50 no-undo.
def var aux-i-cont    as int            no-undo.
def var aux-i-num-var as int extent 2   no-undo.
def var aux-i-tamanho as int extent 2   no-undo.                /* Variaveis para CD4300.I4         */
def var l-ipi-bicms    as log form "Sim/Nao"       no-undo.
def var l-frete-bipi   as log form "Sim/Nao"       no-undo.
def var l-ind-bipi     as log form "Bruto/Liquido" no-undo.
def var l-ipi-tot-nota as log form "Sim/Nao"       no-undo.
def var l-ind-biss     as log form "Bruto/Liquido" no-undo.
def var c-modelo-cupom-fiscal as char no-undo format "x(2)".
def var l-atu-cota     as log form "Sim/N∆o"       no-undo.
DEF VAR l-imp-dt-emis  AS LOG NO-UNDO.
DEF VAR c-serie        AS CHARACTER                NO-UNDO.
DEF VAR raw-param2     AS RAW                      NO-UNDO.
DEF VAR h-pdapi002     AS HANDLE                   NO-UNDO.
DEF VAR l-processo-esftp079 AS LOGICAL             NO-UNDO.
DEF VAR c-cod-depos    AS CHARACTER                NO-UNDO.
DEF VAR i-nr-pedido    AS INTEGER  INITIAL 0       NO-UNDO.
DEF VAR l-erro         AS LOGICAL                  NO-UNDO.
DEF VAR l-log          AS LOGICAL  INITIAL NO      NO-UNDO.

DEFINE VARIABLE de-aliq-pis     AS DECIMAL  format ">9,99"   NO-UNDO.
DEFINE VARIABLE de-aliq-cofins  AS DECIMAL  format ">9,99"   NO-UNDO.

assign aux-i-num-var[1] = 7     /* Sempre que for criada uma nova variavel nesse */
                                /* programa, devera  ser  acrescentado  um  para */ 
                                /* essa variavel.                                */
       aux-i-tamanho[1] = 5.    /* Variaveis para CD0604                         */
{cdp/cdcfgman.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}
{cdp/cdcfgcex.i}
{utp/ut-glob.i}


DEF BUFFER b-estabelec  FOR estabelec.
DEF BUFFER b-natur-oper FOR natur-oper.
DEF BUFFER b-docum-est  FOR docum-est.
    DEF VAR h-boin176 AS HANDLE NO-UNDO.
    DEF VAR h-boin090 AS HANDLE NO-UNDO.
/*
&if "{&bf_dis_versao_ems}" >= "2.062" &then
    {inbo/boin176.i4 tt-item-devol-cli} /* tt-item-devol-cli */
&endif
*/
/*     def temp-table tt-item-devol-cli no-undo                           */
/*         field rw-it-nota-fisc   as rowid                               */
/*         field quant-devol       like item-doc-est.quantidade           */
/*         field preco-devol       like item-doc-est.preco-total extent 0 */
/*         field cod-depos         like item-doc-est.cod-depos            */
/*         field reabre-pd         like item-doc-est.reabre-pd            */
/*         field vl-desconto       like item-doc-est.pr-total-cmi.        */

{inbo/boin176.i4 tt-item-devol-cli } /* DefiniÓ“o tt-item-devol-cli */
  
def buffer b-estab for estabelec.

def var c-estab    like estabelec.cod-estabel     no-undo.
def var i-retorno  as integer                     no-undo.
def var i-emp-prin like param-global.empresa-prin no-undo.
DEF VAR r-row-id-docum-est AS ROWID NO-UNDO.

/* Temp-tables usadas na atualizacao do documento (RE1005) */
define temp-table tt-param2
    field destino            as integer
    field arquivo            as char
    field usuario            as char
    field data-exec          as date
    field hora-exec          as integer
    field classifica         as integer
    field c-cod-estabel-ini  as char
    field c-cod-estabel-fim  as char
    field i-cod-emitente-ini as integer
    field i-cod-emitente-fim as integer
    field c-nro-docto-ini    as char
    field c-nro-docto-fim    as char
    field c-serie-docto-ini  as char
    field c-serie-docto-fim  as char
    field c-nat-operacao-ini as char
    field c-nat-operacao-fim as char
    field da-dt-trans-ini    as date
    field da-dt-trans-fim    as date.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

DEFINE TEMP-TABLE tt-digita
    FIELD r-docum-est AS ROWID.

DEFINE TEMP-TABLE tt-erros NO-UNDO
    FIELD nome-abrev       LIKE ped-item.nome-abrev
    FIELD nr-pedcli        LIKE ped-item.nr-pedcli
    FIELD it-codigo        LIKE ped-item.it-codigo
    FIELD mensagem         AS   CHARACTER FORMAT "x(85)".

DEFINE TEMP-TABLE tt-docum-est NO-UNDO LIKE movind.docum-est
       field r-Rowid as rowid.

/****************** B L O C O        P R I N C I P A L *****************/
ASSIGN l-log = NO.

RUN pi-cria-itens-docto.

/****************** P R O C E D U R E S              I N T E R N A S   *****************/
Procedure pi-cria-docum-via-bo:

    IF NOT VALID-HANDLE(h-boin090) THEN
    run inbo/boin090.p persistent set h-boin090.
    
    RUN emptyRowErrors IN h-boin090.
    EMPTY TEMP-TABLE tt-docum-est.

    find first estabelec
        where estabelec.cod-emitente = nota-fiscal.cod-emitente     no-lock no-error.

    FIND b-estabelec
         WHERE b-estabelec.cod-estabel = nota-fiscal.cod-estabel
         NO-LOCK NO-ERROR.

    FIND FIRST b-natur-oper NO-LOCK
         WHERE b-natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.        

    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = b-natur-oper.nat-comp NO-ERROR.

    ASSIGN c-serie = IF nota-fiscal.serie = "1." THEN "1" ELSE nota-fiscal.serie.

    find FIRST docum-est
        where docum-est.cod-emitente = b-estabelec.cod-emitente
          and docum-est.serie-docto  = c-serie
          and docum-est.nat-operacao = natur-oper.nat-operacao
          and docum-est.nro-docto    = nota-fiscal.nr-nota-fis exclusive-lock no-error.

    if avail docum-est then do:
        IF docum-est.CE-atual = NO THEN RETURN.
        ELSE DO:
            /*15530 - erro n∆o pode atualizar*/

            RUN imprime-cabec-nota.
            run pi-erro-nota (input 15530,
                              input natur-oper.nat-operacao).
            return.

        END.
    end.
    if  yes then do  aux-i-cont = 1 to aux-i-num-var[1]:
        assign aux-c-char[aux-i-cont] =
                   substr( natur-oper.char-2,
                           aux-i-tamanho[1] * (aux-i-cont - 1) + 1,
                           aux-i-tamanho[1]).
    end.

    /* Grava os conteudos de aux-c-char para variavel */
    else do  aux-i-cont = 1 to aux-i-num-var[1]:
        assign substr( natur-oper.char-2,
                       aux-i-tamanho[1] * (aux-i-cont - 1) + 1,
                       aux-i-tamanho[1]) =
             substr(string(aux-c-char[aux-i-cont], "x(50)"), 1, aux-i-tamanho[1]).
    END.

    assign l-ipi-bicms           = aux-c-char[1] = "1"
           l-frete-bipi          = aux-c-char[2] = "1"
           l-ind-bipi            = aux-c-char[3] = "1"
           l-ipi-tot-nota        = aux-c-char[4] = "1"
           l-ind-biss            = aux-c-char[5] = "1"
           c-modelo-cupom-fiscal = aux-c-char[6]
           l-atu-cota            = aux-c-char[7] = "1".



    find transporte
        where transporte.nome-abrev = nota-fiscal.nome-transp       no-lock no-error.

    FIND estab-mat NO-LOCK
        WHERE estab-mat.cod-estabel = estabelec.cod-estabel NO-ERROR.

    create tt-docum-est.
    assign
        tt-docum-est.cod-emitente  = b-estabelec.cod-emitente
        tt-docum-est.cod-estabel   = estabelec.cod-estabel
        tt-docum-est.cod-observa   = if natur-oper.log-2 then 2 else 1 /*natur-oper.log-2 = nota de comercio*/
        tt-docum-est.conta-transit = estab-mat.cod-cta-transf-unif + estab-mat.cod-ccusto-transf-unif
        tt-docum-est.ct-transit    = estab-mat.cod-cta-transf-unif
        tt-docum-est.sc-transit    = estab-mat.cod-ccusto-transf-unif
        tt-docum-est.dt-emissao    = nota-fiscal.dt-emis-nota
        tt-docum-est.dt-trans      = if  da-dt-saida <> ?
                                      then da-dt-saida
                                      else nota-fiscal.dt-emis-nota
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
        tt-docum-est.usuario       = nota-fiscal.user-calc
        tt-docum-est.via-transp    = if avail transporte then
                                     transporte.via-transp
                                  else 1
        tt-docum-est.sit-atual     = 2
        tt-docum-est.cod-chave-aces-nf-eletro = nota-fiscal.cod-chave-aces-nf-eletro
        OVERLAY(tt-docum-est.char-2,143,8) = "0".

    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
        FIND emitente
            WHERE emitente.cod-emitente = tt-docum-est.cod-emitente NO-LOCK NO-ERROR.
        FIND loc-entr
             WHERE loc-entr.nome-abrev = emitente.nome-abrev
               AND loc-entr.cod-entrega = "Padrao" NO-LOCK NO-ERROR.
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
        ELSE
            ASSIGN tt-docum-est.cod-entrega = nota-fiscal.cod-entrega
                   tt-docum-est.endereco    = nota-fiscal.endereco
                   tt-docum-est.bairro      = nota-fiscal.bairro
                   tt-docum-est.cep         = nota-fiscal.cep
                   tt-docum-est.cidade      = nota-fiscal.cidade
                   tt-docum-est.uf          = nota-fiscal.estado
                   tt-docum-est.pais        = nota-fiscal.pais
                   tt-docum-est.log-consid-ender-nf-saida = YES.
    &endif

    &if  defined(bf_mat_conta_estab) &then
        find first b-estab
             where b-estab.cod-estabel = tt-docum-est.cod-estabel no-lock no-error.

        for first estab-mat
            where estab-mat.cod-estabel = b-estab.cod-estabel no-lock: end.

        if  avail estab-mat then do:
            assign tt-docum-est.conta-transit = estab-mat.cod-cta-transf-unif + estab-mat.cod-ccusto-transf-unif
                   tt-docum-est.ct-transit    = estab-mat.cod-cta-transf-unif
                   tt-docum-est.sc-transit    = estab-mat.cod-ccusto-transf-unif.
        end.
    &endif
    assign  tt-docum-est.base-icm      =    0
            tt-docum-est.base-ipi      =    0
            tt-docum-est.base-subs     =    0
            tt-docum-est.despesa-nota  =    0
            tt-docum-est.icm-complem   =    0
            tt-docum-est.icm-deb-cre   =    0
            tt-docum-est.ipi-deb-cre   =    0
            tt-docum-est.ipi-outras    =    0
            tt-docum-est.tot-desconto  =    0
            tt-docum-est.tot-peso      =    0
            tt-docum-est.valor-mercad  =    0
            tt-docum-est.valor-outras  =    0
            tt-docum-est.vl-subs       =    0
            tt-docum-est.tot-valor     =    0.

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
    END.

    RETURN "OK".

End Procedure. /*pi-gera-docum-est*/

/* Procedure pi-gera-docum-est:                                                                                   */
/*     find first estabelec                                                                                       */
/*         where estabelec.cod-emitente = nota-fiscal.cod-emitente     no-lock no-error.                          */
/*                                                                                                                */
/*     FIND b-estabelec                                                                                           */
/*          WHERE b-estabelec.cod-estabel = nota-fiscal.cod-estabel                                               */
/*          NO-LOCK NO-ERROR.                                                                                     */
/*                                                                                                                */
/*     find b-natur-oper                                                                                          */
/*         where b-natur-oper.nat-operacao = it-nota-fisc.nat-operacao   no-lock no-error.                        */
/*                                                                                                                */
/*     FIND natur-oper                                                                                            */
/*          WHERE natur-oper.nat-operacao = b-natur-oper.nat-comp                                                 */
/*          NO-LOCK NO-ERROR.                                                                                     */
/*                                                                                                                */
/*     ASSIGN c-serie = IF nota-fiscal.serie = "1." THEN "1" ELSE nota-fiscal.serie.                              */
/*                                                                                                                */
/*     find docum-est                                                                                             */
/*         where docum-est.cod-emitente = b-estabelec.cod-emitente                                                */
/*           and docum-est.serie-docto  = c-serie                                                                 */
/*           and docum-est.nat-operacao = natur-oper.nat-operacao                                                 */
/*           and docum-est.nro-docto    = nota-fiscal.nr-nota-fis exclusive-lock no-error.                        */
/*                                                                                                                */
/*                                                                                                                */
/*     if avail docum-est then do:                                                                                */
/*         IF docum-est.CE-atual = NO THEN RETURN.                                                                */
/*         ELSE DO:                                                                                               */
/*             /*15530 - erro n∆o pode atualizar*/                                                                */
/*                                                                                                                */
/*             RUN imprime-cabec-nota.                                                                            */
/*             run pi-erro-nota (input 15530,                                                                     */
/*                               input natur-oper.nat-operacao).                                                  */
/*             return.                                                                                            */
/*                                                                                                                */
/*         END.                                                                                                   */
/*     end.                                                                                                       */
/*     if  yes then do  aux-i-cont = 1 to aux-i-num-var[1]:                                                       */
/*         assign aux-c-char[aux-i-cont] =                                                                        */
/*                    substr( natur-oper.char-2,                                                                  */
/*                            aux-i-tamanho[1] * (aux-i-cont - 1) + 1,                                            */
/*                            aux-i-tamanho[1]).                                                                  */
/*     end.                                                                                                       */
/*                                                                                                                */
/*     /* Grava os conteudos de aux-c-char para variavel */                                                       */
/*     else do  aux-i-cont = 1 to aux-i-num-var[1]:                                                               */
/*         assign substr( natur-oper.char-2,                                                                      */
/*                        aux-i-tamanho[1] * (aux-i-cont - 1) + 1,                                                */
/*                        aux-i-tamanho[1]) =                                                                     */
/*              substr(string(aux-c-char[aux-i-cont], "x(50)"), 1, aux-i-tamanho[1]).                             */
/*     END.                                                                                                       */
/*                                                                                                                */
/*     assign l-ipi-bicms           = aux-c-char[1] = "1"                                                         */
/*            l-frete-bipi          = aux-c-char[2] = "1"                                                         */
/*            l-ind-bipi            = aux-c-char[3] = "1"                                                         */
/*            l-ipi-tot-nota        = aux-c-char[4] = "1"                                                         */
/*            l-ind-biss            = aux-c-char[5] = "1"                                                         */
/*            c-modelo-cupom-fiscal = aux-c-char[6]                                                               */
/*            l-atu-cota            = aux-c-char[7] = "1".                                                        */
/*                                                                                                                */
/*                                                                                                                */
/*                                                                                                                */
/*     find transporte                                                                                            */
/*         where transporte.nome-abrev = nota-fiscal.nome-transp       no-lock no-error.                          */
/*                                                                                                                */
/*     FIND estab-mat NO-LOCK                                                                                     */
/*         WHERE estab-mat.cod-estabel = estabelec.cod-estabel NO-ERROR.                                          */
/*                                                                                                                */
/*     create docum-est.                                                                                          */
/*     assign                                                                                                     */
/*         docum-est.cod-emitente  = b-estabelec.cod-emitente                                                     */
/*         docum-est.cod-estabel   = estabelec.cod-estabel                                                        */
/*         docum-est.cod-observa   = if natur-oper.log-2 then 2 else 1 /*natur-oper.log-2 = nota de comercio*/    */
/*         docum-est.conta-transit = estab-mat.cod-cta-transf-unif + estab-mat.cod-ccusto-transf-unif             */
/*         docum-est.ct-transit    = estab-mat.cod-cta-transf-unif                                                */
/*         docum-est.sc-transit    = estab-mat.cod-ccusto-transf-unif                                             */
/*         docum-est.dt-emissao    = nota-fiscal.dt-emis-nota                                                     */
/*         docum-est.dt-trans      = if  da-dt-saida <> ?                                                         */
/*                                       then da-dt-saida                                                         */
/*                                       else nota-fiscal.dt-emis-nota                                            */
/*         docum-est.dt-venc-icm   = docum-est.dt-trans                                                           */
/*         docum-est.dt-venc-ipi   = docum-est.dt-trans                                                           */
/*         docum-est.esp-docto     = 23 /*NFT*/                                                                   */
/*         docum-est.estab-de-or   = nota-fiscal.cod-estabel                                                      */
/*         docum-est.estab-fisc    = estabelec.cod-estabel                                                        */
/*         docum-est.nat-operacao  = natur-oper.nat-operacao                                                      */
/*         docum-est.nro-docto     = nota-fiscal.nr-nota-fis                                                      */
/*         docum-est.observacao    = nota-fiscal.observ-nota                                                      */
/*         docum-est.pais-origem   = "RE1001"                                                                     */
/*         docum-est.serie-docto   = c-serie                                                                      */
/*         docum-est.tipo-docto    = natur-oper.tipo                                                              */
/*         docum-est.uf            = nota-fiscal.estado /*nota-fiscal.uf*/                                        */
/*         docum-est.usuario       = nota-fiscal.user-calc                                                        */
/*         docum-est.via-transp    = if avail transporte then                                                     */
/*                                      transporte.via-transp                                                     */
/*                                   else 1                                                                       */
/*         docum-est.sit-atual     = 2                                                                            */
/*         docum-est.cod-chave-aces-nf-eletro = nota-fiscal.cod-chave-aces-nf-eletro                              */
/*         OVERLAY(docum-est.char-2,143,8) = "0".                                                                 */
/*                                                                                                                */
/*     &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN                                                                */
/*         FIND emitente                                                                                          */
/*             WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.                             */
/*         FIND loc-entr                                                                                          */
/*              WHERE loc-entr.nome-abrev = emitente.nome-abrev                                                   */
/*                AND loc-entr.cod-entrega = "Padrao" NO-LOCK NO-ERROR.                                           */
/*         IF AVAIL loc-entr THEN DO:                                                                             */
/*             ASSIGN docum-est.cod-entrega = "Padrao"                                                            */
/*                    docum-est.endereco    = loc-entr.endereco                                                   */
/*                    docum-est.bairro      = loc-entr.bairro                                                     */
/*                    docum-est.cep         = loc-entr.cep                                                        */
/*                    docum-est.cidade      = loc-entr.cidade                                                     */
/*                    docum-est.uf          = loc-entr.estado                                                     */
/*                    docum-est.pais        = loc-entr.pais                                                       */
/*                    docum-est.log-consid-ender-nf-saida = YES.                                                  */
/*                                                                                                                */
/*         END.                                                                                                   */
/*         ELSE                                                                                                   */
/*             ASSIGN docum-est.cod-entrega = nota-fiscal.cod-entrega                                             */
/*                    docum-est.endereco    = nota-fiscal.endereco                                                */
/*                    docum-est.bairro      = nota-fiscal.bairro                                                  */
/*                    docum-est.cep         = nota-fiscal.cep                                                     */
/*                    docum-est.cidade      = nota-fiscal.cidade                                                  */
/*                    docum-est.uf          = nota-fiscal.estado                                                  */
/*                    docum-est.pais        = nota-fiscal.pais                                                    */
/*                    docum-est.log-consid-ender-nf-saida = YES.                                                  */
/*     &endif                                                                                                     */
/*                                                                                                                */
/*     &if  defined(bf_mat_conta_estab) &then                                                                     */
/*         find first b-estab                                                                                     */
/*              where b-estab.cod-estabel = docum-est.cod-estabel no-lock no-error.                               */
/*                                                                                                                */
/*         for first estab-mat                                                                                    */
/*             where estab-mat.cod-estabel = b-estab.cod-estabel no-lock: end.                                    */
/*                                                                                                                */
/*         if  avail estab-mat then do:                                                                           */
/*             assign docum-est.conta-transit = estab-mat.cod-cta-transf-unif + estab-mat.cod-ccusto-transf-unif  */
/*                    docum-est.ct-transit    = estab-mat.cod-cta-transf-unif                                     */
/*                    docum-est.sc-transit    = estab-mat.cod-ccusto-transf-unif.                                 */
/*         end.                                                                                                   */
/*     &endif                                                                                                     */
/*     assign   docum-est.base-icm      =    0                                                                    */
/*              docum-est.base-ipi      =    0                                                                    */
/*              docum-est.base-subs     =    0                                                                    */
/*              docum-est.despesa-nota  =    0                                                                    */
/*              docum-est.icm-complem   =    0                                                                    */
/*              docum-est.icm-deb-cre   =    0                                                                    */
/*              docum-est.ipi-deb-cre   =    0                                                                    */
/*              docum-est.ipi-outras    =    0                                                                    */
/*              docum-est.tot-desconto  =    0                                                                    */
/*              docum-est.tot-peso      =    0                                                                    */
/*              docum-est.valor-mercad  =    0                                                                    */
/*              docum-est.valor-outras  =    0                                                                    */
/*              docum-est.vl-subs       =    0                                                                    */
/*              docum-est.tot-valor     =    0.                                                                   */
/*                                                                                                                */
/*                                                                                                                */
/* End Procedure. /*pi-gera-docum-est*/                                                                           */


Procedure Pi-totaliza-documento:

        RUN gotokey IN h-boin176 (INPUT  item-doc-est.serie-docto,
                                      INPUT  item-doc-est.nro-docto,
                                      INPUT  item-doc-est.cod-emitente,
                                      INPUT  item-doc-est.nat-operacao,
                                  INPUT  item-doc-est.sequencia).
        IF RETURN-VALUE = "NOK":U THEN DO:
            MESSAGE "Nao achou Item "
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            NEXT.
        END.
        RUN setDocumEst IN h-boin176.

        /************
        Chamado TRW244
        run recalculateImposto in h-boin176 ( input item-doc-est.qt-do-forn,
                                      input item-doc-est.preco-total[1],
                                      input item-doc-est.desconto[1],
                                      input item-doc-est.despesas[1],
                                      input item-doc-est.pr-total-cmi,
                                      input item-doc-est.peso-liquido,
                                      INPUT dec(substring(item-doc-est.char-2,819,13)),
                                      input item-doc-est.aliquota-ipi,
                                      input item-doc-est.cd-trib-ipi,
                                      input item-doc-est.aliquota-iss,
                                      input item-doc-est.cd-trib-iss,
                                      input item-doc-est.aliquota-icm,
                                      input item-doc-est.cd-trib-icm,
                                      input IF item-doc-est.val-perc-rep-ipi <> 0 THEN STRING(item-doc-est.val-perc-rep-ipi) ELSE string(dec(substring(item-doc-est.char-2,1,6)) / 10000), /* perc ipi */
                                      input IF item-doc-est.val-perc-red-icms <> 0 THEN STRING(item-doc-est.val-perc-red-icms) ELSE string(dec(substring(item-doc-est.char-2,7,6)) / 10000), /* perc icm */
                                      input item-doc-est.log-2,
                                      input item-doc-est.idi-tributac-pis,
                                      input de-aliq-pis,
                                      input item-doc-est.idi-tributac-cofins,
                                      input de-aliq-cofins,
                                      input no).

        def input param piQuantidade like item-doc-est.quantidade no-undo.
        def input param piPrecoTotal like item-doc-est.preco-total[1] no-undo.
        def input param piDesconto like item-doc-est.desconto[1] no-undo.
        def input param piDespesa like item-doc-est.despesas[1] no-undo.
        def input param piFrete like item-doc-est.pr-total-cmi no-undo.
        def input param piPeso like item-doc-est.peso-liquido no-undo.
        def input param piPedagio as decimal no-undo.
        def input param piAliquotaIPI like item-doc-est.aliquota-ipi no-undo.
        def input param piTribIPI like item-doc-est.cd-trib-ipi no-undo.
        def input param piAliquotaISS like item-doc-est.aliquota-iss no-undo.
        def input param piTribISS like item-doc-est.cd-trib-iss no-undo.
        def input param piAliquotaICM like item-doc-est.aliquota-icm no-undo.
        def input param piTribICM like item-doc-est.cd-trib-icm no-undo.
        def input param pdePercIPI as dec no-undo.
        def input param pdePercICM as dec no-undo.
        def input param piICMRet like item-doc-est.log-2 no-undo.
        def input param piTribPIS as int no-undo.
        def input param piAliquotaPIS as dec format ">9,99" no-undo.
        def input param piTribCOFINS as int no-undo.
        def input param piAliquotaCOFINS as dec format ">9,99" no-undo.
        def input param piRecalcula as logical no-undo.                              

        ************/

        ASSIGN de-aliq-pis    = item-doc-est.val-aliq-pis
               de-aliq-cofins = item-doc-est.val-aliq-cofins .

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
                                              INPUT de-aliq-pis,
                                              input item-doc-est.idi-tributac-cofins,
                                              input de-aliq-cofins,
                                              input YES ).


        run getDecField in h-boin176 ( input "ipi-ntrib[1]":U, output c-desc-aux ).
        assign item-doc-est.ipi-ntrib[1] = DEC(c-desc-aux).

        run getDecField in h-boin176 ( input "ipi-outras[1]":U, output c-desc-aux ).
        assign item-doc-est.ipi-outras[1] = dec(c-desc-aux).

        run getDecField in h-boin176 ( input "base-ipi[1]":U, output c-desc-aux ).
        assign item-doc-est.base-ipi[1] = dec(c-desc-aux).

        run getDecField in h-boin176 ( input "valor-ipi[1]":U, output c-desc-aux ).
        assign item-doc-est.valor-ipi[1] = dec(c-desc-aux).

        run getDecField in h-boin176 ( input "preco-unit[1]":U, output c-desc-aux ).
        assign item-doc-est.preco-unit[1] = dec(c-desc-aux).

        run getDecField in h-boin176 ( input "pr-total-cmi":U, output c-desc-aux ).
        assign item-doc-est.pr-total-cmi = DEC(c-desc-aux).

        run getDecField in h-boin176 ( input "despesas[1]":U, output c-desc-aux ).
        assign item-doc-est.despesas[1] = dec(c-desc-aux).

        run getDecField in h-boin176 ( input "base-iss[1]":U, output c-desc-aux ).
        assign item-doc-est.base-iss[1] = dec(c-desc-aux).

        run getDecField in h-boin176 ( input "valor-iss[1]":U, output c-desc-aux ).
        assign item-doc-est.valor-iss[1] = dec(c-desc-aux).

        run getDecField in h-boin176 ( input "iss-ntrib[1]":U, output c-desc-aux ).
        assign item-doc-est.iss-ntrib[1] = dec(c-desc-aux).

        run getDecField in h-boin176 ( input "iss-outras[1]":U, output c-desc-aux ).
        assign item-doc-est.iss-outras[1] = dec(c-desc-aux).
/*         run recalculateImposto in h-boin176 ( input item-doc-est.qt-do-forn,                       */
/*                                               input item-doc-est.preco-total[1],                   */
/*                                               input item-doc-est.desconto[1],                      */
/*                                               input item-doc-est.despesas[1],                      */
/*                                               input item-doc-est.pr-total-cmi,                     */
/*                                               input item-doc-est.peso-liquido,                     */
/*                                               input item-doc-est.aliquota-ipi,                     */
/*                                               input item-doc-est.cd-trib-ipi,                      */
/*                                               input item-doc-est.aliquota-iss,                     */
/*                                               input item-doc-est.cd-trib-iss,                      */
/*                                               input item-doc-est.aliquota-icm,                     */
/*                                               input item-doc-est.cd-trib-icm,                      */
/*                                               input item-doc-est.val-perc-rep-ipi, /* perc ipi */  */
/*                                               input item-doc-est.val-perc-red-icms, /* perc icm */ */
/*                                               input item-doc-est.log-2,                            */
/*                                               input item-doc-est.idi-tributac-pis,                 */
/*                                               input item-doc-est.val-aliq-pis,                     */
/*                                               input item-doc-est.idi-tributac-cofins,              */
/*                                               input item-doc-est.val-aliq-cofins,                  */
/*                                               input NO ).                                          */

        run getDecField in h-boin176 ( input "val-base-calc-cofins":U, output c-desc-aux ).
        assign item-doc-est.val-base-calc-cofins = dec(c-desc-aux).

        run getDecField in h-boin176 ( input "valor-pis":U, output c-desc-aux ).
        assign  item-doc-est.valor-pis = dec(c-desc-aux).

        run getDecField in h-boin176 ( input "base-pis":U, output c-desc-aux ).
        assign  item-doc-est.base-pis = dec(c-desc-aux).

        run getDecField in h-boin176 ( input "val-cofins":U, output c-desc-aux ).
        assign item-doc-est.val-cofins = dec(c-desc-aux).




            run pi-total-nota.

End Procedure. /*Pi-totaliza-documento*/


Procedure Pi-total-nota:
    def var de-tot-valor like docum-est.tot-valor.


/*     /* Calcula total da nota */                                         */
/*     assign de-tot-valor  = docum-est.valor-mercad                       */
/*                          + docum-est.despesa-nota                       */
/*                          - docum-est.tot-desconto                       */
/*                          + docum-est.vl-subs.                           */
/*                                                                         */
/*     if  docum-est.cod-observa = 1 then do:                              */
/*                                                                         */
/*         /* IPI Tributado */                                             */
/*         IF  item-doc-est.cd-trib-ipi <> 3 THEN                          */
/*             assign de-tot-valor = de-tot-valor + docum-est.ipi-deb-cre. */
/*                                                                         */
/*         /* IPI Outros */                                                */
/*         IF  item-doc-est.cd-trib-ipi = 3 THEN                           */
/*             assign de-tot-valor = de-tot-valor                          */
/*                                   + docum-est.ipi-deb-cre               */
/*                                   * int(    l-ipi-tot-nota         or   */
/*                                        (not natur-oper.terceiros   and  */
/*                                         not natur-oper.transf)).        */
/*     end.                                                                */
/*                                                                         */
/*     if  de-tot-valor < 0 then                                           */
/*         assign docum-est.tot-valor = 0.                                 */
/*     else                                                                */
/*         assign docum-est.tot-valor = de-tot-valor.                      */

END PROCEDURE. /*Pi-total-nota*/


Procedure pi-erro-nota:
    def input parameter cod-mensag  as integer                      no-undo.
    def input parameter c-parametro as char                         no-undo.

    run utp/ut-msgs.p ( input "msg",
                        input cod-mensag,
                        input c-parametro ).

    create tt-erro.
    assign tt-erro.cd-erro  = cod-mensag
           tt-erro.mensagem = return-value
           l-rejeita-nota   = yes.

    put string(tt-erro.cd-erro,">>>>>9") at 11.
    put substring(tt-erro.mensagem,1,110) at 19 format "X(110)" skip.
    /* Controla mensagem maior que 110 caracteres */
    if length(right-trim(tt-erro.mensagem)) > 110 then
       put right-trim(substr(tt-erro.mensagem,111,110)) at 19 format "X(110)" skip.

End Procedure. /*pi-erro-nota*/

PROCEDURE pi-elimina-handle:
    IF VALID-HANDLE(h-boin176) THEN
        RUN destroy IN h-boin176.

    IF VALID-HANDLE(h-boin090) THEN
        RUN destroy IN h-boin090.

    IF VALID-HANDLE(h-pdapi002) THEN
        DELETE PROCEDURE h-pdapi002.

    ASSIGN h-boin176  = ?
           h-boin090  = ?
           h-pdapi002 = ?.
END PROCEDURE.

PROCEDURE pi-cria-itens-docto:
    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    
    /*
    IF  NOT VALID-HANDLE(h-boin176) THEN DO:
        RUN inbo/boin176.p PERSISTENT SET h-boin176.
        RUN openQueryStatic IN h-boin176 (INPUT "Main":U).
    END.
    
    IF  NOT VALID-HANDLE(h-boin090) THEN DO:
        RUN inbo/boin090.p PERSISTENT SET h-boin090.
        RUN openQueryStatic IN h-boin090 (INPUT "Main":U).
    END.
    */

    find nota-fiscal where rowid(nota-fiscal) = rw-nota-fiscal no-lock no-error.

    FIND FIRST natur-oper NO-LOCK
        WHERE  natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.

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

    
    IF  NOT VALID-HANDLE(h-pdapi002) THEN
        RUN pdp/pdapi002.p PERSISTENT SET h-pdapi002.
    
    
    
    /* Quando for Transferància */
    IF  natur-oper.especie-doc = "NFT" THEN DO:
    
        IF  NOT CAN-FIND(FIRST param-re NO-LOCK
                         WHERE param-re.usuario = c-seg-usuario) THEN DO:
            PUT UNFORMATTED SKIP "Usu†rio n∆o cadastrado nos ParÉmetros do Recebimento!".
            RUN pi-elimina-handle.
            RETURN "NOK":U.
        END.
    
        /* Executado pelo ESFTP079 */
        FIND FIRST ped-transf NO-LOCK
            WHERE  ped-transf.cod-estabel = nota-fiscal.cod-estabel
            AND    ped-transf.serie       = nota-fiscal.serie
            AND    ped-transf.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
        IF  AVAIL  ped-transf THEN
            ASSIGN c-cod-depos         = ped-transf.cod-depos-dest
                   l-processo-esftp079 = YES.
        ELSE
            ASSIGN c-cod-depos         = "alm"
                   l-processo-esftp079 = NO.
    
    
        FIND FIRST emitente NO-LOCK
            WHERE  emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.
    END.
    ELSE
        ASSIGN c-cod-depos         = "alm"
               l-processo-esftp079 = NO.
    
    /*RUN setHandleDocumEst IN h-boin176 (INPUT h-boin090).*/
    
    ASSIGN i-cont = 0.
    for each  it-nota-fisc of nota-fiscal no-lock:
        ASSIGN i-cont = i-cont + 1.
    END.
    IF i-cont > 40 THEN do:
        PUT "Nao Ç possivel criar documento de entrada utilize o bacas/cria-re1001.r" SKIP.
        RUN pi-elimina-handle.
        RETURN. /* ocorre problema de system error quando tem muitos itens devido transaá∆o muito grande */
    END.
    
    
    /* for each  it-nota-fisc of nota-fiscal no-lock                                                                                               */
    /*     break by it-nota-fisc.nat-operacao  /* GERA UMA NOTA NO RECEBIMENTO PARA CADA NATUREZA DO FATURAMENTO*/                                 */
    /*           by it-nota-fisc.nr-seq-fat:                                                                                                       */
    /*                                                                                                                                             */
    /*                                                                                                                                             */
    /*     DO TRANS:                                                                                                                               */
    /*                                                                                                                                             */
    /*                                                                                                                                             */
    /*         IF  NOT CAN-FIND(FIRST item-uni-estab NO-LOCK                                                                                       */
    /*                          WHERE item-uni-estab.cod-estabel = nota-fiscal.cod-estabel                                                         */
    /*                          AND   item-uni-estab.it-codigo   = it-nota-fisc.it-codigo) THEN DO:                                                */
    /*             ASSIGN l-erro = YES.                                                                                                            */
    /*             PUT UNFORMATTED "Item (" it-nota-fisc.it-codigo ") n∆o relacionado com o Estabelecimento (" nota-fiscal.cod-estabel ")!".       */
    /*         END.                                                                                                                                */
    /*                                                                                                                                             */
    /*         if first-of(it-nota-fisc.nat-operacao) then do:                                                                                     */
    /*             run pi-gera-docum-est.      /*cria o docum-est temporariamente para gerar o log p/ multiplanta*/                                */
    /*                                                                                                                                             */
    /*             if l-rejeita-nota then DO:                                                                                                      */
    /*                 FOR EACH tt-erro:                                                                                                           */
    /*                     PUT "Erro durante Criacao da nota de Entrada " tt-erro.cd-erro  " " tt-erro.mensagem  SKIP.                             */
    /*                 END.                                                                                                                        */
    /*                 RUN pi-elimina-handle.                                                                                                      */
    /*                 return.                                                                                                                     */
    /*             END.                                                                                                                            */
    /*             &if "{&bf_dis_versao_ems}" >= "2.062" &then                                                                                     */
    /*                 RUN goToKey IN h-boin090 (INPUT docum-est.serie-docto,                                                                      */
    /*                                           INPUT docum-est.nro-docto,                                                                        */
    /*                                           INPUT docum-est.cod-emitente,                                                                     */
    /*                                           INPUT docum-est.nat-operacao).                                                                    */
    /*             &ENDIF                                                                                                                          */
    /*         end.                                                                                                                                */
    /*                                                                                                                                             */
    /*         /*** A partir da release 2.06B, passa a criar os registros item-doc-est atravÇs da BO ***/                                          */
    /*         &if "{&bf_dis_versao_ems}" >= "2.062" &then                                                                                         */
    /*                                                                                                                                             */
    /*             EMPTY TEMP-TABLE tt-item-devol-cli.                                                                                             */
    /*             CREATE tt-item-devol-cli.                                                                                                       */
    /*             ASSIGN tt-item-devol-cli.rw-it-nota-fisc = ROWID(it-nota-fisc)                                                                  */
    /*                    /*                                                                                                                       */
    /*                    tt-item-devol-cli.nat-of          = it-nota-fisc.nat-operacao                                                            */
    /*                    */                                                                                                                       */
    /*                    tt-item-devol-cli.quant-devol     = it-nota-fisc.qt-faturada[1]                                                          */
    /*                    tt-item-devol-cli.preco-devol     = it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[1]. /* item-doc-est.qt-do-forn. */ */
    /*                                                                                                                                             */
    /*             RUN createItemOfNotaFiscal IN h-boin176 (INPUT h-boin090,                                                                       */
    /*                                                      INPUT TABLE tt-item-devol-cli).                                                        */
    /*                                                                                                                                             */
    /*             IF RETURN-VALUE = "NOK" THEN DO:                                                                                                */
    /*                 RUN getRowErrors IN h-boin176 (OUTPUT TABLE RowErrors).                                                                     */
    /*                 FOR EACH rowErrors:                                                                                                         */
    /*                     PUT UNFORMATTED RowErrors.ErrorDescription SKIP.                                                                        */
    /*                 END.                                                                                                                        */
    /*                 ASSIGN l-erro = YES.                                                                                                        */
    /*             END.                                                                                                                            */
    /*                                                                                                                                             */
    /*             /*** Executa o openQuery da BO pra atualizar o registro inclu°do ***/                                                           */
    /*             RUN openQueryStatic IN h-boin176 (INPUT "OfDocumEst":U).                                                                        */
    /*         &ELSE                                                                                                                               */
    /*             /* Geraá∆o do item-doc-est e rat-lote a partir do it-nota-fisc */                                                               */
    /*             run cdp/cd4327.p (input rowid(docum-est),                                                                                       */
    /*                               input rowid(it-nota-fisc)).                                                                                   */
    /*         &ENDIF                                                                                                                              */
    /*                                                                                                                                             */
    /*         find item-doc-est                                                                                                                   */
    /*             where item-doc-est.cod-emitente = b-estabelec.cod-emitente                                                                      */
    /*               and item-doc-est.serie-docto  = c-serie                                                                                       */
    /*               and item-doc-est.nat-operacao = natur-oper.nat-operacao                                                                       */
    /*               and item-doc-est.nro-docto    = nota-fiscal.nr-nota-fis                                                                       */
    /*               and item-doc-est.it-codigo    = it-nota-fisc.it-codigo                                                                        */
    /*               and item-doc-est.seq-comp     = it-nota-fisc.nr-seq-fat exclusive-lock no-error.                                              */
    /*                                                                                                                                             */
    /*         assign item-doc-est.base-icm[1]    = it-nota-fisc.vl-bicms-it                                                                       */
    /*                item-doc-est.base-ipi[1]    = it-nota-fisc.vl-bipi-it                                                                        */
    /*                item-doc-est.base-iss[1]    = it-nota-fisc.vl-biss-it                                                                        */
    /*                item-doc-est.base-subs[1]   = it-nota-fisc.vl-bsubs-it                                                                       */
    /*                item-doc-est.icm-complem[1] = it-nota-fisc.vl-icmscomp-it                                                                    */
    /*                item-doc-est.icm-ntrib[1]   = it-nota-fisc.vl-icmsnt-it                                                                      */
    /*                item-doc-est.icm-outras[1] = it-nota-fisc.vl-icmsou-it                                                                       */
    /*                item-doc-est.ipi-ntrib[1]  = it-nota-fisc.vl-ipint-it                                                                        */
    /*                item-doc-est.ipi-outras[1] = it-nota-fisc.vl-ipiou-it                                                                        */
    /*                item-doc-est.iss-ntrib[1]  = it-nota-fisc.vl-issnt-it                                                                        */
    /*                item-doc-est.iss-outras[1] = it-nota-fisc.vl-issou-it                                                                        */
    /*                item-doc-est.valor-icm[1]  = it-nota-fisc.vl-icms-it                                                                         */
    /*                item-doc-est.valor-ipi[1]  = it-nota-fisc.vl-ipi-it                                                                          */
    /*                item-doc-est.valor-iss[1]  = it-nota-fisc.vl-iss-it                                                                          */
    /*                item-doc-est.vl-subs[1]    = it-nota-fisc.vl-icmsub-it                                                                       */
    /*                item-doc-est.despesas[1]   = it-nota-fisc.vl-despes-it                                                                       */
    /*                item-doc-est.pr-total-cmi  = it-nota-fisc.vl-frete-it.                                                                       */
    /*                                                                                                                                             */
    /*         /*PUT UNFORMATTED SKIP "****LOG-TESTE****" "Solitaá∆o (pedido): " i-nr-pedido " - Item: " item-doc-est.it-codigo.*/                 */
    /*          IF  l-processo-esftp079 = NO THEN                                                                                                  */
    /*              FIND FIRST fat-ser-lote NO-LOCK                                                                                                */
    /*                     WHERE  fat-ser-lote.cod-estabel  = it-nota-fisc.cod-estabel                                                             */
    /*                       AND  fat-ser-lote.serie        = it-nota-fisc.serie                                                                   */
    /*                       AND  fat-ser-lote.nr-nota-fis  = it-nota-fisc.nr-nota-fis                                                             */
    /*                       AND  fat-ser-lote.nr-seq-fat   = it-nota-fisc.nr-seq-fat                                                              */
    /*                       AND fat-ser-lote.it-codigo     = it-nota-fisc.it-codigo NO-ERROR.                                                     */
    /*                 IF  AVAIL  fat-ser-lote THEN                                                                                                */
    /*                     ASSIGN c-cod-depos = fat-ser-lote.cod-depos.                                                                            */
    /*                                                                                                                                             */
    /*         FOR EACH rat-lote OF item-doc-est:                                                                                                  */
    /*             ASSIGN rat-lote.cod-depos = c-cod-depos.                                                                                        */
    /*         END.                                                                                                                                */
    /*                                                                                                                                             */
    /*         /*  Tratamento do desconto do item */                                                                                               */
    /*         if  (  nota-fiscal.perc-desco1                                                                                                      */
    /*              + nota-fiscal.perc-desco2                                                                                                      */
    /*              + it-nota-fisc.per-des-item                                                                                                    */
    /*              + dec(substr(it-nota-fisc.char-1,1,14)) > 0)                                                                                   */
    /*         then                                                                                                                                */
    /*             assign item-doc-est.preco-unit[1]  = it-nota-fisc.vl-preori                                                                     */
    /*                    item-doc-est.preco-total[1] = it-nota-fisc.vl-merc-ori                                                                   */
    /*                    item-doc-est.desconto[1]    = it-nota-fisc.vl-merc-ori                                                                   */
    /*                                                - it-nota-fisc.vl-merc-liq                                                                   */
    /*                    item-doc-est.desconto[1]    = if  item-doc-est.desconto[1] < 0                                                           */
    /*                                                  then 0                                                                                     */
    /*                                                  else item-doc-est.desconto[1].                                                             */
    /*         else                                                                                                                                */
    /*             assign item-doc-est.preco-total[1] = it-nota-fisc.vl-merc-liq.                                                                  */
    /*                                                                                                                                             */
    /*         ASSIGN de-aliq-pis    = 0                                                                                                           */
    /*                de-aliq-cofins = 0.                                                                                                          */
    /*                                                                                                                                             */
    /*         run pi-totaliza-documento.                                                                                                          */
    /*     END.                                                                                                                                    */
    /* END.                                                                                                                                        */
    
    /* main_block:                                                                                                                       */
    /* DO TRANS:                                                                                                                         */
    /*                                                                                                                                   */
    /*     assign   docum-est.base-icm      =    0                                                                                       */
    /*              docum-est.base-ipi      =    0                                                                                       */
    /*              docum-est.base-subs     =    0                                                                                       */
    /*              docum-est.despesa-nota  =    0                                                                                       */
    /*              docum-est.icm-complem   =    0                                                                                       */
    /*              docum-est.icm-deb-cre   =    0                                                                                       */
    /*              docum-est.ipi-deb-cre   =    0                                                                                       */
    /*              docum-est.ipi-outras    =    0                                                                                       */
    /*              docum-est.tot-desconto  =    0                                                                                       */
    /*              docum-est.tot-peso      =    0                                                                                       */
    /*              docum-est.valor-mercad  =    0                                                                                       */
    /*              docum-est.valor-outras  =    0                                                                                       */
    /*              docum-est.vl-subs       =    0                                                                                       */
    /*              docum-est.tot-valor     =    0.                                                                                      */
    /*                                                                                                                                   */
    /*                                                                                                                                   */
    /*     FOR EACH item-doc-est OF docum-est NO-LOCK:                                                                                   */
    /*         ASSIGN  docum-est.base-icm      = docum-est.base-icm                                                                      */
    /*                                             +  (item-doc-est.base-icm[1]                                                          */
    /*                                             *  int(((item-doc-est.cd-trib-icm = 1 /*T*/)   or                                     */
    /*                                                     (item-doc-est.cd-trib-icm = 4 /*R*/)   or                                     */
    /*                                                     (item-doc-est.cd-trib-icm = 5 /*D*/)))                                        */
    /*                                                               /**** int(can-do(1,4,5 /*"T,R,D"*/, item-doc-est.cd-trib-icm)) ***/ */
    /*                                             +  (item-doc-est.icm-outras[1]                                                        */
    /*                                             *  int(item-doc-est.cd-trib-icm = 3 /*"O"*/))).                                       */
    /*                                                                                                                                   */
    /*         ASSIGN   docum-est.base-ipi     = docum-est.base-ipi                                                                      */
    /*                                +  (item-doc-est.base-ipi[1]                                                                       */
    /*                                *  int(((item-doc-est.cd-trib-ipi = 1 /*T*/)   or                                                  */
    /*                                        (item-doc-est.cd-trib-ipi = 4 /*R*/)))                                                     */
    /*                                   /**** int(can-do("T,R", item-doc-est.cd-trib-ipi)))****/                                        */
    /*                                +  (item-doc-est.ipi-outras[1]                                                                     */
    /*                                *  int(   item-doc-est.cd-trib-ipi = 3 /*O*/                                                       */
    /*                                       or (    item-doc-est.cd-trib-ipi = 1 /*T*/                                                  */
    /*                                           and item-doc-est.aliquota-ipi = 0 ) ))).                                                */
    /*                                                                                                                                   */
    /*                 /*docum-est.base-ipi      = docum-est.base-ipi                                                                    */
    /*                                             +  (item-doc-est.base-ipi[1]                                                          */
    /*                                             *  int(((item-doc-est.cd-trib-ipi = 1 /*T*/)   or                                     */
    /*                                                     (item-doc-est.cd-trib-ipi = 4 /*R*/)))                                        */
    /*                                                /**** int(can-do("T,R", item-doc-est.cd-trib-ipi)))****/                           */
    /*                                             +  (item-doc-est.ipi-outras[1]                                                        */
    /*                                             *  int(item-doc-est.cd-trib-ipi = 3 /*"O"*/)))                                        */
    /*                                                                                                                                   */
    /*                   */                                                                                                              */
    /*                                                                                                                                   */
    /*          ASSIGN docum-est.base-subs     = docum-est.base-subs       + item-doc-est.base-subs[1]                                   */
    /*                 docum-est.despesa-nota  = docum-est.despesa-nota    + item-doc-est.despesas[1]                                    */
    /*                 docum-est.icm-complem   = docum-est.icm-complem     + item-doc-est.icm-complem[1]                                 */
    /*                 docum-est.icm-deb-cre   = docum-est.icm-deb-cre     + item-doc-est.valor-icm[1]                                   */
    /*                 docum-est.ipi-deb-cre   = docum-est.ipi-deb-cre     + item-doc-est.valor-ipi[1]                                   */
    /*                 docum-est.ipi-outras    = docum-est.ipi-outras                                                                    */
    /*                                             +  item-doc-est.ipi-outras[1]                                                         */
    /*                                             *  int(item-doc-est.cd-trib-ipi = 3 /*"O"*/)                                          */
    /*                 docum-est.tot-desconto  = docum-est.tot-desconto    + item-doc-est.desconto[1]                                    */
    /*                 docum-est.tot-peso      = docum-est.tot-peso        + item-doc-est.peso-liquido                                   */
    /*                 docum-est.valor-mercad  = docum-est.valor-mercad    + item-doc-est.preco-total[1]                                 */
    /*                 docum-est.valor-outras  = docum-est.despesa-nota                                                                  */
    /*                 docum-est.vl-subs       = docum-est.vl-subs         + item-doc-est.vl-subs[1].                                    */
    /*                                                                                                                                   */
    /*                                                                                                                                   */
    /*          ASSIGN docum-est.tot-valor = docum-est.tot-valor +                                                                       */
    /*                                     + item-doc-est.valor-ipi[1]                                                                   */
    /*                                     + item-doc-est.preco-total[1]                                                                 */
    /*                                     + item-doc-est.despesas[1]                                                                    */
    /*                                     - item-doc-est.desconto[1]                                                                    */
    /*                                     + item-doc-est.vl-pis-subs                                                                    */
    /*                                     + item-doc-est.vl-cofins-subs.                                                                */
    /*                                                                                                                                   */
    /*                                                                                                                                   */
    /*                                                                                                                                   */
    /*     END.                                                                                                                          */
    /*                                                                                                                                   */
    /*     IF  l-erro THEN                                                                                                               */
    /*         UNDO main_block, LEAVE main_block.                                                                                        */
    /* END.                                                                                                                              */
    
    IF  l-erro THEN DO:
        RUN pi-elimina-handle.
        RETURN "NOK":U.
    END.
    
    IF  l-processo-esftp079 THEN DO:
        FOR EACH  ped-transf EXCLUSIVE-LOCK
            WHERE ped-transf.cod-estabel = nota-fiscal.cod-estabel
            AND   ped-transf.serie       = nota-fiscal.serie
            AND   ped-transf.nr-nota-fis = nota-fiscal.nr-nota-fis:
            FIND FIRST ped-venda EXCLUSIVE-LOCK
                WHERE  ped-venda.nome-abrev = ped-transf.nome-abrev
                AND    ped-venda.nr-pedcli  = ped-transf.nr-pedcli NO-ERROR.
    
            FIND FIRST ped-item NO-LOCK
                WHERE  ped-item.nome-abrev   = ped-transf.nome-abrev
                AND    ped-item.nr-pedcli    = ped-transf.nr-pedcli
                AND    ped-item.it-codigo    = ped-transf.it-codigo
                AND    ped-item.nr-sequencia = ped-transf.nr-sequencia
                AND    ped-item.cod-sit-item < 3  NO-ERROR.
    
            ASSIGN ped-venda.cod-estabel = ped-transf.cod-estab-dest.
    
            IF  l-log THEN
                PUT UNFORMATTED SKIP "****LOG-TESTE****" "Alocando Item: " ped-transf.nome-abrev "/" ped-transf.nr-pedcli "/" ped-transf.it-codigo "/" ped-transf.qt-log-aloca.
    
            RUN pi-alocar-itens IN THIS-PROCEDURE.
            IF  RETURN-VALUE = "NOK":U THEN DO:
                /*PUT UNFORMATTED SKIP(2) "**** ERRO NA ALOCAÄ«O DOS ITENS DE TRANSFER“NCIA ****" SKIP.
                FOR EACH tt-erros:
                    PUT UNFORMATTED tt-erros.nome-abrev "/" tt-erros.nr-pedcli "/" tt-erros.it-codigo " - " tt-erros.mensagem SKIP.
                END.
    
                UNDO main_block, LEAVE main_block.*/
            END.
            ELSE
                DELETE ped-transf.
        END.
    
        IF  CAN-FIND(FIRST tt-erros) THEN DO:
            PUT UNFORMATTED SKIP(2) "**** ERRO NA ALOCAÄ«O DOS ITENS DE TRANSFER“NCIA ****" SKIP.
            FOR EACH tt-erros:
                PUT UNFORMATTED tt-erros.nome-abrev "/" tt-erros.nr-pedcli "/" tt-erros.it-codigo " - " tt-erros.mensagem SKIP.
            END.
        END.
    END.
    
    RUN pi-elimina-handle.

END PROCEDURE.

PROCEDURE imprime-cabec-nota:

    IF NOT l-imprime-ft2100 AND NOT l-imprime-notas-exito-ft2100 THEN DO:
        put nota-fiscal.cod-estabel at 01 space(1)
            nota-fiscal.serie             space(1)
            nota-fiscal.nr-nota-fis       space(1)
            nota-fiscal.nome-ab-cli       space(1).

        FOR EACH tt-it-nota-fis-ft2100 NO-LOCK:

            PUT tt-it-nota-fis-ft2100.nr-seq-fat at 45 space(1)
                tt-it-nota-fis-ft2100.it-codigo
                tt-it-nota-fis-ft2100.cod-refer  at 69 space(1)
                tt-it-nota-fis-ft2100.cod-depos  at 78 space(1)
                tt-it-nota-fis-ft2100.cod-localiz      space(1)
                tt-it-nota-fis-ft2100.nr-serlote       space(1)
                tt-it-nota-fis-ft2100.qt-baixada FORMAT "->,>>>,>>9.9999"  SPACE(1).

            IF NOT l-imp-dt-emis THEN DO:
                ASSIGN l-imp-dt-emis = YES.
                PUT nota-fiscal.dt-emis-nota      SPACE(1).
            END.


        END.

        ASSIGN l-imprime-ft2100 = YES.
    END.

END PROCEDURE.


PROCEDURE pi-alocar-itens:
    DEFINE VARIABLE c-return          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-msg-erro        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-depos-dest  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-nr-ordem        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-qt-transferida AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-qt-alocada     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-qt-saldo       AS DECIMAL     NO-UNDO.

    EMPTY TEMP-TABLE tt-erro.

    ASSIGN c-cod-depos-dest = ped-transf.cod-depos-dest.


    FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "espdp006"
        AND   ponto-programa.ponto         = 1, /* Centrais Embratel */
        EACH  conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
        AND   conteudo-programa.sequencia    = INT(ped-venda.tp-pedido):
        IF  INDEX(conteudo-programa.conteudo,c-seg-usuario) = 0 THEN DO:
            CREATE tt-erros.
            ASSIGN tt-erros.nome-abrev = ped-item.nome-abrev
                   tt-erros.nr-pedcli  = ped-item.nr-pedcli
                   tt-erros.it-codigo  = ped-item.it-codigo
                   tt-erros.mensagem   = "Permiss∆o para alocaá∆o do pedido restrita, somente estes usuarios podem alocar: " + conteudo-programa.conteudo.

            RETURN "NOK":U.
        END.
    END.


    FIND FIRST permissao-alocacao NO-LOCK
        WHERE  permissao-alocacao.it-codigo = ped-item.it-codigo NO-ERROR.
    IF  AVAIL  permissao-alocacao AND
        permissao-alocacao.usuario <> c-seg-usuario THEN DO:
        CREATE tt-erros.
        ASSIGN tt-erros.nome-abrev = ped-item.nome-abrev
               tt-erros.nr-pedcli  = ped-item.nr-pedcli
               tt-erros.it-codigo  = ped-item.it-codigo
               tt-erros.mensagem   = "Usuario sem permiss∆o para alocaá∆o deste item. Este item esta bloqueado pelo usuario: " + permissao-alocacao.usuario.

        RETURN "NOK":U.
    END.

    FIND FIRST ped-ent NO-LOCK
        WHERE  ped-ent.nome-abrev   = ped-item.nome-abrev
        AND    ped-ent.nr-pedcli    = ped-item.nr-pedcli
        AND    ped-ent.nr-sequencia = ped-item.nr-sequencia
        AND    ped-ent.it-codigo    = ped-item.it-codigo
        AND    ped-ent.cod-refer    = ped-item.cod-refer NO-ERROR.
    IF  NOT AVAIL ped-ent THEN DO:
        CREATE tt-erros.
        ASSIGN tt-erros.nome-abrev = ped-item.nome-abrev
               tt-erros.nr-pedcli  = ped-item.nr-pedcli
               tt-erros.it-codigo  = ped-item.it-codigo
               tt-erros.mensagem   = "N∆o foram localizadas as entregas do Item".

        RETURN "NOK":U.
    END.

    ASSIGN de-qt-alocada = ped-transf.qt-log-aloca /* ped-item.qt-log-aloca*/.

    /* Reporte */
    FOR FIRST item-uni-estab NO-LOCK
        WHERE item-uni-estab.cod-estabel = ped-venda.cod-estabel
        AND   item-uni-estab.it-codigo   = ped-ent.it-codigo
        AND   item-uni-estab.nr-linha    = 20: END.
    IF  AVAIL item-uni-estab THEN DO:
        FIND FIRST saldo-estoq NO-LOCK
            WHERE  saldo-estoq.cod-estabel = ped-venda.cod-estabel
            AND    saldo-estoq.it-codigo   = ped-ent.it-codigo
            AND    saldo-estoq.cod-refer   = ped-ent.cod-refer
            AND    saldo-estoq.cod-depos   = c-cod-depos-dest
            AND    saldo-estoq.cod-localiz = "" NO-ERROR.
        IF  NOT AVAIL saldo-estoq OR
           (saldo-estoq.qtidade-atu  -
            (saldo-estoq.qt-alocada  +
             saldo-estoq.qt-aloc-ped +
             saldo-estoq.qt-aloc-prod)) < ped-item.qt-log-aloca THEN DO:
            ASSIGN c-msg-erro = "".

            RUN esp/pdp/espdp006a.p(INPUT  ped-venda.cod-estabel,
                                    INPUT  ROWID(ped-ent),
                                    INPUT  ped-transf.qt-log-aloca /*ped-item.qt-log-aloca*/,
                                    INPUT  c-cod-depos-dest,
                                    INPUT  "",
                                    OUTPUT i-nr-ordem,
                                    OUTPUT c-msg-erro).

            IF  c-msg-erro <> "" AND c-msg-erro <> "OK" THEN DO:
                IF  c-msg-erro = "NOK" THEN
                    RETURN "NOK":U.
                ELSE DO:
                    CREATE tt-erros.
                    ASSIGN tt-erros.nome-abrev = ped-item.nome-abrev
                           tt-erros.nr-pedcli  = ped-item.nr-pedcli
                           tt-erros.it-codigo  = ped-item.it-codigo
                           tt-erros.mensagem   = c-msg-erro.

                    RETURN "NOK":U.
                END.
            END.
        END.
    END.
    ELSE DO:
        DO WHILE de-qt-alocada > 0:
            FIND FIRST saldo-estoq NO-LOCK
                WHERE  saldo-estoq.cod-estabel = ped-venda.cod-estabel
                AND    saldo-estoq.it-codigo   = ped-ent.it-codigo
                AND    saldo-estoq.cod-refer   = ped-ent.cod-refer
                AND    saldo-estoq.cod-depos   = c-cod-depos-dest
                AND    saldo-estoq.cod-localiz = "" NO-ERROR.
            IF  NOT AVAIL saldo-estoq THEN DO:
                CREATE tt-erros.
                ASSIGN tt-erros.nome-abrev = ped-item.nome-abrev
                       tt-erros.nr-pedcli  = ped-item.nr-pedcli
                       tt-erros.it-codigo  = ped-item.it-codigo
                       tt-erros.mensagem   = "Saldo do Estoque n∆o encontrado para o Item.".

                IF  l-log THEN
                    PUT UNFORMATTED SKIP "****LOG-TESTE****" "ped-venda.cod-estabel: " ped-venda.cod-estabel
                                    "ped-ent.it-codigo: " ped-ent.it-codigo
                                    "ped-ent.cod-refer: " ped-ent.cod-refer
                                    "c-cod-depos-dest:  " c-cod-depos-dest.

                RETURN "NOK":U.
            END.
            ELSE DO:
                IF (saldo-estoq.qtidade-atu -
                    (saldo-estoq.qt-alocada  +
                     saldo-estoq.qt-aloc-ped +
                     saldo-estoq.qt-aloc-prod)) < ped-transf.qt-log-aloca THEN DO:
                    CREATE tt-erros.
                    ASSIGN tt-erros.nome-abrev = ped-item.nome-abrev
                           tt-erros.nr-pedcli  = ped-item.nr-pedcli
                           tt-erros.it-codigo  = ped-item.it-codigo
                           tt-erros.mensagem   = "Quantidade do Estoque menor do que a quantidade do Pedido".

                    IF  l-log THEN
                        PUT UNFORMATTED SKIP "****LOG-TESTE****" "saldo-estoq.qtidade-atu: " saldo-estoq.qtidade-atu
                                        "saldo-estoq.qt-alocada: " saldo-estoq.qt-alocada
                                        "saldo-estoq.qt-aloc-ped: " saldo-estoq.qt-aloc-ped
                                        "saldo-estoq.qt-aloc-prod: " saldo-estoq.qt-aloc-prod
                                        "ped-transf.qt-log-aloca: " ped-transf.qt-log-aloca.
                    RETURN "NOK":U.
                END.
                ELSE
                    ASSIGN de-qt-alocada = 0.
            END.

            IF  NOT CAN-FIND(FIRST tt-erro) THEN
                ASSIGN de-qt-alocada = de-qt-alocada - de-qt-transferida.
            ELSE
                ASSIGN de-qt-alocada = 0.
        END.
    END.

    IF  NOT CAN-FIND(FIRST tt-erro) THEN DO:
        /* EFETUA  A ALOCAÄ«O FISICA DOS ITENS DO PEDIDO SELECIONADO */
        ASSIGN de-qt-saldo = 0.
        FOR FIRST saldo-estoq NO-LOCK
            WHERE saldo-estoq.cod-estabel = ped-venda.cod-estabel
            AND   saldo-estoq.it-codigo   = ped-item.it-codigo
            AND   saldo-estoq.cod-depos   = c-cod-depos-dest
            AND   saldo-estoq.cod-localiz = ""
            AND  (saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada   +
                                             saldo-estoq.qt-aloc-prod +
                                             saldo-estoq.qt-aloc-ped)) > 0:
            ASSIGN de-qt-saldo = (saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada   +
                                                             saldo-estoq.qt-aloc-prod +
                                                             saldo-estoq.qt-aloc-ped)).
        END.

        IF  de-qt-saldo >= ped-transf.qt-log-aloca /*ped-item.qt-log-aloca*/ THEN DO:
            IF  VALID-HANDLE(h-pdapi002) THEN DO:
                RUN pi-aloca-fisica-man IN h-pdapi002(INPUT ROWID(ped-ent),
                                                      INPUT-OUTPUT ped-transf.qt-log-aloca /*ped-item.qt-log-aloca*/,
                                                      INPUT ROWID(saldo-estoq)).

                IF  RETURN-VALUE = "NOK" THEN DO:
                    CREATE tt-erros.
                    ASSIGN tt-erros.nome-abrev = ped-item.nome-abrev
                           tt-erros.nr-pedcli  = ped-item.nr-pedcli
                           tt-erros.it-codigo  = ped-item.it-codigo
                           tt-erros.mensagem   = "N∆o foi possivel efetuar a alocaá∆o f°sica do material!".

                    IF  VALID-HANDLE(h-pdapi002) THEN
                        RUN pi-retorna-erro IN h-pdapi002(OUTPUT TABLE tt-erro).

                    ASSIGN c-return = "NOK":U.
                END.
                ELSE
                    ASSIGN c-return = "OK".
            END.
        END.
        ELSE
            ASSIGN c-return = "NSDO".

        IF  l-log THEN
            PUT UNFORMATTED SKIP "****LOG-TESTE****" "c-return: " c-return " avail ped-ent: " AVAIL ped-ent.

        IF  (c-return = "OK" OR NOT AVAIL ped-ent) THEN DO:
            FIND FIRST int-ped-item EXCLUSIVE-LOCK
                WHERE  int-ped-item.nome-abrev   = ped-venda.nome-abrev
                AND    int-ped-item.nr-pedcli    = ped-venda.nr-pedcli
                AND    int-ped-item.nr-sequencia = ped-item.nr-sequencia
                AND    int-ped-item.it-codigo    = ped-item.it-codigo
                AND    int-ped-item.cod-refer    = ped-item.cod-refer NO-ERROR.
            IF  NOT AVAIL int-ped-item  THEN DO:
                CREATE int-ped-item.
                ASSIGN int-ped-item.nome-abrev   = ped-venda.nome-abrev
                       int-ped-item.nr-pedcli    = ped-venda.nr-pedcli
                       int-ped-item.nr-sequencia = ped-item.nr-sequencia
                       int-ped-item.it-codigo    = ped-item.it-codigo
                       int-ped-item.cod-refer    = ped-item.cod-refer NO-ERROR.
            END.

            ASSIGN int-ped-item.log-transferido = YES.

            FIND CURRENT int-ped-item NO-LOCK NO-ERROR.
            RELEASE int-ped-item.
        END.
        ELSE DO:
            IF  c-return = "NSDO" THEN DO:
                CREATE tt-erros.
                ASSIGN tt-erros.nome-abrev = ped-item.nome-abrev
                       tt-erros.nr-pedcli  = ped-item.nr-pedcli
                       tt-erros.it-codigo  = ped-item.it-codigo
                       tt-erros.mensagem   = "Transferància/Reporte n∆o efetuada!~~N∆o h† saldo suficiente no dep¢sito " + c-cod-depos-dest + " para atender a alocaá∆o!".

                RETURN "NOK":U.
            END.
            ELSE DO:
                IF  VALID-HANDLE(h-pdapi002) THEN
                    RUN pi-retorna-erro IN h-pdapi002(OUTPUT TABLE tt-erro).
            END.
        END.
    END.

    IF  CAN-FIND(FIRST tt-erro) THEN DO:
        FOR EACH tt-erro NO-LOCK:
            CREATE tt-erros.
            ASSIGN tt-erros.nome-abrev = ped-item.nome-abrev
                   tt-erros.nr-pedcli  = ped-item.nr-pedcli
                   tt-erros.it-codigo  = ped-item.it-codigo
                   tt-erros.mensagem   = tt-erro.mensagem.
        END.
        RETURN "NOK":U.
    END.
END PROCEDURE.
/****************** F I M    P R O C E D U R E S     I N T E R N A S   *****************/
