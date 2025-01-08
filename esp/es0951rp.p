/*{include/i-prgvrs.i es0951 2.04.00.000}*/
/***********************************************************************
**  Programa..: ESP/ES0951RP.P
**  Autor.....: Raphael Matei Paini
**  Data......: MAIO/2009 - Desenvolvimento
**  Descricao.: Inconsitàncias C.Custo e Transit¢rias
**  Vers∆o....: 001 07/05/2009
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp/es0951tt.i}
{utp/utapi009.i}
/****************************  Temp-Tables  ****************************/

DEF TEMP-TABLE tt-dados NO-UNDO
    FIELD cod_estab             AS CHAR
    FIELD origem                AS CHAR FORMAT "x(3)"   /**** APB, ACR, FGL, CMG, APL, FAS ou CEP ***/
    FIELD ind_natur_lancto_ctbl AS CHAR FORMAT "X(3)"   /**** DB ou CR ***/
    FIELD cod_emitente          AS INT  FORMAT ">>>,>>>,>>9"
    FIELD nome_emitente         AS CHAR FORMAT "X(40)"
    FIELD dt_transacao          AS DATE FORMAT "99/99/9999"
    FIELD cod_espec_docto       AS CHAR FORMAT "x(3)"
    FIELD cod_ser_docto         AS CHAR FORMAT "x(3)"
    FIELD cod_tit_ap            AS CHAR FORMAT "x(10)"
    FIELD cod_parcela           AS CHAR FORMAT "x(2)"
    FIELD val_aprop_ctbl        AS DEC  FORMAT "->>>,>>>,>>9.99"
    FIELD cod_cta_ctbl          AS CHAR
    FIELD cod_ccusto            AS CHAR
    FIELD cod_unid_negoc        AS CHAR
    FIELD des_lancto            AS CHAR
    FIELD erro                  AS CHARACTER FORMAT "x(200)"
    FIELD cod_usuar_ult_atualiz AS CHAR FORMAT "x(12)"
    FIELD ind_trans             AS CHAR.

DEF TEMP-TABLE tt-dados2 NO-UNDO
    FIELD codigo                AS INTEGER
    FIELD cod_estab             AS CHAR
    FIELD origem                AS CHAR FORMAT "x(3)"   /**** APB, ACR, FGL, CMG, APL, FAS ou CEP ***/
    FIELD ind_natur_lancto_ctbl AS CHAR FORMAT "X(3)"   /**** DB ou CR ***/
    FIELD cod_emitente          AS INT  FORMAT ">>>,>>>,>>9"
    FIELD nome_emitente         AS CHAR FORMAT "X(40)"
    FIELD dt_transacao          AS DATE FORMAT "99/99/9999"
    FIELD cod_espec_docto       AS CHAR FORMAT "x(3)"
    FIELD cod_ser_docto         AS CHAR FORMAT "x(3)"
    FIELD cod_tit_ap            AS CHAR FORMAT "x(10)"
    FIELD cod_parcela           AS CHAR FORMAT "x(2)"
    FIELD val_aprop_ctbl        AS DEC  FORMAT "->>>,>>>,>>9.99"
    FIELD cod_cta_ctbl          AS CHAR
    FIELD cod_ccusto            AS CHAR
    FIELD cod_unid_negoc        AS CHAR
    FIELD des_lancto            AS CHAR
    FIELD serie-fat             AS CHAR
    FIELD cgc-transp            AS CHAR
    FIELD nr-fatura             AS CHAR
    FIELD natureza              AS CHARACTER
    FIELD erro                  AS CHARACTER FORMAT "x(200)"
    FIELD cod_usuar_ult_atualiz AS CHAR FORMAT "x(12)"
    FIELD ind_trans             AS CHAR
    INDEX conta cod_cta_ctbl
    INDEX codigo codigo
    INDEX leitura cod_cta_ctbl cod_tit_ap
    INDEX leitura2 cod_cta_ctbl nome_emitente
    INDEX leitura3 ind_natur_lancto_ctbl
    INDEX leitura4 codigo cod_estab cod_cta_ctbl ind_natur_lancto_ctbl cod_tit_ap
    INDEX fatura1 serie-fat cgc-transp nr-fatura
    INDEX fatura2 nr-fatura.

DEFINE TEMP-TABLE tt-total NO-UNDO
    FIELD codigo                AS INTEGER
    FIELD cod_estab             AS CHAR
    FIELD cod_cta_ctbl          AS CHAR
    FIELD ident                 AS INTEGER
    FIELD origem                AS CHAR FORMAT "x(3)"   /**** APB, ACR, FGL, CMG, APL, FAS ou CEP ***/
    FIELD cod_tit_ap            AS CHAR
    FIELD val_aprop_ctbl        AS DEC  FORMAT "->>>,>>>,>>9.99"
    FIELD desc-conta            AS CHARACTER FORMAT "x(60)"
    INDEX chave codigo cod_cta_ctbl cod_tit_ap ident origem
    INDEX chave2 codigo cod_cta_ctbl origem
    INDEX chave3 codigo cod_cta_ctbl cod_tit_ap origem
    INDEX chave4 origem val_aprop_ctbl.

def temp-table tt_diar_aux_pat no-undo like bem_pat
    field tta_dat_movto_bem_pat            as date format "99/99/9999" initial today label "Data Movimento" column-label "Data Movimento"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_des_tit_ctbl                 as character format "x(40)" label "T°tulo Cont†bil" column-label "T°tulo Cont†bil"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field ttv_des_narrat_bem_pat_tmp       as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field ttv_des_historico                as character format "x(150)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_num_bem_pat                  as integer format ">>>>>>>>9" initial 0 label "Bem Patrimonial" column-label "Bem"
    field tta_num_seq_bem_pat              as integer format ">>>>9" initial 0 label "Sequància Bem" column-label "Sequància"
    field tta_dat_aquis_bem_pat            as date format "99/99/9999" initial today label "Data Aquisiá∆o" column-label "Dat Aquis"
    field ttv_dat_baixa                    as date format "99/99/9999" label "Data de Baixa" column-label "Data da Baixa"
    field tta_val_lancto_ctbl_cr           as decimal format ">>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor CrÇditos" column-label "Valor CrÇditos"
    field tta_val_lancto_ctbl_db           as decimal format ">>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor DÇbitos" column-label "Valor DÇbitos"
    field tta_num_id_bem_pat               as integer format ">>,>>>,>>9" initial 0 label "Identificaá∆o Bem" column-label "Identificaá∆o Bem"
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    index tt_diar_aux_pat                  is primary
          tta_dat_movto_bem_pat            ascending
          tta_cod_cta_ctbl                 ascending
          tta_num_bem_pat                  ascending
          tta_num_seq_bem_pat              ascending
    index tt_num_id                       
          tta_num_id_bem_pat               ascending
    .

DEF TEMP-TABLE tt-rec   NO-UNDO
    FIELD cod-estabel  LIKE docum-est.cod-estabel
    FIELD serie-docto  LIKE docum-est.serie-docto
    FIELD nro-docto    LIKE docum-est.nro-docto
    FIELD cod-emitente LIKE docum-est.cod-emitente
    FIELD nat-operacao LIKE docum-est.nat-operacao
    FIELD serie-nfe    LIKE docum-est.serie-docto
    FIELD docto-nfe    LIKE docum-est.nro-docto
    FIELD it-codigo    LIKE ITEM.it-codigo
    FIELD valor        AS   DECIMAL
    FIELD usuario      AS   CHAR
    FIELD data         AS   DATE.

DEF TEMP-TABLE tt-acr   NO-UNDO
    FIELD cod-estabel  LIKE docum-est.cod-estabel
    FIELD serie-docto  LIKE docum-est.serie-docto
    FIELD nro-docto    LIKE docum-est.nro-docto
    FIELD cod-emitente LIKE docum-est.cod-emitente
    FIELD nat-operacao LIKE docum-est.nat-operacao
    FIELD valor        AS   DECIMAL
    FIELD usuario      AS   CHAR
    FIELD data         AS   DATE
    INDEX acr cod-estabel serie-docto nro-docto cod-emitente.

DEF TEMP-TABLE tt-rec-sacr   NO-UNDO
    FIELD cod-estabel  LIKE docum-est.cod-estabel
    FIELD serie-docto  LIKE docum-est.serie-docto
    FIELD nro-docto    LIKE docum-est.nro-docto
    FIELD cod-emitente LIKE docum-est.cod-emitente
    FIELD nat-operacao LIKE docum-est.nat-operacao
    FIELD serie-nfe    LIKE docum-est.serie-docto
    FIELD docto-nfe    LIKE docum-est.nro-docto
    FIELD it-codigo    LIKE ITEM.it-codigo
    FIELD valor        AS   DECIMAL
    FIELD usuario      AS   CHAR
    FIELD data         AS   DATE
    FIELD desc-item    LIKE ITEM.desc-item
    FIELD fm-codigo    LIKE ITEM.fm-codigo
    FIELD ipi          LIKE item-doc-est.valor-ipi[1]
    FIELD icm          LIKE item-doc-est.valor-icm[1]
    FIELD base-subs    LIKE item-doc-est.base-subs[1]
    FIELD vl-subs      LIKE item-doc-est.vl-subs[1]
    FIELD vl-despesas  AS   DECIMAL
    FIELD vl-merc      AS   DECIMAL
    FIELD vl-total     AS   DECIMAL.

def new global shared var i-ep-codigo-usuario  like mgcad.empresa.ep-codigo no-undo.

DEFINE VARIABLE h-cd9500 AS HANDLE      NO-UNDO.
DEFINE VARIABLE r-conta-ft AS ROWID       NO-UNDO.


DEFINE VARIABLE i-erro       AS INTEGER     NO-UNDO.

DEF VAR h-acomp      as handle no-undo.

DEFINE VARIABLE v_des_cta_ctbl     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_des_ccusto       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_des_unid_negoc   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_nom_usuar        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-achou            AS LOGICAL     NO-UNDO.

DEFINE VARIABLE l-cria-dados2 AS LOGICAL  INITIAL YES NO-UNDO.
DEFINE VARIABLE l-elimina     AS LOGICAL  INITIAL YES NO-UNDO.

/****************************  Frames       ****************************/
DEF INPUT PARAMETER raw-param as raw no-undo.
DEF INPUT PARAMETER table for tt-raw-digita.

DEFINE BUFFER b-tt-total FOR tt-total.
DEFINE BUFFER b-tt-dados2 FOR tt-dados2.
DEFINE BUFFER b-emitente FOR emitente.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

IF tt-param.mensal THEN DO:
    ASSIGN tt-param.data-ini = DATE(MONTH(TODAY),01,YEAR(TODAY)).

    IF MONTH(TODAY) = 12 THEN
        ASSIGN tt-param.data-fim = DATE(12,31,YEAR(TODAY)).
    ELSE
        ASSIGN tt-param.data-fim = DATE(MONTH(TODAY) + 1,01,YEAR(TODAY)) - 1.
END.
    
for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

FIND FIRST param-global NO-LOCK.
FOR FIRST mgcad.empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    
    RUN pi-inicializar in h-acomp (input "Carregando Informaá‰es...").



    IF tt-param.destino = 3 THEN /* Terminal */   
        ASSIGN tt-param.arquivo = IF SEARCH(tt-param.arquivo) <> ? THEN tt-param.arquivo ELSE SESSION:TEMP-DIRECTORY + "ES0951.txt".

    IF tt-param.execucao = 2 THEN /* batch */   
        ASSIGN tt-param.arquivo = IF SEARCH(tt-param.arquivo) <> ? THEN tt-param.arquivo ELSE SESSION:TEMP-DIRECTORY + tt-param.arquivo.



    OUTPUT TO VALUE(tt-param.arquivo) NO-CONVERT.

    for each tt-dados:
        delete tt-dados.
    end.

    for each tt-dados2:
        delete tt-dados2.
    end.

    FOR EACH tt-total:
        DELETE tt-total.
    END.

    FOR EACH tt_diar_aux_pat:
        DELETE tt_diar_aux_pat.
    END.

    IF tt-param.valida-cc THEN
        RUN pi_rpt_motiv_movto_tit_acr_dem.

    IF tt-param.concil-transit THEN
        RUN pi_conciliacao.

    RUN pi_concil_cmg.

    IF tt-param.devol THEN
       RUN pi_devolucoes.

    OUTPUT CLOSE.

    IF tt-param.envia-email THEN
        RUN pi-envia-email IN THIS-PROCEDURE.

    RUN pi-finalizar in h-acomp.

    RETURN "OK".
END.

PROCEDURE pi_rpt_motiv_movto_tit_acr_dem:
/*****************************************************************************
** Procedure Interna.....: pi_rpt_motiv_movto_tit_acr_dem
** Descricao.............: pi_rpt_motiv_movto_tit_acr_dem
** Criado por............: borba
** Criado em.............: 07/05/1997 09:17:55
** Alterado por..........: Claudia
** Alterado em...........: 13/08/1997 17:17:33
*****************************************************************************/

    FOR EACH cta_ctbl NO-LOCK
       WHERE cta_ctbl.cod_plano_cta_ctbl  = "PADRAO"
         /*AND cta_ctbl.cod_cta_ctbl       >= v_cod_cta_ctbl_ini
         AND cta_ctbl.cod_cta_ctbl       <= v_cod_cta_ctbl_fim*/ :
    
       IF cta_ctbl.cod_cta_ctbl < "40000000" OR cta_ctbl.cod_cta_ctbl > "41999999"
          THEN NEXT.
    
       RUN pi-inicializar in h-acomp (input "Validando CC Conta: " + cta_ctbl.cod_cta_ctbl).
       RUN pi_leitura_lancto (INPUT cta_ctbl.cod_cta_ctbl).
    END.
    
    RUN pi-inicializar in h-acomp (input "Gerando Relat¢rio...").

    IF CAN-FIND(FIRST tt-dados) THEN DO:
        PUT UNFORMATTED "Erros Encontrados Validando Centro de Custo" SKIP(1).

        PUT UNFORMATTED "Estab;Origem;DB/CR;Emitente;Nome;Data;Especie;Serie;Titulo;Parcela;Valor;Conta;Descricao;CCusto;Descricao;UN;Descricao;Historico;Erro;Usu†rio;Nome;" SKIP.

        FOR EACH tt-dados:

            ASSIGN tt-dados.des_lancto = REPLACE(tt-dados.des_lancto,CHR(13)," ").
            ASSIGN tt-dados.des_lancto = REPLACE(tt-dados.des_lancto,CHR(10)," ").
            ASSIGN tt-dados.des_lancto = REPLACE(tt-dados.des_lancto,";"," ").

            find cta_ctbl no-lock
                where cta_ctbl.cod_plano_cta_ctbl = "PADRAO"
                  and cta_ctbl.cod_cta_ctbl       = tt-dados.cod_cta_ctbl no-error.
            if avail cta_ctbl
               then assign v_des_cta_ctbl = cta_ctbl.des_tit_ctbl.
               else assign v_des_cta_ctbl = "Nao Localizada".

            find emscad.ccusto no-lock
                where emscad.ccusto.cod_empresa      = "1"
                  AND emscad.ccusto.cod_plano_ccusto = "PADRAO"
                  and emscad.ccusto.cod_ccusto       = tt-dados.cod_ccusto no-error.
            if avail emscad.ccusto
               then assign v_des_ccusto = emscad.ccusto.des_tit_ctbl.
               else assign v_des_ccusto = "Nao Localizada".

            find unid_negoc no-lock
                where unid_negoc.cod_unid_negoc = tt-dados.cod_unid_negoc no-error.
            if avail unid_negoc
               then assign v_des_unid_negoc = unid_negoc.des_unid_negoc.
               else assign v_des_unid_negoc = "Nao Localizada".

            FIND FIRST usuar_mestre NO-LOCK
                WHERE  usuar_mestre.cod_usuar = tt-dados.cod_usuar_ult_atualiz NO-ERROR.
            ASSIGN v_nom_usuar = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuar ELSE "".

            PUT UNFORMATTED tt-dados.cod_estab               + ";" +
                            tt-dados.origem                  + ";" +
                            tt-dados.ind_natur_lancto_ctbl   + ";" +
                            STRING(tt-dados.cod_emitente)    + ";" +
                            tt-dados.nome_emitente           + ";" +
                            STRING(tt-dados.dt_transacao)    + ";" +
                            tt-dados.cod_espec_docto         + ";" +
                            tt-dados.cod_ser_docto           + ";" +
                            tt-dados.cod_tit_ap              + ";" +
                            tt-dados.cod_parcela             + ";" +
                            STRING(tt-dados.val_aprop_ctbl)  + ";" +
                            tt-dados.cod_cta_ctbl            + ";" +
                            v_des_cta_ctbl                   + ";" +
                            tt-dados.cod_ccusto              + ";" +
                            v_des_ccusto                     + ";" +
                            tt-dados.cod_unid_negoc          + ";" +
                            v_des_unid_negoc                 + ";" +
                            tt-dados.des_lancto              + ";" +
                            tt-dados.erro                    + ";" +
                            tt-dados.cod_usuar_ult_atualiz   + ";" +
                            v_nom_usuar                      SKIP.

        END.
        PUT UNFORMATTED SKIP(3).
    END.
END PROCEDURE.

PROCEDURE pi_conciliacao:
/*****************************************************************************
** Procedure Interna.....: pi_conciliacao
** Descricao.............: pi_conciliacao
** Criado por............: Raphael Paini
** Criado em.............: 14/05/2009 09:17:55
*****************************************************************************/
    DEFINE VARIABLE de-total AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-difer AS DECIMAL     NO-UNDO.

    FOR EACH conciliacao NO-LOCK
       WHERE conciliacao.situacao
         AND conciliacao.codigo >= tt-param.i-concil-ini
         AND conciliacao.codigo <= tt-param.i-concil-fim,
        EACH conciliacao-contas OF conciliacao NO-LOCK,
       FIRST cta_ctbl NO-LOCK
       WHERE cta_ctbl.cod_plano_cta_ctbl  = "PADRAO"
         AND cta_ctbl.cod_cta_ctbl = conciliacao-contas.ct-codigo:

        RUN pi-inicializar in h-acomp (input "Validando Transit¢ria: " + cta_ctbl.cod_cta_ctbl).

        RUN pi_leitura_lancto2 (INPUT cta_ctbl.cod_cta_ctbl).
    END.
        
    /*
        FOR EACH tt-dados2 NO-LOCK 
           WHERE tt-dados2.nr-fatura <> "" BREAK BY tt-dados2.nr-fatura:

            IF FIRST-OF(tt-dados2.nr-fatura) THEN DO:
                FOR EACH fatura-docto-frete NO-LOCK
                   WHERE fatura-docto-frete.serie-fat         = tt-dados2.serie-fat
                     AND fatura-docto-frete.cgc-transp        = tt-dados2.cgc-transp
                     AND fatura-docto-frete.nr-fatura         = tt-dados2.nr-fatura
                     AND fatura-docto-frete.dt-emissao-docto <= tt-param.data-ini:

                    CREATE b-tt-dados2.
                    BUFFER-COPY tt-dados2 TO  b-tt-dados2.
                    ASSIGN b-tt-dados2.cod_tit_ap     = fatura-docto-frete.nr-fatura
                           b-tt-dados2.cod_ser_docto  = fatura-docto-frete.serie
                           b-tt-dados2.cod_parcela    = fatura-docto-frete.nr-documento
                           b-tt-dados2.nr-fatura      = fatura-docto-frete.nr-fatura.

                    RUN pi-totaliza-contas.
                END.
            END.
        END.*/
    

    RUN pi-inicializar in h-acomp (input "Gerando Relat¢rio...").

    /*FOR EACH conciliacao NO-LOCK
       WHERE conciliacao.situacao:
        FIND FIRST tt-dados2 NO-LOCK
             WHERE tt-dados2.codigo = conciliacao.codigo NO-ERROR.
        IF AVAIL tt-dados2 THEN DO:
            ASSIGN de-total = 0.
            FOR EACH conciliacao-contas OF conciliacao NO-LOCK:
                FIND FIRST tt-total NO-LOCK
                     WHERE tt-total.codigo       = conciliacao-contas.codigo
                       AND tt-total.cod_cta_ctbl = conciliacao-contas.ct-codigo
                       AND tt-total.origem       = "TOT" NO-ERROR.
                IF AVAIL tt-total THEN DO:
                    /*IF conciliacao-contas.tipo = 0 THEN DO:
                        ASSIGN de-total = de-total + tt-total.val_aprop_ctbl.
                    END.
                    ELSE IF conciliacao-contas.tipo = 1 THEN DO:
                        /*Credito*/
                        ASSIGN de-total = de-total + (tt-total.val_aprop_ctbl * -1).

                    END.
                    ELSE IF conciliacao-contas.tipo = 2 THEN DO:
                        /*Debito*/
                        ASSIGN de-total = de-total + tt-total.val_aprop_ctbl.
                    END.*/

                    ASSIGN de-total = de-total + tt-total.val_aprop_ctbl.
                END.
            END.
            IF de-total = 0 THEN DO:
                FOR EACH tt-dados2 WHERE tt-dados2.codigo = conciliacao.codigo:
                    DELETE tt-dados2.
                END.
            END.
        END.
    END.*/

    IF l-elimina THEN DO:
        run pi-acompanhar in h-acomp (INPUT "Eliminando Totais").
        FOR EACH tt-total 
           WHERE tt-total.origem = "TOT" AND tt-total.val_aprop_ctbl = 0:
    
            FOR EACH tt-dados2 
               WHERE tt-dados2.cod_cta_ctbl = tt-total.cod_cta_ctbl:
                DELETE tt-dados2.
            END.
    
            FOR EACH b-tt-total
               WHERE b-tt-total.codigo       = tt-total.codigo      
                 AND b-tt-total.cod_cta_ctbl = tt-total.cod_cta_ctbl
                 AND b-tt-total.origem      <> "TOT":
                DELETE b-tt-total.
            END.
        END.
    
        run pi-acompanhar in h-acomp (INPUT "Eliminando Diferenáas").
        FOR EACH tt-total 
           WHERE tt-total.origem = "DIF" AND tt-total.val_aprop_ctbl = 0:
    
            IF tt-total.cod_cta_ctbl = "11910100" THEN DO:
                FOR EACH tt-dados2 
                   WHERE tt-dados2.cod_cta_ctbl  = tt-total.cod_cta_ctbl
                     AND tt-dados2.nome_emitente = tt-total.cod_tit_ap:
                    DELETE tt-dados2.
                END.
            END.
            ELSE DO:
                FOR EACH tt-dados2 
                   WHERE tt-dados2.cod_cta_ctbl = tt-total.cod_cta_ctbl
                     AND tt-dados2.cod_tit_ap   = tt-total.cod_tit_ap:
                    DELETE tt-dados2.
                END.
            END.
    
            FOR EACH b-tt-total
               WHERE b-tt-total.codigo       = tt-total.codigo      
                 AND b-tt-total.cod_cta_ctbl = tt-total.cod_cta_ctbl
                 AND b-tt-total.cod_tit_ap   = tt-total.cod_tit_ap
                 AND b-tt-total.origem      <> "TOT":
    
                DELETE b-tt-total.
            END.
        END.
    
        FOR EACH tt-total 
           WHERE tt-total.origem = "DIF":
            DELETE tt-total.
        END.
    
        FOR EACH tt-dados2 WHERE tt-dados2.ind_natur_lancto_ctbl = "CR":
            FIND FIRST b-tt-dados2 NO-LOCK
                 WHERE b-tt-dados2.codigo                = tt-dados2.codigo      
                   AND b-tt-dados2.cod_estab             = tt-dados2.cod_estab   
                   AND b-tt-dados2.origem                = tt-dados2.origem      
                   AND b-tt-dados2.cod_cta_ctbl          = tt-dados2.cod_cta_ctbl
                   AND b-tt-dados2.cod_emitente          = tt-dados2.cod_emitente
                   AND b-tt-dados2.ind_natur_lancto_ctbl = "DB"
                   AND b-tt-dados2.cod_espec_docto       = tt-dados2.cod_espec_docto 
                   AND b-tt-dados2.cod_ser_docto         = tt-dados2.cod_ser_docto   
                   AND b-tt-dados2.cod_tit_ap            = tt-dados2.cod_tit_ap      
                   AND b-tt-dados2.cod_parcela           = tt-dados2.cod_parcela
                   AND b-tt-dados2.val_aprop_ctbl        = tt-dados2.val_aprop_ctbl  * -1 NO-ERROR.
            IF AVAIL b-tt-dados2 THEN DO:
                DELETE b-tt-dados2.
                DELETE tt-dados2.
            END.
        END.
        
        /*FOR EACH tt-dados2 
           WHERE tt-dados2.ind_natur_lancto_ctbl = "CR"
             AND tt-dados2.codigo = 10:
    
            ASSIGN de-difer = tt-dados2.val_aprop_ctbl.
            FOR EACH b-tt-dados2 NO-LOCK
               WHERE b-tt-dados2.codigo                = tt-dados2.codigo      
                 AND b-tt-dados2.cod_estab             = tt-dados2.cod_estab   
                 AND b-tt-dados2.cod_cta_ctbl          = tt-dados2.cod_cta_ctbl
                 AND b-tt-dados2.ind_natur_lancto_ctbl = "DB"
                 AND b-tt-dados2.cod_tit_ap            = tt-dados2.cod_tit_ap:
                ASSIGN de-difer = de-difer - b-tt-dados2.val_aprop_ctbl.
            END.
    
            IF de-difer = 0 THEN DO:
                FOR EACH b-tt-dados2 NO-LOCK
                   WHERE b-tt-dados2.codigo                = tt-dados2.codigo      
                     AND b-tt-dados2.cod_estab             = tt-dados2.cod_estab   
                     AND b-tt-dados2.cod_cta_ctbl          = tt-dados2.cod_cta_ctbl
                     AND b-tt-dados2.ind_natur_lancto_ctbl = "DB"
                     AND b-tt-dados2.cod_tit_ap            = tt-dados2.cod_tit_ap:
                    DELETE b-tt-dados2.    
                END.
                DELETE tt-dados2.
            END.
        END.
    
        FOR EACH tt-dados2 
           WHERE tt-dados2.ind_natur_lancto_ctbl = "DB"
             AND tt-dados2.codigo = 10:
    
            ASSIGN de-difer = tt-dados2.val_aprop_ctbl.
            FOR EACH b-tt-dados2 NO-LOCK
               WHERE b-tt-dados2.codigo                = tt-dados2.codigo      
                 AND b-tt-dados2.cod_estab             = tt-dados2.cod_estab   
                 AND b-tt-dados2.cod_cta_ctbl          = tt-dados2.cod_cta_ctbl
                 AND b-tt-dados2.ind_natur_lancto_ctbl = "CR"
                 AND b-tt-dados2.cod_tit_ap            = tt-dados2.cod_tit_ap:
                ASSIGN de-difer = de-difer + b-tt-dados2.val_aprop_ctbl.
            END.
    
            IF de-difer = 0 THEN DO:
                FOR EACH b-tt-dados2 NO-LOCK
                   WHERE b-tt-dados2.codigo                = tt-dados2.codigo      
                     AND b-tt-dados2.cod_estab             = tt-dados2.cod_estab   
                     AND b-tt-dados2.cod_cta_ctbl          = tt-dados2.cod_cta_ctbl
                     AND b-tt-dados2.ind_natur_lancto_ctbl = "CR"
                     AND b-tt-dados2.cod_tit_ap            = tt-dados2.cod_tit_ap:
                    DELETE b-tt-dados2.    
                END.
                DELETE tt-dados2.
            END.
        END.    
    
        FOR EACH tt-dados2 
           WHERE tt-dados2.ind_natur_lancto_ctbl = "CR"
             AND tt-dados2.codigo = 10:
    
            FIND FIRST b-tt-dados2 NO-LOCK
                 WHERE b-tt-dados2.codigo                = tt-dados2.codigo      
                   AND b-tt-dados2.cod_estab             = tt-dados2.cod_estab   
                   AND b-tt-dados2.cod_cta_ctbl          = tt-dados2.cod_cta_ctbl
                   AND b-tt-dados2.cod_emitente          = tt-dados2.cod_emitente
                   AND b-tt-dados2.ind_natur_lancto_ctbl = "DB"
                   AND b-tt-dados2.cod_tit_ap            = tt-dados2.cod_tit_ap      
                   AND b-tt-dados2.val_aprop_ctbl        = tt-dados2.val_aprop_ctbl  * -1 NO-ERROR.
            IF AVAIL b-tt-dados2 THEN DO:
                DELETE b-tt-dados2.
                DELETE tt-dados2.
            END.
        END.*/
    END.


    run pi-acompanhar in h-acomp (INPUT "Gerando informaá‰es").
    
    IF CAN-FIND(FIRST tt-dados2) AND 
        tt-param.devol = NO THEN DO:
        PUT UNFORMATTED 
            "Erros Encontrados Conciliando Transit¢rias" SKIP(1)
            "Codigo;Estab;Origem;DB/CR;Emitente;Nome;Data;Natureza;Especie;Serie;Titulo;Parcela;Valor;Conta;Descricao;CCusto;Descricao;UN;Descricao;Erros;Historico;Usu†rio;Nome;" SKIP.

        FOR EACH tt-dados2:

            ASSIGN tt-dados2.des_lancto = REPLACE(tt-dados2.des_lancto,CHR(13)," ").
            ASSIGN tt-dados2.des_lancto = REPLACE(tt-dados2.des_lancto,CHR(10)," ").
            ASSIGN tt-dados2.des_lancto = REPLACE(tt-dados2.des_lancto,";"," ").

            find cta_ctbl no-lock
                where cta_ctbl.cod_plano_cta_ctbl = "PADRAO"
                  and cta_ctbl.cod_cta_ctbl       = tt-dados2.cod_cta_ctbl no-error.
            if avail cta_ctbl
               then assign v_des_cta_ctbl = cta_ctbl.des_tit_ctbl.
               else assign v_des_cta_ctbl = "Nao Localizada".

            find emscad.ccusto no-lock
                where emscad.ccusto.cod_empresa      = "1"
                  AND emscad.ccusto.cod_plano_ccusto = "PADRAO"
                  and emscad.ccusto.cod_ccusto       = tt-dados2.cod_ccusto no-error.
            if avail emscad.ccusto
               then assign v_des_ccusto = emscad.ccusto.des_tit_ctbl.
               else assign v_des_ccusto = "Nao Localizada".

            find unid_negoc no-lock
                where unid_negoc.cod_unid_negoc = tt-dados2.cod_unid_negoc no-error.
            if avail unid_negoc
               then assign v_des_unid_negoc = unid_negoc.des_unid_negoc.
               else assign v_des_unid_negoc = "Nao Localizada".

            FIND FIRST usuar_mestre NO-LOCK
                WHERE  usuar_mestre.cod_usuar = tt-dados2.cod_usuar_ult_atualiz NO-ERROR.
            ASSIGN v_nom_usuar = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuar ELSE "".

            PUT UNFORMATTED STRING(tt-dados2.codigo)         + ";" +
                            tt-dados2.cod_estab              + ";" +
                            tt-dados2.origem                 + ";" +
                            tt-dados2.ind_natur_lancto_ctbl  + ";" +
                            STRING(tt-dados2.cod_emitente)   + ";" +
                            tt-dados2.nome_emitente          + ";" +
                            STRING(tt-dados2.dt_transacao)   + ";" +
                            tt-dados2.natureza               + ";" +
                            tt-dados2.cod_espec_docto        + ";" +
                            tt-dados2.cod_ser_docto          + ";" +
                            tt-dados2.cod_tit_ap             + ";" +
                            tt-dados2.cod_parcela            + ";" +
                            STRING(tt-dados2.val_aprop_ctbl) + ";" +
                            tt-dados2.cod_cta_ctbl           + ";" +
                            v_des_cta_ctbl                   + ";" +
                            tt-dados2.cod_ccusto             + ";" +
                            v_des_ccusto                     + ";" +
                            tt-dados2.cod_unid_negoc         + ";" +
                            v_des_unid_negoc                 + ";" +
                            tt-dados2.erro                   + ";" +
                            tt-dados2.des_lancto             + ";" +
                            tt-dados2.cod_usuar_ult_atualiz   + ";" +
                            v_nom_usuar                      SKIP.

        END.

        PUT UNFORMATTED
            SKIP(3)
            "Agrupador de M¢dulos Transit¢rias" SKIP(1) 
            "Codigo;Conta;Descriá∆o;Documento;Origem;Valor" SKIP.
        FOR EACH tt-total BY tt-total.codigo BY tt-total.cod_cta_ctbl BY tt-total.ident BY tt-total.cod_tit_ap BY tt-total.origem :
            PUT UNFORMATTED
                tt-total.codigo        ";"
                tt-total.cod_cta_ctbl  ";"
                tt-total.desc-conta    ";"
                tt-total.cod_tit_ap    ";"
                tt-total.origem        ";"
                tt-total.val_aprop_ctbl SKIP.
        END.
        PUT UNFORMATTED SKIP(3).

    END.

END PROCEDURE.

PROCEDURE pi_leitura_lancto:
/*****************************************************************************
**  Procedure Interna: pi_leitura_lancto
**  Descricao........: Leitura Movimentaá‰es
*****************************************************************************/

   DEF INPUT PARAMETER p_cod_cta_ctbl AS CHAR FORMAT "x(8)" NO-UNDO.

   DEF VAR i-data             AS DATE.
   DEF VAR c-conta-contabil LIKE movto-estoq.ct-codigo.

   FOR EACH estabelecimento NO-LOCK
      WHERE estabelecimento.cod_empresa = "1":
       
       /*/* ** Limitaá∆o na localizaá∆o dos valores no EMS2, que est∆o em bases separadas por empresa ***/
       IF estabelecimento.cod_estab <> "101"
       AND estabelecimento.cod_estab <> "102" 
       AND estabelecimento.cod_estab <> "105" 
           THEN NEXT.*/

       run pi-acompanhar in h-acomp (INPUT "Movimentos Contabilidade - FGL").
       /* ** Movimentos Contabilidade - FGL ***/
       FOR EACH item_lancto_ctbl NO-LOCK
           WHERE item_lancto_ctbl.cod_empres       = estabelecimento.cod_empresa
           AND   item_lancto_ctbl.cod_plano_cta    = 'padrao'
           AND   item_lancto_ctbl.cod_cta_ctbl     = p_cod_cta_ctbl
           AND   item_lancto_ctbl.cod_estab        = estabelecimento.cod_estab
           AND  (item_lancto_ctbl.cod_cenar_ctbl   = tt-param.cod_cenar_ctbl
           OR    item_lancto_ctbl.cod_cenar_ctbl   = "")
           AND   item_lancto_ctbl.dat_lancto_ctbl >= tt-param.data-ini
           AND   item_lancto_ctbl.dat_lancto_ctbl <= tt-param.data-fim,
           EACH lancto_ctbl OF item_lancto_ctbl NO-LOCK
                WHERE lancto_ctbl.cod_modul_dtsul  <> "ACR"
                  AND lancto_ctbl.cod_modul_dtsul  <> "APB"
                  AND lancto_ctbl.cod_modul_dtsul  <> "CMG"
                  AND lancto_ctbl.cod_modul_dtsul  <> "CEP":
    
           IF item_lancto_ctbl.cod_ccusto <> "" THEN DO:
               RUN pi-valida-cc-uni-estab(INPUT estabelecimento.cod_estab,
                                          INPUT item_lancto_ctbl.cod_ccusto,
                                          INPUT item_lancto_ctbl.cod_unid_negoc).
               IF RETURN-VALUE <> "" THEN DO:
                   FIND int_item_lancto_ctbl OF item_lancto_ctbl NO-LOCK NO-ERROR.

                   CREATE tt-dados.
                   ASSIGN tt-dados.cod_estab             = estabelecimento.cod_estab
                          tt-dados.origem                = "FGL"
                          tt-dados.ind_natur_lancto_ctbl = item_lancto_ctbl.ind_natur_lancto_ctbl
                          tt-dados.dt_transacao          = item_lancto_ctbl.dat_lancto_ctbl
                          tt-dados.val_aprop_ctbl        = item_lancto_ctbl.val_lancto_ctbl * (IF tt-dados.ind_natur_lancto_ctbl = "DB" THEN 1 ELSE -1)
                          tt-dados.cod_cta_ctbl          = item_lancto_ctbl.cod_cta_ctbl
                          tt-dados.cod_ccusto            = item_lancto_ctbl.cod_ccusto
                          tt-dados.cod_unid_negoc        = item_lancto_ctbl.cod_unid_negoc
                          tt-dados.des_lancto            = "Lote: " + string(item_lancto_ctbl.num_lote_ctbl) + " Seq: " + string(item_lancto_ctbl.num_seq_lancto_ctbl) + " Historico: " + item_lancto_ctbl.des_histor_lancto_ctbl
                          tt-dados.cod_emitente          = 0
                          tt-dados.nome_emitente         = ""
                          tt-dados.cod_espec_docto       = ""
                          tt-dados.cod_ser_docto         = ""
                          tt-dados.cod_tit_ap            = ""
                          tt-dados.cod_parcela           = ""
                          tt-dados.erro                  = RETURN-VALUE
                          tt-dados.cod_usuar_ult_atualiz = IF AVAIL int_item_lancto_ctbl THEN int_item_lancto_ctbl.cod_usuar_ult_atualiz ELSE "".
               END.
           END.
       END.
    
       run pi-acompanhar in h-acomp (INPUT "Movimentos Contas a Pagar - APB").
       /* ** Movimentos Contas a Pagar - APB ***/
       FOR EACH aprop_ctbl_ap NO-LOCK
           WHERE aprop_ctbl_ap.cod_estab           = estabelecimento.cod_estab
             AND aprop_ctbl_ap.cod_plano_cta_ctbl  = "PADRAO"
             AND aprop_ctbl_ap.cod_cta_ctbl        = p_cod_cta_ctbl
             AND aprop_ctbl_ap.dat_transacao      >= tt-param.data-ini
             AND aprop_ctbl_ap.dat_transacao      <= tt-param.data-fim:
    
           FIND FIRST movto_tit_ap NO-LOCK
                WHERE movto_tit_ap.cod_estab           = aprop_ctbl_ap.cod_estab
                  AND movto_tit_ap.num_id_movto_tit_ap = aprop_ctbl_ap.num_id_movto_tit_ap
                  AND movto_tit_ap.log_movto_estordo   = NO NO-ERROR.
    
           IF NOT AVAIL movto_tit_ap 
              THEN NEXT.

           IF aprop_ctbl_ap.cod_ccusto <> "" THEN DO:
               RUN pi-valida-cc-uni-estab(INPUT estabelecimento.cod_estab,
                                          INPUT aprop_ctbl_ap.cod_ccusto,
                                          INPUT aprop_ctbl_ap.cod_unid_negoc).
               IF RETURN-VALUE <> "" THEN DO:
                   CREATE tt-dados.
                   ASSIGN tt-dados.cod_estab             = estabelecimento.cod_estab
                          tt-dados.origem                = "APB"
                          tt-dados.ind_natur_lancto_ctbl = aprop_ctbl_ap.ind_natur_lancto_ctbl
                          tt-dados.dt_transacao          = aprop_ctbl_ap.dat_transacao
                          tt-dados.val_aprop_ctbl        = aprop_ctbl_ap.val_aprop_ctbl * (IF tt-dados.ind_natur_lancto_ctbl = "DB" THEN 1 ELSE -1)
                          tt-dados.cod_cta_ctbl          = aprop_ctbl_ap.cod_cta_ctbl
                          tt-dados.cod_ccusto            = aprop_ctbl_ap.cod_ccusto
                          tt-dados.cod_unid_negoc        = aprop_ctbl_ap.cod_unid_negoc
                          tt-dados.erro                  = RETURN-VALUE
                          tt-dados.cod_usuar_ult_atualiz = movto_tit_ap.cod_usuario.

                   /*Fabiano - Tratamento para t°tulos implantados em outra moeda*/
                   if aprop_ctbl_ap.cod_indic_econ <> 'real'
                   then do:
                        assign tt-dados.val_aprop_ctbl = 0.
                        for each val_aprop_ctbl_ap of aprop_ctbl_ap no-lock
                           WHERE val_aprop_ctbl_ap.cod_finalid_econ = "corrente":
                            assign tt-dados.val_aprop_ctbl = tt-dados.val_aprop_ctbl + (val_aprop_ctbl_ap.val_aprop * (IF tt-dados.ind_natur_lancto_ctbl = "DB" THEN 1 ELSE -1)).
                        end.
                   end.

                   FIND FIRST emscad.fornecedor NO-LOCK
                        WHERE emscad.fornecedor.cod_empresa    = movto_tit_ap.cod_empresa 
                          AND emscad.fornecedor.cdn_fornecedor = movto_tit_ap.cdn_fornecedor NO-ERROR.

                   IF AVAIL emscad.fornecedor 
                      THEN ASSIGN tt-dados.cod_emitente  = emscad.fornecedor.cdn_fornecedor
                                  tt-dados.nome_emitente = emscad.fornecedor.nom_pessoa.

                   FIND FIRST histor_tit_movto_ap NO-LOCK 
                        WHERE histor_tit_movto_ap.cod_estab           = movto_tit_ap.cod_estab
                          AND histor_tit_movto_ap.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap
                          AND histor_tit_movto_ap.num_id_tit_ap       = movto_tit_ap.num_id_tit_ap NO-ERROR.
                   IF AVAIL histor_tit_movto_ap 
                      THEN ASSIGN tt-dados.des_lancto = histor_tit_movto_ap.des_text_histor.

                   FIND FIRST tit_ap OF movto_tit_ap NO-LOCK NO-ERROR.

                   IF AVAIL tit_ap 
                      THEN ASSIGN tt-dados.cod_espec_docto = tit_ap.cod_espec_docto
                                  tt-dados.cod_ser_docto   = tit_ap.cod_ser_docto
                                  tt-dados.cod_tit_ap      = tit_ap.cod_tit_ap
                                  tt-dados.cod_parcela     = tit_ap.cod_parcela.
               END.
           END.
       END.
    
       run pi-acompanhar in h-acomp (INPUT "Movimentos Contas a Receber - ACR").
       /* ** Movimentos Contas a Receber - ACR ***/
       FOR EACH aprop_ctbl_acr NO-LOCK
           WHERE aprop_ctbl_acr.cod_estab           = estabelecimento.cod_estab
             AND aprop_ctbl_acr.cod_plano_cta_ctbl  = "PADRAO"
             AND aprop_ctbl_acr.cod_cta_ctbl        = p_cod_cta_ctbl
             AND aprop_ctbl_acr.dat_transacao      >= tt-param.data-ini
             AND aprop_ctbl_acr.dat_transacao      <= tt-param.data-fim:
    
           FIND FIRST movto_tit_acr NO-LOCK
                WHERE movto_tit_acr.cod_estab            = aprop_ctbl_acr.cod_estab
                  AND movto_tit_acr.num_id_movto_tit_acr = aprop_ctbl_acr.num_id_movto_tit_acr
                  AND movto_tit_acr.log_movto_estordo    = NO NO-ERROR.
    
           IF NOT AVAIL movto_tit_acr 
              THEN NEXT.
    
           FIND FIRST tit_acr OF movto_tit_acr NO-LOCK NO-ERROR.
    
           IF NOT AVAIL tit_acr 
              THEN NEXT.
    
           IF aprop_ctbl_acr.cod_ccusto <> "" THEN DO:
               RUN pi-valida-cc-uni-estab(INPUT estabelecimento.cod_estab,
                                          INPUT aprop_ctbl_acr.cod_ccusto,
                                          INPUT aprop_ctbl_acr.cod_unid_negoc).
               IF RETURN-VALUE <> "" THEN DO:
                   CREATE tt-dados.
                   ASSIGN tt-dados.cod_estab             = estabelecimento.cod_estab
                          tt-dados.origem                = "ACR"
                          tt-dados.ind_natur_lancto_ctbl = aprop_ctbl_acr.ind_natur_lancto_ctbl
                          tt-dados.dt_transacao          = aprop_ctbl_acr.dat_transacao
                          tt-dados.cod_espec_docto       = tit_acr.cod_espec_docto
                          tt-dados.cod_ser_docto         = tit_acr.cod_ser_docto
                          tt-dados.cod_tit_ap            = tit_acr.cod_tit_acr
                          tt-dados.cod_parcela           = tit_acr.cod_parcela
                          tt-dados.val_aprop_ctbl        = aprop_ctbl_acr.val_aprop_ctbl * (IF tt-dados.ind_natur_lancto_ctbl = "DB" THEN 1 ELSE -1)
                          tt-dados.cod_cta_ctbl          = aprop_ctbl_acr.cod_cta_ctbl
                          tt-dados.cod_ccusto            = aprop_ctbl_acr.cod_ccusto
                          tt-dados.cod_unid_negoc        = aprop_ctbl_acr.cod_unid_negoc
                          tt-dados.erro                  = RETURN-VALUE
                          tt-dados.cod_usuar_ult_atualiz = movto_tit_acr.cod_usuario.

                   /*Fabiano - Tratamento para t°tulos implantados em outra moeda*/
                   if aprop_ctbl_acr.cod_indic_econ <> 'real'
                   then do:
                        assign tt-dados.val_aprop_ctbl = 0.
                        for each val_aprop_ctbl_acr of aprop_ctbl_acr no-lock
                           WHERE val_aprop_ctbl_acr.cod_finalid_econ = "corrente":
                            assign tt-dados.val_aprop_ctbl = tt-dados.val_aprop_ctbl + (val_aprop_ctbl_acr.val_aprop * (IF tt-dados.ind_natur_lancto_ctbl = "DB" THEN 1 ELSE -1)).
                        end.
                   end.

                   FIND FIRST emscad.cliente NO-LOCK
                        WHERE emscad.cliente.cod_empresa = movto_tit_acr.cod_empresa 
                          AND emscad.cliente.cdn_cliente = movto_tit_acr.cdn_cliente NO-ERROR.

                   IF AVAIL emscad.cliente  
                      THEN ASSIGN tt-dados.cod_emitente  = emscad.cliente.cdn_cliente
                                  tt-dados.nome_emitente = emscad.cliente.nom_pessoa.

                   FIND FIRST histor_movto_tit_acr NO-LOCK 
                        WHERE histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                          AND histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                          AND histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr NO-ERROR.
                   IF AVAIL histor_movto_tit_acr 
                      THEN ASSIGN tt-dados.des_lancto = histor_movto_tit_acr.des_text_histor.
               END.
           END.
       END.
    
       run pi-acompanhar in h-acomp (INPUT "Movimentos Caixa e Bancos - CMG").
       /* ** Movimentos Caixa e Bancos - CMG ***/
       FOR EACH aprop_ctbl_cmg NO-LOCK
           WHERE aprop_ctbl_cmg.cod_estab           = estabelecimento.cod_estab
             AND aprop_ctbl_cmg.cod_plano_cta_ctbl  = "PADRAO"
             AND aprop_ctbl_cmg.cod_cta_ctbl        = p_cod_cta_ctbl
             AND aprop_ctbl_cmg.dat_transacao      >= tt-param.data-ini
             AND aprop_ctbl_cmg.dat_transacao      <= tt-param.data-fim:

            FIND FIRST movto_cta_corren OF aprop_ctbl_cmg NO-LOCK NO-ERROR.

            IF NOT AVAIL movto_cta_corren
               THEN NEXT.

            IF aprop_ctbl_cmg.cod_ccusto <> "" THEN DO:
                RUN pi-valida-cc-uni-estab(INPUT estabelecimento.cod_estab,
                                           INPUT aprop_ctbl_cmg.cod_ccusto,
                                           INPUT aprop_ctbl_cmg.cod_unid_negoc).
                IF RETURN-VALUE <> "" THEN DO:
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
                           tt-dados.val_aprop_ctbl        = aprop_ctbl_cmg.val_movto_cta_corren * (IF tt-dados.ind_natur_lancto_ctbl = "DB" THEN 1 ELSE -1)
                           tt-dados.cod_cta_ctbl          = aprop_ctbl_cmg.cod_cta_ctbl
                           tt-dados.cod_ccusto            = aprop_ctbl_cmg.cod_ccusto
                           tt-dados.cod_unid_negoc        = aprop_ctbl_cmg.cod_unid_negoc
                           tt-dados.des_lancto            = movto_cta_corren.des_histor_movto_cta_corren
                           tt-dados.erro                  = RETURN-VALUE
                           tt-dados.cod_usuar_ult_atualiz = movto_cta_corren.cod_usuar_ult_atualiz.
                
                    /*Fabiano - Tratamento para t°tulos implantados em outra moeda*/
                    if aprop_ctbl_cmg.cod_indic_econ <> 'real'
                    then do:
                         assign tt-dados.val_aprop_ctbl = 0.
                         for each val_aprop_ctbl_cmg of aprop_ctbl_cmg no-lock
                            WHERE val_aprop_ctbl_cmg.cod_finalid_econ = "corrente":
                             assign tt-dados.val_aprop_ctbl = tt-dados.val_aprop_ctbl + (val_aprop_ctbl_cmg.val_movto_cta_corren * (IF tt-dados.ind_natur_lancto_ctbl = "DB" THEN 1 ELSE -1)).
                         end.
                    end.
                END.
            END.
       END.
   END.

   run pi-acompanhar in h-acomp (INPUT "Movimentos Estoque - CEP").
   /* ** Movimentos Estoque - CEP ***/
   DO i-data = tt-param.data-ini TO tt-param.data-fim:
       FOR EACH movto-estoq FIELDS (dt-trans esp-docto usuario serie-docto it-codigo quantidade nro-docto 
                                    valor-mob-m valor-ggf-m cod-emitente tipo-trans ct-codigo valor-mat-m cod-estabel descricao-db
                                    nat-operacao sequen-nf sc-codigo cod-unid-negoc) NO-LOCK /*USE-INDEX data-conta*/
          WHERE movto-estoq.dt-trans  = i-data
            AND movto-estoq.ct-codigo = p_cod_cta_ctbl:
 
            /*/* ** Limitaá∆o na localizaá∆o dos valores no EMS2, que est∆o em bases separadas por empresa ***/
            IF  movto-estoq.cod-estabel <> "101"
            AND movto-estoq.cod-estabel <> "102"
            AND movto-estoq.cod-estabel <> "105"
                THEN NEXT.*/
            
            IF movto-estoq.sc-codigo <> "" THEN DO:
                RUN pi-valida-cc-uni-estab(INPUT movto-estoq.cod-estabel,
                                           INPUT movto-estoq.sc-codigo,
                                           INPUT movto-estoq.cod-unid-negoc).
                IF RETURN-VALUE <> "" THEN DO:
                    CREATE tt-dados.
                    ASSIGN tt-dados.cod_estab             = movto-estoq.cod-estabel
                           tt-dados.origem                = "CEP"
                           tt-dados.ind_natur_lancto_ctbl = IF movto-estoq.tipo-trans = 1 THEN "CR" ELSE "DB"
                           tt-dados.cod_emitente          = movto-estoq.cod-emitente
                           tt-dados.dt_transacao          = movto-estoq.dt-trans
                           tt-dados.cod_espec_docto       = string(movto-estoq.esp-docto)
                           tt-dados.cod_ser_docto         = movto-estoq.serie
                           tt-dados.cod_tit_ap            = string(movto-estoq.nro-docto)
                           tt-dados.cod_parcela           = "0"
                           tt-dados.val_aprop_ctbl        = (movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1]) * 
                                                            (IF tt-dados.ind_natur_lancto_ctbl = "DB" THEN 1 ELSE -1)
                           tt-dados.cod_cta_ctbl          = p_cod_cta_ctbl
                           tt-dados.cod_ccusto            = movto-estoq.sc-codigo
                           tt-dados.cod_unid_negoc        = movto-estoq.cod-unid-negoc
                           tt-dados.erro                  = RETURN-VALUE
                           tt-dados.cod_usuar_ult_atualiz = movto-estoq.usuario.
        
                    
                    IF tt-dados.cod_unid_negoc <> "" 
                    THEN DO:
                         FIND unid_negoc NO-LOCK
                            WHERE unid_negoc.cdn_unid_negoc = INT(tt-dados.cod_unid_negoc) NO-ERROR.
                         IF AVAIL unid_negoc 
                            THEN ASSIGN tt-dados.cod_unid_negoc = unid_negoc.cod_unid_negoc.
                    END.
        
                    IF tt-dados.val_aprop_ctbl = 0 
                    THEN DO:
                         find item-estab no-lock
                              where item-estab.cod-estabel = movto-estoq.cod-estabel
                                and item-estab.it-codigo   = movto-estoq.it-codigo no-error.
        
                         if avail item-estab then
                             assign tt-dados.val_aprop_ctbl = (movto-estoq.quantidade * 
                                                             (item-estab.val-unit-mat-m[1]
                                                             + item-estab.val-unit-mob-m[1]
                                                             + item-estab.val-unit-ggf-m[1] )) * (IF tt-dados.ind_natur_lancto_ctbl = "DB" THEN 1 ELSE -1).
                    END.
        
                    FIND ITEM NO-LOCK WHERE ITEM.it-codigo = movto-estoq.it-codigo.
        
                    IF movto-estoq.cod-emitente <> 0 
                    THEN DO:
                         FIND emitente NO-LOCK WHERE emitente.cod-emitente = movto-estoq.cod-emitente NO-ERROR.
        
                         IF AVAIL emitente 
                            THEN ASSIGN tt-dados.nome_emitente = emitente.nome-emit.
        
                    END.
                    ELSE ASSIGN tt-dados.nome_emitente = item.it-codigo + " " + movto-estoq.usuario.
        
                    find item-doc-est no-lock
                         where item-doc-est.serie-docto  = movto-estoq.serie-docto
                           and item-doc-est.nro-docto    = movto-estoq.nro-docto
                           and item-doc-est.cod-emitente = movto-estoq.cod-emitente
                           and item-doc-est.nat-operacao = movto-estoq.nat-operacao
                           and item-doc-est.sequencia    = movto-estoq.sequen-nf no-error.
                     if avail item-doc-est
                        then assign tt-dados.nome_emitente = tt-dados.nome_emitente
                                    tt-dados.des_lancto    = item-doc-est.narrativa.                
                END.
            END.
       END.
   END.
END.

PROCEDURE pi_leitura_lancto2:
/*****************************************************************************
**  Procedure Interna: pi_leitura_lancto2
**  Descricao........: Leitura Movimentaá‰es
*****************************************************************************/

   DEF INPUT PARAMETER p_cod_cta_ctbl AS CHAR FORMAT "x(8)" NO-UNDO.

   DEF VAR i-data             AS DATE.
   DEF VAR c-conta-contabil LIKE movto-estoq.ct-codigo.

   DEFINE VARIABLE c-erro-fat AS CHARACTER FORMAT "x(200)"  NO-UNDO.
   DEFINE VARIABLE de-valor AS DECIMAL     NO-UNDO.

   FOR EACH estabelecimento NO-LOCK
      WHERE estabelecimento.cod_empresa = "1":
       
       /*/* ** Limitaá∆o na localizaá∆o dos valores no EMS2, que est∆o em bases separadas por empresa ***/
       IF  estabelecimento.cod_estab <> "101"
       AND estabelecimento.cod_estab <> "102" 
       AND estabelecimento.cod_estab <> "105" 
           THEN NEXT.*/

       run pi-acompanhar in h-acomp (INPUT "Movimentos Contabilidade - FGL").
       /* ** Movimentos Contabilidade - FGL ***/
       FOR EACH item_lancto_ctbl NO-LOCK
           WHERE item_lancto_ctbl.cod_empres       = estabelecimento.cod_empresa
           AND   item_lancto_ctbl.cod_plano_cta    = 'padrao'
           AND   item_lancto_ctbl.cod_cta_ctbl     = p_cod_cta_ctbl
           AND   item_lancto_ctbl.cod_estab        = estabelecimento.cod_estab
           AND  (item_lancto_ctbl.cod_cenar_ctbl   = tt-param.cod_cenar_ctbl
           OR    item_lancto_ctbl.cod_cenar_ctbl   = "")
           AND   item_lancto_ctbl.dat_lancto_ctbl >= tt-param.data-ini
           AND   item_lancto_ctbl.dat_lancto_ctbl <= tt-param.data-fim,
           EACH lancto_ctbl OF item_lancto_ctbl NO-LOCK
                WHERE lancto_ctbl.cod_modul_dtsul  <> "ACR"
                  AND lancto_ctbl.cod_modul_dtsul  <> "APB"
                  AND lancto_ctbl.cod_modul_dtsul  <> "CMG"
                  AND lancto_ctbl.cod_modul_dtsul  <> "CEP":

           FIND int_item_lancto_ctbl OF item_lancto_ctbl NO-LOCK NO-ERROR.
    
           CREATE tt-dados2.
           ASSIGN tt-dados2.codigo                = conciliacao-contas.codigo
                  tt-dados2.cod_estab             = estabelecimento.cod_estab
                  tt-dados2.origem                = "FGL"
                  tt-dados2.ind_natur_lancto_ctbl = item_lancto_ctbl.ind_natur_lancto_ctbl
                  tt-dados2.dt_transacao          = item_lancto_ctbl.dat_lancto_ctbl
                  tt-dados2.val_aprop_ctbl        = item_lancto_ctbl.val_lancto_ctbl * (IF tt-dados2.ind_natur_lancto_ctbl = "DB" THEN 1 ELSE -1)
                  tt-dados2.cod_cta_ctbl          = item_lancto_ctbl.cod_cta_ctbl
                  tt-dados2.cod_ccusto            = item_lancto_ctbl.cod_ccusto
                  tt-dados2.cod_unid_negoc        = item_lancto_ctbl.cod_unid_negoc
                  tt-dados2.des_lancto            = "Lote: " + string(item_lancto_ctbl.num_lote_ctbl) + " Seq: " + string(item_lancto_ctbl.num_seq_lancto_ctbl) + " Historico: " + item_lancto_ctbl.des_histor_lancto_ctbl
                  tt-dados2.cod_emitente          = 0
                  tt-dados2.nome_emitente         = ""
                  tt-dados2.cod_espec_docto       = ""
                  tt-dados2.cod_ser_docto         = ""
                  tt-dados2.cod_tit_ap            = ""
                  tt-dados2.cod_parcela           = ""
                  tt-dados2.cod_usuar_ult_atualiz = IF AVAIL int_item_lancto_ctbl THEN int_item_lancto_ctbl.cod_usuar_ult_atualiz ELSE "".

          RUN pi-totaliza-contas.
       END.
    
       run pi-acompanhar in h-acomp (INPUT "Movimentos Contas a Pagar - APB").
       /* ** Movimentos Contas a Pagar - APB ***/
       FOR EACH aprop_ctbl_ap NO-LOCK
           WHERE aprop_ctbl_ap.cod_estab           = estabelecimento.cod_estab
             AND aprop_ctbl_ap.cod_plano_cta_ctbl  = "PADRAO"
             AND aprop_ctbl_ap.cod_cta_ctbl        = p_cod_cta_ctbl
             AND aprop_ctbl_ap.dat_transacao      >= tt-param.data-ini
             AND aprop_ctbl_ap.dat_transacao      <= tt-param.data-fim:
    
           FIND FIRST movto_tit_ap NO-LOCK
                WHERE movto_tit_ap.cod_estab           = aprop_ctbl_ap.cod_estab
                  AND movto_tit_ap.num_id_movto_tit_ap = aprop_ctbl_ap.num_id_movto_tit_ap
                  AND movto_tit_ap.log_movto_estordo   = NO NO-ERROR.
    
           IF NOT AVAIL movto_tit_ap 
              THEN NEXT.

           CREATE tt-dados2.
           ASSIGN tt-dados2.codigo                 = conciliacao-contas.codigo
                  tt-dados2.cod_estab             = estabelecimento.cod_estab
                  tt-dados2.origem                = "APB"
                  tt-dados2.ind_natur_lancto_ctbl = aprop_ctbl_ap.ind_natur_lancto_ctbl
                  tt-dados2.dt_transacao          = aprop_ctbl_ap.dat_transacao
                  tt-dados2.val_aprop_ctbl        = aprop_ctbl_ap.val_aprop_ctbl * (IF tt-dados2.ind_natur_lancto_ctbl = "DB" THEN 1 ELSE -1)
                  tt-dados2.cod_cta_ctbl          = aprop_ctbl_ap.cod_cta_ctbl
                  tt-dados2.cod_ccusto            = aprop_ctbl_ap.cod_ccusto
                  tt-dados2.cod_unid_negoc        = aprop_ctbl_ap.cod_unid_negoc
                  tt-dados2.cod_usuar_ult_atualiz = movto_tit_ap.cod_usuario.

           /*Fabiano - Tratamento para t°tulos implantados em outra moeda*/
           if aprop_ctbl_ap.cod_indic_econ <> 'real'
           then do:
                assign tt-dados2.val_aprop_ctbl = 0.
                for each val_aprop_ctbl_ap of aprop_ctbl_ap no-lock
                   WHERE val_aprop_ctbl_ap.cod_finalid_econ = "corrente":
                    assign tt-dados2.val_aprop_ctbl = tt-dados2.val_aprop_ctbl + (val_aprop_ctbl_ap.val_aprop * (IF tt-dados2.ind_natur_lancto_ctbl = "DB" THEN 1 ELSE -1)).
                end.
           end.

           FIND FIRST emscad.fornecedor NO-LOCK
                WHERE emscad.fornecedor.cod_empresa    = movto_tit_ap.cod_empresa 
                  AND emscad.fornecedor.cdn_fornecedor = movto_tit_ap.cdn_fornecedor NO-ERROR.

           IF AVAIL emscad.fornecedor 
              THEN ASSIGN tt-dados2.cod_emitente  = emscad.fornecedor.cdn_fornecedor
                          tt-dados2.nome_emitente = emscad.fornecedor.nom_pessoa.

           FIND FIRST histor_tit_movto_ap NO-LOCK 
                WHERE histor_tit_movto_ap.cod_estab           = movto_tit_ap.cod_estab
                  AND histor_tit_movto_ap.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap
                  AND histor_tit_movto_ap.num_id_tit_ap       = movto_tit_ap.num_id_tit_ap NO-ERROR.
           IF AVAIL histor_tit_movto_ap 
              THEN ASSIGN tt-dados2.des_lancto = histor_tit_movto_ap.des_text_histor.

           FIND FIRST tit_ap OF movto_tit_ap NO-LOCK NO-ERROR.

           IF AVAIL tit_ap 
              THEN ASSIGN tt-dados2.cod_espec_docto = tit_ap.cod_espec_docto
                          tt-dados2.cod_ser_docto   = tit_ap.cod_ser_docto
                          tt-dados2.cod_tit_ap      = tit_ap.cod_tit_ap
                          tt-dados2.cod_parcela     = tit_ap.cod_parcela.

           RUN pi-totaliza-contas.
       END.
    
       run pi-acompanhar in h-acomp (INPUT "Movimentos Contas a Receber - ACR").
       /* ** Movimentos Contas a Receber - ACR ***/
       FOR EACH aprop_ctbl_acr NO-LOCK
           WHERE aprop_ctbl_acr.cod_estab           = estabelecimento.cod_estab
             AND aprop_ctbl_acr.cod_plano_cta_ctbl  = "PADRAO"
             AND aprop_ctbl_acr.cod_cta_ctbl        = p_cod_cta_ctbl
             AND aprop_ctbl_acr.dat_transacao      >= tt-param.data-ini
             AND aprop_ctbl_acr.dat_transacao      <= tt-param.data-fim:
    
           FIND FIRST movto_tit_acr NO-LOCK
                WHERE movto_tit_acr.cod_estab            = aprop_ctbl_acr.cod_estab
                  AND movto_tit_acr.num_id_movto_tit_acr = aprop_ctbl_acr.num_id_movto_tit_acr
                  AND movto_tit_acr.log_movto_estordo    = NO NO-ERROR.
    
           IF NOT AVAIL movto_tit_acr 
              THEN NEXT.
    
           FIND FIRST tit_acr OF movto_tit_acr NO-LOCK NO-ERROR.
    
           IF NOT AVAIL tit_acr 
              THEN NEXT.

           CREATE tt-dados2.
           ASSIGN tt-dados2.codigo                = conciliacao-contas.codigo
                  tt-dados2.cod_estab             = estabelecimento.cod_estab
                  tt-dados2.origem                = "ACR"
                  tt-dados2.ind_natur_lancto_ctbl = aprop_ctbl_acr.ind_natur_lancto_ctbl
                  tt-dados2.dt_transacao          = aprop_ctbl_acr.dat_transacao
                  tt-dados2.cod_espec_docto       = tit_acr.cod_espec_docto
                  tt-dados2.cod_ser_docto         = tit_acr.cod_ser_docto
                  tt-dados2.cod_tit_ap            = tit_acr.cod_tit_acr
                  tt-dados2.cod_parcela           = tit_acr.cod_parcela
                  tt-dados2.val_aprop_ctbl        = aprop_ctbl_acr.val_aprop_ctbl * (IF tt-dados2.ind_natur_lancto_ctbl = "DB" THEN 1 ELSE -1)
                  tt-dados2.cod_cta_ctbl          = aprop_ctbl_acr.cod_cta_ctbl
                  tt-dados2.cod_ccusto            = aprop_ctbl_acr.cod_ccusto
                  tt-dados2.cod_unid_negoc        = aprop_ctbl_acr.cod_unid_negoc
                  tt-dados2.cod_usuar_ult_atualiz = movto_tit_acr.cod_usuario
                  tt-dados2.ind_trans             = movto_tit_acr.ind_trans_acr_abrev.

           /*Fabiano - Tratamento para t°tulos implantados em outra moeda*/
           if aprop_ctbl_acr.cod_indic_econ <> 'real'
           then do:
                assign tt-dados2.val_aprop_ctbl = 0.
                for each val_aprop_ctbl_acr of aprop_ctbl_acr no-lock
                   WHERE val_aprop_ctbl_acr.cod_finalid_econ = "corrente":
                    assign tt-dados2.val_aprop_ctbl = tt-dados2.val_aprop_ctbl + (val_aprop_ctbl_acr.val_aprop * (IF tt-dados2.ind_natur_lancto_ctbl = "DB" THEN 1 ELSE -1)).
                end.
           end.

           FIND FIRST emscad.cliente NO-LOCK
                WHERE emscad.cliente.cod_empresa = movto_tit_acr.cod_empresa 
                  AND emscad.cliente.cdn_cliente = movto_tit_acr.cdn_cliente NO-ERROR.

           IF AVAIL emscad.cliente  
              THEN ASSIGN tt-dados2.cod_emitente  = emscad.cliente.cdn_cliente
                          tt-dados2.nome_emitente = emscad.cliente.nom_pessoa.

           FIND FIRST histor_movto_tit_acr NO-LOCK 
                WHERE histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                  AND histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                  AND histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr NO-ERROR.
           IF AVAIL histor_movto_tit_acr 
              THEN ASSIGN tt-dados2.des_lancto = histor_movto_tit_acr.des_text_histor.

           FIND FIRST tt-acr WHERE
                      tt-acr.cod-estabel  = tt-dados2.cod_estab     AND
                    /*  tt-acr.serie-docto  = tt-dados2.cod_ser_docto AND */
                      tt-acr.nro-docto    = tt-dados2.cod_tit_ap    AND
                      tt-acr.cod-emitente = tt-dados2.cod_emitente
                      NO-LOCK NO-ERROR.
           
           IF NOT AVAIL tt-acr 
           THEN DO:
               CREATE tt-acr.
               ASSIGN tt-acr.cod-estabel  = tt-dados2.cod_estab
                      tt-acr.serie-docto  = tt-dados2.cod_ser_docto
                      tt-acr.nro-docto    = tt-dados2.cod_tit_ap
                      tt-acr.cod-emitente = tt-dados2.cod_emitente
                    /*  tt-rec.nat-operacao = item-doc-est.nat-operacao */
                      tt-acr.valor        = tt-dados2.val_aprop_ctbl
                      tt-acr.data         = tt-dados2.dt_transacao
                      tt-acr.usuario      = tt-dados2.cod_usuar_ult_atualiz.
           END.
           ELSE ASSIGN tt-acr.valor = tt-acr.valor + tt-dados2.val_aprop_ctbl.

           RUN pi-totaliza-contas.
       END.
    
       run pi-acompanhar in h-acomp (INPUT "Movimentos Caixa e Bancos - CMG").
       /* ** Movimentos Caixa e Bancos - CMG ***/
       FOR EACH aprop_ctbl_cmg NO-LOCK
           WHERE aprop_ctbl_cmg.cod_estab           = estabelecimento.cod_estab
             AND aprop_ctbl_cmg.cod_plano_cta_ctbl  = "PADRAO"
             AND aprop_ctbl_cmg.cod_cta_ctbl        = p_cod_cta_ctbl
             AND aprop_ctbl_cmg.dat_transacao      >= tt-param.data-ini
             AND aprop_ctbl_cmg.dat_transacao      <= tt-param.data-fim:

            FIND FIRST movto_cta_corren OF aprop_ctbl_cmg NO-LOCK NO-ERROR.

            IF NOT AVAIL movto_cta_corren
               THEN NEXT.

            CREATE tt-dados2.
            ASSIGN tt-dados2.codigo                 = conciliacao-contas.codigo
                   tt-dados2.cod_estab             = estabelecimento.cod_estab
                   tt-dados2.origem                = "CMG"
                   tt-dados2.ind_natur_lancto_ctbl = aprop_ctbl_cmg.ind_natur_lancto_ctbl
                   tt-dados2.dt_transacao          = aprop_ctbl_cmg.dat_transacao
                   tt-dados2.cod_espec_docto       = ""
                   tt-dados2.cod_ser_docto         = ""
                   tt-dados2.cod_tit_ap            = ""
                   tt-dados2.cod_parcela           = ""
                   tt-dados2.cod_emitente          = 0
                   tt-dados2.nome_emitente         = ""
                   tt-dados2.val_aprop_ctbl        = aprop_ctbl_cmg.val_movto_cta_corren * (IF tt-dados2.ind_natur_lancto_ctbl = "DB" THEN 1 ELSE -1)
                   tt-dados2.cod_cta_ctbl          = aprop_ctbl_cmg.cod_cta_ctbl
                   tt-dados2.cod_ccusto            = aprop_ctbl_cmg.cod_ccusto
                   tt-dados2.cod_unid_negoc        = aprop_ctbl_cmg.cod_unid_negoc
                   tt-dados2.des_lancto            = movto_cta_corren.des_histor_movto_cta_corren
                   tt-dados2.cod_usuar_ult_atualiz = movto_cta_corren.cod_usuar_ult_atualiz.

            /*Fabiano - Tratamento para t°tulos implantados em outra moeda*/
            if aprop_ctbl_cmg.cod_indic_econ <> 'real'
            then do:
                 assign tt-dados2.val_aprop_ctbl = 0.
                 for each val_aprop_ctbl_cmg of aprop_ctbl_cmg no-lock
                    WHERE val_aprop_ctbl_cmg.cod_finalid_econ = "corrente":
                     assign tt-dados2.val_aprop_ctbl = tt-dados2.val_aprop_ctbl + (val_aprop_ctbl_cmg.val_movto_cta_corren * (IF tt-dados2.ind_natur_lancto_ctbl = "DB" THEN 1 ELSE -1)).
                 end.
            end.
            
            RUN pi-totaliza-contas.
       END.

       /*run pi-acompanhar in h-acomp (INPUT "Movimentos Transporte - TMS").
       FOR EACH movct-tr NO-LOCK USE-INDEX ch-data-mov
          WHERE movct-tr.ep-codigo     = param-gerais.ep-codigo
            AND movct-tr.dt-movimento >= tt-param.data-ini
            AND movct-tr.dt-movimento <= tt-param.data-fim
            AND movct-tr.cod-estabel   = estabelecimento.cod_estab
            AND (movct-tr.conta-debito  BEGINS p_cod_cta_ctbl OR
                 movct-tr.conta-credito BEGINS p_cod_cta_ctbl):

           IF movct-tr.conta-debito BEGINS p_cod_cta_ctbl THEN
               ASSIGN de-valor = movct-tr.vl-movimento.
           ELSE 
               ASSIGN de-valor = movct-tr.vl-movimento * -1.

           FIND FIRST emitente NO-LOCK 
                WHERE emitente.cgc = movct-tr.cnpj-emissor NO-ERROR.
           CREATE tt-dados2.
           ASSIGN tt-dados2.codigo                = conciliacao-contas.codigo
                  tt-dados2.cod_estab             = movct-tr.cod-estabel
                  tt-dados2.origem                = "TMS"
                  tt-dados2.ind_natur_lancto_ctbl = "CR"
                  tt-dados2.cod_emitente          = IF AVAIL emitente THEN emitente.cod-emitente ELSE 0
                  tt-dados2.nome_emitente         = IF AVAIL emitente THEN emitente.nome-emit ELSE ""
                  tt-dados2.dt_transacao          = movct-tr.dt-movimento
                  /*tt-dados2.cod_espec_docto       = string(movct-tr.esp-docto)
                  tt-dados2.cod_ser_docto         = movct-tr.serie*/
                  tt-dados2.cod_tit_ap            = STRING(movct-tr.nr-docto)
                  tt-dados2.cod_parcela           = "0"
                  tt-dados2.val_aprop_ctbl        = de-valor
                  tt-dados2.cod_cta_ctbl          = p_cod_cta_ctbl.


           FOR FIRST fatura-docto-frete NO-LOCK
               WHERE fatura-docto-frete.id-tp-docto  = movct-tr.tp-docto
                 AND fatura-docto-frete.cnpj-emit    = movct-tr.cnpj-emissor
                 AND fatura-docto-frete.serie        = movct-tr.cd-serie
                 AND fatura-docto-frete.nr-documento = STRING(movct-tr.nr-docto)
                 AND fatura-docto-frete.dt-emissao-docto = movct-tr.dt-emissao:
               ASSIGN tt-dados2.cod_tit_ap     = fatura-docto-frete.nr-fatura
                      tt-dados2.cod_ser_docto  = fatura-docto-frete.serie
                      tt-dados2.cod_parcela    = STRING(movct-tr.nr-docto)
                      tt-dados2.nr-fatura      = fatura-docto-frete.nr-fatura
                      tt-dados2.serie-fat      = fatura-docto-frete.serie-fat 
                      tt-dados2.cgc-transp     = fatura-docto-frete.cgc-transp.
           END.
           
           IF movct-tr.conta-debito BEGINS p_cod_cta_ctbl THEN
               ASSIGN tt-dados2.cod_ccusto            = SUBSTRING(movct-tr.conta-debito, 12, 5)
                       tt-dados2.cod_unid_negoc        = SUBSTRING(movct-tr.conta-debito, 9, 3).

           ELSE
               ASSIGN tt-dados2.cod_ccusto            = SUBSTRING(movct-tr.conta-credito, 12, 5)
                      tt-dados2.cod_unid_negoc        = SUBSTRING(movct-tr.conta-credito, 9, 3).

           IF tt-dados2.cod_unid_negoc <> "" THEN DO:
               FIND FIRST unid_negoc NO-LOCK
                    WHERE unid_negoc.cdn_unid_negoc = INT(tt-dados2.cod_unid_negoc) NO-ERROR.
               IF AVAIL unid_negoc 
                   THEN ASSIGN tt-dados2.cod_unid_negoc = unid_negoc.cod_unid_negoc.
           END.

           assign tt-dados2.des_lancto = movct-tr.ds-historico-movto.

           RUN pi-totaliza-contas.
       END.*/

       IF p_cod_cta_ctbl = "11910010" THEN DO: /*Faturamento*/
           run pi-acompanhar in h-acomp (INPUT "Movimentos Faturamento - FAT").

           for each nota-fiscal 
              where nota-fiscal.dt-emis-nota  >= tt-param.data-ini
                and nota-fiscal.dt-emis-nota  <= tt-param.data-fim
                and nota-fiscal.cod-estabel    = estabelecimento.cod_estab
                and nota-fiscal.dt-atual-cr   <> ? NO-LOCK:

               if nota-fiscal.emite-duplic = no then
                   next.

               FIND FIRST emitente 
                   WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.
               
               ASSIGN c-erro-fat = "".
                   
               run cdp/cd9500.p persistent set h-cd9500.

               for each it-nota-fisc use-index ch-nota-item
                  where it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
                    and it-nota-fisc.serie       = nota-fiscal.serie   
                    and it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis no-lock,
                  FIRST natur-oper 
                  where natur-oper.nat-operacao = it-nota-fisc.nat-operacao
                    and natur-oper.ind-contabilizacao no-lock:

                   find item where item.it-codigo = it-nota-fisc.it-codigo no-lock no-error.
                   if  avail emitente then do:
                       run pi-cd9500 in h-cd9500(nota-fiscal.cod-estabel,
                                                 emitente.cod-gr-cli,
                                                 rowid(item),
                                                 it-nota-fisc.nat-oper,
                                                 string(nota-fiscal.cod-emitente) /*it-nota-fisc.serie*/ ,
                                                 it-nota-fisc.cod-depos,
                                                 nota-fiscal.cod-canal-venda,
                                                 output r-conta-ft).
                   END.
                   find conta-ft
                       where rowid(conta-ft) = r-conta-ft no-lock no-error.

                   if not avail conta-ft or not avail natur-oper or not avail item THEN
                       ASSIGN c-erro-fat = c-erro-fat + " Grupo de Contas n∆o Cadastrado para item: " + item.it-codigo  + " Natureza: " + it-nota-fisc.nat-oper.
               END.

               IF VALID-HANDLE(h-cd9500) THEN
                   DELETE PROCEDURE h-cd9500.

               for each fat-duplic 
                   where fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                     and fat-duplic.serie       = nota-fiscal.serie
                     and fat-duplic.nr-fatura   = nota-fiscal.nr-nota-fis no-lock:

                   CREATE tt-dados2.
                   ASSIGN tt-dados2.codigo                = conciliacao-contas.codigo
                          tt-dados2.cod_estab             = nota-fiscal.cod-estabel  
                          tt-dados2.origem                = "FAT"
                          tt-dados2.ind_natur_lancto_ctbl = "DB"
                          tt-dados2.dt_transacao          = nota-fiscal.dt-emis-nota
                          tt-dados2.val_aprop_ctbl        = IF c-erro-fat <> "" THEN 0 ELSE IF nota-fiscal.dt-cancela <> ? THEN 0 ELSE fat-duplic.vl-parcela
                          tt-dados2.cod_cta_ctbl          = p_cod_cta_ctbl
                          tt-dados2.cod_ccusto            = ""
                          tt-dados2.cod_unid_negoc        = ""
                          tt-dados2.des_lancto            = nota-fiscal.observ-nota
                          tt-dados2.erro                  = IF c-erro-fat <> "" THEN c-erro-fat ELSE "Natureza: " + nota-fiscal.nat-oper + IF nota-fiscal.dt-cancela <> ? THEN " - Nota fiscal cancelada" ELSE ""
                          tt-dados2.cod_emitente          = nota-fiscal.cod-emitente
                          tt-dados2.nome_emitente         = IF AVAIL emitente THEN emitente.nome-emit ELSE ""
                          tt-dados2.cod_espec_docto       = fat-duplic.cod-esp
                          tt-dados2.cod_ser_docto         = fat-duplic.serie
                          tt-dados2.cod_tit_ap            = fat-duplic.nr-fatura
                          tt-dados2.cod_parcela           = fat-duplic.parcela
                          tt-dados2.cod_usuar_ult_atualiz = nota-fiscal.user-calc.

                   RUN pi-totaliza-contas.
               END.
           END.
       END.

       /*run pi-acompanhar in h-acomp (INPUT "Movimentos Patrimonio - FAS").

       FOR EACH bem_pat NO-LOCK
          WHERE bem_pat.cod_empresa  = "1"
            AND bem_pat.dat_fim_calc_pat >= tt-param.data-ini
            AND bem_pat.cod_estab         = estabelecimento.cod_estab.

            run pi-patrimonio (INPUT p_cod_cta_ctbl, Input 0).
            for each incorp_bem_pat no-lock
                where incorp_bem_pat.num_id_bem_pat = bem_pat.num_id_bem_pat:
                run pi-patrimonio (INPUT p_cod_cta_ctbl,
                                   Input incorp_bem_pat.num_seq_incorp_bem_pat).
            end.
        END.*/
   END.

   run pi-acompanhar in h-acomp (INPUT "Movimentos Transporte - TMS").
   IF p_cod_cta_ctbl = "11910005" THEN DO:
       /* TMS FOR EACH movtrp.fatura-frete NO-LOCK
          WHERE fatura-frete.dt-integr-ap >= tt-param.data-ini
            AND fatura-frete.dt-integr-ap <= tt-param.data-fim:
            FOR EACH fatura-docto-frete NO-LOCK
               WHERE fatura-docto-frete.serie-fat         = fatura-frete.serie
                 AND fatura-docto-frete.cgc-transp        = fatura-frete.cgc-transp
                 AND fatura-docto-frete.nr-fatura         = fatura-frete.nr-fatura,
               FIRST movtrp.docto-frete NO-LOCK
               WHERE docto-frete.id-tp-docto   = fatura-docto-frete.id-tp-docto
                 AND docto-frete.cnpj-emit     = fatura-docto-frete.cnpj-emit
                 AND docto-frete.serie         = fatura-docto-frete.serie
                 AND docto-frete.nr-documento  = fatura-docto-frete.nr-documento:

                /*IF docto-frete.cod-estabel <> "101" AND docto-frete.cod-estabel <> "102" AND docto-frete.cod-estabel <> "105" THEN
                    NEXT.*/

                ASSIGN l-achou = NO.
                FOR EACH movct-tr NO-LOCK
                    WHERE movct-tr.ep-codigo     = mgcad.empresa.ep-codigo
                      AND movct-tr.tp-docto      = docto-frete.id-tp-docto
                      AND movct-tr.cod-estabel   = docto-frete.cod-estabel
                      AND movct-tr.cnpj-emissor  = docto-frete.cnpj-emit
                      AND movct-tr.nr-docto      = INT(docto-frete.nr-documento)
                      AND movct-tr.cd-serie      = STRING(docto-frete.serie)
                      AND movct-tr.dt-emissao    = docto-frete.dt-emissao-docto
                      AND (/*movct-tr.conta-debito  BEGINS p_cod_cta_ctbl OR*/
                           movct-tr.conta-credito BEGINS p_cod_cta_ctbl):

                    IF movct-tr.conta-debito BEGINS p_cod_cta_ctbl THEN
                        ASSIGN de-valor = movct-tr.vl-movimento.
                    ELSE 
                        ASSIGN de-valor = movct-tr.vl-movimento * -1.

                    FIND FIRST emitente NO-LOCK 
                         WHERE emitente.cgc = movct-tr.cnpj-emissor NO-ERROR.

                    ASSIGN l-achou = YES.
                    CREATE tt-dados2.
                    ASSIGN tt-dados2.codigo                = conciliacao-contas.codigo
                           tt-dados2.cod_estab             = movct-tr.cod-estabel
                           tt-dados2.origem                = "TMS"
                           tt-dados2.ind_natur_lancto_ctbl = "CR"
                           tt-dados2.cod_emitente          = IF AVAIL emitente THEN emitente.cod-emitente ELSE 0
                           tt-dados2.nome_emitente         = IF AVAIL emitente THEN emitente.nome-emit ELSE ""
                           tt-dados2.dt_transacao          = movct-tr.dt-movimento
                           /*tt-dados2.cod_espec_docto       = string(movct-tr.esp-docto)*/
                           tt-dados2.cod_ser_docto         = fatura-docto-frete.serie
                           tt-dados2.cod_tit_ap            = fatura-docto-frete.nr-fatura
                           tt-dados2.cod_parcela           = STRING(movct-tr.nr-docto)
                           tt-dados2.val_aprop_ctbl        = de-valor
                           tt-dados2.cod_cta_ctbl          = p_cod_cta_ctbl.

                    IF movct-tr.conta-debito BEGINS p_cod_cta_ctbl THEN
                        ASSIGN tt-dados2.cod_ccusto            = SUBSTRING(movct-tr.conta-debito, 12, 5)
                                tt-dados2.cod_unid_negoc        = SUBSTRING(movct-tr.conta-debito, 9, 3).
                    ELSE
                        ASSIGN tt-dados2.cod_ccusto            = SUBSTRING(movct-tr.conta-credito, 12, 5)
                               tt-dados2.cod_unid_negoc        = SUBSTRING(movct-tr.conta-credito, 9, 3).

                    IF tt-dados2.cod_unid_negoc <> "" THEN DO:
                        FIND FIRST unid_negoc NO-LOCK
                             WHERE unid_negoc.cdn_unid_negoc = INT(tt-dados2.cod_unid_negoc) NO-ERROR.
                        IF AVAIL unid_negoc 
                            THEN ASSIGN tt-dados2.cod_unid_negoc = unid_negoc.cod_unid_negoc.
                    END.

                    assign tt-dados2.des_lancto            = movct-tr.ds-historico-movto
                           tt-dados2.erro                  = "Contabilizado pelo TMS."
                           tt-dados2.cod_usuar_ult_atualiz = "".

                    RUN pi-totaliza-contas.
                END.

                IF NOT l-achou AND docto-frete.dt-emissao-docto < tt-param.data-ini AND DAY(tt-param.data-ini) = 1 THEN DO:
                    FIND FIRST b-emitente NO-LOCK
                         WHERE b-emitente.cgc = docto-frete.cnpj-emit NO-ERROR.
                    IF AVAIL b-emitente THEN DO:
                        FOR EACH movto-estoq NO-LOCK
                           WHERE movto-estoq.cod-estabel = docto-frete.cod-estabel
                             AND movto-estoq.dt-criacao  = docto-frete.dt-liberacao
                             AND movto-estoq.dt-trans   <= tt-param.data-ini
                             AND movto-estoq.nro-docto   = STRING(INT(docto-frete.nr-documento),"9999999")
                             AND movto-estoq.serie-docto = docto-frete.serie
                             AND movto-estoq.cod-emitente = b-emitente.cod-emitente
                             AND movto-estoq.conta-contab BEGINS p_cod_cta_ctbl :

                            /*/* ** Limitaá∆o na localizaá∆o dos valores no EMS2, que est∆o em bases separadas por empresa ***/
                            IF  movto-estoq.cod-estabel <> "101"
                            AND movto-estoq.cod-estabel <> "102"
                            AND movto-estoq.cod-estabel <> "105"
                                THEN NEXT.*/

                            ASSIGN de-valor = (movto-estoq.valor-mat-m[1]               +
                                               movto-estoq.valor-mob-m[1]               +
                                               movto-estoq.valor-ggf-m[1]               +
                                               movto-estoq.valor-icm                    +
                                               movto-estoq.valor-ipi                    +
                                               movto-estoq.valor-iss                    +
                                               movto-estoq.valor-pis                    +
                                               movto-estoq.val-cofins).

                            CREATE tt-dados2.
                            ASSIGN tt-dados2.codigo                 = conciliacao-contas.codigo
                                   tt-dados2.cod_estab             = movto-estoq.cod-estabel
                                   tt-dados2.origem                = "CEP"
                                   tt-dados2.ind_natur_lancto_ctbl = IF movto-estoq.tipo-trans = 1 THEN "CR" ELSE "DB"
                                   tt-dados2.cod_emitente          = movto-estoq.cod-emitente
                                   tt-dados2.dt_transacao          = movto-estoq.dt-trans
                                   tt-dados2.cod_espec_docto       = string(movto-estoq.esp-docto)
                                   tt-dados2.cod_ser_docto         = movto-estoq.serie
                                   tt-dados2.cod_tit_ap            = string(movto-estoq.nro-docto)
                                   tt-dados2.cod_parcela           = "0"
                                   tt-dados2.val_aprop_ctbl        = (movto-estoq.valor-mat-m[1]               +
                                                                      movto-estoq.valor-mob-m[1]               +
                                                                      movto-estoq.valor-ggf-m[1]               +
                                                                      movto-estoq.valor-icm                    +
                                                                      movto-estoq.valor-ipi                    +
                                                                      movto-estoq.valor-iss                    +
                                                                      movto-estoq.valor-pis                    +   /* PIS */
                                                                      movto-estoq.val-cofins   /* COFINS */ ) * (IF tt-dados2.ind_natur_lancto_ctbl = "DB" THEN 1 ELSE -1)
                                   tt-dados2.cod_cta_ctbl          = p_cod_cta_ctbl
                                   tt-dados2.cod_ccusto            = SUBSTRING(movto-estoq.sc-codigo, 4, 5)
                                   tt-dados2.cod_unid_negoc        = SUBSTRING(movto-estoq.sc-codigo, 1, 3)
                                   tt-dados2.natureza              = movto-estoq.nat-operacao 
                                   tt-dados2.cod_usuar_ult_atualiz = movto-estoq.usuario.

                            IF tt-dados2.cod_unid_negoc <> "" 
                            THEN DO:
                                 FIND unid_negoc NO-LOCK
                                    WHERE unid_negoc.cdn_unid_negoc = INT(tt-dados2.cod_unid_negoc) NO-ERROR.
                                 IF AVAIL unid_negoc 
                                    THEN ASSIGN tt-dados2.cod_unid_negoc = unid_negoc.cod_unid_negoc.
                            END.

                            IF tt-dados2.val_aprop_ctbl = 0 
                            THEN DO:
                                 find item-estab no-lock
                                      where item-estab.cod-estabel = movto-estoq.cod-estabel
                                        and item-estab.it-codigo   = movto-estoq.it-codigo no-error.

                                 if avail item-estab then
                                     assign tt-dados2.val_aprop_ctbl = (movto-estoq.quantidade * 
                                                                     (item-estab.val-unit-mat-m[1]
                                                                     + item-estab.val-unit-mob-m[1]
                                                                     + item-estab.val-unit-ggf-m[1] )) * (IF tt-dados2.ind_natur_lancto_ctbl = "DB" THEN 1 ELSE -1).
                            END.

                            FIND ITEM NO-LOCK WHERE ITEM.it-codigo = movto-estoq.it-codigo.
                            IF tt-dados2.cod_emitente <> 0 THEN DO:
                                 FIND emitente NO-LOCK WHERE emitente.cod-emitente = tt-dados2.cod_emitente NO-ERROR.
                                 IF AVAIL emitente 
                                    THEN ASSIGN tt-dados2.nome_emitente = emitente.nome-emit.
                            END.
                            ELSE ASSIGN tt-dados2.nome_emitente = item.it-codigo + " " + movto-estoq.usuario.

                            ASSIGN tt-dados2.cod_tit_ap     = fatura-docto-frete.nr-fatura
                                   tt-dados2.cod_ser_docto  = fatura-docto-frete.serie
                                   tt-dados2.cod_parcela    = movto-estoq.nro-docto
                                   tt-dados2.nr-fatura      = fatura-docto-frete.nr-fatura
                                   tt-dados2.serie-fat      = fatura-docto-frete.serie-fat 
                                   tt-dados2.cgc-transp     = fatura-docto-frete.cgc-transp.

                            ASSIGN tt-dados2.erro = "TMS - contabilizado pelo CEP - Contabilizado antes periodo.".

                            RUN pi-totaliza-contas.
                        END.
                    END.
                END.
            END.
       END.*/
   END.

   run pi-acompanhar in h-acomp (INPUT "Movimentos Estoque - CEP").
   /* ** Movimentos Estoque - CEP ***/
   DO i-data = tt-param.data-ini TO tt-param.data-fim:
       FOR EACH movto-estoq FIELDS (dt-trans esp-docto usuario serie-docto it-codigo quantidade nro-docto 
                                    valor-mob-m valor-ggf-m cod-emitente tipo-trans ct-codigo valor-mat-m cod-estabel descricao-db
                                    nat-operacao sequen-nf sc-codigo valor-icm valor-ipi valor-iss char-1 movto-estoq.valor-pis movto-estoq.val-cofins cod-unid-negoc) NO-LOCK /*USE-INDEX data-conta*/
          WHERE movto-estoq.dt-trans  = i-data
            AND movto-estoq.ct-codigo = p_cod_cta_ctbl:
 
            /*/* ** Limitaá∆o na localizaá∆o dos valores no EMS2, que est∆o em bases separadas por empresa ***/
            IF  movto-estoq.cod-estabel <> "101"
            AND movto-estoq.cod-estabel <> "102"
            AND movto-estoq.cod-estabel <> "105"
                THEN NEXT.*/
            
            ASSIGN de-valor = (movto-estoq.valor-mat-m[1]               +
                               movto-estoq.valor-mob-m[1]               +
                               movto-estoq.valor-ggf-m[1]               +
                               movto-estoq.valor-icm                    +
                               movto-estoq.valor-ipi                    +
                               movto-estoq.valor-iss                    +
                               movto-estoq.valor-pis                    +
                               movto-estoq.val-cofins).

            CREATE tt-dados2.
            ASSIGN tt-dados2.codigo                = conciliacao-contas.codigo
                   tt-dados2.cod_estab             = movto-estoq.cod-estabel
                   tt-dados2.origem                = "CEP"
                   tt-dados2.ind_natur_lancto_ctbl = IF movto-estoq.tipo-trans = 1 THEN "CR" ELSE "DB"
                   tt-dados2.cod_emitente          = movto-estoq.cod-emitente
                   tt-dados2.dt_transacao          = movto-estoq.dt-trans
                   tt-dados2.cod_espec_docto       = string(movto-estoq.esp-docto)
                   tt-dados2.cod_ser_docto         = movto-estoq.serie
                   tt-dados2.cod_tit_ap            = string(movto-estoq.nro-docto)
                   tt-dados2.cod_parcela           = "0"
                   tt-dados2.val_aprop_ctbl        = (movto-estoq.valor-mat-m[1]               +
                                                      movto-estoq.valor-mob-m[1]               +
                                                      movto-estoq.valor-ggf-m[1]               +
                                                      movto-estoq.valor-icm                    +
                                                      movto-estoq.valor-ipi                    +
                                                      movto-estoq.valor-iss                    +
                                                      movto-estoq.valor-pis                    +   /* PIS */
                                                      movto-estoq.val-cofins   /* COFINS */ ) * (IF tt-dados2.ind_natur_lancto_ctbl = "DB" THEN 1 ELSE -1)
                   tt-dados2.cod_cta_ctbl          = p_cod_cta_ctbl
                   tt-dados2.cod_ccusto            = movto-estoq.sc-codigo
                   tt-dados2.cod_unid_negoc        = movto-estoq.cod-unid-negoc
                   tt-dados2.natureza              = movto-estoq.nat-operacao
                   tt-dados2.cod_usuar_ult_atualiz = movto-estoq.usuario.

            IF tt-dados2.cod_espec_docto = "18" OR  tt-dados2.cod_espec_docto = "14" THEN DO:
                FOR EACH despesa-aces NO-LOCK
                   WHERE despesa-aces.serie-docto  = movto-estoq.serie-docto
                     AND despesa-aces.nro-docto    = movto-estoq.nro-docto
                     AND despesa-aces.cod-emitente = movto-estoq.cod-emitente
                     AND despesa-aces.nat-operacao = movto-estoq.nat-operacao:

                    ASSIGN tt-dados2.cod_emitente = despesa-aces.cod-forn-ac
                           tt-dados2.cod_tit_ap   = despesa-aces.nro-docto-ac
                           tt-dados2.cod_parcela  = string(movto-estoq.nro-docto)
                           tt-dados2.erro         = "Despesas acessorias".
                END.
            END.
            
            IF p_cod_cta_ctbl = "11910005" THEN DO:
                FIND FIRST docum-est OF movto-estoq NO-LOCK NO-ERROR.

                IF  AVAIL docum-est
                AND docum-est.esp-docto = 21 
                THEN DO:
                    FIND FIRST b-emitente NO-LOCK
                         WHERE b-emitente.cod-emitente = movto-estoq.cod-emitente NO-ERROR.
                    IF AVAIL b-emitente THEN DO:
                        ASSIGN l-achou = NO.
                        /* TMS FOR FIRST fatura-docto-frete NO-LOCK
                            WHERE fatura-docto-frete.id-tp-docto  = 1
                              AND fatura-docto-frete.cnpj-emit        = b-emitente.cgc
                              AND fatura-docto-frete.serie            = movto-estoq.serie-docto
                              AND fatura-docto-frete.nr-documento     = STRING(INT(movto-estoq.nro-docto)):
                            ASSIGN l-achou = YES
                                   tt-dados2.cod_tit_ap     = fatura-docto-frete.nr-fatura
                                   tt-dados2.cod_ser_docto  = fatura-docto-frete.serie
                                   tt-dados2.cod_parcela    = movto-estoq.nro-docto
                                   tt-dados2.nr-fatura      = fatura-docto-frete.nr-fatura
                                   tt-dados2.serie-fat      = fatura-docto-frete.serie-fat 
                                   tt-dados2.cgc-transp     = fatura-docto-frete.cgc-transp
                                   tt-dados2.erro           = "TMS - contabilizado pelo CEP".
                        END.*/

                        IF NOT l-achou THEN
                            ASSIGN tt-dados2.erro = "Frete sem fatura".
                    END.
                END.

                IF movto-estoq.nat-operacao = "235203" THEN
                    ASSIGN tt-dados2.erro = tt-dados2.erro + " - Lancamento em conta corrente errada".

            END.

            IF tt-dados2.cod_unid_negoc <> "" 
            THEN DO:
                 FIND unid_negoc NO-LOCK
                    WHERE unid_negoc.cdn_unid_negoc = INT(tt-dados2.cod_unid_negoc) NO-ERROR.
                 IF AVAIL unid_negoc 
                    THEN ASSIGN tt-dados2.cod_unid_negoc = unid_negoc.cod_unid_negoc.
            END.

            IF tt-dados2.val_aprop_ctbl = 0 AND p_cod_cta_ctbl <> "11810010" THEN DO:
                 find item-estab no-lock
                      where item-estab.cod-estabel = movto-estoq.cod-estabel
                        and item-estab.it-codigo   = movto-estoq.it-codigo no-error.

                 if avail item-estab then
                     assign tt-dados2.val_aprop_ctbl = (movto-estoq.quantidade * 
                                                     (item-estab.val-unit-mat-m[1]
                                                     + item-estab.val-unit-mob-m[1]
                                                     + item-estab.val-unit-ggf-m[1] )) * (IF tt-dados2.ind_natur_lancto_ctbl = "DB" THEN 1 ELSE -1).
            END.

            FIND ITEM NO-LOCK WHERE ITEM.it-codigo = movto-estoq.it-codigo.
            IF tt-dados2.cod_emitente <> 0 THEN DO:
                 FIND emitente NO-LOCK WHERE emitente.cod-emitente = tt-dados2.cod_emitente NO-ERROR.
                 IF AVAIL emitente 
                    THEN ASSIGN tt-dados2.nome_emitente = emitente.nome-emit.
            END.
            ELSE ASSIGN tt-dados2.nome_emitente = item.it-codigo + " " + movto-estoq.usuario.

            find item-doc-est no-lock
                 where item-doc-est.serie-docto  = movto-estoq.serie-docto
                   and item-doc-est.nro-docto    = movto-estoq.nro-docto
                   and item-doc-est.cod-emitente = movto-estoq.cod-emitente
                   and item-doc-est.nat-operacao = movto-estoq.nat-operacao
                   and item-doc-est.sequencia    = movto-estoq.sequen-nf no-error.
            if avail item-doc-est
                then assign tt-dados2.nome_emitente = tt-dados2.nome_emitente
                            tt-dados2.des_lancto    = item-doc-est.narrativa.
            
            RUN pi-totaliza-contas.
       END.
   END.

   run pi-acompanhar in h-acomp (INPUT "Movimentos Estoque - CEP").



END.

PROCEDURE pi-valida-cc-uni-estab:
    DEFINE INPUT PARAMETER p_cod_estabel    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p_cod_custo      AS CHARACTER NO-UNDO. /*so 5 posicoes*/ 
    DEFINE INPUT PARAMETER p_cod_unid_negoc AS CHARACTER NO-UNDO. /*unidade ems5 */

    DEFINE VARIABLE l-erro-valida AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-unidades    AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE c-erro AS CHARACTER FORMAT "x(200)"  NO-UNDO.

    DEFINE BUFFER b_cc_uni_estab FOR cc_uni_estab.

    ASSIGN c-unidades = "".
    FIND FIRST cc_uni_estab NO-LOCK
         WHERE cc_uni_estab.cod_ccusto     = p_cod_custo 
           AND cc_uni_estab.cod_unid_negoc = p_cod_unid_negoc NO-ERROR.
    IF NOT AVAIL cc_uni_estab THEN DO:
        RETURN "Centro Custo: " + p_cod_custo + " nao cadastrado na tabela cc_uni_estab".
    END.
    ELSE DO:
        FIND FIRST cc_uni_estab NO-LOCK
             WHERE cc_uni_estab.cc_codigo      = p_cod_custo 
               AND cc_uni_estab.cod_unid_negoc = p_cod_unid_negoc NO-ERROR.
        IF AVAIL cc_uni_estab THEN DO:
            FIND FIRST b_cc_uni_estab NO-LOCK 
                 WHERE b_cc_uni_estab.cc_codigo      = cc_uni_estab.cc_codigo
                   AND b_cc_uni_estab.cod_estab      = p_cod_estabel
                   AND b_cc_uni_estab.cod_unid_negoc = p_cod_unid_negoc  NO-ERROR.
            IF NOT AVAIL b_cc_uni_estab THEN
                RETURN "Centro Custo: " + p_cod_custo + " nao pode ser utilizado no estabelecimento " + p_cod_estabel + ".".
        END.
        ELSE DO:
            ASSIGN l-erro-valida = YES.
            IF NOT CAN-FIND(FIRST cc_uni_estab NO-LOCK
                            WHERE cc_uni_estab.cod_ccusto     = p_cod_custo
                              AND cc_uni_estab.cod_estab      = p_cod_estabel
                              AND cc_uni_estab.cod_unid_negoc = p_cod_unid_negoc ) THEN DO:
                RETURN "Centro Custo: " + p_cod_custo + " nao pode ser utilizado no estabelecimento " + p_cod_estabel + ".".
            END.
            ELSE DO:
                FOR EACH cc_uni_estab NO-LOCK
                   WHERE cc_uni_estab.cod_ccusto   = p_cod_custo
                     AND cc_uni_estab.cod_estab    = p_cod_estabel:
                    IF cc_uni_estab.cod_unid_negoc = p_cod_unid_negoc THEN
                        ASSIGN l-erro-valida = NO.

                    IF c-unidades = "" THEN
                        ASSIGN c-unidades = cc_uni_estab.cod_unid_negoc.
                    ELSE
                        ASSIGN c-unidades = "," + cc_uni_estab.cod_unid_negoc.
                END.
                IF l-erro-valida THEN
                    RETURN "C.Custo: " + p_cod_custo + " p/ estab: " + p_cod_estabel + " so pode ser usado nas unidades: " + c-unidades + ".".
            END.
        END.
    END.

    RETURN "".
END PROCEDURE.

PROCEDURE pi-envia-email:

    IF tt-param.lista-email <> "" THEN DO:
        RUN pi-inicializar in h-acomp (input "Enviando Email...").

        FIND FIRST param-global NO-LOCK.

        create tt-envio.
        assign tt-envio.versao-integracao = 1
               tt-envio.exchange          = param-global.log-1
               tt-envio.porta             = param-global.porta-mail
               tt-envio.servidor          = param-global.serv-mail 
               tt-envio.destino           = tt-param.lista-email
               tt-envio.remetente         = "ems@intelbras.com.br"
               tt-envio.assunto           = "Inconsistencias C.Custo e Contas Transitorias - " + STRING(TODAY,"99/99/9999")
               tt-envio.mensagem          = "Segue anexo relatorio das inconsitencias de centro de custo e conciliaá∆o das contas transit¢rias. Favor verificar!" + CHR(10) + tt-param.arquivo
               tt-envio.importancia       = 2
               tt-envio.log-enviada       = no
               tt-envio.log-lida          = no
               tt-envio.acomp             = no.

         IF tt-param.destino = 3 THEN /* Terminal */   
             ASSIGN tt-envio.arq-anexo = IF SEARCH(tt-param.arquivo) <> ? THEN tt-param.arquivo ELSE SESSION:TEMP-DIRECTORY + "ES0951.txt".
         ELSE
             ASSIGN tt-envio.arq-anexo = IF SEARCH(tt-param.arquivo) <> ? THEN tt-param.arquivo ELSE SESSION:TEMP-DIRECTORY + tt-param.arquivo.

         run utp/utapi009.p ( input  table tt-envio,
                              output  table tt-erros).

         IF CAN-FIND(FIRST tt-erros) THEN DO:
             OUTPUT TO VALUE(tt-param.arquivo) APPEND.
             PUT UNFORMATTED
                 SKIP(2)
                 "Erro    Descricao                                                        " AT 01
                 "------- -----------------------------------------------------------------" AT 01 SKIP.
             FOR EACH tt-erros:
                 PUT UNFORMATTED 
                      tt-erros.cod-erro  AT 01
                      tt-erros.desc-erro AT 09 SKIP.
             END.
             PUT UNFORMATTED SKIP(2).
             OUTPUT CLOSE.
         END.
    END.

END PROCEDURE.

PROCEDURE pi-totaliza-contas:
    DEFINE VARIABLE c-documento AS CHARACTER   NO-UNDO.

    ASSIGN c-documento = IF cta_ctbl.cod_cta_ctbl = "11910100" THEN tt-dados2.nome_emitente ELSE tt-dados2.cod_tit_ap.

    FIND FIRST tt-total NO-LOCK
         WHERE tt-total.codigo       = tt-dados2.codigo
           AND tt-total.cod_cta_ctbl = tt-dados2.cod_cta_ctbl 
           AND tt-total.ident        = 1
           AND tt-total.cod_tit_ap   = c-documento
           AND tt-total.origem       = tt-dados2.origem NO-ERROR.
    IF NOT AVAIL tt-total THEN DO:
        CREATE tt-total.
        ASSIGN tt-total.codigo       = tt-dados2.codigo
               tt-total.cod_cta_ctbl = tt-dados2.cod_cta_ctbl
               tt-total.ident        = 1
               tt-total.cod_tit_ap   = c-documento
               tt-total.origem       = tt-dados2.origem
               tt-total.desc-conta   = cta_ctbl.des_tit_ctbl.
    END.
    ASSIGN tt-total.val_aprop_ctbl = tt-total.val_aprop_ctbl + tt-dados2.val_aprop_ctbl.
    RELEASE tt-total.

    FIND FIRST tt-total NO-LOCK
         WHERE tt-total.codigo       = tt-dados2.codigo
           AND tt-total.cod_cta_ctbl = tt-dados2.cod_cta_ctbl
           AND tt-total.ident        = 2
           AND tt-total.cod_tit_ap   = c-documento
           AND tt-total.origem       = "DIF" NO-ERROR.
    IF NOT AVAIL tt-total THEN DO:
        CREATE tt-total.
        ASSIGN tt-total.codigo       = tt-dados2.codigo
               tt-total.cod_cta_ctbl = tt-dados2.cod_cta_ctbl
               tt-total.ident        = 2
               tt-total.cod_tit_ap   = c-documento
               tt-total.origem       = "DIF"
               tt-total.desc-conta   = cta_ctbl.des_tit_ctbl.
    END.
    ASSIGN tt-total.val_aprop_ctbl = tt-total.val_aprop_ctbl + tt-dados2.val_aprop_ctbl.
    RELEASE tt-total.

    FIND FIRST tt-total NO-LOCK
         WHERE tt-total.codigo       = tt-dados2.codigo
           AND tt-total.cod_cta_ctbl = tt-dados2.cod_cta_ctbl
           AND tt-total.ident        = 3
           AND tt-total.origem       = "TOT" NO-ERROR.
    IF NOT AVAIL tt-total THEN DO:
        CREATE tt-total.
        ASSIGN tt-total.codigo       = tt-dados2.codigo
               tt-total.cod_cta_ctbl = tt-dados2.cod_cta_ctbl
               tt-total.ident        = 3
               tt-total.origem       = "TOT"
               tt-total.desc-conta   = cta_ctbl.des_tit_ctbl.
    END.
    ASSIGN tt-total.val_aprop_ctbl = tt-total.val_aprop_ctbl + tt-dados2.val_aprop_ctbl.
    RELEASE tt-total.
END PROCEDURE.


PROCEDURE pi_concil_cmg:

    DEFINE VARIABLE v_data                       AS DATE        NO-UNDO.
    DEFINE VARIABLE v_tot                        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_dif                        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_ind_fluxo_movto_cta_corren AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_cod_valor                  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_num_cont                   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_val_aprop_ctbl_histor      AS DECIMAL     NO-UNDO.
  
    DEF BUFFER b_movto_cta_corren FOR movto_cta_corren.
    
    PUT UNFORMATTED "Diferenáa CMG x Origem;"
                    SKIP    "Cta Corrente;Data;Seq;Origem;Total Origem;Total CMG" SKIP.
    
    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa = '1':
    
        DO v_data = tt-param.data-ini TO tt-param.data-fim:
        
            FOR EACH cta_corren NO-LOCK
                WHERE cta_corren.cod_estab = estabelecimento.cod_estab:
          
                FOR EACH movto_cta_corren NO-LOCK
                    WHERE movto_cta_corren.cod_cta_corren            = cta_corren.cod_cta_corren
                      AND movto_cta_corren.dat_movto_cta_corren      = v_data:
                
                    IF movto_cta_corren.cod_modul_dtsul = "CMG"
                    THEN DO:
                         FOR EACH aprop_ctbl_cmg NO-LOCK
                             WHERE aprop_ctbl_cmg.num_id_movto_cta_corren = movto_cta_corren.num_id_movto_cta_corren
                               AND aprop_ctbl_cmg.ind_natur = "DB":
                             ASSIGN v_tot = v_tot + aprop_ctbl_cmg.val_movto.
                         END.
                         IF v_tot <> movto_cta_corren.val_movto
                         THEN DO: 
                              ASSIGN v_dif = v_dif + (v_tot - movto_cta_corren.val_movto).
                              PUT UNFORMATTED movto_cta_corren.cod_cta_corren ";" movto_cta_corren.dat_movto_cta_corren ";" movto_cta_corren.num_seq ";" movto_cta_corren.cod_modul_dtsul ";" v_tot ";" movto_cta_corren.val_movto SKIP.
                         END.
                         ASSIGN v_tot = 0.
                    END.
              
                    IF movto_cta_corren.cod_modul_dtsul = "APB"
                    THEN DO:
                         FOR EACH movto_tit_ap NO-LOCK 
                             WHERE movto_tit_ap.num_id_movto_cta_corren = movto_cta_corren.num_id_movto_cta_corren:
                             FIND FIRST compl_movto_pagto NO-LOCK 
                                  WHERE compl_movto_pagto.cod_estab           = movto_tit_ap.cod_estab
                                    AND compl_movto_pagto.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap NO-ERROR.
                             IF AVAIL compl_movto_pagto 
                                THEN ASSIGN v_tot = v_tot + compl_movto_pagto.val_movto_ap 
                                                          + compl_movto_pagto.val_juros
                                                          + compl_movto_pagto.val_multa_tit_ap 
                                                          + compl_movto_pagto.val_cm_tit_ap 
                                                          - compl_movto_pagto.val_abat_tit_ap 
                                                          - compl_movto_pagto.val_desconto.
                                ELSE ASSIGN v_tot = v_tot + movto_tit_ap.val_movto_ap 
                                                          + movto_tit_ap.val_juros
                                                          + movto_tit_ap.val_multa_tit_ap 
                                                          + movto_tit_ap.val_cm_tit_ap
                                                          - movto_tit_ap.val_abat_tit_ap 
                                                          - movto_tit_ap.val_desconto. 
                         END.
                         IF v_tot <> movto_cta_corren.val_movto
                         THEN DO:
                              ASSIGN v_dif = v_dif + (v_tot - movto_cta_corren.val_movto).
                              PUT UNFORMATTED movto_cta_corren.cod_cta_corren ";" movto_cta_corren.dat_movto_cta_corren ";" movto_cta_corren.num_seq ";" movto_cta_corren.cod_modul_dtsul ";" v_tot ";" movto_cta_corren.val_movto SKIP.
                         END.
                         ASSIGN v_tot = 0.
                    END.
                
                    IF movto_cta_corren.cod_modul_dtsul = "ACR"
                    THEN DO:

                         /* ** Verifica valores de imposto e despesa ***/
                         FOR EACH b_movto_cta_corren NO-LOCK 
                             WHERE b_movto_cta_corren.num_id_movto_cta_impto = movto_cta_corren.num_id_movto_cta_corren,
                              EACH movto_tit_acr NO-LOCK 
                             WHERE movto_tit_acr.num_id_movto_cta_corren = b_movto_cta_corren.num_id_movto_cta_corren:
    
                              FIND compl_movto_tit_acr NO-LOCK
                                   WHERE compl_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                                     AND compl_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.
                              IF AVAIL compl_movto_tit_acr THEN 
                                 ASSIGN v_tot = v_tot + compl_movto_tit_acr.val_impto_retid.
                              ELSE DO:
                                   FIND aprop_ctbl_acr OF movto_tit_acr NO-LOCK
                                      WHERE aprop_ctbl_acr.ind_natur_lancto = "DB"
                                        AND aprop_ctbl_acr.ind_tip_aprop    = "Impto Operac Financ" NO-ERROR.
                                   IF AVAIL aprop_ctbl_acr 
                                      THEN ASSIGN v_tot = v_tot + aprop_ctbl_acr.val_aprop_ctbl.
                              END.

                         END.
    
                         FOR EACH b_movto_cta_corren NO-LOCK 
                             WHERE b_movto_cta_corren.cod_cta_corren           = movto_cta_corren.cod_cta_corren
                               AND b_movto_cta_corren.dat_movto_cta_corren     = movto_cta_corren.dat_movto_cta_corren
                               AND b_movto_cta_corren.num_id_movto_despes_bcia = movto_cta_corren.num_id_movto_cta_corren,
                              EACH movto_tit_acr NO-LOCK 
                             WHERE movto_tit_acr.num_id_movto_cta_corren = b_movto_cta_corren.num_id_movto_cta_corren:
    
                              FIND compl_movto_tit_acr NO-LOCK
                                   WHERE compl_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                                     AND compl_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.
                              IF AVAIL compl_movto_tit_acr 
                                 THEN ASSIGN v_tot = v_tot + compl_movto_tit_acr.val_despes_bcia.
                                 ELSE ASSIGN v_tot = v_tot + movto_tit_acr.val_despes_bcia.
                         END.


                         FOR EACH movto_tit_acr NO-LOCK 
                             WHERE movto_tit_acr.num_id_movto_cta_corren = movto_cta_corren.num_id_movto_cta_corren:
                             FIND FIRST compl_movto_tit_acr NO-LOCK
                                  WHERE compl_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                                    AND compl_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.
                             IF AVAIL compl_movto_tit_acr 
                                THEN ASSIGN v_tot = v_tot + compl_movto_tit_acr.val_movto_tit_acr 
                                                          + compl_movto_tit_acr.val_juros 
                                                          + compl_movto_tit_acr.val_multa_tit_acr
                                                          + compl_movto_tit_acr.val_cm_tit_acr
                                                          - compl_movto_tit_acr.val_desc
                                                          - compl_movto_tit_acr.val_despes_bcia 
                                                          - compl_movto_tit_acr.val_abat_tit_acr.
                                ELSE ASSIGN v_tot = v_tot + movto_tit_acr.val_movto_tit_acr
                                                          + movto_tit_acr.val_juros
                                                          + movto_tit_acr.val_multa_tit_acr
                                                          + movto_tit_acr.val_cm_tit_acr
                                                          - movto_tit_acr.val_desconto
                                                          - movto_tit_acr.val_abat_tit_acr
                                                          - movto_tit_acr.val_despes_bcia.


                           IF movto_tit_acr.ind_trans_acr = "Estorno Desconto Bancario" 
                           OR movto_tit_acr.ind_trans_acr = "Desconto Bancario"
                              THEN ASSIGN v_tot = v_tot + movto_tit_acr.val_despes_bcia.
/*                           IF movto_tit_acr.ind_trans_acr = "Desconto Bancario" 
                              THEN ASSIGN v_tot = v_tot - movto_tit_acr.val_despes_bcia.
*/                              

                           /* ** Comiss∆o SCO ***/
                           FIND movto_comis_repres NO-LOCK
                              WHERE movto_comis_repres.cod_estab            = movto_tit_acr.cod_estab
                                AND movto_comis_repres.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr                                          
                                AND movto_comis_repres.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.
                           IF AVAIL movto_comis_repres 
                           THEN DO: 
                                ASSIGN v_tot = v_tot - movto_comis_repres.val_movto_comis.
                           END.
                           ELSE DO:
                                FIND aprop_ctbl_acr OF movto_tit_acr NO-LOCK
                                   WHERE aprop_ctbl_acr.ind_natur_lancto = "DB"
                                     AND aprop_ctbl_acr.ind_tip_aprop    = "Comiss∆o Retida" NO-ERROR.
                                IF AVAIL aprop_ctbl_acr 
                                   THEN ASSIGN v_tot = v_tot - aprop_ctbl_acr.val_aprop_ctbl.
                           END.
                                
                           /* ** Tratamento Vendor ***/
                           FIND tit_acr NO-LOCK OF movto_tit_acr NO-ERROR.
                           IF (tit_acr.ind_tip_espec_docto = "Vendor"
                           OR (CAN-FIND(FIRST cart_bcia NO-LOCK
                                        WHERE cart_bcia.cod_cart_bcia     = tit_acr.cod_cart_bcia
                                          AND cart_bcia.ind_tip_cart_bcia = "Vendor")))
                           AND (movto_tit_acr.ind_trans_acr     = "Acerto Valor a Maior"
                           OR   movto_tit_acr.ind_trans_acr     = "Acerto Valor a Menor")
                           AND  movto_tit_acr.val_movto_tit_acr = 0 
                           THEN DO:

                                FIND LAST histor_movto_tit_acr NO-LOCK
                                    WHERE histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                                      AND histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
                                      AND histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                                      AND histor_movto_tit_acr.ind_orig_histor_acr <> "Erro" NO-ERROR.
                                IF  AVAIL histor_movto_tit_acr
                                AND TRIM(SUBSTR(histor_movto_tit_acr.des_text_histor,1,5)) <> "EDIOF"
                                AND TRIM(SUBSTR(histor_movto_tit_acr.des_text_histor,1,5)) <> "IOFCL"
                                /* Os movimentos de Provis∆o gerados pelo Fechamento Mensal Vendor s∆o do tipo N∆o Realizado */
                                AND TRIM(SUBSTR(histor_movto_tit_acr.des_text_histor,1,5)) <> "DPIOF"
                                AND TRIM(SUBSTR(histor_movto_tit_acr.des_text_histor,1,5)) <> "DPEQV"
                                AND TRIM(SUBSTR(histor_movto_tit_acr.des_text_histor,1,5)) <> "RPEQV"
                                THEN DO:
                                
                                    IF TRIM(SUBSTR(histor_movto_tit_acr.des_text_histor,1,5)) = "DIOF"
                                    THEN DO:  
                                         ASSIGN v_ind_fluxo_movto_cta_corren = "SAI".
                                    END.
                                    ELSE DO:
                                         IF movto_tit_acr.ind_trans_acr = "Acerto Valor a Maior"
                                            THEN ASSIGN v_ind_fluxo_movto_cta_corren = "ENT".
                                            ELSE ASSIGN v_ind_fluxo_movto_cta_corren = "SAI".
                                    END.
                                
                                    ASSIGN v_cod_valor = "0".
                                
                                    /* Busca o valor da apropriaá∆o do hist¢rico do movimento */
                                    DO v_num_cont = 1 TO LENGTH(histor_movto_tit_acr.des_text_histor):
                                        IF CAN-DO('0,1,2,3,4,5,6,7,8,9',SUBSTR(histor_movto_tit_acr.des_text_histor,v_num_cont,1)) 
                                        THEN DO:
                                             ASSIGN v_cod_valor = v_cod_valor + SUBSTR(histor_movto_tit_acr.des_text_histor,v_num_cont,1).
                                        END.
                                        ELSE DO:
                                             IF  v_cod_valor <> ""
                                             AND (SUBSTR(histor_movto_tit_acr.des_text_histor,v_num_cont,1) = '.'
                                              OR  SUBSTR(histor_movto_tit_acr.des_text_histor,v_num_cont,1) = ',') 
                                             THEN ASSIGN v_cod_valor = v_cod_valor + SUBSTR(histor_movto_tit_acr.des_text_histor,v_num_cont,1).
                                
                                             IF SUBSTR(histor_movto_tit_acr.des_text_histor,v_num_cont,1) = "G"
                                             OR SUBSTR(histor_movto_tit_acr.des_text_histor,v_num_cont,4) = "Taxa" 
                                             THEN DO:
                                                  ASSIGN v_val_aprop_ctbl_histor = DEC(SUBSTR(v_cod_valor,1,LENGTH(v_cod_valor)- 1)).
                                                  LEAVE.
                                             END.
                                        END.
                                    END.
    
                                    ASSIGN v_tot = v_tot + v_val_aprop_ctbl_histor.

                                END.

                           END.

                         END.

                         IF v_tot <> movto_cta_corren.val_movto
                         THEN DO:
                              ASSIGN v_dif = v_dif + (v_tot - movto_cta_corren.val_movto).
                              PUT UNFORMATTED movto_cta_corren.cod_cta_corren ";" movto_cta_corren.dat_movto_cta_corren ";" movto_cta_corren.num_seq ";" movto_cta_corren.cod_modul_dtsul ";" v_tot ";" movto_cta_corren.val_movto SKIP.
                         END.
                         ASSIGN v_tot = 0.
                    END.
    
                    IF movto_cta_corren.cod_modul_dtsul = "APL"
                    THEN DO:
                         FIND FIRST movto_operac_financ NO-LOCK 
                              WHERE movto_operac_financ.num_id_movto_cta_corren = movto_cta_corren.num_id_movto_cta_corren NO-ERROR.
                         IF NOT AVAIL movto_operac_financ
                            THEN PUT UNFORMATTED movto_cta_corren.cod_cta_corren ";" movto_cta_corren.dat_movto_cta_corren ";" movto_cta_corren.num_seq ";" movto_cta_corren.cod_modul_dtsul ";" v_tot ";" movto_cta_corren.val_movto SKIP.
                    END.
    
                END.
            END.
        END.
    END.
END.


PROCEDURE pi_devolucoes:

    DEFINE VARIABLE de-tot-despesas AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-vl-despesas  AS DECIMAL NO-UNDO.
    DEFINE VARIABLE vlr-fcp         AS DECIMAL NO-UNDO.

    PUT " " SKIP(2).

    PUT "Listagem de diferenáas entre ACR e Devoluá‰es..." SKIP (1).

    PUT "Estab;Ser;Nro Docto;Emitente;Valor;Observaá∆o" SKIP.

    run pi-acompanhar in h-acomp (INPUT "Conferindo devoluá‰es...").

    devol_block:
    FOR EACH docum-est NO-LOCK                       WHERE
             docum-est.dt-trans >= tt-param.data-ini AND 
             docum-est.dt-trans <= tt-param.data-fim AND
             docum-est.ce-atual /*somente documento j† atualizados*/ ,
        FIRST emitente NO-LOCK WHERE
             emitente.cod-emitente = docum-est.cod-emitente,
        EACH item-doc-est OF docum-est NO-LOCK,
        FIRST ITEM NO-LOCK 
        WHERE ITEM.it-codigo = item-doc-est.it-codigo:

        run pi-acompanhar in h-acomp (INPUT "NF: " + STRING(docum-est.nro-docto) + " Ser: " + STRING(docum-est.serie-docto)).

        /* Filtro de naturezas ... */
        IF  NOT CAN-FIND(FIRST ext-natur-oper
                         WHERE ext-natur-oper.nat-operacao = docum-est.nat-operacao
                         AND   ext-natur-oper.tipo         = 1 /* Devoluá∆o */ ) THEN NEXT devol_block.

        ASSIGN de-tot-despesas = docum-est.despesa-nota /* docum-est.valor-frete + docum-est.valor-seguro */
               de-vl-despesas  = item-doc-est.preco-total[1] / docum-est.valor-mercad * de-tot-despesas.
        FIND FIRST familia       OF ITEM NO-LOCK.
        FIND FIRST int-docum-est OF docum-est NO-LOCK NO-ERROR.

        ASSIGN vlr-fcp = 0.

        FOR EACH item-nf-adc NO-LOCK
            WHERE item-nf-adc.cod-serie       = docum-est.serie-docto
              AND item-nf-adc.cod-nota        = docum-est.nro-docto
              AND item-nf-adc.cdn-emitente    = docum-est.cod-emitente
              AND item-nf-adc.cod-natur-oper  = docum-est.nat-operacao
              AND item-nf-adc.idi-tip-dado    = 25
              AND item-nf-adc.num-seq-item-nf = item-doc-est.seq-comp:
            ASSIGN vlr-fcp = vlr-fcp + DEC(SUBSTR(item-nf-adc.cod-livre-4,1,30)).
        END.

        IF  vlr-fcp = ? THEN 
            ASSIGN vlr-fcp = 0.
/*
        PUT  docum-est.dt-trans                                                     FORMAT "99/99/99"         ";"
             docum-est.cod-estabel                                                  FORMAT "x(3)"             ";"
             docum-est.serie-docto                                                  FORMAT "x(03)"            ";"
             item-doc-est.nro-docto                                                                           ";"
             item-doc-est.nat-operacao                                                                        ";"
             item-doc-est.cod-emitente                                                                        ";"
             emitente.nome-abrev                                                                              ";"
             emitente.ins-estadual                                                  FORMAT "x(19)"            ";"
             item-doc-est.nro-comp                                                  FORMAT "9999999"          ";" 
             item-doc-est.data-comp                                                 FORMAT "99/99/99"         ";"
             item-doc-est.nat-comp                                                                            ";"
             ITEM.fm-codigo                                                                                   ";"
             item-doc-est.it-codigo                                                 FORMAT "x(7)"             ";"
             ITEM.desc-item                                                         FORMAT "x(40)"            ";"
             item-doc-est.quantidade                                                                          ";"
             item-doc-est.valor-ipi[1]                                              FORMAT ">,>>>,>>9.99"     ";"
             item-doc-est.valor-icm[1]                                              FORMAT ">,>>>,>>9.99"     ";"
             item-doc-est.base-subs[1]                                              FORMAT ">>>>>,>>>,>>9.99" ";"
             (item-doc-est.vl-subs[1] + vlr-fcp)                                    FORMAT ">,>>>,>>9.99"     ";"
             de-vl-despesas                                                         FORMAT ">>,>>>,>>9.99"    ";"
             (item-doc-est.preco-total[1] - item-doc-est.desconto[1])               FORMAT ">>,>>>,>>9.99"    ";"
             (item-doc-est.preco-total[1] - item-doc-est.desconto[1] + 
              item-doc-est.valor-ipi[1] + item-doc-est.vl-subs[1] + vlr-fcp + de-vl-despesas) FORMAT ">>,>>>,>>9.99"    ";"
             IF AVAIL int-docum-est THEN int-docum-est.cod-msg-devolucao ELSE 0     FORMAT "999"              ";"
             SUBSTRING(familia.fm-codigo,6,2)                                       FORMAT "X(02)"            ";"
             item-doc-est.aliquota-icm                                                                        ";" 
             ITEM.codigo-orig                                                       FORMAT "99"               ";".

        IF NOT SUBSTRING(docum-est.nat-operacao,1,1) = "3" THEN 
           PUT (item-doc-est.val-cofins) FORMAT ">,>>>,>>9.99" ";"
               (item-doc-est.valor-pis)  FORMAT ">,>>>,>>9.99" ";".
           PUT emitente.cidade FORMAT "X(10)"                                                                      ";"
               emitente.estado FORMAT "X(2)"                                                                       ";" .
*/
        FOR FIRST it-nota-fisc NO-LOCK
            WHERE it-nota-fisc.cod-estabel = docum-est.cod-estabel
              AND it-nota-fisc.serie       = item-doc-est.serie-comp
              AND it-nota-fisc.nr-nota-fis = item-doc-est.nro-comp
              AND it-nota-fisc.it-codigo   = item-doc-est.it-codigo:
        END.
/*
        IF AVAIL it-nota-fisc THEN DO:
            PUT DECIMAL(TRIM(SUBSTRING(it-nota-fisc.char-2,218,14))) FORMAT ">,>>>,>>>,>>9.99" ";"
                it-nota-fisc.vl-ir-adic                              FORMAT ">,>>>,>>>,>>9.99" ";".
        END.
        ELSE DO:
            PUT "0;0;".
        END.

        IF AVAIL movto-estoq THEN DO:
            PUT movto-estoq.cod-depos + ";".
        END.
        ELSE DO:
            PUT ";".
        END.

        PUT item.cod-unid-negoc + ";".
*/
        FIND FIRST it-nota-fisc NO-LOCK
             WHERE it-nota-fisc.cod-estabel = docum-est.cod-estabel
               AND it-nota-fisc.serie       = item-doc-est.serie-comp
               AND it-nota-fisc.nr-nota-fis = item-doc-est.nro-comp
               AND it-nota-fisc.it-codigo   = item-doc-est.it-codigo NO-ERROR.

        FIND FIRST nota-fiscal OF it-nota-fisc NO-LOCK NO-ERROR.

/*         FOR FIRST item-nf-adc FIELDS(val-livre-1 cod-livre-1 cod-livre-2 val-livre-2 cod-livre-4 val-livre-3 val-livre-4) */
/*             WHERE item-nf-adc.idi-tip-dado     = 24 /* DIFAL */                                                           */
/*               AND item-nf-adc.cod-estab        = it-nota-fisc.cod-estabel                                                 */
/*               AND item-nf-adc.cod-serie        = nota-fiscal.serie                                                        */
/*               AND item-nf-adc.cod-nota-fisc    = nota-fiscal.nr-nota-fis                                                  */
/*               AND item-nf-adc.cdn-emitente     = nota-fiscal.cod-emitente                                                 */
/*               AND item-nf-adc.cod-natur-operac = nota-fiscal.nat-operacao                                                 */
/*               AND item-nf-adc.cod-item         = it-nota-fisc.it-codigo NO-LOCK:                                          */
/*         END.                                                                                                              */

        FOR FIRST item-nf-adc FIELDS(val-livre-1 cod-livre-1 cod-livre-2 val-livre-2 cod-livre-4
                                    val-livre-3 val-livre-4)
            WHERE item-nf-adc.idi-tip-dado     = 24 /* DIFAL */
              AND item-nf-adc.cod-estab        = docum-est.cod-estabel
              AND item-nf-adc.cod-serie        = docum-est.serie
              AND item-nf-adc.cod-nota-fisc    = docum-est.nro-docto
              AND item-nf-adc.cdn-emitente     = docum-est.cod-emitente
              AND item-nf-adc.cod-natur-operac = docum-est.nat-operacao
              AND item-nf-adc.cod-item         = item-doc-est.it-codigo NO-LOCK:
        END.
/*        
        IF AVAIL item-nf-adc THEN DO:
           PUT item-nf-adc.cod-livre-4 + ";". /*Vl ICMS FCP*/
           PUT STRING(item-nf-adc.val-livre-3) + ";". /*Vl ICMS UF Dest*/ 
           PUT STRING(item-nf-adc.val-livre-4) + ";". /*Vl ICMS UF Remet*/ 
        END.
        ELSE DO:
           PUT "0;0;0;".
        END.
        PUT SKIP. */

        IF item-doc-est.nro-comp   <> "" AND 
           item-doc-est.serie-comp <> "" 
        THEN DO:

            FIND FIRST tt-rec WHERE
                       tt-rec.cod-estabel  = docum-est.cod-estabel   AND
                     /*  tt-rec.serie-docto  = item-doc-est.serie-comp AND */
                       tt-rec.nro-docto    = item-doc-est.nro-comp   AND
                       tt-rec.cod-emitente = docum-est.cod-emitente /* AND
                       tt-rec.nat-operacao = item-doc-est.nat-operacao */
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-rec 
            THEN DO:
                CREATE tt-rec.
                ASSIGN tt-rec.cod-estabel  = docum-est.cod-estabel
                       tt-rec.serie-docto  = item-doc-est.serie-comp
                       tt-rec.nro-docto    = item-doc-est.nro-comp
                       tt-rec.cod-emitente = docum-est.cod-emitente
                       tt-rec.nat-operacao = item-doc-est.nat-operacao
                       tt-rec.serie-nfe    = docum-est.serie-docto
                       tt-rec.docto-nfe    = docum-est.nro-docto
                       tt-rec.valor        = (item-doc-est.preco-total[1] - item-doc-est.desconto[1] + item-doc-est.valor-ipi[1] + item-doc-est.vl-subs[1] + vlr-fcp + de-vl-despesas)
                       tt-rec.usuario      = docum-est.usuario
                       tt-rec.data         = docum-est.dt-trans.
            END.
            ELSE ASSIGN tt-rec.valor = tt-rec.valor + (item-doc-est.preco-total[1] - item-doc-est.desconto[1] + item-doc-est.valor-ipi[1] + item-doc-est.vl-subs[1] + vlr-fcp + de-vl-despesas).
        END.
        ELSE DO:
            FIND FIRST tt-rec-sacr WHERE
                       tt-rec-sacr.cod-estabel  = docum-est.cod-estabel     AND
                       tt-rec-sacr.serie-docto  = docum-est.serie-docto     AND
                       tt-rec-sacr.nro-docto    = docum-est.nro-docto       AND
                       tt-rec-sacr.cod-emitente = docum-est.cod-emitente    AND
                       tt-rec-sacr.nat-operacao = docum-est.nat-operacao
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-rec-sacr 
            THEN DO:
                IF item-doc-est.nro-comp = ""  THEN
                CREATE tt-rec-sacr.
                ASSIGN tt-rec-sacr.cod-estabel  = docum-est.cod-estabel
                       tt-rec-sacr.serie-docto  = docum-est.serie-docto
                       tt-rec-sacr.nro-docto    = docum-est.nro-docto
                       tt-rec-sacr.cod-emitente = docum-est.cod-emitente
                       tt-rec-sacr.nat-operacao = docum-est.nat-operacao
                       tt-rec-sacr.serie-nfe    = docum-est.serie-docto
                       tt-rec-sacr.docto-nfe    = docum-est.nro-docto
                       tt-rec-sacr.it-codigo    = item-doc-est.it-codigo
                       tt-rec-sacr.valor        = (item-doc-est.preco-total[1] - item-doc-est.desconto[1] + item-doc-est.valor-ipi[1] + item-doc-est.vl-subs[1] + vlr-fcp + de-vl-despesas)
                       tt-rec-sacr.usuario      = docum-est.usuario
                       tt-rec-sacr.data         = docum-est.dt-trans
                       tt-rec-sacr.desc-item    = IF AVAIL ITEM AND  ITEM.tipo-contr <> 4 THEN ITEM.desc-item ELSE item-doc-est.narrativa
                       tt-rec-sacr.fm-codigo    = IF AVAIL ITEM THEN ITEM.fm-codigo ELSE ""
                       tt-rec-sacr.ipi          = item-doc-est.valor-ipi[1]
                       tt-rec-sacr.icm          = item-doc-est.valor-icm[1]
                       tt-rec-sacr.base-subs    = item-doc-est.base-subs[1]
                       tt-rec-sacr.vl-subs      = item-doc-est.vl-subs[1] + vlr-fcp
                       tt-rec-sacr.vl-despesas  = de-vl-despesas
                       tt-rec-sacr.vl-merc      = item-doc-est.preco-total[1] - item-doc-est.desconto[1]
                       tt-rec-sacr.vl-total     = item-doc-est.preco-total[1] - item-doc-est.desconto[1] + 
                                                  item-doc-est.valor-ipi[1] + item-doc-est.vl-subs[1] + vlr-fcp + de-vl-despesas.
            END.
        END.

    END.

    FOR EACH tt-rec NO-LOCK.        

        run pi-acompanhar in h-acomp (INPUT "Devoluá∆o " + STRING(tt-rec.nro-docto )).

        FIND FIRST tt-acr WHERE
                   tt-acr.cod-estabel  = tt-rec.cod-estabel AND
                   tt-acr.serie-docto  = tt-rec.serie-docto AND
                   tt-acr.nro-docto    = tt-rec.nro-docto   AND
                   tt-acr.cod-emitente = tt-rec.cod-emitente
                   NO-LOCK NO-ERROR.

        IF NOT AVAIL tt-acr 
        THEN DO:
           PUT tt-rec.cod-estabel  ";"
               tt-rec.serie-docto  ";"
               tt-rec.nro-docto    ";"
               tt-rec.cod-emitente ";"
               tt-rec.valor        ";"
               "NF lanáada no recebimento mas n∆o encontrada na contabilidade" SKIP.
        END.
        ELSE DO:
            IF tt-rec.valor <> tt-acr.valor 
            THEN DO:

               PUT "" SKIP.

               PUT tt-rec.cod-estabel  ";"
                   tt-rec.serie-docto  ";"
                   tt-rec.nro-docto    ";"
                   tt-rec.cod-emitente ";"
                   tt-rec.valor        ";"
                   "NF com valores diferentes entre contabilidade e Recebimento " 
                   " ACR = " STRING(tt-acr.valor) " REC = " STRING(tt-rec.valor)
                   SKIP.

               PUT "Origem;Data Trans;Usuario;Estab;Ser Saida;Nro Doc Saida;Emitente;Valor;Hist ACR;Transacao ACR;Ser Entrada;Nro Doc Entrada;Natureza;Item;Descriá∆o;Familia;IPI;ICMS;Base Subst. Trib.;ICMS Subst;Desp.Aces;Vl. Mercad.;Total" SKIP.

               FOR EACH item-doc-est WHERE
                        item-doc-est.serie-docto  = tt-rec.serie-nfe    AND
                        item-doc-est.nro-docto    = tt-rec.docto-nfe    AND
                        item-doc-est.cod-emitente = tt-rec.cod-emitente AND
                        item-doc-est.nat-operacao = tt-rec.nat-operacao AND
                        item-doc-est.nro-comp     = tt-rec.nro-docto
                     /* aqui pegar a NF complementar do item */   
                        NO-LOCK.

                  FIND FIRST docum-est OF item-doc-est NO-LOCK NO-ERROR.

                  FIND ITEM WHERE
                       ITEM.it-codigo = item-doc-est.it-codigo
                       NO-LOCK NO-ERROR.
               
                  ASSIGN de-tot-despesas = docum-est.despesa-nota /* docum-est.valor-frete + docum-est.valor-seguro */
                         de-vl-despesas  = item-doc-est.preco-total[1] / docum-est.valor-mercad * de-tot-despesas.

                  ASSIGN vlr-fcp = 0.
                  
                  FOR EACH item-nf-adc NO-LOCK
                      WHERE item-nf-adc.cod-serie       = docum-est.serie-docto
                        AND item-nf-adc.cod-nota        = docum-est.nro-docto
                        AND item-nf-adc.cdn-emitente    = docum-est.cod-emitente
                        AND item-nf-adc.cod-natur-oper  = docum-est.nat-operacao
                        AND item-nf-adc.idi-tip-dado    = 25
                        AND item-nf-adc.num-seq-item-nf = item-doc-est.seq-comp:
                      ASSIGN vlr-fcp = vlr-fcp + DEC(SUBSTR(item-nf-adc.cod-livre-4,1,30)).
                  END.
                  
                  IF  vlr-fcp = ? THEN 
                      ASSIGN vlr-fcp = 0. 

                  PUT "REC"                     ";"
                      tt-rec.data               ";"
                      tt-rec.usuario            ";"
                      tt-rec.cod-estabel        ";"
                      tt-rec.serie-docto        ";"
                      tt-rec.nro-docto          ";"
                      tt-rec.cod-emitente       ";"
                      tt-rec.valor              ";"
                      ";"
                      ";"
                      tt-rec.serie-nfe          ";"
                      tt-rec.docto-nfe          ";"
                      tt-rec.nat-operacao       ";"
                      item-doc-est.it-codigo    ";"
                      IF AVAIL ITEM AND  ITEM.tipo-contr <> 4 THEN ITEM.desc-item ELSE item-doc-est.narrativa  ";"
                      IF AVAIL ITEM THEN ITEM.fm-codigo ELSE ""                                                ";"
                      item-doc-est.valor-ipi[1]                                              FORMAT ">,>>>,>>9.99"     ";"
                      item-doc-est.valor-icm[1]                                              FORMAT ">,>>>,>>9.99"     ";"
                      item-doc-est.base-subs[1]                                              FORMAT ">>>>>,>>>,>>9.99" ";"
                      (item-doc-est.vl-subs[1] + vlr-fcp)                                    FORMAT ">,>>>,>>9.99"     ";"
                      de-vl-despesas                                                         FORMAT ">>,>>>,>>9.99"    ";"
                      (item-doc-est.preco-total[1] - item-doc-est.desconto[1])               FORMAT ">>,>>>,>>9.99"    ";"
                      (item-doc-est.preco-total[1] - item-doc-est.desconto[1] + 
                       item-doc-est.valor-ipi[1] + item-doc-est.vl-subs[1] + vlr-fcp + de-vl-despesas) FORMAT ">>,>>>,>>9.99"    SKIP.

               END.

               FOR EACH tt-dados2 WHERE
                        tt-dados2.cod_estab    = tt-rec.cod-estabel  AND
                        tt-dados2.cod_emitente = tt-rec.cod-emitente AND
                        tt-dados2.cod_tit_ap   = tt-rec.nro-docto
                        NO-LOCK.

                  PUT "ACR"                    ";"
                      tt-dados2.dt_transacao   ";"
                      tt-dados2.cod_usuar_ult_atualiz ";"
                      tt-dados2.cod_estab      ";"
                      tt-dados2.cod_ser_docto  ";"
                      string(tt-dados2.cod_tit_ap) ";"
                      tt-dados2.cod_emitente   ";"
                      tt-dados2.val_aprop_ctbl ";" 
                      tt-dados2.des_lancto FORMAT "x(20)" ";" 
                      tt-dados2.ind_trans  FORMAT "x(20)" SKIP.
               END.
            END.
        END.
    END.

    FOR EACH tt-acr NO-LOCK.
        run pi-acompanhar in h-acomp (INPUT "ACR " + STRING(tt-acr.nro-docto )).

        FIND FIRST tt-rec WHERE
                   tt-rec.cod-estabel  = tt-acr.cod-estabel AND
                   tt-rec.serie-docto  = tt-acr.serie-docto AND
                   tt-rec.nro-docto    = tt-acr.nro-docto   AND
                   tt-rec.cod-emitente = tt-acr.cod-emitente
                   NO-LOCK NO-ERROR.

        IF NOT AVAIL tt-rec 
        THEN DO:
           PUT "" SKIP.
           PUT tt-acr.cod-estabel  ";"
               tt-acr.serie-docto  ";"
               tt-acr.nro-docto    ";"
               tt-acr.cod-emitente ";"
               tt-acr.valor        ";"
               "NF lanáada na contabilidade mas n∆o encontrada no recebimento" SKIP.
        END.
    END.

    PUT "" SKIP (1).
    PUT "Recebimentos sem encontro de contas..." SKIP.

    PUT "Origem;Data Trans;Usuario;Estab;Ser Saida;Nro Doc Saida;Emitente;Valor;Hist ACR;Transacao ACR;Ser Entrada;Nro Doc Entrada;Natureza;Item;Descriá∆o;Familia;IPI;ICMS;Base Subst. Trib.;ICMS Subst;Desp.Aces;Vl. Mercad.;Total" SKIP.


    FOR EACH tt-rec-sacr NO-LOCK.

        PUT "REC"                     ";"
            tt-rec-sacr.data          ";"
            tt-rec-sacr.usuario       ";"
            tt-rec-sacr.cod-estabel   ";"
            ";"
            ";"
            tt-rec-sacr.cod-emitente  ";"
            tt-rec-sacr.valor         ";"
            ";"
            ";"
            tt-rec-sacr.serie-docto   ";"
            tt-rec-sacr.nro-docto     ";"
            tt-rec-sacr.nat-operacao  ";"
            tt-rec-sacr.it-codigo     ";"
            tt-rec-sacr.desc-item     ";"
            tt-rec-sacr.fm-codigo     ";"
            tt-rec-sacr.ipi           ";"
            tt-rec-sacr.icm           ";"
            tt-rec-sacr.base-subs     ";"
            tt-rec-sacr.vl-subs       ";"
            tt-rec-sacr.vl-despesas   ";"
            tt-rec-sacr.vl-merc       ";"
            tt-rec-sacr.vl-total      ";" SKIP.

    END.
END.

