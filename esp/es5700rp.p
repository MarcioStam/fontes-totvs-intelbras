 /******************************************************************************************
**  Programa: es5700rp.p
**  Funcao..: Extracao de dados para registro Sped 1601.
**  Autor...: Amdrey M Oliveira
**  Data....: 13/07/2023
******************************************************************************************/
/* include de controle de vers∆o */
{include/i-prgvrs.i es5700rp 1.00.00.001}
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
    FIELD data-ini     AS DATE
    FIELD data-fim     AS DATE.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

/* recebimento de parametros */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* definiá∆o de variaveis */                                                
DEF VAR h-acomp           AS HANDLE                                                   NO-UNDO.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD i-sequen         AS INT
    FIELD tipo             AS INT
    FIELD canal            LIKE int-cc-benef.canal
    FIELD cd-erro          AS INT
    FIELD mensagem         AS CHAR FORMAT "x(255)".

DEF VAR v_cod_estab_orig AS CHAR FORMAT "x(3)":U LABEL "Estabelecimento" COLUMN-LABEL "Estabelecimento" NO-UNDO.
DEF VAR v_ind_orig       AS CHAR                                                                        NO-UNDO.
DEF VAR v_tipo_nota      AS CHAR                                                                        NO-UNDO.
DEF VAR v_arq_extracao   AS CHAR                                                                        NO-UNDO.

DEF BUFFER b_val_tit_acr       FOR val_tit_acr.
DEF BUFFER b_val_movto_tit_acr FOR val_movto_tit_acr.
DEF BUFFER b_movto_tit_acr     FOR movto_tit_acr.
DEF BUFFER b2_movto_tit_acr    FOR movto_tit_acr.
DEF BUFFER b_tit_acr           FOR tit_acr.

DEF TEMP-TABLE tt_origem_acr NO-UNDO
    FIELD cod_estab          LIKE tit_acr.cod_estab          
    FIELD cod_espec_docto    LIKE tit_acr.cod_espec_docto    
    FIELD cod_ser_docto      LIKE tit_acr.cod_ser_docto      
    FIELD cod_tit_acr        LIKE tit_acr.cod_tit_acr        
    FIELD cod_parcela        LIKE tit_acr.cod_parcela        
    FIELD ind_trans_acr      LIKE movto_tit_acr.ind_trans_acr
    FIELD cod_portador       LIKE movto_tit_acr.cod_portador
    FIELD cdn_cliente        LIKE tit_acr.cdn_cliente
    FIELD nom_abrev          LIKE tit_acr.nom_abrev
    FIELD dat_movto_fluxo_cx LIKE movto_fluxo_cx.dat_movto_fluxo_cx
    FIELD val_origem         LIKE val_tit_acr.val_origin_tit_acr
    FIELD tipo_nota          AS CHAR.


FIND FIRST mguni.empresa NO-LOCK   
     WHERE empresa.ep-codigo = v_cdn_empres_usuar NO-ERROR.  

ASSIGN c-versao       = "1.00"
       c-revisao      = "000"
       c-empresa      = empresa.razao-social
       c-programa     = "es5700rp.p"
       c-titulo-relat = "Extraá∆o Dados SPED 1601".
       
/************** BLOCO PRINCIPAL ***************/
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar IN h-acomp (INPUT "In°cio Extraá∆o"). 

FIND FIRST tt-param NO-ERROR.

RUN pi-acompanhar IN h-acomp (INPUT "Extraá∆o: " /*+ tt-param.arquivo-import*/).

EMPTY TEMP-TABLE tt-erro.

ASSIGN v_ind_orig = "MCT" + "," + "MCM" + "," + "MEM".

/* importar dados do arquivo csv separado por ponto e v°rgula */
RUN pi_carrega_registros.

RUN pi_gera_extracao.

/*
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
*/

{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

PUT UNFORMATTED "Arquivo " v_arq_extracao " gerado com sucesso !" SKIP.

{include/i-rpclo.i}

RUN pi-finalizar IN h-acomp.

RETURN "OK":U.


PROCEDURE pi_carrega_registros: /* importar dados da planilha */

    EMPTY TEMP-TABLE tt_origem_acr.

    FOR EACH movto_fluxo_cx NO-LOCK
        WHERE movto_fluxo_cx.num_fluxo_cx        = 0
        AND   movto_fluxo_cx.dat_movto_fluxo_cx >= tt-param.data-ini
        AND   movto_fluxo_cx.dat_movto_fluxo_cx <= tt-param.data-fim
        AND   movto_fluxo_cx.cod_modul_dtsul     = "ACR":

        ASSIGN v_cod_estab_orig = movto_fluxo_cx.cod_estab.

        IF  movto_fluxo_cx.cod_estab_orig <> "" THEN
            ASSIGN v_cod_estab_orig = movto_fluxo_cx.cod_estab_orig.

        DO  v_num_count = 1 TO NUM-ENTRIES(v_ind_orig):

            FOR EACH orig_movto_fluxo_cx NO-LOCK
                WHERE orig_movto_fluxo_cx.num_fluxo_cx            = movto_fluxo_cx.num_fluxo_cx
                AND   orig_movto_fluxo_cx.cod_modul_dtsul         = "ACR"
                AND   orig_movto_fluxo_cx.ind_orig_movto_fluxo_cx = ENTRY(v_num_count, v_ind_orig)
                AND   orig_movto_fluxo_cx.num_id_movto_fluxo_cx   = movto_fluxo_cx.num_id_movto_fluxo_cx
                USE-INDEX orgmvtfl_id
                BREAK BY orig_movto_fluxo_cx.num_id_orig_movto_fluxo_cx:

                IF  orig_movto_fluxo_cx.ind_orig_movto_fluxo_cx = "MCT" THEN DO:
                    
                    FIND val_tit_acr NO-LOCK USE-INDEX vlttcr_num_id
                        WHERE val_tit_acr.cod_estab          = v_cod_estab_orig
                        AND   val_tit_acr.num_id_val_tit_acr = orig_movto_fluxo_cx.num_id_orig_movto_fluxo_cx NO-ERROR.

                    if  avail val_tit_acr then do:
                        find LAST movto_tit_acr no-lock
                            where movto_tit_acr.cod_estab      = val_tit_acr.cod_estab
                            and   movto_tit_acr.num_id_tit_acr = val_tit_acr.num_id_tit_acr
                            and  (movto_tit_acr.ind_trans_acr  = "Implantaá∆o" /*l_implantacao*/
                            /*and  (movto_tit_acr.ind_trans_acr  = "Alteraá∆o n∆o Cont†bil" /*l_implantacao*/ 
                            or    movto_tit_acr.ind_trans_acr  = "Renegociaá∆o" /*l_renegociacao*/ */ ) no-error.

                        if  avail movto_tit_acr then do:
                            find tit_acr no-lock
                                 where tit_acr.cod_estab      = val_tit_acr.cod_estab
                                 and   tit_acr.num_id_tit_acr = val_tit_acr.num_id_tit_acr no-error.

                            if  avail tit_acr THEN DO:

                                RUN pi_nota_origem.

                                IF  tit_acr.ind_tip_espec_docto = "Antecipaá∆o" then DO:

                                    RUN pi_tipo_nota.

                                    CREATE tt_origem_acr.
                                    ASSIGN tt_origem_acr.cod_estab          = tit_acr.cod_estab                
                                           tt_origem_acr.cod_espec_docto    = tit_acr.cod_espec_docto          
                                           tt_origem_acr.cod_ser_docto      = tit_acr.cod_ser_docto            
                                           tt_origem_acr.cod_tit_acr        = tit_acr.cod_tit_acr              
                                           tt_origem_acr.cod_parcela        = tit_acr.cod_parcela              
                                           tt_origem_acr.ind_trans_acr      = movto_tit_acr.ind_trans_acr      
                                           tt_origem_acr.cod_portador       = movto_tit_acr.cod_portador       
                                           tt_origem_acr.cdn_cliente        = tit_acr.cdn_cliente              
                                           tt_origem_acr.nom_abrev          = tit_acr.nom_abrev                
                                           tt_origem_acr.dat_movto_fluxo_cx = movto_fluxo_cx.dat_movto_fluxo_cx
                                           tt_origem_acr.val_origem         = val_tit_acr.val_origin_tit_acr - val_tit_acr.val_impto_retid
                                           tt_origem_acr.tipo_nota          = v_tipo_nota.
                                END.
                                /*
                                else DO:
                                    RUN pi_tipo_nota.

                                    CREATE tt_origem_acr.
                                    ASSIGN tt_origem_acr.cod_estab          = tit_acr.cod_estab                
                                           tt_origem_acr.cod_espec_docto    = tit_acr.cod_espec_docto          
                                           tt_origem_acr.cod_ser_docto      = tit_acr.cod_ser_docto            
                                           tt_origem_acr.cod_tit_acr        = tit_acr.cod_tit_acr              
                                           tt_origem_acr.cod_parcela        = tit_acr.cod_parcela              
                                           tt_origem_acr.ind_trans_acr      = movto_tit_acr.ind_trans_acr      
                                           tt_origem_acr.cod_portador       = movto_tit_acr.cod_portador       
                                           tt_origem_acr.cdn_cliente        = tit_acr.cdn_cliente              
                                           tt_origem_acr.nom_abrev          = tit_acr.nom_abrev                
                                           tt_origem_acr.dat_movto_fluxo_cx = movto_fluxo_cx.dat_movto_fluxo_cx
                                           tt_origem_acr.val_origem         = val_tit_acr.val_sdo_tit_acr
                                           tt_origem_acr.tipo_nota          = v_tipo_nota.
                                END.
                                */
                            END.
                        end.
                        else
                            next.

                        find last param_geral_cfl no-lock no-error.

                        if  avail param_geral_cfl
                        and param_geral_cfl.cod_finalid_econ <> val_tit_acr.cod_finalid_econ then do:
                            
                            find first b_val_tit_acr
                                where b_val_tit_acr.cod_estab            = val_tit_acr.cod_estab
                                and   b_val_tit_acr.num_id_tit_acr       = val_tit_acr.num_id_tit_acr
                                and   b_val_tit_acr.cod_finalid_econ     = param_geral_cfl.cod_finalid_econ
                                and   b_val_tit_acr.cod_unid_negoc       = val_tit_acr.cod_unid_negoc
                                and   b_val_tit_acr.cod_tip_fluxo_financ = val_tit_acr.cod_tip_fluxo_financ no-lock no-error.

                            if  avail b_val_tit_acr then do:
                                find LAST movto_tit_acr no-lock
                                    where movto_tit_acr.cod_estab      = b_val_tit_acr.cod_estab
                                    and   movto_tit_acr.num_id_tit_acr = b_val_tit_acr.num_id_tit_acr
                                    and  (movto_tit_acr.ind_trans_acr  = "Implantaá∆o"
                                    /*and  (movto_tit_acr.ind_trans_acr  = "Alteraá∆o n∆o Cont†bil"
                                    or    movto_tit_acr.ind_trans_acr  = "Renegociaá∆o"*/) no-error.

                                if  avail movto_tit_acr then do:
                                    find tit_acr no-lock
                                        where tit_acr.cod_estab    = b_val_tit_acr.cod_estab
                                        and tit_acr.num_id_tit_acr = b_val_tit_acr.num_id_tit_acr no-error.

                                    if  avail tit_acr THEN DO:
                                        RUN pi_nota_origem.

                                        IF  tit_acr.ind_tip_espec_docto = "Antecipaá∆o" then DO:  
                                            RUN pi_tipo_nota.

                                            CREATE tt_origem_acr.
                                            ASSIGN tt_origem_acr.cod_estab          = tit_acr.cod_estab                
                                                   tt_origem_acr.cod_espec_docto    = tit_acr.cod_espec_docto          
                                                   tt_origem_acr.cod_ser_docto      = tit_acr.cod_ser_docto            
                                                   tt_origem_acr.cod_tit_acr        = tit_acr.cod_tit_acr              
                                                   tt_origem_acr.cod_parcela        = tit_acr.cod_parcela              
                                                   tt_origem_acr.ind_trans_acr      = movto_tit_acr.ind_trans_acr      
                                                   tt_origem_acr.cod_portador       = movto_tit_acr.cod_portador       
                                                   tt_origem_acr.cdn_cliente        = tit_acr.cdn_cliente              
                                                   tt_origem_acr.nom_abrev          = tit_acr.nom_abrev                
                                                   tt_origem_acr.dat_movto_fluxo_cx = movto_fluxo_cx.dat_movto_fluxo_cx
                                                   tt_origem_acr.val_origem         = b_val_tit_acr.val_origin_tit_acr - b_val_tit_acr.val_impto_retid
                                                   tt_origem_acr.tipo_nota          = v_tipo_nota.
                                        END.
                                        /*
                                        else DO:
                                            RUN pi_tipo_nota.

                                            CREATE tt_origem_acr.
                                            ASSIGN tt_origem_acr.cod_estab          = tit_acr.cod_estab                
                                                   tt_origem_acr.cod_espec_docto    = tit_acr.cod_espec_docto          
                                                   tt_origem_acr.cod_ser_docto      = tit_acr.cod_ser_docto            
                                                   tt_origem_acr.cod_tit_acr        = tit_acr.cod_tit_acr              
                                                   tt_origem_acr.cod_parcela        = tit_acr.cod_parcela              
                                                   tt_origem_acr.ind_trans_acr      = movto_tit_acr.ind_trans_acr      
                                                   tt_origem_acr.cod_portador       = movto_tit_acr.cod_portador       
                                                   tt_origem_acr.cdn_cliente        = tit_acr.cdn_cliente              
                                                   tt_origem_acr.nom_abrev          = tit_acr.nom_abrev                
                                                   tt_origem_acr.dat_movto_fluxo_cx = movto_fluxo_cx.dat_movto_fluxo_cx
                                                   tt_origem_acr.val_origem         = b_val_tit_acr.val_sdo_tit_acr
                                                   tt_origem_acr.tipo_nota          = v_tipo_nota.
                                        END.
                                        */
                                    END.
                                end.
                                else
                                    next.
                            end.
                        end.
                    end.

                    if  not avail val_tit_acr then
                        next.
                end.
                else do:
                    find val_movto_tit_acr no-lock
                        where val_movto_tit_acr.cod_estab                = v_cod_estab_orig
                        and   val_movto_tit_acr.num_id_val_movto_tit_acr = orig_movto_fluxo_cx.num_id_orig_movto_fluxo_cx no-error.

                    if  avail val_movto_tit_acr then do:
                        find movto_tit_acr no-lock use-index mvtttcr_token
                            where movto_tit_acr.cod_estab            = val_movto_tit_acr.cod_estab
                            and   movto_tit_acr.num_id_movto_tit_acr = val_movto_tit_acr.num_id_movto_tit_acr no-error.

                        if  avail movto_tit_acr then do:

                            find tit_acr no-lock
                                where tit_acr.cod_estab      = movto_tit_acr.cod_estab
                                and   tit_acr.num_id_tit_acr = movto_tit_acr.num_id_tit_acr no-error.

                            if  avail tit_acr THEN DO:
                                RUN pi_nota_origem.

                                if  movto_tit_acr.ind_trans_acr = "Acerto Valor a Menor"
                                or  movto_tit_acr.ind_trans_acr = "Acerto Valor a Maior" then DO:
                                    RUN pi_tipo_nota.

                                    CREATE tt_origem_acr.
                                    ASSIGN tt_origem_acr.cod_estab          = tit_acr.cod_estab                
                                           tt_origem_acr.cod_espec_docto    = tit_acr.cod_espec_docto          
                                           tt_origem_acr.cod_ser_docto      = tit_acr.cod_ser_docto            
                                           tt_origem_acr.cod_tit_acr        = tit_acr.cod_tit_acr              
                                           tt_origem_acr.cod_parcela        = tit_acr.cod_parcela              
                                           tt_origem_acr.ind_trans_acr      = movto_tit_acr.ind_trans_acr      
                                           tt_origem_acr.cod_portador       = movto_tit_acr.cod_portador       
                                           tt_origem_acr.cdn_cliente        = tit_acr.cdn_cliente              
                                           tt_origem_acr.nom_abrev          = tit_acr.nom_abrev                
                                           tt_origem_acr.dat_movto_fluxo_cx = movto_fluxo_cx.dat_movto_fluxo_cx
                                           tt_origem_acr.val_origem         = val_movto_tit_acr.val_ajust_val_tit_acr
                                           tt_origem_acr.tipo_nota          = v_tipo_nota.
                                END.

                                if  movto_tit_acr.ind_trans_acr = "Liquidaá∆o"
                                or  movto_tit_acr.ind_trans_acr = "Liquidaá∆o Enctro Ctas" then DO:
                                    RUN pi_tipo_nota.

                                    CREATE tt_origem_acr.
                                    ASSIGN tt_origem_acr.cod_estab          = tit_acr.cod_estab                
                                           tt_origem_acr.cod_espec_docto    = tit_acr.cod_espec_docto          
                                           tt_origem_acr.cod_ser_docto      = tit_acr.cod_ser_docto            
                                           tt_origem_acr.cod_tit_acr        = tit_acr.cod_tit_acr              
                                           tt_origem_acr.cod_parcela        = tit_acr.cod_parcela              
                                           tt_origem_acr.ind_trans_acr      = movto_tit_acr.ind_trans_acr      
                                           tt_origem_acr.cod_portador       = movto_tit_acr.cod_portador       
                                           tt_origem_acr.cdn_cliente        = tit_acr.cdn_cliente              
                                           tt_origem_acr.nom_abrev          = tit_acr.nom_abrev                
                                           tt_origem_acr.dat_movto_fluxo_cx = movto_fluxo_cx.dat_movto_fluxo_cx
                                           tt_origem_acr.val_origem         = val_movto_tit_acr.val_liquidac_tit_acr
                                                                            + val_movto_tit_acr.val_multa_tit_acr
                                                                            + val_movto_tit_acr.val_juros
                                                                            + val_movto_tit_acr.val_cm_tit_acr
                                                                            - val_movto_tit_acr.val_despes_bcia
                                           tt_origem_acr.tipo_nota          = v_tipo_nota.
                                END.
                            END.
                        end.
                        else 
                            next.

                        find last param_geral_cfl no-lock no-error.
                        
                        if  avail param_geral_cfl
                        and param_geral_cfl.cod_finalid_econ <> val_movto_tit_acr.cod_finalid_econ then do:
                            
                            find first b_val_movto_tit_acr
                                where b_val_movto_tit_acr.cod_estab            = val_movto_tit_acr.cod_estab
                                and   b_val_movto_tit_acr.num_id_movto_tit_acr = val_movto_tit_acr.num_id_movto_tit_acr
                                and   b_val_movto_tit_acr.cod_finalid_econ     = param_geral_cfl.cod_finalid_econ
                                and   b_val_movto_tit_acr.cod_unid_negoc       = val_movto_tit_acr.cod_unid_negoc
                                and   b_val_movto_tit_acr.cod_tip_fluxo_financ = val_movto_tit_acr.cod_tip_fluxo_financ no-lock no-error.

                            if  avail b_val_movto_tit_acr then do:
                                
                                find movto_tit_acr no-lock use-index mvtttcr_token
                                    where movto_tit_acr.cod_estab            = b_val_movto_tit_acr.cod_estab
                                    and   movto_tit_acr.num_id_movto_tit_acr = b_val_movto_tit_acr.num_id_movto_tit_acr no-error.

                                if  avail movto_tit_acr then do:

                                    find tit_acr no-lock
                                        where tit_acr.cod_estab      = movto_tit_acr.cod_estab
                                        and   tit_acr.num_id_tit_acr = movto_tit_acr.num_id_tit_acr no-error.

                                    if  avail tit_acr THEN DO:
                                        RUN pi_nota_origem.

                                        if  movto_tit_acr.ind_trans_acr = "Acerto Valor a Menor"
                                        or  movto_tit_acr.ind_trans_acr = "Acerto Valor a Maior" then DO:
                                            RUN pi_tipo_nota.

                                            CREATE tt_origem_acr.
                                            ASSIGN tt_origem_acr.cod_estab          = tit_acr.cod_estab                
                                                   tt_origem_acr.cod_espec_docto    = tit_acr.cod_espec_docto          
                                                   tt_origem_acr.cod_ser_docto      = tit_acr.cod_ser_docto            
                                                   tt_origem_acr.cod_tit_acr        = tit_acr.cod_tit_acr              
                                                   tt_origem_acr.cod_parcela        = tit_acr.cod_parcela              
                                                   tt_origem_acr.ind_trans_acr      = movto_tit_acr.ind_trans_acr      
                                                   tt_origem_acr.cod_portador       = movto_tit_acr.cod_portador       
                                                   tt_origem_acr.cdn_cliente        = tit_acr.cdn_cliente              
                                                   tt_origem_acr.nom_abrev          = tit_acr.nom_abrev                
                                                   tt_origem_acr.dat_movto_fluxo_cx = movto_fluxo_cx.dat_movto_fluxo_cx
                                                   tt_origem_acr.val_origem         = b_val_movto_tit_acr.val_ajust_val_tit_acr
                                                   tt_origem_acr.tipo_nota          = v_tipo_nota.
                                        END.

                                        if  movto_tit_acr.ind_trans_acr = "Liquidaá∆o"
                                        or  movto_tit_acr.ind_trans_acr = "Liquidaá∆o Enctro Ctas" then DO:
                                            RUN pi_tipo_nota.

                                            CREATE tt_origem_acr.
                                            ASSIGN tt_origem_acr.cod_estab          = tit_acr.cod_estab                
                                                   tt_origem_acr.cod_espec_docto    = tit_acr.cod_espec_docto          
                                                   tt_origem_acr.cod_ser_docto      = tit_acr.cod_ser_docto            
                                                   tt_origem_acr.cod_tit_acr        = tit_acr.cod_tit_acr              
                                                   tt_origem_acr.cod_parcela        = tit_acr.cod_parcela              
                                                   tt_origem_acr.ind_trans_acr      = movto_tit_acr.ind_trans_acr      
                                                   tt_origem_acr.cod_portador       = movto_tit_acr.cod_portador       
                                                   tt_origem_acr.cdn_cliente        = tit_acr.cdn_cliente              
                                                   tt_origem_acr.nom_abrev          = tit_acr.nom_abrev                
                                                   tt_origem_acr.dat_movto_fluxo_cx = movto_fluxo_cx.dat_movto_fluxo_cx
                                                   tt_origem_acr.val_origem         = b_val_movto_tit_acr.val_liquidac_tit_acr
                                                                                    + b_val_movto_tit_acr.val_multa_tit_acr
                                                                                    + b_val_movto_tit_acr.val_juros
                                                                                    + b_val_movto_tit_acr.val_cm_tit_acr
                                                                                    - b_val_movto_tit_acr.val_despes_bcia
                                                   tt_origem_acr.tipo_nota          = v_tipo_nota.
                                        END.
                                    END.
                                end.
                                else 
                                    next.
                            end.    
                        end.
                    end.

                    if  not avail val_movto_tit_acr then
                        next.
                end.
            END.
        END.
    END.

END PROCEDURE.

PROCEDURE pi_tipo_nota:
    ASSIGN v_tipo_nota = "".

    FIND FIRST ser-estab NO-LOCK
         WHERE ser-estab.cod-estabel = nota-fiscal.cod-estabel
         AND   ser-estab.serie       = nota-fiscal.serie NO-ERROR.

    IF  AVAIL ser-estab THEN DO:
        IF  ser-estab.log-nf-eletro THEN DO:
            ASSIGN v_tipo_nota = "Mercadoria".
        END.
        ELSE DO:
            IF  substring(ser-estab.char-1,71,1) = "S" THEN
                ASSIGN v_tipo_nota = "Serviáo".
            ELSE
                ASSIGN v_tipo_nota = "Outros".
        END.
    END.

END PROCEDURE.


PROCEDURE pi_nota_origem:

    FIND FIRST nota-fiscal
        WHERE nota-fiscal.cod-estabel = tit_acr.cod_estab
        AND   nota-fiscal.serie       = tit_acr.cod_ser_docto
        AND   nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr NO-LOCK NO-ERROR.

    IF  NOT AVAIL nota-fiscal THEN DO:

        FIND FIRST b_movto_tit_acr no-lock
            where b_movto_tit_acr.cod_estab      = val_tit_acr.cod_estab
            and   b_movto_tit_acr.num_id_tit_acr = val_tit_acr.num_id_tit_acr
            and   b_movto_tit_acr.ind_trans_acr  = "Transf Estabelecimento" no-error.                            

        IF  AVAIL b_movto_tit_acr THEN DO:

            FIND FIRST b2_movto_tit_acr no-lock
                where b2_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab_tit_acr_pai
                and   b2_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr_pai NO-ERROR.
    
            IF  AVAIL b2_movto_tit_acr THEN DO:   
                FIND first b_tit_acr no-lock
                    where b_tit_acr.cod_estab      = b2_movto_tit_acr.cod_estab
                    and   b_tit_acr.num_id_tit_acr = b2_movto_tit_acr.num_id_tit_acr NO-ERROR.

                IF  AVAIL b_tit_acr THEN DO:
                    FIND FIRST nota-fiscal
                        WHERE nota-fiscal.cod-estabel = b_tit_acr.cod_estab
                        AND   nota-fiscal.serie       = b_tit_acr.cod_ser_docto
                        AND   nota-fiscal.nr-nota-fis = b_tit_acr.cod_tit_acr NO-LOCK NO-ERROR.
                END.
            END.
        END.
    END.

    IF  NOT AVAIL nota-fiscal THEN 
        NEXT.

END PROCEDURE.

PROCEDURE pi_gera_extracao:

    RUN esp/es0018p.p (INPUT "es5700",
                       INPUT 1,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    FOR EACH tt-prog-ponto NO-LOCK:
        IF  OPSYS = "UNIX":U THEN DO:
            IF  ENTRY(1, tt-prog-ponto.conteudo, ";":U) = "UNIX":U THEN
                ASSIGN v_arq_extracao = ENTRY(2, tt-prog-ponto.conteudo, ";":U) + "sped1601_" + string(day(tt-param.data-ini),"99") + string(MONTH(tt-param.data-ini),"99") + string(YEAR(tt-param.data-ini),"9999") + ".csv" .
        END.
        ELSE DO:
            IF  ENTRY(1, tt-prog-ponto.conteudo, ";":U) = "WINDOWS":U THEN
                ASSIGN v_arq_extracao = ENTRY(2, tt-prog-ponto.conteudo, ";":U) + "sped1601_" + string(day(tt-param.data-ini),"99") + string(MONTH(tt-param.data-ini),"99") + string(YEAR(tt-param.data-ini),"9999") + ".csv" .
        END.
    END.

    OUTPUT TO VALUE(v_arq_extracao) NO-CONVERT.
    
    PUT "Estab;Esp;Ser;Titulo;Parc;Trans;Tipo Nota;Port;Cod Cliente;Nome Abrev;Data Movto;Valor" skip.
    
    FOR EACH tt_origem_acr:
        PUT tt_origem_acr.cod_estab           ";"
            tt_origem_acr.cod_espec_docto     ";"
            tt_origem_acr.cod_ser_docto       ";"
            tt_origem_acr.cod_tit_acr         ";"
            tt_origem_acr.cod_parcela         ";"
            tt_origem_acr.ind_trans_acr       ";"
            tt_origem_acr.tipo_nota           ";"
            tt_origem_acr.cod_portador        ";"
            tt_origem_acr.cdn_cliente         ";"
            tt_origem_acr.nom_abrev           ";"
            tt_origem_acr.dat_movto_fluxo_cx  ";"
            tt_origem_acr.val_origem SKIP.       
    END.
    
    OUTPUT CLOSE.

END PROCEDURE.
