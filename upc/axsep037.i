/*----------------------------------------------------------------------------------

    DEFINIÄÂES TEMP-TABLE

----------------------------------------------------------------------------------*/
 
DEFINE TEMP-TABLE ttAdi NO-UNDO
     FIELD cFabricante    AS CHARACTER INITIAL ?                                         /*C¢digo do fabricante estrangeiro (usado nos sistemas internos de informaá∆o do emitente da NF-e)*/
     FIELD nAdicao        AS CHARACTER INITIAL ?                                         /*N£mero da Adiá∆o*/
     FIELD nSeqAdic       AS CHARACTER INITIAL ?                                         /*N£mero seqÅencial do item dentro da Adiá∆o*/
     FIELD vDescDI        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do desconto do item da DI - adiá∆o*/ 
     FIELD nDraw          AS CHARACTER INITIAL ?                                         /*N£mero do ato concess¢rio de Drawback*/
     FIELD nDI            AS CHARACTER INITIAL ?                                         /*campo para ligaá∆o com a ttDI*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttDI CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF nDI.


DEFINE TEMP-TABLE ttArma NO-UNDO
     FIELD descr          AS CHARACTER INITIAL ?                                         /*Descriá∆o completa da arma, compreendendo: calibre, marca, capacidade, tipo de funcionamento, comprimento e demais elementos que permitam a sua perfeita identificaá∆o.*/
     FIELD nCano          AS CHARACTER INITIAL ?                                         /*N£mero de sÇrie do cano*/
     FIELD nSerie         AS CHARACTER INITIAL ?                                         /*N£mero de sÇrie da arma*/
     FIELD tpArma         AS CHARACTER INITIAL ?                                         /*Indicador do tipo de arma de fogo (0 - Uso permitido; 1 - Uso restrito)*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttArma CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttAutXML NO-UNDO
     FIELD CNPJ           AS CHARACTER INITIAL ?                                         /*CNPJ Autorizado*/
     FIELD CPF            AS CHARACTER INITIAL ?                                         /*CPF Autorizado*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttAutXML CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttAvulsa NO-UNDO
     FIELD CNPJ           AS CHARACTER INITIAL ?                                         /*CNPJ do ¢rg∆o emissor*/
     FIELD dEmi           AS DATE      INITIAL ?                                         /*Data de emiss∆o do DAR (AAAA-MM-DD)*/
     FIELD dPag           AS DATE      INITIAL ?                                         /*Data de pagamento do DAR (AAAA-MM-DD)*/
     FIELD fone           AS CHARACTER INITIAL ?                                         /*Telefone*/
     FIELD matr           AS CHARACTER INITIAL ?                                         /*Matr°cula do agente*/
     FIELD nDAR           AS CHARACTER INITIAL ?                                         /*N£mero do Documento de Arrecadaá∆o de Receita*/
     FIELD repEmi         AS CHARACTER INITIAL ?                                         /*Repartiá∆o Fiscal emitente*/
     FIELD UF             AS CHARACTER INITIAL ?                                         /*Sigla da Unidade da Federaá∆o*/
     FIELD vDAR           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total constante no DAR*/ 
     FIELD xAgente        AS CHARACTER INITIAL ?                                         /*Nome do agente*/
     FIELD xOrgao         AS CHARACTER INITIAL ?                                         /*¢rg∆o emitente*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttAvulsa CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttCobr NO-UNDO
     FIELD nFat           AS CHARACTER INITIAL ?                                         /*N£mero da fatura*/
     FIELD vDesc          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do desconto da fatura*/ 
     FIELD vLiq           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor l°quido da fatura*/     
     FIELD vOrig          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor original da fatura*/    
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttCobr CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttCOFINSAliq NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situaá∆o Tribut†ria do COFINS. 01 Operaá∆o Tribut†vel - Base de C†lculo = Valor da Operaá∆o Al°quota Normal (Cumulativo/N∆o Cumulativo); 02 - Operaá∆o Tribut†vel - Base de Calculo = Valor da Operaá∆o (Al°quota Diferenciada) */
     FIELD pCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do COFINS (em percentual)*/ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do COFINS*/              
     FIELD vCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do COFINS*/                    
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttCOFINSAliq CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttCOFINSNT NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situaá∆o Tribut†ria do COFINS: 04 - Operaá∆o Tribut†vel - Tributaá∆o Monof†sica - (Al°quota Zero); 06 - Operaá∆o Tribut†vel - Al°quota Zero; 07 - Operaá∆o Isenta da contribuiá∆o; 08 - Operaá∆o Sem Incidància da contribuiá∆o; 09 - Operaá∆o com suspens∆o da contribuiá∆o */
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttCOFINSNT CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttCOFINSOutr NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situaá∆o Tribut†ria do COFINS: 99 - Outras Operaá‰es.*/
     FIELD pCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"          DECIMALS 4  /*Al°quota do COFINS (em percentual)*/ 
     FIELD qBCProd        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.9999" DECIMALS 4  /*Quantidade Vendida */                
     FIELD vAliqProd      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.9999"  DECIMALS 4  /*Al°quota do COFINS (em reais)*/      
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor da BC do COFINS*/              
     FIELD vCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do COFINS*/                    
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttCOFINSOutr CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttCOFINSQtde NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situaá∆o Tribut†ria do COFINS. 03 - Operaá∆o Tribut†vel - Base de Calculo = Quantidade Vendida x Al°quota por Unidade de Produto */
     FIELD qBCProd        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.9999" DECIMALS 4  /*Quantidade Vendida */           
     FIELD vAliqProd      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.9999"  DECIMALS 4  /*Al°quota do COFINS (em reais)*/ 
     FIELD vCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do COFINS*/               
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttCOFINSQtde CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttCOFINSST NO-UNDO
     FIELD pCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"          DECIMALS 4  /*Al°quota do COFINS ST(em percentual)*/ 
     FIELD qBCProd        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.9999" DECIMALS 4  /*Quantidade Vendida */                  
     FIELD vAliqProd      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.9999"  DECIMALS 4  /*Al°quota do COFINS ST(em reais)*/      
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor da BC do COFINS ST*/             
     FIELD vCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do COFINS ST*/                   
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttCOFINSST CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttICMSUFDest NO-UNDO
     FIELD vBCUFDest      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor da Base de C†lculo do ICMS na UF do destinat†rio*/
     FIELD pFCPUFDest     AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"          DECIMALS 4  /*Percentual adicional inserido na al°quota interna da UF de destino, relativo ao Fundo de Combate Ö Pobreza (FCP) naquela UF*/
     FIELD pICMSUFDest    AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"          DECIMALS 4  /*Al°quota adotada nas operaá‰es internas na UF do destinat†rio para o produto / mercadoria*/
     FIELD pICMSInter     AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"          DECIMALS 4  /*Al°quota interestadual das UF envolvidas: - 4% al°quota interestadual para produtos importados; - 7% para os Estados de origem do Sul e Sudeste (exceto ES), destinado para os Estados do Norte e Nordeste  ou ES; - 12% para os demais casos*/
     FIELD pICMSInterPart AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"          DECIMALS 4  /*Percentual de partilha para a UF do destinat†rio: - 40% em 2016; - 60% em 2017; - 80% em 2018; - 100% a partir de 2019*/
     FIELD vFCPUFDest     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do ICMS relativo ao Fundo de Combate Ö Pobreza (FCP) da UF de destino*/
     FIELD vICMSUFDest    AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do ICMS de partilha para a UF do destinat†rio*/
     FIELD vICMSUFRemet   AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do ICMS de partilha para a UF do remetente. Nota: A partir de 2019, este valor ser† zero*/
     FIELD vBCFCPUFDest   AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor da Base de C†lculo do FCP na UF do destinat†rio*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ICMSUFDest CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttComb NO-UNDO
     FIELD cProdANP       AS CHARACTER INITIAL ?                                         /*C¢digo de produto da ANP Informar apenas quando se tratar de produtos regulados pela ANP - Agància Nacional do Petr¢leo. Utilizar a codificaá∆o de produtos do Sistema de Informaá‰es de Movimentaá∆o de produtos - SIMP (http://www.anp.gov.br/simp/index.htm)*/
     FIELD descANP        AS CHARACTER INITIAL ?                                         /*Descriá∆o do produto conforme ANP. Utilizar a descriá∆o de produtos do Sistema de Informaá‰es de Movimentaá∆o de Produtos - SIMP (http://www.anp.gov.br/simp/)*/
     FIELD pGLP           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"           DECIMALS 4 /*Percentual do GLP derivado do petr¢leo no produto GLP*/ 
     FIELD pGNn           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"           DECIMALS 4 /*Percentual de G†s Natural Nacional Œ GLGNn para o produto GLP*/ 
     FIELD pGNi           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"           DECIMALS 4 /*Percentual de G†s Natural Importado Œ GLGNi para o produto GLP*/ 
     FIELD vPart          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"   DECIMALS 2 /*Valor de partida. Deve ser informado neste campo o valor por quilograma sem ICMS*/
     FIELD CODIF          AS CHARACTER INITIAL ?                                         /*C¢digo de autorizaá∆o / registro do CODIF. Informar apenas quando a UF utilizar o CODIF (Sistema de Controle do Diferimento do Imposto nas Operaá‰es com AEAC - µlcool Et°lico Anidro Combust°vel).*/
     FIELD qTemp          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.9999"  DECIMALS 4 /*Quantidade de combust°vel faturada - temperatura ambiente. Informar quando a quantidade faturada informada no campo qCom (I10) tiver sido ajustada para uma temperatura diferente da ambiente.*/ 
     FIELD UFCons         AS CHARACTER INITIAL ?                                         /*Sigla da UF Dest*/
     /*CIDE*/
     FIELD qBCProd        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.9999"  DECIMALS 4 /*BC do CIDE ( Quantidade comercializada) */  
     FIELD vAliqProd      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.9999"   DECIMALS 4 /*Al°quota do CIDE  (em reais)*/ 
     FIELD vCIDE          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"   DECIMALS 2 /*Valor do CIDE*/ 
     /*encerrante*/
     FIELD nBico          AS CHARACTER INITIAL ?                                         /*N£mero do bico utilizado no abastecimento*/
     FIELD nBomba         AS CHARACTER INITIAL ?                                         /*Caso exista, informar o n£mero da bomba utilizada*/
     FIELD nTanque        AS CHARACTER INITIAL ?                                         /*N£mero do tanque utilizado*/
     FIELD vEncIni        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.999"   DECIMALS 3 /*Valor da leitura do contador (Encerrante) no in°cio do abastecimento*/
     FIELD vEncFin        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.999"   DECIMALS 3 /*Valor da leitura do contador (Encerrante) no tÇrmino do abastecimento*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttComb CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttCompra NO-UNDO
     FIELD xCont          AS CHARACTER INITIAL ?                                         /*Informaá∆o do contrato*/
     FIELD xNEmp          AS CHARACTER INITIAL ?                                         /*Informaá∆o da Nota de Empenho de compras p£blicas*/
     FIELD xPed           AS CHARACTER INITIAL ?                                         /*Informaá∆o do pedido*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttCompra IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttDest NO-UNDO
     FIELD CEP            AS CHARACTER INITIAL ?                                         /*CEP*/
     FIELD cMun           AS CHARACTER INITIAL ?                                         /*C¢digo do munic°pio (utilizar a tabela do IBGE), informar 9999999 para operaá‰es com o exterior.*/
     FIELD CNPJ           AS CHARACTER INITIAL ?                                         /*N£mero do CNPJ*/
     FIELD cPais          AS CHARACTER INITIAL ?                                         /*C¢digo do pa°s*/
     FIELD CPF            AS CHARACTER INITIAL ?                                         /*N£mero do CPF*/
     FIELD fone           AS CHARACTER INITIAL ?                                         /*Telefone*/
     FIELD IE             AS CHARACTER INITIAL ?                                         /*Inscriá∆o Estadual (obrigat¢rio nas operaá‰es com contribuintes do ICMS)*/
     FIELD ISUF           AS CHARACTER INITIAL ?                                         /*Inscriá∆o na SUFRAMA (Obrigat¢rio nas operaá‰es com as †reas com benef°cios de incentivos fiscais sob controle da SUFRAMA)*/
     FIELD nro            AS CHARACTER INITIAL ?                                         /*N£mero*/
     FIELD UF             AS CHARACTER INITIAL ?                                         /*Sigla da UF, , informar EX para operaá‰es com o exterior.*/
     FIELD xBairro        AS CHARACTER INITIAL ?                                         /*Bairro*/
     FIELD xCpl           AS CHARACTER INITIAL ?                                         /*Complemento*/
     FIELD xLgr           AS CHARACTER INITIAL ?                                         /*Logradouro*/
     FIELD xMun           AS CHARACTER INITIAL ?                                         /*Nome do munic°pio, , informar EXTERIOR para operaá‰es com o exterior.*/
     FIELD xNome          AS CHARACTER INITIAL ?                                         /*Raz∆o Social ou nome do destinat†rio*/
     FIELD xPais          AS CHARACTER INITIAL ?                                         /*Nome do pa°s*/
     FIELD i-natureza     AS INTEGER                                                     /* Campo do EMS, para identificar se pessoa F°sica ou Jur°dica [Campo: emitente.natureza] */
     FIELD email          AS CHARACTER INITIAL ?                                         /* E-mail do destinat†rio */
     FIELD idEstrangeiro  AS CHARACTER INITIAL ?                                         /*Identificador do destinat†rio, em caso de comprador estrangeiro (Informar esta tag no caso de operaá∆o com o exterior, ou para comprador estrangeiro. Informar o n£mero do  assaporte ou outro documento legal para identificar pessoa estrangeira.)*/
     FIELD indIEDest      AS CHARACTER INITIAL ?                                         /*Indicador da IE do destinat†rio: 1=Contribuinte ICMS (informar a IE do destinat†rio); 2=Contribuinte isento de Inscriá∆o no cadastro de Contribuintes do ICMS; 9=N∆o Contribuinte, que pode ou n∆o possuir Inscriá∆o Estadual no Cadastro de Contribuintes do ICMS*/
     FIELD IM             AS CHARACTER INITIAL ?                                         /*Inscriá∆o Municipal do tomador do serviáo*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttDest IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttDet NO-UNDO
     FIELD cEAN           AS CHARACTER INITIAL ?                                                /*GTIN (Global Trade Item Number) do produto, antigo c¢digo EAN ou c¢digo de barras*/
     FIELD cEANTrib       AS CHARACTER INITIAL ?                                                /*GTIN (Global Trade Item Number) da unidade tribut†vel, antigo c¢digo EAN ou c¢digo de barras*/
     FIELD CFOP           AS CHARACTER INITIAL ?                                                /*C¢digo Fiscal de Operaá‰es e Prestaá‰es*/
     FIELD cProd          AS CHARACTER INITIAL ?                                                /*C¢digo do produto ou serviáo. Preencher com CFOP caso se trate de itens n∆o relacionados com mercadorias/produto e que o contribuinte n∆o possua codificaá∆o pr¢pria Formato îCFOP9999î.*/
     FIELD EXTIPI         AS CHARACTER INITIAL ?                                                /*C¢digo EX TIPI (3 posiá‰es)*/
     FIELD infAdProd      AS CHARACTER INITIAL ?                                                /*Informaá‰es adicionais do produto (norma referenciada, informaá‰es complementares, etc)*/
     FIELD NCM            AS CHARACTER INITIAL ?                                                /*C¢digo NCM (8 posiá‰es) ou genero (2 posiá‰es)*/
     FIELD qCom           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.9999"  DECIMALS 4       /*Quantidade Comercial*/  
     FIELD qTrib          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.9999"  DECIMALS 4       /*Quantidade Tribut†vel*/
     FIELD uCom           AS CHARACTER INITIAL ?                                                /*Unidade comercial*/
     FIELD uTrib          AS CHARACTER INITIAL ?                                                /*Unidade Tribut†vel*/
     FIELD vDesc          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2         /*Valor do Desconto*/ 
     FIELD vFrete         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2         /*Valor Total do Frete*/ 
     FIELD vProd          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2         /*Valor bruto do produto ou serviáo*/ 
     FIELD vSeg           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2         /*Valor Total do Seguro*/ 
     FIELD vUnCom         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.9999999999" DECIMALS 10 /*Valor unit†rio de comercializaá∆o*/ 
     FIELD vUnTrib        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.9999999999" DECIMALS 10 /*Valor unit†rio de tributaá∆o*/
     FIELD xProd          AS CHARACTER INITIAL ?                                                /*Descriá∆o do produto ou serviáo*/
     FIELD vOutro         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2         /*Outras despesas acess¢rias*/
     FIELD indTot         AS CHARACTER INITIAL ?                                                /*Indica se valor do Item (vProd) entra no valor total da NF-e*/
     FIELD xPed           AS CHARACTER INITIAL ?                                                /*N£mero do Pedido de Compra*/
     FIELD nItemPed       AS CHARACTER INITIAL ?                                                /*Item do Pedido de Compra*/
     FIELD nFCI           AS CHARACTER INITIAL ?                                                /*N£mero FCI*/
     FIELD vTotTrib       AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2          /*Valor aproximado total de tributos federais, estaduais e municipais - NT2013.003*/
     FIELD NVE            AS CHARACTER INITIAL ?  EXTENT 8                                      /*Codificaá∆o NVE - Nomenclatura de Valor Aduaneiro e Estat°stica. (Ocorrencia 0-8) */
     FIELD nRECOPI        AS CHARACTER INITIAL ?                                                /*N£mero do RECOPI*/
     FIELD CEST           AS CHARACTER INITIAL ?                                                /*C¢digo Especificador da Substituiá∆o Tribut†ria Œ CEST*/
     FIELD indEscala      AS CHARACTER INITIAL ?                                                /*Indicador de Produá∆o em escala relevante, conforme Cl†usula 23 do Convenio ICMS 52/2017: S - Produzido em Escala Relevante; N Œ Produzido em Escala N«O Relevante*/
     FIELD CNPJFab        AS CHARACTER INITIAL ?                                                /*CNPJ do Fabricante da Mercadoria, obrigat¢rio para produto em escala N«O relevante.*/
     FIELD cBenef         AS CHARACTER INITIAL ?                                                /*C¢digo de Benef°cio Fiscal utilizado pela UF, aplicado ao item. Obs.: Deve ser utilizado o mesmo c¢digo adotado na EFD e outras declaraá‰es, nas UF que o exigem.*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttDet CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttDetExport NO-UNDO
     FIELD nDraw          AS CHARACTER INITIAL ?                                         /*N£mero do ato concess¢rio de Drawback*/
     FIELD nRE            AS CHARACTER INITIAL ?                                         /*N£mero do Registro de Exportaá∆o*/
     FIELD chNFe          AS CHARACTER INITIAL ?                                         /*Chave de Acesso da NF-e recebida para exportaá∆o*/
     FIELD qExport        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.9999" DECIMALS 4   /*Quantidade do item efetivamente exportado*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttDetExport CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttDI NO-UNDO
     FIELD cExportador    AS CHARACTER INITIAL ?                                         /*C¢digo do exportador (usado nos sistemas internos de informaá∆o do emitente da NF-e)*/
     FIELD dDesemb        AS DATE      INITIAL ?                                         /*Data do desembaraáo aduaneiro (AAAA-MM-DD)*/
     FIELD dDI            AS DATE      INITIAL ?                                         /*Data de registro da DI/DSI/DA (AAAA-MM-DD)*/
     FIELD nDI            AS CHARACTER INITIAL ?                                         /*Numero do Documento de Importaá∆o DI/DSI/DA (DI/DSI/DA)*/
     FIELD UFDesemb       AS CHARACTER INITIAL ?                                         /*UF onde ocorreu o desembaraáo aduaneiro*/
     FIELD xLocDesemb     AS CHARACTER INITIAL ?                                         /*Local do desembaraáo aduaneiro*/
     FIELD tpViaTransp    AS CHARACTER INITIAL ?                                         /*Via de transporte internacional informada na Declaraá∆o de Importaá∆o (DI) (1=Mar°tima; 2=Fluvial; 3=Lacustre; 4=AÇrea; 5=Postal 6=Ferrovi†ria; 7=Rodovi†ria; 8=Conduto / Rede Transmiss∆o; 9=Meios Pr¢prios; 10=Entrada / Sa°da ficta;)*/
     FIELD vAFRMM         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da AFRMM - Adicional ao Frete para Renovaá∆o da Marinha Mercante*/
     FIELD tpIntermedio   AS CHARACTER INITIAL ?                                         /*Forma de Importaá∆o quanto a intermediaá∆o  (1=Importaá∆o por conta pr¢pria; 2=Importaá∆o por conta e ordem; 3=Importaá∆o por encomenda)*/ 
     FIELD CNPJ           AS CHARACTER INITIAL ?                                         /*CNPJ do adquirente ou do encomendante*/
     FIELD UFTerceiro     AS CHARACTER INITIAL ?                                         /*Sigla da UF do adquirente ou do encomendante*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttDI CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttDup NO-UNDO
     FIELD dVenc          AS DATE      INITIAL ?                                         /*Data de vencimento da duplicata (AAAA-MM-DD)*/
     FIELD nDup           AS CHARACTER INITIAL ?                                         /*N£mero da duplicata*/
     FIELD vDup           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da duplicata*/ 
     FIELD nFat           AS CHARACTER INITIAL ?                                         /*Campo para ligaá∆o com a ttCobr*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttDup CodEstabelNF SerieNF NrNotaFisNF nFat.


DEFINE TEMP-TABLE ttEmit NO-UNDO
     FIELD CEP            AS CHARACTER INITIAL ?                                         /*CEP*/
     FIELD cMun           AS CHARACTER INITIAL ?                                         /*C¢digo do munic°pio (utilizar a tabela do IBGE), informar 9999999 para operaá‰es com o exterior.*/
     FIELD CNAE           AS CHARACTER INITIAL ?                                         /*CNAE Fiscal*/
     FIELD CNPJ           AS CHARACTER INITIAL ?                                         /*N£mero do CNPJ do emitente*/
     FIELD cPais          AS CHARACTER INITIAL ?                                         /*C¢digo do pa°s*/
     FIELD CPF            AS CHARACTER INITIAL ?                                         /*N£mero do CPF do emitente*/
     FIELD fone           AS CHARACTER INITIAL ?                                         /*Telefone*/
     FIELD IE             AS CHARACTER INITIAL ?                                         /*Inscriá∆o Estadual*/
     FIELD IEST           AS CHARACTER INITIAL ?                                         /*Inscricao Estadual do Substituto Tribut†rio*/
     FIELD IM             AS CHARACTER INITIAL ?                                         /*Inscriá∆o Municipal*/
     FIELD nro            AS CHARACTER INITIAL ?                                         /*N£mero*/
     FIELD UF             AS CHARACTER INITIAL ?                                         /*Sigla da UF, , informar EX para operaá‰es com o exterior.*/
     FIELD xBairro        AS CHARACTER INITIAL ?                                         /*Bairro*/
     FIELD xCpl           AS CHARACTER INITIAL ?                                         /*Complemento*/
     FIELD xFant          AS CHARACTER INITIAL ?                                         /*Nome fantasia*/
     FIELD xLgr           AS CHARACTER INITIAL ?                                         /*Logradouro*/
     FIELD xMun           AS CHARACTER INITIAL ?                                         /*Nome do munic°pio, , informar EXTERIOR para operaá‰es com o exterior.*/
     FIELD xNome          AS CHARACTER INITIAL ?                                         /*Raz∆o Social ou Nome do emitente*/
     FIELD xPais          AS CHARACTER INITIAL ?                                         /*Nome do pa°s*/
     FIELD CRT            AS CHARACTER INITIAL ?                                         /*C¢digo Regime Tribut†rio*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD VersaoLayout   AS CHARACTER INITIAL ?
     INDEX ch-ttEmit IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttEntrega NO-UNDO
     FIELD cMun           AS CHARACTER INITIAL ?                                         /*C¢digo do munic°pio (utilizar a tabela do IBGE)*/
     FIELD CNPJ           AS CHARACTER INITIAL ?                                         /*CNPJ*/
     FIELD CPF            AS CHARACTER INITIAL ?                                         /*CPF*/
     FIELD nro            AS CHARACTER INITIAL ?                                         /*N£mero*/
     FIELD UF             AS CHARACTER INITIAL ?                                         /*Sigla da UF*/
     FIELD xBairro        AS CHARACTER INITIAL ?                                         /*Bairro*/
     FIELD xCpl           AS CHARACTER INITIAL ?                                         /*Complemento*/
     FIELD xLgr           AS CHARACTER INITIAL ?                                         /*Logradouro*/
     FIELD xMun           AS CHARACTER INITIAL ?                                         /*Nome do munic°pio*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttEntrega IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttExporta NO-UNDO
     FIELD UFSaidaPais    AS CHARACTER INITIAL ?                                         /*Sigla da UF de Embarque ou de transposiá∆o de fronteira*/
     FIELD xLocExporta    AS CHARACTER INITIAL ?                                         /*Local de Embarque ou de transposiá∆o de fronteira*/
     FIELD xLocDespacho   AS CHARACTER INITIAL ?                                         /*Descriá∆o do local de despacho [Descriá∆o do Recinto Alfandegado ou do local onde foi efetivado o despacho para a exportaá∆o, conforme padronizaá∆o da RFB]*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttExporta IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttICMS00 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributá∆o pelo ICMS 00 - Tributada integralmente*/
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determinaá∆o da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Preáo Tabelado M†ximo (valor); 3 - Valor da Operaá∆o.*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do ICMS*/    
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/       
     FIELD pFCP           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do FCP*/
     FIELD vFCP           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do FCP*/       
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS00 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttICMS10 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*10 - Tributada e com cobranáa do ICMS por substituiá∆o tribut†ria */
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determinaá∆o da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Preáo Tabelado M†ximo (valor); 3 - Valor da Operaá∆o */
     FIELD modBCST        AS CHARACTER INITIAL ?                                         /*Modalidade de determinaá∆o da BC do ICMS ST: 0 - Preáo tabelado ou m†ximo  sugerido; 1 - Lista Negativa (valor); 2 - Lista Positiva (valor); 3 - Lista Neutra (valor); 4 - Margem Valor Agregado (%); 5 - Pauta (valor) */
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do ICMS*/ 
     FIELD pICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do ICMS ST*/ 
     FIELD pMVAST         AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual da Margem de Valor Adicionado ICMS ST*/ 
     FIELD pRedBCST       AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual de reduá∆o da BC ICMS ST */ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
     FIELD vBCST          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS ST*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/ 
     FIELD vICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS ST*/ 
     FIELD vBCFCP         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do FCP*/ 
     FIELD pFCP           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do FCP*/
     FIELD vFCP           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do FCP*/       
     FIELD vBCFCPST       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do FCP ST*/ 
     FIELD pFCPST         AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do FCP ST*/
     FIELD vFCPST         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do FCP ST*/       
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS10 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttICMS20 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributá∆o pelo ICMS 20 - Com reduá∆o de base de c†lculo*/
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determinaá∆o da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Preáo Tabelado M†ximo (valor); 3 - Valor da Operaá∆o.*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do ICMS*/ 
     FIELD pRedBC         AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual de reduá∆o da BC*/ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/ 
     FIELD vICMSDeson     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS de desoneraá∆o*/ 
     FIELD motDesICMS     AS CHARACTER INITIAL ?                                         /*Motivo da desoneraá∆o do ICMS:3-Uso na agropecu†ria;9-Outros;12-Fomento agropecu†rio*/
     FIELD vBCFCP         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do FCP*/ 
     FIELD pFCP           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do FCP*/
     FIELD vFCP           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do FCP*/       
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?   
     INDEX ch-ttICMS20 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttICMS30 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributá∆o pelo ICMS 30 - Isenta ou n∆o tributada e com cobranáa do ICMS por substituiá∆o tribut†ria */
     FIELD modBCST        AS CHARACTER INITIAL ?                                         /*Modalidade de determinaá∆o da BC do ICMS ST: 0 - Preáo tabelado ou m†ximo  sugerido; 1 - Lista Negativa (valor); 2 - Lista Positiva (valor); 3 - Lista Neutra (valor); 4 - Margem Valor Agregado (%); 5 - Pauta (valor).*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do ICMS ST*/ 
     FIELD pMVAST         AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual da Margem de Valor Adicionado ICMS ST*/
     FIELD pRedBCST       AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual de reduá∆o da BC ICMS ST */ 
     FIELD vBCST          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS ST*/ 
     FIELD vICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS ST*/ 
     FIELD vICMSDeson     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS de desoneraá∆o*/ 
     FIELD motDesICMS     AS CHARACTER INITIAL ?                                         /*Motivo da desoneraá∆o do ICMS:6-Utilit†rios Motocicleta Aµrea Livre;7-SUFRAMA;9-Outros*/
     FIELD vBCFCPST       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do FCP ST*/ 
     FIELD pFCPST         AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do FCP ST*/
     FIELD vFCPST         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do FCP ST*/       
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS30 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttICMS40 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributaá∆o pelo ICMS 40 - Isenta 41 - N∆o tributada 50 - Suspens∆o 51 - Diferimento */
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD vICMSDeson     AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2    /*Valor do ICMS de desoneraá∆o*/ 
     FIELD motDesICMS     AS CHARACTER INITIAL ?                                         /*Motivo da desoneraá∆o do ICMS: 1 Œ T†xi; 3 Œ Produtor Agropecu†rio; 4 Œ Frotista/Locadora; 5 Œ Diplom†tico/Consular; 6 Œ Utilit†rios e Motocicletas da Amazìnia Ocidental e µreas de Livre ComÇrcio (Resoluá∆o 714/88 e 790/94 Œ CONTRAN e suas alteraá‰es); 7 Œ SUFRAMA; 8 - Venda a ¢rg∆o P£blico; 9 Œ Outros 10- Deficiente Condutor 11- Deficiente n∆o condutor*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS40 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttICMS51 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributá∆o pelo ICMS 20 - Com reduá∆o de base de c†lculo*/
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determinaá∆o da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Preáo Tabelado M†ximo (valor); 3 - Valor da Operaá∆o.*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do ICMS*/ 
     FIELD pRedBC         AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual de reduá∆o da BC*/ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/
     FIELD vICMSOp        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS da Operaá∆o*/
     FIELD pDif           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual do diferimento*/
     FIELD vICMSDif       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS da diferido*/
     FIELD vBCFCP         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do FCP*/ 
     FIELD pFCP           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do FCP*/
     FIELD vFCP           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do FCP*/       
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS51 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttICMS60 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributaá∆o pelo ICMS 60 - ICMS cobrado anteriormente por substituiá∆o tribut†ria */
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD vBCSTRet       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS ST retido anteriormente*/ 
     FIELD pST            AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Aliquota suportada pelo Consumidor Final*/
     FIELD vICMSSTRet     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS ST retido anteriormente*/ 
     FIELD vBCFCPSTRet    AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do FCP ST Ret*/ 
     FIELD pFCPSTRet      AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do FCP ST Ret*/
     FIELD vFCPSTRet      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do FCP ST Ret*/       
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS60 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttICMS70 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributá∆o pelo ICMS 70 - Com reduá∆o de base de c†lculo e cobranáa do ICMS por substituiá∆o tribut†ria */
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determinaá∆o da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Preáo Tabelado M†ximo (valor); 3 - Valor da Operaá∆o.*/
     FIELD modBCST        AS CHARACTER INITIAL ?                                         /*Modalidade de determinaá∆o da BC do ICMS ST: 0 - Preáo tabelado ou m†ximo  sugerido; 1 - Lista Negativa (valor); 2 - Lista Positiva (valor); 3 - Lista Neutra (valor); 4 - Margem Valor Agregado (%); 5 - Pauta (valor).*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do ICMS*/ 
     FIELD pICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do ICMS ST*/ 
     FIELD pMVAST         AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual da Margem de Valor Adicionado ICMS ST*/ 
     FIELD pRedBC         AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual de reduá∆o da BC*/ 
     FIELD pRedBCST       AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual de reduá∆o da BC ICMS ST */ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
     FIELD vBCST          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS ST*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/ 
     FIELD vICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS ST*/ 
     FIELD vICMSDeson     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS de desoneraá∆o*/ 
     FIELD motDesICMS     AS CHARACTER INITIAL ?                                         /*Motivo da desoneraá∆o do ICMS:3-Uso na agropecu†ria;9-Outros;12-Fomento agropecu†rio*/
     FIELD vBCFCP         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do FCP*/ 
     FIELD pFCP           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do FCP*/
     FIELD vFCP           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do FCP*/       
     FIELD vBCFCPST       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do FCP ST*/ 
     FIELD pFCPST         AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do FCP ST*/
     FIELD vFCPST         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do FCP ST*/       
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS70 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttICMS90 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributá∆o pelo ICMS 90 - Outras*/
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determinaá∆o da BC do ICMS:  0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Preáo Tabelado M†ximo (valor); 3 - Valor da Operaá∆o.*/
     FIELD modBCST        AS CHARACTER INITIAL ?                                         /*Modalidade de determinaá∆o da BC do ICMS ST: 0 - Preáo tabelado ou m†ximo  sugerido;  1 - Lista Negativa (valor); 2 - Lista Positiva (valor); 3 - Lista Neutra (valor); 4 - Margem Valor Agregado (%);  5 - Pauta (valor).*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do ICMS*/ 
     FIELD pICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do ICMS ST*/ 
     FIELD pMVAST         AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual da Margem de Valor Adicionado ICMS ST*/ 
     FIELD pRedBC         AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual de reduá∆o da BC*/ 
     FIELD pRedBCST       AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual de reduá∆o da BC ICMS ST */ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
     FIELD vBCST          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS ST*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/ 
     FIELD vICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS ST*/ 
     FIELD vICMSDeson     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS de desoneraá∆o*/ 
     FIELD motDesICMS     AS CHARACTER INITIAL ?                                         /*Motivo da desoneraá∆o do ICMS:3-Uso na agropecu†ria;9-Outros;12-Fomento agropecu†rio*/
     FIELD vBCFCP         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do FCP*/ 
     FIELD pFCP           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do FCP*/
     FIELD vFCP           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do FCP*/       
     FIELD vBCFCPST       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do FCP ST*/ 
     FIELD pFCPST         AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do FCP ST*/
     FIELD vFCPST         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do FCP ST*/       
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS90 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttICMSTot NO-UNDO
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*BC do ICMS*/                 
     FIELD vBCST          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*BC do ICMS ST*/              
     FIELD vCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do COFINS*/            
     FIELD vDesc          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total do Desconto*/    
     FIELD vFrete         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total do Frete*/       
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total do ICMS*/        
     FIELD vII            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total do II*/          
     FIELD vIPI           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total do IPI*/          
     FIELD vNF            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total da NF-e*/        
     FIELD vOutro         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Outras Despesas acess¢rias*/ 
     FIELD vPIS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do PIS*/               
     FIELD vProd          AS DECIMAL   INITIAL ?                                         /*Valor Total dos produtos e serviáos*/
     FIELD vSeg           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total do Seguro*/      
     FIELD vST            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total do ICMS ST*/     
     FIELD vTotTrib       AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor aproximado total de tributos federais, estaduais e municipais - NT2013.003*/
     FIELD vICMSDeson     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total do ICMS desonerado*/ 
     FIELD vFCPUFDest     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total do ICMS relativo ao Fundo de Combate Ö Pobreza (FCP) para a UF de destino.*/
     FIELD vICMSUFDest    AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total do ICMS de partilha para a UF do destinat†rio*/
     FIELD vICMSUFRemet   AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total do ICMS de partilha para a UF do remetente*/
     FIELD vFCP           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total do FCP*/
     FIELD vFCPST         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total do FCP ST*/
     FIELD vFCPSTRet      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total do FCP ST Ret*/
     FIELD vIPIDevol      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2  /*Valor do IPI devolvido*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttICMSTot IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttIde NO-UNDO
     FIELD cDV            AS CHARACTER INITIAL ?                                         /*Digito Verificador da Chave de Acesso da NF-e*/
     FIELD cMunFG         AS CHARACTER INITIAL ?                                         /*C¢digo do Munic°pio de Ocorrància do Fato Gerador (utilizar a tabela do IBGE)*/
     FIELD cNF            AS CHARACTER INITIAL ?                                         /*C¢digo numÇrico que comp‰e a Chave de Acesso. N£mero aleat¢rio gerado pelo emitente para cada NF-e.*/
     FIELD cUF            AS CHARACTER INITIAL ?                                         /*C¢digo da UF do emitente do Documento Fiscal. Utilizar a Tabela do IBGE.*/
     FIELD dhEmi          AS CHARACTER INITIAL ?                                         /*Data e Hora de emiss∆o do Documento Fiscal (Formato AAAA-MM-DDThh:mm:ssTZD (UTC - Universal Coordinated Time))*/
     FIELD dhSaiEnt       AS CHARACTER INITIAL ?                                         /*Data e Hora de Sa°da da Mercadoria/Produto. No caso da NF de entrada, esta Ç a Data e Hora de entrada. (Formato AAAA-MM-DDThh:mm:ssTZD (UTC - Universal Coordinated Time))*/
     FIELD finNFe         AS CHARACTER INITIAL ?                                         /*Finalidade da emiss∆o da NF-e: 1=NF-e normal; 2=NF-e complementar; 3=NF-e de ajuste; 4=Devoluá∆o/Retorno.*/
     FIELD mod            AS CHARACTER INITIAL ?                                         /*C¢digo do modelo do Documento Fiscal. Utilizar 55 para identificaá∆o da NF-e, emitida em substituiá∆o ao modelo 1 e 1A.*/
     FIELD natOp          AS CHARACTER INITIAL ?                                         /*Descriá∆o da Natureza da Operaá∆o*/
     FIELD nNF            AS CHARACTER INITIAL ?                                         /*N£mero do Documento Fiscal*/
     FIELD procEmi        AS CHARACTER INITIAL ?                                         /*Processo de emiss∆o utilizado com a seguinte codificaá∆o: 0 - emiss∆o de NF-e com aplicativo do contribuinte; 1 - emiss∆o de NF-e avulsa pelo Fisco; 2 - emiss∆o de NF-e avulsa, pelo contribuinte com seu certificado digital, atravÈs do site do Fisco; 3- emiss∆o de NF-e pelo contribuinte com aplicativo fornecido pelo Fisco.*/
     FIELD serie          AS CHARACTER INITIAL ?                                         /*SÇrie do Documento Fiscal*/
     FIELD tpAmb          AS CHARACTER INITIAL ?                                         /*Identificaá∆o do Ambiente: 1 - Produá∆o 2 - Homologaá∆o*/
     FIELD tpEmis         AS CHARACTER INITIAL ?                                         /*Forma de emiss∆o da NF-e (1=Emiss∆o normal (n∆o em contingància); 2=Contingància FS-IA, com impress∆o do DANFE em formul†rio de seguranáa; 3=Contingància SCAN (Sistema de Contingància  do Ambiente Nacional); 4=Contingància EPEC (Declaraá∆o PrÇvia da Emiss∆o em Contingància); 5=Contingància FS-DA, com impress∆o do DANFE em formul†rio de seguranáa; 6=Contingància SVC-AN (SEFAZ Virtual de Contingància do AN); 7=Contingància SVC-RS (SEFAZ Virtual de Contingància do RS); 9=Contingància off-line da NFC-e)*/
     FIELD tpImp          AS CHARACTER INITIAL ?                                         /*Formato do DANFE (0=Sem geraá∆o de DANFE; 1=DANFE normal, Retrato; 2=DANFE normal, Paisagem; 3=DANFE Simplificado; 4=DANFE NFC-e; 5=DANFE NFC-e em mensagem eletrìnica. */
     FIELD tpNF           AS CHARACTER INITIAL ?                                         /*Tipo do Documento Fiscal (0 - entrada; 1 - sa°da)*/
     FIELD verProc        AS CHARACTER INITIAL ?                                         /*vers∆o do aplicativo utilizado no processo de emiss∆o*/
     FIELD dhCont         AS CHARACTER INITIAL ?                                         /*Data/hora entrada em contingencia (Formato AAAA-MM-DDThh:mm:ssTZD (UTC - Universal Coordinated Time))*/
     FIELD xJust          AS CHARACTER INITIAL ?                                         /*Justificada entrada em contingencia*/
     FIELD idDest         AS CHARACTER INITIAL ?                                         /*Identificador de Local de destino da operaá∆o (1=Operaá∆o interna; 2=Operaá∆o interestadual; 3=Operaá∆o com exterior.)*/
     FIELD indFinal       AS CHARACTER INITIAL ?                                         /*Indica operaá∆o com Consumidor final (0=N∆o; 1=Consumidor final;)*/
     FIELD indPres        AS CHARACTER INITIAL ?                                         /*Indicador de presenáa do comprador no estabelecimento comercial no momento da oepraá∆o (0-N∆o se aplica (ex.: Nota Fiscal complementar ou de ajuste;1-Operaá∆o presencial;2-N∆o presencial, internet;3-N∆o presencial, teleatendimento;4-NFC-e entrega em domic°lio;9-N∆o presencial, outros)*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttIde IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttII NO-UNDO
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Base da BC do Imposto de Importaá∆o*/          
     FIELD vDespAdu       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor das despesas aduaneiras*/                
     FIELD vII            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do Imposto de Importaá∆o*/               
     FIELD vIOF           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do Imposto sobre Operaá‰es Financeiras*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttII CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttImpostoDevol NO-UNDO
     FIELD pDevol         AS DECIMAL   INITIAL ?  FORMAT ">>9.99"            DECIMALS 2  /*Percentual de mercadoria devolvida*/ 
     FIELD vIPIDevol      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do IPI devolvido*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttImpostoDevol CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttInfAdic NO-UNDO
     FIELD infAdFisco     AS CHARACTER INITIAL ?                                         /*Informaá‰es adicionais de interesse do Fisco*/
     FIELD infCpl         AS CHARACTER INITIAL ?                                         /*Informaá‰es complementares de interesse do Contribuinte*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttInfAdic IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttIPI NO-UNDO
     FIELD cEnq           AS CHARACTER INITIAL ?                                         /*C¢digo de Enquadramento Legal do IPI (tabela a ser criada pela RFB)*/
     FIELD clEnq          AS CHARACTER INITIAL ?                                         /*Classe de Enquadramento do IPI para Cigarros e Bebidas*/
     FIELD CNPJProd       AS CHARACTER INITIAL ?                                         /*CNPJ do produtor da mercadoria, quando diferente do emitente. Somente para os casos de exportaá∆o direta ou indireta.*/
     FIELD cSelo          AS CHARACTER INITIAL ?                                         /*C¢digo do selo de controle do IPI */
     FIELD CSTIPINT       AS CHARACTER INITIAL ?                                         /*C¢digo da Situaá∆o Tribut†ria do IPI: 01-Entrada tributada com al°quota zero 02-Entrada isenta 03-Entrada n∆o-tributada 04-Entrada imune 05-Entrada com suspens∆o 51-Sa°da tributada com al°quota zero 52-Sa°da isenta 53-Sa°da n∆o-tributada 54-Sa°da imune 55-Sa°da com suspens∆o*/
     FIELD CSTIPITrib     AS CHARACTER INITIAL ?                                         /*C¢digo da Situaá∆o Tribut†ria do IPI: 00-Entrada com recuperaá∆o de crÈdito 49 - Outras entradas 50-Sa°da tributada 99-Outras sa°das*/ 
     FIELD pIPI           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"          DECIMALS 4  /*Al°quota do IPI*/ 
     FIELD qSelo          AS CHARACTER INITIAL ?                                         /*Quantidade de selo de controle do IPI*/
     FIELD qUnid          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.9999" DECIMALS 4  /*Quantidade total na unidade padr∆o para tributaá∆o */ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor da BC do IPI*/ 
     FIELD vIPI           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do IPI*/ 
     FIELD vUnid          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.9999"  DECIMALS 4  /*Valor por Unidade Tribut†vel. Informar o valor do imposto Pauta por unidade de medida.*/ 
     FIELD l-ipi-trib     AS LOGICAL   INITIAL ?
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttIPI CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttISSQN NO-UNDO
     FIELD cListServ      AS CHARACTER INITIAL ?                                         /*C¢digo da lista de serviáos da LC 116/03 em que se classifica o seriváo, campo de interesse da Prefeitura, devendo ser informado nas NFe conjugadas, onde h† a prestaá∆o de serviáos sujeitos ao ISSQN e fornecimento de peáas sujeitas ao ICMS*/
     FIELD cMunFG         AS CHARACTER INITIAL ?                                         /*C¢digo do Munic°pio de Ocorrància do Fato Gerador (utilizar a tabela do IBGE)*/
     FIELD vAliq          AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do ISSQN*/    
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ISSQN*/ 
     FIELD vISSQN         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da do ISSQN*/    
     FIELD vDeducao       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor deduá∆o para reduá∆o da base de c†lculo*/
     FIELD vOutro         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor outras retená‰es*/
     FIELD vDescIncond    AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor desconto incondicionado*/
     FIELD vDescCond      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor desconto condicionado*/
     FIELD vISSRet        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Retená∆o ISS*/
     FIELD indISS         AS CHARACTER INITIAL ?                                         /*Exibilidade do ISS:1-Exig°vel;2-N∆o incidente;3-Isená∆o;4-Exportaá∆o;5-Imunidade;6-Exig.Susp. Judicial;7-Exig.Susp. ADM*/
     FIELD cServico       AS CHARACTER INITIAL ?                                         /*C¢digo do serviáo prestado dentro do munic°pio*/
     FIELD cMun           AS CHARACTER INITIAL ?                                         /*C¢digo do Munic°pio de Incidància do Imposto*/
     FIELD cPais          AS CHARACTER INITIAL ?                                         /*C¢digo do pa°s onde o serviáo foi prestado*/
     FIELD nProcesso      AS CHARACTER INITIAL ?                                         /*N£mero do Processo administrativo ou judicial de suspená∆o do processo*/
     FIELD indIncentivo   AS CHARACTER INITIAL ?                                         /*Indicador de Incentivo Fiscal. 1=Sim; 2=N∆o*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttISSQN CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttISSQNtot NO-UNDO
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Base de C†lculo do ISS*/         
     FIELD vCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do COFINS sobre serviáos*/ 
     FIELD vISS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total do ISS*/             
     FIELD vPIS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do PIS sobre serviáos*/    
     FIELD vServ          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total dos Serviáos sob n∆o-incidància ou n∆o tributados pelo ICMS */ 
     FIELD dCompet        AS DATE      INITIAL ?                                         /*Data da prestaá∆o do serviáo  (AAAA-MM-DD)*/
     FIELD vDeducao       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor deduá∆o para reduá∆o da base de c†lculo*/
     FIELD vOutro         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor outras retená‰es*/
     FIELD vDescIncond    AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor desconto incondicionado*/
     FIELD vDescCond      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor desconto condicionado*/
     FIELD vISSRet        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total Retená∆o ISS*/
     FIELD cRegTrib       AS CHARACTER INITIAL ?                                         /*C¢digo do regime especial de tributaá∆o*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttISSQNtot IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttLacres NO-UNDO
     FIELD nLacre         AS CHARACTER INITIAL ?                                         /*N£mero dos Lacres*/
     FIELD nVol           AS CHARACTER INITIAL ?                                         /*campo para ligaá∆o com a ttVol*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttLacres IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF nVol.


DEFINE TEMP-TABLE ttRastro NO-UNDO /*Detalhamento de produto sujeito a rastreabilidade*/
     FIELD nLote          AS CHARACTER INITIAL ?                                   /*N£mero do Lote do produto*/
     FIELD qLote          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>9.999" DECIMALS 3 /*Quantidade de produto no Lote*/
     FIELD dFab           AS DATE      INITIAL ?                                   /*Data de fabricaá∆o/ Produá∆o*/
     FIELD dVal           AS DATE      INITIAL ?                                   /*Data de validade*/
     FIELD cAgreg         AS CHARACTER INITIAL ?                                   /*C¢digo de Agregaá∆o*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttRastro CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttMed NO-UNDO
     FIELD cProdANVISA    AS CHARACTER INITIAL ?                                         /*C¢digo de Produto da ANVISA. Utilizar o n£mero do registro do produto da CÉmara de Regulaá∆o do Mercado de Medicamento Œ CMED*/
     FIELD vPMC           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Preáo M†ximo ao Consumidor*/     
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttMed CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttNFe NO-UNDO
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ChaveAcessoNFe AS CHARACTER INITIAL ?
     FIELD VersaoLayout   AS CHARACTER INITIAL ?
     INDEX ch-ttNFe IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttrefNF NO-UNDO
     FIELD AAMM           AS CHARACTER INITIAL ?                                         /*AAMM da emiss∆o*/
     FIELD CNPJ           AS CHARACTER INITIAL ?                                         /*CNPJ do emitente do documento fiscal referenciado*/
     FIELD cUF            AS CHARACTER INITIAL ?                                         /*C¢digo da UF do emitente do Documento Fiscal. Utilizar a Tabela do IBGE.*/
     FIELD mod            AS CHARACTER INITIAL ?                                         /*C¢digo do modelo do Documento Fiscal. Utilizar 01 para NF modelo 1/1A*/
     FIELD nNF            AS CHARACTER INITIAL ?                                         /*N£mero do Documento Fiscal*/
     FIELD refNFe         AS CHARACTER INITIAL ?                                         /*Chave de acesso das NF-e referenciadas. Chave de acesso compostas por C¢digo da UF (tabela do IBGE) + AAMM da emiss∆o + CNPJ do Emitente + modelo, sÈrie e n£mero da NF-e Referenciada + C¢digo NumÈrico + DV.*/
     FIELD serie          AS CHARACTER INITIAL ?                                         /*SÇrie do Documento Fiscal, informar zero se inexistente*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttrefNF     CodEstabelNF SerieNF NrNotaFisNF nNF
     INDEX ch-ttrefNF2    refNFe.


DEFINE TEMP-TABLE ttObsCont NO-UNDO
     FIELD xCampo         AS CHARACTER INITIAL ? /*Atributo*/
     FIELD xTexto         AS CHARACTER INITIAL ? /*Valor*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttObsCont IS PRIMARY CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttObsFisco NO-UNDO
     FIELD xCampo         AS CHARACTER INITIAL ? /*Atributo*/
     FIELD xTexto         AS CHARACTER INITIAL ? /*Valor*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttObsFisco IS PRIMARY CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttPISAliq NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situaá∆o Tribut†ria do PIS. 01 - Operaá∆o Tribut†vel - Base de C†lculo = Valor da Operaá∆o Al°quota Normal (Cumulativo/N∆o Cumulativo); 02 - Operaá∆o Tribut†vel - Base de Calculo = Valor da Operaá∆o (Al°quota Diferenciada) */
     FIELD pPIS           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota do PIS (em percentual)*/ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do PIS*/              
     FIELD vPIS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do PIS*/                    
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttPISAliq CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttPISNT NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situaá∆o Tribut†ria do PIS. 04 - Operaá∆o Tribut†vel - Tributaá∆o Monof†sica - (Al°quota Zero); 06 - Operaá∆o Tribut†vel - Al°quota Zero; 07 - Operaá∆o Isenta da contribuiá∆o; 08 - Operaá∆o Sem Incidància da contribuiá∆o; 09 - Operaá∆o com suspens∆o da contribuiá∆o */
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttPISNT CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttPISOutr NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situaá∆o Tribut†ria do PIS. 99 - Outras Operaá‰es.*/
     FIELD pPIS           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"          DECIMALS 4  /*Al°quota do PIS (em percentual)*/ 
     FIELD qBCProd        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.9999" DECIMALS 4  /*Quantidade Vendida */             
     FIELD vAliqProd      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.9999"  DECIMALS 4  /*Al°quota do PIS (em reais)*/      
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor da BC do PIS*/              
     FIELD vPIS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do PIS*/                    
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttPISOutr CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttPISQtde NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situaá∆o Tribut†ria do PIS. 03 - Operaá∆o Tribut†vel - Base de Calculo = Quantidade Vendida x Al°quota por Unidade de Produto */
     FIELD qBCProd        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.9999" DECIMALS 4  /*Quantidade Vendida */ 
     FIELD vAliqProd      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.9999"  DECIMALS 4  /*Al°quota do PIS (em reais)*/ 
     FIELD vPIS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do PIS*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttPISQtde CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttPISST NO-UNDO
     FIELD pPIS           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"          DECIMALS 4  /*Al°quota do PIS ST (em percentual)*/ 
     FIELD qBCProd        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.9999" DECIMALS 4  /*Quantidade Vendida */                
     FIELD vAliqProd      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.9999"  DECIMALS 4  /*Al°quota do PIS ST (em reais)*/      
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor da BC do PIS ST*/              
     FIELD vPIS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do PIS ST*/                    
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttPISST CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttProcRef NO-UNDO
     FIELD indProc        AS CHARACTER INITIAL ?                                         /*Origem do processo, informar com: 0 - SEFAZ; 1 - Justiáa Federal; 2 - Justiáa Estadual; 3 - Secex/RFB; 9 - Outros*/
     FIELD nProc          AS CHARACTER INITIAL ?                                         /*Indentificador do processo ou ato concess¢rio*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttProcRef CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttReboque NO-UNDO
     FIELD placa          AS CHARACTER INITIAL ?                                         /*Placa do ve°culo*/
     FIELD RNTC           AS CHARACTER INITIAL ?                                         /*Registro Nacional de Transportador de Carga (ANTT)*/
     FIELD UF             AS CHARACTER INITIAL ?                                         /*Sigla da UF*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttReboque CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttRetirada NO-UNDO
     FIELD cMun           AS CHARACTER INITIAL ?                                         /*C¢digo do munic°pio (utilizar a tabela do IBGE)*/
     FIELD CNPJ           AS CHARACTER INITIAL ?                                         /*CNPJ*/
     FIELD CPF            AS CHARACTER INITIAL ?                                         /*CPF*/
     FIELD nro            AS CHARACTER INITIAL ?                                         /*N£mero*/
     FIELD UF             AS CHARACTER INITIAL ?                                         /*Sigla da UF*/
     FIELD xBairro        AS CHARACTER INITIAL ?                                         /*Bairro*/
     FIELD xCpl           AS CHARACTER INITIAL ?                                         /*Complemento*/
     FIELD xLgr           AS CHARACTER INITIAL ?                                         /*Logradouro*/
     FIELD xMun           AS CHARACTER INITIAL ?                                         /*Nome do munic°pio*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttRetirada IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttRetTrib NO-UNDO
     FIELD vBCIRRF        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Base de C†lculo do IRRF*/ 
     FIELD vBCRetPrev     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Base de C†lculo da Retená∆o da Previdàncica Social*/ 
     FIELD vIRRF          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Retido de IRRF*/    
     FIELD vRetCOFINS     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Retido de COFINS*/  
     FIELD vRetCSLL       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Retido de CSLL*/    
     FIELD vRetPIS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Retido de PIS*/     
     FIELD vRetPrev       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da Retená∆o da Previdàncica Social*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttRetTrib IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttTransp NO-UNDO
     FIELD CFOP           AS CHARACTER INITIAL ?                                         /*C¢digo Fiscal de Operaá‰es e Prestaá‰es*/
     FIELD cMunFG         AS CHARACTER INITIAL ?                                         /*C¢digo do Munic°pio de Ocorrància do Fato Gerador (utilizar a tabela do IBGE)*/
     FIELD CNPJ           AS CHARACTER INITIAL ?                                         /*CNPJ do transportador*/
     FIELD CPF            AS CHARACTER INITIAL ?                                         /*CPF do transportador*/
     FIELD IE             AS CHARACTER INITIAL ?                                         /*Inscriá∆o Estadual*/
     FIELD modFrete       AS CHARACTER INITIAL ?                                         /*Modalidade do frete (0 - por conta do emitente; 1 - por conta do destinat†rio)*/
     FIELD pICMSRet       AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al°quota da Retená∆o*/ 
     FIELD placa          AS CHARACTER INITIAL ?                                         /*Placa do ve°culo*/
     FIELD RNTC           AS CHARACTER INITIAL ?                                         /*Registro Nacional de Transportador de Carga (ANTT)*/
     FIELD UF             AS CHARACTER INITIAL ?                                         /*Sigla da UF*/
     FIELD UFplaca        AS CHARACTER INITIAL ?                                         /*Sigla da UF do Ve°culo*/
     FIELD vBCRet         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*BC da Retená∆o do ICMS*/ 
     FIELD vICMSRet       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS Retido*/ 
     FIELD vServ          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do Serviáo*/     
     FIELD xEnder         AS CHARACTER INITIAL ?                                         /*Endereáo completo*/
     FIELD xMun           AS CHARACTER INITIAL ?                                         /*Nome do mun°cipio*/
     FIELD xNome          AS CHARACTER INITIAL ?                                         /*Raz∆o Social ou nome*/
     FIELD vagao          AS CHARACTER INITIAL ?                                         /*Identificaá∆o do vag∆o*/
     FIELD balsa          AS CHARACTER INITIAL ?                                         /*Identificaá∆o da balsa*/
     FIELD i-natureza     AS INTEGER                                                     /*Campo do EMS, para identificar se pessoa F°sica ou Jur°dica [Campo: transporte.natureza] */
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttTransp IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttVeic NO-UNDO
     FIELD anoFab         AS CHARACTER INITIAL ?                                         /*Ano de Fabricaá∆o*/
     FIELD anoMod         AS CHARACTER INITIAL ?                                         /*Ano Modelo de Fabricaá∆o*/
     FIELD cCor           AS CHARACTER INITIAL ?                                         /*Cor do ve°culo (c¢digo de cada montadora)*/
     FIELD chassi         AS CHARACTER INITIAL ?                                         /*Chassi do ve°culo*/
     FIELD cilin          AS CHARACTER INITIAL ?                                         /*cilin (potància)*/
     FIELD CMT            AS CHARACTER INITIAL ?                                         /*CMT*/
     FIELD cMod           AS CHARACTER INITIAL ?                                         /*C¢digo Marca Modelo (utilizar tabela RENAVAM)*/
     FIELD condVeic       AS CHARACTER INITIAL ?                                         /*Condiá∆o do ve°culo (1 - acabado; 2 - inacabado; 3 - semi-acabado)*/
     FIELD dist           AS CHARACTER INITIAL ?                                         /*DistÉncia entre eixos*/
     FIELD espVeic        AS CHARACTER INITIAL ?                                         /*EspÇcie de ve°culo (utilizar tabela RENAVAM)*/
     FIELD nMotor         AS CHARACTER INITIAL ?                                         /*N£mero do motor*/
     FIELD nSerie         AS CHARACTER INITIAL ?                                         /*Serial (sÇrie)*/
     FIELD pesoB          AS CHARACTER INITIAL ?                                         /*Peso bruto*/
     FIELD pesoL          AS CHARACTER INITIAL ?                                         /*Peso l°quido*/
     FIELD pot            AS CHARACTER INITIAL ?                                         /*Potància do motor*/
     FIELD tpComb         AS CHARACTER INITIAL ?                                         /*Tipo de combust°vel*/
     FIELD tpOp           AS CHARACTER INITIAL ?                                         /*Tipo da Operaá∆o (1 - Venda concession†ria; 2 - Faturamento direto; 3 - Venda direta; 0 - Outros)*/
     FIELD tpPint         AS CHARACTER INITIAL ?                                         /*Tipo de pintura*/
     FIELD tpVeic         AS CHARACTER INITIAL ?                                         /*Tipo de ve°culo (utilizar tabela RENAVAM)*/
     FIELD VIN            AS CHARACTER INITIAL ?                                         /*C¢digo do VIN (Vehicle Identification Number)*/
     FIELD xCor           AS CHARACTER INITIAL ?                                         /*Descriá∆o da cor*/
     FIELD cCorDENATRAN   AS CHARACTER INITIAL ?                                         /*C¢digo da Cor*/
     FIELD lota           AS CHARACTER INITIAL ?                                         /*Capacidade m†xima de lotaá∆o*/
     FIELD tpRest         AS CHARACTER INITIAL ?                                         /*Restriá∆o*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttVeic CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttVol NO-UNDO
     FIELD esp            AS CHARACTER INITIAL ?                                         /*EspÇcie dos volumes transportados*/
     FIELD marca          AS CHARACTER INITIAL ?                                         /*Marca dos volumes transportados*/
     FIELD nVol           AS CHARACTER INITIAL ?                                         /*Numeraá∆o dos volumes transportados*/
     FIELD pesoB          AS DECIMAL   INITIAL ?                                         /*Peso bruto (em kg)*/
     FIELD pesoL          AS DECIMAL   INITIAL ?                                         /*Peso l°quido (em kg)*/
     FIELD qVol           AS CHARACTER INITIAL ?                                         /*Quantidade de volumes transportados*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD SiglaEmb       AS CHARACTER INITIAL ?
     INDEX ch-ttVol IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF SiglaEmb.


DEFINE TEMP-TABLE ttrefNFP NO-UNDO
     FIELD cUF            AS CHARACTER INITIAL ?                                  /*C¢digo da UF do emitente do Documento Fiscal. Utilizar a Tabela do IBGE.*/
     FIELD AAMM           AS CHARACTER INITIAL ?                                  /*AAMM da emiss∆o*/
     FIELD CNPJ           AS CHARACTER INITIAL ?                                  /*CNPJ do emitente do documento fiscal referenciado*/
     FIELD CPF            AS CHARACTER INITIAL ?                                  /*CPF do emitente da NF de produtor*/
     FIELD IE             AS CHARACTER INITIAL ?                                  /*IE do emitente da NF de Produtor*/
     FIELD mod            AS CHARACTER INITIAL ?                                  /*C¢digo do modelo do Documento Fiscal. Utilizar 01 para NF modelo 1/1A*/
     FIELD serie          AS CHARACTER INITIAL ?                                  /*SÇrie do Documento Fiscal, informar zero se inexistente*/ 
     FIELD nNF            AS CHARACTER INITIAL ?                                  /*N£mero do Documento Fiscal*/     
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttNFRef     CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttrefCTe NO-UNDO
     FIELD refCTe         AS CHARACTER INITIAL ?                                  /*chave acesso CT-e emitido anteriormente, vinculada a NF-e*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttNFRef     CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttrefECF NO-UNDO
     FIELD mod            AS CHARACTER INITIAL ?                                  /*Modelo do Documento Fiscal*/
     FIELD nECF           AS CHARACTER INITIAL ?                                  /*n£mero de ordem seqÅencial do ECF que emitiu o Cupom Fiscal vinculado Ö NF-e*/
     FIELD nCOO           AS CHARACTER INITIAL ?                                  /*N£mero do Contador de Ordem de Operaá∆o - COO vinculado Ö NF-e*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttNFRef     CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttICMSPart NO-UNDO /*Partilha do ICMS entre a UF de origem e UF de destino ou a UF definida na legislaá∆o. */
     FIELD orig      AS CHARACTER INITIAL ?                                       /*Origem da mercadoria*/
     FIELD CST       AS CHARACTER INITIAL ?                                       /*Tributaá∆o do ICMS*/
     FIELD modBC     AS CHARACTER INITIAL ?                                       /*Modalidade de determinaá∆o*/
     FIELD vBC       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do ICMS*/
     FIELD pRedBC    AS DECIMAL   INITIAL ?  FORMAT ">>9.9999" DECIMALS 4         /*Percentual da Reduá∆o de BC*/
     FIELD pICMS     AS DECIMAL   INITIAL ?  FORMAT ">>9.9999" DECIMALS 4         /*Al°quota do imposto*/
     FIELD vICMS     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do ICMS*/
     FIELD modBCST   AS CHARACTER INITIAL ?                                       /*Modalidade de determinaá∆o da BC do ICMS ST*/
     FIELD pMVAST    AS DECIMAL   INITIAL ?  FORMAT ">>9.9999" DECIMALS 4         /*Percentual da margem de valor Adicionado do ICMS ST*/
     FIELD pRedBCST  AS DECIMAL   INITIAL ?  FORMAT ">>9.9999" DECIMALS 4         /*Percentual da Reduá∆o de BC do ICMS ST*/
     FIELD vBCST     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do ICMS ST*/
     FIELD pICMSST   AS DECIMAL   INITIAL ?  FORMAT ">>9.9999" DECIMALS 4         /*Al°quota do imposto do ICMS ST*/
     FIELD vICMSST   AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do ICMS ST*/
     FIELD pBCOp     AS DECIMAL   INITIAL ?  FORMAT ">>9.9999" DECIMALS 4         /*Percentual da BC operaá∆o pr¢pria*/
     FIELD UFST      AS CHARACTER INITIAL ?                                       /*UF para qual Ç devido o ICMS ST*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMSPart CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttICMSST NO-UNDO /*ICMS ST - repasse de ICMS ST retido anteriormente em operaá‰es interestaduais com repasses atravÇs do Substituto Tribut†rio*/
     FIELD orig           AS CHARACTER INITIAL ?                                       /*Origem da mercadoria*/
     FIELD CST            AS CHARACTER INITIAL ?                                       /*Tributaá∆o do ICMS*/
     FIELD vBCSTRet       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do BC do ICMS ST*/
     FIELD vICMSSTRet     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do ICMS ST retido na UF remetente*/
     FIELD vBCSTDest      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do ICMS ST da UF destino*/
     FIELD vICMSSTDest    AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do ICMS ST da UF destino*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMSST CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.    


DEFINE TEMP-TABLE ttICMSSN101 NO-UNDO /*Tributaá∆o do ICMS pelo SIMPLES NACIONAL e CSOSN=101*/
     FIELD Orig           AS CHARACTER INITIAL ?                                      /*Origem da mercadoria*/
     FIELD CSOSN          AS CHARACTER INITIAL ?                                      /*C¢digo de Situaá∆o da Operaá∆o - Simples Nacional*/
     FIELD pCredSN        AS DECIMAL   INITIAL ? FORMAT ">>9.9999" DECIMALS 4         /*Al°quota aplic†vel de c†lculo do crÇdito (Simples Nacional)*/
     FIELD vCredICMSSN    AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor crÇdito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional)*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMSSN101 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.  


DEFINE TEMP-TABLE ttICMSSN102 NO-UNDO /*Grupo CRT=1 - Simples Nacional e CSOSN=102, 103, 300 ou 400*/
     FIELD Orig           AS CHARACTER INITIAL ?                                      /*Origem da mercadoria*/
     FIELD CSOSN          AS CHARACTER INITIAL ?                                      /*C¢digo de Situaá∆o da Operaá∆o - Simples Nacional*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ttICMSSN102 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.  


DEFINE TEMP-TABLE ttICMSSN201 NO-UNDO /*Grupo CRT=1 - Simples Nacional e CSOSN=201*/
     FIELD Orig           AS CHARACTER INITIAL ?                                      /*Origem da mercadoria*/
     FIELD CSOSN          AS CHARACTER INITIAL ?                                      /*C¢digo de Situaá∆o da Operaá∆o - Simples Nacional*/
     FIELD modBCST        AS CHARACTER INITIAL ?                                      /*Modalidade de determinaá∆o da BC do ICMS ST*/
     FIELD pMVAST         AS DECIMAL   INITIAL ? FORMAT ">>9.9999" DECIMALS 4         /*Percentual da margem de valor Adicionado do ICMS ST*/
     FIELD pRedBCST       AS DECIMAL   INITIAL ? FORMAT ">>9.9999" DECIMALS 4         /*Percentual da Reduá∆o de BC do ICMS ST vBCST Valor da BC do ICMS ST*/
     FIELD vBCST          AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do ICMS ST*/
     FIELD pICMSST        AS DECIMAL   INITIAL ? FORMAT ">>9.9999" DECIMALS 4         /*Al°quota do imposto do ICMS ST*/
     FIELD vICMSST        AS DECIMAL   INITIAL ?                                      /*Valor do ICMS ST*/
     FIELD pCredSN        AS DECIMAL   INITIAL ? FORMAT ">>9.9999" DECIMALS 4         /*Al°quota aplic†vel de c†lculo do crÇdito (SIMPLES NACIONAL).*/
     FIELD vCredICMSSN    AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor crÇdito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (SIMPLES NACIONAL)*/
     FIELD vBCFCPST       AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do FCP ST*/ 
     FIELD pFCPST         AS DECIMAL   INITIAL ? FORMAT ">>9.9999"         DECIMALS 4 /*Al°quota do FCP ST*/
     FIELD vFCPST         AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do FCP ST*/       
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ttICMSSN201 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttICMSSN202 NO-UNDO /*Grupo CRT=1 - Simples Nacional e CSOSN=201*/
     FIELD Orig           AS CHARACTER INITIAL ?                                      /*Origem da mercadoria*/
     FIELD CSOSN          AS CHARACTER INITIAL ?                                      /*C¢digo de Situaá∆o da Operaá∆o - Simples Nacional*/
     FIELD modBCST        AS CHARACTER INITIAL ?                                      /*Modalidade de determinaá∆o da BC do ICMS ST*/
     FIELD pMVAST         AS DECIMAL   INITIAL ? FORMAT ">>9.9999" DECIMALS 4         /*Percentual da margem de valor Adicionado do ICMS ST*/
     FIELD pRedBCST       AS DECIMAL   INITIAL ? FORMAT ">>9.9999" DECIMALS 4         /*Percentual da Reduá∆o de BC do ICMS ST vBCST Valor da BC do ICMS ST*/
     FIELD vBCST          AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do ICMS ST*/
     FIELD pICMSST        AS DECIMAL   INITIAL ? FORMAT ">>9.9999" DECIMALS 4         /*Al°quota do imposto do ICMS ST*/
     FIELD vICMSST        AS DECIMAL   INITIAL ?                                      /*Valor do ICMS ST*/
     FIELD vBCFCPST       AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do FCP ST*/ 
     FIELD pFCPST         AS DECIMAL   INITIAL ? FORMAT ">>9.9999"         DECIMALS 4 /*Al°quota do FCP ST*/
     FIELD vFCPST         AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do FCP ST*/       
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ttICMSSN202 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttICMSSN500 NO-UNDO /*Grupo CRT=1 - Simples Nacional e CSOSN = 500*/
     FIELD Orig           AS CHARACTER INITIAL ?                                      /*Origem da mercadoria*/
     FIELD CSOSN          AS CHARACTER INITIAL ?                                      /*C¢digo de Situaá∆o da Operaá∆o - Simples Nacional*/
     FIELD vBCSTRet       AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do ICMS ST retido*/
     FIELD pST            AS DECIMAL   INITIAL ? FORMAT ">>9.9999"         DECIMALS 4 /*Aliquota suportada pelo Consumidor Final*/
     FIELD vICMSSTRet     AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do ICMS ST retido*/
     FIELD vBCFCPSTRet    AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do FCP ST Ret*/ 
     FIELD pFCPSTRet      AS DECIMAL   INITIAL ? FORMAT ">>9.9999"         DECIMALS 4 /*Al°quota do FCP ST Ret*/
     FIELD vFCPSTRet      AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do FCP ST Ret*/       
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ttICMSSN500 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttICMSSN900 NO-UNDO /*Grupo CRT=1 - Simples Nacional e CSOSN=900*/
     FIELD Orig           AS CHARACTER INITIAL ?                                      /*Origem da mercadoria*/
     FIELD CSOSN          AS CHARACTER INITIAL ?                                      /*C¢digo de Situaá∆o da Operaá∆o - SIMPLES NACIONAL*/
     FIELD modBC          AS CHARACTER INITIAL ?                                      /*Modalidade de determinaá∆o da BC do ICMS*/
     FIELD vBC            AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do ICMS*/
     FIELD pRedBC         AS DECIMAL   INITIAL ? FORMAT ">>9.9999" DECIMALS 4         /*Percentual da Reduá∆o de BC*/
     FIELD pICMS          AS DECIMAL   INITIAL ? FORMAT ">>9.9999" DECIMALS 4         /*Al°quota do imposto*/
     FIELD vICMS          AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do ICMS*/
     FIELD modBCST        AS CHARACTER INITIAL ?                                      /*Modalidade de determinaá∆o da BC do ICMS ST*/
     FIELD pMVAST         AS DECIMAL   INITIAL ? FORMAT ">>9.9999" DECIMALS 4         /*Percentual da margem de valor Adicionado do ICMS ST*/
     FIELD pRedBCST       AS DECIMAL   INITIAL ? FORMAT ">>9.9999" DECIMALS 4         /*Percentual da Reduá∆o de BC do ICMS ST*/
     FIELD vBCST          AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do ICMS ST*/
     FIELD pICMSST        AS DECIMAL   INITIAL ? FORMAT ">>9.9999" DECIMALS 4         /*Al°quota do imposto do ICMS ST*/
     FIELD vICMSST        AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do ICMS ST*/
     FIELD vBCSTRet       AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do ICMS ST retido*/
     FIELD vICMSSTRet     AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do ICMS ST retido*/
     FIELD pCredSN        AS DECIMAL   INITIAL ? FORMAT ">>9.9999" DECIMALS 4         /*Al°quota aplic†vel de c†lculo do crÇdito (SIMPLES NACIONAL).*/
     FIELD vCredICMSSN    AS DECIMAL   INITIAL ?                                      /*Valor crÇdito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (SIMPLES NACIONAL)*/
     FIELD vBCFCPST       AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do FCP ST*/ 
     FIELD pFCPST         AS DECIMAL   INITIAL ? FORMAT ">>9.9999"         DECIMALS 4 /*Al°quota do FCP ST*/
     FIELD vFCPST         AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do FCP ST*/       
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ttICMSSN900 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttCana NO-UNDO /*Grupo de cana*/
     FIELD safra           AS CHARACTER INITIAL ?                                             /*Identificaá∆o da safra*/
     FIELD ref             AS CHARACTER INITIAL ?                                             /*Màs e ano de referància*/
     FIELD qTotMes         AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>9.9999999999" DECIMALS 10 /*Quantidade Total do Màs*/
     FIELD qTotAnt         AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>9.9999999999" DECIMALS 10 /*Quantidade Total Anterior*/
     FIELD qTotGer         AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>9.9999999999" DECIMALS 10 /*Quantidade Total Geral*/
     FIELD vFor            AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2        /*Valor dos Fornecimentos*/
     FIELD vTotDed         AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2        /*Valor Total da Deduá∆o*/
     FIELD vLiqFor         AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2        /*Valor L°quido dos Fornecimentos*/
     /*Chave EMS*/
     FIELD CodEstabelNF    AS CHARACTER INITIAL ?
     FIELD SerieNF         AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF     AS CHARACTER INITIAL ?
     INDEX ch-ttCana CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttForDia NO-UNDO /*Grupo de Fornecimento di†rio de cana*/
     FIELD dia             AS CHARACTER INITIAL ?                                             /*Dia*/
     FIELD qtde            AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>9.9999999999" DECIMALS 10 /*Quantidade*/
     /*Chave EMS*/
     FIELD CodEstabelNF    AS CHARACTER INITIAL ?
     FIELD SerieNF         AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF     AS CHARACTER INITIAL ?
     INDEX ch-ttForDia CodEstabelNF SerieNF NrNotaFisNF.

     
DEFINE TEMP-TABLE ttDeduc NO-UNDO /*Grupo de Deduá‰es - Taxas e Contribuiá‰es*/
     FIELD xDed            AS CHARACTER INITIAL ?                                      /*Descriá∆o da Deduá∆o*/
     FIELD vDed            AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da Deduá∆o*/
     /*Chave EMS*/
     FIELD CodEstabelNF    AS CHARACTER INITIAL ?
     FIELD SerieNF         AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF     AS CHARACTER INITIAL ?
     INDEX ch-ttDeduc CodEstabelNF SerieNF NrNotaFisNF.


DEFINE TEMP-TABLE ttPag NO-UNDO
     FIELD vTroco          AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do Troco*/
     /*Chave EMS*/
     FIELD CodEstabelNF    AS CHARACTER INITIAL ?
     FIELD SerieNF         AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF     AS CHARACTER INITIAL ?
     INDEX ch-ttPag CodEstabelNF SerieNF NrNotaFisNF.
     

DEFINE TEMP-TABLE ttDetPag NO-UNDO
     FIELD tPag            AS CHARACTER INITIAL ?
     FIELD vPag            AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do Pagamento. Esta tag poder† ser omitida quando a tag tPag=90 (Sem Pagamento), caso contr†rio dever† ser preenchida.*/
     FIELD tpIntegra       AS CHARACTER INITIAL ?
     FIELD CNPJ            AS CHARACTER INITIAL ?
     FIELD tBand           AS CHARACTER INITIAL ?
     FIELD cAut            AS CHARACTER INITIAL ?
     /*Chave EMS*/
     FIELD CodEstabelNF    AS CHARACTER INITIAL ?
     FIELD SerieNF         AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF     AS CHARACTER INITIAL ?
     INDEX ch-ttDetPag CodEstabelNF SerieNF NrNotaFisNF.


/*--- TRATAMENTO CASAS DECIMAIS - XML/TXT e DANFE ---*/
FUNCTION fn-retorna-nro-decimais-nfe-FT0301 RETURNS INTEGER:

    DEFINE VARIABLE i-nro-decimais-nfe AS INTEGER     NO-UNDO.

    IF  NOT AVAIL para-fat THEN
        FIND FIRST para-fat NO-LOCK NO-ERROR.

    IF  AVAIL para-fat THEN DO:
        
        IF  INT(&IF "{&bf_dis_versao_ems}" >= "2.09" &THEN  /* FT0301 - Pasta C†lculos - Campo "Nro Decimais Val Unit NF-e" */
                  para-fat.num-dec-val-unit-nfe
                &ELSE
                  TRIM(SUBSTRING(para-fat.char-2,94,2))
                &ENDIF)
        <> 0 THEN
            ASSIGN i-nro-decimais-nfe = INT(STRING(&IF "{&bf_dis_versao_ems}" >= "2.09" &THEN  /* FT0301 - Pasta C†lculos - Campo "Nro Decimais Val Unit NF-e" */
                                                     para-fat.num-dec-val-unit-nfe
                                                   &ELSE
                                                     TRIM(SUBSTRING(para-fat.char-2,94,2))
                                                   &ENDIF)).
        ELSE
            ASSIGN i-nro-decimais-nfe = 10. /*Se o conte£do do novo campo n∆o estiver preenchido, imprime o m†ximo permitido no manual do contribuinte, que s∆o 10 */

        
        /*Ticket */
        FOR EACH tt-epc
            WHERE tt-epc.cod-event     = "AtualizaDecimais":U 
              AND tt-epc.cod-parameter = "nfe-ft0301":U:
            DELETE tt-epc.
        END.
        
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "AtualizaDecimais":U
               tt-epc.cod-parameter = "nfe-ft0301":U.
        
        {include/i-epc201.i "AtualizaDecimais"}
        
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event     = "AtualizaDecimais":U 
              AND tt-epc.cod-parameter = "nfe-ft0301":U
              AND tt-epc.val-parameter <> "":
            ASSIGN i-nro-decimais-nfe = int(tt-epc.val-parameter).
        END.
        /* TIcket */
        
        RETURN i-nro-decimais-nfe.

    END.

END FUNCTION.
/*--- FIM TRATAMENTO CASAS DECIMAIS - XML/TXT e DANFE ---*/


/*---------------------------------------------------------------------------------*/
