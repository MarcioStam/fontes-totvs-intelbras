DEF TEMP-TABLE ttcomponente
    FIELD seq AS INT
    FIELD componente AS CHAR
    INDEX sequencia seq.

{esp/es0018.i}

/* Parametros */
DEFINE  INPUT  PARAMETER p-cdb          AS CHARACTER NO-UNDO.
DEFINE  OUTPUT PARAMETER p-corporativo  AS LOGICAL   NO-UNDO. /* item corporativo? */
DEFINE  OUTPUT PARAMETER p-serie        AS CHARACTER NO-UNDO.
DEFINE  OUTPUT PARAMETER p-nr-nota-fis  AS CHARACTER NO-UNDO.
DEFINE  OUTPUT PARAMETER p-dt-emis-nota AS DATE      NO-UNDO.
DEFINE  OUTPUT PARAMETER p-nome-emit    AS CHARACTER NO-UNDO.
DEFINE  OUTPUT PARAMETER p-it-codigo    AS CHARACTER NO-UNDO.
DEFINE  OUTPUT PARAMETER p-desc-item    AS CHARACTER NO-UNDO.
DEFINE  OUTPUT PARAMETER p-nr-ord-prod  AS INT       NO-UNDO.
DEFINE  OUTPUT PARAMETER p-sigla        AS CHAR      NO-UNDO.
DEFINE  OUTPUT PARAMETER p-desc-sigla   AS CHAR      NO-UNDO.
DEFINE  OUTPUT PARAMETER p-data-fabric  AS DATETIME  NO-UNDO.
DEFINE  OUTPUT PARAMETER TABLE FOR ttcomponente.


/* variaveis */
DEFINE VARIABLE i                AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-sigla          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-data           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-numero         AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-item           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-item-intelbras AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-achou-nf       AS LOGICAL     NO-UNDO.


FOR EACH ttcomponente:
    DELETE ttcomponente.
END.

ASSIGN l-item-intelbras = NO.

FOR FIRST num-serie NO-LOCK
    WHERE num-serie.n-serie = p-cdb:

    ASSIGN c-item = num-serie.it-codigo.

END.

IF NOT AVAIL num-serie THEN DO:

    ASSIGN p-corporativo  = ?
           p-serie        = ?
           p-nr-nota-fis  = ?
           p-dt-emis-nota = ?
           p-nome-emit    = ?
           p-it-codigo    = ?
           p-desc-item    = ?
           p-nr-ord-prod  = ?
           p-sigla        = ?
           p-desc-sigla   = ?.

    LEAVE.

END.

/**/

FIND FIRST item WHERE item.it-codigo = c-item NO-LOCK NO-ERROR.

/* Item */
ASSIGN p-it-codigo   = c-item
       p-desc-item   = item.desc-item
       p-nr-ord-prod = 0.

/**/

IF substring(num-serie.char-1,1,5) = "icomp" THEN DO:

    /* Componentes do item */
    FIND FIRST item-ean WHERE item-ean.it-codigo = c-item NO-LOCK NO-ERROR.
    IF AVAIL item-ean THEN DO:
        DO i = 1 TO 15:
            IF item-ean.texto[i] <> "" THEN DO: 
                CREATE ttcomponente.
                ASSIGN ttcomponente.seq        = i
                       ttcomponente.componente = item-ean.texto[i].
            END. 
        END.
    END.

END.


/**/


ASSIGN p-sigla       = num-serie.sigla
       p-data-fabric = num-serie.data.

FOR FIRST ns-sigla NO-LOCK
    WHERE ns-sigla.sigla = num-serie.sigla:

    ASSIGN p-desc-sigla = ns-sigla.descricao.

END.


/**/


ASSIGN l-achou-nf = FALSE.

FOR LAST num-serie-rast NO-LOCK USE-INDEX sdata
    WHERE num-serie-rast.n-serie = num-serie.n-serie
    BY num-serie-rast.data:

    FOR FIRST nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel = num-serie-rast.cod-estabel
        AND   nota-fiscal.serie       = num-serie-rast.serie
        AND   nota-fiscal.nr-nota-fis = num-serie-rast.nr-nota-fis:

        ASSIGN l-achou-nf = TRUE.

        FIND FIRST emitente 
            WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.

        ASSIGN p-serie        = nota-fiscal.serie
               p-nr-nota-fis  = nota-fiscal.nr-nota-fis
               p-dt-emis-nota = nota-fiscal.dt-emis-nota
               p-nome-emit    = IF AVAIL emitente THEN emitente.nome-emit ELSE "".

    END.

END.


IF NOT l-achou-nf THEN DO:

    /* NF Sa¡da */
    FIND FIRST ns-volume NO-LOCK
        WHERE  ns-volume.volume-filho = num-serie.n-serie NO-ERROR.

    IF  AVAIL  ns-volume THEN DO:

        FIND FIRST nota-fiscal NO-LOCK
            WHERE  nota-fiscal.cod-estabel = ns-volume.cod-estabel
            AND    nota-fiscal.serie       = ns-volume.serie
            AND    nota-fiscal.nr-nota-fis = ns-volume.nr-nota-fis NO-ERROR.

        IF AVAIL nota-fiscal THEN DO:

            ASSIGN l-achou-nf = TRUE.

            FIND FIRST emitente 
                WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.

            ASSIGN p-serie        = nota-fiscal.serie
                   p-nr-nota-fis  = nota-fiscal.nr-nota-fis
                   p-dt-emis-nota = nota-fiscal.dt-emis-nota
                   p-nome-emit    = IF AVAIL emitente THEN emitente.nome-emit ELSE "".
        END.
    END.
    ELSE DO:
        /* Corporativo? */
        FIND FIRST int-item OF item NO-LOCK NO-ERROR.
        IF AVAIL int-item THEN
            ASSIGN p-corporativo = int-item.corporativo.
    END.

END.
    

IF NOT l-achou-nf THEN DO:

    /* NF Sa¡da */
    FIND FIRST nf-cdb NO-LOCK
        WHERE nf-cdb.cod-estabel = num-serie.cod-estabel
        AND   nf-cdb.cdb         = num-serie.n-serie
        AND   nf-cdb.it-codigo   = num-serie.it-codigo NO-ERROR.

    IF AVAIL nf-cdb THEN DO:

        FIND FIRST nota-fiscal OF nf-cdb NO-LOCK NO-ERROR.

        IF AVAIL nota-fiscal THEN DO:

            ASSIGN l-achou-nf = TRUE.

            FIND FIRST emitente 
                WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.

            ASSIGN p-serie        = nota-fiscal.serie
                   p-nr-nota-fis  = nota-fiscal.nr-nota-fis
                   p-dt-emis-nota = nota-fiscal.dt-emis-nota
                   p-nome-emit    = IF AVAIL emitente THEN emitente.nome-emit ELSE "".
        
            /* Corporativo? */
            FIND FIRST it-nota-fisc NO-LOCK
                WHERE  it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
                AND    it-nota-fisc.serie       = nota-fiscal.serie 
                AND    it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
                AND    it-nota-fisc.it-codigo   = item.it-codigo NO-ERROR.

            IF  AVAIL  it-nota-fisc THEN DO:

                FIND FIRST ped-venda NO-LOCK
                    WHERE  ped-venda.nr-pedcli  = it-nota-fisc.nr-pedcli
                    AND    ped-venda.nome-abrev = it-nota-fisc.nome-ab-cli NO-ERROR.

                IF  AVAIL ped-venda THEN DO:

                    FIND FIRST int-ped-venda NO-LOCK
                        WHERE  int-ped-venda.cod-estabel = ped-venda.cod-estabel
                        AND    int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

                    IF  AVAIL  int-ped-venda THEN DO:
                        IF  SUBSTRING(int-ped-venda.char-1,10,1) = "S" THEN
                            ASSIGN p-corporativo = YES.
                        ELSE
                            ASSIGN p-corporativo = NO.
                    END.

                END.

            END.

        END.

    END.
    ELSE DO:
        /* Corporativo? */
        FIND FIRST int-item OF item NO-LOCK NO-ERROR.
        IF  AVAIL  int-item THEN
            ASSIGN p-corporativo = int-item.corporativo.
    END.

END.

