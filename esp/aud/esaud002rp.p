{include/i-prgvrs.i esaud002rp 2.00.00.000}  

define temp-table tt-param no-undo
    FIELD destino      AS INTEGER
    FIELD arquivo      AS CHAR format "x(35)"
    FIELD usuario      AS CHAR format "x(12)"
    FIELD data-exec    AS DATE
    FIELD hora-exec    AS INTEGER
    FIELD usuar-ini    AS CHAR
    FIELD usuar-fim    AS CHAR
    FIELD base-ini     AS CHAR
    FIELD base-fim     AS CHAR
    FIELD tabela-ini   AS CHAR
    FIELD tabela-fim   AS CHAR
    FIELD atributo-ini AS CHAR
    FIELD atributo-fim AS CHAR
    FIELD data-ini     AS DATE
    FIELD data-fim     AS DATE
    FIELD programa     AS CHAR
    FIELD contem       AS CHAR
    FIELD l-create     AS LOG
    FIELD l-write      AS LOG
    FIELD l-delete     AS LOG.

define temp-table tt-digita 
    FIELD canal-central AS INTEGER .

def temp-table tt-raw-digita
   field raw-digita      as raw.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE for tt-raw-digita.
 
CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEF VAR h-acomp         AS HANDLE                          NO-UNDO.
DEF VAR v_des_val_nov   LIKE atrib_vrf_monitor.des_val_nov NO-UNDO.
DEF VAR v_des_val_ant   LIKE atrib_vrf_monitor.des_val_ant NO-UNDO.
DEF VAR i-cont          AS INT                             NO-UNDO.
DEF VAR v_nom_usuar_reg AS CHAR FORMAT "x(30)"             NO-UNDO.
DEF VAR v_nom_alt       AS CHAR FORMAT "x(30)"             NO-UNDO.
DEF VAR v_nom_novo      AS CHAR FORMAT "x(30)"             NO-UNDO.

{include/i-rpvar.i}
{utp/ut-glob.i}
{include/i-rpout.i}

ASSIGN c-programa     = "esaud002rp"
       c-versao       = "2.00"
       c-revisao      = ".00.001"
       c-empresa      = "Intelbras"
       c-sistema      = "Auditoria"
       c-titulo-relat = "Relat¢rio Auditoria Banco de Dados".

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Gerando relat¢rio ...").

RUN pi-auditoria.

{include/i-rpclo.i}

if valid-handle(h-acomp) then    
    RUN pi-finalizar IN h-acomp. 
                                 
RETURN "OK".             


PROCEDURE pi-auditoria:

    IF  tt-param.tabela-ini = "usuar_grp_usuar"
    AND tt-param.tabela-fim = "usuar_grp_usuar" THEN
        PUT "Base de Dados;Tabela;Atributo;Evento;Usu rio;Nome Usu rio;Data;Hora;Programa;Seq Evento;Terminal;Valor Anterior;Perfil ou Usu rio Alterado;Valor Novo;Perfil ou Usu rio Novo" SKIP.
    ELSE
        PUT "Base de Dados;Tabela;Atributo;Evento;Usu rio;Nome Usu rio;Data;Hora;Programa;Seq Evento;Terminal;Valor Anterior;Valor Novo" SKIP.
    
    for each tabela_vrf_monitor
        where tabela_vrf_monitor.cod_base_dados     >= tt-param.base-ini
        and   tabela_vrf_monitor.cod_base_dados     <= tt-param.base-fim
        and   tabela_vrf_monitor.cod_tabela         >= tt-param.tabela-ini
        and   tabela_vrf_monitor.cod_tabela         <= tt-param.tabela-fim
        and   tabela_vrf_monitor.dat_atualiz        >= tt-param.data-ini
        and   tabela_vrf_monitor.dat_atualiz        <= tt-param.data-fim
        and   tabela_vrf_monitor.cod_usuario        >= tt-param.usuar-ini
        and   tabela_vrf_monitor.cod_usuario        <= tt-param.usuar-fim
        and  (tabela_vrf_monitor.des_prog_atualiz[2] = tt-param.programa
        or    tt-param.programa                      = "")
        and  (tabela_vrf_monitor.des_resumo_alt &IF '{&mgadt_dbtype}' = "progress":U &THEN 
                                                     contains tt-param.contem
                                                 &ELSE
                                                     matches ("*" + tt-param.contem + "*")
                                                 &ENDIF
        or    tt-param.contem                        = "") 
        and ((tabela_vrf_monitor.cod_evento          = "W":U and tt-param.l-write = yes)
        or   (tabela_vrf_monitor.cod_evento          = "C":U and tt-param.l-create = yes)
        or   (tabela_vrf_monitor.cod_evento          = "D":U and tt-param.l-delete = yes)) no-lock:
    
        for each atrib_vrf_monitor
            where atrib_vrf_monitor.num_seq_evento  = tabela_vrf_monitor.num_seq_evento
            and   atrib_vrf_monitor.cod_atributo   >= tt-param.atributo-ini
            and   atrib_vrf_monitor.cod_atributo   <= tt-param.atributo-fim no-lock: 
    
            assign v_des_val_ant   = ""
                   v_des_val_nov   = ""
                   v_nom_usuar_reg = ""
                   v_nom_alt       = ""
                   v_nom_novo      = "".  
    
            do i-cont = 1 to num-entries(atrib_vrf_monitor.des_val_ant,chr(254)):
                assign v_des_val_ant = v_des_val_ant + "," + entry(i-cont,atrib_vrf_monitor.des_val_ant,chr(254)).
            end.
            do i-cont = 1 to num-entries(atrib_vrf_monitor.des_val_nov,chr(254)):
                assign v_des_val_nov = v_des_val_nov + "," + entry(i-cont,atrib_vrf_monitor.des_val_nov,chr(254)).
            end.
    
            assign v_des_val_ant = substr(v_des_val_ant,2)
                   v_des_val_nov = substr(v_des_val_nov,2).
    
            FIND FIRST usuar_mestre
                WHERE usuar_mestre.cod_usuario = tabela_vrf_monitor.cod_usuario NO-LOCK NO-ERROR.

            IF  AVAIL usuar_mestre THEN
                ASSIGN v_nom_usuar_reg = usuar_mestre.nom_usuario.

            IF  tt-param.tabela-ini = "usuar_grp_usuar"
            AND tt-param.tabela-fim = "usuar_grp_usuar" THEN DO:
                
                IF  v_des_val_ant <> "" THEN DO:
                    IF  length(v_des_val_ant) > 3 THEN DO:
                        FIND FIRST usuar_mestre
                            WHERE usuar_mestre.cod_usuario = v_des_val_ant NO-LOCK NO-ERROR.
    
                        IF  AVAIL usuar_mestre THEN
                            ASSIGN v_nom_alt = usuar_mestre.nom_usuario.
                    END.
                    ELSE DO:
                        FIND FIRST grp_usuar
                            WHERE grp_usuar.cod_grp_usuar = v_des_val_ant NO-LOCK NO-ERROR.

                        IF  AVAIL grp_usuar THEN
                            ASSIGN v_nom_alt = grp_usuar.des_grp_usuar.
                    END.
                END.

                IF  v_des_val_nov <> "" THEN DO:
                    IF  length(v_des_val_nov) > 3 THEN DO:
                        FIND FIRST usuar_mestre
                            WHERE usuar_mestre.cod_usuario = v_des_val_nov NO-LOCK NO-ERROR.
    
                        IF  AVAIL usuar_mestre THEN
                            ASSIGN v_nom_novo = usuar_mestre.nom_usuario.
                    END.
                    ELSE DO:
                        FIND FIRST grp_usuar
                            WHERE grp_usuar.cod_grp_usuar = v_des_val_nov NO-LOCK NO-ERROR.

                        IF  AVAIL grp_usuar THEN
                            ASSIGN v_nom_novo = grp_usuar.des_grp_usuar.
                    END.
                END.

                PUT tabela_vrf_monitor.cod_base_dados       ';' 
                    tabela_vrf_monitor.cod_tabela           ';' 
                    atrib_vrf_monitor.cod_atributo          ';' 
                    tabela_vrf_monitor.cod_evento           ';' 
                    tabela_vrf_monitor.cod_usuario          ';'
                    v_nom_usuar_reg                         ';'
                    tabela_vrf_monitor.dat_atualiz          ';' 
                    tabela_vrf_monitor.hra_atualiz          ';' 
                    tabela_vrf_monitor.des_prog_atualiz[2]  ';' 
                    tabela_vrf_monitor.num_seq_evento       ';' 
                    tabela_vrf_monitor.nom_terminal         ';' 
                    v_des_val_ant FORMAT "x(50)"            ';' 
                    v_nom_alt                               ';'
                    v_des_val_nov FORMAT "x(50)"            ';'
                    v_nom_novo                              SKIP.
            END.
            ELSE
                PUT tabela_vrf_monitor.cod_base_dados       ';' 
                    tabela_vrf_monitor.cod_tabela           ';' 
                    atrib_vrf_monitor.cod_atributo          ';' 
                    tabela_vrf_monitor.cod_evento           ';' 
                    tabela_vrf_monitor.cod_usuario          ';'
                    v_nom_usuar_reg                         ';'
                    tabela_vrf_monitor.dat_atualiz          ';' 
                    tabela_vrf_monitor.hra_atualiz          ';' 
                    tabela_vrf_monitor.des_prog_atualiz[2]  ';' 
                    tabela_vrf_monitor.num_seq_evento       ';' 
                    tabela_vrf_monitor.nom_terminal         ';' 
                    v_des_val_ant FORMAT "x(50)"            ';' 
                    v_des_val_nov FORMAT "x(50)" SKIP.
        end.         
    end.

END PROCEDURE.
