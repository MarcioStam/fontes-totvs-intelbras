/*************************************************************************************************************************************************************************
** Copyright PRIME Consultoria (2014)                                                                                                                                   **
** Todos os Direitos Reservados.                                                                                                                                        **
**                                                                                                                                                                      **
** Este fonte ‚ de propriedade exclusiva da PRIME Consultoria, sua reprodu‡Æo parcial ou total por qualquer meio, s¢ poder  ser feita mediante autoriza‡Æo expressa     **
**                                                                                                                                                                      **
**************************************************************************************************************************************************************************
** Programa .....: prmapi-fecha-procedure.p                                                                                                                             ** 
** Data .........: Outubro de 2021                                                                                                                                      **
** Autor ........: Prime Consultoria                                                                                                                                    **
** Objetivo .....: Fechar procedure aberta sem pai                                                                                                                      **
** Revisäes **************************************************************************************************************************************************************
** Autor         Ver.    Data        Cliente      Solicitante    Descri‡Æo                                                                                              **
** Pedro Vicari  00.001  29/10/2021  CRS          CRS            1) Desenvolvimento inicial do programa                                                                 **
**                                                                                                                                                                      **
*************************************************************************************************************************************************************************/
/*--- Defini‡Æo Parƒmetros ---*/
DEFINE INPUT PARAMETER p-procedure     AS CHARACTER    NO-UNDO.

/*--- Variaveis Globais ---*/

/*--- Variaveis Locais ---*/

/*--- Buffers ---*/

/*--- Inicio Execu‡Æo ---*/
RUN fecharProcedureSemPai(INPUT p-procedure).


RETURN "OK":U.

/*------------------------------------------- Procedures Internas --------------------------------------------*/
PROCEDURE fecharProcedureSemPai:
    /*Fechar uma procedure aberta*/

    DEFINE INPUT PARAMETER p-procedure     AS CHARACTER    NO-UNDO. /*Nome da procedure a ser fechada*/

    DEFINE VARIABLE h-procedure     AS HANDLE   NO-UNDO.
    DEFINE VARIABLE h-procedure-del AS HANDLE   NO-UNDO.
    DEFINE VARIABLE h-procedure-pai AS HANDLE   NO-UNDO.

    ASSIGN h-procedure = SESSION:FIRST-PROCEDURE.

    DO WHILE h-procedure <> ?:
        IF h-procedure:NAME = p-procedure THEN DO:
            ASSIGN h-procedure-pai = h-procedure:INSTANTIATING-PROCEDURE.
            IF NOT VALID-HANDLE(h-procedure-pai) THEN DO:
                ASSIGN h-procedure-del = h-procedure.
            END.
        END.
        ASSIGN h-procedure = h-procedure:NEXT-SIBLING.

        IF VALID-HANDLE(h-procedure-del) THEN
            DELETE PROCEDURE h-procedure-del.
    END.
END PROCEDURE.

