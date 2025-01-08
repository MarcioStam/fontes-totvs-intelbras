/*----------------------------------------*/
/* Api para retornar al¡quota FCP do item */
/*----------------------------------------*/

PROCEDURE pi-retorna-aliquota-FCP:

   DEF INPUT  PARAM p-item           AS CHAR NO-UNDO.
   DEF INPUT  PARAM p-estado-origem  AS CHAR NO-UNDO.
   DEF INPUT  PARAM p-estado-destino AS CHAR NO-UNDO.
   DEF OUTPUT PARAM de-aliq-fcp      AS DEC NO-UNDO.

   FOR EACH ct-trib-cenar-fisc
        WHERE ct-trib-cenar-fisc.cod-territor-orig = p-estado-origem
          AND ct-trib-cenar-fisc.cod-territor-dest = p-estado-destino
          AND ct-trib-cenar-fisc.cod-tip-trib      = 'FCP ST' NO-LOCK:

       IF  ct-trib-cenar-fisc.idi-busca-trib = 5 THEN DO:
           FIND FIRST ct-trib-clas-fisc
               WHERE ct-trib-clas-fisc.cod-clas-fisc = ct-trib-cenar-fisc.cod-clas-fisc-natur-operac NO-LOCK NO-ERROR.
           FIND FIRST ct-configur-trib
               WHERE ct-configur-trib.cod-configur-trib = ct-trib-clas-fisc.cod-configur-trib NO-LOCK NO-ERROR.
           ASSIGN de-aliq-fcp = ct-configur-trib.val-aliq.
       END.
       IF  ct-trib-cenar-fisc.idi-busca-trib = 4 THEN DO:
           FIND FIRST ct-trib-clas-fisc
               WHERE ct-trib-clas-fisc.cod-clas-fisc = ct-trib-cenar-fisc.cod-clas-fisc-item NO-LOCK NO-ERROR.
           FIND FIRST ct-configur-trib
               WHERE ct-configur-trib.cod-configur-trib = ct-trib-clas-fisc.cod-configur-trib NO-LOCK NO-ERROR.
           FIND FIRST ct-clas-item
               WHERE ct-clas-item.cod-item    = p-item
                 AND ct-clas-item.cod-clas-fisc = ct-trib-cenar-fisc.cod-clas-fisc-item NO-LOCK NO-ERROR.
           IF  AVAIL ct-clas-item THEN
               ASSIGN de-aliq-fcp = ct-configur-trib.val-aliq.
       END.
   END.

   RETURN "OK".
END.
