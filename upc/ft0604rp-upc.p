/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/* {include/i-prgvrs.i ft0604-upc 2.03.00.000}   */

/************************************************************************
**
** ft0604-upc.P - 
**
*************************************************************************/


define temp-table tt-epc no-undo
   field cod-event     as char format "x(12)"
   field cod-parameter as char format "x(32)"
   field val-parameter as char format "x(54)"
   index  id is primary cod-parameter cod-event ascending.    

def input param p-ind-event as char no-undo.
def input-output param table for tt-epc.


DEFINE VARIABLE r-rowid        AS ROWID       NO-UNDO.

if  p-ind-event = "Point-One" THEN DO:    
    FIND FIRST tt-epc         
    where tt-epc.cod-event = p-ind-event          
      AND tt-epc.cod-parameter = "rowid-nota-fiscal"        
      NO-LOCK NO-ERROR.    
    IF AVAIL tt-epc THEN DO:        
       assign r-rowid = to-rowid(tt-epc.val-parameter).            
       FIND nota-fiscal            
            WHERE ROWID(nota-fiscal) = r-rowid NO-LOCK NO-ERROR.        
       IF AVAIL nota-fiscal AND           
          (nota-fiscal.serie = "R2" OR
           nota-fiscal.serie = "R3" OR
           nota-fiscal.serie = "R4")  AND            
          substr(nota-fiscal.char-1,143,2) <> '3' THEN DO:            
          PUT skip                
              "Nota fiscal de serviáo n∆o possui status de convertida: "  nota-fiscal.cod-estabel    " / "  nota-fiscal.serie  " / " nota-fiscal.nr-nota-fis   SKIP.             
          ASSIGN tt-epc.val-parameter = "error".             
          RETURN "NOK":U.        
       END.    
    END.
END.

