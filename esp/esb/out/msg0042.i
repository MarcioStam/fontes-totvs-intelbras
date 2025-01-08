{esp/esb/esesb000.i}.

DEFINE TEMP-TABLE msg0042 NO-UNDO XML-NODE-NAME 'MSG0042'
    FIELD idm                   AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoEstabelecimento AS INTEGER
    FIELD Nome                  AS CHARACTER
    FIELD RazaoSocial           AS CHARACTER
    FIELD CNPJ                  AS CHARACTER
    FIELD InscricaoEstadual     AS CHARACTER
    FIELD Endereco              AS CHARACTER
    FIELD Cidade                AS CHARACTER
    FIELD UF                    AS CHARACTER
    FIELD CEP                   AS CHARACTER
    FIELD Situacao              AS INTEGER.
    
      
DEFINE TEMP-TABLE msg0042r NO-UNDO XML-NODE-NAME 'MSG0042R1'
   FIELD idm AS INT XML-NODE-TYPE 'hidden'.
