 /******************************************************************************************
**  Programa: esacr081rp.p
**  Funcao..: Importar antecipa‡Æo concilia‡Æo financeira
**  Autor...: Gesplus Software
**  Data....: jan/2020  
**  Versao..: 1.00.00.000 - Versao Inicial.
******************************************************************************************/
/* include de controle de versao */
{include/i-prgvrs.i esacr081rp 1.00.00.002}
{include/i-rpvar.i}
{utp/ut-glob.i}
{cdp/cdcfgmat.i} 
{esp/acr/esacr081.i "new shared"} /* defini‡äes para geracao da antecipa‡Æo */

/* preprocessador para ativar ou nao a saida para RTF */
&GLOBAL-DEFINE RTF NO
/* preprocessador para setar o tamanho da pagina */
&SCOPED-DEFINE pagesize 62  

/* definicao das temp-tables para recebimento de parametros */
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino        AS INTEGER
    FIELD arquivo        AS CHAR FORMAT "x(35)":U
    FIELD usuario        AS CHAR FORMAT "x(12)":U
    FIELD data-exec      AS DATE
    FIELD hora-exec      AS INTEGER
    FIELD arquivo-import AS CHAR FORMAT "x(256)"
    FIELD ind-tipo       AS INT /* 1 - concil financ, 2 - devolucao */.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

/* recebimento de parametros */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* defini‡Æo de variaveis */
DEF VAR h-acomp             AS HANDLE        NO-UNDO.
DEF VAR c-arq-rec           AS CHARACTER     NO-UNDO. 
DEF VAR c-arq-import        AS CHARACTER     NO-UNDO. 
DEF VAR c-arq-log           AS CHARACTER     NO-UNDO. 
DEF VAR c1                  AS CHARACTER NO-UNDO. /*file name*/
DEF VAR c2                  AS CHARACTER NO-UNDO. /*file name with path*/
DEF VAR c_erro_aux          AS CHAR FORMAT "x(256)".
DEF VAR c-arq-log-aux       AS CHAR NO-UNDO.
DEF VAR c-parcela           AS CHAR NO-UNDO.

DEF BUFFER b_tit_acr FOR tit_acr.

/* temp-table onde seraÿ gravado o nome dos arquivos para importa‡Æo */ 
DEFINE TEMP-TABLE tt-arquivo    
    FIELD nm-arquivo-completo AS CHAR FORMAT "x(256)"
    FIELD nm-arquivo          AS CHAR FORMAT "x(256)". 

/* temp-table com os dados da planilha de importa‡Æo */
DEFINE TEMP-TABLE tt-import    
    FIELD linha                 AS INT /* int */
    FIELD cod_estab             LIKE tit_acr.cod_estab   /* char */
    FIELD cod_espec_docto       LIKE tit_acr.cod_espec_docto /* char */
    FIELD cod_ser_docto         LIKE tit_acr.cod_ser_docto /* char */
    FIELD cod_tit_acr           LIKE tit_acr.cod_tit_acr /* char */
    FIELD cod_parcela           LIKE tit_acr.cod_parcela /* char */
    FIELD cdn_cliente           LIKE tit_acr.cdn_cliente /* int */
    FIELD dat_emis_docto        LIKE tit_acr.dat_emis_docto /* date */ 
    FIELD val_liq_tit_acr       LIKE tit_acr.val_liq_tit_acr /* deci */
    FIELD cod_portador          LIKE tit_acr.cod_portador /* char */
    FIELD cod_cart_bcia         LIKE tit_acr.cod_cart_bcia /* char */
    FIELD nr-pedido             LIKE ped-venda.nr-pedido /* int */
    FIELD origem                AS CHAR /* char */
    FIELD cod_indic_econ        LIKE tit_acr.cod_indic_econ /* char */ 
    FIELD val_cotac_indic_econ  as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 /* dec */
    FIELD cod_unid_negoc        as character format "x(3)" /* char */
    FIELD cod_cta_ctbl          as character format "x(20)" /* char */
    FIELD nf_cliente            AS CHAR /* char */.

    
/* inicio */
FIND FIRST mguni.empresa NO-LOCK   
     WHERE empresa.ep-codigo = v_cdn_empres_usuar NO-ERROR.  

assign c-versao       = "1.00"
       c-revisao      = "000"
       c-empresa      = empresa.razao-social
       c-programa     = "esacr081rp.p"
       c-titulo-relat = "Importa‡Æo Antecipa‡Æo Concilia‡Æo Financeira".
       
{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

DEF STREAM s1.

/************** BLOCO PRINCIPAL ***************/

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar IN h-acomp (INPUT "In¡cio Importa‡Æo"). 

FIND FIRST tt-param NO-ERROR.
FIND FIRST param-concil-financ NO-LOCK NO-ERROR.
FIND FIRST matriz_trad_org_ext NO-LOCK NO-ERROR.

/* validar diret¢rios de importa‡Æo */
RUN pi-valida-diretorios. 
IF RETURN-VALUE = "NOK" THEN DO:
    RUN pi-finalizar IN h-acomp.
    RETURN "NOK".
END.

/* carregar arquivo(s) */
RUN pi-carrega-arquivos.
IF RETURN-VALUE = "NOK" THEN DO:
    RUN pi-finalizar IN h-acomp.
    RETURN "NOK".
END.

RUN pi-inicializar IN h-acomp (INPUT "Processando arquivos...").

/* processar arquivo(s) */
RUN pi-processa-arquivos.

RUN pi-finalizar IN h-acomp.
{include/i-rpclo.i}
RETURN "OK":U.

/************** PROCEDURES ***************/

PROCEDURE pi-valida-diretorios: /* valida‡äes diretorios de importa‡Æo */
    
    /* quando nÆo for informado arquivo em tela, vai validar diretorio de arquivos recebidos */
    IF tt-param.arquivo-import = "" THEN DO:           
        IF param-concil-financ.dir-arq-recebidos-an = "" OR 
           param-concil-financ.dir-arq-recebidos-an = ? THEN DO:
            PUT "Erro: Diret¢rio de arquivos recebidos nÆo parametrizado. Verificar parƒmetros concilia‡Æo financeira.".
            RETURN "NOK".
        END.
    END.
    
    IF param-concil-financ.dir-arq-importados-an = "" OR 
       param-concil-financ.dir-arq-importados-an = ? THEN DO:
        PUT "Erro: Diret¢rio de arquivos importados nÆo parametrizado. Verificar parƒmetros concilia‡Æo financeira.".
        RETURN "NOK".
    END.
    
    IF param-concil-financ.dir-arq-log-an = "" OR 
       param-concil-financ.dir-arq-log-an = ? THEN DO:
        PUT "Erro: Diret¢rio de arquivos log nÆo parametrizado. Verificar parƒmetros concilia‡Æo financeira.".
        RETURN "NOK".
    END.

END PROCEDURE.

PROCEDURE pi-carrega-arquivos: /* carregar temp-table tt-arquivo com os arquivos que serÆo importados */

    EMPTY TEMP-TABLE tt-arquivo.

    ASSIGN c-arq-rec     = param-concil-financ.dir-arq-recebidos-an
           c-arq-import  = param-concil-financ.dir-arq-importados-an
           c-arq-log     = param-concil-financ.dir-arq-log-an.  

    IF tt-param.arquivo-import = "" THEN DO:                        
        IF OPSYS = 'WIN32' THEN
            ASSIGN c-arq-rec    = REPLACE(c-arq-rec,'/','\')
                   c-arq-import = REPLACE(c-arq-import,'/','\')
                   c-arq-log    = REPLACE(c-arq-log,'/','\').
    
        INPUT FROM OS-DIR(c-arq-rec) CONVERT SOURCE 'iso8859-1'.
        REPEAT:
            IMPORT c1 c2 .
            IF c1 = "." OR c1 = ".." THEN NEXT.

            IF tt-param.ind-tipo = 1 /* concil financeira */ THEN DO:
                IF INDEX(c1, "conc") > 0 THEN DO:
                    CREATE tt-arquivo. 
                    ASSIGN tt-arquivo.nm-arquivo-completo = c2
                           tt-arquivo.nm-arquivo = c1.    
                END.
            END.
            ELSE DO: /* devolu‡Æo */
                IF INDEX(c1, "dev") > 0 THEN DO:
                    CREATE tt-arquivo. 
                    ASSIGN tt-arquivo.nm-arquivo-completo = c2
                           tt-arquivo.nm-arquivo = c1.    
                END.
            END.
        END.
        INPUT CLOSE.
    END.
    ELSE DO:
        IF tt-param.ind-tipo = 1 /* concil financeira */ THEN DO:
            IF INDEX(tt-param.arquivo-import, "recebidos\conc") = 0 THEN DO:
                PUT "Erro: Arquivo selecionado nÆo ‚ do tipo concilia‡Æo financeira.".
                RETURN "NOK".
            END.
        END.
        ELSE DO: /* devolu‡Æo */
            IF INDEX(tt-param.arquivo-import, "recebidos\dev") = 0 THEN DO:
                PUT "Erro: Arquivo selecionado nÆo ‚ do tipo devolu‡Æo.".
                RETURN "NOK".
            END.
        END.

        CREATE tt-arquivo. 
        ASSIGN tt-arquivo.nm-arquivo-completo = tt-param.arquivo-import
               tt-arquivo.nm-arquivo          = tt-param.arquivo-import.
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-processa-arquivos: /* processar arquivos de importa‡Æo */

    ASSIGN c-arq-log-aux = c-arq-log + "LogAntecip-Mes" + STRING(MONTH(TODAY),"99") + "-Dia" + STRING(DAY(TODAY),"99") + "-" + STRING(TIME) + ".txt".
    OUTPUT STREAM s1 TO VALUE(c-arq-log-aux) CONVERT TARGET "iso8859-1".

    FOR EACH tt-arquivo:

        RUN pi-acompanhar IN h-acomp (INPUT "Lendo arquivo: " + tt-arquivo.nm-arquivo). 

        PUT "--------" SKIP
            "Arquivo: " tt-arquivo.nm-arquivo     SKIP
            "--------" SKIP(1).
        PUT STREAM s1 "--------" SKIP
                      "Arquivo: " tt-arquivo.nm-arquivo     SKIP
                      "--------" SKIP(1).

        /* importar dados da planilha */
        IF tt-param.ind-tipo = 1 /* concil financeira */ THEN
            RUN pi-importa-concil.
        ELSE /* devolu‡Æo */
            RUN pi-importa-dev.

        /* gerar antecipa‡Æo */
        IF CAN-FIND(FIRST tt-import) THEN DO:
            RUN pi-gera-an.

            RUN pi-move-arquivo (INPUT tt-arquivo.nm-arquivo-completo).
        END.
        ELSE DO:
            PUT "Arquivo inv lido, ou em branco, ou nÆo est  no modelo definido para importa‡Æo. Arquivo nÆo ser  movido para o diret¢rio de importados." AT 03 SKIP(1).
            PUT STREAM s1 "Arquivo inv lido, ou em branco, ou nÆo est  no modelo definido para importa‡Æo. Arquivo nÆo ser  movido para o diret¢rio de importados." AT 03 SKIP(1).
        END.  
           
    END.

    OUTPUT STREAM s1 CLOSE. 

END PROCEDURE.

PROCEDURE pi-importa-concil : /* importar dados da planilha concilia‡Æo financeira */

    DEFINE VARIABLE ch-excel            AS COM-HANDLE  NO-UNDO.
    DEFINE VARIABLE ch-arquivo          AS COM-HANDLE  NO-UNDO.
    DEFINE VARIABLE ch-planilha         AS COM-HANDLE  NO-UNDO.
    DEFINE VARIABLE i-linha             AS INTEGER     NO-UNDO.
    
    DEFINE VARIABLE v_cod_estab             LIKE tit_acr.cod_estab.   /* char */     
    DEFINE VARIABLE v_cdn_cliente           LIKE tit_acr.cdn_cliente. /* int */      
    DEFINE VARIABLE v_dat_emis_docto        LIKE tit_acr.dat_emis_docto. /* date */  
    DEFINE VARIABLE v_val_liq_tit_acr       LIKE tit_acr.val_liq_tit_acr. /* deci */ 
    DEFINE VARIABLE v_cod_portador          LIKE tit_acr.cod_portador. /* char */    
    DEFINE VARIABLE v_cod_cart_bcia         LIKE tit_acr.cod_cart_bcia. /* char */   
    DEFINE VARIABLE v_nr-pedido             LIKE ped-venda.nr-pedido. /* int */      
    DEFINE VARIABLE v_origem                AS CHAR. /* char */       
    DEFINE VARIABLE v_cod_indic_econ        AS CHAR. /* char */
    DEFINE VARIABLE v_val_cotac_indic_econ  as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0. /* dec */
    DEFINE VARIABLE v_cod_unid_negoc        AS CHAR. /* char */
    DEFINE VARIABLE v_cod_cta_ctbl          AS CHAR. /* char */
    DEFINE VARIABLE v_nf_cliente            AS CHAR. /* char */

    EMPTY TEMP-TABLE tt-import.
    
    CREATE "Excel.Application" ch-excel.
    ch-excel:ScreenUpdating = NO.
    ch-excel:Visible = NO.
    ch-arquivo  = ch-excel:workbooks:OPEN(tt-arquivo.nm-arquivo-completo).
    ch-planilha = ch-arquivo:sheets:ITEM(1).
    
    ASSIGN i-linha = 1.

    bloco_leitura_arquivo_excel:
    REPEAT ON ERROR UNDO bloco_leitura_arquivo_excel, LEAVE bloco_leitura_arquivo_excel ON STOP UNDO bloco_leitura_arquivo_excel, LEAVE bloco_leitura_arquivo_excel:
        ASSIGN i-linha = i-linha + 1.
    
        
        ASSIGN v_cod_estab            = ENTRY(1,ch-planilha:range("A" + STRING(i-linha)):VALUE,",")
               v_cdn_cliente          = INT(ch-planilha:range("B" + STRING(i-linha)):VALUE)
               v_dat_emis_docto       = DATE(ch-planilha:range("C" + STRING(i-linha)):VALUE)
               v_val_liq_tit_acr      = DECIMAL(ch-planilha:range("D" + STRING(i-linha)):VALUE)
               v_cod_portador         = ENTRY(1,ch-planilha:range("E" + STRING(i-linha)):VALUE,",")
               v_cod_cart_bcia        = ENTRY(1,ch-planilha:range("F" + STRING(i-linha)):VALUE,",")
               v_nr-pedido            = INT(ch-planilha:range("G" + STRING(i-linha)):VALUE)
               v_origem               = ENTRY(1,ch-planilha:range("H" + STRING(i-linha)):VALUE,",")
               v_cod_indic_econ       = ENTRY(1,ch-planilha:range("I" + STRING(i-linha)):VALUE,",")
               v_val_cotac_indic_econ = DECIMAL(ch-planilha:range("J" + STRING(i-linha)):VALUE)
               v_cod_unid_negoc       = ENTRY(1,ch-planilha:range("K" + STRING(i-linha)):VALUE,",")
               v_cod_cta_ctbl         = ENTRY(1,ch-planilha:range("L" + STRING(i-linha)):VALUE,",")
               v_nf_cliente           = ENTRY(1,ch-planilha:range("M" + STRING(i-linha)):VALUE,",").
        
        IF (v_cod_estab              = ? OR v_cod_estab         = "") THEN DO:

            RELEASE OBJECT ch-planilha.
            //ch-arquivo:SAVE.
            ch-arquivo:CLOSE.
            RELEASE OBJECT ch-arquivo.
            ch-excel:QUIT().
            RELEASE OBJECT ch-excel.
            
            LEAVE bloco_leitura_arquivo_excel.
        END.
    
        CREATE tt-import.
        ASSIGN tt-import.linha                = i-linha
               tt-import.cod_estab            = v_cod_estab
               tt-import.cdn_cliente          = v_cdn_cliente    
               tt-import.dat_emis_docto       = v_dat_emis_docto 
               tt-import.val_liq_tit_acr      = v_val_liq_tit_acr
               tt-import.cod_portador         = v_cod_portador   
               tt-import.cod_cart_bcia        = v_cod_cart_bcia  
               tt-import.nr-pedido            = v_nr-pedido      
               tt-import.origem               = v_origem
               tt-import.cod_espec_docto      = param-concil-financ.cod-espec-docto
               tt-import.cod_ser_docto        = param-concil-financ.cod-ser-docto
               tt-import.cod_tit_acr          = SUBSTRING(v_origem,1,3) + STRING(v_nr-pedido)
               tt-import.cod_parcela          = param-concil-financ.cod-parcela
               tt-import.cod_indic_econ       = "Real"           
               tt-import.val_cotac_indic_econ = 1
               tt-import.cod_unid_negoc       = "ADM"      
               tt-import.cod_cta_ctbl         = ""
               tt-import.nf_cliente           = "".

    END.
    
    IF VALID-HANDLE(ch-planilha) THEN DO:
        RELEASE OBJECT ch-planilha.
        //ch-arquivo:SAVE.
        ch-arquivo:CLOSE.
        RELEASE OBJECT ch-arquivo.
        ch-excel:QUIT().
        RELEASE OBJECT ch-excel.
    END.
    
    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-importa-dev : /* importar dados da planilha devolu‡Æo */

    DEFINE VARIABLE ch-excel            AS COM-HANDLE  NO-UNDO.
    DEFINE VARIABLE ch-arquivo          AS COM-HANDLE  NO-UNDO.
    DEFINE VARIABLE ch-planilha         AS COM-HANDLE  NO-UNDO.
    DEFINE VARIABLE i-linha             AS INTEGER     NO-UNDO.
    
    DEFINE VARIABLE v_cod_estab             LIKE tit_acr.cod_estab.   /* char */     
    DEFINE VARIABLE v_cdn_cliente           LIKE tit_acr.cdn_cliente. /* int */      
    DEFINE VARIABLE v_dat_emis_docto        LIKE tit_acr.dat_emis_docto. /* date */  
    DEFINE VARIABLE v_val_liq_tit_acr       LIKE tit_acr.val_liq_tit_acr. /* deci */ 
    DEFINE VARIABLE v_cod_tit_acr           LIKE tit_acr.cod_tit_acr. /* char */
    DEFINE VARIABLE v_cod_ser_docto         LIKE tit_acr.cod_ser_docto. /* char */
    DEFINE VARIABLE v_cod_parcela           LIKE tit_acr.cod_parcela. /* char */
    DEFINE VARIABLE v_cod_indic_econ        AS CHAR. /* char */
    DEFINE VARIABLE v_val_cotac_indic_econ  as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0. /* dec */
    DEFINE VARIABLE v_cod_cta_ctbl          AS CHAR. /* char */
    DEFINE VARIABLE v_cod_unid_negoc        AS CHAR. /* char */
    DEFINE VARIABLE v_nf_cliente            AS CHAR. /* char */

    EMPTY TEMP-TABLE tt-import.
    
    CREATE "Excel.Application" ch-excel.
    ch-excel:ScreenUpdating = NO.
    ch-excel:Visible = NO.
    ch-arquivo  = ch-excel:workbooks:OPEN(tt-arquivo.nm-arquivo-completo).
    ch-planilha = ch-arquivo:sheets:ITEM(1).
    
    ASSIGN i-linha = 1.

    bloco_leitura_arquivo_excel:
    REPEAT ON ERROR UNDO bloco_leitura_arquivo_excel, LEAVE bloco_leitura_arquivo_excel ON STOP UNDO bloco_leitura_arquivo_excel, LEAVE bloco_leitura_arquivo_excel:
        ASSIGN i-linha = i-linha + 1.
    
        
        ASSIGN v_cod_estab             = ENTRY(1,ch-planilha:range("A" + STRING(i-linha)):VALUE,",")
               v_cdn_cliente           = INT(ch-planilha:range("B" + STRING(i-linha)):VALUE)
               v_dat_emis_docto        = DATE(ch-planilha:range("C" + STRING(i-linha)):VALUE)
               v_val_liq_tit_acr       = DECIMAL(ch-planilha:range("D" + STRING(i-linha)):VALUE)
               v_cod_tit_acr           = ENTRY(1,ch-planilha:range("E" + STRING(i-linha)):VALUE,",")
               v_cod_ser_docto         = ENTRY(1,ch-planilha:range("F" + STRING(i-linha)):VALUE,",")
               v_cod_parcela           = ENTRY(1,ch-planilha:range("G" + STRING(i-linha)):VALUE,",")
               v_cod_indic_econ        = ENTRY(1,ch-planilha:range("H" + STRING(i-linha)):VALUE,",")
               v_val_cotac_indic_econ  = DECIMAL(ch-planilha:range("I" + STRING(i-linha)):VALUE)
               v_cod_cta_ctbl          = ENTRY(1,ch-planilha:range("J" + STRING(i-linha)):VALUE,",")
               v_cod_unid_negoc        = ENTRY(1,ch-planilha:range("K" + STRING(i-linha)):VALUE,",")
               v_nf_cliente            = ENTRY(1,ch-planilha:range("L" + STRING(i-linha)):VALUE,",").
                
        
        IF (v_cod_estab              = ? OR v_cod_estab         = "") THEN DO:

            RELEASE OBJECT ch-planilha.
            //ch-arquivo:SAVE.
            ch-arquivo:CLOSE.
            RELEASE OBJECT ch-arquivo.
            ch-excel:QUIT().
            RELEASE OBJECT ch-excel.
            
            LEAVE bloco_leitura_arquivo_excel.
        END.
    
        CREATE tt-import.
        ASSIGN tt-import.linha                = i-linha
               tt-import.cod_estab            = v_cod_estab           
               tt-import.cdn_cliente          = v_cdn_cliente         
               tt-import.dat_emis_docto       = v_dat_emis_docto      
               tt-import.val_liq_tit_acr      = v_val_liq_tit_acr     
               tt-import.cod_portador         = ""
               tt-import.cod_cart_bcia        = ""
               tt-import.nr-pedido            = 0
               tt-import.origem               = ""
               tt-import.cod_espec_docto      = param-concil-financ.cod-espec-docto
               tt-import.cod_ser_docto        = v_cod_ser_docto         
               tt-import.cod_tit_acr          = v_cod_tit_acr        
               tt-import.cod_parcela          = v_cod_parcela          
               tt-import.cod_indic_econ       = v_cod_indic_econ       
               tt-import.val_cotac_indic_econ = 1 / v_val_cotac_indic_econ 
               tt-import.cod_unid_negoc       = v_cod_unid_negoc       
               tt-import.cod_cta_ctbl         = v_cod_cta_ctbl
               tt-import.nf_cliente           = v_nf_cliente.    

    END.
    
    IF VALID-HANDLE(ch-planilha) THEN DO:
        RELEASE OBJECT ch-planilha.
        //ch-arquivo:SAVE.
        ch-arquivo:CLOSE.
        RELEASE OBJECT ch-arquivo.
        ch-excel:QUIT().
        RELEASE OBJECT ch-excel.
    END.
    
    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-gera-an: /* gerar antecipa‡Æo no ACR */

    PUT "Estab Esp‚cie Serie T¡tulo     Parc     Cliente Dt EmissÆo      Vl L¡quid Port  Cart      Pedido Origem       Importado?" AT 01
        "----- ------- ----- ---------- ---- ----------- ---------- -------------- ----- ---- ----------- ------------ ----------" AT 01.

    PUT STREAM s1 "Estab Esp‚cie S‚rie T¡tulo     Parc     Cliente Dt EmissÆo      Vl L¡quid Port  Cart      Pedido Origem       Importado?" AT 01
                  "----- ------- ----- ---------- ---- ----------- ---------- -------------- ----- ---- ----------- ------------ ----------" AT 01.

    FOR EACH tt-import:
        EMPTY TEMP-TABLE tt_log_erros_atualiz.
        EMPTY TEMP-TABLE tt_integr_acr_aprop_ctbl_pend.
        EMPTY TEMP-TABLE tt_integr_acr_item_lote_impl_6.
        EMPTY TEMP-TABLE tt_integr_acr_lote_impl.
        EMPTY TEMP-TABLE tt_integr_acr_ped_vda_pend.
        EMPTY TEMP-TABLE tt_erro_tit_acr.

        RUN pi-cria-lote.
        
        RUN pi-cria-item-lote.

        PUT tt-import.cod_estab       AT 01
            tt-import.cod_espec_docto AT 07
            tt-import.cod_ser_docto   AT 15
            tt-import.cod_tit_acr     AT 21
            c-parcela                 AT 32
            tt-import.cdn_cliente     TO 47
            tt-import.dat_emis_docto  AT 49
            tt-import.val_liq_tit_acr TO 73
            tt-import.cod_portador    AT 75
            tt-import.cod_cart_bcia   AT 81
            tt-import.nr-pedido       TO 96
            tt-import.origem          AT 98.

        PUT STREAM s1
            tt-import.cod_estab       AT 01
            tt-import.cod_espec_docto AT 07
            tt-import.cod_ser_docto   AT 15
            tt-import.cod_tit_acr     AT 21
            c-parcela                 AT 32
            tt-import.cdn_cliente     TO 47
            tt-import.dat_emis_docto  AT 49
            tt-import.val_liq_tit_acr TO 73
            tt-import.cod_portador    AT 75
            tt-import.cod_cart_bcia   AT 81
            tt-import.nr-pedido       TO 96
            tt-import.origem          AT 98.

        RUN pi-executa-api-imp.

        IF CAN-FIND(FIRST tt_erro_tit_acr) THEN DO:            
            PUT "NÆo" AT 111 SKIP. 
            PUT STREAM s1 "NÆo" AT 111 SKIP. 

            FOR EACH tt_erro_tit_acr:
                ASSIGN c_erro_aux = STRING(tt_erro_tit_acr.ttv_num_mensagem) + " - " + tt_erro_tit_acr.ttv_des_msg_erro.
                PUT c_erro_aux AT 111 SKIP.
                PUT STREAM s1 c_erro_aux AT 111 SKIP.
            END.
        END.
        ELSE DO:
            PUT "Sim" AT 111 SKIP.      
            PUT STREAM s1 "Sim" AT 111 SKIP.      
        END.

    END.

    PUT SKIP(1).  
    PUT STREAM s1 SKIP(1).
    
END PROCEDURE.

PROCEDURE pi-cria-lote: /* criar lote */
    DEFINE VARIABLE c-ref AS CHARACTER   NO-UNDO.

    FIND FIRST espec_docto WHERE espec_docto.cod_espec_docto = tt-import.cod_espec_docto NO-LOCK NO-ERROR.

    ASSIGN v_log_refer_unica = NO.
    DO WHILE NOT v_log_refer_unica:
        run pi_retorna_sugestao_referencia (Input "F", Input TODAY, Output v_cod_refer) /* pi_retorna_sugestao_referencia*/.

        run pi_verifica_refer_unica_acr    (Input tt-import.cod_estab,
                                            Input v_cod_refer, 
                                            Input "tit_acr", 
                                            Input ?, 
                                            OUTPUT v_log_refer_unica).
    END.

    CREATE tt_integr_acr_lote_impl.
    ASSIGN tt_integr_acr_lote_impl.tta_cod_empresa          = string(i-ep-codigo-usuario)
           tt_integr_acr_lote_impl.tta_cod_estab            = tt-import.cod_estab
           tt_integr_acr_lote_impl.tta_cod_refer            = v_cod_refer           
           tt_integr_acr_lote_impl.tta_ind_tip_espec_docto  = espec_docto.ind_tip_espec_doc
           tt_integr_acr_lote_impl.tta_ind_orig_tit_acr     = "ACR" 
           tt_integr_acr_lote_impl.ttv_log_lote_impl_ok     = YES
           tt_integr_acr_lote_impl.tta_log_liquidac_autom   = YES
           tt_integr_acr_lote_impl.tta_cod_indic_econ       = tt-import.cod_indic_econ
           v-recid                                          = RECID(tt_integr_acr_lote_impl).    

    IF  tt-import.dat_emis_docto = ? THEN
        ASSIGN tt_integr_acr_lote_impl.tta_dat_transacao    = TODAY.
    ELSE
        ASSIGN tt_integr_acr_lote_impl.tta_dat_transacao    = tt-import.dat_emis_docto.
    
    ASSIGN i-sequencia = 0. /* reinicio da sequencia do filho a cada lote criado */

    
END PROCEDURE.

PROCEDURE pi-cria-item-lote :
    DEF VAR v-log-tit-acr-unico  AS LOGICAL   NO-UNDO.
    
    ASSIGN i-sequencia = i-sequencia + 10.

    /* verifca se ja criou a antecipacao no lote */
    IF CAN-FIND (FIRST tt_integr_acr_item_lote_impl_6
                      WHERE tt_integr_acr_item_lote_impl_6.ttv_rec_lote_impl_tit_acr = v-recid
                        AND tt_integr_acr_item_lote_impl_6.tta_cdn_cliente           = tt-import.cdn_cliente
                        AND tt_integr_acr_item_lote_impl_6.tta_cod_espec_docto       = tt-import.cod_espec_docto
                        AND tt_integr_acr_item_lote_impl_6.tta_cod_tit_acr           = tt-import.cod_tit_acr
                        AND tt_integr_acr_item_lote_impl_6.tta_cod_parcela           = tt-import.cod_parcela) THEN
            RETURN "OK":U.         

    /***** ITEM LOTE *****/
    CREATE tt_integr_acr_item_lote_impl_6.
    ASSIGN tt_integr_acr_item_lote_impl_6.ttv_rec_lote_impl_tit_acr      = v-recid
           tt_integr_acr_item_lote_impl_6.tta_num_seq_refer              = i-sequencia
           tt_integr_acr_item_lote_impl_6.tta_cdn_cliente                = tt-import.cdn_cliente
           tt_integr_acr_item_lote_impl_6.tta_cod_espec_docto            = tt-import.cod_espec_docto
           tt_integr_acr_item_lote_impl_6.tta_cod_ser_docto              = tt-import.cod_ser_docto
           tt_integr_acr_item_lote_impl_6.tta_cod_tit_acr                = tt-import.cod_tit_acr
           tt_integr_acr_item_lote_impl_6.tta_cod_parcela                = tt-import.cod_parcela
           tt_integr_acr_item_lote_impl_6.tta_cod_indic_econ             = tt-import.cod_indic_econ
           tt_integr_acr_item_lote_impl_6.tta_val_cotac_indic_econ       = tt-import.val_cotac_indic_econ
           tt_integr_acr_item_lote_impl_6.tta_ind_tip_espec_docto        = espec_docto.ind_tip_espec_doc
           tt_integr_acr_item_lote_impl_6.tta_dat_vencto_tit_acr         = tt-import.dat_emis_docto
           tt_integr_acr_item_lote_impl_6.tta_dat_emis_docto             = tt-import.dat_emis_docto
           tt_integr_acr_item_lote_impl_6.tta_ind_tip_calc_juros         = "Simples"
           tt_integr_acr_item_lote_impl_6.tta_val_tit_acr                = tt-import.val_liq_tit_acr
           tt_integr_acr_item_lote_impl_6.tta_val_liq_tit_acr            = tt-import.val_liq_tit_acr
           tt_integr_acr_item_lote_impl_6.ttv_rec_item_lote_impl_tit_acr = RECID(tt_integr_acr_item_lote_impl_6)
           tt_integr_acr_item_lote_impl_6.tta_dat_prev_liquidac          = tt_integr_acr_item_lote_impl_6.tta_dat_vencto_tit_acr.

    ASSIGN tt_integr_acr_item_lote_impl_6.tta_cod_portador               = tt-import.cod_portador
           tt_integr_acr_item_lote_impl_6.tta_cod_cart_bcia              = tt-import.cod_cart_bcia.

    find first tit_acr
        where tit_acr.cod_estab       = tt_integr_acr_lote_impl.tta_cod_estab
        and   tit_acr.cod_espec_docto = tt_integr_acr_item_lote_impl_6.tta_cod_espec_docto
        and   tit_acr.cod_ser_docto   = tt_integr_acr_item_lote_impl_6.tta_cod_ser_docto
        and   tit_acr.cod_tit_acr     = tt_integr_acr_item_lote_impl_6.tta_cod_tit_acr
        and   tit_acr.cod_parcela     = tt_integr_acr_item_lote_impl_6.tta_cod_parcela NO-LOCK no-error.

    assign c-parcela = tt_integr_acr_item_lote_impl_6.tta_cod_parcela.

    if  c-parcela = " " then
        assign c-parcela = "01".

    if  avail tit_acr then do:
        repeat :
           find first b_tit_acr
                where  b_tit_acr.cod_estab       = tit_acr.cod_estab
                and    b_tit_acr.cod_espec_docto = tit_acr.cod_espec_docto
                and    b_tit_acr.cod_ser_docto   = tit_acr.cod_ser_docto
                and    b_tit_acr.cod_tit_acr     = tit_acr.cod_tit_acr
                and    b_tit_acr.cod_parcela     = c-parcela no-lock no-error.

           if  avail b_tit_acr then do:
               assign c-parcela = b_tit_acr.cod_parcela.
               
               run pi_increase_char_counter (input-output c-parcela).
           end.
           else
               leave.
        end.
    END.

    assign tt_integr_acr_item_lote_impl_6.tta_cod_parcela = c-parcela.

    IF tt-param.ind-tipo = 1 /* concil financeira */ THEN
        ASSIGN tt_integr_acr_item_lote_impl_6.tta_des_text_histor            = "Antecipa‡Æo gerada a partir da importa‡Æo ESACR081. Arquivo: " + tt-arquivo.nm-arquivo.
    ELSE /* devolu‡Æo */ 
        ASSIGN tt_integr_acr_item_lote_impl_6.tta_des_text_histor            = "Antecipa‡Æo gerada a partir da importa‡Æo ESACR081. Nf Cliente: " + tt-import.nf_cliente + " Arquivo: " + tt-arquivo.nm-arquivo.

    
    /***** APROPRIA€ÇO CONTABIL - RATEIO *****/
    FIND FIRST unid_negoc NO-LOCK
         WHERE unid_negoc.cdn_unid_negoc = INT(tt-import.cod_unid_negoc) NO-ERROR. /* na planilha de importa‡Æo pode vir o numero referente a unidade de negocio OU o proprio codigo */
    
    CREATE tt_integr_acr_aprop_ctbl_pend.
    ASSIGN tt_integr_acr_aprop_ctbl_pend.ttv_rec_item_lote_impl_tit_acr = RECID(tt_integr_acr_item_lote_impl_6) 
           tt_integr_acr_aprop_ctbl_pend.tta_cod_tip_fluxo_financ       = "103" /*fixo*/
           tt_integr_acr_aprop_ctbl_pend.tta_val_aprop_ctbl             = tt_integr_acr_item_lote_impl_6.tta_val_tit_acr
           tt_integr_acr_aprop_ctbl_pend.tta_cod_cta_ctbl               = tt-import.cod_cta_ctbl
           tt_integr_acr_aprop_ctbl_pend.tta_cod_unid_negoc             = IF AVAIL unid_negoc THEN unid_negoc.cod_unid_negoc ELSE tt-import.cod_unid_negoc
           tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_ccusto           = ""       
           tt_integr_acr_aprop_ctbl_pend.tta_cod_ccusto                 = "".

    IF tt-param.ind-tipo = 1 /* concil financeira */ THEN
        ASSIGN tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_cta_ctbl         = "".
    ELSE /* devolu‡Æo */ 
        ASSIGN tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_cta_ctbl         = "PADRÇO".

    /***** PEDIDO DE VENDA *****/
    IF tt-import.nr-pedido            <> 0 AND 
       tt-import.nr-pedido            <> ? THEN DO:
        CREATE tt_integr_acr_ped_vda_pend.
        ASSIGN tt_integr_acr_ped_vda_pend.ttv_rec_item_lote_impl_tit_acr    = RECID(tt_integr_acr_item_lote_impl_6)
               tt_integr_acr_ped_vda_pend.tta_cod_ped_vda                   = STRING(tt-import.nr-pedido) 
               tt_integr_acr_ped_vda_pend.tta_val_perc_particip_ped_vda     = 100.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-executa-api-imp :
    DEF VAR v_hdl_api_integr_acr AS HANDLE NO-UNDO.

    bloco_executa_api:
    DO TRANSACTION ON ERROR UNDO bloco_executa_api,  LEAVE bloco_executa_api:
    
        RELEASE tt_integr_acr_relacto_pend_cheq.
        RELEASE tt_integr_acr_cheq.
        RELEASE tt_integr_acr_aprop_ctbl_pend.
        RELEASE tt_integr_acr_item_lote_impl_6.
        RELEASE tt_integr_acr_lote_impl.

        RUN prgfin/acr/acr900zi.py PERSISTENT SET v_hdl_api_integr_acr.
        FIND FIRST tt_integr_acr_item_lote_impl_6 NO-LOCK NO-ERROR. /*tt_integr_acr_lote_impl NO-LOCK NO-ERROR.*/
        IF  AVAIL tt_integr_acr_item_lote_impl_6 THEN DO: /*tt_integr_acr_lote_impl THEN DO:*/
            EMPTY TEMP-TABLE tt_log_erros_atualiz.
    
            RUN pi_main_code_integr_acr_new_6 IN v_hdl_api_integr_acr (INPUT 1,
                                                                       INPUT matriz_trad_org_ext.cod_matriz_trad_org_ext,
                                                                       INPUT YES, /* log_atualiza_refer_acr */
                                                                       INPUT NO,  /* assume data de emissao */
                                                                       INPUT TABLE tt_integr_acr_repres_comis,
                                                                       INPUT-OUTPUT TABLE tt_integr_acr_item_lote_impl_6,
                                                                       INPUT TABLE tt_integr_acr_aprop_relacto_2).

        END.
    
        DELETE PROCEDURE v_hdl_api_integr_acr.

        IF CAN-FIND(FIRST tt_log_erros_atualiz) THEN DO:
            FOR EACH tt_log_erros_atualiz:
                CREATE tt_erro_tit_acr.
                BUFFER-COPY tt_log_erros_atualiz to tt_erro_tit_acr.                
            END.                                                    

            /*** Desfaz a Transacao caso algum titulo nao tenha sido atualizado ..................................*/
            UNDO bloco_executa_api, LEAVE bloco_executa_api.
            
        END.

    END.

    RETURN "OK".
  
END PROCEDURE.


PROCEDURE pi_retorna_sugestao_referencia :
/*****************************************************************************
** Procedure Interna.....: pi_retorna_sugestao_referencia
** Descricao.............: pi_retorna_sugestao_referencia
** Criado por............: Barth
** Criado em.............: 21/10/1998 09:14:30
** Alterado por..........: Souza
** Alterado em...........: 18/05/1999 10:12:58
*****************************************************************************/

    /************************ Parameter Definition Begin ************************/

    def Input param p_ind_tip_atualiz
        as character
        format "X(08)"
        no-undo.
    def Input param p_dat_refer
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_refer
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_des_dat                        as character       no-undo. /*local*/
    def var v_num_aux                        as integer         no-undo. /*local*/
    def var v_num_aux_2                      as integer         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_des_dat   = string(p_dat_refer,"99999999")
           p_cod_refer = substring(v_des_dat,7,2)
                       + substring(v_des_dat,3,2)
                       + substring(v_des_dat,1,2)
                       + substring(p_ind_tip_atualiz,1,1)
           v_num_aux_2 = integer(this-procedure:handle).

    do  v_num_cont = 1 to 3:
        assign v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               p_cod_refer = p_cod_refer + chr(v_num_aux).
    end.
END PROCEDURE. /* pi_retorna_sugestao_referencia */


PROCEDURE pi_verifica_refer_unica_acr :
/*****************************************************************************
** Procedure Interna.....: pi_verifica_refer_unica_acr
** Descricao.............: pi_verifica_refer_unica_acr
** Criado por............: Claudia
** Criado em.............: 14/08/1996 09:34:38
** Alterado por..........: its0105
** Alterado em...........: 23/08/2005 17:52:01
*****************************************************************************/

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_cod_refer
        as character
        format "x(10)"
        no-undo.
    def Input param p_cod_table
        as character
        format "x(8)"
        no-undo.
    def Input param p_rec_tabela
        as recid
        format ">>>>>>9"
        no-undo.
    def output param p_log_refer_uni
        as logical
        format "Sim/NÊo"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "5.02" &then
    def buffer b_cobr_especial_acr
        for cobr_especial_acr.
    &endif
    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_lote_impl_tit_acr
        for lote_impl_tit_acr.
    &endif
    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_lote_liquidac_acr
        for lote_liquidac_acr.
    &endif
    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_movto_tit_acr
        for movto_tit_acr.
    &endif
    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_operac_financ_acr
        for operac_financ_acr.
    &endif
    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_renegoc_acr
        for renegoc_acr.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_return
        as character
        format "x(40)":U
        no-undo.


    /************************** Variable Definition End *************************/

    assign p_log_refer_uni = yes.

    if  p_cod_table <> "lote_impl_tit_acr" /*l_lote_impl_tit_acr*/  then do:
        find first b_lote_impl_tit_acr no-lock
             where b_lote_impl_tit_acr.cod_estab = p_cod_estab
               and b_lote_impl_tit_acr.cod_refer = p_cod_refer
               and recid( b_lote_impl_tit_acr ) <> p_rec_tabela
             use-index ltmplttc_id no-error.
        if  avail b_lote_impl_tit_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_cod_table <> "lote_liquidac_acr" /*l_lote_liquidac_acr*/  then do:
        find first b_lote_liquidac_acr no-lock
             where b_lote_liquidac_acr.cod_estab_refer = p_cod_estab
               and b_lote_liquidac_acr.cod_refer       = p_cod_refer
               and recid( b_lote_liquidac_acr )       <> p_rec_tabela
             use-index ltlqdccr_id no-error.
        if  avail b_lote_liquidac_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_cod_table <> "Opera¯Êo financeira" /*l_operacao_financ*/  then do:
        find first b_operac_financ_acr no-lock
             where b_operac_financ_acr.cod_estab               = p_cod_estab
               and b_operac_financ_acr.cod_movto_operac_financ = p_cod_refer
               and recid( b_operac_financ_acr )               <> p_rec_tabela
             use-index oprcfnna_id no-error.
        if  avail b_operac_financ_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_cod_table = 'cobr_especial_acr' then do:
        find first b_cobr_especial_acr no-lock
             where b_cobr_especial_acr.cod_estab = p_cod_estab
               and b_cobr_especial_acr.cod_refer = p_cod_refer
               and recid( b_cobr_especial_acr ) <> p_rec_tabela
             use-index cbrspclc_id no-error.
        if  avail b_cobr_especial_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_log_refer_uni = yes then do:
        find first b_renegoc_acr no-lock
            where b_renegoc_acr.cod_estab = p_cod_estab
            and   b_renegoc_acr.cod_refer = p_cod_refer
            and   recid(b_renegoc_acr)   <> p_rec_tabela
            no-error.
        if  avail b_renegoc_acr then
            assign p_log_refer_uni = no.
        else do:
            find first b_movto_tit_acr no-lock
                 where b_movto_tit_acr.cod_estab = p_cod_estab
                   and b_movto_tit_acr.cod_refer = p_cod_refer
                   and recid(b_movto_tit_acr)   <> p_rec_tabela
                 use-index mvtttcr_refer
                 no-error.
            if  avail b_movto_tit_acr then
                assign p_log_refer_uni = no.
        end.
    end.
    
END PROCEDURE. /* pi_verifica_refer_unica_acr */

PROCEDURE pi-move-arquivo: /* mover arquivos recebidos para o diret¢rio de importados */

    DEFINE INPUT PARAMETER p-arquivo       AS CHAR    NO-UNDO.

    OS-COPY VALUE(p-arquivo) VALUE(c-arq-import).

    OS-DELETE VALUE(p-arquivo).
    
    RETURN "OK".
END PROCEDURE.

PROCEDURE pi-erro:
    DEF INPUT PARAM p-erro AS CHAR.

    CREATE tt_erro_tit_acr.
    ASSIGN tt_erro_tit_acr.tta_cod_estab     = ''
           tt_erro_tit_acr.tta_cod_refer     = ''
           tt_erro_tit_acr.tta_num_seq_refer = 1
           tt_erro_tit_acr.ttv_num_mensagem  = 1
           tt_erro_tit_acr.ttv_des_msg_erro  = p-erro.

END PROCEDURE.

PROCEDURE pi_increase_char_counter:

    def input-output param p_cod_geral as character format "x(8)" no-undo.

    def var v_log_adc   as logical no-undo.
    def var v_num_count as integer no-undo.
    def var v_num_pos   as integer no-undo.

    /* ---------------------------------- Funcionamento desta pi ---------------------------------------
    O resultado desta pi ‚ o seguinte:
    Para criar sequencias sao considerados os caracteres 0123456789abcdefghijklmnopqrstuvwxyz.
    As sequencias sao crecentes somente dentro do mesmo n£mero de digitos. Por exemplo, uma 
    sequencia variando de 00...09-0a..0z..9z-aa..zz, ser , ap¢s atingido o valor zz, 000.
    Por‚m, 000 ‚ menor que zz, fato que deve ser considerado pelo programa chamador que utilizar
    o comando find last.
    -------------------------------------------------------------------------------------------------*/

    if  p_cod_geral <> "" then do:

        valida_caracters:
        do v_num_count = length(p_cod_geral) to 1 by -1:
            if  index("0123456789abcdefghijklmnopqrstuvwxyz" , substr(p_cod_geral, v_num_count, 1)) = 0 then do:
                assign substr(p_cod_geral, v_num_count, 1) = "".
            end.
        end.

        loop:
        do v_num_count = length(p_cod_geral) to 1 by -1:
            assign v_num_pos = index("0123456789abcdefghijklmnopqrstuvwxyz" , substr(p_cod_geral, v_num_count, 1)).
            
            if  v_num_pos > 0 then do:
                if  v_num_pos >= 36 then do:
                    assign substr(p_cod_geral, v_num_count, 1) = "0"
                           v_log_adc                           = yes.
                end.
                else do:
                    assign substr(p_cod_geral, v_num_count, 1) = substr("0123456789abcdefghijklmnopqrstuvwxyz" , v_num_pos + 1, 1)
                           v_log_adc                           = no.
                    leave loop.
                end.
            end.
        end.

        if  v_log_adc = YES then do:
            assign p_cod_geral = "0" + p_cod_geral.
        end.
    end.
    else do:
        assign p_cod_geral = fill( "0", length(p_cod_geral) - 1 ) + "1" .
    end.

    assign p_cod_geral = TRIM(p_cod_geral).
END PROCEDURE.
