DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESFTP028 2.06.00.001}

{utp/ut-glob.i}
{include/i-rpvar.i}

{esp/ftp/esftp028.i}
   
define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

define variable h-acomp      as handle no-undo.
DEFINE VARIABLE c-arquivo    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-linha AS CHARACTER   NO-UNDO.

function fn-segmento returns character
  ( p-fm-cod-com as character )  forward.

function fn-unid-negoc returns character
  ( p-fm-cod-com as character )  forward.

find param-global no-lock.
find mgcad.empresa no-lock
   where mgcad.empresa.ep-codigo = param-global.empresa-pri.

create tt-param.
raw-transfer raw-param to tt-param.

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Atualizaá∆o do faturamento"
       c-empresa      = if avail mgcad.empresa then mgcad.empresa.razao-social else ''.

define temp-table tt-unid no-undo
   field cod_unid_negoc like unid-neg-fat.cod_unid_negoc
   field perc-unid-neg  like unid-neg-fat.perc-unid-neg
   index ch-cod is primary unique cod_unid_negoc.

define temp-table tt-fat no-undo like faturamento.

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    
    {include/i-rpout.i}

    run utp/ut-acomp.p persistent set h-acomp.  

    run pi-inicializar in h-acomp (input "Imprimindo...").

    
    run piMontaRelat.

    run pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    return "OK".
end.

/* Limpa faturamento caso n∆o existe na tabela faturamento-segmento-ordem */
for each faturamento EXCLUSIVE-LOCK
   where faturamento.periodo = string(year(today), "9999") + string(month(today), "99"):
    FIND  faturamento-segmento-ordem 
        WHERE faturamento-segmento-ordem.unid-neg = faturamento.unid-neg
          AND faturamento-segmento-ordem.segmento = faturamento.segmento
        NO-LOCK NO-ERROR.
    IF NOT AVAIL faturamento-segmento-ordem THEN DO:
        DELETE faturamento.
    END.
END.

procedure piMontaRelat:
   define variable dt-inicial as date      no-undo.
   define variable dt-final   as date      no-undo.
   define variable dt-data    as date      no-undo.
   define variable c-unid-neg as character no-undo format 'x(3)'.
   define variable de-perc    as decimal   no-undo.
   define variable de-alocado as decimal   no-undo.
   define variable d-cotacao  as decimal   no-undo.

   DEFINE VARIABLE c-unid-negoc AS CHARACTER FORMAT "x(90)"  NO-UNDO.
   DEFINE VARIABLE c-segmento   AS CHARACTER FORMAT "x(90)"  NO-UNDO.
   DEFINE VARIABLE i-GrpCanais  AS INTEGER     NO-UNDO.
   
   assign dt-inicial = date(month(today), 1, year(today)).
   if (day(today) <= 3) then
      assign dt-inicial = add-interval(dt-inicial, -1, 'months').

   assign dt-final = date(month(today), 1, year(today))
          dt-final = add-interval(dt-final, 1, 'months') - 1.

   /** faturamento **/
   

   PUT " Data ;"
       " Nota  ;"
       " Serie ;"
       " Estab ;"
       " Familia ;"
       " Valor Mercadoria ;"
       " Unid Negocio ; Segmento"
             SKIP.
   do dt-data = dt-inicial to dt-final:
      for each nota-fiscal no-lock use-index ch-distancia
          where nota-fiscal.dt-emis-nota  = dt-data
            and nota-fiscal.dt-cancel     = ?,
         first natur-oper no-lock
            where natur-oper.nat-operacao = nota-fiscal.nat-operacao
              and natur-oper.atual-estat,
         first emitente no-lock
            where emitente.cod-emitente = nota-fiscal.cod-emitente,
         each it-nota-fisc of nota-fiscal no-lock,
         first item of it-nota-fisc no-lock:

         /*Chamado 71552*/
         IF nota-fiscal.serie = "R2" THEN
              NEXT.
   
         ASSIGN c-unid-negoc = fn-unid-negoc(item.fm-cod-com).

         FIND FIRST ped-venda 
             WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
               AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli  NO-LOCK NO-ERROR.
         IF AVAIL ped-venda THEN DO:
             FIND FIRST int-ped-venda2
                 WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
                   AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido  NO-LOCK NO-ERROR.
             IF AVAIL int-ped-venda2 AND int-ped-venda2.int-1 <> 0 THEN
                 ASSIGN i-grpcanais = int-ped-venda2.int-1.
             ELSE DO:
                 FIND FIRST grupo-canais-clientes
                     WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
                 IF AVAIL grupo-canais-clientes THEN
                     ASSIGN i-grpcanais = grupo-canais-clientes.cod-gr-canais.
             END.
         END. /* IF AVAIL ped-venda THEN DO: */
         ELSE DO:
             FIND FIRST grupo-canais-clientes
                 WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
             IF AVAIL grupo-canais-clientes THEN
                 ASSIGN i-grpcanais = grupo-canais-clientes.cod-gr-canais.
         END.
         
         ASSIGN c-segmento   = fn-segmento(item.fm-cod-com).

         /** Chamado 61441 **/
         if item.it-codigo eq '4143002' OR
            item.it-codigo eq '9900154' then
            assign c-segmento = 'Conversor Digital (CD901)'.

         /** Solicitado pelo Sr. Rafael - Separar exportaá∆o **/
	     /** Chamado 61441 - Tirar a exportaá∆o, deixar s¢ o MÇxico isolado **/
		 /*if emitente.natureza > 2 then /** Considera exportaá∆o e trading **/
            assign c-segmento   = 'Outros Paises'
                   c-unid-negoc = 'EXPORT'.*/
         if nota-fiscal.cod-emitente = 105068 then
            assign c-unid-negoc = 'TRANSF MEX'
                   c-segmento   = 'Transferencia Mexico'.

         /***** Segmento ***/
         if c-segmento begins 'Partes e Pecas' then do:
            IF c-unid-negoc = "INOV" THEN
                ASSIGN c-segmento  = "Acess¢rios".
            ELSE if c-unid-negoc = 'ICORP' then
               assign c-segmento = "Pequenas e Medias centrais".
            else if c-unid-negoc = 'ICON' then
               assign c-segmento = "Telefone sem fio".
            else if c-unid-negoc = 'ISEC' then
               assign c-segmento = "Gerenciamento de imagem".
            else if c-unid-negoc = 'INET' then
               assign c-segmento = "Banda larga sem fio".
/*             else if c-unid-negoc = 'IFIRE' then          */
/*                assign c-segmento = "Alarme de Incàndio". */
            else if c-unid-negoc = 'ISEC/MG' then
               assign c-segmento = "Alarmes".
/*             else if c-unid-negoc = 'IAUT' then                  */
/*                assign c-segmento = "Fechadura".                 */
/*             else IF c-unid-negoc = 'IACCS' then                 */
/*                assign c-segmento = "Conversores e Perifericos". */
            /* Alterado em 31/01/2014 - adicionado IFIRE solicitado pela usu†ria Juliana (Controladoria) */
         end.
         /** Chamado 61441 **/
         if c-segmento = "Redes Wireless Indoor" or c-segmento = "Banda larga sem fio" then
            assign c-segmento = "Redes Wireless PRO".
         IF c-segmento = "Telefone Fixo GSM" THEN
              assign c-segmento = "Acessorios de TV".
         /***** Segmento ***/

         /* com grupo canais */
         IF i-grpcanais <> 0 THEN DO:
             find tt-fat
                where tt-fat.periodo        = string(year(nota-fiscal.dt-emis-nota),"9999") + string(month(nota-fiscal.dt-emis-nota),"99")
                  AND tt-fat.cod-gr-canais  = i-grpcanais
                  and tt-fat.unid-neg       = c-unid-negoc
                  and tt-fat.segmento       = c-segmento no-error.
             if not available tt-fat then do:
                create tt-fat.
                assign tt-fat.periodo       = string(year(nota-fiscal.dt-emis-nota),"9999") + string(month(nota-fiscal.dt-emis-nota),"99")
                       tt-fat.cod-gr-canais = i-grpcanais
                       tt-fat.unid-neg      = c-unid-negoc
                       tt-fat.segmento      = c-segmento.
             end.

             assign tt-fat.vl-fat-real = tt-fat.vl-fat-real + it-nota-fisc.vl-merc-liq + it-nota-fisc.vl-despes-it.

             PUT nota-fiscal.dt-emis-nota   ";"
                 nota-fiscal.nr-nota-fis    ";"
                 nota-fiscal.serie          ";"
                 nota-fiscal.cod-estabel    ";"
                 ITEM.fm-cod-com            ";"
                 it-nota-fisc.vl-merc-liq   ";"
                 i-grpcanais                ";"  
                 c-unid-negoc               ";"
                 c-segmento                 ";"  
                 SKIP.
         END.

         /* sem grupo canais */
         find tt-fat
            where tt-fat.periodo        = string(year(nota-fiscal.dt-emis-nota),"9999") + string(month(nota-fiscal.dt-emis-nota),"99")
              AND tt-fat.cod-gr-canais  = 0
              and tt-fat.unid-neg       = c-unid-negoc
              and tt-fat.segmento       = c-segmento no-error.
         if not available tt-fat then do:
            create tt-fat.
            assign tt-fat.periodo       = string(year(nota-fiscal.dt-emis-nota),"9999") + string(month(nota-fiscal.dt-emis-nota),"99")
                   tt-fat.cod-gr-canais = 0
                   tt-fat.unid-neg      = c-unid-negoc
                   tt-fat.segmento      = c-segmento.
         end.
   
         assign tt-fat.vl-fat-real = tt-fat.vl-fat-real + it-nota-fisc.vl-merc-liq + it-nota-fisc.vl-despes-it.

         PUT nota-fiscal.dt-emis-nota   ";"
             nota-fiscal.nr-nota-fis    ";"
             nota-fiscal.serie          ";"
             nota-fiscal.cod-estabel    ";"
             ITEM.fm-cod-com            ";"
             it-nota-fisc.vl-merc-liq   ";"
             0                          ";"  
             c-unid-negoc               ";"
             c-segmento                 ";"  
             SKIP.


      end.
   end.
      
   /** CARTEIRA **/
   /** SOS 33336 - ∑ pedido do Sr. Altair, a carteira n∆o Ç mais atualizada automaticamente, pois ele quer ver
                   o mesmo valor que o Luciano calcula no Excel **/
   /** SOS 36478 - Devido Ö grande divergància detectada no dia 25.10, a l¢gica deve
                   ser executada novamente, para evitar problemas futuros **/
   /** Tratamento quanto a atendente, onde a mesma tem que ter marcado como acesso restrito **/

   put "Pedido ; Item ;Sequencia Item; Prioridade ; carteira ; faturado ; Pendente ; Canais ; unid negoc ; segmento ; periodo" skip.

   for each ped-venda no-lock
      where (ped-venda.cod-sit-ped = 1
          or ped-venda.cod-sit-ped = 2
          or ped-venda.cod-sit-ped = 5),
      first natur-oper no-lock
         where natur-oper.nat-operacao = ped-venda.nat-operacao
           and natur-oper.atual-estat,
      first emitente no-lock
         where emitente.nome-abrev = ped-venda.nome-abrev,
      FIRST atendente NO-LOCK
             WHERE atendente.cd-oper                        = int(ped-venda.tp-pedido)
               AND atendente.ind-considera-acesso-restrito  = YES,
      each ped-item no-lock
         where (ped-item.nome-abrev   = ped-venda.nome-abrev
           and  ped-item.nr-pedcli    = ped-venda.nr-pedcli 
           and  ped-item.ind-componen = 1 
           and  ped-item.cod-sit-item = 1
           and  ped-item.dt-entrega  <= dt-final + 1)
            or (ped-item.nome-abrev   = ped-venda.nome-abrev
           and  ped-item.nr-pedcli    = ped-venda.nr-pedcli 
           and  ped-item.ind-componen = 1 
           and  ped-item.cod-sit-item = 2
           and  ped-item.dt-entrega  <= dt-final + 1)
            or (ped-item.nome-abrev   = ped-venda.nome-abrev
           and  ped-item.nr-pedcli    = ped-venda.nr-pedcli 
           and  ped-item.ind-componen = 1 
           and  ped-item.cod-sit-item = 5
           and  ped-item.dt-entrega   <= dt-final + 1),
      first item no-lock
         where item.it-codigo = ped-item.it-codigo:
       
       /** Ignora oráamentos **/
      if  ped-venda.cod-priori = 44 then
          next.
   
      IF  ped-venda.cod-sit-aval = 4 THEN  /* pedidos reprovados que deverao ser considerados no acesso restrito */
          IF  ped-venda.quem-aprovou  <> "Sistema" THEN NEXT. /* Reprovados pelo sistema e que estejam dentro do mes ou mes inferior */
          ELSE
              IF ped-item.dt-entrega > dt-final THEN NEXT.
       
      assign de-alocado = 0.
   
      find cotacao no-lock
         where cotacao.mo-codigo   = ped-venda.mo-codigo
           and cotacao.ano-periodo = string(year(today), "9999") + string(month(today), "99") no-error.
      if available (cotacao) and (cotacao.cotacao[day(today)] <> 0) then
         assign d-cotacao = cotacao.cotacao[day(today)].
      else
         assign d-cotacao = 1.

      ASSIGN c-unid-negoc = fn-unid-negoc(item.fm-cod-com)
             c-segmento   = fn-segmento(item.fm-cod-com).
   
      FIND FIRST int-ped-venda2
          WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
            AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido  NO-LOCK NO-ERROR.
      IF AVAIL int-ped-venda2 AND int-ped-venda2.int-1 <> 0 THEN
          ASSIGN i-grpcanais = int-ped-venda2.int-1.
      ELSE DO:
          FIND FIRST grupo-canais-clientes
              WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
          IF AVAIL grupo-canais-clientes THEN
              ASSIGN i-grpcanais = grupo-canais-clientes.cod-gr-canais.
      END.

      IF i-grpcanais = 0 THEN NEXT.                      
/*           ASSIGN i-grpcanais = emitente.cod-gr-cli. */

      /** Chamado 61441 **/
      if item.it-codigo eq '4143002' OR
         item.it-codigo eq '9900154' then
         assign c-segmento = 'Conversor Digital (CD901)'.

      /** Solicitado pelo Sr. Rafael - Separar exportaá∆o **/
	  /** Chamado 61441 - Tirar a exportaá∆o, deixar s¢ o MÇxico isolado **/
      /*if emitente.natureza > 2 then /** Considera exportaá∆o e trading **/
         assign c-segmento   = 'Outros Paises'
                c-unid-negoc = 'EXPORT'.*/
      if ped-venda.cod-emitente = 105068 then
         assign c-unid-negoc = 'TRANSF MEX'
                c-segmento   = 'Transferencia Mexico'.

      /***** Segmento ***/
      if c-segmento begins 'Partes e Pecas' then do:
         if c-unid-negoc = 'ICORP' then
            assign c-segmento = "Pequenas e Medias centrais".
         else if c-unid-negoc = 'ICON' then
            assign c-segmento = "Telefone sem fio".
         else if c-unid-negoc = 'ISEC' then
            assign c-segmento = "Gerenciamento de imagem".
         else if c-unid-negoc = 'INET' then
            assign c-segmento = "Banda larga sem fio".
/*          else if c-unid-negoc = 'IFIRE' then          */
/*             assign c-segmento = "Alarme de Incàndio". */
         else if c-unid-negoc = 'ISEC/MG' then
            assign c-segmento = "Alarmes".
/*          else if c-unid-negoc = 'IAUT' then                  */
/*             assign c-segmento = "Fechadura".                 */
/*          else IF c-unid-negoc = 'IACCS' then                 */
/*             assign c-segmento = "Conversores e Perifericos". */
         /* Alterado em 31/01/2014 - adicionado IFIRE solicitado pela usu†ria Juliana (Controladoria) */
      end.
      /** Chamado 61441 **/
       IF c-segmento = "Telefone Fixo GSM" THEN
            assign c-segmento = "Acessorios de TV".
      if c-segmento = "Redes Wireless Indoor" or c-segmento = "Banda larga sem fio" then
         assign c-segmento = "Redes Wireless PRO".
      /***** Segmento ***/

      /* com grupo canais */
      find tt-fat
         where tt-fat.periodo       = string(year(today),"9999") + string(month(today),"99")
           AND tt-fat.cod-gr-canais = i-grpcanais
           and tt-fat.unid-neg      = c-unid-negoc
           and tt-fat.segmento      = c-segmento no-error.
      if not available tt-fat then do:
         create tt-fat.
         assign tt-fat.periodo       = string(year(today),"9999") + string(month(today),"99")
                tt-fat.cod-gr-canais = i-grpcanais
                tt-fat.unid-neg      = c-unid-negoc
                tt-fat.segmento      = c-segmento.
      end.
   
      if (ped-venda.cod-priori = 10 AND
         (ped-item.qt-alocada + ped-item.qt-log-aloca) > 0) then
         assign de-alocado = ped-item.vl-preuni * (ped-item.qt-alocada + ped-item.qt-log-aloca - ped-item.qt-atendida).
      else
         assign de-alocado = 0.
   
      if (ped-item.dt-entrega = dt-final + 1) then
         assign tt-fat.vl-pendente = tt-fat.vl-pendente + ped-item.vl-merc-abe * d-cotacao.
      else do:
         if (ped-venda.cod-priori = 10 AND
             (ped-item.qt-alocada + ped-item.qt-log-aloca) > 0) then
            assign tt-fat.vl-fat-real = tt-fat.vl-fat-real + de-alocado * d-cotacao
                   tt-fat.vl-cart     = tt-fat.vl-cart + (ped-item.vl-merc-abe - de-alocado) * d-cotacao.
         else
            assign tt-fat.vl-cart = tt-fat.vl-cart + (ped-item.vl-merc-abe - de-alocado) * d-cotacao.
      end.

      /* */
      /* sem grupo canais */

      find tt-fat
         where tt-fat.periodo       = string(year(today),"9999") + string(month(today),"99")
           AND tt-fat.cod-gr-canais = 0
           and tt-fat.unid-neg      = c-unid-negoc
           and tt-fat.segmento      = c-segmento no-error.
      if not available tt-fat then do:
         create tt-fat.
         assign tt-fat.periodo       = string(year(today),"9999") + string(month(today),"99")
                tt-fat.cod-gr-canais = 0
                tt-fat.unid-neg      = c-unid-negoc
                tt-fat.segmento      = c-segmento.
      end.   
   
      if (ped-item.dt-entrega = dt-final + 1) then
         assign tt-fat.vl-pendente = tt-fat.vl-pendente + ped-item.vl-merc-abe * d-cotacao.
      else do:
         if (ped-venda.cod-priori = 10 AND
             (ped-item.qt-alocada + ped-item.qt-log-aloca) > 0) then
            assign tt-fat.vl-fat-real = tt-fat.vl-fat-real + de-alocado * d-cotacao
                   tt-fat.vl-cart     = tt-fat.vl-cart + (ped-item.vl-merc-abe - de-alocado) * d-cotacao.
         else
            assign tt-fat.vl-cart = tt-fat.vl-cart + (ped-item.vl-merc-abe - de-alocado) * d-cotacao.
      end.
      /* */
	  put ped-item.nr-pedcli ";" ped-item.it-codigo ";" ped-item.nr-sequencia ";" ped-venda.cod-priori  ";" .

      if (ped-item.dt-entrega = dt-final + 1) then
          put 	0 ";" 0 ";" ped-item.vl-merc-abe * d-cotacao ";".
        
      else 
          if ped-venda.cod-priori = 10 AND
              de-alocado > 0           then
              put 	(ped-item.vl-merc-abe - de-alocado) * d-cotacao ";" de-alocado * d-cotacao ";" 0 ";".
          else 
              put 	(ped-item.vl-merc-abe - de-alocado) * d-cotacao ";" 0 ";" 0 ";".

      PUT string(i-grpcanais) ";" c-unid-negoc ";" c-segmento ";" string(tt-fat.periodo) " " string(ped-item.dt-entrega) skip.


      /* Impress∆o para Canal zero */
	  put ped-item.nr-pedcli ";" ped-item.it-codigo ";" ped-item.nr-sequencia ";" ped-venda.cod-priori  ";" .

      if (ped-item.dt-entrega = dt-final + 1) then
	      put 	0 ";" 0 ";" ped-item.vl-merc-abe * d-cotacao ";".
        
      else 
          if ped-venda.cod-priori = 10 AND
              de-alocado > 0           then
              put 	(ped-item.vl-merc-abe - de-alocado) * d-cotacao ";" de-alocado * d-cotacao ";" 0 ";".
          else 
              put 	(ped-item.vl-merc-abe - de-alocado) * d-cotacao ";" 0 ";" 0 ";".

      PUT "0;" c-unid-negoc ";" c-segmento ";" string(tt-fat.periodo) " " string(ped-item.dt-entrega) skip.

      
   end. /* for each ped-venda no-lock */

   /**************************************************
   for each ped-venda no-lock
      where (ped-venda.cod-sit-ped = 1
          or ped-venda.cod-sit-ped = 2
          or ped-venda.cod-sit-ped = 5),
      first natur-oper no-lock
         where natur-oper.nat-operacao = ped-venda.nat-operacao
           and natur-oper.atual-estat,
      first emitente no-lock
         where emitente.nome-abrev = ped-venda.nome-abrev,
      FIRST atendente
             WHERE atendente.cd-oper                        = int(ped-venda.tp-pedido)
               AND atendente.ind-considera-acesso-restrito  = YES,
      each ped-item no-lock
         where (ped-item.nome-abrev   = ped-venda.nome-abrev
           and  ped-item.nr-pedcli    = ped-venda.nr-pedcli 
           and  ped-item.ind-componen = 1 
           and  ped-item.cod-sit-item = 1
           and  ped-item.dt-entrega  <= dt-final + 1)
            or (ped-item.nome-abrev   = ped-venda.nome-abrev
           and  ped-item.nr-pedcli    = ped-venda.nr-pedcli 
           and  ped-item.ind-componen = 1 
           and  ped-item.cod-sit-item = 2
           and  ped-item.dt-entrega  <= dt-final + 1)
            or (ped-item.nome-abrev   = ped-venda.nome-abrev
           and  ped-item.nr-pedcli    = ped-venda.nr-pedcli 
           and  ped-item.ind-componen = 1 
           and  ped-item.cod-sit-item = 5
           and  ped-item.dt-entrega   <= dt-final + 1),
      first item no-lock
         where item.it-codigo = ped-item.it-codigo:
       
       /** Ignora oráamentos **/
      if  ped-venda.cod-priori = 44 then
          next.
   
      IF  ped-venda.cod-sit-aval = 4 THEN  /* pedidos reprovados que deverao ser considerados no acesso restrito */
          IF  ped-venda.quem-aprovou  <> "Sistema" THEN NEXT. /* Reprovados pelo sistema e que estejam dentro do mes ou mes inferior */
          ELSE
              IF ped-item.dt-entrega > dt-final THEN NEXT.
       
      assign de-alocado = 0.
   
      find cotacao no-lock
         where cotacao.mo-codigo   = ped-venda.mo-codigo
           and cotacao.ano-periodo = string(year(today), "9999") + string(month(today), "99") no-error.
      if available (cotacao) and (cotacao.cotacao[day(today)] <> 0) then
         assign d-cotacao = cotacao.cotacao[day(today)].
      else
         assign d-cotacao = 1.

      ASSIGN c-unid-negoc = fn-unid-negoc(item.fm-cod-com)
             c-segmento   = fn-segmento(item.fm-cod-com).
   
      FIND FIRST int-ped-venda2
          WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
            AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido  NO-LOCK NO-ERROR.
      IF AVAIL int-ped-venda2 AND int-ped-venda2.int-1 <> 0 THEN
          ASSIGN i-grpcanais = int-ped-venda2.int-1.
      ELSE DO:
          FIND FIRST grupo-canais-clientes
              WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
          IF AVAIL grupo-canais-clientes THEN
              ASSIGN i-grpcanais = grupo-canais-clientes.cod-gr-canais.
      END.

/*       IF i-grpcanais = 0 THEN                       */
/*           ASSIGN i-grpcanais = emitente.cod-gr-cli. */

      /** Chamado 61441 **/
      if item.it-codigo eq '4143002' then
         assign c-segmento = 'Conversor Digital (CD901)'.

      /** Solicitado pelo Sr. Rafael - Separar exportaá∆o **/
	  /** Chamado 61441 - Tirar a exportaá∆o, deixar s¢ o MÇxico isolado **/
      /*if emitente.natureza > 2 then /** Considera exportaá∆o e trading **/
         assign c-segmento   = 'Outros Paises'
                c-unid-negoc = 'EXPORT'.*/
      if ped-venda.cod-emitente = 105068 then
         assign c-unid-negoc = 'TRANSF MEX'
                c-segmento   = 'Transferencia Mexico'.

      /***** Segmento ***/
      if c-segmento begins 'Partes e Pecas' then do:
         if c-unid-negoc = 'ICORP' then
            assign c-segmento = "Pequenas e Medias centrais".
         else if c-unid-negoc = 'ICON' then
            assign c-segmento = "Telefone sem fio".
         else if c-unid-negoc = 'ISEC' then
            assign c-segmento = "Gerenciamento de imagem".
         else if c-unid-negoc = 'INET' then
            assign c-segmento = "Banda larga sem fio".
/*          else if c-unid-negoc = 'IFIRE' then          */
/*             assign c-segmento = "Alarme de Incàndio". */
         else if c-unid-negoc = 'ISEC/MG' then
            assign c-segmento = "Alarmes".
/*          else if c-unid-negoc = 'IAUT' then                  */
/*             assign c-segmento = "Fechadura".                 */
/*          else IF c-unid-negoc = 'IACCS' then                 */
/*             assign c-segmento = "Conversores e Perifericos". */
         /* Alterado em 31/01/2014 - adicionado IFIRE solicitado pela usu†ria Juliana (Controladoria) */
      end.
      /** Chamado 61441 **/
      if c-segmento = "Redes Wireless Indoor" or c-segmento = "Banda larga sem fio" then
         assign c-segmento = "Redes Wireless PRO".
      /***** Segmento ***/

      /* sem grupo canais */

      find tt-fat
         where tt-fat.periodo       = string(year(today),"9999") + string(month(today),"99")
           AND tt-fat.cod-gr-canais = 0
           and tt-fat.unid-neg      = c-unid-negoc
           and tt-fat.segmento      = c-segmento no-error.
      if not available tt-fat then do:
         create tt-fat.
         assign tt-fat.periodo       = string(year(today),"9999") + string(month(today),"99")
                tt-fat.cod-gr-canais = 0
                tt-fat.unid-neg      = c-unid-negoc
                tt-fat.segmento      = c-segmento.
      end.   
      if (ped-venda.cod-priori = 10 AND
         (ped-item.qt-alocada + ped-item.qt-log-aloca) > 0) then
         assign de-alocado = ped-item.vl-preuni * (ped-item.qt-alocada + ped-item.qt-log-aloca - ped-item.qt-atendida).
      else
         assign de-alocado = 0.
   
      if (ped-item.dt-entrega = dt-final + 1) then
         assign tt-fat.vl-pendente = tt-fat.vl-pendente + ped-item.vl-merc-abe * d-cotacao.
      else do:
         if (ped-venda.cod-priori = 10 AND
             (ped-item.qt-alocada + ped-item.qt-log-aloca) > 0) then
            assign tt-fat.vl-fat-real = tt-fat.vl-fat-real + de-alocado * d-cotacao
                   tt-fat.vl-cart     = tt-fat.vl-cart + (ped-item.vl-merc-abe - de-alocado) * d-cotacao.
         else
            assign tt-fat.vl-cart = tt-fat.vl-cart + (ped-item.vl-merc-abe - de-alocado) * d-cotacao.
      end.

	  put ped-item.nr-pedcli ";" ped-item.it-codigo ";" ped-item.nr-sequencia ";" ped-venda.cod-priori  ";" .

      if (ped-item.dt-entrega = dt-final + 1) then
	      put 	0 ";" 0 ";" ped-item.vl-merc-abe * d-cotacao ";".
        
      else 
          if ped-venda.cod-priori = 10 AND
              de-alocado > 0           then
              put 	(ped-item.vl-merc-abe - de-alocado) * d-cotacao ";" de-alocado * d-cotacao ";" 0 ";".
          else 
              put 	(ped-item.vl-merc-abe - de-alocado) * d-cotacao ";" 0 ";" 0 ";".

      PUT string(0) ";" c-unid-negoc ";" c-segmento ";" string(tt-fat.periodo) " " string(ped-item.dt-entrega) skip.


   end. /* for each ped-venda no-lock */
*/
   /**************************************************/
      PUT " Devoluá∆o  ;"
       " Serie ;"
       " Estab ;"
       " Familia ;"
       " Valor Mercadoria ;"
       " Grupo Canais;"
       " Unid Negocio ;"
       " Segmento;"
             SKIP.
   
   /** DEVOLUCAO **/
   for each devol-cli no-lock
      where devol-cli.dt-devol >= dt-inicial
        and devol-cli.dt-devol <= dt-final,
      first nota-fiscal no-lock
         where nota-fiscal.cod-estabel = devol-cli.cod-estabel
           and nota-fiscal.serie       = devol-cli.serie
           and nota-fiscal.nr-nota-fis = devol-cli.nr-nota-fis,
      first natur-oper no-lock
         where natur-oper.nat-operacao = nota-fiscal.nat-operacao
           and natur-oper.atual-estat,
      first emitente no-lock
         where emitente.cod-emitente = nota-fiscal.cod-emitente,
      each item-doc-est of devol-cli no-lock,
      first it-nota-fisc no-lock
         where it-nota-fisc.cod-estabel = devol-cli.cod-estabel
           and it-nota-fisc.serie       = devol-cli.serie
           and it-nota-fisc.nr-nota-fis = devol-cli.nr-nota-fis
           and it-nota-fisc.it-codigo   = devol-cli.it-codigo
           and it-nota-fisc.nr-seq-fat  = devol-cli.nr-sequencia,
      first item no-lock
          where item.it-codigo = devol-cli.it-codigo:

      ASSIGN c-unid-negoc = fn-unid-negoc(item.fm-cod-com)
             c-segmento   = fn-segmento(item.fm-cod-com).

      /** Chamado 61441 **/
      if item.it-codigo eq '4143002' then
         assign c-segmento = 'Conversor Digital (CD901)'.
			 
      /** Solicitado pelo Sr. Rafael - Separar exportaá∆o **/
	  /** Chamado 61441 - Tirar a exportaá∆o, deixar s¢ o MÇxico isolado **/
      /*if emitente.natureza > 2 then /** Considera exportaá∆o e trading **/
         assign c-segmento   = 'Outros Paises'
                c-unid-negoc = 'EXPORT'.*/
      if nota-fiscal.cod-emitente = 105068 then
         assign c-unid-negoc = 'TRANSF MEX'
                c-segmento   = 'Transferencia Mexico'.

      /***** Segmento ***/
      if c-segmento begins 'Partes e Pecas' then do:
         if c-unid-negoc = 'ICORP' then
            assign c-segmento = "Pequenas e Medias centrais".
         else if c-unid-negoc = 'ICON' then
            assign c-segmento = "Telefone sem fio".
         else if c-unid-negoc = 'ISEC' then
            assign c-segmento = "Gerenciamento de imagem".
         else if c-unid-negoc = 'INET' then
            assign c-segmento = "Banda larga sem fio".
/*          else if c-unid-negoc = 'IFIRE' then          */
/*             assign c-segmento = "Alarme de Incàndio". */
         else if c-unid-negoc = 'ISEC/MG' then
            assign c-segmento = "Alarmes".
/*          else if c-unid-negoc = 'IAUT' then                  */
/*             assign c-segmento = "Fechadura".                 */
/*          else IF c-unid-negoc = 'IACCS' then                 */
/*             assign c-segmento = "Conversores e Perifericos". */
         /* Alterado em 31/01/2014 - adicionado IFIRE solicitado pela usu†ria Juliana (Controladoria) */
      end.
      /** Chamado 61441 **/
       IF c-segmento = "Telefone Fixo GSM" THEN
            assign c-segmento = "Acessorios de TV".
      if c-segmento = "Redes Wireless Indoor" or c-segmento = "Banda larga sem fio" then
         assign c-segmento = "Redes Wireless PRO".
      /***** Segmento ***/

     FIND FIRST ped-venda 
         WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
           AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli  NO-LOCK NO-ERROR.
     IF AVAIL ped-venda THEN DO:
         FIND FIRST int-ped-venda2
             WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
               AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido  NO-LOCK NO-ERROR.
         IF AVAIL int-ped-venda2 AND int-ped-venda2.int-1 <> 0 THEN
             ASSIGN i-grpcanais = int-ped-venda2.int-1.
         ELSE DO:
             FIND FIRST grupo-canais-clientes
                 WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
             IF AVAIL grupo-canais-clientes THEN
                 ASSIGN i-grpcanais = grupo-canais-clientes.cod-gr-canais.
         END.
     END. /* IF AVAIL ped-venda THEN DO: */
     ELSE DO:
         FIND FIRST grupo-canais-clientes
             WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
         IF AVAIL grupo-canais-clientes THEN
             ASSIGN i-grpcanais = grupo-canais-clientes.cod-gr-canais.
     END.
      IF i-grpcanais <> 0 THEN DO:
          find tt-fat
             where tt-fat.periodo       = string(year(devol-cli.dt-devol),"9999") + string(month(devol-cli.dt-devol),"99")
               AND tt-fat.cod-gr-canais = i-grpcanais
               and tt-fat.unid-neg      = c-unid-negoc
               and tt-fat.segmento      = c-segmento no-error.
       
          if not available tt-fat then do:
             create tt-fat.
             assign tt-fat.periodo       = string(year(devol-cli.dt-devol),"9999") + string(month(devol-cli.dt-devol),"99")
                    tt-fat.cod-gr-canais = i-grpcanais
                    tt-fat.unid-neg      = c-unid-negoc
                    tt-fat.segmento      = c-segmento no-error.
          end.
       
          assign tt-fat.vl-fat-real = tt-fat.vl-fat-real - item-doc-est.preco-total[1].
      END.
      find tt-fat
         where tt-fat.periodo       = string(year(devol-cli.dt-devol),"9999") + string(month(devol-cli.dt-devol),"99")
           AND tt-fat.cod-gr-canais = 0
           and tt-fat.unid-neg      = c-unid-negoc
           and tt-fat.segmento      = c-segmento no-error.

      if not available tt-fat then do:
         create tt-fat.
         assign tt-fat.periodo       = string(year(devol-cli.dt-devol),"9999") + string(month(devol-cli.dt-devol),"99")
                tt-fat.cod-gr-canais = 0
                tt-fat.unid-neg      = c-unid-negoc
                tt-fat.segmento      = c-segmento no-error.
      end.

      assign tt-fat.vl-fat-real = tt-fat.vl-fat-real - item-doc-est.preco-total[1].
      PUT    
             nota-fiscal.nr-nota-fis ";"
             nota-fiscal.serie       ";"
             nota-fiscal.cod-estabel ";"
             ITEM.fm-cod-com         ";"
             item-doc-est.preco-total[1] * -1 FORMAT "->>,>>>,>>>,>>>.99" ";"
             "0"                     ";"
             c-unid-negoc            ";"
             c-segmento              ";"
             SKIP.

      PUT    
             nota-fiscal.nr-nota-fis ";"
             nota-fiscal.serie       ";"
             nota-fiscal.cod-estabel ";"
             ITEM.fm-cod-com         ";"
             item-doc-est.preco-total[1] * -1 FORMAT "->>,>>>,>>>,>>>.99" ";"
             i-grpcanais             ";"
             c-unid-negoc            ";"
             c-segmento              ";"
             SKIP.
   end.
   


   

   /** Atualiza tabela no banco **/

   PUT "GRAVANDO TABELA FATURAMENTO " SKIP.

   for each tt-fat:

       /* com grupo canais *******/
      find FIRST faturamento exclusive-lock
         where faturamento.periodo       = tt-fat.periodo
           AND faturamento.cod-gr-canais = tt-fat.cod-gr-canais
           and faturamento.unid-neg      = tt-fat.unid-neg
           and faturamento.segmento      = tt-fat.segmento no-error.
      if not available faturamento then do:
          PUT "nao encontrou nao encontrou nao encontrou nao encontrou"  SKIP.
         create faturamento.
         assign faturamento.periodo       = tt-fat.periodo
                faturamento.cod-gr-canais = tt-fat.cod-gr-canais
                faturamento.unid-neg      = tt-fat.unid-neg
                faturamento.segmento      = tt-fat.segmento
            /** GAMBI **/
                faturamento.mercado       = 'Interno'.
      end.

      PUT "antes  atualizar faturamento "  faturamento.cod-gr-canais
/*                faturamento.periodo       */
/*                faturamento.cod-gr-canais */
/*                faturamento.unid-neg      */
               faturamento.segmento  
            faturamento.vl-fat-orc 
            faturamento.vl-fat-real  
            faturamento.vl-cart      
            faturamento.vl-pendente  SKIP.


      assign faturamento.vl-fat-real = tt-fat.vl-fat-real
             faturamento.vl-pendente = tt-fat.vl-pendente
             faturamento.vl-cart     = tt-fat.vl-cart.

      PUT "depois atualizar faturamento "  faturamento.cod-gr-canais
/*                faturamento.periodo       */
/*                faturamento.cod-gr-canais */
/*                faturamento.unid-neg      */
               faturamento.segmento  
            faturamento.vl-fat-orc 
            faturamento.vl-fat-real  
            faturamento.vl-cart      
            faturamento.vl-pendente  SKIP.

   end.


/* Importar Dados de Empresas que n∆o est∆o no E.M.S */
   for first ponto-programa
        where ponto-programa.nome-programa = "ESFTP028"
          AND ponto-programa.ponto         = 1,
         EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          AND conteudo-programa.sequencia    = 1:
        assign c-arquivo = ENTRY(1,conteudo-programa.conteudo).
    end.    


    PUT "Importando " c-arquivo FORMAT "x(200)" SKIP.
    IF SEARCH(c-arquivo) <> ? THEN DO:
       INPUT FROM VALUE(c-arquivo).
       REPEAT:
             IMPORT UNFORMATTED c-linha.

             /* com grupo de canais ******/
             find faturamento exclusive-lock
                 where faturamento.periodo       = string(ENTRY(1, c-linha, ";")) 
                   AND faturamento.cod-gr-canais = integer(ENTRY(4, c-linha, ";")) 
                   and faturamento.unid-neg      = string(ENTRY(2, c-linha, ";")) 
                   and faturamento.segmento      = string(ENTRY(3, c-linha, ";"))  no-error.
          
              if not available faturamento then do:
                  PUT "nao achou faturamento " SKIP.
                 create faturamento.
                 assign faturamento.periodo       = string(ENTRY(1, c-linha, ";")) 
                        faturamento.unid-neg      = string(ENTRY(2, c-linha, ";")) 
                        faturamento.segmento      = string(ENTRY(3, c-linha, ";"))
                        faturamento.cod-gr-canais = INTEGER(ENTRY(4, c-linha, ";")) 
                        faturamento.mercado       = 'Interno'.
              end.  
              PUT   "ANTES ATUALIZAR "
                    faturamento.periodo   
                    faturamento.cod-gr-canais 
                    faturamento.unid-neg  
                    faturamento.segmento  
                    faturamento.vl-fat-orc 
                    faturamento.vl-fat-real  
                    faturamento.vl-cart      
                    faturamento.vl-pendente  SKIP.

/*                faturamento.vl-fat-orc     =  faturamento.vl-fat-orc  + DEC(ENTRY(4, c-linha, ";")) */
              ASSIGN
                     faturamento.vl-fat-real    =  faturamento.vl-fat-real + DEC(ENTRY(6, c-linha, ";"))
                     faturamento.vl-cart        =  faturamento.vl-cart     + DEC(ENTRY(7, c-linha, ";"))
                     faturamento.vl-pendente    =  faturamento.vl-pendente + DEC(ENTRY(8, c-linha, ";")).

              PUT  faturamento.periodo   
                       faturamento.unid-neg  
                       faturamento.segmento  
                                             
                    faturamento.vl-fat-orc 
                    faturamento.vl-fat-real  
                    faturamento.vl-cart      
                    faturamento.vl-pendente  SKIP.

              /* sem grupo de canais ******/
              find faturamento exclusive-lock
                  where faturamento.periodo       = string(ENTRY(1, c-linha, ";")) 
                    AND faturamento.cod-gr-canais = 0
                    and faturamento.unid-neg      = string(ENTRY(2, c-linha, ";")) 
                    and faturamento.segmento      = string(ENTRY(3, c-linha, ";"))  no-error.

               if not available faturamento then do:
                   PUT "nao achou faturamento " SKIP.
                  create faturamento.
                  assign faturamento.periodo       = string(ENTRY(1, c-linha, ";")) 
                         faturamento.unid-neg      = string(ENTRY(2, c-linha, ";")) 
                         faturamento.segmento      = string(ENTRY(3, c-linha, ";"))
                         faturamento.cod-gr-canais = 0
                         faturamento.mercado       = 'Interno'.
               end.  
               PUT   "ANTES ATUALIZAR "
                     faturamento.periodo   
                     faturamento.cod-gr-canais 
                     faturamento.unid-neg  
                     faturamento.segmento  
                     faturamento.vl-fat-orc 
                     faturamento.vl-fat-real  
                     faturamento.vl-cart      
                     faturamento.vl-pendente  SKIP.

 /*                faturamento.vl-fat-orc     =  faturamento.vl-fat-orc  + DEC(ENTRY(4, c-linha, ";")) */
               ASSIGN
                      faturamento.vl-fat-real    =  faturamento.vl-fat-real + DEC(ENTRY(6, c-linha, ";"))
                      faturamento.vl-cart        =  faturamento.vl-cart     + DEC(ENTRY(7, c-linha, ";"))
                      faturamento.vl-pendente    =  faturamento.vl-pendente + DEC(ENTRY(8, c-linha, ";")).

               PUT  faturamento.periodo   
                        faturamento.unid-neg  
                        faturamento.segmento  

                     faturamento.vl-fat-orc 
                     faturamento.vl-fat-real  
                     faturamento.vl-cart      
                     faturamento.vl-pendente  SKIP.

       END.
   END.
   INPUT CLOSE.
end procedure.

/* PROCEDURE pi-segmento:                                                                                 */
/*                                                                                                        */
/*     if c-segmento begins 'Partes e Pecas' then do:                                                     */
/*        if c-unid-negoc = 'ICORP' then                                                                  */
/*           assign c-segmento = "Pequenas e Medias centrais".                                            */
/*        else if c-unid-negoc = 'ICON' then                                                              */
/*           assign c-segmento = "Telefone sem fio".                                                      */
/*        else if c-unid-negoc = 'ISEC' then                                                              */
/*           assign c-segmento = "Gerenciamento de imagem".                                               */
/*        else if c-unid-negoc = 'INET' then                                                              */
/*           assign c-segmento = "Banda larga sem fio".                                                   */
/*        else if c-unid-negoc = 'IFIRE' then                                                             */
/*           assign c-segmento = "Alarme de Incàndio".                                                    */
/*        else if c-unid-negoc = 'ISEC/MG' then                                                           */
/*           assign c-segmento = "Alarmes".                                                               */
/*        else if c-unid-negoc = 'IAUT' then                                                              */
/*           assign c-segmento = "Fechadura".                                                             */
/*        else IF c-unid-negoc = 'IACCS' then                                                             */
/*           assign c-segmento = "Conversores e Perifericos".                                             */
/*        /* Alterado em 31/01/2014 - adicionado IFIRE solicitado pela usu†ria Juliana (Controladoria) */ */
/*     end.                                                                                               */
/*     /** Chamado 61441 **/                                                                              */
/*     if c-segmento = "Redes Wireless Indoor" or c-segmento = "Banda larga sem fio" then                 */
/*        assign c-segmento = "Redes Wireless PRO".                                                       */
/*                                                                                                        */
/* END PROCEDURE.                                                                                         */

function fn-segmento returns character
  ( p-fm-cod-com as character ) :
    find first fam-com-item
        where fam-com-item.fm-cod-com = substring(p-fm-cod-com, 1, 4) no-lock no-error.

   IF SUBSTRING(fam-com-item.fm-cod-com,1,2) = "31" THEN
       RETURN "Incàndio e Iluminaá∆o".
    ELSE
        IF SUBSTRING(fam-com-item.fm-cod-com,1,2) = "32" THEN
           RETURN "Controle de Acesso".
        ELSE
            IF SUBSTRING(fam-com-item.fm-cod-com,1,2) = "35" THEN
               RETURN "Acessorios".

            ELSE
                if available fam-com-item then
                    return fam-com-item.descricao.
                else
                    return "":U.
                    

end function.

function fn-unid-negoc returns character
  ( p-fm-cod-com as character ) :
    define variable i-sequencia      as integer   no-undo.
    define variable i-cdn_unid_negoc as integer   no-undo.
    define variable c-des_unid_negoc as character no-undo.

    find first fam-com-item
        where fam-com-item.fm-cod-com = p-fm-cod-com no-lock no-error.

    if not available fam-com-item then
        return "":U.

    assign c-des_unid_negoc = "":U.

    assign i-sequencia = int(fam-com-item.unidade) no-error.

    if not error-status:error then do:
        for first ponto-programa no-lock
            where ponto-programa.nome-programa = "boes513":U
              and ponto-programa.ponto         = 1,
            first conteudo-programa no-lock
            where conteudo-programa.cod-programa = ponto-programa.cod-programa
              and conteudo-programa.sequencia    = i-sequencia:
            assign i-cdn_unid_negoc = int(conteudo-programa.conteudo) no-error.

            if not error-status:error then
                run esp/ftp/esftp028rp1.p (input  i-cdn_unid_negoc,
                                           output c-des_unid_negoc).
        end.
    end.

    IF c-des_unid_negoc = "IAUT" OR
       c-des_unid_negoc = "IACCS" OR
       c-des_unid_negoc = "IFIRE" THEN
       ASSIGN c-des_unid_negoc = "INOV".

    return c-des_unid_negoc.

end function.

