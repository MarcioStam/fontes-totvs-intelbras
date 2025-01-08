/***********************************************************************
**  Programa..: esp/es0952rp.p
**  Autor.....: Fabiano Zarpe Henke
**  Data......: 26/10/2012
**  Descricao.: Extra‡Æo dos movimentos
************************************************************************/

/****************************  Definitions  ****************************/
{esp/es0952tt.i}
{esp/es0018.i} 

/****************************  Variaveis    ****************************/
/********************* Temporary Table Definition Begin *********************/

DEF TEMP-TABLE tt-dados
    FIELD cod_estab              AS CHAR
    FIELD origem                 AS CHAR FORMAT "x(3)"   /**** APB, ACR, FGL, CMG, APL, FAS, FTP ou CEP ***/
    FIELD ind_natur_lancto_ctbl  AS CHAR FORMAT "X(3)"   /**** DB ou CR ***/
    FIELD cod_emitente           AS INT  FORMAT ">>>,>>>,>>9"
    FIELD nome_emitente          AS CHAR FORMAT "X(40)"
    FIELD dt_transacao           AS DATE FORMAT "99/99/9999"
    FIELD cod_espec_docto        AS CHAR FORMAT "x(3)"
    FIELD cod_ser_docto          AS CHAR FORMAT "x(3)"
    FIELD cod_tit_ap             AS CHAR FORMAT "x(10)"
    FIELD cod_parcela            AS CHAR FORMAT "x(2)"
    FIELD nat-operacao           LIKE movto-estoq.nat-operacao
    FIELD val_aprop_ctbl         AS DEC  FORMAT ">>>,>>>,>>9.99"
    FIELD cod_cta_ctbl           AS CHAR
    FIELD cod_ccusto             AS CHAR
    FIELD cod_unid_negoc         AS CHAR
    FIELD des_lancto             AS CHAR
    FIELD dat_vencto             AS DATE FORMAT "99/99/9999"
    FIELD dat_vencto_origin      AS DATE FORMAT "99/99/9999"
    FIELD dat_prev_pagto         AS DATE FORMAT "99/99/9999"
    FIELD cod_grp                AS CHAR FORMAT "x(4)"
    FIELD dat_emis_docto         AS DATE FORMAT "99/99/9999"
    FIELD cod_indic_econ         AS CHAR FORMAT "x(8)"
    FIELD ind_trans              AS CHAR FORMAT "x(29)"
    FIELD des_item               AS CHAR
    FIELD it_codigo              AS CHAR
    FIELD cod_depos              AS CHAR
    FIELD quantidade             AS DEC  FORMAT ">>>>,>>>,>>9.9999"
    FIELD cod_portador           AS CHAR FORMAT "x(5)"
    FIELD cod_carteira           AS CHAR FORMAT "x(3)"
    FIELD val_cotac_indic_econ   AS DEC  FORMAT ">>>>,>>9.9999999999" DECIMALS 10
    FIELD cod_usuar_ult_atualiz  AS CHAR FORMAT "x(12)"
    FIELD dat_ult_atualiz        AS DATE
    FIELD hra_ult_atualiz        AS CHAR FORMAT "99:99:99"
    FIELD tta_cod_cta_pat        AS CHAR
    FIELD tta_num_bem_pat        AS INT
    FIELD tta_num_seq_bem_pat    AS INT
    FIELD vida_util              AS DEC
    FIELD fornecedor             AS INT
    FIELD cod_docto_entr         AS CHAR
    FIELD cod_ser_docto_entr     AS CHAR
    FIELD parcela                AS INT
    FIELD tot-parcela            AS INT
    FIELD saldo                  AS DEC
    FIELD IECFOAT                AS CHAR
    FIELD cod_tribut             AS INT
    FIELD nf-desp-aces           LIKE despesa-aces.nro-docto
    FIELD serie-desp             LIKE despesa-aces.serie-doc
    FIELD nat-oper-desp          LIKE despesa-aces.nat-operacao
    FIELD vlr-desp-aces          LIKE despesa-aces.valor
    FIELD uf_emitente            LIKE emitente.estado
    FIELD log_contabilizado      AS LOG
    FIELD cod_refer              LIKE movto_tit_acr.cod_refer
    FIELD ind_sit_proces_pagto   LIKE proces_pagto.ind_sit_proces_pagto  
    FIELD cod_usuar_liber_pagto  LIKE proces_pagto.cod_usuar_liber_pagto 
    FIELD dat_liber_pagto        LIKE proces_pagto.dat_liber_pagto       
    FIELD hra_liber_proces_pagto LIKE proces_pagto.hra_liber_proces_pagto
    FIELD val_liberd_pagto       LIKE proces_pagto.val_liberd_pagto.     

                                                                  

def temp-table tt_converter_finalid_econ_apl no-undo
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cota‡Æo" column-label "Data Cota‡Æo"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo" column-label "Cota‡Æo"
    field tta_val_cotac_tax_juros          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Taxa Juros" column-label "Cotac Taxa Juros"
    field tta_val_prev_cotac_fasb          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Previs Fasb" column-label "Cotac Previs Fasb"
    field tta_val_cotac_cm_emis            as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Emiss" column-label "Cotac Cm Emiss"
    field tta_val_cotac_cm_vencto          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Vencto" column-label "Cotac Cm Vencto"
    field tta_val_cotac_cm_pagto           as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Pagto" column-label "Cotac CM Pagto"
    field tta_val_transacao                as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Transa‡Æo" column-label "Transa‡Æo"
    field tta_val_variac_cambial           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Varic Cambial" column-label "Variac Cambial"
    field tta_val_acerto_cmcac             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Acerto CMCAC" column-label "Vl Acerto CMCAC"
    field tta_val_fatorf                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator F" column-label "Fator F"
    field tta_val_fatorx                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator X" column-label "Fator X"
    field tta_val_fatory                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator Y" column-label "Fator Y"
    field tta_val_ganho_perda_cm           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P CM" column-label "G/P CM"
    field tta_val_ganho_perda_projec       as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P Proje‡Æo" column-label "G/P Proje‡Æo"
    field tta_ind_forma_conver             as character format "X(10)" initial "Direta" label "Forma ConversÆo" column-label "Forma ConversÆo"
    field ttv_val_multa                    as decimal format "->>>,>>>,>>9.99" decimals 2 label "Vl Multa" column-label "Vl Multa"
    field ttv_val_desc                     as decimal format "->>>,>>>,>>9.99" decimals 2 label "Vl Desc" column-label "Vl Desc"
    field ttv_val_juros_apl_1              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field ttv_val_abat                     as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Abatimento" column-label "Valor Abatimento"
    field ttv_val_cm_apl                   as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Corre‡Æo Monet ria" column-label "Corre‡Æo Monet ria"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc".


/********************** Temporary Table Definition End **********************/

/************************** Stream Definition Begin *************************/

def new shared stream s_1.

/*************************** Stream Definition End **************************/

/************************* Variable Definition Begin ************************/

DEFINE VARIABLE v_cod_cta_ctbl_ini  AS CHARACTER   FORMAT "99999999"   NO-UNDO.
DEFINE VARIABLE v_cod_cta_ctbl_fim  AS CHARACTER   FORMAT "99999999"   NO-UNDO.
DEFINE VARIABLE v_data_ini          AS DATE        FORMAT "99/99/9999" NO-UNDO.
DEFINE VARIABLE v_data_fim          AS DATE        FORMAT "99/99/9999" NO-UNDO.
DEFINE VARIABLE v_cod_arquivo       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-data              AS DATE        NO-UNDO.
DEFINE VARIABLE v_val_aprop_ctbl    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_des_cta_ctbl      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_des_ccusto        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_des_unid_negoc    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_arq           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_dat_vencto        AS CHARACTER   NO-UNDO.  
DEFINE VARIABLE v_dat_vencto_origin AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_dat_prev_pagto    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_dat_emis_docto    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_dat_alter         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_hr_alter          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_val_cotac         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_nom_usuar         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-estoque           AS LOGICAL     INITIAL NO NO-UNDO.
DEFINE VARIABLE v_ccusto_ini        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_ccusto_fim        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_estab_ini         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_estab_fim         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-ACR               AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-APB               AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-APL               AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-CMG               AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-desc-sit          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-cod-gr-cob        LIKE int-emitente.cod-gr-cob.  

DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.

def var v_wgh_focus
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_log_method
    as logical
    format "Sim/NÆo"
    initial yes
    no-undo.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

DEFINE VARIABLE l-despesa AS LOGICAL INITIAL YES
     LABEL "Somente Contas de Despesa" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.

/************************** Variable Definition End *************************/

DEF BUFFER b_movto_tit_ap     FOR movto_tit_ap.
DEF BUFFER b_aprop_ctbl_ap    FOR aprop_ctbl_ap.
DEF BUFFER b_movto_tit_ap_aux FOR movto_tit_ap.

/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. 

/* ***************************  Main Block  *************************** */

do on stop undo, leave:

   IF OPSYS = "unix" THEN DO:
       EMPTY TEMP-TABLE tt-prog-ponto.

       RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                          INPUT 1,
                          INPUT 0,
                          INPUT "":U,
                          OUTPUT TABLE tt-prog-ponto).

       FOR FIRST tt-prog-ponto:

           ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).

       END.

       ASSIGN tt-param.arquivo = c-dir-saida + "/":U + tt-param.usuario + "/":U + tt-param.arquivo.

   END.

END.



run utp/ut-acomp.p persistent set h-acomp.  
run pi-inicializar in h-acomp (input "Imprimindo...").
output stream s_1 to value(tt-param.arquivo) convert target 'iso8859-1'.
RUN piImprimeRelat. 
output stream s_1 close.

/* ** Imprime p gina de parƒmetros ***/
ASSIGN v_cod_arquivo = ENTRY(1, tt-param.arquivo, ".") + ".LOG".

output stream s_1 to value(v_cod_arquivo) convert target 'iso8859-1'.
PUT stream s_1 UNFORMATTED "Faixa Estab: " v_estab_ini " AT " v_estab_fim SKIP     
                           "Faixa Datas: " v_data_ini  " AT " v_data_fim  SKIP     
                           "Faixa Conta Contabil: " v_cod_cta_ctbl_ini " AT " v_cod_cta_ctbl_fim SKIP
                           "Faixa CCusto:  " v_ccusto_ini " AT " v_ccusto_fim    SKIP 
                           "Somente Despesa: " l-despesa    SKIP     
                           "ACR: " l-ACR                    SKIP
                           "APB: " l-APB                    SKIP
                           "APL: " l-APL                    SKIP
                           "CMG: " l-CMG                    SKIP
                           "Usu rio: " tt-param.usuario     SKIP
                           "Data: " TODAY                   SKIP
                           "Hora: " STRING(TIME,"HH:MM:SS") SKIP
                           "Arquivo Gerado: " tt-param.arquivo.
output stream s_1 close.

run pi-finalizar in h-acomp.  

RETURN "OK".



/* **********************  Internal Procedures  *********************** */


PROCEDURE piImprimeRelat:
        DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    
        ASSIGN v_cod_cta_ctbl_ini = tt-param.ini-conta
               v_cod_cta_ctbl_fim = tt-param.fim-conta
               v_data_ini         = tt-param.ini-data
               v_data_fim         = tt-param.fim-data
               l-despesa          = tt-param.l-despesa
               v_ccusto_ini       = tt-param.ini-ccusto
               v_ccusto_fim       = tt-param.fim-ccusto
               v_estab_ini        = tt-param.ini-estab
               v_estab_fim        = tt-param.fim-estab
               l-ACR              = tt-param.l-ACR
               l-APB              = tt-param.l-APB
               l-APL              = tt-param.l-APL
               l-CMG              = tt-param.l-CMG.

        for each tt-dados:
            delete tt-dados.
        end.

        run pi-acompanhar in h-acomp (input "Ler Lancto Conta").
        FOR EACH cta_ctbl NO-LOCK
           WHERE cta_ctbl.cod_plano_cta_ctbl  = "PADRAO"
             AND cta_ctbl.cod_cta_ctbl       >= v_cod_cta_ctbl_ini
             AND cta_ctbl.cod_cta_ctbl       <= v_cod_cta_ctbl_fim:

           run pi-acompanhar in h-acomp (input "Lendo Lancto Conta: " + cta_ctbl.cod_cta_ctbl).
        
           IF l-despesa = YES 
           THEN DO:
                IF cta_ctbl.cod_cta_ctbl < "40000000"
                OR cta_ctbl.cod_cta_ctbl > "41999999"
                   THEN NEXT.
           END.
        
           RUN pi_leitura_lancto (INPUT cta_ctbl.cod_cta_ctbl,
                                  INPUT-OUTPUT TABLE tt-dados).
        END.

        PUT stream s_1 UNFORMATTED "Estab;Origem;DB/CR;Emitente;NomeEmitente;Data;Especie;Serie;Titulo;Parcela;Valor;Conta;DescricaoConta;CCusto;DescricaoCCusto;UN;DescricaoUN;Vencto;Vencto Orig;Prev Pagto;Grupo;Emissao;Moeda;Transacao;Grupo Cobran‡a;Referˆncia;Portador;Carteira;Cotacao;Usuario;NomeUsuario;DataLog;Hora;UF Emitente;Contabilizado;Historico;Situa‡Æo;Usuar Libera‡Æo;Data Liber Pagto;Hora Libera‡Æo;Vl Liber Pagto" SKIP. 
                                       
        run pi-acompanhar in h-acomp (input "Gerar Relat¢rio").

        FOR EACH tt-dados:

            run pi-acompanhar in h-acomp (input "Gerando Relat¢rio Dia: " + STRING(tt-dados.dt_transacao,"99/99/9999")).
        
            IF tt-dados.cod_cta_ctbl < v_cod_cta_ctbl_ini
            OR tt-dados.cod_cta_ctbl > v_cod_cta_ctbl_fim THEN
               NEXT.

            IF tt-dados.cod_ccusto < v_ccusto_ini
            OR tt-dados.cod_ccusto > v_ccusto_fim THEN 
               NEXT.

            IF tt-dados.cod_estab < v_estab_ini
            OR tt-dados.cod_estab > v_estab_fim THEN 
               NEXT.

            ASSIGN tt-dados.des_lancto = REPLACE(tt-dados.des_lancto, ";":U, ",":U)
                   tt-dados.des_lancto = REPLACE(tt-dados.des_lancto, CHR(10), " ")
                   tt-dados.des_lancto = REPLACE(tt-dados.des_lancto, CHR(11), " ")
                   tt-dados.des_lancto = REPLACE(tt-dados.des_lancto, CHR(12), " ")
                   tt-dados.des_lancto = REPLACE(tt-dados.des_lancto, CHR(13), " ")
                   tt-dados.cod_tit_ap = REPLACE(tt-dados.cod_tit_ap, ";":U, ",":U)
                   tt-dados.des_item   = REPLACE(tt-dados.des_item, ";":U, ",":U).

            DO i-cont = 1 TO 31:
                ASSIGN tt-dados.des_lancto = REPLACE(tt-dados.des_lancto, CHR(i-cont), CHR(32)).
            END.

            IF INDEX(tt-dados.des_lancto, CHR(32) + CHR(32)) <> 0 THEN DO:
                DO i-cont = 12 TO 2 BY -1:
                    ASSIGN tt-dados.des_lancto = REPLACE(tt-dados.des_lancto, FILL(CHR(32), i-cont), CHR(32)).
                END.
            END.

            ASSIGN tt-dados.des_lancto = TRIM(tt-dados.des_lancto).
            
            DO i-cont = 1 TO 31:
                ASSIGN tt-dados.des_item = REPLACE(tt-dados.des_item, CHR(i-cont), CHR(32)).
            END.

            IF INDEX(tt-dados.des_item, CHR(32) + CHR(32)) <> 0 THEN DO:
                DO i-cont = 12 TO 2 BY -1:
                    ASSIGN tt-dados.des_item = REPLACE(tt-dados.des_item, FILL(CHR(32), i-cont), CHR(32)).
                END.
            END.

            ASSIGN tt-dados.des_item = TRIM(tt-dados.des_item).


            IF tt-dados.ind_natur_lancto_ctbl = "DB"
               THEN ASSIGN v_val_aprop_ctbl = tt-dados.val_aprop_ctbl.
               ELSE ASSIGN v_val_aprop_ctbl = tt-dados.val_aprop_ctbl * (-1).
        
            find cta_ctbl no-lock
                where cta_ctbl.cod_plano_cta_ctbl = "PADRAO"
                  and cta_ctbl.cod_cta_ctbl       = tt-dados.cod_cta_ctbl no-error.
            if avail cta_ctbl
               then assign v_des_cta_ctbl = cta_ctbl.des_tit_ctbl.
               else assign v_des_cta_ctbl = "Nao Localizada".

            find emscad.ccusto no-lock
                where ccusto.cod_empresa      = "1"
                  AND ccusto.cod_plano_ccusto = "PADRAO"
                  and ccusto.cod_ccusto       = tt-dados.cod_ccusto no-error.
            if avail ccusto
               then assign v_des_ccusto = emscad.ccusto.des_tit_ctbl.
               else assign v_des_ccusto = "Nao Localizada".

            find unid_negoc no-lock
                where unid_negoc.cod_unid_negoc = tt-dados.cod_unid_negoc no-error.
            if avail unid_negoc
               then assign v_des_unid_negoc = unid_negoc.des_unid_negoc.
               else assign v_des_unid_negoc = "Nao Localizada".

            FIND usuar_mestre NO-LOCK
                WHERE usuar_mestre.cod_usuar = tt-dados.cod_usuar_ult_atualiz NO-ERROR.

            FIND FIRST int-emitente NO-LOCK
                 WHERE int-emitente.cod-emitente = tt-dados.cod_emitente NO-ERROR.

            ASSIGN v_dat_vencto        = IF tt-dados.dat_vencto           <> ? THEN STRING(tt-dados.dat_vencto)        ELSE ""
                   v_dat_vencto_origin = IF tt-dados.dat_vencto_origin    <> ? THEN STRING(tt-dados.dat_vencto_origin) ELSE ""
                   v_dat_prev_pagto    = IF tt-dados.dat_prev_pagto       <> ? THEN STRING(tt-dados.dat_prev_pagto)    ELSE ""
                   v_dat_emis_docto    = IF tt-dados.dat_emis_docto       <> ? THEN STRING(tt-dados.dat_emis_docto)    ELSE ""
                   v_dat_alter         = IF tt-dados.dat_ult_atualiz      <> ? THEN STRING(tt-dados.dat_ult_atualiz)   ELSE ""
                   v_hr_alter          = IF tt-dados.hra_ult_atualiz      <> "00:00:00" THEN STRING(tt-dados.hra_ult_atualiz)      ELSE ""
                   v_val_cotac         = IF tt-dados.val_cotac_indic_econ <> ?          THEN STRING(tt-dados.val_cotac_indic_econ) ELSE ""
                   v_nom_usuar         = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuar ELSE ""
                   v-cod-gr-cob        = IF AVAIL int-emitente THEN int-emitente.cod-gr-cob ELSE 0.

            PUT STREAM s_1 UNFORMATTED tt-dados.cod_estab                    + ";" +
                                       tt-dados.origem                       + ";" +
                                       tt-dados.ind_natur_lancto_ctbl        + ";" +
                                       STRING(tt-dados.cod_emitente)         + ";" +
                                       tt-dados.nome_emitente                + ";" +
                                       STRING(tt-dados.dt_transacao)         + ";" +
                                       tt-dados.cod_espec_docto              + ";" +
                                       tt-dados.cod_ser_docto                + ";" +
                                       tt-dados.cod_tit_ap                   + ";" +
                                       tt-dados.cod_parcela                  + ";" +
                                       STRING(v_val_aprop_ctbl)              + ";" +
                                       tt-dados.cod_cta_ctbl                 + ";" +
                                       v_des_cta_ctbl                        + ";" +
                                       tt-dados.cod_ccusto                   + ";" +
                                       v_des_ccusto                          + ";" +
                                       tt-dados.cod_unid_negoc               + ";" +
                                       v_des_unid_negoc                      + ";" +
                                       v_dat_vencto                          + ";" +
                                       v_dat_vencto_origin                   + ";" +
                                       v_dat_prev_pagto                      + ";" +
                                       tt-dados.cod_grp                      + ";" +
                                       v_dat_emis_docto                      + ";" +
                                       tt-dados.cod_indic_econ               + ";" +
                                       tt-dados.ind_trans                    + ";" +
                                       string(v-cod-gr-cob)                  + ";" +
                                       tt-dados.cod_refer                    + ";" +
                                       tt-dados.cod_portador                 + ";" +
                                       tt-dados.cod_carteira                 + ";" +
                                       v_val_cotac                           + ";" +
                                       tt-dados.cod_usuar_ult_atualiz        + ";" +
                                       v_nom_usuar                           + ";" +
                                       v_dat_alter                           + ";" +
                                       v_hr_alter                            + ";" +
                                       tt-dados.uf_emitente                  + ";" +
                                       STRING(tt-dados.log_contabilizado)    + ";" +
                                       string(tt-dados.des_lancto).             

                                       IF tt-dados.ind_sit_proces_pagto <> "" THEN DO:
                                            PUT STREAM s_1 UNFORMATTED ";" + string(tt-dados.ind_sit_proces_pagto)   + ";" +
                                                                             string(tt-dados.cod_usuar_liber_pagto)  + ";" +
                                                                             IF tt-dados.dat_liber_pagto        <> ? THEN string(tt-dados.dat_liber_pagto) + ";"        ELSE ";"
                                                                             IF tt-dados.hra_liber_proces_pagto <> ? THEN string(tt-dados.hra_liber_proces_pagto,"99:99:99") + ";" ELSE ";"
                                                                             string(tt-dados.val_liberd_pagto). 
                                       END.

                                       PUT STREAM s_1 UNFORMATTED SKIP.
                                           
        END.
        

END PROCEDURE.
/*****************************************************************************
**  Procedure Interna: pi_leitura_lancto
**  Descricao........: Leitura Movimenta‡äes
*****************************************************************************/
PROCEDURE pi_leitura_lancto:

   DEF INPUT PARAMETER p_cod_cta_ctbl AS CHAR FORMAT "x(8)" NO-UNDO.
   DEF INPUT-OUTPUT PARAM TABLE FOR tt-dados.

   DEF VAR i-data      AS DATE.
   DEF VAR c-ct-codigo LIKE movto-estoq.ct-codigo.

   DEFINE VARIABLE v_cod_return AS CHARACTER   NO-UNDO.

   IF l-estoque = NO 
   THEN DO:
       FOR EACH estabelecimento NO-LOCK
           WHERE estabelecimento.cod_empresa = v_cod_empres_usuar
             AND estabelecimento.cod_estab  >= v_estab_ini
             AND estabelecimento.cod_estab  <= v_estab_fim:
           
           /* ** Movimentos Contas a Pagar - APB ***/
           IF l-APB = YES 
           THEN DO:
               FOR EACH aprop_ctbl_ap NO-LOCK
                   WHERE aprop_ctbl_ap.cod_estab           = estabelecimento.cod_estab
                     AND aprop_ctbl_ap.cod_plano_cta_ctbl  = "PADRAO"
                     AND aprop_ctbl_ap.cod_cta_ctbl        = p_cod_cta_ctbl
                     AND aprop_ctbl_ap.dat_transacao      >= v_data_ini
                     AND aprop_ctbl_ap.dat_transacao      <= v_data_fim:
            
                   FIND FIRST movto_tit_ap NO-LOCK
                        WHERE movto_tit_ap.cod_estab           = aprop_ctbl_ap.cod_estab
                          AND movto_tit_ap.num_id_movto_tit_ap = aprop_ctbl_ap.num_id_movto_tit_ap
                          AND movto_tit_ap.log_ctbz_aprop_ctbl = YES NO-ERROR.
            
                   IF NOT AVAIL movto_tit_ap 
                      THEN NEXT.
        
                   CREATE tt-dados.
                   ASSIGN tt-dados.cod_estab             = estabelecimento.cod_estab
                          tt-dados.origem                = "APB"
                          tt-dados.ind_natur_lancto_ctbl = aprop_ctbl_ap.ind_natur_lancto_ctbl
                          tt-dados.dt_transacao          = aprop_ctbl_ap.dat_transacao
                          tt-dados.val_aprop_ctbl        = aprop_ctbl_ap.val_aprop_ctbl
                          tt-dados.cod_cta_ctbl          = aprop_ctbl_ap.cod_cta_ctbl
                          tt-dados.cod_ccusto            = aprop_ctbl_ap.cod_ccusto
                          tt-dados.cod_unid_negoc        = aprop_ctbl_ap.cod_unid_negoc
                          tt-dados.ind_trans             = movto_tit_ap.ind_trans_ap_abrev
                          tt-dados.cod_portador          = movto_tit_ap.cod_portador
                          tt-dados.cod_usuar_ult_atualiz = movto_tit_ap.cod_usuario
                          tt-dados.dat_ult_atualiz       = movto_tit_ap.dat_gerac_movto
                          tt-dados.hra_ult_atualiz       = STRING(movto_tit_ap.hra_gerac_movto,"99:99:99")
                          tt-dados.cod_indic_econ        = aprop_ctbl_ap.cod_indic_econ
                          tt-dados.log_contabilizado     = movto_tit_ap.log_aprop_ctbl_ctbzda
                          tt-dados.cod_refer             = movto_tit_ap.cod_refer.
            
                   /*Fabiano - Tratamento para t¡tulos implantados em outra moeda*/
                   if aprop_ctbl_ap.cod_indic_econ <> 'real'
                   then do:
                        assign tt-dados.val_aprop_ctbl = 0.
                        for each val_aprop_ctbl_ap of aprop_ctbl_ap 
                            WHERE val_aprop_ctbl_ap.cod_finalid_econ = "Corrente" no-lock:
                            assign tt-dados.val_aprop_ctbl       = tt-dados.val_aprop_ctbl + val_aprop_ctbl_ap.val_aprop.
                            IF val_aprop_ctbl_ap.val_cotac_indic_econ <> 0 
                               THEN ASSIGN tt-dados.val_cotac_indic_econ = 1 / val_aprop_ctbl_ap.val_cotac_indic_econ.
                        end.
                        FIND val_movto_ap_correc_val OF movto_tit_ap NO-LOCK
                            WHERE val_movto_ap_correc_val.cod_finalid_econ = "Corrente" NO-ERROR.
                        IF AVAIL val_movto_ap_correc_val 
                           THEN ASSIGN tt-dados.val_cotac_indic_econ = 1 / val_movto_ap_correc_val.val_cotac_indic_econ.
                        
                        /* ** Localiza cota‡Æo que est  no t¡tulo origem***/
                        IF tt-dados.val_cotac_indic_econ = 0 
                        THEN DO:
                             FIND FIRST b_movto_tit_ap_aux NO-LOCK
                                 WHERE b_movto_tit_ap_aux.cod_estab     = movto_tit_ap.cod_estab
                                   AND b_movto_tit_ap_aux.num_id_tit_ap = movto_tit_ap.num_id_tit_ap NO-ERROR.
                             FOR EACH b_movto_tit_ap NO-LOCK
                                 WHERE b_movto_tit_ap.cod_estab           = b_movto_tit_ap_aux.cod_estab_tit_ap_pai
                                   AND b_movto_tit_ap.num_id_movto_tit_ap = b_movto_tit_ap_aux.num_id_movto_tit_ap_pai:
                                 FOR EACH b_aprop_ctbl_ap OF b_movto_tit_ap NO-LOCK:
                                     FOR EACH val_aprop_ctbl_ap OF b_aprop_ctbl_ap NO-LOCK:
                                         ASSIGN tt-dados.val_cotac_indic_econ = 1 / val_aprop_ctbl_ap.val_cotac_indic_econ.
                                     END.
                                 END.
                             END.
                        END.

                   END.
            
                   FIND FIRST emscad.fornecedor NO-LOCK
                        WHERE fornecedor.cod_empresa    = movto_tit_ap.cod_empresa 
                          AND fornecedor.cdn_fornecedor = movto_tit_ap.cdn_fornecedor NO-ERROR.
                   IF AVAIL emscad.fornecedor THEN DO:
                       IF emscad.fornecedor.num_pessoa MODULO 2 = 0 THEN DO:
                           FIND pessoa_fisic NO-LOCK
                               WHERE pessoa_fisic.num_pessoa_fisic = emscad.fornecedor.num_pessoa NO-ERROR.
                           IF AVAIL pessoa_fisic THEN
                               ASSIGN tt-dados.uf_emitente = pessoa_fisic.cod_unid_federac.
                       END.
                       ELSE DO:
                           FIND pessoa_jurid NO-LOCK
                               WHERE pessoa_jurid.num_pessoa_jurid = emscad.fornecedor.num_pessoa NO-ERROR.
                           IF AVAIL pessoa_jurid THEN
                               ASSIGN tt-dados.uf_emitente = pessoa_jurid.cod_unid_federac.
                       END.
                       
                       ASSIGN tt-dados.cod_emitente  = emscad.fornecedor.cdn_fornecedor
                              tt-dados.nome_emitente = emscad.fornecedor.nom_pessoa.
                   END.
            
                   FOR EACH histor_tit_movto_ap NO-LOCK 
                       WHERE histor_tit_movto_ap.cod_estab           = movto_tit_ap.cod_estab
                         AND histor_tit_movto_ap.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap
                         AND histor_tit_movto_ap.num_id_tit_ap       = movto_tit_ap.num_id_tit_ap 
                         AND histor_tit_movto_ap.ind_orig_histor_ap <> "Erro":
                       ASSIGN tt-dados.des_lancto = tt-dados.des_lancto + histor_tit_movto_ap.des_text_histor + " ".
                   END.
            
                   FIND FIRST tit_ap OF movto_tit_ap NO-LOCK NO-ERROR.

                   
            
                   IF AVAIL tit_ap THEN DO:

                       FIND LAST proces_pagto OF tit_ap NO-LOCK NO-ERROR.

                       IF AVAIL proces_pagto THEN 
                           ASSIGN tt-dados.ind_sit_proces_pagto    = proces_pagto.ind_sit_proces_pagto 
                                  tt-dados.cod_usuar_liber_pagto   = proces_pagto.cod_usuar_liber_pagto 
                                  tt-dados.dat_liber_pagto         = proces_pagto.dat_liber_pagto
                                  tt-dados.hra_liber_proces_pagto  = proces_pagto.hra_liber_proces_pagto 
                                  tt-dados.val_liberd_pagto        = proces_pagto.val_liberd_pagto.

                       ASSIGN tt-dados.cod_espec_docto   = tit_ap.cod_espec_docto
                              tt-dados.cod_ser_docto     = tit_ap.cod_ser_docto
                              tt-dados.cod_tit_ap        = tit_ap.cod_tit_ap
                              tt-dados.cod_parcela       = tit_ap.cod_parcela
                              tt-dados.dat_vencto        = tit_ap.dat_vencto_tit_ap
                              tt-dados.dat_prev_pagto    = tit_ap.dat_prev_pagto 
                              tt-dados.cod_grp           = tit_ap.cod_grp_fornec
                              tt-dados.dat_emis_docto    = tit_ap.dat_emis_docto
                              tt-dados.cod_indic_econ    = tit_ap.cod_indic_econ.         
                   END.
               END.
           END.
        
           /* ** Movimentos Contas a Receber - ACR ***/
           IF l-ACR = YES 
           THEN DO:
               FOR EACH aprop_ctbl_acr NO-LOCK
                   WHERE aprop_ctbl_acr.cod_estab           = estabelecimento.cod_estab
                     AND aprop_ctbl_acr.cod_plano_cta_ctbl  = "PADRAO"
                     AND aprop_ctbl_acr.cod_cta_ctbl        = p_cod_cta_ctbl
                     AND aprop_ctbl_acr.dat_transacao      >= v_data_ini
                     AND aprop_ctbl_acr.dat_transacao      <= v_data_fim:
            
                   FIND FIRST movto_tit_acr NO-LOCK
                        WHERE movto_tit_acr.cod_estab            = aprop_ctbl_acr.cod_estab
                          AND movto_tit_acr.num_id_movto_tit_acr = aprop_ctbl_acr.num_id_movto_tit_acr
                          AND movto_tit_acr.log_ctbz_aprop_ctbl  = YES NO-ERROR.
            
                   IF NOT AVAIL movto_tit_acr 
                      THEN NEXT.
            
                   FIND FIRST tit_acr OF movto_tit_acr NO-LOCK NO-ERROR.
            
                   IF NOT AVAIL tit_acr 
                      THEN NEXT.
            
                   CREATE tt-dados.
                   ASSIGN tt-dados.cod_estab             = estabelecimento.cod_estab
                          tt-dados.origem                = "ACR"
                          tt-dados.ind_natur_lancto_ctbl = aprop_ctbl_acr.ind_natur_lancto_ctbl
                          tt-dados.dt_transacao          = aprop_ctbl_acr.dat_transacao
                          tt-dados.cod_espec_docto       = tit_acr.cod_espec_docto
                          tt-dados.cod_ser_docto         = tit_acr.cod_ser_docto
                          tt-dados.cod_tit_ap            = tit_acr.cod_tit_acr
                          tt-dados.cod_parcela           = tit_acr.cod_parcela
                          tt-dados.val_aprop_ctbl        = aprop_ctbl_acr.val_aprop_ctbl
                          tt-dados.cod_cta_ctbl          = aprop_ctbl_acr.cod_cta_ctbl
                          tt-dados.cod_ccusto            = aprop_ctbl_acr.cod_ccusto
                          tt-dados.cod_unid_negoc        = aprop_ctbl_acr.cod_unid_negoc
                          tt-dados.dat_vencto            = tit_acr.dat_vencto_tit_acr
                          tt-dados.dat_vencto_origin     = tit_acr.dat_vencto_origin_tit_acr
                          tt-dados.dat_prev_pagto        = tit_acr.dat_prev_liquidac
                          tt-dados.cod_grp               = tit_acr.cod_grp_clien
                          tt-dados.dat_emis_docto        = tit_acr.dat_emis_docto
                          tt-dados.cod_indic_econ        = tit_acr.cod_indic_econ
                          tt-dados.ind_trans             = movto_tit_acr.ind_trans_acr_abrev
                          tt-dados.cod_portador          = movto_tit_acr.cod_portador
                          tt-dados.cod_carteira          = movto_tit_acr.cod_cart_bcia
                          tt-dados.cod_usuar_ult_atualiz = movto_tit_acr.cod_usuario
                          tt-dados.dat_ult_atualiz       = movto_tit_acr.dat_gerac_movto
                          tt-dados.hra_ult_atualiz       = STRING(movto_tit_acr.hra_gerac_movto,"99:99:99")
                          tt-dados.log_contabilizado     = movto_tit_acr.log_aprop_ctbl_ctbzda
                          tt-dados.cod_refer             = movto_tit_acr.cod_refer.
        
                   /*Fabiano - Tratamento para t¡tulos implantados em outra moeda*/
                   if aprop_ctbl_acr.cod_indic_econ <> 'real'
                   then do:
                        assign tt-dados.val_aprop_ctbl = 0.
                        for each val_aprop_ctbl_acr of aprop_ctbl_acr  
                            WHERE val_aprop_ctbl_acr.cod_finalid_econ = "Corrente" no-lock:
                            assign tt-dados.val_aprop_ctbl       = tt-dados.val_aprop_ctbl + val_aprop_ctbl_acr.val_aprop.
                            IF val_aprop_ctbl_acr.val_cotac_indic_econ <> 0 
                               THEN ASSIGN tt-dados.val_cotac_indic_econ = 1 / val_aprop_ctbl_acr.val_cotac_indic_econ.
                        end.
        
                        FIND val_movto_acr_correc_val OF movto_tit_acr NO-LOCK
                            WHERE val_movto_acr_correc_val.cod_finalid_econ = "Corrente" NO-ERROR.
                        IF AVAIL val_movto_acr_correc_val 
                           THEN ASSIGN tt-dados.val_cotac_indic_econ = 1 / val_movto_acr_correc_val.val_cotac_indic_econ.
        
                   end.
            
                   FIND FIRST emscad.cliente NO-LOCK
                        WHERE emscad.cliente.cod_empresa = movto_tit_acr.cod_empresa 
                          AND emscad.cliente.cdn_cliente = movto_tit_acr.cdn_cliente NO-ERROR.
            
                   IF AVAIL emscad.cliente  
                      THEN ASSIGN tt-dados.cod_emitente  = emscad.cliente.cdn_cliente
                                  tt-dados.nome_emitente = emscad.cliente.nom_pessoa.
            
                   FOR EACH histor_movto_tit_acr NO-LOCK 
                       WHERE histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                         AND histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                         AND histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr 
                         AND histor_movto_tit_acr.ind_orig_histor_acr <> "Erro":
                       ASSIGN tt-dados.des_lancto = tt-dados.des_lancto + histor_movto_tit_acr.des_text_histor + " ".
                   END.
                   
               END.
           END.
        
           /* ** Movimentos Caixa e Bancos - CMG ***/
           IF l-CMG = YES 
           THEN DO:
               FOR EACH aprop_ctbl_cmg NO-LOCK
                   WHERE aprop_ctbl_cmg.cod_estab           = estabelecimento.cod_estab
                     AND aprop_ctbl_cmg.cod_plano_cta_ctbl  = "PADRAO"
                     AND aprop_ctbl_cmg.cod_cta_ctbl        = p_cod_cta_ctbl
                     AND aprop_ctbl_cmg.dat_transacao      >= v_data_ini
                     AND aprop_ctbl_cmg.dat_transacao      <= v_data_fim:
        
                    FIND FIRST movto_cta_corren OF aprop_ctbl_cmg NO-LOCK NO-ERROR.
        
                    IF NOT AVAIL movto_cta_corren
                       THEN NEXT.
        
                    CREATE tt-dados.
                    ASSIGN tt-dados.cod_estab             = estabelecimento.cod_estab
                           tt-dados.origem                = "CMG"
                           tt-dados.ind_natur_lancto_ctbl = aprop_ctbl_cmg.ind_natur_lancto_ctbl
                           tt-dados.dt_transacao          = aprop_ctbl_cmg.dat_transacao
                           tt-dados.cod_espec_docto       = ""
                           tt-dados.cod_ser_docto         = ""
                           tt-dados.cod_tit_ap            = ""
                           tt-dados.cod_parcela           = ""
                           tt-dados.cod_emitente          = 0
                           tt-dados.nome_emitente         = ""
                           tt-dados.val_aprop_ctbl        = aprop_ctbl_cmg.val_movto_cta_corren
                           tt-dados.cod_cta_ctbl          = aprop_ctbl_cmg.cod_cta_ctbl
                           tt-dados.cod_ccusto            = aprop_ctbl_cmg.cod_ccusto
                           tt-dados.cod_unid_negoc        = aprop_ctbl_cmg.cod_unid_negoc
                           tt-dados.des_lancto            = movto_cta_corren.des_histor_movto_cta_corren
                           tt-dados.cod_usuar_ult_atualiz = movto_cta_corren.cod_usuar_ult_atualiz
                           tt-dados.dat_ult_atualiz       = movto_cta_corren.dat_ult_atualiz
                           tt-dados.hra_ult_atualiz       = STRING(movto_cta_corren.hra_ult_atualiz,"99:99:99")
                           tt-dados.cod_indic_econ        = movto_cta_corren.cod_indic_econ
                           tt-dados.log_contabilizado     = aprop_ctbl_cmg.log_ctbz_movto_cta_corren.
        
                    /*Fabiano - Tratamento para t¡tulos implantados em outra moeda*/
                    if aprop_ctbl_cmg.cod_indic_econ <> 'real'
                    then do:
                         assign tt-dados.val_aprop_ctbl = 0.
                         for each val_aprop_ctbl_cmg of aprop_ctbl_cmg  
                            WHERE val_aprop_ctbl_cmg.cod_finalid_econ = "Corrente" no-lock:
                             assign tt-dados.val_aprop_ctbl       = tt-dados.val_aprop_ctbl + val_aprop_ctbl_cmg.val_movto_cta_corren
                                    tt-dados.val_cotac_indic_econ = 1 / val_aprop_ctbl_cmg.val_cotac_indic_econ.
                         end.
                    end.
        
               END.
           END.
       END.
   END.

   DO i-data = v_data_ini TO v_data_fim:

      IF  l-estoque = NO 
      AND l-APL = YES
      THEN DO:

          /* ** Movimentos Aplica‡Æo e Empr‚stimos - APL ***/
          FOR EACH aprop_ctbl_apl NO-LOCK
              WHERE aprop_ctbl_apl.cod_empresa        = v_cod_empres_usuar
                AND aprop_ctbl_apl.dat_transacao      = i-data
                AND aprop_ctbl_apl.cod_plano_cta_ctbl = "PADRAO"
                AND aprop_ctbl_apl.cod_cta_ctbl       = p_cod_cta_ctbl:
    
               FIND FIRST movto_operac_financ OF aprop_ctbl_apl NO-LOCK NO-ERROR.
    
               IF NOT AVAIL movto_operac_financ
                  THEN NEXT.
    
               IF (movto_operac_financ.ind_tip_trans_apl = "Varia‡Æo Cambial"
               OR  movto_operac_financ.ind_tip_trans_apl = "Transf Var Cambial"
               OR  movto_operac_financ.ind_tip_trans_apl = "Transf VC Juros"
               OR  movto_operac_financ.ind_tip_trans_apl = "Var Cambial Juros"
               OR  movto_operac_financ.ind_tip_trans_apl = "V Camb Juros Compet"
               OR  movto_operac_financ.ind_tip_trans_apl = "V Camb Competˆncia")
               AND movto_operac_financ.cod_indic_econ   <>  "Real" 
                   THEN NEXT.
    
               FIND operac_financ OF movto_operac_financ NO-LOCK NO-ERROR.
    
               IF NOT AVAIL operac_financ 
                  THEN NEXT.
    
               CREATE tt-dados.
               ASSIGN tt-dados.cod_estab             = aprop_ctbl_apl.cod_estab
                      tt-dados.origem                = "APL"
                      tt-dados.ind_natur_lancto_ctbl = aprop_ctbl_apl.ind_natur_lancto_ctbl
                      tt-dados.dt_transacao          = aprop_ctbl_apl.dat_transacao
                      tt-dados.cod_espec_docto       = ""
                      tt-dados.cod_ser_docto         = ""
                      tt-dados.cod_tit_ap            = ""
                      tt-dados.cod_parcela           = ""
                      tt-dados.cod_emitente          = 0
                      tt-dados.nome_emitente         = ""
                      tt-dados.val_aprop_ctbl        = 0
                      tt-dados.cod_cta_ctbl          = aprop_ctbl_apl.cod_cta_ctbl
                      tt-dados.cod_ccusto            = ""
                      tt-dados.cod_unid_negoc        = aprop_ctbl_apl.cod_unid_negoc
                      tt-dados.des_lancto            = "Banco: " + operac_financ.cod_banco + ". Produto: " + operac_financ.cod_produt_financ + ". Opera‡Æo: " + operac_financ.cod_operac_financ + ". Transa‡Æo: " + movto_operac_financ.ind_tip_trans_apl + "."
                      tt-dados.cod_usuar_ult_atualiz = movto_operac_financ.cod_usuario
                      tt-dados.dat_ult_atualiz       = movto_operac_financ.dat_movto_apl
                      tt-dados.hra_ult_atualiz       = STRING(movto_operac_financ.hra_movto_apl,"99:99:99")
                      tt-dados.cod_indic_econ        = operac_financ.cod_indic_econ
                      tt-dados.log_contabilizado     = movto_operac_financ.log_aprop_ctbl_ctbzda.   
    
               FIND val_aprop_ctbl_apl NO-LOCK 
                  WHERE val_aprop_ctbl_apl.num_id_movto_operac_financ = aprop_ctbl_apl.num_id_movto_operac_financ
                    AND val_aprop_ctbl_apl.num_seq_aprop_ctbl         = aprop_ctbl_apl.num_seq_aprop_ctbl
                    AND val_aprop_ctbl_apl.cod_finalid_econ           = "Corrente" NO-ERROR.
               IF AVAIL val_aprop_ctbl_apl 
                  THEN ASSIGN tt-dados.val_aprop_ctbl = tt-dados.val_aprop_ctbl + val_aprop_ctbl_apl.val_aprop_ctbl.
    
               IF tt-dados.val_aprop_ctbl = 0
               THEN DO:    
                    IF  movto_operac_financ.ind_tip_trans_apl <> "Varia‡Æo Cambial"
                    AND movto_operac_financ.ind_tip_trans_apl <> "Transf Var Cambial"
                    AND movto_operac_financ.ind_tip_trans_apl <> "Transf VC Juros"
                    AND movto_operac_financ.ind_tip_trans_apl <> "Var Cambial Juros"
                    AND movto_operac_financ.ind_tip_trans_apl <> "V Camb Juros Compet"
                    AND movto_operac_financ.ind_tip_trans_apl <> "V Camb Competˆncia"
                    AND movto_operac_financ.cod_indic_econ    <> "Real"   
                    THEN DO:
                         RUN pi_converter_indic_econ_finalid_apl (INPUT movto_operac_financ.cod_indic_econ,
                                                                  INPUT "1",
                                                                  INPUT movto_operac_financ.dat_transacao,
                                                                  INPUT aprop_ctbl_apl.val_aprop_indic_econ_movto,
                                                                  INPUT "Corrente",
                                                                  OUTPUT v_cod_return).
                         FIND FIRST tt_converter_finalid_econ_apl NO-LOCK NO-ERROR. 
                         IF AVAIL tt_converter_finalid_econ_apl 
                            THEN ASSIGN tt-dados.val_aprop_ctbl       = tt_converter_finalid_econ_apl.tta_val_transacao
                                        tt-dados.val_cotac_indic_econ = tt_converter_finalid_econ_apl.tta_val_cotac_indic_econ.
                    END.
               END. 
    
               IF tt-dados.val_aprop_ctbl = 0
                  THEN ASSIGN tt-dados.val_aprop_ctbl = aprop_ctbl_apl.val_aprop_indic_econ_movto.    
    
               FIND FIRST tax_movto_operac_financ NO-LOCK 
                  WHERE tax_movto_operac_financ.num_id_movto_operac_financ = movto_operac_financ.num_id_movto_operac_financ NO-ERROR.
               IF AVAIL tax_movto_operac_financ 
                  THEN ASSIGN tt-dados.val_cotac_indic_econ = (1 / tax_movto_operac_financ.val_cotac_indic_econ_fim)
                              /*tt-dados.cod_indic_econ       = tax_movto_operac_financ.cod_indic_econ_tax_pos*/.
    
          END.
      END.

   END.
  
END.
/********************  End of rpt_motiv_movto_tit_acr_dem *******************/

/*apl301za*/
PROCEDURE pi_converter_indic_econ_finalid_apl:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_unid_organ
        as character
        format "x(3)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_val_transacao
        as decimal
        format "->>,>>>,>>>,>>9.99"
        decimals 2
        no-undo.
    def Input param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_erro_compos_armaz
        as character
        format "x(40)":U
        no-undo.
    def var v_cod_erro_compos_organ
        as character
        format "x(40)":U
        no-undo.
    def var v_cod_return
        as character
        format "x(40)":U
        no-undo.
    def var v_dat_cotac_indic_econ
        as date
        format "99/99/9999":U
        initial today
        label "Data Cota‡Æo"
        column-label "Data Cota‡Æo"
        no-undo.
    def var v_val_cotac_indic_econ
        as decimal
        format "->>,>>>,>>>,>>9.9999999999":U
        decimals 10
        label "Cota‡Æo"
        column-label "Cota‡Æo"
        no-undo.
    def var v_log_existe_compos              as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    elimina:
    for each tt_converter_finalid_econ_apl exclusive-lock:
        delete tt_converter_finalid_econ_apl.
    end.

    find first compos_finalid no-lock 
         where compos_finalid.cod_indic_econ_base = p_cod_indic_econ 
           and compos_finalid.cod_finalid_econ    = p_cod_finalid_econ 
           and compos_finalid.dat_inic_valid     <= p_dat_transacao 
           and compos_finalid.dat_fim_valid      >  p_dat_transacao 
         use-index cmpsfnld_parid_indic_econ no-error. 
    if  not avail compos_finalid
    then do: 
        assign p_cod_return = "782". 
        return. 
    end.

    if  compos_finalid.cod_indic_econ_base <> compos_finalid.cod_indic_econ_idx
    then do: 

        find first compos_finalid_cmcmm no-lock 
              where compos_finalid_cmcmm.cod_finalid_econ       = compos_finalid.cod_finalid_econ 
                and compos_finalid_cmcmm.dat_inic_valid_finalid = compos_finalid.dat_inic_valid_finalid 
                and compos_finalid_cmcmm.cod_indic_econ_base    = compos_finalid.cod_indic_econ_base 
                and compos_finalid_cmcmm.cod_indic_econ_idx     = compos_finalid.cod_indic_econ_idx 
                and compos_finalid_cmcmm.dat_inic_valid_compos  = compos_finalid.dat_inic_valid 
                and compos_finalid_cmcmm.dat_inic_valid        <= p_dat_transacao 
                and compos_finalid_cmcmm.dat_fim_valid         >  p_dat_transacao no-error. 

         if  avail compos_finalid_cmcmm
         then do: 
              run pi_achar_cotac_indic_econ (Input compos_finalid.cod_indic_econ_base,
                                             Input compos_finalid.cod_indic_econ_idx,
                                             Input p_dat_transacao,
                                             Input "Real",
                                             output v_dat_cotac_indic_econ,
                                             output v_val_cotac_indic_econ,
                                             output v_cod_return). 
              if  entry(1,v_cod_return) = "358"
              then do: 
                  elimina:
                  for each tt_converter_finalid_econ_apl exclusive-lock: 
                      delete tt_converter_finalid_econ_apl. 
                  end. 
                  assign p_cod_return = v_cod_return. 
                  return. 
              end. 
              create tt_converter_finalid_econ_apl. 
              assign tt_converter_finalid_econ_apl.tta_cod_finalid_econ     = compos_finalid.cod_finalid_econ 
                     tt_converter_finalid_econ_apl.tta_dat_cotac_indic_econ = v_dat_cotac_indic_econ 
                     tt_converter_finalid_econ_apl.tta_val_cotac_indic_econ = v_val_cotac_indic_econ 
                     tt_converter_finalid_econ_apl.tta_val_transacao        = p_val_transacao / v_val_cotac_indic_econ.

         end. 
    end. 

    assign p_cod_return = "OK".

END PROCEDURE.


PROCEDURE pi_achar_cotac_indic_econ:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ_base
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_indic_econ_idx
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_ind_tip_cotac_parid
        as character
        format "X(09)"
        no-undo.
    def output param p_dat_cotac_indic_econ
        as date
        format "99/99/9999"
        no-undo.
    def output param p_val_cotac_indic_econ
        as decimal
        format ">>>>,>>9.9999999999"
        decimals 10
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_dat_cotac_mes
        as date
        format "99/99/9999":U
        no-undo.
    def var v_log_indic
        as logical
        format "Sim/NÆo"
        initial no
        no-undo.
    def var v_cod_indic_econ_orig            as character       no-undo. /*local*/
    def var v_val_cotac_indic_econ_base      as decimal         no-undo. /*local*/
    def var v_val_cotac_indic_econ_idx       as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* altera‡Æo sob demanda da atividade 148.681*/
    release cotac_parid.

    if  p_cod_indic_econ_base = p_cod_indic_econ_idx
    then do:
        /* **
         Quando a Base e o Öndice forem iguais, significa que a cota‡Æo pode ser percentual,
         portanto nÆo basta apenas retornar 1 e deve ser feita toda a pesquisa abaixo para
         encontrar a taxa da moeda no dia informado.
         Exemplo: D¢lar - D¢lar, poder¡amos retornar 1
                  ANBID - ANBID, devemos retornar a taxa do dia.
        ***/
        find indic_econ no-lock
             where indic_econ.cod_indic_econ  = p_cod_indic_econ_base
               and indic_econ.dat_inic_valid <= p_dat_transacao
               and indic_econ.dat_fim_valid  >  p_dat_transacao
             no-error.
        if  avail indic_econ then do:
            if  indic_econ.ind_tip_cotac = "Valor" /*l_valor*/  then do:
                assign p_dat_cotac_indic_econ = p_dat_transacao
                       p_val_cotac_indic_econ = 1
                       p_cod_return           = "OK" /*l_ok*/ .
            end.
            else do:
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                       and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                       and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                     use-index ctcprd_id no-error.
                if  not avail cotac_parid
                then do:
                    find parid_indic_econ no-lock
                         where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
                           and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
                         use-index prdndccn_id no-error.
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then find prev cotac_parid no-lock
                              where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                and cotac_parid.val_cotac_indic_econ <> 0.0
                              use-index ctcprd_id no-error.
                        when "Pr¢ximo" /*l_proximo*/ then  find next cotac_parid no-lock
                               where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                 and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                 and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                 and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                 and cotac_parid.val_cotac_indic_econ <> 0.0
                               use-index ctcprd_id no-error.
                    end /* case block */.
                    if  not avail cotac_parid
                    then do:
                        assign p_cod_return = "358"                   + "," +
                                              p_cod_indic_econ_base   + "," +
                                              p_cod_indic_econ_idx    + "," +
                                              string(p_dat_transacao) + "," +
                                              p_ind_tip_cotac_parid.
                    end /* if */.
                    else do:
                        assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                               p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                               p_cod_return           = "OK" /*l_ok*/ .
                    end /* else */.
                end /* if */.
                else do:
                    assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                           p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                           p_cod_return           = "OK" /*l_ok*/ .
                end /* else */.
            end.
        end.
        else do:
            assign p_cod_return = "335".
        end.
    end /* if */.
    else do:
        find parid_indic_econ no-lock
             where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
               and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
             use-index prdndccn_id no-error.
        if  avail parid_indic_econ
        then do:


            /* Begin_Include: i_verifica_cotac_parid */
            /* verifica as cotacoes da moeda p_cod_indic_econ_base para p_cod_indic_econ_idx 
              cadastrada na base, de acordo com a periodicidade da cotacao (obtida na 
              parid_indic_econ, que deve estar avail)*/

            /* period_block: */
            case parid_indic_econ.ind_periodic_cotac:
                when "Di ria" /*l_diaria*/ then
                    diaria_block:
                    do:
                        find cotac_parid no-lock
                            where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                              and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                              and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                              and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                            use-index ctcprd_id no-error.
                        if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                        then do:
                            find parid_indic_econ no-lock
                                where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
                                  and parid_indic_econ.cod_indic_econ_idx  = p_cod_indic_econ_idx
                                use-index prdndccn_id no-error.
                            /* block: */
                            case parid_indic_econ.ind_criter_busca:
                                when "Anterior" /*l_anterior*/ then 
                                    find prev cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                          use-index ctcprd_id no-error.
                                when "Pr¢ximo" /*l_proximo*/ then  
                                    find next cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                          use-index ctcprd_id no-error.
                            end /* case block */.
                        end /* if */.
                    end /* do diaria_block */.
                when "Mensal" /*l_mensal*/ then
                    mensal_block:
                    do:
                        assign v_dat_cotac_mes = date(month(p_dat_transacao), 1, year(p_dat_transacao))
                               &if yes = yes &then 
                               v_log_indic     = yes
                               &endif .
                        find cotac_parid no-lock
                            where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                              and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                              and cotac_parid.dat_cotac_indic_econ = v_dat_cotac_mes
                              and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                            use-index ctcprd_id no-error.
                        if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                        then do:
                            /* block: */
                            case parid_indic_econ.ind_criter_busca:
                                when "Anterior" /*l_anterior*/ then
                                    find prev cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ < v_dat_cotac_mes
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                        use-index ctcprd_id no-error.
                                when "Pr¢ximo" /*l_proximo*/ then
                                    find next cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ > v_dat_cotac_mes
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                        use-index ctcprd_id no-error.
                            end /* case block */.
                        end /* if */.
                    end /* do mensal_block */.
                when "Bimestral" /*l_bimestral*/ then
                    bimestral_block:
                    do:
                    end /* do bimestral_block */.
                when "Trimestral" /*l_trimestral*/ then
                    trimestral_block:
                    do:
                    end /* do trimestral_block */.
                when "Quadrimestral" /*l_quadrimestral*/ then
                    quadrimestral_block:
                    do:
                    end /* do quadrimestral_block */.
                when "Semestral" /*l_semestral*/ then
                    semestral_block:
                    do:
                    end /* do semestral_block */.
                when "Anual" /*l_anual*/ then
                    anual_block:
                    do:
                    end /* do anual_block */.
            end /* case period_block */.
            
        end /* if */.
        if v_log_indic = yes then do:
           if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
           then do:
               assign p_cod_return = "358"                 + "," +
                      p_cod_indic_econ_base   + "," +
                      p_cod_indic_econ_idx    + "," +
                      string(v_dat_cotac_mes) + "," +
                      p_ind_tip_cotac_parid.
           end /* if */.
           else do:
               assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                      p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                      p_cod_return           = "OK" /*l_ok*/ .
           end /* else */.
        end.
        else do:   
           if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
           then do:
               assign p_cod_return = "358"                 + "," +
                      p_cod_indic_econ_base   + "," +
                      p_cod_indic_econ_idx    + "," +
                      string(p_dat_transacao) + "," +
                      p_ind_tip_cotac_parid.
           end /* if */.
           else do:
               assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                      p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                      p_cod_return           = "OK" /*l_ok*/ .
           end /* else */.
        end.
        assign v_log_indic = no.
    end /* else */.
END PROCEDURE. /* pi_achar_cotac_indic_econ */

PROCEDURE pi-desp-asc:
    FOR FIRST despesa-aces
        WHERE despesa-aces.ser-docto-ac  = doc-fiscal.serie
          AND despesa-aces.nro-docto-ac  = doc-fiscal.nr-doc-fis
          AND despesa-aces.cod-forn-ac   = doc-fiscal.cod-emitente
          AND despesa-aces.nat-oper-ac   = doc-fiscal.nat-operacao no-LOCK:


          ASSIGN tt-dados.nf-desp-aces   = despesa-aces.nro-docto
                 tt-dados.serie-desp     = despesa-aces.serie-doc
                 tt-dados.nat-oper-desp  = despesa-aces.nat-operacao.

    END.
END.
