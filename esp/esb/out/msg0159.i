 
DEFINE TEMP-TABLE MSG0159 NO-UNDO XML-NODE-NAME 'MSG0159'
    FIELD idm  AS INT XML-NODE-TYPE 'hidden'.

DEFINE TEMP-TABLE msg0159-BeneficioCanalItens NO-UNDO XML-NODE-NAME 'BeneficioCanalItens'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE msg0159-BeneficioCanalItem NO-UNDO XML-NODE-NAME 'BeneficioCanalItem'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoBeneficioCanal        AS CHAR INIT ?
   FIELD VerbaCalculada              AS DEC
   FIELD VerbaPeriodoAnterior        AS DEC
   FIELD VerbaTotal                  AS DEC
   FIELD VerbaEmpenhada              AS DEC
   FIELD VerbaReembolsada            AS DEC
   FIELD VerbaCancelada              AS DEC
   FIELD VerbaAjustada               AS DEC
   FIELD VerbaDisponivel             AS DEC.
   
DEFINE TEMP-TABLE MSG0159r NO-UNDO XML-NODE-NAME 'MSG0159R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD proprietario AS CHAR
    FIELD tipo-proprietario AS CHAR.


