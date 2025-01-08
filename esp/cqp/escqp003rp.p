/***********************************************************************
**  Programa..: ESP\CPP\ESCQP003RP.P
**  Autor.....: Giovane Oliveira
**  Data......: OUTUBRO/2005 - Desenvolvimento
**  Descricao.: Relat¢rio de Sequˆncias de AE
**  VersÆo....: 001 06/10/2005
**                  Desenvolvimento Programa
************************************************************************/
{include/i-prgvrs.i ESCQP003 2.04.00.002}
/****************************  Definitions  ****************************/
{esp/cqp/escqp003tt.i}
{include/i-rpvar.i}
{utp/utapi019.i}
{esp/es0018.i}

/****************************  Temp-Tables  ****************************/
/****************************  Vari veis    ****************************/
DEF VAR h-boin367 AS HANDLE NO-UNDO.
def var i-estoque       as dec.
def var i-est-seg       as dec.
def var i-imp           as int format "99".
def var c-fab-inf       as char format "x(15)".
def var c-acond         as char format "x(50)".
def var c-embarque      as char format "x(79)".
def var c-embarque2     as char format "x(79)".
def var c-embarque3     as char format "x(79)".
def var r-registro       as   recid no-undo.
def var l-resposta       as   log format "Sim/Nao".
def var l-alterou        as   log.
def var l-loop           as   log.
def var c-opcao          as   character .
def var c-comando        as   char extent 3
    init ["Arquivo","Impressao","Fim"].
def var c-transportadora like emitente.nome-abrev.
def var c-comprador      like item.cod-comprado.
def var l-conf           as   log initial yes.
def var c-localizacao1   as   char format "x(75)" extent 5.
def var i-pula           as   int.
def var c-situacao       as   char format "x(50)".
def var i-cont           as   int.
def var i-sequencia      as   int.
def var i-qtd-lote       as   int.
def var i-qtd-resto      as   int.
def var i-ultimo-ae      as   int.
def var i-emitente       as   int.
def var c-emitente       as   char format "x(30)".
def var i-estrado        as   char format "x(15)".
def var i-nota           like docum-est.nro-docto.
def var i-quantidade     as   int.
def var i-quantidade-rot as   int.  
def var i-qtde-rot-tot   as   int.
def var l-inspeciona     as   logical.
def var i-etiquetas      as   int format ">>9".
def var i-lote-multiplo  like item.lote-multipl.
def var c-ind            as   char format "X(20)".
def var c-capacidade     as   char format "x(60)".
def var c-item           like item.it-codigo.
def var c-item-a         like item-fabric.it-fabric.
def var c-fabric         like fabricante.nome-abrev.

def var i-fl-nivel       like item.nivel.
def var i-fl-nqa         like item.perc-nqa.
def var i-fl-tipo        like item-fornec-estab.tp-insp.
def var i-fl-lote        like nivel-insp.tam-lote.
def var i-fl-cod-amostra like nivel-insp.cod-amostra.
def var i-fl-tam-amostra like amostra.tam-amostra.
def var i-fl-aceita      like nqa-simp.nr-aceita.
def var i-fl-rejeita     like nqa-simp.nr-rejeita.
DEF VAR c-lancamento     AS CHAR FORMAT "X(50)".

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usuÿrio Corrente"
    column-label "Usuÿrio Corrente"
    no-undo.

DEFINE VARIABLE de-perc-nqa AS DECIMAL     NO-UNDO.

DEFINE VARIABLE c-depos-entrada AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-tipo-pedido AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-estabelecimento LIKE ae-inspecao.cod-estabel NO-UNDO.

/********** DEFINICAO DE STREAMS     ****************************************/
/********** DEFINICAO DE TEMP-TABLES ****************************************/

DEFINE TEMP-TABLE tt-email-para-manaus NO-UNDO
    FIELD serie-docto  LIKE item-doc-est.serie-docto
    FIELD nro-docto    LIKE item-doc-est.nro-docto
    FIELD cod-emitente LIKE item-doc-est.cod-emitente
    FIELD nat-operacao LIKE item-doc-est.nat-operacao
    FIELD num-pedido   LIKE pedido-compr.num-pedido
    FIELD numero-ordem LIKE item-doc-est.numero-ordem
    FIELD it-codigo    LIKE item-doc-est.it-codigo
    FIELD quantidade   LIKE item-doc-est.quantidade
    INDEX ch-primario IS PRIMARY UNIQUE
        serie-docto
        nro-docto
        cod-emitente
        nat-operacao
        num-pedido
        numero-ordem
        it-codigo.

/********** DEFINICAO DE BUFFERS     ****************************************/

def buffer b-rat-lote      for rat-lote.
def buffer b-ficha-cq      for ficha-cq.
def buffer b-ae-inspecao   for ae-inspecao.
def buffer bm-ordem-compra for ordem-compra.

/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

def var h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

FOR FIRST usuar_mestre NO-LOCK
    WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren:
END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Ficha de Inspe‡Æo"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESCQP003"
       c-versao       = "2.04"
       c-revisao      = "002"
       c-lancamento   = usuar_mestre.cod_usuario + " - " + usuar_mestre.nom_usuario.

form header
     "Intelbras S/A                Ficha de Inspe‡Æo"
     "Pag: " at 70
    page-number format ">>9"
     skip
     today    format "99/99/99" at 1 " - " string(time,"hh:mm:ss") c-ind at 30 
"------------------------------------------------------------------------------"
     "Fornecedor     : " 
     i-emitente
     c-emitente         skip
     "Estabelecimento: "
     c-estabelecimento  skip
     "Nota           : "
     i-nota             skip    
     "Serie          : " 
     tt-param.serie-docto     skip
     "Natureza       : "
     tt-param.nat-operacao   
     "    - "
     c-embarque
     skip
     c-embarque2 SKIP
     c-embarque3 SKIP
     "Volumes        : "
     tt-param.volume          skip
     "Comprador      : "
     c-comprador              SKIP
     "Lan‡amento     : "   
     c-lancamento
     skip
     "    ImpressÆo:" i-imp skip
     "  Localiza‡Æo:" skip
     "1- " tt-param.localizacao1 skip
     "2- " tt-param.localizacao2 skip
     "3- " tt-param.localizacao3 skip
     "4- " tt-param.localizacao4 skip
     "5- " tt-param.localizacao5 skip

     with page-top frame f-cabecalho width 81 STREAM-IO no-labels no-box.


form HEADER
      "
______________________________________________________________________________"
     skip 
     "Item                                         Num.AE   " skip
     "        Roteiro    Quantidade" skip
      "
______________________________________________________________________________"

     with  page-top frame f-cabecalho1 width 81 STREAM-IO no-labels no-box.

form HEADER
     "###############################################################" skip
     "####                                                          #"
     "####       U R G E N T E - U R G E N T E - U R G E N T E      #"
     "####                                                          #"
     "###############################################################"
     with page-top frame f-urgente STREAM-IO no-labels no-box.

form header
    skip(3)
    "_______________________" at 50 skip
    "Inspetor" at 57
    skip(2)
    with page-bottom FRAME f-rodape-2 STREAM-IO no-labels no-box.

form 
   "Situa‡Æo de Inspe‡Æo:" c-situacao skip
   "Item Fabricantes:"    

"______________________________________________________________________________
"
   with frame f-obs STREAM-IO no-labels no-box.


/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    /*{include/i-rpcab.i}*/
    {include/i-rpout.i}

    view frame f-cabecalho.
    if tt-param.urgencia then view frame f-urgente.
    view frame f-cabecalho1.
    view frame f-rodape-2.

    /*
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    */

   run utp/ut-acomp.p persistent set h-acomp.  

   run pi-inicializar in h-acomp (input "Imprimindo...").
   
   run piImprimeRelat.

   IF tt-param.imprime-param THEN DO:
       HIDE FRAME f-cabecalho.
       HIDE FRAME f-urgente.
       HIDE FRAME f-cabecalho1.
       HIDE FRAME f-rodape-2.
       PAGE.

       PUT skip(1)
           "PAR¶METROS"         
           skip(1)
           "Emitente: " TO 40 tt-param.cod-emitente FORMAT ">>>>>>>>9" SKIP
           "S‚rie: "    TO 40 tt-param.serie-docto FORMAT "x(5)" SKIP
           "Documento: " TO 40 tt-param.nro-docto FORMAT "x(16)" SKIP
           "Nat Opera‡Æo: " TO 40 tt-param.nat-operacao FORMAT "x(06)" SKIP
           "Urgˆncia: " TO 40 tt-param.urgencia FORMAT "Urgente/Normal".

        PUT skip(1)
           "IMPRESSÇO"
           skip(1)
           "Destino: "           TO 40 
           tt-param.arquivo    
           "Usu rio: " TO 40 tt-param.usuario     
           skip(1).
   END.
   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.




/*****************************************************************************************
**
** PROCEDURES INTERNAS
**
*****************************************************************************************/
PROCEDURE piImprimeRelat:
    EMPTY TEMP-TABLE tt-email-para-manaus.

    assign c-ind = "".
  
    run compacta-ficha.

    if substr(tt-param.nat-operacao,2,2) = "13" then do:
        RUN imprime-industrializacao.
        next.
    end.
    
    for each item-doc-est
        where item-doc-est.cod-emitente = tt-param.cod-emitente  and
              item-doc-est.serie-docto  = tt-param.serie-docto   and
              item-doc-est.nro-docto    = tt-param.nro-docto     and
              item-doc-est.nat-operacao = tt-param.nat-operacao exclusive-lock:

        if item-doc-est.num-pedido = 0 then 
            assign c-comprador = "Sem Pedido".
        else do:
            find pedido-compr 
                where pedido-compr.num-pedido = item-doc-est.num-pedido no-lock no-error.
            if avail pedido-compr then
                assign c-comprador = pedido-compr.responsavel.
            else 
                assign c-comprador = "NÆo Definido".
               
            find first despesa-aces
                where despesa-aces.cod-emitente =  item-doc-est.cod-emitente
                and despesa-aces.serie-docto  =  item-doc-est.serie-docto 
                and despesa-aces.nro-docto    =  item-doc-est.nro-docto
                and despesa-aces.nat-operacao =  item-doc-est.nat-operacao no-lock no-error.
            if avail despesa-aces then do:
                find emitente where emitente.cod-emitente = despesa-aces.cod-forn-ac no-lock no-error.
                assign c-transportadora = emitente.nome-abrev.
            end.
            else assign c-transportadora = "Indefinida".      
        end.
        
        find first rat-lote 
            where rat-lote.cod-emitente = item-doc-est.cod-emitente
            and rat-lote.nro-docto    = item-doc-est.nro-docto
            and rat-lote.serie-docto  = item-doc-est.serie-docto
            and rat-lote.nat-operacao = item-doc-est.nat-operacao
            and rat-lote.sequencia    = item-doc-est.sequencia no-lock no-error.
        if avail rat-lote then 
            assign item-doc-est.nr-ficha = rat-lote.nr-ficha.
    end.
    


    find docum-est
        where docum-est.cod-emitente = tt-param.cod-emitente  and
              docum-est.serie-docto  = tt-param.serie-docto   and
              docum-est.nro-docto    = tt-param.nro-docto     and
              docum-est.nat-operacao = tt-param.nat-operacao  no-lock no-error.
    IF AVAILABLE docum-est THEN DO:
        IF docum-est.nat-operacao BEGINS "3" THEN DO:
            FIND FIRST embarque-imp
                WHERE embarque-imp.cod-estabel = docum-est.cod-estabel 
                AND   embarque-imp.embarque    = TRIM(SUBSTRING(docum-est.char-1,1,20)) NO-LOCK NO-ERROR.

            ASSIGN c-embarque = docum-est.observacao + IF AVAIL embarque-imp THEN (" - " + TRIM(embarque-imp.cod-conhecto-maste)) ELSE "".

            IF LENGTH(c-embarque) > 158 THEN
                ASSIGN c-embarque3 = SUBSTRING(c-embarque,159).
            IF LENGTH(c-embarque) > 79 THEN
                ASSIGN c-embarque2 = SUBSTRING(c-embarque,80,158)
                       c-embarque  = SUBSTRING(c-embarque,1,79).
        END.    

    
        for each item-doc-est of docum-est no-lock
            WHERE item-doc-est.nr-ficha <> 0
            break by item-doc-est.it-codigo:

            find item where item.it-codigo = item-doc-est.it-codigo no-lock no-error.

            find first item-uni-estab 
                 where item-uni-estab.cod-estabel = docum-est.cod-estabel
                   AND item-uni-estab.it-codigo   = item-doc-est.it-codigo no-lock no-error.
        
            find pedido-compr where
                 pedido-compr.num-pedido = item-doc-est.num-pedido no-lock no-error.

            if not avail pedido-compr then 
                find item-fornec-estab
                where item-fornec-estab.cod-estabel  = docum-est.cod-estabel
                  AND item-fornec-estab.it-codigo    = item-doc-est.it-codigo
                  and item-fornec-estab.cod-emitente = item-doc-est.cod-emitente no-lock no-error.
            else        
                find item-fornec-estab 
                    where item-fornec-estab.cod-estabel  = docum-est.cod-estabel
                      AND item-fornec-estab.it-codigo = item-doc-est.it-codigo
                      AND item-fornec-estab.cod-emitente = pedido-compr.cod-emitente no-lock no-error.
           
            if avail item-fornec-estab then  do:
                assign i-lote-multiplo = item-fornec-estab.lote-mul-for.
            end.
            else do:
                assign c-situacao      = "ITEM NAO RELACIONADO AO FORNECEDOR"              
                       i-lote-multiplo = IF AVAIL item-uni-estab THEN item-uni-estab.lote-multipl ELSE item.lote-multipl.
            end.
            
            /* inicio da geracao de ae-inspecao */

            FOR EACH ficha-cq NO-LOCK
                where ficha-cq.serie-docto  = docum-est.serie-docto
                AND   ficha-cq.nro-docto    = docum-est.nro-docto
                and   ficha-cq.cod-emitente = docum-est.cod-emitente
                and   ficha-cq.nat-operacao = item-doc-est.nat-operacao
                /*and ficha-cq.it-codigo    = item-doc-est.it-codigo
                and ficha-cq.sequencia    = item-doc-est.sequencia*/ :  

                IF ficha-cq.cod-estabel <> docum-est.cod-estabel OR
                   ficha-cq.it-codigo   <> item-doc-est.it-codigo THEN
                    NEXT.

                find first ae-inspecao exclusive-lock 
                    where ae-inspecao.cod-estabel  = docum-est.cod-estabel
                    and ae-inspecao.nro-docto    = int(docum-est.nro-docto)
                    and ae-inspecao.cod-emitente = docum-est.cod-emitente
                    and ae-inspecao.serie        = docum-est.serie-docto
                    and ae-inspecao.it-codigo    = item-doc-est.it-codigo
                    and ae-inspecao.sequencia    = item-doc-est.sequencia 
                    AND ae-inspecao.nr-ficha     = ficha-cq.nr-ficha no-error.

                if not avail ae-inspecao then do:    
                    if avail item then do:          
                        run busca-capacidade.
                   
                        if (AVAIL item-uni-estab AND item-uni-estab.contr-qualid) OR 
                           (NOT AVAIL item-uni-estab AND item.contr-qualid) then do:
         
                            assign i-qtd-lote = trunc((item-doc-est.quantidade 
                                   / i-lote-multiplo),0)
                                   i-qtd-resto = ((item-doc-est.quantidade 
                                   / i-lote-multiplo) -
                                   i-qtd-lote) * i-lote-multiplo.
                        
                            if first-of(item-doc-est.it-codigo) then do:
                                find first aviso-entrada where aviso-entrada.cod-estabel = docum-est.cod-estabel exclusive-lock no-error.
                                if avail aviso-entrada then
                                    assign i-ultimo-ae = aviso-entrada.ultimo-ae + 1
                                           aviso-entrada.ultimo-ae = i-ultimo-ae
                                           i-sequencia = i-qtd-lote + i-qtd-resto.
                                ELSE DO:
                                    CREATE aviso-entrada.
                                    ASSIGN aviso-entrada.cod-estabel = docum-est.cod-estabel
                                           aviso-entrada.ultimo-ae   = 1.
                                END.
                                find current aviso-entrada no-lock no-error.
                            end.
    
                            create ae-inspecao.
                            assign  ae-inspecao.cod-estabel  = docum-est.cod-estabel
                                    ae-inspecao.nro-docto    = int(item-doc-est.nro-docto)
                                    ae-inspecao.cod-emitente = item-doc-est.cod-emitente
                                    ae-inspecao.it-codigo    = item-doc-est.it-codigo
                                    ae-inspecao.nat-operacao = item-doc-est.nat-operacao
                                    ae-inspecao.serie        = item-doc-est.serie-docto                                             
                                    ae-inspecao.nr-ae      = i-ultimo-ae 
                                    ae-inspecao.sequencia  = item-doc-est.sequencia
                                    ae-inspecao.quantidade = item-doc-est.quantidade
                                    ae-inspecao.nr-ficha   = ficha-cq.nr-ficha.
                            
    
                        end.
                    end.  
                end. 

                IF NOT CAN-FIND (FIRST b-ficha-cq
                                 WHERE b-ficha-cq.serie-docto  = ficha-cq.serie-docto
                                 AND   b-ficha-cq.nro-docto    = ficha-cq.nro-docto
                                 AND   b-ficha-cq.cod-emitente = ficha-cq.cod-emitente
                                 AND   b-ficha-cq.nat-operacao = ficha-cq.nat-operacao
                                 AND   b-ficha-cq.cod-estabel  = ficha-cq.cod-estabel
                                 AND   b-ficha-cq.it-codigo    = ficha-cq.it-codigo
                                 AND   ROWID(b-ficha-cq) <> ROWID(ficha-cq)) THEN DO:

                    ASSIGN ae-inspecao.quantidade = item-doc-est.quantidade.

                END.

            END.
           
            find first ae-entrada where 
                ae-entrada.cod-estabel = docum-est.cod-estabel and
                ae-entrada.nro-docto = int(item-doc-est.nro-docto) and
                ae-entrada.cod-emitente = item-doc-est.cod-emitente no-lock no-error.  
            if avail ae-entrada AND AVAIL ae-inspecao then do:
                do i-cont = 1 to 5:
                    assign ae-inspecao.localizacao[i-cont] =
                           ae-entrada.localizacao[i-cont].
                end.
                do i-cont = 1 to 5: 
                    if ae-entrada.estrado[i-cont] <> "" then
                        assign ae-inspecao.estrado[i-cont] = 
                               ae-entrada.estrado[i-cont].
                end.
                find current ae-inspecao no-lock.
            end.
        end. /* for each item-doc-est */

        run imprime-ae.

    end. /* avail docum-est */
    
    RUN pi-envia-email-manaus.

END.


PROCEDURE compacta-ficha:

    for each rat-lote no-lock
        where rat-lote.nro-docto = tt-param.nro-docto
          and rat-lote.cod-emitente = tt-param.cod-emitente
          and rat-lote.serie = tt-param.serie-docto
          and rat-lote.nat-operacao = tt-param.nat-operacao
        break by rat-lote.it-codigo:
        
        if first-of(rat-lote.it-codigo) then do:
            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = rat-lote.it-codigo NO-ERROR.
            IF ITEM.tipo-con-est = 3 THEN NEXT. /* item controlado por lote*/
         
            find ficha-cq where ficha-cq.nr-ficha = rat-lote.nr-ficha exclusive-lock no-error.
            
            if not avail ficha-cq then next.
            
            for each b-rat-lote exclusive-lock
                where b-rat-lote.nro-docto = rat-lote.nro-docto
                and b-rat-lote.serie-docto = rat-lote.serie-docto
                and b-rat-lote.cod-emitente = rat-lote.cod-emitente
                and b-rat-lote.nat-operacao = rat-lote.nat-operacao
                and b-rat-lote.it-codigo = rat-lote.it-codigo
                and b-rat-lote.sequencia <> rat-lote.sequencia:
                
                find b-ficha-cq where b-ficha-cq.nr-ficha = b-rat-lote.nr-ficha exclusive-lock no-error.
                 
                if not avail b-ficha-cq then next.
                 
                if b-ficha-cq.nr-ficha = ficha-cq.nr-ficha then next.
                 
                assign ficha-cq.qt-original = ficha-cq.qt-original +
                                             b-ficha-cq.qt-original
                       ficha-cq.qt-aprovada = ficha-cq.qt-aprovada +
                                             b-ficha-cq.qt-aprovada
                       ficha-cq.qt-rejeitada = ficha-cq.qt-rejeitada +
                                              b-ficha-cq.qt-rejeitada
                       ficha-cq.qt-apr-cond = ficha-cq.qt-apr-cond +
                                             b-ficha-cq.qt-apr-cond
                       ficha-cq.qt-a-liberar = ficha-cq.qt-a-liberar +
                                              b-ficha-cq.qt-a-liberar.
                                              
                delete b-ficha-cq.             
                assign b-rat-lote.nr-ficha = rat-lote.nr-ficha.
                
            end.
        end.
    end.
end.


procedure compacta-ind.


   for each ae-inspecao no-lock
        where   ae-inspecao.cod-estabel = tt-param.cod-estabel 
          and   ae-inspecao.nro-docto = int(tt-param.nro-docto)
          and   ae-inspecao.cod-emitente = tt-param.cod-emitente
          and   ae-inspecao.serie = tt-param.serie-docto
          and   ae-inspecao.nat-operacao = tt-param.nat-operacao
        break by ae-inspecao.it-codigo:
        if first-of(ae-inspecao.it-codigo) then do:

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = ae-inspecao.it-codigo NO-ERROR.
        IF ITEM.tipo-con-est = 3 THEN NEXT. /* item controlado por lote*/
        
        find ficha-cq where ficha-cq.nr-ficha = ae-inspecao.nr-ficha exclusive-lock no-error.

        if not avail ficha-cq then next.
        
        for each b-ae-inspecao exclusive-lock
           where b-ae-inspecao.cod-estabel = tt-param.cod-estabel
             and b-ae-inspecao.nro-docto = int(tt-param.nro-docto)
             and b-ae-inspecao.serie = tt-param.serie-docto
             and b-ae-inspecao.cod-emitente = tt-param.cod-emitente
             and b-ae-inspecao.nat-operacao = tt-param.nat-operacao
             and b-ae-inspecao.it-codigo = ae-inspecao.it-codigo
             and b-ae-inspecao.sequencia <> ae-inspecao.sequencia:
             find b-ficha-cq where b-ficha-cq.nr-ficha = b-ae-inspecao.nr-ficha
             exclusive-lock no-error.
             
             if not avail b-ficha-cq then next.
             
             
             if b-ficha-cq.nr-ficha = ficha-cq.nr-ficha then next.
         
             
             assign ficha-cq.qt-original = ficha-cq.qt-original +
                                         b-ficha-cq.qt-original
                    ficha-cq.qt-aprovada = ficha-cq.qt-aprovada +
                                         b-ficha-cq.qt-aprovada
                    ficha-cq.qt-rejeitada = ficha-cq.qt-rejeitada +
                                          b-ficha-cq.qt-rejeitada
                    ficha-cq.qt-apr-cond = ficha-cq.qt-apr-cond +
                                         b-ficha-cq.qt-apr-cond
                    ficha-cq.qt-a-liberar = ficha-cq.qt-a-liberar +
                                          b-ficha-cq.qt-a-liberar.
             
             
             delete b-ficha-cq.             
             assign b-ae-inspecao.nr-ficha = ae-inspecao.nr-ficha.
/*              find current ficha-cq no-lock. */
/*              release b-ae-inspecao. */
             
        end.
         
        
        
        
        end.
  


   end.

  
end.

procedure busca-capacidade.

    assign c-capacidade = "".
    for each item-tipo-loc no-lock
       where item-tipo-loc.it-codigo = item.it-codigo
         and item-tipo-loc.cod-estabel = tt-param.cod-estabel
         and item-tipo-loc.cod-depos = "alm" :
        assign c-capacidade = c-capacidade + 
               string(item-tipo-loc.cod-tipo,">>9") + " - " + string(item-tipo-loc.quantidade,">,>>>,>>9") + " ".
    end.
end.

procedure qual-assegurada.
    DEFINE VARIABLE i-criticidade AS INTEGER     NO-UNDO.

    find first param-cq no-lock.

    ASSIGN i-criticidade = IF AVAIL item-uni-estab THEN item-uni-estab.criticidade ELSE item.criticidade.
    
    assign i-pula = 0.
    case i-criticidade:
      /*  when "x" then do:
       */ when 1 then do:

                do i-cont = 30 to (31 - (ins-pref-x[1] + ins-pref-x[2] - 1) ) 
                            by -1:
                  if item-fornec-estab.aval-insp[i-cont] = 4 then
                         assign i-pula = i-pula + 1.
                
                end.

                if i-pula >= ins-pref-x[2] then assign l-inspeciona = yes.
                else assign l-inspeciona = no.


            end.
/*        when "y" then do: */
          when 2 then do:

                do i-cont = 30 to (31 - (ins-pref-y[1] + ins-pref-y[2] - 1) ) by -1:
                    if item-fornec-estab.aval-insp[i-cont] = 4 then
                         assign i-pula = i-pula + 1.
                
                end.

                
                if i-pula >= ins-pref-y[2] then assign l-inspeciona = yes.
                else assign l-inspeciona = no.
        
            end.
/*        when "z" then do: */
                when 3 then do:

  do i-cont = 30 to (31 - (ins-pref-z[1] + ins-pref-z[2] - 1) ) by -1:
                  if item-fornec-estab.aval-insp[i-cont] = 4 then
                         assign i-pula = i-pula + 1.
                
                end.

                if i-pula >= ins-pref-z[2] then assign l-inspeciona = yes.
                else assign l-inspeciona = no.

            end.
     end.
     if l-inspeciona then         
        assign c-situacao = c-situacao + " - ESTE LOTE DEVE SER INSPECIONADO".
     else do:
        assign c-situacao = c-situacao + " - NAO INSPECIONAR" .
/*         find current ficha-cq exclusive-lock. */
     /*   assign ficha-cq.u-dec-1 = 1.
       */ find current ficha-cq no-lock.

     end.

        

end.


procedure ctr.
      /* Comentado por Emerson. Substituido por forech abaixo
      
      for each it-res-carac no-lock
         where it-res-carac.it-codigo = item.it-codigo:
         if it-res-carac.tipo-result = 2 then do:
            find c-tab-res 
               where c-tab-res.nr-tabela = it-res-carac.nr-tabela
                 and c-tab-res.sequencia = it-res-carac.sequencia
                   no-lock no-error.
            if avail c-tab-res then do:
               if it-res-carac.nr-tabela = 1 then do:
                  assign c-fab-inf = c-tab-res.descricao.
               end.
               else do:
                  if it-res-carac.nr-tabela = 4 then do:
                     assign c-acond   = c-tab-res.descricao.
                  end. 
               end.
            end.
         end.
      end.
      */
    for each it-res-carac no-lock
        where it-res-carac.it-codigo = item.it-codigo:
        
        if it-res-carac.nr-tabela <> 0 then do:
            FIND c-tab-res 
                where c-tab-res.nr-tabela = it-res-carac.nr-tabela
                  and c-tab-res.sequencia = it-res-carac.sequencia
                    no-lock no-error.
            if avail c-tab-res then do:
                CASE it-res-carac.nr-tabela:
                    WHEN 1 THEN ASSIGN c-fab-inf    = c-tab-res.descricao.
                    WHEN 4 THEN ASSIGN c-acond      = c-tab-res.descricao.
                END CASE.
            end.
         end.
    end.

    FIND FIRST familia
        WHERE familia.fm-codigo = ITEM.fm-codigo NO-LOCK NO-ERROR.
    IF AVAIL familia THEN
        FIND FIRST int-familia OF familia NO-LOCK NO-ERROR.
    IF AVAIL int-familia THEN
        ASSIGN c-fab-inf  = STRING(int-familia.meses-validade) + " Meses".
end.

procedure desenho-ctr.
      for each desenho-item 
         where desenho-item.it-codigo = item.it-codigo
            no-lock break by desenho-item.it-codigo:

         put if first-of(desenho-item.it-codigo) 
                          then "Desenhos:" else "" format "x(10)"
                desenho-item.de-codigo  format "x(13)".
         find last revisao
            where revisao.de-codigo = desenho-item.de-codigo
            no-lock no-error.
         if avail revisao  then
            put " " revisao.rv-codigo   format "xx"
                " " substring(string(year(revisao.data-revisao),"9999"),3,2)
                format "99" skip.
      end.
end.

procedure imprime-ae:

    DEFINE VARIABLE c-linha AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-aux AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-quebra AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-linhas AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-pedaco AS INTEGER     NO-UNDO.


/*        

    view frame f-cabecalho.
    if tt-param.urgencia then view frame f-urgente.
    view frame f-cabecalho1.
    view frame f-rodape-2.
*/         
    assign i-quantidade = 0
           i-quantidade-rot = 0
           i-qtde-rot-tot = 0
           i-etiquetas = 0.
        
    for each ae-inspecao no-lock
       where ae-inspecao.cod-estabel = tt-param.cod-estabel
         and ae-inspecao.nro-docto = int(tt-param.nro-docto)
         and ae-inspecao.cod-emitente = tt-param.cod-emitente
         and ae-inspecao.serie = tt-param.serie-docto
         and ae-inspecao.nat-operacao = tt-param.nat-operacao
       break by ae-inspecao.cod-emitente
             by ae-inspecao.nro-docto
             by ae-inspecao.nat-operacao
             by ae-inspecao.it-codigo:
       
       find emitente  no-lock
            where emitente.cod-emit = ae-inspecao.cod-emitente.
       
       find first item-uni-estab 
            where item-uni-estab.cod-estabel = ae-inspecao.cod-estabel
              AND item-uni-estab.it-codigo   = ae-inspecao.it-codigo no-lock no-error.

       find item no-lock
            where item.it-codigo = ae-inspecao.it-codigo.
       
       run busca-capacidade.
       assign tt-param.serie-docto     = ae-inspecao.serie
              tt-param.nat-operacao    = ae-inspecao.nat-operacao
              i-emitente        = ae-inspecao.cod-emitente
              c-emitente        = emitente.nome-emit 
              c-estabelecimento = ae-inspecao.cod-estabel
              i-imp             = int(ae-inspecao.ae-imp) + 1
              i-estrado         = ae-inspecao.estrado[1] + "-" +
                                  ae-inspecao.estrado[2] + "-" +
                                  ae-inspecao.estrado[3] + "-" +
                                  ae-inspecao.estrado[4] + "-" +
                                  ae-inspecao.estrado[5]
              c-localizacao1[1] = "1-" + ae-inspecao.localizacao[1]
              c-localizacao1[2] = "2-" + ae-inspecao.localizacao[2]
              c-localizacao1[3] = "3-" + ae-inspecao.localizacao[3]
              c-localizacao1[4] = "4-" + ae-inspecao.localizacao[4]
              c-localizacao1[5] = "5-" + ae-inspecao.localizacao[5]
              i-nota            = string(ae-inspecao.nro-docto,"9999999")
              i-quantidade-rot  = i-quantidade-rot + ae-inspecao.quantidade
              i-qtde-rot-tot    = i-qtde-rot-tot + ae-inspecao.quantidade.

       if first-of(ae-inspecao.it-codigo) then do:
       
           /*
           view frame f-cabecalho.
           if tt-param.urgencia then view frame f-urgente.
           view frame f-cabecalho1.
           */
           assign i-est-seg = IF AVAIL item-uni-estab THEN item-uni-estab.quant-segur ELSE item.quant-segur
                  i-estoque = 0.
           for each saldo-estoq no-lock
              where saldo-estoq.cod-estabel = ae-inspecao.cod-estabel
                and saldo-estoq.it-codigo = ae-inspecao.it-codigo
                and saldo-estoq.cod-depos = "alm":
                assign i-estoque = i-estoque + saldo-estoq.qtidade-atu.
           end.
           
           put ae-inspecao.it-codigo format "x(8)" at 01
               item.descricao-1
               item.descricao-2  
               " "
               ae-inspecao.nr-ae       . 
           if i-estoque <= i-est-seg then 
              put " *ATENCAO: Saldo < Est Seg" SKIP.

           find homologacao no-lock
               where homologacao.it-codigo = item.it-codigo
                 and homologacao.cod-emitente = emitente.cod-emitente no-error.
           
           if avail homologacao and homologacao.situacao <> 99 
               AND homologacao.situacao <> 7 
               AND homologacao.situacao <> 8 then 
              put skip "**** ITEM EM HOMOLOGACAO. PROCESSO: "                 
                       homologacao.nr-processo                 skip.
       end.

       ASSIGN c-depos-entrada = ""
              c-tipo-pedido   = "".

       find item-doc-est 
            where item-doc-est.it-codigo = ae-inspecao.it-codigo
              AND item-doc-est.sequencia = ae-inspecao.sequencia
              and item-doc-est.nro-docto = string(ae-inspecao.nro-docto,"9999999")
              and item-doc-est.serie-docto = ae-inspecao.serie
              and item-doc-est.nat-operacao = ae-inspecao.nat-operacao
              and item-doc-est.cod-emitente = ae-inspecao.cod-emitente NO-LOCK NO-ERROR.

       IF AVAIL item-doc-est THEN DO:

           IF item-doc-est.log-1 = NO AND /* nao ‚ fifo */
              item-doc-est.numero-ordem > 0 THEN DO:
               FIND pedido-compr WHERE pedido-compr.num-pedido = item-doc-est.num-pedido NO-LOCK NO-ERROR.

               FIND ordem-compra WHERE
                    ordem-compra.numero-ordem = item-doc-est.numero-ordem NO-LOCK NO-ERROR.
               IF AVAIL ordem-compra THEN
                   ASSIGN c-depos-entrada = ordem-compra.dep-almoxar.
           END.
           ELSE DO:

               FOR FIRST rat-ordem 
                   WHERE rat-ordem.nro-docto    = item-doc-est.nro-docto 
                     AND rat-ordem.serie-docto  = item-doc-est.serie-docto 
                     AND rat-ordem.nat-operacao = item-doc-est.nat-operacao 
                     AND rat-ordem.cod-emitente = item-doc-est.cod-emitente 
                     AND rat-ordem.sequencia    = item-doc-est.sequencia NO-LOCK:

                   FOR FIRST pedido-compr 
                       WHERE pedido-compr.num-pedido = rat-ordem.num-pedido NO-LOCK:
                   END.

                   FIND FIRST ordem-compra WHERE
                        ordem-compra.numero-ordem = rat-ordem.numero-ordem NO-LOCK NO-ERROR.

                   IF AVAIL ordem-compra THEN
                       ASSIGN c-depos-entrada = ordem-compra.dep-almoxar.
               END.
           END.
       END.

/*        IF c-depos-entrada = "HML" THEN DO:                  */
/*            PUT SKIP "*** MATERIAL EM HOMOLOGA€¶O ***" SKIP. */
/*        END.                                                 */

       /* Busca o Tipo de Pedido */
       IF AVAILABLE pedido-compr THEN DO:
           FOR FIRST int-pedido-compr WHERE                                        
                    int-pedido-compr.num-pedido = pedido-compr.num-pedido NO-LOCK:
    
                CASE int-pedido-compr.tp-pedido:
                    WHEN 1 THEN DO:
                        ASSIGN c-tipo-pedido = "*** PEDIDO " + TRIM(STRING(pedido-compr.num-pedido)) + " AMOSTRA ***".
                    END.
                    WHEN 4 THEN DO:
                        ASSIGN c-tipo-pedido = "*** PEDIDO " + TRIM(STRING(pedido-compr.num-pedido)) + " HOMOLOGA€ÇO ***".
                    END.
                    WHEN 5 THEN DO:
                        ASSIGN c-tipo-pedido = "*** PEDIDO " + TRIM(STRING(pedido-compr.num-pedido)) + " INDEPENDENTE ***".
                    END.
                    WHEN 6 THEN DO:
                        ASSIGN c-tipo-pedido = "*** PEDIDO " + TRIM(STRING(pedido-compr.num-pedido)) + " RESSARCIMENTO ***".
                    END.
                    WHEN 7 THEN DO:
                        ASSIGN c-tipo-pedido = "*** PEDIDO " + TRIM(STRING(pedido-compr.num-pedido)) + " SPOT ***".
                    END.
                    WHEN 9 THEN DO:
                        ASSIGN c-tipo-pedido = "*** PEDIDO " + TRIM(STRING(pedido-compr.num-pedido)) + " PARA MANAUS ***".
    
                        IF i-imp = 1 THEN
                            RUN pi-gera-email-manaus (INPUT item-doc-est.serie-docto,
                                                      INPUT item-doc-est.nro-docto,
                                                      INPUT item-doc-est.cod-emitente,
                                                      INPUT item-doc-est.nat-operacao,
                                                      INPUT pedido-compr.num-pedido,
                                                      INPUT item-doc-est.numero-ordem,
                                                      INPUT item-doc-est.sequencia,
                                                      INPUT item-doc-est.it-codigo,
                                                      INPUT item-doc-est.quantidade).
                    END.
                    WHEN 12 THEN DO:
                        ASSIGN c-tipo-pedido = "*** PEDIDO " + TRIM(STRING(pedido-compr.num-pedido)) + " PARA ENGESUL ***".
                    END.
                    WHEN 13 THEN DO:
                        ASSIGN c-tipo-pedido = "*** PEDIDO " + TRIM(STRING(pedido-compr.num-pedido)) + " PARA AUTOMATIZA ***".
                    END.
               END CASE.
           END.
       END.

/*        IF AVAIL pedido-compr AND pedido-compr.emergencial THEN */
/*            PUT SKIP "*** PEDIDO EMERGENCIAL ***" SKIP.         */

       put ae-inspecao.nr-ficha at 08
           ae-inspecao.quantidade format ">,>>>,>>9.99"   at 20
           c-tipo-pedido FORMAT "x(45)" AT 38.
              
       assign i-etiquetas = i-etiquetas + ae-inspecao.quantidade.
              
       if last-of(ae-inspecao.it-codigo)  then do:
           
           run pega-amostra. 
 
           if not avail pedido-compr then 
               find item-fornec-estab
                    where item-fornec-estab.cod-estabel = tt-param.cod-estabel
                      AND item-fornec-estab.it-codigo = ae-inspecao.it-codigo
                      and item-fornec-estab.cod-emitente = emitente.cod-emitente 
                          no-lock no-error.
           else
               find item-fornec-estab
                    where item-fornec-estab.cod-estabel = tt-param.cod-estabel
                      AND item-fornec-estab.it-codigo = ae-inspecao.it-codigo
                      and item-fornec-estab.cod-emitente = pedido-compr.cod-emitente 
                          no-lock no-error.
           
           if avail item-fornec-estab then do:
               find FIRST ficha-cq 
                    where ficha-cq.nr-ficha = ae-inspecao.nr-ficha 
                          NO-LOCK NO-ERROR.
               case item-fornec-estab.tp-inspecao:
                   when 1 then assign c-situacao = "Severa".
                   when 2 then assign c-situacao = "Normal".
                   when 3 then assign c-situacao = "Atenuada".
                   otherwise do:
                       assign c-situacao = "ASSEGURADA".
                       run qual-assegurada.
                   end.
               end.

               find int-item-fornec of item-fornec-estab no-lock no-error.
               if avail int-item-fornec then do:
                  
                   if int-item-fornec.obs-insp <> "" then 
                      put skip "OBS INSP.: " int-item-fornec.obs-insp .
                   if int-item-fornec.obs-rec <> "" then DO:

                       /*put UNFORMATTED skip "OBS REC.: " int-item-fornec.obs-rec .*/

                       DO i-aux = 1 TO NUM-ENTRIES(int-item-fornec.obs-rec, CHR(10)):

                           ASSIGN c-linha = ENTRY(i-aux, int-item-fornec.obs-rec, CHR(10)).

                           IF i-aux = 1 THEN
                               PUT SKIP "OBS REC: ".
                           ELSE 
                               PUT SKIP "         ".

                           ASSIGN i-linhas = TRUNCATE(LENGTH(c-linha) / 68, 0).

                           IF TRUNCATE(LENGTH(c-linha) / 68, 0) <> LENGTH(c-linha) / 68 THEN 
                               ASSIGN i-linhas = i-linhas + 1.

                           ASSIGN i-pedaco = 1.

                           DO i-quebra = 1 TO i-linhas:

                               PUT UNFORMATTED SUBSTRING(c-linha, i-pedaco, 68).

                               IF i-quebra < i-linhas THEN
                                   PUT SKIP "         ".

                               ASSIGN i-pedaco = i-pedaco + 68.

                           END.

                       END.

                   END.
                      
                end.

           end.
              
           assign i-etiquetas = i-etiquetas / i-lote-multiplo.
           if i-etiquetas = 0 then assign i-etiquetas = 1.

           if i-fl-tam-amostra = 0 then assign c-situacao = "ERRO NA AMOSTRA. VERIFIQUE  CADASTRO - " + c-situacao.

           if i-fl-tam-amostra > i-qtde-rot-tot then do:
               put skip
                   "AMOSTRA MAIOR QUE LOTE. PROCURE A INFORMATICA".
                next.
           end.

           run ctr.

           put "Total  "                            at 08
               i-qtde-rot-tot format ">,>>>,>>9.99" at 20 skip
               "Criticidade: " (IF AVAIL item-uni-estab THEN item-uni-estab.criticidade ELSE item.criticidade) "   " 
               "Situa‡Æo de Inspe‡Æo: " c-situacao  skip
               "NQA: " i-fl-nqa 
               " N¡vel: " i-fl-nivel  
               " Faixa: " i-fl-lote
               " Cod. Amostra: " i-fl-cod-amostra
               " Tam. Amostra: " i-fl-tam-amostra 
               skip
               "Aceita Lote com: " i-fl-aceita
               " pecas com defeito. Rejeita Lote com: " i-fl-rejeita
               " pecas com defeito. "
               
               skip
               
               " UN: " item.un 
               " Contenedor: " i-lote-multiplo format ">>>,>>9"
               " Etiquetas: " i-etiquetas format ">>>>>>9" skip

               "Fabr.Inferior: " c-fab-inf 
               "Acondicionamento: " c-acond skip.
               run desenho-ctr.
              put   
               
               "Item Fabricante:" at 01 space(02).
                   
           find first item-fabric no-lock
                where item-fabric.it-codigo  = item.it-codigo 
                  and item-fabric.cod-fabric = emitente.cod-emitente no-error.
            if avail item-fabric then do:
                put item-fabric.it-fabric skip.
            end.
            else do:
                for each item-fabric no-lock  
                   where item-fabric.it-codigo = item.it-codigo,
                    each fabricante no-lock
                   where fabricante.cod-fabric = item-fabric.cod-fabric:
                     put skip fabricante.nome-abrev "     "
                              item-fabric.it-fabric.
                end.
            end.   
            
            put skip 
                   
"______________________________________________________________________________
".                   
            assign i-quantidade-rot = 0
                   i-qtde-rot-tot = 0
                   i-etiquetas = 0.  
       
       end.    
       find first b-ae-inspecao where recid(b-ae-inspecao) = recid(ae-inspecao) exclusive-lock.
       assign b-ae-inspecao.ae-imp = string(int(ae-inspecao.ae-imp) + 1).
       find current b-ae-inspecao no-lock.
       if last-of(ae-inspecao.cod-emitente) or 
          last-of(ae-inspecao.nat-operacao) then do: 
           /*
           DO WHILE LINE-COUNTER < 59:
               PUT " " SKIP.
           END.
           PUT
           skip(3)
           "_______________________" at 50 skip
           "Inspetor" at 57
           skip(2).
           */
           /*
           VIEW FRAME f-rodape-2.
           */
           page.
       end.

    end.
        
    /* fim da impressao do ae-inspecao */
    
    /*
    output  close.
    hide message no-pause.
    */
end.

/*****************************************************************************/ 


procedure imprime-industrializacao:

    run compacta-ind.     
         
         
    assign i-quantidade = 0
           i-quantidade-rot = 0
           i-qtde-rot-tot = 0
           c-ind = "Industrializa‡Æo".

    /*
    view frame f-cabecalho.
    if tt-param.urgencia then view frame f-urgente.
    view frame f-cabecalho1.
    view frame f-rodape-2.
    */
    assign i-etiquetas = 0
           i-quantidade-rot = 0.                 
         
    for each ae-inspecao no-lock
        where ae-inspecao.cod-estabel = tt-param.cod-estabel
          and ae-inspecao.nro-docto = int(tt-param.nro-docto)
          and ae-inspecao.cod-emitente = tt-param.cod-emitente
          and ae-inspecao.serie = tt-param.serie-docto
          and ae-inspecao.nat-operacao = tt-param.nat-operacao
        break by ae-inspecao.cod-emitente
              by ae-inspecao.nro-docto
              by ae-inspecao.nat-operacao
              by ae-inspecao.it-codigo:

        assign i-etiquetas = i-etiquetas + ae-inspecao.quantidade.
        
        find emitente 
             where emitente.cod-emit = ae-inspecao.cod-emitente no-lock.
           
        find item  where item.it-codigo = ae-inspecao.it-codigo no-lock.

        find first item-uni-estab 
             where item-uni-estab.cod-estabel = ae-inspecao.cod-estabel
               AND item-uni-estab.it-codigo   = ae-inspecao.it-codigo no-lock no-error.

        
        run busca-capacidade.
        
        assign tt-param.serie-docto = ae-inspecao.serie
               tt-param.nat-operacao = ae-inspecao.nat-operacao
               i-emitente = ae-inspecao.cod-emitente
               c-emitente = emitente.nome-emit  
               c-estabelecimento = ae-inspecao.cod-estabel
               i-imp             = int(ae-inspecao.ae-imp) + 1
               i-estrado  = ae-inspecao.estrado[1] + "-" +
                            ae-inspecao.estrado[2] + "-" +
                            ae-inspecao.estrado[3] + "-" +
                            ae-inspecao.estrado[4] + "-" +
                            ae-inspecao.estrado[5]
               c-localizacao1[1] = "1-" + ae-inspecao.localizacao[1]
               c-localizacao1[2] = "2-" + ae-inspecao.localizacao[2]
               c-localizacao1[3] = "3-" + ae-inspecao.localizacao[3]
               c-localizacao1[4] = "4-" + ae-inspecao.localizacao[4]
               c-localizacao1[5] = "5-" + ae-inspecao.localizacao[5]
               i-nota     = string(ae-inspecao.nro-docto,"9999999")
               i-quantidade-rot = i-quantidade-rot + ae-inspecao.quantidade
               i-qtde-rot-tot = i-qtde-rot-tot + ae-inspecao.quantidade.
        if first-of(ae-inspecao.it-codigo) then
           /*
           view frame f-cabecalho.
           if tt-param.urgencia then view frame f-urgente.
           view frame f-cabecalho1.
           */

           put ae-inspecao.it-codigo format "x(8)" at 01
               item.descricao-1
               item.descricao-2  
               " "
               ae-inspecao.nr-ae. 
           
        put ae-inspecao.nr-ficha at 08
            ae-inspecao.quantidade format ">,>>>,>>9.99"   at 20.

        if last-of(ae-inspecao.it-codigo)  then do:
           find item-fornec-estab where
                item-fornec-estab.cod-estabel = tt-param.cod-estabel AND
                item-fornec-estab.it-codigo    = ae-inspecao.it-codigo and
                item-fornec-estab.cod-emitente = emitente.cod-emitente 
                no-lock no-error.
           find item
                where item.it-codigo = ae-inspecao.it-codigo no-lock
                no-error.

                if avail item-fornec-estab then do:
                        assign i-lote-multiplo = item-fornec-estab.lote-mul-for.
                        find ficha-cq where ficha-cq.nr-ficha =                              ae-inspecao.nr-ficha no-lock.

                        case item-fornec-estab.tp-inspecao:
                        when 1 then assign c-situacao = "Severa".
                        when 2 then assign c-situacao = "Normal".
                        when 3 then assign c-situacao = "Atenuada".
                        otherwise do:
                            assign c-situacao = "ASSEGURADA".
                            run qual-assegurada.
                        end.

                                       
                       end.


                end.
                else do:
                    assign i-lote-multiplo = IF AVAIL item-uni-estab THEN item-uni-estab.lote-multipl ELSE item.lote-multipl.
                end.

           run busca-capacidade.
           
           run pega-amostra.


              
            if avail item-fornec-estab then do:
               find int-item-fornec of item-fornec-estab no-lock no-error.
               if avail int-item-fornec then do:
                  
                   if int-item-fornec.obs-insp <> "" then 
                      put skip "OBS INSP.: " int-item-fornec.obs-insp .
                   if int-item-fornec.obs-rec <> "" then 
                      put skip "OBS REC.: " int-item-fornec.obs-rec .
                end.
           end.
 
           assign i-etiquetas = i-etiquetas / i-lote-multiplo.
          
           
           if i-etiquetas = 0 then 
              assign i-etiquetas = 1.
          if i-fl-tam-amostra = 0 then assign c-situacao = "ERRO NA AMOSTRA. VERIFIQUE   CADASTRO - " + c-situacao.

          if i-fl-tam-amostra > i-qtde-rot-tot then do:
                put "AMOSTRA MAIOR QUE LOTE. PROCURE A INFORMATICA".
                next.
          end.

          run ctr.
          
          put "Total  "                            at 08
               i-qtde-rot-tot format ">,>>>,>>9.99" at 20 skip
               "Criticidade: " (IF AVAIL item-uni-estab THEN item-uni-estab.criticidade ELSE item.criticidade) "   " 
               "Situa‡Æo de Inspe‡Æo: " c-situacao skip
  "NQA: " i-fl-nqa 
               " N¡vel: " i-fl-nivel  
               " Faixa: " i-fl-lote
               " Cod. Amostra: " i-fl-cod-amostra
               " Tam. Amostra: " i-fl-tam-amostra 
               skip
               "Aceita Lote com: " i-fl-aceita
               " pecas com defeito. Rejeita Lote com: " i-fl-rejeita
               " pecas com defeito. "
               skip
               " UN: " item.un 
               " Contenedor: " i-lote-multiplo format ">>>,>>9"
               " Etiquetas: " i-etiquetas format ">>>>9" skip
               "Fabr.Inferior: " c-fab-inf 
               "Acondicionamento: " c-acond skip.
               run desenho-ctr.
            put   
               "Item Fabricante:" at 01  space(02) .
               
                find first item-fabric where
                      item-fabric.it-codigo = item.it-codigo 
                  and item-fabric.cod-fabric = emitente.cod-emitente no-lock no-error.
                  if avail item-fabric then do:
                     put item-fabric.it-fabric skip.
                  end.
                  else do:
                     for each item-fabric no-lock  where
                              item-fabric.it-codigo = item.it-codigo,
                         each fabricante no-lock where
                              fabricante.cod-fabric = item-fabric.cod-fabric:
                              put skip fabricante.nome-abrev "     "
                                  item-fabric.it-fabric.
                     end.
                  end.   
           
                
               
                put skip 
"______________________________________________________________________________
".                   
           assign i-quantidade-rot = 0
                   i-qtde-rot-tot = 0
                   i-etiquetas = 0.  
           
           
        end.    
        
        find first b-ae-inspecao where recid(b-ae-inspecao) = recid(ae-inspecao) exclusive-lock.
        assign b-ae-inspecao.ae-imp = string(int(ae-inspecao.ae-imp) + 1).
        find current b-ae-inspecao no-lock.
        if last-of(ae-inspecao.cod-emitente) or 
           last-of(ae-inspecao.nat-operacao) then do: 
           /*
           DO WHILE LINE-COUNTER < 59:
               PUT " " SKIP.
           END.
           PUT
           skip(3)
           "_______________________" at 50 skip
           "Inspetor" at 57
           skip(2).
           */
           /*
           VIEW FRAME f-rodape-2.
           */
           page.
        end.


    end. /***** for each ae-inspecao ***/
end.

/*****************************************************************************/ 

PROCEDURE pega-amostra:
    
    find item-doc-est 
         where item-doc-est.it-codigo = ae-inspecao.it-codigo
           and item-doc-est.nro-docto = string(ae-inspecao.nro-docto,"9999999")
           and item-doc-est.serie-docto = ae-inspecao.serie
           and item-doc-est.nat-operacao = ae-inspecao.nat-operacao
           and item-doc-est.cod-emitente = ae-inspecao.cod-emitent 
           no-lock no-error.
               
    find pedido-compr 
         where pedido-compr.num-pedido = item-doc-est.num-pedido 
         no-lock no-error.
    if not avail pedido-compr then 
       find item-fornec-estab
            where item-fornec-estab.cod-estabel = tt-param.cod-estabel
              AND item-fornec-estab.it-codigo = ae-inspecao.it-codigo
              and item-fornec-estab.cod-emitente = emitente.cod-emitente 
              no-lock no-error.
    else
       find item-fornec-estab
            where item-fornec-estab.cod-estabel = tt-param.cod-estabel
              AND item-fornec-estab.it-codigo = ae-inspecao.it-codigo
              and item-fornec-estab.cod-emitente = pedido-compr.cod-emitente 
             no-lock no-error.
    
    find item no-lock
         where item.it-codigo = ae-inspecao.it-codigo no-error.

    if avail item-fornec-estab then DO:

        assign i-lote-multiplo = item-fornec-estab.lote-mul-for.                        

        case item-fornec-estab.tp-insp:
           when 1 then assign i-fl-tipo = 3.
           when 3 then assign i-fl-tipo = 1.
           otherwise assign i-fl-tipo = 2.
        end.
    END.
    else DO:
        assign i-lote-multiplo = IF AVAIL item-uni-estab THEN item-uni-estab.lote-multipl ELSE item.lote-multipl
               i-fl-tipo       = ITEM.tipo-insp.
    END.
        

    assign i-fl-nivel = item.nivel
           i-fl-nqa   = item.perc-nqa.

    FIND FIRST nivel-insp 
             WHERE nivel-insp.nivel   = i-fl-nivel 
               AND nivel-insp.tam-lote >= i-quantidade-rot no-lock no-error.
    if  not avail nivel-insp then do:
        run utp/ut-msgs.p (input "msg",
                           input 3302,
                           input "N¡vel de Inspe‡Æo~~tamanho do lote~~" +
                           string(i-quantidade-rot)).
    end.
    else do:
        assign i-fl-lote = nivel-insp.tam-lote.
        
        find first amostra 
             where amostra.tipo-plano = i-fl-tipo
               and amostra.cod-amostra = nivel-insp.cod-amostra no-lock no-error.
        if  not avail amostra then do:
            run utp/ut-msgs.p (input "msg",
                               input 3302,
                               input "Tabela de Amostra MCQ~~Plano Normal MCQ~~" +
                               string(i-fl-tipo)). 
        end.
        else do:
            find first nqa-simp where nqa-simp.tipo-plano = i-fl-tipo and
                       nqa-simp.cod-amostra = nivel-insp.cod-amostra and
                       nqa-simp.perc-nqa = i-fl-nqa
                       no-lock no-error.
            if  avail nqa-simp then do:
                assign de-perc-nqa = nqa-simp.perc-nqa.
                if  nqa-simp.nr-aceita = ? then do:
                        /*------------ AJUSTE INFERIOR ------------*/
                        if  nqa-simp.ajuste-tab = 1 then 
                            find next nqa-simp where nqa-simp.tipo-plano = i-fl-tipo
                                     and nqa-simp.perc-nqa =
                                     de-perc-nqa and nqa-simp.nr-aceita <> ?
                                     no-lock no-error.
                        else                       
                        /*------------ AJUSTE SUPERIOR ------------*/
                            find prev nqa-simp where nqa-simp.tipo-plano = i-fl-tipo
                                     and nqa-simp.perc-nqa =
                                     de-perc-nqa and nqa-simp.nr-aceita <> ?
                                     no-lock no-error.                 
                end.
            end.
            if  avail nqa-simp then do:
                    find first amostra where amostra.tipo-plano = i-fl-tipo
                         and amostra.cod-amostra = nqa-simp.cod-amostra 
                         no-lock no-error.
                    assign i-fl-aceita  = nqa-simp.nr-aceita
                           i-fl-rejeita = nqa-simp.nr-rejeita
                           i-fl-tam-amostra = amostra.tam-amostra
                           i-fl-cod-amostra = amostra.cod-amostra.
                end.
                else do:
                     run utp/ut-msgs.p (input "msg",
                                        input 3305,
                                        input string(de-perc-nqa) + "~~" +
                                              string(i-fl-tipo)).
            end.

            /* Atualiza o tamanho da amostra igual ao tamanho do lote
            (inspecao 100%), quando amostra igualar ou exceder o lote */

            if  amostra.tam-amostra >= integer(i-quantidade-rot) then do:
                    run utp/ut-msgs.p (input "msg", 
                                       input 3310,
                                       input "Tamanho da amostra MCQ~~tamanho do lote MCQ").
                    run utp/ut-msgs.p (input "msg",
                                       input 3311,
                                       input "").
                    assign i-fl-tam-amostra = int(i-quantidade-rot).
            end.
        end.
    end.
end.


PROCEDURE pi-gera-email-manaus :
    DEFINE INPUT  PARAMETER p-serie-docto  LIKE item-doc-est.serie-docto  NO-UNDO.
    DEFINE INPUT  PARAMETER p-nro-docto    LIKE item-doc-est.nro-docto    NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-emitente LIKE item-doc-est.cod-emitente NO-UNDO.
    DEFINE INPUT  PARAMETER p-nat-operacao LIKE item-doc-est.nat-operacao NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-pedido   LIKE pedido-compr.num-pedido   NO-UNDO.
    DEFINE INPUT  PARAMETER p-numero-ordem LIKE item-doc-est.numero-ordem NO-UNDO.
    DEFINE INPUT  PARAMETER p-sequencia    LIKE item-doc-est.sequencia    NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo    LIKE item-doc-est.it-codigo    NO-UNDO.
    DEFINE INPUT  PARAMETER p-quantidade   LIKE item-doc-est.quantidade   NO-UNDO.

    FIND FIRST bm-ordem-compra USE-INDEX pedido
        WHERE bm-ordem-compra.num-pedido   = p-num-pedido
          AND bm-ordem-compra.numero-ordem = p-numero-ordem
          AND bm-ordem-compra.it-codigo    = p-it-codigo NO-LOCK NO-ERROR.

    IF AVAILABLE bm-ordem-compra THEN DO:
        FIND FIRST tt-email-para-manaus
            WHERE tt-email-para-manaus.serie-docto  = p-serie-docto
              AND tt-email-para-manaus.nro-docto    = p-nro-docto
              AND tt-email-para-manaus.cod-emitente = p-cod-emitente
              AND tt-email-para-manaus.nat-operacao = p-nat-operacao
              AND tt-email-para-manaus.num-pedido   = p-num-pedido
              AND tt-email-para-manaus.numero-ordem = bm-ordem-compra.numero-ordem
              AND tt-email-para-manaus.it-codigo    = p-it-codigo NO-ERROR.

        IF NOT AVAILABLE tt-email-para-manaus THEN DO:
            CREATE tt-email-para-manaus.
            ASSIGN tt-email-para-manaus.serie-docto  = p-serie-docto
                   tt-email-para-manaus.nro-docto    = p-nro-docto
                   tt-email-para-manaus.cod-emitente = p-cod-emitente
                   tt-email-para-manaus.nat-operacao = p-nat-operacao
                   tt-email-para-manaus.num-pedido   = bm-ordem-compra.num-pedido
                   tt-email-para-manaus.numero-ordem = bm-ordem-compra.numero-ordem
                   tt-email-para-manaus.it-codigo    = bm-ordem-compra.it-codigo.
        END.

        ASSIGN tt-email-para-manaus.quantidade = IF bm-ordem-compra.qt-solic < p-quantidade THEN bm-ordem-compra.qt-solic ELSE p-quantidade.
    END.
    ELSE DO:
        FOR EACH rat-ordem NO-LOCK
            WHERE rat-ordem.serie-docto  = p-serie-docto
              AND rat-ordem.nro-docto    = p-nro-docto
              AND rat-ordem.cod-emitente = p-cod-emitente
              AND rat-ordem.nat-operacao = p-nat-operacao
              AND rat-ordem.sequencia    = p-sequencia
              AND rat-ordem.num-pedido   = p-num-pedido,
            FIRST ordem-compra NO-LOCK
            WHERE ordem-compra.numero-ordem = rat-ordem.numero-ordem:

            FIND FIRST tt-email-para-manaus
                WHERE tt-email-para-manaus.serie-docto  = rat-ordem.serie-docto
                  AND tt-email-para-manaus.nro-docto    = rat-ordem.nro-docto
                  AND tt-email-para-manaus.cod-emitente = rat-ordem.cod-emitente
                  AND tt-email-para-manaus.nat-operacao = rat-ordem.nat-operacao
                  AND tt-email-para-manaus.num-pedido   = rat-ordem.num-pedido
                  AND tt-email-para-manaus.numero-ordem = rat-ordem.numero-ordem
                  AND tt-email-para-manaus.it-codigo    = ordem-compra.it-codigo NO-ERROR.

            IF NOT AVAILABLE tt-email-para-manaus THEN DO:
                CREATE tt-email-para-manaus.
                ASSIGN tt-email-para-manaus.serie-docto  = rat-ordem.serie-docto
                       tt-email-para-manaus.nro-docto    = rat-ordem.nro-docto
                       tt-email-para-manaus.cod-emitente = rat-ordem.cod-emitente
                       tt-email-para-manaus.nat-operacao = rat-ordem.nat-operacao
                       tt-email-para-manaus.num-pedido   = rat-ordem.num-pedido
                       tt-email-para-manaus.numero-ordem = rat-ordem.numero-ordem
                       tt-email-para-manaus.it-codigo    = ordem-compra.it-codigo.
            END.

            ASSIGN tt-email-para-manaus.quantidade = rat-ordem.quantidade.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-envia-email-manaus :
    DEFINE VARIABLE c-texto-html AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE v-nome-emit LIKE emitente.nome-emit NO-UNDO.
    DEFINE VARIABLE v-desc-item LIKE item.desc-item     NO-UNDO.

    DEFINE VARIABLE c-destino AS CHARACTER   NO-UNDO.

    IF NOT CAN-FIND(FIRST tt-email-para-manaus) THEN
        RETURN "OK":U.

    FIND FIRST emitente
        WHERE emitente.cod-emitente = tt-param.cod-emitente NO-LOCK NO-ERROR.

    ASSIGN v-nome-emit = IF AVAILABLE emitente THEN TRIM(emitente.nome-emit) ELSE "":U.

    ASSIGN c-texto-html = "<html>":U + CHR(10) +
                          "    <head>":U + CHR(10) +
                          "        <title>Entrada de Itens para Manaus</title>":U + CHR(10) +
                          "        <style type=~"text/css~">":U + CHR(10) +
                          "            table.bordasimples ~{ border-collapse: collapse; border-color: #000000; ~}":U + CHR(10) +
                          "            table.bordasimples tr td ~{ border: 1px solid; text-align: left; border-color: #000000; ~}":U + CHR(10) +
                          "            table.bordasimples tr th ~{ border: 1px solid; text-align: left; border-color: #000000; ~}":U + CHR(10) +
                          "        </style>":U + CHR(10) +
                          "    </head>":U + CHR(10) +
                          "    <body text=~"#000000~">":U + CHR(10) +
                          "        <table>":U + CHR(10) +
                          "            <tr><td><h3 align=~"center~">Entrada de Itens para Manaus</h3></td></tr>":U + CHR(10) +
                          "            <tr>":U + CHR(10) +
                          "                <td>":U + CHR(10) +
                          "                    <table>":U + CHR(10) +
                          "                        <tr><td align=~"right~"><b>Fornecedor:</b></td><td>":U + TRIM(STRING(tt-param.cod-emitente, ">>>,>>>,>>9":U)) + " - ":U + v-nome-emit + "</td></tr>":U + CHR(10) +
                          "                        <tr><td align=~"right~"><b>Natureza Opera‡Æo:</b></td><td>":U + TRIM(tt-param.nat-operacao) + "</td></tr>":U + CHR(10) +
                          "                        <tr><td align=~"right~"><b>S‚rie:</b></td><td>":U + TRIM(tt-param.serie-docto) + "</td></tr>":U + CHR(10) +
                          "                        <tr><td align=~"right~"><b>Documento:</b></td><td>":U + TRIM(tt-param.nro-docto) + "</td></tr>":U + CHR(10) +
                          "                    </table>":U + CHR(10) +
                          "                </td>":U + CHR(10) +
                          "            </tr>":U + CHR(10) +
                          "            <tr>":U + CHR(10) +
                          "                <td>":U + CHR(10) +
                          "                    <table class=~"bordasimples~" cellpadding=~"4~">":U + CHR(10) +
                          "                        <tr>":U + CHR(10) +
                          "                            <th>Pedido Compra</th>":U + CHR(10) +
                          "                            <th>Ordem Compra</th>":U + CHR(10) +
                          "                            <th>Item</th>":U + CHR(10) +
                          "                            <th>Descri‡Æo</th>":U + CHR(10) +
                          "                            <th>Quantidade</th>":U + CHR(10) +
                          "                        </tr>":U +  CHR(10).

    FOR EACH tt-email-para-manaus:
        FIND FIRST item
            WHERE item.it-codigo = tt-email-para-manaus.it-codigo NO-LOCK NO-ERROR.

        ASSIGN v-desc-item = IF AVAILABLE item THEN TRIM(item.desc-item) ELSE "":U.

        ASSIGN c-texto-html = c-texto-html +
                              "                        <tr>":U + CHR(10) +
                              "                            <td>":U + TRIM(STRING(tt-email-para-manaus.num-pedido, ">>>>>,>>9":U)) + "</td>":U + CHR(10) +
                              "                            <td>":U + TRIM(STRING(tt-email-para-manaus.numero-ordem, "zzzzz9,99":U)) + "</td>":U + CHR(10) +
                              "                            <td>":U + TRIM(tt-email-para-manaus.it-codigo) + "</td>":U + CHR(10) +
                              "                            <td>":U + v-desc-item + "</td>":U + CHR(10) +
                              "                            <td>":U + TRIM(STRING(tt-email-para-manaus.quantidade, ">,>>>,>>>,>>9.99":U)) + "</td>":U + CHR(10) +
                              "                        </tr>":U +  CHR(10).
    END.

    ASSIGN c-texto-html = c-texto-html +
                          "                    </table>":U + CHR(10) +
                          "                </td>":U + CHR(10) +
                          "            </tr>":U + CHR(10) +
                          "        </table>":U + CHR(10) +
                          "    </body>":U + CHR(10) +
                          "</html>":U.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    IF NOT AVAILABLE param-global THEN
        RETURN "NOK":U.

    IF NOT VALID-HANDLE(h-utapi019) THEN
        RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    EMPTY TEMP-TABLE tt-envio2.
    EMPTY TEMP-TABLE tt-mensagem.

    RUN esp/es0018p.p (INPUT  "escqp003rp":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    ASSIGN c-destino = "":U.

    FOR EACH tt-prog-ponto:
        ASSIGN c-destino = (IF c-destino = "":U THEN "":U ELSE (c-destino + ",":U)) + tt-prog-ponto.conteudo.
    END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail
           tt-envio2.porta             = param-global.porta-mail
           tt-envio2.remetente         = "ems@intelbras.com.br":U
           tt-envio2.destino           = c-destino
           tt-envio2.assunto           = "Entrada de Itens para Manaus":U
           tt-envio2.formato           = "HTML":U.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = c-texto-html.

    IF VALID-HANDLE(h-utapi019) THEN
        RUN pi-execute2 IN h-utapi019 (INPUT  TABLE tt-envio2,
                                       INPUT  TABLE tt-mensagem,
                                       OUTPUT TABLE tt-erros).

    IF VALID-HANDLE(h-utapi019) THEN
        DELETE PROCEDURE h-utapi019.

    RETURN "OK":U.

END PROCEDURE.

