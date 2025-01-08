/* ESTE PROGRAMA FOI CUSTOMIZADO APARTIR DO FT0904L E COMPILADO COM PREPROCESS PARA INCORPORAR TODAS AS INCLUDES */
    DEFINE VARIABLE l-log AS LOGICAL  INITIAL NO   NO-UNDO.
    def new global shared var c-arquivo-log    as char  format "x(60)" no-undo.
    DEFINE VARIABLE i-cod-unid-neg AS INTEGER     NO-UNDO.
    def var c-prg-vrs as char init "[[[[[[" no-undo.
    def var c-prg-obj as char no-undo.
    assign c-prg-vrs = "2.00.00.064"
           c-prg-obj = "esftp041l".


    if  c-arquivo-log <> "" and c-arquivo-log <> ? then do:
        find prog_dtsul where prog_dtsul.cod_prog_dtsul = "esftp041rp" no-lock no-error.

       if not avail prog_dtsul then do:
              if  c-prg-obj begins "btb":U then
                  assign c-prg-obj = "btb~/":U + c-prg-obj.
              else if c-prg-obj begins "men":U then
                      assign c-prg-obj = "men~/":U + c-prg-obj.
              else if c-prg-obj begins "sec":U then
                      assign c-prg-obj = "sec~/":U + c-prg-obj.
              else if c-prg-obj begins "utb":U then
                      assign c-prg-obj = "utb~/":U + c-prg-obj.
              find prog_dtsul where
                   prog_dtsul.nom_prog_ext begins c-prg-obj no-lock no-error.
       end .            /*if*/

        output to value(c-arquivo-log) append.

        if  avail prog_dtsul then do:
            if  prog_dtsul.nom_prog_dpc <> "" then
                put "DPC : ":U at 5 prog_dtsul.nom_prog_dpc  at 12 skip.
            if  prog_dtsul.nom_prog_appc <> "" then
                put "APPC: ":U at 5 prog_dtsul.nom_prog_appc at 12 skip.
            if  prog_dtsul.nom_prog_upc <> "" then
                put "UPC : ":U at 5 prog_dtsul.nom_prog_upc  at 12 skip.
        end.
        output close.        
    end.  
    error-status:error = no.

     def new global shared var i-ep-codigo-usuario  like mgcad.empresa.ep-codigo no-undo.
     def new Global shared var l-implanta           as logical    init no.
     def new Global shared var c-seg-usuario        as char format "x(12)" no-undo.
     def new global shared var i-num-ped-exec-rpw   as integer no-undo.   
     def var rw-log-exec                            as rowid no-undo.
     def new global shared var i-pais-impto-usuario as integer format ">>9" no-undo.
     def new global shared var l-rpc as logical no-undo.
     def var c-erro-rpc as character format "x(60)" initial " " no-undo.
     def var c-erro-aux as character format "x(60)" initial " " no-undo.
     def var c-ret-temp as char no-undo.
     def var h-servid-rpc as handle no-undo.     
     def new global shared var r-registro-atual as rowid no-undo.
     def new global shared var c-arquivo-log    as char  format "x(60)"no-undo.
     def new global shared var h-rsocial as handle no-undo.
     def new global shared var l-achou-prog as logical no-undo.

      /* Variáveis Padrão DWB / Datasul HR */
     def new global shared var i-num-ped as integer no-undo.         
     def new global shared var v_cdn_empres_usuar   like mgcad.empresa.ep-codigo        no-undo.
     def new global shared var v_cod_usuar_corren   like usuar_mestre.cod_usuario no-undo.
     def new global shared var h_prog_segur_estab     as handle                   no-undo.
     def new global shared var v_cod_grp_usuar_lst    as char                     no-undo.
     def new global shared var v_num_tip_aces_usuar   as int                      no-undo.

     /*Alteracao 02/11/2006 - tech1007 - FO 1407866 - Criacao de nova vari vel global*/
     /*def new global shared var v_cdn_empresa_evento like mgcad.empresa.ep-codigo.*/
     /*def new global shared var v_cdn_empresa_evento  As Integer      No-undo.*/

    /* Retorno RPC */

     {upc/btb910za-upc.i} /* Defini‡Æo da vari vel New Global Shared "v_cod_estab_usuar_intelbras" */

    procedure pi-seta-return-value:
    def input param ret as char no-undo.
    return ret.
  end procedure.


/* Retorno RPC */

def new global shared var i-ep-codigo-usuario  like mgcad.empresa.ep-codigo no-undo.     
     
define temp-table tt-epc no-undo
   field cod-event     as char format "x(12)"
   field cod-parameter as char format "x(32)"
   field val-parameter as char format "x(54)"
   index  id is primary cod-parameter cod-event ascending.    
   
/* end_temp_table_definition */   
    

  def var c-nom-prog-dpc-mg97  as char init "" no-undo.   
  def var c-nom-prog-appc-mg97 as char init "" no-undo.
  def var c-nom-prog-upc-mg97  as char init "" no-undo.
  def var raw-rowObject        as raw          no-undo.

   
find prog_dtsul where prog_dtsul.cod_prog_dtsul = "ft0904l" no-lock no-error.
if  avail prog_dtsul then do:
    assign c-nom-prog-dpc-mg97  = prog_dtsul.nom_prog_dpc
           c-nom-prog-appc-mg97 = prog_dtsul.nom_prog_appc
           c-nom-prog-upc-mg97  = prog_dtsul.nom_prog_upc.
end.          
/* i-epc200.i */
 
def buffer b-sumar-rec        for sumar-ft.
def buffer b-it-fatura        for it-nota-fisc.
def buffer b-nota-fatura      for nota-fiscal.

def shared var i-id           as integer no-undo.
def shared var c-id           as character no-undo.
def shared var l-achou        as logical init yes no-undo.
def shared var i-cont         as int.
def shared var r-inicio       as rowid.
def shared var r-ultimo       as rowid.
def var de-vl-contab          like sumar-ft.vl-contab no-undo. 
def shared var r-nota         as rowid no-undo.
def shared var r-conta-ft     as rowid .
def var c-desc-conta          like conta-contab.titulo.
def var dec-1                 like estabelec.sc-fins-pg.
def var de-taxa-cofins        as dec.
def var de-taxa-pis           as dec.
def var de-vl-desconto        like nota-fiscal.perc-desco1 no-undo.

def var de-vl-total-pis-por-unidade     as decimal no-undo.
def var de-vl-total-cofins-por-unidade  as decimal no-undo.

DEF VAR de-descto-zfm-pis    AS DECIMAL NO-UNDO.
DEF VAR de-descto-zfm-cofins AS DECIMAL NO-UNDO.

DEF VAR c-conta-debito       AS CHAR    NO-UNDO.

DEF VAR c-estab-ent-fut AS CHAR NO-UNDO.
DEF VAR l-leitura-item  AS LOG  NO-UNDO INITIAL YES.

def var i-empresa like param-global.empresa-prin   no-undo.

/** added **/
def var de-vl-descicms        like it-nota-fisc.vl-merc-liq.
def var de-vl-aux             like de-vl-contab.

/* Lei 10925 */
def var l-ret-fat as log no-undo.

def new shared temp-table w-item
    field nr-sequencia like it-nota-fisc.nr-seq-fat
    field desconto     like it-nota-fisc.vl-tot-item
    field vl-tot-item  like it-nota-fisc.vl-tot-item.

def shared temp-table tt-ped-curva
    field it-codigo      like nota-fiscal.cod-estabel  
    field serie          like nota-fiscal.serie                
    field nr-nota-fis    like nota-fiscal.nr-nota-fis 
    field ct-codigo      like conta-ft.ct-recven
    FIELD sc-codigo      LIKE conta-ft.sc-recven
    field ct-desc        AS CHAR
    FIELD sc-desc        AS CHAR
    field dec-1          like sumar-ft.vl-contab
    field vl-credito     like sumar-ft.vl-contab
    field vl-debito      like sumar-ft.vl-contab
    
    .

def var h-cd9500       as handle no-undo.

/*As temp-tables tt-auxiliar e tt-auxiliar-aux sÆo tamb‚m utilizadas 
  no programa ex3200.p definidas na include ft0708.i1*/


DEF NEW GLOBAL SHARED VAR lContaFtPorCliente AS LOG NO-UNDO INIT ?.

IF  lContaFtPorCliente = ? THEN
    ASSIGN lContaFtPorCliente = 
              CAN-FIND(funcao 
                        WHERE funcao.cd-funcao = "spp-ContaFtCli":U
                        AND   funcao.ativo NO-LOCK).
/**************ISS RETIDO ****************************/
DEF VAR l-funcao-iss-retido AS LOG NO-UNDO INITIAL NO.


    ASSIGN l-funcao-iss-retido = CAN-FIND (FIRST funcao
                                           WHERE funcao.cd-funcao = "spp-iss-retido":U
                                           AND   funcao.ativo).

/****************************************************/

find first param-global no-lock no-error.

find nota-fiscal where rowid(nota-fiscal) = r-nota no-lock no-error.
find estabelec
    where estabelec.cod-estabel = nota-fiscal.cod-estabel
    no-lock no-error.

find emitente
    where emitente.nome-abrev = nota-fiscal.nome-ab-cli
    no-lock no-error.

for each w-item:
    delete w-item.
end.

if  substring(nota-fiscal.nat-operacao,1,1) = "5"
and estabelec.estado                        = "AM"
/*and emitente.atividade                      = "lojista"*/ then do:
    run ftp/ft0904n.p (rowid(nota-fiscal)).
end.

if (nota-fiscal.dt-cancela    = ?
and nota-fiscal.ind-tip-nota <> 7
and nota-fiscal.esp-docto    <> 21) /*"NFE"*/ = no then next.

find first fat-duplic 
     where fat-duplic.cod-estabel = nota-fiscal.cod-estabel
       and fat-duplic.serie       = nota-fiscal.serie
       and fat-duplic.nr-fatura   = nota-fiscal.nr-fatura
       no-lock no-error.
if  avail fat-duplic and
    
        fat-duplic.log-impto-retid = YES then
    
    assign l-ret-fat = yes.
else
    assign l-ret-fat = no.


/*** Intgra‡Æo com o M¢dulo de Exporta‡Æo - Contabiliza‡Æo das Despesas de Exporta‡Æo ***/



run cdp/cd9500.p persistent set h-cd9500.

itens:
    for each  it-nota-fisc use-index ch-nota-item
        where it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
        and   it-nota-fisc.serie       = nota-fiscal.serie
        and   it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
        no-lock,
       each natur-oper where 
            natur-oper.nat-ope            = it-nota-fisc.nat-oper and
            natur-oper.ind-contabilizacao = yes no-lock .

        IF  ( it-nota-fisc.vl-ipi-it      = 0                OR
              it-nota-fisc.cd-trib-ipi    = 3 ) /* outras */ AND  
            ( it-nota-fisc.vl-icms-it     = 0                OR
              it-nota-fisc.cd-trib-icm    = 3 ) /* outras */ AND
              it-nota-fisc.vl-icmsub-it   = 0                AND
              it-nota-fisc.vl-iss-it      = 0                AND
              it-nota-fisc.vl-irf-it      = 0                AND
              DEC(SUBSTR(it-nota-fisc.char-2,76,5)) = 0      AND 
              DEC(SUBSTR(it-nota-fisc.char-2,81,5)) = 0      AND
              it-nota-fisc.emite-duplic   = NO               AND
              it-nota-fisc.val-unit-cofins                 = 0           AND
              it-nota-fisc.val-unit-pis                    = 0           THEN
              NEXT itens.

        find item where item.it-codigo = it-nota-fisc.it-codigo
                   no-lock no-error.

        run pi-cd9500 in h-cd9500(nota-fiscal.cod-estabel,
                                  emitente.cod-gr-cli,
                                  rowid(item),
                                  it-nota-fisc.nat-oper,
                                  (IF lContaFtPorCliente THEN string(nota-fiscal.cod-emitente) ELSE it-nota-fisc.serie),
                                  it-nota-fisc.cod-depos,
                                  nota-fiscal.cod-canal-venda,
                                  output r-conta-ft).

/*        run cdp/cd9500.p (input nota-fiscal.cod-estabel,
 *                           input emitente.cod-gr-cli,
 *                           input rowid(item),
 *                           input it-nota-fisc.nat-oper,
 *                           input it-nota-fisc.serie,
 *                           input it-nota-fisc.cod-depos,
 *                           input nota-fiscal.cod-canal-venda,
 *                           output r-conta-ft).      */

        find conta-ft
             where rowid(conta-ft) = r-conta-ft no-lock no-error.

         if  not avail conta-ft   or 
            not avail natur-oper or
            not avail item then
            next itens.

        

        find first w-item 
             where w-item.nr-sequencia = it-nota-fisc.nr-seq-fat
             no-lock no-error.

        /* DESCONTOS */

       /********************************************************************************
**
** Programa : FT0904.I8
**
** Autor    : DATASUL S.A
**
** Objetivo : Calcular o desconto de ICMS 
******************************************************************************/

ASSIGN de-descto-zfm-pis    = 0
       de-descto-zfm-cofins = 0.



     IF  natur-oper.log-deduz-desc-zfm-tot-nf = YES THEN
         ASSIGN de-descto-zfm-pis    = natur-oper.val-perc-desc-pis-zfm    
                de-descto-zfm-cofins = natur-oper.val-perc-desc-cofins-zfm   .


assign de-vl-descicms = (1 - (dec(substring(natur-oper.char-2,66,5)) + de-descto-zfm-pis + de-descto-zfm-cofins) / 100) *
                        (1 - it-nota-fisc.per-des-icms              / 100)
       de-vl-descicms = it-nota-fisc.vl-merc-liq / de-vl-descicms
       de-vl-descicms = de-vl-descicms - it-nota-fisc.vl-merc-liq
       de-vl-descicms = if  de-vl-descicms < 0 then 0 else de-vl-descicms.
  /* desconto de ICMS */
       /********************************************************************************
**
** Programa : FT0904.I9
**
** Autor    : DATASUL S.A
**
** Objetivo : Acumular todos os descontos
******************************************************************************/

assign de-vl-desconto = nota-fiscal.perc-desco1                   +
                        nota-fiscal.perc-desco2                   +
                        it-nota-fisc.per-des-item                 +
                        decimal(substr(it-nota-fisc.char-1,1,14)) 
                     
                                                                  +
                        nota-fiscal.val-pct-desconto-tab-preco    +
                        it-nota-fisc.val-pct-desconto-periodo     + 
                        it-nota-fisc.val-pct-desconto-prazo       +
                        it-nota-fisc.val-pct-desconto-tab-preco   +
                        it-nota-fisc.val-desconto-inform          +
                        nota-fiscal.desc-valor-nota.                    
                     
                     .

        DO i-cont = 1 TO 5:
           ASSIGN de-vl-desconto = de-vl-desconto + it-nota-fisc.val-desconto[i-cont]. 
        END.

                     

                     



    
  /* descontos dos itens e da nota fiscal */

        if  it-nota-fisc.vl-tot-item >= 0
        and de-vl-desconto > 0  /* ft0904.i9 */
        and it-nota-fisc.vl-merc-ori > ( it-nota-fisc.vl-merc-liq + de-vl-descicms )
        and natur-oper.emite-dupli   = yes
        and conta-ft.cod-cta-desc      <> ""  /* possui conta cadastrada */
        and estabelec.ct-desconto <> "" /* possui conta cadastrada */
        and (conta-ft.cod-cta-desc + conta-ft.cod-ccusto-desc = estabelec.ct-desconto + estabelec.sc-desconto) = no /*partida<>contra*/
        and nota-fiscal.emite-duplic = yes then
        do:
            assign de-vl-contab = it-nota-fisc.vl-merc-ori
                                - it-nota-fisc.vl-merc-liq
                                - de-vl-descicms
                   de-vl-aux    = de-vl-contab.

        /* EVERTON - INICIO ****************************************************************/
            /* executa UPC para alterar o valor do desconto */
            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = "Change_de-vl-desconto"
                   tt-epc.cod-parameter = "rowid_it-nota-fisc"
                   tt-epc.val-parameter = string(rowid(it-nota-fisc)).
            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = "Change_de-vl-desconto"
                   tt-epc.cod-parameter = "de-vl-desconto"
                   tt-epc.val-parameter = string(de-vl-contab). /* valor do desconto */
        
            /***************************************************************
**
** I-EPC201.I - Padroniza a chamada dos programas de integração/
**              customização.
**
**
***************************************************************/ 

/* begin_epc_call*/

/* DPC */
if c-nom-prog-dpc-mg97  <> "" and
   c-nom-prog-dpc-mg97  <> ?  then do:
   
   run value( c-nom-prog-dpc-mg97  ) 
            ( "Change_de-vl-desconto", 
              input-output table tt-epc
            ).
end.                                     

/* APPC */
if c-nom-prog-appc-mg97  <> "" and
   c-nom-prog-appc-mg97  <> ?  then do:
   
   run value( c-nom-prog-appc-mg97  ) 
            ( "Change_de-vl-desconto", 
              input-output table tt-epc
            ).
end.                                     

/* UPC */
if c-nom-prog-upc-mg97   <> "" and
   c-nom-prog-upc-mg97   <> ?  then do:
   
      run value( c-nom-prog-upc-mg97  )
            ( "Change_de-vl-desconto", 
               input-output table tt-epc
            ).        
end.

/* end_epc_call*/
 

            /* trata retorno da UPC */
            FIND FIRST tt-epc
                 WHERE tt-epc.cod-event     = "Change_de-vl-desconto"
                 AND   tt-epc.cod-parameter = "de-vl-desconto" NO-ERROR.
            IF  AVAIL tt-epc THEN
                ASSIGN de-vl-contab = decimal(tt-epc.val-parameter).

            FOR EACH tt-epc:
                DELETE tt-epc.
            END.            

        /* EVERTON - FIM  ****************************************************************/
            /* estabelec */
            RUN pi-ped-curva(INPUT estabelec.ct-desconto, INPUT estabelec.sc-desconto, INPUT de-vl-contab).
            IF l-log THEN
                PUT "1 " estabelec.ct-desconto + estabelec.sc-desconto SKIP.

            assign de-vl-contab = de-vl-contab * -1.

            RUN pi-ped-curva(INPUT conta-ft.cod-cta-desc, INPUT conta-ft.cod-ccusto-desc, INPUT de-vl-contab).
            IF l-log THEN
                PUT "2 " conta-ft.cod-cta-desc + conta-ft.cod-ccusto-desc SKIP.

            /********AGREGAR DESCONTO NA RECEITA/TRANSITORIA******/

            assign de-vl-contab = it-nota-fisc.vl-merc-ori
                                - it-nota-fisc.vl-merc-liq
                                - de-vl-descicms
                   de-vl-aux    = de-vl-contab.

        /* EVERTON - INICIO ****************************************************************/
            /* executa UPC para alterar o valor da receita */
            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = "Change_de-vl-receita"
                   tt-epc.cod-parameter = "rowid_it-nota-fisc"
                   tt-epc.val-parameter = string(rowid(it-nota-fisc)).
            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = "Change_de-vl-receita"
                   tt-epc.cod-parameter = "de-vl-receita"
                   tt-epc.val-parameter = string(de-vl-contab). /* valor do desconto */
        
            /***************************************************************
**
** I-EPC201.I - Padroniza a chamada dos programas de integração/
**              customização.
**
**
***************************************************************/ 

/* begin_epc_call*/

/* DPC */
if c-nom-prog-dpc-mg97  <> "" and
   c-nom-prog-dpc-mg97  <> ?  then do:
   
   run value( c-nom-prog-dpc-mg97  ) 
            ( "Change_de-vl-receita", 
              input-output table tt-epc
            ).
end.                                     

/* APPC */
if c-nom-prog-appc-mg97  <> "" and
   c-nom-prog-appc-mg97  <> ?  then do:
   
   run value( c-nom-prog-appc-mg97  ) 
            ( "Change_de-vl-receita", 
              input-output table tt-epc
            ).
end.                                     

/* UPC */
if c-nom-prog-upc-mg97   <> "" and
   c-nom-prog-upc-mg97   <> ?  then do:
   
      run value( c-nom-prog-upc-mg97  )
            ( "Change_de-vl-receita", 
               input-output table tt-epc
            ).        
end.

/* end_epc_call*/
 

            /* trata retorno da UPC */
            FIND FIRST tt-epc
                 WHERE tt-epc.cod-event     = "Change_de-vl-receita"
                 AND   tt-epc.cod-parameter = "de-vl-receita" NO-ERROR.
            IF  AVAIL tt-epc THEN
                ASSIGN de-vl-contab = decimal(tt-epc.val-parameter).

            FOR EACH tt-epc:
                DELETE tt-epc.
            END.            

        /* EVERTON - FIM  ****************************************************************/

            /* estabelec */

            /*** Integracao com o Modulo de Exportacao - Verifica se esta rodando do ambiente hibrido ***/
            
                /*** Se nao estiver rodando no hibrido entao credita Receita de Vendas - como o produto normal ja faz ***/
                RUN pi-ped-curva (INPUT conta-ft.ct-recven, INPUT conta-ft.sc-recven, INPUT de-vl-contab).
                IF l-log THEN
                    PUT "3 " conta-ft.ct-recven + conta-ft.sc-recven SKIP.

                ASSIGN de-vl-contab = de-vl-contab * -1.
                RUN pi-ped-curva (INPUT estabelec.ct-recven, INPUT estabelec.sc-recven, INPUT de-vl-contab).            
                IF l-log THEN
                    PUT "4 " estabelec.ct-recven + estabelec.sc-recven SKIP.
        END.

        /* RECEITA BRUTA DE VENDAS */

        if  it-nota-fisc.vl-tot-item > 0
        and it-nota-fisc.emite-duplic 
        and nota-fiscal.emite-duplic  then do:

            run pi-vl-contabil.

            ASSIGN c-conta-debito  = "".

            /*** Integra‡Æo com o m¢dulo de Exporta‡Æo ***/
            
                /*** Se nÆo estiver utilizando a integra‡Æo com o com‚rcio exterior ***/

            RUN pi-ped-curva(INPUT conta-ft.ct-recven, INPUT conta-ft.sc-recven, INPUT de-vl-contab).
            IF l-log THEN
                PUT "5 " conta-ft.ct-recven + conta-ft.sc-recven SKIP.

            assign de-vl-contab = de-vl-contab * (-1).

            /* ######### */
            if   nota-fiscal.ind-tip-nota = 3 /*Diferenca de Pre‡o*/
            and  substring(nota-fiscal.nat-operacao,1,1) = "7" /* Exportacao */
            then do :

                /*
                
                NÇO EXISTEM REGISTROS NA TABELA conta-cr.
                COMENTADO CONFORME ORIENTA€ÇO DE FABIANO
                
                find first fat-duplic
                where fat-duplic.cod-estabel  = nota-fiscal.cod-estabel
                and   fat-duplic.serie        = nota-fiscal.serie
                and   fat-duplic.nr-fatura    = nota-fiscal.nr-fatura
                and   fat-duplic.mo-negoc     > 0 
                no-lock no-error.

                if  avail fat-duplic then do:
                    find conta-cr where
                         conta-cr.ep-codigo = i-ep-codigo-usuario and
                         conta-cr.cod-estabel = nota-fiscal.cod-estabel and
                         conta-cr.cod-esp     = fat-duplic.cod-esp and
                         conta-cr.cod-gr-cli  = emitente.cod-gr-cli no-lock no-error.
                    if  avail conta-cr then do:
                    RUN pi-ped-curva(INPUT conta-cr.conta-var-monetaria, INPUT "", INPUT de-vl-contab).   /* Migra‡Æo Totvs 11 - Falta identificar o campo SC-Codigo desta conta */
                    IF l-log THEN
                        PUT "6 " conta-cr.conta-var-monetaria + "" SKIP.  /* Migra‡Æo Totvs 11 - Falta identificar o campo SC-Codigo desta conta */

                    end.
                end.*/
            end.
            else do:
                 RUN pi-ped-curva(INPUT estabelec.ct-recven, INPUT estabelec.sc-recven, INPUT de-vl-contab).
                 IF l-log THEN
                    PUT "7 " estabelec.ct-recven + estabelec.sc-recven SKIP.
            end.
            /* ######### */
        end.

        if  int(substr(natur-oper.char-1,1,5)) = 1
        and natur-oper.ind-est-qtd             = yes
        and nota-fiscal.int-2                  > 2000
        and it-nota-fisc.nr-nota-ant           > "" then 
        do:
            ASSIGN c-estab-ent-fut = it-nota-fisc.cod-estabel.
            /* INICIO - Ponto de chamada para trocar o estabelecimento de validacao da NF entrega futura */
            IF  c-nom-prog-dpc-mg97  <> "" 
            OR  c-nom-prog-appc-mg97 <> "" 
            OR  c-nom-prog-upc-mg97  <> "" THEN DO:
                FOR EACH tt-epc:
                    DELETE tt-epc.
                END.
                /********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/********************************************************************************
** Programa : include/i-epc200.i2
**
** Data : 04/05/1999
**
** Criacao : John Cleber Jaraceski
**
** Objetivo : Padronizar a criacao de registro para a Temp-Table tt-epc. 
**            Esta Temp-Table ‚ utilizada em programas em EPCs de Pontos Estrat.
** 
** Parametros :
**
** Ultima Alt : 
*******************************************************************************/


    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = 'BuscaEstEntFutura'
           tt-epc.cod-parameter = 'TABLE-ROWID'
           tt-epc.val-parameter = STRING(ROWID(it-nota-fisc)).

 
                /********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/********************************************************************************
** Programa : include/i-epc200.i2
**
** Data : 04/05/1999
**
** Criacao : John Cleber Jaraceski
**
** Objetivo : Padronizar a criacao de registro para a Temp-Table tt-epc. 
**            Esta Temp-Table ‚ utilizada em programas em EPCs de Pontos Estrat.
** 
** Parametros :
**
** Ultima Alt : 
*******************************************************************************/


    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = 'BuscaEstEntFutura'
           tt-epc.cod-parameter = 'EstEntFut'
           tt-epc.val-parameter = c-estab-ent-fut.

 
                                     
                /********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/********************************************************************************
** Programa : include/i-epc200.i2
**
** Data : 04/05/1999
**
** Criacao : John Cleber Jaraceski
**
** Objetivo : Padronizar a criacao de registro para a Temp-Table tt-epc. 
**            Esta Temp-Table ‚ utilizada em programas em EPCs de Pontos Estrat.
** 
** Parametros :
**
** Ultima Alt : 
*******************************************************************************/


    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = 'BuscaEstEntFutura'
           tt-epc.cod-parameter = 'LeituraItem'
           tt-epc.val-parameter = STRING(ROWID(conta-ft)).

 
                                     
                /***************************************************************
**
** I-EPC201.I - Padroniza a chamada dos programas de integração/
**              customização.
**
**
***************************************************************/ 

/* begin_epc_call*/

/* DPC */
if c-nom-prog-dpc-mg97  <> "" and
   c-nom-prog-dpc-mg97  <> ?  then do:
   
   run value( c-nom-prog-dpc-mg97  ) 
            ( "BuscaEstEntFutura", 
              input-output table tt-epc
            ).
end.                                     

/* APPC */
if c-nom-prog-appc-mg97  <> "" and
   c-nom-prog-appc-mg97  <> ?  then do:
   
   run value( c-nom-prog-appc-mg97  ) 
            ( "BuscaEstEntFutura", 
              input-output table tt-epc
            ).
end.                                     

/* UPC */
if c-nom-prog-upc-mg97   <> "" and
   c-nom-prog-upc-mg97   <> ?  then do:
   
      run value( c-nom-prog-upc-mg97  )
            ( "BuscaEstEntFutura", 
               input-output table tt-epc
            ).        
end.

/* end_epc_call*/
 

                FOR EACH tt-epc
                    WHERE tt-epc.cod-event     = "BuscaEstEntFutura":U:

                    IF  tt-epc.cod-parameter = "EstEntFut":U THEN
                        ASSIGN c-estab-ent-fut = IF tt-epc.val-parameter <> ""
                                                 THEN tt-epc.val-parameter
                                                 ELSE c-estab-ent-fut.
                    /* esse registro deve ser criado dentro da upc */
                    IF  tt-epc.cod-parameter = "AlteraLeituraItem":U THEN
                        ASSIGN l-leitura-item = (tt-epc.val-parameter = "YES":U). 
                END.
                FOR EACH tt-epc:
                    DELETE tt-epc.
                END.
            END.
            /* FIM - Ponto de chamada para trocar o estabelecimento de validacao da NF entrega futura */
            /* Localiza nota fiscal Fatura (1a Nota) */
            find b-nota-fatura 
                where b-nota-fatura.cod-estabel  = c-estab-ent-fut
                and   b-nota-fatura.serie        = it-nota-fisc.serie-ant
                and   b-nota-fatura.nr-nota-fis  = it-nota-fisc.nr-nota-ant
                and   b-nota-fatura.int-2        > 2000  NO-LOCK NO-ERROR.

            IF  l-leitura-item  THEN
                find first b-it-fatura of b-nota-fatura
                     where b-it-fatura.it-codigo = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.
            ELSE 
                find first b-it-fatura of b-nota-fatura NO-LOCK NO-ERROR.

            if  avail b-nota-fatura then do:

                
                find b-sumar-rec 
                     where b-sumar-rec.cod-estabel = b-nota-fatura.cod-estabel
                     and   b-sumar-rec.dt-movto    = b-nota-fatura.dt-emis-nota
                     and   b-sumar-rec.ct-conta    = b-it-fatura.ct-cusven
                     and   b-sumar-rec.sc-conta    = b-it-fatura.sc-cusven
                     and   b-sumar-rec.serie       = b-nota-fatura.serie
                     and   b-sumar-rec.tp-imposto  = 0
                     and   b-sumar-rec.nr-nota-fis = b-nota-fatura.nr-nota-fis 
                     no-lock no-error.

                if   avail b-sumar-rec then
                     assign de-vl-contab = if  b-sumar-rec.vl-contab <= it-nota-fisc.vl-tot-item 
                                           then b-sumar-rec.vl-contab
                                           else it-nota-fisc.vl-tot-item - (IF  it-nota-fisc.cd-trib-ipi <> 3 /* outras */
                                                                            THEN it-nota-fisc.vl-ipi-it
                                                                            ELSE 0).

                RUN pi-ped-curva(INPUT conta-ft.ct-recven, INPUT conta-ft.sc-recven, INPUT de-vl-contab).
                IF l-log THEN
                    PUT "8 " conta-ft.ct-recven + conta-ft.sc-recven SKIP.

                assign de-vl-contab = de-vl-contab * (-1).
                RUN pi-ped-curva(INPUT b-it-fatura.ct-cusven, INPUT b-it-fatura.sc-cusven, INPUT de-vl-contab). /* Saida da receita futura */
                IF l-log THEN
                    PUT "9 "b-it-fatura.ct-cusven + b-it-fatura.sc-cusven SKIP.


                /*--- INICIO - Ponto de chamada para alterar registros da tt-ped-curva j  existentes, e incluir mais registros [TV-PARANA - Liziane - 06/2008] ---*/
                IF  c-nom-prog-dpc-mg97  <> "" 
                OR  c-nom-prog-appc-mg97 <> "" 
                OR  c-nom-prog-upc-mg97  <> "" THEN DO:

                    FOR EACH tt-epc:
                        DELETE tt-epc.
                    END.

                    /********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/********************************************************************************
** Programa : include/i-epc200.i2
**
** Data : 04/05/1999
**
** Criacao : John Cleber Jaraceski
**
** Objetivo : Padronizar a criacao de registro para a Temp-Table tt-epc. 
**            Esta Temp-Table ‚ utilizada em programas em EPCs de Pontos Estrat.
** 
** Parametros :
**
** Ultima Alt : 
*******************************************************************************/


    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = 'TrataTTPedCurva'
           tt-epc.cod-parameter = 'rowid-it-nota-fisc'
           tt-epc.val-parameter = STRING(ROWID(it-nota-fisc)).

 
                    
                    /***************************************************************
**
** I-EPC201.I - Padroniza a chamada dos programas de integração/
**              customização.
**
**
***************************************************************/ 

/* begin_epc_call*/

/* DPC */
if c-nom-prog-dpc-mg97  <> "" and
   c-nom-prog-dpc-mg97  <> ?  then do:
   
   run value( c-nom-prog-dpc-mg97  ) 
            ( "TrataTTPedCurva", 
              input-output table tt-epc
            ).
end.                                     

/* APPC */
if c-nom-prog-appc-mg97  <> "" and
   c-nom-prog-appc-mg97  <> ?  then do:
   
   run value( c-nom-prog-appc-mg97  ) 
            ( "TrataTTPedCurva", 
              input-output table tt-epc
            ).
end.                                     

/* UPC */
if c-nom-prog-upc-mg97   <> "" and
   c-nom-prog-upc-mg97   <> ?  then do:
   
      run value( c-nom-prog-upc-mg97  )
            ( "TrataTTPedCurva", 
               input-output table tt-epc
            ).        
end.

/* end_epc_call*/
 

                    FOR EACH tt-epc:
                        DELETE tt-epc.
                    END.
                END.
                /*--- FIM ---*/

            end.         
        end.

        /* IPI */
        if  it-nota-fisc.vl-ipi-it > 0 and
            it-nota-fisc.cd-trib-ipi <> 3 then do:
            assign de-vl-contab = it-nota-fisc.vl-ipi-it.
            RUN pi-ped-curva(INPUT estabelec.ct-ipi-ft, INPUT estabelec.sc-ipi-ft, INPUT de-vl-contab). 
            IF l-log THEN
                PUT "10 " estabelec.ct-ipi-ft + estabelec.sc-ipi-ft SKIP.

            assign de-vl-contab = de-vl-contab * (-1).
            RUN pi-ped-curva(INPUT conta-ft.ct-ipi-ft, INPUT conta-ft.sc-ipi-ft, INPUT de-vl-contab).
            IF l-log THEN
                PUT "11 " conta-ft.nat-operacao " " conta-ft.cod-estabel " "
                conta-ft.cod-gr-cli " " conta-ft.ct-ipi-ft + conta-ft.sc-ipi-ft SKIP.

        end.

        /* ICMS */

        if  it-nota-fisc.vl-icms-it > 0 and
            it-nota-fisc.cd-trib-icm <> 3 then do:
            assign de-vl-contab = it-nota-fisc.vl-icms-it.
            RUN pi-ped-curva(INPUT estabelec.ct-icms-ft, INPUT estabelec.sc-icms-ft, INPUT de-vl-contab). 
            IF l-log THEN
                PUT "12 " estabelec.ct-icms-ft + estabelec.sc-icms-ft SKIP.

            assign de-vl-contab = de-vl-contab * (-1).
            RUN pi-ped-curva(INPUT conta-ft.ct-icms-ft, INPUT conta-ft.sc-icms-ft, INPUT de-vl-contab).
            IF l-log THEN
                PUT "13 " conta-ft.ct-icms-ft + conta-ft.sc-icms-ft SKIP.

        end.

        /* ICMSUB ICM DE SUBSTITUICAO TRIBUTARIA */

        if  it-nota-fisc.vl-icmsub-it > 0 then do:
            assign de-vl-contab = it-nota-fisc.vl-icmsub-it.
            RUN pi-ped-curva(INPUT estabelec.ct-icmsub-ft, INPUT estabelec.sc-icmsub-ft, INPUT de-vl-contab).
            IF l-log THEN
                PUT "14 " estabelec.ct-icmsub-ft + estabelec.sc-icmsub-ft SKIP.

            assign de-vl-contab = de-vl-contab * (-1).
            RUN pi-ped-curva(INPUT conta-ft.ct-icmsub-ft, INPUT conta-ft.sc-icmsub-ft, INPUT de-vl-contab).
            IF l-log THEN
                PUT "15 " conta-ft.ct-icmsub-ft + conta-ft.sc-icmsub-ft SKIP.

        end.



         /* ISS */
        if  it-nota-fisc.vl-iss-it > 0 then do:
            assign de-vl-contab = it-nota-fisc.vl-iss-it.
            RUN pi-ped-curva(INPUT estabelec.ct-iss, INPUT estabelec.sc-iss, INPUT de-vl-contab). 
            IF l-log THEN
                PUT "16 " estabelec.ct-iss + estabelec.sc-iss SKIP.

            assign de-vl-contab = de-vl-contab * (-1).
            RUN pi-ped-curva(INPUT conta-ft.ct-iss-ft, INPUT conta-ft.sc-iss-ft, INPUT de-vl-contab).
            IF l-log THEN
                PUT "17 " conta-ft.ct-iss-ft + conta-ft.sc-iss-ft SKIP.

         end.


          /* I.R.R.F. */
         if  it-nota-fisc.vl-irf-it > 0 then do:
             assign de-vl-contab = it-nota-fisc.vl-irf-it.
             RUN pi-ped-curva(INPUT estabelec.ct-recven, INPUT estabelec.sc-recven, INPUT de-vl-contab). 
             IF l-log THEN
                PUT "18 " estabelec.ct-recven + estabelec.sc-recven SKIP.

             assign de-vl-contab = de-vl-contab *  (-1).
             RUN pi-ped-curva(INPUT conta-ft.ct-ir-ret, INPUT conta-ft.sc-ir-ret, INPUT de-vl-contab).
             IF l-log THEN
                PUT "19 " conta-ft.ct-ir-ret + conta-ft.sc-ir-ret SKIP.

         end.

         /* Reten‡Æo CSLL */
         if  it-nota-fisc.val-retenc-csll > 0 
         AND l-ret-fat then do:
              assign de-vl-contab  = it-nota-fisc.val-retenc-csll.
             RUN pi-ped-curva(INPUT estabelec.ct-recven, INPUT estabelec.sc-recven, INPUT de-vl-contab).
             IF l-log THEN
                PUT "20 " estabelec.ct-recven + estabelec.sc-recven SKIP.

             assign de-vl-contab = de-vl-contab * (-1).
             RUN pi-ped-curva(INPUT conta-ft.cod-cta-retenc-csll, INPUT conta-ft.cod-ccusto-retenc-csll, INPUT de-vl-contab).
             IF l-log THEN
                PUT "21 " conta-ft.cod-cta-retenc-csll + conta-ft.cod-ccusto-retenc-csll SKIP.

         end.

         /* Retencao PIS/PASEP */
         if  it-nota-fisc.val-retenc-pis > 0 
         AND l-ret-fat then do:

             assign de-vl-contab  = it-nota-fisc.val-retenc-pis.
             RUN pi-ped-curva(INPUT estabelec.ct-recven, INPUT estabelec.sc-recven, INPUT de-vl-contab).
             IF l-log THEN
                PUT "22 " estabelec.ct-recven + estabelec.sc-recven SKIP.

             assign de-vl-contab = de-vl-contab * (-1).
             RUN pi-ped-curva(INPUT conta-ft.cod-cta-retenc-pis, INPUT conta-ft.cod-ccusto-retenc-pis, INPUT de-vl-contab).
             IF l-log THEN
                PUT "23 " conta-ft.cod-cta-retenc-pis + conta-ft.cod-ccusto-retenc-pis SKIP.

         end.

         /* Retencao COFINS */
         if  it-nota-fisc.val-retenc-cofins > 0 
         AND l-ret-fat then do:

             assign de-vl-contab  = it-nota-fisc.val-retenc-cofins.
             RUN pi-ped-curva(INPUT estabelec.ct-recven, INPUT estabelec.sc-recven, INPUT de-vl-contab).
             IF l-log THEN
                PUT "24 " estabelec.ct-recven + estabelec.sc-recven SKIP.

             assign de-vl-contab = de-vl-contab * (-1).
             RUN pi-ped-curva(INPUT conta-ft.cod-cta-retenc-cofins, INPUT conta-ft.cod-ccusto-retenc-cofins, INPUT de-vl-contab).
             IF l-log THEN
                PUT "25 " conta-ft.cod-cta-retenc-cofins + conta-ft.cod-ccusto-retenc-cofins SKIP.

         end.

         /* I.N.S.S. */

        if  it-nota-fisc.vl-ir-adic > 0 then 

            if  int(substr(natur-oper.char-2,71,5)) = 1 then do: /* Indica se possu¡ INSS na Fonte */

                assign de-vl-contab  = it-nota-fisc.vl-ir-adic.

                /*SAT e SENAR*/
                
                    /*Verificar se cliente ‚ produtor rural*/
                    
                        IF emitente.log-controla-val-max-inss = YES   THEN
                    
                        
                            ASSIGN de-vl-contab = de-vl-contab + 
                                   it-nota-fisc.val-sat        +
                                   it-nota-fisc.val-senar.
                        
                

                 RUN pi-ped-curva(INPUT estabelec.ct-recven, INPUT estabelec.sc-recven, INPUT de-vl-contab).
                 IF l-log THEN
                    PUT "26 " estabelec.ct-recven + estabelec.sc-recven SKIP.

                 assign de-vl-contab = de-vl-contab * (-1).
                 RUN pi-ped-curva(INPUT conta-ft.cod-cta-inss-retid, INPUT conta-ft.cod-ccusto-inss-retid, INPUT de-vl-contab).
                 IF l-log THEN
                    PUT "27 " conta-ft.cod-cta-inss-retid + conta-ft.cod-ccusto-inss-retid SKIP.
             end.
             else do:

                 assign de-vl-contab  = it-nota-fisc.vl-ir-adic.
                 RUN pi-ped-curva(INPUT estabelec.cod-cta-inss-recolh, INPUT estabelec.cod-ccusto-inss-recolh, INPUT de-vl-contab).
                 IF l-log THEN
                    PUT "28 " estabelec.cod-cta-inss-recolh + estabelec.cod-ccusto-inss-recolh SKIP.

                 assign de-vl-contab = de-vl-contab * (-1).
                 RUN pi-ped-curva(INPUT conta-ft.cod-cta-inss-retid, INPUT conta-ft.cod-ccusto-inss-retid, INPUT de-vl-contab).
                 IF l-log THEN
                    PUT "29 " conta-ft.cod-cta-inss-retid + conta-ft.cod-ccusto-inss-retid SKIP.

             end.

         /* PIS */
         assign de-vl-total-pis-por-unidade = 0.
         if  it-nota-fisc.vl-tot-item > 0      
         and conta-ft.ct-pis-ft <> ""
         THEN DO:
             if  natur-oper.mercado = 1  then       /*** Percentual PIS ***/
                 if  nota-fiscal.dt-emis-nota < 11/01/2002 then
                     assign de-taxa-pis = decimal(substr(natur-oper.char-1,76,5)) / 100.
                 else     /* Novo tratamento de PIS e COFINS */
                     if  it-nota-fisc.idi-forma-calc-pis = 2 /* valor por unidade */ then do:
                         assign de-taxa-pis = 0.

                         /* Calcula valor total do PIS por unidade */
                         if  int(SUBSTRING(it-nota-fisc.char-2,96,1)) = 1 /* Tributacao do PIS = Tributado */ then
                             assign de-vl-total-pis-por-unidade = round(it-nota-fisc.qt-faturada[1] * it-nota-fisc.val-unit-pis,2).
                         else
                             assign de-vl-total-pis-por-unidade = 0.
                     end.
                     else
                         /* calcula PIS por percentual */
                         assign de-taxa-pis = decimal(substr(it-nota-fisc.char-2,76,5))
                                     * (100 - if substr(it-nota-fisc.char-2,96,1) = "3"  /* Reduzido */
                                              or substr(it-nota-fisc.char-2,96,1) = "4"  /* Outros   */
                                              then decimal(substr(it-nota-fisc.char-2,86,5))
                                              else 0)
                                     / 10000.
             else
                 assign de-taxa-pis = natur-oper.perc-pis[2] / 100.

             if  de-vl-total-pis-por-unidade > 0 then
                 assign de-vl-contab = de-vl-total-pis-por-unidade.
             else do:
                 assign de-vl-contab = it-nota-fisc.vl-tot-item
                                     - (if  substr(item.char-1,50,5) = " "    /* Retira PIS/Cofins Subst incorporado */
                                        or  substr(item.char-1,50,5) = "Sim"
                                        then   it-nota-fisc.vl-pis
                                             + it-nota-fisc.vl-finsocial
                                        else 0)
                                     - (if natur-oper.tp-oper-terc = 4
                                        then it-nota-fisc.vl-icmsubit-e[3]
                                        else it-nota-fisc.vl-icmsub-it)
                                     - (if avail w-item
                                        then w-item.desconto
                                        else 0).

                 /* IN306 - IPI integrante base PIS COFINS */
                     /** IN306 - IPI integrante base PIS COFINS                                       **/
    /** Tratamento para descontar valor do IPI/IPI Outras na base do PIS e do COFINS **/        

    /*Nao inclui o valor no IPI na base das contrib sociais*/    
    if  it-nota-fisc.cd-trib-ipi <> 3
    
    and natur-oper.log-ipi-contrib-social     <> YES then 
    
        assign de-vl-contab = de-vl-contab
                   - it-nota-fisc.vl-ipi-it
                   - (if  it-nota-fisc.vl-bipiit-e[3] <> 0 
                      then it-nota-fisc.vl-ipiit-e[3]
                      else 0).

    /*Nao inclui o valor no IPI OUTRAS na base das contrib sociais*/
    if  it-nota-fisc.cd-trib-ipi = 3 
    and substring(natur-oper.char-2,16,1) = "1":U
    
    and natur-oper.log-ipi-outras-contrib-social <> YES then 
    
        assign de-vl-contab = de-vl-contab
                   - it-nota-fisc.vl-ipi-it
                   - (if  it-nota-fisc.vl-bipiit-e[3] = 0 
                      then it-nota-fisc.vl-ipiit-e[3]
                      else 0).
 

                 assign de-vl-contab = de-vl-contab * de-taxa-pis
                        de-vl-contab = round(de-vl-contab,2).
             end.

             if  de-vl-contab > 0 then do:
                 RUN pi-ped-curva(INPUT estabelec.ct-pis, INPUT estabelec.sc-pis, INPUT de-vl-contab). 
                 IF l-log THEN
                    PUT "30 " estabelec.ct-pis + estabelec.sc-pis SKIP.

                 assign de-vl-contab = de-vl-contab * (-1).
                 RUN pi-ped-curva(INPUT conta-ft.ct-pis-ft, INPUT conta-ft.sc-pis-ft, INPUT de-vl-contab).
                 IF l-log THEN
                    PUT "31 " conta-ft.ct-pis-ft + conta-ft.sc-pis-ft SKIP.

             end.
         END.

         /* COFINS */
         assign de-vl-total-cofins-por-unidade = 0.
         if  it-nota-fisc.vl-tot-item      > 0
         and conta-ft.ct-cofins-ft        <> ""
         THEN DO:
             if  natur-oper.mercado = 1  then       /*** Percentual PIS ***/
                 if  nota-fiscal.dt-emis-nota < 11/01/2002 then
                     assign de-taxa-cofins = decimal(substr(natur-oper.char-1,81,5)) / 100.
                 else     /* Novo tratamento de PIS e COFINS */
                     if  it-nota-fisc.idi-forma-calc-cofins = 2 /* valor por unidade */ then do:
                         assign de-taxa-cofins = 0.

                         /* Calcula valor total do COFINS por unidade */
                         if  int(SUBSTRING(it-nota-fisc.char-2,97,1)) = 1 /* Tributacao COFINS = Tributado */ then
                             assign de-vl-total-cofins-por-unidade = round(it-nota-fisc.qt-faturada[1] * it-nota-fisc.val-unit-cofins,2).
                         else
                             assign de-vl-total-cofins-por-unidade = 0.
                     end.
                     else
                         /* calcula COFINS por percentual */
                         assign de-taxa-cofins = decimal(substr(it-nota-fisc.char-2,81,5))
                                     * (100 - if substr(it-nota-fisc.char-2,97,1) = "3"  /* Reduzido */
                                              or substr(it-nota-fisc.char-2,97,1) = "4"  /* Outros   */
                                              then decimal(substr(it-nota-fisc.char-2,91,5))
                                              else 0)
                                     / 10000.
             else
                 assign de-taxa-cofins = natur-oper.per-fin-soc[2] / 100.

             if  de-vl-total-cofins-por-unidade > 0 then
                 assign de-vl-contab = de-vl-total-cofins-por-unidade.
             else do:
                 assign de-vl-contab = it-nota-fisc.vl-tot-item
                                  - (if  substr(item.char-1,50,5) = " "    /* Retira PIS/Cofins Subst incorporado */
                                     or  substr(item.char-1,50,5) = "Sim"
                                     then   it-nota-fisc.vl-pis
                                          + it-nota-fisc.vl-finsocial
                                     else 0)
                                  - (if natur-oper.tp-oper-terc = 4
                                     then it-nota-fisc.vl-icmsubit-e[3]
                                     else it-nota-fisc.vl-icmsub-it)
                                  - (if avail w-item
                                     then w-item.desconto
                                     else 0).

                 /* IN306 - IPI integrante base PIS COFINS */
                     /** IN306 - IPI integrante base PIS COFINS                                       **/
    /** Tratamento para descontar valor do IPI/IPI Outras na base do PIS e do COFINS **/        

    /*Nao inclui o valor no IPI na base das contrib sociais*/    
    if  it-nota-fisc.cd-trib-ipi <> 3
    
    and natur-oper.log-ipi-contrib-social     <> YES then 
    
        assign de-vl-contab = de-vl-contab
                   - it-nota-fisc.vl-ipi-it
                   - (if  it-nota-fisc.vl-bipiit-e[3] <> 0 
                      then it-nota-fisc.vl-ipiit-e[3]
                      else 0).

    /*Nao inclui o valor no IPI OUTRAS na base das contrib sociais*/
    if  it-nota-fisc.cd-trib-ipi = 3 
    and substring(natur-oper.char-2,16,1) = "1":U
    
    and natur-oper.log-ipi-outras-contrib-social <> YES then 
    
        assign de-vl-contab = de-vl-contab
                   - it-nota-fisc.vl-ipi-it
                   - (if  it-nota-fisc.vl-bipiit-e[3] = 0 
                      then it-nota-fisc.vl-ipiit-e[3]
                      else 0).
 

                 assign de-vl-contab = de-vl-contab * de-taxa-cofins
                        de-vl-contab = round(de-vl-contab,2).
             end.

             if  de-vl-contab > 0 then do:
                 RUN pi-ped-curva(INPUT estabelec.ct-fins-pg, INPUT estabelec.sc-fins-pg, INPUT de-vl-contab). 
                 IF l-log THEN
                    PUT "32 " estabelec.ct-fins-pg + estabelec.sc-fins-pg SKIP.

                 assign de-vl-contab = de-vl-contab * (-1).
                 RUN pi-ped-curva(INPUT conta-ft.ct-cofins-ft, INPUT conta-ft.sc-cofins-ft, INPUT de-vl-contab).
                 IF l-log THEN
                    PUT "33 " conta-ft.ct-cofins-ft + conta-ft.sc-cofins-ft SKIP.
             end.
         END.

         /* PIS SUBSTITUTO */

         if  it-nota-fisc.vl-pis > 0 then do:
             assign de-vl-contab = it-nota-fisc.vl-pis.
             RUN pi-ped-curva(INPUT substr(estabelec.char-1,300,20), INPUT substr(estabelec.char-1,320,20), INPUT de-vl-contab).
             IF l-log THEN
                PUT "34 " substr(estabelec.char-1,300,20) + substr(estabelec.char-1,320,20) SKIP.


             assign de-vl-contab = de-vl-contab * (-1).

             RUN pi-ped-curva(INPUT conta-ft.cod-cta-pis, INPUT conta-ft.cod-ccusto-pis, INPUT de-vl-contab).
             IF l-log THEN
                PUT "35 " conta-ft.cod-cta-pis + conta-ft.cod-ccusto-pis SKIP.

         end.


         /* COFINS SUBSTITUTO */

         if  it-nota-fisc.vl-finsocial > 0 then do:
             assign de-vl-contab = it-nota-fisc.vl-finsocial.
             RUN pi-ped-curva(INPUT SUBSTR(estabelec.char-1,340,20), INPUT SUBSTR(estabelec.char-1,360,20), INPUT de-vl-contab).
             IF l-log THEN
                PUT "36 " SUBSTR(estabelec.char-1,340,20) + SUBSTR(estabelec.char-1,360,20) SKIP.

             assign de-vl-contab = de-vl-contab * (-1).

             RUN pi-ped-curva(INPUT conta-ft.cod-cta-cofins, INPUT conta-ft.cod-ccusto-cofins, INPUT de-vl-contab).
             IF l-log THEN
                PUT "37 " conta-ft.cod-cta-cofins + conta-ft.cod-ccusto-cofins SKIP.

         end.
        
        /* Contabiliza‡Æo da Receita de Exporta‡Æo */
        
        
        /*** RETENCAO ISS ***/
        
        if  l-funcao-iss-retido
        and dec(trim(substr(it-nota-fisc.char-2,218,14))) > 0 then do:  /* valor de reten‡ao > que zero */
    
            ASSIGN de-vl-contab = dec(trim(substr(it-nota-fisc.char-2,218,14))).
            RUN pi-ped-curva(INPUT estabelec.ct-recven, INPUT estabelec.sc-recven, INPUT de-vl-contab).
            IF l-log THEN
                PUT "40 " estabelec.ct-recven + estabelec.sc-recven SKIP.
            
            assign de-vl-contab = de-vl-contab * (-1).
            RUN pi-ped-curva(INPUT conta-ft.cod-cta-retenc-iss, INPUT conta-ft.cod-ccusto-retenc-iss, INPUT de-vl-contab).
            IF l-log THEN
                PUT "41 " conta-ft.cod-cta-retenc-iss + conta-ft.cod-ccusto-retenc-iss SKIP.
    
        end.
        
    end.

delete widget h-cd9500.

PROCEDURE pi-ped-curva:

    DEFINE INPUT PARAMETER c-ct-codigo  AS CHAR     NO-UNDO.
    DEFINE INPUT PARAMETER c-sc-codigo  AS CHAR     NO-UNDO.
    DEFINE INPUT PARAMETER de-valor     AS DECIMAL  NO-UNDO.

    DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO.


    /* Esta logica foi implementada para listar a contabiliza‡Æo por unidade de negocio */
    DEF VAR c-unid-neg AS CHAR NO-UNDO.
    
    /* Incidente 1156 - Contabiliza‡Æo de notas de devolu‡aä da ASTEC por unidade de negocio do item/familia */
    FIND int-natur-oper WHERE
         int-natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR.

    IF AVAIL it-nota-fisc 
    THEN DO:
        FIND item-uni-estab NO-LOCK
            WHERE item-uni-estab.it-codigo   = it-nota-fisc.it-codigo
              AND item-uni-estab.cod-estabel = it-nota-fisc.cod-estabel NO-ERROR.

        IF  AVAIL item-uni-estab
        THEN
            ASSIGN c-unid-neg = item-uni-estab.cod-unid-neg.
    END.
    ELSE DO:
        IF AVAIL ITEM 
        THEN DO:
            FIND item-uni-estab NO-LOCK
                WHERE item-uni-estab.it-codigo   = ITEM.it-codigo
                  AND item-uni-estab.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.
    
            IF  AVAIL item-uni-estab
            THEN
                ASSIGN c-unid-neg = item-uni-estab.cod-unid-neg.
        END.
    END.

    /*
    IF substring(string(c-ct-codigo),1,1) = "3" AND
        substring(it-nota-fisc.it-codigo,1,1) <> "4" THEN do: /* Quando for conta de resultado */
    
        ASSIGN i-cod-unid-neg = 0.

        RUN upc/ft0708a-epca.p (INPUT c-unid-neg, OUTPUT i-cod-unid-neg).

        IF i-cod-unid-neg <> 0 THEN DO:

            ASSIGN OVERLAY(c-conta,11,1) = string(i-cod-unid-neg,"9").
        END.
    END. 
    */

    IF AVAIL int-natur-oper 
         AND int-natur-oper.contab-unid-neg THEN DO:
        IF substring(string(c-ct-codigo),1,1) = "4" /* somente troca a conta que iniciam com 4 */
           AND c-unid-neg <> "" THEN DO:
            ASSIGN i-empresa = param-global.empresa-prin.
    
            IF AVAIL estabelec THEN
                run cdp/cd9970.p (input rowid(estabelec),
                                  output i-empresa).
    
            FIND FIRST int-unid-neg-natur
                 WHERE int-unid-neg-natur.cod-estabel  = nota-fiscal.cod-estabel
                   AND int-unid-neg-natur.cod-unid-neg = c-unid-neg
                   AND int-unid-neg-natur.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.
            IF AVAIL int-unid-neg-natur THEN DO:

                /*
                for first conta-contab fields (conta-contabil ct-codigo sc-codigo ep-codigo)
                    where conta-contab.conta-contabil = int-unid-neg-natur.conta-contabil
                      and conta-contab.ep-codigo      = i-empresa no-lock: end.
                if  avail conta-contab then DO:
                    ASSIGN c-conta = conta-contab.conta-contabil.
                END.
                */

                ASSIGN v_cod_conta = int-unid-neg-natur.ct-codigo
                       l-erro = FALSE.

            	empty temp-table tt_log_erro.

                if not valid-handle(h_api_cta_ctbl) then 
            		run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
                
            	run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (INPUT "",
            												   INPUT "",
                                                               input-output v_cod_conta,
            												   INPUT TODAY,
            												   output v_des_titulo_conta,
            												   output v_num_tip_cta_ctbl,
            												   output v_num_sit_cta_ctbl,
            												   output v_ind_finalid_cta,
            												   OUTPUT TABLE tt_log_erro).

                IF VALID-HANDLE(h_api_cta_ctbl) THEN
                    DELETE OBJECT h_api_cta_ctbl.

                IF CAN-FIND (FIRST tt_log_erro) THEN
                    ASSIGN l-erro = TRUE.

                /**/

                ASSIGN v_cod_ccusto = int-unid-neg-natur.sc-codigo.

                RUN prgint/utb/utb742za.py persistent set h_api_ccusto.

                EMPTY TEMP-TABLE tt_log_erro.
            
                run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,          /* EMPRESA EMS2 */
                                                           input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                           input  v_cod_ccusto,       /* CCUSTO */
                                                           input TODAY,              /* DATA DE TRANSACAO */
                                                           output v_des_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                           output table tt_log_erro). /* ERROS */

                IF VALID-HANDLE(h_api_ccusto) THEN
                    DELETE OBJECT h_api_ccusto.

                IF CAN-FIND (FIRST tt_log_erro) THEN
                    ASSIGN l-erro = TRUE.

                /**/

                IF NOT l-erro THEN DO:

                    ASSIGN c-ct-codigo = int-unid-neg-natur.ct-codigo
                           c-sc-codigo = int-unid-neg-natur.sc-codigo.

                END.
                

            END.
        END.
    END. /* IF AVAIL int-natur-oper  */
    /*****************************************************************************
**
** Programa : FT0904l.I
**
** Autor    : DATASUL S.A.
**
** Objetivo : Comum ao programa FT0904l.P, criar o tt-ped-curva.
**
*****************************************************************************/

find tt-ped-curva where 
     tt-ped-curva.it-codigo    = nota-fiscal.cod-estabel  
 and tt-ped-curva.serie        = nota-fiscal.serie                
 and tt-ped-curva.nr-nota-fis  = nota-fiscal.nr-nota-fis 
 and tt-ped-curva.ct-codigo    = c-ct-codigo
 AND tt-ped-curva.sc-codigo    = c-sc-codigo no-lock no-error.

if not avail tt-ped-curva then do: 
   create tt-ped-curva.
    assign tt-ped-curva.it-codigo  = nota-fiscal.cod-estabel
          tt-ped-curva.serie       = nota-fiscal.serie
          tt-ped-curva.nr-nota-fis = nota-fiscal.nr-nota-fis
          tt-ped-curva.ct-codigo   = c-ct-codigo
          tt-ped-curva.sc-codigo   = c-sc-codigo
          i-empresa = param-global.empresa-prin.
   
      IF AVAIL estabelec THEN
        run cdp/cd9970.p (input rowid(estabelec), output i-empresa). 



      /**/

      ASSIGN v_cod_conta = c-ct-codigo
             l-erro = FALSE.
    
      empty temp-table tt_log_erro.
    
      if not valid-handle(h_api_cta_ctbl) then 
          run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
      
      run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (INPUT "",
                                                     INPUT "",
                                                     input-output v_cod_conta,
                                                     INPUT TODAY,
                                                     output v_des_titulo_conta,
                                                     output v_num_tip_cta_ctbl,
                                                     output v_num_sit_cta_ctbl,
                                                     output v_ind_finalid_cta,
                                                     OUTPUT TABLE tt_log_erro).
    
      IF VALID-HANDLE(h_api_cta_ctbl) THEN
          DELETE OBJECT h_api_cta_ctbl.
    
      IF NOT CAN-FIND (FIRST tt_log_erro) THEN
          ASSIGN tt-ped-curva.ct-desc = v_des_titulo_conta.
    
      /**/
    
      ASSIGN v_cod_ccusto = c-sc-codigo.
    
      RUN prgint/utb/utb742za.py persistent set h_api_ccusto.
    
      EMPTY TEMP-TABLE tt_log_erro.
    
      run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,          /* EMPRESA EMS2 */
                                                 input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                 input  v_cod_ccusto,       /* CCUSTO */
                                                 input TODAY,              /* DATA DE TRANSACAO */
                                                 output v_des_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                 output table tt_log_erro). /* ERROS */
    
      IF VALID-HANDLE(h_api_ccusto) THEN
          DELETE OBJECT h_api_ccusto.
    
      IF NOT CAN-FIND (FIRST tt_log_erro) THEN
          ASSIGN tt-ped-curva.sc-desc = v_des_titulo_ccusto.
    
      /**/
   
end.
assign tt-ped-curva.dec-1 = tt-ped-curva.dec-1 + de-valor.
if tt-ped-curva.dec-1 < 0 then
   assign tt-ped-curva.vl-debito  = -(tt-ped-curva.dec-1)
          tt-ped-curva.vl-credito = 0.
else 
   assign tt-ped-curva.vl-credito = tt-ped-curva.dec-1
          tt-ped-curva.vl-debito  = 0.
/* FT0904l.I */
 

END PROCEDURE.

/* Pi-vl-contabil */
/******************************************************************************
* FT0708A.I10
* Este include faz o Tratamento para Notas de Entrega Futura.
*
*******************************************************************************/

procedure pi-vl-contabil:
 
    /* Tratamento para Notas de Entrega Futura */
    if  int(natur-oper.ind-entfut) + int(natur-oper.ind-est-qtd) > 0 then do:
        if  natur-oper.ind-entfut then /* Nota de Faturamento */
            assign de-vl-contab = it-nota-fisc.vl-tot-item
                                - it-nota-fisc.vl-ipiit-e[3]
                                - it-nota-fisc.vl-icmsit-e[2]
                                - if  avail w-item
                                  then w-item.desconto
                                  else 0.
 
        else /* Nota de Remessa */
            assign de-vl-contab = it-nota-fisc.vl-ipi-it
                                + it-nota-fisc.vl-icmsub-it.
    end.
    else
        assign de-vl-contab = it-nota-fisc.vl-tot-item
                            - if  avail w-item
                              then w-item.desconto
                              else 0.
end.
 
