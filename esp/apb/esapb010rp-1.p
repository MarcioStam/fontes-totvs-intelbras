/*****************************************************************************
**     Programa.........: esp/apb/esapb010rp-1.p
**     Descricao .......: Relat¢rio de Devolu‡äes - AP
**     Versao...........: 1.00.001
**     Autor............: Giovane Alves
**     Criado...........: 22/02/2008
**     Desc. Atualiza‡Æo: 
**     Autor............: 
*******************************************************************************/
DEFINE SHARED VAR v_cod_estab AS CHARACTER NO-UNDO.
DEFINE SHARED VAR v_fim_cod_emitente AS INTEGER NO-UNDO.
DEFINE SHARED VAR v_fim_data AS DATE NO-UNDO.
DEFINE SHARED VAR v_ini_cod_emitente AS INTEGER NO-UNDO.
DEFINE SHARED VAR v_ini_data AS DATE NO-UNDO.

DEF SHARED STREAM Stream_1.

for each nota-fiscal no-lock
   where nota-fiscal.cod-estabel = v_cod_estab
     and nota-fiscal.dt-emis-nota >= v_ini_data
     and nota-fiscal.dt-emis-nota <= v_fim_data
     and nota-fiscal.cod-emitente >= v_ini_cod_emitente
     and nota-fiscal.cod-emitente <= v_fim_cod_emitente
     and (nota-fiscal.nat-operacao = "520100"
      or  nota-fiscal.nat-operacao = "520101"
      or  nota-fiscal.nat-operacao = "520102"
      or  nota-fiscal.nat-operacao = "620100"
      or  nota-fiscal.nat-operacao = "620101"
      or  nota-fiscal.nat-operacao = "620102"
      or  nota-fiscal.nat-operacao = "520200"
      or  nota-fiscal.nat-operacao = "620200"
      or  nota-fiscal.nat-operacao = "555500"
      or  nota-fiscal.nat-operacao = "555501"
      or  nota-fiscal.nat-operacao = "555600"
      or  nota-fiscal.nat-operacao = "655600"
      or  nota-fiscal.nat-operacao = "655601"
      or  nota-fiscal.nat-operacao = "655602"
      or  nota-fiscal.nat-operacao = "655603"
      or  nota-fiscal.nat-operacao = "555500" 
      or  nota-fiscal.nat-operacao = "655501"
      or  nota-fiscal.nat-operacao = "694950"
      or  nota-fiscal.nat-operacao = "594950"
      or  nota-fiscal.nat-operacao = "155300")
     and nota-fiscal.dt-cancel = ?,
    each it-nota-fisc of nota-fiscal no-lock
  break by nota-fiscal.dt-emis-nota 
        by nota-fiscal.nr-nota-fis:

    disp STREAM Stream_1
         nota-fiscal.cod-emitente label "Cod"
         nota-fiscal.nome-ab-cli  label "Cliente"
         nota-fiscal.dt-emis-nota label "EmissÆo"
         nota-fiscal.serie        label "Ser"
         nota-fiscal.nr-nota-fis  label "Nota Fis"
         nota-fiscal.nat-operacao label "Nat"
         it-nota-fisc.vl-tot-item label "Vl Total" (total by nota-fiscal.nr-nota-fis)
         it-nota-fisc.vl-icms-it label "Vl ICMS" (total by nota-fiscal.nr-nota-fis)
         it-nota-fisc.vl-ipi-it  label "Vl IPI" (total by nota-fiscal.nr-nota-fis)
         it-nota-fisc.nat-docum   label "Nat"
         it-nota-fisc.serie-docum label "Ser"
         it-nota-fisc.nr-docum    label "Docto"
         with width 132 no-labels stream-io.
end.


