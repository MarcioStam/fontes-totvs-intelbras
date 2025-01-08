 
TRIGGER PROCEDURE FOR WRITE OF estrut-astec OLD BUFFER b-old-estrut-astec.

    /*
DEF PARAM BUFFER b-estrut-astec      FOR estrut-astec.
DEF PARAM BUFFER b-old-estrut-astec  FOR estrut-astec.
*/

    /*
{utp/utapi019.i}
{utp/ut-glob.i}
{upc/btb910za-upc.i}
{esp/es0018.i}
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}

DEFINE VARIABLE cNom_from   AS CHARACTER    NO-UNDO INITIAL ''.
DEFINE VARIABLE lErro       AS LOGICAL      NO-UNDO INITIAL NO.
DEFINE VARIABLE C-ALTERACAO AS char format "x(35)" no-undo initial ''.
DEFINE VARIABLE c-fiscal-atu AS char format "x(15)" no-undo initial ''.
DEFINE VARIABLE c-fiscal-ant AS char format "x(15)" no-undo initial ''.
DEFINE VARIABLE c-programa   AS char format "x(40)" extent 3  no-undo initial ''.
def var c-desc-usuario as char format "x(30)".

*/

/*RUN pi-cria-int-estrutura.*/

/*Inicio Integra‡Æo*/
/* DEFINE TEMP-TABLE tt-estrutura-integra NO-UNDO                      */
/*     FIELD CodigoProduto LIKE estrutura.it-codigo.                   */
/* DEF VAR raw-param   AS RAW  NO-UNDO.                                */
/*                                                                     */
/* CREATE tt-estrutura-integra.                                        */
/* ASSIGN tt-estrutura-integra.CodigoProduto = estrut-astec.it-codigo. */
/*                                                                     */
/* RAW-TRANSFER tt-estrutura-integra TO raw-param.                     */
/*                                                                     */
/* RUN esp/trgw/wes727a.p (INPUT raw-param,                            */
/*                         INPUT 'msg0301').                           */

/*
PROCEDURE pi-cria-int-estrutura.

    DEFINE BUFFER b-int-estrut-ant  FOR int-estrutura.
          
    IF NEW estrut-astec THEN DO:

        find first int-estrutura EXCLUSIVE-LOCK
             where int-estrutura.it-codigo = estrut-astec.it-codigo
               and int-estrutura.es-codigo = estrut-astec.es-codigo
               and int-estrutura.sequencia = estrut-astec.sequencia no-error.
        
        if not avail int-estrutura then do:
            
            create int-estrutura.
            assign int-estrutura.it-codigo = estrut-astec.it-codigo
                   int-estrutura.es-codigo = estrut-astec.es-codigo
                   int-estrutura.sequencia = estrut-astec.sequencia.

            FOR FIRST b-int-estrut-ant NO-LOCK
                WHERE b-int-estrut-ant.it-codigo =  estrut-astec.it-codigo
                AND   b-int-estrut-ant.es-codigo =  estrut-astec.es-codigo
                AND   ROWID(b-int-estrut-ant)    <> ROWID(int-estrutura):

                ASSIGN int-estrutura.garantia = b-int-estrut-ant.garantia
                       int-estrutura.venda    = b-int-estrut-ant.venda.
            END.
        END.
    END.
    ELSE DO:

        find first int-estrutura EXCLUSIVE-LOCK
             where int-estrutura.it-codigo = b-old-estrut-astec.it-codigo
               and int-estrutura.es-codigo = b-old-estrut-astec.es-codigo
               and int-estrutura.sequencia = b-old-estrut-astec.sequencia no-error.
        
        if not avail int-estrutura then do:
           
            create int-estrutura.
            assign int-estrutura.it-codigo = b-old-estrut-astec.it-codigo
                   int-estrutura.es-codigo = b-old-estrut-astec.es-codigo
                   int-estrutura.sequencia = b-old-estrut-astec.sequencia.
    
        END.

        ASSIGN int-estrutura.it-codigo = estrut-astec.it-codigo
               int-estrutura.es-codigo = estrut-astec.es-codigo
               int-estrutura.sequencia = estrut-astec.sequencia.

    END.

    assign int-estrutura.visivel = yes.

END.
*/







