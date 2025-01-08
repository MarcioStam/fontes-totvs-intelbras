/*******************************************************************************************************************/
/* Programa: esesbapi004-benef - Retornar benef°cios do canal                                                      */
/* Objetivo: Centralizar as busca dos benef°cios do canal, e tambÇm seus percentuais, unificando a pesquisa de     */ 
/*           v†rias mensagens em uma £nica API. Retornar† uma temp-table mais completa com tudo que Ç preciso      */ 
/*            para calcula ou provisionar as contas correntes.                                                     */ 
/* Autor...: Roger Marcelino Bruhn                                                                                 */ 
/* Data....: 25/06/2014                                                                                            */
/*                                                                                                                 */
/* ParÉmetros Entrada:  p-buscar-param-globais      -> Se dever† trazer na tt-beneficio o % do benf°cio            */
/*                                                    que Ç obtido atravÇs do acesso de outra mensagem             */ 
/*                      p-buscar-param-financeiros  -> Se dever†r trazer na tt-beneficio os parametros financeiros */
/*                                                                                                                 */
/*                      p-unid-neg                  -> Caso queira buscar apenas uma unidade de neg¢cio, ou        */
/*                                                    passar ? para trazer sempre todas as unidades de neg¢cio     */      
/*                      tt-canal                    -> Temp-table que poder† conter 1 ou N canais                  */   
/*                                                                                                                 */
/* ParÉmetros Sa°da..: tt-erros      -> indica que todas as mensagens internas foram executadas com sucesso,       */   
/*                                      e a temp-table de retorno princiapal est† correta para utilizaá∆o          */   
/*                     tt-beneficios -> retorna os benef°cios consolidades, com as categorias, percentuais para    */
/*                                      calculo e provisao                                                         */
/*                                                                                                                 */
/* RETURN-VALUE......: OK, se conseguiu carretar todos os benef°cios sem erro. NOK para qualquer erro ou falta de  */
/*                     informaá‰es a partir das mensagens chamadas                                                 */
/*******************************************************************************************************************/

{esp/esb/out/msg0111.i} /* Para busca dos parÉmetros globais do CRM */

FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT) FORWARD.

DEF TEMP-TABLE tt-canal NO-UNDO
    FIELD canal         AS INTEGER
    FIELD guid-canal    AS CHAR FORMAT "X(36)"
    FIELD guid-class    AS CHAR FORMAT "X(36)"
        INDEX idx-canal IS PRIMARY UNIQUE canal.
    
DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

/* Temp-table tt-beneficio */
{esp/esb/esesbapi004-benef.i}

DEF BUFFER b-tt-beneficio FOR tt-beneficio.

DEFINE VARIABLE i-status    AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-categoria AS CHARACTER NO-UNDO.
DEFINE VARIABLE de-vl-glob  AS DECIMAL     NO-UNDO.

/* PAR∂METROS ENTRADA/SA÷DA*/
DEF INPUT  PARAM p-provisionamento          AS LOG  NO-UNDO.
DEF INPUT  PARAM p-buscar-param-globais     AS LOG  NO-UNDO.
DEF INPUT  PARAM p-buscar-param-financeiros AS LOG  NO-UNDO.
DEF INPUT  PARAM p-unid-neg                 AS CHAR NO-UNDO.
DEF INPUT  PARAM p-tipo-beneficio           AS INT  NO-UNDO.
DEF INPUT  PARAM TABLE FOR tt-canal.
DEF OUTPUT PARAM TABLE FOR tt-erro.
DEF OUTPUT PARAM TABLE FOR tt-beneficio.


/* Procedure principal do programa */
RUN pi-retorna-beneficios.

IF  RETURN-VALUE <> "OK" THEN
    RETURN "NOK".

RETURN "OK".
/* FIM */

PROCEDURE pi-retorna-beneficios:

    IF  NOT CAN-FIND (FIRST tt-canal) THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "Nenhum canal foi enviado para retorno de benef°cios",
                                            INPUT "").
        RETURN "NOK".
    END.
    
    FOR EACH tt-canal:

        FOR FIRST int-emitente 
            WHERE int-emitente.cod-emitente = tt-canal.canal NO-LOCK:
        END.
        FOR FIRST int-class-canal 
            WHERE int-class-canal.codigo-classificacao = tt-canal.guid-class:
        END.

        IF  NOT AVAIL int-class-canal THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                INPUT "Benef°cios do Canal - Classificaá∆o Canal inexistente no EMS." , 
                                                INPUT "C¢digo Canal EMS...: " + string(tt-canal.canal) + CHR(10) + 
                                                      "C¢digo Canal CRM...: " + tt-canal.guid-canal    + CHR(10) +  
                                                      "Classificaá∆o CRM..: " + tt-canal.guid-class).
            NEXT.
        END.

        FOR EACH int-benef-canal NO-LOCK
            WHERE int-benef-canal.CodigoConta = tt-canal.guid-canal
            BY int-benef-canal.BeneficioCodigo
            BY int-benef-canal.CodigoUnidadeNegocio:

            /* S¢ busca e os percentuais de : */
            IF  int-benef-canal.BeneficioCodigo <> 37 /* 37 - REBATE            */
            AND int-benef-canal.BeneficioCodigo <> 66 /* 66 - REBATE  P‡S-VENDA */
            AND int-benef-canal.BeneficioCodigo <> 21 /* 21 - VMC               */
            THEN
                NEXT.

            /*Quando for informado um beneficio espec°fico*/
            IF  p-tipo-beneficio <> ? 
            AND int-benef-canal.BeneficioCodigo <> p-tipo-beneficio THEN
                NEXT.

            /* STATUS DO BENEF÷CIO ê CONVERTIDO APENAS AQUI */
            CASE int-benef-canal.NomeStatusBeneficio:
                WHEN "ATIVO"     THEN ASSIGN i-status = 1.
                WHEN "BLOQUEADO" THEN ASSIGN i-status = 2.
                WHEN "SUSPENSO"  THEN ASSIGN i-status = 3.
                OTHERWISE ASSIGN i-status = ?.
            END CASE.

            /* CASO E STATUS N«O TENHA SIDO INFORMADO NO CRM, ASSUMIMOS QUE ESTµ SUSPENSO */
            IF  i-status = ? THEN
                ASSIGN i-status = 3.

            /* TIPO DA CATEGORIA, INDICANDO SE ê OURO/BRATA/BRONZE/DISTRIBUIDOR */
            CASE int-benef-canal.CategoriaCodigo:
                WHEN 1    THEN ASSIGN c-categoria = "OURO".
                WHEN 2    THEN ASSIGN c-categoria = "PRATA".
                WHEN 3    THEN ASSIGN c-categoria = "BRONZE".
                WHEN 5    THEN ASSIGN c-categoria = "DISTRIBUIDOR".
                WHEN 14   THEN ASSIGN c-categoria = "REVENDA SOLUCOES".
                WHEN 15   THEN ASSIGN c-categoria = "PROVEDORES".
                WHEN 1001 THEN ASSIGN c-categoria = "ESPECIALIZADA INCENDIO".
                WHEN 100  THEN ASSIGN c-categoria = "ATACADO DISTRIBUIDOR".
                OTHERWISE ASSIGN c-categoria = ?.
            END CASE.

            IF  c-categoria = ? THEN DO:
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                    INPUT "Benef°cios do Canal - Categoria do benef°cio n∆o existe no EMS. " ,
                                                    INPUT "C¢digo Canal EMS....: " + string(tt-canal.canal)                          + CHR(10) +
                                                          "C¢digo Canal CRM....: " + tt-canal.guid-canal                             + CHR(10) +
                                                          "Cod Categoria CRM...: " + string(int-benef-canal.CategoriaCodigo)  + CHR(10) +  
                                                          "Nome Categoria......: " + int-benef-canal.NomeCategoria).
                NEXT.
            END.
            /* Verifica Duplicidade */
            IF  CAN-FIND (FIRST b-tt-beneficio
                            WHERE b-tt-beneficio.canal               = tt-canal.canal 
                              AND b-tt-beneficio.unid-neg            = int-benef-canal.CodigoUnidadeNegocio 
                              AND b-tt-beneficio.tipo-beneficio      = int-benef-canal.BeneficioCodigo) THEN DO: 
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                    INPUT "Benef°cios do Canal - Benef°cio existe em duplicidade no CRM. " ,
                                                    INPUT "C¢digo Canal EMS....: " + string(tt-canal.canal)                          + CHR(10) +
                                                          "C¢digo Canal CRM....: " + tt-canal.guid-canal                             + CHR(10) +
                                                          "Cod Categoria CRM...: " + string(int-benef-canal.CategoriaCodigo)  + CHR(10) +  
                                                          "Nome Categoria......: " + int-benef-canal.NomeCategoria).
                NEXT.
            END.

            CREATE tt-beneficio.
            ASSIGN tt-beneficio.canal                = tt-canal.canal             
                   tt-beneficio.guid-canal           = tt-canal.guid-canal        
                   tt-beneficio.unid-neg             = int-benef-canal.CodigoUnidadeNegocio
                   tt-beneficio.guid-categoria       = int-benef-canal.CodigoCategoria    
                   tt-beneficio.guid-beneficio       = int-benef-canal.CodigoBeneficio
                   tt-beneficio.guid-beneficio-canal = int-benef-canal.CodigoBeneficioCanal
                   tt-beneficio.tipo-beneficio       = int-benef-canal.BeneficioCodigo
                   tt-beneficio.tipo-categoria       = c-categoria
                   tt-beneficio.guid-class           = tt-canal.guid-class 
                   tt-beneficio.nome-class           = int-class-canal.nome
                   tt-beneficio.exclusividade        = int-emitente.exclusividade
                   tt-beneficio.id-status            = i-status         
                   tt-beneficio.calcula-verba        = int-benef-canal.CalcularVerba.

            
            /*
            IF  tt-beneficio.unid-neg  = "ADM" THEN
                NEXT.
            */
            /*----------------------------------------------------------------------------------------------------------------------------*/
            /*                                        BUSCA DO PERCENTUAL GLOBAL DO BENEF÷CIO                                             */
            /*----------------------------------------------------------------------------------------------------------------------------*/
            IF  p-buscar-param-globais AND tt-beneficio.unid-neg <> "ADM"  THEN DO: /*n∆o precisa % global quando for apenas provis∆o */
                RUN pi-Buscar-Parametros-Globais (INPUT  tt-canal.guid-class                        , /* GUID */
                                                  INPUT  int-benef-canal.CodigoCategoria     , /* GUID */
                                                  INPUT  int-benef-canal.BeneficioCodigo     , /* 21-VMC, 22-STOCK ROTATION, 37-REBATE, 66-REBATE P‡S-VENDA */
                                                  INPUT  int-benef-canal.CodigoUnidadeNegocio, /* C‡DIGO DO EMS MESMO */
                                                  INPUT  int-benef-canal.CodigoBeneficio     , /* GUID */
                                                  OUTPUT de-vl-glob).
                IF  RETURN-VALUE <> "OK" THEN
                    NEXT.

                ASSIGN tt-beneficio.perc-global = de-vl-glob.
            END.

            /*----------------------------------------------------------------------------------------------------------------------------*/
            /*                                Busca dados Financeiros e % de provisionameto da MSG0142)                                   */
            /*----------------------------------------------------------------------------------------------------------------------------*/
            IF  p-buscar-param-financeiros THEN DO:
                RUN pi-busca-parametros-beneficios.
                IF  RETURN-VALUE <> "OK" THEN
                    NEXT.
            END.

        END.
                                                 
    END.

    IF  NOT CAN-FIND (FIRST tt-beneficio) THEN
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "Nenhum benef°cio processado.",
                                            INPUT "A busca de benef°cios para o(s) canal(is) n∆o retornou resultados.").
    RETURN "OK".

END.


/*---------------------------------------*/
/*   MSG0111 - OBTER_PARAMETRO_GLOBAL    */
/*---------------------------------------*/
PROCEDURE pi-Buscar-Parametros-Globais:

    DEFINE  INPUT  PARAM p-guid-classificacao   AS CHAR NO-UNDO.
    DEFINE  INPUT  PARAM p-guid-Categoria       AS CHAR NO-UNDO.
    DEFINE  INPUT  PARAM p-TipoParametroGlobal  AS INT  NO-UNDO.
    DEFINE  INPUT  PARAM p-CodigoUnidadeNegocio AS CHAR NO-UNDO.
    DEFINE  INPUT  PARAM p-guid-beneficio       AS CHAR NO-UNDO.
    DEFINE  OUTPUT PARAM p-valor-param          AS DEC  NO-UNDO.

    /* Stock Backup e Show Room */
    IF  int-benef-canal.BeneficioCodigo = 15
    OR  int-benef-canal.BeneficioCodigo = 04 THEN 
        RETURN "OK".

    FIND LAST int-benef-canal-perc NO-LOCK
        WHERE int-benef-canal-perc.CodigoClassificacao  = p-guid-classificacao
          AND int-benef-canal-perc.CodigoCategoria      = p-guid-Categoria
          AND int-benef-canal-perc.CodigoBeneficio      = p-guid-beneficio
          AND int-benef-canal-perc.TipoParametroGlobal  = p-TipoParametroGlobal
          AND int-benef-canal-perc.CodigoUnidadeNegocio = p-CodigoUnidadeNegocio NO-ERROR.

    IF  AVAIL int-benef-canal-perc THEN DO:
        IF  dec(int-benef-canal-perc.ValorParametroGlobal) = 0 
        AND p-TipoParametroGlobal <> 66 
        AND tt-canal.canal <> 202749 THEN DO: /* andrey */
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                INPUT "PAR∂METRO GLOBAL - Retornou % GLOBAL zerado. " ,
                                                INPUT "Canal EMS..........: " + string(tt-canal.canal)        + CHR(10) +
                                                      "C¢digo Canal CRM...: " + tt-canal.guid-canal           + CHR(10) +
                                                      "Classificacao CRM..: " + p-guid-classificacao          + CHR(10) +
                                                      "Categoria CRM......: " + p-guid-Categoria              + CHR(10) +
                                                      "Unidade de Neg¢cio.: " + p-CodigoUnidadeNegocio        + CHR(10) +
                                                      "Beneficio CRM......: " + p-guid-Beneficio              + CHR(10) +
                                                      "Tipo ParÉmetro.....: " + string(p-TipoParametroGlobal)).
            RETURN "NOK".
        END.

        ASSIGN p-valor-param = dec(int-benef-canal-perc.ValorParametroGlobal).

    END.
    ELSE DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "PAR∂METRO GLOBAL - N∆o encontrado parÉmetro global para: " ,
                                            INPUT "Canal EMS..........: " + string(tt-canal.canal)        + CHR(10) +
                                                  "C¢digo Canal CRM...: " + tt-canal.guid-canal           + CHR(10) +
                                                  "Classificacao CRM..: " + p-guid-classificacao          + CHR(10) +
                                                  "Categoria CRM......: " + p-guid-Categoria              + CHR(10) +
                                                  "Unidade de Neg¢cio.: " + p-CodigoUnidadeNegocio        + CHR(10) +
                                                  "Beneficio CRM......: " + p-guid-Beneficio              + CHR(10) +
                                                  "Tipo ParÉmetro.....: " + string(p-TipoParametroGlobal) ).
        RETURN "NOK".
    END.

    RETURN "OK".
END.


/*-----------------------------------------*/
/*  MSG0142  - LISTAR_PARAMETROS_BENEFICIO */
/*-----------------------------------------*/
PROCEDURE pi-busca-parametros-beneficios:
    
    /* N«O PRECISA BUSCAR PAR∂METROS PARA O SHOW ROOM E ESTOCK BACKUP andrey */
    IF  int-benef-canal.BeneficioCodigo = 15
    OR  int-benef-canal.BeneficioCodigo = 04 THEN 
        RETURN "OK".

    FOR FIRST int-benef-parametro NO-LOCK
         WHERE int-benef-parametro.CodigoBeneficio      = tt-beneficio.guid-beneficio
           AND int-benef-parametro.CodigoUnidadeNegocio = tt-beneficio.unid-neg:

        IF  tt-canal.canal = 416 THEN
            MESSAGE "for each - int-benef-parametro.CodigoUnidadeNegocio " int-benef-parametro.CodigoUnidadeNegocio VIEW-AS ALERT-BOX.

        ASSIGN tt-beneficio.conta          = int-benef-parametro.ContaContabil                
               tt-beneficio.centro-custo   = int-benef-parametro.CentroCusto                  
               tt-beneficio.cod-estabel    = string(int-benef-parametro.CodigoEstabelecimento)
               tt-beneficio.cod-especie    = int-benef-parametro.EspecieDocumento             
               tt-beneficio.tipo-fluxo     = int-benef-parametro.TipoFluxoFinanceiro          
               tt-beneficio.perc-custo     = int-benef-parametro.PercentualCusto              
               tt-beneficio.perc-prov-meta = int-benef-parametro.PercentualAtingimentoMeta.   

    END.
        
    IF  tt-canal.canal = 416 THEN
        MESSAGE "pi-busca-parametros-beneficios - tt-beneficio.cod-estabel " tt-beneficio.cod-estabel skip
                "tt-beneficio.unid-neg " tt-beneficio.unid-neg skip
                "tt-beneficio.tipo-beneficio " tt-beneficio.tipo-beneficio
                VIEW-AS ALERT-BOX.

    IF  NOT CAN-FIND (FIRST int-benef-parametro) THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "PAR∂METRO BENEF÷CIO. N∆o existem parÉmetros cadastrados para este benef°cio. " ,
                                            INPUT "Canal EMS..........: " + string(tt-canal.canal)                                   + CHR(10) +
                                                  "C¢digo Canal CRM...: " + tt-canal.guid-canal                                      + CHR(10) +
                                                  "Benef°cio CRM......: " + string(tt-beneficio.guid-beneficio)                      + CHR(10) +         
                                                  "Nome Benef°cio.....: " + fn-retorna-nome-beneficio (tt-beneficio.tipo-beneficio)).
                                                  
        RETURN "NOK".
    END.

    RETURN "OK".
END.


PROCEDURE pi-cria-erro:

    DEFINE INPUT PARAM p-erro     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM p-mensagem AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-ajuda    AS CHAR NO-UNDO.

    CREATE tt-erro.
    ASSIGN tt-erro.codigo   = p-erro
           tt-erro.mensagem = p-mensagem
           tt-erro.ajuda    = p-ajuda.

END.

FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT):
    
    CASE p-beneficio:
        WHEN 21 THEN RETURN "VMC".
        WHEN 22 THEN RETURN "STOCK ROTATION".
        WHEN 37 THEN RETURN "REBATE".
        WHEN 66 THEN RETURN "REBATE P‡S-VENDA".
    END CASE.

    RETURN "".
END FUNCTION.

