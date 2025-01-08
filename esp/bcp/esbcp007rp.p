/***********************************************************************
**  Programa..: esp/bcp/escpp007rp.p
**  Autor.....: Nicolas Martinez
**  Data......: Abril/2020 - Desenvolvimento
**  Descricao.: Relat¢rio N£mero de S‚rie x Ped Venda
**  Versao....: 003 07/04/2020
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.
{include/i-prgvrs.i ESBCP007RP 2.00.00.000}

/****************************  Definitions  ****************************/

{esp/bcp/esbcp007.i}

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

DEFINE STREAM str-excel.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

{include/i-rpvar.i}
{esp/es0018.i}

/****************************  Variables  ****************************/
DEFINE VARIABLE h-acomp       AS HANDLE       NO-UNDO.
DEFINE VARIABLE c-aux         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-mensagem    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE i-status      AS INTEGER      NO-UNDO.
DEFINE VARIABLE c-impressao   AS CHARACTER    NO-UNDO.

DEFINE VARIABLE c-excel       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE chExcel       AS COM-HANDLE   NO-UNDO.
DEFINE VARIABLE chArquivo     AS COM-HANDLE   NO-UNDO.
DEFINE VARIABLE chPlanilhaMod AS COM-HANDLE   NO-UNDO.

DEFINE VARIABLE c-tipo        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-desc-item   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-nome-usuar  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE i-cont        AS INT LABEL "Qtd.Num-serie" NO-UNDO.

/****************************  Temp-Tables  ****************************/
DEF BUFFER bitem FOR ITEM.

DEF TEMP-TABLE tt-dados NO-UNDO
    FIELD it-codigo    AS CHAR
    FIELD qtd-est      AS DECI
    FIELD qtd-bip      AS DECI.


/* **************************** Frames ********************************* */

{include/i-rpout.i}
{include/i-rpcab.i}


FOR FIRST tt-param:
END.

ASSIGN  c-programa 	    = "ESBCP007"
	    c-versao	    = "2.00"
	    c-revisao	    = ".00.000"
	    c-empresa       = "Intelbras"
	    c-sistema	    = "BCP"
	    c-titulo-relat  = "Listagem de NS x Ped. Venda".

/* para nÆo visualizar cabe‡alho/rodap‚ em sa¡da RTF */

IF tt-param.destino <> 4 THEN DO:
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
END.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Listando_N£meros_de_S‚rie *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

FIND FIRST ord-prod WHERE
           ord-prod.nr-pedido = string(tt-param.nrPedido)
           NO-LOCK NO-ERROR.

IF AVAIL ord-prod 
THEN DO:

    FIND FIRST ITEM WHERE
               ITEM.it-codigo = ord-prod.it-codigo
               NO-LOCK NO-ERROR.

    DISP ord-prod.nr-ord-produ LABEL "Ord. Prod.:"
         ord-prod.it-codigo    LABEL "Item"
         ITEM.desc-item        LABEL "Descri‡Æo"
         ord-prod.qt-ordem     LABEL "Qtd"
         SKIP
         WITH FRAME f-acabado WIDTH 132 STREAM-IO DOWN.

    CASE tt-param.tipo-arquivo:
        //Estrutura
        WHEN 1 THEN DO:
            FOR EACH estrutura WHERE
                     estrutura.it-codigo    = ord-prod.it-codigo AND
                     estrutura.data-inicio <= TODAY              AND
                     estrutura.data-termino > TODAY
                     NO-LOCK.

               FIND FIRST bitem WHERE
                          bitem.it-codigo = estrutura.es-codigo
                          NO-LOCK NO-ERROR.
               
               DISP estrutura.es-codigo AT 10
                    bitem.desc-item FORMAT "x(50)"
                    estrutura.qtd-compon
                    WITH FRAME f-estrutura WIDTH 132 STREAM-IO DOWN.
            END.
        END.
    
        //Bipados
        WHEN 2 THEN DO:

            ASSIGN c-tipo = "".

            FOR EACH int-col-num-serie WHERE
                     int-col-num-serie.nr-pedido = int(ord-prod.nr-pedido)
                     NO-LOCK.    

               FIND FIRST bitem WHERE
                          bitem.it-codigo = int-col-num-serie.it-codigo
                          NO-LOCK NO-ERROR.
                                        
               IF int-col-num-serie.tp-cod-barra = 1 
               THEN ASSIGN c-tipo = "SERIAL".
               
               IF int-col-num-serie.tp-cod-barra = 2 
               THEN ASSIGN c-tipo = "DUN14".
               
               IF int-col-num-serie.tp-cod-barra = 3 
               THEN ASSIGN c-tipo = "EAN13".

               DISP int-col-num-serie.it-codigo AT 5
                    bitem.desc-item FORMAT "x(50)"
                    c-tipo COLUMN-LABEL "Tipo"
                    int-col-num-serie.cod-barra FORMAT "x(25)" COLUMN-LABEL "Cod. Barra"
                    string(int-col-num-serie.data,"99/99/9999") + " " + string(int-col-num-serie.hora,"HH:MM:SS")
                    FORMAT "x(20)" COLUMN-LABEL "Data/Hora"
                    WITH FRAME f-bipados WIDTH 132 STREAM-IO DOWN.
                                          
            END.
        END.

        //Ambos
        WHEN 3 THEN DO:
            FOR EACH estrutura WHERE
                     estrutura.it-codigo    = ord-prod.it-codigo AND
                     estrutura.data-inicio <= TODAY              AND
                     estrutura.data-termino > TODAY
                     NO-LOCK.

                FIND FIRST tt-dados WHERE
                           tt-dados.it-codigo = estrutura.es-codigo
                           NO-LOCK NO-ERROR.

                IF NOT AVAIL tt-dados 
                THEN DO:
                    CREATE tt-dados.
                    ASSIGN tt-dados.it-codigo = estrutura.es-codigo
                           tt-dados.qtd-est   = estrutura.qtd-compon.
                END.
            END.

            FOR EACH int-col-num-serie WHERE
                     int-col-num-serie.nr-pedido = int(ord-prod.nr-pedido)
                     NO-LOCK.  

                FIND FIRST tt-dados WHERE
                           tt-dados.it-codigo = int-col-num-serie.it-codigo
                           NO-LOCK NO-ERROR.

                IF NOT AVAIL tt-dados 
                THEN DO:
                    CREATE tt-dados.
                    ASSIGN tt-dados.it-codigo = estrutura.es-codigo
                           tt-dados.qtd-bip   = 1.
                END.
                ELSE DO:
                    IF int-col-num-serie.tp-cod-barra = 1 THEN
                       ASSIGN tt-dados.qtd-bip = tt-dados.qtd-bip + 1.
                    ELSE DO:
                        FIND FIRST estrutura WHERE
                                   estrutura.it-codigo    = ord-prod.it-codigo          AND
                                   estrutura.es-codigo    = int-col-num-serie.it-codigo AND
                                   estrutura.data-inicio <= TODAY                       AND
                                   estrutura.data-termino > TODAY
                                   NO-LOCK NO-ERROR.
                        
                        IF AVAIL estrutura
                        THEN DO:
                            ASSIGN tt-dados.qtd-bip = estrutura.qtd-compon.
                        END.
                    END.
                END.
            END.

            FOR EACH tt-dados NO-LOCK.

                FIND FIRST bitem WHERE
                           bitem.it-codigo = tt-dados.it-codigo
                           NO-LOCK NO-ERROR.

                DISP tt-dados.it-codigo  COLUMN-LABEL "Item" AT 10
                     bitem.desc-item bitem.desc-item FORMAT "x(50)"
                     bitem.un            COLUMN-LABEL "UN"   
                     tt-dados.qtd-est    COLUMN-LABEL "Qtd Est"
                     tt-dados.qtd-bip    COLUMN-LABEL "Qtd Bip"
                     WITH FRAME f-compara WIDTH 132 STREAM-IO DOWN.
            END.
        END.
    END CASE.
END.

PAGE.

disp skip(1)
     "SELE€ÇO" NO-LABEL
     SKIP(1)
     tt-param.nrPedido LABEL "Ped. Venda" FORMAT "zzzzzzz9"  AT 04 
     with frame f-selec width 132 stream-io side-labels.

/*fechamento do output do relat¢rio*/
{include/i-rpclo.i}
RUN pi-finalizar IN h-acomp.














