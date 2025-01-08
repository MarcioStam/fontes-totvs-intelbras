

FUNCTION fnbeneficio RETURNS CHARACTER
  (INPUT p-tipo AS INTEGER)  FORWARD.
    
FUNCTION fnMovto RETURNS CHARACTER
  ( p-movto AS INTEGER /* parameter-definitions */ )  FORWARD.

FUNCTION fnSitPedido RETURNS CHARACTER
  ( INPUT  p-sit AS INTEGER )  FORWARD.


DEF VAR i-canal         AS INTEGER NO-UNDO.
DEF VAR c-nome-abrev    AS CHAR    NO-UNDO.
DEF VAR c-cgc           AS CHAR    NO-UNDO.
DEF VAR c-nome          AS CHAR    NO-UNDO.
DEF VAR i-beneficio     AS INTEGER NO-UNDO.
DEF VAR c-beneficio     AS CHAR    NO-UNDO.
DEF VAR c-unidade       AS CHAR    NO-UNDO.
DEF VAR c-class         AS CHAR    NO-UNDO.
DEF VAR c-categoria     AS CHAR    NO-UNDO.
DEF VAR de-custo        AS DEC     NO-UNDO.
DEF VAR de-benef        AS DEC     NO-UNDO.
DEF VAR de-verba        AS DEC     NO-UNDO.
DEF VAR de-origem-tit   AS DEC     NO-UNDO.
DEF VAR de-tit          AS DEC     NO-UNDO.
DEF VAR de-solicitado   AS DEC     NO-UNDO.
DEF VAR de-pendente     AS DEC     NO-UNDO.
DEF VAR de-pago         AS DEC     NO-UNDO.
DEF VAR de-disponivel   AS DEC     NO-UNDO.
DEF VAR c-user-alte     AS CHAR    NO-UNDO.
DEF VAR c-user-reat     AS CHAR    NO-UNDO.
DEF VAR c-natureza      AS CHAR    NO-UNDO.
DEF VAR c-sit-ped       AS CHAR    NO-UNDO.
DEF VAR c-nr-ped        AS CHAR    NO-UNDO.
DEF VAR de-liq          AS DEC     NO-UNDO.
DEF VAR de-tot-ped      AS DEC     NO-UNDO.
DEF VAR da-solicitacao  AS DATE    NO-UNDO.
DEF VAR c-hora          AS CHAR    NO-UNDO.
DEF VAR l-enviado       AS LOG     NO-UNDO.
DEF VAR c-situacao      AS CHAR    NO-UNDO.

DEF VAR l-tem-itens AS LOG NO-UNDO.

OUTPUT TO c:\temp\contas-correntes.csv CONVERT TARGET "iso8859-1".     
PUT "Canal;NomeAbrev;CGC;Nome;Tp Benef;Benef°cio;Unidade;Classif;Categoria;%Custo;%Benf°cio;VERBA INICIAL;Verba Dispon°vel;Saldo APB Original;Saldo APB Atual;Situaá∆o;Data;Hora;Solicitado;Pendente;Pago;Sit Pedido;NrPedido;Natureza;ÈLT Alteraá∆o;Reativaá∆oLiq.Pedido;Tot.Pedido;Enviado CRM" SKIP.
            
DO TRANS:

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
                de-verba      = int-cc-benef.vl-saldo
                de-tit        = (IF  NOT AVAIL tit_ap THEN 0 ELSE tit_ap.val_sdo_tit_ap)
                de-origem-tit = (IF  NOT AVAIL tit_ap THEN 0 ELSE tit_ap.val_origin_tit_ap).
    
        
        RUN pi-solicitacao.
    
        PUT SKIP.
    
    END.
    STOP.
END.

OUTPUT CLOSE.

PROCEDURE pi-solicitacao:

    DEF VAR de-tot-aprovadas AS DEC NO-UNDO.
    DEF VAR de-tot-pendente  AS DEC NO-UNDO.
    DEF VAR de-tot-pagas     AS DEC NO-UNDO.
    DEF VAR de-tot-ajustes   AS DEC NO-UNDO.
    DEF VAR de-tot-geral     AS DEC NO-UNDO.
    DEF VAR l-tem-solicitacao AS LOG NO-UNDO.
                           
    ASSIGN de-disponivel = int-cc-benef.vl-saldo .

    FOR EACH int-solicitacao NO-LOCK                                                          
        WHERE int-solicitacao.CodigoConta                  = int-cc-benef.guid-canal     
          AND int-solicitacao.CodigoUnidadeNegocio         = int-cc-benef.unid-neg       
          AND int-solicitacao.tipo-beneficio               = int-cc-benef.tipo-beneficio 
          AND int-solicitacao.dt-periodo-ini               = int-cc-benef.dt-periodo-ini 
          AND int-solicitacao.dt-periodo-fim               = int-cc-benef.dt-periodo-fim
          AND NOT int-solicitacao.log-1:

       ASSIGN l-tem-solicitacao = YES.

       CASE  int-solicitacao.SituacaoSolicitacaoBeneficio:
             WHEN  993520008 THEN ASSIGN c-situacao       = "Aprovada"
                                         de-tot-aprovadas = int-solicitacao.ValorSolicitado.
             WHEN  993520003 THEN ASSIGN c-situacao       = "Pendente"
                                         de-pendente      = int-solicitacao.ValorSolicitado.
             WHEN  993520004 THEN ASSIGN c-situacao       = "Paga"
                                         de-pago          = int-solicitacao.ValorSolicitado.
             WHEN  993520006 THEN ASSIGN c-situacao       = "Cancelada".
        END CASE.
       
        ASSIGN da-solicitacao = int-solicitacao.dt-trans
               c-hora         = SUBSTR(int-solicitacao.char-1, 1,8)
               de-solicitado  = int-solicitacao.ValorSolicitado
               de-pendente    = de-tot-pendente
               de-pago        = de-tot-pagas
               de-disponivel  = de-disponivel - (de-pendente - de-pago)
               l-enviado      = int-solicitacao.log-enviada. /* Dispon°vel */
        
        ASSIGN l-tem-itens = NO.
        IF  int-solicitacao.desc-forma-pagto = "Produto" 
        AND NOT int-solicitacao.log-1 THEN
            FOR EACH int-solicitacao-item NO-LOCK
                WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = int-solicitacao.CodigoSolicitacaoBeneficio
                ,FIRST ped-venda NO-LOCK
                    WHERE ped-venda.nome-abrev = int-solicitacao-item.nome-abrev
                      AND ped-venda.nr-pedcli  = int-solicitacao-item.nr-pedcli
                BREAK BY ped-venda.nome-abrev 
                      BY ped-venda.nr-pedcli:

                IF  FIRST-OF (ped-venda.nr-pedcli) THEN DO:
                    ASSIGN c-natureza    = ped-venda.nat-operacao
                           c-sit-ped     = fnSitPedido(ped-venda.cod-sit-ped)
                           c-nr-ped      = ped-venda.nr-pedcli
                           c-user-alte   = ped-venda.user-alte
                           c-user-reat   = ped-venda.user-reat
                           de-liq        = ped-venda.vl-liq-ped
                           de-tot-ped    = ped-venda.vl-tot-ped.
                    RUN pi-imprime-variaveis.
                END.

                
                ASSIGN l-tem-itens = YES.
            END.
    END.

    IF  NOT l-tem-solicitacao THEN DO:
        ASSIGN de-disponivel = de-verba.
        RUN pi-imprime-variaveis.
    END.
END.


PROCEDURE pi-imprime-variaveis:
    EXPORT  DELIMITER ";" i-canal 
                          c-nome-abrev                  
                          c-cgc       
                          c-nome      
                          i-beneficio
                          c-beneficio  
                          c-unidade    
                          c-class      
                          c-categoria  
                          de-custo     
                          de-benef     
                          de-verba  
                          de-disponivel
                          de-origem-tit
                          de-tit      
                          c-situacao
                          da-solicitacao
                          c-hora
                          de-solicitado
                          de-pendente  
                          de-pago      
                          c-sit-ped    
                          c-nr-ped 
                          c-natureza
                          c-user-alte
                          c-user-reat
                          de-liq       
                          de-tot-ped   
                          l-enviado 
                             .
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

