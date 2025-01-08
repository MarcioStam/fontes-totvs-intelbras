/*------------------------------------------------------------------------
    File        : ESMSSP028.P
    Purpose     : Busca Fam¡lia por Descri‡Æo
    Procedure   : buscaFamiliaCodParcial
    Syntax      : <none>
    Description : <none>

    Author(s)   : Maicon Roberto Correa (Sensus Tecnologia)
    Created     : Janeiro / 2015
    Notes       : <none>
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-familia NO-UNDO
    FIELD fm-codigo        LIKE familia.fm-codigo
    FIELD descricao        LIKE familia.descricao
    FIELD un               LIKE familia.un           
    FIELD contr-qualid     LIKE familia.contr-qualid 
    FIELD fraciona         LIKE familia.fraciona     
    FIELD criticidade      LIKE familia.criticidade  
    FIELD perc-nqa         LIKE familia.perc-nqa     
    FIELD class-fiscal     AS CHARACTER
    FIELD fluxo-sp         LIKE int-familia.fluxo-sp
    FIELD ex               LIKE int-familia.ex
    FIELD ge-codigo        LIKE int-familia.ge-codigo
    FIELD acond            LIKE int-familia.acond
    FIELD norma            LIKE int-familia.norma
    INDEX chPrimario IS UNIQUE PRIMARY
        fm-codigo.
    .
    
/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-query AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-where AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-sort  AS CHARACTER   NO-UNDO.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-fm-codigo     AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-familia.
DEFINE OUTPUT PARAMETER p-mensagem  AS CHARACTER   NO-UNDO.


/* ***************************  Main Block  *************************** */

EMPTY TEMP-TABLE tt-familia.


/*ASSIGN p-fm-codigo = "dispositivos oticos lentes maicon roberto correa".*/

ASSIGN p-fm-codigo = TRIM(p-fm-codigo).

FOR EACH familia NO-LOCK
    WHERE familia.fm-codigo BEGINS p-fm-codigo:

    IF INDEX("0123456789", substring(familia.fm-codigo, 1, 1)) = 0 THEN
        NEXT.

    CREATE tt-familia.
    ASSIGN tt-familia.fm-codigo     = familia.fm-codigo
           tt-familia.descricao     = familia.descricao
           tt-familia.un            = familia.un
           tt-familia.contr-qualid  = familia.contr-qualid
           tt-familia.fraciona      = familia.fraciona
           tt-familia.criticidade   = familia.criticidade
           tt-familia.perc-nqa      = familia.perc-nqa
           tt-familia.class-fiscal  = familia.class-fiscal.

    FOR FIRST int-familia NO-LOCK
        WHERE int-familia.fm-codigo = familia.fm-codigo:

        ASSIGN tt-familia.fluxo-sp   = int-familia.fluxo-sp  
               tt-familia.ex         = int-familia.ex        
               tt-familia.ge-codigo  = int-familia.ge-codigo 
               tt-familia.acond      = int-familia.acond     
               tt-familia.norma      = int-familia.norma.

    END.
         
END.

IF NOT CAN-FIND(FIRST tt-familia) THEN DO:

    ASSIGN p-mensagem = "Nenuma Fam¡lia encontrada!":U.

    RETURN "NOK":U.

END.

RETURN "OK":U.

