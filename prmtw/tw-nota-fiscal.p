/*************************************************************************************************************************************************************************
** Copyright PRIME Consultoria (2014)                                                                                                                                   **
** Todos os Direitos Reservados.                                                                                                                                        **
**                                                                                                                                                                      **
** Este fonte ‚ de propriedade exclusiva da PRIME Consultoria, sua reprodu‡Æo parcial ou total por qualquer meio, s¢ poder  ser feita mediante autoriza‡Æo expressa     **
**                                                                                                                                                                      **
**************************************************************************************************************************************************************************
** Programa .....: tw-nota-fiscal                                                                                                                                       ** 
** Data .........: Julho de 2022                                                                                                                                        **
** Autor ........: Prime Consultoria                                                                                                                                    **
** Objetivo .....: Atualizar situa‡Æo da NF para s‚rie Manual                                                                                                           **
** Revisäes **************************************************************************************************************************************************************
** Autor         Ver.   Data       Cliente      Solicitante    Descri‡Æo                                                                                                **
** Gabriel Poli  00.001 05/07/2022 CRS          Juliana        1) Desenvolvimento inicial do programa                                                                   **
**                                                                                                                                                                      **
*************************************************************************************************************************************************************************/
/*--- Defini‡Æo Parƒmetros ---*/
DEF PARAM BUFFER p-table      FOR nota-fiscal.
DEF PARAM BUFFER p-old-table  FOR nota-fiscal.

/*--- Variaveis Globais ---*/

/*--- Variaveis Locais ---*/

/*--- Buffers ---*/

/*--- Inicio Execu‡Æo ---*/
IF p-table.dt-cancela <> p-old-table.dt-cancela AND
   p-table.dt-cancela <> ?                      AND
   p-table.idi-sit-nf-eletro <> 6               THEN DO:

    /* -- Verifica se ‚ s‚rie Manual (CD0905) -- */
    FIND FIRST serie NO-LOCK
         WHERE serie.serie      = p-table.serie
           AND serie.forma-emis = 2 NO-ERROR.
    IF AVAIL serie THEN DO:

        FIND FIRST prm-projeto-integrador NO-LOCK
             WHERE prm-projeto-integrador.serie = p-table.serie NO-ERROR.

        IF AVAIL prm-projeto-integrador THEN DO:
            ASSIGN p-table.idi-sit-nf-eletro = 6.
        END.
    END.
END.


RETURN "OK":U.

/*------------------------------------------- Procedures Internas --------------------------------------------*/

