/******************************************************************************
** Programa..............: rpt_gera_inf_orc_todos_os_meses
** Versao................:  1.00.00.000
** Nome Externo..........: esp/es0031rp.p
** Criado por............: Fabiano
** Criado em.............: 21/02/2008
** Objetivo..............: Gerar os arquivos no diret¢rio orcamento para serem
**                         importadas pelo programa es0940, mˆs anterior.
******************************************************************************/

{esp/es0018.i}

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
   field raw-digita      as raw.
 

def input parameter raw-param  as raw no-undo.
def input parameter table     for tt-raw-digita.

DEF TEMP-TABLE tt-uni
    FIELD unidade AS CHAR
    FIELD divisao AS CHAR
    FIELD cod_ccusto LIKE sdo_orcto_ctbl_bgc.cod_ccusto
    INDEX codigo IS PRIMARY unidade divisao cod_ccusto.

DEF TEMP-TABLE tt-conta
    FIELD cod_cta_ctbl LIKE cta_ctbl.cod_cta_ctbl
    FIELD ind_espec_cta_ctbl LIKE cta_ctbl.ind_espec_cta_ctbl
    FIELD orcado AS DEC FORMAT "->>>,>>>,>>9.99"
    FIELD realizado AS DEC FORMAT "->>>,>>>,>>9.99"
    INDEX codigo IS PRIMARY cod_cta_ctbl
    INDEX esp ind_espec_cta_ctbl
    INDEX tp-codigo ind_espec_cta_ctbl cod_cta_ctbl.

DEF TEMP-TABLE tt-conta-div
    FIELD unidade LIKE tt-uni.unidade
    FIELD divisao LIKE tt-uni.divisao
    FIELD cod_cta_ctbl LIKE cta_ctbl.cod_cta_ctbl
    FIELD ind_espec_cta_ctbl LIKE cta_ctbl.ind_espec_cta_ctbl
    FIELD orcado AS DEC FORMAT "->>>,>>>,>>9.99"
    FIELD realizado AS DEC FORMAT "->>>,>>>,>>9.99"
    INDEX codigo IS PRIMARY unidade divisao cod_cta_ctbl .

DEF TEMP-TABLE tt-conta-uni
    FIELD unidade LIKE tt-uni.unidade
    FIELD cod_cta_ctbl LIKE cta_ctbl.cod_cta_ctbl
    FIELD ind_espec_cta_ctbl LIKE cta_ctbl.ind_espec_cta_ctbl
    FIELD orcado AS DEC FORMAT "->>>,>>>,>>9.99"
    FIELD realizado AS DEC FORMAT "->>>,>>>,>>9.99"
    INDEX codigo IS PRIMARY unidade cod_cta_ctbl.

DEF TEMP-TABLE tt-conta-emp
    FIELD cod_cta_ctbl LIKE cta_ctbl.cod_cta_ctbl
    FIELD ind_espec_cta_ctbl LIKE cta_ctbl.ind_espec_cta_ctbl
    FIELD orcado AS DEC FORMAT "->>>,>>>,>>9.99"
    FIELD realizado AS DEC FORMAT "->>>,>>>,>>9.99"
    INDEX codigo IS PRIMARY cod_cta_ctbl.

DEF TEMP-TABLE tt-cc
    FIELD cc-codigo AS CHAR FORMAT "x(5)"
    FIELD centro-custo LIKE centro-custo.cc-codigo
    INDEX codigo IS PRIMARY cc-codigo.

DEF TEMP-TABLE tt-dados
    FIELD origem                        AS CHAR FORMAT "x(3)"
    FIELD ind_natur_lancto_ctbl         AS CHAR FORMAT "X(3)"
    FIELD cod_emitente                  AS INT FORMAT ">>>,>>>,>>9"
    FIELD nome_emitente                 AS CHAR FORMAT "X(40)"
    FIELD dt_transacao                  AS DATE FORMAT "99/99/9999"
    FIELD cod_espec_docto               AS CHAR FORMAT "x(3)"
    FIELD cod_ser_docto                 AS CHAR FORMAT "x(3)"
    FIELD cod_tit_ap                    AS CHAR FORMAT "x(10)"
    FIELD cod_parcela                   AS CHAR FORMAT "x(2)"
    FIELD val_aprop_ctbl                AS DEC FORMAT ">>>,>>>,>>9.99".

DEF BUFFER btt-conta FOR tt-conta.

DEF VAR c-arquivo AS CHAR.
DEF VAR c-dir     AS CHAR.
DEF VAR c-linha   AS CHAR.
DEF VAR i-ano     AS INT.
DEF VAR i-mes     AS INT.
def var v_data    as date.

DEF VAR v_seq AS INT.

EMPTY TEMP-TABLE tt-prog-ponto.

IF OPSYS = "UNIX":U THEN DO:
    RUN esp/es0018p.p (INPUT  "ES0940":U,
                       INPUT  2,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-dir = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
    END.

    IF SUBSTRING(c-dir, LENGTH(c-dir), 1) <> "/":U THEN
        ASSIGN c-dir = c-dir + "/":U.
END.
ELSE DO:
    RUN esp/es0018p.p (INPUT  "ES0940":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-dir = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
    END.

    IF SUBSTRING(c-dir, LENGTH(c-dir), 1) <> "~\":U THEN
        ASSIGN c-dir = c-dir + "~\":U.
END.

/* ** Gera todos os meses do ano corrente ***/
DO v_seq = 3 TO 12:

    FOR EACH tt-uni:
        DELETE tt-uni.
    END.
    FOR EACH tt-conta:
        DELETE tt-conta.
    END.
    FOR EACH tt-cc:
        DELETE tt-cc.
    END.
    FOR EACH tt-conta-emp:
        DELETE tt-conta-emp.
    END.
    FOR EACH tt-conta-uni:
        DELETE tt-conta-uni.
    END.
    FOR EACH tt-conta-div:
        DELETE tt-conta-div.
    END.
    FOR EACH tt-dados:
        DELETE tt-dados.
    END.

    assign v_data = DATE(v_seq, 01, year(today)).
    
    ASSIGN i-ano = year(v_data)
           i-mes = month(v_data).
    
    def var v_num_ano_refer as int.
    def var v_num_mes_refer as int.
    def var v_dat_refer_fim as date.
    
    /* ** Posiciona um mˆs a frente ***/
    assign v_num_ano_refer = year(v_data)
           v_num_mes_refer = month(v_data) + 1.
       
    if v_num_mes_refer = 13
       then assign v_num_mes_refer = 1
                   v_num_ano_refer = v_num_ano_refer + 1.
     
    /* ** Diminui um dia para pegar o £ltimo dia do mˆs anterior ***/
    assign v_dat_refer_fim = date('01' + string(v_num_mes_refer, '99') + string(v_num_ano_refer, '9999'))
           v_dat_refer_fim = v_dat_refer_fim - 1.
    
    ASSIGN c-arquivo = c-dir + "cc-unidade.csv".
    
    INPUT FROM VALUE(c-arquivo).
    
    REPEAT:
    
        IMPORT UNFORMATTED c-linha.
    
        CREATE tt-uni.
        ASSIGN tt-uni.unidade    = ENTRY(1,c-linha,";")
               tt-uni.divisao    = ENTRY(2,c-linha,";")
               tt-uni.cod_ccusto = SUBSTRING(ENTRY(3,c-linha,";"),2,5).
    
    END.
    
    INPUT CLOSE.
    
    /* BUSCA TODOS OS CENTROS DE CUSTOS - O ARQUIVO SERA GERADO POR CENTRO DE CUSTOS */
    FOR EACH cta_ctbl FIELDS (cod_cta_ctbl ind_espec_cta_ctbl) NO-LOCK
        WHERE cta_ctbl.cod_cta_ctbl >= "40000000"
          AND cta_ctbl.cod_cta_ctbl <  "42000000": 
    
        CREATE tt-conta.
        ASSIGN tt-conta.cod_cta_ctbl       = cta_ctbl.cod_cta_ctbl
               tt-conta.ind_espec_cta_ctbl = cta_ctbl.ind_espec_cta_ctbl.
        
    END.
    
    FOR EACH centro-custo FIELDS (cc-codigo) NO-LOCK:
    
        FIND tt-cc
             WHERE tt-cc.cc-codigo = centro-custo.cc-codigo NO-ERROR.
        IF NOT AVAIL tt-cc 
        THEN DO:
             /* Caso o Centro de Custo esteja relacionado a mais de uma unidade ‚ criado somente o primeiro registro 
                Esta limita‡Æo foi contornada no programa es0940aa, mas precisa ser revista */
             CREATE tt-cc.
             ASSIGN tt-cc.cc-codigo    = centro-custo.cc-codigo
                    tt-cc.centro-custo = centro-custo.cc-codigo.
    
        END.
    
    END.
    
    FOR EACH tt-cc  NO-LOCK:
    
        ASSIGN c-arquivo = c-dir + "orc" + STRING(i-ano,"9999") + STRING(i-mes,"99") + tt-cc.centro-custo.
    
        /* BUSCA TODAS AS CONTAS CONTABEIS - O ARQUIVO TERA UMA LINHA PARA CADA CONTA */
        FOR EACH tt-conta:
    
            ASSIGN tt-conta.realizado = 0
                   tt-conta.orcado    = 0.
     
            FOR EACH estabelecimento NO-LOCK
                WHERE estabelecimento.cod_empresa = '1':
    
                IF estabelecimento.cod_estab = '102' 
                   THEN NEXT.

                RUN  menu-es/es0940aa.p (INPUT estabelecimento.cod_estab,
                                         INPUT "padrao",
                                         INPUT tt-conta.cod_cta_ctbl,
                                         INPUT tt-cc.centro-custo,
                                         INPUT DATE(i-mes,01, i-ano),
                                         INPUT v_dat_refer_fim,
                                         OUTPUT TABLE tt-dados).     
                                         
                FOR EACH tt-dados:
                    IF tt-dados.ind_natur_lancto_ctbl  = "db" 
                       THEN ASSIGN tt-conta.realizado = tt-conta.realizado + tt-dados.val_aprop_ctbl .
                       ELSE ASSIGN tt-conta.realizado = tt-conta.realizado - tt-dados.val_aprop_ctbl .
                END.
    
                /* BUSCA OS VALORES ORCADOS PARA CADA CONTA / CENTRO DE CUSTOS */
                FOR EACH sdo_orcto_ctbl_bgc NO-LOCK
                    WHERE sdo_orcto_ctbl_bgc.cod_cenar_orctario  = STRING(i-ano,"9999")
                      AND sdo_orcto_ctbl_bgc.cod_unid_orctaria   = "desp1"
                      AND sdo_orcto_ctbl.num_seq_orcto_ctbl      = 1
                      AND sdo_orcto_ctbl_bgc.cod_cenar_ctbl      = "FISCAL"
                      AND sdo_orcto_ctbl_bgc.cod_plano_cta_ctbl  = "padrao"
                      AND sdo_orcto_ctbl_bgc.cod_plano_ccusto    = "padrao"
                      AND sdo_orcto_ctbl_bgc.cod_estab           = estabelecimento.cod_estab
                      AND sdo_orcto_ctbl_bgc.cod_empresa         = "1"
                      AND sdo_orcto_ctbl_bgc.cod_exerc_ctbl      = STRING(i-ano,"9999")
                      AND sdo_orcto_ctbl_bgc.num_period_ctbl     = i-mes
                      AND sdo_orcto_ctbl_bgc.cod_vers_orcto_ctbl = "3.00"
                      AND sdo_orcto_ctbl.cod_cta_ctbl            = tt-conta.cod_cta_ctbl
                      AND sdo_orcto_ctbl.cod_ccusto              = tt-cc.cc-codigo:
                      
                    ASSIGN tt-conta.orcado = tt-conta.orcado + sdo_orcto_ctbl_bgc.val_orcado.
                    
                END.

            END.

        END.
    
        /* totaliza contas */
        FOR EACH tt-conta USE-INDEX tp-codigo
            WHERE tt-conta.ind_espec_cta_ctbl = "analitica"
               BY tt-conta.cod_cta_ctbl DESCENDING:
    
            FIND LAST btt-conta
                 WHERE btt-conta.cod_cta_ctbl       < tt-conta.cod_cta_ctbl
                   AND btt-conta.ind_espec_cta_ctbl = "sintetica" 
                   USE-INDEX codigo NO-ERROR.
        
            IF AVAIL btt-conta 
            THEN DO:
            
                 IF tt-conta.cod_cta_ctbl = btt-conta.cod_cta_ctbl 
                    THEN NEXT.
    
                 ASSIGN btt-conta.orcado    = btt-conta.orcado    + tt-conta.orcado
                        btt-conta.realizado = btt-conta.realizado + tt-conta.realizado.
        
            END.
            
        END.
    
        FOR EACH tt-conta USE-INDEX tp-codigo
              WHERE tt-conta.ind_espec_cta_ctbl = "sintetica"
                 BY tt-conta.cod_cta_ctbl DESCENDING:
    
               FIND LAST btt-conta
                    WHERE btt-conta.ind_espec_cta_ctbl = "sintetica"
                      AND btt-conta.cod_cta_ctbl       < tt-conta.cod_cta_ctbl
                      AND btt-conta.cod_cta_ctbl  BEGINS substring(ENTRY(1,tt-conta.cod_cta_ctbl,"0"),1,LENGTH(ENTRY(1,tt-conta.cod_cta_ctbl,"0")) - 1) 
                                                         + FILL("0", 8 - LENGTH(substring(ENTRY(1,tt-conta.cod_cta_ctbl,"0"),1,LENGTH(ENTRY(1,tt-conta.cod_cta_ctbl,"0")) - 1) )) 
                    NO-ERROR.
            
                   IF AVAIL btt-conta 
                      THEN ASSIGN btt-conta.orcado    = btt-conta.orcado    + tt-conta.orcado
                                  btt-conta.realizado = btt-conta.realizado + tt-conta.realizado.
            
        END.
    
        /* GERA O ARQUIVO */
        OUTPUT TO VALUE(c-arquivo).
         
        FOR EACH tt-conta:
             PUT tt-conta.cod_cta_ctbl ";"
                 tt-conta.orcado ";"
                 tt-conta.realizado SKIP.
    
        END.
    
        OUTPUT CLOSE.
    
        FOR EACH tt-conta:
    
            /* totaliza empresa */
             FIND tt-conta-emp 
                  WHERE tt-conta-emp.cod_cta_ctbl = tt-conta.cod_cta_ctbl NO-ERROR.
             IF NOT AVAIL tt-conta-emp 
                THEN CREATE tt-conta-emp.
    
             ASSIGN tt-conta-emp.cod_cta_ctbl       = tt-conta.cod_cta_ctbl
                    tt-conta-emp.ind_espec_cta_ctbl = tt-conta.ind_espec_cta_ctbl
                    tt-conta-emp.orcado             = tt-conta-emp.orcado          + tt-conta.orcado
                    tt-conta-emp.realizado          = tt-conta-emp.realizado       + tt-conta.realizado.
    
        END.
    
        FOR EACH tt-uni
            WHERE tt-uni.cod_ccusto = tt-cc.cc-codigo:
    
            FOR EACH tt-conta:
                    
                /* totaliza unidade */
                FIND tt-conta-uni 
                     WHERE tt-conta-uni.cod_cta_ctbl = tt-conta.cod_cta_ctbl
                       AND tt-conta-uni.unidade      = tt-uni.unidade NO-ERROR.
                IF NOT AVAIL tt-conta-uni 
                   THEN CREATE tt-conta-uni.
    
                ASSIGN tt-conta-uni.cod_cta_ctbl       = tt-conta.cod_cta_ctbl
                       tt-conta-uni.unidade            = tt-uni.unidade
                       tt-conta-uni.ind_espec_cta_ctbl = tt-conta.ind_espec_cta_ctbl
                       tt-conta-uni.orcado             = tt-conta-uni.orcado          + tt-conta.orcado
                       tt-conta-uni.realizado          = tt-conta-uni.realizado       + tt-conta.realizado.
    
                /* totaliza divisao */
                FIND tt-conta-div
                     WHERE tt-conta-div.cod_cta_ctbl = tt-conta.cod_cta_ctbl
                       AND tt-conta-div.unidade      = tt-uni.unidade
                       AND tt-conta-div.divisao      = tt-uni.divisao NO-ERROR.
                IF NOT AVAIL tt-conta-div 
                   THEN CREATE tt-conta-div.
    
                ASSIGN tt-conta-div.cod_cta_ctbl       = tt-conta.cod_cta_ctbl
                       tt-conta-div.unidade            = tt-uni.unidade
                       tt-conta-div.divisao            = tt-uni.divisao
                       tt-conta-div.ind_espec_cta_ctbl = tt-conta.ind_espec_cta_ctbl
                       tt-conta-div.orcado             = tt-conta-div.orcado          + tt-conta.orcado
                       tt-conta-div.realizado          = tt-conta-div.realizado       + tt-conta.realizado.
                
            END.
            
        END.
        
    END. /* centro de custos */
    
    /* gera arquivo da empresa */
    ASSIGN c-arquivo = c-dir + "emp" + STRING(i-ano,"9999") + STRING(i-mes,"99"). 

    OUTPUT TO VALUE(c-arquivo).
    
    FOR EACH tt-conta-emp:
    
        PUT tt-conta-emp.cod_cta_ctbl ";"
            tt-conta-emp.orcado ";"
            tt-conta-emp.realizado SKIP.
    
    END.
    
    OUTPUT CLOSE.
    
    /* gera arquivos das unidades */
    FOR EACH tt-conta-uni
        BREAK BY tt-conta-uni.unidade:
    
        IF FIRST-OF(tt-conta-uni.unidade) 
        THEN DO:
             
             ASSIGN c-arquivo = c-dir + "uni" + STRING(i-ano,"9999") + STRING(i-mes,"99") + tt-conta-uni.unidade. 
    
             OUTPUT TO VALUE(c-arquivo).
             
        END.
    
        PUT tt-conta-uni.cod_cta_ctbl ";"
            tt-conta-uni.orcado ";"
            tt-conta-uni.realizado SKIP.
        
        IF LAST-OF(tt-conta-uni.unidade) 
           THEN OUTPUT CLOSE.
    
    END.
    
    
    /* gera arquivos das unidades */
    FOR EACH tt-conta-div
        BREAK BY tt-conta-div.unidade
              BY tt-conta-div.divisao:
    
        IF FIRST-OF(tt-conta-div.divisao) 
        THEN DO:
    
             ASSIGN c-arquivo = c-dir + "div" + STRING(i-ano,"9999") + STRING(i-mes,"99") + tt-conta-div.unidade + tt-conta-div.divisao.
    
             OUTPUT TO VALUE(c-arquivo).
    
        END.
    
        PUT tt-conta-div.cod_cta_ctbl ";"
            tt-conta-div.orcado ";"
            tt-conta-div.realizado SKIP.
        
        IF LAST-OF(tt-conta-div.divisao) 
           THEN OUTPUT CLOSE.
    
    END.

END.
