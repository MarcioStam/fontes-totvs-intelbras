/***********************************************************************
**  Programa...: upc-doc-fiscal-d
**  Autor......: Oliver Fagionato
**  Descricao..: Upc utilizada na exclusao da tabela doc-fiscal
**  data.......: janeiro de 2013
**  Atualizacao: 
************************************************************************/
{include/i-prgvrs.i UPC-DOC-FISCAL-D 2.00.00.000}
/******************** DEFINICAO PARAMETROS ********************/
define param buffer b-doc-fiscal for doc-fiscal.

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
           param-xml.cod-estabel = b-doc-fiscal.cod-estabel NO-ERROR.

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


FIND FIRST gt-tt-docum-est EXCLUSIVE-LOCK WHERE
           gt-tt-docum-est.serie-docto  = b-doc-fiscal.serie        AND
           gt-tt-docum-est.nro-docto    = b-doc-fiscal.nr-doc-fis   AND
           gt-tt-docum-est.cod-emitente = b-doc-fiscal.cod-emitente AND
           gt-tt-docum-est.nat-operacao = b-doc-fiscal.nat-operacao AND
           gt-tt-docum-est.cod-estabel  = b-doc-fiscal.cod-estabel 
        NO-ERROR.

IF AVAIL param-xml AND
   PARAM-xml.l-retorna-xml AND
   AVAIL gt-tt-docum-est THEN DO:

        /* Chamado 11868 da Solidus que estava voltando a nota direto para o monitor, 
            quando usado o RE0402, sem antes deletar no RE1001 */
        IF NOT CAN-FIND(FIRST docum-est 
                        WHERE docum-est.serie        = gt-tt-docum-est.serie
                          AND docum-est.nro-docto    = gt-tt-docum-est.nro-docto
                          AND docum-est.cod-emitente = gt-tt-docum-est.cod-emitente
                          AND docum-est.nat-operacao = gt-tt-docum-est.nat-operacao
                          AND docum-est.cod-estabel  = gt-tt-docum-est.cod-estabel) THEN DO:
                assign gt-tt-docum-est.log-situacao = NO.
        END.
END.
ELSE
    IF AVAIL gt-tt-docum-est THEN
        RUN gtp/gati0208.p(INPUT gt-tt-docum-est.nome-arq).


FIND FIRST docum-est EXCLUSIVE-LOCK WHERE
           docum-est.serie-docto  = b-doc-fiscal.serie        AND
           docum-est.nro-docto    = b-doc-fiscal.nr-doc-fis   AND
           docum-est.cod-emitente = b-doc-fiscal.cod-emitente AND
           docum-est.nat-operacao = b-doc-fiscal.nat-operacao AND
           docum-est.cod-estabel  = b-doc-fiscal.cod-estabel  NO-ERROR.

IF NOT AVAIL docum-est THEN DO:

    &IF '{&pre-xml-webservice}' = "ativo" &THEN
        ASSIGN cType = "201".

        CREATE SAX-WRITER hSAXWriter.

        hSAXWriter:FORMATTED = TRUE.

        hSAXWriter:SET-OUTPUT-DESTINATION("longchar ", c-xml).

        hSAXWriter:START-DOCUMENT().
            hSAXWriter:START-ELEMENT("recepcaoEntrada").
                    hSAXWriter:START-ELEMENT("entrada").
                        hSAXWriter:START-ELEMENT("notificacao").
                        hSAXWriter:INSERT-ATTRIBUTE("type", cType).
                            hSAXWriter:WRITE-DATA-ELEMENT("chNFe", &IF "{&bf_mat_versao_ems}" >= '2.09' &THEN b-doc-fiscal.cod-chave-aces-nf-eletro &ELSE SUBSTRING(b-doc-fiscal.char-2,155,60) &ENDIF ).
                        hSAXWriter:END-ELEMENT("notificacao").
                    hSAXWriter:END-ELEMENT("entrada").
              hSAXWriter:END-ELEMENT("recepcaoEntrada").
        hSAXWriter:END-DOCUMENT().

        RUN gtp/gati0102k.p(INPUT c-xml,
                            INPUT param-xml.url-ws-saida).
    &ELSE
        &IF '{&pre-empresa}' <> "denso" &THEN
            ASSIGN c-arquivo = param-xml.arq-entrada-cce
                               + TRIM( &IF "{&bf_mat_versao_ems}" >= '2.09' &THEN b-doc-fiscal.cod-chave-aces-nf-eletro &ELSE SUBSTRING(b-doc-fiscal.char-2,155,60) &ENDIF )
                               + "-NFE_DESATUALIZADO" + ".txt".
    
            output to value(c-arquivo) convert target "iso8859-1".
            PUT UNFORMATTED TRIM( &IF "{&bf_mat_versao_ems}" >= '2.09' &THEN b-doc-fiscal.cod-chave-aces-nf-eletro &ELSE SUBSTRING(b-doc-fiscal.char-2,155,60) &ENDIF ) + ";" + "NFE_DESATUALIZADO".
            OUTPUT CLOSE.
        &ENDIF
    &ENDIF



END.

RETURN "OK".
