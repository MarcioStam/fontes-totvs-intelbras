/********************************************************************************
 ** UPC........: upcw-un007.p - UPC WRITE Unidade da Federa‡Æo
 ** Data.......: Outubro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes das unidades de federa‡Æo para a Base Oracle
 ********************************************************************************/

TRIGGER PROCEDURE FOR WRITE OF fam-com-item.
DEFINE TEMP-TABLE tt-fam-com-item LIKE fam-com-item.

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

EMPTY TEMP-TABLE tt-fam-com-item.
CREATE tt-fam-com-item .
BUFFER-COPY fam-com-item     TO tt-fam-com-item .
RAW-TRANSFER tt-fam-com-item TO raw-param.


 IF fam-com-item.unidade  <> "" 
AND fam-com-item.segmento <> "" 
AND fam-com-item.familia1 = "" 
AND fam-com-item.familia2 = "" 
AND fam-com-item.origem   = "" THEN

    RUN esp/trgw/wes513a.p (INPUT raw-param,
                            INPUT "msg0026").

ELSE IF fam-com-item.unidade  <> "" 
    AND fam-com-item.segmento <> "" 
    AND fam-com-item.familia1 <> "" 
    AND fam-com-item.familia2 = "" 
    AND fam-com-item.origem   = "" THEN

    RUN esp/trgw/wes513a.p (INPUT raw-param,
                            INPUT "msg0028").

ELSE IF fam-com-item.unidade  <> "" 
    AND fam-com-item.segmento <> "" 
    AND fam-com-item.familia1 <> "" 
    AND fam-com-item.familia2 <> "" 
    AND fam-com-item.origem   = "" THEN

    RUN esp/trgw/wes513a.p (INPUT raw-param,
                            INPUT "msg0030").


ELSE IF fam-com-item.unidade  <> "" 
    AND fam-com-item.segmento <> "" 
    AND fam-com-item.familia1 <> "" 
    AND fam-com-item.familia2 <> "" 
    AND fam-com-item.origem   <> "" THEN
    RUN esp/trgw/wes513a.p (INPUT raw-param,
                            INPUT "msg0032").

/*Fim Integra‡Æo Canais*/
