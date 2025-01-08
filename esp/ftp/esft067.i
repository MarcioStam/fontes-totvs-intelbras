/* 
===================================================================== 
Programa...: nf001.i
Descricao..: Gera estrutura XML a partir da nota fiscal
Autor......: Tiago Castilho
Data.......: 26/05/2009
===================================================================== 
*/ 

/* Temp-Table Definitions (Cada temp-table será uma estrutura(um nó)) */

/* identificação da nota fiscal Eletronica */

DEFINE VARIABLE cCampo1  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo2  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo3  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo4  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo5  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo6  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo7  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo8  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo9  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo10 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo11 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo12 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo13 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo14 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo15 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo16 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo17 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo18 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo19 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo20 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo21 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo22 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo23 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo24 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo25 AS CHARACTER   NO-UNDO.

define temp-table ide NO-UNDO 
    FIELDS cUF     AS CHAR 
    FIELDS cNF     AS CHAR FORMAT "99999999"
    FIELDS natOp   AS CHAR FORMAT "x(1)" INITIAL "?"
    FIELDS indPag  AS CHAR 
    FIELDS mod     AS CHAR FORMAT "x(2)" INITIAL "55"
    FIELDS serie   AS CHAR INITIAL '1'
    FIELDS nNF     AS CHAR
    FIELDS dEmi    AS CHAR
    FIELDS dSaiEnt AS CHAR
    FIELDS hSaiEnt AS CHAR
    FIELDS tpNF    AS CHAR
    FIELDS cMunFG  AS CHAR FORMAT "9999999"
    FIELDS tpImp   AS CHAR INIT "1"
    FIELDS tpEmis  AS CHAR
    FIELDS cDV     AS CHAR INITIAL 0
    FIELDS tpAmb   AS CHAR
    FIELDS finNFe  AS CHAR
    FIELDS procEmi AS CHAR
    FIELDS verProc AS CHAR
    FIELDS dhCont  AS CHAR
    FIELDS xJust   AS CHAR.
    
DEFINE TEMP-TABLE refNF NO-UNDO
    FIELDS nitem    AS INT
    FIELDS cUF      as char
    fields AAMM     as char
    fields CNPJ     as char
    fields mod      as char
    fields serie    as char
    fields nNF      as char.        

DEFINE TEMP-TABLE refNFP NO-UNDO
    FIELDS nitem    AS INT
    FIELD cUF       as char
    FIELD AAMM      as char
    FIELD CNPJ      as char
    FIELD CPF       as char
    FIELD IE        as char
    FIELD MOD       as char
    FIELD serie     as char
    FIELD nNF       as char.

DEFINE TEMP-TABLE refCTe NO-UNDO
    FIELDS nitem    AS INT
    FIELD refCte    AS CHAR.

DEFINE TEMP-TABLE refECF NO-UNDO
    FIELD nitem AS INT
    FIELD MOD   AS CHAR
    FIELD nECF  AS CHAR
    FIELD nCOO  AS CHAR.

DEFINE TEMP-TABLE emit NO-UNDO
    FIELDS CNPJ  AS CHAR
    FIELDS xNome AS CHAR
    FIELDS xFant AS CHAR
    FIELDS IE    AS CHAR
    FIELDS IEST  AS CHAR
    FIELDS IM    AS CHAR
    FIELD CNAE   AS CHARACTER
    FIELD CRT    AS CHARACTER.

DEFINE TEMP-TABLE enderEmit NO-UNDO
    FIELDS xLgr    AS CHAR
    FIELDS nro     AS CHAR
    FIELDS xCpl    AS CHAR
    FIELDS xBairro AS CHAR
    FIELDS cMun    AS CHAR
    FIELDS xMun    AS CHAR
    FIELDS UF      AS CHAR
    FIELDS CEP     AS CHAR FORMAT '99999999'
    FIELDS cPais   AS CHAR
    FIELDS xPais   AS CHAR
    FIELDS fone    AS CHAR.

DEFINE TEMP-TABLE Avulsa NO-UNDO
     FIELD CNPJ    AS CHARACTER INITIAL ?
     FIELD xOrgao  AS CHARACTER INITIAL ?
     FIELD matr    AS CHARACTER INITIAL ?
     FIELD xAgente AS CHARACTER INITIAL ?
     FIELD fone    AS CHARACTER INITIAL ?
     FIELD UF      AS CHARACTER INITIAL ?
     FIELD nDAR    AS CHARACTER INITIAL ?
     FIELD dEmi    AS CHAR      INITIAL ?
     FIELD vDAR    AS CHAR      INITIAL ?
     FIELD repEmi  AS CHARACTER INITIAL ?
     FIELD dPag    AS CHAR      INITIAL ?.





DEFINE TEMP-TABLE dest NO-UNDO
    FIELDS CNPJ     AS char
    FIELDS CPF      AS CHAR
    FIELDS xNome    AS CHAR
    FIELDS IE       AS CHAR
    FIELDS ISUF     AS CHAR
    FIELDS email    AS CHAR.

DEFINE TEMP-TABLE enderDest NO-UNDO
    FIELDS xLgr    AS CHAR
    FIELDS nro     AS CHAR INITIAL '00'
    FIELDS xCpl    AS CHAR
    FIELDS xBairro AS CHAR
    FIELDS cMun    AS CHAR
    FIELDS xMun    AS CHAR
    FIELDS UF      AS CHAR
    FIELDS CEP     AS CHAR FORMAT '99999999'
    FIELDS cPais   AS CHAR 
    FIELDS xPais   AS CHAR
    FIELDS fone    AS CHAR.

DEF TEMP-TABLE retirada NO-UNDO
    FIELDS CNPJ      as char   
    FIELDS xLgr      as char   
    FIELDS nro       as char   
    FIELDS xCpl      as char
    FIELDS xBairro   as char   
    FIELDS cMun      as char   
    FIELDS xMun      as char   
    FIELDS UF        as char. 

DEFINE TEMP-TABLE entrega NO-UNDO
    FIELDS CNPJ     AS CHAR
    FIELDS CPF      AS CHAR
    FIELDS xLgr     AS CHAR
    FIELDS nro      AS CHAR
    FIELDS xCpl     AS CHAR
    FIELDS xBairro  AS CHAR
    FIELDS cMun     AS CHAR
    FIELDS xMun     AS CHAR
    FIELDS UF       AS CHAR.

DEFINE TEMP-TABLE prod NO-UNDO
    FIELDS nItem    AS INT 
    FIELDS cProd    AS CHAR
    FIELDS cEAN     AS CHAR
    FIELDS xProd    AS CHAR format "x(120)"
    FIELDS NCM      AS CHAR
    FIELDS EXTIPI   AS CHAR FORMAT "999"
    FIELDS CFOP     as char 
    FIELDS uCom     as char 
    FIELDS qCom     AS CHAR
    FIELDS vUnCom   AS CHAR
    FIELDS vProd    AS CHAR
    FIELDS cEANTrib as char 
    FIELDS uTrib    as char 
    FIELDS qTrib    AS CHAR 
    FIELDS vUnTrib  AS CHAR
    FIELDS vFrete   AS CHAR
    FIELDS vSeg     AS CHAR
    FIELDS vDesc    AS CHAR
    FIELDS vOutro   AS CHAR
    FIELDS indTot   AS CHAR
    
    FIELDS xPed     AS CHAR
    FIELDS nItemPed AS CHAR
    FIELDS nFCI     AS CHAR.

DEFINE TEMP-TABLE DI NO-UNDO
    FIELD nDI           AS CHAR
    FIELD dDI           AS CHAR
    FIELD xLocDesemb    AS CHAR
    FIELD UFDesemb      AS CHAR
    FIELD dDesemb       AS CHAR
    FIELD cExportador   AS CHAR .

DEFINE TEMP-TABLE adi NO-UNDO
    FIELD nAdicao        AS CHARACTER INITIAL ?
    FIELD nSeqAdic       AS CHARACTER INITIAL ?
    FIELD cFabricante    AS CHARACTER INITIAL ?
    FIELD vDescDI        AS CHAR   INITIAL ?. 

DEFINE TEMP-TABLE Veic NO-UNDO
     FIELD tpOp           AS CHARACTER INITIAL ?                                         /*Tipo da Opera‡Æo (1 - Venda concession ria; 2 - Faturamento direto; 3 - Venda direta; 0 - Outros)*/
     FIELD chassi         AS CHARACTER INITIAL ?                                         /*Chassi do ve¡culo*/
     FIELD cCor           AS CHARACTER INITIAL ?                                         /*Cor do ve¡culo (c¢digo de cada montadora)*/
     FIELD xCor           AS CHARACTER INITIAL ?                                         /*Descri‡Æo da cor*/
     FIELD pot            AS CHARACTER INITIAL ?                                         /*Potˆncia do motor*/
     FIELD CM3            AS CHARACTER INITIAL ?                                         /*CM3 (potˆncia)*/
     FIELD pesoL          AS CHARACTER INITIAL ?                                         /*Peso l¡quido*/
     FIELD pesoB          AS CHARACTER INITIAL ?                                         /*Peso bruto*/
     FIELD nSerie         AS CHARACTER INITIAL ?                                         /*Serial (s‚rie)*/
     FIELD tpComb         AS CHARACTER INITIAL ?                                         /*Tipo de combust¡vel*/
     FIELD nMotor         AS CHARACTER INITIAL ?                                         /*N£mero do motor*/
     FIELD CMKG           AS CHARACTER INITIAL ?                                         /*CMKG*/
     FIELD dist           AS CHARACTER INITIAL ?                                         /*Distƒncia entre eixos*/
     FIELD RENAVAM        AS CHARACTER INITIAL ?                                         /*RENAVAM, informar apenas quando existente*/
     FIELD anoMod         AS CHARACTER INITIAL ?                                         /*Ano Modelo de Fabrica‡Æo*/
     FIELD anoFab         AS CHARACTER INITIAL ?                                         /*Ano de Fabrica‡Æo*/
     FIELD tpPint         AS CHARACTER INITIAL ?                                         /*Tipo de pintura*/
     FIELD tpVeic         AS CHARACTER INITIAL ?                                         /*Tipo de ve¡culo (utilizar tabela RENAVAM)*/
     FIELD espVeic        AS CHARACTER INITIAL ?                                         /*Esp‚cie de ve¡culo (utilizar tabela RENAVAM)*/
     FIELD VIN            AS CHARACTER INITIAL ?                                         /*C¢digo do VIN (Vehicle Identification Number)*/
     FIELD condVeic       AS CHARACTER INITIAL ?                                         /*Condi‡Æo do ve¡culo (1 - acabado; 2 - inacabado; 3 - semi-acabado)*/
     FIELD cMod           AS CHARACTER INITIAL ?.

DEFINE TEMP-TABLE med NO-UNDO
    FIELD nLote     AS CHAR
    FIELD qLote     AS CHAR
    FIELD dFab      AS CHAR
    FIELD dVal      AS CHAR
    FIELD vPMC      AS CHAR.

DEF TEMP-TABLE Arma NO-UNDO
    FIELD tpArma   AS CHARACTER INITIAL ?
    FIELD nSerie   AS CHARACTER INITIAL ? 
    FIELD nCano    AS CHARACTER INITIAL ? 
    FIELD descr    AS CHARACTER INITIAL ?.

DEFINE TEMP-TABLE Comb NO-UNDO
     FIELD cProdANP       AS CHARACTER INITIAL ?
     FIELD CODIF          AS CHARACTER INITIAL ? 
     FIELD qTemp          AS CHAR      INITIAL ? 
     FIELD UFCons         AS CHARACTER INITIAL ? 
     FIELD cide           AS CHAR      INITIAL ?
     FIELD qBCProd        AS CHAR      INITIAL ?   
     FIELD vAliqProd      AS CHAR      INITIAL ?   
     FIELD vCIDE          AS CHAR      INITIAL ?.

DEFINE TEMP-TABLE ICMS00 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tribut‡Æo pelo ICMS 00 - Tributada integralmente*/
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determina‡Æo da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Pre‡o Tabelado M ximo (valor); 3 - Valor da Opera‡Æo.*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importa‡Æo direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS CHARACTER INITIAL ?   /*Al¡quota do ICMS*/    
     FIELD vBC            AS CHARACTER INITIAL ?   /*Valor da BC do ICMS*/ 
     FIELD vICMS          AS CHARACTER INITIAL ?   /*Valor do ICMS*/       
     FIELD nItem          AS INT.

DEFINE TEMP-TABLE ICMS10 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*10 - Tributada e com cobran‡a do ICMS por substitui‡Æo tribut ria */
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determina‡Æo da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Pre‡o Tabelado M ximo (valor); 3 - Valor da Opera‡Æo */
     FIELD modBCST        AS CHARACTER INITIAL ?                                         /*Modalidade de determina‡Æo da BC do ICMS ST: 0 - Pre‡o tabelado ou m ximo  sugerido; 1 - Lista Negativa (valor); 2 - Lista Positiva (valor); 3 - Lista Neutra (valor); 4 - Margem Valor Agregado (%); 5 - Pauta (valor) */
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importa‡Æo direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS CHARACTER INITIAL ?   /*Al¡quota do ICMS*/ 
     FIELD pICMSST        AS CHARACTER INITIAL ?   /*Al¡quota do ICMS ST*/ 
     FIELD pMVAST         AS CHARACTER INITIAL ?   /*Percentual da Margem de Valor Adicionado ICMS ST*/ 
     FIELD pRedBCST       AS CHARACTER INITIAL ?   /*Percentual de redu‡Æo da BC ICMS ST */ 
     FIELD vBC            AS CHARACTER INITIAL ?   /*Valor da BC do ICMS*/ 
     FIELD vBCST          AS CHARACTER INITIAL ?   /*Valor da BC do ICMS ST*/ 
     FIELD vICMS          AS CHARACTER INITIAL ?   /*Valor do ICMS*/ 
     FIELD vICMSST        AS CHARACTER INITIAL ?   /*Valor do ICMS ST*/ 
     FIELD nItem          AS INT.

DEFINE TEMP-TABLE ICMS20 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tribut‡Æo pelo ICMS 20 - Com redu‡Æo de base de c lculo*/
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determina‡Æo da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Pre‡o Tabelado M ximo (valor); 3 - Valor da Opera‡Æo.*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importa‡Æo direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS CHARACTER INITIAL ?  /*Al¡quota do ICMS*/ 
     FIELD pRedBC         AS CHARACTER INITIAL ?  /*Percentual de redu‡Æo da BC*/ 
     FIELD vBC            AS CHARACTER INITIAL ?  /*Valor da BC do ICMS*/ 
     FIELD vICMS          AS CHARACTER INITIAL ?  /*Valor do ICMS*/ 
     FIELD nItem          AS INT.

DEFINE TEMP-TABLE ICMS30 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tribut‡Æo pelo ICMS 30 - Isenta ou nÆo tributada e com cobran‡a do ICMS por substitui‡Æo tribut ria */
     FIELD modBCST        AS CHARACTER INITIAL ?                                         /*Modalidade de determina‡Æo da BC do ICMS ST: 0 - Pre‡o tabelado ou m ximo  sugerido; 1 - Lista Negativa (valor); 2 - Lista Positiva (valor); 3 - Lista Neutra (valor); 4 - Margem Valor Agregado (%); 5 - Pauta (valor).*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importa‡Æo direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMSST        AS CHARACTER INITIAL ?   /*Al¡quota do ICMS ST*/ 
     FIELD pMVAST         AS CHARACTER INITIAL ?   /*Percentual da Margem de Valor Adicionado ICMS ST*/
     FIELD pRedBCST       AS CHARACTER INITIAL ?   /*Percentual de redu‡Æo da BC ICMS ST */ 
     FIELD vBCST          AS CHARACTER INITIAL ?   /*Valor da BC do ICMS ST*/ 
     FIELD vICMSST        AS CHARACTER INITIAL ?   /*Valor do ICMS ST*/ 
     FIELD nItem          AS INT.

DEFINE TEMP-TABLE ICMS40 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributa‡Æo pelo ICMS 40 - Isenta 41 - NÆo tributada 50 - SuspensÆo 51 - Diferimento */
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importa‡Æo direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD nItem          AS INT.

DEFINE TEMP-TABLE ICMS51 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tribut‡Æo pelo ICMS 20 - Com redu‡Æo de base de c lculo*/
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determina‡Æo da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Pre‡o Tabelado M ximo (valor); 3 - Valor da Opera‡Æo.*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importa‡Æo direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS CHARACTER INITIAL ?   /*Al¡quota do ICMS*/ 
     FIELD pRedBC         AS CHARACTER INITIAL ?   /*Percentual de redu‡Æo da BC*/ 
     FIELD vBC            AS CHARACTER INITIAL ?   /*Valor da BC do ICMS*/ 
     FIELD vICMS          AS CHARACTER INITIAL ?   /*Valor do ICMS*/ 
     FIELD nItem          AS INT.
                             
DEFINE TEMP-TABLE ICMS60 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributa‡Æo pelo ICMS 60 - ICMS cobrado anteriormente por substitui‡Æo tribut ria */
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importa‡Æo direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD vBCST          AS CHARACTER INITIAL ?   /*Valor da BC do ICMS ST retido anteriormente*/ 
     FIELD vICMSST        AS CHARACTER INITIAL ?   /*Valor do ICMS ST retido anteriormente*/ 
     FIELD nItem          AS INT.

DEFINE TEMP-TABLE ICMS70 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tribut‡Æo pelo ICMS 70 - Com redu‡Æo de base de c lculo e cobran‡a do ICMS por substitui‡Æo tribut ria */
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determina‡Æo da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Pre‡o Tabelado M ximo (valor); 3 - Valor da Opera‡Æo.*/
     FIELD modBCST        AS CHARACTER INITIAL ?                                         /*Modalidade de determina‡Æo da BC do ICMS ST: 0 - Pre‡o tabelado ou m ximo  sugerido; 1 - Lista Negativa (valor); 2 - Lista Positiva (valor); 3 - Lista Neutra (valor); 4 - Margem Valor Agregado (%); 5 - Pauta (valor).*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importa‡Æo direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS CHARACTER INITIAL ?   /*Al¡quota do ICMS*/ 
     FIELD pICMSST        AS CHARACTER INITIAL ?   /*Al¡quota do ICMS ST*/ 
     FIELD pMVAST         AS CHARACTER INITIAL ?   /*Percentual da Margem de Valor Adicionado ICMS ST*/
     FIELD pRedBC         AS CHARACTER INITIAL ?   /*Percentual de redu‡Æo da BC*/ 
     FIELD pRedBCST       AS CHARACTER INITIAL ?   /*Percentual de redu‡Æo da BC ICMS ST */ 
     FIELD vBC            AS CHARACTER INITIAL ?   /*Valor da BC do ICMS*/ 
     FIELD vBCST          AS CHARACTER INITIAL ?   /*Valor da BC do ICMS ST*/ 
     FIELD vICMS          AS CHARACTER INITIAL ?   /*Valor do ICMS*/ 
     FIELD vICMSST        AS CHARACTER INITIAL ?   /*Valor do ICMS ST*/ 
     FIELD nItem          AS INT.

DEFINE TEMP-TABLE ICMS90 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tribut‡Æo pelo ICMS 90 - Outras*/
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determina‡Æo da BC do ICMS:  0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Pre‡o Tabelado M ximo (valor); 3 - Valor da Opera‡Æo.*/
     FIELD modBCST        AS CHARACTER INITIAL ?                                         /*Modalidade de determina‡Æo da BC do ICMS ST: 0 - Pre‡o tabelado ou m ximo  sugerido;  1 - Lista Negativa (valor); 2 - Lista Positiva (valor); 3 - Lista Neutra (valor); 4 - Margem Valor Agregado (%);  5 - Pauta (valor).*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importa‡Æo direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS CHARACTER INITIAL ?   /*Al¡quota do ICMS*/ 
     FIELD pICMSST        AS CHARACTER INITIAL ?   /*Al¡quota do ICMS ST*/ 
     FIELD pMVAST         AS CHARACTER INITIAL ?   /*Percentual da Margem de Valor Adicionado ICMS ST*/
     FIELD pRedBC         AS CHARACTER INITIAL ?   /*Percentual de redu‡Æo da BC*/ 
     FIELD pRedBCST       AS CHARACTER INITIAL ?   /*Percentual de redu‡Æo da BC ICMS ST */ 
     FIELD vBC            AS CHARACTER INITIAL ?   /*Valor da BC do ICMS*/ 
     FIELD vBCST          AS CHARACTER INITIAL ?   /*Valor da BC do ICMS ST*/ 
     FIELD vICMS          AS CHARACTER INITIAL ?   /*Valor do ICMS*/ 
     FIELD vICMSST        AS CHARACTER INITIAL ?   /*Valor do ICMS ST*/ 
     FIELD nItem          AS INT.

DEFINE TEMP-TABLE IPI NO-UNDO
    FIELDS nItem AS INT
    FIELDS clEnq    AS CHAR
    FIELDS CNPJProd AS CHAR
    FIELDS cSelo    AS CHAR
    FIELDS qSelo    AS CHAR
    FIELDS cEnq     AS CHAR
    FIELDS CST      AS CHAR
    FIELDS vBC      AS CHAR
    FIELDS pIPI     AS CHAR
    FIELDS qUnid    AS CHAR 
    FIELDS vUnid    AS CHAR
    FIELDS vIPI     AS CHAR.

DEFINE TEMP-TABLE II NO-UNDO
    FIELDS nItem   AS INT
    FIELD vBC      AS CHAR
    FIELD vDespAdu AS CHAR
    FIELD vII      AS CHAR
    FIELD vIOF     AS CHAR.

DEFINE TEMP-TABLE PISAliq NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situa‡Æo Tribut ria do PIS. 01 - Opera‡Æo Tribut vel - Base de C lculo = Valor da Opera‡Æo Al¡quota Normal (Cumulativo/NÆo Cumulativo); 02 - Opera‡Æo Tribut vel - Base de Calculo = Valor da Opera‡Æo (Al¡quota Diferenciada) */
     FIELD vBC            AS CHARACTER INITIAL ?   /*Valor da BC do PIS*/              
     FIELD pPIS           AS CHARACTER INITIAL ?   /*Al¡quota do PIS (em percentual)*/ 
     FIELD vPIS           AS CHARACTER INITIAL ?   /*Valor do PIS*/                    
     FIELD nItem          AS INT.

DEFINE TEMP-TABLE PISQtde NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situa‡Æo Tribut ria do PIS. 03 - Opera‡Æo Tribut vel - Base de Calculo = Quantidade Vendida x Al¡quota por Unidade de Produto */
     FIELD qBCProd        AS CHARACTER INITIAL ?  /*Quantidade Vendida */ 
     FIELD vAliqProd      AS CHARACTER INITIAL ?  /*Al¡quota do PIS (em reais)*/ 
     FIELD vPIS           AS CHARACTER INITIAL ?  /*Valor do PIS*/ 
     FIELD nItem          AS INT.

DEFINE TEMP-TABLE PISNT NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situa‡Æo Tribut ria do PIS. 04 - Opera‡Æo Tribut vel - Tributa‡Æo Monof sica - (Al¡quota Zero); 06 - Opera‡Æo Tribut vel - Al¡quota Zero; 07 - Opera‡Æo Isenta da contribui‡Æo; 08 - Opera‡Æo Sem Incidˆncia da contribui‡Æo; 09 - Opera‡Æo com suspensÆo da contribui‡Æo */
     FIELD nItem          AS INT.

DEFINE TEMP-TABLE PISOutr NO-UNDO
     FIELD CST            AS CHARACTER 
     FIELD vPIS           AS CHAR
     FIELD vBC            AS CHAR
     FIELD pPIS           AS CHAR
     FIELD qBCProd        AS CHAR
     FIELD vAliqProd      AS CHAR
     FIELD nItem          AS INT.

DEFINE TEMP-TABLE PISST NO-UNDO
     FIELD vBC            AS CHAR
     FIELD pPIS           AS CHAR
     FIELD qBCProd        AS CHAR
     FIELD vAliqProd      AS CHAR
     FIELD vPIS           AS CHAR    
     FIELD nItem          AS INT.

DEFINE TEMP-TABLE COFINSAliq NO-UNDO
     FIELD CST            AS CHARACTER 
     FIELD vBC            AS CHAR
     FIELD pCOFINS        AS CHAR
     FIELD vCOFINS        AS CHAR
     FIELD nItem          AS INT.

DEFINE TEMP-TABLE COFINSQtde NO-UNDO
     FIELD CST            AS CHARACTER 
     FIELD qBCProd        AS CHAR
     FIELD vAliqProd      AS CHAR
     FIELD vCOFINS        AS CHAR
     FIELD nItem          AS INT.

DEFINE TEMP-TABLE COFINSNT NO-UNDO
     FIELD CST            AS CHARACTER 
     FIELD nItem          AS INT.

DEFINE TEMP-TABLE COFINSOutr NO-UNDO
     FIELD CST            AS CHARACTER 
     FIELD vCOFINS        AS CHARACTER 
     FIELD pCOFINS        AS CHARACTER 
     FIELD qBCProd        AS CHARACTER 
     FIELD vAliqProd      AS CHARACTER 
     FIELD vBC            AS CHARACTER 
     FIELD nItem          AS INT.

DEFINE TEMP-TABLE COFINSST NO-UNDO
     FIELD vBC            AS CHAR     
     FIELD pCOFINS        AS CHAR
     FIELD qBCProd        AS CHAR
     FIELD vAliqProd      AS CHAR
     FIELD vCOFINS        AS CHAR     
     FIELD nItem          AS INT.

DEFINE TEMP-TABLE ISSQN NO-UNDO
     FIELD nItem          AS INT
     FIELD vBC            AS CHAR   
     FIELD vAliq          AS CHAR   
     FIELD vISSQN         AS CHAR   
     FIELD cMunFG         AS CHARACTER 
     FIELD cListServ      AS CHARACTER 
     FIELD cSitTrib       AS CHAR.

DEFINE TEMP-TABLE ICMSTot 
    FIELDS vBC     AS CHAR
    FIELDS vICMS   AS CHAR 
    FIELDS vBCST   AS CHAR 
    FIELDS vST     AS CHAR 
    FIELDS vProd   AS CHAR 
    FIELDS vFrete  AS CHAR
    FIELDS vSeg    AS CHAR 
    FIELDS vDesc   AS CHAR 
    FIELDS vII     AS CHAR
    FIELDS vIPI    AS CHAR 
    FIELDS vPIS    AS CHAR 
    FIELDS vCOFINS AS CHAR 
    FIELDS vOutro  AS CHAR
    FIELDS vNF     AS CHAR
    FIELDS vTotTrib AS CHAR.

DEFINE TEMP-TABLE ISSQNtot NO-UNDO
     FIELD vServ          AS CHAR   
     FIELD vBC            AS CHAR   
     FIELD vISS           AS CHAR   
     FIELD vPIS           AS CHAR   
     FIELD vCOFINS        AS CHAR .

DEFINE TEMP-TABLE retTrib NO-UNDO
     FIELD vRetPIS        AS CHAR   
     FIELD vRetCOFINS     AS CHAR   
     FIELD vRetCSLL       AS CHAR   
     FIELD vBCIRRF        AS CHAR
     FIELD vIRRF          AS CHAR   
     FIELD vBCRetPrev     AS CHAR   
     FIELD vRetPrev       AS CHAR.

DEFINE TEMP-TABLE transp NO-UNDO
    FIELD modFrete  AS CHAR 
    FIELD vagao     AS CHAR
    FIELD balsa     AS CHAR.

DEFINE TEMP-TABLE transporta NO-UNDO
    FIELDS CNPJ       as char
    FIELDS CPF        as char
    FIELDS xNome      as char
    FIELDS IE         as char
    FIELDS xEnder     as char
    FIELDS xMun       as char
    FIELDS UF         as char.

DEFINE TEMP-TABLE reboque NO-UNDO
    FIELDS placa       AS CHAR
    FIELDS UF          AS CHAR
    FIELDS RNTC        AS CHAR.

DEFINE TEMP-TABLE vol NO-UNDO
    FIELDS qVol  AS CHAR
    FIELDS esp   AS CHAR
    FIELDS marca AS CHAR
    FIELDS nVol  AS CHAR
    FIELDS pesoL AS CHAR
    FIELDS pesoB AS CHAR.   

DEFINE TEMP-TABLE lacres NO-UNDO
    FIELDS NLacre      AS CHAR
    FIELDS nVol        AS CHAR.

DEFINE TEMP-TABLE cobr NO-UNDO
    FIELD nFat   AS CHARACTER INITIAL ?
    FIELD vDesc  AS CHAR
    FIELD vLiq   AS CHAR
    FIELD vOrig  AS CHAR
    .

DEFINE TEMP-TABLE fat NO-UNDO
    FIELDS nFat     AS CHAR
    FIELDS vOrig    AS CHAR
    FIELDS vDesc    AS CHAR
    FIELDS vLiq     AS CHAR.

DEFINE TEMP-TABLE dup NO-UNDO
    FIELDS nDup     AS CHAR
    FIELDS dVenc    AS CHAR
    FIELDS vDup     AS CHAR
    .

DEFINE TEMP-TABLE infAdic NO-UNDO
    FIELD infAdFisco AS CHAR
    FIELD infCpl     AS CHAR.

DEFINE TEMP-TABLE obsCont NO-UNDO
/*     FIELD xCampo         AS CHARACTER INITIAL ? /*Atributo*/*/
     FIELD xTexto         AS CHARACTER INITIAL ? /*Valor*/
     .

DEFINE TEMP-TABLE obsFisco NO-UNDO
/*     FIELD xCampo         AS CHARACTER INITIAL ? /*Atributo*/*/
     FIELD xTexto         AS CHARACTER INITIAL ? /*Valor*/.

DEFINE TEMP-TABLE procRef NO-UNDO
     FIELD nProc          AS CHARACTER INITIAL ?                                         /*Indentificador do processo ou ato concess¢rio*/
     FIELD indProc        AS CHARACTER INITIAL ?                                         /*Origem do processo, informar com: 0 - SEFAZ; 1 - Justi‡a Federal; 2 - Justi‡a Estadual; 3 - Secex/RFB; 9 - Outros*/
     .
DEFINE TEMP-TABLE exporta NO-UNDO
    FIELDS UFEmbarq   AS CHAR
    FIELDS xLocEmbarq AS CHAR
    .

DEFINE TEMP-TABLE compra NO-UNDO
    FIELDS xNEmp      AS CHAR
    FIELDS xPed       AS CHAR
    FIELDS xCont      AS CHAR
    FIELDS nItem      AS CHAR.

/*----------------------*/

DEFINE TEMP-TABLE retTransp NO-UNDO
    FIELDS vServ       AS CHAR
    FIELDS vBCRet      AS CHAR
    FIELDS pICMSRet    AS CHAR
    FIELDS vICMSRet    AS CHAR
    FIELDS CFOP        AS CHAR
    FIELDS cMunFG      AS CHAR.

DEFINE TEMP-TABLE veicTransp NO-UNDO
    FIELDS placa       AS CHAR
    FIELDS UF          AS CHAR
    FIELDS RNTC        AS CHAR.

DEFINE TEMP-TABLE veicProd NO-UNDO
    FIELDS tpOp     AS CHAR
    FIELDS chassi   AS CHAR
    FIELDS cCor     AS CHAR
    FIELDS xCor     as char 
    FIELDS pot      as char 
    FIELDS CM3      as char 
    FIELDS pesoL    as char 
    FIELDS pesoB    as char 
    FIELDS nSerie   as char 
    FIELDS tpComb   as char 
    FIELDS nMotor   as char 
    FIELDS CMKG     as char 
    FIELDS dist     as char 
    FIELDS RENAVAM  as char 
    FIELDS anoMod   as char 
    FIELDS anoFab   as char 
    FIELDS tpPint   as char 
    FIELDS tpVeic   as char 
    FIELDS espVeic  as char 
    FIELDS VIN      as char 
    FIELDS condVeic as char 
    FIELDS cMod     as char 
    FIELD cilin     AS CHAR
    FIELD CMT       AS CHAR
    FIELD cCorDENATRAN AS CHAR
    FIELD lota      AS CHAR
    FIELD tpRest    AS CHAR.

DEFINE TEMP-TABLE det NO-UNDO
     FIELD cEAN           AS CHARACTER INITIAL ?
     FIELD cEANTrib       AS CHARACTER INITIAL ?
     FIELD CFOP           AS CHARACTER INITIAL ?
     FIELD cProd          AS CHARACTER INITIAL ?
     FIELD EXTIPI         AS CHARACTER INITIAL ?
     FIELD genero         AS CHARACTER INITIAL ?
     FIELD infAdProd      AS CHARACTER INITIAL ?
     FIELD NCM            AS CHARACTER INITIAL ?
     FIELD qCom           AS CHARACTER INITIAL ?
     FIELD qTrib          AS CHARACTER INITIAL ?
     FIELD uCom           AS CHARACTER INITIAL ?
     FIELD uTrib          AS CHARACTER INITIAL ?
     FIELD vDesc          AS CHARACTER INITIAL ?
     FIELD vFrete         AS CHARACTER INITIAL ?
     FIELD vProd          AS CHARACTER INITIAL ?
     FIELD vSeg           AS CHARACTER INITIAL ?
     FIELD vUnCom         AS CHARACTER INITIAL ?
     FIELD vUnTrib        AS CHARACTER INITIAL ?
     FIELD xProd          AS CHARACTER INITIAL ?
     FIELD vOutro         AS CHARACTER INITIAL ? 
     FIELD indTot         AS CHARACTER INITIAL ? 
     FIELD xPed           AS CHARACTER INITIAL ? 
     FIELD nItemPed       AS CHARACTER INITIAL ? 
     FIELD nItem          AS INT.

DEFINE TEMP-TABLE imposto NO-UNDO
    FIELDS nItem AS INT .

DEFINE TEMP-TABLE ICMS NO-UNDO
    FIELDS nItem      AS INT
    FIELDS orig       AS CHAR                                    
    FIELDS CST        AS CHAR                                    
    FIELDS modBC      AS CHAR          
    FIELDS pRedBC     AS CHAR 
    FIELDS vBC        AS CHAR 
    FIELDS pICMS      AS CHAR 
    FIELDS vICMS      AS CHAR 
    FIELDS modBCST    AS CHAR 
    FIELDS motDesICMS AS CHAR
    FIELDS pMVAST     AS CHAR
    FIELDS pRedBCST   AS CHAR 
    FIELDS vBCST      AS CHAR 
    FIELDS pICMSST    AS CHAR 
    FIELDS vICMSST    AS CHAR 
    FIELDS vBCSTRet   AS CHAR
    FIELDS vICMSSTRet AS CHAR
    FIELDS cTag       AS CHAR
    FIELDS pBCOp      AS CHAR
    FIELDS UFST       AS CHAR
    FIELDS vBCSTDest  AS CHAR
    FIELDS vICMSSTDest AS CHAR
    FIELDS CSOSN     AS CHAR
    FIELD pCredSN   AS CHAR
    FIELD vCredICMSSN  AS CHAR.

DEFINE TEMP-TABLE PIS NO-UNDO
    FIELD nItem     AS INT
    FIELD CST       AS CHAR 
    FIELD vBC       AS CHAR 
    FIELD pPIS      AS CHAR 
    FIELD qBCProd   AS CHAR 
    FIELD vAliqProd AS CHAR
    FIELD vPIS      AS CHAR.

DEFINE TEMP-TABLE COFINS NO-UNDO
    FIELD nItem     AS INT 
    FIELD CST       AS CHAR
    FIELD vBC       AS CHAR
    FIELD pCOFINS   AS CHAR    
    FIELD qBCProd   AS CHAR
    FIELD vAliqPRod AS CHAR
    FIELD vCOFINS   AS CHAR.

DEFINE TEMP-TABLE cEnq NO-UNDO
    FIELDS nItem  AS INT .

DEFINE TEMP-TABLE ttMsgFISCO NO-UNDO
    FIELD cd-mensagem   AS CHAR
    FIELD ds-mensagem   AS CHAR.

DEFINE TEMP-TABLE ttMsgCONTR NO-UNDO
    FIELD cd-mensagem   AS CHAR
    FIELD ds-mensagem   AS CHAR.

DEFINE TEMP-TABLE NFref NO-UNDO
    FIELDS nitem    AS INT
    FIELD refNFe         AS CHARACTER INITIAL ?                                         /*Chave de acesso das NF-e referenciadas. Chave de acesso compostas por C¢digo da UF (tabela do IBGE) + AAMM da emissÆo + CNPJ do Emitente + modelo, série e n£mero da NF-e Referenciada + C¢digo Numérico + DV.*/.

DEFINE TEMP-TABLE cana NO-UNDO
    FIELD safra      as char
    FIELD ref        as char
    FIELD qTotMes    as char
    FIELD qTotAnt    as char
    FIELD qTotGer    as char
    FIELD vFor       as char
    FIELD vTotDed    as char
    FIELD vLiqFor    as char.

DEFINE TEMP-TABLE ForDia NO-UNDO
    FIELD dia  AS CHAR
    FIELD qtde AS CHAR.

DEFINE TEMP-TABLE deduc NO-UNDO
    FIELD xDed AS CHAR
    FIELD vDed AS CHAR.

DEFINE TEMP-TABLE total NO-UNDO
    FIELD nada AS CHAR.

DEFINE TEMP-TABLE TotalTrib NO-UNDO
    FIELD nItem     AS Int
    FIELD vTotTrib  AS CHAR.

DEFINE TEMP-TABLE tt-impressora 
    FIELD xTexto    AS CHAR FORMAT 'X(50)'.

FUNCTION replaceEspecialChars RETURN CHARACTER (INPUT pcTexto AS CHAR):

           IF INDEX(pcTexto,"û")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"û"," ").
           IF INDEX(pcTexto,"˜")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"˜"," ").
           IF INDEX(pcTexto,"ü")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"ü"," ").
           IF INDEX(pcTexto,"'")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"'"," ").
           IF INDEX(pcTexto,"ï")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"ï"," ").
           IF INDEX(pcTexto,"'")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto," "," ").
           IF INDEX(pcTexto,"·")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"·"," ").
           IF INDEX(pcTexto,"ý")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"ý"," ").
           IF INDEX(pcTexto,"¬")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"¬"," ").
           IF INDEX(pcTexto,"¨")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"¨"," ").
           IF INDEX(pcTexto,"Ç")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"Ç"," ").
           IF INDEX(pcTexto,"ð")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"ð"," ").
           IF INDEX(pcTexto,"¶")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"¶"," ").
           IF INDEX(pcTexto,"µ")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"µ"," ").
           IF INDEX(pcTexto,"Ø")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"Ø"," ").
           IF INDEX(pcTexto,"Ö")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"Ö"," ").
           IF INDEX(pcTexto,"«")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"«"," ").
           IF INDEX(pcTexto,"Ó")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"Ó"," ").
           IF INDEX(pcTexto,"Þ")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"Þ"," ").
           IF INDEX(pcTexto,"å")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"å"," ").
           IF INDEX(pcTexto,"ß")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"ß"," ").
           IF INDEX(pcTexto,"×")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"×"," ").
           IF INDEX(pcTexto,"ñ")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"ñ"," ").
           IF INDEX(pcTexto,"Ã")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"Ã"," ").
           IF INDEX(pcTexto,"ë")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"ë"," ").
           IF INDEX(pcTexto,CHR(13)) > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,CHR(13),"").
           IF INDEX(pcTexto,CHR(10)) > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,CHR(10),"").
           IF INDEX(pcTexto,CHR(9))  > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,CHR(9),"").
           IF INDEX(pcTexto,CHR(8))  > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,CHR(8),"").
           IF INDEX(pcTexto,"í")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"í"," ").
           IF INDEX(pcTexto,"ä")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"ä"," ").
           IF INDEX(pcTexto,"&")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"&"," ").
           IF INDEX(pcTexto,"|")     > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,"|"," ").

           RETURN pcTexto.
    END FUNCTION.


