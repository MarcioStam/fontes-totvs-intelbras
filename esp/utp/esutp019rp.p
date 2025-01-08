{include/i-prgvrs.i ESUTP019 2.04.00.000}
/***********************************************************************
**  Programa..: ESP\REP\ESUTP019RP.P
**  Autor.....: Raphael Matei Paini
**  Data......: JULHO/2008 - Desenvolvimento
**  Descricao.: Relat¢rio Telefonia
**  VersÆo....: 001 21/11/2008
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp/utp/esutp019tt.i}

{utp/utapi009.i}
{utp/ut-glob.i}
{include/i-rpvar.i}
{upc/btb910za-upc.i}

/****************************  Temp-Tables  ****************************/
DEF VAR h-acomp      as handle no-undo.

/****************************  Frames       ****************************/
DEF INPUT PARAMETER raw-param as raw no-undo.
DEF INPUT PARAMETER table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Telefonia"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESUTP019"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

    {include/i-rpout.i &pagesize="0"}

    RUN pi-relatorio.
             
    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.

PROCEDURE pi-relatorio:
    DEFINE VARIABLE c-nome         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-departamento AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-fornec       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE de-minutagem   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-duracao      AS CHARACTER   NO-UNDO.

    RUN pi-inicializar in h-acomp (input "Gerando Relat¢rio...").

    PUT UNFORMATTED
        "Fornecedor;Periodo;Fatura;Equipamento;Nome;Departamento;Data;Hora;Plano;Servico;Origem;Numero;Destino;Duracao;Valor;Estab;Minutagem" SKIP.

    FIND FIRST equipamentos NO-LOCK NO-ERROR.

    FOR EACH telefonia NO-LOCK
       WHERE telefonia.mes-ref     >= tt-param.periodo-ini
         AND telefonia.mes-ref     <= tt-param.periodo-fim
         AND telefonia.fornecedor  >= tt-param.fornec-ini 
         AND telefonia.fornecedor  <= tt-param.fornec-fim 
         AND telefonia.equipamento >= tt-param.equip-ini
         AND telefonia.equipamento <= tt-param.equip-fim
        BREAK BY telefonia.fornecedor
              BY telefonia.mes-ref
              BY telefonia.equipamento
              BY telefonia.data
              BY telefonia.hora:

        IF NOT AVAIL equipamentos OR equipamentos.equipamento <> telefonia.equipamento THEN
            FIND FIRST equipamentos NO-LOCK
                 WHERE equipamentos.equipamento = telefonia.equipamento NO-ERROR.

        ASSIGN c-fornec       = ""
               c-nome         = ""
               c-departamento = "".
        IF AVAIL equipamentos THEN DO:
            ASSIGN c-nome = equipamentos.descricao.
            run prgint/utb/utb742za.py persistent set h_api_ccusto.

            FOR EACH cc-equipamentos OF equipamentos NO-LOCK:
                EMPTY TEMP-TABLE tt_log_erro.
                run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,       /* EMPRESA EMS2 */
                                                           input  "",                        /* CODIGO DO PLANO CCUSTO */
                                                           input  cc-equipamentos.cc-codigo, /* CCUSTO */
                                                           input  today,                     /* DATA DE TRANSACAO */
                                                           output v_des_titulo_ccusto,       /* DESCRICAO DO CCUSTO */
                                                           output table tt_log_erro).        /* ERROS */
                IF c-departamento = "" THEN
                    ASSIGN c-departamento = cc-equipamentos.cc-codigo + v_des_titulo_ccusto.
                ELSE 
                    ASSIGN c-departamento = c-departamento + "," + cc-equipamentos.cc-codigo + v_des_titulo_ccusto.
            END.
            delete object h_api_ccusto.
        END.

        IF NOT AVAIL fornec-equipamentos OR fornec-equipamentos.fornecedor <> telefonia.fornecedor THEN
            FIND FIRST fornec-equipamentos NO-LOCK
                 WHERE fornec-equipamentos.fornecedor = telefonia.fornecedor NO-ERROR.
        IF AVAIL fornec-equipamentos THEN
            ASSIGN c-fornec = TRIM(STRING(telefonia.fornecedor)) + "-" + fornec-equipamentos.nome.


        IF SUBSTRING(telefonia.duracao,3,1) = ":" AND
           SUBSTRING(telefonia.duracao,6,1) = ":" THEN DO:
            ASSIGN de-minutagem = INT(SUBSTRING(telefonia.duracao,1,2)) * 60 +
                                  INT(SUBSTRING(telefonia.duracao,4,2))      +
                                  INT(SUBSTRING(telefonia.duracao,7,2)) / 60 NO-ERROR.
        END.
        ELSE ASSIGN de-minutagem = 0.

        PUT UNFORMATTED
            c-fornec              ";"
            telefonia.mes-ref     ";"
            telefonia.nr-fatura   ";"
            telefonia.equipamento ";"
            c-nome                ";"
            c-departamento        ";"
            telefonia.data        ";"
            telefonia.hora        ";"
            telefonia.plano       ";"
            telefonia.servico     ";"
            telefonia.origem      ";"
            telefonia.numero      ";"
            telefonia.destino     ";"
            telefonia.duracao     ";"
            telefonia.valor       ";"
            telefonia.cod-estabel ";"
            de-minutagem          ";" SKIP.

    END.
END PROCEDURE.

