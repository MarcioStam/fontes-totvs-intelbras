/*------------------------------------------------------------------------------
  Purpose:     Inicializa impress∆o (parÉmetros impressora
  Parameters:  <none>
  Notes:       Carlos Daniel - 07/10/2015
------------------------------------------------------------------------------*/
PUT "^XA"         SKIP.   /* Inicio Label */
PUT "^PW832"      SKIP.   /* Width 832 */
PUT "^MNY"        SKIP.   /* Papel de etiquetas n∆o continuo */
PUT "^MTT"        SKIP.   /* Papel Comum - usa ribon */
PUT "^BY2"        SKIP.   /* Magnitude EAN */ 
PUT "^PRA"        SKIP.   /* Velocidade 50mm/seg */
PUT "^JUS"        SKIP.   /* Grava Configuracao */
PUT "^XZ"         SKIP.
