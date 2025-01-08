{include/i-prgvrs.i ESIMP003 2.04.00.002}
/*****************************************************************************
**     Programa.........: esp/imp/esimp003rp.p
**     Descricao .......: 
**     Versao...........: 1.00.000
**     Autor............: Clayton Antunes
**     Criado...........: 01/11/2006
*******************************************************************************/

/****************************  Definitions  ****************************/
{esp/imp/esimp003tt.i}
{include/i-rpvar.i}
{cdp/cd0666.i}

/****************************  Temp-Tables  ****************************/

/****************************  Variaveis    ****************************/
DEF VAR dt-data AS DATE.


/****************************  Frames       ****************************/

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.

RAW-TRANSFER raw-param TO tt-param.

DEF VAR h-acomp AS HANDLE NO-UNDO.
/*
FIND FIRST empresa NO-LOCK WHERE
           empresa.ep-codigo = tt-param.ep-codigo NO-ERROR.
*/           

/*
ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = 
       c-empresa      = 
       c-programa     = 
       c-versao       = "2.04"
       c-revisao      = "001".
*/


/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:

    {include/i-rpcab.i}
    {include/i-rpout.i}

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    find first param-global no-lock no-error.
    find mgcad.empresa where
         empresa.ep-codigo = param-global.empresa-prin no-lock no-error.
    if not avail empresa then return.

    RUN utp/ut-acomp.p persistent set h-acomp.  
    RUN pi-inicializar in h-acomp (input "Montando Relat¢rio...").
    RUN pi-relat.
    RUN pi-inicializar in h-acomp (input "Imprimindo...").
    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.
/* fim do programa */




PROCEDURE pi-relat:    
    /*
    MESSAGE "numero pag ini: " tt-param.pag-ini
            "numero pag fim: " tt-param.pag-fim
            "linha: " tt-param.linha
            "ncm: "  tt-param.ncm 
            "comissao: " tt-param.comissao
            "ref: "  tt-param.RefBancaria
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    */      
     
    FOR EACH pagamento NO-LOCK                           WHERE
             pagamento.nr-pagamento >= tt-param.pag-ini  AND
             pagamento.nr-pagamento <= tt-param.pag-fim:
        FIND moeda WHERE
             moeda.mo-codigo = pagamento.cod-moeda NO-LOCK NO-ERROR.
        FIND emitente WHERE
             emitente.cod-emitente = pagamento.cod-emitente NO-LOCK NO-ERROR.
        FIND mgcad.banco WHERE
             banco.cod-banco = pagamento.cod-banco NO-LOCK NO-ERROR.
        FIND banco-emit WHERE
             banco-emit.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.        
        
        RUN pi-imprimir.
    END.
    /*
    FIND pagamento WHERE 
         RECID(pagamento) = r-reg NO-LOCK NO-ERROR.
    IF AVAIL pagamento THEN 
       ASSIGN c-modalidade = pagamento.modalidade.
    */

    /* HIDE MESSAGE NO-PAUSE.*/
    return "ok":U.
END PROCEDURE.



PROCEDURE pi-imprimir:
    PUT "DE: Departamento de Compras / Importacao" 
        "CI " AT 100 pagamento.nr-pagamento skip
        "DI: " pagamento.nr-di SKIP(1).

    PUT "Para: ". 
    IF AVAIL mgcad.banco THEN
       PUT mgcad.banco.nome-banco.

    PUT "Vencimento: " AT 90 pagamento.dt-prev-fecha-cam.

    PUT SKIP.

    PUT "C/C: Tesouraria "             SKIP(1)
        "Linha: " tt-param.linha                              SKIP(1)
        "              PLANILHA DE FECHAMENTO DE IMPORTACAO " SKIP(1).

    PUT "Empresa:       " mgcad.empresa.nome SKIP
        "C.N.P.J:       " empresa.cgc SKIP(1).
       
    if param-global.empresa-prin = "1" then /* Intelbras */
        put "C/C    : " IF AVAIL banco AND banco.cod-banco = 399 THEN 
                       "08594-45 Agencia: 1052 " 
                    ELSE 
                       IF AVAIL banco AND banco.cod-banco = 341 THEN
                          "0555-6   Agencia: 1570" 
                       ELSE "" FORMAT "x(30)".
    else if param-global.empresa-prin = "2" then /* Nova*/
        put "C/C    : " IF AVAIL banco AND banco.cod-banco = 341 THEN
                          "23872-0   Agencia: 6663" 
                       ELSE "" FORMAT "x(30)".
    
    PUT SKIP(1) 
        "Unid.Neg: " pagamento.cod-unid-neg                          SKIP(1)
        "Moeda: " moeda.descricao  "Valor: " AT 30 pagamento.valor-pag FORMAT ">>>,>>>,>>9.99" SKIP(1)
        "Valor Moeda Nacional: "                                     SKIP(1)
        "Natureza de Operacao: "  pagamento.tipo-contr-cambio        SKIP(1)
        "NCM-LI: " tt-param.ncm                                      SKIP(1)
        "Referencia Cobranca Bancaria: " tt-param.RefBancaria        SKIP(1).


    FIND FIRST cond-pagto NO-LOCK
     WHERE cond-pagto.cod-cond-pag = pagamento.cod-cond-pag NO-ERROR.

    IF pagamento.cod-cond-pag = 0 OR NOT AVAIL cond-pagto THEN
        PUT "Modalidade: " pagamento.modalidade SKIP(1).
    ELSE 
        PUT "Condi‡Æo Pagamento: " pagamento.cod-cond-pag " - " cond-pagto.descricao SKIP(1).


    PUT "Recebedor no Exterior: " emitente.cod-emitente " - " emitente.nome-emit SKIP(1)
        "Cidade: " emitente.cidade                                   SKIP(1)
        "Pais: " emitente.pais                                       SKIP(1).

    if avail banco-emit then
        put "Banco Recebedor: " banco-emit.banco[1] + "   C/C " + banco-emit.conta[1] + "   ABA: " + banco-emit.aba[1] + "   Swift: " + banco-emit.swift[1] format "x(120)" skip(1)
            "Endereco: " banco-emit.endereco-1[1] format "x(80)"         SKIP
                         banco-emit.endereco-2[1] format "x(80)"         SKIP
                         banco-emit.endereco-3[1] format "x(80)"         SKIP
                         banco-emit.endereco-4[1] format "x(80)"         SKIP(1) 
            "Banco Intermediario: " banco-emit.banco[2] + "   C/C " + banco-emit.conta[2] + "   ABA: " + banco-emit.aba[2] + "   Swift: " + banco-emit.swift[2] format "x(120)" skip(1)
            "Endereco: " banco-emit.endereco-1[2] format "x(80)"         SKIP
                         banco-emit.endereco-2[2] format "x(80)"         SKIP
                         banco-emit.endereco-3[2] format "x(80)"         SKIP
                         banco-emit.endereco-4[2] format "x(80)"         SKIP.        
    else
        put "Banco Recebedor: "     FORMAT "x(80)"                SKIP(1)
            "Banco Intermediario: " FORMAT "x(80)"                SKIP(1)
            "Endereco: "            format "x(80)"                SKIP.
            


    PUT "Hist¢rico: " pagamento.historico[1] SKIP(1).

    PUT "Comissao de Agente: " tt-param.comissao SKIP(1)
        "Invoices:" SKIP.
        
    for each estabelec
       where estabelec.ep-codigo = param-global.empresa-prin no-lock:
        FOR EACH pagamento-invoice NO-LOCK 
           WHERE pagamento-invoice.nr-pagamento = pagamento.nr-pag,
            EACH invoice-emb-imp NO-LOCK 
           WHERE invoice-emb-imp.cod-estabel = estabelec.cod-estabel
             AND invoice-emb-imp.embarque    = pagamento-invoice.embarque      
             AND invoice-emb-imp.nr-invoice  = pagamento-invoice.nr-invoice  
             AND invoice-emb-imp.parcela     = pagamento-invoice.parcela:
                 
            FIND embarque-imp WHERE
                 embarque-imp.cod-estabel = estabelec.cod-estabel AND
                 embarque-imp.embarque = invoice-emb-imp.embarque NO-LOCK no-error.
            if not avail embarque-imp then next.
            
            FIND FIRST historico-embarque 
                 WHERE historico-embarque.cod-estabel = estabelec.cod-estabel
                   AND historico-embarque.embarque = embarque-imp.embarque NO-LOCK no-error.
            if not avail historico-embarque then next.
            
            FIND itinerario WHERE
                 itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK no-error.
            if not avail itinerario then next.
                 
            FIND FIRST historico-embarque NO-LOCK 
                 WHERE historico-embarque.cod-estabel = estabelec.cod-estabel
                   AND historico-embarque.embarque      = embarque-imp.embarque
                   AND historico-embarque.cod-pto-contr = itinerario.pto-embarque no-error.
            if not avail historico-embarque then next.
    
            PUT  invoice-emb-imp.nr-invoice " "
                 invoice-emb-imp.dt-vencim  " "
                 invoice-emb-imp.vl-invoice " - Embarque:" 
                 embarque-imp.embarque " - "
                 embarque-imp.cod-conhecto-master " - "
                 IF historico-embarque.dt-efetiva = ? THEN 
                    historico-embarque.dt-ult-prev
                 ELSE 
                    historico-embarque.dt-efetiva
                 SKIP.
        END.
    end.
    
    PUT SKIP(1)
    "Outras Informacoes: Em caso de cobranca bancaria, solicitamo-lhes o envio dos " SKIP
           "                    documentos originais, ENDOSSADOS, o mais breve possivel." SKIP(1)
    "Operacao isenta de IOF conforme Decreto Lei 2434 de 19/05/88" .

    PAGE.

END PROCEDURE.
