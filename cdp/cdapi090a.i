/* Caso seja necess rio adicionar novas variaveis neste fonte, 
   as mesmas devem ser definidas no programa cdp/cdapi090def.i */

/****** EVENTOS SAMSUNG VISIBILITY - SCI ******/ 
/*    {1} - CREATE          */
/*        - UPSERT          */
/***** EVENTOS - SAMSUNG VISIBILITY - SCI *****/ 

/***** TABELAS - SAMSUNG VISIBILITY - SCI *****/ 
/*   {2} - PED-VENDA        */
/*       - PED-ENT          */
/*       - IT-PRE-FAT       */
/*       - NOTA-FISCAL      */
/*       - EMBARQUE         */
/***** TABELAS - SAMSUNG VISIBILITY - SCI *****/ 

&if "{3}" = "" &then
    &scop tabela ''
&else
    &scop tabela {3}
&endif

IF CAN-FIND(FIRST tab-generica
            WHERE tab-generica.utilizacao = "SETSCI"
            AND   tab-generica.log-1      = YES) THEN DO:
      
   /* Instanciamento do proxy de integra‡Æo via Web Service */
   RUN cdp/cdapi090.p PERSISTENT SET hProxy.

   IF "{4}" = "TP2" THEN DO:
       FOR FIRST b-ped-venda-sci NO-LOCK
           WHERE ROWID(b-ped-venda-sci) = ROWID({&tabela}),
           EACH  ped-ent NO-LOCK
           WHERE ped-ent.nr-pedcli  = b-ped-venda-sci.nr-pedcli
           AND   ped-ent.nome-abrev = b-ped-venda-sci.nome-abrev:

           /* Parƒmetros de Execu‡Æo - sempre utilizar um m‚todo para cada cada parƒmetro */
           RUN setIntegration   IN hProxy("SCI":U).
           IF ped-ent.cd-sit-prog = 1 THEN
               RUN setOperation     IN hProxy("DELETE").
           ELSE 
               IF ped-ent.cod-sit-ent > 3 THEN
                   RUN setOperation     IN hProxy("DELETE").
               ELSE 
                   RUN setOperation     IN hProxy("{2}").
           RUN setPoint         IN hProxy("{4}").
           RUN setTable         IN hProxy('ped-ent').
           RUN setRowid         IN hProxy(ROWID(ped-ent)).
           RUN sendData         IN hProxy.
       END.
   END.
   ELSE 
       IF "{4}" = "TP5" THEN DO: 
           FOR FIRST b-embarque-sci NO-LOCK
               WHERE ROWID(b-embarque-sci) = ROWID({&tabela}):
               RUN setIntegration   IN hProxy("SCI":U).

               IF NOT CAN-FIND(FIRST res-cli
                               WHERE res-cli.cdd-embarq = b-embarque-sci.cdd-embarq) THEN 
                   RUN setOperation     IN hProxy("DELETE").
               ELSE 
                   RUN setOperation     IN hProxy("{2}"). 
                   
               RUN setPoint         IN hProxy("{4}").
               RUN setTable         IN hProxy('{&tabela}').
               RUN setRowid         IN hProxy(ROWID({&tabela})).
               RUN sendData         IN hProxy.
           END.
       END.
       ELSE DO:
           /* Parƒmetros de Execu‡Æo - sempre utilizar um m‚todo para cada cada parƒmetro */
           RUN setIntegration   IN hProxy("SCI":U).
           RUN setOperation     IN hProxy("{2}").
           RUN setPoint         IN hProxy("{4}").
           RUN setTable         IN hProxy('{&tabela}').
           RUN setRowid         IN hProxy(ROWID({&tabela})).
           RUN sendData         IN hProxy.
       END.
   
   
   /* Elimina‡Æo da instƒncia */
   DELETE PROCEDURE hProxy.
   ASSIGN hProxy = ?.

END.
