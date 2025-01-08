/**
 * Extrator para BI
 * Fato: Carteira - Contas a Receber
 *
 * Autor: Felipe Braun Azambuja
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parƒmetros **/
{bi/fact004tt.i}
{bi/esbi000.i}

define input  parameter table for tt-param.
define output parameter table for ttFactContasReceberCarteira.
define output parameter table for tt-erro.

find first tt-param.

define variable dt-data       as date        no-undo.
define variable dt-inicial    as date        no-undo.
define variable dt-final      as date        no-undo.
define variable dt-final-calc as date        no-undo.
define variable c-negativos   as character   no-undo.
define variable c-pais        as character   no-undo.
define variable c-estado      as character   no-undo.
define variable c-cidade      as character   no-undo.

assign dt-inicial    = date(month(tt-param.dt-inicial), 1, year(tt-param.dt-inicial))
       dt-final      = date(month(tt-param.dt-final), 1, year(tt-param.dt-final))
       dt-inicial    = add-interval(dt-inicial, 1, 'months') - 1
       dt-final      = add-interval(dt-final, 1, 'months') - 1
       dt-final-calc = dt-final.

assign dt-data = dt-inicial.

for each espec_docto no-lock
   where espec_docto.ind_tip_espec_docto = 'Antecipa‡Æo':
   assign c-negativos = c-negativos + espec_docto.cod_espec_docto + ','.
end.

/** Gambi **/
if dt-final > today then
   assign dt-final = today.

repeat while dt-data <= dt-final:
   log-manager:write-message('Atual: ' + string(dt-data, '99/99/9999'), 'DEBUG').

   run pi-extrai(input dt-data).

   assign dt-data = date(month(dt-data), 1, year(dt-data))
          dt-data = add-interval(dt-data, 2, 'months') - 1.
end.

/** Se a data final tem que ser today, extrai s¢ isso aqui **/
if (dt-final = today) and (dt-final-calc <> today) then do:
   assign dt-data = today.
   log-manager:write-message('Extraindo TODAY', 'DEBUG').

   run pi-extrai(input today).
end.

procedure pi-extrai:
   define input parameter pdt-data as date no-undo.

   run bi/fact004rp1.p (input pdt-data,
                        output table tt_titulos_em_aberto_acr).

   for each tt_titulos_em_aberto_acr
       BREAK BY tt_titulos_em_aberto_acr.tta_cdn_cliente:

       IF  FIRST-OF(tt_titulos_em_aberto_acr.tta_cdn_cliente)
       THEN DO:
           ASSIGN c-pais   = ""
                  c-estado = ""
                  c-cidade = "".

           FIND emitente NO-LOCK
               WHERE emitente.cod-emitente = tt_titulos_em_aberto_acr.tta_cdn_cliente NO-ERROR.

           IF  AVAIL emitente
           THEN
               ASSIGN c-cidade = fn-free-accent(UPPER(TRIM(emitente.cidade)))
                      c-estado = fn-free-accent(UPPER(TRIM(emitente.estado)))
                      c-pais   = fn-free-accent(UPPER(TRIM(emitente.pais))).

               if c-estado = 'DF' then
                  assign c-cidade = 'BRASILIA'. 
        END. /* IF  FIRST-OF(tt_titulos_em_aberto_acr.tta_cdn_cliente) */

      create ttFactContasReceberCarteira.
      assign ttFactContasReceberCarteira.CD_Estabelecimento   = tt_titulos_em_aberto_acr.tta_cod_estab
             ttFactContasReceberCarteira.CD_Especie_Documento = fn-free-accent(upper(trim(tt_titulos_em_aberto_acr.tta_cod_espec_docto)))
             ttFactContasReceberCarteira.CD_Serie             = fn-free-accent(upper(trim(tt_titulos_em_aberto_acr.tta_cod_ser_docto)))
             ttFactContasReceberCarteira.CD_Titulo            = fn-free-accent(upper(trim(tt_titulos_em_aberto_acr.tta_cod_tit_acr)))
             ttFactContasReceberCarteira.CD_Parcela           = fn-free-accent(upper(trim(tt_titulos_em_aberto_acr.tta_cod_parcela)))
             ttFactContasReceberCarteira.CD_Unidade_Negocio   = fn-free-accent(upper(trim(tt_titulos_em_aberto_acr.tta_cod_unid_negoc)))
             ttFactContasReceberCarteira.CD_Emitente          = tt_titulos_em_aberto_acr.tta_cdn_cliente
             ttFactContasReceberCarteira.CD_Portador          = fn-free-accent(upper(trim(tt_titulos_em_aberto_acr.tta_cod_portador)))
             ttFactContasReceberCarteira.CD_Carteira_Bancaria = fn-free-accent(upper(trim(tt_titulos_em_aberto_acr.tta_cod_cart_bcia)))
             ttFactContasReceberCarteira.CD_Representante     = tt_titulos_em_aberto_acr.tta_cdn_repres
             ttFactContasReceberCarteira.CD_Pais              = c-pais
             ttFactContasReceberCarteira.CD_Estado            = c-estado
             ttFactContasReceberCarteira.CD_Cidade            = c-cidade
             ttFactContasReceberCarteira.DT_Posicao           = pdt-data
             ttFactContasReceberCarteira.DT_Emissao           = tt_titulos_em_aberto_acr.tta_dat_emis_docto
             ttFactContasReceberCarteira.DT_Vencimento        = tt_titulos_em_aberto_acr.tta_dat_vencto_tit_acr
             ttFactContasReceberCarteira.NM_Vl_Saldo          = tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr * (if lookup(ttFactContasReceberCarteira.CD_Especie_Documento, c-negativos) > 0 then -1 else 1)
             ttFactContasReceberCarteira.NM_Dias_Atraso       = tt_titulos_em_aberto_acr.ttv_num_atraso_dias_acr.
   end.
end procedure.
