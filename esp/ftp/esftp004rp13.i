ASSIGN c-desc-separa = "".

EMPTY TEMP-TABLE tt-zona-separa.

FOR FIRST volume-wms-nf NO-LOCK
    WHERE volume-wms-nf.cod-estabel = volume-nf.cod-estabel
      AND volume-wms-nf.serie       = volume-nf.serie
      AND volume-wms-nf.nr-nota-fis = volume-nf.nr-nota-fis
      AND volume-wms-nf.nr-volume   = volume-nf.nr-volume
      AND volume-wms-nf.tipo-separa = 3: /* flow rack */
    /* buscar areas de flow rack envolvidas */

    FOR FIRST wm-local NO-LOCK
        WHERE wm-local.cod-estabel = volume-nf.cod-estabel
          AND wm-local.log-local-padrao:
    END.

    IF NOT AVAIL wm-local THEN
        RETURN "OK".
    
    FOR EACH b-volume-nf NO-LOCK 
        WHERE b-volume-nf.cod-estabel = volume-nf.cod-estabel
          AND b-volume-nf.nr-nota-fis = volume-nf.nr-nota-fis
          AND b-volume-nf.serie       = volume-nf.serie
          AND b-volume-nf.nr-volume   = volume-nf.nr-volume:

        FOR EACH wm-item-picking NO-LOCK
            WHERE wm-item-picking.cod-estabel = wm-local.cod-estabel
              AND wm-item-picking.cod-local   = wm-local.cod-local
              AND wm-item-picking.cod-item    = b-volume-nf.it-codigo
              AND CAN-FIND(FIRST ext-wm-picking NO-LOCK
                           WHERE ext-wm-picking.cod-estabel   = wm-item-picking.cod-estabel
                             AND ext-wm-picking.cod-local     = wm-item-picking.cod-local
                             AND ext-wm-picking.cod-picking   = wm-item-picking.cod-picking
                             AND ext-wm-picking.log-flow-rack = YES),
            EACH wm-box-picking NO-LOCK
                WHERE wm-box-picking.cod-estabel = wm-item-picking.cod-estabel
                  AND wm-box-picking.cod-local   = wm-item-picking.cod-local
                  AND wm-box-picking.cod-picking = wm-item-picking.cod-picking,
                FIRST zona-separa-box NO-LOCK
                    WHERE zona-separa-box.cod-estabel = wm-box-picking.cod-estabel
                      AND zona-separa-box.cod-local   = wm-box-picking.cod-local
                      AND zona-separa-box.id-box      = wm-box-picking.id-box-comp:

            FOR FIRST tt-zona-separa
                WHERE tt-zona-separa.cod-zona = zona-separa-box.cod-zona:
            END.

            IF NOT AVAIL tt-zona-separa THEN DO:
                CREATE tt-zona-separa.
                ASSIGN tt-zona-separa.cod-zona = zona-separa-box.cod-zona.
            END.
        END.
    END.

    FOR EACH tt-zona-separa 
        BREAK BY tt-zona-separa.cod-zona:
        IF c-desc-separa = "" THEN
            ASSIGN c-desc-separa = tt-zona-separa.cod-zona.
        ELSE
            ASSIGN c-desc-separa = c-desc-separa + "|" + tt-zona-separa.cod-zona.
    END.

    ASSIGN c-desc-separa = "[ FR " + c-desc-separa + " ]".
END.

IF NOT AVAIL volume-wms-nf THEN DO: /* pulmao ou picking */
/*
    FOR FIRST b-volume-nf NO-LOCK 
        WHERE b-volume-nf.cod-estabel = volume-nf.cod-estabel
          AND b-volume-nf.nr-nota-fis = volume-nf.nr-nota-fis
          AND b-volume-nf.serie       = volume-nf.serie
          AND b-volume-nf.nr-volume   = volume-nf.nr-volume
          AND b-volume-nf.it-codigo  <> volume-nf.it-codigo: /* se tem outro item no volume Ç fracionado */
    END.

    IF AVAIL b-volume-nf THEN DO: /* picking */
        ASSIGN c-desc-separa = "PK".
    END.
    ELSE DO: 
*/
    IF volume-nf.varios-itens THEN DO:
        ASSIGN c-desc-separa = "[ PK ]".
    END.
    ELSE DO:
        FOR FIRST wm-item-embalagem-local USE-INDEX idx-wm-item-embalagem-local5 NO-LOCK
            WHERE wm-item-embalagem-local.cod-item   = volume-nf.it-codigo
              AND wm-item-embalagem-local.log-padrao = YES
              AND wm-item-embalagem-local.cod-estabel = volume-nf.cod-estabel:
        END.

        IF AVAIL wm-item-embalagem-local THEN DO:
            IF volume-nf.qtde = wm-item-embalagem-local.qtd-item-emb
            OR volume-nf.qtde = wm-item-embalagem-local.qtd-emb-item THEN /* filha */
                ASSIGN c-desc-separa = "[ CX ]". /* caixa fechada - pulm∆o */
            ELSE
                ASSIGN c-desc-separa = "[ PK ]".
        END.
        ELSE DO:
            ASSIGN c-desc-separa = "[ NA ]". /* so pra identificar que nao achou */
        END.
    END.
        /*
    END.  */
END.
