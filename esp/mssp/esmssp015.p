/*****************************************************************************
** Programa: esp/mssp/esmssp015.p
** VersÆo..: 1.00
** Data....: 30/05/2012
** Autor...: Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
** Obs.....: Zoom de Fabricante (Procedure: zoomFabricante)
*****************************************************************************/

CREATE WIDGET-POOL.

/*--- Defini‡Æo das Vari veis ---*/
DEFINE TEMP-TABLE tt-fabricante NO-UNDO
    FIELD cod-fabric LIKE fabricante.cod-fabric
    FIELD nome       LIKE fabricante.nome
    INDEX id cod-fabric.

/*--- Defini‡Æo dos Parƒmetros ---*/
DEFINE OUTPUT PARAMETER TABLE FOR tt-fabricante.

/*--- Bloco Principal ---*/
EMPTY TEMP-TABLE tt-fabricante.

FOR EACH fabricante FIELDS(cod-fabric nome) NO-LOCK:
    CREATE tt-fabricante.
    ASSIGN tt-fabricante.cod-fabric = fabricante.cod-fabric
           tt-fabricante.nome       = fabricante.nome.
END.

DELETE WIDGET-POOL.

RETURN "OK":U.

