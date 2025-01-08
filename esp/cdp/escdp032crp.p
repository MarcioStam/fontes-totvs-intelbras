/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCDP032CRP 2.06.00.000}

/* ***************************  Definitions  ************************** */

/* Preprocessor Definitions ---                                         */

&GLOBAL-DEFINE PRINT-PARAM  YES

/* Include Definitions ---                                              */

/* Defini‡Æo das temp-tables tt-param, tt-digita e tt-raw-digita */
//{esp/cdp/escdp032c.i}
{include/i-rpvar.i}


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
    FIELD rs-imp-exp       AS CHAR
    FIELD arq-imp-exp      AS CHAR.


define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field lista-rw         as character format "x(30)"
    FIELD r-rowid          AS ROWID
    index id ordem.


DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.


DEFINE TEMP-TABLE tt-crm-desc-cli-imp NO-UNDO
    FIELD cd-unid-negoc   LIKE crm-desc-cli.cd-unid-negoc
    FIELD cod-emitente    LIKE crm-desc-cli.cod-emitente
    FIELD it-codigo      LIKE crm-desc-cli.it-codigo
    FIELD dt-vigencia-ini LIKE crm-desc-cli.dt-vigencia-ini
    FIELD dt-vigencia-fim LIKE crm-desc-cli.dt-vigencia-fim
    FIELD pc-desconto     LIKE crm-desc-cli.pc-desconto
    FIELD observacao      LIKE crm-desc-cli.observacao
    FIELD linha           AS INTEGER.



/* Local Temp-Table Definitions ---                                     */
DEFINE TEMP-TABLE tt-erros NO-UNDO
       FIELD identifi-msg AS CHAR FORMAT "x(60)"
       FIELD cod-erro     AS INT  FORMAT "99999"
       FIELD desc-erro    AS CHAR FORMAT "x(60)"
       FIELD tabela       AS CHAR FORMAT "x(20)".

DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-destino AS CHARACTER   NO-UNDO.

DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

/* Stream Definitions ---                                               */

DEFINE STREAM str-rp.

/* Form Definitions ---                                                 */

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.

/* ***************************  Main Block  *************************** */

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST mgcad.empresa
    WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-titulo-relat = "":U
       c-sistema      = "":U.

ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}.

/*DO ON ERROR UNDO, RETURN ERROR
   ON STOP  UNDO, RETURN ERROR:*/
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

    IF tt-param.rs-imp-exp = "1" THEN
        RUN pi-importa.
    ELSE IF tt-param.rs-imp-exp = "2" THEN
            RUN pi-exporta.
         ELSE RUN pi-elimina.
    
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    {include/i-rpclo.i &STREAM="STREAM str-rp"}

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.
/*END.*/

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-importa:

    DEF VAR i-cont AS INT NO-UNDO.

    ASSIGN i-cont = 0.

    /* Importa as Notas de um arquivo */
    INPUT FROM VALUE(tt-param.arq-imp-exp) NO-ECHO.
    REPEAT:
        ASSIGN i-cont = i-cont + 1.

        RUN pi-acompanhar IN h-acomp (INPUT "Importando linha " + STRING(i-cont)).

        CREATE tt-crm-desc-cli-imp.
        ASSIGN tt-crm-desc-cli-imp.linha = i-cont.
        IMPORT DELIMITER ";" tt-crm-desc-cli-imp.
    END.
    INPUT CLOSE.

    /* NÆo busca o £ltimo registro criado, com as informa‡äes em branco! */
    FOR EACH  tt-crm-desc-cli-imp EXCLUSIVE-LOCK
        WHERE tt-crm-desc-cli-imp.linha < i-cont
          AND tt-crm-desc-cli-imp.cd-unid-negoc <> ""
          AND tt-crm-desc-cli-imp.cod-emitente  <> 0
          AND tt-crm-desc-cli-imp.it-codigo     <> "":

        RUN pi-acompanhar IN h-acomp (INPUT STRING("Cliente: " + STRING(tt-crm-desc-cli-imp.cod-emitente) + "/" + tt-crm-desc-cli-imp.it-codigo)).

        RUN pi-validar-imp IN THIS-PROCEDURE.
        IF  RETURN-VALUE = "NOK":U THEN
            NEXT.

        /* Necess rio para manter o hist¢rio do desconto */
        FIND LAST crm-desc-cli EXCLUSIVE-LOCK
            WHERE crm-desc-cli.cd-unid-negoc   = tt-crm-desc-cli-imp.cd-unid-negoc
            AND   crm-desc-cli.cod-emitente    = tt-crm-desc-cli-imp.cod-emitente
            AND   crm-desc-cli.it-codigo      = tt-crm-desc-cli-imp.it-codigo NO-ERROR.
        IF  AVAIL crm-desc-cli AND crm-desc-cli.dt-vigencia-fim = ? THEN
            ASSIGN crm-desc-cli.dt-vigencia-fim = tt-crm-desc-cli-imp.dt-vigencia-ini.

        CREATE crm-desc-cli.
        BUFFER-COPY tt-crm-desc-cli-imp TO crm-desc-cli.
    END.

    IF  CAN-FIND(FIRST tt-erros) THEN DO:
        FOR EACH tt-erros:
            DISPLAY STREAM str-rp
            	tt-erros.desc-erro NO-LABEL
        		WITH FRAME f-report. 
        END.
    END.
    
    DISPLAY STREAM str-rp
        "Importa‡Æo conclu¡da!"
        WITH FRAME f-impressao.
    
END PROCEDURE.

PROCEDURE pi-exporta:
    
    OUTPUT TO VALUE(tt-param.arq-imp-exp).
    PUT "Unid Coml;Cod cliente;Cod Item;Data Inicial;Data Final;Desconto;Observacao" SKIP.
    
    FOR EACH crm-desc-cli NO-LOCK:

        RUN pi-acompanhar IN h-acomp (INPUT "Exportando dados").
    
        PUT crm-desc-cli.cd-unid-negoc   ";"
            crm-desc-cli.cod-emitente    ";"
            crm-desc-cli.it-codigo       ";"
            crm-desc-cli.dt-vigencia-ini ";"
            crm-desc-cli.dt-vigencia-fim ";"
            crm-desc-cli.pc-desconto     ";"
            trim(crm-desc-cli.observacao)      ";" SKIP.
    
    END.
    OUTPUT CLOSE.

    DISPLAY STREAM str-rp
        "Exporta‡Æo conclu¡da!"
        WITH FRAME f-impressao.
    
    /*DOS SILENT notepad value(tt-param.arq-imp-exp).*/
    
END PROCEDURE.

PROCEDURE pi-elimina:
    
    FOR EACH tt-digita:

        DO i-cont = 1 TO NUM-ENTRIES(tt-digita.lista-rw,';'):

           FIND FIRST crm-desc-cli EXCLUSIVE-LOCK
                WHERE rowid(crm-desc-cli) = TO-ROWID(entry(i-cont,tt-digita.lista-rw,';')) 
           NO-ERROR.
         
           IF AVAIL crm-desc-cli THEN DO:
              RUN pi-acompanhar IN h-acomp (INPUT "Eliminando - " + crm-desc-cli.it-codigo  ).
              DELETE crm-desc-cli.
           END.       
        END.
        
    END. 

END PROCEDURE.

PROCEDURE pi-validar-imp :

    IF  tt-crm-desc-cli-imp.cd-unid-negoc = "0" OR
        tt-crm-desc-cli-imp.cd-unid-negoc = "" THEN DO:
        CREATE tt-erros.
        ASSIGN tt-erros.cod-erro      = 17006
               tt-erros.desc-erro     = "Unidade Comercial deve ser informada! Linha: " + STRING(tt-crm-desc-cli-imp.linha).
        RETURN "NOK":U.
    END.
    ELSE DO:
        IF  NOT CAN-FIND(FIRST unid-comerc NO-LOCK
                         WHERE unid-comerc.cd-unid-comerc = INT(tt-crm-desc-cli-imp.cd-unid-negoc)) THEN DO:
            CREATE tt-erros.
            ASSIGN tt-erros.cod-erro      = 17006
                   tt-erros.desc-erro     = "Unidade Comercial informada nÆo est  cadastrada! Linha: " + STRING(tt-crm-desc-cli-imp.linha).
            RETURN "NOK":U.
        END.
    END.


    IF  tt-crm-desc-cli-imp.cod-emitente = 0 THEN DO:
        CREATE tt-erros.
        ASSIGN tt-erros.cod-erro      = 17006
               tt-erros.desc-erro     = "Cliente deve ser informado! Linha: " + STRING(tt-crm-desc-cli-imp.linha).
        RETURN "NOK":U.
    END.
    ELSE DO:
        IF  NOT CAN-FIND(FIRST emitente NO-LOCK
                         WHERE emitente.cod-emitente = tt-crm-desc-cli-imp.cod-emitente) THEN DO:
            CREATE tt-erros.
            ASSIGN tt-erros.cod-erro      = 17006
                   tt-erros.desc-erro     = "Cliente informado nÆo est  cadastrado! Linha: " + STRING(tt-crm-desc-cli-imp.linha).
            RETURN "NOK":U.
        END.
    END.


    IF  tt-crm-desc-cli-imp.it-codigo = "" THEN DO:
        CREATE tt-erros.
        ASSIGN tt-erros.cod-erro      = 17006
               tt-erros.desc-erro     = "Fam¡lia Comercial deve ser informada! Linha: " + STRING(tt-crm-desc-cli-imp.linha).
        RETURN "NOK":U.
    END.
    ELSE DO:
        IF  NOT CAN-FIND(FIRST ITEM NO-LOCK
                         WHERE ITEM.it-codigo = tt-crm-desc-cli-imp.it-codigo) THEN DO:
            CREATE tt-erros.
            ASSIGN tt-erros.cod-erro      = 17006
                   tt-erros.desc-erro     = "Fam¡lia Comercial informada n’o estÿ cadastrada! Linha: " + STRING(tt-crm-desc-cli-imp.linha).
            RETURN "NOK":U.
        END.
    END.


    IF  tt-crm-desc-cli-imp.dt-vigencia-ini = ? THEN DO:
        CREATE tt-erros.
        ASSIGN tt-erros.cod-erro      = 17006
               tt-erros.desc-erro     = "Vigˆncia Inicial deve ser informada! Linha: " + STRING(tt-crm-desc-cli-imp.linha).
        RETURN "NOK":U.
    END.


    IF  CAN-FIND(FIRST crm-desc-cli NO-LOCK
                 WHERE crm-desc-cli.cd-unid-negoc   = tt-crm-desc-cli-imp.cd-unid-negoc
                 AND   crm-desc-cli.cod-emitente    = tt-crm-desc-cli-imp.cod-emitente
                 AND   crm-desc-cli.it-codigo      = tt-crm-desc-cli-imp.it-codigo
                 AND   crm-desc-cli.dt-vigencia-ini = tt-crm-desc-cli-imp.dt-vigencia-ini) THEN DO:
        CREATE tt-erros.
        ASSIGN tt-erros.cod-erro      = 17006
               tt-erros.desc-erro     = "J  existe um Desconto de Cliente! Linha: " + STRING(tt-crm-desc-cli-imp.linha).
        RETURN "NOK":U.
    END.

END PROCEDURE.
