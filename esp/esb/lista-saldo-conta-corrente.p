

FUNCTION fnbeneficio RETURNS CHARACTER
  (INPUT p-tipo AS INTEGER)  FORWARD.
    
FUNCTION fnMovto RETURNS CHARACTER
  ( p-movto AS INTEGER /* parameter-definitions */ )  FORWARD.

FUNCTION fnSitPedido RETURNS CHARACTER
  ( INPUT  p-sit AS INTEGER )  FORWARD.


DEF VAR i-canal           AS INTEGER NO-UNDO.
DEF VAR c-nome-abrev      AS CHAR    NO-UNDO.
DEF VAR c-cgc             AS CHAR    NO-UNDO.
DEF VAR c-nome            AS CHAR    NO-UNDO.
DEF VAR i-beneficio       AS INTEGER NO-UNDO.
DEF VAR c-beneficio       AS CHAR    NO-UNDO.
DEF VAR c-unidade         AS CHAR    NO-UNDO.
DEF VAR c-class           AS CHAR    NO-UNDO.
DEF VAR c-categoria       AS CHAR    NO-UNDO.
DEF VAR de-custo          AS DEC     NO-UNDO.
DEF VAR de-benef          AS DEC     NO-UNDO.
DEF VAR de-verba          AS DEC     NO-UNDO.
DEF VAR de-origem-tit     AS DEC     NO-UNDO.
DEF VAR de-tit            AS DEC     NO-UNDO.
DEF VAR de-solicitado     AS DEC     NO-UNDO.
DEF VAR de-pendente       AS DEC     NO-UNDO.
DEF VAR de-pago           AS DEC     NO-UNDO.
DEF VAR de-disponivel     AS DEC     NO-UNDO.
DEF VAR c-user-alte       AS CHAR    NO-UNDO.
DEF VAR c-user-reat       AS CHAR    NO-UNDO.
DEF VAR c-natureza        AS CHAR    NO-UNDO.
DEF VAR c-sit-ped         AS CHAR    NO-UNDO.
DEF VAR c-nr-ped          AS CHAR    NO-UNDO.
DEF VAR de-liq            AS DEC     NO-UNDO.
DEF VAR de-tot-ped        AS DEC     NO-UNDO.
DEF VAR da-solicitacao    AS DATE    NO-UNDO.
DEF VAR c-hora            AS CHAR    NO-UNDO.
DEF VAR l-enviado         AS LOG     NO-UNDO.
DEF VAR c-situacao        AS CHAR    NO-UNDO.
DEF VAR de-verba-ori      AS DEC     NO-UNDO.
DEF VAR de-val-empenhado  AS DEC     NO-UNDO.
DEF VAR de-val-realizado  AS DEC     NO-UNDO.
DEF VAR de-val-disponivel AS DEC     NO-UNDO.

DEF VAR l-tem-itens AS LOG NO-UNDO.

OUTPUT TO c:\temp\saldo-contas-correntes.csv CONVERT TARGET "iso8859-1".     
PUT "Canal;NomeAbrev;Nome;Tp Benef;Benef°cio;Unidade;Classif;Categoria;%Custo;%Benf°cio; VERBA ORIGINAL; VERBA ATUAL (+/-Ajustes); REALIZADO; EMPENHADO; DISPON÷VEL; APB ORIGINAL; APB ATUAL" SKIP.
            
FOR EACH int-cc-benef NO-LOCK
    ,FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = int-cc-benef.canal:

    FIND FIRST int-class-canal NO-LOCK
         WHERE int-class-canal.codigo-classificacao = int-cc-benef.classificacao NO-ERROR.

    FIND FIRST tit_ap NO-LOCK
        WHERE tit_ap.cod_estab     = int-cc-benef.cod_estab
          AND tit_ap.num_id_tit_ap = int-cc-benef.num_id_tit_ap NO-ERROR.

    RUN pi-zera-variaveis.

    ASSIGN  i-canal       = int-cc-benef.canal
            c-nome-abrev  = emitente.nome-abrev
            c-cgc         = emitente.cgc
            c-nome        = emitente.nome-emit
            i-beneficio   = int-cc-benef.tipo-beneficio
            c-beneficio   = fnBeneficio(int-cc-benef.tipo-beneficio) 
            c-unidade     = upper(int-cc-benef.unid-neg)
            c-class       = IF  NOT AVAIL int-class-canal THEN "N∆o encontrou" ELSE int-class-canal.nome            
            c-categoria   = int-cc-benef.categoria   
            de-custo      = int-cc-benef.perc-custo
            de-benef      = int-cc-benef.perc-benef
            de-verba-ori  = int-cc-benef.vl-saldo-ori
            de-verba      = int-cc-benef.vl-saldo
            de-tit        = (IF  NOT AVAIL tit_ap THEN 0 ELSE tit_ap.val_sdo_tit_ap)
            de-origem-tit = (IF  NOT AVAIL tit_ap THEN 0 ELSE tit_ap.val_origin_tit_ap).

    RUN pi-solicitacao.

    ASSIGN de-val-disponivel = de-verba - de-val-realizado - de-val-empenhado.
    
   /* RUN pi-solicitacao. */
    EXPORT  DELIMITER ";" i-canal      
                          c-nome-abrev 
                          c-nome       
                          i-beneficio  
                          c-beneficio  
                          c-unidade    
                          c-class      
                          c-categoria  
                          de-custo     
                          de-benef     
                          de-verba-ori 
                          de-verba     
                          de-val-realizado
                          de-val-empenhado
                          de-val-disponivel
                          de-origem-tit
                          de-tit.

    PUT SKIP.

END.

OUTPUT CLOSE.

PROCEDURE pi-solicitacao:

    
    ASSIGN  de-val-empenhado = 0
            de-val-realizado = 0   
            de-val-realizado = 0.

    FOR EACH int-solicitacao NO-LOCK                                                          
        WHERE int-solicitacao.CodigoConta                  = int-cc-benef.guid-canal     
          AND int-solicitacao.CodigoUnidadeNegocio         = int-cc-benef.unid-neg       
          AND int-solicitacao.tipo-beneficio               = int-cc-benef.tipo-beneficio 
          AND int-solicitacao.dt-periodo-ini               = int-cc-benef.dt-periodo-ini 
          AND int-solicitacao.dt-periodo-fim               = int-cc-benef.dt-periodo-fim
          AND NOT int-solicitacao.log-1:

       IF  int-solicitacao.SituacaoSolicitacaoBeneficio = 993520003 THEN
           ASSIGN de-val-empenhado = de-val-empenhado + int-solicitacao.ValorSolicitado.
       IF  int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004 THEN
           ASSIGN de-val-realizado = de-val-realizado + int-solicitacao.ValorSolicitado.

    END.
END.

PROCEDURE pi-zera-variaveis:

    ASSIGN i-canal        = 0
           c-nome-abrev   = ""
           c-cgc          = ""
           c-nome         = ""
           i-beneficio    = 0
           c-beneficio    = ""
           c-unidade      = ""
           c-class        = ""
           c-categoria    = ""
           de-custo       = 0
           de-benef       = 0
           de-verba       = 0
           de-origem-tit  = 0
           de-tit         = 0
           c-situacao     = ""
           da-solicitacao = ?
           c-hora         = "00:00:00"
           de-solicitado  = 0
           de-pendente    = 0
           de-pago        = 0
           de-disponivel  = 0
           c-sit-ped      = ""
           c-nr-ped       = ""
           c-natureza     = ""
           c-user-alte    = ""
           c-user-reat    = ""
           de-liq         = 0
           de-verba-ori   = 0
           de-tot-ped     = 0
           l-enviado      = NO.
END.

FUNCTION fnbeneficio RETURNS CHARACTER
  (INPUT p-tipo AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE p-tipo:
      WHEN 21 THEN RETURN "V M C".
      WHEN 37 THEN RETURN "Rebate".
      WHEN 22 THEN RETURN "Stock Rotation".
      WHEN 66 THEN RETURN "Rebate P¢s-Venda".
  END CASE.

END FUNCTION.

FUNCTION fnMovto RETURNS CHARACTER
  ( p-movto AS INTEGER /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE p-movto:
      WHEN 1 THEN RETURN "PROV".
      WHEN 2 THEN RETURN "DESP".
  END CASE.

END FUNCTION.

FUNCTION fnSitPedido RETURNS CHARACTER
  ( INPUT  p-sit AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE p-sit:
      WHEN 1 THEN RETURN "Aberto".
      WHEN 2 THEN RETURN "Atendido Parcial".
      WHEN 3 THEN RETURN "Atendido Total".
      WHEN 4 THEN RETURN "Pendente".
      WHEN 5 THEN RETURN "Suspenso".
      WHEN 6 THEN RETURN "Cancelado".
      WHEN 7 THEN RETURN "Fatur Balc∆o".
  END CASE.

  RETURN "".   /* Function return value. */

END FUNCTION.

