 /******************************************************************************************
**  Programa: esfas019rp.p
**  Funcao..: Inclus∆o/Exclus∆o Alocaá‰es de Bens
**  Autor...: Andrey Mauricio de Oliveira
**  Data....: 22/07/2020
**  Versao..: 1.00.00.000 - Versao Inicial.
******************************************************************************************/
{include/i-prgvrs.i esfas019rp 1.00.00.001}
{include/i-rpvar.i}
{utp/ut-glob.i}
{cdp/cdcfgmat.i} 

&GLOBAL-DEFINE RTF NO
&SCOPED-DEFINE pagesize 62  

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino        AS INTEGER
    FIELD arquivo        AS CHAR FORMAT "x(35)":U
    FIELD usuario        AS CHAR FORMAT "x(12)":U
    FIELD data-exec      AS DATE
    FIELD hora-exec      AS INTEGER
    FIELD arquivo-import AS CHAR FORMAT "x(256)"
    FIELD ind-tipo       AS INT /* 1 - Exclus∆o, 2 - Inclus∆o */.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

def new global shared var v_cod_empres_usuar AS CHARACTER format "x(3)":U label "Empresa" column-label "Empresa" no-undo.

DEF VAR c-lin        AS CHAR   NO-UNDO.
DEF VAR h-acomp      AS HANDLE NO-UNDO.
DEF VAR v_arq_export AS CHAR   NO-UNDO.

DEF STREAM s_exp_aloc.

DEF TEMP-TABLE tt_bem_pat_inc NO-UNDO
    FIELD cod_empresa     LIKE bem_pat.cod_empresa
    FIELD cod_cta_pat     LIKE bem_pat.cod_cta_pat
    FIELD num_bem_pat     LIKE bem_pat.num_bem_pat
    FIELD num_seq_bem_pat LIKE bem_pat.num_seq_bem_pat
    FIELD cod_ccusto      LIKE aloc_bem.cod_ccusto
    FIELD cod_unid_negoc  LIKE aloc_bem.cod_unid_negoc
    FIELD val_perc        LIKE aloc_bem.val_perc_aprop.
    
DEF TEMP-TABLE tt_bem_pat_exc NO-UNDO
    FIELD cod_empresa     LIKE bem_pat.cod_empresa
    FIELD cod_cta_pat     LIKE bem_pat.cod_cta_pat
    FIELD num_bem_pat     LIKE bem_pat.num_bem_pat
    FIELD num_seq_bem_pat LIKE bem_pat.num_seq_bem_pat.

DEF TEMP-TABLE tt_erro NO-UNDO
    FIELD cod_empresa     LIKE bem_pat.cod_empresa
    FIELD cod_cta_pat     LIKE bem_pat.cod_cta_pat
    FIELD num_bem_pat     LIKE bem_pat.num_bem_pat
    FIELD num_seq_bem_pat LIKE bem_pat.num_seq_bem_pat
    FIELD cod_erro        AS INT
    FIELD des_erro        AS CHAR FORMAT "x(200)".

FIND FIRST mguni.empresa NO-LOCK   
     WHERE empresa.ep-codigo = v_cdn_empres_usuar NO-ERROR.  

ASSIGN c-versao       = "1.00"
       c-revisao      = "000"
       c-empresa      = empresa.razao-social
       c-programa     = "esfas019rp.p"
       c-titulo-relat = "Inclus∆o/Exclus∆o Alocaá‰es de Bens".
       
{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

DEF STREAM s1.

/************** BLOCO PRINCIPAL ***************/

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar IN h-acomp (INPUT "In°cio Importaá∆o"). 

FIND FIRST tt-param NO-ERROR.

RUN pi-inicializar IN h-acomp (INPUT "Processando arquivos...").

IF  tt-param.ind-tipo = 1 /* Exclus∆o */ THEN DO:
    RUN pi_exclusao.
END.

IF  tt-param.ind-tipo = 2 /* Incus∆o */ THEN DO:
    RUN pi_inclusao.
END.

RUN pi-finalizar IN h-acomp.

{include/i-rpclo.i}

RETURN "OK":U.


PROCEDURE pi_exclusao:
    EMPTY TEMP-TABLE tt_bem_pat_exc.
    
    ASSIGN v_arq_export = "".

    INPUT FROM VALUE(tt-param.arquivo-import).
    IMPORT UNFORMATTED c-lin.

    REPEAT:
        IMPORT UNFORMATTED c-lin.
        CREATE tt_bem_pat_exc.
        ASSIGN tt_bem_pat_exc.cod_empresa     = v_cod_empres_usuar
               tt_bem_pat_exc.cod_cta_pat     = ENTRY(1,c-lin,";")
               tt_bem_pat_exc.num_bem_pat     = INT(ENTRY(2,c-lin,";"))
               tt_bem_pat_exc.num_seq_bem_pat = INT(ENTRY(3,c-lin,";")).

        RUN pi-acompanhar IN h-acomp (INPUT "Importando Planilha de Exclus∆o - bem: " + string(tt_bem_pat_exc.num_bem_pat)).
    END.
    
    ASSIGN v_arq_export = REPLACE(tt-param.arquivo-import,".csv",".d").
    
    OUTPUT STREAM s_exp_aloc TO VALUE(v_arq_export).
    
    FOR EACH tt_bem_pat_exc:
        RUN pi-acompanhar IN h-acomp (INPUT "Excluindo alocaá∆o - Bem: " + string(tt_bem_pat_exc.num_bem_pat)).

        FIND FIRST bem_pat
            WHERE bem_pat.cod_empresa     = tt_bem_pat_exc.cod_empresa    
            AND   bem_pat.cod_cta_pat     = tt_bem_pat_exc.cod_cta_pat    
            AND   bem_pat.num_bem_pat     = tt_bem_pat_exc.num_bem_pat    
            AND   bem_pat.num_seq_bem_pat = tt_bem_pat_exc.num_seq_bem_pat NO-LOCK NO-ERROR.
    
        IF  AVAIL bem_pat THEN DO:
            FOR EACH aloc_bem OF bem_pat EXCLUSIVE-LOCK:
                EXPORT STREAM s_exp_aloc aloc_bem.
                
                DISP bem_pat.cod_cta_pat
                     bem_pat.num_bem_pat
                     bem_pat.num_seq_bem_pat
                     aloc_bem.cod_ccusto    
                     aloc_bem.cod_unid_negoc
                     WITH DOWN FRAME f_exclusao.
                
                DOWN WITH FRAME f_exclusao.

                DELETE aloc_bem.
            END.
        END.
        ELSE DO:
            CREATE tt_erro.
            ASSIGN tt_erro.cod_empresa     = tt_bem_pat_exc.cod_empresa    
                   tt_erro.cod_cta_pat     = tt_bem_pat_exc.cod_cta_pat    
                   tt_erro.num_bem_pat     = tt_bem_pat_exc.num_bem_pat    
                   tt_erro.num_seq_bem_pat = tt_bem_pat_exc.num_seq_bem_pat
                   tt_erro.cod_erro        = 17006
                   tt_erro.des_erro        = "Bem n∆o localizado com a chave informada.".
        END.
    END.
    
    OUTPUT STREAM s_exp_aloc CLOSE.

    RUN pi_erro.
END PROCEDURE.

PROCEDURE pi_inclusao:
    EMPTY TEMP-TABLE tt_bem_pat_inc.

    INPUT FROM VALUE(tt-param.arquivo-import).
    IMPORT UNFORMATTED c-lin.
    
    REPEAT:
        IMPORT UNFORMATTED c-lin.
        CREATE tt_bem_pat_inc.
        ASSIGN tt_bem_pat_inc.cod_empresa     = v_cod_empres_usuar
               tt_bem_pat_inc.cod_cta_pat     = ENTRY(1,c-lin,";")
               tt_bem_pat_inc.num_bem_pat     = INT(ENTRY(2,c-lin,";"))
               tt_bem_pat_inc.num_seq_bem_pat = INT(ENTRY(3,c-lin,";"))
               tt_bem_pat_inc.cod_ccusto      = ENTRY(4,c-lin,";")
               tt_bem_pat_inc.cod_unid_negoc  = ENTRY(5,c-lin,";")
               tt_bem_pat_inc.val_perc        = DEC(ENTRY(6,c-lin,";")).
        
        RUN pi-acompanhar IN h-acomp (INPUT "Importando Planilha de Inclus∆o - Bem: " + string(tt_bem_pat_inc.num_bem_pat)).
    END.

    FOR EACH tt_bem_pat_inc:
        RUN pi-acompanhar IN h-acomp (INPUT "Incluindo alocaá∆o - Bem: " + string(tt_bem_pat_inc.num_bem_pat)).

        FIND FIRST bem_pat
            WHERE bem_pat.cod_empresa     = tt_bem_pat_inc.cod_empresa    
            AND   bem_pat.cod_cta_pat     = tt_bem_pat_inc.cod_cta_pat    
            AND   bem_pat.num_bem_pat     = tt_bem_pat_inc.num_bem_pat    
            AND   bem_pat.num_seq_bem_pat = tt_bem_pat_inc.num_seq_bem_pat NO-LOCK NO-ERROR.
    
        IF  AVAIL bem_pat THEN DO:

            FIND FIRST emscad.ccusto
                WHERE emscad.ccusto.cod_empresa      = bem_pat.cod_empresa
                AND   emscad.ccusto.cod_plano_ccusto = "PADRAO"
                AND   emscad.ccusto.cod_ccusto       = tt_bem_pat_inc.cod_ccusto NO-LOCK NO-ERROR.

            IF  NOT AVAIL emscad.ccusto THEN DO:
                CREATE tt_erro.
                ASSIGN tt_erro.cod_empresa     = tt_bem_pat_inc.cod_empresa    
                       tt_erro.cod_cta_pat     = tt_bem_pat_inc.cod_cta_pat    
                       tt_erro.num_bem_pat     = tt_bem_pat_inc.num_bem_pat    
                       tt_erro.num_seq_bem_pat = tt_bem_pat_inc.num_seq_bem_pat
                       tt_erro.cod_erro        = 17006
                       tt_erro.des_erro        = "Centro de custo " + tt_bem_pat_inc.cod_ccusto + " n∆o cadastrado." .
                NEXT.
            END.

            FIND FIRST unid_negoc
                WHERE unid_negoc.cod_unid_negoc = tt_bem_pat_inc.cod_unid_negoc NO-LOCK NO-ERROR.

            IF  NOT AVAIL unid_negoc THEN DO:
                CREATE tt_erro.
                ASSIGN tt_erro.cod_empresa     = tt_bem_pat_inc.cod_empresa    
                       tt_erro.cod_cta_pat     = tt_bem_pat_inc.cod_cta_pat    
                       tt_erro.num_bem_pat     = tt_bem_pat_inc.num_bem_pat    
                       tt_erro.num_seq_bem_pat = tt_bem_pat_inc.num_seq_bem_pat
                       tt_erro.cod_erro        = 17006
                       tt_erro.des_erro        = "Unidade de neg¢cio " + tt_bem_pat_inc.cod_unid_negoc + " n∆o cadastrada." .
                NEXT.
            END.

            CREATE aloc_bem.
            ASSIGN aloc_bem.num_id_bem_pat   = bem_pat.num_id_bem_pat.
            ASSIGN aloc_bem.cod_empresa      = bem_pat.cod_empresa
                   aloc_bem.cod_plano_ccusto = "PADRAO"
                   aloc_bem.cod_ccusto       = tt_bem_pat_inc.cod_ccusto
                   aloc_bem.cod_unid_negoc   = tt_bem_pat_inc.cod_unid_negoc
                   aloc_bem.dat_inic_valid   = 01/01/0001
                   aloc_bem.dat_fim_valid    = 12/31/9999
                   aloc_bem.val_perc_aprop   = tt_bem_pat_inc.val_perc.

            DISP bem_pat.cod_cta_pat
                 bem_pat.num_bem_pat
                 bem_pat.num_seq_bem_pat
                 tt_bem_pat_inc.cod_ccusto     
                 tt_bem_pat_inc.cod_unid_negoc 
                 WITH DOWN FRAME f_inclusao.

            DOWN WITH FRAME f_inclusao.
        END.
        ELSE DO:
            CREATE tt_erro.
            ASSIGN tt_erro.cod_empresa     = tt_bem_pat_inc.cod_empresa    
                   tt_erro.cod_cta_pat     = tt_bem_pat_inc.cod_cta_pat    
                   tt_erro.num_bem_pat     = tt_bem_pat_inc.num_bem_pat    
                   tt_erro.num_seq_bem_pat = tt_bem_pat_inc.num_seq_bem_pat
                   tt_erro.cod_erro        = 17006
                   tt_erro.des_erro        = "Bem n∆o localizado com a chave informada.".
        END.
    END.

    RUN pi_erro.
END.

PROCEDURE pi_erro:

    FOR EACH tt_erro:
        DISP tt_erro.cod_cta_pat    
             tt_erro.num_bem_pat    
             tt_erro.num_seq_bem_pat
             tt_erro.cod_erro       
             tt_erro.des_erro FORMAT "x(30)" WITH DOWN FRAME f_erros.

        DOWN WITH FRAME f_erros.
    END.
END PROCEDURE.
