/*****************************************************************************
** Programa..............: mod_ccusto
** Autor.................: Anderson Hoepers
** Criado em.............: 17/11/2015
*****************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.

{utp/ut-glob.i}

DEF NEW GLOBAL SHARED VAR wh-mod-tg-desp-viagem AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE c-estabelec   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cc-codigo   AS CHARACTER   NO-UNDO.

DEF BUFFER b_ccusto FOR emscad.ccusto.

DEF TEMP-TABLE tt-integra-ccusto NO-UNDO
    FIELD c-cod-estab AS CHAR
    FIELD c-cod-ccusto AS CHAR
    FIELD c-nom-ccusto AS CHAR
    FIELD c-ind-movto  AS CHAR
    INDEX id-ccusto
            c-cod-ccusto
            c-cod-estab.

if  p_ind_event = "INITIALIZE" 
then do:
    CREATE TOGGLE-BOX wh-mod-tg-desp-viagem
    ASSIGN NAME      = "wh-mod-tg-desp-viagem"
           FORMAT    = "Sim/NÆo"
           FRAME     = p_wgh_frame
           WIDTH     = 23.50
           HEIGHT    =  0.70
           COLUMN    = 39.00
           ROW       =  6.10
           LABEL     = "Movimenta Despesa Viagem"
           HELP      = "Movimenta Despesa Viagem"
           CHECKED   = NO
           VISIBLE   = YES
           SENSITIVE = NO.
end.

if p_ind_event = "DISPLAY" 
THEN DO:
    assign wh-mod-tg-desp-viagem:CHECKED = NO.

    FOR FIRST b_ccusto NO-LOCK
        WHERE RECID(b_ccusto) = p_rec_table:

        FOR FIRST cc_uni_estab NO-LOCK
            WHERE cc_uni_estab.cod_ccusto            = b_ccusto.cod_ccusto
              AND cc_uni_estab.log_movta_desp_viagem = YES:
            ASSIGN wh-mod-tg-desp-viagem:CHECKED = YES.
        END.
    END.
END.
    

if p_ind_event = "ENABLE" 
THEN
    assign wh-mod-tg-desp-viagem:SENSITIVE = YES.


if p_ind_event = "ASSIGN" 
THEN DO:
    FOR FIRST b_ccusto NO-LOCK
        WHERE RECID(b_ccusto) = p_rec_table:

        FOR EACH  cc_uni_estab EXCLUSIVE-LOCK
            WHERE cc_uni_estab.cod_ccusto = b_ccusto.cod_ccusto:

            ASSIGN cc_uni_estab.log_movta_desp_viagem = wh-mod-tg-desp-viagem:CHECKED.

            CASE cc_uni_estab.cod_estab:
                WHEN "101" THEN
                    ASSIGN c-estabelec = "Matriz 101".
                WHEN "103" THEN
                    ASSIGN c-estabelec = "Minas 103".
                WHEN "104" THEN
                    ASSIGN c-estabelec = "Fabrica II 104".
                WHEN "105" THEN
                    ASSIGN c-estabelec = "Manaus 105".
                WHEN "107" THEN
                    ASSIGN c-estabelec = "Palhoca 107".
                OTHERWISE
                    NEXT.
            END CASE.
        
            ASSIGN c-cc-codigo = CAPS(TRIM(cc_uni_estab.cod_unid_negoc)) + TRIM(cc_uni_estab.cod_ccusto).
        
            FOR FIRST emscad.ccusto NO-LOCK
                WHERE emscad.ccusto.cod_empresa      = i-ep-codigo-usuario
                  AND emscad.ccusto.cod_plano_ccusto = "padrao"
                  AND emscad.ccusto.cod_ccusto       = cc_uni_estab.cod_ccusto:
        
                EMPTY TEMP-TABLE tt-integra-ccusto.
                CREATE tt-integra-ccusto.
                ASSIGN tt-integra-ccusto.c-cod-estab  = c-estabelec
                       tt-integra-ccusto.c-cod-ccusto = c-cc-codigo
                       tt-integra-ccusto.c-nom-ccusto = TRIM(emscad.ccusto.des_tit_ctbl)
                       tt-integra-ccusto.c-ind-movto  = "A".

                IF  cc_uni_estab.log_movta_desp_viagem = NO OR 
                    emscad.ccusto.dat_fim_valid          < TODAY 
                THEN
                    ASSIGN tt-integra-ccusto.c-ind-movto = "E". /* Elimina‡Æo */

                RUN esp/esb/out/msg0178.p (INPUT TABLE tt-integra-ccusto). /* Integrar com Barramento */

            END. /* FOR FIRST emscad.ccusto NO-LOCK */
        END. /* FOR EACH  cc_uni_estab EXCLUSIVE-LOCK */
    END.
    RELEASE cc_uni_estab.
END.


if  p_ind_event = "DISABLE" 
THEN
    assign wh-mod-tg-desp-viagem:SENSITIVE = YES.
