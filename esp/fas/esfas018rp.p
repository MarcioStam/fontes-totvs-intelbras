/*******************************************************************************/
{include/i-prgvrs.i esfas018rp 2.00.00.001}  /*** 010001 ***/
/*******************************************************************************/

define temp-table tt-param no-undo
    field destino                as integer
    field arquivo                as char format "x(35)"
    field usuario                as char format "x(12)"
    field data-exec              as date
    field hora-exec              as integer
    field num_bem_pat_ini        like int_solic_transf.num_bem_pat
    field num_bem_pat_fim        like int_solic_transf.num_bem_pat
    field cod_usuar_solic_ini    like int_solic_transf.cod_usuar_solic
    field cod_usuar_solic_fim    like int_solic_transf.cod_usuar_solic
    field nr_nota_transf_ini     like int_solic_transf.nr_nota_transf
    field nr_nota_transf_fim     like int_solic_transf.nr_nota_transf
    field dat_transf_ini         like int_solic_transf.dat_transf
    field dat_transf_fim         like int_solic_transf.dat_transf
    field rs_status              as int.

define temp-table tt-raw-digita
   field raw-digita as raw.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{include/i-rpvar.i}
{utp/ut-glob.i}

DEF VAR h-acomp      AS HANDLE                     NO-UNDO.
DEF VAR c-dados      AS CHAR FORMAT "x(500)"       NO-UNDO.
DEF VAR v_nome_usuar LIKE usuar_mestre.nom_usuario NO-UNDO.

{include/i-rpout.i}
{include/i-rpcab.i}

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Imprimindo *}.
run pi-inicializar in h-acomp (input return-value).

ASSIGN c-dados = "Nr Solic;Status;Usuar Solic;Dt Transf;Conta Pat;Bem;Seq Bem;Estab Origem;CCusto Origem;Unid Negoc Origem;Estab Destino;CCusto Destino;Unid Negoc Destino;Localiza‡Æo;NF Transf;Serie NF Transf;Desc Solicita‡Æo;Desc Aprov/Reprov".

put c-dados skip. 

FOR EACH int_solic_transf
    WHERE int_solic_transf.num_bem_pat     >= tt-param.num_bem_pat_ini
    AND   int_solic_transf.num_bem_pat     <= tt-param.num_bem_pat_fim
    AND   int_solic_transf.cod_usuar_solic >= tt-param.cod_usuar_solic_ini
    AND   int_solic_transf.cod_usuar_solic <= tt-param.cod_usuar_solic_fim
    AND   int_solic_transf.nr_nota_transf  >= tt-param.nr_nota_transf_ini
    AND   int_solic_transf.nr_nota_transf  <= tt-param.nr_nota_transf_fim
    AND   int_solic_transf.dat_transf      >= tt-param.dat_transf_ini
    AND   int_solic_transf.dat_transf      <= tt-param.dat_transf_fim NO-LOCK:

    IF  tt-param.rs_status = 1
    AND int_solic_transf.ind_aprovac <> "Aprovado"  THEN
        NEXT.

    IF  tt-param.rs_status = 2
    AND int_solic_transf.ind_aprovac <> "Reprovado"  THEN
        NEXT.

    IF  tt-param.rs_status = 3
    AND int_solic_transf.ind_aprovac <> "Pendente"  THEN
        NEXT.

    run pi-acompanhar in h-acomp (input "Solicita‡Æo: " + string(int_solic_transf.num_solicitacao)).

    FOR FIRST usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = int_solic_transf.cod_usuar_solic:
    END.
    ASSIGN v_nome_usuar = usuar_mestre.nom_usuario.

    assign c-dados = string(int_solic_transf.num_solicitacao)
                 + ";" + int_solic_transf.ind_aprovac
                 + ";" + v_nome_usuar
                 + ";" + string(int_solic_transf.dat_transf)
                 + ";" + int_solic_transf.cod_cta_pat
                 + ";" + string(int_solic_transf.num_bem_pat)
                 + ";" + string(int_solic_transf.num_seq_bem_pat)
                 + ";" + int_solic_transf.cod_est_ori
                 + ";" + int_solic_transf.cod_ccus_ori
                 + ";" + int_solic_transf.cod_unid_neg_ori
                 + ";" + int_solic_transf.cod_estab
                 + ";" + int_solic_transf.cod_ccusto
                 + ";" + int_solic_transf.cod_unid_negoc
                 + ";" + int_solic_transf.cod_localiz
                 + ";" + int_solic_transf.nr_nota_transf
                 + ";" + int_solic_transf.serie_transf
                 + ";" + entry(1,int_solic_transf.des_historico,";")
                 + ";" + IF num-entries(int_solic_transf.des_historico,";") > 1 THEN entry(2,int_solic_transf.des_historico,";") ELSE "".

    put c-dados skip. 
END.

run pi-finalizar in h-acomp.
