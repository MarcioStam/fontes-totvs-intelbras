/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i FT4015RP 2.00.00.012}  /*** 010012 ***/

/*****************************************************************************
**
**  Programa: FT4015RP - Impressao dos dados da simulacao do Calculo da Nota.
**
**  Data....: Agosto/2000
**
**  Objetivo: Mostrar os dados gerados para as worktables que cont‚m as infor-
**            ma‡äes do c lculo das notas.
**
******************************************************************************/

def temp-table tt-documentos no-undo
    field seq-wt-docto as int
    index codigo
          seq-wt-docto. 

{cdp/cdcfgdis.i}
{cdp/cd0620.i1 "' '"}
{include/tt-edit.i}
{include/pi-edit.i}
find first doc-fiscal no-lock no-error.

def temp-table tt-param
    field destino         as int
    field arquivo         as char
    field usuario         as char form "x(12)":U
    field data-exec       as date
    field hora-exec       as int
    field classifica      as int
    field desc-classifica as char form "x(40)":U.

define temp-table tt-digita
    field ordem   as int  form ">>>>9":U
    field exemplo as char form "x(30)":U
    index id is primary unique
          ordem.

define temp-table tt-class-fis
     field b-cod-class  like  item.class-fisc
     field b-indice     as    integer initial 0
     index b-cod-class
     is primary b-cod-class ascending.

def temp-table tt-resto
    field it-codigo like item.it-codigo
    field qtde      as dec
    index tt-resto is primary unique it-codigo
    index qtde     qtde.

def temp-table tt-volume-nf no-undo like volume-nf.

def input param i-cod-pais-imposto as integer.
def input param table for tt-param.
def input param table for tt-documentos.

find first tt-param no-error.
{include/i-rpvar.i} /* Include padrao de relatorio */
{include/i-rpout.i} /* Include padrao de relatorio */

def new shared var de-val9100   as decimal.
def new shared var i-num9100    as integer.
def new shared var i-tam9100    as integer.
def new shared var c-ext9100    as character extent 10.
DEFINE VARIABLE c-imp-boleto    AS CHARACTER  NO-UNDO FORMAT 'x(4)'.
def var i                       as int no-undo.
def var i-parcela               as integer                             extent 6 no-undo.
def var c-fatura                as char      format "x(6)"            extent 6 no-undo.
def var da-venc-dup             as date      format "99/99/9999"       extent 6 no-undo.
def var de-vl-dup               as decimal   format ">>>>>,>>>,>>9.99" extent 6 no-undo.
def var c-formato-cfop          as char no-undo.
def var i-nr-ult-fat            as int no-undo.
def var i-nr-ult-nota           as int no-undo.
def var c-class-fiscal          as character format "99" no-undo.
def var c-un-fatur              as character format "x(2)" no-undo.
def var de-qt-fatur             as decimal format ">>>>,>>9.9999" no-undo.
def var i-codigo                as integer no-undo.
def var l-sub                   as logical no-undo.
def var de-tot-icmssubs         like it-nota-fisc.vl-icmsub-it no-undo.
def var de-tot-bicmssubs        like it-nota-fisc.vl-bsubs-it no-undo.
def var de-tot-bas-icm          like it-nota-fisc.vl-icms-it no-undo.
def var de-tot-bas-iss          like it-nota-fisc.vl-iss-it no-undo.
def var de-tot-bas-ipi          like it-nota-fisc.vl-ipi-it no-undo.
def var de-tot-icm              like it-nota-fisc.vl-icms-it no-undo.
def var de-tot-iss              like it-nota-fisc.vl-iss-it no-undo.
def var de-tot-ipi              like it-nota-fisc.vl-ipi-it no-undo.
def var de-tot-nota             as dec no-undo.
def var c-pago                  as character format "x" init " " no-undo.
def var c-mess                  as character NO-UNDO format "x(73)" extent 20 init " ".
def var de-conv                 as decimal no-undo init 1.
def var c-cod-suframa-est       as char no-undo.
def var c-cod-suframa-cli       as char no-undo.
def var l-tem-portaria          as logi no-undo.
def var l-nao-tem-portaria      as logi no-undo.
def var l-lei-informatica       as logi no-undo.
DEFINE VARIABLE l-software          AS LOGICAL      NO-UNDO.
def var de-tot-icmssubs-obs     as dec no-undo.
def var de-tot-bicmssubs-obs    as dec no-undo.
def var de-tot-icms-obs         as dec no-undo.
def var de-tot-ipi-calc         as dec no-undo.
def var de-acum-vl-merc-ori     as dec no-undo.
def var de-aliquota-iss         as dec no-undo.
def var c-emb-escolhida         as char no-undo.
def var de-peso-embalag         as dec no-undo.
def var c-desc-prod             as char no-undo.
DEF VAR c-chave-bem             AS CHAR NO-UNDO.
DEFINE VARIABLE c-desc-portaria     AS CHARACTER   NO-UNDO.

find first param-global no-lock no-error.

for first tt-documentos,
    first wt-docto no-lock
    where wt-docto.seq-wt-docto = tt-documentos.seq-wt-docto:
    
    find first natur-oper no-lock
        where natur-oper.nat-operacao = wt-docto.nat-operacao no-error.
        
    find first ser-estab no-lock
        where ser-estab.cod-estabel = wt-docto.cod-estabel
        and   ser-estab.serie       = wt-docto.serie no-error.
        
    find first emitente no-lock
        where emitente.cod-emitente = wt-docto.cod-emitente no-error.      
        
    find first estabelec no-lock
        where estabelec.cod-estabel = wt-docto.cod-estabel no-error.          

    find first cidade-zf where cidade-zf.cidade = wt-docto.cidade
                         and   cidade-zf.estado = wt-docto.estado
                         no-lock no-error.
                         
    if  avail cidade-zf 
    and dec(natur-oper.per-des-icms) > 0 then
        assign de-conv = (100 - dec(natur-oper.per-des-icms)) / 100.
               
    IF natur-oper.tipo = 1 THEN /* ENTRADA */   
        PUT "X"       AT 105.
    ELSE                        /* SAIDA   */
        PUT "X"       AT  89.

    i-nr-ult-nota = int(ser-estab.nr-ult-nota) + 1.
    
    put string(i-nr-ult-nota) format "x(7)" at 124.
   
    assign c-imp-boleto = "". 

    if wt-docto.modalidade <> 7 then do:
       if (wt-docto.cod-port = 999 and wt-docto.modalidade = 6) or
          (wt-docto.cod-port = 237 and wt-docto.modalidade = 6) then do:
          do i = 1 to 6:
             if (da-venc-dup[i] - wt-docto.dt-emis-nota) >= 5
                and (da-venc-dup[i] - wt-docto.dt-emis-nota)  <= 25 then
                assign c-imp-boleto = "(**)".
          end.
       end.
    end.

    put "  " c-imp-boleto skip.
    
    ASSIGN c-formato-cfop = if SUBSTRING(natur-oper.char-2,78,10) <> " "
                            THEN trim(SUBSTRING(natur-oper.char-2,78,10))
                            ELSE "9.99".

    {cdp/cd0620.i1 wt-docto.cod-estabel}
    
    put natur-oper.denominacao                              at 01
        {cdp/cd0620.i2 nat-operacao wt-docto.dt-emis-nota "' '" c-formato-cfop} at 40 skip(1)
        emitente.nome-emit at 01.
        
    if emitente.nome-abrev <> "brinde" THEN
        put "(" + string(emitente.cod-emitente,">>>,>>9") + ")" format "x(10)" at 75
            emitente.cgc                                                       at 87.

    put wt-docto.dt-emis-nota FORMAT '99/99/9999' AT 120 SKIP(1)
        emitente.endereco     at  1
        emitente.bairro       FORMAT 'x(20)'        at 66
        emitente.cep          FORMAT param-global.formato-cep at 99 skip.
        
    if emitente.nome-abrev <> "brinde" THEN
        PUT emitente.cidade                at 01
            emitente.telefone[1]           at 46
            emitente.estado                at 78
            emitente.ins-estadual          at 87 skip(1).
            
    i-nr-ult-fat = int(ser-estab.nr-ult-fat) + 1.        
    for each  wt-fat-duplic of wt-docto no-lock
        break by wt-fat-duplic.parcela i = 1 to 6:
    
        assign da-venc-dup [i] = wt-fat-duplic.dt-venciment
               de-vl-dup[i]    = wt-fat-duplic.vl-parcela 
               c-fatura[i]     = string(i-nr-ult-fat)
               i-parcela[i]    = integer(wt-fat-duplic.parcela).
    end.

            
    /*------  DUPLICATAS  ------*/
    
    put "-------------------- DUPLICATAS --------------------" AT 40 SKIP(1).
    assign de-val9100 = 0.
    DO i = 1 TO 2:
       
       assign de-val9100 = de-val9100 + de-vl-dup[i].
       
       PUT da-venc-dup[i]                  AT  01
           de-vl-dup[i]                    AT  14
           c-fatura[i]     FORMAT 'x(6)'   AT  36
           '/'                             AT  42
           i-parcela[i]    FORMAT '99'     AT  43.

       IF i-parcela[i + 2] <> 0 THEN do:
          
          assign de-val9100 = de-val9100 + de-vl-dup[i + 2].
          
          PUT da-venc-dup[i + 2]                  AT 47
              de-vl-dup[i + 2]                    AT 61
              c-fatura[i + 2]     FORMAT 'x(6)'   AT 83
              '/'                                 AT 89
              i-parcela[i + 2]    FORMAT '99'     AT 90.
       end.

       IF i-parcela[i + 4] <> 0 then do:
       
          assign de-val9100 = de-val9100 + de-vl-dup[i + 4].
          
          PUT da-venc-dup[i + 4]                  AT 93
              de-vl-dup[i + 4]                    AT 107
              c-fatura[i + 4]     FORMAT 'x(6)'   AT 129
              '/'                                 AT 135
              i-parcela[i + 4]    FORMAT '99'     AT 136.
       end.
       PUT SKIP.
    END.            
    put skip(1).

    IF c-fatura[1] <> '' THEN DO:
        ASSIGN i-num9100  = 2
               i-tam9100  = 80.
        RUN cdp/cd9100.p.
        PUT c-ext9100[1] format "x(80)" at 14 skip
            c-ext9100[2] format "x(80)" at 14 skip.
    END.
    put skip(1).
    put "-------------------- ITENS DA NOTA --------------------" AT 38 SKIP(1).

    i = 0.
    ASSIGN l-software       = NO
           l-tem-portaria   = NO
           c-desc-portaria  = "".

    for each wt-it-docto of wt-docto no-lock:
        find first item of wt-it-docto no-lock no-error.
        
        find first wt-it-imposto of wt-it-docto no-lock no-error.

        FIND LAST int-portaria-movto NO-LOCK
            WHERE int-portaria-movto.it-codigo     = wt-it-docto.it-codigo  
              AND int-portaria-movto.cod-estabel   = wt-docto.cod-estabel        
              AND int-portaria-movto.dt-fim        = ?
              AND int-portaria-movto.classificacao = "DEF" NO-ERROR.
        IF NOT AVAIL int-portaria-movto THEN
            FIND LAST int-portaria-movto NO-LOCK
                WHERE int-portaria-movto.it-codigo     = wt-it-docto.it-codigo  
                  AND int-portaria-movto.cod-estabel   = wt-docto.cod-estabel       
                  AND int-portaria-movto.dt-fim        = ?
                  AND int-portaria-movto.classificacao = "PROV" NO-ERROR.
        IF AVAIL int-portaria-movto THEN DO:

            ASSIGN l-tem-portaria = YES.

            IF NOT c-desc-portaria MATCHES ("*" + int-portaria-movto.codigo + "*") THEN
                IF c-desc-portaria = "" THEN
                    ASSIGN c-desc-portaria = int-portaria-movto.codigo.
                ELSE ASSIGN c-desc-portaria = c-desc-portaria + ", " + int-portaria-movto.codigo.
            
        END.
                            
        IF (SUBSTRING(item.fm-codigo, 6, 2) = '16') THEN
                    ASSIGN l-software = YES.

        RUN pi-niveis-tributacao (output i-codigo, output l-sub).
        
        if  wt-it-docto.class-fisc <> "" then do:
            assign c-class-fiscal = STRING(wt-it-docto.class-fisc).
        end.
        else 
            assign c-class-fiscal = STRING(item.class-fisc).
            
        find tt-class-fis 
              where tt-class-fis.b-cod-class = c-class-fiscal no-error.
        if avail tt-class-fis then
            assign c-class-fiscal = String(tt-class-fis.b-indice,"99").
        else do:
            create tt-class-fis.
            assign i                        = i + 1
                   tt-class-fis.b-indice    = i
                   tt-class-fis.b-cod-class = c-class-fiscal
                   c-class-fiscal           = String(tt-class-fis.b-indice,"99").
        end.           
            
        IF wt-it-docto.un[2] = "" THEN
            ASSIGN c-un-fatur  = wt-it-docto.un[1]
                   de-qt-fatur = wt-it-docto.quantidade[1].
        ELSE DO:
            FIND item-cli NO-LOCK
                WHERE item-cli.it-codigo  = wt-it-docto.it-codigo
                  AND item-cli.nome-abrev = emitente.nome-abrev
                NO-ERROR.
            IF AVAILABLE item-cli THEN
                ASSIGN c-un-fatur  = wt-it-docto.un[2]
                       de-qt-fatur = wt-it-docto.quantidade[2].
            ELSE
                ASSIGN c-un-fatur  = wt-it-docto.un[1]
                       de-qt-fatur = wt-it-docto.quantidade[1].
        END.
        
        /*------  PESQUISA A DESCRICAO DO PRODUTO  ------ */
        
        c-desc-prod = "".

        if item.ind-imp-desc = 1 THEN /* Descri‡Æo */
           ASSIGN c-desc-prod = item.desc-item.

        if  item.ind-imp-desc = 2           /* Descri‡Æo + Narrativa */
        or  item.ind-imp-desc = 5           /* Narrativa Item */
        or  item.ind-imp-desc = 6           /* Uma Linha Narrativa */
        or  item.ind-imp-desc = 10 THEN DO: /* Descri‡Æo + 24 Narrativa Item */

            if  item.ind-imp-desc = 2
            or  item.ind-imp-desc = 10 THEN
                ASSIGN c-desc-prod = item.desc-item.
            ELSE 
                ASSIGN c-desc-prod = "".

            FIND narrativa of item NO-LOCK NO-ERROR.

            IF AVAILABLE narrativa THEN 
                ASSIGN c-desc-prod = c-desc-prod +
                                  if  item.ind-imp-desc = 6 THEN
                                      trim(entry(1,SUBSTRING(narrativa.descricao,1,76),chr(10)))
                                  ELSE if item.ind-imp-desc = 10 THEN
                                      trim(entry(1,SUBSTRING(narrativa.descricao,1,24),chr(10)))
                                  ELSE                        
                                      narrativa.descricao.
        END.

        if  item.ind-imp-desc = 3          /* Descri‡Æo + Narrativa Item/Cliente */
        or  item.ind-imp-desc = 8 THEN DO: /* Descri‡Æo + 24 Narrativa Item/Cliente */
            FIND item-cli
               WHERE item-cli.nome-abrev = emitente.nome-abrev
               and   item-cli.it-codigo  = wt-it-docto.it-codigo
               NO-LOCK NO-ERROR.

            ASSIGN c-desc-prod = item.desc-item.

            IF AVAILABLE item-cli THEN
                ASSIGN c-desc-prod = c-desc-prod +
                                   if item.ind-imp-desc = 3 THEN          
                                      item-cli.narrativa
                                   ELSE
                                      trim(entry(1,SUBSTRING(item-cli.narrativa,1,24),chr(10))).
        END.

        if  item.ind-imp-desc = 4            /* Descri‡Æo + Narrativa Informada */
        or  item.ind-imp-desc = 7            /* Narrativa Informada */
        or  item.ind-imp-desc = 9 THEN DO:   /* Descri‡Æo + 24 Narrativa Informada */

            if  item.ind-imp-desc = 4
            or  item.ind-imp-desc = 9 THEN
                ASSIGN c-desc-prod = item.desc-item.
            ELSE 
                ASSIGN c-desc-prod = "".
                
            if wt-it-docto.narrativa ne "" then 
                c-desc-prod = c-desc-prod + replace(wt-it-docto.narrativa, chr(10), chr(32)).                

        END.

        FIND FIRST ped-fiscal
            WHERE ped-fiscal.cod-estabel = wt-docto.cod-estabel
            AND   ped-fiscal.serie       = wt-docto.serie
            AND   ped-fiscal.nr-nota-fis = wt-docto.nr-nota NO-LOCK NO-ERROR.

        IF  AVAIL ped-fiscal THEN DO:
            FIND FIRST it-ped-fiscal
                WHERE it-ped-fiscal.nr-pedido = ped-fiscal.nr-pedido NO-LOCK NO-ERROR.
    
            IF  AVAIL it-ped-fiscal THEN DO:
                ASSIGN c-chave-bem = substr(it-ped-fiscal.char-1, 79, 35).
                ASSIGN c-desc-prod = " Bem: " + ENTRY(2,c-chave-bem,";") + " Seq: " + ENTRY(3,c-chave-bem,";") + " - " + c-desc-prod.
            END.
        END.

        PUT item.it-codigo              format "x(7)"                             at   01
            c-desc-prod                 format "x(61)"                            at   09
            natur-oper.cod-cfop         format "X(04)"                            at   71
            c-class-fiscal              format "99"                               at   76.
        
        FIND int-wt-it-docto
             WHERE int-wt-it-docto.seq-wt-docto    = wt-it-docto.seq-wt-docto
             AND   int-wt-it-docto.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto NO-LOCK NO-ERROR.
        
        IF  AVAIL INT-wt-it-docto THEN DO:
            PUT int(string(int-wt-it-docto.codigo-orig) + string(i-codigo, "99")) format "999"   at   80.
        END.
        ELSE
            PUT int(string(item.codigo-orig) + string(i-codigo, "99")) format "999"   at   80.

        PUT c-un-fatur                  format "x(2)"                             at   85
            de-qt-fatur                 format ">>>>>>9"                          at   88
            wt-it-docto.vl-preuni       format ">>>>9.9999"                       at   97
            wt-it-docto.vl-merc-liq     format ">,>>>,>>9.99"                     at  107
            wt-it-imposto.aliquota-icm  format ">9"                               at  121 
            wt-it-imposto.aliquota-ipi  format ">9.99"                               at  125
            wt-it-imposto.vl-ipi-it     format ">>>,>>9.99"                       at  127 skip.
            
        assign de-tot-bas-icm      = de-tot-bas-icm + wt-it-imposto.vl-bicms-it
               de-tot-icm          = IF natur-oper.cd-trib-icm = 1 THEN (de-tot-icm + wt-it-imposto.vl-icms-it) ELSE de-tot-icm
               de-tot-bicmssubs    = de-tot-bicmssubs + wt-it-imposto.vl-bsubs-it
               de-tot-icmssubs     = de-tot-icmssubs + wt-it-imposto.vl-icmsub-it
               de-tot-nota         = de-tot-nota + wt-it-docto.vl-tot-item
               de-tot-ipi          = de-tot-ipi + wt-it-imposto.vl-ipi-it
               de-acum-vl-merc-ori = de-acum-vl-merc-ori + wt-it-docto.vl-merc-ori.
               
        if  lookup(SUBSTRING(natur-oper.nat-operacao,1,4), "5933,6933,7933") > 0 then
            ASSIGN de-tot-bas-iss = de-tot-bas-iss + wt-it-imposto.vl-biss-it
                   de-tot-iss     = de-tot-iss     + wt-it-imposto.vl-iss-it.
               
        /*------  ACUMULANDO VALORES PARA OBSERVACAO  ------*/

        /* IPI SOBRE AS DESPESAS */
        
        if  avail cidade-zf then do:
            assign de-tot-ipi-calc = de-tot-ipi-calc +
                                     if  wt-it-docto.vl-despes-it > 0
                                     and wt-it-imposto.vl-ipi-it    > 0
                                     then wt-it-imposto.vl-ipi-it / de-conv
                                     else
                                         if  wt-it-docto.vl-despes-it > 0
                                         and wt-it-imposto.vl-ipi-it    > 0
                                         then wt-it-imposto.vl-ipi-it
                                         else 0.
        end.                                  
        
        /* ICMS SUBSTITUTO */
        
        assign de-tot-icmssubs-obs  = de-tot-icmssubs-obs  + wt-it-imposto.vl-icmsub-it
               de-tot-bicmssubs-obs = de-tot-bicmssubs-obs + wt-it-imposto.vl-bsubs-it.
        
        
        /* TOTALIZACAO DO ICMS PARA O ESTADO DE SP - SUBST.TRIBUTARIA */
        
        assign de-tot-icms-obs = de-tot-icms-obs + wt-it-imposto.vl-icms-it
               de-tot-icms-obs = de-tot-icms-obs + wt-it-imposto.vl-icmsub-it.
               
    end.

    IF  de-tot-icmssubs-obs <> 0 
    and estabelec.estado    = "SP" 
    AND emitente.estado     = "SP" THEN
        ASSIGN de-tot-icm = 0.
    
    if  lookup(SUBSTRING(natur-oper.nat-operacao,1,4), "5933,6933,7933") > 0 then do:
        IF  de-tot-bas-iss <> 0 THEN
            ASSIGN de-aliquota-iss = de-tot-iss * 100 / de-tot-bas-iss.
        ELSE
            ASSIGN de-aliquota-iss = 0.
        
        put skip(1)
            "Base ISS: " de-tot-bas-iss  FORMAT ">>>,>>>,>>9.99" at 1 skip
            " Al¡quota ISS: " de-aliquota-iss format  ">>>>>>>>>>9.99"
            " Valor ISS: " de-tot-iss      format ">>>,>>>,>>9.99" skip.
        if wt-it-imposto.vl-irf-it <> 0 then
            put "Valor IR: " wt-it-imposto.vl-irf-it at 1 skip.       
        
    end.

    put skip(1).

    IF  wt-docto.cod-entrega <> ""
    AND wt-docto.cod-entrega <> 'PadrÆo' then do:
        find loc-entr
             where loc-entr.nome-abrev  = emitente.nome-abrev
             and   loc-entr.cod-entrega = wt-docto.cod-entrega no-lock no-error.

         put "Entrega: " at 09
             loc-entr.endereco "  "
             loc-entr.bairro "  "
             loc-entr.cidade "  "
             loc-entr.estado "  "
             "CEP." loc-entr.cep FORMAT param-global.formato-cep SKIP(2).
    end.

    put "-------------------- TOTAIS --------------------" AT 42 SKIP(1).

    /*---------------------------  IMPRIME TOTAIS  -------------------------------*/

    PUT de-tot-bas-icm           format ">>>,>>>,>>9.99"  at 01
        de-tot-icm               FORMAT ">>>,>>>,>>9.99"  AT 29
        de-tot-bicmssubs         FORMAT ">>>,>>>,>>9.99"  AT 56
        de-tot-icmssubs          FORMAT ">>>,>>>,>>9.99"  AT 84 
        wt-docto.vl-mercad       FORMAT ">>>,>>>,>>9.99"  AT 109 SKIP(1)
        wt-docto.vl-frete        format ">>>,>>>,>>9.99"  at 01
        wt-docto.vl-seguro       format ">>>,>>>,>>9.99"  at 29
        wt-docto.vl-embalagem    format ">>>,>>>,>>9.99"  at 56
        de-tot-ipi               format ">>>,>>>,>>9.99"  at 84
        de-tot-nota              format ">>>,>>>,>>9.99" at 109 skip(2).

    /*------------------  TRANSPORTADORA E DESPESAS ACESSORIAS  ------------------*/

    put "-------------------- TRANSPORTADORA / VOLUMES TRANSPORTADOS --------------------" AT 26 SKIP(1).

    FIND transporte NO-LOCK WHERE transporte.nome-abrev = wt-docto.nome-trans NO-ERROR.

    IF  wt-docto.cidade-cif <> "" THEN
        ASSIGN c-pago = "1".
    ELSE
        ASSIGN c-pago = "2".

    IF  AVAIL transporte THEN do:
        put transporte.cod-transp                               at   01
            " - "                                               at   12
            transporte.nome                                     at   15
            c-pago                                              at   79
            substring(wt-docto.placa,1,10)                      at   93
            transporte.cgc                                      at  103 skip(1).

        put transporte.endereco                                 at  01
            transporte.cidade                                   at  74
            transporte.estado                                   at  100
            transporte.ins-estadual                             at  104 skip(1).
            
    end.
    else 
        put c-pago at 79 skip(1).
    
    run pi-calcula-volumes.
    
    ASSIGN de-peso-embalag = 0.

    FOR EACH tt-volume-nf NO-LOCK
        WHERE tt-volume-nf.cod-estabel = wt-docto.cod-estabel
        AND   tt-volume-nf.serie = wt-docto.serie
        BREAK BY tt-volume-nf.nr-volume:
        IF FIRST-OF(tt-volume-nf.nr-volume) THEN DO:
            FIND FIRST embalag NO-LOCK
                 WHERE embalag.sigla-emb = tt-volume-nf.sigla-emb NO-ERROR.
            IF AVAIL embalag THEN
               ASSIGN de-peso-embalag = de-peso-embalag + embalag.peso-emb.
        END.
    END.
    
    PUT dec(wt-docto.nr-volumes) format ">>,>>9"                        at  01
        "VOLUME"                                                        at  10
        "INTELBRAS"                                                     at  51
        wt-docto.peso-bru-tot   format ">>>,>>9.999"                    at  98
        wt-docto.peso-liq-tot + de-peso-embalag  format ">>>,>>9.999"   at 117 skip(1).
    
    i = 0.    
    
    RUN pi-print-editor(replace(wt-docto.observ-nota, chr(10), chr(32)), INPUT 73).
    for each tt-editor:
        if i < 20 then
            assign i = i + 1
                   c-mess[i] = c-mess[i] + tt-editor.conteudo.
    end.           

    IF (l-tem-portaria) THEN DO:

        for each tt-editor:
            delete tt-editor.
        end.  

        IF c-desc-portaria <> "" THEN
            ASSIGN c-desc-portaria = "Produto beneficiado pela Lei n§ 8.248/91 com as modifica‡äes da Lei n§ 13.969/2019 e conf. Decreto 5.906/06 - Portaria " + c-desc-portaria + " | Produto fabricado no estab. CNPJ " + estabelec.cgc + " | ".
        
        RUN pi-print-editor(replace(c-desc-portaria, chr(10), chr(32)), INPUT 73).

        for each tt-editor:
            if i < 20 then
                assign i = i + 1
                       c-mess[i] = c-mess[i] + tt-editor.conteudo.
        end. 

    END.
    
    if i < 20 and l-software then do:
        for first mensagem no-lock
            where mensagem.cod-mensag = 93
            and   mensagem.texto-mensag > " ": 

            for each tt-editor:
                delete tt-editor.
            end.    
            
            RUN pi-print-editor(replace(mensagem.texto-mensag, chr(10), chr(32)), INPUT 73).
            
            for each tt-editor:
                if i < 20 then
                    assign i = i + 1
                           c-mess[i] = c-mess[i] + tt-editor.conteudo.
            end.           
        end.
    end.

    if avail cidade-zf then 
        assign c-cod-suframa-est = estabelec.cod-suframa
               c-cod-suframa-cli = emitente.cod-suframa.
    
    if i < 20 and c-cod-suframa-est <> "" then
        assign i = i + 1
               c-mess[i] = "Registro do Estabelecimento na SUFRAMA: " + c-cod-suframa-est.
               
    if i < 20 and c-cod-suframa-cli <> "" then
        assign i = i + 1
               c-mess[i] = "Registro do Cliente na SUFRAMA: " + c-cod-suframa-cli.                                              
    
    if i < 20 and avail cidade-zf 
        and can-find(first wt-it-docto of wt-docto no-lock
                     where wt-it-docto.nat-operacao begins "6") 
        and natur-oper.per-des-icms <> 0 then do:
            assign i = i + 1
                   c-mess[i] = substitute("DESC.ICMS ZFM &1 % = &2",
                                          string(natur-oper.per-des-icms, ">9.99"),
                                          string(TRUNCATE(wt-docto.vl-mercad / de-conv , 2)
                                         - wt-docto.vl-mercad, ">>>>>>9.99")). 
    end.

    if i < 20 and de-tot-icmssubs-obs > 0 then do:
        assign i = i + 1
               c-mess[i] = substitute("ICMS Retido na fonte por Substituicao Tributaria com base: &1  e valor: &2",
                                      STRING(de-tot-bicmssubs-obs, ">>>,>>>,>>9.99"),
                                      STRING(de-tot-icmssubs-obs, ">>>,>>>,>>9.99")).
        if i < 20 then
            if emitente.estado = "MG" then
                assign i = i + 1
                       c-mess[i] = "SUBSTITUTO TRIBUTARIO/MG: 168.363566.0090 REGIME ESPECIAL / PTA: 16.000128134-66".
            else if estabelec.estado = "SP" and emitente.estado  = "SP" then
                assign i = i + 1
                       c-mess[i] = "Valor do ICMS: " + STRING(de-tot-icms-obs, ">>>,>>>,>>9.99").           
    
    end.        
    
    if i < 20 and de-tot-ipi-calc > 0 then
        assign i = i + 1
               c-mess[i] = "Valor do IPI sobre Despesas acessorias..: " + STRING(de-tot-ipi - de-tot-ipi-calc ,">>>>>>>>>9.99").
               
    if i < 20 and can-find(first wt-fat-duplic of wt-docto) THEN DO:
       IF (wt-docto.cidade = "Manaus"          AND wt-docto.estado = "AM") OR
          (wt-docto.cidade = "Tabatinga"       AND wt-docto.estado = "AM") OR
          (wt-docto.cidade = "Guajara-Mirim"   AND wt-docto.estado = "RO") OR
          (wt-docto.cidade = "Epitaciolandia"  AND wt-docto.estado = "AC") OR
          (wt-docto.cidade = "Boa Vista"       AND wt-docto.estado = "RR") OR
          (wt-docto.cidade = "Bonfim"          AND wt-docto.estado = "RR") OR
          (wt-docto.cidade = "Macapa"          AND wt-docto.estado = "AP") OR
          (wt-docto.cidade = "Santana"         AND wt-docto.estado = "AP") OR
          (wt-docto.cidade = "Brasileia"       AND wt-docto.estado = "AC") OR
          (wt-docto.cidade = "Cruzeiro do Sul" AND wt-docto.estado = "AC") THEN DO:    
           assign i = i + 1
                  c-mess[i] = substitute("PIS: &1  -  COFINS: &2",
                                         string((de-acum-vl-merc-ori * 0.0165), ">>>>>>9.99"),
                                         string((de-acum-vl-merc-ori * 0.076), ">>>>>>9.99")).          
        end.
    end.

                                      
    for each tt-class-fis by b-indice:
        if i < 20 then
            assign i = i + 1
                   c-mess[i] = c-mess[i] + String(tt-class-fis.b-indice,"99") + "-" + tt-class-fis.b-cod-class + " ".
    end.
                                      
    if i < 20 then 
        for first tab-ocor NO-LOCK
            where tab-ocor.cod-tab   = 105 
            and   tab-ocor.descricao = estabelec.cod-estabel
            and   tab-ocor.c-campo[1] <> "":
            assign i = i + 1
                   c-mess[i] = "Cod.Repart.Fiscal: " + tab-ocor.c-campo[1].
        end.        
        
    if i < 20 and emitente.insc-subs-trib <> "" then
        assign i = i + 1
               c-mess[i] = "Nao retencao do ICMS ST conforme Regime Especial/Processo n. " + emitente.insc-subs-trib.




            
    put "-------------------- INFORMA€åES ADICIONAIS --------------------" AT 34 SKIP(1).

    do i = 1 to 20:
        if c-mess[i] > "" then
            put c-mess[i] skip.
    
    end.
    
end.
    
{include/i-rpclo.i}

procedure pi-niveis-tributacao:
    def output parameter i-codigo    as integer format "99".
    def output parameter l-sub       as logical init no.
    
    def var l-char1-2 as logical init no.
    def var l-char2-2 as logical init no.
    
    assign l-char1-2 = natur-oper.ind-it-sub-dif
                                               /* variavel logica para cod trib 5 */
           l-char2-2 = natur-oper.ind-it-icms.
                                               /* variavel logica para cod trib 6 */
    
    /*----------------------------------------------------------------------------*/
    
    if  natur-oper.ind-entfut = yes
    and wt-it-imposto.vl-icmsit-e[3] > 0 then do:
        assign i-codigo = 90.
        return.
    end.        
    
    if  l-char1-2 = yes then do:
        assign i-codigo = 50.
        return.
    end.
    else if l-char1-2 = ? then do:  /* Diferido */
            assign i-codigo = 51.
            return.
         end.
         else do:
             if l-char2-2 = yes then do:
                assign i-codigo = 60.
                return.
             end.   
         end.
    
    
    /*----------------------------------------------------------------------------*/
    
    if  wt-it-imposto.cd-trib-icm = 1
    and wt-it-imposto.ind-icm-ret = yes then do:
        assign i-codigo = 10
               l-sub    = yes.
        return.
    end.
    else do:
        if  wt-it-imposto.cd-trib-icm = 1 then do:
            assign i-codigo = 00.
            return.
        end.
    end.
    
    /*----------------------------------------------------------------------------*/
    
    if  wt-it-imposto.cd-trib-icm  = 4
    and wt-it-imposto.ind-icm-ret = yes then do:
        assign i-codigo = 70.
        return.
    end.
    
    /*----------------------------------------------------------------------------*/
    
    if  wt-it-imposto.cd-trib-icm = 4
    and wt-it-imposto.ind-icm-ret = no then do:
        assign i-codigo = 20.
        return.
    end.
    
    /*----------------------------------------------------------------------------*/
    
    if  wt-it-imposto.cd-trib-icm = 2
    and wt-it-imposto.ind-icm-ret = yes then do:
        assign i-codigo = 30
               l-sub    = yes.
        return.
    end.
    else do:
        if  wt-it-imposto.cd-trib-icm = 2 then do:
            assign i-codigo = 40 + int(natur-oper.ind-tipo-vat = yes).
            return.
        end.
    end.
    
    /*---------------------------------------------------------------------------*/
    
    if  wt-it-imposto.cd-trib-icm = 3 then do:
        assign i-codigo = 90.
        return.
    end.


end procedure.

PROCEDURE pi-calcula-volumes.

   def var i-nr-volumes    as int.
   def var i-tmp           as int.
   def var ind             as int.
   def var de-tmp          as dec format "99.999999999".
   def var de-vol-tmp      as dec.
   def var de-tmp-acum     as dec format "99.999999999".

   DEF VAR lItemBranco     AS LOGICAL    NO-UNDO.
   DEF VAR iNrVol          LIKE volume-nf.nr-volume NO-UNDO.
   DEF VAR i-vol-exp       AS INTEGER      NO-UNDO.
   DEF VAR i-nr-vol-aux    AS INTEGER      NO-UNDO INITIAL 0.
   def var i-proximo-vol   as inte no-undo init 1.

   assign i-nr-volumes = 0.

   for each tt-resto:
       delete tt-resto.
   end.
   
   for each wt-it-docto of wt-docto NO-LOCK 
       where not wt-it-docto.it-codigo begins "servico",
       first item FIELDS(comprim largura altura peso-bruto peso-liq) NO-LOCK 
             where item.it-codigo = wt-it-docto.it-codigo
       break by wt-it-docto.it-codigo:

       if not wt-it-docto.it-codigo begins "4" or
          wt-docto.nome-transp = "MALOTE" then do:
          ASSIGN lItemBranco = YES.
          NEXT.
       end.

       IF wt-docto.nat-operacao BEGINS "7" THEN
           find first item-caixa no-lock
                where item-caixa.sigla-emb BEGINS "e"
                  and item-caixa.it-codigo = wt-it-docto.it-codigo 
                  AND item-caixa.fm-cod-com = ?
                  AND item-caixa.fm-codigo  = ? no-error.
       ELSE 
           find first item-caixa no-lock
                where item-caixa.sigla-emb = "cx"
                  and item-caixa.it-codigo = wt-it-docto.it-codigo 
                  AND item-caixa.fm-cod-com = ?
                  AND item-caixa.fm-codigo  = ? no-error.

       if item.comprim = 0 or item.largura = 0 or item.altura = 0 then do:
          if avail item-caixa then do:
             assign i-tmp = trunc(wt-it-docto.quantidade[1] / item-caixa.qt-item,0).
             if wt-it-docto.quantidade[1] mod item-caixa.qt-item > 0 then
                assign i-tmp = i-tmp + 1.

             do ind = i-proximo-vol to (i-proximo-vol + i-tmp) - 1:
                 /* gera etiquetas dos itens da estrutura para as centrais */
                IF item-caixa.qt-item = 0.5 AND ind MOD 2 = 0 THEN DO:
                   FOR EACH estrutura NO-LOCK
                       WHERE estrutura.it-codigo = wt-it-docto.it-codigo
                       AND   estrutura.data-inicio <= TODAY
                       AND   estrutura.data-termino >= TODAY
                       AND   NOT estrutura.es-codigo BEGINS "43":
                       find first tt-volume-nf
                          where tt-volume-nf.cod-estabel  = wt-docto.cod-estabel
                             and tt-volume-nf.serie       = wt-docto.serie
                             and tt-volume-nf.it-codigo   = estrutura.es-codigo
                             and tt-volume-nf.nr-volume   = ind no-error.
                      if not avail tt-volume-nf then do:
                         create tt-volume-nf.
                         assign tt-volume-nf.cod-estabel = wt-docto.cod-estabel
                                tt-volume-nf.serie       = wt-docto.serie
                                tt-volume-nf.it-codigo   = estrutura.es-codigo
                                tt-volume-nf.nr-volume   = ind.
                      end.
                      assign tt-volume-nf.qtde = estrutura.quant-usada
                             tt-volume-nf.varios-itens = YES
                             tt-volume-nf.sigla-emb = item-caixa.sigla-emb.
                   END.
                END.
                ELSE DO:
                     find first tt-volume-nf
                        where tt-volume-nf.cod-estabel  = wt-docto.cod-estabel
                           and tt-volume-nf.serie       = wt-docto.serie
                           and tt-volume-nf.it-codigo   = wt-it-docto.it-codigo
                           and tt-volume-nf.nr-volume   = ind no-error.
                    if not avail tt-volume-nf then do:
                       create tt-volume-nf.
                       assign tt-volume-nf.cod-estabel = wt-docto.cod-estabel
                              tt-volume-nf.serie       = wt-docto.serie
                              tt-volume-nf.it-codigo   = wt-it-docto.it-codigo
                              tt-volume-nf.nr-volume   = ind.
                    end.
                    assign tt-volume-nf.qtde = if ind = (i-proximo-vol + i-tmp) - 1 and
                                               wt-it-docto.quantidade[1] mod item-caixa.qt-item > 0 then
                                               wt-it-docto.quantidade[1] mod item-caixa.qt-item
                                            else
                                               item-caixa.qt-item.
                    ASSIGN tt-volume-nf.sigla-emb  = item-caixa.sigla-emb.
                END.
             end.
             assign i-proximo-vol = i-proximo-vol + i-tmp.
          end.  /**** avail item caixa dentro do comprim, altura, largura = 0 ****/
          else do:
              find first tt-resto 
                   where tt-resto.it-codigo = wt-it-docto.it-codigo no-error.
              if not avail tt-resto then do:
                 create tt-resto.
                 assign tt-resto.it-codigo = wt-it-docto.it-codigo.
              end.
              ASSIGN tt-resto.qtde = wt-it-docto.quantidade[1].
          end. 
       END. /*** comprim, largura, altura = 0 ****/
       else do:
          find first tt-resto 
               where tt-resto.it-codigo = wt-it-docto.it-codigo no-error.
          if not avail tt-resto then do:
             create tt-resto.
             assign tt-resto.it-codigo = wt-it-docto.it-codigo.
          end.

          if avail item-caixa then do:
             if wt-it-docto.quantidade[1] >= item-caixa.qt-item then do:
                assign i-tmp = trunc(wt-it-docto.quantidade[1] / item-caixa.qt-item,0)
                       tt-resto.qtde = tt-resto.qtde +
                                       wt-it-docto.quantidade[1] MOD item-caixa.qt-item.
                do ind = i-proximo-vol to (i-proximo-vol + i-tmp) - 1:
                    IF item-caixa.qt-item = 0.5 AND ind MOD 2 = 0 THEN DO:
                       FOR EACH estrutura NO-LOCK
                           WHERE estrutura.it-codigo = wt-it-docto.it-codigo
                           AND   estrutura.data-inicio <= TODAY
                           AND   estrutura.data-termino >= TODAY
                           AND   NOT estrutura.es-codigo BEGINS "43":
                           find first tt-volume-nf 
                              where tt-volume-nf.cod-estabel = wt-docto.cod-estabel
                              AND   tt-volume-nf.serie       = wt-docto.serie
                              AND   tt-volume-nf.it-codigo   = estrutura.es-codigo
                              AND   tt-volume-nf.nr-volume   = ind no-error.
                          if not avail tt-volume-nf then do:
                             create tt-volume-nf.
                             assign tt-volume-nf.cod-estabel = wt-docto.cod-estabel
                                    tt-volume-nf.serie       = wt-docto.serie
                                    tt-volume-nf.it-codigo   = estrutura.es-codigo   
                                    tt-volume-nf.nr-volume   = ind no-error.       
                          END.
                          assign tt-volume-nf.qtde = estrutura.quant-usada
                                 tt-volume-nf.sigla-emb = item-caixa.sigla-emb
                                 tt-volume-nf.varios-itens = YES.
                       END.
                    END.
                    ELSE DO:
                       find first tt-volume-nf 
                            where tt-volume-nf.cod-estabel = wt-docto.cod-estabel
                              and tt-volume-nf.serie       = wt-docto.serie
                              and tt-volume-nf.it-codigo   = wt-it-docto.it-codigo
                              and tt-volume-nf.nr-volume   = ind no-error.
                       if not avail tt-volume-nf then do:
                          create tt-volume-nf.
                          assign tt-volume-nf.cod-estabel = wt-docto.cod-estabel
                                 tt-volume-nf.serie       = wt-docto.serie
                                 tt-volume-nf.it-codigo   = wt-it-docto.it-codigo
                                 tt-volume-nf.nr-volume   = ind.
                       end.
                       assign tt-volume-nf.qtde      = item-caixa.qt-item
                              tt-volume-nf.sigla-emb = item-caixa.sigla-emb.
                    END.
                end.
                assign i-proximo-vol = i-proximo-vol + i-tmp.
             end.
             else do:
                assign tt-resto.qtde = tt-resto.qtde + wt-it-docto.quantidade[1].
             end.
          end. /**** AVAIL ITEM-CAIXA *******/
          else do:
              ASSIGN tt-resto.qtde = wt-it-docto.quantidade[1].
          END.
       END. /***** ELSE DO ALTURA, LARGURA E COMPRIMENTO = 0 ********/
   END.

   assign de-tmp = 0
          de-tmp-acum = 0
          ind = 0.

   /**** pega a maior caixa  E COLOCO C-EMB-ESCOLHIDA EM BRANCO POIS
         S… VOU SABER QUAL CAIXA QUERO AP…S SABER QUAIS OS ITENS QUE
         V€O NA CAIXA. USO A MAIOR CAIXA COMO REFERENCIAL INICIAL SOMENTE.
         O CAMPO EMITE-ROMAN IDENTICA QUAIS EMBALAGENS EST€O LIBERADAS
         NA UTILIZA?€O PARA COMPARTILHAR ITENS  ****/
   
   IF wt-docto.nat-operacao BEGINS "7" THEN DO:
      FOR EACH embalag NO-LOCK
          WHERE embalag.embalagem BEGINS "EMB"
          AND   embalag.emite-roman 
          BREAK BY embalag.volume:
          ASSIGN c-emb-escolhida = embalag.sigla-emb.
      END.
   END.
   ELSE 
       find first embalag no-lock
            where embalag.sigla-emb = "cx" no-error.

   for each tt-resto where tt-resto.qtde <> 0,
       first ITEM FIELDS(it-codigo comprim largura altura peso-bruto peso-liq)
             where item.it-codigo = tt-resto.it-codigo
       BREAK BY tt-resto.it-codigo
             BY tt-resto.qtde:


       assign de-tmp = (item.comprim / 1000) * (item.largura / 1000) *
                       (item.altura / 1000)  * tt-resto.qtde.

       if de-tmp > embalag.volume * 0.85 then do:
           /* ASSIGN i-proximo-vol = i-proximo-vol + 1. */

          find first tt-volume-nf
               where tt-volume-nf.cod-estabel = wt-docto.cod-estabel
                 and tt-volume-nf.serie       = wt-docto.serie
                 and tt-volume-nf.it-codigo   = item.it-codigo
                 and tt-volume-nf.nr-volume   = i-proximo-vol no-error.

          if not avail tt-volume-nf then do:
             create tt-volume-nf.
             assign tt-volume-nf.cod-estabel = wt-docto.cod-estabel
                    tt-volume-nf.serie       = wt-docto.serie
                    tt-volume-nf.it-codigo   = item.it-codigo
                    tt-volume-nf.nr-volume = i-proximo-vol
                    tt-volume-nf.varios-itens = yes.
          end.
          assign tt-volume-nf.qtde       = tt-resto.qtde
                 tt-volume-nf.sigla-emb  = ""
                 i-proximo-vol = i-proximo-vol + 1
                 de-tmp = 0
                 de-tmp-acum = 0.

          RUN pi-grava-embalagem.

       end.
       else do:

          assign de-tmp-acum = de-tmp-acum + de-tmp
                 ind = ind + 1.

          if de-tmp-acum > embalag.volume * 0.85 or ind > 6 then do:

             RUN pi-grava-embalagem.

             assign i-proximo-vol = i-proximo-vol + 1
                    de-tmp-acum = de-tmp
                    ind = 0.
          end.

          /*** Se for o ultimo item dos restos, procura uma caixa de tamanho
               suficiente para caber o que sobrou do resto ****/
          IF LAST(tt-resto.qtde) THEN DO:
             ASSIGN de-tmp = 99.
             IF wt-docto.nat-operacao BEGINS "7" THEN DO:
                 FOR EACH embalag NO-LOCK
                     WHERE embalag.embalagem BEGINS "emb"
                     AND   embalag.emite-roman
                     BY embalag.volume:
                     IF de-tmp-acum - embalag.volume * 0.85 < 0 THEN DO:
                        ASSIGN de-tmp          = de-tmp-acum - embalag.volume
                               c-emb-escolhida = embalag.sigla-emb.
                        LEAVE.
                     END.
                 END.
             END.
          END.

          find first tt-volume-nf
               where tt-volume-nf.cod-estabel = wt-docto.cod-estabel
                 and tt-volume-nf.serie       = wt-docto.serie
                 and tt-volume-nf.it-codigo   = item.it-codigo
                 and tt-volume-nf.nr-volume   = i-proximo-vol no-error.

          if not avail tt-volume-nf then do:
             create tt-volume-nf.
             assign tt-volume-nf.cod-estabel = wt-docto.cod-estabel
                    tt-volume-nf.serie       = wt-docto.serie
                    tt-volume-nf.it-codigo   = item.it-codigo
                    tt-volume-nf.nr-volume   = i-proximo-vol
                    tt-volume-nf.varios-itens = yes.
          end.
          assign  tt-volume-nf.qtde      = tt-resto.qtde
                  tt-volume-nf.sigla-emb = "".
       end.
   end.

   RUN pi-grava-embalagem.

   IF lItemBranco THEN DO:
       find last tt-volume-nf
            where tt-volume-nf.cod-estabel = wt-docto.cod-estabel 
              and tt-volume-nf.serie       = wt-docto.serie no-error.
       IF AVAIL tt-volume-nf THEN
            ASSIGN iNrVol = tt-volume-nf.nr-volume + 1.
       ELSE ASSIGN iNrVol = 1.

       create tt-volume-nf.
       assign tt-volume-nf.cod-estabel = wt-docto.cod-estabel
              tt-volume-nf.serie       = wt-docto.serie
              tt-volume-nf.it-codigo   = ""
              tt-volume-nf.nr-volume   = iNrVol.
   END.
END PROCEDURE.

PROCEDURE Pi-grava-embalagem.
    /**** O FOR EACH ABAIXO ATUALIZA A EMBALAGEM NOS VOLUMES QUE N€O
          TINHA SIDO IDENTIFICADO O TAMANHO DA MESMA ***********/
    FOR EACH tt-volume-nf
        where tt-volume-nf.cod-estabel = wt-docto.cod-estabel
        and   tt-volume-nf.serie       = wt-docto.serie
        AND   tt-volume-nf.sigla-emb   = "":
        ASSIGN tt-volume-nf.sigla-emb = c-emb-escolhida.
    END.
END PROCEDURE.
