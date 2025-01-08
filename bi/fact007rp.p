/**
 * Extrator para BI
 * Fato: Limite de CrÇdito
 *
 * Autor: Felipe Braun Azambuja
 * 31/10/2011 - Hoepers: enviar a moeda e n∆o fazer mais a convers∆o pela cotaá∆o desta
 * 09/11/2011 - Hoepers: Localiza extensao da parcela que contem o valor do cliente(com juros)
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parÉmetros **/
{bi/fact007tt.i}
{bi/esbi000.i}

define input  parameter table for tt-param.
define output parameter table for ttFactLimiteCredito.
define output parameter table for tt-erro.

find first tt-param.

define variable d-cotacao            as decimal                              no-undo.
define variable c-pais               as character                            no-undo.
define variable c-estado             as character                            no-undo.
define variable c-cidade             as character                            no-undo.
DEFINE VARIABLE v-cod-finalid-econ LIKE histor_finalid_econ.cod_finalid_econ NO-UNDO.
DEFINE VARIABLE v-mo-codigo        LIKE moeda.mo-codigo                      NO-UNDO.

define variable d-vl-lim-total  as decimal no-undo.
define variable d-vl-lim-usado  as decimal no-undo.
DEFINE VARIABLE v_tot_utilizado AS DECIMAL NO-UNDO.

define buffer bmovto_tit_acr_perdas for movto_tit_acr.
DEFINE BUFFER b-emitente            FOR emitente.
/***************************************************************************************/
for each emitente no-lock
   where emitente.identific <> 2:

   assign c-cidade       = fn-free-accent(upper(trim(emitente.cidade)))
          c-estado       = fn-free-accent(upper(trim(emitente.estado)))
          c-pais         = fn-free-accent(upper(trim(emitente.pais)))
          d-vl-lim-total = 0.         
   
   if c-estado = 'DF' then
      assign c-cidade = 'BRASILIA'.

/*    if (emitente.moeda-libcre > 0) then do:                                                              */
/*       find cotacao no-lock                                                                              */
/*          where cotacao.mo-codigo   = emitente.moeda-libcre                                              */
/*            and cotacao.ano-periodo = string(year(today), "9999") + string(month(today), "99") no-error. */
/*       if available (cotacao) and (cotacao.cotacao[day(today)] <> 0) then                                */
/*          assign d-cotacao = cotacao.cotacao[day(today)].                                                */
/*       else                                                                                              */
/*          assign d-cotacao = 1.                                                                          */
/*    end.                                                                                                 */
/*    else                                                                                                 */
/*       assign d-cotacao = 1.                                                                             */

   assign d-cotacao = 1.

   if (emitente.nome-abrev = emitente.nome-matriz) then
      assign d-vl-lim-total = emitente.lim-credito * d-cotacao.
   else
      assign d-vl-lim-total = 0.

   /** Valor total **/
   create ttFactLimiteCredito.
   assign ttFactLimiteCredito.CD_Emitente            = emitente.cod-emitente
          ttFactLimiteCredito.CD_Representante       = emitente.cod-rep
          ttFactLimiteCredito.CD_Moeda               = emitente.moeda-libcre
          ttFactLimiteCredito.CD_Pais                = c-pais
          ttFactLimiteCredito.CD_Estado              = c-estado
          ttFactLimiteCredito.CD_Cidade              = c-cidade
          ttFactLimiteCredito.CD_Indicador_Credito   = (if emitente.ind-cre-cli = 0 then 1 else emitente.ind-cre-cli)
          ttFactLimiteCredito.CD_Unidade_Negocio     = ?
          ttFactLimiteCredito.CD_Tipo_Limite_Credito = 1
          ttFactLimiteCredito.DT_Limite_Credito      = today - 1
          ttFactLimiteCredito.NM_Limite_Total        = d-vl-lim-total
          ttFactLimiteCredito.NM_Limite_Utilizado    = ?.


   /** Leitura dos t°tulos e pedidos em aberto **/
   for each estabelecimento no-lock:
      /** Ignora t°tulos da Nova e da Maxcom **/
      if (estabelecimento.cod_estab = '201') or (estabelecimento.cod_estab = '301') then
         next.

      for each tit_acr no-lock use-index titacr_cliente
         where tit_acr.cod_estab           = estabelecimento.cod_estab
           and tit_acr.cdn_cliente         = emitente.cod-emitente
           and tit_acr.val_sdo_tit_acr     > 0
           and tit_acr.log_tit_acr_estordo = no:

         if can-find (first bmovto_tit_acr_perdas
                         where bmovto_tit_acr_perdas.cod_estab           = tit_acr.cod_estab
                           and bmovto_tit_acr_perdas.num_id_tit_acr      = tit_acr.num_id_tit_acr
                           and bmovto_tit_acr_perdas.ind_trans_acr_abrev = "LQPD"
                           and bmovto_tit_acr_perdas.log_movto_estordo   = no) then
            next.
         
         if (tit_acr.ind_tip_espec_docto = 'Normal') or (tit_acr.ind_tip_espec_docto begins 'Vendor') then do:
            /** Ignora t°tulos vendor que vieram do magnus **/
            if (tit_acr.cod_espec_docto = 'VEM') then
               next.


            ASSIGN v-cod-finalid-econ = "Corrente".
            for first histor_finalid_econ fields (cod_finalid_econ) no-lock
                where histor_finalid_econ.cod_indic_econ          = tit_acr.cod_indic_econ
                and   histor_finalid_econ.dat_inic_valid_finalid <= TODAY
                and   histor_finalid_econ.dat_fim_valid_finalid   > TODAY.
            
                if avail histor_finalid_econ 
                then
                    assign v-cod-finalid-econ = histor_finalid_econ.cod_finalid_econ.
            end.

            ASSIGN v-mo-codigo = 0.
            find first trad_finalid_econ_ext no-lock
                 where trad_finalid_econ_ext.cod_matriz_trad_finalid_ext = "EMS"
                   and trad_finalid_econ_ext.cod_finalid_econ            = v-cod-finalid-econ  no-error.
            IF  AVAIL trad_finalid_econ_ext
            THEN
                ASSIGN v-mo-codigo = INT(trad_finalid_econ_ext.cod_finalid_econ_ext).

            bloco-val-tit:
            for each val_tit_acr of tit_acr no-lock:

                 IF tit_acr.cod_espec_docto = "VE"
                 THEN DO:
                      /* Localiza extensao da parcela que contem o valor do cliente(com juros) */
                      FIND FIRST parc_vendor NO-LOCK
                           WHERE parc_vendor.cod_estab_tit_acr = tit_acr.cod_estab
                             AND parc_vendor.num_id_tit_acr    = tit_acr.num_id_tit_acr NO-ERROR.
                      IF AVAIL parc_vendor
                      THEN DO:
                          run criaTt (INPUT 1, INPUT emitente.cod-emitente, input val_tit_acr.cod_unid_negoc, INPUT v-mo-codigo, input parc_vendor.val_parc_vendor_clien).
                          LEAVE bloco-val-tit.
                      END.
                 END.
                 ELSE DO:
                     IF  val_tit_acr.cod_finalid_econ = v-cod-finalid-econ 
                     THEN
                         run criaTt (INPUT 1, INPUT emitente.cod-emitente, input val_tit_acr.cod_unid_negoc, INPUT v-mo-codigo, input val_tit_acr.val_sdo_tit_acr).
                 END.
            end.
         end.
      end.

      /** Là pedidos em aberto **/
      for each ped-venda no-lock
         where ped-venda.cod-estabel  = estabelecimento.cod_estab
           and ped-venda.nome-abrev   = emitente.nome-abrev
           and ped-venda.cod-sit-ped <= 2
           and ped-venda.completo
           and ped-venda.cod-sit-aval = 3
           and ped-venda.cod-priori   = 01:

         /** Ignora pagamento Ö vista **/
         find cond-pagto no-lock
            where cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag no-error.
         if available (cond-pagto) and (cond-pagto.cod-vencto = 2) and (cond-pagto.cod-cond-pag <> 502) then
            next.

/*          if (ped-venda.mo-codigo > 0) then do:                                                                */
/*             find cotacao no-lock                                                                              */
/*                where cotacao.mo-codigo   = ped-venda.mo-codigo                                                */
/*                  and cotacao.ano-periodo = string(year(today), "9999") + string(month(today), "99") no-error. */
/*             if available (cotacao) and (cotacao.cotacao[day(today)] <> 0) then                                */
/*                assign d-cotacao = cotacao.cotacao[day(today)].                                                */
/*             else                                                                                              */
/*                assign d-cotacao = 1.                                                                          */
/*          end.                                                                                                 */
/*          else                                                                                                 */
/*             assign d-cotacao = 1.                                                                             */

         assign d-cotacao = 1.

         find int-ped-venda no-lock
             where int-ped-venda.nr-pedido = ped-venda.nr-pedido no-error.

         for each ped-item of ped-venda no-lock
            where ped-item.cod-sit-item <= 2:
            empty temp-table tt-unid.

            if not can-find (first unid-neg-ped of ped-item) then do:
               create tt-unid.
               assign tt-unid.cod_unid_negoc = 'INV'
                      tt-unid.perc-unid-neg  = 100.
            end.
            else do:
               for each unid-neg-ped of ped-item no-lock:
                  create tt-unid.
                  assign tt-unid.cod_unid_negoc = unid-neg-ped.cod_unid_negoc
                         tt-unid.perc-unid-neg  = unid-neg-ped.perc-unid-neg.
               
                  /** Corrige unidade de neg¢cio **/
                  if (ped-venda.cod-estabel = '102' and tt-unid.cod_unid_negoc = 'ADM') then
                     assign tt-unid.cod_unid_negoc = 'COM'.
                  else if (ped-venda.cod-estabel = '301' and tt-unid.cod_unid_negoc = 'ADM') then
                     assign tt-unid.cod_unid_negoc = 'MAX'.
               end.
            end.

            assign d-vl-lim-usado = 0.

            for each tt-unid:
               if available (int-ped-venda) then
                   assign d-vl-lim-usado = d-vl-lim-usado + (ped-item.vl-liq-abe + int-ped-venda.vl-frete) * d-cotacao * tt-unid.perc-unid-neg / 100.
               else
                   assign d-vl-lim-usado = d-vl-lim-usado + ped-item.vl-liq-abe * d-cotacao * tt-unid.perc-unid-neg / 100.
   
               run criaTt(INPUT 1, INPUT emitente.cod-emitente, input tt-unid.cod_unid_negoc, INPUT ped-venda.mo-codigo, input d-vl-lim-usado).
            end.
         end.
      end.
   end.

   RUN pi_cria_limite_HSBC.
   RUN pi_cria_limite_SC.

end.

PROCEDURE pi_cria_limite_HSBC:

    FIND int-emitente-hsbc-limite NO-LOCK
        WHERE int-emitente-hsbc-limite.cod-emitente   = emitente.cod-emitente
          AND int-emitente-hsbc-limite.ind-tipo       = "Limite"
          AND int-emitente-hsbc-limite.dat-ocorrencia = TODAY NO-ERROR.

    IF NOT AVAIL int-emitente-hsbc-limite
       THEN NEXT.

    ASSIGN d-vl-lim-total = (int-emitente-hsbc-limite.val-limite + int-emitente-hsbc-limite.val-limite-utilizado) * d-cotacao.

    /** Valor total **/
    CREATE ttFactLimiteCredito.
    ASSIGN ttFactLimiteCredito.CD_Emitente            = emitente.cod-emitente
           ttFactLimiteCredito.CD_Representante       = emitente.cod-rep
           ttFactLimiteCredito.CD_Moeda               = emitente.moeda-libcre
           ttFactLimiteCredito.CD_Pais                = c-pais
           ttFactLimiteCredito.CD_Estado              = c-estado
           ttFactLimiteCredito.CD_Cidade              = c-cidade
           ttFactLimiteCredito.CD_Indicador_Credito   = (IF emitente.ind-cre-cli = 0 THEN 1 ELSE emitente.ind-cre-cli)
           ttFactLimiteCredito.CD_Unidade_Negocio     = ?
           ttFactLimiteCredito.CD_Tipo_Limite_Credito = 3
           ttFactLimiteCredito.DT_Limite_Credito      = today - 1
           ttFactLimiteCredito.NM_Limite_Total        = d-vl-lim-total
           ttFactLimiteCredito.NM_Limite_Utilizado    = ?.

    EMPTY TEMP-TABLE tt-unid.
    ASSIGN v_tot_utilizado = 0.

    /* ** Localiza os t°tulos que est∆o em aberto no HSBC e gera rateio proporcional entre as UNs atÇ receber a lista de t°tulos via arquivo do HSBC ***/
    /* ** Tratamento caso n∆o tenhamos o empenhado enviado pelo HSBC, verifica o que tem em aberto e proporcinaliza as UNs pelo total empenhado ***/
    FOR EACH estabelecimento NO-LOCK:
        FOR EACH tit_acr NO-LOCK
            WHERE tit_acr.cod_estab            = estabelecimento.cod_estab
              AND tit_acr.cdn_cliente          = emitente.cod-emitente
              AND tit_acr.cod_portad           = '399'
              AND tit_acr.cod_cart             = 'CSR'
              AND tit_acr.log_tit_acr_estordo  = NO
              AND tit_acr.cod_espec            = 'DM'
              AND tit_acr.log_sdo_tit_acr      = NO
              AND tit_acr.dat_vencto_tit_acr  >= TODAY:

            FOR EACH val_tit_acr OF tit_acr NO-LOCK:
                FIND tt-unid NO-LOCK
                    WHERE tt-unid.cod_unid_negoc = val_tit_acr.cod_unid_negoc NO-ERROR.
                IF NOT AVAIL tt-unid
                THEN DO: 
                     CREATE tt-unid.
                     ASSIGN tt-unid.cod_unid_negoc = val_tit_acr.cod_unid_negoc.
                END.
                ASSIGN tt-unid.val-utilizado = tt-unid.val-utilizado + val_tit_acr.val_origin_tit_acr
                       v_tot_utilizado       = v_tot_utilizado       + val_tit_acr.val_origin_tit_acr.
            END.

        END.
    END.

    FOR EACH tt-unid:
        ASSIGN tt-unid.perc-unid-neg = tt-unid.val-utilizado * 100 / v_tot_utilizado.
    END.

    FOR EACH tt-unid:
        RUN criaTt(INPUT 3, INPUT emitente.cod-emitente, INPUT tt-unid.cod_unid_negoc, INPUT emitente.moeda-libcre, INPUT (int-emitente-hsbc-limite.val-limite-utilizado * tt-unid.perc-unid-neg / 100)).
    END.

    /* ** Caso n∆o localize t°tulos CSR com data de vencimento futura, n∆o ser† poss°vel efetuar o rateio, aloca na ADM ***/
    IF  NOT CAN-FIND(FIRST tt-unid)
    AND int-emitente-hsbc-limite.val-limite-utilizado <> 0
        THEN RUN criaTt(INPUT 3, INPUT emitente.cod-emitente, INPUT "ADM", INPUT "0", INPUT int-emitente-hsbc-limite.val-limite-utilizado).

END.

PROCEDURE pi_cria_limite_SC:
     
    /* ** Verifica se o cliente j† foi criado pela estrutura de raiz do CNPJ ***/
    FIND FIRST ttFactLimiteCredito NO-LOCK
         WHERE ttFactLimiteCredito.CD_Emitente            = emitente.cod-emitente
           AND ttFactLimiteCredito.CD_Tipo_Limite_Credito = 2 NO-ERROR.
    IF AVAIL ttFactLimiteCredito 
       THEN RETURN.

    FIND int-emitente-supcard NO-LOCK
        WHERE int-emitente-supcard.raiz-cnpj     = SUBSTRING(emitente.cgc, 1, 8)
          AND int-emitente-supcard.dat-avaliacao = TODAY NO-ERROR.
    IF NOT AVAIL int-emitente-supcard 
       THEN NEXT.
    
    IF NOT int-emitente-supcard.log-habilitado 
       THEN NEXT.

    ASSIGN d-vl-lim-total = (int-emitente-supcard.val-limite-utilizado + int-emitente-supcard.val-limite) * d-cotacao.
    
    EMPTY TEMP-TABLE tt-unid.
    EMPTY TEMP-TABLE tt-unid-aux.

    ASSIGN v_tot_utilizado = 0.

    FOR EACH b-emitente NO-LOCK
        WHERE b-emitente.cgc BEGINS SUBSTRING(emitente.cgc, 1, 8)
          AND b-emitente.identific <> 2:

        /** Valor total **/
        CREATE ttFactLimiteCredito.
        ASSIGN ttFactLimiteCredito.CD_Emitente            = b-emitente.cod-emitente
               ttFactLimiteCredito.CD_Representante       = b-emitente.cod-rep
               ttFactLimiteCredito.CD_Moeda               = b-emitente.moeda-libcre
               ttFactLimiteCredito.CD_Pais                = c-pais
               ttFactLimiteCredito.CD_Estado              = c-estado
               ttFactLimiteCredito.CD_Cidade              = c-cidade
               ttFactLimiteCredito.CD_Indicador_Credito   = (IF b-emitente.ind-cre-cli = 0 THEN 1 ELSE b-emitente.ind-cre-cli)
               ttFactLimiteCredito.CD_Unidade_Negocio     = ?
               ttFactLimiteCredito.CD_Tipo_Limite_Credito = 2
               ttFactLimiteCredito.DT_Limite_Credito      = today - 1
               ttFactLimiteCredito.NM_Limite_Total        = d-vl-lim-total
               ttFactLimiteCredito.NM_Limite_Utilizado    = ?.

        /* ** Associa valor somente ao primeiro emitente que possua a raiz de CNPJ do limite ***/
        ASSIGN d-vl-lim-total = 0.

        /* ** Localiza os t°tulos, pedidos e NFs que est∆o em aberto para a SC e gera rateio proporcional entre as UNs atÇ receber a lista de t°tulos via arquivo da SC ***/
        /* ** Tratamento caso n∆o tenhamos o empenhado enviado pela SC, verifica o que tem em aberto e proporcinaliza as UNs pelo total empenhado ***/


        /* ** Pedidos - Alocaá∆o somente no limite SC Intelbras ***/
        FOR EACH  int-ped-aloc-supcard NO-LOCK
            WHERE int-ped-aloc-supcard.raiz-cnpj  = SUBSTRING(b-emitente.cgc, 1, 8)
              AND int-ped-aloc-supcard.nome-abrev = b-emitente.nome-abrev
            BREAK BY int-ped-aloc-supcard.nr-pedcli:
        
            IF FIRST-OF(int-ped-aloc-supcard.nr-pedcli)
            THEN DO:
                FIND FIRST ped-venda NO-LOCK
                     WHERE ped-venda.nr-pedcli  = int-ped-aloc-supcard.nr-pedcli
                       AND ped-venda.nome-abrev = int-ped-aloc-supcard.nome-abrev NO-ERROR.
    
                find int-ped-venda no-lock
                    where int-ped-venda.nr-pedido = ped-venda.nr-pedido no-error.
    
                for each ped-item of ped-venda no-lock
                   where ped-item.cod-sit-item <= 2:
    
                   if not can-find (first unid-neg-ped of ped-item) 
                   then do:
                        FIND tt-unid-aux NO-LOCK
                             WHERE tt-unid-aux.cdn_cliente    = b-emitente.cod-emitente
                               AND tt-unid-aux.cod_unid_negoc = 'INV' NO-ERROR.
                        IF NOT AVAIL tt-unid-aux
                        THEN DO: 
                             CREATE tt-unid-aux.
                             ASSIGN tt-unid-aux.cdn_cliente    = b-emitente.cod-emitente
                                    tt-unid-aux.cod_unid_negoc = 'INV'.
                        END.
                        ASSIGN tt-unid-aux.perc-unid-neg = 100.
                   end.
                   else do:
                      for each unid-neg-ped of ped-item no-lock:
                          FIND tt-unid-aux NO-LOCK
                               WHERE tt-unid-aux.cdn_cliente    = b-emitente.cod-emitente
                                 AND tt-unid-aux.cod_unid_negoc = unid-neg-ped.cod_unid_negoc NO-ERROR.
                          IF NOT AVAIL tt-unid-aux
                          THEN DO: 
                               CREATE tt-unid-aux.
                               ASSIGN tt-unid-aux.cdn_cliente    = b-emitente.cod-emitente
                                      tt-unid-aux.cod_unid_negoc = unid-neg-ped.cod_unid_negoc.
                          END.
                          ASSIGN tt-unid-aux.perc-unid-neg = unid-neg-ped.perc-unid-neg.
                      end.
                   end.
    
                   assign d-vl-lim-usado = 0.
    
                   FOR EACH tt-unid-aux
                       WHERE tt-unid-aux.cdn_cliente = b-emitente.cod-emitente:
                      if available (int-ped-venda) then
                          assign d-vl-lim-usado = d-vl-lim-usado + (ped-item.vl-liq-abe + int-ped-venda.vl-frete) * d-cotacao * tt-unid-aux.perc-unid-neg / 100.
                      else
                          assign d-vl-lim-usado = d-vl-lim-usado + ped-item.vl-liq-abe * d-cotacao * tt-unid-aux.perc-unid-neg / 100.
    
                      ASSIGN tt-unid-aux.val-utilizado = tt-unid-aux.val-utilizado + d-vl-lim-usado
                             v_tot_utilizado           = v_tot_utilizado           + d-vl-lim-usado.
                   END.


                end.
            END.
        END.

        /* ** Notas Fiscais emitidas e n∆o integradas ***/
        FOR EACH  int-nfs-supcard NO-LOCK
            WHERE int-nfs-supcard.raiz-cnpj = SUBSTRING(b-emitente.cgc, 1, 8)
              AND int-nfs-supcard.dat-movto = TODAY:

            FOR EACH tit_acr NO-LOCK
                WHERE tit_acr.cod_estab     = int-nfs-supcard.cod-estabel
                  AND tit_acr.cod_espec     = "DM"
                  AND tit_acr.cod_ser_docto = int-nfs-supcard.serie
                  AND tit_acr.cod_tit_acr   = int-nfs-supcard.nr-nota-fis:
                FOR EACH val_tit_acr OF tit_acr NO-LOCK:
                    FIND tt-unid-aux NO-LOCK
                        WHERE tt-unid-aux.cdn_cliente    = b-emitente.cod-emitente
                          AND tt-unid-aux.cod_unid_negoc = val_tit_acr.cod_unid_negoc NO-ERROR.
                    IF NOT AVAIL tt-unid-aux
                    THEN DO: 
                         CREATE tt-unid-aux.
                         ASSIGN tt-unid-aux.cdn_cliente    = b-emitente.cod-emitente
                                tt-unid-aux.cod_unid_negoc = val_tit_acr.cod_unid_negoc.
                    END.
                    ASSIGN tt-unid-aux.val-utilizado = tt-unid-aux.val-utilizado + val_tit_acr.val_origin_tit_acr
                           v_tot_utilizado           = v_tot_utilizado           + val_tit_acr.val_origin_tit_acr.
                END.
            END.

        END.

        /* ** Localiza t°tulos que estariam em aberto ***/
        FOR EACH estabelecimento NO-LOCK:
            FOR EACH tit_acr NO-LOCK
                WHERE tit_acr.cod_estab            = estabelecimento.cod_estab
                  AND tit_acr.cdn_cliente          = b-emitente.cod-emit
                  AND tit_acr.cod_portad           = '9915'
                  AND tit_acr.log_tit_acr_estordo  = NO
                  AND tit_acr.cod_espec            = 'dm'
                  AND tit_acr.dat_vencto_tit_acr  >= TODAY:
                FOR EACH val_tit_acr OF tit_acr NO-LOCK:
                    FIND tt-unid-aux NO-LOCK
                        WHERE tt-unid-aux.cdn_cliente    = b-emitente.cod-emitente
                          AND tt-unid-aux.cod_unid_negoc = val_tit_acr.cod_unid_negoc NO-ERROR.
                    IF NOT AVAIL tt-unid-aux
                    THEN DO: 
                         CREATE tt-unid-aux.
                         ASSIGN tt-unid-aux.cdn_cliente    = b-emitente.cod-emitente
                                tt-unid-aux.cod_unid_negoc = val_tit_acr.cod_unid_negoc.
                    END.
                    ASSIGN tt-unid-aux.val-utilizado = tt-unid-aux.val-utilizado + val_tit_acr.val_origin_tit_acr
                           v_tot_utilizado           = v_tot_utilizado           + val_tit_acr.val_origin_tit_acr.
                END.
            END.
        END.

    END.

    FOR EACH tt-unid-aux:
        ASSIGN tt-unid-aux.perc-unid-neg = (tt-unid-aux.val-utilizado * 100) / v_tot_utilizado.
    END.

    FOR EACH tt-unid-aux:
        RUN criaTt(INPUT 2, INPUT tt-unid-aux.cdn_cliente, INPUT tt-unid-aux.cod_unid_negoc, INPUT emitente.moeda-libcre, INPUT (int-emitente-supcard.val-limite-utilizado * (tt-unid-aux.perc-unid-neg / 100))).
    END.

    /* ** Caso n∆o localize saldo comprometido n∆o ser† poss°vel efetuar o rateio, aloca na ADM ***/
    IF  NOT CAN-FIND(FIRST tt-unid-aux)
    AND int-emitente-supcard.val-limite-utilizado <> 0 
       THEN RUN criaTt(INPUT 2, INPUT emitente.cod-emitente, INPUT "ADM", INPUT emitente.moeda-libcre, INPUT int-emitente-supcard.val-limite-utilizado).

END.

procedure criaTt:
   DEFINE INPUT PARAMETER pcod_tipo_limite_credito AS INT NO-UNDO.
   DEFINE INPUT PARAMETER pcod-emitente            AS INT NO-UNDO.
   define input parameter pcod_unid_negoc          like val_movto_tit_acr.cod_unid_negoc no-undo.
   DEFINE INPUT PARAMETER pcod_moeda               LIKE moeda.mo-codigo                  NO-UNDO.
   define input parameter pvl-lim-usado            as decimal no-undo.

   find ttFactLimiteCredito
      where ttFactLimiteCredito.CD_Emitente            = pcod-emitente
        AND ttFactLimiteCredito.CD_Tipo_Limite_Credito = pcod_tipo_limite_credito
        and ttFactLimiteCredito.CD_Unidade_Negocio     = pcod_unid_negoc
        AND ttFactLimiteCredito.CD_Moeda               = pcod_moeda no-error.
   if not available ttFactLimiteCredito then do:
      create ttFactLimiteCredito.
      assign ttFactLimiteCredito.CD_Emitente            = pcod-emitente
             ttFactLimiteCredito.CD_Representante       = emitente.cod-rep
             ttFactLimiteCredito.CD_Moeda               = pcod_moeda
             ttFactLimiteCredito.CD_Pais                = c-pais
             ttFactLimiteCredito.CD_Estado              = c-estado
             ttFactLimiteCredito.CD_Cidade              = c-cidade
             ttFactLimiteCredito.CD_Indicador_Credito   = (if emitente.ind-cre-cli = 0 then 1 else emitente.ind-cre-cli)
             ttFactLimiteCredito.CD_Unidade_Negocio     = fn-free-accent(trim(upper(pcod_unid_negoc)))
             ttFactLimiteCredito.CD_Tipo_Limite_Credito = pcod_tipo_limite_credito
             ttFactLimiteCredito.DT_Limite_Credito      = today - 1
             ttFactLimiteCredito.NM_Limite_Total        = ?.
   end.
   assign ttFactLimiteCredito.NM_Limite_Utilizado = ttFactLimiteCredito.NM_Limite_Utilizado + pvl-lim-usado.
end.
