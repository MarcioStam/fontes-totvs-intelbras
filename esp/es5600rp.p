 /******************************************************************************************
**  Programa: es5600rp.p
**  Funcao..: Importar liquidaá∆o conciliaá∆o financeira
**  Autor...: Gesplus Software
**  Data....: jan/2020  
**  Versao..: 1.00.00.000 - Versao Inicial.
******************************************************************************************/
/* include de controle de vers∆o */
{include/i-prgvrs.i es5600rp 1.00.00.001}
{include/i-rpvar.i}
{utp/ut-glob.i}

{esp/esb/esesb007-solicita.i1} 
{esapi/esapi015tt.i}
{esp/es0018.i}

/* preprocessador para ativar ou nao a saida para RTF */
&GLOBAL-DEFINE RTF NO
/* preprocessador para setar o tamanho da pagina */
&SCOPED-DEFINE pagesize 62  

/* definicao das temp-tables para recebimento de parametros */
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino      AS INTEGER
    FIELD arquivo      AS CHAR FORMAT "x(35)":U
    FIELD usuario      AS CHAR FORMAT "x(12)":U
    FIELD data-exec    AS DATE
    FIELD hora-exec    AS INTEGER
    FIELD arquivo-import AS CHAR FORMAT "x(256)".   

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

/* recebimento de parametros */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* definiá∆o de variaveis */                                                
DEF VAR h-acomp           AS HANDLE                                                   NO-UNDO.
DEF VAR c-arq-rec         AS CHARACTER                                                NO-UNDO. 
DEF VAR c-arq-import      AS CHARACTER                                                NO-UNDO. 
DEF VAR c-arq-log         AS CHARACTER                                                NO-UNDO. 
DEF VAR c1                AS CHARACTER                                                NO-UNDO.
DEF VAR c2                AS CHARACTER                                                NO-UNDO.
DEF VAR c_erro_aux        AS CHAR FORMAT "x(256)"                                     NO-UNDO.
DEF VAR c-arq-log-aux     AS CHAR                                                     NO-UNDO.
DEF VAR v_prefixo         AS CHAR                                                     NO-UNDO.
DEF VAR v_dat_ini         AS DATE                                                     NO-UNDO.
DEF VAR v_dat_fim         AS DATE                                                     NO-UNDO.
DEF VAR v_hdl_aux         AS HANDLE                                                   NO-UNDO.
DEF VAR v_dat_tri_ant_ini AS DATE                                                     NO-UNDO.
DEF VAR v_dat_tri_ant_fim AS DATE                                                     NO-UNDO.
DEF VAR v_refer           LIKE tit_ap.cod_refer                                       NO-UNDO.
DEF VAR v_verba_ant       LIKE int-solicitacao.ValorSolicitado                        NO-UNDO.
DEF VAR v_verba_tot       LIKE int-solicitacao.ValorSolicitado                        NO-UNDO.
DEF VAR v_verba_aux       LIKE int-solicitacao.ValorSolicitado                        NO-UNDO.
DEF VAR v_verba_calc      LIKE int-solicitacao.ValorSolicitado                        NO-UNDO.
DEF VAR v_val_rateio      LIKE rat_movto_tit_ap.val_aprop_ctbl                        NO-UNDO.
DEF VAR v_aux_val_rateio  LIKE rat_movto_tit_ap.val_aprop_ctbl                        NO-UNDO.
DEF VAR v_dif_rat         LIKE rat_movto_tit_ap.val_aprop_ctbl                        NO-UNDO.
DEF VAR v_perc_rateio     AS DEC                                                      NO-UNDO.
DEF VAR v_cod_cta_ctbl    LIKE tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl         NO-UNDO.
DEF VAR v_cod_ccusto      LIKE tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto           NO-UNDO.
DEF VAR v_cod_tip_fluxo   LIKE tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ NO-UNDO.
DEF VAR v_cod_tit_ap      LIKE tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap          NO-UNDO.
DEF VAR c-prefixo         AS CHAR                                                     NO-UNDO.
DEF VAR v_seq_erro_aux    AS INT                                                      NO-UNDO.

/* testes
DEF VAR v_today AS DATE NO-UNDO. */

DEF BUFFER b_tit_ap FOR tit_ap.

/* temp-table com os dados da planilha de importaá∆o */
DEFINE TEMP-TABLE tt-import NO-UNDO   
    FIELD linha          AS INT
    FIELD cdn_cliente    LIKE int-cc-benef.canal         
    FIELD cod_unid_negoc LIKE int-cc-benef.unid-neg      
    FIELD beneficio      AS CHAR
    FIELD categoria      LIKE int-cc-benef.categoria     
    FIELD val_ajuste     LIKE int-cc-benef.VerbaCalculada
    FIELD nome_solic     LIKE int-solicitacao.NomeSolicitacaoBeneficio
    FIELD tipo_solic     LIKE int-solicitacao.CodigoTipoSolicitacao
    FIELD desc_solic     LIKE int-solicitacao.DescricaoSolicitacao
    FIELD forma_pag      LIKE int-solicitacao.CodigoFormaPagamento
    FIELD dat_vencto     LIKE int-solicitacao.da-vencto
    FIELD classific      LIKE int-cc-benef.classificacao.

DEF TEMP-TABLE tt-int-cc-benef NO-UNDO 
    field tp-movto              like int-cc-benef.tp-movto            
    field canal                 like int-cc-benef.canal               
    field unid-neg              like int-cc-benef.unid-neg            
    field dt-periodo-ini        like int-cc-benef.dt-periodo-ini      
    field dt-periodo-fim        like int-cc-benef.dt-periodo-fim      
    field tipo-beneficio        like int-cc-benef.tipo-beneficio      
    field classificacao         like int-cc-benef.classificacao       
    field categoria             like int-cc-benef.categoria           
    field guid-canal            like int-cc-benef.guid-canal          
    field guid-beneficio        like int-cc-benef.guid-beneficio      
    field guid-beneficio-canal  like int-cc-benef.guid-beneficio-canal
    field VerbaCalculada        like int-cc-benef.VerbaCalculada      
    field perc-benef            like int-cc-benef.perc-benef          
    field dt-transacao          like int-cc-benef.dt-transacao        
    field dt-vencimento         like int-cc-benef.dt-vencimento       
    field id-status             like int-cc-benef.id-status           
    field usuario               like int-cc-benef.usuario             
    field vl-base-calc          like int-cc-benef.vl-base-calc        
    field perc-custo            like int-cc-benef.perc-custo.



DEF TEMP-TABLE tt-int-solicitacao NO-UNDO
    LIKE int-solicitacao.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD i-sequen         AS INT
    FIELD tipo             AS INT
    FIELD canal            LIKE int-cc-benef.canal
    FIELD cd-erro          AS INT
    FIELD mensagem         AS CHAR FORMAT "x(255)".

DEF BUFFER b-int-solicitacao   FOR int-solicitacao.
DEF BUFFER b-int-solicitacao-2 FOR int-solicitacao.
DEF BUFFER b-int-cc-benef      FOR int-cc-benef.

FIND FIRST mguni.empresa NO-LOCK   
     WHERE empresa.ep-codigo = v_cdn_empres_usuar NO-ERROR.  

ASSIGN c-versao       = "1.00"
       c-revisao      = "000"
       c-empresa      = empresa.razao-social
       c-programa     = "es5600rp.p"
       c-titulo-relat = "Importar Planilha Ajustes Trimestrais VMC".
       
/************** BLOCO PRINCIPAL ***************/
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar IN h-acomp (INPUT "In°cio Importaá∆o"). 

FIND FIRST tt-param NO-ERROR.

RUN pi-acompanhar IN h-acomp (INPUT "Lendo arquivo: " + tt-param.arquivo-import).

EMPTY TEMP-TABLE tt-erro.

{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

/* importar dados do arquivo csv separado por ponto e v°rgula */
RUN pi-importa.

/* gerar ajustes vmc */
IF  CAN-FIND(FIRST tt-import) THEN DO:
    RUN pi-gera-solic-vmc.
END.

IF  CAN-FIND(FIRST tt-erro WHERE tt-erro.tipo = 1) THEN DO:
    PUT UNFORMATTED "Erros;" SKIP.
    PUT UNFORMATTED "Num Msg;Mensagem" SKIP.

    FOR EACH tt-erro
        WHERE tt-erro.tipo = 1:

        PUT UNFORMATTED 
             tt-erro.cd-erro ";"
             tt-erro.mensagem SKIP.
    END.
END.

IF  NOT CAN-FIND(FIRST tt-erro WHERE tt-erro.tipo = 1) THEN DO:
    PUT UNFORMATTED "Benef°cio Apurado;" SKIP.
    PUT UNFORMATTED "Canal;Num Msg;Mensagem" SKIP.

    FOR EACH tt-erro
        WHERE tt-erro.tipo = 2:

        PUT UNFORMATTED 
             tt-erro.canal   ";"
             tt-erro.cd-erro ";"
             tt-erro.mensagem SKIP.
    END.
END.

{include/i-rpclo.i}

RUN pi-finalizar IN h-acomp.

RETURN "OK":U.


PROCEDURE pi-importa: /* importar dados da planilha */

    DEF VAR v_num_line       AS INT                                        NO-UNDO.
    DEF VAR v_des_reg_import AS CHAR FORMAT "x(200)":U                     NO-UNDO.
    DEF VAR v_cdn_cliente    LIKE int-cc-benef.canal                       NO-UNDO.
    DEF VAR v_cod_unid_negoc LIKE int-cc-benef.unid-neg                    NO-UNDO.
    DEF VAR v_beneficio      AS CHAR                                       NO-UNDO.
    DEF VAR v_categoria      LIKE int-cc-benef.categoria                   NO-UNDO.
    DEF VAR v_val_ajuste     LIKE int-cc-benef.VerbaCalculada              NO-UNDO.
    DEF VAR v_nome_solic     LIKE int-solicitacao.NomeSolicitacaoBeneficio NO-UNDO.
    DEF VAR v_tipo_solic     LIKE int-solicitacao.CodigoTipoSolicitacao    NO-UNDO.
    DEF VAR v_desc_solic     LIKE int-solicitacao.DescricaoSolicitacao     NO-UNDO.
    DEF VAR v_forma_pag      LIKE int-solicitacao.CodigoFormaPagamento     NO-UNDO.
    DEF VAR v_dat_vencto     LIKE int-solicitacao.da-vencto                NO-UNDO.
    DEF VAR v_classific      LIKE int-cc-benef.classificacao               NO-UNDO.

    EMPTY TEMP-TABLE tt-import.
    
    INPUT FROM VALUE(tt-param.arquivo-import) NO-CONVERT.
    
    REPEAT:
        IMPORT UNFORMATTED v_des_reg_import.
    
        ASSIGN v_num_line = v_num_line + 1.
    
        IF  v_num_line = 1 THEN
            NEXT.

        run pi-acompanhar in h-acomp (input "Importando arquivo: " + tt-param.arquivo-import + " - Linha: " + string(v_num_line)).

        ASSIGN v_cdn_cliente        =  INT(ENTRY(2,  v_des_reg_import, ";"))
               v_cod_unid_negoc     = TRIM(ENTRY(4,  v_des_reg_import, ";"))
               v_beneficio          = TRIM(ENTRY(5,  v_des_reg_import, ";"))
               v_categoria          = TRIM(ENTRY(6,  v_des_reg_import, ";"))
               v_val_ajuste         =  DEC(ENTRY(15, v_des_reg_import, ";"))
               v_nome_solic         = TRIM(ENTRY(9,  v_des_reg_import, ";"))
               v_tipo_solic         = TRIM(ENTRY(8,  v_des_reg_import, ";"))
               v_desc_solic         = TRIM(ENTRY(19, v_des_reg_import, ";"))
               v_forma_pag          = TRIM(ENTRY(16, v_des_reg_import, ";"))
               v_dat_vencto         = date(ENTRY(17, v_des_reg_import, ";"))
               v_classific          = TRIM(ENTRY(20, v_des_reg_import, ";")).

        CREATE tt-import.
        ASSIGN tt-import.linha       = v_num_line
               tt-import.cdn_cliente = v_cdn_cliente
               tt-import.beneficio   = v_beneficio
               tt-import.categoria   = v_categoria
               tt-import.val_ajuste  = v_val_ajuste
               tt-import.nome_solic  = v_nome_solic
               tt-import.tipo_solic  = v_tipo_solic
               tt-import.desc_solic  = v_desc_solic
               tt-import.forma_pag   = v_forma_pag
               tt-import.dat_vencto  = v_dat_vencto
               tt-import.classific   = v_classific.

        FIND FIRST unid_negoc
            WHERE unid_negoc.des_unid_negoc = v_cod_unid_negoc NO-LOCK NO-ERROR.

        IF  AVAIL unid_negoc THEN
            ASSIGN tt-import.cod_unid_negoc = unid_negoc.cod_unid_negoc.
        ELSE DO:
            ASSIGN v_seq_erro_aux = v_seq_erro_aux + 1.

            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = v_seq_erro_aux
                   tt-erro.canal    = v_cdn_cliente
                   tt-erro.tipo     = 1
                   tt-erro.cd-erro  = 17006
                   tt-erro.mensagem = "Unidade de neg¢cio " + v_cod_unid_negoc + " n∆o cadastrada." .
            NEXT.
        END.
    END.

END PROCEDURE.

PROCEDURE pi-gera-solic-vmc:

    DEF VAR i-cont-seq        AS INT                              NO-UNDO.
    DEF VAR d_val_sdo_tit_acr AS DEC                              NO-UNDO.
    DEF VAR v_dat_ini_tri     AS DATE                             NO-UNDO.
    DEF VAR v_tri_compet      AS CHAR                             NO-UNDO.
    DEF VAR v_tipo_benef      LIKE int-solicitacao.tipo-beneficio NO-UNDO.

    ASSIGN v_dat_ini_tri = DATE(MONTH(TODAY),01,YEAR(TODAY)).

    IF  MONTH(TODAY) >= 01
    AND MONTH(TODAY) <= 03 THEN
        ASSIGN v_tri_compet      = string(YEAR(TODAY) - 1,"9999") + "-T4"
               v_dat_ini         = DATE(10,01,YEAR(TODAY) - 1)
               v_dat_fim         = DATE(12,31,YEAR(TODAY) - 1)
               v_dat_tri_ant_ini = DATE(07,01,YEAR(TODAY) - 1)
               v_dat_tri_ant_fim = DATE(09,30,YEAR(TODAY) - 1).

    IF  MONTH(TODAY) >= 04
    AND MONTH(TODAY) <= 06 THEN
        ASSIGN v_tri_compet      = string(YEAR(TODAY),"9999") + "-T1"
               v_dat_ini         = DATE(01,01,YEAR(TODAY))
               v_dat_fim         = DATE(03,31,YEAR(TODAY))
               v_dat_tri_ant_ini = DATE(10,01,YEAR(TODAY) - 1)
               v_dat_tri_ant_fim = DATE(12,31,YEAR(TODAY) - 1).

    IF  MONTH(TODAY) >= 07
    AND MONTH(TODAY) <= 09 THEN
        ASSIGN v_tri_compet      = string(YEAR(TODAY),"9999") + "-T2"
               v_dat_ini         = DATE(04,01,YEAR(TODAY))
               v_dat_fim         = DATE(06,30,YEAR(TODAY))
               v_dat_tri_ant_ini = DATE(01,01,YEAR(TODAY))
               v_dat_tri_ant_fim = DATE(03,31,YEAR(TODAY)).

    IF  MONTH(TODAY) >= 10
    AND MONTH(TODAY) <= 12 THEN
        ASSIGN v_tri_compet      = string(YEAR(TODAY),"9999") + "-T3"
               v_dat_ini         = DATE(07,01,YEAR(TODAY))
               v_dat_fim         = DATE(09,30,YEAR(TODAY))
               v_dat_tri_ant_ini = DATE(04,01,YEAR(TODAY))
               v_dat_tri_ant_fim = DATE(06,30,YEAR(TODAY)).

    EMPTY TEMP-TABLE tt-int-cc-benef.

    FOR EACH tt-import
       BREAK BY tt-import.cdn_cliente:

        RUN pi-acompanhar IN h-acomp (INPUT "Gera VMC - Canal: " + string(tt-import.cdn_cliente)).

        IF  tt-import.beneficio <> "VMC" THEN DO:
            ASSIGN v_seq_erro_aux = v_seq_erro_aux + 1.

            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = v_seq_erro_aux
                   tt-erro.canal    = tt-import.cdn_cliente
                   tt-erro.tipo     = 1
                   tt-erro.cd-erro  = 17006
                   tt-erro.mensagem = "Tipo de benef°cio n∆o pode ser diferente de VMC." .
            NEXT.
        END.
        ELSE
            ASSIGN v_tipo_benef = 21.

        FIND FIRST emitente
            WHERE emitente.cod-emit   = tt-import.cdn_cliente
            AND   emitente.identific <> 2 NO-LOCK NO-ERROR.

        IF  NOT AVAIL emitente THEN DO:
            ASSIGN v_seq_erro_aux = v_seq_erro_aux + 1.

            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = v_seq_erro_aux
                   tt-erro.canal    = tt-import.cdn_cliente
                   tt-erro.tipo     = 1
                   tt-erro.cd-erro  = 17006
                   tt-erro.mensagem = "Canal n∆o cadastrado." .
            NEXT.
        END.

        FIND FIRST int-emitente
            WHERE int-emitente.cod-emit = emitente.cod-emit NO-LOCK NO-ERROR.

        IF  NOT AVAIL int-emitente THEN DO:
            ASSIGN v_seq_erro_aux = v_seq_erro_aux + 1.

            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = v_seq_erro_aux
                   tt-erro.canal    = tt-import.cdn_cliente
                   tt-erro.tipo     = 1
                   tt-erro.cd-erro  = 17006
                   tt-erro.mensagem = "Extens∆o do canal n∆o cadastrada." .
            NEXT.
        END.

        CREATE int-solicitacao.
        ASSIGN int-solicitacao.CodigoSolicitacaoBeneficio       = string(ROWID(int-solicitacao))
               int-solicitacao.NomeSolicitacaoBeneficio         = tt-import.nome_solic
               int-solicitacao.CodigoTipoSolicitacao            = tt-import.tipo_solic
               int-solicitacao.CodigoBeneficio                  = tt-import.beneficio
               int-solicitacao.CodigoBeneficioCanal             = ""
               int-solicitacao.CodigoUnidadeNegocio             = tt-import.cod_unid_negoc
               int-solicitacao.CodigoConta                      = "BR" + trim(emitente.cgc)
               int-solicitacao.ValorSolicitado                  = tt-import.val_ajuste
               int-solicitacao.ValorSolicitadoOrigemCRM         = tt-import.val_ajuste
               int-solicitacao.DescricaoSolicitacao             = tt-import.desc_solic                       
               int-solicitacao.SolicitacaoIrregular             = NO
               int-solicitacao.DescricaoSituacaoIrregular       = ""
               int-solicitacao.CodigoFormaPagamento             = tt-import.forma_pag
               int-solicitacao.SituacaoSolicitacaoBeneficio     = 993520004 /* paga */
               int-solicitacao.RazaoStatusSolicitacaoBeneficio  = 993520002
               int-solicitacao.situacao                         = 0
               int-solicitacao.Proprietario                     = ""
               int-solicitacao.TipoProprietario                 = "systemuser"
               int-solicitacao.dt-periodo-ini                   = v_dat_ini
               int-solicitacao.dt-periodo-fim                   = v_dat_fim. 

        ASSIGN int-solicitacao.CodigoAssistente                 = 36
               int-solicitacao.CodigoSupervisorEMS              = "al027000"
               int-solicitacao.CodigoFilial                     = ""
               int-solicitacao.StatusPagamento                  = 993520000
               int-solicitacao.DataCriacao                      = TODAY
               int-solicitacao.DataValidade                     = v_dat_ini_tri + 124
               int-solicitacao.CodigoCondicaoPagamento          = ?
               int-solicitacao.DescartarVerba                   = NO
               int-solicitacao.TrimestreCompetencia             = v_tri_compet
               int-solicitacao.FormaCancelamento                = ?
               int-solicitacao.dt-trans                         = TODAY
               int-solicitacao.desc-forma-pagto                 = tt-import.forma_pag
               int-solicitacao.cod-emitente                     = int-emitente.cod-emitente                                   
               int-solicitacao.Ajuste                           = YES   /* INDICA SE ê AJUSTE OU NORMAL */                       
               int-solicitacao.ValorAbaterOriginalCRM           = tt-import.val_ajuste
               int-solicitacao.ValorAbater                      = tt-import.val_ajuste
               int-solicitacao.ValorAprovado                    = tt-import.val_ajuste
               int-solicitacao.tipo-beneficio                   = v_tipo_benef
               int-solicitacao.hora-trans                       = STRING(TIME, "HH:MM:SS")
               int-solicitacao.int-1                            = IF fn-grupo-distribuidores (int-emitente.cod-emitente) THEN 0 ELSE 1 /* 1 indica que Ç revenda */
               int-solicitacao.CodigoAcaoSubsidiadaVMC          = "Ajuste"
               int-solicitacao.DataPrevistaRetornoAcao          = TODAY
               int-solicitacao.log-historica                    = NO
               int-solicitacao.da-vencto                        = tt-import.dat_vencto.

        FIND FIRST int-cc-benef
            WHERE int-cc-benef.dt-periodo-ini = int-solicitacao.dt-periodo-ini
            AND   int-cc-benef.dt-periodo-fim = int-solicitacao.dt-periodo-fim
            AND   int-cc-benef.id-status      = 1
            AND   int-cc-benef.tp-movto       = 2
            AND   int-cc-benef.canal          = int-solicitacao.cod-emitente
            AND   int-cc-benef.unid-neg       = "ADM"
            AND   int-cc-benef.tipo-beneficio = 21 NO-LOCK NO-ERROR.
        
        IF  NOT AVAIL int-cc-benef THEN
            RUN pi_consolida_adm.
        ELSE DO:
            CREATE tt-int-cc-benef.
            ASSIGN tt-int-cc-benef.tp-movto             = int-cc-benef.tp-movto
                   tt-int-cc-benef.canal                = int-cc-benef.canal
                   tt-int-cc-benef.unid-neg             = int-cc-benef.unid-neg
                   tt-int-cc-benef.dt-periodo-ini       = int-cc-benef.dt-periodo-ini
                   tt-int-cc-benef.dt-periodo-fim       = int-cc-benef.dt-periodo-fim
                   tt-int-cc-benef.tipo-beneficio       = int-cc-benef.tipo-beneficio
                   tt-int-cc-benef.classificacao        = int-cc-benef.classificacao
                   tt-int-cc-benef.categoria            = int-cc-benef.categoria    
                   tt-int-cc-benef.guid-canal           = ""
                   tt-int-cc-benef.guid-beneficio       = ""
                   tt-int-cc-benef.guid-beneficio-canal = ""
                   tt-int-cc-benef.VerbaCalculada       = /*int-cc-benef.VerbaCalculada +*/ int-solicitacao.ValorAprovado /* ajuste durante o trimestre */
                   tt-int-cc-benef.perc-benef           = int-cc-benef.perc-benef
                   tt-int-cc-benef.dt-transacao         = TODAY
                   tt-int-cc-benef.dt-vencimento        = int-cc-benef.dt-vencimento
                   tt-int-cc-benef.id-status            = int-cc-benef.id-status
                   tt-int-cc-benef.usuario              = int-cc-benef.usuario
                   tt-int-cc-benef.vl-base-calc         = int-cc-benef.vl-base-calc
                   tt-int-cc-benef.perc-custo           = int-cc-benef.perc-custo.
        END.
    END.

    RUN pi_gera_adm.

END PROCEDURE.

PROCEDURE pi_consolida_adm:

    FIND FIRST tt-int-cc-benef
        WHERE tt-int-cc-benef.dt-periodo-ini = int-solicitacao.dt-periodo-ini 
        AND   tt-int-cc-benef.dt-periodo-fim = int-solicitacao.dt-periodo-fim 
        AND   tt-int-cc-benef.id-status      = 1
        AND   tt-int-cc-benef.tp-movto       = 2
        AND   tt-int-cc-benef.canal          = int-solicitacao.cod-emitente
        AND   tt-int-cc-benef.unid-neg       = "ADM"
        AND   tt-int-cc-benef.tipo-beneficio = 21 EXCLUSIVE-LOCK NO-ERROR.
    
    IF  AVAIL tt-int-cc-benef THEN DO:
        ASSIGN tt-int-cc-benef.VerbaCalculada = tt-int-cc-benef.VerbaCalculada + int-solicitacao.ValorAprovado.
    END.
    ELSE DO:
        CREATE tt-int-cc-benef.
        ASSIGN tt-int-cc-benef.tp-movto             = 2 /* DESPESA */
               tt-int-cc-benef.canal                = int-solicitacao.cod-emitente
               tt-int-cc-benef.unid-neg             = "ADM"
               tt-int-cc-benef.dt-periodo-ini       = v_dat_ini
               tt-int-cc-benef.dt-periodo-fim       = v_dat_fim
               tt-int-cc-benef.tipo-beneficio       = int-solicitacao.tipo-beneficio
               tt-int-cc-benef.classificacao        = tt-import.classific
               tt-int-cc-benef.categoria            = tt-import.categoria
               tt-int-cc-benef.guid-canal           = ""
               tt-int-cc-benef.guid-beneficio       = ""
               tt-int-cc-benef.guid-beneficio-canal = ""
               tt-int-cc-benef.VerbaCalculada       = int-solicitacao.ValorAprovado
               tt-int-cc-benef.perc-benef           = 0
               tt-int-cc-benef.dt-transacao         = TODAY
               tt-int-cc-benef.dt-vencimento        = int-solicitacao.da-vencto
               tt-int-cc-benef.id-status            = 1 /*CONTA CORRENTE ATIVA */
               tt-int-cc-benef.usuario              = c-seg-usuario
               tt-int-cc-benef.vl-base-calc         = 0
               tt-int-cc-benef.perc-custo           = 100.        
    END.

END PROCEDURE.

PROCEDURE pi_gera_adm:
    
    FOR EACH tt-int-cc-benef:
        
        FIND FIRST int-cc-benef
            WHERE int-cc-benef.dt-periodo-ini = tt-int-cc-benef.dt-periodo-ini
            AND   int-cc-benef.dt-periodo-fim = tt-int-cc-benef.dt-periodo-fim
            AND   int-cc-benef.tp-movto       = tt-int-cc-benef.tp-movto      
            AND   int-cc-benef.canal          = tt-int-cc-benef.canal         
            AND   int-cc-benef.unid-neg       = tt-int-cc-benef.unid-neg      
            AND   int-cc-benef.tipo-beneficio = tt-int-cc-benef.tipo-beneficio EXCLUSIVE-LOCK NO-ERROR.

        IF  NOT AVAIL int-cc-benef THEN DO:
            CREATE int-cc-benef.
            ASSIGN int-cc-benef.tp-movto             = tt-int-cc-benef.tp-movto            
                   int-cc-benef.canal                = tt-int-cc-benef.canal               
                   int-cc-benef.unid-neg             = tt-int-cc-benef.unid-neg            
                   int-cc-benef.tipo-beneficio       = tt-int-cc-benef.tipo-beneficio
                   int-cc-benef.dt-periodo-ini       = tt-int-cc-benef.dt-periodo-ini
                   int-cc-benef.dt-periodo-fim       = tt-int-cc-benef.dt-periodo-fim
                   int-cc-benef.classificacao        = tt-int-cc-benef.classificacao       
                   int-cc-benef.categoria            = tt-int-cc-benef.categoria           
                   int-cc-benef.guid-canal           = tt-int-cc-benef.guid-canal          
                   int-cc-benef.guid-beneficio       = tt-int-cc-benef.guid-beneficio      
                   int-cc-benef.guid-beneficio-canal = string(ROWID(int-cc-benef))
                   int-cc-benef.VerbaCalculada       = tt-int-cc-benef.VerbaCalculada
                   int-cc-benef.perc-benef           = tt-int-cc-benef.perc-benef          
                   int-cc-benef.dt-transacao         = tt-int-cc-benef.dt-transacao        
                   int-cc-benef.dt-vencimento        = tt-int-cc-benef.dt-vencimento       
                   int-cc-benef.id-status            = tt-int-cc-benef.id-status           
                   int-cc-benef.usuario              = tt-int-cc-benef.usuario             
                   int-cc-benef.vl-base-calc         = tt-int-cc-benef.vl-base-calc        
                   int-cc-benef.perc-custo           = tt-int-cc-benef.perc-custo
                   int-cc-benef.cod_estab            = "101".

            RUN pi_gera_apb.
        END.
        ELSE DO:
            ASSIGN int-cc-benef.VerbaCalculada = int-cc-benef.VerbaCalculada + tt-int-cc-benef.VerbaCalculada.

            /* ajustes durante o trimestre, ajustar saldo dos t°tulos no APB */
            FIND FIRST b_tit_ap
                WHERE b_tit_ap.cod_estab     = int-cc-benef.cod_estab
                AND   b_tit_ap.num_id_tit_ap = int-cc-benef.num_id_tit_ap NO-LOCK NO-ERROR.

            IF  AVAIL b_tit_ap THEN DO:
                EMPTY TEMP-TABLE tt_tit_ap_alteracao_base_aux_1.
                EMPTY TEMP-TABLE tt_tit_ap_alteracao_rateio.
                EMPTY TEMP-TABLE tt_log_erros_tit_ap_alteracao.

                RUN pi-busca-referencia (INPUT  "BNEF",
                                         INPUT  b_tit_ap.cod_estab,
                                         OUTPUT v_refer).

                create tt_tit_ap_alteracao_base_aux_1.
                assign tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren             = v_cod_usuar_corren
                       tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                  = b_tit_ap.cod_empresa
                       tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                    = b_tit_ap.cod_estab
                       tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap                = b_tit_ap.num_id_tit_ap
                       tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                   = recid(tt_tit_ap_alteracao_base_aux_1)
                       tt_tit_ap_alteracao_base_aux_1.tta_cdn_fornecedor               = b_tit_ap.cdn_fornecedor
                       tt_tit_ap_alteracao_base_aux_1.tta_cod_espec_docto              = b_tit_ap.cod_espec_docto
                       tt_tit_ap_alteracao_base_aux_1.tta_cod_ser_docto                = b_tit_ap.cod_ser_docto
                       tt_tit_ap_alteracao_base_aux_1.tta_cod_tit_ap                   = b_tit_ap.cod_tit_ap
                       tt_tit_ap_alteracao_base_aux_1.tta_cod_parcela                  = b_tit_ap.cod_parcela
                       tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                = TODAY
                       tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                    = v_refer 
                       tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap               = b_tit_ap.val_sdo_tit_ap + tt-int-cc-benef.VerbaCalculada /* somando apenas o valor do ajuste ao valor da verba */
                       tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto               = b_tit_ap.dat_emis_docto
                       tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap            = b_tit_ap.dat_vencto_tit_ap
                       tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto               = b_tit_ap.dat_prev_pagto
                       tt_tit_ap_alteracao_base_aux_1.tta_dat_ult_pagto                = b_tit_ap.dat_ult_pagto
                       tt_tit_ap_alteracao_base_aux_1.tta_num_dias_atraso              = b_tit_ap.num_dias_atraso
                       tt_tit_ap_alteracao_base_aux_1.tta_val_perc_multa_atraso        = b_tit_ap.val_perc_multa_atraso
                       tt_tit_ap_alteracao_base_aux_1.tta_val_juros_dia_atraso         = b_tit_ap.val_juros_dia_atraso
                       tt_tit_ap_alteracao_base_aux_1.tta_val_perc_juros_dia_atraso    = b_tit_ap.val_perc_juros_dia_atraso
                       tt_tit_ap_alteracao_base_aux_1.tta_dat_desconto                 = b_tit_ap.dat_desconto
                       tt_tit_ap_alteracao_base_aux_1.tta_val_perc_desc                = b_tit_ap.val_perc_desc
                       tt_tit_ap_alteracao_base_aux_1.tta_val_desconto                 = b_tit_ap.val_desconto
                       tt_tit_ap_alteracao_base_aux_1.tta_cod_portador                 = b_tit_ap.cod_portador
                       tt_tit_ap_alteracao_base_aux_1.tta_log_pagto_bloqdo             = b_tit_ap.log_pagto_bloqdo
                       tt_tit_ap_alteracao_base_aux_1.tta_cod_seguradora               = b_tit_ap.cod_seguradora
                       tt_tit_ap_alteracao_base_aux_1.tta_cod_apol_seguro              = b_tit_ap.cod_apol_seguro
                       tt_tit_ap_alteracao_base_aux_1.tta_cod_arrendador               = b_tit_ap.cod_arrendador
                       tt_tit_ap_alteracao_base_aux_1.tta_cod_contrat_leas             = b_tit_ap.cod_contrat_leas
                       tt_tit_ap_alteracao_base_aux_1.tta_ind_tip_espec_docto          = b_tit_ap.ind_tip_espec_docto
                       tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ               = b_tit_ap.cod_indic_econ
                       tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap   = "Alteraá∆o"
                       tt_tit_ap_alteracao_base_aux_1.tta_cod_histor_padr              = ""
                       tt_tit_ap_alteracao_base_aux_1.tta_des_histor_padr              = "Ajustes benef°cios -> Programas chamadores: "
                                                                                       +  (IF  PROGRAM-NAME( 1) <> ? THEN PROGRAM-NAME( 1) ELSE "") + chr(10)
                                                                                       +  (IF  PROGRAM-NAME( 2) <> ? THEN PROGRAM-NAME( 2) ELSE "") + chr(10)
                                                                                       +  (IF  PROGRAM-NAME( 3) <> ? THEN PROGRAM-NAME( 3) ELSE "") + chr(10)
                                                                                       +  (IF  PROGRAM-NAME( 4) <> ? THEN PROGRAM-NAME( 4) ELSE "") + chr(10)
                                                                                       +  (IF  PROGRAM-NAME( 5) <> ? THEN PROGRAM-NAME( 5) ELSE "") + chr(10)
                                                                                       +  (IF  PROGRAM-NAME( 6) <> ? THEN PROGRAM-NAME( 6) ELSE "") + chr(10)
                                                                                       +  (IF  PROGRAM-NAME( 7) <> ? THEN PROGRAM-NAME( 7) ELSE "") + chr(10)
                                                                                       +  (IF  PROGRAM-NAME( 8) <> ? THEN PROGRAM-NAME( 8) ELSE "") + chr(10)
                                                                                       +  (IF  PROGRAM-NAME( 9) <> ? THEN PROGRAM-NAME( 9) ELSE "") + chr(10)
                                                                                       +  (IF  PROGRAM-NAME(10) <> ? THEN PROGRAM-NAME(10) ELSE "")
                       tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap               = b_tit_ap.ind_sit_tit_ap              
                       tt_tit_ap_alteracao_base_aux_1.tta_cod_forma_pagto              = b_tit_ap.cod_forma_pagto.

                       VALIDATE tt_tit_ap_alteracao_base_aux_1.

                IF  CAN-FIND (FIRST tt_tit_ap_alteracao_base_aux_1)  THEN DO:
                    run prgfin/apb/apb767ze.py(input 1,
                                               input "",
                                               INPUT "",
                                               input-output table tt_tit_ap_alteracao_base_aux_1,
                                               input-output table tt_tit_ap_alteracao_rateio,
                                               output table       tt_log_erros_tit_ap_alteracao).
                END.

                IF  CAN-FIND(FIRST tt_log_erros_tit_ap_alteracao 
                                WHERE  tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 6542  
                                  AND  tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 11834 
                                  AND  tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 20260 ) THEN DO:

                    FOR EACH tt_log_erros_tit_ap_alteracao:
                        ASSIGN v_seq_erro_aux = v_seq_erro_aux + 1.

                        CREATE tt-erro.
                        ASSIGN tt-erro.i-sequen = v_seq_erro_aux
                               tt-erro.canal    = int-cc-benef.canal
                               tt-erro.tipo     = 1
                               tt-erro.cd-erro  = 17006
                               tt-erro.mensagem = tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro.
                    END.                
                END.        
                ELSE DO:
                    ASSIGN v_seq_erro_aux = v_seq_erro_aux + 1.

                    CREATE tt-erro.
                    ASSIGN tt-erro.i-sequen = v_seq_erro_aux
                           tt-erro.canal    = int-cc-benef.canal
                           tt-erro.tipo     = 2
                           tt-erro.cd-erro  = 17006
                           tt-erro.mensagem = "Ajuste dentro do trimestre efetuado com sucesso" .
                END.
            END.
            /* ajustes durante o trimestre, ajustar saldo dos t°tulos no APB */
        END.
    END.

END PROCEDURE.

PROCEDURE pi_gera_apb:

    ASSIGN v_verba_tot = 0
           v_verba_aux = 0
           v_verba_ant = 0.

    FOR EACH int-solicitacao NO-LOCK
        WHERE int-solicitacao.dt-periodo-ini   = v_dat_tri_ant_ini 
        AND   int-solicitacao.dt-periodo-fim   = v_dat_tri_ant_fim 
        AND   int-solicitacao.cod-emitente     = int-cc-benef.canal
        AND   int-solicitacao.tipo-beneficio   = int-cc-benef.tipo-beneficio
        AND   int-solicitacao.Ajuste           = NO
        AND   int-solicitacao.desc-forma-pagto = "Dinheiro"
        AND   int-solicitacao.log-historica    = NO:
    
        IF  int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004 THEN NEXT.
        IF  int-solicitacao.SituacaoSolicitacaoBeneficio = 993520006 THEN NEXT.
        
        ASSIGN v_verba_ant = v_verba_ant + int-solicitacao.ValorSolicitado.
    END.
     
    ASSIGN v_verba_tot                       = v_verba_ant + int-cc-benef.VerbaCalculada
           v_verba_aux                       = int-cc-benef.VerbaCalculada
           int-cc-benef.VerbaPeriodoAnterior = v_verba_ant.

    EMPTY TEMP-TABLE tt_integr_apb_lote_impl.
    EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl_3.
    EMPTY TEMP-TABLE tt_integr_apb_aprop_ctbl_pend.
    EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl3v.
    EMPTY TEMP-TABLE tt_log_erros_atualiz.

    ASSIGN v_refer = "".

    RUN pi-busca-referencia (INPUT  "BNEF",
                             INPUT  "101",
                             OUTPUT v_refer).

    CREATE tt_integr_apb_lote_impl.
    ASSIGN tt_integr_apb_lote_impl.tta_cod_estab         = "101"
           tt_integr_apb_lote_impl.tta_cod_refer         = v_refer.

    ASSIGN tt_integr_apb_lote_impl.tta_dat_transacao     = TODAY /* v_today - teste */
           tt_integr_apb_lote_impl.tta_ind_origin_tit_ap = "APB"
           tt_integr_apb_lote_impl.tta_cod_empresa       = "1".

    VALIDATE tt_integr_apb_lote_impl.

    ASSIGN v_cod_tit_ap = string(int-cc-benef.tipo-beneficio) 
                        + int-cc-benef.unid-neg 
                        + string(MONTH(int-cc-benef.dt-periodo-fim),"99") 
                        + SUBSTRING(STRING(YEAR(int-cc-benef.dt-periodo-fim),"9999"),3,2).

    CREATE tt_integr_apb_item_lote_impl_3.
    ASSIGN tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl     = recid(tt_integr_apb_lote_impl)
           tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote     = recid(tt_integr_apb_item_lote_impl_3)
           tt_integr_apb_item_lote_impl_3.tta_num_seq_refer                = 1
           tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor               = int-cc-benef.canal
           tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto              = "VM"
           tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto                = "U"
           tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap                   = v_cod_tit_ap
           tt_integr_apb_item_lote_impl_3.tta_cod_parcela                  = "01"
           tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto               = TODAY
           tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap            = int-cc-benef.dt-vencimento
           tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto               = int-cc-benef.dt-vencimento
           tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto              = "30" /* boleto */
           tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ               = "real"
           tt_integr_apb_item_lote_impl_3.tta_val_tit_ap                   = v_verba_tot
           tt_integr_apb_item_lote_impl_3.tta_cod_portador                 = "999"
           tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ         = 1.

    VALIDATE tt_integr_apb_item_lote_impl_3.

    ASSIGN v_aux_val_rateio = 0.

    FIND FIRST b-int-solicitacao-2 NO-LOCK
        WHERE b-int-solicitacao-2.dt-periodo-ini        = int-cc-benef.dt-periodo-ini
        AND   b-int-solicitacao-2.dt-periodo-fim        = int-cc-benef.dt-periodo-fim
        AND   b-int-solicitacao-2.cod-emitente          = int-cc-benef.canal
        AND   b-int-solicitacao-2.tipo-beneficio        = int-cc-benef.tipo-beneficio
        AND   b-int-solicitacao-2.desc-forma-pagto      = "Dinheiro"
        AND   b-int-solicitacao-2.Ajuste                = YES
        AND   b-int-solicitacao-2.CodigoUnidadeNegocio <> "ADM" 
        AND   b-int-solicitacao-2.ValorAprovado         = 0 NO-ERROR.

    IF  NOT AVAIL b-int-solicitacao-2 THEN DO: /* s¢ faz caso n∆o seja calculado zero */

        FOR EACH int-solicitacao NO-LOCK
            WHERE int-solicitacao.dt-periodo-ini        = int-cc-benef.dt-periodo-ini
            AND   int-solicitacao.dt-periodo-fim        = int-cc-benef.dt-periodo-fim
            AND   int-solicitacao.cod-emitente          = int-cc-benef.canal
            AND   int-solicitacao.tipo-beneficio        = int-cc-benef.tipo-beneficio
            AND   int-solicitacao.desc-forma-pagto      = "Dinheiro"
            AND   int-solicitacao.Ajuste                = YES
            AND   int-solicitacao.CodigoUnidadeNegocio <> "ADM":
    
            ASSIGN v_perc_rateio = 0
                   v_val_rateio  = 0.
    
            ASSIGN v_perc_rateio = ((int-solicitacao.ValorAprovado) * 100) / v_verba_aux.
    
            RUN esp/es0018p.p (INPUT "es5600",
                               INPUT 1,
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
            FIND FIRST tt-prog-ponto 
                WHERE entry(1,tt-prog-ponto.conteudo,";") = int-cc-benef.categoria 
                AND   entry(2,tt-prog-ponto.conteudo,";") = int-solicitacao.CodigoUnidadeNegocio 
                NO-LOCK NO-ERROR.
    
            IF  AVAIL tt-prog-ponto THEN
                ASSIGN v_cod_cta_ctbl  = entry(3,tt-prog-ponto.conteudo,";")
                       v_cod_ccusto    = entry(4,tt-prog-ponto.conteudo,";")
                       v_cod_tip_fluxo = entry(5,tt-prog-ponto.conteudo,";").
            ELSE DO:
                ASSIGN v_seq_erro_aux = v_seq_erro_aux + 1.
    
                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = v_seq_erro_aux
                       tt-erro.canal    = int-cc-benef.canal
                       tt-erro.tipo     = 1
                       tt-erro.cd-erro  = 17006
                       tt-erro.mensagem = "N∆o localizado ES0018 para a categoria " + int-cc-benef.categoria + " e unidade de neg¢cio " + int-solicitacao.CodigoUnidadeNegocio + " Ponto: es5600 / 1 .".
    
                NEXT.
            END.
    
            ASSIGN v_val_rateio = (v_verba_tot * v_perc_rateio) / 100.
    
            CREATE tt_integr_apb_aprop_ctbl_pend.
            ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote  = recid(tt_integr_apb_item_lote_impl_3)
                   tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend      = ?
                   tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend = ?
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc            = int-solicitacao.CodigoUnidadeNegocio
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ      = v_cod_tip_fluxo
                   tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl            = v_val_rateio
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_pais                  = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_federac          = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto               = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto         = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl        = "PADRAO"
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl              = v_cod_cta_ctbl
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto          = "PADRAO"
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                = v_cod_ccusto.
    
            ASSIGN v_aux_val_rateio = v_aux_val_rateio + v_val_rateio.
    
            VALIDATE tt_integr_apb_aprop_ctbl_pend.
        END.

        ASSIGN v_dif_rat = v_aux_val_rateio - v_verba_tot.
    
        IF   v_dif_rat <> 0 THEN DO:
        
            FIND LAST tt_integr_apb_aprop_ctbl_pend EXCLUSIVE-LOCK NO-ERROR.
    
            IF  AVAIL tt_integr_apb_aprop_ctbl_pend THEN DO:
            
                IF  v_dif_rat > 0
                AND v_dif_rat <= 0.5 THEN
                    ASSIGN tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl = tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl - v_dif_rat.
    
                IF  v_dif_rat < 0
                AND v_dif_rat >= -0.5 THEN
                    ASSIGN tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl = tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl + (v_dif_rat * -1).
            END.
    
            VALIDATE tt_integr_apb_aprop_ctbl_pend.
        END.
    END.
    ELSE DO: /* calcular com base no rateio do tri anterior */

        FOR EACH int-solicitacao NO-LOCK
            WHERE int-solicitacao.dt-periodo-ini        = v_dat_tri_ant_ini
            AND   int-solicitacao.dt-periodo-fim        = v_dat_tri_ant_fim
            AND   int-solicitacao.cod-emitente          = int-cc-benef.canal
            AND   int-solicitacao.tipo-beneficio        = int-cc-benef.tipo-beneficio
            AND   int-solicitacao.desc-forma-pagto      = "Dinheiro"
            AND   int-solicitacao.Ajuste                = YES
            AND   int-solicitacao.CodigoUnidadeNegocio <> "ADM":
    
            ASSIGN v_verba_aux = v_verba_aux + int-solicitacao.ValorAprovado.
        END.

        FOR EACH int-solicitacao NO-LOCK
            WHERE int-solicitacao.dt-periodo-ini        = v_dat_tri_ant_ini
            AND   int-solicitacao.dt-periodo-fim        = v_dat_tri_ant_fim
            AND   int-solicitacao.cod-emitente          = int-cc-benef.canal
            AND   int-solicitacao.tipo-beneficio        = int-cc-benef.tipo-beneficio
            AND   int-solicitacao.desc-forma-pagto      = "Dinheiro"
            AND   int-solicitacao.Ajuste                = YES
            AND   int-solicitacao.CodigoUnidadeNegocio <> "ADM":
    
            ASSIGN v_perc_rateio = 0
                   v_val_rateio  = 0.
    
            ASSIGN v_perc_rateio = ((int-solicitacao.ValorAprovado) * 100) / v_verba_aux.
    
            RUN esp/es0018p.p (INPUT "es5600",
                               INPUT 1,
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
            FIND FIRST tt-prog-ponto 
                WHERE entry(1,tt-prog-ponto.conteudo,";") = int-cc-benef.categoria 
                AND   entry(2,tt-prog-ponto.conteudo,";") = int-solicitacao.CodigoUnidadeNegocio 
                NO-LOCK NO-ERROR.
    
            IF  AVAIL tt-prog-ponto THEN
                ASSIGN v_cod_cta_ctbl  = entry(3,tt-prog-ponto.conteudo,";")
                       v_cod_ccusto    = entry(4,tt-prog-ponto.conteudo,";")
                       v_cod_tip_fluxo = entry(5,tt-prog-ponto.conteudo,";").
            ELSE DO:
                ASSIGN v_seq_erro_aux = v_seq_erro_aux + 1.
    
                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = v_seq_erro_aux
                       tt-erro.canal    = int-cc-benef.canal
                       tt-erro.tipo     = 1
                       tt-erro.cd-erro  = 17006
                       tt-erro.mensagem = "N∆o localizado ES0018 para a categoria " + int-cc-benef.categoria + " e unidade de neg¢cio " + int-solicitacao.CodigoUnidadeNegocio + " Ponto: es5600 / 1 .".
    
                NEXT.
            END.
    
            ASSIGN v_val_rateio = (v_verba_tot * v_perc_rateio) / 100.
    
            CREATE tt_integr_apb_aprop_ctbl_pend.
            ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote  = recid(tt_integr_apb_item_lote_impl_3)
                   tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend      = ?
                   tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend = ?
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc            = int-solicitacao.CodigoUnidadeNegocio
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ      = v_cod_tip_fluxo
                   tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl            = v_val_rateio
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_pais                  = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_federac          = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto               = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto         = ""
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl        = "PADRAO"
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl              = v_cod_cta_ctbl
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto          = "PADRAO"
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                = v_cod_ccusto.
    
            ASSIGN v_aux_val_rateio = v_aux_val_rateio + v_val_rateio.
    
            VALIDATE tt_integr_apb_aprop_ctbl_pend.
        END.

        ASSIGN v_dif_rat = v_aux_val_rateio - v_verba_tot.
    
        IF   v_dif_rat <> 0 THEN DO:
        
            FIND LAST tt_integr_apb_aprop_ctbl_pend EXCLUSIVE-LOCK NO-ERROR.
    
            IF  AVAIL tt_integr_apb_aprop_ctbl_pend THEN DO:
            
                IF  v_dif_rat > 0
                AND v_dif_rat <= 0.5 THEN
                    ASSIGN tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl = tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl - v_dif_rat.
    
                IF  v_dif_rat < 0
                AND v_dif_rat >= -0.5 THEN
                    ASSIGN tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl = tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl + (v_dif_rat * -1).
            END.
    
            VALIDATE tt_integr_apb_aprop_ctbl_pend.
        END.
    END.

    run prgfin/apb/apb900zg.py persistent set v_hdl_aux.

    FOR EACH tt_integr_apb_item_lote_impl_3:
        CREATE tt_integr_apb_item_lote_impl3v.
        BUFFER-COPY tt_integr_apb_item_lote_impl_3 TO tt_integr_apb_item_lote_impl3v.
    END.

    EMPTY TEMP-TABLE tt_log_erros_tit_ap_alteracao.

    IF  CAN-FIND (FIRST tt_integr_apb_item_lote_impl3v) THEN DO:
        run pi_main_block_api_tit_ap_cria_4 in v_hdl_aux (Input 5,
                                                          Input "EMS",
                                                          input-output table tt_integr_apb_item_lote_impl3v).

        IF  CAN-FIND (FIRST tt_log_erros_atualiz) THEN DO:
            FOR EACH tt_log_erros_atualiz:
                ASSIGN v_seq_erro_aux = v_seq_erro_aux + 1.

                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = v_seq_erro_aux
                       tt-erro.canal    = int-cc-benef.canal
                       tt-erro.tipo     = 1
                       tt-erro.cd-erro  = 17006
                       tt-erro.mensagem = tt_log_erros_atualiz.ttv_des_msg_erro .

                NEXT.
            END.
        END.
        ELSE DO:
            FIND FIRST tit_ap
                 WHERE tit_ap.cod_estab        = "101"
                 AND   tit_ap.cod_espec_docto  = "VM"
                 AND   tit_ap.cod_ser_docto    = "U"
                 AND   tit_ap.cdn_fornecedor   = int-cc-benef.canal
                 AND   tit_ap.cod_tit_ap       = v_cod_tit_ap
                 AND   tit_ap.cod_parcela      = "01" NO-LOCK NO-ERROR.

            IF  NOT AVAIL tit_ap THEN DO:
                ASSIGN v_seq_erro_aux = v_seq_erro_aux + 1.

                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = v_seq_erro_aux
                       tt-erro.canal    = int-cc-benef.canal
                       tt-erro.tipo     = 1
                       tt-erro.cd-erro  = 17006
                       tt-erro.mensagem = "T°tulo n∆o foi criado para estab 101, espÇcie VM, sÇrie U, c¢digo " + v_cod_tit_ap + " e parcela 01 ." .
            END.
            ELSE DO:
                ASSIGN int-cc-benef.num_id_tit_ap = tit_ap.num_id_tit_ap.

                /* in°cio criaá∆o hist¢rico dos ajustes nas unidades */
                EMPTY TEMP-TABLE tt-int-solicitacao.

                FOR EACH int-solicitacao EXCLUSIVE-LOCK
                    WHERE int-solicitacao.dt-periodo-ini        = int-cc-benef.dt-periodo-ini
                    AND   int-solicitacao.dt-periodo-fim        = int-cc-benef.dt-periodo-fim
                    AND   int-solicitacao.cod-emitente          = int-cc-benef.canal         
                    AND   int-solicitacao.CodigoUnidadeNegocio <> "ADM"
                    AND   int-solicitacao.ajuste                = YES
                    AND   int-solicitacao.log-historica         = NO:
                
                    ASSIGN v_prefixo = "AJUSTES - ".

                    CREATE tt-int-solicitacao.
                    BUFFER-COPY int-solicitacao EXCEPT CodigoSolicitacaoBeneficio TO tt-int-solicitacao.
                    ASSIGN tt-int-solicitacao.CodigoSolicitacaoBeneficio = v_prefixo + int-solicitacao.CodigoSolicitacaoBeneficio
                           tt-int-solicitacao.log-historica              = YES.
                
                    ASSIGN int-solicitacao.CodigoUnidadeNegocio = "ADM".
                END.
                
                FOR EACH tt-int-solicitacao:
                    CREATE b-int-solicitacao.
                    BUFFER-COPY tt-int-solicitacao TO b-int-solicitacao.
                END.
                /* fim criaá∆o hist¢rico dos ajustes nas unidades */

                /* in°cio criaá∆o historico aá‰es trimestre anterior */
                EMPTY TEMP-TABLE tt-int-solicitacao.

                FOR EACH int-solicitacao EXCLUSIVE-LOCK
                    WHERE int-solicitacao.dt-periodo-ini                = v_dat_tri_ant_ini
                    AND   int-solicitacao.dt-periodo-fim                = v_dat_tri_ant_fim
                    AND   int-solicitacao.cod-emitente                  = int-cc-benef.canal
                    AND  (int-solicitacao.SituacaoSolicitacaoBeneficio <> 993520006
                    AND   int-solicitacao.SituacaoSolicitacaoBeneficio <> 993520004)
                    AND   int-solicitacao.ajuste                        = NO
                    AND   int-solicitacao.log-historica                 = NO:
                
                    RUN pi-retorna-trimestre-historico (INPUT int-solicitacao.dt-periodo-fim,
                                                        OUTPUT c-prefixo).
                
                    CREATE tt-int-solicitacao.
                    BUFFER-COPY int-solicitacao EXCEPT CodigoSolicitacaoBeneficio TO tt-int-solicitacao.
                    ASSIGN tt-int-solicitacao.CodigoSolicitacaoBeneficio = c-prefixo + int-solicitacao.CodigoSolicitacaoBeneficio
                           tt-int-solicitacao.log-historica              = YES.
                
                    ASSIGN int-solicitacao.dt-periodo-ini         = int-cc-benef.dt-periodo-ini
                           int-solicitacao.dt-periodo-fim         = int-cc-benef.dt-periodo-fim
                           int-solicitacao.vl-empenho-transferido = int-solicitacao.ValorSolicitado
                           int-solicitacao.vl-empenho-pago        = 0
                           int-solicitacao.ValorPago              = 0
                           int-solicitacao.Vl-Abatido-apb         = 0
                           int-solicitacao.CodigoUnidadeNegocio   = "ADM".
                END.
                
                FOR EACH tt-int-solicitacao:
                    CREATE b-int-solicitacao.
                    BUFFER-COPY tt-int-solicitacao TO b-int-solicitacao.
                END.
                /* fim criaá∆o historico aá‰es trimestre anterior */

                /* setar conta corrente do trimestre anterior como inativa */
                FIND FIRST b-int-cc-benef
                   WHERE b-int-cc-benef.dt-periodo-ini = v_dat_tri_ant_ini
                   AND   b-int-cc-benef.dt-periodo-fim = v_dat_tri_ant_fim
                   AND   b-int-cc-benef.id-status      = 1
                   AND   b-int-cc-benef.tp-movto       = int-cc-benef.tp-movto
                   AND   b-int-cc-benef.canal          = int-cc-benef.canal
                   AND   b-int-cc-benef.unid-neg       = int-cc-benef.unid-neg
                   AND   b-int-cc-benef.tipo-beneficio = int-cc-benef.tipo-beneficio EXCLUSIVE-LOCK NO-ERROR.

                IF  AVAIL b-int-cc-benef THEN do:
                    ASSIGN b-int-cc-benef.id-status = 2.

                    FIND FIRST b_tit_ap
                        WHERE b_tit_ap.cod_estab     = b-int-cc-benef.cod_estab
                        AND   b_tit_ap.num_id_tit_ap = b-int-cc-benef.num_id_tit_ap NO-LOCK NO-ERROR.

                    IF  AVAIL b_tit_ap THEN DO:

                        EMPTY TEMP-TABLE tt_tit_ap_alteracao_base_aux_1.
                        EMPTY TEMP-TABLE tt_tit_ap_alteracao_rateio.
                        EMPTY TEMP-TABLE tt_log_erros_tit_ap_alteracao.

                        RUN pi-busca-referencia (INPUT  "BNEF",
                                                 INPUT  b_tit_ap.cod_estab,
                                                 OUTPUT v_refer).

                        create tt_tit_ap_alteracao_base_aux_1.
                        assign tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren             = v_cod_usuar_corren
                               tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                  = b_tit_ap.cod_empresa
                               tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                    = b_tit_ap.cod_estab
                               tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap                = b_tit_ap.num_id_tit_ap
                               tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                   = recid(tt_tit_ap_alteracao_base_aux_1)
                               tt_tit_ap_alteracao_base_aux_1.tta_cdn_fornecedor               = b_tit_ap.cdn_fornecedor
                               tt_tit_ap_alteracao_base_aux_1.tta_cod_espec_docto              = b_tit_ap.cod_espec_docto
                               tt_tit_ap_alteracao_base_aux_1.tta_cod_ser_docto                = b_tit_ap.cod_ser_docto
                               tt_tit_ap_alteracao_base_aux_1.tta_cod_tit_ap                   = b_tit_ap.cod_tit_ap
                               tt_tit_ap_alteracao_base_aux_1.tta_cod_parcela                  = b_tit_ap.cod_parcela
                               tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                = TODAY
                               tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                    = v_refer 
                               tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap               = 0
                               tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto               = b_tit_ap.dat_emis_docto
                               tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap            = b_tit_ap.dat_vencto_tit_ap
                               tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto               = b_tit_ap.dat_prev_pagto
                               tt_tit_ap_alteracao_base_aux_1.tta_dat_ult_pagto                = b_tit_ap.dat_ult_pagto
                               tt_tit_ap_alteracao_base_aux_1.tta_num_dias_atraso              = b_tit_ap.num_dias_atraso
                               tt_tit_ap_alteracao_base_aux_1.tta_val_perc_multa_atraso        = b_tit_ap.val_perc_multa_atraso
                               tt_tit_ap_alteracao_base_aux_1.tta_val_juros_dia_atraso         = b_tit_ap.val_juros_dia_atraso
                               tt_tit_ap_alteracao_base_aux_1.tta_val_perc_juros_dia_atraso    = b_tit_ap.val_perc_juros_dia_atraso
                               tt_tit_ap_alteracao_base_aux_1.tta_dat_desconto                 = b_tit_ap.dat_desconto
                               tt_tit_ap_alteracao_base_aux_1.tta_val_perc_desc                = b_tit_ap.val_perc_desc
                               tt_tit_ap_alteracao_base_aux_1.tta_val_desconto                 = b_tit_ap.val_desconto
                               tt_tit_ap_alteracao_base_aux_1.tta_cod_portador                 = b_tit_ap.cod_portador
                               tt_tit_ap_alteracao_base_aux_1.tta_log_pagto_bloqdo             = b_tit_ap.log_pagto_bloqdo
                               tt_tit_ap_alteracao_base_aux_1.tta_cod_seguradora               = b_tit_ap.cod_seguradora
                               tt_tit_ap_alteracao_base_aux_1.tta_cod_apol_seguro              = b_tit_ap.cod_apol_seguro
                               tt_tit_ap_alteracao_base_aux_1.tta_cod_arrendador               = b_tit_ap.cod_arrendador
                               tt_tit_ap_alteracao_base_aux_1.tta_cod_contrat_leas             = b_tit_ap.cod_contrat_leas
                               tt_tit_ap_alteracao_base_aux_1.tta_ind_tip_espec_docto          = b_tit_ap.ind_tip_espec_docto
                               tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ               = b_tit_ap.cod_indic_econ
                               tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap   = "Alteraá∆o"
                               tt_tit_ap_alteracao_base_aux_1.tta_cod_histor_padr              = ""
                               tt_tit_ap_alteracao_base_aux_1.tta_des_histor_padr              = "Apuraá∆o trimestral benef°cios - Zeramento tri anterior -> Programas chamadores: "
                                                                                               +  (IF  PROGRAM-NAME( 1) <> ? THEN PROGRAM-NAME( 1) ELSE "") + chr(10)
                                                                                               +  (IF  PROGRAM-NAME( 2) <> ? THEN PROGRAM-NAME( 2) ELSE "") + chr(10)
                                                                                               +  (IF  PROGRAM-NAME( 3) <> ? THEN PROGRAM-NAME( 3) ELSE "") + chr(10)
                                                                                               +  (IF  PROGRAM-NAME( 4) <> ? THEN PROGRAM-NAME( 4) ELSE "") + chr(10)
                                                                                               +  (IF  PROGRAM-NAME( 5) <> ? THEN PROGRAM-NAME( 5) ELSE "") + chr(10)
                                                                                               +  (IF  PROGRAM-NAME( 6) <> ? THEN PROGRAM-NAME( 6) ELSE "") + chr(10)
                                                                                               +  (IF  PROGRAM-NAME( 7) <> ? THEN PROGRAM-NAME( 7) ELSE "") + chr(10)
                                                                                               +  (IF  PROGRAM-NAME( 8) <> ? THEN PROGRAM-NAME( 8) ELSE "") + chr(10)
                                                                                               +  (IF  PROGRAM-NAME( 9) <> ? THEN PROGRAM-NAME( 9) ELSE "") + chr(10)
                                                                                               +  (IF  PROGRAM-NAME(10) <> ? THEN PROGRAM-NAME(10) ELSE "")
                               tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap               = b_tit_ap.ind_sit_tit_ap              
                               tt_tit_ap_alteracao_base_aux_1.tta_cod_forma_pagto              = b_tit_ap.cod_forma_pagto.

                               VALIDATE tt_tit_ap_alteracao_base_aux_1.

                        IF  CAN-FIND (FIRST tt_tit_ap_alteracao_base_aux_1)  THEN DO:
                            run prgfin/apb/apb767ze.py(input 1,
                                                       input "",
                                                       INPUT "",
                                                       input-output table tt_tit_ap_alteracao_base_aux_1,
                                                       input-output table tt_tit_ap_alteracao_rateio,
                                                       output table       tt_log_erros_tit_ap_alteracao).
                        END.
                    END.
                END.

                IF  CAN-FIND(FIRST tt_log_erros_tit_ap_alteracao 
                                WHERE  tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 6542  
                                  AND  tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 11834 
                                  AND  tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 20260 ) THEN DO:

                    FOR EACH tt_log_erros_tit_ap_alteracao:
                        ASSIGN v_seq_erro_aux = v_seq_erro_aux + 1.

                        CREATE tt-erro.
                        ASSIGN tt-erro.i-sequen = v_seq_erro_aux
                               tt-erro.canal    = int-cc-benef.canal
                               tt-erro.tipo     = 1
                               tt-erro.cd-erro  = 17006
                               tt-erro.mensagem = tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro.
                    END.                
                END.        
                ELSE DO:
                    ASSIGN v_seq_erro_aux = v_seq_erro_aux + 1.

                    CREATE tt-erro.
                    ASSIGN tt-erro.i-sequen = v_seq_erro_aux
                           tt-erro.canal    = int-cc-benef.canal
                           tt-erro.tipo     = 2
                           tt-erro.cd-erro  = 17006
                           tt-erro.mensagem = "Apuraá∆o efetuada com sucesso." .
                END.

                VALIDATE int-cc-benef.
                VALIDATE b-int-cc-benef.
            END.
        END.
    END.

END PROCEDURE.

PROCEDURE pi-busca-referencia:
    DEFINE INPUT PARAMETER  p-sigla       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER  p-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-refer       AS CHARACTER NO-UNDO.

    def var v_log_refer_uni AS LOGICAL format "Sim/N∆o" INITIAL YES NO-UNDO.
    def var v_cod_refer     AS CHARACTER format "x(10)" NO-UNDO.

    ASSIGN v_log_refer_uni = NO.

    REPEAT WHILE v_log_refer_uni = NO:

        run pi_retorna_sugestao_referencia (INPUT  p-sigla,
                                            OUTPUT v_cod_refer).

        run pi_verifica_refer_unica_apb (INPUT  p-cod-estabel,
                                         INPUT  v_cod_refer,
                                         INPUT  "lote_impl_tit_ap",
                                         INPUT  ?,
                                         OUTPUT v_log_refer_uni).
    END.

    ASSIGN p-refer = v_cod_refer.

END PROCEDURE.

PROCEDURE pi_retorna_sugestao_referencia:

    /************************ Parameter Definition Begin ************************/
               
    DEF INPUT  param p_ind_tip_atualiz AS CHARACTER format "X(08)" NO-UNDO.
    DEF OUTPUT param p_cod_refer       AS CHARACTER format "x(10)" NO-UNDO.

    DEF VAR v_num_aux   AS INTEGER NO-UNDO. 
    DEF VAR v_num_aux_2 AS INTEGER NO-UNDO. 
    DEF VAR v_num_cont  AS INTEGER NO-UNDO. 

    ASSIGN p_cod_refer = SUBSTRING(p_ind_tip_atualiz,1,4)
           v_num_aux_2 = INTEGER(this-procedure:handle).

    DO  v_num_cont = 1 TO 6:
        ASSIGN v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               p_cod_refer = p_cod_refer + chr(v_num_aux).
    END.

END PROCEDURE.

PROCEDURE pi_verifica_refer_unica_apb:

    DEF INPUT  PARAM p_cod_estab        AS CHARACTER FORMAT "x(3)"    NO-UNDO.
    DEF INPUT  PARAM p_cod_refer        AS CHARACTER FORMAT "x(10)"   NO-UNDO.
    DEF INPUT  PARAM p_cod_table        AS CHARACTER FORMAT "x(8)"    NO-UNDO.
    DEF INPUT  PARAM p_rec_movto_tit_ap AS RECID     FORMAT ">>>>>>9" NO-UNDO. 
    DEF OUTPUT PARAM p_log_refer_uni    AS LOGICAL   FORMAT "Sim/N∆o" NO-UNDO.

    DEF BUFFER b_antecip_pef_pend FOR antecip_pef_pend.
    DEF BUFFER b_lote_impl_tit_ap FOR lote_impl_tit_ap.
    DEF BUFFER b_lote_pagto       FOR lote_pagto.
    DEF BUFFER b_movto_tit_ap     FOR movto_tit_ap.

    /*************************** Buffer Definition End **************************/
    ASSIGN p_log_refer_uni = YES.

    find first b_antecip_pef_pend no-lock
         where b_antecip_pef_pend.cod_estab = p_cod_estab
           and b_antecip_pef_pend.cod_refer = p_cod_refer no-error.
    if  avail b_antecip_pef_pend then do:
        assign p_log_refer_uni = no.
        RETURN.
    end.
    find first b_lote_impl_tit_ap no-lock
         where b_lote_impl_tit_ap.cod_estab = p_cod_estab
           and b_lote_impl_tit_ap.cod_refer = p_cod_refer no-error.
    if  avail b_lote_impl_tit_ap then do:
        assign p_log_refer_uni = no.
        RETURN.
    end.
    find first b_lote_pagto no-lock
         where b_lote_pagto.cod_estab_refer = p_cod_estab
           and b_lote_pagto.cod_refer = p_cod_refer no-error.
    if  avail b_lote_pagto then do:
        assign p_log_refer_uni = no.
        RETURN.
    end.
    find first b_movto_tit_ap NO-LOCK where b_movto_tit_ap.cod_estab = p_cod_estab
           and b_movto_tit_ap.cod_refer = p_cod_refer
           and recid(b_movto_tit_ap) <> p_rec_movto_tit_ap no-error.
    if  avail b_movto_tit_ap then do:
        assign p_log_refer_uni = no.
        RETURN.
    end.

END PROCEDURE.

PROCEDURE pi-retorna-trimestre-historico:
    /* Objetivo: Quando uma solicitaá∆o Ç transferida de um trimestre para outro, Ç criada uma c¢pia e mantida
                 no trimestre que se encerra. Isso para que os programas que comp‰em saldo (quando vocà consulta o
                 o esesb008 por exemplo, ele deve compor o saldo considerando essa c¢pia que possui os valores atendidos
                 parcialmente ou n∆o nesse trimestre encerrado.
                 Para mantermos a relaá∆o entre eleas, o Guida da solicitaá∆o hist¢rica Ç exatamente o guid da solicitaá∆o 
                 que foi transferida, porÇm com o sufixo indicando que Ç hist¢rica; 
                 Ex: HIST_1T2016. 
                     neste caso, indica que em Abril, um solicitaá∆o do primeiro trimestre foi transferida para o segundo,
                     um c¢pia dela Ç mantida como HIST_1T2016 */

    DEF INPUT  PARAM p-data-fim-tri AS DATE NO-UNDO.
    DEF OUTPUT PARAM p-prefixo      AS CHAR NO-UNDO.

    CASE MONTH(p-data-fim-tri):
        WHEN 03 THEN ASSIGN p-prefixo = "H_1T" + string(YEAR(p-data-fim-tri), "9999") + "_".
        WHEN 06 THEN ASSIGN p-prefixo = "H_2T" + string(YEAR(p-data-fim-tri), "9999") + "_".
        WHEN 09 THEN ASSIGN p-prefixo = "H_3T" + string(YEAR(p-data-fim-tri), "9999") + "_".
        WHEN 12 THEN ASSIGN p-prefixo = "H_4T" + string(YEAR(p-data-fim-tri), "9999") + "_".
    END CASE.

END.
