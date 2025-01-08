/*****************************************************************************
** Programa: esp/mssp/esmssp016.p
** VersÆo..: 1.00
** Data....: 30/05/2012
** Autor...: Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
** Obs.....: Zoom de Unidade de Medida (Procedure: zoomUnMedida)
*****************************************************************************/

CREATE WIDGET-POOL.

/*--- Defini‡Æo das Vari veis ---*/
DEFINE TEMP-TABLE tt-tab-unidade NO-UNDO
    FIELD un        LIKE tab-unidade.un
    FIELD descricao LIKE tab-unidade.descricao
    INDEX id un.

/*--- Defini‡Æo dos Parƒmetros ---*/
DEFINE OUTPUT PARAMETER TABLE FOR tt-tab-unidade.

/*--- Bloco Principal ---*/
EMPTY TEMP-TABLE tt-tab-unidade.

FOR EACH tab-unidade FIELDS(un descricao) NO-LOCK:
    CREATE tt-tab-unidade.
    ASSIGN tt-tab-unidade.un        = tab-unidade.un
           tt-tab-unidade.descricao = tab-unidade.descricao.
END.

DELETE WIDGET-POOL.

RETURN "OK":U.

