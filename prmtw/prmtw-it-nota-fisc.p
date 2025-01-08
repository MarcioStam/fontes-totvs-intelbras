/*************************************************************************************************************************************************************************
** Copyright PRIME Consultoria (2014)                                                                                                                                   **
** Todos os Direitos Reservados.                                                                                                                                        **
**                                                                                                                                                                      **
** Este fonte ‚ de propriedade exclusiva da PRIME Consultoria, sua reprodu‡Æo parcial ou total por qualquer meio, s¢ poder  ser feita mediante autoriza‡Æo expressa     **
**                                                                                                                                                                      **
**************************************************************************************************************************************************************************
** Programa .....: prmtw-it-nota-fisc                                                                                                                                   ** 
** Data .........: Maio de 2022                                                                                                                                         **
** Autor ........: Prime Consultoria                                                                                                                                    **
** Objetivo .....: Replicar desconto para notas importadas                                                                                                              **
** Revisäes **************************************************************************************************************************************************************
** Autor         Ver.   Data       Cliente      Solicitante    Descri‡Æo                                                                                                **
** Felipe Kato   00.001 31/05/2022 Memo         Memo           1) Desenvolvimento inicial do programa                                                                   **
**                                                                                                                                                                      **
*************************************************************************************************************************************************************************/

/*--- Defini‡Æo Parƒmetros ---*/
DEF PARAM BUFFER p-table      FOR it-nota-fisc.
DEF PARAM BUFFER p-old-table  FOR it-nota-fisc.

/*--- Variaveis Globais ---*/

/*--- Variaveis Locais ---*/

/*--- Inicio Execu‡Æo ---*/
IF NEW p-table                     AND 
   p-table.vl-desconto-me      > 0 AND 
   p-table.val-desconto-total  = 0 THEN DO:

    /* -- Verifica se ‚ s‚rie Manual (CD0905) -- */
    FIND FIRST serie NO-LOCK
         WHERE serie.serie      = p-table.serie
           AND serie.forma-emis = 2 NO-ERROR.
    IF AVAIL serie THEN
        ASSIGN p-table.val-desconto-total = p-table.vl-desconto-me.

END.

RETURN "OK":U.

/*------------------------------------------- Procedures Internas --------------------------------------------*/

