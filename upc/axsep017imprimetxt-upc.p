/***********************************************************************
**  Programa..: upc\axsep017imprimetxt-upc.p
**  Autor.....: Anderson Cenci
**  Data......: 03/06/2011
**  Descricao.: 
**  Versão....: Desenvolvimento Programa
************************************************************************/

{include/i-epc200.i1}
{utp/ut-glob.i}
def input param p-ind-event as char no-undo.
def input-output param table for tt-epc.

DEFINE VARIABLE pcArquivoNFeTXT AS CHARACTER   NO-UNDO.

DEF BUFFER b-tt-epc FOR tt-epc.
/*     OUTPUT TO /usr8/spool/an046325/axsep017imprimetxt.LOG. */
/*     PUT "axsep017imprimetxt" SKIP.                         */
    

case p-ind-event:
    WHEN "AlteraArquivoNFeTXT" THEN DO:
        for each tt-epc EXCLUSIVE-LOCK
            where tt-epc.cod-event       = p-ind-event 
              AND tt-epc.cod-parameter   = "ArquivoNFeTXT": 

/*             PUT "axsep017imprimetxt 1 " TRIM(SUBSTRING(tt-epc.val-parameter,INDEX(tt-epc.val-parameter,"NFe_") + 12,3)) SKIP. */
/*                                                                                                                               */
            find first nfe-param no-lock 
                where nfe-param.cod-estabel = TRIM(SUBSTRING(tt-epc.val-parameter,INDEX(tt-epc.val-parameter,"NFe_") + 12,3))    no-error.
            
/*             PUT "axsep017imprimetxt 2 " AVAIL nfe-param SKIP     */
/*                 tt-epc.val-parameter FORMAT "x(300)" SKIP        */
/*                 nfe-param.end-imp-txt  FORMAT "x(300)" SKIP      */
/*                 nfe-param.end-imp-txt-unix  FORMAT "x(300)" SKIP */
/*                                                                  */
/*                 SKIP.                                            */

            IF AVAIL nfe-param THEN DO:
                IF OPSYS <> 'WIN32' THEN DO:

                    ASSIGN pcArquivoNFeTXT = nfe-param.end-imp-txt-unix .


/*                     PUT "axsep017imprimetxt 3 " pcArquivoNFeTXT FORMAT "x(200)" SKIP. */
/*                                                                                       */
                 
                    ASSIGN tt-epc.cod-event      = "AlteraArquivoNFeTXT"
                           tt-epc.cod-parameter  = "ArquivoNFeTXTAlterado"
                           tt-epc.val-parameter  = replace(replace(tt-epc.val-parameter,nfe-param.end-imp-txt,nfe-param.end-imp-txt-unix),"~\","~/")
                           tt-epc.val-parameter  = replace(replace(tt-epc.val-parameter,nfe-param.end-imp-txt,pcArquivoNFeTXT),"~\","~/").

/*                     PUT "apos " tt-epc.val-parameter FORMAT "x(300)" SKIP. */
                    
                END.
            END.

/*             PUT "axsep017imprimetxt 3 "  SKIP. */

        END.

    end.
    
end case.
/*  PUT "axsep017imprimetxt 4 "  SKIP. */
/*  OUTPUT CLOSE.                      */
return "OK":U.

