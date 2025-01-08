
/* TRIGGER PROCEDURE FOR WRITE OF contrat_vendor. */

/*** Cria‡Æo: 03/11/2005 - Claudiney Klitzke ******/
 
/*** Historico de altera‡Æo ********/
/**Altera‡Æo:
   Motivo...:
****/   

DEF PARAM BUFFER b-contrat_vendor      FOR contrat_vendor.
DEF PARAM BUFFER b-old-contrat_vendor  FOR contrat_vendor.
    
run esp/es0669.p (input "yes", 
                  "emitente", 
                  string(b-contrat_vendor.cdn_cliente,"999999999"),
                  "", "", "", "", "", "", "", "").


