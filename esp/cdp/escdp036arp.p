{include/i-prgvrs.i escdp036aRP 2.00.00.000}
{include/i-rpvar.i}
{esp/es0018.i}
{utp/ut-glob.i}
{method/dbotterr.i}

DEFINE BUFFER bf-crm-relacionamento-cliente FOR crm-relacionamento-cliente.

DEFINE TEMP-TABLE tt-crm-relacionamento-cliente NO-UNDO
    FIELD cod-emitente    LIKE crm-relacionamento-cliente.cod-emitente
    FIELD cod-rep         LIKE crm-relacionamento-cliente.cod-rep
    FIELD cd-unid-negoc   LIKE crm-relacionamento-cliente.cd-unid-negoc
    FIELD cod-gerente     LIKE crm-relacionamento-cliente.cod-gerente
    FIELD cd-categoria    LIKE crm-relacionamento-cliente.cd-categoria
    FIELD dt-vigencia-ini LIKE crm-relacionamento-cliente.dt-vigencia-ini
    FIELD dt-vigencia-fim LIKE crm-relacionamento-cliente.dt-vigencia-fim
    FIELD observacao      LIKE crm-relacionamento-cliente.observacao
    FIELD linha           AS INTEGER
    /*INDEX idx-pri IS PRIMARY 
          linha 
          cod-emitente
          dt-vigencia-fim*/
          .

define temp-table tt-param
    field destino          as integer
    field arq-destino      as char
    field arq-entrada      as char
    field todos            as integer
    field usuario          as char
    field data-exec        as date
    field hora-exec        as integer.

def temp-table tt-raw-digita
   field raw-digita      as raw.

DEF TEMP-TABLE tt-erro
    FIELD mensagem AS CHAR.

DEF TEMP-TABLE tt-sucesso
    FIELD mensagem AS CHAR.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEF STREAM s-imp.
DEF STREAM s-exp.
DEF VAR h-acomp       AS HANDLE NO-UNDO.
DEF VAR c-linha       AS CHAR NO-UNDO.
DEF VAR c-arquivo-lst AS CHAR.
DEF VAR c-dir-saida   AS CHAR.
DEF VAR c-arq-lst     AS CHAR.
DEFINE VARIABLE i-cont      AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-time AS INTEGER     NO-UNDO.

{include/i-rpout.i &STREAM="stream str-rp" &TOFILE=tt-param.arq-destino}
{include/i-rpcab.i &STREAM="str-rp"}

ASSIGN c-programa 	  = "escdp036aRP"
       c-titulo-relat = "Importaá∆o de metas".

VIEW STREAM str-rp FRAME f-cabec.
VIEW STREAM str-rp FRAME f-rodape.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Importando").

/*Importar*/

INPUT STREAM s-imp FROM VALUE(tt-param.arq-entrada).

blk_import:
REPEAT ON STOP UNDO, LEAVE:
    RUN pi-acompanhar IN h-acomp (INPUT c-linha).

    ASSIGN i-cont = i-cont + 1.

    RUN pi-acompanhar IN h-acomp (INPUT "Importando linha " + STRING(i-cont)).

    CREATE tt-crm-relacionamento-cliente.
    ASSIGN tt-crm-relacionamento-cliente.linha = i-cont.
    IMPORT STREAM s-imp DELIMITER ";" tt-crm-relacionamento-cliente.

    
END.

INPUT STREAM s-imp CLOSE.

ASSIGN i-time = TIME.
/* N∆o busca o £ltimo registro criado, com as informaá‰es em branco! */
FOR EACH tt-crm-relacionamento-cliente
   WHERE tt-crm-relacionamento-cliente.linha < i-cont
   BREAK BY tt-crm-relacionamento-cliente.cod-emitente
         BY tt-crm-relacionamento-cliente.dt-vigencia-ini:
    
    RUN pi-acompanhar IN h-acomp (INPUT "Linha: " + STRING(tt-crm-relacionamento-cliente.linha)).
    
    IF  FIRST-OF(tt-crm-relacionamento-cliente.cod-emitente) THEN DO:
        FIND LAST bf-crm-relacionamento-cliente NO-LOCK
            WHERE bf-crm-relacionamento-cliente.cod-emitente = tt-crm-relacionamento-cliente.cod-emitente NO-ERROR.
        ASSIGN i-sequencia = IF AVAIL bf-crm-relacionamento-cliente THEN bf-crm-relacionamento-cliente.seq ELSE 0.
    END.

    RUN pi-validar-imp.

    IF  RETURN-VALUE = "NOK":U THEN
        NEXT.

    /* S¢ pode ter uma Unidade Comercial vigànte para o Cliente */
    FIND LAST bf-crm-relacionamento-cliente EXCLUSIVE-LOCK
        WHERE bf-crm-relacionamento-cliente.cod-emitente  = tt-crm-relacionamento-cliente.cod-emitente
        AND   bf-crm-relacionamento-cliente.cd-unid-negoc = tt-crm-relacionamento-cliente.cd-unid-negoc
        AND   bf-crm-relacionamento-cliente.dt-vigencia-fim = ? NO-ERROR.
    IF  AVAIL bf-crm-relacionamento-cliente THEN
        ASSIGN bf-crm-relacionamento-cliente.dt-vigencia-fim = tt-crm-relacionamento-cliente.dt-vigencia-ini.

    ASSIGN i-sequencia = i-sequencia + 1.

    CREATE crm-relacionamento-cliente.
    ASSIGN crm-relacionamento-cliente.seq = i-sequencia.
    BUFFER-COPY tt-crm-relacionamento-cliente TO crm-relacionamento-cliente.

    CREATE tt-sucesso.
    ASSIGN tt-sucesso.mensagem = "Importado relacionamento para emitente" + STRING(crm-relacionamento-cliente.cod-emitente) + 
                                                        " representante " + STRING(crm-relacionamento-cliente.cod-rep) + 
                                                   " unidade de negocio " + STRING(crm-relacionamento-cliente.cd-unid-negoc) + 
                                                              " gerente " + STRING(crm-relacionamento-cliente.cod-gerente).
END.

FOR EACH rowErrors:
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = rowErrors.ErrorDescription + " - " +  rowErrors.ErrorHelp.
END.

FOR EACH tt-sucesso:
    PUT STREAM str-rp UNFORMATTED tt-sucesso.mensagem SKIP.
END.

PUT STREAM str-rp SKIP(3).

FOR EACH tt-erro:
    PUT STREAM str-rp UNFORMATTED tt-erro.mensagem SKIP.
END.

{include/i-rpclo.i &STREAM="stream str-rp"}
RUN pi-finalizar IN h-acomp.
RETURN "OK".

PROCEDURE pi-validar-imp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Valida as informaá‰es que est∆o sendo importadas
------------------------------------------------------------------------------*/

    IF  tt-crm-relacionamento-cliente.cod-emitente = 0 THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Cliente n∆o informado."
               rowErrors.ErrorHelp        = "C¢digo do Cliente deve ser informado! Linha: " + STRING(tt-crm-relacionamento-cliente.linha).
        RETURN "NOK":U.
    END.
    ELSE DO:
        IF  NOT CAN-FIND(FIRST emitente NO-LOCK
                         WHERE emitente.cod-emitente = tt-crm-relacionamento-cliente.cod-emitente) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Cliente inv†lido (" + STRING(tt-crm-relacionamento-cliente.cod-emitente) + ")!"
                   rowErrors.ErrorHelp        = "Cliente informado n∆o est† cadastrado! Linha: " + STRING(tt-crm-relacionamento-cliente.linha).
            RETURN "NOK":U.
        END.
    END.


    IF  tt-crm-relacionamento-cliente.cod-rep = 0 THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Representante n∆o informado."
               rowErrors.ErrorHelp        = "Representante deve ser informado! Linha: " + STRING(tt-crm-relacionamento-cliente.linha).
        RETURN "NOK":U.
    END.
    ELSE DO:
        IF  NOT CAN-FIND(FIRST repres NO-LOCK
                         WHERE repres.cod-rep = tt-crm-relacionamento-cliente.cod-rep) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Representante inv†lido (" + STRING(tt-crm-relacionamento-cliente.cod-rep) + ")!"
                   rowErrors.ErrorHelp        = "Representante informado n∆o est† cadastrado! Linha: " + STRING(tt-crm-relacionamento-cliente.linha).
            RETURN "NOK":U.
        END.
    END.

    IF  tt-crm-relacionamento-cliente.cd-unid-negoc = "0" OR
        tt-crm-relacionamento-cliente.cd-unid-negoc = "" THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Unidade Comercial n∆o informada."
               rowErrors.ErrorHelp        = "Unidade Comercial deve ser informada! Linha: " + STRING(tt-crm-relacionamento-cliente.linha).
        RETURN "NOK":U.
    END.
    ELSE DO:
        IF  NOT CAN-FIND(FIRST unid-comerc NO-LOCK
                         WHERE unid-comerc.cd-unid-comerc = INT(tt-crm-relacionamento-cliente.cd-unid-negoc)) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Unidade Comercial inv†lida (" + tt-crm-relacionamento-cliente.cd-unid-negoc + ")!"
                   rowErrors.ErrorHelp        = "Unidade Comercial informada n∆o est† cadastrada! Linha: " + STRING(tt-crm-relacionamento-cliente.linha).
            RETURN "NOK":U.
        END.
    END.


    IF  tt-crm-relacionamento-cliente.cd-categoria = 0 THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Categoria n∆o informada."
               rowErrors.ErrorHelp        = "Categoria deve ser informada! Linha: " + STRING(tt-crm-relacionamento-cliente.linha).
        RETURN "NOK":U.
    END.
    ELSE DO:
        IF  NOT CAN-FIND(FIRST crm-categoria NO-LOCK
                         WHERE crm-categoria.cd-categoria = tt-crm-relacionamento-cliente.cd-categoria) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Categoria inv†lida (" + STRING(tt-crm-relacionamento-cliente.cd-categoria) + ")!"
                   rowErrors.ErrorHelp        = "Categoria informada n∆o est† cadastrada! Linha: " + STRING(tt-crm-relacionamento-cliente.linha).
            RETURN "NOK":U.
        END.
    END.


    IF  tt-crm-relacionamento-cliente.dt-vigencia-ini = ? THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Vigància Inicial n∆o informada!"
               rowErrors.ErrorHelp        = "Vigància Inicial deve ser informada! Linha: " + STRING(tt-crm-relacionamento-cliente.linha).
        RETURN "NOK":U.
    END.


    /* Valida se o Usu†rio tem cadastrada essa Unidade Comercial */
    IF  NOT CAN-FIND(FIRST int-user-coml NO-LOCK
                     WHERE int-user-coml.cd-usuario    = c-seg-usuario
                     AND   int-user-coml.cd-unid-negoc = STRING(tt-crm-relacionamento-cliente.cd-unid-negoc)) THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Usu†rio sem relacionamento com a Unidade Comercial!"
               rowErrors.ErrorHelp        = "Usu†rio sem relacionamento com a Unidade Comercial! Linha: " + STRING(tt-crm-relacionamento-cliente.linha).
        RETURN "NOK":U.
    END.
    /* Fim cadastro usu†rio */

    /* Validaá∆o entre Categoria x Unidade Neg¢cio */
    IF  NOT CAN-FIND(FIRST crm-categ-un NO-LOCK
                     WHERE crm-categ-un.cd-categoria  = tt-crm-relacionamento-cliente.cd-categoria
                     AND   crm-categ-un.cd-unid-negoc = tt-crm-relacionamento-cliente.cd-unid-negoc) THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "N∆o foi encontrada relaá∆o Categoria x Unidade Comercial!"
               rowErrors.ErrorHelp        = "N∆o foi encontrado relacionamento entre Categoria x Unidade Comercial! Linha: " + STRING(tt-crm-relacionamento-cliente.linha).
        RETURN "NOK":U.
    END.

    /* Valida se j† existe outro Representante informado para a Unidade de Neg¢cio */
    FIND FIRST crm-relacionamento-cliente NO-LOCK
        WHERE  crm-relacionamento-cliente.cod-emitente  = tt-crm-relacionamento-cliente.cod-emitente
        AND    crm-relacionamento-cliente.cd-unid-negoc = tt-crm-relacionamento-cliente.cd-unid-negoc NO-ERROR.
    IF  AVAIL  crm-relacionamento-cliente THEN DO:
        IF  crm-relacionamento-cliente.dt-vigencia-fim   <> ? AND
            tt-crm-relacionamento-cliente.dt-vigencia-ini < crm-relacionamento-cliente.dt-vigencia-fim THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Faixa de Datas pertence a outra Vigància!"
                   rowErrors.ErrorHelp        = "A faixa de data informada est† entre outra Vigància j† cadastrada! Linha: " + STRING(tt-crm-relacionamento-cliente.linha).
            RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
