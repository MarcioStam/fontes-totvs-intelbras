/*****************************************************************************
** Programa..............: acr205aa1_epc.p
** Autor.................: Andrey Mauricio de Oliveira
** Criado em.............: 04/02/2019
*****************************************************************************/

{utp/ut-glob.i}

DEF TEMP-TABLE tt_port_tit
    FIELD cod_portador LIKE tit_acr.cod_portador
    FIELD num_titulos  AS INT
    INDEX portador IS PRIMARY UNIQUE
        cod_portador ASCENDING.

DEF NEW GLOBAL SHARED VAR h_v_cod_clien_infor AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren
    AS CHARACTER
    FORMAT "x(12)"
    LABEL "Usu†rio Corrente"
    COLUMN-LABEL "Usu†rio Corrente"
    NO-UNDO.

DEF TEMP-TABLE tt_estatis_clien_detalhe no-undo
    FIELD ttv_cod_periodo                  AS CHARACTER FORMAT "x(7)" LABEL "Per°odo" COLUMN-LABEL "Per°odo"
    FIELD ttv_val_atraso_med_clien_2       AS DECIMAL FORMAT "->>>>>>>>>9" LABEL "Atraso MÇdio" COLUMN-LABEL "Atraso MÇdio"
    FIELD ttv_val_praz_med_2               AS DECIMAL FORMAT ">>>>>>>>>9" LABEL "Prazo MÇdio Receb" COLUMN-LABEL "Prazo MÇdio Receb"
    FIELD tta_val_vendas                   AS DECIMAL FORMAT ">>,>>>,>>>,>>9.99" DECIMALS 2 INITIAL 0 LABEL "Vendas" COLUMN-LABEL "Vendas"
    FIELD ttv_num_cont_aux                 AS INTEGER FORMAT ">9"
    FIELD ttv_val_sdo_clien_mes            AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99" DECIMALS 2 INITIAL 0 LABEL "Saldo Cliente" COLUMN-LABEL "Saldo Cliente"
    FIELD ttv_val_vendas_2                 AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99" DECIMALS 2 LABEL "Vendas" COLUMN-LABEL "Vendas"
    FIELD ttv_val_devol_per                AS DECIMAL FORMAT ">>,>>>,>>>,>>9.99" DECIMALS 2 INITIAL 0 LABEL "Valor Devoluá∆o" COLUMN-LABEL "Valor Devoluá∆o"
    FIELD ttv_cod_period_aux               AS CHARACTER FORMAT "x(8)"
    INDEX tt_estatis_id                    IS PRIMARY UNIQUE
          ttv_num_cont_aux                 ASCENDING.

DEF VAR v_per_ult_compra   AS CHAR FORMAT "99/9999"                     LABEL "Per. Èltima Compra"    NO-UNDO.
DEF VAR v_val_ult_compra   AS DEC  FORMAT ">>>,>>>,>>9.99":U DECIMALS 2 LABEL "Valor Èltima Compra"   NO-UNDO.
DEF VAR v_per_maior_compra AS CHAR FORMAT "99/9999"                     LABEL "Per. Maior Compra"     NO-UNDO.
DEF VAR v_val_maior_compra AS DEC  FORMAT ">>>,>>>,>>9.99":U DECIMALS 2 LABEL "Valor Maior Compra"    NO-UNDO.
DEF VAR v_atraso_medio     AS INT  FORMAT "->>>9"                       LABEL "Atraso MÇdio"          NO-UNDO.
DEF VAR l_segur_usuar      AS LOG INIT NO                                                             NO-UNDO.
DEF VAR v_desc_cond_pagto  LIKE cond-pagto.descricao                                                  NO-UNDO.
DEF VAR v_val_tot_recebto  AS DEC                                                                     NO-UNDO.
DEF VAR v_val_recebto      AS DEC                                                                     NO-UNDO.
DEF VAR v_venc_ini         LIKE tit_acr.dat_prev_liq                                                  NO-UNDO.
DEF VAR v_venc_fim         LIKE tit_acr.dat_prev_liq                                                  NO-UNDO.
DEF VAR v_dat_prev         LIKE tit_acr.dat_prev_liq                                                  NO-UNDO.
DEF VAR i_ano              AS INT                                                                     NO-UNDO.
DEF VAR i_mes              AS INT                                                                     NO-UNDO.
DEF VAR v_num_titulos      AS INT                                                                     NO-UNDO.
DEF VAR v_portador         LIKE tit_acr.cod_portador                                                  NO-UNDO.

DEF VAR v_num_ano                        AS INTEGER         NO-UNDO.
DEF VAR v_num_cont                       AS INTEGER         NO-UNDO.
DEF VAR v_num_mes                        AS INTEGER         NO-UNDO.

DEF RECT rt_001 SIZE 1 BY 1 EDGE-PIXELS 2.
DEF RECT rt_002 SIZE 1 BY 1 EDGE-PIXELS 2.

DEF BUTTON bt_ok LABEL "&OK":U TOOLTIP "OK":U SIZE 1 BY 1 AUTO-GO.

DEFINE FRAME fPage0
    rt_001                                             AT ROW 01.25 COL 02.00
    emscad.cliente.cdn_cliente                           AT ROW 01.60 COL 15.80 bgcolor 15
    emscad.cliente.nom_abrev   NO-LABEL FORMAT "x(12)"   AT ROW 01.60 COL 30.50 bgcolor 15
    emscad.cliente.dat_impl_clien LABEL "Dt Implantaá∆o" AT ROW 02.60 COL 10.00 bgcolor 15
    v_val_ult_compra                                   AT ROW 03.60 COL 06.50 bgcolor 15
    v_per_ult_compra                                   AT ROW 03.60 COL 36.00 bgcolor 15
    v_val_maior_compra                                 AT ROW 04.60 COL 07.00 bgcolor 15
    v_per_maior_compra                                 AT ROW 04.60 COL 36.50 bgcolor 15
    v_atraso_medio                                     AT ROW 05.60 COL 11.20 bgcolor 15
    v_desc_cond_pagto           LABEL "Cond Pagto"     AT ROW 06.60 COL 12.00 bgcolor 15
    rt_002                                             AT ROW 08.45 COL 02.00 BGCOLOR 7 
    bt_ok                                              AT ROW 08.65 COL 02.75 FONT ? HELP "OK":U
    WITH 1 DOWN SIDE-LABELS NO-VALIDATE KEEP-TAB-ORDER THREE-D
         SIZE-CHAR 67.00 BY 10.33
         VIEW-AS DIALOG-BOX
         FONT 1 FGCOLOR ? BGCOLOR 8
         TITLE "Referàncias Comerciais".

ASSIGN bt_ok:WIDTH-CHARS                       IN FRAME fPage0 = 10.00
       bt_ok:HEIGHT-CHARS                      IN FRAME fPage0 = 01.00
       rt_001:WIDTH-CHARS                      IN FRAME fPage0 = 63.57
       rt_001:HEIGHT-CHARS                     IN FRAME fPage0 = 07.00
       rt_002:WIDTH-CHARS                      IN FRAME fPage0 = 63.57
       rt_002:HEIGHT-CHARS                     IN FRAME fPage0 = 01.42
       v_per_ult_compra:WIDTH-CHARS            IN FRAME fPage0 = 10
       v_per_maior_compra:WIDTH-CHARS          IN FRAME fPage0 = 10
       emscad.cliente.dat_impl_clien:WIDTH-CHARS IN FRAME fPage0 = 13
       emscad.cliente.nom_abrev:WIDTH-CHARS      IN FRAME fPage0 = 15.

FIND FIRST prog_dtsul
    WHERE prog_dtsul.cod_prog_dtsul = "acr205aa1" NO-LOCK NO-ERROR.

IF  AVAIL prog_dtsul THEN DO:

    FOR EACH usuar_grp_usuar NO-LOCK
        WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
        
        IF  NOT CAN-FIND(FIRST prog_dtsul_segur NO-LOCK
                         WHERE prog_dtsul_segur.cod_prog_dtsul = "acr205aa1"
                         AND  (prog_dtsul_segur.cod_grp_usuar  = usuar_grp_usuar.cod_grp_usuar
                         OR    prog_dtsul_segur.cod_grp_usuar  = "*")) THEN DO:

            ASSIGN l_segur_usuar = NO.
        END.
        ELSE DO:
            ASSIGN l_segur_usuar = YES.
            LEAVE.
        END.
    END.

    IF  l_segur_usuar = NO THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Usu†rio n∆o possui permiss∆o para acessar o programa acr205aa1 !":U).
        RETURN 'nok'.
    END.
END.
ELSE DO:
    RUN utp/ut-msgs.p (INPUT "show":U,
                       INPUT 17006,
                       INPUT "Programa acr205aa1 n∆o cadastrado no menu !":U).
    RETURN 'nok'.
END.

bem_nf_block:
DO  ON ENDKEY UNDO bem_nf_block, LEAVE bem_nf_block:
    VIEW FRAME fPage0.

    DISABLE ALL WITH FRAME fPage0.
    ENABLE bt_ok WITH FRAME fPage0.

    RUN pi_monta_dados.

    WAIT-FOR GO OF FRAME fPage0.
END.

HIDE FRAME fPage0.

RETURN "OK".

PROCEDURE pi_monta_dados:

    FIND FIRST emscad.cliente
        WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
        AND   emscad.cliente.cdn_cliente = int(h_v_cod_clien_infor:SCREEN-VALUE) NO-LOCK NO-ERROR.

    IF  AVAIL emscad.cliente THEN DO:

        FIND clien_financ no-lock
            WHERE clien_financ.cod_empresa = cliente.cod_empresa
            AND   clien_financ.cdn_cliente = cliente.cdn_cliente NO-ERROR.
    
        IF  AVAIL clien_financ THEN DO:

            FIND FIRST clien_analis_cr
                WHERE clien_analis_cr.cod_empresa = clien_financ.cod_empresa
                AND   clien_analis_cr.cdn_cliente = clien_financ.cdn_cliente NO-LOCK NO-ERROR.
    
            IF  AVAIL clien_analis_cr THEN DO:
                ASSIGN /*
                       v_per_ult_compra   = clien_analis_cr.dat_ult_impl_tit_acr
                       v_val_ult_compra   = clien_analis_cr.val_ult_impl_tit_acr
                       v_per_maior_compra = string(month(clien_analis_cr.dat_maior_tit_acr),"99") + "/" + string(YEAR(clien_analis_cr.dat_maior_tit_acr),"9999")
                       v_val_maior_compra = clien_analis_cr.val_maior_tit_acr 
                       */
                       v_num_mes          = MONTH(TODAY)
                       v_num_ano          = YEAR(TODAY).
    
                DO  v_num_cont = 1 TO 12:
                    IF  v_num_mes = 0 THEN
                        ASSIGN v_num_mes = 12
                               v_num_ano = v_num_ano - 1.
 
                    CREATE tt_estatis_clien_detalhe.
                    ASSIGN tt_estatis_clien_detalhe.ttv_num_cont_aux           = v_num_cont
                           tt_estatis_clien_detalhe.ttv_cod_periodo            = STRING(v_num_mes,"99") + "/" + STRING(v_num_ano,"9999")
                           tt_estatis_clien_detalhe.ttv_cod_period_aux         = STRING(DATE(v_num_mes, 01, v_num_ano))
                           tt_estatis_clien_detalhe.ttv_val_atraso_med_clien_2 = 0
                           tt_estatis_clien_detalhe.ttv_val_vendas_2           = 0
                           v_num_mes = v_num_mes - 1.
                END.

                ASSIGN v_val_maior_compra = 0
                       v_per_maior_compra = ""
                       v_val_recebto      = 0
                       v_val_tot_recebto  = 0
                       v_val_ult_compra   = 0
                       v_per_ult_compra   = "".
    
                blk_ttest:
                FOR EACH tt_estatis_clien_detalhe:
                    FIND estatis_clien NO-LOCK
                       WHERE estatis_clien.cod_empresa       = clien_financ.cod_empresa
                       AND   estatis_clien.cdn_cliente       = clien_financ.cdn_cliente
                       AND   estatis_clien.dat_estatis_clien = DATE(tt_estatis_clien_detalhe.ttv_cod_period_aux) NO-ERROR.
                   
                    IF  AVAIL estatis_clien THEN DO:
                        ASSIGN tt_estatis_clien_detalhe.ttv_val_atraso_med_clien_2 = IF estatis_clien.val_tot_recebto > 0 THEN 
                                                                                        estatis_clien.val_recebto / estatis_clien.val_tot_recebto
                                                                                     ELSE 0
                               tt_estatis_clien_detalhe.ttv_val_vendas_2           = estatis_clien.val_vendas
                               v_val_recebto                                       = v_val_recebto + estatis_clien.val_recebto
                               v_val_tot_recebto                                   = v_val_tot_recebto + estatis_clien.val_tot_recebto.
                    END.

                    IF  tt_estatis_clien_detalhe.ttv_val_vendas_2 > v_val_maior_compra THEN
                        ASSIGN v_val_maior_compra = tt_estatis_clien_detalhe.ttv_val_vendas_2
                               v_per_maior_compra = tt_estatis_clien_detalhe.ttv_cod_periodo.

                    IF  v_val_ult_compra = 0 THEN
                        ASSIGN v_val_ult_compra = tt_estatis_clien_detalhe.ttv_val_vendas_2
                               v_per_ult_compra = tt_estatis_clien_detalhe.ttv_cod_periodo.
                END.

                ASSIGN v_atraso_medio = v_val_recebto / v_val_tot_recebto.

                IF  v_atraso_medio = ? THEN
                    ASSIGN v_atraso_medio = 0.
            END.

            ASSIGN v_venc_ini = DATE(MONTH(TODAY),01,YEAR(TODAY))
                   i_mes      = int(MONTH(TODAY) + 1)
                   i_ano      = int(YEAR(TODAY)).

            IF  i_mes > 12 THEN
                ASSIGN i_mes = 01
                       i_ano = int(YEAR(TODAY) + 1).

            ASSIGN v_venc_fim = DATE(i_mes,01,i_ano).

            ASSIGN v_venc_fim = v_venc_fim - 1
                   v_venc_ini = v_venc_ini - 180.

            DO  v_dat_prev = v_venc_ini TO v_venc_fim:
                FOR EACH tit_acr
                    WHERE tit_acr.cod_empresa       = emscad.cliente.cod_empresa
                    AND   tit_acr.cdn_cliente       = emscad.cliente.cdn_cliente
                    AND   tit_acr.dat_prev_liquidac = v_dat_prev:
        
                    IF  tit_acr.ind_tip_espec_docto <> "Normal" THEN NEXT.
                    
                    FIND FIRST tt_port_tit
                        WHERE tt_port_tit.cod_portador = tit_acr.cod_portador NO-LOCK NO-ERROR.
        
                    IF  NOT AVAIL tt_port_tit THEN DO:
                        CREATE tt_port_tit.
                        ASSIGN tt_port_tit.cod_portador = tit_acr.cod_portador.
                    END.
        
                    ASSIGN tt_port_tit.num_titulos = tt_port_tit.num_titulos + 1.
                END.
            END.
        END.

        ASSIGN v_portador = "".

        FOR EACH tt_port_tit:
            IF  tt_port_tit.num_titulos > v_num_titulos THEN
                ASSIGN v_num_titulos = tt_port_tit.num_titulos
                       v_portador    = tt_port_tit.cod_portador.
        END.

        IF  v_portador = "999" THEN
            ASSIGN v_desc_cond_pagto = "DEP‡SITO".
        ELSE
            IF  v_portador <> "" THEN
                ASSIGN v_desc_cond_pagto = "BOLETO".
            ELSE
                ASSIGN v_desc_cond_pagto = "".

        ASSIGN emscad.cliente.cdn_cliente:SCREEN-VALUE    IN FRAME fPage0 = STRING(emscad.cliente.cdn_cliente)
               emscad.cliente.nom_abrev:SCREEN-VALUE      IN FRAME fPage0 = STRING(emscad.cliente.nom_abrev)
               emscad.cliente.dat_impl_clien:SCREEN-VALUE IN FRAME fPage0 = STRING(emscad.cliente.dat_impl_clien)
               v_per_ult_compra:SCREEN-VALUE            IN FRAME fPage0 = STRING(v_per_ult_compra)
               v_val_ult_compra:SCREEN-VALUE            IN FRAME fPage0 = STRING(v_val_ult_compra)
               v_per_maior_compra:SCREEN-VALUE          IN FRAME fPage0 = STRING(v_per_maior_compra)
               v_val_maior_compra:SCREEN-VALUE          IN FRAME fPage0 = STRING(v_val_maior_compra)
               v_atraso_medio:SCREEN-VALUE              IN FRAME fPage0 = STRING(v_atraso_medio)
               v_desc_cond_pagto:SCREEN-VALUE           IN FRAME fPage0 = STRING(v_desc_cond_pagto).
    END.
END PROCEDURE.
