/*****************************************************************************
**
**     Objetivo: Importa‡Æo CTRCs GKO
**
**     Versao..: 2.00.00.000
**     Autor: hoepers - 09/04/2012
*****************************************************************************/
{include/i-prgvrs.i gk0005 2.00.00.000}

{utp/ut-glob.i}
define temp-table tt-param   no-undo
    field destino            as integer
    field arquivo            as char    format "x(35)"
    field usuario            as char    format "x(12)"
    field data-exec          as date
    field hora-exec          as integer
    FIELD dt-registro        AS DATE.

define temp-table tt-digita no-undo
    field num-nota     like nota-fiscal.nr-nota-fis.

def temp-table tt-raw-digita
   field raw-digita      as raw.

DEF TEMP-TABLE tt-cfop
    FIELD cod-estabel AS CHAR
    FIELD v-cod-cfop-dentro AS CHAR
    FIELD v-cod-cfop-fora   AS CHAR
        INDEX ch-estab cod-estabel.
        
DEF TEMP-TABLE tt-CHAVE
    FIELD chave_acesso_cte AS CHAR
    INDEX ch-chave chave_acesso_cte.

    

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{esp/gko/gk0005rp.i}  /* Temp-table integra‡Æo OF          */
{esp/gko/gkapi001.i} /* Defini‡Æo temp-table "tt-log-gko" */

DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

DEFINE BUFFER b-tt-log-gko FOR tt-log-gko.

DEFINE VARIABLE v-dat-congela     AS DATE        NO-UNDO.
DEFINE VARIABLE v-ind-tipo-reg    AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-log-integra-of  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v-cod-dir-origem  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-cod-dir-destino AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-cod-linha-imp   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE rw-documento      AS ROWID       NO-UNDO.
DEFINE VARIABLE v-val-aliq-imp    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-val-aliq-pis    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-val-aliq-cofins AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-descricao-db    AS CHARACTER   NO-UNDO. /*Leonam liberação notas fiscais de serviço, para constar a composição dos ctes no OF*/
DEFINE VARIABLE cCdNC             AS CHAR        NO-UNDO.

DEFINE VARIABLE h-boin046na       AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-bodi144         AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-bodi515         AS HANDLE     NO-UNDO.

/*******************************************************************/

FIND LAST   param-global NO-LOCK NO-ERROR.
FIND FIRST  tt-param     NO-LOCK NO-ERROR.

EMPTY TEMP-TABLE tt-log-gko.
EMPTY TEMP-TABLE tt-conhec.
EMPTY TEMP-TABLE tt-CHAVE.
EMPTY TEMP-TABLE tt-impostos.
EMPTY TEMP-TABLE tt-conta-contab.
EMPTY TEMP-TABLE tt-nota-fisc-adc.

/* Identificar diret¢rio destino dos arquivos */
FOR FIRST ponto-programa
    WHERE ponto-programa.nome-programa = "gk0005"
      AND ponto-programa.ponto         = 1,
     EACH conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        
    IF  conteudo-programa.conteudo                  <> "" AND
        NUM-ENTRIES(conteudo-programa.conteudo,";")  > 1
    THEN DO:
        IF  OPSYS = "WIN32"
        THEN DO:
            IF  ENTRY(1,conteudo-programa.conteudo,";") = "SAIDAGKOWIN32"
            THEN
                ASSIGN v-cod-dir-origem = ENTRY(2,conteudo-programa.conteudo,";").

            IF  ENTRY(1,conteudo-programa.conteudo,";") = "BACKUPGKOWIN32"
            THEN
                ASSIGN v-cod-dir-destino = ENTRY(2,conteudo-programa.conteudo,";").
        END.
        ELSE DO:
            IF  ENTRY(1,conteudo-programa.conteudo,";") = "SAIDAGKOUNIX"
            THEN
                ASSIGN v-cod-dir-origem = ENTRY(2,conteudo-programa.conteudo,";").

            IF  ENTRY(1,conteudo-programa.conteudo,";") = "BACKUPGKOUNIX"
            THEN
                ASSIGN v-cod-dir-destino = ENTRY(2,conteudo-programa.conteudo,";").
        END.
    END.
END.

/* Identificar CFOP conforme origem Dentro/Fora Estado */
FOR FIRST ponto-programa
    WHERE ponto-programa.nome-programa = "gk0005"
      AND ponto-programa.ponto         = 2,
     EACH conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        
    IF  conteudo-programa.conteudo                  <> "" AND
        NUM-ENTRIES(conteudo-programa.conteudo,";")  > 1
    THEN DO:

        FIND tt-cfop
             WHERE tt-cfop.cod-estabel = ENTRY(1,conteudo-programa.conteudo,";") EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL TT-CFOP THEN
            CREATE tt-cfop.

        ASSIGN tt-cfop.cod-estabel = ENTRY(1,conteudo-programa.conteudo,";").

        IF  ENTRY(2,conteudo-programa.conteudo,";") = "CTDE" /* Conhecimento Transporte Dentro Estado */
        THEN
            ASSIGN tt-cfop.v-cod-cfop-dentro = ENTRY(3,conteudo-programa.conteudo,";").

        IF  ENTRY(2,conteudo-programa.conteudo,";") = "CTFE" /* Conhecimento Transporte Fora Estado */
        THEN
            ASSIGN tt-cfop.v-cod-cfop-fora = ENTRY(3,conteudo-programa.conteudo,";").
    END.                                   
END.

/* Identificar Aliquota PIS/COFINS */
FOR FIRST ponto-programa
    WHERE ponto-programa.nome-programa = "gk0005"
      AND ponto-programa.ponto         = 3,
     EACH conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        
    IF  conteudo-programa.conteudo                  <> "" AND
        NUM-ENTRIES(conteudo-programa.conteudo,";")  > 1
    THEN DO:
        IF  ENTRY(1,conteudo-programa.conteudo,";") = "PIS" /* Conhecimento Transporte Dentro Estado */
        THEN
            ASSIGN v-val-aliq-pis = DEC(ENTRY(2,conteudo-programa.conteudo,";")).

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "COFINS" /* Conhecimento Transporte Fora Estado */
        THEN
            ASSIGN v-val-aliq-cofins = DEC(ENTRY(2,conteudo-programa.conteudo,";")).
    END.
END.

/* Ler arquivos no diret¢rio de origem */
INPUT FROM OS-DIR(v-cod-dir-origem) NO-ECHO.
REPEAT:
    CREATE tt-arquivos.
    IMPORT tt-arquivos.nom-arquivo tt-arquivos.nom-completo tt-arquivos.ind-tipo-arquivo.

    IF  NOT tt-arquivos.nom-arquivo BEGINS "frnc" OR
            tt-arquivos.ind-tipo-arquivo <> "F"
    THEN
        DELETE tt-arquivos.
END.
INPUT CLOSE.

/* Importar conte£do dos arquivos encontrados */
FOR EACH  tt-arquivos.  

    IF  SEARCH(tt-arquivos.nom-completo) <> ?
    THEN DO:
        INPUT FROM VALUE(SEARCH(tt-arquivos.nom-completo)).
        CREATE tt-log-gko.
        ASSIGN tt-log-gko.ind-tipo-integracao    = 1
               tt-log-gko.log-imp-erro           = NO
               tt-log-gko.des-erro-imp           = "Integra‡Æo realizada com sucesso."
               tt-log-gko.nom-arquivo-integracao = SEARCH(tt-arquivos.nom-completo)
               tt-log-gko.cod-arquivo-integracao = tt-arquivos.nom-arquivo.

        REPEAT:
            IMPORT UNFORMATTED v-cod-linha-imp.
            RUN pi-cria-registros.
        END.
        INPUT CLOSE.

    END.

END.

FOR EACH doc-fiscal
   WHERE doc-fiscal.dt-docto >= (TODAY - 90) NO-LOCK:

    /*coleta chave de acesso*/
  CREATE tt-CHAVE.
  ASSIGN tt-CHAVE.chave_acesso_cte = SUBSTRING(doc-fiscal.char-2,155,60) .
END.

/* Gerar integra‡Æo com OF-EMS */
FOR EACH tt-conhec NO-LOCK:

    EMPTY TEMP-TABLE tt-doc-fiscal.
    EMPTY TEMP-TABLE tt-it-doc-fisc.
/*     EMPTY TEMP-TABLE tt-impostos. */
    EMPTY TEMP-TABLE tt-nota-fisc-adc.

    RUN pi-integra-of.
END.

/* Inicio controlar log de erros e backup dos arquivos processados */
FOR EACH  b-tt-log-gko
    WHERE b-tt-log-gko.log-imp-erro = NO:
    FIND FIRST tt-log-gko
        WHERE  tt-log-gko.nom-arquivo-integracao = b-tt-log-gko.nom-arquivo-integracao
          AND  tt-log-gko.log-imp-erro           = YES NO-ERROR.

    IF  AVAIL tt-log-gko
    THEN
        DELETE b-tt-log-gko.
    ELSE DO:
        OS-COPY   VALUE(b-tt-log-gko.nom-arquivo-integracao) VALUE(v-cod-dir-destino + b-tt-log-gko.cod-arquivo-integracao).
        OS-DELETE VALUE(b-tt-log-gko.nom-arquivo-integracao) NO-ERROR.
    END.
END.

RUN esp/gko/gkapi001.p (INPUT TABLE tt-log-gko).

/* Fim controlar log de erros e backup dos arquivos processados */

RUN pi-limpa-handle.

RETURN "ok".

/**********************************************************************/

PROCEDURE pi-cria-registros:

    ASSIGN v-ind-tipo-reg = INT(TRIM(SUBSTR(v-cod-linha-imp,1,3))).

    CASE v-ind-tipo-reg:
        WHEN(700) 
        THEN DO:
/*            Leonam Liberação notas fiscais de serviço*/
            assign c-descricao-db = "".

            ASSIGN cCdNC = TRIM(SUBSTR(v-cod-linha-imp,23,12)).

            CREATE tt-conhec.
            ASSIGN tt-conhec.IdNC                   = INT(TRIM(SUBSTR(v-cod-linha-imp,4,15)))
                   tt-conhec.CdTipoNC               = TRIM(SUBSTR(v-cod-linha-imp,19,4))
                   tt-conhec.CdNC                   = STRING(INT(cCdNC)) //TRIM(SUBSTR(int(v-cod-linha-imp,23,12)))   
                   tt-conhec.CdSerieNC              = TRIM(SUBSTR(v-cod-linha-imp,35,5))
                   tt-conhec.TpPessoaTransp         = INT(TRIM(SUBSTR(v-cod-linha-imp,40,1)))
                   tt-conhec.CNPJCPFTransp          = TRIM(SUBSTR(v-cod-linha-imp,41,14))
                   tt-conhec.DsIEDestTransp         = TRIM(SUBSTR(v-cod-linha-imp,55,15))                   
                   tt-conhec.CdParRespFrete         = TRIM(SUBSTR(v-cod-linha-imp,70,14))
                   tt-conhec.CNPJParRespFrete       = TRIM(SUBSTR(v-cod-linha-imp,84,14))
                   tt-conhec.DtRegistroNC           = IF tt-param.dt-registro <> ? THEN DATE(TRIM(SUBSTR(v-cod-linha-imp,98,10))) ELSE tt-param.dt-registro
                   tt-conhec.DtEmissaoNC            = DATE(TRIM(SUBSTR(v-cod-linha-imp,108,10)))
                   tt-conhec.VrFreteApagar          = DEC(TRIM(SUBSTR(v-cod-linha-imp,124,15))) / 100
                   tt-conhec.VrDesconto             = DEC(TRIM(SUBSTR(v-cod-linha-imp,139,15))) / 100
                   tt-conhec.StSubstTriburariaIcms  = IF INT(TRIM(SUBSTR(v-cod-linha-imp,154,1))) = 1 THEN YES ELSE NO
                   tt-conhec.DsUFOrigem             = TRIM(SUBSTR(v-cod-linha-imp,155,2))
                   tt-conhec.DsUFDestino            = TRIM(SUBSTR(v-cod-linha-imp,157,2))
                   tt-conhec.cdFatura               = TRIM(SUBSTR(v-cod-linha-imp,159,12))
                   tt-conhec.TotVrRatFreteCobradoNC = DEC(TRIM(SUBSTR(v-cod-linha-imp,171,15))) / 100
                   tt-conhec.DsChaveAcesso          = TRIM(SUBSTR(v-cod-linha-imp,186,44))
                   tt-conhec.CdNaturezaOperacao     = TRIM(SUBSTR(v-cod-linha-imp,230,6))
                   tt-conhec.tp-ct-e                = SUBSTR(v-cod-linha-imp,236,1)
                   tt-conhec.DesArquivoOrigem       = SEARCH(tt-arquivos.nom-completo)
                   tt-conhec.CdIbgeOrig             = TRIM(SUBSTR(v-cod-linha-imp,237,7))  
                   tt-conhec.CdIbgeDest             = TRIM(SUBSTR(v-cod-linha-imp,244,7)).
                   /* base de calculo para notas fiscais de servi‡o de frete - Leonam 10/03/2020*/ 
                   if lookup(TRIM(SUBSTR(v-cod-linha-imp,230,6)),"194994,194992,100000,100001") > 0 then do:
                       assign tt-conhec.VrFreteApagar = DEC(TRIM(SUBSTR(v-cod-linha-imp,171,15))) / 100.
                   end.  

        END. /* WHEN(700) */
        WHEN(720) 
        THEN DO:
            CREATE tt-impostos.
            ASSIGN tt-impostos.IdNC                 = INT(TRIM(SUBSTR(v-cod-linha-imp,4,15)))
                   tt-impostos.CDIMPOSTO            = INT(TRIM(SUBSTR(v-cod-linha-imp,19,3)))
                   tt-impostos.VRBASECALIMPOSTO     = DEC(TRIM(SUBSTR(v-cod-linha-imp,22,15))) / 100
                   tt-impostos.PCALIQUOTAIMPOSTO    = DEC(TRIM(SUBSTR(v-cod-linha-imp,37,8)))  / 100
                   tt-impostos.VRIMPOSTO            = DEC(TRIM(SUBSTR(v-cod-linha-imp,45,15))) / 100
                   tt-impostos.TPTRIBICMS           = TRIM(SUBSTR(v-cod-linha-imp,60,2))
                   tt-impostos.TPTRIBUTACAO         = TRIM(SUBSTR(v-cod-linha-imp,62,2)).   
                   if lookup(TRIM(SUBSTR(tt-conhec.CdNaturezaOperacao,1,6)),"194994,194992,100000,100001") > 0 then do:
                      assign tt-impostos.VRBASECALIMPOSTO      = tt-conhec.VrFreteApagar.
                   end.    
  
                   if lookup(TRIM(SUBSTR(tt-conhec.CdNaturezaOperacao,1,6)),"194994,194992,100000,100001") <= 0 then do:
                ASSIGN tt-impostos.TPTRIBICMS = "00". /* Ser  considerado fixo inicialmente Tributa, por‚m, vamos revisar a rotina, pois o GKO nÆo gera a natureza de opera‡Æo correta */
             end.
        END. /* WHEN(720) */
        WHEN(740)
        THEN DO:

           assign c-descricao-db = c-descricao-db + " " + TRIM(SUBSTR(v-cod-linha-imp,33,12)) + "/" + TRIM(SUBSTR(v-cod-linha-imp,45,3)).
        END. /* WHEN(750) */
        WHEN(750)
        THEN DO:
            CREATE tt-conta-contab.
            ASSIGN tt-conta-contab.IdNC               = tt-conhec.IdNC
                   tt-conta-contab.CdContaContabil    = TRIM(SUBSTR(v-cod-linha-imp,4,35))  
                   tt-conta-contab.CdCentroCusto      = TRIM(SUBSTR(v-cod-linha-imp,39,10))
                   tt-conta-contab.VrRatAPagarCobrado = DEC(TRIM(SUBSTR(v-cod-linha-imp,49,15))) / 100
                   tt-conta-contab.VrRatFreteCobrado  = DEC(TRIM(SUBSTR(v-cod-linha-imp,64,15))) / 100.
        END. /* WHEN(750) */
    END CASE. /* CASE v-ind-tipo-reg: */

END PROCEDURE.


PROCEDURE pi-integra-of:

    DEFINE VARIABLE lTributado        AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-tp-apuracao     AS INTEGER     NO-UNDO.
/*Leonam 30/07*/
    if lookup(TRIM(SUBSTR(tt-conhec.CdNaturezaOperacao,1,6)),"194994,194992,100000,100001,135200,135201,135202,135203,135205,135207,135210,135213" + "," +
                                                              "135217,135218,135299,1352A1,1352A2,1352X0,1352X1,1352X2" + "," +
                                                              "1352X3,1352X5,1352X6,1352X7,235200,235201,235203,235204" + "," +
                                                              "235205,235206,235208,235209,235210,235217,235218,235220" + "," +
                                                              "235221,235299,2352A0,2352A1,2352A2,2352A3,2352A4,2352A9" + "," +
                                                              "2352X0,2352X1,2352X2,2352X5,2352X6,2352X7,2352X9,2352XA" + "," +
                                                              "1932x0,1932x1,2932X0") > 0 then do:

    /* Buscar item para nota de frete */
    FIND ITEM NO-LOCK
        WHERE ITEM.it-codigo = "Fretes" NO-ERROR.
    /*        , procurar itens fretes ********alterar */
    end.
    ELSE do:
        FIND ITEM NO-LOCK
        WHERE ITEM.it-codigo = "" NO-ERROR.
    end. 
    IF  NOT VALID-HANDLE(h-boin046na) THEN
        RUN inbo/boin046na.p PERSISTENT SET h-boin046na.
    
    RUN openQueryStatic IN h-boin046na ("Main").

    BLOCO:
    DO  TRANS ON ERROR UNDO, LEAVE:
    
        /***** CRIANDO DOCUMENTO FISCAL *****/
        FIND FIRST emitente NO-LOCK
            WHERE  emitente.cgc = tt-conhec.CNPJCPFTransp NO-ERROR.
        IF NOT AVAIL emitente THEN DO:
            CREATE tt-log-gko.
            ASSIGN tt-log-gko.ind-tipo-integracao    = 1
                   tt-log-gko.log-imp-erro           = YES
                   tt-log-gko.des-erro-imp           = "CNPJ da transportadora nao cadastrada no TOTVS. Verifique com area responsavel pelo cadastro"
                                                       + CHR(13) 
                                                       + "CNPJ....: " + tt-conhec.CNPJCPFTransp.
                  tt-log-gko.nom-arquivo-integracao = tt-conhec.DesArquivoOrigem.
            RETURN "NOK":U.
        END.

        IF tt-conhec.CdNaturezaOperacao = "" THEN DO:
            CREATE tt-log-gko.
            ASSIGN tt-log-gko.ind-tipo-integracao    = 1
                   tt-log-gko.log-imp-erro           = YES
                   tt-log-gko.des-erro-imp           = "Conhecimento com natureza em branco. Verifique com a area responsavel pelo cadastro"
                                                       + CHR(13) 
                                                       + "CNPJ....: " + tt-conhec.CNPJCPFTransp
                                                       + "Documento: " + string(tt-conhec.CdNc).
                  tt-log-gko.nom-arquivo-integracao = tt-conhec.DesArquivoOrigem.
            RETURN "NOK":U.
        END.

        FIND FIRST estabelec NO-LOCK
            WHERE  estabelec.cgc = tt-conhec.CNPJParRespFrete NO-ERROR.

        FIND tt-cfop
            WHERE tt-cfop.cod-estabel = estabelec.cod-estabel NO-LOCK NO-ERROR.
        /*no caso de notas de servi‡o nÆo precisa validar a natureza de opera‡Æo o GKo exporta corretamente. Leonam - 10/30/2020*/
        if lookup(TRIM(SUBSTR(tt-conhec.CdNaturezaOperacao,1,6)),"135217,1352A1,1352X7,235217,2352A1,2352X7") > 0 then do:

            IF AVAIL tt-cfop THEN DO:
                /* Tratar Natureza para Fornecedor dentro ou fora do Estado. Ser  necess rio buscar alternativas no GKO para que ambos fiquem iguais */
                ASSIGN tt-conhec.CdNaturezaOperacao = tt-cfop.v-cod-cfop-dentro.
    
                IF  emitente.estado <> estabelec.estado THEN
                    ASSIGN tt-conhec.CdNaturezaOperacao = tt-cfop.v-cod-cfop-fora.
            END.
        end. 
        /* Tratar s‚rie do documento com valor inv lido para OF. Ser  necess rio buscar alternativas no GKO para que ambos fiquem iguais */
        IF  tt-conhec.CdSerieNC = "000" OR
            tt-conhec.CdSerieNC = "00"
        THEN
            ASSIGN tt-conhec.CdSerieNC = "0".

        IF  tt-conhec.CdSerieNC = "001" OR
            tt-conhec.CdSerieNC = "01"
        THEN
            ASSIGN tt-conhec.CdSerieNC = "1".

        IF  tt-conhec.CdSerieNC = "Unica" OR
            tt-conhec.CdSerieNC = "Uni"   OR
            tt-conhec.CdSerieNC = "Un"
        THEN
            ASSIGN tt-conhec.CdSerieNC = "0".
    
        EMPTY TEMP-TABLE tt-doc-fiscal.
        CREATE tt-doc-fiscal.

        FIND natur-oper NO-LOCK
            WHERE natur-oper.nat-operacao = tt-conhec.CdNaturezaOperacao NO-ERROR.

        ASSIGN tt-doc-fiscal.cod-emitente = emitente.cod-emitente                     
               tt-doc-fiscal.cod-estabel  = estabelec.cod-estabel    
               tt-doc-fiscal.nat-operacao = tt-conhec.CdNaturezaOperacao
               tt-doc-fiscal.nr-doc-fis   = IF length(tt-conhec.CdNc) > 7 THEN STRING(INT(tt-conhec.CdNc),"99999999999") ELSE STRING(INT(tt-conhec.CdNc),"9999999") 
               tt-doc-fiscal.serie        = tt-conhec.CdSerieNC
               tt-doc-fiscal.bairro       = emitente.bairro      
               tt-doc-fiscal.cep          = emitente.cep         
               tt-doc-fiscal.cidade       = emitente.cidade      
               tt-doc-fiscal.cod-emitente = emitente.cod-emitente
               tt-doc-fiscal.endereco     = emitente.endereco    
               tt-doc-fiscal.estado       = emitente.estado      
               tt-doc-fiscal.cgc          = emitente.cgc
               tt-doc-fiscal.ins-estadual = emitente.ins-estadual
               tt-doc-fiscal.nome-ab-emi  = emitente.nome-abrev  
               tt-doc-fiscal.pais         = emitente.pais
               tt-doc-fiscal.ind-sit-doc  = 1
               tt-doc-fiscal.dt-docto     = tt-conhec.DtRegistroNC
               tt-doc-fiscal.dt-emis-doc  = tt-conhec.DtEmissaoNC
               tt-doc-fiscal.ind-ori-doc  = 3 /* Manual */
               tt-doc-fiscal.esp-docto    = "NFE"
               tt-doc-fiscal.cod-mensagem = 1
               tt-doc-fiscal.cod-cfop     = SUBSTR(tt-conhec.CdNaturezaOperacao,1,4)
               tt-doc-fiscal.cod-observa  = 5 /* Frete CIF */
               tt-doc-fiscal.tipo-nat     = IF AVAIL natur-oper THEN natur-oper.tipo ELSE 1
               OVERLAY(tt-doc-fiscal.char-2,155,60) = tt-conhec.DsChaveAcesso
               OVERLAY(tt-doc-fiscal.char-2,237,8) = "0"
               overlay(tt-doc-fiscal.char-2,245,1) = tt-conhec.tp-ct-e
               OVERLAY(tt-doc-fiscal.char-1,231,10) = tt-conhec.CdIbgeOrig 
               OVERLAY(tt-doc-fiscal.char-1,241,10) = tt-conhec.CdIbgeDest
               tt-doc-fiscal.manut-icm = IF AVAIL natur-oper THEN natur-oper.manut-icm ELSE false
               tt-doc-fiscal.manut-ipi = IF AVAIL natur-oper THEN natur-oper.manut-ipi ELSE false.
                  if lookup(TRIM(SUBSTR(tt-conhec.CdNaturezaOperacao,1,6)),"135200,135201,135202,135203,135205,135207,135210
                                                                           ,135213,135218,135299,1352A2,1352X0,1352X1,1352X2
                                                                           ,1352X3,1352X5,1352X6,235200,235201,235203,235204
                                                                           ,235205,235206,235208,235209,235210,235218,235220
                                                                           ,235221,235299,2352A0,2352A2,2352A3,2352A4,2352A9
                                                                           ,2352X0,2352X1,2352X2,2352X5,2352X6,2352X9,2352XA
                                                                           ,1932x0,1932x1,2932X0") > 0 then do:
                     assign tt-doc-fiscal.cod-observa  = 6
                            tt-doc-fiscal.ind-cifob = 2.
                     
                  end. /*Leonam 30/07*/
        if lookup(TRIM(SUBSTR(tt-conhec.CdNaturezaOperacao,1,6)),"194994,194992,100000,100001") > 0 then do:
          
           assign tt-doc-fiscal.cod-observa  = 4
                  tt-doc-fiscal.tipo-nat     = 3.
        end. 
        IF NOT VALID-HANDLE(h-bodi144) 
        THEN
            RUN dibo/bodi144.p PERSISTENT SET h-bodi144.
            
        IF VALID-HANDLE(h-bodi144) 
        THEN DO:
            RUN openQueryStatic IN h-bodi144(INPUT "Main":U).
            RUN goToKey         IN h-bodi144(INPUT tt-doc-fiscal.cod-estabel).
            IF RETURN-VALUE = "OK":U THEN
                RUN getDateField IN h-bodi144(INPUT "v-dat-congela":U, OUTPUT v-dat-congela).
                
            IF tt-doc-fiscal.dt-docto < v-dat-congela 
            THEN DO:
                CREATE tt-log-gko.
                ASSIGN tt-log-gko.ind-tipo-integracao    = 1
                       tt-log-gko.log-imp-erro           = YES
                       tt-log-gko.des-erro-imp           = "O documento de frete est  dentro do per¡odo de congelamento para lan‡amento em Obriga‡äes Fiscais. Verifique a Data de Congelamento no programa OF0301"
                                                         + CHR(13) 
                                                         + "Est....: " + tt-doc-fiscal.cod-estabel          + CHR(13)
                                                         + "Fornec.: " + STRING(tt-doc-fiscal.cod-emitente) + CHR(13)
                                                         + "S‚rie..: " + tt-doc-fiscal.serie                + CHR(13)
                                                         + "Nota...: " + tt-doc-fiscal.nr-doc-fis           + CHR(13)
                                                         + "Natureza:" + tt-doc-fiscal.nat-operacao         + CHR(13)
                       tt-log-gko.nom-arquivo-integracao = tt-conhec.DesArquivoOrigem.
                RETURN "NOK":U.
            END.
            
            RUN destroy IN h-bodi144. 
        END.
        
        FIND natur-oper NO-LOCK
            WHERE natur-oper.nat-operacao = tt-doc-fiscal.nat-operacao NO-ERROR.

        IF  AVAIL natur-oper and
                  natur-oper.ind-gera-of = NO 
        THEN DO:
            CREATE tt-log-gko.                      
            ASSIGN tt-log-gko.ind-tipo-integracao    = 1
                   tt-log-gko.log-imp-erro           = YES
                   tt-log-gko.des-erro-imp           = "Natureza de opera‡Æo nÆo atualiza o m¢dulo de Obriga‡äes Fiscais."
                                                     + CHR(13) 
                                                     + "Est....: " + tt-doc-fiscal.cod-estabel          + CHR(13)
                                                     + "Fornec.: " + STRING(tt-doc-fiscal.cod-emitente) + CHR(13)
                                                     + "S‚rie..: " + tt-doc-fiscal.serie                + CHR(13)
                                                     + "Nota...: " + tt-doc-fiscal.nr-doc-fis           + CHR(13)
                                                     + "Natureza:" + tt-doc-fiscal.nat-operacao         + CHR(13)
                   tt-log-gko.nom-arquivo-integracao = tt-conhec.DesArquivoOrigem.
            RETURN "NOK":U.
        END.
/*    
        FIND FIRST doc-fiscal NO-LOCK
            WHERE  doc-fiscal.cod-estabel  = tt-doc-fiscal.cod-estabel
              AND  doc-fiscal.serie        = tt-doc-fiscal.serie      
              AND  doc-fiscal.nr-doc-fis   = tt-doc-fiscal.nr-doc-fis 
              AND  doc-fiscal.cod-emitente = tt-doc-fiscal.cod-emitente
              AND  doc-fiscal.nat-operacao = tt-doc-fiscal.nat-operacao NO-ERROR.

        IF  AVAIL doc-fiscal
        THEN DO:
            CREATE tt-log-gko.
            ASSIGN tt-log-gko.ind-tipo-integracao    = 1
                   tt-log-gko.log-imp-erro           = YES
                   tt-log-gko.des-erro-imp           = "O documento j  existe no m¢dulo de Obriga‡äes Fiscais."
                                                     + CHR(13) 
                                                     + "Est....: " + tt-doc-fiscal.cod-estabel          + CHR(13)
                                                     + "Fornec.: " + STRING(tt-doc-fiscal.cod-emitente) + CHR(13)
                                                     + "S‚rie..: " + tt-doc-fiscal.serie                + CHR(13)
                                                     + "Nota...: " + tt-doc-fiscal.nr-doc-fis           + CHR(13)
                                                     + "Natureza:" + tt-doc-fiscal.nat-operacao         + CHR(13)
                   tt-log-gko.nom-arquivo-integracao = tt-conhec.DesArquivoOrigem.
            RETURN "NOK":U.
*/
      if lookup(TRIM(SUBSTR(tt-conhec.CdNaturezaOperacao,1,6)),"194994,194992,100000,100001") <= 0 then do:
        IF CAN-FIND (FIRST tt-CHAVE
                     WHERE tt-CHAVE.chave_acesso_cte = tt-conhec.DsChaveAcesso) THEN DO:
    
                CREATE tt-log-gko.
                ASSIGN tt-log-gko.ind-tipo-integracao    = 1
                       tt-log-gko.log-imp-erro           = YES
                       tt-log-gko.des-erro-imp           = "O documento ja existe no m½dulo de Obrigacoes Fiscais com a chave informada."
                                                         + CHR(13) 
                                                         + "Est....: " + tt-doc-fiscal.cod-estabel           + CHR(13)
                                                         + "Fornec.: " + STRING(tt-doc-fiscal.cod-emitente)  + CHR(13)
                                                         + "S²rie..: " + tt-doc-fiscal.serie                 + CHR(13)
                                                         + "Nota...: " + tt-doc-fiscal.nr-doc-fis            + CHR(13)
                                                         + "Natureza:" + tt-doc-fiscal.nat-operacao          + CHR(13)
                                                         + "Chave acesso:" + tt-conhec.DsChaveAcesso         + CHR(13)
                       tt-log-gko.nom-arquivo-integracao = tt-conhec.DesArquivoOrigem.
                RETURN "NOK":U.
        END.

        IF tt-conhec.CdIbgeOrig = "" OR tt-conhec.CdIbgeDest = "" THEN DO:
             CREATE tt-log-gko.
             ASSIGN tt-log-gko.ind-tipo-integracao    = 1
                    tt-log-gko.log-imp-erro           = YES
                    tt-log-gko.des-erro-imp           = "O documento nÆo possui codigo ibge origem ou destino"
                                                      + CHR(13) 
                                                      + "Est....: " + tt-doc-fiscal.cod-estabel          + CHR(13)
                                                      + "Fornec.: " + STRING(tt-doc-fiscal.cod-emitente) + CHR(13)
                                                      + "S²rie..: " + tt-doc-fiscal.serie                + CHR(13)
                                                      + "Nota...: " + tt-doc-fiscal.nr-doc-fis           + CHR(13)
                                                      + "Natureza:" + tt-doc-fiscal.nat-operacao         + CHR(13)
                    tt-log-gko.nom-arquivo-integracao = tt-conhec.DesArquivoOrigem.
             RETURN "NOK":U.
        
        END.
     END.
     ELSE DO:
        FIND FIRST doc-fiscal NO-LOCK
            WHERE  doc-fiscal.cod-estabel  = tt-doc-fiscal.cod-estabel
              AND  doc-fiscal.serie        = tt-doc-fiscal.serie      
              AND  doc-fiscal.nr-doc-fis   = tt-doc-fiscal.nr-doc-fis 
              AND  doc-fiscal.cod-emitente = tt-doc-fiscal.cod-emitente
              AND  doc-fiscal.nat-operacao = tt-doc-fiscal.nat-operacao NO-ERROR.

        IF  AVAIL doc-fiscal
        THEN DO:
            CREATE tt-log-gko.
            ASSIGN tt-log-gko.ind-tipo-integracao    = 1
                   tt-log-gko.log-imp-erro           = YES
                   tt-log-gko.des-erro-imp           = "O documento j  existe no m¢dulo de Obriga‡äes Fiscais."
                                                     + CHR(13) 
                                                     + "Est....: " + tt-doc-fiscal.cod-estabel          + CHR(13)
                                                     + "Fornec.: " + STRING(tt-doc-fiscal.cod-emitente) + CHR(13)
                                                     + "S‚rie..: " + tt-doc-fiscal.serie                + CHR(13)
                                                     + "Nota...: " + tt-doc-fiscal.nr-doc-fis           + CHR(13)
                                                     + "Natureza:" + tt-doc-fiscal.nat-operacao         + CHR(13)
                   tt-log-gko.nom-arquivo-integracao = tt-conhec.DesArquivoOrigem.
            RETURN "NOK":U.
        END.    
     END.     
      CREATE doc-fiscal.
        BUFFER-COPY tt-doc-fiscal TO doc-fiscal.
        ASSIGN rw-documento = ROWID(doc-fiscal).
        RELEASE doc-fiscal.

        /***** FIM DOCUMENTO FISCAL *****/

        /****** CRIANDO ITEM ******/
        EMPTY TEMP-TABLE tt-it-doc-fisc.
        CREATE tt-it-doc-fisc.
        ASSIGN tt-it-doc-fisc.nr-seq-doc     = 10
               tt-it-doc-fisc.cod-estabel    = tt-doc-fiscal.cod-estabel  
               tt-it-doc-fisc.serie          = tt-doc-fiscal.serie        
               tt-it-doc-fisc.nr-doc-fis     = tt-doc-fiscal.nr-doc-fis   
               tt-it-doc-fisc.cod-emitente   = tt-doc-fiscal.cod-emitente 
               tt-it-doc-fisc.nat-operacao   = tt-doc-fiscal.nat-operacao
  
               tt-it-doc-fisc.nr-seq-doc     = tt-it-doc-fisc.nr-seq-doc
               tt-it-doc-fisc.dt-docto       = tt-doc-fiscal.dt-docto

               /*Leonam*/
               tt-it-doc-fisc.descricao-db   = c-descricao-db

               
               tt-it-doc-fisc.dt-emis-doc    = tt-doc-fiscal.dt-emis-doc
               tt-it-doc-fisc.ind-ori-doc    = 3 /* Manual */
               tt-it-doc-fisc.conta-contabil = item.conta-aplicacao
               tt-it-doc-fisc.ct-codigo      = item.ct-codigo
               tt-it-doc-fisc.sc-codigo      = item.sc-codigo
               tt-it-doc-fisc.tipo-nat       = IF AVAIL natur-oper THEN natur-oper.tipo ELSE 1. 

                  /*devolu‡Æo Leonam*/  
        if lookup(TRIM(SUBSTR(tt-conhec.CdNaturezaOperacao,1,6)),"194994,194992,100000,100001") > 0 then do:
                          
        ASSIGN tt-it-doc-fisc.class-fiscal   = ITEM.class-fiscal 
               tt-it-doc-fisc.it-codigo      = ITEM.it-codigo.
        end.
        else do:
          ASSIGN     tt-it-doc-fisc.it-codigo      = ""
                     tt-it-doc-fisc.class-fiscal   =   "85177010"  .
       
        end.
                       
               

        RUN goToKey IN h-boin046na (INPUT tt-it-doc-fisc.class-fiscal).
        IF  RETURN-VALUE = "OK" THEN DO:
            RUN getIntField IN h-boin046na (INPUT "idi-tip-apurac-ipi", OUTPUT i-tp-apuracao).
            assign tt-it-doc-fisc.idi-tip-apurac-ipi = i-tp-apuracao.
         END.
        /* Se tiver ICMS */
        /* Caso tributado, vai para o EMS como ICMS e Tributa‡Æo Tributado */
 /*Leonam 30/07*/
      /*LEONAM Verifica informa‡äes de tributa‡Æo na natureza de opera‡Æo ICMS*/   
    
      if avail natur-oper then  tt-it-doc-fisc.cd-trib-icm = natur-oper.cd-trib-icm.

        FIND FIRST tt-impostos NO-LOCK
            WHERE  tt-impostos.idnc      = tt-conhec.idnc 
              AND (tt-impostos.cdimposto = 1  /* ICMS    */ 
               OR  tt-impostos.cdimposto = 3) /* IMCS ST */ NO-ERROR.
        ASSIGN tt-it-doc-fisc.un              = ITEM.un
               tt-it-doc-fisc.cd-trib-iss     = 2 /* Isento */
               tt-it-doc-fisc.cd-trib-ipi     = 2 /* Isento */
               tt-it-doc-fisc.pc-desc-icms    = 0
               tt-it-doc-fisc.perc-red-icm    = 0
               tt-it-doc-fisc.perc-red-iss    = 0
               tt-it-doc-fisc.vl-bicms-it     = 0
               tt-it-doc-fisc.vl-biss-it      = 0
               tt-it-doc-fisc.vl-icms-it      = 0
               tt-it-doc-fisc.vl-icmsnt-it    = 0
               tt-it-doc-fisc.vl-icmsub-it    = 0
               tt-it-doc-fisc.vl-icmsub-it-en = 0
               tt-it-doc-fisc.vl-iss-it       = 0
               tt-it-doc-fisc.vl-issnt-it     = 0
               tt-it-doc-fisc.vl-issou-it     = 0
               tt-it-doc-fisc.aliquota-ipi    = 0
               tt-it-doc-fisc.cd-vin-ipi      = ""
               tt-it-doc-fisc.perc-red-ipi    = 0
               tt-it-doc-fisc.vl-bipi-it      = 0
               tt-it-doc-fisc.vl-ipi-dev      = 0
               tt-it-doc-fisc.vl-ipi-devol    = 0
               tt-it-doc-fisc.vl-ipi-it       = 0
               tt-it-doc-fisc.vl-ipint-it     = 0
               tt-it-doc-fisc.aliquota-icm    = 0
               tt-it-doc-fisc.aliquota-ISS    = 0
               tt-it-doc-fisc.vl-merc-liq     = tt-conhec.VrFreteAPagar
               tt-it-doc-fisc.vl-merc-sicm    = tt-conhec.VrFreteAPagar
               tt-it-doc-fisc.vl-tot-item     = tt-conhec.VrFreteAPagar
               tt-it-doc-fisc.vl-ipiou-it     = 0
               tt-it-doc-fisc.vl-ipint-it     = 0
               tt-it-doc-fisc.quantidade      = 1.
/*        IF AVAIL tt-impostos THEN   /*Leonam 30/07*/
            IF tt-it-doc-fisc.cod-estabel = "103" AND tt-impostos.vrimposto = 0 THEN 
                ASSIGN tt-it-doc-fisc.cd-trib-icm = 2.
            ELSE 
                ASSIGN tt-it-doc-fisc.cd-trib-icm = 1.
        ELSE     
            ASSIGN tt-it-doc-fisc.cd-trib-icm = 2.    */

        IF  AVAIL tt-impostos
        THEN DO:
            ASSIGN tt-it-doc-fisc.aliquota-icm = tt-impostos.pcaliquotaimposto.
            IF  tt-impostos.tptribicms = "00" /* Tributa */ 
            THEN DO: /*Leonam 30/07*/
              /*  ASSIGN tt-it-doc-fisc.cd-trib-icm  = IF  tt-it-doc-fisc.cod-estabel = "103" AND tt-impostos.vrimposto = 0 THEN 2 ELSE 1.
                */
                IF tt-it-doc-fisc.cd-trib-icm = 2 THEN
                   ASSIGN tt-it-doc-fisc.vl-icmsnt-it   = 0.
                ELSE
                   ASSIGN tt-it-doc-fisc.vl-icms-it   = IF  tt-it-doc-fisc.cod-estabel = "103" AND tt-doc-fiscal.dt-emis-doc < 10/01/2014 THEN 0 ELSE tt-impostos.vrimposto
                          tt-it-doc-fisc.vl-bicms-it  = IF  tt-it-doc-fisc.cod-estabel = "103" AND tt-doc-fiscal.dt-emis-doc < 10/01/2014 THEN 0 ELSE tt-impostos.vrbasecalimposto
                          tt-it-doc-fisc.vl-icmsou-it = IF  tt-it-doc-fisc.cod-estabel = "103" AND tt-doc-fiscal.dt-emis-doc < 10/01/2014 THEN tt-it-doc-fisc.vl-tot-item ELSE 0.
            END.
            ELSE
                IF  tt-impostos.tptribicms = "40" OR /* Isenta */ 
                    tt-impostos.tptribicms = "41"    /* NÆo Tributa */
                THEN DO: /*Leonam 30/07*/
                    ASSIGN /*tt-it-doc-fisc.cd-trib-icm  = 2*/
                           tt-it-doc-fisc.vl-icmsnt-it = tt-impostos.vrimposto.
                END.
                ELSE
                    IF  tt-impostos.tptribicms = "10" OR /* Subst. Tribut. */
                        tt-impostos.tptribicms = "51" OR /* Diferido       */
                        tt-impostos.tptribicms = "90"    /* Outros         */
                    THEN DO: /*Leonam 30/07*/
                       /* IF  tt-impostos.tptribicms = "51"
                        THEN
                            ASSIGN tt-it-doc-fisc.cd-trib-icm  = 5.

                        IF  tt-impostos.tptribicms = "90"
                        THEN
                            ASSIGN tt-it-doc-fisc.cd-trib-icm  = 3.*/

                        IF  tt-impostos.tptribicms = "90"    /* Outros         */ 
                        THEN
                            ASSIGN tt-it-doc-fisc.vl-icmsou-it = tt-impostos.vrimposto.
                        ELSE
                             ASSIGN tt-it-doc-fisc.vl-bicms-it = tt-impostos.vrimposto.
                    END.
        END. /* IF  AVAIL tt-impostos - ICMS */
        
        /*LEONAM Verifica informa‡äes de tributa‡Æo na natureza de opera‡Æo PIS*/ 
        if avail natur-oper then  tt-it-doc-fisc.cd-trib-pis = int(substr(natur-oper.char-1,86,1)).
        FIND FIRST tt-impostos NO-LOCK
            WHERE  tt-impostos.idnc      = tt-conhec.idnc 
              AND  tt-impostos.cdimposto = 54 /* PIS */ NO-ERROR.
        IF  AVAIL tt-impostos THEN DO:
            if tt-it-doc-fisc.cd-trib-pis          = 2 then do:
               assign tt-it-doc-fisc.val-base-calc-pis    = 0
                      tt-it-doc-fisc.val-pis              = 0
                      tt-it-doc-fisc.aliq-pis             = 0. /* Aliquota PIS */ 
            end.
            else do:
               ASSIGN tt-it-doc-fisc.val-base-calc-pis    = tt-impostos.vrbasecalimposto
                      tt-it-doc-fisc.val-pis              = tt-impostos.vrimposto.
/*                    tt-it-doc-fisc.aliq-pis             = tt-impostos.pcaliquotaimposto. /* Aliquota PIS */ */

               &IF "{&bf_dis_versao_ems}" >= "2.09" &THEN
                   ASSIGN tt-it-doc-fisc.aliq-pis             = tt-impostos.pcaliquotaimposto.
               &ELSE
                   ASSIGN SUBSTRING(tt-it-doc-fisc.char-2,22,8)  = string(tt-impostos.pcaliquotaimposto,'99.9999').
               &ENDIF
            end.  
        END.

        /*LEONAM Verifica informa‡äes de tributa‡Æo na natureza de opera‡Æo COFINS*/ 
        if avail natur-oper then  tt-it-doc-fisc.cd-trib-cofins= int(substr(natur-oper.char-1,87,1)).

        FIND FIRST tt-impostos NO-LOCK
            WHERE  tt-impostos.idnc      = tt-conhec.idnc 
              AND  tt-impostos.cdimposto = 64 /* COFINS */ NO-ERROR.
        IF  AVAIL tt-impostos THEN DO:
          if tt-it-doc-fisc.cd-trib-pis          = 2 then do:
             assign tt-it-doc-fisc.val-base-calc-cofins    = 0
                    tt-it-doc-fisc.val-cofins              = 0
                    tt-it-doc-fisc.aliq-cofins             = 0. /* Aliquota cofins*/ 
          end.
          else do:
            ASSIGN tt-it-doc-fisc.val-base-calc-cofins   = tt-impostos.vrbasecalimposto
                   tt-it-doc-fisc.val-cofins             = tt-impostos.vrimposto.
/*                    tt-it-doc-fisc.aliq-cofins            = tt-impostos.pcaliquotaimposto. /* Aliquota COFINS */ */

            &IF "{&bf_dis_versao_ems}" >= "2.09" &THEN
                ASSIGN tt-it-doc-fisc.aliq-cofins          = tt-impostos.pcaliquotaimposto.
            &ELSE
                ASSIGN SUBSTRING(tt-it-doc-fisc.char-2,30,8)  = string(tt-impostos.pcaliquotaimposto,'99.9999').
            &ENDIF
          end.  
        END.

        if lookup(TRIM(SUBSTR(tt-conhec.CdNaturezaOperacao,1,6)),"194994,194992,100000,100001") > 0 then do:
           assign tt-doc-fiscal.cod-observa  = 4.
        end. 
        /*LEONAM Verifica informa‡äes de tributa‡Æo na natureza de opera‡Æo ISS*/ 
        if avail natur-oper then  tt-it-doc-fisc.cd-trib-iss = natur-oper.cd-trib-iss.
        FIND FIRST tt-impostos NO-LOCK
            WHERE  tt-impostos.idnc      = tt-conhec.idnc 
              AND  tt-impostos.cdimposto = 8 /* ISS */ NO-ERROR.

        IF  AVAIL tt-impostos
        THEN DO:
            ASSIGN tt-it-doc-fisc.aliquota-iss = tt-impostos.pcaliquotaimposto
                   tt-it-doc-fisc.cod-servico  = 0.
            CASE tt-it-doc-fisc.cd-trib-iss:
                WHEN(1) THEN /*Tributado*/ do:
                    ASSIGN tt-it-doc-fisc.vl-iss-it  = tt-impostos.vrimposto
                           tt-it-doc-fisc.vl-biss-it = tt-impostos.vrbasecalimposto.
                           
                end.           
                WHEN(2) THEN /*Isento*/

                 if lookup(TRIM(SUBSTR(tt-conhec.CdNaturezaOperacao,1,6)),"194994,194992,100000,100001") > 0 then 

                    ASSIGN tt-it-doc-fisc.vl-issnt-it = 0
                           tt-it-doc-fisc.vl-iss-it  = 0
                           tt-it-doc-fisc.vl-biss-it = 0.
                  else  
                    ASSIGN tt-it-doc-fisc.vl-issnt-it = tt-impostos.vrimposto.
                WHEN(3) THEN /*Outros*/
                    ASSIGN tt-it-doc-fisc.vl-issou-it = tt-impostos.vrimposto
                           tt-it-doc-fisc.vl-bsubs-it = tt-impostos.vrbasecalimposto
                           tt-it-doc-fisc.vl-iss-it   = tt-impostos.vrimposto
                           tt-it-doc-fisc.vl-merc-liq = tt-impostos.vrbasecalimposto.
                WHEN(4) THEN
                    ASSIGN tt-it-doc-fisc.vl-issou-it = tt-impostos.vrbasecalimposto
                           tt-it-doc-fisc.vl-iss-it   = tt-impostos.vrimposto.
                WHEN(5) THEN
                    ASSIGN tt-it-doc-fisc.vl-issnt-it = tt-impostos.vrimposto.
                WHEN(6) THEN
                    ASSIGN tt-it-doc-fisc.vl-issou-it = tt-impostos.vrbasecalimposto
                           tt-it-doc-fisc.vl-iss-it   = tt-impostos.vrimposto.
            END CASE.
        END. /* IF  AVAIL tt-impostos - ISS */

        CREATE it-doc-fisc.
        BUFFER-COPY tt-it-doc-fisc TO it-doc-fisc.
        RELEASE it-doc-fisc.

        RUN totalizarDocFiscal IN THIS-PROCEDURE (INPUT rw-documento).

        RUN criarNFAdicional.
    
        /***** FIM CRIA ITEM *****/
    END. /* DO  TRANS ON ERROR UNDO, LEAVE: */

END PROCEDURE.


PROCEDURE totalizarDocFiscal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Utilizar apenas para integra‡Æo com EMS 2.04 ou superiores      
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prw-doc-fiscal AS ROWID NO-UNDO.

    FIND doc-fiscal EXCLUSIVE-LOCK
        WHERE ROWID(doc-fiscal) = prw-doc-fiscal NO-ERROR.

    IF AVAIL doc-fiscal THEN DO:

        IF doc-fiscal.dt-docto <> tt-param.dt-registro THEN DO:

            ASSIGN doc-fiscal.dt-docto = tt-param.dt-registro.

            FOR EACH it-doc-fisc OF doc-fiscal EXCLUSIVE-LOCK:
                IF it-doc-fisc.dt-docto <> tt-param.dt-registro THEN
                    ASSIGN it-doc-fisc.dt-docto = tt-param.dt-registro.
            END. /* FOR EACH it-doc-fisc OF doc-fiscal EXCLUSIVE-LOCK: */

        END. /* IF doc-fiscal.dt-docto <> tt-it-doc-fisc.dt-docto THEN DO: */

    END.

    FOR EACH tt-it-doc-fisc EXCLUSIVE-LOCK:
         accumulate tt-it-doc-fisc.vl-bipi-it   (total)
                    tt-it-doc-fisc.vl-ipi-it    (total)
                    tt-it-doc-fisc.vl-ipint-it  (total)
                    tt-it-doc-fisc.vl-ipiou-it  (total)
                    tt-it-doc-fisc.vl-ipint-it  (total)
                    tt-it-doc-fisc.vl-bsubs-it  (total)
                    tt-it-doc-fisc.vl-icmsub-it (total)
                    tt-it-doc-fisc.vl-biss-it   (total)
                    tt-it-doc-fisc.vl-iss-it    (total)
                    tt-it-doc-fisc.vl-tot-item  (total)
                    tt-it-doc-fisc.vl-bicms-it  (total)
                    tt-it-doc-fisc.vl-icmsou-it (total)
                    tt-it-doc-fisc.vl-icmsnt-it (total)
                    tt-it-doc-fisc.vl-icms-it   (total)
                    tt-it-doc-fisc.vl-ipi-devol (total).
    END.

    ASSIGN doc-fiscal.vl-bipi      = accum total tt-it-doc-fisc.vl-bipi-it
           doc-fiscal.vl-ipi       = accum total tt-it-doc-fisc.vl-ipi-it
           doc-fiscal.vl-ipint     = accum total tt-it-doc-fisc.vl-ipint-it
           doc-fiscal.vl-ipiou     = accum total tt-it-doc-fisc.vl-ipiou-it
           doc-fiscal.vl-ipint     = accum total tt-it-doc-fisc.vl-ipint-it
           doc-fiscal.vl-bsubs     = accum total tt-it-doc-fisc.vl-bsubs-it
           doc-fiscal.vl-icmsub    = accum total tt-it-doc-fisc.vl-icmsub-it
           doc-fiscal.vl-cont-doc  = accum total tt-it-doc-fisc.vl-tot-item
           doc-fiscal.vl-biss      = accum total tt-it-doc-fisc.vl-biss-it
           doc-fiscal.vl-iss       = accum total tt-it-doc-fisc.vl-iss-it
           doc-fiscal.vl-bicms     = IF   doc-fiscal.cod-estabel = "103" AND tt-doc-fiscal.dt-emis-doc < 10/01/2014 THEN 0
                                     ELSE accum total tt-it-doc-fisc.vl-bicms-it
           doc-fiscal.vl-icmsou    = IF   doc-fiscal.cod-estabel = "103" AND tt-doc-fiscal.dt-emis-doc < 10/01/2014 THEN doc-fiscal.vl-cont-doc
                                     ELSE accum total tt-it-doc-fisc.vl-icmsou-it 
           doc-fiscal.vl-icmsnt    = accum total tt-it-doc-fisc.vl-icmsnt-it
           doc-fiscal.vl-icms      = IF   doc-fiscal.cod-estabel = "103" AND tt-doc-fiscal.dt-emis-doc < 10/01/2014 THEN 0 
                                     ELSE accum total tt-it-doc-fisc.vl-icms-it    
           doc-fiscal.vl-ipi-devol = accum total tt-it-doc-fisc.vl-ipi-devol
           doc-fiscal.user-alt     = "GKO - via " + c-seg-usuario
           doc-fiscal.dt-ult-alt   = today.

    IF  doc-fiscal.vl-bicms <> 0 
    THEN
        ASSIGN doc-fiscal.vl-pis       = ROUND(doc-fiscal.vl-bicms * v-val-aliq-pis    / 100,2)
               doc-fiscal.vl-finsocial = ROUND(doc-fiscal.vl-bicms * v-val-aliq-cofins / 100,2).
    RELEASE doc-fiscal.

    RETURN "OK":U.
    
END PROCEDURE.


PROCEDURE criarNFAdicional :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* *** Cria»’o da Nota Fiscal Adicional - nota-fisc-adic *** */
    
    IF  NOT VALID-HANDLE(h-bodi515) 
    THEN
        RUN dibo/bodi515.p PERSISTENT SET h-bodi515.

    RUN openQueryStatic IN h-bodi515 (INPUT "Main":U).

    RUN goToKey         IN h-bodi515 (INPUT tt-doc-fiscal.cod-estabel,
                                      INPUT tt-doc-fiscal.serie,      
                                      INPUT tt-doc-fiscal.nr-doc-fis, 
                                      INPUT tt-doc-fiscal.cod-emitente,
                                      INPUT tt-doc-fiscal.nat-operacao,
                                      INPUT 13,
                                      INPUT 1).
    IF RETURN-VALUE = "NOK":U 
    THEN DO:
        EMPTY TEMP-TABLE tt-nota-fisc-adc.

        CREATE tt-nota-fisc-adc.
        ASSIGN tt-nota-fisc-adc.cod-estab                = tt-doc-fiscal.cod-estabel
               tt-nota-fisc-adc.cod-serie                = tt-doc-fiscal.serie      
               tt-nota-fisc-adc.cod-nota-fisc            = tt-doc-fiscal.nr-doc-fis   
               tt-nota-fisc-adc.cdn-emitente             = tt-doc-fiscal.cod-emitente
               tt-nota-fisc-adc.cod-natur-operac         = tt-doc-fiscal.nat-operacao
               tt-nota-fisc-adc.idi-tip-dado             = 13
               OVERLAY(tt-nota-fisc-adc.cod-livre-2,9,2) = "00".

        RUN emptyRowErrors   IN h-bodi515.
        RUN newRecord        IN h-bodi515.
        RUN setRecord        IN h-bodi515 (INPUT TABLE tt-nota-fisc-adc).
        RUN createRecord     IN h-bodi515.

        IF  RETURN-VALUE = "NOK":U 
        THEN DO:
            RUN getRowErrors IN h-bodi515 (OUTPUT TABLE rowErrors).

            RUN getRowErrors IN h-bodi515 (OUTPUT TABLE RowErrors).
            IF  CAN-FIND(FIRST RowErrors) 
            THEN DO:
                FOR EACH rowerrors:
                    CREATE tt-log-gko.
                    ASSIGN tt-log-gko.ind-tipo-integracao    = 1
                           tt-log-gko.log-imp-erro           = YES
                           tt-log-gko.des-erro-imp           = rowerrors.Errorhelp
                                                             + CHR(13) 
                                                             + "Est....: " + tt-doc-fiscal.cod-estabel          + CHR(13)
                                                             + "Fornec.: " + STRING(tt-doc-fiscal.cod-emitente) + CHR(13)
                                                             + "S‚rie..: " + tt-doc-fiscal.serie                + CHR(13)
                                                             + "Nota...: " + tt-doc-fiscal.nr-doc-fis           + CHR(13)
                                                             + "Natureza:" + tt-doc-fiscal.nat-operacao         + CHR(13)
                           tt-log-gko.nom-arquivo-integracao = tt-conhec.DesArquivoOrigem.
                END.
                IF  CAN-FIND(FIRST rowErrors
                         WHERE rowErrors.errorSubType = "ERROR":U) THEN
                    RETURN "NOK":U.
            END.
        END.
    END. /* IF RETURN-VALUE = "NOK":U THEN DO: */

    IF  VALID-HANDLE(h-bodi515) 
    THEN DO:
        DELETE PROCEDURE h-bodi515.
        ASSIGN h-bodi515 = ?.
    END.
    
    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-limpa-handle:

    IF VALID-HANDLE(h-boin046na) THEN
        RUN destroy IN h-boin046na.
    
    IF VALID-HANDLE(h-bodi144) THEN
        RUN destroy IN h-bodi144.
    
    RETURN "OK":U.

END PROCEDURE.

