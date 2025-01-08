DEFINE INPUT PARAM p-ncm        AS CHAR NO-UNDO.
DEFINE INPUT PARAM p-origem     AS INT  NO-UNDO.

DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar IN h-acomp (INPUT "Atualizando escdp055...").

FOR EACH ncm-origem-sem-prot NO-LOCK
    WHERE ncm-origem-sem-prot.cod-ncm     = replace(p-ncm, '.', '')
      AND ncm-origem-sem-prot.codigo-orig = p-origem 
      AND ncm-origem-sem-prot.l-gera-of
      AND ncm-origem-sem-prot.l-tem-st,
    EACH ITEM NO-LOCK
        WHERE ITEM.class-fiscal = ncm-origem-sem-prot.cod-ncm
          AND ITEM.codigo-orig  = ncm-origem-sem-prot.codigo-orig
          AND ITEM.ind-item-fat:
  
    RUN pi-acompanhar IN h-acomp (input "Item: " + ITEM.it-codigo ).

    FIND item-uf EXCLUSIVE-LOCK
        WHERE item-uf.it-codigo       = ITEM.it-codigo      
          AND item-uf.cod-estado-orig = ncm-origem-sem-prot.uf-origem
          AND item-uf.estado          = ncm-origem-sem-prot.uf-destino NO-ERROR.

    IF NOT AVAIL item-uf THEN DO:

       FIND unid-feder NO-LOCK
           WHERE unid-feder.estado = ncm-origem-sem-prot.uf-origem NO-ERROR.

        CREATE item-uf.
        ASSIGN item-uf.it-codigo       = ITEM.it-codigo           
               item-uf.cod-estado-orig = ncm-origem-sem-prot.uf-origem     
               item-uf.estado          = ncm-origem-sem-prot.uf-destino.
               item-uf.pais            = unid-feder.pais. 
    END.
    ASSIGN item-uf.per-sub-tri         = ncm-origem-sem-prot.per-sub-tri   
           item-uf.perc-red-sub        = ncm-origem-sem-prot.perc-red-sub
           item-uf.dec-1               = ncm-origem-sem-prot.perc-aliq-Interna.

    FIND int-item-uf EXCLUSIVE-LOCK
        WHERE int-item-uf.it-codigo       = ITEM.it-codigo      
          AND int-item-uf.cod-estado-orig = ncm-origem-sem-prot.uf-origem
          and int-item-uf.estado          = ncm-origem-sem-prot.uf-destino NO-ERROR.

    IF NOT AVAIL int-item-uf THEN DO:
        CREATE int-item-uf.
        ASSIGN int-item-uf.it-codigo       = ITEM.it-codigo           
               int-item-uf.cod-estado-orig = ncm-origem-sem-prot.uf-origem     
               int-item-uf.estado          = ncm-origem-sem-prot.uf-destino.                   
    END.

    ASSIGN int-item-uf.perc-credito-interno = ncm-origem-sem-prot.perc-credito-icms
           int-item-uf.protocolo            = ncm-origem-sem-prot.protocolo.    
END.

RUN pi-finalizar IN h-acomp.

RETURN "OK":U.



