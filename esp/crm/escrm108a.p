/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*{include/i-prgvrs.i <Nome do Programa> 2.00.00.000}  /*** 010000 ***/*/
/*******************************************************************************
**  Programa: ADEEDIT\(C).P
**  Objetivo: <comment>
**  Autor...: Intelbras - USER    
**  Data....: 19.05.2008 16:11
** Programa verifica se existe algum item dentro da estrutura que esteja com o 
** campo garantia maior que zero
*******************************************************************************/
/* parametros */

DEF INPUT PARAMETER c-it-codigo AS CHAR NO-UNDO.
DEF INPUT PARAMETER c-data      AS DATE NO-UNDO.
DEF OUTPUT PARAMETER c-garantia AS LOGICAL NO-UNDO.

ASSIGN c-garantia = NO.
       
RUN pi-looping (INPUT c-it-codigo).

PROCEDURE pi-looping:
    DEF INPUT PARAM p-it-codigo AS CHAR NO-UNDO.
    
    FOR EACH estrutura
       WHERE estrutura.it-codigo = p-it-codigo AND
             estrutura.data-inicio <= c-data AND
             estrutura.data-termino > c-data NO-LOCK:

        FIND FIRST int-estrutura NO-LOCK
             WHERE int-estrutura.it-codigo = estrutura.it-codigo
               AND int-estrutura.sequencia = estrutura.sequencia
               AND int-estrutura.es-codigo = estrutura.es-codigo NO-ERROR.

        IF AVAIL int-estrutura AND int-estrutura.garantia > 0 THEN DO:
            ASSIGN c-garantia = YES.
            RETURN "NOK".
        END.
        
        RUN pi-looping (INPUT estrutura.es-codigo).
    END.
    RETURN "OK".
END PROCEDURE.
