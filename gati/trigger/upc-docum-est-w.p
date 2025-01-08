/***********************************************************************
**  Programa...: upc-docum-est-w
**  Autor......: Oliver Fagionato
**  Descricao..: Upc utilizada na Altera‡Æo da tabela docum-est
**  data.......: Outubro/2012
**  Atualizacao: 
************************************************************************/
{include/i-prgvrs.i UPC-DOCUM-EST-W 2.00.00.000}
/******************** DEFINICAO PARAMETROS ********************/
def parameter buffer b-docum-est     for docum-est.
def parameter buffer b-docum-est-old for docum-est.

FIND FIRST param-global NO-LOCK NO-ERROR.

/************************ DEFINICAO VARIAVEIS ************************/
{utp/ut-glob.i}
{gtp/gati0000.i}
{cdp/cdcfgmat.i}

&IF '{&pre-xml-webservice}' = "ativo" &THEN
    DEFINE VARIABLE hSAXWriter      AS HANDLE   NO-UNDO. 
    DEFINE VARIABLE c-xml           AS LONGCHAR NO-UNDO.
    DEFINE VARIABLE cType           AS CHARACTER   NO-UNDO.
&ENDIF

DEFINE VARIABLE c-arquivo AS CHARACTER FORMAT "x(100)" NO-UNDO.

IF b-docum-est-old.ce-atual <> b-docum-est.ce-atual THEN DO:
    FIND FIRST param-xml NO-LOCK WHERE
               &IF '{&pre-empresa}' = "jmalucelli" OR
                   '{&pre-empresa}' = "colorminas" &THEN
               &else
                    &IF "{&bf_mat_versao_ems}" >= "2.07" &THEN
                        &if '{&pre-empresa}' = "belliz" or
                            '{&pre-empresa}' = "guaiba" or
                            '{&pre-empresa}' = "constran" &then
                            param-xml.ep-codigo   =     param-global.empresa-prin         AND
                        &else
                            param-xml.ep-codigo   = int(param-global.empresa-prin)        AND
                        &endif
                    &ELSE
                        param-xml.ep-codigo   = int(param-global.empresa-prin)          AND
                    &ENDIF
               &endif
               param-xml.cod-estabel = b-docum-est.cod-estabel NO-ERROR.

    /* Chamado 416 - Alteracao para Solidus - Encontrar os parametros */
    &IF '{&pre-empresa}' = "solidus" &THEN
        IF NOT AVAIL param-xml THEN
            FIND LAST param-xml NO-LOCK WHERE
                            &IF  "{&bf_mat_versao_ems}"  >=  "2.07":U  &THEN
                                param-xml.ep-codigo   =     param-global.empresa-prin      NO-ERROR.
                            &ELSE
                                param-xml.ep-codigo   = int(param-global.empresa-prin)     NO-ERROR.
                            &ENDIF
    &ENDIF

    FIND FIRST natur-oper NO-LOCK WHERE
               natur-oper.nat-operacao = b-docum-est.nat-operacao NO-ERROR.

    &IF '{&pre-xml-webservice}' = "ativo" &THEN
        IF b-docum-est.ce-atual THEN
            ASSIGN cType = "200".
        ELSE
            ASSIGN cType = "201".

        CREATE SAX-WRITER hSAXWriter.

        hSAXWriter:FORMATTED = TRUE.

        hSAXWriter:SET-OUTPUT-DESTINATION("longchar ", c-xml).

        hSAXWriter:START-DOCUMENT().
            hSAXWriter:START-ELEMENT("recepcaoEntrada").
                    hSAXWriter:START-ELEMENT("entrada").
                        hSAXWriter:START-ELEMENT("notificacao").
                        hSAXWriter:INSERT-ATTRIBUTE("type", cType).
                            hSAXWriter:WRITE-DATA-ELEMENT("chNFe", &IF "{&bf_mat_versao_ems}" < "2.07" &THEN SUBSTRING(b-docum-est.char-1,93,60) &ELSE b-docum-est.cod-chave-aces-nf-eletro &ENDIF ).
                        hSAXWriter:END-ELEMENT("notificacao").
                    hSAXWriter:END-ELEMENT("entrada").
              hSAXWriter:END-ELEMENT("recepcaoEntrada").
        hSAXWriter:END-DOCUMENT().

        RUN gtp/gati0102k.p(INPUT c-xml,
                            INPUT param-xml.url-ws-saida).
    &ELSE
        &IF '{&pre-empresa}' <> "denso" &THEN
            ASSIGN c-arquivo = param-xml.arq-entrada-cce
                               + TRIM( &IF "{&bf_mat_versao_ems}" < "2.07" &THEN SUBSTRING(b-docum-est.char-1,93,60) &ELSE b-docum-est.cod-chave-aces-nf-eletro &ENDIF )
                               + (IF b-docum-est.ce-atual THEN "-NFE_ATUALIZADO" ELSE "-NFE_DESATUALIZADO") + ".txt".
    
            output to value(c-arquivo) convert target "iso8859-1".
            PUT UNFORMATTED TRIM(&IF "{&bf_mat_versao_ems}" < "2.07" &THEN SUBSTRING(b-docum-est.char-1,93,60) &ELSE b-docum-est.cod-chave-aces-nf-eletro &ENDIF) + ";" + (IF b-docum-est.ce-atual THEN "NFE_ATUALIZADO" ELSE "NFE_DESATUALIZADO").
            OUTPUT CLOSE.
        &ENDIF
    &ENDIF
    /* END.  AVAIL gt-tt-docum-est */
END. /* b-docum-est-old.ce-atual <> b-docum-est.ce-atual */

RETURN "OK".
