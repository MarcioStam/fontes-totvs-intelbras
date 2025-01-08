
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/******************************************************************************
**  Programa: VE2027.P correspondente ao PD1001M.P
**  Objetivo: Retorna as informa‡äes Vendor do pedido conforme parƒmetros.
**  Data....: Outubro de 1998
**  Autor...: Datasul S/A
******************************************************************************/
def input param row-pedido     as rowid                    no-undo.
def output param i-cod-cond-cli as int  format ">>9"        no-undo.   
def output param i-dias-base    as int  format ">>9"        no-undo.   
def output param da-base        as date format "99/99/9999" no-undo.           
def output param de-tx-cli      as dec  format ">>9.9999"   no-undo.

find first ped-venda where rowid(ped-venda) = row-pedido no-lock no-error.
find first pd-vendor of ped-venda no-lock no-error.

if avail pd-vendor then 
   assign i-cod-cond-cli = pd-vendor.cod-cond-cli
          i-dias-base    = pd-vendor.dias-base
          da-base        = pd-vendor.data-base
          de-tx-cli      = pd-vendor.taxa-cliente * 100.

/* VE2027.P */




