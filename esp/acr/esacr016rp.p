/*****************************************************************************
**     Programa.........: esp/acr/esacr016rp.p
**     Descricao .......: Carta de Anuencia.
**     Versao...........: 1.00.000
**     Autor............: Anderson Silvano - Gestech
**     Criado...........: 23/08/2005
**     Atualiza‡Æo......: 15/05/2010 
**     Autor............: Gustavo Eduardo Tamanini - SQL WORKS
*******************************************************************************/
{esinc\es0000.i}

DEF NEW GLOBAL SHARED VAR L-Implanta              AS   LOGI   INIT NO.
DEF NEW GLOBAL SHARED VAR C-Seg-Usuario           AS   CHAR   FORM "x(12)"  NO-UNDO.
DEF NEW GLOBAL SHARED VAR I-Num-Ped-Exec-Rpw      AS   INTE                 NO-UNDO.   
DEF NEW GLOBAL SHARED VAR I-Pais-Impto-Usuario    AS   INTE   FORM ">>9"    NO-UNDO.
DEF NEW GLOBAL SHARED VAR L-Rpc                   AS   LOGI                 NO-UNDO.
DEF NEW GLOBAL SHARED VAR R-Registro-Atual        AS   ROWID                NO-UNDO.
DEF NEW GLOBAL SHARED VAR C-Arquivo-Log           AS   CHAR   FORM "x(60)"  NO-UNDO.
DEF NEW GLOBAL SHARED VAR I-Num-Ped               AS   INTE                 NO-UNDO.
DEF NEW GLOBAL SHARED VAR H_Prog_Segur_Estab      AS   HANDLE               NO-UNDO.
DEF NEW GLOBAL SHARED VAR V_Num_Tip_Aces_Usuar    AS   INTE                 NO-UNDO.     
DEF NEW GLOBAL SHARED VAR V_Num_Ped_Exec_Corren   AS   INTE   FORM ">>>>>9" NO-UNDO.
DEF NEW GLOBAL SHARED VAR V_Cod_Dwb_User          AS   CHAR   FORM "x(15)"  NO-UNDO. /* usuario corrente */
DEF NEW GLOBAL SHARED VAR C-Dir-Spool-Servid-Exec AS   CHAR                 NO-UNDO.
DEF NEW GLOBAL SHARED VAR I-Num-Ped-Exec-Rpw      AS   INTE                 NO-UNDO.

DEF NEW GLOBAL SHARED TEMP-TABLE Tt-Servid-Rpc-Aplicat
    FIELD Tta-Cod-Aplicat-Dtsul LIKE Aplicat_Dtsul.Cod_Aplicat_Dtsul
    FIELD Tta-Hdl-Servid-Rpc    AS HANDLE.

DEFINE TEMP-TABLE tt_histor_clien
    FIELD cod_empresa LIKE tit_acr.cod_empresa
    FIELD cdn_cliente LIKE tit_acr.cdn_cliente
    FIELD titulos     AS CHAR.

DEFINE TEMP-TABLE tt_tit_acr NO-UNDO LIKE tit_acr
    FIELD l-marcado AS LOGICAL FORMAT "*/ "
    INDEX id IS PRIMARY cod_estab cod_espec_docto cod_ser_docto cod_tit_acr cod_parcela.

DEFINE INPUT PARAMETER TABLE FOR tt_tit_acr.

DEF VAR Rw-Log-Exec                             AS ROWID                      NO-UNDO.
DEF VAR C-Erro-Rpc                              AS CHAR FORM "x(60)" INIT " " NO-UNDO.
DEF VAR C-Erro-Aux                              AS CHAR FORM "x(60)" INIT " " NO-UNDO.

/****************** Defini‡ao de Vari veis de Processamento do Relat¢rio *********************/

DEF VAR V_Cod_Empresa           LIKE EmsUni.Empresa.Cod_Empresa                 NO-UNDO.
DEF VAR I                       AS INTE                                         NO-UNDO.
DEF VAR V_Cod_Dwb_File          LIKE Dwb_Set_List_Param.Cod_Dwb_File     NO-UNDO.
DEF VAR V_Cod_Dwb_Output        LIKE Dwb_Set_List_Param.Cod_Dwb_Output   NO-UNDO.
DEF VAR C-Impressora            LIKE Ped_Exec_Param.Nom_Dwb_Printer      NO-UNDO.
DEF VAR C-Layout                LIKE Ped_Exec_Param.Cod_Dwb_Print_Layout NO-UNDO.
DEF VAR H-Hacr155               AS HANDLE             NO-UNDO.
DEF VAR V-Cod-Destino-Impres    AS CHAR               NO-UNDO.
DEF VAR V-Num-Reg-Lidos         AS INTE               NO-UNDO.
DEF VAR V-Num-Point             AS INTE               NO-UNDO.
DEF VAR V-Num-Set               AS INTE               NO-UNDO.
DEF VAR V-Cod-Arquivo           AS CHAR.
DEF VAR V-Num-Tip-Reg           AS INTE FORM "999".
DEF VAR C-Empresa               AS CHAR FORM "x(40)"  NO-UNDO.
DEF VAR c-titulo-relat          AS CHAR FORM "x(50)"  NO-UNDO.
DEF VAR C-Sistema               AS CHAR FORM "x(25)"  NO-UNDO.
DEF VAR C-Rodape                AS CHAR               NO-UNDO.
DEF VAR C-Programa              AS CHAR FORM "x(08)"  NO-UNDO.
DEF VAR C-Versao                AS CHAR FORM "x(04)"  NO-UNDO.
DEF VAR C-Revisao               AS CHAR FORM "999"    NO-UNDO.
DEF VAR V_Num_Pag               AS INTE INIT 1        NO-UNDO.
DEF VAR Ch_Linha                AS CHAR FORM "x(215)" NO-UNDO.

DEF VAR c_cod_estab_ini         LIKE tit_acr.cod_estab.
DEF VAR c_cod_estab_fim         LIKE tit_acr.cod_estab.
DEF VAR c_cod_tit_acr_ini       LIKE tit_acr.cod_tit_acr.
DEF VAR c_cod_tit_acr_fim       LIKE tit_acr.cod_tit_acr.
DEF VAR c_cod_ser_docto_ini     LIKE tit_acr.cod_ser_docto.
DEF VAR c_cod_ser_docto_fim     LIKE tit_acr.cod_ser_docto.
DEF VAR c_cod_parcela_ini       LIKE tit_acr.cod_parcela.
DEF VAR c_cod_parcela_fim       LIKE tit_acr.cod_parcela.
DEF VAR c_cod_espec_docto_ini   LIKE tit_acr.cod_espec_docto.
DEF VAR c_cod_espec_docto_fim   LIKE tit_acr.cod_espec_docto.
DEF VAR i_cdn_cliente_ini       LIKE tit_acr.cdn_cliente.
DEF VAR i_cdn_cliente_fim       LIKE tit_acr.cdn_cliente.
DEF VAR l-log-matriz            AS LOGICAL.
DEF VAR i-corresp               AS INTEGER.
DEF VAR i-chefe                 AS INTEGER.
DEF VAR l-protesto              AS LOGICAL. 
DEF VAR l-imp                   AS LOGICAL. 
DEF VAR dt-vencimen             AS DATE FORMAT "99/99/9999".
DEF VAR de-valor                LIKE tit_acr.val_sdo_tit_acr.
DEF VAR i-sequencia             LIKE histor_clien.num_seq_histor_clien.

DEF VAR c-chefe                 AS CHAR FORMAT "X(30)".
DEF VAR c-cargo                 AS CHAR FORMAT "X(30)".
DEF VAR l-cab                   AS LOGICAL INITIAL NO NO-UNDO.
DEF VAR c-estab                 AS CHAR FORMAT "x(3)" NO-UNDO.    
DEF VAR c-titulos               AS CHAR               NO-UNDO.
DEF VAR i-skip                  AS INTEGER            NO-UNDO.
DEF VAR i-cont                  AS INTEGER            NO-UNDO.

DEF VAR c-mes                   AS CHAR EXTENT 12 FORMAT "X(10)" INIT 
 ["Janeiro","Fevereiro","Marco","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"].

DEF STREAM Stream_1.

DEF BUFFER B_Ped_Exec_Style     FOR Ped_Exec.
DEF BUFFER B_Servid_Exec_Style  FOR servid_Exec.
DEF BUFFER b_pessoa_jurid       FOR pessoa_jurid.
DEF BUFFER b_cliente            FOR emscad.cliente.
                                
DEF NEW SHARED VAR V_Rpt_Stream_1_Lines      AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Columns    AS INTE INIT 255.
DEF NEW SHARED VAR V_Rpt_Stream_1_Bottom     AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Page       AS INTE.
DEF NEW SHARED VAR V_Rpt_Stream_1_Name       AS CHAR INIT "".

{esinc\es0003.i &Prog="esacr016"}
{esp\acr\esacr016tt.i}

ASSIGN C-Programa          = "esacr016"
       C-Versao            = "1.00"
       C-Revisao           = "001"
       c-titulo-relat      = "Carta de Anuˆncia"
       V_Rpt_Stream_1_Name = c-titulo-relat
       C-Sistema           = "ESP"
       Ch_Linha            = FILL("-",255).

ASSIGN V_Num_Pag = 1.

RUN Pi_Imprime_Relat.  

OUTPUT STREAM Stream_1 CLOSE.

IF  V_Cod_Dwb_Output = "Terminal" THEN
    RUN pi-abre-edit (INPUT V_Cod_Dwb_File).

RETURN "OK".

/* fim do programa */

PROCEDURE Pi_Imprime_Relat:

    IF CAN-FIND (FIRST tt_tit_acr WHERE
                       tt_tit_acr.l-marcado) THEN DO:       

        ASSIGN i-skip = 1.
        FOR EACH  tt_tit_acr 
            WHERE tt_tit_acr.l-marcado NO-LOCK:
            ASSIGN i-skip = i-skip + 1.
        END.
        ASSIGN i-skip = 22 - i-skip.
        IF i-skip <= 0 THEN i-skip = 1.

        FOR EACH tt_tit_acr WHERE
                 tt_tit_acr.l-marcado:

            IF tt_tit_acr.dat_vencto_origin_tit_acr = ? THEN
                ASSIGN tt_tit_acr.dat_vencto_origin_tit_acr = DATE(01,01,0001).

            FIND FIRST emitente NO-LOCK WHERE
                       emitente.cod-emitente = tt_tit_acr.cdn_cliente NO-ERROR.

            IF NOT(l-cab) THEN DO:
                IF V_Cod_Dwb_Output = "Impressora" THEN DO:
                    PUT STREAM Stream_1 CHR(027) + CHR(040) + CHR(115) + CHR(048) + CHR(080).
                    PUT STREAM Stream_1 CHR(027) + CHR(040) + CHR(115) + CHR(053) + CHR(084). 
                    PUT STREAM Stream_1 CHR(027) + CHR(040) + CHR(115) + "12" + CHR(086). 
                END.

                DO i-cont = 0 TO i-skip:
                    PUT STREAM Stream_1 SKIP(1).
                END.

                PUT STREAM Stream_1 SPACE(31) "D E C L A R A C A O" SKIP SPACE(31) "-------------------".
                PUT STREAM Stream_1 SKIP(2) SPACE(5)
                   "Declaramos para os devidos fins e especialmente para fins de baixa e/ou" SKIP SPACE(5)
                   "cancelamento de protesto,  que a(s) duplicata(s) abaixo relacionada(s)," SKIP SPACE(5)
                   "de nossa emissao, contra " emitente.nome-emit "," SKIP SPACE(5) 
                   "encontra(m)-se  quitada(s)," SKIP SPACE(5)
                   "desta forma, nada opomos quanto a baixa e/ou cancelamento do protesto." SKIP(1).

                /* Primeira Linha - Traco Superior */
                PUT STREAM Stream_1
                    SPACE(5) 
                    "+------------------+------------+----------------+--------------------+" SKIP 
                    SPACE(5)
                    "|      TITULO      | VENCIMENTO |    VALOR R$    |      CPF/CNPJ      |" SKIP
                    SPACE(5) 
                    "+------------------+------------+----------------+--------------------+" SKIP.

                ASSIGN l-cab = YES.
            END.

            PUT STREAM Stream_1
                SPACE(5) "| ".

            ASSIGN c-estab = "   ":U.
            IF tt_tit_acr.cod_espec_docto = "VD":U THEN DO:
                ASSIGN c-estab = tt_tit_acr.cod_estab.
            END.

            /** Titulo **/
            IF l-imp THEN
                PUT STREAM Stream_1
                    tt_tit_acr.cod_espec_docto
                    c-estab
                    TRIM(tt_tit_acr.cod_tit_acr) 
                    TRIM(tt_tit_acr.cod_parcela) FORMAT "99" 
                    SPACE(1) "| ".
            ELSE
                PUT STREAM Stream_1 
                    "   "
                    c-estab
                    TRIM(tt_tit_acr.cod_tit_acr)
                    TRIM(tt_tit_acr.cod_parcela) FORMAT "99"
                    SPACE(1)  "| ".

            /** Dt Vencto / Valor / CPF/CNPJ **/
            IF tt_tit_acr.dat_vencto_origin_tit_acr = DATE(01,01,0001) THEN DO:
                IF tt_tit_acr.num_pessoa MODULO 2 <> 0 THEN
                    PUT STREAM Stream_1
                        "  A Vista"
                        SPACE(2) "| "
                        tt_tit_acr.val_origin_tit_acr FORMAT ">>>,>>>,>>9.99"
                        " | "
                        emitente.cgc FORMAT "99.999.999/9999-99"
                        " |"
                        SKIP.
                ELSE
                    PUT STREAM Stream_1
                        "  A Vista"
                        SPACE(2) "| "
                        tt_tit_acr.val_origin_tit_acr FORMAT ">>>,>>>,>>9.99"
                        " |    "
                        emitente.cgc FORMAT "999.999.999-99"
                        "  |"
                        SKIP.
            END.
            ELSE DO:
                IF tt_tit_acr.num_pessoa MODULO 2 <> 0 THEN
                    PUT STREAM Stream_1
                        tt_tit_acr.dat_vencto_origin_tit_acr
                        SPACE(1) "| "
                        tt_tit_acr.val_origin_tit_acr FORMAT ">>>,>>>,>>9.99"
                        " | "
                        emitente.cgc FORMAT "99.999.999/9999-99"
                        " |"
                        SKIP.
                ELSE
                    PUT STREAM Stream_1
                        tt_tit_acr.dat_vencto_origin_tit_acr
                        SPACE(1) "| "
                        tt_tit_acr.val_origin_tit_acr FORMAT ">>>,>>>,>>9.99"
                        " |    "
                        emitente.cgc FORMAT "999.999.999-99"
                        "  |"
                        SKIP.
            END.

            PUT STREAM Stream_1
                SPACE(5) 
                "+------------------+------------+----------------+--------------------+" SKIP.

            ASSIGN c-titulos = STRING(tt_tit_acr.cod_tit_acr,"9999999") + "-" + STRING(tt_tit_acr.cod_parcela,"99") + " com vencimento em " + STRING(tt_tit_acr.dat_vencto_origin_tit_acr,"99/99/9999") + " e valor " + STRING(tt_tit_acr.val_origin_tit_acr,">>>,>>>,>>9.99") + CHR(10).
            
            FIND FIRST tt_histor_clien WHERE 
                       tt_histor_clien.cod_empresa = tt_tit_acr.cod_empresa AND
                       tt_histor_clien.cdn_cliente = tt_tit_acr.cdn_cliente NO-LOCK NO-ERROR.
            IF NOT AVAIL tt_histor_clien THEN DO:
                CREATE tt_histor_clien.
                ASSIGN tt_histor_clien.cod_empresa = tt_tit_acr.cod_empresa
                       tt_histor_clien.cdn_cliente = tt_tit_acr.cdn_cliente.
            END.
            ASSIGN tt_histor_clien.titulos = tt_histor_clien.titulos + c-titulos.

        END. /* each tt_tit_acr */

        /**  Cria Historico Cliente **/
        FOR EACH tt_histor_clien:
            FIND LAST histor_clien
                WHERE histor_clien.cod_empresa = tt_histor_clien.cod_empresa
                  AND histor_clien.cdn_cliente = tt_histor_clien.cdn_cliente NO-ERROR.
            IF AVAIL histor_clien THEN
                ASSIGN i-sequencia = histor_clien.num_seq_histor_clien + 1.
            ELSE 
                ASSIGN i-sequencia = 1.

            CREATE tt_histor_clien_integr.
            ASSIGN tt_histor_clien_integr.tta_cod_empresa                  = tt_histor_clien.cod_empresa 
                   tt_histor_clien_integr.tta_cdn_cliente                  = tt_histor_clien.cdn_cliente
                   tt_histor_clien_integr.tta_num_seq_histor_clien         = i-sequencia
                   tt_histor_clien_integr.tta_des_abrev_histor_clien       = STRING(TODAY,"99/99/9999") + " * Enviamos carta de anuˆncia" 
                   tt_histor_clien_integr.tta_des_histor_clien             = "Enviamos carta de anuencia para os t¡tulos: " + CHR(10) +
                                                                             tt_histor_clien.titulos +
                                                                             "Correspondencia: " + IF i-corresp = 1 THEN "Sedex" ELSE "Normal"  + CHR(10) +
                                                                             "    Protesto: "    + STRING(l-protesto,"Sim/NÆo")
                   tt_histor_clien_integr.ttv_num_tip_operac               = 1.

            RUN prgint/utb/utb765ze.py(1 ,
                                       INPUT TABLE tt_cliente_integr,
                                       INPUT TABLE tt_fornecedor_integr,
                                       INPUT TABLE tt_clien_financ_integr_e,
                                       INPUT TABLE tt_fornec_financ_integr_d,
                                       INPUT TABLE tt_pessoa_jurid_integr_e,
                                       INPUT TABLE tt_pessoa_fisic_integr_e,
                                       INPUT TABLE tt_contato_integr_e,
                                       INPUT TABLE tt_contat_clas_integr,
                                       INPUT TABLE tt_estrut_clien_integr,
                                       INPUT TABLE tt_estrut_fornec_integr,
                                       INPUT TABLE tt_histor_clien_integr,
                                       INPUT TABLE tt_histor_fornec_integr,
                                       INPUT TABLE tt_ender_entreg_integr_e,
                                       INPUT TABLE tt_telef_integr,
                                       INPUT TABLE tt_telef_pessoa_integr,
                                       INPUT TABLE tt_pj_ativid_integr,
                                       INPUT TABLE tt_pj_ramo_negoc_integr,
                                       INPUT TABLE tt_porte_pj_integr,
                                       INPUT TABLE tt_idiom_pf_integr,
                                       INPUT TABLE tt_idiom_contat_integr,
                                       INPUT "", /*Matriz de Tradu‡Æo Organizacional*/
                                       INPUT "", /*Empresa*/
                                       INPUT-OUTPUT TABLE tt_retorno_clien_fornec).
        END. /* each tt_histor_clien */

        PUT STREAM Stream_1
            SKIP(2)
            SPACE(23) "Sao Jose, " 
            DAY(TODAY) FORMAT "99"
            " de " 
            TRIM(c-mes[MONTH(TODAY)]) FORMAT "x(9)"
            " de " 
            YEAR(TODAY) FORMAT "9999"
            "." SKIP(6)
            SPACE(28)
            c-chefe SKIP
            SPACE(28) 
            c-cargo.

    END. /* can-find */
END PROCEDURE.

PROCEDURE piAtualizaCampos:
    ASSIGN c_cod_tit_acr_ini      = ENTRY(2,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           c_cod_tit_acr_fim      = ENTRY(3,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           c_cod_ser_docto_ini    = ENTRY(4,dwb_set_list_param.cod_dwb_parameters,CHR(10))  
           c_cod_ser_docto_fim    = ENTRY(5,dwb_set_list_param.cod_dwb_parameters,CHR(10))  
           c_cod_parcela_ini      = ENTRY(6,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           c_cod_parcela_fim      = ENTRY(7,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           c_cod_espec_docto_ini  = ENTRY(8,dwb_set_list_param.cod_dwb_parameters,CHR(10))         
           c_cod_espec_docto_fim  = ENTRY(9,dwb_set_list_param.cod_dwb_parameters,CHR(10))                    
           i-corresp              = INTEGER(ENTRY(10,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           i-chefe                = INTEGER(ENTRY(11,dwb_set_list_param.cod_dwb_parameters,CHR(10))) 
           l-protesto             = ENTRY(12,dwb_set_list_param.cod_dwb_parameters,CHR(10)) = 'YES'
           l-imp                  = ENTRY(13,dwb_set_list_param.cod_dwb_parameters,CHR(10)) = 'YES'
           c_cod_estab_ini        = ENTRY(14,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           c_cod_estab_fim        = ENTRY(15,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           i_cdn_cliente_ini      = INTEGER(ENTRY(16,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           i_cdn_cliente_fim      = INTEGER(ENTRY(17,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           l-log-matriz           = ENTRY(18,dwb_set_list_param.cod_dwb_parameters,CHR(10)) = 'YES'.

    IF i-chefe = 1 THEN
        ASSIGN c-chefe = "FERNANDO RODRIGO SAGAZ"
               c-cargo = "Supervisor de Controladoria".
    ELSE 
        ASSIGN c-chefe = "JAIR P. TONIN ZANCHIN"
               c-cargo = "Gerente Financeiro".
END PROCEDURE.

PROCEDURE Pi-Abre-Edit:
  DEF INPUT PARAM P_Cod_Dwb_File AS CHAR FORM "x(40)" NO-UNDO.
  DEF VAR V_Cod_Key_Value        AS CHAR FORM "x(08)" NO-UNDO.

  GET-KEY-VALUE SECTION 'EMS' KEY 'Show-Report-Program' VALUE V_Cod_Key_Value.
  if V_Cod_Key_Value = "" OR 
     V_Cod_Key_Value = ?  THEN 
  DO.
    ASSIGN V_Cod_Key_Value = 'start'.
    PUT-KEY-VALUE SECTION 'EMS' KEY 'Show-Report-Program' VALUE V_Cod_Key_Value NO-ERROR.
  END. /* End do - if V_Cod_Key_Value = "" OR V_Cod_Key_Value = ? */

  OS-COMMAND SILENT VALUE(V_Cod_Key_Value + CHR(32) + P_Cod_Dwb_File).
END PROCEDURE.  /* End da Procedure Pi-Abre-Edit */

IF I-Num-Ped-Exec-Rpw <> 0 
THEN RETURN "OK".

