/***********************************************************************
**  Programa..: UPC/PD4000-UPCA.P
**  Autor.....: Robson Jeorge Moser - Gestech
**  Data......: DEZEMBRO/2004 - Desenvolvimento
**  Descricao.: Chama o "choose" padr∆o do bot∆o elimina do representante 
                e elimina o relacionamento do representante com as tabelas
                de extens∆o int-ped-repre e int-ped-venda (criadas para 
                armazenar informaá‰es para o c†lculo de comiss∆o).
**  Vers∆o....: 001 26/12/2004
**              Desenvolvimento Programa
************************************************************************/

DEF NEW GLOBAL SHARED VAR whbtDeleteRepresentative     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whbtDeleteRepresentative-new AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR whbtAddServInst     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whPedCli            AS WIDGET-HANDLE NO-UNDO.

DEF VAR i-nr-pedido               LIKE ped-repre.nr-pedido NO-UNDO.
DEF VAR c-nome-ab-rep             LIKE repres.nome-abrev no-undo.
/* DEF VAR v-cod-classificador-aux-1 LIKE ped-repre.cod-classificador. */
DEF VAR l-reppri                  AS LOGICAL NO-UNDO.


ASSIGN i-nr-pedido   = INT(whPedCli:SCREEN-VALUE)
       c-nome-ab-rep = whbtAddServInst:SCREEN-VALUE.

ASSIGN l-reppri = NO.
FIND FIRST ped-venda NO-LOCK                             WHERE
            ped-venda.nr-pedido = int(whPedCli:SCREEN-VALUE) NO-ERROR.

FIND FIRST int-ped-venda NO-LOCK WHERE
           int-ped-venda.nr-pedido = int(whPedCli:SCREEN-VALUE) and
           int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-ERROR.
IF AVAIL int-ped-venda THEN DO:
    IF AVAIL ped-venda THEN 
       IF ped-venda.no-ab-reppri = c-nome-ab-rep  THEN
          ASSIGN l-reppri = YES.
END.

APPLY "choose" TO whbtDeleteRepresentative.

IF RETURN-VALUE = "OK" AND l-reppri = NO THEN DO:

    /* L¢gica para eliminaá∆o do registro das tabelas int-ped-venda e int-ped-repre */
    /*
    FIND FIRST ped-repre NO-LOCK                     WHERE
               ped-repre.nr-pedido   = i-nr-pedido   AND
               ped-repre.nome-ab-rep = c-nome-ab-rep NO-ERROR.
    IF AVAIL ped-repre THEN
       ASSIGN v-cod-classificador-aux-1 = ped-repre.cod-classificador.
    */
    FIND ped-venda
         WHERE ped-venda.nr-pedido = i-nr-pedido NO-LOCK NO-ERROR.
    FIND FIRST int-ped-venda EXCLUSIVE-LOCK          WHERE
               int-ped-venda.nr-pedido = i-nr-pedido    AND
               int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-ERROR. 
    IF AVAIL int-ped-venda THEN DO:
        /*
        FIND FIRST int-ped-repre EXCLUSIVE-LOCK                                WHERE
                   int-ped-repre.nr-pedido         = int-ped-venda.nr-pedido   AND
                   int-ped-repre.nome-ab-rep       = c-nome-ab-rep             AND
                   int-ped-repre.cod-classificador = v-cod-classificador-aux-1 NO-ERROR.
        IF AVAIL int-ped-repre THEN 
            DELETE int-ped-repre.            
        IF NOT CAN-FIND(int-ped-repre                                      WHERE 
                        int-ped-repre.nr-pedido = int-ped-venda.nr-pedido) THEN 
        */                
            DELETE int-ped-venda.
    END.
END.
