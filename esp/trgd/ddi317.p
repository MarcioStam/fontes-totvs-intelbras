/********************************************************************************
 ** UPC........: ddi317.p - UPC DELETE cond-pagto    
 ** Data.......: Maio / 2011
 ** Objetivo...: Repassa Elimina‡Æo da tabela wt-docto
 ********************************************************************************/
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHARACTER FORMAT "x(12)":U LABEL "Usuÿrio Corrente" COLUMN-LABEL "Usuÿrio Corrente" NO-UNDO. 
DEF PARAM BUFFER b-wt-docto      FOR wt-docto.


FIND ped-fiscal
     WHERE ped-fiscal.seq-wt-docto = b-wt-docto.seq-wt-docto
     EXCLUSIVE-LOCK NO-ERROR.

IF AVAIL ped-fiscal AND
    ped-fiscal.situacao = 3 AND
    ped-fiscal.nr-nota-fis = "" THEN DO:
    ASSIGN ped-fiscal.situacao = 6
           ped-fiscal.motivo = ped-fiscal.motivo + " - Docto Eliminado do ft4003 pelo usuario " + v_cod_usuar_corren  .
        

END.

