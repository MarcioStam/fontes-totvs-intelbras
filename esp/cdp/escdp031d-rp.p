/********************************************************************************
**  Programa.: Elimina‡Æo tabela crm-desc-prod 
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCDP031D 1}
{utp/ut-glob.i}
{include/i-rpvar.i}

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    FIELD cd-unid-comerc   AS INTEGER
    FIELD c-desc-unid-com  AS CHAR FORMAT "x(50)"
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG.
    /*Fim alteracao 15/02/2005*/

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

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

DEF VAR i-registros AS INT NO-UNDO.
DEF VAR i AS INT NO-UNDO.

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
       c-titulo-relat = "Elimina‡Æo Desconto por Produto, por Unidade Neg¢cio X Grupo Cliente X Categoria"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCDP031D"
       c-versao       = "2.00"
       c-revisao      = "001".

DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i}

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    RUN utp/ut-acomp.p persistent set h-acomp.  
    RUN pi-inicializar in h-acomp (input "Executando Elimina‡Æo").

    RUN pi-executar.

    PUT "    Unidade Comercial: " string(tt-param.cd-unid-comer) + " - " + tt-param.c-desc-unid-com SKIP(2).

    IF  i > 0 AND i = i-registros THEN
        PUT "Elimina‡Æo conclu¡da!" SKIP
            "Todal de registros eliminados: " string(STRING(i) + " de " + STRING(i-registros)) SKIP.
    ELSE
        PUT "Nenhum registro eliminado. Verifique a existˆncia de registros para a Unidade Comercial." SKIP.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
    {include/i-rpclo.i}
    
    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.
    ASSIGN h-acomp = ?.
    
    RETURN "OK":U.
   
END.

PROCEDURE pi-executar:

    /* Elimina‡Æo dos dados */
    FOR EACH  crm-desc-prod NO-LOCK
        WHERE crm-desc-prod.cd-unid-negoc = string(tt-param.cd-unid-comerc):
        ASSIGN i-registros = i-registros + 1.
    END.
    
    FOR EACH  crm-desc-prod EXCLUSIVE-LOCK
        WHERE crm-desc-prod.cd-unid-negoc = string(tt-param.cd-unid-comerc):
       
        DELETE crm-desc-prod.
        ASSIGN i = i + 1.

        RUN pi-acompanhar IN h-acomp (INPUT "Eliminando registro " + STRING(i) + " de " + STRING(i-registros)).
        
     END.

END PROCEDURE.

