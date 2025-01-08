/*----------------------------------------------------------------------------------

    DEFINIÄÂES TEMP-TABLE

----------------------------------------------------------------------------------*/
 
DEFINE TEMP-TABLE ttAdi NO-UNDO
     FIELD cFabricante    AS CHARACTER INITIAL ?                                         /*C¢digo do fabricante estrangeiro (usado nos sistemas internos de informaá∆o do emitente da NF-e)*/
     FIELD nAdicao        AS CHARACTER INITIAL ?                                         /*N£mero da Adiá∆o*/
     FIELD nSeqAdic       AS CHARACTER INITIAL ?                                         /*N£mero seqÅencial do item dentro da Adiá∆o*/
     FIELD vDescDI        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do desconto do item da DI - adiá∆o*/ 
     FIELD nDI            AS CHARACTER INITIAL ?                                         /*campo para ligaá∆o com a ttDI*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttDI CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF nDI
.


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
     INDEX ch-ttArma CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


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
     INDEX ch-ttAvulsa CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttCobr NO-UNDO
     FIELD nFat           AS CHARACTER INITIAL ?                                         /*N£mero da fatura*/
     FIELD vDesc          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do desconto da fatura*/ 
     FIELD vLiq           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor l°quido da fatura*/     
     FIELD vOrig          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor original da fatura*/    
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttCobr CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttCOFINSAliq NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situaá∆o Tribut†ria do COFINS. 01 Operaá∆o Tribut†vel - Base de C†lculo = Valor da Operaá∆o Al°quota Normal (Cumulativo/N∆o Cumulativo); 02 - Operaá∆o Tribut†vel - Base de Calculo = Valor da Operaá∆o (Al°quota Diferenciada) */
     FIELD pCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al°quota do COFINS (em percentual)*/ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do COFINS*/              
     FIELD vCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do COFINS*/                    
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttCOFINSAliq CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttCOFINSNT NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situaá∆o Tribut†ria do COFINS: 04 - Operaá∆o Tribut†vel - Tributaá∆o Monof†sica - (Al°quota Zero); 06 - Operaá∆o Tribut†vel - Al°quota Zero; 07 - Operaá∆o Isenta da contribuiá∆o; 08 - Operaá∆o Sem Incidància da contribuiá∆o; 09 - Operaá∆o com suspens∆o da contribuiá∆o */
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttCOFINSNT CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttCOFINSOutr NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situaá∆o Tribut†ria do COFINS: 99 - Outras Operaá‰es.*/
     FIELD pCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>9.99"            DECIMALS 2  /*Al°quota do COFINS (em percentual)*/ 
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
     INDEX ch-ttCOFINSOutr CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


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
     INDEX ch-ttCOFINSQtde CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttCOFINSST NO-UNDO
     FIELD pCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>9.99"            DECIMALS 2  /*Al°quota do COFINS ST(em percentual)*/ 
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
     INDEX ch-ttCOFINSST CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttComb NO-UNDO
     FIELD CODIF          AS CHARACTER INITIAL ?                                         /*C¢digo de autorizaá∆o / registro do CODIF. Informar apenas quando a UF utilizar o CODIF (Sistema de Controle do Diferimento do Imposto nas Operaá‰es com AEAC - µlcool Et°lico Anidro Combust°vel).*/
     FIELD cProdANP       AS CHARACTER INITIAL ?                                         /*C¢digo de produto da ANP Informar apenas quando se tratar de produtos regulados pela ANP - Agància Nacional do Petr¢leo. Utilizar a codificaá∆o de produtos do Sistema de Informaá‰es de Movimentaá∆o de produtos - SIMP (http://www.anp.gov.br/simp/index.htm)*/
     FIELD qBCProd        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.9999"  DECIMALS 4 /*BC do CIDE ( Quantidade comercializada) */  
     FIELD qTemp          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.9999"  DECIMALS 4 /*Quantidade de combust°vel faturada - temperatura ambiente. Informar quando a quantidade faturada informada no campo qCom (I10) tiver sido ajustada para uma temperatura diferente da ambiente.*/ 
     FIELD UFCons         AS CHARACTER INITIAL ?                                         /*Sigla da UF Dest*/
     FIELD vAliqProd      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.9999"   DECIMALS 4 /*Al°quota do CIDE  (em reais)*/ 
     FIELD vCIDE          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.9999" DECIMALS 4 /*Valor do CIDE*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttComb CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttCompra NO-UNDO
     FIELD xCont          AS CHARACTER INITIAL ?                                         /*Informaá∆o do contrato*/
     FIELD xNEmp          AS CHARACTER INITIAL ?                                         /*Informaá∆o da Nota de Empenho de compras p£blicas*/
     FIELD xPed           AS CHARACTER INITIAL ?                                         /*Informaá∆o do pedido*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttCompra IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


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
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttDest IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


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
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttDet CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttDI NO-UNDO
     FIELD cExportador    AS CHARACTER INITIAL ?                                         /*C¢digo do exportador (usado nos sistemas internos de informaá∆o do emitente da NF-e)*/
     FIELD dDesemb        AS DATE      INITIAL ?                                         /*Data do desembaraáo aduaneiro (AAAA-MM-DD)*/
     FIELD dDI            AS DATE      INITIAL ?                                         /*Data de registro da DI/DSI/DA (AAAA-MM-DD)*/
     FIELD nDI            AS CHARACTER INITIAL ?                                         /*Numero do Documento de Importaá∆o DI/DSI/DA (DI/DSI/DA)*/
     FIELD UFDesemb       AS CHARACTER INITIAL ?                                         /*UF onde ocorreu o desembaraáo aduaneiro*/
     FIELD xLocDesemb     AS CHARACTER INITIAL ?                                         /*Local do desembaraáo aduaneiro*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttDI CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttDup NO-UNDO
     FIELD dVenc          AS DATE      INITIAL ?                                         /*Data de vencimento da duplicata (AAAA-MM-DD)*/
     FIELD nDup           AS CHARACTER INITIAL ?                                         /*N£mero da duplicata*/
     FIELD vDup           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da duplicata*/ 
     FIELD nFat           AS CHARACTER INITIAL ?                                         /*Campo para ligaá∆o com a ttCobr*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttDup CodEstabelNF SerieNF NrNotaFisNF nFat
.


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
     INDEX ch-ttEmit IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


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
     INDEX ch-ttEntrega IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttExporta NO-UNDO
     FIELD UFEmbarq       AS CHARACTER INITIAL ?                                         /*Sigla da UF onde ocorrer† o embarque dos produtos*/
     FIELD xLocEmbarq     AS CHARACTER INITIAL ?                                         /*Local onde ocorrer† o embarque dos produtos*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttExporta IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttICMS00 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributá∆o pelo ICMS 00 - Tributada integralmente*/
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determinaá∆o da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Preáo Tabelado M†ximo (valor); 3 - Valor da Operaá∆o.*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al°quota do ICMS*/    
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/       
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS00 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttICMS10 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*10 - Tributada e com cobranáa do ICMS por substituiá∆o tribut†ria */
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determinaá∆o da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Preáo Tabelado M†ximo (valor); 3 - Valor da Operaá∆o */
     FIELD modBCST        AS CHARACTER INITIAL ?                                         /*Modalidade de determinaá∆o da BC do ICMS ST: 0 - Preáo tabelado ou m†ximo  sugerido; 1 - Lista Negativa (valor); 2 - Lista Positiva (valor); 3 - Lista Neutra (valor); 4 - Margem Valor Agregado (%); 5 - Pauta (valor) */
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al°quota do ICMS*/ 
     FIELD pICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al°quota do ICMS ST*/ 
     FIELD pMVAST         AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Percentual da Margem de Valor Adicionado ICMS ST*/ 
     FIELD pRedBCST       AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Percentual de reduá∆o da BC ICMS ST */ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
     FIELD vBCST          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS ST*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/ 
     FIELD vICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS ST*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS10 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttICMS20 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributá∆o pelo ICMS 20 - Com reduá∆o de base de c†lculo*/
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determinaá∆o da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Preáo Tabelado M†ximo (valor); 3 - Valor da Operaá∆o.*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al°quota do ICMS*/ 
     FIELD pRedBC         AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Percentual de reduá∆o da BC*/ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?   
     INDEX ch-ttICMS20 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttICMS30 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributá∆o pelo ICMS 30 - Isenta ou n∆o tributada e com cobranáa do ICMS por substituiá∆o tribut†ria */
     FIELD modBCST        AS CHARACTER INITIAL ?                                         /*Modalidade de determinaá∆o da BC do ICMS ST: 0 - Preáo tabelado ou m†ximo  sugerido; 1 - Lista Negativa (valor); 2 - Lista Positiva (valor); 3 - Lista Neutra (valor); 4 - Margem Valor Agregado (%); 5 - Pauta (valor).*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al°quota do ICMS ST*/ 
     FIELD pMVAST         AS DECIMAL   INITIAL ?                                         /*Percentual da Margem de Valor Adicionado ICMS ST*/
     FIELD pRedBCST       AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Percentual de reduá∆o da BC ICMS ST */ 
     FIELD vBCST          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS ST*/ 
     FIELD vICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS ST*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS30 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttICMS40 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributaá∆o pelo ICMS 40 - Isenta 41 - N∆o tributada 50 - Suspens∆o 51 - Diferimento */
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD vICMS          AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2    /*Valor do ICMS*/
     FIELD motDesICMS     AS CHARACTER INITIAL ?                                         /*Motivo da desoneraá∆o do ICMS*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS40 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttICMS51 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributá∆o pelo ICMS 20 - Com reduá∆o de base de c†lculo*/
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determinaá∆o da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Preáo Tabelado M†ximo (valor); 3 - Valor da Operaá∆o.*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al°quota do ICMS*/ 
     FIELD pRedBC         AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Percentual de reduá∆o da BC*/ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS51 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttICMS60 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributaá∆o pelo ICMS 60 - ICMS cobrado anteriormente por substituiá∆o tribut†ria */
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD vBCSTRet       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS ST retido anteriormente*/ 
     FIELD vICMSSTRet     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS ST retido anteriormente*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS60 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttICMS70 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributá∆o pelo ICMS 70 - Com reduá∆o de base de c†lculo e cobranáa do ICMS por substituiá∆o tribut†ria */
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determinaá∆o da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Preáo Tabelado M†ximo (valor); 3 - Valor da Operaá∆o.*/
     FIELD modBCST        AS CHARACTER INITIAL ?                                         /*Modalidade de determinaá∆o da BC do ICMS ST: 0 - Preáo tabelado ou m†ximo  sugerido; 1 - Lista Negativa (valor); 2 - Lista Positiva (valor); 3 - Lista Neutra (valor); 4 - Margem Valor Agregado (%); 5 - Pauta (valor).*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al°quota do ICMS*/ 
     FIELD pICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al°quota do ICMS ST*/ 
     FIELD pMVAST         AS DECIMAL   INITIAL ?                                         /*Percentual da Margem de Valor Adicionado ICMS ST*/
     FIELD pRedBC         AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Percentual de reduá∆o da BC*/ 
     FIELD pRedBCST       AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Percentual de reduá∆o da BC ICMS ST */ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
     FIELD vBCST          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS ST*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/ 
     FIELD vICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS ST*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS70 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttICMS90 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributá∆o pelo ICMS 90 - Outras*/
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determinaá∆o da BC do ICMS:  0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Preáo Tabelado M†ximo (valor); 3 - Valor da Operaá∆o.*/
     FIELD modBCST        AS CHARACTER INITIAL ?                                         /*Modalidade de determinaá∆o da BC do ICMS ST: 0 - Preáo tabelado ou m†ximo  sugerido;  1 - Lista Negativa (valor); 2 - Lista Positiva (valor); 3 - Lista Neutra (valor); 4 - Margem Valor Agregado (%);  5 - Pauta (valor).*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al°quota do ICMS*/ 
     FIELD pICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al°quota do ICMS ST*/ 
     FIELD pMVAST         AS DECIMAL   INITIAL ?                                         /*Percentual da Margem de Valor Adicionado ICMS ST*/
     FIELD pRedBC         AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Percentual de reduá∆o da BC*/ 
     FIELD pRedBCST       AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Percentual de reduá∆o da BC ICMS ST */ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
     FIELD vBCST          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS ST*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/ 
     FIELD vICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS ST*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS90 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


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
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttICMSTot IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttIde NO-UNDO
     FIELD cDV            AS CHARACTER INITIAL ?                                         /*Digito Verificador da Chave de Acesso da NF-e*/
     FIELD cMunFG         AS CHARACTER INITIAL ?                                         /*C¢digo do Munic°pio de Ocorrància do Fato Gerador (utilizar a tabela do IBGE)*/
     FIELD cNF            AS CHARACTER INITIAL ?                                         /*C¢digo numÇrico que comp‰e a Chave de Acesso. N£mero aleat¢rio gerado pelo emitente para cada NF-e.*/
     FIELD cUF            AS CHARACTER INITIAL ?                                         /*C¢digo da UF do emitente do Documento Fiscal. Utilizar a Tabela do IBGE.*/
     FIELD dEmi           AS DATE      INITIAL ?                                         /*Data de emiss∆o do Documento Fiscal (AAAA-MM-DD)*/
     FIELD dSaiEnt        AS DATE      INITIAL ?                                         /*Data de sa°da ou de entrada da mercadoria / produto (AAAA-MM-DD)*/
     FIELD finNFe         AS CHARACTER INITIAL ?                                         /*Finalidade da emiss∆o da NF-e: 1 - NFe normal 2 - NFe complementar 3 - NFe de ajuste*/
     FIELD indPag         AS CHARACTER INITIAL ?                                         /*Indicador da forma de pagamento: 0 - pagamento Ö vista; 1 - pagamento ‡ prazo; 2 - outros.*/
     FIELD mod            AS CHARACTER INITIAL ?                                         /*C¢digo do modelo do Documento Fiscal. Utilizar 55 para identificaá∆o da NF-e, emitida em substituiá∆o ao modelo 1 e 1A.*/
     FIELD natOp          AS CHARACTER INITIAL ?                                         /*Descriá∆o da Natureza da Operaá∆o*/
     FIELD nNF            AS CHARACTER INITIAL ?                                         /*N£mero do Documento Fiscal*/
     FIELD procEmi        AS CHARACTER INITIAL ?                                         /*Processo de emiss∆o utilizado com a seguinte codificaá∆o: 0 - emiss∆o de NF-e com aplicativo do contribuinte; 1 - emiss∆o de NF-e avulsa pelo Fisco; 2 - emiss∆o de NF-e avulsa, pelo contribuinte com seu certificado digital, atravÈs do site do Fisco; 3- emiss∆o de NF-e pelo contribuinte com aplicativo fornecido pelo Fisco.*/
     FIELD serie          AS CHARACTER INITIAL ?                                         /*SÇrie do Documento Fiscal*/
     FIELD tpAmb          AS CHARACTER INITIAL ?                                         /*Identificaá∆o do Ambiente: 1 - Produá∆o 2 - Homologaá∆o*/
     FIELD tpEmis         AS CHARACTER INITIAL ?                                         /*Forma de emiss∆o da NF-e (1 - Normal; 2 - Contingància)*/
     FIELD tpImp          AS CHARACTER INITIAL ?                                         /*Formato de impress∆o do DANFE (1 - Retrato; 2 - Paisagem)*/
     FIELD tpNF           AS CHARACTER INITIAL ?                                         /*Tipo do Documento Fiscal (0 - entrada; 1 - sa°da)*/
     FIELD verProc        AS CHARACTER INITIAL ?                                         /*vers∆o do aplicativo utilizado no processo de emiss∆o*/
     FIELD dhCont         AS CHARACTER INITIAL ?                                         /*Data/hora entrada em contingencia*/
     FIELD xJust          AS CHARACTER INITIAL ?                                         /*Justificada entrada em contingencia*/
     FIELD hSaiEnt        AS CHARACTER INITIAL ?                                         /*Hora de Sa°da ou da Entrada da Mercadoria/Produto*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttIde IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


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
     INDEX ch-ttII CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttInfAdic NO-UNDO
     FIELD infAdFisco     AS CHARACTER INITIAL ?                                         /*Informaá‰es adicionais de interesse do Fisco*/
     FIELD infCpl         AS CHARACTER INITIAL ?                                         /*Informaá‰es complementares de interesse do Contribuinte*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttInfAdic IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttIPI NO-UNDO
     FIELD cEnq           AS CHARACTER INITIAL ?                                         /*C¢digo de Enquadramento Legal do IPI (tabela a ser criada pela RFB)*/
     FIELD clEnq          AS CHARACTER INITIAL ?                                         /*Classe de Enquadramento do IPI para Cigarros e Bebidas*/
     FIELD CNPJProd       AS CHARACTER INITIAL ?                                         /*CNPJ do produtor da mercadoria, quando diferente do emitente. Somente para os casos de exportaá∆o direta ou indireta.*/
     FIELD cSelo          AS CHARACTER INITIAL ?                                         /*C¢digo do selo de controle do IPI */
     FIELD CSTIPINT       AS CHARACTER INITIAL ?                                         /*C¢digo da Situaá∆o Tribut†ria do IPI: 01-Entrada tributada com al°quota zero 02-Entrada isenta 03-Entrada n∆o-tributada 04-Entrada imune 05-Entrada com suspens∆o 51-Sa°da tributada com al°quota zero 52-Sa°da isenta 53-Sa°da n∆o-tributada 54-Sa°da imune 55-Sa°da com suspens∆o*/
     FIELD CSTIPITrib     AS CHARACTER INITIAL ?                                         /*C¢digo da Situaá∆o Tribut†ria do IPI: 00-Entrada com recuperaá∆o de crÈdito 49 - Outras entradas 50-Sa°da tributada 99-Outras sa°das*/ 
     FIELD pIPI           AS DECIMAL   INITIAL ?  FORMAT ">>9.99"            DECIMALS 2  /*Al°quota do IPI*/ 
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
     INDEX ch-ttIPI CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttISSQN NO-UNDO
     FIELD cListServ      AS CHARACTER INITIAL ?                                         /*C¢digo da lista de serviáos da LC 116/03 em que se classifica o seriváo, campo de interesse da Prefeitura, devendo ser informado nas NFe conjugadas, onde h† a prestaá∆o de serviáos sujeitos ao ISSQN e fornecimento de peáas sujeitas ao ICMS*/
     FIELD cMunFG         AS CHARACTER INITIAL ?                                         /*C¢digo do Munic°pio de Ocorrància do Fato Gerador (utilizar a tabela do IBGE)*/
     FIELD vAliq          AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al°quota do ISSQN*/    
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ISSQN*/ 
     FIELD vISSQN         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da do ISSQN*/    
     FIELD cSitTrib       AS CHARACTER INITIAL ?                                         /*C¢digo de Tributaá∆o do ISSQN*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttISSQN CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttISSQNtot NO-UNDO
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Base de C†lculo do ISS*/         
     FIELD vCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do COFINS sobre serviáos*/ 
     FIELD vISS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total do ISS*/             
     FIELD vPIS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do PIS sobre serviáos*/    
     FIELD vServ          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total dos Serviáos sob n∆o-incidància ou n∆o tributados pelo ICMS */ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttISSQNtot IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttLacres NO-UNDO
     FIELD nLacre         AS CHARACTER INITIAL ?                                         /*N£mero dos Lacres*/
     FIELD nVol           AS CHARACTER INITIAL ?                                         /*campo para ligaá∆o com a ttVol*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttLacres IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF nVol
.


DEFINE TEMP-TABLE ttMed NO-UNDO
     FIELD dFab           AS DATE      INITIAL ?                                         /*Data de Fabricaá∆o do medicamento (AAAA-MM-DD)*/
     FIELD dVal           AS DATE      INITIAL ?                                         /*Data de validade do medicamento (AAAA-MM-DD)*/
     FIELD nLote          AS CHARACTER INITIAL ?                                         /*N£mero do lote do medicamento*/
     FIELD qLote          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>9.999"     DECIMALS 4   /*Quantidade de produtos no lote*/ 
     FIELD vPMC           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Preáo M†ximo ao Consumidor*/     
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttMed CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttNFe NO-UNDO
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ChaveAcessoNFe AS CHARACTER INITIAL ?
     FIELD VersaoLayout   AS CHARACTER INITIAL ?
     INDEX ch-ttNFe IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


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
     INDEX ch-ttrefNF2    refNFe
.


DEFINE TEMP-TABLE ttObsCont NO-UNDO
     FIELD xCampo         AS CHARACTER INITIAL ? /*Atributo*/
     FIELD xTexto         AS CHARACTER INITIAL ? /*Valor*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttObsCont IS PRIMARY CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttObsFisco NO-UNDO
     FIELD xCampo         AS CHARACTER INITIAL ? /*Atributo*/
     FIELD xTexto         AS CHARACTER INITIAL ? /*Valor*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttObsFisco IS PRIMARY CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttPISAliq NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situaá∆o Tribut†ria do PIS. 01 - Operaá∆o Tribut†vel - Base de C†lculo = Valor da Operaá∆o Al°quota Normal (Cumulativo/N∆o Cumulativo); 02 - Operaá∆o Tribut†vel - Base de Calculo = Valor da Operaá∆o (Al°quota Diferenciada) */
     FIELD pPIS           AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al°quota do PIS (em percentual)*/ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do PIS*/              
     FIELD vPIS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do PIS*/                    
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttPISAliq CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttPISNT NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situaá∆o Tribut†ria do PIS. 04 - Operaá∆o Tribut†vel - Tributaá∆o Monof†sica - (Al°quota Zero); 06 - Operaá∆o Tribut†vel - Al°quota Zero; 07 - Operaá∆o Isenta da contribuiá∆o; 08 - Operaá∆o Sem Incidància da contribuiá∆o; 09 - Operaá∆o com suspens∆o da contribuiá∆o */
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttPISNT CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttPISOutr NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situaá∆o Tribut†ria do PIS. 99 - Outras Operaá‰es.*/
     FIELD pPIS           AS DECIMAL   INITIAL ?  FORMAT ">>9.99"            DECIMALS 2  /*Al°quota do PIS (em percentual)*/ 
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
     INDEX ch-ttPISOutr CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


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
     INDEX ch-ttPISQtde CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttPISST NO-UNDO
     FIELD pPIS           AS DECIMAL   INITIAL ?  FORMAT ">>9.99"            DECIMALS 2  /*Al°quota do PIS ST (em percentual)*/ 
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
     INDEX ch-ttPISST CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttProcRef NO-UNDO
     FIELD indProc        AS CHARACTER INITIAL ?                                         /*Origem do processo, informar com: 0 - SEFAZ; 1 - Justiáa Federal; 2 - Justiáa Estadual; 3 - Secex/RFB; 9 - Outros*/
     FIELD nProc          AS CHARACTER INITIAL ?                                         /*Indentificador do processo ou ato concess¢rio*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttProcRef IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttReboque NO-UNDO
     FIELD placa          AS CHARACTER INITIAL ?                                         /*Placa do ve°culo*/
     FIELD RNTC           AS CHARACTER INITIAL ?                                         /*Registro Nacional de Transportador de Carga (ANTT)*/
     FIELD UF             AS CHARACTER INITIAL ?                                         /*Sigla da UF*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttReboque CodEstabelNF SerieNF NrNotaFisNF
.


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
     INDEX ch-ttRetirada IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


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
     INDEX ch-ttRetTrib IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttTransp NO-UNDO
     FIELD CFOP           AS CHARACTER INITIAL ?                                         /*C¢digo Fiscal de Operaá‰es e Prestaá‰es*/
     FIELD cMunFG         AS CHARACTER INITIAL ?                                         /*C¢digo do Munic°pio de Ocorrància do Fato Gerador (utilizar a tabela do IBGE)*/
     FIELD CNPJ           AS CHARACTER INITIAL ?                                         /*CNPJ do transportador*/
     FIELD CPF            AS CHARACTER INITIAL ?                                         /*CPF do transportador*/
     FIELD IE             AS CHARACTER INITIAL ?                                         /*Inscriá∆o Estadual*/
     FIELD modFrete       AS CHARACTER INITIAL ?                                         /*Modalidade do frete (0 - por conta do emitente; 1 - por conta do destinat†rio)*/
     FIELD pICMSRet       AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al°quota da Retená∆o*/ 
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
     INDEX ch-ttTransp IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


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
     INDEX ch-ttVeic CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.

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
     INDEX ch-ttVol IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF SiglaEmb
.

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
     INDEX ch-ttNFRef     CodEstabelNF SerieNF NrNotaFisNF
     .

DEFINE TEMP-TABLE ttrefCTe NO-UNDO
     FIELD refCTe         AS CHARACTER INITIAL ?                                  /*chave acesso CT-e emitido anteriormente, vinculada a NF-e*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttNFRef     CodEstabelNF SerieNF NrNotaFisNF
     .

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
     INDEX ch-ttNFRef     CodEstabelNF SerieNF NrNotaFisNF
     .

DEFINE TEMP-TABLE ttICMSPart NO-UNDO /*Partilha do ICMS entre a UF de origem e UF de destino ou a UF definida na legislaá∆o. */
     FIELD orig      AS CHARACTER INITIAL ?                                       /*Origem da mercadoria*/
     FIELD CST       AS CHARACTER INITIAL ?                                       /*Tributaá∆o do ICMS*/
     FIELD modBC     AS CHARACTER INITIAL ?                                       /*Modalidade de determinaá∆o*/
     FIELD vBC       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do ICMS*/
     FIELD pRedBC    AS DECIMAL   INITIAL ?  FORMAT ">>9.99" DECIMALS 2           /*Percentual da Reduá∆o de BC*/
     FIELD pICMS     AS DECIMAL   INITIAL ?  FORMAT ">>9.99" DECIMALS 2           /*Al°quota do imposto*/
     FIELD vICMS     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do ICMS*/
     FIELD modBCST   AS CHARACTER INITIAL ?                                       /*Modalidade de determinaá∆o da BC do ICMS ST*/
     FIELD pMVAST    AS DECIMAL   INITIAL ?  FORMAT ">>9.99" DECIMALS 2           /*Percentual da margem de valor Adicionado do ICMS ST*/
     FIELD pRedBCST  AS DECIMAL   INITIAL ?  FORMAT ">>9.99" DECIMALS 2           /*Percentual da Reduá∆o de BC do ICMS ST*/
     FIELD vBCST     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do ICMS ST*/
     FIELD pICMSST   AS DECIMAL   INITIAL ?  FORMAT ">>9.99" DECIMALS 2           /*Al°quota do imposto do ICMS ST*/
     FIELD vICMSST   AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do ICMS ST*/
     FIELD pBCOp     AS DECIMAL   INITIAL ?  FORMAT ">>9.99" DECIMALS 2           /*Percentual da BC operaá∆o pr¢pria*/
     FIELD UFST      AS CHARACTER INITIAL ?                                       /*UF para qual Ç devido o ICMS ST*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMSPart CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
     .

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
     INDEX ch-ttICMSST CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
     .    

DEFINE TEMP-TABLE ttICMSSN101 NO-UNDO /*Tributaá∆o do ICMS pelo SIMPLES NACIONAL e CSOSN=101*/
     FIELD Orig           AS CHARACTER INITIAL ?                                      /*Origem da mercadoria*/
     FIELD CSOSN          AS CHARACTER INITIAL ?                                      /*C¢digo de Situaá∆o da Operaá∆o - Simples Nacional*/
     FIELD pCredSN        AS DECIMAL   INITIAL ? FORMAT ">>9.99" DECIMALS 2           /*Al°quota aplic†vel de c†lculo do crÇdito (Simples Nacional)*/
     FIELD vCredICMSSN    AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor crÇdito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional)*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMSSN101 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
     .  

DEFINE TEMP-TABLE ttICMSSN102 NO-UNDO /*Grupo CRT=1 - Simples Nacional e CSOSN=102, 103, 300 ou 400*/
     FIELD Orig           AS CHARACTER INITIAL ?                                      /*Origem da mercadoria*/
     FIELD CSOSN          AS CHARACTER INITIAL ?                                      /*C¢digo de Situaá∆o da Operaá∆o - Simples Nacional*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ttICMSSN102 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
     .  

DEFINE TEMP-TABLE ttICMSSN201 NO-UNDO /*Grupo CRT=1 - Simples Nacional e CSOSN=201*/
     FIELD Orig           AS CHARACTER INITIAL ?                                      /*Origem da mercadoria*/
     FIELD CSOSN          AS CHARACTER INITIAL ?                                      /*C¢digo de Situaá∆o da Operaá∆o - Simples Nacional*/
     FIELD modBCST        AS CHARACTER INITIAL ?                                      /*Modalidade de determinaá∆o da BC do ICMS ST*/
     FIELD pMVAST         AS DECIMAL   INITIAL ? FORMAT ">>9.99" DECIMALS 2           /*Percentual da margem de valor Adicionado do ICMS ST*/
     FIELD pRedBCST       AS DECIMAL   INITIAL ? FORMAT ">>9.99" DECIMALS 2           /*Percentual da Reduá∆o de BC do ICMS ST vBCST Valor da BC do ICMS ST*/
     FIELD vBCST          AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do ICMS ST*/
     FIELD pICMSST        AS DECIMAL   INITIAL ? FORMAT ">>9.99" DECIMALS 2           /*Al°quota do imposto do ICMS ST*/
     FIELD vICMSST        AS DECIMAL   INITIAL ?                                      /*Valor do ICMS ST*/
     FIELD pCredSN        AS DECIMAL   INITIAL ? FORMAT ">>9.99" DECIMALS 2           /*Al°quota aplic†vel de c†lculo do crÇdito (SIMPLES NACIONAL).*/
     FIELD vCredICMSSN    AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor crÇdito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (SIMPLES NACIONAL)*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ttICMSSN201 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
     .

DEFINE TEMP-TABLE ttICMSSN202 NO-UNDO /*Grupo CRT=1 - Simples Nacional e CSOSN=201*/
     FIELD Orig           AS CHARACTER INITIAL ?                                      /*Origem da mercadoria*/
     FIELD CSOSN          AS CHARACTER INITIAL ?                                      /*C¢digo de Situaá∆o da Operaá∆o - Simples Nacional*/
     FIELD modBCST        AS CHARACTER INITIAL ?                                      /*Modalidade de determinaá∆o da BC do ICMS ST*/
     FIELD pMVAST         AS DECIMAL   INITIAL ? FORMAT ">>9.99" DECIMALS 2           /*Percentual da margem de valor Adicionado do ICMS ST*/
     FIELD pRedBCST       AS DECIMAL   INITIAL ? FORMAT ">>9.99" DECIMALS 2           /*Percentual da Reduá∆o de BC do ICMS ST vBCST Valor da BC do ICMS ST*/
     FIELD vBCST          AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do ICMS ST*/
     FIELD pICMSST        AS DECIMAL   INITIAL ? FORMAT ">>9.99" DECIMALS 2           /*Al°quota do imposto do ICMS ST*/
     FIELD vICMSST        AS DECIMAL   INITIAL ?                                      /*Valor do ICMS ST*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ttICMSSN202 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
     .

DEFINE TEMP-TABLE ttICMSSN500 NO-UNDO /*Grupo CRT=1 - Simples Nacional e CSOSN = 500*/
     FIELD Orig           AS CHARACTER INITIAL ?                                      /*Origem da mercadoria*/
     FIELD CSOSN          AS CHARACTER INITIAL ?                                      /*C¢digo de Situaá∆o da Operaá∆o - Simples Nacional*/
     FIELD vBCSTRet       AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do ICMS ST retido*/
     FIELD vICMSSTRet     AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do ICMS ST retido*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ttICMSSN500 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
     .

DEFINE TEMP-TABLE ttICMSSN900 NO-UNDO /*Grupo CRT=1 - Simples Nacional e CSOSN=900*/
     FIELD Orig           AS CHARACTER INITIAL ?                                      /*Origem da mercadoria*/
     FIELD CSOSN          AS CHARACTER INITIAL ?                                      /*C¢digo de Situaá∆o da Operaá∆o - SIMPLES NACIONAL*/
     FIELD modBC          AS CHARACTER INITIAL ?                                      /*Modalidade de determinaá∆o da BC do ICMS*/
     FIELD vBC            AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do ICMS*/
     FIELD pRedBC         AS DECIMAL   INITIAL ? FORMAT ">>9.99" DECIMALS 2           /*Percentual da Reduá∆o de BC*/
     FIELD pICMS          AS DECIMAL   INITIAL ? FORMAT ">>9.99" DECIMALS 2           /*Al°quota do imposto*/
     FIELD vICMS          AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do ICMS*/
     FIELD modBCST        AS CHARACTER INITIAL ?                                      /*Modalidade de determinaá∆o da BC do ICMS ST*/
     FIELD pMVAST         AS DECIMAL   INITIAL ? FORMAT ">>9.99" DECIMALS 2           /*Percentual da margem de valor Adicionado do ICMS ST*/
     FIELD pRedBCST       AS DECIMAL   INITIAL ? FORMAT ">>9.99" DECIMALS 2           /*Percentual da Reduá∆o de BC do ICMS ST*/
     FIELD vBCST          AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do ICMS ST*/
     FIELD pICMSST        AS DECIMAL   INITIAL ? FORMAT ">>9.99" DECIMALS 2           /*Al°quota do imposto do ICMS ST*/
     FIELD vICMSST        AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do ICMS ST*/
     FIELD vBCSTRet       AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da BC do ICMS ST retido*/
     FIELD vICMSSTRet     AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor do ICMS ST retido*/
     FIELD pCredSN        AS DECIMAL   INITIAL ? FORMAT ">>9.99" DECIMALS 2           /*Al°quota aplic†vel de c†lculo do crÇdito (SIMPLES NACIONAL).*/
     FIELD vCredICMSSN    AS DECIMAL   INITIAL ?                                      /*Valor crÇdito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (SIMPLES NACIONAL)*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ttICMSSN900 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
     .

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
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttCana IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
     .

DEFINE TEMP-TABLE ttForDia NO-UNDO /*Grupo de Fornecimento di†rio de cana*/
     FIELD dia             AS CHARACTER INITIAL ?                                             /*Dia*/
     FIELD qtde            AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>9.9999999999" DECIMALS 10 /*Quantidade*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttForDia IS PRIMARY UNIQUE dia CodEstabelNF SerieNF NrNotaFisNF
     .
     
DEFINE TEMP-TABLE ttDeduc NO-UNDO /*Grupo de Deduá‰es - Taxas e Contribuiá‰es*/
     FIELD xDed            AS CHARACTER INITIAL ?                                      /*Descriá∆o da Deduá∆o*/
     FIELD vDed            AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor da Deduá∆o*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttDeduc IS PRIMARY UNIQUE xDed CodEstabelNF SerieNF NrNotaFisNF
     .


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

        RETURN i-nro-decimais-nfe.

    END.

END FUNCTION.
/*--- FIM TRATAMENTO CASAS DECIMAIS - XML/TXT e DANFE ---*/


/*---------------------------------------------------------------------------------*/
