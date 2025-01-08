/**
 * Extrator para BI
 * Dimens∆o: Transportador
 *
 * Autor: Felipe Braun Azambuja
 */

create widget-pool.

&scoped-define TEMP_TABLE  ttTransportador
&scoped-define ARQUIVO_TXT DimTransportador

{bi/esbi000.i}
{include/i-freeac.i}

/**
 * Leitura do XML
 */
define variable c-xml as character no-undo.
assign c-xml = entry(2,session:parameter).
file-info:file-name = c-xml.
if (index(file-info:file-type, 'f') = 0) then
   leave.
{bi/esbi001.i c-xml}

/** Valida diret¢rio de sa°da **/
assign c-diretorio = getTag("diretorio").
file-info:file-name = c-diretorio.
if (index(file-info:file-type, 'd') = 0) or (c-diretorio = "") then
   leave.

/**
 * Regra de neg¢cio a partir daqui
 */
define temp-table ttTransportador no-undo
   field CD_Transportador     like transporte.cod-transp
   FIELD CD_Matriz            LIKE transporte.cod-transp
   field TX_Transportador     like transporte.nome
   field TX_Nome_Abreviado    like transporte.nome-abrev
   FIELD TX_Nome_Abrev_Matriz LIKE emitente.nome-abrev
   FIELD TX_Matriz            LIKE emitente.nome-emit
   index idx_pri is primary unique CD_Transportador.

DEF BUFFER b-emitente   FOR emitente.
DEF BUFFER b-transporte FOR transporte.

for each transporte no-lock:
   create ttTransportador.
   assign ttTransportador.CD_Transportador  = transporte.cod-transp
          ttTransportador.TX_Transportador  = transporte.nome
          ttTransportador.TX_Nome_Abreviado = transporte.nome-abrev.

   FIND FIRST emitente NO-LOCK
       WHERE  emitente.cgc = transporte.cgc NO-ERROR.

   IF AVAIL emitente
   THEN DO:
        IF  emitente.nome-abrev = emitente.nome-matriz
        THEN
            ASSIGN ttTransportador.CD_Matriz            = transporte.cod-transp
                   ttTransportador.TX_Nome_Abrev_Matriz = emitente.nome-abrev
                   ttTransportador.TX_Matriz            = emitente.nome-emit.
        ELSE DO:
            FIND FIRST b-emitente NO-LOCK
                WHERE  b-emitente.nome-abrev = emitente.nome-matriz NO-ERROR.

            IF  AVAIL b-emitente
            THEN DO:
                ASSIGN ttTransportador.TX_Nome_Abrev_Matriz = b-emitente.nome-abrev
                       ttTransportador.TX_Matriz            = b-emitente.nome-emit.

                FIND FIRST b-transporte NO-LOCK
                    WHERE  b-transporte.cgc = b-emitente.cgc NO-ERROR.

                IF  AVAIL b-transporte
                THEN
                    ASSIGN ttTransportador.CD_Matriz = b-transporte.cod-transp.
            END.
        END.
   END.
   ELSE
       ASSIGN ttTransportador.CD_Matriz            = transporte.cod-transp 
              ttTransportador.TX_Nome_Abrev_Matriz = transporte.nome-abrev       
              ttTransportador.TX_Matriz            = transporte.nome.
end.

run createTxt(input buffer {&TEMP_TABLE}:handle, "{&ARQUIVO_TXT}").
