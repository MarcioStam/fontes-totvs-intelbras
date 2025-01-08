DEFINE VARIABLE c-destino AS CHARACTER   FORMAT "x(15)":U.

{include/i-prgvrs.i esccp048RP 1.00.00.002}

{esp/ccp/esccp048tt.i}
{upc/btb910za-upc.i}
{esp/es0018.i}

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.    
DEFINE VARIABLE c-dt-arq  AS CHARACTER   NO-UNDO.

/* Vari†vel de exportaá∆o */
DEFINE VARIABLE c-export             AS CHARACTER FORMAT "X(256)"        NO-UNDO.
DEFINE VARIABLE c-cab                AS CHARACTER FORMAT "X(256)"        NO-UNDO.
DEFINE VARIABLE c-format             AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-format-cab         AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-caminho-arquivo    AS CHARACTER                        NO-UNDO.

DEFINE VARIABLE c-desc-conta         AS CHARACTER   NO-UNDO.
ASSIGN c-dt-arq  = STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99").

DEF BUFFER bf-embarque FOR ordens-embarque.

{esp/imp/esimp000.i1}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

DEF TEMP-TABLE tt-oc NO-UNDO
    FIELD dt-pedido           AS CHARACTER
    FIELD num-pedido          AS CHARACTER 
    FIELD cod-emite           AS CHARACTER
    FIELD nome-emite          AS CHARACTER
    FIELD cod-gr-forn         AS CHARACTER
    FIELD desc-cod-gr-forn    AS CHARACTER
    FIELD numero-ordem        AS CHARACTER
    FIELD it-codigo           AS CHARACTER
    FIELD descricao           AS CHARACTER
    FIELD ge-codigo           AS CHARACTER
    FIELD ge-descricao        AS CHARACTER
    FIELD saldo-OC-a-entregar AS CHARACTER
    FIELD salto-OC-total      AS CHARACTER
    FIELD preco-pedido        AS CHARACTER
    FIELD preco-taxa          AS CHARACTER
    FIELD desc-moeda          AS CHARACTER
    FIELD cod-comprador       AS CHARACTER
    FIELD nome-comprador      AS CHARACTER
    FIELD tp-despesa          AS CHARACTER
    FIELD desc-tp-despesa     AS CHARACTER
    FIELD ct-codigo           AS CHARACTER
    FIELD desc-ct-codigo      AS CHARACTER
    FIELD tipo-rec-desp       AS CHARACTER
    FIELD desc-tipo-rec-desp  AS CHARACTER
    FIELD ERRO                AS CHARACTER

        INDEX tipo-rec-desp 
              ct-codigo.

DEF BUFFER b-tt-oc FOR tt-oc.

form
/*form-selecao-ini*/
    skip(1)
    "Seleá∆o: "
    skip(1)
    tt-param.data-ini format "99/99/9999" label "Data" colon 40
    " <| |> " at 60
    tt-param.data-fim format "99/99/9999" no-label skip
    
    tt-param.cod-comprado-ini format "X(12)" label "Comprador" colon 40
    " <| |> " at 60
    tt-param.cod-comprado-fim format "X(12)" no-label skip

    tt-param.it-codigo-ini format "x(16)" label "Item" colon 40
    " <| |> " at 60
    tt-param.it-codigo-fim format "x(16)" no-label skip
    
    tt-param.i-ge-ini format ">>9" label "Grupo Estoqeu" colon 40
    " <| |> " at 60
    tt-param.i-ge-fim format ">>9" no-label skip
    skip(2)
    "Impress∆o:"
    skip(1)
    c-destino           LABEL "Destino" colon 40 "-"
    tt-param.arquivo    no-label
    tt-param.usuario    LABEL "Usu†rio" colon 40
    skip(1)
/*form-impressao-fim*/
    with stream-io side-labels no-attr-space no-box width 132 frame f-impressao.

form
    /*campos-do-relatorio*/
     with no-box width 132 down stream-io frame f-relat.

create tt-param.
raw-transfer raw-param to tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

{include/i-rpvar.i}
{utp/ut-glob.i}

FIND FIRST mgcad.empresa NO-LOCK 
     WHERE mgcad.empresa.ep-codigo = v_cdn_empres_usuar NO-ERROR.

FIND FIRST param-global NO-LOCK NO-ERROR.

{utp/ut-liter.i Espec°ficos_Intelbras * }
assign c-sistema = return-value.
{utp/ut-liter.i Relat¢rio_de_Saldos_por_Comprador * }
assign c-titulo-relat = return-value.
assign c-empresa     = param-global.grupo
       c-programa    = "{&programa}":U
       c-versao      = "1.00":U
       c-revisao     = "000"
       c-destino     = {varinc/var00002.i 04 tt-param.destino}.
       
def var c-titulo        as char format "x(50)" NO-UNDO.
def var c-fornecedor    as char no-undo.
def var c-comprador     as char no-undo.
DEF VAR c-nome-comprado AS CHAR NO-UNDO.

DEFINE VARIABLE c-data-vencto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-cotacao    AS DECIMAL     NO-UNDO.
DEF VAR c-remetente           AS CHAR        NO-UNDO INITIAL "intelbras@intelbras.com.br".

def var i-cont-dat  as integer no-undo.
def var i-cont-desc as integer no-undo.

DEF VAR i-page      AS INT       NO-UNDO INIT 1.
DEF VAR l-ok        AS LOGICAL   NO-UNDO.
DEF VAR c-data      AS CHAR      NO-UNDO.
DEF VAR c-despacho  AS CHAR      NO-UNDO.
DEF VAR l-imp-cabec AS LOGICAL   NO-UNDO.    
DEF VAR i-cont      AS INTEGER   NO-UNDO.
DEF VAR l-imp-dat   AS LOGICAL   NO-UNDO.
DEF VAR l-imp-dsc   AS LOGICAL   NO-UNDO.
DEF VAR emb-conhec  AS CHAR      NO-UNDO.

DEFINE VARIABLE c-emb-conhec     AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE c-embarque       AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE c-incortem       AS CHARACTER                 NO-UNDO. /*embarque-imp.cod-incoterm*/
DEFINE VARIABLE c-itiner         AS CHARACTER                 NO-UNDO. /*cotacao-item.cod-itiner*/
DEFINE VARIABLE c-pto-contr-base AS CHARACTER                 NO-UNDO. /*cotacao-item.cod-pto-contr-base*/
DEFINE VARIABLE c-erro           AS CHARACTER FORMAT "x(90)"  NO-UNDO.

DEFINE VARIABLE c-it-altern      AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE c-des-unid-negoc AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE de-qtidade-atu   LIKE saldo-estoq.qtidade-atu NO-UNDO.
DEFINE VARIABLE c-situacao       AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE i-situacao       AS INTEGER                   NO-UNDO.
      
DEFINE VARIABLE da-data          AS DATE EXTENT 12            NO-UNDO.
DEFINE VARIABLE i-aux            AS INT                       NO-UNDO.

DEFINE VARIABLE v_des_cta_ctbl   AS CHAR FORMAT "x(100)"      NO-UNDO.

{include/i-rpcab.i}

do on stop undo, leave:
    {include/i-rpout.i}
    view frame f-cabec.
    view frame f-rodape.    
    run utp/ut-acomp.p persistent set h-acomp.  
    
    run pi-inicializar in h-acomp (input "Inicializar":U). 

    run pi-relat.
    
    run pi-finalizar in h-acomp.
    
    page.
    
    disp tt-param.data-ini
         tt-param.data-fim
         tt-param.cod-comprado-ini
         tt-param.cod-comprado-fim
         tt-param.it-codigo-ini
         tt-param.it-codigo-fim
         tt-param.i-ge-ini
         tt-param.i-ge-fim
         c-caminho-arquivo LABEL "Caminho Relat¢rio" FORMAT "x(100)"
         c-destino
         tt-param.arquivo
         tt-param.usuario
         with frame f-impressao.
    
    {include/i-rpclo.i}
end.


PROCEDURE pi-relat :
    
    EMPTY TEMP-TABLE tt-oc.

    RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

    RUN pi-inicializar IN h-acomp (INPUT "Lendo Ordens de Compra":U).
  
    /*Leitura apartir de ordem de compra - informado o emitente e comprador*/
    FOR EACH ordem-compra NO-LOCK
       WHERE ordem-compra.situacao       = 2 /*Confirmada*/ 
         AND ordem-compra.cod-comprado   >= tt-param.cod-comprado-ini
         AND ordem-compra.cod-comprado   <= tt-param.cod-comprado-fim
         AND ordem-compra.it-codigo      >= tt-param.it-codigo-ini
         AND ordem-compra.it-codigo      <= tt-param.it-codigo-fim,
       FIRST ITEM NO-LOCK
       WHERE ITEM.it-codigo = ordem-compra.it-codigo
         AND ITEM.ge-codigo >= tt-param.i-ge-ini
         AND ITEM.ge-codigo <= tt-param.i-ge-fim,
       FIRST pedido-compr NO-LOCK
       WHERE pedido-compr.num-pedido   = ordem-compra.num-pedido
         AND pedido-compr.data-pedido >= tt-param.data-ini
         AND pedido-compr.data-pedido <= tt-param.data-fim,
        EACH prazo-compra OF ordem-compra NO-LOCK
       WHERE prazo-compra.situacao     = 2 /*Confirmada*/ 
        BY pedido-compr.data-pedido
        BY ordem-compra.numero-ordem:


        RUN pi-cria-tabela.
    END.

    IF NOT CAN-FIND(FIRST tt-oc) THEN DO:
        ASSIGN c-erro = "N∆o foram encontradas ordens para a seleá∆o efetuada.".
        PUT UNFORMATTED c-erro.
        RETURN "NOK".
    END.

    RUN pi-inicializar IN h-acomp (INPUT "Gerando Relat¢rio":U).
    ASSIGN l-imp-cabec = YES.

    /* Exporta Excel */
    ASSIGN c-export          = ""
           c-cab             = ""
           c-format          = ""
           c-format-cab      = ""
           c-caminho-arquivo = "".

   /* ASSIGN c-caminho-arquivo = SESSION:TEMP-DIRECTORY + c-seg-usuario. */
    ASSIGN c-caminho-arquivo = c-dir-arquivo-session + c-seg-usuario.

    OS-CREATE-DIR VALUE(c-caminho-arquivo).

    ASSIGN c-caminho-arquivo = c-caminho-arquivo + "/" + "ESCCP048.csv".
    ASSIGN c-caminho-arquivo = REPLACE(c-caminho-arquivo, "~\":U, "/":U).

    /* Elimina arquivo j† existente */
    OS-DELETE VALUE(c-caminho-arquivo) NO-ERROR.

    /* Inicia Exportaá∆o */
    OUTPUT TO VALUE(c-caminho-arquivo) CONVERT TARGET "iso8859-1":U.

    /* Exporta cabeáalho */
    RUN piCabecalhoExcel.
    PUT c-cab FORMAT c-format-cab.
    PUT SKIP.

    /* Exporta de acordo com a classificaá∆o */
    RUN piExportaExcel1.
    
    OUTPUT CLOSE.
    
    if valid-handle(h_api_cta_ctbl) then
        delete object h_api_cta_ctbl.


END PROCEDURE.


PROCEDURE pi-busca-cotacao :
DEF INPUT PARAMETER da-data as DATE NO-UNDO.
    
    FIND FIRST cotacao NO-LOCK         
         WHERE cotacao.mo-codigo   = 1 
           AND cotacao.ano-periodo = STRING(year(da-data),"9999") + STRING(month(da-data),"99") NO-ERROR.

    IF AVAIL cotacao 
         AND cotacao.cotacao[day(da-data)] <> 0 THEN  
       ASSIGN de-cotacao = cotacao.cotacao[day(da-data)].
    ELSE
       ASSIGN de-cotacao = 1.
END.

PROCEDURE pi-cria-tabela:

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emite = ordem-compra.cod-emite NO-ERROR.

    FIND FIRST cotacao-item NO-LOCK 
         WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
           AND cotacao-item.cod-emitente = ordem-compra.cod-emitente NO-ERROR.

    FIND FIRST int-cotacao-item OF cotacao-item NO-LOCK NO-ERROR.

    run pi-acompanhar in h-acomp (INPUT "Ordem: " + TRIM(STRING(ordem-compra.numero-ordem)) + " - " + TRIM(STRING(ordem-compra.it-codigo)) + " - " + STRING(pedido-compr.data-pedido,"99/99/9999")).
    
  
    CREATE tt-oc.

    FIND FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-ERROR.

    FIND FIRST grupo-forn NO-LOCK
        WHERE grupo-forn.cod-gr-forn = emitente.cod-gr-forn NO-ERROR.

    ASSIGN tt-oc.dt-pedido          = STRING(pedido-compr.data-pedido, "99/99/9999")
           tt-oc.num-pedido         = string(ordem-compra.num-pedido)
           tt-oc.cod-emite          = STRING(ordem-compra.cod-emite, ">>>,>>9")
           tt-oc.nome-emite         = emitente.nome-emit
           tt-oc.cod-gr-forn        = string(emitente.cod-gr-forn).
    ASSIGN
           tt-oc.desc-cod-gr-forn   = IF AVAIL grupo-forn THEN grupo-forn.descricao ELSE ""
           tt-oc.numero-ordem       = string(ordem-compra.numero-ordem)
           tt-oc.it-codigo          = ordem-compra.it-codigo.

    IF  ordem-compra.it-codigo = "" THEN ASSIGN tt-oc.descricao = tt-oc.descricao + ordem-compra.narrativa.
    ELSE ASSIGN tt-oc.descricao = item.desc-item.
    

    ASSIGN tt-oc.descricao = trim(substring(REPLACE(REPLACE(tt-oc.descricao,CHR(10),""),CHR(13),""), 1, 40)).

    FIND FIRST grup-estoq NO-LOCK
         WHERE grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.

    ASSIGN tt-oc.ge-codigo       = STRING(ITEM.ge-codigo)
           tt-oc.ge-descricao    = IF AVAIL grup-estoq THEN grup-estoq.descricao ELSE "".

    /* PREÄOS */
    ASSIGN tt-oc.saldo-OC-a-entregar = string(prazo-compra.qtd-sal-forn, "->>>,>>>,>>9.99999")
           tt-oc.salto-OC-total      = string(ordem-compra.qt-solic, "->>>,>>>,>>9.99999").

    /* Comprador */
    FOR FIRST comprador FIELDS (nome)
        WHERE comprador.cod-comprado = ordem-compra.cod-comprado NO-LOCK: 
    END.

    FIND FIRST moeda                                                    
        WHERE moeda.mo-codigo = cotacao-item.mo-codigo NO-LOCK NO-ERROR.
       
    ASSIGN tt-oc.Desc-moeda     = IF AVAIL moeda THEN moeda.descricao ELSE ""
           tt-oc.cod-comprador  = ordem-compra.cod-com
           tt-oc.nome-comprador = IF AVAIL comprador THEN comprador.nome ELSE "".

    FIND FIRST tipo-rec-desp
         WHERE tipo-rec-desp.tp-codigo = ordem-compra.tp-despesa NO-LOCK NO-ERROR.

    ASSIGN tt-oc.tp-despesa      = string(ordem-compra.tp-despesa)
           tt-oc.desc-tp-despesa = IF AVAILABLE tipo-rec-desp THEN tipo-rec-desp.descricao ELSE "".

    ASSIGN v_des_cta_ctbl     = ""
           v_num_tip_cta_ctbl = 0
           v_num_sit_cta_ctbl = 0 
           v_ind_finalid_cta  = ""
           c-desc-conta       = ordem-compra.ct-codigo.

    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        "001",              /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output c-desc-conta,       /* CONTA */
                                                   input        TODAY,              /* DATA TRANSACAO */   
                                                   output       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUAÄ«O DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */
    ASSIGN tt-oc.ct-codigo      = ordem-compra.ct-codigo
           tt-oc.desc-ct-codigo = v_des_cta_ctbl.

    FIND FIRST cotacao-item NO-LOCK 
         WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
           AND cotacao-item.cod-emitente = ordem-compra.cod-emitente NO-ERROR.

      IF AVAIL cotacao-item THEN DO:
          IF cotacao-item.mo-codigo = 1 THEN DO:
              IF emitente.natureza <= 2 THEN DO:
                  /*nacional*/
                  RUN pi-busca-cotacao  (input ordem-compra.data-emissao).
              END.
              ELSE DO:
                  RUN pi-busca-cotacao  (input prazo-compra.data-entrega).
              END.
          END.
          ELSE
             ASSIGN de-cotacao = 1.

          FIND FIRST moeda
              WHERE moeda.mo-codigo = cotacao-item.mo-codigo NO-LOCK NO-ERROR.

          ASSIGN tt-oc.preco-pedido = TRIM(STRING(cotacao-item.preco-fornec * de-cotacao,"->>>,>>>,>>9.99999"))
                 tt-oc.preco-taxa   = TRIM(STRING(cotacao-item.pre-unit-for * de-cotacao,"->>>,>>>,>>9.99999")).
      END.

      FOR FIRST int-desp-cta-ctbl NO-LOCK
            WHERE int-desp-cta-ctbl.cod-cta-ctbl = ordem-compra.ct-codigo:
          ASSIGN tt-oc.tipo-rec-desp = string(int-desp-cta-ctbl.tp-codigo).

          FIND FIRST tipo-rec-desp
              WHERE tipo-rec-desp.tp-codigo = int-desp-cta-ctbl.tp-codigo NO-LOCK NO-ERROR.
          IF  AVAIL tipo-rec-desp THEN
              ASSIGN tt-oc.desc-tipo-rec-desp = tipo-rec-desp.descricao.
      END.

            
      IF  AVAIL int-desp-cta-ctbl THEN
          tt-oc.ERRO = STRING(int(tt-oc.tp-despesa) = int-desp-cta-ctbl.tp-codigo, "SIM/N«O").
      

 
END PROCEDURE.

PROCEDURE piCabecalhoExcel:
    
    /* Criar Cabeáalho */
    ASSIGN c-cab = "Data Emiss∆o"          + ";" +
                   "Pedido"                + ";" +
                   "Cod Fornec"            + ";" +
                   "Nome Fornec"           + ";" +
                   "GF"                    + ";" +
                   "Desc GF"               + ";" + 
                   "OC"                    + ";" +
                   "Item"                  + ";" +
                   "Desc Item"             + ";" + 
                   "GE"                    + ";" + 
                   "Desc GE"               + ";" + 
                   "Qty Saldo OC"          + ";" + 
                   "Qty Total OC"          + ";" + 
                   "Preáo Pedido"          + ";" + 
                   "Preáo Taxa"            + ";" + 
                   "Moeda"                 + ";" + 
                   "Comprador"             + ";" + 
                   "Desc Compr"            + ";" + 
                   "Tipo Desp OC"          + ";" + 
                   "Desc Desp"             + ";" + 
                   "Conta Cont†bil"        + ";" + 
                   "Desc Conta"            + ";" + 
                   "Tipo Desp Conta"       + ";" + 
                   "Desc Tipo Desp Conta"  + ";" + 
                   "ERRO"                  + ";".
                                      
    ASSIGN c-format-cab = "x(" + STRING(LENGTH(c-cab)) + ")".

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE piExportaExcel1:

    /* Exportar dados Classificaá∆o 1 */
    FOR EACH tt-oc
        BY  tt-oc.tipo-rec-desp
        BY  tt-oc.ct-codigo:               
        
        ASSIGN c-export = tt-oc.dt-pedido           + ";" +   
                          tt-oc.num-pedido          + ";" +   
                          tt-oc.cod-emite           + ";" +   
                          tt-oc.nome-emite          + ";" +   
                          tt-oc.cod-gr-forn         + ";" +   
                          tt-oc.desc-cod-gr-forn    + ";" +   
                          tt-oc.numero-ordem        + ";" +   
                          tt-oc.it-codigo           + ";" +   
                          tt-oc.descricao           + ";" +   
                          tt-oc.ge-codigo           + ";" +   
                          tt-oc.ge-descricao        + ";" +   
                          tt-oc.saldo-OC-a-entregar + ";" +   
                          tt-oc.salto-OC-total      + ";" +   
                          tt-oc.preco-pedido        + ";" +   
                          tt-oc.preco-taxa          + ";" +   
                          tt-oc.Desc-moeda          + ";" +   
                          tt-oc.cod-comprador       + ";" +   
                          tt-oc.nome-comprador      + ";" +   
                          tt-oc.tp-despesa          + ";" +   
                          tt-oc.desc-tp-despesa     + ";" +   
                          tt-oc.ct-codigo           + ";" +   
                          tt-oc.desc-ct-codigo      + ";" +   
                          tt-oc.tipo-rec-desp       + ";" + 
                          tt-oc.desc-tipo-rec-desp  + ";" + 
                          tt-oc.ERRO                + ";".

        /* Retira Informaá‰es Desnecess†rias */
        ASSIGN c-export = REPLACE(c-export,"&nbsp;", "").

        ASSIGN c-format = "x(" + STRING(LENGTH(c-export)) + ")".

        /* Exportar Dados */
        PUT UNFORMATTED c-export /*FORMAT c-format*/.
        PUT SKIP.
    END.

    RETURN "OK":U.

END PROCEDURE.

