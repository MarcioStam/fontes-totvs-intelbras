/*****************************************************************************
** Programa..............: fas211aa3_epc.p
** Autor.................: Sensus Tecnologia
** Criado em.............: 21/06/2013
*****************************************************************************/

DEFINE NEW GLOBAL SHARED VARIABLE v_rec_bem_pat_epc AS RECID FORMAT ">>>>>>9":U INITIAL ? NO-UNDO.
DEFINE OUTPUT PARAMETER pclass-fiscal LIKE item-doc-est.class-fiscal NO-UNDO.

FIND bem_pat NO-LOCK WHERE RECID(bem_pat) = v_rec_bem_pat_epc NO-ERROR.

FIND FIRST item-doc-est NO-LOCK
    WHERE  item-doc-est.serie-docto  = bem_pat.cod_ser_nota  
    AND    item-doc-est.nro-docto    = STRING(INT(bem_pat.cod_docto_entr), '9999999')
    AND    item-doc-est.cod-emitente = bem_pat.cdn_fornecedor 
    AND    item-doc-est.sequencia    = bem_pat.num_item_docto_entr NO-ERROR.
IF  AVAIL  item-doc-est THEN ASSIGN pclass-fiscal = item-doc-est.class-fiscal.


IF  NOT AVAIL item-doc-est OR pclass-fiscal = "" OR pclass-fiscal = ? THEN DO:
    FOR EACH bem_pat_item_docto_entr OF bem_pat NO-LOCK:

        FIND FIRST item_docto_entr NO-LOCK 
            WHERE  item_docto_entr.cod_estab           = bem_pat_item_docto_entr.cod_estab
            AND    item_docto_entr.cod_empresa         = bem_pat_item_docto_entr.cod_empresa
            AND    item_docto_entr.cdn_fornecedor      = bem_pat_item_docto_entr.cdn_fornecedor
            AND    item_docto_entr.cod_docto_entr      = bem_pat_item_docto_entr.cod_docto_entr
            AND    item_docto_entr.cod_ser_nota        = bem_pat_item_docto_entr.cod_ser_nota
            AND    item_docto_entr.num_item_docto_entr = bem_pat_item_docto_entr.num_item_docto_entr no-error.

        IF  AVAIL  item_docto_entr THEN DO:
            FOR FIRST item-doc-est NO-LOCK
                WHERE item-doc-est.serie-docto  = item_docto_entr.cod_ser_nota
                AND   item-doc-est.nro-docto    = item_docto_entr.cod_docto_entr
                AND   item-doc-est.cod-emitente = item_docto_entr.cdn_fornecedor
                AND   item-doc-est.sequencia    = item_docto_entr.num_item_docto_entr:
                
                ASSIGN pclass-fiscal = item-doc-est.class-fiscal.

            END. /* FOR FIRST item-doc-est NO-LOCK */
        END.
    END. /* FOR EACH bem_pat_item_docto_entr OF */
END. /* ELSE DO: */


