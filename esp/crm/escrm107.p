/*----------------------------------------------------------------------
**  Programa..: esp/crm/escrm107.p
**  Autor.....: Silvio Ferrari
**  Data......: Mar‡o/2011 - Desenvolvimento
**  Descricao.: Busca Transportadora
-----------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pEstab      LIKE def-transportes.cod-estabel    NO-UNDO.
DEFINE INPUT  PARAMETER pCliente    LIKE def-transportes.cod-cliente    NO-UNDO.
DEFINE INPUT  PARAMETER pCidade     LIKE def-transportes.cod-cidade     NO-UNDO.
DEFINE INPUT  PARAMETER pEstado     LIKE def-transportes.cod-uf         NO-UNDO.
DEFINE INPUT  PARAMETER pUnidComerc LIKE def-transportes.cd-unid-comerc NO-UNDO.
DEFINE INPUT  PARAMETER cCepDestino AS   CHAR                           NO-UNDO.

DEFINE OUTPUT PARAMETER codTransp   LIKE def-transportes.cod-trans      NO-UNDO.
DEFINE OUTPUT PARAMETER siglaTransp LIKE def-transportes.sigla-trans    NO-UNDO.

ASSIGN codTransp = 0
       siglaTransp = "".

/*** Busca por CEP ***/
IF siglaTransp = "" THEN
   FOR FIRST int-def-sigla-transp NO-LOCK
       WHERE int-def-sigla-transp.cod-estab    = pEstab
         AND int-def-sigla-transp.cep-inicial >= cCepDestino
         AND int-def-sigla-transp.cep-final   <= cCepDestino
         AND int-def-sigla-transp.cod-emitente = int(pCliente):
      ASSIGN codTransp   = int-def-sigla-transp.cod-transp
             siglaTransp = int-def-sigla-transp.sigla-transp.
   END.

/*** Busca por Cidade/Estado ***/
IF siglaTransp = "" THEN
   FOR FIRST int-def-sigla-transp NO-LOCK
       WHERE int-def-sigla-transp.cod-estab    = pEstab
         AND int-def-sigla-transp.cidade       = pCidade
         AND int-def-sigla-transp.estado       = pEstado
         AND int-def-sigla-transp.cod-emitente = int(pCliente):
      ASSIGN codTransp   = int-def-sigla-transp.cod-transp
             siglaTransp = int-def-sigla-transp.sigla-transp.
   END.

/*** Busca por Estado ***/
IF siglaTransp = "" THEN
   FOR FIRST int-def-sigla-transp NO-LOCK
       WHERE int-def-sigla-transp.cod-estab    = pEstab
         AND int-def-sigla-transp.estado       = pEstado
         AND int-def-sigla-transp.cod-emitente = int(pCliente):
      ASSIGN codTransp   = int-def-sigla-transp.cod-transp
             siglaTransp = int-def-sigla-transp.sigla-transp.
   END.

/*** Busca por Estabelecimento ***/
IF siglaTransp = "" THEN
   FOR FIRST int-def-sigla-transp NO-LOCK
       WHERE int-def-sigla-transp.cod-estab    = pEstab
         AND int-def-sigla-transp.cod-emitente = int(pCliente):
      ASSIGN codTransp   = int-def-sigla-transp.cod-transp
             siglaTransp = int-def-sigla-transp.sigla-transp.
   END.


IF siglaTransp = "" THEN
   FOR FIRST int-def-sigla-transp NO-LOCK
       WHERE int-def-sigla-transp.cod-estab    = pEstab
         AND int-def-sigla-transp.cep-inicial >= cCepDestino
         AND int-def-sigla-transp.cep-final   <= cCepDestino
         AND int-def-sigla-transp.cod-emitente = 0:
      ASSIGN codTransp   = int-def-sigla-transp.cod-transp
             siglaTransp = int-def-sigla-transp.sigla-transp.
   END.


IF siglaTransp = "" THEN
   FOR FIRST int-def-sigla-transp NO-LOCK
       WHERE int-def-sigla-transp.cod-estab    = pEstab
         AND int-def-sigla-transp.cidade       = pCidade
         AND int-def-sigla-transp.estado       = pEstado
         AND int-def-sigla-transp.cod-emitente = 0:
      ASSIGN codTransp   = int-def-sigla-transp.cod-transp
             siglaTransp = int-def-sigla-transp.sigla-transp.
   END.


IF siglaTransp = "" THEN
   FOR FIRST int-def-sigla-transp NO-LOCK
       WHERE int-def-sigla-transp.cod-estab    = pEstab
         AND int-def-sigla-transp.estado       = pEstado
         AND int-def-sigla-transp.cod-emitente = 0:
      ASSIGN codTransp   = int-def-sigla-transp.cod-transp
             siglaTransp = int-def-sigla-transp.sigla-transp.
   END.

IF siglaTransp = "" THEN
   FOR FIRST int-def-sigla-transp NO-LOCK
       WHERE int-def-sigla-transp.cod-estab    = pEstab
         AND int-def-sigla-transp.cod-emitente = 0:
      ASSIGN codTransp   = int-def-sigla-transp.cod-transp
             siglaTransp = int-def-sigla-transp.sigla-transp.
   END.	   
	   

if siglatransp = '' then 	   
FOR FIRST def-transportes NO-LOCK
    WHERE def-transportes.cod-estabel    = pEstab
      AND def-transportes.cod-uf         = pEstado
      AND def-transportes.cod-cidade     = pCidade
      AND def-transportes.cod-cliente    = pCliente
      AND def-transportes.cd-unid-comerc = pUnidComerc:
    ASSIGN codTransp    = def-transportes.cod-trans.
          siglaTransp  = def-transportes.sigla-trans. 
END.


if siglatransp = '' then 	   
IF  NOT AVAIL def-transportes THEN DO:
    FOR FIRST def-transportes NO-LOCK
        WHERE def-transportes.cod-estabel    = pEstab
          AND def-transportes.cod-uf         = pEstado
          AND def-transportes.cod-cidade     = pCidade
          AND def-transportes.cod-cliente    = pCliente
          AND def-transportes.cd-unid-comerc = 0:
        ASSIGN codTransp    = def-transportes.cod-trans.
             siglaTransp  = def-transportes.sigla-trans. 
    END.
END.


if siglatransp = '' then 	   
IF NOT AVAIL def-transportes THEN DO:
    
    IF pCliente <> "":U THEN DO:

        FOR FIRST def-transportes  NO-LOCK
            WHERE def-transportes.cod-estabel    = pEstab
              AND def-transportes.cod-cliente    = pCliente
              AND def-transportes.cd-unid-comerc = pUnidComerc
              AND def-transportes.cod-uf         = ""
              AND def-transportes.cod-cidade     = "":
            
            ASSIGN codTransp    = def-transportes.cod-trans.
                  siglaTransp  = def-transportes.sigla-trans. 
        END.

       
        IF  NOT AVAIL def-transportes THEN DO:
            FOR FIRST def-transportes  NO-LOCK
                WHERE def-transportes.cod-estabel    = pEstab
                  AND def-transportes.cod-cliente    = pCliente
                  AND def-transportes.cod-cidade     = ""
                  AND def-transportes.cod-uf         = ""
                  AND def-transportes.cd-unid-comerc = 0:
                ASSIGN codTransp    = def-transportes.cod-trans.
                      siglaTransp  = def-transportes.sigla-trans. 
            END.
        END.

    END.

    IF NOT AVAIL def-transportes THEN DO:
           
        IF pCidade <> "":U AND pEstado <> "":U THEN DO:

            FOR FIRST def-transportes NO-LOCK
                WHERE def-transportes.cod-estabel    = pEstab
                  AND def-transportes.cod-cidade     = pCidade
                  AND def-transportes.cod-uf         = pEstado
                  AND def-transportes.cod-cliente    = pCliente
                  AND def-transportes.cd-unid-comerc = pUnidComerc:

                ASSIGN codTransp    = def-transportes.cod-trans
                       siglaTransp  = def-transportes.sigla-trans. 
            END.
            
            IF NOT AVAIL def-transportes THEN
               FOR FIRST def-transportes NO-LOCK
                   WHERE def-transportes.cod-estabel    = pEstab
                     AND def-transportes.cod-cidade     = ""
                     AND def-transportes.cod-uf         = pEstado
                     AND def-transportes.cod-cliente    = pCliente
                     AND def-transportes.cd-unid-comerc = pUnidComerc:
                   ASSIGN codTransp    = def-transportes.cod-trans
                          siglaTransp  = def-transportes.sigla-trans. 
               END. 

            IF NOT AVAIL def-transportes THEN
               FOR FIRST def-transportes NO-LOCK
                   WHERE def-transportes.cod-estabel    = pEstab
                     AND def-transportes.cod-cidade     = pCidade
                     AND def-transportes.cod-uf         = pEstado
                     AND def-transportes.cod-cliente    = ""
                     AND def-transportes.cd-unid-comerc = pUnidComerc:
                   ASSIGN codTransp    = def-transportes.cod-trans
                          siglaTransp  = def-transportes.sigla-trans. 
               END.
            
            IF  NOT AVAIL def-transportes THEN DO:
                FOR FIRST def-transportes NO-LOCK
                    WHERE def-transportes.cod-estabel    = pEstab
                      AND def-transportes.cod-cidade     = pCidade
                      AND def-transportes.cod-uf         = pEstado
                      AND def-transportes.cod-cliente    = ""
                      AND def-transportes.cd-unid-comerc = 0:
                    ASSIGN codTransp    = def-transportes.cod-trans
                           siglaTransp  = def-transportes.sigla-trans .
                END.
            END.

        END.

        IF NOT AVAIL def-transportes THEN DO:

            FOR FIRST def-transportes  NO-LOCK
                WHERE def-transportes.cod-estabel    = pEstab
                  AND def-transportes.cod-uf         = pEstado
                  AND def-transportes.cd-unid-comerc = pUnidComerc
                  AND def-transportes.cod-cidade     = ""
                  AND def-transportes.cod-cliente    = "":
                ASSIGN codTransp    = def-transportes.cod-trans
                        siglaTransp  = def-transportes.sigla-trans. 
            END.

            IF  NOT AVAIL def-transportes THEN DO:
                FOR FIRST def-transportes NO-LOCK
                    WHERE def-transportes.cod-estabel    = pEstab
                      AND def-transportes.cod-uf         = pEstado
                      AND def-transportes.cd-unid-comerc = 0
                      AND def-transportes.cod-cidade     = ""
                      AND def-transportes.cod-cliente    = "":
                    ASSIGN codTransp    = def-transportes.cod-trans
                           siglaTransp  = def-transportes.sigla-trans. 
                END.
            END.
        END.
    END.
END.


/* Se nao encontrar retorna pra regra da unidade comercial 0 */

if siglatransp = '' then 	   
IF NOT AVAIL def-transportes  THEN
    ASSIGN codTransp = ?.

if siglatransp = '' then 	
IF  codTransp <> ? AND codTransp <> 0 THEN DO:
    FOR FIRST int-def-sigla-transp NO-LOCK
        WHERE int-def-sigla-transp.cod-transp   = codTransp
          AND int-def-sigla-transp.cod-estab    = pEstab
          AND int-def-sigla-transp.cep-inicial <=  cCepDestino
          AND int-def-sigla-transp.cep-final   >=  cCepDestino:
          ASSIGN siglaTransp = int-def-sigla-transp.sigla-transp.
    END.

    IF  siglaTransp = "" THEN
        FOR FIRST int-def-sigla-transp NO-LOCK
            WHERE int-def-sigla-transp.cod-transp   = codTransp
              AND int-def-sigla-transp.cod-estab    = pEstab
              AND int-def-sigla-transp.cidade       = pCidade
              AND int-def-sigla-transp.estado       = pEstado:
              ASSIGN siglaTransp = int-def-sigla-transp.sigla-transp.
        END.

    IF  siglaTransp = "" THEN
        FOR FIRST int-def-sigla-transp NO-LOCK
            WHERE int-def-sigla-transp.cod-transp   = codTransp
              AND int-def-sigla-transp.cod-estab    = pEstab
              AND int-def-sigla-transp.estado       = pEstado:
              ASSIGN siglaTransp = int-def-sigla-transp.sigla-transp.
        END.

    IF  siglaTransp = "" THEN
        FOR FIRST int-def-sigla-transp NO-LOCK
            WHERE int-def-sigla-transp.cod-transp   = codTransp
              AND int-def-sigla-transp.cod-estab    = pEstab:
              ASSIGN siglaTransp = int-def-sigla-transp.sigla-transp.
        END.
END.


RELEASE def-transportes.

RETURN "OK":U.
