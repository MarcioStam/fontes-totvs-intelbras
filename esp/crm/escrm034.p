/*********************************************************************************
** Programa: esp/crm/escrm034.p
** Vers∆o..: 1.00
** Data....: 01/10/2012
** Autor...: Anderson CEnci
** Obs.....: API para criar os Pedidos no EMS do Portal ASTEC
*********************************************************************************/


CREATE WIDGET-POOL.
/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE INPUT  PARAMETER pPedVendaMessagem AS LONGCHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER pRetorno          AS LONGCHAR    NO-UNDO.

    /* Temp-tables do programa */
{esp/crm/escrm034.i}


    /** Vari†veis de TT dinÉmica **/

DEFINE VARIABLE cXML AS LONGCHAR    NO-UNDO.

DEFINE VARIABLE hXML   AS HANDLE      NO-UNDO.
DEFINE VARIABLE hRoot  AS HANDLE      NO-UNDO.
DEFINE VARIABLE hTags  AS HANDLE      NO-UNDO.

DEFINE VARIABLE i AS INTEGER     NO-UNDO.
DEFINE VARIABLE j AS INTEGER     NO-UNDO.

DEFINE VARIABLE l-ok AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-status            AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-status            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-observacao        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-xml AS LONGCHAR   NO-UNDO.
/* ASSIGN c-xml = '<?xml version="1.0" encoding="utf-8"?>                                                 */
/* <pedido cliente="1122" transportadora="retira" estabelecimento="101" atendente="01" canalDeVendas="1"> */
/*   <diagnostico codigoItem="4030001" quantidade="1" numeroOs="aa" id="id1" codigoProdutoPrincipal=""/>                           */
/*   <diagnostico codigoItem="4030002" quantidade="2" numeroOs="bb" id="id2" codigoProdutoPrincipal=""/>                           */
/*   <diagnostico codigoItem="4030003" quantidade="3" numeroOs="cc" id="id3" codigoProdutoPrincipal=""/>                           */
/*   <diagnostico codigoItem="4030004" quantidade="4" numeroOs="dd" id="id4" codigoProdutoPrincipal=""/>                           */
/* </pedido>                                                                                              */
/* '.                                                                                                     */

DEFINE TEMP-TABLE tt-ped-venda no-undo like ped-venda
    field r-rowid  as rowid.
DEFINE TEMP-TABLE tt-ped-item no-undo like ped-item
    field r-rowid  as rowid.
DEFINE TEMP-TABLE tt-ped-ent no-undo like ped-ent
    field r-rowid  as rowid.
DEFINE TEMP-TABLE tt-ped-repre no-undo like ped-repre 
    field r-rowid  as rowid.
DEFINE TEMP-TABLE tt-ped-antecip no-undo like ped-antecip
    field r-rowid  as rowid.
DEFINE TEMP-TABLE tt-cond-ped no-undo like cond-ped
    field r-rowid  as rowid.

DEFINE TEMP-TABLE tt-int-ped-venda NO-UNDO LIKE int-ped-venda
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-int-ped-item NO-UNDO LIKE int-ped-item
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-int-ped-item-astec NO-UNDO LIKE int-ped-item-astec
    FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-int-ped-item-astec-aux NO-UNDO LIKE tt-int-ped-item-astec.

DEFINE TEMP-TABLE tt-log NO-UNDO
    FIELD nr-pedido-telecontrol  AS CHARACTER FORMAT "x(12)"
    FIELD nr-pedido-ems          AS CHARACTER FORMAT "x(12)"
    FIELD cod-cliente            AS INTEGER
    FIELD caminho-arquivo        AS CHARACTER FORMAT "x(150)"
    FIELD mensagem               AS CHARACTER FORMAT "x(100)".

def temp-table tt-ped-vendor
    field data-base    as date
    field dias-base    as int  format ">>>9"
    field cod-cond-pag as int  format ">9"
    field taxa-cliente as dec  format ">>9.9999".

/*
DEFINE TEMP-TABLE tt-ped-vendor no-undo like pd-vendor
    field r-rowid  as rowid.
  */ 
{esapi/esapi010tt.i} /****** TEMP-TABLE tt-email *****/
{utp/utapi019.i} 
/* {cdp/cd0666.i} */
def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEFINE BUFFER b-tt-ped-item FOR tt-ped-item.
        


def stream s-arquivos.
def stream s-arquivo.
def stream s-log.
def stream s.

DEFINE VARIABLE c-nat-oper-dentro-estado-contrib     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nat-oper-dentro-estado-nao-contrib AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nat-oper-fora-estado-contrib       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nat-oper-fora-estado-nao-contrib   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-endereco-email                     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nr-tabpre                          AS CHARACTER   NO-UNDO.

def var l-utiliza-vendor as log.

def var c-valor-arq      as char format "x(80)"            no-undo.
def var i-cliente        like emitente.cod-emitente no-undo. 
def var d-vl-liq-abe     like tt-ped-item.vl-liq-abe       no-undo.
def var d-vl-liq-it      like tt-ped-item.vl-liq-abe       no-undo.
def var c-mail           as char format "x(100)"           no-undo.
def var cmail            as char format "X(100)"           no-undo.
def var c-endereco       as char format "x(50)"            no-undo.
def var c-assunto        as char format "x(50)"            no-undo.

DEFINE VARIABLE de-tot-icm  AS DECIMAL     NO-UNDO.

def var i-cont           as i.
def var d-perc           as dec init 0.
def var d-valor-min      as dec init 0.
def var c-pagto          as char format "x(20)".
def var l-primeiro       as log init yes.
def var de-vl-ipi        as dec.
def var de-vl-liq-abe    as dec.
def var de-vl-liq        as dec.
def var l-envia          as log.
def var c-prazo          as char.
def var c-obs            as char.
def var c-perm           as char.
def var c-nat-oper       like natur-oper.nat-operacao.
DEF VAR l-mantem-nat     AS LOG.
def var l-avalia         as log.
def var c-mail-aten      as char format "X(60)".
def var de-perc          AS DEC.
def var c-cgc-rep        like repres.cgc.
DEF VAR c-desc-suspend   AS CHAR.

DEF VAR de-tot-cipi      AS DEC FORMAT ">>>,>>>,>>9.99".
DEF VAR de-tot-sipi      AS DEC FORMAT ">>>,>>>,>>9.99".

DEFINE VAR cRemetente    AS CHAR FORMAT 'x(60)'   NO-UNDO.
DEFINE VAR CDestino      AS CHAR FORMAT 'x(60)'   NO-UNDO.
DEFINE VAR CAssunto      AS CHAR FORMAT 'x(60)'   NO-UNDO.
DEFINE VAR CDescEmail    AS CHAR FORMAT 'x(2000)' NO-UNDO.
DEFINE VAR CArqEmail     AS CHAR FORMAT 'x(60)'   NO-UNDO.
DEF VARIABLE cArqDest    AS CHARACTER             NO-UNDO.
DEF VARIABLE cArqErro    AS CHARACTER             NO-UNDO.
DEF VARIABLE cArqSalva   AS CHARACTER             NO-UNDO.
DEF VARIABLE cLinhaArq   AS CHARACTER             NO-UNDO.
DEF VARIABLE cLinhaImp   AS CHARACTER             NO-UNDO.
DEF VARIABLE cArqImporta AS CHARACTER             NO-UNDO.
DEF VARIABLE cReturn     AS CHARACTER             NO-UNDO.
DEF VARIABLE iCont       AS INTEGER               NO-UNDO.

def var h-bodi149        as handle no-undo.
def var h-bodi154        as handle no-undo.
def var h-bodi157        as handle no-undo.
def var h-bodi159        as handle no-undo.
def var h-bodi159cal     AS handle no-undo.
def var h-bodi159sus     as handle no-undo.
def var h-esapi018       as handle no-undo.
DEF VAR cArq             AS CHAR FORMAT "X(20)".
DEF VAR cArqcaminho      AS CHAR FORMAT "X(50)".
DEF VAR cArqId           AS CHAR FORMAT "X(20)".
def var c-cod-rota       like rota.cod-rota.
def var c-estado         as char.
DEFINE VARIABLE i-contador-de-linhas AS INTEGER     NO-UNDO.

DEFINE VARIABLE de-icms AS DECIMAL     NO-UNDO.
DEF VAR l-gera-log AS LOGICAL INITIAL YES NO-UNDO.

{esp/es0018.i}

DEFINE VARIABLE c-dir AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-usuario        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-senha          AS CHARACTER   NO-UNDO.

FIND FIRST ponto-programa
    WHERE ponto-programa.nome-programa = "escrm004":U
      AND ponto-programa.ponto         = 1 NO-LOCK NO-ERROR.

IF AVAILABLE ponto-programa THEN DO:
    FOR EACH conteudo-programa
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa NO-LOCK:
        
        IF conteudo-programa.sequencia = 1 THEN DO:
            assign c-usuario = ENTRY(1,conteudo-programa.conteudo,",")
                   c-senha   = ENTRY(2,conteudo-programa.conteudo,",").
        END.
    END.
END.

RUN bi/esbi002.p (INPUT c-usuario,
                  INPUT c-senha).



IF l-gera-log = YES  THEN DO:
    EMPTY TEMP-TABLE tt-prog-ponto.

    IF OPSYS = "UNIX":U THEN
        RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                           INPUT  1,
                           INPUT  0,
                           INPUT  "":U,
                           OUTPUT TABLE tt-prog-ponto).
    ELSE
        RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                           INPUT  1,
                           INPUT  0,
                           INPUT  "":U,
                           OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-dir = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
    END.

    IF SUBSTRING(c-dir, LENGTH(c-dir), 1) <> "/":U THEN
        ASSIGN c-dir = c-dir + "/":U.

    OUTPUT TO VALUE(c-dir + "an046325/escrm034" + trim(replace(string(TODAY),"/","")) + ".txt":U) APPEND.
    
    PUT "passo 1 " SKIP.
END.

DEF TEMP-TABLE tt-arquivo
    FIELD c-arquivo AS CHAR FORMAT "x(20)"
    INDEX arquivo IS PRIMARY IS UNIQUE c-arquivo.



FIND FIRST para-ped NO-LOCK.
FIND FIRST para-fat NO-LOCK.

RUN utp/utapi019.p PERSISTENT SET h-utapi019.  

RUN readXML (INPUT pPedVendaMessagem, 
             OUTPUT TABLE TT-PEDIDO, 
             OUTPUT TABLE TT-ITEns).

FOR FIRST tt-pedido:
    FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "escrm034",
        FIRST conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
        AND conteudo-programa.sequencia      = int(tt-pedido.estabelecimento):
       
        ASSIGN c-nat-oper-dentro-estado-contrib     = ENTRY(1,conteudo-programa.conteudo)
               c-nat-oper-dentro-estado-nao-contrib = ENTRY(2,conteudo-programa.conteudo)
               c-nat-oper-fora-estado-contrib       = ENTRY(3,conteudo-programa.conteudo)
               c-nat-oper-fora-estado-nao-contrib   = ENTRY(4,conteudo-programa.conteudo)
               c-endereco-email                     = ENTRY(5,conteudo-programa.conteudo)
               c-nr-tabpre                          = ENTRY(6,conteudo-programa.conteudo).
    END.

    IF NOT AVAIL conteudo-programa THEN DO:
        IF NOT AVAIL estabelec THEN DO:
            CREATE tt-log.
            ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
                   tt-log.mensagem              = "Estabelecimento " + tt-pedido.estabelecimento + " n∆o cadastrado no cadastro de parametros - ES0018".
            LEAVE.
        END.
        
    END.

    IF l-gera-log = YES  THEN DO:
        PUT "registro 1 " SKIP.
    END.

    ASSIGN d-vl-liq-abe   = 0 
           d-vl-liq-it    = 0 
           c-desc-suspend = ""
           
           cArqEmail      = "".

    RUN pi-zerar-temporarias.

    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = tt-pedido.estabelecimento NO-ERROR.

    IF NOT AVAIL estabelec THEN DO:
        CREATE tt-log.
        ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
               tt-log.mensagem              = "Estabelecimento " + tt-pedido.estabelecimento + " n∆o cadastrado".
        LEAVE.
    END.
    
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = INT(tt-pedido.cliente) NO-ERROR.
    
    IF NOT AVAIL emitente THEN DO:
        CREATE tt-log.
        ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
               tt-log.mensagem              = "Cliente " + tt-pedido.cliente + " n∆o cadastrado.".

        LEAVE.
    END.
    
    IF estabelec.cod-estabel = "101" OR 
       estabelec.cod-estabel = "104" THEN
        FIND repres NO-LOCK WHERE 
             repres.cod-rep = 2000 NO-ERROR. /*** ESTA FIXO POIS N«O ê PAGO COMISS«O ***/
    ELSE     
        FIND repres NO-LOCK WHERE 
             repres.cod-rep = 6000 NO-ERROR. /*** ESTA FIXO POIS N«O ê PAGO COMISS«O ***/
        
    IF NOT AVAIL repres THEN DO:
        CREATE tt-log.
        ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
               tt-log.mensagem              = "Representante " + string(emitente.cod-rep) + " do cliente n∆o cadastrado. - " + " Cod Cliente: " + string(emitente.cod-emitente).
        LEAVE.
    END.

    FIND FIRST loc-entr NO-LOCK USE-INDEX ch-entrega 
         WHERE loc-entr.cod-entrega = "padrao" 
           AND loc-entr.nome-abrev  = emitente.nome-abrev NO-ERROR.
    
    IF NOT AVAIL loc-entr THEN DO:

          CREATE tt-log.
          ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
                 tt-log.mensagem              = "Local de entrega do cliente " + string(emitente.cod-emitente) + " n∆o cadastrado. " + " Cod Cliente: " + string(emitente.cod-emitente).

        LEAVE.
    END.
    
    FIND FIRST transporte
         WHERE transporte.nome-abrev = tt-pedido.transportadora NO-LOCK NO-ERROR.
    
    IF NOT AVAIL transporte THEN DO:
        CREATE tt-log.
        ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
               tt-log.mensagem              = "Transportador " + STRING(tt-pedido.transportador) + " n∆o cadastrado  ".
        LEAVE.
    END.
    
    ASSIGN c-cod-rota = "".
    
    IF transporte.nome-abrev = "sedex" THEN DO:
        FOR EACH rota 
           WHERE rota.descricao BEGINS "sedex 2006" 
           AND  (rota.roteiro <> "" OR 
             NOT rota.roteiro BEGINS "com ex") NO-LOCK:   /* somente capital */
            
            DO i-cont = 1 TO NUM-ENTRIES(rota.roteiro,";"):
                IF TRIM(ENTRY(i-cont,rota.roteiro,";")) = emitente.cidade THEN DO:
                    ASSIGN c-cod-rota = rota.cod-rota.
                    LEAVE.
                END.
            END.
            IF c-cod-rota <> "" THEN LEAVE.
        END.
        
        /* se nao achou capital, procura primeira que nao tiver lista de cidades */
        IF c-cod-rota = "" THEN DO:
            ASSIGN c-estado = "*" + emitente.estado + "*".
            
            FIND FIRST rota
                 WHERE rota.descricao BEGINS "sedex 2006" 
                 AND   rota.descricao MATCHES(c-estado) 
                 AND  (rota.roteiro = "" OR    
                       rota.roteiro BEGINS "com ex") NO-LOCK NO-ERROR.
            
            IF AVAIL rota THEN
                ASSIGN c-cod-rota = rota.cod-rota.
        END.
    END.
    ELSE DO:
        ASSIGN c-cod-rota = loc-entr.cod-rota.
    END.
    
    FIND cond-pagto NO-LOCK WHERE
         cond-pagto.cod-cond-pag = 501 NO-ERROR. /* Remessa em garantia n∆o gera faturamento */
    
    IF NOT AVAIL cond-pagto THEN DO:
        CREATE tt-log.
         ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
                tt-log.mensagem              = "Condiá∆o de pagamento 501 n∆o cadastrado. - " + " Cod Cliente: " + string(emitente.cod-emitente).
      
        LEAVE.
    END.
       
    FIND FIRST natur-oper NO-LOCK WHERE
               natur-oper.nat-operacao =      IF emitente.estado =  estabelec.estado AND emitente.contrib-icms = YES THEN c-nat-oper-dentro-estado-contrib
                                         ELSE IF emitente.estado =  estabelec.estado AND emitente.contrib-icms = NO  THEN c-nat-oper-dentro-estado-nao-contrib
                                         ELSE IF emitente.estado <> estabelec.estado AND emitente.contrib-icms = YES THEN c-nat-oper-fora-estado-contrib         
                                         ELSE IF emitente.estado <> estabelec.estado AND emitente.contrib-icms = NO  THEN c-nat-oper-fora-estado-nao-contrib
                                         ELSE "".
    IF NOT AVAIL natur-oper THEN DO:
        CREATE tt-log.
         ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
                tt-log.mensagem              = "Natureza de operaá∆o parametrizada n∆o cadastrada. - " + " Cod Cliente: " + string(emitente.cod-emitente).

        LEAVE.
    END.
    
    FIND FIRST unid-feder NO-LOCK
         WHERE unid-feder.pais   = estabelec.pais
           AND unid-feder.estado = estabelec.estado NO-ERROR.
    
    ASSIGN de-icms = 1
           l-ok    = NO.
    
    IF unid-feder.estado = emitente.estado THEN
        ASSIGN de-icms = (100 - unid-feder.per-icms-int) / 100.
    ELSE DO:
        DO i = 1 TO 25:
            IF unid-feder.est-exc[i] = emitente.estado AND NOT l-ok THEN
                ASSIGN de-icms = (100 - unid-feder.perc-exc[i]) / 100
                       l-ok = YES.
        END.
        IF NOT l-ok THEN
            ASSIGN de-icms = (100 - unid-feder.per-icms-ext) / 100.
    END.

    ASSIGN c-nat-oper = natur-oper.nat-operacao
           l-mantem-nat = NO.

    CREATE tt-ped-venda.

    ASSIGN tt-ped-venda.nr-pedido  = NEXT-VALUE(seq-nr-pedido)
           tt-ped-venda.nome-abrev = emitente.nome-abrev
           tt-ped-venda.nr-pedcli  = STRING(tt-ped-venda.nr-pedido).

    ASSIGN tt-ped-venda.nr-tabpre  = c-nr-tabpre
           tt-ped-venda.cond-espec = "Reposicao de pecas em garantia".
        
    IF l-gera-log = YES  THEN DO:
        PUT "registro 1 -2- " tt-ped-venda.nr-pedido SKIP.
    END.
    
    ASSIGN tt-ped-venda.cod-estabel    = estabelec.cod-estabel
           tt-ped-venda.dt-emissao     = TODAY
           tt-ped-venda.no-ab-reppri   = repres.nome-abrev
           tt-ped-venda.dt-implant     = TODAY
           tt-ped-venda.nome-transp    = transporte.nome-abrev
           tt-ped-venda.cod-emitente   = emitente.cod-emitente
           tt-ped-venda.nat-operacao   = natur-oper.nat-operacao
           tt-ped-venda.cod-mensagem   = natur-oper.cod-mensagem
/*                 tt-ped-venda.cod-cond-pag   = 501 */
           tt-ped-venda.nr-tab-fin     = cond-pagto.nr-tab-finan
           tt-ped-venda.nr-ind-finan   = cond-pagto.nr-ind-finan
           tt-ped-venda.tp-pedido      = tt-pedido.atendente
           tt-ped-venda.e-mail         = emitente.e-mail
           tt-ped-venda.cod-sit-aval   = 1   /* Credito nao Avaliado */
           tt-ped-venda.mo-codigo      = 0
           tt-ped-venda.cod-gr-cli     = emitente.cod-gr-cli
           tt-ped-venda.tp-faturam     = 1
           tt-ped-venda.origem         = 6
           tt-ped-venda.atendido       = NO
           tt-ped-venda.cd-origem      = 2
           tt-ped-venda.user-impl      = "adm"
           tt-ped-venda.dt-userimp     = TODAY
           tt-ped-venda.tip-cob-desp   = para-fat.tip-cob-desp                   
           tt-ped-venda.esp-ped        = 1
           tt-ped-venda.cod-priori     = 01
           tt-ped-venda.cod-rota       = c-cod-rota 
           tt-ped-venda.cod-canal-venda  = INT(tt-pedido.canalDeVendas)
           tt-ped-venda.ind-ent-completa = YES
           tt-ped-venda.dsp-pre-fat      = YES
           tt-ped-venda.log-usa-tabela-desconto = NO
           tt-ped-venda.ind-lib-nota     = para-ped.ind-lib-nota WHEN AVAIL para-ped
           OVERLAY(tt-ped-venda.char-2,109,8)   = "0".

    /* Grava o n£mero do Pedido do PORTAL ASTEC, para validaá∆o na importaá∆o */
    CREATE tt-int-ped-venda.
    ASSIGN tt-int-ped-venda.nr-pedido             = tt-ped-venda.nr-pedido
           tt-int-ped-venda.cod-estabel           = tt-ped-venda.cod-estabel
           tt-int-ped-venda.nr-pedido-telecontrol = string(tt-ped-venda.nr-pedido)
           tt-int-ped-venda.nr-volumes            = "0".
    
    IF natur-oper.consum-final THEN
        ASSIGN tt-ped-venda.cod-des-merc = 2.
    ELSE 
        ASSIGN tt-ped-venda.cod-des-merc = 1.
    
    ASSIGN tt-ped-venda.dt-entrega  = TODAY
           tt-ped-venda.dt-entorig  = TODAY
           tt-ped-venda.ind-fat-par = NO.
    
    IF l-gera-log = YES  THEN DO:
        PUT "registro 1 -3- " SKIP.
    END.

    IF AVAIL loc-entr THEN
        ASSIGN tt-ped-venda.local-entreg = loc-entr.endereco
              tt-ped-venda.bairro       = loc-entr.bairro
              tt-ped-venda.cidade       = loc-entr.cidade
              tt-ped-venda.pais         = loc-entr.pais
              tt-ped-venda.estado       = loc-entr.estado
              tt-ped-venda.cep          = loc-entr.cep
              tt-ped-venda.caixa-postal = loc-entr.caixa-postal
              tt-ped-venda.cgc          = loc-entr.cgc
              tt-ped-venda.ins-estadual = loc-entr.ins-estadual
              tt-ped-venda.cod-entrega  = loc-entr.cod-entrega
              tt-ped-venda.cidade-cif   = loc-entr.nom-cidad-cif .
    ELSE
        IF AVAIL emitente THEN
            ASSIGN tt-ped-venda.local-entreg = emitente.endereco
                   tt-ped-venda.bairro       = emitente.bairro
                   tt-ped-venda.cidade       = emitente.cidade
                   tt-ped-venda.pais         = emitente.pais
                   tt-ped-venda.estado       = emitente.estado
                   tt-ped-venda.cep          = emitente.cep
                   tt-ped-venda.caixa-postal = emitente.caixa-postal
                   tt-ped-venda.cgc          = emitente.cgc
                   tt-ped-venda.ins-estadual = emitente.ins-estadual
                   tt-ped-venda.cidade-cif   = emitente.cidade.
    
    /***** CRIACAO DO PED-REPRE ******* */
    FIND FIRST tt-ped-repre WHERE
               tt-ped-repre.nr-pedido = tt-ped-venda.nr-pedido AND
               tt-ped-repre.nome-ab-rep = repres.nome-abrev    NO-ERROR.
    
    ASSIGN c-cgc-rep = repres.cgc.
    
    IF NOT AVAIL tt-ped-repre THEN DO:
        
        ASSIGN de-perc = 0.
        
        CREATE tt-ped-repre.
        ASSIGN tt-ped-repre.nr-pedido   = tt-ped-venda.nr-pedido
               tt-ped-repre.ind-repbase = YES
               tt-ped-repre.perc-comis  = de-perc
               tt-ped-repre.nome-ab-rep = repres.nome-abrev.
    END.
    
    ASSIGN l-utiliza-vendor = NO.
    /*** Atribuir Portador conforme o cadastro do cliente ***/
    IF emitente.portador <> 0 THEN
        ASSIGN tt-ped-venda.cod-portador = emitente.portador
               tt-ped-venda.modalidade   = emitente.modalidade.
    ELSE
        ASSIGN tt-ped-venda.cod-portador = 999
               tt-ped-venda.modalidade   = 6.
        
    IF l-gera-log = YES  THEN DO:
        PUT "registro 1 -4- " SKIP.
    END.
END.

FIND FIRST tt-log NO-LOCK NO-ERROR.
IF AVAIL tt-log  THEN DO:
    ASSIGN pRetorno = '<?xml version="1.0" encoding="utf-8"?>
                <pedido codigoPedido="" resultadoDaOperacao="0" mensagem="' + tt-log.mensagem + '" />'.
    RETURN "OK":U.
END.

    
            /*************** ITENS DO PEDIDO   ****************** */
FOR EACH tt-itens:

    /* Valida se OS esta duplicada */
    IF CAN-FIND(FIRST tt-int-ped-item-astec NO-LOCK
                WHERE tt-int-ped-item-astec.nr-pedcli  = tt-ped-venda.nr-pedcli 
                  AND tt-int-ped-item-astec.nome-abrev = tt-ped-venda.nome-abrev
                  AND tt-int-ped-item-astec.it-codigo  = tt-itens.codigoItem
                  AND tt-int-ped-item-astec.vl-guid-os = tt-itens.id) THEN DO:
        CREATE tt-log.
         ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
                tt-log.mensagem              = "Item " + tt-itens.codigoItem + " e OS " + tt-itens.numeroOs + 
            " Pedido ja existente " + tt-ped-venda.nr-pedcli        + 
            
            
            " Guid " + tt-itens.id + 
            " j† cadastrada no EMS.".
                                                        
        DELETE tt-ped-venda.
        LEAVE.
    END.
    ASSIGN c-observacao = "".

    IF l-gera-log = YES  THEN DO:
        PUT "Vai ler produto substituto - " tt-itens.codigoProdutoPrincipal           " - " 
                                          tt-itens.codigoItem      "-"                
            SKIP.
    END.
    
    FIND prod-substituto
         WHERE prod-substituto.it-prod-final = tt-itens.codigoProdutoPrincipal
           AND prod-substituto.it-codigo-pai = tt-itens.codigoItem
           NO-LOCK NO-ERROR.
    IF AVAIL prod-substituto THEN DO:
        FIND FIRST ITEM NO-LOCK WHERE 
                      ITEM.it-codigo = prod-substituto.it-codigo-filho NO-ERROR.
        IF NOT AVAIL ITEM THEN DO:
             CREATE tt-log.
             ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
                    tt-log.mensagem              = "Item Substituto n∆o existe NO cadastro - " + tt-itens.codigoItem +  " Substituto: " + string( prod-substituto.it-codigo-filho).
        
            DELETE tt-ped-venda.
            LEAVE.

        END.
        ASSIGN c-observacao   = "Espdp054 - Substituicao do Item: " + tt-itens.codigoItem + "," + STRING(INTEGER(tt-itens.quantidade)).
        IF l-gera-log = YES  THEN DO:
            PUT "Gravando observacao " c-observacao FORMAT "x(100)"  " - Item FIlho  " prod-substituto.it-codigo-filho SKIP.
        END.
    END.
    ELSE 
        FIND FIRST ITEM NO-LOCK WHERE 
                          ITEM.it-codigo = tt-itens.codigoItem NO-ERROR.

    
    IF NOT AVAIL ITEM OR
        tt-itens.codigoItem = ""  THEN DO:
         CREATE tt-log.
         ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
                tt-log.mensagem              = "Item Inexistente ou em Branco - " + tt-itens.codigoItem +  " Cod Cliente: " + string(emitente.cod-emitente).
    
        DELETE tt-ped-venda.
        LEAVE.
    END.
    
    IF INT(tt-pedido.cliente) = 0 THEN DO:

         CREATE tt-log.
         ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
                tt-log.mensagem              = "Item com quantidade zerada  " + item.it-codigo + " Cliente " + string(emitente.cod-emitente).
        
        DELETE tt-ped-venda.
        LEAVE.
    END.
    
    FIND FIRST classif-fisc NO-LOCK 
         WHERE classif-fisc.class-fiscal = ITEM.class-fisc NO-ERROR.
    
    IF NOT AVAIL classif-fisc OR ITEM.class-fisc = "" THEN DO:
         CREATE tt-log.
         ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
                tt-log.mensagem              = "Item " + ITEM.it-codigo + " sem classificaá∆o fiscal cadastrada - " + " Cod Cliente: " + string(emitente.cod-emitente).
        DELETE tt-ped-venda.
        LEAVE.
    END.

    IF l-gera-log = YES  THEN DO:
        PUT "registro 2 -2*** - " SKIP.
    END.

    FIND FIRST repres NO-LOCK WHERE
               repres.nome-abrev = tt-ped-venda.no-ab-reppri NO-ERROR.
  
    ASSIGN c-nat-oper   = tt-ped-venda.nat-operacao
           l-mantem-nat = YES.
            
    FIND FIRST natur-oper NO-LOCK WHERE
             natur-oper.nat-operacao = c-nat-oper NO-ERROR.
    IF l-gera-log = YES  THEN DO:
        PUT "registro 2 -2***b- " SKIP.
    END.

    IF NOT AVAIL natur-oper THEN DO:

       CREATE tt-log.
       ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
              tt-log.mensagem              = "Natureza de operaá∆o " + c-nat-oper + " invalida -  " + " Cod Cliente: " + string(emitente.cod-emitente).
    
       DELETE tt-ped-venda.
        IF l-gera-log = YES  THEN DO:
            PUT "registro 2 -2a-  Natureza de operaá∆o " + c-nat-oper + " invalida -  " + " Cod Cliente: " + string(emitente.cod-emitente) SKIP.
        END.
       LEAVE.
    END.
    IF l-gera-log = YES  THEN DO:
        PUT "registro 2 -2- " SKIP.
    END.
    FIND FIRST preco-item NO-LOCK
       WHERE preco-item.it-codigo  = ITEM.it-codigo 
       AND   preco-item.cod-refer  = ""
       AND   preco-item.nr-tabpre  = c-nr-tabpre
       AND   preco-item.dt-inival <= TODAY
       AND   preco-item.situacao   = 1 NO-ERROR.
     IF l-gera-log = YES  THEN DO:
        PUT "registro 2 -2bbbb- " SKIP.
    END.
    IF NOT AVAIL preco-item THEN DO:
        CREATE tt-log.
        ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
               tt-log.mensagem              = "O item " + ITEM.it-codigo + " n∆o possui preáo ativo cadastrado na tabela " + c-nr-tabpre + " - " + " Cod Cliente: " + string(emitente.cod-emitente).

        IF l-gera-log = YES  THEN DO:
           PUT "Erro " tt-log.mensagem FORMAT "x(300)" SKIP.
        END.
        DELETE tt-ped-venda.

        LEAVE.
    END.
    IF l-gera-log = YES  THEN DO:
        PUT "registro 2 -2ab- " SKIP.
    END.

    FIND FIRST tt-ped-item
        WHERE tt-ped-item.nome-abrev = tt-ped-venda.nome-abrev
          AND tt-ped-item.nr-pedcli  = tt-ped-venda.nr-pedcli
          AND tt-ped-item.it-codigo  = item.it-codigo NO-ERROR.

    IF NOT AVAILABLE tt-ped-item THEN DO:
        FIND LAST b-tt-ped-item
            WHERE b-tt-ped-item.nome-abrev = tt-ped-venda.nome-abrev
              AND b-tt-ped-item.nr-pedcli  = tt-ped-venda.nr-pedcli NO-ERROR.

        CREATE tt-ped-item.
        ASSIGN tt-ped-item.nome-abrev = tt-ped-venda.nome-abrev
               tt-ped-item.nr-pedcli  = tt-ped-venda.nr-pedcli.

        IF l-gera-log = YES  THEN DO:
            PUT "registro 2 -2ac- " SKIP.
        END.


        /* ATRIBUIR SEQUENCIA AO ITEM */
        ASSIGN tt-ped-item.nr-sequencia = IF AVAILABLE b-tt-ped-item THEN (b-tt-ped-item.nr-sequencia + 10) ELSE 10.

        ASSIGN tt-ped-item.it-codigo  = item.it-codigo
               tt-ped-item.dt-entorig = tt-ped-venda.dt-entorig.

/*         FIND LAST item-dt-entrega NO-LOCK                                      */
/*              WHERE item-dt-entrega.it-codigo = item.it-codigo NO-ERROR.        */
/*                                                                                */
/*         IF AVAIL item-dt-entrega                                               */ /* conforme conversa com Luciano Cestari, nestes pedidos n∆o Ç necessario */
/*              AND item-dt-entrega.dt-entrega-futura > TODAY THEN DO:            */
/*             ASSIGN tt-ped-item.dt-entrega = item-dt-entrega.dt-entrega-futura. */
/*         END.                                                                   */
/*         ELSE                                                                   */
        
        ASSIGN tt-ped-item.dt-entrega = tt-ped-venda.dt-entrega.

        ASSIGN tt-ped-item.qt-pedida = 0.

        IF l-gera-log = YES  THEN DO:
            PUT "registro 2 -2ad- " SKIP.
        END.


        /** Explicaá∆o do 0.495
         * LAI tem 25% de desconto em cima do preáo de revenda, mais uma
         * bonificaá∆o de 12%, conforme Lazare explicou em 27.04.2006
         * SOS 39430 - Pedidos da PORTAL ASTEC devem ser implantados com o preáo LAI
         *
         * Tarefa 12264: preáo est† diferente no c†lculo, depois da alteraá∆o da tabela
         *
         */

        /* mudou em 08/02/2011, segundo Lazare somente aplica o ICMS
         * ASSIGN tt-ped-item.vl-pretab = preco-item.preco-venda / de-icms / 1.25 / (if item.ge-codigo = 10 then 1.51 else 1.25)
         *        tt-ped-item.vl-preori = preco-item.preco-venda / de-icms / 1.25 / (if item.ge-codigo = 10 then 1.51 else 1.25).
         */

        ASSIGN tt-ped-item.vl-pretab = preco-item.preco-venda / de-icms
               tt-ped-item.vl-preori = preco-item.preco-venda / de-icms.

        /*** DEFINICAO DO VALOR UNITARIO COM DESCONTO ZFM ** */
        IF natur-oper.per-des-icm > 0 THEN
            ASSIGN tt-ped-item.vl-preuni = tt-ped-item.vl-preori - (tt-ped-item.vl-preori * (natur-oper.per-des-icm / 100)).
        ELSE
            ASSIGN tt-ped-item.vl-preuni = tt-ped-item.vl-preori.

            IF l-gera-log = YES  THEN DO:
                PUT "registro 2 -2ae- " SKIP.
            END.


        ASSIGN tt-ped-item.per-minfat            = IF AVAILABLE emitente THEN emitente.per-minfat ELSE tt-ped-item.per-minfat
               tt-ped-item.cod-sit-item          = tt-ped-venda.cod-sit-ped
               tt-ped-item.user-impl             = tt-ped-venda.user-impl
               tt-ped-item.dt-userimp            = tt-ped-venda.dt-userimp
               tt-ped-item.aliquota-ipi          = item.aliquota-ipi
               tt-ped-item.tp-preco              = 0
               tt-ped-item.per-des-icms          = natur-oper.per-des-icms
               tt-ped-item.nat-operacao          = natur-oper.nat-operacao
               tt-ped-item.tipo-atend            = IF tt-ped-venda.ind-fat-par THEN 2 ELSE 1
               tt-ped-item.observacao            = c-observacao
               tt-ped-item.cod-sit-pre           = tt-ped-venda.cod-sit-pre
               tt-ped-item.esp-ped               = 1
               tt-ped-item.cod-entrega           = tt-ped-venda.cod-entrega
               tt-ped-item.cd-origem             = 2
               tt-ped-item.tp-adm-lote           = 1
               OVERLAY(tt-ped-item.char-2, 1, 8) = item.class-fiscal.

        IF item.tipo-contr = 4 THEN
            ASSIGN OVERLAY(tt-ped-item.char-2, 9, 2) = item.un.

        ASSIGN tt-ped-item.log-usa-tabela-desconto = NO
               tt-ped-item.des-un-medida           = item.un
               tt-ped-item.cod-unid-negoc          = item.cod-unid-neg.

        FIND FIRST tt-int-ped-item
            WHERE tt-int-ped-item.nome-abrev   = tt-ped-item.nome-abrev
              AND tt-int-ped-item.nr-pedcli    = tt-ped-item.nr-pedcli
              AND tt-int-ped-item.nr-sequencia = tt-ped-item.nr-sequencia
              AND tt-int-ped-item.it-codigo    = tt-ped-item.it-codigo
              AND tt-int-ped-item.cod-refer    = tt-ped-item.cod-refer NO-ERROR.


        IF l-gera-log = YES  THEN DO:
            PUT "registro 2 -2af- " SKIP.
        END.

        IF NOT AVAILABLE tt-int-ped-item THEN DO:
            CREATE tt-int-ped-item.
            ASSIGN tt-int-ped-item.nome-abrev   = tt-ped-item.nome-abrev
                   tt-int-ped-item.nr-pedcli    = tt-ped-item.nr-pedcli
                   tt-int-ped-item.nr-sequencia = tt-ped-item.nr-sequencia
                   tt-int-ped-item.it-codigo    = tt-ped-item.it-codigo
                   tt-int-ped-item.cod-refer    = tt-ped-item.cod-refer.
        END.

        FIND FIRST tt-ped-ent
            WHERE tt-ped-ent.nome-abrev   = tt-ped-item.nome-abrev
              AND tt-ped-ent.nr-pedcli    = tt-ped-item.nr-pedcli
              AND tt-ped-ent.nr-sequencia = tt-ped-item.nr-sequencia
              AND tt-ped-ent.it-codigo    = tt-ped-item.it-codigo
              AND tt-ped-ent.cod-refer    = tt-ped-item.cod-refer NO-ERROR.

        IF NOT AVAILABLE tt-ped-ent THEN DO:
            CREATE tt-ped-ent.
            ASSIGN tt-ped-ent.nr-pedcli    = tt-ped-item.nr-pedcli
                   tt-ped-ent.cod-sit-ent  = tt-ped-item.cod-sit-item
                   tt-ped-ent.cod-sit-pre  = tt-ped-item.cod-sit-pre
                   tt-ped-ent.dt-entorig   = tt-ped-item.dt-entorig
                   tt-ped-ent.dt-entrega   = tt-ped-item.dt-entrega
                   tt-ped-ent.dt-userimp   = tt-ped-item.dt-userimp
                   tt-ped-ent.it-codigo    = tt-ped-item.it-codigo
                   tt-ped-ent.nome-abrev   = tt-ped-item.nome-abrev
                   tt-ped-ent.qt-pedida    = tt-ped-item.qt-pedida
                   tt-ped-ent.user-impl    = tt-ped-item.user-impl
                   tt-ped-ent.vl-liq-it    = tt-ped-item.vl-liq-it
                   tt-ped-ent.nr-sequencia = tt-ped-item.nr-sequencia
                   tt-ped-ent.vl-liq-abe   = tt-ped-item.vl-liq-abe.
        END.
    END.

    IF l-gera-log = YES  THEN DO:
        PUT "registro 2 -2ag- " SKIP.
    END.


    ASSIGN tt-ped-item.qt-pedida   = tt-ped-item.qt-pedida + INTEGER(tt-itens.quantidade)
           tt-ped-item.vl-merc-abe = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni
           tt-ped-item.vl-liq-it   = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni.

    /*** TRATAMENTO IPI ** */
    IF  item.cd-trib-ipi       = 1  AND  /**** tributado *** */
       (natur-oper.cd-trib-ipi = 1  OR   /**** tributado *** */
        natur-oper.cd-trib-ipi = 4) THEN /**** Reduzido  *** */
        ASSIGN tt-ped-item.vl-liq-abe = tt-ped-item.vl-liq-it + (tt-ped-item.vl-liq-it * tt-ped-item.aliquota-ipi / 100).
    ELSE
        ASSIGN tt-ped-item.vl-liq-abe = tt-ped-item.vl-liq-it.

    ASSIGN tt-ped-item.vl-tot-it = tt-ped-item.vl-liq-abe
           tt-ped-item.qt-un-fat = tt-ped-item.qt-pedida.

    IF l-gera-log = YES  THEN DO:
        PUT "registro 2 -3- " SKIP.
    END.

    /* TRATA NUMERO DA OS */
    FIND FIRST tt-int-ped-item-astec
        WHERE tt-int-ped-item-astec.nome-abrev   = tt-ped-item.nome-abrev
          AND tt-int-ped-item-astec.nr-pedcli    = tt-ped-item.nr-pedcli
          AND tt-int-ped-item-astec.nr-sequencia = tt-ped-item.nr-sequencia
          AND tt-int-ped-item-astec.it-codigo    = tt-ped-item.it-codigo
          AND tt-int-ped-item-astec.nr-os        = tt-itens.numeroOs NO-ERROR.

    IF NOT AVAILABLE tt-int-ped-item-astec THEN DO:
        CREATE tt-int-ped-item-astec.
        ASSIGN tt-int-ped-item-astec.nome-abrev   = tt-ped-item.nome-abrev
               tt-int-ped-item-astec.nr-pedcli    = tt-ped-item.nr-pedcli
               tt-int-ped-item-astec.nr-sequencia = tt-ped-item.nr-sequencia
               tt-int-ped-item-astec.it-codigo    = tt-ped-item.it-codigo
               tt-int-ped-item-astec.nr-os        = tt-itens.numeroOs
               tt-int-ped-item-astec.vl-guid-os   = tt-itens.id
               tt-int-ped-item-astec.qt-pedida    = 0.
    END.

    ASSIGN tt-int-ped-item-astec.qt-pedida = tt-int-ped-item-astec.qt-pedida + INTEGER(tt-itens.quantidade).

    ASSIGN tt-ped-item.observacao   = tt-ped-item.observacao   + (IF tt-ped-item.observacao   = "":U THEN "":U ELSE ", ":U) + tt-itens.numeroOs     + " ":U   + tt-itens.id
           tt-ped-venda.observacoes = tt-ped-venda.observacoes + (IF tt-ped-venda.observacoes = "":U THEN "":U ELSE ", ":U) + tt-int-ped-item-astec.nr-os + " - ":U + tt-int-ped-item-astec.it-codigo.

    IF l-gera-log = YES  THEN DO:
        PUT "registro 2 -4- " tt-ped-item.observacao SKIP.
    END.           
END.

/* ATRIBUICAO DE VALORES TOTAIS DO PEDIDO */
FOR EACH tt-ped-item:
    ASSIGN d-vl-liq-it  = d-vl-liq-it  + tt-ped-item.vl-liq-it
           d-vl-liq-abe = d-vl-liq-abe + tt-ped-item.vl-liq-abe.
END.

FIND FIRST tt-log NO-LOCK NO-ERROR.
IF AVAIL tt-log  THEN DO:
    ASSIGN pRetorno = '<?xml version="1.0" encoding="utf-8"?>
                <pedido codigoPedido="" resultadoDaOperacao="0" mensagem="' + tt-log.mensagem + '" />'.
    RETURN "OK":U.
END.
    IF NOT l-mantem-nat THEN DO:
        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = c-nat-oper NO-ERROR.

        ASSIGN tt-ped-venda.nat-operacao = natur-oper.nat-operacao
               tt-ped-venda.cod-mensagem = natur-oper.cod-mensagem
               tt-ped-venda.cod-canal-venda  = if estabelec.cod-estabel = "102" then 791 else if natur-oper.cod-canal-venda <> 0 then 
                                                  natur-oper.cod-canal-venda
                                               else emitente.cod-canal-venda.
                                                    
        if natur-oper.consum-final then
            assign tt-ped-venda.cod-des-merc = 2.
        else 
            assign tt-ped-venda.cod-des-merc = 1.
    END.
    
    assign tt-ped-venda.vl-tot-ped = d-vl-liq-abe
           tt-ped-venda.vl-liq-abe = d-vl-liq-abe
           tt-ped-venda.vl-mer-abe = d-vl-liq-it
           tt-ped-venda.vl-liq-ped = d-vl-liq-it.

    find first repres no-lock
         where repres.nome-abrev = tt-ped-venda.no-ab-reppri no-error.

    assign tt-ped-venda.cidade-cif = tt-ped-venda.cidade.

    IF c-desc-suspend <> "" THEN
        ASSIGN tt-ped-venda.cod-priori = 99.

    
    IF l-gera-log = YES  THEN DO:    
        put "antes executar-bos"  SKIP.
    END.

    RUN pi-executar-bos (INPUT c-desc-suspend).
    
    run pi-destroi-bos.

    IF l-gera-log = YES  THEN DO:    
        put "apos executar-bos"  SKIP.
    END.

    FIND FIRST tt-log
        WHERE tt-log.nr-pedido-ems <> "" NO-LOCK NO-ERROR.

    IF AVAIL tt-log THEN DO:
        ASSIGN pRetorno = '<?xml version="1.0" encoding="utf-8"?><pedido codigoPedido="' 
                            + string(tt-log.nr-pedido-ems) + 
                             '" resultadoDaOperacao="1" mensagem="' 
                            + tt-log.mensagem + 
                            '" />'.
    END.
    ELSE DO:
        FIND FIRST tt-log NO-LOCK NO-ERROR.
        IF AVAIL tt-log THEN DO:
            ASSIGN pRetorno = '<?xml version="1.0" encoding="utf-8"?>
                        <pedido codigoPedido="" resultadoDaOperacao="0" mensagem="' + tt-log.mensagem + '" />'.
            NEXT.

        END.
        ELSE DO:
            ASSIGN pRetorno = '<?xml version="1.0" encoding="utf-8"?>
                        <pedido codigoPedido="" resultadoDaOperacao="0" mensagem="Nao encontrado Log de erro" />'.
            NEXT.
        END.

    END.
       
  
    /******** EMAIL PARA O CLIENTE  *************** */

    IF l-gera-log = YES  THEN DO:    
        put "-1- email " cDestino  SKIP.
    END.
        
    hide message no-pause.
      
    find emitente no-lock where
         emitente.nome-abrev = tt-ped-venda.nome-abrev no-error.

    assign cDestino = ""
           de-tot-cipi = 0
           de-tot-sipi = 0.
    
    if emitente.e-mail <> "" then do:
       assign cDestino = emitente.e-mail.
    end.
    else do:   
       find first cont-emit no-lock where
            cont-emit.cod-emitente = emitente.cod-emitente and
            cont-emit.e-mail <> "" no-error.
       if avail cont-emit then
          assign cDestino = cont-emit.e-mail.
    end.
         
    FIND atendente 
        WHERE atendente.cd-oper = int(tt-pedido.atendente)
        NO-LOCK NO-ERROR.
    IF AVAIL atendente THEN
      assign cDestino = atendente.email.
    
    assign cassunto  = "Pedidos Intelbras " + tt-ped-venda.nr-pedcli
           cArqEmail = session:temp-directory + string(emitente.cod-emitente, "999999") + ".txt".
    
    ASSIGN cRemetente = "b2b@intelbras.com.br".

    output stream s to value(cArqEmail).     
    
    put stream s "Intelbras S/A Ind. Telec. Eletr. Brasileira" skip
                 "         Suporte Remoto as Vendas" skip
                 "     Confirmacao automatica de pedidos" skip(2).
         
    put stream s "Numero do Pedido: " tt-ped-venda.nr-pedcli skip
                 "Nome do  Cliente: " emitente.nome-emit skip   
                 "Data de  Emissao: " tt-ped-venda.dt-emissao skip
                 "Nome da Transpor: " tt-ped-venda.nome-transp skip
                 "Observacoes     : " tt-ped-venda.cond-espec skip(2)
                 "Itens do Pedido" skip(1).     
    
    PUT STREAM s "Item    Descricao                             Quant Pedida    Preco Unitario   Valor sem IPI   Valor com IPI" SKIP
                 "------- ------------------------------------ ------------- ----------------- --------------- ---------------" SKIP.
    for each ped-item no-lock 
        WHERE ped-item.nr-pedcli = tt-ped-venda.nr-pedcli 
          AND ped-item.nome-abrev = tt-ped-venda.nome-abrev,
        first item no-lock where
              item.it-codigo = ped-item.it-codigo:

        PUT stream s item.it-codigo FORMAT "x(7)" 
                     " "
                     item.descricao-1 + item.descricao-2 format "X(36)"
                     " " 
                     ped-item.qt-pedida 
                     " "
                     ped-item.vl-preuni 
                     " "
                     ped-item.vl-liq-it  
                     " "
                     ped-item.vl-tot-it SKIP.
        ASSIGN de-tot-cipi = de-tot-cipi + ped-item.vl-tot-it
               de-tot-sipi = de-tot-sipi + ped-item.vl-liq-it.
    end.       
     
    put stream s space(52) "Total do pedido ===>>>    " de-tot-sipi "  " de-tot-cipi skip(2) 
        "<*** E-mail automatico ***>" skip(1).

    output stream s close.
    
    ASSIGN cdescemail = "Verifique no arquivo anexo, os dados do seu pedido".

    IF l-gera-log = YES  THEN DO:    
        put "email " cDestino  SKIP.
    END.
        
    
    RUN piEnviaEmail(INPUT cRemetente, 
                     INPUT cDestino,
                     INPUT cAssunto,
                     INPUT cDescEmail,
                     INPUT cArqEmail).
  
           
    

IF l-gera-log = YES  THEN DO:
    OUTPUT CLOSE.
END.
    

hide message no-pause.
RETURN "OK":U.


PROCEDURE pi-zerar-temporarias:
    FOR EACH tt-ped-venda:
        DELETE tt-ped-venda.
    END.

    FOR EACH tt-ped-item:
        DELETE tt-ped-item.
    END.

    
    FOR EACH tt-ped-ent:
        DELETE tt-ped-ent.
    END.

    FOR EACH tt-ped-repre:
        DELETE tt-ped-repre.
    END.

    for each tt-ped-vendor:
        delete tt-ped-vendor.
    end.

END PROCEDURE.

    

PROCEDURE piEnviaEmail:

    DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.

/*    ASSIGN pDestino = "claudiney@intelbras.com.br". */


    FOR EACH tt-mail:
        DELETE tt-mail.
    END.
    DEF VAR icont AS INT. 
    FOR FIRST param-global NO-LOCK:
    END.

    CREATE tt-mail.
    ASSIGN tt-mail.Remetente     = pRemetente
           tt-mail.Destinatario  = pdestino
           tt-mail.Assunto       = pAssunto
           tt-mail.Arquivo       = IF pArquivo <> "" then
                                      SEARCH(pArquivo) 
                                   ELSE
                                       "" 
           tt-mail.Mensagem      = pDescEmail.

       FOR EACH tt-mail:

           FOR EACH tt-envio2.   DELETE tt-envio2.   END.
           FOR EACH tt-mensagem. DELETE tt-mensagem. END.

           CREATE tt-envio2.
           ASSIGN tt-envio2.versao-integracao = 1
                  tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
                  tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
                  tt-envio2.destino           = tt-mail.Destinatario     /* Destinat†rio       */ 
                  tt-envio2.remetente         = tt-mail.Remetente        /* Remetente          */ 
                  tt-envio2.assunto           = tt-mail.Assunto          /* Assunto            */
                  tt-envio2.arq-anexo         = tt-mail.Arquivo          /* Arquivo Tempor†rio */
                  tt-envio2.formato           = "TEXTO".

           CREATE tt-mensagem.
           ASSIGN tt-mensagem.seq-mensagem = 1
                  tt-mensagem.mensagem     = tt-mail.Mensagem. /* Mensagem           */
                   /*"<h1><center>message body 1</pre>"*/

       /*    PUT 'TST 1 ' SKIP.*/
           RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                          INPUT  TABLE tt-mensagem,
                                          OUTPUT TABLE tt-erros).
       /*    PUT 'TST 2 ' SKIP.*/
/*           ASSIGN tt-mail.lEnviado = CAN-FIND(FIRST tt-erros). */
           FIND FIRST tt-erros NO-LOCK NO-ERROR.
           IF AVAIL tt-erros THEN
               OUTPUT TO erros-comerc.LOG APPEND.

           FOR EACH tt-erros:
               DISP tt-erros.cod-erro
                    tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
           END.
           OUTPUT CLOSE.
       END.
/*    RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                          OUTPUT TABLE tt-erro).
    IF CAN-FIND(FIRST tt-erro) THEN
        RUN cdp\cd0666.w (INPUT TABLE tt-erro). 
  */
END PROCEDURE.


PROCEDURE pi-executar-bos.
    DEF INPUT PARAMETER p-desc-suspend AS CHAR.

    DEFINE VARIABLE i-cod-gr-canais        AS INT NO-UNDO.

    bloco:
    DO  TRANSACTION ON ERROR  UNDO bloco, LEAVE bloco
                    ON ENDKEY UNDO bloco, LEAVE bloco:
        
        run dibo/bodi159.p persistent set h-bodi159.
    
        run openQueryStatic in h-bodi159(input "Main":U).
        run setRecord       in h-bodi159(input table tt-ped-venda). 
        RUN inputRowVendor  IN h-bodi159(INPUT TABLE tt-ped-vendor).
        run emptyRowErrors in h-bodi159.
        run createMPLog    in h-bodi159(input no). 
        RUN createRecord   in h-bodi159.
        run getRowErrors   in h-bodi159(output table RowErrors).

        IF l-gera-log = YES  THEN DO:    
            put "1 executar-bos"  SKIP.
        END.
    
        for each RowErrors
           where RowErrors.ErrorType   <> "INTERNAL":U
             and RowErrors.ErrorSubType = "Error":U no-lock:
            CREATE  tt-log.
            ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
                   tt-log.mensagem              = string(RowErrors.errorNumber) + "-" + RowErrors.ERRORDescription.

        END.
        IF CAN-FIND (FIRST tt-log) THEN
           UNDO bloco, LEAVE bloco.
        
        /*** Verifica se utiliza informa?Ñes de VENDOR ***/
/*        run useVendorInformation in h-bodi159 (input tt-ped-venda.modalidade,
                                               input tt-ped-venda.cod-cond-pag,
                                               output l-utiliza-vendor).
  */
/*        if  l-utiliza-vendor then do:
            run inputRowVendor in h-bodi159 (input table tt-ped-vendor).
        END.
  */
        run dibo/bodi157.p persistent set h-bodi157.

        FOR EACH tt-ped-repre:
            run openQueryStatic in h-bodi157(input "Default":U).
            run emptyRowErrors  in h-bodi157.
            run setRecord       in h-bodi157(input table tt-ped-repre).
            run createMPLog     in h-bodi157(input no).
            run createRecord    in h-bodi157.
            run getRowErrors    in h-bodi157(output table RowErrors).
    
            for each RowErrors
               where RowErrors.ErrorType   <> "INTERNAL":U
                 and RowErrors.ErrorSubType = "Error":U no-lock:
                CREATE tt-log.
                ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
                       tt-log.mensagem              = STRING(RowErrors.errorNumber) + "-" + RowErrors.ERRORDescription + " Repres: " + tt-ped-repre.nome-ab-rep.

                IF l-gera-log = YES  THEN DO:    
                    put "1a rowerrors " tt-log.mensagem FORMAT "x(300)" SKIP.
                END.
            END.
            DELETE tt-ped-repre.
        END.
        IF l-gera-log = YES  THEN DO:    
            put "2 executar-bos"  SKIP.
        END.

        /*delete procedure h-bodi157.*/

        IF CAN-FIND (FIRST tt-log) THEN
           UNDO bloco, LEAVE bloco.
        
        run dibo/bodi154.p persistent set h-bodi154.
        
        FOR EACH tt-ped-item:

            /* Verifica data de entrega do item */
            FIND int-ped-venda2 NO-LOCK
                WHERE int-ped-venda2.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.
            
            FIND LAST item-dt-entrega NO-LOCK
                WHERE item-dt-entrega.it-codigo = tt-ped-item.it-codigo 
                  AND item-dt-entrega.cod-gr-canais = IF AVAIL int-ped-venda2 THEN int-ped-venda2.int-1 ELSE 0 NO-ERROR.

            IF NOT AVAIL item-dt-entrega THEN DO:

                ASSIGN i-cod-gr-canais = 0.
        
                FIND FIRST atendente
                     WHERE atendente.cd-oper = int(tt-ped-venda.tp-pedido) NO-LOCK NO-ERROR.
                IF AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO:
                    ASSIGN i-cod-gr-canais = atendente.cod-gr-canais.
                END. /* IF AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO: */
                ELSE DO:
                    FIND FIRST emitente
                         WHERE emitente.cod-emitente = tt-ped-venda.cod-emitente NO-LOCK NO-ERROR.
                    IF  AVAIL emitente THEN DO:
                        FIND FIRST grupo-canais-clientes
                             WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
                        IF AVAIL grupo-canais-clientes THEN DO:
                            ASSIGN i-cod-gr-canais = grupo-canais-clientes.cod-gr-canais.
                        END.
                    END.
                END. /* IF NOT AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO: */
        
                FIND LAST item-dt-entrega NO-LOCK
                    WHERE item-dt-entrega.it-codigo = tt-ped-item.it-codigo 
                      AND item-dt-entrega.cod-gr-canais = i-cod-gr-canais NO-ERROR.
            END.
        
            IF AVAIL item-dt-entrega
                 AND item-dt-entrega.dt-entrega-futura > TODAY 
                 AND tt-ped-venda.dt-entrega           < item-dt-entrega.dt-entrega-futura THEN DO:
                ASSIGN tt-ped-item.dt-entrega = item-dt-entrega.dt-entrega-futura.
            END.
            ELSE
                ASSIGN tt-ped-item.dt-entrega = tt-ped-venda.dt-entrega.

            run openQueryStatic in h-bodi154(input "Default":U).
            run emptyRowErrors  in h-bodi154.
            run setRecord       in h-bodi154(input table tt-ped-item).
            run createMPLog     in h-bodi154(input no).
            run createRecord    in h-bodi154.
            run getRowErrors    in h-bodi154(output table RowErrors).

            IF l-gera-log = YES  THEN DO:    
                put "2a "  SKIP.
            END.

                                
            for each RowErrors
               where RowErrors.ErrorType   <> "INTERNAL":U
                 and RowErrors.ErrorSubType = "Error":U no-lock:

                CREATE  tt-log.
                ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
                       tt-log.mensagem              = string(RowErrors.errorNumber) + "-" + RowErrors.ERRORDescription + " Item: " + tt-ped-item.it-codig.
                IF l-gera-log = YES  THEN DO:    
                    put "2b rowerrors " tt-log.mensagem FORMAT "x(300)" SKIP.
                END.

            END.

            /* TRATA NUMERO DA OS */
            EMPTY TEMP-TABLE tt-int-ped-item-astec-aux.

            FOR EACH tt-int-ped-item-astec
                WHERE tt-int-ped-item-astec.nome-abrev   = tt-ped-item.nome-abrev
                  AND tt-int-ped-item-astec.nr-pedcli    = tt-ped-item.nr-pedcli
                  AND tt-int-ped-item-astec.nr-sequencia = tt-ped-item.nr-sequencia
                  AND tt-int-ped-item-astec.it-codigo    = tt-ped-item.it-codigo:
                CREATE tt-int-ped-item-astec-aux.
                BUFFER-COPY tt-int-ped-item-astec TO tt-int-ped-item-astec-aux.
            END.
            IF l-gera-log = YES  THEN DO:    
                put "2c "  SKIP.
            END.

            IF  NOT VALID-HANDLE(h-esapi018)                  OR
                h-esapi018:TYPE      <> "PROCEDURE":U         OR
               (h-esapi018:FILE-NAME <> "esapi/esapi018.p":U  AND
                h-esapi018:FILE-NAME <> "esapi/esapi018.r":U) THEN
                RUN esapi/esapi018.p PERSISTENT SET h-esapi018.

            IF  VALID-HANDLE(h-esapi018)                     AND
                h-esapi018:TYPE      = "PROCEDURE":U         AND
               (h-esapi018:FILE-NAME = "esapi/esapi018.p":U  OR
                h-esapi018:FILE-NAME = "esapi/esapi018.r":U) THEN DO:

                IF l-gera-log = YES  THEN DO:    
                    put "2d "  SKIP.
                END.

                RUN createPedItemAstec IN h-esapi018 (INPUT TABLE tt-int-ped-item-astec-aux).

                IF l-gera-log = YES  THEN DO:    
                    put "2e "  SKIP.
                END.

                IF RETURN-VALUE = "NOK":U THEN DO:
                    RUN getRowErrors IN h-esapi018 (OUTPUT TABLE RowErrors).

                    FOR EACH RowErrors:
                        CREATE tt-log.
                        ASSIGN tt-log.cod-cliente = INTEGER(tt-pedido.cliente)
                               tt-log.mensagem    = STRING(RowErrors.ErrorNumber) + " - ":U + RowErrors.ErrorDescription.
                        IF l-gera-log = YES  THEN DO:    
                            put "2f rowerrors " tt-log.mensagem FORMAT "x(300)" SKIP.
                        END.

                    END.
                END.
            END.
            IF l-gera-log = YES  THEN DO:    
                put "2g" SKIP.
            END.

            FIND FIRST tt-int-ped-item
                 WHERE tt-int-ped-item.nome-abrev   = tt-ped-item.nome-abrev  
                   AND tt-int-ped-item.nr-pedcli    = tt-ped-item.nr-pedcli   
                   AND tt-int-ped-item.nr-sequencia = tt-ped-item.nr-sequencia
                   AND tt-int-ped-item.it-codigo    = tt-ped-item.it-codigo   
                   AND tt-int-ped-item.cod-refer    = tt-ped-item.cod-refer NO-LOCK NO-ERROR.
            IF AVAIL tt-int-ped-item THEN DO:
                FIND FIRST int-ped-item
                     WHERE int-ped-item.nome-abrev   = tt-int-ped-item.nome-abrev  
                       AND int-ped-item.nr-pedcli    = tt-int-ped-item.nr-pedcli   
                       AND int-ped-item.nr-sequencia = tt-int-ped-item.nr-sequencia
                       AND int-ped-item.it-codigo    = tt-int-ped-item.it-codigo   
                       AND int-ped-item.cod-refer    = tt-int-ped-item.cod-refer EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAIL int-ped-item THEN DO:
                    CREATE int-ped-item.
                    ASSIGN int-ped-item.nome-abrev   = tt-int-ped-item.nome-abrev  
                           int-ped-item.nr-pedcli    = tt-int-ped-item.nr-pedcli   
                           int-ped-item.nr-sequencia = tt-int-ped-item.nr-sequencia
                           int-ped-item.it-codigo    = tt-int-ped-item.it-codigo   
                           int-ped-item.cod-refer    = tt-int-ped-item.cod-refer.
                END.

                FIND CURRENT int-ped-item NO-LOCK NO-ERROR.
            END.
            IF l-gera-log = YES  THEN DO:    
                put "2h" SKIP.
            END.

            DELETE tt-ped-item.
        END.
        /*
        run destroyBO in h-bodi154.
        delete procedure h-bodi154.
        */

        IF l-gera-log = YES  THEN DO:    
            put "3 executar-bos"  SKIP.
        END.

        IF CAN-FIND (FIRST tt-log) THEN
           UNDO bloco, LEAVE bloco.
        
     
        FIND FIRST ped-venda NO-LOCK 
             WHERE ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli
               AND ped-venda.nome-abrev = tt-ped-venda.nome-abrev NO-ERROR.

            
     

        IF l-gera-log = YES  THEN DO:    
            put "antes completeorder"  SKIP.
        END.


        run dibo/bodi159com.p persistent set h-bodi159cal.
    
        run completeOrder in h-bodi159cal (input rowid(ped-venda),
                                           OUTPUT TABLE rowerrors).
    
        IF l-gera-log = YES  THEN DO:    
            put "apos completeorder"  SKIP.
        END.

        FOR EACH rowerrors WHERE rowerrors.errornumber <> 8259:  /* credito n∆o aprovado */

            CREATE  tt-log.
            ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
                   tt-log.mensagem              = string(rowerrors.errornumber) + " - " + RowErrors.ERRORDescription +
                                " Pedido: " + ped-venda.nr-pedcli + " Cliente : " + tt-pedido.cliente.


        END.


        IF CAN-FIND(FIRST tt-log)  THEN
           UNDO bloco, LEAVE bloco.
        
        IF p-desc-suspend <> "" THEN DO:
            run dibo/bodi159sus.p persistent set h-bodi159sus.
        
            FOR EACH RowErrors:
                DELETE RowErrors.
            END.
        
            run ValidateSuspension in h-bodi159sus (input rowid(ped-venda),
                                                    OUTPUT TABLE RowErrors).
            for each RowErrors
                where RowErrors.ErrorType   <> "INTERNAL":U
                  and RowErrors.ErrorSubType = "Error":U no-lock:

                CREATE  tt-log.
                ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
                       tt-log.mensagem              = string(RowErrors.errorNumber) + "-" + RowErrors.ERRORDescription +
                                    " Pedido: " + ped-venda.nr-pedcli + " Cliente : " + tt-pedido.cliente .
    

            END.
               
            IF CAN-FIND(FIRST tt-log)  THEN
                UNDO bloco, LEAVE bloco.
    
            run UpdateSuspension in h-bodi159sus(input rowid(ped-venda),
                                                 INPUT 2,
                                                 INPUT p-desc-suspend).
            IF RETURN-VALUE <> "no":U AND
               RETURN-VALUE <> "ok":U THEN DO:

                CREATE  tt-log.
                ASSIGN tt-log.cod-cliente           = INT(tt-pedido.cliente)
                       tt-log.mensagem              = "Problema de integraá∆o entre PORTAL ASTEC e EMS(CONFIRMA-SUSPENSAO)" +
                         " Pedido: " + ped-venda.nr-pedcli + " Cliente : " + tt-pedido.cliente.



                
               UNDO bloco, LEAVE bloco.
            END.
            IF l-gera-log = YES  THEN DO:    
                put "final - dbos"  SKIP.
            END.


            /*
            IF VALID-HANDLE(h-bodi159sus) THEN
               delete procedure h-bodi159sus.
               */
        END.

        /* Neste ponto o Pedido j† est† criado no EMS.         **
        ** Ent∆o ir† criar o registro da tabela de extens∆o, e **
        ** atualizar o Log, informando que n∆o houve erro      */
        FIND FIRST tt-int-ped-venda NO-LOCK
            WHERE  tt-int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

        IF  AVAIL  tt-int-ped-venda THEN DO:
            FIND FIRST int-ped-venda EXCLUSIVE-LOCK
                WHERE  int-ped-venda.nr-pedido   = tt-int-ped-venda.nr-pedido NO-ERROR.
            IF  NOT AVAIL int-ped-venda THEN DO:
                CREATE int-ped-venda.
                ASSIGN int-ped-venda.nr-pedido   = tt-int-ped-venda.nr-pedido.
            END.
            ASSIGN int-ped-venda.cod-estabel = tt-int-ped-venda.cod-estabel
                   int-ped-venda.nr-pedido-telecontrol = tt-int-ped-venda.nr-pedido-telecontrol
                   int-ped-venda.nr-volumes            = "0". /* */
            RELEASE int-ped-venda.

            FIND FIRST tt-log NO-LOCK
                WHERE  tt-log.nr-pedido-telecontrol = tt-int-ped-venda.nr-pedido-telecontrol NO-ERROR.
            IF  NOT AVAIL  tt-log THEN DO:
                CREATE tt-log.
                ASSIGN tt-log.nr-pedido-ems = STRING(ped-venda.nr-pedido)
                       tt-log.mensagem      = "Pedido integrado com sucesso!".
            END.
        END.
    END.
end procedure.

procedure pi-destroi-bos:
    if valid-handle(h-bodi159) and h-bodi159:file-name = "dibo/bodi159.p" and h-bodi159:type = "procedure" then
       run destroyBO in h-bodi159.
    if valid-handle(h-bodi159) then do:
       delete procedure h-bodi159.
       assign h-bodi159 = ?.
    end.

    /* MÇtodo n∆o existe nesta BO */
    /*
    if valid-handle(h-bodi157) and h-bodi157:file-name = "dibo/bodi157.p" and h-bodi157:type = "procedure" then
       run destroyBO in h-bodi157.
       */
    if valid-handle(h-bodi157) then do:
       delete procedure h-bodi157.
       assign h-bodi157 = ?.
    end.

    if valid-handle(h-bodi154) and h-bodi154:file-name = "dibo/bodi154.p" and h-bodi154:type = "procedure" then
       run destroyBO in h-bodi154.
    if valid-handle(h-bodi154) then do:
       delete procedure h-bodi154.
       assign h-bodi154 = ?.
    end.

    IF  VALID-HANDLE(h-esapi018)                     AND
        h-esapi018:TYPE      = "PROCEDURE":U         AND
       (h-esapi018:FILE-NAME = "esapi/esapi018.p":U  OR
        h-esapi018:FILE-NAME = "esapi/esapi018.r":U) THEN
        RUN destroy IN h-esapi018.

    IF VALID-HANDLE(h-esapi018) THEN
        DELETE PROCEDURE h-esapi018.

    ASSIGN h-esapi018 = ?.

    if valid-handle(h-bodi159cal) and h-bodi159cal:file-name = "dibo/bodi159com.p" and h-bodi159cal:type = "procedure" then
       run destroyBO in h-bodi159cal.
    if valid-handle(h-bodi159cal) then do:
       delete procedure h-bodi159cal.
       assign h-bodi159cal = ?.
    end.

    if valid-handle(h-bodi159sus) and h-bodi159sus:file-name = "dibo/bodi159sus.p" and h-bodi159sus:type = "procedure" then
       run destroyBO in h-bodi159sus.
    if valid-handle(h-bodi159sus) then do:
       delete procedure h-bodi159sus.
       assign h-bodi159sus = ?.
    end.

END PROCEDURE.

procedure ReadXML:
     define input  parameter cXML  as LONGCHAR     no-undo.
     define output parameter table for tt-Pedido.
     define output parameter table for tt-Itens.
    
    CREATE X-DOCUMENT hXML.
    hXML:LOAD("LONGCHAR":U, cXML, FALSE).
    
    /*** Caso queira ler o XML direto do arquivo ***/
    /*hXML:LOAD("FILE":U, "C:\temp\teste.xml":U, FALSE).*/
    
    CREATE X-NODEREF  hRoot.
    hXML:GET-DOCUMENT-ELEMENT(hRoot).
    
    CREATE X-NODEREF hTags.
    
    IF hRoot:NAME <> "pedido":U THEN
        RETURN NO-APPLY.
    
    CREATE tt-pedido.
    
    REPEAT j = 1 TO NUM-ENTRIES(hRoot:ATTRIBUTE-NAMES):
        CASE ENTRY(j, hRoot:ATTRIBUTE-NAMES):
            WHEN "cliente":U THEN
                ASSIGN tt-pedido.cliente = hRoot:GET-ATTRIBUTE(ENTRY(j, hRoot:ATTRIBUTE-NAMES)).
            WHEN "transportadora":U THEN
                ASSIGN tt-pedido.transportadora = hRoot:GET-ATTRIBUTE(ENTRY(j, hRoot:ATTRIBUTE-NAMES)).
            WHEN "estabelecimento":U THEN
                ASSIGN tt-pedido.estabelecimento = hRoot:GET-ATTRIBUTE(ENTRY(j, hRoot:ATTRIBUTE-NAMES)).
            WHEN "atendente":U THEN
                ASSIGN tt-pedido.atendente = hRoot:GET-ATTRIBUTE(ENTRY(j, hRoot:ATTRIBUTE-NAMES)).
            WHEN "canalDeVendas":U THEN
                ASSIGN tt-pedido.canalDeVendas = hRoot:GET-ATTRIBUTE(ENTRY(j, hRoot:ATTRIBUTE-NAMES)).
        END CASE.
    END.
    
    REPEAT i = 1 TO hRoot:NUM-CHILDREN:
        l-ok = hRoot:GET-CHILD(hTags, i).
    
        IF NOT l-ok THEN LEAVE.
    
        IF hTags:SUBTYPE <> "element":U THEN NEXT.
    
        IF hTags:NAME <> "diagnostico":U THEN NEXT.
    
        CREATE tt-itens.
    
        REPEAT j = 1 TO NUM-ENTRIES(hTags:ATTRIBUTE-NAMES):
            CASE ENTRY(j, hTags:ATTRIBUTE-NAMES):
                WHEN "codigoItem":U THEN
                    ASSIGN tt-itens.codigoItem = hTags:GET-ATTRIBUTE(ENTRY(j, hTags:ATTRIBUTE-NAMES)).
                WHEN "quantidade":U THEN
                    ASSIGN tt-itens.quantidade = hTags:GET-ATTRIBUTE(ENTRY(j, hTags:ATTRIBUTE-NAMES)).
                WHEN "numeroOS":U THEN
                    ASSIGN tt-itens.numeroOS = hTags:GET-ATTRIBUTE(ENTRY(j, hTags:ATTRIBUTE-NAMES)).
                WHEN "id":U THEN
                    ASSIGN tt-itens.id = hTags:GET-ATTRIBUTE(ENTRY(j, hTags:ATTRIBUTE-NAMES)).
                WHEN "codigoProdutoPrincipal":U THEN
                    ASSIGN tt-itens.codigoProdutoPrincipal = hTags:GET-ATTRIBUTE(ENTRY(j, hTags:ATTRIBUTE-NAMES)).

                    
            END CASE.
        END.
    END.
    
    DELETE OBJECT hXML.
    DELETE OBJECT hRoot.
    DELETE OBJECT hTags.
    
/*     FOR FIRST tt-pedido:                      */
/*         DISPLAY tt-pedido                     */
/*             WITH 1 COLUMN SCROLLABLE FRAME a. */
/*                                               */
/*         FOR EACH tt-itens:                     */
/*             DISPLAY tt-itens                   */
/*                 WITH DOWN SCROLLABLE FRAME b. */
/*         END.                                  */
/*     END.                                      */
/*                                               */
      
end procedure.
