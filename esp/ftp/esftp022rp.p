{include/i-prgvrs.i ESFTP022 2.04.00.001}
/***********************************************************************
**  Programa..: ESP\FTP\ESFTP022RP.P
**  Autor.....: Pedro Faraco - Intelbras
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: Relatorio de Notas Fiscais sem Sa¡da
**              Adaptado do programa ESFTP002RP.P
**  VersÆo....: 001 27/06/2005
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp\ftp\esftp022tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}
/****************************  Temp-Tables  ****************************/

DEF TEMP-TABLE tt-resumo
    FIELD dt-emis-nota LIKE nota-fiscal.dt-emis-nota column-label "Dt EmissÆo"
    FIELD nr-nota-fis  LIKE nota-fiscal.nr-nota-fis  column-label "N£mero"
    FIELD serie        LIKE nota-fiscal.serie        column-label "S"
    FIELD nat-operacao LIKE nota-fiscal.nat-operacao column-label "NatOp."
    FIELD cod-emitente LIKE emitente.cod-emitente    column-label "Cliente"
    FIELD nome-emit    LIKE emitente.nome-emit       column-label "Nome do Cliente"
    FIELD vl-tot-nota  LIKE nota-fiscal.vl-tot-nota  column-label "Valor Total"
    FIELD dt-saida     LIKE nota-fiscal.dt-saida     column-label "Dt Sa¡da".


/****************************  Variaveis    ****************************/
DEF VAR natoper AS CHAR INITIAL "5101,5118,5102,5119,5111,5113,5551,5922,5933,6101,6107,6109,6118,6122,6102,6108,6110,6119,6113,6551,6922,6933,7101,7102,7551".
DEFINE VARIABLE valTotal AS DECIMAL FORMAT '->>,>>>,>>9.99'   NO-UNDO.

/****************************  Frames       ****************************/

FORM tt-resumo.dt-emis-nota
     tt-resumo.nr-nota-fis FORMAT "X(7)"
     tt-resumo.serie FORMAT "X(1)"
     tt-resumo.nat-operacao
     tt-resumo.cod-emitente
     tt-resumo.nome-emit
     tt-resumo.vl-tot-nota
     /*tt-resumo.dt-saida*/
     WITH WIDTH 150 NO-ATTR-SPACE FRAME f-corpo STREAM-IO DOWN.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relatorio de Notas Fiscais Sem Sa¡da"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESFTP022"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}

    run utp/ut-acomp.p persistent set h-acomp.  

    RUN pi-inicializar in h-acomp (input "Imprimindo...").

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    RUN pi-inicializar in h-acomp (input "Montando Relat¢rio...").
    RUN piMontaRelat.

    RUN pi-inicializar in h-acomp (input "Imprimindo...").
    RUN piImprimeRelatRes.

    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */
PROCEDURE piMontaRelat:

    FOR EACH nota-fiscal NO-LOCK WHERE nota-fiscal.dt-emis-nota >= tt-param.DtEmissaoIni AND
                                       nota-fiscal.dt-emis-nota <= tt-param.DtEmissaoFim AND
                                       nota-fiscal.estado >= tt-param.EstadoIni AND
                                       nota-fiscal.estado <= tt-param.EstadoFim AND
                                       nota-fiscal.dt-saida = ? AND
                                       nota-fiscal.dt-cancela = ?,
                                 first natur-oper no-lock
                                 where natur-oper.nat-operacao = nota-fiscal.nat-operacao
                                   and natur-oper.tipo = 2,
                                 FIRST emitente NO-LOCK WHERE emitente.cod-emitente = nota-fiscal.cod-emitente:
        IF INDEX(natoper, substring(nota-fiscal.nat-operacao, 1, 4)) = 0 THEN 
            NEXT.

        CREATE tt-resumo.
        ASSIGN tt-resumo.dt-emis-nota = nota-fiscal.dt-emis-nota
               tt-resumo.nr-nota-fis  = nota-fiscal.nr-nota-fis
               tt-resumo.serie        = nota-fiscal.serie
               tt-resumo.nat-operacao = nota-fiscal.nat-operacao
               tt-resumo.cod-emitente = emitente.cod-emitente
               tt-resumo.nome-emit    = emitente.nome-emit
               tt-resumo.vl-tot-nota  = nota-fiscal.vl-tot-nota
               tt-resumo.dt-saida     = nota-fiscal.dt-saida.

        valtotal = valtotal + nota-fiscal.vl-tot-nota.
    END.

END PROCEDURE.

PROCEDURE piImprimeRelatRes:

    FOR EACH tt-resumo:
        DISPLAY dt-emis-nota
                nr-nota-fis
                serie
                nat-operacao
                cod-emitente
                nome-emit
                vl-tot-nota
                /*dt-saida*/ WITH FRAME f-corpo.
        DOWN WITH FRAME f-corpo.
    END.
    
    DISPLAY "-----------------" @ vl-tot-nota WITH FRAME f-corpo.

    DOWN WITH FRAME f-corpo.

    DISPLAY "                                   TOTAL" @ nome-emit
            valtotal @ vl-tot-nota WITH FRAME f-corpo.


END PROCEDURE.


