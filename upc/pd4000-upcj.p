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
*******************************************************************************/
DEFINE INPUT PARAM p-nome-abrev-tri-pd4000 AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAM p-nome-transp-pd4000    AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAM p-nat-operacao-pd4000   AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAM p-cidade-cif-pd4000     AS WIDGET-HANDLE NO-UNDO.


IF p-nome-abrev-tri-pd4000:SENSITIVE AND p-nome-transp-pd4000:SENSITIVE THEN DO:
    FIND emitente
         WHERE emitente.nome-abrev = p-nome-abrev-tri-pd4000:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    FIND transporte 
         WHERE transporte.cod-transp = emitente.cod-transp
        NO-LOCK NO-ERROR.
    FIND natur-oper
         WHERE natur-oper.nat-operacao = p-nat-operacao-pd4000:SCREEN-VALUE
         NO-LOCK NO-ERROR.
    FIND FIRST loc-entr
            WHERE loc-entr.nome-abrev  = emitente.nome-abrev
            AND   loc-entr.cod-entrega = "Padr∆o"
        no-LOCK NO-ERROR.
    IF AVAIL emitente AND natur-oper.log-oper-triang THEN DO:
        ASSIGN p-nome-transp-pd4000:screen-value = transporte.nome-abrev.
        IF AVAIL loc-entr THEN
           ASSIGN p-cidade-cif-pd4000:SCREEN-VALUE = loc-entr.nom-cidad-cif .
    END.
END.
