{esp/esb/esesb000.i}

/* /******************************** MSG0099 ***********************************/  */
/* define temp-table msg0099 no-undo xml-node-name 'MSG0099'                       */
/*    field idm as int xml-node-type 'hidden'.                                     */
/*                                                                                 */
/* define temp-table msg0099-CanaisItens no-undo xml-node-name 'CanaisItens'       */
/*    field idm as int xml-node-type 'hidden'.                                     */
/*                                                                                 */
/* define temp-table msg0099-CanalItem no-undo xml-node-name 'CanalItem'           */
/*    field idm as int xml-node-type 'hidden'                                      */
/*    field CodigoConta as CHAR.                                                   */
/*                                                                                 */
/* /******************************* msg0099r1 ***********************************/ */
/* define temp-table msg0099r1 no-undo xml-node-name 'msg0099r1'                   */
/*    field idm as int xml-node-type 'hidden'.                                     */
/*                                                                                 */
/* define temp-table msg0099r1-CanaisCentrais no-undo xml-node-name 'ClientesItens'   */
/*    field idm as int xml-node-type 'hidden'.                                     */
/*                                                                                 */
/* define temp-table msg0099r1-CanalItem no-undo xml-node-name 'CanalItem'         */
/*    field idm as int xml-node-type 'hidden'                                      */
/*    FIELD  CodigoConta  AS CHAR                                                  */
/*    FIELD  ValorAberto  AS DEC                                                   */
/*    FIELD  ValorVencido AS DEC                                                   */
/*    FIELD  Situacao     AS CHAR.                                                 */
/*                                                                                 */
/* define temp-table msg0099r1-ClientesItens no-undo xml-node-name 'ClientesItens' */
/*    field idm as int xml-node-type 'hidden'.                                     */
/*                                                                                 */
/* define temp-table msg0099r1-ClienteItem no-undo xml-node-name 'ClienteItem'     */
/*    field idm as int xml-node-type 'hidden'                                      */
/*    FIELD  CodigoConta                 AS CHAR                                   */
/*    FIELD  ValorAberto                 AS DEC                                    */
/*    FIELD  ValorVencido                AS DEC                                    */
/*    FIELD  Situacao                    AS CHAR.                                  */

    /******************************** MSG0099 ***********************************/ 

define temp-table msg0099 no-undo xml-node-name 'MSG0099'
   field idm as int xml-node-type 'hidden'.

define temp-table msg0099-CanaisCentrais no-undo xml-node-name 'CanaisCentrais'
   field idm as int xml-node-type 'hidden'
   field ContaCentral as character.

define temp-table msg0099-CanaisFiliais no-undo xml-node-name 'CanaisFiliais'
   field ContaCentral as CHAR xml-node-type 'hidden'
   field ContaFilial  as CHAR.



/******************************* msg0099r1 ***********************************/
define temp-table msg0099r1 no-undo xml-node-name 'MSG0099R1'
   field  idm as int xml-node-type 'hidden'.

define temp-table msg0099r1-CanaisCentrais no-undo xml-node-name 'CanaisCentrais'
   FIELD  idm as int xml-node-type 'hidden'
   FIELD  ContaCentral  AS CHAR
   FIELD  ValorAberto   AS DEC     
   FIELD  ValorVencido  AS DEC
   FIELD  Situacao      AS CHAR.        

define temp-table msg0099r1-CanaisFiliais no-undo xml-node-name 'CanaisFiliais'
   FIELD  idm as int xml-node-type 'hidden'
   FIELD  ContaCentral  AS CHAR
   FIELD  ContaFilial   AS CHAR
   FIELD  ValorAberto   AS DEC
   FIELD  ValorVencido  AS DEC
   FIELD  Situacao      AS CHAR.
