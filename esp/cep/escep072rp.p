DEFINE INPUT PARAM p-dir-import AS CHAR.

DEFINE TEMP-TABLE tt-erro
    FIELD descricao AS CHAR.

DEFINE VARIABLE c-cod-estabel       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-it-codigo         AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-estab-gestor  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-comprado      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-deposito-pad      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-tp-desp-padrao    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-nat-despesa       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cd-planejado      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-politica          AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-demanda           AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-periodo-fixo      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-tempo-segur       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-reab-estoq        AS CHARACTER NO-UNDO. /*if substr(item-uni-estab.char-1,10,1) = "" then {ininc/i26in172.i 04 1} else {ininc/i26in172.i 04 int(substr(item-uni-estab.char-1,10,1))}*/
DEFINE VARIABLE c-classe-repro      AS CHARACTER NO-UNDO. /*{ininc/i06in122.i 06 c-classe-repro}*/
DEFINE VARIABLE c-emissao-ord       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-div-ordem         AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-prioridade-mrp    AS CHARACTER NO-UNDO. /*int-1*/
DEFINE VARIABLE c-represa-demanda   AS CHARACTER NO-UNDO. /*if substring(item-uni-estab.char-1,132,1) = "1" then assign l-demanda-item = yes.*/
DEFINE VARIABLE c-prioridade        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-res-int-comp      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-res-cq-comp       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-ressup-fabri      AS CHARACTER NO-UNDO.
/*
DEFINE VARIABLE c-cod-emitente      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-ativo             AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cot-aut           AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-horiz-fixo        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-perc-compra       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lote-minimo       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lote-mul-for      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-cond-pag      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-classe-repro-forn AS CHARACTER NO-UNDO.             
DEFINE VARIABLE c-item-do-forn      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-unid-mes-for      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-fator-conver      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-num-casa-dec      AS CHARACTER NO-UNDO.
*/

DEFINE VARIABLE h-acomp             AS HANDLE    NO-UNDO.

DEFINE STREAM s-import.

INPUT STREAM s-import FROM VALUE(p-dir-import) NO-CONVERT.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp(INPUT "Importando.").

REPEAT ON ERROR UNDO, LEAVE
       ON STOP UNDO, LEAVE TRANSACTION:
    ASSIGN c-it-codigo         = ""
           c-cod-estabel       = ""
           c-cod-comprado      = ""
           c-deposito-pad      = ""
           c-tp-desp-padrao    = ""
           c-nat-despesa       = ""
           c-cd-planejado      = ""
           c-politica          = ""
           c-demanda           = ""
           c-periodo-fixo      = ""
           c-tempo-segur       = ""
           c-reab-estoq        = ""
           c-classe-repro      = ""
           c-emissao-ord       = ""
           c-div-ordem         = ""
           c-prioridade-mrp    = ""
           c-represa-demanda   = ""
           c-prioridade        = ""
           c-res-int-comp      = ""
           c-res-cq-comp       = ""
           c-ressup-fabri      = "".

    /*       c-cod-emitente      = ""
           c-ativo             = ""
           c-cot-aut           = ""
           c-horiz-fixo        = ""
           c-perc-compra       = ""
           c-lote-minimo       = ""
           c-lote-mul-for      = ""
           c-cod-cond-pag      = ""
           c-classe-repro-forn = ""
           c-item-do-forn      = ""
           c-unid-mes-for      = ""
           c-fator-conver      = ""
           c-num-casa-dec      = "".*/

    IMPORT STREAM s-import DELIMITER ";"
        c-cod-estabel      
        c-it-codigo        
        c-cod-estab-gestor
        c-cod-comprado     
        c-deposito-pad     
        c-tp-desp-padrao   
        c-nat-despesa      
        c-cd-planejado    
        c-politica         
        c-demanda          
        c-periodo-fixo     
        c-tempo-segur      
        c-reab-estoq       
        c-classe-repro     
        c-emissao-ord      
        c-div-ordem        
        c-prioridade-mrp   
        c-represa-demanda  
        c-prioridade       
        c-res-int-comp     
        c-res-cq-comp      
        c-ressup-fabri.     
        /*c-cod-emitente     
        c-ativo            
        c-cot-aut          
        c-horiz-fixo       
        c-perc-compra      
        c-lote-minimo      
        c-lote-mul-for     
        c-cod-cond-pag     
        c-classe-repro-forn
        c-item-do-forn     
        c-unid-mes-for     
        c-fator-conver     
        c-num-casa-dec.*/

    IF c-cod-estabel BEGINS "Estab" THEN NEXT.

    IF c-it-codigo = "" THEN
        LEAVE.

    FIND FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = c-it-codigo NO-ERROR.

    IF NOT AVAIL ITEM THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.descricao = "ITEM: " + c-it-codigo + " n∆o cadastrado!".
        NEXT.
    END.

    FIND FIRST estabelec NO-LOCK 
        WHERE estabelec.cod-estab = c-cod-estabel NO-ERROR.

    IF NOT AVAIL estabelec THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.descricao = "Estabelecimento: " + c-cod-estabel + " n∆o cadastrado!".
        NEXT.
    END.

    IF c-cod-estab-gestor <> "" THEN DO:
        FIND FIRST estabelec NO-LOCK 
            WHERE estabelec.cod-estab = c-cod-estab-gestor NO-ERROR.
    
        IF NOT AVAIL estabelec THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.descricao = "Estabelecimento Gestor: " + c-cod-estab-gestor + " n∆o cadastrado!".
            NEXT.
        END.
    END.

    /*FIND FIRST emitente NO-LOCK 
        WHERE emitente.cod-emitente = INT(c-cod-emitente) NO-ERROR.

    IF NOT AVAIL emitente THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.descricao = "Emitente: " + c-cod-emitente + " n∆o cadastrado!".
        NEXT.
    END.

    FIND FIRST fabricante NO-LOCK 
        WHERE fabricante.cod-fabric = INT(c-item-do-forn) NO-ERROR.

    IF NOT AVAIL fabricante 
    AND c-item-do-forn <> "" THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.descricao = "Fabricante n∆o cadastrado e n∆o importado: " + c-item-do-forn 
               c-item-do-forn    = "".
        
    END.*/

    RUN pi-acompanhar IN h-acomp (INPUT c-cod-estabel + " " + c-it-codigo).

    FIND FIRST item-uni-estab EXCLUSIVE-LOCK
        WHERE item-uni-estab.it-codigo   = c-it-codigo 
          AND item-uni-estab.cod-estabel = c-cod-estabel NO-ERROR.

    IF NOT AVAIL item-uni-estab THEN DO:
        CREATE item-uni-estab.
        ASSIGN item-uni-estab.cod-estabel = c-cod-estabel
               item-uni-estab.it-codigo   = c-it-codigo. 
    END.

    ASSIGN item-uni-estab.cod-estab-gestor = c-cod-estab-gestor      
           item-uni-estab.cod-comprado     = c-cod-comprado          
           item-uni-estab.deposito-pad     = c-deposito-pad          
           item-uni-estab.tp-desp-padrao   = INT(c-tp-desp-padrao)   
           item-uni-estab.nat-despesa      = INT(c-nat-despesa)      
           item-uni-estab.cd-planejado     = c-cd-planejado          
           item-uni-estab.politica         = {ininc/i04in122.i 06 c-politica}       
           item-uni-estab.demanda          = {ininc/i02in122.i 06 c-demanda}        
           item-uni-estab.periodo-fixo     = INT(c-periodo-fixo)         
           item-uni-estab.tempo-segur      = INT(c-tempo-segur)          
           item-uni-estab.classe-repro     = {ininc/i06in122.i 06 c-classe-repro}   
           item-uni-estab.emissao-ord      = {ininc/i03in122.i 06 c-emissao-ord}    
           item-uni-estab.div-ordem        = {ininc/i12in122.i 06 c-div-ordem}      
           item-uni-estab.int-1            = INT(c-prioridade-mrp)        
           item-uni-estab.prioridade       = INT(c-prioridade)            
           item-uni-estab.res-int-comp     = INT(c-res-int-comp)          
           item-uni-estab.res-cq-comp      = INT(c-res-cq-comp)           
           item-uni-estab.ressup-fabri     = INT(c-ressup-fabri).       

    OVERLAY(item-uni-estab.char-1,10,1)   = STRING({ininc/i26in172.i 06 c-reab-estoq }).
    OVERLAY(item-uni-estab.char-1,132,1)  = IF c-represa-demanda = "sim" THEN "1" ELSE "0".

    /*
    FIND FIRST item-fornec-estab EXCLUSIVE-LOCK
         WHERE item-fornec-estab.cod-emitente = INT(c-cod-emitente) 
           AND item-fornec-estab.it-codigo    = c-it-codigo 
           AND item-fornec-estab.cod-estabel  = c-cod-estabel NO-ERROR.

    IF c-cod-emitente <> "" THEN DO:
    
        IF NOT AVAIL item-fornec-estab THEN DO:
            CREATE item-fornec-estab.
            ASSIGN item-fornec-estab.cod-emitente = INT(c-cod-emitente) 
                   item-fornec-estab.it-codigo    = c-it-codigo         
                   item-fornec-estab.cod-estabel  = c-cod-estabel.
        END.
    
        ASSIGN item-fornec-estab.ativo        = IF c-ativo   = "sim" THEN YES ELSE NO         
               item-fornec-estab.cot-aut      = IF c-cot-aut = "sim" THEN YES ELSE NO         
               item-fornec-estab.horiz-fixo   = INT(c-horiz-fixo)       
               item-fornec-estab.tempo-ressup = INT(c-horiz-fixo)     
               item-fornec-estab.perc-compra  = DEC(c-perc-compra)    
               item-fornec-estab.lote-minimo  = DEC(c-lote-minimo)    
               item-fornec-estab.lote-mul-for = DEC(c-lote-mul-for)   
               item-fornec-estab.cod-cond-pag = INT(c-cod-cond-pag)   
               item-fornec-estab.classe-repro = {ininc/i06in122.i 06 c-classe-repro-forn}  
               item-fornec-estab.item-do-forn = c-item-do-forn     
               item-fornec-estab.unid-med-for = c-unid-mes-for     
               item-fornec-estab.fator-conver = INT(c-fator-conver)
               item-fornec-estab.num-casa-dec = INT(c-num-casa-dec).


        FIND FIRST item-fornec EXCLUSIVE-LOCK
             WHERE item-fornec.cod-emitente = INT(c-cod-emitente)
               AND item-fornec.it-codigo    = c-it-codigo NO-ERROR.
        IF NOT AVAIL item-fornec THEN DO:
            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = c-it-codigo NO-ERROR.
        
            CREATE item-fornec.
            ASSIGN item-fornec.cod-emitente = INT(c-cod-emitente)
                   item-fornec.it-codigo    = c-it-codigo
                   item-fornec.unid-med-for = IF AVAIL ITEM THEN ITEM.un ELSE ""
                   item-fornec.item-do-forn = c-item-do-forn.
        END.
        
        ASSIGN item-fornec.ativo = IF c-ativo = "sim" THEN YES ELSE NO   .
        
        RELEASE item-fornec.
    END.*/
END.

IF CAN-FIND (FIRST tt-erro) THEN DO:
    OUTPUT TO VALUE (SESSION:TEMP-DIR + "erros_import.txt").
    FOR EACH tt-erro:
        PUT UNFORMATTED tt-erro.descricao SKIP.
    END.
    OUTPUT CLOSE.
    RUN WinExec (INPUT 'notepad.exe' + chr(32) + SESSION:TEMP-DIR + "erros_import.txt", 
                 INPUT 1). 

END.

IF NOT CAN-FIND (FIRST tt-erro) THEN DO:
    MESSAGE "Arquivo Importado com Sucesso!"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.


RUN pi-finalizar IN h-acomp. 

PROCEDURE WinExec EXTERNAL "kernel32.dll":
  DEF INPUT  PARAM prg_name                          AS CHARACTER.
  DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.
