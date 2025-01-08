DEFINE INPUT PARAM p-dir-import AS CHAR.

DEFINE TEMP-TABLE tt-erro
    FIELD descricao AS CHAR.

DEFINE VARIABLE c-cod-estabel       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-it-codigo         AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-emitente      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-ativo             AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cot-aut           AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-horiz-fixo        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-perc-compra       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lote-minimo       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lote-mul-for      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-cond-pag      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-moeda             AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-classe-repro-forn AS CHARACTER NO-UNDO.             
DEFINE VARIABLE c-item-do-forn      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-unid-mes-for      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-fator-conver      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-num-casa-dec      AS CHARACTER NO-UNDO.

def var de-soma                     as decimal no-undo. /* utilizado na verificacao do percentual de compra */
def var de-perc-compra              as decimal no-undo. /* utilizado na verificacao do percentual de compra */

DEFINE VARIABLE h-acomp             AS HANDLE    NO-UNDO.

DEFINE STREAM s-import.

INPUT STREAM s-import FROM VALUE(p-dir-import) NO-CONVERT.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp(INPUT "Importando.").

REPEAT ON ERROR UNDO, LEAVE
       ON STOP UNDO, LEAVE TRANSACTION:
    ASSIGN c-it-codigo         = ""
           c-cod-estabel       = ""
           c-cod-emitente      = ""
           c-ativo             = ""
           c-cot-aut           = ""
           c-horiz-fixo        = ""
           c-perc-compra       = ""
           c-lote-minimo       = ""
           c-lote-mul-for      = ""
           c-cod-cond-pag      = ""
           c-moeda             = ""
           c-classe-repro-forn = ""
           c-item-do-forn      = ""
           c-unid-mes-for      = ""
           c-fator-conver      = ""
           c-num-casa-dec      = "".

    IMPORT STREAM s-import DELIMITER ";"
        c-cod-estabel      
        c-it-codigo        
        c-cod-emitente     
        c-ativo            
        c-cot-aut          
        c-horiz-fixo       
        c-perc-compra      
        c-lote-minimo      
        c-lote-mul-for     
        c-cod-cond-pag
        c-moeda
        c-classe-repro-forn
        c-item-do-forn     
        c-unid-mes-for     
        c-fator-conver     
        c-num-casa-dec.

    IF c-cod-estabel BEGINS "Estab" THEN 
        NEXT.

    FIND FIRST estabelec NO-LOCK 
         WHERE estabelec.cod-estab = c-cod-estabel NO-ERROR.

    IF NOT AVAIL estabelec THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.descricao = "Estabelecimento: " + c-cod-estabel + " n∆o cadastrado!".
        NEXT.
    END.

    IF c-it-codigo = "" THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.descricao = "O c¢digo do Item n∆o pode estar em branco!".
        NEXT.  /*LEAVE.*/
    END.
        

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = c-it-codigo NO-ERROR.
    IF NOT AVAIL ITEM THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.descricao = "ITEM: " + c-it-codigo + " n∆o cadastrado!".
        NEXT.
    END.

    FIND FIRST item-uni-estab NO-LOCK
         WHERE item-uni-estab.it-codigo   = c-it-codigo
           AND item-uni-estab.cod-estabel = c-cod-estabel NO-ERROR.
    IF NOT AVAIL item-uni-estab THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.descricao = "ITEM: " + c-it-codigo + " n∆o cadastrado para o Estabelecimento " + c-cod-estabel + "!" .
        NEXT.
    END. 

    FIND FIRST emitente NO-LOCK 
         WHERE emitente.cod-emitente = INT(c-cod-emitente)
           AND emitente.identific    <> 1 NO-ERROR.            
    IF NOT AVAIL emitente THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.descricao = "Emitente: " + c-cod-emitente + " n∆o cadastrado como Fornecedor !" .
        NEXT.
    END.

    FIND FIRST cond-pagto
        WHERE cond-pagto.cod-cond-pag = int(c-cod-cond-pag) NO-LOCK NO-ERROR.
    IF NOT AVAIL cond-pagto THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.descricao = "N∆o foi encontrada Condiá∆o de Pagamento com para o Fornecedor: " + c-cod-emitente + " Estab: " + c-cod-estabel + " ITEM: " + c-it-codigo.
    END.

    FIND FIRST moeda NO-LOCK
        WHERE moeda.mo-codigo = int(c-moeda) NO-ERROR.

    IF NOT AVAIL moeda THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.descricao = "N∆o foi encontrada Moeda com o c¢digo informado: " + c-moeda .
    END.

    FIND FIRST tab-unidade NO-LOCK
         WHERE tab-unidade.un = trim(c-unid-mes-for) NO-ERROR.

    IF NOT AVAIL tab-unidade THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.descricao = "N∆o foi encontrada Unidade de Medida com o c¢digo informado: " + trim(c-unid-mes-for) + " Fornecedor: " + c-cod-emitente + " Estab: " + c-cod-estabel + " ITEM: " + c-it-codigo.
    END.

    assign de-soma = dec(c-perc-compra).

    /*Considera o total de 100% de compra apenas na tabela item-fornec-estab.*/
    for each  item-fornec-estab
        where item-fornec-estab.it-codigo      = c-it-codigo
          and item-fornec-estab.cod-estabel    = c-cod-estabel
          and item-fornec-estab.cod-emitente  <> int(c-cod-emitente)
          and item-fornec-estab.ativo no-lock:
        assign de-soma = de-soma + item-fornec-estab.perc-compra.
    end.
   
    assign de-perc-compra = dec(c-perc-compra).

    if  /*(de-perc-compra = 0 and c-ativo = "sim") or*/  de-soma > 100 then do:
        CREATE tt-erro.
        ASSIGN tt-erro.descricao = "O percentual de compra n∆o foi informado ou o mesmo ultrapassa 100%. Verificar o Fornecedor: " + c-cod-emitente + ", Estab: " + c-cod-estabel + ", ITEM: " + c-it-codigo.
        NEXT.
    end.

    FIND FIRST fabricante NO-LOCK 
         WHERE fabricante.cod-fabric = INT(c-item-do-forn) NO-ERROR.

    IF NOT AVAIL fabricante AND c-item-do-forn <> "" THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.descricao = "Fabricante: " + c-item-do-forn + " n∆o cadastrado e n∆o importado. Verificar o Estab: " + c-cod-estabel + ", e ITEM: " + c-it-codigo + " e Fornecedor: " + c-cod-emitente.
        NEXT.
    END.

    IF INT(c-item-do-forn) <> 0 THEN DO:
        IF NOT CAN-FIND (FIRST item-fabric 
                         WHERE item-fabric.cod-fabri = INT(c-item-do-forn)
                           AND item-fabric.it-codigo = c-it-codigo) THEN DO:

            CREATE tt-erro.
            ASSIGN tt-erro.descricao = "Item: " + c-it-codigo + " n∆o relacionado ao fabricante: " + c-item-do-forn + ". Registro n∆o importado".
            NEXT.
        END.
    END.

    RUN pi-acompanhar IN h-acomp (INPUT c-cod-estabel + " " + c-it-codigo).
    
    FIND FIRST item-fornec-estab EXCLUSIVE-LOCK
         WHERE item-fornec-estab.cod-emitente = INT(c-cod-emitente) 
           AND item-fornec-estab.it-codigo    = c-it-codigo 
           AND item-fornec-estab.cod-estabel  = c-cod-estabel NO-ERROR.

    
        IF NOT AVAIL item-fornec-estab THEN DO:
            CREATE item-fornec-estab.
            ASSIGN item-fornec-estab.cod-emitente = INT(c-cod-emitente) 
                   item-fornec-estab.it-codigo    = c-it-codigo         
                   item-fornec-estab.cod-estabel  = c-cod-estabel.
        END.
    
        ASSIGN item-fornec-estab.ativo               = IF c-ativo   = "sim" THEN YES ELSE NO         
               item-fornec-estab.cot-aut             = IF c-cot-aut = "sim" THEN YES ELSE NO         
               item-fornec-estab.horiz-fixo          = INT(c-horiz-fixo)       
               item-fornec-estab.tempo-ressup        = INT(c-horiz-fixo)     
               item-fornec-estab.perc-compra         = DEC(c-perc-compra)    
               item-fornec-estab.lote-minimo         = DEC(c-lote-minimo)    
               item-fornec-estab.lote-mul-for        = DEC(c-lote-mul-for)   
               item-fornec-estab.cod-cond-pag        = INT(c-cod-cond-pag)   
               item-fornec-estab.classe-repro        = {ininc/i06in122.i 06 c-classe-repro-forn}  
               item-fornec-estab.item-do-forn        = c-item-do-forn 
               item-fornec-estab.unid-med-for        = trim(c-unid-mes-for)
               item-fornec-estab.fator-conver        = INT(c-fator-conver)
               item-fornec-estab.num-casa-dec        = INT(c-num-casa-dec)
               OVERLAY(item-fornec-estab.char-1,1,2) = c-moeda.


        FIND FIRST item-fornec EXCLUSIVE-LOCK
             WHERE item-fornec.cod-emitente = INT(c-cod-emitente)
               AND item-fornec.it-codigo    = c-it-codigo NO-ERROR.
        IF NOT AVAIL item-fornec THEN DO:
            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = c-it-codigo NO-ERROR.
        
            CREATE item-fornec.
            ASSIGN item-fornec.cod-emitente = INT(c-cod-emitente)
                   item-fornec.it-codigo    = c-it-codigo
                   item-fornec.unid-med-for = IF AVAIL ITEM THEN ITEM.un ELSE "".
                   /*item-fornec.item-do-forn = c-item-do-forn.*/
        END.
        
        ASSIGN item-fornec.ativo               = IF c-ativo = "sim" THEN YES ELSE NO  
               OVERLAY(item-fornec.char-2,3,2) = c-moeda.
        
        RELEASE item-fornec.

        FIND FIRST int-item-for-PN NO-LOCK
            WHERE int-item-for-PN.cod-emitente = INT(c-cod-emitente)  
              AND int-item-for-PN.it-codigo    = c-it-codigo NO-ERROR.
        IF  NOT AVAIL int-item-for-PN THEN DO:
            CREATE int-item-for-PN.
            ASSIGN int-item-for-PN.cod-emitente = INT(c-cod-emitente)  
                   int-item-for-PN.it-codigo    = c-it-codigo
                   int-item-for-PN.item-do-forn = c-item-do-forn .
         END.


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
RUN pi-finalizar IN h-acomp. 

PROCEDURE WinExec EXTERNAL "kernel32.dll":
  DEF INPUT  PARAM prg_name                          AS CHARACTER.
  DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.
