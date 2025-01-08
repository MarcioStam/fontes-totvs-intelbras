/*------------------------------------------------------------------------
    File        : DDI037.P
    Purpose     : UPC de Delete da tabela "doc-fiscal".

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Abril de 2013
    Notes       : 001 - 19/04/2013 - Implementa‡Æo da chamada … UPC de
                  Delete "trigger/upc-doc-fiscal-d.p" desenvolvida
                  pela Gati (Fabiano Sakae Ribeiro - Exponencial TI).
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameter Definitions ---                                            */

DEFINE PARAM BUFFER b-doc-fiscal FOR doc-fiscal.


/* ***************************  Main Block  *************************** */

/* Chamada UPC de Delete da Gati */
IF  SEARCH("trigger/upc-doc-fiscal-d.p") <> ? OR
    SEARCH("trigger/upc-doc-fiscal-d.r") <> ?
THEN
    RUN trigger/upc-doc-fiscal-d.p (BUFFER b-doc-fiscal).

RETURN "OK":U.

