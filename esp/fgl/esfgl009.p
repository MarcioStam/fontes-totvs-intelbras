/* 
**
** Este programa foi descontinuado e substituido pelo programa ESFGL010 em 09/05/2016
**

def temp-table tt_input_leitura_sdo no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    field ttv_num_seq_2                    as integer format ">>>>,>>9"
    index tt_ID                            is primary
          ttv_num_seq_1                    ascending.

def temp-table tt_retorna_sdo_ctbl no-undo
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequ¼ncia" column-label "NumSeq"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Contÿbil" column-label "Conta Contÿbil"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_proj_financ              as character format "x(20)" label "Projeto" column-label "Projeto"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cenÿrio Contÿbil" column-label "Cenÿrio Contÿbil"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg"
    field tta_dat_sdo_ctbl                 as date format "99/99/9999" initial ? label "Data Saldo Contÿbil" column-label "Data Saldo Contÿbil"
    field tta_val_sdo_ctbl_db              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto D²bito" column-label "Movto D²bito"
    field tta_val_sdo_ctbl_cr              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto Cr²dito" column-label "Movto Cr²dito"
    field tta_val_sdo_ctbl_fim             as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Contÿbil Final" column-label "Saldo Contÿbil Final"
    field tta_val_apurac_restdo            as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apura»’o Resultado" column-label "Apura»’o Resultado"
    field tta_val_apurac_restdo_db         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apura»’o Restdo DB" column-label "Apura»’o Restdo DB"
    field tta_val_apurac_restdo_cr         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apura»’o Restdo CR" column-label "Apura»’o Restdo CR"
    field tta_val_apurac_restdo_acum       as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuracao Final" column-label "Apuracao Final"
    field tta_val_sdo_ctbl_db_sint         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto D²bito Sint" column-label "Movto D²bito Sint"
    field tta_val_sdo_ctbl_cr_sint         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto Cr²dito Sint" column-label "Movto Cr²dito Sint"
    field tta_val_sdo_ctbl_fim_sint        as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Sint²tico" column-label "Saldo Sint²tico"
    field tta_val_apurac_restdo_sint       as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuracao Resultado" column-label "Apuracao Resultado"
    field tta_val_apurac_restdo_sint_db    as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apur Restdo Sint DB" column-label "Apur Restdo Sint DB"
    field tta_val_apurac_restdo_sint_cr    as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apur Restdo Sint CR" column-label "Apur Restdo Sint CR"
    field tta_val_apurac_restdo_sint_acum  as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apur Result Sint" column-label "Apur Result Sint"
    field tta_val_movto_empenh             as decimal format "->>,>>>,>>>,>>9.99" decimals 9 initial 0 label "Movto Empenhado" column-label "Movto Empenhado"
    field tta_qtd_sdo_ctbl_db              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade DB" column-label "Quantidade DB"
    field tta_qtd_sdo_ctbl_cr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade CR" column-label "Quantidade CR"
    field tta_qtd_sdo_ctbl_fim             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade Final" column-label "Quantidade Final"
    field ttv_val_movto_ctbl               as decimal format ">>>,>>>,>>>,>>9.99" decimals 2
    field tta_qtd_movto_empenh             as decimal format "->>>>,>>9.9999" decimals 4 initial 0 label "Qtde Movto Empenhado" column-label "Qtde Movto Empenhado"
    index tt_cta                          
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
    index tt_id                            is primary unique
          tta_cod_empresa                  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_proj_financ              ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_dat_sdo_ctbl                 ascending
          tta_num_seq                      ascending
    index tt_id2                          
          tta_cod_empresa                  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_proj_financ              ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_dat_sdo_ctbl                 ascending
    index tt_seq                          
          tta_num_seq                      ascending.

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seq±¼ncia" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsist¼ncia" column-label "Inconsist¼ncia"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda".


DEF TEMP-TABLE tt_ctas NO-UNDO 
    FIELD tta_cod_cta_ctbl             LIKE cta_ctbl.cod_cta_ctbl
    FIELD tta_des_grp_cta_ctbl         LIKE grp_cta_ctbl.des_grp_cta_ctbl.

DEFINE VARIABLE l_titulo  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c_titulo  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-sdo     AS DECIMAL     format "->>,>>>,>>>,>>9.99" NO-UNDO.

DEFINE VARIABLE d-db AS DECIMAL     format "->>,>>>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE d-cr AS DECIMAL     format "->>,>>>,>>>,>>9.99" NO-UNDO.

DEFINE VARIABLE c-cta AS CHARACTER   NO-UNDO.

DEF BUFFER bcta_ctbl          FOR cta_ctbl.
DEF BUFFER bitem_demonst_ctbl FOR item_demonst_ctbl.

OUTPUT TO c:\temp\demonst.csv CONVERT TARGET "iso8859-1".

PUT UNFORMATTED "nivel 1;nivel 2;agrupador;estab;cta;periodo;sdo ini;movto;sdo fim" SKIP.

OUTPUT CLOSE.

FIND demonst_ctbl NO-LOCK
    WHERE demonst_ctbl.cod_demonst_ctbl = 'DCKPMG10' NO-ERROR.
FOR EACH ITEM_demonst_ctbl OF demonst_ctbl NO-LOCK:

    IF  ITEM_demonst_ctbl.ind_tip_lin_demonst <> 'titulo' 
    AND ITEM_demonst_ctbl.ind_tip_lin_demonst <> 'calculo' 
    AND ITEM_demonst_ctbl.ind_tip_lin_demonst <> 'valor' 
        THEN NEXT.

    IF ITEM_demonst_ctbl.ind_tip_lin_demonst = 'titulo' 
    THEN DO:
         IF ITEM_demonst_ctbl.des_tit_ctbl = 'ativo' 
         OR ITEM_demonst_ctbl.des_tit_ctbl = 'passivo'
            THEN NEXT.

         IF l_titulo = NO 
            THEN ASSIGN c_titulo = "".
         IF c_titulo = ""
         THEN DO: 
              ASSIGN c_titulo = ITEM_demonst_ctbl.des_tit_ctbl.
         END.
         ASSIGN l_titulo = YES.
         NEXT.
    END.
    IF ITEM_demonst_ctbl.ind_tip_lin_demonst = 'calculo'  
    THEN DO:
        /* localiza contas e localiza saldos */
        EMPTY TEMP-TABLE tt_ctas.
        FOR EACH compos_demonst_ctbl OF ITEM_demonst_ctbl NO-LOCK:

            ASSIGN c-cta = compos_demonst_ctbl.cod_cta_ctbl_fim.
            FIND LAST cta_ctbl NO-LOCK
                WHERE cta_ctbl.cod_plano_cta  = 'padrao'
                  AND cta_ctbl.cod_cta_ctbl  <= compos_demonst_ctbl.cod_cta_ctbl_fim 
                  AND cta_ctbl.cod_cta_ctbl  >= compos_demonst_ctbl.cod_cta_ctbl_ini NO-ERROR.

            IF cta_ctbl.ind_espec_cta_ctbl = "Sintetica" 
            THEN DO:
                 RUN pi_procura(INPUT cta_ctbl.cod_cta_ctbl).
            END.
            ELSE DO:
                 ASSIGN c-cta = cta_ctbl.cod_cta_ctbl.
            END.

            FOR EACH cta_ctbl NO-LOCK
                WHERE cta_ctbl.cod_plano_cta = 'padrao'
                  AND cta_ctbl.cod_cta_ctbl >= compos_demonst_ctbl.cod_cta_ctbl_ini
                  AND cta_ctbl.cod_cta_ctbl <= c-cta:
                FIND grp_cta_ctbl OF cta_ctbl NO-LOCK.
                CREATE tt_ctas.
                ASSIGN tt_ctas.tta_cod_cta_ctbl     = cta_ctbl.cod_cta_ctbl
                       tt_ctas.tta_des_grp_cta_ctbl = grp_cta_ctbl.des_grp_cta_ctbl.
            END.

        END.
    END.
    IF ITEM_demonst_ctbl.ind_tip_lin_demonst = 'valor' 
    THEN DO:
         IF ITEM_demonst_ctbl.des_tit_ctbl = "" 
            THEN NEXT.

         FIND LAST bitem_demonst_ctbl OF demonst_ctbl NO-LOCK
             WHERE bitem_demonst_ctbl.num_seq_demonst_ctbl < item_demonst_ctbl.num_seq_demonst_ctbl.
         IF bitem_demonst_ctbl.ind_tip_lin_demonst = 'valor'
            THEN NEXT.

         FOR EACH tt_ctas:

            EMPTY TEMP-TABLE tt_input_leitura_sdo.
      
            CREATE tt_input_leitura_sdo.
            ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Empresa"
                   tt_input_leitura_sdo.ttv_des_conteudo = '1'
                   tt_input_leitura_sdo.ttv_num_seq_1    = 1
                   tt_input_leitura_sdo.ttv_num_seq_2    = 1.
            
            CREATE tt_input_leitura_sdo.
            ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Finalidade Economica"
                   tt_input_leitura_sdo.ttv_des_conteudo = 'Corrente'
                   tt_input_leitura_sdo.ttv_num_seq_1    = 1
                   tt_input_leitura_sdo.ttv_num_seq_2    = 2. 
            
            CREATE tt_input_leitura_sdo. 
            ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Conta Contabil Inicial"
                   tt_input_leitura_sdo.ttv_des_conteudo = tt_ctas.tta_cod_cta_ctbl
                   tt_input_leitura_sdo.ttv_num_seq_1    = 1
                   tt_input_leitura_sdo.ttv_num_seq_2    = 3.
            
            CREATE tt_input_leitura_sdo. 
            ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Conta Contabil Final"
                   tt_input_leitura_sdo.ttv_des_conteudo = tt_ctas.tta_cod_cta_ctbl
                   tt_input_leitura_sdo.ttv_num_seq_1    = 1
                   tt_input_leitura_sdo.ttv_num_seq_2    = 4.
            
            CREATE tt_input_leitura_sdo.
            ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Data Final"
                   tt_input_leitura_sdo.ttv_des_conteudo = STRING(02/29/2016, "99/99/9999")
                   tt_input_leitura_sdo.ttv_num_seq_1    = 1
                   tt_input_leitura_sdo.ttv_num_seq_2    = 5.            
            
             RUN prgfin/fgl/fgl905zb.py (INPUT 1,
                                         INPUT TABLE tt_input_leitura_sdo,
                                         OUTPUT TABLE tt_retorna_sdo_ctbl,
                                         OUTPUT TABLE tt_log_erros).
              
             FOR EACH tt_retorna_sdo_ctbl
                 BREAK BY tt_retorna_sdo_ctbl.tta_cod_estab:
                 /* ** Filtrar estabelecimento conforme sele‡Æo
                 IF tt_retorna_sdo_ctbl.tta_cod_estab THEN NEXT. ***/

                 ASSIGN d-sdo = d-sdo + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim
                        d-db  = d-db  + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_db
                        d-cr  = d-cr  + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_cr.

                 IF LAST-OF(tta_cod_estab) 
                 THEN DO:
                      OUTPUT TO c:\temp\demonst.csv CONVERT TARGET "iso8859-1" APPEND.
                      PUT UNFORMATTED tt_ctas.tta_des_grp_cta_ctbl ";" c_titulo ";" ITEM_demonst_ctbl.des_tit_ctbl ";" tt_retorna_sdo_ctbl.tta_cod_estab ";" tt_ctas.tta_cod_cta_ctbl ";" "02/2016;" d-sdo - (d-db - d-cr) ";" d-db - d-cr ";" d-sdo SKIP.
                      OUTPUT CLOSE.
                      ASSIGN d-sdo = 0
                             d-db  = 0
                             d-cr  = 0.
                 END.


             END.

         END.
         ASSIGN l_titulo = NO.
    END.

END.

OUTPUT CLOSE.

MESSAGE 
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

PROCEDURE pi_procura:
    
    DEF INPUT PARAM p_cta AS CHAR.

    FOR EACH estrut_cta_ctbl NO-LOCK
         WHERE estrut_cta_ctbl.cod_plano_cta_ctbl = 'padrao'
           AND estrut_cta_ctbl.cod_cta_ctbl_pai   = p_cta:

         IF estrut_cta_ctbl.cod_cta_ctbl_filho < c-cta 
            THEN NEXT.

         FIND bcta_ctbl NO-LOCK
            WHERE bcta_ctbl.cod_plano_cta = 'padrao'
              AND bcta_ctbl.cod_cta_ctbl  = estrut_cta_ctbl.cod_cta_ctbl_filho.
         IF bcta_ctbl.ind_espec_cta_ctbl = "Sintetica" 
            THEN RUN pi_procura (INPUT estrut_cta_ctbl.cod_cta_ctbl_filho).

         ASSIGN c-cta = bcta_ctbl.cod_cta_ctbl.
         
    END.

END.

*/

