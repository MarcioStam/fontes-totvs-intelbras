/***********************************************************************
**  Programa...: upc-docum-est
**  Autor......: Daniel Steiner
**  Descricao..: Upc utilizada na Exclusao  da tabela docum-est
**  data.......: MARCO/2010
**  Atualizacao: 
************************************************************************/
{include/i-prgvrs.i UPC-DOCUM-EST 2.00.00.000}
/******************** DEFINICAO PARAMETROS ********************/
define param buffer bdocum-est     for docum-est.

FIND FIRST param-global NO-LOCK NO-ERROR.

/************************ DEFINICAO VARIAVEIS ************************/
{utp/ut-glob.i}
{gtp/gati0000.i}
{cdp/cdcfgmat.i}

FIND FIRST natur-oper NO-LOCK WHERE
           natur-oper.nat-operacao = bDocum-est.nat-operacao NO-ERROR.

IF natur-oper.imp-nota THEN DO:
    FIND FIRST gt-tt-docum-est EXCLUSIVE-LOCK WHERE
               gt-tt-docum-est.serie-docto  = bDocum-est.serie-docto    AND
               gt-tt-docum-est.int-1        = int(bDocum-est.nro-docto) AND
               gt-tt-docum-est.cod-emitente = bDocum-est.cod-emitente   AND
               gt-tt-docum-est.nat-operacao = bDocum-est.nat-operacao   AND
               gt-tt-docum-est.cod-estabel  = bDocum-est.cod-estabel 
            NO-ERROR.
END.
ELSE DO:
    FIND FIRST gt-tt-docum-est EXCLUSIVE-LOCK WHERE
               gt-tt-docum-est.serie-docto  = bDocum-est.serie-docto  AND
               gt-tt-docum-est.nro-docto    = bDocum-est.nro-docto    AND
               gt-tt-docum-est.cod-emitente = bDocum-est.cod-emitente AND 
               gt-tt-docum-est.nat-operacao = bDocum-est.nat-operacao AND
               gt-tt-docum-est.cod-estabel  = bDocum-est.cod-estabel 
            NO-ERROR.
END.

IF NOT AVAIL gt-tt-docum-est THEN DO:
    &IF "{&bf_mat_versao_ems}"  >=  "2.07"  &THEN
        FIND FIRST gt-tt-docum-est EXCLUSIVE-LOCK WHERE
                gt-tt-docum-est.chave-acesso = TRIM(bDocum-est.cod-chave-aces-nf-eletro)
            NO-ERROR.
    &ELSE
        FIND FIRST gt-tt-docum-est EXCLUSIVE-LOCK WHERE
                gt-tt-docum-est.chave-acesso = TRIM(SUBSTRING(bDocum-est.char-1,93,60))
            NO-ERROR.
    &ENDIF
END.

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
       PARAM-xml.l-retorna-xml THEN DO:

        assign gt-tt-docum-est.log-situacao = no.

        FOR EACH gt-ext-it-docum-est EXCLUSIVE-LOCK WHERE
                 gt-ext-it-docum-est.serie-docto-pad  = bDocum-est.serie-docto  AND
                 gt-ext-it-docum-est.nro-docto-pad    = bDocum-est.nro-docto    AND
                 gt-ext-it-docum-est.cod-emitente-pad = bDocum-est.cod-emitente AND
                 gt-ext-it-docum-est.nat-operacao-pad = bDocum-est.nat-operacao:

            DELETE gt-ext-it-docum-est.
        END.
    END.
    ELSE
        RUN gtp/gati0208.p(INPUT gt-tt-docum-est.nome-arq).
END.

/* Valida‡äes CT-e */
FIND FIRST gati-cte EXCLUSIVE-LOCK WHERE
           gati-cte.cod-emitente = bDocum-est.cod-emitente AND
           gati-cte.nat-operacao = bDocum-est.nat-operacao AND
           gati-cte.nro-docto    = bDocum-est.nro-docto    AND
           gati-cte.serie-docto  = bDocum-est.serie-docto  NO-ERROR.
IF AVAIL gati-cte THEN DO:
    FIND FIRST param-xml NO-LOCK WHERE
               &IF '{&pre-empresa}' = "jmalucelli" &THEN
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
               param-xml.cod-estabel = gati-cte.cod-estabel NO-ERROR.

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
        ASSIGN gati-cte.log-importado = NO
               gati-cte.nat-operacao  = "".
    ELSE
        DELETE gati-cte.
END.

RETURN "OK".
