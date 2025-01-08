/****************************************************************************************************
** Autor: Isac Abrahao
**
** Objetivo: API Retorno Grupo de Usuarios Totvs 
**
** Data: 30/06/2021
**
****************************************************************************************************/
{utp/ut-api.i}
{utp/ut-api-utils.i}        /*
{fwk/utils/fndApiServices.i}  */
{utp/ut-api-action.i piGrupUsuar POST /~*}
{utp/ut-api-notfound.i} 

{esp/es0018.i}
/****************************************************************************************************/
/****************************************************************************************************/
/****************************************************************************************************/
PROCEDURE piGrupUsuar:

    DEFINE INPUT  PARAMETER jsonInput   AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER jsonOutput  AS JsonObject NO-UNDO.    

    DEFINE VARIABLE jsonObjectOutput        AS JsonObject   NO-UNDO.
    DEFINE VARIABLE jsonObjectPayload       AS jsonObject   NO-UNDO.

    DEFINE VARIABLE objGrupUsuar          AS JsonObject   NO-UNDO.
    DEFINE VARIABLE arrayGrupUsuar        AS jsonArray    NO-UNDO.
    
    DEFINE VARIABLE codProg         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-prog          AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-retorna-grupo AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE i-cont          AS INTEGER   NO-UNDO.

    IF jsonInput:has("payload") THEN DO:
       ASSIGN jsonObjectPayload    = jsonInput:GetJsonObject("payload").
         
       ASSIGN codProg = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "codPrograma").
    END.

    ASSIGN arrayGrupUsuar  = NEW JsonArray().
    
    FOR EACH prog_dtsul_segur NO-LOCK
        WHERE prog_dtsul_segur.cod_prog_dtsul = codProg ,
        FIRST prog_dtsul NO-LOCK 
        WHERE prog_dtsul.cod_prog_dtsul = prog_dtsul_segur.cod_prog_dtsul,
        FIRST grp_usuar WHERE grp_usuar.cod_grp_usuar = prog_dtsul_segur.cod_grp_usuar NO-LOCK
        BREAK BY grp_usuar.cod_grp_usuar:

        ASSIGN l-prog  = YES.

        FOR EACH tt-prog-ponto: DELETE tt-prog-ponto. END.

        RUN esp/es0018p.p (INPUT "api-gr-usuar":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        ASSIGN l-retorna-grupo = NO. 

        FOR EACH tt-prog-ponto:
            DO i-cont = 1 TO NUM-ENTRIES(tt-prog-ponto.conteudo,';'):
               IF ENTRY(i-cont,tt-prog-ponto.conteudo,';') = grp_usuar.cod_grp_usuar THEN 
                  ASSIGN l-retorna-grupo = YES. 
            END.
        END.

        IF NOT l-retorna-grupo THEN NEXT.

        ASSIGN objGrupUsuar  = NEW JsonObject(). 

        objGrupUsuar:ADD("CodGrupo",STRING(grp_usuar.cod_grp_usuar)).
        objGrupUsuar:ADD("DesGrupo",STRING(grp_usuar.des_grp_usuar)). 

        arrayGrupUsuar:ADD(objGrupUsuar).
    END.

    IF NOT l-prog THEN DO:
       ASSIGN objGrupUsuar  = NEW JsonObject(). 

       objGrupUsuar:ADD("CodGrupo",'Erro').
       objGrupUsuar:ADD("DesGrupo",'Codigo do programa nao localizado!'). 

       arrayGrupUsuar:ADD(objGrupUsuar).
    END.
    
    jsonObjectOutput = NEW jsonObject().
    jsonObjectOutput:ADD("GrupoUsuarios", arrayGrupUsuar ).
    
    RUN createJsonResponse(INPUT jsonObjectOutput, INPUT TABLE rowErrors, INPUT false, OUTPUT jsonOutput).

END PROCEDURE.


