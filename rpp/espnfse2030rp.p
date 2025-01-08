/**************************************************************************************************
** PROGRAMA...: espnfse2030rp.p - Importacao de dados da RPS do CW-NFSe para o EMS
** AUTOR......: Ivonei Vock - CW
** DATA.......: 01/09/2010
** ATUALIZACAO: 08/04/2013
**************************************************************************************************/
{include/i-prgvrs.i espnfse2030 3.00.00.000}  /*** 010000 ***/

/** DEFINICAO: Pre-processadores **/
{cdp/cdcfgdis.i}
{utp/ut-glob.i}

/** DEFINICAO: Temp-tables **/
{rpp/espnfse2030.i}

DEF TEMP-TABLE tt-param NO-UNDO
    FIELD destino            AS INT
    FIELD arquivo            AS CHAR FORMAT "x(35)":U
    FIELD usuario            AS CHAR FORMAT "x(12)":U
    FIELD data-exec          AS DATE
    FIELD hora-exec          AS INT
    FIELD classifica         AS INT
    FIELD desc-classifica    AS CHAR FORMAT "x(40)":U
    FIELD modelo             AS CHAR FORMAT "x(35)":U
    FIELD l-habilitaRtf      AS LOG
    FIELD cod-estabel-ini    AS CHAR FORMAT "x(03)":U
    FIELD cod-estabel-fim    AS CHAR FORMAT "x(03)":U
    FIELD lista-movto        AS LOG
    FIELD arquivo-imp        AS CHAR
    FIELD diretorio-imp      AS CHAR.

DEF TEMP-TABLE tt-arquivos
    FIELD c-arquivo          AS CHAR FORMAT "x(30)"
    FIELD c-dir-arquivo      AS CHAR FORMAT "x(150)"
    FIELD c-dir-arq-completo AS CHAR FORMAT "x(200)"
    FIELD c-tipo             AS CHAR
    INDEX ch-index1 c-dir-arq-completo
    INDEX ch-index2 c-tipo c-dir-arq-completo.

DEF TEMP-TABLE tt-raw-digita
    FIELD raw-digita         AS RAW.

DEF BUFFER  bf-esp-ext-nota-fiscal FOR esp-ext-nota-fiscal.

/** DEFINICAO: Parametros **/
DEF INPUT PARAM raw-param AS RAW NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/** DEFINICAO: Variaveis **/
DEF VAR h-acomp               AS HANDLE              NO-UNDO.
DEF VAR c-linha               AS CHAR                NO-UNDO.
DEF VAR c-data-emis-rps       AS CHAR                NO-UNDO. /*AAAA-MM-DD*/
DEF VAR c-serie               AS CHAR                NO-UNDO.
DEF VAR c-cod-estabel         AS CHAR                NO-UNDO.
DEF VAR c-nr-lote             AS CHAR                NO-UNDO.
DEF VAR c-nr-rps              AS CHAR                NO-UNDO.
DEF VAR c-nr-nfse             AS CHAR                NO-UNDO.
DEF VAR c-cod-autenticidade   AS CHAR                NO-UNDO.
DEF VAR c-inscricao           AS CHAR                NO-UNDO.
DEF VAR c-cgc                 AS CHAR                NO-UNDO.
DEF VAR i-cont                AS INT                 NO-UNDO.
DEF VAR i-posicao             AS INT                 NO-UNDO.
DEF VAR c-novo-arquivo        AS CHAR FORMAT "x(30)" NO-UNDO.
DEF VAR l-erro                AS LOG                 NO-UNDO.
DEF VAR i-seq                 AS INT                 NO-UNDO.
DEF VAR c-livre1              AS CHAR                NO-UNDO.
DEF VAR c-livre2              AS CHAR                NO-UNDO.
DEF VAR c-livre3              AS CHAR                NO-UNDO.
DEF VAR c-data-emis-nfse      AS CHAR                NO-UNDO. /*AAAA-MM-DD HH:MM:SS*/
DEF VAR c-tipo-erro           AS CHAR                NO-UNDO.
DEF VAR c-cod-prestador       AS CHAR                NO-UNDO.
DEF VAR c-cod-erro            AS CHAR                NO-UNDO.
DEF VAR c-des-erro            AS CHAR                NO-UNDO.
DEF VAR c-correcao            AS CHAR                NO-UNDO.
DEF VAR c-nome-arquivo        AS CHAR                NO-UNDO.
DEF VAR c-dt-importacao       AS CHAR                NO-UNDO.
DEF VAR c-registro-arquivo    AS CHAR                NO-UNDO.
DEF VAR c-tipo-registro       AS CHAR                NO-UNDO.
DEF VAR c-cod-status-espnfse  AS CHAR                NO-UNDO.
DEF VAR c-des-status-espnfse  AS CHAR FORMAT "x(30)" EXTENT 10.
DEF VAR i-arq-rps-lidos       AS INT                 NO-UNDO.
DEF VAR i-arq-rps-import      AS INT                 NO-UNDO.
DEF VAR i-arq-erro-lidos      AS INT                 NO-UNDO.
DEF VAR i-arq-erro-import     AS INT                 NO-UNDO.
DEFINE VARIABLE c-erro        AS CHARACTER           NO-UNDO.

/*Layout Mastersaf*/
DEF VAR c-v3-status              AS CHAR FORMAT "x(0004)" NO-UNDO.
DEF VAR c-v3-descricaoStatus     AS CHAR FORMAT "x(4000)" NO-UNDO.
DEF VAR c-v3-codCidade           AS CHAR FORMAT "x(0010)" NO-UNDO.
DEF VAR c-v3-siafiPrestador      AS CHAR FORMAT "x(0010)" NO-UNDO.
DEF VAR c-v3-numeroRps           AS CHAR FORMAT "x(0015)" NO-UNDO.
DEF VAR c-v3-serieRps            AS CHAR FORMAT "x(0005)" NO-UNDO.
DEF VAR c-v3-tipoRps             AS CHAR FORMAT "x(0020)" NO-UNDO.
DEF VAR c-v3-situacaoRps         AS CHAR FORMAT "x(0012)" NO-UNDO.
DEF VAR c-v3-dataEmissaoRps      AS CHAR FORMAT "x(0020)" NO-UNDO.
DEF VAR c-v3-dataAprovacao       AS CHAR FORMAT "x(0020)" NO-UNDO.
DEF VAR c-v3-dataCancelamento    AS CHAR FORMAT "x(0020)" NO-UNDO.
DEF VAR c-v3-docNum              AS CHAR FORMAT "x(0012)" NO-UNDO.
DEF VAR c-v3-numeroNFe           AS CHAR FORMAT "x(0012)" NO-UNDO.
DEF VAR c-v3-cnpjPrestador       AS CHAR FORMAT "x(0014)" NO-UNDO.
DEF VAR c-v3-inscricaoPrestador  AS CHAR FORMAT "x(0015)" NO-UNDO.
DEF VAR c-v3-aliquotaServicos    AS CHAR FORMAT "x(0009)" NO-UNDO.
DEF VAR c-v3-valorServicos       AS CHAR FORMAT "x(0017)" NO-UNDO.
DEF VAR c-v3-valorDeduzir        AS CHAR FORMAT "x(0017)" NO-UNDO.
DEF VAR c-v3-codigoVerificacao   AS CHAR FORMAT "x(0255)" NO-UNDO.
DEF VAR c-v3-codigoCancelamento  AS CHAR FORMAT "x(0255)" NO-UNDO.
DEF VAR c-v3-numeroLote          AS CHAR FORMAT "x(0012)" NO-UNDO.
DEF VAR c-v3-numeroProtocolo     AS CHAR FORMAT "x(0050)" NO-UNDO.
DEF VAR c-v3-tipoAmbienteSistema AS CHAR FORMAT "x(0001)" NO-UNDO.
DEF VAR c-v3-urlConsulta         AS CHAR FORMAT "x(0255)" NO-UNDO.

ASSIGN c-des-status-espnfse[10] = "N∆o Enviado"
       c-des-status-espnfse[1]  = "Enviado"
       c-des-status-espnfse[2]  = "Convertido"
       c-des-status-espnfse[3]  = "Erro Lote"
       c-des-status-espnfse[4]  = "Cancelado"
       c-des-status-espnfse[5]  = "Erro Lote"
       c-des-status-espnfse[6]  = "Erro RPS"
       c-des-status-espnfse[7]  = "Erro Cancelar"
       c-des-status-espnfse[8]  = "Realizando Integraá∆o"
       c-des-status-espnfse[9]  = "Erro Importaá∆o".

/** DEFINICAO: Stream do arquivo de importacao **/
DEF STREAM s-entrada.

/** DEFINICAO: Forms do relatorio **/
FORM tt-erro.c-arquivo   COLUMN-LABEL "Arquivo"
     tt-erro.cod-estabel COLUMN-LABEL "Estab"
     tt-erro.serie       COLUMN-LABEL "SÇrie"
     tt-erro.nr-nota-fis COLUMN-LABEL "Nr RPS"
     tt-erro.nr-nota-el  COLUMN-LABEL "Nr NFSe"
     tt-erro.cod-erro    COLUMN-LABEL "Cod Erro"
    WITH DOWN STREAM-IO NO-BOX WIDTH 132 FRAME f-nfse.

/** DEFINICAO: Tela de acompanhamento **/
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Exportando_RPS *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE ).

/** REGRA: Tabela de parametros do relatorio e global **/
FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST tt-param             NO-ERROR.

/** DEFINICAO: Padroes do FRW de relatorio **/
{include/i-rpvar.i}
{utp/ut-liter.i Importaá∆o_NFSe_-_Nota_Fiscal_Serviáo_Eletrìnica * r}
ASSIGN c-programa = "espnfse2030"
       c-versao   = c-prg-vrs
       c-revisao  = "000"
       c-titulo-relat = TRIM(RETURN-VALUE).

/** DEFINICAO: Identificao da empresa no relatorio **/
FOR FIRST mgcad.empresa FIELDS(nome) NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-prin:

    ASSIGN c-empresa = TRIM(STRING(param-global.empresa-prin))
                     + " - " 
                     + empresa.nome.
END.

{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.


/** ###################################### INICIO DO RELATORIO ###################################### **/

/** REGRA: Se o usuario informou um arquivo especifico, carregar este arquivo **/
IF  tt-param.arquivo-imp <> "" THEN DO:

    DO  i-cont = 1 TO 100:

        IF  i-cont >= R-INDEX(tt-param.arquivo-imp,".") THEN
            LEAVE.

        IF  SUBSTRING(tt-param.arquivo-imp,R-INDEX(tt-param.arquivo-imp,".") - i-cont,1) = "~\" OR
            SUBSTRING(tt-param.arquivo-imp,R-INDEX(tt-param.arquivo-imp,".") - i-cont,1) = "/" THEN DO:
            ASSIGN i-posicao = R-INDEX(tt-param.arquivo-imp,".") - i-cont.
            LEAVE.
        END.
    END.

    CREATE tt-arquivos.
    ASSIGN tt-arquivos.c-dir-arq-completo = tt-param.arquivo-imp
           tt-arquivos.c-arquivo          = SUBSTRING(tt-param.arquivo-imp,i-posicao + 1, LENGTH(tt-param.arquivo-imp) - i-posicao)
           tt-arquivos.c-tipo             = "F".
END.

/** REGRA: Se o usuario informou um diretorio especifico, carregar os arquivos desse diretorio **/
ELSE IF tt-param.diretorio-imp <> "" THEN DO:

    RUN pi-carrega-arquivos IN THIS-PROCEDURE (INPUT tt-param.diretorio-imp).
END.

/** REGRA: Se o usuario nao informou arquivo/diretorio especifico, carregar arquivos conforme diretorio padrao **/
ELSE DO:

    FOR EACH esp-ext-ser-estab NO-LOCK
       WHERE esp-ext-ser-estab.cod-estabel >= tt-param.cod-estabel-ini
         AND esp-ext-ser-estab.cod-estabel <= tt-param.cod-estabel-fim:

        RUN pi-carrega-arquivos IN THIS-PROCEDURE (INPUT esp-ext-ser-estab.dir-padrao-imp).
    END.
END.


/** REGRA: Considera apenas arquivos com extensao TXT **/
FOR EACH tt-arquivos
   WHERE tt-arquivos.c-tipo = "D"
      OR tt-arquivos.c-tipo = ""
      OR R-INDEX(tt-arquivos.c-dir-arq-completo, ".txt") = 0:
    
    DELETE tt-arquivos.
END.


/** REGRA: Importacao dos arquivos de SUCESSO **/
FOR EACH tt-arquivos
   WHERE R-INDEX(tt-arquivos.c-arquivo,"erro_nfse") = 0:

    RUN pi-acompanhar IN h-acomp (INPUT "Importando arquivos: " + tt-arquivos.c-dir-arq-completo).

    /** REGRA: Contador de arquivos lidos **/
    ASSIGN i-arq-rps-lidos = i-arq-rps-lidos + 1.

    /** REGRA: Retorno Sucesso CW NFSe **/
    IF  R-INDEX(tt-arquivos.c-arquivo,"nfse_lote") > 0 THEN DO:
        INPUT STREAM s-entrada FROM VALUE(tt-arquivos.c-dir-arq-completo) CONVERT TARGET "IBM850".
        REPEAT:

            ASSIGN c-nr-lote            = ""
                   c-nr-rps             = ""
                   c-serie              = ""
                   c-data-emis-rps      = ""
                   c-nr-nfse            = ""
                   c-cod-autenticidade  = ""
                   c-inscricao          = ""
                   c-livre1             = ""
                   c-livre2             = ""
                   c-livre3             = ""
                   c-data-emis-nfse     = ""
                   c-cod-status-espnfse = "".
    
            IMPORT STREAM s-entrada DELIMITER "|" c-nr-lote
                                                  c-nr-rps
                                                  c-serie
                                                  c-data-emis-rps
                                                  c-nr-nfse
                                                  c-cod-autenticidade
                                                  c-inscricao
                                                  c-livre1
                                                  c-livre2
                                                  c-livre3
                                                  c-data-emis-nfse
                                                  c-cod-status-espnfse.

            ASSIGN c-serie = "R2".
    
            /** REGRA: Encontra o estabelecimento atraves do CNPJ **/
            FOR EACH esp-ext-ser-estab NO-LOCK,
                FIRST estabelec NO-LOCK
                WHERE estabelec.cod-estabel = esp-ext-ser-estab.cod-estabel:
    
                ASSIGN c-cgc = REPLACE(REPLACE(estabelec.cgc,"/",""),".","")
                       c-cgc = REPLACE(c-cgc,"-","").
    
                IF  c-cgc = c-inscricao THEN DO:
                    ASSIGN c-cod-estabel = estabelec.cod-estabel.
                    LEAVE.
                END.
            END.
    
            /** VALIDACAO: Se nao encontrou estabelecimento **/
            IF  c-cod-estabel = "" THEN DO:
                RUN pi-gera-erro (INPUT 17006,
                                  INPUT "N∆o foi encontrado um estabelecimento v†lido (ESPNFSE2040) para CNPJ: " + c-inscricao,
                                  INPUT "",
                                  INPUT "",
                                  INPUT "",
                                  INPUT "",
                                  INPUT tt-arquivos.c-arquivo).
            END.
            ELSE DO:
                /** VALIDACAO: Se o estabelecimento esta fora da faixa **/
                IF  c-cod-estabel < tt-param.cod-estabel-ini OR
                    c-cod-estabel > tt-param.cod-estabel-fim THEN DO:
                    RUN pi-gera-erro (INPUT 17006,
                                      INPUT "Este arquivo contÇm NFSe de outro estabelecimento: " + c-cod-estabel,
                                      INPUT "",
                                      INPUT "",
                                      INPUT "",
                                      INPUT "",
                                      INPUT tt-arquivos.c-arquivo).
                END.
                ELSE DO:
    
                    /** REGRA: Importando registro do arquivo **/
                    ASSIGN i-seq = 1.
                    FOR LAST tt-nfse:
                        ASSIGN i-seq = tt-nfse.sequencia + 1.
                    END.
        
                    CREATE tt-nfse.
                    ASSIGN tt-nfse.sequencia          = i-seq
                           tt-nfse.cod-estabel        = c-cod-estabel
                           tt-nfse.serie              = c-serie
                           tt-nfse.nr-rps             = c-nr-rps
                           tt-nfse.nr-nota-fis        = c-nr-nfse
                           tt-nfse.c-cnpj-estab       = c-inscricao
                           tt-nfse.dt-emis-nfse       = DATE(c-data-emis-nfse)
                           /*tt-nfse.dt-emis-nfse       = DATE(  SUBSTRING(c-data-emis-nfse,1,2) + "/"
                                                             + SUBSTRING(c-data-emis-nfse,4,2) + "/"
                                                             + SUBSTRING(c-data-emis-nfse,7,4))*/
                           tt-nfse.i-status-rps       = IF c-cod-status-espnfse = "0"
                                                           THEN 10
                                                           ELSE INT(c-cod-status-espnfse)
                           tt-nfse.c-cod-verificacao  = c-cod-autenticidade
                           tt-nfse.c-arquivo          = tt-arquivos.c-arquivo
                           tt-nfse.c-dir-arq-completo = tt-arquivos.c-dir-arq-completo
                           tt-nfse.c-sistema          = "1" /*CW NFSe*/
                           tt-nfse.l-situacao-imp     = NO.
                END.
            END.
        END.

        INPUT STREAM s-entrada CLOSE.
    END.
    /** REGRA: Retorno Mastersaf **/
    ELSE DO:
        INPUT STREAM s-entrada FROM VALUE(tt-arquivos.c-dir-arq-completo) CONVERT TARGET "IBM850".
        REPEAT:
            ASSIGN c-v3-status               = ""
                   c-v3-descricaoStatus      = ""
                   c-v3-codCidade            = ""
                   c-v3-siafiPrestador       = ""
                   c-v3-numeroRps            = ""
                   c-v3-serieRps             = ""
                   c-v3-tipoRps              = ""
                   c-v3-situacaoRps          = ""
                   c-v3-dataEmissaoRps       = ""
                   c-v3-dataAprovacao        = ""
                   c-v3-dataCancelamento     = ""
                   c-v3-docNum               = ""
                   c-v3-numeroNFe            = ""
                   c-v3-cnpjPrestador        = ""
                   c-v3-inscricaoPrestador   = ""
                   c-v3-aliquotaServicos     = ""
                   c-v3-valorServicos        = ""
                   c-v3-valorDeduzir         = ""
                   c-v3-codigoVerificacao    = ""
                   c-v3-codigoCancelamento   = ""
                   c-v3-numeroLote           = ""
                   c-v3-numeroProtocolo      = ""
                   c-v3-tipoAmbienteSistema  = ""
                   c-v3-urlConsulta          = "".
    
            IMPORT STREAM s-entrada DELIMITER "|" c-v3-status
                                                  c-v3-descricaoStatus
                                                  c-v3-codCidade
                                                  c-v3-siafiPrestador
                                                  c-v3-numeroRps
                                                  c-v3-serieRps
                                                  c-v3-tipoRps
                                                  c-v3-situacaoRps
                                                  c-v3-dataEmissaoRps
                                                  c-v3-dataAprovacao
                                                  c-v3-dataCancelamento
                                                  c-v3-docNum
                                                  c-v3-numeroNFe
                                                  c-v3-cnpjPrestador
                                                  c-v3-inscricaoPrestador
                                                  c-v3-aliquotaServicos
                                                  c-v3-valorServicos
                                                  c-v3-valorDeduzir
                                                  c-v3-codigoVerificacao
                                                  c-v3-codigoCancelamento
                                                  c-v3-numeroLote
                                                  c-v3-numeroProtocolo
                                                  c-v3-tipoAmbienteSistema
                                                  c-v3-urlConsulta.

            ASSIGN c-v3-serieRps = "R2".

            /** REGRA: Encontra o estabelecimento atraves do CNPJ **/
            FOR EACH esp-ext-ser-estab NO-LOCK,
                FIRST estabelec NO-LOCK
                WHERE estabelec.cod-estabel = esp-ext-ser-estab.cod-estabel:
    
                ASSIGN c-cgc = REPLACE(REPLACE(estabelec.cgc,"/",""),".","")
                       c-cgc = REPLACE(c-cgc,"-","").
    
                IF  c-cgc = c-v3-cnpjPrestador THEN DO:
                    ASSIGN c-cod-estabel = estabelec.cod-estabel.
                    LEAVE.
                END.
            END.
    
            /** VALIDACAO: Se nao encontrou estabelecimento **/
            IF  c-cod-estabel = "" THEN DO:
                RUN pi-gera-erro (INPUT 17006,
                                  INPUT "N∆o foi encontrado um estabelecimento v†lido (ESPNFSE2040) para CNPJ: " + c-v3-cnpjPrestador,
                                  INPUT "",
                                  INPUT "",
                                  INPUT "",
                                  INPUT "",
                                  INPUT tt-arquivos.c-arquivo).
            END.
            ELSE DO:
                /** VALIDACAO: Se o estabelecimento esta fora da faixa **/
                IF  c-cod-estabel < tt-param.cod-estabel-ini OR
                    c-cod-estabel > tt-param.cod-estabel-fim THEN DO:
                    RUN pi-gera-erro (INPUT 17006,
                                      INPUT "Este arquivo contÇm NFSe de outro estabelecimento: " + c-cod-estabel,
                                      INPUT "",
                                      INPUT "",
                                      INPUT "",
                                      INPUT "",
                                      INPUT tt-arquivos.c-arquivo).
                END.
                ELSE DO:
    
                    /** REGRA: Importando registro do arquivo - SUCESSO **/
                    IF  INT(c-v3-status) = 100 OR
                        INT(c-v3-status) = 101 THEN DO:

                        ASSIGN i-seq = 1.
                        FOR LAST tt-nfse:
                            ASSIGN i-seq = tt-nfse.sequencia + 1.
                        END.
            
                        ASSIGN c-v3-numeroNFe = string(int(c-v3-numeroNFe),"9999999").

                        CREATE tt-nfse.
                        ASSIGN tt-nfse.sequencia          = i-seq
                               tt-nfse.cod-estabel        = c-cod-estabel
                               tt-nfse.serie              = c-v3-serieRps
                               tt-nfse.nr-rps             = c-v3-numeroRps
                               tt-nfse.nr-nota-fis        = c-v3-numeroNFe
                               tt-nfse.c-cnpj-estab       = c-v3-cnpjPrestador
                               /*tt-nfse.dt-emis-nfse       = DATE(c-data-emis-nfse)*/
                               /*tt-nfse.dt-emis-nfse       = DATE(  SUBSTRING(c-data-emis-nfse,1,2) + "/"
                                                                 + SUBSTRING(c-data-emis-nfse,4,2) + "/"
                                                                 + SUBSTRING(c-data-emis-nfse,7,4))*/
                               tt-nfse.i-status-rps       = INT(c-v3-status)
                               tt-nfse.c-cod-verificacao  = c-v3-codigoVerificacao
                               tt-nfse.c-arquivo          = tt-arquivos.c-arquivo
                               tt-nfse.c-dir-arq-completo = tt-arquivos.c-dir-arq-completo
                               tt-nfse.c-sistema          = "2" /*Mastersaf V3*/
                               tt-nfse.c-url-consulta     = c-v3-urlConsulta
                               tt-nfse.l-situacao-imp     = NO.
                    END.

                    /** REGRA: Importando registro do arquivo - ERRO **/
                    ELSE DO:

                        ASSIGN i-seq = 1.
                        FOR LAST tt-erro-nfse:
                            ASSIGN i-seq = tt-erro-nfse.sequencia + 1.
                        END.
        
                        CREATE tt-erro-nfse.
                        ASSIGN tt-erro-nfse.sequencia          = i-seq
                               tt-erro-nfse.cod-estabel        = c-cod-estabel
                               tt-erro-nfse.nr-rps             = c-v3-numeroRps
                               tt-erro-nfse.serie              = c-v3-serieRps
                               tt-erro-nfse.nr-lote            = INT(c-v3-numeroLote)
                               tt-erro-nfse.cod-erro           = c-v3-status
                               tt-erro-nfse.des-erro           = c-v3-descricaoStatus
                               tt-erro-nfse.des-correcao       = ""
                               tt-erro-nfse.nome-arquivo       = c-nome-arquivo
                               tt-erro-nfse.hr-importacao      = STRING(time,"HH:MM:SS")
                               tt-erro-nfse.linha-registro     = ""
                               tt-erro-nfse.tipo-registro      = ""
                               tt-erro-nfse.c-arquivo          = tt-arquivos.c-arquivo
                               tt-erro-nfse.c-dir-arq-completo = tt-arquivos.c-dir-arq-completo
                               tt-erro-nfse.l-situacao-imp     = NO
                               tt-erro-nfse.dt-importacao      = TODAY
                               tt-erro-nfse.c-registro-arquivo = ""
                               tt-erro-nfse.c-sistema          = "2" /*Mastersaf V3*/.

                        IF  INT(c-v3-status) = 200 THEN
                            ASSIGN tt-erro-nfse.tipo-erro = "ER".
                        ELSE
                            ASSIGN tt-erro-nfse.tipo-erro = "EE".
                    END.
                END.
            END.
        END.

        INPUT STREAM s-entrada CLOSE.
    END.
END.


/** REGRA: Importacao dos arquivos de ERRO (somente CW NFSe) **/
FOR EACH tt-arquivos
   WHERE R-INDEX(tt-arquivos.c-arquivo,"erro_nfse") > 0:

    RUN pi-acompanhar IN h-acomp (INPUT "Importando arquivos: " + tt-arquivos.c-dir-arq-completo).

    /** REGRA: Contador de arquivos lidos **/
    ASSIGN i-arq-erro-lidos = i-arq-erro-lidos + 1.

    INPUT STREAM s-entrada FROM VALUE(tt-arquivos.c-dir-arq-completo) CONVERT TARGET "IBM850".
    REPEAT:
        ASSIGN c-tipo-erro        = ""
               c-nr-lote          = ""
               c-nr-rps           = ""
               c-serie            = ""
               c-cod-prestador    = ""
               c-cod-erro         = ""
               c-des-erro         = ""
               c-correcao         = ""
               c-inscricao        = ""
               c-nome-arquivo     = ""
               c-dt-importacao    = ""
               c-registro-arquivo = ""
               c-tipo-registro    = ""
               c-livre1           = ""
               c-livre2           = ""
               c-livre3           = "".

        IMPORT STREAM s-entrada DELIMITER "|" c-tipo-erro
                                              c-nr-lote
                                              c-nr-rps
                                              c-serie
                                              c-cod-prestador
                                              c-cod-erro
                                              c-des-erro
                                              c-correcao
                                              c-inscricao
                                              c-nome-arquivo
                                              c-dt-importacao
                                              c-registro-arquivo
                                              c-tipo-registro
                                              c-livre1
                                              c-livre2
                                              c-livre3.

        ASSIGN c-serie = "R2".

        /** REGRA: Erros que n∆o retornam com a chave do RPS, considera conte£do do arquivo de envio quando existir **/
        IF  c-nr-rps = "" AND
            c-registro-arquivo <> "" THEN DO:

            ASSIGN c-nr-rps    = RIGHT-TRIM(SUBSTRING(ENTRY(7,c-registro-arquivo,"<<,>>"),4,20))
                   c-serie     = "R2" /* RIGHT-TRIM(SUBSTRING(ENTRY(5,c-registro-arquivo,"<<,>>"),4,20))*/
                   c-inscricao = RIGHT-TRIM(SUBSTRING(ENTRY(97,c-registro-arquivo,"<<,>>"),4,20)) NO-ERROR.
        END.


        /** REGRA: Ignorar registros que nao tem o numero da nota (exportacao cadastro do item) **/
        IF  c-nr-rps <> "" THEN DO:

            /** REGRA: Encontra o estabelecimento atraves do CNPJ **/
            FOR EACH esp-ext-ser-estab NO-LOCK,
                FIRST estabelec NO-LOCK
                WHERE estabelec.cod-estabel = esp-ext-ser-estab.cod-estabel:
    
                ASSIGN c-cgc = REPLACE(REPLACE(estabelec.cgc,"/",""),".","")
                       c-cgc = REPLACE(c-cgc,"-","").
    
                IF  c-cgc = c-inscricao THEN DO:
                    ASSIGN c-cod-estabel = estabelec.cod-estabel.
                    LEAVE.
                END.
            END.
    
            /** VALIDACAO: Se nao encontrou estabelecimento **/
            IF  c-cod-estabel = "" THEN DO:
                RUN pi-gera-erro (INPUT 17006,
                                  INPUT "N∆o foi encontrado um estabelecimento v†lido (ESPNFSE2040) para CNPJ: " + c-inscricao,
                                  INPUT "",
                                  INPUT "",
                                  INPUT "",
                                  INPUT "",
                                  INPUT tt-arquivos.c-arquivo).
            END.
            ELSE DO:
                /** VALIDACAO: Se o estabelecimento esta fora da faixa **/
                IF  c-cod-estabel < tt-param.cod-estabel-ini OR
                    c-cod-estabel > tt-param.cod-estabel-fim THEN DO:
                    RUN pi-gera-erro (INPUT 17006,
                                      INPUT "Este arquivo contÇm erros de outro estabelecimento: " + c-cod-estabel,
                                      INPUT "",
                                      INPUT "",
                                      INPUT "",
                                      INPUT "",
                                      INPUT tt-arquivos.c-arquivo).
                END.
                ELSE DO:
                    
                    /** REGRA: Importando registro do arquivo **/
                    ASSIGN i-seq = 1.
                    FOR LAST tt-erro-nfse:
                        ASSIGN i-seq = tt-erro-nfse.sequencia + 1.
                    END.
    
                    CREATE tt-erro-nfse.
                    ASSIGN tt-erro-nfse.sequencia          = i-seq
                           tt-erro-nfse.cod-estabel        = c-cod-estabel
                           tt-erro-nfse.nr-rps             = c-nr-rps
                           tt-erro-nfse.serie              = c-serie
                           tt-erro-nfse.tipo-erro          = c-tipo-erro
                           tt-erro-nfse.nr-lote            = INT(c-nr-lote)
                           tt-erro-nfse.cod-erro           = c-cod-erro
                           tt-erro-nfse.des-erro           = REPLACE(c-des-erro,"<<ENTER>>",CHR(10))
                           tt-erro-nfse.des-correcao       = REPLACE(c-correcao,"<<ENTER>>",CHR(10))
                           tt-erro-nfse.nome-arquivo       = c-nome-arquivo
                           tt-erro-nfse.hr-importacao      = SUBSTRING(c-dt-importacao,11,8)
                           tt-erro-nfse.linha-registro     = c-registro-arquivo
                           tt-erro-nfse.tipo-registro      = c-tipo-registro
                           tt-erro-nfse.c-arquivo          = tt-arquivos.c-arquivo
                           tt-erro-nfse.c-dir-arq-completo = tt-arquivos.c-dir-arq-completo
                           tt-erro-nfse.l-situacao-imp     = NO
                           tt-erro-nfse.dt-importacao      = DATE(c-dt-importacao)
                           tt-erro-nfse.c-registro-arquivo = c-registro-arquivo
                           tt-erro-nfse.c-sistema          = "1" /*CW NFSe*/.
                END.
            END.
        END.
    END.

    INPUT STREAM s-entrada CLOSE.
END.

/*****************************************************************************************************************************
######################################### E S P A C O   P A R A   C U S T O M I Z A C A O ####################################
*****************************************************************************************************************************/
IF  SEARCH("rpp/espnfse2030x.p") <> ? OR
    SEARCH("rpp/espnfse2030x.r") <> ? THEN DO:
    
    RUN pi-acompanhar IN h-acomp (INPUT "Customizaá∆o dos dados...").
    
    RUN rpp/espnfse2030x.p (INPUT-OUTPUT TABLE tt-nfse,
                            INPUT-OUTPUT TABLE tt-erro-nfse,
                            INPUT-OUTPUT TABLE tt-erro,
                            INPUT THIS-PROCEDURE).
END.


RUN pi-acompanhar IN h-acomp (INPUT "Validando dados...").

/** VALIDACAO: Outras validacoes da importacao - Arquivo de Sucesso **/
FOR EACH tt-nfse:

    IF  NOT CAN-FIND(FIRST esp-ext-ser-estab
                     WHERE esp-ext-ser-estab.cod-estabel = tt-nfse.cod-estabel
                       AND esp-ext-ser-estab.serie       = tt-nfse.serie) THEN DO:

        RUN pi-gera-erro (INPUT 158,
                          INPUT "Relacionamento SÇrie x Estabelecimento n∆o foi encontrado",
                          INPUT tt-nfse.cod-estabel,
                          INPUT tt-nfse.serie,
                          INPUT tt-nfse.nr-rps,
                          INPUT "",
                          INPUT tt-nfse.c-arquivo).
    END.

    ELSE DO:

         /** REGRA: Quando situacao atualizada na chamada X **/
        IF  tt-nfse.l-situacao-imp = YES THEN
            NEXT.

        /** REGRA: Layout CW NFSe**/
        IF  tt-nfse.c-sistema = "1" THEN DO:

            /** REGRA: Importacao de NFSe convertida **/
            IF  tt-nfse.i-status-rps = 2 THEN DO:
        
                FIND FIRST nota-fiscal NO-LOCK
                     WHERE nota-fiscal.cod-estabel = tt-nfse.cod-estabel
                       AND nota-fiscal.serie       = tt-nfse.serie
                       AND nota-fiscal.nr-nota-fis = STRING(INT(tt-nfse.nr-rps),"9999999") NO-ERROR.
            
                IF  NOT AVAIL(nota-fiscal) THEN DO:
                    RUN pi-gera-erro (INPUT 2,
                                      INPUT "RPS",
                                      INPUT tt-nfse.cod-estabel,
                                      INPUT tt-nfse.serie,
                                      INPUT tt-nfse.nr-rps,
                                      INPUT "",
                                      INPUT tt-nfse.c-arquivo).
                END.
                ELSE DO:
            
                    FIND FIRST esp-ext-nota-fiscal NO-LOCK
                         WHERE esp-ext-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                           AND esp-ext-nota-fiscal.serie       = nota-fiscal.serie
                           AND esp-ext-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
    
                    IF  AVAIL esp-ext-nota-fiscal THEN DO:
                        IF  NOT esp-ext-nota-fiscal.processada THEN DO:
                            RUN pi-gera-erro (INPUT 28006,
                                              INPUT "RPS N∆o Foi Processado e Enviado ",
                                              INPUT tt-nfse.cod-estabel,
                                              INPUT tt-nfse.serie,
                                              INPUT tt-nfse.nr-rps,
                                              INPUT "",
                                              INPUT tt-nfse.c-arquivo).
                        END.
                        ELSE DO:
                            /** REGRA: Registro apto para atualizacao **/
                            ASSIGN tt-nfse.l-situacao-imp = YES.
                        END.
                    END.
                    ELSE DO:
                        RUN pi-gera-erro (INPUT 2,
                                          INPUT "Extens∆o da RPS",
                                          INPUT tt-nfse.cod-estabel,
                                          INPUT tt-nfse.serie,
                                          INPUT tt-nfse.nr-rps,
                                          INPUT "",
                                          INPUT tt-nfse.c-arquivo).
                    END.
                END.
            END.
        
            /** REGRA: Importacao de NFSe cancelada **/
            ELSE IF tt-nfse.i-status-rps = 4 THEN DO:
        
                FIND FIRST nota-fiscal NO-LOCK
                     WHERE nota-fiscal.cod-estabel = tt-nfse.cod-estabel
                       AND nota-fiscal.serie       = tt-nfse.serie
                       AND nota-fiscal.nr-nota-fis = STRING(INT(tt-nfse.nr-rps),"9999999")
                       AND nota-fiscal.dt-cancela <> ? NO-ERROR.
            
                IF  NOT AVAIL(nota-fiscal) THEN DO:
                    RUN pi-gera-erro (INPUT 2,
                                      INPUT "Cancelamento de NFS-e",
                                      INPUT tt-nfse.cod-estabel,
                                      INPUT tt-nfse.serie,
                                      INPUT tt-nfse.nr-rps,
                                      INPUT "",
                                      INPUT tt-nfse.c-arquivo).
                END.
                ELSE DO:
    
                    FIND FIRST esp-ext-nota-fiscal NO-LOCK
                         WHERE esp-ext-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                           AND esp-ext-nota-fiscal.serie       = nota-fiscal.serie
                           AND esp-ext-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
    
                    IF  AVAIL esp-ext-nota-fiscal THEN DO:
                        IF  esp-ext-nota-fiscal.int-1 < 2 THEN DO:
            
                            RUN pi-gera-erro (INPUT 17006, 
                                              INPUT "Solicitaá∆o de Cancelamento n∆o foi Processado e Enviado ",
                                              INPUT tt-nfse.cod-estabel,
                                              INPUT tt-nfse.serie,
                                              INPUT tt-nfse.nr-rps,
                                              INPUT "",
                                              INPUT tt-nfse.c-arquivo).
                        END.
                        ELSE DO:
                            /** REGRA: Registro apto para atualizacao **/
                            ASSIGN tt-nfse.l-situacao-imp = YES.
                        END.
                    END.
                    ELSE DO:
                         RUN pi-gera-erro (INPUT 2,
                                          INPUT "Extens∆o do Cancelamento da RPS",
                                          INPUT tt-nfse.cod-estabel,
                                          INPUT tt-nfse.serie,
                                          INPUT tt-nfse.nr-rps,
                                          INPUT "",
                                          INPUT tt-nfse.c-arquivo).
                    END.
                END.
            END.
            ELSE DO:
                RUN pi-gera-erro (INPUT 17006,
                                  INPUT "Status de retorno Inv†lido",
                                  INPUT tt-nfse.cod-estabel,
                                  INPUT tt-nfse.serie,
                                  INPUT tt-nfse.nr-rps,
                                  INPUT "",
                                  INPUT tt-nfse.c-arquivo).
            END.
        END.

        /** REGRA: Layout Mastersaf V3**/
        ELSE DO:

            /** REGRA: Importacao de NFSe convertida **/
            IF  tt-nfse.i-status-rps = 100 THEN DO:
        
                FIND FIRST nota-fiscal NO-LOCK
                     WHERE nota-fiscal.cod-estabel = tt-nfse.cod-estabel
                       AND nota-fiscal.serie       = tt-nfse.serie
                       AND nota-fiscal.nr-nota-fis = STRING(INT(tt-nfse.nr-rps),"9999999") NO-ERROR.
            
                IF  NOT AVAIL(nota-fiscal) THEN DO:
                    RUN pi-gera-erro (INPUT 2,
                                      INPUT "RPS",
                                      INPUT tt-nfse.cod-estabel,
                                      INPUT tt-nfse.serie,
                                      INPUT tt-nfse.nr-rps,
                                      INPUT "",
                                      INPUT tt-nfse.c-arquivo).
                END.
                ELSE DO:
            
                    FIND FIRST esp-ext-nota-fiscal NO-LOCK
                         WHERE esp-ext-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                           AND esp-ext-nota-fiscal.serie       = nota-fiscal.serie
                           AND esp-ext-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
    
                    IF  AVAIL esp-ext-nota-fiscal THEN DO:
                        IF  NOT esp-ext-nota-fiscal.processada THEN DO:
                            RUN pi-gera-erro (INPUT 28006,
                                              INPUT "RPS N∆o Foi Processado e Enviado ",
                                              INPUT tt-nfse.cod-estabel,
                                              INPUT tt-nfse.serie,
                                              INPUT tt-nfse.nr-rps,
                                              INPUT "",
                                              INPUT tt-nfse.c-arquivo).
                        END.
                        ELSE DO:
                            /** REGRA: Registro apto para atualizacao **/
                            ASSIGN tt-nfse.l-situacao-imp = YES.
                        END.
                    END.
                    ELSE DO:
                        RUN pi-gera-erro (INPUT 2,
                                          INPUT "Extens∆o da RPS",
                                          INPUT tt-nfse.cod-estabel,
                                          INPUT tt-nfse.serie,
                                          INPUT tt-nfse.nr-rps,
                                          INPUT "",
                                          INPUT tt-nfse.c-arquivo).
                    END.
                END.
            END.
        
            /** REGRA: Importacao de NFSe cancelada **/
            ELSE IF tt-nfse.i-status-rps = 101 THEN DO:
        
                FIND FIRST nota-fiscal NO-LOCK
                     WHERE nota-fiscal.cod-estabel = tt-nfse.cod-estabel
                       AND nota-fiscal.serie       = tt-nfse.serie
                       AND nota-fiscal.nr-nota-fis = STRING(INT(tt-nfse.nr-rps),"9999999")
                       AND nota-fiscal.dt-cancela <> ? NO-ERROR.
            
                IF  NOT AVAIL(nota-fiscal) THEN DO:
                    RUN pi-gera-erro (INPUT 2,
                                      INPUT "Cancelamento de NFS-e",
                                      INPUT tt-nfse.cod-estabel,
                                      INPUT tt-nfse.serie,
                                      INPUT tt-nfse.nr-rps,
                                      INPUT "",
                                      INPUT tt-nfse.c-arquivo).
                END.
                ELSE DO:
    
                    FIND FIRST esp-ext-nota-fiscal NO-LOCK
                         WHERE esp-ext-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                           AND esp-ext-nota-fiscal.serie       = nota-fiscal.serie
                           AND esp-ext-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
    
                    IF  AVAIL esp-ext-nota-fiscal THEN DO:
                        IF  esp-ext-nota-fiscal.int-1 < 2 THEN DO:
            
                            RUN pi-gera-erro (INPUT 17006, 
                                              INPUT "Solicitaá∆o de Cancelamento n∆o foi Processado e Enviado ",
                                              INPUT tt-nfse.cod-estabel,
                                              INPUT tt-nfse.serie,
                                              INPUT tt-nfse.nr-rps,
                                              INPUT "",
                                              INPUT tt-nfse.c-arquivo).
                        END.
                        ELSE DO:
                            /** REGRA: Registro apto para atualizacao **/
                            ASSIGN tt-nfse.l-situacao-imp = YES.
                        END.
                    END.
                    ELSE DO:
                         RUN pi-gera-erro (INPUT 2,
                                          INPUT "Extens∆o do Cancelamento da RPS",
                                          INPUT tt-nfse.cod-estabel,
                                          INPUT tt-nfse.serie,
                                          INPUT tt-nfse.nr-rps,
                                          INPUT "",
                                          INPUT tt-nfse.c-arquivo).
                    END.
                END.
            END.
            ELSE DO:

                RUN pi-gera-erro (INPUT 17006,
                                  INPUT "Status de retorno Inv†lido: " + STRING(tt-nfse.i-status-rps),
                                  INPUT tt-nfse.cod-estabel,
                                  INPUT tt-nfse.serie,
                                  INPUT tt-nfse.nr-rps,
                                  INPUT "",
                                  INPUT tt-nfse.c-arquivo).
            END.
        END.
    END.
    FIND FIRST nota-fiscal EXCLUSIVE-LOCK
         WHERE nota-fiscal.cod-estabel = tt-nfse.cod-estabel
           AND nota-fiscal.serie       = tt-nfse.serie
           AND nota-fiscal.nr-nota-fis = STRING(INT(tt-nfse.nr-rps),"9999999") NO-ERROR.
    IF AVAIL nota-fiscal THEN DO:

        &if '{&bf_dis_versao_ems}' >= '2.09':U &then
            ASSIGN nota-fiscal.cod-verific-nf-serv-eletro = tt-nfse.c-cod-verificacao.
        &else
            ASSIGN OVERLAY(nota-fiscal.char-1,163,15)     = tt-nfse.c-cod-verificacao.
        &endif.
        
    END. /* IF AVAIL nota-fiscal THEN DO: */


END.


/** VALIDACAO: Outras validacoes da importacao - Arquivo de Erro **/
FOR EACH tt-erro-nfse:

    IF  NOT CAN-FIND(FIRST esp-ext-ser-estab
                     WHERE esp-ext-ser-estab.cod-estabel = tt-erro-nfse.cod-estabel
                       AND esp-ext-ser-estab.serie       = tt-erro-nfse.serie) THEN DO:

        RUN pi-gera-erro (INPUT 158,
                          INPUT "Relacionamento SÇrie x Estabelecimento n∆o foi encontrado",
                          INPUT tt-erro-nfse.cod-estabel,
                          INPUT tt-erro-nfse.serie,
                          INPUT tt-erro-nfse.nr-rps,
                          INPUT "",
                          INPUT tt-erro-nfse.c-arquivo).
    END.
    ELSE DO:
    
        FIND FIRST nota-fiscal NO-LOCK
             WHERE nota-fiscal.cod-estabel = tt-erro-nfse.cod-estabel
               AND nota-fiscal.serie       = tt-erro-nfse.serie
               AND nota-fiscal.nr-nota-fis = STRING(INT(tt-erro-nfse.nr-rps),"9999999") NO-ERROR.
    
        IF  NOT AVAIL(nota-fiscal) THEN DO:
            RUN pi-gera-erro (INPUT 2,
                              INPUT "RPS",
                              INPUT tt-erro-nfse.cod-estabel,
                              INPUT tt-erro-nfse.serie,
                              INPUT tt-erro-nfse.nr-rps,
                              INPUT "",
                              INPUT tt-erro-nfse.c-arquivo).
        END.
        ELSE DO:
            /** REGRA: Registro apto para atualizacao **/
            ASSIGN tt-erro-nfse.l-situacao-imp = YES.
        END.
    END.
END.

RUN pi-acompanhar IN h-acomp (INPUT "Atualizando dados...").

/** REGRA: Atualizacao dos registros aptos para importacao - Arquivo de Sucesso **/
FOR EACH tt-nfse
   WHERE tt-nfse.l-situacao-imp
   BREAK BY tt-nfse.c-arquivo:

    FOR FIRST esp-ext-nota-fiscal EXCLUSIVE-LOCK
        WHERE esp-ext-nota-fiscal.cod-estabel = tt-nfse.cod-estabel
          AND esp-ext-nota-fiscal.serie       = tt-nfse.serie
          AND esp-ext-nota-fiscal.nr-nota-fis = STRING(INT(tt-nfse.nr-rps),"9999999"):


        /** REGRA: Importacao de NFSe convertida **/
        IF  tt-nfse.i-status-rps = 2   OR        /*Aprovado CW NFSe*/
            tt-nfse.i-status-rps = 100 THEN DO:  /*Aprovado Mastersaf V3*/
            
            ASSIGN esp-ext-nota-fiscal.nr-nota-el        = tt-nfse.nr-nota-fis
                   esp-ext-nota-fiscal.serie-el          = tt-nfse.serie
                   esp-ext-nota-fiscal.dt-emis-el        = tt-nfse.dt-emis-nfse
                   esp-ext-nota-fiscal.cod-autentic-nfe  = tt-nfse.c-cod-verificacao
                   esp-ext-nota-fiscal.url-consulta-nfse = tt-nfse.c-url-consulta.
            
            /** REGRA: Atualiza Status da NFSe Cancelada quando for substituiá∆o **/
            IF  esp-ext-nota-fiscal.nr-nota-fis-subs <> "" THEN DO:

                FOR FIRST bf-esp-ext-nota-fiscal EXCLUSIVE-LOCK
                    WHERE bf-esp-ext-nota-fiscal.cod-estabel = esp-ext-nota-fiscal.cod-estabel
                      AND bf-esp-ext-nota-fiscal.nr-nota-el  = esp-ext-nota-fiscal.nr-nota-fis-subs:
                    
                    ASSIGN bf-esp-ext-nota-fiscal.int-1 = 3. /*1-Cancelamento Pendente, 2-Cancelamento Enviado, 3-Cancelamento Confirmado*/
                END.
            END.

            RUN pi-gera-erro (INPUT 1103,
                              INPUT "Atualizado N£mero NFSe",
                              INPUT tt-nfse.cod-estabel,
                              INPUT tt-nfse.serie,
                              INPUT STRING(INT(tt-nfse.nr-rps),"9999999"),
                              INPUT tt-nfse.nr-nota-fis,
                              INPUT tt-nfse.c-arquivo).

/* Rotina para mudar a numeracao da nota fiscal de acordo com o numero da nota de saida gerada pela prefeitura */
/* Situacao nao atendida pelo Mastersaf */

            RUN upc/espnfse2030-upc.p (INPUT esp-ext-nota-fiscal.cod-estabel,
                                       INPUT esp-ext-nota-fiscal.serie,
                                       INPUT esp-ext-nota-fiscal.nr-nota-fis,
                                       INPUT STRING(INT(esp-ext-nota-fiscal.nr-nota-el),"9999999"),
                                       INPUT "S2",
                                       OUTPUT c-erro).
            IF c-erro <> "" THEN DO:
                RUN pi-gera-erro (INPUT 17006,
                                  INPUT c-erro,
                                  INPUT tt-nfse.cod-estabel,
                                  INPUT tt-nfse.serie,
                                  INPUT STRING(INT(tt-nfse.nr-rps),"9999999"),
                                  INPUT tt-nfse.nr-nota-fis,
                                  INPUT tt-nfse.c-arquivo).
                UNDO, NEXT.

            END.
        END.
    
        /** REGRA: Importacao de NFSe cancelada **/
        ELSE IF tt-nfse.i-status-rps = 4   OR       /*Cancelada CW NFSe*/
                tt-nfse.i-status-rps = 101 THEN DO: /*Cancelada Mastersaf V3*/
    
            ASSIGN esp-ext-nota-fiscal.int-1            = 3 /*1-Cancelamento Pendente, 2-Cancelamento Enviado, 3-Cancelamento Confirmado*/
                   esp-ext-nota-fiscal.nr-nota-el       = tt-nfse.nr-nota-fis
                   esp-ext-nota-fiscal.serie-el         = tt-nfse.serie
                   esp-ext-nota-fiscal.dt-emis-el       = tt-nfse.dt-emis-nfse
                   esp-ext-nota-fiscal.cod-autentic-nfe = tt-nfse.c-cod-verificacao.
    
            RUN pi-gera-erro (INPUT 17006,
                              INPUT "Cancelamento da NFSe Confirmado",
                              INPUT tt-nfse.cod-estabel,
                              INPUT tt-nfse.serie,
                              INPUT STRING(INT(tt-nfse.nr-rps),"9999999"),
                              INPUT tt-nfse.nr-nota-fis,
                              INPUT tt-nfse.c-arquivo).
        END.
    END.

    /** REGRA: Renomear o arquivo importado para extensao .bkp **/
    IF  LAST-OF(tt-nfse.c-arquivo) THEN DO:
        ASSIGN c-novo-arquivo   = REPLACE(tt-nfse.c-dir-arq-completo,".txt",".bkp")
               i-arq-rps-import = i-arq-rps-import + 1.
        OS-RENAME VALUE(tt-nfse.c-dir-arq-completo) VALUE(c-novo-arquivo).
    END.
END.


/** REGRA: Atualizacao dos registros aptos para importacao - Arquivo de Erro **/
FOR EACH tt-erro-nfse
   WHERE tt-erro-nfse.l-situacao-imp
   BREAK BY tt-erro-nfse.c-arquivo:

    /** REGRA: Mensagens de acompanhamento/avisos **/
    IF  tt-erro-nfse.tipo-erro = "IM" THEN DO:

        RUN pi-gera-esp-ext-nota-fiscal-erro IN THIS-PROCEDURE.
    END.
    ELSE DO:

        /** REGRA: Erros de solicitacao de cancelamento **/
        IF  tt-erro-nfse.tipo-registro = "003" THEN DO:
        
            RUN pi-gera-esp-ext-nota-fiscal-erro IN THIS-PROCEDURE.

            RUN pi-gera-erro (INPUT 17006,
                              INPUT "Erro na Solicitaá∆o de Cancelamento (verifique no FT0904)",
                              INPUT tt-erro-nfse.cod-estabel,
                              INPUT tt-erro-nfse.serie,
                              INPUT tt-erro-nfse.nr-rps,
                              INPUT "",
                              INPUT tt-erro-nfse.c-arquivo).
        END.
        /** REGRA: Erros de conversao de RPS **/
        ELSE DO:
    
            RUN pi-gera-esp-ext-nota-fiscal-erro IN THIS-PROCEDURE.
    
            RUN pi-gera-erro (INPUT 17006,
                              INPUT "Erro na Convers∆o da RPS (verifique no FT0904)",
                              INPUT tt-erro-nfse.cod-estabel,
                              INPUT tt-erro-nfse.serie,
                              INPUT tt-erro-nfse.nr-rps,
                              INPUT "",
                              INPUT tt-erro-nfse.c-arquivo).
        END.
    END.

    /** REGRA: Renomear o arquivo importado para extensao .bkp **/
    IF  LAST-OF(tt-erro-nfse.c-arquivo) THEN DO:
        ASSIGN c-novo-arquivo   = REPLACE(tt-erro-nfse.c-dir-arq-completo,".txt",".bkp")
               i-arq-erro-import = i-arq-erro-import + 1.
        OS-RENAME VALUE(tt-erro-nfse.c-dir-arq-completo) VALUE(c-novo-arquivo).
    END.
END.

/** REGRA: Emitir mensagem para o usuario sobre importacao de mensagens de acompanhamento **/
IF CAN-FIND(FIRST tt-erro-nfse
            WHERE tt-erro-nfse.l-situacao-imp
              AND tt-erro-nfse.tipo-erro = "IM") THEN DO:

    RUN pi-gera-erro (INPUT 17006,
                      INPUT "Importaá∆o de mensagens de acompanhamento para a RPS (verifique no FT0904)",
                      INPUT "",
                      INPUT "",
                      INPUT "",
                      INPUT "",
                      INPUT tt-erro-nfse.c-arquivo).
END.

RUN pi-acompanhar IN h-acomp (INPUT "Impress∆o do Relat¢rio...").

/** REGRA: Listar os erros e sucessos do processamento **/
IF  NOT CAN-FIND(FIRST tt-erro) AND
    NOT CAN-FIND(FIRST tt-nfse) AND 
    NOT CAN-FIND(FIRST tt-erro-nfse) THEN DO:
    PUT UNFORMATTED "N∆o foram encontrados registros para importaá∆o." SKIP(1).
END.

FOR EACH tt-erro
      BY tt-erro.c-arquivo:

    IF  LINE-COUNTER > 60 THEN
        PAGE.

    DISP tt-erro.c-arquivo
         tt-erro.cod-estabel
         tt-erro.serie
         tt-erro.nr-nota-fis
         tt-erro.nr-nota-el
         tt-erro.cod-erro
         tt-erro.ajuda-erro AT 042
        WITH FRAME f-nfse WIDTH 132.
    DOWN WITH FRAME f-nfse.
END.


/** REGRA: Imprime quadro com resumo da importacao dos arquivos **/
PUT UNFORMATTED SKIP(2)
    "=================================="       SKIP
    "RESUMO DA IMPORTAÄ«O DE ARQUIVOS"   AT 02 SKIP(1)
    "Arquivos de RPS"                    AT 04 SKIP
    "- Lido.....:"                       AT 04
    i-arq-rps-lidos                            SKIP
    "- Importado:"                       AT 04 
    i-arq-rps-import                           SKIP(1)
    "Arquivos de ERRO"                   AT 04 SKIP
    "- Lido.....:"                       AT 04
    i-arq-erro-lidos                           SKIP
    "- Importado:"                       AT 04
    i-arq-erro-import                          SKIP
    "=================================="       SKIP.


/** REGRA: Finalizar o relatorio **/
RUN pi-finalizar IN h-acomp.
{include/i-rpclo.i}

IF  VALID-HANDLE(h-acomp) THEN
    DELETE PROCEDURE h-acomp.


/** ###################################### INICIO DAS PROCEDURES ###################################### **/

PROCEDURE pi-carrega-arquivos:
/*********************************************************************************************************
** REGRA: Verifica os arquivos disponiveis do diretorio
*********************************************************************************************************/

    DEF INPUT PARAM p-diretorio AS CHAR NO-UNDO.

    DEF VAR vc-arquivo          AS CHAR NO-UNDO.
    DEF VAR vc-dir-arq-completo AS CHAR NO-UNDO.
    DEF VAR vc-tipo             AS CHAR NO-UNDO.

    RUN pi-acompanhar IN h-acomp (INPUT "Carregando arquivos...").

    IF  p-diretorio = "" THEN
        RETURN "NOK".

    INPUT FROM OS-DIR(p-diretorio) NO-ECHO.
    REPEAT:

        IMPORT vc-arquivo
               vc-dir-arq-completo
               vc-tipo.

        IF  NOT CAN-FIND(FIRST tt-arquivos
                         WHERE tt-arquivos.c-dir-arq-completo = vc-dir-arq-completo) THEN DO:
            CREATE tt-arquivos.
            ASSIGN tt-arquivos.c-arquivo          = vc-arquivo
                   tt-arquivos.c-dir-arq-completo = vc-dir-arq-completo
                   tt-arquivos.c-tipo             = vc-tipo.
        END.
    END.

    /** REGRA: Diretorio padrao dos arquivos de "erro" do CW NFS-e */
    IF  tt-param.diretorio-imp = "" THEN DO:

        ASSIGN p-diretorio = p-diretorio + "ERROS~\".

        INPUT FROM OS-DIR(p-diretorio) NO-ECHO.
        REPEAT:
    
            IMPORT vc-arquivo
                   vc-dir-arq-completo
                   vc-tipo.
    
            IF  NOT CAN-FIND(FIRST tt-arquivos
                             WHERE tt-arquivos.c-dir-arq-completo = vc-dir-arq-completo) THEN DO:
                CREATE tt-arquivos.
                ASSIGN tt-arquivos.c-arquivo          = vc-arquivo
                       tt-arquivos.c-dir-arq-completo = vc-dir-arq-completo
                       tt-arquivos.c-tipo             = vc-tipo.
            END.
        END.
    END.

    RETURN "OK".
END PROCEDURE.


PROCEDURE pi-gera-erro:
/*********************************************************************************************************
** REGRA: Insere erro para reportar no relatorio
*********************************************************************************************************/

    DEF INPUT PARAMETER i-msg         AS INT   NO-UNDO.
    DEF INPUT PARAMETER c-texto       AS CHAR  NO-UNDO.
    DEF INPUT PARAMETER p-estabel     AS CHAR  NO-UNDO.
    DEF INPUT PARAMETER p-serie       AS CHAR  NO-UNDO.
    DEF INPUT PARAMETER p-nr-nota-fis AS CHAR  NO-UNDO.
    DEF INPUT PARAMETER p-nr-nota-el  AS CHAR  NO-UNDO.
    DEF INPUT PARAMETER p-arquivo     AS CHAR  NO-UNDO.

    RUN utp/ut-msgs.p (INPUT "msg",
                       INPUT i-msg,
                       INPUT c-texto).
    CREATE tt-erro.
    ASSIGN tt-erro.ajuda-erro  = RETURN-VALUE
           tt-erro.cod-erro    = i-msg
           tt-erro.desc-erro   = c-texto
           tt-erro.cod-estabel = p-estabel
           tt-erro.serie       = p-serie
           tt-erro.nr-nota-fis = p-nr-nota-fis
           tt-erro.nr-nota-el  = p-nr-nota-el
           tt-erro.c-arquivo   = p-arquivo.

    RETURN "OK".
END.


PROCEDURE pi-gera-esp-ext-nota-fiscal-erro:
/*********************************************************************************************************
** REGRA: Insere erro na tabela especifica da nota fiscal
*********************************************************************************************************/

    DEF VAR i-seq-esp AS INT INITIAL 1 NO-UNDO.


    FOR LAST esp-ext-nota-fiscal-erro NO-LOCK
       WHERE esp-ext-nota-fiscal-erro.cod-estabel = tt-erro-nfse.cod-estabel
         AND esp-ext-nota-fiscal-erro.serie       = tt-erro-nfse.serie
         AND esp-ext-nota-fiscal-erro.nr-nota-fis = STRING(INT(tt-erro-nfse.nr-rps),"9999999"):

        ASSIGN i-seq-esp = esp-ext-nota-fiscal-erro.sequencia + 1.
    END.

    CREATE esp-ext-nota-fiscal-erro.
    ASSIGN esp-ext-nota-fiscal-erro.cod-estabel     = tt-erro-nfse.cod-estabel
           esp-ext-nota-fiscal-erro.serie           = tt-erro-nfse.serie
           esp-ext-nota-fiscal-erro.nr-nota-fis     = STRING(INT(tt-erro-nfse.nr-rps),"9999999")
           esp-ext-nota-fiscal-erro.sequencia       = i-seq-esp
           esp-ext-nota-fiscal-erro.nr-lote         = tt-erro-nfse.nr-lote
           esp-ext-nota-fiscal-erro.tipo-erro       = tt-erro-nfse.tipo-erro
           esp-ext-nota-fiscal-erro.cod-erro        = tt-erro-nfse.cod-erro
           esp-ext-nota-fiscal-erro.des-erro        = tt-erro-nfse.des-erro
           esp-ext-nota-fiscal-erro.des-correcao    = tt-erro-nfse.des-correcao
           esp-ext-nota-fiscal-erro.tipo-registro   = tt-erro-nfse.tipo-registro
           esp-ext-nota-fiscal-erro.linha-registro  = tt-erro-nfse.linha-registro
           esp-ext-nota-fiscal-erro.nome-arquivo    = tt-erro-nfse.nome-arquivo
           esp-ext-nota-fiscal-erro.data-importacao = tt-erro-nfse.dt-importacao
           esp-ext-nota-fiscal-erro.hora-importacao = tt-erro-nfse.hr-importacao
           esp-ext-nota-fiscal-erro.usuario-log     = c-seg-usuario
           esp-ext-nota-fiscal-erro.data-log        = TODAY
           esp-ext-nota-fiscal-erro.hora-log        = STRING(TIME,"HH:MM:SS").

    RETURN "OK".
END PROCEDURE.
