/*************************************************************************************************************************************************************************
** Copyright PRIME Consultoria (2014)                                                                                                                                   **
** Todos os Direitos Reservados.                                                                                                                                        **
**                                                                                                                                                                      **
** Este fonte ‚ de propriedade exclusiva da PRIME Consultoria, sua reprodu‡Æo parcial ou total por qualquer meio, s¢ poder  ser feita mediante autoriza‡Æo expressa     **
**                                                                                                                                                                      **
**************************************************************************************************************************************************************************
** Programa .....: PRMUPC-BODI135CANCEL                                                                                                                                 ** 
** Data .........: Julho de 2022                                                                                                                                        **
** Autor ........: Prime Consultoria                                                                                                                                    **
** Objetivo .....: Permitir cancelamento de NF com prazo maior que 3 dias                                                                                               **
** Revisäes **************************************************************************************************************************************************************
** Autor         Ver.   Data       Cliente      Solicitante    Descri‡Æo                                                                                                **
** Gabriel Poli  00.001 06/07/2022 Prime        Prime          1) Desenvolvimento inicial do programa                                                                   **
**                                                                                                                                                                      **
*************************************************************************************************************************************************************************/
{utp/ut-glob.i}
{include/i-epc200.i bodi135cancel}

/*--- Defini‡Æo Parƒmetros ---*/
DEFINE INPUT PARAMETER p-ind-event   AS CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

/*--- Variaveis Globais ---*/

/*--- Variaveis Locais ---*/

/*--- Buffers ---*/
DEFINE BUFFER bf-nota-fiscal FOR nota-fiscal.
DEFINE BUFFER bf-tt-epc      FOR tt-epc.

/*--- Inicio Execu‡Æo ---*/
RUN ValidarCancelamentoNotaFiscal.

RETURN "OK":U.

/*------------------------------------------- Procedures Internas --------------------------------------------*/
PROCEDURE ValidarCancelamentoNotaFiscal:

    IF p-ind-event = "ValidaEmissaoMaior3Dias" THEN DO:
        FOR EACH tt-epc NO-LOCK
            WHERE tt-epc.cod-event     = p-ind-event
              AND tt-epc.cod-parameter = "Rowid_NotaFiscal".
          
            FIND FIRST nota-fiscal NO-LOCK 
                 WHERE ROWID(nota-fiscal) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
            IF AVAILABLE nota-fiscal THEN DO:               

                FIND FIRST prm-projeto-integrador NO-LOCK
                     WHERE prm-projeto-integrador.serie = nota-fiscal.serie NO-ERROR.

                IF AVAIL prm-projeto-integrador THEN DO:
                    ASSIGN tt-epc.val-parameter = "FALSE".
                    CREATE bf-tt-epc.
                    ASSIGN bf-tt-epc.cod-event     = "ValidaEmissaoMaior3Dias"
                           bf-tt-epc.cod-parameter = "Return_Valid"
                           bf-tt-epc.val-parameter = STRING(NO). /* Nao valida emissao maior que tres dias */

                END.
            END.
        END.
    END.

END PROCEDURE.
