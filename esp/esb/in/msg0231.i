{esp/esb/esesb000.i}

/*Dataset de entrada*/
DEFINE TEMP-TABLE MSG0231 NO-UNDO XML-NODE-NAME 'MSG0231'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroEmbarque            LIKE embarque-imp.embarque INITIAL ?
   FIELD CodigoEstabelecimento     LIKE embarque-imp.cod-estabel
   FIELD CodigoViaTransporte       LIKE embarque-imp.cod-via-transp
   FIELD CodigoIncoterm            LIKE embarque-imp.cod-incoterm
   FIELD Narrativa                 LIKE embarque-imp.narrativa
   FIELD DataNecessidadeFabrica    AS DATE
   FIELD Master                    LIKE embarque-imp.cod-conhecto-master
   FIELD House                     LIKE embarque-imp.cod-conhecto-house
   FIELD CodigoTransportadora      LIKE embarque-imp.cod-transportador
   FIELD CodigoCorretorCambio      LIKE embarque-imp.cdn-corretor-cambio-import
   FIELD CodigoDespachante         LIKE embarque-imp.cod-despachante
   FIELD CodigoDespachanteExterior LIKE embarque-imp.cdn-despa-exter-import
   FIELD CodigoSeguradora          LIKE embarque-imp.cdn-segurad-import
   FIELD CodigoCorretorSeguro      LIKE embarque-imp.cdn-corretor-import
   FIELD TipoContainer             LIKE ext-embarque-imp.conteiner
   FIELD Quantidade1Container      LIKE ext-embarque-imp.qtd-conteiner
   FIELD Quantidade2Container      LIKE ext-embarque-imp.qtd2-conteiner
   FIELD MatriculaResponsavel      LIKE usuar_mestre.cod_usuar
   FIELD PossuiAnexos              AS LOG
   FIELD LogEnvioComex             LIKE ext-embarque-imp.log-envio-comex
   FIELD LogLiberaAlteracaoComex   LIKE ext-embarque-imp.log-libera-alteracao
   FIELD LogLiberaModalComex       LIKE ext-embarque-imp.log-libera-modal
   FIELD FinalidadeCourier         AS i.

DEFINE TEMP-TABLE FinanceiroFiscal NO-UNDO XML-NODE-NAME 'FinanceiroFiscal'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD ROF                         LIKE embarque-imp.nr-rof
   FIELD DISiscomex                  LIKE embarque-imp.declaracao-import  
   FIELD DIEMS                       LIKE embarque-imp.int-2
   FIELD DataDI                      LIKE embarque-imp.data-di
   FIELD NaturezaCambial             LIKE embarque-imp.int-1
   FIELD NumeroCartaCredito          LIKE embarque-imp.carta-credito
   FIELD CodigoBanco                 LIKE embarque-imp.cod-banco
   FIELD DataSolicitacaoCartaCredito AS DATE 
   FIELD DataAprovacaoCartaCredito   AS DATE 
   FIELD DataValidadeCartaCredito    AS DATE 
   FIELD DeadlineCartaCredito        AS INT  
   FIELD ValorCartaCredito           AS DEC  
   FIELD CodigoMoedaEMS              AS INT.
   
/*Dataset de sa¡da*/
DEFINE TEMP-TABLE MSG0231R1 NO-UNDO XML-NODE-NAME 'MSG0231R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

/*Outras Defini‡äes*/

DEF TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-erro           NO-UNDO
   FIELD mensagem AS CHARACTER FORMAT "x(250)".

{method/dbotterr.i}
