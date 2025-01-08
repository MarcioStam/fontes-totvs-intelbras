/*--------------------------------------------------------------------------------
 Programa: espdp044rpba.p
 Autor   : Robinson Rafael Koprowski - SQLWorks
 Data    : 23/10/2008
--------------------------------------------------------------------------------*/

procedure incluiCartao:
    define input  parameter piCod-emitente      as integer      no-undo.
    define input  parameter pcNroCartao         as character    no-undo.
    define input  parameter piSeguranca         as integer      no-undo.
    define input  parameter piOperadora         as integer      no-undo.
    define input  parameter pcTitular           as character    no-undo.
    define input  parameter piValidadeMes       as integer      no-undo.
    define input  parameter piValidadeAno       as integer      no-undo.
    define input  parameter piTipoOrigem        as integer      no-undo. /* b2b=1, b2c=2, outros=0 */
    define output parameter piSeqCartao         as integer      no-undo initial 0.

    define variable cCartaoCripto   as character    no-undo.

    run encryptText in this-procedure (pcNroCartao, output cCartaoCripto).


    if piValidadeAno < 100 then
        assign piValidadeAno = piValidadeAno + 2000.



    find emitente-cartao-cred no-lock
        where emitente-cartao-cred.cod-emitente  = piCod-emitente
          and emitente-cartao-cred.nro-cartao    = cCartaoCripto
          and emitente-cartao-cred.cod-seguranca = piSeguranca
          and emitente-cartao-cred.bandeira      = piOperadora
        no-error.
    if available emitente-cartao-cred then
        assign piSeqCartao = emitente-cartao-cred.sequencia.
    else do:

        find last emitente-cartao-cred no-lock use-index ch_principal
            where emitente-cartao-cred.cod-emitente  = piCod-emitente
            no-error.

        if available emitente-cartao-cred then
            assign piSeqCartao = emitente-cartao-cred.sequencia + 1.
        else
            assign piSeqCartao = 1.

        do transaction on error undo, return 'NOK':
            create emitente-cartao-cred.
            assign emitente-cartao-cred.cod-emitente    = piCod-emitente
                   emitente-cartao-cred.sequencia       = piSeqCartao
                   emitente-cartao-cred.nro-cartao      = cCartaoCripto
                   emitente-cartao-cred.cod-seguranca   = piSeguranca
                   emitente-cartao-cred.bandeira        = piOperadora
                   emitente-cartao-cred.nome-pessoa     = pcTitular
                   emitente-cartao-cred.mes-validade    = piValidadeMes
                   emitente-cartao-cred.ano-validade    = piValidadeAno
                   emitente-cartao-cred.tipo-cartao     = piTipoOrigem.
        end.
    end.

    return 'OK'.
end procedure.

procedure consultaCartao:
    define input  parameter piCod-emitente      as integer      no-undo.
    define input  parameter piSeqCartao         as integer      no-undo.
    define output parameter pcNroCartao         as character    no-undo initial ''.
    define output parameter piSeguranca         as integer      no-undo initial 0.
    define output parameter piOperadora         as integer      no-undo initial 0.
    define output parameter pcTitular           as character    no-undo initial ''.
    define output parameter piValidadeMes       as integer      no-undo initial 0.
    define output parameter piValidadeAno       as integer      no-undo initial 0.
    define output parameter piTipoOrigem        as integer      no-undo initial 0. /* b2b=1, b2c=2, outros=0 */

    define variable cCartaoCripto   as character    no-undo.


    find emitente-cartao-cred no-lock
        where emitente-cartao-cred.cod-emitente  = piCod-emitente
          and emitente-cartao-cred.sequencia     = piSeqCartao
        no-error.
    if available emitente-cartao-cred then do:

        run decryptText in this-procedure (emitente-cartao-cred.nro-cartao, output pcNroCartao).

        assign piSeguranca      = emitente-cartao-cred.cod-seguranca
               piOperadora      = emitente-cartao-cred.bandeira
               pcTitular        = emitente-cartao-cred.nome-pessoa
               piValidadeMes    = emitente-cartao-cred.mes-validade
               piValidadeAno    = emitente-cartao-cred.ano-validade
               piTipoOrigem     = emitente-cartao-cred.tipo-cartao.

    end.
    else
        return 'NOK'.

    return 'OK'.
end procedure.


procedure encryptText:
    /* Programa para Criptografia Progress */

    DEFINE INPUT  PARAMETER ipPlainText     AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER opEncryptedText AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE binary-key     AS RAW.
    DEFINE VARIABLE crypto-value   AS MEMPTR.

    SECURITY-POLICY:SYMMETRIC-ENCRYPTION-ALGORITHM = "DES3_CBC_168".
    /* SECURITY-POLICY:PBE-HASH-ALGORITHM = "MD5".           */
    /* SECURITY-POLICY:ENCRYPTION-SALT = GENERATE-PBE-SALT.  */

    binary-key = GENERATE-PBE-KEY( "I8N2T9E0L1B0R0A0S0B0R0127" ).

    SECURITY-POLICY:SYMMETRIC-ENCRYPTION-KEY = binary-key.
    SECURITY-POLICY:SYMMETRIC-ENCRYPTION-IV = ?.

    crypto-value = ENCRYPT(ipPlainText).
    opEncryptedText = BASE64-ENCODE(crypto-value).

end procedure.


procedure decryptText:
    /* Programa para Criptografia Progress */

    DEFINE INPUT  PARAMETER ipEncryptedText AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER opPlainText     AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE binary-key     AS RAW.
    DEFINE VARIABLE crypto-return  AS MEMPTR.

    SECURITY-POLICY:SYMMETRIC-ENCRYPTION-ALGORITHM = "DES3_CBC_168".
    /* SECURITY-POLICY:PBE-HASH-ALGORITHM = "MD5".           */
    /* SECURITY-POLICY:ENCRYPTION-SALT = GENERATE-PBE-SALT.  */

    binary-key = GENERATE-PBE-KEY( "I8N2T9E0L1B0R0A0S0B0R0127" ).

    SECURITY-POLICY:SYMMETRIC-ENCRYPTION-KEY = binary-key.
    SECURITY-POLICY:SYMMETRIC-ENCRYPTION-IV = ?.

    crypto-return = BASE64-DECODE(ipEncryptedText).
    opPlainText = GET-STRING(DECRYPT(crypto-return),1).

end procedure.
