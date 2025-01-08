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

DEFINE temp-table msg0141r-beneficioItem no-undo xml-node-name 'BeneficioItem'
    FIELD idm                         AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoBeneficioCanal        AS CHAR
    FIELD NomeBeneficioCanal          AS CHAR
    FIELD CodigoBeneficio             AS CHAR 
    FIELD BeneficioCodigo             AS INTEGER
    FIELD NomeBeneficio               AS CHAR
    FIELD CodigoCategoria             AS CHAR
    FIELD CategoriaCodigo             AS INTEGER
    FIELD NomeCategoria               AS CHAR
    FIELD CodigoUnidadeNegocio        AS CHAR
    FIELD NomeUnidadeNegocio          AS CHAR 
    FIELD VerbaCalculada              AS DEC
    FIELD VerbaPeriodoAnterior        AS DEC
    FIELD VerbaTotal                  AS DEC
    FIELD VerbaEmpenhada              AS DEC
    FIELD VerbaReembolsada            AS DEC
    FIELD VerbaCancelada              AS DEC
    FIELD VerbaAjustada               AS DEC
    FIELD VerbaDisponivel             AS DEC
    FIELD CodigoStatusBeneficio       AS CHAR
    FIELD NomeStatusBeneficio         AS CHAR
    FIELD CalculaVerba                AS LOGICAL
    FIELD AcumulaVerba                AS LOGICAL
    FIELD PassivelSolicitacao         AS LOGICAL
    FIELD PossuiControleContaCorrente AS INTEGER.
    
DEF TEMP-TABLE tt-canal NO-UNDO
    FIELD canal         AS INTEGER
    FIELD guid-canal    AS CHAR FORMAT "X(36)"
    FIELD guid-class    AS CHAR FORMAT "X(36)"
        INDEX idx-canal IS PRIMARY UNIQUE canal.
    
DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

DEF TEMP-TABLE tt-param-global NO-UNDO
    FIELD unid-neg            AS CHAR FORMAT "!!!!"
    FIELD guid-class          AS CHAR FORMAT "X(15)"
    FIELD guid-categoria      AS CHAR FORMAT "X(15)"
    FIELD guid-beneficio      AS CHAR
    FIELD tipo-beneficio      AS INTEGER  /* 21-VMC, 22-Stock Rotation, 37-Rebate, 66-Rebate p¢s-venda */
    FIELD perc-global         AS DEC
        INDEX idx-vmc-rebate IS PRIMARY UNIQUE
                unid-neg         
                guid-class
                guid-categoria  
                guid-beneficio
                tipo-beneficio.

/*ESSA RETORNA DA MESNAGEM 142 - PAR∂METROS BENEF÷CIOS CANAL*/
DEFINE temp-table msg0142r-ParametroBeneficioItem no-undo xml-node-name 'ParametroBeneficioItem'
    FIELD idm                       AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoUnidadeNegocio      AS CHAR 
    FIELD CodigoEstabelecimento     AS INT
    FIELD TipoFluxoFinanceiro       AS CHAR
    FIELD EspecieDocumento          AS CHAR
    FIELD ContaContabil             AS CHAR
    FIELD CentroCusto               AS CHAR
    FIELD PercentualAtingimentoMeta AS DEC
    FIELD PercentualCusto           AS DEC.
   
/* Temp-table tt-beneficio */
{esp/esb/esesbapi004-benef.i}

DEF BUFFER b-tt-beneficio FOR tt-beneficio.

DEF TEMP-TABLE tt-param-msg0142 NO-UNDO
    FIELD tipo-beneficio AS INTEGER
    FIELD unid-neg       AS CHAR FORMAT "!!!!"
    FIELD conta          AS CHAR FORMAT "X(20)"
    FIELD centro-custo   AS CHAR FORMAT "X(20)"
    FIELD cod-estabel    AS CHAR FORMAT "X(5)"
    FIELD cod-especie    AS CHAR
    FIELD tipo-fluxo     AS CHAR
    FIELD perc-custo     AS DEC
    FIELD perc-prov-meta AS DEC
    INDEX idx-primary IS UNIQUE PRIMARY 
            tipo-beneficio
            unid-neg.

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

DEF VAR h-acomp AS HANDLE NO-UNDO.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                      

RUN pi-inicializar IN h-acomp (INPUT "Buscando do CRM os benef°cios dos canais...").


/* Procedure principal do programa */
RUN pi-retorna-beneficios.

IF  RETURN-VALUE <> "OK" THEN DO:
    RUN pi-finalizar IN h-acomp.
    RETURN "NOK".
END.

RUN pi-finalizar IN h-acomp.

RETURN "OK".
/* FIM */

PROCEDURE pi-retorna-beneficios:

    IF  NOT CAN-FIND (FIRST tt-canal) THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "Nenhum canal foi enviado para retorno de benef°cios",
                                            INPUT "").
        RETURN "NOK".
    END.
    
    DEF VAR i-cont AS INTEGER NO-UNDO.
    DEF VAR i-tot  AS INTEGER NO-UNDO.
    FOR EACH tt-canal:
        i-tot = i-tot + 1.
    END.

    FOR EACH tt-canal:

        ASSIGN i-cont = i-cont + 1.
        RUN pi-inicializar IN h-acomp ("Buscando Benef. Canal: " + string(i-cont) + " de " + string(i-tot) ).  

        FOR FIRST int-emitente FIELD (exclusividade)
            WHERE int-emitente.cod-emitente = tt-canal.canal NO-LOCK:
        END.
        FOR FIRST int-class-canal FIELDS (nome)
            WHERE int-class-canal.codigo-classificacao = tt-canal.guid-class:
        END.

        IF  NOT AVAIL int-class-canal THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                INPUT "MSG0141-LISTAR_BENEFICIO_CANAL - Classificaá∆o Canal inexistente no EMS." , 
                                                INPUT "C¢digo Canal EMS...: " + string(tt-canal.canal) + CHR(10) + 
                                                      "C¢digo Canal CRM...: " + tt-canal.guid-canal    + CHR(10) +  
                                                      "Classificaá∆o CRM..: " + tt-canal.guid-class).
            NEXT.
        END.

        EMPTY TEMP-TABLE  msg0141r-beneficioItem. 
        EMPTY TEMP-TABLE  resultado. 

        RUN esp/esb/out/msg0141.p (INPUT  tt-canal.guid-canal, /* Canal */   
                                   INPUT  p-unid-neg,          /* ? Trazer todas as unidades de neg¢cio, ou passar a unidade caso queira trazer apenas uma UNIDADE*/
                                   INPUT  ?,                   /*Buscar apenas os Beneficios q possuem controle de conta corrente (yes,no,?)*/
                                   OUTPUT TABLE resultado,                               
                                   OUTPUT TABLE msg0141r-beneficioItem).      
        

        FIND FIRST resultado NO-ERROR.

        IF  AVAIL resultado  THEN DO:
            IF  NOT resultado.sucesso THEN DO:
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                    INPUT "MSG0141-LISTAR_BENEFICIO_CANAL - n∆o retornou Benef°cios para o Canal." , 
                                                    INPUT "C¢digo Canal EMS...: " + string(tt-canal.canal) + CHR(10) + 
                                                          "C¢digo Canal CRM...: " + tt-canal.guid-canal    + CHR(10) +  
                                                          "Erro Barramento....: " + string(resultado.CodigoErro)  + " - " + resultado.mensagem  ).
                NEXT.
            END.
            ELSE
                IF  NOT CAN-FIND (FIRST msg0141r-beneficioItem) THEN DO:
                    RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                        INPUT "MSG0141-LISTAR_BENEFICIO_CANAL - n∆o retornou Benef°cios para o Canal." , 
                                                        INPUT "C¢digo Canal EMS...: " + string(tt-canal.canal)       + CHR(10) + 
                                                              "C¢digo Canal CRM...: " + tt-canal.guid-canal          + CHR(10) +  
                                                              "Sucesso............: " + string(resultado.sucesso)    + CHR(10) +  
                                                              "Erro Barramento....: " + string(resultado.CodigoErro) + " - " + resultado.mensagem  ).
                    NEXT.
                END.
        END.
        ELSE DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                INPUT "MSG0141-LISTAR_BENEFICIO_CANAL n∆o processada. " ,
                                                INPUT "C¢digo Canal EMS...: " + string(tt-canal.canal) + CHR(10) + 
                                                      "C¢digo Canal CRM...: " + tt-canal.guid-canal    + CHR(10) +
                                                      "Erro Barramento....: N∆o foi poss°vel interpretar o retorno do barramento" ).
            NEXT.
        END.

        IF  NOT CAN-FIND (FIRST msg0141r-beneficioItem) THEN
            NEXT.

        FOR EACH msg0141r-beneficioItem
            BY msg0141r-beneficioItem.BeneficioCodigo
            BY msg0141r-beneficioItem.CodigoUnidadeNegocio:

            /* S¢ busca e os percentuais de : */
            IF  msg0141r-beneficioItem.BeneficioCodigo <> 22 /* 22 - STOCK ROTATION    */
            AND msg0141r-beneficioItem.BeneficioCodigo <> 37 /* 37 - REBATE            */
            AND msg0141r-beneficioItem.BeneficioCodigo <> 66 /* 66 - REBATE  P‡S-VENDA */
            AND msg0141r-beneficioItem.BeneficioCodigo <> 21 /* 21 - VMC               */
            AND msg0141r-beneficioItem.BeneficioCodigo <> 15 /* 15 - SHOWROOM          */
            AND msg0141r-beneficioItem.BeneficioCodigo <> 08 /* 08 - PRICE PROTECTION  */
            AND msg0141r-beneficioItem.BeneficioCodigo <> 04 /* 04 - STOCK BACKUP      */ 
            THEN
                NEXT.

            /*Quando for informado um beneficio espec°fico*/
            IF  p-tipo-beneficio <> ? 
            AND msg0141r-beneficioItem.BeneficioCodigo <> p-tipo-beneficio THEN
                NEXT.

            /* STATUS DO BENEF÷CIO ê CONVERTIDO APENAS AQUI */
            CASE msg0141r-beneficioItem.NomeStatusBeneficio:
                WHEN "ATIVO"     THEN ASSIGN i-status = 1.
                WHEN "BLOQUEADO" THEN ASSIGN i-status = 2.
                WHEN "SUSPENSO"  THEN ASSIGN i-status = 3.
                OTHERWISE ASSIGN i-status = ?.
            END CASE.

            /* CASO E STATUS N«O TENHA SIDO INFORMADO NO CRM, ASSUMIMOS QUE ESTµ SUSPENSO */
            IF  i-status = ? THEN
                ASSIGN i-status = 3.

            /* TIPO DA CATEGORIA, INDICANDO SE ê OURO/BRATA/BRONZE/DISTRIBUIDOR */
            CASE msg0141r-beneficioItem.CategoriaCodigo:
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
                                                    INPUT "MSG0141-LISTAR_BENEFICIO_CANAL - Categoria do benef°cio n∆o existe no EMS. " ,
                                                    INPUT "C¢digo Canal EMS....: " + string(tt-canal.canal)                          + CHR(10) +
                                                          "C¢digo Canal CRM....: " + tt-canal.guid-canal                             + CHR(10) +
                                                          "Cod Categoria CRM...: " + string(msg0141r-beneficioItem.CategoriaCodigo)  + CHR(10) +  
                                                          "Nome Categoria......: " + msg0141r-beneficioItem.NomeCategoria).
                NEXT.
            END.

            
            IF  CAN-FIND (FIRST b-tt-beneficio
                            WHERE b-tt-beneficio.canal               = tt-canal.canal 
                              AND b-tt-beneficio.unid-neg            = msg0141r-beneficioItem.CodigoUnidadeNegocio 
                              AND b-tt-beneficio.tipo-beneficio      = msg0141r-beneficioItem.BeneficioCodigo) THEN DO: 

                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                    INPUT "MSG0141-LISTAR_BENEFICIO_CANAL - Benef°cio existe em duplicidade no CRM. " ,
                                                    INPUT "C¢digo Canal EMS....: " + string(tt-canal.canal)                          + CHR(10) +
                                                          "C¢digo Canal CRM....: " + tt-canal.guid-canal                             + CHR(10) +
                                                          "Cod Categoria CRM...: " + string(msg0141r-beneficioItem.CategoriaCodigo)  + CHR(10) +  
                                                          "Nome Categoria......: " + msg0141r-beneficioItem.NomeCategoria).
                NEXT.
            END.

            CREATE tt-beneficio.
            ASSIGN tt-beneficio.canal                = tt-canal.canal             
                   tt-beneficio.guid-canal           = tt-canal.guid-canal        
                   tt-beneficio.unid-neg             = msg0141r-beneficioItem.CodigoUnidadeNegocio
                   tt-beneficio.guid-categoria       = msg0141r-beneficioItem.CodigoCategoria    
                   tt-beneficio.guid-beneficio       = msg0141r-beneficioItem.CodigoBeneficio
                   tt-beneficio.guid-beneficio-canal = msg0141r-beneficioItem.CodigoBeneficioCanal
                   tt-beneficio.tipo-beneficio       = msg0141r-beneficioItem.BeneficioCodigo
                   tt-beneficio.tipo-categoria       = c-categoria
                   tt-beneficio.guid-class           = tt-canal.guid-class 
                   tt-beneficio.nome-class           = int-class-canal.nome
                   tt-beneficio.exclusividade        = int-emitente.exclusividade
                   tt-beneficio.id-status            = i-status         
                   tt-beneficio.calcula-verba        = msg0141r-beneficioItem.CalculaVerba.


            /*----------------------------------------------------------------------------------------------------------------------------*/
            /*                                        BUSCA DO PERCENTUAL GLOBAL DO BENEF÷CIO                                             */
            /*----------------------------------------------------------------------------------------------------------------------------*/
            IF  p-buscar-param-globais THEN DO: /*n∆o precisa % global quando for apenas provis∆o */
                RUN pi-Buscar-Parametros-Globais (INPUT  tt-canal.guid-class                        , /* GUID */
                                                  INPUT  msg0141r-beneficioItem.CodigoCategoria     , /* GUID */
                                                  INPUT  msg0141r-beneficioItem.BeneficioCodigo     , /* 21-VMC, 22-STOCK ROTATION, 37-REBATE, 66-REBATE P‡S-VENDA */
                                                  INPUT  msg0141r-beneficioItem.CodigoUnidadeNegocio, /* C‡DIGO DO EMS MESMO */
                                                  INPUT  msg0141r-beneficioItem.CodigoBeneficio     , /* GUID */
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

    IF  msg0141r-beneficioItem.BeneficioCodigo = 15
    /*OR  msg0141r-beneficioItem.BeneficioCodigo = 08*/
    OR  msg0141r-beneficioItem.BeneficioCodigo = 04 THEN 
        RETURN "OK".


    FIND FIRST tt-param-global
       WHERE tt-param-global.unid-neg       = p-CodigoUnidadeNegocio
         AND tt-param-global.guid-class     = p-guid-classificacao
         AND tt-param-global.guid-categoria = p-guid-Categoria
         AND tt-param-global.guid-beneficio = p-guid-beneficio
         AND tt-param-global.tipo-beneficio = p-TipoParametroGlobal NO-ERROR.

    IF  AVAIL tt-param-global THEN DO:
        ASSIGN p-valor-param = tt-param-global.perc-global.
        RETURN "OK".
    END.

    EMPTY TEMP-TABLE resultado.
    EMPTY TEMP-TABLE msg0111r-ParametroGlobal.

    RUN esp/esb/out/msg0111.p (INPUT  p-guid-classificacao,   /* CLASSIFICACAO      */      
                               INPUT  ?,                      /* COMPROMISSO        */        
                               INPUT  p-guid-Categoria,       /* CATEGORIA          */          
                               INPUT  p-guid-beneficio,       /* BENEFICIO          */          
                               INPUT  p-TipoParametroGlobal,  /* TIPO DE PAR∂METRO  */  
                               INPUT  ?,                      /* N÷VEL P‡S-VENDA    */                       
                               INPUT  p-CodigoUnidadeNegocio, /* UNIDADE DE NEG‡CIO */ 
                               OUTPUT TABLE resultado,                               
                               OUTPUT TABLE msg0111r-ParametroGlobal).      

    FIND FIRST resultado NO-ERROR.

    IF  AVAIL resultado  THEN DO:

        IF  resultado.sucesso THEN DO:
            FIND FIRST msg0111r-ParametroGlobal NO-ERROR.

/*             MESSAGE "p-TipoParametroGlobal: " p-TipoParametroGlobal   SKIP             */
/*                     "p-CodigoUnidadeNegocio: " p-CodigoUnidadeNegocio SKIP             */
/*                     "tt-canal.canal-central: " tt-canal.canal SKIP                     */
/*                     "AVAIL msg0111r-ParametroGlobal: " AVAIL msg0111r-ParametroGlobal  */
/*                 VIEW-AS ALERT-BOX INFO BUTTONS OK.                                     */

            IF  AVAIL msg0111r-ParametroGlobal THEN DO:
                CREATE tt-param-global.
                ASSIGN tt-param-global.unid-neg       = p-CodigoUnidadeNegocio
                       tt-param-global.guid-class     = p-guid-classificacao
                       tt-param-global.guid-categoria = p-guid-Categoria
                       tt-param-global.guid-beneficio = p-guid-Beneficio
                       tt-param-global.tipo-beneficio = p-TipoParametroGlobal
                       tt-param-global.perc-global    = dec(msg0111r-ParametroGlobal.valor).

                ASSIGN p-valor-param = tt-param-global.perc-global.

                IF  p-valor-param = 0 THEN DO:
                    RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                        INPUT "MSG0111-OBTER_PARAMETRO_GLOBAL - Retornou % GLOBAL zerado. " ,
                                                        INPUT "Canal EMS..........: " + string(tt-canal.canal)        + CHR(10) +
                                                              "C¢digo Canal CRM...: " + tt-canal.guid-canal           + CHR(10) +
                                                              "Classificacao CRM..: " + p-guid-classificacao          + CHR(10) +
                                                              "Categoria CRM......: " + p-guid-Categoria              + CHR(10) +
                                                              "Unidade de Neg¢cio.: " + p-CodigoUnidadeNegocio        + CHR(10) +
                                                              "Beneficio CRM......: " + p-guid-Beneficio              + CHR(10) +
                                                              "Tipo ParÉmetro.....: " + string(p-TipoParametroGlobal) + CHR(10) +
                                                              "Erro Barramento....: N∆o foi poss°vel interpretar o retorno do barramento" ).
                    RETURN "NOK".

                END.
            END.
            ELSE DO:
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                    INPUT "MSG0111-OBTER_PARAMETRO_GLOBAL - N∆o retornou parÉmetros / Registro n∆o Encontrado. " ,
                                                    INPUT "Canal EMS..........: " + string(tt-canal.canal)        + CHR(10) +
                                                          "C¢digo Canal CRM...: " + tt-canal.guid-canal           + CHR(10) +
                                                          "Classificacao CRM..: " + p-guid-classificacao          + CHR(10) +
                                                          "Categoria CRM......: " + p-guid-Categoria              + CHR(10) +
                                                          "Unidade de Neg¢cio.: " + p-CodigoUnidadeNegocio        + CHR(10) +
                                                          "Beneficio CRM......: " + p-guid-Beneficio              + CHR(10) +
                                                          "Tipo ParÉmetro.....: " + string(p-TipoParametroGlobal) + CHR(10) +
                                                          "Erro Barramento....: N∆o retornou parÉmetros" ).
                RETURN "NOK".
            END.
        END.
        ELSE DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                INPUT "MSG0111-OBTER_PARAMETRO_GLOBAL - Processou mensagem mas retornou erro. " ,
                                                INPUT "Canal EMS..........: " + string(tt-canal.canal)        + CHR(10) +
                                                      "C¢digo Canal CRM...: " + tt-canal.guid-canal           + CHR(10) +
                                                      "Classificacao CRM..: " + p-guid-classificacao          + CHR(10) +
                                                      "Categoria CRM......: " + p-guid-Categoria              + CHR(10) +
                                                      "Unidade de Neg¢cio.: " + p-CodigoUnidadeNegocio        + CHR(10) +
                                                      "Beneficio CRM......: " + p-guid-Beneficio              + CHR(10) +
                                                      "Tipo ParÉmetro.....: " + string(p-TipoParametroGlobal) + CHR(10) +
                                                      "Erro Barramento....: " + string(resultado.CodigoErro)  + " - " + resultado.mensagem  ).
            RETURN "NOK".
        END.

    END.
    ELSE DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "MSG0111-OBTER_PARAMETRO_GLOBAL. N∆o processada, erro na tentativa de acesso ao barramento. " ,
                                            INPUT "Canal EMS..........: " + string(tt-canal.canal)        + CHR(10) +
                                                  "C¢digo Canal CRM...: " + tt-canal.guid-canal           + CHR(10) +
                                                  "Classificacao CRM..: " + p-guid-classificacao          + CHR(10) +
                                                  "Categoria CRM......: " + p-guid-Categoria              + CHR(10) +
                                                  "Unidade de Neg¢cio.: " + p-CodigoUnidadeNegocio        + CHR(10) +
                                                  "Beneficio CRM......: " + p-guid-Beneficio              + CHR(10) +
                                                  "Tipo ParÉmetro.....: " + string(p-TipoParametroGlobal) + CHR(10) +
                                                  "Erro Barramento....: N∆o foi poss°vel interpretar o retorno do barramento" ).
        RETURN "NOK".
    END.
    
    RETURN "OK".
END.


/*-----------------------------------------*/
/*  MSG0142  - LISTAR_PARAMETROS_BENEFICIO */
/*-----------------------------------------*/
PROCEDURE pi-busca-parametros-beneficios:
    
    /* N«O PRECISA BUSCAR PAR∂METROS PARA O SHOW ROOM E ESTOCK BACKUP */
    IF  msg0141r-beneficioItem.BeneficioCodigo = 15
    OR  msg0141r-beneficioItem.BeneficioCodigo = 04 THEN 
        RETURN "OK".

    /* S‡ CHAMA A MENSAGEM MSG0142, CASO AINDA N«O TENHA CHAMADO ANTES PARA O TIPO DE BENEF÷CIO*/
    IF  NOT CAN-FIND (FIRST tt-param-msg0142                                                  
                       WHERE tt-param-msg0142.tipo-beneficio = tt-beneficio.tipo-beneficio    
                         AND tt-param-msg0142.unid-neg       = tt-beneficio.unid-neg) 
    THEN do: /* BUSCA NO BARRAMENTO */

        RUN pi-acompanhar IN h-acomp ("Buscando Parametros Benef....: " + fn-retorna-nome-beneficio (tt-beneficio.tipo-beneficio)).  
    
        EMPTY TEMP-TABLE  msg0142r-ParametroBeneficioItem. 
        EMPTY TEMP-TABLE  resultado. 
        RUN esp/esb/out/msg0142.p (INPUT        tt-beneficio.guid-beneficio, /* Canal */      
                                   OUTPUT TABLE resultado,                               
                                   OUTPUT TABLE msg0142r-ParametroBeneficioItem).      
        
        FIND FIRST resultado NO-ERROR.
    
        IF  AVAIL resultado  THEN DO:
            IF  NOT resultado.sucesso THEN DO:
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                    INPUT "MSG0142-LISTAR_PARAMETRO_BENEFICIO. Processou mensagem mas retornou erro." , 
                                                    INPUT "Canal EMS..........: " + string(tt-canal.canal)                                  + CHR(10) +
                                                          "C¢digo Canal CRM...: " + tt-canal.guid-canal                                     + CHR(10) +
                                                          "Benef°cio CRM......: " + string(tt-beneficio.guid-beneficio)                     + CHR(10) + 
                                                          "Nome Benef°cio.....: " + fn-retorna-nome-beneficio (tt-beneficio.tipo-beneficio) + CHR(10) +  
                                                          "Erro Barramento....: " + string(resultado.CodigoErro)  + " - " + resultado.mensagem  ).
                RETURN "NOK".
            END.
        END.
        ELSE DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                INPUT "MSG0142-LISTAR_PARAMETRO_BENEFICIO. N∆o processada, erro na tentativa de acesso ao barramento." ,
                                                INPUT "Canal EMS..........: " + string(tt-canal.canal)                                  + CHR(10) +
                                                      "C¢digo Canal CRM...: " + tt-canal.guid-canal                                     + CHR(10) +
                                                      "Benef°cio CRM......: " + string(tt-beneficio.guid-beneficio)                     + CHR(10) +         
                                                      "Nome Benef°cio.....: " + fn-retorna-nome-beneficio (tt-beneficio.tipo-beneficio) + CHR(10) +         
                                                      "Erro Barramento....: N∆o foi poss°vel interpretar o retorno do barramento" ).
            RETURN "NOK".
        END.
    
        IF  NOT CAN-FIND (FIRST msg0142r-ParametroBeneficioItem) THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                INPUT "MSG0142-LISTAR_PARAMETRO_BENEFICIO. N∆o existem parÉmetros cadastrados para este benef°cio. " ,
                                                INPUT "Canal EMS..........: " + string(tt-canal.canal)                                   + CHR(10) +
                                                      "C¢digo Canal CRM...: " + tt-canal.guid-canal                                      + CHR(10) +
                                                      "Benef°cio CRM......: " + string(tt-beneficio.guid-beneficio)                      + CHR(10) +         
                                                      "Nome Benef°cio.....: " + fn-retorna-nome-beneficio (tt-beneficio.tipo-beneficio)).
                                                      
            RETURN "NOK".
        END.
    
        FOR EACH msg0142r-ParametroBeneficioItem:

            IF  CAN-FIND (FIRST tt-param-msg0142                                                  
                             WHERE tt-param-msg0142.tipo-beneficio = tt-beneficio.tipo-beneficio    
                               AND tt-param-msg0142.unid-neg       = msg0142r-ParametroBeneficioItem.CodigoUnidadeNegocio)  THEN 
                NEXT.

            CREATE tt-param-msg0142.
            ASSIGN tt-param-msg0142.tipo-beneficio = tt-beneficio.tipo-beneficio
                   tt-param-msg0142.unid-neg       = msg0142r-ParametroBeneficioItem.CodigoUnidadeNegocio
                   tt-param-msg0142.conta          = msg0142r-ParametroBeneficioItem.ContaContabil        
                   tt-param-msg0142.centro-custo   = msg0142r-ParametroBeneficioItem.CentroCusto
                   tt-param-msg0142.cod-estabel    = string(msg0142r-ParametroBeneficioItem.CodigoEstabelecimento)
                   tt-param-msg0142.cod-especie    = msg0142r-ParametroBeneficioItem.EspecieDocumento
                   tt-param-msg0142.tipo-fluxo     = msg0142r-ParametroBeneficioItem.TipoFluxoFinanceiro
                   tt-param-msg0142.perc-custo     = msg0142r-ParametroBeneficioItem.PercentualCusto            
                   tt-param-msg0142.perc-prov-meta = msg0142r-ParametroBeneficioItem.PercentualAtingimentoMeta.         
        END.
    END.

    FIND FIRST tt-param-msg0142
      WHERE tt-param-msg0142.tipo-beneficio = tt-beneficio.tipo-beneficio
        AND tt-param-msg0142.unid-neg       = tt-beneficio.unid-neg NO-ERROR.

    IF  AVAIL tt-param-msg0142 THEN DO:
    
        ASSIGN tt-beneficio.conta          = tt-param-msg0142.conta          
               tt-beneficio.centro-custo   = tt-param-msg0142.centro-custo   
               tt-beneficio.cod-estabel    = tt-param-msg0142.cod-estabel    
               tt-beneficio.cod-especie    = tt-param-msg0142.cod-especie    
               tt-beneficio.tipo-fluxo     = tt-param-msg0142.tipo-fluxo     
               tt-beneficio.perc-custo     = tt-param-msg0142.perc-custo     
               tt-beneficio.perc-prov-meta = tt-param-msg0142.perc-prov-meta.


    END.
    ELSE DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "MSG0142-LISTAR_PARAMETRO_BENEFICIO: N∆o foi poss°vel identificar os parÉmentros financeiros. " ,
                                            INPUT "Canal EMS..........: " + string(tt-canal.canal)                                  + CHR(10) +
                                                  "C¢digo Canal CRM...: " + tt-canal.guid-canal                                     + CHR(10) +
                                                  "Benef°cio CRM......: " + string(tt-beneficio.guid-beneficio)                     + CHR(10) +         
                                                  "Nome Benef°cio.....: " + fn-retorna-nome-beneficio (tt-beneficio.tipo-beneficio) + CHR(10) +
                                                  "Unidade Neg¢cio....: " + tt-beneficio.unid-neg).
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

