/*------------------------------------------------------------------------
    File        : DIN087.P
    Purpose     : UPC de Delete da tabela "despesa-aces".

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Abril de 2013
    Notes       : 001 - 19/04/2013 - Implementa‡Æo da chamada … UPC de
                  Delete "trigger/upc-despesa-aces-d.p" desenvolvida
                  pela Gati (Fabiano Sakae Ribeiro - Exponencial TI).
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameter Definitions ---                                            */

DEFINE PARAM BUFFER b-despesa-aces FOR despesa-aces.


/* ***************************  Main Block  *************************** */

/* Chamada UPC de Delete da Gati */
IF  SEARCH("trigger/upc-despesa-aces-d.p") <> ? OR
    SEARCH("trigger/upc-despesa-aces-d.r") <> ?
THEN
    RUN trigger/upc-despesa-aces-d.p (BUFFER b-despesa-aces).

RETURN "OK":U.

