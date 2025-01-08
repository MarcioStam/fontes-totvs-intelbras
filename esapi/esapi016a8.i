/*------------------------------------------------------------------------------
  Purpose: Etiquetas pequenas quintupla e modelo com tarja no topo da etiqueta
           a direita. Para modelos da quintupla.
  Parameters:  <none>
  Notes:   Carlos Daniel - 16/11/2015
------------------------------------------------------------------------------*/

PUT UNFORMATTED "^FO415,203^A0N,18,16^FB190,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. /* Sigla - Etiqueta Pequena 1 */
PUT UNFORMATTED "^FO415,223^A0N,18,16^FB190,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Sigla - Etiqueta Pequena 1 */
PUT UNFORMATTED "^FO625,203^A0N,18,16^FB190,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. /* Sigla - Etiqueta Pequena 2 */
PUT UNFORMATTED "^FO625,223^A0N,18,16^FB190,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Sigla - Etiqueta Pequena 2 */
PUT UNFORMATTED "^FO430,1^A0B,18,16^FB170,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. /* Sigla - Etiqueta Pequena 3 */
PUT UNFORMATTED "^FO450,1^A0B,18,16^FB170,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Sigla - Etiqueta Pequena 3 */

PUT UNFORMATTED "^FO543,15^A0N,24,24^FB272,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
PUT UNFORMATTED "^LRY^FO543,1^GB272,40,40^FS^LRN" SKIP.  /* Quadro preto */
