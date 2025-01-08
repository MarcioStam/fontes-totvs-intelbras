/*******************************************************************************************************************/
/* Parƒmetros:                                                                                                     */
/*                                                                                                                 */
/*   {1} Campo da Temp-table                                                                                       */                                                                                                      
/*   {2} Campo da tabela principal                                                                                 */
/*   {3} variavel que guarda o cabe‡alho da tabelinha HTML                                                         */                                                                                                      
/*   {4} label do campo da tabelinha HTML                                                                          */
/*   {5} variavel que guarda o valor do campo da tabelinha HTML                                                    */
/*                                                                                                                 */
/*   Ex:  {esp/inp/esinp003.i "tt-ncm.descricao" "fiscosoft-ncm.descricao" "c-lbl-ncm" "'Descri‡Æo'" "c-msg-ncm"}  */
/*                                                                                                                 */
/*******************************************************************************************************************/
     
ASSIGN {3} = {3} + '<TD>' + {1} + '</TD>' 
       {5} = {5} + '<TH>' + {4} + '</TH>'.           

ASSIGN {2} = {1}.     

