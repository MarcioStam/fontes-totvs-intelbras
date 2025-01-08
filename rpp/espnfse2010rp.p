/**************************************************************************************************
** PROGRAMA...: espnfse2010rp.p - Exportacao de dados da RPS para CW-NFSe
** AUTOR......: Ivonei Vock - CW
** DATA.......: 01/09/2010
** ATUALIZACAO: 17/09/2012
**************************************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i espnfse2010 3.00.00.000}  /*** 010000 ***/

/** DEFINICAO: Temp-tables **/
{rpp/espnfse2010.i}

/** DEFINICAO: Pre-processadores **/
{cdp/cdcfgdis.i}

DEFINE TEMP-TABLE tt-digita NO-UNDO 
    FIELD ordem            AS INTEGER   FORMAT ">>>>9"
    FIELD exemplo          AS CHARACTER FORMAT "x(30)"
    INDEX id ordem.

DEF TEMP-TABLE tt-raw-digita
   FIELD raw-digita      AS RAW.

/** DEFINICAO: Parametros **/
DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/** DEFINICAO: Variaveis Gerais **/
DEF VAR vc-nome-arquivo      AS CHAR FORMAT "x(40)"        NO-UNDO.
DEF VAR vc-arquivo-temp      AS CHAR                       NO-UNDO.
DEF VAR vc-arquivo-real      AS CHAR                       NO-UNDO.
DEF VAR vc-diretorio-real    AS CHAR                       NO-UNDO.
DEF VAR vc-status-rps        AS CHAR FORMAT "x(14)"        NO-UNDO.
DEF VAR vi-num-linha         AS INT                        NO-UNDO.
DEF VAR vi-numero            AS INT                        NO-UNDO.
DEF VAR vi-id-transacao      AS INT                        NO-UNDO.
DEF VAR vi-status-conv       AS INT                        NO-UNDO.
DEF VAR vc-obs-cancela       AS CHAR                       NO-UNDO.
DEF VAR vc-nr-nota-subs      AS CHAR                       NO-UNDO.
DEF VAR vd-total-servico     AS DEC FORMAT ">>>>>>>>>9.99" NO-UNDO.
DEF VAR vc-nr-rps-subs       AS CHAR FORMAT "x(15)"        NO-UNDO.
DEF VAR vc-serie-subs        AS CHAR FORMAT "x(5)"         NO-UNDO.
DEF VAR vc-nr-nfse           AS CHAR FORMAT "x(16)"        NO-UNDO.
DEF VAR vc-cd-verificacao    AS CHAR FORMAT "x(16)"        NO-UNDO.
DEFINE VARIABLE c-desc-servico AS CHARACTER FORMAT "x(100)"  NO-UNDO.
DEFINE VARIABLE i-total      AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont       AS INTEGER     NO-UNDO.
DEF VAR c-insc-aux         AS   CHAR                     NO-UNDO FORMAT "x(08)".
DEF VAR c-cgc-aux          AS   CHAR                     NO-UNDO .
DEF VAR c-data             AS   CHAR                     NO-UNDO FORMAT "x(08)".
DEF VAR c-rua              AS   CHAR                     NO-UNDO FORMAT "x(50)".  
DEF VAR c-numero           AS   CHAR                     NO-UNDO FORMAT "x(09)".
def var i-numero           as   int                      no-undo.
DEF VAR c-complemento      AS   CHAR                     NO-UNDO.
DEF VAR c-campoPipe        AS   CHAR                     NO-UNDO FORMAT "X(1000)".
DEF VAR i-remessa          AS   INT                      NO-UNDO FORMAT "99999999999".
DEF VAR i-qt-linhas-reg-2  AS   INT                      NO-UNDO.
DEF VAR i-total-linhas     AS   INT                      NO-UNDO.
DEF VAR i-qt-linhas-reg-3  AS   INT                      NO-UNDO.
DEF VAR i                  AS   INT                      NO-UNDO.
DEF VAR cont               AS   INT                      NO-UNDO.
DEF VAR colIni             AS   INT                      NO-UNDO.
DEF VAR i-aux              AS   INT                      NO-UNDO.
DEF VAR h-cdapi704         AS   HANDLE                   NO-UNDO.
DEF VAR h-acomp            AS   HANDLE                   NO-UNDO.
DEF VAR de-vl-tot-serv     LIKE it-nota-fisc.vl-tot-item NO-UNDO.     
DEF VAR de-vl-tot-ret      LIKE it-nota-fisc.vl-tot-item NO-UNDO.     
DEF VAR de-vl-tot-serv-rps LIKE it-nota-fisc.vl-tot-item NO-UNDO.
DEF VAR c-cod-servico-aux  AS   CHAR                     NO-UNDO.
DEF VAR i-cdn-munpio-ibge  AS INTEGER                    NO-UNDO.
DEF VAR i-cdn-estab-ibge   AS INTEGER                    NO-UNDO.
DEF VAR c-nat-op-municipal AS CHAR FORMAT "x(04)"        NO-UNDO.
DEF VAR c-nome-temp        AS CHAR FORMAT "x(300)"       NO-UNDO.

DEF VAR i-nome             AS INT                        NO-UNDO.
DEF VAR i-seq-print        AS INT                        NO-UNDO.
DEF VAR c-descricao-serv   AS CHAR                       NO-UNDO.

DEF VAR d-vl-iss           AS DEC FORMAT ">>>>>>>9.99"   NO-UNDO.
DEF VAR d-vl-irrf          AS DEC FORMAT ">>>>>>>9.99"   NO-UNDO.
DEF VAR d-vl-pis           AS DEC FORMAT ">>>>>>>9.99"   NO-UNDO.
DEF VAR d-vl-cofins        AS DEC FORMAT ">>>>>>>9.99"   NO-UNDO.
DEF VAR d-vl-csll          AS DEC FORMAT ">>>>>>>9.99"   NO-UNDO.
DEF VAR d-vl-inss          AS DEC FORMAT ">>>>>>>9.99"   NO-UNDO.
DEF VAR d-vl-iss-ret       AS DEC FORMAT ">>>>>>>9.99"   NO-UNDO.

/** DEFINICAO: Stream do arquivo de exportacao **/
DEF STREAM s-saida.

/** DEFINICAO: Buffers **/
DEF BUFFER bf-nota-fiscal         FOR nota-fiscal.
DEF BUFFER bf-esp-ext-nota-fiscal FOR esp-ext-nota-fiscal.

/** DEFINICAO: Forms do relatorio **/
FORM tt-rps.cod-estabel   COLUMN-LABEL "Estab"
     tt-rps.serie         COLUMN-LABEL "SÇrie"
     tt-rps.nr-rps        COLUMN-LABEL "Nr RPS"
     tt-rps.dt-emis-rps   COLUMN-LABEL "Dt Emiss∆o"
     tt-rps.vl-servico    COLUMN-LABEL "Valor Serviáo"
     vc-nome-arquivo      COLUMN-LABEL "Arquivo"
     vc-status-rps        COLUMN-LABEL "Status"
    WITH DOWN STREAM-IO NO-BOX WIDTH 132 FRAME f-rps.
     
FORM tt-erro.cod-estabel   COLUMN-LABEL "Estab"
     tt-erro.serie         COLUMN-LABEL "SÇrie"
     tt-erro.nr-rps        COLUMN-LABEL "Nr RPS"
     tt-erro.cod-erro      COLUMN-LABEL "Erro"
     tt-erro.des-erro      COLUMN-LABEL "Descriá∆o"
    WITH DOWN STREAM-IO NO-BOX WIDTH 132 FRAME f-erro.

/*****************************************************************************************************************************
########################################### I N I C I O    D O    R E L A T O R I O ##########################################
*****************************************************************************************************************************/

/** DEFINICAO: Tela de acompanhamento **/
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Exportando_RPS *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE ).

/** REGRA: Tabela de parametros do relatorio e global **/
FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST tt-param             NO-ERROR.

/** DEFINICAO: Padroes do FRW de relatorio **/
{include/i-rpvar.i}
{utp/ut-liter.i Exportaá∆o_de_RPS_-_Recibo_Provis¢rio_Serviáo * r}
ASSIGN c-programa = "ESPNFSE2010"
       c-versao   = c-prg-vrs
       c-revisao  = "000"
       c-titulo-relat = TRIM(RETURN-VALUE).

{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

/** REGRA: API para separacao de endereco **/
RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.


/*****************************************************************************************************************************
############################################## G E R A C A O   D O S   D A D O S #############################################
*****************************************************************************************************************************/

FOR EACH esp-ext-ser-estab NO-LOCK
   WHERE esp-ext-ser-estab.cod-estabel >= tt-param.cod-estabel-ini
     AND esp-ext-ser-estab.cod-estabel <= tt-param.cod-estabel-fim
     AND esp-ext-ser-estab.serie       >= tt-param.serie-ini
     AND esp-ext-ser-estab.serie       <= tt-param.serie-fim
     AND esp-ext-ser-estab.emite-rps,
    EACH nota-fiscal NO-LOCK
   WHERE nota-fiscal.cod-estabel   = esp-ext-ser-estab.cod-estabel
     AND nota-fiscal.serie         = esp-ext-ser-estab.serie
     AND nota-fiscal.nr-nota-fis  >= tt-param.nr-rps-ini
     AND nota-fiscal.nr-nota-fis  <= tt-param.nr-rps-fim
     AND nota-fiscal.dt-emis-nota >= tt-param.dt-emis-ini
     AND nota-fiscal.dt-emis-nota <= tt-param.dt-emis-fim
     AND nota-fiscal.nat-operacao >= tt-param.nat-oper-ini
     AND nota-fiscal.nat-operacao <= tt-param.nat-oper-fim:

    RUN pi-acompanhar IN h-acomp (INPUT "Gerando dados: " + esp-ext-ser-estab.serie + "/" + esp-ext-ser-estab.cod-estabel).
    
    /** REGRA: Considera Somente RPS com ERROS **/
    IF  tt-param.erros THEN DO:

        FIND FIRST esp-ext-nota-fiscal NO-LOCK
             WHERE esp-ext-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
               AND esp-ext-nota-fiscal.serie       = nota-fiscal.serie
               AND esp-ext-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.

        /** RPS Pendente **/
        IF  NOT AVAIL esp-ext-nota-fiscal THEN
            NEXT.
        
        IF  nota-fiscal.dt-cancela <> ? THEN DO:
            /** RPS Erro de Cancelamento **/
            IF  esp-ext-nota-fiscal.int-1 <> 3 AND
                NOT CAN-FIND(FIRST esp-ext-nota-fiscal-erro
                             WHERE esp-ext-nota-fiscal-erro.cod-estabel = nota-fiscal.cod-estabel
                               AND esp-ext-nota-fiscal-erro.serie       = nota-fiscal.serie
                               AND esp-ext-nota-fiscal-erro.nr-nota-fis = nota-fiscal.nr-nota-fis
                               AND esp-ext-nota-fiscal-erro.tipo-erro  <> "IM") THEN
                NEXT.
        END.
        ELSE DO:
            /** RPS Erro de Convers∆o **/
            IF  esp-ext-nota-fiscal.nr-nota-el       = "" AND
                esp-ext-nota-fiscal.cod-autentic-nfe = "" AND
                NOT CAN-FIND(FIRST esp-ext-nota-fiscal-erro
                             WHERE esp-ext-nota-fiscal-erro.cod-estabel = nota-fiscal.cod-estabel
                               AND esp-ext-nota-fiscal-erro.serie       = nota-fiscal.serie
                               AND esp-ext-nota-fiscal-erro.nr-nota-fis = nota-fiscal.nr-nota-fis
                               AND esp-ext-nota-fiscal-erro.tipo-erro  <> "IM") THEN
                NEXT.
        END.
    END.


    /** REGRA: Validacoes basicas da nota-fiscal **/
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
    IF  NOT AVAIL emitente THEN DO:
        RUN pi-gera-erro IN THIS-PROCEDURE (INPUT nota-fiscal.cod-estabel,
                                            INPUT nota-fiscal.nr-nota-fis,
                                            INPUT nota-fiscal.serie,
                                            INPUT "E02",
                                            INPUT "Cliente da nota n∆o foi encontrado: " + STRING(nota-fiscal.cod-emitente)).
    END.

    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.
    IF  NOT AVAIL estabelec THEN DO:
        RUN pi-gera-erro IN THIS-PROCEDURE (INPUT nota-fiscal.cod-estabel,
                                            INPUT nota-fiscal.nr-nota-fis,
                                            INPUT nota-fiscal.serie,
                                            INPUT "E03",
                                            INPUT "Estabelecimento da nota n∆o foi encontrado: " + STRING(nota-fiscal.cod-estabel)).
    END.

    IF  AVAIL emitente THEN DO:

        FIND FIRST mgcad.pais NO-LOCK
             WHERE mgcad.pais.nome-pais = emitente.pais NO-ERROR.
        IF  NOT AVAIL emitente THEN DO:
            RUN pi-gera-erro IN THIS-PROCEDURE (INPUT nota-fiscal.cod-estabel,
                                                INPUT nota-fiscal.nr-nota-fis,
                                                INPUT nota-fiscal.serie,
                                                INPUT "E04",
                                                INPUT "Pa°s do cliente n∆o Ç v†lido: " + STRING(emitente.pais)).
        END.
    END.

    /** REGRA: Valida descricao do servico **/
    IF  esp-ext-ser-estab.log-1 = NO                   AND      /*Imprime Fatura   */
        SUBSTRING(esp-ext-ser-estab.char-1,1,1) <> "S" AND      /*Imprime Desc Item*/
        SUBSTRING(esp-ext-ser-estab.char-1,2,1) <> "S" THEN DO: /*Imprime Obs Nota */

        RUN pi-gera-erro IN THIS-PROCEDURE (INPUT nota-fiscal.cod-estabel,
                                            INPUT nota-fiscal.nr-nota-fis,
                                            INPUT nota-fiscal.serie,
                                            INPUT "E09",
                                            INPUT "A RPS n∆o possui descriá∆o do Serviáo. Parametrizar a descriá∆o atravÇs do programa ESPNFSE2040").
    END.

    /** REGRA: Existindo erro basico, passa para proxima nota-fiscal **/
    FIND FIRST tt-erro
         WHERE tt-erro.cod-estabel = nota-fiscal.cod-estabel
           AND tt-erro.serie       = nota-fiscal.serie
           AND tt-erro.nr-rps      = nota-fiscal.nr-nota-fis NO-ERROR.
    IF  AVAIL tt-erro THEN
        NEXT.

    /** REGRA: Gerar tabela especifica da nota-fiscal **/
    FIND FIRST esp-ext-nota-fiscal EXCLUSIVE-LOCK
         WHERE esp-ext-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
           AND esp-ext-nota-fiscal.serie       = nota-fiscal.serie
           AND esp-ext-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.

    IF  NOT AVAIL esp-ext-nota-fiscal THEN DO:
        CREATE esp-ext-nota-fiscal.
        ASSIGN esp-ext-nota-fiscal.cod-estabel       = nota-fiscal.cod-estabel
               esp-ext-nota-fiscal.serie             = nota-fiscal.serie
               esp-ext-nota-fiscal.nr-nota-fis       = nota-fiscal.nr-nota-fis
               esp-ext-nota-fiscal.hr-emis-nota      = STRING(TIME,"HH:MM:SS").
    END.

    /** REGRA: Se a nota nao foi gerada pelo FT4003/FT4004, nao gerou a tabela
               esp-ext-wt-it-docto, logo, esta rotina vai sugerir cidade, estado
               e pais padrao conforme parametro: emitente ou estabelecimento **/
    IF  esp-ext-nota-fiscal.cidade = "" THEN DO:

        FIND FIRST esp-ext-wt-it-docto NO-LOCK
             WHERE esp-ext-wt-it-docto.nr-nota-fis = nota-fiscal.nr-nota-fis
               AND esp-ext-wt-it-docto.serie       = nota-fiscal.serie
               AND esp-ext-wt-it-docto.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.
        
        /** RERGA: Local prestacao servico informado na nota **/
        IF  AVAIL esp-ext-wt-it-docto        AND
            esp-ext-wt-it-docto.cidade <> "" THEN DO:

            ASSIGN esp-ext-nota-fiscal.cidade = esp-ext-wt-it-docto.cidade
                   esp-ext-nota-fiscal.estado = esp-ext-wt-it-docto.estado
                   esp-ext-nota-fiscal.pais   = esp-ext-wt-it-docto.pais.
        END.
        ELSE DO:
            /** RERGA: Local prestacao servico padrao Cliente **/
            IF  esp-ext-ser-estab.local-padrao-prest-serv = 2 THEN DO:
                ASSIGN esp-ext-nota-fiscal.cidade = emitente.cidade
                       esp-ext-nota-fiscal.estado = emitente.estado
                       esp-ext-nota-fiscal.pais   = emitente.pais.
            END.
            /** RERGA: Local prestacao servico padrao Estabelecimento **/
            ELSE DO:
                ASSIGN esp-ext-nota-fiscal.cidade = estabelec.cidade
                       esp-ext-nota-fiscal.estado = estabelec.estado
                       esp-ext-nota-fiscal.pais   = estabelec.pais.
            END.
        END.
    END.

    /** REGRA: Procura registro da RPS na temp-table **/
    FIND FIRST tt-rps
         WHERE tt-rps.cod-estabel = nota-fiscal.cod-estabel
           AND tt-rps.serie       = nota-fiscal.serie
           AND tt-rps.nr-rps      = nota-fiscal.nr-nota-fis NO-ERROR.

    /** REGRA: Registro da RPS **/
    IF  NOT AVAIL tt-rps THEN DO:

        ASSIGN vi-id-transacao   = 0
               vi-status-conv    = 0
               vc-obs-cancela    = ""
               vc-nr-nota-subs   = ""
               vc-nr-rps-subs    = ""
               vc-serie-subs     = ""
               vc-nr-nfse        = ""
               vc-cd-verificacao = "".

        /** REGRA: Solicita cancelamento **/
        IF  nota-fiscal.dt-cancela <> ? THEN DO:

            /** REGRA: Exporta cancelamento? **/
            IF  SUBSTRING(esp-ext-ser-estab.char-1,3,1) = "S" THEN DO:

                /** REGRA: RPS processada **/
                IF  esp-ext-nota-fiscal.processada THEN
                    ASSIGN vi-id-transacao   = 3
                           vc-obs-cancela    = nota-fiscal.desc-cancela
                           vc-nr-nfse        = esp-ext-nota-fiscal.nr-nota-el
                           vc-cd-verificacao = esp-ext-nota-fiscal.cod-autentic-nfe.
    
                /** REGRA: RPS nao processada **/
                ELSE
                    ASSIGN vi-id-transacao = 1
                           vi-status-conv  = 4
                           vc-obs-cancela  = nota-fiscal.desc-cancela.
    
                /** REGRA: Desconsidera o que ja foi enviado **/
                IF  NOT tt-param.enviados          AND
                    esp-ext-nota-fiscal.int-1 >= 2 THEN
                    ASSIGN vi-id-transacao = 0.
            END.
        END.

        /** REGRA: Solicita envio **/
        ELSE DO:

            /** REGRA: Substituicao de nota **/
            IF  esp-ext-nota-fiscal.nr-nota-fis-subs <> "" THEN DO:
    
                ASSIGN vi-id-transacao = 1
                       vc-nr-nota-subs = esp-ext-nota-fiscal.nr-nota-fis-subs.

                FOR FIRST bf-esp-ext-nota-fiscal NO-LOCK
                    WHERE bf-esp-ext-nota-fiscal.nr-nota-el = esp-ext-nota-fiscal.nr-nota-fis-subs,
                    FIRST bf-nota-fiscal NO-LOCK OF bf-esp-ext-nota-fiscal:
                    
                    ASSIGN vc-obs-cancela = bf-nota-fiscal.desc-cancela.

                    /*REGRA: substituicao Mastersaf V3*/
                    ASSIGN vc-nr-rps-subs = bf-esp-ext-nota-fiscal.nr-nota-fis
                           vc-serie-subs  = bf-esp-ext-nota-fiscal.serie.
                END.
            END.

            /** REGRA: Conversao de RPS **/
            ELSE
                ASSIGN vi-id-transacao = 1.

            /** REGRA: Desconsidera o que ja foi enviado **/
            IF  NOT tt-param.enviados          AND
                esp-ext-nota-fiscal.processada THEN
                ASSIGN vi-id-transacao = 0.
        END.

        /** REGRA: Desconsiderar registros ja enviados **/
        IF  vi-id-transacao = 0 THEN
            NEXT.
            
        /** REGRA: Cria registro RPS **/
        CREATE tt-rps.
        ASSIGN tt-rps.serie          = nota-fiscal.serie      
               tt-rps.cod-estabel    = nota-fiscal.cod-estabel
               tt-rps.nr-rps         = nota-fiscal.nr-nota-fis
               tt-rps.dt-emis-rps    = nota-fiscal.dt-emis-nota
               tt-rps.vl-servico     = nota-fiscal.vl-tot-nota
               tt-rps.observ-nota    = nota-fiscal.observ-nota
               tt-rps.cod-prestador  = esp-ext-ser-estab.cod-prestador
               tt-rps.cod-emitente   = emitente.cod-emitente
               tt-rps.id-transacao   = vi-id-transacao
               tt-rps.i-status-conv  = vi-status-conv
               tt-rps.nr-nota-subs   = vc-nr-nota-subs
               tt-rps.motivo-cancela = vc-obs-cancela
               tt-rps.estab-razao    = estabelec.nome
               tt-rps.estab-endereco = estabelec.endereco
               tt-rps.estab-bairro   = estabelec.bairro
               tt-rps.estab-cep      = REPLACE(STRING(estabelec.cep),".","")
               tt-rps.estab-cep      = REPLACE(tt-rps.estab-cep,"-","")
               tt-rps.estab-cep      = RIGHT-TRIM(tt-rps.estab-cep)
               tt-rps.estab-estado   = estabelec.estado
               tt-rps.estab-ins      = estabelec.ins-municipal
               tt-rps.subst-nr-rps   = vc-nr-rps-subs
               tt-rps.subst-serie    = vc-serie-subs
               tt-rps.nr-nfse        = vc-nr-nfse
               tt-rps.cd-verificacao = vc-cd-verificacao.

        /** REGRA: CNPJ do prestador **/
        ASSIGN tt-rps.estab-cgc = REPLACE(estabelec.cgc,".","")
               tt-rps.estab-cgc = REPLACE(tt-rps.estab-cgc,"/","")
               tt-rps.estab-cgc = REPLACE(tt-rps.estab-cgc,"-","")
               tt-rps.estab-cgc = RIGHT-TRIM(tt-rps.estab-cgc).
        
        /** REGRA: Cidade do prestador **/
        FIND FIRST mgcad.cidade NO-LOCK
             WHERE mgcad.cidade.cidade = estabelec.cidade
               AND mgcad.cidade.estado = estabelec.estado NO-ERROR.
        IF  AVAIL mgcad.cidade THEN
            ASSIGN tt-rps.estab-ibge = mgcad.cidade.cdn-munpio-ibge.
        ELSE DO:
            RUN pi-gera-erro IN THIS-PROCEDURE (INPUT tt-rps.cod-estabel,
                                                INPUT tt-rps.nr-rps,
                                                INPUT tt-rps.serie,
                                                INPUT "CW20",
                                                INPUT "Cidade do prestador n∆o foi localizada: " + estabelec.cidade + "/" + estabelec.estado).
        END.

        /** REGRA: IBGE do prestador **/
        FIND FIRST esp-ext-municipio-ibge NO-LOCK
             WHERE esp-ext-municipio-ibge.cod-ibge = tt-rps.estab-ibge NO-ERROR.
        IF  NOT AVAIL esp-ext-municipio-ibge THEN
            RUN pi-gera-erro IN THIS-PROCEDURE (INPUT tt-rps.cod-estabel,
                                                INPUT tt-rps.nr-rps,
                                                INPUT tt-rps.serie,
                                                INPUT "CW21",
                                                INPUT "C¢digo IBGE do prestador inv†lido: " + STRING(tt-rps.estab-ibge)).

        /** REGRA: Cidade do local de prestacao do servico **/
        FIND FIRST mgcad.cidade NO-LOCK
             WHERE mgcad.cidade.cidade = esp-ext-nota-fiscal.cidade
               AND mgcad.cidade.estado = esp-ext-nota-fiscal.estado NO-ERROR.
        IF  AVAIL mgcad.cidade THEN
            ASSIGN tt-rps.cod-pais        = mgcad.cidade.pais
                   tt-rps.servico-ibge    = mgcad.cidade.cdn-munpio-ibge
                   tt-rps.ibge-incidencia = tt-rps.servico-ibge.
        ELSE DO:
            RUN pi-gera-erro IN THIS-PROCEDURE (INPUT tt-rps.cod-estabel,
                                                INPUT tt-rps.nr-rps,
                                                INPUT tt-rps.serie,
                                                INPUT "CW21",
                                                INPUT "Cidade do local de prestaá∆o do serviáo n∆o foi localizada: " + esp-ext-nota-fiscal.cidade + "/" + esp-ext-nota-fiscal.estado).
        END.

        /** REGRA: IBGE do local de prestacao do servico **/
        FIND FIRST esp-ext-municipio-ibge NO-LOCK
             WHERE esp-ext-municipio-ibge.cod-ibge = tt-rps.servico-ibge NO-ERROR.
        IF  NOT AVAIL esp-ext-municipio-ibge THEN
            RUN pi-gera-erro IN THIS-PROCEDURE (INPUT tt-rps.cod-estabel,
                                                INPUT tt-rps.nr-rps,
                                                INPUT tt-rps.serie,
                                                INPUT "CW21",
                                                INPUT "C¢digo IBGE do local de prestaá∆o do serviáo inv†lido: " + STRING(tt-rps.servico-ibge)).

        /** REGRA: Dados do cliente **/
        ASSIGN tt-rps.cli-cgc           = REPLACE(emitente.cgc,".","")
               tt-rps.cli-cgc           = REPLACE(tt-rps.cli-cgc,"/","")
               tt-rps.cli-cgc           = REPLACE(tt-rps.cli-cgc,"-","")
               tt-rps.cli-cgc           = RIGHT-TRIM(tt-rps.cli-cgc)
               tt-rps.cli-razao         = emitente.nome-emit
               tt-rps.cli-email         = emitente.e-mail
               tt-rps.cli-ins-municipal = emitente.ins-municipal
               tt-rps.cli-ins-estadual  = emitente.ins-estadual
               tt-rps.cli-telefone      = emitente.telefone[1].


        /** REGRA: Tipo Pessoa Cliente **/
        IF  SUBSTRING(esp-ext-ser-estab.char-1,5,1) = "2" THEN DO: /*Mastersaf V3*/

            ASSIGN tt-rps.cli-pessoa = IF      emitente.natureza = 1 THEN 1 /*PF*/
                                       ELSE IF emitente.natureza = 2 THEN 2 /*PJ*/
                                       ELSE 4. /*ESTRANGEIRO*/

            IF  emitente.natureza = 1        AND
                emitente.cgc = "99999999999" THEN
                ASSIGN tt-rps.cli-pessoa = 3. /*N INFORMADO*/
        END.
        ELSE DO:  /*CW NFSe*/

            ASSIGN tt-rps.cli-pessoa = IF emitente.natureza = 1 THEN 0 /*PF*/
                                       ELSE 1 /*PJ*/.

            IF  emitente.natureza = 1        AND
                emitente.cgc = "99999999999" THEN
                ASSIGN tt-rps.cli-pessoa = 2. /*N INFORMADO*/
        END.
            

        /** REGRA: Endereco do cliente ("" ou "1" = Nota Fiscal / "2" Cadastro Emitente, conf espnfse2040) **/
        IF  SUBSTRING(esp-ext-ser-estab.char-1,4,1) = "2" THEN
            ASSIGN tt-rps.cli-end-bairro    = emitente.bairro
                   tt-rps.cli-end-cidade    = emitente.cidade
                   tt-rps.cli-end-estado    = emitente.estado
                   tt-rps.cli-end-cep       = REPLACE(emitente.cep,".","")
                   tt-rps.cli-end-cep       = REPLACE(tt-rps.cli-end-cep,"-","")
                   tt-rps.cli-end-cep       = RIGHT-TRIM(tt-rps.cli-end-cep)
                   tt-rps.cli-end-rua       = emitente.endereco.
        ELSE
            ASSIGN tt-rps.cli-end-bairro    = nota-fiscal.bairro
                   tt-rps.cli-end-cidade    = nota-fiscal.cidade
                   tt-rps.cli-end-estado    = nota-fiscal.estado
                   tt-rps.cli-end-cep       = REPLACE(nota-fiscal.cep,".","")
                   tt-rps.cli-end-cep       = REPLACE(tt-rps.cli-end-cep,"-","")
                   tt-rps.cli-end-cep       = RIGHT-TRIM(tt-rps.cli-end-cep)
                   tt-rps.cli-end-rua       = nota-fiscal.endereco.

        /** REGRA: Se cliente for estrangeiro, enviar o cod-cliente no campo cnpj **/
        IF  emitente.natureza = 3 THEN
            ASSIGN tt-rps.cli-cgc = STRING(emitente.cod-emitente).
                                                  
        /** REGRA: Separacao do endereco do cliente **/
        RUN pi-trata-endereco IN h-cdapi704 (INPUT  tt-rps.cli-end-rua,
                                             OUTPUT tt-rps.cli-end-rua,
                                             OUTPUT tt-rps.cli-end-numero,
                                             OUTPUT tt-rps.cli-end-complemento).

        /** REGRA: Numero nao pode ser nulo **/
        ASSIGN vi-numero = INT(tt-rps.cli-end-numero) NO-ERROR.
        IF  ERROR-STATUS:ERROR THEN
            ASSIGN tt-rps.cli-end-numero = '0'.
        IF  tt-rps.cli-end-numero = '' THEN
            ASSIGN tt-rps.cli-end-numero = '0'.
                                                  
        /** REGRA: Cidade do cliente **/
        FIND FIRST mgcad.cidade NO-LOCK
             WHERE mgcad.cidade.cidade = tt-rps.cli-end-cidade
               AND mgcad.cidade.estado = tt-rps.cli-end-estado NO-ERROR.
        IF  AVAIL mgcad.cidade THEN
            ASSIGN tt-rps.cli-ibge = mgcad.cidade.cdn-munpio-ibge.
        ELSE DO:
            RUN pi-gera-erro IN THIS-PROCEDURE (INPUT tt-rps.cod-estabel,
                                                INPUT tt-rps.nr-rps,
                                                INPUT tt-rps.serie,
                                                INPUT "CW30",
                                                INPUT "Cidade do cliente n∆o foi localizada: " + tt-rps.cli-end-cidade + "/" + tt-rps.cli-end-estado).
        END.

        /** REGRA: IBGE do cliente **/
        FIND FIRST esp-ext-municipio-ibge NO-LOCK
             WHERE esp-ext-municipio-ibge.cod-ibge = tt-rps.cli-ibge NO-ERROR.
        IF  NOT AVAIL esp-ext-municipio-ibge THEN
            RUN pi-gera-erro IN THIS-PROCEDURE (INPUT tt-rps.cod-estabel,
                                                INPUT tt-rps.nr-rps,
                                                INPUT tt-rps.serie,
                                                INPUT "CW31",
                                                INPUT "C¢digo IBGE do cliente inv†lido: " + STRING(tt-rps.cli-ibge)).
        
        /** REGRA: ITENS/SERVICOS da RPS **/
        FOR EACH it-nota-fisc NO-LOCK
           WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
             AND it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
             AND it-nota-fisc.serie       = nota-fiscal.serie,
           FIRST ITEM NO-LOCK
           WHERE ITEM.it-codigo = it-nota-fisc.it-codigo:

            /** REGRA: Informacoes gerais da RPS **/
            ASSIGN tt-rps.cod-servico = it-nota-fisc.cod-servico
                   tt-rps.vl-iss-base = tt-rps.vl-iss-base
                                      + it-nota-fisc.vl-biss-it.

            /** REGRA: Aliquota ISS retido ou nao **/
            IF  it-nota-fisc.aliquota-iss <> 0 THEN
                ASSIGN tt-rps.aliq-iss = it-nota-fisc.aliquota-iss. /*ISS Normal*/
            ELSE
                ASSIGN tt-rps.aliq-iss = DEC(SUBSTRING(it-nota-fisc.char-2,204,10)). /*ISS Retido*/

            /** REGRA: Carrega os itens da RPS **/
            CREATE tt-rps-item.
            ASSIGN tt-rps-item.serie        = it-nota-fisc.serie
                   tt-rps-item.nr-rps       = it-nota-fisc.nr-nota-fis
                   tt-rps-item.cod-estabel  = it-nota-fisc.cod-estabel
                   tt-rps-item.it-codigo    = it-nota-fisc.it-codigo
                   tt-rps-item.nr-seq-fat   = it-nota-fisc.nr-seq-fat
                   tt-rps-item.desc-item    = item.desc-item
                   tt-rps-item.quantidade   = it-nota-fisc.qt-fatura[1]
                   tt-rps-item.vl-preuni    = it-nota-fisc.vl-preuni
                   tt-rps-item.vl-tot-item  = it-nota-fisc.vl-tot-item
                   tt-rps-item.vl-deducao   = 0
                   tt-rps-item.vl-base-iss  = it-nota-fisc.vl-biss-it
                   tt-rps-item.un-medida[1] = it-nota-fisc.un-fatur[1]
                   tt-rps-item.desc-vl-item = " R$ "
                                            + TRIM(STRING(it-nota-fisc.vl-tot-item,"->>>>,>>>,>>>,>>9.99")).

            /** REGRA: Descricao do servico do item **/
            RUN pi-descricao-servico (OUTPUT tt-rps-item.desc-servico).

            /** REGRA: Retencoes do servico **/
            ASSIGN tt-rps-item.vl-irf     = it-nota-fisc.vl-irf-it
                   tt-rps-item.vl-pis     = it-nota-fisc.val-retenc-pis
                   tt-rps-item.vl-cofins  = it-nota-fisc.val-retenc-cofins
                   tt-rps-item.vl-csll    = it-nota-fisc.val-retenc-csll
                   tt-rps-item.vl-iss     = it-nota-fisc.vl-iss-it
                   tt-rps-item.vl-inss    = it-nota-fisc.vl-ir-adic
                   tt-rps-item.vl-iss-ret = DEC(SUBSTR(it-nota-fisc.char-2,218,14))
                   tt-rps.vl-irf          = tt-rps.vl-irf        + tt-rps-item.vl-irf    
                   tt-rps.vl-pis          = tt-rps.vl-pis        + tt-rps-item.vl-pis    
                   tt-rps.vl-cofins       = tt-rps.vl-cofins     + tt-rps-item.vl-cofins 
                   tt-rps.vl-csll         = tt-rps.vl-csll       + tt-rps-item.vl-csll   
                   tt-rps.vl-iss          = tt-rps.vl-iss        + tt-rps-item.vl-iss    
                   tt-rps.vl-inss         = tt-rps.vl-inss       + tt-rps-item.vl-inss   
                   tt-rps.vl-iss-retido   = tt-rps.vl-iss-retido + tt-rps-item.vl-iss-ret.

            /** REGRA: Valida natureza de operacao do item **/
            FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao NO-ERROR.
            IF  NOT AVAIL natur-oper THEN DO:
    
                RUN pi-gera-erro IN THIS-PROCEDURE (INPUT nota-fiscal.cod-estabel,
                                                    INPUT nota-fiscal.nr-nota-fis,
                                                    INPUT nota-fiscal.serie,
                                                    INPUT "E05",
                                                    INPUT "Natureza de operaá∆o do item n∆o Ç v†lida. Item: " + STRING(it-nota-fisc.it-codigo) + " / Natureza: " + STRING(it-nota-fisc.nat-operacao)).
            END.
        END.

        /** REGRA: Tributacao do servico da RPS para Curitiba-PR **/
        IF  tt-rps.estab-ibge = 4106902 THEN DO:

            /*Aliquota do ISS = 0, deve enviar operaá∆o como isená∆o (3)*/
            IF  tt-rps.aliq-iss = 0 THEN DO:

                FIND FIRST int-nota-rps
                    WHERE int-nota-rps.cod-estabel = nota-fiscal.cod-estabel
                      AND int-nota-rps.nr-nota-fis = nota-fiscal.nr-nota-fis
                      AND int-nota-rps.serie       = nota-fiscal.serie NO-LOCK NO-ERROR.
                IF AVAIL int-nota-rps THEN
                    ASSIGN tt-rps.nat-op-municipal = int-nota-rps.nat-op-especial.
                ELSE
                    ASSIGN tt-rps.nat-op-municipal = esp-ext-ser-estab.nat-op-especial.
            END.
            ELSE DO:
                IF  tt-rps.servico-ibge = tt-rps.estab-ibge THEN
                    ASSIGN tt-rps.nat-op-municipal = esp-ext-ser-estab.nat-op-dentro.
                ELSE
                    ASSIGN tt-rps.nat-op-municipal = esp-ext-ser-estab.nat-op-fora.
            END.
        END.
        /** REGRA: Tributacao do servico da RPS para outras cidades **/
        ELSE DO:
            
            FIND FIRST int-nota-rps
                WHERE int-nota-rps.cod-estabel = nota-fiscal.cod-estabel
                  AND int-nota-rps.nr-nota-fis = nota-fiscal.nr-nota-fis
                  AND int-nota-rps.serie       = nota-fiscal.serie NO-LOCK NO-ERROR.
            IF AVAIL int-nota-rps THEN
                ASSIGN tt-rps.nat-op-municipal = int-nota-rps.nat-op-especial.
            ELSE
                ASSIGN tt-rps.nat-op-municipal = esp-ext-ser-estab.nat-op-especial.
    
            IF  tt-rps.nat-op-municipal = "" THEN DO:
                IF  tt-rps.servico-ibge = tt-rps.estab-ibge THEN
                    ASSIGN tt-rps.nat-op-municipal = esp-ext-ser-estab.nat-op-dentro.
                ELSE
                    ASSIGN tt-rps.nat-op-municipal = esp-ext-ser-estab.nat-op-fora.
            END.
        END.

        /** REGRA: Tributacao do servico da RPS para Anapolis-GO **/
        IF  tt-rps.estab-ibge = 5201108 THEN DO:

            /*IBGE do local de prestacao sempre devera ser Anapolis-GO*/
            ASSIGN tt-rps.servico-ibge = 5201108.
        END.

        /** REGRA: Valida tributacao **/
        IF  tt-rps.nat-op-municipal = "" THEN DO:
            RUN pi-gera-erro IN THIS-PROCEDURE (INPUT tt-rps.cod-estabel,
                                                INPUT tt-rps.nr-rps,
                                                INPUT tt-rps.serie,
                                                INPUT "CW10",
                                                INPUT "Tributaá∆o da RPS inv†lida. Verifique parÉmetros da SÇrie x Estabelecimento.").
        END.

        /** REGRA: Conforme parametro, incluir as faturas na descricao do servico **/
        IF  esp-ext-ser-estab.log-1 = YES THEN DO:

            FOR EACH fat-duplic NO-LOCK
               WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                 AND fat-duplic.serie       = nota-fiscal.serie
                 AND fat-duplic.nr-fatura   = nota-fiscal.nr-fatura
                BREAK BY fat-duplic.cod-estabel
                      BY fat-duplic.serie
                      BY fat-duplic.nr-fatura:
                
                IF  FIRST-OF(fat-duplic.nr-fatura) THEN
                    ASSIGN tt-rps.desc-fatura = tt-rps.desc-fatura
                                              + " / "
                                              + "Cond. Pagto.(Vencimento/Valor): "
                                              + STRING(fat-duplic.dt-venciment, '99-99-9999')
                                              + " - R$ "
                                              + TRIM(STRING(fat-duplic.vl-parcela, '>>,>>>,>>>,>>9.99')).
                ELSE
                    ASSIGN tt-rps.desc-fatura = tt-rps.desc-fatura
                                              + " / "
                                              + STRING(fat-duplic.dt-venciment, '99-99-9999')
                                              + " - R$ "
                                              + TRIM(STRING(fat-duplic.vl-parcela, '>>,>>>,>>>,>>9.99')).
            END.
        END.

        /** REGRA: Carregar data de competencia (algumas prefeituras utilizam) **/
        ASSIGN tt-rps.dt-competencia  = nota-fiscal.dt-emis-nota.
    END.
END.


/*****************************************************************************************************************************
########################################### P R E P A R A C A O   D O S   D A D O S ##########################################
*****************************************************************************************************************************/

FOR EACH tt-rps,
   FIRST esp-ext-ser-estab NO-LOCK
   WHERE esp-ext-ser-estab.cod-estabel = tt-rps.cod-estabel
     AND esp-ext-ser-estab.serie       = tt-rps.serie
     AND esp-ext-ser-estab.emite-rps:

    /** REGRA: ISS Retido **/
    IF  tt-rps.vl-iss-retido > 0 THEN
        ASSIGN tt-rps.i-iss-retido = 1.
    /** REGRA: Se nao for retido, para V3 tem que ser 2 **/
    ELSE IF SUBSTRING(esp-ext-ser-estab.char-1,5,1) = "2" THEN
        ASSIGN tt-rps.i-iss-retido = 2.
    
    /** REGRA: Incluir descricao do item **/
    IF  SUBSTRING(esp-ext-ser-estab.char-1,1,1) = "S" THEN DO:

        FOR EACH tt-rps-item
           WHERE tt-rps-item.cod-estabel = tt-rps.cod-estabel
             AND tt-rps-item.serie       = tt-rps.serie
             AND tt-rps-item.nr-rps      = tt-rps.nr-rps:


            /** REGRA: Agrupado por nota **/
            IF  esp-ext-ser-estab.log-2 = YES THEN DO:
                ASSIGN c-desc-servico = IF tt-rps.desc-servico = ""
                                             THEN tt-rps-item.desc-servico + tt-rps-item.desc-vl-item
                                             ELSE "; " + tt-rps-item.desc-servico + tt-rps-item.desc-vl-item.
            END.
            ELSE DO:
                ASSIGN c-desc-servico = IF tt-rps.desc-servico = ""
                                             THEN tt-rps-item.desc-servico
                                             ELSE "; " + tt-rps-item.desc-servico.
            END.
            IF LENGTH(c-desc-servico) < 51 THEN 
               ASSIGN i-total = 50.
            ELSE
                IF LENGTH(c-desc-servico) < 101 THEN 
                   ASSIGN i-total = 100.
                ELSE
                    IF LENGTH(c-desc-servico) < 151 THEN 
                       ASSIGN i-total = 150.
                    ELSE
                        IF LENGTH(c-desc-servico) < 201 THEN 
                           ASSIGN i-total = 200.          

            DO i-cont = LENGTH(c-desc-servico) TO i-total:
               ASSIGN c-desc-servico = c-desc-servico + "_".
            END.
            
            ASSIGN tt-rps.desc-servico = tt-rps.desc-servico + c-desc-servico.
        END.
    END.

    ASSIGN tt-rps.desc-servico = tt-rps.desc-servico.

    /** REGRA: Incluir observacao da nota na descricao **/
    IF  SUBSTRING(esp-ext-ser-estab.char-1,2,1) = "S" THEN
        ASSIGN tt-rps.desc-servico = IF tt-rps.desc-servico <> ""
                                        THEN tt-rps.desc-servico + " - " + tt-rps.observ-nota
                                        ELSE tt-rps.observ-nota.

    /** REGRA: Incluir duplicata na descricao **/
    IF  esp-ext-ser-estab.log-1 = YES THEN
        ASSIGN tt-rps.desc-servico = tt-rps.desc-servico
                                   + tt-rps.desc-fatura.
    /*
    /** REGRA: Remover quebras de linha na descricao **/
	IF  SUBSTRING(esp-ext-ser-estab.char-1,5,1) = "2" THEN DO: /*Mastersaf V3*/
	    ASSIGN tt-rps.desc-servico = REPLACE(tt-rps.desc-servico,CHR(10),"\n")
               tt-rps.desc-servico = REPLACE(tt-rps.desc-servico,CHR(13),"\n")
			   tt-rps.desc-servico = REPLACE(tt-rps.desc-servico,"|"," ").
	END.
	ELSE DO: /*CW NFSe*/
	    ASSIGN tt-rps.desc-servico = REPLACE(tt-rps.desc-servico,CHR(10),"<<ENTER>>")
               tt-rps.desc-servico = REPLACE(tt-rps.desc-servico,CHR(13),"<<ENTER>>").
	END.*/
END.


/*****************************************************************************************************************************
######################################### E S P A C O   P A R A   C U S T O M I Z A C A O ####################################
*****************************************************************************************************************************/
IF  SEARCH("rpp/espnfse2010x.p") <> ? OR
    SEARCH("rpp/espnfse2010x.r") <> ? THEN DO:

    RUN pi-acompanhar IN h-acomp (INPUT "Customizaá∆o dos dados...").

    RUN rpp/espnfse2010x.p (INPUT-OUTPUT TABLE tt-rps,
                            INPUT-OUTPUT TABLE tt-rps-item,
                            INPUT-OUTPUT TABLE tt-erro,
                            INPUT TABLE tt-param,
                            INPUT THIS-PROCEDURE).
END.


/*****************************************************************************************************************************
########################################### E X P O R T A C A O   D O S   D A D O S ##########################################
*****************************************************************************************************************************/

FOR EACH esp-ext-ser-estab NO-LOCK
   WHERE esp-ext-ser-estab.cod-estabel >= tt-param.cod-estabel-ini
     AND esp-ext-ser-estab.cod-estabel <= tt-param.cod-estabel-fim
     AND esp-ext-ser-estab.serie       >= tt-param.serie-ini
     AND esp-ext-ser-estab.serie       <= tt-param.serie-fim
     AND esp-ext-ser-estab.emite-rps:

    FIND FIRST tt-rps
         WHERE tt-rps.cod-estabel = esp-ext-ser-estab.cod-estabel
           AND tt-rps.serie       = esp-ext-ser-estab.serie NO-ERROR.

    IF  NOT AVAIL tt-rps THEN
        NEXT.

    RUN pi-acompanhar IN h-acomp (INPUT "Gerando arquivo: " + esp-ext-ser-estab.serie + "/" + esp-ext-ser-estab.cod-estabel).

    /** REGRA: Nome dos arquivos **/
    ASSIGN vc-nome-arquivo   = "RPS"
                             + IF SUBSTRING(esp-ext-ser-estab.char-1,5,1) = "2"
                                  THEN "V3_"
                                  ELSE "CW_".
    ASSIGN vc-nome-arquivo   = vc-nome-arquivo
                             + STRING(param-global.empresa-prin,"999")
                             + STRING(TODAY,"99999999")
                             + STRING(TIME)
                             + ".txt"
           vc-diretorio-real = IF  tt-param.arquivo-exp <> ""
                                   THEN tt-param.arquivo-exp
                                   ELSE esp-ext-ser-estab.dir-padrao-exp
           vc-arquivo-temp   = SESSION:TEMP-DIRECTORY
                             + REPLACE(vc-nome-arquivo,".txt",".tmp")
           vc-arquivo-real   = vc-diretorio-real
                             + vc-nome-arquivo
           vi-num-linha      = 0
           vd-total-servico  = 0.
    
    /** VALIDACAO: Validacao do diretorio de exportacao **/
    RUN pi-valida-diretorio IN THIS-PROCEDURE (INPUT vc-diretorio-real).
    IF  RETURN-VALUE = "NOK":U THEN
        NEXT.

    /** REGRA: Gerando arquivo temporario **/
    OUTPUT STREAM s-saida TO VALUE(vc-arquivo-temp) CONVERT TARGET "ISO8859-1" /* CONVERT TARGET "utf-8"*/ .

        FOR EACH tt-rps
           WHERE tt-rps.cod-estabel = esp-ext-ser-estab.cod-estabel
             AND tt-rps.serie       = esp-ext-ser-estab.serie:

            /** REGRA: Somente exporta a RPS se nao encontrar erro **/
            FIND FIRST tt-erro
                 WHERE tt-erro.cod-estabel = tt-rps.cod-estabel
                   AND tt-erro.nr-rps      = tt-rps.nr-rps
                   AND tt-erro.serie       = tt-rps.serie NO-ERROR.
            IF  NOT AVAIL tt-erro THEN DO:

                /** REGRA: layout MASTERSAF V3 **/
                IF  SUBSTRING(esp-ext-ser-estab.char-1,5,1) = "2" THEN DO:
                    RUN pi-layout-mastersaf IN THIS-PROCEDURE.
                END.

                /** REGRA: layout CW NFSe **/
                ELSE DO:
                    RUN pi-layout-cwnfse IN THIS-PROCEDURE.
                END.


                /** REGRA: Impressao da RPS exportada **/
                DISP tt-rps.cod-estabel
                     tt-rps.serie
                     tt-rps.nr-rps
                     tt-rps.dt-emis-rps
                     tt-rps.vl-servico
                     vc-nome-arquivo
                     vc-status-rps WITH FRAME f-rps.
                DOWN WITH FRAME f-rps.
            END.
        END.
                
        /** REGRA: final de arquivo layout MASTERSAF V3 **/
        IF  SUBSTRING(esp-ext-ser-estab.char-1,5,1) = "2" THEN DO:
            PUT STREAM s-saida UNFORMATTED
                "__arquivo_fim__|".
        END.
        
    OUTPUT STREAM s-saida CLOSE.

    /** REGRA: Apenas converte arquivo temporario para real se existir conteudo **/
    IF  vi-num-linha > 0 THEN DO:
        OS-COPY   VALUE(vc-arquivo-temp) VALUE(vc-arquivo-real).
        OS-DELETE VALUE(vc-arquivo-temp).
    END.
END.


/*****************************************************************************************************************************
######################################### F I N A L I Z A N D O   R E L A T R O R I O ########################################
*****************************************************************************************************************************/

RUN pi-acompanhar IN h-acomp (INPUT "Finalizando...").

/** REGRA: Listar os erros do processamento **/
FIND FIRST tt-erro NO-ERROR.
FIND FIRST tt-rps  NO-ERROR.

IF  NOT AVAIL tt-erro AND
    NOT AVAIL tt-rps THEN
    PUT UNFORMATTED "N∆o foi encontrado RPS para a seleá∆o informada." SKIP(1).

IF  AVAIL tt-erro THEN
    PUT UNFORMATTED "==================== ERROS DO PROCESSAMENTO ====================" SKIP(1).

FOR EACH tt-erro:

    IF  LINE-COUNTER > 60 THEN
        PAGE.

    DISP tt-erro.cod-estabel
         tt-erro.serie
         tt-erro.nr-rps
         tt-erro.cod-erro
         tt-erro.des-erro WITH FRAME f-erro.
    DOWN WITH FRAME f-erro.
END.

/** REGRA: Finalizar o relatorio **/
RUN pi-finalizar IN h-acomp.
{include/i-rpclo.i}

IF  VALID-HANDLE(h-cdapi704) THEN
    DELETE PROCEDURE h-cdapi704.

IF  VALID-HANDLE(h-acomp) THEN
    DELETE PROCEDURE h-acomp.



/*****************************************************************************************************************************
#################################################### P R O C E D U R E S #####################################################
*****************************************************************************************************************************/


PROCEDURE pi-descricao-servico:
/*************************************************************************************************
** Retorna a descricao do servico
*************************************************************************************************/

    DEF OUTPUT PARAMETER c-desc-prod LIKE nar-it-nota.narrativa NO-UNDO.

    FIND FIRST narrativa NO-LOCK
         WHERE narrativa.it-codigo = ITEM.it-codigo NO-ERROR.

    IF  ITEM.ind-imp-desc = 1 THEN
        ASSIGN c-desc-prod = ITEM.desc-item.

    IF  ITEM.ind-imp-desc =  8 THEN DO:

        FIND FIRST item-cli NO-LOCK
             WHERE item-cli.nome-abrev = nota-fiscal.nome-ab-cli
               AND item-cli.it-codigo  = it-nota-fisc.it-codigo NO-ERROR.
        
        ASSIGN c-desc-prod = ITEM.desc-item + " " + 
                             IF  AVAIL item-cli 
                                 THEN TRIM(SUBSTRING(item-cli.narrativa,1,27))
                                 ELSE "".
    END.

    IF  ITEM.ind-imp-desc = 9 THEN DO:

        FIND FIRST nar-it-nota NO-LOCK
             WHERE nar-it-nota.cod-estabel  = it-nota-fisc.cod-estabel
               AND nar-it-nota.serie        = it-nota-fisc.serie
               AND nar-it-nota.nr-nota-fis  = it-nota-fisc.nr-nota-fis
               AND nar-it-nota.nr-sequencia = it-nota-fisc.nr-seq-fat
               AND nar-it-nota.it-codigo    = it-nota-fisc.it-codigo NO-ERROR.
        
        ASSIGN c-desc-prod = ITEM.desc-item + " " +
                             IF  AVAIL nar-it-nota 
                                 THEN TRIM(SUBSTRING(nar-it-nota.narrativa,1,27))
                                 ELSE "".
    END.

    IF  ITEM.ind-imp-desc = 10 THEN
        ASSIGN c-desc-prod = ITEM.desc-item + " " + 
                             IF  AVAIL narrativa
                                 THEN TRIM(SUBSTRING(narrativa.descricao,1,27))
                                 ELSE "".

    IF  (ITEM.ind-imp-desc = 2 OR
         ITEM.ind-imp-desc = 5 OR
         ITEM.ind-imp-desc = 6   ) AND
        AVAIL narrativa THEN
        ASSIGN c-desc-prod = IF  ITEM.ind-imp-desc = 2
                                 THEN ITEM.desc-item + " " + TRIM(SUBSTRING(narrativa.descricao,1,38))
                                 ELSE IF  ITEM.ind-imp-desc = 5 
                                          THEN narrativa.descricao
                                          ELSE IF ITEM.ind-imp-desc = 6 
                                               THEN TRIM(ENTRY(1,SUBSTRING(narrativa.descricao,1,76),CHR(10)))
                                               ELSE "".

    IF  ITEM.ind-imp-desc = 3 THEN DO:

        FIND FIRST item-cli NO-LOCK
             WHERE item-cli.nome-abrev = nota-fiscal.nome-ab-cli
               AND item-cli.it-codigo  = it-nota-fisc.it-codigo NO-ERROR.

        ASSIGN c-desc-prod = item.desc-item + " " + 
                             IF  AVAIL item-cli 
                                 THEN TRIM(SUBSTRING(item-cli.narrativa,1,380))
                                 ELSE "".
    END.

    IF  ITEM.ind-imp-desc = 4 OR
        ITEM.ind-imp-desc = 7 THEN DO:

        FIND FIRST nar-it-nota NO-LOCK
             WHERE nar-it-nota.cod-estabel  = it-nota-fisc.cod-estabel
               AND nar-it-nota.serie        = it-nota-fisc.serie
               AND nar-it-nota.nr-nota-fis  = it-nota-fisc.nr-nota-fis
               AND nar-it-nota.nr-sequencia = it-nota-fisc.nr-seq-fat
               AND nar-it-nota.it-codigo    = it-nota-fisc.it-codigo NO-ERROR.

        IF  ITEM.ind-imp-desc = 4 THEN
            ASSIGN c-desc-prod = ITEM.desc-item + " " +
                                 IF  AVAIL nar-it-nota
                                     THEN TRIM(SUBSTRING(nar-it-nota.narrativa,1,1000))
                                     ELSE "".

        IF  ITEM.ind-imp-desc = 7 THEN 
            ASSIGN c-desc-prod = IF  AVAIL nar-it-nota 
                                     THEN TRIM(SUBSTRING(nar-it-nota.narrativa,1,1000))
                                     ELSE "".
    END.

    IF  c-desc-prod = "" THEN
        ASSIGN c-desc-prod = ITEM.desc-item.
    
    ASSIGN c-desc-prod = "Qtde: " + STRING(it-nota-fisc.qt-faturada[1]) + " - " +  c-desc-prod 
           c-desc-prod = REPLACE(c-desc-prod,CHR(10)," ")
           c-desc-prod = REPLACE(c-desc-prod,CHR(13)," ").
		   
    /*REGRA: Para Mastersaf V3 o pipe È separador, ent„o substituir por espaÁo*/
    IF  SUBSTRING(esp-ext-ser-estab.char-1,5,1) = "2" THEN /*Mastersaf V3*/
	    ASSIGN c-desc-prod = REPLACE(c-desc-prod,"|"," ").

    ASSIGN c-desc-prod = ITEM.it-codigo + "-" + c-desc-prod.
    RETURN "OK".
END PROCEDURE.


PROCEDURE pi-gera-erro:
/*********************************************************************************************************
** Gera erro
*********************************************************************************************************/

    DEF VAR iSeqErro AS INT INITIAL 1 NO-UNDO.
    
    DEF INPUT PARAM pCodEstabel LIKE nota-fiscal.cod-estabel NO-UNDO.
    DEF INPUT PARAM pNrRPS      LIKE nota-fiscal.nr-nota-fis NO-UNDO.
    DEF INPUT PARAM pSerie      LIKE nota-fiscal.serie       NO-UNDO.
    DEF INPUT PARAM pCodErro    AS CHAR                      NO-UNDO.
    DEF INPUT PARAM pDesErro    AS CHAR FORMAT "x(40)"       NO-UNDO.

    FOR LAST tt-erro:
        ASSIGN iSeqErro = tt-erro.seq + 1.
    END.

    CREATE tt-erro.
    ASSIGN tt-erro.seq         = iSeqErro
           tt-erro.cod-estabel = pCodEstabel
           tt-erro.nr-rps      = pNrRPS
           tt-erro.serie       = pSerie
           tt-erro.cod-erro    = pCodErro
           tt-erro.des-erro    = pDesErro.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-valida-diretorio:
/*********************************************************************************************************
** VALIDACAO: Verifica se existe problema no diretorio de exportacao
*********************************************************************************************************/

    DEF INPUT PARAM p-dir-exportacao AS CHAR NO-UNDO.

    OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "cw-espnfse2010.001").
    OUTPUT CLOSE.
    OS-COPY VALUE(SESSION:TEMP-DIRECTORY + "cw-espnfse2010.001") VALUE(p-dir-exportacao + "cw-espnfse2010.001").

    IF  OS-ERROR <> 0 THEN DO:
        RUN pi-gera-erro IN THIS-PROCEDURE (INPUT esp-ext-ser-estab.cod-estabel,
                                            INPUT "",
                                            INPUT esp-ext-ser-estab.serie,
                                            INPUT "CW01",
                                            INPUT "Diret¢rio de exportaá∆o inv†lido ou sem permiss∆o: " + p-dir-exportacao).
        RETURN "NOK":U.
    END.

    OS-DELETE VALUE(SESSION:TEMP-DIRECTORY + "cw-espnfse2010.001") NO-ERROR.
    OS-DELETE VALUE(p-dir-exportacao + "cw-espnfse2010.001") NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-layout-cwnfse:
/*********************************************************************************************************
** REGRA: Impressao do arquivo de RPS para integracao com o CW NFSe
*********************************************************************************************************/

    /** REGRA: Emissao **/
    IF  tt-rps.id-transacao = 1 THEN DO:

        /** Registro tipo 001 - Dados da RPS **/
        PUT STREAM s-saida UNFORMATTED
            /* ID            */ "001"                                                                  "|"
            /* RPS           */ "RPS"                                                                  "|".

        IF  tt-rps.nr-rps-ext <> "" THEN
            PUT STREAM s-saida UNFORMATTED
            /* SERIE         */ UPPER(tt-rps.serie-ext)                                                "|"
            /* NR_RPS        */ STRING(INT(tt-rps.nr-rps-ext),"9999999999")                            "|".
        ELSE
            PUT STREAM s-saida UNFORMATTED
            /* SERIE         */ UPPER(tt-rps.serie)                                                    "|"
            /* NR_RPS        */ STRING(INT(tt-rps.nr-rps),"9999999999")                                "|".

        PUT STREAM s-saida UNFORMATTED
            /* DATA(ano)     */ SUBSTR(STRING(tt-rps.dt-emis-rps,"99999999"),5,4) FORMAT "x(04)"  "-"
            /* DATA(mes)     */ SUBSTR(STRING(tt-rps.dt-emis-rps,"99999999"),3,2) FORMAT "x(02)"  "-"
            /* DATA(dia)     */ SUBSTR(STRING(tt-rps.dt-emis-rps,"99999999"),1,2) FORMAT "x(02)"       "|"
            /* COD SERV      */ STRING(tt-rps.cod-servico)                                             "|"
            /* VL SERV       */ tt-rps.vl-servico                                                      "|"
            /* VL ISS        */ tt-rps.vl-iss                                                          "|"
            /* DESC SERV     */ tt-rps.desc-servico                                                    "|"
            /* VL IRF        */ tt-rps.vl-irf                                                          "|"
            /* VL PIS        */ tt-rps.vl-pis                                                          "|"
            /* VL COFINS     */ tt-rps.vl-cofins                                                       "|"
            /* VL CSLL       */ tt-rps.vl-csll                                                         "|"
            /* VL INSS       */ tt-rps.vl-inss                                                         "|"
            /* VL DEDUCAO    */ tt-rps.vl-deducao                                                      "|"
            /* ISS RETIDO    */ tt-rps.i-iss-retido                                                    "|"
            /* VL ISS RET    */ tt-rps.vl-iss-retido                                                   "|"
            /* VL OUT RET    */ tt-rps.vl-retencoes                                                    "|"
            /* NAT_OPER      */ tt-rps.nat-op-municipal                                                "|"
            /* IBGE SERVICO  */ tt-rps.servico-ibge                                                    "|"
            /* TIPO_PESSOA   */ tt-rps.cli-pessoa                                                      "|"
            /* CD_INSCRIC    */ tt-rps.cli-cgc                                                         "|"
            /* NM_EMITENTE   */ tt-rps.cli-razao                                                       "|" 
            /* ENDERECO      */ tt-rps.cli-end-rua                                                     "|" 
            /* NUMERO        */ tt-rps.cli-end-numero                                                  "|"
            /* BAIRRO        */ tt-rps.cli-end-bairro                                                  "|"
            /* COMPLEMENTO   */ tt-rps.cli-end-complemento                                             "|"
            /* CIDADE        */ tt-rps.cli-end-cidade                                                  "|"
            /* ESTADO        */ tt-rps.cli-end-estado                                                  "|"
            /* CEP           */ tt-rps.cli-end-cep                                                     "|"
            /* EMAIL         */ tt-rps.cli-email                                                       "|"
            /* IBGE CLIENT   */ tt-rps.cli-ibge                                                        "|"
            /* INSC MUNIC    */ tt-rps.cli-ins-municipal                                               "|"
            /* INSC ESTAD    */ tt-rps.cli-ins-estadual                                                "|"
            /* TELEFONE      */ tt-rps.cli-telefone                                                    "|"
            /* FIXO NULO     */                                                                        "|"
            /* FIXO NULO     */                                                                        "|"
            /* FIXO NULO     */                                                                        "|"
            /* FIXO NULO     */                                                                        "|"
            /* BASE CALC     */ tt-rps.vl-iss-base                                                     "|"
            /* VL DESC       */ tt-rps.vl-desconto                                                     "|"
            /* VL DESC INC   */ tt-rps.vl-desconto-incond                                              "|"
            /* IS TIPO       */ tt-rps.int-tipo                                                        "|"
            /* IS DOCTO      */ tt-rps.int-cgc                                                         "|"
            /* IS RAZAO SOC  */ tt-rps.int-razao                                                       "|"
            /* IS INSC MUNIC */ tt-rps.int-ins-municipal                                               "|"
            /* CIVIL CD OBRA */ tt-rps.cod-obra                                                        "|"
            /* CIVIL ART     */ tt-rps.cod-art                                                         "|"
            /* CNPJ PREST    */ tt-rps.estab-cgc                                                       "|"
            /* CD PRESTADOR  */ tt-rps.cod-prestador                                                   "|"
            /* ALIQ ISS      */ tt-rps.aliq-iss                                                        "|"
            /* ALIQ PIS      */ tt-rps.aliq-pis                                                        "|"
            /* ALIQ COFINS   */ tt-rps.aliq-cofins                                                     "|"
            /* ALIQ INSS     */ tt-rps.aliq-inss                                                       "|"
            /* ALIQ IRRF     */ tt-rps.aliq-irrf                                                       "|"
            /* ALIQ CSLL     */ tt-rps.aliq-csll                                                       "|"
            /* TIPO ENDERECO */ tt-rps.cli-tipo-endereco                                               "|"
            /* CAMPO LIVRE1  */ tt-rps.string_livre_1                                                  "|"
            /* CAMPO LIVRE2  */ tt-rps.string_livre_2                                                  "|"
            /* CAMPO LIVRE3  */ tt-rps.string_livre_3                                                  "|"
            /* RPS SUBSTITUTA*/ tt-rps.nr-nota-subs                                                    "|"
            /* STATUS        */ tt-rps.i-status-conv                                                   "|"
            /* OBS CANCELA   */ tt-rps.motivo-cancela                                                  "|"
            /* CD SERV MUNIC */ tt-rps.serv-cd-servico                                                 "|"
            /* ITEM LISTA    */ tt-rps.serv-item-lista                                                 "|"
            /* CNAE          */ tt-rps.serv-cnae                                                       "|"
            /* IM PRESTADOR  */ tt-rps.estab-ins                                                       "|"
            /* IBGE PRESTADO */ tt-rps.estab-ibge                                                      "|"
            /* EMAIL TOM RPS */ tt-rps.rps-mail-cli                                                    "|"
            /* DT COMPETENCI */ tt-rps.dt-competencia                                                  "|"
            /* RESP RETENCAO */ tt-rps.resp-retencao                                                   "|"
            /* IBGE INCIDENC */ tt-rps.ibge-incidencia                                                 "|"
            /* COD PAIS      */ tt-rps.cod-pais                                                        "|"
            /* NR PROC SUSP  */ tt-rps.nr-proc-susp-exig                                               SKIP.

        /** REGRA: Controla conteudo do arquivo **/
        ASSIGN vi-num-linha = vi-num-linha + 1.

        /** REGRA: Itens da RPS **/
        FOR EACH tt-rps-item
           WHERE tt-rps-item.serie       = tt-rps.serie
             AND tt-rps-item.cod-estabel = tt-rps.cod-estabel
             AND tt-rps-item.nr-rps      = tt-rps.nr-rps:

            /** Registro tipo 020 - Itens da RPS **/
            PUT STREAM s-saida UNFORMATTED
                /* ID             */ "020"                                           "|".

            IF  tt-rps-item.nr-rps-ext <> "" THEN
                PUT STREAM s-saida UNFORMATTED
                /* SERIE         */ UPPER(tt-rps-item.serie-ext)                     "|"
                /* NR_RPS        */ STRING(INT(tt-rps-item.nr-rps-ext),"9999999999") "|".
            ELSE
                PUT STREAM s-saida UNFORMATTED
                /* SERIE         */ UPPER(tt-rps-item.serie)                         "|"
                /* NR_RPS        */ STRING(INT(tt-rps-item.nr-rps),"9999999999")     "|".

            PUT STREAM s-saida UNFORMATTED
                /* CD_PRESATDOR   */ tt-rps.cod-prestador                            "|"
                /* NUM_SEQ        */ tt-rps-item.nr-seq-fat                          "|"
                /* COD_ITEM       */ tt-rps-item.it-codigo                           "|"
                /* NUM_QTD        */ tt-rps-item.quantidade                          "|"
                /* VLR_UNITARIO   */ tt-rps-item.vl-preuni                           "|"
                /* CNPJ_PRESTADOR */ tt-rps.estab-cgc                                "|"
                /* UN_MEDIDA      */ tt-rps-item.un-medida[1]                        "|"
                /* VL_DEDUCAO     */                                                 SKIP.

            /** REGRA: Controla conteudo do arquivo **/
            ASSIGN vi-num-linha = vi-num-linha + 1.

            /** Registro tipo 025 - Cadastro de Itens **/
            PUT STREAM s-saida UNFORMATTED
                /* ID             */ "025"                                   "|"
                /* COD_ITEM       */ tt-rps-item.it-codigo                   "|"
                /* DES_ITEM       */ tt-rps-item.desc-item                   SKIP.

            /** REGRA: Controla conteudo do arquivo **/
            ASSIGN vi-num-linha = vi-num-linha + 1.
        END.

        /** REGRA: Atualiza status da RPS para enviada **/
        FOR FIRST esp-ext-nota-fiscal EXCLUSIVE-LOCK
            WHERE esp-ext-nota-fiscal.cod-estabel = tt-rps.cod-estabel
              AND esp-ext-nota-fiscal.serie       = tt-rps.serie
              AND esp-ext-nota-fiscal.nr-nota-fis = tt-rps.nr-rps:

            ASSIGN esp-ext-nota-fiscal.processada = YES /*RPS processado*/
                   vc-status-rps                  = "RPS Processado".
                   
            /** REGRA: Cancelamento de RPS **/
            IF  tt-rps.i-status-conv = 4 THEN
                ASSIGN esp-ext-nota-fiscal.int-1 = 2. /*1-Cancelamento Pendente, 2-Cancelamento Enviado, 3-Cancelamento Confirmado*/
        END.
    END.

    /** REGRA: Cancelar **/
    IF  tt-rps.id-transacao = 3 THEN DO:

        /** Registro tipo 003 - Cancelar RPS **/
        PUT STREAM s-saida UNFORMATTED
            /* ID            */ "003"                                   "|"
            /* CNPJ PREST    */ tt-rps.estab-cgc                        "|"
            /* CD PRESTADOR  */ tt-rps.cod-prestador                    "|"
            /* NR_RPS        */ STRING(INT(tt-rps.nr-rps),"9999999999") "|"
            /* SERIE         */ UPPER(tt-rps.serie)                     "|"
            /* MOTIVO CANCEL */ tt-rps.motivo-cancela                   SKIP.

        /** REGRA: Controla conteudo do arquivo **/
        ASSIGN vi-num-linha = vi-num-linha + 1.

        /** REGRA: Atualiza status da RPS para cancelada **/
        FOR FIRST esp-ext-nota-fiscal EXCLUSIVE-LOCK
            WHERE esp-ext-nota-fiscal.cod-estabel = tt-rps.cod-estabel
              AND esp-ext-nota-fiscal.serie       = tt-rps.serie
              AND esp-ext-nota-fiscal.nr-nota-fis = tt-rps.nr-rps:

            ASSIGN esp-ext-nota-fiscal.int-1 = 2 /*1-Cancelamento Pendente, 2-Cancelamento Enviado, 3-Cancelamento Confirmado*/
                   vc-status-rps             = "RPS Cancelado".
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.


/* ************************  Function Prototypes ********************** */
FUNCTION fnCasasDecimais RETURNS CHARACTER
  (p-valor AS DEC)  FORWARD.



PROCEDURE pi-layout-mastersaf:
/*********************************************************************************************************
** REGRA: Impressao do arquivo de RPS para integracao com o Mastersaf V3
*********************************************************************************************************/

    /** REGRA: Emissao **/
    IF  tt-rps.id-transacao = 1 THEN DO:


        /** TAG RPS - Dados do RPS **/
        PUT STREAM s-saida UNFORMATTED
            "__rps__"                                                                          "|" SKIP
            "versao="                      "2"                                                 "|" SKIP.

        IF  SUBSTRING(esp-ext-ser-estab.char-1,6,1) = "1" THEN
            PUT STREAM s-saida UNFORMATTED
                "tipoAmbienteSistema="     "1"  /*PRODUCAO*/                                   "|" SKIP.
        ELSE
            PUT STREAM s-saida UNFORMATTED
                "tipoAmbienteSistema="     "2"  /*HOMOLOGACAO*/                                "|" SKIP.

        
        PUT STREAM s-saida UNFORMATTED
            "codCidade="                   tt-rps.estab-ibge                                   "|" SKIP
            "cnpjPrestador="               tt-rps.estab-cgc                                    "|" SKIP     
            "inscricaoPrestador="          tt-rps.estab-ins                                    "|" SKIP.

        IF  tt-rps.nr-rps-ext <> "" THEN
            PUT STREAM s-saida UNFORMATTED
            "numeroRps="                   STRING(INT(tt-rps.nr-rps-ext),"9999999999")         "|" SKIP
            "serieRps="                    "S2"                                                 "|" SKIP.
/*             "serieRps="                    UPPER(tt-rps.serie-ext)                             "|" SKIP. */
        ELSE
            PUT STREAM s-saida UNFORMATTED
            "numeroRps="                   STRING(INT(tt-rps.nr-rps),"9999999999")             "|" SKIP
            "serieRps="                    "S2"                                                 "|" SKIP.
/*             "serieRps="                    UPPER(tt-rps.serie)                                 "|" SKIP. */

        PUT STREAM s-saida UNFORMATTED
            "dataEmissaoRps="                         SUBSTR(STRING(tt-rps.dt-emis-rps,"99999999"),5,4)    FORMAT "x(04)"  "-"
            /*AAAA-MM-DDTHH:MM:SS*/                   SUBSTR(STRING(tt-rps.dt-emis-rps,"99999999"),3,2)    FORMAT "x(02)"  "-"
                                                      SUBSTR(STRING(tt-rps.dt-emis-rps,"99999999"),1,2)    FORMAT "x(02)"  "T"
                                                      STRING(TIME,"HH:MM:SS")                                                   "|" SKIP
            "dataCompetencia="                        SUBSTR(STRING(tt-rps.dt-competencia,"99999999"),5,4) FORMAT "x(04)"  "-"
            /*AAAA-MM-DDTHH:MM:SS*/                   SUBSTR(STRING(tt-rps.dt-competencia,"99999999"),3,2) FORMAT "x(02)"  "-"
                                                      SUBSTR(STRING(tt-rps.dt-competencia,"99999999"),1,2) FORMAT "x(02)"  "T"      
                                                      STRING(TIME,"HH:MM:SS")                                                   "|" SKIP
            "tipoRps="                                "1" /*RPS*/                                                               "|" SKIP
            "situacaoRps="                            "1" /*Normal*/                                                            "|" SKIP
            "naturezadaOperacao="                     tt-rps.nat-op-municipal                                                   "|" SKIP
            "municipioPrestacao="                     tt-rps.servico-ibge                                                       "|" SKIP
            /*"municipioIncidencia="                    tt-rps.ibge-incidencia                                                    "|" SKIP*/
            "paisServico="                            "1058"                                                                    "|" SKIP
            "descricaoRps="                           tt-rps.desc-servico                                                       "|" SKIP
            "codigoServicoInterno="                   STRING(tt-rps.cod-servico,"99,99")                                        "|" SKIP
            /*"codigoCnae="                             tt-rps.serv-cnae                                                          "|" SKIP*/
            "itemListaServico="                       tt-rps.serv-item-lista                                                    "|" SKIP
            "codigoTributacaoMunicipio="              tt-rps.serv-cd-servico                                                    "|" SKIP
            "aliquotaServicos="                       fnCasasDecimais(tt-rps.aliq-iss / 100)                                    "|" SKIP
            "baseCalculo="                            fnCasasDecimais(tt-rps.vl-iss-base)                                       "|" SKIP
            "valorIss="                               fnCasasDecimais(tt-rps.vl-iss)                                            "|" SKIP
            "tipoRecolhimento="                       tt-rps.i-iss-retido                                                       "|" SKIP
            "valorIssRetido="                         fnCasasDecimais(tt-rps.vl-iss-retido)                                     "|" SKIP
            "responsavelRetencao="                    tt-rps.resp-retencao                                                      "|" SKIP
            "valorLiquidoNfse="                       fnCasasDecimais(tt-rps.vl-servico)                                        "|" SKIP
            "valorServicos="                          fnCasasDecimais(tt-rps.vl-servico)                                        "|" SKIP
            "valorPis="                               fnCasasDecimais(tt-rps.vl-pis)                                            "|" SKIP
            "valorCofins="                            fnCasasDecimais(tt-rps.vl-cofins)                                         "|" SKIP
            "valorInss="                              fnCasasDecimais(tt-rps.vl-inss)                                           "|" SKIP
            "valorIr="                                fnCasasDecimais(tt-rps.vl-irf)                                            "|" SKIP
            "valorCsll="                              fnCasasDecimais(tt-rps.vl-csll)                                           "|" SKIP
            "outrasRetencoes="                        fnCasasDecimais(tt-rps.vl-retencoes)                                      "|" SKIP
            "valorDescontoIncondicionado="            fnCasasDecimais(tt-rps.vl-desconto-incond)                                "|" SKIP
            "valorDescontoCondicionado="              fnCasasDecimais(tt-rps.vl-desconto)                                       "|" SKIP
            "razaoSocialPrestador="                   tt-rps.estab-razao                                                        "|" SKIP
            "enderecoPrestador="                      tt-rps.estab-endereco                                                     "|" SKIP
            "numeroEnderecoPrestador="                tt-rps.estab-numero                                                       "|" SKIP
            "complementoEnderecoPrestador="           tt-rps.estab-complemento                                                  "|" SKIP
            "bairroPrestador="                        tt-rps.estab-bairro                                                       "|" SKIP
            "cepPrestador="                           tt-rps.estab-cep                                                          "|" SKIP
            "ufPrestador="                            tt-rps.estab-estado                                                       "|" SKIP
            /*"dddPrestador="                           tt-rps.estab-ddd                                                          "|" SKIP*/
            /*"telefonePrestador="                      tt-rps.estab-telefone                                                     "|" SKIP*/
            /*"emailPrestador="                         tt-rps.estab-email                                                        "|" SKIP*/
            /*"regimeEspecialTributacao="               tt-rps.estab-reg-espec-trib                                               "|" SKIP*/
            "optanteSimplesNacional="                 "2" /*tt-rps.estab-optante-simples*/                                      "|" SKIP
            "incentivadorCultural="                   "2" /*tt-rps.estab-incent-cultural*/                                      "|" SKIP
            "cpfCnpjTomador="                         tt-rps.cli-cgc                                                            "|" SKIP
            "inscricaoMunicipalTomador="              tt-rps.cli-ins-municipal                                                  "|" SKIP
            "indicacaoCpfCnpj="                       tt-rps.cli-pessoa                                                         "|" SKIP
            "inscricaoEstadualTomador="               tt-rps.cli-ins-estadual                                                   "|" SKIP
            "razaoSocialTomador="                     tt-rps.cli-razao                                                          "|" SKIP
            "tipoLogradouroTomador="                  tt-rps.cli-logradouro                                                     "|" SKIP
            "enderecoTomador="                        tt-rps.cli-end-rua                                                        "|" SKIP
            "numeroEnderecoTomador="                  tt-rps.cli-end-numero                                                     "|" SKIP
            "complementoEnderecoTomador="             tt-rps.cli-end-complemento                                                "|" SKIP
            "bairroTomador="                          tt-rps.cli-end-bairro                                                     "|" SKIP
            "cidadeTomador="                          tt-rps.cli-ibge                                                           "|" SKIP
            "ufTomador="                              tt-rps.cli-end-estado                                                     "|" SKIP
            "paisTomador="                            tt-rps.cli-pais                                                           "|" SKIP
            "cepTomador="                             tt-rps.cli-end-cep                                                        "|" SKIP
            "emailTomador="                           tt-rps.cli-email                                                          "|" SKIP
            "dddTomador="                             tt-rps.cli-ddd                                                            "|" SKIP
            "telefoneTomador="                        "" /*tt-rps.cli-telefone*/                                                "|" SKIP
            "razaoSocialIntermediarioServico="        tt-rps.int-razao                                                          "|" SKIP
            "inscricaoMunicipalIntermediarioServico=" tt-rps.int-ins-municipal                                                  "|" SKIP
            "cpfCnpjIntermediarioServico="            tt-rps.int-cgc                                                            "|" SKIP
            "codigodaObra="                           tt-rps.cod-obra                                                           "|" SKIP
            "art="                                    tt-rps.cod-art                                                            "|" SKIP
            "serieRpsSubstituido="                    tt-rps.subst-serie                                                        "|" SKIP
            "numeroRpsSubstituido="                   tt-rps.subst-nr-rps                                                       "|" SKIP
            "nroProcessoNatureza="                    tt-rps.nr-proc-susp-exig                                                  "|" SKIP.
        
        /** REGRA: Itens da RPS **/
        FOR EACH tt-rps-item
           WHERE tt-rps-item.serie       = tt-rps.serie
             AND tt-rps-item.cod-estabel = tt-rps.cod-estabel
             AND tt-rps-item.nr-rps      = tt-rps.nr-rps:

            /** TAG ITEM - Itens do RPS **/
            PUT STREAM s-saida UNFORMATTED
                "__item__"                                                                                        "|" SKIP.

            PUT STREAM s-saida UNFORMATTED
                /*"discriminacaoServico="   tt-rps-item.it-codigo + " - " + tt-rps-item.desc-item                   "|" SKIP
                   ESTA TAG DEIXA DE SER ENVIADA PALIATIVAMENTE ATE ATUALIZAR O MSAF V3, CONFORME EMAIL IVONEI 11/01/2013*/
                "quantidade="             tt-rps-item.quantidade                                                  "|" SKIP
                "valorUnitario="          fnCasasDecimais(tt-rps-item.vl-preuni)                                  "|" SKIP
                "valorTotal="             fnCasasDecimais((tt-rps-item.quantidade * tt-rps-item.vl-preuni))       "|" SKIP
                "unidadeMedida="          tt-rps-item.un-medida[1]                                                "|" SKIP.
        END.

        /** TAG DEDUCAO - Deducao do RPS **/
        PUT STREAM s-saida UNFORMATTED
            "__deducao__"                                                                                         "|" SKIP
            "valorDeduzir="               fnCasasDecimais(tt-rps.vl-deducao)                                      "|" SKIP.

        /** REGRA: Controla conteudo do arquivo **/
        ASSIGN vi-num-linha = vi-num-linha + 1.

        /** REGRA: Atualiza status da RPS para enviada **/
        FOR FIRST esp-ext-nota-fiscal EXCLUSIVE-LOCK
            WHERE esp-ext-nota-fiscal.cod-estabel = tt-rps.cod-estabel
              AND esp-ext-nota-fiscal.serie       = tt-rps.serie
              AND esp-ext-nota-fiscal.nr-nota-fis = tt-rps.nr-rps:

            ASSIGN esp-ext-nota-fiscal.processada = YES /*RPS processado*/
                   vc-status-rps                  = "RPS Processado".
                   
            /** REGRA: Cancelamento de RPS **/
            IF  tt-rps.i-status-conv = 4 THEN
                ASSIGN esp-ext-nota-fiscal.int-1 = 2. /*1-Cancelamento Pendente, 2-Cancelamento Enviado, 3-Cancelamento Confirmado*/
        END.
    END.

    /** REGRA: Cancelar **/
    IF  tt-rps.id-transacao = 3 THEN DO:

        /** TAG CANCELAMENTO - Cancelamento de NFSe **/
        PUT STREAM s-saida UNFORMATTED
            "__cancelamento__"                                                                 "|" SKIP
            "versao="                     "1"                                                  "|" SKIP
            "codCidade="                   tt-rps.estab-ibge                                   "|" SKIP.

        IF  SUBSTRING(esp-ext-ser-estab.char-1,6,1) = "1" THEN
            PUT STREAM s-saida UNFORMATTED
                "tipoAmbienteSistema="     "1"  /*PRODUCAO*/                                   "|" SKIP.
        ELSE
            PUT STREAM s-saida UNFORMATTED
                "tipoAmbienteSistema="     "2"  /*HOMOLOGACAO*/                                "|" SKIP.

        PUT STREAM s-saida UNFORMATTED
            "cnpjPrestador="               tt-rps.estab-cgc                                    "|" SKIP      
            "inscricaoPrestador"           tt-rps.estab-ins                                    "|" SKIP
            "numeroNfe="                   tt-rps.nr-nfse                                      "|" SKIP
            "codigoVerificacao="           tt-rps.cd-verificacao                               "|" SKIP
            "motivoCancelamento="          tt-rps.motivo-cancela                               "|" SKIP
            "codigoCancelamento="          "1"                                                 "|" SKIP.

        /** REGRA: Controla conteudo do arquivo **/
        ASSIGN vi-num-linha = vi-num-linha + 1.

        /** REGRA: Atualiza status da RPS para cancelada **/
        FOR FIRST esp-ext-nota-fiscal EXCLUSIVE-LOCK
            WHERE esp-ext-nota-fiscal.cod-estabel = tt-rps.cod-estabel
              AND esp-ext-nota-fiscal.serie       = tt-rps.serie
              AND esp-ext-nota-fiscal.nr-nota-fis = tt-rps.nr-rps:

            ASSIGN esp-ext-nota-fiscal.int-1 = 2 /*1-Cancelamento Pendente, 2-Cancelamento Enviado, 3-Cancelamento Confirmado*/
                   vc-status-rps             = "RPS Cancelado".
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCasasDecimais wWindow 
FUNCTION fnCasasDecimais RETURNS CHARACTER
  (p-valor AS DEC) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEF VAR vc-valor AS CHAR FORMAT "x(30)" NO-UNDO.

    ASSIGN vc-valor = REPLACE(STRING(p-valor),".","")
           vc-valor = REPLACE(STRING(vc-valor),",",".").

    /*MESSAGE p-valor SKIP
            vc-valor
        VIEW-AS ALERT-BOX INFO BUTTONS OK.*/

  RETURN vc-valor.   /* Function return value. */

END FUNCTION.
