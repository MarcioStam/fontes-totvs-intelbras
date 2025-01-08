/***********************************************************************
**  Programa..: ESP\CCP\ESDPP003RP.P
**  Autor.....: Anderson Silvano
**  Data......: Setembro/2005 - Desenvolvimento
**  Descricao.:  - Individual
**  Vers∆o....: 001 15/09/2005
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESDPP003 2.04.00.000}

/****************************  Definitions  ****************************/

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD l-rodape         AS LOG 
    FIELD i-fabric         AS INTEGER
    FIELD l-imp-obsoleto   AS LOG
    FIELD c-endereco       AS CHAR FORMAT "x(60)"
    FIELD c-html-contato   AS CHAR FORMAT "x(60)"
    FIELD c-html-fornec    AS CHAR FORMAT "x(60)"
    FIELD l-html           AS LOG
    FIELD i-lingua         AS INTEGER. 

define temp-table tt-digita no-undo
    field it-codigo    like item.it-codigo
    field cod-emitente like emitente.cod-emitente
    index id it-codigo.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

def temp-table tt-rec
    field seq              as int 
    field descricao        as char extent 2
    index codigo is primary seq.

def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

def var c-titulo        as char.

def var c-familia       like familia.descricao.
def var ci-familia      like familia.descricao.
def var c-desenho       as char format "x(20)".
def var c-fab-inf       as char format "x(15)".
def var c-amostragem    as char format "x(48)".
def var c-acond         as char format "x(48)".
def var ci-fab-inf      as char format "x(15)".
def var ci-amostragem   as char format "x(48)".
def var ci-acond        as char format "x(48)".
def var i-versao        like it-carac-tec.vl-result.
def var da-versao       like it-carac-tec.dt-result.
def var c-responsavel   as char format "x(25)".
DEF VAR i-cont          AS INT.
DEF VAR c-linha         AS CHAR FORMAT "x(140)".

{esapi/esapi010tt.i}
{include/i-rpvar.i}
{esp/es0006a.i}
{esp/es0006.i}
{utp/ut-glob.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

{include/tt-edit.i}

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
     create tt-digita.
     raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. 

def var h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Ficha de Caracter°sticas TÇcnicas"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESENP003"
       c-versao       = "2.04"
       c-revisao      = "000".

DEF VAR c-it-fabric AS CHAR FORMAT "x(60)" NO-UNDO.

DEF STREAM shtml.                                                                        

/* **************************** Frames ********************************* */

form header
     fill("_", 80) format "x(80)"
     with row 20 column 1 no-labels no-box attr-space frame f-traco STREAM-IO.
form 
     "Aprovado por: ________________ Assinatura do Aprovador :___________________"   
     with page-bottom no-label frame f-rodape2 STREAM-IO.

form header
     "Intelbras S/A     Condiá‰es TÇcnicas de Recebimento / Technical Receiving Conditions  " at 01
     "Pagina/Page: " at 108
     page-number format ">>9"
     TODAY   format "99/99/99" at 125
     fill("-",132)  format "x(132)"    at 01
     with width 135 page-top no-labels frame f-cab1 STREAM-IO.

form header
     "Item     Descricao                                       Ver"             at 01
     "        Data"                                           
     "Fab. Inferior  Amostragem"                                                at 01
     "Acondicionamento"                                                         at 01
     "Desenhos"                                                                 at 01
      "Fabricante            Item do Fabricante                    Referencia " at 01
     "Informacoes Adicionais"                                                   at 01                                                  
     fill("-",80)  format "x(80)"                                               at 01
     with width 82 page-top frame f-cab2 STREAM-IO.

form "Item     Descricao                                       Ver"             at 01
     "        Data"                                           
     "Fab. Inferior  Amostragem"                                                at 01
     "Acondicionamento"                                                         at 01
     "Desenhos"                                                                 at 01
      "Fabricante            Item do Fabricante                    Referencia " at 01
     "Informacoes Adicionais"                                                   at 01                                                                                                            
     "-------------------------------------------------------------------------------" at 01
     with width 82 frame f-cab2a STREAM-IO.

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    if tt-param.l-rodape then 
        view frame f-rodape2.

    run utp/ut-acomp.p persistent set h-acomp.  

    run pi-inicializar in h-acomp (input "Imprimindo...").

    run piImprimeRelat.

    {include/i-rpclo.i}

    IF tt-param.l-html THEN 
        RUN piGeraHtml.

    run pi-finalizar in h-acomp.
    
    RETURN "OK".
end.

PROCEDURE piImprimeRelat:

    VIEW FRAME f-cab1.   
    
    for each tt-digita no-lock,
        each item  no-lock
        where item.it-codigo = tt-digita.it-codigo
        break by tt-digita.cod-emitente
              by item.fm-codigo
              by item.it-codigo:
    
        RUN pi-acompanhar IN h-acomp ("Gerando Item: " + ITEM.it-codigo).

        find int-item of item no-lock no-error.
        if not avail int-item then do:
            create int-item.
            assign int-item.it-codigo = item.it-codigo.
            find current int-item no-lock.
        end.
    
        if first-of(item.fm-codigo) then do:
           hide frame f-cab2 no-pause.
           find first familia
                where familia.fm-codigo = item.fm-codigo
                      no-lock no-error.
           assign c-familia = item.fm-codigo + " - " + familia.descricao.
    
           if avail familia then do:
               find int-familia of familia no-lock no-error.
               if not avail int-familia then do:
                    create int-familia.
                    assign int-familia.fm-codigo = familia.fm-codigo.
                    find current int-familia no-lock.
               end.
               assign  ci-familia = item.fm-codigo + " - " + int-familia.desc-ingles.
           end.
    
           for each tt-rec:
             delete tt-rec.
           end.
           assign i-cont = 0.
           for each comp-folh use-index  seq-impr
              where comp-folh.cd-folha = substring(item.fm-codigo,1,3) no-lock:
              assign i-cont = i-cont + 1.
              create tt-rec.
              assign tt-rec.seq = i-cont 
                     tt-rec.descricao[1] = comp-folh.descricao .
           end.   
    
           assign i-cont = 0.
           for each comp-folh use-index  seq-impr
              where comp-folh.cd-folha = "100" + substring(item.fm-codigo,1,3) 
              no-lock:
              assign i-cont = i-cont + 1.
              find tt-rec where tt-rec.seq = i-cont no-error.
              if avail tt-rec then assign tt-rec.descricao[2] = comp-folh.descricao.
              else do:   
                 create tt-rec.
                 assign tt-rec.seq = i-cont
                        tt-rec.descricao[2] = comp-folh.descricao.
              end.
           end.   
        end.   
    
        if tt-param.l-imp-obsoleto 
        or item.cod-obsoleto = 1 then do:
    
           assign c-desenho     = ""
                  c-fab-inf     = ""
                  c-amostragem  = ""
                  c-acond       = ""
                  ci-fab-inf    = ""
                  ci-amostragem = ""
                  ci-acond      = ""
                  i-versao      = 0
                  da-versao     = date("  /  /    ").
    
           view frame f-cabecalho.
           for each it-carac-tec no-lock
               where it-carac-tec.it-codigo = item.it-codigo:
    
               CASE it-carac-tec.tipo-result:
                   WHEN 1 THEN ASSIGN i-versao      = it-carac-tec.vl-result.
                   WHEN 6 THEN ASSIGN da-versao     = it-carac-tec.dt-result.
                   WHEN 4 THEN ASSIGN c-responsavel = it-carac-tec.observacao.
               END CASE.
           end.
    
           if c-responsavel <> "" then do:
               find usuar_mestre no-lock
                   where usuar_mestre.cod_usuario = c-responsavel no-error.
               if avail usuar_mestre then assign c-responsavel = usuar_mestre.nom_usuario.
           end.
    
           for each it-res-carac no-lock
              where it-res-carac.it-codigo = item.it-codigo:
              if it-res-carac.nr-tabela <> 0 then do:
                 find c-tab-res 
                    where c-tab-res.nr-tabela = it-res-carac.nr-tabela
                      and c-tab-res.sequencia = it-res-carac.sequencia
                        no-lock no-error.
                 if avail c-tab-res then do:
                     CASE it-res-carac.nr-tabela:
                         WHEN 1 THEN ASSIGN c-fab-inf    = c-tab-res.descricao.
                         WHEN 4 THEN ASSIGN c-acond      = c-tab-res.descricao.
                         WHEN 3 THEN ASSIGN c-amostragem = c-tab-res.descricao.
                     END CASE.
                 END.
              END.
           END.
    
          /* novo calculo de fabricacao inferior utilizando parametro cadastrado na familia via es0733. */
    
           find int-familia of familia no-lock no-error.
    
           if not avail int-familia then do:
                create int-familia.
                assign int-familia.fm-codigo = familia.fm-codigo.
                find current int-familia no-lock.
           end.
    
           assign c-fab-inf  = string(int-familia.meses-validade) + " Meses" .
                  ci-fab-inf = string(int-familia.meses-validade) + " Months".
    
           /* atualiza variaveis com dados em ingles */
    
           for each it-res-carac no-lock
              where it-res-carac.it-codigo = item.it-codigo:
              if it-res-carac.nr-tabela <> 0 then do:
                 find c-tab-res 
                    where c-tab-res.nr-tabela = it-res-carac.nr-tabela * 100
                      and c-tab-res.sequencia = it-res-carac.sequencia
                        no-lock no-error.
                 if avail c-tab-res then do:
                    CASE it-res-carac.nr-tabela:
                        WHEN 1 THEN ASSIGN ci-fab-inf = c-tab-res.descricao.
                        WHEN 4 THEN ASSIGN ci-acond   = c-tab-res.descricao.
                        WHEN 3 THEN ASSIGN ci-amostragem = c-tab-res.descricao.
                    END CASE.
                 END.
              END.
           END.
    
           /* novo calculo de fabricacao inferior utilizando parametro cadastrado na ~familia via es0733. */
    
           find int-familia of familia no-lock no-error.
           if not avail int-familia then do:
                create int-familia.
                assign int-familia.fm-codigo = familia.fm-codigo.
                find current int-familia no-lock.
           end.
    
           assign c-fab-inf  = string(int-familia.meses-validade) + " Meses" .
                  ci-fab-inf = string(int-familia.meses-validade) + " Months".
    
           IF LINE-COUNTER + 6 > PAGE-SIZE then do:
              page.
           end.     
           assign c-linha                  = fill("-",132)
                  substring(c-linha,1,1)   = "+"
                  substring(c-linha,28,1)  = "+"
                  substring(c-linha,80,1)  = "+"
                  substring(c-linha,132,1) = "+".
    
           put c-linha format "x(135)" skip
              "|                          |          Portugues "
              "|              English " at 80 
              "|"                       at 132 skip
              c-linha format "x(135)" skip.
    
           put "| Familia/Family           | " 
               c-familia
               "| "                     at 80 
               ci-familia
               "|"                      at 132 skip
               c-linha format "x(135)" skip.
    
           for each tt-rec break by tt-rec.seq.
    
              put if first(tt-rec.seq) then 
                  "| Rotina /Receive Routine  | " else
                  "|                          | " format "x(29)"
                  tt-rec.descricao[1] format "x(50)" "| " at 80
                  tt-rec.descricao[2] format "x(50)" "| " at 132 skip.
           end.
    
           put c-linha format "x(135)" skip.
    
           put "| Item/Item                | " 
               item.it-codigo               format "x(7)"
               "| "                         at 80
               item.it-codigo               format "x(7)" 
               "|"                          at 132 skip
               c-linha                      format "x(132)" skip
               "| Descricao/Description    | " 
               item.desc-item               FORMAT "x(50)"
               "| "                         at 80 
               if item.desc-inter <> "" 
               THEN item.desc-inter 
               ELSE item.desc-item format "x(36)"
               "|"                          at 132 skip
               c-linha                      format "x(132)" skip
               /*"| NCM / Ex Tarifario       | " 
               item.class-fiscal " / "                                           
               string(int-item.ex-tarifario,">>>")
               "| "                         at 80 
               "|"                          at 132 skip
               c-linha                      format "x(132)" skip*/  .
    
           /*if int-item.nve <> "" then 
               put "| NVE                      | " int-item.nve format "x(50)"
                   "| "                     at 80 
                   "|"                      at 132 skip
                   c-linha format "x(135)"  skip.*/
    
           put "| Versao,Data/Version,Date | " 
               i-versao                     format ">>9" 
               " - " 
               da-versao
               "| "                         at 80 
               i-versao                     FORMAT ">>9" 
               " - "  
               month(da-versao)             format "99"
               "/" 
               day(da-versao)               format "99"
               "/"
               year(da-versao)              format "9999"
               "|"                          at 132          skip
               c-linha                      format "x(132)" skip
               "| Responsavel/Responsible  | " 
               c-responsavel 
               "| "                         at 80 
               c-responsavel                   
               "|"                          at 132          skip
               c-linha                      format "x(132)" skip
               "| Fabr. Inferior/Validity  | " 
               c-fab-inf    
               "| "                         at 80 
               ci-fab-inf 
               "|"                          at 132          skip
               c-linha                      format "x(132)" skip
               "| Amostragem               | " 
               c-amostragem 
               "|"                          at 80 
               "|"                          at 132 skip
               c-linha                      format "x(132)" skip
               "| Acondicionamento/Packing | " 
               c-acond 
               "| "                         AT 80
               ci-acond 
               "|"                          AT 132 skip
               c-linha                      format "x(132)" skip.
    
           for each desenho-item 
              where desenho-item.it-codigo = item.it-codigo
                 no-lock break by desenho-item.it-codigo:
    
              put if first-of(desenho-item.it-codigo) 
                               then "| Desenhos/Drawing         | " 
                               else "|                          | " format "x(29)"
                     desenho-item.de-codigo format "x(13)".
    
              find last revisao no-lock
                 where revisao.de-codigo = desenho-item.de-codigo no-error.
              if avail revisao  then
                    put " " 
                        revisao.rv-codigo   format "xx"
                        " " 
                        substring(string(year(revisao.data-revisao),"9999"),3,2) format "99".
    
              put "|" at 80
                  desenho-item.de-codigo    format "x(13)".
    
              if avail revisao  then
                    put " " 
                        revisao.rv-codigo   format "xx"
                        " " 
                        substring(string(year(revisao.data-revisao),"9999"),3,2) format "99".
              
              put "|" at 132 skip. 
              
              if last-of(desenho-item.it-codigo) then 
                    put c-linha format "x(132)" skip.
           end.
    
           for each item-fabric 
               where item-fabric.it-codigo = item.it-codigo
               no-lock
               break by item-fabric.cod-fabric:

               ASSIGN c-it-fabric = ITEM-fabric.it-fabric.

               find fabricante 
                    where fabricante.cod-fabric = item-fabric.cod-fabric no-lock no-error.
               put "| Fabricante/Manufacturer  | " 
                   fabricante.cod-fabric 
                   if tt-param.i-fabric = 1 then " - " + fabricante.nome 
                                            else "" format "x(20)"
                   "| "             at 80 
                   fabricante.cod-fabric 
                   "|"              at 132 skip
                   "|      Item/Item           | "
                   c-it-fabric FORMAT "x(50)"
                   "| "             at 80 
                   c-it-fabric FORMAT "x(50)"
                   "|"              at 132 skip
                   c-linha          format "x(132)" skip. 
           end.
    
           for each it-msg-carac no-lock
              where it-msg-carac.it-codigo = item.it-codigo break by it-msg-carac.it-codigo:

                run pi-print-editor (it-msg-carac.msg-exp, 78).

                FOR EACH tt-editor:
                    PUT  IF tt-editor.linha = 1 
                         AND FIRST-OF(it-msg-carac.it-codigo)
                         then   "| Inf.Adicion/General Inf. | "
                         else   "|                          | " format "x(29)".

                    PUT tt-editor.conteudo
                        "| "                        at 80
                        tt-editor.conteudo
                        "|"                         AT 132 SKIP.
                END.

                if last-of(it-msg-carac.it-codigo) then       
                    put c-linha format "x(132)" skip.
           end.
    
           put "" at 01 skip.
    
           page.
    
        end.
    end.

    output  close.
END.

procedure piGeraHtml.
    assign c-arquivo = c-dir-arquivo-session + "ctr-html.html".
   
   for each tt-digita no-lock,
       each item  no-lock
      where item.it-codigo = tt-digita.it-codigo
      break by tt-digita.cod-emitente
            by item.fm-codigo
            by item.it-codigo:

        RUN pi-acompanhar IN h-acomp ("Gerando HTML Item: " + ITEM.it-codigo).

        find int-item of item no-lock no-error.
        if not avail int-item then do:
            create int-item.
            assign int-item.it-codigo = item.it-codigo.
            find current int-item no-lock.
      
        end.

       if first-of(item.fm-codigo) then do:
          find first familia
               where familia.fm-codigo = item.fm-codigo no-lock no-error.
               
          assign c-familia = item.fm-codigo + " - " + familia.descricao.
    
          if avail familia then do:
              find int-familia of familia no-lock no-error.
              if not avail int-familia then do:
                   create int-familia.
                   assign int-familia.fm-codigo = familia.fm-codigo.
                   find current int-familia no-lock.
              end.
              assign  ci-familia = item.fm-codigo + " - " + int-familia.desc-ingles.
          end.
          
          for each tt-rec:
              delete tt-rec.
          end.
          assign i-cont = 0.
          for each comp-folh use-index  seq-impr
             where comp-folh.cd-folha = substring(item.fm-codigo,1,3)
             no-lock:
             assign i-cont = i-cont + 1.
             create tt-rec.
             assign tt-rec.seq = i-cont 
                    tt-rec.descricao[1] = comp-folh.descricao .
          end.   
         
          assign i-cont = 0.
          for each comp-folh use-index  seq-impr
             where comp-folh.cd-folha = "100" + substring(item.fm-codigo,1,3) 
             no-lock:
             assign i-cont = i-cont + 1.
             find tt-rec where tt-rec.seq = i-cont no-error.
             if avail tt-rec then assign tt-rec.descricao[2] = comp-folh.descricao.
             else do:   
                create tt-rec.
                assign tt-rec.seq = i-cont
                       tt-rec.descricao[2] = comp-folh.descricao.
             end.
          end.   
       end.   
       if first-of(item.it-codigo) then do:
            output to value(c-arquivo).
    
            if tt-param.i-lingua = 1 then do:
                run html-inicio("Condicoes Tecnicas de Recebimento").
                assign c-titulo = "Condicoes Tecnicas de Recebimento do Item: " + item.it-codigo + "-" + item.desc-item.
                run html-titulo(c-titulo).
            end.
            else do:
                run html-inicio("Technical Specification to Receiving").
                assign c-titulo = "Technical Specification to Receiving Item: " + item.it-codigo + "-" + item.desc-item.
                run html-titulo(c-titulo).
            end.
            if tt-param.i-lingua = 1 then 
            assign c-texto-html[1]  = "Sao Jose - SC"  + " - " + string(today,"99/99/9999")
                   c-texto-html[3]  = "Para: " + c-html-fornec
                   c-texto-html[4]  = " At.: " + c-html-contato
                   c-texto-html[6]  = "Ref.: Condicao Tecnica de Recebimento Atualizada para o item: " + item.it-codigo + " - " + item.desc-item
                   c-texto-html[8]  = "Prezados Senhores,"
                   c-texto-html[10] = "Estamos encaminhando em anexo nossa condicao tecnica de recebimento atualizada."
                   c-texto-html[11] = "Para nosso controle, solicitamos que efetuem retorno deste documento, por correios, fax ou e-mail"
                   c-texto-html[12] = "no prazo de 10 dias uteis. "
                   c-texto-html[13] = "Estamos a disposicao para quaisquer esclarecimentos."
                   c-texto-html[15] = ""
                   c-texto-html[16] = "Departamento de Compras"
                   c-texto-html[18] = "Recebemos em ___/___/___"
                   c-texto-html[19] = "Nome:___________________"
                   c-texto-html[20] = "Assinatura:_____________".
           
            else 
            assign c-texto-html[1] = "Sao Jose - SC"  + " - " + 
                                     string(month(today),"99") + "/" + string(day(today),"99") + "/" + string(year(today),"9999")
                   c-texto-html[3] = "To: " + c-html-fornec
                   c-texto-html[4] = " Att.: " + c-html-contato
                   c-texto-html[6] = "Subject:  Technical Specification to receiving item: " +  item.it-codigo + " - " + item.descricao-1 + item.descricao-2
                   c-texto-html[8] = "Dear Reader,"
                   c-texto-html[10] = "Please find attached our technical especification to receiving current items."
                   c-texto-html[11] = "It is necessary resend this document by post mail, fax or e-mail"
                   c-texto-html[12] = " up to 10 days after receiving it."
                   c-texto-html[13] = "If you have any inquire, we are avaliable to clarify your question."
                   c-texto-html[15] = ""
                   c-texto-html[16] = "Purchasing department"                                       
                   c-texto-html[18] = "Received on  ___/___/___"
                   c-texto-html[19] = "Name:___________________"
                   c-texto-html[20] = "Signature:_____________".
       end.
   
       if l-imp-obsoleto 
       or item.cod-obsoleto = 1 then do:
 
          assign c-desenho     = ""
                 c-fab-inf     = ""
                 c-amostragem  = ""
                 c-acond       = ""
                 ci-fab-inf    = ""
                 ci-amostragem = ""
                 ci-acond      = ""
                 i-versao      = 0
                 da-versao     = date("  /  /    ").
          view frame f-cabecalho.
          for each it-carac-tec no-lock
              where it-carac-tec.it-codigo = item.it-codigo:
              CASE it-carac-tec.tipo-result:
                  WHEN 1 THEN ASSIGN i-versao = it-carac-tec.vl-result.
                  WHEN 6 THEN ASSIGN da-versao =  it-carac-tec.dt-result.
                  WHEN 4 THEN ASSIGN c-responsavel =  it-carac-tec.observacao.
              END CASE.
          end.
          
          if c-responsavel <> "" then do:
              find usuar_mestre no-lock
                  where usuar_mestre.cod_usuario = c-responsavel no-error.
              if avail usuar_mestre then assign c-responsavel = usuar_mestre.cod_usuario.
          end.
    
          for each it-res-carac no-lock
             where it-res-carac.it-codigo = item.it-codigo:
             if it-res-carac.nr-tabela <> 0 then do:
                find c-tab-res 
                   where c-tab-res.nr-tabela = it-res-carac.nr-tabela
                     and c-tab-res.sequencia = it-res-carac.sequencia
                       no-lock no-error.
                if avail c-tab-res then do:
                    CASE it-res-carac.nr-tabela:
                        WHEN 1 THEN ASSIGN c-fab-inf    = c-tab-res.descricao.
                        WHEN 4 THEN ASSIGN c-acond      = c-tab-res.descricao.
                        WHEN 3 THEN ASSIGN c-amostragem = c-tab-res.descricao.
                    END CASE.
                end.
             end.
          end.

          
          /* atualiza variaveis com dados em ingles */

          for each it-res-carac no-lock
             where it-res-carac.it-codigo = item.it-codigo:
             if it-res-carac.nr-tabela <> 0 then do:
                find c-tab-res 
                   where c-tab-res.nr-tabela = it-res-carac.nr-tabela * 100
                     and c-tab-res.sequencia = it-res-carac.sequencia
                       no-lock no-error.
                if avail c-tab-res then do:
                    CASE it-res-carac.nr-tabela:
                        WHEN 1 THEN ASSIGN ci-fab-inf = c-tab-res.descricao.
                        WHEN 4 THEN ASSIGN ci-acond   = c-tab-res.descricao.
                        WHEN 3 THEN ASSIGN ci-amostragem = c-tab-res.descricao.
                    END CASE.
                end.
             end.
          end.
        
         /* novo calculo de fabricacao inferior utilizando parametro cadastrado na ~familia via es0733. */

          find int-familia of familia no-lock no-error.
              if not avail int-familia then do:
                   create int-familia.
                   assign int-familia.fm-codigo = familia.fm-codigo.
                   find current int-familia no-lock.
              end.
    
             assign c-fab-inf  = string(int-familia.meses-validade) + " Meses" .
                    ci-fab-inf = string(int-familia.meses-validade) + " Months".
    
          run html-ini-tab.
          run html-ini-lin-tab.
          run html-cab-tab("&nbsp") .
          run html-cab-tab("Portugues").
          run html-cab-tab("English").
          run html-fim-lin-tab.
          
          run html-ini-lin-tab.
          run html-con-tab("Familia/Family","Left").
          run html-con-tab(c-familia,"center").
          run html-con-tab(ci-familia,"center").
          run html-fim-lin-tab.
          
          for each tt-rec break by tt-rec.seq :
               run html-ini-lin-tab.
               run html-con-tab(if first(tt-rec.seq) then 
                 "Rotina /Receive Routine" else "&nbsp","Left").
               run html-con-tab(tt-rec.descricao[1],"center").
               run html-con-tab(tt-rec.descricao[2],"center").
               run html-fim-lin-tab.  
          end.

          run html-ini-lin-tab.
          run html-con-tab("Item/Item","Left").
          run html-con-tab(item.it-codigo,"center").
          run html-con-tab(item.it-codigo,"center").
          run html-fim-lin-tab.
    
          run html-ini-lin-tab.
          run html-con-tab("Descricao/Description","Left").
          run html-con-tab(item.desc-item,"center").
          run html-con-tab(if item.desc-inter <> "" THEN item.desc-inter ELSE item.desc-item,"center").
          run html-fim-lin-tab.
    
          /*run html-ini-lin-tab.
          run html-con-tab("NCM / Ex Tarifario","Left").
          run html-con-tab( item.class-fiscal + " / " +  
          string(int-item.ex-tarifario),"center").
          run html-con-tab("&nbsp","center").
          run html-fim-lin-tab.
     
          if int-item.nve <> "" then do:
              run html-ini-lin-tab.
              run html-con-tab("NVE","Left").
              run html-con-tab(int-item.nve,"center").
              run html-con-tab("&nbsp","center").
              run html-fim-lin-tab.
          end.*/

          run html-ini-lin-tab.
          run html-con-tab("Versao,Data/Version,Date","Left").
          run html-con-tab(string(i-versao,">>9") + " - " + string(da-versao,"99/99/9999"),"center").
          run html-con-tab(string(i-versao,">>9") + " - " + string(month(da-versao),"99") + "/" + 
                           string(day(da-versao),"99") + "/" + string(year(da-versao),"9999"),"center").
          run html-fim-lin-tab.
              
          run html-ini-lin-tab.
          run html-con-tab("Responsavel/Responsible","Left").
          run html-con-tab(c-responsavel,"center").
          run html-con-tab(c-responsavel,"center").
          run html-fim-lin-tab.
    
          run html-ini-lin-tab.
          run html-con-tab("Fabr.Inferior/Validity","Left").
          run html-con-tab(c-fab-inf,"center").
          run html-con-tab(ci-fab-inf,"center").
          run html-fim-lin-tab.
    
          run html-ini-lin-tab.
          run html-con-tab("Amostragem","Left").
          run html-con-tab(c-amostragem,"center").
          run html-con-tab("&nbsp","center").
          run html-fim-lin-tab.

          run html-ini-lin-tab.
          run html-con-tab("Acondicionamento/Packing","Left").
          run html-con-tab(c-acond,"center").
          run html-con-tab(ci-acond,"center").
          run html-fim-lin-tab.

          for each desenho-item 
             where desenho-item.it-codigo = item.it-codigo
                no-lock break by desenho-item.it-codigo:
    
             run html-ini-lin-tab.
             run html-con-tab(if first-of(desenho-item.it-codigo) 
                              then "Desenhos/Drawing" 
                              else  "&nbsp","Left").
           
             find last revisao
                where revisao.de-codigo = desenho-item.de-codigo
                no-lock no-error.
             if avail revisao  then do:
                run html-con-tab(desenho-item.de-codigo + " " + revisao.rv-codigo + " " + 
                                 SUBSTRING(STRING(YEAR(revisao.data-revisao),"9999"),3,2),"center").
                run html-con-tab(desenho-item.de-codigo + " " + revisao.rv-codigo + " " + 
                                 SUBSTRING(STRING(YEAR(revisao.data-revisao),"9999"),3,2),"center").
             end.
             else do:
                 run html-con-tab(desenho-item.de-codigo,"center").
                 run html-con-tab(desenho-item.de-codigo,"center").
             end.
       
             run html-fim-lin-tab.
          end.

          for each item-fabric no-lock
              where item-fabric.it-codigo = item.it-codigo
              break by item-fabric.cod-fabric:
              FIND fabricante NO-LOCK
                   WHERE fabricante.cod-fabric = item-fabric.cod-fabric NO-ERROR.

              ASSIGN c-it-fabric = ITEM-fabric.it-fabric.

              run html-ini-lin-tab.
              run html-con-tab("Fabricante/Manufacturer","Left").
              run html-con-tab(string(fabricante.cod-fabric) + if i-fabric = 1 then " - " + fabricante.nome else "","center").           
              run html-con-tab(string(fabricante.cod-fabric) + if i-fabric = 1 then " - " + fabricante.nome else "","center").              
              run html-fim-lin-tab.
              
              run html-ini-lin-tab.
              run html-con-tab("Item/Item","Left").
              run html-con-tab(c-it-fabric,"center").
              run html-con-tab(c-it-fabric,"center").
              run html-fim-lin-tab.
              
          end.
          for each it-msg-carac no-lock
             where it-msg-carac.it-codigo = item.it-codigo 
             break by it-msg-carac.it-codigo:
             if first-of(it-msg-carac.it-codigo) then do:
                 run html-ini-lin-tab.
                 run html-con-tab("Inf.Adicion/General Inf.","left").
                 run html-con-tab(it-msg-carac.msg-exp,"center").
                 run html-con-tab("&nbsp;","center").
                 run html-fim-lin-tab.
             end.
          end.
          if last-of(item.it-codigo) then do:
               run html-fim-tab.
               run html-fim.
    
               OUTPUT CLOSE.

               RUN esp/visualiza.p (c-arquivo).

               run pi-manda-email.
          end.
          delete tt-digita.
      end. 
   end.
end.

PROCEDURE pi-manda-email.

    FOR EACH tt-mail:
        DELETE tt-mail.
    END.

    CREATE tt-mail.
    ASSIGN tt-mail.Destinatario  = tt-param.c-endereco
           tt-mail.Arquivo       = c-arquivo
           tt-mail.Assunto       = "Condicoes Tecnicas de Recebimento".

    FOR FIRST usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = c-seg-usuario:
        ASSIGN tt-mail.Remetente = IF usuar_mestre.cod_e_mail_local = "" THEN "Compras@intelbras.com.br" 
                                                                         ELSE usuar_mestre.cod_e_mail_local.
    END.

    DO i-cont = 1 TO 20:
        ASSIGN tt-mail.mensagem = tt-mail.mensagem + c-texto-html[i-cont] + CHR(13).
    END.
    
    RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                          OUTPUT TABLE tt-erro).

END PROCEDURE.

{include/pi-edit.i}


/**** Fim do programa ****/


