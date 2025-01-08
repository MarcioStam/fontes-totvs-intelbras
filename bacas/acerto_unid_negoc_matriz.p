FOR EACH ordem-compra EXCLUSIVE-LOCK             
    WHERE ordem-compra.situacao = 2: 

    FIND FIRST ITEM NO-LOCK 
        WHERE ITEM.it-codigo  = ordem-compra.it-codigo 
          AND item.tipo-contr = 4 NO-ERROR.

    IF AVAIL ITEM THEN DO:
         FIND FIRST unid_negoc NO-LOCK                                                                  
             WHERE unid_negoc.cdn_unid_negoc = int(SUBSTRING(ordem-compra.conta-contabil,9,3)) NO-ERROR.
                                                                                                             
         IF AVAIL unid_negoc THEN                                                                            
             ASSIGN ordem-compra.cod-unid-negoc = unid_negoc.cod_unid_negoc.                            

        FOR EACH matriz-rat-ordem EXCLUSIVE-LOCK
            WHERE matriz-rat-ordem.numero-ordem = ordem-compra.numero-ordem:
            FIND FIRST unid_negoc NO-LOCK
                WHERE unid_negoc.cdn_unid_negoc = int(SUBSTRING(matriz-rat-ordem.conta-contabil,9,3)) NO-ERROR.
        
            IF AVAIL unid_negoc THEN
                OVERLAY(matriz-rat-ordem.char-2,1,3) =  unid_negoc.cod_unid_negoc.
        END.
    END.
END.

/*  FOR EACH matriz-rat-ordem:                       */
/*      DISP matriz-rat-ordem.char-2 WITH WIDTH 300. */
/*  END.                                             */

/* FOR EACH ordem-compra EXCLUSIVE-LOCK                                                                     */
/*     WHERE ordem-compra.situacao = 2                                                                      */
/*     AND  ordem-compra.narrativa BEGINS "SDCV: ":                                                         */
/*                                                                                                          */
/*     FIND FIRST unid_negoc NO-LOCK                                                                   */
/*         WHERE unid_negoc.cdn_unid_negoc = int(SUBSTRING(ordem-compra.conta-contabil,9,3)) NO-ERROR. */
/*                                                                                                          */
/*     IF AVAIL unid_negoc THEN                                                                             */
/*         ASSIGN ordem-compra.cod-unid-negoc = unid_negoc.cod_unid_negoc.                             */
/*                                                                                                          */
/*                                                                                                          */
/* END.                                                                                                     */

/* FOR EACH ordem-compra NO-LOCK                    */
/*     WHERE ordem-compra.situacao = 2              */
/*     AND  ordem-compra.narrativa BEGINS "SDCV: ": */
/*                                                  */
/*                                                  */
/*     DISP ordem-compra.numero-ordem               */
/*          ordem-compra.cod-unid-negoc             */
/*          ordem-compra.conta-contabil   .         */
/*                                                  */
/*                                                  */
/* END.                                             */
