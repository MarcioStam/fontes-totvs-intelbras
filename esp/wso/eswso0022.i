DEFINE VARIABLE jsonObjectOutput    AS JsonObject NO-UNDO.
DEFINE VARIABLE jsonObjectPayload   AS jsonObject NO-UNDO.
DEFINE VARIABLE objEmit             AS JsonObject NO-UNDO.
DEFINE VARIABLE objGrupoEcon        AS JsonObject NO-UNDO.
DEFINE VARIABLE arrayGrupoEcon      AS jsonArray  NO-UNDO.
DEFINE VARIABLE objCanalVenda       AS JsonObject NO-UNDO.
DEFINE VARIABLE objCanalVenda2      AS JsonObject NO-UNDO.
DEFINE VARIABLE arrayCanalVenda     AS jsonArray  NO-UNDO.
DEFINE VARIABLE objInfComp          AS JsonObject NO-UNDO.
DEFINE VARIABLE objInfGrupo         AS JsonObject NO-UNDO.
DEFINE VARIABLE arrayInfGrupo       AS jsonArray  NO-UNDO.
DEFINE VARIABLE objInfCanal         AS JsonObject NO-UNDO.
DEFINE VARIABLE arrayInfCanal       AS jsonArray  NO-UNDO.
DEFINE VARIABLE objGrupRegInf       AS JsonObject NO-UNDO.
DEFINE VARIABLE jsonArrayPayload    AS jsonArray  NO-UNDO.

DEF VAR c-jason       AS LONGCHAR            NO-UNDO.
DEF VAR i_cont        AS INT                 NO-UNDO.
DEF VAR c-msg         AS CHAR FORMAT "x(7)"  NO-UNDO.
DEF VAR v_tipo_pessoa AS CHAR FORMAT "x(20)" NO-UNDO.

/****************************************************************************************************/

PROCEDURE pi-gera-json.

    FIND FIRST emitente
        WHERE emitente.cod-emit = p_cod_emit NO-LOCK NO-ERROR.

    IF  AVAIL emitente THEN DO:

        FIND FIRST int-emitente NO-LOCK
             WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

        ASSIGN v_tipo_pessoa = IF emitente.natureza = 1 THEN "Pessoa Fisica" ELSE "Pessoa Juridica".

        objEmit = NEW JsonObject().
    
        objEmit:ADD("documentNumber", string(emitente.cgc)).
        objEmit:ADD("nature", v_tipo_pessoa).
        objEmit:ADD("customerCode", string(emitente.cod-emit)).
        objEmit:ADD("corporateName", emitente.nome-emit).
        objEmit:ADD("fantasyName", emitente.nome-abrev).
        objEmit:ADD("stateRegistration", "isento").
        /*objEmit:ADD("dateOfEstablishment", emitente.data-implant "1992-08-31").*/
        objEmit:ADD("addressDistrict", emitente.bairro).
        objEmit:ADD("addressCep", string(emitente.cep)).
        objEmit:ADD("addressComplement", "").
        objEmit:ADD("addressStreet", emitente.endereco).
        objEmit:ADD("addressCity", emitente.cidade).
        objEmit:ADD("addressNumber", "").
        objEmit:ADD("addressState", emitente.estado).
        objEmit:ADD("addressCountry", emitente.pais).
        objEmit:ADD("economicGroupCode", emitente.nome-matriz).

        /* canal venda */
        arrayCanalVenda = NEW JsonArray().
    
        /*
        objCanalVenda = NEW JsonObject().
    
        /* desassocia canal de venda */
        objCanalVenda:ADD("billingGroupCode", "5").
        objCanalVenda:ADD("isDeleted", "True").
        
        arrayCanalVenda:ADD(objCanalVenda).
        */

        objCanalVenda2 = NEW JsonObject().
    
        /* associa canal de venda */
        objCanalVenda2:ADD("billingGroupCode", string(int-emitente.cod-gr-cob)).
        objCanalVenda2:ADD("isDeleted", "False").
    
        arrayCanalVenda:ADD(objCanalVenda2).
    
        objEmit:ADD("SalesChannel", arrayCanalVenda).
    
    
        /* inf complementares */
        /* grupo */
        objInfComp = NEW JsonObject().
        
        arrayInfGrupo = NEW JsonArray().
    
        objInfGrupo = NEW JsonObject().
    
        objInfGrupo:ADD("economicGroupCode", emitente.nome-matriz).
        objInfGrupo:ADD("name", emitente.nome-matriz).
    
        arrayInfGrupo:ADD(objInfGrupo).
    
        objInfComp:ADD("EconomicGroup", (arrayInfGrupo)).
    
    
        /* saleschannel */
        arrayInfCanal = NEW JsonArray().
    
        objInfCanal = NEW JsonObject().
    
        objInfCanal:ADD("billingGroupCode", string(int-emitente.cod-gr-cob)).
        objInfCanal:ADD("name", string(int-emitente.cod-gr-cob)).
    
        objGrupRegInf = NEW JsonObject().
    
        objGrupRegInf:ADD("name", "INTELBRAS").
        objGrupRegInf:ADD("subGroupCode", string(int-emitente.cod-gr-cob)).
        objGrupRegInf:ADD("nameSubGroup", "CANAL DE VENDAS").
    
        objInfCanal:ADD("GroupRegistrionInformation", (objGrupRegInf)).
    
        arrayInfCanal:ADD(objInfCanal).
    
        objInfComp:ADD("SalesChannel", (arrayInfCanal)).
    
        objEmit:ADD("ComplementaryRegisters", objInfComp).
    END.

    ASSIGN c-jason = objEmit:getjsontext().

END PROCEDURE. 
