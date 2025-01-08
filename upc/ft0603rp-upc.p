/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/* {include/i-prgvrs.i ft0603-upc 2.03.00.043}  /*** 010043 ***/ */

/************************************************************************
**
** ft0603-upc.P - Nota de Diferenáa Cambial - log13176
**
*************************************************************************/


define temp-table tt-epc no-undo
   field cod-event     as char format "x(12)"
   field cod-parameter as char format "x(32)"
   field val-parameter as char format "x(54)"
   index  id is primary cod-parameter cod-event ascending.    

def input param p-ind-event as char no-undo.
def input-output param table for tt-epc.

{esp/es0018.i}

DEF VAR c-estabel-ini          AS CHARACTER NO-UNDO.
DEF VAR c-estabel-fim          AS CHARACTER NO-UNDO.
DEF VAR c-serie-ini            AS CHARACTER NO-UNDO.
DEF VAR c-serie-fim            AS CHARACTER NO-UNDO.
DEF VAR c-nota-fis-ini         AS CHARACTER NO-UNDO.
DEF VAR c-nota-fis-fim         AS CHARACTER NO-UNDO.
DEF VAR da-emis-ini            AS DATE      NO-UNDO.
DEF VAR da-emis-fim            AS DATE      NO-UNDO.
DEFINE VARIABLE i-posicao      AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-campo        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-valor        AS CHARACTER   NO-UNDO.
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
       
       IF  AVAIL nota-fiscal THEN DO:
           
           IF  (nota-fiscal.serie = "R2" 
           OR  nota-fiscal.serie = "R3" 
           OR  nota-fiscal.serie = "R4")   
           AND substr(nota-fiscal.char-1,143,2) <> '3' THEN DO:            
              PUT skip                
                  "Nota fiscal de serviáo n∆o possui status de convertida: " nota-fiscal.cod-estabel  " / "  nota-fiscal.serie " / " nota-fiscal.nr-nota-fis SKIP.
              
              ASSIGN tt-epc.val-parameter = "error".            
              RETURN "NOK":U.        
           END.

           IF  nota-fiscal.cod-cond-pag = 0 THEN DO:
               FIND FIRST ped-venda NO-LOCK
                    WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli
                    AND   ped-venda.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.
    
               IF  AVAIL ped-venda THEN DO:
                   FIND FIRST int-ped-venda
                        WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.
        
                   IF  AVAIL int-ped-venda 
                   AND int-ped-venda.cod-projeto <> "" AND NOT int-ped-venda.origem MATCHES("*Salesforce*") THEN DO: /* Ignorar pedidos da Solar, estes ser∆o tratados apenas pelo esacr078 */
                       ASSIGN tt-epc.val-parameter = "error".
                       RETURN "NOK":U.
                   END.
               END.
           END.
       END.    
    END.
END.

if  p-ind-event = "AtualizaPortModal" THEN DO:
    FIND FIRST tt-epc 
        where tt-epc.cod-event = p-ind-event
          AND tt-epc.cod-parameter = "rowid-fat-duplic"
        NO-LOCK NO-ERROR.
    IF AVAIL tt-epc THEN DO:
        assign r-rowid = to-rowid(tt-epc.val-parameter).      
        find fat-duplic
             WHERE ROWID(fat-duplic) = r-rowid
             NO-LOCK NO-ERROR.
        IF AVAIL fat-duplic THEN DO:
            FIND nota-fiscal
                 WHERE nota-fiscal.cod-estabel = fat-duplic.cod-estabel
                   AND nota-fiscal.serie       = fat-duplic.serie
                   AND nota-fiscal.nr-fatura   = fat-duplic.nr-fatura
                NO-LOCK NO-ERROR.
            IF AVAIL nota-fiscal THEN DO:
	    
	    	EMPTY TEMP-TABLE tt-prog-ponto.
                RUN esp/es0018p.p (INPUT "ft0603":U,
                                   INPUT 1,
                                   INPUT 0,
                                   INPUT "":U,
                                   OUTPUT TABLE tt-prog-ponto).
                
                FOR FIRST tt-prog-ponto
                    WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = STRING(nota-fiscal.cod-cond-pag): END.
                IF AVAIL tt-prog-ponto THEN DO:
                    FIND FIRST tt-epc 
                         where tt-epc.cod-event = p-ind-event
                           AND tt-epc.cod-parameter = "cod-portador" NO-LOCK NO-ERROR.
                    IF AVAIL tt-epc THEN DO:
                        ASSIGN tt-epc.val-parameter = ENTRY(2,tt-prog-ponto.conteudo,";").
                    END.
                    FIND FIRST tt-epc 
                         where tt-epc.cod-event = p-ind-event
                           AND tt-epc.cod-parameter = "modalidade" NO-LOCK NO-ERROR.
                    IF AVAIL tt-epc THEN DO:
                        ASSIGN tt-epc.val-parameter = ENTRY(3,tt-prog-ponto.conteudo,";").
                    END.
                END.
                ELSE DO:
                    FIND emitente
                         WHERE emitente.cod-emitente = nota-fiscal.cod-emitente
                         NO-LOCK NO-ERROR.
                    IF AVAIL emitente AND 
                        emitente.cod-gr-cli = 20  AND
                        (nota-fiscal.cod-canal-venda = 4 OR 
                         nota-fiscal.cod-canal-venda = 7) THEN DO:
                        FIND FIRST tt-epc 
                            where tt-epc.cod-event = p-ind-event
                              AND tt-epc.cod-parameter = "cod-portador"
                            NO-LOCK NO-ERROR.
                        IF AVAIL tt-epc THEN DO:
                            ASSIGN tt-epc.val-parameter = "999".
                        END.
                        FIND FIRST tt-epc 
                            where tt-epc.cod-event = p-ind-event
                              AND tt-epc.cod-parameter = "modalidade"
                            NO-LOCK NO-ERROR.
                        IF AVAIL tt-epc THEN DO:
                            ASSIGN tt-epc.val-parameter = "90".
                        END.
                    END.
                END.
            END.
        END.
    END.
END.
if  p-ind-event = "fim ft0603rp" THEN DO:
    FIND FIRST tt-epc 
        where tt-epc.cod-event = p-ind-event
          AND tt-epc.cod-parameter = "Campo"
        NO-LOCK NO-ERROR.
    IF AVAIL tt-epc THEN DO:
        ASSIGN c-campo = replace(tt-epc.val-parameter,"i-pais.c-estabel-fim","i-pais;c-estabel-fim").
        
        FIND FIRST tt-epc 
            where tt-epc.cod-event = p-ind-event
              AND tt-epc.cod-parameter = "Valor"
            NO-LOCK NO-ERROR.

        IF AVAIL tt-epc THEN DO:
            ASSIGN c-valor = tt-epc.val-parameter.


            ASSIGN i-posicao      = LOOKUP("c-nota-fis-ini",c-campo,";")
                   c-nota-fis-ini = entry(i-posicao, c-valor, ";") 
                   i-posicao      = LOOKUP("c-nota-fis-fim",c-campo,";")
                   c-nota-fis-fim = entry(i-posicao, c-valor, ";")
    
                   i-posicao      = LOOKUP("c-estabel-ini",c-campo,";")
                   c-estabel-ini  = entry(i-posicao, c-valor, ";") 
                   i-posicao      = LOOKUP("c-estabel-fim",c-campo,";")
                   c-estabel-fim  = entry(i-posicao, c-valor, ";") 
                
                   i-posicao      = LOOKUP("c-serie-ini",c-campo,";")
                   c-serie-ini    = entry(i-posicao, c-valor, ";")
                   i-posicao      = LOOKUP("c-serie-fim",c-campo,";")
                   c-serie-fim    = entry(i-posicao, c-valor, ";")
    
                   i-posicao      = LOOKUP("da-emis-ini",c-campo,";")
                   da-emis-ini    = date(entry(i-posicao, c-valor, ";"))
                   i-posicao      = LOOKUP("da-emis-fim",c-campo,";")
                   da-emis-fim    = date(entry(i-posicao, c-valor, ";")). 
                     
    
            FOR EACH nota-fiscal 
                WHERE nota-fiscal.cod-estabel  >= c-estabel-ini
                  AND nota-fiscal.cod-estabel  <= c-estabel-fim
                  AND nota-fiscal.serie        >= c-serie-ini
                  AND nota-fiscal.serie        <= c-serie-fim
                  AND nota-fiscal.nr-nota-fis  >= c-nota-fis-ini
                  AND nota-fiscal.nr-nota-fis  <= c-nota-fis-fim
                  AND nota-fiscal.dt-emis-nota >= da-emis-ini
                  AND nota-fiscal.dt-emis-nota <= da-emis-fim
                  AND nota-fiscal.dt-atual-cr   = ? EXCLUSIVE-LOCK:

                IF AVAIL ser-estab THEN DO:
                   IF (ser-estab.cod-estabel <> nota-fiscal.cod-estabel OR
                       ser-estab.serie       <> nota-fiscal.serie) THEN DO:
                        FIND ser-estab
                             WHERE ser-estab.cod-estabel = nota-fiscal.cod-estabel
                               AND ser-estab.serie       = nota-fiscal.serie
                             NO-LOCK NO-ERROR.
                   END.
                END.
                ELSE
                    FIND ser-estab
                         WHERE ser-estab.cod-estabel = nota-fiscal.cod-estabel
                           AND ser-estab.serie       = nota-fiscal.serie
                         NO-LOCK NO-ERROR.

                FIND FIRST tit_acr NO-LOCK
                    WHERE tit_acr.cod_estab            = nota-fiscal.cod-estabel
                      AND tit_acr.cod_espec_docto      = ser-estab.cod-esp
                      AND tit_acr.cod_ser_docto        = nota-fiscal.serie
                      AND tit_acr.cod_tit_acr          = nota-fiscal.nr-fatura
                      NO-ERROR.

                IF AVAIL tit_acr THEN DO:
                    assign nota-fiscal.dt-atual-cr  = TODAY.

                    for each fat-duplic EXCLUSIVE-LOCK
                       where fat-duplic.serie       = nota-fiscal.serie
                         and fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                         and fat-duplic.nr-fatura   = nota-fiscal.nr-fatura :

                       assign fat-duplic.flag-atualiz = YES.
                    end.                                   
                END.
            END.
        END.
    END.
END.

               

        
