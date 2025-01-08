/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI001 2.00.00.056 } /*** 010056 ***/
/*************************************************************************
**
**   Programa: BCAPI001 - API de criaá∆o de transacoes de coleta de dados
**
**   Parametros: tt-trans - Contem os registros que ser∆o convertidos  em
**                          transacoes de coleta de dados
**               tt-erro  - Apos a execucao da API contera  os  possiveis
**                          erros de criacao de transacoes
**
**   Versao de Integracao: 1 - Luciano - Criacao da API (07/98)
**
**************************************************************************/

/* VERSAO DE INTEGRACAO */

&SCOPED-DEFINE Versao-Integracao 1

{cdp/cd0666.i}      /* Definicao da temp-table de erros         */
{bcp/bcapi001.i}    /* Definicao da temp-table de transacoes    */
{bcp/bc1000.i}      /* Procedure geraTTErro */
{bcp/bc1003.i}      /* funá∆o formataCodLayout */
{include/i_dbtype.i}
{cdp/cdcfgint.i}    /* include de definicao de versao de banco  */
{include/i-epc200.i bcapi001} /** Include UPCs **/

DEF VAR lEfetivaComErro              AS LOGICAL  INITIAL NO NO-UNDO.
DEF VAR i-cont-erro                  AS INT                 NO-UNDO.
DEF VAR c-antes-execucao-upc         AS CHAR                NO-UNDO.
DEF VAR c-depois-execucao-upc        AS CHAR                NO-UNDO.
DEF VAR c-registros-tt-epc           AS CHAR                NO-UNDO.

def input-output param table for tt-trans.
def input-output param table for tt-erro.

/* Esta procedure pode ser executada persistente para incluir
   transaá‰es 2D. Quando o programa Ç executado persistente
   retorna sem executar nada e devem ser usadas as procedures 
   internas recebeMovimento e recebeMovimentoFilho.
   No caso das transaá‰es antigas o processo n∆o muda, ou seja,
   a api continua a ser chamada diretamente (sem persistente)
   com os dados em tt-trans */


IF  THIS-PROCEDURE:PERSISTENT THEN
    RETURN.

def var l-erro      as logical init NO                  NO-UNDO.
def var i-cont      as integer                          no-undo.
def var i-cod-erro  as int                              NO-UNDO.
DEF VAR v-seq-erro  AS INTEGER                          NO-UNDO.
DEFINE VARIABLE vLogEfetivNOK  AS LOGICAL INITIAL YES   NO-UNDO.
DEFINE VARIABLE i-estado-trans AS INTEGER               NO-UNDO INITIAL 0.

DEFINE VARIABLE tgAtualiza AS LOGICAL     NO-UNDO.
DEFINE VARIABLE tgImprime AS LOGICAL     NO-UNDO.


def temp-table tt-erro-aux no-undo  like tt-erro.


def new global shared var c_seg_usuario             as character format "x(12)"     no-undo.
def new global shared var v_cod_usuar_corren        like usuar_mestre.cod_usuario   no-undo.
def new global shared var i-ep-codigo-usuario  like mgcad.empresa.ep-codigo no-undo.

find first param-bc no-lock no-error.
if  avail param-bc
then do:
    &if '{&mgcld_version}' <= '2.04' &then
        if  param-bc.int-2 = 2 /* Magnus */
    &else
        if  param-bc.ind-sistema = 2 /* Magnus */
    &endif
    then do:
        assign  c_seg_usuario       = (IF c_seg_usuario= "" THEN userid("mgadm") ELSE c_seg_usuario)
                v_cod_usuar_corren  = (IF v_cod_usuar_corren = "" THEN userid("mgadm") ELSE v_cod_usuar_corren).
    end.
end.

{utp/ut-liter.i "Antes_da_execuá∆o_do_ponto_de_UPC:" * L}
ASSIGN c-antes-execucao-upc = RETURN-VALUE.
{utp/ut-liter.i "Depois_da_execuá∆o_do_Ponto_de_UPC:" * L}
ASSIGN c-depois-execucao-upc = RETURN-VALUE.
{utp/ut-liter.i "Registros temp-table tt-epc:" * L}
ASSIGN c-registros-tt-epc = RETURN-VALUE.

LOG-MANAGER:WRITE-MESSAGE("bcapi001 -0 c_seg_usuario=" + STRING(c_seg_usuario)) NO-ERROR.

for each tt-trans:

    ASSIGN lEfetivaComErro = NO.

LOG-MANAGER:WRITE-MESSAGE("bcapi001 -1 tt-trans.cod-versao-integracao=" + STRING(tt-trans.cod-versao-integracao)) NO-ERROR.

    /*** Teste da versao de integracao ***/
    if  tt-trans.cod-versao-integracao <> {&Versao-Integracao} then do:
        run utp/ut-msgs.p (input "msg",
                           input 3941,
                           input "").
        create tt-erro.
        assign tt-erro.i-sequen = tt-trans.i-sequen
               tt-erro.cd-erro  = 3941
               tt-erro.mensagem = return-value
               l-erro = yes.
    end.

    /*** Teste do tipo de transacao ***/
    find first bc-tipo-trans
         where bc-tipo-trans.cd-trans = tt-trans.cd-trans
         no-lock no-error.

    if  not available(bc-tipo-trans) then do:
        {utp/ut-field.i mgcld bc-tipo-trans cd-trans 1}
        run utp/ut-msgs.p (input "msg",
                           input 56,
                           input trim(return-value)).
        create tt-erro.
        assign tt-erro.i-sequen = tt-trans.i-sequen
               tt-erro.cd-erro  = 56
               tt-erro.mensagem = return-value
               l-erro = yes.
    end.

    /*** Teste do conteudo da transacao ***/
    if  tt-trans.conteudo-trans = ? then do:
        {utp/ut-field.i mgcld bc-trans conteudo-trans 1}
        run utp/ut-msgs.p (input "msg",
                           input 5793,
                           input trim(return-value)).
        create tt-erro.
        assign tt-erro.i-sequen = tt-trans.i-sequen
               tt-erro.cd-erro  = 5793
               tt-erro.mensagem = return-value
               l-erro = yes.
    end.

    /*** Teste do detalhe da transacao ***/
    if  (   tt-trans.detalhe = ?
         or tt-trans.detalhe = "")
    then do:
        {utp/ut-field.i mgcld bc-trans detalhe 1}
        run utp/ut-msgs.p (input "msg",
                           input 5793,
                           input trim(return-value)).
        create tt-erro.
        assign tt-erro.i-sequen = tt-trans.i-sequen
               tt-erro.cd-erro  = 5793
               tt-erro.mensagem = return-value
               l-erro = yes.
    end.

    /*** Teste do usuario ***/
    if  (   tt-trans.usuario = ?
         or tt-trans.usuario = "")
    then do:
        {utp/ut-field.i mgcld bc-trans usuario 1}
        run utp/ut-msgs.p (input "msg",
                           input 5793,
                           input trim(return-value)).
        create tt-erro.
        assign tt-erro.i-sequen = tt-trans.i-sequen
               tt-erro.cd-erro  = 5793
               tt-erro.mensagem = return-value
               l-erro = yes.
    end.

    if  l-erro = yes then undo, next.

LOG-MANAGER:WRITE-MESSAGE("bcapi001 - 2 tt-trans.cd-trans=" + STRING(tt-trans.cd-trans)) NO-ERROR.

    do transaction:
        create  bc-trans.
        assign  bc-trans.estado-trans       = if  tt-trans.atualizada = yes
                                                  then 2
                                                  else 1
                bc-trans.cd-trans           = tt-trans.cd-trans
                bc-trans.data               = today
                bc-trans.data-atualizacao   = if  tt-trans.atualizada = yes
                                                then today
                                                else ?
                                            /* solicitaá∆o Vanessa Bueno em 16/01/03 p .detalhe */
                bc-trans.detalhe            = &IF "{&mgcld_dbtype}":U = "PROGRESS":U &THEN
                                                  tt-trans.detalhe
                                              &ELSE
                                                  substring(tt-trans.detalhe,1,256)
                                              &ENDIF
                bc-trans.ep-codigo          = i-ep-codigo-usuario
                bc-trans.horario            = string(time,"HH:MM:SS")
                bc-trans.hora-atualizacao   = if  tt-trans.atualizada = yes
                                                  then string(time,"HH:MM:SS")
                                                  else ""
                bc-trans.usuario            = tt-trans.usuario
&IF "{&mgcld_version}" >= "2.04" &THEN
                bc-trans.ind-tipo-trans     = if tt-trans.etiqueta then 1 else 2
&ELSE 
                bc-trans.log-1              = tt-trans.etiqueta
&ENDIF
&IF "{&mgcld_version}" >= "2.04" &then                
                bc-trans.ind-processo       = 1 /* processo antigo */.
&else
                bc-trans.int-2              = 1.
&endif


        &IF "{&mgcld_dbtype}":U = "PROGRESS":U &THEN
            assign bc-trans.conteudo-trans = tt-trans.conteudo-trans.
        &ELSE
            assign bc-trans.conteudo-trans = string(tt-trans.conteudo-trans).
            IF ROWID(bc-trans) = ? THEN. /* solicitaá∆o Vanessa Bueno em 16/01/03 */
        &ENDIF
    end.

    assign tt-trans.nr-trans = bc-trans.nr-trans.

LOG-MANAGER:WRITE-MESSAGE("bcapi001 - 3 bc-trans.nr-trans=" + STRING(bc-trans.nr-trans)) NO-ERROR.

    RUN pi-zera-return-value.

LOG-MANAGER:WRITE-MESSAGE("bcapi001 - 4 tt-trans.etiqueta=" + STRING(tt-trans.etiqueta)) NO-ERROR.
LOG-MANAGER:WRITE-MESSAGE("bcapi001 - 4 bc-tipo-trans.imp-apos-trans=" + STRING(bc-tipo-trans.imp-apos-trans)) NO-ERROR.

    IF  tt-trans.etiqueta AND 
        bc-tipo-trans.imp-apos-trans THEN DO:
        
        FOR EACH tt-epc:
            DELETE tt-epc.
        END.

        if c-nom-prog-upc-mg97   <> "" and
           c-nom-prog-upc-mg97   <> ?  then do:
           IF c-arquivo-log <> "" THEN DO: /* extrato de versao */
                output to value(c-arquivo-log) convert target "iso8859-1":U APPEND.
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "User-Print" *}
                put UNFORMATTED "        (BCAPI001) ":U AT 1 trim(c-antes-execucao-upc) RETURN-VALUE string(time,'HH:MM:SS':U) at 94 SKIP.
                put UNFORMATTED "        (BCAPI001) ":U AT 1 "Return-value:":U RETURN-VALUE.
                if  error-status:error then do:
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Error-Status" *}
                    put UNFORMATTED "        (BCAPI001) ":U AT 1  RETURN-VALUE + ":("  error-status:NUM-MESSAGES ")":U SUBSTRING(error-status:get-message(1),1,50) skip.
                END.
                put UNFORMATTED "        (BCAPI001) ":U AT 1 trim(c-registros-tt-epc) SKIP.
                FOR EACH tt-epc:
                      put UNFORMATTED "        (BCAPI001) :cod-event....:":U AT 1 tt-epc.cod-event  SKIP.
                      /* Inicio -- Projeto Internacional */
                      {utp/ut-liter.i "BCAPI001)_:cod-parameter" *}
                      put UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.cod-parameter SKIP.
                      /* Inicio -- Projeto Internacional */
                      {utp/ut-liter.i "BCAPI001)_:val-parameter" *}
                      put UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.val-parameter SKIP.
                      /* Inicio -- Projeto Internacional */
                      {utp/ut-liter.i "BCAPI001" *}
                      put UNFORMATTED "        (" + RETURN-VALUE + ") :---" SKIP.
                END.
                output close.   
           end.
        END.

        {include/i-epc201.i "User-Print"}.

        if c-nom-prog-upc-mg97   <> "" and
           c-nom-prog-upc-mg97   <> ?  then do:
           IF c-arquivo-log <> "" THEN DO: /* extrato de versao */
               output to value(c-arquivo-log) convert target "iso8859-1":U APPEND.
               /* Inicio -- Projeto Internacional */
               {utp/ut-liter.i "User-Print" *}
               put UNFORMATTED "        (BCAPI001) ":U AT 1 trim(c-depois-execucao-upc) RETURN-VALUE string(time,'HH:MM:SS':U) at 94 SKIP.
               put UNFORMATTED "        (BCAPI001) ":U AT 1 "Return-value:":U RETURN-VALUE.
               if  error-status:error then do:
                   /* Inicio -- Projeto Internacional */
                   {utp/ut-liter.i "Error-Status" *}
                   put UNFORMATTED "        (BCAPI001) ":U AT 1  RETURN-VALUE + ":("  error-status:NUM-MESSAGES ")":U SUBSTRING(error-status:get-message(1),1,50) skip.
               END.
               put UNFORMATTED "        (BCAPI001) ":U AT 1 trim(c-registros-tt-epc) SKIP.
               FOR EACH tt-epc:
                     put UNFORMATTED "        (BCAPI001) :cod-event....:":U AT 1 tt-epc.cod-event  SKIP.
                     /* Inicio -- Projeto Internacional */
                     {utp/ut-liter.i "BCAPI001)_:cod-parameter" *}
                     put UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.cod-parameter SKIP.
                     /* Inicio -- Projeto Internacional */
                     {utp/ut-liter.i "BCAPI001)_:val-parameter" *}
                     put UNFORMATTED "        (" + RETURN-VALUE + ":" AT 1 tt-epc.val-parameter SKIP.
                     /* Inicio -- Projeto Internacional */
                     {utp/ut-liter.i "BCAPI001" *}
                     put UNFORMATTED "        (" + RETURN-VALUE + ") :---" SKIP.
               END.
               output close.   
           end.
        END.

    END.

LOG-MANAGER:WRITE-MESSAGE("bcapi001 - 5 bc-trans.estado-trans=" + STRING(bc-trans.estado-trans)) NO-ERROR.
LOG-MANAGER:WRITE-MESSAGE("bcapi001 - 5 bc-tipo-trans.atualiza-on-line=" + STRING(bc-tipo-trans.atualiza-on-line)) NO-ERROR.
LOG-MANAGER:WRITE-MESSAGE("bcapi001 - 5 bc-tipo-trans.imp-apos-trans=" + STRING(bc-tipo-trans.imp-apos-trans)) NO-ERROR.

    if      bc-trans.estado-trans   = 1             /* estado da transaá∆o = 1-Nova  log-1 = yes (atualiza-on-line) */
    and (   bc-tipo-trans.atualiza-on-line  = yes
         or bc-tipo-trans.imp-apos-trans    = yes)
    then do:

        for each tt-erro-aux:
            delete tt-erro-aux.
        end.

        ASSIGN  vLogEfetivNOK = YES.
        RUN PI-ZERA-RETURN-VALUE.
        /***** execucao da pre-api ***/  
        erro:
        do  on error  undo erro, leave erro
            on quit   undo erro, leave erro
            on stop   undo erro, leave erro
            on endkey undo erro, leave erro:

            if  not tt-trans.etiqueta           /* tt-trans.etiqueta = <NO> - Gera Transaá∆o Movimento */
            and bc-tipo-trans.atualiza-on-line
            then do:
                tgAtualiza = YES.
                if  bc-tipo-trans.api-atualizacao <> ""
                THEN
                    run value(bc-tipo-trans.api-atualizacao)
                             (  input tt-trans.nr-trans,
                                input tt-trans.conteudo-trans,
                                input-output table tt-erro-aux) no-error.
                else do:
                    run utp/ut-msgs.p ( input "msg",
                                        input 4,
                                        input return-value).

                    create tt-erro.
                    assign tt-erro.i-sequen = 1
                           tt-erro.cd-erro  = 4
                           tt-erro.mensagem = return-value.
                end.
            end.

            if  tt-trans.etiqueta               /* tt-trans.etiqueta = <YES> - Gera Transaá∆o Etiqueta */
            and bc-tipo-trans.imp-apos-trans
            then do:
                tgImprime = YES.
                if  bc-tipo-trans.prog-etiq <> ""
                THEN DO:
                    RUN VALUE(bc-tipo-trans.prog-etiq)
                             (  input tt-trans.nr-trans,
                                input tt-trans.conteudo-trans,
                                input-output table tt-erro-aux) NO-ERROR.
                END.
                else do:
                    run utp/ut-msgs.p ( input "msg",
                                        input 4,
                                        input return-value).
                    create tt-erro.
                    assign tt-erro.i-sequen = 1
                           tt-erro.cd-erro  = 4
                           tt-erro.mensagem = return-value.
                end.
            end.
            ASSIGN  vLogEfetivNOK = NO.
        end.

        IF  vLogEfetivNOK /* Erro Travamento de Registro */
        OR  RETURN-VALUE = "NOK"
        THEN DO:
            FIND FIRST tt-erro-aux NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-erro-aux
            OR vLogEfetivNOK
            THEN DO:
                run utp/ut-msgs.p (input "msg",
                                   input 27611,
                                   input "").
                create  tt-erro.
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
                ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-bcapi001 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "bcapi001" *}
                ASSIGN c-lbl-liter-bcapi001 = TRIM(RETURN-VALUE).
                Assign  tt-erro.cd-erro  = 27611
                        tt-erro.mensagem = "*** " + c-lbl-liter-bcapi001 + ": " + TRIM(c-lbl-liter). 
            END.
        END.

        if  error-status:error
            or  (    error-status:get-number(1) <> 138
                 and error-status:num-messages <> 0)
        then do:
            do  i-cont = 1 to error-status:num-messages
                while(error-status:get-message(i-cont) <> ""):

                IF  error-status:get-number(i-cont) = 138 THEN NEXT.

                assign i-cod-erro = error-status:get-number(i-cont).

                 run utp/ut-msgs.p (input "msg",
                                   input 15837,
                                   input ( &if '{&mgcld_version}' < '2.04' &then if  bc-trans.log-1 = no &else if  bc-trans.ind-tipo-TRANS = 2 &endif THEN bc-tipo-trans.api-atualizacao else bc-tipo-trans.prog-etiq)
                                    ).

                create tt-erro.
                assign tt-erro.cd-erro  = 15837
                       tt-erro.mensagem = trim(return-value). 

                {utp/ut-liter.i Transaá∆o * L}       
                assign tt-erro.mensagem     = tt-erro.mensagem      
                                                    + " " + trim(return-value)       
                                                    + " (" 
                                                    + bc-trans.cd-trans
                                                    + ")".
                {utp/ut-liter.i Erro_Progress * L}                                   
                assign tt-erro.mensagem =  tt-erro.mensagem      
                                                    + " - " + trim(return-value)       
                                                    + " (" 
                                                    + string(i-cod-erro)
                                                    + ")".
            end.
        end.
        FOR EACH tt-erro-aux.
            CREATE tt-erro.
            BUFFER-COPY tt-erro-aux TO tt-erro NO-ERROR.
            DELETE tt-erro-aux.
        END.

        ASSIGN i-cont-erro = 0.
        FOR EACH tt-erro:
            CREATE  bc-trans-erro.
            ASSIGN  i-cont-erro             = i-cont-erro + 1
                    bc-trans-erro.nr-trans  = bc-trans.nr-trans
                    bc-trans-erro.cd-msg    = tt-erro.cd-erro
                    bc-trans-erro.texto-msg = tt-erro.mensagem
                    &IF  '{&mgcld_version}'   >= '2.02' &THEN
                    bc-trans-erro.num-sequencia = i-cont-erro
                    &ENDIF.

            &IF "{&EMSFND_VERSION}" >= "1.0" &THEN
                FIND FIRST cadast_msg
                     WHERE cadast_msg.cdn_msg = tt-erro.cd-erro
                     NO-LOCK NO-ERROR.

                IF  AVAIL cadast_msg
                AND cadast_msg.idi_tip_msg = 1
                THEN
                    ASSIGN  lEfetivaComErro = YES.
            &ELSE
                FIND FIRST cad-msgs
                     WHERE cad-msgs.cd-msg = tt-erro.cd-erro
                     NO-LOCK NO-ERROR.

                IF  AVAIL cad-msgs
                AND cad-msgs.tipo-msg = 1
                THEN
                    ASSIGN  lEfetivaComErro = YES.
            &ENDIF

        END.
        IF  lEfetivaComErro
        THEN
            DO TRANSACTION:
                ASSIGN  bc-trans.estado-trans       = 3
                        bc-trans.hora-atualizacao   = ""
                        bc-trans.data-atualizacao   = ?.
            END.
        ELSE
            IF (    tt-trans.etiqueta AND tgImprime)
            OR (NOT tt-trans.etiqueta AND tgAtualiza)
            THEN DO:
                DO TRANSACTION:
                    ASSIGN  bc-trans.estado-trans       = 2
                            bc-trans.hora-atualizacao   = string(time,"HH:MM:SS")
                            bc-trans.data-atualizacao   = today.
                END.
            END.

        for each tt-epc:
          delete tt-epc.
        end.

        create  tt-epc.
        assign  tt-epc.cod-event        = "End_Process"
                tt-epc.cod-parameter    = "nr-trans"
                tt-epc.val-parameter    = String(bc-trans.nr-trans).

        create  tt-epc.
        assign  tt-epc.cod-event        = "End_Process"
                tt-epc.cod-parameter    = "cd-trans"
                tt-epc.val-parameter    = String(bc-trans.cd-trans).

        {include/i-epc201.i "End_Process"}.

    END.

end.

find first tt-erro no-error.
if  available(tt-erro) then
    return "NOK".
else
    return "OK".

    /*25-inicio*/
/*
**  Atualiza transaá∆o pai: bc-trans
**  Atauliza transaá∆o filho: bc-trans-filho
**  Retorna erros em tt-erro. Valida todos os registros.
*/

&IF "{&mgcld_version}" >= "2.04" &THEN

PROCEDURE atualizaTransacao:

    DEF INPUT-OUTPUT PARAM TABLE FOR tt-trans.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt-trans-ext.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt-trans-filho.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt-erro.

    DEF VAR v-complemento       AS CHARACTER NO-UNDO.
    DEF VAR v-programa          AS CHARACTER NO-UNDO.

    DEFINE VARIABLE i-nr-trans AS INTEGER    NO-UNDO.

    FOR EACH tt-trans TRANSACTION:
        /* controla os erros para cada transaá∆o */
        l-erro = NO.

        /*** Teste da versao de integracao ***/
        IF  tt-trans.cod-versao-integracao <> {&Versao-Integracao} THEN
            RUN geraErro (3941, "":U, "":U).

        /*** Teste do tipo de transacao ***/
        FIND bc-tipo-trans
            WHERE bc-tipo-trans.cd-trans = tt-trans.cd-trans
            NO-LOCK NO-ERROR.
        IF  NOT AVAIL bc-tipo-trans THEN DO:
            {utp/ut-table.i mgcld bc-tipo-trans 1}
            RUN geraErro (2, TRIM(RETURN-VALUE) + ": ":U + tt-trans.cd-trans, "":U).
        END.

        /*** Teste do detalhe da transacao ***/
        IF  (tt-trans.detalhe = ? or tt-trans.detalhe = "") then do:
            {utp/ut-field.i mgcld bc-trans detalhe 1}
            RUN geraErro (5793, TRIM(RETURN-VALUE), "":U).
        END.

        /*** Teste do usuario ***/
        if  (tt-trans.usuario = ? or tt-trans.usuario = "") then do:
            {utp/ut-field.i mgcld bc-trans usuario 1}
            RUN geraErro (5793, TRIM(RETURN-VALUE), "":U).
        end.

        /* verifica se tem registros filhos */
        FIND FIRST tt-trans-filho
            WHERE tt-trans-filho.i-sequen-pai = tt-trans.i-sequen
            NO-ERROR.
        IF  NOT AVAIL tt-trans-filho THEN
            RUN geraErro (25996, tt-trans.cd-trans, "":U).

        /* Criaá∆o do Movimento, somente se n∆o ocorrer erros */            
        IF  l-erro = NO THEN DO:
            CREATE bc-trans.
            
            IF i-estado-trans <> 0 THEN
                ASSIGN bc-trans.estado-trans = i-estado-trans.
            ELSE
                ASSIGN bc-trans.estado-trans = if  tt-trans.atualizada = yes
                                                      then 2
                                                      else 1.
             ASSIGN bc-trans.cd-trans           = tt-trans.cd-trans
                    bc-trans.data               = today
                    bc-trans.data-atualizacao   = if  tt-trans.atualizada = yes
                                                    then today
                                                    else ?
                    bc-trans.detalhe            = tt-trans.detalhe
                    bc-trans.ep-codigo          = i-ep-codigo-usuario
                    bc-trans.horario            = string(time,"HH:MM:SS")
                    bc-trans.hora-atualizacao   = if  tt-trans.atualizada = yes
                                                      then string(time,"HH:MM:SS")
                                                      else ""
                    bc-trans.usuario            = tt-trans.usuario
        &IF "{&mgcld_version}" >= "2.04" &THEN
                    bc-trans.ind-tipo-trans     = if tt-trans.etiqueta then 1 else 2
                    bc-trans.ind-processo       = 2 /* processo novo */.

        &ELSE 
                    bc-trans.log-1              = tt-trans.etiqueta
                    bc-trans.int-2              = 2 /* processo novo */.
        &ENDIF




        /* Atualiza quantidade de etiquetas */
        FIND tt-trans-ext
                WHERE tt-trans-ext.i-sequen = tt-trans.i-sequen
                  AND tt-trans-ext.campo    = {&EXT-Quantidade}
                NO-ERROR.

        ASSIGN 
        &IF  "{&mgcld_version}" < "2.05" &THEN
                    bc-trans.int-1 = (IF AVAIL tt-trans-ext THEN INTEGER(tt-trans-ext.valor) ELSE 1).
        &ELSE
                    bc-trans.qtd_etiqueta = (IF AVAIL tt-trans-ext THEN INTEGER(tt-trans-ext.valor) ELSE 1).
        &ENDIF

        END.

        FOR EACH tt-trans-filho 
            WHERE tt-trans-filho.i-sequen-pai = tt-trans.i-sequen:
            /* verifica vers∆o de integraá∆o */
            IF  tt-trans-filho.cod-versao-integracao <> {&Versao-Integracao} THEN
                RUN geraErro (3941, "":U, "":U).

            /* verifica tipo-etiqueta */

            IF  tt-trans-filho.tipo-etiq <> 0 
            THEN DO:

            FIND tipo-etiqueta
                WHERE tipo-etiqueta.tipo-etiq = tt-trans-filho.tipo-etiq
                NO-LOCK NO-ERROR.
            IF  NOT AVAIL tipo-etiqueta THEN DO:
                {utp/ut-field.i mgcld tipo-etiqueta tipo-etiq 1}
                RUN geraErro (56, TRIM(RETURN-VALUE), "":U).
            END.

            /* verifica layout/versao */
            FIND bc-layout
                WHERE bc-layout.cod-layout  = tipo-etiqueta.cod-layout
                  AND bc-layout.log-datasul = tipo-etiqueta.log-datasul
                  AND bc-layout.num-versao  = tt-trans-filho.num-versao
                NO-LOCK NO-ERROR.
            IF  NOT AVAIL bc-layout THEN
                RUN geraErro (25971, formataCodLayout(tipo-etiqueta.cod-layout, tipo-etiqueta.log-datasul, tt-trans-filho.num-versao), "":U).

            /* verifica num-layout-registro */
            FIND bc-layout-registro
                WHERE bc-layout-registro.num-layout-registro = tt-trans-filho.segmento
                NO-LOCK NO-ERROR.
            IF  NOT AVAIL bc-layout-registro THEN DO:
                {utp/ut-table.i mgcld bc-layout-registro 1}
                RUN geraErro (2, TRIM(RETURN-VALUE), ": ":U + STRING(tt-trans-filho.segmento)).
            END.

            END.

            /* verifica conteudo-xml */
            IF  tt-trans-filho.conteudo-xml = ? 
            OR  tt-trans-filho.conteudo-xml = "":U THEN
                RUN geraErro (25972, STRING(tt-trans.nr-trans) + "~~":U +
                                       STRING(tt-trans-filho.i-sequen), "":U).

            /* cria movimento se n∆o houve erro */
            IF  l-erro = NO THEN DO:
                CREATE bc-trans-filho.
                ASSIGN bc-trans-filho.nr-trans            = bc-trans.nr-trans
                       bc-trans-filho.sequencia           = tt-trans-filho.i-sequen
                       bc-trans-filho.tipo-etiq           = tt-trans-filho.tipo-etiq
                       bc-trans-filho.num-versao          = tt-trans-filho.num-versao
                       bc-trans-filho.num-layout-registro = tt-trans-filho.segmento
                       bc-trans-filho.cod-aux[1]          = STRING(tt-trans-filho.registro)
                       bc-trans-filho.conteudo-trans      = tt-trans-filho.conteudo-xml.
            END.
        END.

        /* em caso de erro (na transaá∆o-pai ou algum dos filhos) cancela */
        IF  l-erro = YES THEN
            UNDO, NEXT.

        /* Atualiza nr-trans na tt para indicar que atualizou */
        tt-trans.nr-trans = bc-trans.nr-trans.

        /* Guarda nr-trans para realizar a atualizacao do estado para nova apos cadastro de variaveis */
        ASSIGN i-nr-trans = bc-trans.nr-trans.

    END.

    /* verifica se executa programas de atualizacao/impressao */
    FOR EACH tt-trans WHERE tt-trans.nr-trans <> 0:
        FIND bc-trans
            WHERE bc-trans.nr-trans = tt-trans.nr-trans
            NO-LOCK NO-ERROR.
        IF  NOT AVAIL bc-trans THEN DO:
            {utp/ut-table.i mgcld bc-trans 1}
            RUN geraErro (2, TRIM(RETURN-VALUE) + ": ":U + STRING(tt-trans.nr-trans), "":U).
            NEXT.
        END.
        FIND bc-tipo-trans
            WHERE bc-tipo-trans.cd-trans = bc-trans.cd-trans
            NO-LOCK NO-ERROR.
        IF  NOT AVAIL bc-tipo-trans THEN DO:
            {utp/ut-table.i mgcld bc-tipo-trans 1}
            RUN geraErro (2, TRIM(RETURN-VALUE) + ": ":U + tt-trans.cd-trans, "":U).
            NEXT.
        END.

        /* n∆o precisa executar programa de atualizaá∆o/impress∆o */    
        IF  bc-trans.estado-trans <> 1 THEN /* estado da transaá∆o = 1-Nova */
            NEXT.   

        /* n∆o atualiza online */
        IF  bc-tipo-trans.atualiza-on-line = NO 
        AND bc-tipo-trans.imp-apos-trans = NO THEN
            NEXT.

        v-programa = "":U.

        /* define programa de atualizaá∆o */            
        IF  tt-trans.etiqueta = NO  /* tt-trans.etiqueta = <NO> - Gera Transaá∆o Movimento */
        AND bc-tipo-trans.atualiza-on-line = YES THEN
            IF  bc-tipo-trans.api-atualizacao <> "" THEN
                v-programa = bc-tipo-trans.api-atualizacao.
            ELSE DO:
                {utp/ut-liter.i "API-Efetivaá∆o"}
                RUN geraErro (25975, TRIM(RETURN-VALUE) + "~~" + bc-tipo-trans.cd-trans, "":U).
            END.

        /* define programa de etiqueta */
        IF  tt-trans.etiqueta = YES   /* tt-trans.etiqueta = <YES> - Gera Transaá∆o Etiqueta */
        AND bc-tipo-trans.imp-apos-trans = YES THEN
            IF  bc-tipo-trans.prog-etiq <> "" THEN
                v-programa = bc-tipo-trans.prog-etiq.
            ELSE DO:
                {utp/ut-liter.i "Impress∆o Etiqueta"}
                RUN geraErro (25975, TRIM(RETURN-VALUE) + "~~" + bc-tipo-trans.cd-trans, "":U).
            END.

        /* n∆o tem programa ou n∆o precisa executar */
        IF  v-programa = "":U THEN
            NEXT.

        /* preparaá∆o para verificaá∆o de poss°veis erros */
        EMPTY TEMP-TABLE tt-erro-aux.

        /***** execucao do programa ***/  
        erro:
        DO  ON ERROR  UNDO erro, LEAVE erro
            ON QUIT   UNDO erro, LEAVE erro
            ON STOP   UNDO erro, LEAVE erro
            ON ENDKEY UNDO erro, LEAVE erro:

            /* Executa programa de atualizacao ou etiqueta */
            RUN VALUE(v-programa) (tt-trans.nr-trans,
                                   tt-trans.conteudo-trans,
                                   INPUT-OUTPUT TABLE tt-erro-aux) NO-ERROR.

            /* transaá∆o atualizada */
            DO  TRANSACTION:
                FIND CURRENT bc-trans EXCLUSIVE-LOCK.
                ASSIGN  bc-trans.estado-trans     = 2
                        bc-trans.data-atualizacao = TODAY
                        bc-trans.hora-atualizacao = STRING(TIME,"HH:MM:SS").
            END.
        END.

        /* verificaá∆o dos erros ap¢s execuá∆o do programa */
        IF  ERROR-STATUS:ERROR
        OR  (ERROR-STATUS:GET-NUMBER(1) <> 138 AND ERROR-STATUS:NUM-MESSAGES <> 0) THEN DO:
            DO  i-cont = 1 TO ERROR-STATUS:NUM-MESSAGES:
                ASSIGN i-cod-erro = ERROR-STATUS:GET-NUMBER(i-cont).
                {utp/ut-liter.i Transaá∆o * L}       
                v-complemento = " ":U + TRIM(RETURN-VALUE)
                              + " (":U
                              + bc-trans.cd-trans
                              + ")":U.
                {utp/ut-liter.i Erro_Progress * L}
                v-complemento = v-complemento + " - ":U
                              + TRIM(RETURN-VALUE)
                              + " (":U
                              + STRING(i-cod-erro)
                              + ")":U.
                RUN geraErro (15837, (IF bc-trans.log-1 = NO
                                        THEN bc-tipo-trans.api-atualizacao
                                        ELSE bc-tipo-trans.prog-etiq),
                                        v-complemento).
            END.
        END.

        /* verificaá∆o dos erros gerados no programa de atualiza/etiqueta */
        FIND FIRST tt-erro-aux NO-ERROR.
        IF  AVAILABLE tt-erro-aux THEN DO:

            ASSIGN i-cont-erro = 0.

            FOR EACH tt-erro-aux:
                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = tt-erro-aux.i-sequen
                       tt-erro.cd-erro  = tt-erro-aux.cd-erro
                       tt-erro.mensagem = tt-erro-aux.mensagem.

                CREATE bc-trans-erro.
                ASSIGN i-cont-erro             = i-cont-erro + 1
                       bc-trans-erro.nr-trans  = tt-trans.nr-trans
                       bc-trans-erro.cd-msg    = tt-erro-aux.cd-erro
                       bc-trans-erro.texto-msg = tt-erro-aux.mensagem
                       bc-trans-erro.num-sequencia = i-cont-erro.
            END.
            DO  TRANSACTION:
                FIND CURRENT bc-trans EXCLUSIVE-LOCK.
                ASSIGN bc-trans.estado-trans     = 3
                       bc-trans.data-atualizacao = ?
                       bc-trans.hora-atualizacao = "".
            END.
        END.
    END.

    RUN FinalizaTransacaoEquipamento (INPUT i-nr-trans).

    FIND FIRST tt-erro NO-ERROR.
    RETURN (IF AVAIL tt-erro THEN "NOK":U ELSE "OK":U).
END PROCEDURE.


/*
** AlÇm de criar tt-erro Ç necess†rio setar l-erro com YES
*/
PROCEDURE geraErro:
    DEF INPUT PARAM p-numero        AS INTEGER   NO-UNDO.
    DEF INPUT PARAM p-parametros    AS CHARACTER NO-UNDO.
    DEF INPUT PARAM p-complemento   AS CHARACTER NO-UNDO.

    l-erro = YES.
    RUN geraTTErro (p-numero, p-parametros, p-complemento).
END PROCEDURE.

&ENDIF

&IF "{&mgcld_version}":U >= "2.02":U &THEN 

PROCEDURE cria_reg_wms:

    DEF INPUT        PARAM           p-estado-trans AS INTEGER NO-UNDO.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt-trans.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt-trans-filho.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt-erro.

    DEFINE VARIABLE vcont AS INTEGER.

    FOR EACH tt-erro:
        DELETE tt-erro.
    END.
    FOR EACH tt-trans:
         ASSIGN vcont = 0.
         if  tt-trans.cod-versao-integracao <> {&Versao-Integracao} then do:
            run utp/ut-msgs.p (input "msg",
                               input 3941,
                               input "").
            create tt-erro.
            assign tt-erro.i-sequen = tt-trans.i-sequen
                   tt-erro.cd-erro  = 3941
                   tt-erro.mensagem = RETURN-VALUE
                   l-erro = yes.
        end.

        find first bc-tipo-trans
            where bc-tipo-trans.cd-trans = tt-trans.cd-trans
            no-lock no-error.
        if  not available(bc-tipo-trans) then do:
            {utp/ut-field.i mgcld bc-tipo-trans cd-trans 1}
            run utp/ut-msgs.p (input "msg",
                               input 56,
                               input trim(return-value)).
            create tt-erro.
            ASSIGN tt-erro.i-sequen = tt-trans.i-sequen
                   tt-erro.cd-erro  = 56
                   tt-erro.mensagem = RETURN-VALUE
                   l-erro = yes.
        end.
        if  (   tt-trans.detalhe = ?
             or tt-trans.detalhe = "")
        then do:
            {utp/ut-field.i mgcld bc-trans detalhe 1}
            run utp/ut-msgs.p (input "msg",
                               input 5793,
                               input trim(return-value)).
            create tt-erro.
            assign tt-erro.i-sequen = tt-trans.i-sequen
                   tt-erro.cd-erro  = 5793
                   tt-erro.mensagem = RETURN-VALUE
                   l-erro = yes.
        end.
        if  (   tt-trans.usuario = ?
             or tt-trans.usuario = "")
        then do:
            {utp/ut-field.i mgcld bc-trans usuario 1}
            run utp/ut-msgs.p (input "msg",
                               input 5793,
                               input trim(return-value)).
            create tt-erro.
            ASSIGN tt-erro.i-sequen = tt-trans.i-sequen
                   tt-erro.cd-erro  = 5793
                   tt-erro.mensagem = RETURN-VALUE
                   l-erro = yes.
        end.

        if  l-erro = yes then undo, next.
        DO TRANSACTION:
            FIND FIRST bc-trans USE-INDEX bctrans-06
                 WHERE bc-trans.detalhe      = tt-trans.detalhe 
                   AND bc-trans.estado-trans = 4 
                   AND bc-trans.cd-trans     = tt-trans.cd-trans NO-LOCK NO-ERROR.
            IF NOT AVAILABLE bc-trans THEN DO:
                CREATE  bc-trans.
                ASSIGN  bc-trans.cd-trans       = tt-trans.cd-trans
                        bc-trans.data           = TODAY
                        bc-trans.detalhe        = tt-trans.detalhe
                        bc-trans.ep-codigo      = i-ep-codigo-usuario
                        bc-trans.estado-trans   = p-estado-trans   /* Conforme Foi Definido o codigo 4 corresponde aos Movimentos das Cargas em processso */
                        bc-trans.horario        = STRING(TIME,"HH:MM:SS":U)
                        bc-trans.usuario        = tt-trans.usuario
                        bc-trans.ind-tipo-trans = 2     /*1-Etiqueta, 2-Coleta*/.
                ASSIGN bc-trans.des-observacao = 'Transaá∆o DC x WMS' + ';0':U.       
                ASSIGN tt-trans.nr-trans = bc-trans.nr-trans
                       vcont = 0.
            END.
            ELSE DO:
                ASSIGN tt-trans.nr-trans = bc-trans.nr-trans
                       vcont = INTEGER(ENTRY(2,bc-trans.des-observacao,';':U)).
            END.                 

            FOR EACH tt-trans-filho 
                WHERE tt-trans-filho.i-sequen-pai = tt-trans.i-sequen:
                ASSIGN vcont = vcont + 1.
                CREATE bc-trans-filho.
                ASSIGN  bc-trans-filho.nr-trans             = tt-trans.nr-trans
                        bc-trans-filho.sequencia            = vcont 
                        bc-trans-filho.cod-aux[1]           = ""
                        bc-trans-filho.cod-aux[2]           = ""
                        bc-trans-filho.cod-aux[3]           = ""
                        bc-trans-filho.cod-aux[4]           = ""
                        bc-trans-filho.cod-aux[5]           = ""
                        bc-trans-filho.num-layout-registro  = 0
                        bc-trans-filho.num-versao           = TT-trans.cod-versao-integracao
                        bc-trans-filho.tipo-etiq            = 0
                        bc-trans-filho.conteudo-trans       = TT-trans-filho.conteudo-xml.
                ASSIGN tt-trans-filho.cod-versao-integracao = vcont.
             END.
             FIND CURRENT bc-trans EXCLUSIVE-LOCK NO-ERROR.
             ASSIGN entry(2,bc-trans.des-observacao,';':U) = STRING(vcont).
             RELEASE bc-trans.
             RELEASE bc-trans-filho.
        END.
    END.
    RETURN 'OK':U.
END PROCEDURE.
&endif.
/*25-fim*/

/* FIM */

/************************************************************************************************************************************/
PROCEDURE pi-zera-return-value:

    RETURN "":U.

END PROCEDURE.

PROCEDURE SetEstadoTrans :

    DEFINE INPUT PARAM p-i-estado-trans AS INTEGER NO-UNDO.

    ASSIGN i-estado-trans = p-i-estado-trans.

END.

PROCEDURE FinalizaTransacaoEquipamento :
    
    DEFINE INPUT PARAM p-i-nr-trans AS INTEGER NO-UNDO.

    FIND FIRST bc-trans EXCLUSIVE-LOCK WHERE bc-trans.nr-trans = p-i-nr-trans NO-ERROR.

    IF AVAIL bc-trans THEN
        bc-trans.estado-trans = 1.
     
    ASSIGN i-estado-trans = 0.

END PROCEDURE.
