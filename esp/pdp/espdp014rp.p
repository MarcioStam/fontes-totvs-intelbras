/*****************************************************************************
**     Programa.........: esp/pdp/espdp014rp.p
**     Descricao .......: Comiss∆o revenda
**     Versao...........: 1.00.000
**     Autor............: Clayton Antunes
**     Criado...........: 01/03/2006
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESPDP014 2.04.00.001}

/****************************  Definitions  ****************************/
{esp/pdp/espdp014tt.i}
{include/i-rpvar.i}


/****************************  Temp-Tables  ****************************/
DEF TEMP-TABLE tt-nf
    FIELD dt-emis-nota      LIKE nota-fiscal.dt-emis-nota
    FIELD vl-mercad         LIKE nota-fiscal.vl-mercad    
    FIELD nr-pedcli         LIKE ped-venda.nr-pedcli
    FIELD cod-emitente      LIKE ped-venda.cod-emitente
    FIELD nome-abrev        LIKE ped-venda.nome-abrev
    FIELD vl-comis-distrib  LIKE int-ped-venda.vl-comis-distrib
    FIELD vl-serv-inst      LIKE int-ped-venda.vl-serv-inst.
    /*
    index tt-nf is primary unique nr-nota-fis
    index tt-ct ct-codigo sc-codigo.
    */

/****************************  Variaveis    ****************************/
DEF VAR dt-data AS DATE.


/****************************  Frames       ****************************/

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.

RAW-TRANSFER raw-param TO tt-param.

DEF VAR h-acomp AS HANDLE NO-UNDO.
FIND FIRST empresa NO-LOCK WHERE
           empresa.ep-codigo = tt-param.ep-codigo NO-ERROR.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Comiss∆o Revenda"
       c-empresa      = IF AVAIL empresa THEN empresa.razao-social ELSE ''
       c-programa     = "ESPDP014"
       c-versao       = "2.04"
       c-revisao      = "001".


/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i}
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    RUN utp/ut-acomp.p persistent set h-acomp.  
    RUN pi-inicializar in h-acomp (input "Montando Relat¢rio...").
    RUN pi-relat.
    RUN pi-inicializar in h-acomp (input "Imprimindo...").
    RUN pi-imprime.

    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.
/* fim do programa */


PROCEDURE pi-relat:
        FOR EACH tt-nf:
            DELETE tt-nf.
        END.
        DO dt-data = tt-param.da-emis-ini TO tt-param.da-emis-fim:
            FOR EACH nota-fiscal NO-LOCK WHERE
                     nota-fiscal.cod-estabel = tt-param.cod-estabel and
                     nota-fiscal.dt-emis-nota = dt-data:
                FOR EACH ped-venda NO-LOCK WHERE
                         ped-venda.cod-estabel = nota-fiscal.cod-estabel and
                         ped-venda.nr-pedcli = nota-fiscal.nr-pedcli:
                    FOR EACH int-ped-venda NO-LOCK WHERE 
                             int-ped-venda.nr-pedido = ped-venda.nr-pedido AND
                             int-ped-venda.cod-estabel = ped-venda.cod-estabel AND
                             (int-ped-venda.vl-comis-distrib <> 0          OR
                             int-ped-venda.vl-serv-inst     <> 0):
                             RUN pi-acompanhar IN h-acomp (INPUT "Data Nota: " + string(nota-fiscal.dt-emis-nota)).
                             CREATE tt-nf.
                             ASSIGN tt-nf.dt-emis-nota     = nota-fiscal.dt-emis-nota
                                    tt-nf.vl-mercad        = nota-fiscal.vl-mercad
                                    tt-nf.nr-pedcli        = ped-venda.nr-pedcli
                                    tt-nf.cod-emitente     = ped-venda.cod-emitente
                                    tt-nf.nome-abrev       = ped-venda.nome-abrev
                                    tt-nf.vl-serv-inst     = int-ped-venda.vl-serv-inst
                                    tt-nf.vl-comis-distrib = int-ped-venda.vl-comis-distrib.
                    END.
                END.
            END.
        END.
END PROCEDURE.


PROCEDURE pi-imprime:
    /*
    PUT  " " skip(2)
        "Data Emiss∆o  Pedido    Cliente    Nome             VL.Mercadoria   VL.Comiss∆o   VL.Serviáo"        
    SKIP.   
    */
    FOR EACH tt-nf:
             DISP tt-nf.dt-emis-nota COLUMN-LABEL "Data Emiss∆o"
                  tt-nf.nr-pedcli COLUMN-LABEL "Pedido"
                  tt-nf.cod-emitente COLUMN-LABEL "Cod. emitente" 
                  tt-nf.nome-abrev COLUMN-LABEL "Nome"
                  tt-nf.vl-mercad COLUMN-LABEL "Vl. Mercadoria"
                  tt-nf.vl-comis-distrib COLUMN-LABEL "Vl. Comiss∆o"
                  tt-nf.vl-serv-inst COLUMN-LABEL "Vl. Serviáo" WITH WIDTH 255 STREAM-IO.
    END.
END PROCEDURE.

