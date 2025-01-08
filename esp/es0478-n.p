/*****************************************************************************
**
**   Programa:  es0478.p
**
**   Funcao:  Controlar Localizacao nas Transferencias
**
**   Data:  10/08/2000
**
**   Autor:  Flavio Schoenell   - INTELBRAS S/A.
**
compile \\tsclient\c\fontes\esp\es0478-n.p save into c:\temp\esp.
******************************************************************************/
/*
&if opsys = "UNIX" &then
    &GLOBAL-DEFINE EXEC-RPC YES
&endif
*/

{esp/es0018.i }
{esp/es0478-rpc.i} 
{upc/btb910za-upc.i} /* Definiá∆o do estabelecimento do usu†rio */
{utp/utapi019.i} /* Include de envio de e-mail */
 

def input parameter c-it-codigo     like item.it-codigo no-undo.
def input parameter c-depos-sai     like deposito.cod-depos no-undo.
def input parameter c-loc-sai       like item.cod-localiz no-undo.
def input parameter i-quantidade    like movto-estoq.quantidade no-undo.
def input parameter c-depos-ent     like deposito.cod-depos no-undo.
def input parameter i-nro-docto     as int no-undo.
def input parameter c-serie         like movto-estoq.serie-docto no-undo.
def input parameter c-historico     as char format "x(70)" no-undo.
def input parameter i-nr-ae         like ae-item.nr-ae no-undo.
def input parameter i-sequencia     like ae-item.sequencia no-undo.
def input parameter i-roteiro       like ficha-cq.nr-ficha no-undo.
def input parameter i-nf            as int no-undo.
def input parameter l-parcial       as logical no-undo.
def input parameter l-devolucao     as logical no-undo.
def input parameter i-contenedor    like item.lote-multipl no-undo.
def input parameter i-emitente      like emitente.cod-emitente no-undo.
def input parameter i-seq-ini       like ae-item.sequencia no-undo.
def input parameter l-usa-loc       as logical no-undo.
def input parameter c-loc-dest      like item.cod-localiz no-undo.
def input parameter dt-trans        like movto-estoq.dt-trans no-undo.
def input parameter dt-validade     like ae-item.data-validade no-undo.
def input parameter c-livre         as char format "X(100)" no-undo.
def input param pi-cod-estabel      as char no-undo.
DEF OUTPUT PARAM TABLE FOR tt-etiqueta.
DEF OUTPUT PARAM p-msg-erro AS CHAR NO-UNDO.

/* Deve carregar a global, pois o ES0007.i usa ela e estava indo em branco. */
ASSIGN v_cod_estab_usuar = pi-cod-estabel.

def var c-loc-ent        like item.cod-localiz no-undo.
def var i-qtd-trans      like movto-estoq.quantidade no-undo.
def var c-mensagem       as char format "x(100)" no-undo.
def var i-nova-ae        like ae-item.nr-ae no-undo.
def var i-nova-seq       like ae-item.sequencia no-undo.
def var i-nova-qtd       like ae-item.quantidade no-undo.
def var da-data          as date no-undo .
def var i-qtd-lote       as int no-undo.
def var i-qtd-resto      as int no-undo.
def var i-cont           as int no-undo.
def var c-linha          as char no-undo.
def var i-it-digito      as int no-undo.
def var c-arquivo        as char no-undo.
def var l-alocou-ini     as logical no-undo.
def var de-qtde          as dec no-undo.
def var l-liberado       as log no-undo.
DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.

{esp/es0478.i} /* definicao de variaveis */
{esp/es0007.i} /* busca conta de transferencia */
{utp/ut-glob.i}

def buffer b-param-depos    for param-depos.
def buffer b-ae-item        for ae-item.
def buffer b-ae-item-dois   for ae-item.
def buffer bx-ae-item       for ae-item.
def buffer b-saldo-estoq    for saldo-estoq.

/* variaveis utilizadas na localizacao automatica */

def buffer b-item-tipo-loc for item-tipo-loc.

def temp-table tt-ae
    field nr-ae      like ae-item.nr-ae
    field sequencia  like ae-item.sequencia
    field quantidade like ae-item.quantidade
    field data       like ae-item.data
    index codigo is primary nr-ae sequencia.

def var c-local like item.cod-localiz no-undo.
def var l-usa-ult-loc as logical no-undo.
def var l-mistura as logical no-undo.
def var l-compartilha as logical no-undo.
def var i-capacidade like item-tipo-loc.quantidade no-undo.
def var i-capac-comp like item-tipo-loc.quantidade no-undo.
def var i-qtd-autom like i-quantidade no-undo.
def var l-tem-tipo as logical no-undo.
def var l-achou    as logical no-undo.
def var num-comp   as int no-undo.
def var proprio-item as logical no-undo.
def var local-proprio like item.cod-localiz no-undo.
def var saldo-proprio like saldo-estoq.qtidade-atu no-undo.
    

/* inicio log */
/*
def stream arq.
EMPTY TEMP-TABLE tt-prog-ponto.

IF OPSYS = "UNIX":U THEN DO:
    RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-arquivo = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
    END.

    IF SUBSTRING(c-arquivo, LENGTH(c-arquivo), 1) <> "/":U THEN
        ASSIGN c-arquivo = c-arquivo + "/":U.

    ASSIGN c-arquivo = c-arquivo + "spool/es0478/loges0478-":U +
                       STRING(YEAR(TODAY), "9999":U) +
                       STRING(MONTH(TODAY), "99":U) +
                       STRING(DAY(TODAY), "99":U) +
                       "-":U + pi-cod-estabel + "-":U +
                       ENTRY(1, c-livre, ",":U) + ".txt":U.
END.
ELSE DO:
    RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-arquivo = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
    END.

    IF SUBSTRING(c-arquivo, LENGTH(c-arquivo), 1) <> "~\":U THEN
        ASSIGN c-arquivo = c-arquivo + "~\":U.

    ASSIGN c-arquivo = c-arquivo + "spool~\es0478~\loges0478-":U +
                       STRING(YEAR(TODAY), "9999":U) +
                       STRING(MONTH(TODAY), "99":U) +
                       STRING(DAY(TODAY), "99":U) +
                       "-":U + pi-cod-estabel + "-":U +
                       ENTRY(1, c-livre, ",":U) + ".txt":U.
END.

if search(c-arquivo) ne ? then
    output stream arq to value(c-arquivo) append.
else do:
    output stream arq to value(c-arquivo).
end.                   

put stream arq fill("-", 75) format "x(75)" skip
               "Hora: " string(time, "hh:mm:ss") skip(1)    
               "Chamador: " program-name(2) format "x(75)" skip
               "Com : " skip(1)   
               "c-it-codigo     = " c-it-codigo skip
               "c-depos-sai     = " c-depos-sai skip
               "c-loc-sai       = " c-loc-sai skip
               "i-quantidade    = " i-quantidade skip
               "c-depos-ent     = " c-depos-ent skip
               "i-nro-docto     = " i-nro-docto skip
               "c-serie         = " c-serie skip
               "c-historico     = " c-historico skip
               "i-nr-ae         = " i-nr-ae skip
               "i-sequencia     = " i-sequencia skip
               "i-roteiro       = " i-roteiro skip
               "i-nf            = " i-nf skip
               "l-parcial       = " l-parcial skip
               "l-devolucao     = " l-devolucao skip
               "i-contenedor    = " i-contenedor skip
               "i-emitente      = " i-emitente skip
               "i-seq-ini       = " i-seq-ini skip
               "l-usa-loc       = " l-usa-loc skip
               "c-loc-dest      = " c-loc-dest skip
               "dt-trans        = " dt-trans skip
               "dt-validade     = " dt-validade skip
               "c-livre         = " c-livre skip
               "pi-cod-estabel  = " pi-cod-estabel skip
               fill("-", 75) format "x(75)" skip(1).

    
disp stream arq skip "[{&LINE-NUMBER}]: " "Inicio" c-it-codigo i-nr-ae i-sequencia
     with no-labels frame f1.
*/
/* fim log */

assign l-deu-erro = yes.
{cdp/cd0666.i}      /* Definicao da temp-table de erros */
{cep/ceapi001k.i}   /* Definicao de temp-table do movto-estoq para ems2.06 */
{cdp/cd9590.i}

DEF BUFFER b-tt-movto       FOR tt-movto.

DEF VAR h-ceapi001k      AS HANDLE NO-UNDO.
DEF VAR h-cdapi024       AS HANDLE NO-UNDO.
DEF VAR c-unid-negoc     AS CHAR   NO-UNDO.

if l-usa-loc then do:
    find param-depos 
         where param-depos.cod-estabel = pi-cod-estabel
         and   param-depos.cod-depos = c-depos-ent no-lock no-error.

    IF NOT AVAIL param-depos THEN DO:

        if opsys = "UNIX" then
            p-msg-erro = "ParÉmetros do Dep¢sito (ESCEP021) n∆o cadastrado para Estabelecimento " + pi-cod-estabel + " e dep¢sito " + c-depos-ent + ". Favor cadastrar.".
        else
            message "ParÉmetros do Dep¢sito (ESCEP021) n∆o cadastrado para Estabelecimento " + pi-cod-estabel + " e dep¢sito " + c-depos-ent + ". Favor cadastrar."
                view-as alert-box.
        
        assign l-deu-erro = yes.
        UNDO, RETURN.

    END.

    if not param-depos.loc-autom 
     /*  retirado para que a devolucao para o INJ gere AE
         or 
           c-depos-ent = "INJ" */ then do:
        find item where item.it-codigo = c-it-codigo no-lock no-error.
        FIND item-uni-estab WHERE
             item-uni-estab.cod-estabel = pi-cod-estabel AND
             item-uni-estab.it-codigo   = c-it-codigo NO-LOCK NO-ERROR.

        run processa-loc-comum.
        if c-depos-sai = c-depos-ent then do:
            find first ae-item exclusive-lock
                where ae-item.cod-estabel = pi-cod-estabel
                and ae-item.nr-ae = i-nr-ae
                and ae-item.sequencia = i-sequencia no-error.
            if avail ae-item then do:
                assign ae-item.localizacao = c-loc-dest.
                find current ae-item no-lock.
            end.    
        end.
        if c-depos-ent = "inj" and c-depos-sai <> "inj" then do:
            find first ae-item exclusive-lock
                where ae-item.cod-estabel = pi-cod-estabel
                and ae-item.nr-ae = i-nr-ae
                and ae-item.sequencia = i-sequencia no-error.
            if avail ae-item then do:
                assign ae-item.situacao = yes.
                find current ae-item no-lock.
            end.    
        end.
        if c-depos-ent <> "inj" and c-depos-sai = "inj" then do:
            find first ae-item exclusive-lock
                where ae-item.cod-estabel = pi-cod-estabel
                and ae-item.nr-ae = i-nr-ae
                and ae-item.sequencia = i-sequencia no-error.
            if avail ae-item then do:
                assign ae-item.situacao = yes.
                find current ae-item no-lock.
            end.    
        end.
        next.
    end.
    /* alterado em 25/01/05 - Flavio */
    else do:
        if c-depos-ent = "inj" and c-loc-dest = "" then do:
            find first ae-item exclusive-lock
                where ae-item.cod-estabel = pi-cod-estabel 
                and ae-item.nr-ae = i-nr-ae
                and ae-item.sequencia = i-sequencia no-error.
            if avail ae-item then do:
                assign ae-item.situacao = yes.
                find current ae-item no-lock.
            end.    
        end.
    
    end.

    /* disp stream arq  skip "[{&LINE-NUMBER}]: " "l-usa-loc = " l-usa-loc with no-labels frame f-2 width 131. */
    
    assign i-qtd-autom =  i-quantidade
           c-local     =  c-loc-dest.

    create tt-ae.
    assign tt-ae.nr-ae = i-nr-ae
           tt-ae.sequencia = i-sequencia
           tt-ae.quantidade = i-quantidade.
    
    find item where item.it-codigo = c-it-codigo no-lock no-error.

    FIND item-uni-estab WHERE
         item-uni-estab.cod-estabel = pi-cod-estabel AND
         item-uni-estab.it-codigo   = c-it-codigo NO-LOCK NO-ERROR.

    find first local 
         where local.cod-estabel = pi-cod-estabel
           and local.cod-depos   = c-depos-ent
           and local.localizacao = c-loc-dest no-lock no-error.
    if avail local then
        FIND FIRST item-tipo-loc 
             where item-tipo-loc.it-codigo = c-it-codigo
               and item-tipo-loc.cod-estabel = pi-cod-estabel
               and item-tipo-loc.cod-depos   = local.cod-depos
               and item-tipo-loc.cod-tipo  = local.cod-tipo no-lock no-error.

    
    
    if avail item-tipo-loc then
        assign i-capacidade = item-tipo-loc.quantidade.
    else    
        assign i-capacidade = 0.

    
   
    /* caso o material esteja sendo enviado para devolucao, a capacidade esta sendo informada no programa para nao exigir a atualizacao do relacionamento item x local */

    if c-loc-dest = "devolucao" then 
       assign i-capacidade = 100000.
    
    /* disp stream arq skip "[{&LINE-NUMBER}]: " "vai alocar com capacidade" i-capacidade with no-labels frame f3 width 131. */

    run aloca. 

    if return-value = "NOK" then undo, return.

    /*run disp-stream (input {&LINE-NUMBER}).*/

    next.
end.

find param-depos 
     where param-depos.cod-estabel = pi-cod-estabel
     and   param-depos.cod-depos = c-depos-ent no-lock no-error.

find b-param-depos
     where b-param-depos.cod-estabel = pi-cod-estabel
     and   b-param-depos.cod-depos = c-depos-sai no-lock no-error.

IF NOT AVAIL param-depos THEN DO:

    if opsys = "UNIX" then
        p-msg-erro = "ParÉmetros do Dep¢sito (ESCEP021) n∆o cadastrado para Estabelecimento " + pi-cod-estabel + " e dep¢sito " + c-depos-ent + ". Favor cadastrar.".
    else
        message "ParÉmetros do Dep¢sito (ESCEP021) n∆o cadastrado para Estabelecimento " + pi-cod-estabel + " e dep¢sito " + c-depos-ent + ". Favor cadastrar."
            view-as alert-box.

    assign l-deu-erro = yes.
    UNDO, RETURN.

END.

IF NOT AVAIL b-param-depos THEN DO:

    if opsys = "UNIX" then
        p-msg-erro = "ParÉmetros do Dep¢sito (ESCEP021) n∆o cadastrado para Estabelecimento " + pi-cod-estabel + " e dep¢sito " + c-depos-sai + ". Favor cadastrar.".
    else
        message "ParÉmetros do Dep¢sito (ESCEP021) n∆o cadastrado para Estabelecimento " + pi-cod-estabel + " e dep¢sito " + c-depos-sai + ". Favor cadastrar."
            view-as alert-box.

    assign l-deu-erro = yes.
    UNDO, RETURN.

END.

     
find item 
     where item.it-codigo = c-it-codigo no-lock no-error.

FIND item-uni-estab WHERE
     item-uni-estab.cod-estabel = pi-cod-estabel AND
     item-uni-estab.it-codigo   = c-it-codigo NO-LOCK NO-ERROR.

if i-contenedor = 0 then 
    assign i-contenedor = item-uni-estab.lote-multipl.

/* busca ae quando tipo fizer baixa de ae */

if b-param-depos.baixa-ae then do:

   if i-nr-ae <> 0 then do:
      find bx-ae-item no-lock
           where bx-ae-item.cod-estabel = pi-cod-estabel
             and bx-ae-item.nr-ae     = i-nr-ae
             and bx-ae-item.sequencia = i-sequencia no-error.
      if avail bx-ae-item then do:
         /* disp stream arq "[{&LINE-NUMBER}]: " "achei o AE " with no-labels frame f-5000 width 131. */
         assign i-nro-docto = bx-ae-item.nr-ae
                c-serie     = string(bx-ae-item.sequencia,"999").
      end.           
      if ambiguous bx-ae-item then do:
         if opsys = "UNIX" then
             p-msg-erro = "AE em duplicidade. Consulte respons†vel do Almoxarifado".
         else
             message "AE em Duplicidade. Consulte Responsavel do Almoxarifado."
                     view-as alert-box.
         
         assign l-deu-erro = yes.
         next.
      end.
   end.
end.

if param-depos.loc-autom then do:

   if c-depos-ent = "exp" and c-depos-sai <> "aca" 
   then do:
      if c-loc-sai <> "localizar" then run processa-loc-comum.
                                  else run processa-loc-autom.
   end.
      
   else do:
      run processa-loc-autom.
   end.
      
end.
ELSE DO: 
    run processa-loc-comum.
END.
   
   
 
/* procedure que faz a transferencia para depositos que nao controla local. */

procedure processa-loc-comum.
    
    /* disp stream arq skip "[{&LINE-NUMBER}]: " "PROCESSA-LOC-COMUM" c-it-codigo i-nr-ae i-sequencia
     with no-labels frame fplc width 131. */
    
    if not l-usa-loc then do:
        if param-depos.tipo-loc /* padrao */ then
            assign c-loc-ent = item-uni-estab.cod-localiz.
        else 
            assign c-loc-ent = "".
    end.
    else assign c-loc-ent = c-loc-dest.
    
    assign i-qtd-trans = i-quantidade.

    run processa-transferencia. 

    if l-deu-erro then undo, return.
    
    if (param-depos.cria-ae or l-parcial) and c-depos-ent <> "inj" 
       then run gera-ae.
    else
       if l-devolucao 
       and (c-depos-ent = "smd" or c-depos-ent = "iao" or c-depos-ent = "iac"
            or c-depos-ent = "ias" or c-depos-ent = "iat" or c-depos-ent = "cob")
       then run gera-ae.
end.

/* procedure que faz a transferencia para depositos que controlam local. */

procedure processa-loc-autom.

    /* disp stream arq skip "[{&LINE-NUMBER}]: " "PROCESSA-LOC-AUTOM" c-it-codigo i-nr-ae i-sequencia
     with no-labels frame fpla width 131. */

    proc-loc-autom:
    DO TRANS ON ERROR UNDO proc-loc-autom, LEAVE proc-loc-autom:
    
        for each tt-ae:
            delete tt-ae.
        end.
    
        assign i-qtd-trans   = i-quantidade
               l-usa-ult-loc = no.

        run gera-ae.
    
        assign l-alocou-ini = no.
        
        /* disp stream arq skip "[{&LINE-NUMBER}]: " "Quantidade recebida" i-qtd-trans with no-labels frame f-4 width 131. */

        run aloca-inicial.

        IF RETURN-VALUE = "NOK" THEN
            UNDO proc-loc-autom, LEAVE proc-loc-autom.
    
        if l-alocou-ini then next.
    
        /* disp stream arq skip "[{&LINE-NUMBER}]: " "nao alocou na parte inicial" with no-labels frame f-5 width 131. */
    
        for each tt-ae:
            if l-parcial then
               assign i-qtd-autom = i-quantidade.
            else
               assign i-qtd-autom = tt-ae.quantidade.
        
            /* disp stream arq "[{&LINE-NUMBER}]: " "Inicio do item " c-it-codigo tt-ae.nr-ae tt-ae.sequencia with no-labels frame f-140 width 131. */
    
            if l-usa-ult-loc then do:
            
               /* disp stream arq skip "[{&LINE-NUMBER}]: " "vai usar ultima localizacao" c-local
                    with no-labels frame f-6 width 131. */

               run aloca.
               if return-value = "NOK" then UNDO proc-loc-autom, LEAVE proc-loc-autom.
     
            end.
            
            if i-qtd-autom <= 0 then next.
            
            assign l-tem-tipo = no.
            
            /*** PEGA LOCALIZACAO NAO UNICA *******/
            
            for each item-tipo-loc no-lock
               where item-tipo-loc.it-codigo = c-it-codigo
                 and item-tipo-loc.cod-estabel = pi-cod-estabel
                 and item-tipo-loc.cod-depos = c-depos-ent,
                each tipo-local no-lock
               where tipo-local.cod-estabel = pi-cod-estabel
                 and tipo-local.cod-tipo = item-tipo-loc.cod-tipo
                 and tipo-local.unico    = no
               break by item-tipo-loc.it-codigo
                     by item-tipo-loc.sequencia:
    
                /* disp stream arq "[{&LINE-NUMBER}]: " "vai procurar no tipo nao unica: " c-depos-ent " "
                     item-tipo-loc.cod-tipo with frame f141 width 131. */
    
                assign l-tem-tipo = yes
                       i-capacidade = item-tipo-loc.quantidade
                       i-capac-comp = item-tipo-loc.qtd-comp
                       l-mistura    = item-tipo-loc.mistura
                       l-compartilha = item-tipo-loc.compartilha.

                if i-qtd-autom <= 0 then next.
                                               
                assign l-achou = no.
                
                /* busca localizacao vaga do tipo que nao seja unica */                                                                     
                for each local no-lock
                   where local.loc-unica = no
                     and local.cod-estabel = pi-cod-estabel
                     and local.cod-depos = c-depos-ent
                     and local.cod-tipo  = item-tipo-loc.cod-tipo:
                     
                     /* disp stream arq "[{&LINE-NUMBER}]: " "tentativa na loc: " local.localizacao with frame f1412 width 131. */
                     
                     find first saldo-estoq use-index dep-estabel
                          where saldo-estoq.cod-estabel = pi-cod-estabel
                            and saldo-estoq.cod-depos   = c-depos-ent 
                            and saldo-estoq.cod-localiz = local.localizacao
                            and saldo-estoq.qtidade-atu > 0 
                            no-lock no-error.
                     if not avail saldo-estoq then do:
                        
                        /* disp stream arq "[{&LINE-NUMBER}]: " "localiz: " local.localizacao with frame f1412 width 131. */
                         
                        assign l-liberado = yes.
                        
                        /* o teste de log baixado so e utilizado na expedicao
                           por isso o IF abaixo */
                        
                        if c-depos-ent = "exp" then do:
                            for each b-saldo-estoq use-index dep-estabel
                               where b-saldo-estoq.cod-estabel = pi-cod-estabel
                                 and b-saldo-estoq.cod-depos   = c-depos-ent 
                                 and b-saldo-estoq.cod-localiz = local.localizacao no-lock:
                        
                              find int-saldo-estoq 
                                 where int-saldo-estoq.cod-estabel = b-saldo-estoq.cod-estabel
                                   and int-saldo-estoq.cod-depos   = b-saldo-estoq.cod-depos
                                   and int-saldo-estoq.it-codigo   = b-saldo-estoq.it-codigo
                                   and int-saldo-estoq.cod-localiz = b-saldo-estoq.cod-localiz
                                   and not int-saldo-estoq.log-baixado 
                                 no-lock no-error.
                     
                              if avail int-saldo-estoq then
                                 assign l-liberado = no.
                           end.
                        end.       
                        /* disp stream arq "[{&LINE-NUMBER}]: " "situacao liberacao " l-liberado with frame f14121 width 131. */
                               
    
                        if l-liberado then do:
                           assign c-local = local.localizacao
                                  l-achou = yes.
                           leave.
                        end.
                     end.
                end.  /* each local */ 
    
                if not l-achou then do:
    
                    
    /*                 if tipo-local.unico then do:       /* Emerson - Comentei porque se olhar o 'For each' acima, nunca entra nesta condiá∆o */     */
    /*                                                                                                                                                */
    /*                     /* disp stream arq "[{&LINE-NUMBER}]: " "Tipo unico" with no-labels frame f-145 width 131. */                              */
    /*                                                                                                                                                */
    /*                     /* busca saldo suficiente */                                                                                               */
    /*                                                                                                                                                */
    /*                     if item-tipo-loc.compartilha then do:                                                                                      */
    /*                          /* disp stream arq "[{&LINE-NUMBER}]: " "Item compartilha " skip                                                      */
    /*                              "sai fora" with no-labels frame f-146 width 131. */                                                               */
    /*                          next.                                                                                                                 */
    /*                     end.                                                                                                                       */
    /*                     for each local no-lock                                                                                                     */
    /*                        where local.cod-estabel = pi-cod-estabel                                                                                */
    /*                          and local.cod-depos   = c-depos-ent                                                                                   */
    /*                          and local.cod-tipo    = item-tipo-loc.cod-tipo:                                                                       */
    /*                         find first saldo-estoq use-index dep-estabel                                                                           */
    /*                              where saldo-estoq.it-codigo   = c-it-codigo                                                                       */
    /*                                and saldo-estoq.cod-estabel = pi-cod-estabel                                                                    */
    /*                                and saldo-estoq.cod-depos   = c-depos-ent                                                                       */
    /*                                and saldo-estoq.cod-localiz = local.localizacao                                                                 */
    /*                                and saldo-estoq.qtidade-atu + i-qtd-autom <                                                                     */
    /*                                    i-capacidade no-lock no-error.                                                                              */
    /*                         if avail saldo-estoq then do:                                                                                          */
    /*                             assign c-local = saldo-estoq.cod-localiz                                                                           */
    /*                                    l-achou = yes.                                                                                              */
    /*                         end.                                                                                                                   */
    /*                         else do:                                                                                                               */
    /*                             /* disp stream arq "[{&LINE-NUMBER}]: " "nao achou saldo estoque " with no-labels frame f-150 width 131. */        */
    /*                         end.                                                                                                                   */
    /*                     end.                                                                                                                       */
    /*                     if not l-achou then do:                                                                                                    */
    /*                        /* disp stream arq "[{&LINE-NUMBER}]: " "Nao achou nenhum local no tipo unico" with no-labels frame f-151 width 131. */ */
    /*                        next.                                                                                                                   */
    /*                     end.                                                                                                                       */
    /*                 end.     /* tipo unico */                                                                                                      */
    /*                  else do:                                                                                                                      */
    
                        /* verifica se aceita compartilhado no mesmo local */
                        
                        if not item-tipo-loc.compartilha then do:
                             /* disp stream arq "[{&LINE-NUMBER}]: " "Item nao compartilha " with no-labels frame f-152 width 131. */
                             next.
                        end.
                        else do:  /* compartilha */
                        
                            /* busca localizacao compartilhada */ 
    
                            for each local no-lock
                               where local.cod-tipo    = item-tipo-loc.cod-tipo
                                 and local.cod-estabel = pi-cod-estabel
                                 and local.cod-depos   = c-depos-ent:
                                assign num-comp = 0
                                       proprio-item = no.
                               
                                for each saldo-estoq no-lock
                                   where saldo-estoq.cod-estabel = pi-cod-estabel
                                     and saldo-estoq.cod-depos = c-depos-ent
                                     and saldo-estoq.cod-localiz = local.localizacao,
                                   first int-saldo-estoq no-lock
                                   where int-saldo-estoq.cod-estabel = saldo-estoq.cod-estabel
                                     and int-saldo-estoq.cod-depos   = saldo-estoq.cod-depos
                                     and int-saldo-estoq.it-codigo   = saldo-estoq.it-codigo
                                     and int-saldo-estoq.cod-localiz = saldo-estoq.cod-localiz
                                     and not int-saldo-estoq.log-baixado:
                                     assign num-comp = num-comp + 1.
                                     if saldo-estoq.it-codigo = c-it-codigo then
                                        assign proprio-item = yes
                                               saldo-proprio = saldo-estoq.qtidade-atu
                                               local-proprio = saldo-estoq.cod-localiz.                             
                                end.
    
                                if num-comp < 2 then do:
                                    assign c-local = local.localizacao
                                           l-achou = yes.
                                    leave.
                                end.
                                if proprio-item then do:
                                    if saldo-proprio + i-qtd-autom <= i-capac-comp then do:
                                        assign c-local = local-proprio
                                               l-achou = yes.
                                        leave.
                                    end.
                                end.
                                if i-qtd-autom <= i-capac-comp then do:
                                    assign c-local = local.localizacao
                                           l-achou = yes.
                                    leave.
                                end.
                            end.
                        end. 
                    
                        if not l-achou then do:                                
                            /* disp stream arq "[{&LINE-NUMBER}]: " "nao achou local compartilhado " with no-labels frame f-157 width 131. */
                            next.
                        end.
                        else do:
                            /* disp stream arq "[{&LINE-NUMBER}]: " "achou local :" c-local with no-labels frame f-155 width 131. */
                        end.
                   /*  end. */
                
                end.  /* if l-achou */
    
                else do:
                    /* disp stream arq "[{&LINE-NUMBER}]: " "achou a localizacao " c-local with no-labels frame f-143 width 131. */
                end.

                run aloca.
                if return-value = "NOK" then UNDO proc-loc-autom, LEAVE proc-loc-autom.
    
                 
            end. /* each item-tipo-lock */
    
            /* verifica se a quantidade e maior que zero (nao achou local) */
            
            if i-qtd-autom > 0 then do:
    
               /* disp stream arq "[{&LINE-NUMBER}]: " "vai usar local branco" with no-labels frame f-160 width 131. */
    
               assign c-local = "".

                run aloca.
                if return-value = "NOK" then UNDO proc-loc-autom, LEAVE proc-loc-autom.
    
            end.
        end. /* each tt-ae */


    END.  /* DO TRANS */

    RETURN "OK":U.


end.

/* executa a tentativa inicial */

procedure aloca-inicial.
    
    /* disp stream arq skip "[{&LINE-NUMBER}]: " "entrou no aloca-inicial, i-qtd-trans = " i-qtd-trans with no-labels frame f-7 width 131. */
  
    assign c-local = item-uni-estab.cod-localiz
           i-qtd-autom = i-qtd-trans.

    run testa-local.

    /* busca saldo na localizacao padrao */
    
    find first saldo-estoq
         where saldo-estoq.cod-depos   = c-depos-ent
           AND saldo-estoq.cod-estabel = pi-cod-estabel
           and saldo-estoq.cod-localiz = item-uni-estab.cod-localiz 
           and saldo-estoq.qtidade-atu > 0 no-lock no-error.
    
    if avail saldo-estoq then do:
        if saldo-estoq.qtidade-atu + i-qtd-trans <= i-capacidade then do:

            /* disp stream arq "[{&LINE-NUMBER}]: " "tem saldo na padrao e cabe" 
            saldo-estoq.cod-localiz
            saldo-estoq.qtidade-atu i-capacidade with no-labels frame f116 width 131. */
            /* incluido testa-local em 27/12/2004 por Flavio */
                        
            run testa-local.
                                                                 
            if not avail local then next.
            
            run checa-mistura. 

            if not l-mistura then next.


              /*chaves
              if item-tipo-loc.compartilha = no */
              if AVAIL item-tipo-loc AND item-tipo-loc.compartilha = no 
                 and saldo-estoq.it-codigo <> item-uni-estab.it-codigo then do:
                         /* disp stream arq skip "[{&LINE-NUMBER}]: " "item nao compartilha" 
                         saldo-estoq.it-codigo
                         saldo-estoq.cod-localiz
                         saldo-estoq.qtidade-atu
                         with no-labels frame f20 width 131. */
                         assign l-usa-ult-loc = no.

                       /* disp stream arq "[{&LINE-NUMBER}]: " "saiu porque tem saldo de outro item" 
                       with no-labels frame f-102 width 131. */
                    
                       /*run disp-stream (input {&LINE-NUMBER}).*/
                    
                       next.
                   end.                 
           
           assign c-loc-ent = c-local.

          run processa-transferencia.

          if l-deu-erro then undo, RETURN "NOK".

          for each tt-ae:
              find first ae-item exclusive-lock
                   where ae-item.cod-estabel = pi-cod-estabel
                   and ae-item.nr-ae = tt-ae.nr-ae 
                   and ae-item.sequencia = tt-ae.sequencia NO-ERROR.
              assign ae-item.localizacao = c-loc-ent.

              find current ae-item no-lock.
          end.
          
          /* testar retorno com erro do processa transferencia */
          assign l-usa-ult-loc = yes
                 i-qtd-autom   = 0
                 l-alocou-ini  = yes.
        
          /* disp stream arq skip "[{&LINE-NUMBER}]: " "fim do aloca-inicial" with no-labels frame f10 width 131. */
        
        end.  
        else do:
            /* disp stream arq "[{&LINE-NUMBER}]: " "Nao coube na padrao" saldo-estoq.cod-localiz with no-labels frame f118 width 131. */
        end.
        
    end.

    if not avail saldo-estoq then do:

       find first b-saldo-estoq
            where b-saldo-estoq.cod-estabel = pi-cod-estabel 
              and b-saldo-estoq.cod-depos   = c-depos-ent
              and b-saldo-estoq.cod-localiz = item-uni-estab.cod-localiz no-lock no-error.
        if avail b-saldo-estoq then do:

              find int-saldo-estoq
             where int-saldo-estoq.cod-estabel = b-saldo-estoq.cod-estabel
               and int-saldo-estoq.cod-depos   = b-saldo-estoq.cod-depos
               and int-saldo-estoq.it-codigo   = b-saldo-estoq.it-codigo
               and int-saldo-estoq.cod-localiz = b-saldo-estoq.cod-localiz
               and not int-saldo-estoq.log-baixado  no-lock no-error.

           if avail int-saldo-estoq then
              next.
        end.       
        assign c-loc-ent   = c-local
               i-qtd-autom = i-qtd-trans. 

        /* disp stream arq skip "[{&LINE-NUMBER}]: " "nao achou registro de saldo na padrao"  with no-labels frame f11 width 131. */
        
        if i-qtd-autom > i-capacidade then do:
            /* disp stream arq "[{&LINE-NUMBER}]: " "nao tem registro de saldo na padrao e excede a capacidade" i-qtd-autom i-capacidade with no-labels frame f-128 width 131. */
            /*run disp-stream (input {&LINE-NUMBER}).*/
            next.
        end.

          run processa-transferencia.

          if l-deu-erro then undo, RETURN "NOK".

          for each tt-ae:
              find first ae-item exclusive-lock
                   where ae-item.cod-estabel = pi-cod-estabel
                   and ae-item.nr-ae = tt-ae.nr-ae 
                   and ae-item.sequencia = tt-ae.sequencia no-error.
              assign ae-item.localizacao = c-loc-ent.
              find current ae-item no-lock.
          
          end.

          /* testar retorno com erro do processa transferencia */

          assign l-usa-ult-loc = yes
                 i-qtd-autom   = 0
                 l-alocou-ini  = yes.
        
        /* disp stream arq skip "[{&LINE-NUMBER}]: " "fim da alocacao inicial sem saldo" with no-labels frame f-12 width 131. */
    end.
    /***** nao chegou aqui" *******/

    if l-alocou-ini then do:
    
        /* disp stream arq "[{&LINE-NUMBER}]: " "conseguiu alocar na primeira tentativa da padrao" with no-labels frame f-130 width 131. */


        for each tt-ae:
        
            find first ae-item no-lock
                 where ae-item.cod-estabel = pi-cod-estabel
                   and ae-item.nr-ae = tt-ae.nr-ae
                   and ae-item.sequencia = tt-ae.sequencia no-error.

            run imprime-ae.
        end.

        /*run disp-stream (input {&LINE-NUMBER}).*/
        next.
    end.

    /* disp stream arq "[{&LINE-NUMBER}]: " "nao conseguiu alocar na primeira tentativa da padrao" with no-labels frame f-131 width 131. */

    for each saldo-estoq no-lock
       where saldo-estoq.it-codigo = c-it-codigo 
         AND saldo-estoq.cod-estabel = pi-cod-estabel
         and saldo-estoq.cod-depos = c-depos-ent
         and saldo-estoq.cod-localiz <> item-uni-estab.cod-localiz
         and saldo-estoq.cod-localiz <> ""
         and saldo-estoq.qtidade-atu > 0 :
        assign c-local = saldo-estoq.cod-localiz.

        if l-alocou-ini then next. 
        
        /* disp stream arq skip "[{&LINE-NUMBER}]: " "busca locais do item com saldo " 
             saldo-estoq.cod-localiz saldo-estoq.qtidade-atu
             with no-labels frame f13 width 131. */
         
        run testa-local. 
        
        if not avail local then next.
       
        if saldo-estoq.qtidade-atu + i-qtd-autom > i-capacidade then do:
            /* disp stream arq "[{&LINE-NUMBER}]: " "excedeu capacidade"             saldo-estoq.cod-localiz saldo-estoq.qtidade-atu
            i-qtd-autom i-capacidade with no-labels frame f-132 width 131. */
            next.
        end.  

        run checa-mistura.  
        
        if not l-mistura then next.

        if not avail item-tipo-loc then do:
        
        /* disp stream arq "[{&LINE-NUMBER}]: " "Nao tem tipo definido, abortando " with no-labels frame f-4000 width 131. */
            next.
        end.
        
        assign c-loc-ent   = c-local .

          run processa-transferencia.

          if l-deu-erro then undo, RETURN "NOK".
        
          for each tt-ae:
              find first ae-item exclusive-lock
                   where ae-item.cod-estabel = pi-cod-estabel
                   and ae-item.nr-ae = tt-ae.nr-ae 
                   and ae-item.sequencia = tt-ae.sequencia no-error.
              assign ae-item.localizacao = c-loc-ent.
              find current ae-item no-lock.  
              if not l-usa-loc then 
                    run imprime-ae.
              else do:
                  if ae-item.cod-depos = "inj" or ae-item.cod-depos = "tam"                      then run imprime-ae.
              end.
          end.
          
          /* testar retorno com erro do processa transferencia */

          assign l-usa-ult-loc = yes
                 i-qtd-autom   = 0
                 l-alocou-ini  = yes.
    end.
    /* disp stream arq "[{&LINE-NUMBER}]: " "fim da alocacao-inicial" with no-labels frame f-134 width 131.  */

    RETURN "OK":U.

end.

/*procedure disp-stream:
    def input param pi-linha as int no-undo.
    /* disp stream arq substitute("[&1]: ", pi-linha) "termino " c-it-codigo i-nr-ae i-sequencia with no-labels frame f-99 width 131. */
end.*/

procedure checa-mistura.

    assign l-mistura = yes.
    
    /* disp stream arq "[{&LINE-NUMBER}]: " "entrou no checa mistura " with no-labels frame f-122 width 131. */

    if avail item-tipo-loc then do:

        if item-tipo-loc.mistura = no then do:

            /* disp stream arq "[{&LINE-NUMBER}]: " "item nao aceita mistura" with no-labels frame f-120 width 131. */
            if c-depos-ent = "EXP" and
               c-depos-sai = "ACA" then
               assign l-usa-ult-loc = no
                      l-mistura = no.

               find first ae-item
                    where ae-item.cod-estabel = pi-cod-estabel
                      and ae-item.it-codigo = c-it-codigo
                      and ae-item.situacao  = no
                      and ae-item.data      <> tt-ae.data
                      and ae-item.localizacao = c-local no-lock no-error.
               if avail ae-item then do:
                   assign l-usa-ult-loc = no. 
               
                   /* disp stream arq "[{&LINE-NUMBER}]: " "item nao mistura e tem outro ae" ae-item.nr-ae with no-labels frame f119 width 131. */
                   assign l-mistura = no.                
               end.
        end.
    end.
    else do:
        /* disp stream arq "[{&LINE-NUMBER}]: " "nao tem item-tipo-local definido" c-local with no-labels frame f-125 width 131. */
    end.
    /* disp stream arq "[{&LINE-NUMBER}]: " "saiu do checa mistura" with no-labels frame f-124 width 131. */
end.


procedure testa-local.

    /* disp stream arq skip "[{&LINE-NUMBER}]: " "entrou testa local"  with no-labels frame f16 width 131. */

    /* busca capacidade */
    
    find first local 
         where local.cod-estabel = pi-cod-estabel
           and local.cod-depos   = c-depos-ent
           and local.localizacao = c-local no-lock no-error.
           
    if not avail local then do:
     /* disp stream arq skip "[{&LINE-NUMBER}]: " "localizacao nao e valida" c-local with no-labels frame f17 width 131. */
     
        next.
    end.

    /* disp stream arq skip "[{&LINE-NUMBER}]: " 
    "busca item-tipo-loc "  c-it-codigo c-depos-ent local.cod-tipo      with no-labels frame f168 width 131. */
    
    find item-tipo-loc
         where item-tipo-loc.it-codigo = c-it-codigo
           and item-tipo-loc.cod-estabel = pi-cod-estabel
           and item-tipo-loc.cod-depos = c-depos-ent
           and item-tipo-loc.cod-tipo  = local.cod-tipo no-lock no-error.
           
    if avail item-tipo-loc THEN DO:
    
        assign i-capacidade = item-tipo-loc.quantidade
               i-capac-comp = item-tipo-loc.qtd-comp.

    END.
    else do:
        
        if opsys = "UNIX" then
            /* DISP stream arq "[{&LINE-NUMBER}]: " "Item-Tipo-Local Nao encontrado para: Deposito: " c-depos-ent " Tipo: " local.cod-tipo " . Providencie o cadastro. Transferencia Abortada" SKIP. */
            p-msg-erro = substitute("Item-Tipo-Local n∆o encontrado para: Dep¢sito: &1 Tipo: &2|Providencie o cadastro. Transferància abortada",  
                                    c-depos-ent,
                                    string(local.cod-tipo)).

        assign l-deu-erro = yes.

        assign i-capacidade = 1000000
               i-capac-comp = 1000000.

        leave.
    end.           

    /* disp stream arq "[{&LINE-NUMBER}]: " "capacidades definidas: "  i-capacidade i-capac-comp skip 
                    "saiu do testa local"
    with no-labels frame f115 width 131. */
end.

/* executa a colocacao no local */

procedure aloca.

    DEFINE VARIABLE d-qtd-saldo-estoq AS DECIMAL     NO-UNDO.

    
    /* disp stream arq skip "[{&LINE-NUMBER}]: " "entrou no aloca:" c-local with no-labels frame f18 width 131. */

    if c-local = "" then do:

     /* temporariamente o programa joga na localizacao padrao */
        
        assign c-loc-ent = ""
               i-qtd-trans = i-qtd-autom.

        run processa-transferencia.

        if l-deu-erro then undo, RETURN "NOK":U.
        
        assign l-usa-ult-loc = yes
               i-qtd-autom   = 0.
    
        run atualiza-ae. 
        
    end.
    else do:

        if not c-local = item-uni-estab.cod-localiz then do:
        
            /* disp stream arq skip "[{&LINE-NUMBER}]: " "localizacao diferente da padrao" with no-labels frame f19 width 131. */

            
            find first saldo-estoq use-index dep-estabel
                 where saldo-estoq.cod-depos = c-depos-ent
                   and saldo-estoq.cod-localiz = c-local
                   and saldo-estoq.it-codigo <> c-it-codigo
                   and saldo-estoq.qtidade-atu > 0  
                   and saldo-estoq.cod-estabel = pi-cod-estabel
                   no-lock no-error.

            if avail saldo-estoq then do:
                if not l-usa-loc then do:
                    
                   if item-tipo-loc.compartilha = no then do:
                         /* disp stream arq skip "[{&LINE-NUMBER}]: " "item nao compartilha" 
                         saldo-estoq.it-codigo
                         saldo-estoq.cod-localiz
                         saldo-estoq.qtidade-atu
                         with no-labels frame f20 width 131. */
                         assign l-usa-ult-loc = no.

                       /*disp stream arq "[{&LINE-NUMBER}]: " "saiu porque tem saldo de outro item" 
                       with no-labels frame f-102 width 131. */
                    
                       /*run disp-stream (input {&LINE-NUMBER}).*/
                    
                       next.
                   end.                 
                
                end.

                
                
                find b-item-tipo-loc
                     where b-item-tipo-loc.cod-tipo = item-tipo-loc.cod-tipo
                       and b-item-tipo-loc.it-codigo = saldo-estoq.it-codigo
                       and b-item-tipo-loc.cod-depos = saldo-estoq.cod-depos
                           no-lock no-error.
          
              /*  
                if not avail b-item-tipo-loc then do:
                      disp stream arq skip "o outro item nao compartilha" 
                      saldo-estoq.it-codigo with no-labels frame f-21 width 131.
                    assign l-usa-ult-loc = no.
                    next.
                end. 
                */

                if avail b-item-tipo-loc then do:

                    if b-item-tipo-loc.compartilha = no then do:
                 
                      if not l-usa-loc then do:
                         /* disp stream arq skip "[{&LINE-NUMBER}]: " "o outro item nao compartilha dois" with no-labels frame f-22 width 131. */
                         assign  l-usa-ult-loc = no.
                        next.
                      end.
                   end.
                   /* disp stream arq skip "[{&LINE-NUMBER}]: " "os dois compartilham " 
                   item-tipo-loc.qtd-comp with no-labels frame f-23 width 131. */

                  if not l-usa-loc then
                      assign i-capacidade = item-tipo-loc.qtd-comp.
                  else
                      assign i-capacidade = item-tipo-loc.quantidade.

                end.
            end.
        end.
        
        find first saldo-estoq use-index dep-estabel
             where saldo-estoq.cod-depos   = c-depos-ent
               and saldo-estoq.it-codigo   = c-it-codigo
               and saldo-estoq.cod-estabel = pi-cod-estabel
               and saldo-estoq.cod-localiz = c-local 
               and saldo-estoq.qtidade-atu > 0 no-lock no-error.
        
        assign de-qtde = 0.
        
        if avail item-tipo-loc and item-tipo-loc.compartilha then do:
           for each ae-baixa no-lock
               where ae-baixa.cod-estabel = pi-cod-estabel,
               first ae-item no-lock where
                     ae-item.cod-estabel = pi-cod-estabel and 
                     ae-item.nr-ae       = ae-baixa.nr-ae and
                     ae-item.it-codigo   = c-it-codigo and
                     ae-item.localizacao = c-local:
               assign de-qtde = de-qtde + ae-item.quantidade.
           end.
        end.

        ASSIGN d-qtd-saldo-estoq = IF AVAIL saldo-estoq THEN saldo-estoq.qtidade-atu ELSE 0.
        
        if avail saldo-estoq or de-qtde <> 0 then do:
            
            if d-qtd-saldo-estoq + i-qtd-autom + de-qtde > i-capacidade then do:

               /* disp stream arq skip "[{&LINE-NUMBER}]: " "quantidade excede capacidade" 
               saldo-estoq.cod-localiz with no-labels frame f-24 width 131. */
               
                assign l-usa-ult-loc = no.

                next.
            end.
        end.
        else do:
            if i-qtd-autom + de-qtde > i-capacidade then do:
               /* disp stream arq skip "[{&LINE-NUMBER}]: " "quantidade excede capacidade (2)" 
               c-local with no-labels frame f-240 width 131. */
               assign l-usa-ult-loc = no.

               next.
            end.
        end.
        
        if not l-usa-loc then do:
            if not item-tipo-loc.mistura and avail saldo-estoq then do:
                 /* disp stream arq skip "[{&LINE-NUMBER}]: " "nao mistura" with no-labels frame f-25 width 131. */
                find first ae-item 
                     where ae-item.cod-estabel = pi-cod-estabel
                       and ae-item.it-codigo = c-it-codigo
                       and ae-item.situacao  = no
                       and ae-item.data      <> tt-ae.data
                       and ae-item.localizacao = c-local no-lock no-error.
                if avail ae-item then do:
                     assign l-usa-ult-loc = no.

                    next.
                end.
        
            end.
        end.
        assign c-loc-ent   = c-local
               i-qtd-trans = i-qtd-autom.

        run processa-transferencia.

        if l-deu-erro then undo, return "NOK".

        if l-usa-loc and param-depos.cria-ae and l-devolucao THEN DO:

           run gera-ae.    /********* CLAUDINEY" *********/

        END.
           
        assign l-usa-ult-loc = yes
               i-qtd-autom   = 0.

        run atualiza-ae.
    end.

    /* disp stream arq "[{&LINE-NUMBER}]: " "saiu do aloca" with no-labels frame f101 width 131. */

    RETURN "OK":U.

end.

procedure atualiza-ae.

        find first ae-item exclusive-lock
             where ae-item.cod-estabel = pi-cod-estabel
               and ae-item.nr-ae = tt-ae.nr-ae
               and ae-item.sequencia = tt-ae.sequencia NO-ERROR.
        IF NOT AVAIL ae-item THEN RETURN. /* Giovane Alves - Developer - 28/03/2006 */
        if not l-parcial then
           assign ae-item.localizacao = c-local.

        find current ae-item no-lock.
        
        if not l-usa-loc then 
           run imprime-ae.
end.
        
/* executa a transferencia */
       
procedure processa-transferencia.

    EMPTY TEMP-TABLE tt-erro.
    EMPTY TEMP-TABLE tt-movto. 
    
    /* disp stream arq skip "[{&LINE-NUMBER}]: " "PROCESSA-TRANSFERENCIA" c-it-codigo i-nr-ae 
     with no-labels frame fT width 131. */

     
    /* disp stream arq skip "[{&LINE-NUMBER}]: " "TRANSFERENCIA-Saida" trim(string(i-nro-docto)) c-serie lower(c-depos-sai) c-loc-sai i-qtd-trans
     with no-labels frame fTS width 131. */
     
    /* MOVIMENTO DE SA÷DA */ 
    create tt-movto. 

    assign tt-movto.cod-versao-integracao = 001
           tt-movto.cod-prog-orig   = "es0478"
           tt-movto.cod-depos       = lower(c-depos-sai)
           tt-movto.cod-localiz     = c-loc-sai
           tt-movto.cod-estabel     = pi-cod-estabel
           tt-movto.ct-codigo       = pa-ct-codigo 
           tt-movto.sc-codigo       = pa-sc-codigo
           tt-movto.esp-docto       = 33
           tt-movto.it-codigo       = c-it-codigo
           tt-movto.nro-docto       = trim(string(i-nro-docto))
           tt-movto.cod-emitente    = i-emitente
           tt-movto.quantidade      = i-qtd-trans
           tt-movto.serie-docto     = c-serie
           tt-movto.tipo-trans      = 2     /* saida */
           tt-movto.un              = item.un
           tt-movto.num-sequen      = 1
           tt-movto.dt-trans        = dt-trans
           tt-movto.descricao-db    = c-historico
           tt-movto.usuario         = IF OPSYS = "UNIX" THEN entry(1,c-historico,"-") ELSE c-seg-usuario.

    IF ITEM.tipo-con-est = 3 THEN DO: /* Item Controlado por Lote */ 
       IF i-roteiro <> 0 THEN DO:
          FIND FIRST ficha-cq NO-LOCK
               WHERE ficha-cq.nr-ficha = i-roteiro NO-ERROR.
          IF AVAIL ficha-cq THEN
             ASSIGN tt-movto.lote = ficha-cq.lote.
          ELSE
             ASSIGN tt-movto.lote = "GENERICO".
       END.
       ELSE DO:
          FIND FIRST saldo-estoq NO-LOCK          
               WHERE saldo-estoq.cod-estabel = pi-cod-estabel     
                 AND saldo-estoq.cod-depos   = c-depos-sai        
                 AND saldo-estoq.cod-localiz = c-loc-sai  
                 AND saldo-estoq.it-codigo   = c-it-codigo       
                 AND saldo-estoq.qtidade-atu > 0 NO-ERROR.               
          IF AVAIL saldo-estoq THEN 
             ASSIGN tt-movto.lote = saldo-estoq.lote.
          ELSE
             ASSIGN tt-movto.lote = "GENERICO".
       END.
    END.

    /*** Seta Unidade de Neg¢cio para ems2.06 ***/
    
    IF  l-unidade-negocio
    AND l-mat-unid-negoc THEN DO:

        IF CAN-FIND (FIRST item-uni-estab 
            WHERE item-uni-estab.cod-estabel = pi-cod-estabel AND
                  item-uni-estab.it-codigo   = c-it-codigo) THEN
            ASSIGN c-unid-negoc = item-uni-estab.cod-unid-negoc.
        ELSE ASSIGN c-unid-negoc = "".

        /* EMS206
        run cdp/cdapi024.p persistent set h-cdapi024.
        if  valid-handle(h-cdapi024) then do:
            run retornaUnidadeNegocio IN h-cdapi024 (input tt-movto.cod-estabel,
                                                     input tt-movto.it-codigo,
                                                     input tt-movto.cod-depos,
                                                     output tt-movto.cod-unid-negoc).

            delete procedure h-cdapi024.
            assign h-cdapi024 = ?.
        end.
        
        ASSIGN c-unid-negoc = tt-movto.cod-unid-negoc.
        */
    end.
    ELSE
        ASSIGN c-unid-negoc = "".
    

                                                                                           
    /* disp stream arq skip "[{&LINE-NUMBER}]: " "TRANSFERENCIA-Entrada" trim(string(i-nro-docto)) c-serie lower(c-depos-ent) c-loc-ent i-qtd-trans 
     with no-labels frame fTE width 131. */

    /* MOVIMENTO DE ENTRADA */
    create tt-movto.   

    assign tt-movto.cod-versao-integracao = 001
           tt-movto.cod-prog-orig   = "es0478"
           tt-movto.cod-depos       = lower(c-depos-ent)
           tt-movto.cod-localiz     = c-loc-ent
           tt-movto.cod-estabel     = pi-cod-estabel
           tt-movto.ct-codigo       = pa-ct-codigo
           tt-movto.sc-codigo       = pa-sc-codigo
           tt-movto.esp-docto       = 33
           tt-movto.it-codigo       = c-it-codigo
           tt-movto.cod-emitente    = i-emitente
           tt-movto.nro-docto       = trim(string(i-nro-docto))
           tt-movto.quantidade      = i-qtd-trans
           tt-movto.serie-docto     = c-serie
           tt-movto.tipo-trans      = 1        /* entrada */
           tt-movto.un              = item.un
           tt-movto.num-sequen      = 1
           tt-movto.dt-trans        = dt-trans
           tt-movto.descricao-db    = c-historico
           tt-movto.cod-unid-negoc  = IF  l-unidade-negocio AND l-mat-unid-negoc THEN c-unid-negoc ELSE ""
           tt-movto.usuario         = IF OPSYS = "UNIX" THEN entry(1,c-historico,"-") ELSE c-seg-usuario.

    IF ITEM.tipo-con-est = 3 THEN DO: /* Item Controlado por Lote */ 
       IF i-roteiro <> 0 THEN DO:
          FIND FIRST ficha-cq NO-LOCK
               WHERE ficha-cq.nr-ficha = i-roteiro NO-ERROR.
          IF AVAIL ficha-cq THEN
             ASSIGN tt-movto.lote = ficha-cq.lote.
          ELSE
             ASSIGN tt-movto.lote = "GENERICO".
       END.
       ELSE DO:
          FIND FIRST saldo-estoq NO-LOCK          
               WHERE saldo-estoq.cod-estabel = pi-cod-estabel     
                 AND saldo-estoq.cod-depos   = c-depos-sai        
                 AND saldo-estoq.cod-localiz = c-loc-sai  
                 AND saldo-estoq.it-codigo   = c-it-codigo       
                 AND saldo-estoq.qtidade-atu > 0 NO-ERROR.               
          IF AVAIL saldo-estoq THEN 
             ASSIGN tt-movto.lote = saldo-estoq.lote.
          ELSE
             ASSIGN tt-movto.lote = "GENERICO".
       END.
    END.

    run cep/ceapi001k.p persistent set h-ceapi001k.
    if  valid-handle (h-ceapi001k) then do:
        run pi-execute IN h-ceapi001k (input-output table tt-movto,
                                       input-output table tt-erro, 
                                       input        yes).

        delete procedure h-ceapi001k.
        assign h-ceapi001k = ?.
    end.

    find first tt-erro no-error.
    if avail tt-erro OR RETURN-VALUE = "NOK" then do:
        assign l-deu-erro = YES. 

        if opsys = "UNIX" then
            p-msg-erro = "Ocorreu um erro na transferància. Verifique abaixo|" + tt-erro.mensagem.
        else
            RUN cdp/cd0666.p (INPUT TABLE tt-erro).

        /* disp stream arq "[{&LINE-NUMBER}]: " "Esta dando erros na ceapi001k "  c-loc-sai c-depos-sai c-loc-ent c-depos-ent SKIP 
             SUBSTRING(tt-erro.mensagem,1,300) FORMAT "x(300)" WITH WIDTH 350 no-labels frame f-erros. */
        undo, return.
    end.
    if not avail tt-erro then do:
        assign l-deu-erro = no. 

        if avail bx-ae-item then do:
           /* disp stream arq "[{&LINE-NUMBER}]: " "Vou mudar situacao do AE" with no-labels frame f-5100 width 131. */
           find current bx-ae-item exclusive-lock no-error.
           assign bx-ae-item.situacao = yes.
           find current bx-ae-item no-lock no-error.
        end.   
            
        RUN pi-processa-item-critico.

    end. 
    for each tt-erro:
        delete tt-erro.
    end.
    for each tt-movto.
        delete tt-movto.
    end.
    
end. /* processa transferencia */


/* procedure para geracao de novas aes */        
        
procedure gera-ae.

    DEFINE VARIABLE r-ae-item AS ROWID       NO-UNDO.


    /* disp stream arq skip "[{&LINE-NUMBER}]: " "GERA-AE" c-it-codigo i-nr-ae i-sequencia
     with no-labels frame fga width 131. */
    
    if not l-parcial and not l-devolucao and
       c-depos-ent = "exp" and i-nr-ae <> 0 then next. 
    
    assign da-data = 12/31/2999.
    
    if l-devolucao or l-parcial then do:

        if (c-depos-sai <> "fal" AND c-depos-sai <> "hml" AND c-depos-sai <> "dev") OR
           (c-depos-sai = "hml" AND c-depos-ent = "alm" AND l-devolucao)
            then do:
            
            ASSIGN r-ae-item = ?.

            FOR EACH b-ae-item-dois NO-LOCK
                WHERE b-ae-item-dois.cod-estabel = pi-cod-estabel
                AND   b-ae-item-dois.cod-depos   = c-depos-ent
                AND   b-ae-item-dois.it-codigo   = c-it-codigo:

                IF b-ae-item-dois.situacao = NO THEN DO:

                    IF b-ae-item-dois.data < da-data THEN DO:

                        ASSIGN da-data = b-ae-item-dois.data
                               r-ae-item = ROWID(b-ae-item-dois).

                    END.

                END.

            END.

            FOR FIRST b-ae-item-dois NO-LOCK
                WHERE ROWID(b-ae-item-dois) = r-ae-item:
            END.

           if avail b-ae-item-dois then DO:

               assign da-data = b-ae-item-dois.data - 1 .

               IF c-depos-sai = "hml" AND 
                  c-depos-ent = "alm" AND
                  l-devolucao AND
                  b-ae-item-dois.roteiro <> 0 THEN DO:

                   FIND FIRST ficha-cq EXCLUSIVE-LOCK
                       WHERE ficha-cq.nr-ficha = b-ae-item-dois.roteiro NO-ERROR.
                   IF AVAIL ficha-cq THEN DO:

                       ASSIGN ficha-cq.narrativa = IF OPSYS = "UNIX" THEN entry(1,c-historico,"-") + " Alterado FIFO para Homologacao."
                                                   ELSE c-seg-usuario + " Alterado FIFO para Homologacao.".
                   END.
               END.


           END.
        end.

    end.

    IF da-data = 12/31/2999 THEN
        assign da-data = today.

    if i-nr-ae = 0 then do:  /* gera nova ae quando nao souber o numero da ae*/
        IF NOT CAN-FIND (FIRST aviso-entrada
                         WHERE aviso-entrada.cod-estabel = pi-cod-estabel) THEN DO:
            CREATE aviso-entrada.
            ASSIGN aviso-entrada.cod-estabel = pi-cod-estabel
                   aviso-entrada.ultimo-ae   = 1.
                   
        END.
        ELSE DO:
            repeat:
                find first aviso-entrada exclusive-lock 
                    where aviso-entrada.cod-estabel = pi-cod-estabel no-error no-wait.
                if not locked(aviso-entrada) then do:    
                    assign i-nova-ae = aviso-entrada.ultimo-ae + 1
                           aviso-entrada.ultimo-ae = i-nova-ae.
                    find current aviso-entrada NO-LOCK NO-ERROR.
                    leave.
                end.
                
                pause 30.
            end.               
        END.
    end.
    else assign i-nova-ae = i-nr-ae.

    assign i-nova-seq = 1
           i-nova-qtd = i-qtd-trans.

    if l-parcial then do:
        
        find first ae-item no-lock
             where ae-item.cod-estabel = pi-cod-estabel
               and ae-item.nr-ae = i-nr-ae
               and ae-item.sequencia = i-sequencia no-error. 
        assign i-nova-qtd = ae-item.quantidade - i-quantidade.
        find last ae-item use-index it-ae-seq no-lock
            where ae-item.cod-estabel = pi-cod-estabel 
              and ae-item.nr-ae = i-nr-ae
              and ae-item.it-codigo = c-it-codigo no-error.
        assign i-seq-ini = ae-item.sequencia + 1
               da-data    = ae-item.data
               dt-validade = ae-item.data-validade.
    end.

    assign i-qtd-lote  = trunc((i-nova-qtd / i-contenedor),0)
           i-qtd-resto = ((i-nova-qtd / i-contenedor) - i-qtd-lote) * 
                          i-contenedor.
   
    assign i-cont = i-seq-ini.

    if c-depos-sai = "hml" THEN DO:
        IF NOT (c-depos-sai = "hml" AND c-depos-ent = "alm" AND l-devolucao) THEN
             assign da-data = today.
    END.
      
    
    /* disp stream arq skip "[{&LINE-NUMBER}]: " "GERACAO" c-it-codigo i-nova-ae i-sequencia i-qtd-lote i-qtd-resto
     with no-labels frame fga1 width 131. */

    if i-qtd-lote > 0 then do:
        do i-cont = i-seq-ini to i-qtd-lote + i-seq-ini - 1:

            create ae-item.
            assign ae-item.cod-estabel = pi-cod-estabel
                   ae-item.it-codigo   = c-it-codigo
                   ae-item.localizacao = if l-parcial then c-loc-sai else c-loc-ent
                   ae-item.nr-ae       = i-nova-ae
                   ae-item.sequencia   = i-cont
                   ae-item.quantidade  = i-contenedor
                   ae-item.data        = da-data
                   ae-item.roteiro     = i-roteiro
                   ae-item.nf          = i-nf 
                   ae-item.data-validade = dt-validade 
                   ae-item.cod-depos     = if l-parcial then c-depos-sai else c-depos-ent.
            
            create tt-ae.
            assign tt-ae.nr-ae = i-nova-ae
                   tt-ae.sequencia = i-cont
                   tt-ae.quantidade = i-contenedor
                   tt-ae.data = da-data.
            if not param-depos.loc-autom or l-devolucao or l-parcial then 
                run imprime-ae.
           else do:
               if ae-item.cod-depos = "inj" or ae-item.cod-depos = "tam"  then
                run imprime-ae.
           end.
        end.
    end.    

    if i-qtd-resto > 0 then do:
    
        create ae-item.
        assign ae-item.cod-estabel = pi-cod-estabel
               ae-item.it-codigo   = c-it-codigo
               ae-item.localizacao = if l-parcial then c-loc-sai else c-loc-ent
               ae-item.nr-ae       = i-nova-ae
               ae-item.sequencia   = i-cont
               ae-item.quantidade  = i-qtd-resto
               ae-item.data        = da-data
               ae-item.roteiro     = i-roteiro
               ae-item.nf          = i-nf
               ae-item.data-validade = dt-validade
               ae-item.cod-depos     = if l-parcial then c-depos-sai else c-depos-ent.

            create tt-ae.
            assign tt-ae.nr-ae = i-nova-ae
                   tt-ae.sequencia = i-cont
                   tt-ae.quantidade = i-qtd-resto
                   tt-ae.data = da-data.
            if not param-depos.loc-autom or l-devolucao or l-parcial then do:
               run imprime-ae.
            end.
    end.
end.

/* procedure para impressao de novas aes geradas */

procedure imprime-ae.
    
    def var l-continua as logical no-undo.
    DEFINE VARIABLE h_esapi020 AS HANDLE NO-UNDO.

    IF NOT l-deu-erro then do:
        
        IF SESSION:REMOTE THEN
            c-arquivo = session:TEMP-DIRECTORY + replace(STRING(TIME,"HH:MM:SS"),":","") + string(random(1,100),"999").
        ELSE
            c-arquivo = ENTRY(2,c-livre,",").


        IF NOT valid-handle(h_esapi020) THEN 
            RUN esapi/esapi020.p PERSISTENT SET h_esapi020.

        RUN pi-imprime-AE IN h_esapi020 (INPUT c-arquivo,
                                         INPUT ae-item.cod-estabel,
                                         INPUT ae-item.nr-ae,
                                         INPUT ae-item.sequencia,      
                                         INPUT c-seg-usuario).

        
        find current ae-item exclusive-lock no-error.
        ASSIGN ae-item.impresso = yes.            
        find current ae-item no-lock.

        if opsys = "UNIX" THEN DO:
            DEF BUFFER b-tt-etiqueta FOR tt-etiqueta.
        
            INPUT FROM VALUE(c-arquivo).
            REPEAT:
                CREATE tt-etiqueta.
                FIND LAST b-tt-etiqueta NO-ERROR.
                ASSIGN tt-etiqueta.num = IF AVAIL b-tt-etiqueta THEN 
                                         b-tt-etiqueta.num + 1 ELSE 1.
                IMPORT UNFORMATTED tt-etiqueta.linha.
                tt-etiqueta.linha = TRIM(tt-etiqueta.linha).
                IF LENGTH(tt-etiqueta.linha) = 0 THEN DELETE tt-etiqueta.
            END.
            INPUT CLOSE.
            OS-DELETE VALUE(c-arquivo).
            RETURN.
        END.
    END. 

    /*
    &SCOPED-DEFINE PROGRAMAS ESSFC001,ESCEP013,ESAPI001,ESCQP004,ESCEP016,ESCEP027,ESCEP047,ESCEP048
    
    def var l-continua as logical no-undo.
    
    if not l-deu-erro then do:
   
   

   
      &IF "{&EXEC-RPC}" = "YES" &THEN
          DEF BUFFER b-tt-etiqueta FOR tt-etiqueta.
    
          assign c-linha = substring(ae-item.it-codigo,1,7)   +
                           string(ae-item.quantidade,"99999") +
                           string(ae-item.nr-ae,"9999999")    +
                           string(ae-item.sequencia,"999").
          
          
    
          
               
          run esp/es0135.p(input c-linha, output i-it-digito).
    
          assign c-linha = c-linha + string(i-it-digito,"9").
          
          
    
          IF SESSION:REMOTE THEN
              c-arquivo = session:TEMP-DIRECTORY + replace(STRING(TIME,"HH:MM:SS"),":","") + 
                                            string(random(1,100),"999").
          ELSE DO:
    
              EMPTY TEMP-TABLE tt-prog-ponto.
    
              RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                                 INPUT 1,
                                 INPUT 0,
                                 INPUT "":U,
                                 OUTPUT TABLE tt-prog-ponto).
              
              FOR FIRST tt-prog-ponto:
              
                  ASSIGN c-dir-saida = replace(tt-prog-ponto.conteudo, "/", "~\").
              
                  IF SUBSTRING(c-dir-saida, LENGTH(c-dir-saida), 1) <> "~\" THEN
                      ASSIGN c-dir-saida = c-dir-saida + "~\".
              
              END.
    
              c-arquivo = c-dir-saida + "spool~\" + replace(STRING(TIME,"HH:MM:SS"),":","") + string(random(1,100),"999").
    
          END.
              
    
          
          
          output to value(c-arquivo).
    
          IF ENTRY(2,c-livre,",") MATCHES "*barra*" THEN DO:
              {esp/es0478.iz2} /* zebra */
          END.
          ELSE DO:
              {esp/es0478.iz}
          END.
          
          find current ae-item exclusive-lock no-error.
          ASSIGN ae-item.impresso = yes.            
          find current ae-item no-lock.
          
          OUTPUT CLOSE.
          
          INPUT FROM VALUE(c-arquivo).
          REPEAT:
              CREATE tt-etiqueta.
              FIND LAST b-tt-etiqueta NO-ERROR.
              ASSIGN tt-etiqueta.num = IF AVAIL b-tt-etiqueta THEN 
                                       b-tt-etiqueta.num + 1 ELSE 1.
              IMPORT UNFORMATTED tt-etiqueta.linha.
              tt-etiqueta.linha = TRIM(tt-etiqueta.linha).
              IF LENGTH(tt-etiqueta.linha) = 0 THEN DELETE tt-etiqueta.
          END.
          INPUT CLOSE.
          OS-DELETE VALUE(c-arquivo).
          RETURN.
      &else
          assign c-linha = substring(ae-item.it-codigo,1,7)   +
                           string(ae-item.quantidade,"99999") +
                           string(ae-item.nr-ae,"9999999")    +
                           string(ae-item.sequencia,"999").
           
          
     
          run esp/es0135.p(input c-linha, output i-it-digito).
    
          assign c-linha = c-linha + string(i-it-digito,"9").
    
    
          IF LOOKUP(ENTRY(1,c-livre,","), "{&PROGRAMAS}") > 0 THEN DO:
              OUTPUT TO VALUE(TRIM(ENTRY(2,c-livre,","))) page-size 0. /*PAGED PAGE-SIZE VALUE(99) CONVERT TARGET 'iso8859-1'*/ 
          END.
          ELSE DO:
              IF SESSION:REMOTE THEN
                c-arquivo = session:TEMP-DIRECTORY + replace(STRING(TIME,"HH:MM:SS"),":","") + 
                                            string(random(1,100),"999").
              ELSE
                c-arquivo = c-dir-saida + "spool~\" + replace(STRING(TIME,"HH:MM:SS"),":","") + 
                                            string(random(1,100),"999").
    
            find current ae-item exclusive-lock no-error.
            ASSIGN ae-item.impresso = yes.            
            find current ae-item no-lock.
      
              output to value(c-arquivo).
          END.
     
          if i-barra = 1 or i-barra = 2 or i-barra = 3 then DO:
              IF ENTRY(2,c-livre,",") MATCHES "*barra*" THEN DO:
                  {esp/es0478.iz2} /* zebra */
              END.
              ELSE DO:
                   
              
                  {esp/es0478.iz}
              END.
          END.
          ELSE 
             {esp/es0478.ig} /* godex */
      
        
          IF LOOKUP(ENTRY(1,c-livre,","), "{&PROGRAMAS}") > 0 THEN DO:
                find current ae-item exclusive-lock no-error.
                ASSIGN ae-item.impresso = yes.            
                find current ae-item no-lock.
                OUTPUT CLOSE.
          END.
          ELSE output close.
       
          IF LOOKUP(ENTRY(1,c-livre,","), "{&PROGRAMAS}") = 0 THEN DO:
                if i-barra = 1 then  
                   unix silent lp -d barra value(c-arquivo) > /dev/null. 
                else 
                   if i-barra = 2 then 
                      unix silent lp -d barra2 value(c-arquivo) > /dev/null.
                   else do:
                      message " ". pause 0.
                      unix silent impesc-light value(c-arquivo).
                   end.
       
       
                unix silent rm value(c-arquivo).            
                hide message no-pause.
                pause 0.
          END.
      &endif
   end. */  
end.        


/*run disp-stream (input {&LINE-NUMBER}).*/

/* output stream arq close. */
  

PROCEDURE pi-processa-item-critico:

    DEFINE VARIABLE i-situacao AS INTEGER     NO-UNDO.


    FOR FIRST tt-movto
        WHERE tt-movto.tipo-trans = 2 /* Saida */
        AND   tt-movto.esp-docto  = 33 /* TRA */    
        AND   tt-movto.cod-depos  = "REC":

        FOR FIRST b-tt-movto
            WHERE b-tt-movto.tipo-trans = 1    /* Entrada */
            AND   b-tt-movto.esp-docto  = 33:   /* TRA */

            FOR FIRST it-critico-cq EXCLUSIVE-LOCK USE-INDEX it-sit-dt
                WHERE it-critico-cq.cod-estabel = tt-movto.cod-estabel
                AND   it-critico-cq.it-codigo   = tt-movto.it-codigo
                AND   it-critico-cq.situacao    = 0  /* Aberto */:

                IF b-tt-movto.cod-depos = "DEV" THEN
                    ASSIGN i-situacao = 2. /* Bloqueado */
                ELSE
                    ASSIGN i-situacao = 1. /* Liberado */

                ASSIGN it-critico-cq.situacao = i-situacao
                       it-critico-cq.dt-atend = NOW.

                RUN pi-envia-aviso-cq (INPUT it-critico-cq.email,
                                       INPUT i-situacao).

            END.

            RELEASE it-critico-cq.

        END.

    END.

END PROCEDURE.


PROCEDURE pi-envia-aviso-cq:

    DEFINE INPUT PARAMETER p-email      AS CHAR     NO-UNDO.
    DEFINE INPUT PARAMETER p-lib-bloq   AS INT      NO-UNDO.


    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = it-critico-cq.it-codigo:
    END.

    FOR FIRST param-global NO-LOCK:
    END.

    run utp/utapi019.p persistent set h-utapi019.
    create tt-envio2.
    assign tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail
           tt-envio2.porta             = param-global.porta-mail
           tt-envio2.destino           = p-email
           tt-envio2.remetente         = "ems@intelbras.com.br"
           tt-envio2.assunto           = "Liberaá∆o de Item Cr°tico" 
           tt-envio2.mensagem          = IF p-lib-bloq = 1 THEN "Material Liberado" ELSE "Material Bloqueado".
                                                                                                    
    ASSIGN tt-envio2.mensagem          = tt-envio2.mensagem + CHR(10) + CHR(10) + CHR(10) + 
                                         "Estabelecimento: " + it-critico-cq.cod-estabel + CHR(10) +
                                         "Solicitaá∆o: " + string(it-critico-cq.cod-solic) + CHR(10) +
                                         "Item: " + it-critico-cq.it-codigo + " - " + ITEM.desc-item + CHR(10) + 
                                         "Data Solicitaá∆o: " + string(it-critico-cq.dt-solic, "99/99/9999 HH:MM:SS") + CHR(10).

    ASSIGN tt-envio2.mensagem          = tt-envio2.mensagem + IF p-lib-bloq = 1 THEN "Data Liberaá∆o: " ELSE "Data Bloqueio: ".
                                                                                                                              
    ASSIGN tt-envio2.mensagem          = tt-envio2.mensagem + STRING(it-critico-cq.dt-atend, "99/99/9999 HH:MM:SS").
       
    output to value(session:temp-directory + "envemail.txt").       
    run pi-execute in h-utapi019 (input  table tt-envio2, output table tt-erros).
    output close.
    delete procedure h-utapi019.

    if available tt-envio2 then
        delete tt-envio2.    


    RETURN "OK":U.

END PROCEDURE.
