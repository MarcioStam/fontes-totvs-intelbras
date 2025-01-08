/*----------------------------------------------------------------------
**  Programa..: esp/api/busca-transportadora.p
**  Autor.....: Leandro Jonk
**  Data......: Dez/2021 - Desenolvimento
**  Descricao.: Busca Transportadora
-----------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pEstab      LIKE int-logistica-ecommerce.cod-estabel  NO-UNDO.
DEFINE INPUT  PARAMETER pCliente    LIKE int-logistica-ecommerce.cod-emitente NO-UNDO.
DEFINE INPUT  PARAMETER pCidade     LIKE int-logistica-ecommerce.cidade       NO-UNDO.
DEFINE INPUT  PARAMETER pEstado     LIKE int-logistica-ecommerce.estado       NO-UNDO.
DEFINE INPUT  PARAMETER pUnidComerc LIKE unid-comerc.cd-unid-comerc           NO-UNDO.
DEFINE INPUT  PARAMETER cCepDestino AS   CHAR                                 NO-UNDO.

DEFINE OUTPUT PARAMETER codTransp   LIKE int-logistica-ecommerce.cod-trans    NO-UNDO.
DEFINE OUTPUT PARAMETER siglaTransp LIKE int-logistica-ecommerce.sigla-trans  NO-UNDO.

ASSIGN codTransp = 0
       siglaTransp = "".

/*** Busca por CEP ***/
IF siglaTransp = "" THEN
   FOR FIRST int-logistica-ecommerce NO-LOCK
       WHERE int-logistica-ecommerce.cod-estab    = pEstab
         AND int-logistica-ecommerce.cep-inicial <= cCepDestino
         AND int-logistica-ecommerce.cep-final   >= cCepDestino   
         AND int-logistica-ecommerce.cod-emitente = int(pCliente):
      ASSIGN codTransp   = int-logistica-ecommerce.cod-transp
             siglaTransp = int-logistica-ecommerce.sigla-transp.
   END.

/*** Busca por Cidade/Estado ***/
IF siglaTransp = "" THEN
   FOR FIRST int-logistica-ecommerce NO-LOCK
       WHERE int-logistica-ecommerce.cod-estab    = pEstab
         AND int-logistica-ecommerce.cidade       = pCidade
         AND int-logistica-ecommerce.estado       = pEstado
         AND int-logistica-ecommerce.cod-emitente = int(pCliente):
      ASSIGN codTransp   = int-logistica-ecommerce.cod-transp
             siglaTransp = int-logistica-ecommerce.sigla-transp.
   END.

/*** Busca por Estado ***/
IF siglaTransp = "" THEN
   FOR FIRST int-logistica-ecommerce NO-LOCK
       WHERE int-logistica-ecommerce.cod-estab    = pEstab
         AND int-logistica-ecommerce.estado       = pEstado
         AND int-logistica-ecommerce.cod-emitente = int(pCliente):
      ASSIGN codTransp   = int-logistica-ecommerce.cod-transp
             siglaTransp = int-logistica-ecommerce.sigla-transp.
   END.

/*** Busca por Estabelecimento ***/
IF siglaTransp = "" THEN
   FOR FIRST int-logistica-ecommerce NO-LOCK
       WHERE int-logistica-ecommerce.cod-estab    = pEstab
         AND int-logistica-ecommerce.cod-emitente = int(pCliente):
      ASSIGN codTransp   = int-logistica-ecommerce.cod-transp
             siglaTransp = int-logistica-ecommerce.sigla-transp.
   END.


IF siglaTransp = "" THEN
   FOR FIRST int-logistica-ecommerce NO-LOCK
       WHERE int-logistica-ecommerce.cod-estab    = pEstab
         AND int-logistica-ecommerce.cep-inicial <= cCepDestino
         AND int-logistica-ecommerce.cep-final   >= cCepDestino   
         AND int-logistica-ecommerce.cod-emitente = 0:
      ASSIGN codTransp   = int-logistica-ecommerce.cod-transp
             siglaTransp = int-logistica-ecommerce.sigla-transp.
   END.


IF siglaTransp = "" THEN
   FOR FIRST int-logistica-ecommerce NO-LOCK
       WHERE int-logistica-ecommerce.cod-estab    = pEstab
         AND int-logistica-ecommerce.cidade       = pCidade
         AND int-logistica-ecommerce.estado       = pEstado
         AND int-logistica-ecommerce.cod-emitente = 0:
      ASSIGN codTransp   = int-logistica-ecommerce.cod-transp
             siglaTransp = int-logistica-ecommerce.sigla-transp.
   END.


IF siglaTransp = "" THEN
   FOR FIRST int-logistica-ecommerce NO-LOCK
       WHERE int-logistica-ecommerce.cod-estab    = pEstab
         AND int-logistica-ecommerce.estado       = pEstado
         AND int-logistica-ecommerce.cod-emitente = 0:
      ASSIGN codTransp   = int-logistica-ecommerce.cod-transp
             siglaTransp = int-logistica-ecommerce.sigla-transp.
   END.

IF siglaTransp = "" THEN
   FOR FIRST int-logistica-ecommerce NO-LOCK
       WHERE int-logistica-ecommerce.cod-estab    = pEstab
         AND int-logistica-ecommerce.cod-emitente = 0:
      ASSIGN codTransp   = int-logistica-ecommerce.cod-transp
             siglaTransp = int-logistica-ecommerce.sigla-transp.
   END.	   
	   
/* Se nao encontrar retorna pra regra da unidade comercial 0 */
if siglatransp = '' then 	
IF  codTransp <> ? AND codTransp <> 0 THEN DO:
    FOR FIRST int-logistica-ecommerce NO-LOCK
        WHERE int-logistica-ecommerce.cod-transp   = codTransp
          AND int-logistica-ecommerce.cod-estab    = pEstab
          AND int-logistica-ecommerce.cep-inicial <=  cCepDestino
          AND int-logistica-ecommerce.cep-final   >=  cCepDestino:
          ASSIGN siglaTransp = int-logistica-ecommerce.sigla-transp.
    END.

    IF  siglaTransp = "" THEN
        FOR FIRST int-logistica-ecommerce NO-LOCK
            WHERE int-logistica-ecommerce.cod-transp   = codTransp
              AND int-logistica-ecommerce.cod-estab    = pEstab
              AND int-logistica-ecommerce.cidade       = pCidade
              AND int-logistica-ecommerce.estado       = pEstado:
              ASSIGN siglaTransp = int-logistica-ecommerce.sigla-transp.
        END.

    IF  siglaTransp = "" THEN
        FOR FIRST int-logistica-ecommerce NO-LOCK
            WHERE int-logistica-ecommerce.cod-transp   = codTransp
              AND int-logistica-ecommerce.cod-estab    = pEstab
              AND int-logistica-ecommerce.estado       = pEstado:
              ASSIGN siglaTransp = int-logistica-ecommerce.sigla-transp.
        END.

    IF  siglaTransp = "" THEN
        FOR FIRST int-logistica-ecommerce NO-LOCK
            WHERE int-logistica-ecommerce.cod-transp   = codTransp
              AND int-logistica-ecommerce.cod-estab    = pEstab:
              ASSIGN siglaTransp = int-logistica-ecommerce.sigla-transp.
        END.
END.

RETURN "OK":U.
