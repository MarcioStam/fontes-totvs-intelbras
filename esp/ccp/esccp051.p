DEF TEMP-TABLE tt-transfere-item
    field cod-estabel as char
    field cod-item    as char
    field qtd-item    AS DEC.

DEF INPUT PARAM  p-docto        AS CHAR NO-UNDO.
DEF INPUT PARAM  p-dep-orig     AS CHAR NO-UNDO.
DEF INPUT PARAM  p-dep-dest     AS CHAR NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-transfere-item.
DEF OUTPUT PARAM p-retorno      AS CHAR NO-UNDO.

/* variaveis globais */
{utp/ut-glob.i}   

{esp/es0018.i}
 
/* Definicao de temp-tables para movimentacao de estoque */
{cep/ceapi001.i}
{cdp/cd0666.i}

FOR EACH tt-movto: DELETE tt-movto. END.
FOR EACH tt-erro:  DELETE tt-erro.  END.

/* Inicio */

DO TRANSACTION: 

    FOR EACH tt-transfere-item,
        FIRST ITEM WHERE item.it-codigo = tt-transfere-item.cod-item NO-LOCK:

        CREATE tt-movto.
        ASSIGN tt-movto.cod-versao-integracao = 1
               tt-movto.cod-prog-orig         = "ESFTP211"                                                                 
               tt-movto.dt-trans              = TODAY                                                                     
               tt-movto.nro-docto             = p-docto 
               tt-movto.nr-ord-prod           = int(p-docto) 
               tt-movto.it-codigo             = tt-transfere-item.cod-item                                                                   
               tt-movto.un                    = ITEM.un
               tt-movto.cod-estabel           = tt-transfere-item.cod-estabel                                                            
               tt-movto.cod-depos             = p-dep-orig           
               tt-movto.cod-refer             = ''                                                                   
               tt-movto.cod-localiz           = ''                                                                        
               tt-movto.lote                  = ''                                                               
               tt-movto.quantidade            = tt-transfere-item.qtd-item                                                                  
               tt-movto.tipo-trans            = 2           /* 1 = Entrada, 2 = Sa¡da */                                  
               tt-movto.esp-docto             = 33                                                                        
               tt-movto.usuario               = c-seg-usuario
               tt-movto.ct-codigo             = "14111018000008".
    
        CREATE tt-movto.
        ASSIGN tt-movto.cod-versao-integracao = 1
               tt-movto.cod-prog-orig         = "ESFTP211"                                                                 
               tt-movto.dt-trans              = TODAY                                                                     
               tt-movto.nro-docto             = p-docto
               tt-movto.nr-ord-prod           = int(p-docto)
               tt-movto.it-codigo             = tt-transfere-item.cod-item                                                                 
               tt-movto.un                    = ITEM.un
               tt-movto.cod-estabel           = tt-transfere-item.cod-estabel                                                                
               tt-movto.cod-depos             = p-dep-dest
               tt-movto.cod-refer             = ''                                                                   
               tt-movto.cod-localiz           = ''
               tt-movto.lote                  = ''                                                               
               tt-movto.quantidade            = tt-transfere-item.qtd-item                                                                    
               tt-movto.tipo-trans            = 1           /* 1 = Entrada, 2 = Sa¡da */                                  
               tt-movto.esp-docto             = 33                                                                        
               tt-movto.usuario               = c-seg-usuario
               tt-movto.ct-codigo             = "14111018000008".

    END.

    run cep/ceapi001.p (input-output table tt-movto,
                        input-output table tt-erro, 
                        input        yes).

    FIND FIRST tt-erro NO-ERROR.
    
    IF NOT AVAIL tt-erro THEN
         ASSIGN p-retorno = 'OK - Movimentacao realizada com Sucesso'.
    ELSE DO:
       ASSIGN p-retorno = "ERRO - Transferencia nao realizada" + CHR(13).

       FOR EACH tt-erro BREAK BY tt-erro.cd-erro:
           IF FIRST-OF(tt-erro.cd-erro) THEN
              ASSIGN p-retorno = p-retorno + string(tt-erro.cd-erro) + " - " + tt-erro.mensagem + CHR(13).
       END.

       RUN pi-log-erro(INPUT p-retorno).
    
       UNDO, LEAVE.  
    END.

    
END.    
 
/* Fim do Programa */

PROCEDURE pi-log-erro:

    DEF INPUT PARAM p-erro         AS CHAR NO-UNDO.
    
    DEFINE VARIABLE c-arquivo-erro AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-dir-saida    AS CHARACTER NO-UNDO.
       
    ASSIGN c-arquivo-erro = "esftp211_" + REPLACE(STRING(TIME,'HH:MM'),':','') + ".txt":U.
    
    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. /* FOR FIRST tt-prog-ponto: */
    
        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arquivo-erro = c-dir-saida + TRIM(c-arquivo-erro).
    END. /* IF  OPSYS = "unix" THEN DO: */
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. /* FOR FIRST tt-prog-ponto: */
    
        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arquivo-erro = c-dir-saida + TRIM(c-arquivo-erro).
    END.
    
    OUTPUT TO value(c-arquivo-erro) NO-MAP NO-CONVERT.
    PUT UNFORMATTED p-erro.
    OUTPUT CLOSE.
    
    DOS SILENT START VALUE(c-arquivo-erro). 

END PROCEDURE.
