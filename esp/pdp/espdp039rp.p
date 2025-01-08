
/*******************************************************************************/
{include/i-prgvrs.i espdp039rp 2.00.00.012}  /*** 010012 ***/
/*******************************************************************************/


define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field c-estab-ini      as char
    field c-estab-fim      as char
    field c-cli-ini        as char
    field c-cli-fim        as char
    field c-pedido-ini     as char
    field c-pedido-fim     as char
    field dt-impl-ini      as date format "99/99/9999"
    field dt-impl-fim      as date format "99/99/9999"
    field dt-entr-ini      as date format "99/99/9999"
    field dt-entr-fim      as date format "99/99/9999"
    field rs-moeda         as int 
    field c-rep-ini        as char
    field c-rep-fim        as char
    field l-ped-aval       as log
    field l-ped-n-aval     as log
    field l-ped-aprov      as log
    field l-ped-n-aprov    as log
    field l-ped-pend-inf   as log
    field l-mot-recusa     as log.

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

assign c-programa     = "pd0808rp"
       c-versao       = "1.00"
       c-revisao      = ".00.000"
       c-sistema      = "MPD"
       c-titulo-relat = trim(return-value).

RUN utp/ut-liter.p (INPUT REPLACE({diinc/i03di149.i 03}," ","_"), INPUT "", INPUT "").
ASSIGN c-lista-sit = TRIM(RETURN-VALUE).

RUN utp/ut-liter.p (INPUT REPLACE({diinc/i03di159.i 03}," ","_"), INPUT "", INPUT "").
ASSIGN c-lista-aval = TRIM(RETURN-VALUE).

/* view frame f-cabec.  */
/* view frame f-rodape. */

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

case tt-param.classifica:
   when 1 then do:
      run pi-impr-cliente-pedido.

   end.
   when 2 then do: 
      run pi-impr-cliente-dtentr.
   end.
end.
run pi-finalizar in h-acomp.

page.

{utp/ut-liter.i "Sele‡Æo" * R}
put space(41) trim(return-value) format "x(25)" skip(2).

{utp/ut-liter.i "Estabelecimento"  * r}
put "          " trim(return-value) format "x(30)" " : " tt-param.c-estab-ini
    "  |>  <|  "  at 60 tt-param.c-estab-fim skip.

{utp/ut-liter.i "Cliente" * r}
put "          " trim(return-value) format "x(30)" " : " tt-param.c-cli-ini
    "  |>  <|  " at 60 tt-param.c-cli-fim skip.

{utp/ut-liter.i "Pedido Cliente" * r}
put "          " trim(return-value) format "x(30)" " : " tt-param.c-pedido-ini
    "  |>  <|  " at 60 tt-param.c-pedido-fim skip.

{utp/ut-liter.i "Data Implanta‡Æo" * r}
put "          " trim(return-value) format "x(30)" " : " tt-param.dt-impl-ini
    "  |>  <|  " at 60 tt-param.dt-impl-fim skip.

{utp/ut-liter.i "Prev.Fatur" * r}
put "          " trim(return-value) format "x(30)" " : " tt-param.dt-entr-ini
    "  |>  <|  " at 60 tt-param.dt-entr-fim skip.

{utp/ut-liter.i "Representante" * r}
put "          " trim(return-value) format "x(30)" " : " tt-param.c-rep-ini
    "  |>  <|  " at 60 tt-param.c-rep-fim skip(2).

{utp/ut-liter.i "Classifica‡Æo" * R}
put space(41) trim(return-value) format "x(25)" skip(2).

put tt-param.desc-classifica at 25 skip(2).

{utp/ut-liter.i "Parƒmetros" * R}
put space(41) trim(return-value) format "x(25)" skip(2).

{utp/ut-liter.i "Situa‡Æo Avalia‡Æo Pedido" * r}
put space(25) trim(return-value) format "x(25)" skip(1).

{utp/ut-liter.i "Sim" * R}
assign c-sim = trim(return-value).

{utp/ut-liter.i "NÆo" * R}
assign c-nao = trim(return-value).

{utp/ut-liter.i "Avaliados" * R}
if tt-param.l-ped-aval 
then put "          " trim(return-value) format "x(30)" " : " c-sim skip.
else put "          " trim(return-value) format "x(30)" " : " c-nao skip.

{utp/ut-liter.i "NÆo Avaliados" * R}
if tt-param.l-ped-n-aval
then put "          " trim(return-value) format "x(30)" " : " c-sim skip.
else put "          " trim(return-value) format "x(30)" " : " c-nao skip.

{utp/ut-liter.i "Aprovados" * R}
if tt-param.l-ped-aprov 
then put "          " trim(return-value) format "x(30)" " : " c-sim skip.
else put "          " trim(return-value) format "x(30)" " : " c-nao skip.

{utp/ut-liter.i "NÆo Aprovados" * R}
if tt-param.l-ped-n-aprov 
then put "          " trim(return-value) format "x(30)" " : " c-sim skip.
else put "          " trim(return-value) format "x(30)" " : " c-nao skip.

/*
{utp/ut-liter.i "Pendente Informa‡Æo" * R}
if tt-param.l-ped-pend-inf
then put "          " trim(return-value) format "x(30)" " : " c-sim skip.
else put "          " trim(return-value) format "x(30)" " : " c-nao.
*/

{utp/ut-liter.i "Moeda: " * R}
assign c-moeda = trim(return-value).
if tt-param.rs-moeda = 1
then {utp/ut-liter.i "PadrÆo" * R}
else {utp/ut-liter.i "Limite Cr‚dito" * R}
put "          " c-moeda format "x(30)" " : " trim(return-value) skip.

{utp/ut-liter.i "Imprime Motivo Recusa Pedidos" * R}
if tt-param.l-mot-recusa
then put "          " trim(return-value) format "x(30)" " : " c-sim skip.
else put "          " trim(return-value) format "x(30)" " : " c-nao skip.

put skip(2).

{utp/ut-liter.i "Impressao" * r}
put trim(return-value) at 041  format "x(15)" skip(1).   /** Impressao **/

{utp/ut-liter.i "Destino:" * r}
put trim(return-value) at 035 format "x(08)".

if tt-param.destino = 1 then do:
  {utp/ut-liter.i "Impressora"}.
   put return-value     at 044 format "x(12)".
   put tt-param.arquivo at 054 format "x(35)" skip.
end.   


if tt-param.destino = 2 then do:
   {utp/ut-liter.i "Arquivo"}.
   put return-value     at 044 format "x(12)".
   put tt-param.arquivo at 054 format "x(35)" skip.
end.   

if tt-param.destino = 3 then  do:
   {utp/ut-liter.i "Terminal"}.
   put return-value at 044 format "x(12)" skip.
end.   

{utp/ut-liter.i "Usu rio:" * r}.
put return-value       at 035 format "x(08)".
put tt-param.usuario   at 044 format "x(20)".

/*************************/
/** Procedures internas **/
/*************************/

/***************************************/
/** Quebra por cliente/pedido cliente **/
/***************************************/

procedure pi-impr-cliente-pedido: 
   PUT "Nome Abrev   Cod.Cli     Nome Emitente                              Cidade                    CNPJ                  Lim.Credito Pedido       Representante      Vlr.Aberto  Vlr a Avaliar Moeda            Dt.Entrega Dt.Implant Tb Fin  Ind Est Cond.Pagto             Situa‡Æo Ped.    Situ.Aprova‡Æo     Motivo Recusa" SKIP.
   for each emitente fields (nome-abrev identific lim-credito cod-emitente
                             nome-emit cidade cgc categoria dt-lim-cre ind-aval moeda-libcre)
       where emitente.nome-abrev  >= tt-param.c-cli-ini and
             emitente.nome-abrev  <= tt-param.c-cli-fim and
             (emitente.identific   = 1                   or
              emitente.identific   = 3                 ) no-lock,
       each ped-venda fields (mo-codigo cod-sit-ped cod-cond-pag nr-ind-finan nr-tab-finan 
                              vl-liq-abe desc-bloq-cr nat-operacao cod-sit-aval nome-abrev
                              cod-estabel nr-pedcli dt-entrega dt-implant no-ab-reppri tab-ind-fin)
          USE-INDEX ch-credito
          where ped-venda.nome-abrev     = emitente.nome-abrev            and
                ped-venda.cod-estabel   >= tt-param.c-estab-ini           and                 
                ped-venda.cod-estabel   <= tt-param.c-estab-fim           and
                ped-venda.nr-pedcli     >= tt-param.c-pedido-ini          and
                ped-venda.nr-pedcli     <= tt-param.c-pedido-fim          and 
               (ped-venda.cod-sit-aval  = 1 and tt-param.l-ped-n-aval     or  /** NÆo avaliado                      **/
                ped-venda.cod-sit-aval  = 2 and tt-param.l-ped-aval       or  /** Avaliado                          **/
                ped-venda.cod-sit-aval  = 3 and tt-param.l-ped-aprov      or  /** Aprovado                          **/
                ped-venda.cod-sit-aval  = 4 and tt-param.l-ped-n-aprov )      /** NÆo aprovado                      **/
          and   ped-venda.cod-sit-ped   <= 2                              and  /** Pedidos aberto e atendido parcial **/
                ped-venda.dt-entrega    >= tt-param.dt-entr-ini           and
                ped-venda.dt-entrega    <= tt-param.dt-entr-fim           and
                ped-venda.dt-implant    >= tt-param.dt-impl-ini           and
                ped-venda.dt-implant    <= tt-param.dt-impl-fim           and
                ped-venda.no-ab-reppri  >= tt-param.c-rep-ini             and
                ped-venda.no-ab-reppri  <= tt-param.c-rep-fim 
                &IF '{&BF_DIS_VERSAO_EMS}' >= '2.04' &THEN
                    AND ped-venda.log-cotacao = NO
                &ENDIF
                no-lock
                break by ped-venda.nome-abrev
                      by ped-venda.nr-pedcli:

       c-acompanhar2 = c-acompanhar + ' ' + ped-venda.nome-abrev.               
       run pi-acompanhar in h-acomp (input c-acompanhar2).              

       assign c-situacao = entry(ped-venda.cod-sit-ped,c-lista-sit).
       assign c-sit-aval = entry(ped-venda.cod-sit-aval,c-lista-aval).
       run pi-processa-relatorio (input first-of(ped-venda.nome-abrev),
                                  input last-of(ped-venda.nome-abrev)).
   end.    
end.

/****************************************/
/** Quebra por cliente/data de entrega **/
/****************************************/

procedure pi-impr-cliente-dtentr:  
   PUT "Nome Abrev   Cod.Cli     Nome Emitente                              Cidade                    CNPJ                  Lim.Credito Dt.Entrega Pedido       Representante      Vlr.Aberto    Vlr a Avaliar Moeda            Dt.Implant Tb Fin  Ind Est Cond.Pagto             Situa‡Æo Ped.    Situ.Aprova‡Æo     Motivo Recusa" SKIP.
   for each emitente fields (nome-abrev identific lim-credito cod-emitente nome-emit
                             cidade cgc categoria dt-lim-cre ind-aval moeda-libcre)
       where emitente.nome-abrev  >= tt-param.c-cli-ini and
             emitente.nome-abrev  <= tt-param.c-cli-fim and
             (emitente.identific   = 1                   or
              emitente.identific   = 3                 ) no-lock,
       each ped-venda fields (mo-codigo cod-sit-ped cod-cond-pag nr-ind-finan nr-tab-finan 
                              vl-liq-abe desc-bloq-cr nat-operacao nome-abrev nr-pedcli cod-sit-aval
                              dt-entrega dt-implant no-ab-reppri tab-ind-fin)
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
                ped-venda.no-ab-reppri  <= tt-param.c-rep-fim 
                &IF '{&BF_DIS_VERSAO_EMS}' >= '2.04' &THEN
                    AND ped-venda.log-cotacao = NO
                &ENDIF
                no-lock
                break by ped-venda.nome-abrev
                      by ped-venda.dt-entrega:

       c-acompanhar2 = c-acompanhar + ' ' + ped-venda.nome-abrev.               
       run pi-acompanhar in h-acomp (input c-acompanhar2).              

       assign c-situacao = entry(ped-venda.cod-sit-ped,c-lista-sit).
       assign c-sit-aval = entry(ped-venda.cod-sit-aval,c-lista-aval).       
       run pi-processa-relatorio (input first-of(ped-venda.nome-abrev),
                                  input last-of(ped-venda.nome-abrev)).
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


     PUT emitente.nome-abrev  " "
         string(emitente.cod-emitente) " "  
         " - "  emitente.nome-emit  " - "  emitente.cidade " "       
         emitente.cgc         format param-global.formato-id-federal " "
         emitente.lim-credito format ">>>,>>>,>>9.99" " ".      




  assign c-moeda-ped = "".
  find first moeda where moeda.mo-codigo = ped-venda.mo-codigo no-lock no-error.
  if avail moeda then
     assign c-moeda-ped = string(moeda.mo-codigo) + " - " + moeda.descricao.

  assign c-cond-pagto = "".

  if ped-venda.cod-cond-pag = 0 then  /** Pedido com condi‡Æo de pagamento especial **/
     assign c-cond-pagto = "0 - Especial".
  else do:
     find first cond-pagto where cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag no-lock no-error.
     assign c-cond-pagto = string(cond-pagto.cod-cond-pag, ">>9") + "-"  + substring(cond-pagto.descricao,1,19).
  end.  

  IF  ped-venda.nr-ind-finan <> 0 THEN DO:
      &IF DEFINED(bf_dis_gradiente) &THEN
          ASSIGN de-ind-fin = ped-venda.tab-ind-fin.
      &ELSE
          FIND FIRST tab-finan
               WHERE tab-finan.nr-tab-finan = ped-venda.nr-tab-finan NO-LOCK NO-ERROR.
          IF  AVAIL tab-finan THEN
              ASSIGN de-ind-fin = tab-finan.tab-ind-fin[ped-venda.nr-ind-finan].
      &ENDIF
  END.
  ELSE ASSIGN de-ind-fin = 1.

  run pi-calc-valor-aberto (input rowid(ped-venda),
                            input-output de-vl-a-aval). /** C lculo do valor em aberto pedido **/

  assign de-vl-a-aval = de-vl-a-aval * de-indice
         de-vl-aberto = ped-venda.vl-liq-abe * de-indice.

  if classifica = 1 then do: /** por cliente/nr-pedido **/                                    
     put ped-venda.nr-pedcli        format "x(12)"              " "
         ped-venda.no-ab-reppri     format "x(12)"              " "
         de-vl-aberto               format ">,>>>,>>>,>>9.99"   " "
         de-vl-a-aval               format ">>>,>>>,>>9.99"     " "
         c-moeda-ped                format "x(16)"              " "
         ped-venda.dt-entrega       format "99/99/9999"         " "
         ped-venda.dt-implant       format "99/99/9999"         " "
         ped-venda.nr-tab-finan                                 " "
         de-ind-fin                 format ">,>>>>>"            " "
         ped-venda.cod-estabel       format "x(03)"             " "
         c-cond-pagto                                           " "
         c-situacao                                             " "
         c-sit-aval                                             " " .
  end.
  else do:
     put ped-venda.dt-entrega     format "99/99/9999"              " "
         ped-venda.nr-pedcli      format "x(12)"                   " "
         ped-venda.no-ab-reppri   format "x(12)"                   " "
         de-vl-aberto             format ">,>>>,>>>,>>9.99"        " "
         de-vl-a-aval             format ">,>>>,>>>,>>9.99"        " "
         c-moeda-ped              format "x(16)"                   " "
         ped-venda.dt-implant     format "99/99/9999"              " "
         ped-venda.nr-tab-finan                                    " "
         de-ind-fin               format ">,>>>>>"                 " "
         ped-venda.cod-estabel    format "x(03)"                   " "
         c-cond-pagto                                              " "
         c-situacao                                                " "
         c-sit-aval                                                " ". 
  end.

  if tt-param.l-mot-recusa = yes and ped-venda.cod-sit-aval = 4  then do: /** NÆo aprovado **/

    put ped-venda.desc-bloq-cr .
  end.

  PUT SKIP.
  assign i-tot-ped    = i-tot-ped + 1
         de-tot-ped   = de-tot-ped + (ped-venda.vl-liq-abe * de-indice)
         de-tot-molim = de-tot-molim + de-vl-a-aval.




/*   if l-ultimo then do:                                                                                              */
/*      {utp/ut-liter.i "Total Pedidos Cliente: " * R}                                                                 */
/*      if classifica = 1 then do:                                                                                     */
/*         put skip(1).                                                                                                */
/*         put trim(return-value) at 1 format "x(24)"                                                                  */
/*             i-tot-ped    at 25                                                                                      */
/*             de-tot-ped   at 31                                                                                      */
/*             de-tot-molim at 50.                                                                                     */
/*         put skip(1).                                                                                                */
/*      end.                                                                                                           */
/*      else do:                                                                                                       */
/*         put skip(1).                                                                                                */
/*         put return-value at 1 format "x(24)"                                                                        */
/*             i-tot-ped    at 26                                                                                      */
/*             de-tot-ped   at 44                                                                                      */
/*             de-tot-molim at 65.                                                                                     */
/*         put skip(1).                                                                                                */
/*      end.                                                                                                           */
/*      if (de-tot-molim > emitente.lim-credito and                                                                    */
/*          emitente.ind-aval = 3) then do:                                                                            */
/*          {utp/ut-liter.i "Obs.: O saldo total dos pedidos em aberto do cliente excede seu limite de cr‚dito." + R}. */
/*          put return-value format "x(85)".                                                                           */
/*          put skip(1).                                                                                               */
/*      end.                                                                                                           */

/*      assign de-ger-ped   = de-ger-ped   + de-tot-ped   */
/*             de-ger-molim = de-ger-molim + de-tot-molim */
/*             i-ger-ped    = i-ger-ped    + i-tot-ped    */
/*             i-tot-ped    = 0                           */
/*             de-tot-ped   = 0                           */
/*             de-tot-molim = 0.                          */
/*   end.                                                 */
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


