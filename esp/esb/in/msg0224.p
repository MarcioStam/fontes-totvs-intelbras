CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                                            */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                                            */
/*                                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                                           */
/*                 <MENSAGEM>                                                                      */
/*                   <CABECALHO>                                                                   */
/*                     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*                     <NumeroOperacao>gu048488-2015-07-01-2015-07-31-2-fr04965</NumeroOperacao>   */
/*                     <CodigoMensagem>MSG0224</CodigoMensagem>                                    */
/*                     <LoginUsuario>fr049656</LoginUsuario>                                       */
/*                   </CABECALHO>                                                                  */
/*                   <CONTEUDO>                                                                    */
/*                         <MSG0224>                                                               */
/*                             <CodigoUnidadeNegocio>CEN</CodigoUnidadeNegocio>                    */
/*                             <CodigoEstabelecimento>101</CodigoEstabelecimento>                  */
/*                         </MSG0224>                                                              */
/*                   </CONTEUDO>                                                                   */
/*                 </MENSAGEM>".                                                                   */

{esp/esb/in/msg0224.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0224
   DATA-RELATION FOR conteudo, MSG0224      RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0224R1, ContaContabil, CentroCusto, resultado
   DATA-RELATION FOR conteudor, MSG0224R1       RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0224R1, ContaContabil   RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR ContaContabil, CentroCusto RELATION-FIELDS (CodigoContaContabil, CodigoContaContabil) NESTED
   DATA-RELATION FOR MSG0224R1, resultado       RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0224R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0224 NO-ERROR.

CREATE conteudor.
CREATE MSG0224R1.
CREATE resultado.

RUN retorna-contas.

DELETE OBJECT h_api_ccusto.
DELETE OBJECT h_api_cta_ctbl.

ASSIGN h_api_ccusto   = ?      
       h_api_cta_ctbl = ?.     

IF  RETURN-VALUE <> "OK" THEN DO:
    
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY tt-erro.Mensagem:
        ASSIGN resultado.Mensagem = resultado.Mensagem + tt-erro.mensagem + IF NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

/* DEFINE VARIABLE hDoc    AS HANDLE   NO-UNDO.                                                 */
/* CREATE X-DOCUMENT hDoc.                                                                      */
/* hDoc:LOAD("LONGCHAR", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + REPLACE(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE retorna-contas:

    RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
    RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

    FIND FIRST unid_negoc NO-LOCK
         WHERE unid_negoc.cod_unid_negoc = msg0224.CodigoUnidadeNegocio NO-ERROR.

    IF NOT AVAIL unid_negoc THEN DO:
        RUN pi-erro (INPUT "NÆo encontrada unidade de neg¢cio com o c¢digo: " + unid_negoc.cod_unid_negoc).
        RETURN "NOK".
    END.

    IF MSG0224.CodigoContaContabil <> ? THEN DO:
        FIND FIRST cta_ctbl NO-LOCK
             WHERE cta_ctbl.cod_cta_ctbl = MSG0224.CodigoContaContabil NO-ERROR.

        IF NOT AVAIL (cta_ctbl) THEN DO:
            RUN pi-erro (INPUT "NÆo encontrada conta cont bil n£mero: " + MSG0224.CodigoContaContabil).
            RETURN "NOK".
        END.

        RUN pi_busca_plano_cta_ctbl_empresa IN h_api_cta_ctbl (INPUT "", /*Empresa, passa branco para a API buscar a do usu rio*/
                                                               INPUT TODAY,
                                                               OUTPUT v_cod_plano_cta_ctbl,
                                                               OUTPUT TABLE tt_log_erro).

        IF CAN-FIND (FIRST tt_log_erro) THEN DO:
            FOR EACH tt_log_erro:
                RUN pi-erro (INPUT tt_log_erro.ttv_des_msg_ajuda + " " + tt_log_erro.ttv_des_msg_erro).
            END.                    
            RETURN "NOK".
        END.

        RUN pi-cria-tts.

    END.
    ELSE DO:
        FOR EACH cta_ctbl NO-LOCK:
            IF msg0224.DescricaoContaContabil <> ? THEN DO:
                IF NOT cta_ctbl.des_tit_ctbl MATCHES("*" + msg0224.DescricaoContaContabil + "*")  THEN
                    NEXT.
            END.

            RUN pi_busca_plano_cta_ctbl_empresa IN h_api_cta_ctbl (INPUT "", /*Empresa, passa branco para a API buscar a do usu rio*/
                                                                   INPUT TODAY,
                                                                   OUTPUT v_cod_plano_cta_ctbl,
                                                                   OUTPUT TABLE tt_log_erro).

            IF CAN-FIND (FIRST tt_log_erro) THEN DO:
                FOR EACH tt_log_erro:
                    RUN pi-erro (INPUT tt_log_erro.ttv_des_msg_ajuda + " " + tt_log_erro.ttv_des_msg_erro).
                END.                    
                RETURN "NOK".
            END.
    
            RUN pi-cria-tts.
        END.
    END.

    RUN pi_busca_ccustos_x_cta_ctbl IN h_api_ccusto (INPUT  "", /*Empresa, passa branco para a API buscar a do usu rio*/
                                                     INPUT  MSG0224.CodigoEstabelecimento,
                                                     INPUT  NO, /*Listar todos estabelecimentos*/
                                                     INPUT  "", /*Plano Centro Custo, passa branco para a API buscar o vigente*/
                                                     INPUT  unid_negoc.cod_unid_negoc,
                                                     INPUT  TODAY,
                                                     INPUT  TABLE tt_cta_integr,
                                                     OUTPUT TABLE tt_ccusto_cta_integr,
                                                     OUTPUT TABLE tt_log_erro).

    IF CAN-FIND (FIRST tt_log_erro) THEN DO:
        FOR EACH tt_log_erro:
            RUN pi-erro (INPUT tt_log_erro.ttv_des_msg_ajuda + " " + tt_log_erro.ttv_des_msg_erro).
        END.                    
        RETURN "NOK".
    END.

    FOR EACH tt_ccusto_cta_integr:

        FIND FIRST emscad.ccusto NO-LOCK
             WHERE emscad.ccusto.cod_empresa      = tt_ccusto_cta_integr.ttv_cod_empresa 
               AND emscad.ccusto.cod_plano_ccusto = tt_ccusto_cta_integr.ttv_cod_plano_ccusto
               AND emscad.ccusto.cod_ccusto       = tt_ccusto_cta_integr.ttv_cod_ccusto NO-ERROR.

        RUN pi-valida-cc-uni-estab (INPUT msg0224.CodigoEstabelecimento,
                                    INPUT emscad.ccusto.cod_ccusto,
                                    INPUT unid_negoc.cod_unid_negoc).

        IF RETURN-VALUE <> "OK" THEN
            NEXT.

        CREATE CentroCusto. 
        ASSIGN CentroCusto.CodigoContaContabil  = tt_ccusto_cta_integr.ttv_cod_cta_ctbl 
               CentroCusto.CodigoCentroCusto    = ccusto.cod_ccusto         
               CentroCusto.DescricaoCentroCusto = ccusto.des_tit_ctbl       
               CentroCusto.MatriculaResponsavel = ccusto.cod_usuar_respons  
               CentroCusto.DataInicioValidade   = ccusto.dat_inic_valid     
               CentroCusto.DataFimValidade      = ccusto.dat_fim_valid.      
    END.
   
    IF CAN-FIND (FIRST tt-erro) THEN DO:
        RETURN "NOK".
    END.

    RETURN "OK".
END.

PROCEDURE pi-valida-cc-uni-estab:
    DEFINE INPUT PARAMETER p_cod_estabel    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p_cod_custo      AS CHARACTER NO-UNDO. /*so 5 posicoes*/ 
    DEFINE INPUT PARAMETER p_cod_unid_negoc AS CHARACTER NO-UNDO. /*unidade ems5 */

    DEFINE VARIABLE l-erro-valida AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-unidades    AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE c-erro AS CHARACTER FORMAT "x(200)"  NO-UNDO.

    DEFINE BUFFER b_cc_uni_estab FOR cc_uni_estab.

    ASSIGN c-unidades = "".
    FIND FIRST cc_uni_estab NO-LOCK
         WHERE cc_uni_estab.cod_ccusto     = p_cod_custo 
           AND cc_uni_estab.cod_unid_negoc = p_cod_unid_negoc NO-ERROR.
    IF NOT AVAIL cc_uni_estab THEN DO:
        /*RUN pi-erro (INPUT "Centro Custo: " + p_cod_custo + " nao cadastrado na tabela cc_uni_estab").*/
        RETURN "NOK".
    END.
    ELSE DO:
        FIND FIRST cc_uni_estab NO-LOCK
             WHERE cc_uni_estab.cc_codigo      = p_cod_custo 
               AND cc_uni_estab.cod_unid_negoc = p_cod_unid_negoc NO-ERROR.
        IF AVAIL cc_uni_estab THEN DO:
            FIND FIRST b_cc_uni_estab NO-LOCK 
                 WHERE b_cc_uni_estab.cc_codigo      = cc_uni_estab.cc_codigo
                   AND b_cc_uni_estab.cod_estab      = p_cod_estabel
                   AND b_cc_uni_estab.cod_unid_negoc = p_cod_unid_negoc  NO-ERROR.
            IF NOT AVAIL b_cc_uni_estab THEN DO:
                /*RUN pi-erro (INPUT "Centro Custo: " + p_cod_custo + " nao pode ser utilizado no estabelecimento " + p_cod_estabel + ".").*/
                RETURN "NOK".
            END.
        END.
        ELSE DO:
            ASSIGN l-erro-valida = YES.
            IF NOT CAN-FIND(FIRST cc_uni_estab NO-LOCK
                            WHERE cc_uni_estab.cod_ccusto     = p_cod_custo
                              AND cc_uni_estab.cod_estab      = p_cod_estabel
                              AND cc_uni_estab.cod_unid_negoc = p_cod_unid_negoc ) THEN DO:
                /*RUN pi-erro (INPUT "Centro Custo: " + p_cod_custo + " nao pode ser utilizado no estabelecimento " + p_cod_estabel + ".").*/
                RETURN "NOK".
            END.
            ELSE DO:
                FOR EACH cc_uni_estab NO-LOCK
                   WHERE cc_uni_estab.cod_ccusto   = p_cod_custo
                     AND cc_uni_estab.cod_estab    = p_cod_estabel:
                    IF cc_uni_estab.cod_unid_negoc = p_cod_unid_negoc THEN
                        ASSIGN l-erro-valida = NO.

                    IF c-unidades = "" THEN
                        ASSIGN c-unidades = cc_uni_estab.cod_unid_negoc.
                    ELSE
                        ASSIGN c-unidades = "," + cc_uni_estab.cod_unid_negoc.
                END.
                IF l-erro-valida THEN DO:
                    /*RUN pi-erro (INPUT "C.Custo: " + p_cod_custo + " p/ estab: " + p_cod_estabel + " so pode ser usado nas unidades: " + c-unidades + ".").*/
                    RETURN "NOK".
                END.
            END.
        END.
    END.

    RETURN "OK".
END PROCEDURE.

PROCEDURE pi-cria-tts:

    CREATE tt_cta_integr.
    ASSIGN tt_cta_integr.ttv_cod_plano_cta_ctbl = v_cod_plano_cta_ctbl
           tt_cta_integr.ttv_cod_cta_ctbl       = cta_ctbl.cod_cta_ctbl.

    CREATE ContaContabil.
    ASSIGN ContaContabil.CodigoContaContabil    = cta_ctbl.cod_cta_ctbl
           ContaContabil.DescricaoContaContabil = cta_ctbl.des_tit_ctbl
           ContaContabil.Alternativa            = cta_ctbl.cod_altern_cta_ctbl    
           ContaContabil.FinalidadeContabil     = cta_ctbl.ind_utiliz_ctbl_finalid
           ContaContabil.DataInicioValidade     = cta_ctbl.dat_inic_valid         
           ContaContabil.DataFimValidade        = cta_ctbl.dat_fim_valid.

    RETURN "OK".
END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.

    
    
