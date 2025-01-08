/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*:T*******************************************************************************
**
**  Programa.: Importa Relacionamento - Unidade Comercial
**  Objetivo.: Relat¢rio.
**  Cria‡Æo..: 04/2016
**  VersÆo...: Rubia (Sensus).
**
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCDP031C 1.12.00.001}
{utp/ut-glob.i}
{include/i-rpvar.i}
{esp/es0018.i}

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    FIELD arq-entrada      AS CHAR FORMAT "x(160)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG.
    /*Fim alteracao 15/02/2005*/

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-crm-desc-prod-imp NO-UNDO
    FIELD cd-unid-negoc   LIKE crm-desc-prod.cd-unid-negoc
    FIELD cod-gr-cli      LIKE crm-desc-prod.cod-gr-cli
    FIELD cd-categoria    LIKE crm-desc-prod.cd-categoria
    FIELD it-codigo       LIKE crm-desc-prod.it-codigo
    FIELD dt-vigencia-ini LIKE crm-desc-prod.dt-vigencia-ini
    FIELD dt-vigencia-fim LIKE crm-desc-prod.dt-vigencia-fim
    FIELD pc-desconto     LIKE crm-desc-prod.pc-desconto
    FIELD linha           AS INTEGER.

define buffer b-tt-digita for tt-digita.

Define Temp-table RowErrors No-undo 
    Field ErrorSequence    As Integer 
    Field ErrorNumber      As Integer 
    Field ErrorDescription As Character 
    Field ErrorParameters  As Character 
    Field ErrorType        As Character 
    Field ErrorHelp        As Character 
    Field ErrorSubType     As Character.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita  AS RAW.

/* Local Variables Definitions ---                                      */
DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-cont          AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-arq-entrada   AS CHARACTER   NO-UNDO.

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri: END.

FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Importa Relacionamento - Unidade Comercial"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCDP031C"
       c-versao       = "2.00"
       c-revisao      = "001".

DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i}

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    RUN utp/ut-acomp.p persistent set h-acomp.  
    RUN pi-inicializar in h-acomp (input "Executando...").

    RUN pi-executar.

    FOR EACH rowErrors NO-LOCK:
        PUT rowErrors.ErrorDescription ' - ' rowErrors.ErrorHelp  FORMAT "x(256)" SKIP.
    END.
    PUT "Importa‡Æo conclu¡da!" SKIP.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
    {include/i-rpclo.i}
    
    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.
    ASSIGN h-acomp = ?.
    
    RETURN "OK":U.
   
END.

PROCEDURE pi-executar:

    DEF VAR c-arq-entrada-unix    AS CHAR NO-UNDO.
    DEF VAR c-arq-entrada-windows AS CHAR NO-UNDO.

    EMPTY TEMP-TABLE tt-prog-ponto.
    
    RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-arq-entrada-unix = tt-prog-ponto.conteudo. 
    END.

    RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    FOR FIRST tt-prog-ponto:
        ASSIGN c-arq-entrada-windows = tt-prog-ponto.conteudo. 
    END.

    IF  OPSYS = "UNIX":U 
    THEN ASSIGN c-arq-entrada = REPLACE(tt-param.arq-entrada, c-arq-entrada-windows, c-arq-entrada-unix)
                c-arq-entrada = REPLACE(c-arq-entrada, "\":U, "/":U).
    ELSE ASSIGN c-arq-entrada = REPLACE(tt-param.arq-entrada, "/":U, "\":U).

    /* Importa as Notas de um arquivo */
    INPUT FROM VALUE(c-arq-entrada) NO-ECHO.
    REPEAT:
        ASSIGN i-cont = i-cont + 1.

        CREATE tt-crm-desc-prod-imp.
        ASSIGN tt-crm-desc-prod-imp.linha = i-cont.
        IMPORT DELIMITER ";" tt-crm-desc-prod-imp.
    END.
    INPUT CLOSE.

    /* Efetiva‡Æo dos dados */
    /* NÆo busca o £ltimo registro criado, com as informa‡äes em branco! */
    FOR EACH  tt-crm-desc-prod-imp EXCLUSIVE-LOCK
        WHERE tt-crm-desc-prod-imp.linha < i-cont
        BY    tt-crm-desc-prod-imp.linha:

        RUN pi-acompanhar IN h-acomp (INPUT "GrCli: " + string(tt-crm-desc-prod-imp.cod-gr-cli) + " Cat: " + 
                                            string(tt-crm-desc-prod-imp.cd-categoria) + " Item: " + tt-crm-desc-prod-imp.it-codigo).

        RUN pi-validar-imp IN THIS-PROCEDURE.
        IF  RETURN-VALUE = "NOK":U THEN
            NEXT.

        /* Necess rio para manter o hist¢rio do desconto */
        FIND LAST crm-desc-prod EXCLUSIVE-LOCK
            WHERE crm-desc-prod.cd-unid-negoc   = tt-crm-desc-prod-imp.cd-unid-negoc
            AND   crm-desc-prod.cod-gr-cli      = tt-crm-desc-prod-imp.cod-gr-cli
            AND   crm-desc-prod.cd-categoria    = tt-crm-desc-prod-imp.cd-categoria
            AND   crm-desc-prod.it-codigo       = tt-crm-desc-prod-imp.it-codigo NO-ERROR.
        IF  AVAIL crm-desc-prod AND crm-desc-prod.dt-vigencia-fim = ? THEN
            ASSIGN crm-desc-prod.dt-vigencia-fim = tt-crm-desc-prod-imp.dt-vigencia-ini.
        
        CREATE crm-desc-prod.
        BUFFER-COPY tt-crm-desc-prod-imp TO crm-desc-prod.
    END.

END PROCEDURE.

PROCEDURE pi-validar-imp:

    IF  tt-crm-desc-prod-imp.cd-unid-negoc = "0" OR
        tt-crm-desc-prod-imp.cd-unid-negoc = "" THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Unidade Comercial nÆo informada."
               rowErrors.ErrorHelp        = "Unidade Comercial deve ser informada! Linha: " + STRING(tt-crm-desc-prod-imp.linha).
        RETURN "NOK":U.
    END.
    ELSE DO:
        IF  NOT CAN-FIND(FIRST unid-comerc NO-LOCK
                         WHERE unid-comerc.cd-unid-comerc = INT(tt-crm-desc-prod-imp.cd-unid-negoc)) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Unidade Comercial inv lida (" + tt-crm-desc-prod-imp.cd-unid-negoc + ")!"
                   rowErrors.ErrorHelp        = "Unidade Comercial informada nÆo est  cadastrada! Linha: " + STRING(tt-crm-desc-prod-imp.linha).
            RETURN "NOK":U.
        END.
    END.


    IF  tt-crm-desc-prod-imp.cd-categoria = 0 THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Categoria nÆo informada."
               rowErrors.ErrorHelp        = "Categoria deve ser informada! Linha: " + STRING(tt-crm-desc-prod-imp.linha).
        RETURN "NOK":U.
    END.
    ELSE DO:
        IF  NOT CAN-FIND(FIRST crm-categoria NO-LOCK
                         WHERE crm-categoria.cd-categoria = tt-crm-desc-prod-imp.cd-categoria) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Categoria inv lida (" + STRING(tt-crm-desc-prod-imp.cd-categoria) + ")!"
                   rowErrors.ErrorHelp        = "Categoria informada nÆo est  cadastrada! Linha: " + STRING(tt-crm-desc-prod-imp.linha).
            RETURN "NOK":U.
        END.
    END.


    IF  tt-crm-desc-prod-imp.cod-gr-cli = 0 THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Grupo de cliente nÆo informado."
               rowErrors.ErrorHelp        = "C¢digo do Grupo do Cliente deve ser informado! Linha: " + STRING(tt-crm-desc-prod-imp.linha).
        RETURN "NOK":U.
    END.
    ELSE DO:
        IF  NOT CAN-FIND(FIRST gr-cli NO-LOCK
                         WHERE gr-cli.cod-gr-cli = tt-crm-desc-prod-imp.cod-gr-cli) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Grupo de Cliente inv lido (" + STRING(tt-crm-desc-prod-imp.cod-gr-cli) + ")!"
                   rowErrors.ErrorHelp        = "Grupo de Cliente informado nÆo est  cadastrado! Linha: " + STRING(tt-crm-desc-prod-imp.linha).
            RETURN "NOK":U.
        END.
    END.


    IF  NOT CAN-FIND(FIRST item NO-LOCK
                     WHERE item.it-codigo = tt-crm-desc-prod-imp.it-codigo) THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Item inv lido (" + STRING(tt-crm-desc-prod-imp.it-codigo) + ")!"
               rowErrors.ErrorHelp        = "Item informado nÆo est  cadastrado! Linha: " + STRING(tt-crm-desc-prod-imp.linha).
        RETURN "NOK":U.
    END.


    IF  tt-crm-desc-prod-imp.dt-vigencia-ini = ? THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Vigˆncia Inicial nÆo informada!"
               rowErrors.ErrorHelp        = "Vigˆncia Inicial deve ser informada! Linha: " + STRING(tt-crm-desc-prod-imp.linha).
        RETURN "NOK":U.
    END.


    /* Valida‡Æo entre Categoria x Unidade Neg¢cio */
    IF  NOT CAN-FIND(FIRST crm-categ-un NO-LOCK
                     WHERE crm-categ-un.cd-categoria  = tt-crm-desc-prod-imp.cd-categoria
                     AND   crm-categ-un.cd-unid-negoc = tt-crm-desc-prod-imp.cd-unid-negoc) THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "NÆo foi encontrada rela‡Æo Categoria x Unidade Comercial!"
               rowErrors.ErrorHelp        = "NÆo foi encontrado relacionamento entre Categoria x Unidade Comercial! Linha: " + STRING(tt-crm-desc-prod-imp.linha).
        RETURN "NOK":U.
    END.

    /* Valida se j  existe o relacionamento entre a Unidade de Neg¢cio e Categoria */
    IF  CAN-FIND(FIRST crm-desc-prod NO-LOCK
                 WHERE crm-desc-prod.cd-unid-negoc   = tt-crm-desc-prod-imp.cd-unid-negoc
                 AND   crm-desc-prod.cod-gr-cli      = tt-crm-desc-prod-imp.cod-gr-cli
                 AND   crm-desc-prod.cd-categoria    = tt-crm-desc-prod-imp.cd-categoria
                 AND   crm-desc-prod.it-codigo       = tt-crm-desc-prod-imp.it-codigo
                 AND   crm-desc-prod.dt-vigencia-ini = tt-crm-desc-prod-imp.dt-vigencia-ini) THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "J  existe um Desconto por Produto!"
               rowErrors.ErrorHelp        = "J  existe um Desconto por Produto! Linha: " + STRING(tt-crm-desc-prod-imp.linha).
        RETURN "NOK":U.
    END.

END PROCEDURE.

