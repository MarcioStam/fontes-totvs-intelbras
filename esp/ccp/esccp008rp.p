/*:T *******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCCP008RP 1.00.00.002}

/* ***************************  Definitions  ************************** */
&global-define programa ESCCP008RP

DEFINE VARIABLE c-destino AS CHARACTER   FORMAT "x(15)":U.
DEFINE VARIABLE c-distrib AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-classif AS CHARACTER   NO-UNDO.

{esp/ccp/esccp008tt.i}
{upc/btb910za-upc.i}
{esp/es0018.i}

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.    
DEFINE VARIABLE c-dt-arq  AS CHARACTER   NO-UNDO.

/* Vari vel de exporta‡Æo */
DEFINE VARIABLE c-export             AS CHARACTER FORMAT "X(256)"        NO-UNDO.
DEFINE VARIABLE c-cab                AS CHARACTER FORMAT "X(256)"        NO-UNDO.
DEFINE VARIABLE c-format             AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-format-cab         AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-caminho-arquivo    AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE l-usuar-comprador    AS LOGICAL                          NO-UNDO.
                                     
DEFINE VARIABLE d-peso-bruto         AS DECIMAL FORMAT ">>>,>>>,>>9.99999" NO-UNDO.
DEFINE VARIABLE d-peso-liquido       AS DECIMAL FORMAT ">>>,>>>,>>9.99999" NO-UNDO.
DEFINE VARIABLE c-descricao          AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE c-observacao         AS CHARACTER FORMAT "X(100)"          NO-UNDO.
DEFINE VARIABLE l-antidumping        AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE c-des-ult-pto-contr  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-data-ult-pto-contr AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-navio              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-tipos              AS CHARACTER   NO-UNDO.
ASSIGN c-tipos = "Amostra,Automÿtico,Comum,Homologa»’o,Independente,Ressarcimento,Spot,Troca de Modal,Para Manaus,CKD Comum,CKD Amostra,Para Engesul,Para Automatiza,Back to back".

ASSIGN c-dt-arq  = STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99").

DEFINE VARIABLE c-tp-pedido AS CHARACTER   NO-UNDO.

DEF BUFFER bf-embarque FOR ordens-embarque.

{esp/imp/esimp000.i1}

DEF TEMP-TABLE tt-oc NO-UNDO
    FIELD cod-emite          AS CHARACTER
    FIELD cod-comprado       AS CHARACTER
    FIELD nome-comprado      AS CHARACTER
    FIELD nome-abrev         AS CHARACTER
    FIELD dt-orig            AS CHARACTER
    field dt-necessidade     as character
    FIELD dt-entrega         AS CHARACTER
    FIELD situacao-parcela   AS CHARACTER
    FIELD dt-despacho        AS CHARACTER
    FIELD dt-embarque        AS CHARACTER
    FIELD dt-pedido          AS CHARACTER
    FIELD nr-conhecimento    AS CHARACTER
    FIELD embarque           AS CHARACTER
    FIELD des-ult-pto-contr  AS CHARACTER
    FIELD data-ult-pto-contr AS CHARACTER
    FIELD navio              AS CHARACTER
    FIELD incortem           AS CHARACTER
    FIELD itiner             AS CHARACTER
    FIELD pto-contr-base     AS CHARACTER
    FIELD peso-bruto         AS CHARACTER
    FIELD peso-liquido       AS CHARACTER
    FIELD num-pedido         AS CHARACTER
    FIELD numero-ordem       AS CHARACTER
    FIELD vl-custo-it        AS CHARACTER
    FIELD des-moeda          AS CHARACTER
    FIELD narrativa-ordem    AS CHARACTER
    FIELD parcela            AS CHARACTER
    FIELD cod-estabel        AS CHARACTER
    FIELD ordem-serv         AS CHARACTER
    FIELD it-codigo          AS CHARACTER
    FIELD descricao          AS CHARACTER
    FIELD un                 AS CHARACTER
    FIELD class-fiscal       AS CHARACTER
    FIELD ex-tarif           LIKE int-item.ex-tarifario
    FIELD destaque           AS CHARACTER FORMAT "x(03)"
    FIELD gatt               AS CHARACTER 
    FIELD nec-li             AS CHARACTER
    FIELD antidump           AS CHARACTER
    FIELD observacao         AS CHARACTER
    FIELD nec-inspec         AS CHARACTER
    FIELD quantidade         AS CHARACTER
    FIELD qtd-receb          AS CHARACTER
    FIELD qtd-saldo          AS CHARACTER
    FIELD qtd-do-forn        AS CHARACTER
    FIELD un-do-forn         AS CHARACTER
    FIELD atraso             AS CHARACTER
    FIELD fone               LIKE emitente.telefone[1]
    FIELD cond-pagto         AS CHARACTER 

    /* - em coment rios para libera‡Æo de corre‡Æo simples antes do FFT .... 
    FIELD cod-libera-fft  AS INTEGER
    */
                           
    FIELD vl-unit          AS CHARACTER 
    FIELD vl-unit-ipi      AS CHARACTER 
    FIELD ipi-incluso      AS CHARACTER
    FIELD aliq-ipi         AS CHARACTER     
    FIELD cnpj             AS CHARACTER
    FIELD narrativa        AS CHARACTER FORMAT "X(2000)"
    FIELD cod-unid-negoc   AS CHARACTER
    FIELD des-unid-negoc   AS CHARACTER
    FIELD ge-codigo        AS CHARACTER
    FIELD ge-descricao     AS CHARACTER
    FIELD it-altern        AS CHARACTER
    FIELD saldo-estoq      AS CHARACTER
    FIELD via-transp       AS CHARACTER
    FIELD situacao         AS CHARACTER
    FIELD cod-depos        LIKE ordem-compra.dep-almoxar
    FIELD cod-fabric       LIKE fabricante.cod-fabric
    FIELD desc-fabric      LIKE fabricante.nome-abrev
    FIELD ativo-fabric     AS CHAR
    FIELD cod-pn-fabric    LIKE item-fabric.it-fabric
    FIELD nome-contato     LIKE cont-emit.nome
    FIELD fone-contato     LIKE cont-emit.telefone
    FIELD email-contato    LIKE cont-emit.e-mail
    FIELD cod-mensagem     AS CHARACTER
    FIELD desc-mensagem    AS CHARACTER
    FIELD ct-codigo   AS CHARACTER
    FIELD sc-codigo   AS CHARACTER
    FIELD requisitante AS CHAR
    FIELD nome-requis  AS CHAR
    FIELD tipo-pedido  AS CHAR
    FIELD nr-nf        AS CHAR
    INDEX for-dat-it 
          cod-emite
          dt-entrega
          it-codigo
    INDEX it-dat-for
          cod-comprado
          it-codigo
          dt-entrega
          cod-emite.

DEF TEMP-TABLE tt-arq1 NO-UNDO
    FIELD campo0 AS CHARACTER
    FIELD campo1 AS CHARACTER
    FIELD campo2 AS CHARACTER
    FIELD qtd    AS INTEGER
    INDEX n1
          campo2.
    
DEF TEMP-TABLE tt-arq2 NO-UNDO
    FIELD campo0 AS CHARACTER
    FIELD campo1 AS CHARACTER
    FIELD campo2 AS CHARACTER
    FIELD qtd    AS INTEGER
    INDEX n1
          campo2.

DEF STREAM s-supervisor.
DEF STREAM s-outros.
DEF BUFFER b-tt-oc FOR tt-oc.

form
/*form-selecao-ini*/
    skip(1)
    "Sele‡Æo: "
    skip(1)
    tt-param.cod-estabel-ini format "x(3)" label "Estab" colon 40
    " <| |> " at 60
    tt-param.cod-estabel-fim format "x(3)" no-label skip 
    tt-param.it-codigo-ini format "x(16)" label "Item" colon 40
    " <| |> " at 60
    tt-param.it-codigo-fim format "x(16)" no-label skip
    tt-param.cod-emitente-ini format ">>>>>>>>9" label "Fornecedor" colon 40
    " <| |> " at 60
    tt-param.cod-emitente-fim format ">>>>>>>>9" no-label skip
    tt-param.cod-comprado-ini format "X(12)" label "Comprador" colon 40
    " <| |> " at 60
    tt-param.cod-comprado-fim format "X(12)" no-label skip
    tt-param.data-ini format "99/99/9999" label "Data" colon 40
    " <| |> " at 60
    tt-param.data-fim format "99/99/9999" no-label skip
    skip(1)
/*form-selecao-fim*/
/*form-parametro-ini*/
    skip(1)
    "Email: "
    skip(1)
    c-distrib  format "x(15)" label "Distribui‡Æo Email" colon 40 skip
    tt-param.c-email   format "x(40)" label "Email" colon 40 skip
    tt-param.c-email-2   format "x(40)" label "Email Alternativo" colon 40 skip
    skip(1)
/*form-parametro-fim*/
/*form-classificacao-ini*/
    skip(1)
    "Parƒmetros:"
    skip(1)
    c-classif      FORMAT "x(30)"   LABEL "Classifica‡Æo" COLON 40 SKIP
    l-dependente   FORMAT "Sim/NÆo" label "Dependentes" colon 40 skip
    l-independente FORMAT "Sim/NÆo" label "Independente" colon 40 skip
    l-importados   FORMAT "Sim/NÆo" label "Importados" colon 40 skip
    l-nacionais    FORMAT "Sim/NÆo" label "Nacionais" colon 40 skip
    l-adicionais   FORMAT "Sim/NÆo" label "Dados Adicionais" colon 40 skip
    tt-param.l-oem          FORMAT "Sim/NÆo" label "Dados OEM" colon 40 skip
    c-caminho-arquivo FORMAT "X(80)" LABEL "Arquivo Excel" colon 40 skip
    skip(1)
/*form-classificacao-fim*/
/*form-impressao-ini*/
    skip(1)
    "ImpressÆo:"
    skip(1)
    c-destino           LABEL "Destino" colon 40 "-"
    tt-param.arquivo    no-label
    tt-param.usuario    LABEL "Usu rio" colon 40
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

{utp/ut-liter.i Espec¡ficos_Intelbras * }
assign c-sistema = return-value.
{utp/ut-liter.i Relat¢rio_de_Saldos_por_Comprador * }
assign c-titulo-relat = return-value.
assign c-empresa     = param-global.grupo
       c-programa    = "{&programa}":U
       c-versao      = "1.00":U
       c-revisao     = "000"
       c-destino     = {varinc/var00002.i 04 tt-param.destino}
       c-distrib      = entry(tt-param.i-distribuicao, "Todos,Supervisores")
       c-classif   = entry(tt-param.i-classif, "1-Fornecedor/Data/Item,2-Item/Data/Fornecedor").

def var c-titulo        as char format "x(50)" NO-UNDO.
def var c-fornecedor    as char no-undo.
def var c-comprador     as char no-undo.
DEF VAR c-nome-comprado AS CHAR NO-UNDO.

DEFINE VARIABLE c-data-vencto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-cotacao    AS DECIMAL     NO-UNDO.
DEF VAR c-remetente           AS CHAR        NO-UNDO INITIAL "intelbras@intelbras.com.br".

def var i-cont-dat  as integer no-undo.
def var i-cont-desc as integer no-undo.

DEF VAR i-page      AS INT     NO-UNDO INIT 1.
DEF VAR l-ok        AS LOGICAL NO-UNDO.
DEF VAR c-data      AS CHAR    NO-UNDO.
DEF VAR c-despacho  AS CHAR    NO-UNDO.
DEF VAR l-imp-cabec AS LOGICAL NO-UNDO.    
DEF VAR i-cont      AS INTEGER NO-UNDO.
DEF VAR l-imp-dat   AS LOGICAL NO-UNDO.
DEF VAR l-imp-dsc   AS LOGICAL NO-UNDO.
DEF VAR emb-conhec  AS CHAR    NO-UNDO.

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

{esp/es0006a.i}
{esp/es0006.i}
{esp/eslib.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

{include/i-rpcab.i}

/* ***************************  Main Block  *************************** */

do on stop undo, leave:
    {include/i-rpout.i}
    view frame f-cabec.
    view frame f-rodape.    
    run utp/ut-acomp.p persistent set h-acomp.  
    
    run pi-inicializar in h-acomp (input "Inicializar":U). 
    
    FOR FIRST usuar_mestre FIELDS (cod_e_mail_local)
        WHERE usuar_mestre.cod_usuario = c-seg-usuario:

        IF usuar_mestre.cod_e_mail_local <> "" THEN
            ASSIGN c-remetente = usuar_mestre.cod_e_mail_local.
    END.

    ASSIGN c-tam-tab = "900".

    run pi-relat.
    
    run pi-finalizar in h-acomp.
    
    page.
    
    disp tt-param.cod-estabel-ini
         tt-param.cod-estabel-fim
         tt-param.it-codigo-ini
         tt-param.it-codigo-fim
         tt-param.cod-emitente-ini
         tt-param.cod-emitente-fim
         tt-param.cod-comprado-ini
         tt-param.cod-comprado-fim
         tt-param.data-ini
         tt-param.data-fim
         c-distrib
         tt-param.c-email
         tt-param.c-email-2
         c-classif
         l-dependente
         l-independente
         l-importados
         l-nacionais
         l-adicionais
         l-oem
         c-caminho-arquivo
         c-destino
         tt-param.arquivo
         tt-param.usuario
         with frame f-impressao.
    
    {include/i-rpclo.i}
end.

/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-relat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-oc:
        DELETE tt-oc.
    END.

    FOR FIRST ponto-programa USE-INDEX ponto NO-LOCK
        WHERE ponto-programa.nome-programa = "cc0300a"
          AND ponto-programa.ponto         = 1
          AND ponto-programa.tipo          = 3,
         EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        /*ASSIGN de-seq = deci(ENTRY(1,conteudo-programa.conteudo,";")) NO-ERROR.

        IF ERROR-STATUS:ERROR
        OR NUM-ENTRIES(conteudo-programa.conteudo,";") < 4
        OR conteudo-programa.sequencia                <> de-seq
        OR conteudo-programa.sequencia                 = 0
        THEN DO:
             ASSIGN c-tp-pedido = ""
                    lg-aux      = YES.
             run utp/ut-msgs.p (input "show", input 17567, input "ATEN€ÇO! ERRO ao carregamento do Tipo Pedido. Revise o ES0018 (" + STRING(conteudo-programa.sequencia) + ")").
             LEAVE.
        END.

        IF  ENTRY(4,conteudo-programa.conteudo,";") = "INATIVO"
        AND (NOT AVAIL int-pedido-compr
         OR  int-pedido-compr.tp-pedido <> conteudo-programa.sequencia)
        THEN NEXT.*/

        ASSIGN c-tp-pedido = c-tp-pedido 
                           + TRIM(ENTRY(2,conteudo-programa.conteudo,";"))
                           + ",".                           
    END.

    ASSIGN c-tp-pedido = TRIM(c-tp-pedido,",").

    RUN pi-inicializar IN h-acomp (INPUT "Lendo Ordens de Compra":U).
  
    IF tt-param.cod-emitente-ini = tt-param.cod-emitente-fim AND
       tt-param.cod-comprado-ini = tt-param.cod-comprado-fim THEN DO:
        
        /*Leitura apartir de ordem de compra - informado o emitente e comprador*/
        FOR EACH ordem-compra NO-LOCK
           WHERE ordem-compra.cod-estabel    >= tt-param.cod-estabel-ini
             AND ordem-compra.cod-estabel    <= tt-param.cod-estabel-fim
             AND ordem-compra.situacao       <> 3 /*Cotada*/ 
             AND ordem-compra.situacao       <> 5 /*Em cota‡Æo*/
             AND ordem-compra.situacao       <> 1 /*NÆo confirmada*/
             AND ordem-compra.cod-emitente    = tt-param.cod-emitente-ini
             AND ordem-compra.cod-comprado    = tt-param.cod-comprado-ini
             AND ordem-compra.it-codigo      >= tt-param.it-codigo-ini
             AND ordem-compra.it-codigo      <= tt-param.it-codigo-fim
             AND ordem-compra.cod-unid-negoc >= tt-param.fi-ini-cod-unid-negoc
             AND ordem-compra.cod-unid-negoc <= tt-param.fi-fim-cod-unid-negoc,
           FIRST ITEM NO-LOCK
           WHERE ITEM.it-codigo = ordem-compra.it-codigo,
           FIRST pedido-compr NO-LOCK
           WHERE pedido-compr.num-pedido = ordem-compra.num-pedido,
            EACH prazo-compra OF ordem-compra NO-LOCK
           WHERE prazo-compra.situacao     <> 3 /*Cotada*/ 
             AND prazo-compra.situacao     <> 5 /*Em cota‡Æo*/
             AND prazo-compra.situacao     <> 1 /*NÆo confirmada*/
             AND prazo-compra.data-entrega >= tt-param.data-ini
             AND prazo-compra.data-entrega <= tt-param.data-fim:

            RUN pi-cria-tabela.
        END.
    END.
    ELSE DO:
        IF tt-param.cod-emitente-ini = tt-param.cod-emitente-fim THEN DO:
            /*Leitura apartir de ordem de compra - informado o emitente*/
            FOR EACH ordem-compra NO-LOCK
               WHERE ordem-compra.cod-estabel    >= tt-param.cod-estabel-ini
                 AND ordem-compra.cod-estabel    <= tt-param.cod-estabel-fim
                 AND ordem-compra.situacao       <> 3 /*Cotada*/ 
                 AND ordem-compra.situacao       <> 5 /*Em cota‡Æo*/
                 AND ordem-compra.situacao       <> 1 /*NÆo confirmada*/
                 AND ordem-compra.cod-emitente    = tt-param.cod-emitente-ini
                 AND ordem-compra.cod-comprado   >= tt-param.cod-comprado-ini
                 AND ordem-compra.cod-comprado   <= tt-param.cod-comprado-fim
                 AND ordem-compra.it-codigo      >= tt-param.it-codigo-ini
                 AND ordem-compra.it-codigo      <= tt-param.it-codigo-fim
                 AND ordem-compra.cod-unid-negoc >= tt-param.fi-ini-cod-unid-negoc
                 AND ordem-compra.cod-unid-negoc <= tt-param.fi-fim-cod-unid-negoc,
               FIRST ITEM NO-LOCK
               WHERE ITEM.it-codigo = ordem-compra.it-codigo,
               FIRST pedido-compr NO-LOCK
               WHERE pedido-compr.num-pedido = ordem-compra.num-pedido,
                EACH prazo-compra OF ordem-compra NO-LOCK
               WHERE prazo-compra.situacao     <> 3 /*Cotada*/ 
                 AND prazo-compra.situacao     <> 5 /*Em cota‡Æo*/
                 AND prazo-compra.situacao     <> 1 /*NÆo confirmada*/
                 AND prazo-compra.data-entrega >= tt-param.data-ini
                 AND prazo-compra.data-entrega <= tt-param.data-fim:

                RUN pi-cria-tabela.
            END.
        END.
        ELSE IF tt-param.cod-comprado-ini = tt-param.cod-comprado-fim THEN DO:
            /*Leitura apartir de ordem de compra - informado o comprador*/
            FOR EACH ordem-compra NO-LOCK
               WHERE ordem-compra.cod-estabel    >= tt-param.cod-estabel-ini
                 AND ordem-compra.cod-estabel    <= tt-param.cod-estabel-fim
                 AND ordem-compra.situacao       <> 3 /*Cotada*/ 
                 AND ordem-compra.situacao       <> 5 /*Em cota‡Æo*/
                 AND ordem-compra.situacao       <> 1 /*NÆo confirmada*/
                 AND ordem-compra.cod-emitente   >= tt-param.cod-emitente-ini
                 AND ordem-compra.cod-emitente   <= tt-param.cod-emitente-fim
                 AND ordem-compra.cod-comprado    = tt-param.cod-comprado-ini
                 AND ordem-compra.it-codigo      >= tt-param.it-codigo-ini
                 AND ordem-compra.it-codigo      <= tt-param.it-codigo-fim
                 AND ordem-compra.cod-unid-negoc >= tt-param.fi-ini-cod-unid-negoc
                 AND ordem-compra.cod-unid-negoc <= tt-param.fi-fim-cod-unid-negoc,
               FIRST ITEM NO-LOCK
               WHERE ITEM.it-codigo = ordem-compra.it-codigo,
               FIRST pedido-compr NO-LOCK
               WHERE pedido-compr.num-pedido = ordem-compra.num-pedido,
                EACH prazo-compra OF ordem-compra NO-LOCK
               WHERE prazo-compra.situacao     <> 3 /*Cotada*/ 
                 AND prazo-compra.situacao     <> 5 /*Em cota‡Æo*/
                 AND prazo-compra.situacao     <> 1 /*NÆo confirmada*/
                 AND prazo-compra.data-entrega >= tt-param.data-ini
                 AND prazo-compra.data-entrega <= tt-param.data-fim:

                RUN pi-cria-tabela.
            END.
        END.
        ELSE IF tt-param.it-codigo-ini = tt-param.it-codigo-fim THEN DO:
            /*Leitura apartir de ordem de compra - informado o item*/
            FOR EACH ordem-compra NO-LOCK
               WHERE ordem-compra.cod-estabel    >= tt-param.cod-estabel-ini
                 AND ordem-compra.cod-estabel    <= tt-param.cod-estabel-fim
                 AND ordem-compra.situacao       <> 3 /*Cotada*/ 
                 AND ordem-compra.situacao       <> 5 /*Em cota‡Æo*/
                 AND ordem-compra.situacao       <> 1 /*NÆo confirmada*/
                 AND ordem-compra.cod-emitente   >= tt-param.cod-emitente-ini
                 AND ordem-compra.cod-emitente   <= tt-param.cod-emitente-fim
                 AND ordem-compra.cod-comprado   >= tt-param.cod-comprado-ini
                 AND ordem-compra.cod-comprado   <= tt-param.cod-comprado-fim
                 AND ordem-compra.it-codigo       = tt-param.it-codigo-ini
                 AND ordem-compra.cod-unid-negoc >= tt-param.fi-ini-cod-unid-negoc
                 AND ordem-compra.cod-unid-negoc <= tt-param.fi-fim-cod-unid-negoc,
               FIRST ITEM NO-LOCK
               WHERE ITEM.it-codigo = ordem-compra.it-codigo,
               FIRST pedido-compr NO-LOCK
               WHERE pedido-compr.num-pedido = ordem-compra.num-pedido,
                EACH prazo-compra OF ordem-compra NO-LOCK
               WHERE prazo-compra.situacao     <> 3 /*Cotada*/ 
                 AND prazo-compra.situacao     <> 5 /*Em cota‡Æo*/
                 AND prazo-compra.situacao     <> 1 /*NÆo confirmada*/
                 AND prazo-compra.data-entrega >= tt-param.data-ini
                 AND prazo-compra.data-entrega <= tt-param.data-fim:

                RUN pi-cria-tabela.
            END.
        END.
        ELSE DO:
            /*Leitura atrav‚s da prazo-compra - data entrega*/
            FOR EACH prazo-compra NO-LOCK
               WHERE prazo-compra.situacao     <> 3 /*Cotada*/ 
                 AND prazo-compra.situacao     <> 5 /*Em cota‡Æo*/
                 AND prazo-compra.situacao     <> 1 /*NÆo confirmada*/
                 AND prazo-compra.data-entrega >= tt-param.data-ini
                 AND prazo-compra.data-entrega <= tt-param.data-fim
                 AND prazo-compra.it-codigo    >= tt-param.it-codigo-ini
                 AND prazo-compra.it-codigo    <= tt-param.it-codigo-fim,
               FIRST ordem-compra of prazo-compra NO-LOCK
               WHERE ordem-compra.cod-estabel >= tt-param.cod-estabel-ini
                 AND ordem-compra.cod-estabel <= tt-param.cod-estabel-fim
                 AND ordem-compra.situacao        <> 3 /*Cotada*/ 
                 AND ordem-compra.situacao        <> 5 /*Em cota‡Æo*/
                 AND ordem-compra.situacao        <> 1 /*NÆo confirmada*/
                 AND ordem-compra.cod-emitente >= tt-param.cod-emitente-ini
                 AND ordem-compra.cod-emitente <= tt-param.cod-emitente-fim
                 AND ordem-compra.cod-comprado >= tt-param.cod-comprado-ini
                 AND ordem-compra.cod-comprado <= tt-param.cod-comprado-fim
                 AND ordem-compra.cod-unid-negoc >= tt-param.fi-ini-cod-unid-negoc
                 AND ordem-compra.cod-unid-negoc <= tt-param.fi-fim-cod-unid-negoc,
               FIRST ITEM NO-LOCK
               WHERE item.it-codigo = ordem-compra.it-codigo,
               FIRST pedido-compr NO-LOCK
               WHERE pedido-compr.num-pedido = ordem-compra.num-pedido:

                RUN pi-cria-tabela.
            END.
        END.
    END.

    IF NOT CAN-FIND(FIRST tt-oc) THEN DO:
        ASSIGN c-erro = "NÆo foram encontradas ordens para a sele‡Æo efetuada. Aten‡Æo, e-mail nÆo enviado!".
        PUT UNFORMATTED c-erro.
        RETURN "NOK".
    END.

    RUN pi-inicializar IN h-acomp (INPUT "Gerando Relat¢rio":U).
    ASSIGN l-imp-cabec = YES.

    /* Exporta Excel */
    ASSIGN c-export          = "":U
           c-cab             = "":U
           c-format          = "":U
           c-format-cab      = "":U
           c-caminho-arquivo = "":U.

   /* ASSIGN c-caminho-arquivo = SESSION:TEMP-DIRECTORY + c-seg-usuario. */
    ASSIGN c-caminho-arquivo = c-dir-arquivo-session + c-seg-usuario.

    OS-CREATE-DIR VALUE(c-caminho-arquivo).

    ASSIGN c-caminho-arquivo = c-caminho-arquivo + "/" + "ESCCP008.csv".
    ASSIGN c-caminho-arquivo = REPLACE(c-caminho-arquivo, "~\":U, "/":U).

    /* Elimina arquivo j  existente */
    OS-DELETE VALUE(c-caminho-arquivo) NO-ERROR.

    /* Inicia Exporta‡Æo */
    OUTPUT TO VALUE(c-caminho-arquivo) CONVERT TARGET "iso8859-1":U.

    FIND FIRST usuar-mater NO-LOCK
        WHERE usuar-mater.cod-usuario = c-seg-usuario NO-ERROR.

    ASSIGN l-usuar-comprador = IF AVAIL usuar-mater THEN usuar-mater.usuar-comprador ELSE NO.

    RUN esp/es0018p.p (INPUT "ESCCP008":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    IF CAN-FIND (FIRST tt-prog-ponto
                 WHERE tt-prog-ponto.conteudo = c-seg-usuario) THEN DO:
        ASSIGN l-usuar-comprador = YES.
    END.

    /* Exporta cabe‡alho */
    RUN piCabecalhoExcel.
    PUT c-cab FORMAT c-format-cab.
    PUT SKIP.

    /* Exporta de acordo com a classifica‡Æo */
    IF tt-param.i-classif = 1 THEN
        RUN piExportaExcel1.
    ELSE
        RUN piExportaExcel2.

    OUTPUT CLOSE.
    
    IF tt-param.i-distribuicao = 1 /*Todos*/ THEN
        RUN pi-envia-email("comprador", tt-param.c-email-2).

    RUN pi-envia-email("supervisor", tt-param.c-email).


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

PROCEDURE pi-envia-email :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF INPUT PARAMETER c-destino AS CHAR NO-UNDO.
   DEF INPUT PARAMETER c-mail    AS CHAR NO-UNDO.

        
   IF c-mail <> "" THEN DO:
       assign c-endereco    = c-mail
           c-arquivo        = c-caminho-arquivo
           c-texto-html[1]  = "Segue arquivo contendo Entregas previstas. "
           c-texto-html[2]  = (if c-destino = "fornecedor" then
                                  "A file containing forecasted deliveries "
                                + "is attached to this mail"
                               else 
                                  "")
           c-titulo         = "Relatorio de entregas previstas"
                            + (if c-destino = "fornecedor" then 
                                 (" - Fornecedor: " + tt-oc.nome-abrev)
                               else if c-destino = "comprador" then
                                 (" - Comprador: " + tt-oc.cod-comprado)
                               else 
                                 " - Supervisao").

        run pi-acompanhar in h-acomp (input "Enviando Email: " + c-endereco).
    
        RUN enviaMail (INPUT c-remetente,
                       INPUT c-endereco,
                       INPUT trim(c-titulo),
                       INPUT c-texto-html[1] + "~n" + c-texto-html[2],
                       INPUT c-arquivo).
   END.
END PROCEDURE.


PROCEDURE pi-cria-tabela:

    IF NOT tt-param.l-confirmada AND prazo-compra.situacao = 2 /*Confirmada*/ THEN NEXT.

    IF NOT tt-param.l-eliminada  AND prazo-compra.situacao = 4 /*Eliminada*/ THEN NEXT.

    IF NOT tt-param.l-recebida   AND prazo-compra.situacao = 6 /*Recebida*/ THEN NEXT.

    IF tt-param.l-dependente AND NOT tt-param.l-independente AND ITEM.demanda = 2 THEN NEXT.

    IF tt-param.l-dependente AND NOT tt-param.l-independente AND ITEM.demanda = 1 AND ITEM.tipo-contr = 4 THEN NEXT.

    IF NOT tt-param.l-dependente AND tt-param.l-independente AND ITEM.demanda = 1 THEN NEXT.

/*     IF ordem-compra.cod-cond-pag <> 0 THEN DO:                                           */
/*         find first cond-pagto where                                                      */
/*                    cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag no-lock no-error. */
/*                                                                                          */
/*         if not avail cond-pagto then next.                                               */
/*                                                                                          */
/*         if  cond-pagto.cod-vencto = 3 then next.                                         */
/*     END.                                                                                 */

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emite = ordem-compra.cod-emite NO-ERROR.

    IF NOT tt-param.l-nacionais AND emitente.natureza <= 2 THEN NEXT.        
    IF NOT tt-param.l-importados AND emitente.natureza >= 3 THEN NEXT.

    FIND FIRST cotacao-item NO-LOCK 
         WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
           AND cotacao-item.cod-emitente = ordem-compra.cod-emitente NO-ERROR.

    FIND FIRST int-cotacao-item OF cotacao-item NO-LOCK NO-ERROR.

    IF AVAIL cotacao-item THEN 
        FIND FIRST itinerario NO-LOCK 
             WHERE itinerario.cod-itiner = cotacao-item.int-1 NO-ERROR.
    
    FIND LAST ordens-embarque NO-LOCK 
        WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
          AND ordens-embarque.parcela      = prazo-compra.parcela NO-ERROR.

    ASSIGN c-embarque       = "&nbsp;"
           c-incortem       = "&nbsp;"      
           c-itiner         = "&nbsp;"         
           c-pto-contr-base = "&nbsp;"
           c-emb-conhec     = "&nbsp;".

    FIND FIRST embarque-imp NO-LOCK 
         WHERE embarque-imp.cod-estabel = ordens-embarque.cod-estabel 
           AND embarque-imp.embarque    = ordens-embarque.embarque NO-ERROR.
    IF AVAIL embarque-imp THEN DO:

        ASSIGN c-embarque       = embarque-imp.embarque
               c-emb-conhec     = embarque-imp.cod-conhecto-master
               c-incortem       = STRING(embarque-imp.cod-incoterm   )
               c-itiner         = STRING(cotacao-item.int-1          )
               c-pto-contr-base = SUBSTRING(cotacao-item.char-1,41,20).
    END.

    /* Inicio Calculo Pesos */
    ASSIGN d-peso-liquido   = 0
           d-peso-bruto     = 0.

    FOR EACH bf-embarque NO-LOCK
       WHERE bf-embarque.numero-ordem = ordens-embarque.numero-ordem  
         AND bf-embarque.parcela      = ordens-embarque.parcela:

        IF DEC(SUBSTRING(bf-embarque.char-2,9,17)) = 0 THEN
            ASSIGN d-peso-liquido = d-peso-liquido + (ITEM.peso-liquido * bf-embarque.quantidade).
        ELSE
            ASSIGN d-peso-liquido = d-peso-liquido + DEC(SUBSTRING(bf-embarque.char-2,9,17)).

        IF DEC(SUBSTRING(bf-embarque.char-2,26,17)) = 0 THEN
            ASSIGN d-peso-bruto = d-peso-bruto + (ITEM.peso-bruto * bf-embarque.quantidade).
        ELSE
            ASSIGN d-peso-bruto = d-peso-bruto + DEC(SUBSTRING(bf-embarque.char-2,26,17)).

    END.
    /* Fim Calculo Pesos */

    FIND FIRST historico-embarque NO-LOCK 
         WHERE historico-embarque.cod-estabel   = ordem-compra.cod-estabel
           AND historico-embarque.embarque      = ordens-embarque.embarque 
           AND historico-embarque.cod-itiner    = cotacao-item.int-1       
           AND historico-embarque.cod-pto-contr = itinerario.pto-embarque NO-ERROR.

    ASSIGN c-data  = (IF AVAIL historico-embarque THEN
                         IF historico-embarque.dt-efetiva = ? THEN
                            STRING(historico-embarque.dt-ult-previsao, "99/99/9999")
                         ELSE
                            STRING(historico-embarque.dt-efetiva, "99/99/9999")
                      ELSE
                         "&nbsp;").

    FIND FIRST historico-embarque NO-LOCK 
         WHERE historico-embarque.cod-estabel   = ordem-compra.cod-estabel 
           AND historico-embarque.embarque      = ordens-embarque.embarque 
           AND historico-embarque.cod-itiner    = cotacao-item.int-1       
           AND historico-embarque.cod-pto-contr = itinerario.pto-despacho NO-ERROR.

    ASSIGN c-despacho  = (IF AVAIL historico-embarque THEN
                         IF historico-embarque.dt-efetiva = ? THEN
                            STRING(historico-embarque.dt-ult-previsao, "99/99/9999")
                         ELSE
                            STRING(historico-embarque.dt-efetiva, "99/99/9999")
                      ELSE
                         "&nbsp;").

    /*Ultimo Ponto de controle efetivado*/
    FOR LAST historico-embarque NO-LOCK
       WHERE historico-embarque.cod-estabel = ordens-embarque.cod-estabel
         AND historico-embarque.embarque    = ordens-embarque.embarque
         AND historico-embarque.dt-efetiva <> ?
       BREAK BY historico-embarque.dt-efetiva:
    END.

    FIND FIRST pto-contr NO-LOCK
         WHERE pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr NO-ERROR.

    ASSIGN c-des-ult-pto-contr  = IF AVAIL pto-contr          THEN pto-contr.descricao ELSE ""
           c-data-ult-pto-contr = IF AVAIL historico-embarque AND historico-embarque.dt-efetiva <> ? THEN STRING(historico-embarque.dt-efetiva) ELSE ""
           c-navio              = IF AVAIL historico-embarque THEN historico-embarque.id-meio-transp     ELSE "".

    run pi-acompanhar in h-acomp (INPUT "Ordem: " + TRIM(STRING(ordem-compra.numero-ordem)) + " - " + TRIM(STRING(ordem-compra.it-codigo)) + " - " + STRING(prazo-compra.data-entrega,"99/99/9999")).
    CREATE tt-oc.
    IF ordem-compra.it-codigo = "" THEN 
       ASSIGN tt-oc.descricao = tt-oc.descricao + ordem-compra.narrativa + "<BR>".
    ELSE 
       ASSIGN tt-oc.descricao = item.desc-item.

    /*FIND usuar-mater NO-LOCK
         WHERE usuar-mater.cod-usuario = ITEM.cod-comprado NO-ERROR.*/

    for first comprador fields (nome)
        where comprador.cod-comprado = ordem-compra.cod-comprado no-lock: 
    end.
    if  available comprador then 
        assign c-nome-comprado = comprador.nome.
    else 
        assign c-nome-comprado = "&nbsp;".

    /* Imprimir dados OEM */
    FIND item-uni-estab NO-LOCK
        WHERE item-uni-estab.it-codigo   = ordem-compra.it-codigo
          AND item-uni-estab.cod-estabel = ordem-compra.cod-estabel NO-ERROR.

    IF AVAIL item-uni-estab 
    THEN DO:
        RUN esp/pdp/espdp015rp-un.p (INPUT item-uni-estab.cod-unid-negoc).
        ASSIGN c-des-unid-negoc = RETURN-VALUE.
        IF c-des-unid-negoc = "" THEN
            ASSIGN c-des-unid-negoc = "&nbsp;".
    END.
    ELSE
        ASSIGN c-des-unid-negoc = "&nbsp;".

    IF tt-param.l-oem THEN DO:        
        FIND FIRST it-altern
             WHERE it-altern.it-altern = ordem-compra.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL it-altern THEN
            ASSIGN c-it-altern = it-altern.it-codigo.
        ELSE
            ASSIGN c-it-altern = "&nbsp;".            

        ASSIGN de-qtidade-atu = 0.
        IF AVAIL it-altern THEN DO:            
            FOR EACH saldo-estoq NO-LOCK
               WHERE saldo-estoq.cod-estabel = "101"
                 AND saldo-estoq.it-codigo   = it-altern.it-codigo:

                IF  saldo-estoq.cod-depos = "rec":U OR
                    saldo-estoq.cod-depos = "alm":U OR 
                    saldo-estoq.cod-depos = "exp":U OR 
                    saldo-estoq.cod-depos = "wal":U THEN
                    ASSIGN de-qtidade-atu = de-qtidade-atu + saldo-estoq.qtidade-atu.
            END.
            FOR EACH saldo-estoq NO-LOCK
               WHERE saldo-estoq.cod-estabel = "104"
                 AND saldo-estoq.it-codigo   = it-altern.it-codigo:

                IF  saldo-estoq.cod-depos = "rec":U OR
                    saldo-estoq.cod-depos = "alm":U OR 
                    saldo-estoq.cod-depos = "wex":U OR 
                    saldo-estoq.cod-depos = "wal":U THEN
                    ASSIGN de-qtidade-atu = de-qtidade-atu + saldo-estoq.qtidade-atu.
            END.
        END.
        
    END.
    ELSE
        ASSIGN c-it-altern      = "&nbsp;".

    IF AVAIL embarque-imp THEN
        RUN pi-situacao.

    FIND FIRST tt-emb NO-ERROR.
    IF AVAIL tt-emb THEN DO:
        CASE tt-emb.situacao:
            WHEN 99 THEN ASSIGN c-situacao = "Agt".
            WHEN 1  THEN ASSIGN c-situacao = "Prev".
            WHEN 2  THEN ASSIGN c-situacao = "Embar".
            WHEN 98 THEN ASSIGN c-situacao = "DI".
            WHEN 3  THEN ASSIGN c-situacao = "Desp".
            WHEN 4  THEN ASSIGN c-situacao = "NF".
            WHEN 96  THEN ASSIGN c-situacao = "Inst".
            WHEN 97  THEN ASSIGN c-situacao = "Manut".
        END CASE.
    END.
    ELSE
        ASSIGN c-situacao = "Ped".

    RELEASE embarque-imp.
    EMPTY TEMP-TABLE tt-emb.

    FOR FIRST int-item-fornec-estab NO-LOCK
        WHERE int-item-fornec-estab.it-codigo = ordem-compra.it-codigo
        AND   int-item-fornec-estab.cod-emitente = ordem-compra.cod-emite
        AND   int-item-fornec-estab.cod-estabel = ordem-compra.cod-estabel:
    END.

    /**/

    FIND FIRST grup-estoq NO-LOCK
         WHERE grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.

    ASSIGN tt-oc.cod-emite       = STRING(ordem-compra.cod-emite, ">>>,>>9")
           tt-oc.cod-comprado    = ordem-compra.cod-comprado
           tt-oc.cod-unid-negoc  = ordem-compra.cod-unid-negoc
           tt-oc.ge-codigo       = STRING(ITEM.ge-codigo)
           tt-oc.ge-descricao    = grup-estoq.descricao
           /*
           tt-oc.cod-comprado = IF item.it-codigo = "" THEN pedido-compr.responsavel
                                ELSE IF AVAIL usuar-mater THEN 
                                    ENTRY(1,usuar-mater.nome," ") ELSE pedido-compr.responsavel
           */

           tt-oc.nome-comprado    = c-nome-comprado
           tt-oc.nome-abrev       = emitente.nome-abrev
           tt-oc.cod-depos        = ordem-compra.dep-almoxar
           tt-oc.fone             = emitente.telefone[1]
           tt-oc.dt-orig          = string(prazo-compra.data-orig, "99/99/9999")
           tt-oc.dt-entrega       = string(prazo-compra.data-entrega, "99/99/9999")
           tt-oc.situacao-parcela = IF prazo-compra.situacao = 2 THEN "Confirmada" ELSE
                                    IF prazo-compra.situacao = 4 THEN "Eliminada"  ELSE "Recebida" .  
    ASSIGN tt-oc.dt-despacho        = c-despacho
           tt-oc.dt-embarque        = c-data
           tt-oc.dt-pedido          = STRING(pedido-compr.data-pedido, "99/99/9999")
           tt-oc.nr-conhecimento    = IF c-emb-conhec = ? THEN "" ELSE c-emb-conhec
           tt-oc.embarque           = c-embarque
           tt-oc.des-ult-pto-contr  = c-des-ult-pto-contr 
           tt-oc.data-ult-pto-contr = c-data-ult-pto-contr
           tt-oc.navio              = c-navio             
           tt-oc.incortem           = c-incortem      
           tt-oc.itiner             = c-itiner        
           tt-oc.pto-contr-base     = c-pto-contr-base
           tt-oc.peso-bruto         = STRING(d-peso-bruto,">>>,>>>,>>9.99999")
           tt-oc.peso-liquido       = STRING(d-peso-liquido, ">>>,>>>,>>9.99999")
           tt-oc.num-pedido         = string(ordem-compra.num-pedido, ">>>,>>9")
           tt-oc.numero-ordem       = string(ordem-compra.numero-ordem, ">>>,>>9,99")
           tt-oc.parcela            = string(prazo-compra.parcela, ">9")
           tt-oc.cod-estabel        = ordem-compra.cod-estabel
           tt-oc.ordem-serv         = string(ordem-compra.ordem-serv, ">>>,>>>,>>9")
           tt-oc.it-codigo          = (IF ordem-compra.it-codigo = "" THEN
                                    "&nbsp;"
                                 ELSE 
                                    ordem-compra.it-codigo)
           tt-oc.un           = (IF item.un = "" THEN 
                                    "&nbsp;"
                                  ELSE 
                                     item.un).

           IF ITEM.ge-codigo = 0 THEN
               ASSIGN tt-oc.class-fiscal = SUBSTR(cotacao-item.char-1,81,20).
           ELSE 
               ASSIGN tt-oc.class-fiscal = STRING(ITEM.class-fiscal).

    FIND FIRST usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuario = ordem-compra.requisitante NO-ERROR.

    FIND FIRST int-pedido-compr NO-LOCK
         WHERE int-pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR.

    FIND FIRST int-prazo-compra NO-LOCK
         WHERE int-prazo-compra.numero-ordem = prazo-compra.numero-ordem
           AND int-prazo-compra.parcela      = prazo-compra.parcela NO-ERROR.

    ASSIGN tt-oc.narrativa       = ITEM.narrativa
           tt-oc.quantidade      = string(prazo-compra.quantidade, ">>>,>>>,>>9.99999")
           tt-oc.qtd-receb       = string(prazo-compra.quant-receb, ">>>,>>>,>>9.99999")
           tt-oc.qtd-saldo       = string(prazo-compra.quant-saldo, ">>>,>>>,>>9.99999")
           tt-oc.qtd-do-forn     = string(prazo-compra.qtd-do-forn, ">>>,>>>,>>9.99999")               
           tt-oc.un-do-forn      = cotacao-item.un
           tt-oc.atraso          = string((today - prazo-compra.data-entrega), "->>>>>>>>9")
           tt-oc.aliq-ipi        = STRING(ordem-compra.aliquota-ipi) + "%"
           tt-oc.cnpj            = emitente.cgc
           tt-oc.des-unid-negoc  = c-des-unid-negoc
           tt-oc.it-altern       = c-it-altern
           tt-oc.saldo-estoq     = (IF tt-param.l-oem THEN STRING(de-qtidade-atu,">>>,>>>,>>9.9999")     ELSE "&nbsp;")
           tt-oc.via-transp      = (IF tt-param.l-oem THEN {adinc/i01ad268.i 04 pedido-compr.via-transp} ELSE "&nbsp;")
           tt-oc.situacao        = c-situacao
           tt-oc.narrativa-ordem = REPLACE(REPLACE(ordem-compra.narrativa,CHR(10)," "),"<BR>","")
           tt-oc.requisitante    = ordem-compra.requisitante
           tt-oc.nome-requis     = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "&nbsp;"           
           tt-oc.tipo-pedido     = IF AVAIL int-pedido-compr THEN ENTRY(int-pedido-compr.tp-pedido,c-tp-pedido,",") ELSE "&nbsp;"
           tt-oc.nr-nf           = IF AVAIL int-prazo-compra THEN int-prazo-compra.nro-docto ELSE "&nbsp;"
           tt-oc.dt-necessidade  = if avail int-prazo-compra then string(int-prazo-compra.data-necessidade,"99/99/9999") else "".

      IF tt-oc.peso-bruto   = ? THEN ASSIGN tt-oc.peso-bruto   = STRING(0).
      IF tt-oc.peso-liquido = ? THEN ASSIGN tt-oc.peso-liquido = STRING(0).

      /* Busca Part Number do item fornecedor */
      ASSIGN tt-oc.cod-pn-fabric = "Sem Rela‡Æo".
      FIND FIRST item-fornec-estab NO-LOCK
           WHERE item-fornec-estab.it-codigo    = tt-oc.it-codigo
             AND item-fornec-estab.cod-emitente = INT(tt-oc.cod-emite)
             AND item-fornec-estab.cod-estabel  = tt-oc.cod-estabel  NO-ERROR.
      IF  AVAIL item-fornec-estab
      THEN DO:
          FIND FIRST item-fabric NO-LOCK
               WHERE item-fabric.it-codigo  = item-fornec-estab.it-codigo
                 AND ITEM-fabric.cod-fabric = INT(item-fornec-estab.item-do-for) NO-ERROR.
          IF  AVAIL item-fabric
          THEN DO:

              FOR FIRST fabricante NO-LOCK
                  WHERE fabricante.cod-fabric = INT(item-fornec-estab.item-do-for).

                  ASSIGN tt-oc.cod-fabric = fabricante.cod-fabric
                         tt-oc.desc-fabric = fabricante.nome-abrev
                         tt-oc.ativo-fabric = IF fabricante.ativo THEN "Sim" ELSE "NÆo".
              END.
              ASSIGN tt-oc.cod-pn-fabric = item-fabric.it-fabric.
          END.
      END.
      /* Fim Busca Part Number do item fornecedor */


      /* Busca Contato Fornecedor */
      FIND FIRST cont-emit NO-LOCK
          WHERE  cont-emit.cod-emitente = ordem-compra.cod-emitente NO-ERROR.

      IF  AVAIL cont-emit
      THEN
          ASSIGN tt-oc.nome-contato  = cont-emit.nome    
                 tt-oc.fone-contato  = cont-emit.telefone
                 tt-oc.email-contato = cont-emit.e-mail.
      /* Fim Busca Contato Fornecedor */

      FIND FIRST int-item 
           WHERE int-item.it-codigo = ITEM.it-codigo NO-LOCK NO-ERROR.
      if avail int-item then
          assign l-antidumping = int-item.log-antidumping.
      else
          assign l-antidumping = no.

      FIND FIRST int-item-uni-estab no-lock
           WHERE int-item-uni-estab.cod-estabel = ITEM.cod-estabel 
             AND int-item-uni-estab.it-codigo   = item.it-codigo no-error.
      IF AVAIL int-item-uni-estab THEN
          assign c-observacao = int-item-uni-estab.observacao.
      ELSE 
          assign c-observacao = "".

      ASSIGN tt-oc.ex-tarif   = IF AVAIL int-item THEN int-item.ex-tarifario      ELSE "&nbsp;"
             tt-oc.destaque   = IF AVAIL int-item THEN STRING(int-item.destaque)  ELSE "&nbsp;"
             tt-oc.gatt       = IF AVAIL int-item THEN STRING(int-item.perc-gatt) ELSE "&nbsp;"
             tt-oc.nec-li     = IF ITEM.log-necessita-li THEN "X" ELSE "&nbsp;"
             tt-oc.nec-inspec = IF AVAIL int-item-fornec-estab AND int-item-fornec-estab.log-nec-inspec THEN "X" ELSE "&nbsp;"
             tt-oc.antidump   = IF l-antidumping THEN "X" ELSE "&nbsp;"
             tt-oc.observacao = c-observacao.

      IF  tt-oc.ex-tarif = ? OR tt-oc.ex-tarif = "" THEN ASSIGN tt-oc.ex-tarif = "&nbsp;".
      IF  tt-oc.destaque = ? OR tt-oc.destaque = "" THEN ASSIGN tt-oc.destaque = "&nbsp;".
      IF  tt-oc.gatt = ? THEN ASSIGN tt-oc.gatt = "&nbsp;".

      FIND FIRST cond-pagto NO-LOCK
           WHERE cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag NO-ERROR.
      IF AVAIL cond-pagto THEN
          ASSIGN tt-oc.cond-pagto = TRIM(STRING(pedido-compr.cod-cond-pag)) + " - " + TRIM(cond-pagto.descricao).
      ELSE
          ASSIGN tt-oc.cond-pagto = TRIM(STRING(pedido-compr.cod-cond-pag)).

      
      /* - em coment rios para libera‡Æo de corre‡Æo simples antes do FFT .... 
      
      FOR FIRST emitente NO-LOCK
          WHERE emitente.cod-emitente = pedido-compr.cod-emitente:
          FIND FIRST int-tb-pr-cc NO-LOCK
              WHERE int-tb-pr-cc.cod-cond-pag = pedido-compr.cod-cond-pag
                AND int-tb-pr-cc.nome-abrev   = emitente.nome-abrev NO-ERROR.
          IF AVAIL int-tb-pr-cc THEN
              ASSIGN tt-oc.cod-libera-fft = int-tb-pr-cc.cod-libera-fft.
          ELSE
              ASSIGN tt-oc.cod-libera-fft = 0.
      END.                                    
      
      */

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

          ASSIGN tt-oc.vl-custo-it = TRIM(STRING(cotacao-item.preco-fornec, "->>>,>>>,>>9.99999":U))
                 tt-oc.des-moeda   = IF AVAILABLE moeda THEN moeda.descricao ELSE "-":U
                 tt-oc.vl-unit     = TRIM(STRING(cotacao-item.preco-fornec * de-cotacao,"->>>,>>>,>>9.99999"))
                 tt-oc.vl-unit-ipi = TRIM(STRING(cotacao-item.pre-unit-for * de-cotacao,"->>>,>>>,>>9.99999"))
                 tt-oc.ipi-incluso = TRIM(STRING(cotacao-item.codigo-ipi,"Sim/Nao")).
      END.
      ELSE ASSIGN tt-oc.vl-custo-it = "&nbsp;"
                  tt-oc.des-moeda   = "&nbsp;"
                  tt-oc.vl-unit     = "&nbsp;"
                  tt-oc.vl-unit-ipi = "&nbsp;"
                  tt-oc.ipi-incluso = "&nbsp;".

      FOR FIRST mensagem FIELDS (descricao) NO-LOCK
          WHERE mensagem.cod-mensagem = pedido-compr.cod-mensagem: 
      END.
      ASSIGN tt-oc.cod-mensagem  = STRING(pedido-compr.cod-mensagem)
             tt-oc.desc-mensagem = IF AVAIL mensagem THEN mensagem.descricao ELSE ""
             tt-oc.ct-codigo = ordem-compra.ct-codigo
             tt-oc.sc-codigo = ordem-compra.sc-codigo.

        

END PROCEDURE.

PROCEDURE pi-situacao :
    {esp/imp/esimp000.i}
END PROCEDURE.

PROCEDURE piCabecalhoExcel:
    
    /* Criar Cabe‡alho */
    IF tt-param.i-classif = 1 THEN DO:        

        IF  tt-param.l-lista-contatos = YES
        THEN
            ASSIGN c-cab = "C¢digo Forn."       + ";" +
                           "Nome Forn."         + ";" +
                           "Contato"            + ";" +
                           "Telefone"           + ";" +
                           "E-mail"             + ";" +
                           "Dt Original"        + ";" +
                           "Necessidade"        + ";" +
                           "Dt Entrega"         + ";" +
                           "Situa‡Æo Parcela"   + ";" +
                           "Item"               + ";".
        ELSE
            ASSIGN c-cab = "C¢digo Forn."       + ";" +
                           "Nome Forn."         + ";" +
                           "Dt Original"        + ";" + 
                           "Necessidade"        + ";" +
                           "Dt Entrega"         + ";" +
                           "Situa‡Æo Parcela"   + ";" +
                           "Item"               + ";".

        IF tt-param.l-narrativa-ordem THEN
            ASSIGN c-cab = c-cab + "Narrativa Ordem" + ";".

        ASSIGN c-cab = c-cab                + 
                       "Descri‡Æo"          + ";" +
                       "Uni-Neg. OC"        + ";" +
                       "Grupo Estoq"        + ";" +
                       "Des Grupo Estoq"    + ";" +
                       "C¢d.Fabric"         + ";" +
                       "Desc.Fabric"        + ";" +                       
                       "Situa‡Æo Fabric"    + ";" +
                       "PN Fabric"          + ";" +
                       "NCM"                + ";" +
                       "Destaque"           + ";" +
                       "EX Tarif rio"       + ";" +
                       "GATT"               + ";" +
                       "Necessita LI"       + ";" +
                       "Necessita Inspe‡Æo" + ";" +
                       "Antidumping"        + ";" +
                       "Observa‡ao LOG"     + ";" +
                       "Dt Pedido"          + ";".
    END.
    ELSE DO:
        ASSIGN c-cab = "Item"               + ";".

        IF tt-param.l-narrativa-ordem THEN
            ASSIGN c-cab = c-cab + "Narrativa Ordem" + ";".

        ASSIGN c-cab = c-cab                +
                       "Descri‡Æo"          + ";" + 
                       "Uni-Neg. OC"        + ";" +
                       "Grupo Estoq"        + ";" +
                       "Des Grupo Estoq"    + ";" +
                       "C¢d.Fabric"         + ";" +
                       "Desc.Fabric"        + ";" +                       
                       "Situa‡Æo Fabric"    + ";" +
                       "PN Fabric"          + ";" +
                       "NCM"                + ";" +
                       "Destaque"           + ";" +
                       "EX Tarif rio"       + ";" +
                       "GATT"               + ";" +
                       "Necessita LI"       + ";" +
                       "Necessita Inspe‡Æo" + ";" +
                       "Antidumping"        + ";" +
                       "Observa‡ao LOG"     + ";" +
                       "Dt Original"        + ";" + 
                       "Necessidade"        + ";" +
                       "Dt Entrega"         + ";" +
                       "Situa‡Æo Parcela"   + ";" +
                       "C¢digo Forn."       + ";" +
                       "Nome Forn."         + ";".

        IF  tt-param.l-lista-contatos = YES
        THEN
            ASSIGN c-cab = c-cab       +
                          "Contato"    + ";" +
                          "Telefone"   + ";" +
                          "E-mail"     + ";" +
                          "Dt Pedido"  + ";".
        ELSE
            ASSIGN c-cab = c-cab       +
                           "Dt Pedido" + ";".
    END.

    IF l-usuar-comprador THEN DO:
        ASSIGN c-cab = c-cab                +                  
                       "Pedido"             + ";" +                                     
                       "Ordem"              + ";" +                                     
                       "Custo Item"         + ";" +                                     
                       "Moeda"              + ";" +                                     
                       "Par."               + ";" +                                     
                       "Situa‡Æo"           + ";" +
                       "Estab."             + ";" +                                     
                       "Cond. Pagto"        + ";" +

                       /* - em coment rios para libera‡Æo de corre‡Æo simples antes do FFT .... 
                       "Libera FFT"         + ";" +
                       */
                       
                       "Comprador"          + ";".        
                                                                                    
    
        ASSIGN c-cab = c-cab                +                                                          
                       "Quantidade"         + ";" +                                     
                       "UN"                 + ";" + 
                       "Qt Fornec"          + ";" +                                     
                       "Un Fornec"          + ";" +                                     
                       "Pre‡o Unit rio"     + ";" +                                     
                       "IPI"                + ";" +                                     
                       "Preco Unit. IPI"    + ";" +                                     
                       "IPI Incluso"        + ";" +                                     
                       "Qtd Receb."         + ";" +                                     
                       "Qtd Saldo"          + ";" +                                     
                       "Atraso"             + ";" +                                     
                       "CNPJ"               + ";" +                                     
                       "Dep"                + ";".
    END.
    ELSE DO:
        ASSIGN c-cab = c-cab                +                  
                       "Pedido"             + ";" +                                     
                       "Ordem"              + ";" +                                     
                       "Moeda"              + ";" +                                     
                       "Par."               + ";" +                                     
                       "Situa‡Æo"           + ";" +
                       "Estab."             + ";" +                                     
                       "Cond. Pagto"        + ";" +

                       /* - em coment rios para libera‡Æo de corre‡Æo simples antes do FFT .... 
                       "Libera FFT"         + ";" +
                       */
                       
                       "Comprador"          + ";". 

        ASSIGN c-cab = c-cab                +                                                          
                       "Quantidade"         + ";" +                                     
                       "UN"                 + ";" + 
                       "Qt Fornec"          + ";" +                                     
                       "Un Fornec"          + ";" +                                     
                       "Qtd Receb."         + ";" +                                     
                       "Qtd Saldo"          + ";" +                                     
                       "Atraso"             + ";" +                                     
                       "CNPJ"               + ";" +                                     
                       "Dep"                + ";".
    END.

    IF tt-param.l-oem THEN
        ASSIGN c-cab = c-cab            + 
                       "Item Venda."    + ";" +                                     
                       "Saldo"          + ";" +
                       "Modal"          + ";".

    IF tt-param.l-importados THEN
        ASSIGN c-cab = c-cab                + 
                       "Dt Despacho"        + ";" +                                     
                       "Dt Embarque"        + ";" +                                     
                       "Conhec. Embarque"   + ";" +                                     
                       "Embarque"           + ";" +
                       "élt. Pto. Contr."   + ";" +
                       "Data élt. Pto. Contr." + ";" +
                       "Navio"              + ";" +
                       "Icoterm"            + ";" +
                       "Itiner rio"         + ";" +
                       "Pto Contr Base"     + ";" +
                       "Peso Bruto"         + ";" +
                       "Peso L¡quido"       + ";".

    IF tt-param.l-adicionais THEN DO:
        IF l-usuar-comprador THEN DO:
            ASSIGN c-cab = c-cab                            + 
                           "Divergˆncia Data Entrega"       + ";" +
                           "Divergˆncia Nro Pedido"         + ";" +
                           "Divergˆncia Cond. Pagamento"    + ";" +
                           "Divergˆncia Quantidade"         + ";" +
                           "Divergˆncia Valor Unit rio"     + ";" +
                           "Divergˆncia IPI"                + ";" +
                           "Observa‡Æo"                     + ";" +   
                           "Status"                         + ";".
        END.
        ELSE DO:
            ASSIGN c-cab = c-cab                            + 
                           "Divergˆncia Data Entrega"       + ";" +
                           "Divergˆncia Nro Pedido"         + ";" +
                           "Divergˆncia Cond. Pagamento"    + ";" +
                           "Divergˆncia Quantidade"         + ";" +
                           "Divergˆncia IPI"                + ";" +
                           "Observa‡Æo"                     + ";" +   
                           "Status"                         + ";".
        END.
    END.

    IF tt-param.l-narrativa THEN
        ASSIGN c-cab = c-cab + "Narrativa Item" + ";".

    ASSIGN c-cab = c-cab + "Mensagem;Descri‡Æo Mensagem;Conta;C. Custo;Requisitante;Nome Requisitante;Tipo Pedido;Nr NF".
                                      
    ASSIGN c-format-cab = "x(" + STRING(LENGTH(c-cab)) + ")".

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE piExportaExcel1:

    /* Exportar dados Classifica‡Æo 1 */
    FOR EACH tt-oc USE-INDEX for-dat-it
                  BREAK BY tt-oc.cod-emite
                        BY tt-oc.dt-entrega
                        BY tt-oc.it-codigo:

        ASSIGN c-descricao = replace(replace(tt-oc.descricao,"<BR>":U,"":U),";",",").

        ASSIGN c-descricao = REPLACE(c-descricao,CHR(10), " ").

        ASSIGN c-descricao = REPLACE(c-descricao,CHR(10)," ")
               c-descricao = REPLACE(c-descricao,CHR(11)," ")
               c-descricao = REPLACE(c-descricao,CHR(12)," ")
               c-descricao = REPLACE(c-descricao,CHR(13)," ").

        IF  tt-param.l-lista-contatos = YES
        THEN
            ASSIGN c-export = tt-oc.cod-emite       + ";" +
                              tt-oc.nome-abrev      + ";" +
                              tt-oc.nome-contato    + ";" +
                              tt-oc.fone-contato    + ";" +
                              tt-oc.email-contato   + ";" +
                              tt-oc.dt-orig         + ";" +
                              tt-oc.dt-necessidade  + ";" +
                              tt-oc.dt-entrega      + ";" +
                              situacao-parcela      + ";" +
                              tt-oc.it-codigo       + ";".
        ELSE
            ASSIGN c-export = tt-oc.cod-emite       + ";" +
                              tt-oc.nome-abrev      + ";" +
                              tt-oc.dt-orig         + ";" +
                              tt-oc.dt-necessidade  + ";" +
                              tt-oc.dt-entrega      + ";" +
                              situacao-parcela      + ";" +   
                              tt-oc.it-codigo       + ";".

        IF tt-param.l-narrativa-ordem THEN
            ASSIGN c-export = c-export + tt-oc.narrativa-ordem + ";".

        IF l-usuar-comprador THEN DO:
            ASSIGN c-export = c-export                   +
                              c-descricao                + ";" +
                              tt-oc.des-unid-negoc       + ";" +
                              tt-oc.ge-codigo            + ";" +
                              tt-oc.ge-descricao         + ";" +
                              string(tt-oc.cod-fabric)   + ";" +
                              tt-oc.desc-fabric          + ";" +
                              tt-oc.ativo-fabric         + ";" +
                              tt-oc.cod-pn-fabric        + ";" +
                              tt-oc.class-fiscal         + ";" +
                              tt-oc.destaque             + ";" + 
                              tt-oc.ex-tarif             + ";" +
                              tt-oc.gatt                 + ";" +
                              tt-oc.nec-li               + ";" +
                              tt-oc.nec-inspec           + ";" +
                              tt-oc.antidump             + ";" +
                              tt-oc.observacao           + ";" +
                              tt-oc.dt-pedido            + ";" +
                              tt-oc.num-pedido           + ";" +
                              tt-oc.numero-ordem         + ";" +
                              tt-oc.vl-custo-it          + ";" +
                              tt-oc.des-moeda            + ";" +
                              tt-oc.parcela              + ";" +
                              tt-oc.situacao             + ";" +
                              tt-oc.cod-estabel          + ";" +
                              tt-oc.cond-pagto           + ";" +

                       /* - em coment rios para libera‡Æo de corre‡Æo simples antes do FFT .... 
                       STRING(tt-oc.cod-libera-fft) + ";" +
                       */

                              tt-oc.cod-comprado    + ";" +
                              tt-oc.quantidade      + ";" +
                              tt-oc.un              + ";" +
                              tt-oc.qtd-do-forn     + ";" +
                              tt-oc.un-do-forn      + ";" +
                              tt-oc.vl-unit         + ";" +
                              tt-oc.aliq-ipi        + ";" +
                              tt-oc.vl-unit-ipi     + ";" +
                              tt-oc.ipi-incluso     + ";" +
                              tt-oc.qtd-receb       + ";" +
                              tt-oc.qtd-saldo       + ";" +
                              tt-oc.atraso          + ";" +
                              tt-oc.cnpj            + ";" +
                              tt-oc.cod-depos       + ";".
        END.
        ELSE DO:
            ASSIGN c-export = c-export                   +
                              c-descricao                + ";" +
                              tt-oc.des-unid-negoc       + ";" +
                              tt-oc.ge-codigo            + ";" +
                              tt-oc.ge-descricao         + ";" +
                              string(tt-oc.cod-fabric)   + ";" +
                              tt-oc.desc-fabric          + ";" +
                              tt-oc.ativo-fabric         + ";" +
                              tt-oc.cod-pn-fabric        + ";" +
                              tt-oc.class-fiscal         + ";" +
                              tt-oc.destaque             + ";" + 
                              tt-oc.ex-tarif             + ";" +
                              tt-oc.gatt                 + ";" +
                              tt-oc.nec-li               + ";" +
                              tt-oc.nec-inspec           + ";" +
                              tt-oc.antidump             + ";" +
                              tt-oc.observacao           + ";" +
                              tt-oc.dt-pedido            + ";" +
                              tt-oc.num-pedido           + ";" +
                              tt-oc.numero-ordem         + ";" +
                              tt-oc.des-moeda            + ";" +
                              tt-oc.parcela              + ";" +
                              tt-oc.situacao             + ";" +
                              tt-oc.cod-estabel          + ";" +
                              tt-oc.cond-pagto           + ";" +

                       /* - em coment rios para libera‡Æo de corre‡Æo simples antes do FFT .... 
                       STRING(tt-oc.cod-libera-fft) + ";" +
                       */
                       
                              tt-oc.cod-comprado    + ";" +
                              tt-oc.quantidade      + ";" +
                              tt-oc.un              + ";" +
                              tt-oc.qtd-do-forn     + ";" +
                              tt-oc.un-do-forn      + ";" +
                              tt-oc.qtd-receb       + ";" +
                              tt-oc.qtd-saldo       + ";" +
                              tt-oc.atraso          + ";" +
                              tt-oc.cnpj            + ";" +
                              tt-oc.cod-depos       + ";".
        END.

        IF tt-param.l-oem THEN
            ASSIGN c-export = c-export              + 
                              tt-oc.it-altern       + ";" +
                              tt-oc.saldo-estoq     + ";" +
                              tt-oc.via-transp      + ";".

        IF tt-param.l-importados THEN
            ASSIGN c-export = c-export              + 
                              tt-oc.dt-despacho     + ";" + 
                              tt-oc.dt-embarque     + ";" + 
                              tt-oc.nr-conhecimen   + ";" +
                              tt-oc.embarque        + ";" +
                              tt-oc.des-ult-pto-contr + ";" + 
                              tt-oc.data-ult-pto-contr + ";" + 
                              tt-oc.navio           + ";" +   
                              tt-oc.incortem        + ";" +
                              tt-oc.itiner          + ";" +
                              tt-oc.pto-contr-base  + ";" +
                              tt-oc.peso-bruto      + ";" +
                              tt-oc.peso-liquido    + ";".

        IF tt-param.l-narrativa THEN
            ASSIGN c-export = c-export + tt-oc.narrativa + ";".

        ASSIGN c-export = c-export + 
                          tt-oc.cod-mensagem  + ";" +
                          tt-oc.desc-mensagem + ";" +
                          tt-oc.ct-codigo     + ";" +
                          tt-oc.sc-codigo     + ";" +
                          tt-oc.requisitante  + ";" +
                          tt-oc.nome-requis   + ";" +
                          tt-oc.tipo-pedido   + ";" +
                          tt-oc.nr-nf         + ";".

        /* Retira Informa‡äes Desnecess rias */
        ASSIGN c-export = REPLACE(c-export,"&nbsp;":U, "":U).

        ASSIGN c-format = "x(" + STRING(LENGTH(c-export)) + ")".

        /* Exportar Dados */
        PUT UNFORMATTED c-export /*FORMAT c-format*/.
        PUT SKIP.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE piExportaExcel2:

     /* Exportar dados Classifica‡Æo 2 */
    FOR EACH tt-oc USE-INDEX it-dat-for
                BREAK BY tt-oc.cod-comprado
                      BY tt-oc.it-codigo
                      BY tt-oc.dt-entrega:

        ASSIGN c-descricao = replace(replace(tt-oc.descricao,"<BR>":U,"":U),";",",").

        ASSIGN c-descricao = REPLACE(c-descricao,CHR(10), " ").

        ASSIGN c-export = tt-oc.it-codigo + ";".

        IF tt-param.l-narrativa-ordem THEN
            ASSIGN c-export = c-export + tt-oc.narrativa-ordem + ";".

        ASSIGN c-export = c-export              +
                          c-descricao           + ";" +
                          tt-oc.des-unid-negoc  + ";" +
                          tt-oc.ge-codigo       + ";" +
                          tt-oc.ge-descricao    + ";" +
                          string(tt-oc.cod-fabric)   + ";" +
                          tt-oc.desc-fabric          + ";" +
                          tt-oc.ativo-fabric         + ";" +
                          tt-oc.cod-pn-fabric        + ";" +
                          tt-oc.class-fiscal    + ";" +  
                          tt-oc.destaque        + ";" + 
                          tt-oc.ex-tarif        + ";" +
                          tt-oc.gatt            + ";" +
                          tt-oc.nec-li          + ";" +
                          tt-oc.nec-inspec      + ";" +
                          tt-oc.antidump        + ";" +
                          tt-oc.observacao      + ";" +
                          tt-oc.dt-orig         + ";" +
                          tt-oc.dt-necessidade  + ";" +
                          tt-oc.dt-entrega      + ";" + 
                          situacao-parcela      + ";" + 
                          tt-oc.cod-emite       + ";" + 
                          tt-oc.nome-abrev      + ";".

        IF  tt-param.l-lista-contatos = YES
        THEN
            ASSIGN c-export = c-export              +
                              tt-oc.nome-contato    + ";" +
                              tt-oc.fone-contato    + ";" +
                              tt-oc.email-contato   + ";".

        IF l-usuar-comprador THEN DO:
            ASSIGN c-export = c-export              +
                              tt-oc.dt-pedido       + ";" +
                              tt-oc.num-pedido      + ";" +
                              tt-oc.numero-ordem    + ";" +
                              tt-oc.vl-custo-it     + ";" +
                              tt-oc.des-moeda       + ";" +
                              tt-oc.parcela         + ";" +
                              tt-oc.situacao        + ";" +
                              tt-oc.cod-estabel     + ";" +
                              tt-oc.cond-pagto      + ";" +

                       /* - em coment rios para libera‡Æo de corre‡Æo simples antes do FFT .... 
                       STRING(tt-oc.cod-libera-fft) + ";" +
                       */

                              tt-oc.cod-comprado    + ";" +   
                              tt-oc.quantidade      + ";" +
                              tt-oc.un              + ";" +
                              tt-oc.qtd-do-forn     + ";" +
                              tt-oc.un-do-forn      + ";" +
                              tt-oc.vl-unit         + ";" +
                              tt-oc.aliq-ipi        + ";" +
                              tt-oc.vl-unit-ipi     + ";" +
                              tt-oc.ipi-incluso     + ";" +
                              tt-oc.qtd-receb       + ";" +
                              tt-oc.qtd-saldo       + ";" +
                              tt-oc.atraso          + ";" +
                              tt-oc.cnpj            + ";" +
                              tt-oc.cod-depos       + ";".

        END.
        ELSE DO:
            ASSIGN c-export = c-export              +
                              tt-oc.dt-pedido       + ";" +
                              tt-oc.num-pedido      + ";" +
                              tt-oc.numero-ordem    + ";" +
                              tt-oc.des-moeda       + ";" +
                              tt-oc.parcela         + ";" +
                              tt-oc.situacao        + ";" +
                              tt-oc.cod-estabel     + ";" +
                              tt-oc.cond-pagto      + ";" +

                       /* - em coment rios para libera‡Æo de corre‡Æo simples antes do FFT .... 
                       STRING(tt-oc.cod-libera-fft) + ";" +
                       */

                              tt-oc.cod-comprado    + ";" +   
                              tt-oc.quantidade      + ";" +
                              tt-oc.un              + ";" +
                              tt-oc.qtd-do-forn     + ";" +
                              tt-oc.un-do-forn      + ";" +
                              tt-oc.qtd-receb       + ";" +
                              tt-oc.qtd-saldo       + ";" +
                              tt-oc.atraso          + ";" +
                              tt-oc.cnpj            + ";" +
                              tt-oc.cod-depos       + ";".
        END.
                          
        IF tt-param.l-oem THEN
            ASSIGN c-export = c-export              + 
                              tt-oc.it-altern       + ";" +
                              tt-oc.saldo-estoq     + ";" +
                              tt-oc.via-transp      + ";" +
                              tt-oc.situacao        + ";".

        IF tt-param.l-importados THEN
            ASSIGN c-export = c-export              + 
                              tt-oc.dt-despacho     + ";" + 
                              tt-oc.dt-embarque     + ";" + 
                              tt-oc.nr-conhecimen   + ";" +
                              tt-oc.embarque        + ";" +
                              tt-oc.des-ult-pto-contr + ";" + 
                              tt-oc.data-ult-pto-contr + ";" + 
                              tt-oc.navio           + ";" +   
                              tt-oc.incortem        + ";" +
                              tt-oc.itiner          + ";" +
                              tt-oc.pto-contr-base  + ";" +
                              tt-oc.peso-bruto      + ";" +
                              tt-oc.peso-liquido    + ";".

        IF tt-param.l-narrativa THEN
            ASSIGN c-export = c-export + tt-oc.narrativa.

        ASSIGN c-export = c-export + 
                          tt-oc.cod-mensagem  + ";" +
                          tt-oc.desc-mensagem + ";" +
                          tt-oc.ct-codigo     + ";" +
                          tt-oc.sc-codigo     + ";" +
                          tt-oc.requisitante  + ";" +
                          tt-oc.nome-requis   + ";" +
                          tt-oc.tipo-pedido   + ";" +
                          tt-oc.nr-nf         + ";".

        ASSIGN c-export = REPLACE(c-export,"&nbsp;":U, "":U).

        ASSIGN c-format = "x(" + STRING(LENGTH(c-export)) + ")".

        

        /* Exportar Dados */
        PUT c-export FORMAT c-format.
        PUT SKIP.
    END.

    RETURN "OK":U.

END PROCEDURE.

