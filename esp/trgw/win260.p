/********************************************************************************
 ** UPC........: win260.p - UPC WRITE oper-ord
 ** Data.......: abril / 2022
 ** Objetivo...: Criacao automatica de extensao 
 ********************************************************************************/

def param buffer p-table     for oper-ord.
def param buffer p-old-table for oper-ord.

if p-table.nr-ord-produ <> p-old-table.nr-ord-produ
then for last int-ext-operacao no-lock
        where int-ext-operacao.it-codigo       = p-table.it-codigo
          and int-ext-operacao.cod-roteiro     = p-table.cod-roteiro
          and int-ext-operacao.op-codigo       = p-table.op-codigo
          AND int-ext-operacao.num-id-operacao = p-table.num-id-operacao:
         if int-ext-operacao.nro-homem-aps <= 0
         then leave.

         FOR FIRST int-oper-ord
             WHERE int-oper-ord.nr-ord-produ = p-table.nr-ord-produ
               AND int-oper-ord.it-codigo    = p-table.it-codigo
               AND int-oper-ord.cod-roteiro  = p-table.cod-roteiro
               AND int-oper-ord.op-codigo    = p-table.op-codigo
                   EXCLUSIVE-LOCK: END.

         IF NOT AVAIL int-oper-ord
         THEN DO:
              create int-oper-ord.
              assign int-oper-ord.nr-ord-produ  = p-table.nr-ord-produ
                     int-oper-ord.it-codigo     = p-table.it-codigo
                     int-oper-ord.cod-roteiro   = p-table.cod-roteiro
                     int-oper-ord.op-codigo     = p-table.op-codigo.
         END. 

         ASSIGN int-oper-ord.nro-homem-aps = int-ext-operacao.nro-homem-aps.
         find current int-oper-ord no-lock no-error.
         RELEASE int-oper-ord.
     end. /* for last int-ext-operacao */

