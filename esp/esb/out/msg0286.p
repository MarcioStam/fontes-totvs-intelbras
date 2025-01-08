{include/i-prgvrs.i msg0286 2.00.00.000}  /*** 010000 ***/

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-int-calc-comis LIKE int-calc-comis.

{esp/esb/out/msg0286.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

DEFINE VARIABLE c-matricula AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont      AS INTEGER     NO-UNDO.

CREATE tt-int-calc-comis.
RAW-TRANSFER raw-param TO tt-int-calc-comis.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0286, UnidadesNegocio, UnidadeNegocio, Segmentos, Segmento, tt-total
   DATA-RELATION FOR conteudo, msg0286                RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0286, UnidadesNegocio         RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR UnidadesNegocio, UnidadeNegocio  RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR UnidadeNegocio, Segmentos        RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR Segmentos, Segmento              RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0286, tt-total                RELATION-FIELDS (idm, idm) NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0286r, resultado
   DATA-RELATION FOR conteudor, msg0286r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0286r, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0286'.
     
CREATE conteudo.
CREATE msg0286.

FOR FIRST tt-int-calc-comis NO-LOCK:

    /*Executivo*/
    IF tt-int-calc-comis.idi-tipo = 1 THEN DO:
        FIND FIRST int-executivo NO-LOCK
             WHERE int-executivo.cod-executivo = tt-int-calc-comis.codigo NO-ERROR.

        ASSIGN c-matricula = int-executivo.matricula.
    END.
    /*Supervisor*/
    ELSE DO:
        FIND FIRST int-supervisor NO-LOCK
             WHERE int-supervisor.cod-supervisor = tt-int-calc-comis.codigo NO-ERROR.
    
        ASSIGN c-matricula = int-supervisor.matricula.
    END.

    ASSIGN msg0286.Empresa          = 1
           msg0286.TipoColaborador  = 1
           msg0286.Matricula        = c-matricula
           msg0286.DataReferencia   = TODAY
           msg0286.TipoComissao     = IF tt-int-calc-comis.periodo-mes MOD 3 = 0 THEN "T" ELSE "M" /*1 - Mensal, 2 - Trimestral*/
           cabecalho.NumeroOperacao = STRING(msg0286.Matricula) + "-" + STRING(tt-int-calc-comis.periodo-mes,"99") + "/" + STRING(tt-int-calc-comis.periodo-ano).

    CREATE UnidadesNegocio.
    CREATE tt-total.

    ASSIGN i-cont = 0.

    FOR EACH int-calc-comis NO-LOCK
       WHERE int-calc-comis.periodo-ano = tt-int-calc-comis.periodo-ano
         AND int-calc-comis.periodo-mes = tt-int-calc-comis.periodo-mes
         AND int-calc-comis.codigo      = tt-int-calc-comis.codigo     
         AND int-calc-comis.idi-tipo    = tt-int-calc-comis.idi-tipo:

        ASSIGN i-cont = i-cont + 1.

        FIND FIRST unid_negoc NO-LOCK
             WHERE unid_negoc.cod_unid_negoc = int-calc-comis.cod-unid-negoc NO-ERROR.

        CREATE UnidadeNegocio.
        ASSIGN UnidadeNegocio.NomeUnidadeNegocio          = unid_negoc.des_unid_negoc
               UnidadeNegocio.PercentualProporcionalUN    = int-calc-comis.perc-un                                       
               UnidadeNegocio.ValorVariavelUN             = int-calc-comis.vl-variavel-un                             
               UnidadeNegocio.ValorFaturamentoUN          = int-calc-comis.vl-faturado                                   
               UnidadeNegocio.ValorSelloutUN              = int-calc-comis.vl-sellout                                    
               UnidadeNegocio.ValorFatSellUN              = int-calc-comis.vl-fat-total                                  
               UnidadeNegocio.ValorMetaUN                 = int-calc-comis.vl-meta                                       
               UnidadeNegocio.PercentualAtingimentoMetaUN = int-calc-comis.perc-ating-meta
               UnidadeNegocio.ValorCarteiraUN             = int-calc-comis.vl-carteira                                   
               UnidadeNegocio.PercAtingMetaFatCarteiraUN  = int-calc-comis.perc-ating-meta-cart
               UnidadeNegocio.ValorVariavelReceberMesUN   = int-calc-comis.vl-var-apagar                                 
               UnidadeNegocio.ValorBonusMixMesUN          = int-calc-comis.vl-bonus-mix                                  
               UnidadeNegocio.ValorRolloutTrimestreUN     = int-calc-comis.vl-rollout-tri                                
               UnidadeNegocio.PercAtingMetaTrimestreUN    = int-calc-comis.perc-ating-tri                                
               UnidadeNegocio.AtingiuMetaTrimestreAtualUN = IF int-calc-comis.perc-ating-tri >= 100 THEN YES ELSE NO     
               UnidadeNegocio.ValorRNMVariavelUN          = int-calc-comis.vl-rnm-variav                                 
               UnidadeNegocio.ValorRNMBonusMixUN          = int-calc-comis.vl-rnm-bonus                                  
               UnidadeNegocio.ValorRNMTotalUN             = int-calc-comis.vl-rnm-tot                                    
               UnidadeNegocio.ValorBonusSuperacaoUN       = int-calc-comis.vl-bonus-sup                                  
               UnidadeNegocio.ValorSalarioVariavelTotalUN = int-calc-comis.vl-var-tot.                                   

        ASSIGN tt-total.PercentualTotal                = IF tt-total.PercentualTotal + UnidadeNegocio.PercentualProporcionalUN >= 100 THEN 100 ELSE tt-total.PercentualTotal + UnidadeNegocio.PercentualProporcionalUN
               tt-total.ValorVariavelTotal             = tt-total.ValorVariavelTotal             + UnidadeNegocio.ValorVariavelUN            
               tt-total.ValorFaturamentoTotal          = tt-total.ValorFaturamentoTotal          + UnidadeNegocio.ValorFaturamentoUN         
               tt-total.ValorSelloutTotal              = tt-total.ValorSelloutTotal              + UnidadeNegocio.ValorSelloutUN             
               tt-total.ValorFatSellTotal              = tt-total.ValorFatSellTotal              + UnidadeNegocio.ValorFatSellUN             
               tt-total.ValorMetaTotal                 = tt-total.ValorMetaTotal                 + UnidadeNegocio.ValorMetaUN                
               tt-total.MediaPercentualAtingimentoMeta = tt-total.MediaPercentualAtingimentoMeta + UnidadeNegocio.PercentualAtingimentoMetaUN
               tt-total.ValorCarteiraTotal             = tt-total.ValorCarteiraTotal             + UnidadeNegocio.ValorCarteiraUN            
               tt-total.MediaPercAtingMetaFatCarteira  = tt-total.MediaPercAtingMetaFatCarteira  + UnidadeNegocio.PercAtingMetaFatCarteiraUN 
               tt-total.ValorVariavelReceberMesTotal   = tt-total.ValorVariavelReceberMesTotal   + UnidadeNegocio.ValorVariavelReceberMesUN  
               tt-total.ValorBonusMixMesTotal          = tt-total.ValorBonusMixMesTotal          + UnidadeNegocio.ValorBonusMixMesUN         
               tt-total.ValorRolloutTrimestreTotal     = tt-total.ValorRolloutTrimestreTotal     + UnidadeNegocio.ValorRolloutTrimestreUN    
               tt-total.MediaPercAtingMetaTrimestre    = tt-total.MediaPercAtingMetaTrimestre    + UnidadeNegocio.PercAtingMetaTrimestreUN   
               tt-total.AtingiuMetaTrimestreAtualTotal = IF int-calc-comis.perc-ating-tri >= 100 THEN YES ELSE NO
               tt-total.ValorRNMVariavelTotal          = tt-total.ValorRNMVariavelTotal          + UnidadeNegocio.ValorRNMVariavelUN         
               tt-total.ValorRNMBonusMixTotal          = tt-total.ValorRNMBonusMixTotal          + UnidadeNegocio.ValorRNMBonusMixUN         
               tt-total.ValorRNMTotal                  = tt-total.ValorRNMTotal                  + UnidadeNegocio.ValorRNMTotalUN            
               tt-total.ValorBonusSuperacaoTotal       = tt-total.ValorBonusSuperacaoTotal       + UnidadeNegocio.ValorBonusSuperacaoUN      
               tt-total.ValorSalarioVariavelTotal      = tt-total.ValorSalarioVariavelTotal      + UnidadeNegocio.ValorSalarioVariavelTotalUN.
                                                                                                   
    END.     

    ASSIGN tt-total.MediaPercentualAtingimentoMeta = tt-total.MediaPercentualAtingimentoMeta / i-cont
           tt-total.MediaPercAtingMetaFatCarteira  = tt-total.MediaPercAtingMetaFatCarteira  / i-cont
           tt-total.MediaPercAtingMetaTrimestre    = tt-total.MediaPercAtingMetaTrimestre    / i-cont.
END.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
