{esp/esb/esesb000.i}.

DEFINE TEMP-TABLE msg0084 NO-UNDO XML-NODE-NAME 'MSG0084'
    field idm                	 as int XML-NODE-TYPE 'hidden'
    field SiglaUnidadeMedida 	 as character
    field DescricaoUnidadeMedida as character 
    field UnidadeBase        	 as character
    field Quantidade         	 as decimal
    field GrupoUnidadeMedida 	 as character.
    
    
DEFINE TEMP-TABLE msg0084r NO-UNDO XML-NODE-NAME 'MSG0084R1'
   FIELD idm AS INT XML-NODE-TYPE 'hidden'.
