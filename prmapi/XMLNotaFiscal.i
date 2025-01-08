DEFINE TEMP-TABLE ttNfeProc NO-UNDO SERIALIZE-NAME "nfeProc"    
    FIELD versao AS CHARACTER XML-NODE-TYPE "ATTRIBUTE".
    
DEFINE TEMP-TABLE ttNfe NO-UNDO SERIALIZE-NAME "NFe"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN.    

DEFINE TEMP-TABLE ttInfNFe NO-UNDO SERIALIZE-NAME "infNFe"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD Id        AS CHARACTER XML-NODE-TYPE "ATTRIBUTE".
                  
DEFINE TEMP-TABLE ttIde NO-UNDO SERIALIZE-NAME "ide"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN 
    FIELD cUF      AS CHARACTER
    FIELD cNF      AS CHARACTER
    FIELD natOp    AS CHARACTER
    FIELD nNF      AS CHARACTER
    FIELD serie    AS CHARACTER
    FIELD dhEmi    AS CHARACTER
    FIELD idDest   AS CHARACTER.
    
DEFINE TEMP-TABLE ttNFref NO-UNDO SERIALIZE-NAME "NFref"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN 
    FIELD refNFe    AS CHARACTER.
    
DEFINE TEMP-TABLE ttEmit NO-UNDO SERIALIZE-NAME "emit"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN 
    FIELD CNPJ      AS CHARACTER
    FIELD xNome     AS CHARACTER.
    
DEFINE TEMP-TABLE ttDest NO-UNDO SERIALIZE-NAME "dest"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN 
    FIELD CNPJ      AS CHARACTER
    FIELD CPF       AS CHARACTER
    FIELD xNome     AS CHARACTER
    FIELD IE        AS CHARACTER.           
    
DEFINE TEMP-TABLE ttEnderDest NO-UNDO SERIALIZE-NAME "enderDest"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN 
    FIELD xLgr      AS CHARACTER
    FIELD nro       AS CHARACTER
    FIELD xBairro   AS CHARACTER
    FIELD xMun      AS CHARACTER
    FIELD UF        AS CHARACTER
    FIELD CEP       AS CHARACTER
    FIELD xPais     AS CHARACTER
    FIELD xCpl      AS CHARACTER.
    
DEFINE TEMP-TABLE ttDet NO-UNDO SERIALIZE-NAME "det"
    FIELD parent-id  AS RECID SERIALIZE-HIDDEN 
    FIELD nItem      AS INTEGER XML-NODE-TYPE "ATTRIBUTE".                           
    
DEFINE TEMP-TABLE ttProd NO-UNDO SERIALIZE-NAME "prod"
    FIELD parent-id  AS RECID SERIALIZE-HIDDEN 
    FIELD cProd      AS CHARACTER
    FIELD qCom       AS DECIMAL
    FIELD vUnCom     AS DECIMAL
    FIELD uCom       AS CHARACTER
    FIELD NCM        AS CHARACTER
    FIELD CFOP       AS CHARACTER
    FIELD vProd      AS DECIMAL
    FIELD vFrete     AS DECIMAL
    FIELD vDesc      AS DECIMAL.
    
DEFINE TEMP-TABLE ttRastro NO-UNDO SERIALIZE-NAME "rastro"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN    
    FIELD nLote     AS CHARACTER
    FIELD qLote     AS DECIMAL
    FIELD dFab      AS CHARACTER
    FIELD dVal      AS CHARACTER.
    
DEFINE TEMP-TABLE ttImposto NO-UNDO SERIALIZE-NAME "imposto"
    FIELD parent-id  AS RECID SERIALIZE-HIDDEN.      
    
DEFINE TEMP-TABLE ttICMS NO-UNDO SERIALIZE-NAME "ICMS"
    FIELD parent-id  AS RECID SERIALIZE-HIDDEN.     

DEFINE TEMP-TABLE ttICMS00 NO-UNDO SERIALIZE-NAME "ICMS00"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD orig      AS INTEGER
    FIELD CST       AS CHARACTER
    FIELD modBC     AS INTEGER
    FIELD vBC       AS DECIMAL
    FIELD pICMS     AS DECIMAL
    FIELD vICMS     AS DECIMAL.

DEFINE TEMP-TABLE ttICMS10 NO-UNDO SERIALIZE-NAME "ICMS10"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD CST       AS CHARACTER    
    FIELD orig      AS INTEGER
    FIELD vBC       AS DECIMAL
    FIELD pICMS     AS DECIMAL
    FIELD vICMS     AS DECIMAL
    FIELD vBCST     AS DECIMAL
    FIELD pICMSST   AS DECIMAL
    FIELD vICMSST   AS DECIMAL
    FIELD vBCFCPST  AS DECIMAL
    FIELD pFCPST    AS DECIMAL
    FIELD vFCPST    AS DECIMAL.    
    
DEFINE TEMP-TABLE ttICMS20 NO-UNDO SERIALIZE-NAME "ICMS20"    
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD orig      AS INTEGER
    FIELD CST       AS CHARACTER
    FIELD modBC     AS CHARACTER
    FIELD pRedBC    AS DECIMAL
    FIELD vBC       AS DECIMAL
    FIELD pICMS     AS DECIMAL
    FIELD vICMS     AS DECIMAL.    
    
DEFINE TEMP-TABLE ttICMS30 NO-UNDO SERIALIZE-NAME "ICMS30"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD CST       AS CHARACTER
    FIELD orig      AS INTEGER.    
    
DEFINE TEMP-TABLE ttICMS40 NO-UNDO SERIALIZE-NAME "ICMS40"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD orig      AS INTEGER
    FIELD CST       AS CHARACTER.   
    
DEFINE TEMP-TABLE ttICMS50 NO-UNDO SERIALIZE-NAME "ICMS50"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD CST       AS CHARACTER
    FIELD orig      AS INTEGER.
    
DEFINE TEMP-TABLE ttICMS51 NO-UNDO SERIALIZE-NAME "ICMS51"    
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD orig      AS INTEGER
    FIELD CST       AS CHARACTER
    FIELD modBC     AS CHARACTER
    FIELD pRedBC    AS DECIMAL
    FIELD vBC       AS DECIMAL
    FIELD pICMS     AS DECIMAL
    FIELD vICMS     AS DECIMAL.     
    
DEFINE TEMP-TABLE ttICMS60 NO-UNDO SERIALIZE-NAME "ICMS60"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD CST       AS CHARACTER
    FIELD orig      AS INTEGER.                    
    
DEFINE TEMP-TABLE ttICMS70 NO-UNDO SERIALIZE-NAME "ICMS70"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD orig      AS INTEGER
    FIELD CST       AS CHARACTER
    FIELD modBC     AS CHARACTER
    FIELD pRedBC    AS DECIMAL
    FIELD vBC       AS DECIMAL
    FIELD pICMS     AS DECIMAL
    FIELD vICMS     AS DECIMAL.    
    
DEFINE TEMP-TABLE ttICMS90 NO-UNDO SERIALIZE-NAME "ICMS90"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD orig      AS INTEGER
    FIELD CST       AS CHARACTER
    FIELD modBC     AS CHARACTER
    FIELD pRedBC    AS DECIMAL
    FIELD vBC       AS DECIMAL
    FIELD pICMS     AS DECIMAL
    FIELD vICMS     AS DECIMAL.    
    
DEFINE TEMP-TABLE ttIPI NO-UNDO SERIALIZE-NAME "IPI"
    FIELD parent-id  AS RECID SERIALIZE-HIDDEN.    
    
DEFINE TEMP-TABLE ttIPINT NO-UNDO SERIALIZE-NAME "IPINT"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD CST       AS CHARACTER.    
    
DEFINE TEMP-TABLE ttIPITrib NO-UNDO SERIALIZE-NAME "IPITrib"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD CST       AS CHARACTER
    FIELD vBC       AS DECIMAL
    FIELD pIPI      AS DECIMAL
    FIELD vIPI      AS DECIMAL.    
    
DEFINE TEMP-TABLE ttPIS NO-UNDO SERIALIZE-NAME "PIS"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN.    

DEFINE TEMP-TABLE ttPISAliq NO-UNDO SERIALIZE-NAME "PISAliq"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD vBC       AS DECIMAL
    FIELD pPIS      AS DECIMAL
    FIELD vPIS      AS DECIMAL.

DEFINE TEMP-TABLE ttPISOutr NO-UNDO SERIALIZE-NAME "PISOutr"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD vBC       AS DECIMAL
    FIELD pPIS      AS DECIMAL
    FIELD vPIS      AS DECIMAL. 
    
DEFINE TEMP-TABLE ttCOFINS NO-UNDO SERIALIZE-NAME "COFINS"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN.    

DEFINE TEMP-TABLE ttCOFINSAliq NO-UNDO SERIALIZE-NAME "COFINSAliq"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD vBC       AS DECIMAL
    FIELD pCOFINS   AS DECIMAL
    FIELD vCOFINS   AS DECIMAL.

DEFINE TEMP-TABLE ttCOFINSOutr NO-UNDO SERIALIZE-NAME "COFINSOutr"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD vBC       AS DECIMAL
    FIELD pCOFINS   AS DECIMAL
    FIELD vCOFINS   AS DECIMAL.  
    
DEFINE TEMP-TABLE ttICMSUFDest NO-UNDO SERIALIZE-NAME "ICMSUFDest"
    FIELD parent-id         AS RECID SERIALIZE-HIDDEN
    FIELD vBCUFDest         AS DECIMAL
    FIELD vBCFCPUFDest      AS DECIMAL
    FIELD pFCPUFDest        AS DECIMAL
    FIELD pICMSUFDest       AS DECIMAL
    FIELD pICMSInter        AS DECIMAL
    FIELD pICMSInterPart    AS DECIMAL
    FIELD vFCPUFDest        AS DECIMAL
    FIELD vICMSUFDest       AS DECIMAL
    FIELD vICMSUFRemet      AS DECIMAL.       

DEFINE TEMP-TABLE ttTotal NO-UNDO SERIALIZE-NAME "total"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN.      
    
DEFINE TEMP-TABLE ttICMSTot NO-UNDO SERIALIZE-NAME "ICMSTot"
    FIELD parent-id  AS RECID SERIALIZE-HIDDEN
    FIELD vProd      AS DECIMAL
    FIELD vFrete     AS DECIMAL    
    FIELD vOutro     AS DECIMAL    
    FIELD vSeg       AS DECIMAL
	FIELD vDesc      AS DECIMAL.
    
DEFINE TEMP-TABLE ttTransp NO-UNDO SERIALIZE-NAME "transp"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN.    
    
DEFINE TEMP-TABLE ttTransporta NO-UNDO SERIALIZE-NAME "transporta"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD cnpj      AS CHARACTER.    
    
/* DAC */
DEFINE TEMP-TABLE ttPag NO-UNDO SERIALIZE-NAME "pag"
    FIELDS parent-id AS RECID SERIALIZE-HIDDEN.

DEFINE TEMP-TABLE ttdetPag NO-UNDO SERIALIZE-NAME "detPag"
    FIELDS parent-id    AS RECID SERIALIZE-HIDDEN 
    FIELDS indPag       AS INTEGER
    FIELDS tPag         AS INTEGER
    FIELDS vPag         AS DECIMAL.

DEFINE TEMP-TABLE ttVol NO-UNDO SERIALIZE-NAME "vol"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD qVol      AS CHARACTER
    FIELD pesoL     AS DECIMAL
    FIELD pesoB     AS DECIMAL.    
    
DEFINE TEMP-TABLE ttCobr NO-UNDO SERIALIZE-NAME "cobr"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN.    
    
DEFINE TEMP-TABLE ttFat NO-UNDO SERIALIZE-NAME "fat"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD nFat      AS CHARACTER
    FIELD vLiq      AS DECIMAL.    
    
DEFINE TEMP-TABLE ttDup NO-UNDO SERIALIZE-NAME "dup"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN
    FIELD nDup      AS CHARACTER
    FIELD dVenc     AS CHARACTER
    FIELD vDup      AS DECIMAL.    
    
DEFINE TEMP-TABLE ttProtNFe NO-UNDO SERIALIZE-NAME "protNFe"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN 
    FIELD versao    AS CHARACTER XML-NODE-TYPE "ATTRIBUTE".    
    
DEFINE TEMP-TABLE ttInfProt NO-UNDO SERIALIZE-NAME "infProt"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN 
    FIELD tbAmb     AS INTEGER
    FIELD verAlpic  AS CHARACTER
    FIELD chNFe     AS CHARACTER
    FIELD dhRecbto  AS CHARACTER
    FIELD nProt     AS CHARACTER
    FIELD digVal    AS CHARACTER
    FIELD cStat     AS INTEGER
    FIELD xMotivo   AS CHARACTER.    
    
DEFINE TEMP-TABLE ttInfAdic NO-UNDO SERIALIZE-NAME "infAdic"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN 
    FIELD infCpl    AS CHARACTER. 

DEFINE TEMP-TABLE ttObsCont NO-UNDO SERIALIZE-NAME "obsCont"
    FIELD parent-id AS RECID SERIALIZE-HIDDEN 
    FIELD xTexto    AS CHARACTER. 

DEFINE DATASET XMLNotaFiscal SERIALIZE-HIDDEN
    FOR ttnfeProc,
            ttnfe,
                ttinfNFe,
                    ttIde,
                        ttNFref,
                    ttEmit,    
                    ttDest,  
                        ttEnderDest,              
                    ttDet,
                        ttProd,
                            ttRastro,
                        ttImposto,
                            ttICMS,
                                ttICMS00,
                                ttICMS10,
                                ttICMS20,
                                ttICMS30,
                                ttICMS40,
                                ttICMS50,
                                ttICMS51,
                                ttICMS60,
                                ttICMS70,
                                ttICMS90,                                
                            ttIPI,
                                ttIPINT,
                                ttIPITrib,
                            ttPIS,
                                ttPISAliq,
                                ttPISOutr,
                            ttCOFINS,
                                ttCOFINSAliq,
                                ttCOFINSOutr,
                            ttICMSUFDest,
                    ttTotal,
                        ttICMSTot,
                    ttTransp,
                        ttTransporta,
                        ttVol,
                    ttPag,
                        ttdetPag,
                    ttCobr,
                        ttFat,
                        ttDup,
                    ttInfAdic,
                        ttObsCont,
            ttProtNFe,
                ttInfProt
    PARENT-ID-RELATION dr1  FOR ttnfeProc   ,ttnfe          PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr2  FOR ttnfe       ,ttinfNFe       PARENT-ID-FIELD parent-id                        
    PARENT-ID-RELATION dr3  FOR ttinfNFe    ,ttide          PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr4  FOR ttinfNFe    ,ttEmit         PARENT-ID-FIELD parent-id    
    PARENT-ID-RELATION dr5  FOR ttinfNFe    ,ttDest         PARENT-ID-FIELD parent-id       
    PARENT-ID-RELATION dr6  FOR ttDest      ,ttEnderDest    PARENT-ID-FIELD parent-id    
    PARENT-ID-RELATION dr7  FOR ttinfNFe    ,ttdet          PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr8  FOR ttdet       ,ttProd         PARENT-ID-FIELD parent-id        
    PARENT-ID-RELATION dr9  FOR ttProd      ,ttRastro       PARENT-ID-FIELD parent-id    
    PARENT-ID-RELATION dr10 FOR ttdet       ,ttImposto      PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr11 FOR ttImposto   ,ttICMS         PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr12 FOR ttImposto   ,ttIPI          PARENT-ID-FIELD parent-id       
    PARENT-ID-RELATION dr13 FOR ttImposto   ,ttPIS          PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr14 FOR ttPIS       ,ttPISAliq      PARENT-ID-FIELD parent-id 
    PARENT-ID-RELATION dr15 FOR ttPIS       ,ttPISOutr      PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr16 FOR ttImposto   ,ttCOFINS       PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr17 FOR ttCOFINS    ,ttCOFINSAliq   PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr18 FOR ttCOFINS    ,ttCOFINSOutr   PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr19 FOR ttImposto   ,ttICMSUFDest   PARENT-ID-FIELD parent-id    
    PARENT-ID-RELATION dr20 FOR ttICMS      ,ttICMS00       PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr21 FOR ttICMS      ,ttICMS10       PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr22 FOR ttICMS      ,ttICMS20       PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr23 FOR ttICMS      ,ttICMS30       PARENT-ID-FIELD parent-id           
    PARENT-ID-RELATION dr24 FOR ttICMS      ,ttICMS40       PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr25 FOR ttICMS      ,ttICMS50       PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr26 FOR ttICMS      ,ttICMS51       PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr27 FOR ttICMS      ,ttICMS60       PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr28 FOR ttICMS      ,ttICMS70       PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr29 FOR ttICMS      ,ttICMS90       PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr30 FOR ttIPI       ,ttIPINT        PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr31 FOR ttIPI       ,ttIPITrib      PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr32 FOR ttinfNFe    ,ttTotal        PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr33 FOR ttTotal     ,ttICMSTot      PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr34 FOR ttinfNFe    ,ttTransp       PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr35 FOR ttTransp    ,ttTransporta   PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr36 FOR ttTransp    ,ttVol          PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr37 FOR ttinfNFe    ,ttPag          PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr38 FOR ttPag       ,ttdetPag       PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr39 FOR ttinfNFe    ,ttCobr         PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr40 FOR ttCobr      ,ttFat          PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr41 FOR ttCobr      ,ttDup          PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr42 FOR ttnfe       ,ttProtNFe      PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr43 FOR ttProtNFe   ,ttInfProt      PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr44 FOR ttProtNFe   ,ttInfAdic      PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr45 FOR ttide       ,ttNFref        PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr46 FOR ttInfAdic   ,ttObsCont      PARENT-ID-FIELD parent-id.
