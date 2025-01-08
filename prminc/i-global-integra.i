/*************************************************************************************************************************************************************************
** Copyright PRIME Consultoria (2014)                                                                                                                                   **
** Todos os Direitos Reservados.                                                                                                                                        **
**                                                                                                                                                                      **
** Este fonte ‚ de propriedade exclusiva da PRIME Consultoria, sua reprodu‡Æo parcial ou total por qualquer meio, s¢ poder  ser feita mediante autoriza‡Æo expressa     **
**                                                                                                                                                                      **
**************************************************************************************************************************************************************************
** Programa .....: i-global-integra                                                                                                                                     ** 
** Data .........: Julho de 2020                                                                                                                                        **
** Autor ........: Prime Consultoria                                                                                                                                    **
** Objetivo .....: Vari veis globais na integra‡Æo entre Datasul e PC-Factory                                                                                           **
** Revisäes **************************************************************************************************************************************************************
** Autor         Ver.   Data       Cliente      Solicitante    Descri‡Æo                                                                                                **
** Gabriel Poli  00.001 31/07/2020 Handle       Alan            1) Desenvolvimento inicial do programa                                                                  **
**                                                                                                                                                                      **
*************************************************************************************************************************************************************************/

/*--- Defini‡Æo Parƒmetros ---*/

/*--- Variaveis Globais ---*/
DEFINE NEW GLOBAL SHARED VARIABLE gl-exibe-json         AS LOGICAL NO-UNDO INITIAL FALSE.
DEFINE NEW GLOBAL SHARED VARIABLE gl-atualiza-re1001    AS LOGICAL NO-UNDO INITIAL TRUE.
DEFINE NEW GLOBAL SHARED VARIABLE gl-atualiza-ft4003    AS LOGICAL NO-UNDO INITIAL TRUE.
DEFINE NEW GLOBAL SHARED VARIABLE gl-atualiza-pd4000    AS LOGICAL NO-UNDO INITIAL TRUE.
DEFINE NEW GLOBAL SHARED VARIABLE gl-cria-duplic        AS LOGICAL NO-UNDO INITIAL TRUE.
DEFINE NEW GLOBAL SHARED VARIABLE gl-cria-item-re       AS LOGICAL NO-UNDO INITIAL TRUE.
DEFINE NEW GLOBAL SHARED VARIABLE gl-cria-item-terc-re  AS LOGICAL NO-UNDO INITIAL TRUE.
DEFINE NEW GLOBAL SHARED VARIABLE gl-cria-item-dev-re   AS LOGICAL NO-UNDO INITIAL TRUE.
DEFINE NEW GLOBAL SHARED VARIABLE gl-cria-item-ft       AS LOGICAL NO-UNDO INITIAL TRUE.
DEFINE NEW GLOBAL SHARED VARIABLE gl-cria-item-pd       AS LOGICAL NO-UNDO INITIAL TRUE.
DEFINE NEW GLOBAL SHARED VARIABLE gl-saldo-terc         AS LOGICAL NO-UNDO INITIAL FALSE.
DEFINE NEW GLOBAL SHARED VARIABLE gl-componente         AS LOGICAL NO-UNDO INITIAL FALSE.

/*--- Variaveis Locais ---*/

/*--- Buffers ---*/

/*--- Inicio Execu‡Æo ---*/


/*------------------------------------------- Procedures Internas --------------------------------------------*/


