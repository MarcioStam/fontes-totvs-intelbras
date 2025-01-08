DEF TEMP-TABLE tt-usuar-cc NO-UNDO
    FIELD l-selec         AS LOGICAL FORMAT "+/-" INIT NO
    FIELD cod_estabel     AS CHAR COLUMN-LABEL "Est"
    FIELD cod_ccusto      AS CHAR COLUMN-LABEL "Centro Custos"
    FIELD cod_unid_negoc  AS CHAR COLUMN-LABEL "UN"
    FIELD des_ccusto      AS CHAR COLUMN-LABEL "Descri‡Æo" FORMAT "X(60)"
    INDEX cc IS PRIMARY  
            cod_ccusto
    INDEX id-selec
              cod_estabel
              l-selec
              cod_ccusto
              cod_unid_negoc.

{esp/es0018.i}

DEF TEMP-TABLE tt-param NO-UNDO
    FIELD c-cod-unid-orcta  LIKE sdo_orcto_ctbl_bgc.cod_unid_orctaria 
    FIELD num-seq-orcto-ctb LIKE sdo_orcto_ctbl.num_seq_orcto_ctbl   
    FIELD cod-versao-orcto  LIKE sdo_orcto_ctbl_bgc.cod_vers_orcto_ctbl 
    FIELD c-cod-ini         LIKE cta_ctbl.cod_cta_ctbl
    FIELD c-cod-fim         LIKE cta_ctbl.cod_cta_ctbl.

DEF TEMP-TABLE tt-consulta-res NO-UNDO
    field cod_empresa         LIKE movto_real_orcto.cod_empresa       COLUMN-LABEL "Emp"
    field cod_estab           LIKE movto_real_orcto.cod_estab         COLUMN-LABEL "Est"
    field cod_cenar_ctbl      LIKE movto_real_orcto.cod_cenar_ctbl    COLUMN-LABEL "Cen rio"
    field cod_plano_cta_ctbl  like movto_real_orcto.cod_plano_cta_ctb COLUMN-LABEL "Plano Cta"
    field cod_plano_ccusto    like movto_real_orcto.cod_plano_ccusto  COLUMN-LABEL "Plano CC"
    field cod_cta_ctbl        like movto_real_orcto.cod_cta_ctbl      COLUMN-LABEL "Cta"
    FIELD des_cta_ctbl        LIKE cta_ctbl.des_tit_ctbl         COLUMN-LABEL "Descri‡Æo Cta"
    field cod_ccusto          like movto_real_orcto.cod_ccusto        COLUMN-LABEL "C.Custo"
    field cod_unid_negoc      like movto_real_orcto.cod_unid_negoc    COLUMN-LABEL "Un"
    field cod_proj_financ     like movto_real_orcto.cod_proj_financ   COLUMN-LABEL "Proj"
    field c-per-ano-1         AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 1"
    field valor_rea-1         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 1"
    field valor_orc-1         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 1"
    field de-var-1            AS DECIMAL FORMAT "->>9.99"             COLUMN-LABEL "%"
    field c-per-ano-2         AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 2"
    field valor_rea-2         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 2"
    field valor_orc-2         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 2"
    field de-var-2            AS DECIMAL FORMAT "->>9.99"             COLUMN-LABEL "%"
    field c-per-ano-3         AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 3"
    field valor_rea-3         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 3"
    field valor_orc-3         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 3"
    field de-var-3            AS DECIMAL FORMAT "->>9.99"             COLUMN-LABEL "%"
    field c-per-ano-4         AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 4"
    field valor_rea-4         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 4"
    field valor_orc-4         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 4"
    field de-var-4            AS DECIMAL FORMAT "->>9.99"             COLUMN-LABEL "%"
    field c-per-ano-5         AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 5"
    field valor_rea-5         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 5"   
    field valor_orc-5         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 5"
    field de-var-5            AS DECIMAL FORMAT "->>9.99"             COLUMN-LABEL "%"
    field c-per-ano-6         AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 6"
    field valor_rea-6         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 6"
    field valor_orc-6         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 6"
    field de-var-6            AS DECIMAL FORMAT "->>9.99"             COLUMN-LABEL "%"
    field c-per-ano-7         AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 7"
    field valor_rea-7         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 7"
    field valor_orc-7         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 7"
    field de-var-7            AS DECIMAL FORMAT "->>9.99"             COLUMN-LABEL "%"
    field c-per-ano-8         AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 8"
    field valor_rea-8         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 8"
    field valor_orc-8         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 8"
    field de-var-8            AS DECIMAL FORMAT "->>9.99"             COLUMN-LABEL "%"
    field c-per-ano-9         AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 9"
    field valor_rea-9         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 9"
    field valor_orc-9         AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 9"
    field de-var-9            AS DECIMAL FORMAT "->>9.99"             COLUMN-LABEL "%"
    field c-per-ano-10        AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 10"
    field valor_rea-10        AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 10"
    field valor_orc-10        AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 10"
    field de-var-10           AS DECIMAL FORMAT "->>9.99"             COLUMN-LABEL "%"
    field c-per-ano-11        AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 11"
    field valor_rea-11        AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 11"
    field valor_orc-11        AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 11"
    field de-var-11           AS DECIMAL FORMAT "->>9.99"             COLUMN-LABEL "%"
    field c-per-ano-12        AS CHAR    FORMAT "xx\xxxx"             COLUMN-LABEL "Per¡odo 12"
    field valor_rea-12        AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor REAL 12"   
    field valor_orc-12        AS DECIMAL FORMAT "->,>>>,>>>,>>9.99"   COLUMN-LABEL "Valor OR€ADO 12"
    field de-var-12           AS DECIMAL FORMAT "->>9.99"             COLUMN-LABEL "%"
    INDEX idx_codigo is PRIMARY 
              cod_cta_ctbl
    INDEX idx_resumo
              cod_empresa           
              cod_estab             
              cod_cenar_ctbl        
              cod_plano_cta_ctbl    
              cod_plano_ccusto      
              cod_cta_ctbl          
              cod_ccusto            
              cod_unid_negoc        
              cod_proj_financ.

DEF TEMP-TABLE tt-totais NO-UNDO
    FIELD cod-estabel         LIKE movto_real_orcto.cod_estab
    field valor_rea-1         AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 1"
    field valor_orc-1         AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 1"
    field de-var-1            AS DECIMAL FORMAT "->>9.99"           COLUMN-LABEL "%"
    field valor_rea-2         AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 2"
    field valor_orc-2         AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 2"
    field de-var-2            AS DECIMAL FORMAT "->>9.99"           COLUMN-LABEL "%"
    field valor_rea-3         AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 3"
    field valor_orc-3         AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 3"
    field de-var-3            AS DECIMAL FORMAT "->>9.99"           COLUMN-LABEL "%"          
    field valor_rea-4         AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 4"
    field valor_orc-4         AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 4"
    field de-var-4            AS DECIMAL FORMAT "->>9.99"           COLUMN-LABEL "%"
    field valor_rea-5         AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 5"   
    field valor_orc-5         AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 5"
    field de-var-5            AS DECIMAL FORMAT "->>9.99"           COLUMN-LABEL "%"          
    field valor_rea-6         AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 6"
    field valor_orc-6         AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 6"
    field de-var-6            AS DECIMAL FORMAT "->>9.99"           COLUMN-LABEL "%"
    field valor_rea-7         AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 7"
    field valor_orc-7         AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 7"
    field de-var-7            AS DECIMAL FORMAT "->>9.99"           COLUMN-LABEL "%"
    field valor_rea-8         AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 8"
    field valor_orc-8         AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 8"
    field de-var-8            AS DECIMAL FORMAT "->>9.99"           COLUMN-LABEL "%"
    field valor_rea-9         AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 9"
    field valor_orc-9         AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 9"
    field de-var-9            AS DECIMAL FORMAT "->>9.99"           COLUMN-LABEL "%"
    field valor_rea-10        AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 10"
    field valor_orc-10        AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 10"
    field de-var-10           AS DECIMAL FORMAT "->>9.99"           COLUMN-LABEL "%"
    field valor_rea-11        AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 11"
    field valor_orc-11        AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 11"
    field de-var-11           AS DECIMAL FORMAT "->>9.99"           COLUMN-LABEL "%"
    field valor_rea-12        AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor REAL 12"   
    field valor_orc-12        AS DECIMAL FORMAT "->,>>>,>>9.99"    COLUMN-LABEL "Valor OR€ADO 12"
    field de-var-12           AS DECIMAL FORMAT "->>9.99"           COLUMN-LABEL "%".

DEF TEMP-TABLE tt-dados-consulta NO-UNDO LIKE movto_real_orcto
    FIELD r-resumo AS RECID
    FIELD des_cta AS CHAR FORMAT "X(40)"
    FIELD des_cc  AS CHAR FORMAT "X(40)"
    FIELD nome_forn AS CHAR FORMAT "X(40)".
   
DEF BUFFER b-tt-totais FOR tt-totais.

DEF INPUT  PARAM c-estabelecimento AS CHAR.
DEF INPUT  PARAM cb-mes            AS CHAR EXTENT 12.
DEF INPUT  PARAM cb-ano            AS CHAR EXTENT 12.
DEF INPUT  PARAM TABLE FOR tt-param.
DEF INPUT  PARAM TABLE FOR tt-usuar-cc.
DEF OUTPUT PARAM TABLE FOR tt-consulta-res.
DEF OUTPUT PARAM TABLE FOR tt-dados-consulta.
DEF OUTPUT PARAM TABLE FOR tt-totais.

DEF VAR i-cont    AS INT.
DEF VAR i-periodo AS INT.

DEFINE VARIABLE da-inicio AS DATE        NO-UNDO.
DEFINE VARIABLE da-fim    AS DATE        NO-UNDO.

FIND FIRST tt-param NO-LOCK NO-ERROR.

DO  i-cont = 1 TO NUM-ENTRIES(c-estabelecimento,","):
    FIND estabelecimento
            WHERE estabelecimento.cod_estab = ENTRY(i-cont,c-estabelecimento)
            NO-LOCK NO-ERROR.
    
    IF  AVAIL estabelecimento 
    THEN DO:
        DO  i-periodo = 1 TO 12:
            
            IF  cb-mes[i-periodo] = "" OR 
                cb-mes[i-periodo] = "0" 
            THEN 
                NEXT.

            IF  cb-ano[i-periodo] = "" 
            THEN 
                NEXT.

            ASSIGN da-inicio = DATE("01/" + string(int(cb-mes[i-periodo]), "99") + "/" + string(cb-ano[i-periodo], "9999"))
                   da-fim    = ADD-INTERVAL(da-inicio,1 ,"MONTH") - DAY(da-inicio).
            
            FIND LAST PARAM_orcto NO-LOCK
                WHERE PARAM_orcto.dt_inicio <= da-inicio
                AND   PARAM_orcto.dt_final  >= da-fim NO-ERROR.

            IF  NOT AVAIL PARAM_orcto
            THEN
                NEXT.

            FOR EACH  movto_real_orcto NO-LOCK USE-INDEX ch_periodo
                WHERE movto_real_orcto.cod_empresa        = estabelecimento.cod_empresa
                  AND movto_real_orcto.cod_estab          = estabelecimento.cod_estab
                  AND movto_real_orcto.cod_cenar_ctbl     = "FISCAL"
                  AND movto_real_orcto.cod_plano_cta_ctbl = "PADRAO"
                  AND movto_real_orcto.cod_plano_ccusto   = "PADRAO"
                  AND movto_real_orcto.cod_proj_financ    = ""
                  AND movto_real_orcto.cod_exerc_ctbl     = cb-ano[i-periodo]
                  AND movto_real_orcto.num_period_ctbl    = string(int(cb-mes[i-periodo]),"99"):

                FIND FIRST tt-usuar-cc NO-LOCK
                    WHERE  tt-usuar-cc.cod_estabel    = movto_real_orcto.cod_estab 
                      AND  tt-usuar-cc.l-selec        = YES
                      AND  tt-usuar-cc.cod_ccusto     = movto_real_orcto.cod_ccusto 
                      AND  tt-usuar-cc.cod_unid_negoc = movto_real_orcto.cod_unid_negoc NO-ERROR.

                IF  NOT AVAIL tt-usuar-cc
                THEN DO:
                    FIND FIRST tt-usuar-cc NO-LOCK
                        WHERE  tt-usuar-cc.cod_estabel    = movto_real_orcto.cod_estab 
                          AND  tt-usuar-cc.l-selec        = YES
                          AND  tt-usuar-cc.cod_ccusto     = movto_real_orcto.cod_ccusto
                          AND  tt-usuar-cc.cod_unid_negoc = "*" NO-ERROR.
    
                    IF  NOT AVAIL tt-usuar-cc
                    THEN DO:
                        FIND FIRST tt-usuar-cc NO-LOCK
                            WHERE  tt-usuar-cc.cod_estabel    = movto_real_orcto.cod_estab 
                              AND  tt-usuar-cc.l-selec        = YES
                              AND  tt-usuar-cc.cod_ccusto     = "*"
                              AND  tt-usuar-cc.cod_unid_negoc = movto_real_orcto.cod_unid_negoc NO-ERROR.
        
                        IF  NOT AVAIL tt-usuar-cc
                        THEN DO:
                            FIND FIRST tt-usuar-cc NO-LOCK
                                WHERE  tt-usuar-cc.cod_estabel    = movto_real_orcto.cod_estab 
                                  AND  tt-usuar-cc.l-selec        = YES
                                  AND  tt-usuar-cc.cod_ccusto     = "*"
                                  AND  tt-usuar-cc.cod_unid_negoc = "*" NO-ERROR.
                        END.
                    END.
                END. /* IF  NOT AVAIL tt-usuar-cc */

                IF  NOT AVAIL tt-usuar-cc THEN
                    NEXT.
    
                FIND FIRST tt-consulta-res
                    WHERE  tt-consulta-res.cod_empresa       = movto_real_orcto.cod_empresa       
                      and  tt-consulta-res.cod_estab         = movto_real_orcto.cod_estab         
                      and  tt-consulta-res.cod_cenar_ctbl    = movto_real_orcto.cod_cenar_ctbl    
                      and  tt-consulta-res.cod_plano_cta_ctbl= movto_real_orcto.cod_plano_cta_ctbl
                      and  tt-consulta-res.cod_plano_ccusto  = movto_real_orcto.cod_plano_ccusto  
                      and  tt-consulta-res.cod_cta_ctbl      = movto_real_orcto.cod_cta_ctbl      
                      and  tt-consulta-res.cod_ccusto        = movto_real_orcto.cod_ccusto        
                      and  tt-consulta-res.cod_unid_negoc    = movto_real_orcto.cod_unid_negoc    
                      and  tt-consulta-res.cod_proj_financ   = movto_real_orcto.cod_proj_financ NO-ERROR.
                     
                IF  NOT AVAIL tt-consulta-res 
                THEN DO:
                    FIND cta_ctbl NO-LOCK
                        WHERE cta_ctbl.cod_plano_cta_ctbl = movto_real_orcto.cod_plano_cta_ctb
                          AND cta_ctbl.cod_cta_ctbl       = movto_real_orcto.cod_cta_ctbl NO-ERROR.

                    CREATE tt-consulta-res.
                    ASSIGN tt-consulta-res.cod_empresa       = movto_real_orcto.cod_empresa      
                           tt-consulta-res.cod_estab         = movto_real_orcto.cod_estab        
                           tt-consulta-res.cod_cenar_ctbl    = movto_real_orcto.cod_cenar_ctbl   
                           tt-consulta-res.cod_plano_cta_ctbl= movto_real_orcto.cod_plano_cta_ctb
                           tt-consulta-res.cod_plano_ccusto  = movto_real_orcto.cod_plano_ccusto 
                           tt-consulta-res.cod_cta_ctbl      = movto_real_orcto.cod_cta_ctbl     
                           tt-consulta-res.cod_ccusto        = movto_real_orcto.cod_ccusto       
                           tt-consulta-res.cod_unid_negoc    = movto_real_orcto.cod_unid_negoc   
                           tt-consulta-res.cod_proj_financ   = movto_real_orcto.cod_proj_financ
                           tt-consulta-res.des_cta_ctbl      = IF AVAIL cta_ctbl THEN cta_ctbl.des_tit_ctbl  ELSE "".
                END.

                FIND tt-totais
                    WHERE tt-totais.cod-estab = tt-consulta-res.cod_estab NO-ERROR.

                IF  NOT AVAIL tt-totais 
                THEN DO:
                    CREATE tt-totais.
                    ASSIGN tt-totais.cod-estab = tt-consulta-res.cod_estab.
                END.

                FIND b-tt-totais
                    WHERE b-tt-totais.cod-estab = "TOTAL" NO-ERROR.
                
                IF  NOT AVAIL b-tt-totais 
                THEN DO:
                    CREATE b-tt-totais.
                    ASSIGN b-tt-totais.cod-estab = "TOTAL".
                END.

                FIND sdo_orcto_ctbl_bgc NO-LOCK
                    WHERE sdo_orcto_ctbl_bgc.cod_cenar_orctario  = PARAM_orcto.cod_cenar_orcto   
                      AND sdo_orcto_ctbl_bgc.cod_unid_orctaria   = PARAM_orcto.cod_unid_orcta  
                      AND sdo_orcto_ctbl.num_seq_orcto_ctbl      = param_orcto.num_seq_orcto_ctbl
                      AND sdo_orcto_ctbl_bgc.cod_vers_orcto_ctbl = PARAM_orcto.cod_vers_orcto_ctbl
                      AND sdo_orcto_ctbl_bgc.cod_cenar_ctbl      = tt-consulta-res.cod_cenar_ctbl
                      AND sdo_orcto_ctbl_bgc.cod_exerc_ctbl      = cb-ano[i-periodo]
                      AND sdo_orcto_ctbl_bgc.num_period_ctbl     = int(cb-mes[i-periodo])
                      AND sdo_orcto_ctbl_bgc.cod_empresa         = tt-consulta-res.cod_empresa
                      AND sdo_orcto_ctbl_bgc.cod_plano_cta_ctbl  = tt-consulta-res.cod_plano_cta_ctbl
                      AND sdo_orcto_ctbl.cod_cta_ctbl            = tt-consulta-res.cod_cta_ctbl
                      AND sdo_orcto_ctbl_bgc.cod_plano_ccusto    = tt-consulta-res.cod_plano_ccusto
                      AND sdo_orcto_ctbl.cod_ccusto              = tt-consulta-res.cod_ccusto
                      AND sdo_orcto_ctbl_bgc.cod_estab           = tt-consulta-res.cod_estab 
                      AND sdo_orcto_ctbl.cod_unid_negoc          = tt-consulta-res.cod_unid_negoc
                      AND sdo_orcto_ctbl.cod_proj_financ         = tt-consulta-res.cod_proj NO-ERROR.

                IF i-periodo = 1 THEN
                    {esp/es5500.i1 "-1"}

                IF i-periodo = 2 THEN
                    {esp/es5500.i1 "-2"}

                IF i-periodo = 3 THEN
                   {esp/es5500.i1 "-3"}
                                     
                IF i-periodo = 4 THEN
                   {esp/es5500.i1 "-4"}

                IF i-periodo = 5 THEN
                   {esp/es5500.i1 "-5"}
                   
                IF i-periodo = 6 THEN
                   {esp/es5500.i1 "-6"}
                 
                IF i-periodo = 7 THEN
                   {esp/es5500.i1 "-7"}                  

                IF i-periodo = 8 THEN
                   {esp/es5500.i1 "-8"}
                                     
                IF i-periodo = 9 THEN
                   {esp/es5500.i1 "-9"}
                   
                IF i-periodo = 10 THEN
                   {esp/es5500.i1 "-10"}

                IF i-periodo = 11 THEN                    
                   {esp/es5500.i1 "-11"}                   

                IF i-periodo = 12 THEN
                   {esp/es5500.i1 "-12"}
                   
                CREATE tt-dados-consulta.
                BUFFER-COPY movto_real_orcto TO tt-dados-consulta. 
                ASSIGN tt-dados-consulta.r-resumo = RECID(tt-consulta-res).

                FIND cta_ctbl NO-LOCK
                    WHERE cta_ctbl.cod_plano_cta_ctbl = movto_real_orcto.cod_plano_cta_ctb
                      AND cta_ctbl.cod_cta_ctbl       = movto_real_orcto.cod_cta_ctbl NO-ERROR.

                IF AVAIL cta_ctbl 
                THEN
                    ASSIGN tt-dados-consulta.des_cta = cta_ctbl.des_tit_ctbl.

                FIND emscad.ccusto NO-LOCK
                    WHERE ccusto.cod_empres   = movto_real_orcto.cod_emp
                    AND   ccusto.cod_plano_cc = movto_real_orcto.cod_plano_ccusto
                    AND   ccusto.cod_ccusto   = movto_real_orcto.cod_ccusto NO-ERROR.

                IF AVAIL ccusto 
                THEN
                    ASSIGN tt-dados-consulta.des_cc = ccusto.des_tit_ctbl.
                         
                FIND emscad.fornecedor NO-LOCK
                    WHERE fornecedor.cod_empres = movto_real_orcto.cod_empr
                    AND   fornecedor.cdn_fornec = movto_real_orcto.cod_fornec NO-ERROR.

                IF  AVAIL fornecedor 
                THEN
                    ASSIGN tt-dados-consulta.nome_forn = fornecedor.nom_pessoa.
            END.
        END. /* DO  i-periodo = 1 TO 12: */   
    END. /* IF  AVAIL estabelecimento */
END.
