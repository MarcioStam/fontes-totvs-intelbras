/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN356VLUPC 2.00.00.000}  /*** 010000 ***/
/***********************************************************************
**  Programa.: BOIN356VL-UPC
**  Autor....: Silvio Ferrari
**  Descricao: UPC
************************************************************************/
{include/i-epc200.i1}
{method/dbotterr.i}
DEF INPUT PARAM  p-ind-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEFINE VARIABLE h-dbo-handle   AS HANDLE NO-UNDO.
/* ------------------------------------------- */

CASE p-ind-event:
    WHEN "validateUpdateManutOrdCompra" THEN DO:

        FOR FIRST tt-epc WHERE tt-epc.cod-event = p-ind-event:

            ASSIGN h-dbo-handle = WIDGET-HANDLE(tt-epc.val-parameter).

            EMPTY TEMP-TABLE RowErrors.

            IF VALID-HANDLE(h-dbo-handle) THEN DO:

                RUN getRowErrors IN h-dbo-handle (output table RowErrors).

                FIND FIRST RowErrors WHERE RowErrors.ErrorNumber = 3048 NO-ERROR.

                IF AVAIL RowErrors THEN DO:
                    DELETE RowErrors.

                    RUN emptyRowErrors IN h-dbo-handle.
    
                    IF CAN-FIND (FIRST RowErrors ) THEN DO:
                        FOR EACH RowErrors:
                            RUN _insertErrorManual IN h-dbo-handle (INPUT RowErrors.ErrorNumber,
                                                                    INPUT RowErrors.ErrorType,
                                                                    INPUT RowErrors.ErrorSubType,
                                                                    INPUT RowErrors.ErrorDescription,
                                                                    INPUT RowErrors.ErrorHelp,
                                                                    INPUT RowErrors.ErrorParameters).
                        END.
                    END.
                END.
            END.
        END.
    END.

END CASE.
/* ------------------------------------------- */
RETURN "OK".
