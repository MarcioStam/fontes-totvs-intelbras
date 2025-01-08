 /********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i espdp051rp 2.00.00.012}  /*** 010012 ***/
/*******************************************************************************/
/** Programa....: espdp051rp.p                                                  **/
/*******************************************************************************/

/*****************/
/** Temp-Tables **/
/*****************/

define temp-table tt-param no-undo
    field destino            as integer
    field arquivo            as char format "x(35)"
    field usuario            as char format "x(12)"
    field data-exec          as date
    field hora-exec          as integer
    field classifica         as integer
    field desc-classifica    as char format "x(40)"
    field c-estab-ini        as char
    field c-estab-fim        as char
    field c-cli-ini          as char
    field c-cli-fim          as char
    field c-pedido-ini       as char
    field c-pedido-fim       as char
    field dt-impl-ini        as date format "99/99/9999"
    field dt-impl-fim        as date format "99/99/9999"
    field dt-entr-ini        as date format "99/99/9999"
    field dt-entr-fim        as date format "99/99/9999"
    field rs-moeda           as int 
    field c-rep-ini          as char
    field c-rep-fim          as char
    field l-ped-aval         as log
    field l-ped-n-aval       as log
    field l-ped-aprov        as log
    field l-ped-n-aprov      as log
    field l-ped-pend-inf     as log
    field l-mot-recusa       as LOG
    FIELD i-priori-ini       AS INTEGER
    FIELD i-priori-fim       AS INTEGER 
    FIELD i-grupo-ini        AS INTEGER
    FIELD i-grupo-fim        AS INTEGER
    FIELD i-grupo-cobran-ini AS INTEGER
    FIELD i-grupo-cobran-fim AS INTEGER
    FIELD l-bonificacao      AS LOG.

define temp-table tt-raw-digita
   field raw-digita as raw.

/*******************************/
/** Recebimento de Parƒmetros **/
/*******************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/****************************/
/** Defini‡Æo de Vari veis **/
/****************************/

{cdp/cdcfgdis.i}  /* Include para Pre-Processadores */
{include/i-rpvar.i}
{utp/ut-glob.i}

{include/tt-edit.i}
{include/pi-edit.i}

def var h-acomp as handle no-undo.

def var de-fator-2    as decimal                                 no-undo.   /** cota‡Æo da moeda do pedido                   **/
def var de-fator-3    as decimal                                 no-undo.   /** cota‡Æo da moeda padrÆo ou limite de cr‚dito **/
def var de-indice     as decimal                                 no-undo.   /** indice de conversao                          **/
def var de-lim-mopad  as decimal format ">>>,>>>,>>>,>>9.99"     no-undo.   /** Moeda limite cr‚dito                         **/
def var de-ind-fin    as decimal format ">>>,>>9.9<<<<"          no-undo.   /** Indice de financiamento                      **/
def var de-vl-a-aval  as decimal format ">>>,>>>,>>9.99"         no-undo.   /** Valor em aberto                              **/
def var de-tot-ped    as decimal format ">>,>>>,>>>,>>9.99"      no-undo.   /** Valor total de pedidos                       **/
def var de-ger-ped    as decimal format ">>>,>>>,>>>,>>9.99"     no-undo.   /** Total geral de pedidos                       **/
def var de-ger-molim  as decimal format ">>>,>>>,>>>,>>9.99"     no-undo.   /** Total geral do limite de cr‚dito             **/
def var de-tot-molim  as decimal format ">>,>>>,>>>,>>9.99"      no-undo.   /** Total do limite de cr‚dito                   **/
def var de-vl-aberto  like ped-venda.vl-liq-abe                  no-undo.
DEF VAR v_val_sdo_tit_acr AS DECIMAL FORMAT ">>>,>>>,>>9.99"     NO-UNDO.   /** Valor de ANs do cliente **/

def var c-cliente     as character format "x(90)"                no-undo.   /** Informa‡äes do Cliente                       **/
def var c-moeda       as character format "x(09)" init "Padrao"  no-undo.   /** Moeda                                        **/
def var c-cond-pagto  as character format "x(22)"                no-undo.   /** Condi‡Æo de pagamento                        **/
def var c-acompanhar  as character                               no-undo.   /** acompanhamento do processamento              **/
def var c-acompanhar2 as character                               no-undo.
def var c-lista-sit   as character                               no-undo.   /** Descri‡Æo da situa‡Æo do pedido              **/
def var c-motivo      as character format "x(18)"                no-undo.   /** Motivo da recusa                             **/
def var c-situacao    as character format "x(16)"                no-undo.   /** Situacao do pedido                           **/
def var c-vl-a-aval   as character format "x(10)"                no-undo.   /** Label do valor a avaliar                     **/
def var c-ind-fin     as character format "x(08)"                no-undo.
def var c-sit-aval    as character format "x(18)"                no-undo.
def var c-lista-aval  as character                               no-undo.
def var c-moeda-ped   as character format "x(16)"                no-undo.
def var c-sim         as character format "x(03)"                no-undo.
def var c-nao         as character format "x(03)"                no-undo.
def var c-emitente    like emitente.cgc                          no-undo.   /** CGC/CPF do emitente                          **/

def var i-tot-ped     as integer format ">,>>9"                  no-undo.   /** Contador de pedidos                          **/
def var i-ger-ped     as integer format ">>,>>9"                 no-undo.   /** Contador Geral de Pedidos                    **/

/************************/
/** Defini‡Æo de forms **/
/************************/

DEF TEMP-TABLE tt-ped-venda-filtro
    FIELD nr-pedido LIKE ped-venda.nr-pedido
    INDEX idx-primary IS UNIQUE nr-pedido .

form
   ped-venda.dt-entrega      at 001
   ped-venda.nr-pedcli       at 014
   ped-venda.no-ab-reppri    at 030
   ped-venda.vl-liq-abe      at 045
   c-vl-a-aval               at 070
   ped-venda.mo-codigo       at 085
   ped-venda.dt-implant      at 102
   ped-venda.nr-tab-finan    at 114
   c-ind-fin                 at 125 skip 
   ped-venda.cod-estabel     at 001
   ped-venda.cod-cond-pag    at 007
   ped-venda.cod-sit-pre     at 031
   ped-venda.cod-sit-aval    at 049 
   ped-venda.tp-pedido       AT 076 COLUMN-LABEL "AT"
with width 133 no-box page-top stream-io frame f-cab-ent.

{utp/ut-liter.i "Ind Fin" * R}
assign c-ind-fin:label in frame f-cab-ent = trim(return-value).

{utp/ut-liter.i "Vl a Avaliar" * R}
assign c-vl-a-aval:label in frame f-cab-ent = trim(return-value).

{utp/ut-liter.i "Moeda" * R}
assign ped-venda.mo-codigo:label in frame f-cab-ent = trim(return-value).

{utp/ut-liter.i "Cond Pagamento" * R}
assign ped-venda.cod-cond-pag:label in frame f-cab-ent = trim(return-value).

form
   ped-venda.nr-pedcli               at 001
   ped-venda.no-ab-reppri            at 017
   ped-venda.vl-liq-abe              at 033
   c-vl-a-aval                       at 055
   ped-venda.mo-codigo               at 070
   ped-venda.dt-entrega              at 089  
   ped-venda.dt-implant              at 102
   ped-venda.nr-tab-finan            at 118
   c-ind-fin                         at 125 skip
   ped-venda.cod-estabel             at 001   
   ped-venda.cod-cond-pag            at 008 
   ped-venda.cod-sit-pre             at 039
   ped-venda.cod-sit-aval            at 057
   ped-venda.tp-pedido               AT 076 COLUMN-LABEL "AT"
with width 133 no-box page-top stream-io frame f-cab-ped.

{utp/ut-liter.i "Önd Fin" * R}
assign c-ind-fin:label in frame f-cab-ped = trim(return-value).

{utp/ut-liter.i "Vl a Avaliar" * R}
assign c-vl-a-aval:label in frame f-cab-ped = trim(return-value).

{utp/ut-liter.i "Moeda" * R}
assign ped-venda.mo-codigo:label in frame f-cab-ped = trim(return-value).

{utp/ut-liter.i "Cond Pagamento" * R}
assign ped-venda.cod-cond-pag:label in frame f-cab-ped = trim(return-value).

run utp/ut-trfrrp.p (input frame f-cab-ped:handle).
run utp/ut-trfrrp.p (input frame f-cab-ent:handle).
{include/i-rpout.i}
{include/i-rpcab.i}

/*********************/
/** Bloco Principal **/
/*********************/

for first mgcad.empresa fields (ep-codigo razao-social) where empresa.ep-codigo = i-ep-codigo-usuario no-lock:
    assign c-empresa = empresa.razao-social.
end.

{utp/ut-liter.i "Avalia‡Æo de Cr‚dito" * R}

assign c-programa     = "espdp051"
       c-versao       = "1.00"
       c-revisao      = ".00.000"
       c-sistema      = "MPD"
       c-titulo-relat = trim(return-value).

RUN utp/ut-liter.p (INPUT REPLACE({diinc/i03di149.i 03}," ","_"), INPUT "", INPUT "").
ASSIGN c-lista-sit = TRIM(RETURN-VALUE).

RUN utp/ut-liter.p (INPUT REPLACE({diinc/i03di159.i 03}," ","_"), INPUT "", INPUT "").
ASSIGN c-lista-aval = TRIM(RETURN-VALUE).
/*
view frame f-cabec.
view frame f-rodape.
*/
run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Imprimindo *}.
run pi-inicializar in h-acomp (input return-value).

{utp/ut-liter.i "Processando Pedidos Cliente:" * R}
assign c-acompanhar = return-value.

find first param-global no-lock no-error.
find first para-ped     no-lock no-error.

/***************************************************
 * Pre-processador de Usuario e Moeda de Credito   *
 ***************************************************/
&if  defined (bf_dis_usu_moeda_cred)  &then


&else
    if  para-ped.moeda-libcre <> 0 then do:
        find first moeda where moeda.mo-codigo = para-ped.moeda-libcre no-lock no-error.
        assign c-moeda = moeda.descricao.
    end.
    else do:
        {utp/ut-liter.i PadrÆo * R}
        assign c-moeda = return-value.
    end.
&endif.

assign i-ger-ped    = 0
       de-ger-ped   = 0    
       de-ger-molim = 0.

RUN pi-filtra-bonificacoes.

case tt-param.classifica:
   when 1 then do:
      run pi-impr-cliente-pedido.
   end.
   when 2 then do: 
      run pi-impr-cliente-dtentr.
   end.
end.
run pi-finalizar in h-acomp.

/*************************/
/** Procedures internas **/
/*************************/

/***************************************/
/** Quebra por cliente/pedido cliente **/
/***************************************/

PROCEDURE pi-filtra-bonificacoes:

    FOR EACH estabelec NO-LOCK
       WHERE estabelec.cod-estabel >= tt-param.c-estab-ini
         AND estabelec.cod-estabel <= tt-param.c-estab-fim,
        EACH ped-venda NO-LOCK
       WHERE ped-venda.cod-estabel        = estabelec.cod-estabel
         AND (ped-venda.cod-sit-ped        = 1
          OR  ped-venda.cod-sit-ped        = 2)
         AND ped-venda.nr-pedcli     >= tt-param.c-pedido-ini          
         AND ped-venda.nr-pedcli     <= tt-param.c-pedido-fim      
         AND ped-venda.dt-entrega    >= tt-param.dt-entr-ini           
         AND ped-venda.dt-entrega    <= tt-param.dt-entr-fim           
         AND ped-venda.dt-implant    >= tt-param.dt-impl-ini           
         AND ped-venda.dt-implant    <= tt-param.dt-impl-fim    
         AND ped-venda.no-ab-reppri  >= tt-param.c-rep-ini             
         AND ped-venda.no-ab-reppri  <= tt-param.c-rep-fim             
         AND ped-venda.cod-priori    >= tt-param.i-priori-ini          
         AND ped-venda.cod-priori    <= tt-param.i-priori-fim,
       FIRST emitente NO-LOCK
       WHERE emitente.cod-emitente    = ped-venda.cod-emitente
         AND (emitente.identific      = 1
          OR  emitente.identific      = 3)
         AND emitente.nome-abrev     >= tt-param.c-cli-ini 
         AND emitente.nome-abrev     <= tt-param.c-cli-fim
         AND emitente.cod-gr-cli     >= tt-param.i-grupo-ini
         AND emitente.cod-gr-cli     <= tt-param.i-grupo-fim:
    
         IF ped-venda.cod-cond-pag = 74 THEN NEXT.
         IF ped-venda.cod-cond-pag = 75 THEN NEXT.
         IF ped-venda.cod-cond-pag = 76 THEN NEXT.
         IF ped-venda.cod-cond-pag = 77 THEN NEXT.
         IF ped-venda.cod-cond-pag = 78 THEN NEXT.
    
         IF ped-venda.cod-sit-ped  > 2 THEN NEXT.
    
         IF ped-venda.cod-sit-aval = 1 AND tt-param.l-ped-n-aval  = NO THEN NEXT.
         IF ped-venda.cod-sit-aval = 2 AND tt-param.l-ped-aval    = NO THEN NEXT.
         IF ped-venda.cod-sit-aval = 3 AND tt-param.l-ped-aprov   = NO THEN NEXT.
         IF ped-venda.cod-sit-aval = 4 AND tt-param.l-ped-n-aprov = NO THEN NEXT.
    
         IF ped-venda.log-cotacao = YES THEN NEXT.
    
         IF tt-param.l-bonificacao = NO  AND ped-venda.origem = 9 THEN NEXT.
         
         IF  NOT tt-param.l-bonificacao THEN DO:
             IF  CAN-FIND (FIRST pagto-vpc WHERE  pagto-vpc.nr-pedcli = ped-venda.nr-pedcli) THEN
                 NEXT.
         END.

         IF  NOT CAN-FIND(FIRST tt-ped-venda-filtro
                             WHERE tt-ped-venda-filtro.nr-pedido = ped-venda.nr-pedido) THEN DO:
             CREATE tt-ped-venda-filtro.
             ASSIGN tt-ped-venda-filtro.nr-pedido = ped-venda.nr-pedido.
         END.
    END.
END.

procedure pi-impr-cliente-pedido: 
      put unformatted
          "GR COBR"               ";"
          "MATRIZ"                ";"
          "CODIGO"                ";"
          "CNPJ"                  ";"
          "NOME ABREVIADO"        ";"
          "NUMERO DO PEDIDO"      ";"
          "CONDI€ÇO DE PAGAMENTO" ";"
          "COMPLETO?"             ";"
          "SALDO TITULO"          ";"
          "VALOR ABERTO"          ";"
          "VALOR AVAL"            ";"
          "ATENDENTE"             ";"
          "DATA DA IMPLANTA€ÇO"   ";"
          "OBSERVA€ÇO DA ANALISE" ";"
          SKIP.

       FOR EACH  tt-ped-venda-filtro
           ,FIRST ped-venda NO-LOCK
            WHERE ped-venda.nr-pedido =  tt-ped-venda-filtro.nr-pedido
              ,FIRST ped-item NO-LOCK OF ped-venda
              , FIRST emitente NO-LOCK
                    WHERE emitente.nome-abrev = ped-venda.nome-abrev
                break by ped-venda.nome-abrev
                      by ped-venda.nr-pedcli:

             FIND FIRST int-emitente
                   WHERE int-emitente.cod-emitente = ped-venda.cod-emitente
                     AND int-emitente.cod-gr-cob >= tt-param.i-grupo-cobran-ini
                     AND int-emitente.cod-gr-cob <= tt-param.i-grupo-cobran-fim NO-ERROR.
              IF  AVAIL int-emitente THEN DO:
            
                  ASSIGN c-acompanhar2 = c-acompanhar + ' ' + ped-venda.nome-abrev.               
                  run pi-acompanhar in h-acomp (input c-acompanhar2).              
                  
                  assign c-situacao = entry(ped-venda.cod-sit-ped,c-lista-sit).
                  assign c-sit-aval = entry(ped-venda.cod-sit-aval,c-lista-aval).
                  run pi-processa-relatorio (input first-of(ped-venda.nome-abrev),
                                             input last-of(ped-venda.nome-abrev)).
                  PUT SKIP.
              END.
       END.
END.
/****************************************/
/** Quebra por cliente/data de entrega **/
/****************************************/

procedure pi-impr-cliente-dtentr:  
    put unformatted
        "GR COBR"               ";"
        "MATRIZ"                ";"
        "CODIGO"                ";"
        "CNPJ"                  ";"
        "NOME ABREVIADO"        ";"
        "NUMERO DO PEDIDO"      ";"
        "CONDI€ÇO DE PAGAMENTO" ";"
        "COMPLETO?"             ";"
/*         "SALDO TITULO"          ";" */
        "VALOR ABERTO"          ";"
/*         "VALOR AVAL"            ";"  */
        "ATENDENTE"             ";"
        "DATA DA IMPLANTA€ÇO"   ";"
        "OBSERVA€ÇO DA ANALISE" ";"
        SKIP.

       for each emitente fields (nome-abrev identific lim-credito cod-emitente nome-emit
                                 cidade cgc categoria dt-lim-cre ind-aval moeda-libcre nome-matriz)
           where emitente.nome-abrev  >= tt-param.c-cli-ini and
                 emitente.nome-abrev  <= tt-param.c-cli-fim and
                 (emitente.identific   = 1                   or
                  emitente.identific   = 3                 ) AND
                 emitente.cod-gr-cli >= tt-param.i-grupo-ini AND
                 emitente.cod-gr-cli <= tt-param.i-grupo-fim no-lock,
    
           each ped-venda 
              USE-INDEX ch-credito
              where ped-venda.nome-abrev     = emitente.nome-abrev            and
                    ped-venda.cod-estabel   >= tt-param.c-estab-ini           and                 
                    ped-venda.cod-estabel   <= tt-param.c-estab-fim           and
                    ped-venda.nr-pedcli     >= tt-param.c-pedido-ini          and
                    ped-venda.nr-pedcli     <= tt-param.c-pedido-fim          and 
                   (ped-venda.cod-sit-aval  = 1 and tt-param.l-ped-n-aval     or  /** NÆo avaliado                      **/
                    ped-venda.cod-sit-aval  = 2 and tt-param.l-ped-aval       or  /** Avaliado                          **/
                    ped-venda.cod-sit-aval  = 3 and tt-param.l-ped-aprov      or  /** Aprovado                          **/
                    ped-venda.cod-sit-aval  = 4 and tt-param.l-ped-n-aprov)       /** NÆo aprovado                      **/
              and   ped-venda.cod-sit-ped   <= 2                              and  /** Pedidos aberto e atendido parcial **/
                    ped-venda.dt-entrega    >= tt-param.dt-entr-ini           and
                    ped-venda.dt-entrega    <= tt-param.dt-entr-fim           and
                    ped-venda.dt-implant    >= tt-param.dt-impl-ini           and
                    ped-venda.dt-implant    <= tt-param.dt-impl-fim           and
                    ped-venda.no-ab-reppri  >= tt-param.c-rep-ini             and
                    ped-venda.no-ab-reppri  <= tt-param.c-rep-fim             AND
                    (IF NOT tt-param.l-bonificacao THEN 
                        ped-venda.origem <> 9 
                     ELSE 
                        ped-venda.origem >= 0)                                AND
                    ped-venda.cod-priori    >= tt-param.i-priori-ini          AND
                    ped-venda.cod-priori    <= tt-param.i-priori-fim          
    
                    &IF '{&BF_DIS_VERSAO_EMS}' >= '2.04' &THEN
                        AND ped-venda.log-cotacao = NO
                    &ENDIF
                    no-lock
                    break by ped-venda.nome-abrev
                          by ped-venda.dt-entrega:

                        FIND FIRST int-emitente
                            WHERE int-emitente.cod-emitente = ped-venda.cod-emitente
                              AND int-emitente.cod-gr-cob >= tt-param.i-grupo-cobran-ini
                              AND int-emitente.cod-gr-cob <= tt-param.i-grupo-cobran-fim NO-ERROR.
                         IF AVAIL int-emitente THEN DO:

                             c-acompanhar2 = c-acompanhar + ' ' + ped-venda.nome-abrev.               
                             run pi-acompanhar in h-acomp (input c-acompanhar2).              
                             IF ped-venda.cod-cond-pag = 74 OR
                                ped-venda.cod-cond-pag = 75 OR
                                ped-venda.cod-cond-pag = 76 OR
                                ped-venda.cod-cond-pag = 77 OR
                                ped-venda.cod-cond-pag = 78 THEN NEXT.
                      
                             IF NOT can-find(FIRST ped-item OF ped-venda no-lock) THEN NEXT.
                      
                             assign c-situacao = entry(ped-venda.cod-sit-ped,c-lista-sit).
                             assign c-sit-aval = entry(ped-venda.cod-sit-aval,c-lista-aval).       
                             run pi-processa-relatorio (input first-of(ped-venda.nome-abrev),
                                                      input last-of(ped-venda.nome-abrev)).
                             PUT SKIP.

                         END.
    end.
end.

/**************/
/** Displays **/
/**************/

procedure pi-processa-relatorio:
  def input parameter l-primeiro as logical no-undo.
  def input parameter l-ultimo   as logical no-undo.

  assign de-fator-2 = 1.
  assign de-fator-3 = 1.

  if  ped-venda.mo-codigo <> 0 then do:
      run pi-cotacao-moeda (input ped-venda.mo-codigo,
                            input today,
                            output de-fator-2). /** Cota‡Æo da moeda do pedido **/
  end.

  if  tt-param.rs-moeda <> 1
  then do:
      /***************************************************
       * Pre-processador de Usuario e Moeda de Credito   *
       ***************************************************/
       &if  defined (bf_dis_usu_moeda_cred)  &then
           run pi-cotacao-moeda (input  emitente.moeda-libcre,
                                 input  today,
                                 output de-fator-3). /** Cota‡Æo da moeda do limite de cr‚dito **/
       &else
           run pi-cotacao-moeda (input  para-ped.moeda-libcre,
                                 input  today,
                                         output de-fator-3). /** Cota‡Æo da moeda do limite de cr‚dito **/
       &endif.
  end.

  assign de-indice = de-fator-2 / de-fator-3.

  assign de-lim-mopad = emitente.lim-credito / (if tt-param.rs-moeda = 1
                                                then 1
                                                else de-indice)
         c-cliente = emitente.nome-abrev + " (" +
                     string(emitente.cod-emitente) + 
                     ") - " + emitente.nome-emit + " - " + emitente.cidade.

  ASSIGN v_val_sdo_tit_acr = 0.
  RUN esp/pdp/espdp051rp-a.p (INPUT emitente.cod-emitente,
                              OUTPUT v_val_sdo_tit_acr).     

  put unformatted
      int-emitente.cod-gr-cob ";"
      emitente.nome-matriz    ";"
      emitente.cod-emitente   ";"
      emitente.cgc            ";"
      emitente.nome-abrev     ";"
      ped-venda.nr-pedcli     ";".

  assign c-cond-pagto = "".

  if ped-venda.cod-cond-pag = 0 then  /** Pedido com condi‡Æo de pagamento especial **/
     assign c-cond-pagto = "0 - Especial".
  else do:
     find first cond-pagto where cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag no-lock no-error.
     assign c-cond-pagto = string(cond-pagto.cod-cond-pag, ">>9") + "-"  + substring(cond-pagto.descricao,1,19).
  end.  

  PUT UNFORMATTED
      c-cond-pagto ";".


  if ped-venda.completo then put UNFORMATTED "SIM" ";".
  else put UNFORMATTED "NAO" ";".

/*   put UNFORMATTED             */
/*       v_val_sdo_tit_acr  ";". */

  run pi-calc-valor-aberto (input rowid(ped-venda),
                            input-output de-vl-a-aval). /** C lculo do valor em aberto pedido **/

  assign de-vl-a-aval = de-vl-a-aval * de-indice
         de-vl-aberto = ped-venda.vl-liq-abe * de-indice.

  put unformatted
         de-vl-aberto              ";".
/*          de-vl-a-aval              ";". */

  FIND atendente
      WHERE atendente.cd-oper = int(ped-venda.tp-pedido)
      NO-LOCK NO-ERROR.
  IF  AVAIL atendente THEN
      put UNFORMATTED atendente.nm-oper ";".
  ELSE
      put UNFORMATTED "" ";".

  put unformatted ped-venda.dt-implant      ";".

  if tt-param.l-mot-recusa = yes and ped-venda.cod-sit-aval = 4  then do: /** NÆo aprovado **/

    for each tt-editor:
        delete tt-editor.
    end.

    run pi-print-editor (ped-venda.desc-bloq-cr, 100).
    for each tt-editor:
        if   tt-editor.linha = 1 then do: 
             put unformatted tt-editor.conteudo.     
        end.
             else put unformatted tt-editor.conteudo.     
    end.   
    IF  NOT CAN-FIND (FIRST tt-editor) THEN
        PUT "" ";".
  end.
  ELSE PUT "" ";".

  assign i-tot-ped    = i-tot-ped + 1
         de-tot-ped   = de-tot-ped + (ped-venda.vl-liq-abe * de-indice)
         de-tot-molim = de-tot-molim + de-vl-a-aval.

  IF  l-ultimo THEN DO:
      if (de-tot-molim > emitente.lim-credito 
      and emitente.ind-aval = 3) then do:
         {utp/ut-liter.i "Obs.: O saldo total dos pedidos em aberto do cliente excede seu limite de cr‚dito." + R}. 
         put return-value format "x(85)".
      end.  
      ASSIGN i-tot-ped    = 0
             de-tot-ped   = 0
             de-tot-molim = 0.
  END.

end.

procedure pi-cotacao-moeda:

  def input  parameter i-moeda    as integer no-undo.
  def input  parameter d-data     as date    no-undo.
  def output parameter de-cotacao as decimal no-undo.

  find first cotacao
      where cotacao.mo-codigo   = i-moeda
      and   cotacao.ano-periodo = string(year(d-data)) + string(month(d-data),"99")
      and   cotacao.cotacao[int(day(d-data))] <> 0 no-lock no-error.

  if  avail cotacao then
      assign de-cotacao = cotacao.cotacao[int(day(d-data))].
  else assign de-cotacao = 1.    
end.

procedure pi-calc-valor-aberto:
  def input        parameter r-pedido   as rowid.
  def input-output parameter de-tot-pre like ped-venda.vl-liq-abe.

  assign de-tot-pre = 0.
  find ped-venda 
       where rowid(ped-venda) = r-pedido no-lock no-error.
  if can-find (first natur-oper where  natur-oper.nat-operacao = ped-venda.nat-operacao
               and natur-oper.emite-duplic = no) then 
     return.

  for each  ped-item fields (ped-item.nat-operacao ped-item.vl-liq-abe)
      where ped-item.nome-abrev    = ped-venda.nome-abrev
        and ped-item.nr-pedcli     = ped-venda.nr-pedcli
        and ped-item.ind-componen  <> 3
        and ped-item.qt-pedida     >  0 no-lock:
    if  can-find (first natur-oper where natur-oper.nat-operacao = ped-item.nat-operacao
                    and natur-oper.emite-duplic = yes) then
        assign de-tot-pre = de-tot-pre + ped-item.vl-liq-abe.
  end.
end.
