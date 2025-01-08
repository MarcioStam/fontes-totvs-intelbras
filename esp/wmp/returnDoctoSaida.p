/*******************************************************************************************/
/* Autor.........: Carlos da Costa Junior                                                  */
/*                                                                                         */
/* Data..........: 24/08/2021                                                              */
/*                                                                                         */
/* Objetivo......:                          */
/*******************************************************************************************/
using esp.wmp.ReturnDocto.

{esp/es0018.i}
{esp/wmp/returnDoctoSaida.i}
{METHOD/dbotterr.i}

DEF INPUT  PARAM pRowid      AS ROWID   NO-UNDO.
DEF INPUT  PARAM pNumVolumes AS INT     NO-UNDO.
DEF OUTPUT PARAM pErro      AS LOG      NO-UNDO.
DEF OUTPUT PARAM TABLE      FOR RowErrors.

def var oReturnDoctoSaida      as ReturnDocto.

DEF VAR h-acomp             AS HANDLE   NO-UNDO.
DEF VAR cToken              AS CHAR     NO-UNDO.
DEF VAR cArquivoXML         AS CHAR     NO-UNDO.
DEF VAR cChaveAcesso        AS CHAR     NO-UNDO.
DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-msg AS CHARACTER   NO-UNDO.

FIND FIRST wm-docto
    WHERE ROWID(wm-docto) = pRowid EXCLUSIVE-LOCK NO-ERROR.
IF AVAIL wm-docto THEN DO:

    RUN utp/ut-acomp.p persistent set h-acomp.
    RUN pi-inicializar in h-acomp (input "Retorno Protheus").
    RUN pi-acompanhar in h-acomp (input "Documento: " + wm-docto.num-docto).

    EMPTY TEMP-TABLE tt-docto-saida.
    EMPTY TEMP-TABLE tt-docto-saida-itens.
            
    RUN pi-acompanhar in h-acomp (input "Conectando WS... " + wm-docto.num-docto).
            
    CREATE tt-docto-saida.
    ASSIGN tt-docto-saida.numeroPedido  = wm-docto.num-docto
           tt-docto-saida.volume        = pNumVolumes
           tt-docto-saida.especie       = "NI" // Verificar
           tt-docto-saida.statusDocto   = "L".

    FOR EACH tt-prog-ponto:
        DELETE tt-prog-ponto.
    END.
    RUN esp/es0018p.p ( INPUT "wm-estab-api":U,
                        INPUT 1,
                        INPUT 0,
                        INPUT "":U,
                        OUTPUT TABLE tt-prog-ponto).
    FIND FIRST tt-prog-ponto 
         WHERE ENTRY(2,tt-prog-ponto.conteudo,";") = wm-docto.cod-estabel NO-ERROR.
    IF AVAIL tt-prog-ponto THEN DO:
            ASSIGN tt-docto-saida.filialPedido = string(ENTRY(1,tt-prog-ponto.conteudo,";")).
    END.

    FOR EACH wm-docto-itens OF wm-docto NO-LOCK:
        FIND FIRST wm-item NO-LOCK
             WHERE wm-item.cod-item = wm-docto-itens.cod-item NO-ERROR.
        IF AVAIL wm-item AND wm-item.log-2 = NO THEN DO:
            CREATE tt-docto-saida-itens.
            ASSIGN tt-docto-saida-itens.numeroItem    = string(wm-docto-itens.num-seq-item)
                   tt-docto-saida-itens.codigoProduto = wm-docto-itens.cod-item
                   tt-docto-saida-itens.quantidade    = wm-docto-itens.qtd-item
                   tt-docto-saida-itens.numeroSerie   = "".
        END.
        ELSE DO:
            FOR EACH es-wm-docto-it-serie NO-LOCK
               WHERE es-wm-docto-it-serie.cod-estabel  = wm-docto-itens.cod-estabel
                 AND es-wm-docto-it-serie.cod-local    = wm-docto-itens.cod-local
                 AND es-wm-docto-it-serie.id-docto     = wm-docto-itens.id-docto 
                 AND es-wm-docto-it-serie.num-seq-item = wm-docto-itens.num-seq-item:
                
                CREATE tt-docto-saida-itens.
                ASSIGN tt-docto-saida-itens.numeroItem    = string(es-wm-docto-it-serie.num-seq-item)
                       tt-docto-saida-itens.codigoProduto = es-wm-docto-it-serie.cod-item
                       tt-docto-saida-itens.quantidade    = es-wm-docto-it-serie.qtd-item
                       tt-docto-saida-itens.numeroSerie   = es-wm-docto-it-serie.num-serie.
            END.
        END.
    END.

    ASSIGN OVERLAY(wm-docto.char-2,21,26) = STRING(pNumVolumes).

    //Envia as informa‡äes para a Classe
    oReturnDoctoSaida = NEW ReturnDocto().
    oReturnDoctoSaida:returnDoctoSaida(INPUT  TABLE tt-docto-saida,
                                       INPUT  TABLE tt-docto-saida-itens,
                                       OUTPUT l-erro,
                                       OUTPUT c-msg) NO-ERROR.
    delete object oReturnDoctoSaida.
        
    RUN pi-acompanhar in h-acomp (input "Retorno WS... " + wm-docto.num-docto).
                
    ASSIGN pErro = l-erro.

    //Se voltar com erro grava o Log
    IF l-erro THEN DO:
        CREATE RowErrors.
        ASSIGN RowErrors.errorNumber      = 17006
               RowErrors.errorDescription = c-msg.

    END. 
    ELSE
        ASSIGN OVERLAY(wm-docto.char-2,1,20)  = string(TODAY,"99/99/9999") + " " + string(TIME,"HH:MM:SS")
               wm-docto.log-2                 = YES.
END.

RUN pi-finalizar IN h-acomp.

IF l-erro = YES THEN
    RETURN "NOK":U.

RETURN "OK":U.


