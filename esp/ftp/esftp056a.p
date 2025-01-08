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
DEFINE INPUT  PARAMETER c-cod-estabel                        AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER c-especie                            AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER c-serie                              AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER c-nr-nota-fis                        AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER c-parcela                            AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER da-dt-vencto                         AS DATE        NO-UNDO.

FIND FIRST nota-fiscal NO-LOCK
     WHERE nota-fiscal.cod-estabel = c-cod-estabel
       AND nota-fiscal.serie       = c-serie
       AND nota-fiscal.nr-nota-fis = c-nr-nota-fis NO-ERROR.
IF NOT AVAIL nota-fiscal
THEN DO: 
     NEXT.
END.

FIND tit_acr
    WHERE tit_acr.cod_estab   = c-cod-estabel
      AND tit_acr.cod_espec   = c-especie
      AND tit_acr.cod_ser     = c-serie
      AND tit_acr.cod_tit_acr = nota-fiscal.nr-fatura
      AND tit_acr.cod_parcela = c-parcela
    NO-LOCK NO-ERROR.
IF AVAIL tit_acr THEN
   ASSIGN da-dt-vencto = tit_acr.dat_vencto_tit_acr .
ELSE
   ASSIGN da-dt-vencto = ?.
RETURN "OK".
