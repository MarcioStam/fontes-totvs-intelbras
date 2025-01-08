{esp/esb/esesb000.i}

/*Data set entrada*/
DEFINE TEMP-TABLE MSG0228 NO-UNDO XML-NODE-NAME 'MSG0228'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE Identificadores NO-UNDO XML-NODE-NAME 'Identificadores'
   FIELD idm                AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD IdentificacaoCampo AS INTEGER.

/*Data set retorno*/
DEFINE TEMP-TABLE MSG0228R1 NO-UNDO XML-NODE-NAME 'MSG0228R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE ListaRegistrosCampos NO-UNDO XML-NODE-NAME 'ListaRegistrosCampos'
   FIELD idm                AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD IdentificacaoCampo AS INTEGER.

DEFINE TEMP-TABLE RegistroCampo NO-UNDO XML-NODE-NAME 'RegistroCampo'
   FIELD idm                AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD IdentificacaoCampo AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoRegistro     AS CHARACTER
   FIELD DescricaoRegistro  AS CHARACTER.

/*Outras defini‡äes*/
DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".
