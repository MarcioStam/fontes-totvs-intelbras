/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESFTP132RP 2.06.00.000}

/*------------------------------------------------------------------------
    File        : ESFTP132RP.P
    Description : 

    Author(s)   : 
    Created     : 
    Notes       : 
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Preprocessor Definitions ---                                         */

&GLOBAL-DEFINE PRINT-PARAM  YES

/* Include Definitions ---                                              */

/* Defini‡Æo das temp-tables tt-param, tt-digita e tt-raw-digita */

{utp/utapi019.i}
{utp/ut-glob.i} 
{esp/es0018.i}

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD id-conta-ini     AS INT
    FIELD id-conta-fim     AS INT
    FIELD dt-venc-ini      AS DATE
    FIELD dt-venc-fim      AS DATE.

DEFINE TEMP-TABLE tt-registros
    FIELD id-recorrencia LIKE int-recorrencia-contratos.id-recorrencia 
    FIELD nr-contrato    LIKE int-recorrencia-contratos.nr-contrato 
    FIELD nr-parcela     LIKE int-recorrencia-contratos.nr-parcela  
    FIELD dt-venc        LIKE int-recorrencia-contratos.dt-venc
    FIELD nr-pedido      LIKE int-recorrencia-notas.nr-pedido   
    FIELD cod-estabel    LIKE int-recorrencia-notas.cod-estabel 
    FIELD serie          LIKE int-recorrencia-notas.serie       
    FIELD nr-nota-fis    LIKE int-recorrencia-notas.nr-nota-fis 
    FIELD dt-emis-nota   LIKE int-recorrencia-notas.dt-emis-nota
    FIELD valor          LIKE int-recorrencia-notas.valor.

{include/i-rpvar.i}

/* Local Temp-Table Definitions ---                                     */
DEFINE VARIABLE h-acomp     AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-excel     AS CHARACTER   NO-UNDO.

DEFINE STREAM str-excel.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.

/* ************************  Function Prototypes ********************** */

/* ***************************  Main Block  *************************** */

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

FIND FIRST param-global NO-LOCK NO-ERROR.

assign c-programa     = "ESFTP132"
       c-sistema      = "NF Recorrencia"
       c-titulo-relat = "NF Recorrencia"
       c-versao       = "2.06.00"
       c-revisao      = "000"
       c-empresa      = "Intelbras".

FIND FIRST tt-param NO-LOCK NO-ERROR.

//ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}.

DO ON ERROR UNDO, RETURN ERROR
   ON STOP  UNDO, RETURN ERROR:
    {include/i-rpcab.i &STREAM="str-rp"}
    {include/i-rpout.i &STREAM="STREAM str-rp"}

    VIEW STREAM str-rp FRAME f-cabec.
    VIEW STREAM str-rp FRAME f-rodape.

    IF NOT VALID-HANDLE(h-acomp)               OR
       h-acomp:TYPE      <> "PROCEDURE":U      OR
       h-acomp:FILE-NAME <> "utp/ut-acomp.p":U THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "":U).

    FOR EACH int-recorrencia-contratos NO-LOCK
       WHERE int-recorrencia-contratos.id-recorrencia >= STRING(tt-param.id-conta-ini)
         AND int-recorrencia-contratos.id-recorrencia <= STRING(tt-param.id-conta-fim)
         AND int-recorrencia-contratos.dt-venc        >= tt-param.dt-venc-ini  
         AND int-recorrencia-contratos.dt-venc        <= tt-param.dt-venc-fim:

        IF NOT CAN-FIND(FIRST int-recorrencia-notas
                        WHERE int-recorrencia-notas.id-recorrencia = int-recorrencia-contratos.id-recorrencia
                          AND int-recorrencia-notas.nr-contrato    = int-recorrencia-contratos.nr-contrato   
                          AND int-recorrencia-notas.nr-parcela     = int-recorrencia-contratos.nr-parcela    
                          AND int-recorrencia-notas.nr-transacao   = int-recorrencia-contratos.nr-transacao) THEN DO:
            CREATE tt-registros.
            ASSIGN tt-registros.id-recorrencia = int-recorrencia-contratos.id-recorrencia
                   tt-registros.nr-contrato    = int-recorrencia-contratos.nr-contrato 
                   tt-registros.nr-parcela     = int-recorrencia-contratos.nr-parcela.
        END.
        ELSE DO:
            FOR EACH int-recorrencia-notas NO-LOCK
               WHERE int-recorrencia-notas.id-recorrencia = int-recorrencia-contratos.id-recorrencia
                 AND int-recorrencia-notas.nr-contrato    = int-recorrencia-contratos.nr-contrato   
                 AND int-recorrencia-notas.nr-parcela     = int-recorrencia-contratos.nr-parcela    
                 AND int-recorrencia-notas.nr-transacao   = int-recorrencia-contratos.nr-transacao:
                CREATE tt-registros.
                ASSIGN tt-registros.id-recorrencia = int-recorrencia-contratos.id-recorrencia
                       tt-registros.nr-contrato    = int-recorrencia-contratos.nr-contrato 
                       tt-registros.nr-parcela     = int-recorrencia-contratos.nr-parcela  
                       tt-registros.dt-venc        = int-recorrencia-contratos.dt-venc  
                       tt-registros.nr-pedido      = int-recorrencia-notas.nr-pedido   
                       tt-registros.cod-estabel    = int-recorrencia-notas.cod-estabel 
                       tt-registros.serie          = int-recorrencia-notas.serie       
                       tt-registros.nr-nota-fis    = int-recorrencia-notas.nr-nota-fis 
                       tt-registros.dt-emis-nota   = int-recorrencia-notas.dt-emis-nota
                       tt-registros.valor          = int-recorrencia-notas.valor.
            END.
        END.
    END.

    RUN pi-gera-arquivo-csv. // CRIA NOME ARQUIVO CSV

    OUTPUT STREAM str-excel TO VALUE(c-excel) CONVERT TARGET "iso8859-1".
    PUT STREAM str-excel
        "Id;Contrato;Parcela;Dt Venc;Pedido;Estab;Serie;NF;Dt Emis;Valor" SKIP.
    
    FOR EACH tt-registros NO-LOCK:
        PUT STREAM str-excel
            tt-registros.id-recorrencia ";"
            tt-registros.nr-contrato    ";"
            tt-registros.nr-parcela     ";"
            tt-registros.dt-venc        ";"
            tt-registros.nr-pedido      ";"
            tt-registros.cod-estabel    ";"
            tt-registros.serie          ";"
            tt-registros.nr-nota-fis    ";"
            tt-registros.dt-emis-nota   ";"
            tt-registros.valor          ";"
            SKIP.
    END.
    OUTPUT STREAM str-excel CLOSE.   
    
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    {include/i-rpclo.i &STREAM="STREAM str-rp"}

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.
END.

PROCEDURE pi-gera-arquivo-csv:

    EMPTY TEMP-TABLE tt-prog-ponto.

    IF OPSYS = "UNIX" THEN DO:
        RUN esp/es0018p.p (INPUT "spool-unix", /* Nome do programa */
                           INPUT 1,           /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.
        FOR FIRST tt-prog-ponto NO-LOCK:
    
            ASSIGN c-excel = tt-prog-ponto.conteudo + "~/" + v_cod_usuar_corren + "~/".
    
            OS-CREATE-DIR VALUE(c-excel).
    
            ASSIGN c-excel = c-excel + "ESFTP132" + ".csv".
            
        END.
    
    END.
    ELSE DO:
        RUN esp/es0018p.p (INPUT "spool-win", /* Nome do programa */
                           INPUT 1,          /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
        FOR FIRST tt-prog-ponto NO-LOCK:
    
            ASSIGN c-excel = tt-prog-ponto.conteudo + "~\" + v_cod_usuar_corren + "~\".
    
            OS-CREATE-DIR VALUE(c-excel).
    
            ASSIGN c-excel = c-excel + "ESFTP132" + ".csv".
        END.                
    END.

END PROCEDURE.

RETURN "OK":U.      
