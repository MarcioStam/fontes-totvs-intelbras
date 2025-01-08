/*Tt's Json Entrada  */
DEFINE TEMP-TABLE ttSimulacaoDevolucao NO-UNDO
   FIELD tipoDocumentoCliente   AS CHAR
   FIELD numeroDocumentoCliente LIKE emitente.cgc
   FIELD dataSimulacao          LIKE int-simula-dev.dt-simula    
   FIELD numeroSequencia        LIKE int-simula-dev.nr-sequencia 
   FIELD cnpjEstabelecimento    LIKE estabelec.cgc
   FIELD tipoNFe                AS CHAR
   FIELD email                  LIKE int-simula-dev.email        
   FIELD observacoes            LIKE int-simula-dev.narrativa
   FIELD cnpjTransportadora     LIKE transporte.cgc
   FIELD freteCIF               LIKE int-simula-dev.frete-cif.

DEFINE TEMP-TABLE ttItem NO-UNDO
   FIELD codigoItem       LIKE int-simula-dev-it.it-codigo
   FIELD quantidade       LIKE int-simula-dev-it.qt-devolvida.

DEFINE TEMP-TABLE ttExcluirSimulacao NO-UNDO
   FIELD numeroDocumentoCliente LIKE emitente.cgc
   FIELD dataSimulacao          LIKE int-simula-dev.dt-simula    
   FIELD numeroSequencia        LIKE int-simula-dev.nr-sequencia .

/*Tt's Json Sa­da*/
DEFINE TEMP-TABLE ttSimulacaoDevolucaoR NO-UNDO
    FIELD cnpj            LIKE emitente.cgc
    FIELD dataSimulacao   LIKE int-simula-dev.dt-simula    
    FIELD numeroSequencia LIKE int-simula-dev.nr-sequencia 
    FIELD estabelecimento LIKE int-simula-dev.cod-estabe.

DEF TEMP-TABLE ttItemR NO-UNDO
   FIELD codigoItem       LIKE int-simula-dev-it.it-codigo
   FIELD quantidade       LIKE int-simula-dev-it.qt-devolvida
   FIELD sequencia        LIKE int-simula-dev-it.nr-seq-it
   FIELD valorUnitario    LIKE int-simula-dev-it.vl-unitario
   FIELD valorIPI         LIKE int-simula-dev-it.vl-ipi
   FIELD percentualIPI    LIKE it-nota-fisc.aliquota-ip
   FIELD valorICMS        LIKE int-simula-dev-it.vl-icms
   FIELD percentualICMS   LIKE it-nota-fisc.aliquota-icm
   FIELD valorICMSST      LIKE int-simula-dev-it.vl-icmsst
   FIELD valorICMSDifal   LIKE int-simula-dev-it.vl-icmsdifal
   FIELD valorPIS         LIKE int-simula-dev-it.vl-pis
   FIELD valorCofins      LIKE int-simula-dev-it.vl-cofins
   FIELD valorTotalItem   LIKE int-simula-dev-it.vl-tot-it
   FIELD observacoes      LIKE int-simula-dev-it.observacao
   FIELD numeroNotaOrigem LIKE int-simula-dev-it.nr-nota-origem
   FIELD serieOrigem      LIKE int-simula-dev-it.serie-origem
   FIELD codigoEstabelecimentoOrigem LIKE int-simula-dev-it.cod-estabel-origem
   FIELD garantia         LIKE int-simula-dev-it.garantia
   FIELD baseICMSST       LIKE it-nota-fisc.vl-bsubs-it.  

/*Outras Tt's*/
DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD i-sequen AS INT
    FIELD cd-erro  AS INT
    FIELD mensagem AS CHAR FORMAT "x(255)".

DEFINE TEMP-TABLE tt-int-simula-dev-it NO-UNDO LIKE int-simula-dev-it
    FIELD dt-emis-nota LIKE nota-fiscal.dt-emis-nota
    FIELD dt-producao  LIKE num-serie-rast.data
    FIELD dt-primeira-nf LIKE nota-fiscal.dt-emis-nota.
