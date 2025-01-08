/***********************************************************************
**  Programa..: ESP\REP\ESREP042RP.P
**  Autor.....: Nicolas Martinez
**  Data......: Agosto/2019 - Desenvolvimento
**  Descricao.: Relatorio de Titulos NF recebidas no colabora‡Æo RE0708
**  VersÆo....: 001 27/08/2019
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESREP042 2.06.00.000}

/****************************  Definitions  ****************************/
{esp/rep/esrep042tt.i}
{esp/es0043.i}

{utp/ut-glob.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
DEF VAR c-arquivo-csv AS CHAR NO-UNDO.

/****************************  Frames       ****************************/

DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

DEF var h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relat¢rio NF Recebidas Totvs Colabora‡Æo"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESREP042"
       c-versao       = "2.06"
       c-revisao      = "001".

ASSIGN c-arquivo-csv = c-dir-arquivo-session + string(tt-param.usuario) + "/ESREP042.csv".

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i}

    RUN utp/ut-acomp.p persistent set h-acomp.  

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    
    OUTPUT TO VALUE(c-arquivo-csv).

    RUN piMontaRelat.

    OUTPUT CLOSE.

    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.

PROCEDURE piMontaRelat:
    RUN pi-inicializar in h-acomp (input "Imprimindo...").
    
    PUT UNFORMATTED "Estab;Cod Emitente;Nome;Serie;Nro Docto;CFOP;Dt Emis;Dt Trans;Chave Completa;Valor Total;Valor Tot Produto;Valor Frete;Valor IPI;Valor ICMS;Situacao;CNPJ;Inf Complementar" SKIP.

    FOR EACH doc-orig-nfe WHERE
             doc-orig-nfe.idi-orig-trad  = 2 /* Traduzida */
         AND doc-orig-nfe.dt-emissao    >= tt-param.data-ini
         AND doc-orig-nfe.dt-emissao    <= tt-param.data-fim
         AND doc-orig-nfe.cod-estabel   >= tt-param.cod-estabel-ini
         AND doc-orig-nfe.cod-estabel   <= tt-param.cod-estabel-fim
         AND doc-orig-nfe.cod-emitente  >= tt-param.cod-emitente-ini
         AND doc-orig-nfe.cod-emitente  <= tt-param.cod-emitente-fim
         AND doc-orig-nfe.cnpj          >= tt-param.c-cgc-ini
         AND doc-orig-nfe.cnpj          <= tt-param.c-cgc-fim
             NO-LOCK.

        IF tt-param.tg-filtra-sit = YES THEN
           IF doc-orig-nfe.idi-situacao <> tt-param.situacao THEN NEXT.

        RUN pi-acompanhar IN h-acomp (INPUT STRING(doc-orig-nfe.serie-docto) + "/" + STRING(doc-orig-nfe.nro-docto)).

        FIND FIRST item-doc-orig-nfe OF doc-orig-nfe NO-LOCK NO-ERROR.

        FIND FIRST emitente WHERE
                   emitente.cod-emitente = doc-orig-nfe.cod-emitente
                   NO-LOCK NO-ERROR.

        PUT UNFORMATTED doc-orig-nfe.cod-estabel  ";"
                        doc-orig-nfe.cod-emitente ";"
                        IF AVAIL emitente THEN emitente.nome-emit ELSE ""  ";"
                        doc-orig-nfe.serie-docto  ";"
                        doc-orig-nfe.nro-docto    ";"
                        IF AVAIL item-doc-orig-nfe THEN item-doc-orig-nfe.cod-cfop ELSE ""  ";"
                        doc-orig-nfe.dt-emissao   ";"
                        doc-orig-nfe.dt-transacao ";"
                        "'" + string(doc-orig-nfe.ch-acesso-comp-nfe) ";"
                        doc-orig-nfe.valor-total  ";"
                        doc-orig-nfe.valor-produto ";"
                        doc-orig-nfe.valor-frete ";"
                        doc-orig-nfe.valor-ipi   ";"
                        doc-orig-nfe.valor-icms ";"
                        {ininc/i01in847.i 04 doc-orig-nfe.idi-situacao} ";"
                        "'" + doc-orig-nfe.cnpj  ";"
                        doc-orig-nfe.inf-complement 
                        SKIP.

    END.
END.

