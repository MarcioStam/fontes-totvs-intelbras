{esp/esapi505.i}    

DEF INPUT  PARAM  p-ordem  AS CHARACTER NO-UNDO.

DEF OUTPUT PARAM  p-operacao AS CHARACTER NO-UNDO.
DEF OUTPUT PARAM  p-result   AS CHARACTER NO-UNDO.

DEF BUFFER bf-las-api-log FOR es-api-log.
DEF BUFFER bf-new-api-log FOR es-api-log.

DEFINE VARIABLE objOperProd           AS JsonObject   NO-UNDO.
DEFINE VARIABLE arrayOperProd         AS jsonArray    NO-UNDO.

DEFINE VARIABLE c-JASON AS longcHAR   NO-UNDO.

DEFINE VARIABLE c-num-op        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-operacoes     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-data-implanta AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-un-tempo      AS CHARACTER  NO-UNDO.




/* Inicio */ 

ASSIGN c-data-implanta = STRING(YEAR(TODAY),'9999') + '-' + STRING(MONTH(TODAY),'99') + '-' + STRING(DAY(TODAY),'99') + 'T' + 
                         STRING(TIME,'HH:MM:SS') + 'Z'.


IF NOT CAN-FIND(FIRST oper-ord 
    WHERE oper-ord.nr-ord-prod = INT(p-ordem)
      AND oper-ord.revisao = 'MES') THEN DO:

    ASSIGN p-operacao = ''
           p-result   = 'Nao encontrada Operacao com MES'.
    RETURN 'ok'.
END.            



FOR EACH oper-ord NO-LOCK 
    WHERE oper-ord.nr-ord-prod = INT(p-ordem)
      AND oper-ord.revisao = 'MES',
    FIRST ITEM WHERE ITEM.it-codigo = oper-ord.it-codigo NO-LOCK,
    FIRST ord-prod WHERE ord-prod.nr-ord-prod = int(p-ordem) NO-LOCK:

    arrayOperProd = NEW JsonArray().
    ASSIGN objOperProd = NEW JsonObject().

 
    ASSIGN c-operacoes = oper-ord.descricao + ';'.



     CASE oper-ord.un-med-tempo:
        WHEN 1 THEN ASSIGN c-un-tempo = 'Horas'.    
        WHEN 2 THEN ASSIGN c-un-tempo = 'Minutos'.
        WHEN 3 THEN ASSIGN c-un-tempo = 'Segundos'.
        WHEN 4 THEN ASSIGN c-un-tempo = 'Dias'.
     END CASE.

    objOperProd:ADD("@odata.etag"              , "4e11c8f9-3ed9-3549-815b-e859c1b0d496").     
    objOperProd:ADD("qtde_refugo"              , 0).
    objOperProd:ADD("ferramenta"               , oper-ord.ferramenta).
    objOperProd:ADD("fator_producao"           , 1).
    objOperProd:ADD("it_codigo"                , oper-ord.it-codigo).
    objOperProd:ADD("un_oper"                  , c-un-tempo).
    objOperProd:ADD("tempo_setup"              , oper-ord.tempo-maquin).
    objOperProd:ADD("descricao"                , oper-ord.descricao).
    objOperProd:ADD("reporte"                  , TRUE).
    objOperProd:ADD("tempo_homem"              , oper-ord.tempo-homem).
    objOperProd:ADD("qtde"                     , int(ord-prod.qt-ordem)).
    objOperProd:ADD("qtde_produzida"           , 0).
    objOperProd:ADD("tempo_maquina"            , oper-ord.tempo-prepar).
    objOperProd:ADD("qtde_pessoas"             , oper-ord.numero-homem).
    objOperProd:ADD("nr_ordem"                 , oper-ord.nr-ord-prod). 
    objOperProd:ADD("cod_recurso"              , oper-ord.centro-aps).
    objOperProd:ADD("cod_operacao"             , oper-ord.op-codigo).
    arrayOperProd:ADD(objOperProd).

    ASSIGN c-JASON = JsonAPIUtils:getJsonArrayChar(arrayOperProd).
    ASSIGN c-operacoes = c-num-op + ';' + c-operacoes.
    
    
    FIND LAST bf-las-api-log 
        WHERE bf-las-api-log.id-api-log > 0
    NO-LOCK NO-ERROR.
    
    FIND FIRST es-api-URI WHERE es-api-URI.id-URI = 'operINTELMES' NO-LOCK.
    
    CREATE es-api-log.
    ASSIGN es-api-log.seqexec        = bf-las-api-log.seqexec  +  10   
           es-api-log.id-aplicacao   = 'MES'
           es-api-log.id-codigo      = c-operacoes
           es-api-log.id-URI         = es-api-URI.id-URI
           es-api-log.dh-request     = NOW
           //es-api-log.end-envio      = bf-las-api-log.end-envio
           es-api-log.flg-processado = NO
           es-api-log.Origem         = es-api-URI.id-URI
           es-api-log.aux            = c-operacoes
           es-api-log.cJson          = c-JASON
           es-api-log.id-api-log     = NEXT-VALUE(seq_api_log). 
    
    ASSIGN lcEnvio = es-api-log.cjson
           lcEnvio = CODEPAGE-CONVERT(lcEnvio, "UTF-8":U).
    
    ASSIGN c-endereco = es-api-URI.ent-PRD.
    
    COPY-LOB lcEnvio TO es-api-log.cl-envio.
    
    IF STRING(lcEnvio) > "" THEN 
       fc-chamada-2().
    
    ASSIGN p-operacao  = c-operacoes
           p-result    = es-api-log.cod-retorno.
END.

/*
ASSIGN c-JASON = JsonAPIUtils:getJsonArrayChar(arrayOperProd).
ASSIGN c-operacoes = c-num-op + ';' + c-operacoes.

MESSAGE string(c-JASON)
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

MESSAGE c-operacoes
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

FIND LAST bf-las-api-log 
    WHERE bf-las-api-log.id-api-log > 0
NO-LOCK NO-ERROR.

FIND FIRST es-api-URI WHERE es-api-URI.id-URI = 'operINTELMES' NO-LOCK.

CREATE es-api-log.
ASSIGN es-api-log.seqexec        = bf-las-api-log.seqexec  +  10   
       es-api-log.id-aplicacao   = 'MES'
       es-api-log.id-codigo      = c-operacoes
       es-api-log.id-URI         = es-api-URI.id-URI
       es-api-log.dh-request     = NOW
       //es-api-log.end-envio      = bf-las-api-log.end-envio
       es-api-log.flg-processado = NO
       es-api-log.Origem         = es-api-URI.id-URI
       es-api-log.aux            = c-operacoes
       es-api-log.cJson          = c-JASON
       es-api-log.id-api-log     = NEXT-VALUE(seq_api_log).


ASSIGN lcEnvio = es-api-log.cjson
       lcEnvio = CODEPAGE-CONVERT(lcEnvio, "UTF-8":U).

ASSIGN c-endereco = es-api-URI.ent-PRD.


COPY-LOB lcEnvio TO es-api-log.cl-envio.


IF STRING(lcEnvio) > "" THEN 
   fc-chamada-2().


ASSIGN p-operacao  = c-operacoes
       p-result    = es-api-log.cod-retorno.
*/

   /*
MESSAGE 'Integra OPERACAO ' SKIP p-operacao SKIP es-api-log.cod-retorno 
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/
     




