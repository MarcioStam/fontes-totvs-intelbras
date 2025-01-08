/********************************************************************************
**  Programa: WSC098.P                                    
**  Data....: Marco de 2016                           
**  Autor...: SCM Concept Consultoria e Desenvolvimento 
**  Objetivo: UPC da trigger de WRITE da tabela wm-box-saldo-etiqueta.
**            -> Utilizado para gravar a data no saldo com base na etiqueta na 
**               criacao do registro 
********************************************************************************/

DEFINE PARAMETER BUFFER p-table     FOR wm-box-saldo-etiqueta.
DEFINE PARAMETER BUFFER p-table-old FOR wm-box-saldo-etiqueta.

DEF BUFFER bfwm-box-saldo-etiqueta   FOR wm-box-saldo-etiqueta.


IF  p-table.id-saldo <> p-table-old.id-saldo THEN DO:

    FIND FIRST wm-box-saldo OF p-table EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL wm-box-saldo THEN DO:
        FIND FIRST wm-etiqueta OF p-table NO-LOCK NO-ERROR.
    	ASSIGN wm-box-saldo.dt-trans = wm-etiqueta.dt-geracao.
    END.

END.

RETURN "OK".


