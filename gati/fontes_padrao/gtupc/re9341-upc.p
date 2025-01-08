/*******************************************************************************
** Copyright GATI  (2015)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da GATI, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{include/i-prgvrs.i RE9341-UPC 2.00.00.000}  /*** 010000 ***/

{include/i-epc200.i} /** Defini»’o tt-EPC **/
{method/dbotterr.i}

DEFINE INPUT PARAM p-ind-event AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEFINE NEW GLOBAL SHARED VARIABLE gl-c-cod-esp AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gl-dt-vencim AS DATE      NO-UNDO.

DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

&if "{&pre-empresa}" = "Parati" &then
IF  p-ind-event = "After-Invoice-Generation":U THEN DO:
    
    FOR FIRST tt-epc NO-LOCK 
        WHERE tt-epc.cod-event     = p-ind-event
          AND tt-epc.cod-parameter = "ROWID(docum-est)":U:

        FOR FIRST docum-est
            WHERE ROWID(docum-est) = TO-ROWID(tt-epc.val-parameter):

            FOR FIRST dupli-apagar OF docum-est EXCLUSIVE-LOCK:
    
                DO i-cont = 1 TO 6:
    
                    IF PROGRAM-NAME(i-cont) MATCHES "*GATI0102*" THEN DO:
                        IF gl-c-cod-esp <> "" THEN
                            ASSIGN dupli-apagar.cod-esp   = gl-c-cod-esp.
                        IF gl-dt-vencim <> ?  THEN
                            ASSIGN dupli-apagar.dt-vencim = gl-dt-vencim.
                    END.
                END.

                ASSIGN gl-c-cod-esp           = ""
                       gl-dt-vencim           = ?.
            END.
        END.        
    END.
END.
&endif
RETURN "OK".
