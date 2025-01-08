DEFINE TEMP-TABLE ttProcEventoNFe NO-UNDO SERIALIZE-NAME "procEventoNFe"    
    FIELD versao AS CHARACTER XML-NODE-TYPE "ATTRIBUTE".
    
DEFINE TEMP-TABLE ttEvento NO-UNDO SERIALIZE-NAME "evento"
    FIELD parent-id AS RECID        SERIALIZE-HIDDEN
    FIELD versao    AS CHARACTER    XML-NODE-TYPE "ATTRIBUTE".

DEFINE TEMP-TABLE ttDetEvento NO-UNDO SERIALIZE-NAME "detEvento"
    FIELD parent-id AS RECID        SERIALIZE-HIDDEN
    FIELD versao    AS CHARACTER    XML-NODE-TYPE "ATTRIBUTE"
    FIELD descEvento AS CHARACTER
    FIELD nProt     AS CHARACTER
    FIELD xJust     AS CHARACTER.

DEFINE TEMP-TABLE ttInfEvento NO-UNDO SERIALIZE-NAME "infEvento"
    FIELD parent-id  AS RECID       SERIALIZE-HIDDEN
    FIELD Id         AS CHARACTER   XML-NODE-TYPE "ATTRIBUTE"
    FIELD cOrgao     AS CHARACTER
    FIELD tpAmb      AS CHARACTER
    FIELD CNPJ       AS CHARACTER
    FIELD chNFe      AS CHARACTER
    FIELD dhEvento   AS CHARACTER
    FIELD tpEvento   AS CHARACTER
    FIELD nSeqEvento AS CHARACTER
    FIELD verEvento  AS CHARACTER.
                  
DEFINE DATASET XMLNotaCanc SERIALIZE-HIDDEN
    FOR ttProcEventoNFe,
            ttEvento,
                ttInfEvento,
                    ttDetEvento
    PARENT-ID-RELATION dr1  FOR ttProcEventoNFe,ttEvento    PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr2  FOR ttEvento,ttInfEvento        PARENT-ID-FIELD parent-id
    PARENT-ID-RELATION dr3  FOR ttInfEvento,ttDetEvento     PARENT-ID-FIELD parent-id.
