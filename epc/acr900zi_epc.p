/*****************************************************************************
** Programa..............: acr900zi_epc
** Versao................:  1.00.00.000
** Nome Externo..........: esp/epc/epc_acr900zi.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 25/09/2008
*****************************************************************************/
{esp/es0018.i}
{esp/acr/esacr047a.i}
{epc/acr900zi_epc.i}

/********************** Temporary Table Definition End **********************/

/************************ Parameter Definition Begin ************************/

DEF INPUT PARAM p_cod_evento
    AS CHARACTER 
    FORMAT "x(1)"
    NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE  
    FOR tt_epc_estrategico.

/************************* Parameter Definition End *************************/

DEF VAR v_cod_portador         AS CHAR NO-UNDO.
DEF VAR v_cod_admdra_cartao_cr AS CHAR NO-UNDO.
DEF VAR v_cod_cartao_cr        AS CHAR NO-UNDO.
DEF VAR v_cod_num_cart_cred    AS CHAR NO-UNDO.
DEF VAR v_cod_cart_bcia        AS CHAR NO-UNDO.
DEF VAR v_cod_aux              AS CHAR NO-UNDO.

DEF VAR v_sequencia            AS INT  NO-UNDO.
DEF VAR v_num_count            AS INT  NO-UNDO.
DEF VAR v_num_lim              AS INT  NO-UNDO.
DEF VAR v_num_digito           AS INT  NO-UNDO.
DEF VAR v_num_resto            AS INT  NO-UNDO.
DEF VAR i-digito               AS INT  NO-UNDO.

DEF VAR v_dat_vencto_tit_acr   AS DATE NO-UNDO.
DEF VAR v_data_base            AS DATE NO-UNDO.
DEF VAR v_data_venc            AS DATE NO-UNDO.

/****************************** Main Code Begin *****************************/

DISABLE TRIGGERS FOR LOAD OF lote_impl_tit_acr.
DISABLE TRIGGERS FOR LOAD OF item_lote_impl_tit_acr.

DEF BUFFER b_lote_impl_tit_acr      FOR lote_impl_tit_acr.
DEF BUFFER b_item_lote_impl_tit_acr FOR item_lote_impl_tit_acr.
DEF BUFFER b_portador               FOR emscad.portador.
DEF BUFFER b_admdra_cartao_cr       FOR admdra_cartao_cr.
DEF BUFFER b-fat-duplic             FOR fat-duplic.
DEF BUFFER b-ped-venda              FOR ped-venda.
DEF BUFFER b-int-ped-venda          FOR int-ped-venda.
DEF BUFFER b-emitente-cartao-cred   FOR emitente-cartao-cred.
DEF BUFFER b_cartao_cr              FOR cartao_cr.
DEF BUFFER b_prefix_cartao_cr       FOR prefix_cartao_cr.
DEF BUFFER b_dia_calend_glob        FOR dia_calend_glob.
DEF BUFFER b-cond-ped               FOR cond-ped.

IF p_cod_evento <> "Item Lote" 
   THEN RETURN "OK".

FIND tt_epc_estrategico NO-LOCK
    WHERE tt_epc_estrategico.ttv_cod_epc_parameters = "recid_item_lote"
      AND tt_epc_estrategico.ttv_cod_epc_event      = "Item Lote" NO-ERROR.
IF NOT AVAIL tt_epc_estrategico
   THEN RETURN "OK".

FIND b_item_lote_impl_tit_acr EXCLUSIVE-LOCK
    WHERE ROWID(b_item_lote_impl_tit_acr) = TO-ROWID(tt_epc_estrategico.ttv_cod_epc_msg) NO-ERROR.

FIND b_lote_impl_tit_acr OF b_item_lote_impl_tit_acr EXCLUSIVE-LOCK NO-ERROR.
IF b_lote_impl_tit_acr.ind_orig_tit_acr <> "FATEMS20"
   THEN RETURN "OK".

IF b_item_lote_impl_tit_acr.cod_tit_acr BEGINS "BWW-" THEN DO:
    ASSIGN b_item_lote_impl_tit_acr.cod_portador  = "9909"
           b_item_lote_impl_tit_acr.cod_cart_bcia = "89"
           b_lote_impl_tit_acr.ind_tip_cobr_acr   = "Normal".

    RETURN "OK".
END.

FIND b-fat-duplic NO-LOCK
    WHERE b-fat-duplic.cod-estabel = b_item_lote_impl_tit_acr.cod_estab
      AND b-fat-duplic.serie       = b_item_lote_impl_tit_acr.cod_ser
      AND b-fat-duplic.nr-fatura   = b_item_lote_impl_tit_acr.cod_tit_acr
      AND b-fat-duplic.parcela     = b_item_lote_impl_tit_acr.cod_parcela
      AND b-fat-duplic.cod-esp     = b_item_lote_impl_tit_acr.cod_espec NO-ERROR.
IF NOT AVAIL b-fat-duplic 
   THEN RETURN "OK".

FIND FIRST nota-fiscal
    WHERE nota-fiscal.cod-estabel = b-fat-duplic.cod-estabel
      AND nota-fiscal.serie       = b-fat-duplic.serie
      AND nota-fiscal.nr-fatura   = b-fat-duplic.nr-fatura NO-LOCK NO-ERROR.

IF NOT AVAILABLE nota-fiscal THEN
    RETURN "OK":U.

// REGRA PARA O MERCADO FULL - N«O POSSUI ped-venda e cond-ped
IF AVAIL nota-fiscal AND nota-fiscal.no-ab-reppri = "MERC LIVRE" THEN DO:

    FIND FIRST int-pedido-param-pagto NO-LOCK
         WHERE int-pedido-param-pagto.marketplace = "MLP"
           AND int-pedido-param-pagto.loja        = "1"
           AND int-pedido-param-pagto.forma-pagto = "0" NO-ERROR.
    IF AVAIL int-pedido-param-pagto THEN DO:
        IF int-pedido-param-pagto.cod-adm-cartao = "MKT" THEN DO:
            ASSIGN b_item_lote_impl_tit_acr.cod_portador  = string(int-pedido-param-pagto.portador)
                   b_item_lote_impl_tit_acr.cod_cart_bcia = int-pedido-param-pagto.cod-carteira
                   b_lote_impl_tit_acr.ind_tip_cobr_acr   = "Normal".
        END.
        ASSIGN v_cod_portador         = string(int-pedido-param-pagto.portador)
               v_cod_admdra_cartao_cr = int-pedido-param-pagto.cod-adm-cartao
               v_cod_cartao_cr        = int-pedido-param-pagto.cod-bandeira
               v_cod_cart_bcia        = int-pedido-param-pagto.cod-carteira.  
    END.        
END.

FIND b-ped-venda NO-LOCK
    WHERE b-ped-venda.nr-pedido = b-fat-duplic.nr-pedido NO-ERROR.
IF NOT AVAIL b-ped-venda
   THEN RETURN "OK".

/* Se a Condiá∆o de Pagamento for da SupplierCard, altera o Portador e Carteira */
FIND FIRST int-cond-pagto NO-LOCK
    WHERE  int-cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag NO-ERROR.
IF  AVAIL  int-cond-pagto AND
    SUBSTRING(int-cond-pagto.char-1,4,1) = "S" THEN DO:
    ASSIGN b_item_lote_impl_tit_acr.cod_portador  = '9915'
           b_item_lote_impl_tit_acr.cod_cart_bcia = '90'.

    RETURN "OK".
END.

FIND b-int-ped-venda NO-LOCK
    WHERE b-int-ped-venda.cod-estabel = b-ped-venda.cod-estabel
      AND b-int-ped-venda.nr-pedido   = b-ped-venda.nr-pedido NO-ERROR.
IF NOT AVAIL b-int-ped-venda 
   THEN RETURN "OK".

FIND LAST param-b2c NO-LOCK NO-ERROR.
IF NOT AVAIL param-b2c
   THEN RETURN "OK".

ASSIGN v_cod_portador  = ""
       v_cod_cart_bcia = ""
       v_data_venc     = ?.

/* ajuste vencimento das parcelas para pedidos faturados em meses posteriores */
FIND FIRST b-cond-ped OF b-ped-venda NO-LOCK
     WHERE b-cond-ped.observacoes BEGINS "Marketplace" 
     AND   b-cond-ped.data-pagto < nota-fiscal.dt-emis-nota NO-ERROR.

IF  AVAIL b-cond-ped THEN DO:
    ASSIGN v_data_venc = nota-fiscal.dt-emis-nota.

    FOR EACH b-cond-ped OF b-ped-venda EXCLUSIVE-LOCK
        BREAK BY (SUBSTRING(b-cond-ped.observacoes,1,4)):

        IF  b-cond-ped.observacoes BEGINS "Marketplace"
        AND TRIM(ENTRY(2,ENTRY(2,b-cond-ped.observacoes,CHR(10)),":")) <> "BOLETO" THEN DO:
            ASSIGN b-cond-ped.data-pagto = v_data_venc.

            ASSIGN v_data_venc = v_data_venc + 30.
        END.
    END.
END.
/* ajuste vencimento das parcelas para pedidos faturados em meses posteriores */

FIND FIRST cond-ped NO-LOCK
     WHERE cond-ped.nr-pedido    = b-ped-venda.nr-pedido
       AND cond-ped.nr-sequencia = int(b_item_lote_impl_tit_acr.cod_parcela) * 10 NO-ERROR.

IF b-ped-venda.cod-cond-pag = param-b2c.cond-pagto-bol /* Boleto Bradesco - B2C */
OR (AVAIL cond-ped AND b-ped-venda.cod-cond-pag = 0 AND trim(substring(cond-ped.observacoes,1,6)) = 'BOLETO')
   THEN ASSIGN v_cod_portador  = '237'
               v_cod_cart_bcia = '71'.

IF AVAIL cond-ped 
     AND cond-ped.observacoes BEGINS "Marketplace"
     AND b-ped-venda.cod-cond-pag = 0 
     AND TRIM(ENTRY(2,ENTRY(2,cond-ped.observacoes,CHR(10)),":")) = "BOLETO" /* Forma pagto:BOLETO */
   THEN ASSIGN v_cod_portador  = '237'
               v_cod_cart_bcia = '71'.

IF b-ped-venda.cod-cond-pag = param-b2c.cond-pagto-bol-par /* Boleto Bradesco - PAR - CEF */
   THEN ASSIGN v_cod_portador  = '237'
               v_cod_cart_bcia = '72'.
               
/* Venda via Boleto B2C ou ?CEF? */
IF v_cod_cart_bcia = "71"
OR v_cod_cart_bcia = "72" THEN DO:

     ASSIGN b_item_lote_impl_tit_acr.cod_portador       = v_cod_portador
            b_item_lote_impl_tit_acr.cod_cart_bcia      = v_cod_cart_bcia
         /* b_item_lote_impl_tit_acr.log_liquidac_autom = YES - Retirado pois usuario do faturamento n∆o tem permiss∆o para liquidar. Gera erro na integraá∆o */.

     IF v_cod_cart_bcia = "71" 
        THEN ASSIGN b_item_lote_impl_tit_acr.cod_tit_acr_bco = string(97000000000 + b-int-ped-venda.pedidocodigo). /* banco n∆o retorna mais 97 nas duas primeiras posiá‰es */
        ELSE ASSIGN b_item_lote_impl_tit_acr.cod_tit_acr_bco = string(00000000000 + b-int-ped-venda.pedidocodigo).
     
     ASSIGN b_item_lote_impl_tit_acr.cod_tit_acr_bco = "00" + SUBSTR(b_item_lote_impl_tit_acr.cod_tit_acr_bco,3,9). /* banco n∆o retorna mais 97 nas duas primeiras posiá‰es */

     FIND FIRST int-ped-venda NO-LOCK
          WHERE int-ped-venda.nr-pedido = b-ped-venda.nr-pedido  NO-ERROR.
     
     IF AVAIL int-ped-venda
     AND int-ped-venda.tid <> "" THEN
         ASSIGN b_item_lote_impl_tit_acr.cod_tit_acr_bco = int-ped-venda.tid.

     /* Gravar estabelecimento no n£mero banc†rio pois o mesmo boleto paga t°tulo de estabelecimentos diferentes,
        n∆o sendo poss°vel ter dois t°tulos no contas a receber, para a mesma empresa, portador, 
        com o mesmo n£mero banc†rio */
     ASSIGN b_item_lote_impl_tit_acr.cod_tit_acr_bco = b_item_lote_impl_tit_acr.cod_tit_acr_bco + b_item_lote_impl_tit_acr.cod_estab.

     IF  CAN-FIND(FIRST tit_acr no-lock
          where tit_acr.cod_portador    = b_item_lote_impl_tit_acr.cod_portador
          and   tit_acr.cod_tit_acr_bco = b_item_lote_impl_tit_acr.cod_tit_acr_bco 
          and   tit_acr.cod_empresa     = b_item_lote_impl_tit_acr.cod_empresa) THEN DO:

         find last tit_acr no-lock
              where tit_acr.cod_portador         = b_item_lote_impl_tit_acr.cod_portador
              and   tit_acr.cod_tit_acr_bco BEGINS b_item_lote_impl_tit_acr.cod_tit_acr_bco 
              and   tit_acr.cod_empresa          = b_item_lote_impl_tit_acr.cod_empresa no-error.
    
         if  avail tit_acr then do:
             ASSIGN v_sequencia = 0.
    
             IF  tit_acr.cod_tit_acr_bco MATCHES("*/*") THEN
                 ASSIGN v_sequencia = int(ENTRY(2,tit_acr.cod_tit_acr_bco,"/")) + 1.
    
             IF  v_sequencia = 0 THEN
                 ASSIGN b_item_lote_impl_tit_acr.cod_tit_acr_bco = b_item_lote_impl_tit_acr.cod_tit_acr_bco + "/2".
             ELSE
                 ASSIGN b_item_lote_impl_tit_acr.cod_tit_acr_bco = STRING(ENTRY(1,b_item_lote_impl_tit_acr.cod_tit_acr_bco,"/")) + "/" + string(v_sequencia).
         END.
     END.

     RETURN "OK".

END.

/* Venda via cart∆o de crÇdito */
/*IF b-ped-venda.cod-cond-pag <> param-b2c.cond-pagto-cred
   THEN RETURN "OK".*/ /*Por enquanto n∆o pode ser validado por causa do B2B, que n∆o est† utilizando este parÉmetro*/

FIND b-emitente-cartao-cred NO-LOCK
    WHERE b-emitente-cartao-cred.cod-emitente = b-ped-venda.cod-emitente
      AND b-emitente-cartao-cred.sequencia    = b-int-ped-venda.seq-cartao-cred NO-ERROR.
 
/* Tratamento antigo de cartao de credito - Retirado conforme chamado C2103-1245

IF  b-ped-venda.cod-cond-pag       = 0  
AND (b-int-ped-venda.pedidocodigo <> 0 OR b-ped-venda.origem = 12) 
and b-int-ped-venda.CarTID = "" THEN DO:
     CREATE tt_epc_estrategico.
     ASSIGN tt_epc_estrategico.ttv_cod_epc_event      = "Item Lote"
            tt_epc_estrategico.ttv_cod_epc_parameters = "Retorno EPC"
            tt_epc_estrategico.ttv_cod_epc_msg        = "EPC acr900zi_epc - C¢digo de Autorizaá∆o n∆o informado !".
     RETURN "OK".
END.
*/

/*
b-emitente-cartao-cred.bandeira    = 01 - American Express
                                     06 - Diners
                                     10 - Mastercard
                                     11 - Visa
                                     07 - Hipercard

b-emitente-cartao-cred.tipo-cartao = 01 - B2B
                                     02 - B2C

v_cod_portador = 9910 - Visanet   B2C
                 9911 - Redcard   B2C
                 9912 - Redcard   B2B
                 9913 - Amex      B2C
                 9914 - Hipercard B2C

v_cod_cart_bcia = 70 - Administradora 
                  71 - Boleto Bradesco
                  72 - CEF

v_cod_admdra_cartao_cr = AMEX  - American Exprex - Bandeira AEX
                         REDCA - Redcard         - Bandeira DIN / MCI
                         VISA  - Visanet         - Bandeira VIS
                         HIPER - Hipercard       - Bandeira HIP
*/

ASSIGN v_cod_portador         = ""
       v_cod_admdra_cartao_cr = ""
       v_cod_cart_bcia        = "".

IF AVAIL b-emitente-cartao-cred THEN DO:

    IF  b-emitente-cartao-cred.tipo-cartao = 02 /*B2C*/
    AND b-emitente-cartao-cred.bandeira    = 07 /*Hipercard*/
        THEN ASSIGN v_cod_portador         = '9914'  /*Redcard B2B*/
                    v_cod_admdra_cartao_cr = 'HIPER' /*Administradora*/
                    v_cod_cartao_cr        = 'HIP'   /*Bandeira*/
                    v_cod_cart_bcia        = '70'. 
    
    IF  b-emitente-cartao-cred.tipo-cartao = 02 /*B2C*/
    AND b-emitente-cartao-cred.bandeira    = 11 /*Visa*/
        THEN ASSIGN v_cod_portador         = '9910' /*Visanet B2C*/
                    v_cod_admdra_cartao_cr = 'VISA' /*Administradora*/
                    v_cod_cartao_cr        = 'VIS'  /*Bandeira*/
                    v_cod_cart_bcia        = '70'.    
    
    IF  b-emitente-cartao-cred.tipo-cartao = 02 /*B2C*/
    AND b-emitente-cartao-cred.bandeira    = 10 /*Mastercard*/
        THEN ASSIGN v_cod_portador         = '9911'  /*Redcard B2C*/
                    v_cod_admdra_cartao_cr = 'REDCA' /*Administradora*/
                    v_cod_cartao_cr        = 'MCI'   /*Bandeira*/
                    v_cod_cart_bcia        = '70'.    
    
    IF  b-emitente-cartao-cred.tipo-cartao = 02 /*B2C*/
    AND b-emitente-cartao-cred.bandeira    = 06 /*Diners*/
        THEN ASSIGN v_cod_portador         = '9911'  /*Redcard B2C*/
                    v_cod_admdra_cartao_cr = 'REDCA' /*Administradora*/
                    v_cod_cartao_cr        = 'DIN'   /*Bandeira*/
                    v_cod_cart_bcia        = '70'.    
    
    IF  b-emitente-cartao-cred.tipo-cartao = 01 /*B2B*/
    AND b-emitente-cartao-cred.bandeira    = 10 /*Mastercard*/
        THEN ASSIGN v_cod_portador         = '9912'  /*Redcard B2B*/
                    v_cod_admdra_cartao_cr = 'REDCA' /*Administradora*/
                    v_cod_cartao_cr        = 'MCI'   /*Bandeira*/
                    v_cod_cart_bcia        = '70'.    
    
    IF  b-emitente-cartao-cred.tipo-cartao = 02 /*B2C*/
    AND b-emitente-cartao-cred.bandeira    = 01 /*American Express*/
        THEN ASSIGN v_cod_portador         = '9913' /*American Express B2C*/
                    v_cod_admdra_cartao_cr = 'AMEX' /*Administradora*/
                    v_cod_cartao_cr        = 'AEX'  /*Bandeira*/
                    v_cod_cart_bcia        = '70'.    
END.

IF  AVAIL cond-ped AND trim(substring(cond-ped.observacoes,1,4)) <> "" AND NOT cond-ped.observacoes BEGINS "Marketplace" THEN DO:

    RUN esp/es0018p.p (INPUT "Solar":U,
                       INPUT 3,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto 
         WHERE entry(1,tt-prog-ponto.conteudo,";") BEGINS trim(substring(cond-ped.observacoes,1,4)) NO-ERROR.

    IF AVAIL tt-prog-ponto THEN DO:

        IF entry(3,tt-prog-ponto.conteudo,";") = "MKT" THEN DO:
            ASSIGN b_item_lote_impl_tit_acr.cod_portador  = entry(2,tt-prog-ponto.conteudo,";")
                   b_item_lote_impl_tit_acr.cod_cart_bcia = entry(5,tt-prog-ponto.conteudo,";")
                   b_lote_impl_tit_acr.ind_tip_cobr_acr   = "Normal"
                .

            RETURN "OK".
        END.

        ASSIGN v_cod_portador         = entry(2,tt-prog-ponto.conteudo,";") /*Redcard B2B*/
               v_cod_admdra_cartao_cr = entry(3,tt-prog-ponto.conteudo,";") /*Administradora*/
               v_cod_cartao_cr        = entry(4,tt-prog-ponto.conteudo,";") /*Bandeira*/
               v_cod_cart_bcia        = entry(5,tt-prog-ponto.conteudo,";").   

    END.
END.

IF  AVAIL cond-ped AND cond-ped.observacoes BEGINS "Marketplace" THEN DO:

    FIND FIRST int-pedido-param-pagto NO-LOCK
         WHERE int-pedido-param-pagto.marketplace = TRIM(ENTRY(2,ENTRY(1,cond-ped.observacoes,CHR(10)),":"))
           AND int-pedido-param-pagto.loja        = "1"
           AND int-pedido-param-pagto.forma-pagto = TRIM(ENTRY(2,ENTRY(2,cond-ped.observacoes,CHR(10)),":")) NO-ERROR.
    IF AVAIL int-pedido-param-pagto THEN DO:

        IF int-pedido-param-pagto.cod-adm-cartao = "MKT" THEN DO:
            ASSIGN b_item_lote_impl_tit_acr.cod_portador  = string(int-pedido-param-pagto.portador)
                   b_item_lote_impl_tit_acr.cod_cart_bcia = int-pedido-param-pagto.cod-carteira
                   b_lote_impl_tit_acr.ind_tip_cobr_acr   = "Normal".

            IF  cond-ped.observacoes BEGINS "Marketplace" 
            AND ENTRY(2,ENTRY(1,cond-ped.observacoes,CHR(10)),":") = "BWW"
            AND DEC(ENTRY(2,ENTRY(6,cond-ped.observacoes,CHR(10)),":")) <> 0
            AND NOT b_item_lote_impl_tit_acr.cod_tit_acr BEGINS "BWW-" THEN DO:
                RUN pi-gera-nota-debito.
            END.

            IF CAN-FIND(FIRST int-pedido-comissao NO-LOCK
                        WHERE int-pedido-comissao.nr-pedcli = nota-fiscal.nr-pedcli) THEN DO:
                IF SUBSTRING(int-pedido-param-pagto.char-1,1,1) = "1" THEN
                    RUN pi-gera-tituto-comissao.
            END.    

            //RETURN "OK".
        END.

        ASSIGN v_cod_portador         = string(int-pedido-param-pagto.portador)
               v_cod_admdra_cartao_cr = int-pedido-param-pagto.cod-adm-cartao
               v_cod_cartao_cr        = int-pedido-param-pagto.cod-bandeira
               v_cod_cart_bcia        = int-pedido-param-pagto.cod-carteira.  
    END.        
END.

FIND b_portador NO-LOCK
    WHERE b_portador.cod_portador = v_cod_portador NO-ERROR.
IF NOT AVAIL b_portador
OR b_portador.ind_tip_portad <> "Administradora"
   THEN RETURN "OK".

FIND b_admdra_cartao_cr NO-LOCK 
    WHERE b_admdra_cartao_cr.cod_admdra_cartao_cr = v_cod_admdra_cartao_cr NO-ERROR.
IF NOT AVAIL b_admdra_cartao_cr 
   THEN RETURN "OK".

FIND b_cartao_cr NO-LOCK
    WHERE b_cartao_cr.cod_admdra_cartao_cr = b_admdra_cartao_cr.cod_admdra_cartao_cr
      AND b_cartao_cr.cod_cartao_cr        = v_cod_cartao_cr NO-ERROR.
IF NOT AVAIL b_cartao_cr 
   THEN RETURN "OK".

FIND FIRST b_prefix_cartao_cr NO-LOCK 
     WHERE b_prefix_cartao_cr.cod_admdra_cartao_cr = b_admdra_cartao_cr.cod_admdra_cartao_cr
       AND b_prefix_cartao_cr.cod_cartao_cr        = b_cartao_cr.cod_cartao_cr NO-ERROR.
IF NOT AVAIL b_prefix_cartao_cr 
   THEN RETURN "OK".

ASSIGN v_cod_num_cart_cred = STRING(b_prefix_cartao_cr.num_prefix_cartao_cr, "9999") + FILL("0", b_cartao_cr.num_digito_cartao_cr - 4).

/* --- Gera d°gito Cart∆o de CrÇdito com o prefixo do cart∆o mais zeros e o digito verificador calculado
       para que n∆o tenhamos o n£mero do cart∆o real no EMS5 ---*/
ASSIGN v_cod_aux = "2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2".

digito:
DO v_num_count = LENGTH(v_cod_num_cart_cred) - 1 TO 1 BY -1:
   ASSIGN v_num_lim    = INT(SUBSTR(v_cod_num_cart_cred,v_num_count,1)) * INT(ENTRY(LENGTH(v_cod_num_cart_cred) - v_num_count,v_cod_aux))
          v_num_digito = v_num_digito + INT(SUBSTR(STRING(v_num_lim,"99"),1,1)) + INT(SUBSTR(STRING(v_num_lim,"99"),2,1)).
END.

ASSIGN v_num_resto = v_num_digito MODULO 10.

IF v_num_resto = 0 
   THEN ASSIGN v_num_digito = 0.
   ELSE ASSIGN v_num_digito = 10 - v_num_resto.

ASSIGN SUBSTR(v_cod_num_cart_cred,LENGTH(v_cod_num_cart_cred),1) = STRING(v_num_digito, "9").

ASSIGN v_data_base = b-ped-venda.dt-emissao.

/* C†lculo Data Vencimento */
IF b_portador.log_calc_dat_vencto_cobr = YES
THEN DO:

     IF AVAIL cond-ped
     AND cond-ped.observacoes BEGINS "Marketplace" 
     AND (ENTRY(2,ENTRY(1,cond-ped.observacoes,CHR(10)),":") = "VTEX"
     OR   ENTRY(2,ENTRY(1,cond-ped.observacoes,CHR(10)),":") = "LMS") THEN
         ASSIGN b_item_lote_impl_tit_acr.dat_vencto_tit_acr = cond-ped.data-pagto.
     ELSE DO:
         IF AVAIL cond-ped AND (ENTRY(2,ENTRY(1,cond-ped.observacoes,CHR(10)),":")) = "ASSIST"  THEN
             ASSIGN b_item_lote_impl_tit_acr.dat_vencto_tit_acr = cond-ped.data-pagto.
         ELSE 
            ASSIGN b_item_lote_impl_tit_acr.dat_vencto_tit_acr = v_data_base + b_admdra_cartao_cr.qti_dias_calc_vencto_tit.
     END.
     /*futuramente a data da aprovaá∆o sera gravada em tabela especifica, e esta data ser† somada a qde de dias para o repasse da adm.*/
    
     /* Considera somente dias £teis. prorrogando a data de vencimento/recebimento */
     block_prorroga:
     REPEAT:
         FIND b_dia_calend_glob NO-LOCK 
             WHERE b_dia_calend_glob.cod_calend = "FISCAL"
               AND b_dia_calend_glob.dat_calend = b_item_lote_impl_tit_acr.dat_vencto_tit_acr NO-ERROR.
         IF AVAIL b_dia_calend_glob 
         THEN DO:
              IF b_dia_calend_glob.log_dia_util = YES 
                 THEN LEAVE block_prorroga.
                 ELSE ASSIGN b_item_lote_impl_tit_acr.dat_vencto_tit_acr = b_item_lote_impl_tit_acr.dat_vencto_tit_acr + 1.
         END.
         ELSE LEAVE block_prorroga.
     END.

     ASSIGN b_item_lote_impl_tit_acr.dat_prev_liquidac = b_item_lote_impl_tit_acr.dat_vencto_tit_acr.

END.

ASSIGN /* ** 505
       ENTRY(3, b_item_lote_impl_tit_acr.cod_livre_1, CHR(24))    = IF LENGTH(b-int-ped-venda.CarTID) > 9 THEN SUBSTRING(b-int-ped-venda.CarTID, LENGTH(b-int-ped-venda.CarTID) - 8, 9) ELSE b-int-ped-venda.CarTID /*cod_comprov_vda*/
       ENTRY(4, b_item_lote_impl_tit_acr.cod_livre_1, CHR(24))    = STRING(b-int-ped-venda.nr-parcelas)
       ENTRY(5, b_item_lote_impl_tit_acr.cod_livre_1, CHR(24))    = "" /*cod_autoriz_bco_emissor*/
       ENTRY(7, b_item_lote_impl_tit_acr.cod_livre_1, CHR(24))    = "" /*cod_lote_origin*/
       ***/
                b_item_lote_impl_tit_acr.cod_comprov_vda          = IF LENGTH(b-int-ped-venda.CarTID) > 9 THEN SUBSTRING(b-int-ped-venda.CarTID, LENGTH(b-int-ped-venda.CarTID) - 8, 9) ELSE b-int-ped-venda.CarTID
                b_item_lote_impl_tit_acr.num_parc_cartcred        = b-int-ped-venda.nr-parcelas
                b_item_lote_impl_tit_acr.cod_autoriz_bco_emissor  = ""
                b_item_lote_impl_tit_acr.cod_lote_origin          = ""
                b_item_lote_impl_tit_acr.cod_autoriz_cartao_cr    = ""
                b_item_lote_impl_tit_acr.cod_cartcred             = v_cod_num_cart_cred 
                b_item_lote_impl_tit_acr.cod_contrat_vda          = ""
                b_item_lote_impl_tit_acr.cod_mes_ano_valid_cartao = IF AVAIL b-emitente-cartao-cred THEN STRING(b-emitente-cartao-cred.mes-validade) + STRING(b-emitente-cartao-cred.ano-validade) ELSE ""
                b_item_lote_impl_tit_acr.cod_portador             = v_cod_portador
                b_item_lote_impl_tit_acr.cod_cart_bcia            = v_cod_cart_bcia
                b_item_lote_impl_tit_acr.dat_compra_cartao_cr     = v_data_base
                b_item_lote_impl_tit_acr.cod_admdra_cartao_cr     = v_cod_admdra_cartao_cr
                b_lote_impl_tit_acr.ind_tip_cobr_acr              = "Especial".

RETURN "OK".

/******************************* Main Code End ******************************/

/*--- Procedures Internas ---*/
PROCEDURE pi-gera-nota-debito:
    DEFINE VARIABLE c-cod-refer       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE de-tot-val-titulo AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_val_rateio      AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE h-acr900zi        AS HANDLE      NO-UNDO.
    DEFINE VARIABLE l-erro            AS LOGICAL     NO-UNDO.

    FIND FIRST tit_acr NO-LOCK
        WHERE  tit_acr.cod_estab       = "104"
        AND    tit_acr.cod_espec_docto = "MK"
        AND    tit_acr.cod_ser_docto   = "4"
        AND    tit_acr.cod_tit_acr     = "BWW-" + STRING(nota-fiscal.nr-nota-fis)
        AND    tit_acr.cod_parcela     = "01" NO-ERROR.
    IF AVAIL tit_acr THEN NEXT.
    
    RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  "101",
                                              INPUT  ?,
                                              OUTPUT c-cod-refer).

    CREATE tt_integr_acr_lote_impl. 
    ASSIGN tt_integr_acr_lote_impl.tta_cod_empresa          = "1"
           tt_integr_acr_lote_impl.tta_cod_estab            = "104"
           tt_integr_acr_lote_impl.tta_cod_refer            = c-cod-refer
           tt_integr_acr_lote_impl.tta_dat_transacao        = b_item_lote_impl_tit_acr.dat_emis_docto
           tt_integr_acr_lote_impl.tta_ind_tip_cobr_acr     = "Normal"
           tt_integr_acr_lote_impl.tta_ind_orig_tit_acr     = "FATEMS20"
           tt_integr_acr_lote_impl.ttv_cod_empresa_ext      = ""
           tt_integr_acr_lote_impl.tta_cod_estab_ext        = ""
           tt_integr_acr_lote_impl.tta_cod_finalid_econ_ext = "".

    ASSIGN de-tot-val-titulo = DEC(ENTRY(2,ENTRY(6,cond-ped.observacoes,CHR(10)),":")).

    CREATE tt_integr_acr_item_lote_impl_8.
    ASSIGN tt_integr_acr_item_lote_impl_8.ttv_rec_lote_impl_tit_acr      = RECID(tt_integr_acr_lote_impl)
           tt_integr_acr_item_lote_impl_8.tta_num_seq_refer              = 1
           tt_integr_acr_item_lote_impl_8.tta_ind_tip_espec_docto        = "Normal":U
           tt_integr_acr_item_lote_impl_8.tta_cod_portador               = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_cart_bcia              = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_espec_docto            = "MK"
           tt_integr_acr_item_lote_impl_8.tta_cod_parcela                = "01"
           tt_integr_acr_item_lote_impl_8.tta_cod_tit_acr                = "BWW-" + STRING(nota-fiscal.nr-nota-fis)
           tt_integr_acr_item_lote_impl_8.tta_cdn_cliente                = 116666
           tt_integr_acr_item_lote_impl_8.tta_cod_ser_docto              = "4"          
           tt_integr_acr_item_lote_impl_8.tta_cod_finalid_econ_ext       = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_finalid_econ           = "corrente"
           tt_integr_acr_item_lote_impl_8.tta_cod_finalid_econ_ext       = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_indic_econ             = "real"
           tt_integr_acr_item_lote_impl_8.tta_cod_portad_ext             = ""
           tt_integr_acr_item_lote_impl_8.tta_cdn_repres                 = 2090
           tt_integr_acr_item_lote_impl_8.tta_dat_vencto_tit_acr         = b_item_lote_impl_tit_acr.dat_vencto_tit_acr
           tt_integr_acr_item_lote_impl_8.tta_dat_prev_liquidac          = ?
           tt_integr_acr_item_lote_impl_8.tta_dat_desconto               = ?
           tt_integr_acr_item_lote_impl_8.tta_dat_emis_docto             = b_item_lote_impl_tit_acr.dat_emis_docto
           tt_integr_acr_item_lote_impl_8.tta_cod_cond_cobr              = ""
           tt_integr_acr_item_lote_impl_8.tta_val_tit_acr                = de-tot-val-titulo
           tt_integr_acr_item_lote_impl_8.tta_val_desconto               = 0
           tt_integr_acr_item_lote_impl_8.tta_val_perc_desc              = 0
           tt_integr_acr_item_lote_impl_8.tta_val_perc_juros_dia_atraso  = 0
           tt_integr_acr_item_lote_impl_8.tta_val_perc_multa_atraso      = 0
           tt_integr_acr_item_lote_impl_8.tta_des_text_histor            = ENTRY(2,ENTRY(5,cond-ped.observacoes,CHR(10)),":")
           tt_integr_acr_item_lote_impl_8.tta_cod_instruc_bcia_1_movto   = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_instruc_bcia_2_movto   = ""
           tt_integr_acr_item_lote_impl_8.tta_qtd_dias_carenc_juros_acr  = ? 
           tt_integr_acr_item_lote_impl_8.tta_val_liq_tit_acr            = de-tot-val-titulo
           tt_integr_acr_item_lote_impl_8.tta_cod_agenc_cobr_bcia        = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_tit_acr_bco            = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_cartcred               = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_mes_ano_valid_cartao   = ""
           tt_integr_acr_item_lote_impl_8.tta_dat_compra_cartao_cr       = ? 
           tt_integr_acr_item_lote_impl_8.ttv_cod_comprov_vda            = ""
           tt_integr_acr_item_lote_impl_8.ttv_cod_autoriz_bco_emissor    = ""
           tt_integr_acr_item_lote_impl_8.ttv_cod_lote_origin            = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_conces_telef           = ""
           tt_integr_acr_item_lote_impl_8.tta_num_ddd_localid_conces     = 0
           tt_integr_acr_item_lote_impl_8.tta_num_prefix_localid_conces  = 0
           tt_integr_acr_item_lote_impl_8.tta_num_milhar_localid_conces  = 0
           tt_integr_acr_item_lote_impl_8.tta_cod_banco                  = "" 
           tt_integr_acr_item_lote_impl_8.tta_cod_agenc_bcia             = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_cta_corren_bco         = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_digito_cta_corren      = ""
           tt_integr_acr_item_lote_impl_8.tta_val_cotac_indic_econ       = 1
           tt_integr_acr_item_lote_impl_8.tta_ind_tip_calc_juros         = "Simples"
           tt_integr_acr_item_lote_impl_8.ttv_rec_item_lote_impl_tit_acr = RECID(tt_integr_acr_item_lote_impl_8)
           tt_integr_acr_item_lote_impl_8.tta_cod_motiv_movto_tit_acr    = ""
           tt_integr_acr_item_lote_impl_8.tta_log_liquidac_autom         = NO
           tt_integr_acr_item_lote_impl_8.ttv_num_parc_cartcred          = 0
           tt_integr_acr_item_lote_impl_8.tta_cod_proces_export          = "".
    
    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "acr900zi":U,
                       INPUT 2,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR EACH it-nota-fisc OF nota-fiscal:
        ASSIGN v_val_rateio = (de-tot-val-titulo * (100 * it-nota-fisc.vl-tot-item) / nota-fiscal.vl-tot-nota) / 100.
    
        FIND FIRST tt-prog-ponto
             WHERE entry(1,tt-prog-ponto.conteudo,";") = it-nota-fisc.cod-unid-negoc NO-LOCK NO-ERROR.
    
        IF  AVAIL tt-prog-ponto THEN DO:
            CREATE tt_integr_acr_aprop_ctbl_pend.
            ASSIGN tt_integr_acr_aprop_ctbl_pend.ttv_rec_item_lote_impl_tit_acr = RECID(tt_integr_acr_item_lote_impl_8)
                   tt_integr_acr_aprop_ctbl_pend.tta_cod_cta_ctbl               = "41110005"
                   tt_integr_acr_aprop_ctbl_pend.tta_cod_tip_fluxo_financ       = "103"
                   tt_integr_acr_aprop_ctbl_pend.tta_val_aprop_ctbl             = v_val_rateio
                   tt_integr_acr_aprop_ctbl_pend.tta_cod_unid_negoc             = it-nota-fisc.cod-unid-negoc
                   tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_cta_ctbl         = "padrao"
                   tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_ccusto           = "padrao"
                   tt_integr_acr_aprop_ctbl_pend.tta_cod_ccusto                 = entry(2,tt-prog-ponto.conteudo,";").
        END.
    END.

    RELEASE tt_integr_acr_aprop_ctbl_pend.
    RELEASE tt_integr_acr_item_lote_impl_8.
    FIND FIRST tt_integr_acr_lote_impl NO-LOCK.

    IF  NOT VALID-HANDLE(h-acr900zi) THEN
        RUN prgfin/acr/acr900zi.py persistent set h-acr900zi.

    IF  VALID-HANDLE(h-acr900zi) THEN
        RUN pi_main_code_integr_acr_new_9 IN h-acr900zi (INPUT 11,
                                                         INPUT "",  /*Matriz Trad Org Ext*/
                                                         INPUT YES, /*Log Atualiz Refer*/
                                                         INPUT NO,  /*Assume Data Emiss*/
                                                         INPUT TABLE tt_integr_acr_repres_comis_2,
                                                         INPUT-OUTPUT TABLE tt_integr_acr_item_lote_impl_8,
                                                         INPUT TABLE tt_integr_acr_aprop_relacto_2).

    IF  VALID-HANDLE(h-acr900zi) THEN
        DELETE PROCEDURE h-acr900zi.

    FOR EACH tt_log_erros_atualiz:
        CREATE tt_epc_estrategico.
        ASSIGN tt_epc_estrategico.ttv_cod_epc_event      = "Item Lote"
               tt_epc_estrategico.ttv_cod_epc_parameters = "Retorno EPC"
               tt_epc_estrategico.ttv_cod_epc_msg        = "EPC acr900zi_epc - " + tt_log_erros_atualiz.ttv_des_msg_erro + " - " + tt_log_erros_atualiz.ttv_des_msg_ajuda.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-gera-tituto-comissao:

    DEFINE VARIABLE v_log_refer_uni AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE v_cod_parcela   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_data          AS DATE        NO-UNDO INITIAL TODAY.
    DEFINE VARIABLE v_cod_refer     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_hdl_aux       AS HANDLE      NO-UNDO.

    ASSIGN v_log_refer_uni          = NO
           v_cod_parcela            = 0.
        
    bk-comissao:
    DO TRANSACTION ON STOP UNDO bk-comissao, RETURN "NOK":U:

        IF NOT AVAIL NOTA-FISCAL THEN NEXT.
        
        FOR EACH int-pedido-comissao NO-LOCK
           WHERE int-pedido-comissao.nr-pedcli = nota-fiscal.nr-pedcli:

            ASSIGN v_cod_parcela   = v_cod_parcela + 1.
        
            EMPTY TEMP-TABLE tt_integr_apb_lote_impl.
            EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl_3.
            EMPTY TEMP-TABLE tt_integr_apb_aprop_ctbl_pend.
            EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl3v.
    
            /* ** Verifica se jˇ existe o t≠tulo no contas a pagar ***/
            REPEAT WHILE NOT v_log_refer_uni:
                ASSIGN v_log_refer_uni = YES.
    
                IF CAN-FIND(FIRST tit_ap NO-LOCK
                            WHERE tit_ap.cod_estab   = nota-fiscal.cod-estabel
                              AND tit_ap.cdn_fornec  = int-pedido-comissao.cod-emitente
                              AND tit_ap.cod_espec   = "DP":U
                              AND tit_ap.cod_ser     = nota-fiscal.serie
                              AND tit_ap.cod_tit_ap  = nota-fiscal.nr-nota-fis
                              AND tit_ap.cod_parcela = TRIM(STRING(v_cod_parcela, ">9":U))) THEN
                    ASSIGN v_log_refer_uni = NO
                           v_cod_parcela   = v_cod_parcela + 1.
            END.
    
            ASSIGN v_log_refer_uni = NO.
    
            /* ** Gera Referºncia Vˇlida ***/
            REPEAT WHILE NOT v_log_refer_uni:
                RUN pi_retorna_sugestao_referencia (INPUT  "F":U,
                                                    INPUT  v_data,
                                                    OUTPUT v_cod_refer).
    
                RUN pi_verifica_refer_unica_apb (INPUT  nota-fiscal.cod-estabel,
                                                 INPUT  v_cod_refer,
                                                 INPUT  "lote_impl_tit_ap":U,
                                                 INPUT  ?,
                                                 OUTPUT v_log_refer_uni).
            END.
    
            /* ** Criaªío do Lote ***/
            CREATE tt_integr_apb_lote_impl.
            ASSIGN tt_integr_apb_lote_impl.tta_cod_estab         = nota-fiscal.cod-estabel
                   tt_integr_apb_lote_impl.tta_cod_refer         = v_cod_refer
                   tt_integr_apb_lote_impl.tta_cod_espec_docto   = "":U
                   tt_integr_apb_lote_impl.tta_dat_transacao     = v_data
                   tt_integr_apb_lote_impl.tta_ind_origin_tit_ap = "APB":U
                   tt_integr_apb_lote_impl.tta_cod_empresa       = "1".
    
            RELEASE tt_integr_apb_lote_impl.
            FIND FIRST tt_integr_apb_lote_impl NO-ERROR.

            /* ** T≠tulo de Provisío ***/
            CREATE tt_integr_apb_item_lote_impl_3.
            ASSIGN tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl = RECID(tt_integr_apb_lote_impl)
                   tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote = RECID(tt_integr_apb_item_lote_impl_3)
                   tt_integr_apb_item_lote_impl_3.tta_num_seq_refer            = 1
                   tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor           = int-pedido-comissao.cod-emitente
                   tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto          = "DP":U
                   tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto            = nota-fiscal.serie        
                   tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap               = nota-fiscal.nr-nota-fis  
                   tt_integr_apb_item_lote_impl_3.tta_cod_parcela              = TRIM(STRING(v_cod_parcela, ">9":U))
                   tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto           = v_data
                   tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap        = v_data + 30
                   tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto           = v_data + 30
                   tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto          = "20":U
                   tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ           = "Real":U
                   tt_integr_apb_item_lote_impl_3.tta_val_tit_ap               = nota-fiscal.vl-tot-nota * int-pedido-comissao.valor / 100
                   tt_integr_apb_item_lote_impl_3.tta_cod_portador             = "999":U
                   tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ     = 1.
    
            RELEASE tt_integr_apb_item_lote_impl_3.
            FIND FIRST tt_integr_apb_item_lote_impl_3 NO-ERROR.
    
            /* ** ApropriaªÑes do T≠tulo ***/
            CREATE tt_integr_apb_aprop_ctbl_pend.
            ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote  = RECID(tt_integr_apb_item_lote_impl_3)
                   tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend      = ?
                   tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend = ?
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc            = "ADM":U
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ      = "203":U
                   tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl            = nota-fiscal.vl-tot-nota * int-pedido-comissao.valor / 100
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl        = "PADRAO"
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl              = "11910005".
    
            RELEASE tt_integr_apb_aprop_ctbl_pend.
            FIND FIRST tt_integr_apb_aprop_ctbl_pend NO-ERROR.
    
            /* ** Transfere o t≠tulo para a nova temp-table da API ***/
            CREATE tt_integr_apb_item_lote_impl3v.
            BUFFER-COPY tt_integr_apb_item_lote_impl_3 TO tt_integr_apb_item_lote_impl3v.
    
            RELEASE tt_integr_apb_item_lote_impl3v.
            FIND FIRST tt_integr_apb_item_lote_impl3v NO-ERROR.
    
            /* ** Chamada da API ***/ 
            RUN prgfin/apb/apb900zg.py PERSISTENT SET v_hdl_aux.
    
            RUN pi_main_block_api_tit_ap_cria_4 IN v_hdl_aux (INPUT 5,
                                                              INPUT "EMS":U,
                                                              INPUT-OUTPUT TABLE tt_integr_apb_item_lote_impl3v).
    
            DELETE PROCEDURE v_hdl_aux.
    
            /* ** Retorna erros da API ***/
            FOR EACH tt_log_erros_atualiz :
                CREATE tt_log_erros.
                ASSIGN tt_log_erros.tta_cod_transp    = int-pedido-comissao.cod-emitente
                       tt_log_erros.tta_serie         = nota-fiscal.serie       
                       tt_log_erros.tta_nr_fatura     = nota-fiscal.nr-nota-fis 
                       tt_log_erros.tta_dt_emissao    = v_data
                       tt_log_erros.ttv_num_mensagem  = tt_log_erros_atualiz.ttv_num_mensagem
                       tt_log_erros.ttv_des_msg_erro  = tt_log_erros_atualiz.ttv_des_msg_erro
                       tt_log_erros.ttv_des_msg_ajuda = tt_log_erros_atualiz.ttv_des_msg_ajuda. 
            END.
    
            IF NOT CAN-FIND(FIRST tt_log_erros) THEN DO:
                FIND FIRST tit_ap
                    WHERE tit_ap.cod_estab   = nota-fiscal.cod-estabel
                      AND tit_ap.cdn_fornec  = int-pedido-comissao.cod-emitente
                      AND tit_ap.cod_espec   = "DP":U
                      AND tit_ap.cod_ser     = nota-fiscal.serie        
                      AND tit_ap.cod_tit_ap  = nota-fiscal.nr-nota-fis  
                      AND tit_ap.cod_parcela = TRIM(STRING(v_cod_parcela, ">9":U)) NO-LOCK NO-ERROR.
    
                IF NOT AVAILABLE tit_ap THEN DO:
                    CREATE tt_log_erros.
                    ASSIGN tt_log_erros.tta_cod_transp    = int-pedido-comissao.cod-emitente
                           tt_log_erros.tta_serie         = nota-fiscal.serie        
                           tt_log_erros.tta_nr_fatura     = nota-fiscal.nr-nota-fis  
                           tt_log_erros.tta_dt_emissao    = v_data
                           tt_log_erros.ttv_num_mensagem  = 0
                           tt_log_erros.ttv_des_msg_erro  = "T≠tulo nío gerado no contas a pagar !":U
                           tt_log_erros.ttv_des_msg_ajuda = "Estab/Transp/Ser/Tit/Parc/Emis: ":U + nota-fiscal.cod-estabel + " / ":U + STRING(int-pedido-comissao.cod-emitente) + " / ":U + nota-fiscal.serie + "/":U + nota-fiscal.nr-nota-fis + " / ":U + TRIM(STRING(v_cod_parcela, ">9":U)) + "/":U + STRING(v_data, "99/99/99":U).
                END.
            END.
        END.
    
        IF CAN-FIND(FIRST tt_log_erros) THEN STOP.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-gera-referencia:
    DEFINE INPUT  PARAMETER p-cod-estab  AS CHARACTER FORMAT "x(3)"    NO-UNDO.
    DEFINE INPUT  PARAMETER p-rec-tabela AS RECID     FORMAT ">>>>>>9" NO-UNDO.
    DEFINE OUTPUT PARAMETER p-referencia AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE l-log-refer-uni AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-des-dat       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-num-aux       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cont          AS INTEGER     NO-UNDO.

    /* Gera o cΩdigo da referºncia */
    ASSIGN c-des-dat    = STRING(TODAY,"99999999")
           p-referencia = SUBSTRING(c-des-dat,7,2) + SUBSTRING(c-des-dat,3,2) + SUBSTRING(c-des-dat,1,2) + "T"
           i-num-aux    = INTEGER(THIS-PROCEDURE:HANDLE).

    DO  i-cont = 1 TO 3:
        ASSIGN p-referencia = p-referencia + CHR((RANDOM(0,i-num-aux) MOD 26) + 97).
    END.


    /* Verifica se a referºncia ≤ única */
    RUN pi-verifica-refer-unica-acr IN THIS-PROCEDURE (INPUT  p-cod-estab,
                                                       INPUT  p-referencia,
                                                       INPUT  "",
                                                       INPUT  p-rec-tabela,
                                                       OUTPUT l-log-refer-uni).
    IF  NOT l-log-refer-uni THEN
        RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  p-cod-estab,
                                                  INPUT  p-rec-tabela,
                                                  OUTPUT p-referencia).

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-verifica-refer-unica-acr:
    /************************ Parameter Definition Begin ************************/
    DEF INPUT  PARAM p_cod_estab     AS CHARACTER FORMAT "x(3)"    NO-UNDO.
    DEF INPUT  PARAM p_cod_refer     AS CHARACTER FORMAT "x(10)"   NO-UNDO.
    DEF INPUT  PARAM p_cod_table     AS CHARACTER FORMAT "x(8)"    NO-UNDO.
    DEF INPUT  PARAM p_rec_tabela    AS RECID     FORMAT ">>>>>>9" NO-UNDO.
    DEF OUTPUT PARAM p_log_refer_uni AS LOGICAL   FORMAT "Sim/Nío" NO-UNDO.
    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/
    DEFINE BUFFER b_cobr_especial_acr FOR cobr_especial_acr.
    DEFINE BUFFER b_lote_impl_tit_acr FOR lote_impl_tit_acr.
    DEFINE BUFFER b_lote_liquidac_acr FOR lote_liquidac_acr.
    DEFINE BUFFER b_movto_tit_acr     FOR movto_tit_acr.
    DEFINE BUFFER b_operac_financ_acr FOR operac_financ_acr.
    DEFINE BUFFER b_renegoc_acr       FOR renegoc_acr.
    /*************************** Buffer Definition End **************************/

    ASSIGN p_log_refer_uni = YES.

    IF  p_cod_table <> "lote_impl_tit_acr" /*l_lote_impl_tit_acr*/  THEN DO:
        FIND FIRST b_lote_impl_tit_acr NO-LOCK
             WHERE b_lote_impl_tit_acr.cod_estab = p_cod_estab
               AND b_lote_impl_tit_acr.cod_refer = p_cod_refer
               AND RECID( b_lote_impl_tit_acr ) <> p_rec_tabela
             USE-INDEX ltmplttc_id NO-ERROR.
        IF  AVAIL b_lote_impl_tit_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF  p_cod_table <> "lote_liquidac_acr" /*l_lote_liquidac_acr*/  THEN DO:
        FIND FIRST b_lote_liquidac_acr NO-LOCK
             WHERE b_lote_liquidac_acr.cod_estab_refer = p_cod_estab
               AND b_lote_liquidac_acr.cod_refer       = p_cod_refer
               AND RECID( b_lote_liquidac_acr )       <> p_rec_tabela
             USE-INDEX ltlqdccr_id NO-ERROR.
        IF  AVAIL b_lote_liquidac_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF  p_cod_table <> "Operaªío financeira" /*l_operacao_financ*/  THEN DO:
        FIND FIRST b_operac_financ_acr NO-LOCK
             WHERE b_operac_financ_acr.cod_estab               = p_cod_estab
               AND b_operac_financ_acr.cod_movto_operac_financ = p_cod_refer
               AND RECID( b_operac_financ_acr )               <> p_rec_tabela
             USE-INDEX oprcfnna_id NO-ERROR.
        IF  AVAIL b_operac_financ_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF  p_cod_table = 'cobr_especial_acr' THEN DO:
        FIND FIRST b_cobr_especial_acr NO-LOCK
             WHERE b_cobr_especial_acr.cod_estab = p_cod_estab
               AND b_cobr_especial_acr.cod_refer = p_cod_refer
               AND RECID( b_cobr_especial_acr ) <> p_rec_tabela
             USE-INDEX cbrspclc_id NO-ERROR.
        IF  AVAIL b_cobr_especial_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF  p_log_refer_uni = YES THEN DO:
        FIND FIRST b_renegoc_acr NO-LOCK
            WHERE b_renegoc_acr.cod_estab = p_cod_estab
            AND   b_renegoc_acr.cod_refer = p_cod_refer
            AND   RECID(b_renegoc_acr)   <> p_rec_tabela
            NO-ERROR.
        IF  AVAIL b_renegoc_acr then
            ASSIGN p_log_refer_uni = no.
        ELSE DO:
            FIND FIRST b_movto_tit_acr NO-LOCK
                 WHERE b_movto_tit_acr.cod_estab = p_cod_estab
                   AND b_movto_tit_acr.cod_refer = p_cod_refer
                   AND RECID(b_movto_tit_acr)   <> p_rec_tabela
                 USE-INDEX mvtttcr_refer
                 NO-ERROR.
            IF  AVAIL b_movto_tit_acr THEN
                ASSIGN p_log_refer_uni = NO.
        END.
    END.

END PROCEDURE.

PROCEDURE pi_retorna_sugestao_referencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p_ind_tip_atualiz AS CHARACTER   NO-UNDO FORMAT "x(8)":U.
    DEFINE INPUT  PARAMETER p_dat_refer       AS DATE        NO-UNDO FORMAT "99/99/9999":U.
    DEFINE OUTPUT PARAMETER p_cod_refer       AS CHARACTER   NO-UNDO FORMAT "x(10)":U.

    DEFINE VARIABLE v_des_dat   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_num_aux   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_num_aux_2 AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_num_cont  AS INTEGER     NO-UNDO.

    ASSIGN v_des_dat   = STRING(p_dat_refer, "99999999":U)
           p_cod_refer = SUBSTRING(v_des_dat, 7, 2) + SUBSTRING(v_des_dat, 3, 2) + SUBSTRING(v_des_dat, 1, 2) + SUBSTRING(p_ind_tip_atualiz, 1, 1)
           v_num_aux_2 = INTEGER(THIS-PROCEDURE:HANDLE).

    DO v_num_cont = 1 TO 3:
        ASSIGN v_num_aux   = (RANDOM(0, v_num_aux_2) MODULO 26) + 97
               p_cod_refer = p_cod_refer + CHR(v_num_aux).
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi_verifica_refer_unica_apb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p_cod_estab        AS CHARACTER   NO-UNDO FORMAT "x(3)":U.
    DEFINE INPUT  PARAMETER p_cod_refer        AS CHARACTER   NO-UNDO FORMAT "x(10)":U.
    DEFINE INPUT  PARAMETER p_cod_table        AS CHARACTER   NO-UNDO FORMAT "x(8)":U.
    DEFINE INPUT  PARAMETER p_rec_movto_tit_ap AS RECID       NO-UNDO FORMAT ">>>>>>9":U.
    DEFINE OUTPUT PARAMETER p_log_refer_uni    AS LOGICAL     NO-UNDO FORMAT "Sim/Nío":U.

    DEFINE BUFFER b_antecip_pef_pend FOR antecip_pef_pend.
    DEFINE BUFFER b_lote_impl_tit_ap FOR lote_impl_tit_ap.
    DEFINE BUFFER b_lote_pagto       FOR lote_pagto.
    DEFINE BUFFER b_movto_tit_ap     FOR movto_tit_ap.

    ASSIGN p_log_refer_uni = YES.

    IF p_cod_table <> "antecip_pef_pend":U THEN
        FIND FIRST b_antecip_pef_pend
            WHERE b_antecip_pef_pend.cod_estab = p_cod_estab
              AND b_antecip_pef_pend.cod_refer = p_cod_refer NO-LOCK NO-ERROR.

    IF AVAILABLE b_antecip_pef_pend THEN
        ASSIGN p_log_refer_uni = NO.
    ELSE DO:
        IF p_cod_table <> "lote_impl_tit_ap":U THEN
            FIND FIRST b_lote_impl_tit_ap
                WHERE b_lote_impl_tit_ap.cod_estab = p_cod_estab
                  AND b_lote_impl_tit_ap.cod_refer = p_cod_refer NO-LOCK NO-ERROR.

        IF AVAILABLE b_lote_impl_tit_ap THEN
            ASSIGN p_log_refer_uni = NO.
        ELSE DO:
            IF p_cod_table <> "lote_pagto":U THEN
                FIND FIRST b_lote_pagto
                    WHERE b_lote_pagto.cod_estab_refer = p_cod_estab
                      AND b_lote_pagto.cod_refer       = p_cod_refer NO-LOCK NO-ERROR.

            IF AVAILABLE b_lote_pagto THEN
                ASSIGN p_log_refer_uni = NO.
            ELSE DO:
                FIND FIRST b_movto_tit_ap
                    WHERE b_movto_tit_ap.cod_estab = p_cod_estab
                      AND b_movto_tit_ap.cod_refer = p_cod_refer
                      AND RECID(b_movto_tit_ap)   <> p_rec_movto_tit_ap NO-LOCK NO-ERROR.

                IF AVAILABLE b_movto_tit_ap THEN
                    ASSIGN p_log_refer_uni = NO.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.
