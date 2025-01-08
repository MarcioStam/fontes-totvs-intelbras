/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i FT0518F FCI.F3V01.00.000}

&if "{&EMSFND_VERSION}" >= "1.00" &then
    {include/i-license-manager.i ft0518f MFT}
&endif

/******************************************************************************
**
**  Programa: FT0518F.P
**
**  Objetivo: Carregar informaá‰es das tabelas tempor†rias para impress∆o
**            da NF-e baseado no retorno das TT's do programa axsep017
**
******************************************************************************/

{cdp/cdcfgdis.i}

DEF TEMP-TABLE ttArquivo NO-UNDO
      FIELD sequencia   AS INT
      FIELD nomeArquivo AS CHAR
      INDEX idx1 sequencia.

/**** Parametros ****/
DEF INPUT-OUTPUT PARAM TABLE FOR ttArquivo.
DEF INPUT PARAM l-reimp AS LOGICAL NO-UNDO. 


/**** Variaveis ****/
DEFINE VARIABLE h-axsep017                   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bcapi016                   AS HANDLE      NO-UNDO.
DEFINE VARIABLE iTpAmbSEFAZ                  AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-cod-uf-ibge                AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-mult-nfe                   AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-count-nfe                  AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-soma-mod-nfe               AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-dig-ver-nfe                AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont-itens                 AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-modelo-DANFE               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-chave-acesso-adicional-nfe AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont                       AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-sem-Word                   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-desc-mod-frete             AS CHARACTER   NO-UNDO.

/****  Variaveis Compartilhadas  ****/
DEFINE SHARED VAR r-nota       AS ROWID.
DEFINE SHARED VAR c-hr-saida   AS CHAR    FORMAT "xx:xx:xx" INIT "000000".
DEFINE SHARED VAR l-dt         AS LOGICAL FORMAT "Sim/Nao"  INIT NO.

{ftp/ft0518f.i5} /* ttDanfe, ttDanfeItem */

{adapters/xml/ep2/axsep017.i} /*Temp-Tables da NF-e, ttNFe, ttIde, ttDet, etc.*/

/*Temp-Table com todos os campos que s∆o impressos no DANFE, referente ao ICMS*/
DEFINE TEMP-TABLE ttICMSDanfe NO-UNDO  
    FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
    FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributá∆o pelo ICMS 00 - Tributada integralmente*/
    FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
    FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/       
    FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al°quota do ICMS*/    
    FIELD vBCST          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS ST*/ 
    FIELD vICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS ST*/ 
    /*Chave EMS*/
    FIELD CodEstabelNF   AS CHARACTER INITIAL ?
    FIELD SerieNF        AS CHARACTER INITIAL ?
    FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
    FIELD ItCodigoNF     AS CHARACTER INITIAL ?
    FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
    INDEX ch-ttICMSDanfe CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


RUN adapters/xml/ep2/axsep017.p PERSISTENT SET h-axsep017.
RUN pi-seta-nota-fiscal    IN h-axsep017 (INPUT r-nota).
RUN pi-prepara-dados       IN h-axsep017.
RUN pi-devolve-temp-tables IN h-axsep017 (OUTPUT  TABLE ttAdi       ,
                                          OUTPUT  TABLE ttArma      ,
                                          OUTPUT  TABLE ttAvulsa    ,
                                          OUTPUT  TABLE ttCobr      ,
                                          OUTPUT  TABLE ttCOFINSAliq,
                                          OUTPUT  TABLE ttCOFINSNT  ,
                                          OUTPUT  TABLE ttCOFINSOutr,
                                          OUTPUT  TABLE ttCOFINSQtde,
                                          OUTPUT  TABLE ttCOFINSST  ,
                                          OUTPUT  TABLE ttComb      ,
                                          OUTPUT  TABLE ttCompra    ,
                                          OUTPUT  TABLE ttDest      ,
                                          OUTPUT  TABLE ttDet       ,
                                          OUTPUT  TABLE ttDI        ,
                                          OUTPUT  TABLE ttDup       ,
                                          OUTPUT  TABLE ttEmit      ,
                                          OUTPUT  TABLE ttEntrega   ,
                                          OUTPUT  TABLE ttExporta   ,
                                          OUTPUT  TABLE ttICMS00    ,
                                          OUTPUT  TABLE ttICMS10    ,
                                          OUTPUT  TABLE ttICMS20    ,
                                          OUTPUT  TABLE ttICMS30    ,
                                          OUTPUT  TABLE ttICMS40    ,
                                          OUTPUT  TABLE ttICMS51    ,
                                          OUTPUT  TABLE ttICMS60    ,
                                          OUTPUT  TABLE ttICMS70    ,
                                          OUTPUT  TABLE ttICMS90    ,
                                          OUTPUT  TABLE ttICMSTot   ,
                                          OUTPUT  TABLE ttIde       ,
                                          OUTPUT  TABLE ttII        ,
                                          OUTPUT  TABLE ttInfAdic   ,
                                          OUTPUT  TABLE ttIPI       ,
                                          OUTPUT  TABLE ttISSQN     ,
                                          OUTPUT  TABLE ttISSQNtot  ,
                                          OUTPUT  TABLE ttLacres    ,
                                          OUTPUT  TABLE ttMed       ,
                                          OUTPUT  TABLE ttNFe       ,
                                          OUTPUT  TABLE ttrefNF     ,
                                          OUTPUT  TABLE ttObsCont   ,
                                          OUTPUT  TABLE ttObsFisco  ,
                                          OUTPUT  TABLE ttPISAliq   ,
                                          OUTPUT  TABLE ttPISNT     ,
                                          OUTPUT  TABLE ttPISOutr   ,
                                          OUTPUT  TABLE ttPISQtde   ,
                                          OUTPUT  TABLE ttPISST     ,
                                          OUTPUT  TABLE ttProcRef   ,
                                          OUTPUT  TABLE ttReboque   ,
                                          OUTPUT  TABLE ttRetirada  ,
                                          OUTPUT  TABLE ttRetTrib   ,
                                          OUTPUT  TABLE ttTransp    ,
                                          OUTPUT  TABLE ttVeic      ,
                                          OUTPUT  TABLE ttVol       ,
                                          OUTPUT  TABLE ttrefNFP    ,
                                          OUTPUT  TABLE ttrefCTe    ,
                                          OUTPUT  TABLE ttrefECF    ,
                                          OUTPUT  TABLE ttICMSPart  ,
                                          OUTPUT  TABLE ttICMSST    ,
                                          OUTPUT  TABLE ttICMSSN101 ,
                                          OUTPUT  TABLE ttICMSSN102 ,
                                          OUTPUT  TABLE ttICMSSN201 ,
                                          OUTPUT  TABLE ttICMSSN202 ,
                                          OUTPUT  TABLE ttICMSSN500 ,
                                          OUTPUT  TABLE ttICMSSN900 ,
                                          OUTPUT  TABLE ttCana      ,
                                          OUTPUT  TABLE ttForDia    ,
                                          OUTPUT  TABLE ttDeduc     ).

IF  VALID-HANDLE(h-axsep017) THEN DO:
    DELETE PROCEDURE h-axsep017.
    ASSIGN h-axsep017 = ?.
END.

EMPTY TEMP-TABLE ttDanfe.
EMPTY TEMP-TABLE ttDanfeItem.

FIND FIRST nota-fiscal   NO-LOCK WHERE ROWID(nota-fiscal) = r-nota NO-ERROR.
FIND FIRST natur-oper    NO-LOCK
    WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.
FIND FIRST param-global  NO-LOCK                                   NO-ERROR.

FIND FIRST ttNFe         NO-LOCK NO-ERROR.
FIND FIRST ttIde         NO-LOCK NO-ERROR.
FIND FIRST ttEmit        NO-LOCK NO-ERROR.
FIND FIRST ttDest        NO-LOCK NO-ERROR.
FIND FIRST ttICMSTot     NO-LOCK NO-ERROR.
FIND FIRST ttTransp      NO-LOCK NO-ERROR.
FIND FIRST ttISSQNTot    NO-LOCK NO-ERROR.
FIND FIRST ttInfAdic     NO-LOCK NO-ERROR.

CREATE ttDanfe.

/* Codigo de Barras - Chave de Acesso */
RUN bcp/bcapi016.p PERSISTENT SET h-bcapi016.
RUN generateCODE128C IN h-bcapi016 (TRIM(ttNFe.ChaveAcessoNFe),OUTPUT ttDanfe.BCCODE128-chave).

DELETE PROCEDURE h-bcapi016.
ASSIGN h-bcapi016 = ?.
/* Fim Codigo de Barras */

/* Ambiente (SEFAZ) do envio da Nota */
ASSIGN iTpAmbSEFAZ = INT(&if '{&bf_dis_versao_ems}' >= '2.09':U
                         &then nota-fiscal.idi-tip-emis-amb-sefaz
                         &else SUBSTRING(nota-fiscal.char-2,200,1) &endif) NO-ERROR.

IF  NOT (iTpAmbSEFAZ > 0) THEN
    ASSIGN iTpAmbSEFAZ = INT(ttIde.tpAmb).
/* Fim - Ambiente (SEFAZ) do envio da Nota */

/* Modelo de DANFE: 1=Retrato 2=Paisagem */
FIND FIRST ser-estab NO-LOCK
     WHERE ser-estab.cod-estabel = nota-fiscal.cod-estabel
       AND ser-estab.serie       = nota-fiscal.serie NO-ERROR.

ASSIGN c-modelo-DANFE = (&if  "{&bf_dis_versao_ems}" < "2.07":U 
                         &then SUBSTRING(ser-estab.char-1,4,1) 
                         &else STRING(ser-estab.idi-format-emis-danfe)  &endif) WHEN AVAIL ser-estab.
/* Fim - MODELO DO DANFE*/

FIND FIRST transporte 
     WHERE transporte.nome-abrev = nota-fiscal.nome-transp NO-LOCK NO-ERROR.

FIND FIRST estabelec 
     WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.
/* Utiliza ou N∆o Word da impress∆o do DANFE */
ASSIGN l-sem-Word     = (&if "{&bf_dis_versao_ems}":U >= "2.08":U
                       &then ser-estab.log-word-danfe
                       &else substring(ser-estab.char-1,70,1) = "S":U &endif) WHEN AVAIL ser-estab.
/* Fim - Utiliza ou N∆o Word da impress∆o do DANFE */

                         
ASSIGN ttDanfe.chavedeacessonfe          = STRING(ttNFe.ChaveAcessoNFe,"9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999")
       ttDanfe.sn                        = ttIde.tpNF
       ttDanfe.razaosocialempresa        = ttEmit.xNome
       ttDanfe.enderecoemp               = (ttEmit.xLgr + " " + ttEmit.nro + " " + ttEmit.xCpl)
       ttDanfe.bairroemp                 = ttEmit.xBairro
       ttDanfe.cidadeemp                 = ttEmit.xMun
       ttDanfe.ufemp                     = ttEmit.UF
       ttDanfe.cepemp                    = STRING( (IF   ttEmit.CEP <> ""
                                                    THEN FILL("0", 8 - LENGTH(STRING(ttEmit.CEP))) + STRING(ttEmit.CEP)
                                                    ELSE STRING(ttEmit.CEP))  ,"99999-999")
       ttDanfe.foneemp                   = ttEmit.fone
       /*ttDanfe.siteemp                   =*/
       ttDanfe.nrnota                    = ttNFe.NrNotaFisNF
       ttDanfe.ser                       = ttNFe.SerieNF
       /*ttDanfe.n1                        =*/
       /*ttDanfe.nnn                       =*/
       ttDanfe.naturezaoperacao          = natur-oper.denominacao
       ttDanfe.inscrestadempresa         = ttEmit.IE
       ttDanfe.inscrestadsubstituto      = ttEmit.IEST
       ttDanfe.cnpjempresa               = (IF   param-global.formato-id-federal <> ""
                                            THEN STRING(ttEmit.CNPJ, param-global.formato-id-federal)
                                            ELSE ttEmit.CNPJ)
       ttDanfe.cnpjdestinatario          = (IF   ttDest.i-natureza = 1 /*Pessoa Fisica*/
                                            THEN IF   param-global.formato-id-pessoal <> ""
                                                 THEN STRING(ttDest.CPF,  param-global.formato-id-pessoal)
                                                 ELSE ttDest.CPF
                                            ELSE IF   param-global.formato-id-federal <> ""
                                                 THEN STRING(ttDest.CNPJ, param-global.formato-id-federal)
                                                 ELSE ttDest.CNPJ)
       ttDanfe.razaosocialdestinatario   = ttDest.xNome
       ttDanfe.dataemissao               = STRING(ttIde.dEmi,"99/99/9999")
       ttDanfe.dataentrega               = STRING(nota-fiscal.dt-saida,"99/99/9999")
       ttDanfe.horasaida                 = c-hr-saida WHEN (c-hr-saida <> "00:00:00" AND l-dt)
       ttDanfe.enderecodestinatario      = (ttDest.xLgr + " " + ttDest.nro + " " + ttDest.xCpl)
       ttDanfe.cidadedestinatario        = ttDest.xMun
       ttDanfe.bairrodestinatario        = ttDest.xBairro
       ttDanfe.cepdestinatario           = STRING( (IF   ttDest.CEP <> ""
                                                    THEN FILL("0", 8 - LENGTH(STRING(ttDest.CEP))) + STRING(ttDest.CEP)
                                                    ELSE STRING(ttDest.CEP))  ,"99999-999")
       ttDanfe.fonedestinatario          = ttDest.fone
       ttDanfe.ufdest                    = ttDest.UF
       ttDanfe.inscrestaddestinatario    = ttDest.IE
       ttDanfe.vlbcicmsnota              = TRIM(STRING(ttICMSTot.vBC   ,"->>>,>>>,>>>,>>9.99"))
       ttDanfe.vlicmsnota                = TRIM(STRING(ttICMSTot.vICMS ,"->>>,>>>,>>>,>>9.99"))
       ttDanfe.vlbcicmsstnota            = TRIM(STRING(ttICMSTot.vBCST ,"->>>,>>>,>>>,>>9.99"))
       ttDanfe.vlicmsstnota              = TRIM(STRING(ttICMSTot.vST   ,"->>>,>>>,>>>,>>9.99"))
       ttDanfe.vltotprod                 = TRIM(STRING(ttICMSTot.vProd ,"->>>,>>>,>>>,>>9.99"))
       ttDanfe.vlfretenota               = TRIM(STRING(ttICMSTot.vFrete,"->>>,>>>,>>>,>>9.99"))
       ttDanfe.vlseguronota              = TRIM(STRING(ttICMSTot.vSeg  ,"->>>,>>>,>>>,>>9.99"))
       ttDanfe.vldescontonota            = TRIM(STRING(ttICMSTot.vDesc ,"->>>,>>>,>>>,>>9.99"))
       ttDanfe.vldespesasnota            = TRIM(STRING(ttICMSTot.vOutro,"->>>,>>>,>>>,>>9.99"))
       ttDanfe.vlipinota                 = TRIM(STRING(ttICMSTot.vIPI  ,"->>>,>>>,>>>,>>9.99"))
       ttDanfe.vltotnota                 = TRIM(STRING(ttICMSTot.vNF   ,"->>>,>>>,>>>,>>9.99"))

       ttDanfe.nometransp                = ttTransp.xNome
       /*ttDanfe.codantt1                  =*/
       /*ttDanfe.codantt2                  =*/
       ttDanfe.placa1                    = ttTransp.placa
       /*ttDanfe.placa2                    =*/
       ttDanfe.ufpl1                     = ttTransp.UFPlaca
       /*ttDanfe.ufpl2                     =*/
       ttDanfe.inscrmunicipaliss         = estabelec.ins-municipal
       ttDanfe.vltotalsevicos            = IF  AVAIL ttISSQNTot 
                                           THEN TRIM(STRING(ttISSQNTot.vServ,"->>>,>>>,>>>,>>9.99")) 
                                           ELSE TRIM(STRING(0               ,"->>>,>>>,>>>,>>9.99")) 
       ttDanfe.vlbciss                   = IF  AVAIL ttISSQNTot 
                                           THEN TRIM(STRING(ttISSQNTot.vBC  ,"->>>,>>>,>>>,>>9.99")) 
                                           ELSE TRIM(STRING(0               ,"->>>,>>>,>>>,>>9.99")) 
       ttDanfe.vlisstotal                = IF  AVAIL ttISSQNTot 
                                           THEN TRIM(STRING(ttISSQNTot.vISS ,"->>>,>>>,>>>,>>9.99")) 
                                           ELSE TRIM(STRING(0               ,"->>>,>>>,>>>,>>9.99")) 
       ttDanfe.informacoescomplementares = ttInfAdic.infCpl
       /*ttDanfe.contingencia              =*/
       ttDanfe.homologacao1              = (IF   iTpAmbSEFAZ = 2 /*Homologacao*/
                                            THEN "SEM VALOR FISCAL":U
                                            ELSE "")
       ttDanfe.homologacao2              = (IF   iTpAmbSEFAZ = 2 /*Homologacao*/
                                            THEN "Nota Fiscal Eletrìnica Autorizada em Ambiente de HOMOLOGAÄ«O.":U
                                            ELSE "").
       IF (AVAIL transporte AND 
          transporte.nome-abrev <> "Remetente"    AND 
          transporte.nome-abrev <> "Destinat†rio" AND 
          transporte.nome-abrev <> "Destinatario") THEN DO:

          ASSIGN ttDanfe.cnpjtransp                = (IF   ttTransp.i-natureza = 1 /*Pessoa Fisica*/
                                                      THEN IF   param-global.formato-id-pessoal <> ""
                                                      THEN STRING(ttTransp.CPF,  param-global.formato-id-pessoal)
                                                      ELSE ttTransp.CPF
                                                      ELSE IF   param-global.formato-id-federal <> ""
                                                      THEN STRING(ttTransp.CNPJ, param-global.formato-id-federal)
                                                      ELSE ttTransp.CNPJ)
                 ttDanfe.enderecotransp            = ttTransp.xEnder                                          
                 ttDanfe.cidadetransp              = ttTransp.xMun
                 ttDanfe.uftran                    = ttTransp.UF
                 ttDanfe.inscrestadtransp          = ttTransp.IE.
       END.
       ELSE 
           ASSIGN ttDanfe.cnpjtransp               = ""
                  ttDanfe.enderecotransp           = ""
                  ttDanfe.cidadetransp             = ""
                  ttDanfe.uftran                   = ""
                  ttDanfe.inscrestadtransp         = "".
       
/*=====================================================================================================================================================
  LOCAL DE ENTREGA (quando for diferente do endereáo padr∆o do destinat†rio da nota fiscal) 
=====================================================================================================================================================*/

FOR FIRST ttEntrega NO-LOCK: /*S¢ haver† registro na ttEntrega na condiá∆o de o local de entrega ser diferente do endereáo do destinatario/cliente da nota*/

    ASSIGN ttDanfe.informacoescomplementares = ttDanfe.informacoescomplementares +
                                               "  LOCAL DE ENTREGA: "    + (ttEntrega.xLgr + " " + ttEntrega.nro + " " + ttEntrega.xCpl) +
                                               " Bairro/Distrito: "      + ttEntrega.xBairro +
                                               " Municipio: "            + ttEntrega.xMun    + 
                                               " UF: "                   + ttEntrega.UF      +
                                               " Pais: "                 + nota-fiscal.pais.
END.
/*===================================================================================================================================================*/



/*=====================================================================================================================================================
  MODALIDADE DE FRETE (No XML da NF-e envia-se apenas os C¢digos. No DANFE, imprime-se Codigo + Descricao) 
  
  0 Œ Emitente
  1 Œ Destinat†rio/Remetente
  2 Œ Terceiros
  9 Œ Sem Frete
=====================================================================================================================================================*/

CASE ttTransp.modfrete:
    WHEN "0":U THEN
        ASSIGN c-desc-mod-frete = "0 Œ Emitente":U.
    WHEN "1":U THEN
        ASSIGN c-desc-mod-frete = "1 Œ Destinat†rio/Remetente":U.
    WHEN "2":U THEN
        ASSIGN c-desc-mod-frete = "2 Œ Terceiros":U.
    WHEN "9":U THEN
        ASSIGN c-desc-mod-frete = "9 Œ Sem Frete":U.
END CASE.

ASSIGN ttDanfe.idfr = c-desc-mod-frete.

/*===================================================================================================================================================*/



/*=====================================================================================================================================================
  VOLUMES E EMBALAGENS
=====================================================================================================================================================*/
ASSIGN ttDanfe.especievolume = "".

FOR EACH ttVol NO-LOCK
    WHERE ( (ttVol.esp   <> "" AND ttVol.esp   <> ?) /* Valida se existe ao menos uma informacao valida */
     OR    (ttVol.pesoB <> 0  AND ttVol.pesoB <> ?)
     OR    (ttVol.pesoL <> 0  AND ttVol.pesoL <> ?)
     /*OR    (ttVol.qVol  <> "" AND ttVol.qVol  <> ?)*/ )  /*NT2012.003 - tag qVol obrigatoria*/
    BREAK BY ttVol.siglaEmb:

    ACCUMULATE INT(ttVol.qVol) (TOTAL).
    ACCUMULATE     ttVol.pesoB (TOTAL).
    ACCUMULATE     ttVol.pesoL (TOTAL).

    IF  LAST (ttVol.siglaEmb) THEN
        ASSIGN ttDanfe.qtvolume              = nota-fiscal.nr-volumes
               /*ttDanfe.qtvolume              = TRIM(STRING(ACCUM TOTAL INT(ttVol.qVol),"->>>,>>>,>>>,>>9.99"))*/
               ttDanfe.marcavolume           = ttVol.marca
               ttDanfe.numeracaovolume       = ttVol.nVol
               ttDanfe.pesobrutototal        = TRIM(STRING(ACCUM TOTAL ttVol.pesoB,"->>>,>>>,>>>,>>9.999"))
               ttDanfe.pesoliquidototal      = TRIM(STRING(ACCUM TOTAL ttVol.pesoL,"->>>,>>>,>>>,>>9.999")).

    IF  ttVol.esp <> ?  AND 
        ttVol.esp <> "" THEN DO:
        IF  ttDanfe.especievolume <> "" THEN
            ttDanfe.especievolume = ttDanfe.especievolume + "/".

        ASSIGN ttDanfe.especievolume = ttDanfe.especievolume + ttVol.esp.
    END.
END.
/*===================================================================================================================================================*/



/*=====================================================================================================================================================
  PROTOCOLO DE AUTORIZACAO + Data e Hora
=====================================================================================================================================================*/

ASSIGN ttDanfe.protocoloautorizacao = &if "{&bf_dis_versao_ems}":U >= "2.07":U 
                                      &then RIGHT-TRIM(nota-fiscal.cod-protoc)
                                      &else RIGHT-TRIM(SUBSTRING(nota-fiscal.char-1,97,15))
                                      &endif.

FOR EACH ret-nf-eletro NO-LOCK
   WHERE ret-nf-eletro.cod-estabel = nota-fiscal.cod-estabel
     AND ret-nf-eletro.cod-serie   = nota-fiscal.serie      
     AND ret-nf-eletro.nr-nota-fis = nota-fiscal.nr-nota-fis
      BY ret-nf-eletro.dat-ret DESC
      BY ret-nf-eletro.hra-ret DESC:

    IF &if "{&bf_dis_versao_ems}" >= "2.07":U &then
         ret-nf-eletro.cod-protoc
       &else
         ret-nf-eletro.cod-livre-1
       &endif
    = TRIM(ttDanfe.protocoloautorizacao) THEN DO:

        ASSIGN ttDanfe.protocoloautorizacao = ttDanfe.protocoloautorizacao + 
                                              "   " + STRING(ret-nf-eletro.dat-ret,"99/99/9999")  + /*DATA*/
                                              "   " + STRING(ret-nf-eletro.hra-ret,"xx:xx:xx").     /*HORA*/
        LEAVE.
    END.
END.
/*===================================================================================================================================================*/




/*=====================================================================================================================================================
  chavedeacessoadicionalnfe = cUF + tpEmis + CNPJ + vNF + ICMSp + ICMSs + DD + DV 
  onde: cUF    = codigo da UF do destinatario do documento fiscal
        tpEmis = forma de emissao da NF-e
        CNPJ   = CNPJ do destinatario
        vNF    = valor total da NF-e(sem ponto decimal, informar sempre os centavos
        ICMSp  = Destaque de ICMS proprio na NF-e e no seguinte formato: 1 - ha destaque de ICMS proprio | 2 - nao ha destaque de ICMS proprio
        ICMSs  = Destaque de ICMS por substituiÁao tributaria na NF-e e no seguinte formato: 1 - ha destaque de ICMS ST | 2 - nao ha destaque de ICMS ST
        DD     = Dia da emissao da NF-e
        DV     = Digito Verificador
  
  IMPRESSAO DE CODIGO DE BARRA ADICIONAL, PARA IMPRESSAO EM CONTINGENCIA PARA FORMULARIO ESPECIAL (FS e FS-DA)      
=====================================================================================================================================================*/

    IF  ttIde.tpEmis = "2" OR ttIde.tpEmis = "5" THEN DO: /* Tipo de Emissao -> 2 - Contingencia FS / 5 - Contingencia FS-DA */

        /*Busca Codigo da UF do Destinatario da Nota*/
        IF  ttDest.xPais = "Brasil":U THEN
            FOR FIRST unid-feder NO-LOCK
                WHERE unid-feder.pais   = ttDest.xPais
                  AND unid-feder.estado = ttDest.UF:

                ASSIGN c-cod-uf-ibge = (&if  "{&bf_dis_versao_ems}"  >=  "2.07":U
                                        &then STRING(unid-feder.cod-uf-ibge)
                                        &else STRING(subSTRING(unid-feder.char-1,1,2))
                                        &endif).
            END. /* for first unid-feder no-lock */
        ELSE 
            ASSIGN c-cod-uf-ibge = "99".
        
        ASSIGN c-chave-acesso-adicional-nfe = /* cUF      */  STRING(INT(c-cod-uf-ibge), '99') + 
                                              /* tpEmis   */  ttIde.tpEmis +
                                              /* CNPJ/CPF */  STRING(DEC(TRIM(REPLACE(REPLACE(REPLACE(ttDanfe.cnpjdestinatario,".",""),"-",""),"/",""))), '99999999999999') +
                                              /* vNF      */  STRING(ttICMSTot.vNF * 100, '99999999999999') + 
                                              /* ICMSp    */  (IF  ttICMSTot.vICMS > 0 
                                                               THEN "1"
                                                               ELSE "2") +
                                              /* ICMSs    */  (IF  ttICMSTot.vST > 0
                                                               THEN "1"
                                                               ELSE "2") +  
                                              /* DD       */  STRING(DAY(ttIde.dEmi),"99").

        ASSIGN i-mult-nfe = 2.

        DO  i-count-nfe = LENGTH(c-chave-acesso-adicional-nfe) TO 1 BY -1:
            ASSIGN i-soma-mod-nfe = i-soma-mod-nfe + (INT(SUBSTRING(c-chave-acesso-adicional-nfe,i-count-nfe,1)) * i-mult-nfe).
        
            ASSIGN i-mult-nfe = i-mult-nfe + 1.
            IF i-mult-nfe = 10 THEN ASSIGN i-mult-nfe = 2.
        END.
        
        IF i-soma-mod-nfe MODULO 11 = 0 OR
           i-soma-mod-nfe MODULO 11 = 1 THEN ASSIGN i-dig-ver-nfe = 0.
                                        ELSE ASSIGN i-dig-ver-nfe = 11 - (i-soma-mod-nfe MODULO 11).
            
        ASSIGN c-chave-acesso-adicional-nfe = c-chave-acesso-adicional-nfe + STRING(i-dig-ver-nfe). /* DV */

        RUN bcp/bcapi016.p PERSISTENT SET h-bcapi016.
        RUN generateCODE128C IN h-bcapi016 (INPUT TRIM(c-chave-acesso-adicional-nfe),OUTPUT ttDanfe.BCCODE128-chaveadicional).

        ASSIGN ttDanfe.chavedeacessoadicionalnfe = STRING(c-chave-acesso-adicional-nfe, "9999 9999 9999 9999 9999 9999 9999 9999 9999").

        DELETE PROCEDURE h-bcapi016.
        ASSIGN h-bcapi016 = ?.
        
    END.
    ELSE DO:
        ASSIGN c-chave-acesso-adicional-nfe      = ""
               ttDanfe.chavedeacessoadicionalnfe = "".
    END.
/*===================================================================================================================================================*/



/*=====================================================================================================================================================
  DUPLICATAS
=====================================================================================================================================================*/

ASSIGN i-cont = 1.

FOR EACH ttDup NO-LOCK:

    IF  i-cont = 8 THEN LEAVE. /*Danfe Padr∆o somente com 8 duplicatas. Se houverem mais, sair e nao imprimir. No XML ir∆o todas as fat-duplic existentes*/

    IF  i-cont = 1 THEN
        ASSIGN ttDanfe.fatura1  = ttDup.nDup
               ttDanfe.vencfat1 = STRING(ttDup.dVenc,"99/99/9999")
               ttDanfe.vlfat1   = TRIM(STRING(ttDup.vDup,"->>>>,>>>,>>>,>>9.99")).
    IF  i-cont = 2 THEN
        ASSIGN ttDanfe.fatura2  = ttDup.nDup                                                 
               ttDanfe.vencfat2 = STRING(ttDup.dVenc,"99/99/9999")                           
               ttDanfe.vlfat2   = TRIM(STRING(ttDup.vDup,"->>>>,>>>,>>>,>>9.99")).

    IF  i-cont = 3 THEN
        ASSIGN ttDanfe.fatura3  = ttDup.nDup                                                 
               ttDanfe.vencfat3 = STRING(ttDup.dVenc,"99/99/9999")                           
               ttDanfe.vlfat3   = TRIM(STRING(ttDup.vDup,"->>>>,>>>,>>>,>>9.99")).

    IF  i-cont = 4 THEN
        ASSIGN ttDanfe.fatura4  = ttDup.nDup                                                 
               ttDanfe.vencfat4 = STRING(ttDup.dVenc,"99/99/9999")                           
               ttDanfe.vlfat4   = TRIM(STRING(ttDup.vDup,"->>>>,>>>,>>>,>>9.99")).

    IF  i-cont = 5 THEN
        ASSIGN ttDanfe.fatura5  = ttDup.nDup                                                 
               ttDanfe.vencfat5 = STRING(ttDup.dVenc,"99/99/9999")                           
               ttDanfe.vlfat5   = TRIM(STRING(ttDup.vDup,"->>>>,>>>,>>>,>>9.99")).

    IF  i-cont = 6 THEN
        ASSIGN ttDanfe.fatura6  = ttDup.nDup                                                 
               ttDanfe.vencfat6 = STRING(ttDup.dVenc,"99/99/9999")                           
               ttDanfe.vlfat6   = TRIM(STRING(ttDup.vDup,"->>>>,>>>,>>>,>>9.99")).

    IF  i-cont = 7 THEN
        ASSIGN ttDanfe.fatura7  = ttDup.nDup                                                 
               ttDanfe.vencfat7 = STRING(ttDup.dVenc,"99/99/9999")                           
               ttDanfe.vlfat7   = TRIM(STRING(ttDup.vDup,"->>>>,>>>,>>>,>>9.99")).

    IF  i-cont = 8 THEN
        ASSIGN ttDanfe.fatura8  = ttDup.nDup                                                 
               ttDanfe.vencfat8 = STRING(ttDup.dVenc,"99/99/9999")                           
               ttDanfe.vlfat8   = TRIM(STRING(ttDup.vDup,"->>>>,>>>,>>>,>>9.99")).

    ASSIGN i-cont = i-cont + 1.
END.
/*===================================================================================================================================================*/



/*=====================================================================================================================================================
  INFORMAÄÂES ESPECIAIS PARA EMISS«O EM CONTING“NCIA (VARIAVEIS DOS ARQUIVOS .RTF -> conteudovariavel1 E conteudovariavel2)
=====================================================================================================================================================*/

IF  ttIde.tpEmis = "1" OR ttIde.tpEmis = "3" THEN /* Tipo de Emiss∆o -> 1 - Normal / 3 - Contingància SCAN */
    
    ASSIGN ttDanfe.conteudovariavel1 = "www.nfe.fazenda.gov.br/portal ou no site da Sefaz Autorizadora":U
           ttDanfe.conteudovariavel2 = "PROTOCOLO DE AUTORIZAÄ«O DE USO":U.

ELSE IF ttIde.tpEmis = "4" THEN /* Tipo de Emiss∆o -> 4 - Contingància DPEC */
        
    ASSIGN ttDanfe.conteudovariavel1 = "www.nfe.fazenda.gov.br/portal":U
           ttDanfe.conteudovariavel2 = "NÈMERO DE REGISTRO DPEC":U.
/*===================================================================================================================================================*/



/*=====================================================================================================================================================
  ITENS DA NOTA FISCAL
=====================================================================================================================================================*/

ASSIGN i-cont-itens = 1.

FOR EACH ttDet NO-LOCK:

    CREATE ttDanfeItem.
    ASSIGN ttDanfeItem.iSeq           = i-cont-itens
           ttDanfeItem.cprod          = ttDet.cProd
           ttDanfeItem.descitem       = ttDet.xProd + ttDet.infAdProd
           ttDanfeItem.ncm            = ttDet.NCM
           ttDanfeItem.cfop           = ttDet.CFOP
           /*Comercial*/
           ttDanfeItem.u              = ttDet.uCom
           ttDanfeItem.quantitem      = STRING(ttDet.qCom, "->>>,>>>,>>>,>>9.99<<":U).
    ASSIGN ttDanfeItem.vlunit         = STRING(ROUND(DEC(ttDet.vUnCom), fn-retorna-nro-decimais-nfe-FT0301()),">>>>>>>>>>>>>>9.99<<<<<<<<"). /*STRING(ttDet.vUnCom, "->,>>>,>>>,>>>,>>9.99<<<<<<<<":U)*/ /*COMENTADO - n∆o enviar sempre 10 decimais, e sim o que estiver parametrizado no FT0301*/
           
    ASSIGN /*Tribut†vel*/
           ttDanfeItem.u-trib         = ttDet.uTrib
           ttDanfeItem.quantitem-trib = STRING(ttDet.qTrib, "->>>,>>>,>>>,>>9.99<<":U).
    ASSIGN ttDanfeItem.vlunit-trib    = STRING(ROUND(DEC(ttDet.vUnTrib),fn-retorna-nro-decimais-nfe-FT0301()),">>>>>>>>>>>>>>9.99<<<<<<<<"). /*STRING(ttDet.vUnTrib, "->,>>>,>>>,>>>,>>9.99<<<<<<<<":U)*/ /*COMENTADO - n∆o enviar sempre 10 decimais, e sim o que estiver parametrizado no FT0301*/
    
    ASSIGN ttDanfeItem.vltotitem      = STRING(ttDet.vProd, "->>>,>>>,>>>,>>>,>>9.99":U)
           /*ttDanfeItem.infAdProd      =*/
           /*ttDanfeItem.textoitem      =*/ .

    FOR EACH ttICMSDanfe:
        DELETE ttICMSDanfe.
    END.

    /*--- Valores e Informaá‰es conforme tributaá∆o do ICMS --*/
    ASSIGN ttDanfeItem.vlbcicmit    = STRING(0, "->>>,>>>,>>>,>>9.99":U)
           ttDanfeItem.vlicmit      = STRING(0, "->>>,>>>,>>>,>>9.99":U)
           ttDanfeItem.icm          = STRING(0, "->>9.99":U)
           ttDanfeItem.vlbcicmit-st = STRING(0, "->>>,>>>,>>>,>>9.99":U)
           ttDanfeItem.vlicmit-st   = STRING(0, "->>>,>>>,>>>,>>9.99":U).

    /*Tratamento NT2011.004 - Para ICMS40, com Valor de Desoneraá∆o de ICMS, imprimir valor 0 no DANFE. No XML, o valor continua sendo impresso na tag vICMS*/
    FOR FIRST ttICMS40
        WHERE ttICMS40.CodEstabelNF = ttDet.CodEstabelNF
          AND ttICMS40.SerieNF      = ttDet.SerieNF     
          AND ttICMS40.NrNotaFisNF  = ttDet.NrNotaFisNF 
          AND ttICMS40.NrSeqFatNF   = ttDet.NrSeqFatNF
          AND ttICMS40.itcodigonf   = ttDet.ItCodigoNF
          AND ttICMS40.motDesICMS   = "7" :  /*Motivo da Desoneraá∆o do ICMS = 7 - SUFRAMA*/
          
        ASSIGN ttICMS40.vICMS = 0.    
    END.
    /*FIM Tratamento NT2011.004 - Para ICMS40, com Valor de Desoneraá∆o de ICMS, imprimir valor 0*/

    {ftp/ft0518f.i6 ttICMS00}
    {ftp/ft0518f.i6 ttICMS10}
    {ftp/ft0518f.i6 ttICMS20}
    {ftp/ft0518f.i6 ttICMS30}
    {ftp/ft0518f.i6 ttICMS40}
    {ftp/ft0518f.i6 ttICMS51}
    {ftp/ft0518f.i6 ttICMS60}
    {ftp/ft0518f.i6 ttICMS70}
    {ftp/ft0518f.i6 ttICMS90}
    /*--- Fim - Valores e Informaá‰es conforme tributaá∆o do ICMS --*/
    
    /*--- Valores e Informaá‰es de IPI --*/
    ASSIGN ttDanfeItem.vlipiit = STRING(0, "->>>,>>>,>>>,>>9.99":U)
           ttDanfeItem.ipi     = STRING(0, "->>9.99":U).

    FOR FIRST ttIPI
       WHERE ttIPI.CodEstabelNF = ttDet.CodEstabelNF
         AND ttIPI.SerieNF      = ttDet.SerieNF     
         AND ttIPI.NrNotaFisNF  = ttDet.NrNotaFisNF 
         AND ttIPI.NrSeqFatNF   = ttDet.NrSeqFatNF
         AND ttIPI.ItCodigoNF   = ttDet.ItCodigoNF 
         AND ttIPI.l-ipi-trib   <> ?: /* quando l-ipi-trib = YES indica que tributa IPI */
        
        ASSIGN ttDanfeItem.vlipiit = STRING({ftp/ft0518f.i8 ttIPI.vIPI}, "->>>,>>>,>>>,>>9.99":U)
               ttDanfeItem.ipi     = STRING({ftp/ft0518f.i8 ttIPI.pIPI}, "->>9.99":U).

    END.
    /*--- Fim - Valores e Informaá‰es de IPI --*/

    ASSIGN i-cont-itens = i-cont-itens + 1.
END.
/*===================================================================================================================================================*/
                      

DEFINE BUFFER bf-ttArquivo FOR ttArquivo.

FOR LAST bf-ttArquivo: END.
CREATE ttArquivo.
ASSIGN ttArquivo.sequencia   = IF AVAIL bf-ttArquivo THEN bf-ttArquivo.sequencia + 1 ELSE 1
       ttArquivo.nomeArquivo = TRIM(nota-fiscal.cod-estabel) + "-" + TRIM(nota-fiscal.serie) + "-" + TRIM(nota-fiscal.nr-nota-fis) + "-" + ".doc".


RUN ftp/ft0518f1.p(INPUT TABLE ttDanfe,
                   INPUT TABLE ttDanfeItem,
                   INPUT ttArquivo.nomeArquivo,
                   INPUT c-modelo-Danfe,
                   INPUT l-sem-Word,
                   INPUT l-reimp).

RETURN "OK":U.

/*fim*/
