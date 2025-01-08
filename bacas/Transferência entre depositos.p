
/*

Acrescentar os diret¢rios para compilar           
           
\\totvs\erp\ddkgui
c:\fontes11

*/



FIND FIRST param-estoq NO-LOCK NO-ERROR.    

{utp/ut-glob.i}    
{cep/ceapi001k.i}
{cdp/cd0666.i}
{cdp/cd0667.i "-bkp"}

DEFINE VARIABLE deSaldo LIKE saldo-estoq.qtidade-atu     NO-UNDO.
DEFINE VARIABLE i-seq AS INTEGER INITIAL 0     NO-UNDO.
define variable h-acomp as handle no-undo.

run utp/ut-acomp.p persisten set h-acomp.
run pi-inicializar in h-acomp (input "Transferˆncia").

DEFINE VARIABLE h-ceapi001k AS HANDLE      NO-UNDO.


 
transf:
DO TRANS ON ERROR UNDO transf, LEAVE transf:

    FOR EACH saldo-estoq NO-LOCK
       WHERE saldo-estoq.cod-estabel = "107" /*Estabelecimento*/
         AND saldo-estoq.cod-depos   = "SUC" /*Dep¢sito*/
         by saldo-estoq.it-codigo:

        FIND FIRST ITEM NO-LOCK 
            WHERE item.it-codigo = saldo-estoq.it-codigo NO-ERROR.                  
            
        if item.cod-obsoleto = 4 then
            next.

        FOR FIRST estab-mat
            WHERE estab-mat.cod-estabel = saldo-estoq.cod-estabel:
        END.

        ASSIGN deSaldo = saldo-estoq.qtidade-atu  - 
                         saldo-estoq.qt-aloc-prod - 
                         saldo-estoq.qt-aloc-ped  - 
                         saldo-estoq.qt-alocada.
                         
        run pi-acompanhar in h-acomp (input "Item:" + saldo-estoq.it-codigo + " " + "Saldo: " + string (deSaldo)).

        
        IF deSaldo <= 0 THEN NEXT.       


        CREATE tt-movto.
        ASSIGN tt-movto.cod-versao-integracao = 001
               tt-movto.usuario               = c-seg-usuario
               tt-movto.cod-prog-orig         = "CE0206"
               tt-movto.cod-estabel           = saldo-estoq.cod-estabel
               tt-movto.cod-depos             = saldo-estoq.cod-depos
               tt-movto.it-codigo             = saldo-estoq.it-codigo
               tt-movto.cod-localiz           = ""
               tt-movto.lote                  = saldo-estoq.lote
               tt-movto.cod-refer             = saldo-estoq.cod-refer
               tt-movto.referencia            = saldo-estoq.cod-refer
               tt-movto.tipo-trans            = 2 /* Sa¡da */
               tt-movto.ct-codigo             = param-estoq.ct-tr-transf
               tt-movto.sc-codigo             = param-estoq.sc-tr-transf
               tt-movto.dt-trans              = TODAY
               tt-movto.esp-docto             = 33 /* TRA */
               tt-movto.quantidade            = deSaldo
               tt-movto.un                    = item.un
               tt-movto.nro-docto             = "WMS" /* Verificar o n£mero do docto*/
               tt-movto.dt-vali-lote          = saldo-estoq.dt-vali-lote.
           
        /* Cria transacao de entrada */       
        CREATE tt-movto.
        ASSIGN tt-movto.cod-versao-integracao = 001
               tt-movto.usuario               = c-seg-usuario
               tt-movto.cod-prog-orig         = "ce0206"
               tt-movto.cod-estabel           = saldo-estoq.cod-estabel
               tt-movto.cod-depos             = "PRO" /* Dep¢sito de entrada <-------------------------------*/
               tt-movto.it-codigo             = saldo-estoq.it-codigo
               tt-movto.cod-localiz           = ""
               tt-movto.lote                  = saldo-estoq.lote
               tt-movto.cod-refer             = saldo-estoq.cod-refer
               tt-movto.referencia            = saldo-estoq.cod-refer
               tt-movto.tipo-trans            = 1 /* Entrada */
               tt-movto.ct-codigo             = param-estoq.ct-tr-transf
               tt-movto.sc-codigo             = param-estoq.sc-tr-transf
               tt-movto.dt-trans              = TODAY
               tt-movto.esp-docto             = 33 /* TRA */
               tt-movto.quantidade            = deSaldo
               tt-movto.un                    = item.un
               tt-movto.nro-docto             = "WMS" /* Verificar o n£mero do docto*/
               tt-movto.dt-vali-lote          = saldo-estoq.dt-vali-lote.
    END.
    
    run pi-finalizar in h-acomp.

    IF TEMP-TABLE tt-movto:HAS-RECORDS THEN DO:
        RUN cep/ceapi001k.p PERSISTENT SET h-ceapi001k.
             
        RUN pi-execute IN h-ceapi001k(INPUT-OUTPUT TABLE tt-movto,
                                      INPUT-OUTPUT TABLE tt-erro,
                                      INPUT        FALSE).
    END.

    IF TEMP-TABLE tt-erro:HAS-RECORDS THEN DO:
        FOR EACH tt-erro:
            ASSIGN i-seq = i-seq + 1.
            CREATE tt-erro-bkp.
            ASSIGN tt-erro-bkp.i-sequen  = i-seq
                   tt-erro-bkp.cd-erro   = tt-erro.cd-erro
                   tt-erro-bkp.mensagem  = tt-erro.mensagem
                   tt-erro-bkp.parametro = "erro".
        END.
    
        IF CAN-FIND (FIRST tt-erro-bkp) THEN DO:
            RUN cdp/cd0667.w (INPUT TABLE tt-erro-bkp).
        END.
    
        UNDO transf, RETURN "NOK".
    END.
END.   

MESSAGE "Terminou"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.


RETURN "OK".

