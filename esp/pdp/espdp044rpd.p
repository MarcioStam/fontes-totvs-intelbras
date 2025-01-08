/*----------------------------------------------------------------------
**  Programa..: esp/pdp/espdp044rpd.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Setembro/2010 - Desenvolvimento
**  Descricao.: Integra‡Æo WS Estoque - Ikeda
-----------------------------------------------------------------------*/

create widget-pool.

/*---------------------------  Variaveis    ---------------------------*/
{utp/ut-glob.i}

define variable hWebService   as handle   no-undo.
define variable l-wms-estab-ativo   as logical no-undo.

{esp/pdp/espdp044tt.i}
{esp/pdp/espdp044rpd-tt.i}
{esp/pdp/espdp044sh.i "shared"}
{include/i-freeac.i}

{cdp/cd0666.i}
{esp/pdp/espdp006fn.i}

/*---------------------------  Parƒmetros   ---------------------------*/
define input parameter raw-param as raw no-undo.

DEF BUFFER b-saldo-estoq FOR saldo-estoq.

create tt-param-rpd.
raw-transfer raw-param to tt-param-rpd.
/* ***************************  Main Block  *************************** */
do on stop undo, return error "NOK":
   define variable iStatus       as integer     no-undo.
   define variable cStatus       as character   no-undo.


   find param-global no-lock no-error.
   find mgcad.empresa no-lock
      where mgcad.empresa.ep-codigo = param-global.empresa-pri no-error.
   find first param-b2c no-lock no-error.

   run pi-acompanhar in h-acomp ('Contando estoque do WEX').

   /* ---------------------------------- Saldo do WEX ------------------------------------ */
    DEFINE VARIABLE d-qtde-reservas-ast AS DECIMAL     NO-UNDO.

    FOR EACH estabelec NO-LOCK:

        RUN esp/wmp/eswmpapi006.p( INPUT estabelec.cod-estabel, OUTPUT l-wms-estab-ativo).

        IF  NOT l-wms-estab-ativo THEN
            NEXT.
    
        FOR EACH saldo-estoq NO-LOCK 
          WHERE saldo-estoq.cod-depos  = "WEX" /* Deposito do WMS */
            AND saldo-estoq.cod-estabel = estabelec.cod-estabel /* Provisoriamente somente o 104 utiliza o wex */
            AND saldo-estoq.cod-localiz = ""
            AND saldo-estoq.it-codigo >= tt-param-rpd.it-codigo-ini
            AND saldo-estoq.it-codigo <= tt-param-rpd.it-codigo-fim,
          FIRST item-estab-b2c NO-LOCK 
             WHERE item-estab-b2c.it-codigo   = saldo-estoq.it-codigo
               AND item-estab-b2c.cod-estabel = saldo-estoq.cod-estabel
               AND NOT item-estab-b2c.ind-aceita-saldao,
          FIRST ITEM NO-LOCK 
             WHERE item.it-codigo   = saldo-estoq.it-codigo
               AND item.tipo-contr <> 4:
    
            ASSIGN d-qtde-reservas-ast = 0.
    
            FIND ttSaldo
               WHERE ttSaldo.it-codigo = trim(saldo-estoq.it-codigo) NO-ERROR.
    
            IF  NOT AVAIL ttSaldo THEN DO:
               CREATE ttSaldo.
               ASSIGN ttSaldo.it-codigo = trim(saldo-estoq.it-codigo)
                      ttSaldo.qtde-min  = item-estab-b2c.qt-minima.
            END.
    
            ASSIGN ttSaldo.qtde-dispon = fnEstoque("104", saldo-estoq.it-codigo, "WEX", "", no).
            
            /* Verificar reservas */
         FOR EACH reservas-ast  NO-LOCK
             WHERE reservas-ast.cod-depos   = "WEX"
               AND reservas-ast.it-codigo   = ttSaldo.it-codigo
               AND reservas-ast.cod-estabel = "104"
               AND reservas-ast.dt-reserva <= TODAY:
            IF  reservas-ast.data-limite = ? OR reservas-ast.data-limite >= TODAY THEN
                    ASSIGN d-qtde-reservas-ast = d-qtde-reservas-ast + reservas-ast.qt-reserva.
            END.
        
            /* Descontar as Reservas */
            ASSIGN ttSaldo.qtde-dispon = ttSaldo.qtde-dispon - d-qtde-reservas-ast.
    
            PUT ".1-Atualizou Saldo " item-estab-b2c.it-codigo " " ttSaldo.qtde-dispon SKIP.
    
        END.
    END.
    /*---------------------------------------------------------------------------------------*/

   /** Contando estoque B2C **/
/*    for each saldo-estoq no-lock                                                                                                              */
/*       where saldo-estoq.cod-depos  = "WEX" /* Deposito do WMS */                                                                             */
/*         AND saldo-estoq.cod-estabel = "104" /* Provisoriamente somente o 104 utiliza o wex */                                                */
/*         AND saldo-estoq.cod-localiz = ""                                                                                                     */
/*         and saldo-estoq.it-codigo >= tt-param-rpd.it-codigo-ini                                                                              */
/*         and saldo-estoq.it-codigo <= tt-param-rpd.it-codigo-fim,                                                                             */
/*       first item-estab-b2c no-lock                                                                                                           */
/*          where item-estab-b2c.it-codigo   = saldo-estoq.it-codigo                                                                            */
/*            and item-estab-b2c.cod-estabel = saldo-estoq.cod-estabel                                                                          */
/*            and not item-estab-b2c.ind-aceita-saldao,                                                                                         */
/*       first item no-lock                                                                                                                     */
/*          where item.it-codigo   = saldo-estoq.it-codigo                                                                                      */
/*            and item.tipo-contr <> 4:                                                                                                         */
/*                                                                                                                                              */
/*       find ttSaldo                                                                                                                           */
/*          where ttSaldo.it-codigo = trim(saldo-estoq.it-codigo) no-error.                                                                     */
/*                                                                                                                                              */
/*       if not avail ttSaldo then do:                                                                                                          */
/*          create ttSaldo.                                                                                                                     */
/*          assign ttSaldo.it-codigo = trim(saldo-estoq.it-codigo)                                                                              */
/*                 ttSaldo.qtde-min  = item-estab-b2c.qt-minima.                                                                                */
/*       end.                                                                                                                                   */
/*                                                                                                                                              */
/*       assign ttSaldo.qtde-dispon = saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-prod + saldo-estoq.qt-aloc-ped).  */
/*       PUT "1-Atualizou Saldo " saldo-estoq.it-codigo " " ttSaldo.qtde-dispon SKIP.                                                           */
/*    end.                                                                                                                                      */

   run pi-acompanhar in h-acomp ('Contando estoque do B2C').
   /** Contando estoque B2C **/
   FOR EACH estabelec NO-LOCK:
   
        RUN esp/wmp/eswmpapi006.p( INPUT estabelec.cod-estabel, OUTPUT l-wms-estab-ativo).

        IF  l-wms-estab-ativo THEN
            NEXT.

       for each saldo-estoq no-lock
          where saldo-estoq.cod-depos  = param-b2c.cod-depos
            AND saldo-estoq.cod-estabel = estabelec.cod-estabel /* para outros estabelecimentos que nÆo utilizamo o wms */
            AND saldo-estoq.cod-localiz = ""
            and saldo-estoq.it-codigo >= tt-param-rpd.it-codigo-ini
            and saldo-estoq.it-codigo <= tt-param-rpd.it-codigo-fim,
          first item-estab-b2c no-lock
             where item-estab-b2c.it-codigo   = saldo-estoq.it-codigo
               and item-estab-b2c.cod-estabel = saldo-estoq.cod-estabel
               and not item-estab-b2c.ind-aceita-saldao,
          first item no-lock
             where item.it-codigo   = saldo-estoq.it-codigo
               and item.tipo-contr <> 4:
       
          ASSIGN d-qtde-reservas-ast = 0.
          find ttSaldo
             where ttSaldo.it-codigo = trim(saldo-estoq.it-codigo) no-error.
       
          if not avail ttSaldo then do:
             create ttSaldo.
             assign ttSaldo.it-codigo = trim(saldo-estoq.it-codigo)
                    ttSaldo.qtde-min  = item-estab-b2c.qt-minima.
          end.
       
          /* Verificar reservas */
          FOR EACH reservas-ast  NO-LOCK
              WHERE reservas-ast.cod-depos   = param-b2c.cod-depos
            AND reservas-ast.it-codigo   = ttSaldo.it-codigo
            AND reservas-ast.cod-estabel = saldo-estoq.cod-estabel
            AND reservas-ast.dt-reserva <= TODAY:
            IF  reservas-ast.data-limite = ? OR reservas-ast.data-limite >= TODAY THEN
                ASSIGN d-qtde-reservas-ast = d-qtde-reservas-ast + reservas-ast.qt-reserva.
          END.
    
          assign ttSaldo.qtde-dispon = saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-prod + saldo-estoq.qt-aloc-ped) - d-qtde-reservas-ast.
          PUT "2-Atualizou Saldo " saldo-estoq.it-codigo " " ttSaldo.qtde-dispon SKIP.
       end.
   END.

   run pi-acompanhar in h-acomp ('Contando estoque do SAL').
   /** Contando estoque SAL **/
   for each saldo-estoq no-lock
      where saldo-estoq.cod-depos  = param-b2c.cod-depos-saldao
        AND saldo-estoq.cod-localiz = ""
        and saldo-estoq.it-codigo >= tt-param-rpd.it-codigo-ini
        and saldo-estoq.it-codigo <= tt-param-rpd.it-codigo-fim,
      first item-estab-b2c no-lock
         where item-estab-b2c.it-codigo   = saldo-estoq.it-codigo
           and item-estab-b2c.cod-estabel = saldo-estoq.cod-estabel
           and item-estab-b2c.ind-aceita-saldao,
      first item no-lock
         where item.it-codigo   = saldo-estoq.it-codigo
           and item.tipo-contr <> 4:
   
      ASSIGN d-qtde-reservas-ast = 0.
      find ttSaldo
         where ttSaldo.it-codigo = trim(saldo-estoq.it-codigo) + "S" no-error.
   
      if not avail ttSaldo then do:
         create ttSaldo.
         assign ttSaldo.it-codigo = trim(saldo-estoq.it-codigo) + "S"
                ttSaldo.qtde-min  = item-estab-b2c.qt-minima.
      end.

      /* Verificar reservas */
      FOR EACH reservas-ast  NO-LOCK
          WHERE reservas-ast.cod-depos   = param-b2c.cod-depos-saldao
            AND reservas-ast.it-codigo   = ttSaldo.it-codigo
            AND reservas-ast.cod-estabel = saldo-estoq.cod-estabel:
            IF  reservas-ast.data-limite = ? OR reservas-ast.data-limite >= TODAY THEN
                ASSIGN d-qtde-reservas-ast = d-qtde-reservas-ast + reservas-ast.qt-reserva.
      END.

      assign ttSaldo.qtde-dispon = saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-prod + saldo-estoq.qt-aloc-ped) - d-qtde-reservas-ast.
      PUT "3-Atualizou Saldo " saldo-estoq.it-codigo " " ttSaldo.qtde-dispon SKIP.
   end.

   run pi-acompanhar in h-acomp ('Listando itens sem saldo').

   for each item-estab-b2c no-lock
      where not item-estab-b2c.ind-aceita-saldao
        and item-estab-b2c.it-codigo >= tt-param-rpd.it-codigo-ini
        and item-estab-b2c.it-codigo <= tt-param-rpd.it-codigo-fim
        and not can-find (first saldo-estoq
                          where saldo-estoq.cod-estabel = item-estab-b2c.cod-estabel
                            and saldo-estoq.it-codigo   = item-estab-b2c.it-codigo
                            and saldo-estoq.cod-depos   = param-b2c.cod-depos),
      first item no-lock
         where item.it-codigo   = item-estab-b2c.it-codigo
           and item.tipo-contr <> 4:
      
      find ttSaldo
         where ttSaldo.it-codigo = trim(item-estab-b2c.it-codigo) no-error.
   
      if not avail ttSaldo then do:
         create ttSaldo.
         assign ttSaldo.it-codigo = trim(item-estab-b2c.it-codigo)
                ttSaldo.qtde-min  = item-estab-b2c.qt-minima.
         assign ttSaldo.qtde-dispon = 0.
         PUT "4-Atualizou Saldo " ttSaldo.it-codigo " " ttSaldo.qtde-dispon SKIP.
      end.
      RUN VerSaldoFilho.

   end.

   for each item-estab-b2c no-lock
      where item-estab-b2c.ind-aceita-saldao
        and item-estab-b2c.it-codigo >= tt-param-rpd.it-codigo-ini
        and item-estab-b2c.it-codigo <= tt-param-rpd.it-codigo-fim
        and not can-find (first saldo-estoq
                          where saldo-estoq.cod-estabel = item-estab-b2c.cod-estabel
                            and saldo-estoq.it-codigo   = item-estab-b2c.it-codigo
                            and saldo-estoq.cod-depos   = param-b2c.cod-depos-saldao),
      first item no-lock
         where item.it-codigo   = item-estab-b2c.it-codigo
           and item.tipo-contr <> 4:
      
      find ttSaldo
         where ttSaldo.it-codigo = trim(item-estab-b2c.it-codigo) + "S" no-error.
   
      if not avail ttSaldo then do:
         create ttSaldo.
         assign ttSaldo.it-codigo = trim(item-estab-b2c.it-codigo) + "S"
                ttSaldo.qtde-min  = item-estab-b2c.qt-minima.
         assign ttSaldo.qtde-dispon = 0.
         PUT "5-Atualizou Saldo " ttSaldo.it-codigo " " ttSaldo.qtde-dispon SKIP.
      end.
   
      
      RUN VerSaldoFilho.
   end.

   run pi-acompanhar in h-acomp ('Atualizando estoque no site').

   /** Execu‡Æo do WS para atualizar inforam‡äes na Ikeda **/
   run esp/pdp/espdp044rpd-ws.p persistent set hWebService.
   run conecta in hWebService (output iStatus, output cStatus).

   if (iStatus <> 1) then
      run incluiMsgErro in this-procedure ('Erro ao conectar na Ikeda').
   else do:
      for each ttSaldo:
         run pi-acompanhar in h-acomp ('Atualizando o Saldo do item ' + ttSaldo.it-codigo).

         run alterarProdutoCodigoInterno in hWebService (ttSaldo.it-codigo, ttSaldo.qtde-dispon, ttSaldo.qtde-min, output iStatus, output cStatus, output table ttEstoque).
         if (iStatus <> 1) and not (cStatus matches 'Codigo Interno*n*o encontrado') then
            run incluiMsgErro in this-procedure ('Erro ao atualizar o saldo do item ' + ttSaldo.it-codigo + ': ' + cStatus).
      end.
   end.

   run desconecta in hWebService.
   delete object hWebService.

   return "OK".
end.

procedure incluiMsgErro:
   define input parameter pcDescErro as character no-undo.

   define variable iNextMsg as integer no-undo.

   find last MsgErro no-lock no-error.
   if available MsgErro then
      assign iNextMsg = MsgErro.SeqErro + 1.
   else
      assign iNextMsg = 1.

   create MsgErro.
   assign MsgErro.SeqErro  = iNextMsg
          MsgErro.DescErro = pcDescErro.
end procedure.

PROCEDURE VerSaldoFilho:
    DEFINE VARIABLE de-qtde-dispon AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE l-inicio       AS LOGICAL     NO-UNDO.
    ASSIGN l-inicio = YES.
    IF item-estab-b2c.lg-saldo-componente THEN DO:
        FOR EACH prod-composto
            WHERE prod-composto.it-codigo-pai = item-estab-b2c.it-codigo NO-LOCK,
            EACH b-saldo-estoq
            where b-saldo-estoq.cod-estabel = item-estab-b2c.cod-estabel
              and b-saldo-estoq.it-codigo   = prod-composto.it-codigo-filho
              and b-saldo-estoq.cod-depos   = param-b2c.cod-depos 
              AND b-saldo-estoq.cod-localiz = "" NO-LOCK:

            ASSIGN d-qtde-reservas-ast = 0.

            /* Verificar reservas */
            FOR EACH reservas-ast  NO-LOCK
                WHERE reservas-ast.cod-depos   = b-saldo-estoq.cod-depos
                  AND reservas-ast.it-codigo   = item-estab-b2c.it-codigo
                  AND reservas-ast.cod-estabel = b-saldo-estoq.cod-estabel:
                  IF  reservas-ast.data-limite = ? OR reservas-ast.data-limite >= TODAY THEN
                      ASSIGN d-qtde-reservas-ast = d-qtde-reservas-ast + reservas-ast.qt-reserva.
            END.

            ASSIGN de-qtde-dispon = b-saldo-estoq.qtidade-atu - (b-saldo-estoq.qt-alocada + b-saldo-estoq.qt-aloc-prod + b-saldo-estoq.qt-aloc-ped) - d-qtde-reservas-ast.
            IF l-inicio = YES THEN
                ASSIGN ttSaldo.qtde-dispon = de-qtde-dispon
                       l-inicio            = NO.
            ELSE
                IF de-qtde-dispon < ttSaldo.qtde-dispon THEN
                   ASSIGN ttSaldo.qtde-dispon = de-qtde-dispon.



        END.

    END.

END PROCEDURE.
