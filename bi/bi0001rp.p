define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG.

DEF TEMP-TABLE tt-consulta-res
    FIELD cod_estab             LIKE movto_real_orcto.cod_estab          
    FIELD des_grupo             AS CHAR
    FIELD cod_cta_ctbl          LIKE movto_real_orcto.cod_cta_ctbl       
    FIELD des_cta_ctbl          AS CHAR
    FIELD cod_ccusto            LIKE movto_real_orcto.cod_ccusto     
    FIELD des_ccusto            AS CHAR
    FIELD cod_fornec            LIKE movto_real_orcto.cod_fornec
    FIELD nom_pessoa            LIKE emscad.fornecedor.nom_pessoa
    FIELD cod_exerc_ctbl        LIKE movto_real_orcto.cod_exerc_ctbl  
    FIELD num_period_ctbl       LIKE movto_real_orcto.num_period_ctbl
    FIELD cod_origem            LIKE movto_real_orcto.cod_origem
    FIELD valor_orc             LIKE movto_real_orcto.val_orcado_per
    FIELD valor_real            LIKE movto_real_orcto.val_realiz_per
    FIELD dt_movto              LIKE movto_real_orcto.dt_movto
    FIELD c-periodo             AS CHAR   
    FIELD v_cod_histor_1        AS CHAR   
    FIELD v_cod_histor_2        AS CHAR    
    INDEX tt_id     IS PRIMARY
            cod_estab
            des_grupo
            cod_cta_ctbl       
            cod_exerc_ctbl     
            num_period_ctbl.
            
DEF TEMP-TABLE tt_grupo
    FIELD cod_cta_ctbl AS CHAR
    FIELD des_grupo    AS CHAR
    index tt_id                           is primary unique
          cod_cta_ctbl                    ascending.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

{esp/es0018.i}
{utp/ut-glob.i}
DEFINE STREAM str-excel.

DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo-csv  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp        AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arq-excel    AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-periodo      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_histor_1 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_histor_2 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont         AS INTEGER     NO-UNDO.

DEFINE VARIABLE c-cta AS CHARACTER   NO-UNDO.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

/*
RUN pi_cria_grupo.
*/

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "BI0001.csv":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "bi0001":U,
                           INPUT 2,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END. 
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "bi0001":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END.
END.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar in h-acomp (input "Gerando ...").

OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.

FOR EACH emscad.empresa NO-LOCK:

    IF  emscad.empresa.cod_empresa <> "1"
    AND emscad.empresa.cod_empresa <> "5"
    AND emscad.empresa.cod_empresa <> "6" THEN
        NEXT.

    FOR EACH movto_real_orcto NO-LOCK
       WHERE movto_real_orcto.cod_empresa        = emscad.empresa.cod_empresa
         AND movto_real_orcto.cod_cenar_ctbl     = "fiscal"
         AND movto_real_orcto.cod_plano_cta_ctbl = "padrao"
         AND movto_real_orcto.cod_plano_ccusto   = "padrao"
         AND movto_real_orcto.cod_exerc_ctbl    >= "2023": 
    
        ASSIGN c-cta = movto_real_orcto.cod_cta_ctbl.
    
        IF  substr(c-cta,1,1) <> "4" THEN
            NEXT.

        /*
        FIND FIRST tt_grupo
             WHERE tt_grupo.cod_cta_ctbl = movto_real_orcto.cod_cta_ctbl NO-ERROR.
    
        IF NOT AVAIL tt_grupo THEN DO:
             NEXT.
        END.
        */

        RUN pi-acompanhar in h-acomp (INPUT STRING(movto_real_orcto.dt_movto)).
    
        FIND FIRST cta_ctbl NO-LOCK 
             WHERE cta_ctbl.cod_plano_cta_ctbl = movto_real_orcto.cod_plano_cta_ctb
               AND cta_ctbl.cod_cta_ctbl       = c-cta NO-ERROR.
    
        FIND emscad.ccusto NO-LOCK
            WHERE emscad.ccusto.cod_empresa      = movto_real_orcto.cod_empresa
              AND emscad.ccusto.cod_plano_ccusto = movto_real_orcto.cod_plano_ccusto
              AND emscad.ccusto.cod_ccusto       = movto_real_orcto.cod_ccusto NO-ERROR.
    
        FIND FIRST emscad.fornecedor NO-LOCK 
             WHERE fornecedor.cod_empres = movto_real_orcto.cod_empr
               AND fornecedor.cdn_fornec = movto_real_orcto.cod_fornec NO-ERROR.                                          
        
        ASSIGN c-periodo = movto_real_orcto.cod_exerc_ctbl + "/" + STRING(movto_real_orcto.num_period_ctbl).
    
        FIND LAST param_orcto NO-LOCK
            WHERE param_orcto.dt_inicio <= DATE("01" + STRING(movto_real_orcto.num_period_ctbl) + movto_real_orcto.cod_exerc_ctbl)
              AND param_orcto.dt_final  >= DATE("01" + STRING(movto_real_orcto.num_period_ctbl) + movto_real_orcto.cod_exerc_ctbl) NO-ERROR.
    
        /* ** Tratamento para retirar caracteres especiais que quebram a linha na exporta‡Æo ***/
        ASSIGN v_cod_histor_1 = movto_real_orcto.des_histor_movto
               v_cod_histor_2 = movto_real_orcto.des_historicao.
    
        ASSIGN v_cod_histor_1 = REPLACE(v_cod_histor_1, ";":U, ",":U)
               v_cod_histor_2 = REPLACE(v_cod_histor_2, ";":U, ",":U).
    
        DO i-cont = 1 TO 31:
            ASSIGN v_cod_histor_1 = REPLACE(v_cod_histor_1, CHR(i-cont), CHR(32))
                   v_cod_histor_2 = REPLACE(v_cod_histor_2, CHR(i-cont), CHR(32)).
        END.
    
        IF INDEX(v_cod_histor_1, CHR(32) + CHR(32)) <> 0 THEN DO:
            DO i-cont = 12 TO 2 BY -1:
                ASSIGN v_cod_histor_1 = REPLACE(v_cod_histor_1, FILL(CHR(32), i-cont), CHR(32)).
            END.
        END.
        IF INDEX(v_cod_histor_2, CHR(32) + CHR(32)) <> 0 THEN DO:
            DO i-cont = 12 TO 2 BY -1:
                ASSIGN v_cod_histor_2 = REPLACE(v_cod_histor_2, FILL(CHR(32), i-cont), CHR(32)).
            END.
        END.
    
        ASSIGN v_cod_histor_1 = TRIM(v_cod_histor_1)
               v_cod_histor_2 = TRIM(v_cod_histor_2).
        /* ** Fim Tratamento para retirar caracteres especiais que quebram a linha na exporta‡Æo ***/
    
        CREATE tt-consulta-res.
        ASSIGN tt-consulta-res.cod_estab             = movto_real_orcto.cod_estab
               tt-consulta-res.des_grupo             = cta_ctbl.des_tit_ctbl /*tt_grupo.des_grupo*/
               tt-consulta-res.cod_cta_ctbl          = c-cta
               tt-consulta-res.des_cta_ctbl          = cta_ctbl.des_tit_ctbl
               tt-consulta-res.cod_ccusto            = movto_real_orcto.cod_ccusto
               tt-consulta-res.des_ccusto            = ccusto.des_tit_ctbl
               tt-consulta-res.cod_fornec            = movto_real_orcto.cod_fornec
               tt-consulta-res.nom_pessoa            = IF AVAIL fornecedor THEN fornecedor.nom_pessoa ELSE ""
               tt-consulta-res.cod_exerc_ctbl        = movto_real_orcto.cod_exerc_ctbl
               tt-consulta-res.num_period_ctbl       = movto_real_orcto.num_period_ctbl
               tt-consulta-res.cod_origem            = movto_real_orcto.cod_origem
               tt-consulta-res.valor_real            = IF movto_real_orcto.ind_natur_lancto_ctbl = "DB" THEN movto_real_orcto.val_realiz_per ELSE movto_real_orcto.val_realiz_per * -1
               tt-consulta-res.dt_movto              = movto_real_orcto.dt_movto
               tt-consulta-res.c-periodo             = c-periodo
               tt-consulta-res.v_cod_histor_1        = v_cod_histor_1
               tt-consulta-res.v_cod_histor_2        = v_cod_histor_2.
        
    END.
END.

PUT STREAM str-excel UNFORMATTED "Data;Estab;Grupo;Cta;Nome Cta;CCusto;Nome CCusto;Emitente;Modulo;Valor;Historico" SKIP.
FOR EACH tt-consulta-res:
    PUT STREAM str-excel UNFORMATTED tt-consulta-res.dt_movto        ";"
                                     tt-consulta-res.cod_estab       ";"
                                     tt-consulta-res.des_grupo       ";"
                                     tt-consulta-res.cod_cta_ctbl    ";"
                                     tt-consulta-res.des_cta_ctbl    ";"
                                     tt-consulta-res.cod_ccusto      ";"
                                     tt-consulta-res.des_ccusto      ";"
                                     tt-consulta-res.cod_fornec      ";"
                                     tt-consulta-res.cod_origem      ";"
                                     tt-consulta-res.valor_real      ";"
                                     tt-consulta-res.v_cod_histor_1  SKIP.
END.

RUN pi-finalizar in h-acomp .

OUTPUT STREAM str-excel CLOSE.

PROCEDURE pi_cria_grupo:
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41310005"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.    
    assign tt_grupo.cod_cta_ctbl = "41310020"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.    
    assign tt_grupo.cod_cta_ctbl = "41310025"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41310030"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41310050"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41320005"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41320010"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41310010"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41310015"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41320015"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41320040"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41330005"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41330010"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41330020"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41330025"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41330030"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41330035"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41330040"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41330045"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41340005"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41350015"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41310035"	
           tt_grupo.des_grupo    = "01 - Gastos com Pessoal".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41340010"	
           tt_grupo.des_grupo    = "02 - Programas de Treinamento".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41340020"	
           tt_grupo.des_grupo    = "02 - Programas de Treinamento".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41350005"	
           tt_grupo.des_grupo    = "03 - Eventos Coletivos".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41350025"	
           tt_grupo.des_grupo    = "03 - Eventos Coletivos".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41520005"	
           tt_grupo.des_grupo    = "04 - Utilidades (Energia/Agua/Comunica‡Æo)".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41520015"   
           tt_grupo.des_grupo    = "04 - Utilidades (Energia/Agua/Comunica‡Æo)".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41520020"	
           tt_grupo.des_grupo    = "04 - Utilidades (Energia/Agua/Comunica‡Æo)".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41520025"	
           tt_grupo.des_grupo    = "04 - Utilidades (Energia/Agua/Comunica‡Æo)".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41530005"	
           tt_grupo.des_grupo    = "04 - Utilidades (Energia/Agua/Comunica‡Æo)".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41530025"	
           tt_grupo.des_grupo    = "04 - Utilidades (Energia/Agua/Comunica‡Æo)".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41510005"	
           tt_grupo.des_grupo    = "05 - Servi‡os de Terceiros".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41510010"	
           tt_grupo.des_grupo    = "05 - Servi‡os de Terceiros".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41510015"	
           tt_grupo.des_grupo    = "05 - Servi‡os de Terceiros".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41510020"	
           tt_grupo.des_grupo    = "05 - Servi‡os de Terceiros".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41510025"	
           tt_grupo.des_grupo    = "05 - Servi‡os de Terceiros".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41510035"	
           tt_grupo.des_grupo    = "05 - Servi‡os de Terceiros".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41530015"	
           tt_grupo.des_grupo    = "06 - Fretes".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41540005"	
           tt_grupo.des_grupo    = "06 - Fretes".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41540010"   
           tt_grupo.des_grupo    = "06 - Fretes".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41610045"	
           tt_grupo.des_grupo    = "07 - Manuten‡Æo Imobilizado".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41620005"	
           tt_grupo.des_grupo    = "07 - Manuten‡Æo Imobilizado".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41630005"	
           tt_grupo.des_grupo    = "07 - Manuten‡Æo Imobilizado".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41630010"	
           tt_grupo.des_grupo    = "07 - Manuten‡Æo Imobilizado".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41630020"	
           tt_grupo.des_grupo    = "07 - Manuten‡Æo Imobilizado".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41610015"	
           tt_grupo.des_grupo    = "08 - Material de Expediente e Consumo".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41610020"	
           tt_grupo.des_grupo    = "08 - Material de Expediente e Consumo".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41610025"	
           tt_grupo.des_grupo    = "08 - Material de Expediente e Consumo".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41610030"	
           tt_grupo.des_grupo    = "08 - Material de Expediente e Consumo".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41610035"	
           tt_grupo.des_grupo    = "08 - Material de Expediente e Consumo".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41610040"	
           tt_grupo.des_grupo    = "08 - Material de Expediente e Consumo".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41610005"	
           tt_grupo.des_grupo    = "09 - Material para Pesquisa".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41650045"	
           tt_grupo.des_grupo    = "09 - Material para Pesquisa".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41410005"	
           tt_grupo.des_grupo    = "10 - Despesas de Marketing".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41410010"	
           tt_grupo.des_grupo    = "10 - Despesas de Marketing".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41410015"	
           tt_grupo.des_grupo    = "10 - Despesas de Marketing".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41410020"	
           tt_grupo.des_grupo    = "10 - Despesas de Marketing".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41410025"	
           tt_grupo.des_grupo    = "10 - Despesas de Marketing".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41420010"	
           tt_grupo.des_grupo    = "10 - Despesas de Marketing".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41420020"	
           tt_grupo.des_grupo    = "10 - Despesas de Marketing".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41420025"	
           tt_grupo.des_grupo    = "10 - Despesas de Marketing".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41420005"	
           tt_grupo.des_grupo    = "11 - Despesas Comerciais".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41420015"	
           tt_grupo.des_grupo    = "11 - Despesas Comerciais".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41420040"	
           tt_grupo.des_grupo    = "11 - Despesas Comerciais".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41420045"	
           tt_grupo.des_grupo    = "12 - Despesas de Assistˆncia T‚cnica".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41430005"	
           tt_grupo.des_grupo    = "12 - Despesas de Assistˆncia T‚cnica".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41430006"	
           tt_grupo.des_grupo    = "12 - Despesas de Assistˆncia T‚cnica".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41430015"	
           tt_grupo.des_grupo    = "12 - Despesas de Assistˆncia T‚cnica".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41430020"	
           tt_grupo.des_grupo    = "12 - Despesas de Assistˆncia T‚cnica".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41430030"	
           tt_grupo.des_grupo    = "12 - Despesas de Assistˆncia T‚cnica".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41430040"	
           tt_grupo.des_grupo    = "12 - Despesas de Assistˆncia T‚cnica".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41430060"	
           tt_grupo.des_grupo    = "12 - Despesas de Assistˆncia T‚cnica".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41430065"	
           tt_grupo.des_grupo    = "12 - Despesas de Assistˆncia T‚cnica".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41430090"	
           tt_grupo.des_grupo    = "12 - Despesas de Assistˆncia T‚cnica".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41650005"	
           tt_grupo.des_grupo    = "13 - Viagens e Representa‡äes".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41420055"	
           tt_grupo.des_grupo    = "14 - VPC - Verba Propaganda Cooperada".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41630015"	
           tt_grupo.des_grupo    = "15 - Impostos taxas e Contribui‡äes".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41640005"	
           tt_grupo.des_grupo    = "15 - Impostos taxas e Contribui‡äes".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41640010"	
           tt_grupo.des_grupo    = "15 - Impostos taxas e Contribui‡äes".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41640015"	
           tt_grupo.des_grupo    = "15 - Impostos taxas e Contribui‡äes".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41640020"	
           tt_grupo.des_grupo    = "15 - Impostos taxas e Contribui‡äes".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41640030"	
           tt_grupo.des_grupo    = "15 - Impostos taxas e Contribui‡äes".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41640025"	
           tt_grupo.des_grupo    = "15 - Impostos taxas e Contribui‡äes".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41420035"	
           tt_grupo.des_grupo    = "16 - Outros Gastos".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41530030"	
           tt_grupo.des_grupo    = "16 - Outros Gastos".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41610050"	
           tt_grupo.des_grupo    = "16 - Outros Gastos".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41610060"	
           tt_grupo.des_grupo    = "16 - Outros Gastos".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41630025"	
           tt_grupo.des_grupo    = "16 - Outros Gastos".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41650010"	
           tt_grupo.des_grupo    = "16 - Outros Gastos".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41650015"	
           tt_grupo.des_grupo    = "16 - Outros Gastos".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41650020"	
           tt_grupo.des_grupo    = "16 - Outros Gastos".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41650025"	
           tt_grupo.des_grupo    = "16 - Outros Gastos".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41650030"	
           tt_grupo.des_grupo    = "16 - Outros Gastos".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41650035"	
           tt_grupo.des_grupo    = "16 - Outros Gastos".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41650050"	
           tt_grupo.des_grupo    = "16 - Outros Gastos".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41650065"	
           tt_grupo.des_grupo    = "16 - Outros Gastos".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41650090"	
           tt_grupo.des_grupo    = "16 - Outros Gastos".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41690005"	
           tt_grupo.des_grupo    = "17 - Deprecia‡Æo".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41690006"	
           tt_grupo.des_grupo    = "17 - Deprecia‡Æo".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41690008"	
           tt_grupo.des_grupo    = "17 - Deprecia‡Æo".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41690009"	
           tt_grupo.des_grupo    = "17 - Deprecia‡Æo".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41690011"	
           tt_grupo.des_grupo    = "17 - Deprecia‡Æo".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41690012"	
           tt_grupo.des_grupo    = "17 - Deprecia‡Æo".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41690015"	
           tt_grupo.des_grupo    = "17 - Deprecia‡Æo".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41690016"	
           tt_grupo.des_grupo    = "17 - Deprecia‡Æo".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41999999"	
           tt_grupo.des_grupo    = "99 - Ajuste Or‡amento".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41110005"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41110010"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41110015"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41110020"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41110028"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41110029"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41110031"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41110032"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41110033"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41110035"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41110036"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41110037"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41110038"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41110039"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41110041"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41110042"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41110050"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41350010"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41420065"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41420070"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41420080"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41430070"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41430075"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41430098"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41430099"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41610006"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41650098"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41650099"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41690007"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41690010"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41920010"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41920015"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41920020"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41190020"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41190025"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41190030"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41430025"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41910005"	
           tt_grupo.des_grupo    = "".
    create tt_grupo.
    assign tt_grupo.cod_cta_ctbl = "41910015"	
           tt_grupo.des_grupo    = "".
END.
