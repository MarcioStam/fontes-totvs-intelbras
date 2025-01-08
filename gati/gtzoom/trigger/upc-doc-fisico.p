/***********************************************************************
**  Programa...: upc-doc-fisico
**  Autor......: Oliver Fagionato
**  Descricao..: Upc utilizada na Exclusao da tabela doc-fisico
**  data.......: junho/2012
**  Atualizacao: 
************************************************************************/
{include/i-prgvrs.i UPC-DOC-FISICO 2.00.00.000}
/******************** DEFINICAO PARAMETROS ********************/
define param buffer bdoc-fisico     for doc-fisico.

FIND FIRST param-global NO-LOCK NO-ERROR.

/************************ DEFINICAO VARIAVEIS ************************/
{utp/ut-glob.i}
{gtp/gati0000.i}
{cdp/cdcfgmat.i}

IF CAN-FIND(FIRST gt-tt-docum-est WHERE
           gt-tt-docum-est.serie-docto  = bdoc-fisico.serie-docto  AND
           gt-tt-docum-est.nro-docto    = bdoc-fisico.nro-docto    AND
           gt-tt-docum-est.cod-emitente = bdoc-fisico.cod-emitente AND
           gt-tt-docum-est.cod-estabel  = bdoc-fisico.cod-estabel ) THEN DO:

    FIND FIRST gt-tt-docum-est EXCLUSIVE-LOCK WHERE
               gt-tt-docum-est.serie-docto  = bdoc-fisico.serie-docto  AND
               gt-tt-docum-est.nro-docto    = bdoc-fisico.nro-docto    AND
               gt-tt-docum-est.cod-emitente = bdoc-fisico.cod-emitente AND
               gt-tt-docum-est.cod-estabel  = bdoc-fisico.cod-estabel 
        NO-ERROR.

    IF AVAIL gt-tt-docum-est THEN DO:
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
                   param-xml.cod-estabel = gt-tt-docum-est.cod-estabel NO-ERROR.

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
    
        IF AVAIL param-xml AND
           param-xml.l-retorna-xml THEN
            assign gt-tt-docum-est.log-situacao = no.
        ELSE
            RUN gtp/gati0208.p(INPUT gt-tt-docum-est.nome-arq).
    
    END.
END.

&IF '{&pre-empresa}' = "cadence" &THEN

FOR EACH cg-agenda EXCLUSIVE-LOCK
   WHERE cg-agenda.serie-docto  = bdoc-fisico.serie-docto 
     AND cg-agenda.nro-docto    = bdoc-fisico.nro-docto   
     AND cg-agenda.cod-emitente = bdoc-fisico.cod-emitente:
    DELETE cg-agenda.
END.


&ENDIF


RETURN "OK".
