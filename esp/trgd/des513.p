/********************************************************************************
 ** UPC........: upcd-un007.p - UPC DELETE  unidade da federa‡Æo
 ** Data.......: Outubro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes das unidades da federa‡Æo para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-fam-com-item      FOR fam-com-item.

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-fam-com-item TO raw-param.

IF b-fam-com-item.unidade  <> "" 
AND b-fam-com-item.segmento <> "" 
AND b-fam-com-item.familia1 = "" 
AND b-fam-com-item.familia2 = "" 
AND b-fam-com-item.origem   = "" THEN

    RUN esp/trgw/wes513a.p (INPUT raw-param,
                            INPUT "msg0026").

ELSE IF b-fam-com-item.unidade  <> "" 
    AND b-fam-com-item.segmento <> "" 
    AND b-fam-com-item.familia1 <> "" 
    AND b-fam-com-item.familia2 = "" 
    AND b-fam-com-item.origem   = "" THEN

    RUN esp/trgw/wes513a.p (INPUT raw-param,
                            INPUT "msg0028").

ELSE IF b-fam-com-item.unidade  <> "" 
    AND b-fam-com-item.segmento <> "" 
    AND b-fam-com-item.familia1 <> "" 
    AND b-fam-com-item.familia2 <> "" 
    AND b-fam-com-item.origem   = "" THEN

    RUN esp/trgw/wes513a.p (INPUT raw-param,
                            INPUT "msg0030").


ELSE IF b-fam-com-item.unidade  <> "" 
    AND b-fam-com-item.segmento <> "" 
    AND b-fam-com-item.familia1 <> "" 
    AND b-fam-com-item.familia2 <> "" 
    AND b-fam-com-item.origem   <> "" THEN
    
    RUN esp/trgw/wes513a.p (INPUT raw-param,
                            INPUT "msg0032").

/*Fim Integra‡Æo Canais*/
