{include/i-epc200.i1}
{method/dbotterr.i}
{include/boerrtab.i}
{upc/btb910za-upc.i}

DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

DEF VAR i-itiner-OC1  AS INT     NO-UNDO.
DEF VAR i-itiner-OC2  AS INT     NO-UNDO.
def var i-ordem-1     as int     no-undo.
def var l-embarque    as log     no-undo.

assign l-embarque = no.

FOR EACH tt-epc 
    WHERE tt-epc.cod-event = 'AfterCreateOrdensEmbarque':

    IF tt-epc.cod-parameter = 'ordem-compra.numero-ordem' THEN DO:
    
        FOR FIRST cotacao-item NO-LOCK 
            WHERE cotacao-item.numero-ordem = INT(tt-epc.val-parameter):
            
            ASSIGN i-itiner-OC1 = cotacao-item.int-1
                   i-ordem-1    = cotacao-item.numero-ordem.
        END.
    END.
    
    IF tt-epc.cod-parameter = 'row-embarque-imp' THEN DO:
    
        FOR FIRST embarque-imp NO-LOCK 
            WHERE ROWID(embarque-imp) = TO-ROWID(tt-epc.val-parameter) :
            
           FOR FIRST ordens-embarque OF embarque-imp:
           
               assign l-embarque = yes. 
           
               FOR FIRST cotacao-item NO-LOCK  
                   WHERE cotacao-item.numero-ordem = INT(ordens-embarque.numero-ordem):

                   ASSIGN i-itiner-OC2 = cotacao-item.int-1.
               END .        
           END.
       END.    
    END .   
     
    if l-embarque then do:                  
        IF i-itiner-OC1 <> i-itiner-OC2 THEN DO:
        
            RUN utp\ut-msgs.p (INPUT "SHOW",
                               INPUT 17006,
                               INPUT "ATENÄ«O: Ordem com itiner†rio divergente.~~A ordem " + string(i-ordem-1) + " n∆o pode ser vinculada neste embarque pois seu itiner†rio difere do itiner†rio do embarque").
                               
            RETURN ERROR.
        end.    
    END.
END.    

RETURN "Ok":U.


      
