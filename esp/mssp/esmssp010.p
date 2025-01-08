/*****************************************************************************
** Programa: esp/mssp/esmssp010.p
** Vers∆o..: 1.00
** Data....: 15/03/2012
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Zoom de Acondicionamento (zoom.p - Procedure: zoomAcondicionamento)
*****************************************************************************/

CREATE WIDGET-POOL.


/*--- Definiá∆o das Vari†veis ---*/
DEFINE TEMP-TABLE tt-acond NO-UNDO
    FIELD sequencia AS INTEGER
    FIELD descricao AS CHARACTER
    INDEX nm descricao.



/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE OUTPUT PARAMETER TABLE FOR tt-acond.



/*--- Bloco Principal ---*/
EMPTY TEMP-TABLE tt-acond.

FOR EACH  c-tab-res FIELDS(c-tab-res.sequencia c-tab-res.descricao c-tab-res.nr-tabela) NO-LOCK
    WHERE c-tab-res.nr-tabela = 4 /* Acondicionamento */
    /*WHERE c-tab-res.nr-tabela <> 100
    AND   c-tab-res.nr-tabela <> 300
    AND   c-tab-res.nr-tabela <> 400*/
    BY    c-tab-res.descricao:
    CREATE tt-acond.
    BUFFER-COPY c-tab-res USING c-tab-res.sequencia c-tab-res.descricao c-tab-res.nr-tabela
             TO tt-acond.
END.


DELETE WIDGET-POOL.
RETURN "OK":U.
