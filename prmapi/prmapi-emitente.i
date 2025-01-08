DEFINE TEMP-TABLE tt-versao-integr NO-UNDO
    FIELD cod-versao-integracao AS INTEGER FORMAT "999"
    FIELD ind-origem-msg        AS INTEGER FORMAT "99".
             
DEFINE TEMP-TABLE tt-erros-geral NO-UNDO
    FIELD identif-msg        AS CHAR    FORMAT "x(60)"
    FIELD num-sequencia-erro AS INTEGER FORMAT "999"
    FIELD cod-erro           AS INTEGER FORMAT "99999"   
    FIELD des-erro           AS CHAR    FORMAT "x(60)"
    FIELD cod-maq-origem     AS INTEGER FORMAT "999"
    FIELD num-processo       AS INTEGER FORMAT "999999999".

DEFINE TEMP-TABLE tt-emitente NO-UNDO LIKE emitente
    FIELD cod-maq-origem AS INT  FORMAT "9999"
    FIELD num-processo   AS INT  FORMAT ">>>>>>>>9" INIT 0
    FIELD num-sequencia  AS INT  FORMAT ">>>>>9"    INIT 0
    FIELD ind-tipo-movto AS INT  FORMAT "99"        INIT 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.

DEFINE TEMP-TABLE tt-retorno NO-UNDO 
    FIELD cgc     LIKE emitente.cgc
    FIELD cd-erro AS INTEGER
    FIELD msg     AS CHAR COLUMN-LABEL "MSG" FORMAT "x(170)".

DEFINE TEMP-TABLE tt-achar-erros NO-UNDO 
    FIELD cgc     LIKE emitente.cgc
    FIELD cd-erro AS INTEGER
    FIELD msg     AS CHAR COLUMN-LABEL "MSG" FORMAT "x(170)".

DEFINE TEMP-TABLE tt-loc-entr 
    FIELD nome-abrev       AS CHAR                                                                
    FIELD cod-entrega      AS CHAR 
    FIELD endereco         AS CHAR 
    FIELD bairro           AS CHAR 
    FIELD cidade           AS CHAR 
    FIELD estado           AS CHAR 
    FIELD cep              AS CHAR 
    FIELD caixa-postal     AS CHAR 
    FIELD pais             AS CHAR 
    FIELD cgc              AS CHAR 
    FIELD ins-estadual     AS CHAR 
    FIELD obs-entrega      AS CHAR 
    FIELD cod-tip-ent      AS INTEGER 
    FIELD zip-code         AS CHAR 
    FIELD e-mail           AS CHAR 
    FIELD cod-tax          AS INTEGER 
    FIELD char-1           AS CHAR 
    FIELD char-2           AS CHAR 
    FIELD dec-1            AS DECIMAL 
    FIELD dec-2            AS DECIMAL 
    FIELD int-1            AS INTEGER 
    FIELD int-2            AS INTEGER 
    FIELD log-1            AS LOGICAL 
    FIELD log-2            AS LOGICAL 
    FIELD data-1           AS DATE 
    FIELD data-2           AS DATE 
    FIELD cod-emite-entr   AS INTEGER 
    FIELD check-sum        AS CHAR 
    FIELD endereco_text    AS CHAR
    FIELD cd-jurisdicao    AS CHAR
    FIELD nome-transp      AS CHAR
    FIELD cod-rota         AS CHAR
    FIELD nom-cidad-cif    AS CHAR
    FIELD cdn-ext          AS INTEGER
    FIELD nom-razao-social AS CHAR
    FIELD cod-telefone     AS CHAR
    FIELD cod-maq-origem   AS INTEGER 
    FIELD num-processo     AS INTEGER 
    FIELD num-sequencia    AS INTEGER 
    FIELD ind-tipo-movto   AS INTEGER
    INDEX ch-codigo IS PRIMARY cod-maq-origem
                               num-processo
                               num-sequencia.

DEFINE TEMP-TABLE tt-dist-emitente LIKE dist-emitente
    FIELD cod-maq-origem AS INTEGER FORMAT "9999"
    FIELD num-processo   AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0
    FIELD num-sequencia  AS INTEGER FORMAT ">>>>>9"    INITIAL 0
    FIELD ind-tipo-movto AS INTEGER FORMAT "99"        INITIAL 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.

DEFINE TEMP-TABLE tt-int-emitente
    FIELD nome-emit         LIKE emitente.nome-emit
    FIELD cgc               LIKE emitente.cgc
    FIELD cgc-cob           LIKE emitente.cgc-cob
    FIELD ins-estadual      LIKE emitente.ins-estadual
    FIELD ins-est-cob       LIKE emitente.ins-est-cob
    FIELD ins-municipal     LIKE emitente.ins-municipal
    FIELD cep               LIKE emitente.cep
    FIELD cep-cob           LIKE emitente.cep-cob
    FIELD endereco          LIKE emitente.endereco
    FIELD endereco-cob      LIKE emitente.endereco-cob
    FIELD bairro            LIKE emitente.bairro
    FIELD bairro-cob        LIKE emitente.bairro-cob
    FIELD cidade            LIKE emitente.cidade
    FIELD cidade-cob        LIKE emitente.cidade-cob
    FIELD estado            LIKE emitente.estado
    FIELD estado-cob        LIKE emitente.estado-cob
    FIELD pais              LIKE emitente.pais
    FIELD pais-cob          LIKE emitente.pais-cob
    FIELD telefone_1        AS CHAR FORMAT 'x(15)'
    FIELD telefone_2        AS CHAR FORMAT 'x(15)'
    FIELD ramal_1           AS CHAR FORMAT 'x(15)'
    FIELD ramal_2           AS CHAR FORMAT 'x(15)'
    FIELD telefax           AS CHAR FORMAT 'x(15)'
    FIELD ramal-fax         LIKE emitente.ramal-fax
    FIELD caixa-postal      LIKE emitente.caixa-postal
    FIELD cx-post-cob       LIKE emitente.cx-post-cob
    FIELD cod-gr-cli        LIKE emitente.cod-gr-cli
    FIELD lim-credito       LIKE emitente.lim-credito
    FIELD dt-lim-cred       LIKE emitente.dt-lim-cred
    FIELD portador          LIKE emitente.portador    
    FIELD modalidade        LIKE emitente.modalidade
    FIELD cod-suframa       LIKE emitente.cod-suframa
    FIELD atividade         LIKE emitente.atividade
    FIELD log_bloqueado     AS LOG FORMAT "Sim/NÆo"         INIT NO
    FIELD natureza_legado   AS INT FORMAT  "->,>>>,>>9"
    FIELD tipo_bloqueio     AS INT FORMAT  "9"
    FIELD cod_AR            AS INT FORMAT  "9"
    FIELD tipo_clientes     AS INT FORMAT  ">9"
    FIELD e-mail            LIKE emitente.e-mail
    FIELD nat-juridica      AS CHAR FORMAT "x(50)"          INIT ""
    FIELD agente-retencao   LIKE emitente.agente-retencao
    FIELD optante-simples   AS LOG INIT FALSE
    FIELD retem-issqn       AS LOG INIT FALSE
    .

/*[INICIO]defini‡Æo de tabelas temporarias necessaria para a api de intefra‡Æo de representantes cdapi016b*/
def temp-table tt_representante_integr_new2 no-undo 
    field cod_versao_integracao        as integer   format "999" 
    field cod_representante            as integer   format ">>>>>9" 
    field nome_abrev                   as character format "x(12)" 
    field nome                         as character format "x(40)" 
    field natureza                     as integer   format ">9" 
    field cgc                          as character format "x(19)" 
    field ins_estadual                 as character format "x(19)" 
    field ins_municipal                as character format "x(19)"  
    field estado                       as character format "x(04)" 
    field endereco                     as character format "x(40)" 
    field endereco2                    as character format "x(40)" 
    field bairro                       as character format "x(30)" 
    field cep                          as character format "x(12)" 
    field cod_pais                     as character format "x(20)" 
    field nome_mic_reg                 as character format "x(12)" 
    field nom_cidade                   as character format "x(25)" 
    field caixa_postal                 as character format "x(10)" 
    field telefax                      as character format "x(15)" 
    field ramal_fax                    as character format "x(05)" 
    field telex                        as character format "x(15)" 
    field telefone                     as character format "x(15)" extent 2 
    field ramal                        as character format "x(05)" extent 2 
    field telef_modem                  as character format "x(15)" 
    field ramal_modem                  as character format "x(05)" 
    field zip_code                     as character format "x(12)" 
    field e_mail                       as character format "x(40)" 
    field perc_comis                   as decimal   format ">>9.99"
    field perc_comis_emis              as decimal   format ">>9.99"
    field perc_comis_indireto          as decimal   format ">>9.99"
    field val_perc_max_comis           as decimal   format ">>9.99"
    field cod_repres_indireto          as integer   format ">>>>9"
    field num_tip_operac               as integer   format "9" 
    field perc_abatimento              as decimal   format ">>9.99" 
    field perc_desconto                as decimal   format ">>9.99" 
    field perc_juros                   as decimal   format ">>9.99" 
    field perc_multa                   as decimal   format ">>9.99"
    field perc_AVA                     as decimal   format ">>9.99"  
    field bloqueado_pagto              as logical   format "Sim/N’o"
    field cod_portador_geracao_ad      as integer   format ">>>>9"
    field int-1                        as integer   format ">>>>>>>>>>9"
    field comis_min                    as decimal   format ">>9.99"
    field ender_text                   as character format "x(2000)"
    field dat_desligto                 as date      format "99/99/9999"
    field ind_sit_repres               as character format "x(10)"
    FIELD cod_id_munic_fisic   AS CHARACTER FORMAT "x(20)"
    FIELD cod_id_previd_social AS CHARACTER FORMAT "x(20)"
    FIELD dat_vencto_id_munic  AS DATE      FORMAT "99/99/9999"

    index codigo                       is primary unique  
          cod_representante            ascending
   . 

def temp-table tt_retorno_clien_fornec_new2 no-undo 
    field ttv_cod_parameters               as character format "x(256)" 
    field ttv_num_mensagem                 as integer format ">>>>,>>9"
    field ttv_des_mensagem                 as character format "x(52)" label "Mensagem" column-label "Mensagem" 
    field ttv_des_ajuda                    as character format "x(256)"
                                           view-as editor max-chars 2000 scrollbar-vertical size 40 by 4 
                                           label "Ajuda" column-label "Ajuda"
    field ttv_cod_parameters_clien         as character format "x(2000)" 
    field ttv_cod_parameters_fornec        as character format "x(2000)" 
    field ttv_log_envdo                    as logical format "Sim/Nao" initial no 
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
    field ttv_cod_parameters_histor_fornec as character format "x(4000)"
    . 
/*[FIM]-defini‡Æo de tabelas temporarias necessaria para a api de intefra‡Æo de representantes cdapi016b*/
