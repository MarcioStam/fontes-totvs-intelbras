{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0286 NO-UNDO XML-NODE-NAME 'MSG0286'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD Empresa         AS INTEGER INITIAL ?
    FIELD TipoColaborador AS INTEGER INITIAL ?
    FIELD Matricula       AS CHAR    INITIAL ?
    FIELD DataReferencia  AS DATE    INITIAL ?
    FIELD TipoComissao    AS CHAR    INITIAL ? /*1ÎMensal, 2ÎTrimnstral*/
    .

DEFINE TEMP-TABLE UnidadesNegocio NO-UNDO XML-NODE-NAME 'UnidadesNegocio'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    .

DEFINE TEMP-TABLE UnidadeNegocio NO-UNDO XML-NODE-NAME 'UnidadeNegocio'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD NomeUnidadeNegocio          AS CHAR 
    FIELD PercentualProporcionalUN    LIKE int-calc-comis.perc-un        
    FIELD ValorVariavelUN             AS DEC /*LIKE int-calc-comis.variavel-un    */
    FIELD ValorFaturamentoUN          LIKE int-calc-comis.vl-faturado    
    FIELD ValorSelloutUN              LIKE int-calc-comis.vl-sellout     
    FIELD ValorFatSellUN              LIKE int-calc-comis.vl-fat-total   
    FIELD ValorMetaUN                 LIKE int-calc-comis.vl-meta        
    FIELD PercentualAtingimentoMetaUN AS DEC /*LIKE int-calc-comis.perc-ating*/
    FIELD ValorCarteiraUN             LIKE int-calc-comis.vl-carteira    
    FIELD PercAtingMetaFatCarteiraUN  AS DEC /*LIKE int-calc-comis.perc-ating-ca*/  XML-NODE-NAME "PercentualAtingimentoMetaFaturadoCarteiraUN"
    FIELD ValorVariavelReceberMesUN   LIKE int-calc-comis.vl-var-apagar  
    FIELD ValorBonusMixMesUN          LIKE int-calc-comis.vl-bonus-mix   
    FIELD ValorRolloutTrimestreUN     LIKE int-calc-comis.vl-rollout-tri 
    FIELD PercAtingMetaTrimestreUN    LIKE int-calc-comis.perc-ating-tri XML-NODE-NAME "PercentualAtingimentoMetaTrimestreUN"
    FIELD AtingiuMetaTrimestreAtualUN AS LOG
    FIELD ValorRNMVariavelUN          LIKE int-calc-comis.vl-rnm-variav  
    FIELD ValorRNMBonusMixUN          LIKE int-calc-comis.vl-rnm-bonus   
    FIELD ValorRNMTotalUN             LIKE int-calc-comis.vl-rnm-tot     
    FIELD ValorBonusSuperacaoUN       LIKE int-calc-comis.vl-bonus-sup   
    FIELD ValorSalarioVariavelTotalUN LIKE int-calc-comis.vl-var-tot     
    .

DEFINE TEMP-TABLE Segmentos NO-UNDO XML-NODE-NAME 'Segmentos'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    .

DEFINE TEMP-TABLE Segmento NO-UNDO XML-NODE-NAME 'Segmento'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
/*     FIELD NomeSegmento                     AS LOG                                                                  */
/*     FIELD PercentualProporcionalSEG        AS LOG                                                                  */
/*     FIELD ValorVariavelSEG                 AS LOG                                                                  */
/*     FIELD ValorFaturamentoSEG              AS LOG                                                                  */
/*     FIELD ValorSelloutSEG                  AS LOG                                                                  */
/*     FIELD ValorFatSellSEG                  AS LOG                                                                  */
/*     FIELD ValorMetaSEG                     AS LOG                                                                  */
/*     FIELD PercentualAtingimentoMetaSEG     AS LOG                                                                  */
/*     FIELD ValorCarteiraSEG                 AS LOG                                                                  */
/*     FIELD PercAtingMetaFatCarteiraSEG      AS LOG     XML-NODE-NAME "PercentualAtingimentoMetaFaturadoCarteiraSEG" */
/*     FIELD ValorVariavelReceberMesSEG       AS LOG                                                                  */
/*     FIELD ValorBonusMixMesSEG              AS LOG                                                                  */
/*     FIELD ValorRolloutTrimestreSEG         AS LOG                                                                  */
/*     FIELD PercAtingMetaTrimestreSEG        AS LOG     XML-NODE-NAME "PercentualAtingimentoMetaTrimestreSEG"        */
/*     FIELD AtingiuMetaTrimestreAtualSEG     AS LOG                                                                  */
/*     FIELD ValorRNMVariavelSEG              AS LOG                                                                  */
/*     FIELD ValorRNMBonusMixSEG              AS LOG                                                                  */
/*     FIELD ValorRNMTotalSEG                 AS LOG                                                                  */
/*     FIELD ValorBonusSuperacaoSEG           AS LOG                                                                  */
/*     FIELD ValorSalarioVariavelTotalSEG     AS LOG                                                                  */
    .

DEFINE TEMP-TABLE tt-total NO-UNDO XML-NODE-NAME 'Total'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD PercentualTotal                  LIKE int-calc-comis.perc-un       
    FIELD ValorVariavelTotal               AS DEC 
    FIELD ValorFaturamentoTotal            LIKE int-calc-comis.vl-faturado   
    FIELD ValorSelloutTotal                LIKE int-calc-comis.vl-sellout    
    FIELD ValorFatSellTotal                LIKE int-calc-comis.vl-fat-total  
    FIELD ValorMetaTotal                   LIKE int-calc-comis.vl-meta       
    FIELD MediaPercentualAtingimentoMeta   AS DEC 
    FIELD ValorCarteiraTotal               LIKE int-calc-comis.vl-carteira   
    FIELD MediaPercAtingMetaFatCarteira    AS DEC XML-NODE-NAME "MediaPercentualAtingimentoMetaFaturadoCarteira"
    FIELD ValorVariavelReceberMesTotal     LIKE int-calc-comis.vl-var-apagar 
    FIELD ValorBonusMixMesTotal            LIKE int-calc-comis.vl-bonus-mix  
    FIELD ValorRolloutTrimestreTotal       LIKE int-calc-comis.vl-rollout-tri
    FIELD MediaPercAtingMetaTrimestre      LIKE int-calc-comis.perc-ating-tri      XML-NODE-NAME "MediaPercentualAtingimentoMetaTrimestre"
    FIELD AtingiuMetaTrimestreAtualTotal   AS LOG                            
    FIELD ValorRNMVariavelTotal            LIKE int-calc-comis.vl-rnm-variav 
    FIELD ValorRNMBonusMixTotal            LIKE int-calc-comis.vl-rnm-bonus  
    FIELD ValorRNMTotal                    LIKE int-calc-comis.vl-rnm-tot    
    FIELD ValorBonusSuperacaoTotal         LIKE int-calc-comis.vl-bonus-sup  
    FIELD ValorSalarioVariavelTotal        LIKE int-calc-comis.vl-var-tot    
    FIELD ValorSalarioTotal                AS DEC            
    .

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0286R NO-UNDO XML-NODE-NAME 'MSG0286R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".
