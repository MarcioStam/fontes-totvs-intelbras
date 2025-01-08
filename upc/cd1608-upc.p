{include/i-epc200.i1}
{utp/ut-glob.i}

def temp-table tt_retorno_clien_fornec no-undo
    field ttv_cod_parameters               as character format "x(256)"
    field ttv_num_mensagem                 as integer format ">>>>,>>9"
    field ttv_des_mensagem                 as character format "x(52)" label "Mensagem" column-label "Mensagem"
    field ttv_des_ajuda                    as character format "x(256)"
                                           view-as editor max-chars 2000 scrollbar-vertical size 40 by 4
                                           label "Ajuda" column-label "Ajuda"
    field ttv_cod_parameters_clien         as character format "x(2000)"
    field ttv_cod_parameters_fornec        as character format "x(2000)"
    field ttv_log_envdo                    as logical format "Sim/NÆo" initial no
    field ttv_cod_parameters_clien_financ  as character format "x(2000)"
    field ttv_cod_parameters_fornec_financ as character format "x(2000)"
    field ttv_cod_parameters_pessoa_fisic  as character format "x(2000)"
    field ttv_cod_parameters_pessoa_jurid  as character format "x(2000)"
    field ttv_cod_parameters_estrut_clien  as character format "x(2000)"
    field ttv_cod_parameters_estrut_fornec as character format "x(2000)"
    field ttv_cod_parameters_contat        as character format "x(2000)"
    field ttv_cod_parameters_repres        as character format "x(2000)"
    field ttv_cod_parameters_ender_entreg  as character format "x(2000)"
    field ttv_cod_parameters_pessoa_ativid as character format "x(2000)"
    field ttv_cod_parameters_ramo_negoc    as character format "x(2000)"
    field ttv_cod_parameters_porte_pessoa  as character format "x(2000)"
    field ttv_cod_parameters_idiom_pessoa  as character format "x(2000)"
    field ttv_cod_parameters_clas_contat   as character format "x(2000)"
    field ttv_cod_parameters_idiom_contat  as character format "x(2000)"
    field ttv_cod_parameters_telef         as character format "x(2000)"
    field ttv_cod_parameters_telef_pessoa  as character format "x(2000)"
    field ttv_cod_parameters_histor_clien  as character format "x(4000)"
    field ttv_cod_parameters_histor_fornec as character format "x(4000)" .

DEFINE INPUT        PARAM pIndEvent AS CHARACTER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEFINE VARIABLE hBuffer AS HANDLE      NO-UNDO.
DEFINE VARIABLE hQuery  AS HANDLE      NO-UNDO.
DEFINE VARIABLE hField  AS HANDLE      NO-UNDO.
    
IF pIndEvent = "Retorno-Clien-Fornec":U THEN DO:
                    
        FIND FIRST tt-epc
            WHERE tt-epc.cod-event     = "tt-retorno-clien-fornec":U
              AND tt-epc.cod-parameter = "handle-tt-retorno-clien-fornec":U NO-LOCK NO-ERROR.

        IF AVAILABLE tt-epc THEN DO:

            ASSIGN hBuffer = WIDGET-HANDLE(tt-epc.val-parameter)
                   hBuffer = hBuffer:DEFAULT-BUFFER-HANDLE.

            CREATE QUERY hQuery.
            hQuery:SET-BUFFERS(hBuffer).
            hQuery:QUERY-PREPARE("FOR EACH ":U + hBuffer:NAME + " NO-LOCK INDEXED-REPOSITION":U).
            hQuery:QUERY-OPEN.
                         
            hQuery:GET-FIRST.
            DO WHILE NOT hQuery:QUERY-OFF-END:

                IF hBuffer:BUFFER-FIELD("ttv_num_mensagem":U):BUFFER-VALUE = 18655 THEN DO:

                    hBuffer:BUFFER-DELETE(). /* Excluindo a Temp-Table */                  

                END.
                hQuery:GET-NEXT.
            END.
            hQuery:GET-FIRST.
        END.
END.


RETURN "OK":U.
