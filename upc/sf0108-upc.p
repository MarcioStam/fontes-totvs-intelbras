/******************************************************************************
*      Programa .....: SF0108-UPC.P                                           *
*      Data .........: 26 de Julho de 2022                                    *
*      Sistema ......: SF                                                     *
*      Empresa ......: iDBA                                                   *
*      Cliente ......: Intelbras                                              *
*      Programador ..: Mauricio                                               *
*      Objetivo .....: UPC para o SF0108                                      *
*******************************************************************************
*      VERSAO      DATA        RESPONSAVEL   MOTIVO                           *
*      1.00.00.000 26/07/2022  Mauricio      Desenvolvimento                  *
******************************************************************************/
{include/i-prgvrs.i "sf0108-epc" 1.00.00.000}

define input param p-ind-event  as char          no-undo.
define input param p-ind-object as char          no-undo.
define input param p-wgh-object as handle        no-undo.
define input param p-wgh-frame  as widget-handle no-undo.
define input param p-cod-table  as char          no-undo.
define input param p-row-table  as rowid         no-undo.

def var c-objeto as char no-undo.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,'~/'),p-wgh-object:file-name,'~/') no-error.

/* message "P-ind-event  = " p-ind-event    skip        */
/*           "P-ind-object = " p-ind-object skip        */
/*           "P-wgh-object = " p-wgh-object skip        */
/*           "P-wgh-frame  = " p-wgh-frame  skip        */
/*           "P-cod-table  = " p-cod-table  skip        */
/*           "p-row-table  = " string(p-row-table) skip */
/*           "c-objeto     = " c-objeto                 */
/*           view-as alert-box.                         */

if  p-ind-event  = "BEFORE-DELETE"
and p-ind-object = "CONTAINER"
and c-objeto     = "sf0108.w"
then for first operador fields(cod-operador) no-lock
         where rowid(operador) = p-row-table,
         first int-gm-operador use-index ch-operador no-lock
         where int-gm-operador.cod-operador = operador.cod-operador:
         run utp/ut-msgs.p (input "show":U, input 17567, input "Operador " + operador.cod-operador + " possui relacionamento com Grupo de M quina (CD0111)").
         return error.
     end. /* for first operador */


/********** PROCEDURES **********/

