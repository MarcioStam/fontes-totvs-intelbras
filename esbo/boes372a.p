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
DEFINE INPUT PARAMETER p-class-fiscal AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-destaque     AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER p-retorno     AS LOGICAL   NO-UNDO.

FIND FIRST destaque-classif-fisc NO-LOCK
     WHERE destaque-classif-fisc.class-fiscal  = p-class-fiscal
       AND destaque-classif-fisc.destaque      = p-destaque NO-ERROR.
ASSIGN p-retorno = AVAIL destaque-classif-fisc.
