/******************************************************************************
** Programa: 
** Data....: 
** Autor...: 
** Objetivo: 
*******************************************************************************/
{include/i-prgvrs.i "ESFTP072" 2.00.00.001} 

/*-------------------------- Definiá∆o temp-table ----------------------------*/
    {utp/utapi019.i}
    {esapi/esapi010tt.i}
    {cdp/cd0666.i}
   
def temp-table tt-raw-digita
    field raw-digita as raw.
      
/*----------------------- Recebimento de parametros --------------------------*/
def input parameter raw-param as raw no-undo. 
def input parameter table for tt-raw-digita.   
DEFINE VARIABLE c-cod-estabelecimento   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-primeira-sequencia    AS DEC         NO-UNDO.
DEFINE VARIABLE i-proxima-sequencia     AS DEC         NO-UNDO.
DEFINE VARIABLE i-ultima-sequencia      AS DEC         NO-UNDO.
DEFINE VARIABLE c-nro-contrato          AS CHAR        NO-UNDO.
DEFINE VARIABLE i-cod-administrativo    AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-pasta-arquivo         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-tipo-servico-correios AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-unid-postagem         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-unid-postagem    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cep-unid-postagem     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-impressora-zebra      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE vArqMail                AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-email-correio         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-cod-servico           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-sequencia-aviso       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-arq-xml               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-prefixo-codigo        AS CHARACTER   NO-UNDO.

define variable hDoc             as handle no-undo.
define variable hRoot            as handle no-undo.
define variable hAux1            as handle no-undo.
define variable hAux2            as handle no-undo.
define variable hAux3            as handle no-undo.
define variable hAux4            as handle no-undo.
define variable xmlParam         as handle no-undo.
define variable xmlText          as handle no-undo.

DEFINE VARIABLE h-cdapi704       AS HANDLE    NO-UNDO.
DEFINE VARIABLE cMensagem        AS CHARACTER NO-UNDO.

DEFINE VARIABLE l-primeiro AS LOGICAL     NO-UNDO.

DEF BUFFER b-nota-fiscal FOR nota-fiscal.

DEFINE VARIABLE i-ultimo-vol AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-endereco   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-rua        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nro        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-comp       AS CHARACTER   NO-UNDO.

DEF STREAM s-arq-email.

DEF BUFFER b-volume-nf FOR volume-nf.


DEFINE TEMP-TABLE tt-volume-nf  LIKE volume-nf.

define temp-table tt-param no-undo
    field destino               as integer
    field arquivo               as char format "x(35)"
    field usuario               as char format "x(12)"
    field data-exec             as date
    field hora-exec             as integer
    field codEstabel            as char
    field cSerie                as char
    field cNrNotaFis-ini        as char
    field cNrNotaFis-fim        as CHAR
    FIELD da-dt-emissao-ini     AS DATE
    FIELD da-dt-emissao-fim     AS DATE
    FIELD da-dt-saida-ini       AS DATE
    FIELD da-dt-saida-fim       AS DATE
    FIELD regera-xml            AS LOGICAL
    FIELD atualiza-dt-saida     AS LOGICAL
    FIELD l-somente-imprime-rel AS LOGICAL
    FIELD c-cartao              AS CHARACTER.

DEFINE TEMP-TABLE tt-dados NO-UNDO
    FIELD nro-contrato        AS CHARACTER
    FIELD cod-administrativo  AS INTEGER
    FIELD nome-rem            LIKE estabelec.nome
    FIELD rua-rem             AS CHARACTER
    FIELD numero-rem          AS CHARACTER
    FIELD comp-rem            AS CHARACTER
    FIELD bairro-rem          LIKE estabelec.bairro
    FIELD cep-rem             LIKE estabelec.cep   
    FIELD cidade-rem          LIKE estabelec.cidade
    FIELD estado-rem          LIKE estabelec.estado
    FIELD nro-etiqueta        LIKE int-nota-conhec.nr-conhec
    FIELD peso                AS DECIMAL
    FIELD cgc-dest            LIKE emitente.cgc
    FIELD nome-dest           LIKE emitente.nome-emit
    FIELD tel-dest            LIKE emitente.telefone[1]
    FIELD cel-dest            LIKE emitente.telefone[2]
    FIELD email-dest          LIKE emitente.e-mail
    FIELD rua-dest            AS CHARACTER
    FIELD comp-dest           AS CHARACTER
    FIELD nro-dest            AS CHARACTER
    FIELD bairro-dest         LIKE nota-fiscal.bairro
    FIELD cidade-dest         LIKE nota-fiscal.cidade
    FIELD estado-dest         LIKE nota-fiscal.estado
    FIELD cep-dest            LIKE nota-fiscal.cep
    FIELD nr-nota-fis         LIKE nota-fiscal.nr-nota-fis
    FIELD serie               LIKE nota-fiscal.serie
    FIELD vl-tot-nota         LIKE nota-fiscal.vl-tot-nota
    FIELD altura              LIKE int-nota-conhec.altura
    FIELD largura             LIKE int-nota-conhec.largura
    FIELD comprimento         LIKE int-nota-conhec.comprimento
    FIELD nro-cartao          LIKE int-nota-conhec.nr-cartao
    FIELD centro-custo        LIKE int-nota-conhec.centro-custo-frete
    FIELD nr-volume           LIKE int-nota-conhec.nr-volume
    INDEX idx-quebra          
            nro-cartao.


FORM nota-fiscal.cep
     int-nota-conhec.nr-conhec FORMAT "x(13)" COLUMN-LABEL "N.Objeto"
     nota-fiscal.nr-nota-fis
     emitente.nome-emit COLUMN-LABEL "Destinatario" 
WITH FRAME f-detalhe WIDTH 132 64 DOWN STREAM-IO.

create tt-param.
raw-transfer raw-param to tt-param.    
   
/*-------------- include padrío para vari†veis de relatΩrio ------------------*/
{include/i-rpvar.i}

{include/tt-edit.i}
{include/i-freeac.i} /* Retira os acentos */

def var h-acomp         as handle no-undo. 

/*-------------------------- Definicao de variaveis --------------------------*/
{utp/ut-glob.i}

/*--------- include com a definiá∆o da frame de cabeáalho e rodapÇ -----------*/
{include/i-rpcab.i} 
    FIND FIRST estabelec
         WHERE estabelec.cod-estabel = tt-param.codestabel NO-LOCK NO-ERROR.

    form header
         "Totalizador:                                                                          Carimbo e assinatura / Matricula dos Correios" SKIP(2)
        "APRESENTAR ESTA LISTA EM CASO DE PEDIDO DE INFORMACOES" SKIP(2)
        "Cartao de Postagem: " tt-param.c-cartao SKIP
        "Remetente: " estabelec.nome SKIP
        "Endereco : " estabelec.endereco SKIP
        "Bairro   : " estabelec.bairro   SKIP
        "Cidade   : " estabelec.cidade " CEP: " estabelec.cep SKIP(2)
        "Estou ciente do disposto na clausula terceira do contrato de prestacao de servicos" SKIP
        "" SKIP
        "" SKIP
        "_________________________________________________________________________________________" SKIP
        "                                   ASSINATURA DO REMETENTE" SKIP(2)
        "Obs. 1) via balancete, 2. Cliente, 3. via arquivo na unidade" SKIP
        with stream-io width 132 no-labels no-box page-bottom frame f-rodape-2.


/*---------------- include padrío para output de relatΩrios ------------------*/
{include/i-rpout.i}

/*------------------- bloco principal do programa ----------------------------*/
FIND FIRST tt-param NO-LOCK NO-ERROR.

ASSIGN c-empresa      = "INTELBRAS"
       c-programa     = "ESFTP072"
       c-titulo-relat = "Listagem de Postagem"
       c-sistema      = "Faturamento"
       c-versao       = "2.04"
       c-revisao      = "00.001".

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Processando...").

VIEW FRAME f-cabec.   
VIEW FRAME f-rodape.
VIEW FRAME f-rodape-2.

RUN pi-acompanhar IN h-acomp ("Carregando...").

FIND FIRST param-correios
    WHERE param-correios.cod-estabel = tt-param.codEstabel
      AND param-correios.tp-servico  = "PAC":U NO-LOCK NO-ERROR.

RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.

IF AVAILABLE param-correios THEN
    RUN PI-Leitura-Notas.

FIND FIRST param-correios
    WHERE param-correios.cod-estabel = tt-param.codEstabel
      AND param-correios.tp-servico  = "SEDEX":U NO-LOCK NO-ERROR.

IF AVAILABLE param-correios THEN
    RUN PI-Leitura-Notas.

FIND FIRST param-correios
    WHERE param-correios.cod-estabel = tt-param.codEstabel
      AND param-correios.tp-servico  = "E-SEDEX":U NO-LOCK NO-ERROR.

IF AVAILABLE param-correios THEN
    RUN PI-Leitura-Notas.

DELETE PROCEDURE h-cdapi704.

/*------------------------ fechamento do output do relat´rio -----------------------*/ 
{include/i-rpclo.i}

RUN pi-finalizar in h-acomp.

RETURN "OK":U.

PROCEDURE PI-Leitura-Notas:

    EMPTY TEMP-TABLE tt-dados.

    PUT UNFORMATTED "-- " param-correios.tp-servico SKIP.

    ASSIGN c-cod-estabelecimento   = param-correios.cod-estabel
           c-tipo-servico-correios = param-correios.tp-servico
           i-primeira-sequencia    = param-correios.seq-inicial
           i-proxima-sequencia     = param-correios.seq-proxima
           i-ultima-sequencia      = param-correios.seq-final
           c-nro-contrato          = param-correios.nr-contrato
           i-cod-administrativo    = param-correios.cod-admin
           c-pasta-arquivo         = param-correios.dir-grav-xml
           c-unid-postagem         = param-correios.cod-un-postagem
           c-desc-unid-postagem    = param-correios.des-un-postagem
           c-cep-unid-postagem     = param-correios.cep-un-postagem
           c-impressora-zebra      = param-correios.imp-etiqueta
           c-email-correio         = param-correios.e-mail-env-xml
           i-sequencia-aviso       = param-correios.seq-aviso
           c-prefixo-codigo        = param-correios.prefix-tp-servico
           v-cod-servico           = "40568".

    IF  NUM-ENTRIES(param-correios.char-1,";") > 2
    THEN DO:
        IF  param-correios.tp-servico = "SEDEX" 
        THEN
            ASSIGN v-cod-servico = ENTRY(1,param-correios.char-1,";").
        ELSE
            IF  param-correios.tp-servico = "E-SEDEX" 
            THEN
                ASSIGN v-cod-servico = ENTRY(2,param-correios.char-1,";").
            ELSE
                IF  param-correios.tp-servico = "PAC" 
                THEN
                    ASSIGN v-cod-servico = ENTRY(3,param-correios.char-1,";").
    END.

    PUT "Empresa Brasileira de Correios e Telegrafos" SKIP
        "Unidade de Postagem: " c-unid-postagem " - " c-desc-unid-postagem " CEP: " c-cep-unid-postagem  SKIP
        "Data Postagem      : " TODAY 
        " Codigo Administrativo: " AT 73 
        i-cod-administrativo FORMAT ">>>>,>>>,>>9"
        " Contrato: " c-nro-contrato FORMAT "x(12)" SKIP
        "Cliente            : " estabelec.nome SKIP
        "" SKIP.                              

    FOR EACH  nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel   = tt-param.codestabel
          AND nota-fiscal.serie         = tt-param.cSerie
          AND nota-fiscal.nr-nota-fis  >= tt-param.cNrNotaFis-ini
          AND nota-fiscal.nr-nota-fis  <= tt-param.cNrNotaFis-fim
          AND nota-fiscal.dt-emis-nota >= tt-param.da-dt-emissao-ini
          AND nota-fiscal.dt-emis-nota <= tt-param.da-dt-emissao-fim
          AND nota-fiscal.nome-transp   = c-tipo-servico-correios
          AND nota-fiscal.dt-cancela    = ?
        BREAK BY nota-fiscal.nr-nota-fis:

        FOR EACH tt-volume-nf:
            DELETE tt-volume-nf.
        END.

        IF CAN-FIND(FIRST volume-nf
                          WHERE volume-nf.cod-estabel     = nota-fiscal.cod-estabel
                            AND volume-nf.serie           = nota-fiscal.serie
                            AND volume-nf.nr-nota-fis     = nota-fiscal.nr-nota-fis) THEN DO:
            FOR EACH volume-nf NO-LOCK
                WHERE volume-nf.cod-estabel     = nota-fiscal.cod-estabel
                  AND volume-nf.serie           = nota-fiscal.serie
                  AND volume-nf.nr-nota-fis     = nota-fiscal.nr-nota-fis:
                CREATE tt-volume-nf.
                BUFFER-COPY volume-nf TO tt-volume-nf.
                RELEASE tt-volume-nf.
            END.
        END.
        ELSE DO:
            CREATE tt-volume-nf.
            ASSIGN tt-volume-nf.cod-estabel     = nota-fiscal.cod-estabel 
                   tt-volume-nf.serie           = nota-fiscal.serie       
                   tt-volume-nf.nr-nota-fis     = nota-fiscal.nr-nota-fis
                   tt-volume-nf.nr-volume       = 1.
            RELEASE tt-volume-nf.
        END.
        FOR EACH tt-volume-nf NO-LOCK
            WHERE tt-volume-nf.cod-estabel     = nota-fiscal.cod-estabel
              AND tt-volume-nf.serie           = nota-fiscal.serie
              AND tt-volume-nf.nr-nota-fis     = nota-fiscal.nr-nota-fis
            BREAK BY tt-volume-nf.nr-volume:

            IF FIRST-OF(tt-volume-nf.nr-volume) THEN DO:
                FIND LAST b-volume-nf USE-INDEX volume-nf
                    WHERE b-volume-nf.cod-estabel     = nota-fiscal.cod-estabel
                      AND b-volume-nf.serie           = nota-fiscal.serie
                      AND b-volume-nf.nr-nota-fis     = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
                IF AVAIL b-volume-nf THEN
                    ASSIGN i-ultimo-vol = b-volume-nf.nr-volume.
                ELSE
                    ASSIGN i-ultimo-vol = 1.
    
                FIND FIRST int-nota-conhec
                     WHERE int-nota-conhec.cod-estabel = nota-fiscal.cod-estabel    
                       AND int-nota-conhec.serie       = nota-fiscal.serie          
                       AND int-nota-conhec.nr-nota-fis = nota-fiscal.nr-nota-fis
                       AND int-nota-conhec.nr-volume   = tt-volume-nf.nr-volume NO-LOCK NO-ERROR.
    
                IF NOT AVAIL int-nota-conhec THEN
                    FIND FIRST int-nota-conhec
                         WHERE int-nota-conhec.cod-estabel = nota-fiscal.cod-estabel    
                           AND int-nota-conhec.serie       = nota-fiscal.serie          
                           AND int-nota-conhec.nr-nota-fis = nota-fiscal.nr-nota-fis
                           AND int-nota-conhec.nr-volume   = 0 NO-LOCK NO-ERROR.
    
                IF tt-param.atualiza-dt-saida THEN DO:
                    FIND FIRST b-nota-fiscal
                        WHERE ROWID(b-nota-fiscal) = ROWID(nota-fiscal) EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAIL b-nota-fiscal THEN DO:
                        ASSIGN b-nota-fiscal.dt-saida = TODAY.
                    END.
                END.

                IF  AVAIL int-nota-conhec                  AND
                          int-nota-conhec.nr-cartao  <> "" AND
                          int-nota-conhec.peso-bruto <> 0  THEN DO:
                   IF tt-param.c-cartao = "" OR tt-param.c-cartao = int-nota-conhec.nr-cartao THEN DO:
    
                       RUN pi-acompanhar IN h-acomp (INPUT 'Gerando Integraá∆o com Correios ' + nota-fiscal.nr-nota-fis).
    
                       FIND FIRST emitente
                            WHERE emitente.cod-emitente = nota-fiscal.cod-emitente
                            NO-LOCK NO-ERROR.
                       IF tt-param.l-somente-imprime-rel THEN DO:
                           IF nota-fiscal.dt-saida >= tt-param.da-dt-saida-ini  AND
                              nota-fiscal.dt-saida <= tt-param.da-dt-saida-fim  THEN DO:
                               RUN pi-imprime-rel.
                           END.
                       END.
                       ELSE DO:
                           IF int-nota-conhec.xml-enviado THEN DO:
                              IF tt-param.regera-xml  THEN DO:
                                  RUN pi-gera-tt.
                                  RUN pi-imprime-rel.
                              END.
                           END.
                           ELSE DO:
                               IF NOT tt-param.regera-xml 
                               THEN DO:    
                                  IF nota-fiscal.dt-saida >= tt-param.da-dt-saida-ini  AND
                                     nota-fiscal.dt-saida <= tt-param.da-dt-saida-fim  
                                  THEN DO:
                                       RUN pi-gera-tt.
                                       FIND current int-nota-conhec EXCLUSIVE-LOCK NO-ERROR.
                                       ASSIGN int-nota-conhec.xml-enviado = YES.
                                       FIND CURRENT int-nota-conhec NO-LOCK NO-ERROR.
                                       IF LAST-OF(nota-fiscal.nr-nota-fis) AND
                                                  emitente.e-mail <> ""
                                       THEN
                                          RUN pi-envia-email.
                                       RUN pi-imprime-rel.
                                  END.
                               END.
                           END.
                       END.
                   END.
                END.
            END.
        END.
    END.

    FOR EACH tt-dados NO-LOCK
        BREAK BY tt-dados.nro-cartao:

        IF  FIRST-OF(tt-dados.nro-cartao) 
        THEN
            ASSIGN l-primeiro = YES.

        RUN pi-acompanhar IN h-acomp (INPUT 'Gerando XML para serviáo ' + CAPS(c-tipo-servico-correios) + ' Cart∆o: ' + STRING(tt-dados.nro-cartao)).

        RUN pi-gera-xml.

        IF  LAST-OF(tt-dados.nro-cartao)
        THEN DO:
            ASSIGN c-arq-xml = TRIM(c-pasta-arquivo) + "Postagem_" + REPLACE(STRING(TODAY),"/","") + "_" + REPLACE(STRING(TIME,"HH:MM:SS"),":","") + ".xml".

            hDoc:SAVE("file", c-arq-xml).


            IF  SEARCH(c-arq-xml) <> ? THEN
                RUN pi-envia-email-xml.

            DELETE OBJECT xmlText.
            DELETE OBJECT xmlParam.
            DELETE OBJECT hAux4.
            DELETE OBJECT hAux3.
            DELETE OBJECT hAux2.
            DELETE OBJECT hAux1.
            DELETE OBJECT hRoot.
        END.
    END.

END PROCEDURE.


PROCEDURE pi-gera-xml:

    IF  l-primeiro = YES 
    THEN DO:
        ASSIGN l-primeiro = NO.
        create x-document hDoc.
        create x-noderef hRoot.
        create x-noderef hAux1.
        create x-noderef hAux2.
        create x-noderef hAux3.
        CREATE X-NODEREF hAux4.
        create x-noderef xmlParam.
        create x-noderef xmlText.
        
        hDoc:create-node(hRoot, "correioslog", "ELEMENT").
        hDoc:append-child(hRoot).
        
        hDoc:create-node(xmlParam, "tipo", "ELEMENT").
        hDoc:create-node(xmlText, ?, "TEXT").
        xmlText:node-value = "INTERLOGIS NACIONAL".
        xmlParam:append-child(xmlText).
        hRoot:append-child(xmlParam).
        

        /** TAG - Contrato **/
        hDoc:create-node(hAux1, "contrato", "ELEMENT").

        hDoc:create-node(xmlParam, "nrocontrato", "ELEMENT").
        hDoc:create-node(xmlText, ?, "TEXT").
        xmlText:node-value = tt-dados.nro-contrato.
        xmlParam:append-child(xmlText).
        hAux1:append-child(xmlParam).

        hDoc:create-node(xmlParam, "cartao_postagem", "ELEMENT").
        hDoc:create-node(xmlText, ?, "TEXT").
        xmlText:node-value = tt-dados.nro-cartao.
        xmlParam:append-child(xmlText).
        hAux1:append-child(xmlParam).

        hRoot:append-child(hAux1).


        /** TAG - Serviáo **/
        hDoc:create-node(hAux1, "servico", "ELEMENT").

        hDoc:create-node(xmlParam, "codigo", "ELEMENT").
        hDoc:create-node(xmlText, ?, "TEXT").
        xmlText:node-value = v-cod-servico.
        xmlParam:append-child(xmlText).
        hAux1:append-child(xmlParam).
    END.


    /** TAG - Destinatario **/
    hDoc:create-node(hAux2, "destinatario", "ELEMENT").

    hDoc:create-node(xmlParam, "cnpjcpf", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = tt-dados.cgc-dest.
    xmlParam:append-child(xmlText).
    hAux2:append-child(xmlParam).

    hDoc:create-node(xmlParam, "nome", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = tt-dados.nome-dest.
    xmlParam:append-child(xmlText).
    hAux2:append-child(xmlParam).

    hDoc:create-node(xmlParam, "email", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = tt-dados.email-dest.
    xmlParam:append-child(xmlText).
    hAux2:append-child(xmlParam).

    hDoc:create-node(xmlParam, "ac", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = "".
    xmlParam:append-child(xmlText).
    hAux2:append-child(xmlParam).

    hDoc:create-node(xmlParam, "contato", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = "".
    xmlParam:append-child(xmlText).
    hAux2:append-child(xmlParam).

    hDoc:create-node(xmlParam, "cep", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = tt-dados.cep-dest.
    xmlParam:append-child(xmlText).
    hAux2:append-child(xmlParam).

    hDoc:create-node(xmlParam, "logradouro", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = tt-dados.rua-dest.
    xmlParam:append-child(xmlText).
    hAux2:append-child(xmlParam).

    hDoc:create-node(xmlParam, "numero", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = tt-dados.nro-dest.
    xmlParam:append-child(xmlText).
    hAux2:append-child(xmlParam).

    hDoc:create-node(xmlParam, "complemento", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = tt-dados.comp-dest.
    xmlParam:append-child(xmlText).
    hAux2:append-child(xmlParam).

    hDoc:create-node(xmlParam, "bairro", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = tt-dados.bairro-dest.
    xmlParam:append-child(xmlText).
    hAux2:append-child(xmlParam).

    hDoc:create-node(xmlParam, "cidade", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = tt-dados.cidade-dest.
    xmlParam:append-child(xmlText).
    hAux2:append-child(xmlParam).

    hDoc:create-node(xmlParam, "tel", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = tt-dados.tel-dest.
    xmlParam:append-child(xmlText).
    hAux2:append-child(xmlParam).

    hDoc:create-node(xmlParam, "celular", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = tt-dados.cel-dest.
    xmlParam:append-child(xmlText).
    hAux2:append-child(xmlParam).

    hDoc:create-node(xmlParam, "fax", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = "".
    xmlParam:append-child(xmlText).
    hAux2:append-child(xmlParam).
    
    hAux1:append-child(hAux2).


    /** TAG - Definiá∆o **/
    hDoc:create-node(hAux3, "definicao", "ELEMENT").

    hDoc:create-node(xmlParam, "volume", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = STRING(tt-dados.nr-volume,">9").
    xmlParam:append-child(xmlText).
    hAux3:append-child(xmlParam).

    hDoc:create-node(xmlParam, "valorcobrar", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = string(0).
    xmlParam:append-child(xmlText).
    hAux3:append-child(xmlParam).

    hDoc:create-node(xmlParam, "especificacao", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = "".
    xmlParam:append-child(xmlText).
    hAux3:append-child(xmlParam).

    hAux2:append-child(hAux3).


    /** TAG - Etiqueta **/
    hDoc:create-node(hAux4, "etiqueta", "ELEMENT").

    hDoc:create-node(xmlParam, "etq", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = tt-dados.nro-etiqueta.
    xmlParam:append-child(xmlText).
    hAux4:append-child(xmlParam).

    hDoc:create-node(xmlParam, "medida", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = STRING(tt-dados.peso,">>>>9").
    xmlParam:append-child(xmlText).
    hAux4:append-child(xmlParam).

    hDoc:create-node(xmlParam, "comprimento", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = STRING(tt-dados.comprimento).
    xmlParam:append-child(xmlText).
    hAux4:append-child(xmlParam).

    hDoc:create-node(xmlParam, "largura", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = STRING(tt-dados.largura).
    xmlParam:append-child(xmlText).
    hAux4:append-child(xmlParam).

    hDoc:create-node(xmlParam, "altura", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = STRING(tt-dados.altura).
    xmlParam:append-child(xmlText).
    hAux4:append-child(xmlParam).

    hAux3:append-child(hAux4).


    /** TAG - Serviáo Adicional **/
    hDoc:create-node(hAux3, "servicoadicional", "ELEMENT").

    hDoc:create-node(xmlParam, "id", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = "".
    xmlParam:append-child(xmlText).
    hAux3:append-child(xmlParam).

    hDoc:create-node(xmlParam, "data", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = "".
    xmlParam:append-child(xmlText).
    hAux3:append-child(xmlParam).

    hDoc:create-node(xmlParam, "valor", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = "".
    xmlParam:append-child(xmlText).
    hAux3:append-child(xmlParam).

    hAux2:append-child(hAux3).


    /** TAG - Nota Fiscal **/
    hDoc:create-node(hAux3, "notafiscal", "ELEMENT").

    hDoc:create-node(xmlParam, "nrofornecimento", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = "".
    xmlParam:append-child(xmlText).
    hAux3:append-child(xmlParam).

    hDoc:create-node(xmlParam, "nronotafiscal", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = tt-dados.nr-nota-fis.
    xmlParam:append-child(xmlText).
    hAux3:append-child(xmlParam).

    hDoc:create-node(xmlParam, "serienotafiscal", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = tt-dados.serie.
    xmlParam:append-child(xmlText).
    hAux3:append-child(xmlParam).

    hDoc:create-node(xmlParam, "valornotafiscal", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = string(tt-dados.vl-tot-nota, ">>>>>>>>>9.99").
    xmlParam:append-child(xmlText).
    hAux3:append-child(xmlParam).

    hDoc:create-node(xmlParam, "naturezaoperacao", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = "".
    xmlParam:append-child(xmlText).
    hAux3:append-child(xmlParam).

    hAux2:append-child(hAux3).


    /** TAG - Unidade Pagadora **/
    hDoc:create-node(hAux3, "unidadepagadora", "ELEMENT").

    hDoc:create-node(xmlParam, "nrounidadepagadora", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = "".
    xmlParam:append-child(xmlText).
    hAux3:append-child(xmlParam).

    hDoc:create-node(xmlParam, "nrobanco", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = "".
    xmlParam:append-child(xmlText).
    hAux3:append-child(xmlParam).

    hDoc:create-node(xmlParam, "nroagencia", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = "".
    xmlParam:append-child(xmlText).
    hAux3:append-child(xmlParam).

    hDoc:create-node(xmlParam, "nrocontacorrente", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = "".
    xmlParam:append-child(xmlText).
    hAux3:append-child(xmlParam).

    hAux2:append-child(hAux3).


    /** TAG - Item **/
    hDoc:create-node(hAux3, "item", "ELEMENT").

    hDoc:create-node(xmlParam, "item", "ELEMENT").
    hDoc:create-node(xmlText, ?, "TEXT").
    xmlText:node-value = "".
    xmlParam:append-child(xmlText).
    hAux3:append-child(xmlParam).

    hAux2:append-child(hAux3).

    hRoot:append-child(hAux1).

END PROCEDURE.

PROCEDURE pi-envia-email:
    DEFINE VARIABLE c-nr-pedido AS CHARACTER   NO-UNDO.

    ASSIGN cMensagem = "Confirmaá∆o de Emiss∆o de Nota Fiscal"                                               + CHR(10) + CHR(10) + 
                   "Foi emitida a nota fiscal de numero "                                                    + STRING(nota-fiscal.nr-nota-fis) + 
                   ", referente o pedido numero " + nota-fiscal.nr-pedcli  + "."                             + CHR(10) + CHR(10) + 
                   "A mesma enviada por " + CAPS(nota-fiscal.nome-transp) + " Nro: " + int-nota-conhec.nr-conhec + CHR(10) + CHR(10) + 
                   "     Para acompanhar a entrega acesse o site do correios atravÇs do link: "              + CHR(10) + CHR(10) + 
                   "     http://websro.correios.com.br/sro_bin/txect01$.QueryList?P_LINGUA=001&P_TIPO=001&P_COD_UNI=" + trim(int-nota-conhec.nr-conhec) + CHR(10) + CHR(10) + 
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

    OUTPUT STREAM s-arq-email TO VALUE(vArqMail).
    PUT STREAM s-arq-email cMensagem FORMAT 'x(2000)'.
    OUTPUT STREAM s-arq-email CLOSE.

    CREATE tt-mail.
    ASSIGN tt-mail.Destinatario  = trim(emitente.e-mail)
           tt-mail.Assunto       = "Emissao Nota Fiscal Venda"
           tt-mail.Mensagem      = cMensagem
           tt-mail.Arquivo       = vArqMail.
    
    FOR FIRST usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = c-seg-usuario:
        ASSIGN tt-mail.Remetente = usuar_mestre.cod_e_mail_local.
    END.
    IF tt-mail.Remetente = "" THEN
        ASSIGN tt-mail.Remetente = "ems@intelbras.com.br".
    
    RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                          OUTPUT TABLE tt-erro).

    FOR EACH tt-mail:
        DELETE tt-mail.
    END.

END PROCEDURE.

PROCEDURE pi-imprime-rel:

    DISP nota-fiscal.cep
         int-nota-conhec.nr-conhec COLUMN-LABEL "N.Objeto"
         nota-fiscal.nr-nota-fis
         STRING(tt-volume-nf.nr-volume,"99999") + "/" + STRING(i-ultimo-vol,"99999") FORMAT "x(11)" COLUMN-LABEL "Volumes"
         emitente.nome-emit COLUMN-LABEL "Destinatario" 
        WITH FRAME f-detalhe.
    DOWN WITH FRAME f-detalhe.

END PROCEDURE.

PROCEDURE pi-envia-email-xml:

    CREATE tt-mail.
    ASSIGN tt-mail.Destinatario  = c-email-correio  /* ES0018 - 'esftp071 - 1'*/
           tt-mail.Assunto       = "Postagem Correios"
           tt-mail.Mensagem      = "Em anexo XML referente Faturamento Intelbras de " + STRING(TODAY,"99/99/9999")
           tt-mail.Arquivo       = c-arq-xml.

    FOR FIRST usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = c-seg-usuario:
        ASSIGN tt-mail.Remetente = usuar_mestre.cod_e_mail_local.
    END.

    IF tt-mail.Remetente = "" THEN
        ASSIGN tt-mail.Remetente = "ems@intelbras.com.br".

    RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                          OUTPUT TABLE tt-erro).
    FOR EACH tt-mail:
        DELETE tt-mail.
    END.
END PROCEDURE.


PROCEDURE pi-gera-tt:

    /* Destinat†rio */
    ASSIGN c-endereco = estabelec.endereco
           c-rua      = ""
           c-nro      = ""
           c-comp     = "".

    IF  INDEX(c-endereco,CHR(ASC("ß"))) > 0 THEN /* Retirar caracter especial */
        ASSIGN c-endereco = REPLACE(c-endereco,CHR(ASC("ß")),"").

    RUN pi-trata-endereco IN h-cdapi704 (INPUT  c-endereco,
                                         OUTPUT c-rua, 
                                         OUTPUT c-nro, 
                                         OUTPUT c-comp).
    ASSIGN c-nro = fn-free-accent(c-nro).

    CREATE tt-dados.
    ASSIGN tt-dados.nro-cartao   = int-nota-conhec.nr-cartao
           tt-dados.centro-custo = int-nota-conhec.centro-custo-frete
           tt-dados.nr-volume    = int-nota-conhec.nr-volume
           tt-dados.nro-contrato = c-nro-contrato
           tt-dados.cod-adm      = i-cod-administrativo
           tt-dados.nome-rem     = estabelec.nome
           tt-dados.rua-rem      = c-rua
           tt-dados.numero-rem   = c-nro
           tt-dados.comp-rem     = c-comp
           tt-dados.bairro-rem   = estabelec.bairro
           tt-dados.cep-rem      = estabelec.cep
           tt-dados.cidade-rem   = estabelec.cidade
           tt-dados.estado-rem   = estabelec.estado
           tt-dados.nro-etiqueta = int-nota-conhec.nr-conhec
           tt-dados.peso         = int-nota-conhec.peso-bruto * 1000.


    /* Remetente */
    FIND FIRST int-loc-entr NO-LOCK
        WHERE  int-loc-entr.nome-abrev = nota-fiscal.nome-ab-cli
        AND    int-loc-entr.cod-entrega = nota-fiscal.cod-entrega NO-ERROR.
    IF  AVAIL int-loc-entr AND
        int-loc-entr.endereco-completo <> "" THEN
        ASSIGN c-endereco = int-loc-entr.endereco-completo.
    ELSE
        ASSIGN c-endereco = IF nota-fiscal.endereco <> "" THEN nota-fiscal.endereco ELSE emitente.endereco.

    ASSIGN c-rua      = ""
           c-nro      = ""
           c-comp     = "".
    IF  INDEX(c-endereco,CHR(ASC("ß"))) > 0 THEN /* Retirar caracter especial */
        ASSIGN c-endereco = REPLACE(c-endereco,CHR(ASC("ß")),"").

    RUN pi-trata-endereco IN h-cdapi704 (INPUT  c-endereco,
                                         OUTPUT c-rua, 
                                         OUTPUT c-nro, 
                                         OUTPUT c-comp).
    ASSIGN c-nro = fn-free-accent(c-nro).


    ASSIGN tt-dados.cgc-dest    = emitente.cgc
           tt-dados.nome-dest   = emitente.nome-emit
           tt-dados.tel-dest    = emitente.telefone[1]
           tt-dados.cel-dest    = emitente.telefone[2]
           tt-dados.email-dest  = emitente.e-mail
           tt-dados.rua-dest    = c-rua
           tt-dados.comp-dest   = c-comp
           tt-dados.nro-dest    = c-nro
           tt-dados.bairro-dest = nota-fiscal.bairro
           tt-dados.cidade-dest = nota-fiscal.cidade
           tt-dados.estado-dest = nota-fiscal.estado
           tt-dados.cep-dest    = nota-fiscal.cep
           tt-dados.nr-nota-fis = nota-fiscal.nr-nota-fis
           tt-dados.serie       = nota-fiscal.serie
           tt-dados.vl-tot-nota = nota-fiscal.vl-tot-nota
           tt-dados.altura      = int-nota-conhec.altura
           tt-dados.largura     = int-nota-conhec.largura
           tt-dados.comprimento = int-nota-conhec.comprimento.

    RETURN "OK":U.
END PROCEDURE.



