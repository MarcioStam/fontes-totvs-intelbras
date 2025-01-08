/************************************************************************
* Programa ..: <name>
* Data ......: 12.08.2019 20:45
* Empresa ...: LHC Informatica
* Cliente ...: ...
* Vers„o ....: 2.12.01.001
* Autor .....: Maicon Machry
*************************************************************************/
def output param c-usuario as char no-undo.
def output param c-senha   as char no-undo.

/** Conex∆o com o EMS para a execuá∆o de BO **/
FIND FIRST ponto-programa
    WHERE ponto-programa.nome-programa = "escrm004":U
      AND ponto-programa.ponto         = 1 NO-LOCK NO-ERROR.
    
IF AVAILABLE ponto-programa THEN DO:
    FOR EACH conteudo-programa
       WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa NO-LOCK:
            
        IF conteudo-programa.sequencia = 1 THEN DO:
            assign c-usuario = ENTRY(1,conteudo-programa.conteudo,",")
                   c-senha   = ENTRY(2,conteudo-programa.conteudo,",").
        END.
    END.
END.
