
/* Caso seja necess rio adicionar novas variaveis neste fonte, 
   as mesmas devem ser definidas no programa cdp/cdapi090def.i */

/****** EVENTOS NEOLOG ******/ 
/*    {1} - CREATE          */
/*        - UPSERT          */
/***** EVENTOS - NEOLOG *****/ 

/***** TABELAS - NEOLOG *****/ 
/*   {2} - TRANSPORTE       */
/*       - LOC-ENTR         */
/*       - ITEM             */
/*       - TIPO-EMB         */
/*       - EMBARQUE         */
/***** TABELAS - NEOLOG *****/ 

&if "{2}" = "" &then
    &scop tabela ''
&else
    &scop tabela {2}
&endif

IF CAN-FIND (FIRST funcao NO-LOCK
             WHERE funcao.cd-funcao = "SPP-INTWS":U
               AND funcao.ativo) THEN DO:
      
   /* Instanciamento do proxy de integra‡Æo via Web Service */
   RUN cdp/cdapi090.p PERSISTENT SET hProxy.
   
   /* Parƒmetros de Execu‡Æo - sempre utilizar um m‚todo para cada cada parƒmetro */
   RUN setIntegration   IN hProxy("ALL":U).
   RUN setOperation     IN hProxy("{1}").
   RUN setTable         IN hProxy('{&tabela}').
   RUN setRowid         IN hProxy(ROWID({&tabela})).
   RUN sendData         IN hProxy.

   &IF "{3}" = "YES" &THEN
    RUN returnTtPedidos IN hProxy (OUTPUT TABLE ttPedidos).
   &ENDIF

   /* Elimina‡Æo da instƒncia */
   DELETE PROCEDURE hProxy.
   ASSIGN hProxy = ?.

END.
