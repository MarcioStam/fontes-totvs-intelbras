

DEF STREAM exp1.
DEF VAR c-arq-fat AS CHAR NO-UNDO.
ASSIGN c-arq-fat = SESSION:TEMP-DIRECTORY + "exp-fatur-benef-" + STRING(TODAY,"99-99-9999") + STRING(TIME) + ".csv".
OUTPUT STREAM exp1 TO VALUE(c-arq-fat).
PUT STREAM exp1 "ANO;MÒS;CANAL;UNID NEG;SEGMENTO;TP BENEF;GUID CLASSI;GUID CATEG;GUID REGIAO;GUDI BENEF;CANAL-MATRIZ;GUID CANAL-MATRIZ;VL FATUR;VL DEVOLV;VL APURADO;GUID BENEF;VL BENEF;% BENEF;ATIVO;CALC VERBA;GUID CANAL" SKIP.

FOR EACH int-apura-fat NO-LOCK:
    EXPORT STREAM exp1 DELIMITER ";" int-apura-fat.ano              
                                     int-apura-fat.mes              
                                     int-apura-fat.canal            
                                     int-apura-fat.unid-neg         
                                     int-apura-fat.segmento         
                                     int-apura-fat.tipo-beneficio   
                                     int-apura-fat.guid-classifica  
                                     int-apura-fat.guid-categoria   
                                     int-apura-fat.guid-regiao      
                                     int-apura-fat.guid-beneficio   
                                     int-apura-fat.canal-matriz     
                                     int-apura-fat.guid-canal-matriz
                                     int-apura-fat.vl-faturado      
                                     int-apura-fat.vl-devolvido     
                                     int-apura-fat.vl-apurado       
                                     int-apura-fat.guid-beneficio   
                                     int-apura-fat.vl-beneficio     
                                     int-apura-fat.perc-beneficio   
                                     int-apura-fat.log-ativo        
                                     int-apura-fat.calcular-verba      
                                     int-apura-fat.guid-canal.
END.

    
DEF STREAM exp2.
DEF VAR c-arq-cc AS CHAR NO-UNDO.

ASSIGN c-arq-cc = SESSION:TEMP-DIRECTORY + "exporta-c-corrente-benef-" + STRING(TODAY,"99-99-9999") + STRING(TIME) + ".csv".
OUTPUT STREAM exp2 TO VALUE(c-arq-cc).

PUT STREAM exp2 "CANAL;UNID NEG;TP BENEF;PER INI;PER FIM;VAL ORIG;VAL SALDO;VAL EMPENHADO;DT TRANS;DT VENCTO;STATUS;USUARIO;CANAL-MATRIZ;FORMA PAGTO" SKIP.

FOR EACH int-cc-benef NO-LOCK:
   
    EXPORT STREAM exp2 DELIMITER ";" int-cc-benef.canal         
                                     int-cc-benef.unid-neg      
                                     int-cc-benef.tipo-beneficio
                                     int-cc-benef.dt-periodo-ini
                                     int-cc-benef.dt-periodo-fim
                                     int-cc-benef.vl-original   
                                     int-cc-benef.vl-saldo      
                                     int-cc-benef.vl-empenhado  
                                     int-cc-benef.dt-transacao  
                                     int-cc-benef.dt-vencimento 
                                     int-cc-benef.id-status     
                                     int-cc-benef.usuario       
                                     int-cc-benef.canal-matriz  
                                     int-cc-benef.forma-pagto.   
END.
