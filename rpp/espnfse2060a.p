/*****************************************************************************************************************************
** Programa: rpp/espnfse2060a.p 
** Autor   : Ivonei Vock
** Data    : 16/03/2012
** Objetivo: Retornar URL de consulta da NFSe
/**ATUALIZACAO: 20/03/2012**/
*****************************************************************************************************************************/
{cdp/cdcfgdis.i}

DEF INPUT  PARAM pr-nota-fiscal  AS ROWID                NO-UNDO.
DEF OUTPUT PARAM pc-url-consulta AS CHAR FORMAT "x(256)" NO-UNDO.
DEF OUTPUT PARAM pc-mensagem-ret AS CHAR FORMAT "x(256)" NO-UNDO.

DEF VAR v-url-origem   AS CHAR FORMAT "x(256)"                   NO-UNDO.
DEF VAR v-url-final    AS CHAR FORMAT "x(256)"                   NO-UNDO.
DEF VAR v-cont         AS INT                                    NO-UNDO.
DEF VAR v-cod-verifica LIKE esp-ext-nota-fiscal.cod-autentic-nfe NO-UNDO.

/*REGRA: Localiza nota fiscal e identifica IBGE do estabelecimento*/
FOR FIRST nota-fiscal NO-LOCK
    WHERE ROWID(nota-fiscal) = pr-nota-fiscal,
    FIRST estabelec NO-LOCK
    WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel,
    FIRST emitente NO-LOCK
    WHERE emitente.cod-emitente = nota-fiscal.cod-emitente,
    FIRST mgcad.cidade NO-LOCK
    WHERE cidade.cidade = estabelec.cidade
      AND cidade.estado = estabelec.estado:

    /*REGRA: URL fixa retornado pelo Mastersaf*/
    FIND FIRST esp-ext-nota-fiscal NO-LOCK
         WHERE esp-ext-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
           AND esp-ext-nota-fiscal.serie       = nota-fiscal.serie
           AND esp-ext-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis
           AND esp-ext-nota-fiscal.url-consulta-nfse <> "" NO-ERROR.

    IF  AVAIL esp-ext-nota-fiscal THEN DO:

        ASSIGN pc-url-consulta = esp-ext-nota-fiscal.url-consulta-nfse.
    END.

    /*REGRA: URL dinamica*/
    ELSE DO:

        /*REGRA: Localiza URL padrao*/
        FIND FIRST esp-ext-municipio-ibge NO-LOCK
             WHERE esp-ext-municipio-ibge.cod-ibge = cidade.cdn-munpio-ibge.
    
        /*REGRA: Validacoes*/
        IF  NOT AVAIL esp-ext-municipio-ibge THEN
            ASSIGN pc-mensagem-ret = "N∆o foi localizado o cadastro (ESPNFSE2060) para IBGE: " + STRING(cidade.cdn-munpio-ibge).
        ELSE IF esp-ext-municipio-ibge.url-consulta-nfse = "":U THEN
            ASSIGN pc-mensagem-ret = "URL n∆o est† dispon°vel/cadastrada (ESPNFSE2060)".
        ELSE IF R-INDEX(esp-ext-municipio-ibge.url-consulta-nfse,"[<@") = 0 THEN
            ASSIGN pc-url-consulta = esp-ext-municipio-ibge.url-consulta-nfse.
        ELSE DO:
    
            FIND FIRST esp-ext-nota-fiscal NO-LOCK
                 WHERE esp-ext-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                   AND esp-ext-nota-fiscal.serie       = nota-fiscal.serie
                   AND esp-ext-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
    
            IF  NOT AVAIL esp-ext-nota-fiscal THEN
                ASSIGN pc-mensagem-ret = "A URL n∆o pode ser acessada por falta de informaá∆o. Verifique se o RPS possui o N£mero da NFSe e C¢digo de Verificaá∆o.".
    
            ELSE DO:
    
                /*REGRA: Substituicao das variaveis*/
                ASSIGN v-url-origem = esp-ext-municipio-ibge.url-consulta-nfse.
        
                /*REGRA: Repeticao caso a mesma variavel seja informada mais de uma vez*/
                DO  v-cont = 1 TO 3:
    
                    /*CNPJ Prestador*/
                    IF  R-INDEX(v-url-origem,"[<@PrestadorCNPJ@>]") <> 0 THEN
                        ASSIGN v-url-final  = REPLACE(v-url-origem,"[<@PrestadorCNPJ@>]", estabelec.cgc)
                               v-url-origem = v-url-final.
            
                    /*IM Prestador*/
                    IF  R-INDEX(v-url-origem,"[<@PrestadorInscMun@>]") <> 0 THEN
                        ASSIGN v-url-final  = REPLACE(v-url-origem,"[<@PrestadorInscMun@>]", estabelec.ins-municipal)
                               v-url-origem = v-url-final.
            
                    /*CNPJ Tomador*/
                    IF  R-INDEX(v-url-origem,"[<@TomadorCNPJ@>]") <> 0 THEN
                        ASSIGN v-url-final  = REPLACE(v-url-origem,"[<@TomadorCNPJ@>]", emitente.cgc)
                               v-url-origem = v-url-final.
    
                    /*Nr NFSe*/
                    IF  R-INDEX(v-url-origem,"[<@NFS-e@>") <> 0 THEN DO:
    
                        IF  esp-ext-nota-fiscal.nr-nota-el = "" THEN
                            ASSIGN pc-mensagem-ret = "A URL n∆o pode ser acessada por falta de informaá∆o. Verifique se o RPS possui o N£mero da NFSe.".
    
                        ASSIGN v-url-final  = REPLACE(v-url-origem,"[<@NFS-e@>]", esp-ext-nota-fiscal.nr-nota-el)
                               v-url-origem = v-url-final.
                    END.
            
                    /*Cod Verificacao*/
                    IF  R-INDEX(v-url-origem,"[<@CodigoVerificacao@>]") <> 0 THEN DO:
    
                        IF  esp-ext-nota-fiscal.cod-autentic-nfe = "" THEN
                            ASSIGN pc-mensagem-ret = "A URL n∆o pode ser acessada por falta de informaá∆o. Verifique se o RPS possui o C¢digo de Verificaá∆o.".
    
                        ASSIGN v-url-final  = REPLACE(v-url-origem,"[<@CodigoVerificacao@>]", esp-ext-nota-fiscal.cod-autentic-nfe)
                               v-url-origem = v-url-final.
                    END.
    
                    /*Cod Verificacao Somente Letras e Numeros*/
                    IF  R-INDEX(v-url-origem,"[<@CodigoVerificacaoSM@>]") <> 0 THEN DO:
    
                        IF  esp-ext-nota-fiscal.cod-autentic-nfe = "" THEN
                            ASSIGN pc-mensagem-ret = "A URL n∆o pode ser acessada por falta de informaá∆o. Verifique se o RPS possui o C¢digo de Verificaá∆o.".
    
                        /** REGRA: Considerar apenas letras e numeros **/
                        DO  v-cont = 1 TO LENGTH(esp-ext-nota-fiscal.cod-autentic-nfe):
                    
                            IF  R-INDEX("1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", SUBSTRING(esp-ext-nota-fiscal.cod-autentic-nfe,v-cont,1)) > 0 THEN
                                ASSIGN v-cod-verifica = v-cod-verifica
                                                      + SUBSTRING(esp-ext-nota-fiscal.cod-autentic-nfe,v-cont,1).
    
                        END.
    
                        ASSIGN v-url-final  = REPLACE(v-url-origem,"[<@CodigoVerificacaoSM@>]", v-cod-verifica)
                               v-url-origem = v-url-final.
                    END.
                END.
    
                ASSIGN pc-url-consulta = v-url-final.
            END.
        END.
    END.
END.
