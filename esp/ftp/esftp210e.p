DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD i-sequen AS INT             
    FIELD cd-erro  AS INT
    field mensagem AS CHAR FORMAT "x(255)".

DEFINE TEMP-TABLE tt-int-simula-dev-it NO-UNDO LIKE int-simula-dev-it
       FIELD dt-emis-nota   LIKE nota-fiscal.dt-emis-nota
       FIELD dt-producao    LIKE num-serie-rast.data
       FIELD dt-primeira-nf LIKE nota-fiscal.dt-emis-nota.

DEFINE INPUT PARAM p-row-int-simula-dev AS ROWID.
DEFINE INPUT PARAM p-it-codigo AS CHAR.
DEFINE INPUT PARAM p-qtd-devol AS DEC FORMAT ">>>,>>>,>>9.99".
DEFINE OUTPUT PARAM TABLE FOR tt-int-simula-dev-it.
DEFINE OUTPUT PARAM TABLE FOR tt-erro.

DEFINE VARIABLE de-saldo-it       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE qt-acum           AS DECIMAL     NO-UNDO.
DEFINE VARIABLE h-acomp           AS HANDLE      NO-UNDO.
DEFINE VARIABLE qtde-comprometida AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-seq-item        AS INTEGER     NO-UNDO.

DEFINE BUFFER b-int-simula-dev-it FOR int-simula-dev-it.

IF p-qtd-devol <= 0 THEN DO:
    RUN pi-erro (INPUT "Quantidade a devolver deve ser maior que 0.").
    RETURN "NOK".
END.

IF NOT CAN-FIND (FIRST ITEM
                 WHERE ITEM.it-codigo = p-it-codigo) THEN DO:

    RUN pi-erro (INPUT "NÆo encontrado item com o c¢digo informado.").
    RETURN "NOK".
END.

FIND FIRST int-simula-dev NO-LOCK
     WHERE ROWID(int-simula-dev) = p-row-int-simula-dev NO-ERROR.

FIND LAST int-simula-dev-it NO-LOCK
    WHERE int-simula-dev-it.cod-emitente = int-simula-dev.cod-emitente
      AND int-simula-dev-it.dt-simula    = int-simula-dev.dt-simula
      AND int-simula-dev-it.nr-sequencia = int-simula-dev.nr-sequencia NO-ERROR.

IF AVAIL int-simula-dev-it THEN
    ASSIGN i-seq-item = int-simula-dev-it.nr-seq-it + 1.

RUN utp/ut-acomp.p PERSISTEN set h-acomp.
RUN pi-inicializar IN h-acomp (input "Buscando Notas").

FOR EACH it-nota-fisc USE-INDEX ch-item-nota NO-LOCK
   WHERE it-nota-fisc.it-codigo = p-it-codigo,
   FIRST nota-fiscal OF it-nota-fisc 
   WHERE nota-fiscal.cod-emit   = int-simula-dev.cod-emit
     //AND nota-fiscal.cod-estabel = int-simula-dev.cod-estabel
     AND nota-fiscal.dt-cancela = ? 
     AND nota-fiscal.dt-entr-cli <> ?
      BY nota-fiscal.dt-emis-nota DESC
      BY it-nota-fisc.nr-seq-fat:

    IF int-simula-dev.cod-estabel <> "" AND nota-fiscal.cod-estabel <> int-simula-dev.cod-estabel THEN
       NEXT.

    RUN pi-acompanhar IN h-acomp (INPUT "Emitente:" + STRING(nota-fiscal.cod-emit) + " " + "Data: " + STRING(nota-fiscal.dt-emis-nota)).

    IF  nota-fiscal.emite-dup = YES 
    AND int-simula-dev.id-tipo-nota = 2 THEN 
        NEXT.

    IF  nota-fiscal.emite-dup = NO
    AND int-simula-dev.id-tipo-nota = 1 THEN 
        NEXT.

    ASSIGN de-saldo-it = it-nota-fisc.qt-faturada[1].

    FOR EACH devol-cli
       WHERE devol-cli.cod-estabel = it-nota-fisc.cod-estabel  
         AND devol-cli.serie       = it-nota-fisc.serie  
         AND devol-cli.nr-nota-fis = it-nota-fisc.nr-nota-fis  
         AND devol-cli.it-codigo   = it-nota-fisc.it-codigo
         AND devol-cli.nr-seq      = it-nota-fisc.nr-seq-fat NO-LOCK:
       ASSIGN de-saldo-it = de-saldo-it - devol-cli.qt-devol.    
    END.

    ASSIGN qtde-comprometida = 0.    
    
    FOR EACH b-int-simula-dev-it
       WHERE b-int-simula-dev-it.cod-estabel-origem = it-nota-fisc.cod-estabel 
         AND b-int-simula-dev-it.serie-origem = it-nota-fisc.serie  
         AND b-int-simula-dev-it.nr-nota-origem = it-nota-fisc.nr-nota-fis  
         AND b-int-simula-dev-it.it-codigo = it-nota-fisc.it-codigo:

        ASSIGN qtde-comprometida = qtde-comprometida + b-int-simula-dev-it.qt-devolvida.
    END.

    ASSIGN de-saldo-it = de-saldo-it - qtde-comprometida.

    IF de-saldo-it <= 0 THEN
        NEXT.
    
    CREATE tt-int-simula-dev-it.
    ASSIGN tt-int-simula-dev-it.cod-emitente        = int-simula-dev.cod-emitente
           tt-int-simula-dev-it.dt-simula           = int-simula-dev.dt-simula
           tt-int-simula-dev-it.it-codigo           = p-it-codigo
           tt-int-simula-dev-it.nr-seq-it           = i-seq-item
           tt-int-simula-dev-it.nr-sequencia        = int-simula-dev.nr-sequencia
           tt-int-simula-dev-it.observacao          = nota-fiscal.observ-nota
           tt-int-simula-dev-it.qt-devolvida        = IF qt-acum + de-saldo-it >= p-qtd-devol THEN p-qtd-devol - qt-acum ELSE de-saldo-it
           tt-int-simula-dev-it.vl-cofins           = (it-nota-fisc.vl-finsocial * tt-int-simula-dev-it.qt-devolvida) / it-nota-fisc.qt-faturada[1]
           tt-int-simula-dev-it.vl-icms             = (it-nota-fisc.vl-icms-it   * tt-int-simula-dev-it.qt-devolvida) / it-nota-fisc.qt-faturada[1]
           tt-int-simula-dev-it.vl-icmsdifal        = 0 /*(it-nota-fisc.vl-finsocial * tt-int-simula-dev-it.qt-devolvida) / it-nota-fisc.qt-faturada[1]*/
           //tt-int-simula-dev-it.vl-icmsst           = (it-nota-fisc.vl-icmsub-it * tt-int-simula-dev-it.qt-devolvida) / it-nota-fisc.qt-faturada[1]
           tt-int-simula-dev-it.vl-icmsst           = (it-nota-fisc.vl-icmsub-it / it-nota-fisc.qt-faturada[1])
           tt-int-simula-dev-it.vl-ipi              = (it-nota-fisc.vl-ipi-it * tt-int-simula-dev-it.qt-devolvida) / it-nota-fisc.qt-faturada[1]
           tt-int-simula-dev-it.vl-pis              = (it-nota-fisc.vl-pis * tt-int-simula-dev-it.qt-devolvida) / it-nota-fisc.qt-faturada[1]
           tt-int-simula-dev-it.vl-tot-it           = (it-nota-fisc.vl-tot-item / it-nota-fisc.qt-faturada[1]) * tt-int-simula-dev-it.qt-devolvida
           tt-int-simula-dev-it.vl-unitario         = it-nota-fisc.vl-preuni
           tt-int-simula-dev-it.nr-nota-origem      = nota-fiscal.nr-nota-fis
           tt-int-simula-dev-it.cod-estabel-origem  = nota-fiscal.cod-estabel
           tt-int-simula-dev-it.serie-origem        = nota-fiscal.serie
           tt-int-simula-dev-it.dt-emis-nota        = nota-fiscal.dt-emis-nota
           tt-int-simula-dev-it.vl-bsubs-it         = (it-nota-fisc.vl-bsubs-it / it-nota-fisc.qt-faturada[1]). 

    ASSIGN qt-acum = qt-acum + de-saldo-it
           i-seq-item = i-seq-item + 1.

    IF  p-qtd-devol <= qt-acum THEN 
        LEAVE. 

END.

RUN pi-finalizar IN h-acomp.

IF p-qtd-devol > qt-acum THEN DO:
    //RUN pi-erro (INPUT "NÆo encontrado item com o c¢digo informado.").
    RUN pi-erro (INPUT "Quantia encontrada nas notas: " + string(qt-acum)).
    RETURN "NOK".
END.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.
